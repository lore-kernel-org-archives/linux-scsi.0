Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012031.outbound.protection.outlook.com [40.107.200.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F087B1A9FAB;
	Fri, 19 Sep 2025 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285555; cv=fail; b=dSqUQr6YDdqxyKVo/NbLZRQ2OHzQq8xVBb9L+N/92K1qWKYLicnv9YqDz4uJS2UItaQ63OfTeuFFVx2hrxiIgBVNphKLfzI0OLhhiIWTlli68g+jyEUieHt/5vAzPzENbfswFsBrl63GgFSqXhF/ppsCrrJ2DhN4fkb67H43Ekg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285555; c=relaxed/simple;
	bh=/AW3NMn3JRqN62kE74aJeMgm+lmr71G7z5vUXa4y7KE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cH4OYciHCSe5tyQR2isd6WiPFlT9ePDmuLoFLVZLTAbVXUIn97azO2mDkbFo21Mep6znNsMq6NnRmMhbcDnb/s/Rp3Dhr3CjJZFe1+Kks524M76lRIJ/G8jj2o8BXESW1Q6t+D5pv3O8iqk55YaJXWWp0h7RIHmk2EW/IEUQsAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e7x9F2cs; arc=fail smtp.client-ip=40.107.200.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e7x9F2cs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nhFMwu4DpzRdffDzvfIvJA/ow2tWz0NeCmM0VZCVxznLuIXaZQ90fb20ic19z5fxe+2/+QJUJUuD25hyPZtZlAdtjZrrPnk7F0Uzw1l/oiyQyOwB93jzMTh1vexif7VW9nx8Bo4MAJ9oTwO0eJnjW5DWd9BAtbrecIXxPkbKBgS+n7NaC77MSNcjvNBt4xBzkZ9zFnjQ9hUlfYO7oLbLBiJkdCLtEDc3CLAKP+tvGpQ/r24MKvtOq9waqVfcq8YciK/x/GKg+P0Bpoe1wnf2e0TXyVB40qCfb5UNx5FF3020XUu9BzekMtDcYOVSwUssoce66ZPERrYIviMv/jKf4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SK7ingm9bxDO8cm2LYXoG9S/iwT8P/p+wggDJUs5ac=;
 b=nY9F5GVnmUBiz2m7VKnXzTKfnkjC0ZaDD8OyHjtHyjs+jpnVe85SPqB+JZ4t+QFG76Rp9kSabsFe1aQ3z3DYfeR94T2HXnNl0VbfrDJN0DyaYEx52p3fxdn8C5Sn2QVYv5mzF7nqxxptH2Fud7zkk9QiVbuOwja756P5pgQJmv6pF29AgFaycb6BaJpQ7P+6lmunzN0qv8lFwCJNCae5aArStpL5LPw9THoxzLiVOEHly+S4AgD+r85W/yZ+spcFBfC4hvGzjlTN+v4JoCypNtqh7IJTjm0DPaVkIM4gGg84C/eShyukFSh+6CMpV7t4pm3nB2+t9oxxkOPlVMmnPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SK7ingm9bxDO8cm2LYXoG9S/iwT8P/p+wggDJUs5ac=;
 b=e7x9F2csDCQYBlrxxs8u9NXaRiN6wUHlitktbGhdH1rt2tFo7zxTN9dCYNFcewOQPJeGidvEODitb4UOi622HHtHIWcn7h+cYOHNF8dqEThz5Olx+zuoKMw8IH+2O7ciGbRknL86e9GmTWM2qauPGuDt+R4YkMc0zRkND2xg6dI=
Received: from MW4P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::15)
 by DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 12:39:09 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:303:8b:cafe::2a) by MW4P221CA0010.outlook.office365.com
 (2603:10b6:303:8b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Fri,
 19 Sep 2025 12:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 12:39:08 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 19 Sep
 2025 05:39:08 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 19 Sep
 2025 07:39:06 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 19 Sep 2025 05:39:01 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 4/5] ufs: core: Add vendor specific ops to handle interrupts
Date: Fri, 19 Sep 2025 18:08:34 +0530
Message-ID: <20250919123835.17899-5-ajay.neeli@amd.com>
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
Received-SPF: None (SATLEXMB05.amd.com: ajay.neeli@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DM6PR12MB4234:EE_
X-MS-Office365-Filtering-Correlation-Id: 715e5d6f-7644-43a7-d0b2-08ddf7798750
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lx2osqy5975SnrdNSFmMBKqCEj9hI7py4eahW4o5jaicy3qaYuwjaYMocCu5?=
 =?us-ascii?Q?MhvpS34IKmYdrp6pBTVG52roerCFXQGjgcdZMkqHIr4PNAit+7Zi6xPBLuLN?=
 =?us-ascii?Q?9K5XHrmaSJS5SsE49G3MvHeu/HRzzt6IH/ocVPuXyQAxyrLA/gWoZg1n3R/o?=
 =?us-ascii?Q?VW+2bWxJRTApaxxPJZXD4YOJyeicKtKJqWjEvHhSZedKneuV8MEUAccoQzQx?=
 =?us-ascii?Q?ql+/O5ZS92frcThcMIbGMO+iyJ8VA3d85ibBAKRNCbjF0yh5ttTkPwCbq3aL?=
 =?us-ascii?Q?TcgpyNovkFkSvbu1vlM5fzh9nFXj9JrwIpbeX3T5MWeGoc+0KVqUAkqHONBb?=
 =?us-ascii?Q?bIGJV48ZGzY5qDfFhL2ubt7k61Xyjn644bhxGUKhj/GhyWAFf6PH0cbtVU2M?=
 =?us-ascii?Q?Ea3lgTCptUogiwZ5WTjyEb/kN6NPIj2uy5in7Q7TvZWMnTukiZgytHVTSy89?=
 =?us-ascii?Q?tcwf3QV1kjBdgYtMWVFinluwoH65lFHDS1v2VIedYxSIt97/SSqB2gDKwgLP?=
 =?us-ascii?Q?LAOvoHiSJEe04nuQGwaP5a3+v/iLfraa7DBwXVuZ6+0cqI/xlXKd8ow9jswz?=
 =?us-ascii?Q?K8LXS1TaRIvEKnarleVj5ft6YNn55s7sLDWTVY8H2CRgBujsSpYaoqXfhPNI?=
 =?us-ascii?Q?ERn5PI76teYf6ReCPMaVI7bw8WCKWwtc6kBi3xVAEtSb8NKH+tKfNy1ZQKs0?=
 =?us-ascii?Q?MTlsjcJS4tpc/5MRNLHfgk6dq9+4GNQqCXhHcpeeYSm9nk7bdmADXqpqPXIm?=
 =?us-ascii?Q?BdhTiLTCEzZxKAK1nbf+niFORjORVXVOooIB0vvaWqNykLUpU7S7NB/m1/yp?=
 =?us-ascii?Q?Xl6+AEqvpL0oRwFZQkPKBkDE7mRXDcR+BU0leLH7X7J+7id2KgNCHGL8FFpc?=
 =?us-ascii?Q?MknxoWBkb1dPLfBTzx5GllSdx5De0oy3rryOBskNIEDy2bX2pEJUvLgf00KS?=
 =?us-ascii?Q?70NWoJ6MOPLpWOmXzYdaR59KslSbUsuva1Ku5SuTb1xEMT3xbib/VoRBdKDh?=
 =?us-ascii?Q?pgH+2AdnJer4ynFQZ+cDs+j+F40gyn+WyDMiFawa1XJmXZdiOUBdwPqs4Eai?=
 =?us-ascii?Q?h0pbV3ZwrJK68RDVNJTnWAFhYakGczPDYxmDJpHU3FBoG/tLJNnsYFpvM8/+?=
 =?us-ascii?Q?ooClDkeNwdB85iOCBfT99rc+VLemhWwuciTPOhbkmwaHwKvzVwij7AGozCiV?=
 =?us-ascii?Q?3ifVToywEE0Tp2cZt8d7mlK2a0jgR5P6dQIsY3NrXxik7c4eVa6EX8gxF4+0?=
 =?us-ascii?Q?OUSqSZ36CRaED4BvEsnyV5Reo6Uv4HiDVDAYqTveB6uwN0MqnrNqsi1C9sFH?=
 =?us-ascii?Q?YC43YJHK4kflgsg++WVF97hXD5RKmC/w3zknG6g4AAKEozV459Nad94NYld9?=
 =?us-ascii?Q?7zND2v5wjd3LXDgcJmH6iNkQaDhJkK7FkcSdJ/D/x0FC2MZIzJzKP/u4++TJ?=
 =?us-ascii?Q?SqPmzeFWLacRpZ0kfy+vxZjTvmNUS95DlsEoGPLgcLpjtofKQuqopuW88cZ0?=
 =?us-ascii?Q?Y0d5y7UwzpNQKwkO03wKDXXkmox7Wt0dcS2T?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:39:08.9192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 715e5d6f-7644-43a7-d0b2-08ddf7798750
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4234

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

Some vendors will define their own interrupts, current interrupt service
routine handles only interrupts defined by the JEDEC standard.
Add provision to handle vendor specific interrupts by defining vendor
specific vops.

Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 drivers/ufs/core/ufshcd-priv.h | 8 ++++++++
 drivers/ufs/core/ufshcd.c      | 3 +++
 include/ufs/ufshcd.h           | 2 ++
 include/ufs/ufshci.h           | 3 +++
 4 files changed, 16 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index d0a2c96..04a31f0 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -118,6 +118,14 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
+static inline irqreturn_t ufshcd_vops_isr(struct ufs_hba *hba, u32 intr_status)
+{
+	if (hba->vops && hba->vops->isr)
+		return hba->vops->isr(hba, intr_status);
+
+	return 0;
+}
+
 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba, bool up,
 					       unsigned long target_freq,
 					       enum ufs_notify_change_status status)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5442bb8..7a6dde8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7069,6 +7069,9 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 	if (intr_status & MCQ_CQ_EVENT_STATUS)
 		retval |= ufshcd_handle_mcq_cq_events(hba);
 
+	if (intr_status & UFSHCD_VENDOR_IS_MASK)
+		retval |= ufshcd_vops_isr(hba, intr_status);
+
 	return retval;
 }
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d39437..64c958e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -337,6 +337,7 @@ struct ufs_pwr_mode_info {
  * @config_esi: called to config Event Specific Interrupt
  * @config_scsi_dev: called to configure SCSI device parameters
  * @freq_to_gear_speed: called to map clock frequency to the max supported gear speed
+ * @isr: called to handle vendor specific interrupts
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -386,6 +387,7 @@ struct ufs_hba_variant_ops {
 	int	(*config_esi)(struct ufs_hba *hba);
 	void	(*config_scsi_dev)(struct scsi_device *sdev);
 	u32	(*freq_to_gear_speed)(struct ufs_hba *hba, unsigned long freq);
+	irqreturn_t	(*isr)(struct ufs_hba *hba, u32 intr_status);
 };
 
 /* clock gating state  */
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 612500a..2844772 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -185,6 +185,9 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
 #define MCQ_CQ_EVENT_STATUS			0x100000
 
+/* Other than above mentioned bits are treated as Vendor specific status bits */
+#define UFSHCD_VENDOR_IS_MASK			0xFFE8F000
+
 #define UFSHCD_UIC_HIBERN8_MASK	(UIC_HIBERNATE_ENTER |\
 				UIC_HIBERNATE_EXIT)
 
-- 
1.8.3.1

