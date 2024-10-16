import React, { useState, useEffect, useCallback } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios';
import DashboardNavbar from '../components/DashboardNavbar';
import styles from '../styles/AddBooks.module.css'; // Importing the CSS module

const AddBooks = () => {
    const location = useLocation();
    const { user_name } = location.state || {}; // Access user_name passed from the dashboard

    const [user_id, setUserId] = useState(null); // State to store user_id
    const [book, setBook] = useState({ title: '', author: '', edition: '' }); // State for a single book
    const [message, setMessage] = useState(''); // To store response message
    const [error, setError] = useState(''); // To store error message
    const [books, setBooks] = useState([]); // State to store user's books

    // Fetch user ID based on user_name when component mounts
    useEffect(() => {
        const fetchUserId = async () => {
            try {
                const response = await axios.get(`http://localhost:8080/auth/user_id/${user_name}`);
                setUserId(response.data); // Assuming response.data returns user_id
            } catch (err) {
                console.error('Error fetching user ID:', err);
                setError('Failed to fetch user ID.'); // Show error message
            }
        };

        if (user_name) {
            fetchUserId();
        }
    }, [user_name]);

    // Memoize fetchBooks using useCallback to prevent it from being recreated on every render
    const fetchBooks = useCallback(async () => {
        if (user_id) {
            try {
                const response = await axios.get(`http://localhost:8080/auth/books_for_specific_user/${user_id}`);
                setBooks(response.data); // Assuming response.data returns the array of books
            } catch (err) {
                console.error('Error fetching books:', err);
                setError('Failed to fetch books.'); // Show error message
            }
        }
    }, [user_id]);

    useEffect(() => {
        fetchBooks(); // Fetch books when user_id changes
    }, [user_id, fetchBooks]);

    // Handle input change
    const handleInputChange = (field, value) => {
        setBook({ ...book, [field]: value });
    };

    // Handle adding a book by sending details to the backend
    const addBook = async () => {
        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }

        const payload = {
            user_id: user_id, // Ensure this is an integer
            action: 'add',
            title: book.title,
            author: book.author
        };

        try {
            const response = await axios.post('http://localhost:8080/auth/managebooks', payload, {
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            setMessage(response.data.message);
            setError('');
            setBook({ title: '', author: ''}); // Clear the form
            await fetchBooks(); // Refetch books after adding a new one
        } catch (error) {
            console.error('Error adding book:', error);
            setError('Failed to add book.');
            setMessage('');
        }
    };

    // Handle removing a book
    const removeBook = async (title, author, edition) => {
        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }

        const payload = {
            user_id: user_id, // Ensure this is an integer
            action: 'remove',
            title: title,
            author: author
        };
        try {
            const response = await axios.post('http://localhost:8080/auth/managebooks', payload, {
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            setMessage(response.data.message);
            setError('');
            await fetchBooks(); // Refetch books after removing one
        } catch (error) {
            console.error('Error removing book:', error);
            setError('Failed to remove book.');
        }
    };

    return (
        <div className={styles.wishlistPage}>
            <div className={styles.sidebar}>
                <img className={styles.profilePic} src={require('../styles/2.png')} alt="Profile" />
                <h2 className={styles.sidebarTitle}>{user_name}</h2>
                <p className={styles.sidebarDescription}>Details about the user</p>
            </div>
            <div className={styles.mainContent}>
                <DashboardNavbar />
                <h2>{user_name}'s Library</h2>
                {message && <p className={styles.message}>{message}</p>}
                {error && <p className={styles.error}>{error}</p>}

                <div className={styles.wishlistContainer}>
                    <h3>Add a New Book to Your Library</h3>
                    <form onSubmit={(e) => { e.preventDefault(); addBook(); }} className={styles.addBookForm}>
                        <input
                            type="text"
                            placeholder="Title"
                            value={book.title}
                            onChange={(e) => handleInputChange('title', e.target.value)}
                            required
                        />
                        <input
                            type="text"
                            placeholder="Author"
                            value={book.author}
                            onChange={(e) => handleInputChange('author', e.target.value)}
                            required
                        />
                        <button type="submit" className={styles.addBookButton}>Add to Library</button>
                    </form>

                    <h3>Your Books</h3>
                    {books.length === 0 ? (
                        <p>No books found.</p>
                    ) : (
                        <ul className={styles.bookList}>
                            {books.map((b) => (
                                <li key={b.book_id} className={styles.bookListItem}>
                                    Title: {b.title}   Author: {b.author}
                                    <button onClick={() => removeBook(b.title, b.author, b.edition)} className={styles.removeButton}>
                                        Remove
                                    </button>
                                </li>
                            ))}
                        </ul>
                    )}
                </div>
            </div>
        </div>
    );
};

export default AddBooks;
