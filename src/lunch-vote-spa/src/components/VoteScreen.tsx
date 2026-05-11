import { useState, useEffect, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ActivePoll, PollResults } from '../types';
import { getActivePoll, submitVote, getPollResults, ApiRequestError } from '../services/api';
import { getOrCreateVoterToken } from '../services/voterToken';
import { LoadingSpinner } from './LoadingSpinner';
import { ErrorMessage } from './ErrorMessage';
import { OptionCard } from './OptionCard';
import { ResultBar } from './ResultBar';
import './VoteScreen.css';

/**
 * Vote screen component - displays active poll for a group and allows voting.
 */
export function VoteScreen() {
  const { groupId } = useParams<{ groupId: string }>();
  const navigate = useNavigate();
  
  const [poll, setPoll] = useState<ActivePoll | null>(null);
  const [selectedOptionId, setSelectedOptionId] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasVoted, setHasVoted] = useState(false);
  const [alreadyVoted, setAlreadyVoted] = useState(false);
  const [votedOptionId, setVotedOptionId] = useState<string | null>(null);
  const [results, setResults] = useState<PollResults | null>(null);

  const fetchPoll = useCallback(async () => {
    if (!groupId) {
      setError('No group ID provided.');
      setIsLoading(false);
      return;
    }

    try {
      setIsLoading(true);
      setError(null);
      const activePoll = await getActivePoll(groupId);
      setPoll(activePoll);
    } catch (err) {
      if (err instanceof ApiRequestError) {
        if (err.statusCode === 404) {
          // No active poll found - redirect to create poll screen
          navigate(`/group/${groupId}/create`);
          return;
        } else {
          setError(err.message);
        }
      } else {
        setError('Failed to load poll. Please try again.');
      }
    } finally {
      setIsLoading(false);
    }
  }, [groupId]);

  useEffect(() => {
    fetchPoll();
  }, [fetchPoll]);

  const handleVote = async () => {
    if (!poll || !selectedOptionId) return;

    try {
      setIsSubmitting(true);
      setError(null);
      
      const voterToken = getOrCreateVoterToken();
      
      await submitVote({
        pollId: poll.pollId,
        optionId: selectedOptionId,
        voterToken,
      });
      
      setVotedOptionId(selectedOptionId);
      setHasVoted(true);
      
      // Fetch results after voting
      const pollResults = await getPollResults(poll.pollId);
      setResults(pollResults);
    } catch (err) {
      if (err instanceof ApiRequestError) {
        if (err.error === 'AlreadyVoted') {
          setAlreadyVoted(true);
          // Fetch results to show what they voted for
          if (poll) {
            try {
              const pollResults = await getPollResults(poll.pollId);
              setResults(pollResults);
            } catch {
              // Ignore error fetching results
            }
          }
        } else {
          setError(err.message);
        }
      } else {
        setError('Failed to submit vote. Please try again.');
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="vote-screen">
        <LoadingSpinner message="Loading poll..." />
      </div>
    );
  }

  if (error) {
    return (
      <div className="vote-screen">
        <ErrorMessage message={error} onRetry={fetchPoll} />
      </div>
    );
  }

  if (!poll) {
    return (
      <div className="vote-screen">
        <ErrorMessage message="No poll available." />
      </div>
    );
  }

  if (hasVoted || alreadyVoted) {
    const getWinnerIds = (): string[] => {
      if (!results || results.totalVotes === 0) return [];
      
      const maxCount = Math.max(...results.results.map(r => r.count));
      return results.results
        .filter(r => r.count === maxCount)
        .map(r => r.optionId);
    };

    const winnerIds = getWinnerIds();

    return (
      <div className="vote-screen">
        <div className="vote-card">
          <button onClick={() => navigate('/')} className="home-button" title="Go to Home">
            🏠 Home
          </button>
          <div className="group-badge">{poll?.groupId}</div>
          
          <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
            <div className="success-icon" style={{ fontSize: '3rem', marginBottom: '1rem' }}>
              {hasVoted ? '🎉' : '✅'}
            </div>
            <h2 style={{ fontSize: '1.5rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              {hasVoted ? 'Thank you for voting!' : 'You have already voted'}
            </h2>
            <p style={{ color: '#666', fontSize: '0.95rem' }}>
              You can only vote once per poll from this device.
            </p>
          </div>

          <h1 className="poll-question">{poll?.question}</h1>
          
          {results && (
            <>
              <div style={{ marginBottom: '1.5rem' }}>
                <p style={{ fontSize: '0.9rem', color: '#666', textAlign: 'center' }}>
                  Total votes: {results.totalVotes}
                </p>
              </div>
              
              <div className="options-list">
                {results.results.map((result) => {
                  const isWinner = winnerIds.includes(result.optionId);
                  const isUserVote = result.optionId === votedOptionId;
                  const percentage = results.totalVotes > 0 
                    ? Math.round((result.count / results.totalVotes) * 100) 
                    : 0;
                  
                  return (
                    <ResultBar
                      key={result.optionId}
                      text={result.text}
                      count={result.count}
                      percentage={percentage}
                      isWinner={isWinner}
                      highlight={isUserVote}
                    />
                  );
                })}
              </div>

              {votedOptionId && (
                <p style={{ textAlign: 'center', marginTop: '1rem', color: '#0969da', fontWeight: '500' }}>
                  ✓ Your vote: {results.results.find(r => r.optionId === votedOptionId)?.text}
                </p>
              )}
            </>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className="vote-screen">
      <div className="vote-card">
        <button onClick={() => navigate('/')} className="home-button" title="Go to Home">
          🏠 Home
        </button>
        <div className="group-badge">{poll.groupId}</div>
        <h1 className="poll-question">{poll.question}</h1>
        
        <div className="options-list">
          {poll.options.map((option) => (
            <OptionCard
              key={option.optionId}
              option={option}
              isSelected={selectedOptionId === option.optionId}
              onSelect={setSelectedOptionId}
              disabled={isSubmitting}
            />
          ))}
        </div>
        
        <button
          className="submit-button"
          onClick={handleVote}
          disabled={!selectedOptionId || isSubmitting}
        >
          {isSubmitting ? 'Submitting...' : 'Submit Vote'}
        </button>
      </div>
    </div>
  );
}

