Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B141A4ED;
	Mon, 27 Jul 2026 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163423; cv=fail; b=RWUZWVitO0eMuskyWCn/gkEmwxLseTUa2PkKEv8rB9dkatBUM+AiosBYpDj7HT/AN1M9So010gtjrSN2ruTu8Bb76q98Waj2bvKGBBdaHMgghAxYKdbhaE1sULHU6813pZCIoDHlQWvnSz8ct7a6nC6k0zNdfHJzLN4Oc6HwWzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163423; c=relaxed/simple;
	bh=Rq/I3kzFqdEsmsrZnlU8+fwiLauI/ggXGyMQPHaR5Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mKgxZPi8gULzjq8eA4kSGDb+SmhdKODNPDtHQ9ws01NBVRkN/lMXeWBBwBmDhnE0xOWFb6/jAYUCFhDj74p0NaWgzyZl9S8tGKik7vTSJkLxulO2yrO43ajs9X2CfCRwGC6M4zF9O0fPs9IkVYywxR5B8oDf4j8whUAViimS5z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dDeLP8Iz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EnaSVjHD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dDeLP8Iz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EnaSVjHD"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTGoh2082260;
	Mon, 27 Jul 2026 14:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p/r3u6Np4wxLlcGydELi8MgHPu0rgA953rxLpwVZY6A=; b=
	dDeLP8IzBCnM++Ln20E6HOsn60/Ce21/swVVu5cWb27duJnKl5+gIGkFs73QlPFR
	cUxp2aYDcbYpp/oCtmfY2t8VdKKmUIV49Jgi/hiJ/JrpaEm8raeclSu2NTCdS5Dw
	FrpBWtx8wJVOHVV76meJVZnpnySPsQ7l3l8ja9iKsPJ8IuuI4Xo/ly9sJmbm/w5X
	iQYQVkHRBlRLS1R3OVyGNhCtFHvVegUBm88/9cMMYC+MjHuRhVMzAFXxemvgjAuC
	D8E7mSfjS71K8NDWKE0rMcqjsFUqeutqvy+5hyCPbPZQlQkp4yjFqyccT+dCeGyX
	haLjpZC6uQDE9A8qHMhTJQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym1xkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBOX006867;
	Mon, 27 Jul 2026 14:43:06 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehaw70-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hU62XhWHCwkPtc0aKAxsisRpDysdpoE4cq/XmtDZAaZd0UWtXGrEZ4dhw0evPD25druNK2wV82vyf9nvW07p53qQyjNzY5lhO+99l0Cuir0Q4CNJIsyBgBXONKuTzBGemGiHNJ4FW4sJ8fvju99grPA3MJfd3uCTZtmMEl9J6NOjdw0DQMMugr+ix6KUbdylgW5g+c2RP7nD2hiUhfGiYP27p3DuLgz0FO+i6Ra/3j5huT92Bm2w7ooMIJx1LPP071uiNqNL59jlSZnOh8zeGZ8RVeG+OFpoj02sqnscQuGmMB+AoEUrNG3citl/UBJ/PC50beDkz/q4cmb1youeMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/r3u6Np4wxLlcGydELi8MgHPu0rgA953rxLpwVZY6A=;
 b=y6wzwRCT+l2Et/UeNGYdRtcQsREVGcCe4jEgFsGS10ITtkRrm8rO+x5KX86HBvA08+J05WtohnwCzL48Ee60YZ2Rqgzr3Z88mgmj0MzP69eOGksj+EUuzuOtq+yeu8Xip/Ck4VPWe7Bx9xLxuwPk31x72zpr8QeSSY6yA29t8JQWISaqg9syJNfzsA+U5oIlzqIxgcA7mCTV2K8mjQbmSHA9DHMH/nhQdTQ2F9ZtjidtJbV+lGElV8IYhvkV7u0kg0sMZOPnGXVIuXawQsOI2WMXntVwO3J/xiDQHAp7fVuRCc3Bzj5i49uDew5Ts18pDyTuwCtdI/4WhHy7i0h3JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/r3u6Np4wxLlcGydELi8MgHPu0rgA953rxLpwVZY6A=;
 b=EnaSVjHDIW8HuAVM9cpCR2cXPmBDPLy3P2ntH/3dtV5q8kAuDzO7F2m0Ig66SKwFGUeIAZ1RTZqoNBjm0ncwAMdnA6BEsr4v3SVrjCkfegAkZfuMQaMbiYCQ+cm7czNrYijGruDT9KOULif3a2QzW+bRsifCDIAvNoBoFoU70kY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 04/27] libmultipath: Add bio handling
Date: Mon, 27 Jul 2026 14:42:11 +0000
Message-ID: <20260727144234.3802948-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d10a270-5b9c-47e5-c8b0-08deebed5bf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	diw7+YZIdOHTnoOFbYS4k1oi8sGEyjZKlPc31/Ayn64ilpsiF/OhD3qBuAG7zZqk/caUVV/PrGrKkTCGMhxkQ10J03ji8hLDw+kK/0ZibKm2kKuShM6MeRRw1HraMgejtkmnXXyTdyRKHYPTJFs51j/yLmoKaT64Ag41sjas2x4WxpqZRuZ7I60vYGwaZFa+6uoEqBkVUlzpOWsy9O3FHjK8p4V2qEPiqMkZnKUqJBfCmEnC6es9SP1tiOFJajtf3GlJik8TTuTkQCnYi2RFndRflpH9dZU7dvO+G8TOvthXdKD8m/NvFYvibDR/6J2Mf2WITdaX+CQNs664rTft6s3C6/NFjjsvDHqdJmbnoON5c4ZKJNtqIIUOSpaf/fA0512SEeizD7k0qQQK8kfgk3ZEqjJlo/ydaTqwCk/OuX+Dmhkorc1tSD5xdP/x+maQ30CYzBsYhXKSOEaT2f1VD5qnjtiyObBKD7vHnaPMFuA6M+trV7JrgtduXBgS0LOkAuhJb2BXvuCivgurCsVWMsu+byELSpde21ZFU/PdkS5udLZH/STbrL0+DK+ByDpuGFgwfLJ/1ZJAt3au8nCfaljCzFiYKjsw0a6RLpa4V2ov7gFrCWZAnrV0ZRrpbRGNAQSmLHXKsM9KX85Ruqja56YfvQ5JrBuC+g6WKcZuVyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RJghhsdwGsXoKjYFThGzvGrFLZ+4HvESbvnXm4+Uh8mrUM+CmDtoKWb0fy8T?=
 =?us-ascii?Q?+KM5i+A27njMbAbE1czJKsQVGejf4FafRI9GNwvqFO71eGqOK54s+JGvRr0+?=
 =?us-ascii?Q?a3Bc6lZCCeDn9PgLRZ+AyMYexA31k4Bc63dcLLJpK1FxZUK+5wbiiCZa1aB5?=
 =?us-ascii?Q?E6IsMzVqiaAiJ4KUYgqlgOof8MtQI1Mdg5nF1aa1gDelb3XnyjrCPk+pB9Ih?=
 =?us-ascii?Q?BXAUQorgpffMnt3ucM3kAO0kEoK3jrtqk0JXgYgDJG71QqH9vnhM5kMq9/K2?=
 =?us-ascii?Q?VmVjHL8cevT3zfRKC4Z69lANb74JZzqEckBKvXXf+TALJv+Sv5b7GyjHeuHl?=
 =?us-ascii?Q?F75dNvBpS+Mdnp2cw4b9f9E+3ttMd9Fdz1chyqYLiMXVxxWdtlEE8VkIFmpg?=
 =?us-ascii?Q?poEhCKVmIznyNyPC13O/SY+FYBF2mQdDsGzb/qFXoqhSIV3tdBjj9mysWQjG?=
 =?us-ascii?Q?ewPfAkk18KG18jUipWoxaWZ1+jiqCm6BtsV2ePTOpBxUbPyTEOGcGNVamSqD?=
 =?us-ascii?Q?WIty6j6ZuNaYc5Vrgj9HObVUNyygNu6u6bOedvDpMEF4VrIpEWjjkywjqpH+?=
 =?us-ascii?Q?R/NBNj9+T6GaNz4CXA/zsmKonxx4EGdb3uDyTKNn9RheZN2bsnOsFORJQauT?=
 =?us-ascii?Q?IzV1UliCftO2fR178301OZEGnEBAuFlSlB6TKnFyJtsQRWO1Os/mc94Ag5xG?=
 =?us-ascii?Q?SfoFpcDINsDqc7TkCo2MWi1qg3I1Qbd12+3bQIhiXLKU7wctCkvqw8lMldPO?=
 =?us-ascii?Q?eUmusRIszW1qt15Nd3gXSsIfA40vhR38fJ/NFj15pA95XQPStHVzUnBK5ubN?=
 =?us-ascii?Q?EnZt8HHyxjYbDSxx4jBRgV6sx9gzq39Hn+Kj5LKreBReb/MDlxQpvEUkPK8y?=
 =?us-ascii?Q?pyWDOmy+LndfUKTBVBinr4ss9mo9v2061U1Cr/CpwUJRENSgwRvcdESx3YJG?=
 =?us-ascii?Q?QwZvb5DI9D/8eNCZ8DP6et7c0ObW9CUoONtPy9+jZqe5C8n2eFfKqbr6TDU+?=
 =?us-ascii?Q?ApGQwDyB2MPPbt7UqjXzm7HrjxbcCIzQCssWkXAh+gGat3fX7CPRQLajArFB?=
 =?us-ascii?Q?Ojz5GvGJcBGqWJVRCMaKoYG0EjYzu67+MSEYOWq8EbHO6Z1bSZiNCyijIVFy?=
 =?us-ascii?Q?u9/pmnk21fH+swz07Xy/EfARR5gComofsak3sg2uRDNVf97ygFVRxBFZnqKq?=
 =?us-ascii?Q?eHApcCZDJJE5/RZ5ptMGCBDuIztXJAHUzCbTAzZei+nwhwTA6LXUIQmoLMbb?=
 =?us-ascii?Q?GmGcADqGcE6Vb/r9tFzw/JuUOdvImdIjR1NH86wWYFePb0YzTyz2wVGFptKc?=
 =?us-ascii?Q?JwCs7qmL0t+G9XDCymaAB0JAPgoj2Z8tQZxQ9x1IJs1X1dbzyT7Km2535CTl?=
 =?us-ascii?Q?6NpLnx4S+LUhyuzrR1zvvdrdlwuBVeRpEgLfQPtdb9uLxaacHf3CWWm3vyTa?=
 =?us-ascii?Q?IrFwFAd7ZT503RQGP5IMz1/qYA1dNI0Am6oF8RpY4hw81BevDXXSQyfNY0F3?=
 =?us-ascii?Q?WiqJH+Yl25hguRs/7jM6KRkE2a4Ng3dS6KaRjB+mKW36X/NnGEtppb8WZQ/K?=
 =?us-ascii?Q?mAYBlVbZlioK0WF2M/XwDgqJcJlCKuQNEBnBE8Y7rgcd71s6leok+puQt3Aq?=
 =?us-ascii?Q?QShGEK/nF/JfJVpZojTwT5intm7ozjxz1nOYuBbW7yieo1Amz4O43reFqJcR?=
 =?us-ascii?Q?/pVLdoJ7GhAX8dwfLOZjFo6WTv9Ul0xeMPu7iyJdqNDL9cz/AV0+mr4YfWlv?=
 =?us-ascii?Q?xJInQ789jICwbXEnRrJ/H/WTFiJFEiw=3D?=
X-Exchange-RoutingPolicyChecked:
	i99mlogpx3s/5TJfSIXMbiTRHb5t/G7U958Qp6zE3eDMk3xuNRbowh2Ht4krdYI47KbbjjsnwZ8nEnuMH3sz3p8DK0DPmj3NPVNeSdRl8l9x/i/e6/z6q23SYykRon54bmR13YhZc3RSYpImAssmF73zOarF8Vb5Gsce0FuwQ5ytJWLva1sMBgftDfGbTdQldwvMqo8uLBKU45snuwZHqutnSWFiz51npB6Apop0grQmQatHh1hlc+en3K0PRKraFqIcwjmcsJrAB2dnz64fITq09pzCCILRWoFJgLwRtH9MKoYPDOegBETnMCPL+9djmYUQfXKTO2ffL1CduTMqEw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z/lBiBTAyObZT2RXa2ipvhhJ6BtW5Q2L/F+D8THTvXqPPh83AyirtTGtxqfYHWrgTqCsYnU1r4raPm1Ms44bVsvUexvzLkaAqkc4Oe4PLLt2iEyfZF8iSYEE084sPvDlo1Bc54brlmbuEWdLNCfnzbKln95En2/geoe6NIBpiyd77Tt6qbvpWIIxcZW1R9ekanOTIav+veb9jcZZVuJG0ur0N96q9QBVkHh4B8SCCIC2UugCtX65Nxh/Gqjbn2UWv90fGRnLdf/HcYPyHsE3ZmQZhabbi7NKbJfrn75A3ACpRcS3hk28xggu3awn8jgapnRb/K6hTyPUEuQuW7FB10eFMwwgXEcuaQ+LnFx/QUV4VD2DS+otpaQJAKipJ/JB7LY0q7AZzmH8K+UnqV/aM4c7zDxV59h2YVwEs0miqvJsiZhO34leRBKOXNKbXDgIJ4pqjLxT3CVHN4vV35faWD1tJvRF8r2iBpQRWS+3Oh4bYhFlZ4r2L/0hvTnOPOSuxOxiQWEa4HaVKFGuImFEkN0IniBY6P/JWr/sVFfTVtBMrpuWlxBXoBdTNA8llI3QI7eM9388qyvumRT59q4LAT5KDOEcAiEXzzReHD7wCFs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d10a270-5b9c-47e5-c8b0-08deebed5bf3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:01.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ITA97BlwrmgcPfhPJ5HXo05DFryV6v4YDoPlDgsJchupm4nOCmIiUB4ZhuG5BRIhpihU+8mN1EjSKQ+LNyejA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX8g5nMQ2CKGCa
 EVog48BgHEYE3oWtbz0aGJZN1LV+3Mcdp2ljO/QT5XTH6Jq6HY2aquCQxIymgwxIYVDFNJMjVJo
 7hIT2c9kmYBjfTPV63xsj7sEfMoAx68+l19sz1uNiUzEyqh2T5X1
X-Proofpoint-ORIG-GUID: 8QvlGYD0bca3jh9g4XtolZ96cXE4gGe0
X-Proofpoint-GUID: 8QvlGYD0bca3jh9g4XtolZ96cXE4gGe0
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a676e7b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=0Q2gd2vOsnR98QmcnEwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfXyw7HzU/vTarl
 pKCpp7xLY8T2fxh7B39vZMwgEDEcSYgndPEIpq0trbDn7p4n9jKtkl1ZolqTnWuEMBBbF2gQJrh
 ow2In9MZVF1BZxX574Lq8YfNjDAmweIeNhcVPYs/LI70pM/OGrW+JoBEeahG/Zr85pBfeVh3lvG
 ACFQKc9Z/Y2jFiaVjrLo+nGsR1RfarE1wnw//WQO5aHDbZePADh9Xgqt3A777g1oG6QIUrwPzt5
 PcCnifToCXgA1tiJ29Azmqw/EGqLxMf0ojQsi2+rbmAX2UJVAMJOgpqTd1CTiKfdyt8YGmof2Hj
 ny5KZA0ucZS/bToEGvhYBenzKtbvkGWuSWwzOZz3WvOAktbpIUjGuVSiRKwcH+GpO9k77Y4qo86
 0jYQzvP01w8UVvspfz4hXJ0nQbDEctuq77AVhXDFqON/L3hv5Z08wcz6QP9MyG95/wDqGBNVUfz
 uVeCcwkhdW4ykfLaQ3A==

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  22 ++++++++
 lib/multipath.c           | 108 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 9bbab0aa8961a..374f0531f7e07 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -29,8 +30,10 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -44,6 +47,14 @@ struct mpath_head {
 	refcount_t		refcount;
 
 	enum mpath_iopolicy_e	*iopolicy;
+
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
+	atomic_long_t		requeue_no_usable_path_cnt;
+	atomic_long_t		fail_no_avail_path_cnt;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -53,6 +64,13 @@ struct mpath_head {
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -96,4 +114,8 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 2b22c74760868..db5f83ebe5d7f 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -5,6 +5,7 @@
  */
 #include <linux/module.h>
 #include <linux/multipath.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -43,7 +44,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -230,7 +230,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
@@ -245,6 +244,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_device might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+
+		bio_set_dev(bio, mpath_device->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
+		bio->bi_opf |= REQ_MPATH;
+		trace_block_bio_remap(bio, disk_devt(mpath_head->disk),
+				      bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+		atomic_long_inc(&mpath_head->fail_no_avail_path_cnt);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -290,6 +364,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -307,12 +382,35 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
 		mpath_synchronize(mpath_head);
+		mpath_schedule_requeue_work(mpath_head);
+
 		del_gendisk(disk);
 	}
 }
@@ -324,6 +422,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 	mpath_head->disk = NULL;
@@ -381,6 +481,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -393,6 +494,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	return init_srcu_struct(&mpath_head->srcu);
 }
-- 
2.43.7

