Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D78D3D3314;
	Fri,  3 Jul 2026 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783090222; cv=fail; b=eRtA8RCvHWUeGEt3EMQIzSqs7K5ufHQ5flTOVMZMZ2N/joTvlg+AAAgXgsLobPNFXuH4ldUQA8LyWLPYzqZiLcNL01KVP5dXEAAsG3cnPPtkvGF2uljQesvSdXACmg2A9FyNHkYnJI/5o3w+SQkA6VdMCCNbkgL6QrAAcjafjo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783090222; c=relaxed/simple;
	bh=Yrgvp8fBLlmjHBDq/DgI06KYpO1uiZaDv1QVyEkFD1k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T1ZyJ+U0JIj6PBXCiQZ11FoSlqSmzS20j3+bMMvg8lUwlNBHy82PcF4e4mNC6ha1C4xbv1SMbSJAq9TvIPk1PsZAQf4blq9d/gJ/aP153oRHVIiPSu3NWUmyjM8LpRujhHAP1HchD/LNThQb1NJEERxiPg3OvZgy0ytFbKPfsQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F+qJiQUJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OqIHfSnY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F+qJiQUJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OqIHfSnY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663EdABc3627556;
	Fri, 3 Jul 2026 14:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gSEmU0lRx0Q3IjKjnf2OuiclxwFM9BaGLQ39rq+qRJY=; b=
	F+qJiQUJ4Qi9t03m2Od4ZjW63mR6tN3N8wqwdwY6/XTLqsgY2Vy8wqMdV0h8Cl6T
	8hcBfdg7OCx3LEyG9rJizSszdBZ2QOIOtszpSoP5/HHdvpcIGM/gGIAJYhwRvWGK
	CxrS4x/fmuvkXqP8CgYfSoN2Sl+uNaV8dq0ARIDQ5Z8CV7vKvB1f645+b9qrrJxx
	cEYlbbxpo9JDDw9AOKOKZ1VKWMstRn5Qc8Fk7CZtPCiVTvpsVsZ5l8ggnvoI5YAx
	GZXL7amX4HsC9+cKIHhew5gNTaeFngWejJU3liqGzyZNYHQpfBFJd21/SBvDgvgk
	vIH58ri0w4lbicFnPf8OEw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qty5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:50:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663EmYfg021373;
	Fri, 3 Jul 2026 14:50:19 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yuh5v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:50:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oKmA7Hl0cKlcdQO6ByCFmjAI+udGbl5A9qKVAGOrRwDjjTIh+xQBEy6N4qedLEhACrAW1n/STXZUC1DeE069rRH3F3Y+3Uola2Q8b/dZzu/HSHaf3YwF+iTxWaiK8xY8fyczqMz4ra+AcesD4y8nXmQd4nmanwW5QHjJLhQF7p6pdIqhjL1HQj7oqBi3CgfutVptbpvddfQlPgId11+Ndrighkg0Eu7q70JQsJBkQtDdFahRH+Y00QUEi6BQoziMGaplXpnQQzc119T+FwRGquZ346KOeSMqK+HW0yU+99NzffJvseDKyd7I6vAggtgslktc4fZTp3Teb6yk6bzNvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSEmU0lRx0Q3IjKjnf2OuiclxwFM9BaGLQ39rq+qRJY=;
 b=ImxeENR1jn1PCT2M+dbLkPKnRq+zE+pQNp+c8lmKxjCEb+Ow0/COUIA4D/Jda1xsUNp4oE/dJuTBSgPY0Am4AxFnGiQRk35NVZXNraTq8zGf8oOmfbfYABdXccW6rU61abzZa93CB44gRgRQ2NqmA2hwvz9BJTEYO3NrJxBiR4jopw/YlhYpnl8k9UnORtTkGu+F+bA0eDzlHaxWLKbSoiOa5YPgL93z0RNEmgVIZQDlw1tlgH553pAeYY4UJOlB18kx5MSFFVBhEyS9i46fcpNgHwPzfsbIZ8RMMeietot9LjKsNVzc9gx33bBC23xikaThfO2G6bsn2LKIhIvKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSEmU0lRx0Q3IjKjnf2OuiclxwFM9BaGLQ39rq+qRJY=;
 b=OqIHfSnY39tZqhR3Zf/RpcC4MzXMZs4aKwF0HSS58vlyg0A5AvUHT6VXiafRf6c8pKB4cjJDpPksOTOKEVoMba7Hwql52L+pZeHYiUF63wiJvXkuNZIerigCEnIrFZl47jUqQWOwWVzpEIofh6sfzkKlHu4Z6rN3E6TUJXDCNPk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LV0PR10MB997615.namprd10.prod.outlook.com (2603:10b6:408:340::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 14:50:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 14:50:16 +0000
Message-ID: <893346f0-3f9a-4ad0-ac70-b7dc26aa5093@oracle.com>
Date: Fri, 3 Jul 2026 15:50:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] nvme-multipath: add nvme_mpath_synchronize()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-8-john.g.garry@oracle.com>
 <20260703112413.083E51F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703112413.083E51F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0363.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LV0PR10MB997615:EE_
X-MS-Office365-Filtering-Correlation-Id: 9320fffc-46b1-4f75-143f-08ded91264f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	ZDRREWcSZ7/YWKe5IRryRoJah5oCv+P3O4b/9w1pG+7aQAIbzD0iundOoraTwpmcWOI0E+hOSaFUSOp+DXWPQRpVJXvleYlQ/ojPXePnuXNHNYA/qIucyyGAdP0hE9WYjahHAZ6zAuHfhiY8G3nxWYAcXF1QKAN3Lb8G4dtKcPuuyxAo9zw2taKLr+93n0nT/TCRfaIkct6dpWpz/BHtuCjkkvoIeTBsLZ2QglWw0IO/h10dZcDR8Q1cbkwz3e0YryqC6DU23tKNZ08gD0dwmJni7wzBsQKOs/CEsism/pYo07pDfpN5Dfr/QH4fusqskutiXyVxmy9nth2LYtv58TaydL954dNqXj5xLl0A2AaG5pY9w6JuyLSHzuBWCeWVRgOdTawHMNC9gPbz8yRpEsq3w3T8SGBN201jjCzBCTKsBtkqEAJOxOnizqtb9NVjiVacEP3T3P1SzBRvuY4fOCjYUquGFPsv1f8kk8Q/wMTTxFXfrOuaQCBG29Me0ks4pz13IZiJ2gz/elJcbhOCUEHcQ2vbos/eKa/TWEEyCsN84oBYdootXw5/9es18ichFh+c+rAzSU7kgMSae6pqWMXpqX8pMlKNucQe4FmB8Q2iNyV8gFwL1Ar3xr7kKYraYnggzAFc6/uoxIEJGUSTKaCgWMqNm9k4UVcHnWztaxo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2RtQ3pHYkdwQ0F5U3RUWDYrSWNDVnFaM0tQZGdITHE5UFo5dUk3bDhEUlkv?=
 =?utf-8?B?eDVtQ3pPSFlxcE5OT1lYY3FmL3RDUHhyQ2h1eG1SSEpFb3hNV3BNU01VR0da?=
 =?utf-8?B?REdWSzJFOTd0RjVoK3hoUmtWK0J0SjRSVXBJWm81YXptRVBvR3E5dWNvNGFP?=
 =?utf-8?B?R0N4RGFVd2tLY1FQUSs4ZERDS1BlbjlzSlpwUkttUGdGSHFMK3I1eGhjY2hv?=
 =?utf-8?B?RkZjc25GdzZlNG1jeHNUK2F6SVpCZURJMlJWaHhTdHVKS2lQWW5FR05wdFBw?=
 =?utf-8?B?MEtJejQzQ0VpaXpIalVzTWxZTVlsTjY5RHZoQStTaTExV05JbVV0RGFCb1F3?=
 =?utf-8?B?S0MvV1NFRi94K3NFcFRRK3dld0xhVnVTbll0YWppVHh6MW1kcm05QzdhRDRr?=
 =?utf-8?B?ZEpqQ3ljOWtML3ZkTkN3VDAvaCtEaFUvUmQyb2U4ZGhhKzhQcElQc3hmVk8z?=
 =?utf-8?B?UFlkdDh1b3hsbzBoK3hRbllROHZJdTJiY3lPd2JmeTlkTDZMKytwbEFHdUtE?=
 =?utf-8?B?SlVOVngrVzFiR2I4bnRhMnZTcFdHZ3JLVUlPd01Na3RVVTQ5eHlvNVZJNFk0?=
 =?utf-8?B?V01hOVBRMEx5M2RwRWdWejJldzROUFZBRUJFYnBmRGw4N3BBN0Y1cUtkQ0dr?=
 =?utf-8?B?YVR2Ly9na1Q4T2pjVnM0UnhhNnJ5S3pmbks5b29WTkFmYVdmOHpwaGVJdlRC?=
 =?utf-8?B?SndNTW91QTJzcDNXQU5jekptenZjd1hBcW1CV1ROU1kxMExVZVhzRERUQ1FJ?=
 =?utf-8?B?UGFTUVVGUmR3Ym8rK1RpbllFOUZ5TC9SQ2tGeHRxT1hxNHVXTE00Ky9McWpS?=
 =?utf-8?B?aGRqTGNMNmVvc2FWb1BVOWJveFNnQ1pKRmVWUjRhMWFMZGpRVlBzdzhWTE1u?=
 =?utf-8?B?TThSSVRsWG85VVJIWVhpaThRYmpnYXVrY0hBN29oWjMzT1hVNmFXb2lVdDRz?=
 =?utf-8?B?S2dQVlZzWWp0d3VJQWE3SzBNTURrK3FjcnZYbWQ1L2xaTXJMeWZrSVRaVlVo?=
 =?utf-8?B?bCtZMEo4SExERGpmRVBQek9RS2lPSDhCZGViaXlKYkFIbjM0eWhxd256anlD?=
 =?utf-8?B?d21vL1BMOTFoZ0VSQlZ2SjZMb2Fya20ybWdSL3grQ2x5RC9CME5nby9MelNs?=
 =?utf-8?B?UnkvU3d3VHJpYmgyWXFsOFJ0RUpjUmFSNWVNOHcvcGVWaFBmVjdsNmlnb2tO?=
 =?utf-8?B?NzZUeXp0SUlTbFVraCttbjdHenVuTTErYWxGaXgwTGJ1cGYyRm1uamxEbDZs?=
 =?utf-8?B?RUxLUTBsdGs0RzdqV2hQWW9xbkJLOEdmRWc5MFpRYm0yKzVEN1lXQTVQaG9H?=
 =?utf-8?B?UFhlUWFmRzlpUVpiQytnMVhpUWxzT2tEVlc3eWhySUZiMVhyQmErNldnMmZL?=
 =?utf-8?B?N25mSmxsOExaWUo5d3NJQ3ZGN28wUDBpY1VleWFBL2xpMjk4M2NBVWFGQWhF?=
 =?utf-8?B?UE9sdFlmT0VqR3k2OE9WbEIvL0lvanI1L0pLU2x3enB5ampwdjJCWE9tV0dM?=
 =?utf-8?B?cVNDbEpDR2JkMjVqaDFXV2NTZzhEWVErZlN3SGpMSUxTNll4UjJkMWp4Z2xO?=
 =?utf-8?B?Ty9UTFJnZm5wcnZoLzZUMFFlQUJJT3NwaUt0enVsakZteENWalJWT0VleFdz?=
 =?utf-8?B?N0lnZDlxdkNRYXNpck92L2hXTksrYk1NQTJuTUZocDh6OFpJUkxDYnpvUzNW?=
 =?utf-8?B?RGoxQlVpWmRPVkZ0Y1RKWWlnejlndm9uVWM1YzYxcG1CNUtGZlZ0b214WUUy?=
 =?utf-8?B?UEt1cVMxL0NOeG5EY0tKN0VOZk5BVW81alZrRTVyUERzOWI2SDJCSDRMVVBn?=
 =?utf-8?B?K09SM1N0MG1BaEdnbVpBQ3NLa1FGRzNkMjJ1R0NSN2RjMFBmdkl4OWdBcENR?=
 =?utf-8?B?cDgvZmdaMjdObXFLRjNweHJNYzkzZ0dDb3NxSHAwcXhrWkRSQ2FBV2c4aTcz?=
 =?utf-8?B?ODhRajVjOC9BaThsUHJ1WkJ6RlNwZUdsMVV4VkJHbCthR09yZWl6R1NLKzNV?=
 =?utf-8?B?dmVObzJjU2tLZFBOZ256S1BZQm9pQVdzQ2ZZcjFldEhIY1Y3VldSblo1SFhD?=
 =?utf-8?B?K3p3Y1pUaXV0R2JBK3YvM1pMTkVkd0dZaGZhaGtkdjBzbmx5RDdDVmZIaDBt?=
 =?utf-8?B?c3V5bVNuOVlyaVpGRkRnRFJoR2pBb01NM3grWTdTcnFWU0VJRWJKdDc3U0Uy?=
 =?utf-8?B?dG1uRkMrc01qSGY4eXorRHVQbVRoUlVmMUFuRVJldWRTSlBQMTViaHpIT2di?=
 =?utf-8?B?VmYyR1lsY2RsZUJGZDNrbld1Z3dJK0QvNXZtOHVxR25RbHFvSm1yOENYUGxF?=
 =?utf-8?B?OGJhTVdJRVFwb2pxeG9TQVpKL2JJZFdueWdaRmJUbFgxOEwzNGFuLzk3YjB3?=
 =?utf-8?Q?EDrH1/XhjZLLm5IY=3D?=
X-Exchange-RoutingPolicyChecked:
	q+tCgvyfy3SZ+msrhf5Q7O1GPrudoMY1UJifptQI6olWRriOA+ErAWlyCQNkKTso89Gyp5uH63Z9DenpeNd1q95Ce/A88EGJvu87e0L99XEzb/ZM9Mq+zY5AbuE6gKkJl2Flml+4cwVwF2ZxczWrXO3TyrKYA9nqo5/RaZ4cqLaHndzjcjutkLk81vIDbzpandwr52O1MS4HIJG8IpmTd6K3r3TIvuOBkFdUTh+7tV2uNRlucQb3caOSMN5XlNsASeymlDxtbxPhzklZrNeOsjdPwkl0U53ImyBO3mERspT51crpiYkpfozzms/MBFKQvFFwAHhI8VeCMmbQo4nBNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2bk5hJIN3TAxkD6OVerB0Bbtr3XFoOD3UN/OIv4rteGY1wKwNzL5rXVWdjWF3iXppsHNgfQCUEYpmZHUIk5nMFhE5hx8LOsAF5KkHXO7eMMLZN2jfu28Y8YN1Of5pmdXdoDH6nbSsg+9szJSVFtas9AQm+Qz0PzeSh10RYL3xBXPzvifXXqFVFOGZLsSVmIPWFW3xK4BJ1sHnI/c4flVqpAKV5bgjjqKBg+pFfauW7x1N4zFcFjK8YOtGj3883OpoKczn3Vj0g7x/BEFaNEmhPhxaaLLnX0XITCTcCKwvGXoTwCWUAcZ96A9HXddQ5cjuCeLal/Py1bnGzCiYg6agtrPEqrYlMZR9aqy8ixOKqVCfJtvQX7mZfOTaKSEBrj0NCgnz6ipyBUXrhrLMos6yoPpNFa3TZTWCnthMAAzHTinRdLUMueHwSZ3xlpsswRTTuY56ACfpjk1ckpxaxzm5VLzlpg971Kr+u73xxuqW44gou7LRPb9bSmIXEbEzfk/cv5qA4/Zu191HEuTojv53KxtxjyXZXPp6gd6nFsFYUVbbB71eWUMWk17kl9kx7pHydrRgLi8uhi8Dbji0mZRH1rjfZEC0bOcdtyKyoBh6P4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9320fffc-46b1-4f75-143f-08ded91264f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:50:16.1672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ocre+H4ZPIkM6YuBc93fI5IBCausG/b13IlwuSVj0IxapxkKBfe7niQqLLJ1kF3jTUdPxCIt7anb3TU1A+ynA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030146
X-Proofpoint-ORIG-GUID: hxDdC22ZuQfNf-2bhP7jlETdnMlTWrXo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDE0NiBTYWx0ZWRfX7iTcQ60wXquU
 +VI1Wz89LxE3iWg70Qd/MdpDW06VHrKwSWttzLKhs04abX6aglTeEBzChgVxyX60nBvgkbLdP1U
 PHONkuLCuPaoyzypbb5c0YkT7HYh7s9Tnaj1s8id2+CMHuZD2fzWKSiqc+94xThLHFD8HlxUt7V
 Oh0GFvplcuFygcbJjKZ3LWB6wAnAps6zx2bcRLDcHmyXuU9D+O/fQJqFZsIPf1oZJR01b0jdWD/
 8Dz7o5ORQjUiNEGDlKcnkf0V6wWh8D5q8ZXNFGu6RrXIQcW8k85er7Rw6X75wg5WoL7GY3B5nCe
 XFGdpZJs1DyVWi9+cnGltzvpHgboWavjztMG8jUE5d93ImPFVglq+uqzS+PpwH/jfv2nzmH/LPZ
 2ICZji0MXBTzyk8xDLhg0BM6NsjiRJQTPX+Ez+aOUURyzP7HyWTuP/VEGgviHj99JY4Ry7L5KG5
 1sK9sa0mOwKCyTecSf5HzyktA6X6x4t8dammbrWo=
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a47cc2c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=chxG11ME967jhF131JsA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-GUID: hxDdC22ZuQfNf-2bhP7jlETdnMlTWrXo
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDE0NiBTYWx0ZWRfX9BuTXa9KTVNV
 NfhdcyIs0cHLDtR8HTmVbY6B/Wwdv0NDjQu03Pdj6yVP5OyuMDzgSdgOTJKpyselEY5LE6M1BCx
 /m1ykbLaPnpJDRxTn3u3JwwlJoC+1JB8zQdwtBMHspp098LEJ3AY

On 03/07/2026 12:24, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] The patch introduces a wrapper `nvme_mpath_synchronize()` that calls an undefined function `mpath_synchronize()`, relying on a missing dependency (`libmultipath`), which leads to a build failure.
> --
> 
> commit f655883eea782b4086749f2985502e444177db21
> Author: John Garry <john.g.garry@oracle.com>
> 
> nvme-multipath: add nvme_mpath_synchronize()
> 
> This commit adds a wrapper function which calls into mpath_synchronize
> for the NVME multipath subsystem.
> 
>> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
>> index 35618285caf89..292526c9dda29 100644
>> --- a/drivers/nvme/host/nvme.h
>> +++ b/drivers/nvme/host/nvme.h
>> @@ -1078,6 +1078,11 @@ void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
>>   			unsigned int cmd, void **opaque);
>>   void nvme_mpath_ioctl_finish(void *opaque);
>>   
>> +static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
>> +{
>> +	mpath_synchronize(&head->mpath_head);
> 
> [Severity: Low]
> Does this code build cleanly? It appears that mpath_synchronize() is not
> declared or defined in the current tree. This seems like it would cause
> a compiler error due to an implicit function declaration when building
> with NVME multipath enabled.
> 
> Is this patch relying on a missing dependency or missing header inclusion?

I think that next time I'll just send a mega series with everything..

> 
>> +}
>> +
>>   static inline void nvme_trace_bio_complete(struct request *req)
> 

