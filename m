From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove unused include in scsi_ioctl.c
Date: Thu, 21 Nov 2002 00:37:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121003725.A8517@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This time I explicitly checked for the in_atomic mess..


--- 1.18/drivers/block/scsi_ioctl.c	Sat Nov  2 16:58:08 2002
+++ edited/drivers/block/scsi_ioctl.c	Wed Nov 20 02:20:15 2002
@@ -7,7 +7,7 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
-
+ *
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
@@ -16,26 +16,20 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
  *
  */
-#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
-#include <linux/config.h>
-#include <linux/swap.h>
-#include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
-#include <linux/blk.h>
+#include <linux/blkdev.h>
 #include <linux/completion.h>
 #include <linux/cdrom.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
+#include <asm/uaccess.h>
 
-#include "../scsi/scsi.h"
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 
-#include <asm/uaccess.h>
 
 /* Command group 3 is reserved and should never be used.  */
 const unsigned char scsi_command_size[8] =
