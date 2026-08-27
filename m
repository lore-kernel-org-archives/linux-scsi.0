Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013031.outbound.protection.outlook.com [52.101.72.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F91D3E314F;
	Thu, 27 Aug 2026 09:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821843; cv=fail; b=Gmt474EAiTJVeEFzpKa82m0PEsvfzZI3dbAG3QY6qDWh00cysiuABksVKT/OxJaCwBtVm5uIimfLyvV5AY53l+BozVc+I4FKStvojr9ZFEOzJXZlXdEbWyC5SEhtjdBkMASi7P3Rna8KqQcNgYnPy2UzDJz+5WiegceCJlO/DOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821843; c=relaxed/simple;
	bh=NyrUNpUUQ021TRHC6vBQvX2pM1eWu+XQSNktW9zf0NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=slSGNyoiEopcVhnS9nn56x3UPXo2ELIqwQOp9vtb7Igda8py3V1OV+J3NF+Ypy+1KIfeRKUAcmlBP4qcPPAZejXPEvQOwV8Yt55/EHuURjhALMo1T359QZBGhYeynSL695Thn9euyqyCNOtLLsjNSD/ok5Wir5gIyxWOL4eG104=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=EUWMCS0t; arc=fail smtp.client-ip=52.101.72.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="EUWMCS0t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Shvjz7euLSShyGlE7Q9HZ6NyuCPhfSPMzWW/rNUkdw/6xmtWq2DC3TmWAXsl2Gcn2jv34R2wWJnjiSNkbPOsYiDivlGk/8hjDSlN1UpTeonQuAu+jQrk3lmqjNI+jyarGWpzj4G1QwNrrK7HhXuRLJ6xGRGSm86aNG9ndKaNTPct5Rk/7h3mEu47DqD10LLoXaen+DoRRgJYbERP6M1MtsYAXx0CcCdROLYAroKkdGAbGJEKyVkoWBMw4isTzZwdgL1o/FOYs10vX5qKghp36uLNS2LO2TQU9CkLtq7zmmm2INqCL2iPEamLn0XPM6kiM0OWee2yLL9uaUJEqO5g3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0Lri72eQ11l1JvNFay/wXwoOq/3rEJlmOnzdjKRQMk=;
 b=gXS0wE+E9uEu4EFvel4aiDiumHsEQlHXVhbbUlIskS2B7ENW4lJNC3gKf9JOG1+LRQsTmZ4lie/hIAAqzgWPXezs+IdNTWVfv+adqO0dI09IJ8k/pEyQ6qPIe4qzP2NGp39YFc2a7+ytJLr3yxh9ameDnjN2Jgc+rlnmhMKDR6Bexe4ntsRaNk0Yi0NJioQ1DCLWuE2VplsEUoe3BbnVfdvUcl2dk8FpCh3t62emoKOUm2TqrB7TesYGM/AEARcxObJ5MrDS7UTfxK153VlvMOdgVkswX1B9SBoUlhWBMUQwmsC6i+WPyGaT220lehNjgsoUbNFlk72KxpK0MiNVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0Lri72eQ11l1JvNFay/wXwoOq/3rEJlmOnzdjKRQMk=;
 b=EUWMCS0tLp82RRwq8o+XmM7sJbI4c9P6LItlVwr0o17D63LCEJ6eYUpmnTkWto/cy00p4mflrn2rgZNe6m9TsltCDlwszYVLJdBgEhryWVRqbHcio7n5Hb0P+X+MqkoyKf/SsBI7s7r571NqLMsfAl/f+23JZ3HskmXWJfHJguC1hbzBWc3XvECW9wiCt5oO90s6RqwCmYHizG8y6vOdzlYz8wdkkVJlzcQUgO4RAXso2UelIx8VIDTJ/Nfm1n1bEBxcTuuYBKNXrSUDRmajjaZXjstqIsTHwRIh/A1YJ6xUJFoiQw4Ro4I39OEQw4g3kC6RId17sG2gzXhVVHur5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PA6PR04MB11909.eurprd04.prod.outlook.com
 (2603:10a6:102:51c::22) by AS8PR04MB8946.eurprd04.prod.outlook.com
 (2603:10a6:20b:42d::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 09:10:37 +0000
Received: from PA6PR04MB11909.eurprd04.prod.outlook.com
 ([fe80::a4b:fa4e:7fe7:e6a2]) by PA6PR04MB11909.eurprd04.prod.outlook.com
 ([fe80::a4b:fa4e:7fe7:e6a2%7]) with mapi id 15.21.0360.006; Thu, 27 Aug 2026
 09:10:37 +0000
Date: Thu, 27 Aug 2026 17:14:40 +0800
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
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
Message-ID: <20260827091440.6iqfhvyihrxqv4bp@shlinux89>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SI2P153CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::17) To PA6PR04MB11909.eurprd04.prod.outlook.com
 (2603:10a6:102:51c::22)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR04MB11909:EE_|AS8PR04MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: d82ca5a2-2fb9-418e-463e-08df041b0e84
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|19092799006|1800799024|366016|23010399003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 567j+4P490lPYQI//4uiHQYzAnm5nfJx/SXHHtVZYXytFIuquNZPcz11w3yIeocOLdG1z2GeyfdVPvsgDp5TBW02k7OIfR1XqO0gCcw8ykaA+PbghaghzXDIUFojUa0iQgz+pa+XYTIcUXIFdojzeuNxhKiFhQJ++OPg+gs2INePY2fBujGq+EzYMluHiYHl6anTGKCr4BkT5NPujlfz/X2jr7wMLrW/XfJW+8jr21M8W6AvsYrGAwT0mfJL2bzh3c1hedmGhjO3qzLQqx2Rbdc9bgP65ycmGKmJH3NzIv0y1ozxivyHxzqKa6020wg2oXwbLxUA/8bxONHEWb4NG4G7fMu3y/OaQ4katHuqf5dmjvmCx5cNlSReG+s/LBoJUKnD54vc4sa+NoxE+SMPq1IgWKNKsuj5YdhJDjddBbV/k/r8DszclIuXWKaeQhWzVGP1Ne9pRQCPEHnfEaOjLShSjIxAKsLn0uDqE22kvSOXVmZbUP/fiS6XHDczHbGjua49wjrxuMyNgPzEFtTdOdPqOg3EV0zCFdNWd2+r4KUPf172fN5ZpmwyKWlpHOrKs56swgoIMWEdRMbM6aopR/RFliCAR3WuQ8DsvVMRbjUCXM3n8G4fSbvfBeSraGJor3fVBy+rfsz4YovPfnRHotR03AJmIZRkDPk9wrRUST8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR04MB11909.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(19092799006)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Aw0jWXqw4MbHNBCGG1QkMCQkSGyl4/vq5OsOrwZWYXzI5QUy8qGDUY6M/JI2?=
 =?us-ascii?Q?lgsSKSP0/Hmid6nbc/oOirraEbEiX4mYJrfmJmkr9Av/uBGyPUPxJ4IcF8gw?=
 =?us-ascii?Q?Yhemt2IwC4BzxFMlCYwkkuuqV9rBVut0+wHql9Ay7qEUfhUKHrOqZ7fJxFvU?=
 =?us-ascii?Q?/ueAJmzybu24rVOR7M+wnrzNfWA7DGbm3JGU4hU9giu4ePvQZ5M9LFL0fut2?=
 =?us-ascii?Q?EK9VnzQ6uh0OIo/gDOyjyngCL+mf1sjss2ygrWpE0MrAZdjCBO1wpK3JQ/O8?=
 =?us-ascii?Q?chDceWcG/bwoLv63buq758gOwXpsRKP4ylsGcp6K93bJxAPP+XnOJQUKakTd?=
 =?us-ascii?Q?pFN6SdHvGr9y19HXFXonT9N9EdVKXCwaj7LMVmrGE5zGxckB0Lv7jiTmPcZ4?=
 =?us-ascii?Q?5cVX8TT3ZdMqICvKMiBluzkd6ARdrigkoA7YanryGAkuVn1wdV7P5GoXc+cP?=
 =?us-ascii?Q?gYXBDPGOesWuem6h4d10rrat09ZM8dzwPvp1OjyqLEIcALrUA8w3BlKVaEAx?=
 =?us-ascii?Q?aVRxRQI4kJoQKM82A8WXDQQ+R9jvx7bBM7YGh5ncaM/novRVHikVue5lzADU?=
 =?us-ascii?Q?pVuS/L5qjRKIxW0QXKXRH0dXEiclyXDoF9d89Z3zm4/BL5cgM4uXcKZXf2DE?=
 =?us-ascii?Q?ZpNPzx3S+pgnM2zPjZK5tngcOjpumCwYX4qfJibL97vaWXWvnq/1JN6JdKeP?=
 =?us-ascii?Q?CQGOSxJQouTicLQY9rjVH2kD3b1Uv/4Ngc5dSPYTyIqCc2who2xkPkzdMKZH?=
 =?us-ascii?Q?1VE8SWIdhTj6boGY6D1ilK8ZreDx7kKoFiDor0qHgzqi1Q5jfuS24TNvRzJn?=
 =?us-ascii?Q?nuZrGkdBrZqmXaigMbIutWqIysLZYi2EonP9IqAzV9MxK7xMnzE3/qUA27aY?=
 =?us-ascii?Q?AStTt9LJzKl8/GxgwxoKMaT1ZraDHHYAlRYDVsKLnFjiZLU3c2lxPF2nbxoR?=
 =?us-ascii?Q?DONtfNG6Cig9GziLTet/OW5e/fv8qPGzoUc4Xg5+TeDIKbmEcpsC02UvyTBo?=
 =?us-ascii?Q?JAzhhH3wSR/J5fTesUZcYc6Ogi7c+FgrDsgvB/Wp7CMn0ADyuNj5/4iTYM6x?=
 =?us-ascii?Q?uCzQtJtCeJcSEqxLwXFqio8pEqWn2h5dQc7uF9vvZ7YroK4jB7oM/lCRJfYZ?=
 =?us-ascii?Q?DMNqlkj1wm6Z+6WK6a2W1topDWEN0/OEho7KMEeriZZGVDWqYGNCVJgEwOxb?=
 =?us-ascii?Q?LfQiJcdlLXJb5PTyx7wdJkgwqAdWo1ng6HWKS58mLfdx3/l41rIa4PckEYvo?=
 =?us-ascii?Q?hhciDawHJcOq5q+GbptytkAcsToB4KbyyWD6mNl30OzjrH0VeNv9kQ+P1gX6?=
 =?us-ascii?Q?NoJI2K05ZQjcdfuQNPXNs/NNuzMFUgA2nx70YcMqu5gUh/tULVsg2eMob7is?=
 =?us-ascii?Q?iPJSBWA9bP8V4ibNaXJcYyfno0KTpOoV6/Fj0ypGwNVQ6R/DONrBORGPAOJF?=
 =?us-ascii?Q?0Ijst8VCTh8D2286gxbvnk5gliKAdE2hCD3oBO4E2pw1AkJXDCYxZgfzDZ4C?=
 =?us-ascii?Q?O7kq+7BXzTa7U+fSUQ7Paq71oeY2JuDbixJUoM+qhYNEY4QixYZbROQNyRlb?=
 =?us-ascii?Q?YBI93X+6IwFmoVR48jVRIhFuHOHqG8r3zR745Vp3d5AU/iAlSn1XpEw5uFVP?=
 =?us-ascii?Q?xRSQ9z19iZX8U6yO9TfzYY15V/uR+v+ljXMgmjayDd6/4JKu0EhOYUP54xoi?=
 =?us-ascii?Q?i/HjjyMuKhsl3XiNUnUDp83k28MIFasZa71oNdeTAkwdXZWt3HlRoQ4TEVdO?=
 =?us-ascii?Q?ARzmUs/fe8FhK3cpve6GgCo+zWEpCTII6FQ9o2xzn7MK1uOR5nFp?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82ca5a2-2fb9-418e-463e-08df041b0e84
X-MS-Exchange-CrossTenant-AuthSource: PA6PR04MB11909.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 09:10:37.1643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1ndvWdzOZTaScis1iYSyjU+UkDUoB0x3X4nkTBQty+fPRZVaVl7kp93uuj3xiRLWZT5ZXN/VDOZMvaminpO5hEI1h8/r37cvZkEBLwsLnmf4R4DS60W5mEGLalkY9wC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8946

On Wed, Aug 26, 2026 at 03:40:41PM +0200, Larisa Grigore wrote:
> Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
> enter Hibern8 into ufshcd_check_hibern8().
> 
> The HiSilicon and Qualcomm drivers currently implement similar checks
> using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
> this logic to a common helper in ufshcd-pltfrm so it can be shared
> across host controller drivers.
> 
> Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
> their local implementations.

The code change the error return value for qcom and hisi, better to point this
out like the following, so that QCOM/HISI guys may pay attention on it:

"While at it, normalize the "TX lane failed to reach Hibern8" error path to
return -ETIMEDOUT instead of the raw TX_FSM_STATE value (qcom) or -1 (hisi),
so all callers get a proper errno. This is an intentional, harmless change of
the returned error value; the pass/fail behaviour at the call sites is
unchanged."

Regards
Haibo Chen
> 
> This also prepares for reusing the same UniPro-specific Hibern8 check in
> a subsequent commit.
> 
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  drivers/ufs/host/ufs-hisi.c      | 48 +------------------
>  drivers/ufs/host/ufs-qcom.c      | 42 +----------------
>  drivers/ufs/host/ufshcd-pltfrm.c | 79 ++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufshcd-pltfrm.h |  2 +
>  4 files changed, 84 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
> index bd223bda1ce2..76d77bc30322 100644
> --- a/drivers/ufs/host/ufs-hisi.c
> +++ b/drivers/ufs/host/ufs-hisi.c
> @@ -22,50 +22,6 @@
>  #include <ufs/ufshci.h>
>  #include <ufs/ufs_quirks.h>
>  
> -static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
> -{
> -	int err = 0;
> -	u32 tx_fsm_val_0 = 0;
> -	u32 tx_fsm_val_1 = 0;
> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
> -
> -	do {
> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
> -				      &tx_fsm_val_0);
> -		err |= ufshcd_dme_get(hba,
> -		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
> -		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
> -			tx_fsm_val_1 == TX_STATE_HIBERN8))
> -			break;
> -
> -		/* sleep for max. 200us */
> -		usleep_range(100, 200);
> -	} while (time_before(jiffies, timeout));
> -
> -	/*
> -	 * we might have scheduled out for long during polling so
> -	 * check the state again.
> -	 */
> -	if (time_after(jiffies, timeout)) {
> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
> -				     &tx_fsm_val_0);
> -		err |= ufshcd_dme_get(hba,
> -		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
> -	}
> -
> -	if (err) {
> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> -			__func__, err);
> -	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
> -			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
> -		err = -1;
> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
> -			__func__, tx_fsm_val_0, tx_fsm_val_1);
> -	}
> -
> -	return err;
> -}
> -
>  static void ufs_hisi_clk_init(struct ufs_hba *hba)
>  {
>  	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
> @@ -224,9 +180,9 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>  
>  	/* Unipro VS_mphy_disable */
>  	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
> -	err = ufs_hisi_check_hibern8(hba);
> +	err = ufshcd_check_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
>  	if (err)
> -		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
> +		dev_err(hba->dev, "hibern8 TX FSM check failed\n");
>  
>  	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
>  		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index b2081ed6197a..c94488661bcf 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>  	return 0;
>  }
>  
> -static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
> -{
> -	int err;
> -	u32 tx_fsm_val;
> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
> -
> -	do {
> -		err = ufshcd_dme_get(hba,
> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> -				&tx_fsm_val);
> -		if (err || tx_fsm_val == TX_STATE_HIBERN8)
> -			break;
> -
> -		/* sleep for max. 200us */
> -		usleep_range(100, 200);
> -	} while (time_before(jiffies, timeout));
> -
> -	/*
> -	 * we might have scheduled out for long during polling so
> -	 * check the state again.
> -	 */
> -	if (time_after(jiffies, timeout))
> -		err = ufshcd_dme_get(hba,
> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> -				&tx_fsm_val);
> -
> -	if (err) {
> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> -				__func__, err);
> -	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
> -		err = tx_fsm_val;
> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
> -				__func__, err);
> -	}
> -
> -	return err;
> -}
> -
>  static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>  {
>  	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
> @@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>  		break;
>  	case POST_CHANGE:
>  		/* check if UFS PHY moved from DISABLED to HIBERN8 */
> -		err = ufs_qcom_check_hibern8(hba);
> +		err = ufshcd_check_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
>  		ufs_qcom_enable_hw_clk_gating(hba);
>  		ufs_qcom_ice_enable(host);
>  		ufs_qcom_config_ice_allocator(host);
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index c2dafb583cf5..034ee988924a 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_opp.h>
> @@ -563,6 +564,84 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_pltfrm_remove);
>  
> +/**
> + * ufshcd_check_hibern8 - Check if all TX lanes entered Hibern8 state
> + * @hba: host controller instance
> + * @num_lanes: number of TX lanes to check
> + * @timeout_ms: timeout in milliseconds for all lanes
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
> +			 unsigned int timeout_ms)
> +{
> +	unsigned long timeout;
> +	u32 tx_fsm_val = 0;
> +	unsigned int i;
> +	bool success;
> +	int err;
> +
> +	if (!num_lanes)
> +		return -EINVAL;
> +
> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +
> +	do {
> +		success = true;
> +
> +		for (i = 0; i < num_lanes; i++) {
> +			err = ufshcd_dme_get(hba,
> +					UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +						UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +					&tx_fsm_val);
> +			if (err) {
> +				dev_err(hba->dev,
> +						"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +						__func__, i, err);
> +				return err;
> +			}
> +
> +			if (tx_fsm_val != TX_STATE_HIBERN8) {
> +				success = false;
> +				break;
> +			}
> +		}
> +
> +		if (success)
> +			return 0;
> +
> +		/* sleep for max. 200us */
> +		usleep_range(100, 200);
> +	} while (time_before(jiffies, timeout));
> +
> +	/*
> +	 * We might have been scheduled out for long during polling, so do
> +	 * one final check before reporting timeout.
> +	 */
> +	for (i = 0; i < num_lanes; i++) {
> +		err = ufshcd_dme_get(hba,
> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +				&tx_fsm_val);
> +		if (err) {
> +			dev_err(hba->dev,
> +					"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +					__func__, i, err);
> +			return err;
> +		}
> +
> +		if (tx_fsm_val != TX_STATE_HIBERN8) {
> +			dev_err(hba->dev,
> +					"%s: timeout waiting for lane %u to enter HIBERN8, TX_FSM_STATE=%u\n",
> +					__func__, i, tx_fsm_val);
> +			return -ETIMEDOUT;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_check_hibern8);
> +
>  MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
>  MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
>  MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
> index 0a18a8aed94d..ec2a8013e975 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.h
> +++ b/drivers/ufs/host/ufshcd-pltfrm.h
> @@ -35,5 +35,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>  void ufshcd_pltfrm_remove(struct platform_device *pdev);
>  int ufshcd_populate_vreg(struct device *dev, const char *name,
>  			 struct ufs_vreg **out_vreg, bool skip_current);
> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
> +			 unsigned int timeout_ms);
>  
>  #endif /* UFSHCD_PLTFRM_H_ */
> -- 
> 2.43.0
> 
