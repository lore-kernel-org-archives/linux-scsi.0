From: Andries.Brouwer@cwi.nl
Subject: [patch] isa_writeb args interchanged
Date: Fri, 23 May 2003 00:26:25 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200305222226.h4MMQP519152.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h	Thu May 22 13:17:01 2003
+++ b/drivers/scsi/g_NCR5380.h	Fri May 23 01:23:21 2003
@@ -102,7 +102,7 @@
 #define NCR5380_region_size 0x3a00
 
 #define NCR5380_read(reg) isa_readb(NCR5380_map_name + NCR53C400_mem_base + (reg))
-#define NCR5380_write(reg, value) isa_writeb(NCR5380_map_name + NCR53C400_mem_base + (reg), value)
+#define NCR5380_write(reg, value) isa_writeb(value, NCR5380_map_name + NCR53C400_mem_base + (reg))
 #endif
 
 #define NCR5380_implementation_fields \
