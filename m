Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013011.outbound.protection.outlook.com [40.107.162.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF2E4E4C5A;
	Thu, 17 Sep 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661044; cv=fail; b=lVzkjJwtsgqtSL+X6F2th7qKjKupFL5gp47Ecuy19ZMfWHAdSI15k1aqPkTshLIFTysXy+Ssk6pjFFHZ0AnNVWrB2k22sq0idEPOHS2P2FiDxicqat07GLXEXhybQNGD5OEvSxBgaLicRxnUylrsbHGEZEpNNAZa/t1s7IHHQtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661044; c=relaxed/simple;
	bh=A+MtAbFH8dSljJDOMQCNyo8tBJ/EZ/AobCxaPFHoOiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JUvIirYoLIhqjBn540Gs7/n2Kpdni/FsZDw4Gh9/T+Gi6IXKTk56L4D20bGztNjtG1G6WSU6M/rYplTYwDqgKezPcrXOeytm+cZVHOPZyZ6WOqHmex8iAJpTtxwnFuEaHl+/HEMR9FKLg0Prj7MnleiyXxiawFhQ+SUDkbresu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=UNhpCiy3; arc=fail smtp.client-ip=40.107.162.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="UNhpCiy3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEOZXICsd8MwhWXqzMp/wfher43TmDxi0thfTn9ctqpoS2/10URXHUEogqadPD0bth6A94ykzuaD+HPv2z4cnMjz0Lz6pAwVFX5Nu3aWb0VrlEZzEp8uAaKiuiewV+6/jmOjFjC63C5avXfImPflqlfNA/14809aLQNTXf0SqH+GjikunM1Z8gamwAds31Pd9Tazg7pdh2ENl0GBQ0eBZgRnog1vFOPjG/90V5sYhWfC1OX0NZxMFBO6sPVl1BBkBjtOEFrA1giegAjgYui9I6Zbkz6SAWNsX477hiol1io8U/SaYb0iv92+VUfhpCdLNJoL1b4m40X7fo8mi/qmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pVuUX6eWjeFkXe2CNgyoAyvhETAc5N0ln0OmGsf5bI=;
 b=NeRovmchWR06msF5WcJlvePy3+/p5ZVNQv1fhvpKHYHCsO0btpPC73OZi3k84TlNq9I/PmvKG2IJsRACs2Syu5/fgr0XeA8t45DVbKtunH1TDsNe9N6DY5TR9cbidDGLRuprwt42OUoPzcaww/AloPopA5DADuY9RDHqKVlzxaPyfFBeSNh0R/QFM6ytU83zFaDPUkS5qbXAk7kiIKWFDY+sWEbPG6gqGQ4kwmvO9sc35CBlBa41gEP/4+VNM4lNJeXBJQ+HOOnP9SQfozQOWAQr2JKe49p4vgaYvnn+i3v2T9SevKdGe6WIifZhDEg/Fl6IxBEEIJhFT+f1WaPSrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pVuUX6eWjeFkXe2CNgyoAyvhETAc5N0ln0OmGsf5bI=;
 b=UNhpCiy3PmfNWO7S6cslgSzw08kVUdbc3PGC7YTeTepQvC/QjZhn/uHDqwElDjMBI+P58GxbSTTRmzX73cA9rTjlp7+QfThzZxY4k0Adq1pVA/QQ2vxgyS3+7282VLStzJJF5T43zQShVw8lS6Xh0CANsqOPlvq2frBmMYNWFHy4WU+8EL6TvPgS1JEU/ToJJZR++0bI3LW+VXAJlB4BZ2lZF6HyQSnjG1CgiOctL+fgN9zidRjmS6l2yyICN20qs1tzZBQpIpTV9mPSHShGsWPZBJqqEBRIzi8nohTaBaiPg+Pl4RICj9CnlV87xbn+uTtuJVDpbKCUOxK8NtVHkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by GV2PR04MB12338.eurprd04.prod.outlook.com (2603:10a6:150:321::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 16:03:57 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Thu, 17 Sep 2026
 16:03:57 +0000
Date: Thu, 17 Sep 2026 11:03:44 -0500
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
Subject: Re: [PATCH v4 04/11] ufs: host: Add common Hibern8 TX FSM polling
 helper
Message-ID: <aqwPYEvGiamxNW3T@SMW015318>
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
 <20260917091555.1443076-5-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917091555.1443076-5-larisa.grigore@oss.nxp.com>
X-ClientProxiedBy: PH8PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::8) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|GV2PR04MB12338:EE_
X-MS-Office365-Filtering-Correlation-Id: 299f4c8b-b0ee-4444-0835-08df14d54792
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|1800799024|19092799006|376014|366016|23010399003|11063799006|18002099003|22082099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 c6KYmnsYBEyMGLmrgsdUXvaDo78yuJmy4rfIp4h7qgzWNiiwd21ylXvgUclRcSRLSEo69qGgbqPofLNu1Z8PpXbNFOPwXqOTpr19UAJ1WYNWbFlOVww9zaJAWTmI/kGu5zIIBn0BjnDY+Z15RVrnoe3RklXjgtzDHCQRD59rA8yqBqzMRdQYuVllm3Sw6+7wxpb/VBfWDedvIqR6qvVwzH2/VLXL6kMhz1C+HEnY8ICgZQtFAsKsX9PiVbaY2fGXK7Oh9hCC175oM9sBaAwalYOmBNwqA8phs3bEw3d1gtu+ArV/B/ek1wmowvJ3x0Qh+ea/xf6T2jFtStvd/pZCg8bAVB0JnH3GC68fTBuEhR9g+b5VKcgE05nDVuhhff92amD1H+ppRZKFEnCWE3PGIjGkmGfANgMSm1PEAzrwefaPjrDR7XqM+DktwRsNLy7YZmEfUdbzW9Gvd0zfVW2PiE4RJIdqiYw5fzZRlk5FKFpLQ2hY9jZ0CuTJH199VrH2PvO2ckSXFl9Pq/hz0VFj54PM+ykRY7XJdGmFp5Iui3uR5vhv4cdZN39cFdBAgaf8Q19zj0khbUG3VbQZC4DmpnjxbenHckDvLEhYRjqLdduVZYeZDEenRw3u3rKleKjfB8vAV5LsiEtwJjklVOMw3nqPS60icSUyk/YGvoVrIRM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(19092799006)(376014)(366016)(23010399003)(11063799006)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vgll2SUJiEDORxpvk4GaHWau4VRQCnkjGA19TuILvijJmZm8r4v5mK9+kLN0?=
 =?us-ascii?Q?xt1J1QG0/STJPyaM92xx1Pn/lVD5d62TZBX90rsMk6zemjVxb+/nkwfarooX?=
 =?us-ascii?Q?jyhayK+x3fdxSNC8vbMUgZAO3jEirdTTHY0XghjSwH1zqyAJ/uSQZJYfsnNG?=
 =?us-ascii?Q?vMeEPZxqxKqFDwe+nNzU7ncZHm7MmMGqo5KEWqlOYUIG/Ps6pz/PzRRRX+Yn?=
 =?us-ascii?Q?ZeN5Ugk7B5EzS+rFIiJgoYuL+Ek/byf1lM8fKy0G2eNVzolV5kv2hw48Uktq?=
 =?us-ascii?Q?Pbba2UKfqcLh5ar1qsNZwPZEHqDjqtdDufmKU/+2DNyjYr0CRta4rKE0sPRF?=
 =?us-ascii?Q?O/8cM/1NXXglaIqxOSvnqEylzxuKvHNs+VyCKhiYxuuAK7EQGt68UW8G+6nu?=
 =?us-ascii?Q?/i+vFYtvPIgM8mqPq4/kITfxeH6s8c2cmDjo7nbKltp4HsR3h+qIL3h1Nqp4?=
 =?us-ascii?Q?Ufey3zmvjzqmiM4sgdRB6ZBy51MRMVfnS5Xz07NGNpoGdIHgTFa8LUf8kvLq?=
 =?us-ascii?Q?NAVyUuqfeFhaVbZqfJ/Hi28TlKB+5LpcJT7bHk6lAPS/+FAY52fY4jv/EYu6?=
 =?us-ascii?Q?RSHGaMIfJeEAzhzTRQl+ZiCeCFcbuXOPN/j6aLCqEQp1Xa1XdyIphmapuDm6?=
 =?us-ascii?Q?xNHjXHzcSgZF9VcB8ipaHDzzl2MUIgwhrvUYgGxY326+TRC8bQyO7DmdPoGG?=
 =?us-ascii?Q?w+1v2t78rbtjGtgRTxI2cKDLKBYFsjtnuga4/Gp6TSA/+2ioY4eb81uox679?=
 =?us-ascii?Q?fD91R7KJpm5YU1oFgPMpmVed4ZBjpuTvJsyEyEYEKRA8egGsN7Su1CMTij0X?=
 =?us-ascii?Q?ZKU3PTmMIdoKnuRFTzCJXCCXyV9pHyAh9PRm2h0rx9Em8NyNuhggEeldBzXX?=
 =?us-ascii?Q?JBqh/pHphyA8JU4L7DudGMMefFiS8gEswoX+FH/fUon6tseIKBMSnnTrz14x?=
 =?us-ascii?Q?AEx7ODXwyFm3Pfk4kFbgloH8lPmdJrmj+PdFK2Vc4W+uDPtAHkF8UBoqASFj?=
 =?us-ascii?Q?aPtUIzpuIj0u9vgmyt5uJMUIPZCkt2hPapu6xQp7jQMvUE5tSG5IFA9TQL1L?=
 =?us-ascii?Q?26P8WMlQe8QzJjt5xqvjAIQ92FWLki+yh3mRM2e5ywTxLgc8ju0R/yT9BRsU?=
 =?us-ascii?Q?4pyUM3NqMrWc4MdKWRGJ5WHn8tYFXF77qq5T0sJt0A1CtKgC8+Nu9Y/jlI7k?=
 =?us-ascii?Q?5oUvSTu/QjmRDt2gB9LhNLkPCmnqRJoIRlFGVHLSQg5fxskvLi7sq8MMrI1e?=
 =?us-ascii?Q?/Wyc88ibnMMmLaSAJRHlsvUgp5TXi6mjtozvp133UppTuJV5ZayeAfywTD9M?=
 =?us-ascii?Q?mKQRTSx03O2uMq1OGX2HkB4HyjRE1CuhEEJ6ikhwp6OFUxrjavJY3DXBCOrr?=
 =?us-ascii?Q?NHCtvZBeD17toAmmA80rq3Tv0jjHnHx+oQ+HH7411YE3RGiOhXAtcpQVfenZ?=
 =?us-ascii?Q?WeSSAdiIIDptZCN0bnh3+XQyJ3CGxYMgKOqZ5SyVqwCGxPKLtEP7i2NXiwgq?=
 =?us-ascii?Q?t9qbqFMlRx+Uj8BEln192KR3WtHXXumcreWU2+nSDGKnBUsks6lhU3T1K8W8?=
 =?us-ascii?Q?1/qyP4YufKvR3BgWzguR3YpuAJcRLgFdrPgCDDtxP07OqzJk/FN7/Yq+Nt/b?=
 =?us-ascii?Q?bMYIdsvRhJhR05M4sKKV65AEYZlAvSkEjdzeiyhPRDK7BWpwPy+jdl7tIlC9?=
 =?us-ascii?Q?LFa8vHDgKFnK64WDoxX7Rrk4q+Y0B/uCAjtXR2sgnV6mdCTQgI/8fSxVN6MU?=
 =?us-ascii?Q?ySMOjCl3TsuY9BcRwGsS6BQehc0dJP139ekyGsqayWCFJnNnPYpo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 299f4c8b-b0ee-4444-0835-08df14d54792
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 16:03:57.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQ8HRffxVBK1yqCNDyIa3io5EwtJLjgVWRf0fkxG6qj3sroInDDUYTcUIeC325t8Mi+9vj/bpxpWSN68OD69hrFz93tFR/lwCbnZpUAT+0e5IYf4F06e5hv1q57S3uBr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB12338

On Thu, Sep 17, 2026 at 11:15:48AM +0200, Larisa Grigore wrote:
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
>  drivers/ufs/core/ufshcd.c   | 73 +++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-hisi.c | 48 +-----------------------
>  drivers/ufs/host/ufs-qcom.c | 42 +--------------------
>  include/ufs/ufshcd.h        |  3 ++
>  4 files changed, 78 insertions(+), 88 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2ba244cf40ac..c1c61377e28a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4448,6 +4448,79 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
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
> + * @timeout_ms: overall timeout in milliseconds shared by all lanes
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
> +				unsigned int timeout_ms)
> +{
> +	int err, ret;
> +
> +	if (!num_lanes)
> +		return -EINVAL;
> +
> +	/*
> +	 * Poll every lane until ufshcd_poll_tx_hibern8_lanes() stops returning
> +	 * -EAGAIN, i.e. all lanes reached HIBERN8 (err == 0) or a real error
> +	 * was hit.
> +	 */
> +	ret = read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err,
> +				err != -EAGAIN, 200,
> +				(u64)timeout_ms * USEC_PER_MSEC, false,
> +				hba, num_lanes);
> +	if (ret) {
> +		dev_err(hba->dev,
> +			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
> +			__func__);
> +		return -ETIMEDOUT;

nit: return ret;

Reviewed-by: Frank Li <Frank.Li@nxp.com>

> +	}
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
