Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEF63B14CE;
	Mon, 27 Jul 2026 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785166846; cv=fail; b=ZsN0Ziy/Exs/gApBp95RU3mPAQwGav+k4gtXK0EY3X2dVoUhudRnWEtbLbyrmOn1zHy5UuGrcBxvgkfSWokWnffQtoqNRqLvoinxErM7lqajbmj+FI59D6/nYnS2l+HWKdAtylKBKAManZvYZ80hfLCG2AiUDcY7i07zpJ6R6Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785166846; c=relaxed/simple;
	bh=upehjfZSa72ip0yzVmd0tQ+aQaDJk+BsOKqHWigM72w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iVDAigwlxbq1mLdP2XG0bM0IfIAHFnLQ4Ixp1D/61HKxI28V9AKepz1Y8i8m9Ez44gTVafyheTDo7OqCOmLy1xXnJTeE8f5dqgybeWiwDMei84IoofDq3kbUCnWXB38xdZsqD8pO/tVJvmIC9XNWe7fTI9lP+R5U/qjIus4sULo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NfJt1UkN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qqzmUgAr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NfJt1UkN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qqzmUgAr"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFXULd3377097;
	Mon, 27 Jul 2026 15:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UaXiecCnvcCUY7buugsjyDji9E+EUCm9bQTLdMPD8oU=; b=
	NfJt1UkNQiQ/q+PQgR9+SY0kbocWUn4/AAQAJm5m5vJb6ikZZTBmKRYyi/gzjVGR
	52NiDXq3zIcPLYWV3naihtF0poBLk87QxJjZbx0+/4hEjA73lP22Q3wZFBCQXxXy
	hQnPzEmzs7DA65oHXVoYCM+Qy+gLvQdu9DE4HiFOyMuBNEyk3KrtFjMsliUHlilf
	5gApP1X49DpxJrSKxGXbPo8g3DNZ3f6SPnWY2eGsuzJF6jZ5+BArBmUz0+l+GFdX
	lNpmLDxFc7iksu3WD1vDzXO0ICFSp60bVg2hmwiZa2wtK51zQFEJH9/1SNezsd47
	8+kDOMdLNAWpZsf5JWzRKw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyya3c8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:40:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFe5QZ027945;
	Mon, 27 Jul 2026 15:40:42 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehdj1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:40:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgDobCRBTU57mcUoa0gO1qYS4nlACTwMagBpZKckC2FNTwx8KLaizdF9zHXLJGKIR0/uW8JEp+05Auf/W7eon2NiT1iC4Bqw5Fc9PrEK/Khrlu+78V10Q1Ntd5C2QHSURyvdV1ztCewksU5gdkfB+LaGChPobwYNmBhmLaH+eSgAK6UlNgRamk9p0bNPCpZrJP46hJaqhLTiiH5ClM4Hp4BnEHru6rIWHxroA2OXZ2/MP6LCyVbm5htuOPitatvdfZQC6sn0EFlbhyXar5i5o/zMb34GM+baiqot+kzWcEq8xo33FAvQcItFcCS8fE/euLOU2B51tgI4BYjpqnwIUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaXiecCnvcCUY7buugsjyDji9E+EUCm9bQTLdMPD8oU=;
 b=t7hAMYWK7CiyiBuOPVYVwD+BGTesJEP/iUdyA9yNdNJ9rD+yAA/muVvWpAGmqNSGu1asLBSomOeOBdI31/x3KgkwTjr1PEFz7h/AhzMVTnup+727iKmfpPK6SIOe2vIK076YRAaVDKr/wRMXjCZcWaAdfXo15O4F7sLWpThtuY9a/SBEK5SsiH8T7N721eN8Ryu1ekooYmzBlTHHw3JYQsHs/f0KFY0wWrdu43bMGQtdKkXaDCuhyqMwJIV8QEkKVSUCoYhdt4Ysaoupr0NQZO3nH8Nxpclk6Z59bpbZhMTknuk+Rwzfvp/lo0uazblAgLN3UGpuBGqCP3fIbwP9Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaXiecCnvcCUY7buugsjyDji9E+EUCm9bQTLdMPD8oU=;
 b=qqzmUgArvVZCX9H6LGfnq1U6XMYglXVry8iMyXn5dpgSi0fE0iAh7slDBXXwrW5IFvPUdCfTwZEUaMhML3hjVMQ8un6FAxq4n6GIIKeD2CmU88M1I82VV8sKFJUydHJg9G1fqE+iiJHVbtCmR+Prw3ac1KahXAxlg9ZdWsH9la8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA3PR10MB8735.namprd10.prod.outlook.com (2603:10b6:208:576::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 15:40:37 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:40:35 +0000
Message-ID: <21b03929-6117-4b3f-9244-fef51ae0d0ca@oracle.com>
Date: Mon, 27 Jul 2026 16:40:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/27] scsi-multipath: clone each bio
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-16-john.g.garry@oracle.com>
 <20260727152119.96DEB1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152119.96DEB1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0110.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA3PR10MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: adad8e56-7794-4462-f5ea-08deebf56676
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|6133799003|5023799004|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qVpmwAdbAF3skFHDu8cMSf/pnFmN6VdONVE2dpcO+Iau6VQhlhwOwOCgbSmT9OsoB6oTW9GiYdiTd8Las44qycEu8byZPA+DEiE1QpjuQtM6aIcF6yL2JlDW8RLn7CcEFi1gQsJ0PxynekYsDaXVrUZNpjl6M8e2NE1WiOKEg3OyiEvqO1nRhZRv2FAo47RodbAF+qWp/Ve9nFIv+sxaIS7viDhrr7VMHv8qsbVRuic9W8iNT8YgeV4jZaIaSiqZc9JEkrpZRUG49Ock2pEYHV0RGaop/gKXTNR9/1vbHCz7kAUWWpfu/2xCv6V05Wnu+EJqQVy3jZ8V6rZ3j2FmeY04w/+p5Hnv1gQn9oPHp79ef7aJRb7PoX5UeidlLbmYBwXuQSE9JUB1ETDaydemRSHXiJNpoJFSSb1Lhq1O4BnPsKXKSxbMvu4c6g9cfjDO4k5OasuSK5aPkbb6ZS9Nl6BgLhqzykRRl/1HWjPFaReMM1DBZv62CpLXKpywXrk25b3DMTFDKXiAvXOV/+S6ImmTDmC8tO0hjdc2dh0SAsNdGm0qaDbjVkaBiXtDsIpaFk6zijWbMeIpHH42X9GehUSVlPAsec2VE1pnnZY8mlRGvLpMJI310KOEUJJkmN2QNcFiCfJi7FdQuK1vxhYL7Qu32aJL1FfQYEyGacC6FiM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(6133799003)(5023799004)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2tUTDVzUHJBcDhIWGhJdDNMcHRKbU9tb2k3YURISFpxUkgxUW1POEErV2w5?=
 =?utf-8?B?QklER2dLbmZYSS9DeXVsSmttWHdHczIyRU5oYjdjd1ZIaVFXbzZmNERqNmY4?=
 =?utf-8?B?M2FyQWtIekx1Rnh3TG1xaDdXMkhhS1NvQ0ZQYjcySWpFNTRCOVUwUy9hUVhR?=
 =?utf-8?B?WUdTZktsRk5rVnlWVzExdU13VS90UGkwbXV6SEFET1h4QjRFNzVKalcyWnJy?=
 =?utf-8?B?N1BHTlBNbzVVVFE5YkhrNmZ3R3h2bHgzbUVENEs1ZFd0ZEhhVjZvUDFOb3BL?=
 =?utf-8?B?a3JTYXhKbHMzOTRYY1ZkbmpCdjhzYlpKN21QbFN5dnQ5cHE0UlNOOVNodHJr?=
 =?utf-8?B?RnNza3NHeXY5KytrOU9HZE9BOXNvL0wwcVRxZ0hzRGJFRjEwZ3pmcnA4c2Jy?=
 =?utf-8?B?MVVTdGVYaEdZY0VPTXo1UmYxQVdkZUVIVGNOdElCMWh0cUl6eklncTVyK0Ey?=
 =?utf-8?B?RGllSDk1cWZ0MXNERFYyK3pydG1uS1RvOWlQbGlXQVRNY3czWjRPTGp0akdP?=
 =?utf-8?B?MWJvZGZyOU94WGgzVCszT1BwZTNvZkRYUlFXTWowVStIQk5aU0JVb0htNFV6?=
 =?utf-8?B?Y2VFV0NvR2RlWElZUjU4cHE3emw4RytxWVVyM2pVTU1WeUNLU2lxSElkT1pp?=
 =?utf-8?B?SU9WYVFsakUvcXlRRUJ3UkNkZVlUMU1PaVBLSDczN2ZEQ2NHVElYTThJU0J2?=
 =?utf-8?B?WmRDY3V1ZmZqekJoVEtpZ2ZoQ00xZ3gyNWwvVnllTExUbFdFbUZvOFNaTlI1?=
 =?utf-8?B?dHR4UzA1WFhITmNWQ20zcnVzRnhpQVFwYldHRnVJMjloaHEyYmxZRmYvN2N0?=
 =?utf-8?B?ZG9mV2pOSUlZQU96dGlqVmdUR3QwQlYrVG9yYjlIaTVTRnRxRy9XNkkrV2h2?=
 =?utf-8?B?a3k5MWlURFZybWtFdHZIVndQZUdyd2lQU0NuV1hDeWlsNUtMTDVyVnVzVkhs?=
 =?utf-8?B?NDN4eXF6L1lncnJxcGNySlVFWCtXVnNqT1JZYXBTR0pOMWN2ODMwQlU1MGo1?=
 =?utf-8?B?a1lSYS9UMHBpWDd3ZlhXZEZHWVdsV0dtWVZxRkV3OHZnbUNYNEJ1VFRJVHNB?=
 =?utf-8?B?THZsN2t5SXhiQzc0Zk9aNncyWXRwZVpYZHQzVzdJajNPVXVKWnM2YXZsWUI3?=
 =?utf-8?B?cGo3alNJQXJXRTBUL2xYZUtXaHkrZUw0bGZIcDlhL0laOTRaY2lvZGNwWkJQ?=
 =?utf-8?B?YTZ3UjZwMENld3VmaEx0VmVSV3BOY0xFL1czZGlRVGx2VmRhVSt4UnVMbUZ2?=
 =?utf-8?B?MnlCdGpQamlNa1RYRld3V1BPMk1vQVkrMG5RVTRON25FalRQaC9wcHVPb2Iw?=
 =?utf-8?B?N0hDclhMdVhnL0hFUUFiZGJKQW91VUQ1ZUVuVlBCSG1NQWI5YjNla01qTEdT?=
 =?utf-8?B?WkRpRjVmQkM3bVBnc0xEV21jZGlpV2o1ZWt0RFIwMzhQaW1EZW8ycktOb2Vm?=
 =?utf-8?B?YnVKWmxFYjEzdVdsbmZzNDdPNHZDR1l4YjRNWXczMVBoem14dkFMSzhJSmZU?=
 =?utf-8?B?RVlCeDVMV1IzSElVU1ZYSzhMK2ZCRmg3SXZ2NGtDWkRRRzI2WEROdTdyUzNy?=
 =?utf-8?B?Wjl5M0xtZWR3dmZRRTNDaVBVUDJUTURXN04zK2FIc1lqM0U0ZnEzbGJ1bTFG?=
 =?utf-8?B?ZzFVdjdibktJK0xzMGEvYWlPN0UyVUV0Y082WS9DOUJxSzB5Y0lEcEJEMVRL?=
 =?utf-8?B?WUhqNFNkNmJ0ZXFtSFUreFJsNDBzcTZiYjNWZ1dmOVJKeXBLOFJja21WY25M?=
 =?utf-8?B?ZVFMcWJPaStyRE8vdzUwL0haWDNxUW1lT1NnZ21ndXp5U2c3bm5ZcUc5cXF1?=
 =?utf-8?B?VDhtbDlWMkdETnowZkFDVm96TUl4OVd4TlZjRHZSVWI4Tko2RXF5Nk9nQW5i?=
 =?utf-8?B?cG5HUzFkRUJFMDYxTktXRkxWMTFWVzZqV214WUpiYWxpa0hqOGVzdlA5bmdY?=
 =?utf-8?B?blQrWmNyOWZRanNNQ0JnV2JTTUwrdmFJNWVhN0EzTFhib05qWjZVam92S3pZ?=
 =?utf-8?B?VW1uaUF6c1Jlb29zTnBzN0pWL3JNenBQbWdmQ0RpZlFLUFo5ejdRRVo1RkVC?=
 =?utf-8?B?eFVqRGoyVE9xdlgyQWw0L2E4WEVhNnR3UXdnYmNycUk3Z1hyd1dMOEpQekh6?=
 =?utf-8?B?aFRaS3VVK2dFOEFsaDJXS2pEaUpxRXcwTlE2RkFRbk9obVdZSGIxYjk0aHF4?=
 =?utf-8?B?UDczcFk2WWFCOHRTeUxBeDhrVXpPSEFpZ2VadFJ4VzRWSk1uU1pVb29rUG9K?=
 =?utf-8?B?Q2lkSW5WSktvaGQvbFlOME96a25qOGtLcXNkRnI5RTZhbTNNYmlUaXNoeEdv?=
 =?utf-8?B?NEg0akNSMjEyVDZUVkszcEJxRnV4VkZWbjFiSkVPQmNvdm8yU3d6enNBWDFR?=
 =?utf-8?Q?+Fsw8Ng1GCpDnQFM=3D?=
X-Exchange-RoutingPolicyChecked:
	gNSGZVI/7AHzVPsEllfq3uJtwBFRl5U0AiJYzFtWqmRj0Lub1+364DvONcmydQmpXW6KpoxTOEGo1e4E9A+JfKY4plJNeMZqrRg7pV36J6lnYEDt0GEdgML0NgaK9N6n7H0rx+TXmIA3HJuM2bFivo5EXrb96fqRcnO8t/V3+Y/unuLNia40shBApVLlaplGkvsSoV95cbXyvP3GGm6xEEgq+e8hfHFTmOKjhl9zfV2oP2vV1sWlq6ObIWHYxRm0bF0ye79Un3toPFe9gdFpKcZ80IOh0OqR9bSd4mg6wGhEqY+L2eEA0MN4iJS3joPIfLjZP/MDkIw+gpgN0H0D3Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	24oSXfP6+uY0nOn41GQttxduwvj+CayM6pgi74SyrjhoaQOBRTZXDsLDmnregAlIE9b22H/d5G4go9rQ3bBjyjh0+XWdd5i1TUdQ690LgUU8NODWxEdKJnXrX+LV73oXHs2A6zn95feQ5S6we6W4NovQHTdpnWJrnGPcWQXkpodZd6vw1cNOpoAgy0pIh/3pfLTqMHEP2f6NaLDl5xdlPwj8iRd13OFkbgXaB8T3EPAL/DSayBWHSRZDXqcc41MgCyydur6ndV+fggaJlecfszLfHLH6vj9L4TdzxMIS3HcxWj2p9Mqw4CYb0ITaYY0yttXGHwK3tXeJlPp/zXFsob9JPK76+1pl8eQKiwZ7bIMNSix8+eBYG8q3zuVPcVozaNSc952y/46jbczklx3rppWEG1IX2T4vexGWkv0+bIfZnIaLOqQwO0dotltKyhb4zg3hsLVWIaqu5thumW41wuG3dainAXI25+DIGSoGkU7fQDh27MOGSpWkkrSTzZikUTuaSzPaCKOtbkx0UZmmhW5m+KnaR5azf3QcWon7TiXU89ovgDMan1opWsSPAvYwLE9ea72y8HsC1iZMyxmrex1sdMpqZ3rjKOG4LBFrfZY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adad8e56-7794-4462-f5ea-08deebf56676
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:40:35.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWBzU72i4ES4PP0vou8Z2O9cZmMx/putTgBjtzzc7LcVyYHD7rby9kjV6xoKOAS6VEzdi/betaAEi12EanJCRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270147
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NyBTYWx0ZWRfX/fNh0kKGOg1t
 44BZZdocVBZMoHVzel7mMdLKMcqgUjfJST39H77/E73SzVjRtXBOAKwmdDiFW67IDap0EHuRZft
 ZtZPh58G6qJMe003dmysL4Zxd9NJi58b36saVV5txr73wN7Qoo+h
X-Proofpoint-GUID: HExr7bGcA8eBqIaUwzBlEZCYc_APSVPQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NyBTYWx0ZWRfX2o6DLZlpcjRZ
 MIc5MNeis9cxK0XSN1JfjdFX6TlGL9bw0t+948xBZ9NrNT9bI9NURv9RxSQ82963oDSLrDA+eOA
 UlYuRdRzW30i7LG2GlhYvpCGqnUMx/eXCgzM7yM+L0LHN59vQ2v8vInCQ6lB91Ig+/SgMOyDm5Y
 BVnvMDi8WJsuPpoKvVouZpbTczxOK8mo1ASN5a3jgVl08tZzSaR30tDlVCePybtH7QXSsHAP2Ks
 +WJoImMFeyPX3qfBdqs434BX1x2rzvzyp0dTYqjl4ULxxm3J/XiRtEhdZL60+kVvdODlaYVSpvy
 +OZz7drpSlN99qwDQq3eCMTWNHQ786cdEshZOm79R+y52AeT/J3aBl1rbio/UaHSRUqxw0a1LRh
 GebpASKkw7Nhn7lWtcFiKBidA8K4/dGKs5C6KYE3C7y716GyZj6d6772v4lM+jK3AnpPB9CI7r5
 sxRj6LU/xkoPAkLtk/g==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a677bfb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=j6bfpGm4YkPphU5Awi0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HExr7bGcA8eBqIaUwzBlEZCYc_APSVPQ

On 27/07/2026 16:21, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The `smpdt` template in `scsi_multipath.c` fails to implement logically required callbacks from `struct mpath_head_template`, which will cause a NULL pointer dereference when the framework attempts to evaluate path states.
> --
> 
> --- Patch [15]: [PATCH v5 15/27] scsi-multipath: clone each bio ---
> commit d3a7e352069146b0f42f27f5c63fadf38b17548f
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clone each bio
> 
> For failover handling, this patch resubmits the original bio by cloning and
> submitting each bio. This ensures each bio can be safely resubmitted for
> SCSI, which unlike NVMe, has no guarantee that any bio submitted is either
> all or none completed.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 1b955e19a6814..5999c59bf7297 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -230,7 +231,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static void scsi_mpath_clone_end_io(struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	master_bio->bi_status = clone->bi_status;
>> +	bio_put(clone);
>> +	bio_endio(master_bio);
>> +}
>> +
>> +static struct bio *scsi_mpath_clone_bio(struct bio *bio)
>> +{
> [ ... ]
>> +}
>> +
>>   static struct mpath_head_template smpdt = {
>> +	.clone_bio = scsi_mpath_clone_bio,
> 
> [Severity: Medium]
> Is it safe to leave callbacks like is_disabled, is_optimized, and
> remove_head uninitialized in this template?

they are set later

> 
> Looking at the libmultipath framework, it appears to unconditionally invoke
> these callbacks. For example, mpath_path_is_disabled() does this:
> 
> lib/multipath.c:mpath_path_is_disabled() {
>      ...
>      return mpath_head->mpdt->is_disabled(mpath_device);
> }
> 
> Could this lead to a null pointer dereference when the framework attempts
> to evaluate the path state or remove the multipath head, once the device
> is fully hooked up?
> 
>>   };
>>   
>>   static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
> 

