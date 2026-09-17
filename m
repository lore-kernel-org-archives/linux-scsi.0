Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010025.outbound.protection.outlook.com [52.101.84.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED44A7C9E;
	Thu, 17 Sep 2026 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636571; cv=fail; b=uOQFUw6PPV6X7gcwh9pT4bbj5IVRa32+JCgi0h9Ai7qys+YIfcJE2O76jvntNwwn05Ds/UKOc8wXjtODblIhjUE8XQpTQ88EQAXMHlNy9mb083sUlqz+ILgq5K8XCgVRS9TnfErY17854+ox12E7otdFGTKJPaN2gUfpSBQhN0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636571; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ElFAYN1Rx6LTD2KPhPgR3F9pzlULyfRElHo/Bkyg23xEtSvIewaE8+UXAEoLpN4P3gBG0bJ7UJslJn4IopNpcEh3oxhVg3LX2IIEWLkN0MhPIcmd1sak7rlTeE+lH7jP62ZUn8QK1jzf0MwuXi4pv/vg5fQdG4ZZFpHcbRrJ+R8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=RdnB8Iiz; arc=fail smtp.client-ip=52.101.84.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RdnB8Iiz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GXQNYyYCsML2yRKKHrpQPHjaecgdFsVNJWsms4nDIWkfAoSDRyKbsDIVFIbhKRp5iR3iW5MCKgnA9k5CbFueEkcO7INdvJ4LRD8BAdft4Gh563tN7iKaQ4MF5iY1f7IKCEkISgfm2R0TM2GtX+brPZdtiRcRiIjRKEFI7a4KTVhpgzDptZHeKQP+pDn32OPcv3dHNjPjv2COyRxRELpgUn6xz49dDuEllbgFxgyojuyOmUicmgi37I+LN+sCFp8It9+2LNU5DkUMVPbTU6S9fLo+t3FYAKBAdBfVD5bUuDWN0tb69yqsD6wZFn4hlz4aXZ4Edjy1MI5ibmqYgMHe/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=QQt5eybONKN87Gi2EgH/TISwqHPGY2ux3ML/eXc4fC4WQwT2zcany7vbZGCuosCNKkRVd6SW09fD/kMTeGDQvYYXAy2jELJv/ANUtZuzKRep3O16GPViUyJ6hWh3G0GS3SohogtE4qF9+JDyy3Cqfcy2pT7TeHqno90rICUozh7rrs0h6HDT97aOs5Yl7+yVvH4MdkuGbDlPi889WSJ97pTtl/fRVUuiTWJW95xFrf/eU/yAkRPU/zbIUzg3IBrZUrcJWe14YZIBNpwRLaYKiZKf3mL+W9RVOs2OYCWPmMX5wUukIwOZEn6VMXbHGRtgUaMLslsD7P16+g0CiBgCjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=RdnB8IizFN7PI6GUakOOXSgFPv1zlvjkljyMBUdE3PV8BfB7jvBdTv8CHrTuTkZVR6eJ4qZgzFyCrSzyQeryitxPbl51KZGFaYdHer5hSNlfEb3iAlNoQwYemMrxJBm28/Ddq5l2Kt1OtvvnWaPo0nf2LLZwyOZSpUOaEkKeNDwTRzojOiTJPp+jNR9ekIf/7wlgqFCGnGmwkyvfPkGXgEn9YHeGsJCahNf3sXc8eJ8A7TKrF83PfM20pY5fx3ao6wHowY0zaA35RPFo3m2eIcx0LWaCGcRcwqmCxoOIdZifeSST+9Hd2cc1ZMSRN6EZ1ORlBKlbnyJ6gd/P9bxTgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM8PR04MB7873.eurprd04.prod.outlook.com
 (2603:10a6:20b:247::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Thu, 17 Sep
 2026 09:16:04 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:04 +0000
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
Subject: [PATCH v4 03/11] ufs: unipro: Add TX/RX FSM state attributes
Date: Thu, 17 Sep 2026 11:15:47 +0200
Message-ID: <20260917091555.1443076-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0061.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::10) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM8PR04MB7873:EE_
X-MS-Office365-Filtering-Correlation-Id: 25565537-3c6c-4276-7ec3-08df149c4cb1
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|7416014|376014|23010399003|1800799024|10067099003|11063799006|56012099006|6133799003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 iV8LTFdhxT7IBbcOEFbDXhvdA6kSn5EDy9qEqAJN3G657aQmRMymCMKPIK+BBUtoxubCyKPbQ1hSmnsGtxW+GF2+uDKQ0duC6IDPMCCkzBzY+cysaRB6Z5dfklz8s5TmATnF+HfnBIrtfmrxJ6K+eTsCy35gjcyzFhJNtVvg6+XidF/PhCVryNzK0Yoviu18MNRGBpaEqbQE4wesA8QvBjHgTjIQS29NFCegy3k0YmmDkoXxFm9aOHUCa4SbrTdgRLG0wX/wdbSZ1BJBOR/wOkz0EHWu0rs21b1XtD9mwRHwBfpzw05XXF/vatk5D9qQOaN0S37ik2+Dm4P0yiyAc1nk63RC+a2ya1ngwAxWqR3jubCeLyFKTE8CKJL/DqN6Vzb1yXl5oXQJE1YFCan8Vftei+zhC+7WCTDqJJ82U5q+WMLg9H9eFStC1sqQ68euEm2xhCaD9qREWu82Trq4zEibF7E6nSP+mEsYE+kJ2iAQjhn2uP6W63oV+KpCu8CbgVKuJfghqCJqLBC4qHlu5ilxmokLP5yAifTY6ZmH4DxbmvWwigxCxvXHD0bVLBjlqxwjzrJcLdPNR+5zTtK6f81mgJv3yfuFccve6t7ucoUhRBF59eBgts5cb5zM+2BNJVyqgFqgiWIoTrPRNcWjlEsGAarLOnO7SKPsIvkAAkPGMTFfkBZPA2cv4l0lw1mZ+aX9YR4AEi7SFt1C9tKCZA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(376014)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(6133799003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Z3hpQjJXNFd1bG80N2o5RzROQmpNb1dmKzFnZVJFV0cyUDVtMGtnanJST1RH?=
 =?utf-8?B?K1luWG43Nk5jUUs4NG51QjBhNzFzeTZBNC80cWUyWGRLcjRzRFA4MG1Da240?=
 =?utf-8?B?cm9RZWZ6RFgvc0pnVjlIcFBkS1NiRTVHajFLUytBSlVTUFdvalY3dEZDazZj?=
 =?utf-8?B?VGlvNDJiRE5SS3VKQkkvWXhFLytnZDVWYmdwYlpLY1poczRQdkk1dFJqMEVF?=
 =?utf-8?B?bmNNUGN5TVltSVRNWEJmSWRhbEFKMU9BYkpjUld3ZGJzbTU1WDZNRE1jY2h1?=
 =?utf-8?B?OTFNL0hjNXFZNFBJS09sZUZHeEVPTmFTRnYwMWxJdmMvRG1EWDBZVTZVNTV0?=
 =?utf-8?B?TjJDQWpUU3BQU0JkK1A0MEt2MDZZVVQ0amRXN25tbC9RVlZQZHNSVm1GYmU5?=
 =?utf-8?B?UlBzc1BsRXFlcXlGZFBzYXFodmxwc0RWTzNhUUtFeU9qakZSbVRLY3RSNHFy?=
 =?utf-8?B?WDNkSU5YNFF4TFI0NHVlZFQwdE5XTnEyRXd2dXM2bGt0RXRiU2JpR3puZTQ3?=
 =?utf-8?B?N1JUMWczVVBhOWY5RWx5c2l2bUZYWW1WUGJ2eUIwWitqUnFjTnQwaFBLS2Va?=
 =?utf-8?B?dTVUZjZUUFZBYlYvV2VEbWladDZuV1Bjb2VlTWZwOGdkNWhnQW1JbHBGWC90?=
 =?utf-8?B?NjRNamFGa0RCR042Y0dEdWRrV0xLd3BvdzRudHZqK1dIVWVoTFByUk5tYkIv?=
 =?utf-8?B?K1ZkT2g4T0tobzBwcE83T2pPZjVaWUVNZHBIUksyWThieHc5aGdCR0puZVBa?=
 =?utf-8?B?Y1NnaGR1SXJ5V2xFUElqVzFMUFdWT2M3azVvUGljRXhkRVZubVJVUWV3V0I0?=
 =?utf-8?B?SEVlTm04d1U5VUR3UFQ0NUVqa2xwU2t2L0IxaGt6enUwRlhRdWFsQ0ZwR3Fp?=
 =?utf-8?B?WlJxRElhdzFNYXA2YVY3K0ptYVF3eEordVJVS2x6ZFVqNVptRnpUTWZpRGhi?=
 =?utf-8?B?TmY0Rkk2eHZuTmdlRExvQk00ZkR0ZEdPYzJDRnF2SC9hcFI0TzFmQnN2Rzdw?=
 =?utf-8?B?MEhtcDB6RXhJL0QwN3ZNUytEWXorcnNNYUQ1dHZlVWtMU2p4Sk1vUEw2bEdv?=
 =?utf-8?B?YzdkRVVmWHFPTUkxd0FmUGxlNzJqOWJ1d2lqKzByWlpVT01MZHBMUHFPaU9h?=
 =?utf-8?B?Rlp5Zm9wTENkcjIvWlB4SCtNdU1nZFVhcUtyOG1JVlpNdXFhNjBQc1FqNUYx?=
 =?utf-8?B?UlVDVUtSdkVaakpFb013aXd0aEEwQUIrdmQ4R1pUTUYzS0pwY3FoMThGdkZo?=
 =?utf-8?B?elNSR3FuOE1WVEQ0NFFKbTYzOUpxRGNIelRNUlY0dWNrZG5SdlZrNkV4bmZP?=
 =?utf-8?B?a0xuc3RuUkNYTGI3MzBFSDZQQU9vWXZCRE1CY3lOWlR2QzNCTnNQL1ZIOC9m?=
 =?utf-8?B?SDBIYkVlTWd3QUVBdnB3TnpFQk5WYjRLQ2hSRFQ1WGc2SEx4cWJvSlRhdmd5?=
 =?utf-8?B?UTAvWWFVODB2YmRJWkdEK2hZMm8vck1YS3M2WU9LZDZidENxUnJsejFBa2N6?=
 =?utf-8?B?SVNyUnZmaktKRDVaYVFjbVFzY2NyNFRYRzdxZmhQaVU1ZG1rY2pRZkQwNDZh?=
 =?utf-8?B?VUFtSTIrbldZaktQZU44NWpGa242VUorV3dlK2s3bU5MbmZpZEZCZWdubGRG?=
 =?utf-8?B?L0ZpdGk5akU4RDhxYkdqUVZFd29ZMTFqbmo5b2wreGJwY0hua3Mrd1ZjMzY0?=
 =?utf-8?B?OVM0dFJRbFZuQTlEeDlpeVplYk1qRTU3cENRcmk1K2wzRmo1NWVvaEVJRCs1?=
 =?utf-8?B?QUJENkROWEVvVHNEb2N5V1puc3lIOGN6bFpkcmZJZWdqYTJ0ZEEzWXdOcFJo?=
 =?utf-8?B?eDBoa2JJTDJZK01vQXd4WFZzc2JqNU9OMTFkV3ZQclMrckx1RGg1c0w3TUpS?=
 =?utf-8?B?cjBtbW9pblp4VzVpcERUNW1mVVkwTVZCYmtXaGx1ZHdjOGU5UTNCNUZnUWJT?=
 =?utf-8?B?M3Z4NzdQdTNieEZlL0FwQnRvWUdZNE9hWjg2OVhmSmtObW5DaDFQR3JXdjJV?=
 =?utf-8?B?cHZKSEx3UEFzNkdFVE5VZ09LZG9IYmNOK21GSnhkSlJYaTFSZzdBWFBocDB2?=
 =?utf-8?B?L0s1Ym0rdEFKMzlGZ0VHd0ZNYzhyaWdhMkk0cmJzdFNIOGI1aEFlOGNqdmh3?=
 =?utf-8?B?dThkWnd3K2p1TnE0c0FsdlFIWjRjM3lSVEpPM3RzZHNtUW5hOG5aaGN2a3Vt?=
 =?utf-8?B?M2Z1ZG9WWktRUS90TzA4YW5JdldpRFFWSHJlWjdVakpOTnZkMGZjNGJlY3l2?=
 =?utf-8?B?NTEyYm5EbEdZVEQ3ZUNBKzUzOFZ6ampPUW5XTHUzdnVxcUxWeWsrd1dpejZL?=
 =?utf-8?B?NEN0QW9OTDI3R1hYTTVEU0lyUStnWlplNlNxbVh4ZmZoUllkbGJQUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25565537-3c6c-4276-7ec3-08df149c4cb1
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:04.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Va8CVMJHxmxBqm4XZqtT8wRzHXpNMkLPh5ciVmbD+tPwIR9VriMTdxQnippz07rdy0dnbte1gKEzk+Oku2CFXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7873

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

