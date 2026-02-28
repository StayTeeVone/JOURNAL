import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],  // <- только модули
  template: `
    <h2>Register</h2>
    <div *ngIf="error" style="color:red">{{ error }}</div>
    <input type="text" [(ngModel)]="username" placeholder="Username" /><br />
    <input type="email" [(ngModel)]="email" placeholder="Email" /><br />
    <input type="password" [(ngModel)]="password" placeholder="Password" /><br />
    <button (click)="register()">Register</button><br />
    <a routerLink="/login">Login</a>
  `
})
export class RegisterComponent {
  username = '';
  email = '';
  password = '';
  error = '';

  constructor(private http: HttpClient, private router: Router) {}

  register() {
    this.http.post<any>('http://127.0.0.1:8000/auth/register', {
      username: this.username,
      email: this.email,
      password: this.password
    }).subscribe({
      next: () => this.router.navigate(['/login']),
      error: err => this.error = err.error.detail
    });
  }
}