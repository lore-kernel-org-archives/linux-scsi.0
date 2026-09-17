Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011025.outbound.protection.outlook.com [40.107.130.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C42F7F01;
	Thu, 17 Sep 2026 09:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635668; cv=fail; b=syceyfGKn862IjYYE0OmOAKl/L3UsN7k5CYjaYdGFo2Gx/6frEtTg4fOQOLBOubE/pQ5ebWF5T9nIp03SovOUDvHQFalGs811j4hCNPsXmvSs3X7ltIVoXXecUdTecn5f1jwpgFRyAtLV2V/+tRou4mTryc7jVrkZdyIvDL+Fxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635668; c=relaxed/simple;
	bh=OzbWYG0JcMyVSX1Ib4DEi4/V1IJAgiS2AfirAzvDrs0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WCZp73jQMtTNplmDE7WhdkRjdgw/d6qxcGaVUAvdPiOV/3Y7XB7kT6E7uoOE+zfgn8HMANZF1aRaEbtrJjdlFw7yVTTPfZuG23ZnNllcv9bZCcc0hHgZ9l1iFohgPuq2Ili6aGFWQUHbvUw8JmrCssQA6N4no3IXxDM34Fl2B/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=HbLBaJZM; arc=fail smtp.client-ip=40.107.130.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="HbLBaJZM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ildgwkpXoZn2Y9LFFdbdyvBhvCm1kbRJq3Ojo4k97hXgxPf9f1Kl/aTyq5//0mxtWffci3N7gdGMxhGBsKLMvhcmcVxyP64ttrvurHRLqH3GRrjL3AUygY6t4FEtKGQ3FuLvUyXjghyQid9Wgrsa0Q99FN6Wv/1arn71CnRnWEgESFgS8DuuohtOWyIY2OU9342/o1Ul3ny+i8C90ognFQv+qCC/pjk7ambyhqf5NgM7KB13vDejwhqdyDD4Md7xnRnHugFV2KTqYXZgS5fTgoZpG44HMlLO2204b5+tATZO6K1VLWAcF7VHvJa2pu/6QBe7qIcwH6szipxDTfFIMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ie+IaUUjAt2szDXMi5v29oMhfImflhnnR1oHxKba5Ao=;
 b=BapcoWQQar58r+cJex6tB9zCXIyVGgbcaq8LSzu9BGDqQVRBjZLQ98TFu/hkcc8aDmQkZ8r3I7/c8wFEUgusEDytMI/F+rLxED8FStlAJ/Ac7RxFpkFvZUPkl3vVszrjdR9Xm6ez832wBim1uTSYVAaP3J+kZA1//S2Cylvtc0xhm+UrKf5C9QhmQzYVo0UmCso5v6MPCR/bGDVIUFOHck2p92/sOtV542R4rzR25msrXHVVKhsddn6m4Ln4e7tNo/1Gr/zkhiouVWv3EnSGHwfVzQoeadegWRvH2iT9AWYUpvbRF1HdkLaHKbrRepppiJqUxFlFJVVG4ShZf2WNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ie+IaUUjAt2szDXMi5v29oMhfImflhnnR1oHxKba5Ao=;
 b=HbLBaJZMtjz3b+l+3o3Mti7AQyh1FzOTcelbz92bUCDwsqd/XIBfQojv6KzKzH4SZ1vXSeptZ0nANTVCeimZj4Z67FTaueSnXnOJLX7STLYpgHhDQeFz9NZ4Wf/9sZM+oijfvmHdPRW+0//0/KcEwGgaO/Tm6t5mO01yff7Sww7Wp8t7TWS2zYClAceOOsMZ9pi2SkY1McrX3iiOyj5rKcX4GamAj28/W4V6okkk1OlFunhLAK25ODGdFmgc38+gmj0hbqiAoDHSz7akakvzIK6zlyljXE2IssD0QpYCluC4Nr+eesqV0w0VyPmeeV8usyURaRc4EIqctXUQwbWUxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DB9PR04MB11628.eurprd04.prod.outlook.com
 (2603:10a6:10:608::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 09:00:56 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 09:00:56 +0000
Message-ID: <af6d03c3-a0fe-49a5-8adc-866ef74f1ebe@oss.nxp.com>
Date: Thu, 17 Sep 2026 12:00:52 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] ufs: host: Add common Hibern8 TX FSM polling
 helper
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
 <20260916084411.941297-4-larisa.grigore@oss.nxp.com>
 <aqrCUDrYaIsL39zn@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <aqrCUDrYaIsL39zn@SMW015318>
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
X-MS-Office365-Filtering-Correlation-Id: 835f6ca9-8145-4679-1fe6-08df149a2f30
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|19092799006|11063799006|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 EEgTDARt27pxsM3sbAcCVrJ0FiiZSao3Z3naQNGZgHkhbi3u6D1Fz++IU9VUY0Ck2q+AkPqiMoRMqs0+5XUOi7IXPz0c8sN1b0iyEI0mJoWoanMqc9CyksLQjsIyDrV5CY5a+MNuHuMgG6hk8md2+057UMZ1Tj7/MDu1XC11JNiZ75iThOsqc2JL6xsC4mbBT9/8olwAPu5xh46afGP3fIAp1JScnJVPs7F6tfSZ8r8/c6HAJAApMPHLSGNN/dRDJX91XNDleMawQA7n6l2GxyFZa9M67ldxZq7lbQxYkNjrFqqRNXGyWmae/yXzsFHyJkDLMv/wjRS+bygJ/roavC4Qv2p2yomYgwtbljy3YH/+/ppE33/Eqgi8lfPzpFZxts0cLnYeeNKQPW52DW7HAohqmy/nVl6BLM1qngR9BpuQmtGMVYdvzSSiGFhs36dYGDBZ6P+pSf2WJB9uLGxWtnTXfEDWSmUvDO31nL1rXUM8uR0DS5lyB5v0GZyQLCXu/bBng9dnAsryMjKwbLXBOsxJtegtSeKwtb6Iw08ctmRyEVxw+vLDWcObPNoc5ryUO08lkQXX3FiKeInh0aC+23OYDKTddpmCqdUAGLHcgjx7EU8GgJtNqxYMgw5q2BnR5IPm5lqzaZEHcw4WxLP1/8yAM2mrflG/cva439M21hE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(19092799006)(11063799006)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?cThoZU5YakVJbTlTTHBuNyswcDhXdHRxU0puc0V3dEVZc2NueWpEbHVzUXkw?=
 =?utf-8?B?UXdaNURBb29CU1VmOXBidTJoeVN2eTB6WjVkdDJ2OVp6bWF6eHdEWU82QytP?=
 =?utf-8?B?Qk0zOVd5RiswZnBXTXZPbWtBeXZiVnNRSWREdzFXNGFDajNHRmVLUEdEdGVz?=
 =?utf-8?B?SUowbUkwZ1BjUEFSL0RTVFkxZEViQ3hpVzBUNmN3eFBTaUV0T1QxQzNGclpv?=
 =?utf-8?B?SUU3am1jYUNnWjdETWlHU2NWdWFBaFQwRmY1cSt6bW9HK2lvK05VMFFmL0h6?=
 =?utf-8?B?djVFRDB2Si9ZdHdOTlJKSFJGcVZmcDhCb3RsQ29ZRjFwNDgxbjdGcnlDb0hD?=
 =?utf-8?B?M2t6dnphc1JlRFkzc3llNlZpTHIwNWNIblBRRExwN05VRkpnOXA0NGlZeVdD?=
 =?utf-8?B?NGcxcDZmNG1vdENYZFZzVU44ZEJESkpMaGFYNy9veEZHVTVONmM0dUZKSERT?=
 =?utf-8?B?akJXSHZqdVMzeVpiTHlLWkNseDhlODdONGl4NjJMcmlveXJZOTRmQklFYnlU?=
 =?utf-8?B?TEF4Unl1dUxtaWVRTjg5NE93cGppYTVoUndUcnArV3B6MWtWTjg5TndpcFFT?=
 =?utf-8?B?RHJMWlRZc1JpLzU3azMxYU40SlRORmtnN1I3MmxSajJ6YXM0aHFDT0p5T0NP?=
 =?utf-8?B?blIydkVheHBLcm4zMG5XSFBkMzR2YzNMb08vTWl1RXM1STREWW1wSjVMcm52?=
 =?utf-8?B?VFQ1MFEvK1VFdytWV0V3R3dFM0NmakhtbjZRNGpWYmNyNUY2cjhoSU1EUmtp?=
 =?utf-8?B?YlN1MFptcTBRbUw4cXJ6bGRjVitab3VtMTd1cGZmQnE3Q25PZnN2NmhMRUx0?=
 =?utf-8?B?RUg3ZVFqNjFBUUtOWXFpYUtwSzZJeE9HSFNESldnd2dJVGVSY0hDVENDS0RL?=
 =?utf-8?B?QkxLODRFZndlTkZ6TkZZOERlKzRjaEhyWERSbEJudlhiVmdmamVaY0prRkMx?=
 =?utf-8?B?QWNFd2ZYSko5dThQNDZSQThBU3BDNHdaWXMweXpTeGk1bE9HRG5Zdm5vZVVY?=
 =?utf-8?B?OHBqS282eitzU3FFRk1ZRkRPVnk2bjFpR3JvYW1aNG8yUVl4aTd1Y29FRE1Q?=
 =?utf-8?B?OUVnSlozYzF6ZFZZZDV5RUtmRmd4YStZRlNGZi9sdzRiN0FRN0NpNlF6VE1o?=
 =?utf-8?B?NUxhSExHM2ZHOUtvTVMvR2U2ZW9wWEplLzZIWkdkSHdzQmRhZkIwSmlkeVlF?=
 =?utf-8?B?Y2VQMmN3L3N2eHh2VUVnKys2ZmxBZXBtK2JOUnkxY0Qya2hlNHB6VzNyRlU5?=
 =?utf-8?B?UU5LcTlndDBFTERPcStxN1pxSDZ6bHpGK3hKWExMZmVlRzAwNWhvbUNJUkRk?=
 =?utf-8?B?VE1wN094SU5Lam1pZFNxZVRjMlQ0YVlwNlB4K05YaW1veE9GZ1A0dVNzR2pL?=
 =?utf-8?B?Q0VMT3JDejBTK2pyVThick1mZ2xiWFQxdkRBZHdyWkRIUlg1YnpGMHBEckNX?=
 =?utf-8?B?Wm1uK2pjWlp4UDZXWWRnOFFQTW80S203eGZWK3VDVCtMS1lRTXQvekhud3NO?=
 =?utf-8?B?Vk84aEJLVnR5L2U1QXZqbk41ZjlsQ3FsNTErVEhXQWYyU0pFVlN1UWxnTmtZ?=
 =?utf-8?B?UDM4cmVyUUw1ZEZHNGFpbTBHaXZuQW5RaC91WWhpcEZqS3RzbFRuL3B4ZTh5?=
 =?utf-8?B?Y2I4dENZbjlKaWFiMTdjVnRoR21xTjVoRkQvVndDYktObGNpWWE2QnI0T1ZB?=
 =?utf-8?B?endxREdqQ2JXajlHZDVDeHY5Sk9RSXdsb0RtekY0UXhVSXR4WGhrbU1lc1N5?=
 =?utf-8?B?Z29BaXJCZUpRdU43OWZ5UmJyNWV6YXlGc3dMd0YzeW5xSVZybzJHZ3hQKzV4?=
 =?utf-8?B?TjFseFBKMlgzUlVHT1k5RnI3eFczZVAxMzJnVHdVQVdMWWxXb1dmS2VXUEZt?=
 =?utf-8?B?T2ozYksxVHNiNXBDbllWZktjdFdiTXpONWVvcHR6SE16ajh3YnRDWXlZRkQ3?=
 =?utf-8?B?a0FFODY4VTF5ZmRzcVg2K09JMmc5YlpBYlhvV04xV240OE8zTG52b1o1M1dI?=
 =?utf-8?B?bjVXQVdYekxpVVVjUFkxT3c5dFBRc0sySmFqV29waHFzMkxBUWhWNjVOZ1RP?=
 =?utf-8?B?Vk9OV09pVElWaC9YQndRRHBPM3FDTG9ac0NlNUNvdHVMZmRPTDFWMXU0dVJm?=
 =?utf-8?B?ZCtxdFZ3TTJwUXBTZEM5eXByRVlWR0tEcDFpcnRoUmRIK1k1Wk9kNWNybjlo?=
 =?utf-8?B?QjFZQ2pjTTA2QmhWR2pHa2lPRmNCYlViajkwdDF5U0hONkQwZ3BZaDAyYlV0?=
 =?utf-8?B?Y3F2MVlHMVk5ZmFid05ldEV5QUkyVzBwMy96VWtkOHhSMEU5RWtYQVpta0tC?=
 =?utf-8?B?V0V6SHlVOCtlNkdGTXlaN0FhUEhLUzdKWkJXWDNnQVdRd2ExdGtkQT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835f6ca9-8145-4679-1fe6-08df149a2f30
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 09:00:56.1460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMw5ksIsfMqteV6JScSWbaQ4UKK1mASLd50CHRe4w7HTt7uvUBFCQc1eG+U1xaybOm/O8r4T+SiPq3XE/D5osQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB11628

On 9/16/2026 7:22 PM, Frank Li wrote:
> On Wed, Sep 16, 2026 at 10:44:04AM +0200, Larisa Grigore wrote:
>> Factor out the common logic used to poll TX_FSM_STATE until the TX lanes
>> enter Hibern8 into ufshcd_check_hibern8().
>>
>> The HiSilicon and Qualcomm drivers currently implement similar checks
>> using the UniPro TX_FSM_STATE attribute after link/PHY bring-up. Move
>> this logic to a common helper in ufshcd so it can be shared across host
>> controller drivers.
>>
>> Switch the HiSilicon and Qualcomm drivers to use the new helper and drop
>> their local implementations. While at it, normalize the "TX lane failed to
>> reach Hibern8" error path to return -ETIMEDOUT instead of the raw
>> TX_FSM_STATE value (qcom) or -1 (hisi), so all callers get a proper errno.
>> This is an intentional, harmless change of the returned error value; the
>> pass/fail behaviour at the call sites is unchanged.
>>
>> Unlike the initial implementation, the timeout error is now reported only
>> once by ufshcd_dme_check_tx_hibern8() after its final check, instead of
>> per lane.
>>
>> This also prepares for reusing the same UniPro-specific Hibern8 check in
>> a subsequent commit.
>>
>> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
>> ---
>>   drivers/ufs/core/ufshcd.c   | 86 +++++++++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufs-hisi.c | 48 +--------------------
>>   drivers/ufs/host/ufs-qcom.c | 42 +-----------------
>>   include/ufs/ufshcd.h        |  3 ++
>>   4 files changed, 91 insertions(+), 88 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 2ba244cf40ac..f34b7fe54a16 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -4448,6 +4448,92 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
>>
>> +/**
>> + * ufshcd_poll_tx_hibern8_lanes - Check TX_FSM_STATE of all TX lanes once
>> + * @hba: host controller instance
>> + * @num_lanes: number of TX lanes to check
>> + *
>> + * Read TX_FSM_STATE for every lane and verify it reached Hibern8.
>> + *
>> + * Return: 0 if all lanes are in Hibern8, -EAGAIN if any lane is not (yet)
>> + * in Hibern8, or a negative errno (e.g. -ETIMEDOUT from a hard UIC command
>> + * timeout) if the attribute read fails.
>> + */
>> +static int ufshcd_poll_tx_hibern8_lanes(struct ufs_hba *hba,
>> +					unsigned int num_lanes)
>> +{
>> +	u32 tx_fsm_val = 0;
>> +	unsigned int i;
>> +	int err;
>> +
>> +	for (i = 0; i < num_lanes; i++) {
>> +		err = ufshcd_dme_get(hba,
>> +				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> +					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(i)),
>> +				&tx_fsm_val);
>> +		if (err) {
>> +			dev_err(hba->dev,
>> +				"%s: unable to get TX_FSM_STATE for lane %u, err %d\n",
>> +				__func__, i, err);
>> +			return err;
>> +		}
>> +
>> +		if (tx_fsm_val != TX_STATE_HIBERN8)
>> +			return -EAGAIN;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * ufshcd_dme_check_tx_hibern8 - Check if all TX lanes entered Hibern8 state
>> + * @hba: host controller instance
>> + * @num_lanes: number of TX lanes to check
>> + * @timeout_ms: timeout in milliseconds for all lanes
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba, unsigned int num_lanes,
>> +				unsigned int timeout_ms)
>> +{
>> +	unsigned long timeout;
>> +	int err;
>> +
>> +	if (!num_lanes)
>> +		return -EINVAL;
>> +
>> +	timeout = jiffies + msecs_to_jiffies(timeout_ms);
>> +
>> +	do {
>> +		err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
>> +		/*
>> +		 * -EAGAIN means the lanes are simply not in HIBERN8 yet, so
>> +		 * keep polling. Any other error is a real failure and must
>> +		 * be returned immediately instead of being retried.
>> +		 */
>> +		if (err != -EAGAIN)
>> +			return err;
>> +
>> +		/* sleep for max. 200us */
>> +		usleep_range(100, 200);
>> +	} while (time_before(jiffies, timeout));
>> +
>> +	/*
>> +	 * We might have been scheduled out for long during polling, so do
>> +	 * one final check before reporting timeout.
>> +	 */
>> +	err = ufshcd_poll_tx_hibern8_lanes(hba, num_lanes);
>> +	if (err == -EAGAIN) {
>> +		dev_err(hba->dev,
>> +			"%s: timeout waiting for TX lanes to enter HIBERN8\n",
>> +			__func__);
>> +		err = -ETIMEDOUT;
>> +	}
> 
> 
> why not use read read_poll_timeout()
> 
> read_poll_timeout(ufshcd_poll_tx_hibern8_lanes, err, err != -EAGAIN, timeout_ms,
> 		  0, hba, numlanes);
> 
> 
> Frank
> 
Thank you for the suggestion!

Best regards,
Larisa

>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_dme_check_tx_hibern8);
>> +
>>   /**
>>    * ufshcd_dme_rmw - get modify set a DME attribute
>>    * @hba: per adapter instance
>> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
>> index bd223bda1ce2..b84075dfe00d 100644
>> --- a/drivers/ufs/host/ufs-hisi.c
>> +++ b/drivers/ufs/host/ufs-hisi.c
>> @@ -22,50 +22,6 @@
>>   #include <ufs/ufshci.h>
>>   #include <ufs/ufs_quirks.h>
>>
>> -static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>> -{
>> -	int err = 0;
>> -	u32 tx_fsm_val_0 = 0;
>> -	u32 tx_fsm_val_1 = 0;
>> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>> -
>> -	do {
>> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>> -				      &tx_fsm_val_0);
>> -		err |= ufshcd_dme_get(hba,
>> -		    UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -		if (err || (tx_fsm_val_0 == TX_STATE_HIBERN8 &&
>> -			tx_fsm_val_1 == TX_STATE_HIBERN8))
>> -			break;
>> -
>> -		/* sleep for max. 200us */
>> -		usleep_range(100, 200);
>> -	} while (time_before(jiffies, timeout));
>> -
>> -	/*
>> -	 * we might have scheduled out for long during polling so
>> -	 * check the state again.
>> -	 */
>> -	if (time_after(jiffies, timeout)) {
>> -		err = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(TX_FSM_STATE, 0),
>> -				     &tx_fsm_val_0);
>> -		err |= ufshcd_dme_get(hba,
>> -		 UIC_ARG_MIB_SEL(TX_FSM_STATE, 1), &tx_fsm_val_1);
>> -	}
>> -
>> -	if (err) {
>> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>> -			__func__, err);
>> -	} else if (tx_fsm_val_0 != TX_STATE_HIBERN8 ||
>> -			 tx_fsm_val_1 != TX_STATE_HIBERN8) {
>> -		err = -1;
>> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE, lane0 = %d, lane1 = %d\n",
>> -			__func__, tx_fsm_val_0, tx_fsm_val_1);
>> -	}
>> -
>> -	return err;
>> -}
>> -
>>   static void ufs_hisi_clk_init(struct ufs_hba *hba)
>>   {
>>   	struct ufs_hisi_host *host = ufshcd_get_variant(hba);
>> @@ -224,9 +180,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>>
>>   	/* Unipro VS_mphy_disable */
>>   	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0C1, 0x0), 0x0);
>> -	err = ufs_hisi_check_hibern8(hba);
>> -	if (err)
>> -		dev_err(hba->dev, "ufs_hisi_check_hibern8 error\n");
>> +	err = ufshcd_dme_check_tx_hibern8(hba, 2, HBRN8_POLL_TOUT_MS);
>>
>>   	if (!(host->caps & UFS_HISI_CAP_PHY10nm))
>>   		ufshcd_writel(hba, UFS_HCLKDIV_NORMAL_VALUE, UFS_REG_HCLKDIV);
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 1e492dac8d93..815ca82a0878 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -382,46 +382,6 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>>   	return 0;
>>   }
>>
>> -static int ufs_qcom_check_hibern8(struct ufs_hba *hba)
>> -{
>> -	int err;
>> -	u32 tx_fsm_val;
>> -	unsigned long timeout = jiffies + msecs_to_jiffies(HBRN8_POLL_TOUT_MS);
>> -
>> -	do {
>> -		err = ufshcd_dme_get(hba,
>> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>> -				&tx_fsm_val);
>> -		if (err || tx_fsm_val == TX_STATE_HIBERN8)
>> -			break;
>> -
>> -		/* sleep for max. 200us */
>> -		usleep_range(100, 200);
>> -	} while (time_before(jiffies, timeout));
>> -
>> -	/*
>> -	 * we might have scheduled out for long during polling so
>> -	 * check the state again.
>> -	 */
>> -	if (time_after(jiffies, timeout))
>> -		err = ufshcd_dme_get(hba,
>> -				UIC_ARG_MIB_SEL(TX_FSM_STATE,
>> -					UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
>> -				&tx_fsm_val);
>> -
>> -	if (err) {
>> -		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
>> -				__func__, err);
>> -	} else if (tx_fsm_val != TX_STATE_HIBERN8) {
>> -		err = tx_fsm_val;
>> -		dev_err(hba->dev, "%s: invalid TX_FSM_STATE = %d\n",
>> -				__func__, err);
>> -	}
>> -
>> -	return err;
>> -}
>> -
>>   static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
>>   {
>>   	ufshcd_rmwl(host->hba, QUNIPRO_SEL, QUNIPRO_SEL, REG_UFS_CFG1);
>> @@ -607,7 +567,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>>   		break;
>>   	case POST_CHANGE:
>>   		/* check if UFS PHY moved from DISABLED to HIBERN8 */
>> -		err = ufs_qcom_check_hibern8(hba);
>> +		err = ufshcd_dme_check_tx_hibern8(hba, 1, HBRN8_POLL_TOUT_MS);
>>   		ufs_qcom_enable_hw_clk_gating(hba);
>>   		ufs_qcom_ice_enable(host);
>>   		ufs_qcom_config_ice_allocator(host);
>> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
>> index dfd302f2dc7c..0d9d0a26eb20 100644
>> --- a/include/ufs/ufshcd.h
>> +++ b/include/ufs/ufshcd.h
>> @@ -1556,6 +1556,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>>   			       u8 attr_set, u32 mib_val, u8 peer);
>>   extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>>   			       u32 *mib_val, u8 peer);
>> +extern int ufshcd_dme_check_tx_hibern8(struct ufs_hba *hba,
>> +				       unsigned int num_lanes,
>> +				       unsigned int timeout_ms);
>>   extern int ufshcd_change_power_mode(struct ufs_hba *hba,
>>   				    struct ufs_pa_layer_attr *pwr_mode,
>>   				    enum ufshcd_pmc_policy pmc_policy);
>> --
>> 2.43.0
>>
>>

