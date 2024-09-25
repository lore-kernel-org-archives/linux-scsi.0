Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010017.outbound.protection.outlook.com [52.101.128.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49755146D6D;
	Wed, 25 Sep 2024 02:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727232541; cv=fail; b=AQnYvKztyW7NVit22UgrdzEH8VZwzlB+UjlEZxZ2L9c7Lwium7J2vB5QwHpyV+AJMpkhpaxFTd6PcpZU72zowE1imZblih8DDI9i25kQf5To8YKcyvAYqRY7ILhBeBbszNeD7q9BRUPEaLszOisQg+pQFwhKsamwnsbHJJyGVP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727232541; c=relaxed/simple;
	bh=LObJaivAr5g8eQmdUtd9SPilVMyK93oE+3S2pUy8GiA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fgywb4lgmlKEGD3VxhlVvFmHLBDzXjRhhGx7WSU8VSUBmqEjw5MUz9U4dcfgdJMEeFde02/b3zNJvbjWdMFrpWlJ/u8dKJNbUmFns/koh/9i1+mtsGG2y/xdx/SQweSDSapEPBzC0+PvvXO8y48S+QvAgAZGyHR121eu22VTetE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=v784tjO+; arc=fail smtp.client-ip=52.101.128.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="v784tjO+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQ9JLfUp9P/MfTe2/cmnVRMsgvZIJdRZfHIy61YM+/rR1kNa2VLkIJHorgXiZC1L3IIrDJYKXtVR+crf3WE0c6Mt3l5fbDXeuF/Vj0U/9w0EowXcU1U8Wg7jD42c9fqSh0y/CQZR/NrECx1AO6xSUrSIuEnJjoxky5lAm77NAdt0h1nwFQcC/N6z1j5jGr55gdAafAanBEwAqRbOUpft3CfxK8D9HPUxJgM2+4CVVe5HPEWkJm32tR9WALAwaP4rKMj+aiOHJ55Fraa67T9aGrMastJLcAgd95H0m8fPC0lreSZf381Krou43rbMkbHFcDIG5szU358J/Z+jZYs6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mx4BEAP9cjjHSnFpGBz0GVMHLyRxFNFGoyL4vlRV2d4=;
 b=NHmSchiSyUqFcR7lG2yqkiizlwDkaiZ0xIYv0hBhQN5ILGDgBBY53hwIecsFgqb8K0ZWHjk4IpqtL0LHanMgBDD1VrTKSgUV9MjLKnjeFiaxRfoCTkY7qJxOJgq15gNArI/aEpfdoz/GOLnk4+ZGUeBw2336CvlIprsYSM07MjctOKUYhTl/E3IfO4Ifk3JQwDqUch2J9ciV6JSxIUfUjya0qtzNk6YFkXRQiDkNYLvmGZxrEtkA+ViWaUQlAVo2heK9Gks15TXj6OU7nf4cVlBF4CV2IP6XZSnpdEzVw/5Gf6YiwpLygORWrLjErfR3PyFxBYoqQBKh7NwK/c/ZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 58.252.5.68) smtp.rcpttodomain=samsung.com smtp.mailfrom=oppo.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=oppo.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mx4BEAP9cjjHSnFpGBz0GVMHLyRxFNFGoyL4vlRV2d4=;
 b=v784tjO+WY2yUz8vRfR6Z/JbL5WpKyFtJISUhPSuBuxofIdNiMi9J0SCCxyjXGboDxHoo0PDc8YzBG25xLiVRlI1SvKXIdi+1KMP9/h0ASIWpUTO3XkuMiErTlRc92X2TCpotU/TPtirHlb/90WzSTSH9OT1Fm7W//zzBmTtJb0=
Received: from SG2PR06CA0232.apcprd06.prod.outlook.com (2603:1096:4:ac::16) by
 SEYPR02MB6243.apcprd02.prod.outlook.com (2603:1096:101:d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.24; Wed, 25 Sep 2024 02:48:54 +0000
Received: from SG2PEPF000B66CC.apcprd03.prod.outlook.com
 (2603:1096:4:ac:cafe::68) by SG2PR06CA0232.outlook.office365.com
 (2603:1096:4:ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.17 via Frontend
 Transport; Wed, 25 Sep 2024 02:48:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 58.252.5.68)
 smtp.mailfrom=oppo.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=oppo.com;
Received-SPF: Pass (protection.outlook.com: domain of oppo.com designates
 58.252.5.68 as permitted sender) receiver=protection.outlook.com;
 client-ip=58.252.5.68; helo=mail.oppo.com; pr=C
Received: from mail.oppo.com (58.252.5.68) by
 SG2PEPF000B66CC.mail.protection.outlook.com (10.167.240.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Wed, 25 Sep 2024 02:48:54 +0000
Received: from cndgdcavdu0c-218-29.172.16.40.114 (172.16.40.118) by
 mailappw30.adc.com (172.16.56.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 25 Sep 2024 10:48:53 +0800
From: <liuderong@oppo.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>, liuderong
	<liuderong@oppo.com>
Subject: [PATCH] scsi:ufs:core: Add trace READ(16)/WRITE(16) commands
Date: Wed, 25 Sep 2024 10:48:43 +0800
Message-ID: <1727232523-188866-1-git-send-email-liuderong@oppo.com>
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
X-MS-TrafficTypeDiagnostic: SG2PEPF000B66CC:EE_|SEYPR02MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: d9ad3e61-838a-45a9-27c6-08dcdd0c9841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VpORU51jA87sJ7mSr/gin7eMNn5fuDUIOL6sV4fl234AFs43Jy3laKLZQWkA?=
 =?us-ascii?Q?/pi1TVFcSVQCdyIrvS/r4SDPjKBTjNBCFNW8/FaCNCcJYkkvnMrFQW6cM1SF?=
 =?us-ascii?Q?zJdvm5ax08/5JORJe4P5OR3oa2hC0ZWqAltshrvZ+flJ7xSfecTuOTHQMBKC?=
 =?us-ascii?Q?26nx+SWXzTfIRJNTeZVx+BAytsmmwdkiqfmkF7q56ig8r03C4qMsiBWeCBZD?=
 =?us-ascii?Q?EyVwXNjDbi2KCmGxTgb6fqxQhH7tRh/qPzNvXrtQhBsGphtIwQCuqP5Kw5QH?=
 =?us-ascii?Q?0rt8/4bnjI/z8SXqa1+UYDLq5SO7xB/ss4GAI1B7flbHoDqFjgb4+fyu4HEa?=
 =?us-ascii?Q?wM2B9KLeL/0p1OM3ZmC9p/2MPptJb+RYTEufzK8Xs1BsfIq8BcsPsmvH1Fw9?=
 =?us-ascii?Q?N+BgkJjSjO9iXNmoO8spzJoJSSfJ6nCSvgPdykUwgpVq3zWlf8YOA50vkMpa?=
 =?us-ascii?Q?zkrI1QvZggXWF7XStyfLoO7lSnZac9jW6NxnFV4J0QWEp6gKzVfkzLnLfztD?=
 =?us-ascii?Q?rGH8JfEKpZoVWrV+LMPBvGftOP20MSkNPVAoDnGeI+hJXyEfVAG5XSKnNxv6?=
 =?us-ascii?Q?EFMH44x6oB/x+qWgtwS9lD01T2GTHVzvNkm/4XbgdyGaJJRWqFwQyMCql8MO?=
 =?us-ascii?Q?fLrLX5eAdOR4UyHzJMzeKsMeV+yFEX76MQJqIhyuvl2ClrdKmdUqtxN/N9OR?=
 =?us-ascii?Q?hMVhHlWqspWEvtkmQm3ulvyz8FNgSstOgggcWT7FTGp/hq3B887RvJhwTXsX?=
 =?us-ascii?Q?uv4vmlfE5Zfw5WDa8Waob7CE7t9IDVu7q3HJPNC3ZO1DwPRZ4VVtu72eBWDw?=
 =?us-ascii?Q?7Vm7Cz/E/AMhDfez9sB3K5KRfzMH76nv8sxKVVhTICUkdq0emYO/x8XnCe5L?=
 =?us-ascii?Q?cBQSzRgwLJzG0/jC3iTptkTZ7npf/taNnchI5r5vNxQJvcilSU9cAoZhyCxf?=
 =?us-ascii?Q?D4cBcrs1YVRdJy/YZZ8ZsMfyn9P/al39V6xMQwB7w96544dewp0ylnbwITEK?=
 =?us-ascii?Q?3rgxvaGI0CrCiOj25Bw6ujN7fgX1V54kFX68j2EW+styx0tcOyyD6y57BkoL?=
 =?us-ascii?Q?nnBr1Dt106cnQ9bM/b/RxEjqVPN8mGdWmvgYsN9Y59ZncNxQzhPoq4yZsTW2?=
 =?us-ascii?Q?R9tH42nx1NBE4uvy5OstZcI8hBXwQMCJfajhyow+xbaaPNzhmvV3GP3QdmFH?=
 =?us-ascii?Q?k/KfkXsoQwRV5qvx+kqVlyXRCGPa886pU3NgTfkHdSS9ysedd0vPXAq3i0iI?=
 =?us-ascii?Q?yJGL4sjhEMQkFcBBi+54KvriRjpEFvdHtjKbSYm62TD/L/onjxPTB7sEeVEe?=
 =?us-ascii?Q?RWmh0gT3ykAF/XkgV6jhjN5SUohCtCl1GGS9YNfn7Yjvt+/K/OXx4KiyMooo?=
 =?us-ascii?Q?qs+rTeGuAAAxE/QXHQrymCPD+CvN?=
X-Forefront-Antispam-Report:
	CIP:58.252.5.68;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.oppo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 02:48:54.2426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9ad3e61-838a-45a9-27c6-08dcdd0c9841
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f1905eb1-c353-41c5-9516-62b4a54b5ee6;Ip=[58.252.5.68];Helo=[mail.oppo.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SG2PEPF000B66CC.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB6243

From: liuderong <liuderong@oppo.com>

For sd_zbc_read_zones, READ(16)/WRITE(16) are mandatory for ZBC disks.
Currently, when printing the trace:ufshcd_command on zone UFS devices,
the LBA and SIZE fields appear invalid,
making it difficult to trace commands.
So add trace READ(16)/WRITE(16) commands for zone ufs device.

Trace sample:
ufshcd_command: send_req: 1d84000.ufshc: tag: 31, DB: 0x0,
size: -1, IS: 0, LBA: 0, opcode: 0x8a (WRITE_16), group_id: 0x0, hwq_id: 7
ufshcd_command: complete_rsp: 1d84000.ufshc: tag: 31, DB: 0x0,
size: -1, IS: 0, LBA: 0, opcode: 0x8a (WRITE_16), group_id: 0x0, hwq_id: 7

Signed-off-by: liuderong <liuderong@oppo.com>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5e3c67e..9e5e903 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -434,15 +434,19 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 
 	opcode = cmd->cmnd[0];
 
-	if (opcode == READ_10 || opcode == WRITE_10) {
+	if (opcode == READ_10 || opcode == READ_16 ||
+		opcode == WRITE_10 || opcode == WRITE_16) {
 		/*
-		 * Currently we only fully trace read(10) and write(10) commands
+		 * Currently we only fully trace the following commands,
+		 * read(10),read(16),write(10), and write(16)
 		 */
 		transfer_len =
 		       be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
 		lba = scsi_get_lba(cmd);
 		if (opcode == WRITE_10)
 			group_id = lrbp->cmd->cmnd[6];
+		if (opcode == WRITE_16)
+			group_id = lrbp->cmd->cmnd[14];
 	} else if (opcode == UNMAP) {
 		/*
 		 * The number of Bytes to be unmapped beginning with the lba.
-- 
2.7.4

