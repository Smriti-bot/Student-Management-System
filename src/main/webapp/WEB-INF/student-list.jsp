<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Students - Student Management</title>

    <style>
        /* Page background */
        body {
            margin: 0;
            font-family: "Helvetica Neue", Arial, sans-serif;
            background-image: url('${pageContext.request.contextPath}/assets/img/study.webp');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            color: #222;
        }

        .page-card {
            max-width: 1200px;
            margin: 48px auto;
            background: rgba(255,255,255,0.98);
            border-radius: 12px;
            padding: 26px;
            box-shadow: 0 8px 24px rgba(20,30,40,0.08);
        }

        .controls { display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap; margin-bottom:18px; }
        .left-controls { display:flex; gap:8px; align-items:center; }
        .right-controls { display:flex; gap:12px; align-items:center; }

        input.search { padding:8px 12px; border-radius:6px; border:1px solid #d0d7de; width:220px; }

        .badge {
            display:flex;
            align-items:center;
            gap:10px;
            background: #fff;
            padding:8px 10px;
            border-radius:8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }
        .badge img { width:40px; height:40px; object-fit:cover; border-radius:6px; border:1px solid #eee; }
        .badge .num { font-weight:700; font-size:18px; color:#0b3b6b; }
        .badge .label { font-size:12px; color:#666; }

        button.btn { padding:8px 12px; border-radius:6px; background:#2c6fb7; color:#fff; border:none; cursor:pointer; }
        button.btn.ghost { background:transparent; color:#2c6fb7; border:1px solid #2c6fb7; }

        .table-wrap { background:transparent; padding:10px; border-radius:10px; }
        table.students { width:100%; border-collapse:collapse; background:#fff; border-radius:8px; overflow:hidden; }
        table.students thead th { background:#2c5fa0; color:#fff; padding:14px 18px; text-align:left; font-weight:700; }
        table.students tbody td { padding:14px 18px; border-bottom:1px solid #eee; }
        table.students tbody tr:nth-child(odd) { background:#fff; }
        table.students tbody tr:nth-child(even) { background:#F5F7FA; }

        .serial { width:64px; font-weight:600; color:#0b3b6b; }
        .actions a { color:#1f4ea0; text-decoration:underline; margin:0 6px; }

        /* modal & toast */
        .modal-backdrop { position:fixed; inset:0; display:none; align-items:center; justify-content:center; background:rgba(0,0,0,0.45); z-index:1200; }
        .modal { background:#fff; padding:18px; border-radius:8px; width:360px; box-shadow:0 12px 40px rgba(10,20,40,0.25); }
        .btn-danger { background:#d9534f; color:#fff; padding:8px 12px; border-radius:6px; border:0; }
        .btn-cancel { background:transparent; border:1px solid #ccc; padding:7px 12px; border-radius:6px; color:#333; }

        .toast { position:fixed; right:22px; bottom:22px; background:#10b981; color:white; padding:10px 14px; border-radius:8px; display:none; z-index:1300; font-weight:600; }
    </style>
</head>
<body>
<div class="page-card" role="main">
    <div class="controls">
        <div class="left-controls">
            <form method="get" action="${pageContext.request.contextPath}/students" style="display:flex; gap:8px; align-items:center;">
                <input class="search" type="text" name="keyword" placeholder="Search by name or course" value="${fn:escapeXml(param.keyword)}"/>
                <input type="hidden" name="action" value="search" />
                <button class="btn" type="submit">Search</button>
            </form>

            <a href="${pageContext.request.contextPath}/students?action=add"><button class="btn ghost" type="button">Add Student</button></a>
        </div>

        <div class="right-controls">
            <!-- Total students badge using uploaded image path -->
            <div class="badge">
                <img src="file:///mnt/data/Gemini_Generated_Image_kllkknkllkknkllk.png" alt="students" />
                <div>
                    <div class="label">Total students</div>
                    <div class="num"><c:out value="${totalStudents != null ? totalStudents : 0}" /></div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/downloadReport?type=csv"><button class="btn ghost" type="button">Download CSV</button></a>
            <a href="${pageContext.request.contextPath}/downloadReport?type=pdf"><button class="btn ghost" type="button">Download PDF</button></a>

            <form method="post" action="${pageContext.request.contextPath}/logout" style="display:inline;">
                <button class="btn" type="submit">Logout</button>
            </form>
        </div>
    </div>

    <div class="table-wrap">
        <table class="students" role="table" aria-label="Student list">
            <thead>
            <tr>
                <th class="serial">No.</th>
                <th>Name</th>
                <th>Email</th>
                <th>Course</th>
                <th>Grade</th>
                <th>Enrollment Date</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty students}">
                    <tr><td colspan="7" style="padding:24px; text-align:center; color:#666;">No students found.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="s" items="${students}" varStatus="status">
                        <tr>
                            <td class="serial"><c:out value="${status.index + 1}" /></td>
                            <td><c:out value="${s.firstName}"/> <c:out value="${s.lastName}"/></td>
                            <td><c:out value="${s.email}"/></td>
                            <td><c:out value="${s.course}"/></td>
                            <td><c:out value="${s.grade}"/></td>
                            <td><c:out value="${s.enrollmentDate}"/></td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/students?action=edit&id=${s.id}">Edit</a> |
                                <a href="#" data-id="${s.id}" data-name="${fn:escapeXml(s.firstName)} ${fn:escapeXml(s.lastName)}" onclick="openDeleteModalFromEl(this); return false;">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Delete modal -->
<div id="deleteModalBackdrop" class="modal-backdrop" role="dialog" aria-hidden="true">
    <div class="modal" role="document" aria-labelledby="confirmTitle">
        <h3 id="confirmTitle">Confirm delete</h3>
        <p id="confirmText">Are you sure you want to delete this student?</p>
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:6px;">
            <div id="studentInfo" style="font-size:14px; color:#444;"></div>
            <div style="display:flex; gap:8px;">
                <button id="confirmDeleteBtn" class="btn-danger">Yes, delete</button>
                <button id="cancelDeleteBtn" class="btn-cancel">Cancel</button>
            </div>
        </div>
    </div>
</div>

<div id="toast" class="toast" role="status" aria-live="polite"></div>

<script>
    // show toast
    function showToast(message, timeout=3000) {
        const t = document.getElementById('toast');
        t.textContent = message;
        t.style.display = 'block';
        t.style.opacity = '1';
        setTimeout(()=> {
            t.style.transition = 'opacity 300ms';
            t.style.opacity = '0';
            setTimeout(()=> t.style.display = 'none', 300);
        }, timeout);
    }

    // delete modal safe helpers
    function openDeleteModalFromEl(el) {
        const id = el.getAttribute('data-id');
        const name = el.getAttribute('data-name') || '';
        openDeleteModal(id, name);
    }

    let deleteStudentId = null;
    function openDeleteModal(id, name) {
        deleteStudentId = id;
        document.getElementById('studentInfo').textContent = name;
        document.getElementById('confirmText').textContent = 'Are you sure you want to delete this student?';
        const backdrop = document.getElementById('deleteModalBackdrop');
        backdrop.style.display = 'flex';
        backdrop.setAttribute('aria-hidden','false');
    }

    function closeDeleteModal() {
        deleteStudentId = null;
        const backdrop = document.getElementById('deleteModalBackdrop');
        backdrop.style.display = 'none';
        backdrop.setAttribute('aria-hidden','true');
    }

    document.getElementById('cancelDeleteBtn').addEventListener('click', function(e){
        e.preventDefault();
        closeDeleteModal();
    });

    document.getElementById('confirmDeleteBtn').addEventListener('click', function(e){
        e.preventDefault();
        if (!deleteStudentId) { closeDeleteModal(); return; }
        const ctx = '${pageContext.request.contextPath}';
        window.location.href = ctx + '/students?action=delete&id=' + encodeURIComponent(deleteStudentId);
    });

    document.getElementById('deleteModalBackdrop').addEventListener('click', function(e){
        if (e.target === this) closeDeleteModal();
    });

    // show toast from server param safely
    (function(){
        var msg = '<c:out value="${param.msg}" />';
        var success = '<c:out value="${param.success}" />';
        if (msg && msg.trim().length > 0) {
            showToast(msg, 3000);
        } else if (success && success.trim().length > 0) {
            showToast(success, 3000);
        }
    })();
</script>
</body>
</html>

<script>
  (function(){
    const searchForm = document.querySelector('form[action$="/students"]');
    if (!searchForm) return;
    searchForm.addEventListener('submit', function(e){
      const input = searchForm.querySelector('input[name="keyword"]');
      if (input && typeof input.value === 'string') {
        input.value = input.value.trim();
      }
    });
  })();
</script>
