import { useEffect, useState } from 'react';
import AppRouter from './routers/AppRouter';
import { useNavigate } from 'react-router-dom';
import useAuth from './hooks/useAuth';
import { refreshToken } from './services/apiUser';

function App() {
  const { fetchUserInfor } = useAuth();
  const navigate = useNavigate();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const initAuth = async () => {
      const access_token = localStorage.getItem('access_token');
      const refresh_token = localStorage.getItem('refresh_token');

      if (!access_token || !refresh_token) {
        setReady(true);
        return;
      }

      try {
        await refreshToken();
        await fetchUserInfor();
        setReady(true);
      } catch (err) {
        console.error(err);
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        navigate('/login');
      }
    };

    initAuth();

    const intervalId = setInterval(refreshToken, 60 * 1000 * 14); // 14 phút
    return () => {
      clearInterval(intervalId);
    };
  }, []);

  return ready ? <AppRouter /> : null;
}

export default App;
