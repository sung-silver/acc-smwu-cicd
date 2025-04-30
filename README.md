# ☁️ ACC SMWU 3기 무중단 배포 사전 세팅 가이드
> Author: [@sung-silver](https://github.com/sung-silver)

이 문서는 GitHub Actions, S3, CodeDeploy, EC2, Nginx를 이용한 무중단 배포 환경 구축을 위해 필요한 EC2 초기 설정 및 Nginx 프록시 설정 방법을 안내합니다.

[`세션 자료 바로가기`](https://www.miricanvas.com/v/14jjqb9)

---
## 📌 0. 실습을 위한 repository setting

### ✅ 다음 설정으로 새 GitHub repository 생성

1. **Repository name**: `acc-smwu-cicd`
2. **공개 범위**: `Public`
3. **Add a README file**: 체크 해제
4. **Create repository** 버튼 클릭

### ✅ 클론 받은 레포의 remote 주소를 본인 것으로 변경

```bash
# 원본 레포를 clone
git clone https://github.com/sung-silver/acc-smwu-cicd.git
cd acc-smwu-cicd

# 기존 origin 제거
git remote remove origin

# 새로 만든 본인 레포 주소로 origin 설정
git remote add origin https://github.com/your-github-username/acc-smwu-cicd.git

# main 브랜치로 푸시
git push -u origin main
```
---

## 📌 1. EC2 인스턴스 준비

### ✅ 인스턴스 설정

- 운영체제: **Ubuntu 22.04 LTS (64-bit)**
- 인스턴스 타입: **t2.micro**
- 스토리지: **22 GiB**
- 보안 그룹 설정:
  - 포트 `22` (SSH): 내 IP 허용
  - 포트 `80` (HTTP): 0.0.0.0/0

---

## 🔐 2. EC2 접속 및 초기 셋업

### ✅ EC2 접속

```bash
ssh -i [your-key.pem] ubuntu@[your-ec2-public-ip]
```
- 또는 AWS 콘솔 내에서 접속합니다

### ✅ 디렉토리 생성 및 `setup.sh` 생성

```bash
mkdir -p ~/app/nonstop/jar
cd ~/app/nonstop
vim setup.sh
```

### ✅ `setup.sh` 작성

GitHub 저장소의 [`/scripts/setup.sh`](https://github.com/sung-silver/acc-smwu-cicd/blob/main/scripts/setup.sh) 내용을 붙여넣습니다.

**vim 사용법:**
- `i`: 편집 시작
- 내용 붙여넣기
- `Esc → :wq → Enter`: 저장 후 종료

### ✅ 실행 권한 부여 및 실행

```bash
chmod +x setup.sh
./setup.sh
```

> Java 17, AWS CodeDeploy Agent, Nginx가 설치됩니다.

---

## 🌐 3. Nginx 설정

### ✅ 기본 설정 파일 수정

```bash
sudo vim /etc/nginx/sites-available/default
```

다음 내용을 찾아 수정하거나 추가합니다:

```nginx
root /var/www/html;

index index.html index.htm index.nginx-debian.html;

include /etc/nginx/conf.d/service-url.inc;  # ✅ 추가

server_name _;

location / {
    # ✅ 아래 4줄 추가
    proxy_pass $service_url;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
}
```

### ✅ `service-url.inc` 파일 생성

```bash
sudo vim /etc/nginx/conf.d/service-url.inc
```

초기 내용:

```nginx
set $service_url http://127.0.0.1:8080;
```

---

## 🔁 4. Nginx Reload

```bash
sudo service nginx reload
```

정상 응답 확인:

```bash
curl -I http://localhost
```

---
