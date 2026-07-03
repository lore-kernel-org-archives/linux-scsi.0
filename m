Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE9F3D9DCA;
	Fri,  3 Jul 2026 10:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074762; cv=fail; b=b9Z7G5yRyNAGWMUeppLty9KriG0fN22wt0GN1wfVays9ce3taPV7A6HO+BPcVNGcm3LHv8pLMvgz54xKCsbzd/mvUzViF3RaMmNZHM44gwm6tc78Z56bZ+4psYsVPDVpQgrlN1aHQrnpgittcoSW2gVgp5LvAa+ut5qkNEV8Gkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074762; c=relaxed/simple;
	bh=CvvoinPz61uctGCYawTPaddnlFaOiDWfuJgdj+Ykw9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OIabQ0cSPj5nHPNEkblsCEpNxt3EAaLdM8nXNN9CKhEKmHQN7b8Fm5woVWgGkhL9yup0gWzibH49dSuYmGJe6gfS2lTiYQPs5aD4rMRj7WwES16kQ9zUgdq1fvpT68IAObom2Npe3HKP4a+0mUhxqZRuvd75Y84I8mCB8VSLfsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bnwjB3N8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vd9RHaLX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bnwjB3N8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vd9RHaLX"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfWb3112698;
	Fri, 3 Jul 2026 10:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J7fXXH/etDNTR8mY+RN7xGiu42UbpwE03YpgbEkKklQ=; b=
	bnwjB3N8Q/58vGrQx6ixp6mKgJXDC60GE2AkG8ZA9RY2mhrcQa3IyV6m+a9B95si
	DqWMmU41DORcb39Vw1+UvRepNITIsKfDrEjdjpaj6LSjOx3L56QlNWgykc5p2E9c
	ZGDvvDNtVuC1df64yFY99juspljgk70XZ4m0b/mz9htYEizUq5a/KU8li06PhcpY
	gVBNoiDwEF2ndIMNNw5pfbsJ0zAeWzpIE/vxTlDlgiBzpJDi/CNQkLqGUtia0xYm
	boQ8jS+1/NSmPKeZbVZWrhokBybYrJorauY0vqpac/pZS2wD/FbSPsD1nl+QhIBC
	sVhs5oBLzhTAswMoTwu1IQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfjemn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7gB013121;
	Fri, 3 Jul 2026 10:32:21 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvrrk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w1jFGpCKe1ujoPhaS0IgzVsSVDkg9oDP8n10qrnuuxfHw+QpmzANyIjin4seZVO37fUFJlzTrCpsDju0LKszt30c4pVzqJWRJUXLJ+0eeZExsCf8nh6jWHfnQ7YwT70PbF+tDciBMVwYhMQjOrzee6HtnTqxPO8icvn99b8eVUfd/Ddgy77txtPxegFpmy+wuj3IUagp+0BIrRrK1fV9dcA/FfFEh0d11Pl5OZecGaizH0l/HWk7EFGUG4Bq+lhrmAUlV7vTIVEXL1hGWnyDCY1x9LjJjdkmwxNjs+l2+mArL6EOGrIkQPeWoyQSkZB3MaIxbHy2a0rSJTnHdf/k1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7fXXH/etDNTR8mY+RN7xGiu42UbpwE03YpgbEkKklQ=;
 b=DLch9aSeU/6Qq5DlgD+978rm5OAr5rsFCnJKzsepPrhaLGLmT4EIWhrT1h3t6mR6Pqen1dZKoPKPIgoleGPIgviwwSrWBzeSBjvhzJOe3iHW8zl8bt4DY61gh9W+2cyx3XJd4tVWiL2EGhLHt8nWVeiGcVCdtfOsGWzXOL0R5ITn+BjGDto9A1UPIqRPRgNU6xmMOtGQK8tW7eW+gfiC1f3FXXXVwbps+18R1aOD5K72NVvzWIATY1mzk13yKr0g7Wifvm76MJMEOrg25OjPGPeiczKt8NBBB7SwXt8SXCEudnYRrBkMpIVgloDcbzrCRRMDul4tfnZbOMANwmzvyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7fXXH/etDNTR8mY+RN7xGiu42UbpwE03YpgbEkKklQ=;
 b=vd9RHaLXLGspQAuEdAkh4PFANtTaEhI5/s3FV688iGkoS/qaGNV0phA2HJhDTCIqLiw8wdud/SCs7omaXUv25+Pk1IDjnj38QhDpXm4zbUd2Z9nbx2Yo9FApy0jI6hUpKrVKobt1i4UeBrryIpn6xDbzLoNpxrP9EfvaEKbxSf0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 02/10] nvme-multipath: add nvme_mpath_available_path()
Date: Fri,  3 Jul 2026 10:31:56 +0000
Message-ID: <20260703103204.3724406-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: d5322fbd-3d24-423b-65f7-08ded8ee5a2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	s2UXB4H+SrdUo0Iw647FIfJJ9Sm0NF3p6iJ83yrcmpaqqWOc3O/ew3/8VxT0gjzQe5uTOb9EYizW0vzCpa1/98dOrWuH94BwN4fnqHJ+c1r9rupOgKlfHXF18lbM8kzKefLw20wouw5PL5HRtvCUvWZVREM+l0LaRqocYh3rzh2lQzZwcR4umRLcKUi8ZsI+jJ7xHnN14Gz/O7Lohi7k7Yz28B0RNcHccfJepNboqQs7VvY433+57V60GLQjx7wdZfLzIkaC9bvgGg4P5vTiU5V6HpmecI12RjGZ1PS8FIwwyw5R6oYicKguZMdiAdQ2a5Nex9Jq1jESCvuFm3PPS5olxDLtgOtyvpw5c1KKpQeqMFuzOHKAzdmoHvd3YplLGE8rFYWPZ0R6dd5ivgCO6+q4Q+6q5REWMXk8kWf+c18hMSWqtRrteVl9vuGwGNeuo5/napjeWEmQsvY9qCmThBTaPluyK/8clbIJ7nGV6f843dpDGwyP+ZYss4rXLXcCosoQayZaN4Xlec/0dK4sXQdeqdO5QorYrPSVLWGwUc1Am4VNihUYFdF7/oYmNmtr+tonRkJ50kT17nIo8mKDpg46d5+gGrVvRSPuUJRuWOnQ0UmplklXnA1HHDwmSAM5vrfvysw7WuIvOSu0GgCPns9cNCRAX8TP3yDkSECBYTk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7gVF1Nth+cXUqh+XpLGTbzoJaZUurNyKciqwTHp8gSjaMCosrwdHbjM7reeW?=
 =?us-ascii?Q?Ngrn1lSa8WCZlwm5ZiZeo6CqExLhxWMgS7Y0d16gHGkhVKTYmAYzg9q5Jdfp?=
 =?us-ascii?Q?3t1rykjg2kuOst5rqj3NGJ+BeIy1qkp8jAf5HywSU5ekb9EetkMA7h23aIet?=
 =?us-ascii?Q?JvDVnpaFjNpsmAIP+fUgHl856SqJlRvjf771RozKia0wUhYpMPitnJB5el58?=
 =?us-ascii?Q?70w9EGCJ4MYL4ZjEq1mqbab9wV03EDuL8+J97RMFQmChhg/aqOSTKnL3vhdQ?=
 =?us-ascii?Q?cQo9gL7N0fy6taVShoCrAUQL8grUVC8byFEf7mqldywiUD5KnxuvcgBVhbCK?=
 =?us-ascii?Q?VcubrpSobeJEwfqPffjnoOy25YV3SSSp5JadCqxwMl1wd9fIg/A9zUG0bmd+?=
 =?us-ascii?Q?RO+8UHr6hdPDOsMpiUK1QGR7N3XVeLft2ok1Ex/hZow98YZuOOEyp+t3sSVe?=
 =?us-ascii?Q?Z4zH+D4hFQVsE3j/uwlUGvCeovM6qszgUIhSDxqrJPugl87eLZFefxts7bVV?=
 =?us-ascii?Q?Vpjs5PiLRD+ZF8+wWI37CoTI0RwXQlpSDuohIIGr8nV5Trhb55PaflaxJFq6?=
 =?us-ascii?Q?CcClpYTq6hvw7CN+2Pf6Ll9s6v7UhG9l83m1RlU4os9kqvTxRaf1igwchpdo?=
 =?us-ascii?Q?j8c0Z70OIvG8MhtRRnjxaLx+OgzHuCst27F6xoYspnXS+qw2EBPU1sFMCbV/?=
 =?us-ascii?Q?Nsq9OdF5PRZVTuBqhbCwV6M98OrLnVPayOKXuXI1+G5euIwou/7DVfDEjAOl?=
 =?us-ascii?Q?EEODgcvtjE0IEey3q00RPAWNdAmRPnBMe9XvMX+8ap1E9pHB8fp5fkCiWsmI?=
 =?us-ascii?Q?zrJY7e4CyjprTcpPuGNkc6bfM7HIWsSrYxhr9RL/vFTG+puzCkGMcxTjgHQr?=
 =?us-ascii?Q?mu7KrNe+98B8OCI4pWMSIsxs+FbKab/DlyP9iAjSuaY/KqwQXnzoF+sUNauh?=
 =?us-ascii?Q?mX7ah1UbQPkhcggdM1zEg0Iclko/mq2xF6xzhmzYbeUDKnnez+F/WvlVWYoa?=
 =?us-ascii?Q?klUpGd7YcJk+QJy3iU4DRSOHtJvUzMqEhKSDovOiEpHHTDeEmWwhvJHC6T0v?=
 =?us-ascii?Q?eyQxV1cVyY+WzMxj5Sy1p+jCTGDqfuALckn8uJJOkWOyHTI9E24YUZ/19dBY?=
 =?us-ascii?Q?bk5H+jl3Ws8fCXkUzl68/Zy3bVc18p3/jECwYhJiwYMYx7KXKvD41zVcwHn3?=
 =?us-ascii?Q?CXW7nisGRUz5kHWqbGSYAx/BW9La1fzoRYFcn2ifPEwlzDE41e1qLcCFpGij?=
 =?us-ascii?Q?Xbw1MGPFbcnWvx/9+9WG4peTch5XETo5uCFYDc5mg7oaSlCq81rL07NhhdcX?=
 =?us-ascii?Q?txUmxBxJRNkFhscky/2HLaiZGFtVJW3rkDqe4esIPkAqlgHORnHQeAyc+0lB?=
 =?us-ascii?Q?9Ss+ivoftj5Sxeb1ay8rvF4zwMaJR3bShjhynJbdEfedIG6EYJdkykZU6fSW?=
 =?us-ascii?Q?wCFfaPfkGL2sHOFBve8H6cahoKwUzCYL7JbDnOQ9tIVIVO/rVbgQa9CuUQUY?=
 =?us-ascii?Q?cZT2g5lMBddj9PxfP8wGS6F6iLPLWIAbuyTvebQtGKAW7fSnQa9RZJgoH7dH?=
 =?us-ascii?Q?qnL/LW8I0xrm3PbKBqegsl3bAIUBvsO7h+q7bT7M2EEXKsNd7znuFRgkDKb7?=
 =?us-ascii?Q?H56OiYs/Cv7MenPG1R/8Ol192G5PqtTsALuFFx3L3Gh1A0wVIB2zWDwFRbVq?=
 =?us-ascii?Q?3wkJyePfOpEAvq69pBfWmIoda6Si9FrrPIynj2ZssLsBQtFO+O3Xpbr/3Ple?=
 =?us-ascii?Q?I/H5Ivh9P8zjU9SE/T0s9U0iaJNxb3I=3D?=
X-Exchange-RoutingPolicyChecked:
	FAheK5+LACxVqwY09vqVx/aS3QMV/vJb5x69H9vpv2eBrZz+9PujbWA7H17zd+nZVFxMErwjVFknVZszNdeHT77QTVt/Shn6tZngbTxcp0mBL3F/7lX1BbJrm9Us5ZdN+ljhT/yYvlyy2fwSXOQ/Pc50EJCRqOaiaTD+eST0p3hty4eO5QVexnBLsRfXF1xl4ezdEy4+CiLQ3UBGKYNbYDjRNaf4bP09itPMR6MFUU/gfOGV6zs9Mq6vcIoF0OWypoSh8LNntvOkdq+oczKb9J0gPovdd0l4/C7RpHpHHeAupWAEkIGzKqhzDfqdbZUzFLSWMqHs3U8YHeVXt9rXsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j8iqNgJFmtOKKo5uZHe8YQP2Vl+s+xocrm3cBdgw+41RF363bSrH99cXOTw0dmmdSqVac6r6meaBbcGzQiAPd2Su0PUTvmnpi8sAM9Zr7QlZHRfIRrQZaEdWeaoTJUzfDdmz1Sc3v0McUKbY5WEoB71p3dGdvNQuZsCe7iUN1YFkNwC5pXrPaZRtx8iF9Myxl6Y+3ymeVWt7nII1L24Jyqxw66p8Jw9LeiDHWDLBXOAsP3Ss03LeP3szxE9Ni1MyPECHoW6Q1j2UI/M3kdVb18WIRY3s+6+M+nKwT0Su6uj2dw+6xyBPqI3YgOXvsOUWFH4o3cUYyVehKDcDcOEehRxVuggeBKe0lDYnF/foprCWv/gcIT83g95cak4qJCnhvPoWHHt2bM1tk3zsTjAFD8OKigq5Zsl+UDx1CTvKH/QWerYpQJf+/TBlV8K1TcC2GGWhlCmeF/bQQvDl8f1LMZxC2vkvZ3PzvVKupvEPVI8xgdYebJrpyAA2zWIT0o+Bd40PtcBpSVbNlkMeIp8kPexaMRrs2heFcSLElzLN8JBFTMaxadZkO3NeEnTrRICIFFrH5Y/S+Ih2v3k/Flg7ZCczV7V4iqfqUPX15rilE8Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5322fbd-3d24-423b-65f7-08ded8ee5a2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:16.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERkjq4Vi4mvnY3MPBwA6vvHEE25H7QInrVOX/k+BfKNe4jebnKXdGwX65C98ZaGHuTnzgmQxl+LGha4jISyw6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4r4tbSGcdyW0
 MWtiXga5qvlYe0ZKc3SWR9/essH7H9w2zBDRIF1Q8bJ1BRChcURICip3bxqNCmUrYc9VrneOX78
 UDfLNL6U905AhFbWWt4OyXi33jXEyDZMr6a4k7aBGHjYHBNcpIhJ
X-Proofpoint-ORIG-GUID: GUs1JdzbOBfn3iCA6j70j2X0JiExVdeK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX7OivpRnPKmdY
 OLhxrNLrewi6291+5yPC3or11CE7ecBVMrU+fy32Y2mXQDwFpZtxz5moW9Y9QPgpx8EfPdifL4Z
 PC/MIDrTWdGCModjab4EssMX2/M/BK5/bfiKwrBZGzuqtE383dE5ptgd+ZzF2HNlAgvbxWSrwme
 YAC7Q4KBoFievKF9pAqss2+J1SrmKf2MGSTM0OVudndOsA/516+qPCTY8uiJvE0LubXTDtU31CQ
 RLgoVW/mlqv/OT4gnqe1LlvlWxdpqtmrE09HPRM3noH+aOA40tMgA9K/u+R/o4qo5ImWhxRzpN/
 BZXO2bBxt68hQuabPsADFxA4rTDQ23AkA6lvOi9szDSgTvHzZESrBgsF5MF2KQmlOWHB5+ZjfDT
 IC4Xfp+WEB7u77aO+xGB4r2UIM1bLJ9amV2vQq1EMrA3yiXfFkkHYI7Osih75f68gvX7otEjMhi
 MIWNMIuk95AjwsJYULw==
X-Proofpoint-GUID: GUs1JdzbOBfn3iCA6j70j2X0JiExVdeK
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a478fb6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=WJg9rLiHYWik38eusUgA:9
 a=WmVTiCyuxqgg3mnwYu6p:22

This is for mpath_head_template.available_path callback.

Currently the same functionality is in nvme_available_path().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 14947736744a5..14c4370f7303f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -505,6 +505,25 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 	return nvme_mpath_queue_if_no_path(head);
 }
 
+static bool nvme_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
+		return false;
+
+	switch (nvme_ctrl_state(ns->ctrl)) {
+	case NVME_CTRL_LIVE:
+	case NVME_CTRL_RESETTING:
+	case NVME_CTRL_CONNECTING:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static void nvme_ns_head_submit_bio(struct bio *bio)
 {
 	struct nvme_ns_head *head = bio->bi_bdev->bd_disk->private_data;
@@ -1499,4 +1518,5 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 
 __maybe_unused
 static const struct mpath_head_template mpdt = {
+	.available_path = nvme_mpath_available_path,
 };
-- 
2.43.7

