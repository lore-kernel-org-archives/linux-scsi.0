Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C1139A070;
	Thu, 14 May 2026 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778751357; cv=fail; b=DjDsEZvNwdcGtjx9/X0JAhfttMvWCTfpff26UxhimrczxQsKOFkFsnAo/wgfvh1y2a7x/xlckvZq7777T8g/lc62HUSMNFvv80sAHS3ULBtmrAFAf1bAsK8T28dYY8+kcHTpysrYbjl0zsjJaiH1R36gyjEFpu0jDBLQclJfiNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778751357; c=relaxed/simple;
	bh=vFSRUfKj9mzrK55DsyiSDDzQarUMCddGBo4rgL/NWuw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Br/lW3+OV18RM/Cp4Y1NId1ZWJ6jGb3IVBbkuJOLcda/jtUqTmiRD79zi1bs7Qg2hyNqNSEsLG2T4Cz4vVyDOhHVb7tSQh+oQZ+TQSpxDU0SLZyY1CmSmABXYWLqqbgS8z+lMIxjh8Y9HS5IImnV4hPlqIXidVET81wuWsn3jf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mJaQzlEW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qEMgxjdS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mJaQzlEW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qEMgxjdS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64DKtkpB002581;
	Thu, 14 May 2026 09:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rNBahrEBos4HWwAsFjC4zUWqtKRcxa25GtOAU/hI878=; b=
	mJaQzlEWyDBq2mTknsJU5rwv2+QpbK+hRPR09F/QJgPlfPAnsKkB+2U+qkKd29DK
	24PFbRhEFtaW5eLtnKxaiMpIDWkzfaEh5Bix+oRrTKEp+NVFheHlhFLg+1YqmWPc
	p5O7XjBzgk9jcqVlv7Tjv4EeinFpKhUdS9ojOZXP+Vm0qPzA9yhgK3G/iX4pLgCY
	QbWDUJF6+4HJ4KFvx/OdnEdLeDEEmk3ZxXcN+X+M9I023y3mAK4QHKfTlPz5GhJj
	o4sR2uOid7GQwYybliGZ9rJr4CWFeVha9GtLQ9Q3htRE3xjJbBde/4A8mdt/KYKl
	4D455j3c7xux8xtwLpAK6Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e4c97tu70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 09:35:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64E9Z5wD028800;
	Thu, 14 May 2026 09:35:33 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e3nekp5b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 May 2026 09:35:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTSqNoZWixL1OWj6RthPq84x828sX79NFnShI3pJsHzO6S8Tv+Om53y0zIhN9d6uGn86cG2T8rLbkqyJpYVorq6DJxOcrEUEmMka3KqSGRGrEsv1wr6zsGJNAyQ/zbKBZj6cHMDZBnqXijGnQvww1EItg9Ky8tfnlQt/PDy0KErjrzUqd4tWs3vAKAYmqJLmDxq0g5Aqy9egb+r7FM0nSjJsuBg+oNqDv/FXTPekxUAMusQZ4sM972QfGrNYjzUaKTNLhl2hWu3u+uJudwze9sjQFcTN6LtVNAooYgv6nKyiuwBtbD0VKiMaY1ywqx19x1hfnjmCVY9HlZbbj9aPmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNBahrEBos4HWwAsFjC4zUWqtKRcxa25GtOAU/hI878=;
 b=uqNDt6BZ93EtUJb6pLGIS/mHMJqqGOAbGI4bya2o+UwEvo/1PjMYwHMCXG1tuS1vG2PDYFxOCJ+t/Zr5/sr8uKNox3ICBUFPxxFW6XlvbFqDDyhOovJ89uTUI1pFL6rmvOnMpiH5eGTsIi7wf7Lp1EpUfvmQpqUd9oC51jAAaukO2fTpSvnkqehoflhu0OhaGcHXF2hz3zCCnEWaMsxIESMXTfdFpCowJ4QTXUhHmZUC8rDNmfbl6q5+JRfPGkq3KGFw68k70qhkagizH7372c3wEpyDwiWSHYS5lkWwaKgTw4fi3IqW5cQ3uMxeh7v1M1fy2Af81zxzPMKlIDUkJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNBahrEBos4HWwAsFjC4zUWqtKRcxa25GtOAU/hI878=;
 b=qEMgxjdSNAKp/2Y5+2BP+lcsvEGZcfuMXK7zBbwrI+Daw8SXPLZSmqVuLtat6wMlgwsHeSZB5ZxpK5yNqaQfBhF/xoVW1fMWqxkh3qSIhGwPSqwHAulwIwQgAmYdtTSpE0ekWY3DtyQImOvz9JQz4z2LCjP/DS5YWs23HpVrji0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS3PR10MB997749.namprd10.prod.outlook.com
 (2603:10b6:8:345::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Thu, 14 May
 2026 09:35:31 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 09:35:31 +0000
Message-ID: <c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com>
Date: Thu, 14 May 2026 10:35:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] scsi: libsas: handle linkrate change in
 sas_rediscover_dev
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260513021603.3023329-1-yangxingui@huawei.com>
 <11d3560e-d956-4f0d-abc6-2ed897e0ce45@oracle.com>
 <391ec8d3-3bf7-16fc-774a-96c917c67d56@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <391ec8d3-3bf7-16fc-774a-96c917c67d56@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS3PR10MB997749:EE_
X-MS-Office365-Filtering-Correlation-Id: d508cc66-d2e0-4274-8584-08deb19c23c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|4133799003|4143699003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	WUYJO4q2AHxcVOQupy1ib+OOnCPH2QkcUx6AeTBj4/7uugpoT9/YPFADRguXjIfXQaRo78RLhLb5UWQnc4cA1OhW4ZBlunypLLgPRVACJ+Qy3OkXi0DwwOVdle1wvOjO97PZe6tk2/UKsv/EZFfQB+1Bj/vAuVDdF/gzRS4tfRLe2wSI97w89Y7R9FuoL825VjRuLtvxwTsElJ/nry4mH4/v0zCnRZYboAzDTlk/ybneBornKAcyuGoaFzif/n5fq/N52sXVunys0Pj/5eXqSWOWO7gORI9s8H+U8j6y4tTm6Iu+lawfTOx/IyvUKEU7YjUW908d8TjNLKbjcEyyeuFAP/1DEDr/Gpxy+UExR5x0LERPlNz2O+8jSQnXJAAD1o1CAVpAVqnXtfjWc7eCG3bIBGEl1V523By2xrThZYGcRGNjRHTzdbPWO72gIagsws9lZzhXAnMzU6d6PkzFVJ44DLpTtCPVwV+r3UkRVK0Id5n5M7oOibElZ+6SzMhDYqJKmTh7JUD7b6pZw+cAa/rSJWJuBn43gZpJBLX+7eFsuLOJeuf4BHjM8RS2RB8sqFv6ZWG3aEAAvTIHes2WOkV1ZzonWXINFezLu+JDQ0K+H5W8Bjjw8jCjHPHgVxgmk+k9/pU8HcSZ0uQYSfcR8A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(4133799003)(4143699003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b253TWpXeEl5b21nZzNsWHV1Qk5KeXlpTzJFN3gwTlNRTTl0c2V6R0ZjSlY2?=
 =?utf-8?B?MG1tY1RyY1ZtSmtGMTA3YXRFQlRlb3BvdVkzMGVMZDNLL2swNDhYVjlJNFBD?=
 =?utf-8?B?ZU5kS25mSGVTVEhpTklQL1dEUGsxY3lJVC83ZURGVHRLZFAxUjkxNDF3bmFt?=
 =?utf-8?B?bTNaanQrRW1lMEVnd05ZMXFROUtpeVVNbmVrRmdKWFA0cy8yWmFhdmQyUTFK?=
 =?utf-8?B?bGJuZ2tuZjBnZCtrQUxUUnlpcmV5MXd5bXEyc0FyWFp5aDF6RUxrNE1nMHlK?=
 =?utf-8?B?bTBmSWxUS29nZlNkZVBSRXBBbHNBdE5lQXd0aVBHM3pxVmZ2V3UweXFKZ2dQ?=
 =?utf-8?B?VWswbStJa1ZpV0Zjc0dRUzF3dkJTOU0rblpHM0dxUzFRR05zL2V4dEhJVWR2?=
 =?utf-8?B?cTRNbm5HVmd1ckd5elVNOWVheDRKcFowdW9lT2xLVUIxYkVWMkJXSGlxd0ov?=
 =?utf-8?B?WTF1a3pvcXpqcUVVV01zU3dOSC9WcjZWZEZyQzUyc2UrblluOHREeXdJQUVy?=
 =?utf-8?B?UlBkQnlZNGYvd2E4N0FaY0M4Qm5iQ0JaYW50RU4vbU85enV5UDZnRDBIeFFt?=
 =?utf-8?B?SkswbUQ2bWI0WWhoNUhGTklRUjNadytQdU9mRnZsVkluMzlSV2YxTm5SaUdh?=
 =?utf-8?B?aTFsNTM2SDBmQ25WbzhzSTJIMVl4WEhhazRIZXowMnNtMVo2bmVwcUxkUnl6?=
 =?utf-8?B?czlCUnJ4WERnQjJ1S0Fuem9QN24zNTMrOFBXM2xhalJQTmlZVUIrWTFGbHdJ?=
 =?utf-8?B?ZWx0WXIzVUFORCtSQ2xDNGI1S0VPUTdHTG13eXY3S081SXQ1U1RhSldnTnVy?=
 =?utf-8?B?Mlc2bWh4SEhtbkg1c0wrQ2x0UEp0Wk5Md0djZlg1MWduTFNOcyswaVkwSmNv?=
 =?utf-8?B?aVFrQk5Tei9ZWHZmUlNUUUE5RlZpRE5GNW1jaDduS1RMMVhCc1NnOUNkeElB?=
 =?utf-8?B?a1luaE1weXlhRmtTY2tkY015S3hTZ1EycEJRbWpNM0pVSHpPWCtYRWNKbnRC?=
 =?utf-8?B?MDZ1NXp2Uzk1enMzN0Z3R1lyQkVvQm9UemNTMUNiekRibGVqWS9vdHVRcFpU?=
 =?utf-8?B?ZmN3M0xCdmxiaHRPWU45SDR5TDZBQnp6S2tyRlp0VFF0d21RWjhWYzdJeGNZ?=
 =?utf-8?B?aVZmd3ZpSm9oTXpwUmJpb055aFZsVUo4WWloSWZkUUNFMDBhRG9GK3JJUkh0?=
 =?utf-8?B?OVJaWkNiYWUrYlduOGs5N0pYOHBUQ1JyTDA3TFNNbVEvWDBNQ2N5dm5PMGtQ?=
 =?utf-8?B?WU5oWXMzQktsdjdhUVZoczJvVVhDMFNLdkJLR1VBQ25kdjFmQ0hQMTk1SDZ4?=
 =?utf-8?B?Y20zcVgwenNnRWRaekZ5TnRidkRNRVFreWp0Mzh3TWdNemp1U2xpMTNMREIy?=
 =?utf-8?B?V0dlbnR4YjNrbk5jKzZuZW5ZWWlLOEs0WUVyTkN3a3VrdjRpanRXd3M2dXNQ?=
 =?utf-8?B?TlptOVpyTkcwNmdtWWtwT29CYlBHVlRUM2ExZEUzOXhBeXc5cWZ0c3JyVUo5?=
 =?utf-8?B?czk1TW9TV0NVWFNiREZ6cElHV2JzQkhLQ1I0OThvdFd2OFRHOTYvNXlCODhk?=
 =?utf-8?B?bU1IM1kwdmk5YTE1Y1RrZ0ErdnAvSUJZcjlyWk1SZnMyUjlXdUpCM3JhZmVR?=
 =?utf-8?B?a09FMW5uZUluWG5ROHJZenN4eFB3Sm1hVFRKWVNzWXBTRFBMZE5QQlArN1Jr?=
 =?utf-8?B?c2RWaXAwbUhLTXhnNCtVdFNEUldUNlJ4TEpPbnVTeGJjYzYxZzIyOXByQWRT?=
 =?utf-8?B?cnZ3SU9EWmJsK3c5N29PMmZ5Szl5U1hSa1BNUCs0aUdQVnpVRG15dlRBbEdF?=
 =?utf-8?B?Q3h6dDdndUZKcWdsbjJPN3FJd3RkQ1BYNzV0akQyVnNUaG5WT1EyVk11T0w3?=
 =?utf-8?B?UnZzU09RRzAwaHIrOWlUaUVjRTAzMWFXenNSVE9IUjVBVjV0dXZwRVh0aU9S?=
 =?utf-8?B?dUp1QmVKd0s0K0VvbVFJUkNJZHo4c2liMHhFYzdWV2l1ZWN4M0J3YkRtWkFE?=
 =?utf-8?B?QXhLWDRCRkNyZ1gyNnhEVDUwL3ZCZ0RFU1k0WTFxdHJ2b3c0YndkdXZ4VzZz?=
 =?utf-8?B?MlRVYmF1bXFkekd6dmZEa0c4NWlMQk05ZURINjBvcE9uYVJCeFJWY3NoSXFF?=
 =?utf-8?B?MVNOd3JYOC9QNk51aUZydGcxQVBlcklGSklzeGZaU0pIeWFsa1hIMkZtblNJ?=
 =?utf-8?B?TGZNdjVjbk00Mm5wdjEyQzN5MUY2VEZrMjNRUFpXWUF6VkMwenVBL3V0UjhM?=
 =?utf-8?B?RFZkODMyTkFuVkcrUUZtbmwxVHoyWmNlTHk5dS9vZFd2Vm04eDg1d3hFQWht?=
 =?utf-8?B?VFkwcDNMZXNtNUIrTmZUSFFXSElaZ3RBOG16KzVPVlUrR0ZPY2VML2owL090?=
 =?utf-8?Q?Rez1Jv9SAyl0zmLs=3D?=
X-Exchange-RoutingPolicyChecked:
	LeVRjtQuivlaagx87g5lj6QieKQ/vp5udf556XPEC4bnW+1DGGqQI2fUHCIPyYv7REv+D1WoT2iNAqKfa7yb1suVGbok4nL5V4pRTVz1DmcBEqFRqvgj7gS6slBY7xBmlP6syQ50TPx+8/tEqhNhoErmm/XZm61v3rTzWO8hpkagoBgi1gW3k2dFXkh70x3z2n8tu4YoipvnXmC522limpH0eNaXaBKR32vTz4BJ4lrT3f3x/vxO5taxIEJJwpptjAgwupIgl6+YpKHlhhj1GbWNI/FPB7ZwX5K3BWWQlsBd3ZZ7RjT0srcMEYoVu4DcOSxZiq9bejE2b6AcSModng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DvIHfDQVQWM0EdOZTCmFelgSJt8aRk5Qs3xp6yPCX6qifaIXFLBdmPJcpoTJ/TSeIMCxe7ZJ71N2RJGU10CgjfO8FwAADYfOXHAS++oTR1P40bOZVRqxl5XIVqObfdlD5l87Mx8LHtfzlHWzBIBp8yZWLV3OaG8/PXbdThNlFpWvDw5YH1InszoNJSaDrFC8Gv8pxWz2G2v2cNfM8VcvWf6SGI6AsgTZK0Wyltc67ZfWZRSYLodh1RweNCvYeD/VofpBBCRgMGzznbzi7Eqy1XHYqogSSyZDcp52VLMbcHTMs5KRYI1Kxg3HAtYzenJQj2ZQia0iPw1CkuQLsN9dyH0rxLPFn3CNGSLcw/r9Zdlcw20Dyr95/U012VcdtroIfxCy54p2h3HXG7SmG9Ytb3q4b5dIRPUlddAQJ3iwbeZQajwpyxJrkt/ytYskHwxebmnaBo5nz95kqe4u2Ax94iuu10hO+dY1mIys68ST493arM2UHJpbPkZvlzpIbEJQy3j+KD6iEQE14dWTNyzHpg7Euvw1BeQvzXIcYnsDJRYvloim7Exo8W+5lraP2eEarjnBpFVczbBBS9g16f58eLAWnITNrO11cYflwPqwUik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d508cc66-d2e0-4274-8584-08deb19c23c9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 09:35:31.0155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49EdtfsrdVRtyfhbExtfmq5lLiGR9LSZOIL4ZL7rkRnBkODdYRI+wVVOWHdxKRZyGTe2jPJFqnAYhGKadRZyqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 mlxlogscore=855 phishscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605050000 definitions=main-2605140095
X-Proofpoint-GUID: org2VvwJWZKI5BIziZnI3qPHM0OOyBQ_
X-Proofpoint-ORIG-GUID: org2VvwJWZKI5BIziZnI3qPHM0OOyBQ_
X-Authority-Analysis: v=2.4 cv=Yt0/gYYX c=1 sm=1 tr=0 ts=6a059767 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=uherdBYGAAAA:8
 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=csMj_6vySG4EpRaIxpUA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12299
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDA5NCBTYWx0ZWRfX8+niu/hfZ4rS
 6zkE2MMhtmbqtg6+O6brfLOwBuuQkwiF40u6xgm0ffDSwnaI9NnVjlrMW0oulU6e0+KPHBMWZ5S
 qUnkNCGgQgHLfaSZtQTR4mIChNLv8sEa99ng5137B1F8VQ8hwfWEIGHNUwuN8d/lPHK6U4/eSPQ
 Q5AhWyZLD4lze81tx2PyQRV+IN+JZ++fIKPegUBb7zcx9hVQKgDotRhiZoFcAc0/Qk9MMGcYm1o
 5sJVvw/bhXhkkuV3VJ0tva8XXwhAeYSX+Vfp5k1Ej7Rpd6Bdbv/hZYYffDicRMXtL44AfrVjRZ5
 euN4P1i5GTodm16OS0T9/R4CreK7EZpwz5t8lOYLPCUsYRITXz1UF8vmnK55cvTQ+czvbZrbzhp
 viO9fTvFEZGFxV5VhoVRuCPpszT4s1MplbkKX6zd6ZUK2th19jPX4GSHKv3NFyynZH5npadu8Wu
 6MchGp7fgLv/YsrHDI28VskCwWNg0FaPhLYBzs/o=

On 13/05/2026 09:14, yangxingui wrote:
> 
> 
> 
> On 2026/5/13 15:29, John Garry wrote:
>> On 13/05/2026 03:16, Xingui Yang wrote:
>>> When a device attached to an expander phy experiences a linkrate change
>>> (e.g., due to cable reconnection or negotiation), the current code in
>>> sas_rediscover_dev() treats it as "broadcast flutter" and takes no 
>>> action
>>> if the SAS address and device type remain unchanged.
>>
>> Can sas_rediscover_dev() check the linkrate (vs expected) to 
>> understand that this flutter has renegotiated the linkrate and then 
>> consider it not just a flutter?
> 
> Hi, John
> Theoretically, it is possible. As early as 2019, Jason attempted to 
> propose the solution you mentioned. He conducted a relatively 
> comprehensive assessment for flutter, including scenarios where the SAS 
> address changes or the ATA ID changes. However, in actual use, such 
> situations almost never occur unless there is an extremely short time 
> window during which the drive is swapped or a new SATA drive is 
> replaced. Because this solution is associated with other modifications 
> and may have significant impacts, it has not been adopted.
> 
> https://urldefense.com/v3/__https://lore.kernel.org/linux- 
> scsi/20190130082412.9357-6-yanaijie@huawei.com/__;!!ACWV5N9M2RV99hQ! 
> K7CIIOxMVXErIMxcZlvm10YX3EVqp0rhSbh_ARyqnaFDmtaqqJtoLTJQui0- 
> Ox_URh97f8oyREG8htBVo2aC3Ew$
> Currently, scenarios involving changes in linkrate are relatively more 
> common, and such situations can be easily reproduced by manually 
> adjusting the linkrate by sysfs. Therefore, a less impactful synchronous 
> update solution was adopted.
> 

What Jason did was to check if same device for flutter, which is not 
really the same thing as what you want.

I just don't like these special case callbacks which you propose, as 
they seem fragile and too specialized.

Is it possible to just check the linkrate and mark the device as gone 
and rediscover when this flutter occurs occurs?


