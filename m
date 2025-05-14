Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E09128819;
	Wed, 14 May 2025 11:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220514; cv=fail; b=U7RnMJQ1foPYEN3+TSKYTkoJeygEPNtTt27S7AlytFPJzsCM2V7LUEw3oEeT9jcqnffGeBIyJZSj1+0TUWesaI3rtN7dwgodyF/85IqTgplO+euGRxo8cnU5rs8m2efZEg4K3wEy2TSwSz3UwPTn18XECkzmFuiSdyYElMFbFTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220514; c=relaxed/simple;
	bh=6ZowV4s8vLLa8iJgUG7Gmm7DW6OM9xz7XxUN+HYtYds=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ApgFcEYVJizhssqcUk2K1wg+Hd3Duxgc7ZLHWLb71xfKx4OAuWXrYweQ26PiO4v6e5ltIuYaWjaXLwGqHKbrl0YDT9hI7YbBaHD7se2Xp/GW1VgkUe3tzfizftxNVqBC4YDBaFDLSOEpCuglXnTLPsaydJ6//bloo8gzyjbL+X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KWvhkv+b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L0nPL4xi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWvhkv+b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L0nPL4xi"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EAC0EP015910;
	Wed, 14 May 2025 11:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wKMl/zY+QgctxYL4zzoGMKyiHB7TOrQwg/Sfw8Tltpc=; b=
	KWvhkv+btOYR8bip3+gJGmRhoh0ZbHFaxHkWyxXI5x4IaZd4JLSEH6gn3UHhaLo+
	kAWGhLolX9Jemx9HM8Vr2JixOe36TOLHFGkcXbHBxs78QZ4h86dW/Kobl2VrxHBf
	EpOw+mvkZaTUB5NLimT+sX9+U5yJ4cQI4TO96+H3malFq7+MuL8Q0/i/zjOlRS1p
	/yzt4U1st3ryG7AGfV/XLnyp7ryACnj6l8uUQX8Q4/h132ml7m4ZRVsILctjL4WV
	G6nSiNi8okiuPecV08uveI3oHVl3xpZ2zHlbFt9t4OLM9REIdJ2j7858BXZ/QFwp
	tIJVu7Lz247fvsHQi/97Fg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ms7br2ct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 11:01:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EAUJs7004196;
	Wed, 14 May 2025 11:01:50 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010002.outbound.protection.outlook.com [40.93.1.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmbvpgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 11:01:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVq37eHlRkYp7QjYPnvJzrxds8CdZ/8qrmUjErW6SHuf6wTy+yGV+gKItGhocoNC1f2bIjpMdmok6dCIgaVQnjyeKk079wCaAye2lOCI0S6XyPePKizJZDf6S8O2oYd7WSj/IMYxt3NKXkkOKqvIZmOrzdC+PdRoYz3qVJy7spAk5iweicuHx2GA6Dlm0tDd0mkRmUDHLrAXUzNKkqd3sa/ROvgiMMQaq7M7bVpCF1c8VOf94zDX7kv3EfbTxSQXFMnmE+2hVD1g2k3SgvKeGdTbeFQhIq0iQeZfJIXcQZ7K5opWm/yOrCjvDZS/HlgF3VhSogCyHIdbC4Mxs9uhSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKMl/zY+QgctxYL4zzoGMKyiHB7TOrQwg/Sfw8Tltpc=;
 b=eVZQcGXr/7aasI6KDjo/M6xDcULmK4uy0dCJoDhmDUQWyB9pTea1/PbNLTlEnzMQEyLOvaMYm/jIHPedz1v2u7+ZndTuwMwmfI8WWbs12S1egU0ZEQqocQpzGYJ/FbPO0s4WFdYuNJb+MWKeGqyt/DUrxm3apJRtrZ32XjzPyayXjYhknDpz9vmC213z657R+L1aKkLynPEKsO1uJ08wOOP0Cin5GtVHI/q+I8kZ/Y2PmzU6QbDZqo/lqLwxCycDHlpYXAEW0mMRwu3vyp8sEf6zzoljLks9cTCDRyFq6WQuDsJgQxNrb2Ncus5XYheNXUUbfgmJbnM8kwTUpk+yxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKMl/zY+QgctxYL4zzoGMKyiHB7TOrQwg/Sfw8Tltpc=;
 b=L0nPL4xibdJFgZ/v6MZAOLjMOoMIz6C59GjduxUPMU8B7SabmD5p4lhhBTCVOswIBrJckYSwfCvKssXEJ/5taarlLLnGNqYD+iE1iK5ebRjsejsu8t0zBk6KdORrPSAuh53WxMVITjsSxUlV3qbMA35aS0VRqRj7w/W6XudQevc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 11:01:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 11:01:48 +0000
Message-ID: <738fdab6-6b16-4592-8e9d-515f02fe8298@oracle.com>
Date: Wed, 14 May 2025 12:01:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] scsi: target: Add atomic support to
 target_core_iblock
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-8-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241008020437.78788-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0071.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 36ca4fbc-3345-4b64-fc46-08dd92d6b913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dEJ6TGhSK0pmTlE5Mk1hd3B5NzUrb200UVNwZU9xdDVHVmg0WUpudThtY1RT?=
 =?utf-8?B?R0ZUakVEcUhEaTd6d2RCbXFQYzBvc2lLZU1iREt4K0c0ODRwYXpEWlhsbW5O?=
 =?utf-8?B?NmlGSkE2RjZLdTRwbnlDd0VxUFQ1cHk1SFJsMjFwWGZ3WTBHMUhnNjNob2dU?=
 =?utf-8?B?aVVYaTNWSjlPaVV3RWZVZFFRdWpjUEVtK21leVdoU0crcjZHQWxkbHBpQm5x?=
 =?utf-8?B?MnBOVm0vWklBMGlPZng1SVJpTXlKSUM2ZHR5OXhieWNDZDhqZEYxTm9EY25s?=
 =?utf-8?B?OUZQUi93M3RHQlgxWTkxaHd0NlNYb1V4ZUI1M2V2RE01R3N6aWF5aCtJNEJO?=
 =?utf-8?B?UnVxUGRxZ0ZLemd0THZOSElKNkJOdGgwWm81ZFZwVTRtT3dxV2pHMjg3MUJX?=
 =?utf-8?B?N1B1Ry8vcVpXUC9QSmVVdE9LQnRJTnZ3eXJmS0ppZjNBclE2Vjd0NTBzRFAv?=
 =?utf-8?B?TTBoQit3NURQcXZCNDZFTzJwYnFNRUdJMEphZE1NY2RsSmRmV2hjMzByaTFl?=
 =?utf-8?B?dXBJZFRzUTg2cG9adGFCSXNJelg3WUhpVVJMdU1BRDB1SS9BVnlUSVhyT29M?=
 =?utf-8?B?RVV3Q1RscXIyNGIyWVRza0U0eVBFY05aRURDVTlCTVpyc3pXRjBIekhnUGJI?=
 =?utf-8?B?bDJ1SmsyT2FWL1RnYlZTdERZWmVpR3l1YXBFQ1F2cVgxc21UdE5ZV29wMUlZ?=
 =?utf-8?B?OTZMViszMU1DbFhsM2VZekJWNmpVbExSUXpOVXNJM0I0dDluZFdHOElqczFj?=
 =?utf-8?B?VnFRL2RDb0lFYWR5a2EvMGNTYmw4dFV0TDBackpycWViVVcrVFh2VXkwN29o?=
 =?utf-8?B?QnFYb0FNdFVZcUZtazlKcURYQS8vRElNZHg2OTE5Ym5VREF3UFkvZkhjd1ZW?=
 =?utf-8?B?Zng0eGh1QXZJb3Q0T2N6Y3U5S0g1SHpLcnhvbUpla3hnSE1oUFlzQXNFdjVp?=
 =?utf-8?B?L01VRDllRHFmS2pBZnBYQXFpc2FrYmk1RXpPbFlpVXM5NGllak04QUxhSHhZ?=
 =?utf-8?B?a1dPN05RMVZWSTAxTndVT3FkK2JqNS9KMnBSaVlUK2lpQW04SlRIOTFBZ1VO?=
 =?utf-8?B?KzhFSFc1c1BqZTYvc0pmNTdXUzlGUG9VZCtqNUxLcWVXdEdNVGs0dXhYcWND?=
 =?utf-8?B?WEk2UERuZ1kxK1VCTVVUZURrRnA4aDM3NWcxRkMxUzZWNkJVMXlMUmdZREtj?=
 =?utf-8?B?K1dqWFBTWHNubTlaRzhibG1UOVJrZ2Vab2k1ajg1VXVxdGlWdTUwb0lyNWNQ?=
 =?utf-8?B?ZTRSNEZhRHNYaWlHRjJNYjFJallYSkszQ0xGQlROY1BsU1JkbDRnVHpxdTRG?=
 =?utf-8?B?T3VMZmtFMUlkZ2o1T25RcU4yeG4zY1QwdE5ja2dUaTFCTHlzbnpPa2FSSlk4?=
 =?utf-8?B?TkwwVXdaMXFOUUlNdVJoem1YTVpXNW9KaEVkcXhSaGRwL2dIYnMydVhrUWN4?=
 =?utf-8?B?bFBRdGgvSjdwcGZldmkzTzFQZmdFNWN5TVBXRHVuY1RxaEtTTUxrUWdUNTR2?=
 =?utf-8?B?ODg0N0k1bUFneUtUejhCcWp1ZkNGbWhsaGJ5ek1UNUg0UHNwd2EwRUtsaFpE?=
 =?utf-8?B?eGIxd0szczdJWUJOSFE0UldJN2pnWSthZnh1SWlJZ0xjcm9Oay9naDBTcWxQ?=
 =?utf-8?B?d3hVaTcyQUJSQ2t4OEV3TjRUWlg1OXpsUXdSdkl2WU50VmM4WGcvSHdZVWlS?=
 =?utf-8?B?QkJjSWRFNlR0RlNtZDNDdmp5Ry9FR1R0TWtYeE9JbEZEOGtVZVJLMGxkMU1l?=
 =?utf-8?B?UGRrd0JnTEVxa0hDcEhLRkJGajlaNnI4d244eHdxVUEyY29tQkhBd1lObFNV?=
 =?utf-8?B?azRKRlpqOFg2ZXZhMXNqaXFrZlluVk5HV1hsRkRRZXZVYUJPL1JsOFRWQjlk?=
 =?utf-8?B?WGxKaVVVb1BXU0lHM201RFpYMlhRcmVqM29WNmlBRFFWNUpKVnlGMElic29I?=
 =?utf-8?Q?whHFcuIoKc4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjBpbmJDUjhqL2UyM1RReXRHTzlmbEZtdi93N1ArSzZKZmEyelJxVzRLQ3Vm?=
 =?utf-8?B?YUkvSUpLWjduQ3IyL2YyVTdlcE4vNHR5RlBEdmhMTmNEa2JIUVhHNStGL3Fa?=
 =?utf-8?B?dXNXTEU2eTA2ZVhmS2d2UkQ2S3Bha1YrbnhMVUpTYTBlQUtQWFB3V2RnMVBP?=
 =?utf-8?B?c0syYjZtb1MvVllVdlJJckYrR21MV1dvOFAwU1hSdkRIQXFtYlJ5bHpucUFy?=
 =?utf-8?B?L2lZSVdXeGNYbm5tck45OUNHYWJKTUdzMzJnemtuSW5mMU5yYTZteGxmdWIx?=
 =?utf-8?B?NlBWK3IrMEJSZlBQYUY3L1pTeGt4TzNBNFJucS84SGZJYUdFY3FCbGtQZVVD?=
 =?utf-8?B?ejJIMzRCSFM3ZUM0SkhvbGZYY1NIbEJ5WURXYXU5M2tFbzlQTWNCblVObHFv?=
 =?utf-8?B?MVVNa2VVRmRzc1hlbSszVlNnQzJnaURtYm9LS3U2MTBQSkdndGxDOG9UaTU2?=
 =?utf-8?B?MUtWQWFCZjFCdkNiTkdpay9wK20wR3RjUVY2ME1zQzhsSjlHZkZTSXZ4MG5w?=
 =?utf-8?B?cG1xSGUzYjZ2N2VDanNKcmpFS2IrdTQ4YWRUWU5kaVlxRWQxMWtpMDBTSWFF?=
 =?utf-8?B?MmVISFNOcSt1U0UwUnFhNWxGUEo5YzVhdE5Zc2pYRWxsRkZlZUFVd2Fta3VY?=
 =?utf-8?B?TklKRUJHNTZxKzNkQUJKVVN0TENsdHJPOEZJckNwQklJRXF3MVIvcnB4bS9u?=
 =?utf-8?B?K0F2d0tIMnljcHQxQXlzbjF1Ym1KSVhHRld0S1Boby9NRHlqS040SWk0TG9U?=
 =?utf-8?B?YWpBWTlRNE8xTFRYWWhEamRESW8xNHZMZlYvek4yQnA5STlMQjJaQVlZbXUy?=
 =?utf-8?B?bHhrYXBRS0s2Z2dxTWQ3VUNMS0M4b2RiUzFnYjZVQTZUTXVPd3RGL2FDOW9W?=
 =?utf-8?B?aXI4WGNZek03bTFBWjMrSzBpc2pXZXVvNDNmbjU4Sk1PYTM4Ym9Tci9MWmJQ?=
 =?utf-8?B?bzAwbjlKS0JIZDdSQmdsaGpZMm1ESk9teWd3RDhZcUgzc051cnI1R3QxbWZH?=
 =?utf-8?B?NVRZazZFZHpYWEtYRkNyMVN6S2l3MjFHUnFoMjNFNGxLZFd4a3VxS2d5Um1h?=
 =?utf-8?B?emgxcVByVkR4UTZnV0xqYWVvZWJLY1drL0VOWGlqN004Q2RVNHFKOGcwWVc2?=
 =?utf-8?B?b3VJampaZnE1WldtN1lUa3l0NmphamUvRjY1K1QrcHBRQUlZMTlZTjNKV0Y1?=
 =?utf-8?B?bmY5OFlBL0hZOVgxWnJOMmxQNnZlSXNSUENPUnM2dnVveWxGbFU0MlZZays3?=
 =?utf-8?B?Zi9Oc0xIalpVM1p6SlBIY2hGcHE0THRmL2pMTjUyQlVqUjdKaGNDbGlLTDda?=
 =?utf-8?B?dlMwRHAyZlhVUzN6eW05RTBLb2djMGwrNURPTU90djMvbllRSkk2NXRWUXQ3?=
 =?utf-8?B?L3Vyc0FKaytmeitlQVNBSDBFWGZjT01RVTFMOUllejFCT3g3di8zSGRMOGFw?=
 =?utf-8?B?L0VlYXJ0a1gwVlFuSDlTQXhtdkN0WEZ5TlB0YU5Gd2pCVWpyN0hJWU8vQ09S?=
 =?utf-8?B?b0FsL1pQbVdYbGUwbFZVc0NLYktJZm91UEkzZmRpN0tSL3EyU2NZVjJwSTB0?=
 =?utf-8?B?S3hzQU1rT2V2WUFrS0hxRWhMamRwN0tNdDNLUmd6SlZJVWdWYUVwa1l4c1l3?=
 =?utf-8?B?bFJjSTdHM3J0ZW9NMm9CSDRVbCtrWno3TDlXbkNiK0RXOFRGOGM1ZVRWTXpT?=
 =?utf-8?B?TXNYK09rOHVkMW1LVDBETThGZkU5UzNqaXZ5VUY2LzZjNlErQUtkS2t1dHBR?=
 =?utf-8?B?bUtWNGhlTzRVMXZuTzRrUU1yZFdpSmhXTVlGQzQwa2dmM1VUUlF1QzhDcE9W?=
 =?utf-8?B?YUpJRksxUWFvemZTKzFjOEhHeUlRR0pCdHRiSDZEN0FsbHh4MUJzRHFOc1VK?=
 =?utf-8?B?c1ZqZDlBVXVXL2lXMk9HZmErbkI0MDlLY1gzT3ZoOGJwTlJPYXVtcVl0cG9U?=
 =?utf-8?B?YlZEeXJ4NVNqMjdtTkhkZkY1SFNxbHRJNUdLK1JsYjA0UDAweVp2M0VyNDNU?=
 =?utf-8?B?K3A1MEtYcjE0eW8zaTBhYUJ5NFlUa1ZoRDlobjhiS0RXK3d2c0xkb1B2MWJ2?=
 =?utf-8?B?b0tGUXVqVmJrQ1N0UTE2VUcramxCRXlpRXY0bFNtckxTejNZMUNkWi8yb2VG?=
 =?utf-8?B?QW1WZzJqQ05UOE5yYlczaVlpcHR0WlNOcEJUdlpuMjVBR3V2VXlZbm82cmVN?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	geE+lPqntbk3orHf6RLlnzLebB17NuYACr5PcQeFlmjogJnBKgxNjGsXnRm89Fhy6e/09xk0GJLuuiKfsxZwtoOPCQ8jagCmCsODgaUelusCZrkVeYwx5QIF42l0WI5/1zushODlOuZDtTYXDbA7oTB7IevY/Wy/80KyVRf6vBI1vrGFzTyluQ68U//508WXBsOzb8Nk5TJqcFzU9O7m+r7jM64BoayuLCymT/0j4QQ2E0VRgPlP5D1IREt5jxYZyT6AUFyGbtRXSdrTGqZvmSou/qSJnXRelqos6AAn5Hn18OSXBl08kBf/IkPR2q/4YVQ4tsbGsUZtN3MLg/yirkZ/nHjEp06hrt3kuWCrEfTMimsyJvaqRF6fqe+aJPDzVEaiWvzBt6KH/LAbUsoCcIlVmgidHPPi5YfZdmy4AOVW5ihhvJrN/inK4c8P+XsIlX4aY/r3hLXKWY+etb9IiPmSaDXM7CkmuV4rCW0PpVCGt7ohdhRq7ORq6eiyxC4RW3KuoXHIp/mx77Z3uWwZXKNqgXVUOSfenlx1fG/4dr+qCH0XMbTgbcM76khMH00KxDvuJtuyfGLBot3TBGCuWt8giEgpBQH4EtC/bXL8xbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ca4fbc-3345-4b64-fc46-08dd92d6b913
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 11:01:48.4980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3w8z4rpHC0sKF0vsGw5l0Qv9U04Q3+m/aW0qRxxJRXF/SAh7AMPK7ZjtllzDd+/itjpq+DiYPgltiGdgl0hDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_03,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA5NyBTYWx0ZWRfX4p3kwqzp0Dtg TH8v7tZ9nO6PNUH8s6Geis8CQhYhU0GfCLUrbg5bhcRHQNoUrmRlP+44iRDwQdCTHN3fsQjLCUF VCoDABMRuFj4XGXl4c1eq8IQMq3+9qLvpAeC7sz1Ybb9uj609KoMlHPm0Bf6uy3cXfF7MeYSVW8
 Vg69FWTD/pCnxt/O/DbgfzTyavR/KN6CnpP+01BDHVDVerm0+ChB/i2cladoLJYJhYlOE8Y5ks7 ILPtpUqsfv0GBdm5vju5Cd0ZWbQ954yLdyoR+uGXqUzXjp/doUJUHu22HvEOWIBka8SG4WYbHju 1j//CJaCaZ65483WQYrGrXnajNTT6YF+OwwA6DCbWbW+tq4/2c7j/or2wIl3fiVU3mxVUPEkwcf
 194KZB4BiQB9VUc7RpoLWvgxyvTy9HPf6Bg1bsmFCiJkxuQHwT0Q+cTM4O++XMXV2dyLnC+8
X-Proofpoint-ORIG-GUID: vdslRtqsV7rOTESbpmNfvIQdHR27h0iS
X-Proofpoint-GUID: vdslRtqsV7rOTESbpmNfvIQdHR27h0iS
X-Authority-Analysis: v=2.4 cv=P846hjAu c=1 sm=1 tr=0 ts=6824781f cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=jGt8oDgdUzQBsaSqkwwA:9 a=QEXdDO2ut3YA:10

On 08/10/2024 03:03, Mike Christie wrote:
> This has target_core_iblock use the LIO helper function to translate its
> block_device atomic settings to LIO settings. If we then get a write
> that LIO has indicated is atomic via the SCF_ATOMIC flag, we use the
> REQ_ATOMIC flag to tell the block layer to perform an atomic write.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
