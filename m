Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212CC3B7B76;
	Fri, 22 May 2026 09:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441407; cv=fail; b=dzI4zcRBhCVo3Xml5iIfSvc7NfBisOLwDciY6EEzjHYYen8z6YlXXW7PisCGpPRASKRx4lMrfYqplUg7hAkc1rsT/iH2XX7rp+WxKkwBGFjPnl9KbzZgEe9WnW4hmDyhCg+jXfSG6ynJMkByT3UrCB8MCguXFdZuGcjJay9MZyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441407; c=relaxed/simple;
	bh=xPGFBqUuwyIVsnawE/o01Ro0i2LAsPqooC5/i7OPkGA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HQeui1Pn6QUXEEjT61GSzcLdPbpeMejapRW+xGZrcpuHOfrIhXGiFM++o5uZ/VFmZkTXJWI7HnJK2HpVltHQEJQyXe8Nuvw1yfJ2UwYjtdacpVZwbp4kXYnz0nQsZ8rN2skVeYrFle4eoFmwLA31e+P7KUUTT83CeWgIk8gtAzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vlm3gHQI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a0YH5VNU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vlm3gHQI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a0YH5VNU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M5jxrB2812760;
	Fri, 22 May 2026 09:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F2CcMKVb+b4WzfYKMDq8ECNeEN9+glrpr7PLCmWF5Fc=; b=
	Vlm3gHQICS2NeRVNDGKNSOOUMFXPqrKAmJlzHP2YJ3C40470XG0v5+LZboTq1gbu
	EmzwV35Uv2F2psS9oh81/L9vmjpoeK0xn2VWgzlBybspdHVuu99t0RyORZIJSBPu
	mEhLaiy5r2seUIweCcVr47+hdOQbOioygkYemnP+XLxTFeXUjJ8sC9Zc2VnNaqH0
	rf1XCTAxdmlhGHYXP6q1QZdgl/kcvkFsj/li2CR0U7o3TMlQ7nl8GqDcU87slOg0
	wstIR6fSblIFB+8cHrPQOWxu+xYBxqVwAlQUPlPkkOF+MpzUQOf94Tzm+agUaBxt
	dTfAjhDJookwc75dCyxf6A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t2us3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 09:16:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64M94jrj034962;
	Fri, 22 May 2026 09:16:12 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e84eg8ryy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 09:16:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmgcSCVGqJfMJOr/G/aU10JBSILla4L9y4jPvxyI68W+UB2njRF1I4gt+uR9MWY3ibjArjIHe2ptWa3+oDUynxPl3BfRTT411sKioOUDiIJDAIUPJMD8huFjnDexeMgNAbNn7ylUaqXZrnIcgxR/hhNzQ5B3kHM70scW0tSBtgorsuuBXDMe+DjdaZBYT7HnJD1g/vs6xdjLstuD5pLsp9+Gh2fqFujIZ1vkGvuO1QXu4xq9AEnacwQ7ZKljz4NEaDYI367+yp0+TIIbHHkQ2W14S8u53nDs8l4R+eZATw0jophtg99CqZILwkmikg7bW0SOUmxmyjog8mzxK2N5NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2CcMKVb+b4WzfYKMDq8ECNeEN9+glrpr7PLCmWF5Fc=;
 b=fB7bAKZ5mwjEW9LJjWDPYY1qU9sTxsOp2P6FPuCxlvO3KJrrqkPLOEg6su6sogtBbzD28T/+q8ofGfhmF1mRIVQBtt3b+315xxc+vc428yDbypQlgnO1T07NS4keXGEbjM8jz4QTSvaDveyt/UNXpUwIjbnpnnydiLczkTzs/84sTnLs9RMqRrvA9oSAhf7ksYpCq7Uizn4pG+ypEiVFk7jmDrVZ6znifkc3rTFzfa9Dkn4L0bKVMHuOAQTh+qqJui/a2cPUxqo5tAB3VOkvJY3Z4/CitzH+4Wy3NKHaNSgQ7UzWeX92JXD7xARwocvY4BXGv9oFapJGs2RV/gCLwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2CcMKVb+b4WzfYKMDq8ECNeEN9+glrpr7PLCmWF5Fc=;
 b=a0YH5VNUWwmprNBL8YcgUw0UxyfTTIxUvl4oYN+c76m0hmlwqhIU2JX+l9xy9NCpukFvAiqRnOtFVq0D8hI+FlA0nm32SaPpQTSq/kzAu1WSr4jP4kxqCP8ta11ZsZPxXl0MixBibNDLlSnBL4QTTvE4ml4uxMnnDLDDtgwgE0o=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB4800.namprd10.prod.outlook.com
 (2603:10b6:a03:2da::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 09:16:10 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Fri, 22 May 2026
 09:16:10 +0000
Message-ID: <b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com>
Date: Fri, 22 May 2026 10:16:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-3-yangxingui@huawei.com>
 <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
 <5600f8fa-489a-9b81-9966-dc5d436c462e@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5600f8fa-489a-9b81-9966-dc5d436c462e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB4800:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ec62c8-5654-4063-9925-08deb7e2c32c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	7j1Fp9IR+YkyNLjR8/UMdluHO5uUFHszdNPQeV6xtA4k/UqbKdpNaHmBepLBg0ef0dknPvBQ+eZTBxJen3MUOTgEC/sJe2O03Rot7agJHhKoidXiGpltKLLO6kK0vy++DMAjMGyW3ydDuDQIzSFYfoTnVlxYqdkY13ZN0gorR6SSpfMFiqJbwyUD+7Y4chTFAA0YExGdMvAbKnOdJ4KlBm3SwsxLvBIC1iURcJxhAJQRwyicNxz6ZKsIB2mXJUU+8Dz8SSbKen1RU1+CnFGwUQ3Wxw57f2kfNb43IH9JJGt3Vyjkeo8y/yPJKtgT2T7tlR5ro4AZOZ/rX3xsg+n0PqgIFTHtis2rqjwZHodi2/20OSe2nc86wDEonewgc4ma1/Ngi+rP26uzAPjGasqZrgcMRWjWIA42d0Zcpap2JUyjqSi3SYhhdswni/1c/T5CXc+E7wmt0545zGKZsiGfHERjLlggNGMjbIUBtze6fiq+075fTfAGwvSjyzvSo3LtEtuuX+g1P9w4DVIF+X8MD3J/hXYHBIqnaKdvPqAoiTQNwhlFTf8BZPa8kFNnT0keyGZhDJb5yAyoz7tZx8ISvXksfYESsLNM4eAmyWJ/Uk5ctzpJo/6fHL8upaPJqm2B0QdS4uDPQMiW/lPGLGvBTnjfEgKkOeq9Llf3QhZyQMiEWw03yntegyvLJLS8GJbW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUVwVFJBM2NFc0U0RStVSGplR01TeVpBSEtkNjZQT2s1RHRmazh1YlhlZ1JZ?=
 =?utf-8?B?QWNtNkJNdXI4b1BTblVpMkZLaWZDb2FPR0Q4YmxSeGcvcXBML1VJUjMzRTVi?=
 =?utf-8?B?bTdZSGtsREVCbGs4cE5DK2Irc1cyc3FLc1BhT09UOG4rRkdtdEVmd3lvUmwv?=
 =?utf-8?B?SnBtSE9FbHZmQlh1djYyQTQvc2JCMWFYU2RJYUpqNzVEdnRTR2RWR3dxWVdJ?=
 =?utf-8?B?Y1MxVk45c1k4Wk9iNHhLclYvaGtZOW9NbHdqMEJaMFVXY1liNGdPcGN1djEr?=
 =?utf-8?B?eWRhcWNCekR0elJDNjZXcG5pQnN6TUZmdkNvejY1K3V4R0pieW1RRzRIcTNJ?=
 =?utf-8?B?d0FvNEJ4SThmSU9OVk1OZGxYMGVVby9pVnpwNjM4NDByclVmMnd6NU1SRUdF?=
 =?utf-8?B?RDB3N2Nmak91c1lSV292cTVsTDc0blJUWHAvR2Z1NW9mdHQwT01ndmd4QkI1?=
 =?utf-8?B?d1VkZ0ZSZGxaaGdmZjZOMWNYY3ZWcHVJV2FsMStScHhHT3NBSTFpVHZIU1hF?=
 =?utf-8?B?UjBWYk9HeDltTXBBMklBVGhHa1JWcG9wR1RML1RFYVYrMVBnbmEzTi9KZEF4?=
 =?utf-8?B?bnIweXRWUlNwMXRKOUl2bG5weEdHY085ZDR6dUJqUVRRQU1XUFdYVStQY0tl?=
 =?utf-8?B?aGc2SFk0WXVyaDB6ZmNrd2lLTEREUEdyYjE1ZjF1aGdnbERINjd0M3psZTJs?=
 =?utf-8?B?cExCYUdwc25CVFJmSkFZODcrS05JRFBNbU5RbUduN0NNd0JEaUV0dDNRT3dO?=
 =?utf-8?B?Y2Z0WC9tRnRhWkV6MGRQZCtQWkp1S0NUejFRaEk3b3BSRXFjQVBvaEhxSkJP?=
 =?utf-8?B?Ym0xSEtyODZoQU9JV0ljMnlERllESS9IcGtCS1JyZUcrYSt0N0M0bkEyenly?=
 =?utf-8?B?djFHMXJ4dlJ3QnpPSGU4SllSekh2aDRwcmJ4NTZCYjZtZ1FsbEFIY200VFlm?=
 =?utf-8?B?aVBVTTBIM3Z3MVRjSVdiNUVPWnRSUWRaQU1UaFhPMTJ1bU40VTJ3Z29qeVJK?=
 =?utf-8?B?RGY5OVlXaDV6YlM3NVkzYVk2SXdCOWQ4a2ltbGhxWlNiS1dpZUFDNm4xM0Jj?=
 =?utf-8?B?NndPdWtlb0VKa1hURURoK3pTSkU4L1ZMSXJwandOalUrS3loQ3lkekl2cWtm?=
 =?utf-8?B?dW5NL08vMVIrbzg1SmhQeUIwM0daK09IVWhNK1BnOWhWalIyMVpuOE9jcUJU?=
 =?utf-8?B?UUIzOVJ6c2E4ZDhSL2loK0NIWWZXdkVEQ1BaN3hrMGFVZDFLUWZmbUZObGpj?=
 =?utf-8?B?dlhMWlZuVzFkTHVJa1crK1Z1bzVKUGIxZmhJRklCandBbnl1Q1hDUVE5YzBP?=
 =?utf-8?B?Smdlb016Q3R0TXF1VEVDeWVoOWRRK0l2UmdNK3RhaVVhNXNuRVcrTzNHWTJ4?=
 =?utf-8?B?N21Udm13bnUwQXg1YlJQb2xCYS9GUGJyQTJ4eHVuRUc1Qy9adzIwQlJBZzdU?=
 =?utf-8?B?OFFqY25XblpvWnMvbm9KOUdIS3ZicmhBQVZaWkJxdTdpc1EwYU5BY2lGem1N?=
 =?utf-8?B?bGZKRkJhMnMyekR3eWFZc01IaUdiamRqQzVTVldha200RzhIcE9jL0dJVVBh?=
 =?utf-8?B?K1Y0aUxITTF4SzVUMU1BVEdOLzNXT0VESVNsaVFMZHhMUCtwbzJqRWVGL0Z4?=
 =?utf-8?B?cS8va005YkdGOVlpcVZSd2QwZ0QzUVV5Si91NnJqeW5TZkpKdXgwbVBrZnNF?=
 =?utf-8?B?RXNNckZiTlhHNTdKbTkvMHcxZmQ5bGlIQUowalFoenBhbGJrbFJpcEdjOTZ0?=
 =?utf-8?B?V0Y3NTlZTGQ2Yk9FajNMTVRlK2ZwQXJVOTdIbmNFUnduVDhYb1lLb1ErbHpG?=
 =?utf-8?B?cWZPY29DN1dJUyttOHViODhkeU1YY3JoR1ByS05rMlNzakpuSTdHdHdjUVhh?=
 =?utf-8?B?L2JpWFFIL1JTbVROVEdvcDY2aGVsbk9oVzF6LzRVUzdGMmo1SjNuQVk3S3Uv?=
 =?utf-8?B?S25Ecm14SVR6Y3AzaHB4VzhwOTAxd3FkeGpxTVpuVkFScHZmOStqdDB2cFlC?=
 =?utf-8?B?dTNERHFwWnBjTjVGS3JseFluanBCbEdwT2xQMmJ5UUlrQkJKKzJXWE44WGtq?=
 =?utf-8?B?M052dnZjeUo5M2dLdmhrNzJTbkJqUWFhVXVlTXhFRldFMUpKUmY0MVlGK08r?=
 =?utf-8?B?TlprOUcyalljRE5qZ2dnRXZ2aS9IZWNHRHJvcm1ycSswR1AxallEcHB5aTVi?=
 =?utf-8?B?NjFqREQvVkhKb25ONTZWQjhQSVNXUmU1OUxxRVVBTEdxZVYzN1Z5a3RGUTJr?=
 =?utf-8?B?NHBDTWV0dzNvdGlvL0Q2TGtkVkpJZmduMkdYNkVyTDFxNUVuV1F6WStMWXcx?=
 =?utf-8?B?NFdTT3ZWZllkd0p0VDRhVmgxRm14dWFEL25CdGJUUVFkWDdYMm9mQT09?=
X-Exchange-RoutingPolicyChecked:
	gC7Wa19hbsVcsaH2y7Ue8LD7etnGXWb4hGJyi8UKBnifN2xoonEV7kUYwZ5RaTkHzFIjHCYy3Im/haIMGezV4DRiwHjNTyST7H9PXeMQvEGnXPw5RAF+OsuTy4XUunQupAtlVW4NwZRDgV2aWs/9XyI6TLMcB/XUi8dnwA91MemhByRI62v+r7Gczkh0dWn6nwL6oAY1jhmbJFje/ydDziImsODZ3/iz8+AEmx/CdAmTLiBkddwUUqnS5C7Zc/Py4XTh6mlkKsvoAaL7d8ssFY4xK73gbkmvtvSFHBTlUBse0ptwBy3Rb8Sp4AIpiXLv75fh/rHvBAWim9Olxz5RyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Om/G1SPl9VUh7NfSgiWO083yjDM+WjUkxuPdI67g/yCpXic7dk9CGxQQz1Z26pw364wa3latGTctjvGPTazbp4ylCWWLLeFs/gistMvr+1AliSXZfStLEfEe7rSvMdpP9fK/1rT9Xznfwl6d3nIEhnkpvqLmbpoG8Cg2t97NGE+9rlmdPkc4mMegZN36JD6ichYmKVI+F3Sawv6vcJonCfz+MAyxxd5VjLrU8/rUbEk0UrfjGCYnDwdHnPYPsoBBwkrdF4N8Amiy6lhjzUSe2bNnkRU9QJcIBHcSQrNPPoWxP6mgESm77vNf/fb11Io82N+rUE/ygO67VeEyZ3wr1mZ4EgaBDoiWUDSkM42NZ8FwqG+CxMVmoo20G4O3mN1wEF9U4ORlLqtMveAK5t6Bft5C8d+pBKoDd3qkM5kpawk0COtkeVPUVb6M1zbsCnW1Y2xoa4B51RN2nhi9yZUWZV5p3+SbYIflHC4FJOe8FITgoyd9jcnZWPZFKMlnxVlezKfoIN1FZb2EJv+2V/Axnl6DVLYpLnT687wRE2nqGeK2f+8nrGCACtEOABjtetJgDJr8Okm4f9aYUqf6KwCTMHYdpnT/0Eckgd9iQ4e9uI0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ec62c8-5654-4063-9925-08deb7e2c32c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 09:16:10.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPSvl3735aWz2v9w2ioJSx/c8tQi70q9bxMEJsJJC/V3kUxzBc3smUV3u/gFSt+ZQ1WarUhszTCVwOZMiPGGiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605220090
X-Proofpoint-GUID: ottnb_dew-97XxWHZeOIYJ-1HqHjlBCt
X-Authority-Analysis: v=2.4 cv=d9jFDxjE c=1 sm=1 tr=0 ts=6a101edd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=zib2IX_x_s7Pj61jrhAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13839
X-Proofpoint-ORIG-GUID: ottnb_dew-97XxWHZeOIYJ-1HqHjlBCt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDA5MSBTYWx0ZWRfX2y5Kt2ocVYGo
 I5Iihx9/cLYS7QyvTe4z9KtdrozDLEmksc1R3NdrMR83Y/0dd26Bg2Nrz0Pzie68DROzIVaMLtd
 5tcR6uKMNNQS088C40jUhfl4XeWeyPuUbPx+/U31WFKmWeZsP6ZfvAZw84iq3avT3r74NSPvL1m
 MSyJ14Qk4l77HRv2iG5l+z2AutccqEn8Omy7kAzLD9D6c1HwKjzI84EjIGHYhWKoGRBzzEPuMrr
 qzKLnt4v5Rbm/LhlhAR+Zk3JvPOln+m3/chOGkZoa7O20JGOQPBKQoHTxLc1HX9HOWzlSJD9Asp
 WVnUtE4XYao1IBo1FXDIvLLg6mREL9hssLSzsPlrM/ahDA6rKqITHC6vbjis2+GnkNOf5DSF9Gx
 kgrblN8wKiGUvfK1LqEFhRAtUuIQE+bf9liGL0B760uCXMme5Ly/wZ9HhiXf1ot1ZawFeBbsLBX
 mZqNRySlTcREuihsvn9i2yiBvfZDzPKppx35BNL0=

On 21/05/2026 10:04, yangxingui wrote:
>>
>> Can this be reused (to lose and find the device with updated info)? Or 
>> why not good enough?
>>
>> I don't know why you need full revalidation.
> 
> Hi, John
> As the commit log. The existing pattern (unregister + sas_discover_new) 
> handles the "replace" case where the SAS address changes completely, 
> implying a different device.
> For the flutter case where we detect linkrate/sas_addr changes,

Can you please clarify this: you say that the existing pattern handles 
"replace" case where the SAS address changes completely, and then 
flutter case covers sas_addr changes.

What is the difference in the SAS address changes between the two cases?


  we
> cannot reuse this synchronous pattern because:
> sas_unregister_devs_sas_addr() only marks the device as gone (sets 
> SAS_DEV_GONE) and adds it to port->destroy_list. The actual sysfs 
> cleanup (sas_rphy_delete) happens later in sas_destruct_devices() called 
> at the end of sas_revalidate_domain() in sas_discover.c.
> I did try the approach you suggested (unregister + sas_discover_new), 
> but it produces sysfs duplicate directory errors:
> Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
> Call trace:
>   dump_backtrace+0x0/0x18c
>   show_stack+0x14/0x1c
>   dump_stack+0x88/0xac
>   sysfs_warn_dup+0x64/0x7c
>   sysfs_create_dir_ns+0x90/0xa0
>   kobject_add_internal+0xa0/0x284
>   kobject_add+0xb8/0x11c
>   device_add+0xe8/0x598
>   sas_port_add+0x24/0x50
>   sas_ex_discover_devices+0xb10/0xc30
> 
> The async pattern with DISCE_REVALIDATE_DOMAIN ensures proper ordering:
> 1. Old device added to destroy_list
> 2. Current revalidate work completes → sas_destruct_devices() truly 
> deletes old device's sysfs
> 3. New DISCE_REVALIDATE_DOMAIN event triggers → discovery starts with 
> clean sysfs state
> This follows libsas's async design pattern similar to sas_resume_devices 
> in sas_port.c.

