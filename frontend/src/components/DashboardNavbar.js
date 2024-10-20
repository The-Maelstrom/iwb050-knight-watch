import React from 'react';
import { Link } from 'react-router-dom';
import { useNavigate, useLocation } from 'react-router-dom';
import styles from '../styles/DashboardNavbar.module.css'; // Importing the CSS module


const DashboardNavbar = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { user_name } = location.state || {};

  return (
    <nav className={styles.navbar}>
  <button onClick={() => navigate('/add-books', { state: { user_name } })}>
    Add Books to Your Library
  </button>
  <button onClick={() => navigate('/editYourAccount', { state: { user_name } })}>
    Edit Your Account
  </button>
  <button onClick={() => navigate('/notifications', { state: { user_name } })}>
    Notifications
  </button>
  <button onClick={() => navigate('/wishlist', { state: { user_name } })}>
    Wishlist
  </button>
</nav>

  );
};

export default DashboardNavbar;
