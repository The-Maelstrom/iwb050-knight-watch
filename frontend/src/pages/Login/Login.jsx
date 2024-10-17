import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import styles from './Login.module.css'; // Import CSS Module for styles
//import Navbar from '../../components/Navbar'; 


function Login() {
    const [formData, setFormData] = useState({
        user_name: '',
        password: ''
    });

    const [message, setMessage] = useState(''); // To store success message
    const [error, setError] = useState(''); // To store error message
    const [showPopup, setShowPopup] = useState(false); // To control popup visibility
    const navigate = useNavigate(); // For navigation after successful login

    // Handle form input changes
    const handleChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        });
    };

    // Simple form validation
    const validateForm = () => {
        const { user_name, password } = formData;

        // Username validation
        if (!user_name) {
            return "Username is required.";
        }

        // Password validation
        if (!password) {
            return "Password is required.";
        }

        return null; // No validation errors
    };

    // Handle form submission
    const handleSubmit = async (e) => {
        e.preventDefault();

        // Validate form data before sending
        const validationError = validateForm();
        if (validationError) {
            setError(validationError);
            setMessage(''); // Clear success message
            return;
        }

        try {
            // Send login data to backend
            const response = await axios.post('http://localhost:8080/auth/login', formData);
            setMessage(response.data.message); // Display backend message
            setError(''); // Clear any errors

            // If login is successful, show a popup message and redirect to dashboard
            if (response.data.message === "Login successful!") {
                setShowPopup(true); // Show popup

                setTimeout(() => {
                    setShowPopup(false); // Hide popup after 2 seconds
                    navigate('/add-books', { state: { user_name: formData.user_name } });
                }, 2000); // 2000 milliseconds = 2 seconds
            }
        } catch (error) {
            setError('Invalid username or password. Please try again.');
            setMessage(''); // Clear success message
            console.error('Login error:', error);
        }
    };

    return  (
        <>
            {/* Navbar at the top of the page */}

            <div className={styles.wrapper}>
                <h2 className={styles.title}>Login</h2>
                <form onSubmit={handleSubmit}>
                    {/* Username */}
                    <div className={styles.inputField}>
                        <label htmlFor="user_name">Username: </label>
                        <input
                            type="text"
                            name="user_name"
                            value={formData.user_name}
                            onChange={handleChange}
                            required
                        />
                    </div>

                    {/* Password */}
                    <div className={styles.inputField}>
                        <label htmlFor="password">Password: </label>
                        <input
                            type="password"
                            name="password"
                            value={formData.password}
                            onChange={handleChange}
                            required
                        />
                    </div>

                    <button type="submit" className={styles.button}>Login</button>
                </form>

                {message && <p className={styles.successMessage}>{message}</p>}
                {error && <p className={styles.errorMessage}>{error}</p>}

                {/* Popup message */}
                {showPopup && (
                    <div className={styles.popup}>
                        <p>{message}</p>
                    </div>
                )}
            </div>
        </>
    );
}

export default Login;
