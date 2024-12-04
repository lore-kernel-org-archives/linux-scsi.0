Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010027.outbound.protection.outlook.com [52.101.128.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE971ABEDC;
	Wed,  4 Dec 2024 11:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733313118; cv=fail; b=atdBabNdUqf9e8iC61qqXhpiMr2pJZ2S7vhjvSZYlnl4kIhBw4dvrfjxzmG2BgkVqxXZqthtVapveBdTUj2cFIW5YBQS0maS7OLqBwkNjndRsdHbukCCtGIuK+Dwgh97uMozU8FqevQpHMiXiBC43rU6KxzbYqHpewTgHgCnOT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733313118; c=relaxed/simple;
	bh=fWznVV8JfhiD2xJxXVYVzjESNbsSf/79GRxXlF7GjTg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oQGVe0A2eFFqzB7WjRUnFFOkPd8U2rJcAhWQbVNpMqOebm2XZODYWT1v/xtIHr17cuxfwxuD/mM0urydU4+G7fTgtBFfakhl/GkC6MD6y37HaR1tdCXXlSxmL9WMMjnE/gGHTVfrl2wUzoLFIB3Sib4lMP+OGWJJA8UqSo9TJJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=gfdtdbXH; arc=fail smtp.client-ip=52.101.128.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="gfdtdbXH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9hjA+jW/yCbjY+2qUK0+dvU1AOCIocpg5+HfUZWC+0D/+IksMxP5MNopROabLCFFsUEFApQjdWe+Y7+VNZyykIkj7TmjJPxTzG17afI27ZBQfkBOR2UnqvIyqp7FPwLzFUqYnHmv0xdUoidgYHCraUz82yhBqvGhQCe52XAqdgB2u9vycp8ATGEZjo/DnXZQa4vUJTvnHgd/dLjG6IIATi1aJmw4oXGBO5RmGzNSTJ4jkjsdw9Rprr46x2hdoY/zXN+xV/xQ1UybOtZTHHCHDhdqNZhF49binEMqbqRgLVMkBq2mdSn5N78HopCJoq57u15w88wEpT0R9wi/qFu2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jIW/2H3yGsVFI0ke6NPImMo9nnC59ZtXEayoR+KbbM=;
 b=PMcyO+KtsLNtFci3gCbCz0oEAR1wUZ4VDJLdmbLVAe6OJXLrg/DYCNJDBIdU9JiDu9TZz9R4YXDYxEBN+e6STfRdF0SxicJj1OhpxCyFxW6gN9AleCJ0EQuD+bHNMTzL6dinEkZmvd7sanpojduw7RL19Q0wBvdQCvE0zQG+2sF9m2fsrTfF2bKycVd4LHqc/wXiwGrVu2bHlyIUybRYI7lDqeFkC/6g61SpBjyC7hvcTTlY/lFjLZju6bpwwKGrt9+vr2Jz2YeFQnn9IcTeyTtafmcagYWIpzB+Md1dn9sfgKH57mxaEKXSaNKx0tBOFNaaWJIHuC6S2VTtlnZuXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 58.252.5.68) smtp.rcpttodomain=samsung.com smtp.mailfrom=oppo.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=oppo.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jIW/2H3yGsVFI0ke6NPImMo9nnC59ZtXEayoR+KbbM=;
 b=gfdtdbXHG31ipEUypXH0mFlcwVA38tK/JuHVXG8KHLmsffht7aebVH69OEP9/CLqWJyOVJRw4TWtiXMjiczni4GwoRBHqqD/1AGP+QvQ9HI2Ce9GUHoXGorZcIA7rmXcQS9A1DlfWDiMJwcsC0RhsmSAgo0ZTRt8FgOzrDorWgc=
Received: from PS2PR02CA0048.apcprd02.prod.outlook.com (2603:1096:300:59::36)
 by SEZPR02MB7539.apcprd02.prod.outlook.com (2603:1096:101:1e8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Wed, 4 Dec
 2024 11:51:50 +0000
Received: from HK3PEPF0000021F.apcprd03.prod.outlook.com
 (2603:1096:300:59:cafe::be) by PS2PR02CA0048.outlook.office365.com
 (2603:1096:300:59::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.17 via Frontend Transport; Wed,
 4 Dec 2024 11:51:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 58.252.5.68)
 smtp.mailfrom=oppo.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=oppo.com;
Received-SPF: Pass (protection.outlook.com: domain of oppo.com designates
 58.252.5.68 as permitted sender) receiver=protection.outlook.com;
 client-ip=58.252.5.68; helo=mail.oppo.com; pr=C
Received: from mail.oppo.com (58.252.5.68) by
 HK3PEPF0000021F.mail.protection.outlook.com (10.167.8.41) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Wed, 4 Dec 2024 11:51:48 +0000
Received: from localhost.localdomain (172.16.40.118) by mailappw30.adc.com
 (172.16.56.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 4 Dec
 2024 19:51:47 +0800
From: <liuderong@oppo.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
	<ahalaney@redhat.com>, <beanhuo@micron.com>, <quic_mnaresh@quicinc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, liuderong
	<liuderong@oppo.com>
Subject: [PATCH] scsi:ufs:core: update compl_time_stamp_local_clock after complete a cqe
Date: Wed, 4 Dec 2024 19:50:04 +0800
Message-ID: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
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
X-MS-TrafficTypeDiagnostic: HK3PEPF0000021F:EE_|SEZPR02MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: c000fc45-fc30-4b6b-b93e-08dd145a08e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j4aUfsU/dJTCyOH3YM1VzQeq0QJIW3qCb9Po0A62yj1T0QVhJ2ts5F7A44Lo?=
 =?us-ascii?Q?PXQiYU3e7Wlm3laVdIbnVVeHdVNCoDKQSljZ/OCRfNH/wXYZzM4U46HWtwl/?=
 =?us-ascii?Q?cBW6/2/h5ytt3F+3iQuxJLTzIT4x/XtWf+/qyrOLCJCUX7b3RhN/9yR/NB42?=
 =?us-ascii?Q?ZZN0CaDY082BJojENjpRkUmWIbh/cfOc8D4jKqyd71ZU9PplSt0w1dUivKuK?=
 =?us-ascii?Q?bo/+B5WACtidaPU0nka+1WOgo5q2U/qe2+o0X9/t5m0yxRZQEcI75PGQRxH0?=
 =?us-ascii?Q?ndGHxcMBL7+JjRuzx9TNn8L1RF8mf3yOAkSrdLBerY6MUmGYVSwqZFj1zM4V?=
 =?us-ascii?Q?cD5NXOr8ZuOb5lv65mMVxXcDNB5CyFNymiZYDtYNi4pn7RzWzcIwuPadLKB/?=
 =?us-ascii?Q?04S6DLsrM3dISBWWhLth95VspG9vd7UUA36pS8tP++n8209iisK72Qp5bX+O?=
 =?us-ascii?Q?NoKSJW3/1eDb+JvMC7qwbA8ghTJrgOzGhSu4m8pSPvJ9SCt2zOAjMYa60p72?=
 =?us-ascii?Q?iQMki5jmyBeQxBT5/bbD8iD/FDB01HA+L/e3UG7/Q5CfpRb0UBzkiacfpY7h?=
 =?us-ascii?Q?iFoUtSDxH4gQGug7X3IBvWrQQvcVhDRP5Cpuax/jP1b/hdlCkgtB1s88P8Rl?=
 =?us-ascii?Q?amC8cxuCtm4vPyoSjwLDXK7acgTx3hUQ/6/Fp98GwoxRzich1n3E3ryXpPw9?=
 =?us-ascii?Q?pVl8wWpZauZUIQVpiMO4QUmpxk7X0cyFJZpPdZd9MkT+1G4Z7hcr8C09ocBv?=
 =?us-ascii?Q?gFnNfhbDaEJDngEAUMH4yFcSv/r0ndcd9tyxN6UQX3BLHHUQRPytuV87uq6j?=
 =?us-ascii?Q?/9vd5HNiORVWDOshBVSFwWohUaacKu0EPmmGMZK6/7VbDWrusjP48cyx2AcU?=
 =?us-ascii?Q?Sd5d8TCiX4mnMqw/ASlbhil931HvlmwHQBwb/IQwQd2Qns9tVtmK0Bo3uI6e?=
 =?us-ascii?Q?s+ArDFebsSqJAhQMxHLhJgGapHhwcTXkb/cL1n6zVyfFo2b+Qv/0NJ5LSzMs?=
 =?us-ascii?Q?xy1v+M7OZThb78CubAr3Dxil9oLH4RuziUTuGn8G13f9DzIHvKuz3Ng1QkoG?=
 =?us-ascii?Q?ZxktT8l/tC7jDMxeD6qhCyu/fS6lEG2O/EYpe058j5W1uz0qQ2oV8nvJkPEx?=
 =?us-ascii?Q?EQ4rH9XBOFMrIhKcMcN1/mpVNZMzMMlJRpIzLBaJh2v7HvYjYyYhiS7e29Zx?=
 =?us-ascii?Q?o/M5EKQRsKQqBS3UFeHceIOJNoZQ9lB6uvGBpXXvKW1xaWOI8gbMili1jJkR?=
 =?us-ascii?Q?56RaDHf4FMhEsh44fBOm7zi+hmaoMuAfJbHseFMUduwx2Lyjj6cRYfcoitKz?=
 =?us-ascii?Q?Px3IHs7eC8LmQcYpJ9tSYfW+rBgaSKVIgLdm497b9+rHYP9TeA1WT0yq7r9y?=
 =?us-ascii?Q?DAAF4dZgB4GpunHJMKHMoMZqCjgzrox2viLD9LRZqm0tT6Z6JQVixxEyjUcz?=
 =?us-ascii?Q?u91i3bDQXr2ynapmQ6o4wgVlvK3yaiABW6Ls8qhVTekslvDUligq2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:58.252.5.68;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.oppo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 11:51:48.3841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c000fc45-fc30-4b6b-b93e-08dd145a08e8
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f1905eb1-c353-41c5-9516-62b4a54b5ee6;Ip=[58.252.5.68];Helo=[mail.oppo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	HK3PEPF0000021F.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB7539

From: liuderong <liuderong@oppo.com>

For now, lrbp->compl_time_stamp_local_clock is set to zero
after send a sqe, but it is not updated after complete a cqe,
the printed information in ufshcd_print_tr will always be zero.
So update lrbp->cmpl_time_stamp_local_clock after complete a cqe.

Log sample:
ufshcd-qcom 1d84000.ufshc: UPIU[8] - issue time 8750227249 us
ufshcd-qcom 1d84000.ufshc: UPIU[8] - complete time 0 us

Signed-off-by: liuderong <liuderong@oppo.com>
---
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

