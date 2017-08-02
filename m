From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 1/3] scsi: mptfusion: constify pci_device_id.
Date: Wed,  2 Aug 2017 22:59:03 +0530
Message-ID: <1501694945-18061-2-git-send-email-arvind.yadav.cs@gmail.com>
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
 drivers/message/fusion/mptspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 9a336a1..f9823bb 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1243,7 +1243,7 @@ static struct spi_function_template mptspi_transport_functions = {
  * Supported hardware
  */
 
-static struct pci_device_id mptspi_pci_table[] = {
+static const struct pci_device_id mptspi_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_ATTO, MPI_MANUFACTPAGE_DEVID_53C1030,
-- 
2.7.4
