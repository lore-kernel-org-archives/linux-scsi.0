Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013038.outbound.protection.outlook.com [40.107.44.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982A233985;
	Wed,  6 Aug 2025 12:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754484494; cv=fail; b=gRNo8wN05S07ZpLW19EXECMpDMIFYGODFDtbuwgdNx/ssqent2R4Kh03SqdA4huFJTN/kCYYl6bV4DnG3sC3hvlp55s9gbdmHGtb4GiM2ilinGXxj6Ge/jnUCRTmq8SXZLcQr3UKAP9nauUJ2liCf5SZabgg7xSynJuj8d7KeRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754484494; c=relaxed/simple;
	bh=cwstCXRx1AbmlWLFa/bvVGB9EfIwUjVIXdrJDSkkhE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xk4//zfQA/EUiG84XWb0YgH/HCeCcH+3zHgj+0HUDukm9X3aev94RgyJe6gy4l2Fre9OybEpb0CdhvA/eHw+SMEQ1ItDVU8Xnjoltm4Fa3KgJ21Cm463hiyJHlHRW76pj0z2aUd3PZEG56zjN9yRzBnPfZEmNueAP8xpCmI/tfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Sjh58AB2; arc=fail smtp.client-ip=40.107.44.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Sjh58AB2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jJynqWyWbrWR1EH5N+WEp8SEJUNRjOyMEpvFrX6WWVLRvwW02ZdcdbpgvL3aV7BUC3WqXyPRlIPinD6unPZDESs3YamEmDbJrNcQ/qFmqx5I/+0a7qImM+bQdhoAP7KNVxchuA9vAvaR418sK/H8ckX/MVC8yd/kCdEEzaL8QO4dszH1i4PRC7JoiLnls5WLk+2H0Tfpv8l2pKYIW7F4mKTpKJqDsP+GN9hEacahQhGovvJxfea3yRG04gZ9ZM/+6aF0Y/7ZMYPhXQagm2PFZCQwNemkW30OVp0Wqw24unytw1nclWCFQBguePWAwYXO2cchsbL2J5RSGVB1p+JQpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SYELEp1663MZcR+PZyg8d+eoeD8/Aouam6k6haS5eY=;
 b=KI6BbbmyW2T58kH2juHNiGpq8YZ9FfKYNoVRCl+S9N50dc4G0YDa1tkj5ojaLon4VYYAAFnpRO6WlgSEdVlF4kbOasHXeUTB1+oW8eTLkjAimde/qW2pKWHn7/1IdpH3gPvHxUamVi2z8d7AEC5Px4/rAwIThWiwMTpAOr4i6rrvbRT/zVMGBRKNQWuUOAY4BaTEPSHDKxa44ozScnsoJKOkGukIpUpckMsV6EuBLTYg1oMTybFZNrGZ6D0eQw8Zu3beChBt9o6cHaIqjakmoiIwn3lk0Q0FrKiHueC5KD4f/jfChzSdpjY6RRppMeTSh8b7Kc9YFzL5yk/umpON3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SYELEp1663MZcR+PZyg8d+eoeD8/Aouam6k6haS5eY=;
 b=Sjh58AB2bJiIgZrCosKjWT+2mvua32aERp2FlBgxmbr8f1JP8Ys6yTDZiJtaUP++gzp7mcI0Cq9BrPGl9yfttrt3xRmku75n0MSj0fsJUcWbWZV9A1S5NZpGdfY8VLQwYVP1iFtNsDcLV9F02oQIoyZcOcm+4avBhAxupjAzbtxYMOswS1cgdz2G5HTCkvV0JFI8tL6ZJ2KC7aW7+gYfk6V9J49nV3Q+ZEp2FHhijMgi0r7rqH9eGi31iv6IlwwNIO+xJzDvz1APROyocKCzSpmQwKCoxX9v9dhZ0grEYpMr9W8G0JjkQ0H4phDOHfzYw88pSZf46dWAl4frlzZVJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7283.apcprd06.prod.outlook.com (2603:1096:405:a5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Wed, 6 Aug 2025 12:48:09 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 12:48:09 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: bvanassche@acm.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v3 2/2] scsi: scsi_debug: use vcalloc to simplify code
Date: Wed,  6 Aug 2025 20:46:33 +0800
Message-Id: <20250806124633.383426-3-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806124633.383426-1-rongqianfeng@vivo.com>
References: <20250806124633.383426-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0045.jpnprd01.prod.outlook.com
 (2603:1096:403:a::15) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7283:EE_
X-MS-Office365-Filtering-Correlation-Id: 4226017a-a3d4-424f-8475-08ddd4e77f2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X2G3OiKJCo6onPukRhvkxZojr49J3qDSsdfTmAc1Ivt526wU/gtfBfNOrbc5?=
 =?us-ascii?Q?3uNM0+igeg7TtQByBcMICb+qygxTMSdM0gTXBqZcYYOuuSDo/ZxtUCGhXQqB?=
 =?us-ascii?Q?vGCzpZqqeIFx7y3OljjNj5yC0Wp64BoQFdP38ena66Sqb2iXBLLFuGWW8DhE?=
 =?us-ascii?Q?VJZUuFtnsXzsGnq70mS54p0ioP8F4Wp+ylzs2kCu7xn1szbtrzDKGHObGz/X?=
 =?us-ascii?Q?5Mq0iW/XAcQCE73GINswK56KHUWftm+DcfzWx2cYT3Fuqb7R9XPVXtsskmIk?=
 =?us-ascii?Q?JM29EPsVNtusm2ReEFF4gIFvtVYldy47k3aoyaQN996qAFmEa/l/Aqw5rF/I?=
 =?us-ascii?Q?tWJlQ3eT87HHOJ1HAoE849l3OLTV2r82nwJO2+lR5wt5AKH8GQ0kfh7+zSz9?=
 =?us-ascii?Q?43pLxcEtqpHRofxueCYtP6qssaiuDkyQV/IRy/zHOufQL7HbGXZlXqAInpFx?=
 =?us-ascii?Q?KBV0ZeqzDfISCD4NZFYt6Csj2ZM4p8UdBU5a97ZJl1bFfDlJH/rlVcL1OOxY?=
 =?us-ascii?Q?bbQSJ0v5bxuPlgxudE9/l3WcF9WSecy/+hBIUsFeYsbqCujpYtpdu996f0Y8?=
 =?us-ascii?Q?tU+ufgxpxL798yeTct9cMhVFMgN0KDtwrAQj7rQnE1l4759q+2VNDo63CMrH?=
 =?us-ascii?Q?8sntxyArOtgxeVvYIyMu39HmMcprd3swhASw+rlFr0YH/Ju5jAcfXwy+IB2F?=
 =?us-ascii?Q?2OgALOWAmAea6VmRsX/KdKMifs5odH9Wv7AYI0wFbqOcN77mLfKBtwWVAlZ0?=
 =?us-ascii?Q?2fBTEX0O1WDa/ujD3Es54Wz4X5rynpjFydkCIn09pacwc0qUuSUv4Ys22fHE?=
 =?us-ascii?Q?7qozsCf61IdYoeEGU0swbou73Jop+TsUBerrvPwfrqC04FFbNVQ9fNIuSpmt?=
 =?us-ascii?Q?ULhR3s3bnnm+DOw6IljSi9nCYF/KG7y4VjDvrnH2u+/Ccf4AAvPYCrAPADcW?=
 =?us-ascii?Q?U0ltRdhYPECr/2H2iCX3ADjYnIu3L+Rg/bIaivZi8vkIOt0u+OYzJC60SQBp?=
 =?us-ascii?Q?io6q9MEUYr6qNo5xtPPHSORGIwVL78fzAaB1Dstjg3nyUXULxoNV1fn/WChH?=
 =?us-ascii?Q?MZO21yEU8pAuKAAYVQAsMKHElzQYmRjVsfwUPMECCOsa/HH+W+5iYkcfVG2N?=
 =?us-ascii?Q?B3SHax2leau+Bd8ypE4oO8iTgGoCCVz9rEWoY2VRSCeatKncLtLkvqkzbOet?=
 =?us-ascii?Q?zeRD/wrMSSs5hdUTlSYvbC8LK8dmGahgEcjoBky30rGdRWzbC7bETbVQ+keR?=
 =?us-ascii?Q?QmBPm6J9AzL4yIZTkIDePkgpLK6vQ05GZdGTFZSyAqcAuIa0gVAAgkHxOV8G?=
 =?us-ascii?Q?manMOl629kNObzCw7NIwzN+nN8fLSnPRMvSDoW3ohSyafIN1hwwCG5RWr9am?=
 =?us-ascii?Q?jHs5zbjhcd+Kj6k7SocNeVglDdEo971BTM9EKSTBkic4FInCgVecg+daQmtQ?=
 =?us-ascii?Q?6GmT48xzZXjoTTcIC16q6SWtyPyPqfGxmcsOin+tpgtyXFTCS852nQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?odihn7h4gIC9M0N5i9Yl7yYOwrB5FmJWXY/u4tW/ShbDsALOm88pMgB7d4IE?=
 =?us-ascii?Q?q8EKsj8Eqs2oOMfPgNh1n1ovqceut/SaP+Udi28TglKNbI8RkujOb4lEPh78?=
 =?us-ascii?Q?mT+k+CNxSBW4bo+JvobNKnvVRjpBs+q7T5JdLvy80W7SjJ63ycyoR9zvkJ5t?=
 =?us-ascii?Q?dh60ZB/V7t4abmlZuHvrNAUBJzGMa35bnRaU3JUNmO6XGSvUfU/Ez2Edl9FF?=
 =?us-ascii?Q?rCJihzPt7ncZYM4ad5US/yZumqWZE0wHOlswPuVky1K5WU0RJWdsG8N9TAC2?=
 =?us-ascii?Q?417wPvIGHt4Tfexs+b8uU5CFhGI2THY/Dg4wbvd4yi+k4ueUTVBpQrPiTdmR?=
 =?us-ascii?Q?W3eaniaRbiPoejtvGKuP4C38QBd6NiTaLT8lXv40nAaWeleax8M5hYRlYxzC?=
 =?us-ascii?Q?qLh5NHkMa1rtItPaw8FRrNRTwhzu4DpdSTHcVyQzFHFh7+hWFYj6zJPTaUOK?=
 =?us-ascii?Q?lp00+8MJTSQNPRx7sHss7pqwhkHq2KE2M1CIv4KpYsrm4qEYC6j0ARdFrbpI?=
 =?us-ascii?Q?Zq/AmCJpgtclxeHydXATgVqM8lW9fPayiVowrbWav4PrJxN3lgG8WmL0Im9h?=
 =?us-ascii?Q?3FUi8V2FyuvBgFp43IWx204xVbr+VRO7qSCyNNMih2lRnwlgHL6H4iy2IiLe?=
 =?us-ascii?Q?XNrvhlnZtDJFQq9Sj9magHScUd/4R9vYOzjAucoyzLVYgyRB4KtVHe0LKtrb?=
 =?us-ascii?Q?URs8r5Fhvbea/dloUjg9gFlobjUExBXIGka78ptop32uLG80oXqUGQxHwqUM?=
 =?us-ascii?Q?fTT+KF/QC5uQETl2SbzISnbRHcmeDhgBUM9ea8cjSnuze5shleXgeMojZ49f?=
 =?us-ascii?Q?KaCBHjk7R/q1qkDdNy+lPjaz2oZIfB00XeX1SLGu1N5L5cDNAqEGmK46mxD2?=
 =?us-ascii?Q?7C9MIodaU4KCRDoRzH2EUdA5UhUN+hqAOR1VBJi4djZozjUPdI57jKPWQ3dF?=
 =?us-ascii?Q?lnGE11w1ohS9JryJonM6WRLgfrnWFAqnW5u4vtoFuxVhZ5XskKDmK8tvAJDr?=
 =?us-ascii?Q?lUBfH4CG5nikcQh3P8huN7xR8ksW2JWoIz33O4x6etc1kt0JtcmBjPSzR+Y0?=
 =?us-ascii?Q?HzA2+8v0VU9WU/suzuBl3Kp9ryjmglT9uHsVly4H/IV4yO/KbWhIdnqJhPmX?=
 =?us-ascii?Q?KD31Q/MyRlZYDVzZW0iixO/CRT4WpcQW5K2z4DvM1UgRB9jZmSY9tpOJoimR?=
 =?us-ascii?Q?Pvjl9FOs+Q73s7AIWSXolgIcme+yH+iEkchfXL8UK1DoM+ptfrLM4s9xunVI?=
 =?us-ascii?Q?h6+9jPXtdgufgQNPxDRzeNGz6eaHkCw8LsWVXHUrGZlCUu3hCcAfGwdCduoE?=
 =?us-ascii?Q?K/f3C+vlGngLJgENtqeFr434TEQkPKewBcpAmR8EZaFgoWfBwGdsNQrGY7Sc?=
 =?us-ascii?Q?1ATWduyKD1vIfIVTG2j/h+f8bPiY+6FcVf0Mv+JW442y/4olq6q+XXlCU3hk?=
 =?us-ascii?Q?d5pjmwpIskqpYcdEtt8n+uHwR4xhusUEBY9ztiHgTjMpY019hFl5uZl6wq7y?=
 =?us-ascii?Q?fkaEDFaruXdfDu2i4c0QEtLLWuQ7fVLZnE7L96AwzbhwcqiZsTnB/icPk/WH?=
 =?us-ascii?Q?14H7qt5ZMQnaqYzKmC6aUyrhVkpHpiYfQ1dSDD4C?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4226017a-a3d4-424f-8475-08ddd4e77f2f
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 12:48:09.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nCJ0pRW4GZZ+wkl7ELghLi1LCbbyTQ/C3TBS3zoY9ji0Nb+LFvfDK/xQCpAU+g++0LVOEOAqYssw9MHPsjShsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7283

Use vcalloc() instead of vmalloc() followed by bitmap_zero() to simplify
the function sdebug_add_store().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/scsi_debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..14e2d6e94dd2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8805,8 +8805,8 @@ static int sdebug_add_store(void)
 	/* Logical Block Provisioning */
 	if (scsi_debug_lbp()) {
 		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
-		sip->map_storep = vmalloc(array_size(sizeof(long),
-						     BITS_TO_LONGS(map_size)));
+		sip->map_storep = vcalloc(BITS_TO_LONGS(map_size),
+					  sizeof(long));
 
 		pr_info("%lu provisioning blocks\n", map_size);
 
@@ -8815,8 +8815,6 @@ static int sdebug_add_store(void)
 			goto err;
 		}
 
-		bitmap_zero(sip->map_storep, map_size);
-
 		/* Map first 1KB for partition table */
 		if (sdebug_num_parts)
 			map_region(sip, 0, 2);
-- 
2.34.1

