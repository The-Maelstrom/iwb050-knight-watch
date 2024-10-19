import React, { useState, useEffect, useCallback } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios';
import DashboardNavbar from '../components/DashboardNavbar';
import styles from '../styles/AddBooks.module.css'; // Importing the CSS module

const AddBooks = () => {
    const location = useLocation();
    const { user_name } = location.state || {}; // Access user_name passed from the dashboard

    const [user_id, setUserId] = useState(null); // State to store user_id
    const [book, setBook] = useState({ title: '', author: '', edition: '' , image_path: ''}); // State for a single book
    const [message, setMessage] = useState(''); // To store response message
    const [error, setError] = useState(''); // To store error message
    const [books, setBooks] = useState([]); // State to store user's books

    const [selectedImage, setSelectedImage] = useState(null); // State for the selected image file
    const [imagePreview, setImagePreview] = useState(null); // State for image preview URL

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

    // Handle input change for book details
    const handleInputChange = (field, value) => {
        setBook({ ...book, [field]: value });
    };

    // Handle image file selection
    const handleImageChange = (e) => {
        if (e.target.files && e.target.files[0]) {
            const file = e.target.files[0];
            setSelectedImage(file);
            setImagePreview(URL.createObjectURL(file)); // Create a local URL for image preview
        }
    };

    // Handle adding a book by sending details to the backend
    const addBook = async (e) => {
        e.preventDefault(); // Prevent the default form submission behavior

        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }

        // Validate form fields
        if (!book.title || !book.author || !book.edition || !user_name) {
            setError('Please fill in all required fields.');
            return;
        }

        try {
            // Create a FormData object to handle file upload
            const formData = new FormData();
            formData.append('user_id', user_id); // Ensure this is an integer
            formData.append('title', book.title);
            formData.append('author', book.author);
            formData.append('edition', book.edition);
            formData.append('username', user_name); // Including username as per backend's image handling

            if (selectedImage) {
                formData.append('image', selectedImage); // Append the image file if selected
            }

            // Send a POST request to the backend with the form data
            const response = await axios.post('http://localhost:8080/auth/addbooks', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data', // Important for file uploads
                },
            });

            setMessage(response.data.message);
            setError('');
            setBook({ title: '', author: '', edition: '' }); // Clear the form
            setSelectedImage(null); // Clear selected image
            setImagePreview(null); // Clear image preview
            await fetchBooks(); // Refetch books after adding a new one
        } catch (error) {
            console.error('Error adding book:', error);
            setError('Failed to add book.');
            setMessage('');
        }
    };



    // Handle removing a book
    const removeBook = async (book) => {
        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }

        
        // Destructure the book object passed as a parameter
        const { title, author, edition } = book;

        const payload = {
            user_id: user_id, // Ensure this is an integer
            title: title,
            author: author,
            edition: edition,
            username: user_name, // Including username to locate the image file
        };
        
        try {
            const response = await axios.post('http://localhost:8080/auth/removebooks', payload, {
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
            setMessage('');
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
                    <form onSubmit={addBook} className={styles.addBookForm}>
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
                        <input
                            type="text"
                            placeholder="Edition"
                            value={book.edition}
                            onChange={(e) => handleInputChange('edition', e.target.value)}
                            required
                        />

                        {/* Image Upload Field */}
                        <div className={styles.formGroup}>
                            <label htmlFor="image">Book Image:</label>
                            <input
                                type="file"
                                id="image"
                                accept="image/*"
                                onChange={handleImageChange}
                            />
                        </div>

                        {/* Image Preview */}
                        {imagePreview && (
                            <div className={styles.imagePreview}>
                                <h4>Image Preview:</h4>
                                <img src={imagePreview} alt="Selected Book" className={styles.bookImage} />
                            </div>
                        )}

                        <button type="submit" className={styles.addBookButton}>Add to Library</button>
                    </form>

                    <h3>Your Books</h3>
                    {books.length === 0 ? (
                        <p>No books found.</p>
                    ) : (
                        <ul className={styles.bookList}>
                            {books.map((b) => (
                                <li key={b.book_id} className={styles.bookListItem}>
                                    <div className={styles.bookDetails}>
                                        <h4>{b.title}</h4>
                                        <p>Author: {b.author}</p>
                                        <p>Edition: {b.edition}</p>
                                    </div>
                                    <div className={styles.bookImageContainer}>
                                        {/* Fetch and display the book image */}
                                        <img
                                            src={`../../../${b.image_path}`}
                                            alt={`${b.title}`}
                                            className={styles.bookImage}
                                            onError={(e) => { e.target.src = '../../../images/books/default_book.jpg'; }} // Fallback image
                                        />
                                    </div>
                                    <button onClick={() => removeBook(b)} className={styles.removeButton}>
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