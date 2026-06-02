Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6112BD5B4;
	Tue,  2 Jun 2026 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780394555; cv=fail; b=QA/42tT6IpQUs3flE1RNrHl+KdnK9Rs85RI30aAyddGfr5CqYZuyV0iuoptMny32OudCpb/bmq3IrXBVDArKIFdOZNBZy66F+qKTi32pWtMRDj3rCVtPV6y+bRSYDo5bR+TIMkx90JtPJ7tuBqi+y+1ICkQ+iKDdj7ryTXxMCWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780394555; c=relaxed/simple;
	bh=SbDY3qIX6WG6xnLHrFl+sqKLNck1jUmujxgTBdIuEZ0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R/LfPwRV1KjhPCLPfbo+zG1w2U/QtEXAiqRjYja5Lsyv6hLQN31a1TQFpdXsejH3QNHF6ZqZkI79z/kSn5fg9XgLUnAfNAfJhGSKEhHcpBAA2lQxqz0aTGmVSC2ndXz0yMjz+ZFoQPnfrS2/lnLkKSbSnhfIiVSsK2x9+BlLmYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t5ZRiB3g; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t5ZRiB3g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVA1vtyqLPqsMzjotgeEWO7ebxILV83i1SDEYyVN5N+hMEMWnO7NfvrGGW/BZEZGsbVl2ZYo0Cs1XQ/xVaoyKVq1uX4omgB5i/QpS/KOWPeTwTKVTpCcrwAxkwovaLa58dz8s2EmESSDZpNOiHrgT51QTsLLlDAlM+Ukdv9bSuNVMJeMBFtAsp5NQqHjTzywNi5TRRo26K1Uxw5uK9va50NJWgirfc/60uXmANG2pUd9HwCo3rL3rh5HqN3qopX9Zib94pvCsIzwOpeWtbS3GD2rbPG9QlCryEHGVMfILNnQUaXG8ijs/ed6eh6URWJF1jKnm1DxViODxfsQgej0Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdWKccGUwQmqzh9XVOYwBEGo1wTGkxu2ArHx5wuwZl0=;
 b=t2RXbeFpUOrl/1Sv56uK1hOQ1+N9gaNWNyBwm1JD1v9kryYGMVDH0RqGenMijr7ZVGs4GPZYHcroVMV6HTfX6J+9F4VorVG4DCpA1m8/ZbLSd50DrwZQG9U9Mm83fADqNK79p+wU2XsaBf/ZJZiScvIy/xPGW7R53j3VSSg1oL+XmEi4tIQIpgnC6HfUJkWnQrpLu6+qwWA0prTpjIrxe7qZC9PsLxNePwubqflceNMjCrs+1vanUHrFj5NYtiS0Tgqmv6855CEySU72scfJhYskDh/eFUXHh/p/9qE96yIftRxtsuzuFeNIVs7U7e092SJlWpvwqZs7LSe7CLO7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=hansenpartnership.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdWKccGUwQmqzh9XVOYwBEGo1wTGkxu2ArHx5wuwZl0=;
 b=t5ZRiB3gsS+Bg+K14AJlrU3+0ihW5+0tTyVCyCawh242QHYMGMIRdhGS/VeDO/WbUMdU1kpSc3IZsMk85oufunqbhSdU7w27Ay7eNsb07//hNJ7HxkzMJ2aHTM02Z+YahZW714zdbuYKWGym1FTaGY4+ocPEBUcRfJXU6+Vo6eM=
Received: from PH8PR15CA0002.namprd15.prod.outlook.com (2603:10b6:510:2d2::29)
 by DS0PR12MB7703.namprd12.prod.outlook.com (2603:10b6:8:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 10:02:29 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::5b) by PH8PR15CA0002.outlook.office365.com
 (2603:10b6:510:2d2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Tue, 2
 Jun 2026 10:02:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 10:02:28 +0000
Received: from airavat.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 05:02:25 -0500
From: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <adrian.hunter@intel.com>, <archana.patni@intel.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
Subject: [PATCH v2] scsi: ufs: ufs-pci: Add AMD device ID support
Date: Tue, 2 Jun 2026 15:29:31 +0530
Message-ID: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|DS0PR12MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4cf779-155f-4655-78c3-08dec08e0de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700016|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Ig9xZJnCeUrsfm9WNKz/D+kX51rAC+DIFumpPYZp85mjWdhIiwdsJbmXR2RGMVsIK93WCez3WOiRQqGRSYkTxQL7g1ZFvZgD/4MTFmeSi3UZmK+BN2KY5uI1TH5HYR9J3yIODgNi+8hScV+I1XFaKnNSM7wZ08sbTIRgardAR7itZANwD2zm92kvxhLddKDPgV9Fa/afA8D0fwJLgR4rvHWED6G9/NQj/qC/ut+jd99W7A3X71xvFIiWJfUyo1D3dAdF674/yqX4GU1TZtS6mP6QrOf+BS/Y9vLGTN1lJtECC2MMl9l/iyZuu5NboZY96CHRQGGjrApPiGCpCGFXPdMP9Zzk2QSwH7VeM/1ppPVwvBYFcsKh1Hf/XtLZuHNhyZXGoieUvSHeiIroMp0iGONsPTk5wl7Hi+4vUt1NiyDBgSzC9pdIvBeR0UtuHe3tcRLKWCz/VV3IoqR5xrlCmgrOCJrqUdlqVaUlzW7phqKmBZNukCH884BI+kgRG6Zub9CKKYE/5ZgQ/yaZSjyCsYcPFpRWH2nUuuDsq+X9L0Ihbc9VU7z7XUJJ0hmXiIZdLeoM80+o4GbJBgQmQPFdlWpXqjNdtDIo/Tl+xXUn2hQ9tt0uE/VjJt4UHIiqC4YPvLQKUYuaazt+hUiPSqJjzXwbpPydBJpUx1V9YR6hmBaoHdZ+BkOHb4O1opJd1axjdTmeiI67KN0JrZSzY4QrcHw3zmVQLCTtzLBcLaK2YK4=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700016)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/GXbcXhQn7RJU1JbWWprkFTk+o/VJYzgGZTNsNPvM9Kam/RQlZR9nKtZed7FsWAzGRVqnbxBQqh9ukGaGjWxSeLqMIGtbm3VdYT+5hutpzipYTJPHBnwxVP2bGR8SI/x7DwT+zFR7VqhSYF2PTi03H1h48rylAAjdxHxg+y6SsKqrVzhn/e/3SD2nm6RHdFsHEZnfJ0Oif4yCs2DCgrsvqBkCrSPGs/sxVNcLsMc3Dj7qqHKbTwfu05NfSIk2udJDOqx4grDiVjA5yLKYpVTte256o8lBmdgaf8IhIZW+j3Vx2huHdw8jXO4Lj0L53EbL8v8wGBMRwaQ5xu1HmuhXE72WN1jmjJYeX/LL+Ss9m6ckIU5CIfjl558EDg0a4mAlqQdb0lLtB5ifJ4rTLqoJwFxNbwO7Oyj7tyeaGjgsNsr33ThgiVAtcDmlD5W2+JK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 10:02:28.3666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4cf779-155f-4655-78c3-08dec08e0de6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7703

Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.

Signed-off-by: Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
---

v2:
 - Use PCI_VDEVICE to match other entries in the ufshcd_pci_tbl array.

 drivers/ufs/host/ufshcd-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 13293e83064c..f2433879b0eb 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -694,6 +694,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0xE447), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4D47), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0xD335), .driver_data = (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
+	{ PCI_VDEVICE(AMD, 0x1B29), .driver_data = 0 },
 	{ }	/* terminate list */
 };
 
-- 
2.34.1

