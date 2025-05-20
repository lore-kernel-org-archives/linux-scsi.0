Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012010.outbound.protection.outlook.com [40.107.75.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26427288AD;
	Tue, 20 May 2025 09:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747734072; cv=fail; b=ZoE0omL2ml4cgUAdAG9ejMs5mclXWPc9LxDkYRUzQB6oZfU1g4AWHROzv6UlDk3P2GplmbY9G+f5r1vXeo1yH4+9HXaG0fVViW0N8BXbO3oVj4A92C90Pc/4UMN3KbB98A3dVTXgwLc5WCIruldjdbdI+h6UVvOBmHWO+PS9bLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747734072; c=relaxed/simple;
	bh=tLA9Vx+3W6DLMYwhUvqBm8/4ZW9HKUFCdx6GNVPzi1M=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WzQaIl7o7BdTKsEugFl5nsOF0XcEJawUIIsfSC4WJtA44vOu/mnVzBn3CBMzsLMQyMAF9dVZn3Mjo1hcjrQKFpuS3Fob0nQ23V89UeTWmLvOcvf4jWDyeyNOFesKnJy2X2+YdCFRhGd2Ce7bb/lBqYSxc20fqbe3Ypdjp7Mu3Tg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=DgqFhN4Z; arc=fail smtp.client-ip=40.107.75.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="DgqFhN4Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4OCwbeU3lKL3CHCixOf02uj5zgITddVZa9DW50+29oajNwHfauV2y/caaTgSDceF9xZZxuc1hoY7TXXWxPNrNAPbnWCzXsYe81Tr+EdpPTGFrGM3AoGhDw/q5YXwzretWEWxrNltaXvHbK+XnaQaXCTTxJoL0GbteD9WJYVk0MlfD+rk2cvBav9g9zw6KpF2Kmv2WMuH1BgpJZyxfaJErgSt02jxjpWY4B2AZsJ0ZYM1z3bvjmwguYf8UCbhiWff2Fmtuxq9XvE5UGq1pIlID1xV1jT0OlmDXN/xD179EGIFw0GhvGU865z2s+qLzS8czKU5fNt+e4eqCuIE91JWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6U7XfvmslP7rfRDReTWwtMdL8W6VWEA8Gb7vUddPcE=;
 b=l8dROi5gxP2d2TSQ1NgINKkFwqfkxHxN4KR+3DioYINArfrbwl1VPEucDMjK1zwylTApyUQuUlx3ScDYUxUaKOfLsUFmlBXRhA9d4OFtfu+UbidiWPEjer6kZx7rmtufjQZmhIJV98igr/ucxV8+vESI3LUrGYHfJJ6cfTvI62ZpZeJBQe/UGlfoJpX1E1pjM3nyV0rotqrW6OnjXUlwUTF3Sj3MGuAvHcTTxf1q00Bp+W7TtMYEpMerHR9uGRpJTsVi1g+Mdb0mTx5l9huXQ0ampHhL/PiXYsn1WmlMb0eHWRcPoyX4sZ9N7uAb4jfhHYAwjsIQDdg/60TUYpbIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6U7XfvmslP7rfRDReTWwtMdL8W6VWEA8Gb7vUddPcE=;
 b=DgqFhN4Zu3/KZtE/tNveUXPjvLlV1LBcivLkRPG9y11ad3O+5asbeSOXWnJmccg/XJq39ZSLNKiEMEHz6Z1JrOJfWZFRuozuH/tk2Bu6t81fbxNdEllkcApcfB/seXBlaZV0+zjaRJxMHqcJ/a45C7mMPjUhuPycnCoYBXKBRFT6lRv+9wUcWRmHNNLflPVZJKI5tpPB8WFGAcp7VVKmhaI96EsIH05mmjGcyG5MVq66vHAwfhBlAtCjnHDs4J68W3EoIKk/plvTkvMFCd2T9oVREJMEgJCJylNIjJZPx+TF46/B7zQazfrktO6IoUzG9nGHJIQyaxSnRI9bGLAPOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYZPR06MB5507.apcprd06.prod.outlook.com (2603:1096:400:289::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Tue, 20 May
 2025 09:41:04 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 09:41:03 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	luhongfei@vivo.com,
	tanghuan@vivo.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com,
	Wenxing Cheng <wenxing.cheng@vivo.com>
Subject: [PATCH v5] ufs: core: Add HID support
Date: Tue, 20 May 2025 17:40:54 +0800
Message-Id: <20250520094054.313-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::12) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYZPR06MB5507:EE_
X-MS-Office365-Filtering-Correlation-Id: c45359c9-9c0d-4c31-aff5-08dd97826fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V0C6PuLvJGk8SY4pxZKYlN+/bxG4qq07z0po3X9RuXlOIEs/0fkB7/kqKTcy?=
 =?us-ascii?Q?3fZ+UHGhMGjZ44OeuqqR9xpGhIvDlLKA0tGX9kMYaZ+mPXWosfJGYqx/kfKi?=
 =?us-ascii?Q?egfgzBwozYuAsx8/9N96Q9nj7z4l5DBur26hOlF73Gp9AGnXcF4UeqJ53na8?=
 =?us-ascii?Q?t2rkQ0IV2BY8gPUSoIfKV61Bd9KdkGs+ifh4SDEzUPSfbpEyxZIITiYErqzZ?=
 =?us-ascii?Q?lzzdE1OhIIpozDVoNcO2pby/FZkk074T3HLauqJvSgeXrgFnPD7NjeFdB6zG?=
 =?us-ascii?Q?X1OWIvJO1PUALK/WLw48JNtgFoNIzIAa7po5pifYLWNTchmF9yEKG5gEnb7Y?=
 =?us-ascii?Q?GvwxpTvtJBspLPVl4FY7Y7xs1h4OCzDCQq2QPG04N9Wbc/mJxNSSLWx9Kvsg?=
 =?us-ascii?Q?H8Un9yGLemFUCZjSklBvBd+uzZdYBBnbetpzFuva/M0/NGdUVx4++K33ctq6?=
 =?us-ascii?Q?hOi0Fi8KK4dsOXvJRvOdPUhcoNzh8E6owjl585GTnSJcMY+zcTBI0AMRVX7M?=
 =?us-ascii?Q?V8L4jXpvAlKzkC40DiMjdHAPLvuXuGzoStAwhIp7dRnbJL9s3QL7fVXDMklc?=
 =?us-ascii?Q?rGFjC+8ryhWmdZ+D9weobos37JhtWMsePcuhTXLKvk1iiE1X32/gy5YD12Eg?=
 =?us-ascii?Q?+/cL3UATl1u+ERjxU9hvV3kMr8Z8Dg+utFIcsxal61+cbtnpDPLyMhRqaGzG?=
 =?us-ascii?Q?ihVYO+0Ri1IAnlYQSF3vCH7nBDWG5TrszQUJ/GxFeB90kSwaUNCx1N2QGfzp?=
 =?us-ascii?Q?yPpcD72eOPRQ+cpVNYvqcn5hf8ZhKhRcRmRaW5OmR0bhRKLPQnGYjkd0vrPA?=
 =?us-ascii?Q?pzVxQgelJQXiYaFYDy5cDl6wJFPfr5+j1ekTOZq4OQOeXhaBSMS6CRQMZKRw?=
 =?us-ascii?Q?mppwAPJ1OvMFduNZ/HGxv0GPN4B3MPUD9FPxCFYmOW8F79sqfNnqP/ETxoBT?=
 =?us-ascii?Q?bFi8/l4RCW0ew9WrAuRmaaufF2sqe/N9G+Y6e3HD3FgeRctCWb3HASO4WYsk?=
 =?us-ascii?Q?S+n8cCOJadlcPEAJZfb3nv0AqC6mSY85SKiHNWHNQXiM4JstdqHEY5Pn1HKv?=
 =?us-ascii?Q?BO5Xevo4l7N3ICV4a3TVleTFPLiTcZFbG0FGp8egu8l8ReYyoD+qHz35rKNx?=
 =?us-ascii?Q?dDeUwQxF/FgNaCv3nyXaaaiEYSbQXOzS5KNK1kxXjVQUGdes140/0QKiYXCv?=
 =?us-ascii?Q?lCmvcQfJD+TSzaOH5pJAb9Spp6DBY86xhWq1Xme0DcTjeCNefGf6dhbSy50u?=
 =?us-ascii?Q?IXR1LWTHxcmb2vtNOeaEgwpfKoW0PipTJLrwMUX9sGSHvRlxHzYFQ7uqwfIC?=
 =?us-ascii?Q?KwQSVAJwRxVXP/6dVrMp/pACLCOG2kBGQJ+S9YOxgcItW0kCKLQNZ5WuJDXO?=
 =?us-ascii?Q?zTyPoFqizLyweCqzcOn+V/HjKxc0nEkU4oJFu/eyMRkgFYJimSNIeVDM/JGl?=
 =?us-ascii?Q?+4+0kDofg05cFjFJB9wWE/TAlIv3LvTLF2uRSAgT1lXuTj7tTE3l+X6Pxi42?=
 =?us-ascii?Q?pyqwBppE5EM6wf8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WHtUI4s1x2DT/INLkOy2l7P5WvK3qQ0MVTazkiT62Xey0jH1Itc9gvcpw0g6?=
 =?us-ascii?Q?6459t9RroS40+Z/WuRm5S5HYHJHfniu8Uv3MhYyCpunxhPfZuIX/u6aE//rx?=
 =?us-ascii?Q?i//XJrltNzOukZXEOnoCH/VDbvwmS5KcumSof/4VUKqPYTuZHoEfJ8kNaMG7?=
 =?us-ascii?Q?7DEyrQpuheudJuOSvTm/I/mwfvTXnhVbo9AzqWzYlMkaGB7NFubUJ7eDfsW6?=
 =?us-ascii?Q?g/P0buA4aB7kjKZRoqOgxMw6gq4F0w3HTH9ANfKWb8iWrZRWC2tZ1TZr+U6x?=
 =?us-ascii?Q?6FhHUWI2DusWHEPJdYKMGuQDDoGhos0uB/3YYDQomeOGMxVpR8ODzfclLpTJ?=
 =?us-ascii?Q?KHoofeBVQhDIAXOLpVss00asK1BjEiklVWJ9gDoqhtP2T+9crFlD/zNDGvFS?=
 =?us-ascii?Q?UBtdC0AtMIfQIxXVvglapobfCNk1PxkL/uvCKvXdhcYxUcREAy7Ne6c16+P5?=
 =?us-ascii?Q?I+okDzhN+HDO1qUD6N1QZxTm5/LekYNo9dxDEysdOGSuTeNGRu9ki0I2yC1/?=
 =?us-ascii?Q?7+4svjgMt1VxXv+P3Mt9GuXNFR3k6vmcnhHTLxQTt94s5pHMiJxBp3qYaAPi?=
 =?us-ascii?Q?yzuhJiD+2wnueGXN3K82OBVwCEkvnMf1lstO2QXIl+twEcZtH9pcdyq3qhjf?=
 =?us-ascii?Q?o+OHvzYPuire7hjOlwnFk0qfnXHX4Dz0miIFgyupDQi9E6tk+3HxGvMUH3rP?=
 =?us-ascii?Q?RWonkgC8hZmsn3Aw42nvWhtBVseMDLZxxISyXdDowYHKaqtxGE/hO280kU0W?=
 =?us-ascii?Q?XsLO4YeohW95d1JXEEy6pyTmfnZ+nFFzGTvfXTwcNzvFkf3T8rGe9yMfBnK2?=
 =?us-ascii?Q?S7rAA4JOSJT4JW62Zi13Flcj3xXWPaDy9PnL1rlWKcgYGIi12LTS79bKIZLF?=
 =?us-ascii?Q?RFqlF/UX/1ai4sr12iy0N9Jhx7x6y1Wp+fI9xGRZsjJlCZz16UTpCW4+HrmX?=
 =?us-ascii?Q?5xwI010GlPOG3yD8RAINqojVe8gGd7ncQu6aawEPDffHSZru+q1H/d6aymLe?=
 =?us-ascii?Q?3upyU4oKPYCSjBIaReBhpKybRQm1ofQKH0xHM+h2rhF14hdhHPJkm8KMyzDK?=
 =?us-ascii?Q?WJyZoZ9kDcYiXMcQ4Vhit0sTMICR6OUuiM0LPhP1K0nZvnVbWwXtzskvNLdv?=
 =?us-ascii?Q?rUfO2/V9iwc80LamnWlY5z65n6Yz16Tt8evKNATqE5i2GJHDMNs2XuugOO6x?=
 =?us-ascii?Q?HHOR/5lEAs4zznFHkra1Wb/ujOpZQsUjnKv3CtbetS8uKwn3UGr2FGQzOfE7?=
 =?us-ascii?Q?o7r7F1+lA/qo2Ovyd5E6s1jKquRWFCdjtMCvHOweSCWsZmPz4KGGe2fjOLWq?=
 =?us-ascii?Q?wwqtaeDn4H0efHulGcaK+zeXiYLuV4hAB4oC41Ydhc75K1HWvX0Xbjgejpte?=
 =?us-ascii?Q?EQ2tUeSfZHJxt3ZcIIfSV1BGlV0zFqSCqEuS9Jg2wJUKKlYOCvkw3kHixHaJ?=
 =?us-ascii?Q?2x1/CRfOdJLy1fbUD704Te64aBwD8qEPZzTddDb0I4SsbdtlD98mfgqXMZSv?=
 =?us-ascii?Q?bCnI4J7g7VC2Y5+8CBaHLJnrsyRbM1FwbqCZfSeTdsfrr610DN6/tkrARZP+?=
 =?us-ascii?Q?TpKMbhPeTCim0od+PremsxVtHDeJEamZT2UyS4Ru?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45359c9-9c0d-4c31-aff5-08dd97826fd7
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 09:41:03.7061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOQAM5kIojbaWLhto2gVMy4BfsRywsD6l1M/4yvBc9ljK/3OBODD5IEgI6Pi4Ag5vXKPJ/r69/SxgdnsOtcosQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5507

Follow JESD220G, support HID(Host Initiated Defragmentation)
through sysfs, the relevant sysfs nodes are as follows:
	1.analysis_trigger
	2.defrag_trigger
	3.fragmented_size
	4.defrag_size
	5.progress_ratio
	6.state
The detailed definition	of the six nodes can be	found in the sysfs
documentation.

HID's execution policy is given to user-space.

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
---
Changelog
===
v4 - > v5:
	1.Fixed a typo in "indicates"
	2."DEFRAG_IS_NOT_REQUIRED" -> "DEFRAG_NOT_REQUIRED"
	3.Fix some coding style issues
v3 - > v4:
	1.Move the changelog description under "---"
v2 - > v3:
	1.Remove the "ufs_" prefix from directory name
	2.Remove the "hid_" prefix from node names
	3.Make "ufs" appear only once in the HID group name
	4.Add "is_visible" callback for "ufs_sysfs_hid_group"
v1 - > v2:
	1.Refactor the HID code according to Bart and Peter and
	Arvi's suggestions

v4
	https://lore.kernel.org/all/20250520063512.213-1-tanghuan@vivo.com/
v3
	https://lore.kernel.org/all/20250519022912.292-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20250512131519.138-1-tanghuan@vivo.com/
v1
	https://lore.kernel.org/all/20250417125008.123-1-tanghuan@vivo.com/

 Documentation/ABI/testing/sysfs-driver-ufs |  83 +++++++++
 drivers/ufs/core/ufs-sysfs.c               | 192 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |   4 +
 include/ufs/ufs.h                          |  25 +++
 4 files changed, 304 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index d4140dc6c5ba..f3de8c521bbd 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1685,3 +1685,86 @@ Description:
 		================  ========================================
 
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/analysis_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid/analysis_trigger
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID analysis operation.
+
+		=======  =========================================
+		disable   disable HID analysis operation
+		enable    enable HID analysis operation
+		=======  =========================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/defrag_trigger
+What:		/sys/bus/platform/devices/*.ufs/hid/defrag_trigger
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable or disable HID defragmentation operation.
+
+		=======  =========================================
+		disable   disable HID defragmentation operation
+		enable    enable HID defragmentation operation
+		=======  =========================================
+
+		The attribute is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/fragmented_size
+What:		/sys/bus/platform/devices/*.ufs/hid/fragmented_size
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The total fragmented size in the device is reported through
+		this attribute.
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/defrag_size
+What:		/sys/bus/platform/devices/*.ufs/hid/defrag_size
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host sets the size to be defragmented by an HID
+		defragmentation operation.
+
+		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/progress_ratio
+What:		/sys/bus/platform/devices/*.ufs/hid/progress_ratio
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		Defragmentation progress is reported by this attribute,
+		indicates the ratio of the completed defragmentation size
+		over the requested defragmentation size.
+
+		====  ============================================
+		1     1%
+		...
+		100   100%
+		====  ============================================
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/hid/state
+What:		/sys/bus/platform/devices/*.ufs/hid/state
+Date:		May 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The HID state is reported by this attribute.
+
+		====================   ===========================
+		idle			Idle (analysis required)
+		analysis_in_progress    Analysis in progress
+		defrag_required      	Defrag required
+		defrag_in_progress      Defrag in progress
+		defrag_completed      	Defrag completed
+		defrag_not_required     Defrag is not required
+		====================   ===========================
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index de8b6acd4058..978374b12931 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -87,6 +87,26 @@ static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
 	}
 }
 
+static const char *ufs_hid_state_to_string(enum ufs_hid_state state)
+{
+	switch (state) {
+	case HID_IDLE:
+		return "idle";
+	case ANALYSIS_IN_PROGRESS:
+		return "analysis_in_progress";
+	case DEFRAG_REQUIRED:
+		return "defrag_required";
+	case DEFRAG_IN_PROGRESS:
+		return "defrag_in_progress";
+	case DEFRAG_COMPLETED:
+		return "defrag_completed";
+	case DEFRAG_NOT_REQUIRED:
+		return "defrag_not_required";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -1763,6 +1783,177 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 	.attrs = ufs_sysfs_attributes,
 };
 
+static int hid_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
+			enum attr_idn idn, u32 *attr_val)
+{
+	int ret;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, opcode, idn, 0, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+	return ret;
+}
+
+static const char * const hid_trigger_mode[] = {"disable", "enable"};
+
+static ssize_t analysis_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_WO(analysis_trigger);
+
+static ssize_t defrag_trigger_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(hid_trigger_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	if (mode)
+		mode = HID_ANALYSIS_AND_DEFRAG_ENABLE;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, &mode);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_WO(defrag_trigger);
+
+static ssize_t fragmented_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_AVAILABLE_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static DEVICE_ATTR_RO(fragmented_size);
+
+static ssize_t defrag_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_SIZE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static ssize_t defrag_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_HID_SIZE, &value);
+
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(defrag_size);
+
+static ssize_t progress_ratio_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_PROGRESS_RATIO, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%u\n", value);
+}
+
+static DEVICE_ATTR_RO(progress_ratio);
+
+static ssize_t state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_HID_STATE, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", ufs_hid_state_to_string(value));
+}
+
+static DEVICE_ATTR_RO(state);
+
+static struct attribute *ufs_sysfs_hid[] = {
+	&dev_attr_analysis_trigger.attr,
+	&dev_attr_defrag_trigger.attr,
+	&dev_attr_fragmented_size.attr,
+	&dev_attr_defrag_size.attr,
+	&dev_attr_progress_ratio.attr,
+	&dev_attr_state.attr,
+	NULL,
+};
+
+static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
+		struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return	hba->dev_info.hid_sup ? attr->mode : 0;
+}
+
+static const struct attribute_group ufs_sysfs_hid_group = {
+	.name = "hid",
+	.attrs = ufs_sysfs_hid,
+	.is_visible = ufs_sysfs_hid_is_visible,
+};
+
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_capabilities_group,
@@ -1777,6 +1968,7 @@ static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_string_descriptors_group,
 	&ufs_sysfs_flags_group,
 	&ufs_sysfs_attributes_group,
+	&ufs_sysfs_hid_group,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3e2097e65964..8ccd923a5761 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8390,6 +8390,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	dev_info->rtt_cap = desc_buf[DEVICE_DESC_PARAM_RTT_CAP];
 
+	dev_info->hid_sup = get_unaligned_be32(desc_buf +
+				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
+				UFS_DEV_HID_SUPPORT;
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index c0c59a8f7256..63af47c4e9ed 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -182,6 +182,11 @@ enum attr_idn {
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
 	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
 	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     = 0x34,
+	QUERY_ATTR_IDN_HID_DEFRAG_OPERATION	= 0x35,
+	QUERY_ATTR_IDN_HID_AVAILABLE_SIZE	= 0x36,
+	QUERY_ATTR_IDN_HID_SIZE			= 0x37,
+	QUERY_ATTR_IDN_HID_PROGRESS_RATIO	= 0x38,
+	QUERY_ATTR_IDN_HID_STATE		= 0x39,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
@@ -401,6 +406,7 @@ enum {
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 	UFS_DEV_LVL_EXCEPTION_SUP       = BIT(12),
+	UFS_DEV_HID_SUPPORT		= BIT(13),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
@@ -466,6 +472,23 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bDefragOperation attribute values */
+enum ufs_hid_defrag_operation {
+	HID_ANALYSIS_AND_DEFRAG_DISABLE	= 0,
+	HID_ANALYSIS_ENABLE		= 1,
+	HID_ANALYSIS_AND_DEFRAG_ENABLE	= 2,
+};
+
+/* bHIDState attribute values */
+enum ufs_hid_state {
+	HID_IDLE		= 0,
+	ANALYSIS_IN_PROGRESS	= 1,
+	DEFRAG_REQUIRED		= 2,
+	DEFRAG_IN_PROGRESS	= 3,
+	DEFRAG_COMPLETED	= 4,
+	DEFRAG_NOT_REQUIRED	= 5,
+};
+
 /* bWriteBoosterBufferResizeEn attribute */
 enum wb_resize_en {
 	WB_RESIZE_EN_IDLE	= 0,
@@ -625,6 +648,8 @@ struct ufs_dev_info {
 	u32 rtc_update_period;
 
 	u8 rtt_cap; /* bDeviceRTTCap */
+
+	bool hid_sup;
 };
 
 /*
-- 
2.48.1

