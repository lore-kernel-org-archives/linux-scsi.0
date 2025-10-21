Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01C32E754;
	Tue, 21 Oct 2025 11:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046262; cv=fail; b=btw8jSr8Zin4fdXFX/G+9sE871AcPDPu+f6ezWr01XadSblJZYG34tePNeQDi7iFjMo8WsJ8Q0wyvvifA5ZdQ6ln+p2AZ4eEEKSXdI90KtkPNIUREloziuMkDS7U3KfmkX7IjgHeQiY8HuKK/ffQBmVUiI1xTHTjEMM1cCNKBoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046262; c=relaxed/simple;
	bh=LZYfXWbGHrO41o1AnjTGeTQS/HVx9Rgfh54Lp2lh8Ng=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gqThVv3xQfDfarwGDXzd1bqKo9Fe8OeSVZMQgyfzbtON75I9VHz+4l0TpmjKnSXzkJn/HggtH0TE/gZpg/dqgSAV9UgGFBLUX39XfjJIsUrEvwHWySl27RpSf9eo0ug+HjGQWrB5wbD6h9LA+NAJ/JiERMML4pSG4iqSJP4G630=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rY1YnID5; arc=fail smtp.client-ip=40.107.208.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rY1YnID5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7jbpHJh9TNbVFDAQyc4dKFmg9/LW9Et05k2perK17lkGNTV3QktAsDsIrXSFTO0v3yyFV2UMuvop74Ql6D1vFi9/7QlrC5rNW7nG59iwdUSQIWRCe6WWdRQAGjrpP30hroXEVWOKEVGh2pFz0rM1efusTUDuxY4GGvX/xuaCa+g4CERZEoEiYjEMNYzHTSMuMg2OB6Y20LpDqLUbQ/0UMPfj1gwg298sKCQCKuTM2d8afx/Iz5CeuxnopofjNGAQeQp39zDO69/QGZzkhKJR80+6UjEdzzJQVnc0wdLWooSO88ZUMWUP7NBK+ZLSLFD9d1fo5yLoFzAO2oeW03mmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OhX5aPIr5YYQuFBiaF1/LYQuQRBUA4NrofgMdC+jek=;
 b=TnWlx+PTKSly1qQGV9NilFW7gPtW6jSS4MlqbaNA9nmV0g+dFkhju+glD8y3wLqXfGDxieKMUo/d7o+/ZlBdpdOzb2EdIJrvR8xrbBa4rKOwGjV+cvHWIL5CaqVOOqtUCMpsbAIGOxoPHqV4eY5QD2PICe56ohsjmYQfDQTFjoSi3WosEkH4k6oOSI7lV0PR94jj1NcIrZkYxFT49UMmXrkNqQYH+r0px3eWkkfcx9EPlncUoPzqye3sKboUUrtdO1WKa0gupbvGxKlSqnYRo881KJwPpiFApgUnQaO0Z5OEy+PD8QBaJFFFqwGZDTArqrxdPGadme1NIlcnZAq3LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OhX5aPIr5YYQuFBiaF1/LYQuQRBUA4NrofgMdC+jek=;
 b=rY1YnID5Kbck7xp7auMCGCvJSepCbJgwUpm2VeNMK2yEp39vhRVk29jQ41L6WR85IJGx9cMqrcdmg/QjILZswUoxDZ65mqg2NJF5p2xjjNmkifd/9cp/PkCpBOyf6lLeK0Uzz3A9lFt78nvKSkYexQcdXepc/fE4pewhuIBIjYM=
Received: from BY5PR16CA0012.namprd16.prod.outlook.com (2603:10b6:a03:1a0::25)
 by MW4PR12MB5665.namprd12.prod.outlook.com (2603:10b6:303:187::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 11:30:51 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::c1) by BY5PR16CA0012.outlook.office365.com
 (2603:10b6:a03:1a0::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.17 via Frontend Transport; Tue,
 21 Oct 2025 11:30:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 11:30:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:30 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Oct
 2025 06:30:29 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Oct 2025 04:30:24 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v2 4/4] ufs: amd-versal2: Add UFS support for AMD Versal Gen 2 SoC
Date: Tue, 21 Oct 2025 17:00:03 +0530
Message-ID: <20251021113003.13650-5-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251021113003.13650-1-ajay.neeli@amd.com>
References: <20251021113003.13650-1-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: ajay.neeli@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|MW4PR12MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 37412262-3e97-4eeb-04eb-08de109549ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8VliCsvyAYZG+4fSYmD9ryycZ/81CSb0wmPdVdC+aXZlgkjh43/JkXlZAGo3?=
 =?us-ascii?Q?sEanyFHBccuBbv6yRgeRKxdocGeb9RU+itIZVriDK+qRvEVyv++FToYDVL5T?=
 =?us-ascii?Q?WTBJ+kioOMBT1f94ekGJ/IEMJpxpERONBvwM3mmHg6Pv7otJHb+m0+3RJGlG?=
 =?us-ascii?Q?s5x1qA3ndmhuHSv7Wkx4FmjdPDWCr2vMkgR8t95heD9OUStsC/vdcfxXjZLe?=
 =?us-ascii?Q?pB5+Rjt181Vs/VTH4edTTXq3goHSBnFyBMMJ15sD82bwvdne+niXSa9JwZCu?=
 =?us-ascii?Q?C/sk/Wfl51YYzgAgKrRJK0M0IeBj0bClrJvUsNz8l2wLHjp3F0ORWPAAplp6?=
 =?us-ascii?Q?PPokLjAF9lA6P/QYUxgY1zMV23cB0oOVfzl6QWONUbM6ZkEoL24sEpb4exCW?=
 =?us-ascii?Q?bc61wUn0EkBmSgit4xSzYYF4lxTDm5UW7a7d9tLii/4fW7J5h1sZD/nXXKzo?=
 =?us-ascii?Q?AeFlK48lM1OLn+sYlRNDgJjwwr364CJJDkTNxzUaXNoLh3jhMfwp3FOOMK5o?=
 =?us-ascii?Q?fuogMLwIWzmHZq7jgbZzmx1rTGGntpZXwOGVTEASLWmKJH2WZ+Zy/Rc9sAHV?=
 =?us-ascii?Q?tM4uG33Z+allLFw+YGMZqrI4d/j4rTE75+WteS20co9U7VozNRejXoUzTPSX?=
 =?us-ascii?Q?KedQnMvjRyKKtAEZhYh5zZ1Oevd4vipgmHUXiu6ZvdWn3pmcKBMnVOoWcxru?=
 =?us-ascii?Q?6bxbMcZmL09qMhlLNs6WHxg7ZVw7/KelKlvNP8VqfNR+HHIcNIlAEdHIhVoZ?=
 =?us-ascii?Q?uxxR/Re7cngXx13UF0PDkgzAG2Jr6HSs2CGryMFVtuKBdvLytj+9qGsUD/On?=
 =?us-ascii?Q?X1EKC1aOgGLZFOgSYjCxkQnOKzsW+Z/w9ZiHRWwTb80NkJ1mNEFa7XiFqKRs?=
 =?us-ascii?Q?3HZQbqJw17LZffWDVI8PYHEc9PrQaH6q4cXMupx2cKn/tY7pjC7c1NGZdpmu?=
 =?us-ascii?Q?9sVsQBHVZvsPrv7T13vMJb/CB+jZHVnMo2BXYTf5m1zsrzmRIKzERQH2V7kI?=
 =?us-ascii?Q?EjmsrpCc2kBEo2WjJVi9+QrgW6JdOB+8bcxr7NbbO+uWRYW2c390DCeJuvpK?=
 =?us-ascii?Q?U75qjn62/xIpsQXKB0zbRGI2BbZ8uB5JjMTrr7+tVRmJ+1E2l1EFXXB9C5Uu?=
 =?us-ascii?Q?yjWnhUuynzoT1mIWsb5aYwCRpQ6w8vG2Q2Fvo2qTK6krY1uiTFMTpydhdwRn?=
 =?us-ascii?Q?nJpL6ThCUducXgGwQd+RiIqWFTetxQ5kBzpmpNV0diIG1ML2qAPE9KnZHnhf?=
 =?us-ascii?Q?tba1YoHzj+YeSofrZO6pQ7ifFL7wFyEYvolS51thqfXJt37usECq/AnHxCTa?=
 =?us-ascii?Q?R3XHvDgseMnoBVdJbYWDAKJIBw6dL5gOUfW2710ccv7cUc9+vilpCVIdECH8?=
 =?us-ascii?Q?5kTdM1bZYeAzUCcEwntCj5w9yFpb4fE/Vn5R25eflpapOMqsF1+DRSLeMTfk?=
 =?us-ascii?Q?+LHEXibJZna1hyCs1jZjWpd/slDSL/VK2Mv7u0BXhwLdzWBxn9y6AdiVAfI3?=
 =?us-ascii?Q?R1u7Q9G9Zj46NbzbB9opeoFokJan2Z6pPoE51FKtuD5jVMKR6zNmr8rwIw1T?=
 =?us-ascii?Q?Vod0FCgCEhx7/DzbOKc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 11:30:50.9472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37412262-3e97-4eeb-04eb-08de109549ff
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5665

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

Add support for the UFS host controller on the AMD Versal Gen 2 SoC,
built on the Synopsys DWC UFS architecture, using the UFSHCD DWC and
UFSHCD platform driver. This controller requires specific configurations
like M-PHY/RMMI/UniPro and vendor specific registers programming before
doing the UIC_LINKSTARTUP.

Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
Changes in v1->v2:
 Moved the PHY reset logic to ufs-host-init to prevent unhandled interrupts.
 Remove vendor-specific ISR handling, as it is no longer needed.
---
 MAINTAINERS                        |   7 +
 drivers/ufs/host/Kconfig           |  13 +
 drivers/ufs/host/Makefile          |   1 +
 drivers/ufs/host/ufs-amd-versal2.c | 564 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h      |  46 +++
 include/ufs/unipro.h               |   1 +
 6 files changed, 632 insertions(+)
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
index 0000000..40543db
--- /dev/null
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -0,0 +1,564 @@
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
+/* PHY modes */
+#define UFSHCD_DWC_PHY_MODE_ROM         0
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
+	host->rstc = devm_reset_control_get_exclusive(dev, "host");
+	if (IS_ERR(host->rstc)) {
+		dev_err(dev, "failed to get reset ctrl: host\n");
+		return PTR_ERR(host->rstc);
+	}
+
+	host->rstphy = devm_reset_control_get_exclusive(dev, "phy");
+	if (IS_ERR(host->rstphy)) {
+		dev_err(dev, "failed to get reset ctrl: phy\n");
+		return PTR_ERR(host->rstphy);
+	}
+
+	ret = reset_control_assert(host->rstc);
+	if (ret) {
+		dev_err(hba->dev, "host reset assert failed, err = %d\n", ret);
+		return ret;
+	}
+
+	ret = reset_control_assert(host->rstphy);
+	if (ret) {
+		dev_err(hba->dev, "phy reset assert failed, err = %d\n", ret);
+		return ret;
+	}
+
+	ret = zynqmp_pm_set_sram_bypass();
+	if (ret) {
+		dev_err(dev, "Bypass SRAM interface failed, err = %d\n", ret);
+		return ret;
+	}
+
+	ret = reset_control_deassert(host->rstc);
+	if (ret)
+		dev_err(hba->dev, "host reset deassert failed, err = %d\n", ret);
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
+	int ret = 0;
+
+	if (status == PRE_CHANGE) {
+		ret = ufs_versal2_phy_init(hba);
+		if (ret)
+			dev_err(hba->dev, "Phy init failed (%d)\n", ret);
+	}
+
+	return ret;
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
index ad91ea5..c618bb9 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -12,6 +12,52 @@
 
 #include <ufs/ufshcd.h>
 
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

