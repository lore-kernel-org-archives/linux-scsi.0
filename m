From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] NCR5380.c compile fix Re: Linux v2.5.50
Date: Fri, 06 Dec 2002 14:40:18 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021206035757.C07B62C2BC@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, linux-scsi@vger.kernel.org

From:  Paul <set@pobox.com>

  Linus Torvalds <torvalds@transmeta.com>, on Wed Nov 27, 2002 [03:07:38 PM] said:
  > 
  > Taking a small thanksgiving break, but before that here's 2.5.50.
  > 
  
  	Hi;
  
  	Needed this so NCR5380.c would compile. (via pas16)
  
  Paul
  set@pobox.com
  

--- trivial-2.5-bk/drivers/scsi/NCR5380.c.orig	2002-12-06 13:56:49.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/NCR5380.c	2002-12-06 13:56:49.000000000 +1100
@@ -1477,8 +1477,8 @@
 	int len;
 	unsigned long timeout;
 	unsigned char value;
-	NCR5380_setup(instance);
 	int err;
+	NCR5380_setup(instance);
 
 	if (hostdata->selecting) {
 		if(instance->irq != IRQ_NONE)
-- 
  Don't blame me: the Monkey is driving
  File: Paul <set@pobox.com>: [uPATCH] NCR5380.c compile fix Re: Linux v2.5.50
