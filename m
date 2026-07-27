Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E4642465C;
	Mon, 27 Jul 2026 16:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169310; cv=fail; b=s9edW8IYiQlrzJPlF2XY2OVeGU25XRNa8JdUkUJaDUSAvdGK6fbXd0QVXY62qZx/ns80U/owErR8YrybsLkxw4OoDOPiqPckmKNnt/sIis0qKgKuL5MwUDYjHJiOQdZlZ9pO3VD6kbfCTzGYLnTsqbkkqeLKWgGfX27Y82G2F60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169310; c=relaxed/simple;
	bh=o0iWiornNWBQMpxAPSRmJcmqKnu917GJKRZK3uNtsvE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D36hEVRNCz/1IvfSTCzczEc5isQ61PSNSigtthXdJ9QRR6f8ksXKz/8THlWjrdw9tvVyyPKT6HZXemr+J59ewIu5h5kmFqnGD/ZvuzJ0KPBbnUG8bvgIbo7VXs99XQNgvuqKJpevW2wqBDYluMiQ5neQGWzZ1v9BTr1P5T+9gvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q9o3a0gt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ln5AMXOu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q9o3a0gt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ln5AMXOu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGE5Yx2505148;
	Mon, 27 Jul 2026 16:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aNodvb4f/A42dSV/IccqQ4/LKDnF/QMIvUgEcgBB35c=; b=
	Q9o3a0gtbmWDxfUoOOH6m9ywDgypRGSNuOksLHy5cSAG+kLyAfIEWNRQmmcDtt93
	mYkKkhwbHN5MGIzwVpvyq9/qKqYE23SF283A2/Y2ZN7P3PO+fBI5dZ+LlDo8bqxM
	ZF65m+8job8JMdgwmv/+5dBQCzjxmuHWq0UY43VzeJm/dAXPOLnj3V62IJJdU0zN
	ETSNPo0XNQRTxLuRVWaoHQqSk5+0pueaNo5F6zm0ZZSD6FLOEgCPy/tDEs0FbI6s
	TmzsyYoQ0lK7EajBzKXogu8eA1UwJnb4QWg/K1JYPeYzYxdMjQ3dnE2AdmXucBLr
	wco/JjwKLUSNpf4nHfIQhw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nj4gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:21:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGKf45020449;
	Mon, 27 Jul 2026 16:21:47 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gjwxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:21:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjjTLdrJFcLMSfUMoxnYSk6N8n0VQu8Ome5YNIbxnkfGNopstLvr0KOPi18//bXlu1L4OSNsW1krDFp8pt2AFWmOUYW5/1tQROyVsepD6qeWDrpDmX3raqoV/eqcpNcRYg6o7wCBFcZEqAsr352Jj+nK31kWulKLGPtM9I9OT7urtN9xF8ufRNgB+nA2GHxgFFHMvLf0R1qD0sDAU4Vp2cD/Jei46jNzz5qVizGmZIKup+hxGEOVZqLYvVe0k9GYvN3CIvwD9359QPlMrFKMf3NnYPyf5CcogmLfF++XhbQnsBn7B3DjS/ho6UlXkWqj3/g/JbwMVdZaANHyi5ujqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNodvb4f/A42dSV/IccqQ4/LKDnF/QMIvUgEcgBB35c=;
 b=u9BjHvgXDiG7zyUDKh5ViSQl53+de/QSZdft7wayDcZfhM5J5iAeN1IV/jJGmyQMIxLyd2Smh2H7PUuRCuA523lxTaiQp/0Nj4/3eavh1q9jXMra/7zO2z0NYd8xzab8qL+RO4qMV5jsx1pJhBCgJyGV8qA9R1FbsgDrQDPn6YjJWgytEEb03WqwaQ/77f6DMNkFEUhoygQYuFhxeKSs+T110OpRDZ35efg8i7/H3tf30DED41zRzT7ytVVeKtxMVuwi0Bszh4jhA1iqXPXS6olNRvMXhhBf9NjAEJhJ4gkYYrAWSQJ5IYphwBWVsV1aXoDwm64HQofJGAcOnPG0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNodvb4f/A42dSV/IccqQ4/LKDnF/QMIvUgEcgBB35c=;
 b=ln5AMXOuQUkyTazfFzJZSAxvPmWArGwr0dD2YwT1HWU2NgtVXC8WiDtSURhIO+g4DI94rqknlJ23Ni+RpthH7tZvAdjfHZr1s7wubkchHh3dCJjsoD5QqrqHluq9nj+ULN9wgj9dnkW3AdAVwT6feGBpRMcXCro/C8DZzbOzVxA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SN7PR10MB6953.namprd10.prod.outlook.com (2603:10b6:806:34c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:21:43 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:21:43 +0000
Message-ID: <1dcc665b-e08b-4d42-bbc6-2295c81f6d65@oracle.com>
Date: Mon, 27 Jul 2026 17:21:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 22/27] scsi: sd: add multipath disk class
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-23-john.g.garry@oracle.com>
 <20260727151419.B41461F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727151419.B41461F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SN7PR10MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c8e656-b727-4998-46fb-08deebfb2578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|10067099003|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Zc3b/j5DIjZyw+XQhmrRCvIzTofEiEQSz+DNyqTDkxkiBsfE09Ti8+qCjXkS1gr8YPrHbjpUjOaVe14LVnTyVP/PwNle0RYKmAOdKLwtY90IV+BZXozKeqbHaon0glkGpq+3bnADXD4bzZC8x/rZcoHksr59cZqEzn7Y6q6gnC5yONhaoA6x+7pyZGJvI20Owi0ZMLsXUlSqhsrjgrsK9c0550gCvZiwzq+4rkrMEqzcFnugR4KtRnmvmM/pp+3zIOfphhRk+Mw/euVQujqw/z8tYVHAbLqQwzvdwM9byK4nSA6BtfWX7+AS6ddDMdAj9qoO2jPJL4eQkdiZMi1MSbW6RFkJN/NVtxDZXQIKLAJsxHB6P5ZyYEJn57hGKkhPGOm6QTHC0pg+UIP90R5upIpvzQFfT7k7rbXVbJ3+g7Mkq+Nd0PiF5TaMWpNmXt4/8+lIWTQ1zIUhH5MXUI9Hhux5cJ/l7HSGHlXHat+r6+RmQQn2jb/jLmfc7tlrNIv7lTQLsXbvOmr/iWstbrWl03r+e0qs5iHCZqPoyZcS8RYusG1yVDRBDYowxZVb2aN/cmGaf73HGycJJZoE0KWlb6HN2G1Ug0kleVcXNLQbxTZFV3SXCrr22zo2bGA2QtRPEvufJIJ0jRbiY7R5cSRtro1leRf+WPv9ZX709uZGeE4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVA2NmlGdmI5THFXSnNrelRBdU1pYktPalhsbmErb09aVkxLc2VveXVOS0RS?=
 =?utf-8?B?dWFuYVJHaHBZcjJyVlVHMmxJUjFTMXBTazg5OC9JNjZBYXZKSWkzdWI3YXhp?=
 =?utf-8?B?YW44NWthRVNPd2pPRnNzY0FRUnJNbG9sTUYwZnM2REREdDBzZ3JIM3ZDZjRn?=
 =?utf-8?B?U1IvWDhvaWpFNU1PQks4Y0hJbnJJcjVMQWQyd2gySndKbEk2ZUZPZ1dwZkxQ?=
 =?utf-8?B?WCtIWUNYUmNJVXdIQjdHcDdVWnhHN3lSdjAyZ29CN3ZOaUhkaS9KY01zK0ht?=
 =?utf-8?B?U2JqOTloR2NMdlJpZ3ZtN2pTa29TOWZJNkVzSjFjeVgrcDhzTGdqK0picEli?=
 =?utf-8?B?dnhtOTBUaldLY21GZWNUa0ZlVUJNaHNyR0JCYU9YRlA5RGJGQmU2N3ZrTE5r?=
 =?utf-8?B?YUNuMU0xT0R3NjA5WkVpQ1h1TU5zOHVlYnNDTy92b2syaWZpeHY2WTRtT1Y5?=
 =?utf-8?B?WC9ydHJVQlNjcE5sMDFLRDY1U1g2aHpCdWFXRXFWc0tnQ0lSSGRYZ24wVmw2?=
 =?utf-8?B?NU5aNFducVNpbGxWb3FqSUNwR3VrMDMyTVA4YThjZHY0cTdlTVhPemsvRHVO?=
 =?utf-8?B?WWZhTDV4Rzl3L1NwQ2FxcWhTUVJuaGNFVC8yeHZzcXlJSU9ISjhzZkhkdzhL?=
 =?utf-8?B?MnpXd0t2aUpxbGd1TWRhdGhNRnhUSDVZVm85dkhHdW9nSFVhdEpveU9ZVlRO?=
 =?utf-8?B?TWJxUHlVNlhReXd4cGVlMHRIdEJHTDJlMnFZN1dLL3hJUFpwUktoV09oT3dP?=
 =?utf-8?B?MGUzam1hZUEvR0tjZXlGbVNPVlI4QUJyZkhxSmUyMVo0SndHNWFObytldUxD?=
 =?utf-8?B?aFc1TUFzOHdhcGgyRWFqa3N2ODlvNXdJYVhDYVV6cFM4RWl6ZDUxT1JQaDM0?=
 =?utf-8?B?TjN0ZE5YUDIxNXZkaTRZSTBudWk1MHg3bWJXTk9DR2FBSlZadS9KZzVBNmxI?=
 =?utf-8?B?bGhLV1ljQUFDODVUOUNvZjV3Z2NzRkF2S2w2eGdiTXZ3TkVLU2xZQ05PRXNt?=
 =?utf-8?B?ZVhZRmFZVnpoMmdjL1lza3M5bzlyRlpOdVNrck1DQk5mbitpVlQ2ek9JTWlp?=
 =?utf-8?B?K1RJSEdTWi95TEVpVDZpY0k1ZFFuRVVTV0p4SURnc0xZMHRVdHZzNGh4akRn?=
 =?utf-8?B?RStEVW1ISFBzNU5mYmdxVyszTUlveGpWVjYzQnF4Rmw1SVBnc3cyS0JDMkZq?=
 =?utf-8?B?MU1qSk15NG5yblJmSDhTLzA3QkxCYXJMV1Rlb0lmSjRnUzJrUkl3UUNzYVdk?=
 =?utf-8?B?cUdBbThSNHFRMk44TjJkVFkrajB6QzBBYzVxNUVqQlN3Z1RMYWRFMjlzRU41?=
 =?utf-8?B?d2UzWkhXQmEvUTRzdkVNWkJ1aEgvWXZHLzdGWk0rRTFTNk5VVGhEeDRnbWIr?=
 =?utf-8?B?T1hwSHBySjdPeFh4NE9hRVBqTmtxbXo1SkdLVlM2WXJsMlJ6STNwSW1vZWw4?=
 =?utf-8?B?ZS9tYk5rNE9tMzZWRjZUcmV3S1hiZGlaYUZaRGxkN2gvcjFRQ3c1ek9kTWgx?=
 =?utf-8?B?NHg2Y3hjSTFZTEQ1TFhKWGg2NTYxR01CRmtxSE1lcFc5TWlaSndOaTdVSGQ3?=
 =?utf-8?B?TUNEQUVQU1R1TGFndmFSYnNyZ3Q1QUhVelo2UGJ2RldkalpFNm40eGQ0VTUr?=
 =?utf-8?B?QjUwM3YvTlMvSHpTTFYwVG1YQnZKcWxpNGlSTEh6c092L2NrbUo1bzFPU01R?=
 =?utf-8?B?aWhTbmZMc2VRcFI1bjhhdEVQRDBoSjZFL1ZUNlRySkhNT2I0S2h4RlFIYTIr?=
 =?utf-8?B?Wkd1ZnFDa3MrZ0ZQb0wweHpqL2hIMkM1cDdQc0t3WGpxMHFyRkhoNTFpRExL?=
 =?utf-8?B?Uk9YRzhJNHYyYzRRWmlhTno3eStNdVBaMXp4ZFZIQWxncjdkT3c4Ni9WMHFI?=
 =?utf-8?B?K1RydEtOMVVaQnlEdnFTejlMZ2R3ODlHZnczOFFkRTRqNkk3em9KczN1Zll1?=
 =?utf-8?B?UDRPUUdPT3UwNEVVa2ZzSnRvMzZuaEpIdExIVUlDOG5uOHcwSTlmejVOQ25E?=
 =?utf-8?B?aGFLak95enVUc20zaG9QVGw0YWdLSnlkRWFFRS9NcmhYUjlqeXFBaGRVNVRa?=
 =?utf-8?B?ZWVRdFVpcWdLSGRqSWljMmV1bDZrT0Z1MEtzYktkbXFrOVZ2SVFNdTNZbmpH?=
 =?utf-8?B?NncyMnFSb21EakJwQU1VVlJhTHlxTmdGUXdSYTBGanRjUElBL3d6ZEMxa1Ev?=
 =?utf-8?B?aVBnQUVnOXVNOGVZTXBWcWtQL3hzNXZpMUhyT09GMkpWeWVRTS9xSjlKdHZC?=
 =?utf-8?B?cldYM1ljMlRkaGpENDJCL25XZWdjVk1idGpMU2thU1gvY3ZGbFBXTzdqZ1lm?=
 =?utf-8?B?VW9RU3RsQ3ZORVkyNExtU2s1MmNmNE9SS0hZRkpGdFl2ejNCYndHUmVwZndP?=
 =?utf-8?Q?QFsc6EIlGjMDXfOo=3D?=
X-Exchange-RoutingPolicyChecked:
	DGgzeAx65PM8H5Jxbo/DVxhIis7HzGXAMMx+DCkfjGjUJIX3WUewC6wuOAvSmc9cksBk6HFkpSIy0iBTvod3WxjPSciZxZfMu9vc0HUvOOSnIZOTQTHBpX+WZ+aM6nqCu9dBwZhQ+ihK/VXfbyJMgyHWPeF6NUT0E0m+EW5drF2klau9JAg3F7N3W78HRi/0FbSX50kmjKnpaNDDxoedcimRzKKh7hQTtijrXIm/2Ap5AoWz8YNRbTBR1eqoYcPgzLE1+uQIJ+AxrSOn17zMR962lhA8U+cLO5iDWQBeL5N8PHfDL616hwE09yruVohtutp2YCLySnnhejn2vIPNIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	a/mvkbT689aPaGHoGoKqhHIXroIqR6b/tZatwB4J/g2TGU26L65k6mGitKDUYA2j2vl5CshbtmbJlGVOzX5XbXx4hI/4GI0rNxmE7LN6urB8ZrZ/3kUHGyBWRMM00yE45no4svPkYkRhxVmQfbv2yy/XtJcQifNGmmOdq3H/fqr/aYOcmaHvJvucUGLyMr6NhxS7RYp3edstdeDNa4dAWlriH4gHNZJPIY30mlWG+yhWF4bLxFynDrLkN6ytWRs6UmDLh2CO3IZTH6QMdl/jksrKR0xZb2HffDLre2UHmD9VOE8+lzpy+z8/rV/N98hy3jpRXdRyxX5q7kKm7nm5lVh174Ur+3gDFmHhG4kIOKptaAvjguThfirazJzEbVRCjTZ3ZDyUYR/9ioWIOoaDNw03adMveng88cC4CXS7EFQ14xfXCMz4n4ROUyGOCGTJvkfYN0nXMWIG0Ukk/Xd/UYpl8fw2GVR19rsyPD1CvQ1YsiH4S2ziAikktaBmAKkfCt0u/u+pimabfvLc4HNg6EuZG87bKrDszI3uuketfls/VB0rWKa0zDjJzhE7xCJgQwZ/7KVdaYZxVNERBrRs5egZ4vQZhacCs9eHfDh714A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c8e656-b727-4998-46fb-08deebfb2578
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:21:43.3588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaPVmfWmRkyY+iXyXpPj3rzVq4JW/vdBqUmz7hJgve/sq4AvJ0tp2W5SVcdfyMo5HIV2UEy6+TdOYiA1c6g3Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6953
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270152
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a67859b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=0UpFFr-qktfgoqZ55lkA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-ORIG-GUID: VJbkEFMwvq8xV0dkkachPUkWHyWVbWZg
X-Proofpoint-GUID: VJbkEFMwvq8xV0dkkachPUkWHyWVbWZg
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX+S4tkVRO+QUk
 +jAgUF1HOkPqDpU/8sosR+mMcejMb8bVrxdX1aRI5CLUeSfhMnjBPTTjBuzgSapq25jUyyz8AMk
 Gafn1AhpPq0YUEJNjVBE26cUaHQbJ0RDKLLw88Kvyz3dzH7fD0U+
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX1+V4j0580ifv
 7iTA9VX44M3/AIDVXLhUNgIWtHuisXTtQCjqUeCXHyandi2gWFUn5qrNeEet0k4E4IV1KuodQS1
 B+/zlPjWMKBd9V5ca+iwR8nD0ODS041Ox12dHyKrHSoRGdEsaXqeGAbGjShjItfEY9GpIe7zgrY
 l7/En+1nVCa+wImiFK1KlG+PNpmBoCOhA0PBHKSu7TFbxO8nWrAzj7LbDXtduqp7tA1ZwjmQJP1
 BCxpcfV7gaBI1AJpF2Q4VsTi92cP2hbznN24nKs5Ndmv9fqv9Jb8mAuZAX2v6V5gMigjcvd2tNs
 CLrUNAD7l6ZuECxo5v5fuCbptpR78V0Ld+fWIwqs1C50ieeDD+MQzEI93bHuUVuFqod7UGumU8v
 pjW2ykEpZBeyPCtdlp0a5IKsBRvBIVTUezDh9c/8hF5hEifvN/nH+lEP34+hQm0JgbobCHPkxMA
 bVuw7k31QQlyp3tRn+Q7bMD/aj/TByP3SZqaQ4ww=

On 27/07/2026 16:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Empty device release function `sd_mpath_disk_release` violates kobject API rules, masking a future memory leak or Use-After-Free.
> --
> 
> --- Patch [22]: [PATCH v5 22/27] scsi: sd: add multipath disk class ---
> commit f2a48f7b23ab293ee7178e9c9e97a979e61dbc55
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add multipath disk class
>      
> This commit adds a new class, sd_mpath_disk_class, which acts as the
> multipath version of the scsi_disk class. It also introduces the
> sd_mpath_disk structure to manage the multipath gendisk.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 599e75f333343..242a15bc2c5bb 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> 
> [ ... ]
> 
>> @@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
>>   static mempool_t *sd_large_page_pool;
>>   static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
>>   static struct lock_class_key sd_bio_compl_lkclass;
>> +#ifdef CONFIG_SCSI_MULTIPATH
>> +struct sd_mpath_disk {
>> +	struct scsi_mpath_head		*scsi_mpath_head;
>> +};
>> +
> 
> [Severity: Medium]
> Does this empty release function violate the device lifecycle rules?

it's added later

> 
> The kernel core API strictly forbids empty device release functions (often
> referred to as 'mocking kobjects'). An empty release callback prevents the
> proper freeing of the structure containing the device, which forces the
> memory to either be leaked when the reference count drops to zero, or freed
> synchronously elsewhere leading to a Use-After-Free.
> 
>> +static void sd_mpath_disk_release(struct device *dev)
>> +{
>> +}
>> +
>> +static const struct class sd_mpath_disk_class = {
>> +	.name = "scsi_mpath_disk",
>> +	.dev_release = sd_mpath_disk_release,
>> +};
> 
> [ ... ]
> 

