Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF8C2737E2;
	Tue,  5 Aug 2025 09:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754386431; cv=fail; b=Dio8cQTn46YSyLgmd+J8TFDmxL+IiIoH8OZQk4pFOsc7kcRjYB/wR+KCz94aV+r2j5qVjM8PKZ+bJK4roiCiE4mZ9G/Sdhk0LjzM+33p3bON4xJXRh9/uBWV8zL9ZrI5OWVKVe3y0x3XV5rBL/sEYl/ZVwkpwt0OHccAA6OO+uU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754386431; c=relaxed/simple;
	bh=MIHUKwI1eJsz9oKEBbnvM0AdzRku7RhYJgrZVPw2A2k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YVJA8/VrPUPMqZARmFgET+bZsRj10Ybml52h8Zh72X0uNkonjtVUcdKBfR5xY1AFN7gVv7Bijk3OuI8Nd7gJ/1NmUCEbLfvVpAfaSdLJqb+LkMzg64Vu+532dN4hj+mK39FTnkGDXFFExsuJS0wZ9noh4YdmRKQGoWkbvc5UDP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com; spf=pass smtp.mailfrom=axis.com; dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b=VwleFZQm; arc=fail smtp.client-ip=52.101.66.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=axis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=axis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=axis.com header.i=@axis.com header.b="VwleFZQm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOTmQcSt1WizT9dtdSHWiSWtbN58JgzZTyQ7UW3LF+hXZMZMm2Eslo1RU9j+IejLe7sqOR95GTTegBw9wb5bqx5I2klX3khJ0/iEfMVjjdHTTIB3dbDwMG4/HZLgexRZlfaFfFS7Izon9VkLfT7yneI5tyEggVmydTahn+tdaRNzzVgVBcXsEncI4O5ejW5n7WdJfRjzOXv3FdCovU7oBUoP2tdNQ/p1rXDnoByCoiOiVE+HyCB3oicZcIsemw7IMI/G7dsZ1Omx/fpCM9zC9NBLUIPlzvgiwNnrSjsyvY2/55bEhmexEYkbq7JqNjkkw93YoDwvB0UEEF5k8bNOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jReJgHAw8eH9muJAyVbXMkOoY/BaBqYpvjRV9Ufcq8=;
 b=H7tj75oL4mA0bSPE/ti3O57Y52fkDDzvCWUyZpF5phCMS0khpw8zSLYV8JWK1IP2HEKoU7qJ9pxcnBOxDIFzXfhEDPM10HlOqm+mrjtnT2EZV7PhBMnDQwlJWXuDRaSYcrmsDCUQHS/P6L2ThXuOaBAoKooMEM2ix6sGD+9pLl9wVovkK4Ag53aEZz6c0VMicUKCiNwyb5HvaelbmYJZYxmweA1SpYFpmVvTGeSGg+uSbY9MD3Xk9zfbpmHNLNCQrT7HLL12g5V+jO0+eQzcPPiw9Q+yfpZzj9qliH3ENwL18pqvLikOCrO4AIcTU9hb32AaS5L0T9f3Ht+BfkyOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 195.60.68.100) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=axis.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=axis.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axis.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jReJgHAw8eH9muJAyVbXMkOoY/BaBqYpvjRV9Ufcq8=;
 b=VwleFZQmsGRfqCK/Tbe5QZKX3LuQNhF5qNRx6KXKS7SWoh1MYeqkZEUy3Y6o5b6JNHnomhl8L9/6N8VMz5JTmMIyNDdAae7R+mRjMUinn+B+IZ0ao6by4mpZlW7SPTz920dGPHli0uuoSHIVBApDhw/BmqBFYwfKedNk3O+VLRo=
Received: from AS4PR09CA0005.eurprd09.prod.outlook.com (2603:10a6:20b:5e0::11)
 by AM9PR02MB6897.eurprd02.prod.outlook.com (2603:10a6:20b:267::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 09:33:47 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e0:cafe::ed) by AS4PR09CA0005.outlook.office365.com
 (2603:10a6:20b:5e0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.21 via Frontend Transport; Tue,
 5 Aug 2025 09:33:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 195.60.68.100)
 smtp.mailfrom=axis.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=axis.com;
Received-SPF: Pass (protection.outlook.com: domain of axis.com designates
 195.60.68.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=195.60.68.100; helo=mail.axis.com; pr=C
Received: from mail.axis.com (195.60.68.100) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Tue, 5 Aug 2025 09:33:47 +0000
Received: from pc52311-2249 (10.4.0.13) by se-mail01w.axis.com (10.20.40.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Tue, 5 Aug
 2025 11:33:36 +0200
From: Waqar Hameed <waqar.hameed@axis.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: <kernel@axis.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: ufs: core: Remove error print for
 devm_add_action_or_reset()
User-Agent: a.out
Date: Tue, 5 Aug 2025 11:33:36 +0200
Message-ID: <pndtt2mkt8v.a.out@axis.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: se-mail02w.axis.com (10.20.40.8) To se-mail01w.axis.com
 (10.20.40.7)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM3PEPF0000A791:EE_|AM9PR02MB6897:EE_
X-MS-Office365-Filtering-Correlation-Id: 176b61d9-285c-43d8-ebb7-08ddd4032e00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7qlPUXMd5BeJ73VvkJ5pcJdJqhxXEhzb+TqRSPM8pYlxAzZpvDkKyv+1X6c0?=
 =?us-ascii?Q?7kxb7a1qkaxCSoKhbueI6vMGyIjAz1Xnkq0QOVA5ySJBw0jJcth0U9BnYO7A?=
 =?us-ascii?Q?OQVEmDZFJd0iEay5LygGCRAyHWIKGdkaELQ5SrueuReYzPcJtGwCdDi5rcPh?=
 =?us-ascii?Q?q5po2ML7K7wGYaGOPp83fUsYZWIvGXTIl47IlicRttYpW75RLz7Bpd1Ivdkt?=
 =?us-ascii?Q?wlH2NPGg+BmtZ0zNi4NtjapHAf+G7bjFDVt4SLmvKe2ySxOpwY6Yo2cZ6VVs?=
 =?us-ascii?Q?HyKkRh3l/RLgupDnr3UMJb2hdb55xs/E06Z5kPlN4GhUl20gFCQ9SymFc1zN?=
 =?us-ascii?Q?Fa1BlpaFMDnWuzsrb2/Y2ohL9lU6IRyEo09b9zZuKJLxJBS8uMYxCtunvBD8?=
 =?us-ascii?Q?7mUOjIx1ogSu+7yv2xpHpzRhgOrhnaHjqc+LQNiBO+B2wqTRHhCPgUpqbqCp?=
 =?us-ascii?Q?/rY2gc9a4KD0Awz0wEe/2nsmrjICOmMiqaT/A1OTJOwbHn0fijj+v80l4oJp?=
 =?us-ascii?Q?Kr6f6fGJcKn2g31T9XxTf10o324ldOo8q28pGz9plveW60uh/QKsGD1hov5v?=
 =?us-ascii?Q?99pjKx4NXv00l6nNjJPLKMUUCw0ROCT3IbYyn/9F52p7ysXGPGKbNoHZLmFD?=
 =?us-ascii?Q?o2vYzkHs1S1dtEtlyMLSZE3MHsphKjidn6ZA7xeHX0cVRNr1GwMAqVVAELvk?=
 =?us-ascii?Q?R34mDDtMUG25dOBsMKc04mkYraZOikyQZOs7IO9uJL1ZnkcfnFNUpwcHrOmT?=
 =?us-ascii?Q?7FPqOYaH+G+zyX41djywhmmuapJiF4q/j8J+/gsy2jI72CQq3w0Nl7MT1asK?=
 =?us-ascii?Q?P/5m2qlsL06DW4aVFswnaZllRC5HYgjO7TYvhv103FdpeubiWPiCvBNOubF0?=
 =?us-ascii?Q?36voHQDNCGaZGH5CDIvqVpVwlbLeatMaeuwybq8CXhM7fQ/62SLUBnUHCzhO?=
 =?us-ascii?Q?lTwzrqrkoK+GmKXyasd5ssRE546gQjd3pd4DlfiJ+eE3IbbVapDYPczvwDxf?=
 =?us-ascii?Q?ZYjsZ+xFAEd0/IWV6Oh49sN3DSmAraGrck+Ls6aQPMIYktiS/LArajrxEUXd?=
 =?us-ascii?Q?YxSNtwTDsbnPo1rlVEZYwdSHjDDzC644TWsR7gxsRzcw+sUfPaF6IPv0fTqb?=
 =?us-ascii?Q?H0lCXF7xu9RKmSoQXJK+4N1qRCIb6bszVpPpl5cCal+K202T0xfI4rcM51mK?=
 =?us-ascii?Q?oW7k4HNs6YQygOAcfhcliIeyL40cRpp4JB/o3UwtGQA+IzqDTxcU3VDq0vd4?=
 =?us-ascii?Q?9g7Csf8R+FsnLYWuadY6KElTs5InuYDiypgqWNJ80F65mLAgc7MIVUn9mRE4?=
 =?us-ascii?Q?S/iVfyu5rNtYXCAU5cRpGpxGNR4C/6TWKFtJ9DPyDLNaJbFNY7Qqwl68qbrx?=
 =?us-ascii?Q?29NClamE2UgJKqM3b6hbd56xV476+ldc/m6C4HQSx0uZJJBT1kxLWly232v0?=
 =?us-ascii?Q?ftRZ/YprxBDfCr7PVVXfRAgij196N2YY9WFWkq4Mk+9KpmUHJlI2vIXB7icm?=
 =?us-ascii?Q?U9UkWI+6X2XBYAGSYGfv+5nqxBb5iMvQu4sN?=
X-Forefront-Antispam-Report:
	CIP:195.60.68.100;CTRY:SE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.axis.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: axis.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 09:33:47.7856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 176b61d9-285c-43d8-ebb7-08ddd4032e00
X-MS-Exchange-CrossTenant-Id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=78703d3c-b907-432f-b066-88f7af9ca3af;Ip=[195.60.68.100];Helo=[mail.axis.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR02MB6897

When `devm_add_action_or_reset()` fails, it is due to a failed memory
allocation and will thus return `-ENOMEM`. `dev_err_probe()` doesn't do
anything when error is `-ENOMEM`. Therefore, remove the useless call to
`dev_err_probe()` when `devm_add_action_or_reset()` fails, and just
return the value instead.

Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
---
Changes in v2:

* Split the patch to one seperate patch for each sub-system.

Link to v1: https://lore.kernel.org/all/pnd7c0s6ji2.fsf@axis.com/

 drivers/ufs/core/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 50adfb8b335b..3be165080a15 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10476,8 +10476,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	err = devm_add_action_or_reset(dev, ufshcd_devres_release,
 				       host);
 	if (err)
-		return dev_err_probe(dev, err,
-				     "failed to add ufshcd dealloc action\n");
+		return err;
 
 	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);

base-commit: 260f6f4fda93c8485c8037865c941b42b9cba5d2
-- 
2.39.5

