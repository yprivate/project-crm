package com.yang;

import static org.junit.Assert.assertTrue;

import com.yang.domane.Student;
import org.junit.Test;

/**
 * Unit test for simple App.
 */
public class AppTest 
{
    /**
     * Rigorous Test :-)
     */
    @Test
    public void shouldAnswerWithTrue() {
        int s1=5;
        int s2=4;
        s1=s2;
        s2=10;
        System.out.println(s1);
        Student str1 = new Student("0x115","张三","12");
        Student str2 = new Student("0x100","李四","15");
        str1=str2;
        str2.setNo("0000");
        System.out.println(str1);
    }
}
