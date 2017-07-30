From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 17/29] scsi: qla2xxx: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:10:33 +0530
Message-ID: <1501404036-9005-7-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df57655..2ee8e86 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6494,7 +6494,7 @@ static const struct pci_error_handlers qla2xxx_err_handler = {
 	.resume = qla2xxx_pci_resume,
 };
 
-static struct pci_device_id qla2xxx_pci_tbl[] = {
+static const struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2100) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2200) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2300) },
-- 
2.7.4
