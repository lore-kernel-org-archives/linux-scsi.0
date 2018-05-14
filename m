From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: clean up generated file scsi_devinfo_tbl.c
Date: Sun, 13 May 2018 17:10:52 -0700
Message-ID: <6e64c815-43dd-3945-6c58-66b1e0533403@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

"make clean" should remove the generated file "scsi_devinfo_tbl.c",
so list it in the clean-files variable so that the file gets
cleaned up.

Fixes: 345e29608b4b ("scsi: scsi: Export blacklist flags to sysfs")

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/scsi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-4.17-rc4.orig/drivers/scsi/Makefile
+++ linux-4.17-rc4/drivers/scsi/Makefile
@@ -182,7 +182,7 @@ zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
 
 # Files generated that shall be removed upon make clean
-clean-files :=	53c700_d.h 53c700_u.h
+clean-files :=	53c700_d.h 53c700_u.h scsi_devinfo_tbl.c
 
 $(obj)/53c700.o $(MODVERDIR)/$(obj)/53c700.ver: $(obj)/53c700_d.h
 
