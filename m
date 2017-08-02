From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/3] scsi: mptfc: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:59:04 +0530
Message-ID: <1501694945-18061-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501694945-18061-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501694945-18061-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/message/fusion/mptfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d065062..82cb864 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -138,7 +138,7 @@ static struct scsi_host_template mptfc_driver_template = {
  * Supported hardware
  */
 
-static struct pci_device_id mptfc_pci_table[] = {
+static const struct pci_device_id mptfc_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC909,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC919,
-- 
2.7.4
