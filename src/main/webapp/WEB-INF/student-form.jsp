<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Student Form</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
    <style>
        /* ---------- Center Page ---------- */
        body, html {
            height: 100%;
            margin: 0;
            background: #f4f7fb;
            font-family: Arial, sans-serif;
        }

        .form-page {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* ---------- Form Card ---------- */
        .form-card {
            width: 420px;
            background: linear-gradient(180deg, rgba(255,255,255,0.97), rgba(250,250,250,0.98));
            padding: 28px 26px;
            border-radius: 14px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.12);
            transition: 0.2s ease;
            position: relative;
        }

        .form-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 55px rgba(0,0,0,0.18);
        }

        .form-card h2 {
            text-align: center;
            margin: 0 0 18px;
            font-size: 22px;
            color: #2b3a42;
        }

        /* ---------- Inputs & Dropdowns ---------- */
        .form-card label {
            font-size: 13px;
            color: #39464d;
        }

        .form-card input,
        .form-card select {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            margin-bottom: 16px;
            border: 1px solid #d5dbe3;
            border-radius: 8px;
            background: #f3f8ff;
            font-size: 14px;
            outline: none;
            transition: border 0.15s ease, box-shadow 0.15s ease;
            box-sizing: border-box;
        }

        .form-card input:focus,
        .form-card select:focus {
            border-color: #7fb1ff;
            box-shadow: 0 4px 14px rgba(127,177,255,0.18);
        }

        /* ---------- Invalid field style (red border) ---------- */
        .form-card .invalid {
            border-color: #e03e2d !important;
            box-shadow: 0 4px 10px rgba(224,62,45,0.12) !important;
            background: #fff6f6;
        }

        .form-card .invalid + .invalid-help {
            color: #d2332a;
            font-size: 12px;
            margin-top: -12px;
            margin-bottom: 12px;
        }

        /* ---------- Buttons ---------- */
        .form-actions {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }

        .btn-primary {
            background: #36a84a;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
            flex: 1;
            text-align: center;
        }

        .btn-primary:hover {
            background: #2e8e3e;
        }

        .btn-cancel {
            background: #dde3ea;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            font-weight: bold;
            flex: 1;
            text-align: center;
        }

        .btn-cancel:hover {
            background: #c8ced6;
        }

        /* ---------- Toast (success notification) ---------- */
        .toast {
            position: fixed;
            right: 20px;
            top: 20px;
            background: #2e8e3e;
            color: white;
            padding: 12px 18px;
            border-radius: 8px;
            box-shadow: 0 10px 24px rgba(0,0,0,0.18);
            opacity: 0;
            transform: translateY(-8px);
            transition: opacity 220ms ease, transform 220ms ease;
            z-index: 9999;
        }
        .toast.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* ---------- Mobile ---------- */
        @media (max-width: 450px) {
            .form-card { width: 94%; padding: 22px; }
            .form-actions { flex-direction: column; }
        }
    </style>
</head>
<body>

<div class="form-page">
    <div class="form-card" id="studentFormCard">

        <h2>
            <c:choose>
                <c:when test="${not empty student}">Edit Student</c:when>
                <c:otherwise>Add Student</c:otherwise>
            </c:choose>
        </h2>

        <!-- Success toast element -->
        <div id="successToast" class="toast" role="status" aria-live="polite">Saved successfully</div>

        <form id="studentForm" method="post" action="${pageContext.request.contextPath}/students" novalidate>

            <input type="hidden" name="id" value="${student.id}" />

            <label>First Name</label>
            <input id="firstName" name="firstName" value="${student.firstName}" required />

            <label>Last Name</label>
            <input id="lastName" name="lastName" value="${student.lastName}" required />

            <label>Email</label>
            <input id="email" type="email" name="email" value="${student.email}" required />

            <!-- COURSE DROPDOWN -->
            <label>Course *</label>
            <select id="course" name="course" required>
                <option value="">-- Select Course --</option>
                <option value="B.Sc"   <c:if test="${student.course=='B.Sc'}">selected</c:if>>B.Sc</option>
                <option value="B.Tech" <c:if test="${student.course=='B.Tech'}">selected</c:if>>B.Tech</option>
                <option value="M.Sc"   <c:if test="${student.course=='M.Sc'}">selected</c:if>>M.Sc</option>
                <option value="M.Tech" <c:if test="${student.course=='M.Tech'}">selected</c:if>>M.Tech</option>
                <option value="MBA"    <c:if test="${student.course=='MBA'}">selected</c:if>>MBA</option>
                <option value="B.Com"  <c:if test="${student.course=='B.Com'}">selected</c:if>>B.Com</option>
                <option value="B.A"    <c:if test="${student.course=='B.A'}">selected</c:if>>B.A</option>
                <option value="Other"  <c:if test="${student.course=='Other'}">selected</c:if>>Other</option>
            </select>
            <div id="courseHelp" class="invalid-help" style="display:none;"></div>

            <!-- GRADE DROPDOWN -->
            <label>Grade *</label>
            <select id="grade" name="grade" required>
                <option value="">-- Select Grade --</option>
                <option value="A" <c:if test="${student.grade=='A'}">selected</c:if>>A</option>
                <option value="B" <c:if test="${student.grade=='B'}">selected</c:if>>B</option>
                <option value="C" <c:if test="${student.grade=='C'}">selected</c:if>>C</option>
                <option value="D" <c:if test="${student.grade=='D'}">selected</c:if>>D</option>
                <option value="F" <c:if test="${student.grade=='F'}">selected</c:if>>F</option>
            </select>
            <div id="gradeHelp" class="invalid-help" style="display:none;"></div>

            <label>Enrollment Date *</label>
            <input id="enrollmentDate" type="date" name="enrollmentDate" value="${student.enrollmentDate}" required />
            <div id="dateHelp" class="invalid-help" style="display:none;"></div>

            <div class="form-actions">
                <button id="saveBtn" type="submit" class="btn-primary">Save</button>
                <a href="${pageContext.request.contextPath}/students" class="btn-cancel">Cancel</a>
            </div>

        </form>
    </div>
</div>

<script>
    (function () {
        const form = document.getElementById('studentForm');
        const toast = document.getElementById('successToast');

        // helper: set invalid class and help text
        function setInvalid(el, helpEl, msg) {
            el.classList.add('invalid');
            if (helpEl) {
                helpEl.textContent = msg || 'This field is required';
                helpEl.style.display = 'block';
            }
        }
        function clearInvalid(el, helpEl) {
            el.classList.remove('invalid');
            if (helpEl) {
                helpEl.textContent = '';
                helpEl.style.display = 'none';
            }
        }

        // validate required fields
        function validate() {
            let ok = true;

            // fields to validate
            const fields = [
                { el: document.getElementById('firstName'), help: null },
                { el: document.getElementById('lastName'), help: null },
                { el: document.getElementById('email'), help: null },
                { el: document.getElementById('course'), help: document.getElementById('courseHelp') },
                { el: document.getElementById('grade'), help: document.getElementById('gradeHelp') },
                { el: document.getElementById('enrollmentDate'), help: document.getElementById('dateHelp') }
            ];

            fields.forEach(f => {
                const value = (f.el.value || '').trim();
                // basic email pattern for client-side
                if (f.el.type === 'email') {
                    const okEmail = value.length > 0 && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
                    if (!okEmail) {
                        setInvalid(f.el, f.help, 'Enter a valid email');
                        ok = false;
                    } else {
                        clearInvalid(f.el, f.help);
                    }
                } else {
                    if (!value) {
                        setInvalid(f.el, f.help);
                        ok = false;
                    } else {
                        clearInvalid(f.el, f.help);
                    }
                }
            });

            return ok;
        }

        // Intercept submit: validate, show success toast, then submit
        form.addEventListener('submit', function (e) {
            // client-side validation
            if (!validate()) {
                // prevent submission if invalid
                e.preventDefault();
                // scroll first invalid into view
                const firstInvalid = document.querySelector('.invalid');
                if (firstInvalid) firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                return;
            }

            // show toast briefly and then let the form submit
            // We show toast and delay submission slightly so user sees it.
            e.preventDefault();

            toast.textContent = 'Saving...';
            toast.classList.add('show');

            // slight delay: submit after 600ms so toast is visible
            setTimeout(function () {
                // change toast to success text (optional)
                toast.textContent = 'Saved successfully';
                // we can either continue to show it while navigation happens,
                // or hide after a short time. We'll wait 400ms then submit.
                setTimeout(function () {
                    // remove show so it will animate out if still visible
                    toast.classList.remove('show');
                }, 400);

                // actually submit form
                form.submit();
            }, 600);
        });

        // If server redirected back with ?saved=1, show the toast on load
        (function showSavedIfRequested() {
            try {
                const params = new URLSearchParams(window.location.search);
                if (params.get('saved') === '1' || params.get('saved') === 'true') {
                    toast.textContent = 'Saved successfully';
                    toast.classList.add('show');
                    setTimeout(() => toast.classList.remove('show'), 2000);
                }
            } catch (er) { /* ignore */ }
        })();
    })();
</script>

</body>
</html>
