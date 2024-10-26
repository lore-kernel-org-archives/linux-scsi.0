Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010047.outbound.protection.outlook.com [52.101.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2DA6FD5;
	Sat, 26 Oct 2024 00:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729903489; cv=fail; b=QfQjIXsKE9LQNhE/RTBXRm4KumM8MgDAPugX0Gc+nSuQBSQN6KtQo41hNpDEMq8VGwxaFK/ay1R7xZJptk72DRG6L+Mn6Nj57zFPa8KODmDPwJLlQrYG1BlAISCYcf+mQxIvwlNm1BGPySaq6ftsSlfJh/cdJmPv+P5kNQLnlPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729903489; c=relaxed/simple;
	bh=XeuBGkARQar1ey4TXtAhkXoaDMIMpQEjcH4n0NJcYXM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=nqRthwTi4k4R36pS2RNUBY5bQ6HBv0YUKcQJE8ufQlnJMG2gk3wmJMyciAbMb63f/wg2idu6c7dWRhhrWXBualOjChHJDs974/I71LmvhAHn3Dx9t5AyZYW8NthvEi4P3wCSP4glFNAMSsZfmJZuXtoEpljS5yAojfP9h0pxHR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=f9MG05k5; arc=fail smtp.client-ip=52.101.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="f9MG05k5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGfrhHy6wxYzFGKqtaLOJo5sU0Z7BcqzXSm3BHPurjTa2BfkQ4Ogop487G2sUhkVxpomzIN3V2Pt1XqygLR82O0kXPOfbv1nH0p5qYxCk8WR6CiVzPOgOip2ZkpNMn1U0u/8UedKaf/4cqLdcvP5KrG8WhjbsGIc9dTFHGB3tYcqnJhSE/KpoGNEH0+l/ayg1KqZCDf6gVhaBvODfxGRfu1NoMwGQ47jByDyddK8sKiOzulqI9dd2jOtXWrFTN0Kl53a2y+nLQqw+0Xrn4efiWTFdchJ7PU6CggLo/5JQ2FXI2V9pzhull7/6NZB5Ju+R6QbeJDoVJ7ck992QUA18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSlHstjouJablQ5tF2tiZlTNtcoRdYtt7Rnbq2geOcc=;
 b=jA+2uVW4HHZx614jMZiPdaEw8kkCe11PJf24qeMn7QchxkoVIYW63dGHHlxlSp26n5xT41mGR8dgg9ymt6TwrstsJvR3xqJ1ltltcw/2PSGkb+RANT1tsDni+y5u4SJKAlyd8Twt2pts1n7rL5kVWLtHKS0fQdrjfzyxnQoY0Yvn04NuZWTZGtuUP9eoGuVnz+JfPnX/F9x0N6BDEnE3HDY/0g0+ilRQs+VUennuJ75M4uo9BPRrdMV2UeDy5jtnWlfejt116GZEVQWgU9dd5gfIWUiONdX76h2mQbZeqFxvqaqSbMo/UOZ9o2lfRy3nshI5u1vjgsUgqhib5hqHpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSlHstjouJablQ5tF2tiZlTNtcoRdYtt7Rnbq2geOcc=;
 b=f9MG05k55mcjeUjO4/diMQmR4wGifaX8hYf0ofuZH+SeEuiLzeSDLjC5a8ha10W0qEp/GjQQXr2ArDDVQGNjiCyzug5CnSgMMYTvCfkmWTDsIgwh9deXU4/K1Cpknkgjdo93XfNBd74AjkLyeG41X+5aeD1Li5xpPMin7ED+Qe/X03v/nsH2N8u6VN3rRjpMXwoWJVjD9Fet7ZosS8LeAMf9yxgB4eVWyuxKlTDA4M6Ab83EZw2scDUAdUGJwuyQaLbjnHe5mOVX5HgQiuDKdOr2+SB87jBgpFeGnACqIClHQ7qG0FXDikYqHJIABBI2OAJDEQ4LZ/PQqg7BimYqZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com (2603:1096:101:139::12)
 by SEZPR06MB5809.apcprd06.prod.outlook.com (2603:1096:101:ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Sat, 26 Oct
 2024 00:44:40 +0000
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a]) by SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a%4]) with mapi id 15.20.8093.014; Sat, 26 Oct 2024
 00:44:39 +0000
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
Subject: [PATCH v2] ufs: core: Add WB buffer resize support
Date: Sat, 26 Oct 2024 08:44:23 +0800
Message-Id: <20241026004423.135-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SEYPR06MB6279.apcprd06.prod.outlook.com
 (2603:1096:101:139::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6279:EE_|SEZPR06MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f2a456-7242-40f8-1d78-08dcf5575f07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|1800799024|376014|7416014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?54aevjlWjTxJS7dlX9eO4XpXp9lMAqHPA1y4J1j+wamoO0c2BfvPAma3Bn9T?=
 =?us-ascii?Q?R0WbivBKhDY248MVFQFFXbFRZmcMdFXHvzAVO38ALVVK3s2KwoEIaoey0yaF?=
 =?us-ascii?Q?K6mP8KE62VSJ013xyDi8ZhRyogoj6vyIFntZGM28KH6sD/UhFLDadkn0k8jn?=
 =?us-ascii?Q?Mx5+sj7ViR5f/r1ycZM58W+synsFah6toNu6VLQdrKReOUwTTHnXXrnnY0wL?=
 =?us-ascii?Q?0Go2Dtn73aiNJ7y4jg7+8w5BT52IE4036roa1/tb+AjrndAYwSyQCa0hMqzr?=
 =?us-ascii?Q?Q3lFehRk66Qppsc4HpT9XaNj0tg7RFfeF5c8w8EGjF+CcWq+6TDHtfChJTdy?=
 =?us-ascii?Q?0Yhpx/QuyWNAHEq1wqu0HXBSPViBVyGLFVgiOlmvkOTdeJouANYqs85c4y8b?=
 =?us-ascii?Q?0KSMHi2FW3XRZupwAw8/K2FyIYXrvXEipvAu5h6Evtci6892y/FWFHpgYwwx?=
 =?us-ascii?Q?WH0o5mR1tYg1WFySO7h7ffBsaZ3T2hMi573Cpxz4K8D/dXKv5HK4XhxfRdhc?=
 =?us-ascii?Q?E7rTI65EL1bSiFuLdP7/zNJbdZuaIkesz4u54sphmg3t2Q/HIRJ2NztJuyNt?=
 =?us-ascii?Q?O+jpAibGbhr3QrtRATRlyCbbwDauM7+OrXOKmeBGK6uNpwA+YhYrRpxFZmWp?=
 =?us-ascii?Q?GG2qf6LFvTGG7ucO9GAPGTKDofYeFxlbiiEPosFH3etgr4m43GnQbLUyu8YG?=
 =?us-ascii?Q?Ct25ZwP/tESuZnRx+Kwkx3n6ulqyGjRvwHpZhAkHuIs7HyjXbxA+XOF9/XWI?=
 =?us-ascii?Q?woczsUtez9Vovq7iy29kZ/yAaYJX0MkyVbkm2qfkTFQlbeM+vHAP3/QkC3dM?=
 =?us-ascii?Q?aqH+M2JNbWC8af56lP8Ge64wcr2M3bhmhe/ihiYgLYXL+s7Ey/0Thb6QKKJA?=
 =?us-ascii?Q?NT37j6v3ca41p/2xi7GsFSwUuPt22r/gqZ4aOMKPfFomPahWLv5/Uct5l5+D?=
 =?us-ascii?Q?aNlyBFqekiuFv5vXvmnkkvTyD9cl6O2kkbIUyXG4ECRV4ryJP5SsHU1L1TbP?=
 =?us-ascii?Q?acT6t5iveJ/ThxTa3XAyssOpmHfm+fPSupfLI4ajo0ywTfjRLxQ0XuVTH0q/?=
 =?us-ascii?Q?esT0/AVlTxMoXXb7TS+uXaT3WZcgL8Io04WJ9+zkzX1LBejTB2OVnw0gzWY8?=
 =?us-ascii?Q?yArsyMYtwA3e1AVKarzwT+BcZWPBy/ye28ibuGIw2ACvOd8ftpTupa3fTrVV?=
 =?us-ascii?Q?i0IFzLOLECPHCKEn+Bck0qzYl8AJKx4IWVVvBZkllUtSEeh0GcToJQYh9u1X?=
 =?us-ascii?Q?e2yujmOSksTPFm4WqiDQHhePPNNMSX6Xc/FsSlPnSL5a+/UVSvh4OAJEKLaX?=
 =?us-ascii?Q?5lJ/o9ecOJGYc2I4kYfRYTOppMbFXO/Ia/rHl7gyJ7hLt9UlFZptTSzPmCch?=
 =?us-ascii?Q?Uyg4kvsJklroyswG9W16+s+X5ZG5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6279.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(1800799024)(376014)(7416014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VZ2N1UjZxm9Jnfz6K75QsQrCBoql0TRtroJdcznTD2qD4xjyzc6Mi8uHrK8V?=
 =?us-ascii?Q?WYrC88lYWvFsXyW+JV1Kf8RBS/2uWPW/yA1amoaWDymQwbFHmhBU9C0pNUno?=
 =?us-ascii?Q?gj7g/N0IWPxOzr6sWw22pdFh/PLGzQFqno6jVw01XaxaxwR8fd20g/VODmJE?=
 =?us-ascii?Q?kgr3h/LDuy4qhRFknYkjrifNiHFV1fXQE95lpNWz1MdiNFPYnoi1Lj3T67Bv?=
 =?us-ascii?Q?Kzel1+8yHx8NxBlrd8vnC8K1KO0tve+PjClAzdbt9TfbZMsfkzsC3j2bfbZy?=
 =?us-ascii?Q?kXngTfPgf0c9pkpK1DKPDY91oTpZMY3y9L+F1CvfKEmLw21Ok2+ZO1+W8D1Z?=
 =?us-ascii?Q?py3lN6S9Ngqux1Y7Ejuy+D+G4WXTHJ7S5b087Io0RtteK14OwbMtIxzVGEWO?=
 =?us-ascii?Q?JpN4u2/FRDAYnzSqiQMA+10jxnCP2lNCgG44Gz/IRRh5EKyN/T62pHHBGKxD?=
 =?us-ascii?Q?Bse/klhNx3Tr0FVXX2X7R6IXQlfViGWOuJ9E8peTe9cv0scet7cVDkTxK5Ot?=
 =?us-ascii?Q?Ksvj6bBbvouphJWmbJYS3CSa50yxiKUbw7tmuSYopLabQq+OhzD7P6zo8vo5?=
 =?us-ascii?Q?6JXvnpALjas1K5Pea37cHMVBenMu/2p8y/1iWKznjucsgRhE125uiCG0zi3L?=
 =?us-ascii?Q?vdQLBzvJlSTI1AnHqSd6urgBYD1bKnp7vtNYaWFNYf9o4+NctJaLTfPJoTty?=
 =?us-ascii?Q?CgPbM6C/FI/xeX8LMhL3Gc6yx5wCwNQawpIWJYsyq2pI1Y47h7hnDH6rR4Py?=
 =?us-ascii?Q?VqrCW9ddl3Ob/W7HGfzezDW1g3bFpX2NjBU/PsgoMYav7GKhgcV8l0vViFUI?=
 =?us-ascii?Q?dWOt8HWxHalW4FmtMKiu/amAU11lFIMYP+H5iwsIDcII6C8YO8F1kRu+YQZ4?=
 =?us-ascii?Q?6vOtL3WheBjAoosIbd03NMCRGVXTIzkBJhFmQp8fsWeYATHAP+WTL5WDbMiT?=
 =?us-ascii?Q?aeZbX9K+mS6vEmkMS/DVDmar3AwFP31Dhf5mB6tvPZRQaxBfZCzzW6ZLEDw0?=
 =?us-ascii?Q?2eV7MHEjPy/3AZ/6AN4GeUCnv9CmggHHS/GUuyGv5kFuJCoju6OqD9w5Uf+W?=
 =?us-ascii?Q?5dwFo/umcEKJtttQhAz0jLu4qUQaZiabYAeDHY11XL29zM/BvR6pbIe9i/Ln?=
 =?us-ascii?Q?tv+VhWvO/JGt0tbHmC280JGLJqA7tSOwwhYefSAmITqAm1pQpWPagPiZTmXZ?=
 =?us-ascii?Q?kQBVQyNCYGjCp6pipqliPMY6q1IVAUzVsS8741JBVpvNvflYE62aSJqKnZTa?=
 =?us-ascii?Q?bfG1UTh9dfWYfy8GWkhEACTBhixrML/mmcCjDsw7qfxSi8H4tBvrXndWiRXc?=
 =?us-ascii?Q?IhIpd8YLTC1mjQFlTulN8KW0oz6+48t/wBeBC6NacNI49jyGYqJYa8qtj1XT?=
 =?us-ascii?Q?ZaNA5kkYxjnqYaAj7Ntab1cHMFaFPsgV1OEwOSNuNolsN/CQMTqPF9bWwg/D?=
 =?us-ascii?Q?ZyllAGujKa+OjD0KOHKjKs8aV0/oiPCBvbGeN8zXvzHUSyii62SzBqPNjsT7?=
 =?us-ascii?Q?MYy1l4RH9rWputq0CzNvsE0A4Lr5h+yHKKvbLY70a4XF2Rl1yS0mTMcvlEKv?=
 =?us-ascii?Q?+ZkIrhyuLA/QZ3Nm8sytGvxDrgwDZx6aHHFUs7ss?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f2a456-7242-40f8-1d78-08dcf5575f07
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6279.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2024 00:44:38.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rk9OdICuGkA1O0VXLHnIxMXSdA1MHrAbOQz1iBwgQK/+TsGKkpu4DhKZtBA6Nlc11eZ6DEcpRQ1mMAA7EouzRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5809

Support WB buffer resize function through sysfs, the host can obtain
resize hint and resize status and enable the resize operation. To
achieve this goals, three sysfs nodes have been added:
	1. wb_toggle_buf_resize
	2. wb_buf_resize_hint
	3. wb_buf_resize_status

The detailed definition of the three nodes can be found in the sysfs
documentation.

Changelog
===
	v1 - > v2:
	remove unused variable "u8 index",
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'
	set but not used.

v1
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 52 ++++++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 43 ++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  | 15 +++++++
 include/ufs/ufs.h                          |  5 ++-
 include/ufs/ufshcd.h                       |  1 +
 5 files changed, 115 insertions(+), 1 deletion(-)

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
index 265f21133b63..bb21982394c8 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -411,6 +411,43 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static ssize_t wb_toggle_buf_resize_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int wb_buf_resize_op;
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
@@ -468,6 +505,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_toggle_buf_resize);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 
@@ -482,6 +520,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_toggle_buf_resize.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	NULL
@@ -1526,6 +1565,8 @@ UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
 UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
+UFS_ATTRIBUTE(wb_buf_resize_hint, _WB_BUF_RESIZE_HINT);
+UFS_ATTRIBUTE(wb_buf_resize_status, _WB_BUF_RESIZE_STATUS);
 
 
 static struct attribute *ufs_sysfs_attributes[] = {
@@ -1549,6 +1590,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
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

