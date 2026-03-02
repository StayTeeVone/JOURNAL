import { Routes } from '@angular/router';
import { DashboardLayoutComponent } from '../layout/dashboard-layout/dashboard-layout.component';

export const DASHBOARD_ROUTES: Routes = [
    {
        path: '',
        component: DashboardLayoutComponent,
        children: [
            {
                path: 'trade',
                loadChildren: () => 
                    import('../pages/trade/trade.routes')
                        .then(m => m.TRADE_ROUTES)
            },
            {
                path: 'idea',
                loadChildren: () => 
                    import('../pages/idea/idea.routes')
                        .then(m => m.IDEA_ROUTES)
            },
            {
                path: 'strategy',
                loadChildren: () => 
                    import('../pages/strategy/strategy.routes')
                        .then(m => m.STRATEGY_ROUTES)
            },
            {
                path: 'document',
                loadChildren: () => 
                    import('../pages/document/document.routes')
                        .then(m => m.DOCUMENT_ROUTES)
            },
            {
                path: 'account',
                loadChildren: () => 
                    import('../pages/account/account.routes')
                        .then(m => m.ACCOUNT_ROUTES)
            },
            {
                path: 'analysis',
                loadChildren: () => 
                    import('../pages/analysis/analysis.routes')
                        .then(m => m.ANALYSIS_ROUTES)
            },
            {
                path: 'backtest',
                loadChildren: () => 
                    import('../pages/backtest/backtest.routes')
                        .then(m => m.BACKTEST_ROUTES)
            },
            {
                path: 'calendar',
                loadChildren: () => 
                    import('../pages/calendar/calendar.routes')
                        .then(m => m.CALENDAR_ROUTES)
            },
            {
                path: 'settings',
                loadChildren: () => 
                    import('../pages/settings/settings.routes')
                        .then(m => m.SETTINGS_ROUTES)
            },
            { path: '', redirectTo: 'analysis', pathMatch: 'full' }
            // { path: 'trade', component: TradeComponent },
            // { path: 'idea', component: IdeaComponent },
            // { path: 'strategy', component: StrategyComponent },
            // { path: 'document', component: DocumentComponent },
            // { path: 'account', component: AccountComponent },
            // { path: 'analysis', component: AnalysisComponent },
            // { path: 'backtest', component: BacktestComponent },
            // { path: 'calendar', component: CalendarComponent },
            // { path: 'settings', component: SettingsComponent },
            // { path: '', redirectTo: 'analysis', pathMatch: 'full' }
        ]
    }
];