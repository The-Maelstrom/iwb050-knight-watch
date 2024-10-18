import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import styles from '../styles/Wishlistitem.module.css'; // Import the new CSS module
import DashboardNavbar from '../components/DashboardNavbar'; // Import your dashboard navbar
import Navbar from '../components/Navbar'; 

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
                <h2 className={styles.sidebarTitle}>Welcome {user_name}!</h2>
                <h2 className={styles.libraryTitle}>"See Who's Interested in Your Books"</h2>
                <p className={styles.sidebarDescription}>You can exchange your book with other users who are interested in similar books! 
            Here, you'll find a list of users who have matching book preferences.
            Simply review the details, and if you find someone with a book you're interested in, 
            you can send them a book exchange request.</p>
            </div>
            <div className={styles.mainContent}>
                    <Navbar />
                    <DashboardNavbar />
                    <h3 className={styles.sectionTitle}>Your Book:-</h3>
                    <div className={styles.bookDetails}>
                        <p><strong>Title:</strong> {title}</p>
                         <p><strong>Author:</strong> {author}</p>
                    </div>

                
                
               
                

                <h3 className={styles.sectionTitle}>Matching Users for Exchange</h3>
                {error && <p className={styles.error}>{error}</p>}
                {matchingUsers.length > 0 ? (
                    <ul className={styles.notificationList}>
                        {matchingUsers.map((user, index) => (
                            <li key={index} className={styles.notificationItem}>
 <div className={styles.notificationDetails}>
        <div className={styles.notificationText}>
          <strong>Book Title:</strong> {user.title}
        </div>
        <div className={styles.notificationText}>
          <strong>Author:</strong> {user.author}
        </div>
        <div className={styles.notificationText}>
          <strong>User Name:</strong> {user.user_name}
        </div>
        <div className={styles.notificationText}>
          <strong>City:</strong> {user.city}
        </div>
        <div className={styles.notificationText}>
          <strong>District:</strong> {user.district}
        </div>
      </div>
                               
                                <button className={styles.notificationButton} onClick={() => requestBook(user.user_id , user.wishlist_book_id)}>Request This Book</button>
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>No matching users found for exchange.</p>
                )}

<button  className={styles.button} onClick={() => navigate('/wishlist', { state: { user_name } })}>
                    Back to Wishlist
                </button>
            </div>
        </div>
    );
};

export default WishlistItem;