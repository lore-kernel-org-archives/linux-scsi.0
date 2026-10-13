Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010054.outbound.protection.outlook.com [52.101.84.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D951D3F54A0;
	Tue, 13 Oct 2026 10:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887415; cv=fail; b=FueteeTpEzutkyPmN0G5dPPWYlsm0JIZbe7wxuSU6+nscXUChKDkw8rfWf9ryiKBch/uyYnGX6HE73v8zAW8OEZCSL+htzBWswfkGgzYzquskub8zywZjRxKVS/LnqDiGDO1gZ6izX6P99qU+EzMkv0wm8sAEdjYqlduECswL+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887415; c=relaxed/simple;
	bh=6Q64KVqjsqbs4QeaHKGZ9Ei5GT2onhng9zfNeJ5Cy6I=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GMIr0x+Gko80EYPWQ3i39mAULBKIq7q9S03rO9WCalMWC6nzLxqzI9kEJVbNZatfgxdr6Xo4jALl5GCUN+z0VUc2HWLK6rtUbJsYg2TaESkO8uyXUOTaczU0jw0HXfMnU4kZQMNoX/5rv90XRJ2wktllk9PzmMHyFWpasTdDi0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=JTeB8Le3; arc=fail smtp.client-ip=52.101.84.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="JTeB8Le3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yu3Y8Dm+QPzPMlO/oIU7TvbrL9c4PDW8PzmmulTwYFRjdfypifHVmglbSaEbhYcunVWxBIbbVtELDoo1rjtJBiwRFbOAa3oNNvDzBq0/Tig4xbRuWKFwjW6kAlaT6Lt13+VLhKtiARVzBmzICgvVQBTPB46W9Qz9qrec4tQDtBagljQ5WJg0uvKYoqMjmd6IxzRIrzh5olkpIm5jJ8DVv7nciWtWuHM/d7yXzQ9PKBtQ/qmqSppCIID9Hp00xf3W2cJi3WZ04YeGL1Eb2I29U6Bm64ExoKY67913tYNc+k4RNkM27Qzd1mR6FfNCM2v4Hk79u3j4yf0+4zwyGFTvGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V2VJkcLc2BY1WSRgqQyMolIjV8SghbN3YU6wP89S2gU=;
 b=F7b0y3h8BWgRChio4ab1o8Wh+mljBbGwzXvMqhcF0lDYIRvRrrAFpnZb+/lX6nkAkUs9mHTuTWqwqkvGpzmRLHmJfimrOZco0LR07b0roa3nys1OzPgSQiMuUvURJsvfs6M50FF/uMnfgWnGc47dg1b0Sz4D1ZrR2IMcqj6Qc3JI72ZtUkDFDZbVsF+o9WWWBX0t1ESB1qAixulzwNgJbKeOdv7CZGyEUJP0taHOLmlzma/Al/lsil5DZb9WARMzuSiTQYsoA3JMgXEz3Gu0+6NXilDGPNHbE0Xw8fAA1il5+K72wFKyo4Fcq/Snq5cG224QdD/XffUgusKEoHfIpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2VJkcLc2BY1WSRgqQyMolIjV8SghbN3YU6wP89S2gU=;
 b=JTeB8Le3G30qFkfXdYxG/saoDrXdvFcjFfe48khfvIiz0+T0WDK3fmGxGaFa+VIpCb6lsifYMCRvHPbp/WKycpE3pOrW1PDIu9Ok7HFTqg0Kdet/o4rtYVTXj18VQg9yt/EPMdGwFrC3JgS/rstxbU02uxdAX6otgUBA1d+yZeOKIMifjSUyJkeqU6UgOV1KJnnRjaXeMRyGdf8pEGUktuh6tulDZwhjVNZ5qPbcOiPfegUrpK+nSUjeWtw2BF7kOSLjweRSPhkmXXuEDgshBgN/vNcdTZUjVfp5LL7GGIbC9pwxOO300lxI2tucxu0hc3xZ7k+LOawTJ88a4+O65A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by VI1PR04MB7133.eurprd04.prod.outlook.com
 (2603:10a6:800:126::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 10:30:06 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0496.021; Tue, 13 Oct 2026
 10:30:06 +0000
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
Subject: [PATCH v8 00/12] Add S32N79RDB UFS support
Date: Tue, 13 Oct 2026 12:29:51 +0200
Message-ID: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::16) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|VI1PR04MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e853be1-b7d7-4833-f398-08df2914f32f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|23010399003|7416014|1800799024|376014|366016|6133799003|10067099003|18002099003|3023799007|921020|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 FLCLvBhXW1oZuRssX1/mQfm0pJOInFmGmYT36Sd0st62KyTUALQ35tUGKWFApdSTfyyExv7LeDGRQTUYGcAi3Gi4voUgD7CodJMyAEcLKKzsH75Z7iOYO1NpzT1yvlDWfDPvdfZwIxfdXBr1QEmg7xAf20s9UkmnzVSdUi09VwbFWZgye9aCxmae80OC/YE50bBrxnlUdGpWhQWrMJ9gqfynBAdbcvMhNCMcVGpUIpjZv/VoiOyd54EmjPElYXm5Qo3yWZ1a+NDMwOniwIIRZ5uvrokl308YAKU9iG/W/dkF97fDAejZvncTQNDkaPoSA0ZdWi4LDFAKZQKLljnrhLc+IyLEr6zUFZDZFzD7lVE3urpdGeHvotyA+FzDtOpXi+rRsxpLZJkX37itCc+to7phNKl++RGHKeYGQ0Zdz/OpSDSJvK4PTlawpq57RNBn+jm7GnQWcIMS7O/2YBc1oJOk+to+HltS1vpTlE9czhQR85q8ImJlddfsM6svMT4DUR44MvwQzQv4/educP+lPVqdDKj4LXH/1v0lMMIpVJIJTZHxqcP5wMLy8n5ycfujywCvKN1Q+uwX58uey7r/meAxVsxgHc+2+HlOKXW1CKLj98EyZNS7PLVbdct22B2+7BTA6hJId9DYlALfglksdE/nBm9mHvpfPSB9bkmMXMDnW5Hwtuyeo88hoHdJOIVC+DhileXlk/mY3BOJ4LWvQg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(7416014)(1800799024)(376014)(366016)(6133799003)(10067099003)(18002099003)(3023799007)(921020)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TGRJSnlpTmxXdjFQQ3A5VFJ1ZkFJSllDOWdXd0lRU3liQXpIYzlNcE1wVkEz?=
 =?utf-8?B?MnpqN1R1Njd1Yy9zdTJTQytocURKY3VBTkdFU1Bpa2FNVkNRMjlGZWw1MElU?=
 =?utf-8?B?WHFzSkJ3Umw5d21KNUw2NldUNzJUSU9heFQ2dk9MTFUzQkVMR1JpMGY2S0I3?=
 =?utf-8?B?YVRuVEptck8yazlCQ3hwMUJUdlZYdEVFcEI2Rk1NemRCN0ZUd2JlQUhQNStj?=
 =?utf-8?B?bmRBN3pTWGEzWGtkOFF3UU4xbklXQmNwSzdYK3dEcUgydEJRM3RzS0YxZXBm?=
 =?utf-8?B?UTY3U3llUTNkMENROHpmKy82bzhMNHcvbmJrYk1UbStleXkzSENCYmFEb2hw?=
 =?utf-8?B?L3BlMlVZYmNPcmF3UVRNTWRHajJlaW5rK3oxZFoxWHNXVVFWTVBXQlRRWVpQ?=
 =?utf-8?B?U1N1UlR0VU9EeFlXdmErRE1GK2hqQUJlQWNpdTVYbXU5bG9oMFFUb1lKOWZ5?=
 =?utf-8?B?YldWZkYySmRreUlOVjBUNld5b1NSeS81ZWhhODVEVEpLSWs2VzA5VEsxa2Qy?=
 =?utf-8?B?dFF5dmRsbmQ5L3pGQ3h1cTN2TUxGNHJmTlIxQUZTRXVXQXlNd1JwR3lrdFFX?=
 =?utf-8?B?MytVQlpWZld6dlU0amxKb0V6d1dZcVgvRTJWcUpBYy83anRxRTdSMzBUZHJS?=
 =?utf-8?B?ODRtMTJ2T1FoOWRRTjVDL1hKdER2R3NXWDRtNldjRGsvcjlBbUx3ZW55dnk2?=
 =?utf-8?B?WXZWR3RoWDNjc2M5L1JTbjV0djk5UHcyMDAxSnJJTmRENDFaT202MWNjT2tQ?=
 =?utf-8?B?Q3M3N3JqeldPT05SdjRzYWZCa21Pck9NZmpnL0I5eXQ1RTduaHE1MkZnbU5B?=
 =?utf-8?B?bUVYMHB6YWFHOVMyZ2RadzlnZ1lLUkJzK3hSczFZb1BEWDNlbWxSaS8yY21w?=
 =?utf-8?B?clMxUDVBbVdBaGJPSFpEQVJ4YzVrU1A3S2U0R0VhclBKdWdhdW5LaW1NQ2Rq?=
 =?utf-8?B?cC8ydHpDYXdaUC9SSDR4SFAwSEZZWW5lY2E4dWcwWGRORkRHNkp0SzNEMC9C?=
 =?utf-8?B?aUQ1alpFU1NhS3NnS2lCUUNUT3ZQcU13R28rUitqSHBtODZoa2doczM4UmVL?=
 =?utf-8?B?Zkp6bHJsRVlNWHZTemE0dXhDR2hjbEE3NHBhRUo3VGwybGRmUXl2eitBSzVS?=
 =?utf-8?B?SHlQREt5SklEdFlwczFheEhsQkJLR3pWYlcrSGo0L2kzK2ZyVHZ2M0hXcU01?=
 =?utf-8?B?M1NXRmZNeXprcU1wUXZCQUpnSzJQc0N0WUxka1hmNjVHdWlJNDhQbmhjT2NI?=
 =?utf-8?B?dzU4VktoMkdpcXF5Rm9nVzNVeGZSRFgrSVlkNko1NnFtWkRwZnI4RkdBTW1N?=
 =?utf-8?B?SEhuV3ovdEpUL0Q5V09kcTJUL3RhamZXR1NVdVVpelJMdWplblF5SXB3a3hD?=
 =?utf-8?B?Y0tPUlZXTWovc3RCU2swOGJlQThza3JhRjA5ZlgxWTAxa1pDeFVKQXBMUWJn?=
 =?utf-8?B?T1JzK1REL2cySEVPMENkK1JrWTVZcUJUSGFpWVg1RGFjYTlJZStkMzk2Rlpy?=
 =?utf-8?B?VHRmd3YwZUtKNjcvN1JuRXhaTURocXQ4MktKYU9hWFBnRFpIU2lvRE9EeGhh?=
 =?utf-8?B?RytIRlJLYWM2L0lXZVZnbFJZcXJBTFpsR3pUUENQQlBoMS84Ty9PZk1Ha1Zv?=
 =?utf-8?B?YzBSMnBuU2YzQzlRbkFTVHQvengyZXJDK0lQL2xZNGJjVDVBdzltUWNrWTBh?=
 =?utf-8?B?NCs0L0V0Wm0zTkJCNTFTVUJjc0hnWk9yZHNDQTBYcXBSUDR3VmRBY0NOUWtJ?=
 =?utf-8?B?MDRVdXZPb1UwRXlLNzRQc3FZc2JoSFI5UHBPbzBXTFVXZGtpS3p1dVZTblpy?=
 =?utf-8?B?Wk5oclZTT3NNaHNWVlJGUmRSV3pIeGlBdWg5dGhjaGtiM09abjZQUmUwZ1k2?=
 =?utf-8?B?NXR5MUZGdVdSNzdmZEZtVk83b3ViV2RDM3pwbG0zZklDYlVPc1VseEFRWkl5?=
 =?utf-8?B?Wm9yd05YUUE3NThKZktsanFmSlQrcDZGZ0hKcGV2SzRSaEdMRCtPNHRjT2dC?=
 =?utf-8?B?RHpENDVXcWEyY1VicnpGTGxpSmpVZW5VNXBsQ2IxZ2ZSb3k3cmx3TzRLNXhw?=
 =?utf-8?B?d2IrcjZ3dkg4L1lFWi9uWXdZSnU3MVpFRk9kMitIdXQwRXBKWHpodnFCbWJn?=
 =?utf-8?B?eDhoVklMVnFMM2Z3MWpkSFhkQWZ6RU1QRW1hUGgvZ09nekk1WUtsZkZLSTlh?=
 =?utf-8?B?TUdONENUaHNsbitQT3ZVTWU4N09CWHk3UDBXNDA5OVhJTFU2VUs4U0QxM1Bz?=
 =?utf-8?B?QUVyZTR0YUE0SVZGcGJDTGRnaDkrZitPSWtQZWZ3aXpoeVlaK3RydlhsNGFY?=
 =?utf-8?B?amIxMmd2blJCVkZRaC81VUJ3dDVCaWdUeThnKzJLTGFja0ZiYzNSUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e853be1-b7d7-4833-f398-08df2914f32f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:30:06.7115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kjzlNC5AQjYzijlWDRRw/E8OXnsknqDBMYpNiXcwjpoGmjJEuq2123/hWsTCPwLEQvPKb9g6+q+Lw7LOshpoIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7133

This series adds support for the UFS host controller found on the NXP S32N79
platform. The controller is based on the Synopsys DesignWare (DWC) UFS host
architecture and requires S32N79-specific M-PHY initialization/calibration
sequence. It is compliant with JESD-223D "Universal Flash Storage Host
Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. It is
compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is compliant with
"MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M-PHY is
compliant to version 4.1.

In order to keep the S32N79 platform driver small and avoid duplicating common
DWC code across platform glue drivers, the series also refactors and exports a
few reusable DWC helpers. In particular, M-PHY CREG (CBCREG*) register access
helpers are moved from the existing AMD Versal2 glue driver into the common
ufshcd-dwc layer, and are then used by the platform drivers. The series also
introduces a generic Hibern8 TX-FSM polling helper so that multiple platforms
can reuse the same pre-link checks.

Device tree binding documentation for the S32N79 UFS controller is included,
along with SoC and board DTS updates to instantiate and enable the controller.

Changes in v8:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Added Reviewed-by: Stanley Jhu.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Let the UFS core manage the core reference clock: declare it in DT via
  clock-names/operating-points-v2 so the core adds it to hba->clk_list_head
  and gates it across system suspend and runtime idle. Dropped the manual
  devm_clk_get_enabled() and the struct s32n7_ufs core_clk member, and now
  read the clock rate from the core clock list.
- Dropped the ufs_s32n7_calculate_us_tick() wrapper and inlined the division.
- Dropped the unused struct s32n7_ufs hba member.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added the required clock-names and operating-points-v2 properties.
- Dropped the Reviewed-by and Acked-by tags.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Added clock-names = "core" and an operating-points-v2 table with
  opp-hz = <0> (fixed-rate clock) so the UFS core manages (and gates) the
  core reference clock.

Changes in v7:

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Wrapped .prepare/.complete in pm_sleep_ptr() instead of pm_ptr().
- Fixed code alignment issues.

Changes in v6:

scsi: ufs: dwc: Return a negative error if the link is down:
- Translate a positive UIC command result from ufshcd_dme_get() into -EIO.
- Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- Added Reviewed-by: Frank Li.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Added Reviewed-by: Frank Li.

Changes in v5:

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- New patch. Split the macro reorder into its own cleanup.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Return the real poller error on timeout, not a forced -ETIMEDOUT.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.
- Removed the select: block and the clocks description.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Documented the timeout values as driver-defined bounds.
- Wrapped .prepare/.complete in pm_ptr().

arm64: dts: freescale: s32n79: Add UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.

Changes in v4:

scsi: ufs: dwc: Return a negative error if the link is down:
- New patch. ufshcd_dwc_link_is_up() now returns a negative errno on failure
  instead of a positive value.

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Refactored ufshcd_dme_check_tx_hibern8() to use read_poll_timeout().

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

Changes in v3:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use -EAGAIN while polling and only normalize to -ETIMEDOUT on timeout, so
  real attribute-read errors are returned instead of masked.
- Drop the stray delay.h include in ufshcd-pltfrm.c; the helper lives in
  ufshcd.c.
- Drop the now-redundant dev_err() after the check in the HiSilicon driver.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Use devm_clk_get_enabled() to enable the core reference clock.
- Rename the family-level identifiers from the s32n_ prefix to s32n7_
  (structs and functions), keeping the s32n79_ prefix only for the
  chip-specific data.

Changes in v2:

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
- Improved the enum comments. They now cite the MIPI M-PHY v6.0 tables.

ufs: unipro: Add TX/RX FSM state attributes:
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Moved the helper into the UFS core (ufshcd.c).
- Split out an inner per-lane poller, ufshcd_poll_tx_hibern8_lanes().
- Expanded the commit message to document the -ETIMEDOUT normalization done
  when converting the qcom/hisi checks to the helper. No code behaviour change.

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Made the DME attribute arrays const. They are now initialized inline instead
  of by later field assignments.

scsi: ufs: dwc: Export common clock divider and link status helpers:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Renamed the patch subject and simplified the commit message.
- Renamed the binding file to nxp,s32n79-ufshc.yaml so it matches the
  nxp,s32n79-ufshc compatible string.
- Removed the nxp,mphy-boot-mode property.
- Made reg-names and clocks required.
- Removed the conditional if/then/else schema.
- Removed clock-names.
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Updated the example clocks to <&clks 0x92>.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Removed the nxp,mphy-boot-mode handling and the mphy_boot_mode enum. The
  M-PHY firmware always runs from ROM now.
- Added a struct s32n_soc_data for SoC match data.
- Moved the calibration writes out to static const tables.
- Renamed struct phy_reg_cfg to s32n_phy_reg.
- Moved the rate-select sequence out of link_startup_post_change() into a new
  pwr_change_notify() pre-change path.
- Used devm_clk_get(dev, NULL) and dropped the redundant core_clk NULL check.
- Switched to *_PM_OPS() macros and pm_ptr() for the PM ops.
- Clarified the Hibern8 poll timeout comment.
- Enabled Auto-Hibern8 instead of setting UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8.
- Reworked and improved the M-PHY initialization sequence.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Removed clock-names.

arm64: dts: freescale: s32n79-rdb: Enable UFS:
- Removed the nxp,mphy-boot-mode property.

Larisa Grigore (12):
  scsi: ufs: dwc: Return a negative error if the link is down
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  arm64: dts: freescale: s32n79: Add UFS host controller
  arm64: dts: freescale: s32n79-rdb: Enable UFS
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  65 +++
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts  |   5 +
 arch/arm64/boot/dts/freescale/s32n79.dtsi     |  24 +
 drivers/ufs/core/ufshcd.c                     |  73 +++
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +--
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 540 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  86 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   3 +
 include/ufs/unipro.h                          |  22 +
 18 files changed, 875 insertions(+), 196 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

