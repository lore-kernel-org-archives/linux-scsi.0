Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011021.outbound.protection.outlook.com [52.101.70.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F282041B8EB;
	Wed, 26 Aug 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757654; cv=fail; b=Ne7FlPU0h/kwExJsPuS0MOP2MajJ06twDWLV1HenbHZLVdyDIN3kojXLBPaOKCEbG5IbpS4kIxr5ZTk4Bxmb8wsEO53sC8nR0qR+uF9vPxMPgiob1lpM+NgDC5uhRcdCxBYMBZw5rC2g1ol0xw4f5VwOAFDJbEy7yBxHk0ZoMGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757654; c=relaxed/simple;
	bh=lgULQNLau3Dv6Z3GOqEyInrbAywNnThhbGWTVfB1lnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qor5tlXaG1UEsJoftadN0jdn1mC6GeoZnRie0gbj9uTG0aSVp/076WEjnDnqVhMBwR8ccoGU15ba9a6qRTHSb/bLDDi60nfB/1RQ079vYUkLE1GJ3MW9lNPbpAhWthiTioHzvWg1aL6YbiUxXXznf1uQALoih9b6wsAGFtBuOw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=RCwoL4YL; arc=fail smtp.client-ip=52.101.70.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="RCwoL4YL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yd/a02bPJ8byOhtCaX+hZaYmawEEJ6cwQcP85iTCsJXMh6J6DKOp0r8Lj8EWWG28xtytMQY+hxrp+KmE+NR99LXbzlCyxySiLjg1ueoiQ/RD9rA9hbGiyVy9d0JZQ/FfWLR9Ka5bgPraSk3Ir/d3t/UzCv8RLdOvzWD5Xv+VSvU5GzisELkLkY89SccK7HxDFT/o+ZcNZvMoVA4hoKv8gADn1hDWqF/5xlOHUo982yiQqxSMlSw9ey7vimnvvHKKZO8zN6Ga/p/buiYg9H43qjj13gETEKgvjMa+RA6c9HGUldk1LQD9Ue9kv/bkePkW9n0pkapYyLJ4nFdZD85dwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQzhJlBOnrsuvBW3gPo1B3nMYX3OiY38jfaSZSuP1yU=;
 b=fayv3CHLgzZvopM+7iEP/TVjceobzsyjtpowRwYqaBbeg9qYSDApTYUi9FSsGY+cSPTx4OZkZoTv8UEFhhb5pyXvutDHq46EexEYxLRoo4OnWip/mKO0WxUuD6lt2T41IvbMUohgBFmX7bxIEGgp2ppuFU3u48SrFzOYOHuuJ4+QbsYMcKRVj1KJBP3+ZCkE+Z7P16cz8ZFFcbuVioxHENc/XUU7ugki/xyF7boNlVAFZbK7FbCnhHit16dmYLW/NDHSmcamV8GXD9lB7UASgaJGaiAIaaXP1fpEd4CW+bkSlwTHqv8r7VyTsc/MEjfNWttLPvbb0kOjoa83aZ4vUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQzhJlBOnrsuvBW3gPo1B3nMYX3OiY38jfaSZSuP1yU=;
 b=RCwoL4YLHbdY6K1sMPCN93LkRm+ovJLAbEUpYaqmWthQ65e5LN/5bOKBPRF7Mr6cbql8bCyuW6cJhBp0ZlWddoiBaq/yMkrNuhyXYV9+l0UNBlL/jS3rNWOq9Y4ulQqxuN+0MmyCfXdSt6ijdSBGyzaakiaT8d4JfdASIwBoREdtrW2RU9HV0yOXsjSdUUJqGpqeZxE8OwfnZixLOObZcbTTkddn37DdSyey+nbHDk517Kw3ufbhN+LASumGscWV4Jhx5m7+Khu7imTzdWcLG/Zco3/hH17cw0DAwNv+nXt2qmnNqxKZH2TB7Usobt3IlKjo1dj1fPuaG8aUSk9hdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB8PR04MB6825.eurprd04.prod.outlook.com (2603:10a6:10:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 15:20:48 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 15:20:48 +0000
Date: Wed, 26 Aug 2026 10:20:36 -0500
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
Subject: Re: [PATCH 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers
 into ufshcd-dwc
Message-ID: <ao8ERPmAsNEtKHUn@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SA9PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:806:28::6) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB8PR04MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ab49e4-4510-4d06-4221-08df03859b2a
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|1800799024|23010399003|376014|7416014|10067099003|3023799007|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 FGhmITID42FSRjAtu4RuPMANJWbDebfbthTc7iqGGou72id7R+ttRIHaDuKXtm0/66B2twQ6h95Xei3OkxdehThLP/WZmu5duF39Dt3mTsYjvKuvr/h7/RX8qC3KCK0CWzVtB7bbNaIu2WtQon6kz41Q3LfjTtvU+7V9hahDnsOX9f/jvOAi2o4ct+L4Y/XAVWfG4zDq6927dPt1EPvYKtah9hkyohnopgeDB64adrMEt0DUuU9giVZadsBE0yqyu9v5YKhnCwwzfAdWWocixEFiDt25liHIp57TcIb3sy/bpUnMIWEXjiv7tAv0nTl9ScRkgRlExVWWymZU7XSeuMwjVfwNjbxOpovNCWB67DxX8ESF2qPj/CLlqcIOTVjBDhP2sfpOVGagC3cmJ5WoGhVTtckodphzb9ucpY21SsYdXORo3APQ/VRDgfSh2qFJVlJcx8dp4chBn6UXXHAQVoU9Im4ZvefQinxQxLSv8CD424BGXfCK2baVHWezCrCCdizIjbE3cKWHF2OQUlSlUeuZjb+L+Fc80OTBhBV/mNSM6jHTi2sUlUdTLcXrsOTlovoNGa1zuolG1Fx6dmwoUVNyihTfs/MgAhXQ4Z5PYcXVr3hZTque/n7jW3X7Ocns16X8dJ4i46Bc9m09KoGiCNx+23opSrjmjFmik/nU4E8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(1800799024)(23010399003)(376014)(7416014)(10067099003)(3023799007)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?ouc9q6jAYYyl8XE5BSQhUmsMrkthljtrgSfIIof7XK3MW5Q73+aCHTj1rEYC?=
 =?us-ascii?Q?b7jwhvzOqpAE5EgdM3fDIEX1+M6dR27EA4aRojUHjYykLTYLtPMAToesscqq?=
 =?us-ascii?Q?XjguFggamkacQpE6ypwFsP85iHVKSYGmz9Q2WocxaUm9SKeWcom27gs0p36M?=
 =?us-ascii?Q?jqgzLoZ8hH/cfRQi3Nnjp6Ab1fhd1Uq08TCp42R9yRXr11VTXuOtvHpYo+U7?=
 =?us-ascii?Q?Lrb0+LWaI4T/52uobZQ1u93pJfU/QdfAspBUJcIcnTOY5kIfNS3jauoj5a6z?=
 =?us-ascii?Q?V70l6hsj44gOhGfmW1LlehE+6E8vezMwlS4hpbpDxaq/xGFsrujAMRKdr8Md?=
 =?us-ascii?Q?ilvDgF3PP248ZVbuBwN/czeIcLAN1THSE+t170wvhdGikZO1BStVfIfoEtzg?=
 =?us-ascii?Q?gEKVrGR/yg0T+TUzAlgNxXh+CfnVSXc+bQHlY7DdPm0yyzIdGn6Wo6moc9T+?=
 =?us-ascii?Q?M0bwRWdlYElt7xN9QhOpfpg2xncn4ZyqKOYRZynMNopFKAEyEb5Ub9iomIEd?=
 =?us-ascii?Q?XTpehZlDuFdiryzVx6n1uxabsUX9WilILMM5ip5IXbf4VaJUHduNgH0KDsd/?=
 =?us-ascii?Q?pPXVrf/80QVNyJ7Oi8KLFoI5Yafe8LQ7zgoQAEK/uG3uctBHzzxfccX0w/cV?=
 =?us-ascii?Q?umApwe4qyC0FX7XfhDW8Mjy8kyiNDh5x3OmETR4jDZD8LHgrH09R88bFpRro?=
 =?us-ascii?Q?MOER6pNoiXkNnwYyeCYZKCKU5BXJAGLA8d2IOwqmoi1zPwX2eWVlD2WE9G6B?=
 =?us-ascii?Q?7Cgx7vt8jrCU6VmLQ7uODiCgUmYCbhlmZgInNkVbj/mjD4VF1Re2dxslBBCq?=
 =?us-ascii?Q?ruvS61wiCNhfq+Oh3CuR40l1H9Ds7hefE3zs2KtbsRQNoi/2VJeKXaz2Ty+0?=
 =?us-ascii?Q?z5rKBb7RWBkAB3vVVhERKBdkLhJuhOQ6Lj0KMDl7CSbAN1OniRiPUlmTq9yk?=
 =?us-ascii?Q?q61v0udZXWt5mhFYmJEyHhISZ6UelUDtt+tlwx8USO45ZDJFI9G8Jj1bw8U1?=
 =?us-ascii?Q?Sli2U/HMNKipcJodrqQR40YAT99uOH0V8iDJkvn3WLCg6f35YYN2n7PAm4yP?=
 =?us-ascii?Q?ZSXZs1EyDrt8UMCH5QvnlyRSjEQaX6ujFSDHWAize7JW3MWlPNqWGet8D0gT?=
 =?us-ascii?Q?rQQhhXL8id3PTN55R61ibVUNAKFylHrHvIZ+prHMiSm6CRFoPmIg49s8kEp+?=
 =?us-ascii?Q?TDmUy4fNfsu7K+u1E5MdfwniW2s4wKkgLxD8S2OzEOfYmftxL6dGYHnQUy55?=
 =?us-ascii?Q?+MDBuYqPVwBl6myu4ukfL1KZfijK+5kd5IRQOzhdjqPobA6C+58iB9c4/5rL?=
 =?us-ascii?Q?QFH5X0Pt+IphL27Ys/w/j35yb4Tm3OCDusnKUAsl+kLmy5juM15dvS7EYDmf?=
 =?us-ascii?Q?5V6wA/RPBsSL3w1LSL5GE3YIwsRxnyZ67ZMV9r5NHoK12+K0hQywpzZdn33N?=
 =?us-ascii?Q?Fqj/Fbh7+L2PoTEEWIIjdUcB+5nj5Zmw4p61xlfuoeNW8HZqgnbYWE8AdjEz?=
 =?us-ascii?Q?TJDqvo8/amwNq0ac6fFT26mDz+JD8XD7YNO2wLDTN6fV29wsetqmCn5nFCr9?=
 =?us-ascii?Q?7LY+1o16EsvdYaX2Kel9fFLq45+fbc/GJYpQ+v/nXmlkNwmXHhVo6g9SLZGs?=
 =?us-ascii?Q?7hqVuPzd9JIr/n9yGa1YiBaFb50AzHP/IZq9F6slsLptcq1NDRXqw0LOn1tW?=
 =?us-ascii?Q?Yeq3/6/V7CRh27niQ8kFo1RwCAPW7s82Xnch13A4n3vYD7+CmrWiiScwzxJI?=
 =?us-ascii?Q?WfiNXi8YakQMBWW4iUR1kJgycN0DbpeylDCRnWZ/8yJEYiEnubnn?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ab49e4-4510-4d06-4221-08df03859b2a
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 15:20:48.1499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NpHwnR4mGQ9Mn8c9XUrphDk04lFSJGB6RGpTuiKpxzqYTHDu+VpDZ8XKeD+wqKYvUHNokvSK9BTdwhII9zWtn32ED4iY2S7lNzyHqy3vYaGT7opdSKeyO7ZpFT1jJmb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6825

On Wed, Aug 26, 2026 at 03:40:42PM +0200, Larisa Grigore wrote:
>
> The AMD Versal Gen 2 UFS platform driver carries local helpers to access
> M-PHY control registers through the UniPro CREG interface.
>
> Move these helpers into the common Synopsys DWC layer as
> ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
> duplication in DWC-based glue drivers and provides a single implementation
> for future reuse.

Nit: add empty line between paragraph

> Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
> is no benefit in keeping them persistent.
>
> Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

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
>         u8 ctlecompval1;
>  };
>
> -static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
> -{
> -       static struct ufshcd_dme_attr_val phy_write_attrs[] = {
> -               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
> -               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> -       };
> -
> -       phy_write_attrs[0].mib_val = (u8)addr;
> -       phy_write_attrs[1].mib_val = (u8)(addr >> 8);
> -       phy_write_attrs[2].mib_val = (u8)val;
> -       phy_write_attrs[3].mib_val = (u8)(val >> 8);
> -
> -       return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
> -}
> -
> -static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
> -{
> -       u32 mib_val;
> -       int ret;
> -       static struct ufshcd_dme_attr_val phy_read_attrs[] = {
> -               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
> -               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> -       };
> -
> -       phy_read_attrs[0].mib_val = (u8)addr;
> -       phy_read_attrs[1].mib_val = (u8)(addr >> 8);
> -
> -       ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
> -       if (ret)
> -               return ret;
> -
> -       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
> -       if (ret)
> -               return ret;
> -
> -       *val = mib_val;
> -       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
> -       if (ret)
> -               return ret;
> -
> -       *val |= (mib_val << 8);
> -
> -       return 0;
> -}
> -
>  static int ufs_versal2_enable_phy(struct ufs_hba *hba)
>  {
>         u32 offset, reg;
> @@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
>         u32 reg;
>
>         /* Bypass RX-AFE offset calibrations (ATT/CTLE) */
> -       ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
> +       ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
>         if (ret)
>                 return ret;
>
>         reg |= MPHY_FAST_RX_AFE_CAL;
> -       ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
> +       ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
>         if (ret)
>                 return ret;
>
> -       ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
> +       ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
>         if (ret)
>                 return ret;
>
>         reg |= MPHY_FAST_RX_AFE_CAL;
> -       ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
> +       ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
>         if (ret)
>                 return ret;
>
>         /* Program ATT and CTLE compensation values */
>         if (host->attcompval0) {
> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
>                 if (ret)
>                         return ret;
>         }
>
>         if (host->attcompval1) {
> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
>                 if (ret)
>                         return ret;
>         }
>
>         if (host->ctlecompval0) {
> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
>                 if (ret)
>                         return ret;
>         }
>
>         if (host->ctlecompval1) {
> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
>                 if (ret)
>                         return ret;
>         }
>
> -       ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
> +       ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
>         if (ret)
>                 return ret;
>
>         reg |= MPHY_FW_CALIB_CFG_VAL;
> -       ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
> +       ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
>         if (ret)
>                 return ret;
>
> -       ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
> +       ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
>         if (ret)
>                 return ret;
>
>         reg |= MPHY_FW_CALIB_CFG_VAL;
> -       return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
> +       return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
>  }
>
>  static int ufs_versal2_phy_init(struct ufs_hba *hba)
> @@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>
>         for (lane = 0; lane < activelanes; lane++) {
>                 time_left = TIMEOUT_MICROSEC;
> -               ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
> +               ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>                 if (ret)
>                         return ret;
>
> @@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>                 else
>                         reg &= ~MPHY_RX_OVRD_VAL;
>
> -               ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>                 if (ret)
>                         return ret;
>
>                 do {
> -                       ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
> +                       ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
>                         if (ret)
>                                 return ret;
>
> @@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
>
>                 /* Remove rx_req override */
>                 for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
> -                       ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
> +                       ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>                         if (ret)
>                                 return ret;
>
>                         reg &= ~MPHY_RX_OVRD_EN;
> -                       ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
> +                       ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>                         if (ret)
>                                 return ret;
>                 }
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
> +       struct ufshcd_dme_attr_val phy_write_attrs[] = {
> +               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
> +               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +       };
> +
> +       phy_write_attrs[0].mib_val = (u8)addr;
> +       phy_write_attrs[1].mib_val = (u8)(addr >> 8);
> +       phy_write_attrs[2].mib_val = (u8)val;
> +       phy_write_attrs[3].mib_val = (u8)(val >> 8);
> +
> +       return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
> +                                       ARRAY_SIZE(phy_write_attrs));
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
> +       struct ufshcd_dme_attr_val phy_read_attrs[] = {
> +               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
> +               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
> +       };
> +       u32 mib_val;
> +       int ret;
> +
> +       phy_read_attrs[0].mib_val = (u8)addr;
> +       phy_read_attrs[1].mib_val = (u8)(addr >> 8);
> +
> +       ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
> +                                      ARRAY_SIZE(phy_read_attrs));
> +       if (ret)
> +               return ret;
> +
> +       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
> +       if (ret)
> +               return ret;
> +
> +       *val = mib_val;
> +       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
> +       if (ret)
> +               return ret;
> +
> +       *val |= (mib_val << 8);
> +
> +       return 0;
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
>                                         enum ufs_notify_change_status status);
>  int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
>                                 const struct ufshcd_dme_attr_val *v, int n);
> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
>  #endif /* End of Header */
> --
> 2.43.0
>
>
