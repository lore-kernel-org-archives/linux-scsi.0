Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012024.outbound.protection.outlook.com [52.101.48.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7036E48EC78;
	Tue, 22 Sep 2026 09:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069873; cv=fail; b=cIG+kxYU1zqurOYdbc8s6zuwM1i5vd4w5rJfSlK8ypFmBFPLYX7ayTfFX8jNUGKDgU8rGFLKrZvl+6yArnZJWMquCSWmQ6SKDQQObvH6p1U5Td56DdnXpI0hf5PXIMyBm64GW0RQForseROjKl6gMK4uvrVQ1JPs2YtQkQZFQmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069873; c=relaxed/simple;
	bh=8N0LYEkpiJOpJr84ZNLjtKsJhb+T9UQdXIY2qJQ8WjU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=elY0fmPQhkparBc7QWITmQn7cC1ygdR3Z1eeJo5wTytQchQeWBEtTwh4E4KWbNG5ArH65pltzb33RaEkvXKKdxv8ukYcS6UlaelzvP3A91IU3CjWfEN808IykhqLp6fSsdL7Z9aMRW8qnus/HxmOvv5LAV3OKuv3sUeAXgNeAKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YX3yxyXh; arc=fail smtp.client-ip=52.101.48.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YX3yxyXh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPJ69Sj7mEqLzdrwSko2vPSV2KMZKIU0fFlnVDED/8CpOcfX9BeG79fy7un84bQK9lGqTkjR+XbPtYsb0NeAJ2PrnwyXMzJ2mOce9J5PjSeBMJx9NVRfCsVEIpnsqlEHNSMTQY0aW1ks4rc9G5w4pTPBxKIllEM3EiBvIgkOvRtBAT8u9BRk4r4eB4TyZAl2DjYFxkeKVX/2REkwPRF25EDS9Cbx/8zjCvB39TvhEfytFzJMr8iY+BLR/9psdUTJ4F5v40bOd/XX4DlpNasxfBaSkARzbOEG9rCutwCNSEA6yg9QSe4fETqxuvyVMqQKvvVrvPI55A1BymIgH5nIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuNfhhoARMqggswdJteFSR0VkRWPN1GX/6FtYp8pZWI=;
 b=EgwWA9ovOwAvWzJutG7JCuxcz6vd3SJgXcYWMmk+IpVUAslqroC4xFwF9XYtxSySLdOudF+opuhH96p8C90jVudDMhc3k6hI6QT36OYYTFCkq9gvelTXbxfMu94jHLgd9wloFyfUnnOYsu8LblJPiaQ6JVjuv2EIH+zL0lKhUOrGbr4CV+l2aKHav2dMzYq2V3aUl/v7yT5JBo9+4Wxzb10DHto/1QF9A4K0Bnbc+iYHXU2Tq+LKaAi5ocIzYwXEvlrCJlwwXt3trvtDFeUbDcuIqAZVSBAI1QjbN5czmyVwLkdxVbhD9CTdXKjbrlRQMeFYAt2DWfASB8oAJ5vgqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuNfhhoARMqggswdJteFSR0VkRWPN1GX/6FtYp8pZWI=;
 b=YX3yxyXhvGkZHIzxU2YelagS24q5Mh/YExE3EdIGOj9GbxwnBPA0zDxNDTt7uBHWx6Dh3i8UoTYKuomrouclOKXh06FUeViMgZ8dHP1MU8mC/NFN/zI5y2NggmRzAkSGn5YHgqX+vcIwyeqqc9ODTs0e20wZyB/bvJbEDP/m2m1+5yv/eU0qaUkpEGItBg9bUbEBEP2djFmCkdNy1AyLSvbak6KojjLGZx2bjterZK9virH0Xki5S/0yk5jJYHlAlBTzuCR5hnW1CH1vg7IXKw0LFpff5XJxspAdcAJoY8qH9tx/eb8Eo5cypnRxg4ZLLnk24VzoYY5IBuV9kTb8nA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14)
 by DS1PR12MB999187.namprd12.prod.outlook.com (2603:10b6:8:495::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 09:36:54 +0000
Received: from MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76]) by MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 09:36:54 +0000
Message-ID: <40a797ed-5c17-400a-9370-1e623d94e524@nvidia.com>
Date: Tue, 22 Sep 2026 15:06:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Thierry Reding <thierry.reding@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel
 <p.zabel@pengutronix.de>, Thierry Reding <treding@nvidia.com>,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
 <aqFqhNA50674GtPo@monoceros>
Content-Language: en-US
From: Kartik Rajput <kkartik@nvidia.com>
In-Reply-To: <aqFqhNA50674GtPo@monoceros>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYP287CA0036.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23e::11) To MN0PR12MB5716.namprd12.prod.outlook.com
 (2603:10b6:208:373::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5716:EE_|DS1PR12MB999187:EE_
X-MS-Office365-Filtering-Correlation-Id: 9191e0fa-1e73-40d0-9b2f-08df188d0972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WBwyFp3RIr8QIUoEcUNcRNE/5DrZn3ZKGr2IzWOir8hxgj934UkWf1x4BwdGDuahHsTllKJZ16vobSQMtOekndgBBVkB1UoVpQIUAcrONMKfIelpMzoxJ1jwKI5+y+ER9XYFTgG5oCOBImlMsVvzRMx6Lv36ANolms0ymO+Nt2MEvzZIwXS1UkL4YPsBNEDUl3yNAgKK5ns01bwWIf+pmY499eLOekdXyBQdFw+WH/WT0x6oGiFn1+T91rV1xo4Rg687snQht8Ger1cvZyJBvwDfxDuSezkf/VZQI6njkU+AQyFKx7Oa+YFNCQBvcQNgkSildyU33orGLL5dsVJ9pLkwkG+VxUb3v/270u6Ywhb+3L2u7cbGjG1KXmJzkvLI9fyf7IUy0AGEMeAryQL1IdDZfRahhZEMHm15JP+3OOPXc0DKgqSqL1tm8djoarVsrTfNfAj4C1fGL165igd5+ZzB4Qwk8yFwiF+qzrOeQ4hZsnOaQv/a1fNIMjLvjJYCUqJ2psOjQEB+zsbvUBpc5O7CMThg3ADKMdOqTfnXk7+ucoyVqqh16o8nx9xAj1KHopBcxdoLR+KhdaKtXvkItM48HOqj2NRhjDikzxASb+hWfZDiDanMu4tHrEBzEcxqHj1BFgPdHM2Hpogr4khUi3V69oVRfq2nomgl1FYXtxE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5716.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STJNL2Nkb1lrSHJqWU81aTFUNHgxQ09GZHZIY1ZHQUhMUGJYM3ZiMzNnYldT?=
 =?utf-8?B?eUlwYWpyUUFmZVhQTVdLOTUxVkVIYkd6SUFWbG9NbzBBL2lmQ1dLWjY0WEtr?=
 =?utf-8?B?WFNNN2EzSWF0ODdLd29Dcy9Bb3lSMm0vNzE2bGlDVVNTbTEyN2x1TmxhTnVD?=
 =?utf-8?B?TDFLZkxicWxjb1Y5U1VmaUxlVzhpUy96cFNBL2xKeG9kb0dvNGhRV0k0bVpI?=
 =?utf-8?B?OUxFMWJlRnFpdUlUWWl6R1plWXJqSzY2SUU5VXljY2dlSGU1bDdLNGE2bWRM?=
 =?utf-8?B?WHoySnBKTmRWMC9ZQ1BkTm5VaFU0US9lYzdZb1RUc1hCWUNubkdISnNkRUJo?=
 =?utf-8?B?TGhVR2tvQTRiY2sxZ0k4Z1dzdFpJb3RBZXA1eXpLMFJldGdOb0l1MGYwaXVw?=
 =?utf-8?B?cytqdGtUeWlhKzhuUTZNZ1hPYUlSREZjelN1ekpvNTVreWZMeGQrQnFwOTRi?=
 =?utf-8?B?c3g0Z2FaMFg3TkQ3QndiUGdhWFFLSHhYZHRjUmVZdHlpNzhrSDVsSDREZUQ3?=
 =?utf-8?B?TXZ6RVRUbUhyM1RYZ2JncUVpMTFZVThHUWh6Ri9Td2M5VzYySE1wUXMxQ0Iv?=
 =?utf-8?B?dklqUTNtZHRJdVN0N0Y3TEFINnNsNUwxaThXVEVuN2JkSVNISUZTN2thUEZ3?=
 =?utf-8?B?OFh1SUcxSk8xWU1CU0QvU0ZoQWM3djh0cXNKQ3QzYWFHdWcza0I0RzE2RWt2?=
 =?utf-8?B?eXluT1MvYnlXMno4N05YWWR4UG82ZmhlV2FlQW9QUk56cjBqZWxMZzV0UnRU?=
 =?utf-8?B?WGNKQmxhSTZXV1hUbi9WQlYrM2tGSi9YUENqRnFDSjVKU252K3Y4L290RWhh?=
 =?utf-8?B?Q1hHaVRrNUxUZW9IcW1sUjM3NGhEd3lXbXZ6ajY1QjJjYklxcnk3d1pYL3ho?=
 =?utf-8?B?elE5RkphbjloQ0YxbXF3anZhQmp4NGRoTWZ4ak4xZDBoVFVIa1lDNW5BdWhw?=
 =?utf-8?B?VHVkc3JOaXFHRVM1RFhYL0xyTjhuOUhGUHdmUXBCT2FyUHovOGRyVjNrUDRB?=
 =?utf-8?B?OG9WcFNzMXZ0S1ZRR3JFT3lBTHZRQ0tmS2NseUZrNGErdUNyMXJ4Z1hNcmpL?=
 =?utf-8?B?SlB5SjZ0aHM1blNwaDNpNUhEeEw3L0lmMEN0dVFmaUNjVlBFUklmbUVmRmhn?=
 =?utf-8?B?Y1hqV2ZxSDVjemZ6VUpwb09JR1Y5YTRXcEUwdFdIN21kMFRadjFwbmRoTmd2?=
 =?utf-8?B?NWlCQzZIZW9GOGZDdklETGNpQzYzYm1yU3p0SUROQ3dyMmxsUzgrOUp0YXkx?=
 =?utf-8?B?bGY2QXh3ZUcvWXBFVFF2SHRNV3VrNy9NZUNEalhaN1lxc0ZLaVkzZWNXY2Jj?=
 =?utf-8?B?QUxPL2s2VXJ1cTNUMkFJeUxGT0JtYzQrNG5paVJnSWEyMU9PQkwxNDRyTUxt?=
 =?utf-8?B?aWdJaUVxajc0bmwzKzZ2bGU4VUpDMUlTL0REY2htU2F1clNXWjcwMXllNWR4?=
 =?utf-8?B?aDhOVFBpcXpOMDd4QmwyZm9TUGxvZkowSE9YN3o5dWtTUy9mT203ZDdYL3kr?=
 =?utf-8?B?UER2RDkybTFxZGY3TjdDTWdadWNUWCtHTzZPYkhwcjd1UmloOEQzNm02Mk16?=
 =?utf-8?B?NWRLVGN6T25kZ1J6RjBxZWd5Y21JTy82SUtWaDdyd1JXdXloQWFxMjlhMUMy?=
 =?utf-8?B?YzE5N2JSWVFBV2tMWGZ3clBqNGZtbkZhb01GMTVvMmo5ajdJSURIRW5nMFFP?=
 =?utf-8?B?N2hVZTNiTG9RRlNlYWhXSjIzRGtqYTJ0RkhvL3JOSWRLbmNwdkh3SFZrTm9X?=
 =?utf-8?B?LzlITzZaRWVCMmtxYVJVYXZSMDhmKzdFR0FWQ1RxRHdqQnJoRm0rMXRDOXNs?=
 =?utf-8?B?K1dpSUxhTDN0a0krSkVDVk1vNVZkZ09UamlGVkN6ZjY2US9oa2MzL2Q1WmFJ?=
 =?utf-8?B?WUpvaXFDL2lYL0xQMEgxd3lJdGZNSWxoYk56Q1hEN2g2alVTNHRXY2JublpL?=
 =?utf-8?B?VTVhNkxkZ2RiT3JEQzRMbDRoYnZWSmEwWmEyR3F0a2lGUW53QU1aSzlWYzJF?=
 =?utf-8?B?cC9rbWxERGdsVnJsdHJ6ZURPYVNlMDhMZXJ0Z2JjQzRGK3dudVZXMTV0RllN?=
 =?utf-8?B?dHZHaDI2bFJ5VlFUNUVXbm0wT2pabUsxUXdpaW1tS1hQWXFMVHIwTmV4bVpW?=
 =?utf-8?B?TjUxRHVYbmR5aGdDZEJQbGpBVVh1TDlKbDhzc2pwRjVRekt2dFkwbnVGM1d1?=
 =?utf-8?B?REJ1RHNNams2MWdmUEN4WmVEdU41c3JFcjlWVjM3clVGUmQ0MUExRGdYZDA4?=
 =?utf-8?B?Vy9SZlFRQThKbis2Y2VxUU5XQ3VVbGl4NVVneXVMNkhRZzN2N2hIaFZKc2Nh?=
 =?utf-8?B?Q3ZKRU5oSFplTE50RHVqdTg5Q1U0VC9tM2wzaFhSNmt4cDRVOXFWUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9191e0fa-1e73-40d0-9b2f-08df188d0972
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5716.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:36:54.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGcm+loPWsyaNIHfdpUMW6EZg1Oojhd2vJJrkfoUtmqgwpnjvbmxwQBWkfoCcazhaMT/Uxoh7bb2MGrDNgGPew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR12MB999187

Hi Uwe,

On 09/09/26 19:50, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Sep 09, 2026 at 04:11:22PM +0530, Kartik Rajput wrote:
>> +#include <linux/bitfield.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/mod_devicetable.h>
> 
> Please don't add new instances of includes for
> <linux/mod_devicetable.h>.  Either rely on <linux/platform_device.h> to
> provide of_device_id (my preferred way), or use <linux/device-id/of.h>
> if you want full iwyu.
> 

ACK. I will use <linux/platform_device.h>.

>> +#include <linux/of.h>
>> +#include <linux/phy/phy.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/reset.h>
>> [...]
>> +static const struct of_device_id ufs_tegra_of_match[] = {
>> +	{ .compatible = "nvidia,tegra264-ufs", },
> 
> No trailing comma before a } please
> 

ACK.

>> +	{}
> 
> { } please (i.e. a space between the braces)
> 

ACK.

Thanks,
Kartik
