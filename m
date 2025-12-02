Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50BC30BB8F;
	Tue,  2 Dec 2025 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764681455; cv=fail; b=Nv0lNPEU0cGfhhIaD+OlVy2hNtjT7xh/Ukeqf1IPeo4RZ65BueMV6QQ8BRnPawjQF6QO7QCeRlYhkYox9nv+ZOzpabjJeBa+63jn0uHSYzGjXBXM6wuKiUawPJJR0cS67f7bhPPI8rD5p4sl5RfJG08fu/YH10b6vS/xrLQt52E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764681455; c=relaxed/simple;
	bh=Yr3kN9ATXhOGf843WdoOdkz9NDrWNy356m9Pitgn5wM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lp7YsNK13lj3DO6pQThDsAFVHQ9/XYNU1AQsQYFMi44ZPWpuiOxsnzkS43VJMgjiOIxinEW2p34J6ehXXByVhL67dtf6x8QzHmY7gxYo2TDMvyrWvxbIsHgZ8oFIxP4/cO6sNzfIFSJYdy5SHnMeXSUwC73eZUtmo7DQ569MoLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eZF6B9cu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u4dAiIPD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eZF6B9cu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u4dAiIPD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B2Bv20w160862;
	Tue, 2 Dec 2025 13:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GuT8SH7ogEEu9IKXJ0utdYuuLbdqn8+LGocr88qnX8Q=; b=
	eZF6B9cuRcBg355DuxO2HRDNGuESezDPErn3C8lCtn0ebcdZHHjnaC+lIjHE8/z/
	VIT4ETEp+ITMk2YdBaGCX2cFnILihWMtOBgqXEtpSI6Koawbo8hhRUmzwt3kvOiN
	YXk6WitOOEmGLbli+A4ut4AZSLKwqldrsxT8pUa8+yWy4ZQYdwqljRIwAgM+CDQ7
	tlFa8UXW2vMHHyUG/n2j9VqVSrwSjWe7IE53WkjsRLEymJAv14PvIxrbFlBs3aHn
	rsGqNd9ri6qJhs5hsakbN1fdJLzcj3oWuB47rZGk7iJFcj1srBAb5XrF4BcJhDii
	BLZ+e3DeUKcivYZQW03J9w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f22xs3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 13:12:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B2Aauon023672;
	Tue, 2 Dec 2025 13:12:09 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9cupn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Dec 2025 13:12:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IDg6xZ5AZlBLPU7dETQl0JKp+wTjYDARqeM0esHT0gQiuHxpFkWD0fys3qY5pLjkDu4agDke2RNc3kMzcfc+xM5Gr45cWPf98fuNe8ucDVRU/rwSUjv3mH8PsdUz4eBMFDdBydD2acFRpFWVRvwfCAq9c3l4jRjSdFKbLgZ/+nr94/WwqSxSLd2FV7Nl3FbfJDykQ/sIM3IM+IMnpTF74rOwNvYwYJP93whXercftffBnzHHtMTb9l0d0ZEbcSwiuEpuL11n9tZCUtkhJRkkSyKYvXRkKNugtjvb8owkn3FQrU/h0GFRawqDQ7TG6aYjXPna/9ZZ9V79mVqHLavZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GuT8SH7ogEEu9IKXJ0utdYuuLbdqn8+LGocr88qnX8Q=;
 b=IDS03KO0UUyKovwJ7fTW5rARobaZJZzA7Goe3eRC3NHEPOQEmVd4IJpuMJEh881Ch5mC7zC8MTcgExwxX3uSHUgEBWIP+aKzKafXhWwU1PWJ1REytcZGfUIOU25WWNK+6OR24pjS15RrjGVWrTQ2mjTDwVJSBEEk2LxLhIQ4FxJAHh0O0qHu4kyBzxJbX9POZD0QqaOKi5C8IdcD5SiOQlgFEH2qAtaSqPjkZLGKWyAa5GDpBSiGiGlJddMl0mE96EkXKW+Nag6YgTQ5lQdc7n81UcFFDnIzxG+KN/+xUjmmZhH+dHiyvHkSDaJRnwXVN0K16LL2ZwDOBUQBvUpO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuT8SH7ogEEu9IKXJ0utdYuuLbdqn8+LGocr88qnX8Q=;
 b=u4dAiIPDmmWgeglTtARh2Cgmqoh826UgXw8mZAfrySSLBS3uaH+FxyjqGslMSgomNRFulgXdV38Coiw3XRmacqifmIKuxHZ3tkrJ24KR2PoikhvadBHAEHlymRQh9tV5uHYjQMyh9eUgFMI9YD+cQTlIEgtBsgvA5C31Ox9L3po=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB4930.namprd10.prod.outlook.com
 (2603:10b6:208:323::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 13:12:06 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088%8]) with mapi id 15.20.9388.003; Tue, 2 Dec 2025
 13:12:06 +0000
Message-ID: <0040f262-b820-4f6f-909b-a10b5b878a3d@oracle.com>
Date: Tue, 2 Dec 2025 13:12:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Revert "scsi: libsas: Fix exp-attached device scan
 after probe failure scanned in again after probe failed"
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20251202065627.140361-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251202065627.140361-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0024.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB4930:EE_
X-MS-Office365-Filtering-Correlation-Id: 69a14a70-b8ce-44f0-7f30-08de31a46438
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTdUQWdjR3NIOFJiNDBVb1VBU2NaOXJ5cWdGL3F5bDNIaWFTZE5JeEJBRStI?=
 =?utf-8?B?UGJRL2hOSi9BZUc5VW9UYk0yUmlIbWlLaGV4K3V0UGNJeGRxVjVzTVpTNEE0?=
 =?utf-8?B?NktWMFpTUmdEKzRNM3NQczNGQjJscHRZUG9GcWk0NGFrQXBWZkprazJLR1cw?=
 =?utf-8?B?eHYwL3gxMjJyakZxcC9jZU95bkZKa1Z3VGJvOG9XTHc4SjY2dWJWcEdta2tw?=
 =?utf-8?B?TklSMmFOS1UyY1NiZ2IrZ2RJcFhSeEZnMFVlRVZydTdmOFBxQTI3WDlPZkxF?=
 =?utf-8?B?QXVoRFZLOG9oQ09qbnVUZkdFUk13dUdmR0VDTHcrZW9BaS9yMnlKYnJnSmxH?=
 =?utf-8?B?Rlp3UkhneWI2L2cwM2dnL2xFaS9tSnh6ZmU1dGRoOWlhVVpQSS8rdUpFQ1hk?=
 =?utf-8?B?cUJkSEo4WENkMVBCdWMrYitMTVhvUXlobkl0RE16WW5rTW5CM0Yrd0lIb0tj?=
 =?utf-8?B?YldaV2l5d0ZRSXNkcnFObm8raTJUaWtKRUdueFplZFZyWGp3M2JzRVRDRHJI?=
 =?utf-8?B?YVNSc2pRWFVnTHM3VXlIMUdIdXJTTGwyN3o3Szg0ajR6aC94ekpzeHh0SW5p?=
 =?utf-8?B?YmkrZkxueHFBbi9uL3VpbnVyUEpsSThrQ0IrR3dhWTZiazFFZ0ZuZGZoUmp3?=
 =?utf-8?B?bDExbzAreUVYM2pJSVRWR2JCTCtCVjBPbXhRNFRxQ0JkREF4Q2tHSHNFUE1p?=
 =?utf-8?B?TDAxZTFTRHB4eVZMVGpRcmFmS1FpQ3dJVEhqcFBJbVdQNEgyYkg4V2hibFFp?=
 =?utf-8?B?YmxLcmU0TUlWbkRnVkFGWm9obG5TRFFJN1lFU1F3bndEMU1USnhMRkV5emda?=
 =?utf-8?B?YmtJcGZueG9zbHl2cFhFeGhWeS9vRWs3WmtHTmNvNy9PN3g3R1QvRDUwL0h5?=
 =?utf-8?B?ajNaT1pwdUd6R3l5eFN2a0lFN3owTjFlSE8zdE9uejc0QS9iME8xMWtmVE5z?=
 =?utf-8?B?Q2ZXYTJ4Rm91MVlrTkp3dGFINVdPUmV2S1FwOU83b0lzZEtmdFUrT2YwaDE0?=
 =?utf-8?B?OWRvUzlUb09MdUx4QzBmaHpzU2s1RHlXVmI0aE9xSS9UNWN5UVdEbEE5bnJ2?=
 =?utf-8?B?NGFpdlRJTjR3WVZ4cXU0TVpQZDRyc2xTUjRPZGNGc1QxTzNmMTlXek1MUDhi?=
 =?utf-8?B?c3N6Q1pkSFZaODM4RUJBUEt5Zjl5TnEzTkQzbTY1YkxsTkdFTlN6eEtjOWo1?=
 =?utf-8?B?eDhkdGRYM0hKMnU2cVpZNFI0TXdBb2hSSnN5Q053RURMcmtLZ0psSjR6VG1t?=
 =?utf-8?B?eHlXQklNSkljSEpqM0JTMzF1ZXZFNHNkRTVRMGpJMEE4ZmFYMjVxMVlCbUxU?=
 =?utf-8?B?T01pS1BnQ3dqWkh2RmJ3aXc4cVc5TDQzRkk3TUpLbjY1cVBGcm1WdWpHZTdl?=
 =?utf-8?B?alA0cVljWlpFM04yaUUwa3hIUDFhaGtmTTdhLzRTSW4wOU1VM1lOQldFR2tl?=
 =?utf-8?B?SGxJSGlZdkdlc0FsQmFFMkpvOWEzQWRTME1SYmhydHJIcndhVnJjL01rdENz?=
 =?utf-8?B?VjhrMWhoNnZGQVd5RTc5TUl0bHVwN1BEUkVuNjA5Z1kvaVpHYWdhdEVjWTQ3?=
 =?utf-8?B?dU9mSndGaVV0S21RdzZjVERiWExZVEFEUEo3ZDBaK0tyekpGc29aQjFxdjg2?=
 =?utf-8?B?ZlZtV0tvS3dZOFd0TENGTXF4aEtFTDhOTHNJRjg5VkJPWTRocWE3dWtIeVBr?=
 =?utf-8?B?bEpMY25MY0ZrcVNES0RFUytXVlp3NUdJcWtmME5jb1FVQmNscmwydDd2aitz?=
 =?utf-8?B?MFA3WTdrUXUvV1R2Q2tZei95WUtEVlNicWpOZWNoODVEL1lRTklqa0t0YVJU?=
 =?utf-8?B?SGFJQlJ6ckdFUXBoYWQzeWZBVU9QWEczb2JsRFZGR3ptTnRHWVYwaTBhU01K?=
 =?utf-8?B?QzVITDRJcmZBKzRkM0Y5WkpVcjc3YmI0cVQ2Vk9kc3VYQzB4eGtSQlR3cWJs?=
 =?utf-8?Q?uktuqnJdM3SjNsTsQvpUG7hsYEKCdcXj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTI3QlcyNHI5NkllbkRnYVNPK3IweE10aDhhRlkzbmJDSjRwc0V2NEpLRlov?=
 =?utf-8?B?eG0xRVo5eFN0OCt4WEJFMzd3ZjA2Rk9wb3lkbjZVNTRvd3dOdlFmM3NSM1Yw?=
 =?utf-8?B?cG84ZUxVQXdyMFBFY2RFUTEveWlWOEV4R0lzVVZ1UmdrZXBOZW9kYmRNOFp3?=
 =?utf-8?B?dmxKOWNvcVVZNUlBMUhveUN4ZGhMb2QxL0UxWGFQTGwrZWQza2d4M3F0Y3lu?=
 =?utf-8?B?ZTFDSXV1Yi9aRVlzRGVDZ1ZzREo1Q3Q1MmJxMVVWNC9vanVtSzNic0Q1TU0z?=
 =?utf-8?B?NlByV0c3TkVCVlpOSmhmT1JVRkZ1MXE5OWIxVzVRTjRqaVByUkhXMXZlZHk0?=
 =?utf-8?B?NUZsWXZaaEIxSStCSmt2U0ZnWUQxWjVOWHpiRUR3SWlrc0tZZk5mUW9od2J1?=
 =?utf-8?B?Qm9aejlmK0p4SzdscEVtd2ZaK1NMMnEzRlRHdFAyUmd1aUJhWW5aSUV2VnBo?=
 =?utf-8?B?b0FXY1ZpTVk5RUM1ZzBwV1J5U3V0c1VvSUJhWW5maDZ0UFRGeE1JYXFsZkww?=
 =?utf-8?B?Vlo2UjA2ZVpOWDRJam1oakZDRnpoV2YwSDVtZW9mck5EU0dXR3hJT3RyMzA5?=
 =?utf-8?B?S0tDS1VUT1FQRitjZmlMbXk1YXZSQ1hQUzFES0NKUURROVpaZ1ViclM1aEpv?=
 =?utf-8?B?KzB1bGdEbXNsODVTbnBIWUh0b05KMmVjV3ZaeWtDWGVtcithT3VtVWJrSENl?=
 =?utf-8?B?N0ZHT2h2SU9JeEFUUHBtUUU4cmxheFhvRkdQRTd2SG5Ed3ZHbytJMlUzYk5q?=
 =?utf-8?B?cndzaWdzdG9QRzhvbDJ5eThJdGJiUWxmb3lQSWxyYUFVTmlIaGxNM0NxNlRS?=
 =?utf-8?B?SUdTK3UvRis0VkMraTJMWTZ5dTlGaTRZQTMwdVdQRktOSlByeWVNNis0cG9J?=
 =?utf-8?B?T1JRQ0JzYWlqRkpsSHRSRkN3aWdoKzBzNTh1UzJSSHQzUTB2V2lpVlBmZDJD?=
 =?utf-8?B?UVJ2YWNnTzdWZnh6aFEreFY1by96Sk5VUEg2OW8wamJsbU5XMTMyenpzSGNX?=
 =?utf-8?B?UlVBemhZZEl2OHB6cms2WXI3SHhlaVNoSUhQNHUxK0M1R0NaVi9GOURiZXpz?=
 =?utf-8?B?YTBzT3g0blBablV1S1RuQU5kNjJmaEc0ekNCbG1wUFhYTGlhWVg5TUk3VkJR?=
 =?utf-8?B?bUsvWGJmMm9FZmhsa2l2VXRkcUFIVC9DTmhpWlFQa3JRcUdYQjlHRjlMZUxF?=
 =?utf-8?B?NUFybmh6Rmdva1pSclNSQ3I2MnpWU1BWdk5XT3BrWXNvK1ZEZ0pXbkF2T1dJ?=
 =?utf-8?B?Tno0a3hZOWxTSVRXOFAvLzdMalM2c284ZWZSWnNZR2kyVEo3WjhpTHAvZDhH?=
 =?utf-8?B?T2xuaXJld2pOU2dWT2tSVElNaWxReGJBYkVOZjgrU1NKRkM0dkltZDhCa2JM?=
 =?utf-8?B?UHpXQXJvTEUxajVkVjRBOGkwUEQ5QWNoelpjVEZPUW1acnZkd3kwTVJhMGQ5?=
 =?utf-8?B?MmE4Tlc0T241ODJkWjA1ZlVNVjR1bFZOZnY4NTVoWldXVURNTnJSdzRSbW9z?=
 =?utf-8?B?ZTZ0bWhaQXFKZXExLzVtZlpZV1FuVm1GSEFpSFR0Zk1vVFhpeEErdmcxd3JR?=
 =?utf-8?B?N2VsMWlJQTAxSXVGazhjdzYzY25neUllT3N6eEJZaldxeHMxVE82aVltdytF?=
 =?utf-8?B?VkU5L25UVDJ1SW4waDRWZmRZb0dvY3ZDMG1QOXljRjUwUUxadkVzWXBzTkhu?=
 =?utf-8?B?Ky9rRGx2Q25tVnVkVWtmNEhia1ZSbC9ETWVoK1g0dVAyb3RqOUVmNDdCa0RO?=
 =?utf-8?B?emtuRk1nZDg2bDdDZWVuSGk3V3paVmcwYmRHblREb0R2aXAwM1B0L2lGeGU1?=
 =?utf-8?B?bWVOSFJTdUJvNkRlUksyZG94OWIvNmpWM3JxdXdUajJza2lJVXZ3dnI2T2k0?=
 =?utf-8?B?OWg5bUxPVXJvWUFPVmRxQWdTRlZkUjBEL2M1UnRlY1UwTUtuS09adXI4NWdP?=
 =?utf-8?B?VkZXbHZCZGNQUTNMQ2IwSTV5Y1BLbnV2YW1mcHJhMlFkV3J2RFhlNkJ5eG5k?=
 =?utf-8?B?K2JLQnpCRkdObVFHbW42aS9UMUw2UnArWi9BbjNodmpUbUpLMXl4bThEZDJa?=
 =?utf-8?B?a0RHcmFXQXc5NlpzSEwvQWVRSmV1UldrRW5YQ3pFaVQ2MDh5MjNnYVJ0TlBt?=
 =?utf-8?B?ZncwRzNCNVZlam16bkY3YzdWak5KaU85b3NmZUk2U2hBUHhXZlo5MHhqSlJw?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7NUbdmrWde2GmpCpf/1NaIEfpeG+vwTbjZkX0Se7CtR3b9GSirnVBSYwRJjmQEQ7gYjzh402o7oqb0HRgYerwjN+O4pXLMqzyje9INBoi5+1ZVKJpf/q1vcaB+oZfGteW65UqZPFKFrX7gS/Pm41J+F1G7gvL/skPjeOEebFn1uX+WBBiA3X7UTKWygQ4B+4sYcMjJbgKDEz/tQHX4R/rGFIjdyCmrmPOBAB2utnGsKawcpu7pADp23xDo0FHxVYChbV1/k/6+QWzkOVlTER+sda6iu7I8W0doxdWZjDE6Ay/q4qPrG1vtaRi9CDBKrl7Oa6boOVCg7RyecLbadnsGhjihRST8D2eK62Jta5rXnUHp2edYCLKIrB8ElRhn0Hi2gMDGrvZmFDyIsLDsDUrBkkCoIYsjuqh588SNPO2s023fsha+prEt4zvwSBA6TZcOXuH6NrMxCf2eIoN6TnUVrcz1Gcz9b4zplTr0nLL1FC1YkmN+n9TCIf9djgEnVRiRvumsbdf260re/a92+BIxZcLTXJjXfa5aGOP3KLNCaPaFlzPLX7G9PiMURmKl1CtIdGcZfm3uVEIvyCRl5IXL4czq6H8xZOOmJRF3mlbLw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a14a70-b8ce-44f0-7f30-08de31a46438
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 13:12:06.1198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBnLKEhI6zgWs6wH9q8Y9X/TZ2w1hoHePKcpGo8U3k+HcgTE0bEBPWAVTG8e4F82d8DdYXZ+CpwI9kbZZoxawg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512020106
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=692ee5aa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8 a=35j0Q-EzUTZwH4HNpMsA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12098
X-Proofpoint-ORIG-GUID: 4cBerHvOwOBuaj4TK07d191letinHrLE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDEwNiBTYWx0ZWRfX956Ur5sWy4b5
 J8thunLqp/LoAU4eAixp75UxMy++Uj9ogXdlhM9oLopxers5GYJt+nXK+2Hhy8Wqa/iuJ4E/3/0
 ZzCJTxc9iK2JP/pmEIJRTgBw6BJBoNrLJvTPdUTn65xZpL54dIqncKkV33UW+y1oDimC6qvAnLE
 IlyfqHCEWuBlCj065gN92OE9dxcZVMbypkJD5z9geK5erXDPwkg4HcEEX0u7E0Haty/vLIy7+EV
 YbMgokkLTUZHMwoDnS/x1Waz6gW8xh/+WA6Wtn7M9XPwWYil/ABcvKGax1Fh0S/JPV+EORXSe5v
 bpDIbEmUMhXAwhxrdAcMTC7ZfefHMKqlcdhK0iRDjZNTaDxgiyokkUVPyquTKuTuu08hdf80U6q
 2ugllmVp2mymZHF0OUaznR2mJI4S4x0yzNuN/zdkzJ1bnuckWzY=
X-Proofpoint-GUID: 4cBerHvOwOBuaj4TK07d191letinHrLE

On 02/12/2025 06:56, Xingui Yang wrote:
> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
> 
> When probing the exp-attached sata device, libsas/libata will issue a hard
> reset in sas_probe_sata() -> ata_sas_async_probe(), then a broadcast event
> will be received after the disk probe fails, and this commit causes the
> probe will be re-executed on the disk, and a faulty disk may get into an
> indefinite loop of probe.
> 
> Therefore, revert this commit, although it can fix some temporary issues
> with disk probe failure.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Reviewed-by: Jason Yan <yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>


