import { Route, Routes, Navigate, Link } from 'react-router-dom';
import Home from '../pages/home/Home';
import RequireAuth from './RequireAuth';
import AppShell from '../layouts/AppShell';
import LayoutAuth from '../layouts/LayoutAuth';
import Layouts from '../layouts/Layouts';

// Import newly created pages
import Login from '../pages/login/Login';
import Register from '../pages/register/Register';
import Cart from '../pages/cart/Cart';
import Checkout from '../pages/checkout/Checkout';
import Orders from '../pages/orders/Orders';
import Profile from '../pages/profile/Profile';
import ProductDetail from '../pages/product/ProductDetail';
import ProductList from '../pages/product/ProductList';
import ProductSale from '../pages/product/ProductSale';
import Search from '../pages/search/Search';
import NewsList from '../pages/news/NewsList';
import NewsDetail from '../pages/news/NewsDetail';
import Introduce from '../pages/info/Introduce';
import Policy from '../pages/info/Policy';
import Recruitment from '../pages/info/Recruitment';
import StoreSystem from '../pages/info/StoreSystem';
import PaymentReturn from '../pages/payment/PaymentReturn';

export default function AppRouter() {
  return (
    <Routes>
      <Route element={<AppShell />}>
        {/* Auth routes */}
        <Route element={<LayoutAuth />}>
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
        </Route>

        {/* Public customer facing routes */}
        <Route element={<Layouts />}>
          <Route path="/" element={<Home />} />
          <Route path="/search" element={<Search />} />
          <Route path="/product/:slug" element={<ProductDetail />} />
          <Route path="/category/:slug" element={<ProductList />} />
          <Route path="/products" element={<ProductList />} />
          <Route path="/sale" element={<ProductSale />} />
          <Route path="/cart" element={<Cart />} />
          <Route path="/news" element={<NewsList />} />
          <Route path="/news/:slug" element={<NewsDetail />} />
          <Route path="/introduce" element={<Introduce />} />
          <Route path="/policy" element={<Policy />} />
          <Route path="/recruitment" element={<Recruitment />} />
          <Route path="/store-system" element={<StoreSystem />} />
          <Route 
            path="/unauthorized" 
            element={
              <div style={{ padding: '80px 20px', textAlign: 'center' }}>
                <h2>Không có quyền truy cập</h2>
                <p>Bạn không có quyền truy cập tài nguyên này.</p>
                <Link to="/" style={{ color: 'var(--color-primary)', fontWeight: 'bold' }}>Quay về trang chủ</Link>
              </div>
            } 
          />
        </Route>

        {/* Protected customer routes (Requires login) */}
        <Route
          element={
            <RequireAuth>
              <Layouts />
            </RequireAuth>
          }
        >
          <Route path="/profile" element={<Profile />} />
          <Route path="/checkout" element={<Checkout />} />
          <Route path="/orders" element={<Orders />} />
          <Route path="/payment/vnpay_return" element={<PaymentReturn />} />
        </Route>

        {/* Page Not Found fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  );
}
