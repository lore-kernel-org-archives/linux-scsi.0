Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010024.outbound.protection.outlook.com [52.101.201.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDE819309E;
	Tue, 21 Oct 2025 11:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046257; cv=fail; b=CQlWTe/NWkhneSEF3r8lJEbJIa0RWjJ0LVA4yR0yvyZSSiRBFCMCSkN92xLcybGoWULAStWCKtkzx7F4G8TEYAD4uHkuLJOisK7HK5NhxisoUviakeeEJC9sKrcq2gn2HitOr8QGzdJi87kvkAZnzJzsafRKA1WgnufzCPNo4qU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046257; c=relaxed/simple;
	bh=x/w0YAi+vqQuGHcqWZhSMhjxlodiIBERc8LBwLK3hss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJ0CQ8cVYZTfT9FbzlDBM3bVFlId4OSqEsg/BjvDgETzrA0OWMRBbBU2CG+JXdzaUkb/R2KuLkN6QJ6Z4qp1CKreAsN32WeyKj/RsGo1s4D6UQo+AnZaD/caJKj/+XJbcKL7ADl9rdJvhxvOtGSoz76/9XoFTei0gu5mJJgl14g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TXsFy2j0; arc=fail smtp.client-ip=52.101.201.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TXsFy2j0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wyf+3XDw5AKcSoyCc24GGrv48MQneocr5sXiuep/j9AOjHMLDkqsnsni6jJutbheGdevl9OrWHuj/8K0z7TEln/fWucNO85+LrNij1JHcpJBYDfyTD02xwB7d6T5+H/s0DNM7Far9OGPXxqAlEgKZp4Cm02Xzeov8kiWdBS6ChP59KC82QEmEQbAxSA7ACED17gysXZdLsU6LJ883Tdcoy3/FpYLady1HhHNkowVTF9lUSc+/BNwhmKZlKBkRMkEtnoTThSNCSMaMdk8ksScYMAGljWe1Q3qfc0Y/sdLkH3lOcKUHE0/siQ/wB37GVeg+w2eRT4VaUk6tC6QmIamWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAKds4+VJ4cdtvOiwVQmfW8G4vuDrcOf7y4/p9GWoOQ=;
 b=u1jU7E280Smkw+IG0ey4zZDZZGtaFxEa9Ev5gfGf7g/p8/2qF976QCiqJRF9RNbgNbMInR94LX78fowwglvJTL66ygFsBWNcs0C4gTjsP1q1lY1qyBS5eqIrzmMueZYOKDjo31TG7JVUQb6GjuaFT0kN0kKDgKTbC0CcQWFtIdwnz0Kw5ckgQexvFL3U4tDqD9+DNI/90yPkTV0/cqOXK1TZveT2k0hhL7tFdZfe6cJhBYnrLLqN5v38UNcABCZjIduro7JQ+Gj9XpHGeOYfm1zOkhYwLu/XPcl2RdXQ9X73mV8tpCvFQNRzCW/g+2NaoTczoG2+1Mmv0PteNsGdTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAKds4+VJ4cdtvOiwVQmfW8G4vuDrcOf7y4/p9GWoOQ=;
 b=TXsFy2j0nQvOlAZ4HH1zWtfq6Wm6ncCLcba5WQKt1INasA6CdJUZjjx7Eab64m8+WT9gAkXn7KBwEBRfu4+IMuj0gCd2ZacjQNw60ZoJDxl1AQSsxdo5mSjNMSTjhkaPuZiQdUwsFBZK+W+WEERf4K/qMWEM5ULqmGKGMZgNEFU=
Received: from SJ0PR03CA0148.namprd03.prod.outlook.com (2603:10b6:a03:33c::33)
 by DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 11:30:49 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::69) by SJ0PR03CA0148.outlook.office365.com
 (2603:10b6:a03:33c::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.16 via Frontend Transport; Tue,
 21 Oct 2025 11:30:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 11:30:49 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:25 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:24 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Oct 2025 04:30:20 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v2 3/4] firmware: xilinx: Add APIs for UFS PHY initialization
Date: Tue, 21 Oct 2025 17:00:02 +0530
Message-ID: <20251021113003.13650-4-ajay.neeli@amd.com>
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
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: 8483968d-c288-452b-2873-08de10954902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1++oPsFcDF437zRRvzdlTohUUWliQKB8vysKcs2KBxg+FS9jjlJr2urMFA7K?=
 =?us-ascii?Q?ZSJBlWMbA+A6QCz3XweUST+K5zoxeD4V+Qeh7dReDWw6DVYXHS40FAQLZo3d?=
 =?us-ascii?Q?uOUuQUd6Hi9LpFPh0dFbozyIc6L4039Q9gAxMdApirr2oRuMH6xiDjvzvjCk?=
 =?us-ascii?Q?81TdQ5WFIlp9GRef62j3R8lRQFNudzaLQsDcdhu0VnnryFEKfDgKBBfvMjIN?=
 =?us-ascii?Q?Z3LiHoJMcjNqJyM5sF5RWU79Uwnqkty9LWsSjC8LpHHrkw7NQV3W+BY17XbV?=
 =?us-ascii?Q?1u0LFxaDi8xbVziX6/fp9aGkh5WhG9DInA+Qch9sakCB2AW6qN5+nbmO6xoD?=
 =?us-ascii?Q?4yjS2j6rGK1rp9WatCkzKKMwz/fs6VzfURky5tulaV+tIHum0jeeX1NF9sZ9?=
 =?us-ascii?Q?BjwNUIgfTpsLSmv4ywLTj4hO9txAbBKCanM9Vhm445DAda6CdWg4FK9sWRUl?=
 =?us-ascii?Q?x6kae74luSdWjbD5W3RhLOk4RIw0K/Ug3tsCgwhs2xf2cQ/Gt774q7ftuK7d?=
 =?us-ascii?Q?LvTcXzhVpYM1hmMDrTJSFrIaUCbVtwwMFBZPqcEj4C6uIOOE0C6SkJNQ9ZRL?=
 =?us-ascii?Q?eaXrO/PHhP7vdbZ9u1pRqSvmtq3IcoC9fIMNQNxxseEWkaHYb8HLQdStYWgH?=
 =?us-ascii?Q?pPTRjjh9OHMJ334NZhyIpbVd1N8Zv2Jz9IBKXl4OW1X8haVhHOEY33kDutVq?=
 =?us-ascii?Q?i0+6hlnmN4SDlh1ae6fzjk8LhXtQevghnFWR6pg9Xfk/AuVw+czNHYfE6A2O?=
 =?us-ascii?Q?kJHBSTXWdg759lFpUB2HU2ckkr3sqbRXnFwoVsh/7UV/ePUpRaYLZOk4UvJ8?=
 =?us-ascii?Q?sAzaifdhiMUCsabjhPb4MkX0+dRBkgKOz2QWEJV0WfL8nBuLksXHTlFYfEnW?=
 =?us-ascii?Q?VbmQGQ1QUvO62X8IHfjMvs5+Gmfc17eT1YVPRHaRVYj8k8uSxBx3GW1UCG+l?=
 =?us-ascii?Q?JpHzRjreVC+GgNXvfx/Howga/EJiDTv5G2B4dLZp+8PXMp3/bSzho5MAJODH?=
 =?us-ascii?Q?ZfYbMozMAXmxBGIcqYr4aFvKn6DYo3+K71Blp3RnuKhyCmg6cySu/WsWhCu1?=
 =?us-ascii?Q?UCnGKKEYGgg52SiXo/c8IQgu0Mmra7rdX262MFPtqxQDRjHf/9pMANmVWKiz?=
 =?us-ascii?Q?0V63qxjZUtQGF5RseECwXN8jwHkM+JcVSgT5jgUD8lHZPZvkfDt8LNR9FULl?=
 =?us-ascii?Q?h7GHDz4d2dhgdsJkLf9nlnKXMGSc9Qbw43fI8t62kZl5OnpkRrXKDuXssyr5?=
 =?us-ascii?Q?mSGFCGkTliRKNFxCr+sDh6u0dPZwky/HacymBn8WpH+8xfQ5NFnTyyqAs7sm?=
 =?us-ascii?Q?5x0hD48HE0UnjnOcNTH0TJ1YLx8B/m0WKsHskE7SzX9Hf4/zF91krafcE/ux?=
 =?us-ascii?Q?VUUgKfLi+pG/Dyouxz0V0FAG3f/65rZo1kHCd52WW5KnPNnPSZmS38oVLFub?=
 =?us-ascii?Q?0zgRjwxVwKlcoiq55GlmHdkfjgJyelt4E75vtdN3/hfiSm2LWxxcHzUQ39CZ?=
 =?us-ascii?Q?n96b9dA6pkOV4wXvEsfiyIEJYzM/SARzRA2EU3hJDiRczHUdgl3IJ73t+MEM?=
 =?us-ascii?Q?aNGsTIGGHK5LEHqQ6z8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 11:30:49.2892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8483968d-c288-452b-2873-08de10954902
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780

- Add APIs for UFS PHY initialization.
- Verify M-PHY TX-RX configuration readiness.
- Confirm SRAM initialization and Set SRAM bypass.
- Retrieve UFS calibration values.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
Acked-by: Senthil Nathan Thangaraj <senthilnathan.thangaraj@amd.com>
---
Changes in v1->v2: None
---
 drivers/firmware/xilinx/Makefile         |   2 +-
 drivers/firmware/xilinx/zynqmp-ufs.c     | 118 +++++++++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp-ufs.h |  38 ++++++++++
 include/linux/firmware/xlnx-zynqmp.h     |   1 +
 4 files changed, 158 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/xilinx/zynqmp-ufs.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-ufs.h

diff --git a/drivers/firmware/xilinx/Makefile b/drivers/firmware/xilinx/Makefile
index 875a537..70f8f02 100644
--- a/drivers/firmware/xilinx/Makefile
+++ b/drivers/firmware/xilinx/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Xilinx firmwares
 
-obj-$(CONFIG_ZYNQMP_FIRMWARE) += zynqmp.o
+obj-$(CONFIG_ZYNQMP_FIRMWARE) += zynqmp.o zynqmp-ufs.o
 obj-$(CONFIG_ZYNQMP_FIRMWARE_DEBUG) += zynqmp-debug.o
diff --git a/drivers/firmware/xilinx/zynqmp-ufs.c b/drivers/firmware/xilinx/zynqmp-ufs.c
new file mode 100644
index 0000000..85da8a8
--- /dev/null
+++ b/drivers/firmware/xilinx/zynqmp-ufs.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Firmware Layer for UFS APIs
+ *
+ * Copyright (C) 2025 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/module.h>
+
+/* Register Node IDs */
+#define PM_REGNODE_PMC_IOU_SLCR		0x30000002 /* PMC IOU SLCR */
+#define PM_REGNODE_EFUSE_CACHE		0x30000003 /* EFUSE Cache */
+
+/* Register Offsets for PMC IOU SLCR */
+#define SRAM_CSR_OFFSET			0x104C /* SRAM Control and Status */
+#define TXRX_CFGRDY_OFFSET		0x1054 /* M-PHY TX-RX Config ready */
+
+/* Masks for SRAM Control and Status Register */
+#define SRAM_CSR_INIT_DONE_MASK		BIT(0) /* SRAM initialization done */
+#define SRAM_CSR_EXT_LD_DONE_MASK	BIT(1) /* SRAM External load done */
+#define SRAM_CSR_BYPASS_MASK		BIT(2) /* Bypass SRAM interface */
+
+/* Mask to check M-PHY TX-RX configuration readiness */
+#define TX_RX_CFG_RDY_MASK		GENMASK(3, 0)
+
+/* Register Offsets for EFUSE Cache */
+#define UFS_CAL_1_OFFSET		0xBE8 /* UFS Calibration Value */
+
+/**
+ * zynqmp_pm_is_mphy_tx_rx_config_ready - check M-PHY TX-RX config readiness
+ * @is_ready:	Store output status (true/false)
+ *
+ * Return:	Returns 0 on success or error value on failure.
+ */
+int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
+{
+	u32 regval;
+	int ret;
+
+	if (!is_ready)
+		return -EINVAL;
+
+	ret = zynqmp_pm_sec_read_reg(PM_REGNODE_PMC_IOU_SLCR, TXRX_CFGRDY_OFFSET, &regval);
+	if (ret)
+		return ret;
+
+	regval &= TX_RX_CFG_RDY_MASK;
+	if (regval)
+		*is_ready = true;
+	else
+		*is_ready = false;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_is_mphy_tx_rx_config_ready);
+
+/**
+ * zynqmp_pm_is_sram_init_done - check SRAM initialization
+ * @is_done:	Store output status (true/false)
+ *
+ * Return:	Returns 0 on success or error value on failure.
+ */
+int zynqmp_pm_is_sram_init_done(bool *is_done)
+{
+	u32 regval;
+	int ret;
+
+	if (!is_done)
+		return -EINVAL;
+
+	ret = zynqmp_pm_sec_read_reg(PM_REGNODE_PMC_IOU_SLCR, SRAM_CSR_OFFSET, &regval);
+	if (ret)
+		return ret;
+
+	regval &= SRAM_CSR_INIT_DONE_MASK;
+	if (regval)
+		*is_done = true;
+	else
+		*is_done = false;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_is_sram_init_done);
+
+/**
+ * zynqmp_pm_set_sram_bypass - Set SRAM bypass Control
+ *
+ * Return:	Returns 0 on success or error value on failure.
+ */
+int zynqmp_pm_set_sram_bypass(void)
+{
+	u32 sram_csr;
+	int ret;
+
+	ret = zynqmp_pm_sec_read_reg(PM_REGNODE_PMC_IOU_SLCR, SRAM_CSR_OFFSET, &sram_csr);
+	if (ret)
+		return ret;
+
+	sram_csr &= ~SRAM_CSR_EXT_LD_DONE_MASK;
+	sram_csr |= SRAM_CSR_BYPASS_MASK;
+
+	return zynqmp_pm_sec_mask_write_reg(PM_REGNODE_PMC_IOU_SLCR, SRAM_CSR_OFFSET,
+					    GENMASK(2, 1), sram_csr);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_set_sram_bypass);
+
+/**
+ * zynqmp_pm_get_ufs_calibration_values - Read UFS calibration values
+ * @val:	Store the calibration value
+ *
+ * Return:	Returns 0 on success or error value on failure.
+ */
+int zynqmp_pm_get_ufs_calibration_values(u32 *val)
+{
+	return zynqmp_pm_sec_read_reg(PM_REGNODE_EFUSE_CACHE, UFS_CAL_1_OFFSET, val);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_get_ufs_calibration_values);
diff --git a/include/linux/firmware/xlnx-zynqmp-ufs.h b/include/linux/firmware/xlnx-zynqmp-ufs.h
new file mode 100644
index 0000000..d3538dd
--- /dev/null
+++ b/include/linux/firmware/xlnx-zynqmp-ufs.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Firmware layer for UFS APIs.
+ *
+ * Copyright (c) 2025 Advanced Micro Devices, Inc.
+ */
+
+#ifndef __FIRMWARE_XLNX_ZYNQMP_UFS_H__
+#define __FIRMWARE_XLNX_ZYNQMP_UFS_H__
+
+#if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
+int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready);
+int zynqmp_pm_is_sram_init_done(bool *is_done);
+int zynqmp_pm_set_sram_bypass(void);
+int zynqmp_pm_get_ufs_calibration_values(u32 *val);
+#else
+static inline int zynqmp_pm_is_mphy_tx_rx_config_ready(bool *is_ready)
+{
+	return -ENODEV;
+}
+
+static inline int zynqmp_pm_is_sram_init_done(bool *is_done)
+{
+	return -ENODEV;
+}
+
+static inline int zynqmp_pm_set_sram_bypass(void)
+{
+	return -ENODEV;
+}
+
+static inline int zynqmp_pm_get_ufs_calibration_values(u32 *val)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /* __FIRMWARE_XLNX_ZYNQMP_UFS_H__ */
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index f441eea..604a03f 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 
 #include <linux/err.h>
+#include <linux/firmware/xlnx-zynqmp-ufs.h>
 
 #define ZYNQMP_PM_VERSION_MAJOR	1
 #define ZYNQMP_PM_VERSION_MINOR	0
-- 
1.8.3.1

