<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.sql.*" %>
<%@ page contentType='text/html ; charset=UTF-8' %>
<html>

  <body>
  <jsp:include page="formulaire.html" />
    <h1>Panier</h1>
    <% 
    try{

      Connection connect = null;
      Statement statement = null;
      Statement statementSupp = null;
      Statement statementTotal = null;
      ResultSet rs = null;
      ResultSet rsTotal = null;
      String name,pass,url; 
      int fp = 0;
      int pt = 0;
      Class.forName("com.mysql.cj.jdbc.Driver");  
      url="jdbc:mysql://localhost:3306/panier";  
      name="root";  
      pass="";  
      connect = DriverManager.getConnection(url,name,pass);
      statement = connect.createStatement();
      if(request.getParameter("nom")!="" && request.getParameter("prix")!=null){
        statement.executeUpdate("INSERT INTO item (nom,prix) VALUES ('"+request.getParameter("nom")+"',"+request.getParameter("prix")+")");
      }
      rs = statement.executeQuery("SELECT * FROM item");
      while (rs.next()) {
        out.println("<h3> produit : "+rs.getString("nom")+"</h3>");
        out.println("<p> reference : "+rs.getInt("reference")+"</p>");
        out.println("<p> prix :"+rs.getInt("prix")+"€</p>");
        %>
        <form method="post" action="">
          <input type="submit" value="supprimer" name=<% out.println("supprimer"+rs.getInt("reference")); %>>
        </form>
        <%
        if(request.getParameter("supprimer"+rs.getInt("reference"))!=null){
          statementSupp = connect.createStatement();
          statementSupp.executeUpdate("DELETE FROM item WHERE reference="+rs.getInt("reference"));
          response.setIntHeader("Refresh", 0);
        }

        out.println("<hr>");
        
      }
      statementTotal = connect.createStatement();
      rsTotal = statementTotal.executeQuery("SELECT sum(prix) as total FROM item");
      rsTotal.next();
      pt = rsTotal.getInt("total");
      
      //////////////////
      String strFp="Pas de frais de port.";
      if(pt == 0){
        fp = 0;
      }else if(pt >= 100){
        fp = 0;
      }else if(pt < 50){
        fp = 5;
        pt+=fp;
        strFp = "Le frais de port est de "+fp+"€";
      }else{
        fp = 8;
        pt+=fp;
        strFp = "Le frais de port est de "+fp+"€";
      }
      out.println("<h4>Prix total : "+pt+"€ </h4>");
      out.println("<h4>"+strFp+"</h4>");
      ///////////////////
      connect.close();
    }catch(Exception e){
      out.println(e);      
    }
    
    
    %>      
    
  <body>
</html>