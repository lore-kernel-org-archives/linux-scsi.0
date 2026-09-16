Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013057.outbound.protection.outlook.com [52.101.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671BD486640;
	Wed, 16 Sep 2026 08:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548297; cv=fail; b=SMeJZMoSywWYxJGTVn9m6rFUUXraFADxJjhqgyhfbR8A0M1Xk1+xDWli246J7/yrwmhQAuZS18lUgGvXgGPCBQrp36T3YkRS3Bp7OzfGDwJSi7tcDRZevJPSr/F3GI5eZPQhAEMXNFZ3dotdvjpfxGpZEOoysku78nihkTkoKig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548297; c=relaxed/simple;
	bh=SlPckDvgmCgHI3K96wXmE3PZMKP1GnJCHi/dHGpHhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o7fsRs4KU5e88P2+Gn/Fu08WXyx9gY5dirBMBdBXS8vLHDImEwWjEBhHxxP2VE9Po8+TqZokfX8B94HF3WWLZL8T6PMZ0h+iXW8Sw2zrEmtEcggWz2mbTjdXlBIcS+8qVRUbRU4hJS0U24cQaTylRxI+Ga1m+eytY4GYCjKB1To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=VY9lrCFW; arc=fail smtp.client-ip=52.101.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="VY9lrCFW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DyYQp9yRH89mTfxXyL62l6ShOCcx6fCThNcuS3m2I3/3Hl85TIDBcMME+bQRpnCuepKDPN+pSmg/6IJiA5AifRavPsQupR+xKaFRhCHUGPTKtGt3g5/aD1/GpWo/sUkXn36YG70QPVuFtrxgC6iTHXxfdy5QRbW9fXoM7NYm2QM0C1gyrOm2DBFSV1bSW3LC9VgjjGLtBUgPbbw1jKfuRRTGj2RXGLPlWNXQHJIoHs8tTSbU8xIa8ShgyIw3N6pXwlCf8iLajxTNLYzpWRBZC8CuC6CluIxwCGTWXU59ChC5Lf6eSLORndLcHVhiWDaPgYS9gnpP8LS1l7pHCu1rCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=wVpmbzxcq236Idp+StKO6b6ZMeM2UwFv1OXORTeKj2rIGUMFqMsGZyHSh1UzpGpxGcERUzVUAM6PXhU9f1kstD7Bd6caGsg4zRTzSi5GpmaGGjmyyz2e2ttVsc5++CLh4x5Sf8HPumTrBBLLz5GfFD9C/fLUWuZjvPmAzRNtCPQv5wjr98WuQ4XDg6+Sl5xFGuTg3ETnb0m1tG5UvkU8CMgA7SVGCPlJwn9D1TSvBenD4g5YinBJfINHG0U4PyZdKamLj+qNk+yp7jIRuA4dMly7X6Wqi5tikKR6l8QFaXe5gJMXzXdvprDV/uxXZYSPTgOG14JiLyg7NmNP0DRR6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=VY9lrCFWEQkpMjJEROvp3Z4xeukcX+LV0CCsBdGlBkqfKP4b4jLk4kHvtK5Zj3+YxEilf3VoNGFl737Q+Pgm/obzqzbUJ6Siv6FOMMv69l+IRxFHVOzEUJWboxUiW2nkRByucmVKySX4gcFY5X8Un2dsW1EgBMcevybVxZK3rcLkLz+0tWVKVV00TDD8ikt+xGvjQxKec5gl2du3QHr+sMEU4sZOu7hcJzcNIZGGr4mtBGizGCGXXa40CLGoAeh3FoQSsdosVB+Q1Ms/PY4X6JWIqaaWK6di1hkIM6SfB+Bq8acOkm1mZ+YhZbfCBGG+3Cqd2vkoQKwuU/YEHHi81g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:33 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:33 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	=?UTF-8?q?Pedro=20Sousa=20=C2=A0?= <pedrom.sousa@synopsys.com>
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v3 09/10] arm64: dts: freescale: s32n79-rdb: Enable UFS
Date: Wed, 16 Sep 2026 10:44:10 +0200
Message-ID: <20260916084411.941297-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DUZPR04MB9981:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e529049-f2b6-4cbc-5305-08df13cebb49
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 uzsD7vLSHNB4GuodHoEx00cSnxqWkXfNkDsFhAqawTJ5Rdx6iKbchCjodVAbV2br0K3KbkK7DrGn6oAluawqVKubWO+NBvfFOzGo1o0JJCEL77WkerAO5+9kMG2zUWVxwHDpltJWBSw6zhKiRFQ2+8HXMySFE3di2ZchOuPagFASbRqCH3hFWNPYj8+rzordG2IJefcaRbJRP/qw7+AMpjZ2Kwviymzu5iNMwqz+Vi9GIY7jzEETfvSAalZnboizBPBfy8vFG9z/SonwtZpjAol658T1AaLgJWJy5VpZdG92S+Z5wrkJafUVs1GG+ChyIgVZcsebtdNw1AaCYb/hsxzc50NAZ1X+PUGz10/IfUno/r34ZfyBL6suph9ndWsPzpFLOyrX8DvPdEbCWozW46W4dUwxfAyIxqcKe7IKbSSndcKUy8zd620a54UYsZ6w5R6EIe90XmDVc/OOlwvvIiDne8K6Dn0jlPOWJMfoZT/Wc1zz8F2HWPkMMBeYDj7cNjzr2OVcHF6Qr9mumL8I/cO/ojPXEJxR79fY/zX69suLOQRPHewcngigx0mhb57E5U0oYwWMm7Lfp+mkwQ71eA4BUrDnnlxAg4HQFkEEsafYUhMxcYFfxVsbwu6+2Qn5CS9bICM9+P1QfWyv/6axSgeWGmrMWd4vvzfBHYdunTEcSX8BV62L1ko3q88JDJS4PYqeYdRTsrjbH7YGrOcAVQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TEZTSVJzQWlubUNDSGJnZmozYXJORWFsdEgzM1hZRmoyWThSa3gybGViU25p?=
 =?utf-8?B?cWVOV3RxL2lyU2VEcXJWSEo5aUEydEp1N2gzQ3A5YTVadHg2UEgzRjRvZ0g5?=
 =?utf-8?B?aFk3NG9PYzVRd3VKWWlmSTg0WkMzTVJITWtFOS9tbmh1R3FGMk42S05wbG5v?=
 =?utf-8?B?U3BYT0w5TTJUaU9VWk44ZHR1MHdSYXcwdStsOVpKaklMK3JXTEMzUW1YbnM2?=
 =?utf-8?B?OW81YVRTRkwrTlZZQjQ5cjZWdG83bm9jaStwL05ibFB6eDkvVlhvNlpyL2kz?=
 =?utf-8?B?cWlORXhNNDYzRThKckVmUFNwOUdRWTRSbXlZRWxLUXdFcFFVem5QcVFFNGZN?=
 =?utf-8?B?ZFdEN3ZHWUZhR1VmTi91Rk5YdmxvYnBVdDIxVk1FWXVFNXk5T2hRbEJzeXFN?=
 =?utf-8?B?c0tGQ1M1OHJRRFRaZ051eU9RMUxOcW5DTEVoNWplb2hRWDJHemxRNzlxQVJU?=
 =?utf-8?B?NXE4K2ZRMU5JbVhzWmlxQU1FbHBXWWkzOUIwQ0kvQWJNeElBVUlmb2Vvbmgv?=
 =?utf-8?B?bHlYemszeHVLWGVSeGszVTJQYUR6VHF1TEVSNlIwd1BocE9RRzdCbU9jdU1V?=
 =?utf-8?B?aFdxRy9RbW5uc2hUdUpUVm9iWHRqTTlHWlY0WGdoUHI4RXoySVVmT092bERh?=
 =?utf-8?B?SEtwaGZ4TFI2NnljZm1HSEtBUlB1Q0xkMzE5MzdtVW91akt2MGE1SVRmY0px?=
 =?utf-8?B?ZlA5Um1hMGhrR204QjRkQk9PVEhIZThDVjZVSFE2aE9qVTl6TUtzT0pjU2k4?=
 =?utf-8?B?bGpURnhUeFMreVNhd1V3b1lhVE8vYVNBYVo0ZExBZ3NtNHUzMnR0cVdCV2xw?=
 =?utf-8?B?SlVaemdBMzJOWGx1bEJvLzVMOEZHbksxQ2k2OURDTEY5WTNYWTJ3c2hodW93?=
 =?utf-8?B?VXNrSTg0Mk1LemlpT2VndmpscXFHY1A3NmFrbFNJK3p1L3VLUXVVR2pncDNU?=
 =?utf-8?B?V1ZCb0MzOThWenlxY2E3S1BUemdMWlh4SFVWY3ZHSjNFc29IOFdTRE5heHJi?=
 =?utf-8?B?RmI2YmhNOUQ4RkhFVVFOclBFNWhUbFZ2S2lqeDFsK0RPcWNVNkVRMU5veUhE?=
 =?utf-8?B?SHluY1A4K05Gd096S2lCM1hHbGh0MzNRQ2VwbVRJS1BSWHFDdXpzejlXQU0y?=
 =?utf-8?B?dkVleTd5TnBacWxVSWdxdVZyZGFkZ3hUZnRJR2ZLVjZzajV5N1grOGVRbHJW?=
 =?utf-8?B?N3FRb2V1ZjNENWhvKzJsQWN3UXNSLytyb3Y0bksyeGwwRjNFbWZNcUp0cUtI?=
 =?utf-8?B?d01rSW54N3VNNkRlM1dZSWwyenhGNytlTERGNlNxb0VjdUJxUWtxRmhvcGJw?=
 =?utf-8?B?WkpTUTBIdzhMTG83a1BaTURNZGgzNjFDN3pQZ0N1YUhZNFZZRlgwZlppV0lL?=
 =?utf-8?B?UWFjdXp3dDRsSFpJZmxsRHZSZEh5TXlZY1VxV0I4ck9pUGdORThlTyt0TlY5?=
 =?utf-8?B?NFQvOTdRemtReHZMd20zakVwVmZReDJoVUlDQ3NyRGF0U2I5M280UDV0aUhK?=
 =?utf-8?B?bjJsMC9DT3k3cnY4a3djbjhaSWpGSC9xeG1pb0huVFJLNFF6aG8zL1JVYUc2?=
 =?utf-8?B?dXRKRjJwK0MvNzRLdDJxa3BKZGY5OWNpbmpMQ3ZYRkE4QjZCM1cxVmVCK1dy?=
 =?utf-8?B?WlFDMis1V0V6NlVjam9QeUZ5MEtyK0s1elJyWUE1UVFHOWJmQ0JCSTdPZWpS?=
 =?utf-8?B?aWtaNUFUVDdsUnlobERydVIrUjBYM1hMYlhnTDV2YkdTeE1kQjFrVkhHeStJ?=
 =?utf-8?B?Z1JVc0hoa1hCQm9tNXNYRXRIZ0VZL2xodlRBTHBaOTEwczBlNi9rUG8zR013?=
 =?utf-8?B?ZGIzYUM2UUwrbFZvbnkxTjZ6b1Q1RUdPemM0VWE2cDlrZ0Y4OG90RTE3WTNm?=
 =?utf-8?B?amplVXJYZ1NJbFRzcDN0RllRdU9HU1hXVWZ0S2xDMGNaVE1OUmhUdldRcUt4?=
 =?utf-8?B?aXU4UkxmcVp5dW5GNlVMOU5naFhRb2xzMlduOGJBakkzanZiL1lzMi9JYXRj?=
 =?utf-8?B?UER4NWVJSFNtN1dCa3c1MENZUnVJUDVHREhScWxSM0tkQmE3STAyeWZiUE9F?=
 =?utf-8?B?QkZkOUdyRXZFRnkzajNKMDkyckNNRlVta05WdENpTWt4NDJTUEN4MFdUSUxr?=
 =?utf-8?B?ZHJscmtsRGNRNUx0WUhZUmtBdGZlUnB4YUhpbDlrU0V1cWhjK2dEaHErOFZG?=
 =?utf-8?B?bm80VzBGWk5WdEI4U0xRcHJmRXE1Q3hoNFl1NE02dlFlMkdVZU13bmxVb2Ra?=
 =?utf-8?B?Vkw5ODBJWjhpUFR2NWpkK1h0b05VdjhaVkNkSVhNdG5QLzVUVFA1bCtoRlN6?=
 =?utf-8?B?MTJWN0VkQzg4SDFqV2sxYW9BUnBsaGp3WHczVzV3T0NyZTBBQXpCUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e529049-f2b6-4cbc-5305-08df13cebb49
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:33.7093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlLZgHz+z/62p0M3BKDdbo54BPnNO15mwaLeACF+fgcOf11Z2tehGd9+cWuQ1+gGRADW7KAY6FdxOQoVXe96zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

Enable the UFS host controller on the S32N79 RDB and configure it for
two lanes per direction.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
index 1feccd61258e..38c5699e6d54 100644
--- a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
@@ -63,6 +63,11 @@ &uart7 {
 	status = "okay";
 };
 
+&ufshc {
+	lanes-per-direction = <2>;
+	status = "okay";
+};
+
 &usdhc0 {
 	disable-wp;
 	no-sdio;
-- 
2.43.0

