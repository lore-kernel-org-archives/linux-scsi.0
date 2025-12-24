Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010022.outbound.protection.outlook.com [40.93.198.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B67C2D7DE8;
	Wed, 24 Dec 2025 05:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766554804; cv=fail; b=bKWNlmHjlaw9oFtudyKfZug+V3dAIk8A/9uY2mUU4Xh9Yn027o9DtkMB6Hv30/A7CXmGLzNCV2xpGSYIZeLMSw3mFn0rl3Ui7dkMyZHWcKDYYpm8+xVy8fnwr4i6h3OeWdpU5SM/GteYn4uAmDCuckCPPTotFK85EksZmCuBIyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766554804; c=relaxed/simple;
	bh=JSgSC9aAcEfCycBLbrO83HzxDQGVEe0Of15YGqFVl0M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SITotFOrXVG93ux+fUI7fAFIqXDdS6LC1hJwmN0OaEvlCBXLOtXf7ps5veQ6QTZQUGcGBZ1Wq/Zwpncm/QatMfiEmZC1gw+O/nHGIrv2nBav8Mb+6wYihm6vq4yfNy1Gf6jKIWQtd0COsy+uJ/mAjS93YLxAXP7Lwh8ImsC85Kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2tG8i8M7; arc=fail smtp.client-ip=40.93.198.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2tG8i8M7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hs9QGzxQpYGxWMYDgw1UiwxVExysKmn9WjUrra1VWvPoNIpNnMLwYr90eEzMLhuIYRDdq7RUq6IIBVuxh7EIQVTyjKSc4MI8PVgFkmPfkvCZI2oVcSEu5Wsnn+e1J1rehYv5u4Q7rlabPfN7OvO9XQz7qRXMlqwQUDTaaYJNx12gBPZnizEx8HIm4E9Fw/JpJ1VUdyy+fwrk9Wmxgta3kFSqI7EJi85cWBoxHBuIr14JPubpV9KS8MygS4oFsPULr9dwDSK44ZSgiaucI4gF17DezPGRu5d2bao0pbRwxtIL+EMSZQ31b6EvIuEhYqd17U4fREAqltO7oP0MX9yF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kl0crvpOe33VMsYhNLMdpexGN8bUifhUlSz/dfcorx8=;
 b=ptTEaSCyL/TxqSBNRNHSqVf4TUrElDra4lzbSzpy1xQiF5s02hEPi86RKFJ6ZvY+OnsfMB4o4FfGyYeSDFnDZR4iTwPNnAin8DjLfL3b9No3yIU6UJST6nmKw5B9+aDvXuwG4n7epUqCoeyM1YYO4AJ95jUnATNabajBe2A247xd3X+fr5Mf1knlJUbSgY0dH+TLQd5E5FRz666FRVki3b6XadTxEdxUbos4toO3KoSIN6d/78+6wMsI2PB68CDwrbJRnO5ySwwwIbfEEzTGGu+lreQEImWJzXNH5OUE982L03x5TwW+UsDohMe+xqdMnxt2HUYLwyrSXx9XUPy+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl0crvpOe33VMsYhNLMdpexGN8bUifhUlSz/dfcorx8=;
 b=2tG8i8M7Mo8l4bgspO9E3AVG768bNZWk41BNz6xk/iYTK0C55QONq49bsDJQx6OqltmadBw03+jknZ+BNR/xB6k2KEwC9svgd1EjSP5X4TA+8PIDB0GL5ZgHOcd8R0QT4aFZ8T7djvnBVGTxuQwNzOi3feFvpEXsMu1wcOIBzio=
Received: from BYAPR02CA0030.namprd02.prod.outlook.com (2603:10b6:a02:ee::43)
 by CY1PR12MB9650.namprd12.prod.outlook.com (2603:10b6:930:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Wed, 24 Dec
 2025 05:39:57 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a02:ee:cafe::e9) by BYAPR02CA0030.outlook.office365.com
 (2603:10b6:a02:ee::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.10 via Frontend Transport; Wed,
 24 Dec 2025 05:39:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Wed, 24 Dec 2025 05:39:57 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 23 Dec
 2025 23:39:56 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 23 Dec
 2025 23:39:54 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 23 Dec 2025 23:39:52 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<git@amd.com>, <sai.krishna.potthuri@amd.com>, <michal.simek@amd.com>,
	<srinivas.goud@amd.com>, <radhey.shyam.pandey@amd.com>, Ajay Neeli
	<ajay.neeli@amd.com>
Subject: [PATCH] scsi: ufs: amd-versal2: Fix PHY initialization in HCE enable notify
Date: Wed, 24 Dec 2025 11:09:50 +0530
Message-ID: <20251224053950.54213-1-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: ajay.neeli@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|CY1PR12MB9650:EE_
X-MS-Office365-Filtering-Correlation-Id: c983dca5-be62-4692-a1db-08de42aedf62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BccV1QjTtdzIUvXV87wHsQ64uu2sppOiqZzacoqLdH5xwTMUHerkke3qSWlD?=
 =?us-ascii?Q?N5ivOU6/gchJ6WAzPDb808Q2Z2Q7kL6HEyyhob7QVW3o2GGEll0UYP9jdF+o?=
 =?us-ascii?Q?3BSN81Z412PZbTkrWlngIK29fU6NUU/ehyQnmIGhDgmcXvQWn1PiIAFiCdoN?=
 =?us-ascii?Q?JXg8nLPvxYqM9b3eFEk3MKOVh1unD38cX+gjSlnlrVs22rQaDoHMV79jqhUb?=
 =?us-ascii?Q?qJg/kRAPYOo8wW4ITM0dj6mqXAAsJOy75SysNErCtVvls5Y6omOu8GZIN/WD?=
 =?us-ascii?Q?RTk3bzNzmKCSU9Xdk2ifE6uC5lk+8D+t1+oZ46r4Cl+WWfAI1AnEBgMMuUD2?=
 =?us-ascii?Q?04ihUbY6Q7PDUuVAZXZ6YweKWE7oZ+/OWnvJb/vxDRkedImqejkhRJupE2IQ?=
 =?us-ascii?Q?ds+jkODGq6FHkK6f6D6QBrr80f3BcsbwpTg7LNVCFEDJpN5jecDi8q6/A/sJ?=
 =?us-ascii?Q?d5ns0s1KmpT8819P6z4J3TM72Ljbvw9HCR7lJ0CfsZ12LFS80zxmpAsv57ft?=
 =?us-ascii?Q?6ofjvJlguyMqfusCQn1paNhremu4Qak6jB0uiD4sRDAyVCzARcI2+Sd/gGfE?=
 =?us-ascii?Q?U8WTdV6UBPw6pEamxgCrBZqWLa5fBPq1bEBiOgtvKFFRopQypeBt+MN5AbXD?=
 =?us-ascii?Q?cF42wix1WBbs3Hek23f3r0ynvrQzmw9twqsM6Cklze8W2Ukb7lef9L+BHF6g?=
 =?us-ascii?Q?ilAKZ57AtCnYQBQkW128cdJwKIgio2vX9yoouLLezLE3F/ykXFwZKcsMOpxt?=
 =?us-ascii?Q?L5yon0Hb6EPhhWoqp4xN5/hDHRHhG5tRhdA0u61WSIxTkkxPn6+c71SWzaZm?=
 =?us-ascii?Q?+WRSa1iGowYOlKUK1IxkjLLJTmggmU/HHK9fTlXuGgCGV7Po5b4ZX6x3GLJS?=
 =?us-ascii?Q?PGPh4K6x1Wwizo6vPOlp53QARVJ3fWu34270MoB1dPKEjtcFRiyFzYINBZei?=
 =?us-ascii?Q?MYwpJT4bhdjnBfgRLM0Y/XlWOySgyOIIxvgI7sIS0xdX3v5fSKJQXcmXEW1E?=
 =?us-ascii?Q?2H20z5MEgKfNfBw460tn0+yPSfp4Bi3NHmJcriFJBAxU43hvTD1ofh9Ho6bU?=
 =?us-ascii?Q?M82BT2Rwfh9jjD1L1bFxhS2e7ucJQZWctFR4kcXZyi2E4Kz9RNLC0DHkDJCC?=
 =?us-ascii?Q?j7ibd41W5rdturvPLYSVJV+lICa7OV0PL/7RG0NxT8uHkcZmWE72Y+AXYjv2?=
 =?us-ascii?Q?LftlaxsIJovZiF8k5pJJ/dTXoIezLIH3Ezs+23Ct6a1t3bz3pDcGVxr/J1YS?=
 =?us-ascii?Q?wKIKqRkCD6T4rglCBtR/HXIe8VO457LDkOBr5DtytGf4VGIZUUI7QexLwQGk?=
 =?us-ascii?Q?TRAtgXAhhJX5KnRkGKcybbSUkQY0+tj6ha3oV0x2D/3CV4aoF99oMg2ZQ2Ui?=
 =?us-ascii?Q?ICDKknBbcv0j60Nh41kDUY0EDNwPKMKIe6Kx/Ije07SFUMYyJ5C3QBQ32v5z?=
 =?us-ascii?Q?ZRxEccJ7R8Lyl6Wo723Gad6kIpev11Y+uAkrPd2u9nKXl5IyzyYLiHhRTSCZ?=
 =?us-ascii?Q?v+PSCAfM2VSTMu1GzAr6r8HOljtfKs+3rF4Vi40Z8/EVowBwN5mZYE55jhkP?=
 =?us-ascii?Q?l3HRhODxWTkhyHIG1jk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 05:39:57.1370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c983dca5-be62-4692-a1db-08de42aedf62
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9650

Move the PHY initialization from PRE_CHANGE to POST_CHANGE in the
ufs_versal2_hce_enable_notify() callback. This ensures that the PHY
is initialized after the host controller enable sequence is complete,
rather than before it starts.

The PHY initialization requires the UFS host controller to be in a
stable enabled state to properly configure the MPHY registers. Moving
this to POST_CHANGE aligns with the expected initialization order and
prevents potential timing issues during controller startup.

Fixes: 769b8b2ffded ("scsi: ufs: amd-versal2: Add UFS support for AMD Versal Gen 2 SoC")
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 40543db621a1..6c454ae8a9c8 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -367,7 +367,7 @@ static int ufs_versal2_hce_enable_notify(struct ufs_hba *hba,
 {
 	int ret = 0;
 
-	if (status == PRE_CHANGE) {
+	if (status == POST_CHANGE) {
 		ret = ufs_versal2_phy_init(hba);
 		if (ret)
 			dev_err(hba->dev, "Phy init failed (%d)\n", ret);
-- 
2.43.0

