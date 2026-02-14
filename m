Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CC8261B71;
	Sat, 14 Feb 2026 09:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771062176; cv=fail; b=Hm2diVswEMV0ic6BbZYCMma4cw2LvW6e8yZe3zl08lzOCWhkOk8GcyVo9tnscmusnHpnFzVEQ14yG9UpepkHUiuYCn6svYBDpUVDTSMaXUyNcuvNfEBi3SjBltdupkpedSBeZfacknR1cy6C56Suu+7TQY4G0+ztlzc4enGK9gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771062176; c=relaxed/simple;
	bh=xW1qsR3ToVUEw8wVHTijjVI5AnowVK7X31Q3TVyxN+I=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pvSiq1jw5dS/Vh0A0qWNt8HK0xB7i4CZ1AsfnVYTPDHJbUl3BPFrZw3vkfC5Bv3hOlTP69a8JT54TtzkV5OQQzJcHJIJyLoyRaumOGVcLwC51sY2nQnqaVxVlMtD994DQgaXlsOHOAF3oTa/0Nck8fYDJI/gcsGvfDEFyXDL53I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZS9fBFqv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XFm2Iud+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZS9fBFqv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XFm2Iud+"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61E9Ttu81321990;
	Sat, 14 Feb 2026 09:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LpRTRanRMqtls3XeOlZVL5yRL5PH1I+jXIcEnRaQ76c=; b=
	ZS9fBFqvr/LhXicQ3+K6g/zAR1wR1Gj/CGbOWk6+p0xgPMClpKJZyJdKitbloKs9
	F7rudnM2rIVVbgIBSyHJQFnhnnHLnFAPJsYyRX06Ar7ukUYmx8otEx3LkdMDXjZ2
	8iEvySnu0tkN+k3x7I5G7Roq1kEHIjcmD4s+JfpjXjot+WCp0YTdVT8ZhG3xR8TU
	hUgMI3wp4efBPl7XJU3huZRYkFvsIGv3nsEPUn+IkwTeKHx7a2ePMMB/Ma9OzePz
	pSwPyJCKARDxqxhwelMSBqTScumkr+zuLARnv2ImD+yo80EbOdbi/3LPJ3UxGbKC
	JxpmNnOpsKJVBzwU/zZnCA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj6m841h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Feb 2026 09:42:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61E7Ijqn022917;
	Sat, 14 Feb 2026 09:42:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013008.outbound.protection.outlook.com [40.107.201.8])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cafg6gahn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Feb 2026 09:42:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JjubvPnPlGLtxGPndSYPbkZTjnLYWaqK3a3Y7xUdPCJmrKdJQsAuH3FdeJKtgUcnmlTCsbPTc1fUvVkgdQlVmPSfmmOfPjQ0bQCmAXco6nDeoLJHKoJRk86rjVgl4MSXOiu0ICWEnMCUC3+5qUnAS9tVEXqBDERRNX3GCU4n5aUpV2eN9CKjy1/ngDL4cYWGx/ujbNn3SLisB4qnzPIfPdbHGXcCDUTdGE3+aS37BNGhwuA4OU6T0DsY8aGl+iz4F2feHTqHldwPj9t7t9d5PAaO3SkIgxIR1Wq/GQ4cDI4FpkM3GLqkdRLfixHmijDOnzK1do5tlINryrmYZezChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpRTRanRMqtls3XeOlZVL5yRL5PH1I+jXIcEnRaQ76c=;
 b=Ht3IhwAyj+YQBJgoug4F1eQJm+/CWEREwkHMaXuFGfXeTSTL0on08CMwPW6v7EWBkFYESdYnS+T3yDM4GsRSPqAIJwo0PoQO8N2eDT+SJ4D5TD6IdE5Q6jLIktZvHQzy3XiFt5nyCpDeJHhDEw+7pWikaY3WKHveK+BcOxFA87xYpk3V7Qpof8DxuT9K4SLrC575sbHTmvgdYHiDQ2+qFHeH7fMdFRB8jCgjC4Pdi4O7Wu/ooz2XOpAS0icx6fGX5qCxNwmPwUGG8aKlGmzUCQLv5C3saS/Prfs4RonE3gDeM0dDhubHlDvwBd7Hmr20xZa/YroIcLmGU09ttmROKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpRTRanRMqtls3XeOlZVL5yRL5PH1I+jXIcEnRaQ76c=;
 b=XFm2Iud+T8fJMJIwGcTINKbWl+ikBk9xfWaF+PWqTSa7L1NTVS0ia1URvDfbJlIKrrqtcLF1HTtashrM4VKWRxzRgFbiaOYY5cmxm2e5X2oIR+iy8Zl/k17U56NLjJ2FeRO+hC2abW+iM7c2k+tYyhvrGWMMx8PofoNn1PThMYQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA0PR10MB7641.namprd10.prod.outlook.com
 (2603:10b6:208:484::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Sat, 14 Feb
 2026 09:42:34 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%5]) with mapi id 15.20.9611.012; Sat, 14 Feb 2026
 09:42:33 +0000
Message-ID: <dbf5fbdd-8894-40b7-b574-0c6385995ec2@oracle.com>
Date: Sat, 14 Feb 2026 09:42:30 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <b598c5c9-6732-4661-85b2-7ab10a0830d4@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b598c5c9-6732-4661-85b2-7ab10a0830d4@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0109.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::28) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA0PR10MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: bbb2d522-8772-489a-8bec-08de6bad6125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEtmY2Uwb3VmVDFKeStabUpJNEdFUWRiWDZOQlg5Y0RYbU5xTXZCL1lGaWtE?=
 =?utf-8?B?MEtwMWNOS25iSEFTNjQ0d1k5WnJtOC8yNzZWbVkrZ3FuQ3VMbnhRVEtvVllG?=
 =?utf-8?B?QjcxWTY2RWRTRmw0WG5TKytJczFRTkpqeHdoalFoSUplR1hoVHNXbHJvWjZ1?=
 =?utf-8?B?U0hPWFpZU2FIY2VTSis4UTJsejFIWXBvK2ZJV2p0MGkxeHIxQVNjaTd1NytR?=
 =?utf-8?B?Q0NmUU03c3l3QWVyWWhXMldVKzJPOHFlNFkyMXRMMm9FMFdiYkhXSExjei91?=
 =?utf-8?B?cnY5c3ZqR1NJYWYyZnVwcTQ0MnRmWVZ0Njh6dEJ6WjBHSHJ4K2tYOHM4RFpo?=
 =?utf-8?B?VkR0RTRqQnlma245aWlDUDNBL3cwKzdtQS9TeXJIakR4UVhrdlVWcGpVUHBK?=
 =?utf-8?B?VVdWUFNBckZsRnNxS014dEEwSVY5R245NCtmMzhiQVZ1VVIvQ2g0WE1kUmxs?=
 =?utf-8?B?aW5XOUN2RmxsTFl1VHhsRmFTSVpkWDJHRlZGMVZ0eWNxMzRHbXdYeEYwR1RK?=
 =?utf-8?B?OW85b05BcXppSHZ2d2pzeVlEZ3dQRnJwVnhVU3ZEVDJNNDZ2d2FxdDFLNjQ2?=
 =?utf-8?B?UkdFNjYyY21acVlzNDltMjZNMkdPcE1scUNvTURPaS9tSUlTTEI0RXJ4em5a?=
 =?utf-8?B?dUIwdU0vWFFvTjNEcXJyU2ZCaFFHNE9PcTRXM1hVNkRMcWpCS05vV2I1aHND?=
 =?utf-8?B?dkdJNktyOG8xVlNQTTZma3VSV0hMdUdEVEZsSC9qY3NMbFgvQ25PNUNmZkho?=
 =?utf-8?B?RjBMMGpVOFJsZUxraGtoT1RzWjFnZ3lsYjlyT3JLTDN1R0xpT0daSlRsbFdn?=
 =?utf-8?B?bWpiWnFSRWNQcGZkZjVMVHY3UHcyMG9tTG9lelNxaEMxUGhTMjYvUEtUUzNZ?=
 =?utf-8?B?MDlwNmpBY3RXakR5MEJVL3VHMStYd1hacEsvU0NkSHBhV21zUW9CQnpQMmd2?=
 =?utf-8?B?MmsvMFROcWg5eWlIak1vOHMzS2NpMXJTcW9tcEJtZ1ZWaWFSMXZ4ZkpJVDA5?=
 =?utf-8?B?UmtSeCtyVndIWE9Lc09FZFFQSEVJd2hQaFZrWk1BVVQyK3JOc2pucGlLTis2?=
 =?utf-8?B?OWE1b3V6MTRZSVE4NkpJb1FYQmpTUTZEdWhRRm5RalpOd3dVcFdxLzBIYVdm?=
 =?utf-8?B?MW9ndjFYS3gzLzBzK2JEMWJxWUJTRzdMandNdExYS1BLQzF0MW1OSDFGVk1B?=
 =?utf-8?B?T2FxQlVvSHRMM3o5dzdUMXEwWHRNRHcwT1RUOVRDeVUwbTBuUHpWcnpsT2U1?=
 =?utf-8?B?VXB6TnhMQjlFbHJIYkhkNldEbTZGaHdPQkllejlVbldzSERuSC9Hd3ZnWnBX?=
 =?utf-8?B?b2JxUzZ4ZHorL1pvT3E1UC80Qnh5QUs5V0JjSHR5THRWUGpQK3NFdE80U3o1?=
 =?utf-8?B?dkoyNEROU1FZdGRmQ2owUGhteTZEZUtnN0s2enJXa1NtYU5TaDhPZ0w3c21J?=
 =?utf-8?B?K3ZPam1KK0NkenN2djJhd0YvSW5WeDBtbVZybS9XbTZZQlFBTFVEcDkyOWNn?=
 =?utf-8?B?NkhzVWVqMXlBYWFMSXdCRDhDVmZBNjVmSCtCNnk1ZXlmWklPdmFOSW5KYlIz?=
 =?utf-8?B?S1V4YmxjSHNzdGd5d3BuWExBUHIwUWcvNEMzYUJLR0dCanRMcXIvQVFQWXBx?=
 =?utf-8?B?clJ5TUliR3NMQjQ5cVhicERiTU5YVzNQcVY1RE1KMG83U1M3bE5BNTRDcFFW?=
 =?utf-8?B?aWxSWU95UkdxcDNEQ3NZd1NpVkswSk9VbzZPL1FUYWRoTENXbm5sRis5R2sz?=
 =?utf-8?B?MkJVNCtHakErRnBaWTdRMmpXKzZ5KzVOVmZPUG8yMXRQQ3dpZEd3ZVNNajJG?=
 =?utf-8?B?OG9NSXZTK0wyVDZwT0YyZFdMNkFXekhYenJkY3ViVlVBZDNSZlI1UmJ0ekdM?=
 =?utf-8?B?S1ozN1VxU3JMVitHdjRNeXlEZGlnNmQvNkNkRU83NVVzeXpMZENra20rRDhi?=
 =?utf-8?B?K1RsaFFoOHZsaVFUSGNZeWo1YXQxQ0ZTRzV0Vis0KzNOZEJKVk5TMWRLM2c3?=
 =?utf-8?B?eEdCeHRsbzFkcE1uYU9Ja1A0VUY1bnRDZjRzSHM1VEJSZ1dOc2tpS3VQWXRN?=
 =?utf-8?B?Nzk3cWRKWXZyblRIQ3pTM2x6WnVyTlFGODNzR2JLZVBVSDh1VWs0THJVZHAz?=
 =?utf-8?Q?b5RM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MG1MeVhZRHFwTDEvZFptK21HOFAvN2R6K1VJMWJmUHFQZDBpQndVMHhwZDBo?=
 =?utf-8?B?UHZSclZZTFZud0xZNGtJVHc3MXMyMHNHc2hRT3Axa0kzVnpTNXVOVUZKRTY1?=
 =?utf-8?B?cXRrcHhSNDV6enc0WmE1NmNtdTAyUlZHMUt4bkpsUXc0RUp5N0pYQmFvVEJW?=
 =?utf-8?B?UDRRZ0xDZ0NuUFZrR0pNbTRQV2E5OEpCcXJLUDhuQnZadndFQ0xraTUwQUx2?=
 =?utf-8?B?WFBlOGhyWk93Q0hWNjJzOEZVN0gwYVZ6NlF0djEwYVQvaXdrc29GZ283dUZY?=
 =?utf-8?B?UVVlQzFjQVN4RkUzSVlEdDFKbWRhTUZlcjlvL2h5U0FOeHYrRU9kRGloSk1N?=
 =?utf-8?B?V2ZMNWNBOTJLU0llTHVBL0NRalhUTnQvZHBrWmdndC9RdHdjZjZoOW9TbFQw?=
 =?utf-8?B?a3hldE9UVmdCZTZEaFp6UlUzM2dPbFo5UG5xVC9UZzl1T2FNSHNCcE1PRzdH?=
 =?utf-8?B?SGRyL3J6WVFVYWhUTXY0ZVMvb2ROWkVOU2xCa3A0MVpLNWMzSUh5SFN1TEgy?=
 =?utf-8?B?aVpqUHdSU2IzdFVXbVFic0J6Wnp5WU9Bc0xuNGdDVW10R2pTbDNWcGkyeEQ1?=
 =?utf-8?B?cm8zRVZKTzYzcVpzOFlFTXZsTVdLUFNnNVZzVk1IUE0yd0pMdC9TTy8vNU9S?=
 =?utf-8?B?NENzTndCQlFGaTU2UHJEZVhXaVNOS1YrR2VacjU5QU9XN2JGTG9WT3RRY2xB?=
 =?utf-8?B?c21JOTdVcksvRkhIZXpBdW9uaDdDU0Ryc1JLU2RPTkFxdWRlWW42ZndZa0Rz?=
 =?utf-8?B?ckQzdTEwS2FmSUpSc2pvdWZSVlhXWFdKS0lSM2xyZzd2bEZ2Q2VWWFZsVnRT?=
 =?utf-8?B?eHdtdWdjdlY5cnFEcVhoSVBoZmFkQlBJWXdOejhkZXAvdkc5aDlicWtzK0R4?=
 =?utf-8?B?T3VMRHEvS0toSjhLUmFpeWpzRWg2YlFzYmNmWDFxR01XTnoxQjlNTkJZcjR1?=
 =?utf-8?B?K0dJVVd5bkNrejhuWFdNaElhTE10ekRTL2NjQ1RTZjZtQWYxSlUraWt0eUdh?=
 =?utf-8?B?VGNmSkFLWXNQTVFXcy9mYSs5R2VFSjBoNWc3U3I0a0tjTEg3ODMrRU8xbVhE?=
 =?utf-8?B?bHIraFkwRG9CT1VFb0h3OTdNcG42ZGVJRHBZMTVtcnRyTnNxQzBONkl5enVT?=
 =?utf-8?B?OTdlYyszWDgyNjdTR2c0aENNNWR6VU9IV1daenFWZlNEN2lOanI5WExVQWtx?=
 =?utf-8?B?U2FEbXc2K3pYK2VBZUM5cXd3TTQ4SUF2Sng5L09CR0xuYWp4dzNpVmdLMEc0?=
 =?utf-8?B?Q3lhYjQvUVBFd1hWZzFLOHJtTVNQdjcyWTJPUlhHd1BFaGtCdjQzeStPdmpV?=
 =?utf-8?B?dDBYK050SUREdC9VcUNnVzNTUUdvTXpwUm1GNUdGQkduanh2dUNiVytHS2lT?=
 =?utf-8?B?dlRCdU1hdmh5TlRFYmtvajl6Y2lYbnQ0VzBDY1kzT2Y2QzYvV1YweU11V05p?=
 =?utf-8?B?K1MwRmZrRm5tS2Vjd0kwa2hMaHdiYjJWVFZLUjY1SEptd3pHV0Q0MFRQWHZJ?=
 =?utf-8?B?a1l1Qlc3bUFrRFcrYnBMUjlvRU5ldmZYRGJ6TU1BcEhkM0tOaHFjd0QrOEdT?=
 =?utf-8?B?MlRlc0tOVmZ6dVBTbCt0RytWWEg3L1M5RDkzaFV1eGZ3SWZXMnFqbHNlbkE5?=
 =?utf-8?B?bHlka05JY2U0WmZqdkZ5SVh1bTFqSDFweXI2YWZlcUl3U3YzeXlPMkx0TmFl?=
 =?utf-8?B?a0wwUFZFV3g2eE85K3A2a3Y4N1kxdnltdkRSeTNvTmNYRk9EYmlpQkRSQlNM?=
 =?utf-8?B?cE5RZHFZYmZUYlJZbDBqZ2lvNTdJZzNiQ0dxY1dkSDRWTFM1cnNNeFh1Tndo?=
 =?utf-8?B?RXZDMExjMmJCYVdXV0wyTVY1ejFSemV4UGc0Ylc5U0ZBRGtZRmVjNExHeUx5?=
 =?utf-8?B?S04vYk96K2VkKzBsM2tqRFBWaDdxMklCTU40Vk1ITUh5Mk1GZVE2bDFxNWkx?=
 =?utf-8?B?bUprdGVCUjBGN2ZwME1RM1NwVFl3WG5uUFdjMys1Z2RLR3pBWE9PVVgxakNw?=
 =?utf-8?B?aUh2WmNQSkVCMW1OSVhOYTk0aVJaRldqTDZRaXc5MnpvNllQV08yRGNTaWM3?=
 =?utf-8?B?TDdJQitLZWZmODBCOFozeUlDbENLY0JHV0w2bzBKMW40WjZyL0FlYVpwZEZW?=
 =?utf-8?B?Zk9FRzhWVGhFUUNTMlM1Snl3RTV4VnV0ZjhnamJYdW1WK0dwTVFFdFowNU9G?=
 =?utf-8?B?WWp4VWQ0ZXRFOVlWaWJ4OGd6b1lYTExTNXNqVVJROERiRURtV2I2c0lpODVp?=
 =?utf-8?B?TXE2aUVkVlQyL1FVSXFpRTZreTExcHJ0Uy91YnRYRS9JM2VlcDRQZXVvU2Vs?=
 =?utf-8?B?VFdQR1BVMFZ6dnM1bjJtU00xWmVGMlJObFJYbkJCdXYyWFVpNjUyUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k5jgq4C/GdKQCzUd3jpmL9R4pBVpJ9kn7odfrZAKmtENcHHLIB5dKgkB/hEyjBj+5pWmyzKp50iOPCGiaUdQUwNqfD5LmRi62Pz70tIz3DpMQtT6uaoonDYAWrXSHcmketo0xyzah6EiEZwPGiu3R/zDqOdH7OTUMTVjIkXodbPPhrXhClenxrlCTy0RKvK7oS6blo/YIqcyBNpvJIqg/1qeWiiwOgNiv0iyCRkHvhYsvA7p7ybInU1ZPdjfDqdlIjXBtOVM8qOp2p2NOSx8G0zXyZU2LgPjj487H3n/OG60zvpYonfsdpKl7QfQ6vhT+7/x0/+Xzy5IA8QVsMzaEr5JAMDEH5BgKjQKKqbrKalr7zwaMkuB8AKdENkfZN4yM2GuWFBfIm5xRbYt8fp/YCoJ55XiLdwdMp1qtq104S7G50derxi1mJ00uUpNvuH4zAMPrfQADmu3Rcv7ZuxJL1uORn5IV/EE9inRWm8DUB41XBo3Pw50kterb5EdjOwVIfW3dEXnvOE4WhuAHOV5y3Y2S9XdNFxiHhytknMfoIb2ktkxngACNbk2WCUUp5ToBgAZ0XEW7XNUY4DDcbt0pQlX6P2Ivm4uOn5wbCfMUE4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb2d522-8772-489a-8bec-08de6bad6125
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2026 09:42:33.7593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEHx05X0yME3v8ekuq851ffJW2NDBbRY+8KoFgqeKmL1nzIYO8PdLyCJoakXUG050GG5y7Bn+pU0T3LndJGnSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7641
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_05,2026-02-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602140076
X-Proofpoint-GUID: cRuNvrjMlQHE3QLi08E2fL9-F8JbFF7O
X-Proofpoint-ORIG-GUID: cRuNvrjMlQHE3QLi08E2fL9-F8JbFF7O
X-Authority-Analysis: v=2.4 cv=JO82csKb c=1 sm=1 tr=0 ts=69904392 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=hdyIXOyQ7RI3xzgd6doA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE0MDA3NiBTYWx0ZWRfX1AhzZGIzrth3
 3B7THTBtXv8TOemEgAqzJec/VtkiqyqLC5h1xcdoYBqIeGr5cePjJnuVJtK9N1nFKlLgkRkEzaX
 aBTAVPJoIF5fpSS3pSQjkUXH23LUsb/Q2uO3WTBd+RKijIknKsyNImND5e73iqXI0iIWQlbO0iJ
 KwNsX/zaDXk5GQ6qrqEAuw/2E2bKmt5ivcH5KmOkNb+LQO3InyeP2Xerrqys5GwqZzWB01GidAv
 pLkqROIUKIKCF5pY8tREAg2TJckLvXrudDNo6X50x50ClgE+9II3nBgrmtg8t9EHw/4UnhCM5iW
 p8Hs0/dOGoBf+bKNCHeVW608+CsSKhSBULV5gZcz99Ph73AUSMNcWX9eN2TiXusJW6E3/JujkkH
 sgAYoP+ViAE5/eFPDZVeVdFTjFxLunl3GqJunERBnYGjAkB1GybmZbX9B6sOoaGyD5LDCdzNKMK
 eEb87AiBM5XO5EcVCww==

On 13/02/2026 17:21, Hannes Reinecke wrote:
>> At ALPSS 25 I presented a proposal for Native SCSI multipath support. 
>> Let's discuss this topic at LSFMM.
>>
>> The idea for this is that SCSI could natively support multipath, like 
>> how NVMe host driver does today. It is intended as an alternative to 
>> dm- multipath support.
>>
>> I have been working on the implementation and I plan to post patches 
>> in the next cycle. I am looking at a 3-stage approach:
>> a. create a driver-agnostic multipath library, very heavily based on 
>> NVMe host multipath support.
>> The library would support features such as path management, path 
>> selection/iopolicy, failover recovery, PR, delayed removal, gendisk 
>> management etc.
>> b. switch NVMe over to use this library
>> c. add native SCSI multipath support based on this common library
>>
> Go for it, John!
> 
> I'd be very interested in that.

cheers, in the meantime, I have some comments:

- I need to test PRs for both NVMe and SCSI, any advice on that would be 
good. I don't think that blktests covers it. I did see Christoph mention 
a testsuite at: 
https://lore.kernel.org/linux-nvme/1438672271-11309-1-git-send-email-hch@lst.de/ 
- I can check that.

- I am still not sure on whether we require a multipath version of sg. 
We can still have per-path sg. NVMe does have a multipath nvme-generic 
dev, but that just handles IOCTLs/uring cmd, and nothing like sg 
read/write fops

- I have not tried to detangle ALUA support from SCSI DH, so no ALUA 
support yet

