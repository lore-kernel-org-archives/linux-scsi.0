From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] current scsi-misc-2.5 include files
Date: Thu, 21 Nov 2002 09:08:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121090844.A17281@eng2.beaverton.ibm.com>
References: <dledford@redhat.com> <200211211612.gALGCNo03331@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211211612.gALGCNo03331@localhost.localdomain>; from James.Bottomley@SteelEye.com on Thu, Nov 21, 2002 at 10:12:23AM -0600
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, Nov 21, 2002 at 10:12:23AM -0600, J.E.J. Bottomley wrote:
> The scsi-misc-2.5 resync should be done now.
> 
> James

Hi -

hardirq.h and init.h were removed from scsi.h. So I had to make the
following changes to compile. I also removed two extraneous includes. 

--- 1.52/drivers/scsi/scsi_lib.c	Thu Nov 21 07:52:29 2002
+++ edited/drivers/scsi/scsi_lib.c	Thu Nov 21 08:48:16 2002
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/kernel.h>
 #include <linux/blk.h>
+#include <asm/hardirq.h>
 #include <linux/smp_lock.h>
 #include <linux/completion.h>
 
===== drivers/scsi/scsi_proc.c 1.10 vs edited =====
--- 1.10/drivers/scsi/scsi_proc.c	Wed Nov 20 17:17:50 2002
+++ edited/drivers/scsi/scsi_proc.c	Thu Nov 21 08:47:56 2002
@@ -16,14 +16,13 @@
  * Michael A. Griffith <grif@acm.org>
  */
 
-#include <linux/config.h>
 #include <linux/module.h>
+#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/errno.h>
-#include <linux/stat.h>
 #include <linux/blk.h>
 #include <asm/uaccess.h>
 
-- Patrick Mansfield
