From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.5 patch] remove an unused variable from fd_mcs.c
Date: Sat, 21 Jun 2003 16:31:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030621143134.GV29247@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au
List-Id: linux-scsi@vger.kernel.org

The patch belowremoves an unused variable from drivers/scsi/fd_mcs.c .

I've tested the compilation with 2.5.72-mm2.



--- linux-2.5.72-mm2/drivers/scsi/fd_mcs.c.old	2003-06-21 16:28:39.000000000 +0200
+++ linux-2.5.72-mm2/drivers/scsi/fd_mcs.c	2003-06-21 16:28:43.000000000 +0200
@@ -589,7 +589,6 @@
 static int fd_mcs_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout)
 {
 	int len = 0;
-	int i;
 
 	if (inout)
 		return (-ENOSYS);



Please apply
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
