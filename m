Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011054.outbound.protection.outlook.com [52.101.70.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A3E48382F;
	Wed, 16 Sep 2026 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548295; cv=fail; b=oh7k9GZYOw4OSK1sXLmRNK3g6C4eehK5oi4I6KTh6LqEPlJ67tVjA+oGdBAHbfeOdeVp1riV4gxE3Ddxw6j8Gps3/2Ty/wQdcbSadRbrb7BsbzNUX/xZM+ypDFfDAwPpXJgHVVbjr0PW1pPHc4/+oc24ygUqsTBAiDQmrOrvjy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548295; c=relaxed/simple;
	bh=pZ/RxeCSS+yGKCwyxaejW/gTmFqTnFiUah4zsBGqaK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HlssXA+rmB/rjZdU72JYXwkr6saaurr7nibh2H8vf2FpNqjog5zpRgUTE3ZmgM0hSwZa6dNlEHwa0gVqGHvAcAt/fn45BULgu39aFXnDnu1RQw393yKFD2N6k2giXXZcK3iIz6qDRJUjtShZpd6D08SE5D7811JREgezM7GHp2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=VY6WUwYZ; arc=fail smtp.client-ip=52.101.70.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="VY6WUwYZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkde7HLCApRkGYrnotP2/eTig9I8O3FPA+1+mn4K0uf3KiEnwJRroD77PfRyD91o9U036yQa4mXsjd/MqCslw094OrNYl9cJmgDTOcbNAAlVHF5F3fQ6D1FfBNYVd+ukZ6CZjO7qerCQBcbMNDycIdsx+crl34EWSbairmh7D/2cOo29guB4WVk4wysAO2MRM+eE5rYuYrmtIHX42LRqUYYvO7MueKTeWkL3QqSR3kZ5tgKj69CPcJ9CpteU6zHex+a/Nffg+5QCLMBzutG8AU/+MwRDI1t4HXNbkpWtUrQ8YxhwMyBrMjy3XI6/Lup8OxzzHOXms614DsmjAx4YbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNHOWLjM2NWYs2V7TInUeViamiQcPDXKCJjXViB/JNQ=;
 b=jPKkvr6p0D12MYDrW+X5BZH8lAUBNmRNee6mXxeyaZxnDumRYBE11m71yWL9HJyn6oXUxH5ayXk8MXDdQ7rz/KDP6RRbaR2T7S845Gbs6YovqTuT8V0jJyPMdTDIXHRrwjKkudKIoRvlQT4XoOf5mIMTYXcEDhLJlshtL+CIIfWLTnuRlrfqFfLi8ScaIUngPTi8Ba87h7W/aynK57tA/MZc327vHEaWEa4wvci0Dscyv2hq/yTjNDNQteQC1tgAHTwKP5JN8PvWGKtoOQvS2o6CXethjwNFQjJeE5jzraXWBk6p5LENWI+BeBx34cigASUIB7zJ2q/XT6OchYYqlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNHOWLjM2NWYs2V7TInUeViamiQcPDXKCJjXViB/JNQ=;
 b=VY6WUwYZebJf4LGJ0eCAvJQFxThSKmv67SPYBvBoXNdPoqDFW1RaQCaHUycGEjk3EZGmyC/AqUlY5E/HLRkHoqbhkGUr5HlvuORPO9l6c1dJAIjfx6r67TkS30XliwAQ9wuuIuECkzyBvkHFa5GE2iBVYL6Irlwhlr4mfImM/npCHQi5fe41XKZJHIGq7yzEmt/bQHSbgfjie4agQnefnWmAY1AjZ2Danp82l5ABVx+5P8hDkWTchEYpaU7jjdp+6Y3fFKsexXFiSVqfWm4dT2CR+F/DJ4xyRRczaL8M0TKH4/bJWG8qawOCova+4WEZ5ASBrbgNpqO+U+ZjvV1vJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DUZPR04MB9981.eurprd04.prod.outlook.com
 (2603:10a6:10:4d8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 08:44:32 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 08:44:31 +0000
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
Subject: [PATCH v3 08/10] arm64: dts: freescale: s32n79: Add UFS host controller
Date: Wed, 16 Sep 2026 10:44:09 +0200
Message-ID: <20260916084411.941297-9-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::6) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 32e7236b-89de-4cef-73a9-08df13ceba39
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|19092799006|366016|23010399003|921020|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Y+VQRmPlv88TPFs8s/RQ3LmM85gumLQqyrcIKeK421V9igQw204GK9j3yJelXjo1VPb1e/hs3oJ3YGFr9n2UcbBmBMXccdT1BoO45Cj7gqL6+ZTjoTZrNsUhF4WTwHEpsYRrXazn9odcCUW0n+qR8n60Qxsb2nKHn7nBTz5aUcAbKhaBeM5nQteycPBlIX4DNI1qgwyEaQwbpgRIbGKp1kuR9fZ9GbeaW2hTu0ezP/TLtciI9wD7wM53RbKtP0XdiAi4JDqKLC94G4oaVYSvNE/eKvALwWL0urW6Ka/Z+SNT/2CmgqiL6v07oDOP9gm9ZvAMixBsnu25Zl0TF7FJ0Tlk5DDjyg2ZCQZZqMfW6r1eDW9aHvOi/ngcYbcoNxdmmDFshNwAleaZzXCzOag5q2g8R/HnXrW3AG1F0ugopdhauJAq2K6Osl7sKWiXxYTznC54jJkF6Z6QEHM+9ZpB0aHzebhB0lb0dzv54uUWM5gbYdMqpPlmlf0I0s9sam5ZLA+2LeFDe3mbNJKXonTzrRx8v3kB2JEX172JC6DoFzRSEuHRBhIalfLfjX41WLwaYV4+vnsFpyLsPKek6itY7h5uxLqXpFRd1She334FRfPALYAl/dxOyp0Fq+A852Veh2pnjHwLNnfVy+ZkoGI6fDc5qG0l9qhyR4kooF0fn6bFOGW7WctJ0C8Twmv1YAGfmM1Jqg4USGEW5ntYz3JZQw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(19092799006)(366016)(23010399003)(921020)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c2V2dHVKUmxPSXI1UGp1cnBFb2psWk8wUUZveTI5YkdoY0dNT2wvR2VjTDdF?=
 =?utf-8?B?VCtRRUJuZWI4OFAzSUdUbGVOQnBlNU4zZkR2b1lhSkdFTkJwVXR0K2dLSG5K?=
 =?utf-8?B?bVFHSnNHV3NNY0FTZWIxMXJvRDVLOVFNdE1tUmU5YmdNZEtkVHcwVUl4cXAz?=
 =?utf-8?B?eUw5MXlhNEp6dG9FZDVxOTNuNW1HMC9haFZCTWJDR3BZY1RBd0kxMFlUb1ow?=
 =?utf-8?B?MVd1SkFobU4rdUhuWWpMYnVlTlExWExoSC8wZTNRNHlYQ0ZvNFJYRThLZEV3?=
 =?utf-8?B?Z2x3a0JmZXg2Tlg2M08xTEhVZTlTbWYrOXdweTdXa29IQmVJYVFhdmV1M1pU?=
 =?utf-8?B?SU4zeXVReldHZzlSWnFLQW1GaUNWak1WU1hnaWl3RzMraVJ4T2RiNEt5dzJX?=
 =?utf-8?B?NVpzWWc1TGdoWVJsN1RTekZ0YTB2ek9kamdaWGwvVjE5aGxRRTJpelp6ekRU?=
 =?utf-8?B?REw0QUQ5SkI0Nzl0MW9jdndpcGpyb2g3andwaUVEaDdmTUt6M2VKc0tURHBZ?=
 =?utf-8?B?NW5qZzRhYzdydVhRK2RNM3I0VkdONU5vL2VrSlVpaHlwejBxZ3JPd1RqWjBS?=
 =?utf-8?B?cGNIbUlUeGVUdE5DdE5UNG5STU5ZKzdYV0c4cW16TzhaSGthYytuOVZmc0JB?=
 =?utf-8?B?ZE1HWHlkQmZ5WEZsQUlQTUFvaXVGRUlkMzdCOXFxbkFmdnhlRHBVOVNDNkpF?=
 =?utf-8?B?RWE4SE5qOEpBWC82MUcxT0tUbXZ0dkk2aitiL2Vsa0ZCSkpFaHo5T0RqNlEy?=
 =?utf-8?B?WVhOMXczVkdxcjI4SGMxUlpkUGpZKzUrcSs2MmxBQ0VrUHlwNTFIWFgwTnpm?=
 =?utf-8?B?aXRnM0N6M1JNQnBtK1FYYVJ1MC9Ednc3UlBPbHdmeHdUWStIQjBSNFlLVVBO?=
 =?utf-8?B?NDZ6b1FuWG5lYmNEbzJsbXhZVEppQTdHTmh1VTkwUHNVZm01K1VPamRUaEZK?=
 =?utf-8?B?YVpFdmMwQXpabVZiVkNlaDJBY3dxczZtU2piTEJJeHV0V3lkSDR1SUxUaVNv?=
 =?utf-8?B?NDJRVjB3YTF4dEdGRnZUTkxRNDJVTkdyRFVIRXJzY0JJa1g1UkFMMU9ZbVBN?=
 =?utf-8?B?aUlWajlNS3U1ZUxGTkEvUU02RmxUUzByOEJzLzkzOUpKMmY3UUY5YnhKcDJz?=
 =?utf-8?B?M2NLMHhBaW05cjY2NnRaZGdRbWlZc21oWWtQaUZ2ZnpnbkVTUUNKb09aOEV2?=
 =?utf-8?B?VTdRTWY1aVN6YlMzbkN6T2tUU044U0I5ekNRWjM5cGxYcXYwK1lkNUhoM3J5?=
 =?utf-8?B?TWFycjJaY3ZTdGVEYjJIc0YzZE9tOTBUc2F1N2xsdGhxcVNDQWxiaEtkbWZ4?=
 =?utf-8?B?LzlvcFJsc3JLUEhhbW5xSHQza2RUWjVQYVpKQk5JSXFyMVlnTml3d1NZai9m?=
 =?utf-8?B?Y3hsNElzbkF3MHVpWGRXenZGc2dhd1ZIdVZNeDJxbmszMjQyVkZEYmp2ekIw?=
 =?utf-8?B?TXZTZGNZcWM3VDFpNndxOVFtVXJZbGRHVmVYWml0MlpOejlPbUV0R3lTRnhB?=
 =?utf-8?B?bjdpSHFBMzVUKy9oTUpVRXhzYTFSMWc0WGlRMnJRVUxtT1hpTlV2UTdmZ0Jy?=
 =?utf-8?B?ckJBUlJuSW95VFhwQmJJSEFRMHNQV2lCNk83TExwdjZ6MUhFem1qd3ZxMVY0?=
 =?utf-8?B?alFEeXBaUlR1YXpMazh0WlpCaUlGclBGYTdpM09ZNzJPYUNSS0ZZaC9XNlV6?=
 =?utf-8?B?aUoxQkdGVU5Ia3lSb3FJZkpydFIzZEdFaFR1bW0rY3NEc0ZNc0VaUWw4U0di?=
 =?utf-8?B?bEVDRHhtN29temFkellOc1Q0blhET0lpVnQ3WmtnbCtwUWlvSGd0WDN5TzIv?=
 =?utf-8?B?Z015czlpRTYwV0txVkRZT3Y2ZDJXSS9FRnNyZ0RHcStFM21XbXRlV0JDM2JD?=
 =?utf-8?B?OWhlQ3BCcmV0Qmh6dkcxMUxXcW4vNzMzakhjZnN3MTUwdVpscHd6MDhqbjd4?=
 =?utf-8?B?N09CYXVrMHF4TTNaSGxFcFdCck8zbm5ON216NVR3ZVZSN1BZcTNUNDJROVp3?=
 =?utf-8?B?YkFnUWtYNWVwVUxzOGhxNUphREFYY1JLZ1dVL080VVBrTjBDdmFDN2F6RDJD?=
 =?utf-8?B?RlhPVXN1b1A0enZ3SnBxSFNNK1UxWXRjd3A2Z3draDNKVnRxWVBxUksxeWhl?=
 =?utf-8?B?eUV3WUxiYjNKNW5rVVNFZll1QkpwSmFJMUd0SittMHVYVTJLb2JZNnBCWTNL?=
 =?utf-8?B?eDBhcVRyVDhiTXZiUE5IZWhXNk4yLzV4NzFDemhFVXcvS20zQVhrWDJTdngx?=
 =?utf-8?B?MEZZeUhvUjVqcFZTZURPSzliQWgvRGdUandMN2pOZ05UYVVJazBtdlF1UlVi?=
 =?utf-8?B?dmVxaFlYS3grZHBLdEZKOURTeml0S25SYlNWcEJjN0Y5dDY0K0RzUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32e7236b-89de-4cef-73a9-08df13ceba39
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 08:44:31.9124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ls8jKwGRhM5cxXaLkKbI0jsMrh6eKBKzN3W97OPOEUk+LQ7/JUrCrRpNTkOz8mhskW40DAJKLl7nRUNRq1dhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9981

Add the S32N79 UFS host controller node to the SoC dtsi.
The controller remains disabled by default and is enabled by board dts
files as needed.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79.dtsi b/arch/arm64/boot/dts/freescale/s32n79.dtsi
index 94ab58783fdc..0b51ca8bc7f9 100644
--- a/arch/arm64/boot/dts/freescale/s32n79.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32n79.dtsi
@@ -100,6 +100,16 @@ uart7: serial@4aa40000 {
 			status = "disabled";
 		};
 
+		ufshc: ufs@4ac80000 {
+			compatible = "nxp,s32n79-ufshc", "jedec,ufs-2.0";
+			reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+			reg-names = "ufshc", "scm";
+			interrupt-parent = <&irqsteer_coss>;
+			interrupts = <211>;
+			clocks = <&clks 0x92>;
+			status = "disabled";
+		};
+
 		irqsteer_coss: interrupt-controller@4ed00000 {
 			compatible = "nxp,s32n79-irqsteer";
 			reg = <0x4ed00000 0x10000>;
-- 
2.43.0

