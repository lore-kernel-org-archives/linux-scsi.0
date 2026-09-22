Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645073C3F44;
	Tue, 22 Sep 2026 07:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062441; cv=fail; b=OQwFTl/Zt73ctp6XpuDR28A5/tM94G/dNq//Z/d4L33pUsPAfKk12V+EC+EhpK3+XMbp+0fgcg5/BfaK8Mh96RG/ipK9yh7q06PrSptVMOQrfqpIduWxTefCXSq4atw4XBEsH9VeK6NnDpctKwp8raKrkwO1XKOo1Z+q4dMvrew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062441; c=relaxed/simple;
	bh=X/ajk0kWDqeHp+au9/dco6+O8CqCA97D+c3zKikzZ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MnTa4Y64gbs2OwoCNUceEh6p7iHPeQJuTLfOI2Krdo9APka4IBVFRPENQumGx2YuBRhhFGBXkrTxFFDKz4fSsbqsHwLlFnc65dwnPdpRwMYMcWpRXYZ61HVoUUABxzzG8rUD0IPYiFzd+XQ/JXNqSKn7d6WdLHGmi9F7xCSDFAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=kslI1u70; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="kslI1u70"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irHYBWwnRiRNkczW9dAGBeKZG3Om3U8DjwO1vFAYPhS2HZLN3nTFYpj9b3t0xOJdSXAxRMEPjUIbxA7jcTN1Df2hOKmADeJNv9KcFVh9/MNjjYRrt5GM6cG4aCMmylvVJ7TREK6q4rR4pZoV+ECuSExobhcS3CXOQ/xtjan0P4rckUAhlf/d5PB8GLVcJKU0N8CjDcrML1LS6trGPKX6ZtnjHTDT5QTCAB7w07/atq9x59icVrvbOzCUE+59wkszmKMdyByet36idJ42JXqu5WFDEQtmmsOfTwb0ap7R/E1UjECIrRgSzEewVJO9sRvgvJjH7sYO8JkYqS/quUXnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzUpn0ruXAMZihjkL7hd55pRrzHxBtwT5AMQPoNWHcE=;
 b=c9HdYgZ3TnngOOXQTkvrBttMhi0A6zt4pkjKXeua3xToldU06VaKuxDV1SG/F02x83+P30veja+6qra2zakXi3FnZhtyww6q0t0hRNeaORvwOyPV+82nhVhe8XFdxC8s0IkBNjjXWBs4KFFxZcIi9j1uMy8CXQXnS9aJSZQlzwxWxBoTraaHLF44Jlp8i14kzw0tT5MlFmkSdXJFommbXvUktfR5J5h297Rn/AcmxURyiJJn1Z8lhUylkqC2GbFYePOh9/BY2A43KL3By28RRDBFkHVvdeBnAyq9aVEMvjc+2tHmWBk3iqKiBSjN5yng6spQ2lHAvDhu6lGxnsWuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzUpn0ruXAMZihjkL7hd55pRrzHxBtwT5AMQPoNWHcE=;
 b=kslI1u70Mv/Jfn+4UCibuspKtaFS6gsb64J+7XUS4WwWHAMlZnGIhQoK9zp2ZCENR0o4H9dWQ+fmqwKIhi6xNajQFk+BuXvujg72WHiaoVdg6CKDLON6yF82IHSy2I6x3IAMm0K6X5/3geVTgoPFMhMPFuQCwm3jIugE6FKylvjnnqNlGcrQJDTgbnmYBVBylcI7UnbncKHSv5BXGwOOJ9Twni/yY5MxKOIMzOY2TK4QWl1bQph9AxJDxyw0kGruArBwCeyu1Tk/ermi52pp6fLiO3dSS2HsrKjQOh+02sSXVYMC8Gsqh/LYXvISbOym8HGCqFw97CGg3ANYpj534g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:28 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:28 +0000
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
Subject: [PATCH v5 08/12] scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
Date: Tue, 22 Sep 2026 09:30:05 +0200
Message-ID: <20260922073009.1449688-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0014.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::24) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|MMZPR04MB213195:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c07e512-f6ef-4546-9943-08df187bcb70
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 CwhonL8AYb9eer5YWeDvvxpdUI+vozcqigFO7WoAqhcRDyPkIBfLjQOl1FshyOLwJuhpnOFgFK45g/ku36G0GG/AHj/oOEZyt9800NfeTsHfOXJtwi/gTYjamejeD5kXGpRzoIdIzcnqMsfliR7NZxhBD8awx6Y7pkOznOk9OY51e5ZlluLNhUIWWfNP/OYcVG8vmXIjny/Ro6VDU8zDBL93P7m9KFOxx+RIowpSX/7lMJ5Uin/gn7VsMpRxKvgNX8QsBhrdvnnObllw51McM6YnCK3PG+Eem040GTBrw5SsrIqMIKaB6nFswEN+LH/JsW7jR4tT3hw2NqaVJKDYlDQki+YQYsVDSe2xlJY3lqr/KEpWBkVfFHm1S4DiEimic9eA+2saOimssHhsoRzCT6B/wqefkxc1HA27H7rNSFah0Lobr+THnGd0uV0o8TM56gr+EULPn6tysHNVebR2HTy62ihvD+RL+udistY2WOyI4wQ7y9wTk8JkCkqpAiTFB9oRKFgQ4fsJUpTO7hYQ5TXWK4r5BpeufPIRzpk42bqgb7AJH4s2wWPphKr5cqaYAJQQF41GV8o/ikh8M3oRbz5pFKFBfJ6ihVdPSyID8BPcdQ/VmjV6MJk6ql3T4p5S0coqoX+mL7rTk3hhrjcTYu3G8eRjd2630P49NPuv/xNmiZswftIExp/jirIXtAQTfNkB+IxETrEETxpVnA3I3g==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?aU5oODJjWnlkMElWSWJCeGYyR2dkb2RZU1J5L0ZnRVdjNThnYXhvbC9qaWJ6?=
 =?utf-8?B?UGYvdzB5MDhaTkJVMERwQnZqMGthY0RoVTRrSzJEOXo5WXVlN2ErK2RtWnEx?=
 =?utf-8?B?ck5CVmYzMnhaOW5zUHlpaHFpQWJFa05Da284cjliOEhXbjBuNlFSUFF6aElV?=
 =?utf-8?B?cDF2VG9zYUxBeEwrUlFjTEdIYkFyb2ZPb21Day9tWGNFRi85empBLzNWOWxr?=
 =?utf-8?B?TVpjWXEybCtleTJoNlRiN3FPOVNJSHlWdnhJT0tDQ1gwZVNyS2x4bk12TzR1?=
 =?utf-8?B?eFRqdDMwYmFGM2dSdFZ2UFVxYkRtcXJzRUdJd2RCdS9saTVuTGJnUlVobEJ6?=
 =?utf-8?B?ZXB2ank3R1IyNk5Tbzl4SDlKK1NybkMzV0F5L0JKOU5CckF3Tjc1Tkt1OEJW?=
 =?utf-8?B?a2d0WFluaHF4RUZabjJvOEhJZ1Jld2d2bnBrQUYvZjVsQjdkVlVLNlRIWEhi?=
 =?utf-8?B?UFl3ekJPaUNXc2NlcVVTekxNSlNjdWswaFEwSkpwY3FNSUd1Z2t0dWNNUFRZ?=
 =?utf-8?B?V0o5QWo1OEFVRmhPVk5qN2VuZkFxSzlpYWxjT1FDK3l4eEx2TVNnZjBhcElK?=
 =?utf-8?B?MS9uOW9LL01Da0k2SHlEUFIwV0NUdDFRekgxWnZTWmloSmV5RUxRU2xxdThK?=
 =?utf-8?B?Z24vOXpNTStwUU9ic2ZUbEplUmp4MG5Ha3NiQ2VPM0RrR3lKWWQrVjFuaVF1?=
 =?utf-8?B?UkJtYnBLMUQrZjRDWXh6SEN5WUxFdjBlUHk2alRuQXFrS1Vla3UzWitYS1JV?=
 =?utf-8?B?akdxNTlXTkdTTlk5RjB3WmFZbC9WWGRMS1VseUNJbTQ0VVFwVndNWkhHT0p1?=
 =?utf-8?B?cFd6cC9TOXRZVjVGVzBxdzFVZ2s1M3RoSnBhMUw5NmI4b2hQY3BXdDRLZUJ5?=
 =?utf-8?B?V29WQVVweGZKQWtCNUlMREpwSmdnUzFjcFQ5bGx0Q0JmSDhHR0hROHlXOEpZ?=
 =?utf-8?B?cGtaNVhnQnExT0pvU21FcUF1d0w5Tm9kS090QzQ4SHptVGxPT0JzdVhOdjBB?=
 =?utf-8?B?UjRLTVhlWTlkK3ozNWdVUU9yc212QlVkTzI3VUxSaStaSW9DV3NobFlNSmh2?=
 =?utf-8?B?SGhnQ0czR2htWW1VVWlRUUN5SC9JL0Z0RUoxbjFzT0pneEhaU3Nvbm9qWHNu?=
 =?utf-8?B?MmpCQ3hBYUxSS1ZHaE55L050Wkc0Y2NyU053bWpPVEdIbUlsQWZIOFgxakhm?=
 =?utf-8?B?NnhoSm5vczN6QTl3WWJSYjJnRTRsOUk1RUNHT1NISHNXMDZOUVFkQUxjcStC?=
 =?utf-8?B?ZHNaR3psSWk5Q3hLWWd4ZjJPVGVRdmJIeUdrQkJ5b0pDR2tPTVVuNC9OWlFm?=
 =?utf-8?B?elpINUY4NWd6Yjgwa2hxRVJuMWdhOWpCN1RjbkRLZW9XbXhXUzBaREt5eWpM?=
 =?utf-8?B?K0hvdWNaMFZ0VFdlR1pFVHVhZzRKNWNrR09zWnFhS1c1RitYOTJnQkhEcGg3?=
 =?utf-8?B?UVFUYTgyVmlNRklzN0hYTlFUYzl4ajZTL2pyYXluNFlCY1hUWmxVbnIvYmhy?=
 =?utf-8?B?Szk5SGZTZVpYMGYvZXJra3l1R3ZOV0dsY2VPSzQzekZJOGZwY2d5dlBxL3ZG?=
 =?utf-8?B?enF0S1AzN0ZGY1ZtcDV5Zzh1dlMydmVUUVVpbXRvZWhkaFpMSlljZ3ZRM2Qw?=
 =?utf-8?B?OFVQa0JNdVFFTmNhdkJ1VWwxT2xIYjBXTXVnTk51SzlxNDNpUlVNcW1JL0Mz?=
 =?utf-8?B?YmI1OGlVSytZbFRadzVoM0RUVXMxUWFwUDBJTzUvNVNkdHlod0laQnREaHBn?=
 =?utf-8?B?c0o4SGQxcXM4RUtmZkh3b0JLSWNqUEpBQndJTkxya2dFamh6NnRCeVNST04y?=
 =?utf-8?B?aXByMW1iOEJ2ODZueGpQUE9tOWw0R2sxTm12RjFCZ0pEck9JNVhVYmI0QUEy?=
 =?utf-8?B?UjRwM2NXZiswVDIzd0lTSDhieTM3VXdnWFF1Rzk3N1F1ZU1TODR2NTEwZTRh?=
 =?utf-8?B?Sk9Vc2Z5cXhSSnRSNXJJK2syQmRUR3NCMWt2NHU0cExTY1dLWGx5L0ozTlE0?=
 =?utf-8?B?Wk9SSUJTL2o1YXFsRXVHRm1FRGNrdG11OHRvRnZWY0pVTVNoZWM4MFpYVVNT?=
 =?utf-8?B?UXlURUNQc2RNeGcza2tBWVMyQnorb1kzbVdkY1YwRnErZEk1RDhtb0liVHJW?=
 =?utf-8?B?WkpjOGtxTUZNeGhxalZ4ZFd6blJjTG5EQXVIRzVWN2xESjZUZjEvZmlZekxk?=
 =?utf-8?B?alZOZTdYdytaaDBnZyttcnBWTWR5N0FyWEhqcUlPRldMTUx2S0Nhd0FqU1Fz?=
 =?utf-8?B?ZFBVVk1RZGFwd0R4Sjc2ZG1tcGFMNHUvTE9TQ3BrVlRlQ1BxU29ENkl1SjAx?=
 =?utf-8?B?Y0VGbTRqTmIwN1lhOXlMVGVZcFJRK0lpSHBRWk9jS2hrU0QwemRXNDlkVC9D?=
 =?utf-8?Q?lPzsw2NAdquRybI0=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c07e512-f6ef-4546-9943-08df187bcb70
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:28.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Doq8SI8Janj2RZpP8FpfF4flixvxVffFIn9sZMVdpg9J9b9chT3JBqIlcxx6i+xOQL09B16+RHOtPK4yuQTlSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

The RMMI attribute defines in ufshcd-dwc.h are otherwise listed in
ascending register-offset order, but CBREFCLKCTRL2 (0x8132) and
CBCRCTRL (0x811F) were placed at the top out of order. Move them down
into their sorted position next to the other CBCREG* attributes.

Pure cleanup, no functional change.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
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

