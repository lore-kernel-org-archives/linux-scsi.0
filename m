Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0F35A39D;
	Thu, 17 Sep 2026 09:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636567; cv=fail; b=PLwDYwk0jOhtx4mqzzCuIN9tNKyUTF7nXAyG++2razaOMTjVaeoIwy23BqYaMIUGvHIFng8lTUk9REJfCWAv/+2J/axZOXnAh4yVJyZmWP6YBzY0ROsQgmBiEi7lLjChBRhxCZ1frM4KDMlQQ5JhW0wRMKUAtlHnotGHZ9S20JY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636567; c=relaxed/simple;
	bh=gIP6A5VOW2/NTGYiJ9SYVMLVTO4nlUYxOolsWodY89s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KeHO0/zUsff36Xx27rfDgXlusLJveKSnzptlXH5B9s6KKiM/5PUBFsa70m5BpuGxpCei6uq8L0RmHUMjeJwXMLsHHP1GcU1uFrelZHyE8jNC6ur9lpErRQ2YE+mg9ObSrRmfYRxPCsI3LEDsofrco3R8sZIBv7pDyWNE3U2BUO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=svxd/6jz; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="svxd/6jz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jv9Blb10h3L75kL99A45x4kSxWUWaU+FWI3fIZPZOezxrYI0FIWfe6llrsne6W9zldZioJ1eR5eT+vC/oLtGl5rQMd8G2oT2ZYffFUKtOfCKgxx+EWQwnGjh5pS0oCo7ZDb0QPdnOMhJ2oa/rPTl+HidEyYuIQONsFtVaWTMyfEc3X1nxv0hY7KRsHpX96N1j8I1x48kIHAxEhAphdbDia3eyNfb5ZZdNeovin/BXCTtcBCiaHPE57M80Ahob3f1iGLr/c1zCRk4+p+6ezfZDI2UqbzEu6WTqprOkeIB3XTdnVtiedGl3gOmsXHDSuipVIXzcLk9SzS2lYfx+ISoQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6uzWGCjM+HfpWtNPV2VGr6nxQBvKn9OL12I3ddxxPgs=;
 b=aJz6kmtQaTgTKSS2LZhI2iA0vy++qgwEypxZ98/fPMyYU8xE0ClKV1eVth7s8qsyE7P2pVaed3rTYKzu/CWmwgItgGUBQjtIdWwZWiWGUafqmnap+4H5GDh8LEEUHuSl/WqhAp1kQctUOfDb6SNvAv4H254nPqza0Y/fExeoYRycq232M+Tuiep43ExlM+BNfK/wVVAMxCTnv3nSMqTutSwQiEgKfsYykk+qVPhK9iqTjJcP2qxjZC3Ww2xgMKqXG1P3/lGfu68uS2LnjwajGL2OKJmfMxYyLPPpkm8Ov1P9x6s1QMzES6mBPv0NTMvOepAYAWH4ZbSxkTz1q719Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6uzWGCjM+HfpWtNPV2VGr6nxQBvKn9OL12I3ddxxPgs=;
 b=svxd/6jzPK7M+tJQYGcR3InVaNTyooNTCQ7A3AG0RYtcC1o7JJO0vCDHdDs4YGkgyQFBVEIssuXiIDmr/u/Qmk7miz0oxDcps5h9c6UeQqBbGsSNCxfOWQ7j4sYYkH0aBOX4pKaZ8LAuqF8NPQV37nhgpHGyaZoWYBqfb9HQ0dvjw11p31pGAGRYIhHn9QQK3xwjOYZaK2YoDoKmyw6omXK4cWp2QRD/SETolpq5ktBTDxPQGnalDwmTsgdpHVwVIidFZ46F1h6aaBtS3oa0UCBaiOX8YkXF5ttj2DrP5yMlfbX2kRPPgdDz35BL1WniEiaWHFRj/KxwEfbVP4kw/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:00 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:00 +0000
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
Subject: [PATCH v4 01/11] scsi: ufs: dwc: Return a negative error if the link is down
Date: Thu, 17 Sep 2026 11:15:45 +0200
Message-ID: <20260917091555.1443076-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0067.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::25) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ba7d33-3aa4-4b8d-09e2-08df149c4a61
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 XX3NGATTow6aVeipQImU6+VJDhUSxVBcbAOItG1YFAXiwmdl/ru56muDgCKfmqzTLRfa25NqhYR97T4lI5GUuyZDsOITdTKD0/V/vQ6zuHJkmzA1vynaUHjfpq6Iq0Gy10bk/Sdbk74XqhMqKQ8cJivH2NutHMfPwM7u3iSfXkol9ptpNDGsXuLHgdL694mZoL0JjDGQSXwbMLNujOYL0ynzXqyWCGx6hlszMWwGjud4+aFRkGvcB/yLTrQthJ5Mwok+d72HTY/BW4mw6B1AjLkn55yttkIxfDL/FXwlPJy4d8bjm/SlL/iHQ1MfS6dZmCEQaQJDIWtq+x94KmTcGfcOkyRF32o8ljA6m5uMjZqKrUeFAfg8vRLSf0yEDA62oLiec1IiVyucbGt5G8jBA3/vzJZxb0a5XEVl7M4IyNbQO7pWJZ6RK235zyACZlzTyuNdoOnd+7dg9AHGlvCZSYpXYVnQEhrSftfbiX9gUiWlvXiyFDwZvbtiw6xnWcv7VMVwoq4rjSAU0tSUrFEuhvE497+ohriQECOKDrvwvPPGKQ7r+ME1zMaZ41oFGX9EDMy7YlM5NAn3DxSEOL3SsThywFU5X95qV5nIY7nsIQyTaQnf1aalAyxK72o6F6JMC0nmovYO3cZj9RTnHhMWC2ENoOnIPm3thTA9eaTd4OIGBTszS9/L3L5N3RjUfPAEuvnNGuWyCzx2Xob4mtJ4fQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WWpQWk5uUnFjVWlWU1BtQVpSWm9KVGlBb0FoSU5xaVN2OHRXOFNkVG5GZmRa?=
 =?utf-8?B?MFVReXRUWjdXNDM2bjdjYTVuUUQ5S3lIR0xDYXl6VUp0NWptK1N0L1Q1SFJq?=
 =?utf-8?B?OXBGWi9yUWFPdVBuakV3VytoWDZPOTU1TTVHQ1VnelFrK1FwdVczQjUrUEVU?=
 =?utf-8?B?SktydldHSnhsSkVvTk1oaW9xQWdTZVpaa1hqckhDd1BjalhZMmRLZWQrQVJz?=
 =?utf-8?B?Z3Vhb2szcWZaS3RtWFZVa3BBMGRzVWErQ054V1lyQjl0aUUzWXd3YUI5VTJv?=
 =?utf-8?B?b3lPN21WUlpScnpQSEtwVHZhWjlrVkU2MC9HRmFUSHZpalZDY3M4dzdSZXYy?=
 =?utf-8?B?b29YSzUxdkV6Vlo5aU1ha1hUcWR5QkJia0g3c0VOQXhuK2ZVM1Rvb09vMVpz?=
 =?utf-8?B?SzJBeVQwV2FuUVhzYXRXR1dIQ2RyMW4wbEZLTVJMSjI5VWN5Wm5FdzBnSkFr?=
 =?utf-8?B?bFk5K0R6RHlzZGxzTldlZE1lWkZLa2MvZDNoeExzclJrOFZ4TUpWZlhMejlj?=
 =?utf-8?B?azhYWHpIcitiTjNyODJaZENRMW5yTjFSeVpQckFHT2JaYVZkbElZUzBLREVw?=
 =?utf-8?B?aTlzd0xkamxiZUFIMFE3Z1BEVEcraXZiWWEzaFdxbnlwMFZaTUVET2VBV2dN?=
 =?utf-8?B?OG9qRldyTnovRUhwUU4rZWZqNWdFa3psU1NteG01VjN4NkxidjVqNVE0MVUy?=
 =?utf-8?B?RHRyald1ME1ydlZYcWlHdldPcmlwV0N4cHdSUzdzQmN2S0VQNnYyWDRxNExl?=
 =?utf-8?B?M3hMZi9XSytVdElST3VEUmUrbG9iSDA2NEsvT2NnZ2hOWGhFVWU0ZTdEYlMy?=
 =?utf-8?B?TVRXNktCWmZjcENjNjQzVlAybUxhaCtLWTIwN2VicFRLNDhacS95Yy9DWUdN?=
 =?utf-8?B?MmJvZHRUejZITHZCNVpVcEN5dUtSclZwRjRsSVM0RXFZSTA4UG96YldKaEl5?=
 =?utf-8?B?UnYxclh5TUc4ckNvM0l3Y3RpUHoxTzFIV0RjSGdLM0JzbTJxSWZTb2lOOGVQ?=
 =?utf-8?B?bzJ0SUhvSS8wTEg4enpMb2JETXVNYXQveWpIeC9oYU5tNXhJNVpPb2hxVXRM?=
 =?utf-8?B?alpkZXRpZ1RrcXRuVFpOSXg1R2NINFJFeDMyODdHZkdXTnBJclplajF5YVcv?=
 =?utf-8?B?NHVHMWZZbG5jNEVhV2JJcm03aFhEYkpaOVN3NjFCWlNPSDRldFE0aFl4R1hi?=
 =?utf-8?B?MEFkeEZsNVF5TFNhcUJ2Z0lrY3p4S2QyUEowNFc4US9XMWFLSDA5UkpIbEVT?=
 =?utf-8?B?MWxOb0pyRkQvMHJQdmNIYUNOSFlVb2t1dTZjdTNGdWMxSWNjV25nNzdFcFJF?=
 =?utf-8?B?Wk53KzJ2ajhaWXFESmk4TmU0YlQzRjJaQmJLaTRFeVRrMWZ3c3NEVWkzUjNj?=
 =?utf-8?B?dEJJbkl4NmJWOFVnTGM1S1drQUhOTXA1aG9TUnhPK2Zvc2NvVEF0T3gzYk92?=
 =?utf-8?B?My9JaXgyYkFMMTFYMkxVRlo0STh2b2pTZnpNcUVyZFJFSDJGcVZOTVJpck1n?=
 =?utf-8?B?djFTazM1dHJ6cEhuNSt3S0pCWnhQS01HTkZHZ2VyV0NrdjRmRjMvRmU3SnZM?=
 =?utf-8?B?MEFiQmVFVU5GdDlaU293OEVQMk9sT1ZpUEFTSXFPMzhiaWoraXc4YVVtS1p4?=
 =?utf-8?B?MkdIS1pqaGNhbGRkYXZadXpjdEJocngxaEo3VWpQeDRkdUdwUTRUQ1BCNnBX?=
 =?utf-8?B?NnZBc3ZWRjJnQ21XbERyYVNTMEMyMkJjaTFENjU5NkhWUHBvWm5PYkN6eVpj?=
 =?utf-8?B?VFIzemwxTXp6eSt1V1dYN1dPanUyR3BaU1FHTEJoN1Q2cHVtaHpPdkFMMXB3?=
 =?utf-8?B?dHB0bEZTMEEzSFp4emFwbFAvV2pkNXY5d2sxY2FVbE84TzdDZlUwMUhDLzBm?=
 =?utf-8?B?VExQYWE5NHgzanBIMkJlSjNPSEJIak9tWDJiTU1kdWExYkE4YWw3N1g3azNX?=
 =?utf-8?B?NDBxamc3RVAxd0gyTjRxckhSRmh6OEFWeUhFYW1xekdUMEQ0Mm9oeDExRzBw?=
 =?utf-8?B?Rzl2TGxTVml4U1ZzdnNvc1VPUjdydFVFVm5oTGY0WlpFSDMraU41T2dGWXZS?=
 =?utf-8?B?REM2Zjk2ME85ZzkyOVdXTVRkdEFXbnNOMGxQVzduTFdGUmpZcmFKdUw4SXVy?=
 =?utf-8?B?ZXY2clNidk1vdlQ4aDE5UXNLVE9SVVdLQlpZdnAxM1Y2MDdhMWpnSXphb1lv?=
 =?utf-8?B?d0RUeFExVXNZQXhMdS9PUmlhUTB6cnBaemxKVXNwbEJvNjVYRG9TUm5BY29r?=
 =?utf-8?B?Z25yYjZSL09lZW03OXBYZVRBSS82WWRFeXhrczBoRVhHWHEvQUMrbVVBZEVL?=
 =?utf-8?B?WS9lZzBXTUtUZVR2Y3Q3SGlJdGV6NEZkQXc3bnZvYXlrV25aanFrUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ba7d33-3aa4-4b8d-09e2-08df149c4a61
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:00.5978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVdK7iWoIhvmNxTVLi2ieBNYSpTzG/FLcA071gOxbSE+UiferoFMImKoWYNJz1wqnDrx92yuJr5+/+It7GBoEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
value may propagate through callers that expect failures to be reported as
negative errno values.

Return -ENOLINK when the link is down and propagate errors returned by
ufshcd_dme_get().

Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 21b1cf912dcc..ccf785fce6cc 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  * ufshcd_dwc_link_is_up() - check if link is up.
  * @hba: private structure pointer
  *
- * Return: 0 on success, non-zero value on failure.
+ * Return: 0 on success, a negative errno value on failure.
  */
 static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	int dme_result = 0;
+	int ret;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+	if (ret)
+		return ret;
 
 	if (dme_result == UFSHCD_LINK_IS_UP) {
 		ufshcd_set_link_active(hba);
 		return 0;
 	}
 
-	return 1;
+	return -ENOLINK;
 }
 
 /**
-- 
2.43.0

