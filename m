Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93B53D4123;
	Fri,  3 Jul 2026 10:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074821; cv=fail; b=FdIrbZBNWieLU/CtNAc3DrG156l5g9JKYoBeCHSoSJ0pY71hjBv8tMdO5B0i+GBcPRYbwmKOyNxRVs8gY3qFzFptQgkElQ6gDEugmas+Z+KejIakmW6YF75Gfhxzi8kHFBr70/qjGujfynCUqVckKDD2xsJHK0eOMhBDAsXFZ8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074821; c=relaxed/simple;
	bh=r1mHYW41HxJ0/H7gv3LRPfJ33CLABllKUFw8xnwgnCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SnTIDr64xfD1dM7W17MWGutVYUq+QDqRXexAL4N21OOQKzK8jR8duJcXdT/oj88ACcZDU8x5Gdgg/se2rNNUoQ8AyZ0NCI2k2S3dAGp68QtiKX/XiuAIqueqaD9WptZ8HGtOnp1QfvkuOvxU8EGoYO8SPNJWrgo/ZPCw4MzWS+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TQ/SNPCP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qui4eEBk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TQ/SNPCP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qui4eEBk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tmbw3016471;
	Fri, 3 Jul 2026 10:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bQo8kTrYyTOcnO5bqQ2nZO+tEz/3h6Ga8EyUXUCTzUw=; b=
	TQ/SNPCPrvu2JJ/8Vo+sIQbqBW6XRm/TI8M1xMMJG1Z7rh8ElMqmzClHct4eEeON
	tU5y508fPnXw6ybubU65Z7CHooH+NWJRuYewr5DOfxj+/ymFxDr6gqLGI1qyhBCD
	ajZcenTYFITbuFcxEd2PNPUIj7QPgPPQ66ZPxdfmGEIRZgTBeNSMANN5WXLBKZp8
	wKwoYj67m2q1HpBL+sIjAnFdShBUTcP7vjF1rpmLQUfDjEaOMlwsNwsPUbW37Khf
	Kq5MkvMBQkG/2flkgg2/pU9rav3cOw8JryXam7cqHRiskLR5mK2/1NNy3ZAfoEYC
	5hXGgcVov2heklaTcgFaNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f272qtdfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ASXsl035316;
	Fri, 3 Jul 2026 10:33:04 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yugvs9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHQmlNpUdd8HkJOzEj3MurF9ZYPNy134A049Cx0N1nttpso4lsXkxw6vA1fxO5HMudLn0/Rr0aez6//SyNtzDDbyw3FHpFQ/h/p8U1Kswo8MMVs5SyQ8wVRtD6nepVY7HLSL9F31zI+tl5u485tFEQKCoy89OnHc1dyBwlwxPwfwSWmIVNg5O2pqM6qQubcAB48irh9tnjsGzfpINPTZmLCNktGQ79Mo7FI6kKPmABiRpOZVQPjqib+45pI4f+8X7mz2Vl1xZBoq0UG/y7jkbhBjB0w9sBTUxQBZnYoSPukFJMXtoBzYD5Ru9Pwd90Y63QNzp3Jh6f25Javg4rQT3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQo8kTrYyTOcnO5bqQ2nZO+tEz/3h6Ga8EyUXUCTzUw=;
 b=n6S7kZLk93umlDMCd+bOlI/y1dJyJMRPnBfzMSbamYCZUrNeVL9DvLCPVgeyiMhTT5GQ+KYOzqnYmuZNCFs/b48+yeAOeqi1u91wF43jmtZ9GNl7kFsb2fySYPLXzlzJRuIFdDPl7vk4pAcbI3B2HMimamyDrnwEpuXxqTgW9gkpKbIw1hR1Q1Qny8fjiZi19MHNBX2pimSOMPhb7+AcOHfB/vrSYIBhpyF0yBg4CqMHWBQb4epxH2piEINcYEVSqu8yuTpHKJBbfRGftzWlnc3u3uID6aRPl88AcYzTL97/ry3xdZmf0cjiu+DeK5kCwaKNAmPCPc1pzsvI7i9LqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQo8kTrYyTOcnO5bqQ2nZO+tEz/3h6Ga8EyUXUCTzUw=;
 b=qui4eEBkLZfp+rwKkaviGf+y9Av5WOIQ/rKm+nHDwgKE0BuvINJSvmGFJvRksU8l3/hDwQAMiLOegmRvZeHMjwAerorwwK7mrGW/IWpAkVGGaIm/U9ZxjloJrMq6UiOZW5ZEizK5oO7WbBttVjdzYTeD/f2RoB9salPBGJNAL78=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:26 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 08/10] nvme-multipath: add nvme_{add,delete}_ns()
Date: Fri,  3 Jul 2026 10:32:02 +0000
Message-ID: <20260703103204.3724406-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::30) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: ee87e280-5726-4a55-3a23-08ded8ee5ff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	3PNwzNtpbRMBAxtzg4cXjLMovyvHE3J2RPqfaI0XV7GKB3/qtIk9RIRGZV/ZId0UiIE9OVS990PueQvaLbB/wCqzhYH3MlH9PsvvqRJrG8x1Zz2mYnd1aQQ5w043ml6g74HymDJDWj9eJyhgEGsCPnDglbRKoaVF2rk5VImKulu7qliuScO0EBlkXtvSHOLwdf4uZLMkKf2oozmsYVBL+9T1YpLDDaTDfxJNsJCvSsSg7tFWbVGkQ3ln3zKZAyDqWonVFo2kGKZev6xizlfwfK/zpmcwlZxEbp8mIb2NDR/05NNAQz4bBO124zML03i0Vnah+w1uPZATstPph1bWCAzyxlPlASMrk/+mySm9oMX0/ZJCrflIB4NIbX1PVC/3WGJ7CasQbFZ3OBJXPoezfPzmUsFg3d+hPN7U3gDf1qeAzvn2McSNfhLF6mR9fXonWXVLEItYxA0XQpiNb/DP86QpbzcpEskZJDhcOfqYLndiHPjw9N+wrUHAyNGJe/G0LsuSNycDvI7aE5HCDyPNH3RXpLZHgnfQdGXDm2xsY9MX/JV/9nrs4O7uwlKGciff0rGicZQuZ6Q541pj9vmlOJ9N4h2TFQRWPFV5NhSqfEXNzSHXID5K3UMHkyfXde2GU0fhvhOnFSAripI/Qsu5AyGkLJJ3gLtAmm5XigrFGL0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TCZiLe3SyRVYxVzgu3PrmIaurgiJ/LKBf0t/68MCivfQma5ll26pP+IuVumz?=
 =?us-ascii?Q?j54GNqjTFRiPpelfQppu8/6PBa+/2H0CPKNTxAUBi3tSB0B4wiq/I4xoG76k?=
 =?us-ascii?Q?gfXZrL9vSNlMWDt+3BSeWfrnsViV4M6gDp0RnA5ODEAo+nYGHkQKd72hUKt5?=
 =?us-ascii?Q?Lpt6DEM9g0NAWo1GyXJLqvQQMaZiweYdETr7R7hZ7Jq6yf661L1hzo772b5X?=
 =?us-ascii?Q?K1LH2otnV9WPqT464fbI4xZzjUIkvHwb0/CsOWOK5SNl5RSAS0XL6jvI6/kQ?=
 =?us-ascii?Q?V9jvbRKWKdQzfrB2ebOInk3fj1p05c2qlMG29w8TtQpFtcMbzmG1Tmdkw0fL?=
 =?us-ascii?Q?ukO1ltiAWL6xxAAe2kYLqKhxpS2t4c63LAf6yUTXpN/HsTSzYY0tdQvt2ght?=
 =?us-ascii?Q?lqnym8Fh04ZYmotfvDaH6O7CcYv+OQHnXpgdIKN6q1MS11Ost5bVflfjUfTR?=
 =?us-ascii?Q?1BMP6KpcCUVqR6X6Bd+NyNzykeHNJXCMiHEqcpySyzdSTRTTU3vu7QCENjoj?=
 =?us-ascii?Q?msiVmmllPE0GdB3BpduN3mLw1LHIAYt78I226cRYkHDXjVe7PR7Vnb859qSJ?=
 =?us-ascii?Q?AZuznAkV90AOPD2hG4VwCPED1T3THCx2W2m+kJujjxQ1ftnfINRJi5BwsdmZ?=
 =?us-ascii?Q?wQIB45TMg/2sTEXKHiVmncMS0kuN/y2CKEgU2283SPGPCWltRpPbMEu3jO+U?=
 =?us-ascii?Q?hLShXIc62YUafNJ/bAX7i2JiDLiNe66Gov3/6l4CaXAKUcj6ZuOQBKbm1VKt?=
 =?us-ascii?Q?chkIX23uFXu+dkf1IRsrNSfWW+Rr5FovoA34EemDQjlf7YZPYXwXpRKilJ+D?=
 =?us-ascii?Q?1eMjHK6aApZvKItT2lZLESn5Gth3dHOg3qmoByJjI/4l5WmxD1//ypfC0hVT?=
 =?us-ascii?Q?fqFVrGRTwbvoUTB3RxbsbDkgDcrzM3K2nCaANOatIedM0Znw2keT2FOXZb8B?=
 =?us-ascii?Q?z93rmrkCtwdE0sazZIDWTQZIyThBPGEXRAAWzY3SaRrTiDne6LRvrYpcFfVQ?=
 =?us-ascii?Q?vlYDPJLAOiJMx0/9NHQ1R+uaye/zaH3EmiJ4ijFBbrgfE7ovAz7GCTcxeb+O?=
 =?us-ascii?Q?S91JCIDQpSBp3Gxm6vcf47YCEWdeNC46O9pI35NSF7NlCIFp4dUrkkaIV2g9?=
 =?us-ascii?Q?mjRD8G1uYLWGmYh250lyJRZQ6rqIvsTbQABdSJi4aBXP8/wCaHEB4hK5VEeH?=
 =?us-ascii?Q?EuXpWL8Dgddht9FhxvQI+2okLD9vP5uY1lhsEW+g2EIdVy+Qy0LFbFInI/xz?=
 =?us-ascii?Q?s6xd1w3l4GfBGh/2/zJl8X/tUs2onemZdAndKTM3pj2UoqA/Mv9lmsFPn1Jx?=
 =?us-ascii?Q?u7OzyJuE2CNE4+toawgElT+ttBoxf1EL0IjDhvyaf4cnWT++wHwh11Dw3y35?=
 =?us-ascii?Q?s5PvEdDqNFnbFP9xtTe8UHEuVpG36v1vG6NGXNRCegDFdMmiiU0ohr+nKB/c?=
 =?us-ascii?Q?ObtbDBWtWK55wB+yaIGyS3/96JIAB+BpfoRRJ1kkFCFIZoimkvfjumx+p7l1?=
 =?us-ascii?Q?GUcSCqVvrJHfX1Vbkw+K1jMrB1CdU0zMj0Oi6HCxuyL8Wn6N5NmLcWFdjO2c?=
 =?us-ascii?Q?CKjsrpuA5Ck0lXgU5BqI0ZyIzmPLZ7C/2vFERsYTP6hIEA+ptIUs811vmRUN?=
 =?us-ascii?Q?stRvX+I6Gv3LtDbs8dFcsQceIdwcWXnSQt8uxRIrHPZ2Kw4SPJWGh9xBboOR?=
 =?us-ascii?Q?nfTdhph5ILbvNKHlTyfqc4oJnbXP4m5R83LaAwyvtdjswj0jKJ4BPp39Ndtt?=
 =?us-ascii?Q?Fnyg59HS4pTPs5oqUY7HuJigCSSHz5k=3D?=
X-Exchange-RoutingPolicyChecked:
	mcYyzB/T7K3HxO7NvRy6V0BZOVa98mwtqIHMtoh6aDfYcIAYNVgGqxejKivVXpnv/g3UQ4B54BtfMWAkA8DH4LFRl1CUjk2tu5L9L4K/L6Ysp+UXGBmSNzBVjdf1tIOQpAX64Yok2OxrGyXFl4JYbaUVeDZAZaaKFPrWt0h3bVds0H9aA/3SMebxVhcQXy53WPJaj910WIlzfe7mUmAyN6S4MlmibURmH4jBGm4qZ+fnrCFWF5Mw+iQSCrkfL9IbmQ1zAW+qQcp4lpI6aJhY1uoxOfWuAhJK+9lD/tm5sgPN14fkFjRpbnnwGqPetWB4shG1VndUcRrunh8IEGnbwA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YV1Lv9nFOvjHEAhLVd2dJSTLuKbwHty54kEvBchNuORVO/jpkVFfHebFADxiLplPr4YZN3VowhGFZKdn5pFiX5l5voz3jnEc9F94mttsoKAwnUe0mD3FOd3dAGIm5PBTBkoUctyM58vmym6RxdHCLYfrERoUBA68/e59kjSMI2LraP/q9ZReHyBsHcFUmyr14k4fi/z8RBiuBemM49AzBeZCbar8m/iqlURxIE0Dw/gLhIQy1NeNIktIWZC/L7ETpoovd31o3Mcj3xb/GNWlr9gZwUKwKGZn0FXFUcFcWC/1yyY+ywQQMITRsE/TLLSn8hneCw6f2id7gvBKB0XkvxkTsArqI0c8LoPvU2ikYGEvZjZLNKDeV9Dns6FLCnlVF9YqDGnuGW3h4NoHeJ26uTDIHGOf6IUjhoEWt1QiM7B7TBzWE38+HeRsRN0ygTuhQbbjPW2Mzn91UocgHsmJii6cgIDgZnVGNW6bz4txDegHgctrwRTZEtNmAZAoIf/DD/DOAfRo7ggrB1S3plSwfXMWQljgIoKJQppbuwihQ0pwDZOV4fMy8dWsR3wXhIQKDHiNAtf9M/L0vPqRnL+zfdlpe/Dhg/SN/HprfCEMt9U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee87e280-5726-4a55-3a23-08ded8ee5ff2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:25.9569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: igcAP3XOWmtBXOJnv9uS5Fzn0uNc/X6P6+D4fZ+mriMUraMYaN7mHkHRHOzPOLFU7SU6oSOFfQlNoDfvXawafQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: 12Clecea9zNIWrGVZ6sisNdwxAiudk_4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX5PGiPzraUgOH
 xp804FxEqObSFl6rkUD6pDjXSx6QD6Hz5CGtYge10tHqAHKQ2YX1GR+AZUdM0/rzCojZHY9sy5y
 ll8DFRPIHl8pBf4Uz7G8l8tukbIsbcQ8p/6687Ur8DBqdwKgV/Aap9O77YxA2CBpx9V3HHfBAAe
 ttA1LLMJaH/JCXPeFjETaTw8dH9EPj+LoqbjLaJIX/Zv69eJJERxUf8ZwTYoYUtSoRhovRDNqaP
 bJ/BCJ+I0mdiOpJd/FOJ/F3Q2+BMHLfC/eJN3IteEP4RbGGWGBVuicm4nKDuewAIdYDDjSUbs66
 ar++aueky7qIyTnc+cNZlFoc0Da6DJrbPo5+U5VhB9O+Cm4oq8WXH3BydedLA6xhtZEf2DZtLAE
 vT+ZAaQ9lA0YoecHNA2LC1pIBRaR3we53FH+mak7L6qgKJXy5dfSs4SBLz/9msWa3VRaZasPeNP
 kpMqEmxpWS3Moxrr3sawFNtk5BfxBcQZMojvD7Tw=
X-Authority-Analysis: v=2.4 cv=LOxWhpW9 c=1 sm=1 tr=0 ts=6a478fe1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=Muhl8PmVDvaFtnfRlhgA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: 12Clecea9zNIWrGVZ6sisNdwxAiudk_4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX11ziAOmEcQ1g
 qCPkGEtdsPTUkFFkDh6xUipoFiKqINeSXg2ZDEZ15lqycXiiTVv7ti7s6CFxbI2udgVxQJUhvrZ
 qoh6fAcDc2lAJFkRdh4K2QbI8yVRPDI7yTcyShHV6Qoj064IFfgu

Add functions to call into the mpath_add_device() and mpath_delete_device()
functions.

The per-NS gendisk pointer is used as the mpath_device disk pointer, which
is used in libmultipath for references the per-path block device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/nvme.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 292526c9dda29..9fd958a426f1f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1041,6 +1041,18 @@ extern const struct block_device_operations nvme_bdev_ops;
 
 void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl);
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
+
+static inline void nvme_add_ns(struct nvme_ns *ns)
+{
+	mpath_add_device(&ns->mpath_device, &ns->head->mpath_head,
+		ns->disk, ns->ctrl->numa_node, &ns->ctrl->nr_active);
+}
+
+static inline bool nvme_delete_ns(struct nvme_ns *ns)
+{
+	return mpath_delete_device(&ns->mpath_device);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 {
-- 
2.43.7

