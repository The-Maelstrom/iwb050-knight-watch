import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import axios from 'axios';
import DashboardNavbar from '../components/DashboardNavbar';
import styles from '../styles/Wishlist.module.css'; // Importing CSS module
import Navbar from '../components/Navbar'; 

const Wishlist = () => {
    const location = useLocation();
    const { user_name } = location.state || {}; 
    const [wishlistItems, setWishlistItems] = useState([]);
    const [title, setTitle] = useState('');
    const [author, setAuthor] = useState('');
    const [user_id, setUserId] = useState(null); 
    const [error, setError] = useState(''); 
    const [message, setMessage] = useState('');
    const [profilePicUrl, setProfilePicUrl] = useState(''); // Adding state for profile picture
    const navigate = useNavigate();
    
    // Fetch user_id based on user_name
    useEffect(() => {
        const fetchUserId = async () => {
            try {
                const response = await axios.get(`http://localhost:8080/auth/user_id/${user_name}`);
                setUserId(response.data);
            } catch (err) {
                console.error('Error fetching user ID:', err);
                setError('Failed to fetch user ID.'); 
            }
        };
        if (user_name) fetchUserId();
    }, [user_name]);

    // Fetch wishlist items based on user_id
    useEffect(() => {   
        const fetchWishlistItems = async () => {
            try {
                const response = await axios.get(`http://localhost:8082/book/wishlist_item/${user_id}`);
                setWishlistItems(response.data);  
            } catch (error) {
                console.error("Error fetching wishlist items:", error);
                setError("Failed to fetch wishlist items."); 
            }
        };
        if (user_id) fetchWishlistItems();
    }, [user_id]);

    // Example to fetch profile picture (if applicable)
    useEffect(() => {
        // Set a default profile picture or fetch it from the server
        // Replace this with actual logic for fetching the profile pic
        setProfilePicUrl('./2.png'); // Default or fetched profile picture URL
    }, []);

    // Add a new book to the wishlist
    const addBookToWishlist = async (e) => {
        e.preventDefault(); // Prevent form submission
        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }
    
        const payload = { action: 'add', user_id, title, author };
    
        try {
            const response = await axios.post('http://localhost:8082/book/ManageWishlistItem', payload, {
                headers: { 'Content-Type': 'application/json' },
            });
            setMessage(response.data.message);
            setError('');
            setTitle('');
            setAuthor('');
            setWishlistItems([...wishlistItems, { title, author }]); // Update wishlist locally
        } catch (error) {
            console.error('Error adding book:', error);
            setError('Failed to add book.');
            setMessage('');
        }
    };

    // Remove a book from the wishlist
    const removeBookFromWishlist = async (title, author) => {
        const payload = { action: 'remove', user_id, title, author };
        try {
            const response = await axios.post('http://localhost:8082/book/ManageWishlistItem', payload, {
                headers: { 'Content-Type': 'application/json' },
            });
            setMessage(response.data.message);
            setError('');
            setWishlistItems(wishlistItems.filter(item => item.title !== title || item.author !== author)); 
        } catch (error) {
            console.error('Error removing book:', error);
            setError('Failed to remove book.');
            setMessage('');
        }
    };

    const goToWishlistItem = (item) => {
        navigate('/wishlistitem', {
            state: {
                user_name,
                user_id,
                title: item.title,
                author: item.author,
                book_id: item.book_id
            }
        });
    };

    return (
        <div className={styles['wishlist-page']}>
            <div className={styles['sidebar']}>
                {/* Profile Picture */}
                {profilePicUrl ? (
                    <img
                        src={require('../asset/2.png')} // The profile picture URL
                        alt={`${user_name}'s profile`}
                        className={styles['profile-pic']} // CSS class for profile image
                    />
                ) : (
                    <div className={styles['profile-placeholder']}>
                        {/* Placeholder if no profile pic is available */}
                        <span>No Image</span>
                    </div>
                )}
                    <h2 className={styles.sidebarTitle}>
                        Welcome {user_name}!
                    </h2>

                    <h2 className={styles.libraryTitle}>To your Wishlist</h2>
                    
                    <p className={styles.sidebarDescription}>
                        Welcome, {user_name}!  This is your wishlist! Here, you can view and manage the books you want to read. 
                        Add books you wish to have or remove those you no longer want.
                    </p>
            </div>
            
            <div className={styles['main-content']}>
            <Navbar/>
                <DashboardNavbar />
                <div className={styles['wishlist-container']}>
                
                    

                    <h3 className={styles.pagedescription}>Add a New Book to Your Wishlist</h3>
                    <form onSubmit={addBookToWishlist} className={styles['add-book-form']}>
                        <input
                            type="text"
                            placeholder="Title"
                            value={title}
                            onChange={(e) => setTitle(e.target.value)}
                            required
                        />
                        <input
                            type="text"
                            placeholder="Author"
                            value={author}
                            onChange={(e) => setAuthor(e.target.value)}
                            required
                        />
                        <button type="submit">Add to Wishlist</button>
                    </form>

                    <h3 className={styles.WishlistItems}>Your Wishlist Items</h3>
                            <ul className={styles.bookList}>
                                {wishlistItems.length > 0 ? (
                                        wishlistItems.map((item, index) => (
                            <li key={index} className={styles.bookListItem}>
                                <div className={styles.wishlistItemDetails}>
                                    <span className={styles.bookID}>Book ID: {item.book_id}</span>
                                    <span className={styles.bookTitle}>Title: {item.title}</span>
                                    <span className={styles.bookAuthor}>Author: {item.author}</span>
                                </div>
                                <div className={styles.wishlistItemActions}>
                                    <button onClick={() => goToWishlistItem(item)} className={styles.viewButton}>
                                        View Details
                                    </button>
                                    <button onClick={() => removeBookFromWishlist(item.title, item.author)} className={styles.removeButton}>
                                        Remove
                                    </button>
                                </div>
                            </li>
                             ))
                                ) : (
                            <li>No items in your wishlist yet.</li>
                                )}
                            </ul>

                            </div>
                                    {error && <p className={styles['error']}>{error}</p>}
                                    {message && <p className={styles['message']}>{message}</p>} 
                        </div>
                        
                    </div>
    );
};

export default Wishlist;
