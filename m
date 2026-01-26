Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED82882D6;
	Mon, 26 Jan 2026 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769416409; cv=fail; b=Z84eBuIobLDRBKMdDsPAr9GekjTHCQdvSL+S5w3CZhL+0bqx7DK/40JeaUPUx98icC6ZazvtG3UjtKdePsdo21CoPfTL+yDM0KtIxXad48NlBTJ5bJBR0Y2UmhYvCwZM/FsyUZauFYjmWy1ZKl/pH9sejMiWxHDHEh0sM3puRlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769416409; c=relaxed/simple;
	bh=2XowAry94KmWeWJ5JwMtDCurb7EoW+byCUl634bXQTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oALFaViUFX4S74clD+Z88KoSTGntzRFIHrkGGYDpnYYnVKX7Is7lHmgbKuFmG8EYvtRETOLN9/jtbX4AVWQ31hxq+m5dayFfHcPcUEImDU2RiOK3FHOfgYtmACXbzMiJz94NZfeJQUxrSkU7EEAT5Xy2mgcMVOmYBZYMa1LAhRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o27fWinf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HEndRg9G; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o27fWinf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HEndRg9G"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q4OM3T206589;
	Mon, 26 Jan 2026 08:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o4OjP5hD9Gkmw2d7KifOmz5pPEP8M1CPpq5vXNLkG3g=; b=
	o27fWinf77Rcg2IQK+43ILiNfwRznzV7ReqpypysvUvMegti7umJyAalttlz/1WI
	4iSIeBjCQFD49jwG5SPV7u8Jx1OhefsgqI7gQp9WmkJcoelqqNmLQJYBocvVP+50
	zSsKNrossCyYsnQGgfATtmiZ0zRd+M5Xmcht+HTjLU+DqTK0bMiziO73Xuiol8Xs
	g6l8cXO5rgRcdivaxAXapi3xIVvazuMHW1oDlT/OHoqfay3lrM34HxHpeRAFb5Vy
	u9hroBbP6BgPHR/5wZxhwjTu1jfnUysVkOxWC1V+PzwBZYc+3a+LGDdMX7eUcUSg
	hkzJ3kVuTOwnvfGiwuBHQA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvpmr9g5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 08:33:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q67JgZ036074;
	Mon, 26 Jan 2026 08:33:20 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhkyn0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 08:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KX/WXn3Rcf2/R4fFF2agludL+J4Ki21gJ6cfA5vRSgVG/mQTSSpHQex4SzsU4AG15WISn25FUToFttDoUw7ZpETzXv57GJAHnPEtkjx2BEU0bvM25C9fQ96hvFwJ/pdGuoq87xcC1pDIzcbvQnBUWJXIc1QcX9Log/IRr1dkDmy13Koj+rb7/u9B7qz23liRjSVrdxKn7WmqZXbGPOI/acW234gUJHDcFGobA19o8s9z/6ryrC+3DmqH+TUZ4CjQuaeyjf/IpQkbRSUcdV5gZ0S/H7/mYX2IeQS8qsremjCUl8sTSZ9BHrkoX+KFdDKKc9MVZlfnI4jGHHXgCQO8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4OjP5hD9Gkmw2d7KifOmz5pPEP8M1CPpq5vXNLkG3g=;
 b=b45qOiTDELFOyOpst2RlC9z27tapkTAHak0VM/zafEDf8/lnTV+C2xWlZwMs/UTGOUlU9fqDMX8zCNEkhvqhn1uon21oTcURfE4ZjY4mPu8N2rxesu0yQtv/ENTFFBEYzQLsnno3Kfuj2q7jgmSo/xq/vB5IpDJfh+pCtEN6hwasVVghQLPJPNP13UR6Zy45DLFsO11fNYFMA7k3zwi/uRItzpYBjRu/hhCONJytLqXnwIDBj7HXs1BXqYuqSPn/CC9dZsVVdpm7bERPLuC6PYdAd8Wc8Bf1hf+rbvJKplHZTo5I5radpPV9V9rB76eeS5nEES4hu3oRKAHFMu+Rag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4OjP5hD9Gkmw2d7KifOmz5pPEP8M1CPpq5vXNLkG3g=;
 b=HEndRg9Gr3Nrb/ZL4sM6hzvn3lb3XqxyjBh5VZRgkqvPHCOocmDwP/Qi9mO4uRbuxxtpNLo717XPDZJTzPwHr0lxD7voY31xHPufwNuDJk4mxxE7+sC2flRSh+Un2VEQroprXP5yQBY+Zhmhu7fuv4y5VVbdU2YP9falq5sZeO0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB7814.namprd10.prod.outlook.com
 (2603:10b6:806:3a7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 08:33:01 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%5]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 08:33:06 +0000
Message-ID: <43040a4e-c2e2-4f51-b4a0-13ebd546cf46@oracle.com>
Date: Mon, 26 Jan 2026 08:33:02 +0000
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW1BBVENIXSBzY3NpOiBtcHQzc2FzOiBGaXggaW52?=
 =?UTF-8?Q?alid_NUMA_node_index?=
To: "vulab@iscas.ac.cn" <vulab@iscas.ac.cn>
Cc: "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com"
 <suganath-prabu.subramani@broadcom.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20251230031416.55328-1-vulab@iscas.ac.cn>
 <cf0f9085-6c87-4dd5-9114-925723e68495@oracle.com>
 <SE5P216MB338083B78B7FFF35811F70A3FCBCA@SE5P216MB3380.KORP216.PROD.OUTLOOK.COM>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SE5P216MB338083B78B7FFF35811F70A3FCBCA@SE5P216MB3380.KORP216.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB7814:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ae400b4-d478-41df-e8f4-08de5cb58717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHh6STNUbTNRSGdrZFFKWjIrR1BpcFlPSFB5bktBQ0NtNEVaNjZmYnRlVHQ0?=
 =?utf-8?B?Y2hldnBNRnlGa082Mzg2VEdyQVpNN3IvQzVrMjFKcDFGNVN5cmJ1c0FPSHdi?=
 =?utf-8?B?dkRlaTBqVTYzNUhxaUFXNE9CU3M3VGFBQ3lXaVMrNVpKSGNlTDdtTTBhM0hh?=
 =?utf-8?B?M3laRElKK3o5NmcrTWMraVpLVW5YOG95M1pLamFpa1RvOCthNnNVWVgzZTh5?=
 =?utf-8?B?UlpzREJuSkUvT1oxTFUxSzZTeVVQS1EvZ0lld251UWhDV3crTTNYbWZ4dmpq?=
 =?utf-8?B?b3M4RGNQcm9VTDdrcWZKdU5BTzl3TC9ldVc4YzF4SmsxWXRja1RBek1PTWVK?=
 =?utf-8?B?WVdCT0g3c0FEckNtT3JmOVJqdnhYRnAxbDZTdWVaNDJUQ0N0QVFoSkFXejc5?=
 =?utf-8?B?am5BZEFSRkUvVGQ2RnhjZzlYN1hoVDBqSnFHOHpYVTk2Q3h3eE1FOFY5RFBF?=
 =?utf-8?B?TG1jaEZOd3l1UGdCUWM0U2cydVBvNC82WEhZcW5oOW5GWThTUmNIOGtOSXgz?=
 =?utf-8?B?M3pVOFowWkRZVzNHZFNJS1QvM0RxeDFvZGRLSXBZRldBdDNSYUlXY3kydW1N?=
 =?utf-8?B?YzlwN1F2L1pBYUxyZnJqVjY3VmQ5OHZTSklNMHhheDFCNEVjeTBEeFlta3NY?=
 =?utf-8?B?YjBCUGtZOUZ6Rm9LS1BZYUJRU1F1eEdKeW5pY0FMaU5aKzZSQi9NY2JTVjlv?=
 =?utf-8?B?UzFodmc1ai9sVjdxZHVZUm8wTzkySVJpVWZVdmJJOEVqb3JNSE1DL28wdGRF?=
 =?utf-8?B?Zm12VER5SEpwN1VSVXpLVytjZWxqdnpzN2Y0eDIvclAvaW1TOExtMVVCNWdF?=
 =?utf-8?B?RmU5eGY5SnVVSisvVldTVWJaVTNLajExSjI0ZGRJMVVDYmRRaWY2bm9zbVZB?=
 =?utf-8?B?S3JzUzVXVVZTcTRWS1ZIT0FZYWpTbDV4SHM3Y0h2WlFxOFB4VVZ2VVRLVndm?=
 =?utf-8?B?K01GV2lINTlMZkZVd1JEa1o1Yk5JMFJUL1dnNkN4VWw4L2pzM1NXTzlwZVNn?=
 =?utf-8?B?MXFFb1NybTNJKys4WTg0UWdEQm5ielp5M2w3Y2hUM0pwZERaYTkxWjhQM2xR?=
 =?utf-8?B?TUZlVE0wR1M2Sjl6bk1YNFI4V0J1M2IzTTV2YlVCRWI3R0NnL3ZQUENyTUY2?=
 =?utf-8?B?WkZsRVZJaEMzbkMzbkRaT290UGZoM2JHRk1jR0VQSEdyY3VPcWovWGFuUkJl?=
 =?utf-8?B?YnlNNU9UYnNoc0tSVzFzWk01VGpDSy9aNGxZOFA2dG5xeFkvWlhiY1ZMb1FU?=
 =?utf-8?B?d1RydFlSNWtJMkRXQUpxM2VhN2dNWGFKOVNpcnV4VkxTYmtiamxDZ1k4ZFJB?=
 =?utf-8?B?ZzNiTC84OEtPMk1QdHJlY3FzTDdVczYxVDJPbVZwb2JSdzZKSmJoa3AveUZ6?=
 =?utf-8?B?bXdhVDNrdHdqanJybHFMdFV0VXV5SzZqbzMxR1JZUlhhM0NBY0gwN0N6bk5Y?=
 =?utf-8?B?cGx2ME5wVmRuOFEweTZBYStqaTdIb1FhNUdvZVUzRkV3eGNpSVBOTUg4dG40?=
 =?utf-8?B?RGE2dVRtajBHZVYwM2pzWk9ENkFmVlFFdGh3b0lBK3BpbWNzdEdSVlZ0Szdm?=
 =?utf-8?B?L3NWTFhsV05McldHSlhIRDRHSXB0cUtkU096NFkwdm1oa1RCWmgrOXlqUUhG?=
 =?utf-8?B?RDIwalErOG4xd0FuZXY3ek5xU3JRRkxENzJtazcySTJNbDRPVVEvdTNUTCtU?=
 =?utf-8?B?RGdHQkVMNkRrRkF2TGxEa2pZR054czFkWXl6NFpNWFNpSjM0aXg3d2JoQ0Ju?=
 =?utf-8?B?TVRZTHlGVDlJVkRDL2R2NENWaVE4M3NIL3o1MWRmamJrR1JYZEErK2Eyd1hT?=
 =?utf-8?B?Ry8vb0RxTkpyMy9XWkxoU2xqS1oxSFJOWUFaNk5JM1FLNHRzdHZra3VtZmQ1?=
 =?utf-8?B?NGd6STAreUduSlhjdUE0UVFMd1JmYlVIb0MvMlFTVkc3NkRMajdRRWE2VjRH?=
 =?utf-8?B?Rktrc1VoekVYUmxielhyL2N4azZZSUJmVzAwR3NubmJpeWxURTBScGlZcEpz?=
 =?utf-8?B?ZUR5NXhXWlo3eE12SzNHSXA0cnIzU0s1RlNwVTRFMXlhOEY1aEM3MUFwQ3l5?=
 =?utf-8?B?ZUE0U3JaYWZYM2E1NE12WEZKOEppRHV3dGQvN1NLQWU3dGFSQzJlUUNFWmFq?=
 =?utf-8?Q?TGRY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVFzcDA0cDQzMlM3L3hHbGFtaklJbU1QYzg2Y3lqaUt6MFRJSDZxUXpnWTFw?=
 =?utf-8?B?Y1lheDk1dFkyWDZCdTh2RTY4eDJGd2hYMUFGUFBLeWdsalRkcDBxZGxESU9B?=
 =?utf-8?B?dzRMQjQvQWV5L1podlhmSk5FS2dSUitQVmFIKzhiTlhtRGZJcEJ1QkFNNHoy?=
 =?utf-8?B?anZlRStGT1ZEK0ZxRGFMcE9KUGxRRmZ5Y0ZMejUydkplNDZaM3J3TzlRNnNC?=
 =?utf-8?B?SU9lQVlqTkNOc2pNWkIwcGlLTjlsYW00U1Voakt6Y1IzWnVhNHJ2VklLd3di?=
 =?utf-8?B?Y2E0Z085OENDSUprZ0ZINWxaU3VtYkJHQ1kvNFR4SnpRL2FiZVNLSy81b29G?=
 =?utf-8?B?enRvZVNqS2czc1Z1RERFaGdqYnAreTV3K1oxYWgwcDk3VEx4bmRuZEN5OXBs?=
 =?utf-8?B?M0FoQlQrMEdUeXFZYUxPcktYTmVWNU82V3N5YVpJeElzL1BqR28wMDdWRG1H?=
 =?utf-8?B?TGtSalhnNDJQem9jeDh3akpWdlcxM3hmRE53QTZ4SS8raDJUUlJDNVJtQU81?=
 =?utf-8?B?Z2VxYWNOWUZhUWhVTWpLVFhKNk5PTkJ2aWwxVklRKzNHcnBFWGFWNVFyWCtj?=
 =?utf-8?B?MmdDSE9kVTJYdEZnV0w4VFVYMGYzSmNRcDlpaTB1UXFmWVN4SUdZM2xybURu?=
 =?utf-8?B?UmZxaDJNRmxONDVBcDgzbnM0U2J6NHpVZDZKNTAzSjNqa2tPeHBJRlVXQ2F3?=
 =?utf-8?B?QjFYNllGTlo2SWlCaE9pQUw3MmZWaDF1Y1VMNEpxODUzckVveFhxdWViMFRP?=
 =?utf-8?B?QzhnMkpaaVpyTVg0MkR2Tmw2c0xCQ0hmVkloZVR2WEJJMEdrUURNZURHODBI?=
 =?utf-8?B?Yms5Q2wvM25lTm13eWs4QXFOMTZuSVM1SmFrdGR5a0JNQWJUY3JPOEVUR0Mv?=
 =?utf-8?B?RGI0VS84Y3U5aDhqRFI4bGUzWVBWNlJzQmtBT1EvNGxpMVJUSTVXZFpEOWVv?=
 =?utf-8?B?Rmx1Tk9SU3l2YXA2aVVBSjd0eStLZHlsTjVIdnRnc2FkQ3U3OXEwTW9zRlh5?=
 =?utf-8?B?RmVvR1BpbHBFbGxET3N3ZE1ENmRGVjFCNFRTd2RCa3ArRzZSckFLMzBXM082?=
 =?utf-8?B?bC9GSDBSWWt4SGdRNnY5SzlJZUpTOXhSRy92ZE5IRmhmZkV4QkZtK0dGdURG?=
 =?utf-8?B?SDVQWlhGRjZISDFVZkZpTWNMUzhGQTVNa0dPejh6Q1F2cXJoT3lWckdSeE1w?=
 =?utf-8?B?blg4Z24xR09VVlB1Q0lBZEd5cVhGa2VoWmlCTm1nVGVEdHBmSnRqSlJsRWxm?=
 =?utf-8?B?TmxLK0wvWVF3dG56WnlVTzA3Tk10aW5POTFOMW55bUZ1QW9OeWR4bHE0QUFL?=
 =?utf-8?B?dXd6Uk12UkJyMTdiWjhtSnlQN0k0bWl1VUpUQVR6OGZQanVDZlFGZEpFUmR6?=
 =?utf-8?B?dFRWTGs0bzdVb2kxSmZPeFowUHB3b05SSmZyM2JpWUt4cEFKS1ZtL3lMaHRR?=
 =?utf-8?B?R0tpcmJZcDRRdUFvcE5hTmhzdGtWa3lLQUMxaFh6QlB0T0YvWG1DajlScXNs?=
 =?utf-8?B?akxsR21TMlFtcTF5cW9CQy9rcUgxVUMvcU05R2ltUENmdjNSZHJvVko2dmZk?=
 =?utf-8?B?OEMxa3BYK3pmVk85cTdMWkh2VWJYcUVRSFlOT2ZKYmZPeWlWTEFjVTlpMU4r?=
 =?utf-8?B?emluS1pOUk51TjNHRjZJeHFuUzQ4QWVlNTIvdzVnNzVqWDRoWTEvcE9NbVlM?=
 =?utf-8?B?Sk83L0FIRUo3Z3BNYTlQaFZoMzRjUitsWVQxQk9YVU5McGZ1UTM5aHJLZ3Fk?=
 =?utf-8?B?enIwQVpISWN0cHZyd3Nmc2lJcml5YUVrbzdMZWlYTENERWRiU3Z6OFlJY29s?=
 =?utf-8?B?Tm5mMFRkMTZtTmxkb0s4L29lR09yQlVnRmlVUytSN0ovK1Z5TzdYakVhSlpo?=
 =?utf-8?B?WHJlWlN4Q3dRVVh6QTFvSWRzMDk1UFlEa1VZWlE0S2FrQmVyVXVOUldFT3hj?=
 =?utf-8?B?RXJ4N044V3owckkxY3d3ckszYnppZXVXYlZlRklxUnNKbnltTHZiZXRhaURn?=
 =?utf-8?B?dmhPYmxBcVVENWtUVk9DYkg1Y0NaWlM0amNhbGkySGRzT3FVWXR6SlJ3eEN0?=
 =?utf-8?B?VXFZR2R0YjhhOGd3MHY0SFgyamt1ckdoZ0IyWVdzdHBrL1YycXQ5MUJCenZt?=
 =?utf-8?B?V0NmVXJ1NTVSc3B6OGtNdEsrQTUrOVo2cEVlaDdaa0wvaXRiNTF2NHVtZkd4?=
 =?utf-8?B?MEErcVR2dnhuUGxXS2hOTzhvaFpydUZTdGUyR3hTbllVU2FxVTZHTmowVE1x?=
 =?utf-8?B?MUV1WmxPUUpZREpTQ1RCVmFFZDh5RDc4K0NnZTdzQWdaL0FubjlacElNWklm?=
 =?utf-8?B?SDNwRTNSWGRPdWgwL1h4NFFiMEZHOHBhOU5mZ3pBTHZmV25QVEllQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y1RsJBhlrJYLJJM8/8seEtunDNysHK4dvtM+hQNH7Jx0GPpRxH/eYK+vTSssSE9n8hZXH1O7hPB75X7It3g0eijSe+IJMguHkEL68bg8I8dG5FOe4PS5IspT525DUFiZkSDEjK3MWiKscFh+cs7ATp0an3LU9A3sJB7AWk3ZXvtx5yH6luzcxUqdFx8uw2ZaydzjfRNwq+35mLlM/O79J8CvqPNnDl6RvVE5O4pUyn/R7XwsKtJQXo5PYv6J7Tb2iaalmBVenI1NWVOMhpyloz52rYr5lqHlWWrF55w4lLqjvcKAXHzWvEctLJiJVePjbzCK4/CKBzKWsW9mZlHJzn6rcQDC6nmYQTIT+2nyN7sx/cZiSqrO5CLhMYM/01GFQenfHhQeuJ4HktzcYIz1q5yQK02wIG8HcFqYfr2SEPGIlX/vN+9kCk3R9dq78+KMn1u9OL4XpugwDS0edKwK838P2SKFkYmTZFBS3xbAcx7xDw7JvVmpt+0McekVnrthu3zBAWUf+LZCj/ioOoU3JDcxTQf5MzLUVsyKX+P03UqhDFI59FYxIRdHS/f9LD8oHqNldDMjwwt/D5E8okHnzK0SO6p1R0fMPQ0f1NwmOIo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae400b4-d478-41df-e8f4-08de5cb58717
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 08:33:06.1495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crSAEHljWnKkz0va1jn8YMU/NavChUTnDMtgWHK0ekujpdhOR9ghSDKG7MXJpTiAs4q8fuVzzm30aARz1LIKSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260073
X-Authority-Analysis: v=2.4 cv=Q//fIo2a c=1 sm=1 tr=0 ts=697726d1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=5KLPUuaC_9wA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=1D0BHPHU6QIMv1VjSOAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: H7BUcic9lWXHxTKuEeSZr8FKUHxeP8je
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA3MiBTYWx0ZWRfX1yArvTVVRLHj
 jq+0YlF4Wli9Yyzc5uW9zNsy3RvBjrbLeBe1ZZFZxnKtulJhg3VQum+55eTTEtOHtRPa1dgcEaB
 aAAHQG/0Y2NOAuXJPLR6Q7xmoBcPi3rMmDhIwD7qzvc5VpzKI2m500rAK/1JNxEKzhMke9nOSXY
 bjFz/TXDc0/ph4mQnRznt/ZHCZJCfBityLa77pathV9psHdjnotgf5JOEhdkb4FjrC2qNj7bgVW
 lINN3HMaWOYi55PHv83oaa/Rf2DfqDMecI0+mWn5y26Kl2/4234mv+Ypvnfy8BvZ8xoeH6vjmYJ
 zKGGHhHKVv2ebMHR+qHd9CPuWRlPU3169mblUgYUSLaLK+tJ3KZRweNaMBgvSDur325GF5jcCdN
 MWgqIXe7pHXNGrdpEepq9kMvnNzAXIWu2f9jW7mKSXRViL3josfaLoL7gnYgdGBfPiHJ/+eB6Wr
 BwqUlJ0/4sBxKposPgq0WxNq11IUo1/+qjduhAc0=
X-Proofpoint-GUID: H7BUcic9lWXHxTKuEeSZr8FKUHxeP8je

>>                  */
>>                 if (ioc->high_iops_queues) {
>> -                     mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
>> +                     int nid = dev_to_node(&ioc->pdev->dev);
>> +
>> +                     if (nid == NUMA_NO_NODE)
>> +                             nid = 0;
>> +                     mask = cpumask_of_node(nid);
> 
> Some versions of cpumask_of_node() handle NUMA_NO_NODE gracefully and
> some don't.
> 
> For the core drivers/base/arch_numa.c version, it returns cpu_all_mask
> (for NUMA_NO_NODE) - so your behaviour here is different.

I sent a series to make all versions of cpumask_of_node() handle 
NUMA_NO_NODE:
https://lore.kernel.org/lkml/20260107094007.966496-1-john.g.garry@oracle.com/

Please check it and provide Tested-by/Reviewed-by tags if you are happy 
with it.

Thanks,
John
