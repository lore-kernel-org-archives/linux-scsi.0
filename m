Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011017.outbound.protection.outlook.com [40.107.130.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C46C4B8297;
	Wed, 16 Sep 2026 16:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576207; cv=fail; b=S6EjxNmy6sXRo05PWb1a4S3oYXBNx53b3lzt/tmAfne3F4fvK6rnQm2X+b3SFxP2iFps4AZ1f3HYkG9yCUUsUBO+ONfJhtNGXiGZUmIDve8/FQICX5T39q/OfRQB6afSzS0YN88kPpej5pUI98drvTqi1+Q95EslJTQzFCbTSz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576207; c=relaxed/simple;
	bh=7JOwX+fr3FzCGEtb+TaerfaAPkGLdIdJHtZ7jnDQ6AM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ta1z5l+qHCBUxMz/cG4IwQaMA9mwkpyInjLXK2OqW4B34BzBXV5Rk3nHlgcJqwZfcjVkJpXBmRj1E9WsGcCHR/yvNBTpMIEwSrOByBWeJk3jfy/z84wW7YeJ/zSG+YsGUSIsCS0fBQLQqtNXpDk4cUEPcGEgnamZXyqZlejKfvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=q+eNGmmj; arc=fail smtp.client-ip=40.107.130.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="q+eNGmmj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T8HJktSEWMDQNWmUPTpBTsJCtZskSfCFKp2aeU1viCiBSVVBzTwz9ZdFZCuDHFQvbNi2MibBPHrhxmdWam9Imu1Vl+nIfeE2QZx4CTmsoynfnI6FltuCDezi8kIDfz4X7ZLbks6cGfgiIUqvk4uy8y9LnXpLSdQc87d+P3IVC/TN0aSUPQxv5OwQ6ames0J5Og3HpxydRV9ffLbGeBCGI7Mvkr5pKc06apsYbVupNgPmSr9v0SP325MrnD2uOrqV2xTBfaYzP8sI88OZsgCPNvNIStHdWfFGZwZH9/gXBYMPKtgupjPTG0/x+QaNAWVG0zIzvui/V/xXA69NcoeBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQBMCuNDXvM2LM09SmU6aRqVGcqWMT7KyZzNkZU8q9k=;
 b=HG2kRrv7J2bCp+BBqiFaPyTlK5FWzzSWJJ8Cdp5fXxxdKi0c9oKJczTZ64a4XXnPnOSY5kKENteXWpP/kKFcbHwYGsS0QGbULy/J5sSRA2oogtQuEqr9GVTrH0suki6w5+/v28wOAAH0Z2/Fm1MyZn0Ni9BFhX0PWYlwROYIYLJYF0bwaiBd5loB+on1uQCUtqlRsR+Afskb5CWq/a/m0kx4sGXmJm91E0YRAPnwK+d86B1h8l+hXN5KcB854cTe3Nn/aK1KQipWUtofO1z4is98E4xp24dbgIrUNDuQgO97gTr3B8dPMSb8ji0da4ReNh2C0g+T1bksj8CSEPc9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQBMCuNDXvM2LM09SmU6aRqVGcqWMT7KyZzNkZU8q9k=;
 b=q+eNGmmjRSzdKiGJHW2XjodPwQqCBhqFw3ZSEyg/beX4A5VBvehEq2aNCnHTXbP0GE9EckBFv69gHxbGR8NPvOzCkEY6+E8R4f2M88RkNotMeUMLsH98rV6ZMSRQmms0MaIBo+0NzQkb3E78/Z6ijmuLWv4rqqZBkRiyY2+IcQLCPw4mwk9U4MLr5GgE8Dy6FkqNKI8Hj0LE4uFQZyjPKv6QeP2FkBFJC+v5cNpvp/UtoyFf8APn9WLthGu5kmnnznGb7HesqtDLufa/9JtA9TQ8FkJ8xXQ3Nt1Im65Ef20Ih+zpgxUSc4EA8nyFYEG/qxNtZL/SMHqWKW1uRXFElQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by BR0PR04MB519544.eurprd04.prod.outlook.com (2603:10a6:2c8:60::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 16:29:58 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Wed, 16 Sep 2026
 16:29:58 +0000
Date: Wed, 16 Sep 2026 11:29:45 -0500
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
Subject: Re: [PATCH v3 04/10] scsi: ufs: Move Versal2 M-PHY CREG access
 helpers into ufshcd-dwc
Message-ID: <aqrD-U1JR07zECr9@SMW015318>
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-5-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916084411.941297-5-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: CYZPR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:930:8f::18) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|BR0PR04MB519544:EE_
X-MS-Office365-Filtering-Correlation-Id: 03230652-8eb3-472f-ff7c-08df140fbfa7
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|19092799006|376014|23010399003|1800799024|366016|22082099003|18002099003|56012099006|11063799006|10067099003|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info:
 Bo09PJsfYfruU7ZbhSseIYtL8Ig2ziGaHrTGd+TpFQfqiyNd6EKW1iX1Lw6JMKRLMl/vmRQAYYEpGpPd522LruRfv8zmaKi9/ZFx3sFbfURLeNswJeh9O7HAoiz7ne6cFCm+OVUwNTDIDriS/DvR/BkAKozjhKnifL5VLWov+mHXOsy2tEgajRB9kKCgNKC8PdMNbWYPgmDq3XXWHeKog/ghd96NkaMQ1eOgWIOp5+sjyzm9GNcrme3XXumrAleBJE+3xTXH7hnKYzt0i4OBmoVqSJho7PeELNeSVg3yaInYMC5USdkqiVlL7sW4X3Q25W3cyo7B+eaq5Bb+vYI45IvJR4mNeH03fXk+D6DLBk/3UpU9zmj50p2LE/mot1mPPCDbug5S/nBxgb+YsQQAygkS3a+zyfcY0wwoq58ZfnMeLwZ2oHhSD1dvzmytaRlSDD0qUojlJCSLsqBfqJNUybShZj5IgZ5Nqs/zYlEwxX4UsztAyl5g54PGdrjxweJmCDRolI38ZFTejPXSiGVJnD0+gzgVWTjhtlbY0Nh5y4VetX8ZQYqNG2wwC3o5vdej9YurXRne3pYEmXaEikSnhxQsRRE60/k+k4XOyZOEvb2tjRd+7MqGy+bMLmXN9m7Mm5xOAh6JROdjH+Hfjzt1n/TFmQOILaZUWoY6xC4fMRQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(19092799006)(376014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(3023799007)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bFO/DHa1dWFIynNgUSdy8obVd7/PhKc42NmH6PlBtjm7//KFnYdCndOfoWV/?=
 =?us-ascii?Q?emDYk17Bbw/E5ydkvA1TUsJeD+ADMHDib+hEy7SxFvXhFMd+QxDEho/QjDGR?=
 =?us-ascii?Q?/VPcVELCc4TNxItyOVmZRlCn95/5PwMO9gK3ubWTgPcMOHdL4ZF0b21P114J?=
 =?us-ascii?Q?LzFEkQD/1ZwSBi0SB5jdQL4knEG/xiTrxcqI3JDF7qicv++jVlgcAqFYAQrK?=
 =?us-ascii?Q?Udwaie3p89Bw0vgloRQMELii3Ay6ETjT0UyGXClv7T5yszayiPjmhS94y3dx?=
 =?us-ascii?Q?D4JNN5eXHcaZ7DsTfdkxPVaD6FLwcu7hMkyQ/M5hpQwQVLb+ZbygQHvp91om?=
 =?us-ascii?Q?L0sBCTXVVNL7mjQC/QwpuD0WHtXgdS0nNOzcnRr6kkMReRKonnbNP/wibwL7?=
 =?us-ascii?Q?BfLnU/3KqfFeKiBM/ficPKl0gbKnKW9gjmXTqFKyKD6SvAwLHWvJhSBMvmfT?=
 =?us-ascii?Q?p5RGF9a1DqOf+gJ+9P7V1dNKTBRfkByX9pECeMDaFH6FvXMXk1wd5YWm1A4A?=
 =?us-ascii?Q?o9HL+DWk7Fe+Oy48si57hFsf/dUmU5/LXdMWCGmdnQkoGIMZ2BKLg6oojKlg?=
 =?us-ascii?Q?3qkZmLTkraxV6VMX1gCQKz2IQowEncxNAJDGrnr4GDZEzLLa2ElOnzJwYWEV?=
 =?us-ascii?Q?A4URdnHHn/jU5YVKHxghKoaO/DL92rUuHy7nrZONKkUHzXDGbvxo79+Mw0yT?=
 =?us-ascii?Q?EtI/N54Rx9+TY6cPVFxuP1w6mzAOk+31TGq0CxtBkVWy0R58WR4EzDBGH5TK?=
 =?us-ascii?Q?KsmHSUS4LLJPJrNf4TLxAxasL3IJGUCsDCfkX8+XCsd+28c/5aHKiGj4TAwJ?=
 =?us-ascii?Q?VLKH5KEqlwg3iHvui3EJXqNhuwOvRuN5Kw782d71h/BeYwQ9Q2mpceyQ3apL?=
 =?us-ascii?Q?37JhkJ2eZdwHGfyy0hmcmeV1cGUr55GnYZq0OwA38lHgwJ5suzw27QHoEY/N?=
 =?us-ascii?Q?6VzqI25lZ7fbpwtnsT+MT5lDD8ZQovipirSw23bJqB3ztzFbBZ7ZUYIZGcFl?=
 =?us-ascii?Q?2KWIHvoeCODl2n/JH31FHsbwerLA0Mdu8oqBF+nenm9dYF0NsP0s3ktH+WAE?=
 =?us-ascii?Q?SNkqP5deeW+pBO8m81209eRUu7fT/Yodgjh5Aynk5UBfYmM0J2gt1jDGuqGv?=
 =?us-ascii?Q?//L+lUaHf8JyRoskZe09xexS2SIonyGVY7KoYJbno2ejvE91k1jrA/GsEM3O?=
 =?us-ascii?Q?kQcj19wx7TXH8jD6seThCwStSJ83N2CHk78sA7OOPIDAWrXlIE/kXD4+BoF9?=
 =?us-ascii?Q?gJbGS7o6xx4EqX8sO0iIHxZZsuTOA3Zk4mv0WFz20/zVASdpxQljvPn4rNOh?=
 =?us-ascii?Q?U6v11bfameui5H/3XOhJipc0vPOjmRl/qgqpEujwxzc9p1uZuCiVF7DZ9IQp?=
 =?us-ascii?Q?qL2iq8RpMAH/r5mMDjZ+rojrStaqQMBi+VmoTKAo6jcCSwbTZ/dkCu07SkXw?=
 =?us-ascii?Q?VtLl0oemcCohONTW0jc3X1SCHClnXcMROB0e1g3tQkpj0IgivSoluM7ChSuS?=
 =?us-ascii?Q?dwPbXeciXRf9cpV+piNIR3k0idtm7XslvExz2b54gvUqaUb37vGuSBoK+vca?=
 =?us-ascii?Q?ZcKZ116mh/AQ9f+8oQ7PDOttc9I9LazLBpRwvkiJvZ9QnJSgh+EJmcsLBED+?=
 =?us-ascii?Q?0GBNeMDw60zsL8nvn/bPCsqFnatD4K9U7MtCGoA0GhegkSc6M1EVPyBOX8Tp?=
 =?us-ascii?Q?X8YZJ4X23PHJitQkuXgzZHTPBF2xAxB2vQ99uwgVPRD0r3TRd31hC5lLKUkE?=
 =?us-ascii?Q?nVdI8OWebb01A4FNCPemjPzV8x9e3bP5er4vsRbxPckMPVvCdKc1?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03230652-8eb3-472f-ff7c-08df140fbfa7
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:29:58.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJikXl/5Lse6gargErsVhOS2+hu8NkMt/K0BV6dnnquTtMff/m560KQa875sGleDfl/8TKaqxRm4WTP7AFgcrep/BTKWFZvCHYKEqeT43d049GVqo1gTZ+IkxtNHlQO3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR0PR04MB519544

On Wed, Sep 16, 2026 at 10:44:05AM +0200, Larisa Grigore wrote:
> The AMD Versal Gen 2 UFS platform driver carries local helpers to access
> M-PHY control registers through the UniPro CREG interface.
>
> Move these helpers into the common Synopsys DWC layer as
> ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
> duplication in DWC-based glue drivers and provides a single implementation
> for future reuse.

Nit: add empty line between paragraph.

Reviewed-by: Frank Li <Frank.Li@nxp.com>

> Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
> is no benefit in keeping them persistent.
>
> Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
>  drivers/ufs/host/ufshcd-dwc.c      | 69 ++++++++++++++++++++++++
>  drivers/ufs/host/ufshcd-dwc.h      |  2 +
>  3 files changed, 88 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
> index 0d4d5e98ad65..c7da95999c85 100644
> --- a/drivers/ufs/host/ufs-amd-versal2.c
> +++ b/drivers/ufs/host/ufs-amd-versal2.c
> @@ -43,57 +43,6 @@ struct ufs_versal2_host {
>  	u8 ctlecompval1;
>  };
>
> -static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
> -{
> -	static struct ufshcd_dme_attr_val phy_write_attrs[] = {
> -		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
> -		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> -	};
> -
> -	phy_write_attrs[0].mib_val = (u8)addr;
> -	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
> -	phy_write_attrs[2].mib_val = (u8)val;
> -	phy_write_attrs[3].mib_val = (u8)(val >> 8);
> -
> -	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
> -}
> -
> -static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
> -{
> -	u32 mib_val;
> -	int ret;
> -	static struct ufshcd_dme_attr_val phy_read_attrs[] = {
> -		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
> -		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> -	};
> -
> -	phy_read_attrs[0].mib_val = (u8)addr;
> -	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
> -
> -	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
> -	if (ret)
> -		return ret;
> -
> -	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
> -	if (ret)
> -		return ret;
> -
> -	*val = mib_val;
> -	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
> -	if (ret)
> -		return ret;
> -
> -	*val |= (mib_val << 8);
> -
> -	return 0;
> -}
> -
>  static int ufs_versal2_enable_phy(struct ufs_hba *hba)
>  {
>  	u32 offset, reg;
> @@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
>  	u32 reg;
>
>  	/* Bypass RX-AFE offset calibrations (ATT/CTLE) */
> -	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
> +	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
>  	if (ret)
>  		return ret;
>
>  	reg |= MPHY_FAST_RX_AFE_CAL;
> -	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
> +	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
>  	if (ret)
>  		return ret;
>
> -	ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
> +	ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
>  	if (ret)
>  		return ret;
>
>  	reg |= MPHY_FAST_RX_AFE_CAL;
> -	ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
> +	ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
>  	if (ret)
>  		return ret;
>
>  	/* Program ATT and CTLE compensation values */
>  	if (host->attcompval0) {
> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
>  		if (ret)
>  			return ret;
>  	}
>
>  	if (host->attcompval1) {
> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
>  		if (ret)
>  			return ret;
>  	}
>
>  	if (host->ctlecompval0) {
> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
>  		if (ret)
>  			return ret;
>  	}
>
>  	if (host->ctlecompval1) {
> -		ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
>  		if (ret)
>  			return ret;
>  	}
>
> -	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
> +	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
>  	if (ret)
>  		return ret;
>
>  	reg |= MPHY_FW_CALIB_CFG_VAL;
> -	ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
> +	ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
>  	if (ret)
>  		return ret;
>
> -	ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
> +	ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
>  	if (ret)
>  		return ret;
>
>  	reg |= MPHY_FW_CALIB_CFG_VAL;
> -	return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
> +	return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
>  }
>
>  static int ufs_versal2_phy_init(struct ufs_hba *hba)
> @@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>
>  	for (lane = 0; lane < activelanes; lane++) {
>  		time_left = TIMEOUT_MICROSEC;
> -		ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
> +		ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>  		if (ret)
>  			return ret;
>
> @@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>  		else
>  			reg &= ~MPHY_RX_OVRD_VAL;
>
> -		ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
> +		ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>  		if (ret)
>  			return ret;
>
>  		do {
> -			ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
> +			ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
>  			if (ret)
>  				return ret;
>
> @@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
>
>  		/* Remove rx_req override */
>  		for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
> -			ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
> +			ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>  			if (ret)
>  				return ret;
>
>  			reg &= ~MPHY_RX_OVRD_EN;
> -			ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
> +			ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>  			if (ret)
>  				return ret;
>  		}
> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
> index 21b1cf912dcc..0eceec543d14 100644
> --- a/drivers/ufs/host/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -141,6 +141,75 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
>  }
>  EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
>
> +/**
> + * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
> + * @hba: private structure pointer
> + * @addr: M-PHY CREG register address
> + * @val: value to write
> + *
> + * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
> + * UniPro indirect register access interface.
> + *
> + * Return: 0 on success, non-zero value on failure.
> + */
> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
> +{
> +	const struct ufshcd_dme_attr_val phy_write_attrs[] = {
> +		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRLSB),   (u8)val,         DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRMSB),   (u8)(val >> 8),  DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1,               DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
> +	};
> +
> +	return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
> +					ARRAY_SIZE(phy_write_attrs));
> +}
> +EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
> +
> +/**
> + * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
> + * @hba: private structure pointer
> + * @addr: M-PHY CREG register address
> + * @val: pointer where the read value is stored
> + *
> + * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
> + * UniPro indirect register access interface.
> + *
> + * Return: 0 on success, non-zero value on failure.
> + */
> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
> +{
> +	const struct ufshcd_dme_attr_val phy_read_attrs[] = {
> +		{ UIC_ARG_MIB(CBCREGADDRLSB), (u8)addr,        DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), (u8)(addr >> 8), DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0,               DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1,              DME_LOCAL }
> +	};
> +	u32 mib_val;
> +	int ret;
> +
> +	ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
> +				       ARRAY_SIZE(phy_read_attrs));
> +	if (ret)
> +		return ret;
> +
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
> +	if (ret)
> +		return ret;
> +
> +	*val = mib_val;
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
> +	if (ret)
> +		return ret;
> +
> +	*val |= (mib_val << 8);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
> +
>  MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
>  MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
>  MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index 0406f2bb576b..d8673cd54d4c 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
>  					enum ufs_notify_change_status status);
>  int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
>  				const struct ufshcd_dme_attr_val *v, int n);
> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
>  #endif /* End of Header */
> --
> 2.43.0
>
>
