Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2633ACA5C;
	Mon, 23 Mar 2026 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273786; cv=fail; b=Iy6TeVhzF1lQt/OBsBP0LejTwrf4m0xixr8TJeSY+dWomfNcQwaAe/mz9f7hf6h4rj9ylx2xziJljMUkJu1qetVWcMTNaN5+mj0/vhJx2UFQonHCdNLmyJmKwCbOiNQHU5I/QjWbMIsk7ntb70nNdIr0NlEi4nXmqOglHdy10zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273786; c=relaxed/simple;
	bh=WbqtqQ0hBIJiSTLJYISDtvogy7tP3qhslIx+YGM/rBg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tQEW1v9XBxB51FlIm36WhOepdpEZfQHzVjs0JxswAaPM95LzYnOYrKUjsGXV8XRsl+/UGHACWtB/xC5yXpxokq/1si79pKxY79RWbOp0STBJQOUHw8oTTk/iqubOCVw9Gg6CmT48lX6w+HPdnWNLlkNU9DA6beXUcnFNuiD9Nhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mGnEBGNf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g5AoQqZ6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mGnEBGNf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g5AoQqZ6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N0177Y1722622;
	Mon, 23 Mar 2026 13:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2C33+j/K9KAFB3wfnOXq4AiA1eEmNSo7y55jXHYsNO0=; b=
	mGnEBGNfQo0OaJavJYuHmL4QmrSCSgoOrZ5tV3fwkXb+qVY80cTkh88Qw+WNrDQ8
	HgGwgz7xq/2QEwCq9oguCx/siTxcVftB39B6DpSve+SU3ETqZAX3Od0Cs6UxaP2r
	Vap6RoWc3jTcDpxuHS7RW9b35FRcrcHXSZdF48uzDpj5SXGpnSM/rep9g+AXziWu
	lwbHwRoOvOiF0E4zlzdpV14LqLlzEgAuSZfmrRftojds34a6YMs/V/8/PNZrbw3y
	cAP0o5H6B1slhrh7HSbj9D+nr/INgXDyQepmb8rUPQlAQi6LOTJsDQdF83lcAcFm
	Do41zkvj2OwmQ7De72dcuA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kgfjafh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:49:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NBu8Vf039920;
	Mon, 23 Mar 2026 13:49:34 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010002.outbound.protection.outlook.com [52.101.46.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs877xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:49:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WRPxz3zRzH0GFjo+LXSwK9SPQCNka8xyey+rmFZEMhD68oQJW2e4MHxAj50s7NHJ3/dH/IphoOdSH/WQRtQg+rikZR7v40zjWlDkIkdhQTy/cbLnAAEhubkD6VLNGUrDb3JXQKGdxJMLhkAYi8mI9POWKUithJ68/tzsXYm2yN4Tml4qOuAAtXOSNGqX5IJGe3WLQQFyKzAL5G3FwShUwq34xksWMM1LwOBWdax1ohYV4dpesNEBqTnrqoU3lxPGyeqpVZWsoM9xqVtq9/VRhHplPT4B6m4kfXVvDWFyl0Yh5ZC9dedZcEdbtMVPneq0G6Z6Og2BbU67CipE0pY0QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2C33+j/K9KAFB3wfnOXq4AiA1eEmNSo7y55jXHYsNO0=;
 b=HQr61FfVMT/9kpBLAdx2/kLSP4A7HoSOJiQxanQAxWVl9eCWePC1JCLeN1odqyLcv7lcVVsBvBiOBYb+N7IQ11xUfOtfmyYkaz4AU5BtcsVHhGJb1UKwcdoNNNc8UzoQUim0sPqZOCwenH+NpiSaVcf44TWbQEZOLh/N4RRHO7FtVQKqvOaBnfaMVZhkI/8sZdIHnQQgjquEKhAIHrxEtJ5cyOOuld0sgcbCiVHR27B/LtRT2c/InzY9UowdFSkpzA4F84iq2JPhUkBXVv5zUOYE9glU/hhGPMSNmHwcfmfFcGpORPsch/Y986uMElRhBJWY57xFyKw5FkM7Sq8yDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2C33+j/K9KAFB3wfnOXq4AiA1eEmNSo7y55jXHYsNO0=;
 b=g5AoQqZ6DsllJtr5HkigyUTY5NZU6mVpTU7HlRE4wAws9fs9nAvL6lBjkZhMJV6wYDMY9qOfQfB4hI13tdWZmLuXJrzBKQl5sZmbfjSavMv9ILOj5lrNV21vtTeZR29FqfFoi/jxhq6W71ThjftCyH+Lm/+cnDsL7cp0aD8hCu4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4577.namprd10.prod.outlook.com
 (2603:10b6:303:97::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 13:49:29 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 13:49:29 +0000
Message-ID: <e25dc0c4-e8d2-4166-8f9e-900fb3e49731@oracle.com>
Date: Mon, 23 Mar 2026 13:49:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] scsi: alua: Add scsi_alua_prep_fn()
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-11-john.g.garry@oracle.com>
 <462cf891-d43c-47b9-9572-c88afb4a09f1@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <462cf891-d43c-47b9-9572-c88afb4a09f1@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0193.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4577:EE_
X-MS-Office365-Filtering-Correlation-Id: 3102d76b-77d3-4d1c-3cd3-08de88e30116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zvvHakLBH0cmJh8tsfnybp4Hb6eRy+Deun7uILEuqJCK1Z4LrFDF+HffXs+XXaX0WX6H7Rh6u8ahXjyyGkz6Ofel1oklwaGVqUXDtY4I6zvuu9FtwjAVPQQq0gA635PXvnLtVVpy/pDfYr2AZY9UOyn2izr/MXwPWT7eydrR67kDHJGSRxIoyKCPibN8DXYk6LAuy4m0OGze7UaTFXLN/StidKOPzDTOlsR2m2cvR77fHCvBpZk9mkXjqo6zj7bCyO3Htqv980ZwO3+/75IR8Wfe8jVTScu7r4MUoCdGTr+hRFPUZa6rENES9VsHJ3SGaNsPbg0fVmtvH1wEYplfKPHlZTgaKn4llKGNoA/SISyGzYRVS0wYZydk1Lc0WHNyUtuw04mtsQZGBpIM5y7zNCpytASz/sZFLZmBFcaJEfli3faY6VzTdDEN9kwkPQpABowCEnrgu7luwqpYyFmFlsprKYnLPzIQAuoaqp5TJk2Attj2aqmkqLWtRayRoBeVEXGosenCo7QJBaBEXe6hjPCwGl7nv2ytzQqbf7OD+VwHK0S2UC9KfCYhkqCC/adKz9lfVc2fwBRyRQ090+ZuNGMmnAoJuE97Tc/1kz4gVzci1VC1Jjv14QxvF0I1iA9Kl7K86gD5Pb8rNg4OfeJVRiPSLjquWGD18GxNekMt/cepwcapTCtnAPjS4bSDSuSqRtDIuZp0/oFUP6hVS/k+H5kXPOvRDD0haDhLx3irMX0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVdXRFZwc0xKbUluZHRrWUJ0UWEzanc0eUxkSkJtWUxKTEJyTkRhK0dVbjN3?=
 =?utf-8?B?R0dHeWs0MlgrdVg1Mnh1Vlh5RUVEeTY3S2xYVS8zZjd6WWFyZExNU0FIY1FN?=
 =?utf-8?B?Um1URGYvaEk5OU5JckxuMDhVeUNLRy9BanczV2k0UlVGSVZTcEhSckNLUkFE?=
 =?utf-8?B?N1dEOFZ6OG1RYWNOcmJ6MjJCcDN5T2lHSHFPZWRydUV0SlJOSHU1T2xLQm9o?=
 =?utf-8?B?SW0zYlptL01kZHF1bkdRRlRvT01oeTBaQ1lvOXZobmlIU25kVGlpbzI5VkxP?=
 =?utf-8?B?M1ptWXBLdGNYbDd2U1QrTFI0MHJnNEhMcG9GbHdBNnNyZk9yUXZaQkhCYk9H?=
 =?utf-8?B?N0hXK044Tk1ad3ZMTkk5OTg3akIrNHFyRjFiRkpUajBzcTUzVHJHWXAwbHlF?=
 =?utf-8?B?V2RaRCtyQXgzYTcyQkxtMWIxaS9udStrYUo0ZUNLcXlqeTBFME5idmM3UkFY?=
 =?utf-8?B?a0FCbjR2cXBrd1FKOVFXSVNEMjhLWm9YY2Z6RmZONXJnNmhEay9lRXNDbEw4?=
 =?utf-8?B?LzhkR2h2VXZUVkQ3dVAvblVwZnRLSjZaTnpKei9JZC9oQlE4SmpBdXFhRUsx?=
 =?utf-8?B?N2RqUkpxSVo0TjNHdGNWeGxJNm95cFY0ekdBQklRY2tIR2p5ZldCUWxXZlhl?=
 =?utf-8?B?d2lUdWlSUmJHL1hxOUJRQThBRWw3bkJjQnJvcTNlMDFsbjdPQWFBQTA2QVBn?=
 =?utf-8?B?emh1cXJZalBDRk02b1Jpb0NmYURNc0paUTNDb21XQUdjbUkrRGx0bERkVWxm?=
 =?utf-8?B?M0tXWjVWZWdmOWpvOWRNWk9NUUhSbXlxbDBFZHlPTzQ5S0ZMejc1Tk8yaHgr?=
 =?utf-8?B?enVPZGM0VURXUWpOaWFoSWxDWTJidDh5NkpQMDVwQVJwTWdJcWlvS1N2d3gw?=
 =?utf-8?B?UmJKMWJmZE91djNKeHd2SWR1VitXOXJQdWlVSmhQcHlRdHJQY2xMREhyL1hR?=
 =?utf-8?B?WlZsR1NZRmFIT3BuMFUyMFR6UVBNUkJ2Q1dhR1EvdlRNeFVhbXpSVm1uR1pp?=
 =?utf-8?B?YjkyN052RVRIWGw2aTREVXRINFl0THdDYkdyZDlwNzRQNlBxa1N1YjQyRHc3?=
 =?utf-8?B?THhxWjliUXNRME54NExpYUhUbU43WkJPdkUyOWpkOEVEVTRLeDdYb0ladFRZ?=
 =?utf-8?B?d0VOcTlqV0RIc25BcWM1OWZVajlBL2o2RFhLYWJDMkNqQUVteEV0dGdsZGN2?=
 =?utf-8?B?eTE0OU9VU3pqR1QyOFNwWnJhYUl5WmhTUGRHSGpwYXpXQSt5YkNIaXhXWE5B?=
 =?utf-8?B?Z0J2WU9aOE9ESkxpRTVOM0FzNUNQcFhrcWFvUzZ5ZlE5eWNMekRHeDhkWWpi?=
 =?utf-8?B?dElmYStQcE94emJYUDhHRStTQUVrc05ZWC9Hc2JRYVNQUERXZW1jWlB4TFpI?=
 =?utf-8?B?QWVjRHFBRWhhQ1BNUXp1Y3B0QzFuc2ZZa1c2c3RLTFZvUklnUDVMa3VmaGlM?=
 =?utf-8?B?azRlSXV3anlGNEtZYzZ2eCtMODBoL3BUaEFsTWlwWXN3M1ZiWjhBT0gzeS9x?=
 =?utf-8?B?MkhnUzJHQmF3TlNDNmFURGlqQU5WdlVZT01KRHFScnA5cldzNjE5bVVwTUJH?=
 =?utf-8?B?N2R2UTZJZHQxalN2K0ZBRWl1ZEpZdVFQcDlDUEorTGk5azZSaG8wNXZjd2JY?=
 =?utf-8?B?UlhOU2p0bjdmVFdDUzRCWXJoYlZyaDhSdzV5VHZJRnRUUHNKVHpTUGRXTE5o?=
 =?utf-8?B?RnQ1RTZORms0aDVzT0FDT1YrQmRDYUVmWTlBZ25aVGpJbXg1aFdhQXNSWTg4?=
 =?utf-8?B?b0hHZVZEa1dYTXRxaEt2TXpOZ09nTzRDeVZCMWk3bVU4YXdmL2drbkpTcHBN?=
 =?utf-8?B?dGFPdTE1R0ZtTjBJNi8wRHU5TEZCTDUrS2U1cUxONHAvS0gwcXZuYVJmbjRi?=
 =?utf-8?B?RThlUmJxZjhJZVU0OHVDbkFVd08xNXFuUXo4UVFSLzFlREdoUlFVTHBKSm1G?=
 =?utf-8?B?czIvU29hRUd6ckZHdDdOUElMTVR6TFBTT2hxSmpIaXVKdkpsNlNxSG1xSk9V?=
 =?utf-8?B?c0dlTDZ2N3huK3BPOVJQRGo0UjJYV2RPdU5oMUlLVG9SMWJVb0ZiT0hwRXg5?=
 =?utf-8?B?NDg0aE03N0pPVVRIcmYxL3lXNkRBS2RENGR0c3hCejE2d0o2Ym15L1A2ak9q?=
 =?utf-8?B?ckw4MTdtbXZ2YTM4ZlFjSVlSbWsrVEwxdVBiOHBXdUJwNGQ5VG5DUzI4eHNx?=
 =?utf-8?B?aFd1b0pNUVdqM0V3OCtxVGJ3dHd2MHJmanVIMHA3QkRjeWVHbjZjWEEyZWkz?=
 =?utf-8?B?VmhMaFk0YWFUbnpRdnJVNXd6dzhFdzZ6Tyt4ci9OdTFEclhybXNFbW1GQkdi?=
 =?utf-8?B?Q3REL2VpNzFiejdtK0l1MlROWUFYYk0wYTVNMmRJM1NDMlpqTlhjQT09?=
X-Exchange-RoutingPolicyChecked:
	usvd4NQy1LZtwuVXdTQiCQU2GMXQqAx3JwYeeiRR4u3YYFxGbFQSPqF+UJV/xIW6L/fOhxLEQJPWlG81ROdSuxqDnK+c6EBzYhSu6BRNncXplXPneNSOkqc7qeL/HksO/M5VzIP3tUx79dn/j8KzsthdG9eAQ7lXBNNgj29rx7eS13piBBqn91h4wwEJzKZmSMFt4+nLxxS2Jv/Q0cj6m8OatNkXl7vB+FiMfld7oEq7toogkaI0gpE54UWbntVmj1L6zB+LEB9cshCSfUXVxVsOVrXXqy8SAZKMWpMG35oOP6mGne75+l+Q8rEO0LiVziQq7tib1dVcpnxplYGE/Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oGGidDPsOBYREqSXfzt/HnAFd6ukAj+4l+hPGV7Y/HKLQxdteJM3ddyrJP9yxrVpNC19Gkh13+x6Qb0Xp2IwCq/Cv7CvsI4VKbNVl2ytScWPDWRojIbPRbvwhEVrF67ige+gV+HBj1gr08Z5NBDyI/PbRyyTJ9+rl/jcS8giF4NNfPjahd9jCuz1EMhEd5h868TBw4ZIadBlNiSf6ouvQPauf+Lv5VaRW74BMh3D0p4BYqoGldn7BuSl+XiFQtnLgEd2uLGEkAntiZo3CsahuN8UMEZE1/PqGQeEg/iRk+bYGY8JJkV980pc9Y5qy95zJbQmd1mzRW2D57IKdIcilTq0OpI2bma9c6tEJ/JQqlnutnoGyNBlh1pgGnh46hIbFvsLdnS21gwBVJTAi5oB6HSJ62Aa+NUjNTlR6RobqlvQ/g30g6+YIbFZ17w6oksu9hJYiXGbITqqjP7dJEEksxexWE2KRKUE461yiH5mOCbA4COM4f073aRsD6EBnbTZ2MRAec4d1g/5bkmVLZiU3wRDmhChykNUv/dmekyvt9+K00QWzoRLhHc7BkikZEFj1lVXkee6Dl2ncGi7fuHTw3QgGh0oFmNxAfRMty0r4ZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3102d76b-77d3-4d1c-3cd3-08de88e30116
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 13:49:29.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5p6+d/pDydnM+xHt+1JNJk8uVJYNaylqPV9wZBKBYYIxoWx6eruXoxzZev3B/dcljJJ1wqJA2IPSf7J49XfMNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4577
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwNyBTYWx0ZWRfX0OizJaUZal4f
 4XlR4i08Ypx/CZZODkcJ8UHlugJ7LXWER/glMuR/BqgdQeNnjsL6BLmiFYoCn3ie3bXQeklp9rc
 W+eXxPjtxAaYoa1LOxYOHPrNhq+CMscCrgBRyR1gsV3Z603YPvzluCbiCUye0TMC7hOOGkylyKa
 wFun9El9U5lJ7dskCdzu4HMZCIIBTFS+mEs6HFx3fNUKw0tkwv0l7P6R1fyK+1n+iI68Us1OcXI
 S+kngxPHAjuvasXax/imbvQasQhKojCEhrFXDfCveKvgI9zwjJpuNuQDgMpHE54uLK0J0HbFvHj
 9HJuEAAc9QVXhi5iTIDJcBJOIpxmyxdPV3CgALt3pgrBGXUzvwPA0lvNMVxUljj9Ls4dNqcg7nM
 JCsYw1KKm3HFjFwufFyF0CnjU3QGpFTtXGI5V3Z5RKov1qAHffCIeI8IjVMf+JelYw/HGYsTZsw
 3vcsPaKVUqwpcFMSSmw==
X-Authority-Analysis: v=2.4 cv=aq+/yCZV c=1 sm=1 tr=0 ts=69c144ef cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=YF6NWXlvk6Bb2axV5n4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DfNWp-Cnnmd4hGCS1RQtVRyeiMXC9ot9
X-Proofpoint-GUID: DfNWp-Cnnmd4hGCS1RQtVRyeiMXC9ot9

On 18/03/2026 08:01, Hannes Reinecke wrote:
>>   }
>> +static inline
>> +blk_status_t scsi_alua_prep_fn(struct scsi_device *sdev, struct 
>> request *req)
>> +{
>> +    return BLK_STS_OK;
>> +}
>>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>>   {
>>       return 0;
> 
> Hmm. The 'prep_fn' thingie was implemented such that other drivers (like 
> scsi_dh) could intercept the scsi prep function and inject their own
> stuff. But now with this patchset the functionality is in the scsi core,
> so really we should do away with the prep_fn here and call the functions
> directly.

ok, so I can just stop setting alua_dh.prep_fn and then have in 
scsi_prepare_cmd():


if (sdev->handler && sdev->handler->prep_fn) {
	blk_status_t ret = sdev->handler->prep_fn(sdev, req);

	if (ret != BLK_STS_OK)
		return ret;
} else if (sdev->alua) {
	/* We should be able to make this common for ALUA DH as well */
	blk_status_t ret = scsi_alua_prep_fn(sdev, req);

	if (ret != BLK_STS_OK)
		return ret;
}

Or even check sdev->alua first, as that is the most popular DH.

Thanks,
John
