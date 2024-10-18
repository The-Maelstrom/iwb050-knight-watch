import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import styles from './Signup.module.css'; // Importing CSS module
//import Navbar from '../../components/Navbar'; 

function Signup() {
    const [formData, setFormData] = useState({
        first_name: '',
        last_name: '',
        email_address: '',
        user_name: '',
        password: '',
        gender: '',
        phone_number1: '',
        address_line1_1: '',
        address_line2_1: '',
        address_line3_1: '',
        city_1: '',
        district_1: '',
        postal_code_1: ''
    });

    const [message, setMessage] = useState(''); // To store success message
    const [error, setError] = useState(''); // To store error message
    const [showPopup, setShowPopup] = useState(false); // To control popup visibility
    const navigate = useNavigate(); // For navigation after successful signup

    // Handle form input changes
    const handleChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        });
    };

    // Simple form validation
    const validateForm = () => {
        const {
            email_address, phone_number1, password, postal_code_1, user_name
        } = formData;

        // Email format validation
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email_address)) {
            return "Invalid email format. Please include '@' and a domain.";
        }

        // Phone number validation (10 digits, numbers only)
        const phoneRegex = /^[0-9]{10}$/;
        if (!phoneRegex.test(phone_number1)) {
            return "Phone number must be exactly 10 digits, with numbers only.";
        }

        // Password length validation
        if (password.length < 6) {
            return "Password must be at least 6 characters long.";
        }

        // Postal code validation (numbers only)
        const postalCodeRegex = /^[0-9]+$/;
        if (!postalCodeRegex.test(postal_code_1)) {
            return "Postal code must contain numbers only.";
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
            // Send form data to backend
            const response = await axios.post('http://localhost:8080/auth/signup', formData);
            setMessage(response.data.message); // Display backend message
            setError(''); // Clear any errors

            // If signup is successful, show a popup message and redirect to dashboard
            if (response.data.message === "User registered successfully!") {
                setShowPopup(true); // Show popup

                setTimeout(() => {
                    setShowPopup(false); // Hide popup after 2 seconds
                    navigate('/add-books', { state: { user_name: formData.user_name } });
                }, 2000); // 2000 milliseconds = 2 seconds
            }
        } catch (error) {
            setError('Error during signup. Please try again.');
            setMessage(''); // Clear success message
            console.error('Signup error:', error);
        }
    };

    return (
        <div className={styles.container}>
            <h2 className={styles.title}>Sign Up</h2>
            <form onSubmit={handleSubmit} className={styles.form}>
                <div className={styles['user-details']}>
                    <div className={styles['input-box']}>
                        <span className={styles.details}>First Name</span>
                        <input
                            type="text"
                            name="first_name"
                            value={formData.first_name}
                            onChange={handleChange}
                            required
                        />
                    </div>
                    <div className={styles['input-box']}>
                        <span className={styles.details}>Last Name</span>
                        <input
                            type="text"
                            name="last_name"
                            value={formData.last_name}
                            onChange={handleChange}
                            required
                        />
                    </div>
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Email Address</span>
                    <input
                        type="email"
                        name="email_address"
                        value={formData.email_address}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Username</span>
                    <input
                        type="text"
                        name="user_name"
                        value={formData.user_name}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Password</span>
                    <input
                        type="password"
                        name="password"
                        value={formData.password}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Gender</span>
                    <select
                        name="gender"
                        value={formData.gender}
                        onChange={handleChange}
                        required
                    >
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Phone Number</span>
                    <input
                        type="text"
                        name="phone_number1"
                        value={formData.phone_number1}
                        onChange={handleChange}
                        required
                    />
                </div>

                <h3 className={styles.title} style={{ color: 'black' }}>Primary Address</h3>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Address Line 1</span>
                    <input
                        type="text"
                        name="address_line1_1"
                        value={formData.address_line1_1}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Address Line 2</span>
                    <input
                        type="text"
                        name="address_line2_1"
                        value={formData.address_line2_1}
                        onChange={handleChange}
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Address Line 3</span>
                    <input
                        type="text"
                        name="address_line3_1"
                        value={formData.address_line3_1}
                        onChange={handleChange}
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>City</span>
                    <input
                        type="text"
                        name="city_1"
                        value={formData.city_1}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>District</span>
                    <input
                        type="text"
                        name="district_1"
                        value={formData.district_1}
                        onChange={handleChange}
                        required
                    />
                </div>
                <div className={styles['input-box']}>
                    <span className={styles.details}>Postal Code</span>
                    <input
                        type="text"
                        name="postal_code_1"
                        value={formData.postal_code_1}
                        onChange={handleChange}
                        required
                    />
                </div>
                
                <div className={styles.button}>
                    <button type="submit">Sign Up</button>
                </div>
            </form>

            {message && <p className={styles.success}>{message}</p>}
            {error && <p className={styles.error}>{error}</p>}

            {/* Popup message */}
            {showPopup && (
                <div className={styles.popup}>
                    <p>{message}</p>
                </div>
            )}
        </div>
    );
}

export default Signup;
