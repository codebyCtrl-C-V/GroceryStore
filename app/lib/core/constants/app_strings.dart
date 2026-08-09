/// Tập trung các chuỗi text dùng trong app tại một nơi
/// để dễ quản lý và sau này dễ dàng đa ngôn ngữ hoá (i18n).
class AppStrings {
  AppStrings._();

  static const String appName = 'D Food';

  // Common
  static const String loading = 'Đang tải...';
  static const String error = 'Đã xảy ra lỗi. Vui lòng thử lại.';
  static const String save = 'Lưu';
  static const String cancel = 'Hủy';

  // Login screen
  static const String loginTitle = 'Đăng nhập';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Mật khẩu';
  static const String loginButton = 'Đăng nhập';
  static const String registerNavigate = 'Chưa có tài khoản? Đăng ký ngay';
  static const String loginError = 'Email hoặc mật khẩu không hợp lệ';
  static const String loginWithGoogle = 'Đăng nhập với Google';

  // Register screen
  static const String registerTitle = 'Đăng ký';
  static const String nameHint = 'Họ và tên';
  static const String confirmPasswordHint = 'Nhập lại mật khẩu';
  static const String registerButton = 'Đăng ký';
  static const String loginNavigate = 'Đã có tài khoản? Đăng nhập';
  static const String registerSuccess = 'Đăng ký thành công!';
  static const String passwordsDoNotMatch = 'Mật khẩu nhập lại không khớp';

  // Home screen
  static const String homeTitle = 'Trang chủ';
  static const String welcomeMessage = 'Chào mừng bạn quay trở lại!';
  static const String outstandingProducts = 'Sản phẩm nổi bật';
  static const String newProducts = 'Sản phẩm mới về';
  static const String viewAll = 'Xem tất cả';

  // Search screen
  static const String searchTitle = 'Tìm kiếm';
  static const String searchHint = 'Tìm kiếm sản phẩm...';
  static const String noProductsFound = 'Không tìm thấy sản phẩm nào.';

  // Cart screen
  static const String cartTitle = 'Giỏ hàng';
  static const String cartEmpty = 'Giỏ hàng của bạn đang trống.';
  static const String total = 'Tổng cộng';
  static const String checkout = 'Thanh toán';
  static const String addToCartSuccess = 'Đã thêm vào giỏ hàng!';

  // Checkout screen
  static const String checkoutTitle = 'Thanh toán';
  static const String receiverName = 'Tên người nhận';
  static const String receiverPhone = 'Số điện thoại';
  static const String shippingAddress = 'Địa chỉ giao hàng';
  static const String paymentMethod = 'Phương thức thanh toán';
  static const String paymentCod = 'Thanh toán khi nhận hàng (COD)';
  static const String paymentVnpay = 'Thanh toán qua VNPay (Giả lập)';
  static const String placeOrder = 'Đặt hàng';
  static const String orderSuccess = 'Đặt hàng thành công!';

  // Orders screen
  static const String ordersTitle = 'Đơn hàng của tôi';
  static const String orderId = 'Mã đơn hàng';
  static const String orderStatus = 'Trạng thái';
  static const String orderTotal = 'Tổng tiền';
  static const String orderDate = 'Ngày đặt';
  static const String cancelOrderButton = 'Hủy đơn hàng';
  static const String cancelOrderConfirm =
      'Bạn có chắc chắn muốn hủy đơn hàng này?';

  // Profile screen
  static const String profileTitle = 'Cá nhân';
  static const String updateProfileTitle = 'Cập nhật thông tin';
  static const String changePasswordTitle = 'Đổi mật khẩu';
  static const String oldPasswordHint = 'Mật khẩu cũ';
  static const String newPasswordHint = 'Mật khẩu mới';
  static const String logoutButton = 'Đăng xuất';
  static const String profileUpdateSuccess = 'Cập nhật thông tin thành công!';
  static const String passwordChangeSuccess = 'Đổi mật khẩu thành công!';

  // News screen
  static const String newsTitle = 'Tin tức';

  // Chatbot screen
  static const String chatbotTitle = 'Trợ lý AI';
  static const String chatbotWelcome = 'Tôi có thể giúp gì cho bạn hôm nay?';
  static const String chatbotHint = 'Nhập câu hỏi tại đây...';
}
