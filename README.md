# AI Proctoring System

An intelligent web-based proctoring system built with Python Flask and MySQL that uses facial recognition for student identity verification during online examinations.

## Features

### For Students (Users)
- **User Registration & Login**: Secure authentication system
- **Face Registration**: Register facial data for identity verification
- **Online Examinations**: Take exams with real-time AI proctoring
- **Real-time Alerts**: Receive warnings for suspicious activities
- **Issue Notifications**: When the AI suspects something during the exam (e.g. tab switch, focus lost), both the student and the administrator are notified via on-screen notifications; the student sees that an issue was recorded and the admin was notified
- **View Results**: Access exam scores and feedback

### For Administrators
- **Dashboard**: Comprehensive overview of system statistics
- **Live Monitoring**: Continuously polls for active exam sessions and updates the list every 5 seconds; shows all in-progress sessions with student, exam, duration, face status, and warnings
- **Issue Notifications**: When the AI flags a warning or critical event during any exam, the admin sees a real-time toast notification (on the Live Monitor and Dashboard) with student name, exam, and incident details
- **Analytics & Reports**: Generate detailed insights on:
  - Exam completion rates
  - Flagged incidents
  - Student performance metrics
  - Proctoring violation statistics
- **Exam Management**: Create, edit, and manage examinations

## Technology Stack

- **Backend**: Python Flask
- **Database**: MySQL
- **Frontend**: HTML5, CSS3, JavaScript
- **AI/ML**: Face Recognition library, OpenCV
- **Authentication**: Flask-Login

## System Requirements

- Python 3.8+
- MySQL 8.0+
- Webcam (for facial recognition features)
- Modern web browser with camera access

## Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd "AI proctoring"
```

### 2. Create Virtual Environment

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Set Up MySQL Database

### 4. Setup MySQL Database
```bash
# Login to MySQL
mysql -u root -p

# Run the SQL schema file
source database/schema.sql
```

### 5. Configure Environment
Create a `.env` file in the root directory:
```env
SECRET_KEY=your-secret-key-here
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=your-mysql-password
MYSQL_DB=ai_proctoring
```

### 6. Run the Application
```bash
python app.py
```

The application will be available at `http://localhost:5000`

## Default Credentials

### Admin Account
- **Username**: admin
- **Password**: admin

### User Account
Register a new account through the registration page.

## Project Structure

```
AI proctoring/
├── app.py                  # Main Flask application
├── config.py               # Configuration settings
├── requirements.txt        # Python dependencies
├── database/
│   └── schema.sql         # MySQL database schema
├── static/
│   ├── css/
│   │   └── style.css      # Main stylesheet
│   ├── js/
│   │   └── main.js        # JavaScript functions
│   └── uploads/           # User uploaded images
├── templates/
│   ├── base.html          # Base template
│   ├── index.html         # Homepage
│   ├── about.html         # About us page
│   ├── login.html         # Login page
│   ├── register.html      # Registration page
│   ├── user/
│   │   ├── dashboard.html # User dashboard
│   │   ├── exam.html      # Exam taking page
│   │   └── results.html   # Results page
│   └── admin/
│       ├── dashboard.html # Admin dashboard
│       ├── monitor.html   # Live monitoring
│       └── reports.html   # Analytics reports
└── README.md
```

## Key Objectives Achieved

1. **User-Friendly Interface**: Modern, responsive design with intuitive navigation
2. **Facial Recognition**: AI-powered identity verification during exams
3. **Analytics & Reports**: Comprehensive insights and statistical reports

## Security Note

⚠️ This system uses plain text passwords for demonstration purposes only. In a production environment, always use proper password hashing (e.g., bcrypt, argon2).

## License

This project is for educational purposes.

## Support

For issues or questions, please open an issue in the repository.
