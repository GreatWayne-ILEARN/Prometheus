import { Switch, Route, Router as WouterRouter, Redirect } from "wouter";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@workspace/ui";
import { TooltipProvider } from "@workspace/ui";
import { AuthProvider, useAuth } from "@/contexts/AuthContext";
import type { AppRole } from "@/contexts/AuthContext";

import Landing from "@/routes/landing";
import Login from "@/routes/auth/login";
import Register from "@/routes/auth/register";
import NotFound from "@/routes/not-found";

import ReviewerDashboard from "@/routes/reviewer/dashboard";
import Leaderboard from "@/routes/reviewer/leaderboard";
import ReviewSession from "@/routes/reviewer/review-session";

import BrandDashboard from "@/routes/brand/dashboard";
import MyAds from "@/routes/brand/ads/my-ads";
import CreateAd from "@/routes/brand/ads/create-ad";
import AdDetail from "@/routes/brand/ads/ad-detail";
import BrandSettings from "@/routes/brand/settings";
import BrandPortal from "@/routes/brand/brand-portal";

import AdminDashboard from "@/routes/admin/dashboard";
import AdminAds from "@/routes/admin/ads";
import AdminUsers from "@/routes/admin/users";
import AdminEvents from "@/routes/admin/events";
import AdminFinancials from "@/routes/admin/financials";
import AdminPanel from "@/routes/admin/admin-panel";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { retry: false, refetchOnWindowFocus: false },
  },
});

function ProtectedRoute({ component: Component, roles }: { component: React.ComponentType<any>; roles?: AppRole[] }) {
  const { user, isLoading } = useAuth();
  if (isLoading) return <div className="min-h-screen flex items-center justify-center"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div></div>;
  if (!user) return <Redirect to="/login" />;
  if (roles && !roles.includes(user.role as AppRole)) return <Redirect to="/" />;
  return <Component />;
}

function Router() {
  const { user } = useAuth();
  const role = user?.role as AppRole | undefined;

  return (
    <Switch>
      <Route path="/">
        {() => {
          const role = user?.role as AppRole;
          if (role === "admin" || role === "super_admin") return <Redirect to="/admin/dashboard" />;
          if (role === "brand") return <Redirect to="/brand/dashboard" />;
          if (role === "reviewer") return <Redirect to="/dashboard" />;
          return <Landing />;
        }}
      </Route>
      <Route path="/login" component={Login} />
      <Route path="/register" component={Register} />

      {/* Reviewer routes */}
      <Route path="/dashboard">
        <ProtectedRoute component={ReviewerDashboard} roles={["reviewer"]} />
      </Route>
      <Route path="/leaderboard">
        <ProtectedRoute component={Leaderboard} roles={["reviewer"]} />
      </Route>
      <Route path="/review/:id">
        <ProtectedRoute component={ReviewSession} roles={["reviewer"]} />
      </Route>

      {/* Brand routes */}
      <Route path="/brand/dashboard">
        <ProtectedRoute component={BrandDashboard} roles={["brand", "admin", "super_admin"]} />
      </Route>
      <Route path="/brand/ads">
        <ProtectedRoute component={MyAds} roles={["brand", "admin", "super_admin"]} />
      </Route>
      <Route path="/brand/ads/new">
        <ProtectedRoute component={CreateAd} roles={["brand", "admin", "super_admin"]} />
      </Route>
      <Route path="/brand/ads/:id">
        <ProtectedRoute component={AdDetail} roles={["brand", "admin", "super_admin"]} />
      </Route>
      <Route path="/brand/settings">
        <ProtectedRoute component={BrandSettings} roles={["brand"]} />
      </Route>
      <Route path="/brand/analytics">
        <ProtectedRoute component={BrandPortal} roles={["brand", "admin", "super_admin"]} />
      </Route>

      {/* Admin routes */}
      <Route path="/admin/dashboard">
        <ProtectedRoute component={AdminDashboard} roles={["admin", "super_admin"]} />
      </Route>
      <Route path="/admin/ads">
        <ProtectedRoute component={AdminAds} roles={["admin", "super_admin"]} />
      </Route>
      <Route path="/admin/users">
        <ProtectedRoute component={AdminUsers} roles={["admin", "super_admin"]} />
      </Route>
      <Route path="/admin/events">
        <ProtectedRoute component={AdminEvents} roles={["admin", "super_admin"]} />
      </Route>
      <Route path="/admin/financials">
        <ProtectedRoute component={AdminFinancials} roles={["admin", "super_admin"]} />
      </Route>
      <Route path="/admin/panel">
        <ProtectedRoute component={AdminPanel} roles={["admin", "super_admin"]} />
      </Route>

      <Route component={NotFound} />
    </Switch>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <WouterRouter base={import.meta.env.BASE_URL.replace(/\/$/, "")}>
          <AuthProvider>
            <Router />
          </AuthProvider>
        </WouterRouter>
        <Toaster />
      </TooltipProvider>
    </QueryClientProvider>
  );
}

export default App;
