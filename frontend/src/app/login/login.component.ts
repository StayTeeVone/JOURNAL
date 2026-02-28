import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],  // <- NgModel не пишем сюда!
  // template: `
  //   <h2>Login</h2>
  //   <div *ngIf="error" style="color:red">{{ error }}</div>
  //   <input type="email" [(ngModel)]="email" placeholder="Email" /><br />
  //   <input type="password" [(ngModel)]="password" placeholder="Password" /><br />
  //   <button (click)="login()">Login</button><br />
  //   <a routerLink="/register">Зарегистрироваться</a>
  // `
  templateUrl: './login.component.html'
})
export class LoginComponent {
  email = '';
  password = '';
  error = '';

  constructor(private http: HttpClient, private router: Router) {}

  login() {
    this.http.post<any>('http://127.0.0.1:8000/auth/login', {
      email: this.email,
      password: this.password
    }).subscribe({
      next: () => this.router.navigate(['/dashboard']),
      error: err => this.error = err.error.detail
    });
  }

  goToRegister() {
    this.router.navigate(['/register']);
  }
}