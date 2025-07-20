Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4A022EF5;
	Sun, 20 Jul 2025 22:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753051393; cv=fail; b=I6KvVsW+tAgeBpui2riDdZm7fsgKAl9qSSgSLtM7Eu+/NtAXdaUbAgg3d2FUfD0VyI9Sa7b+OuHKq9WS6C67PTgRskUTKI2wedJWLwadDGowJN6DOQGJ8wuYpbrN2UICscaslGsCq/BAhi32trnR9PYginJJEeR3jE5OAOrPYI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753051393; c=relaxed/simple;
	bh=yXm2kBblFLaBK1/jpAtERsKyWDtaU7ku5j/E7bFtYdw=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F0WVgTXY6qcoctoELkeny5y32qcG9sKU7w/6PTebZ45EBcJCj2xTa6laPK4hw9z6H8UfoXpQUc+1aW5WXDBrrPPqix/Y/7hGk3dWMfRiITD5bxMPFUVyrcQMLZJgLsqGTPNmF/Vf7QSYFgYXUrDv9tyJATWggTKlty2+tPYL/GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hGc9Vk7m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AQbO/hso; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hGc9Vk7m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AQbO/hso"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56KMh97f014238;
	Sun, 20 Jul 2025 22:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yLQsxjFuEHQioOgEqI4MERXScyaVaYDFETk62caBCWk=; b=
	hGc9Vk7mebVHU3SJdssehqIfPuQmGfRbRCPxCV7wzzeTibItyAKcOL6BkycSNUir
	Dz6OMsEQKbfGrX8emOjppWUiLlZrs0lqMbQWFvfgi7+tKUCfn4vqUdwCXkV8Tcos
	HnXc9oiuFe4Tf3Hf6zGgZ8SiUEYWuGPqdCKcJbE2TkaWy3EtN2B3jIo0JIHaSAer
	2BwSpEYQtvSfSrhqvN2IyRjjO2bsLtLP+HaviBwUsSC9m2W0a2t3YGkJx1zqPjsE
	kpCuUTPYxrb8xYa8JkljHRqrjq7zRY8HirMc4zPcfWnvnDORTPGfvxXot4gcM/N+
	E+HigoVVWL8cegUNjZ5TsA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057qsj5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Jul 2025 22:43:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56KKxubq006160;
	Sun, 20 Jul 2025 22:43:07 GMT
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazon11013052.outbound.protection.outlook.com [52.101.44.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t7dj6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Jul 2025 22:43:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u9/+SEJzHKbP+jhGsJ5gA+sW1LT2qt5ZejP03okvlhsy/Yiy/yZLU5YGVHFp0Jfb2OvsNStQMtKIdSID+lqvpI6aCY28/yKsW++nvODZ3juRjxZStvtzXCDXUHeTAjWSW3KB54gIBy2dFiFlY8vJoh3J0Fu39Wwbu+3WI7UL9ygqA7ttdFGvzMPFuCpjdHy7LO97pXW1QfzqndLc6KVuzEL++HiFlpg1iyguu+Q8X6laoLHB81JWCsk0oa98ScAVQb7pUA3RLOpqJQv1iyfqG4lT6LAvgkTRPTQfRKwMK5fSPjjjNdSxMZOLfyjLMJGkUgTnYktEseeMdNmsP4/M7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLQsxjFuEHQioOgEqI4MERXScyaVaYDFETk62caBCWk=;
 b=nG167H1HTFUgUn2gGWvwnaVEjehqD4TOONcLMv6iuCmBzQ/Bj3QSJRx47ZAv079GIHTapyv7/9pfCei7IY3+Pa5frKAQBKagFPsT5J6uaaqpDivb6bHq+jDhqqfLP49aYxkTmtyLJoZYoCISOfD/kEsaTirLU6pNOLuLDaA/DbR3cTV3YWLxTdbv9JC4nUYE8WwG0h/57ElJD+FQi8TM42lo00VZw6SQju08f0tr8nNRvBtJW2Wd6REtjI96W53SBbopdxxlscIfMDUbjdF4XTaqvzrfPhAcsJKTbIk6L0frjyThKOU7WIbjkA7fSlZMy27ecI6svryKjZFrbtvAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLQsxjFuEHQioOgEqI4MERXScyaVaYDFETk62caBCWk=;
 b=AQbO/hsozVSVoMpsxWCOUsItoHpcwZxroOB/9jDo2CMw1zD3PlzRQvsq7gMnSwFtxQTL7tD1Xs2LkxCcgDEs3Be/Gf191EH/O7RcV6YTiy8t9d6Pa9azl8Xwd0FW7YRzAIlC0mh1AKPWv91YorIpWbK9liVWlYNoHgsXV3HWpUs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6206.namprd10.prod.outlook.com (2603:10b6:8:89::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Sun, 20 Jul 2025 22:42:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8943.029; Sun, 20 Jul 2025
 22:42:54 +0000
Message-ID: <c5585648-eddb-47de-a300-f2a59fea39b0@oracle.com>
Date: Sun, 20 Jul 2025 17:42:53 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: target: Report atomic values in INQUIRY
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-6-michael.christie@oracle.com>
 <3d68de99-bdb3-4a06-93f1-298b2e170cd5@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <3d68de99-bdb3-4a06-93f1-298b2e170cd5@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0089.namprd05.prod.outlook.com (2603:10b6:8:56::6)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6206:EE_
X-MS-Office365-Filtering-Correlation-Id: c3cffce6-97b3-478f-836f-08ddc7dec41f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWxHdndjY1R2bGd4MCtCSk96NjVrMnozb1c5SnJjQitKSjJRRXh5K1I0VzJy?=
 =?utf-8?B?RWE4UEtYSk1QUm81bEhYcmhoUnAvaU11T2o5ZFc1UGJSTkNBUk8xazJyRUtB?=
 =?utf-8?B?SS9uNGVzOXVPN3p6SUtMQXJrdkIrS2ZHUzhOQ2FMaUJPZ3ZHbVFvLzVlZDZa?=
 =?utf-8?B?Mm1pVnl5N3RmWFdLTG16cGZmdHpycVJPOUhTQ2IydTJsa1l3bFljOFRocFl1?=
 =?utf-8?B?eFRKanREb0pDUUpVRDJMeXVKUWl6dnhIY0ZicVFiZUVzQ1owU25HUm5aYS9L?=
 =?utf-8?B?bFRyY2kydFlKWjJSQlF0dVRCbHZEbjh2STdvM1lUei9FZnlsNmNnWktKK0ho?=
 =?utf-8?B?SjNKdE03b3dqb0d1SVkyek4wdzJubTd1Y1pyU2NaQ09yR2Q4R0NwUWQzdEto?=
 =?utf-8?B?Y21uZzFNcUQ2QzVocXNvZHEzc0krTmVtQXdZWDJjalZCdXZPVFNWKzdvUWVn?=
 =?utf-8?B?Ukh6MTNuWS83WWNmaVl2Rm5xbjUzcEpzbWh5YTAzRVQ1OWRmNkpWaTVlMkRm?=
 =?utf-8?B?UlVremhuRnJPTGw4M0R2RGFxZmJjOUdnVTQxS1FzZWpVTVAyWCtCaHAzMmpN?=
 =?utf-8?B?QkZVTFNHd3ZOSmZwMUR4MDlQYjBmRE9qNjd6a1hMcnNKRTZDclVjRXdHcTBs?=
 =?utf-8?B?Q080ZytHM1NVbFdRK215RnJVYTlPTDBOQkhGKy9QZmw0eTFTSFJZdTY1SFNO?=
 =?utf-8?B?R3BZdVp0UXB0WWdZMG1rekVsSDV6MUk5dDRVb21kempkYmh4eTgzNHAvY1pS?=
 =?utf-8?B?bGdhdmJjZHNVVzdkUDRHT0dId2kwMlBBY01HNk14WEU5Yk1XMnJ4LytUTm5m?=
 =?utf-8?B?V2F3S21oV05UUGs4R3grdGRMNkI0YktTeHNra3liUkw3QkJDdmdUVVNDbXkx?=
 =?utf-8?B?d2NFcGRkckphVWl3QytTWTFCRDJWZHZwMDRMUzJmQ0ZKWDFUdVZXaW5oNjVM?=
 =?utf-8?B?MG5GUkxENkY1bTAzRElFYnFiSnBzOWpmYzJrSjVvblFJSGRWNGJ2VVZJNXZ1?=
 =?utf-8?B?eXlpQkxHTGx4V2g1b1U1Z2cybkJYS09OVFZQZWpINEplRWcxamxMMmZNVlhF?=
 =?utf-8?B?K3BWOTJUanJHazIzWW9WRFNxK2hIcWRsTzliTXZML3dXaG02OGtrdGZuV2dk?=
 =?utf-8?B?dnR2OTV1d1g0VXBkdUxDTFJkTk11WWhSRmxnQUxyNzB6Yy8wYlpudUhoUVVy?=
 =?utf-8?B?Ym8yc2lSc1h6QkR3d2JHdy8xeFJiOWhKazRqWTcveUlQYWM4V0crYldqSGdp?=
 =?utf-8?B?YWNiSW5VbHVNb3ptN1VRb3FhQWREL0M3byt3eWxJaHRIYnA3YlNwdVE1ek4y?=
 =?utf-8?B?OEtzc3NZazU1bzR5OXpvY2ZoeS9rSU5Pcy9hNW40eDFEekZ1Nk9tVnBGbnU5?=
 =?utf-8?B?Z0oyRC9XaTdJRXNRVWRtMVY3MHZoaXVLL3VkQ1grVWJodEI2V1VzOVFFeUtJ?=
 =?utf-8?B?WkdaUFJNYXBlci9raTNWMmtLWk9aWnN4QUg4REkvejJCYUN2WXJRa2d2dVIx?=
 =?utf-8?B?M0lLVFIvclFZNjlicFI0QWpMWEpsUUlvL1ZzTXJUMms5UW1rRFRCczV2Nzlx?=
 =?utf-8?B?MWIxTm5JbWdpYUNZb2NudHNuU3c1SVJ6UTlGZUVtcmh6ZHZlTUQwSVg2SWEx?=
 =?utf-8?B?b3gwYkl5eStvSENQY0dOVjZWRTFraUdHczhGZm1CUFo5TjhjV2VNMDViMDBN?=
 =?utf-8?B?L1FxelVVbUJudW00ajRNZDJKdTYvVzY0bnRZU0tHMWNUb04yM0V5d3VKa1U2?=
 =?utf-8?B?VS96VFVBTFNBK1N0cGNFT1VjSFppck1QaDZzT0RFMTJVa1luKzlyL3dSaVJr?=
 =?utf-8?B?ekw3N0ZmVTR1ckNnN3BXbkNNSFhmVmJjdS9BZFpIaFZwYWNOdk5XbzhVS05I?=
 =?utf-8?B?dHMvd2dyU052REx1MnZ5aysvbzJNanZmeVZiQVE0TDdWMlBET3RFMnlBcjhC?=
 =?utf-8?B?eU82dnQ1bUpUTld1cTZqazQ4Rno0WUtuRnRiczdaVkNvMHVZbFJIVkhpRi9C?=
 =?utf-8?B?WERGQTJRY1J3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anZEbEloSjR4L0UybkhQNjgrb0VyS0Jld0JXRnFweC9TRFZsMWtoNzVEeHJY?=
 =?utf-8?B?TDV1NVc2SlkxamVjR0FLcVlBc0tROXU5YkhEU083VzdIQjlzU3VJNzk3ZVFs?=
 =?utf-8?B?a1loVHM5Zjd3cDdiUW9kVExwYjJsK0lUYUJQWW5mQi9lZFo4bGp3ak9LUmFS?=
 =?utf-8?B?SjhSQ0dHMjFMUWF3QSs0dzdFSUpLcWVZM3VPMU1nbFpmb0tTTE5rTmtpdDZP?=
 =?utf-8?B?N1lqK1V2bWczRktLU0FTYWtoZXBzVlRIYzJZeGwybW1mWjRoejlWQ1hVcFNK?=
 =?utf-8?B?LzV6YkxTYlJhVlAvQ3dXcFZlT1RTOVFpcGRWOGdmWHRMOEZndTYrTHdUbDlk?=
 =?utf-8?B?dkdRRnU2MEwrbnR5SXdoNkl2dm0xa3VTajlFYVhLZUl0VFVoeDRQZWtKV21q?=
 =?utf-8?B?eVNacXBmV2F3U05sMnNodmlkNXpSdXFQS2QwalVrSUhreHNTVFN3eG5wVVd2?=
 =?utf-8?B?bDFDUGJjekdpc3A2S0VUN20yUFlXN1N0SjIyaXByTE5rN042UisxZGpCZnAr?=
 =?utf-8?B?aFowdEttcVZXdDRZd3pkUWNUaDFXQXdrQWJKU2swTUtnQjVDc3dLeGhLeTcv?=
 =?utf-8?B?eVZweUVpa3pRMnBTQzJWd01qY1BCMmVPN2hNbmJUeEJuSllxUm85VnI1TDYx?=
 =?utf-8?B?UmR1UE1oTFdEWGZ3a3lPWGJFcDFmWGpYY09jZzhJK0w4T2pHT2taT0IxUzU2?=
 =?utf-8?B?N0NwKzdYdGM2bHV6dXZ1dTlBZ3J2S3VJVHZhL3RHNEJUQm45NGdjMVRPMThv?=
 =?utf-8?B?MENHK3BCY1ZUU1QzZkJTSStXc2d1eUdsYUoraUh1SkJSa3lUTnpzZFFscTFC?=
 =?utf-8?B?WGhxbEh0cmpHeksyTUw0VURhcDNlcHpYZzNsaGNlMlhKankrTDQ3cGFEN290?=
 =?utf-8?B?M1BIRTFmMFdWQVlKdC9GQW16a3ZDL0o4bWhVYnV3WC9OeEIyVHRrQjZWOVdp?=
 =?utf-8?B?K0Qra3hNTitscEZVbGdGdmlCMFdVZkllbkhJTThCYUp4TGdHZHhhKzVKaXE3?=
 =?utf-8?B?NlkrV1ZGZDg1OXdnYzdoRWlwUmN4QUdUYkJ2UzlxaFQzTk5WZDl2a2NBbjVO?=
 =?utf-8?B?dnZ1NkVHczUySDZGZG9FNTl4TWJLMlhZM3J1Y1AwNitGU0VrWHpNbEJmbVd2?=
 =?utf-8?B?SjdoUDN1TndBd3F3Wm50K0dpMTFKSlYzVzlqNVN2Y0dQYm1HUUhwUUw5STBi?=
 =?utf-8?B?WU1TbWJtMEE5RGM2SmJMRDlhbEM1ZW9Pd1lobEJDSHljbEtzSTVCUUFuZURT?=
 =?utf-8?B?a015ZjA2WGd4bldnWnMzZVF4N2x4YUs1RVpYWjVTb1pjdncxRkVZUW9jamtU?=
 =?utf-8?B?bWwyZE5PQmw4bW1CMGFxL3RjRUxVVzYwZWxuTXBkZnFJN1pMYTNOZWhOUkd6?=
 =?utf-8?B?dUZ5bDVvYWxkcnBERDY5MEF4RFpNSm10cFBLTzJCRzlkZm9CNWxYSXVUUGJR?=
 =?utf-8?B?M2hUNkNIZ1BuYUtEdFJCaFpEZ211Q3owUm1uWTRSdHlKc20vTDAzeGs0ZTBu?=
 =?utf-8?B?OXoyeXFySTl3SVlsOEt1UGgwaksyOHNuMmFYMVNPOHBxeFlNQjNRaUdIM2hJ?=
 =?utf-8?B?dWpaeXBaSERuR0hJUTJkdzkvRHJvOGZaSUF4dlBjZ2JWSUhxRGNIQVd2alJQ?=
 =?utf-8?B?enlrQzhOYnlBdlZyZXZDNlpUSjg0UjF1b0EzTVIyVTdKOTRWamhWdS9ydFA3?=
 =?utf-8?B?SDNiTFZ4L0tCMi90WVluS2g1TVJDZE5GbjBFbmJFdjlEOG02Q0x1S3ZvdHps?=
 =?utf-8?B?ZlVCelZSMUlxN0dadm9QRGJrbFd5REhRcFUvencxS2JEODN5TEFVa0hVdWpE?=
 =?utf-8?B?OFl4ODUxOXE3dERibHF0SkVvS3BRWHc1T1VKQnY4VWRCWVZIbGlJbzRncHc1?=
 =?utf-8?B?SFhkWTAxdjlUbkZSbTJHdHArQVRDZ3NWNDltYktOZUZsb3Y2R2ZLT21KTzBH?=
 =?utf-8?B?cHlhSkVJWXRRenh3cGpIU0pwcmptVmlEbHpNdzh4UGY4ZmRtRjJPRDBDb2tM?=
 =?utf-8?B?OFZDNUphMmpxck9TcGtaZXhhMndNb3U1QzJkekVJT2svb0hpbHRlNVFRZEdx?=
 =?utf-8?B?blg3K0s5amt1cm55Wlp2c25QdVZRL0Y2NXZwTGJXNkJUaGJ0bFlJcHY4NnFD?=
 =?utf-8?B?QzEyRm1KdEdZTmlYZDNYNnB6VXljSmpidm1zK0VXSW9lZmtteEhkVy9aeXlw?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mc98pCVzVC2zYpHTJ95H2vwKTTpbxpwIZbsjRiA6UbJUZhBfJPp3y3psC3hmBO2KAEXYn1U5icM85QxLzQaffFJPXE0kkfDghga5hsu2dk0sdLMOyiOIa1QXdsBz4t01JnoDB7M8UEVgJCp9SU+NU+NYjFcW7Ale2PCn6b2D0uGLYZIcXoyIgLAApU43hhV9Tqni84+qPiMxIAxPPb6ImjgWlXo8i+W1xeY33ZML/+TZ9owNhLcG3/4Dthx2E2l+jB17oYjxCsOQVB8ztXrIby1QX0I4IRPMweAkgcqsmhKH6T4dB8YnXQHyC4NRz6pcbVyj0BrYJ6zG53XcP/ddJ9ivGU2/imAF6jZ/8ctBOHhX0HETAP3AB/jpqsKcG3nwc/BwoZTSBdIUR2IqqAyflQvP12UNxVgCuSDBM/NXw4o9mB+RRWjaCAxfPTM8wIPkRiXSFDIAmLr0TSQj7I+rBg0qXWAVfObfZRV2HmFUxrb5pZgaaLOqhN1z2LNaXs1oIoDtJK4uft1AOyDX5FBGqlaD3XtOL/zjG7Cnne2VX7ZcKdF5cuhMJFJVLEOx2A60P7RZp41Oido7eN5zyKJQtNtXy/XZxk/RMzQLK8zP39o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3cffce6-97b3-478f-836f-08ddc7dec41f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2025 22:42:54.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJK5/OpLCyTbFrx1B3zy4MSnoEMmRQ1idE18m9ojyUflaMQZbAl8AnM73UsBTeXTdBGsUumvOEB7MO9NWDV+PfFXYy8bFtt1jtePPQLU64o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-20_02,2025-07-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507200219
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=687d70fc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=G64K0hbfk6-aH_f-3oUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DnBd-yt9shatDKUl4N72wlG2mo3C7e4_
X-Proofpoint-GUID: DnBd-yt9shatDKUl4N72wlG2mo3C7e4_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIwMDIxOCBTYWx0ZWRfXxptNymucS34j
 gAem+jupUQ7VpT3f56yVBMZcuiXn3Br5abYSSH0uQgLdd7XWclTykre0aWosCiI3JC1N1VCqBxH
 sMoGKEbdS8v0NF0LouJpW71RaBsNo1FuLX0w2x3zNE1tyvnFHX2Dx0G+EHVqKJrZE86E8lUR+Tn
 pkP9MwF9zRF143V4K+TI0iF3fCevhmjLffomp5F3Q17TLbL/fkjsLHkrqV51mIfXsiMMOdzE0t4
 ZvQKCv3bnoY1iBKgaRwoPYJ9xO7CV+NzBSONh4496JpJSHBoXe1iCOFjikM/Lvt0es7vW4A1ZfV
 sYuROCwpx5tcqnQcCSF+IcfEnxc1jcpAlNZXgsC3KXSoFWrPTIYa8SURrZbzyDnUCIZtxuCjP+q
 cRR34/m02314befUffuc8B8bH0ZS3FSZW6sw58AhoN2xmCl9m/BkktZGXBpw+CiftNardtO6

On 5/14/25 5:56 AM, John Garry wrote:
>>
>> +    put_unaligned_be16(60, &buf[2]);
> 
> this is the page length, right? if so, can we always report 60 and ensure that the atomics and other fields are 0 when they should be? Or does that violate the spec?

I think it was something on the initiator side does not like that
where it uses 0 for the value instead of a OS's default.
