Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F777CF16;
	Thu, 12 Dec 2024 02:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969248; cv=none; b=JrOEQnBBwOOPxHiT9Tplb/bw2kw5+zxJl/2eEDej576tfLLsN+0E9LGByVzOz6ILqYpgYE1lPZbeQTqXKOsn0JD/sUJCctwUywB4pgOGqBQSqj0eo6xYxj6D+hJL0c9t36V6kWuPvn1GJdmjss0PqYMgRoKH1IoHrq2daXLAt00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969248; c=relaxed/simple;
	bh=42XW+RV/tc1rSfUy1c35v15eguiCwQDZlWf+mhDRfQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzaewXuKoWtumngsmW6Mwg3tP28uuIZf8CptPWGN7Qjwhptf4LP0/Ne40CilN3cYhU1CW5oABmp5AASZ5T6HlQHuAVp38SwT42ToIxzONATubjXgjPa/ucMQD0ch4VypVMYZtFjxV6khoMQEpmY6wo7yLBzDFLixk26ewjV0/II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=HyHrouiV; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="HyHrouiV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=11325; q=dns/txt;
  s=iport; t=1733969246; x=1735178846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W7CxZ1tQ57Ccqwcy9p17qGwDr8ZoU/JPEJHo3UCpY10=;
  b=HyHrouiVbuI4Py6nh8mNm2WsV/2g42rvtHDY/E96E5cygc/xPSvCITg/
   rOzaskn+IN5S5xDRd8OwlUcTn+npz05F8Y4KeU2mHOrI66Lp1jPp1kts/
   4M91qP/j7+XD4ooVLvnR/Q5D0YAsSMOHdPWbC9VD+niTn7JGGGt2Bw2nA
   g=;
X-CSE-ConnectionGUID: Ux7imyUcTmG9hzpxd+nI6g==
X-CSE-MsgGUID: tpu9/D/9Ss25fDwfBoEmag==
X-IPAS-Result: =?us-ascii?q?A0ApAAAVRFpn/5T/Ja1SCBwBAQEBAQEHAQESAQEEBAEBg?=
 =?us-ascii?q?X8HAQELAYJKgU9DGS+McolRnhsUgREDVg8BAQEPRAQBAYUHAoprAiY0CQ4BA?=
 =?us-ascii?q?gQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCAQMnCwFGE?=
 =?us-ascii?q?FFWGYMBgmUDrxaBeTOBAd4zgW2BSAGNSXCEdycVBoFJRIEVgTuCLYFSgjQEE?=
 =?us-ascii?q?oZrBII8hmCdAEiBIQNZIREBVRMNCgsHBYF1AzkMCzEVg2BGPYJJaUk3Ag0CN?=
 =?us-ascii?q?oIkfIJNhRmEaWMvAwMDA4M5hiSCGYFfQAMLGA1IESw3FBsGPm4Hm0tGg2GBD?=
 =?us-ascii?q?gGCPgGTWzOPP4Igi3KVEIQkoUQaM6pRmHukRIRmgWc8gVkzGggbFYMiUhkPj?=
 =?us-ascii?q?i0WxAclMjwCBwsBAQMJj1KBfQEB?=
IronPort-Data: A9a23:iV4RUqLKCDnZScLXFE+RwJQlxSXFcZb7ZxGr2PjKsXjdYENS3jAOm
 2pMW2CBaKreZzTzfY92Odm09UlQ65LXy95lHQUd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCea/kr1WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrX0
 T/Oi5eHYgP8gWctaj98B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1THB43OJwl8dpyLjBO5
 +QIJHMLT06M0rfeLLKTEoGAh+w5J8XteYdasXZ6wHSAVLAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2MESojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZiumwa4OPIYfTLSlTtlqAu
 zOB0yOoOQpAadKz1jSv9V+pj+CayEsXX6pXTtVU7MVCglCRzEQXCRsLRR26q/z/gUm7M/paI
 lYI+yxotaUu+VawQ9/VWAexq3qJ+BUbXrJ4F+w89RHIyafO5QudLnYLQyQHa9E8ssIyAzsw2
 Tehm9LvGCwqq7aOSFqD+bqO6zC/Iy4YKSkFfyBscOcey8PorId2ilfEScxuVffsyNb0Ajr3h
 TuNqUDSmokusCLC7I3jlXivvt5mjsGhotIdjukPYl+Y0w==
IronPort-HdrOrdr: A9a23:EPk/5qBmlx267+flHemD55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuQ8bpE0dND2DrMpbnmFENjo=
X-Talos-CUID: 9a23:iFs1+W9plSiLym0zRMiVv3MERcEgY0DW8HL/ck+qEXZlC7u0F1DFrQ==
X-Talos-MUID: 9a23:5k6YFQitul8CTm7Vxs6qFMMpKN91suOCTxE2is9bteWbOwZ3FjKUg2Hi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,227,1728950400"; 
   d="scan'208";a="295312331"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Dec 2024 02:07:25 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id 611A118000259;
	Thu, 12 Dec 2024 02:07:24 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v7 06/15] scsi: fnic: Add Cisco hardware model names
Date: Wed, 11 Dec 2024 18:03:03 -0800
Message-ID: <20241212020312.4786-7-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241212020312.4786-1-kartilak@cisco.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-11.cisco.com

Add model IDs for Cisco VIC.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Co-developed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
Co-developed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Co-developed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Co-developed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v5 and v6:
    Incorporate review comments from Hannes:
	Split patch into PCI changes and FDMI changes.
---
 drivers/scsi/fnic/Makefile                |   3 +-
 drivers/scsi/fnic/fnic.h                  |  71 ++++++++++++
 drivers/scsi/fnic/fnic_main.c             |  10 ++
 drivers/scsi/fnic/fnic_pci_subsys_devid.c | 131 ++++++++++++++++++++++
 4 files changed, 214 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
index 3bd6b1c8b643..af156c69da0c 100644
--- a/drivers/scsi/fnic/Makefile
+++ b/drivers/scsi/fnic/Makefile
@@ -16,4 +16,5 @@ fnic-y	:= \
 	vnic_intr.o \
 	vnic_rq.o \
 	vnic_wq_copy.o \
-	vnic_wq.o
+	vnic_wq.o \
+	fnic_pci_subsys_devid.o
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 1676bd8324fc..c2978c5c6e8f 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -87,6 +87,72 @@
 /* Retry supported by rport (returned by PRLI service parameters) */
 #define FNIC_FC_RP_FLAGS_RETRY            0x1
 
+/* Cisco vendor id */
+#define PCI_VENDOR_ID_CISCO						0x1137
+#define PCI_DEVICE_ID_CISCO_VIC_FC				0x0045	/* fc vnic */
+
+/* sereno pcie switch */
+#define PCI_DEVICE_ID_CISCO_SERENO             0x004e
+#define PCI_DEVICE_ID_CISCO_CRUZ               0x007a	/* Cruz */
+#define PCI_DEVICE_ID_CISCO_BODEGA             0x0131	/* Bodega */
+#define PCI_DEVICE_ID_CISCO_BEVERLY            0x025f	/* Beverly */
+
+/* Sereno */
+#define PCI_SUBDEVICE_ID_CISCO_VASONA			0x004f	/* vasona mezz */
+#define PCI_SUBDEVICE_ID_CISCO_COTATI			0x0084	/* cotati mlom */
+#define PCI_SUBDEVICE_ID_CISCO_LEXINGTON		0x0085	/* lexington pcie */
+#define PCI_SUBDEVICE_ID_CISCO_ICEHOUSE			0x00cd	/* Icehouse */
+#define PCI_SUBDEVICE_ID_CISCO_KIRKWOODLAKE		0x00ce	/* KirkwoodLake pcie */
+#define PCI_SUBDEVICE_ID_CISCO_SUSANVILLE		0x012e	/* Susanville MLOM */
+#define PCI_SUBDEVICE_ID_CISCO_TORRANCE			0x0139	/* Torrance MLOM */
+
+/* Cruz */
+#define PCI_SUBDEVICE_ID_CISCO_CALISTOGA		0x012c	/* Calistoga MLOM */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTAINVIEW		0x0137	/* Cruz Mezz */
+/* Cruz MountTian SIOC */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN		0x014b
+#define PCI_SUBDEVICE_ID_CISCO_CLEARLAKE		0x014d	/* ClearLake pcie */
+/* Cruz MountTian2 SIOC */
+#define PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN2		0x0157
+#define PCI_SUBDEVICE_ID_CISCO_CLAREMONT		0x015d	/* Claremont MLOM */
+
+/* Bodega */
+/* VIC 1457 PCIe mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BRADBURY         0x0218
+#define PCI_SUBDEVICE_ID_CISCO_BRENTWOOD        0x0217	/* VIC 1455 PCIe */
+/* VIC 1487 PCIe mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BURLINGAME       0x021a
+#define PCI_SUBDEVICE_ID_CISCO_BAYSIDE          0x0219	/* VIC 1485 PCIe */
+/* VIC 1440 Mezz mLOM */
+#define PCI_SUBDEVICE_ID_CISCO_BAKERSFIELD      0x0215
+#define PCI_SUBDEVICE_ID_CISCO_BOONVILLE        0x0216	/* VIC 1480 Mezz */
+#define PCI_SUBDEVICE_ID_CISCO_BENICIA          0x024a	/* VIC 1495 */
+#define PCI_SUBDEVICE_ID_CISCO_BEAUMONT         0x024b	/* VIC 1497 */
+#define PCI_SUBDEVICE_ID_CISCO_BRISBANE         0x02af	/* VIC 1467 */
+#define PCI_SUBDEVICE_ID_CISCO_BENTON           0x02b0	/* VIC 1477 */
+#define PCI_SUBDEVICE_ID_CISCO_TWIN_RIVER       0x02cf	/* VIC 14425 */
+#define PCI_SUBDEVICE_ID_CISCO_TWIN_PEAK        0x02d0	/* VIC 14825 */
+
+/* Beverly */
+#define PCI_SUBDEVICE_ID_CISCO_BERN             0x02de	/* VIC 15420 */
+#define PCI_SUBDEVICE_ID_CISCO_STOCKHOLM        0x02dd	/* VIC 15428 */
+#define PCI_SUBDEVICE_ID_CISCO_KRAKOW           0x02dc	/* VIC 15411 */
+#define PCI_SUBDEVICE_ID_CISCO_LUCERNE          0x02db	/* VIC 15231 */
+#define PCI_SUBDEVICE_ID_CISCO_TURKU            0x02e8	/* VIC 15238 */
+#define PCI_SUBDEVICE_ID_CISCO_TURKU_PLUS       0x02f3	/* VIC 15237 */
+#define PCI_SUBDEVICE_ID_CISCO_ZURICH           0x02df	/* VIC 15230 */
+#define PCI_SUBDEVICE_ID_CISCO_RIGA             0x02e0	/* VIC 15427 */
+#define PCI_SUBDEVICE_ID_CISCO_GENEVA           0x02e1	/* VIC 15422 */
+#define PCI_SUBDEVICE_ID_CISCO_HELSINKI         0x02e4	/* VIC 15235 */
+#define PCI_SUBDEVICE_ID_CISCO_GOTHENBURG       0x02f2	/* VIC 15425 */
+
+struct fnic_pcie_device {
+	u32 device;
+	u8 *desc;
+	u32 subsystem_device;
+	u8 *subsys_desc;
+};
+
 /*
  * fnic private data per SCSI command.
  * These fields are locked by the hashed io_req_lock.
@@ -343,6 +409,9 @@ struct fnic {
 	struct work_struct tport_work;
 	struct list_head tport_event_list;
 
+	char subsys_desc[14];
+	int subsys_desc_len;
+
 	/*** FIP related data members  -- start ***/
 	void (*set_vlan)(struct fnic *, u16 vlan);
 	struct work_struct      fip_frame_work;
@@ -443,6 +512,8 @@ fnic_chk_state_flags_locked(struct fnic *fnic, unsigned long st_flags)
 void __fnic_set_state_flags(struct fnic *, unsigned long, unsigned long);
 void fnic_dump_fchost_stats(struct Scsi_Host *, struct fc_host_statistics *);
 void fnic_free_txq(struct list_head *head);
+int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
+						   char **subsys_desc);
 
 struct fnic_scsi_iter_data {
 	struct fnic *fnic;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index f6940ae350cf..c1c10731906f 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -611,6 +611,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i;
 	unsigned long flags;
 	int hwq;
+	char *desc, *subsys_desc;
 
 	/*
 	 * Allocate SCSI Host and set up association between host,
@@ -644,6 +645,15 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic->fnic_num = fnic_id;
 	fnic_stats_debugfs_init(fnic);
 
+	/* Find model name from PCIe subsys ID */
+	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0)
+		dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
+	else {
+		fnic->subsys_desc_len = 0;
+		dev_info(&fnic->pdev->dev, "Model: %s subsys_id: 0x%04x\n", "Unknown",
+				pdev->subsystem_device);
+	}
+
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Cannot enable PCI device, aborting.\n");
diff --git a/drivers/scsi/fnic/fnic_pci_subsys_devid.c b/drivers/scsi/fnic/fnic_pci_subsys_devid.c
new file mode 100644
index 000000000000..36a2c1268422
--- /dev/null
+++ b/drivers/scsi/fnic/fnic_pci_subsys_devid.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2008 Cisco Systems, Inc.  All rights reserved.
+ * Copyright 2007 Nuova Systems, Inc.  All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/if_ether.h>
+#include "fnic.h"
+
+static struct fnic_pcie_device fnic_pcie_device_table[] = {
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_VASONA,
+	 "VIC 1280"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_COTATI,
+	 "VIC 1240"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_LEXINGTON, "VIC 1225"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_ICEHOUSE,
+	 "VIC 1285"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_KIRKWOODLAKE, "VIC 1225T"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno",
+	 PCI_SUBDEVICE_ID_CISCO_SUSANVILLE, "VIC 1227"},
+	{PCI_DEVICE_ID_CISCO_SERENO, "Sereno", PCI_SUBDEVICE_ID_CISCO_TORRANCE,
+	 "VIC 1227T"},
+
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CALISTOGA,
+	 "VIC 1340"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTAINVIEW,
+	 "VIC 1380"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN,
+	 "C3260-SIOC"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CLEARLAKE,
+	 "VIC 1385"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_MOUNTTIAN2,
+	 "C3260-SIOC"},
+	{PCI_DEVICE_ID_CISCO_CRUZ, "Cruz", PCI_SUBDEVICE_ID_CISCO_CLAREMONT,
+	 "VIC 1387"},
+
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BRADBURY,
+	 "VIC 1457"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BRENTWOOD, "VIC 1455"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BURLINGAME, "VIC 1487"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BAYSIDE,
+	 "VIC 1485"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BAKERSFIELD, "VIC 1440"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_BOONVILLE, "VIC 1480"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BENICIA,
+	 "VIC 1495"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BEAUMONT,
+	 "VIC 1497"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BRISBANE,
+	 "VIC 1467"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega", PCI_SUBDEVICE_ID_CISCO_BENTON,
+	 "VIC 1477"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_TWIN_RIVER, "VIC 14425"},
+	{PCI_DEVICE_ID_CISCO_BODEGA, "Bodega",
+	 PCI_SUBDEVICE_ID_CISCO_TWIN_PEAK, "VIC 14825"},
+
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_BERN,
+	 "VIC 15420"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_STOCKHOLM, "VIC 15428"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_KRAKOW,
+	 "VIC 15411"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_LUCERNE, "VIC 15231"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_TURKU,
+	 "VIC 15238"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_GENEVA,
+	 "VIC 15422"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_HELSINKI, "VIC 15235"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_GOTHENBURG, "VIC 15425"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly",
+	 PCI_SUBDEVICE_ID_CISCO_TURKU_PLUS, "VIC 15237"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_ZURICH,
+	 "VIC 15230"},
+	{PCI_DEVICE_ID_CISCO_BEVERLY, "Beverly", PCI_SUBDEVICE_ID_CISCO_RIGA,
+	 "VIC 15427"},
+
+	{0,}
+};
+
+int fnic_get_desc_by_devid(struct pci_dev *pdev, char **desc,
+						   char **subsys_desc)
+{
+	unsigned short device = PCI_DEVICE_ID_CISCO_VIC_FC;
+	int max = ARRAY_SIZE(fnic_pcie_device_table);
+	struct fnic_pcie_device *t = fnic_pcie_device_table;
+	int index = 0;
+
+	if (pdev->device != device)
+		return 1;
+
+	while (t->device != 0) {
+		if (memcmp
+			((char *) &pdev->subsystem_device,
+			 (char *) &t->subsystem_device, sizeof(short)) == 0)
+			break;
+		t++;
+		index++;
+	}
+
+	if (index >= max - 1) {
+		*desc = NULL;
+		*subsys_desc = NULL;
+		return 1;
+	}
+
+	*desc = fnic_pcie_device_table[index].desc;
+	*subsys_desc = fnic_pcie_device_table[index].subsys_desc;
+	return 0;
+}
-- 
2.47.0

