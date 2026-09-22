Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010045.outbound.protection.outlook.com [52.101.84.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D984E4C4C;
	Tue, 22 Sep 2026 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062458; cv=fail; b=Fqpd9NsvJnyiBzMxBixRreuCnm9tWo1mTP3WQZIZBIjVJ+itK4RD6UaaQuvpJ0Zpe7UFztwFTV/z357JilWHpk8Y3aGlJph0OR0XIttLyGt9X/e9cz/vsdwiuE7/YBBo+hVEQWd4PCBYgobvPOfty37wgzXu1WRX2y2C0WIXjAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062458; c=relaxed/simple;
	bh=SlPckDvgmCgHI3K96wXmE3PZMKP1GnJCHi/dHGpHhM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ncDvU037tO6V6szi3ehYHLedlFaJtg60aBPmwyqCHd771vGfzK14eed/EYi4RncEpMepI6KF/BMMTSDcFtJaz0M4Ep/P4XqQdUqlzgTfuLD2/2MO/e73PLNEPQlg9mIzqv5r1Ts4fRQK+Vd7w+tnvI3o5oVPEO/J2smVRpkeR0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pKQT263M; arc=fail smtp.client-ip=52.101.84.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pKQT263M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnbQmgw3XHsKN3rGTfR4Cr4e71NnMYcU4mnMLBThLwDB/2nmgCQCFHnA7YT+Ux2jqqBFxU3ufhQ4uWQ4mSZqCB3SSagFVIrg1lglRzxe1kjycIF+bK5puEoPx8n9hw/ZYTnKo1cInWLuadEnjo4MINK9MuqZQIuRmq7xz85age5s9HMo+IM/4Z7i3mYRjq1MSpLCocA7C8fF6ifBNZ/g+vR+iv8yAbydKtUxXGhurjE+bpdCYrIvGxC3L2+Zijk/7rnIs1g5e2LrdC6YUBSDSOjqAoqCvz3xmos7szE6i0WOogE7sL6FiKEFfV8xVhQeCfliruitG81yraPkVT3zVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=Rpoye0rUQjxI+PxA476NypYWWZOsclnEe3LgMMkNEMtV4YFzE9lS4cHbYcQzmkVGVYXKUUOsI8dVPIBisvkG+AJDb74c9HZUlobIdyXwgkR4b0BdVr2EUDARipuSRQynj2WbrJNG4UqYC7EPRw0ue42f/ldicyc2jsJzY30599IXWTo3CzjmMoViUqklKsgAOfbq/dxuUgov45gw3I91AkX8bozKvdRGc1v58wrFgxhZa2KR7MgKL+6ggh77IxdJSRjuscASRo2VjVtgBfTXIXTXc1eA8bLJt7eSnAC/c6BwCM0MwZ/BTokIGnNh09UuOg2GfHNjC9UMjF2GLKQAmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UOWV9fRxUwt8l0WY2hoefG5eR2DygWkQFZDWhOqVZ0=;
 b=pKQT263MUISVJlqnA3EiHdXBXtZbgBe0sfgeJA0l4iENCmtR0YxgXDasScmmf0F0wWx8jYhG4Y5rAnN2zsRz//rrXwnS2EZe2LA7kVlyGLqyXPKZExHjSRcgBSfpy5u0QiwR9gXZM9/ZDFw5pPBwr7LI8oDd3vGE+PJJ16wFy28p770AbgeS1Ut4H5PyLqcuIt7mhRLNb6cVjaF6epWZbYH00dfm133CiNGQZIkIrqJxSPqgF/Gt1Njo6Vt6Q5QW2dC7l9kHsDd8XDWKLql44D7OwxYKOO12lvsGN8GBJr2TJM/UTqNPt92fMsbqH+5iOeHfljnf6srXoz6otTgBiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by MMZPR04MB213195.eurprd04.prod.outlook.com
 (2603:10a6:190:4f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 07:33:34 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 07:33:34 +0000
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
Subject: [PATCH v5 11/12] arm64: dts: freescale: s32n79-rdb: Enable UFS
Date: Tue, 22 Sep 2026 09:30:08 +0200
Message-ID: <20260922073009.1449688-12-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0P309CA0030.EURP309.PROD.OUTLOOK.COM
 (2603:10a6:20b:28f::32) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 10d85a8e-5dee-4182-061f-08df187bcef4
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 j3bQwdG9a7ZsS3vwSEoS1ILiygp9NbIPbO444YgyfN8dcJIaIM5qQsZQsTBAWMWIJGXGkBIjxcV8e2smFKhr7cB+AO8osw/8sWoT+jBZ2Zvgn7dL660KkdZ6uO0fRlLBnfdVcvCAgOpBrx+mqQwnHLXDPHmHjbVqA7yPWEmI+zp1j3573l9NHeU7M4fsCpCWc9/5+/WRAPxmSIku+rbVXUbSTQdR9f29HU44Zo0yoXW0ss7USC31Up9VQreh0To/av+fd5uSyUhMfXjKk825w8toDhddp4SsVuadXWRR/x1IbFZdEphymd6G1374AqtLICx4MS/e/lIboAUFlOS8Q49aaLalJDhiOt0TyBTqg7jiNuP7V7pASaDEaYSYV/eHSBw3LePDzYXuF0K7uZW9Ph7GEsjJluGLl9a2jG5vxVDStUyTfRTKUQLzakhCwwfPWLID86v8Kn/vw1HEk+bgyf9jluLnLWrZAguldnLezJOkRhiFr3lVPZs8N1lX1aXEbGtk+MOs1yxJe8gEVRswJi6m6bf6tvigOgYdrSrp9UJofM0P5KnVjsgaRKPd1rFphBgTimc5EleP0/W5dwssqXbsiC0j4loj73R1nCxsW9lu3Ofv0B0NzvEZ+jbgexDSLPZZRu5M7+pHWKdqygYGuDss+f4ELbobXNe6b9nfvsA6YzxdvHGVej+UuJLDFZwXCrnt+saaplhuml7/0QmyOQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?c0VkRlVZWUJ1cEJkeE9kWDFHUXNtVW9TR2NCa3Q5UjdDSFhEUHloTzdSb2hG?=
 =?utf-8?B?bHBzQStUOUFFcHB0bFNnRVFUNlZudHoydUM5MnBFaHEwYi9XUnlnL2tGU3Zm?=
 =?utf-8?B?UEkrb2JuTTN0QXJ2SDU5YzZHbTV4QzRERGJ1L0RLbkh5cUR2bGpla3Y3bXdB?=
 =?utf-8?B?RUxRNlRmSzkwVC85N0FmT3EzVGozZVFsei9uYzhDVjkxQjd5U3lyLzN6Ny9D?=
 =?utf-8?B?dE8xdGtDZWhtK09VaVFNTlRRZEJhVWlEanRZbFUyS2N3czVxeUZidDdQVGxX?=
 =?utf-8?B?dnFkMnhybmM3eThjdkQ3SGxOUDk3bnNJazJWYXBxL3BqUnVCU1pQZCs5cXBO?=
 =?utf-8?B?SUlVYWNWd3hxNHZzZVV5OENhWFFnOWphNUh1aFlGaDlXYUorQlg3ZFZRMmJW?=
 =?utf-8?B?VURMeGg5VG93Z3pQTHFlVG0xRWJVSVZlSml3UytrSFIyVlRya0w0dnlXR21J?=
 =?utf-8?B?VUZEZ1Z6eElISitVTWsvNHNhV0xNcWMxVEh6eFlvWE1sbUl3dUV2Sm5zK0FI?=
 =?utf-8?B?emNYNWZiditnQ3FEOXJ0S0R1UXFLTllYTk91LzJTUUphMWJFQWlkR3RPUjlK?=
 =?utf-8?B?SjFiQmw4bkFmQWVNS0oyU0k4WWtVcnFlNG53dlMvZmxRbnYra3J5ekFHQUlC?=
 =?utf-8?B?clZtaGUvOFFUUEdrQkZ5UkUrMWNheCtrYWZGb0xiRzZWU2k1QXJjSU5aOEpC?=
 =?utf-8?B?eXFsd05ZQXgwZjRsVDZaOUx4OGZZdzBWMjBaSWdyTXBGdXBoTDl2TWJQVUgw?=
 =?utf-8?B?akFVSGFMOXA0YllmLzBIRWhxY3d2c0FTSjVsbVFNcGhhR1pWejF1NzZmc2lp?=
 =?utf-8?B?UHdqMGZnN1RUaGkrcHVwUEIrcW1wY1U5dWtrVDVNWit6WW9MVHh5WUpJUSt3?=
 =?utf-8?B?MFJ3UFVtWDBMWmt4eXBxRG1oRGdublpKa2Z4c3dyc1ZWYXc0V1VKVUVFVTRh?=
 =?utf-8?B?UFBQaDhPelJ2RkpiTEhPV0kzRDN3R2J0TXp3WGU3WTFHbUkrelQ3NGVkaDR6?=
 =?utf-8?B?c0Z4RnBSQVRlaXFrUml3aEFZV2NsM2pXZ3FKWWhlWElvS0dHTGpiaTBSMlpa?=
 =?utf-8?B?UUFaL0FQWlNFZDVpUUNQM1l2UlZDS2gwSXZtRzAzZWNEV0pXK0lOT2h3UFpB?=
 =?utf-8?B?eXBUZCttZzVxTjd4QlpsV210T1R0ck5jeWlma2xSQ3BpZUhyTEp5bzM0NGhI?=
 =?utf-8?B?OWVkVU5jbjJ2YS9HcTcwM2hHeWp0UnFlVXY4SHJrS1grZm5BbXVIMCtpem04?=
 =?utf-8?B?WDJtWkhXOHMzcGlNNmwrM1k2QzNtWlNvUFFZOTc2T0NiMDE3L3BSSm8wNXRl?=
 =?utf-8?B?OGhGYkg1VVUyUEMvRFNMNEwyMlZqajR1bWxMRWY4OS9iZVJBR1lGZW5TdndC?=
 =?utf-8?B?bUlnK1JGeTZ5Mm1CUEsyZGVPNWUzQTI4RGlRL3BYVUpYMTllVEFNNGFzMWFK?=
 =?utf-8?B?VFRQNDVBWkJRKzd3bVhYeWVqYzZlMkM5emduVk9IZTQ1S0swTHcwRkxmcm1p?=
 =?utf-8?B?N2V0ZFlvWE5vaStTeE5aUmNYVHJFSUJINEJjVW5VNk9oSUlGWEFHeXRYdHRR?=
 =?utf-8?B?RHJLR0FoMkk0MEF6ZjV0aVJhbmNmQWJxVUJrdmxzakhsQmpNdE4wYUJtVjZM?=
 =?utf-8?B?TG0zaGFrQitxS2dqVisxejdHR2w5OHpvUXdLQjJHOHBXMlpHTm5KTXBQdjVs?=
 =?utf-8?B?K1JIOGhQMFJmNDQ0TVkzUFFOTGZhUmIvREFFbWxqOXF4UHFRVTdQajJ6ZVJR?=
 =?utf-8?B?R0dROGRDZVBsS0VTU2dLcVd1VHBXVGlOMkFqZzFESDNhbnp3ditNTUJhRElM?=
 =?utf-8?B?VXlCUWlNSXhlU1dqNlgwWHFnRE15STV1bmkzaGV2ZWRMRGRQK0doMndQNVJ2?=
 =?utf-8?B?V0wvbnFTYWZBUVRKV1gvaGdCa3BMNDd6dTl5WlBVMTBGelRXUytKOFBSVHBY?=
 =?utf-8?B?bGY4Qkxvb0NEVkpjRm9BSkdnZVZ1eHpPNVl2NnB2ZDFWVDNER25wV0orWnJR?=
 =?utf-8?B?M3R1UFFhcVRzZUpabjJ0WFlSQWJxcEthU29RcElDNUNSWFhSRFdaTUEyVXpK?=
 =?utf-8?B?MHVMNzdkL1Z0bmp4VmZYRUR2RkNyVkxOMlVHYUV3RkdLYjVCTjlqTDNPcllP?=
 =?utf-8?B?R29mcndLUUN4bFdlaUFzSjEyTHA0SnU1ZFBwa0NyU2FRSnk1SHloeWY1TzhK?=
 =?utf-8?B?eDVqZXY1ZEZ6ak1Kc25tQ1FTMzhGeTU2S2NoWVVPUTg0akZ4RDVzM3JpUldk?=
 =?utf-8?B?a2h2WE4zMklHQWdzcldwcmNaaUpPNHUrNDc5TFdRbklPcTgwclFXVHl2N3Jp?=
 =?utf-8?B?QzZ6dnUvQUovcDZJOGUwWFdOY29nOVM5KzJsTVJ0a1NNYU91ZG1hSW1iOVpB?=
 =?utf-8?Q?hFEf2XnLr1FhrfD4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d85a8e-5dee-4182-061f-08df187bcef4
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:33:34.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAL4ylW3OxLCGT/YomayG/RxR9eR1EvkJbqsfqJ6nJXvXFB35W0uR8rRnD9tlQP5CA9KGixeK5WCOL7s+nxV9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MMZPR04MB213195

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

