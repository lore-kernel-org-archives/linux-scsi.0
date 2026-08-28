Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012025.outbound.protection.outlook.com [52.101.66.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746B39D3EB;
	Fri, 28 Aug 2026 09:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909007; cv=fail; b=F3cNyfFSD+ubamaiSyf+aivPHkHe7IRpAV3F+zXwkAfb6TGxNXCw/w/Xym7+AG2SHc3tuThlX/jj60iJynm9kcG8fo5pvKw6WoTICYH5ses4DIU7qfZmrLd08vBWldwMBUyRnzJnVFUjGqDw+Owq3hmYUhI3u7f98NhEqltk35g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909007; c=relaxed/simple;
	bh=xopD4a2Vb38Kc3jFPgBXJwsmUUUU3AhvfLknwIoxaQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ejR5VFzJs3Xf0ToO3hBNHcdmcSIUSan43F6ub1Ec8K/QuOeL4IJBItpZ3E0RZ47eYdxgHJO4sCr2jL7rYURJdP9p/VlsWljEOI8HA3EVju8CDCyZdHj8YGw7P309tqyyujWpC8kgANiRMoBIU4SYtxLCIaEu+N1YlSJaDSBgtdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=oiH7kQ4o; arc=fail smtp.client-ip=52.101.66.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="oiH7kQ4o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaJ8gmgPgzYRlpms3ucCIU3HxTm4hnoBjf3xYN59FQ8aN6xqpZsWZVAvklkM/hPpA4JqNwnHKFpCXFOLhG3VFodI4JQN5L/B75qOWQm6bCWpvemfi7MxKZGSgylB/p1I8O2s5UK2zRTs7875wiqU2fJs7exNaC8PhRPpH/564KqF4IG1bz7Do7UvvX2JivXeixe2yRQ2gmk5V8nc0XLtNpjRNTzzbWRdvKV2ADCL/xRKEEnGmeKMfwGbTH0r+Dse7O4B1Ip9zcyTQVt4+6+D78CxfWQ96rq6NkCvdF49TJRpTi0JrBpkj9cnswCWEEpJg5873JLusqrtdt85zz2GBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mA29BVdtgrD1b3L5AivDuyz3ybU6fvSY4GZxK9OXjW0=;
 b=kY7QgU5kqSyY8y2Q8RMsCJavrvOn7zxNBDvH4gIGQOQBYGiMeJ741je/c3QoHslpf0BpjSMyAnpgHNupJ56GwjJLZqJ4ZXN66pjvPTD83ulJXP0Ekb834BIQh5ko1nMlXjJqcJ6SxQfmRq1d3ZBZSEl/F01q+xB/vwWmdg4JFNu/0+Yfjag6CydKp5IsaJuA/AlsWgcmar6Gcv3+g2WVg3NB7r5j/wKSD5UUC4czDTD5zU1w2CrhcZL5IEST2D6m77KPg9QsAVhvZrq7FJq9d9fcNtwvm/O6ggBSSqJ2YLXttyPWxtv1GlkSXuBLAd2IplN77R6rHYXbcOKiQ0rpLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA29BVdtgrD1b3L5AivDuyz3ybU6fvSY4GZxK9OXjW0=;
 b=oiH7kQ4oPbpeq85EYsy7bThmI6d0m/UMFwigUTFUC3EyO/mbFp5maHDRGLWHVx08GFK3hFOVWsIsD/9DnkQyxQDpBu4H3f7KkbLV+dQrqMRTuOL/41DTme8X3hLDGPyea5S5CRXex5ThX7oCpkuNoRC+qq/QdZJB8bzSF8i7Me0vwEbwJP6csY3N1+4jFQ/Ag58bJvtjt2QsTOVqfgVcVwN65RTosy7GjrzLqGuRYaGsWMgtNyRZZiAH5AH9F0PKfzlvCiNKpX3iYJr6Q8WSVwS2nFRyvFaU2OX2Ge0hOPM4Xc5e3srurBWX9Gl88TkHe4xu1FOAjG7zFHEqk1y0XA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PA6PR04MB11909.eurprd04.prod.outlook.com
 (2603:10a6:102:51c::22) by PA4PR04MB9438.eurprd04.prod.outlook.com
 (2603:10a6:102:2aa::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 09:23:20 +0000
Received: from PA6PR04MB11909.eurprd04.prod.outlook.com
 ([fe80::a4b:fa4e:7fe7:e6a2]) by PA6PR04MB11909.eurprd04.prod.outlook.com
 ([fe80::a4b:fa4e:7fe7:e6a2%7]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 09:23:20 +0000
Date: Fri, 28 Aug 2026 17:27:24 +0800
From: Bough Chen <haibo.chen@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 07/10] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
Message-ID: <20260828092724.m46ftm7daavufuxy@shlinux89>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To PA6PR04MB11909.eurprd04.prod.outlook.com
 (2603:10a6:102:51c::22)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR04MB11909:EE_|PA4PR04MB9438:EE_
X-MS-Office365-Filtering-Correlation-Id: 0908b4f0-3a05-439a-2757-08df04e60021
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|19092799006|22082099003|18002099003|11063799006|56012099006|6133799003|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
 ynwX7958d9cA0I5+PHXYTTrdfahGfX3D1abxhjUxE36P0CohKxrcxcRXwxuM4coTGKGuExNYhH/mXYff4hVJ9fSlHPvxBzav1wtcfZi2D4khXXm6zMKe2C27F+Rjp/yZvvDUyexoPuY2Urx2vIQVQZR13CYzdRLA4GePmm30M1iG3YSlJFemQzlTjKJXPVQ/VHlHT3u4WoUzPyh3ti3LE7lKUl9a09BuZr9ZLpNLOacNs9v3aL9mvTrLpOK5TW4FLpl7zhiYWHbIIR+wl4BL64fL0HXw3hrT7mr+LyjAjnLtPB5aHMZVi7U8rM/Z8Y6rqYkTCOVoKX9Rlqn/mlXtJ1YqK88FwXEMYMveChIG0fhlDf009qRFNXADWxB1qZJTuUGIG6pQvjGgxHmrH5awdcwfpCdFy5Gjv5wFObURNzffQR3K1l0kWd395FY/hZh4wjdRRQVQdxdxpqTVaaAo17rtfehdfdlNM/rfugjkkWrSZF6j8Or0LzOEuOnLZFOH9IYceqS8oWLBQzupr1Lvnaa+Lstn6NBq8JHwYo6Wy4HVGIyonDFUbfsBI9DE0JvupU0NoresBF53gbxbzfycC1LzZ4YkuZgyklFzF65xCCvnThgj1s7nlDkqVa7oy8uPMngsMd5r4Cpk1I2OB4CGDOb1JPWi2o1FtIAQ7qA87dk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR04MB11909.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(19092799006)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?fi+3nkf/HM0y6suWcbWCyesHwk891xfQHnmJFgJRYmMPLf/R+EoF3iWp4i1u?=
 =?us-ascii?Q?ZmfJ+Hj47W+u1M8h83SPaMaeNsKtqgMdhgzSTtwaFb4qDpuaSJg7Hs0XT3R5?=
 =?us-ascii?Q?z6xiDYVr3Fd/WbLBuwQYev0zCRehKIQfZzMbFQD1yAKvidKrQPmW+lkQhJoP?=
 =?us-ascii?Q?o0zw2TAtzsEWIqk0A4vippRs7JlA+VqHHYcxh7vAsaflB+tARHlEtqW+Szu0?=
 =?us-ascii?Q?F32ChIDOlw50eVg8855p9XJ4+oThqWCKadlal3Nt7JgC021gnYIZuPC6uojU?=
 =?us-ascii?Q?zyQ28U1nGJqCl+p5o5pgrF15qxoGbIHs8rL0yl0ljrKqmHrf8QMP4dBupDGK?=
 =?us-ascii?Q?GHdkQ32xg5XtBDqi6zSlVpAlUyp6oH5uaED5zDtmSl1oxiS/mgv/5Z+BprKo?=
 =?us-ascii?Q?4ojTAGaW3IXBd6xQfvS/TEskHFVIPNe7EMK4xTEh1F+AOyOYwN+d8ovfh3qU?=
 =?us-ascii?Q?xQZE9T54/+ECSlR1WbgDxpxD9Qvr8UvGbL2Bx9wNyI7z3IZlfOE+gmpY4qxj?=
 =?us-ascii?Q?eQ6IDQUO5VqVIb65xumw5BxkufOxM3xloplE8m+ii25eI919vS9QfrHlyYqj?=
 =?us-ascii?Q?2IiYaa731kGjTEe1PjodEiaLpFuMugRGeXr6sNQDOZxEjdNdNK9sflwoOQxM?=
 =?us-ascii?Q?Qfm7L4icso9yjfYw+u2zACpaI9sjPhKJ9HuMF6l3FwZlAHm11eLZKJHHstRr?=
 =?us-ascii?Q?zAEVbGojGlKj7iUzFsqGLSBIuUqDtOHt8dhlbLSvPzGwysTqR+kJAqcFmMsf?=
 =?us-ascii?Q?SlUznXsYoS4+ufZJtWq/ZeGWx2Zu66xkvPbl3t/C5Ij62kdCsB4Ca/3LCB0j?=
 =?us-ascii?Q?NjnxxRlI9UCfvJljYSM10xzEFl72/daeTeUSDBrmGRkSrN8ISpQ6x65RC13u?=
 =?us-ascii?Q?rC5EnWeC6TA3pLTjxVkRppA1rfJnPk0/3KLUBv5UQTgfIif38RN0+mkjduQq?=
 =?us-ascii?Q?OCa3yNopVZHJd7+bjD5l/et2VUqFhYBDXSCgy0Jm1eQ4lWcdpnRhEkyl3xdc?=
 =?us-ascii?Q?S9IA4rK6obij8WbV/V8t3e2WmyvbncpjsCZuhlMGsxgumLf+8Qfypg/HZHO7?=
 =?us-ascii?Q?yIHcams7qO/SMb930eGIWcDLFc7przoW+BewF0OZw9pu/nJauoZOvY4dLKxM?=
 =?us-ascii?Q?OarqdJNNdB2rqg1q+HAQ8++ZcCECmpMIHzqYiG2cLlEbqlIbg2XqnJEKrWIV?=
 =?us-ascii?Q?kAjfAlKNz57j4zt1AEKK6qk5Lj8pB6fzwq1QCdgh3/o1RAKzt1O9AsArNuo0?=
 =?us-ascii?Q?ZAy/APCi5DTeKV6SzTqydZuyJf4iAHlrmL1XhyDKrMR5RXBsSuH97735/WKV?=
 =?us-ascii?Q?XxHmARPMvnBYY6vYq4T1d84cYV1gRXM/LY6YVAx1EKDOxXEk6CESA2FP//qK?=
 =?us-ascii?Q?kmh+Fl0fLjfiGnsKIOfZSxwWlbcjGUz/wdOQKnlDW3e6GchNtGpVfFqfB4NP?=
 =?us-ascii?Q?EHcVYqzsfCye4tHBZ1KZlPgaj6DsbZj9kkbQexfpgUATccCTgF3EU2zD0Cec?=
 =?us-ascii?Q?VN4DWzj7ax3Iak/I+TpgWTF9ss4Ek8F4eAYnRAmtOLMBdPBmW1ixwU0MXPVh?=
 =?us-ascii?Q?0jar2XajrwqJJ7DKQvzhWAuky6SYg2sQI3wFIxg2u1guMx5oaEYg9O3aKare?=
 =?us-ascii?Q?7jDThu/rZQeagSPhYcSiGI/1P6QnFjK/aUPtEUB3vrSQJbwYO/1kbc6EETjr?=
 =?us-ascii?Q?OMt8+fn1kOD/xMVSNRcoEm98Mv23WISZCJTyIQPxIVEeIMCuLturZH6aWDqQ?=
 =?us-ascii?Q?4+S5MaItDFrAc/CeoQzoYpBQREHxeC6qjG5vfNwFhH4OeIctH0Gk?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0908b4f0-3a05-439a-2757-08df04e60021
X-MS-Exchange-CrossTenant-AuthSource: PA6PR04MB11909.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 09:23:20.4547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mY7IckZmOkWBGWBIvL0LRZQ5F4QXB45lVRm7utPJoH52bmSYlEQSt9J/5+NAj1V+I3a7BGrp+94/nndx27VlE77nTGBbofVoEdw/Y1fs5thD8fK16yR0WNH+iShbjkK5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9438

On Wed, Aug 26, 2026 at 03:40:45PM +0200, Larisa Grigore wrote:
> Add support for the UFS host controller on the NXP S32N79 SoC, built on
> the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
> UFSHCD platform glue.
> 
> This controller requires S32N79-specific initialization prior to
> UIC_LINKSTARTUP, including:
>   - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
>   - applying the vendor-defined M-PHY calibration sequence, and
>   - performing post-link calibration steps needed for HS operation.
> 
> The M-PHY boot mode is selected via the 'nxp,mphy-boot-mode' device tree
> property. If the property is omitted, M-PHY initialization is assumed to
> be handled by external firmware or by a simulation environment.
> 
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  drivers/ufs/host/Kconfig         |  12 +
>  drivers/ufs/host/Makefile        |   1 +
>  drivers/ufs/host/ufs-nxp-s32n7.c | 464 +++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufshcd-dwc.h    |   9 +-
>  4 files changed, 484 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c
> 
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0..e8ee7dd05f1a 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -168,3 +168,15 @@ config SCSI_UFS_AMD_VERSAL2
>  
>  	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_S32N7
> +	tristate "NXP S32N7 platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
> +	help
> +	  This selects the S32N7 specific additions on top of the UFSHCD DWC
> +	  and UFSHCD platform driver. UFS host on S32N79 needs some vendor
> +	  specific configurations like PHY and vendor specific register accesses
> +	  before accessing the hardware.
> +
> +	  Select this if you have UFS controller on an S32N7 based board.
> +	  If unsure, say N.
> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
> index 65d8bb23ab7b..0381750a35d3 100644
> --- a/drivers/ufs/host/Makefile
> +++ b/drivers/ufs/host/Makefile
> @@ -2,6 +2,7 @@
>  
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
> +obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
>  obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
> new file mode 100644
> index 000000000000..8a125105536b
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
> @@ -0,0 +1,464 @@
> +// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
> +/*
> + * Copyright 2026 NXP
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/iopoll.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#include "ufshcd-pltfrm.h"
> +#include "ufshcd-dwc.h"
> +#include "ufshci-dwc.h"
> +
> +/* SCM Register Offsets. */
> +#define SCM_ONE_US_TICK			0x2CU
> +#define SCM_STATUS			0x30
> +
> +/* SCM_ONE_US_TICK Register. */
> +#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
> +
> +/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
> +#define SCM_STATUS_PHY_RESET_MASK		BIT(0)
> +#define SCM_STATUS_SRAM_BYPASS_MASK		BIT(1)
> +#define SCM_STATUS_SRAM_INIT_DONE_MASK		BIT(16)
> +
> +#define SCM_STATUS_PHY_RESET(val)		\
> +	FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
> +
> +#define SCM_STATUS_SRAM_BYPASS(val)		\
> +	FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
> +
> +/* Timeout values. */
> +#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
> +
> +/* Clock validation limits. */
> +#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
> +
> +/* CPort definitions */
> +#define CPORT_0				0
> +
> +/* Hibern8 state poll timeout. */
> +#define HBRN8_POLL_TOUT_MS      1000
> +
> +/**
> + * enum mphy_boot_mode - MPHY boot mode options
> + * @MPHY_BOOT_NONE: Skip MPHY initialization
> + * @MPHY_BOOT_ROM: Running MPHY from internal FW ROM
> + */
> +enum mphy_boot_mode {
> +	MPHY_BOOT_NONE = 0,
> +	MPHY_BOOT_ROM = 1,
> +};
> +
> +/**
> + * struct s32n_ufs - S32N7 UFS host controller data
> + * @hba: UFS host controller instance
> + * @reg_scm: SCM register base address
> + * @core_clk: core reference clock used to derive ONE_US_TICK/HCLKDIV
> + * @mphy_boot_mode: MPHY boot mode configuration
> + */
> +struct s32n_ufs {
> +	struct ufs_hba *hba;
> +	void __iomem *reg_scm;
> +	struct clk *core_clk;
> +	enum mphy_boot_mode mphy_boot_mode;
> +};
> +
> +/**
> + * struct phy_reg_cfg - PHY register configuration entry
> + * @reg: Register offset/address
> + * @val: Value to write
> + */
> +struct phy_reg_cfg {
> +	u32 reg;
> +	u32 val;
> +};
> +
> +/**
> + * ufs_s32n_phy_write_sequence - Write a sequence of PHY registers
> + * @hba: UFS host controller instance
> + * @cfg: Array of register configurations
> + * @count: Number of entries in the array
> + *
> + * Return: 0 on success, error code on failure
> + */
> +static int ufs_s32n_phy_write_sequence(struct ufs_hba *hba,
> +				       const struct phy_reg_cfg *cfg,
> +				       size_t count)
> +{
> +	int ret;
> +	size_t i;
> +
> +	for (i = 0; i < count; i++) {
> +		ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
> +		if (ret) {
> +			dev_err(hba->dev,
> +				"Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
> +				cfg[i].reg, cfg[i].val, i);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long ufs_s32n_calculate_us_tick(unsigned long clk_rate)
> +{
> +	return clk_rate / USEC_PER_SEC;
> +}
> +
> +static int ufs_s32n_configure_clocks(struct ufs_hba *hba)
> +{
> +	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
> +	struct device *dev = hba->dev;
> +	unsigned long clk_rate = 0;
> +	unsigned long one_us_tick;
> +
> +	if (!ufs->core_clk) {
> +		dev_err(dev, "Invalid core_clk.\n");
> +		return -EINVAL;
> +	}
> +
> +	clk_rate = clk_get_rate(ufs->core_clk);
> +	if (!clk_rate) {
> +		dev_err(dev, "Failed to get valid clock rate.\n");
> +		return -EINVAL;
> +	}
> +
> +	one_us_tick = ufs_s32n_calculate_us_tick(clk_rate);
> +	if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
> +		dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
> +			one_us_tick, clk_rate);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
> +		 clk_rate, one_us_tick);
> +
> +	/*
> +	 * Configure the micro-second tick rate generator based on core
> +	 * clock rate.
> +	 */
> +	writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
> +	ufshcd_dwc_program_clk_div(hba, one_us_tick);
> +
> +	return 0;
> +}
> +
> +static int ufs_s32n_phy_initial_calib(struct ufs_hba *hba)
> +{
> +	static const struct phy_reg_cfg initial_calib[] = {
> +		{ FAST_FLAGS(0), 0x6 },
> +		{ FAST_FLAGS(1), 0x6 },
> +		{ RX_DAC_CTRL_OVRD(0), 0x1 },
> +		{ RX_DAC_CTRL_OVRD(1), 0x1 },
> +		{ RX_DAC_CTRL(0), 0x8E },
> +		{ RX_DAC_CTRL(1), 0x91 },
> +		{ RX_DAC_CTRL_SEL(0), 0x1 },
> +		{ RX_DAC_CTRL_SEL(1), 0x1 },
> +		{ RX_DAC_CTRL_EN(0), 0x1 },
> +		{ RX_DAC_CTRL_EN(1), 0x1 },
> +		{ RX_DAC_CTRL_OVRD(0), 0x0 },
> +		{ RX_DAC_CTRL_OVRD(1), 0x0 },
> +		{ RX_DAC_CTRL_OVRD(0), 0x1 },
> +		{ RX_DAC_CTRL_OVRD(1), 0x1 },
> +		{ RX_DAC_CTRL(0), 0x71 },
> +		{ RX_DAC_CTRL(1), 0x7F },
> +		{ RX_DAC_CTRL_SEL(0), 0x2 },
> +		{ RX_DAC_CTRL_SEL(1), 0x2 },
> +		{ RX_DAC_CTRL_EN(0), 0x1 },
> +		{ RX_DAC_CTRL_EN(1), 0x1 },
> +		{ RX_DAC_CTRL_OVRD(0), 0x0 },
> +		{ RX_DAC_CTRL_OVRD(1), 0x0 },
> +		{ FW_CALIB_CCFG(0), 0x100 },
> +		{ FW_CALIB_CCFG(1), 0x100 },
> +	};
> +	int ret;
> +
> +	/* Clock Control */
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x80);
> +	if (ret)
> +		return ret;
> +
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +	if (ret)
> +		return ret;
> +
> +	/* Initial calibration sequence */
> +	return ufs_s32n_phy_write_sequence(hba, initial_calib,
> +					   ARRAY_SIZE(initial_calib));
> +}
> +
> +static int ufs_s32n_link_startup_pre_change(struct ufs_hba *hba)
> +{
> +	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
> +	struct device *dev = hba->dev;
> +	int ret;
> +	u32 reg;
> +
> +	/*
> +	 * There are two supported MPHY boot options implemented:
> +	 * - Running MPHY from internal FW ROM:
> +	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
> +	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
> +	 * - Skip M-PHY initialization when it is handled externally.
> +	 */
> +	if (ufs->mphy_boot_mode == MPHY_BOOT_NONE) {
> +		dev_dbg(dev, "Skipping UFS MPHY init.\n");
> +		return 0;
> +	}
> +
> +	ret = ufs_s32n_configure_clocks(hba);
> +	if (ret)
> +		return ret;
> +
> +	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
> +	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
> +	if (ufs->mphy_boot_mode == MPHY_BOOT_ROM) {
> +		/* ROM Mode. */
> +		writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
> +		       ufs->reg_scm + SCM_STATUS);
> +	}
> +
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1);
> +	if (ret)
> +		return ret;
> +
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +	if (ret)
> +		return ret;
> +
> +	/* Release PHY_RESET. */
> +	writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
> +	       ufs->reg_scm + SCM_STATUS);
> +
> +	/* Wait until SRAM_INIT_DONE = 1. */
> +	ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
> +			reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
> +			1000, CFG_MPHY_INIT_TIMEOUT_VALUE_US);
> +	if (ret) {
> +		dev_err(dev, "UFS MPHY init not done!\n");
> +		return ret;
> +	}
> +
> +	/* Start of initial calibration */
> +	ret = ufs_s32n_phy_initial_calib(hba);
> +	if (ret) {
> +		dev_err(dev, "UFS MPHY initial calibration failed!\n");
> +		return ret;
> +	}
> +
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
> +	if (ret)
> +		return ret;
> +
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +	if (ret)
> +		return ret;
> +
> +	/* Set Local DeviceID. */
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
> +	if (ret)
> +		return ret;

N_DEVICEID belong to network layer of Unipro, set DEVICEID in pre_change seems
too early. link startup still not done, so unipro link still not up.
I suggest to move this DEVICEID to post_change, and just before CPort, so that
the whole config sequence is: Mphy -> PA -> DL -> N -> T, from down to high.

> +
> +	/* End of Gear1 settings */
> +
> +	return ufshcd_check_hibern8(hba, hba->lanes_per_direction,
> +				    HBRN8_POLL_TOUT_MS);
> +}
> +
> +static int ufs_s32n_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val cport_setup[] = {
> +		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
> +				CPORT_IDLE, DME_LOCAL },
> +		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
> +				CPORT_DEF_FLAGS, DME_LOCAL },
> +		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
> +				CPORT_CONNECTED, DME_LOCAL },
> +	};
> +	static const struct phy_reg_cfg post_calib[] = {
> +		{ RX_OVRD_IN_1(0), 0xc },
> +		{ RX_OVRD_IN_1(1), 0xc },
> +		{ RX_OVRD_IN_1(0), 0x8 },
> +		{ RX_OVRD_IN_1(1), 0x8 },
> +		{ RX_OVRD_IN_1(0), 0x0 },
> +		{ RX_OVRD_IN_1(1), 0x0 },
> +	};
> +	struct s32n_ufs *ufs = ufshcd_get_variant(hba);
> +	unsigned int data = 0;
> +	int ret;
> +
> +	if (ufs->mphy_boot_mode == MPHY_BOOT_NONE)
> +		return 0;
> +
> +	/* Set Connection State to IDLE (it allows CPort Attributes to be set). */
> +	ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
> +	if (ret)
> +		return ret;
> +
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
> +	if (ret)
> +		return ret;
> +
> +	if (data != CPORT_CONNECTED)
> +		return -EIO;
> +
> +	/* Post Link Startup Calibration sequence */
> +	ret = ufs_s32n_phy_write_sequence(hba, post_calib,
> +					   ARRAY_SIZE(post_calib));
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Performing MPHY configuration for rate change:
> +	 * CB rate selection: 0 - rate A, 1 - rate B;
> +	 */
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), 0x1);
> +	if (ret)
> +		return ret;
> +
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +	if (ret)
> +		return ret;

Should the rate change operation be moved before post link startup calibration sequence?
in post link startup calibration sequence, it reset the RX CDR, but thie CDR reset should be
based on the target rate B, right? If do the RX CDR reset first, it is based on rate A, then
when swithc to rate B, seems need this RX CDR reset again.

Another question is why need to switch to rate B here in link_startup_post_change?
after link_startup_post_change, common code will call
ufshcd_dme_change_power_mode {
...
PA_HSSERIES = PA_HS_MODE_B;
PA_PWRMode = FAST_MODE << 4 | FAST_MODE;
...
}

In the standard DesignWare (DW) UFS IP design, when the PA_HSSERIES value in the PA layer
changes, the M-PHY rate selection register (CBRATESEL) is automatically synchronized by
hardware. No manual software intervention is required.

Does this rate B change here really necessary? or there are some hardware limitation on
S32N79?
> +
> +	/* End of Gear4 calibration */
> +	return 0;
> +}
> +
> +static int ufs_s32n_link_startup_notify(struct ufs_hba *hba,
> +			     enum ufs_notify_change_status status)
> +{
> +	int err;
> +
> +	if (status == PRE_CHANGE) {
> +		err = ufs_s32n_link_startup_pre_change(hba);
> +		if (err) {
> +			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
> +			return err;
> +		}
> +		return 0;
> +	}
> +
> +	/* POST_CHANGE */
> +	err = ufshcd_dwc_link_is_up(hba);
> +	if (err) {
> +		dev_err(hba->dev, "Link is not up.\n");
> +		return err;
> +	}
> +
> +	err = ufs_s32n_link_startup_post_change(hba);
> +	if (err)
> +		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
> +
> +	return err;
> +}
> +
> +static int ufs_s32n_init(struct ufs_hba *hba)
> +{
> +	struct device *dev = hba->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct device_node *np = dev->of_node;
> +	const char *mphy_boot_mode;
> +	struct s32n_ufs *ufs;
> +	int ret;
> +
> +	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
> +	if (!ufs)
> +		return -ENOMEM;
> +
> +	ufs->hba = hba;
> +	ufs->mphy_boot_mode = MPHY_BOOT_NONE;
> +
> +	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;

why broken auto hibernate here? or meet any issue when enable auto hibernate?
Better to add a comment here.

> +	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
> +	hba->spm_lvl = UFS_PM_LVL_5;

Any reason why not support LVL_6? Does this chip do not support reset pin?

Regards
Haibo Chen
> +
> +	ret = of_property_read_string(np, "nxp,mphy-boot-mode", &mphy_boot_mode);
> +	if (ret || !mphy_boot_mode) {
> +		dev_dbg(dev,
> +			"nxp,mphy-boot-mode property not found. UFS MPHY init will be skipped.\n");
> +		goto init_out;
> +	}
> +
> +	if (!strcmp(mphy_boot_mode, "rom")) {
> +		ufs->mphy_boot_mode = MPHY_BOOT_ROM;
> +	} else {
> +		return dev_err_probe(dev, -EINVAL,
> +				     "Unrecognized nxp,mphy-boot-mode property. UFS MPHY init will be skipped.\n");
> +	}
> +
> +	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
> +	if (IS_ERR(ufs->reg_scm))
> +		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
> +				     "ioremap failed for SCM registers.\n");
> +
> +	ufs->core_clk = devm_clk_get(dev, "core_clk");
> +	if (IS_ERR(ufs->core_clk))
> +		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
> +				     "Failed to get core clock.\n");
> +
> +init_out:
> +	ufshcd_set_variant(hba, ufs);
> +
> +	return 0;
> +}
> +
> +static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
> +	.name = "s32n79",
> +	.init = ufs_s32n_init,
> +	.link_startup_notify = ufs_s32n_link_startup_notify,
> +};
> +
> +static const struct of_device_id ufs_s32n7_match[] = {
> +	{
> +		.compatible = "nxp,s32n79-ufshc",
> +		.data = &ufs_hba_s32n79_vops,
> +	},
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
> +
> +static int ufs_s32n7_probe(struct platform_device *pdev)
> +{
> +	const struct ufs_hba_variant_ops *vops;
> +
> +	vops = device_get_match_data(&pdev->dev);
> +	if (!vops)
> +		return -ENODEV;
> +
> +	return ufshcd_pltfrm_init(pdev, vops);
> +}
> +
> +static void ufs_s32n7_remove(struct platform_device *pdev)
> +{
> +	ufshcd_pltfrm_remove(pdev);
> +}
> +
> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> +	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> +	.prepare	= ufshcd_suspend_prepare,
> +	.complete	= ufshcd_resume_complete,
> +};
> +
> +static struct platform_driver ufs_s32n7_driver = {
> +	.probe = ufs_s32n7_probe,
> +	.remove = ufs_s32n7_remove,
> +	.driver	= {
> +		.name	= "ufs-s32n7",
> +		.pm	= &ufs_s32n7_pm_ops,
> +		.of_match_table	= ufs_s32n7_match,
> +	},
> +};
> +
> +module_platform_driver(ufs_s32n7_driver);
> +
> +MODULE_AUTHOR("Larisa Grigore <larisa.grigore@oss.nxp.com>");
> +MODULE_DESCRIPTION("NXP S32N7 UFS Host Controller platform driver");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index 53b523ef59df..747383cfb839 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -13,8 +13,7 @@
>  #include <ufs/ufshcd.h>
>  
>  /* RMMI Attributes */
> -#define CBREFCLKCTRL2		0x8132
> -#define CBCRCTRL		0x811F
> +#define RXSQCONTROL		0x8009
>  #define CBC10DIRECTCONF2	0x810E
>  #define CBRATESEL		0x8114
>  #define CBCREGADDRLSB		0x8116
> @@ -24,10 +23,16 @@
>  #define CBCREGRDLSB		0x811A
>  #define CBCREGRDMSB		0x811B
>  #define CBCREGRDWRSEL		0x811C
> +#define CBCRCTRL		0x811F
> +#define CBREFCLKCTRL2		0x8132
>  
>  #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
>  
>  /* M-PHY registers */
> +#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
> +#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
> +#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
> +#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
>  #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
>  #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
>  #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
> -- 
> 2.43.0
> 
