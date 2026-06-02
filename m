Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA5336C9D5;
	Tue,  2 Jun 2026 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780417888; cv=fail; b=FMc+dp+KhkqlwDT1FbCmArnHaAb70mr0ThuujkqxCaqbanTtlRuwhZ41njlRujJ23No20C+c3zmfFpZG8FtWp1XpzfcCZ2FS1Rel8HVGBZsaz6qJKwWEGOPcldXFndI9p1s31ulVvUvp7VPK6o+s4XRCddmzI6w7kUrZdI3vtK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780417888; c=relaxed/simple;
	bh=mqo+Myxi0D3PKpRq8g8+MYT835/LaouZouiwc5GPY2g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ElySpP3YaamBUo44Rtbyq5L3r+eUD05pPGhObTDXvsf6DbiPpXWoD6g50QWDy6w/32aLbc2IEP6pne9ff9Fa7K6373FXqz7oyPwzstQphSzAkfkaG7riwiB5iNoLWf0FvyOA7o6nYByWamy3mn/hvtogW2Ig3EOWK45e8reCJas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ob7A1r6n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BEM4heSt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ob7A1r6n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BEM4heSt"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652GMrfq2904787;
	Tue, 2 Jun 2026 16:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pwHowJbEiMB3mS59Ed8SKELoNsSlrXPhjnAjTPr6HFY=; b=
	Ob7A1r6n9B/PSb6Eqb+3WEzuq1uCdiUAgA5TKv3awVAR6a9By2QzqVFG9AVJo+wb
	NqNl8R5obIB6x5vPo8LUdSblBnLGu0/FZ7D7PsJ9O1SL+e2JGQAc8li/9nIN8v84
	quqLzLQAhzF5t9DwjSHgjR2bp87p3JRopH4u1G7D38V1xFq3Wuha0sijKQwGrp/H
	mCY8IPkBn3S3EiEPFR/rgbz+NclCX7x10GMaSOO0rlMerFcsEnJ9/GZb3rtPhwZT
	TZK7Zy3IWDmzwFN5ouKy6Bjh2a5UyROyJCOhn4xG+x+v2ls3sMIqShuRY7xe8qRD
	noec6NFVUpZybm05QvlseA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efptbmh0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 16:31:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 652GPMRk010670;
	Tue, 2 Jun 2026 16:31:06 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011071.outbound.protection.outlook.com [52.101.57.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbqvq9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 16:31:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cF45ivCWoZKE46mCSGFywCmGoKofGYpslhTj+6j6vwkC1ZaPIQoHG4hczhh2r6M/V0uiDD2E2zGP9t2NokFuCZba+kBKEzw+1eRhE2ev48l5+J8vsanS9KmjT9aGXtj0ZymHFkrYAMOU1gkvfpJyi0vVjEQszonJpLyJzDk5mKL1sPvUU7pFOKCY2AIdZwzYYOyYSADEqrfKCONabmFQctGrTLBlv2M/xUbk2yibx059J7h1JkahfvJyf2gwAVXjnMyN/pWCO1IkgUcY54sykQQYSGTGF2F5HFYLoYpOGKA+K4sxacTQNb8CGs1rzoK/+uwTzNCOsgxoNpzkaNlM+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwHowJbEiMB3mS59Ed8SKELoNsSlrXPhjnAjTPr6HFY=;
 b=I0ynDzpHWwhaPnm65yZ43NB4xYkIli6nObRdFTShJzY0o+vCYM0T15erA0B6VDU60/Bngip/B9e9PokRKe5tj5TsNAihNKWJzYtA0uJqygRumvtHA4c+RsYLNubPj1rhIIyGyoo/Cyn3+Ib5iPMXDkK2tUfCJ7J1ZF41wJ4VDUcblxiYH7yDCt6MczIS1XFCgeYdeihfP6tNXmnyb2mycFO/la53lkcLtdPtvkoeNKhswgZ+nmkn5HO5lYmoN6yA/UtGYuazRv2AtCZBBySSgOIjHl8hX1qkjQvAaY6ksQPbAp/3rbL85Z7Ud2VMjgmcBYDNFo35zWA5AaL7YNwZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwHowJbEiMB3mS59Ed8SKELoNsSlrXPhjnAjTPr6HFY=;
 b=BEM4heStkBxMdytG1frhOvnrZrJnVXqI1+JX/Kd3/TmDm3iEEZ8BvpZrkXrcbrpFu9tN2FkHYT5n+HwkqROzVYLUJe+8BRcmrJV/QFBlultshUTc8+3CQghnYwSoLLUysqnsP4nqfWkXxr7kdJiTLDt3s81FCIf8TeT6eRylxfI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF8F9C59252.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 16:30:58 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 16:30:58 +0000
Message-ID: <c7e88b75-6c90-46f6-bfa2-471a01a366d0@oracle.com>
Date: Tue, 2 Jun 2026 17:30:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260530024958.3279112-1-yangxingui@huawei.com>
 <20260530024958.3279112-3-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260530024958.3279112-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ce::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF8F9C59252:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b05ea28-f3e2-4aa9-2342-08dec0c453a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|6133799003|56012099006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	yZ+0EHvo0XQYXN+j2xrqb/cfMNaYE9LZIQ7JLUj2GHpFbISatUQvmIr1Di7FEBkyX0H51rLqqj3BasIDNdMwrVgQ7jY1DZmcWKLo8f9+RO9PD7nkZadHwpWy/cI2Pxa7nSUQgliDf7L7b8y3rm1w3/6UPEO6N10OvFDn3fAX/g8lcnFt+TgF6ZwQa5P85Cf5THpCFu5vRJeI9vgX3MTJA8pe8soR2ehXCmagVTjVCJ5zeq8jH/uHSBiZk4589GDtkdVJXVVlV8ghXXrgFgfqQlw6va2OIr1P4mNShQh+wGu4ofZaicBtPaaC2TJk/MHf86HgmdiiEpxJOeSxAaLARN70vb2JMM2hy0Yrk4IyaHbYY+g++R/3+TlG7nv/VDgmi2NrH0KF4t+GBKBN++oKIV1MNVylfzI3p1F8TnBgTuMm8jBeCuL/LOrxZA2g6ui4qiGbsCXNzcP2eyvRlD5lghz1fOrKwwkJQYe7TiYPr58w+oMIfxEQ0NUd1p7idxfBDdAZzSK66MyarYZ27L4vAa20+MV7abC4Cv8/grCbNdS7o0WuJkeNagGRMX1bgG4VXu3JUWMaR84Zln+ZY6BHtfs7ypU8KbWeql89r73Zb3jk7miva9ndYOFnQ0e/12Jp5Lzg93HD/4EZCNuTdaddKBLtFM5GsY6s3dji4Ucge7l811wSD7Pps7CcuXKf+LkL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnVUMHVSY3MrcHpPL2ovbmNBRStWeVVYZmg3Mk9tWDRYeC9DNDJhd2p2RUJQ?=
 =?utf-8?B?ZDZuMXl0SzBCM0Z1UDlIMDU4bGhYckhMak1lQlJ6bmhTRUgxY2pyWWdCQlIv?=
 =?utf-8?B?UkhPOEV0MmhwYUlIRS95bXFSSThuYmtUSWt0N3ptWWl6ZlUveHUrSXphVmlr?=
 =?utf-8?B?N3FvUHBsbnlWZGJlOThtYTNNU0pWTExaam5zdGY1bEFjWTNGZ0pQcUovTUho?=
 =?utf-8?B?S3ZpSTVKbFJlS25kQ2MvZFlXcXRuSU1JY3YzdVBiZm5lT2VQZW9WdnFTVUYy?=
 =?utf-8?B?U25uVlNEaGExMFpjWlZDVzJYK1hXbWVnek5HQ3ZNdDJwcElkNWw3dVh2TUNn?=
 =?utf-8?B?bTBkV3JGVFN0dXVmMitmb3NqVDNaSEVSZWFRUXNaT1NmdEpXZTdKN3plU3JH?=
 =?utf-8?B?T2dSTHdzdlBBQ284U2FTQWVWWVg3N1J3L2lzenp1ZEY5clgwbHpVSklZWm9L?=
 =?utf-8?B?QmVzWEt6L3pyaVdFVWIvd3dLYjdIcWtaSVBGaCtZVUdOS0doSGFMN0pWTUhr?=
 =?utf-8?B?cDA0VDllc2dMQjdYZ3I5SUlOQmNIZ3p5czlORy8xczR3M0d1cGpreE1yUDkw?=
 =?utf-8?B?aE0vWW5DVHZWcUs0RVhlRFo2a09ic2JuTnFvZjdzemJERTFFY2tyOTRRTXBi?=
 =?utf-8?B?b05WUjZtSnduYnlmWkxnV2lVYW5zbnNSTXl5alludFFtcWY1Wm0xUUlZbFZN?=
 =?utf-8?B?cVpnbGU5Yjk1c3I2RElreFd5enBmL0NuaS9DU0FEdU9keGltdkhFRG9iR2px?=
 =?utf-8?B?UGJxYUlpR2R1aHJmR0c5WnpoSEczYUJJMmZzSlpNK2QzUk14R09OMU0xbU5K?=
 =?utf-8?B?amFEazBTTDNxSjdUcHVrVUFYNVFsdzJqZlpVc1cySXAya0RzOEkyTDFtQi93?=
 =?utf-8?B?VmVSUXhySzZMaTc4cERHU2J3cFhUa0VaWGhRSW5DL25zaFA4MHMwbmx6eHh2?=
 =?utf-8?B?bEdoc2dpeVFCQW5mVlhERU5YYlFBcHUvOEowUityR0pKT1N4MWp0ekR0dzVh?=
 =?utf-8?B?YTRLcXFDMVhNb1U5Y3Z2WkZsSU5jZzVvK0lDRjk5WlhnT0VDV00rOUthUytB?=
 =?utf-8?B?U2l6bkJ3WGZMNzR3cTk5aFFwK2JiL1QyaW94c3c3WS81eU5XbXdhM0RHRWpT?=
 =?utf-8?B?eWVCNk1uNTNQMHRjM203NERwcmIvMlRMaGpJQVQ1K1F5TUZ1SCtFbnpndE1u?=
 =?utf-8?B?bW96NmZZZ3JMR3dQZzQxc0hzeEg1RTNwUjhxRnRwZDZ1NlFEVmoyR2pRQTYv?=
 =?utf-8?B?QnJ6L3A4LytidElXdjhEdm4zeHZQTUZkWVRaRWMyZWdjK1BsUENSSjBwM2RM?=
 =?utf-8?B?TG9DOVgyMGZOVGlCM0htTm1zSHorZVVBUnQ2MG9VZXpRRUJDMHFqN015MTh4?=
 =?utf-8?B?QWpMYTFkdkpyUE51TjZnUlY3d2xlUUdGeXJCdVYrU0ovb3djNjd5bnUra2pa?=
 =?utf-8?B?WUxOMUhTdUtTbDV4UHBGZ1R6YkpkeDNsNnZOV0QxMTQwL2N6QWJibkRsR0xn?=
 =?utf-8?B?UEd6TnVveFVkaFA5WUtkSWtjMy83OHJrTWVHcUlrR0p0OUZ2Z3M0Ukc0ekw4?=
 =?utf-8?B?dERWUHY4ZGVTMEtGRThvdldUc3htL3hOaHltRFNKYUxoVkZUT01sSVZXOGxm?=
 =?utf-8?B?bjJ3b2psRmZMb2VjdG5zSjVrT2dMRWF4ZDc4bG9tbU9EUFZra0hUMmtIdzBG?=
 =?utf-8?B?TC9HcTVVNjNVZC9ZNjR0ZXBjTVdZczdZVm51MTh1TmVGM3Bmdy9SZzFqcnA1?=
 =?utf-8?B?bnhLQzhJcS8rQ3RLZjZzdkkxTFp6eFpmSGwyNmh6MFEwUzF0ZDB0MGg1OGU5?=
 =?utf-8?B?emlPclBXSXF6S2JrRWFmdjJNMS83eHpNcEFPU0lPOVhqdnFxeWphdWVFaFpU?=
 =?utf-8?B?Ykk3V2t3cTFKb0h0YlR6aTg4SDFOc1pXUCtFb0dVQ2ZGbksxSW1QcWFXU3lm?=
 =?utf-8?B?Y3pVQ1ZvenNGZXphN2VzZFBob1p5NjVaazZmWlBpSjA3N0pHRVptK1ZiV0Nr?=
 =?utf-8?B?NXVvWXhJNllYM2JtYjNpb1BJQ0RNTWVQZmN2MGw5MUZSV0gzUmtkSERobGkx?=
 =?utf-8?B?WjB6TERadjBRZFFaTXdXa0ZTZURrZlJUOU96SHAzdGY3bjFuS1Y0aHlEWlNY?=
 =?utf-8?B?S0VyV3RWMm05TGQrV3lPUHoydTFMYkRSRUVxZm1ET29oZElDQW56NkdtWFZz?=
 =?utf-8?B?OWVHQms5VlBaVHhEaFplcGxJd05TWW5nL2ExalRZNWJiUlRwRXpDV1lKUGVt?=
 =?utf-8?B?T0kwdnJVMnRyQ1JOY3gvdUxyUWsrY3o3SFZXdzF2b0VUcmRra3pDVVlXZC9E?=
 =?utf-8?B?dHFETGZSQkkyU2dGcjdrU205T0hra1dDcmdSL2M5UkxHdzVzWFFRZz09?=
X-Exchange-RoutingPolicyChecked:
	Kz/zwBPzhRxZy4BtdEX4bXX8btwRakoWwn5Yv7Yu1kRqen83blX4GAfKEx2rxP2/TsAM4Ewtf03t/ca1o/UhacRiSva+ie+oR2uDyXCNeT5M3PStY/pXyyLrbxC/DFNsL/SFjjvPr5bxyDsTkY6JCayypfsz8iQhZX8auheYuk9U1I9izLpEyXzm40EVo/tjndfNXXMnBZT4Ett9oJJ77oxixQ2QikVihm7eUg2D1kVcElrIFhbgMQ6kBFubKBbgNgb9jVhiyWEg655szQsyIycDVtyTW7Gh0x1HC5oRjd6nwajRYI+ufq7VCnB61vpsY0OuX9Y0SPTuYA7mbnXZbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VOINuJWWIM1h7hgxaHA8bu1RXh3N7XywPezeANvuf/VdueShH0GSM1JOSYvLiOTf1QiSjcSzvZeyWKatYsm5/3qkGyu4KTGnxrE58flBLK6KDP+PopIXNvYUDPbr9ZnwL/pjWEq59wqxEf6caidfVlCHT8fjZ1ckCQnxmqaffkG2/4tAJeWo2DvfsFVAxXFdcjVga+KbBz9ldhePVSTNKcZxHwtN3saAU/LuHNCUrR0HkjxkupLvqTai4daer4YRJbM3kw1x7Y2hAq7/Q0iXjbsQLN6Jn/xVxpfh7fW2jvx93OMtODif3PC6hUxycq0ly29dGQZAsuDlGG4qKwTTO9T5fJjtrxx5dnTWfDj8Oewp2GPwLxysOV0enP2RN8R3db+Fs+omuSdM68oM6crdl5mkd1xF+gkr2+caxbESQ3EApGSGZDH+1x+j+P66ed94FVZabEMDsyoUlgY8ccwq8m8NUC+arJnkpxvbI7+hU4haCHngxF1rgP7GWx5KgmKKeNgxZZyl0GUrFWgIEkpA/WAMu3Og+ePoK+v8F6S7COkxiO3HFrdWlcMyJDnXbW3cWNyh9QmA3nJLrttVeYK0BNzkXc4QW3LHrnwrzC9gDz0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b05ea28-f3e2-4aa9-2342-08dec0c453a1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 16:30:58.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cxBpnPqLXbRvmKw2/PyBziAU66hSuXKRsqrhv9qMPRDSib/UrYbwqBuz9YOGDiJJJmirX25BC6MupPrUgEBbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8F9C59252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020159
X-Authority-Analysis: v=2.4 cv=I6dVgtgg c=1 sm=1 tr=0 ts=6a1f054c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=DB-LnrYK3QbjB47iULAA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12302
X-Proofpoint-GUID: Pb6IgC8ifRTKlhSmk5ks6vM8dMwKhsT-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDE1OSBTYWx0ZWRfX6gebMyMsb45L
 BwfASzBtwiqoqNIc6tEg/svkN7CSXngk9fmr9UYQaS55EpElHd2TyKhwqT06XcG8mYXf5xFQa0i
 oKKykv2unyOoAK5A4bppGUNkBLBBlHc8PHOYtOBtEvUS4nTaTu4HTBCMxdTKm2jvkk7eASSUcR3
 /gwGd4hHcnJqwByeJ4CMxpIVKAAp2h02vwHeuoyPDA2RD86gUMvmacNds8YKoHdac6edibzP6iQ
 g6syDW87lCpVX0KrULUbwA+Z9EQHJqzTFTkv0JnYDnoeR7fJoZwMfI6H5dX/vymoImD9iIT6p4V
 Jp8DM/u6DbVO5TklQYqydMcazSBzEgKSAijLU8Wux/nrtGPXiMiAEqIHeZnE+2WtuTvdYh8eulO
 S/KwgqFgMBNJELwBAy8Fd/Xj8uXolr7WW21EOUJj9onsUJjP9sqZ8HBFxQYq2kSzxbNh/WJxffk
 QmbBxpj8Qr2klWAgtZuT7IiVgB/C1wCJJR/hRDwM=
X-Proofpoint-ORIG-GUID: Pb6IgC8ifRTKlhSmk5ks6vM8dMwKhsT-

On 30/05/2026 03:49, Xingui Yang wrote:
> In sas_rediscover_dev(), when detecting a "flutter" condition (same SAS
> address and compatible device type), the code assumes the device remains
> unchanged and only handles SATA pending state recovery. However, this
> approach misses two important scenarios:
> 
> First, the flutter detection only compares SAS address and device type,
> ignoring potential linkrate changes that may have already occurred.
> 
> Second, after sas_ex_phy_discover() re-queries the expander phy, both
> linkrate and attached SAS address may be updated. The current code does
> not validate these changes against the existing child device.
> 
> Additionally, the replace code path (different SAS address detected)
> has a sysfs duplication issue: sas_unregister_devs_sas_addr() only marks
> the device as gone, but the actual sysfs cleanup happens later in
> sas_destruct_devices(). Calling sas_discover_new() immediately after
> unregister causes sysfs_warn_dup() errors.
> 
> Introduce sas_dev_is_flutter() to check whether it is a true flutter with
> validation for linkrate and sas_addr changes. It returns true for normal
> flutter and false when changes are detected requiring rediscovery.
> 
> Introduce sas_rediscover_ex_phy() to handle async rediscovery for both
> flutter and replace cases. When invoked:
> - Set phy_change_count and ex_change_count to -1 to force revalidation
> - Unregister the device via sas_unregister_devs_sas_addr()
> - Queue DISCE_REVALIDATE_DOMAIN event
> 
> The old device sysfs is cleaned up by sas_destruct_devices() at the end
> of current revalidation work. The new event triggers discovery via
> sas_discover_new() since attached_sas_addr is cleared, avoiding the
> sysfs duplication issue.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Suggested-by: John Garry <john.g.garry@oracle.com>

This looks ok, so:

Reviewed-by: John Garry <john.g.garry@oracle.com>

