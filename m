Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB251A3BC0;
	Thu, 24 Apr 2025 03:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745465272; cv=fail; b=hKTx/4NtAYbdZK4KBW579AhEMPKxDQw+cIfAWXPEV+AszbMnXUBCzMt+ZAPjaKUf1ZQgId33HZGtxc+S5JhRNOAljpmdiu2CvdDKxmNfhve1MJCqKcwLGRyl/pqLN1Bbw4Wz6K5g8PhSVO8BYOiPs7H9vsCccX9kf+LmFGBP0cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745465272; c=relaxed/simple;
	bh=1TOmqCrSEPMqzEBZ0Zlo3ezHbzyWYWUqdBI33N8Bdl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r8K1KEG+g/djfFY3cbF/UHVpOym0/UwlmgxVLAR9T7e8mbB6NX/Kh1G2oQ1l4P6f5uEZgtUZUVKrn0uTIE3JuPdQSc3qCjvMtYoGN/AVorkFRAsTSesiBFI8oj8pXy+f6iJ0AeE/5gX6tNy6vpqppfpwBMMeRtgLRwvAPNSYr3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ky72WWZb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RD4AMdz8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ky72WWZb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RD4AMdz8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NLNQYN019703;
	Thu, 24 Apr 2025 03:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5b4tdMAVquoN/qlhMEEcfh9ozlSCxbDh7WHRgQ9i8Nc=; b=
	ky72WWZbe8DnuoCizobpout9wzweUcsJ2ZBo8bs3ZUDTr+dyy3MisjE+Si7FLqiC
	Z4P5ep3cCDpmhVb7EBeEPm1SF4lfkNc6GDWIITjVgLu6VIGs62T0ok4pwzU8+qu4
	0QC3woV9/dFNVW3w9ndan9JF6GCsy1VdSKrLlmFQmKXtKHoaBPyul0YooHmThVnK
	Vzzr5m8GkYG2x0yOPKdQ0nSRGmZ+K3Lfzra+f/rBfcjhlYmWxsXZXvfrM19Br6lj
	cCiXKDzjmob56fRBzINRvR965z5oT3HT/8hzsYv2wBodvlHoh703+BXBwfarqCAQ
	0oO/fjhLBerexUPpYNLpmA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 466jhe2upq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Apr 2025 03:27:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53O0K1Ef039365;
	Thu, 24 Apr 2025 03:27:47 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012010.outbound.protection.outlook.com [40.93.14.10])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 466jkggcjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Apr 2025 03:27:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVzFEuVRC5OsxBlgJX4IxePt2uOxIrHHBWu83sS6YhIfYtYVX48Yfr8qBHHCo7jHYPmnnRbtC20u4rFRopOMrE9ZY5gsIpjGJdcSFd1RxhyyZXWECz/pH2vHIFJ+ZFHYS3LwR+5Wtv34qPRZfBZcbynad4xB2diz6+Drc8SMH5sZ586vaNgabHPaxYPSOIFsvkYUZ3pHv7MbFTWUNbBU/jo/ZzrabLPcQx5VbmHLHuEaj2NzRKxFjAyk1PhBnPlToCXHEdEttUPx9jFYC9KLrVlYSXdrAB9AqHmC2d9AfYyQkgPFn69kWklwb/XLLsShPL0FtSaD92ynzopEWT5eAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5b4tdMAVquoN/qlhMEEcfh9ozlSCxbDh7WHRgQ9i8Nc=;
 b=y0jhUuel4nZAHOHpS+1j7Rr//5MJHu7Q7kYU5khqVnTwWJmhQXL+VIJmGggwi6HPWaMA9iq2Pd6GmPUCBMO4q9WKNexbyLwLRu9MYTG5XuDTZBqHTRteaYYIfijX4RxwUpcvf75ZEl6+iyc3Z9G8iWFobOSIX0UwnGuubsL4rJTVOjtbUDXdupUpLQhATicaxVTC2nCIOYBIUIAYDwBEh2Lg0+oJPFbOjKzwNNeKEPw462PrQZ76TmAQqUUNVGBVoSI3b6ikx+D554+3u0dJuiV+MBLeefXRSihhTxKi5C8jEHUHMGPLivgshbwxTD9vN0qnnC4yzvcvwK4OSoGVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5b4tdMAVquoN/qlhMEEcfh9ozlSCxbDh7WHRgQ9i8Nc=;
 b=RD4AMdz8aYLyL+FNCbSiEzjo0akfbYEMvzVQx1y5wPBnc7PP6xyNpCERQCOpOdUuETx9PpwH6hyd5dHpdBSqXMrtbsewEAnFOyBmAsqBnwZQt6cYnIEdft4JBm6aqtIAPeS2UHmKlI8wxCIpL9CPdKMGXURF1sYgXobe+xhuRmY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH4PR10MB8172.namprd10.prod.outlook.com (2603:10b6:610:239::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 03:27:45 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8655.033; Thu, 24 Apr 2025
 03:27:45 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/2] target: Move IO path stats to per cpu
Date: Wed, 23 Apr 2025 22:26:32 -0500
Message-ID: <20250424032741.16216-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424032741.16216-1-michael.christie@oracle.com>
References: <20250424032741.16216-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSZP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:5:280::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH4PR10MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cfbdab5-54dd-4ab2-2335-08dd82dffaa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a5IhbfUI+GJG2QLkdE5ynHzogd5+yQOE3P+ylAB1EmdnliN2UrDVUKpfWnIv?=
 =?us-ascii?Q?AXN6LviUJHADfqYJoYsgLp6yLQilxahzR+U44asub8XYNv0QQGJf5wtSJ9Mq?=
 =?us-ascii?Q?4YcIylQk/ZEGm2Uf4EPQ+L/PRcDWrlqrdYfBfF3Vj2yqKgmh7LCmwDQSuhsi?=
 =?us-ascii?Q?Gp5RVHgsTq/La1Pk7YV0RlJ5avLuv524RyZiU0omacmeLniViY4NwFwIOmbj?=
 =?us-ascii?Q?5dAt6A5P6KRjt0pM/Zo1Gp5cER0cAXEyHu0GE1C4HbBD0MajM8f2G8BLM+lc?=
 =?us-ascii?Q?uLZRQN1vQGLXf0DhMqJErfYNtOFq6kxZgN1bAL+8vTTXZEyKvTSeh25xrDYf?=
 =?us-ascii?Q?sY6+kkb8A8BcUQk3sqZrS8kJmz2HMrSMOzSi7G9MOeuok5X69L7mTkAS7N1w?=
 =?us-ascii?Q?/jhfDkMbcjEuqZn3XGSRupj/+pfkjY1jiMbWVeJhTGIIznVfHQhShcNbBjOY?=
 =?us-ascii?Q?3wAE3OBKOZGXLq+Yiqj32y6Of4CV+OSNTtlOtotgqKmH5VrNgmTrGJKBI2ko?=
 =?us-ascii?Q?8hno32/fs15BJY7reGB+qcsXCt7LB7geALyeWmC1RtREds7iw/MpoIOJkaPH?=
 =?us-ascii?Q?fOruNfDE+HzWNnlz+80u2OkSNV4Jx/oC0aTIVYUwMVKvUEWH4Q08pAxr+J5I?=
 =?us-ascii?Q?vxd1TkZLAc6+dufDYImd0jo5CENd1zYQaYk03pvGj8M9Q8yPO67gRR1Cbneo?=
 =?us-ascii?Q?7ZYIQofKG3rr0piWuxvli3cxArLYQiInOAv1WMq5x3Ekwg2GupVSa0o0iDoP?=
 =?us-ascii?Q?/lkBN2ZMG5nqDXxkV2HagKVyEqIUcZNCW9QDcyc+C+2x9ETrFnwmhsExvO4m?=
 =?us-ascii?Q?GsHZY5qQePOpObVXgg5R11AKstzuwVm+jrKNnvmNGgRmI+tzyiHsRT8vpfje?=
 =?us-ascii?Q?itZHbfyWgP7LFRc93I7FuTXQE67CzRUPEo0PFmHsGX5abAfM6RhQVvs2ZsGu?=
 =?us-ascii?Q?BK2bKpl2671o6rbMA5UE/YqRD5Xwk2DteXv/xbAwl12ed3iI311oLN/oARAP?=
 =?us-ascii?Q?8wGuajl/lzKjd2rEyX7KVrzBL/PwY8mF+XPPCBtOE4YsXR1BAqEd+RTXEMv/?=
 =?us-ascii?Q?InGhKJWEUaj9GM70b4UiWYfCXX8kNZ7hNVG4r1Xl+IBpb93s15tWZBDdHF1H?=
 =?us-ascii?Q?IKBgVty/s/kotSHq5LUMIeLMBcKbHvAzPpmL8XhImQtRjCBSZJNqEb7F4jtK?=
 =?us-ascii?Q?xO7lDatAThvSOBSM/0omp6Fb/OVO/FtSqqS/l9s2be7moBAr0YV49t03Iyj2?=
 =?us-ascii?Q?+3QDIGoKf09SQVD+VHrJqXI72FFSal1s0xUN3S6q6rz1TzDkEjAsqU4Lu5HY?=
 =?us-ascii?Q?BilXp/TGSENg/ZLx9qcoVuZlU4NVnjsojiOGXBmKReAETfu/70w+76V3GlXz?=
 =?us-ascii?Q?3UzEF9Y5qisBEka77TcP+GaS67Ew78s/QeiQuTrHGW/4kYilzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EHY2gXd+LKrIMz8Cij0qPJcF24N/JDZDI2/QvQb5PknNWZ30cqwclY1Y6LRW?=
 =?us-ascii?Q?DsKxC1ElvAwXHONt4VLwQ2QFDFy+ml3kZVTwyhNrU1SXb3bgGlUlektSI4N7?=
 =?us-ascii?Q?ssjJKxRJvt53RufxyFmVC42GkMDavxF3FBD3mY0Dw61cvSS8WcCmMtRw4c3y?=
 =?us-ascii?Q?D8kjwV774mfbn923wHTH3f8KNbeDYjU9quGxHFxLKs5/hxnthRYFUAtZH011?=
 =?us-ascii?Q?zeoINNlmSAcuCsX4DafuV97j5TlG1nCtjr1d1qQH+24RYL+ecPu0dn2+VoV0?=
 =?us-ascii?Q?glpwwiVHG6vQMR/2a9wv0rdsUFO+qBxn6mMxPvhBQhaScZKqTezc8qB58gVJ?=
 =?us-ascii?Q?08HltPxX83ly4Qkyg7VZTwggyQzZl+oR5C5ja63DuxJpZRDhse6uyhAvizzX?=
 =?us-ascii?Q?9guDOJ6fePwZ6uQq4RZRgKrC7Xlx3qRLELcNedxiU5AvDDQVOJUxuCvxX8z9?=
 =?us-ascii?Q?xUcZkHTpjulbVqlFUHJrA1Ib70cX6tQzlnXyCLyCMwUvOrpwwFKqarx9hmPR?=
 =?us-ascii?Q?aJ11ZaWKTOaEevK3+Kc/A987FHmwBccSGMzuPCmYaRwM45y1Rb50YoXjJkec?=
 =?us-ascii?Q?J3aJUXwh9W/W+FoSJU+bFyPqpsmUYSv+t/GYdD5vP7HNAeamh+20+iYQG2qR?=
 =?us-ascii?Q?ktOPG8S4MGW+ybfDS4kzUp+s3DpckfB2fzc2nZN4K2kCZy4TZwU6yMlfL5kZ?=
 =?us-ascii?Q?LBsc0Ncyeyc26U6fZQwpmfdGrA/VUk7DOiq0VvzlPpKpgego8yl57geY2a1f?=
 =?us-ascii?Q?HfIM+5uBPYFz1mhCq/khwzLTpZTUUaQ/HEd6pIJlgHQh1ZWqYS6Cf9PQoucb?=
 =?us-ascii?Q?DkBBbQon39w6yK2GsnWnMw61jdmpnRx2IaZtGn+IM1/P3ipDEg/xX3thcLlI?=
 =?us-ascii?Q?Fsrw1T4Nr4OHQc2dCSmEAALfFDwQTNIU8TcTmQOyV2shMcveuNNUdGa4cJs2?=
 =?us-ascii?Q?yM36c/MQdDWQc2u2EEL6C2fPhKmZ0P4Kh3fc3pyv/zQpicdm6rlLtL3vafjV?=
 =?us-ascii?Q?YTSvqTBrOYQL72OQAzFKCDhcbjDatQFNPc3PauUsJ32MMuhD9ojKEAeT9bL3?=
 =?us-ascii?Q?215ZJzqDFSrcSpICWtUT9EEzakHLB+dP74E4NLO37kvBhWOKbNkzYISACG2w?=
 =?us-ascii?Q?KjbwEaferQ1bg/IvuaQ5H4intCpRcGcpU+1kflBmXakD8cii9EcqJ4dPP3Zf?=
 =?us-ascii?Q?uLzcP6sfNJZgyrMtg0e/C/XU5/eZQZs4sgibXI7gSnqrI900y1Z35xrT/SBi?=
 =?us-ascii?Q?6kPM4pADUrYOvBgwSq5gNutQaOIhPQiPooHNP9R4OlToRRJDVuN5WgozSYKb?=
 =?us-ascii?Q?4QLMTpep3bBwV0lAlHpQAkHhw9q5nUhCM1emr4blZo8BDEXrKa8EQpbgdLJC?=
 =?us-ascii?Q?yaLGmvlrzgQIXByTipmetI/omUwaz2j2MG8QuQmhSfhY8pZe9ar7p4bQgP80?=
 =?us-ascii?Q?cC9l4k8see9z8kOXoaMvQuIUc2yoj27yGZrbpM3LTdR/gKUdPQJ3GTvlKQwU?=
 =?us-ascii?Q?TaVubXZJ+KJB6SbS3+ldR/lmXxLP0fYmQMIj6+5gLAwZ39wc7W/Hp0smUc/d?=
 =?us-ascii?Q?bs1YSnM9Rrnbvd3zRqUuc9qMTqcHIRO3JbmlADYn9H/TmTYlZ5S6sOkBmlpg?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uy6eWOxfmcOg/SVwX5Lnhi8AZRvU3Br8l8FszY6SiEb3GwIOz87UxDML+1gKrv5xbbRv/hCG+AZu7/cHYyGt5bMITHtLY6J449A4gmxQ+Y5QQrRvpvr2JDr9mEn8EfHEd4/wWZekLJn84JH2dahIrj7PWuVw/6YDOeBvg+BXJZ6dVb7wFYBad6jBdEm47ZD3rveu4560vId4isJiWxJCHYB80LOswxi40plTAvPVmGBByJK0zd2DUI/EzJtreqaWShbGtm8eb1w7MY34/x4EBvMVrpiz3ss0MvOeg+1UeKI4Qd4uwm3cJ7qIzF9/HAXD6EotFglzNfeLzyhop8lmuKIkBfK/03EyEfxqJYnWkBLi8k7aJvOi2hwfm54soyrjHb1Iunu8jFn5KP42YXTtEuMpP752Hew/tc4RB+eihmRuxqxGRswc6f/sQQa7MhIfNioOsGcdkt/uD1XPgKMvvgrGQQZBkX34vGyZCwif1cKk7WPrl4khfUVqb8llVROlb3ZhgrdzsYXv25fUNEUPvOAmqIPxwsHyhqKoo5USDsVyDfa6jcpw5G+tp4+Iow8l6N1ykgr/1KZjzTCmEhKu+6JC+NAkngf98pEAIJBM7yc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfbdab5-54dd-4ab2-2335-08dd82dffaa5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 03:27:45.2823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IecvHlyFOw109GHxiJt7wwud2bWZ4Mc0qMwFKPpFGjMNhzzLMat+UN0WCFANHOyin0C3Ec8rBMvkI26fvpvm88ZyFUvnxp3zMAsz7+yLUvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-24_01,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504240019
X-Proofpoint-ORIG-GUID: klicehkY0jR0CG1OIpuWFYUAxf-oUgpF
X-Proofpoint-GUID: klicehkY0jR0CG1OIpuWFYUAxf-oUgpF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDAxOSBTYWx0ZWRfX5zOBtY5f45Tk LliY0XSRSUSoWk5TVvkpCBXxuZz90tQXjeECU1Asm/mfA4275TMxSMKkLshdbqeAee8mJnpt8df BrfPt/QSjKpPT0IOWEyKFWnTNT6ee8CkbXmVpDDfBYtNTFHfNu69Bb3n0SnrZvg+KIB39dw7sXZ
 IBpXL/Jn6NNs5Am+mNiUpHHfTZiw1LJy46Ki77Zx92Lpozlp72dZ457UPLeNNWXg1lHGB0Fp3/S xnrDFgCgaB7zPNeoezilO3LVknUNXMDVUZZdJYdE3bdw7F6S3DvohnEQfl4VsLwq+JOsHYOoNtT CAcftBNetE1sQxCzD4VqaGtvjLDybljvBr4sRPsFrYg5+H6eKBGOflVbo5oIYyPeBbJv15sIJUA bToW/5UX

The atomic use in the main IO path is causing perf issues when using
higher performance backend devices and multiple queues. This moves the
stats to per cpu. Combined with the next patch that moves the
non_ordered/delayed_cmd_count to per cpu, IOPS by up to 33% for 8K
IOS when using 4 or more queues.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c | 69 +++++++++++++++++++++--------
 drivers/target/target_core_stat.c   | 69 ++++++++++++++++++++++++-----
 include/target/target_core_base.h   | 20 ++++++---
 3 files changed, 121 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index cc2da086f96e..39aad464c0bf 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -55,14 +55,14 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
 	if (deve) {
-		atomic_long_inc(&deve->total_cmds);
+		this_cpu_inc(deve->stats->total_cmds);
 
 		if (se_cmd->data_direction == DMA_TO_DEVICE)
-			atomic_long_add(se_cmd->data_length,
-					&deve->write_bytes);
+			this_cpu_add(deve->stats->write_bytes,
+				     se_cmd->data_length);
 		else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-			atomic_long_add(se_cmd->data_length,
-					&deve->read_bytes);
+			this_cpu_add(deve->stats->read_bytes,
+				     se_cmd->data_length);
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    deve->lun_access_ro) {
@@ -126,14 +126,14 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 	 * target_core_fabric_configfs.c:target_fabric_port_release
 	 */
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
-	atomic_long_inc(&se_cmd->se_dev->num_cmds);
+	this_cpu_inc(se_cmd->se_dev->stats->total_cmds);
 
 	if (se_cmd->data_direction == DMA_TO_DEVICE)
-		atomic_long_add(se_cmd->data_length,
-				&se_cmd->se_dev->write_bytes);
+		this_cpu_add(se_cmd->se_dev->stats->write_bytes,
+			     se_cmd->data_length);
 	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-		atomic_long_add(se_cmd->data_length,
-				&se_cmd->se_dev->read_bytes);
+		this_cpu_add(se_cmd->se_dev->stats->read_bytes,
+			     se_cmd->data_length);
 
 	return ret;
 }
@@ -322,6 +322,7 @@ int core_enable_device_list_for_node(
 	struct se_portal_group *tpg)
 {
 	struct se_dev_entry *orig, *new;
+	int ret = 0;
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new) {
@@ -329,6 +330,12 @@ int core_enable_device_list_for_node(
 		return -ENOMEM;
 	}
 
+	new->stats = alloc_percpu(struct se_dev_entry_io_stats);
+	if (!new->stats) {
+		ret = -ENOMEM;
+		goto free_deve;
+	}
+
 	spin_lock_init(&new->ua_lock);
 	INIT_LIST_HEAD(&new->ua_list);
 	INIT_LIST_HEAD(&new->lun_link);
@@ -351,8 +358,8 @@ int core_enable_device_list_for_node(
 			       " for dynamic -> explicit NodeACL conversion:"
 				" %s\n", nacl->initiatorname);
 			mutex_unlock(&nacl->lun_entry_mutex);
-			kfree(new);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_stats;
 		}
 		if (orig->se_lun_acl != NULL) {
 			pr_warn_ratelimited("Detected existing explicit"
@@ -360,8 +367,8 @@ int core_enable_device_list_for_node(
 				" mapped_lun: %llu, failing\n",
 				 nacl->initiatorname, mapped_lun);
 			mutex_unlock(&nacl->lun_entry_mutex);
-			kfree(new);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_stats;
 		}
 
 		new->se_lun = lun;
@@ -394,6 +401,20 @@ int core_enable_device_list_for_node(
 
 	target_luns_data_has_changed(nacl, new, true);
 	return 0;
+
+free_stats:
+	free_percpu(new->stats);
+free_deve:
+	kfree(new);
+	return ret;
+}
+
+static void target_free_dev_entry(struct rcu_head *head)
+{
+	struct se_dev_entry *deve = container_of(head, struct se_dev_entry,
+						 rcu_head);
+	free_percpu(deve->stats);
+	kfree(deve);
 }
 
 void core_disable_device_list_for_node(
@@ -443,7 +464,7 @@ void core_disable_device_list_for_node(
 	kref_put(&orig->pr_kref, target_pr_kref_release);
 	wait_for_completion(&orig->pr_comp);
 
-	kfree_rcu(orig, rcu_head);
+	call_rcu(&orig->rcu_head, target_free_dev_entry);
 
 	core_scsi3_free_pr_reg_from_nacl(dev, nacl);
 	target_luns_data_has_changed(nacl, NULL, false);
@@ -689,11 +710,13 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	if (!dev)
 		return NULL;
 
+	dev->stats = alloc_percpu(struct se_dev_io_stats);
+	if (!dev->stats)
+		goto free_device;
+
 	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
-	if (!dev->queues) {
-		hba->backend->ops->free_device(dev);
-		return NULL;
-	}
+	if (!dev->queues)
+		goto free_stats;
 
 	dev->queue_cnt = nr_cpu_ids;
 	for (i = 0; i < dev->queue_cnt; i++) {
@@ -707,6 +730,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 		INIT_WORK(&q->sq.work, target_queued_submit_work);
 	}
 
+
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
 	dev->transport_flags = dev->transport->transport_flags_default;
@@ -791,6 +815,12 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 		sizeof(dev->t10_wwn.revision));
 
 	return dev;
+
+free_stats:
+	free_percpu(dev->stats);
+free_device:
+	hba->backend->ops->free_device(dev);
+	return NULL;
 }
 
 /*
@@ -1001,6 +1031,7 @@ void target_free_device(struct se_device *dev)
 		dev->transport->free_prot(dev);
 
 	kfree(dev->queues);
+	free_percpu(dev->stats);
 	dev->transport->free_device(dev);
 }
 
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 210648a0092e..6bdf2d8bd694 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -280,30 +280,51 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
+	struct se_dev_io_stats *stats;
+	unsigned int cpu;
+	u32 cmds = 0;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(dev->stats, cpu);
+		cmds += stats->total_cmds;
+	}
 
 	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%lu\n",
-			atomic_long_read(&dev->num_cmds));
+	return snprintf(page, PAGE_SIZE, "%u\n", cmds);
 }
 
 static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
+	struct se_dev_io_stats *stats;
+	unsigned int cpu;
+	u32 bytes = 0;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(dev->stats, cpu);
+		bytes += stats->read_bytes;
+	}
 
 	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%lu\n",
-			atomic_long_read(&dev->read_bytes) >> 20);
+	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 		char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
+	struct se_dev_io_stats *stats;
+	unsigned int cpu;
+	u32 bytes = 0;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(dev->stats, cpu);
+		bytes += stats->write_bytes;
+	}
 
 	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%lu\n",
-			atomic_long_read(&dev->write_bytes) >> 20);
+	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
@@ -1019,8 +1040,11 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 {
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_io_stats *stats;
 	struct se_dev_entry *deve;
+	unsigned int cpu;
 	ssize_t ret;
+	u32 cmds = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1028,9 +1052,14 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(deve->stats, cpu);
+		cmds += stats->total_cmds;
+	}
+
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%lu\n",
-		       atomic_long_read(&deve->total_cmds));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", cmds);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1040,8 +1069,11 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 {
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_io_stats *stats;
 	struct se_dev_entry *deve;
+	unsigned int cpu;
 	ssize_t ret;
+	u32 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1049,9 +1081,14 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(deve->stats, cpu);
+		bytes += stats->read_bytes;
+	}
+
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-		      (u32)(atomic_long_read(&deve->read_bytes) >> 20));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1061,8 +1098,11 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 {
 	struct se_lun_acl *lacl = auth_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
+	struct se_dev_entry_io_stats *stats;
 	struct se_dev_entry *deve;
+	unsigned int cpu;
 	ssize_t ret;
+	u32 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1070,9 +1110,14 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 		rcu_read_unlock();
 		return -ENODEV;
 	}
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(deve->stats, cpu);
+		bytes += stats->write_bytes;
+	}
+
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n",
-		      (u32)(atomic_long_read(&deve->write_bytes) >> 20));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 97099a5e3f6c..05e3673607b8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -669,15 +669,19 @@ struct se_lun_acl {
 	struct se_ml_stat_grps	ml_stat_grps;
 };
 
+struct se_dev_entry_io_stats {
+	u32			total_cmds;
+	u32			read_bytes;
+	u32			write_bytes;
+};
+
 struct se_dev_entry {
 	u64			mapped_lun;
 	u64			pr_res_key;
 	u64			creation_time;
 	bool			lun_access_ro;
 	u32			attach_count;
-	atomic_long_t		total_cmds;
-	atomic_long_t		read_bytes;
-	atomic_long_t		write_bytes;
+	struct se_dev_entry_io_stats __percpu	*stats;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	struct kref		pr_kref;
 	struct completion	pr_comp;
@@ -800,6 +804,12 @@ struct se_device_queue {
 	struct se_cmd_queue	sq;
 };
 
+struct se_dev_io_stats {
+	u32			total_cmds;
+	u32			read_bytes;
+	u32			write_bytes;
+};
+
 struct se_device {
 	/* Used for SAM Task Attribute ordering */
 	u32			dev_cur_ordered_id;
@@ -821,9 +831,7 @@ struct se_device {
 	atomic_long_t		num_resets;
 	atomic_long_t		aborts_complete;
 	atomic_long_t		aborts_no_task;
-	atomic_long_t		num_cmds;
-	atomic_long_t		read_bytes;
-	atomic_long_t		write_bytes;
+	struct se_dev_io_stats __percpu	*stats;
 	/* Active commands on this virtual SE device */
 	atomic_t		non_ordered;
 	bool			ordered_sync_in_progress;
-- 
2.43.5

