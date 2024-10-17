import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import styles from '../styles/Wishlistitem.module.css'; // Import the new CSS module
import DashboardNavbar from '../components/DashboardNavbar'; // Import your dashboard navbar

const WishlistItem = () => {
    const location = useLocation();
    const { user_name, title, author, book_id, user_id: requestorId } = location.state || {};
    const [matchingUsers, setMatchingUsers] = useState([]);
    const [error, setError] = useState('');
    const navigate = useNavigate();

    useEffect(() => {
        const fetchMatchingUsers = async () => {
            try {
                const payload = {
                    currentUserId: requestorId,
                    selectedBookId: book_id
                };
                
                const response = await axios.post('http://localhost:8080/auth/matchingUsers', payload, {
                    headers: {
                        'Content-Type': 'application/json',
                    },
                });

                setMatchingUsers(response.data);
            } catch (error) {
                console.error('Error fetching matching users:', error);
                setError('Failed to fetch matching users.');
            }
        };

        if (requestorId && book_id) {
            fetchMatchingUsers();
        }
    }, [requestorId, book_id]);

    const requestBook = async (receiverId, receiver_book_id) => {
        const payload = {
            requestor_id: requestorId,
            receiver_id: receiverId,
            requestor_book_id: book_id,
            receiver_book_id: receiver_book_id
        };

        try {
            const response = await axios.post('http://localhost:8080/auth/makerequest', payload, {
                headers: {
                    'Content-Type': 'application/json',
                },
            });

            alert(response.data.message);
        } catch (error) {
            console.error('Error requesting book:', error);
            setError('Failed to request the book.');
        }
    };

    return (
        <div className={styles.container}>
            <div className={styles.sidebar}>
                <img className={styles.profilePic} src={require('../styles/2.png')} alt="Profile" />
                <h2 className={styles.sidebarTitle}>{user_name}</h2>
                <p className={styles.sidebarDescription}>Details about the user</p>
            </div>
            <div className={styles.mainContent}>
                <DashboardNavbar />
                <h2>{user_name}'s Wishlist Item</h2>
                <h2>{requestorId}</h2>
                <h3>Book Details</h3>
                <p><strong>Title:</strong> {title}</p>
                <p><strong>Author:</strong> {author}</p>
                <p><strong>Book ID:</strong> {book_id}</p>
                
                <button onClick={() => navigate('/wishlist', { state: { user_name } })}>
                    Back to Wishlist
                </button>
                <button onClick={() => navigate('/dashboard', { state: { user_name } })}>
                    Back to Dashboard
                </button>

                <h3>Matching Users for Exchange</h3>
                {error && <p className={styles.error}>{error}</p>}
                {matchingUsers.length > 0 ? (
                    <ul>
                        {matchingUsers.map((user, index) => (
                            <li key={index}>
                                <strong>User Name:</strong> {user.user_name} - 
                                <strong> City:</strong> {user.city} - 
                                <strong> District:</strong> {user.district}
                                <strong> Book Owner ID:</strong> {user.user_id}
                                <strong> wishlist_book_id:</strong> {user.wishlist_book_id}
                                <strong> title:</strong> {user.title}
                                <strong> author:</strong> {user.author}
                                <button onClick={() => requestBook(user.user_id , user.wishlist_book_id)}>Request This Book</button>
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>No matching users found for exchange.</p>
                )}
            </div>
        </div>
    );
};

export default WishlistItem;