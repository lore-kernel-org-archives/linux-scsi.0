Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363773B9DA0;
	Tue, 10 Mar 2026 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157979; cv=fail; b=UPuJZnyc06z1kuuzbIWBtC/cqon3jBkrVAzvryadeQKDuD9sPX/uLXyGyphL11JJRwM8XNMu78UtpBlnL1lcsbA1RYRlUmF/yu5OxdbmoyqIZUHPKSMlABiHkgjpFZLLDQ94FctMLWTXQyiJIbjAOFuCzf2gjOSUDalc0stS+Ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157979; c=relaxed/simple;
	bh=30maC1zENZgYZTYl7jRoFtGbiC9aQZVjL6PY5R3jM30=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tqyp6fxWACb4Qk39E1VVA6JRlVZFqS1Xn/cZzPRshqRT8y3EsXtAgT/rQA71M9zWhzqrglEMFW5wSotFyd+eRgfETfXsjdrUsg9mrlwM9lqOUuki+2gxuFBii4/32VWOT233sYcKs0fqBk/YJZM6t2uRZ8hMGJLVjuYwfG8sHVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OhNkknYP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nElayYFf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OhNkknYP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nElayYFf"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AFGnZI3630177;
	Tue, 10 Mar 2026 15:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TRKJI5193voB5Db2CXyzbOP1jIxmLt0/DmfJcVa+r1g=; b=
	OhNkknYPd7i0ZGjVnz6whvuqoCJoanpMt6k9pFf+1G8u/ZVm8NEOaudZeqxcfa8a
	xsEJf1oFLEz4BMa6GVXinmqmjZE/hDHrhqlKQjc+V6WZVhGeH1OVbxP3V0IeRyuz
	hYVH1BgbXZlQJYQKC6Pq2WETmg0Sxq8sl2jlN2M+oiCVtVEqjbYFQG0+rWMPinF1
	QnJfQs9doCwumkIRsdVXfmpW/4xQs8XIw7tBpNlLICwjEeVtPjHJW8M11mcQq25T
	UHD2KW4+/GkfsgLjVo/5U6W8lzzBnlyHaLpufWTqGmbEreUYI4ijfOBJWGeIHSfi
	/teAL8WOKlhbFCXSlVBp/A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskua35gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:52:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AFYg99020253;
	Tue, 10 Mar 2026 15:52:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafea667-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 15:52:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mpPbTM7ytSP2w3rN/Gten9XLr1+sRYWV9CtBK/lnxM5sFsKecUJEWFl2Ww5pJq3W6wdSspS2ExQIC0CfB91ZtyIg+S3Gaea6yPPyLkY78T5GKfQgbXUNtKUPOB+HBJfQXDTW6WAJd4zHSGzFIk2J7oRRzc3nokMuShY18++fyG3+r9Y4NYhZ3eXb/h8FNOP7g1ryQeTheMZ5GpCizrkNfGjVmAtzq1QtafOYL9+05Vlkr9KwdsrE7sNPRTkTHW2u0ir8dazA0e5liRXH2Fo7XSgP9onr+XHzacWPu5/VJ6TY4zNf3xFLa0i8EJspjz2KCprJwabeICd0pm2Qh66VPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRKJI5193voB5Db2CXyzbOP1jIxmLt0/DmfJcVa+r1g=;
 b=IOEerP4KGBc2Yqf6DaNVx649H01M9i9px1SwzktkqtD43QO17ZpbkRxUDyJe84+yXiggt6hUKWHFWZ51NnmU2sXq8o/eGpKUtUIf/BU5gYhAjf+z5izwPG1371S2reTBcG25ryrG/YFAdArxm9kBN8PP3BniQtcU6ECw4F6nbxYnJ42vE6WJQta8Wg3fDsqAdicDCMHZFwU8r4olAMH4WMI5dhCTR0NGs/3KPJuAa9UIlDG2wkfU+0HYFEwv2Ui47pCHqnWQ3BQGl921SyeXq/eOC2+Q7unDnd+RCCzdh3WSPjuNRKzXxRfEZdLbHNP0bDBI9Tz5t6qHQjgzi9YCow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRKJI5193voB5Db2CXyzbOP1jIxmLt0/DmfJcVa+r1g=;
 b=nElayYFfB1KxK5NYhvDscIvssDWR9rRjhvXnOxmnY88TSm+my2u6kRC+0c/BHyqHOkVo6umuehKdA8Lwj/c7hMmr4+CuYFhF5DXe09PIqizS45fnaY6wVPd7bgAN0xqNniHGNW6zyBlUayM4fjV+aOQtBL8cPI8xfwDqBwJzdNc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB5736.namprd10.prod.outlook.com
 (2603:10b6:806:232::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.24; Tue, 10 Mar
 2026 15:52:21 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 15:52:20 +0000
Message-ID: <3178d371-7a4c-4d07-885c-42496190f242@oracle.com>
Date: Tue, 10 Mar 2026 15:52:10 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
 <f46807c2-0266-4143-9caa-ff938293f7b4@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f46807c2-0266-4143-9caa-ff938293f7b4@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0020.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 2913d2b2-4bb7-42ed-d58c-08de7ebd0370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4pLfq481850YaiqPzQ5GyMIJfvhGsHmt6zy2UH/ru5qVE+zw0fuuvOHpV9cJ4sSVdPXqxjaWqxUGH3PInvue32/iJlTpim2/I3n4LFUFRGQJeT70BaQnK48Dgd5auoVdcq+Mpfg6BIGjLs3p4rxW7HSOp6JIVcvFTGKHfUVH1NAB7egYhG0Lcw+WZXirgB2JP9SrrKzfTjQUoxgdEDDKZhzn4kURtUcXKkdBxDYjhKXaceOFipBFHsMftyVpHXzbCoK4LAGgTe1BrRBH6TIp6VEIUrJWAxW1DO4X6BdoYLw6E1gXBiwAcoN6BPZ7gFleabGkHqz127YDH+0pkDjIblrhcWdlCuRr8vxdBce12LbDmVjEXjsFg6FtAmTT/wls/2BCowc1sWly6odyQovGV1PQzn2g1SLZTkFBFkR/SVTO+xBzjy3RUgLWdd/oJ0bheDMz658Lrzs0uMrnIkVhxoJ74AO4clvj9eVbAy9q9/Rvx7phuraot2oeT8OflKYFOlHv5ASAmkE/LnIYS1FN2KvnX/tg6WkLgYurS6WPsn3HLt3wfMwtk/pC6p3DZmrMrkfVU/CjC9EhK0DWjsEeDjxQJCsDwZghRW4ngB5RdGb1yK50o760yvZjLBbVSInJNeIWm5GuYFUvaUEOEmmTIJPi/bOHgEozuXMDOW/VChrtwEhONmDD/nezzfJ7AipOkPTDHe970XbMGyAY2EgcxWFaSgid3Y1Hcb7wftnq/aU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUNTQ095bUxZU0xPbTZ3WERFM0hIMXF5RU4yV3Y4cXhhNHd0dHdEa3YwajRE?=
 =?utf-8?B?SkVGWEFCS3NZeDNSKzRBa2E3MzBwbEVXb1M3dUdpZ2RUMGFVRVpDaTJmbnFY?=
 =?utf-8?B?Mi84YUhLVi9wUm10d1I1UzBTMzAzaHlDWUxNOVd6RkNqT3pTWHBnMkQxNWxn?=
 =?utf-8?B?Mi9rN0VCZFFXMUR2cDFTNHh0OEZPcGlUdlpidjlCZmdzdkw1QVkxNVV1S1Vk?=
 =?utf-8?B?V1lEMitTU2VoTmtlcjZnVUVJczNHc0c0c1NOYzN3Tys2VmhRazBCQjE3TER1?=
 =?utf-8?B?dkNjempwanlXQ1ZSd1JKajZGUzdhVkVlYUZFNGFYYi9iVUNYUlJuODNseXdD?=
 =?utf-8?B?NVdQYlNVQXVGcUp3OXhyU1lRU3lYaWtLK1d0QjZvRm9qVmZ4eWFhUkx6NGxa?=
 =?utf-8?B?RXAzR2dER3IwVXMzanJsYjl5S3pHbUNRNjZzb2ZGcWlzQkVkRnBVSWhDWmcv?=
 =?utf-8?B?Yjk4V2hKNGZvSEFvMDE2b1crTWVNZExCRjBDTTJ0WnV4UzVyNjNBVTBWQzl1?=
 =?utf-8?B?TUYvQVp4cHk0MGFBelhTd0tocUxCUFZ1THZncWI4d1FqaW5hbDBSZU5CcmFt?=
 =?utf-8?B?cU5RMWw1WGIzK2JTR29HVlpoY3dLUloydXcxcjZyYlFOV1J6WFpDeGZ1L0Zp?=
 =?utf-8?B?YmtERmdYbnZoTWZ1aWN1ZEZpeHpyWFp1SjZBd2t2OEl0QmpncEkwSE9KRVlw?=
 =?utf-8?B?SnJ6K1JsUDVwWG1DbjArdk5rb2tzUFVIMlY2TlBNRWdqZEJKZzg4R2hXVTl2?=
 =?utf-8?B?bm8vWVJ6SHdFS3Y1VzlyQWtDa0pmL0x1Ym54b3pURy84OG5xckJqYkd6TTls?=
 =?utf-8?B?bmJIVkZDdVE1cFFFQ0FBY1I2MlA4N1hYSnhzeHhrdjUyNTVoQkQ3RGtXQlpS?=
 =?utf-8?B?cTBjNVRXZk9YQzNPQmJ6enRybzZMa0tobzdBY1lHRTg2T0ErdWlFaDY0c2Vo?=
 =?utf-8?B?Uy9OWTVqR1NUTVJ5TWVUenlodGRqZ0MwVFVCN1ZNVW5XT05PcS9JR3FwcHhP?=
 =?utf-8?B?YXd1S1haZ3NPQ2dTUDdyY1hpU3gyYVorRFJ1THBWVEVJMGp0YTRSZUozMm9V?=
 =?utf-8?B?UEtRY3EzUXZiQWxpQXNTS1g1TlNYbmhWdTVqclUwdERZWk12MDVVNWFaMU5U?=
 =?utf-8?B?cHdZRVlSSjd4OTBObFlWcjVScnZYNXp3WVZnTFFZSW5HY1dDakZRZVRVVTFZ?=
 =?utf-8?B?aXlZelNSSjRXMytTUm4vUXBkMDZXcldodk5vZ0JWMmRXUTR3bFZ3Tnl4czdq?=
 =?utf-8?B?SkFIVklLbVBaRTRFK2hGUWdZWGtrWExyeGt5N25ML1pndW9ISzBXb0lKckl0?=
 =?utf-8?B?NW9GRTc0ZHJ1Y2JkWFdnd3NMdEx2bnE5VkQ0dkdRRjFRYWNEZlMvbFVUUGJB?=
 =?utf-8?B?ZFZZTjlSUHZUb3R3ckhVNlhzQlJERmFRTkZFSW54YXA3QWtLczVXc25IQzM5?=
 =?utf-8?B?Uit2U0V5d01teHI5S1lPZ1VNOHdpd1NvZm9FWE5xU3Y0RVU2aDBQV1VPZFBx?=
 =?utf-8?B?b1dFMXM2VURZVmhVSVlDZUMvcXFlU082VEN1SW91cW5NUDNYTG5jUlVsa3p2?=
 =?utf-8?B?dTF0YUdxZGhzRFNEMUhYWGp0NnNvUXdmY0g5WXM4N0tlTzVzS0xOU3hKSnZM?=
 =?utf-8?B?QXNpODIya2Z3QjlicndGbTlwWjdha1YwcDVsM2FBZUpOUHdPTno1b0lxYXdJ?=
 =?utf-8?B?cGpnZmNoM2lOaEEzUENVNXFMS0NablBDZWdVa3BJTkpyWmtsNDBuLzMrdTU3?=
 =?utf-8?B?cDBzWU5DME54THhBL0p2RWZPcUhnM3lQUURDWVRZZVJka08yTE55NnNweVl2?=
 =?utf-8?B?YlhrekswSFFlbEQ4WXNURDVhczJlRmphbUVMZUdSektmVUtWL0I2ZzJUMEpY?=
 =?utf-8?B?ck5LYmg3eTh6UjNtbFF1RitTTU00N1NMa0JGVmhiSXRtVjhsb3NXdmVZTkhr?=
 =?utf-8?B?cHd6MityNUJDMlZETG93dFZUTVNrTWoveEdvN1diUXB6SzFIVWFMWFhCTEFi?=
 =?utf-8?B?RjRLRERHQy9LK3BucmpZMDFHRzgvaFl3NXVXeVZvdHg3Q3hKaTMwZlFnOUJv?=
 =?utf-8?B?R2dheEhQVTdESDk0WXk3N29nd0VOZDVQWCtCMExaOUxjZmZlczhIdkV1Y3Fl?=
 =?utf-8?B?cENjOENYVU1haldBeDNCVTJxTkdZSEF2V3hSZ0lwY2ExZEdrNC9zVURubW9a?=
 =?utf-8?B?aVBYcjU1cXpkckRtL1d1Zmh0MXBRK1YvY1hOY2hxREF2RGNsQjFrTkRCeVVu?=
 =?utf-8?B?K3h6NmxxYmJJWjRRd0U0WHFNM3pKd3VFenB2aE1mamIxTVZEQm14VDNBTzZp?=
 =?utf-8?B?UEhiL2Y4RVFYOW1QdXJrY0VHTW9YdjVkcm1NN3hhWWgxUEVmSFduaGZXUURw?=
 =?utf-8?Q?9vjVcXYmQCFyt4yY=3D?=
X-Exchange-RoutingPolicyChecked:
	KTlUA6gIL0TSegOMfMaPT4BJM0BdSglXW0IjrjmerT30XW7WFClm33P7YZgDgaidD3tIXcR5O7W6RwAh1R9oiAjYXtQSdJ6vfviVJJSJVllpdnoB2dQwiLRtJoT2AGV4ZlgcJwkVLBmv+rZaLlTUJ9MQFTjy/gafj5k2eKR31ueiiu2aWzNpcPRp/Q2Pkfo0nW3LeJwtOp1az3yCfU5VLpx6a2N+Pm8NYWFG7TVpEUmdn+OikXE3pBWrakt3W9Ph2unbiaWZwndPDZiZO+wBK7ECuLYWcR5Zrf8GBeX8Chc5d7SgGpSvRCgM9W+lrRx4WK5rGBv/5QcB/KrhcrF3Qg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3XXG5mxeUT0Ng9bcI7uFg91L4TJPpM7aXzuIhuHTd5NdQCbC84ZDgvGOBCYPRGq1y7b6JbsWTijT5ptw02h+veWmnupADhEvDuZ+vHS6D/DqYLO1h07/7qRriIAUzqYT2+m7hlVyk4yHRItmvBmFwYLzXutIW9yYokUqnawHkb1X8hPnp04PlQ0/5Wlp6JrRHYD1O+V7FqptfTHJsztdJNmwbV9EtKwRGw2xWJGMLTyd5wgNnllev0WRCvrGMAWWGjUvJ1dj7DBdQz8/n0GttwP8c1DR2BghD08nWcIKhR2CrV7mWPyaFTYK61Dmh98GQrt69CkgeQyXsljaJ2Qg3lS7vYW5Mb+5drPuMpi0/IPa3Zn2+FyDyQ3vW6L4Cqy71+TSUJLSgV0njnw2ZGqubBCjx5kOtxFz3JtOPAF+nOL4yXriVQMK2RIVHr10Ppg2iCglar8CgjavSYCZFfSGbxjqDvZD3+Lj4jnGZzRBs925eaDvwBojP3oE21+3EznXE56djPQ+jyhj8nfVpEEyKvIKWYlOEveuRjGCTqwyJCKI+q25Dj5RW4f/1AiesXGP1ohxw1TPRwCjLkgEC/D58PlFmSmQjMEkeTv7ZUR94M4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2913d2b2-4bb7-42ed-d58c-08de7ebd0370
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 15:52:20.8766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMyYn7PQcshswp6/BvSA8N3Y9FxbQm6xWnmwLirjx6EtU3nKq+TszoOXl+BHJOE7IIlLTIB+C65qnBETyuN4bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100137
X-Authority-Analysis: v=2.4 cv=Methep/f c=1 sm=1 tr=0 ts=69b03e3c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=LN2AWSDT972AZ8vtVXsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzOCBTYWx0ZWRfXz/3WXQjUagZ8
 nZFHPIfQIr07WCLkiCQKj1aA6MfsSWd+ZHJTi5GRWsLi3Bf8U1DBxyTQWZ/FsLNa9pwcXigcJxn
 w7M6ahazg5RQb58AbNFP6j7RvsAiIsoEDgwrOHyd52M8Zm7rUleFKw9paeoW6DvkztHfkjecG7K
 Rvi2MNx95u76kVO9g3AFJtmB7Dem4c9TIgdXQo19diRq8m55zbwLX4R5FC4hiVb2G7cnGi8OO0o
 gIUzV/oRRTQHMSLyp8bIWjghvLKd3xHAAXIVJ+lec/45o2pQm0Xh0MUJ869eXyCH4LjeZFpeckS
 j0AccvYjwWZRndAdGQGl4vSdoUPNFHvi2LDBiyLgcrryDxBQ253xogO7bS3Ks2CMbeBx7oqJKsE
 U8d7ZP3lfHwpKPxrGJte2llp2veDb9ZJSc1hBJbJYa9fctbYQL37iZvWkdzd93p8rv5lICR6Zbm
 +eovgrbCDQ78HXymRZWmILcW8qDgWRLWajLhJOhE=
X-Proofpoint-ORIG-GUID: APO8qSoUUXWzFr3D954OGWALCV7aYLiC
X-Proofpoint-GUID: APO8qSoUUXWzFr3D954OGWALCV7aYLiC

On 10/03/2026 13:23, Hannes Reinecke wrote:
>>       sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, 
>> GFP_KERNEL);
>>       if (sdev->scsi_mpath_dev->index < 0) {
>>           ret = sdev->scsi_mpath_dev->index;
>> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/ 
>> scsi_multipath.h
>> index 2011447f482d6..7c7ee2fb7def7 100644
>> --- a/include/scsi/scsi_multipath.h
>> +++ b/include/scsi/scsi_multipath.h
>> @@ -38,6 +38,9 @@ struct scsi_mpath_device {
>>       int            index;
>>       atomic_t        nr_active;
>>       struct scsi_mpath_head    *scsi_mpath_head;
>> +    int            alua_state;
>> +    int            alua_pref;
>> +    int            alua_valid_states;
>>       char            device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>>   };
> 
> Is there a specific reason why this cannot be in the generic code?

Sure, it's possible....

> After all, if the device reports anything else than ALUA_STATE_OPTIMAL
> or ALUA_STATE_ACTIVE I/O will fail, irrespective of multipath being
> active.
> 
> I would love to see that in the generic SCSI code, independent on this 
> patchset. It would allow us to simplify the device handler code, too,
> as then device handler really would only be required for explicit
> ALUA. (And could be ignored for scsi-multipathing).

Right, so you would like to see alua_port_group management in a core 
ALUA driver as well, right?

If yes, to repeat, it is hard to separate the DH stuff out...but I can 
try. Examples I would need to deal with (and associated handling):

- alua_port_group members like dh_list
- alua_dh_data memebers like init_error
- everything in alua_queue_data

Thanks

