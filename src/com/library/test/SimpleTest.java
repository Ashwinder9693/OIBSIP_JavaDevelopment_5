package com.library.test;

import org.junit.Test;
import static org.junit.Assert.*;

public class SimpleTest {
    @Test
    public void testAddition() {
        assertEquals(4, 2 + 2);
    }
    
    @Test
    public void testString() {
        String str = "Hello World";
        assertNotNull(str);
        assertTrue(str.length() > 0);
        assertEquals("Hello World", str);
    }
}