From: Joel Buckley <joel.buckley@sun.com>
Subject: 2.4.20 & 2.5.63 scsi_scan.c for Sun StorEdge[tm] array SparseLUN
 support
Date: Mon, 24 Feb 2003 16:07:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5AA5CF.6090501@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100070300090506020103"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org, joel.buckley@sun.com

This is a multi-part message in MIME format.
--------------080100070300090506020103
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jens, et.al.,

Hello, I work on the Sun StorEdge[tm] arrays for Sun Microsystems, Inc.
As part of my testing of Linux, the attached changes are needed to enable
Sparse LUN support for Sun StorEdge[tm] arrays.

Please apply to Both the 2.4.20 and 2.5.63 kernel releases.

If there are any questions, please contact me directly.

Thank you,
Joel.

-- 
Joel.Buckley@Sun.COM
Sun Microsystems, Inc.
303-272-5556  x75556 


--------------080100070300090506020103
Content-Type: text/plain;
 name="linux-2.4.20-scsi_scan.c.diffs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.20-scsi_scan.c.diffs"

--- linux-2.4.20/drivers/scsi/scsi_scan.c	Thu Nov 28 16:53:14 2002
+++ linux-2.4.20/drivers/scsi/scsi_scan.c	Mon Feb 24 15:53:48 2003
@@ -182,6 +182,8 @@
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SUN", "T300", "*", BLIST_SPARSELUN},
+	{"SUN", "T4", "*", BLIST_SPARSELUN},
 
 	/*
 	 * Must be at end of list...

--------------080100070300090506020103
Content-Type: text/plain;
 name="linux-2.5.63-scsi_scan.c.diffs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.5.63-scsi_scan.c.diffs"

--- linux-2.5.63/drivers/scsi/scsi_scan.c	Mon Feb 24 12:05:39 2003
+++ linux-2.5.63/drivers/scsi/scsi_scan.c	Mon Feb 24 16:00:46 2003
@@ -189,6 +189,8 @@
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SUN", "T300", "*", BLIST_SPARSELUN},
+	{"SUN", "T4", "*", BLIST_SPARSELUN},
 	{ NULL, NULL, NULL, 0 },
 };
 

--------------080100070300090506020103--

