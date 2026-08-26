Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013068.outbound.protection.outlook.com [40.107.162.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830FB41DEE5;
	Wed, 26 Aug 2026 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757744; cv=fail; b=mv5vzQ8V/nMul6I0GJc9/lNUWo8ulZw2DGnwulalAPWeIEYcCcWtLSJ60R4wmjGJRsIqBXHeFsyNlUAif4zrDYHGH9XiBW4kgG3rgzoZQRh7KNi/ipEo9lffXj2nfkAx+gB4xiKmuLni1JwsGeagkaVoCTvPE8QT1q253YnOXaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757744; c=relaxed/simple;
	bh=5qQaWXWwlar9luz41tUx3v66TuX8Ks8OxpaXFFS7FKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=etz7DY2Er02bu7VfhlDtaTcpyP8ksrDeEI1uDvJOoa/2mGRmbcuSL/SYKEtYHhTaKyG6XRV9wlwcz2Z1Fl5XAYU6YtbwvRvA3QUshKgjunkHJx51OBOR0JsrkFQRJ5XqfAj5NU8/PoELMKnHH5caoRChkEdL18mUvDi1uaVv9Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=hNyUx8Gi; arc=fail smtp.client-ip=40.107.162.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hNyUx8Gi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pA7nEfFXpBM1UxIe+NDTmvwgaU1mTqsbhF1KMa+XTE+HDmstUZwcIyEWwPn9nITY2+m8V/bCzjCAVaTBarBL0NmPJWBB4r7jGesp2SG75l8vGLNYvn1+Z1uIk/Fdi2BBY7ehNZbpEDxguHKl+gse4yXgn8n0JKlrttNbOpYITs8SKVb9mOJ51+i6oUDxSFPaDTb5oePY1o2Gs6r+6ZvOz59gNlfRBAxc8L14mY+1Rxtzf+ACf8Wue/J4BtKDpAP3ygOrGYOxliV+IBRZNlcJRkVASQF4pgfCUb4JVHd2u43UDSyzVnvilc7eapgMScA+uzUZjCRpjm55ewYfDy0Dvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7EhHsbAr8XiPbwlEanL8OLWNtNo3puW7/e3JmdAKcU=;
 b=m4FUDeKQIpP/l8v/NHRqskJzPoqh4NexX4hm3E1FK+X+I7iDqDBflvgnShbB9YEKSbBAat/AFquSZitFHMJcBj8AyydqMfD2lRxOVgpDh4h3A/KOoFyqPvfgUDLbG+tHz899gg06pqvAPKOlVtNs1k+naPqNJua06cu7ZKAR6gXJeobSB8rgtkdcXEm/uNCSaxy/Q/gnACLDkdiLwwF2G+I2mGNdm5vLTnQwz7v/PRELTb4TkiHuiF6uQXPgxmkXJgcIVZuaeXNqVH1CG9DuPplwjICkGE8geEholxkpdY1ZS9/l7GoWucqJrupgbUHaIoo8+TbZKVL8ey8NHAGezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7EhHsbAr8XiPbwlEanL8OLWNtNo3puW7/e3JmdAKcU=;
 b=hNyUx8GivXmT6cUm6B5vfbjOS16gnrPIYzFXGAc2bsBqhers5SogJMc0VAqKbl+pxD/AmPpSeRH/cv5EGytFw878HD+QCk5LkfyS210LPN/XepLuCyTKw8Q9MjEhyAP3RTj7Hxlno5WIkcIEKtQX+qQ5Semq9mBBLH8Yf9hl5Yk7R8+qAPhLkfKaXd43N+9INfDvAVRAG0ykner8JsO5TdQsSeWVXfNVFYrsRVwzKhEKdHTaxCPlW9LaN0tzXzCQUJl3LE0a9bybmH/pQVDxePOFK+2W2y3BOgHKUbym5dsFZS6GG8h1GmKdWRqpJGa8Ip4rzGFgdfM6rn+RkW0hYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB8PR04MB6825.eurprd04.prod.outlook.com (2603:10a6:10:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 15:22:20 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 15:22:20 +0000
Date: Wed, 26 Aug 2026 10:22:07 -0500
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
Subject: Re: [PATCH 05/10] scsi: ufs: dwc: Export common clock divider and
 link status helpers
Message-ID: <ao8En1LWAsgY6wzX@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-6-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-6-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SN7PR04CA0208.namprd04.prod.outlook.com
 (2603:10b6:806:126::33) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB8PR04MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee424a4-383f-4d70-6b7e-08df0385d1d7
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|23010399003|376014|7416014|10067099003|6133799003|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 +eZjSerIJD6UmEVjJ2i46rlQg+hEuLnJ4ELRzH/KptrxoitADHlw2ATgjFUQE7XaEnZqTUZC2bcx2Vmbu9PDkwuRny8Wpow6VNpjz3kaRDLocIC4NZ17HkNPRUe4jOHylfkix570rFXMrG1S5nB28DNSc1lLSjRFvSAkmVj+L6BbcZ57G2a94iAuhgzv+A8GJq/K8dV7uLcFAZUCCoOgvUmYShr8J2LbTq4pjUx5cxAUIbTPWhDhpBUNvidS+QgYGGf8UreLzrlSbHCaZlKg2VDq100eozJGByn/JdFu6YoIb2wUgGR5K8XWenGWZKS1cGlCiy5eYKdsFW73QaOkB1yxBJADyi0K8wSmMedShjyGKtXqz+Qx9cHtGtQKNOY4dPlTCMWgn02HJKfEVoeiOqwQnp/mS84uZgkn2wOwQ+HLPDagwIlsGdYGU60+pNh1p98JJrng/DMkdujQwlAHn6cQGKbvPac0QZQJ5EN61tum0MfFwjjvc6O4YnF6bDMHNZGU4AnKPP8JFFhmiM6ekH7hoN5kW7L5OgcXyAwlAWoeh0ilgMbUed2+QRQu1QKnqMIKKfLm4Fpt7w9NEzB10oKMoTGaznLIGAV3OvJWQungPG90MaVV/Y4DTQ87K5t5BNgRN3EmnbtMjAUDhl2PDH6EtAGB04uPR2Dwc7ZlUMk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(23010399003)(376014)(7416014)(10067099003)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?7/sNYD8eZzP9q37kBq3FUVUbblLnh/wWsh+Jk0XNZqTfs2mRcRxfEMkG0SPj?=
 =?us-ascii?Q?tUKAKLpxzvv8bOvfci13vWD9TbKPSwwEBplC4occFGG7FwZnbj2MvO6w7fdU?=
 =?us-ascii?Q?4G4ZcZgvX4023rkFZup47p6CUWy9mFVNnSQd/C2aT04N0i7MKbFWzcUxR1xe?=
 =?us-ascii?Q?gMfoghxoW36jAMXKU3CesadZR3N+5U8y7rPBXwoBkq58G9dpMWAuM/m+Ula9?=
 =?us-ascii?Q?6r4vEoE/wMLmdV9+Ba3opCeHshym54NcMkXukra6da6pQfjtcX5siYugUj3X?=
 =?us-ascii?Q?9eD05YulockqrIlsAwJRhR/YQ19T9tJFgZz3+TLIOkJRDdqIgdMCKszo4W0g?=
 =?us-ascii?Q?z2zCo9ADIT5I099/vXvAFR8ICma2A0GFTBzK/kKCsMUXEfzvVIvtWR8ME9c5?=
 =?us-ascii?Q?qxBJ82B5cYAb3GXkjr2N1v/swi86Xez2yHrCjZXHTJnGIRNjniya5j06QV1Q?=
 =?us-ascii?Q?gfoQhSzuf6EWja9kwGDFNyzBkIDXwD7q4HhUEVwIZDFky5lKzdCmMAofQU8u?=
 =?us-ascii?Q?JnPL1baN6NXGLibKrdpAVD9XP2whr5HWpsWmaAkW9x2KRcaHTmk6BvMbWJX/?=
 =?us-ascii?Q?818aAl/tlJRlHKlxGgibYx/f+Kj8IVUjpMm/0xRxuWBa/1beJ61hBynn2Mow?=
 =?us-ascii?Q?wu0+vlu9xgAAtM0r4JToQ+Prdj2MbneOtmVf3jEGRbJ0JKtMT1L/DrT0wllI?=
 =?us-ascii?Q?DsskPFeG9iSyltJkbVJq5wxmwL2Q8W/xWgbfAPwghf0UCSHA3IsB8sj3hFw+?=
 =?us-ascii?Q?LYI6H+56TA9RI6mHE+o96+qLCytrCf/ptBY3SIVK6irrx9M57ibashy9ZONa?=
 =?us-ascii?Q?Tv7rlhqTMe94cDGJvaJJT8JMmOVjmAT1VA1iILBXmQw6sVzoA70YTM/43Xw0?=
 =?us-ascii?Q?rEVYEaY3dbvZx1MOT8khJcwEgXXW91fcwEu/y77KodqbbXwoyVolwSzWbJxZ?=
 =?us-ascii?Q?dRipdBYVNbopnzeMrg8L6sGwnqj9//xn2D0YbQ5P0L8OiiH+ECOtHs1WXiVG?=
 =?us-ascii?Q?fFdh+6dx0z+cY/CaW7HRwXfxmnXp90nOpRrgpGNQ7lVwJXTIthl1kQROMsvd?=
 =?us-ascii?Q?HFRMNDPbGL5ftQd4OZj2G3RGme1vL3zRuMts9vjRgEuHSeyfDSLfZLl/MF0J?=
 =?us-ascii?Q?kl5/f4N6z6WcZ20Y2LfGaf8BIwxasU5ps7dzIBRp7dRfJOCcZisxOlsx/mWV?=
 =?us-ascii?Q?8V3rbbPrlePqpy3vYFYE6PSQ3LqnrNmlnedLvxSTPkRtTjZ+5+fN70nsrmGj?=
 =?us-ascii?Q?brABtXqb/hzuhxDDTAkNqTvpWTKsoEnwm+SGVeEkvUI/pMjNSQJ5G+b4PoSG?=
 =?us-ascii?Q?J7o9gpjxeoiXLrPgC2K8UPM4Ra7lr15a1+4/srT4Be69J8EbIJz/gXUVIoIc?=
 =?us-ascii?Q?Re9uNzHOOxU1WNq4UFdvY5yB4YCt/OiZficrGAY9VrYNB1EsEwTbKjj0mRWM?=
 =?us-ascii?Q?bHfp4pfIBDQmsKrMu9h1ulHTOzOsnmdYxdB3gp0+3V3ajJ2oNxFDL28iXtSK?=
 =?us-ascii?Q?2bQpitrSdE2MjyQRkCDvw2aKi6neWbrFlb1TF52F9SGEgr6ZsV1vCBqbliqV?=
 =?us-ascii?Q?5bkE81zJ2kC0oOK3PEWdILTQ1aFL5gttYcPui3LNnCiaZjAGGITqPXzYmu3X?=
 =?us-ascii?Q?6WdQovbWew3ywBLRs0BYeBwA7zjQSlQPaPXhfNuEkbqOxC2gW2t8HVmQqRSG?=
 =?us-ascii?Q?LcMZXxXIqw6jtNjTeqQTSx290L+iOfH068Z8CKHts+xbHO197ze5/dv1nS9K?=
 =?us-ascii?Q?DOMx3OJRB3EAlwZi0muyggnWR1rBPK9Xwkmd515PSQ2q0EZu3lqz?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee424a4-383f-4d70-6b7e-08df0385d1d7
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 15:22:19.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3wQkYBC7dHVDWLopAlxQ856g9prn3ELzwO2WBSP+EFY+To5XfSmoHnJEsjlVW7UZxWco/m+xomkX6RZWw22qW/Nk5M46oYVqPGy4Wnzhv5nG5mrNnM2UB9VD+YPmVQp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6825

On Wed, Aug 26, 2026 at 03:40:43PM +0200, Larisa Grigore wrote:
>
> Make ufshcd_dwc_program_clk_div() and ufshcd_dwc_link_is_up() available to
> DWC-based platform glue drivers. These helpers are needed by platform
> drivers that must program the controller HCLK divider and verify link state
> during their vendor-specific initialization flows.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/ufs/host/ufshcd-dwc.c | 6 ++++--
>  drivers/ufs/host/ufshcd-dwc.h | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
> index 45920793d1a8..4a689d211e81 100644
> --- a/drivers/ufs/host/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -39,10 +39,11 @@ EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
>   * @divider_val: clock divider value to be programmed
>   *
>   */
> -static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
> +void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
>  {
>         ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
>  }
> +EXPORT_SYMBOL(ufshcd_dwc_program_clk_div);
>
>  /**
>   * ufshcd_dwc_link_is_up() - check if link is up.
> @@ -50,7 +51,7 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
>   *
>   * Return: 0 on success, non-zero value on failure.
>   */
> -static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
> +int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
>  {
>         int dme_result = 0;
>
> @@ -63,6 +64,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
>
>         return 1;
>  }
> +EXPORT_SYMBOL(ufshcd_dwc_link_is_up);
>
>  /**
>   * ufshcd_dwc_connection_setup() - configure unipro attributes.
> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index d8673cd54d4c..53b523ef59df 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -47,4 +47,6 @@ int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
>                                 const struct ufshcd_dme_attr_val *v, int n);
>  int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
>  int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
> +int ufshcd_dwc_link_is_up(struct ufs_hba *hba);
> +void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val);
>  #endif /* End of Header */
> --
> 2.43.0
>
>
