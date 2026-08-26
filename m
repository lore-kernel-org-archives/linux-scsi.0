Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012040.outbound.protection.outlook.com [52.101.66.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B93DB626;
	Wed, 26 Aug 2026 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787756958; cv=fail; b=aHJqLvZ/IViun7u7Sb7Pf3GXoEDoY5cEmb+f2yqK3Qy0gTSyTj3DYE7/g40OUb5ClD1pEhcc6VOW41wBENucY1frycmWBuMNyhHWO3kO+KrgMJmwzVOUTXZ3IxmX+XnWxryDfcfUpCwN6Vd8s3c5YIfsO4zKpLGLXGRWCn3d5iE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787756958; c=relaxed/simple;
	bh=AiMF2fNh9dGo+nzNtVAFm65Np9P9xiDRjicn16iWgf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NDArw/Tn1z9qaUJcxds3aS7ZWV4ciuN0h2VAW1Hd40BkgljkdwuXh9Qjt6Lt5BWkx15C60YUah4bl12XIW/WL22aXiXMS42I60/HHFBQs9oJUPpgaXAmt3TpuUtT+yEbkjeLTgyPz2SKq10u5Y3A+Z3dI6t/0Ummc9Osi47CmVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=db2Fl4Ht; arc=fail smtp.client-ip=52.101.66.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="db2Fl4Ht"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQXh0/1irggMs1aQaFpP5vtoWJU0uld+sqBTSBB2b/Zetyy8CMCJN7Imm1sQvgJQXaITkbUk+Ms/JLlR9vl/hllJ0NRlM+cTncd/6ZfEOhRx4MP195f68Tz1F6Iuks9eCTo1d8DTCO8gTSelHbf5xFHaBN6FFkI3rGJFX6DR75bMsT5a/OGHpJkDLcKx5HWX9Q7QVH6Pe8aoZLF27p5bq7D855yW0ST0NvxGTIhVp0OkjcfCK0gbGMhhctWOy5UpUz+cTsYRjjuz0oEXjeFrmHwv6Kx/BrJAA3HSlFFchTHqSpsFKMFQBt/ognGhoqKKnvfiapX9jFDxu4OqZHj4LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAQdZ7Ea1eoATwU2X58JXCGV7gU/E6S3xqkssDRpcKU=;
 b=Aq2TYUXcoZiDvxOTbpUegXRZzjtAftaLxRZ1CrpoBn3kA/ZSGehlNPMNLMyoTO5fJaCtI5MQ5vG0iWhnmZvIzWYaJwdQn5siFitUoHI2QFZJgbipu3eMC3BDuLcipUuJ7YbnOhHcf/mQEHAy+uq28Qml1/6rMY2oI52kqPRUnKx0KcCock/xWetUUCsPU7nGwnN+wKYb+iIQT7z4GmQYC4qk2edfh/aQoHTYN6ODFMJK5F5cQhprXudYtDJgaTVkVpujjQpnA8uTPIL1NyH3v5yeoFtyT1ArHEcyMRiDwohiI2fD+29706IIzTSlIM18xvNVYF4yBhGDEfARzpICAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAQdZ7Ea1eoATwU2X58JXCGV7gU/E6S3xqkssDRpcKU=;
 b=db2Fl4Ht/Vs7qYRgyKJic0J/iBUEhgEufVm20CdcbzOKJeKK4XOJZQEvnxh32hsXKRuKIbguICnEuPayoTMIOKpKIpSBy1q0lcUZfJlVWjhk7y61fL1/dkYU9OSX1Dru66CG0oHMd5ahb2PmZvcU5mJ9HnbkiULIAhoGlawD1pjFw8vUD46FH7Fi7Sy/a8+u6G3pOsYqaWWSMIU6QFtsndX5JeXJwdbL/94MREA+DpjPlTdQo7CGyl738R86MdzWvQvHKU/Uv5YeXBvDoQv3U5fJZ+uonLc+ia7tBmFyyTrtZO6IMkUG0Jv1W/XjXpA8EGP9fyZ2fy+vfFg2c/gChg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by ZR6PR04MB986522.eurprd04.prod.outlook.com (2603:10a6:910:d9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 15:09:13 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 15:09:13 +0000
Date: Wed, 26 Aug 2026 10:09:01 -0500
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
Subject: Re: [PATCH 02/10] ufs: unipro: Add TX/RX FSM state attributes
Message-ID: <ao8BjTPouw7t7xfs@SMW015318>
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-3-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826134048.854748-3-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: SA1PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::23) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|ZR6PR04MB986522:EE_
X-MS-Office365-Filtering-Correlation-Id: fdf29390-8521-4c5b-1f51-08df0383fcc4
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|7416014|23010399003|11063799006|6133799003|4143699003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 yZU1HPCovJHjr0BBbuBqFliFHKlN5zUQWO0tX2nLfZkZEgYMENvwwVBhRlolFt8znFy9GWUoYVH8RItUUk6qajPTsLcKi0taXqw7MMJsi74cYYVOSJjFgAPnMQQOO/8a6BWiMeh68F25TbOAdWfwRoV/JKbVTgT5Jl7i5Mi/kZd+dbIVfedXNXTc1HU1DVAnawpCCGEi3LanrpeXmmkpCqk2Vp/8hQS3AYgNwGWVUAsbhvBuSKDYICMYfqvpxMbkiC1byvIPH1lGxciGG2fB7V/1KfCa3kBh+s4O74IHzcFXMf8HTH9m4+leQQmLIpGq811KCMjQhdYfp7y/uLBK3qJiSPon4qBxN72CEGQNCE3/uGIkhCHviwxFOUHhxQNckxXXm9MKMG5FXuBAt/Psm/3jkKDo4q+HI7S4EDYeX/+pk6dTya/gUDBCcDVE3lyu/2N+2Jal7DUhqweYRJchWN6eFXP2v/9hbKUkMVswYzddo7XK1d/Lh735wr/VY/7eD67p7MyEnCM+6D+ba8BMo6LNTXf73nq4euuMg9GkekglWfKBXbUJ8ijlIpiC4+27WbCTKpgIG6pqdVqIIDbLWa6vLbHAeoq9QhOTyA2AZpL2WCz+8rRSQznZTNt1UdBGl88qJLx81HmfVGYpwD310le6+GGzvF5ChehdjkpiTWk=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(7416014)(23010399003)(11063799006)(6133799003)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FtJxCxlW4uY3fsCskZqe0tK78E4g6iyxo3mfsW0R3zxdp4DJSZAF0Cxy7CrB?=
 =?us-ascii?Q?WWHHMs3ROwFPc1iwrs0mvDdVEhgqNxsLgYTJDMQsEp5DpHba1OAIMEdMD5vs?=
 =?us-ascii?Q?ICubdC1lmSOIxWXXpjHHbvLPGggMmzShkalrxo+6R5s0ixHEvGFoC1nUvi5X?=
 =?us-ascii?Q?Sk0u/+ysKmQJHtk/EehtHGtAlgfZHXvhW3HPAJwjk9a/ua5QrdHAYjQGtt7W?=
 =?us-ascii?Q?VaR4Tq144ThMHoc/n/4CXxGP10crCym9AxxTVVu1gLS1ZWHzYed+sfH3PzeA?=
 =?us-ascii?Q?yehybSQ0+11buehj//CJnKr3fWWb1TEZSB71ALKvQP9iU5xWdZbEQExO66Ys?=
 =?us-ascii?Q?Fblzi3QT5k90G6POyBkzIZBvo3f9JIEjHjCS4dDwrEWbPaSG7rkQYxBryrJg?=
 =?us-ascii?Q?D/B8PGSFjj8itRg9pssWxwd+dCRvHpWl3ZgvKE1GdsFTqS7wEQsAecAdYuAr?=
 =?us-ascii?Q?bZcPiZcAviKyzX5e3EGI9sA1DcFYZTgp7Z9lJDJSaTU08mj2I5xjywBaQVcA?=
 =?us-ascii?Q?jlhP5vv2XjkuqtePnhmn/9xJBWwmNe7OTZ29csQ5U6jSWZnxSEGF4hHwE1Lz?=
 =?us-ascii?Q?ggFqOB/lq/yO8DwYIN0BHgUsE9Rwm2AZZKfLslQQipy8ImZc7AQRVNvEHITh?=
 =?us-ascii?Q?P5MEA+klAoGQ+OiciyfqfYm83SWaigJCpc4TgPEu8FyBmYoFz3vFh3PoaBBz?=
 =?us-ascii?Q?4LtamAh70A/H0KcfUZBTYdLSQsRJnbDIua71dKkOxf28aEFrKrWc/o0uokGN?=
 =?us-ascii?Q?Jid4dkdY+NZLs0apVGLc+GOG9Zx5J3I6HjX+JC/BrJNljwRG1fMW30YnChHc?=
 =?us-ascii?Q?87a+80IGJjg0tNAtBvZbGLE9TIGnETkhKfJUZlN6nIqldqMk1adHusky6GiH?=
 =?us-ascii?Q?YkKE/7MhxAdSOQeOdhYlfS30RRQ8ZwuZLX/ntiH9Bk789FE1w4Oa1227tLW5?=
 =?us-ascii?Q?UwR4l7Teu22Vns+eWd5Fqp3JPkSYNjO7NQorL9++C6mpUHVcf2N3dR6Zlr1r?=
 =?us-ascii?Q?o7iRli8LorYkwIXHvHrYY/x2wQR5O2hViZ8p38xau05VLa9Y+gzPiOohvSYz?=
 =?us-ascii?Q?zL0nlR3wKAkqHZjfWvfSmL97ss1ow3IV8Ni/EMZjHhGbLYFANwlFeq7lI1/M?=
 =?us-ascii?Q?axKJjs2CGjcLfkV6OsRZTa7ogq/21ZDTsGC7rb50GVrlJsZfCBorKrDQsgoY?=
 =?us-ascii?Q?y2xhPHkPNCABiaC36aw8mlw0IuGG0COGMw2wJVJIvgwlJ/vnHE1q4zY3HqOH?=
 =?us-ascii?Q?lv3E5qpcRk5A7BEqk09qW4Kk1/1bqafB+Y3jvuwJG/QpqI/Kkxmcok4lIrDb?=
 =?us-ascii?Q?8cEJtOJd041HzrrP2jTwZLXJET7aaGPyw0k+k49oc0PUYWfXdhsqKxC4IMQJ?=
 =?us-ascii?Q?tKCcJQx0gKmKbrnxmCIViKzHVXgarY/b9Hy7wl0Q066aDvkyrYMsYoGVwD74?=
 =?us-ascii?Q?8weKqCME1G6uamiGjP5EgXYHYRtI0jn986/kvO0U/1j7qNfCHWhOnXVitfnt?=
 =?us-ascii?Q?Jt4BWpNVimVSgqvPYjbKPXzGOZQvCUKZcKxonzaEgd07MxiZQTdPriR55OHE?=
 =?us-ascii?Q?uotYn+p5SAc/Pmzg0OlxbcnHzWdliKmDe96mmpivv7O44CkrbF4B+ebUIsp9?=
 =?us-ascii?Q?uSwIbIqp7pjirxbGxms1bZeWTQmHHZQExYBpLNOSec+9yM30hZQ2LKSaneIp?=
 =?us-ascii?Q?mteuubpvKWO9YeVpnGnq1o84jCEkia9vFZKpFeWXuf3QPMyYsG0UX6vLXACh?=
 =?us-ascii?Q?hho1lJZXcbTFVh7o6P/Wnpd5/lWScfHyhzb7nQ8hz88cJuaOA4ui?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf29390-8521-4c5b-1f51-08df0383fcc4
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 15:09:12.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gH/b/3doKGoHUzwWhfZZfMlaIE9Pi2A2BSjGZKH2c50YDhDfOj1HXXI8c9L1/xcQU452RVGLYpcpazm2x9Si9bYkv5dCt46bftTYuYGqN5pI3pTKJ82WGj7vhU57RhT0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR04MB986522

On Wed, Aug 26, 2026 at 03:40:40PM +0200, Larisa Grigore wrote:
>
> Add TX_FSM_STATE and RX_FSM_STATE to include/ufs/unipro.h, as these are
> UniPro M-PHY attribute definitions rather than host controller specific
> ones.
>
> Remove the duplicated local definitions from the HiSilicon, Qualcomm, AMD
> Versal and DesignWare UFS headers.
>
> This also prepares for using these definitions in a subsequent commit.
>
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> ---

Nice cleanup,

Reviewed-by: Frank Li <Frank.Li@nxp.com>


>  drivers/ufs/host/ufs-amd-versal2.c | 4 ++--
>  drivers/ufs/host/ufs-hisi.c        | 8 ++++----
>  drivers/ufs/host/ufs-hisi.h        | 5 -----
>  drivers/ufs/host/ufs-qcom.c        | 4 ++--
>  drivers/ufs/host/ufs-qcom.h        | 1 -
>  drivers/ufs/host/ufshcd-dwc.h      | 4 ----
>  include/ufs/unipro.h               | 2 ++
>  7 files changed, 10 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
> index 2154d6286817..0d4d5e98ad65 100644
> --- a/drivers/ufs/host/ufs-amd-versal2.c
> +++ b/drivers/ufs/host/ufs-amd-versal2.c
> @@ -112,7 +112,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
>                 u32 time_left, mibsel;
>
>                 time_left = TIMEOUT_MICROSEC;
> -               mibsel = UIC_ARG_MIB_SEL(MTX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
> +               mibsel = UIC_ARG_MIB_SEL(TX_FSM_STATE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(offset));
>                 do {
>                         ret = ufshcd_dme_get(hba, mibsel, &reg);
>                         if (ret)
> @@ -132,7 +132,7 @@ static int ufs_versal2_enable_phy(struct ufs_hba *hba)
>                 }
>
>                 time_left = TIMEOUT_MICROSEC;
> -               mibsel = UIC_ARG_MIB_SEL(MRX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
> +               mibsel = UIC_ARG_MIB_SEL(RX_FSM_STATE, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(offset));
>                 do {
>                         ret = ufshcd_dme_get(hba, mibsel, &reg);
>                         if (ret)
> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
> index 2d214ce9620e..bd223bda1ce2 100644
> --- a/drivers/ufs/host/ufs-hisi.c
> +++ b/drivers/ufs/host/ufs-hisi.c
> @@ -30,10 +30,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>         unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>
>         do {
> -               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
> +               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>                                       &tx_fsm_val_0);
>                 err |= ufshcd_dme_get(hba,
> -                   UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
> +                   UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>                 if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
>                         tx_fsm_val_1 == TX_STATE_HIBERN8))
>                         break;
> @@ -47,10 +47,10 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>          * check the state again.
>          */
>         if (time_after(jiffies, timeout)) {
> -               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 0),
> +               err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>                                      &tx_fsm_val_0);
>                 err |= ufshcd_dme_get(hba,
> -                UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
> +                UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>         }
>
>         if (err) {
> diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
> index 6af6a268458d..08dccfbec404 100644
> --- a/drivers/ufs/host/ufs-hisi.h
> +++ b/drivers/ufs/host/ufs-hisi.h
> @@ -39,11 +39,6 @@
>  #define MASK_UFS_DEVICE_RESET          (0x1 << 16)
>  #define BIT_UFS_DEVICE_RESET           (0x1)
>
> -/*
> - * M-TX Configuration Attributes for Hixxxx
> - */
> -#define MPHY_TX_FSM_STATE      0x41
> -
>  /*
>   * Hixxxx UFS HC specific Registers
>   */
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 75f569dd5cfe..b2081ed6197a 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -390,7 +390,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>
>         do {
>                 err = ufshcd_dme_get(hba,
> -                               UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +                               UIC_ARG_MIB_SEL(TX_FSM_STATE,
>                                         UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>                                 &tx_fsm_val);
>                 if (err || tx_fsm_val == TX_STATE_HIBERN8)
> @@ -406,7 +406,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>          */
>         if (time_after(jiffies, timeout))
>                 err = ufshcd_dme_get(hba,
> -                               UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +                               UIC_ARG_MIB_SEL(TX_FSM_STATE,
>                                         UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>                                 &tx_fsm_val);
>
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index b7b68333fc32..fc24ed995ff3 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -10,7 +10,6 @@
>  #include <soc/qcom/ice.h>
>  #include <ufs/ufshcd.h>
>
> -#define MPHY_TX_FSM_STATE       0x41
>  #define HBRN8_POLL_TOUT_MS      100
>  #define DEFAULT_CLK_RATE_HZ     1000000
>  #define MAX_SUPP_MAC           64
> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
> index a5e40e7604a1..0406f2bb576b 100644
> --- a/drivers/ufs/host/ufshcd-dwc.h
> +++ b/drivers/ufs/host/ufshcd-dwc.h
> @@ -27,10 +27,6 @@
>
>  #define CBREFREFCLK_GATE_OVR_EN                BIT(7)
>
> -/* M-PHY Attributes */
> -#define MTX_FSM_STATE          0x41
> -#define MRX_FSM_STATE          0xC1
> -
>  /* M-PHY registers */
>  #define RX_OVRD_IN_1(n)                (0x3006 + ((n) * 0x100))
>  #define RX_PCS_OUT(n)          (0x300F + ((n) * 0x100))
> diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
> index bf063edc284d..d9fcdf922482 100644
> --- a/include/ufs/unipro.h
> +++ b/include/ufs/unipro.h
> @@ -34,6 +34,7 @@
>  #define TX_PWM_G6_G7_SYNC_LENGTH               0x0034
>  #define TX_HS_DEEMPHASIS_SETTING               0x0037
>  #define TX_HS_PRESHOOT_SETTING                 0x003B
> +#define TX_FSM_STATE                           0x0041
>  #define TX_REFCLKFREQ                          0x00EB
>  #define TX_CFGCLKFREQVAL                       0x00EC
>  #define        CFGEXTRATTR                             0x00F0
> @@ -72,6 +73,7 @@
>  #define CFGRXCDR8                              0x00BA
>  #define CFGRXOVR8                              0x00BD
>  #define CFGRXOVR6                              0x00BF
> +#define RX_FSM_STATE                           0x00C1
>  #define RX_FOM                                 0x00C2
>  #define RXDIRECTCTRL2                          0x00C7
>  #define CFGRXOVR4                              0x00E9
> --
> 2.43.0
>
>
