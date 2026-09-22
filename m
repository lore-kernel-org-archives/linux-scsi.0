Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012003.outbound.protection.outlook.com [52.101.48.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7688844E66C;
	Tue, 22 Sep 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069560; cv=fail; b=qdEEH4pWGyNrD/GFsHs2I8xu6l8gk6uDLKP6LHiZgAwmo7PDTtzyOkb0ixyBzxkNedHM+m2Vdxab8Djxxqj8Cp3hNmHC/ncVuw6ktHWelo+atsdZ7SYGgRzOKYV16U8CX20qo0KxI0Q/Ulu1w67rT3oe2YTdkYUXhbX8o0NDrbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069560; c=relaxed/simple;
	bh=jR2ZqC6OT4RU4MW8RqR0gm+0cjmCELWKJ4v78sLbJDw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R6dXg3ovcRl+4E0PhG5Gboc/RY+BRNABx2vrav1DCRXXpQe/11gWxzKFUsT7d+dm7BKFKOo/HavKKScoBVBoKWmf5/3zObiX6+AXAaQA9ScIQ1ZYf/EwIQ1OnczHzUsbIIHSQyR1lm/J+FSDzPu8CgLHu541lGSFua4MswjN/4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qg5+87r4; arc=fail smtp.client-ip=52.101.48.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qg5+87r4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhVU6jj6YXbRJYqqmJp0hcbJAr9NrcDnzHHgHd2L9w6D+RaoqwcvpnfTiqJmCy4tIzP6ir3yI/ipRh46XyEQLlbOX3CH5ElgnuTsLIyyEd1EKU8FhoiNmB4QpDdPr0ASDTGj6drf//5CnLRLob9+HDDSCh39SdRuYfSfCN8XpJBn2sfa/tXQTyFzLKpJzrIrvkc/sJJ8HmbsYV/XiUo6wWQ0UIMS7yxMjhNr9xoCAVino7xCpFDFk2/QgMF+Entt+zAAFohQ2UXBTCNe9TcvgHnJ65FwCdjN5Pz0traMTzC7cM1e8JjQLkT8Amxr04jurprrWDj5LXWoOcWHLqB1HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPwBGNpKazjpO9zzM0jP46kQukCZbb3dU3m0Unk0t+s=;
 b=GVU50+nGLWSWzreLcBFfKjPrPU4DCBqOhWF50xhMliv4opS2pKuGVqBzVB/vSfrGbZc8xCIUGfGD7Glcw1V/G6QVfmCxBoyffVsmCMN2Y7udN49Sd+fqZ+10wl9JRAmoG2bJGWQ4MLre5kE+rLKTCjQ1Fq5dEnRs+iBBev7TWk6WdVHoAwzUiXU8EbcJWrFHeCTtuKPbeYNVmqHFd44NmZCdN4QNkRfB8sFcu9GxC2+b3I8sruCRgRYTZjC01HJPtRd6ihuLUHutiwHlunw8HuFjDoSm/w4rE5xq5JotVOah672BIn6PMiNglh8znoPKXFNDunUzbdoHtymzn2XFrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPwBGNpKazjpO9zzM0jP46kQukCZbb3dU3m0Unk0t+s=;
 b=Qg5+87r4GJyIYTM3Xwva6zASGvyWnuo/6wVvnDhiuX0JONbACoBxVSTaACimJ3TqrHv0Up4LGUrI9J3l8GgUqRjuuKnGasANFt1FhBE4d2lIOJPacV5S1CtCK+VtXybsDOLnUdvqTeeZiBGAzkSDKPgt1KSJXa3fYJ27IIBAtzQlVvGY5p7puLXug4vvGmDpaydmwphJZpNVmXEdJy3YjE2tToc0yTL1ikz6EJMVoMw5GKfj+x1xFD7AYGBZiJlIIxoIJQFN0M/ozC/LCmxnYbh0zpCx3jj8VCUIwXw9kzv9MudaoTI0E4hvsJGZ8v6iQfS4TLltfaX+qh+1tWi9GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14)
 by DS1PR12MB999187.namprd12.prod.outlook.com (2603:10b6:8:495::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 09:32:35 +0000
Received: from MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76]) by MN0PR12MB5716.namprd12.prod.outlook.com
 ([fe80::bac8:2b43:2a64:4c76%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 09:32:35 +0000
Message-ID: <f6cd2cb7-48ef-4f0d-83d5-0c2beae5aab5@nvidia.com>
Date: Tue, 22 Sep 2026 15:02:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
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
Content-Language: en-US
From: Kartik Rajput <kkartik@nvidia.com>
In-Reply-To: <aqKus9TnDNm3Yt8Q@monoceros>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26e::16) To MN0PR12MB5716.namprd12.prod.outlook.com
 (2603:10b6:208:373::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5716:EE_|DS1PR12MB999187:EE_
X-MS-Office365-Filtering-Correlation-Id: 944f738d-5aba-4fb3-6455-08df188c6f0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PovYdbnfy6YnIWpH2wWl0yG8F3PdV6rxq5/5SCiH4kC2cEhK1Db0pWl04UlKvxmbxaKEG7cPy7d7hLgs0x1Xk5Ke7ecrbualkbObIT0Lgc+AavuqxSMSl3q053xhayqWMwqy/X45ITkgXyFGmmofzXR0EKnhoAdaztj7RmeMmjwFklDgF1YrYl7vGOCaly3I1gjdzn6/ejUkQl7RdzZfaoqN56eJ94v1Oa7AHkFhfnwvpJesQ6Wtp6O6iUiWBtbTMd2ndEfNIeNiIIB4tciNFK8J5upSJkV+lCXcgbtJiWa6wTZh34INAlPwm0yWjj6u4ZzaOrbsFaSEl++LnjJCa/9ecF+UatPoZ8D4vjrGHt5qgvKpbH1CvXGSlSXDRpB7tPyibq6YU6g820vzC2LzSVndldYT90ixEFdvlITNPbymHzMHM+qa/ryEu08xkjAwBjfqYmv/fCpR7zypPT6ykgw0qsXmkL3gElHvrgJZOSXZEDHoXwgZ+Byw4Zl8r7ebSdwGURQLrWERWDMC736LT+/6tC0YKt5tTZ3JWgyJkTa3Jo86hMWdC5Trc89pNUqKN3e4t/SHmIO2h1jLY0lpOg9EBwvUfWlmcpf+3Jwd42r3fZ050usSIaqZonYv13RVGUJzIv0m5/Mburf9scobnFjBSjQiHajDQuYmNJ0ZoKM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5716.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RE5WRjhiUEdIYlFWZmtvZmdyY1NwRUh1VUFiZ2RMYXVMNUdFRTRtbnd2bWVS?=
 =?utf-8?B?QUhhOWZ0U2tqY0ZtN2hOVVNPQk52OE40Z3RwR2ErNFphcmRGV2lhZUNJV0VP?=
 =?utf-8?B?VzNRVFp0eG1YRmNsc2dWSnZWN3AremF3Y0RZS2Vqb2NRK25ITVVDcHRxRndu?=
 =?utf-8?B?VDE0Mm8zRUhUMVlPZVBXbHF6VUJQbmpSOFVMdGNRMFFlYVBlbmN4a3BSUEps?=
 =?utf-8?B?SnZoZ08zTS9pbE8vbFM2RU8weFF4Qk4wQm03VGtCOGVIczJ3NkFQOXBidlRI?=
 =?utf-8?B?aHRkcUtBdGtpczZhNkZMN1ZCWXV2eHFSYUZRbWN4NXhvVmNKRll3azBLKytm?=
 =?utf-8?B?R0tOUkJmNWRBRFpPU1JkdU12MVdVblk3d3hNc1NCYUlzNVhNSEJYck40NkFZ?=
 =?utf-8?B?VlZtZjVlYTluMExBS1QzYzI5d2gxcENMMDZjMHRodWgzOEZvM1g5SDVSdVQw?=
 =?utf-8?B?Y0ppbEJXbnFnUTBmS0N4dTd0NXM5NWZ3eXpOVjlGVUp4NVVZZTJmUi9IdFNZ?=
 =?utf-8?B?YnNWMXN5dDhtVWhWVndFQlFVL3lJbWkzTW5iL1RDNWFIcUIzcEJpSHhRTGNx?=
 =?utf-8?B?c1RNQ3prc1hBQWNDYWh1SVUxWHJKTGR0T3BSWVdhRFhMU1NtRkI1Q05sTnE1?=
 =?utf-8?B?QUxEMHNTVUluenNkL0x4dWN2aW90QjZoNlh4a2FlcFdveUxPaDdOVjFpbmNF?=
 =?utf-8?B?bkd4QWQ4Z2R5VmEvM2hGN0hhQVNjdVZ1eC9VVnlkSHZsb05FT0xESlF6TVR3?=
 =?utf-8?B?ZzA2TzlOU3J2M2JnQ0dLNjlCZ05GaTliNndCSGhWVXozcDFWY1hHK3NRVDJO?=
 =?utf-8?B?K0VTZG4xZXZCS2NrU29sRVFYdDlrZjNMZGRxSzJMVFNXUEFGcVh6dFZxZGk3?=
 =?utf-8?B?bzBjdzYzcEI0cUdhZmt1cWhiWmR6MjlxQ3hiV0tUVGxHUXdDYktmN3FVcG0v?=
 =?utf-8?B?VnhkckxSS0lPZUhtQ3BnaUFBZ3pxOWtGdjh2SFNBbzZ0cDJRM0JnQkJJSytl?=
 =?utf-8?B?bE1NZWd0OWdGUXdVTFNiTkJ2RWVnMWhDVkppTC9oTVliR1JYVXBJaFM3SStI?=
 =?utf-8?B?UW9UVkFIc0dZMGpLU2VyOFA1cU9aNm9NcWc3QWhQeDVML2xYdUlQTW1TVjda?=
 =?utf-8?B?eG50TGV4K0VYVGQxTm1JNXcxZVd3VXFvc3VSWVlKajFmZ0JoQVN0S3pNUnhu?=
 =?utf-8?B?dVdvT3FsaVA3b2pNTFUzelA1cFQrY3hnZVpMb0hxUmJtSEdHOXhPNnYzSHp0?=
 =?utf-8?B?WE0vYUJLcC9hS205TDJZTkMzbmU5WlM4QzN5TTZRdEpOQ2t6MDN3akNWRUc4?=
 =?utf-8?B?NEdtdWdpSzZCT0VPOFk3eUFCS3RWRUR0TVlmak5xSnkraWowR2dRYk0xcytY?=
 =?utf-8?B?anZkUlQyMm1VYTRUc0owYUlnbnNRTXRGanYwbldQcUsybXordW95MWs1NEpM?=
 =?utf-8?B?cU0zUkl4eGN5YUwzQ0tQQXhLcVhaSTNRRmc5MEZrRDUvTFVFZXhGcHQ0Z1A2?=
 =?utf-8?B?WW9SdUxQWVJrZTJhSm1jcUREWGk3QnViT0J6WFo5OG5vclZtQzErdFBIU1dO?=
 =?utf-8?B?bitZcnduOURhdkM2VlowaHpnV2xqRXZxSHhpUDQzV0FvTHExdjJ2U1crM0lZ?=
 =?utf-8?B?dEEzc0VWRzZCSlo4STRBRDdVZFYxWXNSR2NTQ0RXOHYvQmlreVF3aGlSSDVE?=
 =?utf-8?B?bGU1SlMzYUtLU2JNUFJRRVlPa2E1ZFpwa0t4alZxakJsTmk3SEQyNlNFU3ov?=
 =?utf-8?B?R0V0L2lPVDg5MDV6bVl1SUc4ZTNFYmV1MmkrK1drS3lFcVhPcmhHS0JCYitD?=
 =?utf-8?B?QVBOcE9VZ050cFp0YmsyMGt3OWFrckdsV3V2eU8xclVwVkFUeWNNaS9uSUdq?=
 =?utf-8?B?SHhpQjk1SEwwSm1ZZ29WelB5RXM0V2lsUlNHWlI5TlB2UmFTTDE4R1cxZ3VL?=
 =?utf-8?B?dm9vQmw0c1h4clhnZjhLWkNGME5DcDJBZk1PdEVudnp3RkNWVGlJYmZFR2wy?=
 =?utf-8?B?bDhnVyt2cHU4OTk3cUhFUitHU0F6QlZIcm0xMkV3Yjlkc3QwUjhuK0tibldQ?=
 =?utf-8?B?QlZ4UTBlT1czbHRFUmlpaTcrbWZtN0dETlg0dHpIckREM0pJTk5uME51VVdo?=
 =?utf-8?B?SDNkdE41ajB1QTZhY2wxUDgvQUdpRG1pQ0VCTFhRUk0vTG5uTHpqMDh1TlVn?=
 =?utf-8?B?ZXlpbUV2SWFtNHdjNUQrNjhVQk9ENlhXSjJoVG1WY1VTODRTemhuRUxsd25j?=
 =?utf-8?B?MG5sL3F6Wi9aNUtwWExHUkFVVk1jMnBiQ1cyajZRREZpdnVjV3BhRGd5RE1p?=
 =?utf-8?B?YlZIcVNvT1BRNGdleVJJSWxTL1ZvbTBVZWxORWpjRkk3bzBsbVd0UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944f738d-5aba-4fb3-6455-08df188c6f0d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5716.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:32:35.1644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 816WB0W50uEvHpGdZxZLOr28Odu0DJwhBVirxX+erULenxOPHOkBHRPXRe5a+O1kPnhI45rC11GehRY1KM9ErQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR12MB999187

Hi Uwe, Bart,

Thanks for reviewing the patch.

On 10/09/26 19:22, Uwe Kleine-König wrote:
> Hello Bart,
> 
> On Thu, Sep 10, 2026 at 06:09:30AM -0700, Bart Van Assche wrote:
>> On 9/10/26 4:21 AM, Uwe Kleine-König wrote:
>>> What makes you claim that {} is preferred?
>>
>> There are many more occurrences of " = {};" (about 7000) in the Linux
>> kernel than of " = { };" (about 1500). Additionally, clang-format
>> changes any occurrence of " = { };" into " = {};".
> 
> clang-format does this due to
> 
> 	SpaceInEmptyParentheses: false
> 
> in .clang-format which I claim we have due to prefering no space between
> () for function calls. It seems only newer clang-format (starting with
> version 22) can configure that individually using SpaceInEmptyBraces.
> 
> And IMHO my statistic is more relevant because we're not talking about
> `= {};` or `= { };`.
> 
> But I guess this is all subjective. Having said that I feel offended
> when seeing "= {};" and would ask to add a space there, too, when
> spotting that during a review.
> 
> Best regards
> Uwe

ACK, I will use `{}` instead of `{ }`. Or if you prefer, I can use `{ /* sentinel */ }`.

Thanks,
Kartik
