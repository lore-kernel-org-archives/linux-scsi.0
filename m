Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011004.outbound.protection.outlook.com [52.101.65.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68842A14D;
	Thu, 27 Aug 2026 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787827398; cv=fail; b=LBscwnLjJCpeNQm3kkjtkISr+96gTBrCIC6lER1oMFxzgCuGOmwLdCahyDA1LwOGTytMptfQTJ3w1fnAyHQW1CQkGY/jQ+TzkNds6BW2g14vZ0WQQa2kzKnRvnYQZ2+X6kNQML4Qg/0K1pVGTS+AJymBzICBBjSVvx0gX78DqDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787827398; c=relaxed/simple;
	bh=DrmDOhWDiLw31wjYNGFzK8gZYZibfNTAOH5l6eK9yt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bZ7lPwU7UETzVInUcWBiLbJL+pxN9ua22H8k47Un1XQk5g6wE1bwiOqnpkL3Z+ikHKNfUhAp74evv3l+UP0QmkwT/mHRrgLcxcyFtlS9X4lFhybhEZF7+cJm9cP9Bd8MdTsKeb4zq1w2FXys8aH6Za7+Pl2QBOVLyDrkxg7a0dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=R3XR+GGr; arc=fail smtp.client-ip=52.101.65.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="R3XR+GGr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k3AbeqN9YUCxnUC9ZbnOcwUPlbZhq7yiOP3Uzn7Jmz0rOIUsEAW8EVjgN7xCW1sUiu3L6KXPaDmHbgs/FE/4hvXBe6DgJgO0MoBMS325uZjcwP2zTjtDdwJa0+fZv9VW/r3Ig9OZjyrqhIkiunirMhRJEKj4TXViG5MgFHEjnVuoavJrGlthhPaBBQx1PVxVdqCYIvzTwnJF9Xg3WmNCBhWfHZzB6RGnHPdgSX+q7y5FMiHbeQDCdNivXXMyCq5N+4u39GWYdCzHkKNq883AMRLXYdgZvWGZMGfbxcj4OQDA5Tkuj98Ke2m4n3DYSCiKB3hk0fifP4CTh76/fHXMGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3Hd9sjhuHnEJSWpNWhcIzcip0KTOhv4GekjdLwhpw0=;
 b=D4spfcJFWA/GBLz1rAWUYee21S2FQgitYo6zRONOqqXRRd2Ype70155b3WVHspkwD+7vkDLTswGDNnWdkNmHS0mQm6ifgXb0Ycq9i9Lzs59kxne40ITK2Gsy2Li3al5YpHbbZlsXzsG0ZT6kiPK3x0yzX27Pfh0l41NohLW6H3/ko11NgzbtHN1fC4RWa3+EsB+wvAMItBQjK5sWlrnBJkuWKfXem4A7ud/EWj0jmxHNQJ3FMsk67Oa/uRi4Nyix2CDB/Phd2H5YhFbLNo3gpTKGGem4KCNEYXk6GOjHz2YCd7kS6gAUjYDhr5cZA5FoBmDeNdsXsOHA+XhVivs4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3Hd9sjhuHnEJSWpNWhcIzcip0KTOhv4GekjdLwhpw0=;
 b=R3XR+GGrx+Y89dLPjblmZk1t8792n0AeH8nGJRBRMCZQ1S8qUFaBawbYQQJGD0KAYNbXkeCPzuCn1aPro4wWSqvCU/aCkTekiec9GFmukRtjJ/78UbYNxHJfjLwF4TxVGXWuX1P1qEah4KrVA3Ppf+YjCDBvoJ7JdNShQ4SNoIHSNZCM77qp6UFWHJuZ07rh3csNDfcgYSJuykap4gFlyHTkrveEZEpZPPe46ZSpdGf9DyujTIRk8IZtYLHSgSLjcAXSCgVYb8oo/71PuOI6VzP+xveHivdVn5P2ztTcy9Au5es5RZtKORZMYfICD+9BUafpBKu/LYCn1tputKl6Eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from PA6PR04MB11909.eurprd04.prod.outlook.com
 (2603:10a6:102:51c::22) by PAXPR01MB10415.eurprd04.prod.outlook.com
 (2603:10a6:102:247::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Thu, 27 Aug
 2026 10:43:11 +0000
Received: from PA6PR04MB11909.eurprd04.prod.outlook.com
 ([fe80::a4b:fa4e:7fe7:e6a2]) by PA6PR04MB11909.eurprd04.prod.outlook.com
 ([fe80::a4b:fa4e:7fe7:e6a2%7]) with mapi id 15.21.0360.006; Thu, 27 Aug 2026
 10:43:11 +0000
Date: Thu, 27 Aug 2026 18:47:15 +0800
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
Subject: Re: [PATCH 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers
 into ufshcd-dwc
Message-ID: <20260827104715.a4w7zdrjbp7wwtig@shlinux89>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To PA6PR04MB11909.eurprd04.prod.outlook.com
 (2603:10a6:102:51c::22)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR04MB11909:EE_|PAXPR01MB10415:EE_
X-MS-Office365-Filtering-Correlation-Id: d7eccd7f-6bcc-4a86-117c-08df0427fd77
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|19092799006|366016|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 vDODsuGb7kUAXQGRJkabEP3sQ0tFXMpG9Pdxmj3gqcePVMG3nzYVFUU0onpjO+15Z9F6yv0H9VgziuM9fp0HiS9cR6OLsFl5NHq124J28aavPUWznqx/joPdBnQWsqkMZoMWlxrQAmtrLK86VZjbF2XHEEAhiXiIc/bmpur6AkDi5wKPHqjaJnSe2gD5+t0IGxK1sfbYXZOMw9kLG6Hf3SUJOj0htMZg41q6aGhdA6VQBB6XaonIRVI84qAOTKmGIoHQeaOPlotnHgTTlYiXOeV9SYY5zwsZL34zSGB6nFF1urvvFEXDQmoQ2+0R4ib09XFlKFYpWpNjMP1foi4Rl/mC5XttvZWthRbBUbnr+yYrFBJMU99D4jve2WDlxJC3mPBSJRGpuAyP1QRkBIpSfAzGWWIUrA7E9jgArzwHl8sumz8P5aIIgPMipHg2HDbjKw3eeQ8OQJgZ2clmeP/yy786AyJhIaLZsnJsrF+m9xQ/qqE4NZw7GcHmyew8/LLZUNMeAfPwrQ/3kXuFa8vBKPOx8t/YOgABMsPGSFmOepd0PoRsLwff/WJoh7WD+Cm9TGcLGHd8yubRh1Yho5cLz24zDCeOxB3qtqqnubR9s3OFqBMo2+KEtg1iss38bwH4yxn+8AIO/XMjPV8qEtJE9FVA3qMODs6HAw/KF/IFsRw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR04MB11909.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(19092799006)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?BpVyfJlhrnioQ7K4jxPpJQTUN2CE0nR+4rf6VqwzkmBWj7YYmp1WIbOmABps?=
 =?us-ascii?Q?lxjn+7jfGQFVwLwg3BE3lcZH3tJGZwcl24OGuPyUeLp3GSYXnyj8XkJeQKI9?=
 =?us-ascii?Q?V4gsbehi5xjFwfRPAMMdrnbNUHKO45QDY4ev4IqMTV5/pwKLA7FPFDVbpxvI?=
 =?us-ascii?Q?vmL0NcJ/LnVLB0lmZUi7Jx/MYcabeAh8XjOWjl6rwIZ73Gd74kj8ZyGJV9to?=
 =?us-ascii?Q?7fOp4UbeFCTs49W+ls6VcN3VH8d5FYYn1m8MRZxMapuea4BRyOOE9zSZi7ev?=
 =?us-ascii?Q?urHPRi8dJPk8FXm5h5o0fzSHHe1hIo7ThGW+3Abt8ZuYZX4NYvyzYSTfaXSd?=
 =?us-ascii?Q?DKVuqewnjis28vMqczWThOYCbTqRWQjUKMWssWbbFBBG9Y7DOlMtmsgTYJb0?=
 =?us-ascii?Q?ChncRSJXeZUriJEyPDtB3gZLKmGluRtVjpwFLlVdKVsOqEaNLrQrXUwJw8v0?=
 =?us-ascii?Q?1sWq4nd0m+1Xbe76s8E2hn03wvBO5vGyZQ5GlJhO3EEBUrkNAS2Uu6sU0cjl?=
 =?us-ascii?Q?cHQwJ6bp3nWOAZkGWrPvLX/OcoXiigcX0W3dLWfDFoYJQcWmXnttB1xqamcv?=
 =?us-ascii?Q?tsjGrB0YzBmRaHJQOOkQ4cr8YmFMUFuaRnrlkgzoo4iI1GIGOPHvqJfu6vyi?=
 =?us-ascii?Q?glQ2JsOvYPHt2v3Qo371R61G9LzbuurSa08gvsvelF0xLUr/KivQrFmW8zR8?=
 =?us-ascii?Q?FZdRv+3SUAEmbjdHe4gcWstqYJ7PUI07gBKYnZB8nCevKWaMrRSVfMoFQHPo?=
 =?us-ascii?Q?THeOk+2auit6JuTwXYeBsYwBtwNyfaDr5s4yD2j1Yt0OqS2xy+Wt9aXMDAcS?=
 =?us-ascii?Q?V0Qh1h6qH+rW7foSWeZFw+zB1cVbLxMvqHKW+TF+MEd594FfeQiXaCXRD+c+?=
 =?us-ascii?Q?lyXUc8zxl7tVe0d4X4IcGMIXlNKoe7K/KL7curE5zWrCeU7Jo5hU7Na/S8gG?=
 =?us-ascii?Q?xpcT/7vwiSuEV9W2r0v3bSyxVMl5m0goiOPAHFmsJ2X4VrU34A396qGVA8Ua?=
 =?us-ascii?Q?AsP3kD1cgB4dtzZhVLSlZszDu081CDNbpBI3pzPCgfma4cwuMZ9Jt3OiWsJ2?=
 =?us-ascii?Q?JSUSTlYDdOqrnFRE/C0z2O0IRKSUmKopP4uSx9f+ME8RUOrPuFIw950BMiBl?=
 =?us-ascii?Q?qRwXEdX2Isb8J3WUukUOGlzQezr59kEdFGQD1vFEFiTLvx4KXWK2OuEslGeg?=
 =?us-ascii?Q?GjAt+4iOjzCfS2PeCVXZ9M6Jzk+f+AZMLyzPFPrgskb46SUP9B64HtJcg5Gj?=
 =?us-ascii?Q?YisDLtKQMYvgwAtFZBBzmdIsmddgLhS3F91TueHD0OKUiqHIHA0YYE0tJkm5?=
 =?us-ascii?Q?iFB35TOiq9IYrWlCwCsLfw2fAwjlQ/YfebmK9Juj9Oz9ELzWoeysfJ2u4Nwo?=
 =?us-ascii?Q?+u2e0FHlKU1jDxCtsWO4ZCwBxkbIH8RD/jIF9unQsn1tfqZjvjYNbzQxR+z+?=
 =?us-ascii?Q?JltWQIiguCuG3JKKhfusLe96b9ozteYOBLO8Ns/Lk159Rd3mfgHhkh+441y7?=
 =?us-ascii?Q?IEFyXilhr8ZatiBH9VQ6HyK0gGGIownyxV/y30vQwEqSWqDA3n+h0n/kKrtm?=
 =?us-ascii?Q?pyUXP9oWhtns3RdmOGL/fSiVyonoxLI24RRvkt5/++lrIKmN17ofIztAze2B?=
 =?us-ascii?Q?EC6oR+9BVzP3eVprSFdGou+eem0P7BxN6zFMO0+LxM6Kd+lRGLO7AAtyPNT+?=
 =?us-ascii?Q?F9cgXVocOirq9MD3nSknnVFhHZD5nLlWO1BB6hB4NZGfweZqM3YUTasiq+rY?=
 =?us-ascii?Q?sC3m90BOnHG+yumnq7VP7e8qmOOXtyAAIcV4m8TnKgopLzSRkTBr?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7eccd7f-6bcc-4a86-117c-08df0427fd77
X-MS-Exchange-CrossTenant-AuthSource: PA6PR04MB11909.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 10:43:11.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLfc/EthyXTVDSm/0qRA1kQdQ4L1mu7clszhyo+bsB7KKmsbDKNL/l5dE1PHtNAUdShNIGW82U2qjSKGvGF0ViZRkZ7ogEcQTkoRl5c52KkOULCatbe8bTRCnC30ozFD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR01MB10415

On Wed, Aug 26, 2026 at 03:40:42PM +0200, Larisa Grigore wrote:
> The AMD Versal Gen 2 UFS platform driver carries local helpers to access
> M-PHY control registers through the UniPro CREG interface.
> 
> Move these helpers into the common Synopsys DWC layer as
> ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
> duplication in DWC-based glue drivers and provides a single implementation
> for future reuse.
> Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
> is no benefit in keeping them persistent.
> 
> Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.

ufs-sprd.c also contain similar code, seems can also re-use this helper, but it
do not include ufshcd-dwc.h, Unisoc(sprd) guys can do the further check.

Regards
Haibo Chen
> 
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
>  drivers/ufs/host/ufshcd-dwc.c      | 77 +++++++++++++++++++++++++++
>  drivers/ufs/host/ufshcd-dwc.h      |  2 +
>  3 files changed, 96 insertions(+), 68 deletions(-)
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
> index 21b1cf912dcc..45920793d1a8 100644
> --- a/drivers/ufs/host/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -141,6 +141,83 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
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
> +	struct ufshcd_dme_attr_val phy_write_attrs[] = {
> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +	};
> +
> +	phy_write_attrs[0].mib_val = (u8)addr;
> +	phy_write_attrs[1].mib_val = (u8)(addr >> 8);
> +	phy_write_attrs[2].mib_val = (u8)val;
> +	phy_write_attrs[3].mib_val = (u8)(val >> 8);
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
> +	struct ufshcd_dme_attr_val phy_read_attrs[] = {
> +		{ UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
> +		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +	};
> +	u32 mib_val;
> +	int ret;
> +
> +	phy_read_attrs[0].mib_val = (u8)addr;
> +	phy_read_attrs[1].mib_val = (u8)(addr >> 8);
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
