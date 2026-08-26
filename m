Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013047.outbound.protection.outlook.com [52.101.83.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070823DB62F;
	Wed, 26 Aug 2026 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757444; cv=fail; b=iaMcD8dOd4ZjgYQ7jOPC4YGPgfD63O6k88TC+DFcPy1BiwvvNiqlrGP338nQPn+tlm6EYrvikgjuoCcV2jWATwF9R1Pa9GDR5UtWDVPg4wCxCS3cK0em7a0IXildAXax5WrUQkmDXT2ph+b2Hj/hs2di+fTCP7EY6yPjY+k33ZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757444; c=relaxed/simple;
	bh=FiImIo3ZyRDAxPiyrhJvYzZ5Rw4pDqG/5Ya4L9JO/r8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=irPJImNV8EQXnaNF1bNW5BhmG8ptPyJQXlCYKqOsn3Sy7oEDPKsXXzPW41wJddnuxTmBerFtHHNdaZYIOV5KCwF191VvsDoepHJRFw6q+DOktrEuDoD18rMFJig/9WLtkbHnWwZrZFz1tCWzSsEPRco64sBxytv6y8+V31Mc9o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=PaMD4aPI; arc=fail smtp.client-ip=52.101.83.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="PaMD4aPI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U12SDokGYIsqodgMWrN3Q/BSV0neJEINJlfoNJEaMHf9pTJ+5qAkAlk/sJGAWAxt8jPb8neW0a3n5jXZ2H+moZE4wsMfUyiWY8oOCpfZFiXXXle2YQWc9kSDiKt8Lrb1HoERsLd9QVZhxXW+XJ8LLzRT4KbIB+4ccSbnlqk2NBFDJh79uyuXpJ0EJ9AJ4Hb/+OB2ZjeCbLKY+AX2eAvR7LntvGNLq5hkm+jseJLk9WgdSA0M05THrdBPRdWWxUm2vJglOlZf4YRXBld7AjbRUQ9CkOPCB5aYsywSjX6pjVLn1ehGbPSnQ5gpirY78DLGjdoSyT2jRyYQFVE9MzKRIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3P1aKzLKuNmMzAbZsfYDeXMCxV1UsDUahrIbbs/M8x0=;
 b=DiEL/lX6c09HsrgQaWtlENN5IIZjPRHW9+i3VaNuilVsecsf642tHeW8OEkfOcYQIvcrCHcSkpyI9vyOtAOdKKyaoUI6uNsR+vTlZk9g4CCL+AHWS+F8p30zkIrLaXNwreL8nCZk3Wx6+qFTkCbLOKfs1xRWJC45hXXUtD/YRY/n7WGAObTTJ4ExHtqp2AJCpiIZEb7gogDcnhNJk88UlRqVR6SjEnw8SQepaLhb2s7ekTEnmSzGJz/AAZ3MoGHZkAEnC485LoLkjbCFQcoD7NF9UGF7KRNi6FCTDEOge9U/hExu1LwTA71Mj1buxg7k59g5Iq0/mQU2IE5bzOM4KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3P1aKzLKuNmMzAbZsfYDeXMCxV1UsDUahrIbbs/M8x0=;
 b=PaMD4aPI9IYH8CFWShejoEpt65xjAUrYxxO86/2hxqzxn+5B0l/1CW0vdTN4b8CcMR3naz0YDmPTT4SY9rhUdjTNVYFN1Gsrs+wVPg8myO4jmdJH4e6jrkg7sDoHEkvcXYZtnAcRmPSa/mOZeN3VBPKhyQvWCN99oJ/gAsoqgWButslO6eniNs6zERtVaQ4lAPu1JYEh3whLuSdbEEEWHkFh1jdSUNQxy68ukxsNg6e0rzJsPsn9xPPxou6yPfXcpy6E416W8xFxeck+/Kg4QI3iJAfn3aP8K0adps40tf1gt7hBTMzmn85POtqFJf0HNlQ0NYZFlYj5LMifanKWBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by VI2PR04MB10285.eurprd04.prod.outlook.com (2603:10a6:800:21e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 15:17:17 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 15:17:17 +0000
Date: Wed, 26 Aug 2026 10:17:03 -0500
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
Subject: Re: [PATCH 03/10] ufs: host: Add common Hibern8 TX FSM polling helper
Message-ID: <ao8Db43P5zh3YK0b@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-4-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH8PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::16) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|VI2PR04MB10285:EE_
X-MS-Office365-Filtering-Correlation-Id: 7825fa07-9b75-42ae-3ad9-08df03851d60
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 J5UB9ng1zlIt0ZuTX8Y4zYMFVpWmTpVug6BdVb0b1SJLZAey5wi7cY1uLX41EJ0dS+nanSY0a/Ka4hcI6WaFfTPs7G4BIad87O0mx3hg/ZEylCHvWwCy+eEWzRVpTo4BIWy9oF4Ihs0YeIdflXUVVx82N1Hx94cpXUb9WlPyV7mcsVCug/AFOpBlVxfm9KO2FAYtL+tL1lzS0Ky27SRgaM/mx0MtLfmS+KuxIZ+HH2jYESXCB90Ftu2HZ9xy72tJ+jxNjrlebvATc3lPcHF6hAIoiEFzguS+St8Bhy7rdkZyEcAH0jsSjboFdqkgZKn2tOY2t7tc4v3yFs6Afjl3C/tUjS3OQ94XJMHmj0jXXFLWgvCXw8R+c2Jekk5Pp6uctdGS4vodWKSslfkggk23l4sKsGMTi/By4pxGgKDmncBdvGEz4uIwIcbQrm68SIQstnzIfMcyp8RnJ4DHSwLemuFkNp6vi3GZ6idgI+dYD5Cxr5A5V1Ew53ZRFRUDo02jqxq30fnTd5BQDfWCBRQrr28DiPHfN1cTAQosMzAEtaqkE4kmeer1idKLvMES1atOOd8OiNRWqcWKPGWnodlSC1/xKjlHIzZJtgtbjWUF4ZjikXHu8ahrvK+SYNDe/cUX3DxraQu580ChXRFd+z/FTRCjzEEJY5BknFbyIMuP3+E=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?qN1+nLh+cGqaEu+QDfuMyI1UzqbAEfqrGsy0YizVth4hrX6P956rBa7AxEMW?=
 =?us-ascii?Q?XLfv772pKPeBGqOtQvfG+mxYOHL6R6XYH1PSmfEuWmx0Wdv/W910Z/YKA9tg?=
 =?us-ascii?Q?veb0c51a5VKzavM9GnLonDWJG2i0FL1RsrEv2BGoNPcKKFc9KrKh9lLkyWFV?=
 =?us-ascii?Q?wirhrHFUFiTV0EZ6gBwuzzlRWdQmR83ot+KyUIcSQrsPTdwDOznyJzYzX4h8?=
 =?us-ascii?Q?W7MjK/jH2AQOLD+RL3Ij5r/4ZOolq97AMli2R03D0YKnse0Ey7ZooVY2++sl?=
 =?us-ascii?Q?A95sJLKmUTxakPHMG8OEZXqVeJk0v8SbDCRCLB8KWB54iOl2Tt3CEUwC8pz4?=
 =?us-ascii?Q?MeBDHstrjis/JVm0437Rus9AxhVrZ61tn8CWj+VoHbaQRBJanlOp0OmHPuYn?=
 =?us-ascii?Q?dCqTLrqUm6yj6ak04oHrtezg1hqhZ6Ev9ETjHO+LvX64GKoASBFN1s4/6VZr?=
 =?us-ascii?Q?0711YwXnhV52v4DIffVPIpjk+l2+/rlRE8muZrLIxInO6msVYebmmXrE6X//?=
 =?us-ascii?Q?BygNqIps7nGKbOVlh0UXZFSXK+Ug88KdSSYQQsLT1cJF1iHfFANeeNsYynnC?=
 =?us-ascii?Q?4/r/VGJ1WcZ8dLDvodwHnGf3QxWO9qWGdNDq/DXPQ/LIaURzMTNRey0beFnZ?=
 =?us-ascii?Q?Ud9Lxvsaoz+vzbzaNaPtV3IfcDV7dGCUEhotxUS+jl9FIHFx1AT2hSNp7PXO?=
 =?us-ascii?Q?biVlEXcVcGR3ig3UjUNJhvtySaBvaOxMa0JFVaR+OOpP+o29m2E/uw8yX7xC?=
 =?us-ascii?Q?wtZR+23uTNH54GDl4KIC/GgZyYbRTqxAW/680Eib/Yex/IWN3fTErHxSMKEb?=
 =?us-ascii?Q?UvSKkXkRtGeOzOK0R/sS0zYQI7OnsAbkSj6jC3E6wbff+XpcnPWjK7Ldlwco?=
 =?us-ascii?Q?TO8FIUCFdutazBAJQJRK3EdmtGwxeAS1CBm+rBVsHqphY874B+0HJ/6mRdEZ?=
 =?us-ascii?Q?5+4WhMv+dkNbq8eE4uUnuMHphtqJugndlBgHUS5ZKcC592dM8CU29GqHgvyU?=
 =?us-ascii?Q?6G+20VGKsZXFiDaU3mS/sda/S8FnZo4K0aRdPdakLy/bc3JNwBOaWpIc53OX?=
 =?us-ascii?Q?rTpQFDxnAkrCsw3W5tXRDM/NlHK2hdZPW5ZQYl5bsGD0Yoc/Allkv9GFrzZX?=
 =?us-ascii?Q?FwOetj17wZAkYNt5bB24p3/pE4ibAfG9faLvd64VnG+saKiZNiY5nvztSkcF?=
 =?us-ascii?Q?UNt+MM4/y6YhiUqKNK/VMNEeoamCTFh0qbdw6dpvpEPxN71UC8u/l1MswsFd?=
 =?us-ascii?Q?a1S1Q0Hmh29GtRBC+fCF3rWR1Hmi59nJnqqDhp6CNCoAdHJT/0wutrcFRdGx?=
 =?us-ascii?Q?PBjbn3FEXTy9eObc4jjwWUen7q9SFUX95unthwzUBwtGtjICDsTt7SONnpjz?=
 =?us-ascii?Q?YScEdgCjBJ5GGtiVFGJ+/zFHh6uCFXs5Y+QFmLPdrYYGZxk1KvoMAZhm1k4l?=
 =?us-ascii?Q?v4plFaLCpTvbj2rui8vVTSkFIEpe7yn5oT63W7w/eyCDYTQYL9x55old+Ypa?=
 =?us-ascii?Q?Aqk09hVxJ31c0ek9/+cBN2glU+jeHR+ej2nGOfiqWGr5xND9WYzGadFjrTHV?=
 =?us-ascii?Q?6okJ+NY+hQgLZFf5AvmFix0J5iRVVugfFH/JcA5Xn3ddy4TNqEMDiZosJcgB?=
 =?us-ascii?Q?Hu43/5iS0B/jYOmbzNawrvBISdqMh4xH14TVbhspgOtVeoUaNdPSnpy/IAkW?=
 =?us-ascii?Q?pDDPAl3uWmPSpWyM+cdBRawSISazkRREkrpaKPB7l19ziJCZCW7bPY4Im8NF?=
 =?us-ascii?Q?8Fk7BGqrv2Bjaw+jZMUYx4hYpf/x+fGUe+Vw7/zl3eQ2QsPXYlV5?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7825fa07-9b75-42ae-3ad9-08df03851d60
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 15:17:17.0451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nd9WtHq2udXY6Jmodrrc4cN8+1CITS6YTwuUYIi4PuZlCBXhvHSkPcn2y+k+CfPL8XWQUpRS6fWlWJ/aUuAwCPXCXVgCIQLXdBxlrvKk30M78hOQPn3P3TtSnDAJnmB7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR04MB10285

On Wed, Aug 26, 2026 at 03:40:41PM +0200, Larisa Grigore wrote:
>
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
>
> This also prepares for reusing the same UniPro-specific Hibern8 check in
> a subsequent commit.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---


Reviewed-by: Frank Li <Frank.Li@nxp.com>

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
> -       int err = 0;
> -       u32 tx_fsm_val_0 = 0;
> -       u32 tx_fsm_val_1 = 0;
> -       unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
> -
> -       do {
> -               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
> -                                     &tx_fsm_val_0);
> -               err |= ufshcd_dme_get(hba,
> -                   UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
> -               if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
> -                       tx_fsm_val_1 == TX_STATE_HIBERN8))
> -                       break;
> -
> -               /* sleep for max. 200us */
> -               usleep_range(100, 200);
> -       } while (time_before(jiffies, timeout));
> -
> -       /*
> -        * we might have scheduled out for long during polling so
> -        * check the state again.
> -        */
> -       if (time_after(jiffies, timeout)) {
> -               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
> -                                    &tx_fsm_val_0);
> -               err |= ufshcd_dme_get(hba,
> -                UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
> -       }
> -
> -       if (err) {
> -               dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> -                       __func__, err);
> -       } else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
> -                        tx_fsm_val_1 != TX_STATE_HIBERN8) {
> -               err = -1;
> -               dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
> -                       __func__, tx_fsm_val_0, tx_fsm_val_1);
> -       }
> -
> -       return err;
> -}
> -
>  static void ufs_hisi_clk_init(struct ufs_hba *hba)
>  {
>         struct ufs_hisi_host *host = ufshcd_get_variant(hba);
> @@ -224,9 +180,9 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>
>         /* Unipro VS_mphy_disable */
>         ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
> -       err = ufs_hisi_check_hibern8(hba);
> +       err = ufshcd_check_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
>         if (err)
> -               dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
> +               dev_err(hba->dev, "hibern8 TX FSM check failed\n");
>
>         if (!(host->caps & UFS_HISI_CAP_PHY10nm))
>                 ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index b2081ed6197a..c94488661bcf 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>         return 0;
>  }
>
> -static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
> -{
> -       int err;
> -       u32 tx_fsm_val;
> -       unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
> -
> -       do {
> -               err = ufshcd_dme_get(hba,
> -                               UIC_ARG_MIB_SEL(TX_FSM_STATE,
> -                                       UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> -                               &tx_fsm_val);
> -               if (err || tx_fsm_val == TX_STATE_HIBERN8)
> -                       break;
> -
> -               /* sleep for max. 200us */
> -               usleep_range(100, 200);
> -       } while (time_before(jiffies, timeout));
> -
> -       /*
> -        * we might have scheduled out for long during polling so
> -        * check the state again.
> -        */
> -       if (time_after(jiffies, timeout))
> -               err = ufshcd_dme_get(hba,
> -                               UIC_ARG_MIB_SEL(TX_FSM_STATE,
> -                                       UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> -                               &tx_fsm_val);
> -
> -       if (err) {
> -               dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> -                               __func__, err);
> -       } else if (tx_fsm_val != TX_STATE_HIBERN8) {
> -               err = tx_fsm_val;
> -               dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
> -                               __func__, err);
> -       }
> -
> -       return err;
> -}
> -
>  static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>  {
>         ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
> @@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>                 break;
>         case POST_CHANGE:
>                 /* check if UFS PHY moved from DISABLED to HIBERN8 */
> -               err = ufs_qcom_check_hibern8(hba);
> +               err = ufshcd_check_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
>                 ufs_qcom_enable_hw_clk_gating(hba);
>                 ufs_qcom_ice_enable(host);
>                 ufs_qcom_config_ice_allocator(host);
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
> +                        unsigned int timeout_ms)
> +{
> +       unsigned long timeout;
> +       u32 tx_fsm_val = 0;
> +       unsigned int i;
> +       bool success;
> +       int err;
> +
> +       if (!num_lanes)
> +               return -EINVAL;
> +
> +       timeout = jiffies + msecs_to_jiffies(timeout_ms);
> +
> +       do {
> +               success = true;
> +
> +               for (i = 0; i < num_lanes; i++) {
> +                       err = ufshcd_dme_get(hba,
> +                                       UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +                                               UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +                                       &tx_fsm_val);
> +                       if (err) {
> +                               dev_err(hba->dev,
> +                                               "%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +                                               __func__, i, err);
> +                               return err;
> +                       }
> +
> +                       if (tx_fsm_val != TX_STATE_HIBERN8) {
> +                               success = false;
> +                               break;
> +                       }
> +               }
> +
> +               if (success)
> +                       return 0;
> +
> +               /* sleep for max. 200us */
> +               usleep_range(100, 200);
> +       } while (time_before(jiffies, timeout));
> +
> +       /*
> +        * We might have been scheduled out for long during polling, so do
> +        * one final check before reporting timeout.
> +        */
> +       for (i = 0; i < num_lanes; i++) {
> +               err = ufshcd_dme_get(hba,
> +                               UIC_ARG_MIB_SEL(TX_FSM_STATE,
> +                                       UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
> +                               &tx_fsm_val);
> +               if (err) {
> +                       dev_err(hba->dev,
> +                                       "%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
> +                                       __func__, i, err);
> +                       return err;
> +               }
> +
> +               if (tx_fsm_val != TX_STATE_HIBERN8) {
> +                       dev_err(hba->dev,
> +                                       "%s: timeout waiting for lane %u to enter HIBERN8, TX_FSM_STATE=%u\n",
> +                                       __func__, i, tx_fsm_val);
> +                       return -ETIMEDOUT;
> +               }
> +       }
> +
> +       return 0;
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
>                          struct ufs_vreg **out_vreg, bool skip_current);
> +int ufshcd_check_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
> +                        unsigned int timeout_ms);
>
>  #endif /* UFSHCD_PLTFRM_H_ */
> --
> 2.43.0
>
>
