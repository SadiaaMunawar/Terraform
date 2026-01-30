// Get hostname and display it
document.addEventListener('DOMContentLoaded', function() {
    // Set timestamp
    const timestamp = new Date().toLocaleString();
    document.getElementById('timestamp').textContent = timestamp;

    // Try to fetch server hostname (this would work if the server provides it)
    try {
        fetch('/server-info.txt')
            .then(response => response.text())
            .then(data => {
                document.getElementById('hostname').textContent = data.trim();
            })
            .catch(() => {
                document.getElementById('hostname').textContent = 'Web Server Instance';
            });
    } catch (e) {
        document.getElementById('hostname').textContent = 'Web Server Instance';
    }

    // Smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });

    // Add animation to feature cards on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'fadeInDown 0.6s ease forwards';
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.feature-card').forEach(card => {
        observer.observe(card);
    });
});
