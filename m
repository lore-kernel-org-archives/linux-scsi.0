Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAC03AA507;
	Mon,  6 Jul 2026 10:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333615; cv=fail; b=ctnoe231andNzlHUelpBXBtp1rD80EhqdIg1EUUgbUqYKYOaOFsJKgbnkrPODZMaXoS7MVwEe6IgrhrRrc0oJIWI1uYxol2gAfFwI8WLjM6JNfphRhK5NYFuIbuQ08WPT6JQPCI6kdxa3jfSd5MYzLP8HTli2ZnX2jb2nBkshG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333615; c=relaxed/simple;
	bh=xWTraChSpsk5kBtGFdjaaXpco2L9cWzomVLfrKurFvo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sWk/TI84F4MVSt/gIkawAC6Ora6QyfwXpQvrJb0CjuykG+CdQSMRZHe2rc3Di9Pm0YrQDxIzd6ce5ybfTeIgXY4/I0mV/VD9qCemfV0Bid4H8l2/gEc2vZSz79w2M1c8vne8fqeCOEtAJ5zZMxIu4THeSfotvWRA3qsEnICCieU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=otBI0uiW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DoMpkUdG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="otBI0uiW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DoMpkUdG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6663KuCB1340749;
	Mon, 6 Jul 2026 10:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xCoRu0pH7Ajg+K175RO67M2LX8dcqPeDD5PMZXv7MNU=; b=
	otBI0uiWKfazwpVWmtnrwBqSJjt3Xc53Fp9q8WdG+9yF/uPp8KS1cBX3Bvx//SB1
	nMeSZJXHSMpSmeUO0+gZ7AW4GxZWBmWh+govPkXTKu8nDFxmjdJNZU3isyLTR5cj
	/nVm2Le3ct0lPpjHEKBfV2T7PMF0zAB6kMsdVUKMY4Vu5pqwb8Dd27rXDLUOSwYz
	/zccclr4j1yYQQKMlAxW5s/kJySsZs6ZM939VPRRlBZSvWvoghnfhj7It+Lzmpqy
	OAyO6gvWxNaDgoRvRX6hfaAsBX+SDB8kDySPMOMv01Us8pauIllYF4hzoshhUcjf
	m1940XfMcwm5gpIm/KStSQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6tqs37ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 10:26:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666AN7Kj025551;
	Mon, 6 Jul 2026 10:26:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmc70kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 10:26:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPvJJCopoVrpg77uy0Q/bbEfLBtYaOqWjWf1DW/sgB9Wj8vZX9SItTjYhbYHPTDyZPRzNMgEjIKpJaHFWfvKnZjWOiWd0QSJL25R/3tFBwkuEJ077Dn+/8NfIavt/8V7iVRQPuLQt5+qZbO8pT6uuZcb/OymdN9kzGtDP9KZK1h+CluWdkOgCR43Er9Ys7wPoDMFQjboNqqVbnRrW02WEEpXtC85ngFd1HVexbgthuGlVrKbYNk21BxtFBA24otM6MIATPhfkxSLilCmwgBG4dk0MWMT3ah8TtIjRrmnb2CAdRQ1Dd2Qf3PRP4LQapGqL3IznsqSqxlUXlUNoOofOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCoRu0pH7Ajg+K175RO67M2LX8dcqPeDD5PMZXv7MNU=;
 b=NH8nlNzP9w4pLXf0FtGhGRE4Uunc5yr8WQIGzuzLEyGQXT+ZlioVmP7ew2+LDd9GJxNf3P8T9wjBNjkMXw5P255sb1CjNzIEwydIhKCaxaV8DFnMZEpIYHm3qwQc9jYwEJp7oO4Nhy0TGKuQNY4AakykNoRl47cEcRwVmSjxcWIUoV8ZPpJL1zPP6L60Us+h44CPdZv8sYjB4HqJxp4A/GQW1ZG9O7ucGh0zwIe8/EE2NG3MokOG7bwU1vURelbY6aJhNUpsoODP4otIgAxoKBrvG18UlkMCVhgDHlNeNBX60MASRC4sI6E6g0C09FQXKEz/1J7KVVnEucUwF/sbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCoRu0pH7Ajg+K175RO67M2LX8dcqPeDD5PMZXv7MNU=;
 b=DoMpkUdGerZ1mC6Mk5yMHiZg/h5kqWiJHSOkKTY5FbXGaFeanaA3xfrb9k2BqRInGXS3RNaQF3CfXkQq4qmKk0xd/8RQEuF3VDiqTA8UPiU2c5AQHHiHbwhVfEodKpSOveGmsmKAEr3/9Mv3iWNu2hK3s3jzpiD5SO5RsVPFi9Q=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS7PR10MB7190.namprd10.prod.outlook.com (2603:10b6:8:db::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Mon, 6 Jul 2026 10:26:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 10:26:46 +0000
Message-ID: <431f7517-286b-4a92-a6c1-0f0617a9ceb4@oracle.com>
Date: Mon, 6 Jul 2026 11:26:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] libmultipath: Add cdev support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-8-john.g.garry@oracle.com>
 <20260703104832.5166A1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104832.5166A1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS7PR10MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d482576-3385-4c21-f6f4-08dedb49149d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|3023799007|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	7VypQotrAVmci6M+l3JUmM3c3icbNrLjTYE0j44JfDcGVRFYe8Usl5lqsFPtvHEWTVI5f03Y6FuBD1QIE/7KpQKPfKDsyOdYSl021yEd9pF5ku3kHoH56lrEG4W7Zqxj/TDRXzBhBFOe9YGeZxpc641CnI5gvNqQ1YRbVNCOZXdH58XI95BbWmHIV3f7xYQI9XwML0ZxBbWOvOpKYl2/qxHeL3AThEH6NXSl4h3y1OXaBXYkObMQnqNOeVKYmrQObzDmWEU2bqJ9db8ajiLFGkHBRT/Ds3zx73/MVAN7bDig8XThUHbIMLUfN2Uad38x6cwij8Ibn3fGc79QYZruFpj5da9sMcLu1FUWAk3FuX8neyzwkPT4EgYEyCMkAk5cojxZLe+8Z/2akhZ3eQwVjyLzVEhb7ieVorRdmACYYrRFoxGS9WOEm2Lu7w++gTem807ZbuSJLBuhJhWbgWwCINihYAL6erUzeTfeWOSGaz67K8p5vqU8PdQXcHbT04LPY4Sg8QQPzOGEpWWPcn2AbZ50jq/ryOTwxdNHSWAt4ZW7zYAo1IG2WwTF3TEUUcRtT++pywt/gv8w2mf7329jr5k6DikXiZpsxQ2gUlvKjUqyG1IM45rdnNlvqXrO5XxpoBfBu4RfAI42AOwaz89+uOZBftsoyyyl2UUZY3Ry2mw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(3023799007)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2VzZCttQ3dTSUd1eEp4RHRUOFkxd3RFREh1bG5vaHpqcFltRTIrWEpERHEr?=
 =?utf-8?B?Ty9aVTZkbjlvVkZ4d0tVWU5kWExkNWwxVHJDWXNNVGpjbnZaUStSZzg2aDZF?=
 =?utf-8?B?VnplRkF0bHVhOWJKN01kejBPS2haU3R5U3l0c0VYaGFWTENKZmJPK3kxRlYx?=
 =?utf-8?B?cnYwT0EvYkhYcEs5QWFOcjhTM1VaMmFvQmZMbVEvWHNVRldlTVI2ZHF2b0hC?=
 =?utf-8?B?b1c1TlJxUU94UTQrODlESU4rNnI5c3FnQnhRUmQyZFA5VmIzeTBMOHQ5VDM1?=
 =?utf-8?B?Q1pidG1aZ2R5aGlyYWNMbVZ6SnUvd0NjMWNOK2MyT3VtWEhDeW1yMFJlS0tp?=
 =?utf-8?B?aWt1aUJXb0pocXJSQzVLRURybjJHRk9UWXRzVk01VzJVbGVVM2VTNys4R3NP?=
 =?utf-8?B?QXYvS09PTlMzL1g1Vi8zdjJZR2lxamUxTlZvSTRPOUJPT1FnaFVjQ2RpNmx6?=
 =?utf-8?B?UzR4Nis1dHVyenY3OXNOMFlPTWcwNGMwMHZIRVpYKzBxSTJOTE1TblJESndt?=
 =?utf-8?B?WTQ3RU1GbXVjcU40RU5ucFVwUU5tNzIyRE5YeTUrT0k4WkdvUHpJb09CRyt3?=
 =?utf-8?B?SCsvK1JiR2pGTzhWckdEWExwZ25KMFhCNkVMVVA1MjcweDcvUkVweDRtZHNo?=
 =?utf-8?B?aEZsbmVUL2RzWVpwMjZtTE1mTVpBemtocVMycmxQdWw1SFpTZERpUGxaa2Rk?=
 =?utf-8?B?RThFZzJIZVEvUGFjTWJjeVBTTzJYNkdOV1lOM09jTEVxbkQrckNzNThyWnRY?=
 =?utf-8?B?U0J5MVVkVVVvS0w0aFQ3bnVuNjdaeXM4anB6UDl2NjlLanNlck0wNXZ5aFQ2?=
 =?utf-8?B?c0lZanBXN1ZqRUljQlVYL0JwWENoNUNQbGE5SW5lemJTZUxpbHFWVFRmSk52?=
 =?utf-8?B?d0NSUEZVaGlQbkNET1RJdkVESjJNYnBDTVJ6VWtHYVZLeFBwWUNFU3k2R1F6?=
 =?utf-8?B?NFZiRjBuaXU1Q1UwY1dYL3psSVZ1T3FGM2dFZnJYWlhnREFyS3YzWkJ4S2Ns?=
 =?utf-8?B?ekpkaFIzKzgreGdsS2d6bm9UMkZzcm1LNTFpdnp5WEhmQUJ3QjRrN1lMNE01?=
 =?utf-8?B?SWtGZkkxVmhpUmk5LzluUS9sZWNFZktNN1I5eXZaVzY3MXF2UGxUVWpIUDFp?=
 =?utf-8?B?NTZIMzBNRytpRmdaRVAvNEhKSERGb2VVeXNqV0dIWDFVa01yNXFWRGNzQTkr?=
 =?utf-8?B?MWFrZzhweHZnNWxTemlQaHk1aS8yS0pDT3FqSUtCUmhKMUpmS00zd3dRamZy?=
 =?utf-8?B?MTRCTm5hUllqb0lsVFAyTTJBVnJNSlUzNkU2MktMS1NaMEo1OVpBWFhyQVpJ?=
 =?utf-8?B?SVZ5TTdPZ1B4WDNVMHpvcEhtOG9pbzdLNVhnU3JPRytIU3E3a0ZpVm1ydTRk?=
 =?utf-8?B?Y3QxUHBEWjRHaUVZUnJzdGRnQ1BQNXkzZDIvNHE1UVN2bVkwWXhXbkJmSm5D?=
 =?utf-8?B?YXhpMmJHSjczb0daMzdMMGRTb1pLMTZXQ2Q5eHl2T3hsUndpNXFBVUJPbCsw?=
 =?utf-8?B?a1pvZ01qUStNNHBIa1VMVC8wdlNlalFSWTgrSnBVbWR6c3pWYzVzVVJDb09E?=
 =?utf-8?B?UDNSa3M1TlpBZ1pvSStENmJ0UCtpL3hEYk4yOHhSTHM4MzRwVHlHczg2Y0wy?=
 =?utf-8?B?S1RJejJmTngvaG1HN282S3hrVmp6OU1QMVdYVjlkUjNRVDlCTk1WNytRdVVB?=
 =?utf-8?B?eE9NY3BlNVFtK2RldWZBRHRKTFJvaGpGbGd4SWk2VnhyWjlxSnhYNjdIdFhE?=
 =?utf-8?B?UXZ0U1NpZ1RibVc0YnBZQlNwTnFTVkNJZUp5RGp2ZUxMSm9DY0VkUXN4K3ox?=
 =?utf-8?B?Zjk3Z3ZmV1JtaXU5V3VhUWU1M05YUkdpb2t1VFUxR2pWa21kbiswb1pFOE53?=
 =?utf-8?B?SFpXbzdGTHgrdE9JYnFUeFE4NHd3RkY0YmN3ZzlGcU9LMzZuT1pvQ2hrdUY2?=
 =?utf-8?B?OHJFdXhKRFJYcE9HMTRWVnE2R01xN1FBM0tsVWdKN3ovU3lVdi9BWUU4VTls?=
 =?utf-8?B?UkZ1anlXWlNhZi9ld3FFRGwxcVRpZVExU0hIUE9jNnJpRFByVGxRcmc5ZzR1?=
 =?utf-8?B?YjFJMU9tcTJLV3NQbWpQZ2RkbTNMVDVwSTR0a3JBTytBSEcyanp0VWdQU241?=
 =?utf-8?B?eVA2dUgrWE1iT2UyMkUzZDJPZmthenVObW9vN0NlNXhsRjZONkN1Vml2NnpS?=
 =?utf-8?B?WWRJV096U2N6OUViTjl3clI4bElWYXh3ckNwRGF0OWtTS2hzMDFraFNNd2J6?=
 =?utf-8?B?RjRqVDA4eXBYVGlRQ3JFS3dUa0dxYUVnQ0VXbFdlQlo0UGdZQWxLRFRYdzJM?=
 =?utf-8?B?Q0ZmT3piWGRTWmd0cjc0WlJwZFFpa3A2ZDhzYUdzTThjQUkvY045Zz09?=
X-Exchange-RoutingPolicyChecked:
	OqaKVoA115q5txgWjYyx8mlbVeKXUB18kdQk5S7i2DyUsjRBZwpkfoOlQczY1qy/JocmlnkdWeI6qvZUYwEcvs3dqalxeIyWdyGgZLSKEGPzXgC+ikNgAum2T2f0TDwPrAzhNf/6aAwopZD7sUznUDrU/p2hsFlcEiUijz8k2AQL25kMa55JEXsQ/dnvk8F+/HNsm4l1DXwbuCJA5DVGlMpvr2QEtmq54sGsh3XPjCeSKl+4PFVY0kJdZxqoOCmGJ5foxV9i6/ECiMtTOyOEBhDhFIIyrvhQzowCXzHdxVxL/vUNwD+Y6J/ZYlnQX68IJuj+2/4wesuouyMaaOzMrg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	06IFVw3P/IUpHikVilZor0nD2KhsMWC+RUCdv979Ayu26fhxVrhUvwyn1lOPTzrYF3j17Fk3HXViHovVV4Q5bYdPEt084AqLYedEJN/iCEJ6lLRLMBuJU18Zy+GmQD4KYDvueIS/J01biAnt4tZL/ioGOIf4fnRftNSD2+Sic7M0QqnkvU6qo33SIHODP9hxmFxPEB2BDotCeGuGavMvTSR1Bnz6Dq2pld0rV6blKadn+fSfSMMOrFxvYDOYRwQ7u4Npx/qHKEpAZtTkQEpfGsSTYSNW7bx4XlGZhyHGKrUvoE+orq3Y2ptKu+FzQE+8338/JM5bjdhVz6misLp1dZppwB9sndoz7/wIXM8FTtFX/Px7ZifhMZNWcPm0ncnk2uOBQeUoeZnY7e6bSa5sqG/wU6T4u++N+VABN0xvE5gES2luUHr6udU/3ucE+lSvv23MR1OhS/Z7Lh6vJMctNbEZ57Ofjan3+IdcAPnFzV91+IDDcAnDbBWxtYdG6w594Sr6y2JIrIq/1YkXqI/E+cOhrO97dm3bQHT6QjmdL/gTFc8+6H9r6m37AwzjOHLJK6VuOg/s05sEJvEjUNzDGnFZf2o4BbYq7V9ISA3BpRw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d482576-3385-4c21-f6f4-08dedb49149d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 10:26:46.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEBmR3avN6Wk74878F9nf1mWmeC58YhlCdx1+C4yBtvqpNUXcxW7ewkY3/gExKouuXtOYPGOJnvHeU+eaq9aJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060105
X-Authority-Analysis: v=2.4 cv=BMaDalQG c=1 sm=1 tr=0 ts=6a4b82ec cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=oXkmchhlp81meTFojQIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DPJn9lkR_aZ2fZi0QUQ4PU-IaVeU9gDE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDEwNSBTYWx0ZWRfXxjp5tTHrgU7i
 oPTTXiGzqx6QxVaru4uqLLUwU+dIAPyB6rJC2yie4POvcIL4oNy2SLEMJrT9yhkOSu8OvNqFPxU
 5yquEkpgi9mb53Y929SR42CAvEhftIo/CFICUPUGbW0h4H8uJpjY
X-Proofpoint-ORIG-GUID: DPJn9lkR_aZ2fZi0QUQ4PU-IaVeU9gDE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDEwNSBTYWx0ZWRfX6K9kwk23f+UD
 YtySR9hGIX11+kGfBcIBcJt7FjcjYV8dqZurkR7mLn5+mLaaR0E5x1D6iRIVNwta4S9JEqgC0Ku
 snTYA96rOVh1iIJQ4xAVVxjHoepRnPQ1Lkx+aFAfwLmJeWPq5SgEOWrXEJ1g57O1gk/ElUox/EN
 BYKOpqkjCPjG2F2grzN4WGQJ8BqjaNT8k7OO0+ZxvmVBjDz7azrDhfcuJ8Rm8hlzLWHYOQTQDH1
 PV0rHJ+UZhLuctQQ3ouYsB4FjPkZPXcUj5X1wBSQcXAczIkejwDfHmF4Hl1VSWD7R4OAn2QTX7z
 3QeAdGq8deV3R20NCrqJx8XZPPA6un6/S2vZswQNYoPL5Xw9shWO0xBuRVVLI2ySJtsllhORNiy
 3FnlFgJKqEbBOUjp8nq+2q8h9mnIeE+RLuDFp1CXroys3AT/18/GTRbT1jChQ4ypPM5UmpmDRwH
 ydZFqniuNHKq+lZTl/Q==

On 03/07/2026 11:48, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Dropping the SRCU read lock during ioctl execution leaves the `mpath_device` pointer unprotected, causing a use-after-free when passed to `cdev_ioctl` or accessed.
> - [High] Decoupled lifetime between the embedded `cdev` and `mpath_head` reference counting leads to Use-After-Free during VFS file open and release.
> --
> 
> commit 9a6527083c29f0b9d58867aa52ca2ea700cf1168
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add cdev support
> 
> Add support to create a cdev multipath device. The functionality is much
> the same as NVMe, where the cdev is created when a mpath device is set
> live.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 78f88b0664c78..6d2e1186a10f8 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> +static int mpath_chr_open(struct inode *inode, struct file *file)
>> +{
>> +	struct cdev *cdev = file_inode(file)->i_cdev;
>> +	struct mpath_head *mpath_head =
>> +			container_of(cdev, struct mpath_head, cdev);
>> +
>> +	return mpath_get_head(mpath_head);
>> +}
> 
> [Severity: High]
> Is there a race condition with driver teardown here?
> 
> If teardown occurs after the VFS has looked up the cdev but before this
> function calls mpath_get_head() to increment the refcount, mpath_head could
> be freed, potentially causing a use-after-free when this accesses the freed
> memory.

Yeah, that does look like a bug and the same issue exists in the NVMe 
driver today.

> 
>> +
>> +static int mpath_chr_release(struct inode *inode, struct file *file)
>> +{
>> +	struct cdev *cdev = file_inode(file)->i_cdev;
>> +	struct mpath_head *mpath_head =
>> +			container_of(cdev, struct mpath_head, cdev);
>> +
>> +	mpath_put_head(mpath_head);
>> +	return 0;
>> +}
> 
> [Severity: High]
> Does this sequence cause the embedded cdev to be freed prematurely?
> 
> When the last file descriptor is closed, VFS __fput() calls
> mpath_chr_release(). If mpath_put_head() drops the mpath_head refcount to 0,
> the mpath_head structure (and the embedded cdev) is freed.
> 
> When this returns, VFS __fput() will subsequently call
> cdev_put(inode->i_cdev). Could this result in a use-after-free on the now
> freed cdev->kobj?

As above

> 
>> +
>> +static long mpath_chr_ioctl(struct file *file, unsigned int cmd,
>> +		unsigned long arg)
>> +{
>> +	struct cdev *cdev = file_inode(file)->i_cdev;
>> +	struct mpath_head *mpath_head =
>> +			container_of(cdev, struct mpath_head, cdev);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, err = -EWOULDBLOCK;
>> +	void *unlocked_ioctl_data = NULL;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +	mpath_device = mpath_find_path(mpath_head);
>> +	if (!mpath_device)
>> +		goto out_unlock;
>> +	if (mpath_head->mpdt->ioctl_begin)
>> +		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
>> +					&unlocked_ioctl_data);
>> +	if (unlocked_ioctl_data)
>> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	err = mpath_head->mpdt->cdev_ioctl(mpath_device, cmd, arg,
>> +					file->f_mode & FMODE_WRITE);
> 
> [Severity: Critical]
> Are we exposing the mpath_device pointer to a use-after-free here?

Yeah, this needs to be improved.

> 
> If unlocked_ioctl_data is present, the SRCU lock is dropped just before
> calling cdev_ioctl(). Since the lock is dropped, a concurrent hot-unplug
> removal process calling synchronize_srcu() might not wait for this ioctl to
> finish and could free the mpath_device.
> 
> This would leave the mpath_device pointer unprotected, which is then
> immediately passed into cdev_ioctl().
> 
> Also, does mpath_bdev_ioctl() suffer from this exact same problem when it
> calls mpath_device->disk->fops->ioctl() after potentially dropping its SRCU
> lock?
> 
>> +	if (unlocked_ioctl_data) {
>> +		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
>> +		return err;
>> +	}
>> +
>> +out_unlock:
>> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	return err;
>> +}
> 

