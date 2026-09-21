Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010032.outbound.protection.outlook.com [52.101.69.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35FA30DEA6;
	Mon, 21 Sep 2026 08:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979613; cv=fail; b=CAdU/8DASm+VdTDj4Rscai8yN8WS+1pRbI3cd8z8bFl2Hw3j/piEOh/gIGb6yZ10gJA36N3JdLZJFF6KkS0FZMiiD5/CpgnZadgXy5+Ydj3mg4VDHyWUzvVWiewKiSlcIotkZi10/e4cRd+z5sAVhp0Y4qmAmpl9+r+oImgwsTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979613; c=relaxed/simple;
	bh=D63pqlbYkIYfhgVjBu8/1d2rAWZgekmbCZo1+8RdWNI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NCGH3gBRCQ330wHp/SDwAQhM3kxwYCIm8CS3sgcq1r+JeAyNwRphj+unLqM4lfg4mBM68YecXLytXnZ2GyOrpIWbPwdTDax1/oYuqPTEj3a31NUVqqieFBBe/XkMv1tXc/pQgaH/L15jnbmJx0TrB47c5gTeWmYaEKtu3rq12Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=NxLicQA5; arc=fail smtp.client-ip=52.101.69.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="NxLicQA5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ova6DgxFbNvSuPtscY5BcAe59oIql+DLbD7ZaHAn7XGxJsIJ8w0/R7sGkR8XjCl4iGK84tsz4pdBlC1NVoDxTVvllgUvCifUq71s1P6UR54+3SIpPBSApW9soFqvvGmlNyKrOL1vsoK61vQO/jnZSufaOPnOcns0TYI+lt3Y73kv/q+/Jj5GQs68GA/CZJImGaWKolil5sUOpzKkIII0gQkIS642/vX4SNmX25LnEJjJxfVC4QpMF/hAu6lXLbcVVnhPYUSOie6JShcbNs3zBGi5C8AKW5/ZElXeh7wOCudx63y7p+xp7UJIJPPGwzGiSwt1zCAzSK0n5Pi6U7On9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQI63sxQyX4XFVdl1P28FxnHQH2ntKLUS13sU0rADiE=;
 b=FbjSiGKq6va96QpNBf3NBlJyRQjM9BOQpAkznNSy6wfMXTzla4wtb64RDmFOq+U5GcA+CpaV5FVWp4qpCzg8TuRiE4e1J65w5AMP2GLv47qSIHmlTIlgpUxgSP1RE0nLatoqgsjL4IZNLog1RyGCs4PA+2FByT5EE4cOsQ0oojaJCgopPpoNWL4uzhZ/FJKRARS61eFHq+1K/RBfA3Du0iWq/t78O918NlnVwjFAMUkU2SxCXlhOhkF+R6xuHtUgeN5V/KlpdHeKsUmO6QrcRk18z8R0LDv+7Z9kty7Fx5euwihEi6/hTWHHLR9tdrlf6CUAxLF5jQtvuWLw1UCWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQI63sxQyX4XFVdl1P28FxnHQH2ntKLUS13sU0rADiE=;
 b=NxLicQA5VL4Ro3+tUq9z09Udjn2a0RN0L1TPJTCwZwtyITyu3fGGdxtqrVUGc5RYl4ipKeNQ1Uca0TvWcrMvt8GVQgI3dQ/hoYyWnUbIxiXIB4NcttDlwN0XUUe6EBk9S43DrfbCQl/zd8n4MoPGRSctaAL3KV1iRuHQ0MoEJVn93/xJt4VpohBcpn6wd2iWYhYtF/zhaSzXxZNsyAe8Uej7bQPvBwMf0daoIHt719Ox818CXupDk00mO+bNMj87QRK0u8ELRIgNGdGO9cRo4r59YeOL1hYTNh8IyJYuoTMSZuGkmYKVhnIV+FTAXqfJRzmU5VDthZjb5UMJrrS/Iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by BR2PR04MB612324.eurprd04.prod.outlook.com
 (2603:10a6:2c8:5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Mon, 21 Sep
 2026 08:33:25 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:33:25 +0000
Message-ID: <f9eb04a7-abba-4a7b-aaa2-f7f523e4867e@oss.nxp.com>
Date: Mon, 21 Sep 2026 11:33:21 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/11] scsi: ufs: Add NXP S32N79 UFS host controller
 driver
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
References: <20260917091555.1443076-1-larisa.grigore@oss.nxp.com>
 <20260917091555.1443076-9-larisa.grigore@oss.nxp.com>
 <aqwS3-7QubGloVm8@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <aqwS3-7QubGloVm8@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::10) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|BR2PR04MB612324:EE_
X-MS-Office365-Filtering-Correlation-Id: aed1c029-7d01-4044-eded-08df17bb00ff
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|23010399003|19092799006|366016|1800799024|376014|4143699003|10067099003|11063799006|56012099006|3023799007|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
 5DJmDcWIm7Ann3kg8b7y9csstyIqHygzFhr71Q6uAJvcr9tNdfOvJ+ZrkMLix/Jifh2UfC9IcBQK2m2B0fkUdOUIsUZh6nyqFXGktErdXJ764v0nvedpo7gBPXacyluoJXMpRVYxaw3RyRp2Dz71PIdp+yM5sPJRFVS86ZCxdoi1g19hHgP4SS8ZhSRBcYPrBKAjIZqyVBXu8AofQeMuu84jPgwt2C9hchkRACLf9hmjArYt5XKZuIgObBRxPvN/L2ZpEC1A0CrW/Fjv33U3qT0ApDUUqW8s1N4y0/DjDVpSNnNhbujfA/TcUIuiwmk0KnHmyvXX/iZ/i0laOsXC7+MGtZRI5NtW2afcYho6oX8Lfic5yolgkkMFfZill2L0NL2FjEBrHKlKSRZ+zeYDHRA5VPeelPovjHotcvYscmNHo4GL6TFskxSEWnGekOfehiXdpj+XieK1k9upfbQQY6nER5oactjL0wtQTy+yWndhg6mL0emxfyhI7xZqktRwZ+DCKjqyQ3x8qzAmEFGvOH0+T248udFn7pEsyTMFtHe9ce1cfUgCbHrsCUxZYkC6AxbAqJNlw6GkglwhJDuc496zxlleDcsFaxSitGNPR1gxB+ijhcqWR4CN2/spV85mIaPVHs4dHdYhh8gZyVN3JEq76EG+CK4Twu+dMRDX52M=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(19092799006)(366016)(1800799024)(376014)(4143699003)(10067099003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZGRNcDBDWDZYNjE3NkVkRDVNdW8vSVZOM3VLTXVseTJ2M3ArZUhYUzB3WEFQ?=
 =?utf-8?B?Vmt6Z0FVL2cwcEVuc1pxcis0dVNaVUN1VnBpWExGNVRZVUVxZDduZ0llZzBo?=
 =?utf-8?B?WmtINnBEdnNFRmdKam9NZWQ2UDRybEo2bWNjd0EvZlI3ODZIcXpTVVZtaG1I?=
 =?utf-8?B?VXVvdjJHWWxhNklBVEJId1o1Q0pGakN1VXA0V0owVGF5UkEzdUFVTHdUOXk5?=
 =?utf-8?B?RXo4UkZGZ1F4blNsZGo4OWZyeTBkazRBSk9xbUV0YnVESThKRmJFcFVPWkdp?=
 =?utf-8?B?Y3MwSjJ2WXd2YnZPVzJOeHZKU0hyU21xUmxvbDk2ZlZMUEcybVVEdUpwTlow?=
 =?utf-8?B?Vk9CUW9UUCtVbTJhVHRZTE1rUWFJeVRjM0N0QkdpOWtadnUwMlhYbUZCcWlG?=
 =?utf-8?B?NTA2RHd6eG03eHZDUkZOVTF3cU0vL3NzUDAwY1ZJWTIwU2V1RVFjVE15aW9v?=
 =?utf-8?B?c1R0MWkwa0VveEt6YTRrQTg0ZzgvbWYvSXRsUjdjNnAzM05OaXh6bnZIbnZT?=
 =?utf-8?B?ckNCL282VkZ6aTBseTlzbDZjMTBZUjZkdDB0cS9iZDNVNnFyZ29GeFlRL0dj?=
 =?utf-8?B?K3ExbWtibjJVc01DcG9LT2JQcWtWZkcxdzVHY0Z0Yk83Y3V6eXBRQUUzUXcx?=
 =?utf-8?B?cXp3SUp2MzY1d1YxeDFnSjNNczR1S0VaZHpOS1pBdzZKSGxpY2ZtbUU4SWdQ?=
 =?utf-8?B?eUdjOVBFMUs2ekQ4UXZGR3c1V25FdDYydWhFaXZiK0NWZnlRQXR0SlNZT1VZ?=
 =?utf-8?B?VzlmdjhPdElDN1F1UnZmWDVtRWtORjU0VjRBTERORndlVnA2c0UzczErWUt6?=
 =?utf-8?B?aFBxUEtDcVBSdXY1bFVmQ3lQeVBYcmxTaVFzOGROTi8rTkp1cGFiUWVabmFS?=
 =?utf-8?B?UEJBL1BzUUtLU29LMlduckdIalBDMUU2K1JwTTNwcFdwbnNqNElmK3JYa1Zi?=
 =?utf-8?B?UmMramZWeDBNZkRmTHJndEpGMkJPNTk3eEFaa2ZLU0JGcEx0SHF4R3ppeWdU?=
 =?utf-8?B?ZWxCNEQ5Mnl5WDdPRG41bzlFNFhkNHQxaWtRdFVyS0g0aTEybDRxcVZtWHV6?=
 =?utf-8?B?aVMrR0RTT3JwWkNRMlRiVUV6Qmw0b1duOCtWVndMdTBxMWNPQVAxVlBQNHZP?=
 =?utf-8?B?N1BiUVU0ZUtIdzM0NXRsMmlCbEZ2RDVWN0VDbXBsMUE3YUk1MHp1dUpGSWFt?=
 =?utf-8?B?SWFVWklJdmFaS3k5clVxVFhTZTRwcTJLNjN3SG1aSGE0UUF5NmJMV1VkSk1Y?=
 =?utf-8?B?WkJOZXZFcTRDS1Mzc2haSTFUWFdpZGdZZkMvSVlQNjA5bjdlS2lmais2SUU1?=
 =?utf-8?B?U1dOUHlFQ2FYaUVRYVZBRm1MTUYxNmhJL1RyakR6SVNINm9KVmk1c2hvTnNq?=
 =?utf-8?B?V1haeDVBS3BhTHJOTXd3eEJaTEpQNTVIM3d1bUIxaVJHMkp1eDQxNFk0TEJz?=
 =?utf-8?B?ZjF3QXJMclpmQkpwVDVQUHlEV01KNU5ORXFJbGdxTmowK1loaVNhUldmV2k2?=
 =?utf-8?B?eTc5aXVSUzJiYmpRUXRsbU9GbVA1dkpxTzd6aFBEOFROUzFTczJnc2dTcWla?=
 =?utf-8?B?WGN4c2pmbTM2d3daWnN4OTFBK1MvT2o4Sk1KeFU1V0pDS2dNc2h6RzdFVDFl?=
 =?utf-8?B?K1BLaUwxaFp0VGhIa1JTQlBKNDN5bXF6TEpDRkFCNys2K3ZqTzdrcVRiaWp0?=
 =?utf-8?B?UWxSQTFwT0cvSmJCR09WQ0Jya3ZFcVAxR1N5RVBpczQrc2ZPTnJ2NnhEcUEy?=
 =?utf-8?B?RkVCVkFKcUQ4UzM2STVPY0hXeU9xcFBhYVoxWGJlaEkwT2NaSVpOUlBzKzB5?=
 =?utf-8?B?UlJzeFdReVJMQmRoaFl0SDAyUUN1V3c5MWh0T3dTcmpTaVI0b1JXNUF0NnFW?=
 =?utf-8?B?eG9FNFdiNnEySzVKeVJiZGdwSUdZcnZySjk3MkExWDBnWmRFbGdwdytqV0RB?=
 =?utf-8?B?V2xuOGYvTUcrZXMyWTdHUVJTOGczU01sTVBPbGdKek9tMTI5bWFwVnBISjhr?=
 =?utf-8?B?WmJSZmNqeDZkQU9OcEhtSlgvN0o2elN3OUNVSTREa25BYjE3SFFSb3JnV2dp?=
 =?utf-8?B?N0VxU00vdWxLT1FMaUVPSkRLOTZ3cG02MGVvRkR4ZEVzQk4zd1NSZThhNDZD?=
 =?utf-8?B?Z0hBMm11ZFRXdDl4SldjK2ZVK3JLZ3hZREM1emlWUWp1Z2N0ejdnVGZPZDJO?=
 =?utf-8?B?WklwRU5WOUZMU2ZmUC9wNVBodmMveEpvd1k5NVYyd0E5MHNMOXdKS3Q5WEZO?=
 =?utf-8?B?LzBtc2Ftd0kzZUU0VzkybFVqd0RKMDBQZkJyZ3g1dDFYQkNpbDRYSDJnZzNG?=
 =?utf-8?B?bXlpZUdhQkR0YWpiOTlsNE9GeitURjNSV3U2SHExMmNDa2p5TE1wdz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed1c029-7d01-4044-eded-08df17bb00ff
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 08:33:25.4448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5hZUDRl2MbllsaGDMqbPZBZ8hzQIdQX3Qr1b/wllLORkRdNCTaoKL03lhfdpPFagG5HXIAmazPa+FqQMdl/Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BR2PR04MB612324

On 9/17/2026 7:18 PM, Frank Li wrote:
> On Thu, Sep 17, 2026 at 11:15:52AM +0200, Larisa Grigore wrote:
>> Add support for the UFS host controller on the NXP S32N79 SoC, built on
>> the Synopsys DesignWare (DWC) UFS architecture, using the UFSHCD DWC and
>> UFSHCD platform glue.
>>
>> This controller requires S32N79-specific initialization prior to
>> UIC_LINKSTARTUP, including:
>>    - programming SCM.ONE_US_TICK and HC.HCLKDIV based on the core clock,
>>    - applying the vendor-defined M-PHY calibration sequence, and
>>    - performing post-link calibration steps needed for HS operation.
>>
>> The M-PHY supports several boot modes for loading its firmware. Only the
>> mode where the firmware runs from the internal ROM is supported for now.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   drivers/ufs/host/Kconfig         |  12 +
>>   drivers/ufs/host/Makefile        |   1 +
>>   drivers/ufs/host/ufs-nxp-s32n7.c | 543 +++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufshcd-dwc.h    |  14 +-
>>   drivers/ufs/host/ufshci-dwc.h    |   6 +
>>   5 files changed, 574 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c
>>
>> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
>> index ff170c0b6da0..e8ee7dd05f1a 100644
>> --- a/drivers/ufs/host/Kconfig
>> +++ b/drivers/ufs/host/Kconfig
>> @@ -168,3 +168,15 @@ config SCSI_UFS_AMD_VERSAL2
>>
>>   	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
>>   	  If unsure, say N.
>> +
>> +config SCSI_UFS_S32N7
>> +	tristate "NXP S32N7 platform driver"
>> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_S32 || COMPILE_TEST)
>> +	help
>> +	  This selects the S32N7 specific additions on top of the UFSHCD DWC
>> +	  and UFSHCD platform driver. UFS host on S32N79 needs some vendor
>> +	  specific configurations like PHY and vendor specific register accesses
>> +	  before accessing the hardware.
>> +
>> +	  Select this if you have UFS controller on an S32N7 based board.
>> +	  If unsure, say N.
>> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
>> index 7d8db67eb23c..a2f4a1d0b3ae 100644
>> --- a/drivers/ufs/host/Makefile
>> +++ b/drivers/ufs/host/Makefile
>> @@ -4,6 +4,7 @@ CONTEXT_ANALYSIS := y
>>
>>   obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
>>   obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
>> +obj-$(CONFIG_SCSI_UFS_S32N7) += ufs-nxp-s32n7.o ufshcd-dwc.o
> 
> Leave it to ufs maintainer, it should existing problem.
> 
> if CONFIG_SCSI_UFS_AMD_VERSAL2 as module, and CONFIG_SCSI_UFS_S32N7 as
> build-in,
> 
> ufshcd-dwc.o will link twice. I am not sure kernel can handle by duplicate
> symbal, one in kernel and one in module.
>
I'll leave it to the UFS maintainers to decide whether any restructuring 
of the shared DWC objects is needed.

> 
>>   obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>>   obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>>   obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
>> diff --git a/drivers/ufs/host/ufs-nxp-s32n7.c b/drivers/ufs/host/ufs-nxp-s32n7.c
>> new file mode 100644
>> index 000000000000..4f9a00156202
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-nxp-s32n7.c
>> @@ -0,0 +1,543 @@
>> +// SPDX-License-Identifier: (GPL-2.0-or-later OR BSD-3-Clause)
>> +/*
>> + * Copyright 2026 NXP
>> + *
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/device.h>
>> +#include <linux/iopoll.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm.h>
>> +
>> +#include "ufshcd-pltfrm.h"
>> +#include "ufshcd-dwc.h"
>> +#include "ufshci-dwc.h"
>> +
>> +/* SCM Register Offsets. */
>> +#define SCM_ONE_US_TICK			0x2CU
>> +#define SCM_STATUS			0x30
>> +
>> +/* SCM_ONE_US_TICK Register. */
>> +#define SCM_ONE_US_TICK_MASK		GENMASK(8, 0)
>> +
>> +/* SCM_MPHY_RAM_CONFIG_STATUS Register Fields. */
>> +#define SCM_STATUS_PHY_RESET_MASK		BIT(0)
>> +#define SCM_STATUS_SRAM_BYPASS_MASK		BIT(1)
>> +#define SCM_STATUS_SRAM_INIT_DONE_MASK		BIT(16)
>> +
>> +#define SCM_STATUS_PHY_RESET(val)		\
>> +	FIELD_PREP(SCM_STATUS_PHY_RESET_MASK, val)
>> +
>> +#define SCM_STATUS_SRAM_BYPASS(val)		\
>> +	FIELD_PREP(SCM_STATUS_SRAM_BYPASS_MASK, val)
>> +
>> +/* Timeout values. */
>> +#define CFG_MPHY_INIT_TIMEOUT_VALUE_US	3000000
> 
> suggest add comments, where 300000 from? standard spec or engineer choice,
> in case need modify in future. the same for other timeout values.
> 
Thank you! I will add comments documenting the origin of these timeout 
values.

>> +
>> +/* Clock validation limits. */
>> +#define MAX_VALID_ONE_US_TICK		SCM_ONE_US_TICK_MASK
>> +
>> +/* CPort definitions */
>> +#define CPORT_0				0
>> +
>> +/* Driver-defined timeout for completing a Hibern8 transition. */
>> +#define HBRN8_POLL_TOUT_MS      1000
>> +
>> +/**
>> + * struct s32n7_phy_reg - PHY CR (config-register) write entry
>> + * @reg: Register offset/address
>> + * @val: Value to write
>> + */
>> +struct s32n7_phy_reg {
>> +	u32 reg;
>> +	u32 val;
>> +};
>> +
>> +/**
>> + * struct s32n7_soc_data - SoC-specific configuration data
>> + * @vops: UFS host controller variant operations
>> + * @reset_config: MPHY reset DME attributes (programmed while PHY held in reset)
>> + * @reset_config_count: number of entries in @reset_config
>> + * @calib_mphy_disabled: CR calibration writes performed while the MPHY is disabled
>> + * @calib_mphy_disabled_count: number of entries in @calib_mphy_disabled
>> + * @calib_mphy_enabled: CR calibration writes performed while the MPHY is enabled
>> + * @calib_mphy_enabled_count: number of entries in @calib_mphy_enabled
>> + */
>> +struct s32n7_soc_data {
>> +	const struct ufs_hba_variant_ops *vops;
>> +	const struct ufshcd_dme_attr_val *reset_config;
>> +	size_t reset_config_count;
>> +	const struct s32n7_phy_reg *calib_mphy_disabled;
>> +	size_t calib_mphy_disabled_count;
>> +	const struct s32n7_phy_reg *calib_mphy_enabled;
>> +	size_t calib_mphy_enabled_count;
>> +};
>> +
>> +/**
>> + * struct s32n7_ufs - S32N7 UFS host controller data
>> + * @hba: UFS host controller instance
>> + * @reg_scm: SCM register base address
>> + * @core_clk: core reference clock used to derive ONE_US_TICK/HCLKDIV
>> + * @soc_data: SoC-specific configuration data
>> + */
>> +struct s32n7_ufs {
>> +	struct ufs_hba *hba;
>> +	void __iomem *reg_scm;
>> +	struct clk *core_clk;
>> +	const struct s32n7_soc_data *soc_data;
>> +};
>> +
>> +/**
>> + * ufs_s32n7_phy_write_sequence - Write a sequence of PHY registers
>> + * @hba: UFS host controller instance
>> + * @cfg: Array of register configurations
>> + * @count: Number of entries in the array
>> + *
>> + * Return: 0 on success, error code on failure
>> + */
>> +static int ufs_s32n7_phy_write_sequence(struct ufs_hba *hba,
>> +				       const struct s32n7_phy_reg *cfg,
>> +				       size_t count)
>> +{
>> +	int ret;
>> +	size_t i;
>> +
>> +	for (i = 0; i < count; i++) {
>> +		ret = ufshcd_dwc_phy_reg_write(hba, cfg[i].reg, cfg[i].val);
>> +		if (ret) {
>> +			dev_err(hba->dev,
>> +				"Failed to write PHY reg 0x%x = 0x%x (step %zu)\n",
>> +				cfg[i].reg, cfg[i].val, i);
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static unsigned long ufs_s32n7_calculate_us_tick(unsigned long clk_rate)
>> +{
>> +	return clk_rate / USEC_PER_SEC;
> 
> div64?
> 
clk_get_rate() returns an unsigned long, which is also the type used for 
clk_rate here. Since the calculation does not involve a u64 value, I 
believe a regular division should be sufficient. Do you see a reason to 
use div_u64() here?

>> +}
>> +
>> +static int ufs_s32n7_configure_clocks(struct ufs_hba *hba)
>> +{
>> +	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
>> +	struct device *dev = hba->dev;
>> +	unsigned long clk_rate = 0;
>> +	unsigned long one_us_tick;
>> +
>> +	clk_rate = clk_get_rate(ufs->core_clk);
>> +	if (!clk_rate) {
>> +		dev_err(dev, "Failed to get valid clock rate.\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	one_us_tick = ufs_s32n7_calculate_us_tick(clk_rate);
>> +	if (one_us_tick == 0 || one_us_tick > MAX_VALID_ONE_US_TICK) {
>> +		dev_err(dev, "Invalid one_us_tick value: %lu (clk_rate: %lu Hz).\n",
>> +			one_us_tick, clk_rate);
>> +		return -EINVAL;
>> +	}
>> +
>> +	dev_dbg(dev, "Core clock rate: %lu Hz, one_us_tick = %lu.\n",
>> +		 clk_rate, one_us_tick);
>> +
>> +	/*
>> +	 * Configure the micro-second tick rate generator based on core
>> +	 * clock rate.
>> +	 */
>> +	writel(one_us_tick, ufs->reg_scm + SCM_ONE_US_TICK);
>> +	ufshcd_dwc_program_clk_div(hba, one_us_tick);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ufs_s32n7_hce_enable_notify(struct ufs_hba *hba,
>> +				      enum ufs_notify_change_status status)
>> +{
>> +	u32 reg;
>> +
>> +	if (status != POST_CHANGE)
>> +		return 0;
>> +
>> +	/*
>> +	 * Clear the DWC low-power gating (BUSTHRTL) so a doorbell write can
>> +	 * wake the link out of hibernate. LP_PGE (generic low-power) and
>> +	 * LP_AH8_PGE (Auto-Hibern8) both reset to 1.
>> +	 */
>> +	reg = ufshcd_readl(hba, DWC_UFS_REG_BUSTHRTL);
>> +	reg &= ~(DWC_UFS_BUSTHRTL_LP_PGE | DWC_UFS_BUSTHRTL_LP_AH8_PGE);
>> +	ufshcd_writel(hba, reg, DWC_UFS_REG_BUSTHRTL);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ufs_s32n7_phy_initial_calib(struct ufs_hba *hba)
>> +{
>> +	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
>> +	int ret;
>> +
>> +	/* Calibrations that must run while the MPHY is disabled. */
>> +	ret = ufs_s32n7_phy_write_sequence(hba, ufs->soc_data->calib_mphy_disabled,
>> +					  ufs->soc_data->calib_mphy_disabled_count);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYDISABLE, 0), 0x0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Calibrations that must run while the MPHY is enabled. */
>> +	ret = ufs_s32n7_phy_write_sequence(hba, ufs->soc_data->calib_mphy_enabled,
>> +					  ufs->soc_data->calib_mphy_enabled_count);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +}
>> +
>> +static int ufs_s32n7_link_startup_pre_change(struct ufs_hba *hba)
>> +{
>> +	struct s32n7_ufs *ufs = ufshcd_get_variant(hba);
>> +	struct device *dev = hba->dev;
>> +	int ret;
>> +	u32 reg;
>> +
>> +	ret = ufs_s32n7_configure_clocks(hba);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Reset SCM.MPHY_RAM_CONFIG_STATUS to default value; keep MPHY in reset. */
>> +	writel(SCM_STATUS_PHY_RESET(1), ufs->reg_scm + SCM_STATUS);
>> +
>> +	/*
>> +	 * The M-PHY firmware runs from the internal ROM:
>> +	 *  MPHY_RAM_CONFIG_STATUS.SRAM_BYPASS = 1
>> +	 *  MPHY_RAM_CONFIG_STATUS.SRAM_EXT_LD_DONE = 0
>> +	 */
>> +	writel(SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1),
>> +	       ufs->reg_scm + SCM_STATUS);
>> +
>> +	/* MPHY reset configuration: vendor attributes set while PHY in reset. */
>> +	ret = ufshcd_dwc_dme_set_attrs(hba, ufs->soc_data->reset_config,
>> +				       ufs->soc_data->reset_config_count);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Release PHY_RESET. */
>> +	writel(readl(ufs->reg_scm + SCM_STATUS) & ~SCM_STATUS_PHY_RESET_MASK,
>> +	       ufs->reg_scm + SCM_STATUS);
>> +
>> +	/* Wait until SRAM_INIT_DONE = 1. */
>> +	ret = readl_poll_timeout(ufs->reg_scm + SCM_STATUS, reg,
>> +			reg & SCM_STATUS_SRAM_INIT_DONE_MASK,
>> +			1000, CFG_MPHY_INIT_TIMEOUT_VALUE_US);
>> +	if (ret) {
>> +		dev_err(dev, "UFS MPHY init not done!\n");
>> +		return ret;
>> +	}
>> +
>> +	/* Start of initial calibration */
>> +	ret = ufs_s32n7_phy_initial_calib(hba);
>> +	if (ret) {
>> +		dev_err(dev, "UFS MPHY initial calibration failed!\n");
>> +		return ret;
>> +	}
>> +
>> +	/* End of Gear1 settings */
>> +
>> +	return ufshcd_dme_check_tx_hibern8(hba, hba->lanes_per_direction,
>> +					   HBRN8_POLL_TOUT_MS);
>> +}
>> +
>> +static int ufs_s32n7_link_startup_post_change(struct ufs_hba *hba)
>> +{
>> +	static const struct ufshcd_dme_attr_val cport_setup[] = {
>> +		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
>> +				CPORT_IDLE, DME_LOCAL },
>> +		{ UIC_ARG_MIB_SEL(T_CPORTFLAGS, CPORT_0),
>> +				CPORT_DEF_FLAGS, DME_LOCAL },
>> +		{ UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0),
>> +				CPORT_CONNECTED, DME_LOCAL },
>> +	};
>> +	unsigned int data = 0;
>> +	int ret;
>> +
>> +	/* Network layer: set Local DeviceID. */
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Set Connection State to IDLE (it allows CPort Attributes to be set). */
>> +	ret = ufshcd_dwc_dme_set_attrs(hba, cport_setup, ARRAY_SIZE(cport_setup));
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, CPORT_0), &data);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (data != CPORT_CONNECTED)
>> +		return -EIO;
>> +
>> +	return 0;
>> +}
>> +
>> +static int ufs_s32n7_link_startup_notify(struct ufs_hba *hba,
>> +			     enum ufs_notify_change_status status)
>> +{
>> +	int err;
>> +
>> +	if (status == PRE_CHANGE) {
>> +		err = ufs_s32n7_link_startup_pre_change(hba);
>> +		if (err) {
>> +			dev_err(hba->dev, "MPHY setup failed (%d).\n", err);
>> +			return err;
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	/* POST_CHANGE */
>> +	err = ufshcd_dwc_link_is_up(hba);
>> +	if (err) {
>> +		dev_err(hba->dev, "Link is not up.\n");
>> +		return err;
>> +	}
>> +
>> +	err = ufs_s32n7_link_startup_post_change(hba);
>> +	if (err)
>> +		dev_err(hba->dev, "Connection setup failed (%d).\n", err);
>> +
>> +	return err;
>> +}
>> +
>> +static int ufs_s32n7_pwr_change_pre_change(struct ufs_hba *hba,
>> +					  const struct ufs_pa_layer_attr *pwr)
>> +{
>> +	/*
>> +	 * RX rate-select override sequence: assert the override, then deassert
>> +	 * the value, then drop the override enable so normal operation resumes.
>> +	 */
>> +	static const struct s32n7_phy_reg pwr_change_phy_regs[] = {
>> +		{ RX_OVRD_IN_1(0), 0xc },
>> +		{ RX_OVRD_IN_1(1), 0xc },
>> +		{ RX_OVRD_IN_1(0), 0x8 },
>> +		{ RX_OVRD_IN_1(1), 0x8 },
>> +		{ RX_OVRD_IN_1(0), 0x0 },
>> +		{ RX_OVRD_IN_1(1), 0x0 },
>> +	};
>> +	u32 rate;
>> +	int ret;
>> +
>> +	/* Rate change only applies to the HS power modes. */
>> +	if (!ufshcd_is_hs_mode(pwr))
>> +		return 0;
>> +
>> +	/*
>> +	 * Select the M-PHY rate (rate series) that matches the mode the core
>> +	 * has negotiated with the device.
>> +	 */
>> +	rate = (pwr->hs_rate == PA_HS_MODE_B) ? CB_RATE_B : CB_RATE_A;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(CBRATESEL, 0), rate);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(VS_MPHYCFGUPDT, 0), 0x1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Apply the RX rate-select override now that the target rate is set. */
>> +	return ufs_s32n7_phy_write_sequence(hba, pwr_change_phy_regs,
>> +					   ARRAY_SIZE(pwr_change_phy_regs));
>> +}
>> +
>> +static int ufs_s32n7_pwr_change_notify(struct ufs_hba *hba,
>> +				      enum ufs_notify_change_status status,
>> +				      struct ufs_pa_layer_attr *pwr)
>> +{
>> +	int err = 0;
>> +
>> +	if (status == PRE_CHANGE) {
>> +		err = ufs_s32n7_pwr_change_pre_change(hba, pwr);
>> +		if (err)
>> +			dev_err(hba->dev, "Power mode pre-change failed (%d).\n",
>> +				err);
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static int ufs_s32n7_init(struct ufs_hba *hba)
>> +{
>> +	struct device *dev = hba->dev;
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct s32n7_ufs *ufs;
>> +
>> +	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
>> +	if (!ufs)
>> +		return -ENOMEM;
>> +
>> +	ufs->hba = hba;
>> +	ufs->soc_data = device_get_match_data(dev);
>> +	if (!ufs->soc_data)
>> +		return -ENODEV;
>> +
>> +	hba->quirks |= UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE;
>> +	hba->spm_lvl = UFS_PM_LVL_5;
>> +
>> +	ufs->reg_scm = devm_platform_ioremap_resource_byname(pdev, "scm");
>> +	if (IS_ERR(ufs->reg_scm))
>> +		return dev_err_probe(dev, PTR_ERR(ufs->reg_scm),
>> +				     "ioremap failed for SCM registers.\n");
>> +
>> +	/*
>> +	 * The core reference clock is not managed by the UFS core (the DT node
>> +	 * has no clock-names/freq-table-hz, so it is never added to
>> +	 * hba->clk_list_head).
>> +	 */
>> +	ufs->core_clk = devm_clk_get_enabled(dev, NULL);
>> +	if (IS_ERR(ufs->core_clk))
>> +		return dev_err_probe(dev, PTR_ERR(ufs->core_clk),
>> +				     "Failed to get and enable core clock.\n");
>> +
>> +	ufshcd_set_variant(hba, ufs);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct ufs_hba_variant_ops ufs_hba_s32n79_vops = {
>> +	.name = "s32n79",
>> +	.init = ufs_s32n7_init,
>> +	.link_startup_notify = ufs_s32n7_link_startup_notify,
>> +	.hce_enable_notify = ufs_s32n7_hce_enable_notify,
>> +	.pwr_change_notify = ufs_s32n7_pwr_change_notify,
>> +};
>> +
>> +/*
>> + * MPHY reset configuration: vendor DME attributes programmed while the PHY is
>> + * held in reset. Programs the reference-clock, RX squelch, RX Rhold and
>> + * CR-parallel control attributes.
>> + */
>> +static const struct ufshcd_dme_attr_val s32n79_reset_config[] = {
>> +	/*
>> +	 * Disable reference clock gating support and override the UniPro and
>> +	 * application reference clock enable inputs to 0.
>> +	 */
>> +	{ UIC_ARG_MIB_SEL(CBREFCLKCTRL2, 0), 0x8A, DME_LOCAL },
>> +	/* RX squelch control. */
>> +	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN0_RX), 0x1, DME_LOCAL },
>> +	{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN1_RX), 0x1, DME_LOCAL },
>> +	/* RX Rhold control option. */
>> +	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN0_RX), 0x2, DME_LOCAL },
>> +	{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN1_RX), 0x2, DME_LOCAL },
>> +	/* CR parallel selection. */
>> +	{ UIC_ARG_MIB_SEL(CBCRCTRL, 0), 0x1, DME_LOCAL },
>> +};
>> +
>> +/* Calibrations that must run while the MPHY is disabled. */
>> +static const struct s32n7_phy_reg s32n79_calib_mphy_disabled[] = {
>> +	/* Bypass RX AFE calibration. */
>> +	{ FAST_FLAGS(0), 0x4 },
>> +	{ FAST_FLAGS(1), 0x4 },
>> +};
>> +
>> +/* Calibrations that must run while the MPHY is enabled. */
>> +static const struct s32n7_phy_reg s32n79_calib_mphy_enabled[] = {
>> +	/* Write ATT offset compensation code to internal DAC. */
>> +	{ RX_DAC_CTRL_OVRD(0), 0x1 },
>> +	{ RX_DAC_CTRL_OVRD(1), 0x1 },
>> +	{ RX_DAC_CTRL(0), 0x8E },
>> +	{ RX_DAC_CTRL(1), 0x91 },
>> +	{ RX_DAC_CTRL_SEL(0), 0x1 },
>> +	{ RX_DAC_CTRL_SEL(1), 0x1 },
>> +	{ RX_DAC_CTRL_EN(0), 0x1 },
>> +	{ RX_DAC_CTRL_EN(1), 0x1 },
>> +	{ RX_DAC_CTRL_OVRD(0), 0x0 },
>> +	{ RX_DAC_CTRL_OVRD(1), 0x0 },
>> +	/* Write CTLE offset compensation code to internal DAC. */
>> +	{ RX_DAC_CTRL_OVRD(0), 0x1 },
>> +	{ RX_DAC_CTRL_OVRD(1), 0x1 },
>> +	{ RX_DAC_CTRL(0), 0x71 },
>> +	{ RX_DAC_CTRL(1), 0x7F },
>> +	{ RX_DAC_CTRL_SEL(0), 0x2 },
>> +	{ RX_DAC_CTRL_SEL(1), 0x2 },
>> +	{ RX_DAC_CTRL_EN(0), 0x1 },
>> +	{ RX_DAC_CTRL_EN(1), 0x1 },
>> +	{ RX_DAC_CTRL_OVRD(0), 0x0 },
>> +	{ RX_DAC_CTRL_OVRD(1), 0x0 },
>> +	/* FW Calibration configuration. */
>> +	{ FW_CALIB_CCFG(0), 0x100 },
>> +	{ FW_CALIB_CCFG(1), 0x100 },
>> +};
>> +
>> +static const struct s32n7_soc_data s32n79_soc_data = {
>> +	.vops = &ufs_hba_s32n79_vops,
>> +	.reset_config = s32n79_reset_config,
>> +	.reset_config_count = ARRAY_SIZE(s32n79_reset_config),
>> +	.calib_mphy_disabled = s32n79_calib_mphy_disabled,
>> +	.calib_mphy_disabled_count = ARRAY_SIZE(s32n79_calib_mphy_disabled),
>> +	.calib_mphy_enabled = s32n79_calib_mphy_enabled,
>> +	.calib_mphy_enabled_count = ARRAY_SIZE(s32n79_calib_mphy_enabled),
>> +};
>> +
>> +static const struct of_device_id ufs_s32n7_match[] = {
>> +	{
>> +		.compatible = "nxp,s32n79-ufshc",
>> +		.data = &s32n79_soc_data,
>> +	},
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, ufs_s32n7_match);
>> +
>> +static int ufs_s32n7_probe(struct platform_device *pdev)
>> +{
>> +	const struct s32n7_soc_data *soc_data;
>> +
>> +	soc_data = device_get_match_data(&pdev->dev);
>> +	if (!soc_data)
>> +		return -ENODEV;
>> +
>> +	return ufshcd_pltfrm_init(pdev, soc_data->vops);
>> +}
>> +
>> +static void ufs_s32n7_remove(struct platform_device *pdev)
>> +{
>> +	ufshcd_pltfrm_remove(pdev);
>> +}
>> +
>> +static const struct dev_pm_ops ufs_s32n7_pm_ops = {
>> +	SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>> +	RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
>> +	.prepare	= ufshcd_suspend_prepare,
>> +	.complete	= ufshcd_resume_complete,
> 
> AI report, need pm_ptr()
> 
Thank you! I will wrap the prepare and complete callbacks with pm_ptr() 
in the next revision. I left them unchanged so far because both 
callbacks are not guarded by CONFIG_PM_SLEEP.

>> +};
>> +
>> +static struct platform_driver ufs_s32n7_driver = {
>> +	.probe = ufs_s32n7_probe,
>> +	.remove = ufs_s32n7_remove,
>> +	.driver	= {
>> +		.name	= "ufs-s32n7",
>> +		.pm	= pm_ptr(&ufs_s32n7_pm_ops),
>> +		.of_match_table	= ufs_s32n7_match,
>> +	},
>> +};
>> +
>> +module_platform_driver(ufs_s32n7_driver);
>> +
>> +MODULE_AUTHOR("Larisa Grigore <larisa.grigore@oss.nxp.com>");
>> +MODULE_DESCRIPTION("NXP S32N7 UFS Host Controller platform driver");
>> +MODULE_LICENSE("Dual BSD/GPL");
>> diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
>> index 53b523ef59df..d62cd4c085ba 100644
>> --- a/drivers/ufs/host/ufshcd-dwc.h
>> +++ b/drivers/ufs/host/ufshcd-dwc.h
>> @@ -13,8 +13,8 @@
>>   #include <ufs/ufshcd.h>
>>
>>   /* RMMI Attributes */
>> -#define CBREFCLKCTRL2		0x8132
>> -#define CBCRCTRL		0x811F
> 
> Move macro should be in sperate patch, don't mix into this patch.
> 

Thank you! I will create a new patch for this change.

Best regards,
Larisa
> Frank
>> +#define RXSQCONTROL		0x8009
>> +#define RXRHOLDCTRLOPT		0x8013
>>   #define CBC10DIRECTCONF2	0x810E
>>   #define CBRATESEL		0x8114
>>   #define CBCREGADDRLSB		0x8116
>> @@ -24,10 +24,20 @@
>>   #define CBCREGRDLSB		0x811A
>>   #define CBCREGRDMSB		0x811B
>>   #define CBCREGRDWRSEL		0x811C
>> +#define CBCRCTRL		0x811F
>> +#define CBREFCLKCTRL2		0x8132
>>
>>   #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
>>
>> +/* CBRATESEL: 0 - rate A, 1 - rate B. */
>> +#define CB_RATE_A		0x0
>> +#define CB_RATE_B		0x1
>> +
>>   /* M-PHY registers */
>> +#define RX_DAC_CTRL(n)		(0x10AF + ((n) * 0x100))
>> +#define RX_DAC_CTRL_OVRD(n)	(0x10B0 + ((n) * 0x100))
>> +#define RX_DAC_CTRL_SEL(n)	(0x10B1 + ((n) * 0x100))
>> +#define RX_DAC_CTRL_EN(n)	(0x10B8 + ((n) * 0x100))
>>   #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
>>   #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
>>   #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
>> diff --git a/drivers/ufs/host/ufshci-dwc.h b/drivers/ufs/host/ufshci-dwc.h
>> index 6c290e272106..c66f33391b65 100644
>> --- a/drivers/ufs/host/ufshci-dwc.h
>> +++ b/drivers/ufs/host/ufshci-dwc.h
>> @@ -12,9 +12,15 @@
>>
>>   /* DWC HC UFSHCI specific Registers */
>>   enum dwc_specific_registers {
>> +	DWC_UFS_REG_BUSTHRTL	= 0xC0,
>>   	DWC_UFS_REG_HCLKDIV	= 0xFC,
>>   };
>>
>> +/* Low-Power Power Gating Enable. */
>> +#define DWC_UFS_BUSTHRTL_LP_PGE		BIT(16)
>> +/* Low Power - AH8 Power Gating Enable. */
>> +#define DWC_UFS_BUSTHRTL_LP_AH8_PGE	BIT(17)
>> +
>>   /* Clock Divider Values: Hex equivalent of frequency in MHz */
>>   enum clk_div_values {
>>   	DWC_UFS_REG_HCLKDIV_DIV_62_5	= 0x3e,
>> --
>> 2.43.0
>>
>>

