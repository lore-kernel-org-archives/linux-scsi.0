From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH] mptsas: Add device ID for SAS1068_820XELP.
Date: Fri, 18 Nov 2011 14:13:42 -0800
Message-ID: <1321654422-27617-1-git-send-email-ddaney.cavm__5187.10964029214$1321654451$gmane$org@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43259 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1KRWNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2011 17:13:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, DL-MPTFusionLinux@lsi.com, support@lsi
Cc: Chandrakala Chavva <cchavva@caviumnetworks.com>, David Daney <david.daney@cavium.com>

From: Chandrakala Chavva <cchavva@caviumnetworks.com>

We need this new devid to be able to use this board.

Signed-off-by: Chandrakala Chavva <cchavva@caviumnetworks.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/message/fusion/lsi/mpi_cnfg.h |    1 +
 drivers/message/fusion/mptsas.c       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 22027e7..d9bcfba 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -583,6 +583,7 @@ typedef struct _MSG_CONFIG_REPLY
 #define MPI_MANUFACTPAGE_DEVID_SAS1066E             (0x005A)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068              (0x0054)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068E             (0x0058)
+#define MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP      (0x0059)
 #define MPI_MANUFACTPAGE_DEVID_SAS1078              (0x0062)
 
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 9d95042..551262e 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5376,6 +5376,8 @@ static struct pci_device_id mptsas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1078,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptsas_pci_table);
-- 
1.7.2.3

