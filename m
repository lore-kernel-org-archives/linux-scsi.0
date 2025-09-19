Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010029.outbound.protection.outlook.com [52.101.193.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8671A9FAB;
	Fri, 19 Sep 2025 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285551; cv=fail; b=hTZJJHnCW4QCMpEWWQmZTV7B42gr7pkjRh5EtvqAEv8x/kgETuDjDjPyIMyhhBDEXjwKSPxoxYciFLwocGyXtcQAXK0Mq3ljWVFaelDmWNQrUfqDioSEnmeCbxz306Q6Jle4bDIa+DAzuegAzhl44r5wAYanYeaQrAdUur4kpb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285551; c=relaxed/simple;
	bh=kJ7JN2/JLkUQFWq1hYS7fhiZ8Z6tj1e8ohJN2UkZKOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugLQ2LrlaYv9255wPZETC1A4Nmc8cs5+ijd4bGWMqH4k4wTo/v/mbFyd0b722rJXsCcjtVwtHO3KiB+lc/TB66dId7GY3z56M5FtwfHkUB4DGO8Fj3jQBaqfDx3Kn7HNe05QVViLXR0+9JKfBrwQx1sBu6H9ewvazARuVbeSGEI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kjOMvuE6; arc=fail smtp.client-ip=52.101.193.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kjOMvuE6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lk2SYAJlAKjOGnxJRXxnmcaBRiTO0bmsmPM20WRV1Z41D1yglMUuXHQdfKqEoZ+mH1WjfmQfe4GirDHJ9zRimMFZ7GZBPRtJfEwYlD504jX31Ec4T1NZhZnP40HtfGonDKTNlYsKz/jOwYvLCT4wCH6AbaUwmNXv+L4vV8Rm48v04VlAfiVI+BFXJ3sIj+i6HtHxzxPHEob9agloyPQcX/HwF8YnaPkDpyK/EhhTRBORhntqexSTAIl5J4GE8d31ZuQbF8UtZp6e4mGkduRySj8DipmkKu2fCraYxs9fyoAzYrPXTQ3BKSWOyL15JSBb8x7l1mbDX1Up+UmDdCToEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QAP9Jweiz6mJRKe8HWf+P2/sHpWKsRImOFG6QbquNI=;
 b=muF9LHraMHi6b2e49nm4WaX4Yqo0Kp51LL/TOR1/iSD+yJIMBSVATH0C5k/CkcKtvodcgJiDhxJrxWu0e87yIIb6R0UkxoBPzcYGzVCv0X+dm0rcIevQ/wLY2PIXzC57VqWJJlPW6242FCXPzlc3FQ1KZm0I/Vkxz91ItXlhisqM2Cx5Dk9xpaSuJz9cwIm/l3fhETVvkdegObdI6G8QxIfVrBugYhsiGRqUDu23z8Whe16QJ2J9+8Ugh5+FSQY6/zukQfP5wBGkXWvN2FYqIx6cg+fKAGHkfiQ55087kDmyHL7iv49KAb1ieZtAjuKoW8jKPJnZNJyp463Rj80ssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QAP9Jweiz6mJRKe8HWf+P2/sHpWKsRImOFG6QbquNI=;
 b=kjOMvuE644nF2Y89fNrr4kWKdMJrVFwjq5j6MXgmSVa8I54Sv8y8R36weMKSbs7LZFCSqkiBT+JSA/cRfVz7AEMAzgRfyidwELvmbGV+3hyPwU5dxxuLJVlD9WaZyVCSMYlUAHFE/wgi17st3fI8cWiHkveTqqc8hWYvPSLY7Y0=
Received: from BY5PR13CA0003.namprd13.prod.outlook.com (2603:10b6:a03:180::16)
 by CH1PR12MB9720.namprd12.prod.outlook.com (2603:10b6:610:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 12:39:07 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:a03:180:cafe::48) by BY5PR13CA0003.outlook.office365.com
 (2603:10b6:a03:180::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Fri,
 19 Sep 2025 12:39:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 12:39:07 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:39:02 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:39:01 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 19 Sep 2025 05:38:56 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 3/5] firmware: xilinx: Add APIs for UFS PHY initialization
Date: Fri, 19 Sep 2025 18:08:33 +0530
Message-ID: <20250919123835.17899-4-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|CH1PR12MB9720:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf65b47-408e-4e8d-e8d4-08ddf7798631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2SBMk8vchxxSsr3BHM65wZZ3C1I3vSLeS3w2ingIaMG4czYtoQIt7oy6Ojdo?=
 =?us-ascii?Q?ZarThnFcqpw/ENBBobxmEGXu5Oedy74hl4YhXV/n6+rMvP3BMk32gGo7u2O2?=
 =?us-ascii?Q?7QQXWaR5uTS57T1dZUAh91RuEsPPDK+Cp7sqk9foopmcompaWJCme1VRzhPR?=
 =?us-ascii?Q?5hzT2qFZ12sGcPmxirQrSgRbUV+iUCPdwodU5oaHYL+GIG/urFfSIQPwqcjF?=
 =?us-ascii?Q?Eo6Qc6Tjr1N5PjiMC70nKIPAvZ5QnhCh38R+riCdzlBpn9kSatRFQ4XsVOGK?=
 =?us-ascii?Q?5i+Mf6VPIvZ4S8VNzNMhspwhs6jfXe8UxUCOZykEckyytYwG5UBxxw/5HHY5?=
 =?us-ascii?Q?Dtl+Wb2q4hTxPKCO0DtPbXH+G0J3rDGuYq/krUBFF8LheolpkR38OyPXx3Wr?=
 =?us-ascii?Q?sK6wmu7UATB9iMZxRBZHs+DGHNisnLj8Txl5u9Sy7d9owhqPeDPzf7Ft8g8S?=
 =?us-ascii?Q?zlcnlGJmKFDH+H4QAz3gRdOChExeiJbzKRIfJJoYBHrEd5uN1REyZ47bll9r?=
 =?us-ascii?Q?NIC1Tz9GwrQn6+sqm8hG7PGBZtVztKeyJAutKnTTy7jyJtf9wHBwo/Ul4+tx?=
 =?us-ascii?Q?7Jr51NT/iLv2H5VbjGQZJTU6lODL7ck+xExB6P8wgzRaPYDMOm8clsVL7MgX?=
 =?us-ascii?Q?S93xD2DYatXLhb5CV9jVBhQ17038AaZJzDKkxVHDJ4P8A5i+eFonCfa5N961?=
 =?us-ascii?Q?jnEJoJiMUC8tezR8mTAGRfANAfBKfB/oGb2xvV6Uwrrv4WJn2lNZr/JhxZQg?=
 =?us-ascii?Q?/by2oLnUply+6m3cIU8G/CIsohCMhmVXiUke5MKP9ybsv3/HqpGCbDwxVLwL?=
 =?us-ascii?Q?U83aZM7wqGWKNB9M14RPxA8SWC0xhsn8ba1QPkMJ2FZG/4ELPQuxMi+PWmNP?=
 =?us-ascii?Q?82XmCqgmPptQZQoKbEL41nG3AprXGpg1ChwvdTZKoWcStbL6pFYckJdUwS9a?=
 =?us-ascii?Q?jvo5R5xNTabqJpOROgYfyKBlrA84wROSD/Snlhd30Z4kLqDLy2BQjj925b0g?=
 =?us-ascii?Q?LAPb4AYp4SRsdJVLrDUmSUoDSI6kuo2ZJlS2jHzlVTzhfEmwhkrJu50i5E2G?=
 =?us-ascii?Q?lfrbAaUWSVOGDDhO+KXpirfKMXOQ6uEgrcD8Gy6CQNk4mcu05pUMrrAlpNZE?=
 =?us-ascii?Q?0OrMfTcHbGdyEsN2HoUQXlX2ThNr6ubFPzEx+ChAl6FLgORMMlqkB3GsgiFY?=
 =?us-ascii?Q?IuBS+Re6gqpfKbrmVHU7OMyI+vCqPGyw78DBaOZ9Q/EqFk1hI8wd5f+K1/6q?=
 =?us-ascii?Q?tzFOpvPWn2BghfSb3V4tHGzJjyYpcCEERotrI3u+CtTKvgViJcGRwi0QKzsu?=
 =?us-ascii?Q?Q5XAomKQcBn+mXWDyr2MuHztIplPUkLklLWhcW/eHUwU8ioDjsi6MimpFbdM?=
 =?us-ascii?Q?OBLNmAJK9bMn7X83BqYcwFGB1AtF1CdNuBUfZd7NM/YFSHkr4tzgFcgTCB+e?=
 =?us-ascii?Q?DHNSpkeh63MKHMgz/ud5iaoK6OZg0HOv7xNQ88/OpeLv74zVbcZiOPPQ1QBz?=
 =?us-ascii?Q?gNC7Vzn+K81fsT89KzrJSie6SB7NOrdtVNvF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:39:07.0297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf65b47-408e-4e8d-e8d4-08ddf7798631
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9720

- Add APIs for UFS PHY initialization.
- Verify M-PHY TX-RX configuration readiness.
- Confirm SRAM initialization and Set SRAM bypass.
- Retrieve UFS calibration values.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
Acked-by: Senthil Nathan Thangaraj <senthilnathan.thangaraj@amd.com>
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

