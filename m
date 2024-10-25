Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011006.outbound.protection.outlook.com [52.101.129.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBDF1D3567;
	Fri, 25 Oct 2024 08:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729846779; cv=fail; b=TOi5y2utaPwW/JLC5j0v7iKQ9Q7AjnuZzh4E/1YH6XnI6WHqdw5CewBmYHjhkKj6ePHR+H51XhHGNBIe6BfSNzurKq4kXb4MhXT1xdeXSfF+auUhTbjEyzAxhy6JEjhjW0dpM357iLticfJb63pVttatkZEPAuFZVXEG2e4HVvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729846779; c=relaxed/simple;
	bh=errE2uf4Jybl7cpP1ee5fpQz9tz3Ai9uwLGvjBBg2G8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WDdrpm3gm34G3rfyjV3bS8FbZny3Yr4GCUzv5h04EUqV9NQxSfJXXRSPuDo5rSntkxda2buGQRW/CkKpanbY9ICeEgwsyLISZhDXqyN1+bAQs0IBU5qLxcX+CNEEKt9eMGEXiiefRVSDsQ2q6DDKG7Ug6PkhiZClNFahx0DBRN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=TKt5y2Aw; arc=fail smtp.client-ip=52.101.129.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="TKt5y2Aw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lqf4PC5ipHU4C2vuPi7/PKrBBexo3ztBqLebOwBxJQKTnehF36DVdj/jKFhZPxAL2iHMgjELhqm7bV7DQYNfZ6sq0riiEKrYkBKzkAXOnxLk0BWSSY08+QroJmF1jh2A+glhve1coAEXO0RZatxwUHHHe57zBKIq5WQRzFiB21qxL/NEhNP0B0E+CExlo5a2b9k3n7ig/taDzSkZEDE+4/GYtSdPuQmRxbkgLdq4efXXK7SaVcp+27Zs4/wGc/UiNeQ3K10zuxdqTVA1X77pPEMLQ9Cfpc94fBwEJ40hoqybDEe3JdY3dTbRwo5H9XdBRcVYxJu4+m8COpZrtlF/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4lDB2ybBlxot/AwKu2l3g3n+rrA3tXasBCukcm6Gig=;
 b=k862p/uwOXcN0Jz90R7ei26Gf7OONqUizZtXvzDFvaI/1RiahyMIVw7bKLyEss+64bBwyX122FbCBVriCFtmycj6CFL7VyzmDmdfzLZa1OkPeK6AFXT7NXtu7IjoQ4oR3jK9QnbGc1vIY957x0Z9P6V8m8muYnpv6cdq7gCUfTzD/3x5LUkVOuuYEkE0neZfLrNJ37ilRWjwmP0jHsgGcxjhsmJFCt1YynoMIIiQqyfrK3v9GcLfEkx/TQGpct6y0E16ki0EXzgyHH1Vm/zlVt9paO+d2qzkuMfTu9efs3j6TPxQNfwuEEfdqwU2TCA7n3nFBNHBGDj60ZILbYQ4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4lDB2ybBlxot/AwKu2l3g3n+rrA3tXasBCukcm6Gig=;
 b=TKt5y2AwmO/JknmybgkdHbXZJvtKeYcg0WUKZKQl48Y/rLN4ZAnododtQlFhnepZK+MZZFiuKZgTBu/XpUIHbjeaETFvtJ8pAuRqRYzQS0Yr0R+j9fC9+x3EPXbrvCggkTx9MFx44+2KQkUsmw5CKq6lcbEaMEMOrz0yt5FPwC5dWJtSNYDGpSnfLqupKBWBofjsi1J/VjUFn42aiTzPc7I7lcLrN+eU/R2Dx3KWYnP4A0YDFEAImV1Gf58sAY9L5lKj7pTAesQaUVi2ERfi34JnXiXJMCGDq0Alrc2xUoadf592kWQAnpavAMdxvXnZzado8dzk6OjDGCF4t2ydJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SI2PR06MB5363.apcprd06.prod.outlook.com (2603:1096:4:1eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.15; Fri, 25 Oct
 2024 08:59:32 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8093.014; Fri, 25 Oct 2024
 08:59:32 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	beanhuo@micron.com,
	luhongfei@vivo.com,
	quic_cang@quicinc.com,
	keosung.park@samsung.com,
	viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	ahalaney@redhat.com,
	quic_nguyenb@quicinc.com,
	linux@weissschuh.net,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH] ufs: core: Add WB buffer resize support
Date: Fri, 25 Oct 2024 16:59:24 +0800
Message-Id: <20241025085924.4855-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0219.apcprd06.prod.outlook.com
 (2603:1096:4:68::27) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SI2PR06MB5363:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b4ef25c-fdda-4746-9d7b-08dcf4d3576d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|52116014|376014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hl3P4m16s3zdi8ZT9iP3tD2K5MWsShofmhXWOw4rLHzWDpxByTwvIFmWMp4B?=
 =?us-ascii?Q?7QTC1pSSS953xMr6UcLaSrLxmJnybgD8+LvAHkvx75EBu+Ms35RxZV18B9GQ?=
 =?us-ascii?Q?/Y/2jHNPwAy/zQ3z35K0kiAg32xjCcCd4/N+jJ0r1D9APlhABKpfs2NUriEP?=
 =?us-ascii?Q?z+dT4YIWZtTC1ynBxU3kr/1yeDQq1SM0GGy0B1sbtFycuP1d4WuOJWrOw0w6?=
 =?us-ascii?Q?rzOnx2a83SzBMCfryUP53/Rmwm2t83hdgkKyJHJv2nBJCof/NecY7RxRI93J?=
 =?us-ascii?Q?rqjKTMYHJUxUbBlJ/h8tFkAl4oKiw2+kU41huCHZbFUTq6MlMk5XQdM8b8VN?=
 =?us-ascii?Q?e3lmfv5zyf9LBZuVl3pA5jIl7k8U7osOWnNzQdD8aR6BykBS9F7G0FUGZrRx?=
 =?us-ascii?Q?o+j6ApjZ6wgeHEjhTnAjBIUsfclcBGKRQRzCn5RKzfs8KUrYaeDx9nCjl3SL?=
 =?us-ascii?Q?dEqHnqfoDXy2vt+O0So0YzkKFAT3XIuWmDBL4v8LYXKoJRwJRJm3+xdqSSKy?=
 =?us-ascii?Q?kLIKEjihtAtQk1zHJtMty7ALpNosccKYJDFtrp4ujloLvwh7p0yMxb2XVNZl?=
 =?us-ascii?Q?9Rp66KZl3wMsJuQiu077Nvsh+mq7dCA3a2vixejbkzuLx1yd32iqmbehT0K5?=
 =?us-ascii?Q?AmR0/veWXgoYvfruXqxUe6DyDLvoreHydNBgsjchMP9S9vY2fHiQYtCBZSeb?=
 =?us-ascii?Q?STjIbl6OP8FeG1WWt0ATxQfIMgmMT9nSffWhFUdvg4JMQg96w02i4S6aebGy?=
 =?us-ascii?Q?Ek8UQmP5Q2fQizORpLrX4vS2QGUNcLwx519v5VbqtyGFdjGVc65vA8pWPbm5?=
 =?us-ascii?Q?RDtKRUzQfnBt2xJ/VmQDBTCi3sRYo37AWfa5J8mts7t0F+ERgrPDikHUpdMa?=
 =?us-ascii?Q?tUvZDZ6WLG1v9pZFaUkjH4Y4QKJgyXVS4jIsldRN+nAVApElAXdDDKVesiVV?=
 =?us-ascii?Q?DIYrddddEAGaYx5HIAz7o35RFb7tBqoJw8IEkO5rlrWc8qHMDIwEr1Kb4y0b?=
 =?us-ascii?Q?YeKuLPZejFuTKVQX+SPCN9nS10hhF5KPeo5/Fkd0+qx6ZX+3FP3i26p0hGhv?=
 =?us-ascii?Q?Jr5Hmgr4QK+SXBtrCRscsuj0/AONTfZq/55w021Ya3wxrXGMPwaA+vNUjWZ7?=
 =?us-ascii?Q?UKUXpNPunHsuo7PcyrTDDzh21b0WXcIF3nuSTMyqible3RGhjYtAhWDw1d3c?=
 =?us-ascii?Q?k2gdap12v85cQaYVd1U5oajgceOQfCd9hNex8UJx9Ikh6OZ2gkbDyXgg9pir?=
 =?us-ascii?Q?LBin97HCz4BhfaTOPgLG7IG6XsKmL16mX2h/jzkb9Ef8ZA8Q795lS0JaUf8i?=
 =?us-ascii?Q?8In09+dRHmmI8OTvX6ke7colkwnSSiC8rhG/NO/Pi0/EFQ/s+C6EBt+rloDF?=
 =?us-ascii?Q?56q0ia4Jf6e4rMckaY0k4Ljj2yFu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(52116014)(376014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ROQe/zfRSyG9DdSCtDo/YDpiJROo/BBYfxk6WmWKmc+6FGJzPnaFNB23J7lA?=
 =?us-ascii?Q?V/mdSOdQBKiinNXDR8vKFF+n7jRGO0oC8zLcBa/+OagdftAJAFRZOO1PMDup?=
 =?us-ascii?Q?dGe/xG6YZH9YD9ZTBi02Z+nN4t9xXcS8jR4d6zBTF4q6DXKfcG5p5hZPoOQN?=
 =?us-ascii?Q?18/dt7ZP8nv7VXpq7fMpCK4KPxZBTqPnBX0uG64yedZ2pR5Ltu/8Z+h/bfWW?=
 =?us-ascii?Q?lY+eM/gOZc06Reu1gs58v9xrliG63Lc5Mj96Cqc9V+e+5siwJp+DjY49EfbD?=
 =?us-ascii?Q?lc/atxBUJNP46lR2CNsaBqMgdtambGIfbWVHR0ZcQVEZuio913xqtpmgnzjI?=
 =?us-ascii?Q?kqxtGhvhScPrPDh2bUqdYSWM8jP3RqW/t59X6jPvrycC1A8MGEU4NqEO59nI?=
 =?us-ascii?Q?akbQryNwJHiiiDzNwVZfWlTC12fN9OGgn4ELemjnxtsBMQ8/jKzi+LZ0bMi5?=
 =?us-ascii?Q?xtxLo0g1gJELEqYfkitpSPda4omwa+SGGcZpWuFabGBZdv6F2J32yasgMR8Z?=
 =?us-ascii?Q?kkyyqgnDRfEkzqsCIj80Bx5qO2OAURudTfojPrryyqnvVH2rDskLQYBN62U4?=
 =?us-ascii?Q?+/jPzJidsu8bQfkniTYOTNU5z+xSXG9MqdSqFh33589hP6eoL9igod2GflAJ?=
 =?us-ascii?Q?ktr/90QFcAvGG/kcfhoBO3olpFOmiKoJ0TNX4jLGSzGGE7YzMHyskn4OKqp3?=
 =?us-ascii?Q?zGBxHeLLblKQ7M9gBkNBjpYTQpQshWa8Jcvy+E3BmaYtfbsCFQsT3AnrDXJT?=
 =?us-ascii?Q?9R/+BhnfeT8XExUCrwV2CdJWgqQYurIKJ8te9HM5DxhfPtsmIAXwH171sQiJ?=
 =?us-ascii?Q?dwLoQ4E7vtvkX17TsfTdLmSI7VjrTaJTr3iYFFrIvEP8Dlj9diKfrFhFEI5T?=
 =?us-ascii?Q?n500PT4qrGeINIuQsXVle3lCkgkzL9VlScB7ai17AAcfyRvhAvER2n0IkAKU?=
 =?us-ascii?Q?s4nGJ/z7Cs8rDogdWWZ8kemeHZTzIWjsdq0zsP0uBoQ8CAl2U/BygXjIEGs2?=
 =?us-ascii?Q?MDyV63Xjgq9D/FObuw/XWGb0cZKc1M4YzrVDoaDH/H6t5onbhtpiAnrlSQBg?=
 =?us-ascii?Q?GTWGo5cJ7MJlBwczUhmLPeST9c1EE/+bf5lQ+b4LnYfGEWrLUkZxYK7SxnOs?=
 =?us-ascii?Q?+Lgeps0PYZ/rEMLQbjiJis2rv0Mj4mh43jMHzfSTJBhWALf0L7Z2Cnpwlccd?=
 =?us-ascii?Q?9xWl7MgUZ6mcIdPWpdnm3qD4Yf9KEE4PtThuXCC23uViSbEv1xSVuXpIuwth?=
 =?us-ascii?Q?NCBqyC7A7v/Qd+gRIsn1MzsUDV3TO572xuHkSSIatOWQb3HlVASoJIRWYVAP?=
 =?us-ascii?Q?vihAgkzJX37d7kddJF1hQhsL8tgVNeeTS0bNe/h0uCJ50Kqu3WuO1Hj10Pgy?=
 =?us-ascii?Q?4AK5m5rt3qkTEHkt4qHWnDRcy+VEcV2+ReBTbesD8/ugVeWBd6kCm78ZnRxn?=
 =?us-ascii?Q?B41IcKkoVOKlICEJPAd7zcbhK8t5PJDS8EIX8ebVSFd2/OD1zUvHAye1j2IE?=
 =?us-ascii?Q?L1yoYKe5mUjDrxR3u2UHYfY8tZjHrw6VHMXKbZiunk3noZW/wJYCUHQf1zY3?=
 =?us-ascii?Q?o2S8uTvccYE4QbFsaGa5zxCJeKSa7qNNfMk+YXGr?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4ef25c-fdda-4746-9d7b-08dcf4d3576d
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 08:59:32.3385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YeAGsYPa750qX6wJdXkwkC7tJCDFNBGr+BugBppWBNN3cA1mqLbpNvv2R2dKrgkZdceFbpAIkvqTSUB1BuCxng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5363

Support WB buffer resize function through sysfs, the host can obtain
resize hint and resize status and enable the resize operation. To
achieve this goals, three sysfs nodes have been added:
	1. wb_toggle_buf_resize
	2. wb_buf_resize_hint
	3. wb_buf_resize_status

The detailed definition of the three nodes can be found in the sysfs
documentation.

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 52 ++++++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 44 ++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  | 15 +++++++
 include/ufs/ufs.h                          |  5 ++-
 include/ufs/ufshcd.h                       |  1 +
 5 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..dbaa84277801 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1559,3 +1559,55 @@ Description:
 		Symbol - HCMID. This file shows the UFSHCD manufacturer id.
 		The Manufacturer ID is defined by JEDEC in JEDEC-JEP106.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_toggle_buf_resize
+What:		/sys/bus/platform/devices/*.ufs/wb_toggle_buf_resize
+Date:		Qct 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can decrease or increase the WriteBooster Buffer size by setting
+		this file.
+
+		======  ======================================
+		00h  Idle (There is no resize operation)
+		01h  Decrease WriteBooster Buffer Size
+		02h  Increase WriteBooster Buffer Size
+		Others  Reserved
+		======  ======================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_buf_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_buf_resize_hint
+Date:		Qct 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_buf_resize_hint indicates hint information about which type of resize for
+		WriteBooster Buffer is recommended by the device.
+
+		======  ======================================
+		00h  Recommend keep the buffer size
+		01h  Recommend to decrease the buffer size
+		02h  Recommend to increase the buffer size
+		Others: Reserved
+		======  ======================================
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_buf_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_buf_resize_status
+Date:		Qct 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the Resize operation status of the WriteBooster Buffer
+		by reading this file.
+
+		======  ========================================
+		00h  Idle (resize operation is not issued)
+		01h  Resize operation in progress
+		02h  Resize operation completed successfully
+		03h  Resize operation general failure
+		Others  Reserved
+		======  ========================================
+
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 265f21133b63..41de15795cd8 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -411,6 +411,44 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static ssize_t wb_toggle_buf_resize_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_buf_resize_op;
+	u8 index;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en) {
+		dev_err(dev, "The WB buf resize is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (kstrtouint(buf, 0, &wb_buf_resize_op))
+		return -EINVAL;
+
+	if (wb_buf_resize_op != 0x01 && wb_buf_resize_op != 0x02) {
+		dev_err(dev, "The operation %u is invalid!\n", wb_buf_resize_op);
+		return -EINVAL;
+	}
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_wb_toggle_buf_resize(hba, wb_buf_resize_op);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 /**
  * pm_qos_enable_show - sysfs handler to show pm qos enable value
  * @dev: device associated with the UFS controller
@@ -468,6 +506,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_toggle_buf_resize);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 
@@ -482,6 +521,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_toggle_buf_resize.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	NULL
@@ -1526,6 +1566,8 @@ UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
 UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
+UFS_ATTRIBUTE(wb_buf_resize_hint, _WB_BUF_RESIZE_HINT);
+UFS_ATTRIBUTE(wb_buf_resize_status, _WB_BUF_RESIZE_STATUS);
 
 
 static struct attribute *ufs_sysfs_attributes[] = {
@@ -1549,6 +1591,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_buf_resize_hint.attr,
+	&dev_attr_wb_buf_resize_status.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 630409187c10..c28915debab6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6167,6 +6167,21 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
 }
 
+int ufshcd_wb_toggle_buf_resize(struct ufs_hba *hba, u32 op)
+{
+	int ret;
+	u8 index;
+
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				   QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &op);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(to_delayed_work(work),
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index e594abe5d05f..f737d98044ac 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -181,7 +181,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
 	QUERY_ATTR_IDN_EXT_IID_EN		= 0x2A,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
 };
 
 /* Descriptor idn for Query requests */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..cbe208ce9293 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1454,6 +1454,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_toggle_buf_resize(struct ufs_hba *hba, u32 op);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
-- 
2.39.0

