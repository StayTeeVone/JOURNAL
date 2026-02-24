import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'  // сервис доступен во всём приложении
})
export class ApiService {
  private baseUrl = 'http://127.0.0.1:8000'; // адрес твоего FastAPI

  constructor(private http: HttpClient) {}

  // Пример метода для получения сделок
  getDeals(): Observable<any> {
    return this.http.get(`${this.baseUrl}/deals`);
  }

  // Позже можно добавить методы для стратегий, аналитики и т.д.
}