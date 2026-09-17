Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010028.outbound.protection.outlook.com [52.101.69.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5084E4C32;
	Thu, 17 Sep 2026 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660741; cv=fail; b=SRTx0lyIbkeXWGVnjbLbaPBWd/jg8FCSZGo84TkzuJZTzaloJW0FsGyMGEn9TIiwrKCA9GfujG3E4q+lR9wG3rZulAjJTmd8JyTRdjKL/9462wEosnrP95sAOFIbUnksfKmxWgfAjFbtCQOG4KGk4y+h3wUP35jV8IJnytoLSTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660741; c=relaxed/simple;
	bh=Xx+nk6Mu6QmeuF7YcJ3QwpQ9nAiinYfM3BFyO5IXqiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BgWeu254Byxw4wFV5BPvpCbBM5ti8DvTTGIZyyA6w6K3fnhBXSJMrGymKHt3fGgl2DtAcd+GgBRwa9rsMau17WWnZ+cSeYC+03CXoPbVbnzzwhR3RTkPfu3W0SohAzrHIxZjPPH102L8+CGA3pH0PPA5jBwdCvp6zVsdg8QUBvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=XSMgIoEH; arc=fail smtp.client-ip=52.101.69.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="XSMgIoEH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D5f5CpI0AH1b+oQqdxEEySlt2A68tMS3WqBpcl/Z8IMkX/JkHfroi3OarKR1m71Aphu91WX3l8rFckl8wNrH7aUJqdkX9UaotUP49NqhWsWRD2K8QlIFkCHRBaaWkViLe6oZT0d4XZDl1ziTu+4y9EZo8+XvUOC0YeUt70Bps60N/1f1gK1JTOT44jFIlJb0xYH1WHsGaNKUZVJdvtXDMNQze7AMfcMagTiQprAYQSaNDmvIbui/m6WbW6b92JYA5HrzG10bqv7D/CesLcZ+fIiGCqR1Hvj+iW7jFYmu8eyxsvYRVuyMoQ7aNIRS8znhHlQHpgwNugzkFkHWgdnqVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIQkpC2Tc5dGnS+74/8Rg0wbiWIcwbXb3bajmCsOd64=;
 b=roLXVdjnkdvo655W9sgYjnhnZ0Ph+AXtudYsXmVtRkD1wySj5sbcRMX3xXwJFPj8IX0vDuAUmcH82jg+j3ZmT2MluvH4F0o36ct79jCciwf35d/Msd0doLqDOE7zMMDRTyZPmLVeTz1NC8eMPc4Kl0MAVShunZgkqt/G/vHmIiuwrRRlFbzSZTyA/pF/c5uco9G0G4/ISFvq/DQS0oRo0G7HhgQ+/6j4VsoMrPP4BNYo2u186oD+ibVjDaq7PC8/trVDCdYuEh7ZDIUXZzlJZEegoC1QLIf+LKvkHXBfDojaVOWKqxa/qo7yLLZ+xZxKTSadV/zmqLw4NFugZbGWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIQkpC2Tc5dGnS+74/8Rg0wbiWIcwbXb3bajmCsOd64=;
 b=XSMgIoEHmNLWp+bJvpDAcy8fDWsVNE59Zj2LLZ3yssredHgmKGe9Ob8kyNwKgJxuiqzZRq+Bx1VAjM8WIXd5GWSzTuCG306Y+tEPnh37Ydv+SxKkibcAyEyl2kdwCTIDrM2RXZ8ZegPQZORlJnwIO0WPBf9gabQCjvuLPkvVyVvKlPIZBtUX2E89LFTZfBFsQ7Y5Ui7ma2DQJ90dy3KCbJ74SVyBlvA9z9zvc5Pa/G3o+CgCIi0vggIK5NJ1TqNdyo1xZSYub4u9O08nnhdhazwjko+RRXMh+733U9jLakUAF9NFOmL4AKtQbWFej7LXs4d9uYCVC2H48lF7bsvKJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by GV2PR04MB12338.eurprd04.prod.outlook.com (2603:10a6:150:321::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 15:58:54 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Thu, 17 Sep 2026
 15:58:54 +0000
Date: Thu, 17 Sep 2026 10:58:42 -0500
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
	Pedro Sousa <pedrom.sousa@synopsys.com>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org, clizzi@redhat.com,
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com
Subject: Re: [PATCH v4 01/11] scsi: ufs: dwc: Return a negative error if the
 link is down
Message-ID: <aqwOMoHrxaWXoQUX@SMW015318>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
 <20260917091555.1443076-2-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917091555.1443076-2-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: CYZPR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:930:8c::9) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|GV2PR04MB12338:EE_
X-MS-Office365-Filtering-Correlation-Id: ce925355-6361-467b-e92d-08df14d492d4
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|1800799024|19092799006|376014|366016|23010399003|11063799006|18002099003|22082099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 O1sZgCe1Bn+lOrlt6EUB4yG0G5Hz5EDpouts/hYIborHb/+BxDEL17eJ6RDxM685+JWIozx/rQTux410W21JhGwT9ahWZXazUG3jt+U7DHxa2w48EAKq46iEMjnnRxrFxA7hLnVDJ90S0X4qOJOb9LPnGY6fFZrlhCMGWD4ModvJ2et6K2TrSZzrgmzpE76lU3kQtB2mzor5FhnEJQ/8OUqUiXnR0XQrk4ujbQ+2xmlFjGPjntrK779AyenZWCDQM8FicGC80eKdIRwjkAaYgwiWnzFDR1kvj16mLOL4VWbg9+DVZEokXuNC+oUcb1mYbf+1rs26e023bWhwhouqYWOTlBSBGPeOlTKOX8nfDZyMjk3T2G7mkLYftBhBpbZJj507wUOCbQdB5elaelG3+7xsHVZLxb0h2/4O0BToBsrNO+ZeAdoq7PVKxyinCGPoDCzmUSiqtssXLlH+30KGQBKqyEvd6w7bY9ZybbEevYD7aIO77zjzrUIA69FPGBK+Wv/QA/V7+Y0M567UhlJryR5KWGagruUAlunqCGDblGLvA4KA+r54I7IxHx9QUMhIG3bGTWrG8Xt5rJyAlJzIsdKSzWiJkcrsvWCvehCoMwAn+A22SJBuFPFxANQw5wE4Saq637r4hgNbe2upf2FxrgRbIs+niXF3OUkb7RuVhPY=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(19092799006)(376014)(366016)(23010399003)(11063799006)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?VJamgko31pDWPYmaxecJvLnn4I5zy9Ea50h7CLD0m0Lh21M0alpH9in1MP+/?=
 =?us-ascii?Q?/mo9QRXYOizWOHeuU85vWlaVu/fERDf5mdh+9Z6FgNJYhBaE5v1Ja1SYVkN+?=
 =?us-ascii?Q?gxePg7acikPiNJ0P13bZd8WUCR+LIvQqbAG7uXukIAsVfFzBaKFEkhVd40of?=
 =?us-ascii?Q?GjJh0K5RFOeDsPycJ7hkBuvRFi+1bYUl+VaX464uBnhGChE3ASp2jk7At/Sx?=
 =?us-ascii?Q?euLxQckt/pT0mBdDUvhtKrqKMQIDm9GtV7fZYMVc/ix1L31+x/4fZH7QyCKg?=
 =?us-ascii?Q?ha9qGieHyiij+8oIdzjbzqqxOZYS7p737QG1fG74iihObclE1DKTx2PO5my/?=
 =?us-ascii?Q?WMHljHjqx+7qdgAPvlkiyqNE8xRBgV80xayrR1jCASsqbqkAFBDjHm2owuaw?=
 =?us-ascii?Q?7pp8ujqevAic3PuDmmXNXlxmXU5p9+gDlvj0HXClx0m0kCK9llMskdE0ZEpi?=
 =?us-ascii?Q?3dT8aTMDLRtWaVjjQWma2t/1xIos/yulG4Wjrl81znk1tB6SST2XnavcFdql?=
 =?us-ascii?Q?GzUecth8y396ZZ6CJ9S3Bvwvyp9SC6OKy8jfY7zlKVf8oqe/X7aNOIXE4nXT?=
 =?us-ascii?Q?7jrNyPgIaZKKBxJuRBABFX+2SQrHojeHr+2IQBrSNlYUFQ6V0Mm0G/90aNw6?=
 =?us-ascii?Q?LLT5PDnNMY3zIKUJpVhGFg/JjIhlI4tAvXnRO9LtojpChLRqc7khr7YDz9S6?=
 =?us-ascii?Q?qaVEp0E0C0rUcIFcwjOWEyvuf0GDip5pLnlC8iqx2YDTIKyAUIfEtlCJePHi?=
 =?us-ascii?Q?riR5iPhCKnA8DXALxQwdUjjg7mswmkaSFRHg3h+Pjdzi5yFc2y1LZNAiB+Ia?=
 =?us-ascii?Q?fqsfX2NrjJPmZQnH8eVtMOvj38z2gKosU1Clo6IL+G1FqFnL1iS3XjTs6lGI?=
 =?us-ascii?Q?Vf2vT5FgIMFnCrXZYJwUTHnHPXALsVebG1Fbcd7/SV+Xnx1rkufdAGlBu1WT?=
 =?us-ascii?Q?NR6cC9JQPrYNU47U432k7QJMfCHZ+Cw+Ut4FF5OPgW8+WhB+C5wc/8kzLtkZ?=
 =?us-ascii?Q?J2x28+wtsAYqZP/GgiAoO4P5euMB6/cmvX8Zk3xEqbnvM4np3+2inb65zr/O?=
 =?us-ascii?Q?IltJXY6Ydm39KqvxbHlClua2SLxw8AQEmVF5mYfLzJzjkV6gRyLoqM7uhJ/W?=
 =?us-ascii?Q?FORfUs3MRA58gZYFvNCsRUi3m1dCRELAT1ASPKjEe2XcvLMTbdyWxjEOJNyA?=
 =?us-ascii?Q?WVAik7DhYPeBiq8NozzElRdNuHLyrv+rkiOae6SFWVDMx5LkLiiIWYug+i5S?=
 =?us-ascii?Q?mVrxbkGu+q7CUZb1bKPmDI8yNAwNiPcp7qCPgPTg4Op1JqPsL4wL74ukqKiQ?=
 =?us-ascii?Q?rNMUKDJy8zqqhOOY7LOLHsW0RMoYRH+FUMQLoEh3hHqME2J9BzbI5HXLA+Nm?=
 =?us-ascii?Q?9sULcA94wOJLkYm26ZCmy/7OASi93pqFbDgfoMR9+wD8sJD6mCEzNFfORuXR?=
 =?us-ascii?Q?4XcbDmE4cIRTm/syPhoYuBBdrll1PTn0SRG8DU+5hwZ23n/onYuhZzXQkjAV?=
 =?us-ascii?Q?20DrkVoiTZG5fpFtL9Qbapu1ReaIrf2YASxRkYIgN3Qlge5xfhpBPGRUDqka?=
 =?us-ascii?Q?7Aq74wARvUbkW32co0iAI2maB+sVPMZSdrknONsBiLX6Ya5xdwSFE6NxSjfw?=
 =?us-ascii?Q?Rf34zpJIgARjXiSKzHb4izui2ro/vMBb6cdMbwlh/Xt1LZljZJRPJwqYs+ZT?=
 =?us-ascii?Q?Fcp+Eq05Oxrm7/acbyiyxMg/PXa5biXHtysh6+ZaYRZqXYEC5vYJDOInfJ3m?=
 =?us-ascii?Q?3O12+et44//5R034aEk2BI5Q9S49kd25GtMkeyGQONiyn7t0gwyE?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce925355-6361-467b-e92d-08df14d492d4
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 15:58:54.2315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ploeEGj9+PWpXYtu8ylum7L0Gbg6yVr59nFbm8bC+0F6v5xGI4N1L4rllaFgE4Xn8W1tR2eAPgWHupY6GZATYbGSu3ZIKgxp8RXXnX8tJ24ZlR6ytHyPIfvRAz3xgz59
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB12338

On Thu, Sep 17, 2026 at 11:15:45AM +0200, Larisa Grigore wrote:
> ufshcd_dwc_link_is_up() returns 1 when the UniPro link is not up. The
> value may propagate through callers that expect failures to be reported as
> negative errno values.
>
> Return -ENOLINK when the link is down and propagate errors returned by
> ufshcd_dme_get().
>
> Fixes: 4b9ffb5a353b ("ufs: add support for DesignWare Controller")
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/ufs/host/ufshcd-dwc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
> index 21b1cf912dcc..ccf785fce6cc 100644
> --- a/drivers/ufs/host/ufshcd-dwc.c
> +++ b/drivers/ufs/host/ufshcd-dwc.c
> @@ -48,20 +48,23 @@ static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
>   * ufshcd_dwc_link_is_up() - check if link is up.
>   * @hba: private structure pointer
>   *
> - * Return: 0 on success, non-zero value on failure.
> + * Return: 0 on success, a negative errno value on failure.
>   */
>  static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
>  {
>  	int dme_result = 0;
> +	int ret;
>
> -	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
> +	if (ret)
> +		return ret;
>
>  	if (dme_result == UFSHCD_LINK_IS_UP) {
>  		ufshcd_set_link_active(hba);
>  		return 0;
>  	}
>
> -	return 1;
> +	return -ENOLINK;
>  }
>
>  /**
> --
> 2.43.0
>
>
