package com.yourorg.sms.listener;

import com.yourorg.sms.dao.StudentDAO;
import com.yourorg.sms.model.Student;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;
import java.util.concurrent.*;

@WebListener
public class AppStartupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // single-thread scheduler for periodic tasks
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // initial immediate refresh, then every 5 minutes
        scheduler.scheduleAtFixedRate(() -> {
            try {
                StudentDAO dao = new StudentDAO();
                List<Student> students = dao.findAll();
                // store cache in servlet context
                sce.getServletContext().setAttribute("studentCache", students);
                System.out.println("[AppStartupListener] studentCache refreshed: " + (students == null ? 0 : students.size()));
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }, 0, 5, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
