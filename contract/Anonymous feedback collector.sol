// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title AnonymousFeedbackCollector
 * @dev A smart contract that allows users to submit anonymous feedback
 */
contract AnonymousFeedbackCollector {
    // Structure to store feedback
    struct Feedback {
        string message;
        uint256 timestamp;
        bool isEncrypted;
    }

    // Mapping to store feedback by an ID
    mapping(uint256 => Feedback) private feedbacks;
    
    // Total number of feedback submissions
    uint256 private feedbackCount;
    
    // Event emitted when new feedback is submitted
    event FeedbackSubmitted(uint256 indexed feedbackId, uint256 timestamp);
    
    /**
     * @dev Submit anonymous feedback
     * @param _message The feedback message
     * @param _isEncrypted Whether the message is encrypted by the user
     * @return feedbackId The ID of the submitted feedback
     */
    function submitFeedback(string memory _message, bool _isEncrypted) public returns (uint256) {
        uint256 feedbackId = feedbackCount + 1;
        
        feedbacks[feedbackId] = Feedback({
            message: _message,
            timestamp: block.timestamp,
            isEncrypted: _isEncrypted
        });
        
        feedbackCount = feedbackId;
        
        emit FeedbackSubmitted(feedbackId, block.timestamp);
        
        return feedbackId;
    }
    
    /**
     * @dev Retrieve feedback by ID (only contract owner should be able to call this in production)
     * @param _feedbackId The ID of the feedback to retrieve
     * @return message The feedback message
     * @return timestamp When the feedback was submitted
     * @return isEncrypted Whether the message is encrypted
     */
    function getFeedback(uint256 _feedbackId) public view returns (
        string memory message,
        uint256 timestamp,
        bool isEncrypted
    ) {
        require(_feedbackId > 0 && _feedbackId <= feedbackCount, "Invalid feedback ID");
        
        Feedback memory feedback = feedbacks[_feedbackId];
        
        return (
            feedback.message,
            feedback.timestamp,
            feedback.isEncrypted
        );
    }
    
    /**
     * @dev Get the total count of feedback submissions
     * @return The total number of feedback submissions
     */
    function getFeedbackCount() public view returns (uint256) {
        return feedbackCount;
    }

