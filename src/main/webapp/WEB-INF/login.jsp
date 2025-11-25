<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>Login</title>

  <meta name="viewport" content="width=device-width,initial-scale=1"/>

  <style>
    /* Full-page background using the project assets path */
    html, body {
      height: 100%;
      margin: 0;
      font-family: "Helvetica Neue", Arial, sans-serif;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }

    body {
      /* IMPORTANT: this uses the webapp assets path. Keep this path if your image sits under webapp/assets/img/study.webp */
      background-image: url('${pageContext.request.contextPath}/assets/img/study.webp');
      background-position: center center;
      background-repeat: no-repeat;
      background-size: cover;
      background-attachment: fixed;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
    }

    /* translucent card in the middle */
    .login-card {
      width: 360px;
      max-width: calc(100% - 40px);
      background: rgba(255,255,255,0.95);
      border-radius: 10px;
      box-shadow: 0 12px 30px rgba(0,0,0,0.18);
      padding: 32px 30px;
      text-align: center;
    }

    .login-card h1 {
      margin: 0 0 20px;
      font-size: 26px;
      letter-spacing: 0.5px;
    }

    .form-group {
      margin-bottom: 14px;
      text-align: left;
    }

    .form-group label {
      display:block;
      font-size:13px;
      color:#333;
      margin-bottom:6px;
    }

    .form-control {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #cfcfcf;
      border-radius: 6px;
      box-sizing: border-box;
      background: #f6fbff;
      font-size: 14px;
    }

    .btn {
      display:inline-block;
      padding: 10px 18px;
      border-radius: 6px;
      background:#36a84b;
      color:#fff;
      border:none;
      cursor:pointer;
      font-size: 14px;
      margin-top: 10px;
    }

    .small-note {
      margin-top: 10px;
      font-size: 12px;
      color:#666;
    }

    /* Responsive: smaller card on small screens */
    @media (max-width:420px){
      .login-card { padding: 24px 18px; }
      .login-card h1 { font-size:22px; }
    }
  </style>
</head>
<body>

  <div class="login-card" role="main" aria-labelledby="login-heading">
    <h1 id="login-heading">Login</h1>

    <form action="${pageContext.request.contextPath}/login" method="post">
      <div class="form-group">
        <label for="username">Username</label>
        <input id="username" name="username" class="form-control" type="text" required
               value="${param.username != null ? param.username : 'admin'}"/>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input id="password" name="password" class="form-control" type="password" required />
      </div>

      <div style="text-align:center;">
        <button type="submit" class="btn">Login</button>
      </div>
    </form>

    <div class="small-note">
      <!-- optional place for error messages -->
      <c:if test="${not empty error}">
        <div style="color:#c33;margin-top:10px;">${error}</div>
      </c:if>
    </div>
  </div>

</body>
</html>
