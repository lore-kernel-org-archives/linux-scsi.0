Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010040.outbound.protection.outlook.com [52.101.69.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2084CEE7E;
	Wed, 16 Sep 2026 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575788; cv=fail; b=kSGKlLQcwSKZ5m0rQVtvQA/bxHb4dYttUxJCTu8YtGvfQqkRUnD6QfK8mCAxkOvr7lsdXtv5YW4XVNYo3x1Fn/JhJf9BcO7ptUHH6uG8QfnsOHrY5l2G0rl0/g/faG6HI+idLmEp69KVZj2Fp6gow3bgvja2YsT6y490v/x0Ucg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575788; c=relaxed/simple;
	bh=5vRyhGIm3YUqdYfrdv5UM8Y0x6A/je0ZJ0tTIcW4NPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ay9Lq9gV01piniCpbxbJSGH8l8SppWm57JtiAEQeHQFtMEE4Hg92qisHNQoWoWUoNFjoMDJyFCG9MPGMqKz/SJO/bdSi5PHiPq5BwX1pnPXZ+09H8C9iBEYN0UyolarkQMtLgK0nfYZGSkXat33OVO46yoETqM5o97Nl2WaNV5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=hRJVNnFR; arc=fail smtp.client-ip=52.101.69.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="hRJVNnFR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=voUFqZb6J0QlZklLxxp16znQk99YpjDorsyj1C4DH7arYQp6gfVprYoH73CAYTo/2JpZpRX9NnOIi/vRWEc2mTqzvm3d4Aa0XX7e5KGMJo9vuWf0tFJ4n4OMminsFHAGLW8lBDQGYYfI53o9yG1VYF5VfJAVojLXADrSyZ0dbxDKZF+sILd/YcgeX16RonZCGtDw1rWT9QO9QwTSouAXL6+9QdSelDQP+0DM0QxDeTiaRNQ6knX3pg5vEy08tOlCN2/UMcfPzLggqt0BR0aU66gV7B8c4n2pMk2scoeNN8/4AymmHAtin5E90ZgzOMZXkmDJ6r3iF+fAL/JD9WYfEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7GwWBsZ8h/57Z4Uo9eDZf+HmqFImrCFlIP0v/KSyZw=;
 b=smRJRd5dugBC2cLplOILCGtvajLN+Y+XtUvtdj/7A/+ddiA1woMOcknQSP45pWPwkC5BGlTaswmt0IrjMA3O55DU8/gDYPdHNFOxP3m7HnbFXolOtfBXO2Q04o7oQI3VVAnBaMmrwXdpon4U8qscm6fURHrhsH+90sCUfq/ojvSIPvvnAZVKw9uZ1y4s6DF5w9JtgA+8r820oop8e7+QP54zmbu1HxFHgHyv1Dtnt7FY56a1oVNkTswCabeesqfNDSIvVEsYIezlLn0+TpfyMDUK/BBb5fQA+CTLiJ16VYaopOrYptRQaP9ya3HeI/b2/PsL46lJxzP5vwmjTN2RdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7GwWBsZ8h/57Z4Uo9eDZf+HmqFImrCFlIP0v/KSyZw=;
 b=hRJVNnFRefx1euDpKH3j2VahA5eVwabh3AtM8gZUMbNFITmFmrhLfYqFZL01bsqtNYtIoSYyC4OE6savpziS13nl7v1e5rwPUED5YqRBWC9wlvloNENmLAKaOx8U3sKZqwQpEFGD6n6nD2NlgdtjNnmrI1i8bmgfnPMs+wtApoel12UEnfPJSW3b3GjhqVnKvU++/eK+WLsy07xvjXjjvEAnvKBcHkLBjYsQk+KzWevsfN1AJ6kMooS28MpVWVgokzqWbhuYa6m/UGZDyNp74RXlUx6kT7LsMSgTWv+86t3BSANWyjYpwCuJJH9QmG7fKXIYaJ8ZKSnmBGdbTNubMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by PA6PR04MB11988.eurprd04.prod.outlook.com (2603:10a6:102:51c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 16:22:52 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 16:22:52 +0000
Date: Wed, 16 Sep 2026 11:22:40 -0500
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
Subject: Re: [PATCH v3 03/10] ufs: host: Add common Hibern8 TX FSM polling
 helper
Message-ID: <aqrCUDrYaIsL39zn@SMW015318>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-4-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916084411.941297-4-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH0PR07CA0098.namprd07.prod.outlook.com
 (2603:10b6:510:4::13) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|PA6PR04MB11988:EE_
X-MS-Office365-Filtering-Correlation-Id: d326ecf0-5508-4353-f73b-08df140ec1ee
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|19092799006|23010399003|22082099003|4143699003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
 oxMY9zzjPuJlPXqqujRnsDMnRCkuofyrzetiaU/146qpZd+ZUor3Dw3kAgNy2WT+OPr8LbChdXIdbBiSL0ub7bYKYHvj96i7Neqfm1fbtVhVSgDFS9THeX934SvRTQFzhy/ipPykxkqL7ZdqM66oO2ahJPFcolcf6NpqIlHXQCWfws/MhuiExw/o+qpNPn4Im3kBWnpDQ48lIh3BPiRCh2nuhHhzGrdEo5FU9ARnDqa+45B5svqfUzAfeeQUbDu87cSC2bZpej+jWcVbJd3DsJKRf52Jl5fL+JftEnRfqfnbG5viCDyYmxQTFgTcc33evfz8BjeQB55vWOIMZhuLpc7IB7vsdjbd71b7eOJVkRfgeTqTlPtXU8faVhjE0wykGoSo/vJxl9daKpnHfhcIuAXDjZvvfyB99p2xVEQ9UtGpKuDqBZVwl+M1FhaFkaf9WKfi8NpcB0FpGA+z3bsVmu2bNQBv8Mk4uO53U4LxTnmnEQd3SPlY5S0wK2Psco052U8wgLz1b8kITsoxRY0qQ4mlb2osxyy7xZeIbkSDeqMx1s/92w5T3FVJMiL9NgnhC0TngbLtLnjmaYHT0bb8s1t4ZinxA3tuzcBu8jgOJeqF8yisNFgzjDDmJWAI69FDnk+nM3AJEJ1KIR11ziA9ZKVPV+NplpULaEmVaW4Oocw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(19092799006)(23010399003)(22082099003)(4143699003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?8/YZGgrskw2lZZlDz1j+DrxlTGi9PaaX5HtOky0d3Dr1PWPGnIRXsgeT53q+?=
 =?us-ascii?Q?OlRbAsXHXN6GGvq2q1CKsJ9BS69LfTubdmN0CQCW7gHt88QEPz5O+eNV6Sye?=
 =?us-ascii?Q?WdI9Ul40J0rOPoxBsGw/muHUCpoQzRutl3FVSDwIvYe6wsOFhAUTyYJFgGCE?=
 =?us-ascii?Q?fbxzXSp1QF+anOXR+lxgepnZtnASP4DKDMsVZhhdhJugglbOwbsUnbK2+h1Q?=
 =?us-ascii?Q?iSdg6AKjZSS5fu4ecZ3CUhChUW8g+V/a02dvt+D7mVNgrbfYaA531DCKbyTL?=
 =?us-ascii?Q?LeBHAzOSQAlgR5H5bBlpUCEOUCJALRQlLzEw8n2jXryu3kxwccZ4Uo7XmeTb?=
 =?us-ascii?Q?QShrR2BzF+E3cmMPDpbVdr4Ia6eAdkE5NxB3eKrAxkv/cExhGubnE42Vy8yY?=
 =?us-ascii?Q?2PP5GisZ87biEDnop6BMInIqiXiOIg3xa3pJkL1/PJKJ9tJ1YoZT8mQTz4YX?=
 =?us-ascii?Q?LwnioqnsWZajxhpF3GFSCg77YhQmbQSOQDO33thdOUsVrfxOslziDgdiJJ3h?=
 =?us-ascii?Q?sA956T2fwvi1XRdUl1in1C25JBhtPnBg6qrZYfMpaX252yTdyvWFBEJHbMD4?=
 =?us-ascii?Q?PaZWcRiTNC7UrQ/xbsH119iYw36DyVwp+2qjbwX0C4l3rEDyE997ZYUr9z0j?=
 =?us-ascii?Q?ql8t7bRjhM4tN0CY9UCdT2FhXOKRArD6ScB7hlXiayO6CjjblNOX9wutAhvP?=
 =?us-ascii?Q?FYe9v6CBTX/q+3KxBkn/YFtlaAgRfXkDZcs/B6HhUmAM9b9rfDMgTv7KRS6X?=
 =?us-ascii?Q?h2z477SZEX2ts1ogr5wSLWwNdnOO52RoBIR1eGUrrlWUHrefQtzK1yqxwxkV?=
 =?us-ascii?Q?bZfEPTC7MY1PPcGV6CZaQLnI8yibNE5n9ELY8YLZIjtm1e/pOCj7I1T4Co6+?=
 =?us-ascii?Q?Qu1/SZlklG/oJ29RxIKfOTARoYL7S3t4DkCAPvx/r9HIE+Sky3pYAuyLcZmT?=
 =?us-ascii?Q?r4/GcXlKzmesv0bvygTUyPg9a5pJIDcpvs8yDUA3X/xRkR+YkTbQWTFBkUVs?=
 =?us-ascii?Q?+xHBq4ZNgvMVKrhTV1mgPXcjC65wf8vUfPbn+NjRwtfq7FaKGDo0kJv0pMI9?=
 =?us-ascii?Q?u2+tcKkmtUQycunow11xe1Lhw7bU/QMNjvrrtuKEh4yugtRIzEtXdQiVnupw?=
 =?us-ascii?Q?Ou7IOorAdrNKczs+zyXOJkAjR/uHXf9oLlZ1sWO0jZO4ExWMPSyJqm/xzyt7?=
 =?us-ascii?Q?EMRkKMDT2uoJ/lDThEBArADeIR6w2EgwHPIOrlsXp+lg/7mx2wybeaD1T25h?=
 =?us-ascii?Q?PUjZbXAxmC4od2Rp6NI9fz/2rmUejeLORhybEeLkSRbvFfROu7L7nXolPwZX?=
 =?us-ascii?Q?606JVlWwXneHlhQhf3hc8HR12bxv6J+cxiVYY2bGML0hgaqKJtB8cxizsxZq?=
 =?us-ascii?Q?cJIAdKwesCuEZhTNcdepCfN6tZjiSgrZSPrB+cT/o/QvaZYYtoxIzc3RKwUy?=
 =?us-ascii?Q?aIApV/buCZx8x1N2e5pYPcUOjdEsMYXZU60RNMSmYm+3h1NDCKXdP+nOhV6j?=
 =?us-ascii?Q?d0HlO7p3dqi75lpy8pQtiziXVVybhhnYmxZ+qdesv+0EjS/VHGGqIQScVo/K?=
 =?us-ascii?Q?ixvaMW2LG0a/QMOldAPQcAP90kNzEaY3FkF8C4w7v50bzImHnaZzBCUn3wl+?=
 =?us-ascii?Q?M4GFXmQnlM8LkdntbjUW9/jwvRrWx9cbZY27nI+tUS+CPi6VnXSZR/LqXihs?=
 =?us-ascii?Q?eLyb71CtugAwUjSMq+Wavm4I1SMO34tMsOghoF+oPiRJjUdWwUoLG2qhjDrz?=
 =?us-ascii?Q?FPPzilMFfijuJpbFWiNEY0slF31pU2l+BeX2CGww0+XTYkVBniWm?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d326ecf0-5508-4353-f73b-08df140ec1ee
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:22:52.7855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zv5xxPTcK+FmdYR8mCdVWdlBWBl06FJNGW4hl5iFwLKKHQFcnQbYQPODB1ybhU0s7Hb/uqzZdG91E52MPGVSBTijPeBlRaW0TfQIiiAnmsmH3yregmgO9xCoxBbOAknd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR04MB11988

On Wed, Sep 16, 2026 at 10:44:04AM +0200, Larisa Grigore wrote:
> Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
> enter Hibern8 into ufshcd_check_hibern8().
>
> The HiSilicon and Qualcomm drivers currently implement similar checks
> using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
> this logic to a common helper in ufshcd so it can be shared across host
> controller drivers.
>
> Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
> their local implementations. While at it, normalize the "TX lane failed to
> reach Hibern8" error path to return -ETIMEDOUT instead of the raw
> TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
> This is an intentional, harmless change of the returned error value; the
> pass/fail behaviour at the call sites is unchanged.
>
> Unlike the initial implementation, the timeout error is now reported only
> once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
> per lane.
>
> This also prepares for reusing the same UniPro-specific Hibern8 check in
> a subsequent commit.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  drivers/ufs/core/ufshcd.c   | 86 +++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-hisi.c | 48 +--------------------
>  drivers/ufs/host/ufs-qcom.c | 42 +-----------------
>  include/ufs/ufshcd.h        |  3 ++
>  4 files changed, 91 insertions(+), 88 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2ba244cf40ac..f34b7fe54a16 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4448,6 +4448,92 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
>
> +/**
> + * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
> + * @hba: host controller instance
> + * @num_lanes: number of TX lanes to check
> + *
> + * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
> + *
> + * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
> + * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
> + * timeout) if the attribute read fails.
> + */
> +static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
> +					unsigned int num_lanes)
> +{
> +	u32 tx_fsm_val = 0;
> +	unsigned int i;
> +	int err;
> +
> +	for (i = 0; i < num_lanes; i++) {
> +		err = ufshcd_dme_get(hba,
> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +				&tx_fsm_val);
> +		if (err) {
> +			dev_err(hba->dev,
> +				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +				__func__, i, err);
> +			return err;
> +		}
> +
> +		if (tx_fsm_val != TX_STATE_HIBERN8)
> +			return -EAGAIN;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
> + * @hba: host controller instance
> + * @num_lanes: number of TX lanes to check
> + * @timeout_ms: timeout in milliseconds for all lanes
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
> +				unsigned int timeout_ms)
> +{
> +	unsigned long timeout;
> +	int err;
> +
> +	if (!num_lanes)
> +		return -EINVAL;
> +
> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +
> +	do {
> +		err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
> +		/*
> +		 * -EAGAIN means the lanes are simply not in HIBERN8 yet, so
> +		 * keep polling. Any other error is a real failure and must
> +		 * be returned immediately instead of being retried.
> +		 */
> +		if (err != -EAGAIN)
> +			return err;
> +
> +		/* sleep for max. 200us */
> +		usleep_range(100, 200);
> +	} while (time_before(jiffies, timeout));
> +
> +	/*
> +	 * We might have been scheduled out for long during polling, so do
> +	 * one final check before reporting timeout.
> +	 */
> +	err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
> +	if (err == -EAGAIN) {
> +		dev_err(hba->dev,
> +			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
> +			__func__);
> +		err = -ETIMEDOUT;
> +	}


why not use read read_poll_timeout()

read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err, err != -EAGAIN, timeout_ms,
		  0, hba, numlanes);


Frank

> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
> +
>  /**
>   * ufshcd_dme_rmw - get modify set a DME attribute
>   * @hba: per adapter instance
> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
> index bd223bda1ce2..b84075dfe00d 100644
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
> @@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>
>  	/* Unipro VS_mphy_disable */
>  	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
> -	err = ufs_hisi_check_hibern8(hba);
> -	if (err)
> -		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
> +	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
>
>  	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
>  		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 1e492dac8d93..815ca82a0878 100644
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
> +		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
>  		ufs_qcom_enable_hw_clk_gating(hba);
>  		ufs_qcom_ice_enable(host);
>  		ufs_qcom_config_ice_allocator(host);
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index dfd302f2dc7c..0d9d0a26eb20 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>  			       u8 attr_set, u32 mib_val, u8 peer);
>  extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>  			       u32 *mib_val, u8 peer);
> +extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
> +				       unsigned int num_lanes,
> +				       unsigned int timeout_ms);
>  extern int ufshcd_change_power_mode(struct ufs_hba *hba,
>  				    struct ufs_pa_layer_attr *pwr_mode,
>  				    enum ufshcd_pmc_policy pmc_policy);
> --
> 2.43.0
>
>
