import { Route, Routes } from 'react-router-dom';
import Home from '../pages/home/Home';
import RequireAuth from './RequireAuth';
import AppShell from '../layouts/AppShell';
import LayoutAuth from '../layouts/LayoutAuth';
import Layouts from '../layouts/Layouts';

export default function AppRouter() {
  return (
    <Routes>
      <Route element={<AppShell />}>
        {/* Auth routes */}
        <Route element={<LayoutAuth />}>
          {/* <Route path="/signup" element={<Register />} />
          <Route path="/signin" element={<Login />} />
          <Route path="/account-verify" element={<ActiveAccount />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/reset-password" element={<ResetPassword />} />
          <Route path="/terms" element={<TermsAndConditions />} /> */}
        </Route>

        <Route element={<Layouts />}>
          <Route path="/" element={<Home />} />
        </Route>

        {/* Protected routes */}
        <Route
          element={
            <RequireAuth >
              <Layouts />
            </RequireAuth>
          }
        >
         
      
        </Route>

        <Route
          element={
            <RequireAuth roles={['stream_host']}>
              <Layouts />
            </RequireAuth>
          }
        >
          
        </Route>
      </Route>
    </Routes>
  );
}
