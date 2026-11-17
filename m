Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794898670;
	b=w8F2b0w2RCPrt2YvPzFz/YzOhQoMUnPcPRUN17oONXRGv8W2H6De4SHWkI/yN4sQlXAa
	 PmqOC956sYA7A+6tKwGPH5NF1a7WPCcpFP9xAxlp2YmYT46HhdJ6jeh9pTi2/+02rdMC4
	 LL6ZuUT3YHfah+4YsSve5ngJGk63h2Sh7qRH3J9+6ZL+sp8YrcV8J0HsAaeb13BOeKL5R
	 yVJFsrRIgQ+9x7++HygRsP0G13q/FOlNYbpd1X4umaZMjiLsJ2kzzvOI36yjZIjXUPSPq
	 rQD2MAHgkm2UK0yZWqCz0iT0RfhCOlTNmOrrCuxfNs5m4whJuH9TrQSycKFtZ4RnXcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898670;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=xdt1FTAaRtJbcIjMeUHLxWBoTWbairiNtn5rIIaLT+8=;
	b=mKoQ9lXdROthATzx4dWXJLeyv8SzqqGPcEN3sKlBf4DtU5vZqlOtgRUcfgDrxQH617lc
	 qI8fUBidS3Q+4JTlDZRNCi6b+lp5TGOGwkMwxVbWbpC93xBvGogO/RUvvmPE1pHvhv2iy
	 l+EUgr38Ckw4m7OAltT2/s43YGYcs5W1f/J4WwXgrD9lWfRpNLn/U67WASTWKSxUvh3A4
	 0UY4X0PjYzo4qi2/eNpILHF3124+oOw7GYL445aZ11QNxoMKym10xsMFBpyakpKzSIm3g
	 E7hD+OFcp4DsAM/YB7OoSb2JiWVqhVxzxdxlHENJHxM1kZUfLL1IdM+b8vSSrMUOjbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="O3N5Je/E";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.71
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2567606A31C;
	Tue, 17 Nov 2026 06:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2567606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=O3N5Je/E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=krHTaESYo5LPQxzf6w4lteqx+dhc2o/Fyts88MK+/7rF69yuyi2waJ/qf1Q0amb3La+KjWdu7ZHuUV4xm96n5i/ugqtcvCwdJlXeIQgmEzWMDcWodE2PZ9Dww59y6ZzcJ8hX2p/Xegj0s/v99DGBQ4kSwz1GrLWXkfYN99WyHjLO9UdzMz655G6q0cdetM6pDwbmAu21zNX7hV9r+ZztWLvCbiHS9rvoKILVLQF17lG7PDDEe0XZCDH+7QIreWdWCHo1A5qhKaskvVesi3IZ4PmeoqXo7/GS0Um6EuTSAZW80L/3m5zOpJvRRQ9HGOL/Cr2pGE6fh4egzDZP7ji5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdt1FTAaRtJbcIjMeUHLxWBoTWbairiNtn5rIIaLT+8=;
 b=kop6ERQjru2eb1ll5YMEBjSl6SMF5BaWGdsQfRiI1v6NQFjJ3u4HmSn0Ko8S9Q59/pUS0WYkHXwnYV5jocUTDvc71Ma83EEQ+hsN0IiuKBnocL+OiNNu/gjfpjKhwydxzm9dWUBqwsFYCjspPNPVX41ipM9d+m8yT+t6YwFdagZxvtQL6ohWFPUd2iJW63KE6gwwryW4Vr0/5nTHxy+CZmRxHjTOTu72agD1Fd+VKnGSMgTwKVEVv+bn9ZM5gtCMXi+xGENzgWNoArP/AwI3/rJ5LP4HPiCh9Z9Tk8fKWApsZGz0cTaLDAZD7hf9KtELEIE+jp2TRGKe0sfGk8ao1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdt1FTAaRtJbcIjMeUHLxWBoTWbairiNtn5rIIaLT+8=;
 b=O3N5Je/EZAY2Q3eBNaKX5hdhpGp7Tih2FcyEyw7sjpN285XXn170M2R1h9gub6LrmPg6PXfwN+HDTLq5paQ7wq6pF6qK90fVyN9mESajlsm5DoP0EMrmxRjdvKSxBeGOe3+LG0IBOJR/f0CIAi/hW5fZrFH8tulnLPi1piE1jx8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from FT1PR12MB863618.namprd12.prod.outlook.com (2603:10b6:170:e::18)
 by IA0PR12MB8908.namprd12.prod.outlook.com (2603:10b6:208:48a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Tue, 17 Nov
 2026 06:57:44 +0000
Received: from FT1PR12MB863618.namprd12.prod.outlook.com
 ([fe80::9c1:e17d:1a5d:e5fe]) by FT1PR12MB863618.namprd12.prod.outlook.com
 ([fe80::9c1:e17d:1a5d:e5fe%3]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 06:57:43 +0000
Message-ID: <cca85186-7e00-4fbd-87e6-25c4155c6b72@amd.com>
Date: Tue, 17 Nov 2026 12:27:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dt-bindings: ufs: amd,versal2-ufs: Add ref_clk clock
 property
To: Conor Dooley <conor@kernel.org>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 sai.krishna.potthuri@amd.com, alim.akhtar@samsung.com, bvanassche@acm.org,
 beanhuo@micron.com, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 git@amd.com, michal.simek@amd.com, srinivas.goud@amd.com,
 radhey.shyam.pandey@amd.com
References: <20261111043840.906301-1-ajay.neeli@amd.com>
 <20261111-facility-pristine-82e76afe8d8b@spud>
Content-Language: en-US
From: Ajay Neeli <ajaneeli@amd.com>
In-Reply-To: <20261111-facility-pristine-82e76afe8d8b@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0021.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::10) To FT1PR12MB863618.namprd12.prod.outlook.com
 (2603:10b6:170:e::18)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FT1PR12MB863618:EE_|IA0PR12MB8908:EE_
X-MS-Office365-Filtering-Correlation-Id: ea2bdb48-7c47-48f7-173a-08df447813f1
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021123027099003|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	X3nevP7Lt8mRSrM4p5aP6dFy43/SaFKv+1hvnkDE4iYPDWxQJg6+6w3HVkSZJAyqzytAzzi2jpi7/80uljYee6JcJJWTulcGMCc9ViZrEDS5i16VHHmAeiCj5Ut23e/ksFmAyMIvfsFG8Q4t33oCFDsFOwX+Cj7qUczxP9nlRnBIMvqYlmVx+AHIzgvcbvYA0wDKOrr62T5EKu+OAPUOxXKhlfPb3GdUSzrvAvg8WZ2Ub/jP3PBOJjsZj5nmlbJlzAusJhGkmSedwUsXhscZkxU8egcO1x0INXbpj84EefVBYf8Wop/uLxyOC1tNsfDsTU/yepXQSm5syPkZUFaaIqjrDfF4rH7RMtS0kIFHYgTBk+2nk/ebWG02Gj2K3jOLObqrOfGWA33Hvca2QqfBAyx5pQW7ehsNmIlYb2M6qh9gmu2Whk7WE5BcmiSxSAm448YZCj4ndzXx2sI5f2yCIN1qW7OaSLe65CyeywRssyaxItAQmmbcZcCqfULzGP1W4VBp7FWEB5uFR80W8ElPOJt1zdjO12171mEKGo6SlgSXZ872cbt7c5jcDfBOoN2Ejj3fhOrmLN73aUw55L0ukigWF3RCmK7nB48eWgeo0G9NwmFUZ8ESJaIfrB/CH8L2KeSaRiycE9m5DkoiRinyk57Hl3jvUQram+smcwLeTVE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FT1PR12MB863618.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WU9idFlPbXhId1JPdkNaVVpvYmFScTNGNlNmZFVUQ21BMUhkNjlDUDc2Q2RN?=
 =?utf-8?B?QVY3eU0ycWtIZ2V2N2ZJRjFsdnJPd2xtUHVIUis5d0kvY1FRV3ZKdTZTUWNF?=
 =?utf-8?B?aW9leXYrSFJjdlRTNW1JQk9CS05BVzJ6c1duVXp0Nlk0RGlPWklRMHNmbzlZ?=
 =?utf-8?B?WW9aazZRMUFDUkxYQnByZExEdVpudDZPYXRWL2tpQXZvYlRNVkZyU0lmenhh?=
 =?utf-8?B?REJzbjR2T3U0a2drWGR5N1gvYjNHS2xURFd0dHhVVjUwbTRWNFJhNXBGUUd2?=
 =?utf-8?B?SjlNRzByL2VNQ3BqZHFPVllGWkhVNGMzbC9TbGNuRGV4Z0Y4VmlYVXE2bGpi?=
 =?utf-8?B?Nkp1d3lYVmNDaDJFazNzUmxxcFpHOEN0eWxJNDRROTZNelAxRXlaVmUxQi8w?=
 =?utf-8?B?clN2RndCbStMTGpnY3VxUExCckpNT3ZwNnBHQ1p3bk5uUC91ZUMzWXJnamhU?=
 =?utf-8?B?S3NKbWt4MDZsdEQ0YkhjdEhBTUlrb0Y4NVMwWmRFYXh2YXplcks0MVZRamZH?=
 =?utf-8?B?TmwxaldCR3NCZVBrcnFYc0h1OHd2T1MrLzdtRjlWMFdkcTFjYWxZYWh1dStB?=
 =?utf-8?B?K2JJYk1xaGNocTBMdWRPQnRlM1ZNbzlXSjRIYnExRkhNVElsL245TUExSXhJ?=
 =?utf-8?B?amwvL21BV2RWZGxQOTVublo1d056V2tTNXFjV25yTTFLcnR5ckluY1RuRWpM?=
 =?utf-8?B?MGFqT2ROVnJ2MU40WkxaSVU3YWtrNDlkQ0VNUm52VUtzRDdGZWlQTk56MGN0?=
 =?utf-8?B?MkFjV1N6anoxT3lyM3o5My8yZ2VPUHhPZmFNQzVjbVVoZHR1eDhQY1VQNlI1?=
 =?utf-8?B?ZGo4Z21HRmZoeHcvRnE0Qk5HdVRhdVFkRWtoT29FYVljQy9NYWFSVjlSOVlK?=
 =?utf-8?B?M2huQ1l3L1lsTVp3Y0VUSlFIM290c1NQdnVINFhLeXcyTGNSUWpLek54eHVE?=
 =?utf-8?B?aGU2ZlByRmZKWGpPRkNVVE9BbEp2MjdwSndyeFMxYnA5SHRVNHI0YnpSYjA0?=
 =?utf-8?B?cXBtY0lBYk02RXM2V2tCQmdMZStZYkdqUzlxbVYraEpOeUhCS3hYWmpYb3FH?=
 =?utf-8?B?Vy96cjlWQWUvUTJiMTVkL05PWVF2Vk1BYWp4SFpXeXJLbCtmalBvUnZ3Y09l?=
 =?utf-8?B?cWd0NWxuWEdmN2d5Tlo0VEpnV1hsTkNqYVFRZWs1T25GSlBYUlE0ZXMyMmNY?=
 =?utf-8?B?WnBaU0Z3bW9DcDdOZEFiUi9Oai9ra0FTZ0lreUtnT1RaSG0wK0ozVjI4QWFr?=
 =?utf-8?B?WWxPZHhCQ3VyeWFQSlgrVlFRWG5BNHJ6WDJmZ1VMcXZxVUl6VUM2M0k3bTVN?=
 =?utf-8?B?Sk1QbU5JcHFza3oycTYwL3hpM2g1S3BEWkdsdkxnNlNHeVFlRWttRzRCU3ZS?=
 =?utf-8?B?KzhUK3BVMkxJUEFWcDJuN2lZZ3JtZnUrNnd0S3h0UU82WXh3bHJqb2dDQXZj?=
 =?utf-8?B?R2NjckNLWGZGM3ZIZlJvNmdZZlhNcm1tOHZFL3ZXeTRhMW8zaEgyR3FRbE1Z?=
 =?utf-8?B?dDFQU0ZwdWhjTU1aN2R2N1JWRzg4eldocWVyZGl5WlJLSGF2bEZkTUs3ZUhp?=
 =?utf-8?B?S0YxKzFlQ29WK2c1VGVIQWpnOHN4WG9FN1VsMk8zNFBhQTQ1bFZIbzNPbTRh?=
 =?utf-8?B?bElIUW53SGxHK0tNYWxETEsxVjN5YVZOa0JiS0F0VlBxUWR6YXJTbUI2WmpB?=
 =?utf-8?B?R3o0R1RyUGpmZ2k3ZFhoTUdRaHRLbW9SOTBsV0VUeTN5QVFqUHFrMFltdXpD?=
 =?utf-8?B?VzBKU2hNVEo3OWRNVm9Ib2JrMDdBZW90REQ0NVZIZHJ3QnlLbGVDVnp6WFcr?=
 =?utf-8?B?SlcvQXd1dk5QT0U3OUF1UElHNmxscDNkeWhsTUxMNEdqNEwwL0c1aC9CSjFz?=
 =?utf-8?B?TWxVcDRDU3JXaFJFVjcycXR1VnJwak9PV3pxMmR0ZHd2V21KcFFLdTZWQit2?=
 =?utf-8?B?MHo4eVVUdWxqbGVMSXFVeCtsUXNpdFF4WkpZVDFXQUM2WitmbEpOZ3dwTlhU?=
 =?utf-8?B?aGxxaG1JUFpLbTFZZ1p4MkNkVUFPQVNzYW5sR1JTdkVocEh2b2NtaXU4d3l2?=
 =?utf-8?B?MVFidUNJZ2ZneU9aSVYybnBWUEkrcjlUbTNoVWNubzRsRm80YU9Eam4zMkJh?=
 =?utf-8?B?MDhmNjc0OFRGd0RIRnIzanViWm1SbkNUZWVGd0tLMVZzMTNBSXI3aHJvOGdz?=
 =?utf-8?B?QWFWYzBXazg2Ukw3MVNWeFpUdU8waTJMeUc2ZFlZS2NENnFEd2V5cmRYbkIv?=
 =?utf-8?B?d1JXRTlxN2hvOXRBd1BVVXNkMjYrZW9wK1FrZVI1RzVBZVlKKytQdWtIait5?=
 =?utf-8?B?bzg4cFdqRk9WN2tOMU9TRkwvRmxnbDN2UXJlYUgvNFBDOFVKeXp5dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2bdb48-7c47-48f7-173a-08df447813f1
X-MS-Exchange-CrossTenant-AuthSource: FT1PR12MB863618.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 06:57:43.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLdOvP3ne4sG7jogREZXdRMcpMzQu6fIkMaFcxUAhc/l9/y5/r/Y8rmeBkUh6P1/+kYgaTeMQfmFClDuEAgwTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8908



On 11/11/2026 11:43 PM, Conor Dooley wrote:
> On Wed, Nov 11, 2026 at 10:08:40AM +0530, Ajay Neeli wrote:
>> Add ref_clk clock property to specify the reference clock frequency
>> supplied to the UFS device.
>>
>> The AMD Versal2 UFS controller operates with a 26 MHz reference clock.
>> UFS 3.x devices default their bRefClkFreq attribute to 26 MHz, matching
>> the controller, so no explicit configuration is needed. However, UFS 4.0
>> and later devices default bRefClkFreq to 52 MHz, expecting a 52 MHz
>> reference clock. This mismatch causes timing violations and link
>> instability.
>>
>> Adding the ref_clk property allows the UFS driver to read the actual
>> reference clock frequency from the devicetree and program the device
>> bRefClkFreq attribute accordingly during initialization.
>>
>> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
>> ---
>>   .../devicetree/bindings/ufs/amd,versal2-ufs.yaml         | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
>> index c00ec342d574..e294c0f1b0ce 100644
>> --- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
>> @@ -20,11 +20,12 @@ properties:
>>       maxItems: 1
>>   
>>     clocks:
>> -    maxItems: 1
>> +    maxItems: 2
> 
> Please add an items list here.
> 

Sure, will add it in v2.

>>   
>>     clock-names:
>>       items:
>>         - const: core
>> +      - const: ref_clk
> 
> its a clock by nature, don't restate that in the name.
> pw-bot: changes-requested

The generic UFS platform code currently identifies the reference clock
by the "ref_clk" clock name in ufshcd_parse_clock_info().

Would you prefer that the common UFS code be changed to use "ref" as
well, or should this binding retain "ref_clk" for consistency with the
existing UFS core convention?

> 
> Thanks,
> Conor.
> 
>>   
>>     power-domains:
>>       maxItems: 1
>> @@ -52,10 +53,10 @@ examples:
>>       ufs@f10b0000 {
>>           compatible = "amd,versal2-ufs";
>>           reg = <0xf10b0000 0x1000>;
>> -        clocks = <&ufs_core_clk>;
>> -        clock-names = "core";
>> +        clocks = <&ufs_core_clk>, <&ufs_ref_clk>;
>> +        clock-names = "core", "ref_clk";
>>           resets = <&scmi_reset 4>, <&scmi_reset 35>;
>>           reset-names = "host", "phy";
>>           interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
>> -        freq-table-hz = <0 0>;
>> +        freq-table-hz = <0 0>, <26000000 26000000>;
>>       };
>> -- 
>> 2.43.7
>>
>>

