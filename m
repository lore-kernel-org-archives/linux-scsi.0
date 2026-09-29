Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8783C342B;
	Tue, 29 Sep 2026 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676644; cv=fail; b=KvyqGrNUcAFiKGVR4A1bsTATekQypJP4ydiVD0HAz8cZkm2XBm9E1rXu+Z3lh+GuZVGMB1XG8bWGXaBOECGtRzAOAhGvbUWMAMKfRcRGX6m7LTMeDqPhihLKKNMwQrYALACx4TQoS9dVTiNWfd0vpSfHVoputHxGEYleL5yUo0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676644; c=relaxed/simple;
	bh=SlPckDvgmCgHI3K96wXmE3PZMKP1GnJCHi/dHGpHhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sgFqoaNwbANZWlWwqiQ/ZnN2AAAMGkiQDo2K6fr3oHxovciCncqxxw56gQUU1q79V+QIAkmCs5jlmQ3nj06XRK/G86cRTn4NYh/sgFWMOB2f7IXw6DbIijf0yk5LLUXtn/2uyzSAF60Wpb047SlEXzPdDef+Y4nTLp1fH5l5syU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=LL+qzq9r; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="LL+qzq9r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U8pUhr3gcfl1OsdsWRHgSAO9NtnXgGsLWKBy2ppLOAob15b2bhDNPk0vJuIuvqt7azAAWbvvjqAU3EUmu8zwn5UKVumbpI+aJh4u/RA8iIdphETSDFxI0zdXGv9+Z6ybSOx/KIkhr53IkJuv7IW3CqH53IRF1bm/uoRg3+pDIwrhzX1ycpp9PsX7JYjkm8W/yHme3NCHcwIVKdiDH+62UkX9Reis46e11M/stDcGot93bAOjg7fG59ZlfCN0dS+NBq6FL42pfm+OVO7NekY79sai0TFpu/jh04Cx2+DyRMBjQnqv+kmnLQO3E69FiWMgVvevvWudJCM9JgxzQcAxGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=wiinfg08lYODTCvWKD436QUFYNXBY6SEUt6nbdECrWcxvRHxXDUZw1SvhbuTd82jI7Z4gZC4nrU15IKLwVKHZuttqidXwuCH/cltFxU1Wn9tuu0itNupImnAW1Vt/0xh/Xmf8iBzccK17JH97oY/B7D3z4wvy4QA+M0NVLDdaVCuQxiASfo9twM8+mGbMl+b1ZesxN5moTNMQWmwXW8ujBaqlhD1nOBopqy9u26J8FWbCYBCyJeM38efdHrKntkTGNAltyJqsyQPOsTkUl6jIkt5g38E7SMZ1ybJro8c2ykZ3aQbsve95gkQaInQ1GpMs8CGJ/gTsLCIXDd06MFPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=LL+qzq9roiMfAy6a7y5L6EiQfJozPya1dS2+8t9cvY8Zo80DlhajOF1at83o2795XSXihOKmkDFWG37ICqYCghMiPyGYyIeLDT2nWB+mmYCFdGNmErp0bLmNVCZjsrfdniDHL6OXpLvXYrjZE7/qi0IypAJc73nMQ5vCX583TickqO5FDQcbpXTPpBNRen0ApcwLpvC42XaMLOWxMocNXp1YHkJXPCXOvFx+rzci6rya33kS9bCQlUyxXxOXkxceDm9sONZAp2xP9Kxp+ZmAadlTRNIwQYD6Ccs+CuORHG6YIvsmkvkj2wK90tYJA2x6Kfzpi8AeDSXc+Yo+uct35g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI0PR04MB888289.eurprd04.prod.outlook.com
 (2603:10a6:800:366::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 10:10:21 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 10:10:21 +0000
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
Subject: [PATCH v7 11/12] arm64: dts: freescale: s32n79-rdb: Enable UFS
Date: Tue, 29 Sep 2026 12:09:45 +0200
Message-ID: <20260929100946.693962-12-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
References: <20260929100946.693962-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::12) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI0PR04MB888289:EE_
X-MS-Office365-Filtering-Correlation-Id: 85c36bed-fa6a-45dd-9821-08df1e11deb5
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|1800799024|376014|366016|7416014|11063799006|56012099006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 LShwBQyPWzLYVN33P9ApcTw0CQ/vof285S9nnl4LxnHT/Xif/M9n4Fi6E2K5UXoilt0QiSJ0GbzAyCIGbpj9C3cjoPPeSgNqBki0zn1Trj1Bq3db/63H7oRAYBTvtFVLrYxaQlxPwog1QoMa5vWRji6pumZZNYCRLL+NvURlBOZizxxDeRe3k3JY3a9Rgps41ULXHvVtM+YFYjiYpoNt5ZIrP40RIfVmQSe4jgpnTHUb6QTTJp3utsrT7KuZ4bIEWVr2VgWluUvJp+0yG3E52nMZqvKUvZIhu8EEnPv7x0g2hnkDAfChK+AgUU+dqFC6gokgxnlyjhKjewRtYYh73XIFFRWrlfpsgoYiq+oVHxy+kUSmQuu7NBzBU+EMHgoNDg5r4WCl4GpXsX5hJfP7Io1+10NDoN6lyV8p2+24fO2T5/sz0HITD/vuilb0yvQRXbkhdJJW5Gst6j4Q1aDilG1zmzn0UER9N82C5v8unEyBi9VV0h6rLip/a4OdPZvIfP/piAjyzSb8Di6dF1c1ipCokxqD/35sjXEk15V+8hTD2jSFf0M5jDvS04EK7h5MtetRmREi832Drc88myMYahVeXdztOFURqHniE9GTyABP2O/1gq9RpCgaZbTwL0gyWLs8rr647lFox1p5k4oAxgXGXRDjNn7OlEMtruKjIu0tgEvMQfFf3ZvtbEFHEA8V20ydBeaN5pl1llaOv26PRw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(1800799024)(376014)(366016)(7416014)(11063799006)(56012099006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?K2IrQ0ZabzRnWklJdVB3NDNOdmhXd1JQYVMvcDJFREVFczd2SXBnbG51dmVV?=
 =?utf-8?B?OGVmVm1JL0s1ckMyeDl5L2RCV2kxWGQrN2ZDMUxuZDYwbzdSaXdpK25WSU85?=
 =?utf-8?B?YjJ0aGgwNUZaTlh0NllnL2pQOFJPTTNqcGhkbDNuZERzcmw0dzJiYWZUSjVo?=
 =?utf-8?B?bENmRFBFMlNoNlhRZGw3WFVYNUlkUVNqblhOWm15ZHA3cm85MjhiQ0NuTHk4?=
 =?utf-8?B?Umc0T0xMSFYrQm80OTQzM0pMSTJxV0FGb0cxS2xIeVVlUWlEZnpDQWo4ZUxk?=
 =?utf-8?B?VGliZnQ2Q2srVEpZT3ZVdDRncXd6L2tLQWlUWG5XS2xYd2ZjYkVqUmVXQS9F?=
 =?utf-8?B?dndZZlBMeVA4V0laNWFNeXhPMENZN3hTeVU4ZDBLZThNd0lLSWdtaEU3Zkh2?=
 =?utf-8?B?aEdZVnUxK0RNVzlNdHZONHRUUjl0MW5wUll6eE1GbkFHdHVwWG1NZHg3Q2Yy?=
 =?utf-8?B?dEVmOTVaNFB6NENoUys3dDFqL29laVBlM2t2MzFqYld4VjZNTWdOUnp0Zit0?=
 =?utf-8?B?d2czMVNFcUI3QzE0SW55TFZ5RzhBOS82bmNQUFJUdWx2NDRMYk5wRWxlS2xw?=
 =?utf-8?B?RTh4aFByYVl4YzVISlVtL1dpMWFKTVV6ekZENFBaTk91cG5wQ09rTXVWdmM3?=
 =?utf-8?B?cld6UzJ3bkJmWnA3cExET1cyWDhyaU03RS80YURKZVZZbTYrd296NHczTC9o?=
 =?utf-8?B?bVAwMndZYUo3QjdMK2JiRjJXRnUwM1puUzIvOHlETTFRZkFhQ2Fxa1U4VzQr?=
 =?utf-8?B?ZHEyYTh2V3k4NjlxTkZaNnA0UUUya25sTTRONzZLS053RlZDY3phdmhFOHVm?=
 =?utf-8?B?QWdTZVgzY0U0WnVEY01vMUdKdnpuRm5wNHdCZnEwL1oxN0VEN05OaDhPVER1?=
 =?utf-8?B?bEdZdG1FaGtMaUhuUVRSbkxselF0UFgrMTBrM1dpRUVtdE1jYWp4aloxQVIx?=
 =?utf-8?B?UVk0a01JWXhZcFg3ckVxZTUrY3VDRWtYZDBNRkl4RUhkWk1UK3ZWaTY4bVZO?=
 =?utf-8?B?eDh5c3BIc0hTK2FraXVyeW9jZk12ZVB0SGNoNnBFTnEwWmVUQ1orV3BhZGFt?=
 =?utf-8?B?Umo5eVZ5OCsySmJ2L1NrSUtmaHNhZHNzMis4Z1N5R2lQY1MyZTI2WWhNV0gr?=
 =?utf-8?B?MEtjdXNxRTVRaExnMGpoT3dUK1V5SFN0YjBUVkJkdEJEWWRvM3hsQWtOcTZh?=
 =?utf-8?B?WlEwUXZSZ2M2N0Z3cno3VEJFbUNPYUM0SGlOSHNncU9tcEE5T1NKQjJkbTBi?=
 =?utf-8?B?cDRXMEhXS0NqR1FEekVaT3JiZlJmK05ZNjIrNmIvSGVQaHF5bGhWbXhCbUdv?=
 =?utf-8?B?N2g0aXpJR014ZXpmZWxsQXk3d2U1dDJScmgzWjVjNFBpdlFoR2JqdXRsRjNy?=
 =?utf-8?B?bzlUcTBjZGdBVnBSSWduSE5VeWhNNmFVY1dsY2tHVGh0Q1FlK3RwKzdwdWpo?=
 =?utf-8?B?amdpQVROSGw5dGt1UlBMdFZFeVlUQkh3YVlzK2xMME5sdEI2aytsdjBrK0R1?=
 =?utf-8?B?dTN2b3hKVnJKRmJHRXM4Vm9BWlE1Y3RmZ1RsdWVwZ1RPdjNqQnF1dm96b3M5?=
 =?utf-8?B?bnQrRU8yc21lbnV6Vy8wY2x0RUVLTnZtS1Vtd25tNjdaYTkrT0c3RkE2N1o5?=
 =?utf-8?B?aWtGK2dFZ3ZXK0hjVjN5UkZQcllmNmh2RGxiN3pxSkRpdzBuRENMMnJpMDd4?=
 =?utf-8?B?cXNRL0VaSWpqZ0FwOTR3N3lMbWtvMTZmdk9lUGxvaUc1dFJNTXI2N0lqWFVm?=
 =?utf-8?B?QkRYZGh3YlBmQTJ1WVRmQUxVS3hhdExucjFFSzlaU21BQlZaWTBMSVF2bVhr?=
 =?utf-8?B?Z2Q5dVZYV0F6d0FZamthbytrbUl0YVJRTGdXRWw4aThTS2JqZXhhQXo5bHp2?=
 =?utf-8?B?dk9PYWJKQlJOM3VIYmc5NUp3VkRLbXFkOVdJa1FDRGR0WGZXZDBCNjkrRGV6?=
 =?utf-8?B?SS9YTzgySTJDNzVjUStjeDh1eDdZNFNYU09jaXA1T1NCUGlrNG14Rkl3WGNp?=
 =?utf-8?B?Z3BUazBmOFlNNFY0NURxNmY5T1BWb1RMUThQSngzRU1DcTVXbTNnTTBoOTZH?=
 =?utf-8?B?ZGpVNE8wenRDL1pVblNYT21raFVWTGRUVzlNZld3a3VDNHJwbHUwcjhlZHJG?=
 =?utf-8?B?VndBNUkwdkE3Vyt2N0IrOE5nTm9JZXRROFRhZjZxL3BadE81VllLUHozQ3VU?=
 =?utf-8?B?WmJFS3E1T1FJY3cwRUtDK2RZOGpheHRxZldVRm5neVViZGF0Z0ZnT1dNZHgx?=
 =?utf-8?B?NHlVdUI1b253RXlSSTVsenFYdWYvQk1nSGVtc3hmcVM3TW5uVUJGRG1aTW1h?=
 =?utf-8?B?eWVEL2ZuTitPRG5BYTBXNTJTQUYvVVNEUktRVWJCcVBnWnJDT2Fsdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c36bed-fa6a-45dd-9821-08df1e11deb5
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 10:10:21.0444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORfcQK6Dk9WIezhQ3UBdrA1iPL0Rjj4kjDMPnAyzb7AT255KoA6+mwoOhErCUqzGr3O7Rj4TIIFBcL0U5WxD+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB888289

Enable the UFS host controller on the S32N79 RDB and configure it for
two lanes per direction.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
index 1feccd61258e..38c5699e6d54 100644
--- a/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/s32n79-rdb.dts
@@ -63,6 +63,11 @@ &uart7 {
 	status = "okay";
 };
 
+&ufshc {
+	lanes-per-direction = <2>;
+	status = "okay";
+};
+
 &usdhc0 {
 	disable-wp;
 	no-sdio;
-- 
2.43.0

