Java中Date对象的创建是通过System.currentTimeMillis()方法获取距1970年1月1日00:00:00UTC时间的毫秒数进行构建的

SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddhhmmss");
SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddhhmmssSSS")
SSS表示毫秒
