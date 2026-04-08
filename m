Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453673B47E0;
	Wed,  8 Apr 2026 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647756; cv=fail; b=bwNr8XG3aZ7OelraeiaVDApr9ix4dCJ2HpScMtV5OlQBHZZPkr0Xo2MYuaVJKqg6J5hK6o1DjvMk1siA3WB3kIeaOEn4SNqRK7CcX57SEbQgdSYpDo9CA3jRr0L2vtTXlmgvbaNGsSQSEXpRLJQ2MzTCAxtwANjiJvWMHWbQNz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647756; c=relaxed/simple;
	bh=NI311aUw2QgfO3tS+QGSFaLWAwhD8PL1SZ8bVlYMpys=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sbpwEPXlN9/GkNgyiydELJrfsNI9zTHI3jjc8BtU5AcxCpPpj5u+VGHtBmOAldYrEOo6/D4+l7T9Bo03OTCBjFebTYO3jXvZMnLvkV1Mmzl6MRIYfDNDp91p08qnyAp5cZ6ZsIwJ1rx5vi3gGlLPynDhctqO26GXyZqPWxOTFHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jxBs2KSC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ewMi48iB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jxBs2KSC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ewMi48iB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386krw11227468;
	Wed, 8 Apr 2026 11:28:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hFWWT0HDoriPrGwa71FnC069V5R4NWWKxPMi0oxpaPM=; b=
	jxBs2KSCTql7GpLOwwox7+9xIGcDrKN+I5Gk+sgGL5AyysDBpu2EK+IDAvbIIQfZ
	Q+un9wuPmy+cDSVv8Se2odDaSCCU07XrqTM5RwKo91DuTFb2skpAFDsfiq5yXv+e
	s5yWtYTQCUZCirvQ+BXr4EF7drlQPCV8JHsWsKlAOool+Wkc9/wn+9DzTYuc9mfe
	Z60MzsERvaFNeoF8/P1rBzgLHaKMxLlHUmkZ2qB8WfQtO0PYSwGppvc0VNev4vKy
	3227zYG6RnPBUTnWOednkg7WR0HS8mQbg2w53Fx2xWewPeo6qBjmZAqqmE2rlrSx
	4EGlu4Q++5u+tgHQVqhLtQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmq9ubrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 11:28:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6389bc06040097;
	Wed, 8 Apr 2026 11:28:48 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmn9cf2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 11:28:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LwUa//vfD/ZykygF0AkjeNxi5qPNGqbbWo4FNePMBHkLy7mBquyyHI8Ue5q0QKLIpI+LiA7kP6hDh9/jyKjluhm4jaQAgG8DuTVniHafH2Pi33pvx/xmVD0bVRmaCkur1s99i7QCUjjkVFJfAqgyqdPFgVArQHLRZNhjE2OIZ2PiCw6LE2YoFcoWiBaD3yQqLaXBsGdP9rf9wcyQOjGFt+kagZ6FjrIYPjw0DSLo3EWNYfsmD+2JqtnD6oUFIzNZJHhjyj3NqUoDEX/TcTMcal6oij8pL9fheUKyFITQIkP6c9SyJj5swa5BCknIxyL3GW/fWiuZu4TfWcTLmQw8+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFWWT0HDoriPrGwa71FnC069V5R4NWWKxPMi0oxpaPM=;
 b=c5IdMCESAWxVwqPy6AybG/Al4t4LloEvxprM6fSqr8avB5RUmGGr5qqF2C8cwzFydqprtSAyzG9XCctrtCT7FmE5kdlYvi1mAVYy5ve9j8RZFV7SVTy0VJFBz9nDV6ptgCDjgD7Fdi2XQgdTbs3KrhXM6OU3dQM4qD19Z3OtC3VA1KiYgS3mYJ5KqY9pzqHJN/VvQW852Z3NrK23AGWiSwmsXvXoEFi0k92LUc11/O+OH2Eo9yr2kv83acpy4zJiXTrX+jwvEPB0DiScoNXp6iW+K4O5RjNd997hfN+ymZgyt/QP0fu9E11aM7nrqDRtKPiDI7sEaZS8BfkzlQySXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFWWT0HDoriPrGwa71FnC069V5R4NWWKxPMi0oxpaPM=;
 b=ewMi48iBAxymcxQmMYasTOwO8/RkFKxGlG3dzyy6pttsolFYT9+iYEaCrqpXfnrjz3+gwR6ApbvvLdSiw4f5OdcGhhWqgCmh1jR3IzKWtwqtgUgw11D/oI2yIu/tGXUBc7jEWZ1+99/7xLVn0QVLArdqWQqrEvVjbrPoNdIk4dU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF085C55EC8.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d06) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Wed, 8 Apr
 2026 11:28:45 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 11:28:45 +0000
Message-ID: <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
Date: Wed, 8 Apr 2026 12:28:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0190.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF085C55EC8:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e2067a6-0166-4e78-98f2-08de9561fe8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0JGMptqhrH2juwC7xLGpK8mHfIjy4Vo+avd3g4+11vcpfOA263rWwlK/UXwbotHc8DkPqHBv7Bcmp2neN5pFIx8xjjVJ99ScRQyuZodrclEGS2xSSnpQkhW759ax8vJQ4jB2/Y2+CwrBKq3ASSD16zJKfXhZx0XclOWZ7GD2Hk9bLyG9TWUDgwLGR1ckjR7rMKYPAjdfcNjgF/1NMacWcSX9W06zwQzOgKVlo5AnV35puPGuXokCM5HEoiz9XjqruoYMp1NLvCsf4vLYsNryNGa85miSwFtrGL33nyWcX/NvOSBhA3g1vSxDHwuPh0uL/r4xrBuydGQ3y5fkuBJk8hjxiLGhSXxLSsNJCN6jhGdKVrUeAmIYr2/ookeai6aON4uzUc+93cojr12J0UCiZL4IZ4G1ghJqg+IkSAC39o9+LT7/s4DOazUvShGUVTqPBDtDlY0ObdbnfbpAYA+mqn3O+d21RL4UTZGGBQp3eGGeUnnZEC8vwWEsJpwEJuzGHmrTbfn97Fi7fIQK5VJWLnhRvEq2nbRMXgHPKQ+vHn7meTC3fpkgQJXXN4tHul+A6HGql89GNgH4DhJj6LcKP5SsCOUaXWEfMlEAtkImvcwIGK0gH56cmN93cvssS5MRXaR0rvNMYXD+SZ19xbhNj5YARLFUq5PgPIK/rAdTcsnGe3KR+LZs2wd0tSDQs4q+kpJlTEITQDLwFfKvlOpRXzMUtRgpMXhqCA+SFPra+xA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUZ5Q2FDUnJZS0JXd3pjMS8xSkRwTW5QaDBCTGFyQ1FRaExBWkhLRXhRdXEy?=
 =?utf-8?B?V2dQY2xwQUU5ditCWEtWanhSbEFla1JqYytJOTFKWXFtYlFoTGhwd3Z0eXAr?=
 =?utf-8?B?SHlDKzBTVGRIaGttVU1rZXdkaDQvNnJRKzRvOXhEOEorbmhISCtyd1JtYnIr?=
 =?utf-8?B?dEg5M09CYTdXVXJlMmk2NGcrL0ZybFQybm92NHN2LzRFTk9FdGU0eWZCQWR1?=
 =?utf-8?B?Tk1nYUVLVmhsdXNRaWgrWUJzYXNZV0hXc0JyTlR6dlZ5aEt2eUprVUkzbzcw?=
 =?utf-8?B?VTJZOTUzaG5hN1htMXVpUVV1b2pjd1VKd05Ya0pBREFMdENVTXpNdTYyZU1F?=
 =?utf-8?B?RC9VaUd5TThHWUlCWG8yN1ZEMVlERjZkdnJxbFJNNjROT0t1Zk9hSVBnQUF0?=
 =?utf-8?B?NmFDNnJoODVQcEFSTzdxMnZmSklKcjA5OHBsUnl6bzBRQXV6RzVVaGs1ZC9G?=
 =?utf-8?B?QStxdTdobkxhRC9BdklENHM3OXg1eHFzNEhBTno4OWdHOWZBcGdEakZRbWFj?=
 =?utf-8?B?aHg0SDAwS2N1eTlURTRBZUp1NnlwZ1g0amplSEc3b1dPU3BwZVJIdE1aTU1H?=
 =?utf-8?B?QWhwOE1aWFZ0bnVWUkpZdkI0VmtMS3pjNXAzMi83K1VYaDMwaEJwZG9pMHM4?=
 =?utf-8?B?WnoxZDFNVUxVRU8yUk1BNjJNaTJtY2EyMld3bXhqdmd1ZmpTUnhXSXVyMVg4?=
 =?utf-8?B?bXVsR255MlA5aEFvQVJDaGtIbUpYU2VyQ0RkRUc5Wmx6VGR3MW5SNUtwQnpk?=
 =?utf-8?B?cVo4WnpWM05tS1E3bklVZm1SVzlYTjcvcGNZalFXdHBKTWtLc0QzMWxhWW5N?=
 =?utf-8?B?c0NrNlg4bmpRK3ZXWWM4OXFpQklkbVdxeXVlVnIxckxlbXZheTF1amtmS2pv?=
 =?utf-8?B?YUpOdGJZSWp5MHdUT1V2WGZ1THRleklsdHArK0UwQ1Q0MlZ4QUd6SlVuSFRQ?=
 =?utf-8?B?ak0zeEtsdTZ6cDBaZ3huaHpUZkFtaTBpWG9mVm0rYjB5QlgzU0pWSkl5WVk5?=
 =?utf-8?B?bnJGNThDNFU0Sm44bUk2Lzl2YkVHYmxOQjJQd1JkdnRCejNISDd4cDFoeDNr?=
 =?utf-8?B?cEJ0cUJ3VS9xMjh0TG13U2RFRDhLVnhPc0xjVmN4U1V3WGl6L2VIWTI5THRC?=
 =?utf-8?B?SHB3NmxyQTcyc1J5Q3JaamV4cHM2UHc3R0ZPSmRvN0FqQ0pJNVQzQkIvVlNY?=
 =?utf-8?B?bTd5YUd2YTBEVmc2YjhIRThXd21WNUQ5T2lMMXYyOXB1VEtaQmZQdjFhdDJx?=
 =?utf-8?B?MG5ld2lJbGZOTDJmdFE4VHJqOGhDT1FkWWZ2ZU5UZ1FVSDBYNzRUdyt6WDBu?=
 =?utf-8?B?cTBwZ1pZM2J1RXJOYi9kNFgxTUs3RWo2OWV1WDgrSUhpS1R3MXdDNFFoaXJs?=
 =?utf-8?B?V1lRQ1RLdTVaVDRkVnBtRlh2L01rdkRlaXhCOWlUcTVlaW9FOW92eU9nb2JQ?=
 =?utf-8?B?cENaaDRVRDJmL0lqanU1ak8vUDBINzJoK0hhRWl3RkswaVdUblNkTTh1VWkr?=
 =?utf-8?B?a0g5dFhkZE9mUjNYSlZQS1FnTkptbWUrM1NrM1hIY2Y0NDFSVnVzbWhmd3N4?=
 =?utf-8?B?VklhOVJCQkZRcW0xNmxZR2toTFdGZVo0OFRCTFNFemhlMzk1WjFTenhwcjB4?=
 =?utf-8?B?RjVaSkplcGRGaHBEM0t5Qkt0UzJkRlVKYUdIclBzNzlKSkh0am9ISjdVT1Vk?=
 =?utf-8?B?c0t2MFZDeE1FTytCSE1rbi9uSUduenlKbHFqQXpZT3pKamF1NXdOUjFGTE9Q?=
 =?utf-8?B?dFJOUGw0MmtxYmxwSWgybll5RUpvbzNhTnhrY2t4NVBpZXd0T1g5RWw5NUtF?=
 =?utf-8?B?WG9aV1k2dWs5VFRWTWd3U2gvNk9oRndQWWdFNlFqeWJzODBDdUpHcGd2SGhj?=
 =?utf-8?B?NjRRRW5laUkxLzJITFBBblQ0RFhnL05sOGswNnFIV2VXTnlOUVhUMW1zdWUr?=
 =?utf-8?B?dHhCUXZ1Z0JDbXNSUzEzdm5jRW1qcW5zd0FwMEFrQjNyZDN2S1hPcE9LYWhW?=
 =?utf-8?B?SFdxdWE5ZWlVNkd4NjlydGw4TUNYUHdreFI0a28raTlTN3VGT3NiLzJqcitm?=
 =?utf-8?B?ei9NbnBjb3JNUzF0a2prMHpuZC9VVjduVkRLUUcxcTNyS3ZsRkZYaHlSYzJI?=
 =?utf-8?B?Ynd2QjJqd2QrWlVtYVgxOURCRUpaU3hIeCtuRG5MZm9SMEQrbFdZQzJNNkN5?=
 =?utf-8?B?VDBLVkUzQ3UwdnRCTUM4ZFRDZUIyZGVYYWpHM2ZSVSs5aUNXQ25jQWlKZ3NU?=
 =?utf-8?B?amZwZTUxQTNYL25WYU9ZVFFaaUY3bzlVRVRsMkwrYnNIOTgzZEx2dGQ4eDFE?=
 =?utf-8?B?RGtRdk1NY1NUZmh2VmxBeE94RHJqWTIzNGozU3I5cEw0czZUTFBqQT09?=
X-Exchange-RoutingPolicyChecked:
	cHLLKwJkdqCBRczfuZJ0DRwU0R91VaZMdqZwwiV2TBg56yDjIgGEIpPiKcfoWkWxInYe1/4cnAf4vUKfWBvsP00V2LquriJDdQatFlhGbv5pecAxMZM3PUQs4Pnt0xoodmmiW4Q5zEiXT5GTh8RoQ1T9Erkh4n8JJ4qdtVOLVzgiqYHXpKk0xfroDtTRZHtN36KakLE8nDiE/A/ODWB46SCp7b3HkPhw4X/9s5mPG8RhB3Z3J3aqo9A5s+eFmHBuziJa0Zmdz1WRrCAzrW5y8bdiaJBNP/vKUiL8xvQ6nEOnz17GhE2RAJHRnCz07rGbTlMvbebFaa9s+StvuwqK/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lXcF/s+R2DfVKUIlGoypwRScuyHvXr6HCIX1d9cbpagq8wV2DAq8B9gwCTngSvBZggleRGNsyTMTxnFt7JNxsXTnjWfUVJ51Pau74zWQarLN8Jxz+YKdPZ4rzi8Xde0+y1AWveau/K5QhXClRNlcuqZQGTc5LZOC3UPetioDLkxBERLN2yBPuapSskZuiBo+602WXWJnNWgDfe1kTMzHmBMoakdJc9n5z5mGFEJ3jV434N4feR6P8oKTBBRVpdlurevK3TMoSn/4mnYCKfMjxr6jLbT7MvXeXaQPEYSg5sgLp+vQiggljHUW/nQZeLz6KjoWZHo65VIQWIUIvNGkklVZzClzQAb9fcphGz+dxwtsT/4+6nD6QxZzQMd/goWYYlMoqT2AcPF7CVEklm4cEtAkXh4dV47PN+SV3ET7LweMbxSN8yeGIKZ6azCL1xcWVLv6Y2rAiYlR6G2nWe9ioD6hfgs86UEqhrH4fJBfbqV9hJn3lvBHf70JCqNSPQkbpvqOKKgIRq66/GZija/JCl8OG0kcb/6P/H0U1AJnnhcPZxnW64B6ltdCXfQ8KyZjewatuQeQA+v+FmnzkKCooo/I5lfVbqR//PqJPG28iQo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e2067a6-0166-4e78-98f2-08de9561fe8d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 11:28:45.3089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cFAmE55XAvMlV8uW45tCLl0EpxBR2O/6I61d6XbyBITG/WAk94/6NBqugwrJ28+xEdleknPrZofC5CQp7jIuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF085C55EC8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_03,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604080106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDEwNiBTYWx0ZWRfX98uyrlMNLceh
 5gF97+fPomu5pcCdBKchEP7xTmVNIwzWoQzhWseHw1UR86BYjt/GrJFfP4YBCD1gUevUXBAaWcO
 cg2E7Yc/+PLnc4tgSuG4RHE3RTrspdzorlEb0mTFIJSWcV+7+ldfjzek1mSncEJmsNfrX5QHjHV
 qeMi1sg7fKU8GnrlXHsQemcgMu3LmAu4ZZDfA+GuPhE0zEenb64sub+/4wLwODRUezVHXDovPVh
 +suqutovb2PR0o4GREdG6iXv5DN+Dk3QGFeU+qTJw7X3VRkEfMwn+uUIj8gwFt0w6nig9zePS5q
 LMW37xr8T4DD8+RqgPme6oJVxHK5aEcN6jnzGuZyALRApyi3iUzsUkvLKgb15oWEolGhaQ+/vOX
 5os61ZxSCtToCBThqyaXPb1rZ/tu94YaVS+gc9EVbGz+QfpkizXKxg9pFnl5MXygNifABTUKG/N
 HPzCFjEfAG4nJE6lEeA==
X-Proofpoint-ORIG-GUID: v69Vgp1wYT-bPzMaVuhiCYuS0emjtLPm
X-Authority-Analysis: v=2.4 cv=MaJcfZ/f c=1 sm=1 tr=0 ts=69d63bf1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=SHLv58NeNCR32GBbl4EA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=yzZZxD1ETDaWDB-n6lAJ:22
X-Proofpoint-GUID: v69Vgp1wYT-bPzMaVuhiCYuS0emjtLPm

On 02/03/2026 12:41, Nilay Shroff wrote:
>> +
>>   void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
>>   {
>>       struct mpath_head *mpath_head = mpath_disk->mpath_head;
>> @@ -793,6 +868,8 @@ struct mpath_head *mpath_alloc_head(void)
>>       mutex_init(&mpath_head->lock);
>>       kref_init(&mpath_head->ref);
>> +    mpath_head->delayed_removal_secs = 0;
>> +
>>       INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
>>       spin_lock_init(&mpath_head->requeue_lock);
>>       bio_list_init(&mpath_head->requeue_list);
> 
> I think we also need to initialize ->drv_module here.

Hi Nilay,

I am just coming back to this now. About NVMe multipath delayed disk 
removal, did you consider a blktests testcase to cover it? I might look 
at it if I have a chance (and it makes sense to do so).

Thanks!
