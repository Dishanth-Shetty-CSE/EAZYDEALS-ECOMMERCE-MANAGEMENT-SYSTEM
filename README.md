# EazyDeals — E-Commerce Management System

[![Java](https://img.shields.io/badge/Java-17%2B-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-F09819?style=for-the-badge&logo=eclipse-ide&logoColor=white)](https://jakarta.ee/)
[![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10.1%2B-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)](https://tomcat.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)](https://getbootstrap.com/)
[![Font Awesome](https://img.shields.io/badge/Font%20Awesome-6.4-528DD7?style=for-the-badge&logo=font-awesome&logoColor=white)](https://fontawesome.com/)

A modern, high-performance, full-stack E-Commerce Web Application built using Java Servlets, JavaServer Pages (JSP), JDBC, and MySQL. EazyDeals delivers an end-to-end online retail experience for shoppers alongside a centralized administration portal for catalog governance, inventory control, and order fulfillment.

---

## Table of Contents

- [Architectural Overview](#architectural-overview)
- [Key Features](#key-features)
  - [Customer Experience](#customer-experience)
  - [Administrative Operations](#administrative-operations)
  - [Security & Authentication](#security--authentication)
  - [Automated Email Notification Engine](#automated-email-notification-engine)
- [Technology Stack](#technology-stack)
- [Database Schema & Entity Model](#database-schema--entity-model)
- [Project Directory Structure](#project-directory-structure)
- [Getting Started & Installation](#getting-started--installation)
  - [Prerequisites](#prerequisites)
  - [Database Configuration](#database-configuration)
  - [Application Setup in Eclipse / IDE](#application-setup-in-eclipse--ide)
  - [Deployment on Apache Tomcat](#deployment-on-apache-tomcat)
- [Preloaded Demo Credentials](#preloaded-demo-credentials)
- [Core Application Endpoints](#core-application-endpoints)
- [Future Enhancements](#future-enhancements)
- [License](#license)

---

## Architectural Overview

EazyDeals is structured following the enterprise **Model-View-Controller (MVC)** architectural pattern:

- **Model (DAO & Entities):** Encapsulates relational business entities (`Product`, `Category`, `User`, `Order`, `Cart`, `Wishlist`, `Admin`) and handles database transactions via type-safe Data Access Objects (`ProductDao`, `CategoryDao`, `UserDao`, `OrderDao`, `CartDao`, `WishlistDao`, `AdminDao`).
- **View (JSP & Dynamic Web Presentation):** Responsive, high-conversion user interfaces powered by Bootstrap 5.3, Google Fonts (Poppins), Font Awesome 6.4, and SweetAlert2 interactive modals.
- **Controller (Jakarta Servlets & Services):** Processes HTTP GET/POST lifecycles, route validation, session authentication, and transactional state mutations with decoupling between servlets and DAO business layers via specialized service classes (`ProductService`, etc.).

---

## Key Features

### Customer Experience
- **Interactive Home & Showcase:** Dynamic hero promotions, quick-trust assurances, curated hot deals, and recently added collections.
- **Precision Catalog Filtering:** Six dedicated categories (Laptops, Mobiles, Electronics, Appliances, Furniture, and Books) with zero-leakage category filtering and live stock counters.
- **Keyword Search:** Instant full-text search across titles and item specifications.
- **Detailed Product Specifications:** Dynamic calculations showing original MRP, discount percentages, and final payable amount.
- **Cart & Wishlist Engine:** Add, update quantities, remove items, and preserve wishlist favorites with live badge counters in the navigation header.
- **Smooth Checkout Flow:** Pre-filled profile addresses, dynamic order confirmation dialogs, and instant order placement summaries.
- **Account Self-Service:** Customer profile management, shipment status review, and password reset workflows.

### Administrative Operations
- **Executive Operations Dashboard:** Real-time KPI summary widgets for total active products, pending/delivered orders, configured categories, and registered customers.
- **Product Catalog Management:** Multi-attribute product creation with image uploads, live stock tracking, discount margins, and unit pricing.
- **Category Hierarchy Control:** Dynamic category creation, custom image updates, and direct-drilldown category filtering.
- **Order Dispatch & Logistics Pipeline:** Review customer order queues, view multi-product line items, update delivery statuses (Processing, Shipped, Delivered), and manage customer fulfillment.
- **Customer Oversight:** View registered accounts, contact details, physical shipping locations, and manage account privileges.
- **Team Administration:** Admin role assignment with secure credential management.

### Security & Authentication
- **Cryptographic Hashing:** Cryptographically secure SHA-256 password hashing for all customer and administrative accounts.
- **Session Management:** Secure HTTP session persistence (`activeAdmin`, `activeUser`), invalidating unauthorized requests with role-based routing guards.
- **SQL Injection Prevention:** JDBC `PreparedStatement` interfaces utilized across all database operations.

### Automated Email Notification Engine
- **Jakarta Mail Integration:** Asynchronous email dispatch via Gmail SMTP service.
- **Automated Triggers:** Instant transactional emails for account registration, order placement receipts, shipment updates, and OTP-based password recovery.

---

## Technology Stack

| Layer | Technologies / Libraries |
|:---|:---|
| **Language** | Java 17 LTS |
| **Web Framework** | Jakarta Servlet 5.0 / 6.0, JavaServer Pages (JSP 3.0) |
| **Data Access** | JDBC (Java Database Connectivity) |
| **Database** | MySQL Server 8.0+ |
| **Frontend UI** | HTML5, CSS3, JavaScript (ES6+), jQuery 3.7.0 |
| **Styling & Icons** | Bootstrap 5.3.0, Font Awesome 6.4.0, Google Fonts (Poppins) |
| **Dialogs & Feedback** | SweetAlert2 v11 |
| **Mail Services** | Jakarta Mail 2.0.1, Angus Activation 2.0.1 |
| **Database Connector** | MySQL Connector/J 8.0.33 |
| **Server Runtime** | Apache Tomcat 10.1+ (Jakarta namespace support) |
| **Build & Tooling** | Eclipse IDE for Enterprise Java / Maven / VS Code |

---

## Database Schema & Entity Model

The system utilizes an optimized MySQL relational database named `eazydeals`:

```
+---------------+        +---------------+        +---------------+
|   category    | 1    * |    product    | 1    * |     cart      |
|---------------+<-------|---------------+<-------|---------------+
| cid (PK)      |        | pid (PK)      |        | cartid (PK)   |
| name          |        | name          |        | uid (FK)      |
| image         |        | price         |        | pid (FK)      |
+---------------+        | discount      |        | quantity      |
                         | quantity      |        +---------------+
                         | cid (FK)      |
                         +---------------+
                                 ^
                                 | 1
                                 |
                                 | *
+---------------+        +---------------+        +---------------+
|     user      | 1    * |     order     | 1    * |ordered_product|
|---------------+<-------|---------------+<-------|---------------+
| userid (PK)   |        | id (PK)       |        | oid (PK)      |
| name          |        | orderid       |        | name          |
| email         |        | status        |        | quantity      |
| password(SHA) |        | paymentType   |        | price         |
| phone         |        | userId (FK)   |        | image         |
| address       |        | date          |        | orderid (FK)  |
+---------------+        +---------------+        +---------------+
```

### Table Breakdown:
- `admin`: Stores authorized administrator profiles and SHA-256 password digests.
- `category`: Stores catalog departments and promotional badge assets.
- `product`: Stores item titles, rich descriptions, inventory stock levels, base pricing, percentage discounts, image filenames, and category foreign keys (`cid`).
- `user`: Stores customer profile information, contact numbers, encrypted credentials, and default shipping addresses.
- `cart`: Manages session cart state mapped by `uid` and `pid`.
- `order`: Captures order headers, transaction identifiers, payment modes, dispatch status, and timestamp.
- `ordered_product`: Line-item audit records preserving product snapshots (name, quantity, purchase price, image) at checkout time.
- `wishlist`: Customer-bookmarked product records.

---

## Project Directory Structure

```text
EAZYDEALS-ECOMMERCE-MANAGEMENT-SYSTEM/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── eazydeals/
│       │           ├── dao/                  # Data Access Objects (CRUD operations)
│       │           │   ├── AdminDao.java
│       │           │   ├── CartDao.java
│       │           │   ├── CategoryDao.java
│       │           │   ├── OrderDao.java
│       │           │   ├── ProductDao.java
│       │           │   ├── UserDao.java
│       │           │   └── WishlistDao.java
│       │           ├── entities/             # POJO Data Models
│       │           │   ├── Admin.java
│       │           │   ├── Cart.java
│       │           │   ├── Category.java
│       │           │   ├── Message.java
│       │           │   ├── Order.java
│       │           │   ├── OrderedProduct.java
│       │           │   ├── Product.java
│       │           │   ├── User.java
│       │           │   └── Wishlist.java
│       │           ├── helper/               # Utilities & Singletons
│       │           │   ├── ConnectionProvider.java
│       │           │   ├── MailMessenger.java
│       │           │   └── OrderIdGenerator.java
│       │           ├── services/             # Decoupled Business Services
│       │           │   └── ProductService.java
│       │           └── servlets/             # HTTP Controllers (Jakarta Servlets)
│       │               ├── AddCategoryServlet.java
│       │               ├── AddOperationServlet.java
│       │               ├── AdminServlet.java
│       │               ├── CartOperationServlet.java
│       │               ├── ChangePasswordServlet.java
│       │               ├── ForgotPasswordServlet.java
│       │               ├── LoginServlet.java
│       │               ├── LogoutServlet.java
│       │               ├── OrderOperationServlet.java
│       │               ├── ProductServlet.java
│       │               ├── RegisterServlet.java
│       │               ├── UpdateAdminServlet.java
│       │               ├── UpdateOrderServlet.java
│       │               ├── UpdateProductServlet.java
│       │               ├── UpdateUserServlet.java
│       │               └── WishlistServlet.java
│       └── webapp/
│           ├── Components/                   # Modular JSP Snippets
│           │   ├── alert_message.jsp
│           │   ├── common_css_js.jsp
│           │   └── navbar.jsp
│           ├── CSS/                          # Stylesheets
│           │   └── style.css
│           ├── Images/                       # Application Badges & UI Vectors
│           ├── JS/                           # Client Scripts & Form Validation
│           │   └── script.js
│           ├── Product_imgs/                 # Catalog Product Visual Assets
│           ├── WEB-INF/
│           │   ├── lib/                      # Packaged Enterprise Dependency JARs
│           │   │   ├── angus-activation-2.0.1.jar
│           │   │   ├── jakarta.activation-api-2.1.2.jar
│           │   │   ├── jakarta.mail-2.0.1.jar
│           │   │   └── mysql-connector-j-8.0.33.jar
│           │   └── web.xml                   # Web Deployment Descriptor
│           ├── admin.jsp                     # Admin KPI Dashboard
│           ├── adminlogin.jsp                # Admin Authentication Portal
│           ├── cart.jsp                      # Shopping Cart
│           ├── checkout.jsp                  # Checkout & Address Selection
│           ├── display_admin.jsp             # Administrator Registry
│           ├── display_category.jsp          # Category Management Table
│           ├── display_orders.jsp            # Order Processing Table
│           ├── display_products.jsp          # Product Inventory Table
│           ├── display_users.jsp             # Customer Accounts Table
│           ├── index.jsp                     # Primary Customer Storefront
│           ├── login.jsp                     # Customer Login
│           ├── products.jsp                  # Catalog View & Category Filtering
│           ├── profile.jsp                   # Customer Account & Past Orders
│           ├── register.jsp                  # Customer Registration
│           ├── viewProduct.jsp               # Product Detail Overview
│           └── wishlist.jsp                  # Saved Favorites
├── EazyDeals_SQL_Script.sql                  # Complete Database Schema & Seed Data
├── EazyDeals_Schema_Diagram.mwb              # MySQL Workbench Data Model File
├── pom.xml                                   # Maven Build Configuration
└── README.md                                 # Technical Documentation
```

---

## Getting Started & Installation

### Prerequisites
Before running the application, ensure the following are installed:
1. **Java Development Kit (JDK):** Version 17 or higher
2. **Database:** MySQL Server 8.0 or higher
3. **Servlet Container:** Apache Tomcat 10.1+ *(Tomcat 10+ is required due to the `jakarta.servlet` namespace)*
4. **IDE (Optional):** Eclipse IDE for Enterprise Java and Web Developers, IntelliJ IDEA Ultimate, or VS Code

---

### Database Configuration

1. Launch MySQL Command Line Client or MySQL Workbench:
   ```bash
   mysql -u root -p
   ```
2. Execute the complete database initialization script:
   ```sql
   SOURCE /path/to/EazyDeals_SQL_Script.sql;
   ```
   *(This creates the `eazydeals` schema, defines all foreign-keyed tables, and populates 48 products across 6 categories along with sample customers, carts, and orders).*

3. Update Database Credentials (if your MySQL root password differs):
   Open `src/main/java/com/eazydeals/helper/ConnectionProvider.java`:
   ```java
   connection = DriverManager.getConnection(
       "jdbc:mysql://localhost:3306/eazydeals", 
       "YOUR_MYSQL_USERNAME", 
       "YOUR_MYSQL_PASSWORD"
   );
   ```

---

### Application Setup in Eclipse / IDE

1. Open **Eclipse IDE for Enterprise Java Developers**.
2. Go to **File** &rarr; **Import** &rarr; **Existing Projects into Workspace**.
3. Browse to the cloned project folder: `EAZYDEALS-ECOMMERCE-MANAGEMENT-SYSTEM`.
4. Right-click the project &rarr; **Properties** &rarr; **Targeted Runtimes** &rarr; check **Apache Tomcat v10.1**.
5. Ensure the Java Build Path is set to **JavaSE-17**.

---

### Deployment on Apache Tomcat

1. Right-click the project folder in Eclipse &rarr; **Run As** &rarr; **Run on Server**.
2. Select your configured **Apache Tomcat v10.1** instance.
3. Access the application in any modern web browser:
   - **Customer Storefront:** `http://localhost:8080/EAZYDEALS-ECOMMERCE-MANAGEMENT-SYSTEM/`
   - **Administrator Portal:** `http://localhost:8080/EAZYDEALS-ECOMMERCE-MANAGEMENT-SYSTEM/adminlogin.jsp`

---

## Preloaded Demo Credentials

The database script provides ready-to-use testing accounts:

### 1. System Administrator Account
| Attribute | Value |
|:---|:---|
| **Portal URL** | `/adminlogin.jsp` |
| **Email** | `admin@carrental.com` |
| **Password** | `Admin@123` |
| **Permissions** | Full administrative rights (Catalog, Orders, Users, System Admins) |

### 2. Sample Customer Accounts
All pre-seeded customer accounts follow the password pattern: `<Firstname>@123` *(First letter capitalized)*:

| Name | Email | Password | Location |
|:---|:---|:---|:---|
| Aarav Sharma | `aarav.sharma@gmail.com` | `Aarav@123` | Mumbai, Maharashtra |
| Priya Patel | `priya.patel@gmail.com` | `Priya@123` | Ahmedabad, Gujarat |
| Rohan Verma | `rohan.verma@gmail.com` | `Rohan@123` | Gurugram, Haryana |
| Sneha Reddy | `sneha.reddy@gmail.com` | `Sneha@123` | Hyderabad, Telangana |
| Vikram Singh | `vikram.singh@gmail.com` | `Vikram@123` | Jaipur, Rajasthan |

---

## Core Application Endpoints

| Resource URL | Target Component | Purpose |
|:---|:---|:---|
| `/` or `/index.jsp` | `index.jsp` | Main Storefront & Product Showcase |
| `/products` | `ProductServlet` &rarr; `products.jsp` | Filtered Catalog Listing by Category / Search |
| `/viewProduct.jsp?pid=:id` | `viewProduct.jsp` | Product Deep Dive, Stock Status, Pricing |
| `/cart.jsp` | `cart.jsp` | User Cart Inspection & Quantity Adjustment |
| `/checkout.jsp` | `checkout.jsp` | Address Confirmation & Payment Simulation |
| `/profile.jsp` | `profile.jsp` | Customer Account Details & Order History |
| `/admin.jsp` | `admin.jsp` | Central Admin Operational Dashboard |
| `/display_products.jsp` | `display_products.jsp` | Product Inventory Control & Stock Audit |
| `/display_category.jsp` | `display_category.jsp` | Storefront Category Organization |
| `/display_orders.jsp` | `display_orders.jsp` | Order Fulfillment & Delivery Status Dispatch |
| `/display_users.jsp` | `display_users.jsp` | Registered Customer Directory |
| `/display_admin.jsp` | `display_admin.jsp` | Admin User Permissions & Privilege Delegation |

---

## Future Enhancements

- [ ] **Payment Gateway Integration:** Direct integration with Stripe, Razorpay, or PayPal SDKs.
- [ ] **RESTful API Layer:** Expose JSON endpoints for native iOS / Android mobile applications.
- [ ] **Inventory Low-Stock Alerts:** Automated admin email dispatch when inventory counts drop below threshold.
- [ ] **Customer Review & Ratings System:** Verified buyer ratings and image reviews on product pages.
- [ ] **PDF Invoice Generation:** Downloadable GST/tax invoices directly from the customer order history portal.

---

## License

This project is open-source and available under the [MIT License](LICENSE). Feel free to adapt and expand this application for academic, personal, or commercial e-commerce deployments.
