Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010007.outbound.protection.outlook.com [52.101.69.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73F2403B18;
	Wed, 26 Aug 2026 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787759393; cv=fail; b=PtsKffhbovFV2Se54xEyjnOy1EAlxbiTejCFRukduje8/r+uPVjzy5XOYGFF1Ahp05+GR9HF27MxgYwmZDdEFsFOVYHocCfw0zT1KqDPqBNM2isWwLWPG8W8HMVG97tun6iqYuMjU02wyYrj9d17vZd+b2LmqLaHfR0ukCdYwhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787759393; c=relaxed/simple;
	bh=ibw5xmtOuIpLK8jnKymQ0U3Iw522/uMxkvKwo2FuGgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AedWG6pT+EY4VNX1BCPVL87wTCTldxhigRylJFvI7J2Kx0ut20ZomB062QYZmHmjJG4Vi38f2w/YvZSRF0/hig0i/6YwllvMrHAcgX+83KIXk9IPqZVOK61tehQiAK6bx3R2YU39aPOJAL+SqEG/2Bs8ee/+8Am2W7d1KolUKVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Wnju+SK2; arc=fail smtp.client-ip=52.101.69.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Wnju+SK2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+1rgh3P1POnz1D3moeJIFe+jG3w19Jk25pm4ZEJaWHSs1sdchteVPKVWo46UAJpGBZQZMx72vt7jd1iu3/OyhePQbvxCQwZ3G0nRi7zv1795F+Tfx8lEo/W/qlQycEBrNCjdnPpqZwnCO7sw1DThE2r4jqRymB+fCM9qtx+17NT8RlKv5V5y3QZI00lzKhGASTeU1A+Cs7WTAintIu6419JcejxCr4iZ0a6HLmJEVRDfxuLDfd6n+Sr571gJ8bVW5kE4JnI26N8DTH6p2Kt5wK+0e8/ytdzTdnMJcIt/dihS6lNBxQYf0S2dbGVssQMjIBJqSrUFYJfceag4BZg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K58cuNKmjvKI+C6F3bg4Pj11oyIDqo3NW0pPrqlnZUk=;
 b=vO/0bhhpZMOJtjPK/o41ddbg3tPmN65xh8qqlJJ4jkfS1r9LyLr5k2tpPCgjYpy9AcAwNA9i3wM9IiShU1mIiH4a7Kjm+4pvcJPw+Mhf0izmTENmSQs/HLwsOzyvGyBCIgiM9aoh0MEiWz96d05f7GOCDzOJOWe5ACHiDt9l6Uax8yP2oSpTaFtjHSyiuaBp/y94syBRTlFeuKIF02ORDc3T2pS4T0O6W0M+2SUb4ZwcXPQslHmiMtBFGhxscCZfovyvXnEof1W9uPATcNdVP+ixNlDev7AwULkJREYrFblrm6mTTCsy4Maub+2HW6xy66nyE9F+NJs77B+/AoYCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K58cuNKmjvKI+C6F3bg4Pj11oyIDqo3NW0pPrqlnZUk=;
 b=Wnju+SK2jWADTknDV084iqtuw1CE7OcM2v61Ob4mJWb4WsaVPqTiS/BJhficfE434ZgR1Sv8bG/zqNRPKnL6TrmzK5j0evNGjDmOJZ1C9JKUKB8XR39ldO9DZOtvQY+hAsI3jq0Uhqhc8ziuRHMgkOlmKdEOk6WvZjaHGjjgkWrQqHdbxiZl96aJpqoGOEyMAO7EX8HP3WAeSLX6QCbVLBpZo9N8gIHjYJHHYtysHmBQE2pfCQOtIFFvZz9TijxDXbJdeXF2KDAKfo52CggANxH8Zwyha8CZ6K6qs7SjdUr9qwsSefE1zvuJo0vyvOqZ/lZNJG2S0kVgA34IFuX/Jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DBAPR04MB7429.eurprd04.prod.outlook.com (2603:10a6:10:1a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 15:49:46 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 15:49:46 +0000
Date: Wed, 26 Aug 2026 10:49:27 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
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
Message-ID: <ao8LBwXonNzjSQZ9@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-8-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH8P221CA0058.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:349::7) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DBAPR04MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e710d78-5695-4099-9142-08df0389a6eb
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|23010399003|19092799006|7416014|366016|1800799024|6133799003|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 livE95csRtKnZz+Z8uJysqzk/CWpSSOXcVlUMkOx7MQy4tcJ+47UdY23dRlwf9cmsfvRQyg+IlIaSuuunmmIqlxlqPXYGTJ32Mft9kBU4nRwxIf2A5fPV5VDoFXqSJg6vQgw87oheGKeswHCcrXlvCKpLQlFvXWnR6waNWLy6/o8gIHCNA+qSewOupfcXYcwvHeF3nA2VJBtEiXSOVIexmOyL7q3dZWIueLil8t/0P6wlu7wDchowIHhNQMCo2+LgfZ7IvObqvydTN62ip+H8UwvPrGHHTzRBlR0jiowrwR5JPev8I1WrAUC3KfSBr9tmUdZFCJ01y2N1TS9NpXSSgHYdgGTVPO+qe+kvmLjke4DhjmMLFF5GkfztEFjtP5CmS6YKiWkyGzgYIa4nuE6rQf8qS8Hu42bHVDgikqbL82OLGBu75rBQSqLYIYe997yWpdF57yE/J/IfBQzgaRkhpaOr4GGYY4xOyyMvkncoqReHzAC8OVtsAljOKQG7LzRLdusdR+BDXcxSkpX6les/+Gn+YDHYFwNYCpIErYLp0bboowh3+dmo6VxysT/VqOCLM9cISmKqrBzT187424NwUq78OtlY6R8TdEKt+x+HHrzz5GUiwJTO4jW3pYFE2aU8R5rhl1obPW7ZIIAWPjHH9Imt+/BCGa+4yskhX8lGVQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(7416014)(366016)(1800799024)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?7wwC+BYuRpO0gPR4DtNCXUmdvtYJvfLUdDwicXeqzJ4rayjfENlUdmuscN5Y?=
 =?us-ascii?Q?lImi0cdx1k3emSHDcsHeUAJnclLGvmMyFOiN2uxaxsg4PjWsdGY48jyUiZjZ?=
 =?us-ascii?Q?xWCv1malJ2Qc3F7S9T9oJZD0Jiw3TxQh4K3H3Xos+6SoeTX8z7v43FDQ73lN?=
 =?us-ascii?Q?hRaurLtZrVOBmICnkrOCZ5x780Q9VuWkV9sd1zqFSVcCEeEA6M549DNJgGv8?=
 =?us-ascii?Q?9VdyDzPvcuEGw2HKh8AXMFC5JiCuYRmOh35As/y94gGJ7ZpvGHW4FW5aTK7D?=
 =?us-ascii?Q?Wt16s3yVutZzM6Ro/HaDi3k4JkJr26SjfQzTzQHj8lFjdWQy2CaA6pFXJSHA?=
 =?us-ascii?Q?3Sb8ZxnwM9J1DJ4O+BHNsqniN+1y7A2JmGcZYIPVD4h/X8Z4jrosTfaZEAfD?=
 =?us-ascii?Q?y3px0ZpMORSPbvSxVSnmJFLUwsLwDkKRqbqMnWT0F5yjovP5hHPiQCU6uf3K?=
 =?us-ascii?Q?o8ndM6Dud9tCeLhAZwKlyNvEZW2fVibEV7n09zeOykgMHqg4SzJsNTkgrI/C?=
 =?us-ascii?Q?9dafL2nfV8KgBAtLLZwj2ISzxQ4/L6M8ihyoiMotS9qKGcbIJ8dUY19Bac1A?=
 =?us-ascii?Q?kVd7QU7jYrcrHOS/avEcTYrzUZK+89HQ7eBl9+qCaOR3SAFZ7PmXYBHJDI3L?=
 =?us-ascii?Q?HkpGB/bvSW2Xszu307GNKOYFGkY8bvvL8Vn9dDUouSUhAw5o3n3nE+7KnUdE?=
 =?us-ascii?Q?8W7hSilQPor1raO1d5jBA1Z0OBqf9k1HzicUr22Q8PVd53DQXzp914+gR+EP?=
 =?us-ascii?Q?9nbtYceRlGuP27E6FkbxmMfqKk6CotzbEIsWjiVNFhPfMTJEcAppn8YU+X62?=
 =?us-ascii?Q?bl4xU7ixdmrJ3edqRfW44dOgpQHJDDygnCda+zRXM6K/Ygyuv3sX3Zk09oKq?=
 =?us-ascii?Q?qXQxKBeznphnfnKZPjOdXgDSjj0oyszS6erYTWFDwJNNYy3K5HGxydiO57xS?=
 =?us-ascii?Q?12X+T4iKd9cLD+tDZtFsDk7GxlnWZclMj8Y3Zx9yW+eWD5GibpbSoboaugoX?=
 =?us-ascii?Q?hlKP1WnTTWqP4O6Dwm0cuHh94R6S/0MWeHmXuIDO6snM/Is4h5fQvraTg++M?=
 =?us-ascii?Q?UCW5bahzFwouCsRtsC2GSQPCDp0NS8Nzi+TmKe6K8T/JYszZF9pLXQ17Lz1t?=
 =?us-ascii?Q?fScnVUc5FPZnfB3QykPHt6kkY8/3ShG5ZmA9ujzw7/GyxCntc2uX+nXDKRe7?=
 =?us-ascii?Q?oO/JfESwA08BSKA0xzrA4+T31u+cEQzKHQv4hDnqfgkBvbz12GIB57uToswH?=
 =?us-ascii?Q?0/5dD9ZzmJ9THy5DbXWBCSuUiiclLkIIX8J5l2U3sk9aMgOUg8Tkn4h/DSlp?=
 =?us-ascii?Q?f2spUbZ0fHptHzs2cL7Dn5PjUrrqRBtxa0acXfBty50kKCNrHnC17Ua+68KK?=
 =?us-ascii?Q?ceWkJeaGKnF1i3I3owjaFKMsp2CHbESFc1y1YztDthu6ApbnT+KbNabWMu5C?=
 =?us-ascii?Q?2CndH9h5mY7zgv/tVp8d71/tvKn3HhdcKXVoM+Ko2uR2uxsMOoVEgSEp3yi2?=
 =?us-ascii?Q?MuywspcPT8Zt32wjj3nwo165rX/Y4kxtLY3R7aKWeZYpGqRcGyT6SmHPsZSn?=
 =?us-ascii?Q?kWrNUUQ2KCqV7VT/yyJFRDRSyvb4VFFAgDnWzlJRPj9SdeVdZONMCg8BvZXf?=
 =?us-ascii?Q?e9RAaOM/wk0Y8wIvSIleESsown0Lt0tOY27dXl2LkaxLBlSFZwHNVx+QmVED?=
 =?us-ascii?Q?1dI1YPRx3RYTAfdloL3qCmJBfTAcRTIVxmNMyHkRg8D2gBEE8FU+K4Qbdq2U?=
 =?us-ascii?Q?k0bpMmwJDuT9KCkENDfXYzIt9LtNjzdHJq4IynNTotTqkXvDiA6m?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e710d78-5695-4099-9142-08df0389a6eb
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 15:49:46.0032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvcSXrgi6f9j4aLu95Ov0F58dvVgUY8ksLFkdagmI6zEe0l4r6WnN1fLGCfNlYvjhsoqydvwPNiywCKMJ1pKVlQXNRU+IlpOW2f5gCh3RDaHt4feZx3Ubth58NHASklh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7429

On Wed, Aug 26, 2026 at 03:40:45PM +0200, Larisa Grigore wrote:
>
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

Is "simulation environment" productionable?

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
>           Select this if you have UFS controller on AMD Versal Gen 2 SoC.
>           If unsure, say N.
> +
> +config SCSI_UFS_S32N7
> +       tristate "NXP S32N7 platform driver"
> +       depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
> +       help
> +         This selects the S32N7 specific additions on top of the UFSHCD DWC
> +         and UFSHCD platform driver. UFS host on S32N79 needs some vendor
> +         specific configurations like PHY and vendor specific register accesses
> +         before accessing the hardware.
> +
> +         Select this if you have UFS controller on an S32N7 based board.
> +         If unsure, say N.
> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
> index 65d8bb23ab7b..0381750a35d3 100644
> --- a/drivers/ufs/host/Makefile
> +++ b/drivers/ufs/host/Makefile
> @@ -2,6 +2,7 @@
>
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
> +obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o

It is not related with your patch, but multi ufshcd-dwc.o may link many
times if other ufs host driver also build, modern link can remove duplicate
symbal, but not sure what happen if one build as module, one buildin.

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
> +#define SCM_ONE_US_TICK                        0x2CU
> +#define SCM_STATUS                     0x30
> +
> +/* SCM_ONE_US_TICK Register. */
> +#define SCM_ONE_US_TICK_MASK           GENMASK(8, 0)
> +
> +/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
> +#define SCM_STATUS_PHY_RESET_MASK              BIT(0)
> +#define SCM_STATUS_SRAM_BYPASS_MASK            BIT(1)
> +#define SCM_STATUS_SRAM_INIT_DONE_MASK         BIT(16)
> +
> +#define SCM_STATUS_PHY_RESET(val)              \
> +       FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
> +
> +#define SCM_STATUS_SRAM_BYPASS(val)            \
> +       FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
> +
> +/* Timeout values. */
> +#define CFG_MPHY_INIT_TIMEOUT_VALUE_US 3000000
> +
> +/* Clock validation limits. */
> +#define MAX_VALID_ONE_US_TICK          SCM_ONE_US_TICK_MASK
> +
> +/* CPort definitions */
> +#define CPORT_0                                0
> +
> +/* Hibern8 state poll timeout. */
> +#define HBRN8_POLL_TOUT_MS      1000

Does this value is spec defined or just engineering choose?

> +
> +/**
> + * enum mphy_boot_mode - MPHY boot mode options
> + * @MPHY_BOOT_NONE: Skip MPHY initialization
> + * @MPHY_BOOT_ROM: Running MPHY from internal FW ROM
> + */
> +enum mphy_boot_mode {
> +       MPHY_BOOT_NONE = 0,
> +       MPHY_BOOT_ROM = 1,
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
> +       struct ufs_hba *hba;
> +       void __iomem *reg_scm;
> +       struct clk *core_clk;
> +       enum mphy_boot_mode mphy_boot_mode;
> +};
> +
> +/**
> + * struct phy_reg_cfg - PHY register configuration entry
> + * @reg: Register offset/address
> + * @val: Value to write
> + */
> +struct phy_reg_cfg {
> +       u32 reg;
> +       u32 val;
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
> +                                      const struct phy_reg_cfg *cfg,
> +                                      size_t count)
> +{
> +       int ret;
> +       size_t i;
> +
> +       for (i = 0; i < count; i++) {
> +               ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
> +               if (ret) {
> +                       dev_err(hba->dev,
> +                               "Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
> +                               cfg[i].reg, cfg[i].val, i);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static unsigned long ufs_s32n_calculate_us_tick(unsigned long clk_rate)
> +{
> +       return clk_rate / USEC_PER_SEC;
> +}
> +
> +static int ufs_s32n_configure_clocks(struct ufs_hba *hba)
> +{
> +       struct s32n_ufs *ufs = ufshcd_get_variant(hba);
> +       struct device *dev = hba->dev;
> +       unsigned long clk_rate = 0;
> +       unsigned long one_us_tick;
> +
> +       if (!ufs->core_clk) {

suppose return failure at probe if no core_clk, needn't check here

> +               dev_err(dev, "Invalid core_clk.\n");
> +               return -EINVAL;
> +       }
> +
> +       clk_rate = clk_get_rate(ufs->core_clk);
> +       if (!clk_rate) {
> +               dev_err(dev, "Failed to get valid clock rate.\n");
> +               return -EINVAL;
> +       }
> +
> +       one_us_tick = ufs_s32n_calculate_us_tick(clk_rate);
> +       if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
> +               dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
> +                       one_us_tick, clk_rate);
> +               return -EINVAL;
> +       }
> +
> +       dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
> +                clk_rate, one_us_tick);
> +
> +       /*
> +        * Configure the micro-second tick rate generator based on core
> +        * clock rate.
> +        */
> +       writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
> +       ufshcd_dwc_program_clk_div(hba, one_us_tick);
> +
> +       return 0;
> +}
> +
> +static int ufs_s32n_phy_initial_calib(struct ufs_hba *hba)
> +{
> +       static const struct phy_reg_cfg initial_calib[] = {
> +               { FAST_FLAGS(0), 0x6 },
> +               { FAST_FLAGS(1), 0x6 },
> +               { RX_DAC_CTRL_OVRD(0), 0x1 },
> +               { RX_DAC_CTRL_OVRD(1), 0x1 },
> +               { RX_DAC_CTRL(0), 0x8E },
> +               { RX_DAC_CTRL(1), 0x91 },
> +               { RX_DAC_CTRL_SEL(0), 0x1 },
> +               { RX_DAC_CTRL_SEL(1), 0x1 },
> +               { RX_DAC_CTRL_EN(0), 0x1 },
> +               { RX_DAC_CTRL_EN(1), 0x1 },
> +               { RX_DAC_CTRL_OVRD(0), 0x0 },
> +               { RX_DAC_CTRL_OVRD(1), 0x0 },
> +               { RX_DAC_CTRL_OVRD(0), 0x1 },
> +               { RX_DAC_CTRL_OVRD(1), 0x1 },
> +               { RX_DAC_CTRL(0), 0x71 },
> +               { RX_DAC_CTRL(1), 0x7F },
> +               { RX_DAC_CTRL_SEL(0), 0x2 },
> +               { RX_DAC_CTRL_SEL(1), 0x2 },
> +               { RX_DAC_CTRL_EN(0), 0x1 },
> +               { RX_DAC_CTRL_EN(1), 0x1 },
> +               { RX_DAC_CTRL_OVRD(0), 0x0 },
> +               { RX_DAC_CTRL_OVRD(1), 0x0 },
> +               { FW_CALIB_CCFG(0), 0x100 },
> +               { FW_CALIB_CCFG(1), 0x100 },
> +       };

Can you put this data to platform data in case difference data for differe
soc in future?

> +       int ret;
> +
> +       /* Clock Control */
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x80);
> +       if (ret)
> +               return ret;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +       if (ret)
> +               return ret;
> +
> +       /* Initial calibration sequence */
> +       return ufs_s32n_phy_write_sequence(hba, initial_calib,
> +                                          ARRAY_SIZE(initial_calib));
> +}
> +
> +static int ufs_s32n_link_startup_pre_change(struct ufs_hba *hba)
> +{
> +       struct s32n_ufs *ufs = ufshcd_get_variant(hba);
> +       struct device *dev = hba->dev;
> +       int ret;
> +       u32 reg;
> +
> +       /*
> +        * There are two supported MPHY boot options implemented:
> +        * - Running MPHY from internal FW ROM:
> +        *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
> +        *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
> +        * - Skip M-PHY initialization when it is handled externally.
> +        */
> +       if (ufs->mphy_boot_mode == MPHY_BOOT_NONE) {
> +               dev_dbg(dev, "Skipping UFS MPHY init.\n");
> +               return 0;
> +       }
> +
> +       ret = ufs_s32n_configure_clocks(hba);
> +       if (ret)
> +               return ret;
> +
> +       /* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
> +       writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
> +       if (ufs->mphy_boot_mode == MPHY_BOOT_ROM) {
> +               /* ROM Mode. */
> +               writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
> +                      ufs->reg_scm + SCM_STATUS);
> +       }
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1);
> +       if (ret)
> +               return ret;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +       if (ret)
> +               return ret;
> +
> +       /* Release PHY_RESET. */
> +       writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
> +              ufs->reg_scm + SCM_STATUS);
> +
> +       /* Wait until SRAM_INIT_DONE = 1. */
> +       ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
> +                       reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
> +                       1000, CFG_MPHY_INIT_TIMEOUT_VALUE_US);
> +       if (ret) {
> +               dev_err(dev, "UFS MPHY init not done!\n");
> +               return ret;
> +       }
> +
> +       /* Start of initial calibration */
> +       ret = ufs_s32n_phy_initial_calib(hba);
> +       if (ret) {
> +               dev_err(dev, "UFS MPHY initial calibration failed!\n");
> +               return ret;
> +       }
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
> +       if (ret)
> +               return ret;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +       if (ret)
> +               return ret;
> +
> +       /* Set Local DeviceID. */
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
> +       if (ret)
> +               return ret;
> +
> +       /* End of Gear1 settings */
> +
> +       return ufshcd_check_hibern8(hba, hba->lanes_per_direction,
> +                                   HBRN8_POLL_TOUT_MS);
> +}
> +
> +static int ufs_s32n_link_startup_post_change(struct ufs_hba *hba)
> +{
> +       static const struct ufshcd_dme_attr_val cport_setup[] = {
> +               { UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
> +                               CPORT_IDLE, DME_LOCAL },
> +               { UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
> +                               CPORT_DEF_FLAGS, DME_LOCAL },
> +               { UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
> +                               CPORT_CONNECTED, DME_LOCAL },
> +       };
> +       static const struct phy_reg_cfg post_calib[] = {
> +               { RX_OVRD_IN_1(0), 0xc },
> +               { RX_OVRD_IN_1(1), 0xc },
> +               { RX_OVRD_IN_1(0), 0x8 },
> +               { RX_OVRD_IN_1(1), 0x8 },
> +               { RX_OVRD_IN_1(0), 0x0 },
> +               { RX_OVRD_IN_1(1), 0x0 },
> +       };
> +       struct s32n_ufs *ufs = ufshcd_get_variant(hba);
> +       unsigned int data = 0;
> +       int ret;
> +
> +       if (ufs->mphy_boot_mode == MPHY_BOOT_NONE)
> +               return 0;
> +
> +       /* Set Connection State to IDLE (it allows CPort Attributes to be set). */
> +       ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
> +       if (ret)
> +               return ret;
> +
> +       ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
> +       if (ret)
> +               return ret;
> +
> +       if (data != CPORT_CONNECTED)
> +               return -EIO;
> +
> +       /* Post Link Startup Calibration sequence */
> +       ret = ufs_s32n_phy_write_sequence(hba, post_calib,
> +                                          ARRAY_SIZE(post_calib));
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * Performing MPHY configuration for rate change:
> +        * CB rate selection: 0 - rate A, 1 - rate B;
> +        */
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), 0x1);
> +       if (ret)
> +               return ret;
> +
> +       ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
> +       if (ret)
> +               return ret;
> +
> +       /* End of Gear4 calibration */
> +       return 0;
> +}
> +
> +static int ufs_s32n_link_startup_notify(struct ufs_hba *hba,
> +                            enum ufs_notify_change_status status)
> +{
> +       int err;
> +
> +       if (status == PRE_CHANGE) {
> +               err = ufs_s32n_link_startup_pre_change(hba);
> +               if (err) {
> +                       dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
> +                       return err;
> +               }
> +               return 0;
> +       }
> +
> +       /* POST_CHANGE */
> +       err = ufshcd_dwc_link_is_up(hba);
> +       if (err) {
> +               dev_err(hba->dev, "Link is not up.\n");
> +               return err;
> +       }
> +
> +       err = ufs_s32n_link_startup_post_change(hba);
> +       if (err)
> +               dev_err(hba->dev, "Connection setup failed (%d).\n", err);
> +
> +       return err;
> +}
> +
> +static int ufs_s32n_init(struct ufs_hba *hba)
> +{
> +       struct device *dev = hba->dev;
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct device_node *np = dev->of_node;
> +       const char *mphy_boot_mode;
> +       struct s32n_ufs *ufs;
> +       int ret;
> +
> +       ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
> +       if (!ufs)
> +               return -ENOMEM;
> +
> +       ufs->hba = hba;
> +       ufs->mphy_boot_mode = MPHY_BOOT_NONE;
> +
> +       hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
> +       hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
> +       hba->spm_lvl = UFS_PM_LVL_5;
> +
> +       ret = of_property_read_string(np, "nxp,mphy-boot-mode", &mphy_boot_mode);
> +       if (ret || !mphy_boot_mode) {
> +               dev_dbg(dev,
> +                       "nxp,mphy-boot-mode property not found. UFS MPHY init will be skipped.\n");
> +               goto init_out;
> +       }
> +
> +       if (!strcmp(mphy_boot_mode, "rom")) {
> +               ufs->mphy_boot_mode = MPHY_BOOT_ROM;
> +       } else {
> +               return dev_err_probe(dev, -EINVAL,
> +                                    "Unrecognized nxp,mphy-boot-mode property. UFS MPHY init will be skipped.\n");
> +       }
> +
> +       ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
> +       if (IS_ERR(ufs->reg_scm))
> +               return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
> +                                    "ioremap failed for SCM registers.\n");
> +
> +       ufs->core_clk = devm_clk_get(dev, "core_clk");
> +       if (IS_ERR(ufs->core_clk))
> +               return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
> +                                    "Failed to get core clock.\n");
> +
> +init_out:
> +       ufshcd_set_variant(hba, ufs);
> +
> +       return 0;
> +}
> +
> +static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
> +       .name = "s32n79",
> +       .init = ufs_s32n_init,
> +       .link_startup_notify = ufs_s32n_link_startup_notify,
> +};
> +
> +static const struct of_device_id ufs_s32n7_match[] = {
> +       {
> +               .compatible = "nxp,s32n79-ufshc",
> +               .data = &ufs_hba_s32n79_vops,
> +       },
> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
> +
> +static int ufs_s32n7_probe(struct platform_device *pdev)
> +{
> +       const struct ufs_hba_variant_ops *vops;
> +
> +       vops = device_get_match_data(&pdev->dev);
> +       if (!vops)
> +               return -ENODEV;
> +
> +       return ufshcd_pltfrm_init(pdev, vops);
> +}
> +
> +static void ufs_s32n7_remove(struct platform_device *pdev)
> +{
> +       ufshcd_pltfrm_remove(pdev);
> +}
> +
> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> +       SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)

Use  SYSTEM_SLEEP_PM_OPS()

> +       .prepare        = ufshcd_suspend_prepare,
> +       .complete       = ufshcd_resume_complete,
> +};
> +
> +static struct platform_driver ufs_s32n7_driver = {
> +       .probe = ufs_s32n7_probe,
> +       .remove = ufs_s32n7_remove,
> +       .driver = {
> +               .name   = "ufs-s32n7",
> +               .pm     = &ufs_s32n7_pm_ops,

pm_ptr(&ufs_s32n7_pm_ops)

Frank

> +               .of_match_table = ufs_s32n7_match,
> +       },
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
> -#define CBREFCLKCTRL2          0x8132
> -#define CBCRCTRL               0x811F
> +#define RXSQCONTROL            0x8009
>  #define CBC10DIRECTCONF2       0x810E
>  #define CBRATESEL              0x8114
>  #define CBCREGADDRLSB          0x8116
> @@ -24,10 +23,16 @@
>  #define CBCREGRDLSB            0x811A
>  #define CBCREGRDMSB            0x811B
>  #define CBCREGRDWRSEL          0x811C
> +#define CBCRCTRL               0x811F
> +#define CBREFCLKCTRL2          0x8132
>
>  #define CBREFREFCLK_GATE_OVR_EN                BIT(7)
>
>  /* M-PHY registers */
> +#define RX_DAC_CTRL(n)         (0x10AF + ((n) * 0x100))
> +#define RX_DAC_CTRL_OVRD(n)    (0x10B0 + ((n) * 0x100))
> +#define RX_DAC_CTRL_SEL(n)     (0x10B1 + ((n) * 0x100))
> +#define RX_DAC_CTRL_EN(n)      (0x10B8 + ((n) * 0x100))
>  #define RX_OVRD_IN_1(n)                (0x3006 + ((n) * 0x100))
>  #define RX_PCS_OUT(n)          (0x300F + ((n) * 0x100))
>  #define FAST_FLAGS(n)          (0x401C + ((n) * 0x100))
> --
> 2.43.0
>
>
