Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013004.outbound.protection.outlook.com [40.107.159.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6D4FECC6;
	Tue, 13 Oct 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901727; cv=fail; b=uCBhq4mK9n84IXQejaDh8BMItfC/qQY+GLdajRu+4Ucchyu2i7fkQg9g6sKKTDYO2+PiNbs0oUEhSB9eR3fYyUSrvIW9WbxZjIX9cFGtZvYJTqoPnqbRCJ9Z1MwBNDihdEGUq5l3bePcPOZvWoZKiFiC35qrr18B3e5OKjGmpL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901727; c=relaxed/simple;
	bh=NzbPvfko9mJHlR6MloBEG4ttJmFfB0gmHH63UWo9klA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CDZTCClNRNZZ8PMSRU8jnlIDN0pw5vH02VNtd1S2t50LLkiXOyxV4I2rXDttBfaecEwHSi1DT/4Pxu7sL3o/IQS8KO6SjE1KHC5HU0WqRsmpCJcijR5sg3G7Svz9QDbVa4E9s4CBQZvltT5dF0o6AJTll6kQ5Tz2pRayAJokKoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=FiBAWxYs; arc=fail smtp.client-ip=40.107.159.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="FiBAWxYs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JIbNuozZ8/HsN0Td2/jzG4zDTOggDIr7OIvNS83hjwaisiJSDMc52pfzxtOzkkLFhheTwCZf7mUuQY8M6tm80uKr3gfNko2PjuvQjtY3eo6qMVZYpW9ENCFfu2bbRM2vFk+w0UqyI4zZpgJt8ZXhR2y+wPdqZWFVfJ435tD1MILsIXIPkjXDZTCS3s+EewR16YCZFHnyyUbAih32VN/3bN6Y/EHmNBEKSIIl83eV+VlGP6GZG/04otVrAx4KyEGyT1cKwiTsUA9YonOaws/IaXcTVccl/nHLRA4lHbVXl6OHQGXinuKyjyPaybEB6qG/dBwn821WfQ15Gnoy4kQNkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pLo9lY+u75xnHcjIomzvUwdQblmUnS1Jvrgunj3Jzg=;
 b=KlH8mv5vcHCNk60TqtD4+wxIFSl9o1m9J7DZJvXOwFCsvaZPOHR3EN6hGNAUAtycTMPIcSjAPb0q5ZbQBHN6/bv5kvr/yxP+sbjf5EJdHWoX95mMv5k25ooO/PuXKfTvgXwtYomOHZAdTgTwHFhssiuhpDnyO5iSFWLZAO1w3sVuzAf1kpLOVH6PFWCCeBIF7nwfxLoyAHmjuSd+rjkQk+oeqSNTcP3iewfx7H+qjz21o/F/vGgPP1v1qRrfDql5p6LIPUGl1+S4gGUgXvdnUg3I5H6BMKubuSa43oWER8LpsP+RU3DnF3bFRT3d0i2Ze8yuMto6Kt7jFIqidwzU0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pLo9lY+u75xnHcjIomzvUwdQblmUnS1Jvrgunj3Jzg=;
 b=FiBAWxYsb1N56FsLF4qAExkbLO1IK9IkkPEYu/vJ4/b+rDsAPIAKNsLk4cbFfBLW7IrNo1o0lpEi9fpy5smHL+dTmuswMD1i5rLpKXtJ+5pfyegCTEIzjvdg7xlIFV2B7aJ+o2fmkkcuT/iGqNPyOxgj5Cr+vdFcY2Gg5z7yxCY/lTCgm837rzANOc9djtU+IqarJtqUdbS/vcdZGmOJ7nJ7y0unZrSfApo9W1t+0Gc3DQbEsjytX5RDnyO2oywk079H6c5noFe+16W74OQTIjXH81QDfIaSsI3MsjY6eklJQg2pTaAx//OfSToor5OBKFiXluwHFo88fmTqs99xug==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by VI1PR04MB6863.eurprd04.prod.outlook.com (2603:10a6:803:12f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 14:28:40 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 14:28:39 +0000
Date: Tue, 13 Oct 2026 09:28:20 -0500
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
Subject: Re: [PATCH v8 12/12] MAINTAINERS: Add NXP S32N7 UFS host controller
 entry
Message-ID: <as5ABOqo2MTgQBs3@SMW015318>
References: <20261013103003.373156-1-larisa.grigore@oss.nxp.com>
 <20261013103003.373156-13-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013103003.373156-13-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH0PR07CA0120.namprd07.prod.outlook.com
 (2603:10b6:510:4::35) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|VI1PR04MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: 15557135-2374-4eba-a70a-08df2936462b
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|19092799006|7416014|376014|366016|10067099003|261009223027099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 ZWJ5c10TcZrduaEG3g+j0dDoz7YkU11GluaxpQ1bqEssNKHvZ65OhPUH3/C6xxhsEv8mDJEQ8CotdgbYlonnHPtVDZ8S9PFt/srgrZkCgrCVrCw1T5Zlizx4Y08EPkEozBXml6jaZXbp04P0pOv1TxW6rGD1OtgsL9HlNfL3cOm17FFQbB4mT9b2mWsPXJh4EQceSS0d6TJ7PUpISyl9j/eICv1zNBFmoTEgSDg+SXIgD+9E+5OQyEvUKfLUkA5RF3UcGWQr4h/ihrtdqOE8mgn36oU/HSjkpQGaTi5S+GTKOgRrkrzG8Gb6Hd5jF5QXl/JqRD/9eTMLqd0jeL0u0gWTwoZuRAaybcPTvY9TjjXogqgW1CW4vPV3L0XCkmODfI5+pqjhfrG4v3RklIknHONph1E9nrumA10/Gri0E5m+qNu5j0qQSc7cYbmiXt6/8lwrDJIDo9qoh7/rbS9nCl/d3e9MTwTDaHRJ8Pxkc0Jy49BuDotB6g7QP6mRwUDhAYY9y4BorE0LrUtAMGwvWo2S6tNCKa8qyBm0t4sajjqpo+kF+Xq1aNF4INAsGiWV1hyjgOvBqRulVldt74QsKA7Mdw02qeizNcWBiW5Go/Eorbt46LpWNWdfrPMYKeBGXI1ZBkIZNTdXkIrzEvn0L8KaImTkU1+iLKB0Pg7iR+o=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(19092799006)(7416014)(376014)(366016)(10067099003)(261009223027099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bODZqI6lWaUeW2hph4HbaUEs7kFd9zRQnwuvL1E4YsAq7NnGf4J85uOPwiCa?=
 =?us-ascii?Q?CwkMcotRNgZGYNsYUnZ5VaQDB6UtU6WEjSA6dln3npoTGpAjxIWinaPyiq9s?=
 =?us-ascii?Q?oGUrj35vgZPiecDHGxuijfQomrZ8fzfi23uT9fPC4wBwmWAjz+reGwMZH0wO?=
 =?us-ascii?Q?YakbraskMolJXwPHwkj4IrrFm/hDWOJDquKXRYf9hzspgU6EFk+Qdh2HGPIV?=
 =?us-ascii?Q?vU/At8WtgnONkwZiTCi5Vd6D9InFiJXkZSBfOuf5X+z5JYu9X8Jlo6T5rj0b?=
 =?us-ascii?Q?3VIwiRGMNxwjA3RlHG0akEVSxddPT7DmoElwBDeh8E2pU2kR1ioT3H5d96cQ?=
 =?us-ascii?Q?AibMa9oddym0QjlBYQprLCcFURVyRr1bFBRh07C/VrgdIoTuYPAD8IzsJ7dB?=
 =?us-ascii?Q?uCkiQmMD3z4oE5vyvPqyC8cPCeLDswC1QfvEIjBb4mHVX0Z16Yz3zBf6yNEf?=
 =?us-ascii?Q?6RI3oiyr4KLYloRsN9D4/JsU0mODybEJf/0mb+YzOneFF0frn5EmnQiRPs0N?=
 =?us-ascii?Q?F1qaomCXevlZMtglES8hxJZd9ZXRcmeCtMOJ7PKxx8wTmVyZMgoH9vOvAsJ7?=
 =?us-ascii?Q?/LuCIOOFd6Q2GvYhNspQgOfJJmVVFjCKuof2dzrCXnDYzZwgfh3i6M3HJf7f?=
 =?us-ascii?Q?1LPZf7+/xQL3sjpPQp+eSkB0ONI2S+y59CtuJOpjU4dG3GIOxTpVgfD10PAJ?=
 =?us-ascii?Q?HOrbOC57KlZ8m0tN6WKSifc096l33TCivAe065uMtu28KtGFIHnRwJOF4Q1U?=
 =?us-ascii?Q?fUF02p9oHnn0Tdax8gKxk9cDNe+gbEwFsc43cTR/n/fOtzYS9Q6Sg2zXybTp?=
 =?us-ascii?Q?KoOt45nsx+KK6/tv/6elOnQQWnxvTIdsRrG2kiqK1DlOyUchqXyVvpVEvN7+?=
 =?us-ascii?Q?+KnKExyEW2eD/isih9VRr/lsHmy+2RL0XCgYQ7OWj7nfSTi9vSxxI+1ivMu+?=
 =?us-ascii?Q?v4JCr7TFbXuv97eB7GkU6aKUhA1f8xYZgO3viPNGP7s87W6vjjC/Tp3kdfIu?=
 =?us-ascii?Q?jjfOr5gTzQVL/CVYYLQbDbjpPTiCnGMaS0AuiNtKll+aInw6Z0kV8+p2Fvnw?=
 =?us-ascii?Q?7dNd+Eon98eqbHJU7p3M0MtPZcjRRHDocuHu7e5XShz8FDAslbxH/jVqIOsv?=
 =?us-ascii?Q?AJFAov1Qe90CFkImlNvMSxajnBVzpfooywV67qgmB2XBXFD43uozr9r6XLmr?=
 =?us-ascii?Q?FdWcKiI+B/9GEASyblnUNyRyBB8MIL+Ru+GXkno2HLTTzueteL71yI9KhPWe?=
 =?us-ascii?Q?67Zp4EEN7QoAdpLiiI3QPbY0if8jjcCdo8Jti7qOK/cA0iTXVyRnANRrLYRa?=
 =?us-ascii?Q?BG4XBsQnfxjPvKgIV02ehJoDYYXkoBN2TNlnCe8dXDT+92WGQiYF/G77f2Mq?=
 =?us-ascii?Q?Z4BVePcZrzn1snXrBWCxLoMAW2qfRcbWCbnrb+X7QllU1h91+rl0yXzWFXBF?=
 =?us-ascii?Q?6xZc96q7EaCzDWzoZF5Ld241OBPu1CMMOS3Fv+K2hmsKAMqAGXAi48Mdogdc?=
 =?us-ascii?Q?vr/X51zF/phV+zg1/wD1bXHxRrfEQ3KcpfCL+ssmEzmf+n8OIMKsxhJHa9+I?=
 =?us-ascii?Q?0v3cxC/m3k8qKgJsxAAQCgArKtsYe55wsF6m8Uipo7hFyeIVdGfVRDjvVmc0?=
 =?us-ascii?Q?9q3ewVgwztQTn5q3hIOZtOCGNNyStSI2kZnONM24leTOntrBjnXmPso1ao62?=
 =?us-ascii?Q?481RadHJVmnUex/f2RLIGWT58D4GYjNxc1WRYlhxUSoEPZ/RpZaScT/Mkior?=
 =?us-ascii?Q?tqYGD+pPfWTm7wtgSrbdxXc7BN/sGN7kAUgBzyhGWhKlhWom6d3U?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15557135-2374-4eba-a70a-08df2936462b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 14:28:39.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3AP3EX9c6Ciq11Mg30GIjO6/vU0bAN94cWVDXPE4JeiCuH5GGwG2hPlQnc+cOC4Elatdb22c7ffJGroDhmA8YnMDxfWgI5Gl8C9FgpsStPu2/jW9K3LmXHONtQPDa4q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6863

On Tue, Oct 13, 2026 at 12:30:03PM +0200, Larisa Grigore wrote:
> Add maintainer for S32N7 UFS host controller driver.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f53047aa8d3c..16f1dbb763cd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -28119,6 +28119,14 @@ L:	linux-scsi@vger.kernel.org
>  S:	Maintained
>  F:	drivers/ufs/host/ufs-renesas.c
>
> +UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
> +M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
> +R:	NXP S32 Linux Team <s32@nxp.com>
> +L:	linux-scsi@vger.kernel.org

Please add imx@lists.linux.dev

Frank

> +S:	Maintained
> +F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> +F:	drivers/ufs/host/ufs-nxp-s32n7.c
> +
>  UNIWILL LAPTOP DRIVER
>  M:	Armin Wolf <W_Armin@gmx.de>
>  L:	platform-driver-x86@vger.kernel.org
> --
> 2.43.0
>
>
