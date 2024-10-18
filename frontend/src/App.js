import React from 'react';
import { Link, Routes, Route } from 'react-router-dom';
import Signup from './pages/Signup';
import Login from './pages/Login';

import AddBooks from './pages/AddBooks';
import SearchResult from './pages/SearchResult';
import Notifications from './pages/Notifications';
import Wishlist from './pages/Wishlist';
import Homepage from './pages/Homepage';

import Wishlistitem from './pages/Wishlistitem';  

function App() {
  return (
    <div>
      <Routes>
        <Route path="/" element={<Homepage />} /> {/* Route for HomePage */}
        <Route path="/signup" element={<Signup />} />
        <Route path="/login" element={<Login />} />
       
        <Route path="/add-books" element={<AddBooks />} />
        <Route path="/search-results" element={<SearchResult />} />
        <Route path="/notifications" element={<Notifications />} />
        <Route path="/wishlist" element={<Wishlist />} />
       
        <Route path="/wishlistitem" element={<Wishlistitem />} />
      </Routes>
    </div>
  );
}

export default App;
