From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] mptsas: Add device ID for SAS1068_820XELP.
Date: Mon, 28 Nov 2011 14:29:49 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A604726F2879@inbmail02.lsi.com>
References: <1321654422-27617-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321654422-27617-1-git-send-email-ddaney.cavm@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <jejb@kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, Support <support@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Chandrakala Chavva <cchavva@caviumnetworks.com>, David Daney <david.daney@cavium.com>
List-Id: linux-scsi@vger.kernel.org

Please consider this patch as an Acked by me.

Regards,
Nagalakshmi


-----Original Message-----
From: David Daney [mailto:ddaney.cavm@gmail.com] 
Sent: Saturday, November 19, 2011 3:44 AM
To: linux-kernel@vger.kernel.org; Moore, Eric; James Bottomley; Desai, Kashyap; DL-MPT Fusion Linux; Support; linux-scsi@vger.kernel.org
Cc: Chandrakala Chavva; David Daney
Subject: [PATCH] mptsas: Add device ID for SAS1068_820XELP.

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
