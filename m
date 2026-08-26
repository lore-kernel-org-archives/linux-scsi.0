Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0DB427F85;
	Wed, 26 Aug 2026 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751663; cv=fail; b=mN1IRa/XZuCGeuNE6IShHHPT7ZXjlsQso3V7L9uDd5fJb8iZQg+0iSb5MHMMWvMu6IcghLCbC4VIpiap5YpDW2+piIx0DLIyEC7k/9d1KSUxyxcRlRXry/O9PWLqZW93RIsYd0cUwwh+kot8mb8ZyrYYJV8Ikp1hnTTEaZy0rUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751663; c=relaxed/simple;
	bh=7Dfi22EKeBKr42lOAF59B5fJo2nJROufcJPqdftf80I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CB3VGJxP0ctMaozx9mtDtkcSrSlifEjG8F1xNcfYV3inZGe3MM42yisS6ig0GXQEO/awEATydEBUotHeZ+ew88Q8b7Klg6kNk2Yt2tX8i0Dj4v7lBiYjCyq4ECH7GoHgCqtOm00n9hdbCVpagpMkm5ZesMGdyJPXskZdLgrosyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=a9AzpXRS; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="a9AzpXRS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MO/R/OEuJNSh5VWhA/VsIUZzY6NJt7jbD0mXOTa1TbrUpkSFMpjuIFMWmJjPe/HCTImH+kpcm7yNznGi0GdbCPWftVu/eoRNcffGy7wLZ1YvO7eCgob4yRMbxUlqe3IbdBWrAgp/AG6XDb/cuXiNNbnDqfSfNhJksCHAWv4rdHumu3Vzk3PagLse+kRGle1shygaazKBivStuEY9568Khu6ViBP1xHVUGMDR/PG5ULL4a6LOFHq6SDBY5D3N232dIL+kKmnq4KzDrAE0Zdwt5JCapsMwiAybGoGP/JX/f8GTKAfA6SUGwSeXHQJO3Hkof/U3jxRw2UJr3420moIVHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVZNPNMr++D5ypHEgOfxXl4Ig0PZ6IVIaZcK3VQEOBU=;
 b=HessZw1T60cOiaSDevPRCyD3U74ZfgpnXym4JB72DmGgyTpR39szHiPbpRnjFYRNOLSl9XYCcWDx3CzHs8jj4TPnHEn7weDsDZ18xDt3LgOPxN0JYctT7e5Ud+ZRNd3kqTerMNi56eM4SUBRrYyvq1Hh2Vq7CleHCNzQF/6abt+ruuJis74jK0O5RANSq1CnaT6AKHWUKe6IKk8r4q+yfxUBAACRFh+dyYBTuhv8tlL7vjIrt3o1dgmDr0b2wEeQzHlqlheh4c2qPJC6OWp8NXhpdypW1E23h0TGVZTA4UiyLDIWgSWpcqFaMWBMb33TL40qKgQvHiO7Ya3MVa1GyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVZNPNMr++D5ypHEgOfxXl4Ig0PZ6IVIaZcK3VQEOBU=;
 b=a9AzpXRSiuvdkoNbe4shujjPmk9oJga1RNChemxdmJPwrtCuj+miEBNdKcKVUIA+jEgBy38yN3QLqXzaWknwgGDnGG0sfBfJrahkx9+5hrlYiQhPy7Q3B+C7+N2uHmvpamzYwQXyg9AQ0urPvS98mNqQBNLUOS741c0g7zOZEMp0ZRPH0CJvKS41xRpWuthJzl+x1lxNlrgXl1RYAz0d4v3mWKD6cFG/deqkLbR1c5hyggP/DCHpmZDoAus2h5Fi8UK5+eFXn/+iW4KDXMl8UbmYE0HhDYptOpIcJbD5DdT/kStxLYD73CQdImeAEwJgWEmUe7wsFfrbnamQPGwD0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:40:55 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:40:55 +0000
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
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Cc: linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org
Subject: [PATCH 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Wed, 26 Aug 2026 15:40:39 +0200
Message-ID: <20260826134048.854748-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0382.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|GV2PR04MB11862:EE_
X-MS-Office365-Filtering-Correlation-Id: 203a3e0a-7482-4080-3d9e-08df0377a71b
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 8Ga3ws8wNp4F1SD9Pf5bDUKtbh1vMkdCoBYql0lS/QkH/s8/ZtQCJluos3lbVb2nGeNW/SkfAaeNeheptIrPDxWslrmyM+xesk5rd2POU7T25HLsg902RbfStWQMX2bf1+/z1rJnWyJedhzzENWzVY93xTEoSJVXQa1EzLTEmoe1hvP1yQAB4XvYt3u9ouyDGo5pFWX2AK9eCclqhwMZfRu5eErL1TL2x4x7pSk3EBNNbQMljxFuh22d//4WJJV8FcAQirhPkELsgz3AUM4SdfxylN4Nzo2MNFtZb4uHOfEYrvendbz8yDvPC3mkcCPMNcB9HQQ8/FofxCjCPciKN94DG6LJnG/RiPo68BrArxkg3FrMGPNQ9hE2h9qdc+kIMEsNrU9vuo3QQH6lRtuc7DXUvSk+FgF5k0DAX9/ExAZ8Iw/N5vckTbgCnzqLc+RUMXDuCrt/7B6wL3RxG3gcyiIAkoUyDpJiPx6NXlyQ5OfCg0fsYGjmLdKXXiUGW+KJaFBBvNVFe+wf1i4BHOIB82Ca9hdxusvVO4Dadnd20KlqnIFWDijqZwz5xI8UD9OL1AzJGa6smjiIQM3+xFa11lSKfbUo0pOkxCoi1WlwSmHsZuNWNfP7vKFeBy7R705YkEIJv2DDAxJLeuXD53TGXe7lV3dqlomgQDHEWDnlh3mDpxZtJY7sXJioEKpVrNJadRw4YgbLO+R7/HfEef04Fw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WlJ3WTNoUlVtOC92VjU4Y2tCWHRJZGxkVWwyWnhhcmJrUVQ1aEIva0FVcUlJ?=
 =?utf-8?B?MVpaZnBPRmdkNzBJUzMwLzFMNkZZTFA2MWY2QUZzdzA5VjI3L2dLR25VVERI?=
 =?utf-8?B?QjU2YzRpYzJTWCtPV2VlOWFucHE0dlZhdkhYckNLRjJrSkRXYy85WFpKZWJ1?=
 =?utf-8?B?cEdqSDdnVVFJSk9tVVJDdGdqNTcyWXhDcTdlQUZPY1NTZk5TelNxVEFsa0hS?=
 =?utf-8?B?OUt4cnFoN2hMeHY4SmlJdTV4VUJRcTZLWkRHeDFCM2NBcDlBNU14eW5rR3Mx?=
 =?utf-8?B?SHQ3bXRSTnVFM3dzRFFLRm9RVGU5Qy9GdHYvNG9UNXg4Zng2OVg2b3lhUHlo?=
 =?utf-8?B?VUpDSTVaczFyY0o1UTg1QWY3aTJ2d0lpblhDc2ZTc05FSVYwYmpVMDJZR1gw?=
 =?utf-8?B?WmpLaHVYM3g2U09oYnZGQmU5eGtLR3JzWFVEWnhYdlFPNmtjaStuN1JWZDhp?=
 =?utf-8?B?a0xTbEdURGduUSt3S2plYitXeC9IN2pKT0JHRHA1VEFFdHRmOCtXMmhac1VG?=
 =?utf-8?B?MmdqbE1UOEVhNTJiM3paVW4wakIxSUVBVllUOFNHQi9WcWZNekdFMS9UM01m?=
 =?utf-8?B?S1BqbWU0K1QrS2E1aFBqYW1WRzQ3bW0wd2R4aitTek00elExeUlrN3Q4WjVz?=
 =?utf-8?B?WlBQRmhIUWRYTFpEQllkOGY5M2hGS1pnRU42ZjhXajYyUXhnNzNraEtxVmRS?=
 =?utf-8?B?cVBDUHlTeFBNbzFZOXUxMnZ3WXVKVndjVXFoNE4rTDhkK1BBdTNvU2xFdUtW?=
 =?utf-8?B?V3RXblFJUVdlbjAwdmttTXZ4VHFjZVdvQU83Um9mTENmQmVWdGtxTExrL0pw?=
 =?utf-8?B?dFZyL2YyZWo2cStyOTZzV2VGM3docStKRDV0MEkrT3IxNUlKbHp6VXVFb21J?=
 =?utf-8?B?N0VvcWZPLzJvRnZwNTdLemhNTGZLbThYWGlrSzJpZTZnNkhQZ2NJK3hvVG9P?=
 =?utf-8?B?S3RBZlpTQVBCQndRa0hsVHI3TU1XQ3NmbGpzbCtYUHM5SlFwZDR0bDhKMk1a?=
 =?utf-8?B?Zks5b2FOS1dJR1YwV3BjcXlNYjE2TEJ6cFZoUTFWcHp4aHBKZzB5bmx4OGFG?=
 =?utf-8?B?a013S2c5WTBTUWZsM2JPRlN5Mml0N01ROHA4cG5meUx5RWNIcExkclE3ODFp?=
 =?utf-8?B?WTJnbWtnUGtHZXc5ZUhrMkl4dm92SFN5eW1KQmEraXkrL1FzZFk2alpSckdJ?=
 =?utf-8?B?YXlGVi8zcWJEUFVXMUJYSlc1WVh4M2sycTFqbFZ1QU40WkxSdFRjemxWSVdx?=
 =?utf-8?B?WUdJSzVnVXhtOHFPaFVyMzdOT0FTY1FOK2hhaTJweWxiVzYzeUh1UlJFWGd3?=
 =?utf-8?B?WklyM0NYa0tYRVBWQUlwMmUwQS9COWs3V3pua1ZGbWNrVTNzMDZhdWxIaUY5?=
 =?utf-8?B?YVBaZ005Nm1OR1pSd1F4Q29vcE9CbDJnbXoyK3d0QjZFVXFXVjJELzFXVkpS?=
 =?utf-8?B?UDR4V3VkR2ROYWo5S20ySHUyZWhVQ0VlSEJsREZCbEsycFVRMC9ya2hZUFh5?=
 =?utf-8?B?SHdBSGhOVGo0S05VMUo5dGJUQ1lFdDF3SE5STFAwcVVpVzVOSlZsYzhyVU9l?=
 =?utf-8?B?dVlpSVRrVkVYajc2eDcvYkMxR2dMdWd3c2pSdGU0Z2crRXBhTDJWOVpTZkZC?=
 =?utf-8?B?SmY5RklyRlZnazBmQnNXTlVjMys3b1dYbVZkdU94RGE1SFhra2hRTDRXSUJW?=
 =?utf-8?B?aTVlTDBsMjVPenBGeElZaERWaCtEYmF0NFBUZXRyTEtYems2b253elJqNW5H?=
 =?utf-8?B?YWxsUkFtajlhT3ZwVm80ZmJmRHloWFlZNVFLTUx6ZVJsN2p4U0JRVGV1UVdL?=
 =?utf-8?B?RVRuM2JIR1RQekxwYXVNREhzVWFMeEE5cHNhQzBSblE5UGthK3ZqdHVDRkRJ?=
 =?utf-8?B?d3pyYTZncHhxbjFVcTRUc2V2bUFCTWc3RVRRZjB6N2ZmejhvcTVZTVJSNFFK?=
 =?utf-8?B?Z3ZocThhVUR5d2M4KzlUTjJQQW9JT2lsZ2pzbGN5RHlxR0F6V3g3UCtnVE5p?=
 =?utf-8?B?S05RNGRlNG5jUTZEM0VHUjBrVzh2VlVRNkRmRkxmeUMxQzBKWkZSSU5PZHpS?=
 =?utf-8?B?dU1ZQkdEYVFFU2RJN2M5ZG5ocktGb0ZTakFKb1hRWSttQWlZU2J3NHhEVTg1?=
 =?utf-8?B?eXVBVS85T0FvaW1KdlVCMVhzcjZ0aC9wZ1dTZVlOYXNDc25veUVtNnJzcnk1?=
 =?utf-8?B?RUgzRmJhc2U4L29FUjRpMVVwV2w5bzNyQWFtZnFtSXVzQ21UVXZ2Nmh4U3Vx?=
 =?utf-8?B?M3JEOTNuYjRmb2QwTmNCRndNa3JSb283Mk1OMGZSQXVpOXovbzFLTmMzYWdw?=
 =?utf-8?B?OFp0VG5pYXZOTGc0eHh6UXVxL1ByeUp3YkZDaktsSndoTWtyS1NQOWZ0U3dx?=
 =?utf-8?Q?tzz9uMYPNn90T9fg=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 203a3e0a-7482-4080-3d9e-08df0377a71b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:40:55.0203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2O6LuertweSHBgGZatLP3X/QUvW+5K1bPfDbckb+x+kGp3DOrjqfhWh/oGtwxBp1zVnhKbYUh6tu3Zb4VEKLcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
include/ufs/unipro.h.

These state values are UniPro/M-PHY related and are not specific to
the DesignWare UFS host controller implementation, so unipro.h is a
more appropriate location for sharing them.

As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
TX_STATE_HIBERN8 enum constant. This is a no-op change: TX_FSM_HIBERN8
was 0x1 and TX_STATE_HIBERN8 is 1, so the compared values are identical.

This also prepares for using these definitions in a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufs-hisi.c   |  8 ++++----
 drivers/ufs/host/ufs-hisi.h   |  1 -
 drivers/ufs/host/ufs-qcom.c   |  4 ++--
 drivers/ufs/host/ufs-qcom.h   |  1 -
 drivers/ufs/host/ufshcd-dwc.h | 19 -------------------
 include/ufs/unipro.h          | 19 +++++++++++++++++++
 6 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 993e20ac211d..2d214ce9620e 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -34,8 +34,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 				      &tx_fsm_val_0);
 		err |= ufshcd_dme_get(hba,
 		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
-			tx_fsm_val_1 == TX_FSM_HIBERN8))
+		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
+			tx_fsm_val_1 == TX_STATE_HIBERN8))
 			break;
 
 		/* sleep for max. 200us */
@@ -56,8 +56,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 			__func__, err);
-	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
-			 tx_fsm_val_1 != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
+			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
 		err = -1;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
 			__func__, tx_fsm_val_0, tx_fsm_val_1);
diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
index 5a90c0f4e90c..6af6a268458d 100644
--- a/drivers/ufs/host/ufs-hisi.h
+++ b/drivers/ufs/host/ufs-hisi.h
@@ -43,7 +43,6 @@
  * M-TX Configuration Attributes for Hixxxx
  */
 #define MPHY_TX_FSM_STATE	0x41
-#define TX_FSM_HIBERN8	0x1
 
 /*
  * Hixxxx UFS HC specific Registers
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 291c43448764..75f569dd5cfe 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -393,7 +393,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
 					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
 				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_FSM_HIBERN8)
+		if (err || tx_fsm_val == TX_STATE_HIBERN8)
 			break;
 
 		/* sleep for max. 200us */
@@ -413,7 +413,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
 	if (err) {
 		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
 				__func__, err);
-	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
+	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
 		err = tx_fsm_val;
 		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
 				__func__, err);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e20b3ca50577..b7b68333fc32 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -11,7 +11,6 @@
 #include <ufs/ufshcd.h>
 
 #define MPHY_TX_FSM_STATE       0x41
-#define TX_FSM_HIBERN8          0x1
 #define HBRN8_POLL_TOUT_MS      100
 #define DEFAULT_CLK_RATE_HZ     1000000
 #define MAX_SUPP_MAC		64
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index c618bb914904..a5e40e7604a1 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -39,25 +39,6 @@
 #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
 #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
 
-/* Tx/Rx FSM state */
-enum rx_fsm_state {
-	RX_STATE_DISABLED = 0,
-	RX_STATE_HIBERN8 = 1,
-	RX_STATE_SLEEP = 2,
-	RX_STATE_STALL = 3,
-	RX_STATE_LSBURST = 4,
-	RX_STATE_HSBURST = 5,
-};
-
-enum tx_fsm_state {
-	TX_STATE_DISABLED = 0,
-	TX_STATE_HIBERN8 = 1,
-	TX_STATE_SLEEP = 2,
-	TX_STATE_STALL = 3,
-	TX_STATE_LSBURST = 4,
-	TX_STATE_HSBURST = 5,
-};
-
 struct ufshcd_dme_attr_val {
 	u32 attr_sel;
 	u32 mib_val;
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..bf063edc284d 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -466,4 +466,23 @@ enum {
 	CPORT_CONNECTED,
 };
 
+/* Tx/Rx FSM state */
+enum ufs_rx_fsm_state {
+	RX_STATE_DISABLED = 0,
+	RX_STATE_HIBERN8 = 1,
+	RX_STATE_SLEEP = 2,
+	RX_STATE_STALL = 3,
+	RX_STATE_LSBURST = 4,
+	RX_STATE_HSBURST = 5,
+};
+
+enum ufs_tx_fsm_state {
+	TX_STATE_DISABLED = 0,
+	TX_STATE_HIBERN8 = 1,
+	TX_STATE_SLEEP = 2,
+	TX_STATE_STALL = 3,
+	TX_STATE_LSBURST = 4,
+	TX_STATE_HSBURST = 5,
+};
+
 #endif /* _UNIPRO_H_ */
-- 
2.43.0

