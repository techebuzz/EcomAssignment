Create the e-commerce database
CREATE DATABASE  ecommerce;
USE ecommerce;

-- Create brand table
CREATE TABLE brand (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create product_category table
CREATE TABLE  product_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id)
);

-- Create product table
CREATE TABLE  product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    brand_id INT,
    category_id INT,
    base_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Create product_image table
CREATE TABLE product_image (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Create color table
CREATE TABLE IF NOT EXISTS color (
    color_id INT PRIMARY KEY AUTO_INCREMENT,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create size_category table
CREATE TABLE  size_category (
    size_category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create size_option table
CREATE TABLE  size_option (
    size_id INT PRIMARY KEY AUTO_INCREMENT,
    size_category_id INT NOT NULL,
    size_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Create attribute_category table
CREATE TABLE attribute_category (
    attribute_category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create attribute_type table
CREATE TABLE attribute_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create product_attribute table
CREATE TABLE  product_attribute (
    attribute_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    attribute_category_id INT NOT NULL,
    type_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id),
    FOREIGN KEY (type_id) REFERENCES attribute_type(type_id)
);

-- Create product_variation table
CREATE TABLE  product_variation (
    variation_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    color_id INT,
    size_id INT,
    sku VARCHAR(50) UNIQUE,
    price_adjustment DECIMAL(10,2) DEFAULT 0.00,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

-- Create product_item table
CREATE TABLE  product_item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    variation_id INT NOT NULL,
    sku VARCHAR(50) UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
);

-- Insert sample data for testing
-- Insert brands
INSERT INTO brand (brand_name, description) VALUES
('Nike', 'Just Do It'),
('Adidas', 'Impossible Is Nothing'),
('Puma', 'Forever Faster');

-- Insert product categories
INSERT INTO product_category (category_name, description) VALUES
('Clothing', 'Apparel and fashion items'),
('Footwear', 'Shoes and boots'),
('Accessories', 'Fashion accessories');

-- Insert colors
INSERT INTO color (color_name, hex_code) VALUES
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Black', '#000000'),
('White', '#FFFFFF');

-- Insert size categories
INSERT INTO size_category (category_name, description) VALUES
('Clothing', 'Standard clothing sizes'),
('Footwear', 'Shoe sizes');

-- Insert size options
INSERT INTO size_option (size_category_id, size_name) VALUES
(1, 'S'),
(1, 'M'),
(1, 'L'),
(2, '42'),
(2, '43'),
(2, '44');

-- Insert attribute categories
INSERT INTO attribute_category (category_name, description) VALUES
('Physical', 'Physical characteristics'),
('Technical', 'Technical specifications');

-- Insert attribute types
INSERT INTO attribute_type (type_name, description) VALUES
('Text', 'Text-based attributes'),
('Number', 'Numeric attributes'),
('Boolean', 'Yes/No attributes');

-- Insert sample products
INSERT INTO product (product_name, description, brand_id, category_id, base_price) VALUES
('Nike Air Max', 'Classic running shoes', 1, 2, 129.99),
('Adidas T-Shirt', 'Comfortable cotton t-shirt', 2, 1, 29.99);

-- Insert product variations
INSERT INTO product_variation (product_id, color_id, size_id, sku, price_adjustment, stock_quantity) VALUES
(1, 1, 4, 'NIKE-AM-RED-42', 0.00, 10),
(1, 2, 5, 'NIKE-AM-BLUE-43', 0.00, 15),
(2, 3, 1, 'ADIDAS-TS-BLK-S', 0.00, 20),
(2, 4, 2, 'ADIDAS-TS-WHT-M', 0.00, 25);

-- Insert product items
INSERT INTO product_item (variation_id, sku, price, stock_quantity) VALUES
(1, 'NIKE-AM-RED-42-1', 129.99, 10),
(2, 'NIKE-AM-BLUE-43-1', 129.99, 15),
(3, 'ADIDAS-TS-BLK-S-1', 29.99, 20),
(4, 'ADIDAS-TS-WHT-M-1', 29.99, 25);

-- Insert product attributes
INSERT INTO product_attribute (product_id, attribute_category_id, type_id, attribute_name, attribute_value) VALUES
(1, 1, 1, 'Material', 'Mesh and synthetic'),
(1, 2, 2, 'Weight', '300'),
(2, 1, 1, 'Material', '100% Cotton'),
(2, 2, 2, 'Weight', '150');

-- Insert product images
INSERT INTO product_image (product_id, image_url, is_primary) VALUES
(1, 'https://example.com/nike-air-max-red.jpg', TRUE),
(1, 'https://example.com/nike-air-max-blue.jpg', FALSE),
(2, 'https://example.com/adidas-tshirt-black.jpg', TRUE),
(2, 'https://example.com/adidas-tshirt-white.jpg', FALSE);
-- 1. Get all products with their brand and category information
SELECT 
    p.product_name,
    b.brand_name,
    pc.category_name,
    p.base_price
FROM 
    product p
    LEFT JOIN brand b ON p.brand_id = b.brand_id
    LEFT JOIN product_category pc ON p.category_id = pc.category_id;

-- 2. Get all product variations with their color and size information
SELECT 
    p.product_name,
    c.color_name,
    so.size_name,
    pv.sku,
    pv.stock_quantity,
    p.base_price + pv.price_adjustment as final_price
FROM 
    product_variation pv
    JOIN product p ON pv.product_id = p.product_id
    LEFT JOIN color c ON pv.color_id = c.color_id
    LEFT JOIN size_option so ON pv.size_id = so.size_id;

-- 3. Get all products with their primary images
SELECT 
    p.product_name,
    pi.image_url
FROM 
    product p
    LEFT JOIN product_image pi ON p.product_id = pi.product_id
WHERE 
    pi.is_primary = TRUE;

-- 4. Get all products with their attributes
SELECT 
    p.product_name,
    ac.category_name as attribute_category,
    at.type_name as attribute_type,
    pa.attribute_name,
    pa.attribute_value
FROM 
    product p
    JOIN product_attribute pa ON p.product_id = pa.product_id
    JOIN attribute_category ac ON pa.attribute_category_id = ac.attribute_category_id
    JOIN attribute_type at ON pa.type_id = at.type_id;

-- 5. Get all products with low stock (less than 10 items)
SELECT 
    p.product_name,
    pv.sku,
    pv.stock_quantity
FROM 
    product_variation pv
    JOIN product p ON pv.product_id = p.product_id
WHERE 
    pv.stock_quantity < 10;

-- 6. Get all products by brand with their total variations
SELECT 
    b.brand_name,
    COUNT(DISTINCT p.product_id) as total_products,
    COUNT(DISTINCT pv.variation_id) as total_variations
FROM 
    brand b
    LEFT JOIN product p ON b.brand_id = p.brand_id
    LEFT JOIN product_variation pv ON p.product_id = pv.product_id
GROUP BY 
    b.brand_id, b.brand_name;

-- 7. Get all products with their complete information
SELECT 
    p.product_name,
    b.brand_name,
    pc.category_name,
    p.base_price,
    GROUP_CONCAT(DISTINCT c.color_name) as available_colors,
    GROUP_CONCAT(DISTINCT so.size_name) as available_sizes,
    MIN(pv.stock_quantity) as min_stock,
    MAX(pv.stock_quantity) as max_stock
FROM 
    product p
    LEFT JOIN brand b ON p.brand_id = b.brand_id
    LEFT JOIN product_category pc ON p.category_id = pc.category_id
    LEFT JOIN product_variation pv ON p.product_id = pv.product_id
    LEFT JOIN color c ON pv.color_id = c.color_id
    LEFT JOIN size_option so ON pv.size_id = so.size_id
GROUP BY 
    p.product_id, p.product_name, b.brand_name, pc.category_name, p.base_price;

-- 8. Get all products with their attributes and values
SELECT 
    p.product_name,
    GROUP_CONCAT(
        CONCAT(pa.attribute_name, ': ', pa.attribute_value)
        SEPARATOR ', '
    ) as attributes
FROM 
    product p
    LEFT JOIN product_attribute pa ON p.product_id = pa.product_id
GROUP BY 
    p.product_id, p.product_name;

-- 9. Get all products with their images
SELECT 
    p.product_name,
    GROUP_CONCAT(
        CONCAT(pi.image_url, ' (', IF(pi.is_primary, 'Primary', 'Secondary'), ')')
        SEPARATOR ', '
    ) as images
FROM 
    product p
    LEFT JOIN product_image pi ON p.product_id = pi.product_id
GROUP BY 
    p.product_id, p.product_name;

-- 10. Get all products with their complete pricing information
SELECT 
    p.product_name,
    p.base_price,
    MIN(pv.price_adjustment) as min_price_adjustment,
    MAX(pv.price_adjustment) as max_price_adjustment,
    MIN(p.base_price + pv.price_adjustment) as min_final_price,
    MAX(p.base_price + pv.price_adjustment) as max_final_price
FROM 
    product p
    LEFT JOIN product_variation pv ON p.product_id = pv.product_id
GROUP BY 
    p.product_id, p.product_name, p.base_price;