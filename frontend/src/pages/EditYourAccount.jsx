import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios';
import DashboardNavbar from '../components/DashboardNavbar';
import styles from '../styles/EditYourAccount.module.css'; // Importing the CSS module
import Navbar from '../components/Navbar';

const EditAccount = () => {
    const location = useLocation();
    const { user_name } = location.state || {}; // Access user_name passed from the dashboard

    const [user_id, setUserId] = useState(null); // State to store user_id
    const [address, setAddress] = useState({
        address_line1: '',
        address_line2: '',
        address_line3: '',
        city: '',
        district: '',
        postal_code: ''
    });
    
    // State to store the user's phone_number
    const [phone_number, setPhoneNumber] = useState({
        phone_number: '',
    }); 
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
                setError('Failed to fetch user ID.');
            }
        };

        if (user_name) {
            fetchUserId();
        }
    }, [user_name]);

    // Fetch user's existing address when user_id is available
    useEffect(() => {
        const fetchUserAddress = async () => {
            try {
                const response = await axios.get(`http://localhost:8080/auth/address/${user_id}`);
                setAddress(response.data); // Assuming response.data returns the address object
            } catch (err) {
                console.error('Error fetching address:', err);
                setError('Failed to fetch address.');
            }
        };

        if (user_id) {
            fetchUserAddress();
        }
    }, [user_id]);

    // Fetch user's existing PhoneNumber when user_id is available
    useEffect(() => {
        const fetchUserPhoneNumber = async () => {
            try {
                const response = await axios.get(`http://localhost:8080/auth/phone_number/${user_id}`);
                setPhoneNumber(response.data); // Assuming response.data returns the address object
            } catch (err) {
                console.error('Error fetching phone_number:', err);
                setError('Failed to fetch phone_number.');
            }
        };

        if (user_id) {
            fetchUserPhoneNumber();
        }
    }, [user_id]);

    // Handle input change for the address form
    const handleAddressChange = (field, value) => {
        setAddress({ ...address, [field]: value });
    };
    const handlePhoneNumberChange = (field, value) => {
        setPhoneNumber({ ...phone_number, [field]: value });
    };

    // Handle updating the user's address
    const updateAddress = async () => {
        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }

        try {
            const payload = {
                user_id: user_id,
                address_line1: address.address_line1,
                address_line2: address.address_line2,
                address_line3: address.address_line3,
                city: address.city,
                district: address.district,
                postal_code: address.postal_code
            };
            const response = await axios.post('http://localhost:8080/auth/updateUserAddress', payload, {
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            setMessage(response.data.message);
            setError('');
            window.location.reload(); // Reload page after successful update
        } catch (error) {
            console.error('Error updating address:', error);
            setError('Failed to update address.');
            setMessage('');
        }
    };

     // Handle updating the user's phone_number
     const updatePhoneNumber = async () => {
        if (user_id === null) {
            setError('User ID is not available.');
            return;
        }

        try {
            const payload = {
                user_id: user_id,
                phone_number: phone_number.phone_number,
            };
            const response = await axios.post('http://localhost:8080/auth/UpdatePhoneNumber', payload, {
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            setMessage(response.data.message);
            setError('');
            window.location.reload(); // Reload page after successful update
        } catch (error) {
            console.error('Error updating phone_number:', error);
            setError('Failed to update phone_number.');
            setMessage('');
        }
    };

    return (
        <div className={styles.wishlistPage}>
            <div className={styles.sidebar}>
                <img className={styles.profilePic} src={require('../styles/2.png')} alt="Profile" />
                <h2 className={styles.sidebarTitle}>Welcome {user_name}!</h2>
                <h2 className={styles.libraryTitle}>Edit Your Account</h2>
                <p className={styles.sidebarDescription}>
                    This section allows you to update your account information.
                </p>
            </div>

            <div className={styles.mainContent}>
                <Navbar />
                <DashboardNavbar />

                <div className={styles.addressContainer}>
                    <h3 className={styles.pagedescription}>Your Address and Phone Number</h3>
                    <form onSubmit={(e) => { e.preventDefault(); updateAddress(); updatePhoneNumber();}} className={styles.addressForm}>
                        
                        <label className={styles.htmlFor}htmlFor="address_line1">Address Line 1:</label>
                        <input
                            type="text"
                            id="address_line1"
                            placeholder="Address Line 1"
                            value={address.address_line1}
                            onChange={(e) => handleAddressChange('address_line1', e.target.value)}
                            required
                        />

                        <label className={styles.htmlFor} htmlFor="address_line2">Address Line 2:</label>
                        <input
                            type="text"
                            id="address_line2"
                            placeholder="Address Line 2"
                            value={address.address_line2}
                            onChange={(e) => handleAddressChange('address_line2', e.target.value)}
                        />

                        <label  className={styles.htmlFor}htmlFor="address_line3">Address Line 3:</label>
                        <input
                            type="text"
                            id="address_line3"
                            placeholder="Address Line 3"
                            value={address.address_line3}
                            onChange={(e) => handleAddressChange('address_line3', e.target.value)}
                        />

                        <label className={styles.htmlFor} htmlFor="city">City:</label>
                        <input
                            type="text"
                            id="city"
                            placeholder="City"
                            value={address.city}
                            onChange={(e) => handleAddressChange('city', e.target.value)}
                            required
                        />

                        <label className={styles.htmlFor} htmlFor="district">District:</label>
                        <input
                            type="text"
                            id="district"
                            placeholder="District"
                            value={address.district}
                            onChange={(e) => handleAddressChange('district', e.target.value)}
                            required
                        />

                        <label className={styles.htmlFor} htmlFor="postal_code">Postal Code:</label>
                        <input
                            type="text"
                            id="postal_code"
                            placeholder="Postal Code"
                            value={address.postal_code}
                            onChange={(e) => handleAddressChange('postal_code', e.target.value)}
                            required
                        />
                        <label className={styles.htmlFor} htmlFor="phone_number">Phone Number:</label>
                        <input
                            type="text"
                            id="phone_number"
                            placeholder="phone_number"
                            value={phone_number.phone_number}
                            onChange={(e) => handlePhoneNumberChange('phone_number', e.target.value)}
                            required
                        />

                        <button type="submit" className={styles.updateButton}>Update Address</button>
                    </form>

                    {message && <p className={styles.message}>{message}</p>}
                    {error && <p className={styles.error}>{error}</p>}
                </div>
            </div>
        </div>
    );
};

export default EditAccount;
