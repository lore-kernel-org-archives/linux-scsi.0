Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013047.outbound.protection.outlook.com [40.107.201.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103FB41D12B;
	Tue, 22 Sep 2026 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069729; cv=fail; b=IMfu66/rYgXW+++VAnz9biJPaKfdLyYRxjUXJFiuhHh+pXxeLvAIg3g255gIDWBsMsPoFwIZmiWM44iePwv9445eTn66tvxwmHzWUC6e5AOYdGAxXAiLkEZhIrDdSj6DewooQRvEvJqZvY7yQ5vNAlxtymPg0hlLn7qWbVAtFGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069729; c=relaxed/simple;
	bh=oCh/+Tc0oRiTe9zWz3F/rTX35lOJqxblQX7VGYzNGmA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iFNr28FzZBU1WXB9AQVVyrhnjIsZg/ET/r1NcZVITARGgcoDEZYubNe6KtcvTmUn1G5cpUcqsAkZQaHT5gD83DA1GEDGfVCu8eIHChVFAL4Hstr26EaRhQ3OCtXYFQkg45m7ZFBRCeUrKZneGovotPp5ET69F8wOofStpb9p0JE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ezB1PNkK; arc=fail smtp.client-ip=40.107.201.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ezB1PNkK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r9iQznkhuaUEdx+xzJBIFdeYxOVwaSrq5Z+7sdpEsUaeCOfNYFQt6d6rn1O7GvdJNHkHRxkO5lePVAXvIWsgg8pqZw+4OofkwNozxmrxZjdcIGSGmBATa5bqtsirsStFWaatK2gzrOmFPIUV+G+S+x9sizmq32gfyQu4jS/aHlWHCUDBBdoY0eiQWr1PRfu9lH8u2ZKCwqz1JsY/j2Ylw4XDLWKwcRZnUM7ZWvcoqp3Qhf952oUPipqoSIdYWAcb+4OR+zKPCqcEKCaQX4VZBRsEcNoP/GdDTUbMFMIhh0of5gC6LXdMVmnlLjmT64zz1U1CHke7YQJC6tcBecpnOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K405d7o5VVow45OwohoawpbJK4JpzAA6ZIdtGKmiQ1c=;
 b=ph6Av32s/SFMZ7lAQbGATVl/ei9JL/z5RUjmj9etry7hqRnvSOkxZP0VhPaiJGbi5BJgjNuuF3OAxuJHm/oBKuLnNHvDbPAGzCKm1lUW9Hf7nbZ7lNO0r0+9jcMU6pSn4ShtwzYOj0ukz5Fusj60D/Doixp5WOSt+g74vbvq8EWMkCdv4q8Uq1t1ECu5G28t49zcHxNzWg8eiZ++eSKdRffhmFzpZiVHhPBvVaoCwqamVGkf7ReGocQBK20shl5IaBeHiy2aSB/Z1tqY8cHX7LI+HWH5Vnc4eRzNDdzDgQJQsih+lLyN64Z0+82i9VwLV1/uY2kFYbkR5xdcZ7lYeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K405d7o5VVow45OwohoawpbJK4JpzAA6ZIdtGKmiQ1c=;
 b=ezB1PNkKGarKa/0c8baMQPCnzJoIGUM1S626Qlm/uGS6RAQQ8BUauUYfsa0cZ6cF8I2IMplKFjID5QQ0jkg3bAA6Q5CUH7E36Me8pzajzvxPhCbK+Vuf92KHAT3XfBEDEBQcDhREqp1BQKe1tHvdnPECbIn1Ow/mSuc/hsHqgtvtLhbXZ4Of4dchdngJz52Lp/85YKIhQLhujw1EDKHce+wPfF6G3ncdDBu2h6AXpOBF64z1IMWSHPdeFXwilJqnNQiBpm9mVTit+C90vnkextIH7eDSpzhXgv99tlOPIdJ2nunsqL5Ba+4BeSzhZxHwmxxwyFl+SObN9/1UNynNOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14)
 by DS1PR12MB999187.namprd12.prod.outlook.com (2603:10b6:8:495::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 09:35:23 +0000
Received: from MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76]) by MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 09:35:23 +0000
Message-ID: <9145429d-95c7-415f-8e54-027818ef1251@nvidia.com>
Date: Tue, 22 Sep 2026 15:05:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
From: Kartik Rajput <kkartik@nvidia.com>
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel
 <p.zabel@pengutronix.de>, Thierry Reding <treding@nvidia.com>,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
 <aqFqhNA50674GtPo@monoceros> <45a04396-c6c1-41f4-ace8-0ee0ccbc50ad@acm.org>
 <aqKOipmg5V4oqZlB@monoceros> <63f41284-a9ca-4d0e-ba34-096712f27b59@acm.org>
 <aqKus9TnDNm3Yt8Q@monoceros>
 <f6cd2cb7-48ef-4f0d-83d5-0c2beae5aab5@nvidia.com>
Content-Language: en-US
In-Reply-To: <f6cd2cb7-48ef-4f0d-83d5-0c2beae5aab5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYP287CA0051.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23e::28) To MN0PR12MB5716.namprd12.prod.outlook.com
 (2603:10b6:208:373::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5716:EE_|DS1PR12MB999187:EE_
X-MS-Office365-Filtering-Correlation-Id: e936afc9-3161-4747-c95b-08df188cd38d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PwpA1GsyejZZWTQoOfLCql6xcDnDQsfyzR8N7NCBAC3sEX61oLr39l2HCbe97fGaILgI5XGzNqWlJeeXnUre2f057Xd8R29koLYoolIXrv545CLpXMFbzuAi4IRI6L9ZyoX6SaQrhjX1wtRXNy/asnbLUEjdkgn5Z8JqaFhGzALMH+EN2BclBVH3g7kmNEzg3WfQwe16ymJaHRKXnW+lc0S9XuA0sH6tvjLzq4+4zsWR6yTORgHfFSUrniDxkBZKUmhWVTsLOWQAALsjjXTwO7wIWvjTkz6hRIxxiLE9gpBAJ7p9OMxnev4cXZmfcHuRAWXiUDGdsViTPM2f5O9pYFIyDUT2L/d7LPNiDNAETOmPFWVuyVSnEwU+qUWL4u+RWqViPlYkVkYhOSSuO1TGxQuQBuC5IZZBbwt8VznZkBRS5wE4WC0SH3ghWBdcrgpE2RxKXz5yd2IiA4hNmjGsLW9fs7fk6U1mCtzpfGWpllwtLC8mdtmm4jU3H/Yng6vHNu9pk42ziREhG94VaLvVqVE3f/jVf8S380oXVwYh/xoKP2W84hYIwX1mCgoSkO8cIM4nFtKgC9eYU7cEdZhDlKCMRDPrJlxaGa78OlxaxQvzE0/wq5OQAiM9qzfMiHbliFvGnF3A9+ydEJWyX+WAzWYjUs8tOLr6k0NwR/Otu90=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5716.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3lPRzQxbmw1aTBkZW9VQjB4Ui9JU0dLRHdHYk9uYkRTR2hYOXhLYkJLSTRr?=
 =?utf-8?B?UlBDL1o2YlRxRFFyT04wWmFXNmlpYnpwTmIvWFhaSmFnbURKRXI4azg0TnVT?=
 =?utf-8?B?VUZhYm5LT1gwd1JCT3pXeU1PZG52ZzVIYWJrWTYyREVSL0t4NGkrWnA5MUl1?=
 =?utf-8?B?YjNTMEVHQnFXZVpmN2E5SXE5MGlJZU0yRmxxeHpSTWZZRzVUZmZHNjJPbzhu?=
 =?utf-8?B?SlRmV0pCZWdwY25GZnErZldTb2c5NXJkTVBvaWVtOXdXQ1pnMUlpVGVoNmJF?=
 =?utf-8?B?dVRkeG1ZcEpRTnAzT1F2MWxkcVJqT1AwZy9YZk1TN3ZkY0w2MWZkdko1MndI?=
 =?utf-8?B?VVd3UEdVNlJDRzR3cSt5M3V3eUJWRGdxR1BML3ViR3Nmb3VYNmpUVGpFT1Z4?=
 =?utf-8?B?Y2JhZ0tBY01ZODZtWi9peW1GaU45N1NzejdWaHVwQ3VhbW1LU0xIWHhKTExv?=
 =?utf-8?B?ZTNZME8vSXQreTUzOTB4Qm5rT0Z5WG5LV2VWWlBTeHUzbENFQ2RUbXlpekxr?=
 =?utf-8?B?UVl1YWNFbHRBQUxNM1pBWm1EQ3NBa2xDY0gxbVBYVTk0eHI2SE1YbkJJZkdm?=
 =?utf-8?B?dUE2NVA2ak1taUlRV1ZOV2ZFZ1BNd0pPaFlSMFQ4ZEszY2JVTWZYMVIzVTRT?=
 =?utf-8?B?Nm5lRlZLVzN6cUFidXVoRC95aUM0US9mbHg3TkpzVFF2UFR4OElFd3dYS3pK?=
 =?utf-8?B?R1d6SjhMcytOVVZ3eE9iOFAxMTZaOHMyTXI3Z0NTUEF0ZldpNlEvK3U1Nk1J?=
 =?utf-8?B?RnNnQ041d3JheGlPUWcrdm9vUVZMWVFlcUNWWFdnczB3T3Q2M0dqbmFQaUpz?=
 =?utf-8?B?QXBlSXRyVUtoY1VkeWhGOEVtTTQ2Y1dYYjk1Rzg1bi9iZy9SZm5GMWxSb01Q?=
 =?utf-8?B?VEExQXpmNldKdjBhZE1lUDQvSWdUQUE4aUlkNVdrZmxUZmkxVWt2bGh1RjJT?=
 =?utf-8?B?emh4VlBONTZVM2w1aElNUVZoVXpVV2V1RFB0bDdDSmtqVXdhTEYycEJvbG5V?=
 =?utf-8?B?ZWJ1RFc4a2ZtWFdIS0pxaVpqVmhzODNvSWg4Q1I5cW13bXVKYkEyckJFc0J3?=
 =?utf-8?B?SzluQWdVbzI1SW5iUjNFZGVncExjZWtUeDkwRitpaERGb3NicndjdzZjWHdG?=
 =?utf-8?B?aDNMb0hWRWV5ZFBVck56YU9DbVpWaTF3M2Nxb3hza2cwKzc4Nlp1OHYrMlBF?=
 =?utf-8?B?Q1UrWkdDaXVTWE5FVzM0MnVTTDc5L1J0TVc1M1BoNXFFaVJscDBjUDV6Uzhn?=
 =?utf-8?B?WXN0Nm12WkxEMWNqbEtmL0kvdVFLd2pUd0tJZGlKUUhpOUVTS3Mrc1l4VHhr?=
 =?utf-8?B?eW5ROHdES1NSU0hsazcydGpxMEY0NFFUb2lPNTEyZ0s3bGE5eStYb3JuTFVW?=
 =?utf-8?B?eTk1cWdHNlU2WDVORGkvSzdZV1U4YWdCVkpXUnZIb2VocGo3QTNmOG5SUjEr?=
 =?utf-8?B?cFRxZC9TV3FqTEFsOVZZNExzTHpzWUs0UU5mQkxQZ2tZVVY3eFBuVnN4bSs5?=
 =?utf-8?B?MVczN3lkUkNrZHRkaE1uR2o5MENacURPTHBRS1puWGJwQ0VvZjZIdURqeVdO?=
 =?utf-8?B?RlRzZXNPbHpRK2w4WXgwVlBNRkNVWnpRaFQ4enBid2c3d0hXMzNVTTR3dXQv?=
 =?utf-8?B?YXpJbUdoaDd5OVo4cW5SUm1EMjA0aExaT0pveUdTN2hNc3BJNzN4SlJqYU80?=
 =?utf-8?B?L01sNjRqV0Jjd0pCOHhwWHAxa3docWtXMEY3VWphWGEzTUcwUFBsRnArWkR1?=
 =?utf-8?B?Y0hoNEp3U3NaQjJ1bE1pa0prRzlTT2c4QzFZV0pFOUdFeU04dDFyaWREWWR2?=
 =?utf-8?B?WnYwcFUvL0toVFpFVDlRTzdDZEl6Q05YaE0wVWdHWnZnSXEzZXh0OGUxS0Vj?=
 =?utf-8?B?SUZGbzlzS0ErRGRURzQwQ1pock9HRW0wbzdGMWdRZFVzZFVNMWVmUUpFSGIr?=
 =?utf-8?B?bzJxM1ArTlZnUk9NZGk5K0krQ1VRMlkxZmhCZ1B0SHNVd1hjZmhKanhid0NJ?=
 =?utf-8?B?elhTLzl2OGJpWEI1blJ1WHJ0Q0h2elZJZjVldVB1YWFwZUF4WDJ5MGVRUkhH?=
 =?utf-8?B?dGxEa1NMRXBtcm1JdG9mWklvMHZ2MzZZQjlMQ3g1bVU3TG04Q0ZzL3djRGhi?=
 =?utf-8?B?eTc4T1J0S0ZiNnNFNzVBa3BFYklFbVo5by9ncWJZMEJoTEtwV3lSNm9NVUt2?=
 =?utf-8?B?azhHREs0YTR5dUJROEtWa2EzL1YwazFibTF3NldMVnF2ckdpSlB2WDRKQmpE?=
 =?utf-8?B?VFpaak5TRGVzdlBmbGZXaXB3SkljM24xdG9nQm5RNURuSHIxMDhoTjVvR3BY?=
 =?utf-8?B?ZEJ4NFJyUHIyNEZsUVVkeTk3S3F6QmVVaUxqRVAvZ2hKT1RpM0tadz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e936afc9-3161-4747-c95b-08df188cd38d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5716.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:35:23.5285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qk2Hx/h3JoSpbK/jyyG/2MfO/akkDb97fyee4fQvT7OnSP00X5ElDVOiyxbZgL2vpLnBIyM8w8CsO7R7euzwZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR12MB999187

On 22/09/26 15:02, Kartik Rajput wrote:
> Hi Uwe, Bart,
> 
> Thanks for reviewing the patch.
> 
> On 10/09/26 19:22, Uwe Kleine-König wrote:
>> Hello Bart,
>>
>> On Thu, Sep 10, 2026 at 06:09:30AM -0700, Bart Van Assche wrote:
>>> On 9/10/26 4:21 AM, Uwe Kleine-König wrote:
>>>> What makes you claim that {} is preferred?
>>>
>>> There are many more occurrences of " = {};" (about 7000) in the Linux
>>> kernel than of " = { };" (about 1500). Additionally, clang-format
>>> changes any occurrence of " = { };" into " = {};".
>>
>> clang-format does this due to
>>
>>     SpaceInEmptyParentheses: false
>>
>> in .clang-format which I claim we have due to prefering no space between
>> () for function calls. It seems only newer clang-format (starting with
>> version 22) can configure that individually using SpaceInEmptyBraces.
>>
>> And IMHO my statistic is more relevant because we're not talking about
>> `= {};` or `= { };`.
>>
>> But I guess this is all subjective. Having said that I feel offended
>> when seeing "= {};" and would ask to add a space there, too, when
>> spotting that during a review.
>>
>> Best regards
>> Uwe
> 
> ACK, I will use `{}` instead of `{ }`. Or if you prefer, I can use `{ /* sentinel */ }`.
> 

Apologies, `{ }` instead of `{}`

Thanks,
Kartik
