From: prasanna kori <prasannakori@yahoo.com>
Subject: how to write more than 256 bytes to tape
Date: Wed, 7 Apr 2004 00:23:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040407072332.11162.qmail@web12204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web12204.mail.yahoo.com ([216.136.173.88]:63279 "HELO
	web12204.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264131AbUDGHXd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2004 03:23:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


hi,

          i have HP surestore 40*6 ( 40GB, 6 slots)
autoloader tape device. i am using RedHat Linux 8.0,
lk 2.4.18-14. it supports sg (scsi generic driver)
3.x. 

         i am using HBA ( host bus adapter), adaptec
29160 ultra160 card. it uses aicxxxx.o as the low
level driver.

       i am working on scsi read(6)  & write(6) byte
commands, they are working. but i can't write more
than 256 bytes at one time. i want to write more than
32kb per read/write operation.

     if i try to use write(10 byte) command it says
invalid cdb.

 please give me a solution.

regards,

prasanna kori
        

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
