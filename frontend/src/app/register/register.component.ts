import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { HttpClient, HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, HttpClientModule],  // <- только модули
  templateUrl: './register.component.html',
  styleUrl: './register.component.scss'
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

  goToLogin() {
    this.router.navigate(['/login']);
  }
}