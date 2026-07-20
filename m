Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842EA3D524F;
	Mon, 20 Jul 2026 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540898; cv=fail; b=VUoGbQ+s2QOTQ7ZPRymW30AcJZLOY6Kebs+rC658JzhDEimrA5pOm/K+zex+13xFc10MDYcj4rOfms/+nhUWGM1Mhy2vhjiYiM8zWsxEn/nk2snKbz+52v5U8v1ZuUT8GG4r3ECon8fM9tFNm+AFdtaaLC78OPXEAlRPXwKAOR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540898; c=relaxed/simple;
	bh=HpGyt8JT3ovwyVmcSAww99c2SJKgy2fWYcQU+2z0H5E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hO8Da1GJ+Rw/pV9yuWTOFWODs4QCtqm25odOliGiVxtLCdlXFWIiHPuoBiK/+g9PqBvKsb2c+mvv5avJW9fRSNE0SrTW02/qD2CUqh7qRNsV7+iPoRQNMbHJjO6jYUw+X3Vx8ATDbcCpY/yiTqHOGItSSda9aXWCj8yDu2pu6F8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zy0sWokU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Uu08GGub; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zy0sWokU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Uu08GGub"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K3N63N896873;
	Mon, 20 Jul 2026 09:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0Lch0mOBKXkMcuzhsSxQU9WgVs0XCmdaUEqbEmAWc9Q=; b=
	Zy0sWokUMOawLNkt5UC5dwEa92ysQO/x5OsL0wvMu/Qo6NU0LwWwOoegwn0rd/jU
	5ldtRolk4Shi7e8JklXyAzf3HkUuQvrnRr5+VGBogm13T8ANZwqPGcLb4OjHjaOd
	ZsLqJNg7fHndLKDEZkuL9B0bjqgC1AVa2TU9y+Wt+VB3UGDgqBTbwoeGADqROqQL
	agoy34mD3JWFONRx3DezCgL0L7zXj7rQ3eSNcAWa3WA8cYKHOTXoA6MPK7XPuFS8
	tZKxhXL1Bq/m+AagGGvRfRDr/L7ESPG8k/RhJTGMYLd9h0oNP8pZVNO652X+503g
	VZJt+e79I24hktOEKraq3g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q1js2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jul 2026 09:48:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66K9lxkg020198;
	Mon, 20 Jul 2026 09:48:04 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010019.outbound.protection.outlook.com [52.101.201.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxb0hek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 20 Jul 2026 09:48:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q0PW5k7jd7wczTaO1bqfPIrjl5grKUUboq5xGXkMQmuRfC291vvmKT3SDpYGQ0MI+q/Tq+97VgGndymAv2FDGCVAJqdysbqBu1m970NGHynAlHHKUtlihVPsevUSDKHFal9f/A/2dMT38XErJQI6SQR9yrS78q4YlKxN/Zqdr4QR8+WzOAII3BU11WJROSUxcttyIKmMFdLgu1+r26Klv/faV3rJliXogo3AY1lRfR6PmuZiGA6jIYWxDpa4dyeOEPcratcLYUYNFYoK2wRlIjGXDKE/jxh0afGWN9etGikpPOCPUEDvg+HBQ84/WHZjczCTMW17f6Fji7sxmuhr1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Lch0mOBKXkMcuzhsSxQU9WgVs0XCmdaUEqbEmAWc9Q=;
 b=HNdm0eTV3PK1uLxPHbYjBLjwy4r9hnqasN6aq4+mpO1TNFkR2PH0Pc893qiyb2mQY299vXiVPqIrP579li+xJR+WpUZUG90/07IA8BpYh9gpoZYx0WXxlmeQt7Q1fdB9vtYfN7CD+rEvUarXiH7y99JOJzMPDTymPo8B3DHD1nXT7IQPaG3I9lXUraiFP5765yBJBftFnrrl+RtNzRVB1tei4Izcg0kVA+Ty9Ji7W5d266UnBVXf5hA/gHwKeUXOgaivgWcRH0uCT+B8w4Dzo52aJxEJS8ZwhJVNy7d7AXsGIsbea+js+gh2IvMmVWPaPhUYZrizOAx7y9ZV20m7Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Lch0mOBKXkMcuzhsSxQU9WgVs0XCmdaUEqbEmAWc9Q=;
 b=Uu08GGub6WCZ3fCHYr9UdmAXw4xYg9IXR025RVnd/Wu8YsgBh2obG0q8pCfR/UuIM3ebTJKJFfxAgXxJuw8s+AhZCnvHBqhZAjushgpfS9zMaFgGOPcobWK7oX2dRHdh4hu/UknGy+P0lLF89g/uF6FlxELOfLY4rIbScRWYm9I=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 09:47:58 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:47:58 +0000
Message-ID: <c9a91dd7-b158-4416-93bb-9ae1e1acb8a3@oracle.com>
Date: Mon, 20 Jul 2026 10:47:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
To: Xingui Yang <yangxingui@huawei.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, dlemoal@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        hare@suse.com
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-3-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703022833.36847-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0082.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f4d53d-602d-4637-58a9-08dee643fa44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|3023799007|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Z+NBL6oHE7gG9lHA84B0i3nn5mgT3Z5GzO2Zd35K84ViRBox0FVh1o5ZPDKCySOjIiG1VBWKXR5VWlfjIVwhLhEQF0YEz0kFFwPuoenOXFYko+7VnqSety8TZb9e69BFeJEY/Fifu4qGmMpl1cEqvccjoBDSVOUyCLpOhF25HIrAo/mZWib9ZiG9gQSpjCO9bRfJRkGhrJwnGEuNPVs/VfPV5fDsP5eXlN9xUTRS4t8rS3N3ScYquziaURTMiU88/0qLkeTzDLFi0Lsi0IYroSFsRUR5tSBCa2TnW5sI2vLVrIEdrb0cD/JpmWJxNouXwF93Srv5Ex3evYeuWAhQt4z3+3JEgIbyw7xs9rgHynvb5wvE2zqfULeEL4VMR9q6cxwaEIJ0umPMP4OkHb+ZRzSV78nn4bxJa0X8+BxXsVMvZSY+uqbDyKv7NYfFteULStorLVLQ5bpA8VyJ1kXQSpnPfzurAv1vp+5vLVO1t4DpguBwNqDe7C08Xj/LokgpVfcL/UlFomVY0fV3zUhVe6oclfHEuFsZQoQ+ZCAwLgpR+nEtnBvYbAg0qqkg8uHzr3gDf0VQZOE7tpQZMdSztSPMZG5G092Z1JR85SfotkIozxFlA1pmzvCCvq6eEs2HEbvul7piCsHeNC3BbhFXqOC3SFuPpJ8uYawGCNIJ8rY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(3023799007)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGlNYmU5ZjhNVkZNb3dFZjNYblZ5aDJxTVB0RkhYYUF0UVNnMW5pRmRQMTZi?=
 =?utf-8?B?djd5R2ROeWxicTljZU82WTBLNC9Wai9CNzB5WmdGbW01ZStMY011Qkdmbi8z?=
 =?utf-8?B?eGg4SUZ4aSt5Q1hhN2RmVlVJS2tVSjB6SmQ0U0NhdG9yWDhOd3kxK0tzMDFn?=
 =?utf-8?B?UXFmSXhRSWZXVFRkREpvNDMvK0gzQXo4SGY0bThuUmFUdTIrell2eksyRjB1?=
 =?utf-8?B?UFJZWFdzYzNnNWxENGdtcnpwZlNIVkQ1cU9vSnJpSFdVWUxQRE02SlhPTEVR?=
 =?utf-8?B?bFl6cnBwODdlTUdGVDFPMU9pQ1ZoeUpZcG9HaDZsV1FhWCs1b1RoRndscU1u?=
 =?utf-8?B?czdSVmx1bW5Cblk0cmF2SFlEUnVpN1ltS2tCbG83Z0VmSFN0MVFPNjNJcHFj?=
 =?utf-8?B?MDM5cTBwQ2NweCtiQkw4MGVWTWV4UkNxV1NwUk9lTzRoQVlXdUZwQTBrNmdj?=
 =?utf-8?B?TURRSTVkQ2ExVkJtMnZ5QjFRS1NOMkcxTHB5eHBMc2ZaWG93ZHp1RlVhVXZo?=
 =?utf-8?B?TWZnRW9BMjBUQmx3MWVQVnZqY1VQdGpWRjFWZnF6MS9qZCtQMllZTThMMlR6?=
 =?utf-8?B?eGpoY21pYkJTSHVWWmd1ZUZvTXJiVUFTVGJBd2ppb3Jnb1ByNTh2emJqNzNC?=
 =?utf-8?B?UUM1VGkxSWtqSmo4TW5vUjVtRHpWVVFPS3Y2SzVJRlYxWmY0eFFzUk1wOW0w?=
 =?utf-8?B?ZjczZUtGdTltYUNPMjIyTWR2azRnaTVWREI5TzlrQjYyc2svQjVldVdyZWhQ?=
 =?utf-8?B?NkliSTVTeEdhR2pHUXowOFZZMVlJTmVmb05ydU80eWFBNGtYRXRHeWQwZkhr?=
 =?utf-8?B?a3dLRXp6WXlRUm95aTkwd1R5SzBFNVZhSUFPWlhNcytyY0FlYUZwZzNyYUtD?=
 =?utf-8?B?dFdyVm5EZFErL3RTaGV3Q2VYRnBXS3U4bjlQai93czB0OGZpR1JXSzJHVzAv?=
 =?utf-8?B?M0FVRFZ5TEFJVjNxNjJvR3pjd3paTW5vTzRuZHlCZGNrQnNROFZ2WXd4NkJv?=
 =?utf-8?B?ZitZZnk4NzdPTVZPRWF1YlFmbVI4SFZmNUxjYXZKbmNPRXFVdWxOd0Q5Vjl5?=
 =?utf-8?B?ZmlXQVlxWHlYNVlBZHNVVmhRbVBDSkhHM2FCdUxvYituc2kzQmY2RUE5U2E4?=
 =?utf-8?B?SDFrOTdBUlFRd01nTE5BczRXVnVyY05YL2hub01jV0Z0OVdmelJ3UC9rSHdC?=
 =?utf-8?B?clhta1l2azhWSTVQMDU4RkZKU0JlL2dsQks1N3VLT0xvNGhIUEJabDFqRXZR?=
 =?utf-8?B?WXlpa0I5SGtQdGJ3U0RnZy9MWVBhTU40YU9RVHFYb3NUd244MlcrQlpYMG1O?=
 =?utf-8?B?RUNZY3d1ZDNLd1c3ejVhRzhYaGYrRm9sZkd6VWNHTHBOSXRMZ1JZUWlkUzkr?=
 =?utf-8?B?cFBMT2dmZ1VTQ1hTKzRIWHQ5T1pXSW83NEp0K2o3VnJ6aWdGTm9yTDFoTlhC?=
 =?utf-8?B?b3VSellOb1kzaFcvYkx5dFZTTldNKzJIN2NZcjJZV2ZnSVRrVHBFZTZlMnI5?=
 =?utf-8?B?K3lsNFpEVkQxVXVFcE44VFdhbnIzQjN0MndQUnNPWTFnV1YwQk5UbndNOVhS?=
 =?utf-8?B?elN2NlNtRVpEeTh4TjVpZy9ybmFyRjZ5MUNYajg2STlOMVRMUExXMUk1eHZR?=
 =?utf-8?B?c1VZeTZmNkk3ak1CclBNZW1RbzJJYmVaaUlHNlpvS3drQjFCMnJmc0JYZXU3?=
 =?utf-8?B?ZDV4QkZsRUNQdWJCWGNoYXdPWjQvaFhGTVhMU3ZYU2JNdjI4Q1lWa1B1Z2dy?=
 =?utf-8?B?SCtZS2dLblU1bEFuRGc3d3hLTGE1VUlWTTcrVW5UeU1wNkx0aHVBTUxZYzc0?=
 =?utf-8?B?TUROakpQMG9RaS9ETDg5eHdwVXM3VjdycEJWTGJWWlcrZjhhQU9CUWRGRGF5?=
 =?utf-8?B?WE1lWFViNVp3M1pqcjVOL1VQTGY1dVdraFlSZmNnVUVFZW1xMHVvZXk2ZW9v?=
 =?utf-8?B?LzAyYWRneTFPbnFBYlFCcTNkOEN5ZytBM3dQSERmMDlUYmUxeURPR3Q0TlVT?=
 =?utf-8?B?RFJuTzRkM3FtK1FIMEN0bFVvbjRoNUM5UDR5TDN6WEJQd1NBUGg0YkwvdUQz?=
 =?utf-8?B?RDRXbDc5RXlKK1lyVG1QV2tzcGJTQWhZeldwejBkQVYxVjB2OXpGZFRGbUhI?=
 =?utf-8?B?d1cvK1U5RlJnUXlqTnF2dzZkbmtQQ3ZDRVlPR0F2S25RSTRBN3ozT090MVVh?=
 =?utf-8?B?RmdFcjZHdkV3NzVuMHB2ak5KRit5MC9QNmRRTHIrS2MwdVRJL1VaajY3UldV?=
 =?utf-8?B?VHdaaDRGNjl6ZTg2UXc1WHhlWUFXVHpJMkJPTWpFM3UwL2NnWGpkQ3JXNlZV?=
 =?utf-8?B?ZnNrbWZEdzBPYnZhYzFyT05YTkpmUjVZd3dUamd5cE9PN1FSN2thZz09?=
X-Exchange-RoutingPolicyChecked:
	gIn0KBAt8/Lvj7YiOG+2qJwa7iC1iwwG+lBFHt9UirpZO3M5OjiwIeHpld4PvFaXy/pkWAdehR9PC0bPRsz9t6uCL3tMBV/20GiXvZx/DqLKCDqpp7vE8Cabj3K7SQ6NQMma1A8BpAk5Cea2Q52GgPl1kJr0ohHDF3VNperdNXiCqeehkiZRhIE0oPH+2NBplAHWSmliYniKnh3GRyqD10c2ItAt/RAIgC+GTP2Pf7mL704vngkCtv4odNfwvMp5w3sXQvY3HR90ir4whf8oTodOcst25n2ahtIwO4TCjfuHt0oUyGsuF60R0eHR2FmDEioKXdGJjBYYVJURpFQ1Ow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vfIfK3klw1ApwmxVA7+lO0vtjERlMwUjn2FSWcpSZqLebUkTiA0GDDbZ+D1rHUZGu+Vm06lAKm7DXGCwI/tYjWaAPs+u3wMmwKwPu32oTOs5WP/QSOlQ7aVcTWwQMQm1DDzq9RCFs1z4j8y1sUHyqRuLiR1R89dHZsv48tV/5Z8DCoSyd9rlsG+dhm82hXKHo1I72hHHS73iGTnXb/gZiNiPpENj8gb/WoSsGHsKGPqZexxKDVb/yxomNMCPMv6Ho1qmcruyzUstmY3whXlMijM/O8phu/sFFecmMtaQCuLn/Yf5iWDIjHsKL/8oOmTHG1v9aoru/2YTF6nVw6xLTGTMFnoV0e2QOkrmeX0+QJVuDKfaM9pRwJsFbVQnPNOwJpNTizwErexdqWVmyQ44G99zhijo0YmI9YgM7mXCJzBD4xcuuzpY2QoCCNOTV1OudLCvdT//tkyOwBvz33p0NW0t/mtTOB7z4AglmtNrBfrH+X/Y1OxYeQHrxQFTriiq2YMWkC4fxgcvFODKYipoS3a1IhMQZMNmNxF0rJn949fJl4tPL1sIpKBJNs9XrjRn1Q3X4F2sQ9KQANFpAK6CGQ/j9MbR8gCsUcckOmb0Bfg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f4d53d-602d-4637-58a9-08dee643fa44
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 09:47:57.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDtckV/BfKc3Cfg7ve1qDzAxJ4Yzm9Hbo0oUgWDkBWlpCQjQ3b3UvWfzqceI2Vzsioc6emUwtyGR8FKH2eg5Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607200109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDEwOSBTYWx0ZWRfXzgdLdvpXJ7zP
 ao7V0NkG3kkQ27ciHMFjFyG6NQczXw1edNI6Y8n2bw8rff4ar7jFGXKRFj1CtIqjKxiNO9KpRKU
 hJJDMVa66i73f5t8nDLBRkpeEJxmsN12eu2+qrZx8hVycSjwECPeZNwQqZhuSxhkTcmJmgTAOC+
 GB/1dWiZPwp8QiobB1O0RhpbT1K1knT4O5JOGkeMvIZOU5iq2pL3hzb28PBkcyu1SaYIxFETaec
 /JlfWEV5CtrBfEKtFdQSkZaSXR3MUaz3YWHKx8dGJx1GFYAxRAR173ahYnqUYfONG0c8HMS1SRp
 iZEzhKcRI0SM84TBmyV3qjOMaWLg64MzqipTb9rFAia2BZGGpMcchu9Wt8FKR0BHMbv4z2oWrWo
 3YD345hTEv66yw/6A4TLaNM+UmAO8x3S2MGs69J7QQOAlM4tYP+3C44fj3tOE5/Y6rZfqnX3Onl
 zXhaeQFfV8UMtKjFwiA==
X-Proofpoint-GUID: xQSzW7PUPyLHckz38RdNKp4aL22HaNCX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDEwOSBTYWx0ZWRfX+omoxlG8+Tgc
 oH32o9IgupJ0kmeHqlA4/ncujednNvCfaMOwyoeSFMlwAc2mmODV9jSo+uJwBvUqfpV3Nr+t/9f
 JyQ6V3Y/s/BU4oaO1dvgKmDCyX+xWrfyK7qQIk7Pf3E56FJvY3LQ
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a5deed4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=Wrf1t0TAlmzwoxz0vgAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xQSzW7PUPyLHckz38RdNKp4aL22HaNCX

+

>   
> +void hisi_sas_spinup_notify(struct scsi_device *sdev)
> +{
> +	struct domain_device *dev = sdev_to_domain_dev(sdev);
> +	struct sas_ha_struct *sha;
> +	struct hisi_hba *hisi_hba;
> +	struct sas_phy *local_phy;
> +	struct hisi_sas_phy *phy;
> +
> +	if (dev->parent && dev_is_expander(dev->parent->dev_type))
> +		return;
> +
> +	sha = SHOST_TO_SAS_HA(sdev->host);
> +	hisi_hba = sha->lldd_ha;
> +
> +	local_phy = sas_get_local_phy(dev);
> +	phy = &hisi_hba->phy[local_phy->number];
> +	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SSP)
> +		hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY);
> +	sas_put_local_phy(local_phy);
> +}
> +EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
This could go in libsas
