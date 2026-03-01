import { bootstrapApplication } from '@angular/platform-browser';
import { provideRouter, Routes } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';
import { AppComponent } from './app/app.component';
import { LoginComponent } from './app/login/login.component';
import { RegisterComponent } from './app/register/register.component';
import { DashboardComponent } from './app/dashboard/dashboard.component';
import { DashboardLayoutComponent } from './app/layout/dashboard-layout/dashboard-layout.component';
import { TradeComponent } from './app/pages/trade/trade.component';
import { IdeaComponent } from './app/pages/idea/idea.component';
import { StrategyComponent } from './app/pages/strategy/strategy.component';
import { DocumentComponent } from './app/pages/document/document.component';
import { AccountComponent } from './app/pages/account/account.component';
import { AnalysisComponent } from './app/pages/analysis/analysis.component';
import { BacktestComponent } from './app/pages/backtest/backtest.component';
import { CalendarComponent } from './app/pages/calendar/calendar.component';
import { SettingsComponent } from './app/pages/settings/settings.component';
import { AuthGuard } from './app/auth.guard';

const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  // { path: 'dashboard', component: DashboardComponent }
  {
    path: 'dashboard',
    component: DashboardLayoutComponent,
    canActivate: [AuthGuard],  // <- добавляем защиту маршрута
    children: [
      { path: 'trade', component: TradeComponent },
      { path: 'idea', component: IdeaComponent },
      { path: 'strategy', component: StrategyComponent },
      { path: 'document', component: DocumentComponent },
      { path: 'account', component: AccountComponent },
      { path: 'analysis', component: AnalysisComponent },
      { path: 'backtest', component: BacktestComponent },
      { path: 'calendar', component: CalendarComponent },
      { path: 'settings', component: SettingsComponent },
      { path: '', redirectTo: 'trade', pathMatch: 'full' }
    ]
    
  },
  { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
];

bootstrapApplication(AppComponent, {
  providers: [
    provideRouter(routes),
    provideHttpClient()
  ]
});