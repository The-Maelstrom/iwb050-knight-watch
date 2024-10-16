import React from 'react';
//import './Styles/About.css';  // Assuming you have styles for the about page

const About = () => {
    return (
        <div className="about-container">
            <h1>About Us</h1>
            <p>
                Welcome to our Book Exchange Platform! We are a team of passionate computer science engineering undergraduates from the University of Moratuwa, dedicated to creating a space where book lovers can exchange and discover new books. Our platform aims to foster a community of readers who share their love for literature in a sustainable way.
            </p>

            <h2>Mission</h2>
            <p>
                Our mission is to promote sustainability by providing a platform for book exchanges, helping to reduce waste and extend the life cycle of books, while connecting like-minded readers from different backgrounds.
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

            <p>
                For more information, feel free to reach out through our <a href="/contact">Contact Page</a>.
            </p>
        </div>
    );
}

export default About;
