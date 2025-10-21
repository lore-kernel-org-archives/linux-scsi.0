Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C56628506F;
	Tue, 21 Oct 2025 11:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046247; cv=fail; b=cGC7rRGX23UTvjLzb22Z1S4edeXraBLnsJnQwuzI1lXxJ9MQB2b0M/G4jNVNB4xpJLP0XXHFtEHT1K0aBGjaafp9LXBDzGCPYzKregv78ZNwcKawTW8Bb+aZcaymfLVhTbPl1SSAXUoV1+f1tStcYwG0fdfHG6YHLvyhl/6zTBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046247; c=relaxed/simple;
	bh=CCG3b0adVNDKaXbPzyeO6VmEoCOnBRspd/x7eGpal64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MarH2ftGOupEwpznp/hphAbxBDvXoIoZhBVrpc3BgjBadXvEvzYXWoGQ1bhIbLQbItRUqNun25PENKOYDAdbTUPjn0y4xvBh/L28ZL1+j7iNX3cp4DJYgiSIXL8453/5TvlpXOih/eKz6PoFf5M11/8IFtMqfHH4z/SawubTibo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d2VTMo12; arc=fail smtp.client-ip=52.101.43.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d2VTMo12"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aw5OyqzWzGQb89za2ediVPr7I1sHf/Ar9tZciaTTEuBbjYa/EbdmgnhSTR3oQ14kB9mn2/9Nf2D0vhU/qjbPMkQgdIRBw6ehe5fAsYozAWU7vbKRowgD8gYYEf7kOdEVmO75aQMN4Mkye+ckJUYguiUgUZQQBONkW5RT3jkLNNpLesA0oD9yNNoNGuh56Z31bj97mlx3BDXqZG0XT/mK39ZXng1kwbVQWLkoP133H1nXB7zvvrUb6rEuSzfbA/X7nB48Q5sRXUdzSHmpEzIq7TVMjreT3tuFgx+hB2q5Lkjf7i+NkNFkU4Xq1kRoby7lIKnTOEe/aYZZ2BkpXw7YUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHwLAiDJRg4E6DQ6mIJ9fpsy/JroUCYkDJZ9Oqzi/MY=;
 b=n/tc6O71wiK/J8WMHUb9Cwe3Q5k1kl/dXnzMAJMj4lbZUBRZ/mGU7blN7AfVkSaqbNn3eVhZqXE9GWWCkF2C4T1g4paW8wznTxS0VQtty5VLUhMJph2VtIb2+R+j5MGHu10ZdWAgWKRr3KGyzgjZfvGAuqEYkAEt1qF60WJTc+Pjlnm6+aqOzcCgg0bYX7f9mAOTWhQZ+K76osKwPDWCREvF3JA1PO4KNCbBs1DmbR550kKr4qK2ZuHC3lHMWNtJkk9fclBenWchx2wWPEmZcoOvP+dIIOcZlrQyvC98+RWg7nX5Q1QioCvWse2gT7Hpqgx51fwtZ9oy3CXEd482aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHwLAiDJRg4E6DQ6mIJ9fpsy/JroUCYkDJZ9Oqzi/MY=;
 b=d2VTMo12mpK9VQ1Ljkcah6WQ753Qtql4vrveX3qHCqouZKSLrsHLGakrpakp7Qc3GmwmKRgmGJfCZaZsuYEyoFf21PS/tTtZHQwT+n8YFb4TczUZ8aAYPr0b5+0lz+3zE8jLimIKPcru1ebPLlx0RTlK3mIgZz1uBSf0NfmB5qA=
Received: from MW2PR16CA0012.namprd16.prod.outlook.com (2603:10b6:907::25) by
 SA1PR12MB7200.namprd12.prod.outlook.com (2603:10b6:806:2bb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.17; Tue, 21 Oct 2025 11:30:41 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:907:0:cafe::dc) by MW2PR16CA0012.outlook.office365.com
 (2603:10b6:907::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.16 via Frontend Transport; Tue,
 21 Oct 2025 11:30:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 11:30:41 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:21 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Oct
 2025 06:30:19 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Oct 2025 04:30:15 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Izhar Ameer Shaikh
	<izhar.ameer.shaikh@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v2 2/4] firmware: xilinx: Add support for secure read/write ioctl interface
Date: Tue, 21 Oct 2025 17:00:01 +0530
Message-ID: <20251021113003.13650-3-ajay.neeli@amd.com>
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
Received-SPF: None (SATLEXMB05.amd.com: ajay.neeli@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|SA1PR12MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d65ced2-f147-4375-f797-08de10954430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7ynLkag6TZczyzrVW0nff5bMLsIckHYMn/sibaazBx1o4sfWZ7DDVrPF0bJ3?=
 =?us-ascii?Q?HceLeucr/a6hRBBR42kHKP8ESqz4ca0phBL54FSpau3TAAYYxrZNGPRl6X/B?=
 =?us-ascii?Q?kH0txEXavx29UthX9A8Z2qb53Of6WDdn4L5KIPL6PgYvUtrAuwuiYSs3UCpo?=
 =?us-ascii?Q?XL+CxkVvQDhXwVm/rtUnWXejCVnyb6ZVVT7C64GO9mtAZSakBjW4o/cUe/DJ?=
 =?us-ascii?Q?YUd3AJ1GjDEPivAlFjP/FB7shFpDboPmQ8f1gwYKUPx3/wKho9crLLE4mH4m?=
 =?us-ascii?Q?7xkUtMjczmMCuSuYdNqe5AF9m37184Ewi/PZ/sPIzNjyrzbba4t9vGtHmPqV?=
 =?us-ascii?Q?veXtHcwyjE6xJSJ3PWgzAblAxrvBH3P3avjH/2B8j82M4kOYeEzMjTqq8M29?=
 =?us-ascii?Q?393FtPSNH2+Qr7+Le8qESFjeRsRjDL7y9K06QQ30WDLKTsY68KfLcLYD+aI+?=
 =?us-ascii?Q?CuwKepcZ/qm4XNzCZHQ8oFfAjELyjQKpl0DMlz2+iQc30KQXKMpEw+fU4Bly?=
 =?us-ascii?Q?MXWx6/G4c6mtFX5BVYxBIj3TT/nvebehLCQvjhbULI6YpgQ4aYND2zAWfZEs?=
 =?us-ascii?Q?eEW68J9TkUDVqHKKzDhtXFBh2lzRGc7+j5IkvzrQucWlAvtL3vCKkrGRubUS?=
 =?us-ascii?Q?lH2hfvb+9WrewxSf7gSLgseg9bzEKfmRF/7DUH5bmpv3poKyBKjfozmiDVeK?=
 =?us-ascii?Q?zB3ltLNHkMXApY1EbIJWYJ9J2JnPaLNHyQdS3b5BH4njPcAyj4fCCpVS/Km5?=
 =?us-ascii?Q?pav1kUX8sosiNDOqKOg422J9dECC2gBMesneKBuFRDfbmD9YrsgSsiKE76ZK?=
 =?us-ascii?Q?wxrTlyskfhJVRLODA653oTIlQHKu8nNopHGn4fyonwsL9uvUBoGD/DGCqaoB?=
 =?us-ascii?Q?1nyjW5NJU4AP+y3SRsy8NDXJXgEi+Fu61GrWm4c0v7wks73dwrB3SEAir695?=
 =?us-ascii?Q?T1a1+oDIxt0lmzzTNWv+YB+iKk8zdwCGkWoCvfn5IFAlnf3DFjh6+ua5+gdd?=
 =?us-ascii?Q?H0NiLIFtyx2DaVlBb/HcR2fR/l62DVT46972VdYTAIcMuOlYhwYSwFup421S?=
 =?us-ascii?Q?9AeG95Y06spf/Yf7y+vqh7MLO42gWvd72Mb3ij7AbP+sRjVa3fxyIwbcak0D?=
 =?us-ascii?Q?iE78EelwzLzKCD+SdjDVfF4g8KpaMgEtMYZIaDBShlZqn+A5g4uTrVtBiBVo?=
 =?us-ascii?Q?sh26iWLUWUKAnj7HRdKcs69PtlrhnJc9e2r5F2KJcZ40rPYOePHaSerL3kWJ?=
 =?us-ascii?Q?KLD0OhxuFOGrPxLRSpycqrkqeITPNb/LDFx1opLT/eADjP4cT7jNeolYwIqF?=
 =?us-ascii?Q?O4dDsJk8Db2aOzkmR9bXSzg/nDSyErfwztpvtDaVD+hOpEAwf7M9HbJzemEd?=
 =?us-ascii?Q?sokj1Y5fPksiFsiARNm+vElZDFbQuLiuoqDpSwywOyzvZCVB/tXwzFABWW+I?=
 =?us-ascii?Q?XJAxH4OVdTmISzorTUhF1TwvY83QKTlky9rKSs3izA+9D10MDu6w6STtQXXH?=
 =?us-ascii?Q?vf6pOdeIkCgtteNbsyLGX90S1UUJtlm8S5l9m5I/pQ9O7ziRN0rzNNV/Ft+b?=
 =?us-ascii?Q?CHRMNdTmLCQWba0KSUE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 11:30:41.2087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d65ced2-f147-4375-f797-08de10954430
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7200

From: Izhar Ameer Shaikh <izhar.ameer.shaikh@amd.com>

Add support for a generic ioctl read/write interface using which users
can request firmware to perform read/write operations on a protected and
secure address space.

The functionality is introduced through the means of two new IOCTL IDs
which extend the existing PM_IOCTL EEMI API:
 - IOCTL_READ_REG
 - IOCTL_MASK_WRITE_REG

The caller only passes the node id of the given device and an offset.
The base address is not exposed to the caller and internally retrieved
by the firmware. Firmware will enforce an access policy on the incoming
read/write request.

Signed-off-by: Izhar Ameer Shaikh <izhar.ameer.shaikh@amd.com>
Reviewed-by: Tanmay Shah <tanmay.shah@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
Acked-by: Senthil Nathan Thangaraj <senthilnathan.thangaraj@amd.com>
---
Changes in v1->v2: None
---
 drivers/firmware/xilinx/zynqmp.c     | 46 ++++++++++++++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h | 15 ++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 7356e86..2422922 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1617,6 +1617,52 @@ int zynqmp_pm_get_feature_config(enum pm_feature_config_id id,
 }
 
 /**
+ * zynqmp_pm_sec_read_reg - PM call to securely read from given offset
+ *		of the node
+ * @node_id:	Node Id of the device
+ * @offset:	Offset to be used (20-bit)
+ * @ret_value:	Output data read from the given offset after
+ *		firmware access policy is successfully enforced
+ *
+ * Return:	Returns 0 on success or error value on failure
+ */
+int zynqmp_pm_sec_read_reg(u32 node_id, u32 offset, u32 *ret_value)
+{
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	u32 count = 1;
+	int ret;
+
+	if (!ret_value)
+		return -EINVAL;
+
+	ret = zynqmp_pm_invoke_fn(PM_IOCTL, ret_payload, 4, node_id, IOCTL_READ_REG,
+				  offset, count);
+
+	*ret_value = ret_payload[1];
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_sec_read_reg);
+
+/**
+ * zynqmp_pm_sec_mask_write_reg - PM call to securely write to given offset
+ *		of the node
+ * @node_id:	Node Id of the device
+ * @offset:	Offset to be used (20-bit)
+ * @mask:	Mask to be used
+ * @value:	Value to be written
+ *
+ * Return:	Returns 0 on success or error value on failure
+ */
+int zynqmp_pm_sec_mask_write_reg(const u32 node_id, const u32 offset, u32 mask,
+				 u32 value)
+{
+	return zynqmp_pm_invoke_fn(PM_IOCTL, NULL, 5, node_id, IOCTL_MASK_WRITE_REG,
+				   offset, mask, value);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_sec_mask_write_reg);
+
+/**
  * zynqmp_pm_set_sd_config - PM call to set value of SD config registers
  * @node:	SD node ID
  * @config:	The config type of SD registers
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 6d4dbc1..f441eea 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -241,6 +241,7 @@ enum pm_ioctl_id {
 	IOCTL_GET_FEATURE_CONFIG = 27,
 	/* IOCTL for Secure Read/Write Interface */
 	IOCTL_READ_REG = 28,
+	IOCTL_MASK_WRITE_REG = 29,
 	/* Dynamic SD/GEM configuration */
 	IOCTL_SET_SD_CONFIG = 30,
 	IOCTL_SET_GEM_CONFIG = 31,
@@ -620,6 +621,9 @@ int zynqmp_pm_register_notifier(const u32 node, const u32 event,
 int zynqmp_pm_is_function_supported(const u32 api_id, const u32 id);
 int zynqmp_pm_set_feature_config(enum pm_feature_config_id id, u32 value);
 int zynqmp_pm_get_feature_config(enum pm_feature_config_id id, u32 *payload);
+int zynqmp_pm_sec_read_reg(u32 node_id, u32 offset, u32 *ret_value);
+int zynqmp_pm_sec_mask_write_reg(const u32 node_id, const u32 offset,
+				 u32 mask, u32 value);
 int zynqmp_pm_register_sgi(u32 sgi_num, u32 reset);
 int zynqmp_pm_force_pwrdwn(const u32 target,
 			   const enum zynqmp_pm_request_ack ack);
@@ -922,6 +926,17 @@ static inline int zynqmp_pm_request_wake(const u32 node,
 	return -ENODEV;
 }
 
+static inline int zynqmp_pm_sec_read_reg(u32 node_id, u32 offset, u32 *ret_value)
+{
+	return -ENODEV;
+}
+
+static inline int zynqmp_pm_sec_mask_write_reg(const u32 node_id, const u32 offset,
+					       u32 mask, u32 value)
+{
+	return -ENODEV;
+}
+
 static inline int zynqmp_pm_get_rpu_mode(u32 node_id, enum rpu_oper_mode *rpu_mode)
 {
 	return -ENODEV;
-- 
1.8.3.1

