import { Navigate, useLocation } from 'react-router-dom';
import type { JSX } from 'react/jsx-dev-runtime';
import useAuth from '../hooks/useAuth';

export default function RequireAuth({
  children,
  roles,
}: {
  children: JSX.Element;
  roles?: string[];
}) {
  const location = useLocation();
  const token = localStorage.getItem('access_token');
  const { userInfor } = useAuth();

  if (!token) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  let userRoles: string[] = [];

  if (Array.isArray(userInfor?.role)) {
    userRoles = [...userInfor.role];
  } else if (typeof userInfor?.role === 'string') {
    userRoles = [userInfor.role];
  }

  // Nếu có yêu cầu phân quyền thì kiểm tra role
  const hasRole = roles && userRoles.some((r) => roles.includes(r));
  if (!hasRole) {
    return <Navigate to="/unauthorized" replace />;
  }

  return children;
}
