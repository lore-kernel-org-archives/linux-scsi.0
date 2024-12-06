Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011039.outbound.protection.outlook.com [52.101.129.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6625D2F5E;
	Fri,  6 Dec 2024 07:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733470246; cv=fail; b=ercqnMDjREkpkRxu/A+n6RnRIGljfkvXU3bBBTQrmvwJ4xHtdR/HVlWC53w9rl5RLSS5UU+IOn1m4nWLYDBCSMTeLizDr1M7nkJpWEmE6x2UPko3uGUs/R7YgF+3/mFkZESTYiaNnJLBDqK8yoYuG+K0MoL+PZBonxWx+XKCqFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733470246; c=relaxed/simple;
	bh=I6SPPQBvY8M8+yC+tqBRC1MQQZC95Uk3L7y4Z7kQsCU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nTIsnhm2rGrezoCG6wTrV5EGWJvIuAb55X1pPLEtD8HdOCjwGyVPwBHx10p5EbB/oLQheWhUkYhpGdZnmdih+5DY534LSoFpZ6nAnPGRKiW85dyevSQJkqiPSmtOVs4ciSjkwIm7T9NYwJJvD/+XAfHn2qfcWgzohfJUkZ/75nE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=dVCo8f2e; arc=fail smtp.client-ip=52.101.129.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="dVCo8f2e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkmUyx35i4AneyW/xp0IKxwEoiu2ok9P6dlbB0xQVvYYJXR01FqT2OdGuc9RX/ThRvE531O9vIlpMTmotTBvaLft5LldA9JAPUxz30D7VYDjQAEfvQ7wMqFTxOiquT85ALZlpebsiQM2SszoBHJm9A9wlh/w8U4iVGZl/v60LnyausWOaV33e8a+Wu8eVsKph4oPTG+CjL/bDwiDT+uQNH6u7HgBzirht4UqTzuuY1NmRS2j9Rea3Wv8xN+xlVjKYY6RYPObFacL39fjXe9IpIlvthkUb4LGSUw13GqJhdlTsP1l5uOhsQj6ROEFVrYg1xKLZ7Y+hXlM3Q8jgnXdcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUoaheTGILqa2n96rfzdpSN9fN9jf2emerEdMyFRzu0=;
 b=ggu5vBhW6EYH80UkoRKXFfUUtr1B0O4UXaztPshpsohUGJf9rkLTxudyeKV55qTbmm9m1rtjNcytIukHYTL/IXVzGpg1VGI9F8dld2hlsxhvCn8hk2SZ/xl3RYFTtAz0wscTGHLeSQswyh7TCjRGTKwUjkW7qryH3esCae1O5fZ3SCT5Do73t4i4/xsmB4hsvhxUYAaoTw/tycdsHLDW5vnqZ4zCZmz5K2as9FVVdlqRYpZiTjhWkdl5E5AArFFBjOFrKCPS9GzmvSOcE1Yzqm5CwusCD+CY3Muk+8LPpimyjZKjZsKlb8IJnFtnH7eKtF4QIUAD7bHvJ6gvczbnnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 58.252.5.68) smtp.rcpttodomain=samsung.com smtp.mailfrom=oppo.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=oppo.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUoaheTGILqa2n96rfzdpSN9fN9jf2emerEdMyFRzu0=;
 b=dVCo8f2eOXxxQZe7y465b06rt2Fzl8qcDPVNv/RR2THInnxJHD26X2UugaAcYBknHQAljVBG7r8cjH7CBGXYNLjbCGem+8LxV6REzcEf2vTqFwX+/t67cjuzBCRdspd9n19OJXP8VeW3D9ceeIkA1NI4AvNL9OCF9zGijp3qqFM=
Received: from SI2PR02CA0028.apcprd02.prod.outlook.com (2603:1096:4:195::8) by
 SEYPR02MB7388.apcprd02.prod.outlook.com (2603:1096:101:1dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Fri, 6 Dec
 2024 07:30:39 +0000
Received: from HK3PEPF00000220.apcprd03.prod.outlook.com
 (2603:1096:4:195:cafe::9b) by SI2PR02CA0028.outlook.office365.com
 (2603:1096:4:195::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Fri,
 6 Dec 2024 07:30:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 58.252.5.68)
 smtp.mailfrom=oppo.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=oppo.com;
Received-SPF: Pass (protection.outlook.com: domain of oppo.com designates
 58.252.5.68 as permitted sender) receiver=protection.outlook.com;
 client-ip=58.252.5.68; helo=mail.oppo.com; pr=C
Received: from mail.oppo.com (58.252.5.68) by
 HK3PEPF00000220.mail.protection.outlook.com (10.167.8.42) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Fri, 6 Dec 2024 07:30:39 +0000
Received: from localhost.localdomain (172.16.40.118) by mailappw30.adc.com
 (172.16.56.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 6 Dec
 2024 15:30:37 +0800
From: <liuderong@oppo.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
	<ahalaney@redhat.com>, <beanhuo@micron.com>, <quic_mnaresh@quicinc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, liuderong
	<liuderong@oppo.com>
Subject: [PATCH v2] scsi:ufs:core: update compl_time_stamp_local_clock after complete a cqe
Date: Fri, 6 Dec 2024 15:29:42 +0800
Message-ID: <1733470182-220841-1-git-send-email-liuderong@oppo.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: mailappw30.adc.com (172.16.56.197) To mailappw30.adc.com
 (172.16.56.197)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HK3PEPF00000220:EE_|SEYPR02MB7388:EE_
X-MS-Office365-Filtering-Correlation-Id: 39eb9056-1fda-494e-e3a1-08dd15c7e218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?31Sg0UqJxMBn7NJR77xO5pr3hbf+mIsNI5oKnGZ7jzMg0sdDp0k0D9OaAaOS?=
 =?us-ascii?Q?VL+HB9N9+ldUbTxcrIC9yE9G/ZCY4OGLFb3W3aywpkHuOXtur+wtckiyn/5B?=
 =?us-ascii?Q?GbGEvj1b1s3HySqrRCkXl4TpSFxI9MMnTi9LyX7HpC9QwxOKaXczvFCE7pG+?=
 =?us-ascii?Q?DH6OL81le2IZ0hWapGs9GLMGw8GZL18niUtQlxOAKfcJ87RvP/FyOdJYk6Pf?=
 =?us-ascii?Q?BdYME7OtlprXY5uEXsTZBU9qdsu8B1vfv6zU+5jTxeiQcTO4uZ/XuzyYiEnz?=
 =?us-ascii?Q?o4SDW/r2+07RZVXudkidZrUJvPPVnh6WOXF+gIrZXFByqIlqY8jODYBKz4Zy?=
 =?us-ascii?Q?2/nLwdvEwQe4mAbTkZpGascY2ee+WnWEDgC4weSxfUqPD1mHv18vlDwV5EMt?=
 =?us-ascii?Q?yMVDO2yRpD+0vDYZtvgSr5g1n+0vvFt2LFH2WgcP7jD8EesXCnLkg88vLmwH?=
 =?us-ascii?Q?CSkUog74YYoLZk13hGiaxv6YGYSrdktgcp18oIKSMFyr2crpDWhgQyLV6Tjw?=
 =?us-ascii?Q?E8Qcvxspny/8+6749SKl/SDeq6bOlG2hPVt23OIQiWRgyxHWCzpsyJZDiXw/?=
 =?us-ascii?Q?DwlHFBvEVsU4ko2M/WfJtGC0UhXR+6iXAWUKi96rk2+EEe9eD0Z601hIwHiy?=
 =?us-ascii?Q?t6nXIXXEezwRD2duRHX9LJoK9eBPMuyyXxVOwyTp0OHk6nA0nMmH8FZTGJDS?=
 =?us-ascii?Q?PJbrnqeC9uCJyNkyksAtQ563pdxnaTdZ+A1yhfgNP0gslOy4+4GiDcgIKTHO?=
 =?us-ascii?Q?2dbcnIb6yiSikvBABia0mCw+vW07uLwUt+Vp/QrIL5TQi9dh6hQ6ZxgQ5A3M?=
 =?us-ascii?Q?zhuNKJAhnPrHwGFTUXezo9/nssz1InvNYmSXYtM9aSgd8f0cgggpLaRp9K1F?=
 =?us-ascii?Q?RdKqUwfOpOxOU0WHzcZrOXCKfpAK4EO1Z0FPUIa8j3V1vT7CAxzxdZYZ6WAN?=
 =?us-ascii?Q?f6wEk2irTNdsaNRJI82Iu2HNiSBtcZvtpWzqjdvlqCdpa2unFqxVNkeupRte?=
 =?us-ascii?Q?pZeASKpOakjzAALOiwkzqQ/lYbmoOOawOvvmqZrEjfQVg1qMfAj3Gg+0lP3l?=
 =?us-ascii?Q?1Xxxvy5vYxJP9t3QAnGaZyO3oU2FYDyLJ43PEXYTDUSOGkW0bh8e0OyLWWLb?=
 =?us-ascii?Q?FSVyRYP1hDO/TB4oY+lqkPleH5bXI2EUXkPfNZPg3zokuKoMiP8wpd2sB+4q?=
 =?us-ascii?Q?sSETxvxuLA/spjn/w2LDVWvXgJ4BLzQObv9yQ5LBSxh2O5zuduuVkdi7bBsJ?=
 =?us-ascii?Q?k4fACjkI2GWXtkCrlubBrZvErAX1R792sPkzyk7X+LKmuqp/vlEtyhk2LGCJ?=
 =?us-ascii?Q?JMaGrbIwAtVzVRLEeo3Dv/tp6VhNxtE3ZsDhSOKegbUMoomolpdiCq2ohjT4?=
 =?us-ascii?Q?gscv8RJF19XjxsPOeywYusCvhnvlNzdn831Ys/3GTFfrHwWDwIRcXVuFOxyk?=
 =?us-ascii?Q?sjna+l+yTvuF/rd/PAEs/RP7P88ilt+aJnrncpBpHcevqQo64uAmHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:58.252.5.68;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.oppo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 07:30:39.0716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39eb9056-1fda-494e-e3a1-08dd15c7e218
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f1905eb1-c353-41c5-9516-62b4a54b5ee6;Ip=[58.252.5.68];Helo=[mail.oppo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	HK3PEPF00000220.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB7388

From: liuderong <liuderong@oppo.com>

For now, lrbp->compl_time_stamp_local_clock is set to zero
after send a sqe, but it is not updated after complete a cqe,
the printed information in ufshcd_print_tr will always be zero.
So update lrbp->cmpl_time_stamp_local_clock after complete a cqe.

Log sample:
ufshcd-qcom 1d84000.ufshc: UPIU[8] - issue time 8750227249 us
ufshcd-qcom 1d84000.ufshc: UPIU[8] - complete time 0 us

Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: liuderong <liuderong@oppo.com>
---
v1 -> v2: add fixes tag 
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6a26853..bd70fe1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5519,6 +5519,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 
 	lrbp = &hba->lrb[task_tag];
 	lrbp->compl_time_stamp = ktime_get();
+	lrbp->compl_time_stamp_local_clock = local_clock();
 	cmd = lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-- 
2.7.4

