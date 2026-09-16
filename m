Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011070.outbound.protection.outlook.com [40.107.130.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A8A4AAC4E;
	Wed, 16 Sep 2026 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575288; cv=fail; b=PKIMwW7Zv1Jl47kxeiNhA+lmGZQUFBYAAszjP0v8Go1u9MIpk07k0LpKz9glxa+QE95gDWzO/az0TZjPldHIEXl5EseqfGQXZia+GTDfXxTKDnBroOgqOOf34A4Bp4d8+KaRuy+c1i8vO6nnxDQl62gPMCKk0KlDBv7vVjuJs/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575288; c=relaxed/simple;
	bh=i35y5XdlTEdZi56LCoeroh517p27JzlvnaPfU8cjDdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OWFEkJMhgf7du98IUBhHzxnodktMe+nLa+JfovtENi+0GxYZHDSUK4CJrepBQlrAKouqNhwhtO0ETnPsF7HaPRfubDQGFlvNQDiVVEMpC8czWXKtmrxsY1agTZTuVWlcyM2hm48JafrdnHe6pRXmFNLnXJxiC2487EjOHhn15ec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SHtZfFJ2; arc=fail smtp.client-ip=40.107.130.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SHtZfFJ2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=krr3an8MAJgOfB76gJjTiuc8xSM7ZvDAKCl/sYc/6dUpQAGiS3qY4K+n/cvR28eNi7zFFQF3/NovqhoE39CYvVDVNEmLuaDyV3xgydNDwwx6X/KELBfRN2XiEFtRJHXQJCUvVzSebwueZW0XEpG0GVPmPfyJV84WqVbhe5lNKhTNG95pe+AFP8mFDw9HlEjo8ZMo98yL+7PAsqt0RrdgQajOo1XTbRX5S7MnkcfWvX83rsOD1B1KPPieC3TcxeLU0JU4pb6lMfvThi7Zpy3KF7Iil0IeiKjnW8YQorkOV34Jb//hfz0Y2Ao+Du6ZklpM+UfWFOnX1n+jt8MRKyEfgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pt2GMmq8I2JratckoCB+SY3Z/zgksw8qiMvd40TXSWc=;
 b=QDdtznyjJ97puZvCkN3Yt1maXsgvdxX/Z9KV7M9HNz6WbZt2XbboicWmHkuCU7FZaiH6nIW8m/hy60uGfOzJpoQ/b1UU5EXzCTiahU/NW3aMjqpzw4n7Lq1UF0k7dszTQcBlY8gmOxGyGnlZ/EeuAqA7r3Y4LDR8RitpnyBkguVQZ6Cipt0GGBO50LwY034RojwY/w0jzhAQ2it+Yxkyb1fynfQI1xS9RtUZYqUPizJvUfOFXkj/YWfWnGBnk+tpU0qX+U7yRSgvUDyTj+7X/9idFnh2Uo01rXuhqFG4s6+TIIcjcqvrttcG+ZOna6Z3giQNTll4SlveqWEQ6/AiBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pt2GMmq8I2JratckoCB+SY3Z/zgksw8qiMvd40TXSWc=;
 b=SHtZfFJ2B44pLtOTeqFPJlqaAVZ2g6oyhg7KlH1LnuSrreeegxbjfoFGmODWZnc3wgtcr+Pyny0d4WhOhuG0GGXiqh6nVMOpslAHQcnoNk4aB6N4aKppAUhv2Dqdj+ndXJ6bw6DcvOGVJS0d7rqrgg59WRsvTQr+hLGkffxjIqYSWUo6Tqf7LBCnAJt7CKM6xGu69h23GYTWm+O+X8uvYFdOYsRhHohkTkXt9B5DqZptDfidAy7AMfJBAPhuxBtYXfoiX2TmneQM7XyFLGDV9gYsJDb08OL85iW0c4ufJQvAFxy3889pqRLA63O+2CtZlN3atuQ2DxDXn9c1ZgziFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MRWPR04MB12041.eurprd04.prod.outlook.com (2603:10a6:501:93::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 16:14:42 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 16:14:42 +0000
Date: Wed, 16 Sep 2026 11:14:29 -0500
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
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa =?iso-8859-1?Q?=A0?= <pedrom.sousa@synopsys.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com, aruizrui@redhat.com, eballetb@redhat.com,
	echanude@redhat.com
Subject: Re: [PATCH v3 01/10] ufs: unipro: Move Tx/Rx FSM state definitions
 to unipro.h
Message-ID: <aqrAZfkcU29Oq7Jo@SMW015318>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-2-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916084411.941297-2-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH0PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:510:5::21) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MRWPR04MB12041:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3ad411-a4be-40e6-7fb5-08df140d9d8c
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|376014|23010399003|7416014|1800799024|366016|6133799003|22082099003|18002099003|4143699003|11063799006|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
 dFtrQHY9WNVVYEayQ/62z3dzFZh15WzxCO+b+kZcpW2ve+rbwV8YStzXP97D0RgZ4IWLNdC/2fTfBkctMkGYK+EFP+l94SdTlC6zZF5ijMX6nQmE04TZRpNv0Ww6KuXGsG+4bKGB8l8XaY4IsbdaoT85hcKpz8k+2NQmrl0VTNeq/AwOg6Ico8Z5WrW560pLg7ZAu5BfIRvgw2KVdCc5/BKvw4lcnXA0EIa0+321gmGS3OaNBPULWGdg6jWFwFcSc/U6OmhQ5gBarzKwo4VyH1M3Y5IamOcL2WSEqVM43fKTOGUL8edpBZ2FRUj6cPr0pXdiPKyWmSeWR3r/hr8rlbN4YpTR3XL++30VTj7ubcNLrdPdAdoEjwckVewRw8UbaQOkeULfZdcCWgHFRugbT7FG9FRriquhHYl2fTUFIkqtfBXs3CxBKFZh4ZOWjbN2qk4INcYaGIvYzEkbpWoOM54TTF9bmTu0Dq+LoUeGhKdRkMGmarUUntmrMVnP9wfl3i9u69hOds8oOBSFXld12qO+dfsch3y5l8/XTgEhvpXoXrQQ7JMUaV0BkBssD3BuDlnZztmOrYvOmlVzTNFEtOIGFqOYhLOsdamhtchrhdHXEYolIpsgUgbh0xykaKEJNrZXkfoKZSHxyO+oJp9FkKqnp4WypG71KZdw2iiydlE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(7416014)(1800799024)(366016)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?OmbF2M9st9ZFBDCI8tm9x2oPnUhEPIu14LBugM+G2NiSab6YUm8ZQw3vOIBs?=
 =?us-ascii?Q?AWDfDwA4b+yH13yL73VMYSlWCf2ku0RLhfLb+7EBHqRCGJ1kAleZQ9zmE/UI?=
 =?us-ascii?Q?yB0dZDZ2O3BSQ6htv7lFqJO7zjOCQ8zmOIRG03fAMSrMgX24nxihldeeZnWO?=
 =?us-ascii?Q?Hdkdk5nZuG+oOsHfMleegR09Ib73sJ7aaBNyKZm6QmuZA1ZrIPSUyOza+Hec?=
 =?us-ascii?Q?5pMU6FDHmxiHH7JfxSNgduI8DMx7xITI2k/gBQraj1os2bdxXfthqK/EoeAl?=
 =?us-ascii?Q?sFitYo+5bZTzPn1cvTJfX3A03mEpIf31oW8haMBuVritdL7lQBCLeCC+lKaJ?=
 =?us-ascii?Q?HhEyiRD8ZsRlCXO+MZPaAtV5i3/5vRZBBJ45Al+4gf5DQ3z3ChhFWLJ6Ssat?=
 =?us-ascii?Q?818Iglze0az1B69xMEMCJvrVDPlq24dM6WSOux/UKz9595LJvsL4LEwjEK4T?=
 =?us-ascii?Q?uW8ulK90KtrzXaeW6N6pgtnOiLv2TYP1OnepWQwx9tEiXZqBAP/9ftzlCMKL?=
 =?us-ascii?Q?Ucvo5Tj5cWvU4WTQvZ2kF4/G8cnQxRHAe/ip6rSN1ZgpAQo7onRNQP93Okjz?=
 =?us-ascii?Q?suMrFcNRVEmKf6MkJyGSWZ+trrx5xTUbBDNWhPPfHfYQOi1GSsFxknvf7/it?=
 =?us-ascii?Q?lIQ9pm0p92c3drnimVl19laF0qP/lyS2SAvqKVffmxdjb93ZiqlAA0syiBxp?=
 =?us-ascii?Q?PuQ1m8n4Zc0Fmklo8LS0HHu6tpVJEhSoKlgqlX24JgDRDA8Rx9I5XoGZIYS9?=
 =?us-ascii?Q?Og14XXIrCA4CBSlAIeIoIOebFjmBMvxt7EHtkMqHxWCsWX6JVjPVkDcKk+KC?=
 =?us-ascii?Q?6DyfIvUDvTmT3sHBOj/Xd4Ewy5Dcu/AP1U63NZ9TuOLqMcLweCdoCAuAkoBk?=
 =?us-ascii?Q?hXj0RDurZfFoDY3CymviIhGvK1hSlzNWa6RRnu8Ke1norqW6YnOSjMMhCJCb?=
 =?us-ascii?Q?0sgDfG0JBnzzagG0m6i3pLy0Z/mySL2K6dnfvdNAa02EBeHR917jmIC9Ed8T?=
 =?us-ascii?Q?8Y/SZ07H7GH5vhn3AkkMHDcflk4xd8zpQR8NPsCQRHHFhraX1X41O9BhcqXH?=
 =?us-ascii?Q?ZbcEWcNF17JHzoqq43GcyzlktGts2KfrdW2I/xy8airmCJn1dnqtIm8EAsPu?=
 =?us-ascii?Q?6aAPRW4jRhz+eXXnTR5LkRMfesn0q9U8KLIeqMV/FoKC9wJ9mp9+eW+k5q/P?=
 =?us-ascii?Q?ZGpJVgoI5HCOSuAi9BnmygtBkoz4vhpeUP/t25SMSiCmLGiA2dMo4y6+Dumc?=
 =?us-ascii?Q?eJxgsJ7CQsUMPIxTeIuJmolZ/+jhcrIxrHQgDJXzzNItWeUBBRw922PmAbeN?=
 =?us-ascii?Q?Gq7Lif5atQXUU5WODApHCL/+bLpxpQx21Z+13VOivTayn9t0W3KPg0RzFl9w?=
 =?us-ascii?Q?lQHW1+uXeeEY5v7QaY4oj0xhB3n1+4PRigsmQv9BGt+aOPYXFAlz22KcqF0E?=
 =?us-ascii?Q?c3JxR/etbWVzLHOVeRZ3KtKtG/xtYeon8yFN+MGpzahBaFLzcdwCwOgDUssY?=
 =?us-ascii?Q?c54edgzAuLVnRAzDLVb46e/RddYRoV3D3p1z5mycfQJUzXWE6vFtzOQT3/xj?=
 =?us-ascii?Q?1W+Kjt5gDeHtY87U1/2kacrWVWEWd6CI73D7YQhVykvUKLI3XKm5LfuoUSJN?=
 =?us-ascii?Q?UgXzGtkx7mnwyOqP+4Y7vGZjCr47Tpdt1lrW/ULlV2xw9T5RbQrbbpMjkgv8?=
 =?us-ascii?Q?p2fIqJ8qq/K9Q+hZDUG0C34OU6tWT2zjKkFQ8SgRZ85VVpsIfo+xBcWNxR72?=
 =?us-ascii?Q?MyJbGY8d5p5Ah/o6RqCi6FbR9QrR6ndtb6ANRE3u2/qr4Sf4WMgh?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3ad411-a4be-40e6-7fb5-08df140d9d8c
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:14:42.3920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /N/n1cugs9haB1wbLFs6gVd52Iso2ytc0z2Os5S5ch+02dPA8JIeOPijg62PpLw4s4ZnI1jS9W0FyC1tTOy3fSVQZ7fibXQUSkOwEfreTG/rimKAwnRax3STHbUcWowt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRWPR04MB12041

On Wed, Sep 16, 2026 at 10:44:02AM +0200, Larisa Grigore wrote:
> Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
> include/ufs/unipro.h.
>
> These state values are UniPro/M-PHY related and are not specific to
> the DesignWare UFS host controller implementation, so unipro.h is a
> more appropriate location for sharing them.
>
> As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
> ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
> TX_STATE_HIBERN8 enum constant. This is a no-op change: TX_FSM_HIBERN8
> was 0x1 and TX_STATE_HIBERN8 is 1, so the compared values are identical.
>
> This also prepares for using these definitions in a subsequent commit.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/ufs/host/ufs-hisi.c   |  8 ++++----
>  drivers/ufs/host/ufs-hisi.h   |  1 -
>  drivers/ufs/host/ufs-qcom.c   |  4 ++--
>  drivers/ufs/host/ufs-qcom.h   |  1 -
>  drivers/ufs/host/ufshcd-dwc.h | 19 -------------------
>  include/ufs/unipro.h          | 20 ++++++++++++++++++++
>  6 files changed, 26 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
> index 993e20ac211d..2d214ce9620e 100644
> --- a/drivers/ufs/host/ufs-hisi.c
> +++ b/drivers/ufs/host/ufs-hisi.c
> @@ -34,8 +34,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>  				      &tx_fsm_val_0);
>  		err |= ufshcd_dme_get(hba,
>  		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
> -		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
> -			tx_fsm_val_1 == TX_FSM_HIBERN8))
> +		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
> +			tx_fsm_val_1 == TX_STATE_HIBERN8))
>  			break;
>
>  		/* sleep for max. 200us */
> @@ -56,8 +56,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>  	if (err) {
>  		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>  			__func__, err);
> -	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
> -			 tx_fsm_val_1 != TX_FSM_HIBERN8) {
> +	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
> +			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
>  		err = -1;
>  		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
>  			__func__, tx_fsm_val_0, tx_fsm_val_1);
> diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
> index 5a90c0f4e90c..6af6a268458d 100644
> --- a/drivers/ufs/host/ufs-hisi.h
> +++ b/drivers/ufs/host/ufs-hisi.h
> @@ -43,7 +43,6 @@
>   * M-TX Configuration Attributes for Hixxxx
>   */
>  #define MPHY_TX_FSM_STATE	0x41
> -#define TX_FSM_HIBERN8	0x1
>
>  /*
>   * Hixxxx UFS HC specific Registers
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 954be9343f42..38897d01fde2 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -393,7 +393,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>  				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
>  					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>  				&tx_fsm_val);
> -		if (err || tx_fsm_val == TX_FSM_HIBERN8)
> +		if (err || tx_fsm_val == TX_STATE_HIBERN8)
>  			break;
>
>  		/* sleep for max. 200us */
> @@ -413,7 +413,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>  	if (err) {
>  		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>  				__func__, err);
> -	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
> +	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
>  		err = tx_fsm_val;
>  		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
>  				__func__, err);
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index a5ad5ce44a19..3c6cb2281af0 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -11,7 +11,6 @@
>  #include <ufs/ufshcd.h>
>
>  #define MPHY_TX_FSM_STATE       0x41
> -#define TX_FSM_HIBERN8          0x1
>  #define HBRN8_POLL_TOUT_MS      100
>  #define DEFAULT_CLK_RATE_HZ     1000000
>  #define MAX_SUPP_MAC		64
> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index c618bb914904..a5e40e7604a1 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -39,25 +39,6 @@
>  #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
>  #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
>
> -/* Tx/Rx FSM state */
> -enum rx_fsm_state {
> -	RX_STATE_DISABLED = 0,
> -	RX_STATE_HIBERN8 = 1,
> -	RX_STATE_SLEEP = 2,
> -	RX_STATE_STALL = 3,
> -	RX_STATE_LSBURST = 4,
> -	RX_STATE_HSBURST = 5,
> -};
> -
> -enum tx_fsm_state {
> -	TX_STATE_DISABLED = 0,
> -	TX_STATE_HIBERN8 = 1,
> -	TX_STATE_SLEEP = 2,
> -	TX_STATE_STALL = 3,
> -	TX_STATE_LSBURST = 4,
> -	TX_STATE_HSBURST = 5,
> -};
> -
>  struct ufshcd_dme_attr_val {
>  	u32 attr_sel;
>  	u32 mib_val;
> diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
> index 9c168703b104..e0f490e11c7f 100644
> --- a/include/ufs/unipro.h
> +++ b/include/ufs/unipro.h
> @@ -466,4 +466,24 @@ enum {
>  	CPORT_CONNECTED,
>  };
>
> +/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attributes) */
> +enum ufs_rx_fsm_state {
> +	RX_STATE_DISABLED = 0,
> +	RX_STATE_HIBERN8 = 1,
> +	RX_STATE_SLEEP = 2,
> +	RX_STATE_STALL = 3,
> +	RX_STATE_LSBURST = 4,
> +	RX_STATE_HSBURST = 5,
> +};
> +
> +/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attributes) */
> +enum ufs_tx_fsm_state {
> +	TX_STATE_DISABLED = 0,
> +	TX_STATE_HIBERN8 = 1,
> +	TX_STATE_SLEEP = 2,
> +	TX_STATE_STALL = 3,
> +	TX_STATE_LSBURST = 4,
> +	TX_STATE_HSBURST = 5,
> +};
> +
>  #endif /* _UNIPRO_H_ */
> --
> 2.43.0
>
>
