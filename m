Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011055.outbound.protection.outlook.com [52.101.65.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC44963CA;
	Mon, 14 Sep 2026 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390222; cv=fail; b=ZVvbOjwAnkdMV4mCSDNIG1gJgGQX6gSTLFHh6J68UPLm3ucTQ5vy3BPFzLY8p+BqBJHRkmN9HssiqMLNq/xLLB6xmfuy+U+MgU8d3fKexhqrkDvMVTdKLURlX5Ug/gIRvfEgxeTSpRbID3ls1nsOv422GGaXzFbN0A6dgKdGdE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390222; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g+wF9pPN9w3zhE7/AHL33gs8broIEEzsThkgNifk1x5jvuUsLVfWC9jEFYwUnIwFU42KEQjC740+/D3E1fZkkiGpHB1da+zuFTa5fJNv9x0P0X+CgWCoSeZ7jnKFOZoq7UDvPClDSByhVHumeUB8vo3zw29NyyHIAa+dX4rXfHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=oWmb7qaJ; arc=fail smtp.client-ip=52.101.65.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="oWmb7qaJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOWTADnguA7E72FHEpIvk7Zv4eYpNkDLrb2gRnL/CKlm2q5CeooXstrGc2/OhelgAlmnC1x4VTBgpG8F83dYqOZOQ4+Fx/I/ROtHiVugZnZ3UvRT/pXVUfBmdnTMWfKEdORpFl0WHU2UNwZPHrIO14RelgSrbCmR1U/MjgEF7EjSEm6Y+oRc9iYt1q+zAsmKGC5sPEyGBA7nooa+Uhe0c4XLzwun2Z2V3hEUa+W1Ff7ix/NCWrJH72Tl/NjJ8jksgzHT1pPrceez0gdX0XdD5mVzeOHz7j4TUyu+zVkc0GBbGqicjVEPa/7ghzmR1z04I5/Xc5dK7+zLydXfLSufMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=H+icPkTQ9yQi6t6iZqzVpdKoaWw3xAoaSnQvtdrXnR/Ny7rgjpWOTg0ciyBliikoJAfp9KZiPBB5EwCsG9TzJqxd5HgS/bpsLgpUzv+G/X2Bk6Uk3rplxkPzBfMCzfVq87xSGy5BgV9bJmllsvxv+dg6SLEl6BRYTU9PHa0rv27y0O4ytqDc7B48kObeNrFHXydmfahkiaoRoLWb2hWwd1mtfivrzyQNZYFxvgalQEAr1aX/dDjdY3o8oCUAK2xLwbwNmWsj3DkqLMA6j5RmY6MLFjaqJNkSO+pUob5hirDxIaSJBgKHVIzofeMV7R+dWofyDtDEPfu0PMya79Va0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=oWmb7qaJbAEi+8/S3WEMt+8dMpwiURQFaSvXxpuKWE8Ot0QhP4faNWgaO3bfNNsLJYFayQm/8oLPKtd7TV4HBlU4e26GqG8BiAuAfznyzYXR4HNHD+L9pvckzNSmN2R+qKNnGq6ukhQmIBNRBTEV9lCBHZYgVc42qz4EL/K4goomSafQ6SLlhqlpXIlXXmIEw6bgn8wI/rwrQelr2A0fZgQDTpIFAbHXEXsgBAtz3PNRgCq3vJdDCZ2unpWdT1fpgXsL/puA4P+Pq5vGNpm5g7CuOd+ML4evWJ+A80vGVc8VXgzoF0eGzJ5pLrGXpCBUGtGgAA+8FqIH6m5M3HO4ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8971.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:08 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:08 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v2 02/10] ufs: unipro: Add TX/RX FSM state attributes
Date: Mon, 14 Sep 2026 14:49:52 +0200
Message-ID: <20260914125000.30812-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB8971:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e25a3d-04bf-4c42-6be7-08df125eb543
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|19092799006|921020|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 vSz/ngLRENDrzEgdqUOC63FSrhPlGfRmfPUgzOBvAqaCR64yrOVp8O6TAGk3hAjSQ14O3lRp24fTzD6GwP+fZ/v/9y9Ddi5RDHyAfm+B1IQu4tbEn1ok0Vwq30XFQixfy69MLoDB8LvI4cZHcqx1WdfdVA0K97LXdvpnsmucUrpMq+HmBGyg8KlTa2xeqEJNd9OiMASRKkHR6Rz2qxn6S9aFvwnEoZCTolZ6kcZQbCs6M82AyG2UUYGioAwtg/mmolGY68w3pHX6CqtOdywjTJLMvk8zALmMEQILfUNP27mb+T5vmDlw4E6D9d1OPV3gILJmOuUtqDJhwzsXG9MmgmyQoZwMOkeO7hFdgf+0KW/UZDi1bCEi4mz1kKS/zP905Qi0k+BD2Ej8NZ4Ddu05uKjGC7Q6dPa6NdtKugrZlGnlRIYf/gC3PIKS3iPEewVq5xgXgftHhev61yfU3E+mrYQCW+f7bd1w56K0jcdbiaxjeWnS/x/YGbZJV9UsFRylBJNpB4WqtGoJ5ylhM/DyenJCN+yNXirmn6ZX9mSqMZsjhIcv5OjLpbW3IlrLQ2H1CLzka3NEZZqfMdf9QcjN0CS0Avr55RR5HPTEYl7h26cSI+QSHWCMBN/MD281vQ+iXrU7HiAhqhBGLncMLrH52iE9a/pXp29BKqUN8RZZx8DNJt0uYz49wgavhNUYcju/XHUZhMQMZxxn8aj2myOQ3w==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(19092799006)(921020)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?R1hYZFBvMjNpbnNKdUZKN3JieUtXMVVMRjR5STA5cytrNHdpOVloSWcwWFhP?=
 =?utf-8?B?UC84QkRzT0NkZHhSUVJNM2NodUdORFFqUklDRWpDWHJ4Q3VRbXY4c1ZZRms2?=
 =?utf-8?B?T2dqVkVHSXR3c04zNnBFaWtFTDFEOGNaMG1uTXIrM2hzcFlmcWd3c3M0ZHBY?=
 =?utf-8?B?bjJLMzhISmtaRElFTmExc01TNHZnRXpmMy9FZFlHRlNhVTIzQ2Y2L0JCRG1r?=
 =?utf-8?B?djlBYWNaeXkxeFpKaW5GZ29WemNrZDlxTEFQNi84WXhjaUVHNVI0VHJzWm96?=
 =?utf-8?B?Q0FMMkZkOGxzalFuS0NqUmhQNEZnZFhQSjY2dGdxZnIyTStSaHk2d3hab0ZP?=
 =?utf-8?B?RjFpYVVIc0l3UFZ2RlBIQi96dTBLYzJJZEhiMnlja05rWFQrclVsSHVmOEE0?=
 =?utf-8?B?RlU2OTBPWkk2RVRhU0tGTlJhc1Q2Y3BPaE5ybjc5U0F4TGdKQTlXbjltWGVt?=
 =?utf-8?B?eU82bEVzSldKaGZCWWFNbHdVV0JCekg0RUZLN0IwVVJNeHpTVVE1UXRsc2ZY?=
 =?utf-8?B?VnRhNzlDWDdyWElnUHVDNVcxU3NOOGxWS1A2eXRBVUtwK1lnNWNIT05RaWtu?=
 =?utf-8?B?S0ZUMTluNTB5Y3J5OHVHZVpCd3lVdGJOeGxUVTI2OEV4V3p4dlZ6a2ZDODg3?=
 =?utf-8?B?enhTamNkdm9ZN3NOME9zRmxLWVlHSG85NVcwODZtUktMWWNWZDkwQm5aY1JJ?=
 =?utf-8?B?cTR0VFJqcUtXTVZINlhnRlArVThqbG1ZOG9xaXkzS3JWelkrY1BxSFh1dnFz?=
 =?utf-8?B?RmptNzNvTldEQ2FMOGZVaVNOekZSdE4vd0FueVBXdzhYejVoRHRNRk5TRGFV?=
 =?utf-8?B?bmFVMlhsN3VDQ1NkTmdWZm1jKy9DRkR2VGN6Ri8vVzdwOHhmeDl3czYrU21C?=
 =?utf-8?B?YTBQM3VhOEhoUHU4NlhQUVpRRk9VMjdJU1JsdlA4WXZzRGorTU5pQ2JueW9W?=
 =?utf-8?B?N013WXREbTRGYnFERnNocTNQcFN6Q2hxaTBzTnZTREVwVmxlMnZhWDQ4cUp1?=
 =?utf-8?B?VlEva2hIMXExTUhRZm8zU29NaWRQWUtTNTNNNDBta0pIdTI4MzhsRmtjZDFY?=
 =?utf-8?B?RjJINytzMDA2eUVaczFKM3pqVkljdlJxRFdqVkZQakFMOWZTMmZxRkYrYnJB?=
 =?utf-8?B?OEJQL3JvVUJVSlJpRlNPWVRPdWFTTGFJTGgwV2hlWE4xWTVHMnpScXRrV0py?=
 =?utf-8?B?QU1tS2dyUUZvYTFiYWhvb3N6QlRrQkphWW9sNlJVZDlydm9EOXNSYU5udU9o?=
 =?utf-8?B?c0hoUDdXUUlKU2psQm5pbE5SUmRLWnU4T3JFTUhjb3dSOE5iOXJSZzNEQmJx?=
 =?utf-8?B?WDVZTWxHL25wVGVEN1RQZ3NpbitaUWdwY1Z6ZFhKQ04xY0I0aDc5YlhqZExI?=
 =?utf-8?B?OFIzQXZEbFhwajFhWHJhdy9YbGZvRUNsYzhmeGh1MEMveHZiWFBpU0dHVWdZ?=
 =?utf-8?B?ZDVGNkd2V3FVWmVSeGFGMUp1ZWlyL3d0SnhVT0k3M1hPUmNuQ2p6UzRoOGg2?=
 =?utf-8?B?VWlSVnFRZ3hqRGJDcCtYNVdlRnVQa09NaURJRDRCWFd2ZG1ESVlvNFgxSTJS?=
 =?utf-8?B?akRVdlFKT0Z0cER0a2dBTnlNSnRrakpKZlQ0c2RIU0JCYk91ZjJNVTlkRnpQ?=
 =?utf-8?B?eU4yUjdHSzNvV25Jcm9uUTlUT1R1SERVM1V5NFY2VytKZ1FabDFYRXo4UjhO?=
 =?utf-8?B?eVcyR2dOcW9oZm9XTXhUY1Z5cTZVSzBZTVZlT3dSUk94ZUprcDFZLzMzeEph?=
 =?utf-8?B?UWFFNi9lSnd6MzF0YVl3Z2hIN1RZVDhZMFFrQmhuVzVLbkszeFU3dkd5VEN2?=
 =?utf-8?B?L1JFbEJKV0pRczI5aWxzY0I1WHB5dEQ3c01MOUdDc3QycVJ3eEhwUFFkNyty?=
 =?utf-8?B?YVBmeXBBTlpERERLUWZsdWYzdUxJekNoSVFsektiMkl4TXY4ZWlMZ3d6ckM1?=
 =?utf-8?B?R3R5ZHgyWmNHNlZPUmlWRHJyVWk2ZWNlaTdKWGVUKzRIR2VpRjhxcjZHaERW?=
 =?utf-8?B?N3ZwaUdlOTduMmUvZ3ByckhKN3l3V1Q4bnZCNkladkZZWU1CcTFRWUFmNDhP?=
 =?utf-8?B?d3A2MnZsTFFuUEFkUGhDTHJYN2t3bTZPWWoySVFHdFcwa2R0eEpGMlR4bHZ0?=
 =?utf-8?B?WEl1OVVTNm4zSzVVdVk5d05iOUpod2Q2aFBLbXRTQml5Y2hOSGFSemxBTHVK?=
 =?utf-8?B?d0tLNVNGakFVNVZuNGtyN0ZVWTd2bGlFVks1S3BVNTZlMFo2SlNwMzFBdzRV?=
 =?utf-8?B?ak5ISENqdDhMdTZ3WkVaRGVQT0g2YkErTFVhYTU5OHhmdWxYR0ZYUzdBYmN6?=
 =?utf-8?B?RTdWQWUwUHQvdkRoVTIrMFE5Y0V1WGVBaDdTb0d1SHFHVEIvMm16UT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e25a3d-04bf-4c42-6be7-08df125eb543
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:08.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 86ZsecRlxBBsb4+epgRANWOS5MhVb0FhgIP9oTllR37BdhbKd3uU1V/Jmb3kBV8ZKklFR4NqffH+GVfveThH7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8971

Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
UniPro M-PHY attribute definitions rather than host controller specific
ones.

Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
Versal and DesignWare UFS headers.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
 drivers/ufs/host/ufs-hisi.c        | 8 ++++----
 drivers/ufs/host/ufs-hisi.h        | 5 -----
 drivers/ufs/host/ufs-qcom.c        | 4 ++--
 drivers/ufs/host/ufs-qcom.h        | 1 -
 drivers/ufs/host/ufshcd-dwc.h      | 4 ----
 include/ufs/unipro.h               | 2 ++
 7 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
index 2154d6286817..0d4d5e98ad65 100644
--- a/drivers/ufs/host/ufs-amd-versal2.c
+++ b/drivers/ufs/host/ufs-amd-versal2.c
@@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		u32 time_left, mibsel;
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
@@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
 		}
 
 		time_left = TIMEOUT_MICROSEC;
-		mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
+		mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
 		do {
 			ret = ufshcd_dme_get(hba, mibsel, &reg);
 			if (ret)
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 2d214ce9620e..bd223bda1ce2 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
 
 	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
 			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
@@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	 * check the state again.
 	 */
 	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
+		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
 				     &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
+		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
 	}
 
 	if (err) {
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 6af6a268458d..08dccfbec404 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -39,11 +39,6 @@
 #define MASK_UFS_DEVICE_RESET		(0x1 << 16)
 #define BIT_UFS_DEVICE_RESET		(0x1)
 
-/*
- * M-TX Configuration Attributes for Hixxxx
- */
-#define MPHY_TX_FSM_STATE	0x41
-
 /*
  * Hixxxx UFS HC specific Registers
  */
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 38897d01fde2..1e492dac8d93 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -390,7 +390,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 
 	do {
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 		if (err || tx_fsm_val == TX_STATE_HIBERN8)
@@ -406,7 +406,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	 */
 	if (time_after(jiffies, timeout))
 		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
 
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 3c6cb2281af0..1ec661277c1d 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -10,7 +10,6 @@
 #include <soc/qcom/ice.h>
 #include <ufs/ufshcd.h>
 
-#define MPHY_TX_FSM_STATE       0x41
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index a5e40e7604a1..0406f2bb576b 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -27,10 +27,6 @@
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-/* M-PHY Attributes */
-#define MTX_FSM_STATE		0x41
-#define MRX_FSM_STATE		0xC1
-
 /* M-PHY registers */
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index e0f490e11c7f..6fee545bdee5 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -34,6 +34,7 @@
 #define TX_PWM_G6_G7_SYNC_LENGTH		0x0034
 #define TX_HS_DEEMPHASIS_SETTING		0x0037
 #define TX_HS_PRESHOOT_SETTING			0x003B
+#define TX_FSM_STATE				0x0041
 #define TX_REFCLKFREQ				0x00EB
 #define TX_CFGCLKFREQVAL			0x00EC
 #define	CFGEXTRATTR				0x00F0
@@ -72,6 +73,7 @@
 #define CFGRXCDR8				0x00BA
 #define CFGRXOVR8				0x00BD
 #define CFGRXOVR6				0x00BF
+#define RX_FSM_STATE				0x00C1
 #define RX_FOM					0x00C2
 #define RXDIRECTCTRL2				0x00C7
 #define CFGRXOVR4				0x00E9
-- 
2.43.0

