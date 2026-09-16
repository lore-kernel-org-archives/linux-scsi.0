Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011054.outbound.protection.outlook.com [52.101.70.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DCD47B423;
	Wed, 16 Sep 2026 08:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548281; cv=fail; b=U8Jyjj0QtR7CZJAFfdkpEni78z2ece/dYyoUJXJ3ljO9VVvncyPV+y/3qp8uG9w+dzroN6Eyz/xirB54yFMKMnBHc3O2azGHlAny1s9HXgA6sbM/tZNpiHwgAoiubxaYzJJ+EWnocwBBCG7CUCgcMHTab1x7U5l+YHYqmAi50SI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548281; c=relaxed/simple;
	bh=Gc1TxaOrHN222id8IhR5snYb5IiAsyn5XSCkLEPlpak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bL9x5tjRzoSbJIyjr05NJevKReTuk8ziIBrSI5jT4Vtq2H5ypFa10BRH8x9i2ng8IPeniZsot/UUW4vV3eaeijMEyGUSAWjIID3Frprc1ChO6RrMeQSsbEcT9w3g55MZvOFj+RoUlyHmc9Mq3C0Tunk4x3wBJW+gvVoQf/Eb5eQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Np7rDAva; arc=fail smtp.client-ip=52.101.70.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Np7rDAva"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9dOqyzMp6Hi709IDNpWNXoyRD0sr8VrA1WGyoJKtZFz+hSpZyf++AEJ5hzxb+CoFjaZgVG7ifMaDA4LlGu2S+dT1ZbLl5MNbTmzi6NBfQrF1U0Onrfz4xK6i/GStHvIhLwwaoYdu4w+rG5bSBW9tagVtS4PZqzy7nZuIaEQN8dnzyleCnvltqpJ87JCOLlANZMk2q0ZMN1WadzmwJKrUfb6ciGqcuXwPMpXn0v1tAf5MwaIS4qODrrZnzKzekkryWj8j408+4GyXSBWiqGBp+gkjKo7AOfOSwdB39T+tSN9PL5ydO5Xz5RsIkkICheh7lMWVN0r2wM+96/mAn2vjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=mju2Eo40wJhgh8OiGXdFfqHL6XH1h2B2mPMOccXdZoy5gvz4T26/IHgO7nOhCTc3nvXxmwLUBQp+b0mocJQNcvUYnXYy/clC21MWU8Tv/Cj7PDiIVyFEOyuAC64h/dHyoC7/LzpqYObmOQjry43pofryqgPP/M/kWL/VacpdEZbZ4S5Uy1VEXtCbcSxgphXGYZ6eYbGJiEfMlovCDzA5WXsz9m3576j55ga6zlcDA1YZHJOM1xdk10L26YyaxP1CjZ2o+PJYhIFlMVSWL+hcAieylLniLiwK1+602/9PBmf1ZY12TQXBt+UDdgSP3t39gkGsfb3fcgB3YSqogL+ANw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU9MXlLnmGKkDOUO394eSJQ0G0ZYr9aiRiTJSZpMkM8=;
 b=Np7rDAvaGGQZeTuGDifVC6/u4Xdz7ZSoLgKMzm1GF4y/g4GB3mWzDy1aL60sICkVwmz7UjvcLNLQ2Re+wt6TjS7KOHHfiS9RLZvytzoQidxnKdfX5WkbmcXpZhxnAgVHDM/EkZpo3mMu5wFFdRpYTZjRtNjoe+A+bejpKrBMKvc7X/XbZzHmlQprhpZpEhx9bhlTs9oTp+pV6YpuZU3aArhycuMO7chbrco9J2x78kzDc5Hgkghm6ujgf+xDnPI++PcdZqMIrhjrKiADEK1EPkmtwPv5Qu4hhK5zxbRiY0A3wAhoycasliSfIbaJlvgYG58NqeG8o5fx2jqdt7jNqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:20 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:20 +0000
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
Subject: [PATCH v3 02/10] ufs: unipro: Add TX/RX FSM state attributes
Date: Wed, 16 Sep 2026 10:44:03 +0200
Message-ID: <20260916084411.941297-3-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::13) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 253e2b55-81ce-43ad-1fa8-08df13ceb338
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 x9KKgouvn3gTHHXCvdm06BM1QAFYqf5vn248KbDrAvc4K3P0x05CMpr7XIBwt9WIluAPqdUq+kQcej2gYXd2uoEm7ftBXIePrGpnqXrerGtq0U9+0QagUjgDgdnqLAFez9MTJtkAV8JVKi+hujU8TKWLbyT2h2zVRFgYartVwTlw9+6bBRMo0PbKxFC5NiGVNH3exfFoFu1q1ELYeDygUinc2ZoxBiYGlQmpUK1t/emRbHlrqqOQm/of4hK2KvnJC20jt6tbsRfJ/NoKv6J/zjUsepkPSOWFMFSOwhKiFXOmXUZ7CmvyXYo6Sj4qj0/5fahvl4KnOrxVK/2g4AK2IwKm0ls1GpICvIt3dHkCblg+rq2V5s6i3Hbbpq41hr0IZlmYeuVBcp2jNSPM7u1yJpIfTeXP/6oBxRGd8rJAmzyQO/4qYMBPyAgVd8uNbQK81sdLgJf7KUwMAk3z784uLcKOQUOXN9EeMr0LbjScD9gdaeA+cAsEk9YsfhCDL+O22IRq9Gdq6tKklClJvJP8Gx7n3x2k6VR68MfElTnKNH/oRLQIpgCGRZce9K9zTkxGb5BpXCAEZzVYDIQDYN64fXLmlstkF87XymkfhjHehLK22ehTvbhnQstcHKYvy7yYoLG44S0wIpMbSUq/7ToY3YwNUEPp3W2CaAEmchdcBsKrwUyuuIVOcNrsFi4wgCwkTSnxIoGarg6AGk40S1+Jlw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?aGN2U2RDZGo1RkJpYnRZVzVYWGxEd1BCUm5CS1huUDNscnBQSlRnQ2JjQ3pl?=
 =?utf-8?B?Y3AxNlc4Zk9jNTgzWnJKL3ZNeFQxYWQ3eHc1eXlaV3JmcGdBL3FaODJyK2tY?=
 =?utf-8?B?Tm8wR2pmdEFGOGh1UXJadVAyb29mNEpqZkYwcEJSRmxGWHVPSFJtWXg1RHRC?=
 =?utf-8?B?R2VFVHF5aDJ2MVF6ZWVGSTZXYU1YTWpvcWpsL0tKelkwUzVVOVR0RWxESGR3?=
 =?utf-8?B?ejZsdWZHTndHdm5yNkRSWmRBZUduUEJVdlRUSDVxaHpsTEFWdE1uWlU4TlF6?=
 =?utf-8?B?OVFzQkVHRklPRGdWMTlWbnJhdk0yMHVvb2plVEVackl5RjFjV0RFMmxocmxD?=
 =?utf-8?B?c0swUlpEeWlXc3p3NWUzTDl4OU9UZVNXaE9NL2oxbjNiZmF2OXpzYU5YL1Rk?=
 =?utf-8?B?T0Q3QkJnZEJrMVhUZFZnWDhla2NXUStiMXFGWEhlYUtqY3FhYk1YTWtJcGdX?=
 =?utf-8?B?T1FGelQzM1JwSnZGU3pmSlUyaXkyV2dKK0xwbzBGSWxqM0M4M1BRanU0U2Yw?=
 =?utf-8?B?anB2VjB1SU5HQ0pJSHpQUGhNUy9xUzBOQkhnR2prOERwS0YzYkkwcGpUSVY4?=
 =?utf-8?B?TWxTQ0U2dWk2b3VvY2s0Um1UZk11UjZidmdSUmZGL05oSURxZlo3aWtIa1FC?=
 =?utf-8?B?aE1LMFN0c25ieUhaeUtwd1V3LzFpYlZTNG1TUEs4b2tESUJ2eVY4L2w4WmxV?=
 =?utf-8?B?MlFQaG5JYUhEWTJ0V1R5OWFkMGtYUTZtSWpyZXl1RkhCSkpHVWMyN2JwSEVz?=
 =?utf-8?B?SmRsSW1JYk1CNDlDUUtPWXMwR3ZvK05CKzZxS2djVW9zMC9UTHhtTVN2VUwr?=
 =?utf-8?B?YjZLR2ZjN1ZHUEdwMG1RL2JGNkM4UDZ3SmlDTDBYUjZpaXBjekMyZ3JTalBw?=
 =?utf-8?B?VHh1NWNqREJIS2VrUFZzcmFJdXJmMHAwQ2VHSnN2alNqaEVRMGFTazlrR25P?=
 =?utf-8?B?eGtmWFRmOStaeGhnc1dYWDJja3I5NE1nbHFaRFpUaTlhQ29udEVidkZ2d2Nv?=
 =?utf-8?B?dWdMRHpJcWZ5dFJzYVNyT0JYSTExemRiU2VDVy84RHlFWDVIT01BMXFaQ0JG?=
 =?utf-8?B?WExHNDdjb0k3eG9ZcHhDOC9KclFvcmFOcTFudHJQeHpsMFBwTDduWXdYN2ky?=
 =?utf-8?B?bWF2eElnT3Jqb29BQURMN05GSzZuWTM2VVYvQWpLYkErUytmNGo1NWVFMS8v?=
 =?utf-8?B?KzBvbXJtOTc1ZWxyc2VBSTIwQ1pES3VUK293b3dMZjJGdTArY1RhTjVmSThL?=
 =?utf-8?B?dFdUNHNrWTlmbXNUKzRsMFc5ZmlDaFF3cGdmSFZNeCtmUlhaNHdVUFBSd2Jj?=
 =?utf-8?B?QVZEY3JJSFNlQlozRFhNUTIvSFNrUHlBR1lCRld0dkYzczMxRm55b3B2aWpB?=
 =?utf-8?B?N283QmNTQnB1Mlh1ejh6UXFHOFZQektHT3hEK243SlRsM09TeTB3L3ZvZmVI?=
 =?utf-8?B?bmh0aHV6T2hrQnFBdXVXVkN6ckJDYjlYblBGYWtRanRYWlhZYk5tNzNYQU1T?=
 =?utf-8?B?S3pRb3VSdlhsVTdLeEJmTlpLN1dETUVDRWxsaWh4cm9OSjVlZE82S256dG8v?=
 =?utf-8?B?aWNJN0dQbUhVR2xOZkRqbVZwcFVlTlQ5YnFkREw2YllRRnUxNWpCVE5QeENu?=
 =?utf-8?B?Z2kwdmhWSVZrcElLQUNCQmVISlVldHp0eXNwcXUydTVBN2htQTMzQzBPMng3?=
 =?utf-8?B?MGNzSjVRU3c5VnFvMGtROUxCNTU0NVl3NzVUbzdjN2tmU0RoTlVGR1JmOUtP?=
 =?utf-8?B?Q1lIQS9ZdjdMMHlndGZDcFRIR2d6cURlcTJLYjhzZDFGazdJTitrSzVTV0xT?=
 =?utf-8?B?cDBFUE9JZGlPZktHUXhrUjAwbzVuOWZRMmJZT2ZaYktRdHkydUwxOXhrd0ZD?=
 =?utf-8?B?ZzMrZkFpZ3U2ZXZ4Und4SnVXSTdPS25XVjNwMGFoR3BWNlBGMzZ2M2JjTkFs?=
 =?utf-8?B?dVhQajNMTDBPbnNuanNxSmtRM2g4VHI2OUNVNHdmcUJ5Q2Evb0UrYllGanpS?=
 =?utf-8?B?dzlRYU96TlFJd21FUEZxK1ZsSmlQYWZLUUJLNFZUVi9OS0dDOWlDc3JFQmZN?=
 =?utf-8?B?ZXd0UnEwc1VXY1hnQy9ZTlltYzhadXFQb3lLejdDVDBHV1Q5Nk04NXBMT1pM?=
 =?utf-8?B?ZGFZaVNNeHhrZ2R6UFY0ZU12UHVCL2k2aU1jMEhyaWhIeml4KzJpUVJtdVVB?=
 =?utf-8?B?OGhyRU9QQk9sUDRCR2EwZURGYVhWR3lGZmdPd0dNbjBXZ0ZrUUVoNFk3R3VX?=
 =?utf-8?B?bS8wSHFUVmlyU0xVV2hNejR3NUhCVGs1NDIzVk9CZitoVTZ4NDNpU3pLU3ky?=
 =?utf-8?B?THh0Ti96ZWxBaXJjVFFHZ1hraFFSVjM4SmFRUHRjKy84NU9YQlQzdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253e2b55-81ce-43ad-1fa8-08df13ceb338
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:20.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erzOqYmpwsZniO2iyetopOPecb1v+BRsxze++HiJ9mlvTw+K24eJCCyBuUr6kXMT5vyT5z5Ty26W56AkGM7pTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

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

