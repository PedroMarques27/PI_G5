
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using MUP_RR.Models;


namespace MUP_RR.Controllers
{
    public class DBConnector
    {  

    private SqlConnection connection;

    //Constructor
    public DBConnector()
    {
        connection = OpenConnection();
    }

    //Initialize values
    private SqlConnection OpenConnection()
    {
      

        
        return new SqlConnection("Server=sql-dev.ua.pt;Database=muprr-dev;Trusted_Connection=True;");;
    }

    private bool verifySGBDConnection()
    {
        if (connection == null)
            connection = OpenConnection();

        if (connection.State != ConnectionState.Open)
            connection.Open();

        return connection.State == ConnectionState.Open;
    }

    //Close connection
    private bool CloseConnection()
    {
        connection.Close();
        return connection.State == ConnectionState.Closed;
    }

    //Insert statement
    public void Insert()
    {
    }

    //Update statement
    public void Update()
    {
    }

    //Delete statement
    public void Delete()
    {
    }

    //Select statement
    public List<Vinculo> SelectVinculo()
    {
        List<Vinculo> data = new List<Vinculo>();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM Vinculo", connection);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Vinculo v = new Vinculo();
            v.id = int.Parse(reader["id"].ToString());
            v.sigla = reader["sigla"].ToString();
            v.description = reader["description"].ToString();
            data.Add(v);
        }
        return data;


    }

    //Count statement
    public int Count()
    {
        return 0;
    }

    //Backup
    public void Backup()
    {
    }

    //Restore
    public void Restore()
    {
    }   
       

    }
}