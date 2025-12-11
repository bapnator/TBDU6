package ZoologicoAppU6;

import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import com.formdev.flatlaf.FlatLightLaf;

public class App {
    public static void main(String[] args) {
        try { UIManager.setLookAndFeel(new FlatLightLaf()); } catch (UnsupportedLookAndFeelException e) { e.printStackTrace(); }
        FrameAnimales a = new FrameAnimales();
        a.setVisible(true);
    }
}