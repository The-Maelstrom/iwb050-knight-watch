import React, { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import DashboardNavbar from '../components/DashboardNavbar';

const Dashboard = () => {
    const location = useLocation();
    const { user_name } = location.state || {}; // Access the user_name passed from the login page
    const navigate = useNavigate();
    

    

    return (
        <div>
            <h2>Welcome, {user_name}, to your personalized Dashboard!</h2>
            <DashboardNavbar />
         
        </div>
    );
};

export default Dashboard;
