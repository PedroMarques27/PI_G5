
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
    public enum PROFILES {OWNER, STAFF, DEFAULT};

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
        var extra =" Integrated Security=SSPI;";
        return new SqlConnection("Server=sql-dev.ua.pt;Database=muprr-dev;Trusted_Connection=True;");
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
    public void InsertMup(MupTable mpt)
    {
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "INSERT MUP (vinculo, profile, classGroup, uo) VALUES (@VINC, @PROF, @CSG, @UO)";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@VINC", mpt.vinculo);
        cmd.Parameters.AddWithValue("@PROF", mpt.profile);
        cmd.Parameters.AddWithValue("@CSG", mpt.classGroup);
        cmd.Parameters.AddWithValue("@UO", mpt.uo);
        cmd.Connection = connection;
   
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }    
    }
    public void InsertUserAssociation(BRB_RCU_ASSOC _assoc)
    {
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "INSERT MUPRR.BRB_RCU_ASSOC (BRB_ID, RCU_ID, UU) VALUES (@BRB_ID, @RCU_ID, @UU)";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@BRB_ID", _assoc.brb_id);
        cmd.Parameters.AddWithValue("@RCU_ID", _assoc.rcu_id);
        cmd.Parameters.AddWithValue("@UU", _assoc.email);
        cmd.Connection = connection;
   
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }    
    }
    public void InsertProfile(Profile profile)
    {
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "INSERT Profile (id, name) VALUES (@id, @name)";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", profile.id);
        cmd.Parameters.AddWithValue("@name", profile.name);
      
        cmd.Connection = connection;
   
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }    
    }
    public void InsertVinculo(Vinculo v)
    {
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "INSERT Vinculo (sigla, descricao) VALUES (@sig, @desc)";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@sig", v.sigla);
        cmd.Parameters.AddWithValue("@desc", v.description);
        
        cmd.Connection = connection;
   
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }    
    }
    public void InsertUO(UO uo)
    {
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "INSERT UnidadeOrganica (sigla, descricao) VALUES (@sig, @desc)";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@sig", uo.sigla);
        cmd.Parameters.AddWithValue("@desc", uo.description);
        cmd.Connection = connection;
   
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }    
    }
    public void InsertClassroomGroup(ClassroomGroup csg)
    {
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "INSERT ClassroomGroup (id, name) VALUES (@id, @name)";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", csg.id);
        cmd.Parameters.AddWithValue("@name", csg.name);
   
        cmd.Connection = connection;
   
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }    
    }

    //Update statement
    public void UpdateMUP(MupTable mpt)
    {
        int rows = 0;
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
          
        cmd.CommandText = "UPDATE MUP SET vinculo = @VINC, profile = @PROF, classGroup = @CSG, uo = @UO  WHERE id = @ID";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@VINC", mpt.vinculo);
        cmd.Parameters.AddWithValue("@PROF", mpt.profile);
        cmd.Parameters.AddWithValue("@CSG", mpt.classGroup);
        cmd.Parameters.AddWithValue("@UO", mpt.uo);
        cmd.Parameters.AddWithValue("@ID", mpt.id);
        cmd.Connection = connection;

        try
        {
            rows = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }
    }
    public void UpdateUserAssociations(BRB_RCU_ASSOC _ASSOC)
    {
        int rows = 0;
        if (!verifySGBDConnection())
                return;
        SqlCommand cmd = new SqlCommand();
          
        cmd.CommandText = "UPDATE BRB_RCU_ASSOC SET BRB_ID = @BRB_ID, UU = @UU WHERE RCU_ID = @RCU_ID";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@BRB_ID", _ASSOC.brb_id);
        cmd.Parameters.AddWithValue("@UU", _ASSOC.email);
        cmd.Parameters.AddWithValue("@RCU_ID", _ASSOC.rcu_id);
        
        cmd.Connection = connection;

        try
        {
            rows = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to update contact in database. \n ERROR MESSAGE: \n" + ex.Message);
        }
          
    }
    
    
    
    //Delete statement
      public void DeleteUserAssociations(string rcuId)
    {
        if (!verifySGBDConnection())
            return ;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "DELETE BRB_RCU_ASSOC WHERE RCU_ID = @RCU_ID";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@RCU_ID", rcuId);
        cmd.Connection = connection;
          
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to delete in database. \n ERROR MESSAGE: \n" + ex.Message);
        }


    }
    public void DeleteVinculo(int id)
    {
        if (!verifySGBDConnection())
            return ;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "DELETE Vinculo WHERE id=@id ";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", id);
        cmd.Connection = connection;
          
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to delete in database. \n ERROR MESSAGE: \n" + ex.Message);
        }
    }
    public void DeleteProfile(string id)
    {
        if (!verifySGBDConnection())
            return ;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "DELETE Profile WHERE id=@id ";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", id);
        cmd.Connection = connection;
          
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to delete in database. \n ERROR MESSAGE: \n" + ex.Message);
        }
    }
    public void DeleteUO(int id)
    {
        if (!verifySGBDConnection())
            return ;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "DELETE UnidadeOrganica WHERE id=@id ";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", id);
        cmd.Connection = connection;
          
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to delete in database. \n ERROR MESSAGE: \n" + ex.Message);
        }

    }
    public void DeleteClassroomGroup(string id)
    {
        if (!verifySGBDConnection())
            return ;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "DELETE ClassroomGroup WHERE id=@id ";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", id);
        cmd.Connection = connection;
          
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to delete in database. \n ERROR MESSAGE: \n" + ex.Message);
        }
    }
    public void DeleteMup(int id)
    {
        if (!verifySGBDConnection())
            return ;
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "DELETE MUP WHERE id=@id ";
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@id", id);
        cmd.Connection = connection;
          
        try
        {
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            throw new Exception("Failed to delete in database. \n ERROR MESSAGE: \n" + ex.Message);
        }
        
    }


    //Select statement
    public BRB_RCU_ASSOC SelectUserFromIUPI(string iupi)
    {
        BRB_RCU_ASSOC data = new BRB_RCU_ASSOC();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM BRB_RCU_ASSOC WHERE RCU_ID=@RCU_ID", connection);
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@RCU_ID", iupi);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            data.brb_id = (reader["BRB_ID"].ToString());
            data.rcu_id = reader["RCU_ID"].ToString();
            data.email = reader["UU"].ToString();
        }
        reader.Close();
        return data;
    }
    public List<BRB_RCU_ASSOC> SelectUserAssociations()
    {
        List<BRB_RCU_ASSOC> data = new List<BRB_RCU_ASSOC>();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM MUPRR.BRB_RCU_ASSOC", connection);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            BRB_RCU_ASSOC v = new BRB_RCU_ASSOC();
            v.brb_id = (reader["BRB_ID"].ToString());
            v.rcu_id = reader["RCU_ID"].ToString();
            v.email = reader["UU"].ToString();
            data.Add(v);
        }
        reader.Close();
        return data;
    }
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
            v.description = reader["descricao"].ToString();
            data.Add(v);
        }
        reader.Close();
        return data;


    }
    public Profile SelectProfileById(string id){
        Profile data = new Profile();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM Profile WHERE id=@ID", connection);
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@ID", id);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            data.id = reader["id"].ToString();
            data.name = reader["name"].ToString();

        }
        return data;
    }
    public List<Profile> SelectProfile()
    {
        List<Profile> data = new List<Profile>();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM Profile", connection);
        SqlDataReader reader = cmd.ExecuteReader(); 
        while (reader.Read())
        {
            Profile v = new Profile();
            v.id = reader["id"].ToString();
            v.name = reader["name"].ToString();
        
            data.Add(v);
        }
        reader.Close();
        return data;


    }
    public List<UO> SelectUO()
    {
        List<UO> data = new List<UO>();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM UnidadeOrganica", connection);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            UO v = new UO();
            v.id = int.Parse(reader["id"].ToString());
            v.sigla = reader["sigla"].ToString();
            v.description = reader["descricao"].ToString();
            data.Add(v);
        }
        return data;


    }
    public List<ClassroomGroup> SelectClassroomGroup()
    {
        List<ClassroomGroup> data = new List<ClassroomGroup>();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM ClassroomGroup", connection);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            ClassroomGroup v = new ClassroomGroup();
            v.id = reader["id"].ToString();
            v.name = reader["name"].ToString();
            data.Add(v);
        }
        return data;


    }
    public List<MupTable> SelectMup()
    {
        List<MupTable> data = new List<MupTable>();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM MUP", connection);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            MupTable v = new MupTable();
            v.id = int.Parse(reader["id"].ToString());
            v.uo = int.Parse(reader["uo"].ToString());
            v.vinculo = int.Parse(reader["vinculo"].ToString());
            v.profile = reader["profile"].ToString();
            v.profile = reader["classGroup"].ToString();
            data.Add(v);
        }
        return data;


    }

    public MupTable SelectSpecificMup(int uo, int vinculo)
    {
        MupTable data = new MupTable();
        if (!verifySGBDConnection())
            return data;

        SqlCommand cmd = new SqlCommand("SELECT * FROM MUP WHERE uo=@UO AND vinculo = @VINCULO", connection);
        cmd.Parameters.Clear();
        cmd.Parameters.AddWithValue("@UO", uo);
        cmd.Parameters.AddWithValue("@VINCULO", vinculo);
        SqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            data.id = int.Parse(reader["id"].ToString());
            data.uo = int.Parse(reader["uo"].ToString());
            //data.uo = reader["uo"].ToString();
            data.vinculo = int.Parse(reader["vinculo"].ToString());
            //data.vinculo = reader["vinculo"].ToString();
            data.profile = reader["profile"].ToString();
            data.profile = reader["classGroup"].ToString();
        }
        return data;
    }
    }
}