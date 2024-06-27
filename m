Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0265178389;
	Thu, 27 Jun 2024 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492915; cv=fail; b=Fb0UTYZ3fy+VnjmLCzH/0+vZsczeWFTfOkFld1Z5JePmNcthAqgpXNnMTjxvoWxwwrtqG1Ecga7c8uMvac2OKj7tsOpnGpPoWmhK2q4GqAd9yF8N88WeBocpBaVRVDnkKPY5i0AOubDQUtFADd5OLD4mVv8EWyyJYKZqBGxVUIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492915; c=relaxed/simple;
	bh=1hpymfGm9wO08kd8bwZDSsznn5snbUl1Qn+1R/3MAMg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p+FH+U4QVfYqZ0nkY8egXdeJSk3XvsvclwcsyHqqGBHJ5Rxp9QDATkaWfyZZATKL726LdXSkaV8Wsi96I7coIQNxZ8FUSIy7B1XeyNdXN86gGoiUo0c6fNdZpTArSPzr8HKUWFtq6AJoIMWMmv59M7DUpf1PfNPgsCBm0sFjqi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ky1DX9sH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b8HBQl0h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ky1DX9sH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b8HBQl0h"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45R7tWa8006745;
	Thu, 27 Jun 2024 12:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=EDUf82PBuW5R1XJ/4HGw1EXcbK80ipHvPmXfskqdRBM=; b=
	Ky1DX9sHpfdHIpbvS4F5J20YSxpHpCJBQLZB8xUWib9YJc6uidLcAhCoffRf7wX0
	EF6umuG3BBTLkadW3vISpgZ54MZXXH73nNkuWTYozVQ6IvasZco/+z8bTotgZkMa
	V98XMlIQMDD/AIJ1d5Dpiv7o3gMsU0OpnfYVfE+Jff3TF3o9MtiX8b/V5P352yOv
	ISNC9QC92syyOFo5bsRYLEPLBqzlPiC0s/MRzEJPBLYJPifpzA2sLaTVg8ScmzyJ
	9odK2tQboTo9XlREZU3X2H24g02zy5pH6PTA6l9SJpDBkFa1nz1RWZqL0NmQojET
	UeUGzreSf4tVMfU5UHmsBg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywnhb5yka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 12:54:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45RBoFaI001302;
	Thu, 27 Jun 2024 12:54:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2b2kp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 12:54:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NljbXiW4OghapmjoUPm3iPEGQrftfkxcMqJeCdlgsB6biffGvwP0XJNZGnwZK1zf0rjmV+I4Igxz2GaE+8VlBpzHLa9hR8rBuPUxvK6GYaIe4ZNBrcSb/VT4JfgJxUum76Hta6pQCxpTGaoOrSDffb7azZlx5xbOETHr9UN4Vlzq8MO6dRCuH9GWW2abvaL0YioTGuSXmIHWMqmr1Obw2GDHr7kzjm0rvW55ARJh4Eb8OO8U4Zx9k+o3+vNQlnx4gyO7i3kAJkf0rDNFqJnQJUqZ79Iuvma9dOjkLGmUHboyFLnzvma09qelFNoN7Ikwz5aVUHP6ncXjUCj0KoN9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDUf82PBuW5R1XJ/4HGw1EXcbK80ipHvPmXfskqdRBM=;
 b=Rnjw1OXtTDapbFW7RdPiIYNtGrb17U2FrqwlzrjaR4fgCKl5YYuH23g7qs9V25EH5LkGXenwPXSVav/OpayshWKQgeT3cVvqHJh7ubo411/IYkpGGgCHQEEIiKydlVlrYGRYJ7ja7ZUok+dvEAYUyGJPA4E4rX734n+vVH/Apn8qd5birCI4Dz6iXLZbdOlhcWtjfvio9f7qbNKtl6yLpyenYZiKR6NrbVT8iQ3TTMBS4Yj7XrXfdyyHTlyxjmcrKcDt8IyE8X7pKStWikVGXBi+CpnI4hyqMYbh8AJtpl2A/FevpZAPBC1jl4WkuBNtzB07rezrskeGPJmm6rkBDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDUf82PBuW5R1XJ/4HGw1EXcbK80ipHvPmXfskqdRBM=;
 b=b8HBQl0h5G3cZSyTXfnlqQtlnu6jQWkAWKZTa4kUQ8E7WGEoTS/iqQUlssMwghIpeJdMErxv05FfxndjvidIp8SJij8G6jhyronm9i5fUrHOMcLArJOwzV51ZmIpeyJkqSu/LHBAP+okk3fm1V4WfCMs1UR32tjQwHFT1SoOow4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7305.namprd10.prod.outlook.com (2603:10b6:610:12e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Thu, 27 Jun
 2024 12:54:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 12:54:38 +0000
Message-ID: <cd7ff1a0-c73b-4638-be51-2a6d9de4b324@oracle.com>
Date: Thu, 27 Jun 2024 13:54:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] ata,libsas: Assign the unique id used for
 printing earlier
To: Niklas Cassel <cassel@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Colin Ian King <colin.i.king@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <14397cfc-c73a-4046-aca8-527b065f65d9@oracle.com>
 <Zn1bxRbAml-HjWKb@ryzen.lan>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zn1bxRbAml-HjWKb@ryzen.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0153.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a5f0254-802e-4937-dd38-08dc96a84db2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SDJkOG9mYkxJWXlTdjFEZUJSL1NMMkluY1J0cm4zQ1dIWUhyby9zTkJTYmpn?=
 =?utf-8?B?VCsvcTN0NE4yc0pDZWppVFNGaHVja3MwTVROaUVYbjkrVW5sL1FGS2VHSEVI?=
 =?utf-8?B?M09YTzlLNVIxNVZydFhuSFBRcWVGUGxEakQ0SVF2YWhFMUpQNFhkbFV5S1hr?=
 =?utf-8?B?Wk45UFVRQmZqNHNkNTBON3M5TUl3OHdhNUpOdWl3Z3EvQlBsN09SMlNDYllL?=
 =?utf-8?B?SkxuaFhzbWlieDJkQjFzaDQ3cmR1RFhCUFBrSWFXTlI1RWk0THN3R1JFMGZF?=
 =?utf-8?B?MmV4VzZRbTQvQ3JsN1U4azgya1JVeWlpTFNNeE13VzhBMHJXMXpXR1hORDV3?=
 =?utf-8?B?d3B2d01EUi82dU1vZXMyZ2U5WUhxYlhSWVNpOE5yejVXM0J4U0ZSWGxqVm1Q?=
 =?utf-8?B?UWJnRnFoeUgrVENNVnpCWjNPQm5FYVE2RStFZ3FmWEIrbTEraGVwZVBpWWtv?=
 =?utf-8?B?cmV3NEp6dURhaU5TSTdWTHNuUHVmaHBlaS83M1NvajVHY3dhUTFsUXNobHR6?=
 =?utf-8?B?aGJXbDVRSWNVNHhDWlFMRk1RWFYxYmxJOHBZYWxIaEY0RTN3ZFZIVUh4SURL?=
 =?utf-8?B?LzJCdktoNkZNeU5BYVQ1UTZNTWtMNXg3VFUwV2tTTVRNNG82VVJVYmx6VEJn?=
 =?utf-8?B?SFcrd3J1Qk5TNnB0bDFMYVFKL3ljTnZvTHhLTkdaSkFrL2hFV0d6Ky9YVmgr?=
 =?utf-8?B?ZjIwT3E5V0ljMXZIMU5pSG9SV0MramZkLy8ram85TVBBT2JLcjd6NUtQZytv?=
 =?utf-8?B?Vlg1NVg3RDhDOFVNazlvUGY3Q2crcUp4R0t0NkRsZENnMjlvY1hYSzJhSlF4?=
 =?utf-8?B?ZklCM29EaVdxdmZmUXV5Rnk0c1FaZ0RHOTdiN2gwc21kRjFUTEc0Wk4yNVBV?=
 =?utf-8?B?dXZGVU4yZlhqUDRIZHRqOWlKUG1XTzBpZVBuS2RjZlBTMjNrWVBiNlF6WTh5?=
 =?utf-8?B?R1gxTUEzNjZIbjVZOWZMc2Y0aVZHeTJwQVJoWFVKMU5uamppeStEUkVJSHJy?=
 =?utf-8?B?M3ViRUVJRUJnVmRmcDRpOS9PUmc4UlVURkoxOWsvUElYVWJta0xpNlJvdCts?=
 =?utf-8?B?ajB1TlU5QzRVVW1JRzFZVjRSVTFlcmcrOWtFd0tWeDhPOTJwNFFsS0VjZDlu?=
 =?utf-8?B?SUdwT2lBSUpPMXJDTk1BZFpKSVFLWkROblpTZjUxNDRpa0ZLMnpxb2tGOVZz?=
 =?utf-8?B?cjBDeXFlT3k3TG4xUHlrdWJNYzRtOHcrMkZDT3Ztb2J1SFRqaWJIZ2I4SFda?=
 =?utf-8?B?akFqZFpQc21mVEV5WTY0K3NCeHNyYnlMcXJ0eFQ2NTl5ZnNiMkUyQ1pwcTEz?=
 =?utf-8?B?L09SQUViL2RGWUlsT295bGx4c0E4QWtnTkcxbVArMXBOVzBsSllqNGcyc2sx?=
 =?utf-8?B?ZVA2SnFzTWZ3Q0tyQ1VXZnNDWHlhT01wTzdnZ0xxSEFFdmxtV0lYUlhWZWxj?=
 =?utf-8?B?cGlQTk12ajBuWWZzVzdxQmRISTlHUlNzRE9QUGZvaHpVWFgxd3Rnc0dTeFk3?=
 =?utf-8?B?TmFQRDdwQVhFSk94SEIyQWpqNnBpZ1oxYmNhVjlpaHdPUjNEUGhJbHg2czZy?=
 =?utf-8?B?elg4eUlDRDRvcjMra3dOd0c2bVJiOTlPcXJPdGpITmZRUFZKaUpJTkZsY2Iy?=
 =?utf-8?B?V1dkbmwxempNeFZ2VExRQW16c2d0TFJkajBmejlKaSt5c2NxamNUQWUydWpq?=
 =?utf-8?B?YzNCWnJaM1NYRmtnaVp0QWZqc044cVBmeXp4Wlh6YjFqRzZIVDBLNjRkMkJs?=
 =?utf-8?Q?DstHqrrwX+AiQM7dgo=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RW03MlNXemlqaUxSMk1ONDJUenhnVWtiK2xKV0sxWXpQZkhINFp3VTFJT0Ra?=
 =?utf-8?B?MExQWnpFVU5Bckt2d0ZTMnlMR0IwK2c4TVZjQUFreHpSVmJqczlxakpSWnNh?=
 =?utf-8?B?ek5vVU42YWloZTdsRUJYN3l6Q3BObTlQWG5RR2NFcCtJWUVYTk5SYVJQNmVs?=
 =?utf-8?B?eURqc2t5K1RzcjduU0xtM2U2YnM0VzBVS052NmxVTFo1dGZUQkMvUWFrN1Rq?=
 =?utf-8?B?QUMvUk9ST2t2VzNRZkdTZWVOTVhoZmpOQndVYy9PZStBVWhoS1RiVUYyVDgr?=
 =?utf-8?B?T0Vuc3JjS2kza0dkQjRMT2JkaThhU01VMU1QY2hqbjBhWmt4NVRMUXhNbUkw?=
 =?utf-8?B?eFhldm9SaG1RRW5YaXFNaEZlQmFqb2NGQmZpTHBDY25GL1Z5bytJZVp6R0da?=
 =?utf-8?B?b2txekRHNGJ6MUl0c0FvekVBcnlvYldoblZmY1l0cWJ4eWp4T1hjbW9zSnQ2?=
 =?utf-8?B?RU01ZEw1dnA2U2hEa0VYcDBMa1VDQXZXQ0RCSkU5R2hVcVNXQmV3WndoWWJO?=
 =?utf-8?B?Ymk5QmE0UEh3SjVybUJod1AzZHBwSjFaVnZEVEozT1hoVWdqWExRUnd1VWIx?=
 =?utf-8?B?L1pKWTJpRnlDZ1h6c3FHK3ZJZ0xBcWtxb1ExckNIQjdYeTJldHRZYlM4c28v?=
 =?utf-8?B?ejBwVG9meXY5cGV3MHREdGh0Z3RZeFNQY0lXek5Rc0hHSjJNRjRLRGVGajRr?=
 =?utf-8?B?Y2lLbFp3WTFmSzk5S3o2Z09XNGgzOVpCOFdWRXRCQlJJNEFhYlBmNDdGbExD?=
 =?utf-8?B?eGdRRnExMk5MVElXWVVRdncwdDEyTFlraFJNeTNQTmNrVldGSmFYamMyd0Q2?=
 =?utf-8?B?T2V4V3IxK2VjRW5Wa3MyTVVjYkNoWXBqWld6NTdGbXFyZC9wWFZhaE1nNzM3?=
 =?utf-8?B?aytIU1d2VW1WRTRydTNlbnA0NFpRMC9qOWVZaHhsN2Fqdmd3SS9wYys2emg5?=
 =?utf-8?B?LzdvK2J4cEZNTmloeFVaK0NqWXhxUVk2bUpkL0pWdEhvQ0F5QXdGakM4Wml0?=
 =?utf-8?B?L3F2ZlFmbnpaRkwwb1lkeG5HcVh0M2E5aHVVVWdCb240eTI2dEhpd2ppWGVO?=
 =?utf-8?B?N0JNUTJrekxXUGFjZ3MzY0toUFQ5RGkrWXlrWjQ4V1psaVl4ek8zRHorSnI5?=
 =?utf-8?B?cWJwUkFxMFJzaldVaFcremZiNlltZVc1ZzhET1IzRTFFRTBLVFc0dkFUTmV5?=
 =?utf-8?B?YkMvSFloNzNQT0RzQzFwcnBheklUNmNOY2VnRWdrNFB6R3VTeksySkYwLzR4?=
 =?utf-8?B?WnZ1VmpPYWhENEZTb2QvQ3RFdExueDFjY3ZKcFFLUnBGTzI4YUsxTTBkNkpB?=
 =?utf-8?B?aGZRTzdHQ05Hd1hxRm9QWldVYnhuRFlETDBzNTZMV1NZcHBNRGNheko4aDI0?=
 =?utf-8?B?NzU4QXZYcGhJa1VoZzFJZTF2YU05aFhzQVRMcUs2V3p6MzAyTllZSVJlZ0pK?=
 =?utf-8?B?MXJUTkJhVDRIUkdueE1xK0sxdDRYbVc0c01qRW5YbXFrQ09pK1VDN2NkcWFq?=
 =?utf-8?B?QmR0WklZU2NQQy9rbXF5Z3lBcEhOaUdmajV2RnFDZDdabzhLbWlVTnBmcHNm?=
 =?utf-8?B?VzM2WUYxSTZUdDBXQUlKR2hpbkxBTmJxMENQT1psNElRZ1ZFWHMyOW5GTFNo?=
 =?utf-8?B?ckZVbFJJWGVkUUdrY2ZJNFlRUUZ2VXM3YzJaaWlSUVdPOVNxT01zUTFpTEFh?=
 =?utf-8?B?Vnhiamx2bUJZdExrZW45QXdJa3ZpZDZBUnlLdG1zZjhIQ0JwWGNtKytJQnAv?=
 =?utf-8?B?MHJMVjR5YnYremh6eTJhNDJuYzQyWEFKMUZPdWpUekVSSE4rNHpYbnIzNm1s?=
 =?utf-8?B?bkc3YzB2eThISVZ3VzlzS2JLbkx6a25EUElubkRrWFdhU0FTTXZuaGc5azVC?=
 =?utf-8?B?Sk9ubGJ6TjhpaWtldVZqMEtPTHpFeDBCL0R6UkhmdUJvdXFNejdOZlBSMVE1?=
 =?utf-8?B?d2NZMmlaNHQ0ZVhKREtKVkF6QkxFbFRDZ0RIMzR0Q1hoUlh1WXkxcDBFR05X?=
 =?utf-8?B?MHBhOERDVGd5NWRHc1RmMmtJV0dmVlhmem93S0Y1UHZNYUl5dDlhc0VMN0Mr?=
 =?utf-8?B?bGJyRCthOVVQaXdTU1RHd3JuRjJmcnJkOUprcFdFQkVYaUJoRXl5V2x5dmhN?=
 =?utf-8?B?K1dEV1BnRW5TemswcHdpSlhyR09Yck9tMEh1NVF6NGF1UVgxM0JpanlLYTdG?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	L7V16Uz3dl03GmpDUpdsF/3tMn0ITW+OEPC4wyVFcfIpOW69PohiwoAqh5K1iwddB7270/apBEGBhSj817r/EknB5W+rEMLC0uGY5UQRHgS1vHjaQ1VOF22xDgo0AfeGbvcppugECXjKBIsq2/Ye98KuGQDMIMtOc4xU+N5j1CB1QjK+1kJ3kQk5sVT1ajWSKlorcFzg52yjiD6MzJFoC7x0YMdcgGlmZ6/tbIRUebeSOG83Jz1AAaLBq96TlfmbDUwJhO+AazI1TcMgpy6ABWhYYNLOW/xJRc3GHuJHujOPDfSszjExQe/zfZJ1t0lHcedJRMbofj0ZQmgcn0rTl9sC+zpu6BhKCCx+gbAfMtnmSpFJcuOz1Yx00gwxQtcI7IAxxQdH8qISuh76qGyHCINTzg259stZecTzqzyY65je/65r4qHV33a1MMEmuAQeh1oTr2oAr1+j1n3O4KzYed9b7GgKPH3SHI6CZ4jsNuPStREMp8E0j91tV7J0YLGADyIeBekC8xTyotw15fLHhdyxKg9eRVS6hqWi1lgdSpAuaPon0sWwHJesq4WK8EZ8gwb4Ah9KEUPyn/g7s5mqqetWY+naY1PXW+Cj5MLjRTo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5f0254-802e-4937-dd38-08dc96a84db2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 12:54:38.3851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCxcrts5BjInIbH6JCr1Td08hVIcmuofGa/TOoRVANFwI33llKPSFEQSYrIZNl7u+j0xUCc7fdUVVyFz6PPOLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_08,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406270097
X-Proofpoint-GUID: zLcXPOwT1pQPKgYKm4vTBhPasuq7c4ht
X-Proofpoint-ORIG-GUID: zLcXPOwT1pQPKgYKm4vTBhPasuq7c4ht

On 27/06/2024 13:32, Niklas Cassel wrote:
> On Thu, Jun 27, 2024 at 01:26:04PM +0100, John Garry wrote:
>> On 26/06/2024 19:00, Niklas Cassel wrote:
>>> Hello all,
>>>
>>> This patch series was orginally meant to simply assign a unique id used
>>> for printing earlier (ap->print_id), but has since grown to also include
>>> cleanups related to ata_port_alloc() (since ap->print_id is now assigned
>>> in ata_port_alloc()).
>>>
>>
>> There's no real problem statement wrt print_id, telling how and why things
>> are like they are, how it is a problem, and how it is improved in this
>> series.
> 
> You are right, it is missing from the cover-letter.
> 
> It was there in v1:
> https://lore.kernel.org/linux-ide/20240618153537.2687621-7-cassel@kernel.org/
> 
> """
> This series moves the assignment of ap->print_id, which is used as a
> unique id for each port, earlier, such that we can use the ata_port_*
> print functions even before the ata_host has been registered.
> """

OK, fine.

I see code which checks vs ap->print_id, like:

static void ata_force_link_limits(struct ata_link *link)
{
...
		if (fe->port != -1 && fe->port != link->ap->print_id)
			continue;


Is this all ok to deal with this print_id assignment change?

To me, it seems natural to assign a valid print_id from the alloc time, 
so I can't help but wonder it was done the current way.

Thanks,
John
