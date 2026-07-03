Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B775635E94F;
	Fri,  3 Jul 2026 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783087619; cv=fail; b=DiMjCQl8Bh7Cx0ZA4C6Xgh+YglsRkxdRHifIaHKedOp50hjrgsWJ4pzdWRo4xvbCZqjfPTABkfkjzuRZe46LmemvJFyi86aBGvNO+jWpjQTt9AS9N8whnZsW1cuy2lWq1c0kDXFSuIO9l0FbZDCI5eNU21DVJ+2blk/fr3ET1nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783087619; c=relaxed/simple;
	bh=M56dq9copa56HhJZiKt1S2UAM5lO81wiFNg/s1dvITg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=seK2CAgn7/zNzWA6uRGz10btJUtJKrEppeLkETHRVHdegteVeZ4ShobbsxLkvXNB2DX5In3k8ZARlhXIoPflhLs1BvaF+zIUGuvISsvhanw+8+Ri9lGvM1YeH5DrGQ4CVyel2ASqYBw2qm/1duts8ZuOmZcQThskeHvnK7Il8lA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iNb8ntn0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=itcA87GR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iNb8ntn0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="itcA87GR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tgHF3329488;
	Fri, 3 Jul 2026 14:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eZavkjO8hVyd7x/Lb0cacrtyIMLke3HcxDMqD28Um1k=; b=
	iNb8ntn0vUNRPTyjGSN2Eeo+T/sEJ6BlJNOHiaqejJzOZssxE1PJeOC5k85MmLsW
	TI0isyvBIc1RYijej/5u5+D6SeHCPKFcL956HlrV4UggzW6TwsO99OXlaZPEIVAe
	J8q+X6P4F+Zy8ogPs1Yn9feCIX9HYf2sFijdAhOObYUgvL4QO9Eutcyz966Y51ii
	cusvQcqSDnF6B+0A3PIKNGzA2rs4CfRTAfS+oSwxBT3kVcFtyL4aKvcEEdn6XTUA
	ImWgHgHMawuxZhL6G+1NuHKXKb2S+UY+9/rO4AYlBMqEMQgzGoNzt9/VtOcNE8bG
	z0aCU2cRArW/rNYdHCyDmg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkaw6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:06:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663DrKIa000391;
	Fri, 3 Jul 2026 14:06:56 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yje8wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:06:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KXvsalH0gaUbbixu76XIpSNsuQh2StQg1zia1iKe5+4czM6z0gSF9FVviQVBsMbzM8FFW83ksWRDIQ05Vhs8xzKaHgYD0/tdN28frTCY7yQye2gdXZd+Z6AasLX9ESkW658EpBICYFDEW1XeffN/XDsgAW4u15C75mfAEVhbHDhcztIyl0aF6sL59pQASkzMOxcYs4exVTSGGOLJawdUCxTMElluc3j6upoJCG3ixgJaYn9YhqDqPKtxEQRVJ/8xSEZMOzOxslTZpPl5cgxb8LhtrMZ2L4u7JyvBDDHQlN0VsgjbXclZmjXjzVvBwx0uuT3piMJ1Q67Ufn5iA6Ldhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZavkjO8hVyd7x/Lb0cacrtyIMLke3HcxDMqD28Um1k=;
 b=ihyW5fhQCLdgde20yrOOp9a7RK0smCGfA/bsvW84qC3vFo7+TQyWheAzEVD1H3/VibISyyXh/OJHmMcMbvUNP9J6j62hVYMaExmYS9C5UfMm4bMhOkvkF/zqI/ZaofIG9wLuqbia4Qy1dEm8hyauN0VQ/zo4Bw3pJWzeStMqRMxpYBipWu4XbcPCpcve3MNPyT947W8f20lARlE639iP2WlGW2frKoXgIH2gWM8dU5kdjlgPMOH7gCjxLIscom5shoXQQSRfb66PUwXKzNEbiSb5n8ELCH0hJ5DgT70Y59bzlIUklKitTExvFQidBB2j42jPdhS6wizqZHh1F/rnGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZavkjO8hVyd7x/Lb0cacrtyIMLke3HcxDMqD28Um1k=;
 b=itcA87GRQtnyazhwOoV7BElAliDwQzxnVTsHdL8c+ifFI+s0XmNRWS5COQ+lFLHz8Dep2E7zcXRcLrEHbiGa3GlTnjPJhU6lO73Imtm61M4AtKr6P72jyuQOlBi6o4e3YJNQnFu5KCLYkCph7+zD7hpqq9OG7lk/WHx/JGyRTyY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB7484.namprd10.prod.outlook.com (2603:10b6:610:182::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:06:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 14:06:49 +0000
Message-ID: <a53510b2-76c8-4a25-94ff-55d424913218@oracle.com>
Date: Fri, 3 Jul 2026 15:06:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/13] libmultipath: Add initial framework
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-2-john.g.garry@oracle.com>
 <20260703104311.C18771F00A3D@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104311.C18771F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0585.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: de28e504-2a71-4229-4f14-08ded90c5333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|5023799004|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	f+InSblgloKWbPO5kVyOCiDGBJ495jk6AiXriuqUgB1vspEEs1ha5Akrg3OJWaY4hpOjDxhRQV+qsNJw8bdbPpCC2ptpCih8UTeFn1qU2VLKJ2Cr0ngIxaXgq/GC/jVXYHiQBACBJ0UrBrRBlgb6CFhs7FKziIffI4ByWb9mm5LnXOSbPX3iG7a10q2fe2z2ac3mJqd948xyHChwl83rv0PPbDc74aSaGaGQN+oFNw2QuFXq/e27RtqYNMaT8EokLDHeX6BFuxCtN1HF7cMo/sqNbabTMAzo4ZRIPW+Km9VEwsX/UM003NPZq1bpwFXcrz4HV/qC0KqTd1OdqldNKETZv2Er3MO4UDKNG7iSrp7WvgvlDCd8p90f9SyRJ2tcYl3NWA3uS8f6eS0EkzBmWBt7JjJsnRk7E4Ol48LQUMJf74KOBzVgyyFhh95GfLfvivwiKhefwY22Cza/e5Ah2fMIKoJ300uu3q815WkVRSnYz30+1TxZ9zJl13AajVldyXrGWtuw5V5n8sKGDW9WS5DEHekbMgWTAjwf1kwgxjIhLQO2N/dIG7Hc050uIY6n24M3UUH52ZFjLiLTWs1O+KrYVpqFeqUUMuHyN262xyOgiKtOAV4p7yL0ziDUkDPSHVwDcrOXT2Lfqnj6ZBErcEnDhny7bJoWjNvwUkaRyX8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(5023799004)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXd3VEhIYkZuK0JaZnNVdUhpZjc4M3RkR2gyUHd3aTgvbEQ2bTRaQkY0Mmh1?=
 =?utf-8?B?RFYxUjJqNTN2NTFXWFVDUlRXTFRaelR3NDhpZWJiaVRWZmUwcXliNDhmVFla?=
 =?utf-8?B?OHI3bU9GNTlpZkRzZkFQMWtyZ2tsZmtpajAyTmFFaUZjNVRHSTVkN3hXZEdM?=
 =?utf-8?B?WW1ZNTRZelZVeFBtREhlRlFITWNJU1RZQmhMNTFYWXVSOUJib1djVFhDQkxs?=
 =?utf-8?B?Qy8yQy9iUnRSYVB5cGNrNW9hSW1GZGNIQ2R6TUxUNjljb0pHblZGSmY3UjJn?=
 =?utf-8?B?NHFSaW92YXlScEQwVjFjTkx3TkZCQk5TamoyR0N1UmZOYms3NlNpajFMUzdz?=
 =?utf-8?B?U0tOYUFsVWNqM3pnb0U5bnRWb1ZGY3hyU0sxVXZuUk9uQnNPUU4xZmdKTVly?=
 =?utf-8?B?ZEVqY1RvUWRTWUtMbUVIVlpIY3dpQVQ5R3liNk9rTXhQSElReUJBaG1sS21Z?=
 =?utf-8?B?WlE1NWkxL1lFUWptZ2c3UVBYUVdQTXR2SUppVkRpMXQ0ZUtaQ2JwTVZMMEx4?=
 =?utf-8?B?OEVvMDBNMmxra2lXRWVBNVRUN3k1VG13Z3pwRllLai9odjhvYUk1YTd6YjRH?=
 =?utf-8?B?MjVNc0dZSDcxc1pocnhaNUlmK1dZOHE1RHV2MnJnVndLa1JLR0hiWStqZHln?=
 =?utf-8?B?ME1aeStBYzlQeFJuazFzTGxML1BHVlh0N2hHT0UvQ0ltcld0bzltck9vY0hM?=
 =?utf-8?B?UDlFcWJwLzQ4Q1Qzdi9KajNMMEZWQm41L21EQlU1eG1vL2xOS0gxY2dpQm5l?=
 =?utf-8?B?NCt6bDIzT3V3djhtc0llMUkrV1duM0dMWk9CRWpqNVFDcEVFREsrR0NSWnF5?=
 =?utf-8?B?K01jSmtBcFV3ei9UY2Z1dklFQy9nN2ZvMjVCcVBVK3lONzBoL3NHalp1c0pa?=
 =?utf-8?B?RlVRNE9namFtVEVPU2tJTTBmTEpyYnRyVFIwOWZJWklveEdteXRUUUNzYXMv?=
 =?utf-8?B?QUZjVFhac21xa2FvK0lpbk5UYloyVUpLSnB6UWhVemplU2tIcy9ac3hReGRF?=
 =?utf-8?B?YmdZUloxazhkeVdxUjBYSG5oVkYyZEJTK2xUTTM5NFdoUWtRQml6QUkxZVhB?=
 =?utf-8?B?RlNwaWpQTHNveldtbE5ZdjZYaEJBcUkvQXRVWm5BSWhyVDA1OFEwU2xmT0dv?=
 =?utf-8?B?Q1dLcjlPR015amlJMUxhTlljVk84andEN2JoVHBpc29YRkdlMlBYMWxCVURr?=
 =?utf-8?B?czJGNUxIdjRrY1RGcDUvK1FxbkRVWGVHaktvTUxyMWdFNDJtb29hUTBCSS95?=
 =?utf-8?B?bzhPYmVpaFpRZjl1eGtqbnQ3bDBoSG5pRzVLaTJkNW9aa0kzM0lsSnJpRDdw?=
 =?utf-8?B?WnhTMzJBQ3NIa0FUREFoU3VEYTVFdkpBNWJQSTFqK2FudmNsd2t0cmR6bitV?=
 =?utf-8?B?dFdINzliQ05TbmI2VkQ5UUFjN2tHZnR2VjhqQ0FuNGM3NU5ReTRFZHdRY01k?=
 =?utf-8?B?cWx2NFFuZmdHR3RaOVlOTlJQYkFrd2JWejlDVDBUTmpWQ0RzbU1FVVZWKzBJ?=
 =?utf-8?B?K2xkemhwbGxETGh5WnZveXRHdzE1cnJnbTlZa0grSXduL1g3c1pFVEs3VmRF?=
 =?utf-8?B?ZjczR2JiMlIxZGtzbDVSYUdjMUFCZGJ1cTBnd01qeEJQV1pLNTBjUXI3VDNN?=
 =?utf-8?B?S3V4NVlsWTE0Wk5rLzJ4RUl0YjVsVlZVSkRyL2xubWEwVEg3OGpCcTN0VFJm?=
 =?utf-8?B?YXQ0Ung4dWNZQkVCd2paUFU4eUNjZFE2dFpWSmhMTHdMendVR1dPdWdhWmE4?=
 =?utf-8?B?RGFOd2V3ZFNGK1lLc0hTWlpSanVCS3RQeCsyQ2QyUG1wdWx4RUhreFRPNGZz?=
 =?utf-8?B?ektzYVhvYUNabWRYTXJ5d0dyZkF0WFZOamptSkIzMFAzYklBUEZiM3Ewa1Ny?=
 =?utf-8?B?M05KTUQrME56YkUydnNYcitPdngyZGR1ZWVLVVJBVFRFRDlWMjBBQjZDL2Ru?=
 =?utf-8?B?YllPZWVPaHErcW1LNjRtS0VjcE0yNlNobURORUI2MnRpYXBGeStPdmg1dnJM?=
 =?utf-8?B?T1djMFRHL0hoSXRza2RzUXpyQXBFVnJuZnJuaHVNdkxIZ2MwTUg0UFluWkFt?=
 =?utf-8?B?aDJmSU12NWFUeUJKM2hDaW5Fc2ZESXlLaGU1MXlkeTRqd3hzSStoWnhXK1Qw?=
 =?utf-8?B?NWh5MWZ0RU1la3c2QUc2VmJLMHpQQWhLQUJkVDBDckVteFBtYUhHMzFwQUto?=
 =?utf-8?B?ZGg3dDIyd0RIdkxUWEZXZjhTQTRqU3FuMGRlR2lrODgwQ2RaSWRFVmw2dlNv?=
 =?utf-8?B?MWJMQ003cVFHeEl4eGROd0k2TFUrNEtxeEJEajdrTzlqWFA4NytVMDQrRVVp?=
 =?utf-8?B?aVNNK3dsTWVvb1FmdHI2Sm10eWJFVi9HMnd0WFpzN3JPTDVEMG83SXRvMlR1?=
 =?utf-8?Q?np5dfDnD5kj1/LX4=3D?=
X-Exchange-RoutingPolicyChecked:
	BRPgJ/CiYvCxaay5PlvDvxxCgUCE/5nNPAKF/aGIzvrEVeO5kuUQbSup65yYh46kASFKnRTkxvNuxbdvgRVdH/RhfdPxe1G5phrjZE6zMSPD1Se/WJsbppUQM7RUE+vs9vE1dAztHLULNmEe/HOhUAHyTUWqBNi+E4E4aeoqyjxbhwJ+Wa+4Z8Eyi7C70KWbpxhiy6WuHjGMTyJq4wc4SESRGX2VBLOEV1tFWJYYlCVo94IpAbS1lyrCrgfl1ISFp7+PTPNDFnw06REMpgWJ81MpG2kBEZlt3uJHYlFEjGnJWVasPSLAL3ZBdgY6wWnTUi5pck/v6nRGu9RoEr4CMA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JdeGEMp1eQN38JC4WajjTNdEZbSCA2izdUkX3z/dgQksS1nlCWYrQblO96B/sdLB//0aio/PdMZ2cWkdurfXm1XDVv7wRDrg01elXR3usbRs80UI7axX9MdF6u0WmDTP5ZxCF56pNSZsjzKcwdj5bcgKWVI4WFNPj+2L/RhYtnFOLJ3VxgdbvPsKYLoAYbrYCr180Hhn1nciqh7UiEse8nAptY5G5FrbMpywCc7UCBNIE55/qJGz3AUhMaMJ9oFcHs5/hZWFFQjHNB8fU/gYBSrcvAmP3JF18AwPpnFGZh2Xm5N9qoayMjyixtb39lWw3qsRgbof6hHX2Xo3HcnFQNSfvRjkQndsJDrr3CH1PiFrdbEo8LvqKsqlp1uQlnvS/H0TBj3s83ZRf0go2BDusDburUEp9SwAP7nc+O69Z7YNOZyJFlNwfteUYxtk5656fXX1xoC+1SBQuNzRrmfNVNneh/H23MdhHyk7kJrzZLJkIDVQXMflZHu3OvCGPK6baJyWrDBwgh4hmKUArL1oOoRpU5vGgWmmEn1iEDjhiux7E0eTOhjQvaPxroJm19Mij6d9Ltb+FHqx1JgjxTXz7aOqH9XqGxPsOSlr4cqn2oA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de28e504-2a71-4229-4f14-08ded90c5333
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:06:49.4644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VqF4NRC9bwp0gWCeiJeJSy5zsT6aP+BA8S13YPrI7cgImbBzp/gC5ZsTFfKkPstLA0XfZed9A1EecenzydUO0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7484
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030137
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEzOSBTYWx0ZWRfX+RenW2ihGlOO
 iaq2nLQ/8e/HXWM4qPonOG5vLp8IYJkUfS1ovrW2NuSiNT4ju38bFOMxNxOQFO0bsYXFNqc2CAg
 906TE7PJPq19NxSixksOB8CfcUJkB8HzokufkU1KrC+/pqBKwcRO
X-Proofpoint-GUID: HSVdZANtsJHY5Xe6UYMaq_53kNGMa4dD
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a47c200 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ZGUEyuQP7zSta-00FxsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: HSVdZANtsJHY5Xe6UYMaq_53kNGMa4dD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEzOSBTYWx0ZWRfX/g7T6J3HZ39i
 yBtaVlq24L7Xavou/DDWlQD8RkEA55CHm06jpbo6J1ZN/IxMOIRCBsYIXf9xEYxrGXmfBiyZcLd
 jsOBRECE/Ws5neyk8JB1bpWEjgesogLeYLfRz0+5DYaRwvKtNZBpfpjlVYAqklcyR+JnLhz5w2c
 6yRY2m9gHq0uZWHga54fDROeqLaPjCnDJNT/twijqIjjfFPHxudbGQeU8EtaqVT2vrCwYHWhrhY
 GO8fRQBcmtxngxyO01Cny9NwhBH9EZrNiSbZBFj9yCab+9wBKHtkPzouRla3VjFiUeGkptZR2KF
 BtLvoL7B7gv75Grb9BEA7/XXR9S/+qyr9H16UhJQX/8/vVAx+VeC+msZmsF09ibkvLtkWHO3RED
 8j/jKoeZNYs7ejjfoUMQ35Hm33XGqGouvWFYtZtvOHzui4UH7wS3YbSnhGJuuubnIxyD8exs+fq
 Gl7uhNxZdkQhVoZHpcg==

On 03/07/2026 11:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] A race condition between mpath_put_head() and mpath_head_uninit() leads to a use-after-free vulnerability when accessing mpath_head for cleanup.
> --
> 
> commit 594f063adb51503b6e7af6741526b8d738fee5ba
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add initial framework
> 
> This commit adds the initial framework for libmultipath to support path
> management, path selection, and failover handling for multipath-capable
> block drivers. It introduces the mpath_head structure to manage available
> paths and the multipath gendisk.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> new file mode 100644
>> index 0000000000000..009d4bb875c6f
>> --- /dev/null
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> +void mpath_put_head(struct mpath_head *mpath_head)
>> +{
>> +	refcount_t *refcount = &mpath_head->refcount;
>> +
>> +	if (refcount_dec_and_test(refcount)) {
> 
> [Severity: High]
> Could this introduce a use-after-free regression on the mpath_head structure?
> 
> If a teardown thread calls mpath_head_uninit() concurrently, it blocks in
> wait_var_event() waiting for the refcount to drop to 0.
> 
> Once refcount_dec_and_test() drops the refcount to 0 here, the condition
> !refcount_read(refcount) in mpath_head_uninit() can evaluate to true
> immediately. The uninit thread could then wake up, return, and free mpath_head
> before this thread completes mpath_head_cleanup() and wake_up_var().

I will address this.

> 
>> +		mpath_head_cleanup(mpath_head);
>> +		wake_up_var(refcount);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_put_head);
>> +
>> +void mpath_head_uninit(struct mpath_head *mpath_head)
>> +{
>> +	refcount_t *refcount = &mpath_head->refcount;
>> +
>> +	if (refcount_dec_and_test(refcount)) {
>> +		mpath_head_cleanup(mpath_head);
>> +	} else {
>> +		wait_var_event(refcount, !refcount_read(refcount));
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_head_uninit);
> 

