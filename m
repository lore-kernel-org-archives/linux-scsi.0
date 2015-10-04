From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] isci: fix two comment typos
Date: Sun,  4 Oct 2015 16:53:55 +0800
Message-ID: <dc5377b7094d5d50cfe037337b301a083869d0c0.1443948690.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Just fix two typos in the code comment.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/scsi/isci/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index cfd0084..8fe106f 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3306,7 +3306,7 @@ sci_io_request_construct_smp(struct device *dev,
  * @ireq: This parameter points to the isci_request allocated in the
  *    request construct function.
  *
- * SCI_SUCCESS on successfull completion, or specific failure code.
+ * SCI_SUCCESS on successful completion, or specific failure code.
  */
 static enum sci_status isci_smp_request_build(struct isci_request *ireq)
 {
@@ -3332,7 +3332,7 @@ static enum sci_status isci_smp_request_build(struct isci_request *ireq)
  * @sci_device: This parameter is the handle for the sci core's remote device
  *    object that is the destination for this request.
  *
- * SCI_SUCCESS on successfull completion, or specific failure code.
+ * SCI_SUCCESS on successful completion, or specific failure code.
  */
 static enum sci_status isci_io_request_build(struct isci_host *ihost,
 					     struct isci_request *request,
-- 
2.5.0
