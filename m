Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FE53CCFA8;
	Wed, 15 Jul 2026 08:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784103828; cv=fail; b=iMvgpO2CgmiFHQdvwWx0r/+WVED215vL/DvQXlc2J+NY6mvI+1EMjz30yKOCOOTEPuOQOHZM8Azs6ylp3YesaCc2ynOxPxkrWBQJQ88toKnXimwY3Id/vYfxBfZxkZZwbiBoxTOiAVq1RG7uC4ybqSvpYc8xEnMw0zHbrUs0BPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784103828; c=relaxed/simple;
	bh=Q5rfKzgbviEZGFwxXj8y/ki8XNPObqtQWK93uhd2rCc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rCwZunTyrM8bntO7YisC7F/uNtGlQyQr3n2NkiDNDTtCBp1JGAZyEfCk5kVjAwT0BhzHRsIkQa38urzPwSSZipvHUgbMx5MbuRtXXzeGSctnwkW9Vjv/Sm+1kVU+f6H/4+Hdx9WviPzStA7GiDksWSe/Qvtp2DD2Z42rMVQ3ogY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rFfcPXoA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JEuJnMrI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rFfcPXoA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JEuJnMrI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ENIqGY235106;
	Wed, 15 Jul 2026 08:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=C8VvdeVB9oyacZCW2cnRkEv1SPGrhzJwRQLHzLZWzUk=; b=
	rFfcPXoANsV9hLtMmiyj4u279e6OBMnS9YrSQBGPOIVw/+TQj5u7qamRnfL1Vu8M
	zX6iDpjVM/tYIsJQ/aKagCiW2bqEzqjAVnstvTJw5sPlz6IHO58HVs2HcqW/2Drx
	blQNVCzHvRRy0httOOE09pQycR6sBPuBc8UPHl1xICtswmSIWbXsFR2laoeNV3et
	T5rZmy+ZIq/LOCG25KC14DxdgwrbP3QUy9UJMhq413lpnuZeZtv5qDyoyQ2M6FMe
	0baPIvgnmA0a8+rklgZU8Ctz/7TI4S7iAAk3nMQjXC5BjalLiCnSkOv8cHCZknJm
	Q7ieWXfxyGetyZZdn8bWfg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedpd5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 08:23:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66F8NCYE003284;
	Wed, 15 Jul 2026 08:23:32 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9f5a3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 15 Jul 2026 08:23:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2phaayjRNzXKgcE+KtXV3tGj8OD+NK2/0PXwcuKlvZbeuYysQcNRPEAxESpt7t6VsLvsg4OMtT7A4DNtM2/cSMjCA4igXXA+EXHbSCDMVy7QnBQuStrp5xG9ONbhcFOCZ05YEOqwbGhc+XUPNCdd7uUabgvj9+jPOmLwYdg4ndq7CmpBS6wQtHBpa/32slChMDeE+vAUduJshHEgaTCpO2KT80xq/NVEHHkLFH9z6l7tK5/OZvS5qvW8A4rx+mzLqrr84XOj/shcw/Ik8s3vQfsUKYnHOZ2OCcz03dxf4Bgk8uCZbYASMDnJbnmxzjtIllJ0tUgw4KCmIjx8Hkx8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8VvdeVB9oyacZCW2cnRkEv1SPGrhzJwRQLHzLZWzUk=;
 b=CVOCjZj1jRG+ynxNtar5/eRh5Lo/hsfhDuEud/5e+iyN11yPDILhcX2KPYijrAyjX+WYDM9bsF2mknGy6HlzQJnj/i2lYW6XLE0vLlGoJp7ErRFASMmFiUc2gDmsodSDIe2OWGU4bv7vNFbMRy6ACNTXP7aJwvSVXQ6nWLZDB7V6yEBGOybNp6M98Z9uJhYoSh3zT6ryjt50h1gGomeg0krt5HgyqYk+b0skKfL2L7aWvR3d9/HZJKPtyfC/jda2PGJpJuZDR0AmFTHgd+Bw7bVM5zb/T3Ji/3P4TS2bXPhHm6Ign15IZ2p5hjXUhlV5PoskuoxMNevFbv1xgIb0NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8VvdeVB9oyacZCW2cnRkEv1SPGrhzJwRQLHzLZWzUk=;
 b=JEuJnMrIgiuB8spy2bBOVofcD0JYGyVhGzkESNob61NkHTJmRZVOSHBXDooGOv9qkSOdXUJqysnIL1l1q8D6j+P6nXd1jzhbmSg6vOJUHNZSGNSvZfT7xG8B/NLmnJ24Ou5OHkHop2dZwVJqxT1TwzRO0AILtxHA/h3KWtOoVvg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS4PPF7BD9BEA92.namprd10.prod.outlook.com (2603:10b6:f:fc00::d2d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Wed, 15 Jul
 2026 08:23:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Wed, 15 Jul 2026
 08:23:26 +0000
Message-ID: <119e4b61-3671-4680-9738-3cfc679ee00a@oracle.com>
Date: Wed, 15 Jul 2026 09:23:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260702033211.1743313-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260702033211.1743313-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0075.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS4PPF7BD9BEA92:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e8b495b-abff-4d01-0530-08dee24a57b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	bsDgA0GkSXIt7O6+iXJwnFQgixPOitACpqT64s2ibVE846b8z0RUIq0AL6P7YxKNv+3vrHKEtNI5A76ZqxsWgz5izWGVH6mJK4NXyM3itfpUMjftgpJ9OY8tQ1d6N9i9WZ69gXQEhj7Keg3UJ/IM5d2q5z/AxZMMTA8cduLHhg/7UKg8uTms8Y2GNyn1edc5IYDF9bPoqWk10ztnTviuHMv86fpZx/GC0IczWk9nz0BIRCT6KGNMXKSJQLPo+TNRZ6PPVHdbpm41yqwDlNu8rhV3s1kQQNRzONaKuapw5pFTWx9Ky/yb/UBU6VDLs0s2b5dEBAicu+RGytAGVMFRqEwE6NUNmu32LGpmkBteka6PUePYU3dmp1Y/zPewg2Rd+udW7nj3FLCxbcSabbOVmJO24JoSjCuPlaAJ4QaLZXSG5rcDF4GXuJvCiGSGTDiltWmFPIpBnYC4Yos21EavAz4zdv2R+HdYV+Fg4XHNptwwIkpNFukY8kToQ/0gbCBa4NL13p7E5XJuRtl0ZFZc7YpN32m5j34bjn/yz5Yuu0rvqMeL6H5f7SAOYxrKhZpWVIUUoNiFonm3gIgkiSqNcDvPQlXnhGAQVh8/8d1u+y2CQFLF4/tskr06v0sKs7g5WGLEJgRCRqYTd6V0eBVsYpy74UTtzMU65BvLxx6wAUU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTV0Ry8reXNNME43RDhWRTRkMjF0NlJpVkFZQURORCtVNjMrTnJuVnV6TEY2?=
 =?utf-8?B?OVZOSVBReUNvQ1JWUzRTV09FTlNaUWxSd25FcThLU21kaUNRTVkvWUoxUFMw?=
 =?utf-8?B?NGNzQVg1TXZXSHFxckttY3JiK2EydCtxajZ0OTBmYm5qVzhnT3hkVFNTaytj?=
 =?utf-8?B?ck5ROURJVkViOXFBcHF2RFEyZGpJdFNNOHgySlRrYW5yTWY0czU0TVkwWmNv?=
 =?utf-8?B?Y29MaXNhL05SdVVHNitEYWNOS0EvbE1aZSs0RXorb3hTRmpOSkw3cHVrOGxV?=
 =?utf-8?B?dGJ4RS9aYWhzTDMvcXRGaHlLR1B3UWM2bnQwRmJJNTRJZ2IrOUs1U0hhakJ0?=
 =?utf-8?B?ZDZrdnRtVUlzb2JqMkliK01tWUlIa0w1ZDYxNDJWakpUaW9yMjZyTXZiQmxX?=
 =?utf-8?B?R0dhaVV0UXExcEFyY2ZYU3NUZ213Qklsd00vc1FmdDRTQytsK093YXoxMkhO?=
 =?utf-8?B?SkFiaUQzcXI5ajdSY3pBMXdaRUM1OThhTGRuZlN3bHdDYk55K2lIZU1ONGti?=
 =?utf-8?B?K0FYaWNMZ01LTEtNNUFEcjZ2a1ZKdHIrTWtIRlJmTlc4WGhqaVN0Rm1PUmQz?=
 =?utf-8?B?ZVYyTm9JN2ZjeFBIVmt6MkF0emM5L1lLNUlkU0FNT0ZpaFplcGtPSHRaSFBy?=
 =?utf-8?B?VnAvdzN4b2V0U1g0cldDcVlUbi9sQlBac2tPUUtZak9ZOHJYVXQ0bVlrQ3FT?=
 =?utf-8?B?aUc0c1g4dnRMRTh3M2FjbDUxNlpaRzRMQTRtb3JzcVk1UXdIWGU1WEpYK3BV?=
 =?utf-8?B?akFFdzkyeWxyTzlHMWVXNnJFVU96UHdBbTNnaXhvdWFJanMvRVNGTHdxQU14?=
 =?utf-8?B?amdQdWs5aGJXb0RxM3IyNVZSTGdZeU9GMG1vTDl3ZTJwYXU1bkxXeDNrbith?=
 =?utf-8?B?YllPNzE3Q0t2NzJzNTRsUmhjMGc5cDIxTEhMWmVtb2tTRCtQZHU4SktGM1ph?=
 =?utf-8?B?S1pkMllIT3hpbEtHUlAyNWt0ZWlyTGhHT0tBZjhidCtQVkh0WXBpZVQ5eENU?=
 =?utf-8?B?OUZBbWV3aU42bExLcjdDLzR6cjNIUjVwRElMdThoMlZkREJXdG9wS3ZNaDVF?=
 =?utf-8?B?WHBGUDFHRVpiVXpTTmtVSExvbGZLM3oyclFQdnNPaklLK1hackY1alFrcDJy?=
 =?utf-8?B?dmMzMnNXZURzYlhza2FiYmVScVh2Y1lkUVJDbGtVT2htREdxQ1FyNlBjN1NM?=
 =?utf-8?B?dTlYMmhjcmJlMUZtb0N3QWEyemM2ZVNyY2huSzBZZzhoNGducmRQRDlaL0pn?=
 =?utf-8?B?dHc3U2d4bjVSVjRhNEU5bnlxdDE3eGF5NEF6TXBxbDhaTUxaU25yUVFGc3ZC?=
 =?utf-8?B?YVMwRVhwelNCN3drMWxQTjQ4OEFFZ2hKMFZCanp4VVpMeFJlUFQrRUl1NWI3?=
 =?utf-8?B?ZWEwNWJPY1ZVTkRnK3VWU2dKSHhOMXg3elpsd09QRDVXRlBmaW5tWW42TTYw?=
 =?utf-8?B?VURtZmtTbU94RTBOQjJodzdLU1hiUlM3YUNSVE1mdmRJL0liMC9GNERacVBI?=
 =?utf-8?B?UkZ4WW5TaG5BOE5hWFhSQWZFRzh1OVpoRDIzMTZRZit6ZWlyT1BLd1BMclND?=
 =?utf-8?B?OE93ZGdqdlROTHhOTEVpbDkwN0pwSFNrYndob1huVm1GY1hsUnQ3MVJvMmtF?=
 =?utf-8?B?ajd3OVhoQnE0dUlCZEloSTRUMFpIdk81cTBmWVgvVG9BS3RSSExBcCtsRUlt?=
 =?utf-8?B?bUZtT3lmUVdKS01MY1VJbzBBNmRrOGpSZWwvd1F3YUxRbU5JSWZrbUVIUVVz?=
 =?utf-8?B?VklmajdTSXd2d0ptaFJZUEFoZkhsYjM5SVU1RVppbWwvU2hHWXBPWURaRGZw?=
 =?utf-8?B?c3FVb2NleElnZUpvTHRmekdHS1RMSGhuNit5Q0wrVUQvQnRNZ1FaRTgrTHor?=
 =?utf-8?B?bFZVNGw0WnVNSzNPQlh1elVhYlBBQjA1dXh2ajZCQ1lCdWdsTThzZXhOWkNn?=
 =?utf-8?B?MWg4ZG5OOFNPYWd2K2dTNHY2WGRWeVpLa3ZIeGlmeEFoYUJYbGFEN0FnNXZx?=
 =?utf-8?B?Y3ptZjdyYW4wRWdJaFA1SGsyUGNCZklVcmZremE1NkhHdXZUM3ZCY1BXMGlX?=
 =?utf-8?B?L0E5UUJlWng5RXJEeG40UWtjVndUZnh6QTB0dHZ2VVljd1VCL2p1akVqRUYw?=
 =?utf-8?B?MWIxMkVWL081T3FFSjNSSjlWMFJJejJUV0d3OFdXUzBubDZrUmRvTkJjdjI4?=
 =?utf-8?B?OGY3K242NzltYlhiaWszcDRLbDVEVll4QUlpbnBoNHZ1Mjc2dXgyaStoTkpx?=
 =?utf-8?B?WGcxaG9BcjhPcTdCMUFuOVZZSE1sRUt1ZDVvT3pDM0g1cTIyNlhIZmpoYU9N?=
 =?utf-8?B?anFub2NpTVhYeWFPZVJKV1BEaWpXUExVNmFzdnA3RXMrdUpya3VMVks4WXI2?=
 =?utf-8?Q?XX0zCZabVWEdWK3A=3D?=
X-Exchange-RoutingPolicyChecked:
	WEH8uYRzkX8oNxBzhd9UxDa5sg1rbGc927FYYl8RCPOcGi7eVZ7DIPxYgTzghEybYMz+rz8riUVet+PAQ2p39WJqTafM4nxZxh+MQpmjvu2TfkLSZUmjOSL3rHb6tbpUFCPsmMFgrZps5ddWtmFUFsKJ17eD3GNOuoNpfjZ9WB1D7aLFxnAjkaSilVwmuV/f50VGX0r3mm48r/eLQ0lwuxzlubKu/BOMcj0Oe3I6tpEW8/wU7a8Vmrxg2PzitW5ZtHoMTJybhcpJJkmbjI4H1xh0uszeL1ZdHYZsMkE/aiyIRfHmn9y7DQbbrSwQLU4AoPnwZyLMp1USkS/+LqgtEQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9rWJp9JaQKQiOpmCWqT2mX6Lk9g/D7EIImTulgmNxCRyGulKRn+8qpD5sAMzZWvDVbgjiLh+aowEErHaP2CrrMjEtStAyzfc1oOvHWUg95Pqa84//I6MWoGnrWmXVrEleyT1a15HuMWDWInEhrin0gzFMJYibfea5lvVKcMKOnHiP53xRRd1jekOn/m8uVq0CzAgVGQfffVpA1llZ3DGwNJQj3ajN7pGgcEi3MbE/QgUJHCVThEvfd/TPqsKlGGJ7d1Ip/v8JyTv+sitd/jAcr/f2rOxbkOnl3j6bdyj4Plq4+49GCB5xfRUOoVnfWjcodck9JzIYkFBZkdnwjVpkoTT3TZsr15sjCDI3UyhhnBB1wL3hm5IiffdZYeJkmwGeVGoj/RHeJKBN91jZuXSa79Ia1SdlPY4V+QsmDYo+Of5fX7gXZOWGMe32OvCRypAOr+iNYw2UGpECqCvb2LzDHpc9CQG5AUXKjL0RDnFHpxyVE1IpN+T2CFpVlSyJBeHCkdTtFeZO6+ltyLnP1hYoRNJnGbVPaZdmLsi23N7hUds0ErT+IcPGABCAUuNjejUfrlBtFhc4U2rYuNXE/C8y33RqNMVE0EpFOj+FNcgIcI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8b495b-abff-4d01-0530-08dee24a57b2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 08:23:26.1247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oiz/tPmTjeVa7KvkLrr6ED3eyee3QiiOfaKfhbQeDLij0xcRlmb6Hy53i6c+75+LTxjQM5M509z8QZ0NAZNIHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF7BD9BEA92
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607150080
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a574384 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=i0EeH86SAAAA:8
 a=wZuTZ5vtnVNUk9FYjv4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDA4MCBTYWx0ZWRfX+rW7oNUjU7Rv
 jqPzMYQa0e3sggNLHuL8XNtwGyS0ZQvi9OzLcSZM8VXtatoIm1vl8V62A9eptYCGOUV5zDhATNm
 cjIS204IJdbH2RT8XIfxyYBA1XXw3nIkCeSV4lCTDlfCNyBRsVa1oz+ud4cBdhRpaiEo6zO0CGw
 9+mLsofLD6V8MiBHGR1CBURCZnDCyvSz/OJh4m5XZxI5dqbTfq+PRCGuqvHJV1zwMyEqMEPyXMr
 WkWTaKYMjIEI4QqLHlRUiXyLMGs9K8oolykTfn9Z6LoQSrWGr77ZKWvsPvGR+4mNvzKjSE9uNJZ
 6H6Ks7BqUlQ4looEAn6KM0wQyG38qm1WTs9YCDTFFpntOAdM9+QL1i5BaJ6xuyyx5cVekGObLnQ
 YlRXk88H1T+0Ifx9onkfwKc+O3TpQP1FZ5STo7kekWSRMR0NfADSnb9oQhqI4c9cxKeZbPif/xk
 4sKvWObQJMCCZ7rnHQA==
X-Proofpoint-GUID: yxUe4EAiuB5LMYgenhcqB43GPOirC5TO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDA4MCBTYWx0ZWRfXyEvz7lFAE+Oi
 nMjeDoU2mvw0hXJX5iEZicyt71cZPIP1Hq6Gn8HENdqLySARXMznH9/htK4Smv23WqDF8fWp3Eb
 3voG+7hcYlRgcrP9xbFRUvwTz5RBySqwReVl2lA79VtnXes+gUZo
X-Proofpoint-ORIG-GUID: yxUe4EAiuB5LMYgenhcqB43GPOirC5TO

On 02/07/2026 04:32, Xingui Yang wrote:
> Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
> for HA resume") introduced sas_resume_ha_no_sync() to avoid a deadlock: the
> PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
> sas_deform_port() -> sas_destruct_devices(), which removes SCSI devices and
> waits for the host to become runtime-active. But the host cannot resume
> until sas_resume_ha() -> sas_drain_work() returns, and the drain is blocked
> on that very handler.
> 
> However skipping the drain reintroduces a race: hisi_sas returns from
> resume before all PHY UP work and libsas discovery work finish. The
> controller may then autosuspend while disks are still waking up. The disks
> issue IO to a suspended controller, the IO fails, and the disks get
> disabled.
> 
> Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
> notification to after sas_drain_work(). By then the host resume is about to
> complete, so device removal through device_link no longer blocks on the
> resume and the cycle is broken.
> 
> With the deadlock gone, restore sas_resume_ha() (the draining variant) in
> hisi_sas and remove sas_resume_ha_no_sync().
> 
> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue for HA resume")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  9 +-------
>   drivers/scsi/libsas/sas_init.c         | 32 ++++++++++++++------------
>   include/scsi/libsas.h                  |  1 -
>   3 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 0687bdefcd63..c8673ae4e472 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -5263,14 +5263,7 @@ static int _resume_v3_hw(struct device *device)
>   	}
>   	phys_init_v3_hw(hisi_hba);
>   
> -	/*
> -	 * If a directly-attached disk is removed during suspend, a deadlock
> -	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
> -	 * hisi_hba->device to be active, which can only happen when resume
> -	 * completes. So don't wait for the HA event workqueue to drain upon
> -	 * resume.
> -	 */
> -	sas_resume_ha_no_sync(sha);
> +	sas_resume_ha(sha);
>   	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
>   
>   	dev_warn(dev, "end of resuming controller\n");
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index 0bec236f0fb5..624850f1483d 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -410,7 +410,7 @@ static void sas_resume_insert_broadcast_ha(struct sas_ha_struct *ha)
>   	}
>   }
>   
> -static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
> +static void _sas_resume_ha(struct sas_ha_struct *ha)
>   {
>   	const unsigned long tmo = msecs_to_jiffies(25000);
>   	int i;
> @@ -426,6 +426,21 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
>   			 i, i > 1 ? "s" : "");
>   	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
> +
> +	/* all phys are back up or timed out, turn on i/o so we can

That is obviously not the standard formatting for comments. And 
sentences begin with an upper case letter.

> +	 * flush out disks that did not return

. to end a sentence.

Check punctuation in future.

> +	 */
> +	scsi_unblock_requests(ha->shost);
> +	sas_drain_work(ha);
> +
> +	/* Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
> +	 * calls sas_deform_port() -> sas_destruct_devices(), which removes
> +	 * SCSI devices and, for LLDDs using device_link() PM sync, waits
> +	 * for the host to be runtime-active. Sending it before the drain
> +	 * would deadlock: the drain waits for the handler, the handler
> +	 * waits for host resume, and host resume waits for the drain to
> +	 * finish.
> +	 */
>   	for (i = 0; i < ha->num_phys; i++) {
>   		struct asd_sas_phy *phy = ha->sas_phy[i];
>   
> @@ -436,12 +451,6 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   		}
>   	}
>   
> -	/* all phys are back up or timed out, turn on i/o so we can
> -	 * flush out disks that did not return
> -	 */
> -	scsi_unblock_requests(ha->shost);
> -	if (drain)
> -		sas_drain_work(ha);
>   	clear_bit(SAS_HA_RESUMING, &ha->state);
>   
>   	sas_queue_deferred_work(ha);
> @@ -453,17 +462,10 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>   
>   void sas_resume_ha(struct sas_ha_struct *ha)

what is the purpose of this wrapper now?

>   {
> -	_sas_resume_ha(ha, true);
> +	_sas_resume_ha(ha);
>   }
>   EXPORT_SYMBOL(sas_resume_ha);
>   
> -/* A no-sync variant, which does not call sas_drain_ha(). */
> -void sas_resume_ha_no_sync(struct sas_ha_struct *ha)
> -{
> -	_sas_resume_ha(ha, false);
> -}
> -EXPORT_SYMBOL(sas_resume_ha_no_sync);
> -
>   void sas_suspend_ha(struct sas_ha_struct *ha)
>   {
>   	int i;
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 163f23c92b41..36d4cb567837 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -680,7 +680,6 @@ extern int sas_register_ha(struct sas_ha_struct *);
>   extern int sas_unregister_ha(struct sas_ha_struct *);
>   extern void sas_prep_resume_ha(struct sas_ha_struct *sas_ha);
>   extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
> -extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
>   extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
>   
>   int sas_phy_reset(struct sas_phy *phy, int hard_reset);

