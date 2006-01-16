From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] sym53c8xx_2: fix compilation on alpha
Date: Mon, 16 Jan 2006 03:00:35 +0300
Message-ID: <20060116000035.GA3794@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uproxy.gmail.com ([66.249.92.194]:65272 "EHLO uproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750990AbWAOXnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jan 2006 18:43:24 -0500
Received: by uproxy.gmail.com with SMTP id s2so479235uge
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2006 15:43:23 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>

  CC [M]  drivers/scsi/sym53c8xx_2/sym_fw.o
In file included from drivers/scsi/sym53c8xx_2/sym_glue.h:59,
                 from drivers/scsi/sym53c8xx_2/sym_fw.c:40:
include/scsi/scsi_transport_spi.h:57: error: field `dv_mutex' has incomplete type

et al.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/sym53c8xx_2/sym_fw.c     |    1 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |    1 +
 drivers/scsi/sym53c8xx_2/sym_malloc.c |    1 +
 drivers/scsi/sym53c8xx_2/sym_nvram.c  |    1 +
 4 files changed, 4 insertions(+)

--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -37,6 +37,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/mutex.h>
 #include "sym_glue.h"
 
 /*
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -39,6 +39,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <asm/param.h>		/* for timeouts in units of HZ */
 #include <scsi/scsi_dbg.h>
 
--- a/drivers/scsi/sym53c8xx_2/sym_malloc.c
+++ b/drivers/scsi/sym53c8xx_2/sym_malloc.c
@@ -37,6 +37,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/mutex.h>
 #include "sym_glue.h"
 
 /*
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.c
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.c
@@ -37,6 +37,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/mutex.h>
 #include "sym_glue.h"
 #include "sym_nvram.h"
 

