import React, { useState, useEffect, useCallback, useRef } from 'react';
import { Link, useLocation } from 'react-router-dom'; // Import useLocation to handle scroll after navigation
import styles from '../styles/Homepage.module.css'; // Import the CSS file as a module
import axios from 'axios';
import Navbar from '../components/Navbar'; 

const HomePage = () => {
  const [books, setBooks] = useState([]);
  const [error, setError] = useState('');
  const bookListRef = useRef(null); // Reference to the book list container
  const location = useLocation(); // Hook to get the current location

  const scrollToSection = (sectionId) => {
    const section = document.getElementById(sectionId);
    if (section) {
      section.scrollIntoView({ behavior: 'smooth' });
    }
  };

  // Fetch latest books from the server
  const fetchBooks = useCallback(async () => {
    try {
      const response = await axios.get('http://localhost:8080/auth/latest_books');
      setBooks(response.data); // Assuming response.data returns the array of books
    } catch (err) {
      console.error('Error fetching books:', err);
      setError('Failed to fetch books.'); // Show error message
    }
  }, []);

  // Scroll to the section based on the hash in the URL
  useEffect(() => {
    if (location.hash) {
      const sectionId = location.hash.substring(1); // Remove the '#' character from the hash
      scrollToSection(sectionId);
    }
  }, [location]);

  useEffect(() => {
    fetchBooks(); // Fetch books when component mounts
  }, [fetchBooks]);

  // Function to scroll left
  const scrollLeft = () => {
    if (bookListRef.current) {
      bookListRef.current.scrollBy({ left: -300, behavior: 'smooth' }); // Adjust scroll distance as needed
    }
  };

  // Function to scroll right
  const scrollRight = () => {
    if (bookListRef.current) {
      bookListRef.current.scrollBy({ left: 300, behavior: 'smooth' }); // Adjust scroll distance as needed
    }
  };

  return (
    
    <div className={styles.container}>
       <Navbar />

      {/* Header Section */}
      <div id="home" className={styles.headerImage}>
  <div className={styles.headerText}>
  <h1>Book Buddies!</h1>
<h2>Discover, Share, and Swap Your Favorite Reads</h2>
<p>Turn your bookshelf into a treasure trove by exchanging books with fellow readers, all within our community!</p>

  </div>
</div>



      {/* Authentication Buttons */}
      <div className={styles.authButtons}>
        <Link to="/login">
          <button className={styles.button}>Login</button>
        </Link>
        <Link to="/signup">
          <button className={styles.button}>Sign Up</button>
        </Link>
      </div>

      
      {/* How it Works Section */}
<div className={`${styles.whiteContainer} ${styles.stepsSection}`}>
<h2>Your Guide to Seamless Book Swapping</h2>


  <div className={styles.steps}>
  <div className={styles.step}><strong>Step 01:</strong> Sign up to join the community and create your profile</div>
<div className={styles.step}><strong>Step 02:</strong> List your available books in your personal collection</div>
<div className={styles.step}><strong>Step 03:</strong> Browse and select books you'd like to read from others</div>
<div className={styles.step}><strong>Step 04:</strong> Contact the owner and agree on how to exchange the books</div>
<div className={styles.step}><strong>Step 05:</strong> Meet up or arrange a pick-up to swap books</div>

  </div>
</div>


   
      {/* Latest Books Section */}
<div className={styles.whiteContainer}>
  <h3 className={styles.LatestBooks}>Fresh Finds for Your Collection  !!!</h3>
  <div className={styles.horizontalScrollContainer}>
    <button onClick={scrollLeft} className={styles.scrollButton}>←</button>
    <div className={styles.bookList} ref={bookListRef}>
      {books.length === 0 ? (
        <p>No books found.</p>
      ) : (
        books.map((b) => (
          <div key={b.book_id} className={styles.bookListItem}>
            <img className={styles.samplePic} src={require('../styles/11.png')} alt="Book Cover" />
            <div className={styles.book} >
              <strong>Title:</strong> {b.title} <br />
              <strong>Author:</strong> {b.author}
            </div>
          </div>
        ))
      )}
    </div>
    <button onClick={scrollRight} className={styles.scrollButton}>→</button>
  </div>
</div>


      {/* About Section */}
      <div id="about" className={styles.aboutSection}>
  <h1>About Us</h1>
  <p>
    Welcome to our Book Exchange Platform! We are a team of passionate computer science engineering undergraduates from the University of Moratuwa, dedicated to creating a space where book lovers can exchange and discover new books. Our platform aims to foster a community of readers who share their love for literature in a sustainable way.
  </p>

  <h2>Mission</h2>
  <p>
    Our mission is to promote sustainability by providing a platform for book exchanges, helping to reduce waste and extend the life cycle of books. By encouraging the sharing of literature, we aim to save trees and preserve our environment while connecting like-minded readers from different backgrounds.
  </p>

  <h2>Vision</h2>
  <p>
    We envision a world where books are passed from reader to reader, creating lasting connections and making literature more accessible to all. Our platform strives to build a global community of readers who share knowledge and stories through the simple act of exchanging books.
  </p>

  <h2>Meet the Team</h2>
  <ul>
    <li><strong>Dulitha Perera</strong> – Computer Science Engineering Undergraduate, University of Moratuwa</li>
    <li><strong>Sithum Bimsara</strong> – Computer Science Engineering Undergraduate, University of Moratuwa</li>
    <li><strong>Sasmitha Jayasinghe</strong> – Computer Science Engineering Undergraduate, University of Moratuwa</li>
    <li><strong>Kaveesha Kapuruge</strong> – Computer Science Engineering Undergraduate, University of Moratuwa</li>
  </ul>

  <h2>Future Plans</h2>
  <p>
    We are continuously working to improve the platform by adding more features, such as advanced search options, book recommendations, and integration with other literary platforms. Stay tuned for updates!
  </p>
</div>

{/* Contact Section */}
<div id="contact" className={styles.contactSection}>
  <h1>Contact Us</h1>
  <p>If you have any questions or need more information, feel free to reach out at <strong>contact@bookbuddies.com</strong>.</p>
</div>

    </div>
  );
};

export default HomePage;