Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012008.outbound.protection.outlook.com [40.107.209.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D57F1F03C9;
	Fri, 19 Sep 2025 12:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285568; cv=fail; b=J2tFv0NOZwFuOfxDRjLyI3Zqy3JIypAeiktiLFoeY/+l20Johz5ERAcjzDFHoogKaYIOZUVzUS3T5tVVaSk4pTqVP0TbT97VyXmTWpfConJeZrO2XKxK9RyUzNq9owi0bmiVwsmskK+oxeYDMmdzxoeWriS4kZp18/IrmarOkiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285568; c=relaxed/simple;
	bh=uP06c6mq5A9YOglf/0b/I1EU9dGXSAuqtLJE965/G+Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdEBzDti31fDvBCndXSr4NShFyurIAJxv9Y+JTISM90Za/iUjjK2QZiN1WofbtXYUy9+BqO8a1cyRlAiH3vfxElHJHiXmAb6qWRbA0I2Wh7pcKt86ZMo1U6KpMwulWKt7yVh99LEE6Cvrf6TzhgypmmmUuHhQByYR7B7pjZ0fYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nNLpclH6; arc=fail smtp.client-ip=40.107.209.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nNLpclH6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aK4YQyE58TVENA5wk4OOQuMJoan49o+spazyHavJESp/HzFQPlY4XBcQj5bqPxjRdUa/CoYBntQY+YAcshTsWvRzHU4PJ3ue8HgxwB0GotwzYG7sLciyXXwVRkxUZe4hgImKH2jEt4Uy68h2nignSCiXlrTKWSXh/IEWgGJWfpCGAwwK46T25Mja1PWN0HEmjxNJb2mdExbnHADcj/O6dD8q+Az14NhA1cfda6O0RVgkEAzAay4VoFV2iBPHRStfdYT5HA6JjNqeXETEVlkXjATUet3Tu+IoZ17DG81VU7B6zoVeSS4qL4EbhdKIcGV33UkahxPv9gZG7RdFNsv1jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HwuEX2TxXQ7K1ipLH9axZYQ++AauEm05TATAZ/jdq4=;
 b=GTfM2JbmNbzr8NvARjg6PXEICmSp8tI1iB0uWnv2kMplnaCaHNGtZqpYinbya6NWUtdYbMvDNPYmuhQvPwSNAxO3ndwsqy2JcvchSGMF2eCsHcf0LE8re6ZoAHlYhXneu64IUzeo6h6tr5j0rkVTgyhJlz0k/cCHAdy/20kI/qlEBFKOYfMb0LJiRqIyDzY/wu8NQkPnN9i5ym9lyWQK03ag6JK0N5sSBHgUQxte2bB1MJLMEa5qO9lKNEyWP4N+KQ2Nk8scgPcibajdnGj0LjCHuAl5vdldl50nbuScOOtWZX2nNJcDOoOT8Mgqq8ciPiLqkso+HIaCzVHcofkJow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HwuEX2TxXQ7K1ipLH9axZYQ++AauEm05TATAZ/jdq4=;
 b=nNLpclH6wooJ9JiGc3eSdBGWZI6IiAqZ3WNw354AgO7WLok1pT01v2KNhR4/bR7dssw1aP3OQ8WS2OQzMPkUqypuYXKCJszUqBgFNk79hbtWNyYxjKSm0qdtOcKxzJpgegrkyhjYy/nTNGRJhlX3wBXiYxrtCWMknbCoc0mppSw=
Received: from SJ0PR03CA0048.namprd03.prod.outlook.com (2603:10b6:a03:33e::23)
 by PH7PR12MB8425.namprd12.prod.outlook.com (2603:10b6:510:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 19 Sep
 2025 12:39:21 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33e:cafe::50) by SJ0PR03CA0048.outlook.office365.com
 (2603:10b6:a03:33e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Fri,
 19 Sep 2025 12:39:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 12:39:21 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:38:56 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:38:55 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 19 Sep 2025 05:38:50 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Izhar Ameer Shaikh
	<izhar.ameer.shaikh@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 2/5] firmware: xilinx: Add support for secure read/write ioctl interface
Date: Fri, 19 Sep 2025 18:08:32 +0530
Message-ID: <20250919123835.17899-3-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|PH7PR12MB8425:EE_
X-MS-Office365-Filtering-Correlation-Id: 10bd480d-f85d-4b2d-717e-08ddf7798e9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BNemHXunCeMxaRTcdY92srQhihmkoe7xFiBErlv81XJvrL846FZy5HR0aASf?=
 =?us-ascii?Q?xZxu4lvy3FG48Kk1u80GlT7t/QzYb8l7JPVuJa+O3P7CQfbCjW8nVyxKdGhx?=
 =?us-ascii?Q?2V6SsU7f0MgZzIZLeg+/7tCcJn+8wWnFS/lMdh/sGblzcMc9dknjWVGGYDQc?=
 =?us-ascii?Q?Oh3igDZd93Toou6tOGqja8w2Ti17zDmeu3vbbjKG83XtkpDwX5pNs6rZquxc?=
 =?us-ascii?Q?t1gotSPY7utEyQS3pKwNlp6+95NY6mIrYEoAm7bWW2tmHADiX2Vl22WdO8dM?=
 =?us-ascii?Q?/+j+WjSWDzhccbYrsAxO1yoyDgp/P94kc5okQOWi76dFIl1Hz+67qzohgq6p?=
 =?us-ascii?Q?SkUKfoOJDg5ZFjBu88nsfHde1rT4r4nJDgtOQho3P44dA295WYqvwWuKAYWl?=
 =?us-ascii?Q?hsxq4ZmuIQ/8i/Sl18H7ZDdj69+NcQvfo8Ox6KineC7Z57Qydfk8UuPHeVGe?=
 =?us-ascii?Q?U8GfgTsqwQMBWOo+xUzsVOQv+deVZsnGPlC+uvf+7k1gLajHZPGgdZkWXKYp?=
 =?us-ascii?Q?qZu7PZTv5ksxYdup5tfzBgi50w4cfWL5tDjrGBCMNEU+hM1kUaaBITQWCmz/?=
 =?us-ascii?Q?a2v0WU0+f2IkofXwTeoOW5yKfPdWFwPPTKsoqxtqDFPgD4zMs5ccJ5V/65ES?=
 =?us-ascii?Q?0mXeJYB5QbHOpqywG/CxbG/4D1s8zcD4uDO+nFDsrP/YKcDHmEJpMtXNxvHh?=
 =?us-ascii?Q?160WWNnhVpMfQre5KzF1xu/fqoxcs0d3mOjF31andS5+tDzp2vySQ/kfT67Z?=
 =?us-ascii?Q?LEd1gP3iW9FIRn1bZQ2N1si6Ni2KDzkZQrsawBdh8UuZLW7WTp0xBGGq5BFo?=
 =?us-ascii?Q?qjfcPozRxq3u+GXHpnsyo45arMCBJ0+hApKLIfW9+O9KKt61+F6vwgzFRdZd?=
 =?us-ascii?Q?y/Cc1BbJcrUehPCg7PuUENtqeBrAac1MDAPiCTgYZeGlrsZCmuCFypiKQQ+7?=
 =?us-ascii?Q?0wKxTYLpy5vNLYu+rji3Y4iSIHACAkEYs+4r2hhHAwrfAkAiG67Zb/rlFZxf?=
 =?us-ascii?Q?Zr+ENjm92spP1JXkcHUJC4MHradq28T1lOxlE51YzTA2TX7TipNuKOyGFvYy?=
 =?us-ascii?Q?tcdZRLMxIRedbFztNY0TGOVMt8rih8zOK17AJqkKXlRIEdzQImBaVc4j2Rsd?=
 =?us-ascii?Q?wp+kRwol0yoW/vatD7zP7pMi9GKgL9oxArtzyb7VXb1+wiUkCzmMv1Um7SSn?=
 =?us-ascii?Q?VT6YecAumkgMiE1NxeQUDhKVE3kIUUSz9EiSZaAB61pPOkZhuNfB22rHUImv?=
 =?us-ascii?Q?4B0mznaF+j+fsM37pMPZzTAHahdAt7Es1Rn+/5F4XezEQUHfsBWrkdTqvyBU?=
 =?us-ascii?Q?qQaEV4ya54YtMyuull2gJy/sL6/G7zZOC8SRhhnSvnyF7WwgOZGYmZgqAIxg?=
 =?us-ascii?Q?Zuwy5h55PF9e2pFsObwAgqV3fWJOW31oCtuLAcMoqnoSMxaDip8mlZ7stvna?=
 =?us-ascii?Q?AnL2OkXdDHzQT0QyQJ3QHf5m3iZ56NBqjYzP1pMp1a5OURYhYnMKWFixtybX?=
 =?us-ascii?Q?qkgHAQKNUOY5xhlZA/anLiYC6YTFXJw2ClPe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:39:21.0786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bd480d-f85d-4b2d-717e-08ddf7798e9b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8425

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

