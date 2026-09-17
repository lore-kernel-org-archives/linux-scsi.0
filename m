Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013035.outbound.protection.outlook.com [40.107.159.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72253FBEA5;
	Thu, 17 Sep 2026 09:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635631; cv=fail; b=T2M5tbMukVmXFs3FVcV7msbzy5sch0CFtsolUzpLvVI2Fg5Pm6gdmO8Njd8iWGAK9fAsW9+Ntx9ymH069ulJiUenwK3drgBiXSLfILARljQP8r0BMl8I4yjrHuaa0n/Id2TUulIj+4/rpxH+upflxWOLFXIiwpi3rBmNT4oQVm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635631; c=relaxed/simple;
	bh=f2h/bqn6TKYmUie6aX5TvGuMeIhj5H/tcjSvGQqQcFI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D1EAZQyVafLU5X6RRk2/1IrS/O7441ZcCpCHkUVLa4tb6RIg/VaSttTJ9Llf3+vrA+cnV3g0H5m2Ka+NUNCDWANWeDzoddWoMaGXLG3WkxVJAEIFEcUzm4s+K0GMo4y/iGg6HsclFYEUI7U4BYJ9LjT6u+BrhaFxpmJo68dfR3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=o693R2dn; arc=fail smtp.client-ip=40.107.159.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="o693R2dn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kCc5ghldg8MU5ZqZF219BI5ANXYaEwE2A/EykSSj/ofcmElg97ST+2t9rqna4cdhG2Om6uUmhUP1TNYIHfgASHk7kHfsh8RvrahEV0K0fAgPMUVCTlp3k/S+b1ytOnlelT+sDFsQcTtVVuc9ryoJW2iAkb0jJk7xQEP8Qcs2RJxzv8gUt7amyb72M33Z/s9D4qYT0j6HK6oJYHALOfQL34DJDjXBv3kUq2J/dVqWcLTruSnOkGnhv/SJJ4kSOaVJAJZYP5shrBjq5994lWlrD9IyIcBSe2XNaYzqCeYLIAmYNOJ5cJviEV0pOcjeA+6tDimMJkGs8tL+Ydf0CV8AiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkG+WwuvgG4tEeN5QC8U9FMOn6IPoGYWtOPneF6eDB4=;
 b=PftI3igES6xPCmZ9Ob+gRmlim5/9juiX8kRCXw3uRqIGQ740HEKeglE1g85YXqAncINsdpqQIUAsDkBICAPW41OPVDqpf1PX9sF+fhV6c2JO4+RFKpphDd5d32sUNhJUC/W/qxnJA5jOnzuWKXCCUrxn2EA0NZMsm6IgdX3sE1RZl0uHrH63Xk4nkWGRdRtt4s/hmbzoz6LJAvFRf6USp5nHFZaJO9Ftz0FJhxK1nYFLq8Y3UlLyQOjogFbUZBrqSFHPgLP70/my7yOd/4LLwK+yES2RF5Kc+IXEksT3fiDxbkv76RXuxrYFUvpxz4xJkIQfZSHmoZT4r4FgOLDttA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkG+WwuvgG4tEeN5QC8U9FMOn6IPoGYWtOPneF6eDB4=;
 b=o693R2dnPrpfLfnWIptirMrllBJWBHAXX/fgUC/YnVDgqcWeEBuCmVPneHldggDeiHRbcuGhjmJd3Su9/GFWAYsWCunMkTgYRrJegotWmdR9q7p/vGRASH5urA4Q2hfZ7NFxirkF1sptKEVsSiOlrohc3DJ+U0tCuj/N5vxAV6HdNvZ6zqIV1Dtd6LCUzq42pM7V5LhXLsN+iDvQKkUj5oFjagUXV5dEe1VrYjlDgqBTyNBtb8+C0Uf1ask6kQvAi5FZi/UrHM4eKP2HCxyyh6ZExJSP1MDd/20wVEub3lDhE5F6ifCdkitIsoZ9ScHERr/TlKSPzLIKPxYoZn8IFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DB9PR04MB11628.eurprd04.prod.outlook.com
 (2603:10a6:10:608::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 09:00:25 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:00:23 +0000
Message-ID: <adb4b74d-a445-42cd-b041-0df2e454a3d9@oss.nxp.com>
Date: Thu, 17 Sep 2026 12:00:19 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to
 unipro.h
To: Frank Li <Frank.li@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com
References: <20260916084411.941297-1-larisa.grigore@oss.nxp.com>
 <20260916084411.941297-2-larisa.grigore@oss.nxp.com>
 <aqrAZfkcU29Oq7Jo@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <aqrAZfkcU29Oq7Jo@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0184.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::19) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DB9PR04MB11628:EE_
X-MS-Office365-Filtering-Correlation-Id: c31be38b-edc0-4778-2668-08df149a1bbc
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|19092799006|11063799006|56012099006|4143699003|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 zxvo2sbZyumQly2mPS7tgHMUpuOu/LeEsrVAhof5yTAN92Md5DnJo6X4/HT9XSxmVydDorR6VaEY+bQ32ndXlKyEmZylByr7lYPgCMLt0O7Ebe/D2LDmu2a9naA2CnwJuLYn+GPS6y7SKhVIYBeJZk/kRFR8LBi1A+IvZ23YOFPCYVKXwEL9iJHy+3t5u22MaCdZOSkE0rxjKaETTimZSgUuxqnILPTXrmQXFu0mch+J/SBLElT00Ay8wC82/7IgPYc/NrNCZsfIf9r3RqdOEQp2i8UZd8GBevLpcSyNXC9/fN/5Kqi06/LAahEij+6IVSepy9LgtWoNXNKXNmdFUFkqZV7IrhjFVFy+RMksJ8N2puOeXMzWqNj5ODZhzBShCO8ekGSj6V6G31YR8jtBZnRpbuc74ivbdkvu2tbC76LWu0RDxfizLVd93d1BMGZPj1XzrNKM7odARzdgACwm0OG1xu+XXP3BO/QlR9YV7d0xuiTeoO57Nn+UVBimhrDh/0XGo8LK78M9PTdVAGvTisNdONuyTCN3dEDDO87mL7YIwAhjtq85hhEQ2xTwM+4a/GLbKbrz3llTawSa+tnBTbNodKN1CHZ1uNuQ1Ky6DRIkIt6fggej9fHQjxE/+kEAs/4R80nGWplLcrmVnitGcIsytL2WsspWdKrVzKeF/Ko=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(19092799006)(11063799006)(56012099006)(4143699003)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WlNJUzJzbGQ5Yko4QTFlSDFsRnp4dHNKejJZL1ZJbXg2UDd0K01FTEVSSkdU?=
 =?utf-8?B?Z292bnJQQzdXdVZ3bGhWZExWV25DWHRQcHQ4cS9nSE42Z3hDOEdjeHlmaWlv?=
 =?utf-8?B?cFJTYjcrSVpiZFIzK2lYdzQ1M1NuYXlNYU8xM3lFQS92dFRzR1gzaWFUTzg0?=
 =?utf-8?B?V2RLNlZ6NmxVYis2SjlndGEwZWthVE1obVk0RXgyZUoyN0MveS9TWkF2a3p4?=
 =?utf-8?B?OTYxeS9rck53czVUMmFZcEFnNFQvdmcxUmkyNTBoYkpERVBkYzZyYkQ5NzEx?=
 =?utf-8?B?bTVidFNXNFhJYzMzRUFvdmQxOWNKSmppN1ppTEJ4SnFxendWU1ZFUTZtdFVX?=
 =?utf-8?B?WCtTdE9wOUIzOE90dkJhanNKNlEwc2lIbWl1dUVlODVQbGhXSTQ2cTFTZ2FV?=
 =?utf-8?B?UzQwRTkxMndsNW1JVm11b1F0WFFrUStEdVV4dUFDR0swOWpYSkROMWRodWQ5?=
 =?utf-8?B?eGJ1TnYxSit2Rm50Z2NHdWp2MEtBc1NEemhIY0xJVy8rZFFwYk9hUUYwVC9D?=
 =?utf-8?B?aHJ3ZnI0N2t5bmJ2YWp2UFhJSGFjZXdGTlRvS3FSVmFxeE1XZkUwZFBuaXAx?=
 =?utf-8?B?eXU3WEpZbnBBd3JPdVNRUDhTYTJFM0k2NzJMWFBvb0EvMjJSbEVsN3NTdkg3?=
 =?utf-8?B?a2lzK0VwdjRCSzhtK3o3VjFrTmo0UlpuY25qZFFkOWFBVE5Bck1ySWNYT21X?=
 =?utf-8?B?Nzduc29RNEpuVmV4MEEvbzl3QnExTnJjS2l5bC9rRXUvTFVqZGYxclJzRzhq?=
 =?utf-8?B?NmNoT0l4L002QjNVT2xBa1lUNmRYVGlna3FIeHpEQ3RGTGZRSHFhRkg4VWk4?=
 =?utf-8?B?cW8wYXRaZkM0SURyV2c2VCtpZHViYUFQUlh2enQzVVptbGIycStOTnIzUDJa?=
 =?utf-8?B?WWUzY2FJMWw0cGVnNEtabEFsSUIxL1JLT0dIWmhWdWxENW83ZEFCaUFwNGw0?=
 =?utf-8?B?QlhQdDBBUDZ2MitDZHl6K2ZMVEdRczhHTWxpYmFVN1lEQXJZa0dEaVNNVm5N?=
 =?utf-8?B?UVBOWCtFeFdhZUpROUhCZ0ZFcmRBaVdUNjJQNlpwMVROcHJXYllwUlI2ZW5l?=
 =?utf-8?B?bEpwWldUWHFqVzVoUVBCU1Y0VDdrSktWRGJxSm9ZeHN2MDhZMG1iNlVDekp3?=
 =?utf-8?B?TEJEcE9RVnkzbTFaUFQrbkJGa0E4ZjRVbEYzNjI3SXZPUkpRcHFPWlBKcDE0?=
 =?utf-8?B?aitaS0hjczViR2o3NEREZS9XUWJMejEzUlZhUzV1S2hZZ25vTmRLRGtROWYx?=
 =?utf-8?B?bDhBeDVTbkFUaEtTTkJDWEYrTisyamlvd0lWdTljV3ZnU0J3c3VFdGlxekVw?=
 =?utf-8?B?MkR1RDhYdXFYVTlhc29KWFhwZDNNU0MyNGh5TG1PTmEwODkyNS83SEc1Q1Ni?=
 =?utf-8?B?VCtXUlhsQm9sV1A4M1ZDczdpOE5vN3ZuZVNBUTVzazY4VEdIaWtCenY1WFgv?=
 =?utf-8?B?aitZa3kraTBTVG9oQ1Q5MGhPUkJyK091c0V3cmFBemNxRy9maStZcytkTWFT?=
 =?utf-8?B?eHNBR2NzM2VMZHl0QXd6Y3BHNThaSHdFN0QwMTVBMW9jd2IxQ2ppb2hZV2pX?=
 =?utf-8?B?Y3g4SjhJQjlRMTI1U1loWGZVQTZzaTc5MW0ybHVVQ2dRSVBHWUN5TTJ1OXor?=
 =?utf-8?B?VzAweE5CZStUOEk2Y3lIQVRpTWxuU20xWFEvd2hXVzBnMzdlUVk5WUlJekhu?=
 =?utf-8?B?bGxmWlJnR3RpVGhHaUpLWTNxYmxqRXQ5MkRPVi93UWhzcXo5bnRIS3B1Yldv?=
 =?utf-8?B?cXkrZ3oreWpjcmFOTEc4dmNxSHowK3cveUk1b3k5a2srelRHTms3UHdycDB5?=
 =?utf-8?B?Ym5GWEhOemVNc3VQdnhqNlY2L0kvYVluQ1pUanZYSnFqQ3diUWdWSVhaaGtM?=
 =?utf-8?B?UnpjeWh3L044YVl5ZFJoU2M1akxMcHRqY3BEMXE1TFJCY1dYYjE1amMwSUNB?=
 =?utf-8?B?a0s4UzRxTUVrd2VwamNDeXVRT3Z4YTBTM1B1RzNnRUk2UzR1cnorYW9Lekht?=
 =?utf-8?B?OFlnZTNhTk1kbzJQOFpacURMVnZ3d1BKQkx6U3p3WHVldTlYVFhHR2kxSkFx?=
 =?utf-8?B?L1RzTVFRYlBmZ2N3bHNUbHYwUDlzeUU4VU5zdnl1TmxaS3VJQVF5S2FrN3FJ?=
 =?utf-8?B?Tm5IM0d2amlOaEs2Sy9lS0JhSEJqWEptK3F1bDRjdWY1UGJoZ3BLdlhBMWUv?=
 =?utf-8?B?clhZeHVDZWxVYTRRZmVHMERUZ21LMDhSVDVKcmIveHk5NmY5TzNZYWtmWTJo?=
 =?utf-8?B?Vk9XelM3akgwMlZSeHJ6RG44QlRUT2d3T0M1WnBrVUpxd3R0VXg2NXNrZXk0?=
 =?utf-8?B?NlROR0hzNnI0RVNONXhWS1cvNzhzNDBDVitSSDBSTzAvb01CSHplZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31be38b-edc0-4778-2668-08df149a1bbc
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:00:23.5001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mr9J+4KdWQM+pSGg7sxsjRkBhXzvVbdpIihOqdl6OAEXIYC307lJr62Y6Py5mHGKOA4s75ZDUjUa2kuTNuNJBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB11628

On 9/16/2026 7:14 PM, Frank Li wrote:
> On Wed, Sep 16, 2026 at 10:44:02AM +0200, Larisa Grigore wrote:
>> Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
>> include/ufs/unipro.h.
>>
>> These state values are UniPro/M-PHY related and are not specific to
>> the DesignWare UFS host controller implementation, so unipro.h is a
>> more appropriate location for sharing them.
>>
>> As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
>> ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
>> TX_STATE_HIBERN8 enum constant. This is a no-op change: TX_FSM_HIBERN8
>> was 0x1 and TX_STATE_HIBERN8 is 1, so the compared values are identical.
>>
>> This also prepares for using these definitions in a subsequent commit.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>

Thank you!
>>   drivers/ufs/host/ufs-hisi.c   |  8 ++++----
>>   drivers/ufs/host/ufs-hisi.h   |  1 -
>>   drivers/ufs/host/ufs-qcom.c   |  4 ++--
>>   drivers/ufs/host/ufs-qcom.h   |  1 -
>>   drivers/ufs/host/ufshcd-dwc.h | 19 -------------------
>>   include/ufs/unipro.h          | 20 ++++++++++++++++++++
>>   6 files changed, 26 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
>> index 993e20ac211d..2d214ce9620e 100644
>> --- a/drivers/ufs/host/ufs-hisi.c
>> +++ b/drivers/ufs/host/ufs-hisi.c
>> @@ -34,8 +34,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>>   				      &tx_fsm_val_0);
>>   		err |= ufshcd_dme_get(hba,
>>   		    UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
>> -			tx_fsm_val_1 == TX_FSM_HIBERN8))
>> +		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
>> +			tx_fsm_val_1 == TX_STATE_HIBERN8))
>>   			break;
>>
>>   		/* sleep for max. 200us */
>> @@ -56,8 +56,8 @@ static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>>   	if (err) {
>>   		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>>   			__func__, err);
>> -	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
>> -			 tx_fsm_val_1 != TX_FSM_HIBERN8) {
>> +	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
>> +			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
>>   		err = -1;
>>   		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
>>   			__func__, tx_fsm_val_0, tx_fsm_val_1);
>> diff --git a/drivers/ufs/host/ufs-hisi.h b/drivers/ufs/host/ufs-hisi.h
>> index 5a90c0f4e90c..6af6a268458d 100644
>> --- a/drivers/ufs/host/ufs-hisi.h
>> +++ b/drivers/ufs/host/ufs-hisi.h
>> @@ -43,7 +43,6 @@
>>    * M-TX Configuration Attributes for Hixxxx
>>    */
>>   #define MPHY_TX_FSM_STATE	0x41
>> -#define TX_FSM_HIBERN8	0x1
>>
>>   /*
>>    * Hixxxx UFS HC specific Registers
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 954be9343f42..38897d01fde2 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -393,7 +393,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>>   				UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
>>   					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>>   				&tx_fsm_val);
>> -		if (err || tx_fsm_val == TX_FSM_HIBERN8)
>> +		if (err || tx_fsm_val == TX_STATE_HIBERN8)
>>   			break;
>>
>>   		/* sleep for max. 200us */
>> @@ -413,7 +413,7 @@ static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>>   	if (err) {
>>   		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>>   				__func__, err);
>> -	} else if (tx_fsm_val != TX_FSM_HIBERN8) {
>> +	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
>>   		err = tx_fsm_val;
>>   		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
>>   				__func__, err);
>> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
>> index a5ad5ce44a19..3c6cb2281af0 100644
>> --- a/drivers/ufs/host/ufs-qcom.h
>> +++ b/drivers/ufs/host/ufs-qcom.h
>> @@ -11,7 +11,6 @@
>>   #include <ufs/ufshcd.h>
>>
>>   #define MPHY_TX_FSM_STATE       0x41
>> -#define TX_FSM_HIBERN8          0x1
>>   #define HBRN8_POLL_TOUT_MS      100
>>   #define DEFAULT_CLK_RATE_HZ     1000000
>>   #define MAX_SUPP_MAC		64
>> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
>> index c618bb914904..a5e40e7604a1 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.h
>> +++ b/drivers/ufs/host/ufshcd-dwc.h
>> @@ -39,25 +39,6 @@
>>   #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
>>   #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
>>
>> -/* Tx/Rx FSM state */
>> -enum rx_fsm_state {
>> -	RX_STATE_DISABLED = 0,
>> -	RX_STATE_HIBERN8 = 1,
>> -	RX_STATE_SLEEP = 2,
>> -	RX_STATE_STALL = 3,
>> -	RX_STATE_LSBURST = 4,
>> -	RX_STATE_HSBURST = 5,
>> -};
>> -
>> -enum tx_fsm_state {
>> -	TX_STATE_DISABLED = 0,
>> -	TX_STATE_HIBERN8 = 1,
>> -	TX_STATE_SLEEP = 2,
>> -	TX_STATE_STALL = 3,
>> -	TX_STATE_LSBURST = 4,
>> -	TX_STATE_HSBURST = 5,
>> -};
>> -
>>   struct ufshcd_dme_attr_val {
>>   	u32 attr_sel;
>>   	u32 mib_val;
>> diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
>> index 9c168703b104..e0f490e11c7f 100644
>> --- a/include/ufs/unipro.h
>> +++ b/include/ufs/unipro.h
>> @@ -466,4 +466,24 @@ enum {
>>   	CPORT_CONNECTED,
>>   };
>>
>> +/* RX_FSM_State encoding, MIPI M-PHY v6.0 Table 50 (M-RX Status Attributes) */
>> +enum ufs_rx_fsm_state {
>> +	RX_STATE_DISABLED = 0,
>> +	RX_STATE_HIBERN8 = 1,
>> +	RX_STATE_SLEEP = 2,
>> +	RX_STATE_STALL = 3,
>> +	RX_STATE_LSBURST = 4,
>> +	RX_STATE_HSBURST = 5,
>> +};
>> +
>> +/* TX_FSM_State encoding, MIPI M-PHY v6.0 Table 47 (M-TX Status Attributes) */
>> +enum ufs_tx_fsm_state {
>> +	TX_STATE_DISABLED = 0,
>> +	TX_STATE_HIBERN8 = 1,
>> +	TX_STATE_SLEEP = 2,
>> +	TX_STATE_STALL = 3,
>> +	TX_STATE_LSBURST = 4,
>> +	TX_STATE_HSBURST = 5,
>> +};
>> +
>>   #endif /* _UNIPRO_H_ */
>> --
>> 2.43.0
>>
>>

