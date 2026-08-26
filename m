Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011050.outbound.protection.outlook.com [52.101.70.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1279F3BFAF7;
	Wed, 26 Aug 2026 13:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787751661; cv=fail; b=IiPbkyzEH+lbpdyRuxN3HHy9zMNvYN9RtgOwyBgJ/UT+f5cA7Onzfo2xDB0AW/ngwRdH2u/6EOZsFK49NGuprjtRYZ9KEBMuRFLYaSnW8VfI8Gu9PzdTrmrIwBKv1zJCTN9mC/j0VjsLWFV1uBaFAoogGpN0kIHDqcjSpPtxNBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787751661; c=relaxed/simple;
	bh=f8N7mB9NxjZvCHLLsfBjYyuFqUrERiJyPTZyKSUJV9M=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pQP0Zv/KVQ2PrBFgm3CBMKl/9EaRqDSlXx7UZx6Ac3nfuCYwg71RG169lK8uFaKcgHQbuSlD3SuYQ16E6Fyby+JdcTPuuEqrDeWFjdyy2XmMfl0PZbsy+PSHQPvtJaPkSE6uUeYeBPSFtgvcIxc5mMcRCfdRIbzkkXbtdv9s+oI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=mMAWkn0R; arc=fail smtp.client-ip=52.101.70.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="mMAWkn0R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZ7Mt/i/wLx0Qh2Bha1hxfd1fyltlaXYSS/6nUWHHdryLWfV9z/AmbHgmkEY5sl8TqIgcfpDUOKBysPai4PRCtHWOd0W/lQT3uNWiL/85phQdER1b3EDw9jxn5fAY3QRhzL8inh70ZO1M6PvlI9jVcpt0464fZ+qFhW+qdIKDhdrnNIH5UbzV9lhsVT86HmSmu4njvr86kOcbLR6yKLkLIeONVWNRkk9dh2yVleubF1RalxFi7vL7+QTvyNxZZRffa2A1qmg7/To2nwuuuSS7KamULKOXXJVQcDL/HvvlzGlgwk6gL0ili2nD8BSUQuR/elnk/L/jH+7mHzgf+KYXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ywCoDt9cqmRYW5WL0Dg7QSA38nDf35nakgbp+fj5I8=;
 b=H4QEw6rLhSp24usHMD+bF/XuKNG3ONF9liqdoC21hgVl+oiy4m0v7l1pzTVZps2eIIvKLhIr54noE/LwM5lfFTA9Xxn6dhmVcNRgwkh4ikM37UFqdvx5wzsx7lNhdtBwOE9iXXfRPNTu8BbjLu/OwU3eM0Vk9kMINEpWsFnFYRSlx+91AY9bgMs36WnsunyHBas2R2kTazlS930lvCGRWdwjhgwNgH4zWw0yl477JcZQtLPYQQ3jBzcOUZdCYyCdZd2WxLXFLnYYer6M03Gzp1hRsw9tY07EP11Srjd3tcCGgRVgoT1A8RYWd5xasDrc1aSZFaHQqEu6fivAkX/giw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ywCoDt9cqmRYW5WL0Dg7QSA38nDf35nakgbp+fj5I8=;
 b=mMAWkn0RJEnm54fLtCKeHt9r36d5eaZ3HXLv3QfXJLMuwue6bulY4/U6GtuGWUAK5nWybwpyGL1+/0BX0EyyfyrGmqC0l1Z84bRzDnZ1rwv12G5KmgbBMzEsrXAeuI7nzn0cge6PRDYNnILmPrLcUoJ7KW4qD2Udvl4iPV4ktPbytXRyWAoPKVDChIVbzJrY8o81gVsAFhSBdeDNiVAANUpDRD2/5rn1XBflBNStzfYzxwm/rTihGvW9oGlWCWc7w+2vP2XcDKcQr3d1s+I1GukoIm4GJSQYtW+ZKU5BtZOjrvZY6qI6a4hm9yRNLmIfj4f3JOelzwqXaik3EtiBVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by GV2PR04MB11862.eurprd04.prod.outlook.com
 (2603:10a6:150:2f8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Wed, 26 Aug
 2026 13:40:52 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 13:40:52 +0000
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
Subject: [PATCH 00/10] Add S32N79RDB UFS support
Date: Wed, 26 Aug 2026 15:40:38 +0200
Message-ID: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0385.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::10) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: eee604ee-ce35-4c32-1dec-08df0377a5cf
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|7416014|19092799006|376014|366016|921020|6133799003|10067099003|56012099006|3023799007|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
 CZGrOf9iPSqqkQAckXhfk1YEjeOkM4nehkJtHKiFibq3OU3JMi50GnXaJWeyVYWM291BT0nFELCngE7bwA6dPDtkiSyLg0BF15zFZSYDH4u0NPDWohD8DS97CnznUzhRVqPNQpRPR9tZIJ9zBaUmUYacAfOLmIlkHYo+vE3DZLob9coRyUlRcv5KU2M4gDwklvJ8bX7NzUuRmG2zd3dAK5Y8NWTN/bEyA9tGCMkDl7kS+PV7mL2EgAFjnCT6IJLclmHHlD5RueGdDf7KKiZ4fewpbg1h47F2tgrtj8SP/eLBDZMj5ojv/vGFp/QXyrZKKfZ4ust7F0EcdZvrYDHpvhAPWxjl067cBCekMNVg97Aj/TeeaJQh79RLx+h8JkxR4Hymrablp/ojHcSvYwi7WxOAB8M8paJ2CxuYPZzjkzPA12BX2F5F4pU0SqdQ0X8OGwBPsJbiywgBslFD+rJCBe2TqTp/obJthmzxyr6hP0z4v+vGzNf8qgAHJFF7SaCDJZ2ZK2t0WOgBgR+OaESipjMxRl4dSbBin5Im7MZ6Sbm7GF9M/VU9TjWbg5sRONj7EJcg9xVnrY775lkCH/TJ3WKT8cp7Fh3NPG0TXxMef+oknP+tJsfF+FPIPp5wEHNj0ZNv8r1QMYh9LkFGbIiN2+fI+t1tJPPLM7xgylE4t6NRH3lMYvFWdLLcXZfkTrWm3N8k7YbpoNS9cl8TM96WGA==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(19092799006)(376014)(366016)(921020)(6133799003)(10067099003)(56012099006)(3023799007)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Y3lMRnhGNlE1NkE4QkRESFRzcHQ3VlRtZEFSRmN6YUxBQzFmS0RDODQ3R2I4?=
 =?utf-8?B?U1VmQWFVVlUvWUFaNjhXeVkwRXdrRWtYVnBOa3lvc2NsenVvNU1idXZwOEdO?=
 =?utf-8?B?c1ZGTTNkSmc1SzljK0ZWeGR4N3BEZnN2c0d6czMyS1RNZEFBMWR2RzJ3dXEz?=
 =?utf-8?B?SUFLTUV0YlNlY0R3VHJZbHlQRmFaQTZZNUQ3Qm1Way9BblF4M3hmUUJIcXdE?=
 =?utf-8?B?Y1NMb1hWTW1FVGsrOW1FZk5XQldFdkFMM24rMTI1Z2h3MEk4YXpMc0VJQk1t?=
 =?utf-8?B?TFBTYkoyVWdBUk9RSWQ5SFdjaDNtMkFTRTUzS3hpb3NqVDVUWERCeFIxdHRl?=
 =?utf-8?B?a2R0QWxYWEh1VTR5N2ZFanViVGJ6SDhMNzYzazg1ejYyOUpWSlVGSGtxZGI1?=
 =?utf-8?B?WjViS0tjVUxuaElVYnpmTEttNlRNRjhLbVVCNm9McHNmbXBFQ1V4MWRXTjJt?=
 =?utf-8?B?d3lER2RscHVINVJrM0FFVkZkUi8wZm5NT3hzS3ZOOVhHUWtKd0YwaWx5SjhL?=
 =?utf-8?B?akx6WW9tcE1ja1I0U1ZhOXZWbi9GNnJQL0p3WDNHL2xQbUplSHphZ1NjREg4?=
 =?utf-8?B?dHQ5T2ZjSjdVclg2Y2t5ZHBMM09NY0hpZFpwU1IxT0Noc3o4UytWbFZKNDcx?=
 =?utf-8?B?RW9SNVdTQzdGb05yUDVTVVJxQWt0T0xnVGd4bTlSZGlCclkxcHZsbHJHQzV1?=
 =?utf-8?B?VEthWWJEQUZhN21EbHV3UGFrK3dPT3dZQkpBRlQ1WnN6QzMvbEJ0cXBsZjcr?=
 =?utf-8?B?bUtHNTVEOWJKbUl4Y1JnNzdyUCtmK05IMXAxamtkVHQ1YVdJUnlwbUJQejI4?=
 =?utf-8?B?TmVSTktkUU12azFicXlKY3pBdkpzZTZVVnlQLzJQUWpBbkFoNjRzM3QrWUR5?=
 =?utf-8?B?M1FiUHFnVmd4ZWtteGdtY1NtK1RWWDJXR3Rkc2RIZm50Z3VrK0dISE5Ebksw?=
 =?utf-8?B?TGpsd1ROTERBTzM0R3lZVFNicW02VUNWWkplcXJxa0xRVEM4NnNvT0FRNWdU?=
 =?utf-8?B?dmFIdFVkYjRWVk01Q3F6SWJ1RVdNWTNNZFhrbzFRNzFESFhERWJKVWcydTRD?=
 =?utf-8?B?d3hPdk1UeUNlcGNSRWtIcWhUVVgwY1MySG9vN3dGWWVzcHMvNithYzZ2L1V5?=
 =?utf-8?B?S29KOWNDait6dFFQZnpTUHFDekpENnpMM0VSWHdQRUJPUWZ3OHBPdnhFbTlH?=
 =?utf-8?B?RUhteVRkR2NHcEtES2ZJTEVSeFNHTUFlRWhIK0hJZXlGOVljQllERm4xY1dR?=
 =?utf-8?B?OEZ6M1ZZcHZVS2hWbUlZZndFN3hmSThqR0ZkUEpXcDNNdTBna204Vitodjdl?=
 =?utf-8?B?aU5aY01LbStldUU4OGJNN1BuZEZUamRjSWI2a3NTS1U0RW51eXducjJFWjk2?=
 =?utf-8?B?ajlFSHY1ZUxWZ1B5aHp0SXZjZDlYZzQyODMvTUx6Si9pZE5qKzRoQXZKbVpx?=
 =?utf-8?B?N3IvWnNDSGVxcXA3RVREcjJ2U3RWQzArOTRmaERzaVRKVDlEeldVNlQ0VjFS?=
 =?utf-8?B?VlUrZExGdWlGSnZKWFZnQjFzOEtFTHp3MW4xdXBTU2VUNXIwaFVvSU03Rkc2?=
 =?utf-8?B?QU12VzEwUXRxSFhVR3NXQitUTk8xTlZueUtoSThQTjFnenhjWnJsZFpMa3ln?=
 =?utf-8?B?dG8wVUx1VGZjS212RlJiSmVZUjNtL25Fb3dzWmNSVzR3L2tPc21xdEtGeHFy?=
 =?utf-8?B?c1BrSmI2S1RNOThHZVBoUTd3MTRLTFBIVjNnYkR0akNmVjJXaFI0aUpqanRy?=
 =?utf-8?B?Q2toVXBQYWN5cjlqK0R6M3pFcmhMMHp5bS94L0JPeS9iaGtzbzdudzdDa0Vn?=
 =?utf-8?B?ZVgxV1RRY01rbkFNc3NRSEhhM2h0RkxXelRkM0VrcnZaWmczQ2hzRVMwaFJm?=
 =?utf-8?B?STlkU3dMMVZDZkxEc3FjT3pySzJXTENsRUpFcGVTWGVKY0MzNEMxaDUyaU9F?=
 =?utf-8?B?QytLREx4ek1uUmFZaEFBdnF4WHJieUJOVDVidWIxWVYrQUhNdGRLUFEzY0xP?=
 =?utf-8?B?Z0hmMnh4dlMyVUZJYm8vWWxZYUZXUEJZcUlFcUxFZTBpMU5ZSjlxRXBPcFNU?=
 =?utf-8?B?d3BtWlI2R043Q0ZMYllkdVRKTnR5V1ZKb0N1L1pOZDR5dzBEakJkcml5T3Ja?=
 =?utf-8?B?RDBCSTQ0eEpNRzRIbTRiYU5QaGR5YlRQeENrTU9jS2IrMVZidmdVZXRoZUpn?=
 =?utf-8?B?RENKTUdqb01sZmxWVjlnRlppa203RzJFRzBHdUdqdkU5U05VN21PQ2x3ZHgr?=
 =?utf-8?B?aHZpTWdySWprcnBhTUNNelNTbktNOFdlR05ZM3E0TDMxb2E5NWVkN3BMU3Jv?=
 =?utf-8?B?dnpSVXBPUnpRNm92bkNzcnJWVDhLaHB2MDhoSVpxVGxXekhuODNhUm9nUFQ5?=
 =?utf-8?Q?hNov7xldUKkQA9GQ=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee604ee-ce35-4c32-1dec-08df0377a5cf
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 13:40:52.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oy0SzcRChmqrRUSFpY7Bf1BQuOadX4zOXuLiCZh2hj6ewCi5iRzoYM5RMiVBw1nyTaeNkhwXQCfxgRF8eti9jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11862

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

Larisa Grigore (10):
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: host: Add common Hibern8 TX FSM polling helper
  scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  scsi: ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add compatibles for S32N79 Host Controller platform
    driver
  scsi: ufs: Add NXP S32N79 UFS host controller driver
  arm64: dts: freescale: s32n79: Add UFS host controller
  arm64: dts: freescale: s32n79-rdb: Enable UFS
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n7-ufshc.yaml         |  99 ++++
 MAINTAINERS                                   |   8 +
 arch/arm64/boot/dts/freescale/s32n79-rdb.dts  |   6 +
 arch/arm64/boot/dts/freescale/s32n79.dtsi     |  11 +
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  89 +---
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 464 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  83 +++-
 drivers/ufs/host/ufshcd-dwc.h                 |  36 +-
 drivers/ufs/host/ufshcd-pltfrm.c              |  79 +++
 drivers/ufs/host/ufshcd-pltfrm.h              |   2 +
 include/ufs/unipro.h                          |  21 +
 17 files changed, 817 insertions(+), 192 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n7-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

