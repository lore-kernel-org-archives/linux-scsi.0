Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302BC4B0483;
	Thu, 17 Sep 2026 09:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636588; cv=fail; b=jEEhupukfDBBFFazXrkvJYvIKNmRFQc+fpSoTfEwBjCfySL+dWYZ0msYAtSsN3llXkpTUGxXOs1qt2swGsKFt4dbVhLaC3s7wzL1XEQT4jC/gdxGVBivHQsL4GS5+NNSzXR3iqQiVJwaCbsDcrYJN1i5BX80bdFUxg6yhZhzHwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636588; c=relaxed/simple;
	bh=pZ/RxeCSS+yGKCwyxaejW/gTmFqTnFiUah4zsBGqaK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l2ISNyLwlLTt/GBJAc+ooBj5dO9ZzlcAZunGvx8UjKy6CojV+lWZL7M8b3zlgThSSINEpHcAbA1wTDVNi3BGb3LuBaq29he7tazu8ig6U14Zt+E3u1NaLcPeMQI5vT28v1z0tz51ACvhYVm7IBvLUmxqKk8l26P51C+Ord1EckE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=K+Qvpn20; arc=fail smtp.client-ip=40.107.162.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="K+Qvpn20"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MhcgFy8o3yoxGCczFY3QlBSNqO0Cqo70XtjyV4F6gCgRvY8Wfdkv2Ltm+WrOmeYIPR8Bl7KfUkUiBcMrn3tCX8tOPXY/ngL/0I/ldIv0dSgKNdRG/D0z9qXkzWK2FbL6nO6tes7hp6S0ZdUDRqWnlPAHNBOarPEriGzWJmiGQxVYMl2k7XwfArbW8jg6CX3/LtAJjh3qxcwCHFp5MPViFESdpJaU9IPV+uhYiX7Wf2Vj7Vb6ZEu9KFqV8Bhn5x/N86vDOo3gDlhGE8yEnpySuPuk5RPgIU3J7zlPSiBwVxCVckH42Nj45zA6wPRCSk9AvWp4TwsWJt9JD4b8YTQCsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNHOWLjM2NWYs2V7TInUeViamiQcPDXKCJjXViB/JNQ=;
 b=SAGOf47wR3Hen70xB6HS6FijWGDXbac/XHqtuUBpev2/PJE6aniKp3joZ0dMMt4mBTTRH2cVWSz8/rGPD46S10wXFPCEpKZ0KBvIY4InTRhOEpkHy+GL0GjKPMOCK+MBAqdKIfiaceVSJchy2aV4c+fnaSw+SJXVeyFAi4wbfFZF563sqyHh680Q3dW73tuZ/ea2rh2HJW8EKIvj+bMaQK4BCXBEGcSvgSiAPu7WFiS5gEFbnTGDjs/D0gnG4yADpb0uOK1TScZL1OzV5cMFVhIwR768yHvLEsM3TbBcOwz3XhMmuEXUA/tmeighVeJRTkJ2X+G6fN9ewj6hmgGR/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNHOWLjM2NWYs2V7TInUeViamiQcPDXKCJjXViB/JNQ=;
 b=K+Qvpn207lS1m2Z+jCYFUxNuwRNsW8yYm8pwEYbIRB8alfzNOM5S0rFOzV6t2G9BFZpFZS+dfdHHNOvajawuZJZUFYOmxfZxrguZdHZBKLzhCw0FIulBA7OCwdCetgt5BPTe0ovTgweJk1F87orF2wwQxw3fryQRjVzhoh03ffodfjuCSVUO7msYpKlgXtnb7HJvjFs2hW67M3ia4wMsStOKmsVx0GVWKnqTuKYUSXWDcJs7JNAWU+XVQBwTQtnDNdLJUyTAE9VZT5WxKQp+FBh3IpujRyWzm2mClEWc5WltUR7yGLPrYWpYaQOUCuG6VAD+14rau9+cP3Mqc07saA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by PA4PR04MB7840.eurprd04.prod.outlook.com
 (2603:10a6:102:ce::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 09:16:15 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:16:15 +0000
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
	Pedro Sousa <pedrom.sousa@synopsys.com>
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
Subject: [PATCH v4 09/11] arm64: dts: freescale: s32n79: Add UFS host controller
Date: Thu, 17 Sep 2026 11:15:53 +0200
Message-ID: <20260917091555.1443076-10-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0167.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::34) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|PA4PR04MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 039b4692-bcc1-4e73-053f-08df149c5346
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|19092799006|376014|56012099006|11063799006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 NNICd242gsChVPupAv9TpVJmAVbn/bTdWxczquHR6fD3XATzQu8rbEChqimOmSAzinmNhRjP7JamPP+X1ZK9VSkbM5zXKeOu4whCzJfmAcmF7LA2AbAHfzGeYs7ce6gRzbi8mwuUfVG6G5BWdhrMgJ+POm7jLuO8fD4T1mIhAybikYouHoLNgtlGNH3bpSJB6FXP6P41OsPwIl3p4P7PvDwY2JGumEfZTeoltHV6Boy9pWwbKVM+JcwYuY/gNx4znhRFVECViic7nttz6QCRp5gvRjRBxLCt04WQWDGdIY26CCyet/nWG1S9oKC1Pmt/5A4f+pNIYjHQ0eHCc06n4k6ICfSyx8H+i3X06BC/By8RONMKqWmrw/e2lbE+9lrOus1TngbyLn9NO92LzLOwQTGg+CKMUifsqeUJvgWAZ9chL4PfMw/Pcdnf3+bDaoeb5MKdLYjKC90vPvcf/wkSr+MAWbSeVx+WgVHdEHa3rtEwbE0W4qatxTEYY+DolCBLs8bLR4B6Cfj+isTHPDuJuCgIHRLqhLFv2zDZ0HPs2AX1jxkdUEE7rBcYMFgzS3Rad0D4zUuEcMBMfcXPfZ4zuPtRckYGb5JCQh6tTnBNGxQvy4BAhJegSPPJIX2DDHwQcKW1sqXR8jctN6GOg/UnMBgopJ7ltHyp7a7r+ZvbKcM20+h/MkX9SLHdKibQq0EB1DBu5USrfyVf77cMpPdZfw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(19092799006)(376014)(56012099006)(11063799006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?R2pjYWZoWnhyYlFtWUVPcm5OK29pbHVRYnVOd1U0MkdPR05pdjR2RU9pN1M2?=
 =?utf-8?B?SStWVmt5am1HWnF1NHJXTHczY2ZsazVqc1I2SzV6TlZzUHFZY2NvdTllQW5q?=
 =?utf-8?B?Qzcvd3Y4N3R1V0dRQmhHQXc3ZTA4UDZ6OFBMMExuQU1HTFBza0czOStYY0JX?=
 =?utf-8?B?ZWpNNWNPeUdLQllxem44VnRTQ2RzNDU5YVBMZmlVQnE0WUd1WDlYMTBoTVRN?=
 =?utf-8?B?WmRkUXBDbFdjdnlETkxEWk01aW9pZnJheUdQMUJJK1RXSEZXa0hQVmkxWVJq?=
 =?utf-8?B?eTFRZkFndVA5WDZveDNvVnc1clluQ1pvL3dXM081ZVo1Z0Q2YXpRanFzK1Q4?=
 =?utf-8?B?bTZocjBCZVFheU9zTmFqMVZQWXFtWW9GYTdGbndZN1pzSkdzOVRaL0dJdkdN?=
 =?utf-8?B?MTB1WWFYdU9NWXc5TURzNEtNeURDbTR5NXNNZXltSSt1Wkl6bTNHN3hDVThQ?=
 =?utf-8?B?RFVncCsxd1NRYmI5bnEzUnM2MVBNTU0rZUNhbDVFYlhWOEdxenlkaTBRcDlH?=
 =?utf-8?B?eVh1MGdJZmNySmxXWUs2K0djeU8vZ2YwZXRBWHNNZEsrMFdvdG1sOVdPQkl0?=
 =?utf-8?B?ZGkyZXM5cC9MM216aWoySFVpdE1PQUhDNW9XNGlOTDkxeHRRT1d3TlNzM3gv?=
 =?utf-8?B?L2hTeGtrVzJUVkYvMGlCTlZrd2Nwb1NKODVwRmRmcDhLSGEzblI0VG02eFcr?=
 =?utf-8?B?OWswc3RBMlJla1JsMDBpWnY5UmdnUDYrYTdDcTBJT3lJYkRlWTNXUnBGNXl0?=
 =?utf-8?B?bHB4MWZuNGFUTzJmbnpCVVp0SDVEeVluTGhHNEtnVWFEWElyNUhYMms5VWZB?=
 =?utf-8?B?RFJyQURNL08rQ2I4ZVdkSDZIUFJZUDVYc0lWdnpNaTBmMDk1akVER3VyM0ZD?=
 =?utf-8?B?SFlTaGVjQkhDUjhGMDlnOFJxUW9pQ0hTS09RU1JvK2lQU2MvYjlNMVo3S3h2?=
 =?utf-8?B?WEE4WVB4dUVVMTV5OG5WYUNWNjNEQ08wdm1iRFlxY1NJYWM2SnlkWE4rV3pm?=
 =?utf-8?B?N0FWNGpuYytUNUxsdk5LaHhHWGY2a2lUc045V2l6K3ZBVVZzYzNJTVo3RVdv?=
 =?utf-8?B?VWJhQVlhUWVYYjAwYXdaUVNSR3dEOEthZXNUK09INGdKQ2Y5K2tFYkhMdWFj?=
 =?utf-8?B?STU1WHByWC9pVlFsTVkyY3o2bkZZWllUaTBQOXB2RkNJcWZhTlRhUzNwU2g4?=
 =?utf-8?B?MDlHdHRlRkdMYkN4eXRUZUQyVmlhbWNsQ1hMK1JKU1ZEdzc0SjFrUWpFUXky?=
 =?utf-8?B?Rk5QTHk2TVc0NmluYW0rWW5NQ3hsdmt3ZDZucFk1a1ZWUlgza3FkYUZhK3lT?=
 =?utf-8?B?UmR1ZHJkeGp1RGc0dGg3YUg3bHZ6L2hhQVM4YW9QMkRhVm41S2ZUbmx6TThI?=
 =?utf-8?B?dkNIdHg0RDE5ODRPdHN2eGx3ZHdxWEZ0dFVFY0tBT3k0MHNzMXorWG1CK1N0?=
 =?utf-8?B?QVR2NkwyVmpoUGdyMDE3T3lSL09qMXE3UGVVT2JmaVBaTEZtS3Zwcm5ZQlVm?=
 =?utf-8?B?NFQvbXZlcHpYUlZpM3hCSlNHNGpKZFNxeVh5dGQzLzJheGVMUjZkUnJ0Q1oz?=
 =?utf-8?B?Uy9ibjJEQy94bFFNaXdDR0pNSVY3WGMwK2dpRGFRTFpHaVIxY0k3aFFjK1lv?=
 =?utf-8?B?OXdRTkF6Zm4zL25pUEVtV1lvUVU1cGRKMGVHbXJuSXhLVVZmWWlIcFlrL1RL?=
 =?utf-8?B?Vkh4b1B2eVRWaGlEQjY5QUc0ODA1K2NuNmpoeGZmU0VmbmhFUytxK2pUUldM?=
 =?utf-8?B?N0VrdnlDbmM4MVlFNE1MbkJQZ2gvNzgvaEExV3FlMEVkcWpCU1dkNkxwUG1W?=
 =?utf-8?B?c2dkUVBZNjhTYUlsejZCSnFORlhzSGZtOWpjM2RHeVQycVlrallwd3Z5YTBO?=
 =?utf-8?B?TXZ6YmFDNVZPOVdMZXd1dmN4VU5JMktnSW1kd1k0MWFHUjc4QnhmN1BuTXpZ?=
 =?utf-8?B?YjlCMkh5YTFDY01QMlVyck5hNnJuUlJVQTNYVWtQeWlNOStndDZ3ZTBzdmp6?=
 =?utf-8?B?NytFaE9CSG5CQnBIYnhDMTVwUkhQdUZSdHUvY1hURUZWT21QcHNTUjZEMHBN?=
 =?utf-8?B?ckJ4SXYxUk9kUllRMHdyc2dxVFFHWlB2aTlJQUFwTy9VVFd3U2pobncxNHRJ?=
 =?utf-8?B?WWZ3VFhTNTcrSzgzaGk0bDRQbm1SNnBlZkluNXBSaENmei9Nd0hQaXFGdEQx?=
 =?utf-8?B?aVo4WGFCMVZJSkhwL3dLSnVxTzVtdWRUQjIzT25wNjhTcVhuck8yNjhrNDdZ?=
 =?utf-8?B?dWp3aW80L0pDUnhzRGIwMjJjZlU3T0pNMDU5amhPcG01Slp6eVZDUlg0aUF2?=
 =?utf-8?B?aHg0WkNMaDhDUjNzcjlycm9IY0pwdG1YSldYNDB2VEFoT0tLLzdSOTV0WGJU?=
 =?utf-8?Q?weGT0pDQgJDPCSK0=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039b4692-bcc1-4e73-053f-08df149c5346
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:16:15.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odb1bnubE3Tp4ZQKu5r9oahxgAkSqUaBGPPCS6eJec9uG28IKy6ssFkM4xIskygH6J5tHAEPUCbyNAeA8L2cWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7840

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

