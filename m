Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011018.outbound.protection.outlook.com [52.101.129.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC572572;
	Fri, 27 Sep 2024 02:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727403349; cv=fail; b=JuvDDO0H9TggBuDlxbysVU/CBAJE+JYyCwPR7MNLRzYggTMDrcXwR+T24Cadx4kDVbRTeYZo/Eve2FTgZnuHUizPD7A0oSDgLbe9R/m6xaZDeM0dRYf52nll0SwLRQcdhGstOqdKDnAPkU1+DRa7prQ5AYjRcXtz0l2JBBf89gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727403349; c=relaxed/simple;
	bh=BjOuuCyKMoDoXUMQ0nSl7GyTwqB+RX/oy4OeI6kb0Po=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q/Dv5Z1ApP623PBVpUwUAFmMIkigzHR9htUhTcUuiXqHrJhX2WUQbDftyBU+BDPDQllw0COiI2Kv92+JdZM2Mfc4suS+zWwO0QOsoPyBdPV8N5MJpNdGSp3KwPyhIND6d9Wiafkd4lja4ISU4b4t/BgobclgBNZjWgQod0z7lDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com; spf=pass smtp.mailfrom=oppo.com; dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b=nBn/WLYC; arc=fail smtp.client-ip=52.101.129.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oppo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oppo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=oppo.com header.i=@oppo.com header.b="nBn/WLYC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cR3pfEfwUvJobqDssoJr0tGUvu5QK/D+Eopleu1L2B/8wa73rrcoW7aCVhfUfqrxyD+T8nwl3fJuAnTteCksyhRV88psAkUTnN+1DEioXKqraAT2AB6Aaht0YN1GffAS7mWp+eZ9aYJpJHmUDlezK8e3odydKo4HKKtaDyblbMN/mWkvVyIFKKkS60+k2QrRlyFi4XTcwktT8u7b4tsr2PDF1REtJt1trnUKRSbN3oSwotU/WrVWtDMKQi2JJl4s3Rpglj7FfX+LWso1F1SDSwxMkjxSxuo2oXyh1kATskA8ELRor8egy5Wm/xCz0Zxf6kOw+9y6clYLjM99B0PEFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSiCF1jYzw9xLlcvZ7nPR+VfsEBu2ejCrx1XRY7luGs=;
 b=QMJkdKthJL+SAFG68UKBlddGxLCbWbzNYmm6ryQDUYhulFjhj0AOwohQ6GtyUSaeCjAzpWUpAC0YTfsEM9cgGnJ7ue4ryBTaTGbMFvtAyFGNvRcrzZN+DY5CQbXRBh4Aw+XAfFlxA6w75jlSQnK0a4dFyeckAFYKdVsKydjxaFcYHPEbDMORJO/Vn2U1xaD0LTPM8sxxMh0ObQ9mZFYIOAMIgsU/RzugpLGa8p9Tfxt5J81f7c0lTiUfdQjehva/+gF0ZR46YB9GNqM9QJ0qfHCL+FKKm0SrblpBqSOfoi1ZeJpL5eRrJM16CzP2gSFQamG/uMxaYeZXcTbtS9xMvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSiCF1jYzw9xLlcvZ7nPR+VfsEBu2ejCrx1XRY7luGs=;
 b=nBn/WLYCJE14nJ6cD8uOvma+PiimTaWbav/ZhFLHTg7oi60HAncNAYobJRiMInLumD9p079pJHN5lxbvvqOAaHsE47FpQqOHwZyUpNZov3fU5YXzWXyBu/JRj5PBo0VNzv5TFnOEQj9+DchkLAwP42/RWnRi4fhJ9KXi5JQgKJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oppo.com;
Received: from KL1PR02MB6662.apcprd02.prod.outlook.com (2603:1096:820:105::10)
 by SEYPR02MB5511.apcprd02.prod.outlook.com (2603:1096:101:50::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.31; Fri, 27 Sep
 2024 02:15:43 +0000
Received: from KL1PR02MB6662.apcprd02.prod.outlook.com
 ([fe80::6e0b:23b9:808d:ccf5]) by KL1PR02MB6662.apcprd02.prod.outlook.com
 ([fe80::6e0b:23b9:808d:ccf5%5]) with mapi id 15.20.7982.022; Fri, 27 Sep 2024
 02:15:43 +0000
Message-ID: <da300eb6-7a97-438a-8831-5564c8a36e0a@oppo.com>
Date: Fri, 27 Sep 2024 10:15:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi:ufs:core: Add trace READ(16)/WRITE(16) commands
To: Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
 avri.altman@wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>
References: <1727232523-188866-1-git-send-email-liuderong@oppo.com>
 <7c760b76-aba1-4e30-8966-17ae81a7e223@acm.org>
From: liuderong <liuderong@oppo.com>
In-Reply-To: <7c760b76-aba1-4e30-8966-17ae81a7e223@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To KL1PR02MB6662.apcprd02.prod.outlook.com
 (2603:1096:820:105::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR02MB6662:EE_|SEYPR02MB5511:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c12280c-bd11-4865-0b10-08dcde9a4a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3I1RmlZL3BvOE1EQ2dUNnJDVWp0d3JYTEo3SGo5bDQ1ejR6ZnkvUmhRMEtv?=
 =?utf-8?B?aTNWaitKNy9JS1FBYnJFK3B2RmowM0JpUUlQMnZjZ3BEcXhITk1BZGlBYmZw?=
 =?utf-8?B?Wk1vaUhuRkhTL2FNditoSW5abDJXazdUdGFZanZnYkZKeGxyRkdpN2M5Q2pn?=
 =?utf-8?B?bFFobkhQWUk5WDh1VldHK0ZMR2ZFWDhubXJEcW9WOTJNNzZwTFk4bGFrdTBU?=
 =?utf-8?B?eWgzY2l2Q1NtZ1pNNDB4YmNrTGc0QVZLbFpTcDdJQUdwK0FVVjhjeStlaXlu?=
 =?utf-8?B?YzhwWUVTT1ZCMUJmZGpxMCt4V05QK3IzaGNLS0xYRzVSdGR0Wi81MlR3eUFs?=
 =?utf-8?B?Z2pGcWtTaUpIK002NWVueFVRRDR6WDVuMG9CQWI0M1RBaE5NMzJzK0tLc2xn?=
 =?utf-8?B?YWc2K3VHcUhOcVMzUlJZbm5yNUFyS2VyY3BiWUhUNXlmbUpUSnRaMHVydDJF?=
 =?utf-8?B?VHQrSXhPbjdlRHZ3V29CalErcnNlTCtMRFY2cG5aQ2xEK01HdzR2S1pwTmZP?=
 =?utf-8?B?T2taa3ZoaVcvNGNWSXhuOFlYUkFQWkZ4aHhjRGdBTmpKN0p0Z1Vramp1VmJo?=
 =?utf-8?B?UEN2QVA2b3g2UFJ4cWJEMXZIT09vN0NJRmUyZExiMmFXbzlkM3lkL3VrZnRY?=
 =?utf-8?B?aDk2Q29RNmJDQU0xWmE1UCtGVTRsNEkwVm8vdjFaTHFrTVZOZnllOGFaVVVZ?=
 =?utf-8?B?eWZ3QnFUWFZvTERtUWhlekpNSkdSeFlyNitTa0VTY1lpWnprMjFZL1M2SjRK?=
 =?utf-8?B?d0RNMktyS3V1OHlXaEpFOFBDb1FGMlpmMzhBa3k5RUptcFVqQWlrYzJqczdO?=
 =?utf-8?B?d0VtQkxnQ0Q5ZGNIZHorNW9BQm8wUnhCeUZxeVZJa3NjWXVZUEV0SjRlMllj?=
 =?utf-8?B?UlA4RVBOcWY2Rk9GY3NZN3RQQzlDQ3h2MitSTWhBdjhmdk1nbGdKTHNkdEw5?=
 =?utf-8?B?TjlDNXdUSk1OYTd6TkFacy9oVUk2N2dwdFVPQVhJcGFUNXJuRWMveDdwOWlQ?=
 =?utf-8?B?SkloWCtZbmdseFBjenpUdlpsYnlscUVKeW45YUQzdG92VWlWSkhYV2RLUjR6?=
 =?utf-8?B?QTBCTHozbVhTSTZqMzk5eVVQUWlEZWc3U1hHR0dRSUFGS3BFeWlVSXVEMU5r?=
 =?utf-8?B?b0EyR2tRTndTV1JWRlA1dGZxT0xRbXJHSG9TcHU3dXBJcmwxdFlFQnpRUXJF?=
 =?utf-8?B?RE8vMWRLWWJLbk9rOE81eHNYSFh1R0pkMW96MFo3T3QwN2tMUEhwc0FUUWNa?=
 =?utf-8?B?TUlPS2ovbjhWN0hmaDl1VWJkSmg2eU5FRytaTWsrUGZ6NDFpT3ZiaW9VdFZy?=
 =?utf-8?B?TEV5S28yYm5WWklJR2swKzFCQzdqQnIvbk1qakg0eGhKYXFHWU8zbTlxTXNt?=
 =?utf-8?B?M3lUVExWejgweW0zZHRLSDROT3F2azRMc1dZbmhSOHYrR1FoMHRtWDArRkh1?=
 =?utf-8?B?TVI0RGVSQm9OdDBlL1c3MWhTc1pNajJkbUVzbHZQREVTcHZoRXE5NElaTFEr?=
 =?utf-8?B?OFVSYWtrZmhVQXNhbCtRT1d1WjhLUEpqTlAzek9yOEsyTzVKclViSzUxaDJK?=
 =?utf-8?B?LzBCbzVqWitlYWRWVk9QV2d0RlorbUR3SHp2WlYzWUNra2VqckFtdGFpKzNp?=
 =?utf-8?B?amhveHo5K0VjS0hOUWQrcTRpL3pOU2NlQkJGSzlKRk4zZnhUbVBSR1J5dFBa?=
 =?utf-8?B?SmF0NHk3b2JzbVlzeFRpL3NtbWdmNnN6YU1iTDQ4Vm53Y1BFeFlZQXpRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR02MB6662.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTRxOVdrL1Z1MjFKRTlZMGRhL0VJcnVQRWtTOGUva21xeG9vVDZSZytRVlZM?=
 =?utf-8?B?Mm1kWUx2OEJadlUvTW5DREFrSnMrc1VWUUdKKytCZE4yYVNTOS9VUGdVUExQ?=
 =?utf-8?B?Nm5jcWdiR05RZmxPOFlYcWVod3BwMFRiUUdTeEJoVkpVUkFKZ1FzRHR5ZnNC?=
 =?utf-8?B?L2ZlT3VFUUN3SUE4VFpRSnV3NjlzcWVaVkxEeTBTY05JZjNyZDlPa2hrTHpT?=
 =?utf-8?B?TVRaekREUXdDS0lSbjNaTE9CQmlRd1FPV0hFOW56bXNNblpvbVZLR0JuQ29O?=
 =?utf-8?B?dWZCbXpxekhWUHhpUU9IRVJWTVRydktjcmdnMWNoRGJlemcrOHBTRmdyMmlk?=
 =?utf-8?B?eTUxdmlIb2ttMnVMMUpWWTI1MXpUa21BekFIbHdhblZTTFBkZGo1enRnMGFq?=
 =?utf-8?B?YUZ2RXVUcUlZdjhjdWRnNWU0Zlc3ZHNmSkZZV3ZWeWhxUUJWUEgzcUNMeHRs?=
 =?utf-8?B?ZzFxdXNzTjBkRjhmNjR0UllYbWQvTy9tMFVlNFZ0L0tQZGxtTmF3WWhUQ293?=
 =?utf-8?B?bU9aa1hjVWhZZmVQajQwblhENnQ5aHlZQWhFRlFsanlTWnlFazg1VW5LeTRV?=
 =?utf-8?B?MUhlYWNtSDN0SUFlazIreFlJN3dUd1dBWnRBWE1rL05XRTltMmRpZ1l2dVNh?=
 =?utf-8?B?UjQzSFBwTUMwWHJBY1BVaUNYb0tJZWZDcWxSblM4SE5yZFlZQVhreG55M1ZI?=
 =?utf-8?B?ZzZRVlRXQjVYNmRXV3hOVEttVkdGc2lRZ1QrY1RHU255dXd2YUhJMFlKMnJB?=
 =?utf-8?B?VEZjQlljT0RpNzRwSDBQQkc4QUV3dmhEQkVKMFZOODJkbmlpTSsxNEpGNGUz?=
 =?utf-8?B?elhSZFhXQnZ3Qlowc21UK2hmQlpORjVvbkdTNi9Wb3pwei83TFpPWGVPNEFl?=
 =?utf-8?B?UHMyZlc5TUxzT3hyeHMyVU8rN1RjU3RtWEZQUEhzdy8wUThaVzg2MGR6U09H?=
 =?utf-8?B?cEgzV2hQcW5KaDEwRlBnTy9paUEwVVFYcEdRaElIT0JHamNLSGQ0QXFxRi9B?=
 =?utf-8?B?cDdhZ1dBQXVvUCt1cC9WNTFkMjkxQ05TWTUvSUR4Unl3R0MxSVJaWVJNNExo?=
 =?utf-8?B?WE5iQmRjTFFtalkzMkNRSkxHMmh1MDI3dWo0aUlURTBUejZLd2pTbHVNbFJ0?=
 =?utf-8?B?UmFITHZSNVpxb2llKy9XRDQ3UnZZMitQcVRrZUJrZkRqYndlR1pjWWVwTW4w?=
 =?utf-8?B?RVZXMGE2d3NjKy9PT0tsWFJqcllYd0NSR2toWXBjalJ0SFRBMHJXei9WcW1x?=
 =?utf-8?B?YWFCaFdOdmptcEdIYU94ZDkyRGJBZ05mNzFDeW9sT2k0dFp5NGsweXVvcXdu?=
 =?utf-8?B?WXJ3Wjk0dmZmSGtiVHc3eFE2UnVaQ1JsZEZUeGoyVTU4V2xHSmpwQXU1eGNs?=
 =?utf-8?B?VnZhTU9OQ0t4b29FUStwWld2czRUbWR3ODgvSXNER0dQMlhKemZLbUdDQnVk?=
 =?utf-8?B?bjJiVGYySFpiZEErSFQyQ2FMWFZTTHlMY2ZsZWtiVUZkU0ZET29HMlEzTU5P?=
 =?utf-8?B?aFFZazRrVlhlM3hpVS83QWVOc3NwUFhKR3RJMmlKbmlhV1hpV28rdzNlZVIw?=
 =?utf-8?B?RWFQV2VYWG1RYm5hY1RyMDZYdWt4UVZtQlhCRUh0ZU5HNzVaeXZidXdvOWYr?=
 =?utf-8?B?cGI3Q2lKSDExUzRuRjFrWDBrYUhZTEpubkcyWENjMUNkdDRST2RCQzhBeU53?=
 =?utf-8?B?QUp2MWxHaEF3NVVXLzJoNzV2MEJFbG9vKzBsL0hmbVJXMEVrendoeWZ6Nk5I?=
 =?utf-8?B?ZUZlM240MnY1Q1lCNXVVT05paUpFZ3YrVU5GUmFKdk9rdFdPNUkzN0I5bDla?=
 =?utf-8?B?Ym5FbE1VbEdmbEdKL0VXb292Umt4ZHdIYkFGOUpmenZaSnd5MWd4emNJdG1y?=
 =?utf-8?B?NXB5OXgwZ095ZEJyWkdKOUJzTEdML2t4aEZSMnNobXFnWDArUEhXRGNzUFV5?=
 =?utf-8?B?R3hxdjNXbXZNQkhQRGJXbHlWTjlSUXhQdnRYRkdRREd0TzVRREw0MGk4aXV0?=
 =?utf-8?B?eHJKQmZ5VVJuWTR6d2tkSlUxWnlYdDBBVDNOMHFJK01iQ2xCN1ZpQXV5c1M1?=
 =?utf-8?B?OGZFMktObE5LQVBFYmZYN0dScVB3Y1FZWVl0QnRjM2pRTU0yck1TRlZoNUZZ?=
 =?utf-8?Q?TDwt44O6eQIXM13HObeAm2Kcv?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c12280c-bd11-4865-0b10-08dcde9a4a0d
X-MS-Exchange-CrossTenant-AuthSource: KL1PR02MB6662.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 02:15:42.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHfxJx/fBAnQIcnvMm5sIjnJVl6SBhVQffQ/7VfuLr+A+WQe6iwMz/wwAlhv7B0Q5A4WCrJhzSHkRbUCkVorhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR02MB5511





> On 9/24/24 7:48 PM, liuderong@oppo.com wrote:
>> From: liuderong <liuderong@oppo.com>
>>
>> For sd_zbc_read_zones, READ(16)/WRITE(16) are mandatory for ZBC disks.
>> Currently, when printing the trace:ufshcd_command on zone UFS devices,
>> the LBA and SIZE fields appear invalid,
>> making it difficult to trace commands.
>> So add trace READ(16)/WRITE(16) commands for zone ufs device.
>>
>> Trace sample:
>> ufshcd_command: send_req: 1d84000.ufshc: tag: 31, DB: 0x0,
>> size: -1, IS: 0, LBA: 0, opcode: 0x8a (WRITE_16), group_id: 0x0, 
>> hwq_id: 7
>> ufshcd_command: complete_rsp: 1d84000.ufshc: tag: 31, DB: 0x0,
>> size: -1, IS: 0, LBA: 0, opcode: 0x8a (WRITE_16), group_id: 0x0, 
>> hwq_id: 7
>>
>> Signed-off-by: liuderong <liuderong@oppo.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 5e3c67e..9e5e903 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -434,15 +434,19 @@ static void ufshcd_add_command_trace(struct 
>> ufs_hba *hba, unsigned int tag,
>>         opcode = cmd->cmnd[0];
>>   -    if (opcode == READ_10 || opcode == WRITE_10) {
>> +    if (opcode == READ_10 || opcode == READ_16 ||
>> +        opcode == WRITE_10 || opcode == WRITE_16) {
>>           /*
>> -         * Currently we only fully trace read(10) and write(10) 
>> commands
>> +         * Currently we only fully trace the following commands,
>> +         * read(10),read(16),write(10), and write(16)
>>            */
>>           transfer_len =
>> be32_to_cpu(lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
>>           lba = scsi_get_lba(cmd);
>>           if (opcode == WRITE_10)
>>               group_id = lrbp->cmd->cmnd[6];
>> +        if (opcode == WRITE_16)
>> +            group_id = lrbp->cmd->cmnd[14];
>>       } else if (opcode == UNMAP) {
>>           /*
>>            * The number of Bytes to be unmapped beginning with the lba.
>
> To me the above patch looks like a subset of this patch from 1.5y ago:
> https://lore.kernel.org/linux-scsi/20230215190448.1687786-1-jaegeuk@kernel.org/ 
>
>
> Bart.
Hi Bart，

OK, do we have plan to remove the trace: ufshcd_command?
I think if we want to observe info closest to the ufs device(such as ufs 
io latency), the ufshcd trace is more appropriate.
What do you think?

Thanks，
Derong
