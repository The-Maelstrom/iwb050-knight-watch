import React from 'react';
import { Link, useNavigate } from 'react-router-dom'; // Use Link and useNavigate for navigation in React Router
import styles from '../styles/navbar.module.css'; // Import CSS module for Navbar

const Navbar = () => {
  const navigate = useNavigate();

  const handleScroll = (event, sectionId) => {
    event.preventDefault();
    // Navigate to the homepage with the section ID as a hash (e.g., /#about)
    navigate(`/#${sectionId}`);
  };

  return (
    <nav className={styles.nav}>
      <div>
        <Link
          to="/"
          className={styles.link}
          onClick={(e) => handleScroll(e, 'home')}
        >
          Home
        </Link>
        <Link
          to="/"
          className={styles.link}
          onClick={(e) => handleScroll(e, 'about')}
        >
          About
        </Link>
        <Link
          to="/"
          className={styles.link}
          onClick={(e) => handleScroll(e, 'contact')}
        >
          Contact
        </Link>
      </div>
    </nav>
  );
};

export default Navbar;
