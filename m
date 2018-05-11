From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 5/7] cxlflash: Add include guards to backend.h
Date: Fri, 11 May 2018 14:05:51 -0500
Message-ID: <1526065551-39005-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The new header file, backend.h, that was recently added is missing
the include guards. This commit adds the guards.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/backend.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/cxlflash/backend.h b/drivers/scsi/cxlflash/backend.h
index bcd8a6c..55638d1 100644
--- a/drivers/scsi/cxlflash/backend.h
+++ b/drivers/scsi/cxlflash/backend.h
@@ -12,6 +12,9 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#ifndef _CXLFLASH_BACKEND_H
+#define _CXLFLASH_BACKEND_H
+
 extern const struct cxlflash_backend_ops cxlflash_cxl_ops;
 extern const struct cxlflash_backend_ops cxlflash_ocxl_ops;
 
@@ -45,3 +48,5 @@ struct cxlflash_backend_ops {
 	int (*fd_mmap)(struct file *file, struct vm_area_struct *vm);
 	int (*fd_release)(struct inode *inode, struct file *file);
 };
+
+#endif /* _CXLFLASH_BACKEND_H */
-- 
2.1.0
