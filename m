From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/constants.c should include scsi_dbg.h
Date: Sat, 20 Aug 2005 21:27:27 +0200
Message-ID: <20050820192727.GF3615@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750833AbVHTT1a@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

C files should include the files with the prototypes for their global 
functions.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.13-rc6-mm1/drivers/scsi/constants.c.old	2005-08-20 14:42:12.000000000 +0200
+++ linux-2.6.13-rc6-mm1/drivers/scsi/constants.c	2005-08-20 14:43:03.000000000 +0200
@@ -17,6 +17,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_request.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_dbg.h>
 
 
 
