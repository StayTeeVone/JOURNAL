import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';  // <-- важно для *ngFor
import { ApiService } from './services/api.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, HttpClientModule, CommonModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'frontend';
  deals: any[] = [];

  constructor(private apiService: ApiService) {}

  ngOnInit() {
    // Запрос к FastAPI через сервис
    this.apiService.getDeals().subscribe(data => {
      this.deals = data;
      console.log(this.deals);
    });
  }
}
