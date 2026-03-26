Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8288A38759E;
	Thu, 26 Mar 2026 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774536670; cv=fail; b=d2Cv1g6VoSFdFSUDhAflNynuGAwEWTdY3XfRMBdiJ/gAatAQpDl9+tG+EvCKGuNnWc1mRK1AnDz/4UYNROvtzlt3z81k0PZqepwZA9lnH83m9sDbYT2PWDcZ4HwEKANwvNZBimj/lIHwdtaWilGXx+DT1arslMs1QXgcyxkyZHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774536670; c=relaxed/simple;
	bh=pdSN14VngEL8vKOPwrRsLbLHaePwZYtwOS5SAHhjEeo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=InmoRb5BviD1SydlTgYNp3yoN9rMJtZ73x28zjcU99OI9vtSqIBhpVtl5+nOBm+Tmms6Nmx3RbJ7KrJ2g2DmUYXNyX2kD/N1O53/IuySmAeqzLO18d/zcZmggKMrvZ48zQjidhYcfUudyPgaKuOCzI7FmNgg9XaKGfq9qdf2dLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=igD663WK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PLOk8a75; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="igD663WK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PLOk8a75"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62Q751q12526613;
	Thu, 26 Mar 2026 14:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pkdgon30dXCXg/7kVNAvmllKBR1UR15IuAXNqsV8M+c=; b=
	igD663WK2T7i0mcmE0LvX669JgmY7tJg/sWtlJGgpJ1wqga76cEnUdAbXvmjQ4aq
	UsWVBL8W8ImcYkHi5DEL8nhI0W9y4cDZNbkpW9qWskUTaF4HLsd/M6Pvp9zCCN5G
	RWE3nIC2CuSrpzCjCAnbXGwf51O8xzuz3CgRcMnzEvKpv1aDx/w6jCh4ld2Ysrl6
	CziIa/6KuydykO9o3xR13u0EKoUqjbvfouyAsBdD2RSHOiy9pnmU8aD3bFmOleON
	8LK1mNighfjIA0SNOP+mr6NbwW4zuNW6wIUUwKAdPv4RteiG9foqCZX6rz5ReDyL
	jDo1Aa5XxEL8GKoJDlnsvg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kvnrc77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 14:50:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62QDPJbF012374;
	Thu, 26 Mar 2026 14:50:44 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011003.outbound.protection.outlook.com [52.101.52.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsk49cb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 14:50:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IogvJ9FZoPauLuFQxtTKDM4Uyy00fkeHhijppdCG5dVYKHs0dEJAz1/AjHG/Ti6oBo2wVQeJbTgvceeDFy2bBQiNkRPfU//swoRRXgPCeZNoHcPn+P7tM2IKXahAdTjNzgTy2u4bCkuJ5gaozgSllt9fxetmqXqoJNicaQOLPACTkgKMNMBaqu3R7B9OsbXu7hd6xsebdjFA6ZheCFSF7p6c0+FANAV4ZZFSzGL7uW7DLUZ3g7UUUXyT/MYDT/hzRzTX0cbce4YgdI/BU4QvLskzaaXaXxeG6ktZ8TjROwu0oVIOERbbv3J1LOoq9Y1Ae8SwngfOY8ErzHs3RCFLDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pkdgon30dXCXg/7kVNAvmllKBR1UR15IuAXNqsV8M+c=;
 b=PGXXDbNUT5ZRzx4KgFP4i00M+FLGTK29gLGRLkGZP3xXkjtwaS2ppYksKs8QZ8rHxeYIp5oBbweL4aPtZAKNh3K7ykTs1VEwUGCu7KoQD2lr1ICUPRa0U6IXiX95R4/OZVj2K4N/uhbTLidFFX0ON3u3OZZy4nykJQhKegv9hFVs4XQESLkz/S6BZnka97qZVHkIWoFKNpN/8VFgdWT18LPsRI6hVuEMfxWjfkCGwuJdliDJ6Bvt6/MnWwMdGKpd/G3CeFXIgyI9cQXWWEEUIGmjCZEm+UvLodlgWmMgHlmCSa4oQ/dW39ta7H8fcZU5VZyyNr+gy8//nDYuBmA5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkdgon30dXCXg/7kVNAvmllKBR1UR15IuAXNqsV8M+c=;
 b=PLOk8a75gzQ/7YTsgYg4704H8zE58K1OFr4fc1t2FyzFn1n4J31iyl4Ggq7gXcq9V3b2vzku57GQb8lhBm7Ghk8ZSfZp1TUaei59dYuS0K49C/cNPKiDQVyo9EybCK190ofn1UGqiLYRWBfOVA1XihjZZ5XZiq8umDfDTi7x6SM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA3PR10MB8540.namprd10.prod.outlook.com
 (2603:10b6:208:572::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.22; Thu, 26 Mar
 2026 14:50:41 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 14:50:40 +0000
Message-ID: <14e60b2e-931c-461a-a316-f2e434e63811@oracle.com>
Date: Thu, 26 Mar 2026 14:50:36 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, axboe@kernel.dk, m.szyprowski@samsung.com,
        ahuang12@lenovo.com, ionut_n2001@yahoo.com, sunlightlinux@gmail.com
References: <20260326084644.27162-1-ionut.nechita@windriver.com>
 <20260326084644.27162-2-ionut.nechita@windriver.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260326084644.27162-2-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0324.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA3PR10MB8540:EE_
X-MS-Office365-Filtering-Correlation-Id: 72779234-2dc2-4f8b-dec7-08de8b470cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PjKR2TtDsY69TgOY2j93JDa1I5eqkgVTwm2gIcSM67j1EHN8Pdne+Pu4Qifk539fUk89phSPCltawyelh5y8cdiEMj8jYrNERKzSD8eBqGHlxI+QthZQuuwYYlRk2bCYaIu8RyCDqZUxRs+j3V85pp5lUKmyoaMyV7pqqxh8x9dj0RxD7WuQQtPETRM2SRXsDNwZMQio0Hxz0A7tsZsfoVYpfViOex9IvxzY+msnbktL1yH1uNrLHVnhVQZA/T59XwYp/uJxho2eltZzJMMsGNwieKLPt22rZ+dXbhQeMJTmuvDPHq4rPM6YOiPe9ZoR0lXjHJYamU9K6NJbYIHajNV2WL5/XKrSG2bONVUk4NP6GJkKfGiLwt7FcuLowf1ltI2XUv6xZZNKDhf9Zx1XNKQWLvUJdn5e1SuobuACrWHpPqBVaSEJ93B5T6z3xlBibOh8xG7DgKoQg2EI2uJzRiYFfpz/JP1QDT4BQEVj4jhG5N6XNKjMXgB8yWlwM663ZcK7zDamXJ51YW7rau8ZqAIYur802QsUjP5VzE8CGbE8WxCynMMlLmQgva4tD+NCxyO+m9beUAKon+iWqrm2ZawKJTICvbrWh/6vHNnQ8869tmifZMH/8NEAfHHFkLsst4OsrCwAtWiNeYgkvbAseGluTD/XCommrAXsRSidDmixJV3f0gmRJ3pnD9ZqLEIozzm9Sixqau57RiR1LK74sVQF24SIjzb/uaszqjOFun0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alZFbGJBZlhFR0RMbDI2Q1FJL29jZk1zeXU3RjV5Y3ZzaHpHaEdzbXJncGpF?=
 =?utf-8?B?bWRMMVdRVUQ4NXNuc1Z1bHA1UHRmWGVKSUpkeWUxajhNaHJ2RXRDbnZwZjF5?=
 =?utf-8?B?QjN1c04wY1BzWFAzbmtPWkd5NUhjaUVaaFlLZEprM2I3ZnhVWjdDbkMrRjZt?=
 =?utf-8?B?NGlpazk1MHJFMDFoYlplNnNDeDJ6cGhrUVI5VnZOajkvRzgwbW9MQzVmSGts?=
 =?utf-8?B?TVV3MHAyUWtjTzhnUGhBQ0s1R0Z2SkdjRjZZK2NiV1E3SHlleitod0NiY1Vy?=
 =?utf-8?B?WmtQZVJYTGovZUdCRjA3QkVudEx1UWJPZk5ocTd1dWJKSTRaOWkwdG1pWXpN?=
 =?utf-8?B?NGpGcUUzM0JnK0V5ZnZUc0dNWVhPa3Vjb0Q1Rjd4aXBWUjBKWnJ1SnFiT1JM?=
 =?utf-8?B?bTVhWE9XUkhFalJ4RzFudG1qdVNrYjVjOGtaYnE0STRraCtPRDJYTitWWXQw?=
 =?utf-8?B?MzNhSGdCbTE0NU93Z0JyMTY0VFlIV2JHM29yYlBhM2ZRUnByNEI3RDQ0cWFG?=
 =?utf-8?B?M2dmNXRyZW9qdVJJMUI5RGFFRDNuZnUveWpLYVlIVFR6eW9EdzlKdzNocVJZ?=
 =?utf-8?B?KzgvRXZUeTVmMXlIdzR4ZWxIOEl2RUlnVi9oMGZUdkZUNzdtU0daeS90L2JC?=
 =?utf-8?B?ZU9VY28zejBMbG1vQXNtNlI2TUw2bnNZK3kxc3Y4cXdYRlE2Y29kbXpJRHVy?=
 =?utf-8?B?OFZ6NVdFVWc2OCtKTVhrVU5WOUNVWm9jd1dPbmlJNFNxV0pXYittelRDdkFt?=
 =?utf-8?B?L2VMeCt2c1BoNW1sMnZ0aHdTT0tUM29kS3FoQThJei9LcGdmUC9FL2VYZ2Ew?=
 =?utf-8?B?aWI1Rk5PT2hUb3dNdVdmcnNVUFZZMzlvUzdXaEhjMHNvMG1JejdITUpCUTcx?=
 =?utf-8?B?aytGdTdOQ0ZoRG43aVRWVi8xZHdybDRLSm1MVTd2eVppYVhMRDhEZWFFTjJS?=
 =?utf-8?B?NU5YZWwvelBUM3dWVFR5bkZEczIyWURtSGF5MUkwcC9ZS0JPZEptN283ZFpY?=
 =?utf-8?B?R3dPMUNmT1pkVDZId1prb0cxSTcrSk5FTERGNXFFa2dwdkNPa0cvUXV1d1JN?=
 =?utf-8?B?eGlodFNDWXZGamVXOWlKeWpqRmpIbFMzMnBqWVhnOFp6anVqSGJHeTdLQlBi?=
 =?utf-8?B?ZW0wblZkQmwxQVVYbWV4NERyTlpjbkZXQnJQTUp0dG11TFF0ekJuaWR6YlRv?=
 =?utf-8?B?THFwKzg5NldSVWdxaTZFdEg0V0x1dDFWcTAvQ3o2UzMrMVNqblZJYWRsdk94?=
 =?utf-8?B?cEFOUTEvb2RJUVp0cGw4VHZuWHpHMDY3SmF4aDZ2bWQwL3hyVE4vWlp4RVMw?=
 =?utf-8?B?ZStoelNSZUZKdTk4T2hmR295YS8vQXhDcEwzV0RNbE41YXZwOXpQQWJJZU9Z?=
 =?utf-8?B?MUEyNVR6OERsWldMZkVDdk8zVDVpTHJINVhBVTdwQk5LeUJsV091NSsxUWp6?=
 =?utf-8?B?dVdEZVdqRjUzYTB5dDlCaVlwMzRTcjEvS01WRzdNdlpHVHNCL1RMOTBCcmNL?=
 =?utf-8?B?YjJEYVJGQUNldzc3aTZVcXV6WXk4RktHL1VsbkhnK2h4Q0pkb3pndnlxelpB?=
 =?utf-8?B?cG8ydUxZZUZvT0RJN0d3cmViYnJqOFUwZkNrbGZsMHZFNHZIVWMzaVYvRWZC?=
 =?utf-8?B?M29vVkNqVng1VXhDSjBMc1lkUkxISzRibGRCcnJQRVNVZGtOR0srL1dpL1FK?=
 =?utf-8?B?ZmhwZ3NjRG9WZDdlSVgrMlVtUXlWdUkveDBQNjhXeExwdEdoODhjQVNycU5V?=
 =?utf-8?B?WFhmeHdBbXAxejF6ZUJXejlpUkdyWEhpcmJGNHdVbTlGRHFEaVdGZ25jWUxE?=
 =?utf-8?B?NjRnQ0hpdzUyb3pGTnJPb0RDVDBZNHB1SGFmU0R5UWlmQTRLT1NGVTV0Q1JN?=
 =?utf-8?B?Y1lNY1FrKzVrTUk3YlFwbVBxeXBuREMyeHd6bGhJZ1VBMnVSU044WVpOMzZM?=
 =?utf-8?B?K2xOZDdZaEk2cEx4dFR4S2YrNk5PSWU5V1dHQUlCSE5OTnIwZ0tUVVlubFVM?=
 =?utf-8?B?R0w3d3FJeUFzaEMyeklzbzU0ZW1nL3RHTytZdDBwdGoxWmxFTFZZb3RLV0ti?=
 =?utf-8?B?RVkwZEFXUTJFRWNHV0oyOUNmS1hZVjBZZnNXYUp6SDQ3dnpkQVdpRUt0WDVE?=
 =?utf-8?B?cEYvbXU2cXIrdDNReFdHZFdUdmR3cVZ0bldrNURheGtXK0tJaGswKys4Sk10?=
 =?utf-8?B?R0d6Q01ZbE1TWElnVU53OU1nRElnMzVYU2I3a0p6Q3drb25kVWY0R1pYV3RS?=
 =?utf-8?B?TjgwbGdsQS8rekRtdTgzZW82MjF6VUZsY2NDV3FNSTc5OGRTY3dRQTlOTmwr?=
 =?utf-8?B?OEpGd2xOMENBNjRuWlZkWVg5TDJLZUlacm56bFphbkkxN29aUTNwdz09?=
X-Exchange-RoutingPolicyChecked:
	GTUkb5cM1pPYqk8Np92I8lq5YAQOfWrDEUHrkmAd9IsKeXl0tfMn85fqjwBjgQOrckKJht6jUp2BIQlEr1wr0lf81ZvddZxeSVdoOY9rOM01RS7mfpQ3WptPs7g5aNdITqydYdcuRBKWFnsgcKm/jxiijSwVUhN4pwWL6odzpNp/7OSdihfozNPHP2d/nGFiBkroulehTPK8zDW/0mE0gaRDcgGZISc0uChu4fvl/s7fhwdIxDOx8U1tdOvFnZTdVJsVtYERAC3VDWYREEXloIZ8cHu7qy4iJhOQV7GneqELA+wmNSeS1/UC1rpsQyRO4fZcQQAu9BaLXsrHfXVgLg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hE3NoYxLS62juSWxIeknMVTK/O0o/zREql1gtpQBEzjrAbEu2WsOf6ha/U/4R2GxdkVrw41nlDR8vrOJF5HdSgD/RIg6CgufJltRk7/6A/c3aSJ+A8mew9MMYBcg83Qs4d5VHmLfcq4k5o+AU2vIp+14WrOC4z5VneIRINMd9L/BRiklkLPCfHMczP3++9OWwtKo7O/ZGvxosIZXMJA9AjX26BMqodUM607f/vVScpUJt4UqF6YFwsAkxEXXlerQoWMDXIaa0SpmZV3WBtQo1c26UPCbCR9UhbJoNlVXPBQ6eyBgT9dTQ9rwHhnWfFcq1cc/ROtypqk64WyDfvlDZ/XrsHTLX2CJutJGVIx5z9+TmXI5lnbdRRCJUUTJwd5p/K+oHWe+NGKmbICqrowsjdmnuZ8Tcl2Iwhic95hx3PDirYPKW7phL+w2vOpO/ceSlW3fxj6tIoW1OsKz4z6zKltcLn55OgZswCRODYkgv/Om2daFWclxXdS0Uq2hujdqM6v2x5wsp9a2JndDE3g7BU5wcmLvOyE/6uqkmE08XDQsG9x/hXm3U+jm9FVv+pYbbKDp4nzRrPacu1LRV8vUyXdQyvJkJ0u+tR2/xxqSXEE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72779234-2dc2-4f8b-dec7-08de8b470cad
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 14:50:40.7805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mOqpdXjK5Z2deP5Duf/JeVkg0LKRX+eyNATkVdHu1SKzv122Pxb0Sbxf2F/gHsltu2lFBvnUhB6bGVp+WTP3ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8540
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_03,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603260104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDEwNSBTYWx0ZWRfX88GZ0WtSfe4z
 sDSlnI8lrgo8SDnjSrinq3qRXHA7PP8g3jRSd670ygQWt4isC0+4BOWxOWm5imZnFYon8UvA0jE
 SJQ8OaiY2Xpt18kXnCAVLPaS0BNWNlgJJLaMMF7ZHvnTJ5VXcuCGi6sx3lUgCrsxDsW94u2xjyT
 Zb9bzFYarW7YotUA1lPXy6l8JDhEQkABYnqssu8S/PNTbkg56VTmN4/j1sjn6Sj9sFLfQ3bmZk2
 4kKQhfoyAJpd/Bouug6Trgq/ZRc0kYLPJIz6ha9ABCmBsrrbd75cgo9S2G/nwJQd2XId9UygsY0
 fgT/pvu2TUh9isBP6m31HP2hVLDTScZra14dWjB9aoYHVczL1JXeYdowq/HJR4aveNt1hpVkhET
 WTAENWJx+CWEm6Oc43ZxQ7nnJwgAbztNwIov03/bvNp+fb0tKW6gz7pmS+kSFIltsum8JfJgQRe
 nMk1E4jfI4jyosj7J16NV/ynmBPfaRpSnmBAY3r8=
X-Proofpoint-GUID: hH1_LR1mzQWA9CLGC3mkSZcnwzFc0_lF
X-Authority-Analysis: v=2.4 cv=GrtPO01C c=1 sm=1 tr=0 ts=69c547c5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=t7CeM3EgAAAA:8 a=yPCof4ZbAAAA:8 a=dqAK2JzkkH-vDvTDA1wA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22 cc=ntf awl=host:12276
X-Proofpoint-ORIG-GUID: hH1_LR1mzQWA9CLGC3mkSZcnwzFc0_lF

On 26/03/2026 08:46, Ionut Nechita (Wind River) wrote:
> sas_host_setup() unconditionally sets shost->opt_sectors from
> dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
> mode and no DMA ops provide an opt_mapping_size callback,
> dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
> which equals dma_max_mapping_size() — a hard upper bound, not an
> optimization hint.
> 
> On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
> and intel_iommu=off the following values are observed:
> 
>    dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
>    shost->max_sectors      = 32767
>    opt_sectors             = min(32767, huge >> 9) = 32767
>    optimal_io_size         = 32767 << 9 = 16776704
>                            → round_down(16776704, 4096) = 16773120
> 
> The SAS disk (SAMSUNG MZILT800HBHQ0D3) does not report an
> Optimal Transfer Length in VPD page B0, so sdkp->opt_xfer_blocks
> remains 0.  sd_revalidate_disk() then uses min_not_zero(0, opt_sectors)
> = opt_sectors, propagating the bogus value into the block device's
> optimal_io_size (visible as OPT-IO = 16773120 in lsblk --topology).
> 
> mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:
> 
>    swidth = 16773120 / 4096 = 4095
>    sunit  = 8192 / 4096     = 2
> 
> Since 4095 % 2 != 0, XFS rejects the geometry:
> 
>    SB stripe unit sanity check failed
> 
> This makes it impossible to create XFS filesystems (e.g. for
> /var/lib/docker) during system bootstrap.
> 
> Fix this by introducing a sas_dma_setup_opt_sectors() helper that
> sets opt_sectors only when dma_opt_mapping_size() is strictly less
> than dma_max_mapping_size(), indicating a genuine DMA optimization
> constraint.  The helper computes min(opt_sectors, max_sectors) first,
> then rounds down to a power of two so that filesystem geometry
> calculations always produce clean results.  When the two DMA values
> are equal, no backend provided a real hint, so opt_sectors stays at
> 0 ("no preference").
> 
> Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>

I have some nits below, regardless of that, FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>


> ---
>   drivers/scsi/scsi_transport_sas.c | 38 +++++++++++++++++++++++++++----
>   1 file changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 13412702188e4..fa79a0883bb3d 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -27,6 +27,7 @@
>   #include <linux/module.h>
>   #include <linux/jiffies.h>
>   #include <linux/err.h>
> +#include <linux/log2.h>
>   #include <linux/slab.h>
>   #include <linux/string.h>
>   #include <linux/blkdev.h>
> @@ -222,12 +223,42 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
>    * SAS host attributes
>    */
>   
> +/*
> + * Set shost->opt_sectors from the DMA optimal mapping size, but only
> + * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),

Aside from this patch, dma_opt_mapping_size() may be better named to 
dma_max_opt_mapping_size() or similar, to indicate that it is an upper 
limit of good performance and not a sweet spot which we should aim for

> + * indicating a genuine optimization hint from an IOMMU or DMA backend.
> + * When the two are equal (e.g. IOMMU disabled / passthrough), no real
> + * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
> + * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
> + */
> +static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
> +{
> +	struct device *dma_dev = shost->dma_dev;
> +	size_t opt, max;
> +	unsigned int opt_sectors;
> +
> +	if (!dma_dev->dma_mask)
> +		return;
> +
> +	opt = dma_opt_mapping_size(dma_dev);
> +	max = dma_max_mapping_size(dma_dev);
> +
> +	if (!opt || opt >= max)
> +		return;

opt > max should not be possible, but I suppose no harm to check. And I 
think that the opt == 0 check is really covered by the !opt_sectors 
check, below

> +
> +	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
> +			    shost->max_sectors);
> +	if (!opt_sectors)
> +		return;

I don't think that opt_sectors == 0 is possible as max_sectors == 0 is 
not possible unless someone hacks their SCSI LLD to override it to zero 
after scsi_host_alloc(), so I suppose that the check is ok since 
rounddown_pow_of_two(0) gives undefined behaviour

> +
> +	shost->opt_sectors = rounddown_pow_of_two(opt_sectors);
> +}
> +
>   static int sas_host_setup(struct transport_container *tc, struct device *dev,
>   			  struct device *cdev)
>   {
>   	struct Scsi_Host *shost = dev_to_shost(dev);
>   	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
> -	struct device *dma_dev = shost->dma_dev;
>   
>   	INIT_LIST_HEAD(&sas_host->rphy_list);
>   	mutex_init(&sas_host->lock);
> @@ -239,10 +270,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
>   		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
>   			   shost->host_no);
>   
> -	if (dma_dev->dma_mask) {
> -		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> -	}
> +	sas_dma_setup_opt_sectors(shost);
>   
>   	return 0;
>   }

