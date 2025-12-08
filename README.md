REST API

> Delphi (Object Pascal) 기반의 사용자 관리 RESTful API 서버

## 프로젝트 소개

Delphi의 WebBroker 프레임워크와 Indy HTTP Server를 활용하여 구축한 사용자 관리 REST API 서버입니다. 
회원가입, 로그인, 사용자 정보 CRUD 등의 기능을 제공하며, MySQL 데이터베이스와 연동하여 데이터를 관리합니다.

### 개발 목적
- Delphi를 활용한 백엔드 서버 개발 경험
- RESTful API 설계 원칙 학습 및 적용
- FireDAC을 이용한 데이터베이스 연동 구현
- JSON 기반 데이터 통신 처리

## 주요 기능

### 인증 기능
-  **회원가입** - 새로운 사용자 계정 생성
-  **로그인** - 사용자 인증 및 세션 관리
-  **로그아웃** - 로그인 상태 해제
-  **중복 로그인 방지** - 동시 로그인 제어 (옵션)

### 사용자 관리
-  **전체 사용자 조회** - 등록된 모든 사용자 목록 조회
-  **특정 사용자 조회** - ID로 특정 사용자 정보 검색
-  **사용자 정보 수정** - PUT (전체), PATCH (부분) 지원
-  **사용자 삭제** - 계정 삭제 기능

### 기타
-  **CORS 지원** - Cross-Origin 요청 처리
-  **입력 검증** - 중복 사용자명 체크
-  **RESTful 설계** - HTTP 메서드와 상태 코드 준수
-  **테스트 클라이언트** - GUI 기반 API 테스트 도구 포함

##  프로젝트 구조

```
rest-api/
├── ServerMainUnit.pas          # 메인 서버 로직 (REST API 핸들러)
├── FormUnit1.pas               # 서버 시작/중지 UI
├── ClientTestUnit.pas          # API 테스트 클라이언트
├── libmysql.dll               # MySQL 드라이버
├── Untitled1.htm              # 메인 페이지
└── Untitled2.htm              # 회원가입 페이지
```

### 주요 컴포넌트

**ServerMainUnit (TWebModule1)**
- `HandleSignup` - 회원가입 처리
- `HandleLogin` - 로그인 처리
- `HandleLogout` - 로그아웃 처리
- `HandleUsers` - 사용자 CRUD 처리
- `SetCORSHeaders` - CORS 헤더 설정

## 🗄️ 데이터베이스 스키마

### Users 테이블

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    is_logged_in TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 사전 요구사항

- Delphi IDE (10.2 Tokyo 이상 권장)
- MySQL Server 8.0 이상
- MySQL Connector (libmysql.dll)

### HTTP 상태 코드

| 코드 | 의미 | 사용 예시 |
|------|------|-----------|
| 200 | OK | 요청 성공 |
| 201 | Created | 리소스 생성 성공 (회원가입) |
| 400 | Bad Request | 잘못된 요청 형식 |
| 401 | Unauthorized | 인증 실패 |
| 404 | Not Found | 리소스를 찾을 수 없음 |
| 405 | Method Not Allowed | 허용되지 않은 HTTP 메서드 |
| 409 | Conflict | 중복 로그인 등의 충돌 |
| 500 | Internal Server Error | 서버 내부 오류 |


### 지원 엔드포인트
- POST /api/signup - 회원가입
- POST /api/login - 로그인
- POST /api/logout - 로그아웃
- GET /api/users - 사용자 목록 조회
- GET /api/users/{id} - 특정 사용자 조회
- PUT /api/users/{id} - 사용자 전체 수정
- PATCH /api/users/{id} - 사용자 부분 수정
- DELETE /api/users/{id} - 사용자 삭제

## 배운 점 & 개선 사항

### 배운 점
- Delphi로 RESTful API 서버 구축 경험
- WebBroker와 Indy를 활용한 HTTP 서버 구현
- FireDAC을 통한 MySQL 데이터베이스 연동

### 개선이 필요한 부분
- **보안**: 평문 비밀번호 저장 → 해싱 필요
- **인증**: 세션 기반 → JWT 토큰 방식으로 개선
- **에러 처리**: 더 상세한 예외 처리 및 에러 메시지
- **로깅**: 체계적인 로그 시스템 구축
- **테스트**: 자동화된 테스트 코드 작성
- **파일 경로**: 하드코딩된 경로 → 상대 경로 또는 설정 파일로 관리




