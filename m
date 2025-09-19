Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011067.outbound.protection.outlook.com [40.93.194.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C851A9FAB;
	Fri, 19 Sep 2025 12:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285559; cv=fail; b=YTbYH2wcbcY+pwqLcjrEHW9qBSyc0uGMhAYUpwiifbhFXbLykkQjN4VbLQwlhZTL+difZG5WB9L31sQdH+2O1XPbLlEHiI1JsRgCuA5jT5mWBEVTBQEnxd9iY/jnF+SMBr1re8D37NurDwmcOMlUJXTeoDtjwPhA5L5Clt3HEPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285559; c=relaxed/simple;
	bh=RQd7EHc2zZ5qg2r6QWgs2ZJ12N1RvrwM3tIDGLCF2mY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ADGe6zxoOCtJ8hdVT2MZPLdOpLUEQynQTFcxJVAGtF3X3AtswRhJoCsFGDow4PKUEbrtxicz+NsF0QvzdNJn7M+0DUO3G2jm0E5n6eytfpAG3qS5Mz+EL3DdUoYzdPHkrPQt5deYHZoD8DmeZtP0HzFjrZlzjBMFhFTjIpXGSfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LoioTL0p; arc=fail smtp.client-ip=40.93.194.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LoioTL0p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mymWjNUT+fyHXSGpttZgCdOOFVQBila9K7Aqk94JZOdde40vE0yUdVuCXb4KYV+P9sHW8wk9dqWkse723Ao+If/aObEx2RMMXgA+Y19X9D0IAlXJ/3mWzJciKewHWu6GS634tissf0E2BCAASjXHVp6EyyXGcXXyBiJmRhp8MZ6S0MTuqieZvUO45aS0qaVWHy35RjBMRJhGhheDw5hHSKPJRBEfj2mqlKV7bvO+h2n6nFiD0mhOSdqBkM7nyWftaJ30MNBoCqV7HoQCCFxYdaJKpBqyS9jxpYCFgULBqsh2QZ1fF3dLI99MEe9doeGbyvVTOLRhqkE9u0QNlqlFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIslk8y0ZkkSQ03xpvWGtMaEBy1pkzvXG4gOCjuxGf8=;
 b=yO/kHzf+PYaDt1ua7fUk9J14pZ47Reeazvm05aYU1hM4j74BBq0sDLecY06PrwyOcgxwH+6uId563zRo4SYihhFYRwkRJ7VrMbBPFVHloZ80xq6bJyfUf9l37u66m3YtTiqBWZXfABt9kBUlRTqql3CjbQfVjCKLEG6PePy0YWWkCjeU+UUZO8M/vsVvZwYDQeTlbo46P/Shi0FonBxYqVWvIewOA95MmtXqKmn05T2gBKhxxr7JSpYkPaiTtTNJUVd6QZKM6br+6gnASULMsZtm4CL8Vr7T3ZnrmOxNRfbcp0piRjGqPiRAxPMOYPulU+NI+UOVOoDrBERXwq+qWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIslk8y0ZkkSQ03xpvWGtMaEBy1pkzvXG4gOCjuxGf8=;
 b=LoioTL0pK6Hf/egpL8DdlnKXtzV/rE3ny1knDbPJAz/tjFpnLIc+3ObcoRkIlzaEeVNrr4iGCz/CPQYHPLuYN2BEV2IugRdTEP6+zBtN3Ld8zojhr1GX0VnhYbHnd/L63mB2dJ2B+M5iDNfx29uB5jcc2LmS3Lj71FKeCQy9Pxc=
Received: from SJ0PR13CA0240.namprd13.prod.outlook.com (2603:10b6:a03:2c1::35)
 by BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 12:39:15 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::7c) by SJ0PR13CA0240.outlook.office365.com
 (2603:10b6:a03:2c1::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Fri,
 19 Sep 2025 12:39:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 12:39:14 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 19 Sep
 2025 05:38:45 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 19 Sep
 2025 07:38:43 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 19 Sep 2025 05:38:38 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 0/5] ufs: Add support for AMD Versal Gen2 UFS
Date: Fri, 19 Sep 2025 18:08:30 +0530
Message-ID: <20250919123835.17899-1-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: ajay.neeli@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|BL1PR12MB5825:EE_
X-MS-Office365-Filtering-Correlation-Id: 6104e799-f451-49ac-5291-08ddf7798a79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pdoGYl03R3nDrSfMgObNtmBxjq8vqodnZ+7OmolEv2qUfOt1gCr5xMu92glz?=
 =?us-ascii?Q?sbuhA+g97jNOrpIAenHtcmbhRSbI5GfnozNLNAf1RHGrI9jpi1ZbHDk6dy02?=
 =?us-ascii?Q?PiWvYGWdLn8AEH3X5AxynjntUdS9TAyoUWuZyX6Ag7Jk3J8oOc0foT18nHKE?=
 =?us-ascii?Q?eW5Cx58PGzIm1EPAAcxgwGa+cHX0d7De4O41aaWlcDYyjY398aA251ad9OnP?=
 =?us-ascii?Q?H1a6+hKVYugzdt7g6CcBhGv7dC5wDo8eZvAvCftVqs0TAKXniG3g4Bv80n8i?=
 =?us-ascii?Q?ewNSrueWBXiCiAuQc2bLsVH9ScfdtndQsHbD6aIxPfYKJIWL+Bj00CPeWnB4?=
 =?us-ascii?Q?4sOBXVcl3VwONrECsbu9oQ7k1Bi2jbdY8D4XO3wA0Oi+HGiO4+UlzQwVEVKD?=
 =?us-ascii?Q?PT+1QbjDqoUHsHl32V4uADn/ePiXOyUl99AzXkd1XUuMuTbG7x4/YCAH2LYX?=
 =?us-ascii?Q?2jH0YZ6Qj1slKTP0LkleRUeoG1dgPU1gtGsGM8tBu9m8773kMbWGvasXVr2n?=
 =?us-ascii?Q?ERFY2eOmE5nuRXipKz9/YLYawesluIAYQCWcKckiPRCpTlW9CH46W5fgIH7d?=
 =?us-ascii?Q?nX/2Jkyr+DUxx7NbxOJNpd9me/u6vK4ExmOXV9/xMbXS0/1A2HGNS4uQsguB?=
 =?us-ascii?Q?l3l/CjA92rvob8IAhBQeCDExfgY7Si/rFRFRxe7WK47bR4/R4jRZ5y+Ko5TS?=
 =?us-ascii?Q?5El6hmkdGNxfyVxpMmE5GYx3g3CBn2wLrBP4yF6Aur0s/5Tqe+aGJWxPjffM?=
 =?us-ascii?Q?4rVsV05Fobde64bMSgjft5TfliDVb+tma5E8ovGFdeCUW5Hzja73qn+puwvd?=
 =?us-ascii?Q?BmwUQjSbjD8m5/Qm+eFOIILooIYwVzf9QORXlxhV1YdaPWEZcjkxrVEnEqCt?=
 =?us-ascii?Q?UiaxX8lKsMUaTDrVD8l3l0vWVqqpkQBaHoSjOMxyd2ae/FBWCdT9/aw8gNLL?=
 =?us-ascii?Q?RP9uaOwyot7l+xJUibEfK+0thlRAURiRaCvct/l6AZXdnhVWI3HUIWNugzRX?=
 =?us-ascii?Q?onKUcoXNbNLWb5ds1d+LK7cAxU/Z/fYWlfag4DZlxqz3JiVBS2dd3o/Iku14?=
 =?us-ascii?Q?4oefY6Jb+NDJnMs70bD3N7Q97hRrDaEfVlrTusTgz62bFW2B00gR40nbw/FM?=
 =?us-ascii?Q?2BFfPxfNZdmyUNyuXxiy5ZRPTQ7DxHG4q3IsijxseyZQ+ptxwAbr1RY8DSMf?=
 =?us-ascii?Q?rCvbzPO6FRbkyMLtfOt0/VDLXIJ0zNe8VLyWs9S0fV8Gimx+chgF/XsYcgjx?=
 =?us-ascii?Q?JwIwLUMGxxy3Q/CO2u5Jitb1Cga/z7cAzCql1LuO9OJl66gk+ul3djiyEwzw?=
 =?us-ascii?Q?0q9hmu7vrr8jKwNKfZusBV6eP2+bhteQac+Ura6yeXTvWvoogrB/823qCTjN?=
 =?us-ascii?Q?raP1py6lPYa+cmZmJlFBQKvl/Du5PfUTXhRR70yvNiXycPxcdsoQf0QcKkeu?=
 =?us-ascii?Q?cifm1eXdPeuWpe7x3sWe9DYWmCVmjLgdt5YurA3mfPT/5x4Cdvai9WQfupW6?=
 =?us-ascii?Q?yW/aLtNi2U7T7zsfpRhhmSL0xr+OP9GdsP/y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:39:14.1446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6104e799-f451-49ac-5291-08ddf7798a79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825

This patch series adds support for the AMD Versal Gen2 UFS, including:
- Device tree bindings and driver implementation.
- Secure read support for the secure retrieval of UFS calibration values.
- Vendor-specific interrupts support to the UFS core, enabling handling
  of interrupt bits that are not defined in UFSHCI specification,
  to avoid unhandled interrupts.

Ajay Neeli (1):
  firmware: xilinx: Add APIs for UFS PHY initialization

Izhar Ameer Shaikh (1):
  firmware: xilinx: Add support for secure read/write ioctl interface

Sai Krishna Potthuri (3):
  dt-bindings: ufs: amd-versal2: Add support for AMD Versal Gen 2 UFS
    Host Controller
  ufs: core: Add vendor specific ops to handle interrupts
  ufs: amd-versal2: Add AMD Versal Gen 2 UFS support

 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   |  61 +++
 MAINTAINERS                                        |   7 +
 drivers/firmware/xilinx/Makefile                   |   2 +-
 drivers/firmware/xilinx/zynqmp-ufs.c               | 118 +++++
 drivers/firmware/xilinx/zynqmp.c                   |  46 ++
 drivers/ufs/core/ufshcd-priv.h                     |   8 +
 drivers/ufs/core/ufshcd.c                          |   3 +
 drivers/ufs/host/Kconfig                           |  13 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-amd-versal2.c                 | 589 +++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h                      |  49 ++
 drivers/ufs/host/ufshci-dwc.h                      |   5 +
 include/linux/firmware/xlnx-zynqmp-ufs.h           |  38 ++
 include/linux/firmware/xlnx-zynqmp.h               |  16 +
 include/ufs/ufshcd.h                               |   2 +
 include/ufs/ufshci.h                               |   3 +
 include/ufs/unipro.h                               |   1 +
 17 files changed, 961 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
 create mode 100644 drivers/firmware/xilinx/zynqmp-ufs.c
 create mode 100644 drivers/ufs/host/ufs-amd-versal2.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-ufs.h

-- 
1.8.3.1

