Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011011.outbound.protection.outlook.com [52.101.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B44502787;
	Tue, 29 Sep 2026 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676640; cv=fail; b=Cs7Mvey887C+/HeipK2VLfsVwUnSQXGvkfdl8OXdcFvUk2U8Sf6ylq6BfQTQ6+7vOoQFc4AiTFCsZ7qpdDYdR4TCZA8lgWmEeVIb1tpBNPRAXBm/yMvDYHlERU/0QikVdS6kccfOZY80awNgdls39rsrQ5KJx0dkryf3IPbQWsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676640; c=relaxed/simple;
	bh=m6szGpBKsXIUl1/uJVhVROiVGi6vyEU658NnP6M97sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=usz33JKJRqzkGLnrRgz0ylJ77drSvgAmdu9l39MT8bfHTPXrSJuqG2AzdFvQG20+QhaAq4NEjsmygqJGaBomvXQWOjdxoV8TF/iOnp0/Ul95z5YSsnewh/OnFoYuse6B2aIGJyB5Z5JTVaxSU0Rmq/+hYkpSn1Wztb0GLR6Rfjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=f8ikFpqr; arc=fail smtp.client-ip=52.101.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="f8ikFpqr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsjrDu8sEvHSMuCO7NMt7hieiGxSnl5xE/GiGJwt7bqlYlLzTmnU1005frIFWZqPAh2AmcwDnBvXSgjIvfGvORaNIUCBntpOjPMQ1LV62OKEcKKQmUq2M7GllaMwiVrzrkDMRK6fpDtvvbOI478gm69H4DUm9VRtSjOvgsbiMeUJIjZIK4Sd03SGr+lUVlwEmxkSFGk0rSZeXNZDCbiXjUsmV1+Yqa7EAn5LypKHacNKt6cSocBdYkZkrjBZAw59drIGguIS0hbLLDtZVM5H5+H0DxwvpEJuyRgt01VXsjZ99EeQjTo/8cJLGd2ZW65wx2Ar1Hu6yTI5rEWlP/e7aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5VCOxmrakOZvoozZLzX4mZ50JYYQpMdb1k6aGo+n70=;
 b=zWxUIVgNk4BcjhS55SmriJc8ROj/YmIStQWljhgvLCaNuZytPK3wW4+uU2+wBak1gIRFbgLcqawJCDJ2mkmWBeQwBFOWNh8vjerRm8A0zGfXqvL8sSfYvofQ8mLSIqqVO2A4lUx59T9zsFFCX3sKYGfuP0Nv1/YP1ezOYtn4U6UsrLOtF06YreFMJ5Gil4/TsdD5g0pGjqUejagavRVHo3twSDz8IKUkvRuOu4EHF3tx8j915UNs0hW3NtgmvlYaaKwVZt3Ggxj66100ddWvA4YTS/ylj06izBfbR4ro025/k41oUqbfwjzswBncTyWWm+Z/o6l8K4JaPDrG5B5cAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5VCOxmrakOZvoozZLzX4mZ50JYYQpMdb1k6aGo+n70=;
 b=f8ikFpqrd2p+SDOeUbQsAay4zqxCBM+ZqzY7/C2LPFGSFhsBPYI/aUy1FRBqEdqB+N6zQ5g+XSoRkoOnBwAeEy2sHJL+/rFBFHk9N9iguwQ4YPGmOUTWaK0X+vrZ+AHsO4NJDzi8Sfv7KcydMj/mWbRujlxNrrVST6Q9Lh5e4JeJCFNADcsNuMOMLQwrdb0cuHiQfhH+qUshJYj4EIMivAi7qkgOEwNko+yyBHk9lIFO777/qNb6+TjFLQ4q9s6X523PXdH3eYUXmiUYis5ZVetZuvHh5WpbCBRN0b3g25KvFMSOCGiOAd1Tk1PYIUK4hANdfGj1mbAgMYeqr7A32g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:03 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:03 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>
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
Subject: [PATCH v7 04/12] ufs: host: Add common Hibern8 TX FSM polling helper
Date: Tue, 29 Sep 2026 12:09:38 +0200
Message-ID: <20260929100946.693962-5-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0030.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI2PR04MB10595:EE_
X-MS-Office365-Filtering-Correlation-Id: 5639a328-68b9-4eaf-4b56-08df1e11d412
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 cphEmAOFNxwteKtiuWB8FR37RRorGRVjo0mZyzGUD6fK7otztq9v7/3hy8EcvZNxg5dbtwGVCVDj0XgJAS5wfNjncXY//DKH28sdUwsdjVAddZpc1jzdiJIv7HJWgJsQi5f2PKzqfEYqv2aTtL7/j0Pt096TZsmkmQe88AJ/jGifrhtoYmLc4EZyaeGLST8Nctal0uxkqCG2dHgB0mjNFJW3t+RT6pUoWXLfqQVx8M2cWeE0TVHEj96w+d+ySBizQGRjctM2KUG3Udi2cLKD4PaCRf8ByhsW3IQhBbU/v/Y+7bXL9mdNdrPkaEpLlyebs04fDlYwymxrql3pWD9VCz9sBN6k6D2N6b0eXzp3h3U/FwBPkLH6fH6pb0oiFHvAfgsM19piCahrW45To3gbOoTxdg5y/o8orQ3GT4uERWn3pTjK2PrjIw1F/ebwcLfdNsU6CXsO1WuvUOTO9Mg7ebKkDQAmDBggAQPPfsReOK39maQv1vkWyfUaFKJ9lFkhEaNT37Zqj+WsDas6OD9cyv2i3tHdj2uB1eB6WPERNJMTO5HUYIF2WPBpYPnPvk7v33kcdQ4JWgpuXQ2ytOQe/fFp+nJsYXmhbPzanvvyB1VuCfxAnLif7sfQNSHJlqzSNK5wF4LjCYj+IvGBmU4MSz1cNGop1TGDNbg6XSmpyWZqKUnKYdiNi2DNwQdM88rn+l8t9a/opW2DQDMJVmqksw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?U252NlluWW5lVW1XZ2hwc0ZaZlhxVm9IY3dBK1dYZ1JDZnZ2amNQZERvcGNN?=
 =?utf-8?B?YTkxU0VvWjhPQnFPUWIxNy9IemE0RlpUMWNHMzZVcmJSVVQrKzl5Y3pHYWh3?=
 =?utf-8?B?Z0RLdVZZdzVJYlczOTc3U0FUay9ad3hNaVlkcVlzSXRxTU56Q2tnUDI4L2Vh?=
 =?utf-8?B?VGhjTEM5V2pxTFBTQVNhaGNJYURyd09TWVpBVEpaM2tTZ3NPaGllSE5tSVI3?=
 =?utf-8?B?WXB4QUpIaWdJQmFaTjVnUnZXTUtwaURhM1lXaU5BTXR4OEFJRWk1TkFBUStx?=
 =?utf-8?B?Qk85QnpjUEd5NlVqVkNjS1dHSDl0d2pxVW50QzVoS1pRbWZnSW1oOWorbnZK?=
 =?utf-8?B?Vnp2ekJSUkczbVorNHZmbE5CMGRjSXlzTmdaNTNSNXJoMDU4ZnBQZTNvMHhx?=
 =?utf-8?B?ZnJyVVpqY1Z4UmZuOVR0alY5akMrdjZFaXFMdzNidGJnSVgyaFhWMFM4UGtE?=
 =?utf-8?B?RGVuMEVGNVhlU1B6blA0bkhWak5DMVVLVFNsV2lsMW4zeGN1ZzFUc1hiYVpI?=
 =?utf-8?B?VHpCN2Y2ZHlXcVNiMXpOTURmWXdaQkdBbTRURUJnc3l3N3B0SWVJUnNCQ2k5?=
 =?utf-8?B?djRGVXNab09TNzRsbnRTQW0rdlAzclEyOHVvUEhHYVB6MDNCL3d1NnJrZUcw?=
 =?utf-8?B?Sm1lYnFzc1Izb25pTDdUZ2FTNE9seGN3dktkNWF2alhmZVB6RThrYjVRdVJ0?=
 =?utf-8?B?SHhaOUJvYm0yaHdNNGJyUXZWOGZGUHNyTHltbXc2U1Q1WEkxUWhJekFTMmp2?=
 =?utf-8?B?K1ZoMXVJT0JkODVKZGgwbk1NY01Ec25GdmUraU42TUdYSi9Mejg4a0g2Ylhr?=
 =?utf-8?B?a1JmSkdEcUR5cFNNWEl5SVVqK1pWOHgyS3NoT3RXcU1haXVONTB6SmZ0Znhm?=
 =?utf-8?B?SHZYb01ab21MZnBqcUd4bWFvVjB2SnYxMHdKQUMrTUJtM012TFZQejcyR0hx?=
 =?utf-8?B?bkVOM0M0bGE5Y2N3d2Z4bzdJTFgxVHdTN2VpMHRMUHZPRHg5ZEdjTzN6V3lC?=
 =?utf-8?B?b2tYNFluTnpyUXNheDBpdXpsa3duTmlRSERXeXRQaVlwT0pRM1ZUb0ZmcTQ5?=
 =?utf-8?B?UWtZUWU3SnZHSm9MbE5WVXhjdVgvRkRCdTVQbjNIOTZGMnRUOWkrZ3N2UTZQ?=
 =?utf-8?B?YjYvdU11SVpCTXplb1MwTjVCaGVXQmNQZDVnMk5jVU80M0ZETnh6MmRicHVM?=
 =?utf-8?B?TWo2YkdGdERiRCtvcDI5TzAxVkRKaXkwSmZnd09wWnZaTHczUS9ndkVSUnk4?=
 =?utf-8?B?VXBBNlZvUEFydFk0N2xvY3lrSENNS0lsTVUxM3A5Z0dSL2hoUUFJQnoxbGFZ?=
 =?utf-8?B?b1RZa1ZXRU16NGppYjQvcVpzMlFpV2UyZmtVbTRiZ05teW1RVDc4YWorVWgv?=
 =?utf-8?B?TjhnMVMrSEtmZkhXK1NOa2UrOWtQQ1pmSU1xcEFsQXM2MmtHemZqYW5BVFFi?=
 =?utf-8?B?aW9GVHhjOEt3RDhDNGxham9pUXRLZHpucGNwbm91YUtvU0JidHZmcUN3WE9J?=
 =?utf-8?B?MVJHaGxiTjJaWEc2Y2NTcFRNMHFqRG43TXBUSFZzTTJ3VkJLRWM5amFpMWhC?=
 =?utf-8?B?cncrVVIzOXFrWkVNaDhKaTI3RGs2ZVhrQ0NFeXA4YmhVNjdRaDZXTTBlUHda?=
 =?utf-8?B?OWRLajJLT05GclZvTFAzWUFUVDFlT3c4aitNR01RRTBOeUZoS3EwY3lKRk1I?=
 =?utf-8?B?M0lLUWNxVFFUUk5OOUdDdWhNUTc0dmJTY1RXM2hpcWRDWnl6Ung3bE5aVjZw?=
 =?utf-8?B?TUQzaC9BckE4d3BqT3JDbmtZTGdkbmFNYU5kL2F3b2Z0UUhIVVVuRU5wVUUy?=
 =?utf-8?B?YmpwQzJVenNtMVhsZHRqTm5oUEtteVlsT3BicWN6QzFJM21yVkR1dUF1WU1t?=
 =?utf-8?B?RWhEQVRjbTZ1N0V4eTJDN3htV09McVZpRlpyTWcvdTJ5dTZZcThGRldLWXRW?=
 =?utf-8?B?bW5mbmFFRStPaDMweWhyT1g4azh6YWh6aldLRm9zVHl1QVNxd3BPQ3U4eG1p?=
 =?utf-8?B?QTl4WlRrMXNkTWlGT0NZWWRoVmRuL1JGYkUrbDVWdkFHNitMeTBEMnc5dkNk?=
 =?utf-8?B?SWVIai9hZ1RrcjRTY1MvcGVnV0tBWlB0MlAzRThaWFQ2Y0E3WFAxcy9kNDZE?=
 =?utf-8?B?V2s3cWpKYlp1SkVZMjdINHNyeWY1Q3RGc2I5VkM1Yk95Sm80dU9ONGpJWjdZ?=
 =?utf-8?B?bm5xQ0hwNUtteWlKcFlYZkxtT2tGRDRZZzZ6N3laczh4Z2orcURORGZYV0ln?=
 =?utf-8?B?L1g4R29DSUJpeFdnTmpYM01LbG8xMWdhdEJ0ZlppUXY2clpWeG91aFpGQ29P?=
 =?utf-8?B?aGI2eUtILy93MHF3N0hOV05ubXUyZTg3aTJYSUZ1Z2FUeEVhQkV5Zz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5639a328-68b9-4eaf-4b56-08df1e11d412
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:03.2177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMZzNVji31SMzTl9DHU4nzdnjxdzT/XRFHMlVX1OZlL4rzbR1ButWlda0bMxnZgwwJayqvxhQGVD80Mpk1ND+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
enter Hibern8 into ufshcd_check_hibern8().

The HiSilicon and Qualcomm drivers currently implement similar checks
using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
this logic to a common helper in ufshcd so it can be shared across host
controller drivers.

Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
their local implementations. While at it, normalize the "TX lane failed to
reach Hibern8" error path to return -ETIMEDOUT instead of the raw
TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
This is an intentional, harmless change of the returned error value; the
pass/fail behaviour at the call sites is unchanged.

Unlike the initial implementation, the timeout error is now reported only
once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
per lane.

This also prepares for reusing the same UniPro-specific Hibern8 check in
a subsequent commit.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
 drivers/ufs/host/ufs-qcom.c | 42 +--------------------
 include/ufs/ufshcd.h        |  3 ++
 4 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..985573726d67 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4448,6 +4448,79 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
+/**
+ * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ *
+ * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
+ *
+ * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
+ * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
+ * timeout) if the attribute read fails.
+ */
+static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
+					unsigned int num_lanes)
+{
+	u32 tx_fsm_val = 0;
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < num_lanes; i++) {
+		err = ufshcd_dme_get(hba,
+				UIC_ARG_MIB_SEL(TX_FSM_STATE,
+					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
+				&tx_fsm_val);
+		if (err) {
+			dev_err(hba->dev,
+				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
+				__func__, i, err);
+			return err;
+		}
+
+		if (tx_fsm_val != TX_STATE_HIBERN8)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
+ * @hba: host controller instance
+ * @num_lanes: number of TX lanes to check
+ * @timeout_ms: overall timeout in milliseconds shared by all lanes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
+				unsigned int timeout_ms)
+{
+	int err, ret;
+
+	if (!num_lanes)
+		return -EINVAL;
+
+	/*
+	 * Poll every lane until ufshcd_poll_tx_hibern8_lanes() stops returning
+	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
+	 * was hit.
+	 */
+	ret = read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err,
+				err != -EAGAIN, 200,
+				(u64)timeout_ms * USEC_PER_MSEC, false,
+				hba, num_lanes);
+	if (ret) {
+		dev_err(hba->dev,
+			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
+			__func__);
+		return ret;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
+
 /**
  * ufshcd_dme_rmw - get modify set a DME attribute
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index bd223bda1ce2..b84075dfe00d 100644
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
@@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
 
 	/* Unipro VS_mphy_disable */
 	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
-	err = ufs_hisi_check_hibern8(hba);
-	if (err)
-		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
+	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
 
 	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
 		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 1e492dac8d93..815ca82a0878 100644
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
+		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
 		ufs_qcom_enable_hw_clk_gating(hba);
 		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..0d9d0a26eb20 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
+				       unsigned int num_lanes,
+				       unsigned int timeout_ms);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
 				    struct ufs_pa_layer_attr *pwr_mode,
 				    enum ufshcd_pmc_policy pmc_policy);
-- 
2.43.0

