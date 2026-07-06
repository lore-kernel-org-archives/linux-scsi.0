Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B0A385D77;
	Mon,  6 Jul 2026 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349155; cv=fail; b=lw3KPg1g9qC1n/vVWvw/xnitgybDKB3svX41QNkmXD9Qyxgm8J70ASdfE+ksDZR/r2UW0pJn0WKZd8sPQL15JY43wCNBwChHl8yRJl55oiqBnXy7VVj+ZXRTOsyikunnUbp0nVc/rUnPyna+Icy5oG45OGq830ofJmZAxGjRVTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349155; c=relaxed/simple;
	bh=4+xkvOplBcQV2tMuYSNkYhu0y/cIZLTom593Xw+ETKw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gxOVICqhu32Zqro+oQqjlygXV04PtUxnHeI6VmmJlqczdsEV5dhdvbNaB5OzQ4Mdbl+BUvH5UwIYPcjpMqT4DNKpdMeEt3eg5MU519LkGtRKXAicDYqsbJOnKvS5aeNteYRNDU/DkuQp3dkTit0D7DR1qE/ODkDvJwtzuvacv6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cc7Eih+R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wIpNGzX3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cc7Eih+R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wIpNGzX3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666ETUrl1025669;
	Mon, 6 Jul 2026 14:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2lSkdLn7SDiblffBU2L8hsenZ3tVQx0x19sRxn8vqvs=; b=
	Cc7Eih+R+9iBviOUKxB4UrEFo/6lVKkzuPdanmEtOLDZYlB4Q7F6vOyMDbJpQj2F
	8moLZKqaHjBTXskdSEjnBVO0uA3KIF8j5v89XJSU3oNFvUq41NZ7XT2FA3BNCzPW
	38pghgR7FEjVHKuYDn39/BV1RKo4StHlbGlgkRHva6QH09nHquyWoPiL23IZEcvL
	wnk8Pj+hpmiuDa294HtDgD1S3FOOyaHGd58i6IBX/eaKYeUu2sXoNaqU54hfu9bJ
	ywRA1XbjAxTrl3lUp55IwWUMGkw6G6PwP5Cc2BfR4ixlJnf5nZ/WITXwSOPDkLjB
	/seLYmqdqcuaShKwN/+QgQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rkbbw5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:45:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666EhLEG029290;
	Mon, 6 Jul 2026 14:45:51 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012066.outbound.protection.outlook.com [52.101.43.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmcexte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:45:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mi8+Jr1Ri2k3ZVAwiGE7IEzmAHCqKibsCxYMYRVsWMWy4TLRuY6ecl2ygZ2gL2reJI18ZPxmukG0ea9wC+fmDeBDbt9zR9wa8sgPb+ZYaLHyPfbsoQ0/ze81AA9eIvAg0ktIa3GuvFQAQyfqhTdD6BNRAG3pebl99VDLKhQdFR7gFXnZAUcGKleBMD7jKZM7hURjKAiZ0ekh++Eqr4luhgRMROiGDZG9tkep+5UssmYCqBM1s/+3f6X6wTe34msDIJdbq7pkaMnAkEJj2oUHDGrIqCHoqEfaxQoFBhuOQ6YIzglWrpmgaqYdHLWVldhusUmtT75NxvvIm2hOCU0Wgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lSkdLn7SDiblffBU2L8hsenZ3tVQx0x19sRxn8vqvs=;
 b=F47FFXQ47tRuMV5d5zRMr9ubIF0NTdjQghGjnKHGI1HeoqrZfAn3pygHXRFrssBebnEhTrquzlu9RjJtBtd1ITqDO+KbVAASiNUxhkoEpoIpDBHdFoYP8t3OGf6XpgDx+AVOdkb4DVL/9Prl/GSUHpSYkLJd+cRtgJGx8P0jGTiDRPTyDp3ONxBqT3K6add4fCkSHG1B04hMGJrKkdO28tcz518GfVpaBzjqmecqHYiTsOoIJMWUdkBeUCn0FWdLw+sqJuboe2yoUQhICaN7YBX3YdK9ayyxSOtGnnvm16jThmkz+2KrIEwIHm+VuudMkUsq2MIIWYf71roQ8LEvNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lSkdLn7SDiblffBU2L8hsenZ3tVQx0x19sRxn8vqvs=;
 b=wIpNGzX3mlkEnYTv74chuwkoM+v3tBb8JPbVdgS9lkXNDdPZrhhdq7cLEoOTXmMy1xu2SrxJbLxfyR0trmiaOlHznlXi7a52cOvaxF6/0oMT/LujZ1LbFN+2NjwmtAvJZvxXYnz7K3Kr3MSWmxuldJa2oHxOCgT/sLO2+dLJtKM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS0PR10MB6869.namprd10.prod.outlook.com (2603:10b6:8:136::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Mon, 6 Jul 2026 14:45:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:45:44 +0000
Message-ID: <ca4c76c1-214d-4d92-b8ed-e1eab3af7e23@oracle.com>
Date: Mon, 6 Jul 2026 15:45:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/17] scsi-multipath: introduce scsi_device head
 structure
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-3-john.g.garry@oracle.com>
 <20260703104921.2095C1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104921.2095C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0006.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS0PR10MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: ad74b6da-cc03-4446-b065-08dedb6d41e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|18002099003|5023799004|6133799003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	zv1HcMzcSZlpOSkMOFQSFL/taNKsgx/D53hoiszZLU03XQz7KBGplXayvwne6xmTCIGs7VkBAvlLWoiKeFE4tpzfYn0Sf2POspgGxA2+/HXHQSV0I1hLxxnqRuNEWv39a4oUm4XZI+/IT644JQIgZIhdsquT4ZBdiunblOz5/pnP2iLAczpZa5ygfh1OstJNvc5hnvojELQUTDAcC+cvb2Hn3kz4/rZwOrdWmagItHrreIkmcotPKJ/9brQR4PQD3I8qROG/w+IChkwYi0IonvMvCwdg0Cn7D9SiFvhoxNlmEfykVm0IvmDksTYiXMWGsdCbNsp992XOdzPSAK1+vqKgo5Kyhy/GVIELmdkowXZfWHW1YZy/4/TMYyhAl1f5Komz1ASpSbIEA0RWOxpMIDQL0QLiWVUz6eupFMeD8aXs7QvGZMLz1iyZbc1L4FRIcg5gu22YrZMS2F247kuNlh59prlRcgUcVgUWnhNaizet3CICVcnpgj5qmwHTqmjdoOpDGVmkDBQyiY9+VNUitjlNGfvqhVxS4p6UQTbIU+Jl+lj2EkBe8D5iNvZ9H6pGOj89ycT3tJ7LmwA+Cp32sDBXFs3ejptn98sZYiwkj5RksXNRpXYQUtGHEEi48J/lzrxN46ddKYobe7WBgJzHN9aFnbnZUnQ9fuo3kByIXrg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(18002099003)(5023799004)(6133799003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTNJYTQ0aVArNUorM3NXcm9jOC9iQ3VOUVRmeG0yVldicVUxeUZVcHFBQmsv?=
 =?utf-8?B?S0dBeUMrVEQ0THh0alFNa3hmSlh0R1FUOCtEWEl2Z0dMTWhJWlFhdTdlRWRP?=
 =?utf-8?B?UnRLbDQzS1RjUW8wblExeHdmK3A0bHlCVkRCTnp1Q0ppK0ozV2hXMWxZdmlI?=
 =?utf-8?B?WVBsRHA3dmIzZm1ZV0V4RVZNanZLeFQyQVZ4S080S21yZ1RtbW5YYWlMTTlG?=
 =?utf-8?B?THJnQ09QK01KZHI0bDhRVzNsQnRYazI0LzFkTVM2Nmpoa0wzTlBWYTVjcEZo?=
 =?utf-8?B?WE0xc2lZakV5b1dadDZzQVV3dlNmUXo0L0wzMWMzczdodTZFMG11Q1hWdzVQ?=
 =?utf-8?B?YzVaeFVudU9MdklSMGpVc21TcVUreUdOZEZXU0JnQ3NMUm5jVUFTK0FRaWsw?=
 =?utf-8?B?SkdYUXdmTmJzUmpSa0g3dXpISDROVm1YRmxFK3lQTXhiN1lZTmo1VmFyQ2Ft?=
 =?utf-8?B?enh1REpYVEJEQStBT1hjU0NMTXQvV2hlMlZZYjZLUHR1aU5nL0dYYUNZeU5V?=
 =?utf-8?B?MHlucGRaRWFhZ2E5WnYvQW1rdGhwY21LdmwycTNDWkRCTEtUMzZjRkNVWGRo?=
 =?utf-8?B?d2hMUlR6dU1KKzNwRUZGbXdWN2Jtd2ljZXVoR2lZd3N1VkpDYlRFSlFZaDU5?=
 =?utf-8?B?aU5QRFE3WW9wQzBaRy9LNzlRdjE1YzZvekQ4ajVqL3lpM08xQmZ1a3dNM3pj?=
 =?utf-8?B?K1ZDc3pIZUJRY04rMWE0UFFiUlpvSmhRb2hWNnJwUll4QkJDYzN6QlZoWW5S?=
 =?utf-8?B?ZkhyaVdrTEhiTUZMWWRUSllDUEhQcXJZKzlucE14V2NEWVhFSk1sblFvYTNS?=
 =?utf-8?B?V28yR1JWQlIvOUxVQk5TS0YyWDE3NEhxNGNSTUhOSUVrNGFJMkUweEsrQUxh?=
 =?utf-8?B?S3MrdFBkdFZHQkZsQUZFUzJmaUxDdThTVkhRNWFyNEhQRDNpQkJMZlpVSmZQ?=
 =?utf-8?B?ZHBkR1Y5NnhPalZXaDBtd0N6SEEwbStXMXdyV09CMjJ5dUhXZWd0ZXMxVVJR?=
 =?utf-8?B?YktKQnlHZ095cDdsMFMvUVRhUngxSEVOamJLcldFWk12SDNPNU9oWFIwNWRI?=
 =?utf-8?B?MnN1SVNhR2gxejNteks1SE5UUGk1Zkd2U3BxVklMVnEzUWlzUkUwT2Z0UkZE?=
 =?utf-8?B?VzVHWkJYZHVZK2I4RzlVQTM3eEp5MWNFQS9yOUxreTA5L0VZNU1iSHRML1RI?=
 =?utf-8?B?eGMycFd1cGZsdWVpekRyMGtFK3VDZXhyMDdsVzIxMjMrQnRQMnVoaXViWTA1?=
 =?utf-8?B?dEpJc1RTVkYwN2ZyWVh3K1NBcktNUFJvNk5LRGVFNDBVZ2Q0Wk9XMi93V0V4?=
 =?utf-8?B?S01KMTd4Ulpmb0N5OVlyMy9GR2ltQzFpZnREMmxQb3JMczBHckpycnphKzFI?=
 =?utf-8?B?dEZEczArbDRvenVyamJLaGdNbGllVmRjTHRtWVF5SVREWTVSdkxZT3NtVitJ?=
 =?utf-8?B?NVcyb2V2aXl0QTdEdi92YnhxTk4zY2tzU1I5b3V5V0pScSsyb1Q0dTFSNkVY?=
 =?utf-8?B?Y2tMcGxTM2M1RjZNM05UTjlPQVJ2NDR2VHRZYmFVK2Y3N1IyUEd1T29qM1BC?=
 =?utf-8?B?MWU2VmVuYWs1K1E0SmNDRGxSbzhvT3ZnSU1DVER1bGRlNHBKSmQyVXlBSmpk?=
 =?utf-8?B?eVZJT0Nac1VWVEIvV3ppakNBRDhNR1JydmN0OFRJbWNjTHcrTU0vYlRQTDJJ?=
 =?utf-8?B?c0NGWVBlM2VjaTR3MlQwK3hTUzBsRThreDZ4T1hpSDUyMXE4eENlZVk4MzJ1?=
 =?utf-8?B?WGYxNHM3aUJyT2g1RFZWdFR1TVMweE1yYW1TQ1pJNThWaExWWDhJOEhwRXpk?=
 =?utf-8?B?WjVGdGJIUXM1UG1DUlVjZDcxSzVvYStIRXdzTTA5RUQ1eXFZdmFjUDFuTXlh?=
 =?utf-8?B?QkY4VWt5Y040cG5kUmt1RjdwekpyVDNVc3hwOGo1c1lOaWRYNFJrZjFSc0wx?=
 =?utf-8?B?Z2NjbFcvaVUvekY0MWNNdCtmRGdZbENHS3F0Tm1yNUpWZ0tRTkRqb2VIanFz?=
 =?utf-8?B?TG5sVS8vc2RZN1Y2QU5hUmNIUzQzeEJlTFZmcDVpdHhLRjZHSExIMUltU1JP?=
 =?utf-8?B?ZzlUYVJuZmY5WjRWZEVBUFRsd0FRd3J6NlNKeEVLMzdJN1E1TEp6NUlCVVVT?=
 =?utf-8?B?VXJxMVRVRkd3M3c1bHVyaldzQ1hybFoyK05HSFdkaG5DU2hiandzTTZCYTFK?=
 =?utf-8?B?Q0RWYmxadWdwVmtqY20vYjdmR0p0ZlFaTnBYcEZQbHJVc0RubmFsSkFPZHJz?=
 =?utf-8?B?UmxISGt6TFAxWldaaHMyOWZpUDN5RW00eHBQdmRIQXZGOHNaYmlOcTNhbmM3?=
 =?utf-8?B?V253NElFQUoyY2IxcUd3U0RMSnhZdEh5VkMrSEhpQ0ljcS9aTW02ck1JZjgy?=
 =?utf-8?Q?7JlUOW47OteBuKko=3D?=
X-Exchange-RoutingPolicyChecked:
	lFojqnQspiSaMK3OtkY8/VV3dqseDAmvbyPIcPXD0tnFvocJWFUtNyoZKst9YmY1HfXnbsgVUpJWCrjymtSmR5RySgjbn3mKkZSioENR2GmuHgJec9laqfix+uJnvGAtz0gLcZhqNagpkss1mmrvA5oOZkmgtUIMFVtuSVE0VMUPPixPw+6vnX28hcGkCClp2+hjJMYd50Ht3qHzAFw+31i7fDLWDVJwG9tQDBSXg3smXBqqcf5vQjeW5/7t1aFeb3PKAQm6T/JQzVZ9y0xlkD/etVcDTmciXMGyU6XDk1F1GlWPMUy4S9t1zbJvd0NKrMvwEIhle/7KnT6AY29WtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1LF1Prv4SHM1K+LrHhO022UWfBab+zO0kUZlr9at4WZi/ERU82l0pStVDbkiQN62gdqgm/Zb7hlnhnEzvU3t8pISGnI9ykAMbIYy73GpoBB+pBH42yTuc5zrL6iUcurqz3wZ9oqZ/aBfpTHd09wVGNS40oL+SIUbELW4YoNbUDkcGtOzZ9uRiaq2xbI2HNF4hNikmxChkG+jLEb/9uQt4dR9ULzvyO+5bpzK+c6DOMNKhIvq4G4Bdnc6nrVct31Ax/Qk2r0KUVRkc1FaXoUmCfO/bN+rXk9YanF1+v7TFXKF9IDzSTjtRiekrfeq1RGRe0OAiycOBuGbPXd3qlo1cqmuY/Y6fphP2U0uNAjTdfRLD9rKf/i2dN2rin1cjBOops/c8sDrkRWEldvKFXLdwv3Ge8wTg4zKjfzZQFRry/Wa/G07bkDpHIVlOOm6zFYRRV/c09tDCxGLZMwad07GUOlwxvQTNauyI4ko0Bflbg2Uhaf1JxyT3in0eJL0My1Oa1TMeIL3/zQ6apY81NMKXeslUTLymup3plPsWDqwj65CBszB9M6yY75G3H+Mtqlmgcb30glCyRGrS1D5N2fQ+dhjlsfz7hwDFsfRRCG9Nu0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad74b6da-cc03-4446-b065-08dedb6d41e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:45:43.9123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NsBzIRWB6VorGqzi9EOcq7IJZuxwVuZr9tYwIOTO07WSC/pqbo+JnzXTpFkBVUnAQjuQSAPamsK88EzkvqyaOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060150
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE1MCBTYWx0ZWRfX37oOXBrEMn/0
 uDm9BNL9Yc9FdT+BmPYlJTtZKeIhTBijt/25Hi4GbDYngBSmXAzO4X56pY3PwKyOO5FcmG1KApx
 wCbVK9hcGvabIObpI3B3NJ2yjqaNkkTAeSgGVrTsQ+UwrP8KbEtI
X-Authority-Analysis: v=2.4 cv=QP1YgALL c=1 sm=1 tr=0 ts=6a4bbfa0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=jZSE-i3kBAPpBc2cmZwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 38sI8R2Y_O5OdiymyxZAna9VYAhu3w1t
X-Proofpoint-ORIG-GUID: 38sI8R2Y_O5OdiymyxZAna9VYAhu3w1t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE1MCBTYWx0ZWRfX4rRa7uMDCskJ
 B97T4ijSQWyIjyxnmcwKcwmsoKEqsqlCFF2JWEl3XcqscLhKIP/pHH1LVpBW7+1aiFpJGoUf19I
 MNwVYAgWUAxmHh7CvMq8C1R4QzqvHm4zlO5VWFYtRieK0oCUbUbOnAty0cmmzzjmoDOknw3Z1Mi
 X1IvSJBB3taeYD1uddOgHoDA3d2gCg+u7FyWwqAxeQAcg9X9K/AjqEtlnpxOW52wtdwItvCXvJ+
 wys1DU7e7U5+slX2wxBX0xbO06jFyEJiJfp/PLBVBFkO3fjK8vMfGutsIm4fNPZBSSfmIQ79VBq
 FyZwj2bijW7OGWkkX8vngNEk3CvvAwRbkjTWbsnZY1P92unfvpwoj2ONXXxLXT0nsgReXuoTJC6
 +9809iYWgAB7Q36d51HTyJLEYJr12I6Kp/+F5SHzf2jeUBGkjZIR4seQDnqn5s+Td8qw9L/uPS7
 dBQs9LVK2dUO7mjCJuA==

On 03/07/2026 11:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Self-deadlock in scsi_mpath_find_head() due to kref_put() triggering release while holding scsi_mpath_heads_lock.
> - [High] Double-free and use-after-free of scsi_mpath_head in the error path of scsi_mpath_alloc_head().
> - [High] NULL pointer dereference and invalid device_unregister() execution when tearing down a failed device_add() in scsi_mpath_dev_alloc().
> --
> 
> commit d7eb5e4fb506178f4a58d8aa264acf8230ebb5fa
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: introduce scsi_device head structure
> 
> This patch introduces a scsi_mpath_head structure to manage multipathing
> for a scsi_device. It maintains a list of scsi_mpath_head structures
> to look up matching multipathed devices by their unique ID. A new sysfs
> device class is also added to manage the scsi_mpath_head device members.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index ff37cfdf2f9d1..65ee3da5cc7fc 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -88,6 +146,71 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
> [ ... ]
>> +static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>> +{
> [ ... ]
>> +	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
>> +				scsi_mpath_head->index);
>> +	if (ret) {
>> +		put_device(&scsi_mpath_head->dev);
>> +		goto out_free_ida;
>> +	}
>> +
>> +	return scsi_mpath_head;
>> +
>> +out_free_ida:
>> +	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>> +out_put_head:
>> +	mpath_put_head(&scsi_mpath_head->mpath_head);
>> +out_free:
>> +	kfree(scsi_mpath_head);
>> +	return NULL;
>> +}
> 
> [Severity: High]
> Will this cause a double-free on the error path?
> 
> If dev_set_name() fails, put_device() is called which triggers the
> scsi_mpath_head_release() callback, freeing the IDA and the structure itself.
> 
> The code then falls through to the out_free_ida label which calls ida_free()
> and kfree() a second time on the already freed pointer.

I will fix it

> 
>> +
>> +static struct scsi_mpath_head *scsi_mpath_find_head(
>> +			struct scsi_mpath_device *scsi_mpath_dev)
>> +{
> [ ... ]
>> +	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
>> +		ret = scsi_mpath_get_head(scsi_mpath_head);
>> +		if (ret)
>> +			continue;
>> +		if (strncmp(scsi_mpath_head->vpd_id,
>> +			scsi_mpath_dev->device_id_str,
>> +			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
>> +
>> +			return scsi_mpath_head;
>> +		}
>> +		scsi_mpath_put_head(scsi_mpath_head);
>> +	}
>> +
>> +	return NULL;
>> +}
> [ ... ]
>> @@ -116,13 +240,58 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
> [ ... ]
>> +	mutex_lock(&scsi_mpath_heads_lock);
>> +	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
>> +	if (scsi_mpath_head)
>> +		goto found;
>> +	scsi_mpath_head = scsi_mpath_alloc_head();
>> +	if (!scsi_mpath_head) {
>> +		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
>> +		mutex_unlock(&scsi_mpath_heads_lock);
>> +		goto out_uninit;
>> +	}
>> +
>> +	strscpy(scsi_mpath_head->vpd_id, sdev->scsi_mpath_dev->device_id_str,
>> +			SCSI_MPATH_DEVICE_ID_LEN);
>> +
>> +	ret = device_add(&scsi_mpath_head->dev);
>> +	if (ret) {
>> +		mutex_unlock(&scsi_mpath_heads_lock);
>> +		goto out_put_head;
>> +	}
>> +
>> +	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
>> +found:
>> +	mutex_unlock(&scsi_mpath_heads_lock);
> [ ... ]
>> +out_put_head:
>> +	scsi_mpath_put_head(scsi_mpath_head);
>>   out_uninit:
>>   	scsi_multipath_sdev_uninit(sdev);
>>   	return ret;
>>   }
> [ ... ]
>> +static void scsi_mpath_free_head(struct kref *ref)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		container_of(ref, struct scsi_mpath_head, ref);
>> +
> [ ... ]
>> +	mutex_lock(&scsi_mpath_heads_lock);
>> +	list_del_init(&scsi_mpath_head->entry);
>> +	mutex_unlock(&scsi_mpath_heads_lock);
>> +
>> +	device_unregister(&scsi_mpath_head->dev);
>> +}
> 
> [Severity: High]
> Could this lead to an AB-BA self-deadlock?
> 
> The scsi_mpath_dev_alloc() function acquires scsi_mpath_heads_lock before
> calling scsi_mpath_find_head(). During iteration, scsi_mpath_find_head()
> takes a temporary reference to each head.
> 
> If a concurrent thread drops its reference to a head just as we process it,
> our scsi_mpath_put_head() call might drop the refcount to 0.
> 
> This would trigger scsi_mpath_free_head(), which unconditionally tries to
> acquire scsi_mpath_heads_lock. Since the non-recursive mutex is already held
> by the current thread in scsi_mpath_dev_alloc(), it appears this would freeze
> the thread.

I will check it

> 
> [Severity: High]
> Is there a risk of a NULL pointer dereference and invalid device unregistration
> here if device_add() fails?
> 
> If device_add() fails in scsi_mpath_dev_alloc(), we jump to out_put_head and
> call scsi_mpath_put_head(). This drops the refcount to 0 and triggers this
> cleanup function.
> 
> However, the scsi_mpath_head was just allocated with kzalloc and never added
> to the list, so entry.next and entry.prev are NULL. Calling list_del_init()
> would dereference these NULL pointers.
> 
> Furthermore, calling device_unregister() will invoke device_del() on a device
> that failed device_add(), which violates the driver core API.
> 
I will check it.
