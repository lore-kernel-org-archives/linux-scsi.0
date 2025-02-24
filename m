Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1784C264A86;
	Mon, 24 Feb 2025 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740418489; cv=fail; b=oXIW/czm8NS9VpUagrmeaFLMrOpAmkQy89jMqu3vUeoibyFcIdDLfd6bsxYh82pv2aC7EacZte3PG0eqAw/peZelAe2wsiuRyAppkAoaEYTpQOJTSBI3gqtp1o4XDXGcGebHIZ9J4Bt7YNI8P4JwMtUcR1HZjOQFECj+hIe3DT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740418489; c=relaxed/simple;
	bh=3pCEO/nDYpqcFJ/NNkn8LOlanKwInCFBX5RLQMDI4OY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GQvnsnQlCrHc19DdmiIDYOPJt98As9Qdge3QWhkMQuvg2MuOVGr4Uduv+F2G2nT/6JEk023eieYyUjZ3yd10bGhTKqWrMJTmO1n0sV6Czy8+AU/HY1BtHk8s64oEWEzMj6MRVfflog8b02D19a5APfVlil+GkuwKDS8kJ6RBBUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nsvpxASV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lyfVnHs3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nsvpxASV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lyfVnHs3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OHQSEL021577;
	Mon, 24 Feb 2025 17:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vWXBmGFXyv58po6Ndc70M7Kj+561+Q3IZvnXrI6+ktE=; b=
	nsvpxASVByyinuBhzlQcaM4w+s88nOIESL8EAS51djxDYFPmNA1+0BIF8jh1JV3p
	5McFp3OpfXTDDo2XW0QPKX95ddSGhrmmDflxZmU8PCQJHitSmOOF9vkEl3PXnLxn
	9kP9frd63uuoXiMdQsjpTivEYW65yP5EG/kZXV7gSpHIHDFYJUJDE0E0vWfdmrM2
	UwAqDRSmN66izTm4iy6xNzYoVHsR8kbKBIdC6QsYZb4jnn2xZvkh4lqFW+gOaxAl
	dtc8yy7RPzUx6zG8ZUDSv5Hs5HhexzEGSZfaa/y3TlO5bBONbsJnBdeBdLdq+Kfs
	oT7EDJMaFVGCQiUdrauQUw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5gak6ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 17:34:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OG3ImP002916;
	Mon, 24 Feb 2025 17:34:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y5187wq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 17:34:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nffPOZUOUXojcSWQYRt/H54DrkqBr/j68CyawdoKH9k1s007rDbv7br+4M1XycFXHgNnjciunKZki3CHIusSAXHh+rrRsWdZHB5aeFp0uj7DBWiE2d2zDyT3T1ZX1Z8yiJhosaPgx1JuTMh0l6xMTgoq8ArNWQrJpLOqJ4A6zjhV5H16WEYN/rMEAdG/uWxgiFNIzzF5V320w+NF2WEB09JqmHHAZZAil8i0eA1XaMKB81qTBjh7q25Ck55yQJkHEzQcMELBWkTNqLrb+0Zb5FT+9Hvn43LK+av1G+hSHa+CWgmjT+asBvxNQjTYVDF6MWYNyfAGgF5i27YZoRoocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWXBmGFXyv58po6Ndc70M7Kj+561+Q3IZvnXrI6+ktE=;
 b=k6nzYW0KRVfJeDIRC57aa+QyYFftlaROwMvAtTM3qfTOhoq48R1TSoezPlEhWPtIbSFZdDvYRwrJwFeHq8gjEI8+f5roCPBK6BP8a79Z6vZwa344YWEU7BL35ExeiDcG1Kp1Ia50aQ1p4SDXbk5hNdJbGSTpD4WiaaBbD212H38Vd8L3OaVayiTEUpjytc/1Hl8oR0QdWSjQvDGmWAKN5+BoYw9wgrhcp3z8DdaHi8baTtrSxSKe9rhLzaqypL90GBDgKa2g+VnjDkeW5EM5ePzHdiwTOoFOJSken1hDJLubNY/VM2i83ps+idxXpqRnn9hrXF9kd8PUJ5izySGXDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWXBmGFXyv58po6Ndc70M7Kj+561+Q3IZvnXrI6+ktE=;
 b=lyfVnHs3ednOcH/Zy0zit7MY9DAdP+GICccTsJIpvDXLKhXKnv/iJdWtKyG/MVTvkSmql2Jot7ICe/rskYUU/poGFsKao+d2HdNSUzDExesFak12O9xmhpQLUoKwvNWVVZ4Y1suDmzjdUFxP+SUvADW13PSw9M1qlLzte79sszM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4114.namprd10.prod.outlook.com (2603:10b6:a03:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Mon, 24 Feb
 2025 17:34:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 17:34:11 +0000
Message-ID: <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
Date: Mon, 24 Feb 2025 17:34:07 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: yangxingui <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::39) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4114:EE_
X-MS-Office365-Filtering-Correlation-Id: bbe2fedc-3a35-4b62-f311-08dd54f97310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Slg5ZkJOZ1dlQ2Zsc1doc2tud2hVanRJQTlwd1o0VHJFSTlNQW4ralZvU2Nh?=
 =?utf-8?B?ZVZtUmIzQTVrQkVlOEpaNGpvRGlxVDZqMmszOUZKU09iaUF5VWRnbUJMK2d3?=
 =?utf-8?B?Q0xqenhkZlAzSU9hdE9NVGFzUEVFMFhob1FCZ2xPODRyekpMdXZraGRGTkpF?=
 =?utf-8?B?d1YyT1NIRmVoYVpnM21xK3dIbFBvWlJjSHU5emNWRVFjcGtnWVRWVnpxRGJs?=
 =?utf-8?B?R2RPbkNzVG1NU3lTVVBTRFV4SXVwTXJEQW1YN2dUQ0RjKysvdzVWcmxTTTc4?=
 =?utf-8?B?dWN2ckw3TEsycXRTUGhYTnhGdW5qaXllTXZ6eHJpYWdvOTRmNGxRUXdjTkFF?=
 =?utf-8?B?NWxuaTRHdkhQNEZiSStXWUFEYWFqQzhrMmhNQUptTVhWdTZMOFMzTVpmak5P?=
 =?utf-8?B?bWQxK1BVT3ZMN09xVlBDTW0vNXpaVlVHUGlUTE8xY3puVkRtVk91alg1QXhZ?=
 =?utf-8?B?Wk5yWVBMelFjNUJVMk83MU1SM3YxRjg1emxlc0ZPVmxqOGFUSkVQSXQweW5W?=
 =?utf-8?B?Q002d3IrbDVSbmNuODRCakV5ZHJuSzlDNHRWQnQvS08wU2ExdTVFQndXNVJ4?=
 =?utf-8?B?NFNndzRaVFZubXdCb1lBOERBVzEvQXVXUlYrZWppMGxkUGQ3eGZzVXpXTWhq?=
 =?utf-8?B?YWdFV3dZZm9wVUY5NUE3S21abVNzMTkydWE2RFV4K2lLY1Y1eHNCQ0FtRkNy?=
 =?utf-8?B?MTVMTzYzSHVMVjZ5VVhHT1dYeVdRVFl5R2p5RFhsbTZJNEQxeWFPQ0h3S2tR?=
 =?utf-8?B?aUE3NkJRTXJ4Z05lQXFkdGRQTjlBSlF4dG1wTmcyY0c3VEFYNVhIVGhyQnFh?=
 =?utf-8?B?NnZ6R1ZmNVNkck1nYzhKajdybE85OEZyQnhXbXN1eS9icnRZSDN5NnZTL09J?=
 =?utf-8?B?TjdaMDB1eDkwYThlSEVBT2V4TEIvU2xCQzdpWitWZ2ZKQ2gxeFpzcTV6ZHRj?=
 =?utf-8?B?d0J5VkhxT2RTMjBHWXBETjhMNDFubDZ4enZZZVdRek5mZDAzRGJwTkVSWGNO?=
 =?utf-8?B?YldxS2pKT1JWNExXWUJ0WDh3K0dscm1PMVNQNmhDKzV2V0pkUTQrcEErSnl2?=
 =?utf-8?B?eGRjc0pSZmhZa3RUVzlPMm1RR2JRRHArTEIwY05pb3pjUEJMajVSdUFTQnU2?=
 =?utf-8?B?d21DVUJVdjdmZHZMaG02eWFmaFZTdWcwTmt0d2VpNktMY2NSbTVmQlFidHd2?=
 =?utf-8?B?SDJxcmR3NllWNk1kUVRmc0prdmxkVjFuS1R0M1JmTWRKb1FLaERyL05qeGpJ?=
 =?utf-8?B?cjJYLy8vUW1ka25xRy93ZndjVlc4Q0VDWDUvbmZCUWdzMzIwMStpaXZtaGVn?=
 =?utf-8?B?M1FoUTMraVhIUTBJN25NWWM3YW5TalI3MzZ5S3NLRzhJNGV5WjRNbExscUpT?=
 =?utf-8?B?M3N0SU5GMkp4bVpKRWcrTU1ZaDFHRzI1Sy9HTm51eGRXYjNWb2UwN3V0RFFr?=
 =?utf-8?B?anQzTmZtUjNVc3h0THBMQjdGenRuTFZONm14Znlnc0VTVGFtaHZMNldZMHpE?=
 =?utf-8?B?R0F3d1E0Njl1Qit6QjBnVFlhRHUwN09GVlJhT2U0emRpTGs2VUFpSFhMZ05U?=
 =?utf-8?B?QU9KUzZPWUZTc0JCOXVZQ0VyaEQ4UyttaHZpSEM3Sk5FdUIzTFNYNkZhcmFa?=
 =?utf-8?B?RGlTR2RheDNoajN5YlQzdGNtUzl3a3lubVBlMSt3eFBiK0poYU9SNGM1bTA0?=
 =?utf-8?B?L00yTmVoUDhKQmhLNFNBeHhqbmtGQms1OS85Q3ZUdE9zMTBianlqc01wNW9G?=
 =?utf-8?B?NWxZb0hEK3A4OEdxVkhVejYrUzd1anM3Qm8wVkVBczJIT0FvTnkvbkhaM2Vk?=
 =?utf-8?B?VFFiNFBhK2NXTmVwbHozTytDUU5lN013RU9VOUpYUkZWaWJCUGVjSWFYZ25v?=
 =?utf-8?Q?D/aZQ8Q6smEcp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mkg3Y09iYlQzUDlBOGVDc244azE5aDJYK3RMdVFranlXMVoxaXJHcXZCSXpr?=
 =?utf-8?B?OXVnR2ZSQk5td00wSFF1YVRPYjdJSU1DODU0dUhtUmJsNjYyc1Fpc0U2RWt0?=
 =?utf-8?B?MEZZUnFKM2c3TDEwZnZSUkpKRzBQYldyaXQ3U2lDZFp0NlVvOURzcE1pRXY3?=
 =?utf-8?B?dUg2UGM3RnlLZllrQ0xicTRxWk1TYlRyMElrODd0dkNXekU3S0xicUlrMk9S?=
 =?utf-8?B?eDN3R0VPRW1lZmk3RHJ6bHdrOEhPTWdvZGxMSXN0ck0wcUx0VEFjV21HdE45?=
 =?utf-8?B?cGZjbTg4V2NRb2gvY3lsNitvWjRodUFqMTNSUzZReTA1b3RUazRob0xuK1l4?=
 =?utf-8?B?dDRSUmRUZ3U0UGZUM2xrVnhrbzhldHBKRFhoMll6U0I1Y2Q0MWEvWS9oazNZ?=
 =?utf-8?B?YnVHWmZYdS9IeUMrKzFadkl5RlJ2d0lSa0pSckc2cVN1UUJRTTE3UDVRM1JU?=
 =?utf-8?B?aFhGVmJYMXU5aVhBalNqczIxSmVmWGZFU3VXQmZKT0tIUjNpdXFiY1VYajNv?=
 =?utf-8?B?QThYaDcwWWNHOXFya2VZZVd4NlR3NTRBZzh5amJISDNZcnIyWUkxTHk1V21Y?=
 =?utf-8?B?c2lPTmZ1cDMzRFFvYkxEa0RXYWFsY0Zsc0RkMlBYQ1FUSnhoOENUblU5NHlu?=
 =?utf-8?B?c0pjVXV0WTBoM0FHbTg2Um1UeHgvU2NQOHZFUEVHSTN2eW9wekV4b0JZWW9l?=
 =?utf-8?B?WGp4cERwZHN1SnpudTJjN0I4Z1Y4UGZjWmdaYllwSUh5dDA1YU12RkNlNVZY?=
 =?utf-8?B?QmZMcjJlbDJoWU9TQUZLU2x6UDRaNVB5a1h4aWNpSldCUmpZSkp0R2xUVFZK?=
 =?utf-8?B?V1EvNWZpNVJZeHhiQ3FFWWdYMVBqZUdGRlE4UU5GZW5MbUxpZTVNTmZXbCtz?=
 =?utf-8?B?ZUw0MEFSL09nODU3ek9NRXNtc0I2OTVPZ1oxN1VGMkkvNi9icUpMU1NvdU5T?=
 =?utf-8?B?VitjRUVMY2p3ME5zZDBGcVJCK0dlTXlhSHFJbnV5R1IwUGVGWTFKNXYzL3BV?=
 =?utf-8?B?OGpnZzB4cndZVno4TGtyWXJmdEloallTbDE4bzNpTFdWYUN4dmpxeSswc2ND?=
 =?utf-8?B?SDlpUkVVMGhZRDVwY1NndmtpNE1VSU9VWXFkT3NaNklidnRmTGprVHBIK2Ir?=
 =?utf-8?B?c2xLUGRPMTdLSnZId2RTSHlDUzVqYlVhZzRxVXJObUttTFE4bklwbWcydXFh?=
 =?utf-8?B?MURBdFVnZVFlRFVXL2lBLy8rRmpWd3Z1bFE5a1NnejJWdithOEl5cENBQ2xu?=
 =?utf-8?B?azNJdDRpWDFOVUprQkdSZGp1ZjFTbjN2RE05TUtGa3pDU0k2a3daQXRpMWlm?=
 =?utf-8?B?eTNRTnhkbktlUU53VXBWSjUxdDBtUTJiS0s4c09DNE1JNUVyVmNWdHd6czZk?=
 =?utf-8?B?VStaMEJQSi9PVGVJZTRzTWdnNFVPWk9BL3VNcW9zaVZ3YnhMOHd1RnhZdlJL?=
 =?utf-8?B?UFpBKzlSb2s5MmthbitmaVhkNzZHNHZJczB2R0g4N2hSU0hFSUZKZGN4eGpv?=
 =?utf-8?B?SFJtZzU0ajk0TlhWSkNQUngyQWx1czBUR3VvWFpZQVFrbHQ5NUt6ZWNkempS?=
 =?utf-8?B?eEdDTzk2R1FPV2R3QjhueTcycjYxbU1xVkY2V0xtMjdGMkQzVzdyZHlXd0FQ?=
 =?utf-8?B?TFBTRXBOS1JmNXQ2YktXWGdKNDE5bUVGdE5Kd3B0amM5QW9mdnhDMzZpK0w2?=
 =?utf-8?B?cktKMFQyWDE2eTVRQTlGTGF4SzhWTHpQTDJhbzJKTGsvTlJDcTJFSjgzZnVU?=
 =?utf-8?B?bUl3aTk1UEtCa05PdnptdVlLM2FwaFdaZzdrRWxHblIrSDN3SlVPM1ZBUkgw?=
 =?utf-8?B?Wm5JQlZHbHhuWWhNWXRJTXFBTDdXMVd5VkFrWm9iYmVtVlFJZ0FpNlBaaUlp?=
 =?utf-8?B?ajhFRDNjWGE1ZXRxTmd2NlM4NWJ6V1o1RktTRTB6dWRaaFkrckdGemduRWVL?=
 =?utf-8?B?MUxTcHcvUDRlbjZ5QnNVZHFsYlduL0lvQ1JVdkl1aUMvNXlHSzB1Wjc5MGJv?=
 =?utf-8?B?MHlKeTYxOGc4UEZJbU9zZThiNU5NM050V1RELzc5M1NKMmNtSHR3NTUrZVFh?=
 =?utf-8?B?dDg2bU5uNjVScHo0L053Umg5ck5xSk9CVW1KM1RIbitjekJPS2w4dUxZVzl2?=
 =?utf-8?B?dHpkZDhDY05wUS92MjRicmZkOTdSRFVhWXlQYzRNVzNxM0RPWHpNWk9hVWNu?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iJpc1u/NVbtIBttwtNiXuVRWGy9APylX7AROxwBJoZSh7/fv2Jn+tK95UP7FKlNpBVPMc92gc2N/qQwAKV02webaAd8A4zcZvjnyEqUvleRrW0Bb/+i0SrMsAorhXGSgSmqwKWQAqyrfeP2BIovWCmhG/aUxpYApiRXtKKwlM2/ppxWkWv/TnuZAiD3WnOlsB13GukJdyFZg8N27ueszzHyuvTonl5sNQs1yNuiVKjkbDRg3G5aG52Zgo1FdZm/DtmOh8LseD2kfPrakfIMd5ZUm41mJ9B1ESfi1mLgUiwQdUNzKVjJaGhWIfs8pMKBih4w911xCtU31csffBMnP0Qrd87ovcC3ce06fi42YMJP63F5AtJMUlJucLNhPr8Nqg0ucWf7/cq7wMG8NeEjsrOPbzoVJ6tqG9nDWn3B/bK6fbFji3c2fsf0N/g4n4i6yJq57lEqS3Uxvhj+fmvpNOxt1MW0pk1y0fwjEX5HEVXeq5TvDFsBycaE+nviyyFGHRyKCUkh6nk74KaU558bqsFn4AS7SXz/hNwgPEuqwz2MbhZRKiOYSFtDjFNhpR48QKKLAtuhjG0FAzY51cDwuCiOmQUL7Rf+4oOWQ+Uyc0jk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe2fedc-3a35-4b62-f311-08dd54f97310
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 17:34:11.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJKM9IEK1it/SIxCaJsM4/ksS39VMP4KhQeDZ4PC1Nz+aon7UT1gU4jEfAl9+0HNm30NInMC4HnznCUnid4vZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_08,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502240118
X-Proofpoint-ORIG-GUID: wrHUNMMVFd2mCJ3kRED59FzhywMjXT6O
X-Proofpoint-GUID: wrHUNMMVFd2mCJ3kRED59FzhywMjXT6O

On 24/02/2025 13:12, yangxingui wrote:
> Hi, John
> 
> On 2025/2/24 20:21, John Garry wrote:
>> On 24/02/2025 09:36, yangxingui wrote:
>>>>
>>>>
>>>> So do you mean that all IO to this disk will error? If yes, then 
>>>> this is good.
>>> Yes, IO error or IO result does not meet expectations. As shown in 
>>> the log below, due to an abnormal port ID, the SNs of the two disks 
>>> read are the same.
>>
>> Do you mean that this is mainline kernel behaviour, below:
> Yes
>>
>>>
>>> [448000.504979] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 
>>> link_rate=10(sata)
>>> [448000.505070] sas: phy-10:1 added to port-10:1, phy_mask:0x2 
>>> (5000000000000a01)
>>> [448000.505247] sas: DOING DISCOVERY on port 1, pid:2239187
>>> [448000.505255] hisi_sas_v3_hw 0000:d4:02.0: dev[2:5] found
>>> [448000.505274] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>> [448000.505295] sas: ata31: end_device-10:0: dev error handler
>>> [448000.505299] sas: ata32: end_device-10:1: dev error handler
>>> [448001.300517] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy1 
>>> phy_state=0x1   // phy1's hw port id released
>>> [448001.300522] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy1 down
>>> [448001.436187] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 
>>> link_rate=10(sata) // phy2 occupies the hardware port ID of phy1
>>> [448001.608766] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy1 
>>> link_rate=10(sata) // phy1 was assigned a new hardware port ID
>>> [448001.775605] ata32.00: ATA-11: WUH721816ALE6L4, PCGAW660, max 
>>> UDMA/133
>>> [448002.159364] sas: phy-10:2 added to port-10:2, phy_mask:0x4 
>>> (5000000000000a02)
>>> [448002.159575] sas: DOING DISCOVERY on port 2, pid:2239187
>>> [448002.159581] hisi_sas_v3_hw 0000:d4:02.0: dev[3:5] found
>>> [448002.159602] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>> [448002.159623] sas: ata31: end_device-10:0: dev error handler
>>> [448002.159633] sas: ata32: end_device-10:1: dev error handler
>>> [448002.159636] sas: ata33: end_device-10:2: dev error handler
>>> [448002.393349] hisi_sas_v3_hw 0000:d4:02.0: phydown: phy2 phy_state=0x3
>>> [448002.393354] hisi_sas_v3_hw 0000:d4:02.0: ignore flutter phy2 down
>>> [448002.684937] hisi_sas_v3_hw 0000:d4:02.0: phyup: phy2 
>>> link_rate=10(sata)
>>> [448002.851639] ata33.00: ATA-11: WUH721816ALE6L4, PCGAW660, max 
>>> UDMA/133
>>> [448002.851644] ata33.00: 31251759104 sectors, multi 0: LBA48 NCQ 
>>> (depth 32)
>>>
>>>>
>>>> But I still don't like the handling in this patch. If we get a phy 
>>>> up, then the directly-attached disk ideally should be gone already, 
>>>> so should not have to do this handling.
>>> There is no problem when the disk is removed. The current problem is 
>>> that multiple phy up at the same time. When one of the phys up and 
>>> enters error handler to execute hardreset, the phy will down and then 
>>> up. other phy up will probably occupy the hw port id of the previous 
>>> phy which do hardreset in EH.
>>
>> Could you do this work (itct update) in lldd_ata_check_ready CB?
> 
> It's a good idea only for sata disks, but the current problem is not 
> only the scenario of connecting the sata disk. This phenomenon 
> occasionally occurs when the SAS disk is connected after the controller 
> is reset. The following is the log of the stress test recurrence after 
> incorporating the current repair patch. Although we called 
> hisi_sas_refresh_port_id() on controller reset.
> 
> [ 5387.235015] hisi_sas_v3_hw 0000:74:02.0: I_T nexus reset: internal 
> abort (-5)
> [ 5387.242126] sas: clear nexus ha
> [ 5387.245283] hisi_sas_v3_hw 0000:74:02.0: controller resetting...
> [ 5388.908489] hisi_sas_v3_hw 0000:74:02.0: phyup: phy5 link_rate=10(sata)
> [ 5388.915090] hisi_sas_v3_hw 0000:74:02.0: phyup: phy6 link_rate=10(sata)
> [ 5388.934505] hisi_sas_v3_hw 0000:74:02.0: phyup: phy0 link_rate=9(sata)
> [ 5388.941009] hisi_sas_v3_hw 0000:74:02.0: phyup: phy1 link_rate=9(sata)
> [ 5388.950976] hisi_sas_v3_hw 0000:74:02.0: phyup: phy4 link_rate=11
> [ 5388.957048] hisi_sas_v3_hw 0000:74:02.0: phyup: phy7 link_rate=11
> [ 5388.980097] hisi_sas_v3_hw 0000:74:02.0: phyup: phy2 link_rate=11
> [ 5388.986169] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=11 // 
> phy3 attached a sas disk.
> [ 5389.065103] hisi_sas_v3_hw 0000:74:02.0: task prep: SAS port1 not 
> attach device
> [ 5389.072409] sas: executing TMF task failed 5000c500ae49c8f1 (-70)
> [ 5389.078492] hisi_sas_v3_hw 0000:74:02.0: task prep: SAS port1 not 
> attach device
> [ 5389.085780] sas: executing TMF task failed 5000c500ae49c8f1 (-70)
> [ 5389.091861] hisi_sas_v3_hw 0000:74:02.0: task prep: SAS port1 not 
> attach device
> [ 5389.099146] sas: executing TMF task failed 5000c500ae49c8f1 (-70)
> [ 5389.107419] hisi_sas_v3_hw 0000:74:02.0: controller reset complete // 
> controller reset finished
> [ 5389.113686] hisi_sas_v3_hw 0000:74:02.0: phydown: phy0 phy_state=0xfe
> [ 5389.120099] hisi_sas_v3_hw 0000:74:02.0: ignore flutter phy0 down
> [ 5389.136399] hisi_sas_v3_hw 0000:74:02.0: phy3's hw port id changed 
> from 1 to 7
> [ 5389.308114] hisi_sas_v3_hw 0000:74:02.0: phyup: phy0 link_rate=9(sata)
> 


pm8001 sends sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,) link 
reset errors - can you consider doing that in hisi_sas_update_port_id() 
when you find an inconstant port id?

