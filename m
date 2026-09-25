Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013052.outbound.protection.outlook.com [40.107.162.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0192C4B405E;
	Fri, 25 Sep 2026 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347002; cv=fail; b=AI6b+k4PJtz/Zkl1uOWhQaICugS4pTMACCtPvWN16cZcj7Ba6Y/qxoWAeeny2HbzoKvXuBeoBd4vLlRJeqWHpsO8eno6pfebHda34UBVJseoiN3NzEj5oAsA0CZnktlPFOvIgXxsQLOQLwtJ/uH2xZwOrafDeabDkn0Z4I4MWOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347002; c=relaxed/simple;
	bh=4tQRKl8cosXTWtMmOErM22oNiuqrEpljXuiyxcU81lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uDMf3Eoi8voZsUp2q6WCxIWS7ZB7hjAbwiI17yH2g807geK/MSPBbB4BfWSkGGV8aWLsEcu/+BFs5fuQ63FMA+vDlzRMyiYWKhfgwhxDf76Sba2AEXrafTD/c+xuSGirigkE43nJY3CBTqgLdwkZ6oHbZeyzihuIw8WzgK0f4jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=CfPCsmdi; arc=fail smtp.client-ip=40.107.162.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="CfPCsmdi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SDAUpISec0VpFau+mxrSuo9gUdEI/EFCJwLGhwmdaQdH+LmF2RI8XEHNJhGVUneRXbowwsS9AFvIVrH7jzpwwue78xxFc7ljvc1pyVjeT0NvYf2qtGWtqPdYbE5zty+TTPjCn8A5kTLf+4O7OyHNsgwGrJct1Z6z3z/pwOHP/tSJqhSvm5ZlAlz2LRVXMSCS6Ewq2SMMkk+FpIlbKm/WZDzCg7ZjXA9ljLcKk6NwP2bPLyQLbaQVxouDbYMySBxPgRtKcLQLMIYF3iLl/gaI6YHxZFsaZcDjAE7eeWXnC+WlGwGkidlcagf4HCUjH/+hrLfIlPc1+EwxIc5diTFrLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=u0FlRqeRH61uTkhZaOGmSsqpc3TT/6m8qNjAk9O/u9KjujGpat3RPlmVUuR1+vM/oOOiqrfyR658LNH/4s50qu5zxBYLHfBv14ot1EoGTxZSU5xH4H3+KdtHMHR91q7moMWusHoSE0hYvi6yK5RYN0uKH4HyPuM+s0ORnAQOEGv9lyEtY2LyT0SNaYbxg8R8QZ4o3yhFhgKxg6f/mrfA/MOoYpc/Ah1JzU5SuLBTgNCqpyYxUN+SG7RRZk49XvZxA9H5cQE5XS1DVYEuGYO1HGlRxftL/5OWaAF6gJNHIDrHabr998fBvUTmnC0xfpHv2WhfkPNqiao/8JPqHUJe4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=CfPCsmdirJe8JKe8rVeWUsy/pzxmlr4DKorIHt44zVtqlYw48ZVELO3DGB4MxRmRbLCIptLYNI/N7kGiSS8QWQ0Hyp5VsmFqA7e4RCVtkyeB2eSpCHO/cZUTfTvboZOqEnzEcteR0RCJ53WZDoHX2K5JONuCff8P4QuARcUN9x68zmZYNG4y3XwS2IbyHlrCpSHqQuGbhWCO5xHi5gbg24O3ZRN1tmIT41bOk4+InE3wSg+zqmqRJzvnUex/OUmTbVLT9srfgAMFh3xbOzKKNk/0ACorsDkZt5wbIij2IRJ6ivdMZp56eaUImZZYOD0jdZFd4Nf5Yrr6+CZptX5FJQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:36:00 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:36:00 +0000
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
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
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
Subject: [PATCH v6 08/12] scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
Date: Fri, 25 Sep 2026 16:35:30 +0200
Message-ID: <20260925143534.3298540-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|BR2PR04MB800621:EE_
X-MS-Office365-Filtering-Correlation-Id: a252aacd-26e3-4ab6-81d4-08df1b125192
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 NsrfRret/dmNIEghRb2FgGz/hvdGAscIKfPdZ5tJF8k8dZB6fTHlyVMbrlrBd10AxJ3fqW3PRWBd5GZfa7QKVyPyqd3sZTnX8aympSYETl5tuVFrzkERHvY/cVvMTi3jQqriidGQ7dbKJQMxn1u9ZEtXIymmja8qUpOUKej2/Yu8fqN4t7T32kR9QMBwd66ebVNbyDrbLW64rNBqCQMo7hUy2HtEUSieVd6hnzFDuGI78pFgVT//JxdmYWe0mAOrPc+wad911DdJTeFMO9ei05Cd/7AtJmDHicxRGKZCK2MmEsZnR3BMDBg4WYXsk9SLQEny9N3voTWgXS2iLlNH1fus5ZBwW8YzR22DZ8V3Fv8UUUIQK2utJI1mYE5mxRPWpXEyF1qnvrLKXFxa6OwsE85B5pbQODqx51fGe2jGOvEqJLJwvmoZ2jTlkaIGQDd9I95O+Dw2eWfXesj1GvF9vaejuDsp+le+gJO+WMeBDHcRncNCaM8r2RQQbrQHbJDy8Fsb3Cto1TlvW6qiqhaybueUjwzCglllA7xiehY/f/5JGVKpgOlLM+O+zNm+tnIE2K7JCq6WghZrKThCeO0hM0BhkJrf1M0/o6lNXhJR0+VzJqFba1/L9XfAQgvH3naQckNKMOBfSmnJu/z4LJfhQvoWABiTQ8i/Bikp7DNLObtrTx/VGcZSTjvifLX9h7I8i1mJgNEchlCREYiOAqUZWA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?L1htVUFIL3F2d1ZUa05sREg0VDRuL25NemxTbVpvZG1ET0hONDRYbmZiWDFt?=
 =?utf-8?B?ZFFLMkVjK3BLbm5iOVRkdDRaWWpWRk1wMytXVWphRC94NTZ5UHhkd0ZlS2hN?=
 =?utf-8?B?WjhhZzBNNWFlSitNSUdtejJKdVQ4ZXRiR1o5cmduR1dEVUNkRW9UTkhsSUl0?=
 =?utf-8?B?UVdxaytnL0pxbGM3djNoUE94STFnSU5scUFySGdBTUZoVkJhTzd2TG1zMStX?=
 =?utf-8?B?ZVB4TjhvU0cvWWErL3ZXVWltd2dVeW16a3JwdzJ2dUwxZ1QwNFFoRUUwSXpV?=
 =?utf-8?B?YkxXUzlJRnlleDcvM0dpU1YzZW1NeUx6eEZKZ3M3dzNCSlZ4WWk0ZGNrMitU?=
 =?utf-8?B?aWs5RngxWkZwZ25DZXVEWm5RMVQ5a01DVzRvTEVxSmdHU0JJeHVBV3VxRllm?=
 =?utf-8?B?S2Q2UHV4Rm9ON0wzK1dkaGxTdmZTWnBnL1lzZEtWZ3Q5YTNzZkw2eG5mOUwy?=
 =?utf-8?B?Z3ZTYUZqbzRIcEFLQ1ZHZ3VJNVllYmtwcjM3NFVFREhpZnBtSUNBRjZ3VXF5?=
 =?utf-8?B?eGNhTi9PZW15ajVmQ1pGS1lyK0NqT3hVaFdibkR0RXlGUnNqWXhtVHFaRnZ5?=
 =?utf-8?B?K1E0K0xRYmpvNEVraVdDaHJ2L3g2MGsxZVE2ZERHeitKUmlod0Q1YS9IblJt?=
 =?utf-8?B?cTdHMUY3ZXp5NFlZa2t3a25PQk9kcnZaZlM0MGFqbWVBdGl5bkhmd0FYZXFo?=
 =?utf-8?B?UUFnalpKYzFqVDAwL0ZEcnFsWDAyZG93TWpwcyt0ZXBhMEZPY0JYRkJleWxi?=
 =?utf-8?B?enhZSVg3NmVjWjhWcDUvWVVOMDEycHlXK3E0RElxL1JBc01RSHlaaXdlWE5X?=
 =?utf-8?B?bHBCckNpWkNZS2ZTMjFsTGVjYi9BdU5mQXBFK043T0JhRWNzTDVkV2oxalFl?=
 =?utf-8?B?ZW9kU3J3UlZPS1JXdnkvL0tQa1NYbVpwaEJhMTlxK0RRdzNqU3lWeXVleEFx?=
 =?utf-8?B?Wk0wb2lUNTlDQm9KbytCRzdNQnBhWUlEZGFzMGRMREF1SFFYR0VDYnRWNXJR?=
 =?utf-8?B?azZzZjJhU0VzemJPWVB4T1ZKOE1COGx6K0RzY29uNXFxeW4rdG1tb0ttNys4?=
 =?utf-8?B?TGRCdVpKR2JET0hWWHVzQ0w2NWZqK3BaM251bHB6d3Y5TXpWSGdhVGtaaURS?=
 =?utf-8?B?TWplOTV1cWZTelN5MVVJMlNVMkE5V2hkamtPTVdRRXBVOVVjckFZTW5oVFEx?=
 =?utf-8?B?SjBzS1ZhL2VEM1VQZUZzQ2Y4WllVckN5U0xxVUxMMXdEd2dneTBObGRONE1H?=
 =?utf-8?B?QXg4eWFVdDJPZVVEZ0tOcVVBV2dBREtFRXQ3cjhTeUlaTHJsZkdVNyt5cFVk?=
 =?utf-8?B?QTVybGJKRVZSM1F1UEJxNUdFTEpzTXNMbzlVSXRrTklYRmtaOHNMUTZkdUlP?=
 =?utf-8?B?dFQrdmZ5WFd0cW5uTDl2TDExcTVibThhd1QxcjhXUkVQTW1ENVNtdUo0b0U5?=
 =?utf-8?B?S1ZTU2s5ZlFSOHlER0VETENlKy8wK1BiVkxIa2I0Z1Z2QmFCYy9jZnowOFF5?=
 =?utf-8?B?a2I2VkJ2cUVMczdBVE5McFpTajY5ZkwzcVUvNVRJMDQxa2lNYXBBcGcwdnZN?=
 =?utf-8?B?VUk4VTRwQUN3a3VMVGwvTFltZm0rSFNvb2E1Uy9RcW9scE9KTVpOcUh0cUVS?=
 =?utf-8?B?cTBSeEVRSEFPbWIxVExBalMrZVhRZDJKTTl6NjREc0EyYWt5ejhMUEEzeUVz?=
 =?utf-8?B?UHF4TXFRWW1TRUlsOWNHUTg5c0NER3VwSFpjYUVSK2lZV081V3VPT0J0U0Rw?=
 =?utf-8?B?Q1ExOGVEcWdPeE5FQVJwRy9pOUJHZDEwUjU1WG9KMFdwVUNKZWUvQzQvQmYw?=
 =?utf-8?B?dlR1SnBHNGRYK24wMml1Yk00TWUyZTZPL2JRSlIzT0craFFrRnpPTitCdzh6?=
 =?utf-8?B?QlJKY3lBWGFMc21hUzB4WDNjTW5RSWFTSEs0ZlFuc2ZZb052VWpXSVRKS296?=
 =?utf-8?B?N29FaEFrQWFHVVZjTmFiVXBaa1g4OUltNjgrWlBmV0Q3bTkwaGRrMUdiaTdG?=
 =?utf-8?B?TVptYlJFVWZkdWxPRGdZTkUvb2VaOE9JUFE5THJ2UnJCOVdSeXpMMlVYQWlT?=
 =?utf-8?B?L2NoTVpjUG5Uc0RMMEhrMTB1aFhyV3kzQ2ZiY1VKR1pJYmFibTlYQmxRc3Vz?=
 =?utf-8?B?NnRFUWMzVUgrMURoQ0wwcmNkS2dWOFV1OVUrSnNhVWVtbWgvc0VVanhoRkJu?=
 =?utf-8?B?MEJvL3Zrb0o5bVJ3T05HbzYzYlRQcCtiRk9pcDF2ZHI0cjBDMk9aYjgzaXBy?=
 =?utf-8?B?UCt3L0xKbjMvRDRTMnM4TWxjRHk5WlAwaDlDNWJvTEZQaFR4aU1qcGZyMmJV?=
 =?utf-8?B?SStCcnNCTVJnUFF3eTV6MHNIMzJ3NkRPYW5ENzFRQ2haWVFKNEd6QT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a252aacd-26e3-4ab6-81d4-08df1b125192
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:36:00.2749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmD0bjEpcxI8A73B/UekPDiFXZV7fxS6yCSywHIh+GViLwoS/LszmynnH21jue2+iinpi72AqluQQdKNDM4+kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

The RMMI attribute defines in ufshcd-dwc.h are otherwise listed in
ascending register-offset order, but CBREFCLKCTRL2 (0x8132) and
CBCRCTRL (0x811F) were placed at the top out of order. Move them down
into their sorted position next to the other CBCREG* attributes.

Pure cleanup, no functional change.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 53b523ef59df..1abf2b1deac4 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -13,8 +13,6 @@
 #include <ufs/ufshcd.h>
 
 /* RMMI Attributes */
-#define CBREFCLKCTRL2		0x8132
-#define CBCRCTRL		0x811F
 #define CBC10DIRECTCONF2	0x810E
 #define CBRATESEL		0x8114
 #define CBCREGADDRLSB		0x8116
@@ -24,6 +22,8 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define CBCRCTRL		0x811F
+#define CBREFCLKCTRL2		0x8132
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
-- 
2.43.0

