Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6F01E766E;
	Fri, 19 Sep 2025 12:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285574; cv=fail; b=IKOHuT4xU9PPUcKqs5ezv/d8KZvX9tVkMx3WPXdPS1d52rePun9CjBNQ9BBDzLRjzDTTQkN850hhbEzDA9F88DDDsj8vHKAg8Yqiooz8H7ATg57dVn3czZgkRzKu4bysbZiMQ7v1zS6F4c+H+5sansu2zbgrBTj7hpQzR8f41PM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285574; c=relaxed/simple;
	bh=8JgxkBDrldws79pMdf/ZQjQ6ThQZsi6OoerL4sn4XPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXA4Drl2U2vevnewP52c7MaCnS3I7TGhF8TeEmPpuDzp1U/25brogtxmMx7odS/5xY2Qf0AoFcukPmVho8SEA5PC74VGjGLm3aTW/kuizch4K7eZCKVHdCsYc/t87PMDBEn4uoDw8Va/OjDPr9gXBH2frNkKlFaNe71F4ITXTF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EblOXpDw; arc=fail smtp.client-ip=40.107.209.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EblOXpDw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjRrB7VOYrV9VHBx4QL9ax6LM/2O2z5p+1dbuokFfhKW/iv5H3rdYxvvHb3TMGAQvSXfPHZsKphGpXD95gD/I4CpqwlYQSiSqypniKpoPQuNsFUBDtpIsmDanFHsU5wi3lHM8ZJdjZ2Oe9Ia0Qtu979l8Hi6O3ZJuz4fL/8MBhIB2SFa73Fj5NLF2Lo8QHe19fMlZCTJrLZgxgoll5fFnIQUZo3y4bKCUGAeZVj3NcI7Z5BoigjskT9CEH5tMTxSy6N1yhaloGUEAEeZPAh4XuH4Mo0x8uPKNpj1ASbX+CLagVL8Ys8bLgvBe1vm8imE6hTRL9+piUBEkBpY5UZ6QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gd6cbrjqzvahqnECrZX6nrMrM8XP8mFK/tl2zXJ1JTc=;
 b=MlI9DwlSYafXWp2QW+H1vpnqC5iTBoktbiFR5nszqO9G1fofHw5bhtLQCC7KXrq9cMMOUTKMmIkIDrU8M9Qk5kEu6sVm12SOVqn5lDdlspFdN8UEydR8ZCt7Mws3+R9jlx0no3XtxnPX8HwbJiE4UwI0idmH4kskMAlxvFlQVoJDZFn1Na4+UylnuuTK/rptRINcw0SwTwYSg7u/bpeD9YmuZ4w0axnOyJ6y4Sho8ubgjUr4WIqA+72za43NENu0tz29rLoL2gMcawSvA8xf/xWi383Fwk56wxUVQKgPQV81C+MBUnvfaPDqwd8PQ46f2Y2O6Ou/49uKo1XQgQ4vmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gd6cbrjqzvahqnECrZX6nrMrM8XP8mFK/tl2zXJ1JTc=;
 b=EblOXpDwYMs7Og9uTLpX0Uof40Bd+WNLemkV9q3MNmfhA5PmwplfFaBmn6KlD/p7boV0dt9TP+ncvkxgHPadkBOR7Y7meCZl5eX/KzvWmsY/Cwy5n52LmcEv4/fxzGaWQkOGg+R/3mkF/yboOSy7xVCUUCz00nk+VHdJ5P+IyOo=
Received: from SJ0PR03CA0039.namprd03.prod.outlook.com (2603:10b6:a03:33e::14)
 by IA4PR12MB9811.namprd12.prod.outlook.com (2603:10b6:208:54e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 12:39:26 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33e:cafe::30) by SJ0PR03CA0039.outlook.office365.com
 (2603:10b6:a03:33e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.17 via Frontend Transport; Fri,
 19 Sep 2025 12:39:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 12:39:25 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:39:14 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:39:12 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 19 Sep 2025 05:39:07 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 5/5] ufs: amd-versal2: Add AMD Versal Gen 2 UFS support
Date: Fri, 19 Sep 2025 18:08:35 +0530
Message-ID: <20250919123835.17899-6-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250919123835.17899-1-ajay.neeli@amd.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|IA4PR12MB9811:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d19e7da-a611-4eeb-f059-08ddf7799140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vrTzH9x7fKDA5GMyX8h+Px2mFrHS551WJCq+sFv8Hfk21O+AYT5GhOYTGFTR?=
 =?us-ascii?Q?ORRv+oyUn93dFzDPlu+lCdoJmqWC0/FpYVtxbnbjpBCBj7o0D+EWQMzMl4jP?=
 =?us-ascii?Q?VB4YDiYyC2+wdNi/ONx+HrDioMptsRLtNP9zuqRqazvECh9slF0gOsJU+34b?=
 =?us-ascii?Q?6j4iMxatp4sFgMstcZrEUdnU0m3xD1vu3rANvu7WEtplW1TctbpGydkR/OkB?=
 =?us-ascii?Q?Lqmb2oKwyCSzk8DXk/UfLoRYM8pOK3HfjkFi5uXTa93AWwrmAP8bFGNthx3V?=
 =?us-ascii?Q?mgm/uEPLjnoZuPP4iDGrEwAfQHBrjlI1H45F1zMYxQc9dPacEMhBsY8PJcCZ?=
 =?us-ascii?Q?kyzh341M37EaO/vUvXKWSkyxZV682hRXcJqm1uSjajpf0ZVdXeXQ4UYJ9Cn9?=
 =?us-ascii?Q?KGBLlNwec1BQFVz1fOEG0DdJ4lsYBR03kjHxwCES7aEawe2ysZ1T2hzX2bjG?=
 =?us-ascii?Q?YP2lfnfbIWiaH9HCBz/ml+/bzjiS649lk6lp+AenWd2onv3Nac/madjlOYej?=
 =?us-ascii?Q?VhsjfojUPX6ZJGlsKDHHEn6WI4BbqJhtFFgsde0s9b/TB7hAG0yo92JZjBm4?=
 =?us-ascii?Q?2DkQ9ndN3HofXIHScv8ekV1XqqgsitaUIAu5+tVDeYFlWh3QKpxUlBgNCia1?=
 =?us-ascii?Q?hTCnozs5CT/6W4tCOybFgXeyMWg9fnZ5YMCa8/5O71zG59iYd5P1arWftQ2N?=
 =?us-ascii?Q?atmWZm5ehCS/R6qS7ua0IINaEVLOaOXbaRsfz628ByJBvA13uYJx3RiJojDC?=
 =?us-ascii?Q?qWi9pAQJHmQZEPKBRAhlLXPYm3wD1awJt0GMucbFR95RN1pbfe8UIx87+Cqf?=
 =?us-ascii?Q?X95D37O2XIXi7DAq/k7HTmnIflTjLluC2gwgv4lXSy1BYjtNnwNX2IqTnSS4?=
 =?us-ascii?Q?6j7EvzJUReZf2HwGPGE64NB2z62G4WoDkm220B6HfSonvmj5GFacNocIjp9r?=
 =?us-ascii?Q?RsD51dIdnZuHkJlaMoPE+UZoYvzWsLN6jfvmb9HZhAuJ5O7WjqNHs01fhTsj?=
 =?us-ascii?Q?iUWmfYiNKDocWqwZWVKOA1UdnjJGp/YRfcot/JAdJse3Au5t+a5pnu+D0T+9?=
 =?us-ascii?Q?xrfxWgcKSgGGC6yrAsEmhFXan6umdTLRXAytOOa9XytZQw8KYagDF70Q1S8R?=
 =?us-ascii?Q?7iscLdS0Qb641KyVkR516X+tF41vGRWzIVXhB1yIjPCkPhDD+rn1ujzAJBCk?=
 =?us-ascii?Q?o3Kio7iqnHHHHUyDjPR7m4KdgVa1/9UD8/8qI+UsO0dQTSG26vdkcKTUgJ62?=
 =?us-ascii?Q?YO9E1WG+/9B68fMloPvGODGfnpU13UwGUCYvqRKfpiDp7Lf3yZ2t8vmie2dd?=
 =?us-ascii?Q?8nfa02zxROpB/R/pgwqO9/FQ3TT1TRV20mXqmtPqhoIdWDCo/MKB6NsEf41b?=
 =?us-ascii?Q?1pWiwo6bkFO0XdX8wtcXPOaqE60zuZwYm5wrDSCtK33C2/r0FaQgYWVBmqZw?=
 =?us-ascii?Q?6eToWS95maN9lhrpPsPB5FyLCmyYqX/mqmX0V1+eJQX9FwM6Gaw5yM7lBM03?=
 =?us-ascii?Q?5mlGY5wXGOYoqJTpBOwlo6OfUcNRNnxIqPEi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:39:25.5200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d19e7da-a611-4eeb-f059-08ddf7799140
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9811

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

Add UFS AMD Versal Gen 2 platform support on top of the UFSHCD DWC and
UFSHCD platform driver. UFS AMD Versal Gen 2 platform requires specific
configurations like M-PHY/RMMI/UniPro and vendor specific registers
programming before doing the UIC_LINKSTARTUP.

Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 MAINTAINERS                        |   7 +
 drivers/ufs/host/Kconfig           |  13 +
 drivers/ufs/host/Makefile          |   1 +
 drivers/ufs/host/ufs-amd-versal2.c | 589 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  49 +++
 drivers/ufs/host/ufshci-dwc.h      |   5 +
 include/ufs/unipro.h               |   1 +
 7 files changed, 665 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-amd-versal2.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 05325fa..63bb457 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25453,6 +25453,13 @@ F:	Documentation/devicetree/bindings/ufs/
 F:	Documentation/scsi/ufs.rst
 F:	drivers/ufs/core/
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER AMD VERSAL2
+M:	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
+M:	Ajay Neeli <ajay.neeli@amd.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
+F:	drivers/ufs/host/ufs-amd-versal2.c
+
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
 M:	Pedro Sousa <pedrom.sousa@synopsys.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 191fbd7..7d5117b 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -154,3 +154,16 @@ config SCSI_UFS_ROCKCHIP
 
 	  Select this if you have UFS controller on Rockchip chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_AMD_VERSAL2
+	tristate "AMD Versal Gen 2 UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_ZYNQMP || COMPILE_TEST)
+	help
+	  This selects the AMD Versal Gen 2 specific additions on top of
+	  the UFSHCD DWC and UFSHCD platform driver. UFS host on AMD
+	  Versal Gen 2 needs some vendor specific configurations like PHY
+	  and vendor specific register accesses before accessing the
+	  hardware.
+
+	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
+	  If unsure, say N.
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 2f97feb..65d8bb2 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
 obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
 obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
 obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
+obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
new file mode 100644
index 0000000..fdae3ed
--- /dev/null
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -0,0 +1,589 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Advanced Micro Devices, Inc.
+ *
+ * Authors: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/irqreturn.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <ufs/unipro.h>
+
+#include "ufshcd-dwc.h"
+#include "ufshcd-pltfrm.h"
+#include "ufshci-dwc.h"
+
+#define MPHY_FAST_RX_AFE_CAL		BIT(2)
+#define MPHY_FW_CALIB_CFG_VAL		BIT(8)
+
+#define MPHY_RX_OVRD_EN			BIT(3)
+#define MPHY_RX_OVRD_VAL		BIT(2)
+#define MPHY_RX_ACK_MASK		BIT(0)
+
+#define TIMEOUT_MICROSEC	1000000
+
+struct ufs_versal2_host {
+	struct ufs_hba *hba;
+	struct reset_control *rstc;
+	struct reset_control *rstphy;
+	u32 phy_mode;
+	unsigned long host_clk;
+	u8 attcompval0;
+	u8 attcompval1;
+	u8 ctlecompval0;
+	u8 ctlecompval1;
+};
+
+static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
+{
+	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	phy_write_attrs[0].mib_val = (u8)addr;
+	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
+	phy_write_attrs[2].mib_val = (u8)val;
+	phy_write_attrs[3].mib_val = (u8)(val >> 8);
+
+	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
+}
+
+static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
+{
+	u32 mib_val;
+	int ret;
+	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
+		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	phy_read_attrs[0].mib_val = (u8)addr;
+	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val = mib_val;
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
+	if (ret)
+		return ret;
+
+	*val |= (mib_val << 8);
+
+	return 0;
+}
+
+static int ufs_versal2_enable_phy(struct ufs_hba *hba)
+{
+	u32 offset, reg;
+	int ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYDISABLE), 0);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 1);
+	if (ret)
+		return ret;
+
+	/* Check Tx/Rx FSM states */
+	for (offset = 0; offset < 2; offset++) {
+		u32 time_left, mibsel;
+
+		time_left = TIMEOUT_MICROSEC;
+		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		do {
+			ret = ufshcd_dme_get(hba, mibsel, &reg);
+			if (ret)
+				return ret;
+
+			if (reg == TX_STATE_HIBERN8 || reg == TX_STATE_SLEEP ||
+			    reg == TX_STATE_LSBURST)
+				break;
+
+			time_left--;
+			usleep_range(1, 5);
+		} while (time_left);
+
+		if (!time_left) {
+			dev_err(hba->dev, "Invalid Tx FSM state.\n");
+			return -ETIMEDOUT;
+		}
+
+		time_left = TIMEOUT_MICROSEC;
+		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		do {
+			ret = ufshcd_dme_get(hba, mibsel, &reg);
+			if (ret)
+				return ret;
+
+			if (reg == RX_STATE_HIBERN8 || reg == RX_STATE_SLEEP ||
+			    reg == RX_STATE_LSBURST)
+				break;
+
+			time_left--;
+			usleep_range(1, 5);
+		} while (time_left);
+
+		if (!time_left) {
+			dev_err(hba->dev, "Invalid Rx FSM state.\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+static int ufs_versal2_setup_phy(struct ufs_hba *hba)
+{
+	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
+	int ret;
+	u32 reg;
+
+	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
+	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
+	if (ret)
+		return ret;
+
+	reg |= MPHY_FAST_RX_AFE_CAL;
+	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
+	if (ret)
+		return ret;
+
+	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
+	if (ret)
+		return ret;
+
+	reg |= MPHY_FAST_RX_AFE_CAL;
+	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
+	if (ret)
+		return ret;
+
+	/* Program ATT and CTLE compensation values */
+	if (host->attcompval0) {
+		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
+		if (ret)
+			return ret;
+	}
+
+	if (host->attcompval1) {
+		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
+		if (ret)
+			return ret;
+	}
+
+	if (host->ctlecompval0) {
+		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
+		if (ret)
+			return ret;
+	}
+
+	if (host->ctlecompval1) {
+		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
+		if (ret)
+			return ret;
+	}
+
+	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
+	if (ret)
+		return ret;
+
+	reg |= MPHY_FW_CALIB_CFG_VAL;
+	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
+	if (ret)
+		return ret;
+
+	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
+	if (ret)
+		return ret;
+
+	reg |= MPHY_FW_CALIB_CFG_VAL;
+	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
+}
+
+static int ufs_versal2_phy_init(struct ufs_hba *hba)
+{
+	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
+	u32 time_left;
+	bool is_ready;
+	int ret;
+	static const struct ufshcd_dme_attr_val rmmi_attrs[] = {
+		{ UIC_ARG_MIB(CBREFCLKCTRL2), CBREFREFCLK_GATE_OVR_EN, DME_LOCAL },
+		{ UIC_ARG_MIB(CBCRCTRL), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(CBC10DIRECTCONF2), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
+	};
+
+	/* Wait for Tx/Rx config_rdy */
+	time_left = TIMEOUT_MICROSEC;
+	do {
+		time_left--;
+		ret = zynqmp_pm_is_mphy_tx_rx_config_ready(&is_ready);
+		if (ret)
+			return ret;
+
+		if (!is_ready)
+			break;
+
+		usleep_range(1, 5);
+	} while (time_left);
+
+	if (!time_left) {
+		dev_err(hba->dev, "Tx/Rx configuration signal busy.\n");
+		return -ETIMEDOUT;
+	}
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, rmmi_attrs, ARRAY_SIZE(rmmi_attrs));
+	if (ret)
+		return ret;
+
+	ret = reset_control_deassert(host->rstphy);
+	if (ret) {
+		dev_err(hba->dev, "ufsphy reset deassert failed, err = %d\n", ret);
+		return ret;
+	}
+
+	/* Wait for SRAM init done */
+	time_left = TIMEOUT_MICROSEC;
+	do {
+		time_left--;
+		ret = zynqmp_pm_is_sram_init_done(&is_ready);
+		if (ret)
+			return ret;
+
+		if (is_ready)
+			break;
+
+		usleep_range(1, 5);
+	} while (time_left);
+
+	if (!time_left) {
+		dev_err(hba->dev, "SRAM initialization failed.\n");
+		return -ETIMEDOUT;
+	}
+
+	ret = ufs_versal2_setup_phy(hba);
+	if (ret)
+		return ret;
+
+	return ufs_versal2_enable_phy(hba);
+}
+
+static int ufs_versal2_init(struct ufs_hba *hba)
+{
+	struct ufs_versal2_host *host;
+	struct device *dev = hba->dev;
+	struct ufs_clk_info *clki;
+	int ret;
+	u32 cal;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->hba = hba;
+	ufshcd_set_variant(hba, host);
+
+	host->phy_mode = UFSHCD_DWC_PHY_MODE_ROM;
+
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!strcmp(clki->name, "core"))
+			host->host_clk = clk_get_rate(clki->clk);
+	}
+
+	host->rstc = devm_reset_control_get_exclusive(dev, "ufshc");
+	if (IS_ERR(host->rstc)) {
+		dev_err(dev, "failed to get reset ctrl: ufshc\n");
+		return PTR_ERR(host->rstc);
+	}
+
+	host->rstphy = devm_reset_control_get_exclusive(dev, "ufsphy");
+	if (IS_ERR(host->rstphy)) {
+		dev_err(dev, "failed to get reset ctrl: ufsphy\n");
+		return PTR_ERR(host->rstphy);
+	}
+
+	ret = zynqmp_pm_get_ufs_calibration_values(&cal);
+	if (ret) {
+		dev_err(dev, "failed to read calibration values\n");
+		return ret;
+	}
+
+	host->attcompval0 = (u8)cal;
+	host->attcompval1 = (u8)(cal >> 8);
+	host->ctlecompval0 = (u8)(cal >> 16);
+	host->ctlecompval1 = (u8)(cal >> 24);
+
+	hba->quirks |= UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING;
+
+	return 0;
+}
+
+static int ufs_versal2_hce_enable_notify(struct ufs_hba *hba,
+					 enum ufs_notify_change_status status)
+{
+	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+	int ret;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (host->phy_mode) {
+			dev_err(dev, "Invalid phy-mode %d.\n", host->phy_mode);
+			return -EINVAL;
+		}
+
+		ret = reset_control_assert(host->rstc);
+		if (ret) {
+			dev_err(hba->dev, "ufshc reset assert failed, err = %d\n", ret);
+			return ret;
+		}
+
+		ret = reset_control_assert(host->rstphy);
+		if (ret) {
+			dev_err(hba->dev, "ufsphy reset assert failed, err = %d\n", ret);
+			return ret;
+		}
+
+		ret = zynqmp_pm_set_sram_bypass();
+		if (ret) {
+			dev_err(dev, "Bypass SRAM interface failed, err = %d\n", ret);
+			return ret;
+		}
+
+		ret = reset_control_deassert(host->rstc);
+		if (ret)
+			dev_err(hba->dev, "ufshc reset deassert failed, err = %d\n", ret);
+
+		break;
+	case POST_CHANGE:
+		ret = ufs_versal2_phy_init(hba);
+		if (ret)
+			dev_err(hba->dev, "Phy init failed (%d)\n", ret);
+
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static irqreturn_t ufs_versal2_isr(struct ufs_hba *hba, u32 intr_status)
+{
+	u32 mask;
+
+	mask = DWC_UFS_CARD_INSERT_STATUS | DWC_UFS_CARD_REMOVE_STATUS |
+		DWC_UFS_CARD_TOGGLE_STATUS;
+	if (intr_status & mask)
+		return IRQ_HANDLED;
+
+	return IRQ_NONE;
+}
+
+static int ufs_versal2_link_startup_notify(struct ufs_hba *hba,
+					   enum ufs_notify_change_status status)
+{
+	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
+	int ret = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (host->host_clk)
+			ufshcd_writel(hba, host->host_clk / 1000000, DWC_UFS_REG_HCLKDIV);
+
+		break;
+	case POST_CHANGE:
+		ret = ufshcd_dwc_link_startup_notify(hba, status);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_req)
+{
+	u32 time_left, reg, lane;
+	int ret;
+
+	for (lane = 0; lane < activelanes; lane++) {
+		time_left = TIMEOUT_MICROSEC;
+		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+		if (ret)
+			return ret;
+
+		reg |= MPHY_RX_OVRD_EN;
+		if (rx_req)
+			reg |= MPHY_RX_OVRD_VAL;
+		else
+			reg &= ~MPHY_RX_OVRD_VAL;
+
+		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+		if (ret)
+			return ret;
+
+		do {
+			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
+			if (ret)
+				return ret;
+
+			reg &= MPHY_RX_ACK_MASK;
+			if (reg == rx_req)
+				break;
+
+			time_left--;
+			usleep_range(1, 5);
+		} while (time_left);
+
+		if (!time_left) {
+			dev_err(hba->dev, "Invalid Rx Ack value.\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
+static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_change_status status,
+					 const struct ufs_pa_layer_attr *dev_max_params,
+					 struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct ufs_versal2_host *host = ufshcd_get_variant(hba);
+	u32 lane, reg, rate = 0;
+	int ret = 0;
+
+	if (status == PRE_CHANGE) {
+		memcpy(dev_req_params, dev_max_params, sizeof(struct ufs_pa_layer_attr));
+
+		/* If it is not a calibrated part, switch PWRMODE to SLOW_MODE */
+		if (!host->attcompval0 && !host->attcompval1 && !host->ctlecompval0 &&
+		    !host->ctlecompval1) {
+			dev_req_params->pwr_rx = SLOW_MODE;
+			dev_req_params->pwr_tx = SLOW_MODE;
+			return 0;
+		}
+
+		if (dev_req_params->pwr_rx == SLOW_MODE || dev_req_params->pwr_rx == SLOWAUTO_MODE)
+			return 0;
+
+		if (dev_req_params->hs_rate == PA_HS_MODE_B)
+			rate = 1;
+
+		 /* Select the rate */
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB(CBRATESEL), rate);
+		if (ret)
+			return ret;
+
+		ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 1);
+		if (ret)
+			return ret;
+
+		ret = ufs_versal2_phy_ratesel(hba, dev_req_params->lane_tx, 1);
+		if (ret)
+			return ret;
+
+		ret = ufs_versal2_phy_ratesel(hba, dev_req_params->lane_tx, 0);
+		if (ret)
+			return ret;
+
+		/* Remove rx_req override */
+		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
+			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
+			if (ret)
+				return ret;
+
+			reg &= ~MPHY_RX_OVRD_EN;
+			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
+			if (ret)
+				return ret;
+		}
+
+		if (dev_req_params->lane_tx == UFS_LANE_2 && dev_req_params->lane_rx == UFS_LANE_2)
+			ret = ufshcd_dme_configure_adapt(hba, dev_req_params->gear_tx,
+							 PA_INITIAL_ADAPT);
+	}
+
+	return ret;
+}
+
+static struct ufs_hba_variant_ops ufs_versal2_hba_vops = {
+	.name			= "ufs-versal2-pltfm",
+	.init			= ufs_versal2_init,
+	.link_startup_notify	= ufs_versal2_link_startup_notify,
+	.hce_enable_notify	= ufs_versal2_hce_enable_notify,
+	.isr			= ufs_versal2_isr,
+	.pwr_change_notify	= ufs_versal2_pwr_change_notify,
+};
+
+static const struct of_device_id ufs_versal2_pltfm_match[] = {
+	{
+		.compatible = "amd,versal2-ufs",
+		.data = &ufs_versal2_hba_vops,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ufs_versal2_pltfm_match);
+
+static int ufs_versal2_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	/* Perform generic probe */
+	ret = ufshcd_pltfrm_init(pdev, &ufs_versal2_hba_vops);
+	if (ret)
+		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", ret);
+
+	return ret;
+}
+
+static void ufs_versal2_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba = platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+}
+
+static const struct dev_pm_ops ufs_versal2_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+};
+
+static struct platform_driver ufs_versal2_pltfm = {
+	.probe		= ufs_versal2_probe,
+	.remove		= ufs_versal2_remove,
+	.driver		= {
+		.name	= "ufshcd-versal2",
+		.pm	= &ufs_versal2_pm_ops,
+		.of_match_table	= of_match_ptr(ufs_versal2_pltfm_match),
+	},
+};
+
+module_platform_driver(ufs_versal2_pltfm);
+
+MODULE_AUTHOR("Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>");
+MODULE_DESCRIPTION("AMD Versal Gen 2 UFS Host Controller driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index ad91ea5..379f3cf 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -12,6 +12,55 @@
 
 #include <ufs/ufshcd.h>
 
+/* PHY modes */
+#define UFSHCD_DWC_PHY_MODE_ROM         0
+
+/* RMMI Attributes */
+#define CBREFCLKCTRL2		0x8132
+#define CBCRCTRL		0x811F
+#define CBC10DIRECTCONF2	0x810E
+#define CBRATESEL		0x8114
+#define CBCREGADDRLSB		0x8116
+#define CBCREGADDRMSB		0x8117
+#define CBCREGWRLSB		0x8118
+#define CBCREGWRMSB		0x8119
+#define CBCREGRDLSB		0x811A
+#define CBCREGRDMSB		0x811B
+#define CBCREGRDWRSEL		0x811C
+
+#define CBREFREFCLK_GATE_OVR_EN		BIT(7)
+
+/* M-PHY Attributes */
+#define MTX_FSM_STATE		0x41
+#define MRX_FSM_STATE		0xC1
+
+/* M-PHY registers */
+#define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
+#define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
+#define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
+#define RX_AFE_ATT_IDAC(n)	(0x4000 + ((n) * 0x100))
+#define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
+#define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
+
+/* Tx/Rx FSM state */
+enum rx_fsm_state {
+	RX_STATE_DISABLED = 0,
+	RX_STATE_HIBERN8 = 1,
+	RX_STATE_SLEEP = 2,
+	RX_STATE_STALL = 3,
+	RX_STATE_LSBURST = 4,
+	RX_STATE_HSBURST = 5,
+};
+
+enum tx_fsm_state {
+	TX_STATE_DISABLED = 0,
+	TX_STATE_HIBERN8 = 1,
+	TX_STATE_SLEEP = 2,
+	TX_STATE_STALL = 3,
+	TX_STATE_LSBURST = 4,
+	TX_STATE_HSBURST = 5,
+};
+
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
 	u32 mib_val;
diff --git a/drivers/ufs/host/ufshci-dwc.h b/drivers/ufs/host/ufshci-dwc.h
index 6c290e2..96b1a61 100644
--- a/drivers/ufs/host/ufshci-dwc.h
+++ b/drivers/ufs/host/ufshci-dwc.h
@@ -15,6 +15,11 @@ enum dwc_specific_registers {
 	DWC_UFS_REG_HCLKDIV	= 0xFC,
 };
 
+/* DWC HC specific interrupt mask */
+#define DWC_UFS_CARD_INSERT_STATUS	BIT(29)
+#define DWC_UFS_CARD_REMOVE_STATUS	BIT(30)
+#define DWC_UFS_CARD_TOGGLE_STATUS	BIT(31)
+
 /* Clock Divider Values: Hex equivalent of frequency in MHz */
 enum clk_div_values {
 	DWC_UFS_REG_HCLKDIV_DIV_62_5	= 0x3e,
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 360e124..faf1c47 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -174,6 +174,7 @@
 #define VS_POWERSTATE		0xD083
 #define VS_MPHYCFGUPDT		0xD085
 #define VS_DEBUGOMC		0xD09E
+#define VS_MPHYDISABLE		0xD0C1
 
 #define PA_GRANULARITY_MIN_VAL	1
 #define PA_GRANULARITY_MAX_VAL	6
-- 
1.8.3.1

