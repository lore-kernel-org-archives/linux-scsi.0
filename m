Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792844760;
	b=43ofrmWi1NIkvXbm4+F1NqYZhJhU50i8n0n2zHewmA2xVAF10R0ZyOckLi2mE+MjCCgV
	 lJvVrUYJPliUIvQ506BZsMUJHwdvwR2KV31kPSPOgV7///CMK1HRyO0xhNb9GjoUcewXV
	 qPd9QOi7oscd5vXB7bHF2jU/34Oi1bmBemLA1sc8Gm+6tVTrsuTR3rw+kZMXeS2B4clKc
	 n1EJaqEK7xPMdMpDLsuU9+75npF0/RRC9u2eG35FYiq5Ki6Z3yuRV8rumRofxIYZy3NPV
	 TjuGrK/Y4p0tHE3elnrSsUpsIpe2O0geXbwdk39Ej/z1+uvugq6wLZ8mjjHNqJr0J0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792844760;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=lYEzPh2HCvulMM7n8NLZihzPYqqg9U+hllx69esfCrk=;
	b=x2aK4l7+casH87FihSwFuMq8PJV/ncrdC+jjtbaZQnDgFn1/hPHH3Dg+bcz71jKtvft2
	 j7GEYV9mu1jW32MumxI2HsjITrdZnyrdxM3/JfzSaZdXrgvmsxkairJWJjSY1LJhzSQ+p
	 P4t0bZk3GZDf7dHxukEgJO8TpWPFdq15JQKvyRSfC3uHCDsppm3h+QbFFYxBRMtQJabT6
	 xmnIeVjuBTwgy0sCcVmSwfkBVVvqd8vDaVe3sIsLAhTtf7aXYqQkiNAv6+HBIB1YzX650
	 ahBPF9JTII/vTDGXATcBTN7izYcAwOhT/GbnOQCbuiXUqsrhxWrF5F2Qmvcjg4Npb4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=l27shPGF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.66
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013066.outbound.protection.outlook.com [52.101.72.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8B260A260B;
	Sat, 24 Oct 2026 12:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC8B260A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=l27shPGF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FG3YXsa2MadMpPG9Z1aJjoEKWGi3r+D/yVvGnkTM6+SfhVyHtpQA7sJZ6upb3jd+T7eDIXqeXd74ceV9Mj3ArZZcbyQ8VIwAHzk+k6YTtGSNFTc0Cl+hdGmq6Qb31MRqY+mrGY4Y12t+kyxMTKqN1I5ZAHhZyelnBjw6mHtd3rN1XzTJX+o08cnOrTn8Jk1594Tc3nHKUSinUtfe9/sAJY5GYDmhSDhBnPYApUs6YBxDvg7l+lCnsi9Rct1YyrH/l6NbEPTjwh+j1P/08IS2cP6zq4AzGRdiMsXdTYyq6B2MIes2pB5yPgaoqzQx2EeehL0ck3Hck9gAmcNZAsnbZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lYEzPh2HCvulMM7n8NLZihzPYqqg9U+hllx69esfCrk=;
 b=kzoH1glA+Cdoo9ivNmf3l/GkFCfGbb+l4nnfeH6GR1wr1uW3wlvkFxNcGIwrKkxuAbGNxa0BGRfRDMcf5En8BfgBZEZ9Cvlys1Wl4X5VpbpQt3zDtJ3ZIaHodCWLd/0kclXF+y37EtZUMNvkF1DHef+SZTcVCuWjdk5b9uGxS2g+LUPTgphhLk4LTYyuY7ls0dEi5InLsD5IOa/UBoRovezs03CBDgBn5LtjwHQnqULO6nFDkWtbI7D5RlPyxSWAzn/1vye5kP9fc9Q9538NWbg3V7viXxqge4PW6HdzzUaXHzEOl2UpKneeQGXKkJKiUAgYKHqX5yNkOgbGMpsfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYEzPh2HCvulMM7n8NLZihzPYqqg9U+hllx69esfCrk=;
 b=l27shPGFcisFRG3ADoSgFo6nVXrpecqjECAhpkR4poF5ogpvUJ70W+O/D0WTPZe//T6cMLHadIN3ZR4Nh2Y8gwkr6BVpOMlxkfXaZqbX0l55+okvBK4hDY1boSxSLdRuk43idlemb8/MDy5+IqhsQYKBd78KAHONfP7/aowQpN3GADjR3VoZH0/Q7sLnznUhlIcdYVM3K69NTtizcLrCPxyapGSNeMO2u3tiIn1xtYJGC7flJOERr5MmVLMCh3wkcGbnvV4a65dGoDIp2OxvbL3CJW0kUDlLBJ7f3FP7k4J3YwSfyB6OLxYOtPg8BkPYBualEcFB366iikZ6yFjj1Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PAXPR04MB9123.eurprd04.prod.outlook.com
 (2603:10a6:102:22e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.20; Sat, 24 Oct
 2026 12:25:54 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:25:53 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Joao Pinto <Joao.Pinto@synopsys.com>,
	Hannes Reinicke <hare@suse.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 06/10] scsi: ufs: dwc: Export common clock divider and link status helpers
Date: Sat, 24 Oct 2026 14:25:29 +0200
Message-ID: <20261024122533.3609180-7-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PAXPR04MB9123:EE_
X-MS-Office365-Filtering-Correlation-Id: 01c87b54-f1e0-43a5-0d1c-08df31c9f24f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|19092799006|23010399003|921020|11063799006|56012099006|261009223027099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|10067099003|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
 twWECO6HRujJ+QrdHvSWON1fgm+T1XZBrRTsWeirXGCClckfpy08udwuotN16b90/JynNmth3C2W4X74zlD1XCZDGQvpzcu8jV2fu88hQr/6yNPoi4Kp3WtdbQdQAXL+EUID3cssuSaqj4itTdBicY0QaVUG1rcM8nEKBLIZ9Fer762HWLeYU6oyXI0h18PB6BnkjGg3CFiHygLCE02DcnN8f3Z0EwI5SvoNmAZunFcGQEEaD0tbpWHMRvkfPrQh+iWGmN2BuIR9Q1+qFIiUluH1YwJgU1g3k7dNAErvQaiKh54hbSdlwV09FXjIzBhUvcWjkkq86ERwcR8CAr7W6RFfeaEocwK+RGKLRkq7P6yc+jETytQHBqZXQStLNTjSVqQmF3BlSEar3YFnMwmvJ4AmhEa5WAzcH4WnSSUfIA1HpmjvgBhqBm3Syk93ukot7ju6PTNARSIAz8T1RchAccIR/B5hY10fgbjCKEPuKpBh+Ky7pKwLCN6PKorchMhcQS1t2myyOV5MEp/e84em73k/2ZhL7Yc44rMp4TV6drA6dJo704a55YkNokUEFmoVfTKwiyueGh0SS8Ecsrw0NTPeIOVTrGiyPqB1oB/slUNn0ZvgsgCbOjQTbPHSOs2YJleAkp6RnIVDRNmTWqA6HkTPaSyyMiCFogf6bU8WhW//bndSP0uFk/UXtWGaqbvUYvgG22xVwnlWhqql3PXNAw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(19092799006)(23010399003)(921020)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZXE5MUNMQ283ZHVOUDZYb2VjQkpvTFRaZkE4QmNpTFpIeDVvY2JEUHQ0OTFx?=
 =?utf-8?B?QmVtSjJvSjNSdjRxaWNXSlF3ekFGS1o1MnU2Rmh3cXEzZ3MrMEtMSWVxNEdj?=
 =?utf-8?B?d0pYWmNOMFNLOHorZDM1T1NHZnBSaUt0R2laNlFkd0FmZWhUOTNzMGV4REty?=
 =?utf-8?B?WFVneTlwYitSQjRESGdHcnJoaEVVNlgrR1ZkUHprQU1BQWlraG53ZTQvem1x?=
 =?utf-8?B?UEZpaXIydjU3Zkx0QXlGMjlXbGRQd2lWM3RUNEtyNis4MlVHU1IraXFRK0JF?=
 =?utf-8?B?d3pqM3NMZWk2ZkNiRjBEazZtQWU4MXRkOWR1bEJXTVpOeXJqdVlaTTJpb0FH?=
 =?utf-8?B?NUxLUkVPZTRYdm9kNHdWdUlWa3RyU281RWlqbEpWRmd3TWt2eEl2S2xwZlU4?=
 =?utf-8?B?ZHN0aWVoYmhYYXBseFdKQUVYNk9iRzdnVUMzdnZCMFMyeWlpc0xEUTk5S1I4?=
 =?utf-8?B?aURxVk1nS3VpSlZSalRjVFIxM0hBNHVlNWxFSkVOaEZyVkpBSWoxTkVKLzdj?=
 =?utf-8?B?c1pPaXNZK3pRTWN1TnYxL1h2eDFPU2JBVkpSRVRsT21WM3IrbWkxTW9GeVBu?=
 =?utf-8?B?TzNRdlFRcXNSOFpkUVExWmFGRDN3NEhCbzdKV3FkSWxmQ3NVeDN4VUxLdUtz?=
 =?utf-8?B?Z3I4VzdQT1lyM2ZkT0FYNktzYnNFNGVNY0ZjbG9VK3JYbWYwYXUzZXcwRUtp?=
 =?utf-8?B?R2xMZFBOU0crOUVQQnZNaUc5WWFnV2NsU0RDNWg0OXo0elhHUDRJWVZMR0Fq?=
 =?utf-8?B?bXkyR2orSUF6d3FaT1Jlbm9zMzlURFVxYmhxeHRuSytiNFJiV0RiKzlZcUJh?=
 =?utf-8?B?RHkyWTU1alRiL0hra0VLR3J4OTRZbmtQa2RsM1RXMjA0cUVGU2dMd1BUbmM0?=
 =?utf-8?B?TW94RGhOVDQyemJXM09EME5Yd0t2T3d4Mm50L2o2L2lJY0JzdCtyVmVkeTdk?=
 =?utf-8?B?QjhOM0pzTWlMZzhyUmoyOHlaaU5XalVZZW8zcjU3MzdYU01xM3dGSUpiSkhk?=
 =?utf-8?B?dVVRVm5rUG9mQkdySUNDS0RMRzRiWTYxZVFwWHNBcTBBeXRrTDMzY2doUHhF?=
 =?utf-8?B?QjZyaXN1RnRYSk84YkdvS09qT0RDWTY4bHdDbGxaRnVxMTEyZHBrU092TTRQ?=
 =?utf-8?B?c1I5TnJoQ1VpWE43L3NPZ0UyYTcrNE9aUjNDdURvcnJuWUlpRFJCNjFrTFVI?=
 =?utf-8?B?T3IxYk9TcUxiWmNvVGtXK04yRnNBMkxXREdnbUk0T2FVdjFiNzMrU09KQk1T?=
 =?utf-8?B?cUJqUzdtUFJ4V3c3M0x5RjlIemhsUzQxM1BEbjUzWHBtYTdweFB1UGhWZmFV?=
 =?utf-8?B?ODFhYUtvSVJabFc1dlh3NFMyREkxaHRyeUxjd1NIdXJMdXk1d2lhUFhWOVFq?=
 =?utf-8?B?cnJXTnRySjE2OGxvOTFvNlBKMXlKay9qWUsyL1JjZUg5c1ZicDV5ZEtPbGVl?=
 =?utf-8?B?Q3llN0ZEZHZUWm5VcTBscmVmVFBiSGtmNEZXUjQ2ZGtobkdFK1g1VzRKVjlh?=
 =?utf-8?B?QnBuWVdJQzN1UksrbC9XTDVRMlorLy9hVW9NSi9ycUZvdFFrUFk4cWkyOU5N?=
 =?utf-8?B?WS9BQWtvVkNieWJzRHlheDFUdTk0cndaRmZwNVVWRXdYbFYreENHWm1HdzFH?=
 =?utf-8?B?ZG5QbXBmSTJuc1Z4MjJTRElsYktMRkcxRGdDMkl0cG5qcHdNRk1vSTNqcHlr?=
 =?utf-8?B?blF2WTdmRjJLQjUwODgybFV3TFZzOThML21ZWS9pRE9LM2M3ckh1a3kzUFdy?=
 =?utf-8?B?SU1GOEl5WGNJRGFWRkd2d01jNmxwTlJyVC93dmhUR2JhdHlSWFFyazlqRDJq?=
 =?utf-8?B?UmhYcVJGdWcyU1dKcTd5bUExNzFEejcxN2VnbHBKZVQwVVRzSEE2Tmo1d21t?=
 =?utf-8?B?QzJTSUZvV1ErUlVqbVY0TDBOYVhJay8wVm1XMTEwQ1l2Y2kwajZod25iRDVL?=
 =?utf-8?B?aTBBdkdWVDRTUnBMRkNhNkJJK2N5Q0kxRFdsUzNleVBNdGlZRWU4bkNCcGFY?=
 =?utf-8?B?cEU5TERIcTZzaTN5eU0yWndjOVFPOGIyUzJTUGd5bnBXQnNqLzVuaHk0MDhq?=
 =?utf-8?B?SVZwcXowZTc5UGxpcFNrcVFnT3FRWTAzMUwxMmRDNml1UzJMeTFpdE1PSHAy?=
 =?utf-8?B?R2ovMkRYRE15RHV4TkMyU0R1RHF4TjRkUmtCSlJoLzJpMUxieGsxdFFvakI4?=
 =?utf-8?B?UUpOMEgxOElsWXRuLzVLWCtMQ3MwN2lBN0dYckQ4R1hoNFp6TmpaZ3JFTVJn?=
 =?utf-8?B?ZU9ENmlRYWkyaHNLR1U4ZTVLN0Y3cmRLN0NNdldWL2duWFpSUHY1Y2JxMlBC?=
 =?utf-8?B?bUdxeEdMZlBMTjRaN1dKN1ZtZVNyaE11ZXYyRG1HaXYva2wzTEcxUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c87b54-f1e0-43a5-0d1c-08df31c9f24f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2026 12:25:53.4020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAIfsSfiHz642+Egz0wUYKh/rcRy6BK8R/g9DgAwLB59HZB/AxfEma/iJTxEDY8tWV+2C1jf3VBBvBMWmE0zgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9123

Make ufshcd_dwc_program_clk_div() and ufshcd_dwc_link_is_up() available to
DWC-based platform glue drivers. These helpers are needed by platform
drivers that must program the controller HCLK divider and verify link state
during their vendor-specific initialization flows.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
---
 drivers/ufs/host/ufshcd-dwc.c | 6 ++++--
 drivers/ufs/host/ufshcd-dwc.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
index 20b7174e9498..037b99d1148c 100644
--- a/drivers/ufs/host/ufshcd-dwc.c
+++ b/drivers/ufs/host/ufshcd-dwc.c
@@ -39,10 +39,11 @@ EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
  * @divider_val: clock divider value to be programmed
  *
  */
-static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
 {
 	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
 }
+EXPORT_SYMBOL(ufshcd_dwc_program_clk_div);
 
 /**
  * ufshcd_dwc_link_is_up() - check if link is up.
@@ -50,7 +51,7 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
  *
  * Return: 0 on success, a negative errno value on failure.
  */
-static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 {
 	u32 dme_result = 0;
 	int ret;
@@ -66,6 +67,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
 
 	return -ENOLINK;
 }
+EXPORT_SYMBOL(ufshcd_dwc_link_is_up);
 
 /**
  * ufshcd_dwc_connection_setup() - configure unipro attributes.
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index d8673cd54d4c..53b523ef59df 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -47,4 +47,6 @@ int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
 				const struct ufshcd_dme_attr_val *v, int n);
 int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
 int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
+int ufshcd_dwc_link_is_up(struct ufs_hba *hba);
+void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val);
 #endif /* End of Header */
-- 
2.43.0

