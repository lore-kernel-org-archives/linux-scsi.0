Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346871A239A;
	Sun, 12 Jul 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879584; cv=fail; b=oZPCeLNXqVF5+hd53uAXjXnx4UMTitSYPzhdKRUAWUPWdezQ0q8uPcHtF5yf9DfK5RJRwOCG1DzJyY9e1xwuNH4gT4q7Feea40UA7qZD7q+mLT8899T1EWXj+qk3rN9TxbG6oA9ojMnKuO8PSTvJJMsJ4W3MLecgjQV+xQ5b2KM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879584; c=relaxed/simple;
	bh=fpABYz6ghys9SbrrmiXFS7L2iFca5v3o2P1SqtqXg1g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jd5YA/VFPMSrlDovrEkktnjRH6NeOppNDjTz/FjADcw3QQkyJByXUCQmg0ObLQr1i2jqBa356vx9H1C29Kt8HuMxSoInl6yF8H0eZJXfz5t0xYznkxgcvEEhJT6L3YrjHxMPa8XrUUkZZ/ArpSPaKygDTQk/YtmstDw26f3VZPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EizoFx8w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vkFcieqG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EizoFx8w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vkFcieqG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CHhth33714215;
	Sun, 12 Jul 2026 18:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=esJVucpM3mKHnAOWZ2
	zEzq9w1SpJtykk2J+HUulxBJY=; b=EizoFx8wJQek+ZGN5a+7F2NKd4VjMWavW+
	iHfFlSS+I3HedEuzZoRW/v8W8dbwL0Fie7AYeODN4ELmHQFU4K0F42QKonot7uYL
	k7FNCqoBK6BaVdUlwzyLrYnBodEpMuHkDvDfgy6iEFUYLwsXnhMALe6laRt4qpN7
	HT0wqcEiVtL5hQWkA4/wdAABnl6WaG0EFi2fhMS0ZfKJcWKTFx/azA/SGBXy/ESh
	O5phxCyzsp+dA/7WQ/MaWHDtRNxZXcOhuRhKAwaM0qLspgCRyH/42GAdku/2R4Wr
	TzC75g1P7K4/u1ZJ9yci9nvI3ywwqYBmkXJp3cAHdVNhDnYz9ZCw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed294tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:06:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CHwYX7017533;
	Sun, 12 Jul 2026 18:06:11 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010032.outbound.protection.outlook.com [52.101.46.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fm14v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:06:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=srMcInXX9vqTPn2Ylh7Bfc4s8TeQ26vwaB/FuDjAnXDorp/ywWHBxXiAe0DL5Qtx1pG8i4AVVweluuMsI65VxXqO0D/qdqYLXBgQUc21T45jWogUDDUR4MCv5Mm7mDZDcMtiqc2Vv/Z798kzwp2G+JZnns0NbpU36BN+KGhWR49d0Dpvc59id5bm4Uf1nL5GVNy6In4e4z8jJ7iu6CVTag//5w+U9QcqcRDjjDET3fqQgyJFi0YRWUoOcl4aZE0X1vsCnlkw6YXfltr0GtwWlBkl2v1aKQiwx/ZGmhgw9+yFQ3B7QgQwi0wBXjYDUtNVkZmAjLipLsT9xJpqmcUgtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esJVucpM3mKHnAOWZ2zEzq9w1SpJtykk2J+HUulxBJY=;
 b=y1Nrik76Zh4WO+rhD7c8pRv/fXSKYU5WShSfdIJ5BVYetQIMnM0lk+ndkgTuIaVgUiMgp0V0rqdvO+BXMM24dt3YfasDvSwYo9JI/BmYh/1IERmUhijHz7burvU35/tBjKRgAPBVZJyIR6SF3dmDTXfYqcWCPYWrDrU9poK2asnvFz4WGn/HCbzfEr+iI1MBPtcifsy3OJ1pTsLJz21NFOaDJgTtZh3Jqs8RcRz0JMDkAeWaIXB0ehgPFzH2qZhcDBPVU57cPg3mkyWba1gdYSqn/sJQ2NjZCBDbIHtXY0inj8D930SagQeNZTukfI6iIl64gjZL6FETDxKYAQtvtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esJVucpM3mKHnAOWZ2zEzq9w1SpJtykk2J+HUulxBJY=;
 b=vkFcieqGW+tId4x+Y3Wd/RTCiRuhxSl573mqXpTX6DMvV/L16R0RiD1ByEk+Y5JXphhmxUpJqSD9dFOI4Jafc9WXxRW42Ciks1bilcseLoaIEH8f/tQr+mLbi2EjVliQ31bgOTzQLCK88vTe+nNmP3vb2Fv9YA2+2tYV9uBzfB4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:06:06 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:06:06 +0000
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com
Subject: Re: [PATCH 00/29] ibmvfc: Add NVMe-FC support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com> (Tyrel Datwyler's
	message of "Mon, 22 Jun 2026 18:30:06 -0700")
Message-ID: <yq1wlv0dqws.fsf@ca-mkp.ca.oracle.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Date: Sun, 12 Jul 2026 14:06:04 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0228.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 7122270b-e1a6-422f-4ca3-08dee0403e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info:
	gzLBNguu2HiMdqW+jXC/vIFOj11OzoTD6c+SIGjpLR8DwYzxr6H7oj1a+o/l/fBL+Km0s/5Kb0GKTLwOTyLFJVshl68iFsaLLl6srdSikttbEmKstUmcdUz+etT5dClNmYzJnaGj7e6HKBsi3C6AJsfNBUKgNEvyioNOt3P+FCrPFiU8i76G5g+GsF7fXDedWPJJJU67B+CPbz9r6CJ8s1xdrvglm8F0DVC3yfF551z/XLdpH92SooauLQxr1FMcIv8dTqdW7ez+KjdS6PTGn8WaGZG14cFuH1cOepbxm9Mo4KStvJstN8x9X0/pb9EmjnwL+kO2QFeoRBzsg1cZwIXocmLkP/8hNk3IMpD4pP0RmvJm4O10rBVXEjErTTZzXV5O0IDaSc/oZcHiYhRKebDgyNrg4nKCa+hmRXj3EhqRvLYLK++5pGzmrMWE7mUrb84N01YwbHWaRhTBXIQjGQwNEzHdRxtTlJXoN6xWGVs1ReDSg0bjHQTLgaDYbRWeHwnqVRJXWCkrrOslPN/MOqLYpEPhfy8qq97FQse4CAHeVFfZmIRU5EFRT1QrvXQSgiiZDrTW2kyxeQRySIqWnXibHVhdtXcAlpCIf/wMBJhiGZwauCiW75QfC1AEegNrus/3JKtneyYIBduwf3F4Ttud/AI+xQGu6t8LlhPq00o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nEedezPR/ybH7T+VkZLsOjj5igMY9/pxnzScer2iyGwZbdE6a+lQ020OUta2?=
 =?us-ascii?Q?N/hLVE/P9meDRr6hekLzd+saRxrqbziDv0g0WjzZfZ7KxOTOKcvk8JlUFA4k?=
 =?us-ascii?Q?HWICUQNWxEnEBxHJ3Ya/efNCOIwkXFWpHtkQCnyPaDtntU7/sYqfeWtiH4Rw?=
 =?us-ascii?Q?oCnIp2YWNDETqB2iMMy5CuBMSzZUjH53GTl+VAsFldAHIdZuVRBG4YnRsO/x?=
 =?us-ascii?Q?YszvPCga3TIkBR9dhxUl9OFN9Y7up7Dn68dBO8mtIsO9A2EoGDwy8UzlxDtA?=
 =?us-ascii?Q?K+eo0Y9G6luJdEua37wezbcuVm4MfMFk/SICBRzuzcjTAQdz3ZLPH43tFR5R?=
 =?us-ascii?Q?g1AUR6I9cKQF2Tz4QqW1AvbVXghQ0TdGzS7nO6vFM3ZrBexdKWJ414geET4O?=
 =?us-ascii?Q?wlNNQZQSZOf8X+IykRTu2AkZRa6PV8cNiw632VvaUwa5s44FIIxpjRK75uoc?=
 =?us-ascii?Q?SiDSl42umsS271gbehZ8wMp4E1F+LeZvS0gC5TYtIscCPfDYzM6kDY7iW+WP?=
 =?us-ascii?Q?UHxypFVhWQQDaKfI6yZCdjFnWAr3jnYre0anU86iZUUmvRQkuf4Bs6ARw+Sv?=
 =?us-ascii?Q?2Vpir8mX7COJjtc6wU/g+ZJHK+6J4bjIxKRQOvaKkd4zqZXy5ERjTayoCO6b?=
 =?us-ascii?Q?aY226lLm+Uq0DywAwkmefjzMnublPLJcxUZaDXOYbCyZCcyFm5fFY3E7TKM5?=
 =?us-ascii?Q?aOYLx6BPCiMsqmSbhl0LleMcs7T22U8dB3yqrDNlnyPIG4g3Iu3sj0aYKvxn?=
 =?us-ascii?Q?FQbWzjJbbj7x0dx6EfD2xBu9b1bMf2YPD/jUrCOLpF28LIYDJI4B+Eixm+J8?=
 =?us-ascii?Q?8EDtZc+yTMovInfQ8JME1iasUQMdhNNWhB68e0FjOCAtOnP/TULvLwkVNQn2?=
 =?us-ascii?Q?akDTo6skd8k6bP1sBATVKEw/1DTsYWqmtlwrzcZn6Dj/kUiA8gAXoCyMrnme?=
 =?us-ascii?Q?IvAmNcWD+OLAytHuuWW5l7oPWaGb20DyaeiSkfCLv6dyXJ4p2Nq1siy6X4S+?=
 =?us-ascii?Q?TeoRmWUG4kGMucfvf+Qo8Rkbsex1FgiExa4VRCKKw9H0strup/ZOtpQPAcd5?=
 =?us-ascii?Q?Ds6xU6XOCKwpeKwDgaRZSvhAZSd3NCC7zDYn8Klaoqt5+AEbxBILfVaQMX2C?=
 =?us-ascii?Q?KfRu5wur7tqrxLLdzCpT+Y9ECjw/ZKeJely50vqCftfK4boUb6sSbEMpZKKM?=
 =?us-ascii?Q?xIwSh6+Iyoe1VoaMwR1l7bKg9PL0NXprIFk/CMHtwu3Aql8fO8RDTu+/M3Vy?=
 =?us-ascii?Q?iqwmchZIDq27GkYvnrPGmeqp7YRr/L8fH0ly/wfVNJa7Yz6dqy5P+B/ZLgns?=
 =?us-ascii?Q?c1yaEN2a0sK/eauQGNlxrM/UebwgCd/j4Wwg8LlE2kIXQxjke0ij9H65pMR0?=
 =?us-ascii?Q?Z3bSOAMVriwPUyK/gjMhitxUt+cO7nMAu5gwM6anGm2r1hfztpfsz2FUEB+M?=
 =?us-ascii?Q?FyefKaEP2TTBYjyTjA+GfHcMGNzvnaie9A/7RsauI+tnTPw+Ekmkk43n+Iig?=
 =?us-ascii?Q?ZLp8lt4OaOIl27c1RNzsMBeZSnrN8axJW3S6va9hVktcld64m3S4SZGGXqKi?=
 =?us-ascii?Q?nT8ch+GO486JyF0U4E2CGhHrYtddeF5RdEjD6fEBxedAt7COMxvKOn2qEhx7?=
 =?us-ascii?Q?vP5I1dYdckRrpmOMdkcmt21kEatBngvKT1rQvnWuU0KcOHWMtC1or3dzda8R?=
 =?us-ascii?Q?BMs8AfCC5pb1SW9DKyTH36Efg54o2A4RWglZkyAkHD7AHMLLpgXTjIswuvvT?=
 =?us-ascii?Q?rV/GxtiYFOfkoI0tOD2TWOJE0UA3L7M=3D?=
X-Exchange-RoutingPolicyChecked:
	Ak5dUvYt7XYHI15aplhw9bDF5rlzno7JSfKmyRRIRwfWjPxWIJr+90RYLCR4TkMWe1GN42FM7zj30ylSUwdBEQxS+XH0ZZDXBXn/sG0VECzyHLNOfCiL9p4ITrhyozp1JZeWabADcaNRwQmRSdkH9mKdS8Hkn4roBg1gRe3jXRUkUcGKmbXBjnI442RkTktqSW32TPSH3YaXtZCTo1cY1B5jnK0KrazmF8klyk3l/5QGA0oxnLSJKjmAyZQ7UgSa2e2tVuO9FvErhiz0kIJNLbDj+i1vwFeUHGU6eTx3AGpZxUHVP0wkwOxH3Cj2o85+HRGejvqthYmhSk95dKECzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+tW93DkmWt5/km3Qbf7tdi5mRwtbkClf+5FHmSqXxEuXGtVguVRY0kRPbW6nExI5lPozxSUf/W0d/VdsW1YDwbEskj91BzTXWuQpKVDbgRb/O+UkorUWAPbwrcehxiwP+MCgEASv6IjDTgG8tKHG76vZ8GmW6f7mXu+LS1T9LzKQymS3gkigGA7O8HzTU++f8qvxg8N8K2SzKYfXKJ4kN9qMm8kt9EKIffxxBNEI4xm9ZJwzBhwu+5tLVmClId7CMo5rVAmNim5iNiKlSrE6QvXJT3w9GDp88ps4PLzCEoqIeGsb3qqwt2t0s83yRf0U0t0otVmPbIJYwGFD68uzZOREHh1XcoDS4JHovhVaFKCQqzjBlkuCurOUztAO988i9mGQEIYSdVu4lxPv1vOYaGvD7QjPGOOCaPdfMhq39BR13cAtGNyujlcasg2urCmOG45muqCM7rkfpSX1JaupCIAXuSEF5TEGGdcaQnWfECKaKHBTFDBfxK2kITNuRY7WOlQK5J7VtUZNiDBIZzW1zDK5dhNOwCrocMyxa0q3855gCivIeEEJuGMREnwiHIY63BILDtlIoM2Ezpz6PKlKQ1Unm7munbl0c8lkAvSHEoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7122270b-e1a6-422f-4ca3-08dee0403e52
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:06:06.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/XPohGNv+xqhs+iGVJakodwBgdejvM8tku6kRRY9iC9V9ph+aTTt3na5c6XPS0s/iS8xVU6HSoPw6cwdNAoij6PxOhgL/KkH+9N+gFKwwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=649 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120193
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfXw7d88W5Q6w+t
 rKaU0wzQUUnH6FvdlZS9Clqcy73VZwnZh1BMPujzBvHdFRlGS2jEy4D5Lr04ocVdbYGy9R178oh
 D15FSsxiTffpuPzGmC6w1sLoUAuf9i4GEkdKS+w2FNk3x+mOpHWTHVfAArUMmXBjpuUsIfW2K0W
 I4XvdsjRx5xdyOT9d8qTMSlTpXTM5hzsyh0GISmlmraRjoTbMSHPD67K8Qf6NbAc6Ypos88RMA1
 ezgmfwF15zpxjS0k7ulrzyu8V1TB40lXRbPpNkCAnL+dnIOlLmTwqwHPmzTHE51iXEh+BKoA5d5
 aVi7cl+XDsX3SUoS4Ckw1+WhxsK2AA/oleSFx7QZj894Z8JO6yIIBQu8vlAYqT6+hMJV8ws0Coa
 dk+dXMlMVtvvo9/6wIi+1JRWTF2j6vYUZjN2sPRfq4explA298vs6ym07UQET/lmCheJ2/LMFET
 4KU1Ks5iNIU+zksUPZxqv0znc5SvmITNTQO8A1nI=
X-Authority-Analysis: v=2.4 cv=GcknWwXL c=1 sm=1 tr=0 ts=6a53d794 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=aVLt75UyfqpH5wJXYPQA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-GUID: mmPGZUnVvChln0TgEaSv9pXG0je5j0Oc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX4nlsYOvGTY7S
 bzCcpWgdHVp1YRGGzAjpN2mdiEgcMImhesnClU4yu8DvON1eSDi3cZyKfPp3Gc/xBMrhx8pIBQ1
 +2VM5P3FZ9YXWEomvQsZ+e+oe4N5Y9DefnjsYYF4T3E6D5fwEEKr
X-Proofpoint-ORIG-GUID: mmPGZUnVvChln0TgEaSv9pXG0je5j0Oc


Tyrel,

> This patch series adds NVMe-FC protocol support to the ibmvfc driver,
> enabling IBM POWER virtual Fibre Channel adapters to handle both SCSI
> and NVMe storage traffic through a unified driver architecture.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
