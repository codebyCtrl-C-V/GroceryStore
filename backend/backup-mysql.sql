-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: sql12.freesqldatabase.com    Database: sql12785487
-- ------------------------------------------------------
-- Server version	5.5.62-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `quantity` INT DEFAULT 1,
    `userId` INT NOT NULL,
    `productId` INT NOT NULL,
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT `fk_cart_user` 
        FOREIGN KEY (`userId`) REFERENCES `users`(`id`) 
        ON DELETE CASCADE,
    
    CONSTRAINT `fk_cart_product` 
        FOREIGN KEY (`productId`) REFERENCES `products`(`id`) 
        ON DELETE CASCADE,
    
    -- Index for better performance
    INDEX `idx_cart_user` (`userId`),
    INDEX `idx_cart_product` (`productId`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL UNIQUE,
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Index for better performance
    INDEX `idx_categories_slug` (`slug`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Trái cây','trai-cay','2025-03-02 22:38:32','2025-03-02 22:38:32'),(2,'Rau củ','rau-cu','2025-03-02 22:38:32','2025-03-02 22:38:32'),(3,'Đồ uống','do-uong','2025-03-02 22:38:32','2025-03-02 22:38:32'),(4,'Sản phẩm chế biến','san-pham-che-bien','2025-03-02 22:38:32','2025-03-02 22:38:32');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL UNIQUE,
    `content` TEXT NOT NULL,
    `image` VARCHAR(255) NOT NULL,
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Index for better performance
    INDEX `idx_news_slug` (`slug`),
    INDEX `idx_news_created` (`createdAt`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` (`id`,`title`,`slug`,`image`,`content`,`createdAt`,`updatedAt`) VALUES (1,'Thói quen tiết kiệm khi sử dụng thực phẩm: lợi ích và nguy cơ','thoi-quen-tiet-kiem-khi-su-dung-thuc-pham-loi-ich-va-nguy-co','https://res.cloudinary.com/dilsgqfex/image/upload/v1743063400/th%C3%B3i_quen_tk_ybrsmc.jpg','Tiết kiệm thực phẩm là một thói quen tốt, giúp giảm lãng phí, tiết kiệm chi phí và bảo vệ môi trường. Tuy nhiên, nếu không có cách bảo quản và sử dụng hợp lý, việc tận dụng thực phẩm quá mức có thể dẫn đến những rủi ro về sức khỏe, đặc biệt là nguy cơ ngộ độc thực phẩm hoặc làm thực phẩm biến chất.\r\nLợi ích của việc tiết kiệm thực phẩm hợp lý giúp tiết kiệm chi phí, giảm thiểu lãng phí và tiết kiệm tiền bạc cho gia đình. Bảo vệ môi trường, hạn chế rác thải thực phẩm, giảm áp lực lên môi trường. Tận dụng nguồn dinh dưỡng biết cách chế biến và bảo quản hợp lý giúp tận dụng tối đa giá trị dinh dưỡng của thực phẩm.\r\nTuy nhiên, nếu tiết kiệm thực phẩm không đúng cách, có thể gây nguy hiểm đến sức khỏe.\r\nNguy cơ khi sử dụng thực phẩm không đảm bảo: Việc quá tiết kiệm nhưng không kiểm soát chất lượng thực phẩm có thể gây ra nhiều hậu quả nghiêm trọng. Dưới đây là một số thói quen phổ biến tiềm ẩn nguy cơ.\r\nHâm lại thực phẩm nhiều lần: Nhiều gia đình có thói quen hâm lại đồ ăn nhiều lần để tiết kiệm, tuy nhiên việc hâm đi hâm lại khiến thực phẩm mất chất dinh dưỡng. Nếu bảo quản không đúng cách, vi khuẩn có thể phát triển, làm tăng nguy cơ ngộ độc thực phẩm. Một số thực phẩm như rau xanh khi hâm lại có thể sinh ra nitrat chuyển hóa thành nitrit – một chất gây hại cho sức khỏe.\r\nGiải pháp: Chỉ nên hâm lại một lần. Nếu có thể, hãy chia nhỏ thực phẩm và chỉ lấy lượng vừa đủ cho mỗi bữa để tránh hâm nhiều lần.\r\nDùng lại bát nước chấm và dầu chiên đi chiên lại nhiều lần:\r\nNước chấm dùng nhiều lần: Khi nước chấm bị dính thức ăn từ nhiều lần sử dụng, vi khuẩn có thể phát triển, gây đau bụng, tiêu chảy.\r\nDầu chiên lại nhiều lần: Khi dầu ăn được đun nóng liên tục, các chất béo có thể bị phân hủy, tạo ra các hợp chất có hại cho sức khỏe, thậm chí có nguy cơ gây ung thư.\r\nGiải pháp: Chỉ lấy lượng nước chấm vừa đủ, tránh để thừa. Nếu cần dùng lại, hãy bảo quản kín trong tủ lạnh và không sử dụng quá lâu. Dầu ăn chỉ nên dùng tối đa 2 lần, sau đó thay mới để đảm bảo an toàn.','2025-03-27 15:23:06','2025-05-05 17:19:58');
INSERT INTO `news` (`id`,`title`,`slug`,`image`,`content`,`createdAt`,`updatedAt`) VALUES (2,'Tác dụng của khoai lang','tac-dung-khoai-lang','https://res.cloudinary.com/dilsgqfex/image/upload/v1743063572/khoai-lang_z1pv3o.jpg','Khoai lang là thực phẩm giàu protein. Protein trong khoai lang rất đặc biệt do khả năng ức chế ung thư ruột kết và trực tràng ở người. Hàm lượng protein trong khoai lang càng cao thì khả năng ức chế hoạt động của tế bào ung thư càng lớn.\n1. Khoai lang có vị ngọt nhưng không làm tăng lượng đường huyết, mệt mỏi hay tăng cân. Đường tự nhiên trong khoai lang sẽ từ từ thẩm thấu vào máu, giúp cân bằng nguồn năng lượng cho cơ thể.\n\n2. Khoai lang là nguồn cung cấp chất xơ rất tốt, giúp duy trì đường huyết ở mức cân bằng.\n\n3. Cứ 100 g khoai lang nghiền cung cấp 86 calo, thấp hơn nhiều so với mức 118 calo trong 10 0g củ từ.\n\n4. Beta carotene là tiền chất của vitamin A trong cơ thể người. Vitamin A duy trì đôi mắt sáng và làn da khỏe mạnh. Đồng thời, beta caroten được chứng minh là có khả năng bảo vệ cơ thể khỏi những tác nhân gây ung thư. Đây cũng là một dưỡng chất dồi dào trong khoai lang.\n\n5. Hàm lượng vitamin B6 cao chứa trong khoai lang làm giảm homocysteine trong cơ thể. Homocysteine có liên quan đến các bệnh lý thoái hóa và tim mạch. Nồng độ homocysteine trong máu cao làm tăng nguy cơ xơ vữa động mạch, nhồi máu cơ tim và tai biến mạch máu não.\n\n6. Khoai lang là nguồn cung cấp vitamin C dồi dào, giúp ngăn ngừa cảm lạnh và virus cúm. Đồng thời, vitamin C cũng rất cần thiết cho xương và răng, tốt cho hệ tiêu hóa và quá trình hình thành các tế bào máu. Ngoài ra, vitamin C còn góp phần chữa lành vết thương, tạo ra collagen giữ cho làn da luôn tươi trẻ, giảm stress và bảo vệ cơ thể khỏi những độc tố có nguy cơ gây ung thư cao.\n\n7. Vitamin D trong khoai lang có tác dụng hỗ trợ hệ miễn dịch và tăng cường sức khoẻ tổng quát. Vitamin D góp phần giữ cho hệ xương, tim mạch, thần kinh, răng, da và tuyến giáp khỏe mạnh.\n\n8. Vi chất sắt trong khoai lang cung cấp năng lượng cho cơ thể, giảm stress, thúc đẩy sản xuất hồng cầu, bạch cầu, tăng cường miễn dịch và chuyển hoá protein.\n\n9. Khoai lang cũng là nguồn cung cấp magie rất tốt. Magie không những là khoáng chất quan trọng chống căng thẳng mà còn có ý nghĩa then chốt cho sự phát triển khỏe mạnh của cơ xương, tim mạch và các chức năng thần kinh.\n\n10. Kali là chất điện ly quan trọng giúp kiểm soát nhịp tim và các tín hiệu thần kinh. Cũng như các chất điện ly khác, kali đảm nhiệm nhiều chức năng thiết yếu trong đó có thư giãn co thắt cơ, giảm sưng, bảo vệ và kiểm soát hoạt động của thận. Khoai lang chính là nguồn cung cấp kali tuyệt vời mà bạn không thể bỏ qua.\n\n11. Màu cam trên vỏ khoai lang là dấu hiệu cho thấy mức carotene rất cao của loại củ này. Nhóm chất carotene giúp tăng thị lực, thúc đẩy hệ miễn dịch, chống oxy hóa và ngăn ngừa lão hóa. Một nghiên cứu do ĐH Harvard (Mỹ) thực hiện trên 124.000 người cho thấy, những người tiêu thụ thức ăn giàu carotene trong chế độ ăn uống thường xuyên của mình giảm tới hơn 32% nguy cơ ung thư phổi.','2025-03-27 15:23:06','2025-03-27 15:23:06');
INSERT INTO `news` (`id`,`title`,`slug`,`image`,`content`,`createdAt`,`updatedAt`) VALUES (3,'Các thực phẩm tốt cho người tiểu đường','thuc-pham-tot-cho-tieu-duong','https://res.cloudinary.com/dilsgqfex/image/upload/v1743063741/w320_h320_cac-thuc-pham-tot-cho-nguoi-tieu-duong_lzxd0r.jpg','Để kiểm soát đường huyết thành công, ngoài việc dùng thuốc, cần có chế độ ăn kiêng nhưng vẫn phải bảo đảm dinh dưỡng. Do đó, người tiểu đường nên biết cách nhận định chỉ số đường huyết của thực phẩm, từ đó biết cách cần giữ hay loại bỏ thực phẩm đó trong chế độ ăn hằng ngày.\nNhững thực phẩm đề cập trong bài viết này giúp ổn định đường huyết an toàn cho người bệnh đái tháo đường.\n\nNgười đái tháo đường nên chọn thực phẩm như thế nào?\nNgười đái tháo đường nên chọn thực phẩm GI (Glycemic Index  - chỉ số đường huyết) thấp. Đây là chỉ số được dùng để phản ánh tốc độ làm tăng lượng đường trong máu sau khi nạp chất bột đường vào cơ thể. GI thường được dùng để giúp người bệnh đái tháo đường kiểm soát lượng đường huyết hiệu quả. Chỉ số GI của một thực phẩm được phân làm 3 loại: thấp, trung bình và cao.\n\nThực phẩm có chỉ số GI cao (từ 70 trở lên) nghĩa là có thể làm tăng đường huyết nhanh, GI trung bình thường từ 56-69, còn GI thấp (≤ 55) là những thực phẩm làm mức đường huyết tăng từ từ đều đặn và cũng giảm chậm rãi, nhờ đó giữ được nguồn năng lượng ổn định, rất có lợi cho sức khỏe người bệnh đái tháo đường.','2025-03-27 15:23:06','2025-03-27 15:23:06');
INSERT INTO `news` (`id`,`title`,`slug`,`image`,`content`,`createdAt`,`updatedAt`) VALUES (4,'Thời điểm ăn sáng tốt nhất cho sức khỏe','thoi-diem-an-sang-tot','https://res.cloudinary.com/dilsgqfex/image/upload/v1743405336/Screenshot-2025-03-28-at-17-21-6588-2610-1743157590_vhhxmp.webp','Chuyên gia dinh dưỡng chia sẻ thời điểm ăn sáng lý tưởng là trước 8h30, giúp kiểm soát cân nặng, đường huyết và sức khỏe tim mạch.','2025-03-27 15:23:06','2025-03-31 15:23:06');
INSERT INTO `news` (`id`,`title`,`slug`,`image`,`content`,`createdAt`,`updatedAt`) VALUES (5,'Những thứ không thể thiếu trong ngày rằm','nhung-thu-trong-ngay-ram','https://res.cloudinary.com/dilsgqfex/image/upload/v1743405624/Banh-chung_euwzbc.webp','Thịt gà – Gà Ri Mối và Gà Tre\nĐúng là rất khó để tìm ra loại gà nào ngon như vậy, thớ thịt gà dai vừa phải, thơm ngọt, ăn không ngấy như các loại gà khác. Gà Ri Mối không lớn, mỗi con chỉ nặng khoảng hơn 1kg sau khi làm thịt xong, vừa đủ ăn từ hai đến ba người lớn hoặc một gia đình nhỏ.\nHoa quả tươi\nCác loại hoa quả tươi sẽ về theo mùa, nhưng loại đầu bảng là Chuối ngự Đại Hoàng thì nhà em luôn ưu tiên, tiếp đó có thanh long, cam sành, hồng xiêm, ổi Phúc Lợi…\nBánh chưng – Bánh chưng Đất Tổ\nĐể làm một chiếc bánh chưng Đất Tổ ngon có hình thức đẹp, vuông thành sắc cạnh, màu sắc tươi tắn, gạo rền, thơm hương thì đó là một kỳ công. Gạo nếp phải chọn những loại gạo dẻo, mười hạt như mười, có hương thơm đặc trưng và không lẫn tẻ. Đỗ xanh cần phải là loại hạt nhỏ và được chế biến từ khi vỡ đỗ, ngâm cho tróc vỏ, đãi sạch, để ráo đến khi đã nấu chín, như vậy nhân bánh mới thơm ngon. Ngoài đỗ, nhân bánh cần có thêm thịt ba chỉ hoặc nạc vai tươi sống trộn kèm gia vị muối, tiêu… vừa đủ tạo điểm nhấn và mùi thơm.','2025-03-31 14:21:42','2025-03-31 14:21:42');
INSERT INTO `news` (`id`,`title`,`slug`,`image`,`content`,`createdAt`,`updatedAt`) VALUES (6,'Vì sao nước muống luộc để lâu có màu xanh đậm?','vi-sao-nuoc-luoc-de-lau-co-mau-xanh-dam','https://res.cloudinary.com/dilsgqfex/image/upload/v1743405757/Nuoc-rau-muong_vilf9i.webp','Mô tả hiện tượng: nước luộc rau muống (hay lang), có thêm chút muối, khi vừa luộc xong màu nước bình thường. Tuy nhiên để nồi nước này tầm trên 1 tiếng thì nước chuyển màu như hình minh họa\n– Chlorophyll là chất diệp lục có trong rau, màu xanh đặc trưng của lá cây. Về tính chất hóa học, bởi chất diệp lục là một este nên nó có khả năng phản ứng với kiềm và với axit. Nhân Mg có vai trò lớn trong việc tạo nên màu xanh của diệp lục. Trong cấu tạo phân tử của chất diệp lục có chứa gốc Mg2+ , khi phản ứng với kiềm, nhân Mg không bị thay thế và màu sắc của diệp lục sẽ không thay đổi nhiều, nhưng do sự xuất hiện muối của kim loại kiềm, dịch sắc tố sẽ trở nên đục hơn. Gốc Mg2+ này dễ bị thay thế bằng các kim loại khác (Cu, Pb…) để tạo nên phức chất bền nhiệt hơn. Các phức chất mới này có màu xanh lục đậm.\nhất diệp lục phản ứng như một chất chỉ thị màu. Trong môi trường axit, sẽ có màu vàng đến đỏ ; môi trường kiềm sẽ có màu xanh. Vào thời tiết nồm ẩm, mưa nhiều, rau đang trong giai đoạn đầu mùa từ cằn phát triển lên, thời tiết thiếu nắng lượng diệp lục tăng, cộng thêm mưa (mưa miền bắc thường là mưa axit). Diệp lục bị mất màu xanh trong môi trường axit sẽ có thể tái tạo lại màu xanh với kim loại khác cho màu đậm hơn. Ở đây là sắt trong rau muống và các gốc kim loại khác trong nước.\n\nỞ Ngoài ra vào mùa đông, độ PH của nước sẽ thiên về kiềm hơn do ít hòa tan CO2 trong nước ( do nước lạnh hơn)\nTrong trường hợp nồi nấu là nồi nhôm, trong hợp kim nhôm (cấu tạo nên nồi nấu) luôn có sự hiện diện của đồng để cấu trúc cứng vững hơn. Trong nước luộc rau có chất diệp lục, vì vậy phản ứng xảy ra và nước rau sẽ có màu xanh như trường hợp miêu tả.\n\nĐối với dư lượng nitrat cao ( do phân bón lá) nước luộc rau sẽ chuyển màu xanh đen, có vẩn kết tủa đen. Còn đồi với rau muống nhiễm chì, lá thường có màU xanh đen, luộc nước có màu xanh đen và khi vắt chanh hay dầm sấu nước sẽ không chuyển lại màu trong.','2025-03-31 14:24:16','2025-03-31 14:24:16');

/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `orderId` INT NOT NULL,
    `productId` INT NOT NULL,
    `quantity` INT NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `total` DECIMAL(10, 2) NOT NULL,
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT `fk_order_detail_order` 
        FOREIGN KEY (`orderId`) REFERENCES `orders`(`id`) 
        ON DELETE CASCADE,
    
    CONSTRAINT `fk_order_detail_product` 
        FOREIGN KEY (`productId`) REFERENCES `products`(`id`) 
        ON DELETE CASCADE,
    
    -- Index for better performance
    INDEX `idx_order_details_order` (`orderId`),
    INDEX `idx_order_details_product` (`productId`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,1,6,1,20000,20000,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(2,1,40,2,25000,50000,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(3,1,37,1,18400,18400,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(4,1,20,1,51000,51000,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(5,1,1,2,24650,49310,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(6,1,15,4,35000,140000,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(7,1,3,4,32000,128000,'2025-04-11 16:28:38','2025-04-11 16:28:38'),(8,5,28,8,9600,76800,'2025-04-11 17:03:52','2025-04-11 17:03:52'),(9,5,1,1,24650,24650,'2025-04-11 17:03:52','2025-04-11 17:03:52'),(10,6,2,2,42000,84000,'2025-04-14 14:53:19','2025-04-14 14:53:19'),(11,6,7,3,15000,45000,'2025-04-14 14:53:19','2025-04-14 14:53:19'),(12,7,3,2,32000,64000,'2025-04-14 14:56:57','2025-04-14 14:56:57'),(13,8,1,1,24650,24650,'2025-04-14 15:00:24','2025-04-14 15:00:24'),(14,9,5,3,25500,76500,'2025-04-15 15:07:49','2025-04-15 15:07:49'),(15,10,9,1,30000,30000,'2025-04-15 15:21:30','2025-04-15 15:21:30'),(16,10,10,1,39000,39000,'2025-04-15 15:21:30','2025-04-15 15:21:30'),(17,10,8,2,23800,47600,'2025-04-15 15:21:30','2025-04-15 15:21:30'),(18,10,37,3,18400,55200,'2025-04-15 15:21:30','2025-04-15 15:21:30'),(19,11,18,1,64000,64000,'2025-04-15 15:22:50','2025-04-15 15:22:50'),(20,11,31,1,8000,8000,'2025-04-15 15:22:50','2025-04-15 15:22:50'),(21,12,3,1,32000,32000,'2025-04-15 15:29:11','2025-04-15 15:29:11'),(22,13,2,1,42000,42000,'2025-04-15 16:08:06','2025-04-15 16:08:06'),(23,14,1,3,24650,73950,'2025-04-15 16:09:53','2025-04-15 16:09:53'),(24,15,7,1,15000,15000,'2025-04-15 16:19:09','2025-04-15 16:19:09'),(25,16,3,1,32000,32000,'2025-04-15 16:23:51','2025-04-15 16:23:51'),(26,17,4,1,10000,10000,'2025-04-15 16:29:14','2025-04-15 16:29:14'),(27,18,42,2,28000,56000,'2025-05-13 15:19:58','2025-05-13 15:19:58'),(28,18,2,2,42000,84000,'2025-05-13 15:19:58','2025-05-13 15:19:58'),(29,18,10,1,39000,39000,'2025-05-13 15:19:58','2025-05-13 15:19:58'),(30,19,3,1,32000,32000,'2025-05-13 16:08:55','2025-05-13 16:08:55'),(31,20,1,1,24650,24650,'2025-05-13 16:18:37','2025-05-13 16:18:37'),(32,21,2,4,42000,168000,'2025-05-27 14:52:14','2025-05-27 14:52:14'),(33,21,3,1,32000,32000,'2025-05-27 14:52:14','2025-05-27 14:52:14');
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `userId` INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(255) NOT NULL,
    `address` TEXT NOT NULL,
    `paymentMethod` VARCHAR(255) NOT NULL,
    `total` DECIMAL(10, 2) NOT NULL,
    `status` ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT `fk_order_user` 
        FOREIGN KEY (`userId`) REFERENCES `users`(`id`) 
        ON DELETE CASCADE,
    
    -- Index for better performance
    INDEX `idx_orders_user` (`userId`),
    INDEX `idx_orders_status` (`status`),
    INDEX `idx_orders_created` (`createdAt`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,10,'Tdnbict','0123456788','hust','cod',456700,'pending','2025-04-11 16:28:38','2025-04-11 16:28:38'),(2,10,'dien1234','0944538620','avtvn','online',177000,'completed','2025-04-11 16:54:14','2025-04-14 15:25:49'),(3,10,'Tdnbict','0944538620','1111','cod',30000,'cancelled','2025-04-11 16:58:52','2025-04-14 15:35:13'),(4,10,'Tdnbict','1234567890','cvvvv','cod',76800,'cancelled','2025-04-11 17:02:31','2025-04-14 15:26:08'),(5,10,'Tdnbict','0123456789','assssssssssssss','cod',101450,'cancelled','2025-04-11 17:03:52','2025-04-15 15:05:59'),(6,10,'Tdnbict','0944538620','hn','cod',129000,'processing','2025-04-14 14:53:19','2025-04-14 14:53:19'),(7,10,'asp core .net','0944538620','gg','cod',64000,'pending','2025-04-14 14:56:57','2025-04-14 14:56:57'),(8,10,'asp core .net','0944538620','hn','cod',24650,'cancelled','2025-04-14 15:00:24','2025-04-14 15:00:33'),(9,10,'asp core .net','0944538620','tt-hn','online',76500,'pending','2025-04-15 15:07:49','2025-04-15 15:07:49'),(10,10,'dien','0123456788','hn','cod',171800,'pending','2025-04-15 15:21:30','2025-04-15 15:21:30'),(11,10,'dien','0123456788','n?','online',72000,'pending','2025-04-15 15:22:50','2025-04-15 15:22:50'),(12,15,'dien','0123456789','123','cod',32000,'pending','2025-04-15 15:29:11','2025-04-15 15:29:11'),(13,10,'Tdnbict','0944538620','hn','cod',42000,'pending','2025-04-15 16:08:06','2025-04-15 16:08:06'),(14,10,'td123','0944538620','ccc','cod',73950,'processing','2025-04-15 16:09:53','2025-04-16 10:39:46'),(15,10,'Tdnbict','0123456788','hn','cod',15000,'cancelled','2025-04-15 16:19:09','2025-04-15 16:19:18'),(16,10,'dien1234','0944538620','gg','cod',32000,'pending','2025-04-15 16:23:51','2025-04-15 16:23:51'),(17,10,'Tdnbict','0944538620','hn','cod',10000,'pending','2025-04-15 16:29:14','2025-05-05 17:00:30'),(18,10,'tran dien','0123456788','hn','cod',179000,'pending','2025-05-13 15:19:58','2025-05-13 15:19:58'),(19,10,'tran dien','0123456788','gh','online',32000,'pending','2025-05-13 16:08:55','2025-05-13 16:08:55'),(20,10,'tran dien','0123456789','thanh trì','online',24650,'pending','2025-05-13 16:18:37','2025-05-13 16:18:37'),(21,1,'tran dien','0123456788','ddd','cod',200000,'cancelled','2025-05-27 14:52:14','2025-05-27 14:52:31');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `orderId` INT NOT NULL,
    `paymentMethod` ENUM('cod', 'online') NOT NULL,
    `status` ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT `fk_payment_order` 
        FOREIGN KEY (`orderId`) REFERENCES `orders`(`id`) 
        ON DELETE CASCADE,
    
    -- Index for better performance
    INDEX `idx_payments_order` (`orderId`),
    INDEX `idx_payments_status` (`status`),
    INDEX `idx_payments_method` (`paymentMethod`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,10,'cod','pending','2025-04-15 15:21:30','2025-04-15 15:21:30'),(2,11,'online','paid','2025-04-15 15:22:50','2025-04-15 15:22:50'),(3,12,'cod','pending','2025-04-15 15:29:11','2025-04-15 15:29:11'),(4,13,'cod','pending','2025-04-15 16:08:06','2025-04-15 16:08:06'),(5,14,'cod','pending','2025-04-15 16:09:53','2025-04-15 16:09:53'),(6,15,'cod','pending','2025-04-15 16:19:09','2025-05-05 16:45:05'),(7,16,'cod','pending','2025-04-15 16:23:51','2025-04-15 16:23:51'),(8,17,'cod','paid','2025-04-15 16:29:14','2025-04-23 15:10:11'),(9,18,'cod','pending','2025-05-13 15:19:58','2025-05-13 15:19:58'),(10,19,'online','paid','2025-05-13 16:08:55','2025-05-13 16:08:55'),(11,20,'online','paid','2025-05-13 16:18:37','2025-05-13 16:18:37'),(12,21,'cod','pending','2025-05-27 14:52:14','2025-05-27 14:52:14');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL UNIQUE,
    `description` TEXT,
    `price` DECIMAL(10, 2) NOT NULL,
    `stock` INT DEFAULT 0,
    `image` VARCHAR(255),
    `sale` INT DEFAULT 0,
    `category_id` INT,
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    CONSTRAINT `fk_product_category` 
        FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) 
        ON DELETE SET NULL,
    
    -- Index for better performance
    INDEX `idx_products_slug` (`slug`),
    INDEX `idx_products_category` (`category_id`),
    INDEX `idx_products_price` (`price`),
    INDEX `idx_products_stock` (`stock`),
    INDEX `idx_products_sale` (`sale`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (1,'Cà rốt (500g)','ca-rot','Là một loại củ rất quen thuộc trong các món ăn của người Việt. Loại củ này có hàm lượng chất dinh dưỡng và vitamin A cao, được xem là nguyên liệu cần thiết cho các món ăn dặm của trẻ nhỏ, giúp trẻ sáng mắt và cung cấp nguồn chất xơ dồi dào.\r\n\r\nCà rốt không chỉ là loại củ quen thuộc trong các món ăn trong gia đình mà còn là vị thuốc quý, rất tốt cho sức khỏe. Với hàm lượng chất dinh dưỡng và vitamin A cao, cà rốt được xem là một nguyên liệu cần thiết cho các món ăn dặm của trẻ nhỏ, giúp trẻ sáng mắt và cung cấp nguồn chất xơ dồi dào. \r\n\r\nNgoài ra, cà rốt còn được xem là một \"thần dược\" trong quá trình chăm sóc da của phụ nữ. Chỉ với những bước làm đơn giản là bạn đã có ngay hỗn hợp mặt nạ cà rốt - mật ong giúp ngăn ngừa mụn, làm sáng da và cải thiện làn da sạm và lão hóa. ',29000,15,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461053/c%C3%A0_r%E1%BB%91t-removebg-preview_kdo6dr.png',15,'2025-03-08 23:00:26','2025-04-17 17:36:07');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (2,'Bông cải xanh (400g)','bong-cai-xanh','Bông cải xanh là một loại rau xanh có hình dạng giống một cái cây thu nhỏ. Nó thuộc về loài thực vật được gọi là Brassica oleracea, cùng gia đình cải xoăn và súp lơ và đều chung họ rau cải.',42000,12,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461049/s%C3%BAp_l%C6%A1-removebg-preview_jetg9l.png',0,'2025-03-08 23:04:15','2025-04-22 16:10:25');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (3,'Hành tây (500g)','hanh-tay','Hành tây là loại củ có hình dạng giống bóng đèn tròn, còn được gọi là hành củ hay củ hành. Hành tây mọc dưới lòng đất, được trồng phổ biến trên toàn thế giới và có quan hệ gần với hẹ, tỏi và hành lá. Đây là nguyên liệu chủ yếu trong nhiều món ăn, được chế biến rất đa dạng, từ nướng, luộc, chiên, rang, xào, lăn bột hoặc thậm chí là ăn sống.',32000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461050/h%C3%A0nh_t%C3%A2y_%C4%91%E1%BB%8F-removebg-preview_becpmp.png',0,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (4,'Rau mùi (200g)','rau-mui','Rau mùi ăn kèm trong bữa ăn.',10000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461050/rau_m%C3%B9i_t%C3%A2y-removebg-preview_y4gxdq.png',0,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (5,'Ớt chuông đỏ (300g)','ot-chuong-do','Ớt chuông được gọi là ớt ngọt vì nó không có vị cay gắt như ớt cay, được trồng nhiều ở Đà Lạt nên còn gọi là ớt Đà Lạt. Ớt chuông có nhiều màu: xanh, đỏ, vàng.',30000,150,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461050/%E1%BB%9Bt-removebg-preview_ptqlrn.png',15,'2025-03-08 23:19:16','2025-04-16 10:05:35');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (6,'Ngô (500g)','ngo','Ngô ngọt thơm ngon bổ dưỡng.',20000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461050/ng%C3%B4-removebg-preview_e8uqua.png',0,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (7,'Củ cải trắng (1kg)','cui-cai-trang','Củ cải ngon, ngọt.',15000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461050/c%E1%BB%A7_c%E1%BA%A3i-removebg-preview_osio8o.png',0,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (8,'Mướp (300g)','muop','là một loại mướp nhỏ, tươi ngon, có mùi hương đặc trưng và vị ngọt thanh. Được trồng trong môi trường an toàn, sản phẩm này không chứa hóa chất hay thuốc trừ sâu, mang lại sự an tâm cho người tiêu dùng. Với kích thước nhỏ gọn và chất lượng vượt trội, mướp hương baby rất phù hợp cho các món ăn bổ dưỡng và dễ chế biến.',28000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461049/m%C6%B0%E1%BB%9Bp-removebg-preview_lwt5sh.png',15,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (9,'Mướp đắng (300g)','muop-dang','Tốt cho sức khoẻ.',30000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461049/m%C6%B0%E1%BB%9Bp_%C4%91%E1%BA%AFng-removebg-preview_jawaru.png',0,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (10,'Cà chua (500g)','ca-chua','Cà chua chứa rất nhiều giá trị dinh dưỡng tốt cho sức khỏe như Vitamin C, Vitamin A và đặc biệt loại quả này rất giàu Lycopene. Đây là một chất rất bổ dưỡng có trong cà chua chín. Chúng có vai trò đáng kể trong việc phòng ngừa các bệnh mãn tính như ung thư, bệnh tim mạch, loãng xương và bệnh tiểu đường. Cà chua càng đỏ thì càng chứa nhiều Lycopene.\nCà chua rất giàu vitamin A, C, K, vitamin B6, kali, folate, thiamin, magiê, niacin, đồng và phốt pho, là những vi chấtcần thiết để duy trì một sức khỏe tốt. Điều tuyệt vời hơn ở cà chua là chúng chứa rất ít cholesterol, chất béo bão hòa, natri và calo. \n\nBạn có thể ăn cà chua sống kẹp với bánh mì, làm salad, nước sốt, sinh tố, thậm chí nấu súp.',39000,10,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461049/c%C3%A0_chua-removebg-preview_dwapb0.png',0,'2025-03-08 23:19:16','2025-03-08 23:19:16');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (11,'Cà tím (400g)','ca-tim','Cà tím được trồng để lấy quả và là một trong những loại nông sản được trồng nhiều trên thế giới. Thậm chí ở Ấn Độ, cà tím được xếp trong danh sánh Vua của các loại rau củ về giá trị dinh dưỡng và mức độ ưa chuộng của nó.',27000,115,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461050/c%C3%A0_t%C3%ADm-removebg-preview_p6kk8i.png',0,'2025-03-08 23:19:16','2025-04-16 10:03:11');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (12,'Dừa (1 quả)','dua','Dừa tươi là loại trái cây nhiệt đới phổ biến, được yêu thích nhờ nước dừa ngọt thanh và cơm dừa béo ngậy. Nước dừa chứa nhiều khoáng chất như kali, magiê, rất tốt cho việc bù nước và tăng cường sức khỏe. Dừa có thể uống trực tiếp, làm sinh tố hoặc dùng cơm dừa trong các món tráng miệng.',15000,10,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461521/d%E1%BB%ABa-removebg-preview_cfxboj.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (13,'Đu đủ (1kg)','du-du','Đu đủ chín có màu cam rực rỡ, vị ngọt thanh và chứa nhiều vitamin A, C, E cùng enzyme papain hỗ trợ tiêu hóa. Đây là loại trái cây bổ dưỡng, thường được ăn trực tiếp, làm sinh tố hoặc salad. Đu đủ còn tốt cho da và hệ miễn dịch.',25000,10,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461522/%C4%91u_%C4%91%E1%BB%A7-removebg-preview_aomoug.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (14,'Vải (1kg)','vai','Vải là loại trái cây mùa hè nổi tiếng với vị ngọt đậm đà, thịt quả mọng nước. Vải chứa nhiều vitamin C, chất xơ và chất chống oxy hóa, giúp tăng cường sức khỏe tim mạch và làm đẹp da. Có thể ăn tươi hoặc sấy khô.',45000,1,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461527/v%E1%BA%A3i-removebg-preview_vm7oyr.png',15,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (15,'Cam (1kg)','cam','Cam là nguồn cung cấp vitamin C dồi dào, có vị ngọt nhẹ hoặc chua thanh tùy loại. Cam giúp tăng cường hệ miễn dịch, hỗ trợ tiêu hóa và làm đẹp da. Ngoài ăn trực tiếp, cam còn được ép nước hoặc dùng làm mứt.',35000,1,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461522/cam-removebg-preview_eptghw.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (16,'Sầu riêng (1kg)','sau-rieng','Sầu riêng được mệnh danh là \"vua của các loại trái cây\" nhờ hương vị đậm đà, béo ngậy và mùi thơm đặc trưng. Dù mùi hơi khó chịu với một số người, sầu riêng rất giàu năng lượng, vitamin B, C và kali. Thích hợp ăn tươi hoặc làm kem, bánh.',90000,1,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461522/s%E1%BA%A7u_ri%C3%AAng-removebg-preview_iiajr7.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (17,'Thanh long (1kg)','thanh-long','Thanh long có vỏ đỏ hoặc trắng, ruột trắng hoặc đỏ, vị ngọt nhẹ và chứa nhiều chất xơ, vitamin C. Đây là loại trái cây ít calo, hỗ trợ giảm cân, tốt cho tiêu hóa và làm đẹp da. Thường ăn tươi hoặc làm sinh tố.',30000,1,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461522/thanh_long-removebg-preview_untm5d.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (18,'Việt quất (200g)','viet-quat','Việt quất là loại trái cây nhỏ nhưng giàu chất chống oxy hóa, vitamin C và K. Có vị ngọt nhẹ xen chút chua, việt quất giúp cải thiện sức khỏe tim mạch, trí não và chống lão hóa. Thích hợp ăn tươi, làm bánh hoặc sinh tố.',80000,1,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461520/nho-removebg-preview_aebdp7.png',20,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (19,'Bơ (1kg)','bo','Bơ có vị béo nhẹ, chứa nhiều chất béo lành mạnh, vitamin E, K và kali. Đây là loại trái cây lý tưởng cho người ăn kiêng, hỗ trợ sức khỏe tim mạch và làm đẹp da. Có thể ăn trực tiếp, làm sinh tố hoặc salad.',40000,1,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461524/b%C6%A1-removebg-preview_hq7gwj.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (20,'Táo (1kg)','tao','Táo có vị giòn ngọt, giàu chất xơ, vitamin C và chất chống oxy hóa. Táo giúp giảm cholesterol, hỗ trợ tiêu hóa và tốt cho sức khỏe tim mạch. Thường ăn tươi, làm nước ép hoặc bánh nướng.',60000,0,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461521/t%C3%A1o-removebg-preview_ykardh.png',15,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (21,'Xoài (1kg)','xoai','Xoài chín có vị ngọt đậm, thơm ngon, chứa nhiều vitamin A, C và chất xơ. Xoài tốt cho mắt, da và hệ miễn dịch. Có thể ăn tươi, làm sinh tố, kem hoặc nước ép.',35000,0,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461521/xo%C3%A0i-removebg-preview_pyqu3r.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (22,'Kiwi (1kg)','kiwi','Kiwi có vỏ nâu, ruột xanh hoặc vàng, vị chua ngọt đặc trưng. Kiwi rất giàu vitamin C, E và chất xơ, hỗ trợ tiêu hóa, tăng cường miễn dịch và làm đẹp da. Thích hợp ăn tươi hoặc làm sinh tố.',70000,0,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461521/kiwi-removebg-preview_pkxogy.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (23,'Lựu (1kg)','luu','Lựu có hạt đỏ mọng, vị ngọt chua, chứa nhiều chất chống oxy hóa, vitamin C và K. Lựu giúp cải thiện sức khỏe tim mạch, chống viêm và làm đẹp da. Thường ăn hạt hoặc ép lấy nước.',65000,5,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461522/l%E1%BB%B1u-removebg-preview_rncii9.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (24,'Dứa (1 quả)','dua-thom','Dứa (thơm) có vị ngọt chua, chứa enzyme bromelain hỗ trợ tiêu hóa và nhiều vitamin C. Dứa tốt cho hệ miễn dịch và giảm viêm. Có thể ăn tươi, ép nước hoặc dùng trong món tráng miệng.',20000,5,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461528/d%E1%BB%A9a-removebg-preview_kw2c7s.png',15,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (25,'Đào (1kg)','dao','Đào có vỏ mỏng, thịt quả ngọt mềm, chứa vitamin A, C và chất xơ. Đào giúp làm đẹp da, hỗ trợ tiêu hóa và tăng cường sức khỏe mắt. Thích hợp ăn tươi hoặc làm mứt, bánh.',75000,5,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461521/%C4%91%C3%A0o-removebg-preview_vtyzuu.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (26,'Nho (1kg)','nho','Nho có nhiều loại: xanh, đỏ, đen, vị ngọt thanh hoặc chua nhẹ. Nho chứa resveratrol – chất chống oxy hóa tốt cho tim mạch, cùng vitamin C và K. Thường ăn tươi, làm nước ép hoặc sấy khô thành nho khô.',80000,5,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461520/nho-removebg-preview_aebdp7.png',0,'2025-03-20 11:01:33','2025-03-20 11:01:33');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (27,'Pepsi (330ml)','pepsi','Pepsi là loại nước giải khát có ga nổi tiếng với hương vị cola đậm đà, sảng khoái. Được đóng trong lon hoặc chai tiện lợi, Pepsi chứa đường và caffeine, mang lại cảm giác tươi mát, thích hợp uống lạnh hoặc dùng trong các bữa tiệc.',10000,5,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461924/pepsi-removebg-preview_hfazb6.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (28,'Chai Coca-Cola (500ml)','chai-cocacola','Coca-Cola là nước ngọt có ga kinh điển, có hương vị cola độc đáo, ngọt thanh và chút kích thích từ caffeine. Đóng trong chai nhựa tiện dụng, sản phẩm này rất phổ biến trên toàn thế giới, phù hợp để giải khát mọi lúc mọi nơi.',12000,8,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461924/coca_chai-removebg-preview_noaepx.png',20,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (29,'Fanta (330ml)','fanta','Fanta là nước ngọt có ga với hương cam tươi mát, màu sắc bắt mắt và vị ngọt dịu. Không chứa caffeine, Fanta là lựa chọn tuyệt vời cho những ai muốn thưởng thức đồ uống nhẹ nhàng, đặc biệt thích hợp cho trẻ em hoặc các buổi picnic.',10000,8,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461923/fanta-removebg-preview_rouq8t.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (30,'Nước kiwi (500ml)','nuoc-kiwi','Nước kiwi là đồ uống tự nhiên được ép từ quả kiwi tươi, mang hương vị chua ngọt đặc trưng. Giàu vitamin C và chất xơ, nước kiwi giúp tăng cường miễn dịch, hỗ trợ tiêu hóa và làm đẹp da. Thích hợp uống lạnh hoặc thêm đá.',25000,8,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461924/n%C6%B0%C6%A1c_kiwi-removebg-preview_evpym9.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (31,'Sprite (330ml)','sprite','Sprite là nước ngọt có ga với hương chanh tươi mát, không chứa caffeine. Vị ngọt nhẹ và cảm giác sủi bọt giúp Sprite trở thành lựa chọn hoàn hảo để giải nhiệt trong ngày nóng, đặc biệt khi uống lạnh.',10000,8,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461923/sprite-removebg-preview_qzokf6.png',20,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (32,'Lon Coca-Cola (330ml)','lon-cocacola','Coca-Cola lon là phiên bản nhỏ gọn của nước ngọt có ga nổi tiếng, hương vị cola đậm đà, sảng khoái. Với thiết kế lon tiện lợi, sản phẩm này dễ mang theo và phù hợp cho các bữa ăn nhanh hoặc khi di chuyển.',10000,8,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461932/cocacola-removebg-preview_fcu2kd.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (33,'Nước ép táo (500ml)','nuoc-ep-tao','Nước ép táo được làm từ táo tươi, có vị ngọt thanh và hương thơm dịu nhẹ. Giàu vitamin C, chất xơ và chất chống oxy hóa, nước ép táo hỗ trợ tiêu hóa, tốt cho tim mạch và làn da. Uống lạnh hoặc thêm đá都很 ngon.',28000,8,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461923/n%C6%B0%E1%BB%9Bc_%C3%A9p_t%C3%A1o-removebg-preview_ws2g3y.png',15,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (35,'Nước dứa (500ml)','nuoc-dua','Nước dứa (nước thơm) được ép từ dứa tươi, có vị ngọt chua hài hòa và hương thơm đặc trưng. Giàu vitamin C và enzyme bromelain, nước dứa hỗ trợ tiêu hóa, tăng cường miễn dịch và rất thích hợp để giải khát ngày hè.',25000,1,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461924/n%C6%B0%E1%BB%9Bc_d%E1%BB%A9a-removebg-preview_cgm5bg.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (36,'Nước chanh (500ml)','nuoc-chanh','Nước chanh là đồ uống đơn giản nhưng sảng khoái, được làm từ chanh tươi, có vị chua nhẹ và ngọt tùy khẩu vị. Chứa nhiều vitamin C, nước chanh giúp giải độc cơ thể, tăng cường miễn dịch và làm đẹp da.',20000,1,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461924/n%C6%B0%E1%BB%9Bc_chanh-removebg-preview_pyo1e9.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (37,'Nước dưa hấu (500ml)','nuoc-dua-hau','Nước dưa hấu được ép từ dưa hấu tươi, mang vị ngọt mát và màu đỏ bắt mắt. Loại nước này chứa lycopene, vitamin A, C, giúp cấp nước, chống oxy hóa và hỗ trợ sức khỏe tim mạch. Uống lạnh rất tuyệt vời.',23000,1,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461923/n%C6%B0%E1%BB%9Bc_d%C6%B0a_h%E1%BA%A5u-removebg-preview_k4zwqk.png',20,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (38,'Nước ép dâu tây (500ml)','nuoc-ep-dau-tay','Nước ép dâu tây có hương vị ngọt ngào, chua nhẹ từ dâu tây tươi, giàu vitamin C và chất chống oxy hóa. Đồ uống này không chỉ ngon mà còn tốt cho da, mắt và hệ miễn dịch. Phù hợp làm thức uống giải khát hoặc tráng miệng.',30000,1,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742461924/n%C6%B0%E1%BB%9Bc_%C3%A9p_d%C3%A2u_t%C3%A2y-removebg-preview_zp0ukb.png',0,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (39,'Nước cam (500ml)','nuoc-cam','Nước cam được ép từ cam tươi, có vị ngọt hoặc chua thanh tùy loại. Là nguồn vitamin C dồi dào, nước cam giúp tăng cường miễn dịch, hỗ trợ tiêu hóa và làm đẹp da. Thích hợp uống vào buổi sáng hoặc bất kỳ lúc nào trong ngày.',27000,0,3,'https://res.cloudinary.com/dilsgqfex/image/upload/v1741275375/n%C6%B0%E1%BB%9Bc_cam_ev4s7h.png',15,'2025-03-20 11:09:05','2025-03-20 11:09:05');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (40,'Đường nâu (500g)','duong-nau','Đường nâu là loại đường được chế biến từ mía, có màu nâu đặc trưng nhờ giữ lại mật mía. Vị ngọt dịu, thơm nhẹ, đường nâu thường được dùng trong nấu ăn, làm bánh, pha chế đồ uống hoặc ướp thực phẩm để tăng hương vị tự nhiên.',25000,0,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462341/%C4%91%C6%B0%E1%BB%9Dng_n%C3%A2u-removebg-preview_mjeitx.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (41,'Quế (100g)','que','Quế là gia vị được làm từ vỏ cây quế, có mùi thơm ấm áp và vị ngọt nhẹ. Quế không chỉ dùng để nêm nếm món ăn, làm bánh mà còn tốt cho sức khỏe nhờ chứa chất chống oxy hóa, hỗ trợ kiểm soát đường huyết và tăng cường tuần hoàn.',30000,0,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462342/qu%C3%A9-removebg-preview_k48ema.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (42,'Salad rau (200g)','salad-rau','Salad rau là món ăn chế biến sẵn từ các loại rau xanh như xà lách, cải xanh, kết hợp với sốt nhẹ. Giàu chất xơ, vitamin và khoáng chất, salad rau là lựa chọn lý tưởng cho bữa ăn lành mạnh, hỗ trợ giảm cân và tốt cho tiêu hóa.',35000,1,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462342/salad_rau-removebg-preview_flpjjo.png',20,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (43,'Salad trái cây (200g)','salad-trai-cay','Salad trái cây được làm từ các loại trái cây tươi như táo, nho, dứa, trộn với sốt sữa chua hoặc mật ong. Ngọt thanh, giàu vitamin C và chất chống oxy hóa, món này thích hợp làm món tráng miệng hoặc bữa phụ bổ dưỡng.',40000,1,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462349/salad_tr%C3%A1i_c%C3%A2y-removebg-preview_yaexo6.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (44,'Thịt lợn (500g)','thit-lon','Thịt lợn là thực phẩm chế biến sẵn, được sơ chế sạch sẽ, thích hợp để nướng, xào, luộc hoặc làm nhân bánh. Giàu protein, vitamin B và kẽm, thịt lợn là nguyên liệu phổ biến trong bữa ăn gia đình.',70000,1,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462348/th%E1%BB%8Bt_l%E1%BB%A3n-removebg-preview_webgih.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (45,'Thịt gà (500g)','thit-ga','Thịt gà được chế biến từ gà ta hoặc gà công nghiệp, ít chất béo, giàu protein và các axit amin thiết yếu. Thịt gà phù hợp để nấu súp, nướng, chiên hoặc làm gỏi, là lựa chọn lành mạnh cho chế độ ăn uống.',60000,2,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462341/th%E1%BB%8Bt_g%C3%A0-removebg-preview_wsfiyl.png',15,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (46,'Thịt bò (500g)','thit-bo','Thịt bò là loại thực phẩm cao cấp, giàu protein, sắt và vitamin B12, hỗ trợ phát triển cơ bắp và bổ máu. Được sơ chế sạch, thịt bò thích hợp để làm bít tết, xào, nướng hoặc nấu phở.',120000,2,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462342/th%E1%BB%8Bt_b%C3%B2-removebg-preview_akjeep.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (47,'Trứng (10 quả)','trung','Trứng gà hoặc trứng vịt là thực phẩm chế biến sẵn, giàu protein, choline và các vi chất cần thiết cho cơ thể. Trứng có thể luộc, chiên, ốp la hoặc làm bánh, là nguyên liệu không thể thiếu trong gian bếp.',30000,2,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462348/tr%E1%BB%A9ng-removebg-preview_iffpcj.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (48,'Thịt xay (500g)','thit-xay','Thịt xay thường được làm từ thịt lợn, bò hoặc kết hợp, đã qua sơ chế để tiện sử dụng. Giàu protein, thịt xay phù hợp làm chả, nhân bánh, hoặc xào với rau củ, mang lại bữa ăn nhanh chóng và ngon miệng.',75000,2,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462342/th%E1%BB%8Bt_xay-removebg-preview_pxsutd.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (49,'Đậu phụ (200g)','dau-phu','Đậu phụ phomai là sản phẩm chế biến từ đậu nành, có vị béo nhẹ và kết cấu mềm mịn. Giàu protein thực vật và canxi, sản phẩm này thích hợp cho người ăn chay, có thể chiên, nướng hoặc ăn kèm sốt.',20000,2,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462342/%C4%91%E1%BA%ADu_ph%E1%BB%A5-removebg-preview_vfvkkd.png',15,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (50,'Nho khô (200g)','nho-kho','Nho khô được làm từ nho tươi sấy khô, có vị ngọt đậm và hương thơm đặc trưng. Giàu chất xơ, sắt và chất chống oxy hóa, nho khô là món ăn vặt bổ dưỡng, dùng trong làm bánh hoặc trộn salad.',45000,1,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462343/nho_kh%C3%B4-removebg-preview_h933pq.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (51,'Salad rau củ (200g)','salad-rau-cu','Salad rau củ kết hợp rau xanh và củ như cà rốt, dưa chuột, khoai tây, trộn với sốt nhẹ. Giàu vitamin, khoáng chất và chất xơ, món này hỗ trợ tiêu hóa, giảm cân và là lựa chọn tuyệt vời cho chế độ ăn lành mạnh.',38000,0,4,'https://res.cloudinary.com/dilsgqfex/image/upload/v1742462349/salad_rau_c%E1%BB%A7-removebg-preview_qpq4ge.png',0,'2025-03-20 11:14:58','2025-03-20 11:14:58');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (58,'Đu đủ (1 quả)','chuoi-10-qua','Ngon, bổ dưỡng, thơm ngọt',15000,20,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1745313955/products/ysnujcxujdcr3t6g5e3b.jpg',15,'2025-04-22 16:24:32','2025-04-22 16:25:55');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (60,'Chanh (1 quả)','chanh-1-qua','thơm',5000,100,2,'https://res.cloudinary.com/dilsgqfex/image/upload/v1746436206/products/ptsinoftnxxsnrzig7jp.jpg',0,'2025-05-05 16:02:41','2025-06-10 16:21:28');
INSERT INTO `products` (`id`,`name`,`slug`,`description`,`price`,`stock`,`category_id`,`image`,`sale`,`createdAt`,`updatedAt`) VALUES (61,'Na (1 kg)','na-1-kg','Thơm, ngon, chín mọng. Tốt cho sức khoẻ.',39000,15,1,'https://res.cloudinary.com/dilsgqfex/image/upload/v1749547519/products/qyhkq0neiyo7kvizxwnl.png',10,'2025-06-10 16:25:20','2025-06-10 16:25:20');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(255),
    `address` TEXT,
    `role` ENUM('customer', 'admin') DEFAULT 'customer',
    `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Index for better performance
    INDEX `idx_users_email` (`email`),
    INDEX `idx_users_role` (`role`),
    INDEX `idx_users_phone` (`phone`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (1,'Trần Văn Điền','trandiengtc@gmail.com','$2b$10$x9uMg.EPoJFya7EXsrRLvuejO5H4WaGejEL2SQWRtRqQkfeTCmGjm','0944538620','Hà Nội 1','admin','2025-02-26 20:20:09','2025-05-27 14:51:15');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (2,'Tdnbict','trandiengtc1@gmail.com','$2b$10$Rv2cdvjsY3kZfyAd2.sZK.6aslx9nC9KmcNjQcmvJQy/ZRetqQf1W','','','admin','2025-02-27 23:09:50','2025-04-16 09:23:07');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (3,'Tdhút','dien.tv204527@sis.hust.edu.vn','$2b$10$ffUdjGanNLGVprdW2SPztuIl.SfnS4HfdwNPCYbP8zESm7fF0PxcS',NULL,NULL,'customer','2025-02-28 23:36:06','2025-02-28 23:36:06');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (4,'td123','abc@gmail.com','$2b$10$auo/Kijh3oLxmOAef4IvoeFCMu0yCgjAj1DP1XhTw2lImmgXEZmUq','','','customer','2025-03-01 21:51:51','2025-04-01 16:23:09');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (5,'122222','abc1@gmail.com','$2b$10$ZZMtsCm1Ejl1iOkC4QnCbO1kbeICsVT.HL14OvWOAL5j0NNPcKR.6',NULL,NULL,'customer','2025-03-01 21:54:52','2025-04-01 16:15:35');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (7,'td12345678','abc2@gmail.com','$2b$10$MFiMIH8DAfrt27XBfb0GCOek2UbOzLEK9AsKdgUy5uH/W358zIfbK','0123456788','nam định','customer','2025-03-01 21:59:11','2025-04-16 09:21:18');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (8,'Tdhút1','abc3@gmail.com','$2b$10$4atELgvEU2wciFYsvMV8FuuZBQSuzFNuSasVaDuvsA8UDF/rvxlZ.',NULL,NULL,'customer','2025-03-01 21:59:44','2025-03-01 21:59:44');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (10,'dien123','abc5@gmail.com','$2b$10$DVZl0RCuWMZtVJv0rdZQ2uyI7nwwJu252Clw1L5evZQkSyLMXh7Qy','01234567880','nam định','customer','2025-03-01 22:06:43','2025-04-15 14:57:19');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (11,'dien1','diengh@gmail.com','$2b$10$JKY7jfX/yVHqAuIyJ0TGLeJ1WnV5hCv5qFrSx2sphbw3AplrnuCuO','','','customer','2025-04-01 15:01:44','2025-04-01 16:16:13');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (15,'dien','abc6@gmail.com','$2b$10$DJcDZ2RMeYoPLlldwpi34ueuUQe9zVXIPHMWk0lOnUgEJ1uB7TohW',NULL,NULL,'customer','2025-04-15 14:48:26','2025-04-15 14:48:26');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (16,'dien1234','abc7@gmail.com','$2b$10$O7JlhjnOtjX8VymM6dYFheR.kRnMPEzTdNcRwz.Uf8FqA.2ltSYH.','','','customer','2025-04-16 09:41:43','2025-04-16 09:41:43');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (17,'dien','abc8@gmail.com','$2b$10$zHP3n2.1ZQr9xMjjtsyoyuzIAkfvAgmuMOzRGNM5u8VldUNPKHsQu','1234567890','nam định','customer','2025-04-17 15:57:11','2025-04-17 15:59:36');
INSERT INTO `users` (`id`,`name`,`email`,`password`,`phone`,`address`,`role`,`createdAt`,`updatedAt`) VALUES (18,'ei','abc9@gmail.com','$2b$10$Y/ArUM8BfFEBVoSk0hpUH.2qFXOfDJqN7HO4Utn0ZX.b9RBYdQgZm','','','customer','2025-04-17 16:10:41','2025-04-17 16:10:41');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-19 16:31:59
