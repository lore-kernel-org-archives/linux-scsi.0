Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013067.outbound.protection.outlook.com [40.107.162.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549C946AA76;
	Thu, 27 Aug 2026 13:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839187; cv=fail; b=bt4VExl/nJowcypVVEBQKLDNPPTLR65JJb2gFvlNlEOcIcRjSDvbdNLdfRjinugJz16F3I2RR4TVQftCVw1Ju8lZcUa9ISxn8RwxnxAHnW9oZWH/I8YBStGJsd2Zq/H+FsXFGDEYA9qWjAs0WhF3/Ebcz5DaJjS8QXxgBCvRSoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839187; c=relaxed/simple;
	bh=SHvEJaDmxLIMP2l+hWet8xLvEKzWdyPNugOAy/xO6n4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I974n6x9GGrHKtonV2D1Me1PfKIL/LDr9X3jDf1lyfVjqkZR0bssyAAUu7V6Zm3ZtDgPM4P+DASqoce2crM9lPmubHihMJWfiTRWu9A8I1xlEFQFzAp121n4QTTbh81cr06UCJFIYCPmxIWXwMdQ+LbX6pQq7VxxCMqfSlp1eq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SBnZdtWw; arc=fail smtp.client-ip=40.107.162.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SBnZdtWw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjvzINsMuxN1X+8MjkYP7mKvU+RLryF1fQhyJO21GJXxZMtr0+QN+OugSkusi0mqcHqsebXkJHXm54V4tEtH8FeZm0sydBcwcBoZNtQznao9cQBTnXFHtyVE/TgDmEoggCVi08UnxkwFJ/uvZRcqcs0kMpZ2d7GKrqL991LdSOUoDGx5vqmX/jOx/sEw0Q4gbH5CikPqfH5E+7lltdQsQfu1TG3MTDBTYi9E4kH/BuJzhE0R+ZSG7uKl1JTOaQYBhCWsNO6Dtu1ya2UTgzS8bd8df+zS6Xye+z/TkfFbREb0ZFk+F740/Vt4/6IE/do6i5kZQ8Z7u7A+QuSqVrdewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hc+SG1zXAAHlC7/d4JUxS2PuWn1f7c+cm51pO4Y1H+I=;
 b=S4D6o+c/GEI4KIfaHYCTxlEXJTDT894OnN2pSwh0lznqNj+Iil+Va0mYF80OdiRCG+EPxW/HSCEeSHdE4EZKGE5u4v9eQvTR3oTG/ozqhuhU/s587FuMHT1xAPLTPWUU27u4XKFi0gJGZCviFtn4lWRpldb8jok/ECeXQODF60Kjb7iQZT9/rQaZw1H83+VZgvyULOPuPGneb9h21qg1usrVfAHaJ4M7dUklR2mvFq58hHgvwn+7BQeanXEqo6kmKf+LG3qJN4aLX6gnwpPtme6ZaeQiDh44VM6NbwYuV9unlcXSOA8PxH6cte4pgzRxb5ZvuLS70CXYp1HzIHsnjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc+SG1zXAAHlC7/d4JUxS2PuWn1f7c+cm51pO4Y1H+I=;
 b=SBnZdtWwYgncUGs8ZxjCBOLZxjezlmQUmk9JN0MRCjlCZnd41736g0Z3Dh0rbjhYErdN3CTrkPUdDCZ1kyOJXWTcIXxjPMM6kHrL+hvEuQySYLEhDhnH9K5ixpHa6u3Vol6fERA2Ktc4LvmssSfbK6NyJKcGDekxE3M5VmQBvrnbsSrQCygPTi39u0CcnIPL4nZfUdZJYvBMxbiPXEeCAi3M41qkc86GnrkQ5eui+QMLfluEhexK0QZMGPcbXCSZw6DIgo7W4bdw3yZqURXoHku0g9Kwq8IkbLqr76ADjwbAXfspmG7rjIqAVb9n7Uykla+S8Prnschq3C8RTYt4Vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DU4PR04MB10361.eurprd04.prod.outlook.com
 (2603:10a6:10:55d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 13:59:39 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 13:59:39 +0000
Message-ID: <d52642ef-40b3-4c13-8335-aa6e74739f50@oss.nxp.com>
Date: Thu, 27 Aug 2026 16:59:35 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] ufs: unipro: Move Tx/Rx FSM state definitions to
 unipro.h
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
 <20260826134048.854748-2-larisa.grigore@oss.nxp.com>
 <ao8AtFsYdr26rHVc@SMW015318>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <ao8AtFsYdr26rHVc@SMW015318>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0271.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::20) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DU4PR04MB10361:EE_
X-MS-Office365-Filtering-Correlation-Id: b284bb34-421b-4c24-b5b7-08df04436f4f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|19092799006|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 9mXsu+D76rJMQj5wWlgwyhAKC+6nRvcWdvtuz5G9f05M2egCKRLbohHx3CIFfwJy1++F9+2m5grJHNcygS/SeGA04EWBZfS+RRBlxkcerOhLFtHs2V6pdigPat9IdIyXnxaqZGSL5jpdEZcgFWmhYTPul7dO01SQ3PnpM1pb9eWmswYIu8j1Nktyr/q5OgRx5KxIxPrZWHKwglQ0RlZ5+oKxrYYrc/JPB1e6mdibVMJI5UQMSxn1TeY92B8nuARVgM/9DXLUX9F3UWyauNu/u0oqHZhatbAL1XKbPkhA3aR4gysStLGJ8zo5O6O3iepOcPuQm83F/2nNKgQhyHRD/78/392bt15qhl0rvvOhE4ZGOa8BDy1iU/j3Bj5Jdj8uqatLXvwG/WoHhHRp5ZvwSZH/l9/s6WxzoCcRxKLEwcsAOrgFSMKt1rI5KA6Jh+tGkIVVOBMenN5D3GLAH7Uh+/mOI8SwzXhn5NDHTY4dXR8nL5aAZhomu2oRsKMpsi9VsPb7hUh2PPpW+NBPPavCLwrBwSeZpaK45HnbfUBULAZqhIdWaCp71RU8lprLhiDvQlrllV2dNJBfKh5d2ukfJtlIFNexXG1HIEYsjJ7j7GW/RWtBejwYurQ+gUEuYBtzaaeS7dVVcwzP3kn6MbVigdfonQUWj43y0lEU1NML7IM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(19092799006)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?dzVub0h6RHpRdHhMVS8rREVMS2dNWmt6emNVTFNtSDE4azJjd05jNG5LL0U3?=
 =?utf-8?B?dmNjeU9wM3VKdTFIeExXZjZ5Q0kvU1A0UFNFdmlHVTZCUUdhMVJQL2FQZlFL?=
 =?utf-8?B?c0R2NUdkVSt4UUVkcWlveUJJSkFncFZXajFwckc1Nlp0bjhtYTg3clFSdTkr?=
 =?utf-8?B?R1g0K3ppZ1hXempSVksyb29VRi9vSnlmcTRwdWJiOU00OTdiNTgwaUlqMktY?=
 =?utf-8?B?MTB0L2pNeGUvQWo0ZFJtaktqbkJWUUpRQVhSdDlKQkpWZE9aeXh2M2E4WmxC?=
 =?utf-8?B?am9GdGRqSUFtZUpnTFFtQ2pHdy9oRUhBcE9aSlErZVI4RGdvYVhPMC9NRHJ1?=
 =?utf-8?B?T2JMZXhHMWRLTU9OMG5TOVNzMjN2OS9icW1BZjI5eTFrYjdjMkUwTzY5RTI4?=
 =?utf-8?B?QU04VzZHb2pUS2JtY21sRkxBNk5ON2JPemI0TVlzWFU3Y2xsQUE1K001eVYv?=
 =?utf-8?B?dElkdTU2dk8wKzFra0hNeDVXZE8rWXF1Tlp2RGZsUmpZYnNDWTNtdHJIVTBG?=
 =?utf-8?B?MStUdnFrYjg1bDlHYzZPV2R2VnBROUFma1R0UEwwblQ2U24zOStNdENOZUJl?=
 =?utf-8?B?Qm1NNTJHMVNyRjdTTkJuNUFJVHhNcHVjQ1lFeWRjT0pzeUJkSEwxOXViWDIz?=
 =?utf-8?B?NkM2b0UwdW1ESWtoWmdORFdLZGEwZVczS3hVWDVsUHAxV01yVmswWnVqR1Zt?=
 =?utf-8?B?SFUyYytIa2lldk56SS9xWlZzUGhkUzZWZmdYQlBvN1lzdzRia2RXczQ3QWZB?=
 =?utf-8?B?Wk5QUlJUbk8yREM1ZHp6N2ZVaHlna0ZxSDZEL0JhY3JZamoycHZRK0dCeUNl?=
 =?utf-8?B?QzIxK1JqUld5M2JRSE9NUm5UUTR3bjFTcEFJZDlLVXF1bTlHL3hleXVOSUc5?=
 =?utf-8?B?YXpvaGZzSlNxOUtUVm5manpMaHJ2RnFtQk9qM0xLQ1I4Q1pzYVUrYkZ4U2Js?=
 =?utf-8?B?TG42V3RuQnRyQ3cyNTkvbTIyVnNESUFBV0NEY1FyUm05dlFJU1RKeDNRTWZC?=
 =?utf-8?B?cVllZGtQWkhiUjRYSlNyeDUrZnE5UmpLazFnVDJWd1J2OU43MXZmN2xKUGRj?=
 =?utf-8?B?V0xqc0VuVjk4cld0RG1INHdLUzBRaVI1SUFIdjArTWdNZUtBVmZwaWZGOW9n?=
 =?utf-8?B?S2pQQTdHQTQxTCs0L25TZEx3ZUdsWXJtNTc2SnliN0dNYmxXVndKWUZOdGtT?=
 =?utf-8?B?aUUyRWVWWlNEZUtvN200YTZLNTF1VFJsdzdNZlV0S0FZbGhLdGZDU1VhRDRW?=
 =?utf-8?B?RVAvWW12UFcyWm1DYlNiWGptOGpGUG5pNm5DOGdvUTBhSkM3SXNua25lYkNx?=
 =?utf-8?B?THliMGRWeXIvaWNUY01JdE8yS0dTVXBId3U1S29ZZlRxY3MvQWRGSHJ1M0Z4?=
 =?utf-8?B?dUJqcVB2dEdoZm5NR2lMT2QzQ00vbFpoYkNiSldZQ3doenV6aURETjF3aTlS?=
 =?utf-8?B?Znp6d1NUeVhTQzV2WGdOQ3RVVzgrSXJxczBNRFZvU0Zqc1pPaENWUFZYNGxv?=
 =?utf-8?B?TFZJeXl1QlZuZDN6anE2d2hyUE94cjhpS0JHSGdHU25SSEFvN1JRL2ZHK1dE?=
 =?utf-8?B?TWpaRytmc0N2a2l6VmhVUXdhOEJqZWFSUlV2ZHd1U2VVYlRKOHl1QTNLMWxl?=
 =?utf-8?B?ZUVIVmdIUFY0ZWhFOGxkeFE0cDhiZzBxVUk3TndGSUZ5TGlhUWIxSGVQSHFJ?=
 =?utf-8?B?TlVPNi9CQlczbU5yYTRjVFhBZUkvWjIxNUFEc0wwRFY0cStQcWlRcTl0L0hr?=
 =?utf-8?B?cEtLZ1RaYXRabVJoTEh6T2pNbmF5UFRGWnNYN3VmQUNiSm9ISXQ2Y2FEVTFs?=
 =?utf-8?B?Y1NvVkhRcnVFZmdOdm8rM1hTOGZMa0U1TXdFZjZNbSs5cmpmRWR5R2tERE9m?=
 =?utf-8?B?RnZFR1FoNm9oazJseDBKOGpnYjBlTTQ3T1VRbFJaLzBWVDU1WDc5Qkhic1A3?=
 =?utf-8?B?eElqRFVvV21mSkRyN3VCaGV0QUR0djZMQ2ZyNGdpNTRPMlpRTzFkblh5Wlgz?=
 =?utf-8?B?V09RTEl5WFpTZmkxdHpscEdsVWttSjhMQXZQMU1HY3hQZGViUEJXK3RQRFJG?=
 =?utf-8?B?WDhqeG1icXpmZFJBTTVQc29LMXpOMTd4aTdrVVVFaTVUTmhiZnlsYWs0eUpi?=
 =?utf-8?B?dU9EUU85QXNnQWVnSy9VVTBGUDNJRisyT3hpZXJkVDcxUlhvTXNSOGFKOE50?=
 =?utf-8?B?aUNmQkN1UllnUUJoOHB1MmlKQlB6NEM1Q1k0cmZzUjBNNjdLdVhZaXVKTTdN?=
 =?utf-8?B?N3FsNWtwZlFOdzJWcTZIdmFnWjNQTFBoUy83ZWt0bEJ4N2pYT0tiSlA4RDg3?=
 =?utf-8?B?czVyU0F0MjhIeFFqZFFwOUErN1A2SGJzbnRwWXhzOWNUUkZqUUtMWk9zR3py?=
 =?utf-8?Q?/2e3ZRazGqNRVuV4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b284bb34-421b-4c24-b5b7-08df04436f4f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:59:38.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCTqAxLTiPE8x+j6xhgmgnQHJgeERQAHMIe5qPMgNz4KdtV/N8LbN6mgJ0hmMRNP+bmKhwGMhVyt4NircDqKnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10361

On 8/26/2026 6:05 PM, Frank Li wrote:
> On Wed, Aug 26, 2026 at 03:40:39PM +0200, Larisa Grigore wrote:
>> [You don't often get email from larisa.grigore@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>
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
> ...
>> -enum rx_fsm_state {
>> -       RX_STATE_DISABLED = 0,
>> -       RX_STATE_HIBERN8 = 1,
>> -       RX_STATE_SLEEP = 2,
>> -       RX_STATE_STALL = 3,
>> -       RX_STATE_LSBURST = 4,
>> -       RX_STATE_HSBURST = 5,
>> -};
>> -
>> -enum tx_fsm_state {
>> -       TX_STATE_DISABLED = 0,
>> -       TX_STATE_HIBERN8 = 1,
>> -       TX_STATE_SLEEP = 2,
>> -       TX_STATE_STALL = 3,
>> -       TX_STATE_LSBURST = 4,
>> -       TX_STATE_HSBURST = 5,
>> -};
>> -
>>   struct ufshcd_dme_attr_val {
>>          u32 attr_sel;
>>          u32 mib_val;
>> diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
>> index 9c168703b104..bf063edc284d 100644
>> --- a/include/ufs/unipro.h
>> +++ b/include/ufs/unipro.h
>> @@ -466,4 +466,23 @@ enum {
>>          CPORT_CONNECTED,
>>   };
>>
>> +/* Tx/Rx FSM state */
>> +enum ufs_rx_fsm_state {
>> +       RX_STATE_DISABLED = 0,
>> +       RX_STATE_HIBERN8 = 1,
>> +       RX_STATE_SLEEP = 2,
>> +       RX_STATE_STALL = 3,
>> +       RX_STATE_LSBURST = 4,
>> +       RX_STATE_HSBURST = 5,
>> +};
>> +
>> +enum ufs_tx_fsm_state {
>> +       TX_STATE_DISABLED = 0,
>> +       TX_STATE_HIBERN8 = 1,
>> +       TX_STATE_SLEEP = 2,
>> +       TX_STATE_STALL = 3,
>> +       TX_STATE_LSBURST = 4,
>> +       TX_STATE_HSBURST = 5,
>> +};
> 
> Suppose ref RX(TX)_FSM_State in mipi m-phy speci v6.0, table 50 M-RX status
> attributes. you add ref to mipi M-phy to let reader know it is really
> defined by spec, not dwc implementation.
> 
> Both value are the same, why need define two copy.
> 
> Frank

Hi Frank,

Thank you for taking the time to review this patch series and for the 
feedback!

The reason the two enums currently look duplicated is that they 
represent the encodings of two distinct MIPI M-PHY attributes, 
RX_FSM_STATE and TX_FSM_STATE. The specification defines identical state 
encodings for both RX and TX FSMs, which is why the values are the same.

My intention was to preserve the original approach and minimize the 
scope of the changes in this patch. Since the existing code already 
treats the RX and TX FSM states separately, I kept that structure when 
moving the definitions to the common header.

I will clarify in the commit message that these encodings come from the 
MIPI M-PHY specification and are not DesignWare-specific.

Regarding the separate enums, I can consolidate them into a single FSM 
state enum if you think that would be a better representation, given 
that the state encodings are identical.

Thanks,
  Larisa

>> +
>>   #endif /* _UNIPRO_H_ */
>> --
>> 2.43.0
>>
>>

