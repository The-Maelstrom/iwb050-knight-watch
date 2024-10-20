import React from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import { useLocation } from 'react-router-dom';
import '../styles/PageTransition.css'; // Import your CSS file

const PageTransition = ({ children }) => {
    const location = useLocation();

    return (
        <div className="transition-container">
            <TransitionGroup>
                <CSSTransition key={location.key} classNames="split-page" timeout={600}>
                    <div className="page">{children}</div>
                </CSSTransition>
            </TransitionGroup>
        </div>
    );
};

export default PageTransition;
