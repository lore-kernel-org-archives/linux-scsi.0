Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EF037A85B;
	Wed, 26 Aug 2026 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751688; cv=fail; b=UzdWZ7jiphHge+H5IuAPmUDOkXMErbtefTaRMINg06WNCr5t21J1leywgEx2bIEKwh8gWAcOv2H2aUTCbvabfNiHF14T/MpnqhGQzjp2Xuq4hIwOTyjF/wa3xwvHTpEvVDNSVHtKd56/6pzB0hmDs/11RW266W+HL9hQrWJsR3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751688; c=relaxed/simple;
	bh=p46tcHLmcWTBfScBhcw9haEOSBR6RqUjnTixpZfNo+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AsFLAsVWEiNeDTkkYsZRLBFSODpT95NrUuZSWhknsw3S6Yx7p55q7jvwpCr0jUn0bzocSR5Kan5+gr8x87PM6/2g1CNvJQETOlsz5aEWmZIQjILUKc4xBPL2CqioRt0y5A4S8akJTApUvVuJJgHBfV6H7X4vIFVE54dGu6eFpd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=J0fvaY2q; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="J0fvaY2q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5GP1lFT9Pk7oRWn4bBe8o2WD6JwX3WSpcuTcZbKdLwScovrIK+GcpedU1WkXxmVsxr49TI/F4nu2cqefHuiUpvccxp3tS5VT4614G6DvHBe8BSkGEa9L5PDwuSFP/P8ArsDy8+ayU9cAV0vKr9nCwjYqLAlwTOjnlt0nF+g/dPAJ5oqbzh86ulFhmrInJszqwA4Bie4Ef9H1PDvlb3hKTYQA969bWpMcRHabsy1iUJEwx+f4x6UJSJS0yO8VoRWXHiPnB3AzkwQ43hmBkg5gmHQnsSN02R8zBoYHu6P0cLgz66c+SMKIjWAba1da0ZgzH+2egwFitn2/+0itCUC2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm6quMlKZhNGIMDj/m/dU9nLjLDC8U3D/hkm2fySHO8=;
 b=QrEIqruEzBUV+136JQz50gIzxx2I1FUw0SwIl/nbnr+BzVswWmJx3uhR/u6Z50zh9eyrlOBTkVRs5f/beW6h7+M+HUZCe84m1jK0gVlUrKnmFoAh7jvd9W32IMADhRmI9yw856HY1Pzy7SY1u6LFDxF/v4VarNdiifbFtM6JNUeDXpx2t6BqTp2amUtg/J4/SHcwVYK+czlWIN0C8dDwarbcJwERFLVxw7UkAgaJx72b5IpTWYJS4tTBNTMm7be5eBvrMzyd6kbGMSRfbiYmhKYs2JlygHLluOtYvHG0DNeWaLyB3Ajse2n+qZCBKjj3S7W+bBseMWQM7ALZHbVz7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm6quMlKZhNGIMDj/m/dU9nLjLDC8U3D/hkm2fySHO8=;
 b=J0fvaY2qyHL2eMMbKYJ2TtMBWGtT/NrewmewEC0GB4M04i4r/Bm4zwMzyuUlLIRdQttiXJ7JUCCBnWw4P1BeqyCunhi3a2Jl4IdrZ3Su5aY5s1DZRpAhkdDcUDgTkYRVH+c5i4N9N3Zd7DlFq4WJ7EQi13UpmQXQ+iVtSOKQ76q15wR31rjLCm81SG/Cfrk3ogfeYf10JRqDVynYr9pfowzQa95QJN1b9FzwuUEov41cRUOQS92oKBuoec63ejgapXrkgpTGBpXNN8Wqh+Zf+KoIlrKflytnU+axrhUvF/G/NqP/dALRIXhELMq//M0/vMk+LcpGSJAoTM77QqGtbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:41:08 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:41:08 +0000
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
Subject: [PATCH 08/10] arm64: dts: freescale: s32n79: Add UFS host controller
Date: Wed, 26 Aug 2026 15:40:46 +0200
Message-ID: <20260826134048.854748-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0430.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: e9b7fd06-ba19-4826-617d-08df0377af15
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 ggt6oJRLyvuzizzEOGok6AnL4YSs6hOaIxhPPfJodTsjYJIxrbJZrxN3TZjOfOMWxlCHHbtEPLFCVhdeW4l+zdWTmQGvMyyAxKNUJw+D6EVBCOyFz2vZ1JH6qcaJmYVBb20gQI5H1rmUOr+4E8HLKhlEA8lI4CKLiKVirNNZZQaZLKM7oKIna2aDdVLT8Oq4a6naTPCFmFD3QPKBJMrQ/RWiiPkseJErV/g1Y/7uVy5V1nvDyTvyF3JEZBbapFplk/JUWuUTE+0e1FpwzQkFzYfgGIhnFKwtAcPVNGzlw2Rvi2rAYO8Xxsz8ZwMTJiKth62PG9vIFn1EzDwUimTzVxwQAOTC5aTE7DodjfPH4FYXKiB0CdRjf8wD9ozfXE+q1NBWlNaAwB8SwjRbP9EPSuKnQN0uIS6J+fvhPQhJwysWRLSP9j86ULpLFMoGuMzF18/Itc9EXnH5ldJcx7U0odIRbbiTGR9dnU/rwk5d+Ere/lKLlQXEfymSFRrfFL8chOEy73R0H691VP4NDQ8d7+KLP493jgfytGZGZkUkJt9gTbYMP22dF5uFUVTRLIeybTMy1tNvUbsQX/1gSEW7lVKKvocXI0fksErvF40vI8pv3675CLVOBWPgZ22vPo2Z88Se+SZUEQJZEqstGF8kEpIgCbkh3143Et1iWgl90B2ynxEBiiYnWuSzmwwleWqSw5lrQ2IbxspSetqEx8xXyA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SnF3eFQrOWJaLzlCYzZvQnA2c0s3Z3VkUXhwU1ptNTIyelNldDZRT3AyRkw4?=
 =?utf-8?B?TzBHR2ludHlYbFZNKzcrbGtwN1BIeTNrcExEN203aFNGdkFPVUgzMjZTWVhl?=
 =?utf-8?B?eXBvOTFLTFc3K1RwV0ZORU1FZDdzUGFNd0hlaldUcGJZc3l4ZVM4TWNvNGhT?=
 =?utf-8?B?dnR2dGEybDYrMWoyVHdQaFRFLzBiRXdjTE5hdlNWSU5sMlc4YjN5SlJnTWNz?=
 =?utf-8?B?Ykk5cjQ4bzQwbkJaSDQ2SGFacS82cVdaNTNrNHE1cUdvUjlaTWt1OU1Ca2cz?=
 =?utf-8?B?Y0ZCZzFPb28wYjdRa3NIQzZWVnZVcWFicGRaa282ZExIc1JIWG1IcXVPS1BR?=
 =?utf-8?B?bkYwTi8wVG9wQjBZMVBicERSdG8zK01kbmxzakpHZzJxWUhzUXA0bjFaUTRT?=
 =?utf-8?B?Zk9lK3prMjBBMDNLK3hLbVRPWUhlcU5nWWd2dGNYcHZpbjhPdHNlb05LVGQr?=
 =?utf-8?B?dlYrMXZid2tMSTJCTm8xeGoyS1doUkNqQmJOVEp0eTIrR2ZvWGN5UklaZXdL?=
 =?utf-8?B?ZUR2WnVwd1lQekFTbHBjWVpaRU5VNEtxS3FyQlRmc0dJekNtTzNLUVBVcG41?=
 =?utf-8?B?S0dvQkJNZlF1ZjArVGI4UjBlOUwxRFRvUlJoRHZNZmFqY3VreUdwcVFEQTBO?=
 =?utf-8?B?ZkdMMmIwNzBEd2t5NkJKMWs1T1R5dTdzZysyRWtmd2V6YUJaaHZ2MExxYWtU?=
 =?utf-8?B?YUcrTFVzZjJNd1c2WHlUZU9UQU5rZ3haYnBnL0VmVFdwOVp1SkFkYmdzR1Jv?=
 =?utf-8?B?Ky9qTitnS2g5ODEwUm1Eb1VBNGJ1MmpiTEhwOUlYa3NRS0MxZjlFeTBrb1Nt?=
 =?utf-8?B?V1Y4OHY0clNrTFNCZ2h5ZTczcVh2eTRDTlFFR05relE4bVREeC9LdWZyaVVO?=
 =?utf-8?B?R3g0SjVMcmxpS1p0WCtxaWZYVS81SlQwaVdlaDcwTWJ2dFFjRGZCVEF0OTA2?=
 =?utf-8?B?QWpXNi92dE5SbVcxNFJLcUpIdG8rT1QwdkMzMHhIdStqZmxDZWMzUi9GMVhj?=
 =?utf-8?B?Z3lYMGZjV3Y3WWYwTWx5V0FNb2pKZVV4VzA1aFU2SXliYmNIZW5oTDRXNEV5?=
 =?utf-8?B?ay9kMTNKUFZjWXdjSTJ1cDduaGczQWFsVlZuYzk5SHpEdDlDallLSkx3OXk2?=
 =?utf-8?B?TEpVM0dhRTZaQ3B2RHErdWNpelVYTnAvdUE1UkR1YW1nbVZtN2JoZzBXcFFs?=
 =?utf-8?B?ZUFEaERzMEFvOGVLQ0pQYW1WZGI3SGJtZHBlZVlzcWxiNC9CYnh5Vys1WEht?=
 =?utf-8?B?VnYwdlRCbWp1TEpvd1R4Q2MzZW15M1UwdTlWRXhHRHFLS3VnMnIvRGtpY2kw?=
 =?utf-8?B?Z2l3cmZmTURtek1nalZlZkhCekFibHBEMzluMWNXRXV2RGdjWjV2SzEwY1R6?=
 =?utf-8?B?ZWhuY09iM2lRTTROQ1l3ZkxMVVlKNGQ2NzZDZlBvajdkTEJXQ1loYTBLNGhl?=
 =?utf-8?B?UndHQzhOU2o1by8vTlNaYit3MTAxcmJGL2ZIWW9rVFUvbDg4WFZvQmtBRTZJ?=
 =?utf-8?B?SjBBU01qbUl2QnpYZHg1MUZsbEMvZmhQNHJXZUsxNmVHb21acTIrNFFPaEV1?=
 =?utf-8?B?eFpaa1JQVkM3Y1I4Qk95cVZVMXRaY2ZLZDdEMWNzdTFwZjkxNDQvdkNRajJI?=
 =?utf-8?B?U0RFNndNaS9zWmVuc21LaUw3Q29IZENRa1ptZ3lwUFJ1ckFVOStLMGhLb2N3?=
 =?utf-8?B?MGhEOHV4S2hSK0pDalBPeEcxdmF2dHBEU2dlRmJpV290dmdBVnJCd1V3NlR0?=
 =?utf-8?B?OVJJS3dzWUNkcUJ6VldlVXZZODFJYXNWQ1dyQTlCeVpmRFRtMHgySnQzYklx?=
 =?utf-8?B?S2ZqMm4xR3NUb05RSzNWRExNNU1CR2FEL0FPT3VYREhXSWJKN20xNG5NSzJU?=
 =?utf-8?B?UzZ4eCtYUXZDUzZ0N0ZORzR3cHlPNHVka2dzUU41Z2p5MUZYVzJtVVVOWjg2?=
 =?utf-8?B?d2ljR3Z4ZVdyMEZBRjVGZUwrVFUwRnQ2SzJxaTNLcS9YcUlBR2c0ak8rQW9S?=
 =?utf-8?B?anF4LzViN2RDQjZaU3ZHdVhJK1c0MkV1VEpPTzJyU1hReE1rcFE5NjBTUEVR?=
 =?utf-8?B?dC9xa09zUDJUQ3ZRTWlxMERTRGhiQUZRRjdjK2FMYXZ0WmlUTHBsQ1FJUzN6?=
 =?utf-8?B?ZkVEdWQ1U2FOeERIdlN0cHpvOEpLL1JsT2NtWldaT2U0YjJIMDByMzdkUW1t?=
 =?utf-8?B?Z210cHdxSkJOVGNicG9UeU93T2d4bEZsSEIzamwxRlZVYTNTalV5YnVINEhU?=
 =?utf-8?B?d2JMKzdleC9zS1YrYTRxUGU3cStqOHBvZ0JzcHlJckliellhYWZWMGRkbVZv?=
 =?utf-8?B?UDBMYmF0cytxT1hvdkJ6N1lYRWlqNUVqYWdjbGtud05VUXdiUXNIZjZUTlpk?=
 =?utf-8?Q?hM5yr3QVpPrdhTww=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b7fd06-ba19-4826-617d-08df0377af15
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:41:08.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HF2fX/+cXu3UNEic6ZxWvlfIFySebWlnfAOcg3zIOSnoDBmbyEp2W3OjBkKzDKGnx08ydcZozDt+IoeCprO6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

Add the S32N79 UFS host controller node to the SoC dtsi, including the
UFSHC register region and the SCM region required for M-PHY
initialization.

The controller remains disabled by default and is enabled by board dts
files as needed.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79.dtsi b/arch/arm64/boot/dts/freescale/s32n79.dtsi
index 94ab58783fdc..5b92eaea05fb 100644
--- a/arch/arm64/boot/dts/freescale/s32n79.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32n79.dtsi
@@ -100,6 +100,17 @@ uart7: serial@4aa40000 {
 			status = "disabled";
 		};
 
+		ufshc: ufs@4ac80000 {
+			compatible = "nxp,s32n79-ufshc", "jedec,ufs-3.0";
+			reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+			reg-names = "ufshc", "scm";
+			interrupt-parent = <&irqsteer_coss>;
+			interrupts = <211>;
+			clocks = <&clks 0x92>;
+			clock-names = "core_clk";
+			status = "disabled";
+		};
+
 		irqsteer_coss: interrupt-controller@4ed00000 {
 			compatible = "nxp,s32n79-irqsteer";
 			reg = <0x4ed00000 0x10000>;
-- 
2.43.0

