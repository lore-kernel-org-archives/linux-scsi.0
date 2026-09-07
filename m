Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3447A884;
	Mon,  7 Sep 2026 10:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778317; cv=fail; b=KxwguxgkRzy6FlriaTeq3PyXpFrCkkN4xYM38ZKrjxtpxtfawze0rfv/yGMe921QI4uTKJ5NAbZWUDPGWKkSGk66G6yoC/I2Ks8TXsgdXA/ucl/ZvzeQea0SlSvM6e83mPoWrkNDjdBnJQRo0/JMewlZ/27BSXFjMOJccIbEPdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778317; c=relaxed/simple;
	bh=B5XC+D/K7eecREwi47Ova7lBvJ7BYgJLxt2VaUTRJ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G3e49cC7ROJ2OF8kiDWc0sKuXtG9eVOd296BkJPw80Tyf8SOyKmsHQgKA1062/cj+HeyRfcifpwlYnzZh9eXgWl7aC4kYdgQXhwqh7TMheSdvY/DUq3gltsNNcCx7/eARjJJtYo6SMiAy7NE6J9vmk/HGp/DQBBcVtXpsGt54Xk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T+3+P3On; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TCWKdjKW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T+3+P3On";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TCWKdjKW"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686NSBAX1534288;
	Mon, 7 Sep 2026 10:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yowEivTEH11FKs/qtsaOoa6ih5PbxcKY+XnaQ7XBdSM=; b=
	T+3+P3OnQOTwCMWJswX8X1sAJytsCQ5jFPV9IR0FtTCyuGjDfgX5NBdIg+QtDsIZ
	BqfQQZkJhNEJkn094BfSHBMGdQpgadjLxzFgekAFfjSU8hzYQWKTYQfPFLxwrYVj
	891ovPwNHM5pgFnLzWeEovzLU6pYl+R9EK7D4PU1VqPMjuOOQg1ulzqRkjt7zXUn
	Bv1Q0tA/oE+56F3h2DvBKRxKOa001LXMiTEn78G6vQJ8qqKTyb5IL9lZt6Dp5/t2
	QdLaiB1iri4miz9C+phJYlo8pq9p/RdDSVHKNr3LlINKZD+XLZIxNxcAVjKmOz7T
	i+yQS42ecqa1kXFgR7hfAA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdmhttp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfH019106;
	Mon, 7 Sep 2026 10:51:19 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y6ZQSDs/+lGc7uIZnADd4lMa+7kd+a7WNsQDgT40kETGDdrXDBqR9iMh0/WXsJaV7gQPwiBgapx+JKmkrQTLA8u19U6YuxlVmlcDmMGRBX4GJ29GB53nXooIdiHSfzUNlrlU9rhcc2qrm42KmUe+KgZCYidm4F/AThJuEp2WLi47l+EwpRTzA9NdzYx06sswSao+6WTE24ef34Kt7zTESBksTKvDZie8Ke2Jc7VXZD5fqddMbCXg3NPO21Qt9CsDYj3MPoRupzBIqkAy+46NeygWHeEQKcE/tRLqd0/WjtcI6rNM9iCJx+xITEEVnuH89jSu+l1MMcauN4bufs1lvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yowEivTEH11FKs/qtsaOoa6ih5PbxcKY+XnaQ7XBdSM=;
 b=d4lxaKK0whKu3m2RTEwF3WPXpT9vVRMVOsc9wcoMkv6cTZ0e+0I1ShNWqpbIITpnEO1v8YW0HzpB4BC09ADYDJcvjF/sT2S+emg7llvam5DCanx0o1KbMX7YjrMG2TKwRRMjzCagcTyVTbqzW2Q+iufnqYTmPVa1OAdFllhTrxYtaboHHS3qt0CPAa3rWedvfaChwcSuK+mTetmTxfFSsx3MmbF5HDNBHYZan9xdRXMXqCyvGU0mg04C327hUh4lSIvie5zMAA+bM3KYZbFll20vlRUjNcL1b665GQP1vwp6Bq+AgtI8yuXK3rCd/DsVNP0w1qviGeCoRh3V2gZf9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yowEivTEH11FKs/qtsaOoa6ih5PbxcKY+XnaQ7XBdSM=;
 b=TCWKdjKW2G7m8NVZK7Q57joc5LNa9wk1LSSX1AcHJ8PRTZI+xXL/dlWYK55/BNXdW7bLr84/Wdg2mcoz63OaS02Zr8T7tGa0pPuH5BjA45sDiU7RdPL7OT/AuBxUklIFNjoIf8D3f6iu36gCABcYe43j4AoL8Ew9wSvtaBuyR1s=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:05 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 15/27] scsi-multipath: clone each bio
Date: Mon,  7 Sep 2026 10:50:09 +0000
Message-ID: <20260907105021.1763236-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P222CA0026.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:33a::29) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a3beff2-5bd9-4ef7-8498-08df0ccdea82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VxHDGiFRzPX02tNP040WV9Wl8DGJitRxmhIfzVOPugkSfcGmy8iKkYqq1x6jaiR3wiFM6Mv8wOsVu/4sXfnRVoQw/K5vEJ7z9rfGHhrPLXlWb5NSinevNyXzR7PCk+FRDxwFpz9vij76W97zyYQZZiBoZQoTa7+c1icCPK6yRQ1eFzlgk4F9lcEk8+qYJtkaI6Of/vTdhav95KL00ii3/meLOWzNf6YR3pvJotvg16ul/St6yakTnAi4tfNOZmv2EWlRs2rfk7MHBviWoFn4hnIoWtpEPyll1Vk1CBB06qPfZ1e6HtE4aBkl+17/ILtQDWy1a9aNQpxOile/jRZeaoN6K/QmyZTyr9DjvqyIUYZlTLho99LMMWbAzLBKbbtZy9a1Cy2BgODzyKoTPRFmoBnq1mlFpg+2zd47TpQWC5gQTfk23wvwFQ3Lsk+WCWQgt/dErhrZRxgYLwZVITfK39o0YYPtWMNe32cK/F5WO88GQOCPo2Tc/gNrKZEvroLEPtu2H1W9rsyMo4JUjN1eUzzcWNVPoR9/vMdZMRWyf46Vlkk8FD4+gydRSfthl1GhLNVpA3GXlvBxrSQqFHnvgx0/XvbNtYS4dlZYC5zUxhj0Vbj7g+/0jvB5bcKUAtlan/3S5HLE2Mw6yk8lYj6w2gGVWWOlVaXCxDKKWR2HDRA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pwYaGpB2M395RF8MrhEn/4ikXTE6fZHCIwhomnvyILfPVXhllQz9dJnt4+EX?=
 =?us-ascii?Q?WM6KegeIWOZRY1epBiouF4VL/awPVRpbfOS+3Fg9LsvjbDhvCp0SHU477YpP?=
 =?us-ascii?Q?zqcjzaiTE9/I2lsr6ivAG40pl2ShCQJwcVYFA95LXMXu43U4ODV39+rfmKuO?=
 =?us-ascii?Q?+nkdf516lAFSiJZzUNOhFGFBwAHQj92RIlR1JSvrCXDOPmuS5etKwDFCTg+O?=
 =?us-ascii?Q?tYnw9MX3R9A91gQIeZ59wiAnfKKi4hT1CQZWO3puffcdKjMHcEUaseEuYsg+?=
 =?us-ascii?Q?SJOh0v7cR7LHpIVZuudPvpbpOsmlLPrRRQ4kwZZCmNLxw2HKHgDXW0Kwtbmg?=
 =?us-ascii?Q?im22+jLNlMDtVuom69PeoKEoDGmfAMaZZxMqpFxqdXTl0lv1MwkQXGv9QD8N?=
 =?us-ascii?Q?zHhX5eMNSa4VShaLruqpWS0hSfW4bt5UDvIAld8bTw1+7iXQAEP9E8pbUs8Q?=
 =?us-ascii?Q?rKq/BFn+7pzhiTcRFr78criCmQSaqFOCQ6cdxbZ2OYjMO9QERuCgeOGRbYjE?=
 =?us-ascii?Q?/Ly4jEEoLbwTELyCVbw+1um9qnvtoF9GeA67sR+2WJ20b8EaYtGnVLZx20ZX?=
 =?us-ascii?Q?TF20VX6Q3lXu/imqRrpgV+9ccgBmha5/Dmq/I00Pn99VIbf9mpguBaeta8Sz?=
 =?us-ascii?Q?K8tdEezkUY4lBXx0J5758bLy+2gbiC4kqAoRmmSkSWLX95Weup81l14QBNSV?=
 =?us-ascii?Q?nXm0+GdkUgkK2lN8cIOZAM5XJhZbkgR1LEAqJcO6xalbpyaGuWRwDFT97x4L?=
 =?us-ascii?Q?EhaVCvDE9Vc18ZtODkG+CfxWB5wJkJRiegbKrkvEd/Iq989lQbLVat2VRy1u?=
 =?us-ascii?Q?WBcmRcd8PhpwpXxDzudUKmblHzUhFt2H4r1i0lfWlA5s7u1Je/VzSGO3d3m4?=
 =?us-ascii?Q?TPVd0qlweyn0joxFJb9eOLtn+EPU7/IpvAf9bI0UlXrLkEMYMGB7UzRKcii1?=
 =?us-ascii?Q?vyyL5220vQzuQxclaKfGkzXpoq5GRqiZ9NxuZ8+vx91uXux0FbY6Vq5u41Ne?=
 =?us-ascii?Q?FGUAMGexcLMp90WjRY53uml8GNAbDRXdSrJRFiicfSVwkpHf52XrwtMIO4AR?=
 =?us-ascii?Q?5YKutSiF+2fcQ7jTfNfn/jCRCh47/O3KCxRWltBqRJ5J9K+sJXlizTzCglSD?=
 =?us-ascii?Q?M+b3FRDYKrMF9tn4+mfI9kF+aJZt/hZKjK4rG5QNz7gOn7CM1kmZ945wnM+J?=
 =?us-ascii?Q?hjeVhZ35Xsln+rr8LLrqaXFwxlQ2mwpkLWbfu5po0+gH6j8OBl/oeu0N/Hxe?=
 =?us-ascii?Q?jF0zmCSdd2X5HnY8f4nRr9vGwEz5AHyejsETJnao2chZDc6zLbWZx5CwTPxJ?=
 =?us-ascii?Q?2fJ3Nlif2L3rrURY0ECyI1SnMYMGXTnPJDfu0knMtJ8LnXsg+He9yk8Ov7xI?=
 =?us-ascii?Q?G7VyW8uVvwu1R+ObbmFvW6X+eIqmUTCULP7YFHSva9A/B7VI6OEQn/F2zmi6?=
 =?us-ascii?Q?AdPSjQelUJrSadGsBYw5lNksr3IYT8c6UZ3++ElakO9tuIIuOH7XlgGk4vtB?=
 =?us-ascii?Q?smZYc8oCIbfnmvUWDt1Ty7H+7nUCb+I9bxe0Jv6Wi1I27WDinz6H5txyvZot?=
 =?us-ascii?Q?QuhMQ7TcB5DkQ8chIjxwFiCJNq4F+UKw5yeLNFAnuQczax/LGLmEMEgXIC1h?=
 =?us-ascii?Q?YDtVyz1iIYcgiRMIkCkJeQ4zyT26v2QWghX9V58NNStgN5m+y42n6A9uKQWp?=
 =?us-ascii?Q?BpmDU76SzNJ0vCGNJ39EaAihLnci8UoRVLnaJd4ZXVrQu6sjJTYLij529ujn?=
 =?us-ascii?Q?v65Mf42ucg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	bSo0A3n5eTzUyncNamP/zVP4AQ+T5yQO4lN4yusHtj5BkP6fyfuslz9SmT4d27H+QK0f8xZX7/+HPcijN6Xf85kTVobzumZ+aEcnZcOJ7Mrq6J886plqW1Qz3x1N1UG5TzERtuxs7BDkHL+j5oukoKaGMDNCT9YOZZo1BqHvC1fV2bG2/u+NCgdZ06cGG6HYeH7YZp0aR9bcIayh/EIelK+nVoZz14BLEdhFEh16KViW9dKtMSG/jSrtvzhWt3RjjipNtsnwPGUB7+gwEKYTusVKKC2PZjS+8699iy5K8BzoliY7yt00mp4iDRUE+zrxZY+jKGt1Uuq3UlKY0EuBLw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u5poJM1XOoGJFYPCCfPYvyT3YNdkBbwVA2+5S4dZk8LJac8tNQKj86zac8siNVjAehSDg4Cflxc6yTqpHt+Dk6GzSEQaY5op00KvvdoigDtRq5QZuqah0YfTiq+sj1GiBRwMXFsMWmbZC0gKcd9F84tIfd2UPOleuR4o3EglbR2ib4XiTHRbAywIUJ9Ikb0EMhVO0aLF/+l7YUq2Yj3lGZj83gzPiYG76apXCCa8zmqA05VVImAL1Dx1zWwpd8hT2YAE1oeBAjHcFzh7Onb4EQpgdm5RQmTIqJqDG5/qO/rgaLgVreIyMznmyzoaqC7TLFYfIe5YPDGksPeoR0hVFYkJoaGl4YA83aorI1xQVbUrSbFxrQJ7eZT8VqCUaL2w4ebKnul8V1QK9lyQD9Wcwk8X7NB223Ce7V1I8HrBU2H0OtjkuwjIvUB+raDFO52Lr3GKX+0+BGODFWDy/VyaMJk8AILMKoi0nQdt88uvlHTFe3a/WReqCZ535LdK2wRc+9a/Quv0/mcAGqxXVHSDlvDlXIojz4opGGnr9ES1TPI/t+TSAfkU7fzyQO8JcKc/CiP0R+kPELumS9MSuyXKJBofvCGRLExtov+0/jGYTBs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a3beff2-5bd9-4ef7-8498-08df0ccdea82
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:05.3884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQOvDc9hdU+z4Z+pP6nL1cGmXPb7cRLqFK7aSWdSDG9D3AegecXX7CdwxdVp1jpm+uGWsM+JQO3cIXN80/4BJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX1vQazTxgzXj/
 zLDigRsPFMBFf0g5BBGl4+uHGtXKsqy7KvElCwefiuebZaw1neq26RwWQAh4e3wXhU8ejx6n66B
 lH9emlUP3VrnMr1+cUx1QKNiPauIh9i33sClQPOC78MYeq+BK7UM/KcFI9W/GxNShtGzFmhohx8
 6OGpxp4BBr8PrL87LdCP56yjgvw12T0xUvcFyofCeMc26bVgCM69UEps5aCyFoRPrDDIbvhI6qP
 C+Bkv9OBmBCDIzy9uw8bULKYfwrsycikKHqKuOdZMDnVELz6bDpZMHGiU/jhHxyd7VsKVs8LYcZ
 Ia7Co0OWG+FqfE2dNrEta7H3j0YSvubO7mbTlGYgaaQpT0yJcJ9dZa+ywqxRv5GApwE87FU3nUS
 aJgZNuDZishaCtBeKyCGMFWNyQJNs987+dWQZSNck6vCXu+Bh2T0jSEeFMDucqoZJrlte2029+i
 hLQ9w/dR2Jd4dirE0pQ==
X-Proofpoint-ORIG-GUID: 34DN7MsLSelLvoCQZHg9yq8aG2WocwZs
X-Authority-Analysis: v=2.4 cv=d/DFDxjE c=1 sm=1 tr=0 ts=6a9e9728 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=PbwEKb89bYuBhGpDIggA:9
X-Proofpoint-GUID: 34DN7MsLSelLvoCQZHg9yq8aG2WocwZs
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXwZ2sySRO8AfD
 Z8rFBQhdoWG1wS76Oy5fL7upBMhfe3QSmrCDPPje7c+hGaJ6ocRweFguqBH2T4pcJRJBffsn+Kq
 VxOTIyLG6O2G9Jx1yih/zr6NQn4HR/T7KjB9D22P3sTZvbdClf81

From: John Garry <john.garry@linux.dev>

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 7164bc61e65e1..68fe50f62158c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -99,6 +99,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	ida_destroy(&scsi_mpath_head->ida);
 	mpath_head_uninit(mpath_head);
@@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
@@ -263,6 +291,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
 		goto out_uninit_head;
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_ida_free;
 	kref_init(&scsi_mpath_head->ref);
 
 	device_initialize(&scsi_mpath_head->dev);
@@ -282,6 +313,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 
 	return scsi_mpath_head;
 
+out_ida_free:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_uninit_head:
 	mpath_head_uninit(&scsi_mpath_head->mpath_head);
 out_free:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d6f290b84f7f5..d2ef94ebd29af 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.7

