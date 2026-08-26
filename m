Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B6C3BFAF7;
	Wed, 26 Aug 2026 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751668; cv=fail; b=j3Bvyv0gr3pYUDWU+uiqJvofrNGJoBNExpvyM5rWS4uwIR7jim1h5Utyl4PSQ1uneoQ1bSq8PCxoVxJS2n525zGLck4n/dpq/QjvWPH5QbHuVLdkCgjeUbynBPSCmWX+Ulchdxbsyd+BpIs4DcL6kxgit2KT/tF6ybd6fZdc764=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751668; c=relaxed/simple;
	bh=WgxfhdcneNQKxphU7XUa9S8jOzZu3NgMAj3XiPJs7YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B4qMf/CeUy30WgAK0+RTrC3h+gZdiRGhKa7C95kqYDiphWsiz+ZSidApaiCuyWHPDfdSPapoFjxpZfPUtn0ThGasYacMX7JYvC+VatWiqCT8Sue+zvi5ZjlrOehJwSmOs+zMij2vsXTlaF8E7RgZYIbKT2FA4duTSq4xetXysFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=KAIjC07d; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="KAIjC07d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etuBMPPNQYUkv3Apiw2nSz7XlhqBH2XdTEoTZCMJPZjDaxlrnObc/iLSFc3PzlRb9KKflMCop8TwZVG8L1rvZfHN68drXbB1HGicYfd3c9b0zYuiK37MiKehUwWDKQsaRVhxrPSyvyZ8fuI3/vgrgS1wnHFHaP8GtPVoLFmAaXbebv9XQ2Y/8kwVxGrb9RGGrejiVo8vJArz8ES0ujLVZA2qUdespAWLv3Bo6QoEL/DmP8W7TPpskYoQmcfueXFApbekHby7VkJvoO3QcGv0c9IXT21C//KcmAfvO8udu6fyuu7xc4qH56xwmPe7aAZE5HBOR03cIrfBuqIrtno0xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VKraCcVoUYaT+fHlG6gWjNXoLGAu0jQ978z4qyCPlM=;
 b=GlwtVmoDi8BiF7vyn+qKhUfK89YONKmjMPYmkB/fA+aDJQwaV7ObWKWNDNYWLvGt9x8fiT3oPEc04wo0BNpEL0XQFwEb0IPC6cDt2Qe9Z0k1PFa6FIfZ164TesQ5QPVZ8fyx2hVaS0Xh13PDyairIhKxSNDEtk60bcEB2p5BqKsfuohmlA4x2Ur2BD9yDEegTRP2cTVJVfG5VbpBkfC9ZhMMsFjIY7Fj2AUHJ370RqACEsMhWV3iC6L2tyipnghzGOj+Ybdx6NLrqjDp8TgYvSVJxj0YEvUkU1mPPeSuCb66vzv0f7+cFxDKxjZdauqB7Kz5m08Zrd7ivBBgh3vgxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VKraCcVoUYaT+fHlG6gWjNXoLGAu0jQ978z4qyCPlM=;
 b=KAIjC07dRcEgO6VqSNqN3dh1HUad0CyQqJjsWpViKfTsVSZgv5+wL83PLOaEOt6XELd4DvbtmRa804kUNYBhsrBvQQ3BAqIQZbwz7d5ULKtvj+QMzJiMKJzcOAizRBmC01BeaqDhDP1d9IveB5pE97sMuRHj0MGSnRhqwVwRKju+l30T7ZSE/buYyz13mznfQHktalxhC8v6yVr7J7+5x1J6ni7/moVU5eLtSr7CiTIjYguF4blMmxcdEqGEkvnAEZpOA63jNspKHBnDAns4PXw9IPU+MR7iUnLKqPdqukCMAlOPlz9N+SdM0SNaPQS0Avu4HBkP1LPlRaxsz7VyyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:40:59 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:40:59 +0000
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
Subject: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Wed, 26 Aug 2026 15:40:41 +0200
Message-ID: <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0386.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::14) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 02e619bf-7320-4159-6bd6-08df0377a987
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 +VhtmK4DRyC+E7O1kHkRhGUf+FhMqMkJPu+0Ue5BacFZGuIjApR2yMMJ/RkczDl3aaYtpsX011wr4gfCUgX0OaGcLG22A3iswVVuG9nClrYKxNz0wl8pJj1tPfVfQHprmF/cRBbylScsA6nqTRVq2aPPaGDugnpR6+lNTBKrPNKEQN86Z26dp77RnQgB2NHRLxgfQw2I+GfSfcvNVnGot0SBoR4k/K10uilW71pz06/IDSAOxESJWLm1as/iUXrpcIV9U2jS16coPjTq1+FfUDvxBzDDgQQ419GiJKJEDvCeN/HqCv7ROBw5qBcJ3R3gfxiMmpJVfQhYMy4SxhW5m/eo7Hczq3Z8wo9pnLEkeJea/emPeL6cHVfhdr38BSkcWvi40DaOp0a+GSbdp3gIjkSYHVQYQ6IRu750TBLIMGeXq6Gbb+mK9HAo6Xz82C590ygL3s19WWWUSgsPfWbvnljbCQHFwAAXdxATmRrnKL6a27mOwX1CySqgnrNrnuVqMPbC1plNxwBWxtoTg6F0MEIHAl+9j9iMLS1UR57z3kPAaXQT0aTwGjOKJz60AOLlF+hkYvDjaiu9CppJp5ohMF95W/qt9sbJXy7EvgiTdxPH7TxbuOTIXl/8acBgNW56ADwvIjp5d3sbwKrl7xU4v5q+0aC8OYmvEG9SJl/c6ElOSVnD33YC8TFeVDk596b0MjE7iVSag2yJ6GriUyhx2Q==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?a1RaanJHWDFuUXk3bENkTGxmTk5IRTYzMWZBdWZmQVdVb200YVVqTCtxMkRD?=
 =?utf-8?B?V2xPMWRrTVVFamF3RFFOY0M4dmFoTkUxZEhjM3NMdnZUY0NueEovaWVNZ25D?=
 =?utf-8?B?eG9YUW5yRUhPcG1TUEZ4cExXWGszNVIzTExIbDVQUFlkQ2Mya1VjSDM2TUxl?=
 =?utf-8?B?RXFGN3R5NnpGbnBDUTh6MjdEcUdYeWdiMW1nREJqSDY2WURkVFJtUDZhZ2tF?=
 =?utf-8?B?ek8vR2xCRHQyZjByUTZuVjRXaWFFODFweHZJaUR2V0FFRVlvd3lBSUZkNFFO?=
 =?utf-8?B?MUNjWFRFUWQwSzFsOERIOUxxVUwzM0dlZ1pudWVMWHRNUzVPblJkcXhVSksz?=
 =?utf-8?B?Y25NeUxuY0tXei9JWno2Q0hBY3JZZURDL0pGcGtzSXpVWW1VSDFRUkU2ZHpj?=
 =?utf-8?B?WlZUb1p3U25VbWJHZEpBcVVab3ZKcS9TYW43TWVwKzV0S0lCNExUZ2d1dDN3?=
 =?utf-8?B?Ym5TNWl3cGFoNnRyYit1RmhQMG4vRWQ1cnVNRGV4c3l4QUpuZ3ZRdUQ5NDlC?=
 =?utf-8?B?a1E2VGRGNmUrbVp6UU1ISDh0MFFYMG5HY1VxbmYwTi9aNHl1NENIejhPaTMz?=
 =?utf-8?B?N1VIRjM2SWdZZGNmYXpwZWxwU3N5SklCOEZ0UDRaZW1LZm0rT2x2WHFCN1g3?=
 =?utf-8?B?SXFIalIyQkRlOUtLZG1DQ1BkTGV3MHh3ai95aURSVTFJRjgvazZLS1JnV0l2?=
 =?utf-8?B?ekxZN0JnL0hDaDBTbk5BTE1WS3ZuYlFBTTdoalRHRFNOanZBbXRGKy9HZDl0?=
 =?utf-8?B?OUNMM1djYUx2alZhVHpzMFNsTEs0Yy9HSllRdzJFYkFUN1pENHZsUHFnZzVy?=
 =?utf-8?B?QjByZTNKYmJDVFM0bnBsYU1DTHU3MUFhRWVNTHNvakNnTDJWRHExRlQxMWg0?=
 =?utf-8?B?SUlhYkxRRDkrT0dSOTN3TFN0MTEwVHQvM1JOYll3azk4bmVNc3ZYb0hhNXBw?=
 =?utf-8?B?ckFLKys0OUJXOTZqZVprejNRdkFBSGZSK2dWeGxTZk5PelgwdFQ4UWNhaEZn?=
 =?utf-8?B?NFpLVGM1WmNrV2dqU3VVbWtneGNzUDRuNm1GaHJ1U05LY3hNQldVb0I5bGI3?=
 =?utf-8?B?b0xmYlBkVEE1VytYR1F3eDVqVzBadGJndGZZcG5GYjBuRE1jZ2svSHB3eTMv?=
 =?utf-8?B?aUFKZ1hxQU9VRlM4bjRxRjgvOWVML2d0dFFVY3JuVThHaXdMQU1EVElWem1v?=
 =?utf-8?B?a1praVNMdGUwTFpCRUl5eDhwY0xSSGxKMlFScFVxemw3ajg5S2I5aWt0bTN0?=
 =?utf-8?B?aUZpdHVVZHNkZ3J5c3JOMk1qMThjdm9NdTNzNEZjMjVrRVFZdHgzRGRnZklq?=
 =?utf-8?B?RW5NNDB0NXU3UEhGTkRTdGE0akVhdkNYZzFIZHorUlFsMlJIVEtyWDRveVAr?=
 =?utf-8?B?ZWZXUnVxUVhadlNETkxtNGJ3a0RVL2xGQW1XNVVwWmNaSFd6THRqN1NUb1Ix?=
 =?utf-8?B?RWZ6QWN0Wlo3bVZFenk0ckxOaGFzdEpsU1NPNDhKY1RaM3ZkYWtPRkFzaWUx?=
 =?utf-8?B?UmVwbitCbFM2YUcrVDZzbEdqZUZXSjBqa2wrc09PdHc1cy9mT2NHVDUxRTZw?=
 =?utf-8?B?bjZwNFVpajFMV3FpZzEwSERSN2ZKc3BEbGlaZ1R6Z3BESmFvcUlHdUwxUlY0?=
 =?utf-8?B?ME1hUU85dDdnRGJLSGd1KzJ4U1lGUUtKSHZKbm5NaHgzSSt5RGEvQm5BQVlv?=
 =?utf-8?B?MDMvZER6VXpSOEJ5RHpZZWk2SklVTmEyYVV0VExiNlg2UGRYd3V0Tmg2QVA3?=
 =?utf-8?B?N0JTMHFMV2dGNjJPOWMvZzlMcERINFB2b2Q2TDZDRDhJUjhjSVBkdzZ2cGhv?=
 =?utf-8?B?WE1xVnltU2hhNkFVNktzRjV6bGdnYWVvVzNiSFJaYUhORkJ3Q1p4c2JyYzNr?=
 =?utf-8?B?SmhoWFlsWmNlRUloL1BaaGlNSVlKSjVSeWpxRTlSV0xwTzdtRWFyaHJBM3RI?=
 =?utf-8?B?aGsxYkZkN0NPY0R5Q0p4VjZNanpoWWxIWEl0R2lGVDdZTkN2a29Md3R4TU5M?=
 =?utf-8?B?NG1ONWpPQzhid3ByZmtIaUE5dWMza2ZiWXhuM0lpam5vT2NVTjlONXlBMSs2?=
 =?utf-8?B?K1pLdEVieHRVNXNmazdGbmRJQTZva0tVOFRFdWZIR0VBS3JuQU12NkRHQm5p?=
 =?utf-8?B?NUtJN0tRSnM3UTlUOWxKYnhhWDJKM2gyNy9ESHdkSjZxMTFCZWY3RzlLeDV2?=
 =?utf-8?B?S2xVYkV6UWpaR1pEM1hLY3UvNzhuTFplRGpvQS8vK0NVUU5GQStJZWZoYWpE?=
 =?utf-8?B?OGRHRWE4a1BVMEtWMWZpczlVY3FYb0Z3bWpGQWN6N2k1OFIxdHpmU21pclIr?=
 =?utf-8?B?RHoxc2RMUzZ0SGdtYVAzUTZmTFUzMWRwdGlNWTRYN3pXRGVXeGxCOHJuWWYw?=
 =?utf-8?Q?hAWSnzcFuClU8u/U=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e619bf-7320-4159-6bd6-08df0377a987
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:40:59.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/KGw6XO4fT1IeluJBT7KuvCasjDMQOcPZFQLxm+7MvPYtfVQKOElTzYDnhtcqkjtpOCiTITFBbC+exdb6yiMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd-pltfrm so it can be shared
across host controller drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations.

This also prepares for reusing the same UniPro-specific Hibern8 check in
a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 drivers/ufs/host/ufs-hisi.c      | 48 +------------------
 drivers/ufs/host/ufs-qcom.c      | 42 +----------------
 drivers/ufs/host/ufshcd-pltfrm.c | 79 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-pltfrm.h |  2 +
 4 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index bd223bda1ce2..76d77bc30322 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -22,50 +22,6 @@
 #include <ufs/ufshci.h>
 #include <ufs/ufs_quirks.h>
 
-static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
-{
-	int err = 0;
-	u32 tx_fsm_val_0 = 0;
-	u32 tx_fsm_val_1 = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				      &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
-			tx_fsm_val_1 == TX_STATE_HIBERN8))
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout)) {
-		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
-				     &tx_fsm_val_0);
-		err |= ufshcd_dme_get(hba,
-		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
-	}
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-			__func__, err);
-	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
-			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
-		err = -1;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
-			__func__, tx_fsm_val_0, tx_fsm_val_1);
-	}
-
-	return err;
-}
-
 static void ufs_hisi_clk_init(struct ufs_hba *hba)
 {
 	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
@@ -224,9 +180,9 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
+	err = ufshcd_check_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+		dev_err(hba->dev, "hibern8 TX FSM check failed\n");
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index b2081ed6197a..c94488661bcf 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
-{
-	int err;
-	u32 tx_fsm_val;
-	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
-
-	do {
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-		if (err || tx_fsm_val == TX_STATE_HIBERN8)
-			break;
-
-		/* sleep for max. 200us */
-		usleep_range(100, 200);
-	} while (time_before(jiffies, timeout));
-
-	/*
-	 * we might have scheduled out for long during polling so
-	 * check the state again.
-	 */
-	if (time_after(jiffies, timeout))
-		err = ufshcd_dme_get(hba,
-				UIC_ARG_MIB_SEL(TX_FSM_STATE,
-					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
-				&tx_fsm_val);
-
-	if (err) {
-		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
-				__func__, err);
-	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
-		err = tx_fsm_val;
-		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
-				__func__, err);
-	}
-
-	return err;
-}
-
 static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 {
 	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
@@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
-		err = ufs_qcom_check_hibern8(hba);
+		err = ufshcd_check_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index c2dafb583cf5..034ee988924a 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_opp.h>
@@ -563,6 +564,84 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
 
+/**
+ * ufshcd_check_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: timeout in milliseconds for all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+			 unsigned int timeout_ms)
+{
+	unsigned long timeout;
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	bool success;
+	int err;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
+
+	do {
+		success = true;
+
+		for (i = 0; i < num_lanes; i++) {
+			err = ufshcd_dme_get(hba,
+					UIC_ARG_MIB_SEL(TX_FSM_STATE,
+						UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+					&tx_fsm_val);
+			if (err) {
+				dev_err(hba->dev,
+						"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+						__func__, i, err);
+				return err;
+			}
+
+			if (tx_fsm_val != TX_STATE_HIBERN8) {
+				success = false;
+				break;
+			}
+		}
+
+		if (success)
+			return 0;
+
+		/* sleep for max. 200us */
+		usleep_range(100, 200);
+	} while (time_before(jiffies, timeout));
+
+	/*
+	 * We might have been scheduled out for long during polling, so do
+	 * one final check before reporting timeout.
+	 */
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				&tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+					"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+					__func__, i, err);
+			return err;
+		}
+
+		if (tx_fsm_val != TX_STATE_HIBERN8) {
+			dev_err(hba->dev,
+					"%s: timeout waiting for lane %u to enter HIBERN8, TX_FSM_STATE=%u\n",
+					__func__, i, tx_fsm_val);
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ufshcd_check_hibern8);
+
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
index 0a18a8aed94d..ec2a8013e975 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
@@ -35,5 +35,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 void ufshcd_pltfrm_remove(struct platform_device *pdev);
 int ufshcd_populate_vreg(struct device *dev, const char *name,
 			 struct ufs_vreg **out_vreg, bool skip_current);
+int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+			 unsigned int timeout_ms);
 
 #endif /* UFSHCD_PLTFRM_H_ */
-- 
2.43.0

