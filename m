Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013071.outbound.protection.outlook.com [52.101.83.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C35F470106;
	Thu, 27 Aug 2026 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839875; cv=fail; b=Mpor9DJfOqlozICB7u4hYmQ/pzMhhz1OULwCy4NGCpduTyWYwiRikzC79LirzBbO6q8IOpruNqiADWdTcRJvupT4AwN4VuMRiYwnPKdiIrOFBbrvOVPgVDWwCEBNZ8Cl/FNTjnuF0+0WnjfSQ5PWFmzLDPX31ZrXUun8XJXLQVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839875; c=relaxed/simple;
	bh=+KhSYl0OUSl5ox2o6RA4mFFrUG3ul2Q0QCYOwduWqos=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=imXG6F4+sAq4fn3Ze4CcFxAWpLD9xLC+7IDqmj0dNtf4qM3qHb6BDfRaqGn4ClSUIo5qnWci6MVkpVSaIwaAJC8Qpes9xrUcctrBe5K+pYPCqN+/ZU7izLAXEffGEfmlra/CNJt2S2L/PFxp8V25EC6UGUPPE3yFg95GY9bgvH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=bA1m7NnR; arc=fail smtp.client-ip=52.101.83.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="bA1m7NnR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JdkDrTqx4DXUHP9hbEv2nTwF3CCjuGL0L+I6dUoCNyJg0TAR+vtOTJYal5SYaP9lJGtFcqeCDsl9IxCnaRaw4pD/PWLF+kb6H4sf9J/xYi0etgiGgQ2z9k603vWkTEH26eUvPd/NbqmCP7H0az9nWGZptMsWJpVroL2QF/FHQlx2lvPyeMzZ5u6DCQn7kMdXaiv4QhbIDJyhaSZSANqghyHJrkVO6crDk0V8asHAJGY2SmxGktR66gbYy3nA1xIp891FO5mtGouVs5SRavgOOXNWZaZDztaw1gKJujAx+BGH22l4d4HMm9PWiyY7W313rdof+3G/0QWQCRHaeGUdzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecR+CZK61H2cTf6kV4lPAB9c2C+4GkQM+R63BSFp4CM=;
 b=w0yU1s0S+M5ljoilr9NyajAXt3RRSxVrpTtA48waqXcCDU3UgUMWg94obHNeheh9wdyFiLBqNbMlhjxqXp15ZrqEGCB0WZknlzbC0Dpu+N+QeGuDfQ0U2cxVFBjXCNIGd71FMfc7T3birhvYHQj0n8ftXrC0NcA0VGTPtV09kTkbQUfLZpj2JMflmZkQT2C+wEo/Z4IpA3bGhuHArYOf/f9e1cl1Za1tImbyUEDlHjNDdCYGKa4hy8WdNZfq4hAWXbW4fz0njOY2y0d29bNWh9MtZhWVqxOqa5bnFIIfEf7Lg+T+IcFsF4RRCJ99gz1CoLenU7omNaR3D7pkx7J5vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecR+CZK61H2cTf6kV4lPAB9c2C+4GkQM+R63BSFp4CM=;
 b=bA1m7NnRX9sKgkDhz3SjSWPAteMVBCUKKJ5qktCi8iOWfY/eCu9CGOcJk/8km05lqIhKa1AONilPJe7CnNOCuWAIJZzdolkMctULt/wYn8Kn49s3zaYFHx7pWhLsOntocKrXwdjj0GhfCyoPw/D99Du7961pcVSvPXTH7UaS9SmFCZW/Z6UYQcsghXL0LhnzSstitcUcxGuCkU0AeZI0dINlsIILqx7mdgL9CdFzctgIeKDms1x2cCzzVf4Q33LzfF6wCS86MpE/WI+/LSMZPxujmfP03Zy25DCXY5U0ajLbYaQtJkyjnHP/GJFM9A+CyWbbH1vSGVEtQ7n9/xpUJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AS8PR04MB7976.eurprd04.prod.outlook.com
 (2603:10a6:20b:2af::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 14:11:06 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 14:11:06 +0000
Message-ID: <85c580d7-dcc9-429d-a2ff-e286d4ac0fb5@oss.nxp.com>
Date: Thu, 27 Aug 2026 17:11:02 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] scsi: ufs: Move Versal2 M-PHY CREG access helpers
 into ufshcd-dwc
To: Frank Li <Frank.li@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Frank Li <Frank.Li@nxp.com>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, clizzi@redhat.com,
 aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
References: <20260826134048.854748-1-larisa.grigore@oss.nxp.com>
 <20260826134048.854748-5-larisa.grigore@oss.nxp.com>
 <ao8ERPmAsNEtKHUn@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <ao8ERPmAsNEtKHUn@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0208.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AS8PR04MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: e10aa8a7-b41e-4c3e-1a17-08df04450941
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|19092799006|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
 QLgUH1itOw+XtIruF+G8MS2NrenDQVGgrRCoH9lDRoSW18KYJ2B0CLoNqXHm6U9NzpSZVh7T3x+dww46j+X0PulLwTST/kI/9Pryci9MqE1E1niCqw3OKklDf0e8BSyDg+IxJEHTgfPdBdmCadB3CtwICmsyAJVChubOsr2VqIdRloJQGnDbQa3fipQqTpWcEeWwaTVD/Y6O766T2HFw7YqZVr+0UE9e9q1JVO7Eh9JmOxeVkCGcAqICDYzfx+OSdcqc2zP4HSlCy4pWoklte6gfdn1L2Tid4NfCWj9SRuDKkv0MpzxZudWkA709dZkPJ6NK+c2mZwbk4a1dugSoLT9WdhL9Pky2OKf002wlSv3hGMORy3wEtEfKNQvHlO+XLXcPr0CZS1WaB16bAxeyo6ZbxXqS0Wm2xNAmsScN94864plW9yeQ6Kn7n7scxUBi2iQ6cwotlqaMwjJGE5mO0V5HN0cIrr0IdlBxFHCDS0cIhhYbbRBU5i1WLit4cQKmLtLR6swIx8V3Y5+KcCMnbzWx71PPZbqYQWTwQalqKZpaEQjl/01aaWqQqFq27Jp2xuI1unfppmz649n0/9d+CfrMYS66cJToCTbeZp0Eht8zgxhUHuE4ccfUeFd8TmamBsiw+MUQ+wE3NyTg849h796cjk08/XKHeyZUqj+WxQM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?R1FWRXFuV1FYRVVraW5zTE9uTG5xcUpTUllGaTlzR1p1Z0pNcTdKdlIrdXZL?=
 =?utf-8?B?ZU45V1d6ck9FOTcySGs2UXdISElveHBTYUlnY3czdjBZNmFHMnNoOVc0YzVI?=
 =?utf-8?B?ZjAvcmNaMHFSUmw3OS9VUjFnSGgyNHNYM1FJTitUWnUrNXU2LzFrQlJEbmNl?=
 =?utf-8?B?a0pPYk1tOE9UQ2F6aVZGbndTeFZRaDFrZGpjaHNGWTlFUFF6YlQvWlltV0dO?=
 =?utf-8?B?c1NCSHpRY0lGNkowTE41WE1BeHhUYlM1YThTWjRrTXVoeGhGa2ZvNmdzTkgx?=
 =?utf-8?B?ZWdYWGhnQk5wWUhoNmVJKzVaUThTQ3BuOEdtRlNpdENlMFZadnQvRW9ldEFE?=
 =?utf-8?B?LzRNaE9WanJxQmNwMmlrODNHMTZKaGR3OFJlNzNHYnJFeWp2UktZYko0dmJ1?=
 =?utf-8?B?NHJnMkFyY3VoK3htZXRleWdZNjdRdnhiejR1L1UzQWJkd2k4cjdvKy9hbHc0?=
 =?utf-8?B?NmRZdE0zTjA1anNBOGhlYnhQNWhUVmZrTWJuR3NPQmk0QitFcWN3MExkM0ti?=
 =?utf-8?B?b1QreCtSQWVqa3g1blVMQzVRQzVVYVRqaHc1R2p4SFlydWVkV3RqSHI5RGMv?=
 =?utf-8?B?NkEzMjVwajRxc3AzVTdWTUJPMnd3V0VOb2pYb2dvUExQZjREeEZMVWtINHVn?=
 =?utf-8?B?MlZndjNiSXMzcEFZMGllRjNDV2FFaUpiN28wQVVyWG1nQkx0N0owYU1iVHhw?=
 =?utf-8?B?OGk5cERPdW9rZDRFdzBBdlR1WHVjaEtXU1llTFJUVlZ3UWRWZEVjd3A3QUcw?=
 =?utf-8?B?Vno3b01MNFBuL0tuVGRPYUVhUG1tK0UyS2dvV2ZDemNwTE5QMkZJYmxNV2tJ?=
 =?utf-8?B?ZHFjQVhVUnhiRW84THREZEdWSlNtcUg5OXp2akhoUjUxWVc0SnVQbGk1UEho?=
 =?utf-8?B?VmNNSUVVbllXRVNZSUQwL042cDY2OTVsbmFUTVNTRFRtVHVISzdTdXBPd05w?=
 =?utf-8?B?bU9CbG9BTmQ2Z0E5M003dTluS2N3WFljUkJCc3VtZmduelJyUkxxUUwveER4?=
 =?utf-8?B?dU5YY1B1SUZVc3B4YVEzeTJTekhaQy9YbVZRWEtuRlhPbUZSNnB3Y3VjRE1s?=
 =?utf-8?B?cHNxaHlhcUN1eDZTeWNjUGw2NGtnOFhnWVF0cW0rM2pmOHNYYXBkbkhYYU03?=
 =?utf-8?B?VUJ2ZjhlOXpjM2VKSDl4dXB1NUJWUDJCTkx5aXdQNEphblNTdnVjcHg3T0tU?=
 =?utf-8?B?YTZHT3VjR044T05hV1ZiYUF1MjVLWVA4ejdsM3ZwbzZubThYbEw0TElleU9h?=
 =?utf-8?B?bFlTNytJNlJLK0ZZRlc0dnBTVU9HcmhWRk9GNnFod21ZelZGbHlGaURzMk9i?=
 =?utf-8?B?ZXVKazhzUnNmaC9FWVRyc2dHSjY5OTZTWWhEelZhK1BmWTFML3V1ck1LdEw4?=
 =?utf-8?B?OUdTNlpHdDVqcnlFTndVQmZZcWJJTEVpU3hrcUhMTS9TNnFVUEJCZ292Um9m?=
 =?utf-8?B?Ky9kU1dxbEFwTCtSOFdtR2ZQYzBkRzlzYk9zeXJVUE0vd3YxZjQ1N0dEOG1p?=
 =?utf-8?B?RTloSnowTGVSS2JQdTJDVXpHRHhlS0ZBNmI0K1ZHK3BWcHdUR2JuWUZBbHZZ?=
 =?utf-8?B?YW84RENla3IvNE43KzJNUnpMbnlwSk04RUk2S0hrd28vTERHZ29lNGFoNDg1?=
 =?utf-8?B?bEl6OUdpbmF0VHkxZjh1WVVLVUM1MTNPN1lCTEdVaGNmME84QnlPSDRLU29m?=
 =?utf-8?B?aEE0MnJDWVNjVC9jOHRpWFB0WitaaWdiQzEyOVBsWXowODhLSEp5MHROYk5L?=
 =?utf-8?B?bXRyeDBHYTdJUGFTMVM5VVYrd1gwYy90MSs1Q1Fwa1lrbXhiMWg1eGhLdnN2?=
 =?utf-8?B?OXF0TmlLS1RwRHVjdlBBTEJsaVFIVURCTjdYSDl1aGNjMkZKTFhYdHBxTDhC?=
 =?utf-8?B?a1J5ZENBMVR2aXNmNFFreE9tdCtyRVA2R0pzT1VCbkhCZ1JaR1dDRkxndHBB?=
 =?utf-8?B?VmQ3cG5vNXAyOVVBSkM4TExEdmp3UVFnVCtxSEZEcGVJdzQ4YmFWQkQ4ZGs1?=
 =?utf-8?B?QmdyYVJBWlE0MmhpcjBJeWYrOS9pVlNJUjYwS1p2MFVXTmxpVGpicWlucCtG?=
 =?utf-8?B?OWkzU3k3RElqdUpYazFrcWFQck9obk1ocW1QbjJVWjhOQmVuNXFuNjRSdUpp?=
 =?utf-8?B?RDlFc3VYbjR1Skxlazhqb20ya2xpNUlTSG42cndLZmVhOFhZRXJpVUZzSjEw?=
 =?utf-8?B?cnE2ME1MNnRiNGRYOEhyQUI2QURoN1Q3d0plUm1yMjVRSkdwV1lURlpOQWFp?=
 =?utf-8?B?SVpwNk9ZRm9xNUl3SkZpYi82Wml1c1JOSFZZYTR2RVExMmtmL2IxRVROb2hO?=
 =?utf-8?B?Wm5BcXYzZHRoMkNmbjRackF4RHRTMEk1MDJRMitTcmlkZXVFekVRWXYyUnBK?=
 =?utf-8?Q?BNURR7iLjNfldoKo=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10aa8a7-b41e-4c3e-1a17-08df04450941
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 14:11:06.5658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DgAvq+AJo/qGSAScdrfsPGhaK9YV/YRn3zA7YEmX981qMo9Oerf7WNI+J4vly6OLl/YmQ/EtYUZPlqKQ3x3lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7976

On 8/26/2026 6:20 PM, Frank Li wrote:
> On Wed, Aug 26, 2026 at 03:40:42PM +0200, Larisa Grigore wrote:
>>
>> The AMD Versal Gen 2 UFS platform driver carries local helpers to access
>> M-PHY control registers through the UniPro CREG interface.
>>
>> Move these helpers into the common Synopsys DWC layer as
>> ufshcd_dwc_phy_reg_read() and ufshcd_dwc_phy_reg_write(). This avoids code
>> duplication in DWC-based glue drivers and provides a single implementation
>> for future reuse.
> 
> Nit: add empty line between paragraph
> 
Thank you! I’ll address it in the next revision.

>> Dropped `static` from `phy_write_attrs` and `phy_read_attrs` since there
>> is no benefit in keeping them persistent.
>>
>> Update the AMD Versal2 glue driver to use the new ufshcd-dwc helpers.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
> 
> Reviewed-by: Frank Li <Frank.Li@nxp.com>
> 
>>   drivers/ufs/host/ufs-amd-versal2.c | 85 ++++++------------------------
>>   drivers/ufs/host/ufshcd-dwc.c      | 77 +++++++++++++++++++++++++++
>>   drivers/ufs/host/ufshcd-dwc.h      |  2 +
>>   3 files changed, 96 insertions(+), 68 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-amd-versal2.c b/drivers/ufs/host/ufs-amd-versal2.c
>> index 0d4d5e98ad65..c7da95999c85 100644
>> --- a/drivers/ufs/host/ufs-amd-versal2.c
>> +++ b/drivers/ufs/host/ufs-amd-versal2.c
>> @@ -43,57 +43,6 @@ struct ufs_versal2_host {
>>          u8 ctlecompval1;
>>   };
>>
>> -static int ufs_versal2_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
>> -{
>> -       static struct ufshcd_dme_attr_val phy_write_attrs[] = {
>> -               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
>> -               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> -       };
>> -
>> -       phy_write_attrs[0].mib_val = (u8)addr;
>> -       phy_write_attrs[1].mib_val = (u8)(addr >> 8);
>> -       phy_write_attrs[2].mib_val = (u8)val;
>> -       phy_write_attrs[3].mib_val = (u8)(val >> 8);
>> -
>> -       return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs, ARRAY_SIZE(phy_write_attrs));
>> -}
>> -
>> -static int ufs_versal2_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
>> -{
>> -       u32 mib_val;
>> -       int ret;
>> -       static struct ufshcd_dme_attr_val phy_read_attrs[] = {
>> -               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
>> -               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> -       };
>> -
>> -       phy_read_attrs[0].mib_val = (u8)addr;
>> -       phy_read_attrs[1].mib_val = (u8)(addr >> 8);
>> -
>> -       ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs, ARRAY_SIZE(phy_read_attrs));
>> -       if (ret)
>> -               return ret;
>> -
>> -       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
>> -       if (ret)
>> -               return ret;
>> -
>> -       *val = mib_val;
>> -       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
>> -       if (ret)
>> -               return ret;
>> -
>> -       *val |= (mib_val << 8);
>> -
>> -       return 0;
>> -}
>> -
>>   static int ufs_versal2_enable_phy(struct ufs_hba *hba)
>>   {
>>          u32 offset, reg;
>> @@ -162,64 +111,64 @@ static int ufs_versal2_setup_phy(struct ufs_hba *hba)
>>          u32 reg;
>>
>>          /* Bypass RX-AFE offset calibrations (ATT/CTLE) */
>> -       ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(0), &reg);
>> +       ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(0), &reg);
>>          if (ret)
>>                  return ret;
>>
>>          reg |= MPHY_FAST_RX_AFE_CAL;
>> -       ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(0), reg);
>> +       ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(0), reg);
>>          if (ret)
>>                  return ret;
>>
>> -       ret = ufs_versal2_phy_reg_read(hba, FAST_FLAGS(1), &reg);
>> +       ret = ufshcd_dwc_phy_reg_read(hba, FAST_FLAGS(1), &reg);
>>          if (ret)
>>                  return ret;
>>
>>          reg |= MPHY_FAST_RX_AFE_CAL;
>> -       ret = ufs_versal2_phy_reg_write(hba, FAST_FLAGS(1), reg);
>> +       ret = ufshcd_dwc_phy_reg_write(hba, FAST_FLAGS(1), reg);
>>          if (ret)
>>                  return ret;
>>
>>          /* Program ATT and CTLE compensation values */
>>          if (host->attcompval0) {
>> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
>> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(0), host->attcompval0);
>>                  if (ret)
>>                          return ret;
>>          }
>>
>>          if (host->attcompval1) {
>> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
>> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_ATT_IDAC(1), host->attcompval1);
>>                  if (ret)
>>                          return ret;
>>          }
>>
>>          if (host->ctlecompval0) {
>> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
>> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(0), host->ctlecompval0);
>>                  if (ret)
>>                          return ret;
>>          }
>>
>>          if (host->ctlecompval1) {
>> -               ret = ufs_versal2_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
>> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_AFE_CTLE_IDAC(1), host->ctlecompval1);
>>                  if (ret)
>>                          return ret;
>>          }
>>
>> -       ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
>> +       ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(0), &reg);
>>          if (ret)
>>                  return ret;
>>
>>          reg |= MPHY_FW_CALIB_CFG_VAL;
>> -       ret = ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
>> +       ret = ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(0), reg);
>>          if (ret)
>>                  return ret;
>>
>> -       ret = ufs_versal2_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
>> +       ret = ufshcd_dwc_phy_reg_read(hba, FW_CALIB_CCFG(1), &reg);
>>          if (ret)
>>                  return ret;
>>
>>          reg |= MPHY_FW_CALIB_CFG_VAL;
>> -       return ufs_versal2_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
>> +       return ufshcd_dwc_phy_reg_write(hba, FW_CALIB_CCFG(1), reg);
>>   }
>>
>>   static int ufs_versal2_phy_init(struct ufs_hba *hba)
>> @@ -406,7 +355,7 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>>
>>          for (lane = 0; lane < activelanes; lane++) {
>>                  time_left = TIMEOUT_MICROSEC;
>> -               ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>> +               ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>>                  if (ret)
>>                          return ret;
>>
>> @@ -416,12 +365,12 @@ static int ufs_versal2_phy_ratesel(struct ufs_hba *hba, u32 activelanes, u32 rx_
>>                  else
>>                          reg &= ~MPHY_RX_OVRD_VAL;
>>
>> -               ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>> +               ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>>                  if (ret)
>>                          return ret;
>>
>>                  do {
>> -                       ret = ufs_versal2_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
>> +                       ret = ufshcd_dwc_phy_reg_read(hba, RX_PCS_OUT(lane), &reg);
>>                          if (ret)
>>                                  return ret;
>>
>> @@ -483,12 +432,12 @@ static int ufs_versal2_pwr_change_notify(struct ufs_hba *hba, enum ufs_notify_ch
>>
>>                  /* Remove rx_req override */
>>                  for (lane = 0; lane < dev_req_params->lane_tx; lane++) {
>> -                       ret = ufs_versal2_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>> +                       ret = ufshcd_dwc_phy_reg_read(hba, RX_OVRD_IN_1(lane), &reg);
>>                          if (ret)
>>                                  return ret;
>>
>>                          reg &= ~MPHY_RX_OVRD_EN;
>> -                       ret = ufs_versal2_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>> +                       ret = ufshcd_dwc_phy_reg_write(hba, RX_OVRD_IN_1(lane), reg);
>>                          if (ret)
>>                                  return ret;
>>                  }
>> diff --git a/drivers/ufs/host/ufshcd-dwc.c b/drivers/ufs/host/ufshcd-dwc.c
>> index 21b1cf912dcc..45920793d1a8 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.c
>> +++ b/drivers/ufs/host/ufshcd-dwc.c
>> @@ -141,6 +141,83 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
>>   }
>>   EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
>>
>> +/**
>> + * ufshcd_dwc_phy_reg_write - Write a DWC M-PHY CREG register
>> + * @hba: private structure pointer
>> + * @addr: M-PHY CREG register address
>> + * @val: value to write
>> + *
>> + * Write a 16-bit M-PHY CREG register through the Synopsys DesignWare
>> + * UniPro indirect register access interface.
>> + *
>> + * Return: 0 on success, non-zero value on failure.
>> + */
>> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val)
>> +{
>> +       struct ufshcd_dme_attr_val phy_write_attrs[] = {
>> +               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(CBCREGWRLSB), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(CBCREGWRMSB), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(CBCREGRDWRSEL), 1, DME_LOCAL },
>> +               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> +       };
>> +
>> +       phy_write_attrs[0].mib_val = (u8)addr;
>> +       phy_write_attrs[1].mib_val = (u8)(addr >> 8);
>> +       phy_write_attrs[2].mib_val = (u8)val;
>> +       phy_write_attrs[3].mib_val = (u8)(val >> 8);
>> +
>> +       return ufshcd_dwc_dme_set_attrs(hba, phy_write_attrs,
>> +                                       ARRAY_SIZE(phy_write_attrs));
>> +}
>> +EXPORT_SYMBOL(ufshcd_dwc_phy_reg_write);
>> +
>> +/**
>> + * ufshcd_dwc_phy_reg_read - Read a DWC M-PHY CREG register
>> + * @hba: private structure pointer
>> + * @addr: M-PHY CREG register address
>> + * @val: pointer where the read value is stored
>> + *
>> + * Read a 16-bit M-PHY CREG register through the Synopsys DesignWare
>> + * UniPro indirect register access interface.
>> + *
>> + * Return: 0 on success, non-zero value on failure.
>> + */
>> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val)
>> +{
>> +       struct ufshcd_dme_attr_val phy_read_attrs[] = {
>> +               { UIC_ARG_MIB(CBCREGADDRLSB), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(CBCREGADDRMSB), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(CBCREGRDWRSEL), 0, DME_LOCAL },
>> +               { UIC_ARG_MIB(VS_MPHYCFGUPDT), 1, DME_LOCAL }
>> +       };
>> +       u32 mib_val;
>> +       int ret;
>> +
>> +       phy_read_attrs[0].mib_val = (u8)addr;
>> +       phy_read_attrs[1].mib_val = (u8)(addr >> 8);
>> +
>> +       ret = ufshcd_dwc_dme_set_attrs(hba, phy_read_attrs,
>> +                                      ARRAY_SIZE(phy_read_attrs));
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDLSB), &mib_val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       *val = mib_val;
>> +       ret = ufshcd_dme_get(hba, UIC_ARG_MIB(CBCREGRDMSB), &mib_val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       *val |= (mib_val << 8);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(ufshcd_dwc_phy_reg_read);
>> +
>>   MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
>>   MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
>>   MODULE_LICENSE("Dual BSD/GPL");
>> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
>> index 0406f2bb576b..d8673cd54d4c 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.h
>> +++ b/drivers/ufs/host/ufshcd-dwc.h
>> @@ -45,4 +45,6 @@ int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
>>                                          enum ufs_notify_change_status status);
>>   int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
>>                                  const struct ufshcd_dme_attr_val *v, int n);
>> +int ufshcd_dwc_phy_reg_write(struct ufs_hba *hba, u32 addr, u32 val);
>> +int ufshcd_dwc_phy_reg_read(struct ufs_hba *hba, u32 addr, u32 *val);
>>   #endif /* End of Header */
>> --
>> 2.43.0
>>
>>

