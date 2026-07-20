Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468083D16E6;
	Mon, 20 Jul 2026 09:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540841; cv=fail; b=C5EVAtxoSYrNGbOXpau/qzYMCK1KiSORxHGnuOgwFRH9GY/yYzvag1ADVAV6srt/n5erhb/JG3Y0EM1302jGn6I7mRT5dVO2+YWzI2e12jg9MQMZoE9nwJ5SesQcbIfIQ1A6AjSdRBWTsDiqHgf0oOnvch/J62TW7k2061oC5To=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540841; c=relaxed/simple;
	bh=zzsc/H2wBh6GKnyNH0LBBDXAazb+NedCuy6Xw++AxTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EboDsAThH1CeehJh11R8BBIipX7euAguFZVPh1RWVlsoGCgVRkl1A+Bgig2CQjkavTN+loAKYq7O6aE3C/PGe0eyZg/8hI1hHEcUA14+0id1rLQ5Xc2cbsiNAHXTvV7gLiWE0wLjvYUTZL1rqDAJwcfnvQlF+hR6fNxN8r4v3h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oTRgsSDj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZibZmnbD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oTRgsSDj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZibZmnbD"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K0WoWc639032;
	Mon, 20 Jul 2026 09:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UvawwaJrnbIlMXjFNCzud7L5TL01goeMTlMelB35Zy4=; b=
	oTRgsSDjLtOFUSac+VDqvTa+pI/UY6e4LZr+IhG14VLXJaQ3lCA9IQQ7Ol481/Iy
	4aHdUm7N1yuqEsDuMUlYkzn7IBI92t7CQuPpuj7HF/QiGY2ZS/BSOYfTQBX56MJV
	ooAGDdZDUtQeJzP7qBNI/SRzHnj7feQPR6N1pav53xaI9KcjS1a5DWU3O6siL7qy
	pWcmZKL4km81JNZOurrCFX1et/C7uzrnG0cVj+THMoI27dUpvsEONykutIk3Byut
	txkaLySW8YLTMxUIh9gW+55//H5pTAF5zvnJmtmyExuAaozjT84hlwb4DWMJZfg+
	eD/O9htOwjFfNiMWhxkjxA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3hjds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jul 2026 09:46:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66K9hEsA024742;
	Mon, 20 Jul 2026 09:46:57 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012035.outbound.protection.outlook.com [52.101.48.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyx9nfaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 20 Jul 2026 09:46:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sejEpAqnJRfhJd6YN0eP6q5MY0kUHkhlWiMgBIplxAHlq6cJZDjtQAe9HJjU/4BRW2ysuELk4m3H3nQjwW8ZgEYZBwuMyXSABlXFeTEO//OatjZ5OFqgFoXeB1zcsRau9UUlBpQm9ZyfxGHlg+uhkjZXyNtUT2ieYG5bzR8SsPfGEMuob8A+8M6VlaSDMVm5pLFHXj6lB0S7Krf3f6XeJfWLEAlO44C0zeCGOCsEmLlTqgnXvZzyhEmcp/55X9kekV1qmFPo2vuyEwbyoR4B8Ej2pgOql6Xk7ebxwoHclyxIK+vueEsAmqUsnGCpn0vyeJaim8699jZDQfvvkBZLig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvawwaJrnbIlMXjFNCzud7L5TL01goeMTlMelB35Zy4=;
 b=H2Md+1mWu8fCCPTw6P1OljUQbw+sggJRRi4a3uIqJIEjHsLjPI2h7BqU6EtzL83+V9b/6eOr9Z52V/w+hXfARlGh1mQ5nFFYg5R0/kZOam4de2gsye0ttGhJi/5B4R3UnHVRPYKfJJ2yFcshaLz2NuQH58gxPR6Tjr4KmfJmrNifMudMVKBmdURhUgcemRuLGdRK8MvocxPvhF3bmeANaWMsv7CU+Yei37FEV+3jenmNk7DZC5Ld2JQ9z5gp9Oc/Bl3baeOOB2qieAibQc5h3jb86/wtWAOYQLjquR93uDtwWWUfZ4Vmd3WrSYOew+SjsOULsEc5douW+CAdYVEZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvawwaJrnbIlMXjFNCzud7L5TL01goeMTlMelB35Zy4=;
 b=ZibZmnbD/QTMvqVT8YtNgWDJtfqUmRbEsBjJWJY26f7sQ6vP6A81/ICUPIS2gGblu3BVYMF7xEosPWAb2tfHXUoRUuEPU9ylCtG4+XFaNVuZ2GVNuT1NnxNeFHJO4bLm726nweFblJ6j1kIPKEFChIgFEAcUlAmqd0xlh4w3Zvc=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 09:46:53 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:46:53 +0000
Message-ID: <e3b978ac-6d90-4e89-bb39-5d324258ab4f@oracle.com>
Date: Mon, 20 Jul 2026 10:46:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: scsi_lib: add spinup_notify callback for
 ASC/ASCQ=0x04/0x11
To: Xingui Yang <yangxingui@huawei.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, dlemoal@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        hare@suse.com
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-2-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703022833.36847-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: f4e62708-c608-4c1d-8f0b-08dee643ca6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|3023799007|6133799003|10067099003|4143699003|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OZLOOWkeW0m/9hSECBDCbuY8GfalVfz2gkj63JAuj00EfoyG5YQdc5eUG+ae7bA+4yFunEfpRhsZ4X5ofvCcAP3LB+rdk9ZBG40d+c1R3UI9XFLImLUPP89bbG9HrpqPAl64VkGJ8l3ePdVTflZHQDGnPwN9wjMy4dF/vHn9zJaULDbYpm5oVAsgAGXREGuXNLSg1xkSJW8EWhZU4zNoQbFbc4Ncwb2tmr0pNjDnGmNv5cCeDnIE/LJj9QuaGu5E9ILRg8BloRV/OketR3cHoj/Mn/gNGVPON7TzLP+W5UZ7ASI+aukWt0OqephWkhbyCvj/2fxiC7PtJabf5NUWQKFCUUSWA5zjkI1syj1oyujqr/3JDPCde6yQo0kZshgNjZQ8Do39ARJ+1nzCK4yGBO08h2AGHsE/gObnwrA1EWcSkoz5cVaB9g/zoprKKliPdGE9gc2z1k3y+1L/n3eIH3LlO/Sj8+VMtbepy3uWrzO+8EydIsn9A9zyVAITf2RUy/UFeMXq1NJ1bVmNAoGq78/2A6RTJXZR5mb6QFFl0Lj9VaPX+3EBuJ/OH8uTahruy8thtImK8xdmHy/K1uohJvj65isLwcKH946+2eV9G0+FtyFqqt2VbYdJ+fJ95fqeAXJyfnBbBUqSien9zxAmM8veORSEais27RXq+Pg8m+M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(3023799007)(6133799003)(10067099003)(4143699003)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjNOODgyYjFYdzZJOTRlSGljc0ZXSHRRVlBGV3V6Y1BXc1ZVV3F0S2pxdFU1?=
 =?utf-8?B?WEpHNHRHb1N5a3FUNUdBZFJRYy9tY0t6MGlYVnJKUmxEK0FMRkQwRkRGVSt3?=
 =?utf-8?B?RERzRjU0QWN2cnpLWXprY203T05BbDVoYzFDQUJoRjFvL3E3SGtieGFDeUhh?=
 =?utf-8?B?enVyQjdaZDFZOStZMGFjbUVCSTd2cncydUlVLzBzRURnZXJ2TG5mUERtbHpv?=
 =?utf-8?B?SDEvQi92M255N2pTdnhmT0x3QkUvZjI3WjZUZUhiZE1nMXhvQk1jd1F4a2VL?=
 =?utf-8?B?d2lhUngzQVpvQUhBSVRMWkpSc3doVlhMczFSaUs1WXpWOTBkMXFvTjRwMGpF?=
 =?utf-8?B?d0MybU5BdmR5bCtzNDJwNUJTa1pFWjdYTnhVT0NFdFQ5R2dRNTdKMGxkWlJy?=
 =?utf-8?B?bjkxVTkxOCtkczAyUGs3WVE5NTZicDZBTEJSbC9PN013UDFKbWZDTU5SOTRo?=
 =?utf-8?B?d3NEemdKalI4TzZUTnVIeU5Oc2kvditmOVIyeGJoM0hZTk9IbDlabGZDdmlm?=
 =?utf-8?B?SlhEcUVDaHA5SHNVbUtRZzAyYS9JOUt3SzBlTklDWFpSUk9Mb00vZmxtU1Nl?=
 =?utf-8?B?aUg5bENuUU5sZTdpYTVRcFk2U254MGR2WGJ2TnhtLzEzODQydkJSbWh2ZWVS?=
 =?utf-8?B?bkdBWWVaODdBTHJaVjlzMVd4U2JKL1hIcldIVFFSbE5tQ1RNN3hoN2t0T1g4?=
 =?utf-8?B?RCtMMHdSd001QTNObkU2d0V4ZHB6VWhYZ05ScytoYjhKanBFK1p5SzNqSHZn?=
 =?utf-8?B?UDkxUFo4eW1wUzBMVlJCM1RuelpWNjlLR0lFVWtTaUlhK3VCaDlrQkRkV0M2?=
 =?utf-8?B?TE9PQzQxMUlKY085MUM5RW5hbEt1eTBpRy9RVnNJVXZMOG1vL0F4cjF3RDRG?=
 =?utf-8?B?YUhJSDRlU0dyUnZtb3d5MGNDMXBDQ0xKOFZ1RmM2cDRmTXo4L1lHVmFoU2sr?=
 =?utf-8?B?N1BXWERqc1BZRUtJcktpVWpXTTBYNFRVZHZMcTM1NHA2aHkzb3pzZGc3b0pQ?=
 =?utf-8?B?cjcrazZEUzRXLzRMTDEzR3oxVnAzTWZ1VjY5dzlmQXJnMUM3ZmFCUFBOVFNW?=
 =?utf-8?B?YjhOeVliZjFqUDVCUTEvNDlVdGhsb1M2OHRwdWorSkNCd3phL1FnRUwwc0hh?=
 =?utf-8?B?cnB4c05YN004cmxuUk1GT1lwT1FjNk9EZWVEY1lxdFV4OVl1d0xtUEVUc3lK?=
 =?utf-8?B?SmtScGhTdkV5czBNK3FaOGQ2WHB1LzFkdEZCNCsvbVc3QUtvcndPVzRlYlRu?=
 =?utf-8?B?WlczUTl6eWxxLzd3THlWTmwwUC8rVzFtSnorL1JRa0lDRnBjcHBmZGF2eHg3?=
 =?utf-8?B?YVFNTDY2djFGTysyWkRWd3lidTJzZGViYTBLM3VWbkxxaUdIaWVuUDVHVmZw?=
 =?utf-8?B?ZVJjN05uR3lWZXZ6RjlIV0JDZGRGcjhuZGNiSXdxTVFWQnV3Vjc4NHR4MEE5?=
 =?utf-8?B?V3ZVVkI3cFd5bEpNdFRQUmxjZklUQXZGZU5QSG83UW5sSCtSN3hTZEUrWml4?=
 =?utf-8?B?WnVyTkNrUWdlQUVCdVRuaHVSOXVHUWEzdW1TMklYdXBpQWVrUUZzR2wrTkpY?=
 =?utf-8?B?NVhBYXVwL0N3S3dZRS9hTXpWU01TVm1zQ2YwWnBML2grQVNqU3h4WTlwMVZG?=
 =?utf-8?B?aUcwcGw3b1ZBNHhBdnFEMEErRUc3eXNLTDRvcGtEbForekFwM3lWZWd1OFMy?=
 =?utf-8?B?ODNuSlJtZTRTQzRYUzkrYWs4cEpMS0VSU3ZFbGpjbWV1bzE3eThpSENVbmZZ?=
 =?utf-8?B?M0Z6QnlnMk0vMWpsREZXZG1oV3NVV0l2Wng0SHR4THYwbWNLU3U5OGJQVlN1?=
 =?utf-8?B?cnZPcEtaZWJGV3cwM2hMeFNSNzlKbDdLb2U5cTh2NGNPQUhNK0hVUDdxbEFN?=
 =?utf-8?B?akVSMlk2cCtPbGVIckJxbUloUmcrY1M5OGxaRlhyWHNGUVdTMWhNSUJDYWha?=
 =?utf-8?B?aE1LcVJKRmxrcWxkb0ZpUythSUwrR2F4MGFrTlVCcGZ2bW1LYi9Ha1RmcnNH?=
 =?utf-8?B?elVtVlpEb281SWRMdXM5c1RrTG1NYmhRRWp3ejFYOTlZVTd4M3BRd3pBR1p0?=
 =?utf-8?B?b2h0MmVNQ0x4MjUvZklBenJad3JzVEk2RnNmZ3V1bHF5SGF2SnZGYitrUFRT?=
 =?utf-8?B?djJwUVV3NW5DK1ZUMjB0N1VVeEhXY0JudmJ5L2lVQlgwdm1lOG15OVdMVEVN?=
 =?utf-8?B?TTBvdFJsc3BFc2hoZEx4OXBIUzJHVlMzUTJwdHdXeWF1SXJJMk9TYUZDUUdk?=
 =?utf-8?B?T0RTeGFWeDdlSHVaczhEYVZQL1VZZXgzYkVLK1hIMVlYOWNyeWlxTHZRMDB1?=
 =?utf-8?B?WkZDVjFyM2hNUFppWE5VU3JVQUd5VmVjQU1wQ09LeHBWazYvTHZFZz09?=
X-Exchange-RoutingPolicyChecked:
	Mh/35etys+8XUvEL3UTHVmriBSizpPLTJ0cIC8gtZgsOfO+uv7n3JJqBTDyb5730opN2mHM3V8QUguq3+4ntghwjIjVYMn8yocjmbwM3QvrPlFZPXq0xNQh5fm9UI6s6TP9A9N9HPhqeqAy1HbN2T8pkFcBsC4aZKS4PZMoSSlkTCOVRIDwLLaZ/eD2ppFHeiNzBVEyugWuW3CzGpVdpU+EjhRy5uXbH1FUSQd9fLcXLwG/PrJcutZIbsex9UV4wyldOpaAI54g1JWy+2elk4YPUllPqh9Y+9d+N2axA/bo67BpzdGYEtZZJ+HvaKUkMuyMxV8gn7OPdIhGZlWUIqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C/nfd74ceXLO2GRyJJ+RM6ZP3CxKYo3vt5VwH8H3kEO+CyngOc+hNsurPquZBELu+nYQBfZR4usNsLtMCkJPZW6kgMtAeJxgr/hCQRtAK14jS4StcsI96m9oQdmLYX/4C6rcSF32KbkkYNJu5swgXbWqhTI680SF0wDaxo1NKPAKtOnUeUy9baJT8stHwQwNsBzc3XzrzYfUG+QLJofzLLVOp/aChLNZRnroxkgy/Og1b188tqsv/N9oSHqyd23z7N1Eve/9FAqGp1AYDZz9nanKMSoagsKSSpbQzslyS6NtAh9gEftas8XKklIJdcHgpCBka2BG7EoDVtXqifgKEQIHYg115N/krhL1JDsZlWgm82L2wrW8orTmYwIWzSrkNxxbuqiYZAH+TSNtIyypULF1+cwyvMoTx6r9Nahnn0wTAUGqYqrPJI1wO6Mc/RPs4CPxvL0foOsRk1rpwvZBBvfENANu5ef7IoyKFgBrwEDB2sdmsegYISj/4a/9w+dOpQcX9V6QbrTzJs5YJqb8OKwbpc7+5Hq9OSQCrdBaZ2goHwW6ud3OqrsSYQfMXcDqTNeYkyzPyWTOZ2XEyurDVP8LAn/sQnxuYsEBJcsMDpU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e62708-c608-4c1d-8f0b-08dee643ca6d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 09:46:52.9221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOlxOYCHJBHTpbQShYwB+/uxmlA5VVTs17JSkUKNuY2jL/f7xMecxGhyqsVs3GjjayoYNFhKzDX/k1S6ulSasg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607200108
X-Proofpoint-GUID: 3LK6y97mny6RFqfUx67aaQjiu75aybE_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDEwOSBTYWx0ZWRfXx0GkbBfx+ZYl
 dFEhX3U6GLF2kolZRh2Pt44HuM26NBO86zA+N/o9FsxTnLt8PcdHhHfMtjRUjhRA9mv12lMjm0P
 ob0rsp7E6njHueIK6EJ+LjuBaGSWtgNY23t1WKzjpMtQQ/ZlTKkc
X-Proofpoint-ORIG-GUID: 3LK6y97mny6RFqfUx67aaQjiu75aybE_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDEwOSBTYWx0ZWRfXy1tsA1BjoWcf
 fDZ6k7FeZq3O9YQ6CuxMiMJiJTDdy6DCnmGtSkc+IIflIv+Xox8/K2i5ZZSTULFYTvXx262mcDG
 Sv5h79A5GFRHmyOX2Sf/s407ugEYetGXJgSRGRPXebtvEggQK57o5TkW9M29ICl+3yVStx3WFeJ
 +b1jWoDPhhZH1Vr2W71sQfuk+8cbOgJ1crxXPo5YIfbp8MNOsIetEYtf/HhxOqVdS+xMZTsqUga
 S/B1LwM1kb7/9tqaGAHLLUTPGz54pfckL8rBvRqfGyCPvj7HWmYCBgc9CAj/Pn3tXca/MHVzKnK
 qb9wmH1lkhv5dcsyVfUmCo23BHCf8TMPqY2wr4nxjvuvTuUYwvClOCDiaH6wfXWLQjXeUTje7f2
 L/qn6m9qx9xwUoIwoxH1imsRqLbsUU/qDBUz2fUhsW/fu7TKyGlAXlZOx2oNfSva5HdZNjRYX/N
 vGzPXF0heuo+OZjPF8A==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a5dee92 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=i0EeH86SAAAA:8
 a=pbyapcjOTeSjP9FOvUsA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22

On 03/07/2026 03:28, Xingui Yang wrote:

+

> When a SCSI device returns NOT_READY with ASC/ASCQ = 0x04/0x11
> ("notify (enable spinup) required"), the device is in Active_Wait or
> Idle_Wait power state and will not respond to standard START_STOP
> spinup commands.
> 
> Add an optional spinup_notify callback to struct scsi_host_template.
> When ASCQ=0x11 is detected in the mid-layer, invoke this callback
> before ACTION_DELAYED_RETRY, allowing LLDDs to perform controller-
> specific spinup notification.
> 
> Example log:
> [Tue Jun 23 08:34:44 2026] sd 4:0:9:0: [sde] Spinning up disk...
> [Tue Jun 23 08:36:22 2026] ...not responding...
> [Tue Jun 23 08:36:24 2026] sd 4:0:9:0: [sde] Sense Key : Not Ready
> [Tue Jun 23 08:36:24 2026] sd 4:0:9:0: [sde] Add. Sense: Logical unit
>    not ready, notify (enable spinup) required
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c  |  4 ++++
>   include/scsi/scsi_host.h | 12 ++++++++++++
>   2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b67f0dc79499..33c4339ca8c5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -905,6 +905,10 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
>   				case 0x1a: /* start stop unit in progress */
>   				case 0x1b: /* sanitize in progress */
>   				case 0x1d: /* configuration in progress */
> +					if (sshdr.ascq == 0x11 &&
> +					    cmd->device->host->hostt->spinup_notify)
> +						cmd->device->host->hostt->spinup_notify(
> +							cmd->device);
>   					action = ACTION_DELAYED_RETRY;
>   					break;
>   				case 0x0a: /* ALUA state transition */
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 7e2011830ba4..22bf2d3d9b36 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -374,6 +374,18 @@ struct scsi_host_template {
>   #define SCSI_ADAPTER_RESET	1
>   #define SCSI_FIRMWARE_RESET	2
>   
> +	/*
> +	 * Optional callback invoked when a device returns NOT_READY with
> +	 * ASC/ASCQ = 0x04/0x11 ("notify (enable spinup) required").
> +	 * This allows LLDDs to perform controller-specific spinup
> +	 * notification before the mid-layer retries.
> +	 *
> +	 * Context: Called from softirq (block layer completion) context.
> +	 * Implementations must not sleep or schedule.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	void (*spinup_notify)(struct scsi_device *sdev);

I am not sure that adding a sht callback for a protocol issue is the 
best thing for this.

I'll check for other methods which could  be used. Hannes, any suggestion?

>   
>   	/*
>   	 * Name of proc directory

