Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013020.outbound.protection.outlook.com [40.107.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBE032E695;
	Tue, 21 Oct 2025 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046251; cv=fail; b=HM+ktiaUe31Me+11x2souNt6Qhgf5l5wolXi5PBNECuOo/PbpPDMlXh9iJZ4IhPbGa9QiBauMuQE9JGt6/7B2t2C79GUatgpoOnIPXVZu+fJyx1mcVbofdr26WI73BUbvBNmv7+7bM4z9dZYxEm11ozUsNwEwUBaX1tSbX/KO2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046251; c=relaxed/simple;
	bh=hGyZGQhd/29AyRUjPPtckbmVe99dpsTJj8G94+uydjg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZYV7BOsN9hZ1KzP7GEHnSHk7tzwDYRVJfEiRhPBUU/bVkIRyQuE1C0tLiGdDFC5ONxF7tjPI8Y0X+/ncnNFV8D7tBIUpx8tXqfGPKxaDIA5eWeFT8iXICFhUwBrXedbMJ7kzfM7fGAKGEu5ppJtCWAyujPE0jMWrHDNT+4tamTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DpS7jj0b; arc=fail smtp.client-ip=40.107.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DpS7jj0b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uj3nM6pvdmCkVhl1RT8sTL7Qxlk9PepFsVT49lkY0yC+N6O7V6xLuOwHwhfEcIdQMOFUdaPgIv3iTXr8g2YgpgSIMnG90cDMowHGwdcOGs7cBzU1SqWdafHt2VLxvvIGmO/XA9JBhHJdX8YDsjb5T/lA9enTwygdXN9wO9NKCHWsX+6w/9xTtskTzDtnhN4yuW8rWSi6/tfxRLjivHG54E3pL/V3Yyz2KqxkEdZDgVND+99u7kNENnWHIaWdRV60zWHW2Fm/qXyWxcfi/FCviFkosmUUOD9txIFpZuqmiGmqFxbdEBikoarXzROW8G0aJNc5c2YLFX4dTriY+UoCpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GCCeCLn6q8jlaafYurJzq1M9V4WE3QNuEQR1v90tbFY=;
 b=shreWA30LB1v4jGZfPDK2H2Yah6aTCDE7/zvOVA1y7xXGy25g9kNQZhr0a33oKcHUQYHLlQla/NdlKbZzhSUx2PGAp//G0AjG/i8X58krRnDapOKY0X7Mau1dagXp+JgSwj8E9pe6if8NQcqQbnTPfpoiR8dctEwR9cH+hyVgC5WFtOYuebUm3+Pb00S0rGNU3/P//b0UAS/noDZJuHU54SrCfdOOSOrjNnZKMaT+n4jRO4L1IaG9/J1VLKTmXATMhTiQK2Hi9dm7UyIztBQtRG6Z2iPISsleWnhWR5/usIxnlGoVcaSs3g2qwR6Uw2sxiTj0zHKh4WZleDM6fmmkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCCeCLn6q8jlaafYurJzq1M9V4WE3QNuEQR1v90tbFY=;
 b=DpS7jj0b+L5avx0Y6AJ8cnWhghJbo/UuAgdUEWF/+CzJr1Y8lcNPVhuxuIYrE+MZkC+ze4QpR1Cs9q+Xk53UFVa0Yyds6v7E4hbA9VSWJAL72QWdmf4n78dD/vEIP+Cnt8Oek6T52IQH01EQfUFCDrPMBISP8VmfwDHfGyDq6ZQ=
Received: from SJ0PR03CA0149.namprd03.prod.outlook.com (2603:10b6:a03:33c::34)
 by IA0PR12MB8840.namprd12.prod.outlook.com (2603:10b6:208:490::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.15; Tue, 21 Oct
 2025 11:30:43 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::dd) by SJ0PR03CA0149.outlook.office365.com
 (2603:10b6:a03:33c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 11:30:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 11:30:42 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:10 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Oct 2025 04:30:06 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v2 0/4] ufs: Add support for AMD Versal Gen2 UFS
Date: Tue, 21 Oct 2025 16:59:59 +0530
Message-ID: <20251021113003.13650-1-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|IA0PR12MB8840:EE_
X-MS-Office365-Filtering-Correlation-Id: f6b91750-5829-4c1e-c930-08de10954526
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ug9GtyrXUeXIEUmAiy/nNw4FdfYQm2Sf8vlXmje4y6Phj7epFxZEic4+UfXE?=
 =?us-ascii?Q?gC9FjTLBW5KNhH0S2DbuoWTqvOfSwARplQ/7l18oGHwBTTflFDdJyTgjagbE?=
 =?us-ascii?Q?xe9voulCyKdXo4wi0JpDzbIERuTMpTYLrQbpdSs109Z7NBT2NtYsSzb536oS?=
 =?us-ascii?Q?NNcO2WIF9eMj+AiYFo58q4qaN96fw32xvcar+/szrauT+6WDVzz/qa+Omr0v?=
 =?us-ascii?Q?GZZByKBhHheUzwwPZgRye+VOxn/7ZK79VOq4xFArr/4FeFcKWfuZXplaSIAb?=
 =?us-ascii?Q?riHDQDOqERQWUpgmBltnRibhsNEYB+Y6a5wzeDpJn/Z55M3GprXMKQVZRtg8?=
 =?us-ascii?Q?cmwm3Mloh+4Udwk4jpTnj1Pygd+jAaSnjy2IJVAvoDvIgAWK9PgO7ok3ltqZ?=
 =?us-ascii?Q?guLDXY+Mb0n1fPi/QngxTCqsSswiPLArdUKpHm6IyG+ArKLPxBPF8K79zjRj?=
 =?us-ascii?Q?AayiQERwrqAJ5u5gZUu5LCrwn0yX6/n/qLQC7C9cqyQGBTBcDFD6F9nVb3Z6?=
 =?us-ascii?Q?OmjP8Z3IsR55K/Pf4EJbvPMA3t7SWA4P0T3ofSn8kfhKP23MBogRJZOdOB3F?=
 =?us-ascii?Q?RbQoyt8z1fHS8ikrq5oDQP8/vcVgxnXrgHvF0qpd7B3LSVi/TEVRJZSdPAnU?=
 =?us-ascii?Q?pxPlej54x+wvGV7lTisiN5biEERlo1i1j83D5ObVx8Lq020wz0CmFOjr9Rn4?=
 =?us-ascii?Q?ttDb70G5tq1WVxgJN8qYoK9wRePglnqnxpeNQPUazHUsAhGTX5Su60xSmocK?=
 =?us-ascii?Q?y8bHE4ilFATBxhrc9e0ihzvFT/1JkRDzBELONwCQzXxcfKpZlBTUUb0IBTKf?=
 =?us-ascii?Q?shBt3Y4k4hGiUx7DK0nk9gjtgjPM6vieL1/tqLM8iNeGJytPxKPJC/zKkLUp?=
 =?us-ascii?Q?u/ndSPxlQ4no3qmbbXIQ0U0RzcOBr3ZTs38cMG59T9VwR+waEsXCzxDavXSi?=
 =?us-ascii?Q?ptKZf7i+laqYCXPThrDsxVe3Q6snaShpqxfOnIRGIYLju1OsWOz9nVwkzhmj?=
 =?us-ascii?Q?LpRUcNSJ4q2gKMT//P4cIVETxHjZ7NyELoQ2AYVF60VWHaKiuS/UX2BOQBPc?=
 =?us-ascii?Q?0mbaP1EPNIxRZTB7R2wKS6W2vST2f8ybsnwXE8KXLKAjbhf2dbRe5r3kFML6?=
 =?us-ascii?Q?CAnKP5tBFpA6r9O5IhOTYFxfT0fGBh7ZGP3r2TTWuqZRz2YGOBkFhjgyEpEp?=
 =?us-ascii?Q?btyCllHkxzJ4J5G2QUwqU0ddzswdOV59Z0oOV7iG9DhEmbexGG49OetEniTZ?=
 =?us-ascii?Q?3emPvVFVV6rxFWRcNKeIq2Dt9akoBUZjgjZHWpTZau2PVEvc3PRm+19zu6B7?=
 =?us-ascii?Q?pUekh7rGoevhaBx++K2IXyu98UGT302KR5PscEvL2fClyWyuLDU3TraQdVu3?=
 =?us-ascii?Q?lhHwg/4ScGUXRzY7HKcDJdMtp6lrHH9OogW0F4mfpaczKyWomqs+k2UiGzpU?=
 =?us-ascii?Q?fjV0lEru5Psn85KL8TGJt+b65Z5lahvU0fB89JSjbfiSP+N/bBMeM+lrnzKx?=
 =?us-ascii?Q?offPFXCP3ZiwX+/4tW/Siidhbi1WT/AHgV7eavDYwyolKtzqa5+WawFtD5el?=
 =?us-ascii?Q?E3zW4nZ5qEaaOg8CiY4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 11:30:42.8179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b91750-5829-4c1e-c930-08de10954526
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8840

This patch series adds support for the UFS driver on the AMD Versal Gen 2 SoC.
It includes:
- Device tree bindings and driver implementation.
- Secure read support for the secure retrieval of UFS calibration values.

The UFS host driver is based upon the Synopsis DesignWare (DWC) UFS architecture,
utilizing the existing UFSHCD_DWC and UFSHCD_PLATFORM drivers.

---
Changes in v1->v2:
- Address review comments from v1:
  Rewritten commit message to clarify this as UFS driver for AMD Versal Gen 2 SoC.
  Removed patch that utilized reserved bits for vendor-specific interrupts.
  Moved the PHY reset logic to ufs-host-init to prevent unhandled interrupts.

v1 link: https://lore.kernel.org/linux-scsi/20250919123835.17899-1-ajay.neeli@amd.com/
---

Ajay Neeli (1):
  firmware: xilinx: Add APIs for UFS PHY initialization

Izhar Ameer Shaikh (1):
  firmware: xilinx: Add support for secure read/write ioctl interface

Sai Krishna Potthuri (2):
  dt-bindings: ufs: amd-versal2: Add UFS Host Controller for AMD Versal
    Gen 2 SoC
  ufs: amd-versal2: Add UFS support for AMD Versal Gen 2 SoC

 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   |  61 +++
 MAINTAINERS                                        |   7 +
 drivers/firmware/xilinx/Makefile                   |   2 +-
 drivers/firmware/xilinx/zynqmp-ufs.c               | 118 +++++
 drivers/firmware/xilinx/zynqmp.c                   |  46 ++
 drivers/ufs/host/Kconfig                           |  13 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-amd-versal2.c                 | 564 +++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h                      |  46 ++
 include/linux/firmware/xlnx-zynqmp-ufs.h           |  38 ++
 include/linux/firmware/xlnx-zynqmp.h               |  16 +
 include/ufs/unipro.h                               |   1 +
 12 files changed, 912 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
 create mode 100644 drivers/firmware/xilinx/zynqmp-ufs.c
 create mode 100644 drivers/ufs/host/ufs-amd-versal2.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-ufs.h

-- 
1.8.3.1

