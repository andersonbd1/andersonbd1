import java.util.ArrayList;
import java.util.List;

public class MemoryHog {
    public static void main(String[] args) {
        List l = new ArrayList();
        int mb = Integer.parseInt(args[0]);
        System.out.println("mb: "+mb);
        for (int i=0; i<(mb*1024); i++) {
        //while ("1".equals("1")) {
            //arr[i++] = new byte[1024];
            l.add(new byte[1024]);
            /*
            if (i % 1000 == 0)
                System.out.println("i: "+i);
            */
        }
        System.out.println("array filled - sleeping");
        try {
            Thread.sleep(100000);
        } catch (Throwable t) {
        }
        System.out.println("Hello");
    }
}
