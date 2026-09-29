Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010045.outbound.protection.outlook.com [52.101.69.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6246D4FD781;
	Tue, 29 Sep 2026 10:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676690; cv=fail; b=tRDWXdAlI50pvr6n81vEmRy6kReGtVQWSiyp4vL+y1F9dhrdDxv9oo34+CCARyZvSIDQJarzgyLyUhyCUfEliWrREln6MkewFdiMBvzu/98LuzOog50V3l33/k7DF4u18j+yhNcfhLuM0WYDJMoulp1aJ4Bu0p41YNWbTQ/ZDNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676690; c=relaxed/simple;
	bh=4tQRKl8cosXTWtMmOErM22oNiuqrEpljXuiyxcU81lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TQ3UGvttpSqL7KbZMmYSGshsCEDmWo05DqwkrVDvtvDAv6tvU5l/YoNKjzKV0/zY9s76FbVzvx48xAtdttsQwBjFvGjNBszj8MMAuT8iaBysnjOGC260gGSX3P25TAUG4noUM1myfX5bgbz40rRUu0VtxLldz+N0y+4cGMF5GT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=p3yqUapd; arc=fail smtp.client-ip=52.101.69.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="p3yqUapd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dCL7LgEp3bY8zAujaPRwdthToUpz1czypRfAMj0QrAE2yoR6gjRN7dzOLDkLl+3/xXl7xjYDT4oAni7r1xqP27EsJd7aZY48MrmSPUxWQbQzBgTgeeFti74/LkLUuNkUxSxmmBDL/UFgo4nycljuEbM+4tLZn76e99CxHx16GCCWOE+ZqftLL2ompyFYSmY0EVEaFtgBQFCmPfyUTHhqWknH3BBYyGyIldN/rt6XSDrqZswLHd8p3xBc6adW0wl3F5lisg30ah2oAOAzlae0OJxlvfrXMnZvLpV5WJlSQ6KOzIeXGTiL0OVCtFisSyQeR3zZaT2nmtpYIKTfhWR5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=QP/uGkiWqXqfupQHZ0Wkg0UU8jVh9QxoVQz4lppf8dYUB+G2ee8T7U7up67CVM4VoHT3eovUVPt4tiLb+OXz5dyXpak8SobpTVR//gX/IOP8VWn59jBZmmeZsgfh2Y2dWKk7E3X+QESfvMGKPrsXIiOQhMOMqxTw8ezFji3nBSJJ/R8uGb5Y5BiLKvlCXhSPV2qyF6HSo0DXORD1y5Xqk6z8itDrJJOVjbrNdYeWptaV0hCftePnJctJx+eNsafgrnh0WuEzwmSnpBsf2aqGYmvg/mPbOFh2HjCiofi2n+0XiIsj7qm/cu1X6sKZ5XPnN9/MvuHAGW6dISA3hLB5nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULUPTqhfrdzUsU6OJH371yUj0KwB01rAKh14M6kYp1M=;
 b=p3yqUapdgAqRtgO9SNS8/Zy6+os1hNJ30iOt7FKFW3UxhwGmJpKSz7Gm3QKh4Kd/iJp5gVWJ8LOi7GkTLaohQ++JjFQxzxOEDVXirLGlYM4lMOCtHa2xLce1rVSBvFoftkd0uBwbs8FsERnyVFZjkUWSqScH9DcDx4MsZpwnZNMJ4HuX4o7ayRm/KX5s8dV6BkGGT8uSXAnshoERzhrNg5+CF9wWvmzo0c7FmQHUyqcFl/7HneOcaWsowhY7HkKQsbl/vnkP2gABLOUbBaHEWttLrIC3GL5akttSuV8aiAMMAQ9vOx04SV8c9eIHhbVzhJNYVM73PN9A7VTT639zZA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI2PR04MB10595.eurprd04.prod.outlook.com
 (2603:10a6:800:273::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:17 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:15 +0000
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
Subject: [PATCH v7 08/12] scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
Date: Tue, 29 Sep 2026 12:09:42 +0200
Message-ID: <20260929100946.693962-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 8d5dce22-0e91-45a6-8f7a-08df1e11db80
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|19092799006|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 n4fha4RFDi4H9oY8IMwP3O49VZx1IQA65iCzAf/bgEg5g0OI9zkgX8HhcbSjYBf4HtkOdh23mDSTs6GGofNCYGg2wFxOBPCJfVB4Oayj99LtIHNAkJYVYUTftvQHIHa6IjlzCGtjbAYpLB2nNaG2vB5vO9BpHv8+cpIJ3lnNdZa1/9JvYdm1udXVMgnq6UxnuTtnIAIKWahRW2lO8zFi1shAOAubg+82CNI56eH4xMXW57AuR0coz5hl7CQSckx/ZorR8qoI9pFQfuR8BLvvg2I70Zt9FYIdmfKmI5fJiGD2guxfsQW+gF1NLtLadirvfAYKvrwOFJZZ52cJiZTTO3Fs2CgRV2t+pbxD2vEpe8mqzD+I0PcmWs09P4DHwOKx5Jk5r4eqmQDYouAR0iDbX5gt8fmvFOKnTjpTWoxRocAqx5/Jy3Np9ssyzgBJ/3BriwM97pahXAoTLVsZxd/84XfEMjPXxErtMwiJ7ap7h8krmUQoCQplKsHk2vyPJkhfQuPUMW5WKijwpSQOmBy630ltAtc1SzxeKnrobdGM4e+NM4tWvFJliuh+ibOgfPJ551REZmt4VtWR7gfiQA84cI9sFfTAKzxO35cwh+LLsnzNjB6SNpcEExagjP1lt6P06f7v83GG5olad4cR1LQYLtIC20PsfNsPc5WAsXkKbRNoe9cexmP8g56YI8yCpL8L3718+3+fkxarKtTvXGa4OA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(19092799006)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?U3JncUNYTmFSMXMxVVlORE1IdzN6czkxVmFOa2VVMXVqRUdHMTJOYVV4MmFx?=
 =?utf-8?B?U3Y1YS9pSkhWc3BCOTc4RXhmQi9vWkJUb3FwRFRDRForam5GdFhoV3ViWXFB?=
 =?utf-8?B?cjZzeng3eEI2SEZjUEJjOTd6REkrYjk2eEJuUWFiSzZIQXBUdWcrR2M2K0Rx?=
 =?utf-8?B?enVoaEsyNldPOVZhK0d6SWkvVmgvTnBrRjNGWGRmT3drK3RyNERhcUtiTDFj?=
 =?utf-8?B?VkFkRSs2OTVsU2k5Zy9xTnVuRUduQVJZbEtSVGNQNFVvYWdDa2d3dXRzQndh?=
 =?utf-8?B?OWhXYmI2VFdHdkgyZ0h6L1oxZ0lnU0xNc1ZDOHVESlI3SHU3VUFENFN0SUxr?=
 =?utf-8?B?a09hN2lTWksyZE1LY2FZNCtpbU9yYjdxa2xONWlYTTRKQS9taHh4Wnp1VXN4?=
 =?utf-8?B?cVFyNTJwamQ5U0NQb2pac012THRJajZDWk51WTZKTjN4QzBsSWRHTVhtWFZF?=
 =?utf-8?B?Z2FBQUJISzhTT3QwR3pmZjVKNmtnZVppQlJtN2ZXM0dzZVo5L000K0l6ckUr?=
 =?utf-8?B?SjJMK1JzSlV2Tzlkb3hyN3E3VFozOFhZa294Vk1DeFZkRy82QmluMDBCUU85?=
 =?utf-8?B?S2hwMHdTVG1qVDZ5eFNLQlNNcklYR2kxNTh2V3EyVjY0eDE0TVlaN0xzRlhP?=
 =?utf-8?B?clBEUi9ZTTFSc0xtbm5SZDhTa09zWklVYm1vMUp4OFZzbzA5Qm1vUHhVQTRp?=
 =?utf-8?B?ZHBzN2M5MllnTFJscnpudFp6bmRoQTVQbmxkSW8yK1UySUNmeStxVHpickhI?=
 =?utf-8?B?UjRhSWdmYS85SXcrUGwva3FvUW0rYjcrM0FXNXYzREZUeUFFN0ZBajIzc3ln?=
 =?utf-8?B?Rk9ZMEhaMnhUWnRPOFpaRTIzTEFvVXVjdzNwMTB4R2VNS0hNeWlMQTZrQ0hK?=
 =?utf-8?B?MGk4djM4Ryt5R0RIUS9WTkE5aWxzdXdDMVczWW5NN0lmbUZydDQ3NVNwVGtP?=
 =?utf-8?B?TTRWbTNpTGp5SG1vVjExWXl2dFBIeVFOY3lKQitTOWNKVERxRmFucFJNTi9Z?=
 =?utf-8?B?N3lPUitkKzVUbzNXOXF4NlhnN0N6Ym55OFAwY1JPZlROU3IxZDJVYkxhNmox?=
 =?utf-8?B?ZE9xS2Exd2VOb254NXpiSkR2MkZzK3FCN3h2TU01QjNObDB6dHFPQStZM1RW?=
 =?utf-8?B?U2dyZTdhN1RrcmFJMGpXYXptWDBMbE9DRWs0K3JXd3NRY29mejVzL2huUGlO?=
 =?utf-8?B?dzMwSy9mang3N29HWmI3UXNkdUZHMS9kNUlTZVkxaDU1QmM1bVZ6OTVtRDd4?=
 =?utf-8?B?ZVJPWFVsbXVLN2toR2JXWEUyalhTRThINlZSSGVNdlRldE8vNW84UkpPT29x?=
 =?utf-8?B?Q1kwK0ZnTUdENzJUdkRBSjl0WnU3UCtXeEQyZzhzV1RhVEM0cXZCaW41QVRz?=
 =?utf-8?B?ZHZObWV5TE8yeGVlbTN1MFhFNWNYQ1JiT3dabVdxZ2JLUUg1cDY3V1BBYkkz?=
 =?utf-8?B?NDNTMmRzNlQ2QjZOTHFJNlU5ZTQxa1oxaUduSC9zSkFwSnV0dzd3WGsrMExO?=
 =?utf-8?B?b2k5NkN1NUMxZXlmZW1SdUZGMS9FQ053ZnljZTg2WlhjeXBRVDRUV0JqVXE1?=
 =?utf-8?B?SU5iY0RmRG00T2FqL0ZWZC96cVB4bEZrZ2lJYXdBRnVxQ0NWZmh0eWVwei9G?=
 =?utf-8?B?SnVQZnNKa3lEN2I5Y1Nld3lNS3RZdjR1ZnRSMXp4T014K2VNMXU1TEpsNTVU?=
 =?utf-8?B?VEhnK3hFbS8wQk5xeE80WmV4TzUyWTdwaTg3d2Q1cTVmbU15d2o3bm1YQnA4?=
 =?utf-8?B?Vkt2WVNaTTVqYytmdHN1WEJ6M05tbCs4QlFjWW1SZi9sOWdIeWc0VHNTMXhR?=
 =?utf-8?B?WUJZSjdDdjBuVmUvVG9aWndWcHBiNFBtcURYNlBCeVY2dUtINTZqUURsdlhj?=
 =?utf-8?B?L0NnTmZ0Ukppb2pYb084NzNTNjNoY0FzVEt4RUlBOXNOaWk3ZWRQNlhjNUdo?=
 =?utf-8?B?YWpobTlVZy9vK2xvMEZ3K2EvS09qRDArZzV6dXZlNlR3R29vcU5GTDBMc1pt?=
 =?utf-8?B?bmQ0akNIbGNGbE9Bd3diN0dpVkdRaE5RelJOZjlMZjJFSGxGeVZOSXVqcndm?=
 =?utf-8?B?MStHM25adDh5SmpaVm9yMDRSWEhRSlFyWnpGd1RkcnhTcDY5MXB6VW50WVkx?=
 =?utf-8?B?MjR1b1dBWFJWMEFtRzJBNDBIL3hJdm9sUExEK2IzcGxDZXlSMU43S2gyRmRZ?=
 =?utf-8?B?ZGx1SmtFTGxVcnVzWnhWVXRRcGhQRlFaTXVYSnU5cmZXOWU3bXIyYndQTzhs?=
 =?utf-8?B?RGlrdWFWYXhZeHR1OVh6RU5nUTFyVXB3UkJkNjJZaHU2SHVSanFqL1VZaFla?=
 =?utf-8?B?WmI2YVF1MGdLMTh2YlNSeUlsZTFLTDNzNDNjSkRDYlRRUTBORFJyQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5dce22-0e91-45a6-8f7a-08df1e11db80
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:15.6782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HeHIDfSdRpgGDE0K4cIuVip3mVKbQRh5rx5Ss+IUiQrdzmwc3ATcAUChasjCtKV1aB/h0KJb8i6mIRftAIm7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10595

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

