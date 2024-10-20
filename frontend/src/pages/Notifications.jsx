
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { useLocation, useNavigate } from 'react-router-dom';
import DashboardNavbar from '../components/DashboardNavbar';
import styles from '../styles/Notifications.module.css';
import Navbar from '../components/Navbar'; 

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
            const response = await axios.get(`http://localhost:8081/request/pending_requests/${user_id}`);
            setPendingRequests(response.data); 
        } catch (err) {
            setError('Failed to fetch pending requests.');
        }
    };

    // Fetch accepted requests based on user_id
    const fetchAcceptedRequests = async () => {
        try {
            const response = await axios.get(`http://localhost:8081/request/accepted_requests/${user_id}`);
            setAcceptedRequests(response.data);
        } catch (err) {
            setError('Failed to fetch accepted requests.');
        }
    };

    // Fetch confirmed requests based on user_id
    const fetchConfirmedRequests = async () => {
        try {
            const response = await axios.get(`http://localhost:8081/request/confirmed_requests/${user_id}`);
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

            const response = await axios.post('http://localhost:8081/request/acceptrequest', payload, {
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
    const handleReject = async (requestorId, receiverId, requestorBookId, receiverBookId) => {
        try {
            const payload = {
                requestor_id: requestorId,
                receiver_id: receiverId,
                requestor_book_id: requestorBookId,
                receiver_book_id: receiverBookId,
            };

            console.log('Sending payload:', payload);

            const response = await axios.post('http://localhost:8081/request/rejectrequest', payload, {
                headers: { 'Content-Type': 'application/json' },
            });

            console.log('Response received:', response.data);

            setPendingRequests(pendingRequests.filter((request) => request.request_id !== requestorId));
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

            const response = await axios.post('http://localhost:8081/request/confirmrequest', payload, {
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

   // Handle Confirm request
   const handleCancel = async (requestorId, receiverId, requestorBookId, receiverBookId) => {
    try {
        const payload = {
            requestor_id: requestorId,
            receiver_id: receiverId,
            requestor_book_id: requestorBookId,
            receiver_book_id: receiverBookId,
        };

        const response = await axios.post('http://localhost:8081/request/cancelrequest', payload, {
            headers: { 'Content-Type': 'application/json' },
        });
        setMessage(response.data.message);
        setError('');

        // Refresh the data after successful action
        fetchPendingRequests();
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
                <img className={styles.profilePic} src={require('../asset/2.png')} alt="Profile" />
                <h2 className={styles.sidebarTitle}>Welcome {user_name}!</h2>
                <h2 className={styles.libraryTitle}>To your Notifications</h2>
                <p className={styles.sidebarDescription}>Hello, {user_name}! This section helps you manage all your exchange requests. You can view pending, accepted, and confirmed requests here. Stay updated and ensure smooth exchanges with other users. </p>
          </div>

  {/* Notifications Section */}
  <div className={styles.content}>
  <Navbar />
  <DashboardNavbar />
  
    {error && <p style={{ color: 'red' }}>{error}</p>}
    {message && <p style={{ color: 'green' }}>{message}</p>}

    {/* Pending Requests */}
<h3 className={styles.sectionTitle}>Pending Requests</h3>
<ul className={styles.notificationList}>
    {pendingRequests.length > 0 ? (
        pendingRequests.map((request, index) => (
            <li key={index} className={styles.notificationItem}>
                <div className={styles.info}>
                    Request from: {request.requestor_user_name} <br />
                    Request to: {request.receiver_user_name} <br />
                    Requestor Book Title: {request.requestor_book_title} <br />
                    Receiver Book Title: {request.receiver_book_title} <br />
                </div>
                <div className={styles.actionButtons}>
                    <button
                        onClick={() => handleAccept(
                            request.requestor_id,
                            user_id,
                            request.requestor_book_id,
                            request.receiver_book_id
                        )}
                        className={styles.acceptButton}
                    >
                        Accept
                    </button>
                    <button
                        onClick={() => handleReject(request.requestor_id,
                            user_id,
                            request.requestor_book_id,
                            request.receiver_book_id)}
                        className={styles.rejectButton}
                    >
                        Reject
                    </button>
                </div>
            </li>
        ))
    ) : (
        <li>No pending requests.</li>
    )}
</ul>

{/* Accepted Requests */}
<h3 className={styles.sectionTitle}>Accepted Requests</h3>
<ul className={styles.notificationList}>
    {acceptedRequests.length > 0 ? (
        acceptedRequests.map((request, index) => (
            <li key={index} className={styles.notificationItem}>
                <div className={styles.info}>
                    Request from: {request.requestor_user_name} <br />
                    Request to: {request.receiver_user_name} <br />
                    Requestor Book Title: {request.requestor_book_title} <br />
                    Receiver Book Title: {request.receiver_book_title} <br />
                </div>
                <div className={styles.actionButtons}>
                    <button
                        onClick={() => handleConfirm(
                            user_id,
                            request.receiver_id,
                            request.requestor_book_id,
                            request.receiver_book_id
                        )}
                        className={styles.confirmButton}
                    >
                        Confirm
                    </button>
                    <button
                        onClick={() => handleCancel(request.request_id)}
                        className={styles.cancelButton}
                    >
                        Cancel
                    </button>
                </div>
            </li>
        ))
    ) : (
        <li>No accepted requests.</li>
    )}
</ul>

{/* Confirmed Requests */}
<h3 className={styles.sectionTitle}>Confirmed Requests</h3>
<ul className={styles.notificationList}>
    {confirmedRequests.length > 0 ? (
        confirmedRequests.map((request, index) => (
            <li key={index} className={styles.notificationItem}>
                <div className={styles.info}>
                    Requestor Name: {request.requestor_user_name} <br />
                    Receiver Name: {request.receiver_user_name} <br />
                    Requestor Book Title: {request.requestor_book_title} <br />
                    Receiver Book Title: {request.receiver_book_title} <br />
                    Request Date: {request.request_date} <br />
                    Requestor Phone: {request.requestor_phone_number} <br />
                    Receiver Phone: {request.receiver_phone_number}
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
