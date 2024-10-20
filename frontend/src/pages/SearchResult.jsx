
import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios';

const SearchResult = () => {
    const location = useLocation();
    const { user_name, searchQuery } = location.state || {}; // Access user_name and searchQuery from the dashboard

    const [user_id, setUserId] = useState(null); // State to store user_id
    const [bookDetails, setBookDetails] = useState([]); // State for book details array
    const [message, setMessage] = useState(''); // To store response message
    const [error, setError] = useState(''); // To store error message

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

    // Fetch book details based on the title (searchQuery) when the component mounts or searchQuery changes
    useEffect(() => {
        const fetchBookDetails = async () => {
            try {
                const response = await axios.get(`http://localhost:8080/auth/GetBookDetailsByTitle/${searchQuery}`);
                setBookDetails(response.data); // Assuming response.data returns an array of book details
                setMessage('Books found successfully!');
                setError('');
            } catch (error) {
                console.error('Error fetching book details:', error);
                setError('Failed to fetch book details.');
                setMessage('');
            }
        };

        if (searchQuery) {
            fetchBookDetails();
        }
    }, [searchQuery]);

    // Function to handle sending a request to a user
    const sendRequest = async (user_id) => {
        const payload = {
            requestor_id: user_id, // Ensure this is an integer
            receiver_id: 4,
            requestor_book_id: 5,
            receiver_book_id: 3,
            
        };
        try {
            await axios.post(`http://localhost:8080/auth/makerequest`, payload);
            setMessage(`Request sent successfully to user ID: ${user_id}`);
            setError('');
        } catch (error) {
            console.error('Error sending request:', error);
            setError('Failed to send request.');
            setMessage('');
        }
    };

    return (
        <div>
            <h2>Search Results for "{searchQuery}"</h2>
            <p>Welcome, {user_name}! Here are the results for your search.</p>

            {/* Display error if any */}
            {error && <p style={{ color: 'red' }}>{error}</p>}

            {/* Display success message if available */}
            {message && <p style={{ color: 'green' }}>{message}</p>}

            {/* Display user ID if available */}
            {user_id && <p>Your user ID: {user_id}</p>}

            {/* Display book details */}
            <div>
                {bookDetails.length > 0 ? (
                    <ul>
                        {bookDetails.map((book, index) => (
                            <li key={index}>
                                <strong>Book ID:</strong> {book.book_id} <br />
                                <strong>Title:</strong> {book.title} <br />
                                <strong>Author:</strong> {book.author} <br />
                                <strong>Edition:</strong> {book.edition} <br />
                                <strong>User ID:</strong> {book.user_id} <br />
                                <strong>User Name:</strong> {book.user_name} <br />
                                <button onClick={() => sendRequest(book.user_id)}>Send Request</button> {/* Send Request button */}
                                <hr />
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>No books found.</p>
                )}
            </div>
        </div>
    );
};

export default SearchResult;
