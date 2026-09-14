Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011055.outbound.protection.outlook.com [52.101.65.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB32494A1B;
	Mon, 14 Sep 2026 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390217; cv=fail; b=pgp6DX4qNPUefp+pSp4yCxnrUNAA6slXwxb2DDO1KolIGW6KvKlRZuE/xDVPKMhMuK5NHmNsj7Q7yyWQrlP/mfg0kBh/kxq3ldX6MMuIbZhvmz1PanWV4s+erU2Ac8VfnUuzwHl8ecdxeMwRbflAVl7kXYDxsTEPqf59wr+SgpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390217; c=relaxed/simple;
	bh=97icSjO12lOkdoavdD/UM60WoWo3z5SelKg7Df5h+A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RZbr0rsw9LtK+gYtHt1XcHFnhZMI1FRdQULA1vI6XfBDrhgPEAhIx+GEIZAOK3dXm0BxaPXTwchCmGYhI8ScH48aJeQus3Jl0ShrDjzjDkJKDmpPaEK1EEoKA3da/DmTxEl+OFTwCi+1eUcUBFS1CoGFxRHCM1Tmytaxme5g+BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=In+nhaWa; arc=fail smtp.client-ip=52.101.65.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="In+nhaWa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=POgaSO9CQmpIhUHw4h4xcU+YFSryfo+cCfT70xkoLx5ASMSy24NL60UzTa6GhNhvdqqLSarTnYsRIu80F7UzSq+3Pp4oejqOaaRP1nQ36uMgs1Euw69CyqvBDXcUbKytKMkoHY75jMWMTvqzcI+R5OFAN07iww22E+Oeg0CqQmtYwyBIgYqjm819/ifFNy4te/VJ/UGiPOGYvko+ygD1mdqCzGJyrHknB06DL8aAq2GA1DVexvRpBOAWeuZRUJK1Kb1igyXqWRiALt9naU135MlMoUiyxoxpjvKlmh/sP94dq0mLUk4C5WVRnpxqvMOOAA+3LKy8zXuUBhZQ2APAeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbLo/7oNyhXU3wlLm7ARzgq0CzyvIbJqz6X9OT18oWc=;
 b=tXg9qp10acGA6ckHv2xlpvTnl5nQmiqMDMcjf4SN1bDR5VcW0U0RxgWuAOLPoA/in61erxX+jy/MUvOn/IQW/1vNIAbwT4l06SpksXvEVevQIOO6fCoT08WRyRVWt4A9KGhMHwoYW1w8k+LmLsXo6LZJSfOhpO5FE5N4fDq7utG5ZW0acv4X7d6riQ0V5D1Qa1tYB8nEvJLJeYrQ+2Uj7l6xfPCpzU+6YTwRXyaH24lZbxlzUFtBr1qgVxWGJSGDmQIn0Add6ebIU2dUjrlIsAhBFCQKyAyEMwjuMY9bKcNo4GgQf6kvLpcTpSdO+NNAybSQUdMPXi0T95lv7SFL/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbLo/7oNyhXU3wlLm7ARzgq0CzyvIbJqz6X9OT18oWc=;
 b=In+nhaWaVoYcwkwV3KhxsPop8I2YhyeyM0nY1i3sVzOhpQ/Cgr3CCmHof31/kCUtX11/w2eO5j3AIhVrJOgsuEpCFF4+8/DLXE/3Tn7//Nj29SezHf/AEJUYIkDEs/H8FaZtaXrAsiSuVizej0wwI4b0kJ1qBbuQKv5FcF406FnzBlu0P7mBQE0TCRz53PXIv3mm9B8SjH6I1kLp9W29KiJxRtRu74lf6OczTmyJvfXukQ8x2jM7tCrassU+n3utVEJsYdXrnZPpXRwZ9tuXAQjH8dArLlB1TThfTVhjnkH6/O4GnXgB5k/L2u6JB9TqM5hvWeKHuNtXwYWEWQs6pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB8971.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 12:50:07 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 12:50:06 +0000
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
Subject: [PATCH v2 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
Date: Mon, 14 Sep 2026 14:49:51 +0200
Message-ID: <20260914125000.30812-2-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
References: <20260914125000.30812-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P195CA0013.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::18) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: fcf5182e-571d-4149-db3c-08df125eb41c
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|19092799006|921020|11063799006|56012099006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 FbKcfAbaPBGUHm3PByuZEjfYdG8XQAeb0fEzQjte80O37VdrOZaOHYouNBHLyaDJRYvuSvYwrVBPKojr33ZiEUtQ+6pY8JkZULHoHFHe8EeGCURNWcTUghzH2NN83hR1h+k9fPdfNq5qKldrZ9697T6Xwzh4yfSdT5NH6Ur3seMCi4yaY+bEs8ln6K9290OhUs/Ef57MBMfe4Tp+JcYA4d57gOAar/n78Rnj/zD8C5FrfSnRy5yOb1IxRIm1CrITtcqx2bpAUqoW0IafCSyqqC+dPJigo0YINyGNqU+UuKEIAvoad7bRiaCYext892kOtael+i9VETF0B33+1Nl3Ldv6sMuDhAS3Z+ZO6SpRp6Qw+fAMaRjxEshuUUypwHvCLQuTmoE5pjuYMKRDqLa8s4pcBBydCm4eOgJ6Wjf5tT/38tSyhdt2Q+yLcohhvKStNdRa7stdDpZ/5RzgXuwl6rJ0AEnGHtx1gXCChadSBdp2mmVLWrEfDwQ8M+eD2uUxuKR5UuYGyphPyfgSxNxdENRuO6xPTOrtSMp9LuKmjwLouNy/5e29QpnITMXkPCz1hc43iiV4XzgCYCU26R0edqZAkMfyJsL7V4m31eofZhDF/7DJe2LzHEM51gDHhsaVsC4Xk2UL84Sw/ymvvfqvcRj9CzOtcGS2n6WYit0VuFeqPrBNd2A4+tR1Qq1AGAN2UyggcTsaqd48a/0maBnB0Q==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(19092799006)(921020)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WlRFejNmQlFlbnBGWVA5Z0ppd01URmxGbTM2aGZ2NjNVTTkrT2RIUmJadkxO?=
 =?utf-8?B?TzhxdHBYRk5yZXBWK1NlcUNWRTR0RzVweHQwU2FXMk9SYlZLTXlVazdiVi9E?=
 =?utf-8?B?Nmg0OUdzM0dsOW90N1JWWjRUU09BUjZnZDhTLzVCWG0xak92TXdBOC9CT2ZQ?=
 =?utf-8?B?Nm9JY0J3Qmw2UElmSitPV0Q1Q3c2c2ZLRHJyTzU5NGxCanRBZWpHUmNESUdR?=
 =?utf-8?B?djdvL0ZyRDh0TzFwZk9rWmVTQkhNYjVFbmhTN3F6djdMUGxZYzdmZDh6SlZP?=
 =?utf-8?B?cStZOHllK0xab3V5cEtUcVBTSktFSmtpWE9qR3ZDZEFRb09VTjViM0pTNG1G?=
 =?utf-8?B?N1NKaXNaMml0clRBanhxaE9LbHAweXozR0RwSGpkejlKYXhEdysyVlZIRUp2?=
 =?utf-8?B?RjNNM2U2SmJNZWhPR3hCdjJGRWR0RGh6WFlwa243VFFscFViaGdOckxzQ0ov?=
 =?utf-8?B?RDdxOGRvNC9Na3g5K05TNzl2NkZqR3hnZUtITURTS1VBUDVCQTlmNVFiMU5s?=
 =?utf-8?B?bDBGZUVIei9SYWlnb05lMEJ4VDhpMEkwNllMYndodmltSEdPeW13cnM5clNK?=
 =?utf-8?B?OWdDdk9GNGRESGk1WWJYY214ZFQya3dmMElxVmlmRE9Nb1JQNGMvM3kwbElU?=
 =?utf-8?B?U2pqS01pc1NySDhqWUYwTDQwNG5UQkxoNkZDcU81NnNUei80SWpUN3FJR0lr?=
 =?utf-8?B?ajlQSHMxbTBkRHBVT09DajR4VEVWMkExY0ZhTHd4ZDlnY0p4ajRGWUNIdFNK?=
 =?utf-8?B?SnBxR0FJTkRENFRvNHBORngyRXFVNjZJTzZldTBYeUNRWFNmczdnZkRCVzQ2?=
 =?utf-8?B?ZDZnRTVjWkZ1VERnVnloRnJ6VnB6KzNESFdPMkRjNDVTQmNpTy9McTkyRmds?=
 =?utf-8?B?R01yUjJLR242RFhPN1p0RjZRUDlTUnFwT3Z1dW9iSXdyamZma2dHSm00UTl4?=
 =?utf-8?B?MW9IajRUYXkvZnZVTjUwM0NRNFhYNVplMVRna3dYRk8rNjFZMWtiQ3VQdEtv?=
 =?utf-8?B?MnN2alBxZm5Vb0k2aEFLaXFITGhCNG9odkJHNjZsMUdTZW94RndybktRZmZL?=
 =?utf-8?B?VmxjTmlYTlNNTDc4NzlxVVUyUEdYMDNNZ2kwOUMrNUNGa2thU05Zci9NMjdG?=
 =?utf-8?B?RHd1S1BPWDBaU2JqaGNpNDRhcUM0VDE3YVNsclJkVmgvUEdIdW02TGtkUk0y?=
 =?utf-8?B?c2FwK2h5QktkMzZXTldrU25mOWN1aWY2R2MrQjNkMnBkUEU3bGE0ZUl1TU5q?=
 =?utf-8?B?U0xtdEVkb3lPclZLWnJubFpzeFVyaU12ZkF0bTVLd0RLTGx4V2Rld29Pa2xI?=
 =?utf-8?B?cVMvWmI1ODhyZU9wLzJaTzNJcnNsam5YZXI4bElFRVlvK1NPNWRVNDVabExY?=
 =?utf-8?B?cjVOekRDRFU5U3E1ZCtybi9HZmY2UkdzRldUYWxYR3YxTGhnS0Y1Z0VPWjVi?=
 =?utf-8?B?MVdFR29JeHpVclBYWGNXMHpuME55bnFSdVVGRlhncUYwdlpjRXNqRW1lOUl6?=
 =?utf-8?B?Nkx0MHhXUjhaWVZRRHZmZUZJZlRCWXdKT3VaR3lFUVNYQ2tSUVBTOUdKL09L?=
 =?utf-8?B?cUJzZnpGamZmOWNqWlpqVkdxV0R0MFZuVTczSDR2bTM3K2dGWm14V2dWbXRJ?=
 =?utf-8?B?NGRRLy9HNHJhN2hIZG5UZG5aTjNDcVRiWldnM1FHcXVEZ0RlYzJaQTg5cS9N?=
 =?utf-8?B?Qzlydm9hcW1hZ3V0MmVoc3BhUFdOQldiSnhZMHBhemdJQ2lmOHBYWXFEdkUy?=
 =?utf-8?B?d0NONkpCQXRlZW1pSHhNemJWZ2pCUG1uVlR1SmhjbFJ0K1hmUTVSUTBINjlG?=
 =?utf-8?B?czRpTk9RL3RGNjZtalpqTXNBeVloektSZ0EvRFhiNlkyWFFxZjhGS0tUakJP?=
 =?utf-8?B?aEgwc1IxekZRZ3VuVWRLUzV3Skt3dWRMQ2ZaVHJBUldYRG13T09kRmJORzNl?=
 =?utf-8?B?ZjEyUzdsQXdCSlpjK0JGZXA2TUlDc3h0bDF5UTFoWUJrdHB1VGgyYUxTZ1VZ?=
 =?utf-8?B?dWtFMmVaWS9adGZKQnFGbnJVbzlWbmc2Yk44WmVlWEoyL0EyaXR2bERSSW5U?=
 =?utf-8?B?Nmt2QXZCeTVKdmF6ZE0zbis1elNOM243R3l2elRTQlo4SWFUVmIwbythK216?=
 =?utf-8?B?K244Y2pLclhERTBLMktxSytYb0VPODR6MTRINlJPb0xYRHR3U09BNy80MGRs?=
 =?utf-8?B?TUJHOWczRnlYVTNaN2VoeXVORkViMCtjNXpKZmNOVEdmVUZoSGhleW9PQmQ0?=
 =?utf-8?B?dzlYaHgrZklvMXBqOUlzT2RaMEQ2UjVuV1lpVmlja3REQU11ZVpHam5SMXFO?=
 =?utf-8?B?NTVoTlFhTDhBdnF6djVqWlJGeHNnL3g3NzY1WW1BM2ZrRGsvOWhYUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf5182e-571d-4149-db3c-08df125eb41c
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 12:50:06.8942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWJgrX+k165SiAmSBIh6E3uRU6hsb4EwR/SxXi8n7RZYKIiw4GljW1BUg4oWTwiSjhYnk7qXXPkzylLhEjvOQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8971

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
 include/ufs/unipro.h          | 20 ++++++++++++++++++++
 6 files changed, 26 insertions(+), 27 deletions(-)

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
index 954be9343f42..38897d01fde2 100644
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
index a5ad5ce44a19..3c6cb2281af0 100644
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
index 9c168703b104..e0f490e11c7f 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -466,4 +466,24 @@ enum {
 	CPORT_CONNECTED,
 };
 
+/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attributes) */
+enum ufs_rx_fsm_state {
+	RX_STATE_DISABLED = 0,
+	RX_STATE_HIBERN8 = 1,
+	RX_STATE_SLEEP = 2,
+	RX_STATE_STALL = 3,
+	RX_STATE_LSBURST = 4,
+	RX_STATE_HSBURST = 5,
+};
+
+/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attributes) */
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

