Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010069.outbound.protection.outlook.com [52.101.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65695C13B;
	Mon,  2 Sep 2024 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725240809; cv=fail; b=S0N+u8MlEVh04mZia7WVHJVZACLXxU+AgFmyw4VXQKiYpiwTZw1jjG+dvEFA9Dw8cSKVxIE5D4ENjrvXD296rwitL78E69L/R7cJ0itoOQct1m4ZN673O6oeFC6AVkgFLgBbY3MbPksFyR5IMO1uNZj9mGOYv1qFL+rZRSf6ZDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725240809; c=relaxed/simple;
	bh=CPGNYSwoQd4/x6hCFhezwLisWU8U4lF9tp96dcLVigE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Zj52Ek03q5ZYk52SM8AcIpm5iV+jvYEWlE84capzW+KYsVpNQt0dE8FijNlTjfoLzu+wRtf2l3U/jNRMgOB7XloTIhzo6WYzhG8Z3uZcy8AJm5/XBhqC+E5MuesvnZtEqhXQLGnbql0tc9VVOSfWzclmxcHig+laVIp5m18RhHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=IMHHduTq; arc=fail smtp.client-ip=52.101.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="IMHHduTq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxw0Xgqknb0GkgjTHUQXF0gkC0+0Hvb8omMlmxh78wyyjDyeMtcZHDTswIiL3632PWkkdTJg9cxsOmW+ga91ZZtjDdkusS5hWG43XtyGID3X9+G+6PuKwaBIlXqeEZaWopy4HghCIKXF2ambtf3lx2zFOrvnqG8+HM49x2VUs+zX52qkioBNH7D0UfObEhqrFVnblxQJwjpE+lr2/LKBnk9X2UI/q4QNvsbz9w/TCyshcscSpqJGISnV7zeL0LBhhDu+fYXAvknghV722GutdTEbUb7VlXiAOTOKqRLF5jB9bUQTtZy8xqetbEleCO9NVXZ0TBK6e2+O9M6qGAV7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UQy9R4AgJzXJhP4rBcCnJHEcgfhrQBU6GZf3EmRCwc=;
 b=MaD/4bJDJk7mR7QwVyNKIhHGyoPC9V33sttLyKiUFgaZCKw8UKQHf15qtkNUOAj0+zeZQHLIUzkx1Jggm1vRNqSrGpEMrKT4yGCTSKC3EK7qUOfsvpUz2WCi6O8wQPnptAA5cKKGuM+vGv/2GoWz+uzknp2zheC2MIMyFqPrNRhPEAsxqZQnzzpefAZ9HQHhFpB/l4h6C+M9dp5VadCYC5X7M4MN6bgx0y6yja5qPK4EyVD7csT/IqY4E84O8evkrDeNL2Ux/hk6ik1GO1Lvcn76SG9y8lSYMkx0NpY7LECk4CqMRTvFcxPvrqEL2JvdWpEYXAzIyOPafGChK+98QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UQy9R4AgJzXJhP4rBcCnJHEcgfhrQBU6GZf3EmRCwc=;
 b=IMHHduTqRnZJaApbpkuTkKyTC8Y0xfcyCAXvrQPC1EaFxujwb6gCAMmeiHSdK2LwLnboni9Km6ZkVoBD2m6M3XmaG09oEezE72pWjGJrc4XDs4XfrnodlMn+8n4DwM2pFSKZsuYoWC1ZJKKvcG7ADA0fPcHpLSY0qU2pZ5wWwPYPS/ZqXHq2D2uDwVzXzghJ5z7QZEP5WS6Jh43dRQq/wvVhr17+sYLOQuQrXe1Hox/MaY2ZWH42LBntynYBKir9/3PEein1/dyceYbY1bZZ1RJXBZNCOzyjMgFsI/+iSqZXn4D0k5kw5OGqrQAa8234r1hrsAr3nvayKkye+OSCzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com (2603:1096:820:31::7)
 by SI6PR06MB7148.apcprd06.prod.outlook.com (2603:1096:4:250::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 2 Sep
 2024 01:33:22 +0000
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1]) by KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1%4]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 01:33:22 +0000
From: Yan Zhen <yanzhen@vivo.com>
To: sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yan Zhen <yanzhen@vivo.com>
Subject: [PATCH v2] fusion: mptctl: Use min macro
Date: Mon,  2 Sep 2024 09:33:03 +0800
Message-Id: <20240902013303.909316-1-yanzhen@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0025.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:381::12) To KL1PR0601MB4113.apcprd06.prod.outlook.com
 (2603:1096:820:31::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4113:EE_|SI6PR06MB7148:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3db739-277c-46c9-88ad-08dccaef3b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HwcTIMiBchit+CF5fHvL8sjBqHWeJqiNArXnuTT6o0lczBom9IMgsfcwO70E?=
 =?us-ascii?Q?kHt5ObtiAoBHu/geWv/zRbr1veQ7gYOdLU36Y8CRbyfREVkArGWDs2zU0n5L?=
 =?us-ascii?Q?BqIeyQkH9XdtqQuZGiFflk66/ROeYPmUP5IJLm4WyUx3ahJ7fNqwGR514tGu?=
 =?us-ascii?Q?63dh1cthRquzS0wiYGohK9FLi6YKUKgLkylBjQq1N/trW1eqHOF9QnC34CDq?=
 =?us-ascii?Q?r6wZybxVcMdbKQTPPu+3Y5qHzsrA3ARliro2TE+WNAx003AYiNXo8Rvyc0B+?=
 =?us-ascii?Q?4VhSyPACBtFtS7vejGqHBN9psDCcUe47c6DlqNdwedbPMeKK4mytSg5PTFUZ?=
 =?us-ascii?Q?eq7feJFr51TJWoiKOsXTtC11gBfPPiT4OZHjXlbJ2hFBHFfRF3xA1WiglKdX?=
 =?us-ascii?Q?pyp2huwLs1uPoIC8MlRm7fhAPYT5ZbLglqllrUkNKZntDX4omSYMXbNc7l8k?=
 =?us-ascii?Q?sJaF8cD9gvlmFDN5YQkEI2Xd3fI7IdMgwG3Y7xZbLxXmyR1cSzfj3HBNYN5W?=
 =?us-ascii?Q?h2MOccWeszBaQvT//a0Z0fbphGVjhAo0hPz9rXrG9Muozns1E6hySAcOh7hz?=
 =?us-ascii?Q?Gwr8qrbuagSOyXERCVQB+XZ9kt88vMj5LeKOxXeKAyhUoX5nymJECB+1wgXA?=
 =?us-ascii?Q?gXN6qgjpxmRV0dZVUQnm6yDNgCUHMAnSN5BQE/LbjqsSpdjD+PzXGQDrOfcU?=
 =?us-ascii?Q?RDpx6VeBFIcm42APXAyVrKRuXi/9TRR6aiFi+clkPVhhg17KQe6BFtCyJ3fO?=
 =?us-ascii?Q?YN1o+AC7GoC8mIX3nyCaJ1HApvfPhUmWQjZU7vy4eiDyqh2Map+wtAqR3AvY?=
 =?us-ascii?Q?w7hBqDs8tdDNd3s7qKVzjnJvaPxe0SBCvUgefMMzeWgqE5tkUf/hBdo5AQCj?=
 =?us-ascii?Q?FaCRAQkQ8s6cUb5IJ6+4Kp9a1fv+hq6lBBd2vE7a9GHPq7VEE81D0G7Et12Y?=
 =?us-ascii?Q?1o3GsOLFE9cWLc56DnF2FXj2Yr1BSYhNcGdvlKx3tNjt32w0zDQV19DSr/9t?=
 =?us-ascii?Q?Gb2TwNx9jR/jDNC/wdoqGultwbzWweBfq6cSxcl2irOZCcdvPg0MYCbzTlHr?=
 =?us-ascii?Q?9Jt7puyTpwldCFy6UDfXQVFZNBaAIVbXbQ6pUyffgJ3ExvYqNHKoA1ubAYRW?=
 =?us-ascii?Q?GnCvP/rBZFCrzzIiZxHUtZB+epVO9b44Htg+ujDRkl5WCw4ZiWe2m5Rj4RWF?=
 =?us-ascii?Q?AyIPVD0KGTLRZ8YJT+MY5v+ZPeJfmtblP28Q8BiGx+igWq+zoPCG5M5URzC8?=
 =?us-ascii?Q?5Glle8zh7X4V3Szfjld6ZLGkLxsTG3yPCUqhlGWAWJLaK3pn0WXnsbLtKgK0?=
 =?us-ascii?Q?mpWv+PJ2LBoIZpxzbYTLGM9I6pkX5yvgBH7wnuPA/xiW2DqdpyKuUQ9BwQ7p?=
 =?us-ascii?Q?yw7Bwj1RJhJ6N6QK1zxpCN60uRHRjazT3MLTluc6Ler053+o9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4113.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jBglSuPqwiw+JlOaRRhV2l23Y6IG+4/Bs1KYHCcXoMlbwp8TRl/IhLQ/7AXR?=
 =?us-ascii?Q?pAHxlpAs98NXEtEkQlHK4vbDWI+uJeGsAzh+2hJwU379VYY9uqfVuCbtCc11?=
 =?us-ascii?Q?ZO9leFpNHzxdOjAPN7bxOSoML/VlhOMjVXNogiFpXORtrTflY6pL7X3pUQHL?=
 =?us-ascii?Q?v2yNRg7ExvP+lU7bhBdfnLNcAwPQPTsX1rLtxf/Vslxs2uKFISCGaBFwENjv?=
 =?us-ascii?Q?DGJ4xVOkGu3A+9xrKA/BYPldOY6LR8LNLpW4mwJ1SgrimH2o0rEH0ppwX2q/?=
 =?us-ascii?Q?BxaidiEU3aIO+8KD5kRc2YFEEFqijAywNkaVMYM4gV3XvRzFU14Sg3KORV74?=
 =?us-ascii?Q?YIpG33WTDUiZAWANaY+vnzexnRd9s9SdwpnYBO/eQj1ESf+TrC8G7y+Cwx0F?=
 =?us-ascii?Q?vYdBEk1rD4xRQK+kiVrWnPAPfj9sn6Y2Jb9w9sbhbEE7hBFH5Bl8i4NEyoV/?=
 =?us-ascii?Q?G857wQkEQ8L2pJWkwAAzu6nPZYWIMbFktXKubm/MWqg/HHxnPwOmQKY1YWSz?=
 =?us-ascii?Q?RJtX+JCGW5OvnQR45yUBmRbNNPR/9LUytM2LvAT59r30vuBDpgz7jJamiheE?=
 =?us-ascii?Q?Uu3vjjE/vOfVZcuvjvx63HiYU/kOY6IjUG5efB6yk9YHUsxdAW/vYuq+cIzp?=
 =?us-ascii?Q?FgRdex53DtPrUV/c6/8oy+TF9sZQRBOxa+pdq1l0I9QY3wAxAiDYoedbKZa/?=
 =?us-ascii?Q?ovXuOoDM2xlTkhs6CZ6wsoca/JjMUiYe0pnjIL9vMiZMB/BOzP6krQpNVR18?=
 =?us-ascii?Q?twqEHmTpv+uFa5oPIEm1XqGNqT7178whcwMwuyxQs2TXFmUF4SqEiqnCXOMT?=
 =?us-ascii?Q?zB/jXPg0DHqrinsOam1x0cDI37BrTpLywHTBC3pGEAvlvZOVGvNujQ9CvsI1?=
 =?us-ascii?Q?tLGopfoeYFe8wHIfo3txq1gqxx0G3D/8zTu+4q3PP5ApC0UIJiK723S1+tR6?=
 =?us-ascii?Q?I76Ja570r6ha806S5cFj5SQByf13naeVaUcgEPcGrBxhsAzDXZreov94uoVb?=
 =?us-ascii?Q?y9DrXoLeDjZ30TP7ghonAZxK4yNGNnu6bARbw8zgJeX1fhSa49BPXu44M6An?=
 =?us-ascii?Q?NDYrJ/39QHJmE161B+Dd4t0nS5Ecxk2XA/1ar+v/N4hDD4MnvjYfbFm6hcua?=
 =?us-ascii?Q?CouigGP59eWTXx/L7qDARSJUbRImwPsejBuwI5ZE+EN2aOEJx+0dceyNqZuh?=
 =?us-ascii?Q?ZG56Zn3Z5bE8KbAvVsE0sqk3U1snaG79xLBYaQWBmfzirPTA5dbnL66wWGxX?=
 =?us-ascii?Q?bqPmoGStbv0fo9rEqprD/QgLeKaV3kMzLS6mySi9FJ2M4gDzZIHvr4PxCtyL?=
 =?us-ascii?Q?i4rS3KojRjvRiyLacQOYgynK4CODjeCUk3jTfj/CshMmvsJfD4Hnio4MAXTc?=
 =?us-ascii?Q?x4KBELG4JCfZVDjwLdSIi9lxA1XQTmp4RbTEHqYgVH2UYX69k0igSRjtJBBr?=
 =?us-ascii?Q?9gucGWOvRkGJ8h2nB/TKEk1UO6c3+l6bzWi0QcDu/LS4Q1VdVU+MWNEr5r5m?=
 =?us-ascii?Q?7ZCTCTVjUBS/4m2aPjQ4ruVs1AGpMjjCy2g5EBT5oHR5wj1Mrjw0V8nEf+kX?=
 =?us-ascii?Q?cxgx3qJKYFLLVuLnSUwpW5VMnc9W/pJwhO3HRTd/?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3db739-277c-46c9-88ad-08dccaef3b47
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4113.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 01:33:22.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1yl/nQmUIKn6vfGAsyvUkDCGHcQlfTZtQtYg9XPh+LURyZ1TTTznDOGGcCr1lStPhTIEXPf8TeuUSVBTq3EjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR06MB7148

Using the real macro is usually more intuitive and readable,
When the original file is guaranteed to contain the minmax.h header file 
and compile correctly.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
---

Changes in v2:
- Use min(variable, CONSTANT).

 drivers/message/fusion/mptctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 9f3999750..17798edf7 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1609,7 +1609,7 @@ mptctl_eventreport (MPT_ADAPTER *ioc, unsigned long arg)
 	maxEvents = numBytes/sizeof(MPT_IOCTL_EVENTS);
 
 
-	max = MPTCTL_EVENT_LOG_SIZE < maxEvents ? MPTCTL_EVENT_LOG_SIZE : maxEvents;
+	max = min(maxEvents, MPTCTL_EVENT_LOG_SIZE);
 
 	/* If fewer than 1 event is requested, there must have
 	 * been some type of error.
-- 
2.34.1

