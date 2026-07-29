Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECEF470133;
	Wed, 29 Jul 2026 10:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322359; cv=fail; b=C5iMa3yet3+UQcSy4zXuKRiUorG4WK5ZuAmLW+eboFzkSXnmZt0BxbBCh9aGuKedZd3EthlDuHElPIVbm/ZlJP6134tgY6bXzJPes8mu1jzXr2zyVYhZPmSsg9oyqQ3FrT9MMuNqA2At/X5WaUBkYERvCcpC51eK9X/G0XzS1K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322359; c=relaxed/simple;
	bh=qp+p8WCQK0PCDAWZEEWLK4N0bbsCUCCrJ2HLxdGKIps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M4IqwDzhgvBJ0o7Igv+/5pchE1+kG3iw7SXRnubh3TKOTqfVT6BJvr28iAFBVV0qDgDlr1qDeO57tw+aKVpIHHCMHi/jufSq5AljF0j8k0Mpw3PWuT1V64Ebv3ShozkiTX4kNVMqay6aSKUod7OPKQYfIwbixlJII70kXCDD1vY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DkFnF8OH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=erzWEt1X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DkFnF8OH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="erzWEt1X"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9Gt7M1094297;
	Wed, 29 Jul 2026 10:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gfL0Q3AHGbbHquhe1Nwm8Z8J5n8UBBhUdhoxkGNg1Dc=; b=
	DkFnF8OHC1Ej4jnGhrULgc7BHfi4GlEFX8ER76XAsY5lLrY/uijOWmKA1Wcl9Uwj
	fA3QkoJ0JF09D0Ws14zwVMEPUvs4quRuA/Zj3uis9ELAnfMr9u3oPTzQAuA1QdZL
	d+A7XMf4nsO80DrbELBC8CsO/vV/iGsl8o36oRKvHJ5nd8qLofr88qNpjViqSSDS
	5rMalAjROGd6msnAhlhffsfD8ZabOxF4i6TOvAD7LJA+Hfl8WafR1thPIgOk9tTL
	kRaY1KQD1N+zHli5by/w5Tr+dvwca8wnKXOVEBbm+MQZxFKiCJOapSzmQ83SeMGY
	yf8MKHYgCh7PK6vCC03vbA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo6JQ040182;
	Wed, 29 Jul 2026 10:52:00 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrkab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uis01IcpUb/Re5ytD+mygptXqOsVyvCDTdUkE4/MqZDVzPZy8v2OByQXOY0DhExubnSH10ZF9ptrPzAco1PxRMWpPvgwxbN//GdJ39kFXZjlixDJrQqtch5RVcWKyZE+TwYtJL3M7Zq7eUzXVl1hg4BqIx433rgrKdINroFA61qjyb3Xb/zZY2wdu8pKmgLqb/ZKRiDY+KT0zLPczSAL7V21EWHXMwmvmB399HJ2krC4+7K4W/N4JRa+1Fn+dXxskWu0Vl7L09bpODM33jsLSGxoUE/747H8bNnU2dlLeDIWroDYtmp9LM5VrZrIbWM3PsuxISJcGufqIkpXzjzvKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfL0Q3AHGbbHquhe1Nwm8Z8J5n8UBBhUdhoxkGNg1Dc=;
 b=xqxE5eyAeOP4W6mEUPkY5tW4ihVRESLqAMO0X9+FrAOERBRw/kbqwS6WWj63c+sN6wBnDmx5lhewhRMsbecdjujOOHRIrnECkf2HUZSyvrmlFxaFXxMP7yJRq4jhIikNZZB1FBA3Nt5JxOnsZ5bQPCnajomjuch7MF5kpJYzaYYp0Wl0a1SUiZnqaELd9DC2LS2Aj9gTkEAvci6/2ZyKbjfJ2ijpkqqtQr8VRTzMMjsWOPgWSSHTwwrgYAei343MZU+9zlWP+CpH32qt35dPp61rCH4r7o9zB3X8Blxt9Os3RV3CU5R9ai0yaE+3+LSEvs4qcIni3peB9Jp0cnL1yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfL0Q3AHGbbHquhe1Nwm8Z8J5n8UBBhUdhoxkGNg1Dc=;
 b=erzWEt1XBs6N7KQ4szVj3f0D5xBrJGjFFRvH6Na+oP1YPvYbEEPQsKCcqiLjzJvrvD8N3rFAMibw9AtAMMPm3f4WvYylRld9M+0CdEE8v4KHb2sJAyxpzNmTdCzPJ4byH8ii1G8Rc+lyCZFWQ/AF0kjt6yCtk9dOedql2EY/R+4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:51:54 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 11/27] scsi-multipath: introduce basic SCSI device support
Date: Wed, 29 Jul 2026 10:50:51 +0000
Message-ID: <20260729105107.255712-12-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0069.namprd17.prod.outlook.com
 (2603:10b6:510:325::29) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: ab97ee9b-04ef-41ca-f952-08deed5f6701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oplDzhqDLAyW1h6dpYkq1XHcnWSJOTAjkjS22lEqGbHFFmRt/Bzxmm2tQbHN2/26mDMgbIPO4OiBNBRUJzd8QEq0MboWz+D1m2KIl7R+dP0HWuT9wIuqchdD+t66mOkggbP0payYmxoMD8Wnd6Tin/jSPLxAegLEnKv+RHdDUFznyi6djCYECe3G2QbOrc/3et9BQCSSjFpCoBIByDjGenAYRk5EpFd+U/FUmHfrjulqZoaM8W8LmlLCMk999rBgO0310KX7PlKWHnNqFQbzoesdu6weYCwq1UkInMs3wI0HtbGLoeDb2mpJf2vZ1fT7ujWjdYuu8B0znGR6Zgjw0r52N/dNoE0deTgO+tVur6wykCzW9u5N1P6gogVWClyZ53MGVVP4p3f+wCXs3thr4SgYOS+YtbmESDXLZEAzayXKo/EPsQ7ILQcpNi1L+tq/+yMK6VduNJ3y7bBKu3OllxyqUyaXofLRX0cMar+tXTrrx/XlOPTuPzH9Idd6QoCO8AAPequDakcE68ggsUd1CVxkIxyvspQqJ3ci8p5+N2HWpwrbK+Bq/qppC5HmlkmlXyNHLQ6dDsy4W4xSEAae8KGn5xLZFn0WPdIDWohycVmVWczu/F4qutq5CXdM80cg6joXBk32orMB10HJWq5cyB9eS14Av1ltD+sdB5WMM1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?35pZrLwgWh2o1Nf2jL6aojb9TxMUzBOpDozJz+AQUkkZ41nyC701HR7ysmkV?=
 =?us-ascii?Q?r9Xa28+tLfMU4anhJ9LZ3xWZJzXrAUddOmticlm5dudhbs7HpTWc5fXoqSYB?=
 =?us-ascii?Q?b6dGgQ2Tp+t4rsFFNLkhHe5O7txG0BUWLpX7VFK/q8U1QO8WhTZ8NuXzXjwb?=
 =?us-ascii?Q?Z6X66wYliPsj9aaArt7z25PfmdRi5hTZVlQ+UPTYYGUoMc6zhEsrOAP/2Ce3?=
 =?us-ascii?Q?9+/AziMjbdP+FV9qYJoL6XLVVVCEszBOAfz/liHjr9mcsuqIwqllJMxZKL71?=
 =?us-ascii?Q?dSy/m3Rx7xb4NBcdQ/qPSiGx23lByVtDW6wPUgHoDD9GtTcAGiy5OxdUDNRV?=
 =?us-ascii?Q?BL1XIveH6o7B3eMCfPOo5lrYZyCWV7g+Q/yRovREQkXAVpHrhwL4Kej8kEpS?=
 =?us-ascii?Q?4kt+egyRv/LaJ1LrPhQjNuqNB2S1te4s1ZgVDp7ljyMeW+On6twvm9kFcK2y?=
 =?us-ascii?Q?CrhVeCACSjcTLYSlj/PfcjM1D5Fe88l+pI24au/plq5V1H5xM5MnMzUtw2fR?=
 =?us-ascii?Q?zf/lF+f0V7+vr5GeeeVOc/YxnNl6/kCqCPcPWnVYHhJQwRsbzL7ppnEkOqjj?=
 =?us-ascii?Q?mUPkTyi3q/aSGiZMBIkLHXQDhpzcG4M65a1sQJ2VW8WOm9kJESYPSKR3RKVH?=
 =?us-ascii?Q?l/XlddsEhxV/syOvZS/e1PnDAH3gRb1Yq/MXJ/3eiiB1dQRl64RCI5YBWS4N?=
 =?us-ascii?Q?jkR9EFoTOJr4QOJHYxEJ4b0HIHwliwE+3DQ7wNR5bD3r02HgIuX0B3Rjz7/1?=
 =?us-ascii?Q?DbCtybKACKuwnr6d1/q0NCrOIzHpjGuvCnhDR5VgWqqO8f00w0n13ULOi9IZ?=
 =?us-ascii?Q?H+3nXiKu15XKe+RM0yf2Gmjbg2kB/S1WjJnVRxgoGz4j4V1gDNSQkZg6UuoU?=
 =?us-ascii?Q?MJqJAy21Gj9K0XZlHYYYyGs6ylOJmimZcVgJqkUGQOX94oASWVRGhU56bslv?=
 =?us-ascii?Q?HAjmr/g7P1vmfWCF1AZKPymWIiVz7dwxOFvwwvaiqcqiBoVwPvPOvoBRE0D1?=
 =?us-ascii?Q?VWqsSm69gR1qUL+IQ1CY8yNRn7+C2B5KnVe7fB9qhECWQCvbAWkMWcvURrg9?=
 =?us-ascii?Q?jBvAx5TgtbBcILzV+qKJrJYcwfEgSqmPDqCZcBfusrYug6qm3kt+Z9E2V3Gl?=
 =?us-ascii?Q?JqN6k1YPXUdmMfegq09x1T3VtiboKmWbwvcCcVJoEm2BIwFbQ3XX5ZGvhxBz?=
 =?us-ascii?Q?VAW7eCEoXIq94xt4Cp/Oi1YFE3CIowlGnHC0udZpenGOYQuU8Hwy8tWI8a2f?=
 =?us-ascii?Q?N8j3d+3OhPeEvhbE21e/4TsuO4s+rfyo+wWCI2u1zNtkeeb/EtDmS38vPYqe?=
 =?us-ascii?Q?J1iqSuNAffPLxtpmrFTLlMJV94F3HOYN5+CZDBSJ5K6gAGFgjmOS923DgS04?=
 =?us-ascii?Q?mKMpNXRSZ8F13hfOMmCqymVTztOPSPDuXRkYm3ZIYE/ZO6U9IHn2VkbKLoDJ?=
 =?us-ascii?Q?AQ6QwTLMAz9TgNx/7+id0yo5SZiNr7NUQTIzwU+gJBWxongwEdXmzO97xEvE?=
 =?us-ascii?Q?iQ0t3Bj70USIyLHnuL5NsB5bqAC/oat6zZ1XKux7A+QX8HMWhGAXGyJlso8m?=
 =?us-ascii?Q?siQ9GQlM5a0GZgeicSb5fgV/MUYL/jvFTfJaJMn6dtZ212RxxD0fMj4IYoqV?=
 =?us-ascii?Q?pRZvCLClTd82YTitgvSNp9K4AX3J1MmiDpAvjX6qFTciODq7nOblTbgDXiOE?=
 =?us-ascii?Q?kQ6i5XGwgcasrGP+YUVH6GL6DRCyVmVU6AkIwAeYwRG0JSq/DJnjSgWCIuyP?=
 =?us-ascii?Q?SlgR1uyobQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	C87tFxYACs6HUwStLP8vugGLoLSecOQqZjWFM22N9CI4nV9CnQLY2GYGAqSUo3jEKC5c+qHUGI9TLmHf925WrawkdKQ9jYs+LXChd4TWKfJOGp43S+BMXpufgJaoiSDxjVdHvcwyK/nhOnZBSjsMe5gEd9d4YKoACQgWAX2d/EBX4rKURInUWWrryaHs2KEjDD1JOYeM+RV9YZ8nLHJvWx3TRgF2RibmYk0SnOvdhVIxcH1WikS1u5bKaT4gL2S/qVshqPzRMp14YQmsOqN4QolD/M0s4e3m20f1ytroOuZ5KSx7NclptVgRrq0JITl5vO1IW0sNHQvwmOYui2H/fg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+0G6ICvvg5GNoXnMqMahKDprfVqgpXkeQ8fXaGlE9wNllw+L30dMx27kNNFZIPyvRX9pN6RZW8T477OKPzdQBQiXdAuE5/6eo4cRZ/SEaGeDKD3vPSgstB52pM1pQEXEEv4K8V7YkOfIh7I7Uv0MofI5A1qXWcirw+tO4fsigDYZT36diskONCgNOR9U5N4xsyY0WmRROsN+vGgg7zHv4IEonxzWaq+arVwMAZYkqsGcGhKpSDF5yWfj1cYj3uNWwhysU1Y6jaHz+3unKtGkYE512xN+p3dwFyKiG9CKvQQwD+VyJpItt+sGHYWCcV4uGuKKpZPt4wEgIWQ4KKPfIrz6uC+RMM3qLDtPfH5psCr9lR2hlog6AfeSyt05jB6/7m8yAbY4QyDENmpb1Gn4EvwxlCfAGH6K4VW5swrvcAHHbr7ACMMJrgXaWzQY4GQfbNY0O3neuT854zH7525y+hUvJMAG4zjaKiQxDubb617z7YAkYcR1iPshMWmRU/bJMWVOHfdlHukKTCX3FofPxoQMzcW6u8jWR6UR7Ygz2snZ2o94QOh3W116/kzGLYP4Xf74M/Ui/ektcr20q6oXglehOsyYQoapcLOFxdNy+lQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab97ee9b-04ef-41ca-f952-08deed5f6701
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:54.2681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7VsNEB3gCg6k0qEBWlWNqaC8A0+YEzt0Ck2sYohrHavpVAVaS7RB9lgPwv3+KGZguy8St6WPo9T+pJeCdP3Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX+c2yysixM1Sw
 o34O2Dk4rd5BARdEzki9ufl/cgmQS3ySkm6FVkjMPUTArzACENdKF1RpS3Ro8Y4eIabjP5sWaNB
 ziF8xZYTIBAkdzh7VSdP+gyElokq6xoTVdLZmyumTnb7Hs0b8SRS
X-Proofpoint-ORIG-GUID: U0vsZMs27rPNsDqr-AC4BmRECCuQVWIV
X-Proofpoint-GUID: U0vsZMs27rPNsDqr-AC4BmRECCuQVWIV
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db51 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=pCOl5fTshOrEa-n2-VQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX5g0OWEWbvpwd
 zGJeZkbg8vaK/jSsh8yW4Osj1u3pqVVAZ+w/pdLtMCDG837DiKglj0nYJ6QWngy+1IBCOkGKEgl
 Rux7EJSGgCHB0kfYj7OhAaeRHIPiIcxvk1AiffgAt4qP2Yn8iLvYIuCf0LWbLno1u6blcxOLXi5
 IYACkZwnKlBxCNOgDYeGBIph78aKvLn4rM6XBhFEoBVqjq+EDT8mI9kL1LIqkAPjiLtbmsyJSdd
 vhWkIZdHQxNMRwJEW5CzvwO5zKKAT66mmfmgSIzx/cuW7MwIzpDYLwHcO1CmJhOVocexrj0qLY/
 NU8q+st6YIe3gpY93tSvNIziq3yxbwf/4GDpygN619RjGN0qgQEbUyYvv4U6/l8PLOLdApJthH+
 bOCJvXrXuGUO3AXvNeS7ZUZdZqin50oF6RxwL+QlJfZlt3VOMYYI0BtihqmyPQfWA1Z/8O52LuP
 MH6qTxKkHBd9rB4PCow==

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and implicit ALUA supported and unique ID
  available in VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 148 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 229 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c3042393af234..d6c31df454825 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb2269..04f9c2e51fcbd 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..70aa1dbeacebf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..5559e2e8d64a8
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+#define TPGS_MODE_IMPLICIT		0x1
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int mode;
+
+	if (!val)
+		return -EINVAL;
+	mode = __sysfs_match_string(scsi_multipath_modes,
+		ARRAY_SIZE(scsi_multipath_modes), val);
+
+	if (mode < 0)
+		return mode;
+	scsi_multipath = mode;
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+	else if (ret == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!(scsi_device_tpgs(sdev) & TPGS_MODE_IMPLICIT) &&
+	    (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0)
+		goto out_uninit;
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return 0;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a2..3f1ac302719c2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1130,6 +1131,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..2f80d703ce640 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -455,6 +456,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea0..40a435e66b34e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

