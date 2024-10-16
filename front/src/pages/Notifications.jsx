
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useLocation, useNavigate } from 'react-router-dom';
import DashboardNavbar from '../components/DashboardNavbar';
import styles from '../styles/Notifications.module.css';

const SearchResult = () => {
    const location = useLocation();
    const { user_name } = location.state || {}; // Access user_name passed from the dashboard
    const [user_id, setUserId] = useState(null); // State to store user_id
    const [pendingRequests, setPendingRequests] = useState([]);
    const [acceptedRequests, setAcceptedRequests] = useState([]);
    const [confirmedRequests, setConfirmedRequests] = useState([]);
    const [error, setError] = useState(''); 
    const [message, setMessage] = useState('');
    const navigate = useNavigate();

    // Fetch user_id by user_name when component mounts
    useEffect(() => {
        const fetchUserId = async () => {
            try {
                const response = await axios.get(`http://localhost:8080/auth/user_id/${user_name}`);
                setUserId(response.data); // Assuming response.data returns user_id
            } catch (err) {
                console.error('Error fetching user ID:', err);
                setError('Failed to fetch user ID.');
            }
        };

        if (user_name) {
            fetchUserId();
        }
    }, [user_name]);

    // Fetch pending requests based on user_id
    const fetchPendingRequests = async () => {
        try {
            const response = await axios.get(`http://localhost:8080/auth/pending_requests/${user_id}`);
            setPendingRequests(response.data); 
        } catch (err) {
            setError('Failed to fetch pending requests.');
        }
    };

    // Fetch accepted requests based on user_id
    const fetchAcceptedRequests = async () => {
        try {
            const response = await axios.get(`http://localhost:8080/auth/accepted_requests/${user_id}`);
            setAcceptedRequests(response.data);
        } catch (err) {
            setError('Failed to fetch accepted requests.');
        }
    };

    // Fetch confirmed requests based on user_id
    const fetchConfirmedRequests = async () => {
        try {
            const response = await axios.get(`http://localhost:8080/auth/confirmed_requests/${user_id}`);
            setConfirmedRequests(response.data);
        } catch (err) {
            setError('Failed to fetch confirmed requests.');
        }
    };

    useEffect(() => {
        if (user_id) fetchPendingRequests();
    }, [user_id]);

    useEffect(() => {
        if (user_id) fetchAcceptedRequests();
    }, [user_id]);

    useEffect(() => {
        if (user_id) fetchConfirmedRequests();
    }, [user_id]);

    // Handle Accept request
    const handleAccept = async (requestorId, receiverId, requestorBookId, receiverBookId) => {
        try {
            const payload = {
                requestor_id: requestorId,
                receiver_id: receiverId,
                requestor_book_id: requestorBookId,
                receiver_book_id: receiverBookId,
            };

            const response = await axios.post('http://localhost:8080/auth/acceptrequest', payload, {
                headers: { 'Content-Type': 'application/json' },
            });
            setMessage(response.data.message);
            setError('');

            // Refresh the data after successful action
            fetchPendingRequests();
            fetchAcceptedRequests();

        } catch (err) {
            console.error('Failed to accept request:', err);
            setError('Failed to accept the request.');
            setMessage('');
        }
    };

    // Handle Reject request
    const handleReject = async (requestId) => {
        try {
            const response = await axios.put(`http://localhost:8080/auth/request/reject/${requestId}`);
            setMessage(response.data.message);
            setError('');

            // Refresh the data after successful action
            fetchPendingRequests();
            fetchAcceptedRequests();

        } catch (err) {
            console.error('Failed to reject request:', err);
            setError('Failed to reject the request.');
            setMessage('');
        }
    };

    // Handle Confirm request
    const handleConfirm = async (requestorId, receiverId, requestorBookId, receiverBookId) => {
        try {
            const payload = {
                requestor_id: requestorId,
                receiver_id: receiverId,
                requestor_book_id: requestorBookId,
                receiver_book_id: receiverBookId,
            };

            const response = await axios.post('http://localhost:8080/auth/confirmrequest', payload, {
                headers: { 'Content-Type': 'application/json' },
            });
            setMessage(response.data.message);
            setError('');

            // Refresh the data after successful action
            fetchPendingRequests();
            fetchAcceptedRequests();

        } catch (err) {
            console.error('Failed to confirm request:', err);
            setError('Failed to confirm the request.');
            setMessage('');
        }
    };

    // Handle Cancel request
    const handleCancel = async (requestId) => {
        try {
            const response = await axios.put(`http://localhost:8080/auth/cancel/${requestId}`); // Update the endpoint as needed
            setMessage(response.data.message);
            setError('');

            // Refresh the data after successful action
            fetchAcceptedRequests();

        } catch (err) {
            console.error('Failed to cancel request:', err);
            setError('Failed to cancel the request.');
            setMessage('');
        }
    };

    return (
        <div className={styles.container}>
  {/* User Details Sidebar */}
  <div className={styles.sidebar}>
            
                <img className={styles.profilePic} src={require('../styles/2.png')} alt="Profile" />
                <h2 className={styles.sidebarTitle}>{user_name}</h2>
                <p className={styles.sidebarDescription}>Details about the user</p>
            
   
  </div>

  {/* Notifications Section */}
  <div className={styles.content}>
  <DashboardNavbar />
    <h2>{user_name}'s Search Results</h2>
    {error && <p style={{ color: 'red' }}>{error}</p>}
    {message && <p style={{ color: 'green' }}>{message}</p>}

    {/* Pending Requests */}
    <h3>Pending Requests</h3>
    <ul className={styles.notificationList}>
      {pendingRequests.length > 0 ? (
        pendingRequests.map((request, index) => (
          <li key={index}>
            <div className={styles.info}>
              Request from: {request.requestor_id} <br />
              Requestor Book ID: {request.requestor_book_id} <br />
              Your Book ID: {request.receiver_book_id} <br />
              Requestor Book Title: {request.requestor_book_title} <br />
              Requestor Book Author: {request.requestor_book_author} <br />
              Receiver Book Title: {request.receiver_book_title} <br />
              Receiver Book Author: {request.receiver_book_author}
            </div>
            <button
              onClick={() => handleAccept(
                request.requestor_id,
                user_id,
                request.requestor_book_id,
                request.receiver_book_id
              )}
            >
              Accept
            </button>
            <button className={styles.rejectButton} onClick={() => handleReject(request.request_id)}>
              Reject
            </button>
          </li>
        ))
      ) : (
        <li>No pending requests.</li>
      )}
    </ul>

    {/* Accepted Requests */}
    <h3>Accepted Requests</h3>
    <ul className={styles.notificationList}>
      {acceptedRequests.length > 0 ? (
        acceptedRequests.map((request, index) => (
          <li key={index}>
            <div className={styles.info}>
            Request from: {request.requestor_id} <br />
              Requestor Book ID: {request.requestor_book_id} <br />
              Your Book ID: {request.receiver_book_id} <br />
              Requestor Book Title: {request.requestor_book_title} <br />
              Requestor Book Author: {request.requestor_book_author} <br />
              Receiver Book Title: {request.receiver_book_title} <br />
              Receiver Book Author: {request.receiver_book_author}
            </div>
            <button
              onClick={() => handleConfirm(
                user_id,
                request.receiver_id,
                request.requestor_book_id,
                request.receiver_book_id
              )}
            >
              Confirm
            </button>
            <button className={styles.cancelButton} onClick={() => handleCancel(request.request_id)}>
              Cancel
            </button>
          </li>
        ))
      ) : (
        <li>No accepted requests.</li>
      )}
    </ul>

    {/* Confirmed Requests */}
    <h3>Confirmed Requests</h3>
    <ul className={styles.notificationList}>
      {confirmedRequests.length > 0 ? (
        confirmedRequests.map((request, index) => (
          <li key={index}>
            <div className={styles.info}>
              Requestor Name: {request.requestor_user_name} <br />
              Receive Name: {request.receiver_user_name} <br />
              Requestor Book ID: {request.requestor_book_id} <br />
              Receiver Book ID: {request.receiver_book_id} <br />
              Requestor Book Title: {request.requestor_book_title} <br />
              Requestor Book Author: {request.requestor_book_author} <br />
              Receiver Book Title: {request.receiver_book_title} <br />
              Receiver Book Author: {request.receiver_book_author}
              request_date: {request.request_date} <br />
              requestor_phone_number: {request.requestor_phone_number} <br />
              receiver_phone_number: {request.receiver_phone_number}
            </div>
          </li>
        ))
      ) : (
        <li>No confirmed requests.</li>
      )}
    </ul>
  </div>
</div>

    );
};

export default SearchResult;
