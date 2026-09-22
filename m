Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013057.outbound.protection.outlook.com [40.107.162.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C100495059;
	Tue, 22 Sep 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790102433; cv=fail; b=YvwPen+76WEZlRjgeS0Ls1hcWC5OBxnEE1CvFPdg6JcXzQI1QA92yKnVjew2xKn4YcJNGbSnZN0pCrhntjYo1JtwJl0cKIL+2EASgLRf4YlUStBvkJm/RQq4MG3tbEibpQpX1vVVoDQjtvggg6Ts3nQKaXJTIvp13Kn6p60Jk9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790102433; c=relaxed/simple;
	bh=laZyCRdZ+1sJiKHZFO4KPXOSSWBCu05Xp4t7Xcvgvwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fDvFdjI5ZD5xs3L7vu9IA/4nMdECtpTCaY7ez7R9hPBkcvfK8Uln6Oagg0EjcwY+71r32Y/RUZlDpSW0rn+511sWDc/Xu6xcuTPCktpqjpwnKVRNJQ1sv8OKzR2O/8ZpLwT2M39OcQCtORjmktp78jzIXFmGL1GUNoJFYwh2/KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=REeM+tEZ; arc=fail smtp.client-ip=40.107.162.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="REeM+tEZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=smkL9cXaiDCFoPDrV15cn6zFlkWlddyACdej3BL5yevOFTfgRbIntxCdNJNPUEOms3lcI1VX7JFO3jE0JivD/4nuBbiIhzT3RChcFnqUOgCJczWjzN47fvYpGPDzvkqNGEZpoHxvKVxO/rzIZBhwOJMquaZ+1jorgMmqDb4aZTnG/jsIiigoqfS5r8rzb5BisgZW8dQvqLKUIrIbpVkc4k2S3azAS8VeCSf9uQLV5aerQG8G0AqJ23nL/p/2AWFEoTvrY9IqcsBQw6wxbR6qvsprm15ACK9CCjdrx9zEqndBwyDkhUL5DDC+X1ovaKn28r4fXk8tdpPs+d99X1UqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXe3dZaoeI8L5GZtPHvLYMdVxSYmDQc7uDrT9CBKriU=;
 b=bnwoT5UFPuQdy2zBtZaGI1kw+3El9VP0ayNcQHoIfr8y3juQTem5CWss6PZKxE+5RVMZt/BZQ3UT6Ej5xrj5M2jGNOcGtbpD+MJinynR20Fo+2cTp6TRJEW9gXGExXjTRHULwxNWq8eWwQwwHjCOWDG/q1oFgSD8SVh8vUAkq2eeISjBtV6rC3/lzwvN053FV3WlcXlFwjMh38PMD8YB6+MqtE/CCsqkChX7Ra2jACiqmmClvk4UYL/BHh2TJB/9tTqiwlCdV1ROw5pPn1Sj70YaxJwRs4JrcLdjR8vHtx3dSG23QqAk/OD+FyFh9t4ssfAjgrz3YNthD0mmK+cmFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXe3dZaoeI8L5GZtPHvLYMdVxSYmDQc7uDrT9CBKriU=;
 b=REeM+tEZ5nK8RUm0OHJtEymo1OP+5noh02urPk0q1Vn4OFM3QVkLYiHNs+V02gnpz64bX5SfmYN1vgXZ7wl8lwYAAa88OCtbkLwds9jz7v+pmJxoUho9of0dj7OQWMmt2ubroY9QozC6SdN0pd8zrBNbwepeuk1wMbWKMzm3hJqAXHN8Ayzg9MnWHhDfuoxctZBm7r9BryY15AysE+T4FYGB5y4qI1Vl0fSksh9IpQnJ8mkfSyiiJ49yDNFGQ6GONMIylwjIRB706oJ9JWSYu6byL+BKwHAgcC3PShtkgmyfd9I0Lk3k/puC22EPbIshlFBBl/+YtHv+2tP5+XLfXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by PR3PR04MB7481.eurprd04.prod.outlook.com (2603:10a6:102:87::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 18:40:28 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 18:40:28 +0000
Date: Tue, 22 Sep 2026 13:40:14 -0500
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
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Hannes Reinicke <hare@suse.de>,
	Joao Pinto <Joao.Pinto@synopsys.com>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com
Subject: Re: [PATCH v5 08/12] scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2
 by offset
Message-ID: <arLLjqpp0iv1PCxQ@SMW015318>
References: <20260922073009.1449688-1-larisa.grigore@oss.nxp.com>
 <20260922073009.1449688-9-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922073009.1449688-9-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|PR3PR04MB7481:EE_
X-MS-Office365-Filtering-Correlation-Id: deec1ab4-9517-4de7-c40b-08df18d8f8db
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|19092799006|56012099006|4143699003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 hR8WLOYQ2SjvvymaD9MqIJ2ExihMiAdEiD5zzKnMpKcnclfsqXWEcwOOvAFNDFkpkICga7jMkxWBA/7n2mD6x2xsIGUU6V5zhJbQBvrrXL8+7+KkWNVkyEYzeX7Wf06tGSkDIiT09x1copRU3u0bcuDiCUOwvXWlH/EsfWvzxLvnkE4CDa7K0elXp30bH5adXx4b5P2LPmU3sWB+3ITgoXOIFAwYoq5l3A9cgQlc9vF5baOBYYGG0ZF26wgtrNuBcVO684xEXx3HWiVZZJxivVauOj5dJqK/vohD8gDRwtHw0+/uIE5lbl8cxqA30GmDti8zFThvAIjLvj5sBewRDxQzTKi8qXXRPmpk1BzoL9+0LOaynUNq+OX5sQ9dY2iCMr3fgNr7u2MQLd9M5ZDD7MZpsUXM98AkJWCkVEq3TrsEmr2N8vCvZciL5ewKhJv3bvE1OhUyDh5Zv1ndq2oBJVoC9iWXLE/GI/6tVgpz1sBj+fan/BHerVuPkYf4ry38TY6ffDwI+FIemH2NxsOzYPEsUo8svHxEe2f7Kg58o1/pS9O2VbsNy78VPNJwJLYO2bo9P+AH6lGadppaIQUGCn05DM/+gpa4eCgqyo4KU5VR0SFB32eOqI0nGrl/3/chBaX9jJhz5FLDSC8xl9H3JcfDLzraFNGDe//NUHe5H9s=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(19092799006)(56012099006)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?oZrySJYG0lfR6YexXDEwCksMuJu1z2c6IKW9uYpi4vIZapzEklWlncngjKAd?=
 =?us-ascii?Q?dNFYme5MpNopbsM9zj+iruNqCJ1zKFBIjnFMTUGzpRhpEKAUprDHsEOHPV6Y?=
 =?us-ascii?Q?RjqnLiVCPqREKZZWeMZrbZi9+wHR6cOWHky3Uh1H8AhoGDoT+AbXFo90mY3I?=
 =?us-ascii?Q?ckNwHwCMqIksgj2npJqf4rdtqjj+Fc/LN/rM1SDgsB2zTExBGYwhr0sqF5mD?=
 =?us-ascii?Q?LgSQRw3f0WC2v3jO7AXx0T/Br7/zryb5fhHL72PErv/dM3p21AOOU7j6tZMG?=
 =?us-ascii?Q?kH8bf5ZPfZsdmp+HFWUPCPkMk8IqDW+WtE3dbjHnM6nVetllMWV/fDvW98YD?=
 =?us-ascii?Q?EgQ3jG0+u9YGqTpydoXyfaGoWxAaG01NguBlDv9nkyIH0U0BL2iB/6TIWBM9?=
 =?us-ascii?Q?ZPmT2amGabyCPeL2h/IwO35fSmKZ1XSzZai1rSXVZ5hysCgROJPUYKd2yy5A?=
 =?us-ascii?Q?Wb/5aTmeDx9/ZFqtf8TSXQMlJm2wfnFhqeCCndoCqBOfBo5l/jUudcqvxrG4?=
 =?us-ascii?Q?+Kq7FFPCXINpWSd2fGsUCCoVEBXIq6h0avVcybXddye9rQq7kE2iHwB57w+f?=
 =?us-ascii?Q?c7bj0Eas64XMAOb9qI/RhqIUKMsGJZYMigDLcUaham8eVHQ1lWIAAbmawBCg?=
 =?us-ascii?Q?0HB7arzvx0rcqUQbfK8qvYW7UJEdWp22+Y3uD1RgWMgafn/lx1WXweuyOacF?=
 =?us-ascii?Q?xXneTi164Ddlu86ciNyXjiKyPE5vSUTC9F6x21rXXXaCOZ5elO1pOJWU58vs?=
 =?us-ascii?Q?a9o4bCfF8hJFKVJehOiyZH1FTSEGEfFreTEVXGf4qjEdpEM321uU3dWCZM6v?=
 =?us-ascii?Q?hXF9Yh8PUUh3MPC2+0Abu63nkUkV8juBZDdBYhKH1+oMBezNdf6byFsnezxA?=
 =?us-ascii?Q?qhsG8kO3ppdstg7NWYXc31K5Ek28ISrkWi9kdH29wjEWdX12sN8Z+fsAvhDZ?=
 =?us-ascii?Q?pDrj3o4VwoWH+0P6R7KL9L060Pzbt8SZ/FALj8wtjrvNH/iuDgUUPoWwy41K?=
 =?us-ascii?Q?xrkiKX33CtVF0hsGjVOd5/IFF/nUTgDhA5slANi52mcYtqGSXorYwttsk18R?=
 =?us-ascii?Q?3frPGMAJFBy68uWfrSbkTOcJlStTymD5qWZAi9koJ67TGCsbi2TUr5c+sjjp?=
 =?us-ascii?Q?yN7wRCTRkn3q9aewoNYUcj16OfxzEoleyHNoucB8A1wkQ0ndQ8Oy4T6nQbgX?=
 =?us-ascii?Q?JS21abY9IqLhFPmb6QfDNqS3Mjesr6Kgq6mT7sgvALMIrGF/9326ijB2QRYZ?=
 =?us-ascii?Q?OHpXV5n/tmR/ZNUbJJ+UxvyFrxsipF9lK5+CXW928kPQV4jfQaWbA7NHv820?=
 =?us-ascii?Q?kG1U5DGHkF7Unw30q0Quk+ywBmeYT5hpSgHN5uY2iyhXNJ3wCfabva4v9HYe?=
 =?us-ascii?Q?ieUDKVUQEZSOkio4KVu3WqXCNdZe+t9YnUvHjDH6wGAgHmE7QZ+lH6vTYCQt?=
 =?us-ascii?Q?hynl44ZTMrILbhr4dzWo416IHE3kOOyiiVnAV86AXuaeWeW/aVhTDwzx7sUz?=
 =?us-ascii?Q?lzOD64GXRtKVZ/9IMZYsyOkEgfO+kYLQjTwH5y8gqHtXcVW6XtWs4ALOZ2W5?=
 =?us-ascii?Q?hWbtuwsXLpZ/qhuBvOm/J32U7dQA/o0u/gM/Sc9Q324xASXDEmrkaG/ZFYyp?=
 =?us-ascii?Q?spy5vwyiiW3a0UeB7+r6YzZtC3g+ymxIFkMzH6XNPkEI4WqzKBlmLYrumGD6?=
 =?us-ascii?Q?1/bCbVjtmuCBrdhRc0RWVJjf5c7ojFtPBG5DT9s+C1En2q/mFHZF78Mkrfwm?=
 =?us-ascii?Q?AgLQIzS0n/+SHqSwwBKVAAKAr9BQO0a+2FdUy/6sHR36TGG0l/mx?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deec1ab4-9517-4de7-c40b-08df18d8f8db
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 18:40:28.0652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOliPI0DWB5sRkHfvyI7RO7mWMlqx+OdZIiO92o+EzwKbuM1mq1ljb+32+oL4VfsJgdALqNdOBmU09RvwkAQFFY7ST4m83OrHCIQk9b+yZffySyZ1zu+IKgiQ+Z1Nu5e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7481

On Tue, Sep 22, 2026 at 09:30:05AM +0200, Larisa Grigore wrote:
> The RMMI attribute defines in ufshcd-dwc.h are otherwise listed in
> ascending register-offset order, but CBREFCLKCTRL2 (0x8132) and
> CBCRCTRL (0x811F) were placed at the top out of order. Move them down
> into their sorted position next to the other CBCREG* attributes.
>
> Pure cleanup, no functional change.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Nit: keep b4 review-by order, put it before your signed-off-by if need
respin patch.

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/ufs/host/ufshcd-dwc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index 53b523ef59df..1abf2b1deac4 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -13,8 +13,6 @@
>  #include <ufs/ufshcd.h>
>
>  /* RMMI Attributes */
> -#define CBREFCLKCTRL2		0x8132
> -#define CBCRCTRL		0x811F
>  #define CBC10DIRECTCONF2	0x810E
>  #define CBRATESEL		0x8114
>  #define CBCREGADDRLSB		0x8116
> @@ -24,6 +22,8 @@
>  #define CBCREGRDLSB		0x811A
>  #define CBCREGRDMSB		0x811B
>  #define CBCREGRDWRSEL		0x811C
> +#define CBCRCTRL		0x811F
> +#define CBREFCLKCTRL2		0x8132
>
>  #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
>
> --
> 2.43.0
>
>
