package com.yang.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateTimeUtil {
	private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static final String FULL = "yyyy-MM-dd HH:mm:ss";
	public static Date parse(String str) {
		try {
			SimpleDateFormat sdf = new SimpleDateFormat(FULL.substring(0, str.length()));
			return sdf.parse(str);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static String getSysTime(){
		Date date = new Date();
		String dateStr = SDF.format(date);
		return dateStr;
	}

}
