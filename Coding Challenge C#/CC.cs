 //Insurance Claim Management System 


//using System;
//using System.Collections.Generic;
//using System.Data.SqlClient;
//using System.Configuration;

//// Q1: ENTITY CLASSES
//// Q2: Each class below includes default/parameterized constructors, getters/setters, and ToString()

//// Q1.1 & Q2: User class
//class User
//{
//    public int UserId { get; set; }
//    public string Username { get; set; }
//    public string Password { get; set; }
//    public string Role { get; set; }
//    public User() { }
//    public User(int id, string name, string pwd, string role)
//    {
//        UserId = id; Username = name; Password = pwd; Role = role;
//    }
//    public override string ToString() => "UserId: " + UserId + ", Username: " + Username + ", Role: " + Role;
//}

//// Q1.2 & Q2: Client class
//class Client
//{
//    public int ClientId { get; set; }
//    public string ClientName { get; set; }
//    public string ContactInfo { get; set; }
//    public int PolicyId { get; set; }
//    public Client() { }
//    public Client(int id, string name, string contact, int policyId)
//    {
//        ClientId = id; ClientName = name; ContactInfo = contact; PolicyId = policyId;
//    }
//    public override string ToString() => "ClientId: " + ClientId + ", Name: " + ClientName + ", Contact: " + ContactInfo + ", PolicyId: " + PolicyId;
//}

//// Q8: CUSTOM EXCEPTIONS 
//class PolicyNotFoundException : Exception
//{
//    public PolicyNotFoundException(string msg) : base(msg) { }
//}

////Q3: DAO INTERFACE 
//interface IPolicyService
//{
//    Policy GetPolicy(int policyId);
//    List<Policy> GetAllPolicies();
//}

////Q6: DAO IMPLEMENTATION 
//class InsuranceServiceImpl : IPolicyService
//{
//    SqlConnection conn = DBConnectionUtil.GetConnection();

//    public Policy GetPolicy(int policyId)
//    {
//        string query = "SELECT * FROM Policy WHERE PolicyId=@id";
//        SqlCommand cmd = new SqlCommand(query, conn);
//        cmd.Parameters.AddWithValue("@id", policyId);
//        conn.Open();
//        SqlDataReader dr = cmd.ExecuteReader();
//        if (dr.Read())
//        {
//            Policy policy = new Policy()
//            {
//                PolicyId = dr.GetInt32(0),
//                PolicyName = dr.GetString(1),
//                PremiumAmount = dr.GetDecimal(2),
//                Duration = dr.GetInt32(3)
//            };
//            conn.Close();
//            return policy;
//        }
//        conn.Close();
//        throw new PolicyNotFoundException("Policy not found: " + policyId);
//    }

//    public List<Policy> GetAllPolicies()
//    {
//        string query = "SELECT * FROM Policy";
//        List<Policy> list = new List<Policy>();
//        SqlCommand cmd = new SqlCommand(query, conn);
//        conn.Open();
//        SqlDataReader dr = cmd.ExecuteReader();
//        while (dr.Read())
//        {
//            Policy policy = new Policy()
//            {
//                PolicyId = dr.GetInt32(0),
//                PolicyName = dr.GetString(1),
//                PremiumAmount = dr.GetDecimal(2),
//                Duration = dr.GetInt32(3)
//            };
//            list.Add(policy);
//        }
//        conn.Close();
//        return list;
//    }
//}

//// Entity class used in DB layer 
//class Policy
//{
//    public int PolicyId { get; set; }
//    public string PolicyName { get; set; }
//    public decimal PremiumAmount { get; set; }
//    public int Duration { get; set; }
//}

////Q7: DB CONNECTION UTILITY
//class DBConnectionUtil
//{
//    private static SqlConnection conn;
//    public static SqlConnection GetConnection()
//    {
//        if (conn == null)
//            conn = new SqlConnection("Server=LAPTOP-D19876AQ;Initial Catalog=CCDB;Integrated Security=True");
//        return conn;
//    }
//}

////Q9: MAIN METHOD (UI)
//class MainModule
//{
//    static void Main(string[] args)
//    {
//        IPolicyService service = new InsuranceServiceImpl();
//        try
//        {
//            while (true)
//            {
//                Console.WriteLine("\n--- Insurance Policy Management ---");
//                Console.WriteLine("1. Register New Client with Policy");
//                Console.WriteLine("2. View Policy by ID");
//                Console.WriteLine("3. View All Policies");
//                Console.WriteLine("4. Exit");
//                Console.Write("Enter Choice: ");
//                int ch = int.Parse(Console.ReadLine());

//                switch (ch)
//                {
//                    case 1:
//                        SqlConnection conn = DBConnectionUtil.GetConnection();

//                        Console.Write("Enter Client Name: ");
//                        string clientName = Console.ReadLine();
//                        Console.Write("Enter Client Email: ");
//                        string email = Console.ReadLine();

//                        // policy options from DB
//                        string fetchPolicies = "SELECT PolicyId, PolicyName FROM Policy";
//                        SqlCommand fetchCmd = new SqlCommand(fetchPolicies, conn);
//                        conn.Open();
//                        SqlDataReader dr = fetchCmd.ExecuteReader();
//                        Console.WriteLine("\nAvailable Policies:");
//                        while (dr.Read())
//                            Console.WriteLine($"{dr.GetInt32(0)} - {dr.GetString(1)}");
//                        conn.Close();

//                        Console.Write("Enter Policy ID from the above options: ");
//                        int policyId = int.Parse(Console.ReadLine());

//                        // Validation of  selected policy whether exist or not
//                        Policy selectedPolicy;
//                        try { selectedPolicy = service.GetPolicy(policyId); }
//                        catch (PolicyNotFoundException ex)
//                        {
//                            Console.WriteLine(ex.Message);
//                            break;
//                        }

//                        // Generating new User ID
//                        string getMaxUserId = "SELECT ISNULL(MAX(UserId), 0) + 1 FROM [User]";
//                        SqlCommand getUserCmd = new SqlCommand(getMaxUserId, conn);
//                        conn.Open();
//                        int newUserId = Convert.ToInt32(getUserCmd.ExecuteScalar());
//                        conn.Close();

//                        string username = clientName.ToLower().Replace(" ", "");
//                        Console.Write("Enter Password for new user: ");
//                        string password = Console.ReadLine();
//                        string role = "client";

//                        string insertUser = "INSERT INTO [User] (UserId, Username, Password, Role) VALUES (@id, @name, @pass, @role)";
//                        SqlCommand userCmd = new SqlCommand(insertUser, conn);
//                        userCmd.Parameters.AddWithValue("@id", newUserId);
//                        userCmd.Parameters.AddWithValue("@name", username);
//                        userCmd.Parameters.AddWithValue("@pass", password);
//                        userCmd.Parameters.AddWithValue("@role", role);

//                        conn.Open();
//                        int userRes = userCmd.ExecuteNonQuery();
//                        conn.Close();

//                        // Generating new ClientId
//                        string getMaxClientId = "SELECT ISNULL(MAX(ClientId), 0) + 1 FROM Client";
//                        SqlCommand getClientCmd = new SqlCommand(getMaxClientId, conn);
//                        conn.Open();
//                        int newClientId = Convert.ToInt32(getClientCmd.ExecuteScalar());
//                        conn.Close();

//                        string insertClient = "INSERT INTO Client (ClientId, ClientName, ContactInfo, PolicyId) VALUES (@id, @name, @email, @policyId)";
//                        SqlCommand clientCmd = new SqlCommand(insertClient, conn);
//                        clientCmd.Parameters.AddWithValue("@id", newClientId);
//                        clientCmd.Parameters.AddWithValue("@name", clientName);
//                        clientCmd.Parameters.AddWithValue("@email", email);
//                        clientCmd.Parameters.AddWithValue("@policyId", policyId);

//                        conn.Open();
//                        int clientRes = clientCmd.ExecuteNonQuery();
//                        conn.Close();

//                        if (userRes > 0 && clientRes > 0)
//                            Console.WriteLine("Client registered and assigned policy successfully.");
//                        else
//                            Console.WriteLine("Registration failed.");
//                        break;

//                    case 2:
//                        Console.Write("Enter Policy ID to View: ");
//                        int viewId = int.Parse(Console.ReadLine());
//                        Policy foundPolicy = service.GetPolicy(viewId);
//                        Console.WriteLine("Found Policy: " + foundPolicy.PolicyName);
//                        break;

//                    case 3:
//                        Console.WriteLine("--- All Policies ---");
//                        List<Policy> policies = service.GetAllPolicies();
//                        foreach (Policy p in policies)
//                            Console.WriteLine(p.PolicyId + " - " + p.PolicyName);
//                        break;

//                    case 4:
//                        Console.WriteLine("Exiting program...");
//                        return;

//                    default:
//                        Console.WriteLine("Invalid Choice.");
//                        break;
//                }
//            }
//        }
//        catch (PolicyNotFoundException ex)
//        {
//            Console.WriteLine("Policy Error: " + ex.Message);
//        }
//        catch (FormatException)
//        {
//            Console.WriteLine("Invalid input format. Please enter valid values.");
//        }
//        catch (Exception ex)
//        {
//            Console.WriteLine("General Error: " + ex.Message);
//        }
//    }
//}

