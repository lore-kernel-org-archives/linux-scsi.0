From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 05/29] scsi: qla4xxx: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:07:14 +0530
Message-ID: <1501403839-8876-6-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa5..41e1027 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9793,7 +9793,7 @@ static const struct pci_error_handlers qla4xxx_err_handler = {
 	.resume = qla4xxx_pci_resume,
 };
 
-static struct pci_device_id qla4xxx_pci_tbl[] = {
+static const struct pci_device_id qla4xxx_pci_tbl[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_QLOGIC,
 		.device		= PCI_DEVICE_ID_QLOGIC_ISP4010,
-- 
2.7.4
