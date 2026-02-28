import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],  // <- NgModel не пишем сюда!
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
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