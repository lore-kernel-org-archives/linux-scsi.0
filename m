Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012068.outbound.protection.outlook.com [40.107.75.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAC62701B5;
	Wed, 23 Apr 2025 09:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400572; cv=fail; b=W+bK3KoXAmZHOpDyIvxZizdtENdMwycRXGqSRAHgwqsTHt6gyRFpT5y0daX0b6eU3B1vMC70u+UwiMThRIZ94FwtmZRN3kVWPYbnZyIJlN6SIP8w5E67zGXKQAApMjPk78aAzjG3UBwMUD3ysnM0Ii+pVEBe4ggl/aLyOrcuO+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400572; c=relaxed/simple;
	bh=i8ZPRykO6YEHzjitYlpDrfhxZcgsey7YLPzSP+Q2kqY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=n8BzYbtLig/IdmFWbaS9crrfL75rf+qPCOaIX9i0Gkc0QyRVFCOVN8UbTWvKa5Nv2R+/CDsHarhMcU+2jm504ENK+VYT5yi8GQ5gDR3X7UdjlgFvGYto/bzitIMk+F+LEtIJV75YM37ECK+bCjG4h+o+ZBD25d548e7FFFoN2aE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=QCkDpJ9W; arc=fail smtp.client-ip=40.107.75.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="QCkDpJ9W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9z/IVGWfHo64n7wzpVuhsJgnKIWsmsPXuXPXlsd7KKbuoYJ7LElfEKCKkcrJ3BuplmypAGHCB+ukKeKgoXhHZ5XjWASiKrIRnr0v7fGGMOAqYWep/G3ZKERpKQnXyzHIcOGreyOfU5Q1EUrMXrTEGljLBAuSPUXVJEJALufn3KN69dWw/jxCvGznXbWsA879ZxXTVSsYCRAu6Y5gt01Rjz5IIyJ/uY5DE27lMabTdAutnqnuEMHZqQjq+h6DFyh/0+Mh8cyRnc5Qu4z9mxyl4w1hVx2Z2iP+rULg0iA4qoQulXK+tngGoOdtYuZnqpzqbdfToGOPiaLkF6EmZ6npw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPXJneXeT2u2B1aUpOuoCvgNUJXDcpNqtI0IcFFAqrQ=;
 b=VGRp+1d1MP4514EzKvMMThGNz/coBHF5fbJT2r6PXEJ7L2Ia5ykDsYK3eFlPzkjwAIFKN4cZG/7Clhs8I1HBFjbXF5gkAtVH9PtO+C0NR8Pbs5mJVkDKJeHvggZioatgeBqteQtXx7PrQB/aWXlQvcYkI+1olDUpIHoMGIL3zt1BHpB4hZisHMCWzkQH2HrTRjsKwTuJN8yz+DXuYRraugQ7F1sKoJNvoX02ANl0TSu4PQec5fxpt1nSjhAWqzdkdm0FKreR3Tx61p8qEYD6xQhXNFlthKdyQK8Sz8S9BcUDz3QbsSu9niC1IvduTkuHA9Kdutlk4RijYZvg3JsCNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPXJneXeT2u2B1aUpOuoCvgNUJXDcpNqtI0IcFFAqrQ=;
 b=QCkDpJ9WWztTwAtoBXrn7/FObCt2MXQJoBRiOH1YDjNxyxBbtRavOpwjsG5w68Kzu8vZPFOpXxZuLuzpRr+g64eTHmm7pQVHpxx4MqZjmMvH+t2mGS3pwqQudmgSG0qxZPOTVT1CPrz5EgWktvkGGWAcSspZIBjD5UETCSpSOGSjQHx5lUdBq1ZHN4Sd25LviLG2FNGC5D41GfSIxa6bHkJuTpnUg0ui6vHSDrXcuzO94CEuL2hhRZ0XdMgzMwK7ILAf7PWhiT4bHw5dNV8IEjN9dCW3y/aaitnBjf5gs/FUFLlL3dj7Y8YvCAwc6V62/n5oBEVfK01r4EOA12A1ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by PUZPR06MB5651.apcprd06.prod.outlook.com (2603:1096:301:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 09:29:27 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Wed, 23 Apr 2025
 09:29:27 +0000
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
Cc: opensource.kernel@vivo.com
Subject: [PATCH] ufs: core: fix WB resize use wrong offset
Date: Wed, 23 Apr 2025 17:29:17 +0800
Message-Id: <20250423092917.1031-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::6)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|PUZPR06MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 1acc429a-6d03-489d-3740-08dd82495767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|7416014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QbYmuJX7ByAY1IgjRN2fStH51Ahc1v+7yZhUpuzSQ/cRgG29yulKZnRjfvDl?=
 =?us-ascii?Q?pNaVdvX2jZVtgcY4xTSC/++Df5WMabZd68uu2LHFmU1EdKM+43zuKnSYqWU1?=
 =?us-ascii?Q?YBh2Kr/Zw9Ww8gupLT8kmZ+It4lJli220MTomHVG7mFAHWvaAWJlGkvAoPnn?=
 =?us-ascii?Q?7xELr4ZOSPlaP0/px+TguP3cvP5o1JCH8IBW3mS96zhNgnI33NRU9riB3zdh?=
 =?us-ascii?Q?eWJfn8bNb9a4cDuwhZAivdZ6cZINXBRjscMyb82KZbVH28+QL/mUxx6/5l+5?=
 =?us-ascii?Q?KqAFtk6R+N3cZLX6/0Y/4+JiJdXCjhAgb05FwTS6reOITakRvQI7cHUawnLc?=
 =?us-ascii?Q?3GX/ymt3wHhkzQ9yDGFWs0I5AkoSDbTXCQXjdX7XDpwMW8slupw2oKn2O0gc?=
 =?us-ascii?Q?FfDdFxZNx8sL+LK06pA9g6D+0hUDw03TBi64RQYK3R1bEilljArUHaap4oNs?=
 =?us-ascii?Q?6pnPgjRz2PXkxs+Q4RW8n5DtE0dKpUoyf5mUGAT7wSNTnkUtDVBfrTcF1OAd?=
 =?us-ascii?Q?J/jsFessqy6O89gIk/v9GvyW+LRYnI0N0rVUpC97SVUly7x5YMYIIFCujcMJ?=
 =?us-ascii?Q?jbU6L4lARd8qoFuNmy1iFEIdlk1HfLD0NowYukmKAsqU3a5e5EdYj5ZxY4hP?=
 =?us-ascii?Q?rcOyezdBH9YcKlkMXa9c+mTRUp8+TunoGE5L5if4DO1Iw65w3lnRW9bFMETf?=
 =?us-ascii?Q?j0iyqGidR1F34/DPRmr0/O1S73stjkx1tJCIPVT7srMlsPpZdN19LkXGT8fi?=
 =?us-ascii?Q?76jJZNgENcfMfmeM5CojjZjpR6gHzzW1wN/zEXicRQEex+D864HNV5jLBEE0?=
 =?us-ascii?Q?D9UUYC0dAu1XZGCLWuqImHmVJXW5biYYdjJZuRx6QdBtmjJ4k7oK/PjiB9Nu?=
 =?us-ascii?Q?YEB7pydccySsi/Xof4pzgyKtOkrW14Vn963WAWoMj4Egzm5VL2QQOa35uIVd?=
 =?us-ascii?Q?TpO5jBQwDHFn3dZlcFRBjfWE3D7T3tfOk57pzoBdtegrk7ySVegepi955MTp?=
 =?us-ascii?Q?WqhuNEx+gt3eEwuVDXdf36FltKIGeWpTxr8oS7EmM3AluXLaDM8epq49ySbE?=
 =?us-ascii?Q?71ei+xZvHT71KuPKowrxGXVRmNFEtsEmZXhm+QccgjB975KkOL1Alz/qwobT?=
 =?us-ascii?Q?0AXw9Mr7tliO+1xVnPqF1wtZPNUQs1sbTiv75K9YOh+skJRtd7JFzyh83ZDJ?=
 =?us-ascii?Q?o7QUMAku14ktzyLFDvcPebySZnRmwn4G6AkvxtSv4N7+wN4RlRbX55mny23J?=
 =?us-ascii?Q?7RXr33jKLzwtRT2KJfQ8uS6NRUVv/dMFkeikshO+qn0JxCF5I8rEnaRxm2BF?=
 =?us-ascii?Q?knkUqNt335pYr35uAkOQG7GER8PhNJC6STC/hpOeZaGxyl/ex8zyj3sOb/PZ?=
 =?us-ascii?Q?dBRiUX2Nw9PfNh/lGtID/oNWbRwQGajSplvKPDlF9TLoBul8zdD9KsnHtHXm?=
 =?us-ascii?Q?dmor7UprPfK6Ha+DQjQ7cbkJkkdZpl/D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(7416014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iQiDnpKn/eYZWh7puhw5yL+ucyDGxHVTrgHkEg/ICJjEodckYxhq/tMR8Sci?=
 =?us-ascii?Q?UKDioOPL79ULtnxjmcvtIU1OipPFVdNG8Tt75eC2SVq/URHEUIxL9Xvkapm+?=
 =?us-ascii?Q?geLKbAMXm8I8AEH150nZoaRFrLFF9ZNO+wiwUWooNtbI/dgeu33VeL/iJBa3?=
 =?us-ascii?Q?YvHRVBf0NY3114rOoinAkngDQh9dVqCUj/J30YFymbOHY5Dt2w2arRmsyp3Y?=
 =?us-ascii?Q?JUH27HDaGF/GEGbWGm2v5Fu4T7efCZNVGaIIcOZhIdN3Wl8KIxLdDPkubb94?=
 =?us-ascii?Q?RCyIGrdZ5z53PN6I7sZzkaOl9q69KTaqUQyTDq+wdsCMyU5/X31K8LJHnJQ8?=
 =?us-ascii?Q?2WAP3FlwsPjwVzQxus5fSVJlvTBYb82D9TwM+e/ddWhi6SjSNuFBRk8n8mz+?=
 =?us-ascii?Q?KZhWIffUD0W8u8o7lt991U1eVA9g6iiqxQFnaYh2XscLarI25FnX4RElMzFp?=
 =?us-ascii?Q?Gec0MVbWDU+UOOzfb7GdnBaxpbUmr3I1M1O+mO5s8pAoIaRp9m4l9wb7kLWF?=
 =?us-ascii?Q?BRNibfeBchD1/c3EtHN7f7C6tCH6Kj6uEKhV++erA07vlVOGpbrM+f4wAG4G?=
 =?us-ascii?Q?9RzFKlN6mxEMJZDaer56tBp/sCKM3aYrismhmyIazShi9AAcJLtF79Av2KFw?=
 =?us-ascii?Q?HOTdbNWMS58MiHmujTAgZQA/VJ3eVizvmlE4QF4opBCFyHSboPruGl8hKyCC?=
 =?us-ascii?Q?JbMGVC/L1BgzbpAIJihv08N5ORadpYKhx568aMaQJT6LI2qghwrWQJSLfZxI?=
 =?us-ascii?Q?lkslr/JD88lL+MaAMQWVOg6uE9xAB+85YN4u7t6tqmsQK2qHEQ9l6yEQMP/P?=
 =?us-ascii?Q?yqG4rLMG1j6bsjR4pZqWNaw1Sb8EvRJfztFNmwH0308R1cCC7CE0miMgOgPU?=
 =?us-ascii?Q?bkAPJS4LLwqfdEvAw6o8ooxb3V+yPbuwz52RCfbG42HeAlzD0H+xWQehSybU?=
 =?us-ascii?Q?ZqSUvASOWLCdWugv7ScjLgnNhAXNiBkKc1gb4F9RQY4Ds2xftJXLNKFU3Sn5?=
 =?us-ascii?Q?sG1zXYk6+RhIm7IXMToSIhf+Mdd/st18y6Bbmf2JK1zZgLO3WR1vqc0Epj0V?=
 =?us-ascii?Q?advO1DRARVku6zaJTIeRB5Abgd3GUgRW/KizTvGp6fsIDJ4NFoFQrfOaz/JH?=
 =?us-ascii?Q?gvAXS8uYNQVuFkTI7vtetLvanRN9yM/jhQDtKC5PYyjY6+FcrJCBKAEyyLDs?=
 =?us-ascii?Q?dO8LOsgfgo3Pp4pU4zVTvQMC5BaMgzDXKg9wrlpZ1xHUuicDv/NxZ56Njmcn?=
 =?us-ascii?Q?c0lDPnGXDk0SJa74tQRqy7qlgMsnupf4HwYy1OsHF9zNpV7gA+pABqPjqzc2?=
 =?us-ascii?Q?0nCsxolD40t+uDveVmzDAla3mrK77KQ+Jucf7VnH+PNJfPIFIA2BmuxhncF1?=
 =?us-ascii?Q?SVBmDyuucBXdiO2tqJgV2gdQk5L5MVaVstOLp6g/kcm3bEiXv+X2I/5eg/Up?=
 =?us-ascii?Q?bMwXzPivAR2jYzWVQFGTbPhX2aDGOkfI0MqhRMqyBvx0QIbiQi6JwcQ0NucJ?=
 =?us-ascii?Q?m0sqxe9O0zCWlX6/wDdsyMKhwqDRCfcwvHdQkGW0SHoDaS3Hmu8qx0KvvYHz?=
 =?us-ascii?Q?yroK8CzoN7YWVxxfhl3dL5f+YR81CiLjPLfnh+Q+?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acc429a-6d03-489d-3740-08dd82495767
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 09:29:27.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNkWUejRkbwBVAVEIHiGz41L0X2DoiLxv5oDhASOT1aLoE/0r6sPx14j4wwHXhrOzy07FuDSTai8SEGQRQHO0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5651

'Commit 500d4b742e0c ("scsi: ufs: core: Add WB buffer resize support")'
incorrectly reads the value of offset
"DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP" to determine whether WB resize
is supported.

Fix the issue by read the value of "DEVICE_DESC_PARAM_EXT_WB_SUP"
to determine whether the device supports WB resize.

Fixes: 500d4b742e0c ("scsi: ufs: core: Add WB buffer resize support")
Reported-by: Peter Wang <peter.wang@mediatek.com>
Closes: https://lore.kernel.org/all/7ce05b28f5d4b4b4973244310010c1487
bdf4124.camel@mediatek.com/
Signed-off-by: Huan Tang <tanghuan@vivo.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc55c94fa45e..1c53ccf5a616 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8143,7 +8143,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	dev_info->wb_buffer_type = desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
 
 	dev_info->ext_wb_sup =  get_unaligned_be16(desc_buf +
-						DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+						DEVICE_DESC_PARAM_EXT_WB_SUP);
 
 	dev_info->b_presrv_uspc_en =
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
-- 
2.39.0

