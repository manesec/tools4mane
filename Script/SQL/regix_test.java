import java.io.Console;
public class App {
    public static void main(String[] args) throws Exception {
        Console console = System.console();

        while ( true) {
            if (console == null){
                continue;
            }    
            
            String readline = console.readLine();

            readline = readline.replaceAll(" |OR|or|AND|and|LIMIT|limit|OFFSET|offset|WHERE|where|SELECT|select|UPDATE|update|DELETE|delete|DROP|drop|CREATE|create|INSERT|insert|FUNCTION|function|CAST|cast|ASCII|ascii|SUBSTRING|substring|VARCHAR|varchar|/\\*\\*/|;|LENGTH|length|--$", "");
            String sql = "> SELECT * FROM users WHERE username = '" + readline + "'";
            System.out.println(sql);

        }
    }
}
