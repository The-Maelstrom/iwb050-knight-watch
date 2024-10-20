import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Signup from './pages/Signup';
import Login from './pages/Login';
import AddBooks from './pages/AddBooks';
import Notifications from './pages/Notifications';
import Wishlist from './pages/Wishlist';
import Homepage from './pages/Homepage';
import EditYourAccount from './pages/EditYourAccount';
import Wishlistitem from './pages/Wishlistitem';  
import ScrollToTop from './components/ScrollToTop'; // Adjust the path based on your structure
import PageTransition from './components/PageTransition'; // Import the PageTransition component

function App() {
  return (
    <div>
      <ScrollToTop />
      <PageTransition>
        <Routes>
          <Route path="/" element={<Homepage />} /> {/* Route for HomePage */}
          <Route path="/signup" element={<Signup />} />
          <Route path="/login" element={<Login />} />
          <Route path="/add-books" element={<AddBooks />} />
          <Route path="/notifications" element={<Notifications />} />
          <Route path="/wishlist" element={<Wishlist />} />
          <Route path="/wishlistitem" element={<Wishlistitem />} />
          <Route path="/editYourAccount" element={<EditYourAccount />} />
        </Routes>
      </PageTransition>
    </div>
  );
}

export default App;
