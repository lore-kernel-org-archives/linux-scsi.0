From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI sim710.c: make some code static
Date: Wed, 2 Feb 2005 20:52:31 +0100
Message-ID: <20050202195231.GH3313@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 15 Nov 2004

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/sim710.c.old	2004-11-14 01:27:51.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/sim710.c	2004-11-14 01:28:48.000000000 +0100
@@ -47,7 +47,7 @@
 #define MAX_SLOTS 8
 static __u8 __initdata id_array[MAX_SLOTS] = { [0 ... MAX_SLOTS-1] = 7 };
 
-char *sim710;		/* command line passed by insmod */
+static char *sim710;		/* command line passed by insmod */
 
 MODULE_AUTHOR("Richard Hirst");
 MODULE_DESCRIPTION("Simple NCR53C710 driver");
@@ -61,7 +61,7 @@
 #define ARG_SEP ','
 #endif
 
-__init int
+static __init int
 param_setup(char *str)
 {
 	char *pos = str, *next;
@@ -314,7 +314,7 @@
 				   differential, scsi_id);
 }
 
-struct eisa_driver sim710_eisa_driver = {
+static struct eisa_driver sim710_eisa_driver = {
 	.id_table		= sim710_eisa_ids,
 	.driver = {
 		.name		= "sim710",
