Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013065.outbound.protection.outlook.com [40.107.159.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B594B2032;
	Fri, 25 Sep 2026 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790347013; cv=fail; b=tEdJ21BZ081cNXDwlrntBuDQXug+VCDevAhrx+xvkPxO/p1z9+Q9fxiorORWoDXeFsKKNJGhZ7M5VNMykQItHOZF74bsFaMZm2SDcoFwGjhr/qQAavejLONT6A1BcrWD7q+rh5LBzujJer7/8Sm2Ro3gEU2Z9noYcoPFXHkl9Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790347013; c=relaxed/simple;
	bh=gyHjk9qgGhpGB1lOzExqZiyHlqzJcnxT6APzB5tG3Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XvuF4zmTHejKLw6yVGbJf1VekaY/mEElKR0ObuyG8k434U+MsxvOn5OHFH5r00MZqZe8lrTipxKlN+TsrGqPg6ctwQMRHqho9bGunCy859eMSMY7DI+rgEDXFoWz6U+KNMa56YIE3tkr77gLVgzBDwKP0XVSeTyK4mo94YdEE2o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=HKgk6Qq9; arc=fail smtp.client-ip=40.107.159.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="HKgk6Qq9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eUYeyuFqxl5BnljdBIgDz15q0NiVoQr8ibzN/2uiHLIDleOOmjN3FdfUClv8UII7i5EQzy/AHFh782PzKrrkiT0P3yuEnuj0nKiK3ExqJdgJOPpJOsmN2qnRuLhshkmlWB2NpmT4TdMGQreNIlmXD1Zpldi7sEgKpSjvudTPPmDqC9zA9jeNrL2Sgnb+jjGECHqGzfrwxC9t+GewLtsAXKRZEfO/ME2duX0v5t8DWgLZBMn/m181TSCfRJOajhV280vwc7B9VQnADpLAmMYXulSEZXDuwfeH6DNt+hmkSsP/7keq61sUPOJt1GKzp3+k+hlmHmHEBd/4ooE+3+NXfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNv3Dqwe+CFrgU0Ud7+zUIF2eCtGCYIKl3up+iq6cmo=;
 b=AYGEXGw9G/0oTH6EsOcsaCKpwRtCmazCLCtzLBsd85/alMapqimkHJcfzc+sliwHSXqrifgIfoI0fFDFB0iaYQxVzYJrXC1a1pBJ1vsHMBG6kkzPKg5S/D1xLEYtY8V6C4vUMI/dTPYtD0n/2lSl1pWtaVq/HJIM5mu84GfBTdfaLDYiEgkgtwoce5SogQhiYyQ+N4GB8geihykKQexKPp9CYJCo2H1MrA5FmOl9eh72FeKtBEcWDpho9xwMGCgc60gLy7PiBO1Mf6YRUki5l3oibuN4QmERA5v4BSC7kp+vuGwnwUh1qtn5RToe7wn0l4jo9u0fKVcgQLXN8u4uEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNv3Dqwe+CFrgU0Ud7+zUIF2eCtGCYIKl3up+iq6cmo=;
 b=HKgk6Qq98e1JhCNo14QDMUpSvEXFfuPhJojSUpYkLYmlaN2v6eVogUIJ06CDs+hWxS6afQxG4c3dC/DewMfRoe5PiWEnyVXMKPTU3YqEYaBXQHQNIKjFp4OCfTv6uIb9NuAUtXEnNcUX1qSBDOVsa1/Tov2T3xisf/0SsjWZYa/EuyOxra6jh0pJ5GW29Hp+oMkop9cKCHNfwWBI7zSmynGtK2k5IyvASRCsDIUGhPZYeWQ5DDFxq/IgEVpj43FHzUZ2nWIG5gZCbzbN5EFwXHdR3rd7L+b9nUalI8YCHWgpR43XW39rz9e07XNKTjU+mA0DxxgdvaKNAHBq9CRcqw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB800621.eurprd04.prod.outlook.com
 (2603:10a6:2c8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 14:35:58 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 14:35:58 +0000
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
Subject: [PATCH v6 07/12] dt-bindings: ufs: Add NXP S32N79 UFS host controller
Date: Fri, 25 Sep 2026 16:35:29 +0200
Message-ID: <20260925143534.3298540-8-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
References: <20260925143534.3298540-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: eeb9760b-c777-4c64-955c-08df1b125064
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|19092799006|10067099003|56012099006|3023799007|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
 OdE34P8Y+9h2AmCmO/swyx5lqJizK7dAQuNJ2PXELBJ5G+iGUTsYFg6bxosPtohNFLNNkRChAY+a6Pv9Mez4qzRg0uhIwg2SzCjGfta9b5FmDlFMCEwo3t6D/QLHIJ9lq0WAK0bEZe/FLaYO4l1Ih7awqlGQI9jHYXKzyAFbfpS6KF5t1LsvbFg8dHIFhtYFXODKymTof/JNP+xB56dD4wlrkhBvTHVen5MR4oUUXJovNVTpUcMdgYHG0x6xAUOuvGY+wRfq87mK45pjXueI+qmjnqaGmgI7xAeyQeVPNt2VUc0wumpR5t7ckbquCDGEMablInrd2OoiJL4Q8QnqZmMJoo97bYqy11J6/A0fAO3NOEoRldOBPcsw2SDmrMUda76yHASkhF/2btIoIn/Qw3bM8r1cLyfrWjZ9nlKK6HY1KMqKv01Tj+GS5namfP9tt7GA9M7MUl0yqlySzSvXzrqgy12vb3msLDrmVJV7T4qZ3STAwUBxZklL4HlUGRhDJ3MNuUU3Igz6hoEjDAnrWly/b/oCj4w5J9jYKmSf4hHzu3+57+I5mSMIRsEIvadgR75DNWpenW4/gxDLKvCzoqJ2eAywRbSa6rdOnadnjUQOFog1KYTzDUqRmnTYbxWByxXehYBxIv+TdWNQRICPcUQ579QyAcZgajBQXhf2JkY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(3023799007)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WTJqdkxlUVVnK09IRm4rbmJOYWxoL20wZ0kyU1FHMitJMzQrWGMwbkQ1U2I2?=
 =?utf-8?B?U3hlaXFmQ3ZPTVFvaDRDQUZzL3gvSGVsUm56bm9tK0cwWVNjYlovaUpwdC9P?=
 =?utf-8?B?Nk9xL0xBd2V5WHp1SUV5cEFmVHF4TTl5OEtYMEFxbWlTZzQ4cVloUmJLQ1k5?=
 =?utf-8?B?clZ3OGNWdnVhQXRHM2hMWDV0bm1xVTdaWGZuVXZCRVIvYVRVcUgxYWtVT2No?=
 =?utf-8?B?MWt6UjVlOWN1Y09FSGFMeWYvRFJYOXdldW9vb2Z3OXFuZlRGZ1cxK3hWR0w1?=
 =?utf-8?B?dUV3UU9idm9iVVA2MHBiM3NmbHduTDdGb0pIYlRqSk43NFQ3S1pvRW5tOVI2?=
 =?utf-8?B?dS9vOFllbnlKWVY3b3F0aGRxNkVyTHJwaHlzZ3NEazNmZjBlMDFoVE5aTGtZ?=
 =?utf-8?B?ODZhL01RNnFYaENaSm5XZTVTZy9TRE1UaHlWejNvVVVrd0ZuTzI0OE1TRkpL?=
 =?utf-8?B?cFpSRUw4bmI3MmVmS05DbXJFcXZkdTJJKzYrc0RiT0M1ZGhaVm10TXlzRmZx?=
 =?utf-8?B?dERweWw5T2doQXM4TU52bDgxUXZObno3cUpZZmlBMk5mWEFBNDhoYzVML2gy?=
 =?utf-8?B?VjJnenA1cGYyemlpRHhPNHdQenpGQnNMOG5CRU9tMWhTZ0c5M1pPTm9PQlEy?=
 =?utf-8?B?a3lvbnR2R2k5Tmhpd2hFT0Z1bHN5QXBKWjlDOGVneXdtZm5rVjNMTCtzUElt?=
 =?utf-8?B?M0ZXcEtQL0dWN1lLd1JhR00zVlJnQW5mNllURHozeGZKdDA4NmtXQTlWWHh0?=
 =?utf-8?B?L1ZMTGdRcWRkMTVMT3dWMmtIQlowZGhEVTdacjR4U3BRcks3ZWVIMlR6MW92?=
 =?utf-8?B?VVVFWS84NEVyaW01emxsNWNSSTRPd3M2RndCYmZCM2lqOVZUck01dm15UWdZ?=
 =?utf-8?B?bzI5bGJ4REdva0dhTUc3V1hBNTRyR0gvL1crZUtHOUNkWUtKVFlpYjRQNzNL?=
 =?utf-8?B?dFB5cXVaRFRhcTBTbzZQT2gyYlhNeVBtcjZTWkcwMC8yUjZlT0pXblNmVTg1?=
 =?utf-8?B?OStjYXUxcDNYdFR0b3F0UWZxV2U4V0s0dFU2YWpBa2RXWEpZNWQ2V0MxSkJp?=
 =?utf-8?B?aWtCMER3S1ZaWWVDQzBYQUZaTFFFZmQvUTVGVUpYeDhka2dEMEtabGkzeDFo?=
 =?utf-8?B?em1CMFptUUgxd0N4TXpkMHg1ODVRdU4xNEU3THpxYkF2T1RrajJSb0J0NFVL?=
 =?utf-8?B?Z25OamRYMUJaR1FLdk96bnE4QzM0M08zWUI1NUhyY2VtbElOdkt6RDRiNGla?=
 =?utf-8?B?Y2tJMnRkS0NVMGN6cmhEeFhCaEdqdU1GeTdaMDZoWXZESDI2ZVhMZGFVRUt5?=
 =?utf-8?B?MFRjSmVkSGQrNmNiU3JLdWhET3pEZDhJTUcvdm1PaUJBTGQzZUhac1QwYnhp?=
 =?utf-8?B?Q1BwRUZNTmRKbUl2YXpmMk5ZVXpMR0M2TGVHK2xXeE9kdUMxYnNLWG5PaDFY?=
 =?utf-8?B?dnh1WWZwL0J4RmJOdGFwUzZCTTJNMFVvWkdybzV3ZEhGVGFicjc0N0QzYWRZ?=
 =?utf-8?B?SEVSWUVicmQybVlQWkJzSGN2NlRBLy8xcmJKN1E5S0JpMWNZKytOYVB1Mndz?=
 =?utf-8?B?QnNVWWFYUmo3aURmclZEOGM2WGh6ZGhQZWdmRGMxQWtCMkFiRC9ETnpDR3Bw?=
 =?utf-8?B?Z2xWYUlwdUNvczRQeC9mZFBsVTFaaU1ZVEljcjdsZVZ2Qll4NkpFYTZpVWdz?=
 =?utf-8?B?T1h6WkxMeENrbHNwM1hLa0RReEpUc3pVbERZcmtJbkZTbkhISFpyZkpHQlBE?=
 =?utf-8?B?TDdVMG5NTjNNMUYvS2ViaWJFbFg2N2E5dHJwaCs0VHZOUUpDWXlvNEZ6Mk9M?=
 =?utf-8?B?YndIclBuRG5TTncyVFRCcUltRnByZU1JMG5jek54SjRzbmJPRTN2RXByV1Bw?=
 =?utf-8?B?VFlPdGthMGNiblJzVnRhWTNxcGtvVFE4NW5odlBRQVZtWnpzVThuZFNNK1RW?=
 =?utf-8?B?V1ErakZaQnpUUVYwQ01QZ1crczR1Z2xTOHo1RXhvOWRVbGp5TjRSMm1Jbnll?=
 =?utf-8?B?L1FrbXkrTXhsTzVwTzY0QnJESGFKMHYxK25reHpXSGpwOVlEYm1VQ2p0RTdI?=
 =?utf-8?B?SFFBVlZBcThGeklIMXdrc000N0JJWXFHOFQ0UE1PendUT3FaR091SlRPTEla?=
 =?utf-8?B?a0NkZm1NZU51Wjl3SFphMzdON0l2RG50QXFtUWhDUk1HclNGLzBFWkFzWTVq?=
 =?utf-8?B?ZS9JNC9IMW5rWXhOSnVGVDZqV1ZXZjZtdEVvT2tLZmJzUGNXUVdpelRPQ3NJ?=
 =?utf-8?B?SksxVXozcThjS3VPV0JQb2ZtRkk1L3l5cHFRdi9aSFFjTzVoWU9pcTlBRlla?=
 =?utf-8?B?UFd0Mk9wVHFOWk9VUThzam1qVjdSK254TnRNMmVKRko0NkhUZUxHdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb9760b-c777-4c64-955c-08df1b125064
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 14:35:58.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wm3u/T/UEy3Bi6Iu+dKnDtHSeZ0+nRF/MSDpxqubM14fOaoo4Sj5f7t4qYxk9aOoaN+77oq1Ft8NT2IkUvSZXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB800621

Document the UFS host controller on the NXP S32N79 SoC.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml

diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
new file mode 100644
index 000000000000..b825fc1f5e25
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP S32N79 Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Larisa Grigore <larisa.grigore@oss.nxp.com>
+
+properties:
+  compatible:
+    const: nxp,s32n79-ufshc
+
+  reg:
+    items:
+      - description: UFS Host Controller registers
+      - description: System Control Module registers
+
+  reg-names:
+    items:
+      - const: ufshc
+      - const: scm
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufshc@4ac80000 {
+        compatible = "nxp,s32n79-ufshc";
+        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
+        reg-names = "ufshc", "scm";
+        interrupt-parent = <&irqsteer_coss>;
+        interrupts = <211>;
+        clocks = <&clks 0x92>;
+    };
-- 
2.43.0

