Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F324F423A9B;
	Thu,  3 Sep 2026 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788436522; cv=fail; b=WFAO4kHVC+OTVlb+AAzjLcxQLe8k0YD4v4zohTA44QmYHM29gh3uiatnQF+bOgHMFia3H7PebgUsWWOrzzHo4xlLgkzxJh5GJipPpkdbr3GxJAJZqVqsRMqh4DbNsyz/48IQA+s5GsNEoEEkCUu+MyOoavLBf4BtCNKNF0aevyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788436522; c=relaxed/simple;
	bh=9svgEblQQ1efgy47JKZ4aqokODemduYEMnwLlIvKkho=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CPzZG9uJXngDM03eO7tTCWiDiBp4LNPKs+tpGoPt/C+srrkoOsUwKPYrvUuNKxsrPsfNxUVShJhkogDjSFP1WNO78DY4WZhDiZD1azpCx7kc140nsRV7qvaeE4V6PveSkUYW/OWuvnSJhYj0xQVgWYSVwwXENti9MFoLz413nc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q7Cn64OO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HE99fo2A; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q7Cn64OO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HE99fo2A"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788436518; x=1819972518;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=9svgEblQQ1efgy47JKZ4aqokODemduYEMnwLlIvKkho=;
  b=Q7Cn64OOajx4NLvsIqzrKJKurSVNlxyK1hFWrbdrlhD3h4MrviAo9AmK
   XUURutRe7Yi0LLv08Q+pusIKeAtqXuRIZo/+VASvBL+FxuKISIquuycD/
   5JZCHxvtP7GUTMHfRa0FG7/k3n5woDUBGbWm69BDfEfjXo4Bo6LhkkoTE
   vqlrppQiUphcehyXpEWDfoOQUPtTTCBT/dqlT6ryPJadEjbi7Grkm4irm
   M9+F2FahVvYbLjvYC7d3eQT78Q1s2hH1eikjdKP+U21Qvr4eC4NIGCxUC
   fzWmH4ynfWTcHHBEKU2I8ezgvo4UjX32wAYADsgvj4yDhXcG/o9FeuQ0E
   g==;
X-CSE-ConnectionGUID: MFLLcXYuRy+S9B/Cl4ABxw==
X-CSE-MsgGUID: +zRXhroPSKW2ZdrsQPAQ7g==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="154870880"
Received: from mail-centralusazon11011044.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.44])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Sep 2026 19:55:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjmwAButEilQAuKKqUBysakPqQTrwrGjN/NfJxxhz5QZnUMO+DmSaxlnWICF0Okou9HwH9DFryyohJkZkpqEdIpKlzv74wGyEfwRnAUZ16Szom8t+jS93/KLiufHBR7jYFy4aA2swAM8kYKvoI58yZyaQvS6aIX2GyD73lcV14wtxDiJWHPsG83xel8vJvNbZLZfHEps67wvKl0uCCVWkGpqd2I9HCY0hWpol+orzE2ExA68nZ9xo7GyU+udnffnjJmmB/BcLeYtyzgKlc38EwzU11kmYihTEQPIE1Wd/vSxMlxOuQGwqQYHeASGOoRUy0DwupdY10+uXm5L6UApBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9svgEblQQ1efgy47JKZ4aqokODemduYEMnwLlIvKkho=;
 b=B2b1cHZUDvhADkMY9Na0tBJq1Ms2XNpgLqKBff0aKjYoZihEQ18LIBPuoHPRGYFKCUwDquJtKYoiykJOH8JhuzWGKAVoIo6FFX2IrMRYYgCSmYFbtEakL/ZAqU40UoKc00H4xhSgd8O/cakHCkugflui2+1oBkBSrISYF8+ROHu6isRN79VrhxTs9F1TAJvIzf0hWTGZ8kJPUhGqaEhy21MAajDvxibyUyj5TUNq3A39Vdw0SjMGgaGwgBDJgOTWKNxpSPGcGoL1Kp3kUArh0AwoiFaJzccJ+JIBnGUqD5WmaDm1vKfykDjCO94XocE9n7Lr5ADcgtDfg7FanD/+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9svgEblQQ1efgy47JKZ4aqokODemduYEMnwLlIvKkho=;
 b=HE99fo2AWliDYsNnPsU7GDrENO4y1Ml7l3GCVemDkH6dJZ05QHXiMQvsmo55H5C8gfHSMHwfhY68L9MKF9kifjMkwy0gdShkmUotJET9skCzsWbTV+sLH1q7eac1iIGkwtnadLQkda+isEg8WC9hfjBuBo3SdoZ89Br3GgJBNgs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB6392.namprd04.prod.outlook.com (2603:10b6:a03:1ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 11:55:03 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 11:55:03 +0000
Message-ID: <f9faafaf-176e-4bf8-a4a5-0520dc317b07@wdc.com>
Date: Thu, 3 Sep 2026 13:54:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/40] scsi: define all additional sense codes and
 their qualifiers
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-2-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260903034201.112211-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0026.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0510d0-54a7-44b5-e38c-08df09b230b0
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|19092799006|10070799003|1800799024|23010399003|10067099003|11063799006|22082099003|18002099003|56012099006|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	6+Jubc/XC3SMalFzRl611sZCOQlz1ypI9P8HyJGxIu8lmLQhTkQiUUErEPPCJVzHxsNKMZ5VuvSDGh3s0bJYJXFk3CpBB745WTyL8KOMOBZcmjyfjGJBKudzLzbKQDd7JjLZ5CPmR/kQEOCwLQc7ReSYtpNBmjmdDGL1ESh5m4zzdHs38DOPSvX4dktFfMddeUEIeR2fMvoXGyvhs64K2Mqgl5d8qvGs64jyccPM3LTvqh2bbQK998/gQSavY2sQ01ZZhT9xb2L4pDCHc5Q8W/mGdSfw0U8MS8uSZ8ic19pVXXMpklxQKGadWhfsBOS8Ru9+SuGYocXh/hmDror6FLn7FV2Zkvuh2cjDbfmjJzjewUzFNK7PuCT6IA6YOiakov0K+JBf3MTlHElQvtD9r/FWODM3yEFOuazuPKXtbyH5KZN6bIxQ+9otdcA0oXGi8yrYXt0iueBONaz3Nw/iM1ZCFKhuJH64+h3D4zAko3EJjezTDQVD3KwvxwZpWYKCMmn0FmNCGePm/CbVfqXX3fpNbsiVdHZ5eSutjgrI1nsifRqdp9VccPqh0YyE8VpiyYbLZMain+ctqYZDFZu6wb5/6WOULG052ZzCEyAADYqp+Qf6A0wPS+jorfPQXSgzeJJyLCo+WKNniRbTWKc97dS/deKffGIjcGQEDkz/6KXw0q4uEYLeZFwdHDS+ck2kzTg3RZahvokxqMqaGs2JPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(19092799006)(10070799003)(1800799024)(23010399003)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFptVWc0dVFSeGlPRithTGljT24zMGtmcjdsaXpEL0VwVmlMWHNlT2wrM2tv?=
 =?utf-8?B?dUREMkJxVXBUU0J6NWxpcXA4UUpoS0hKYTd5OUxsVEZ3ck1nalRNNWxSN2Uy?=
 =?utf-8?B?S0pCSC9YenZuR1dSdWlmSXB2UitSQUo3djNWL0RMNTVZSHQwZ2ZNTlB3cHpu?=
 =?utf-8?B?VUdYVTUxWlljcGZ5ck51b2FWTTFMK1l6dU1OaitpYjlmY0p2b0NSeFB2dlp3?=
 =?utf-8?B?eUhXcFdoR0VnRmcrd04vVHZWS1NwWXdEdXNUYklZMzl2a0VQUklnQzRDMDRP?=
 =?utf-8?B?NFhzWWg2MXUzRVd5Z2JTNzlvWmxzR3pFSWF6ejVUTEdSOVRMMUp2Z3Y5Rm9X?=
 =?utf-8?B?NnN4SXpySUdhNEZ3S1RMZ0lqVkZsMlFPSXNyY3FwcTQyMDRYQ2dQa3R5ejJq?=
 =?utf-8?B?U3hsTGFhcS9vYkxoS0NnUjBBbnFzWHpiZGxtTEFuUjFmd1ZCcGU0UEZjWWNN?=
 =?utf-8?B?bjhVbkxFY1VSK1EwMmVzOU1XMjlMOVdJRHJLV3NxYlNIaXFiNjJsSWpKM0ho?=
 =?utf-8?B?bThQTmF6NjE5QW9QRExDcEY5LzVWRWtDRStnMm5UbHNoWGZPZzNzOXV3Q0Nn?=
 =?utf-8?B?ZG5mMDRWVHZESW1RUkJoU3ZiTFVlUnZ1Q0ZEQ2dDSWk1ZTY5TGhtQXl0RGpV?=
 =?utf-8?B?NjFSckRyS05URHM1c2lzaDR2WGdOcHNUeThMdkdodUc1b3o5anR2aS9GS3lM?=
 =?utf-8?B?QUsyc2pJaFhGTzBrbVQ1eFFwSEVVV1hKUGt4eFVvR2lNSExYUlRnY2pzenNz?=
 =?utf-8?B?bHQvc1cwUUpsUXIzL3pPMUloSGhjblJmSG1iN2s1NjN0T21PT0tCSVdUdlN4?=
 =?utf-8?B?SUJ4aFJRVXJITzFCS2FjcklMdzBqRzRMWm43OG4wUk9hbFJ0SnFBMUdxUCs3?=
 =?utf-8?B?Zm42WjRRUG44dmVtVEZrVFpvU2xYcFNxSVRHZFdaNkdHRHk0S2trWXFBTWR3?=
 =?utf-8?B?amVGL2JpWnBHYWFQeXM2b2IrUWVQNll4N2RsT05sOGVBbGRxMkNIV1c4YXpu?=
 =?utf-8?B?L1lHbFZFeVpEVkJIYmQ3N2ZtbmMra1JNZm9uQVV2SE0wZDB3V3IyeTdrYnFp?=
 =?utf-8?B?SEpwTGpscjJGQjQrQ3IwRGpodFovVXVFWkZaL3BoaC8rbDFZWDZlbFNLNkRm?=
 =?utf-8?B?WGNucEtIL2F5TlJoVjlWQmhUdmFCT1NXL1ZkTUgzenZyVmt3S2tST25jdmhk?=
 =?utf-8?B?UkgzeVFSTUFNS250dHFsdVVCTmxsSjlvRlM4ZUJHb2xnREEzZGJudk9kUHRL?=
 =?utf-8?B?ejhaUVIydXVWSjUzVXRzNHZSV1kvbEVFNUdQeGVKU2ZhYWNTSGJiWHMxbjYx?=
 =?utf-8?B?ZFpFNnllWEE4Y0dJb04xb3dCaVFTamh3UUkybEMzNGF2Y2crWXNsMHh4UVp3?=
 =?utf-8?B?eWFyRUl6NmMxaTc1TCtkQmdIUGJsWVN5WmVZYmY2VXNuSjU1Nm9xcVFLQm5Q?=
 =?utf-8?B?dmVlZjhCMm1pUFRPK3ZtZEVsZng0TTc0TmtmcFVNZk1aWkFUSWdnbU9rTWta?=
 =?utf-8?B?clB6QVlydlY1eXk2VGQ4cGdZY1JKQ1V2aHlCU1FYTEFlcXcwbHcwRGxsblNH?=
 =?utf-8?B?VzNCaitycG4rd1VRVWtpMm8wMEY0M1VGUmRZKy9UcTZ6dkE4SWN2ZDUyVGJu?=
 =?utf-8?B?K0l0ZFV1UUhlMEtSMW43K1RlMUZJL2h0Q3k5VmVJNEtDc0J3bWJwcXNaMTdx?=
 =?utf-8?B?UzljUHNPcTN4bkcwa2QxdGRqWVYrOEhwQW02YzZXTlliY09nZ01OQnlQUUFr?=
 =?utf-8?B?RVpDUmY2UkNKSUFtVS9XZHRnaitPcmpoZ1dVNEdTbnhSVm5SK1pZMG1OMmxV?=
 =?utf-8?B?Vkl2Wk5IT1Q1NmoyODFMTmpacGNkOEloVnlCMkVuZk5tbGRJNytUc3NrV1pL?=
 =?utf-8?B?WlJmRE5TVHlYVHBlNnQ4NG43b3Ivc1pLcjVGdjRjTmc4eTBydFJ0SjdJZFFJ?=
 =?utf-8?B?aXdpVmlscnUxc3FVRnlpOFUwenFaWTJIemtDVVJMcURRbXFKSTV6U3B5OWJS?=
 =?utf-8?B?Tk1wT2N2S0lReE9wU1g4Rk50RGdlQWNocVZ2S0tJeU5KeGV2UDVGM29CUUdZ?=
 =?utf-8?B?SmdyMURSM2pPeGMrcURzdkJ4SmpJM1h2Z1duVmZjMXRJKy9WNW43N0lRbGpl?=
 =?utf-8?B?TnVGS3BTeWVQMisyYytZUVN2ZjR0UzNQMFhXYnk0ZzBPUFc1clNrdWlvSjk2?=
 =?utf-8?B?SnNhNG9vZitkRytNZnBDbFJqQ2tISFF0aDNpSDc5a3IxSzAzRExGajlQck9X?=
 =?utf-8?B?Q0x0ZWFGenU2VmF6MVlNY2FuRXlGcTB2U2tJdmo2V0UwelV5c0hUdFFhTVEx?=
 =?utf-8?B?ck9yNE53anVkL0VRKzZqS0FidnpKWEZIbW1BcjNyUngvVE55dzN6MU0zMllX?=
 =?utf-8?Q?fMSWXD/KrrawOYmodHdk7LtFubcXKPMt/nMw+MyciRgpK?=
X-MS-Exchange-AntiSpam-MessageData-1: cxyUoKm5Dm0oD5OM1LYB2G752fTDqAvOE4U=
X-Exchange-RoutingPolicyChecked:
	Pk1y624XNAANIsP0UyHQ7F5P/SkWk058MHQSCYXCS9whjiCizBRyghMq5tHYk3uPqymLZ9HdyMGdDabfh7dtdi9PCIyRPKOjRCUh87DlAph9iiuPi7jT02Uf0wDxBVadTcVmtJ+Wz6rqq7Ae0iynGl5H5ckoSRRsMLFFYJVxUHbo6taVgE57AHzKZdEsrZG9nyWs7HcUn8kj89/NWm0At02piYKTWiIrHMA9SJP72pdOBvYvKWYAOrjVWW9qDrjh27wHFRpiobKgY8slg8pypFMJCUAGrJ/GxitRCovxrDnTiC2omHnij5IJA6S6z3joTdlt/zmcfBjgwOlEcrSLLw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aZrOrHI1q7DM6RqpYqWNz/7JmkXiB2c4bPY4ttIbtIJk9yX+sJf4GP5BlHPRhhi3/1b37qQP1k1snkQYA7h1w/NT0R2q4HxIuQrkoO/w6Y+Es4HsSfD2sHg6KNgE+71hXzSgeXXsJYW0BvQjOBWBIx+STVmqb3fdf9ow+3anVkoFMJ/WJKy4b27VldUw4Ka4evoGc3Bt/HzHwCr/iJfLTip8fHq0YU50xIOCOmVAlkpnl5/HuEN4p021GOhepWtrkv9rIMer2irQXnolA1avDk3F94M/yH+hmgcqSzxrvZ4sRNCMj6xmYuy2J5bryHGUK2Of+bZNMTI+d29/jolszrBw+B6MbZ9ygZm5C7I0eiJ9j+T+vzJWWGjfdZr45ACus+azhMeREpASPB/hRzyNhXSBmzy+ho/QwTQRoU3bR+DcPmRpvfmBa3+EO3wc57yU6BRfwOvU1wK+ZTpgQHf3PVmqx5iPO5CJiMSN2ctqTf0rL3WR6EGq8blE04QUkDIFcSF790eQC/6VSTYdLWWWhACjZtkDJqsFeWvxWL0dniYVdvV3ngJDUvM3wiXFRzmGrDm5UzpiEhchbEU7UU2grHTHOaiPyYuTRmWClyyL0gVmK6QewnDGnc4/6buwnBvg
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0510d0-54a7-44b5-e38c-08df09b230b0
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 11:55:03.7968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: niaD57B6iiVUEC/zX5GiGw+k21AIYeX7TPp9+vB/tS43tsKsojOR/wNNjBIVY+HCElGrnBJK7XS6lAjXl2MT5RGB9q5iRWKZ9UFQo58Xi2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6392

Looks good (I think)

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

