Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15712F7AAE;
	Fri, 10 Oct 2025 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105748; cv=fail; b=WLsmp/q93uYRWo6XpPRiM93cKRgJAPD6EntM6VZw/M1gBO00iLIXdNcV43onH2hLCJiGgFW2ow1jo2kkV+N4H0L/KY8eEQJYhzfu/r2BrZ23mzvtGHhHD+dCa8iWStr6tS1znHJ8r2kKSA2e4yXZ5hrzm/Cz/JSrFFphhJagX20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105748; c=relaxed/simple;
	bh=5fB2BBJMhRxS1G19Pkcoqo0QCR4GQX/QpjtkbzkODX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tih4Fm5OPbWJfw9V9LkLjvR7Ug9kpQwn0XEQUvHLnmJhEKa4M1cZ+Ih4gki0mFd1SlERFX/ANHkkyI9ILKIK3L4TimhOQ/zVZwLjdKjhXB2fUCfu28zde6VIFHEsB67Rx5Z1MomO2xY47UwkOIrQFMIb/D7Ybb66Xs1OqDv732g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZQx5s7Jb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RzKqVZCZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZQx5s7Jb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RzKqVZCZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tV3N004102;
	Fri, 10 Oct 2025 14:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XLgc0ZZ5kB9CaS7MGDaCyc5T4uvTR43Rj5c60z1fX/Q=; b=
	ZQx5s7JbQ8AuLqzFgLSibryohBejJzwJ0blqbZ/CX3upTDGRiVO7Ij7mohbLFvpH
	LTXyZHPyUWfUfdaY5+hT+Ppo7ALwm6FIx2gREhOXHeyatZnIgnBpTthpEBUvPxOW
	Xo4mzUXCEnk2QOmtDVpO7cZ2x6gaG5r0M5MemGkeyiMwBUb59+K7C6dk2Y4zlvbq
	g+mKl3xg1Oznq5Fzr07AX8Fs3W7pUflfdErGPGmWDJxpB48Svz9v5pqrr/g9Eshe
	wUIn3aKitJxiJ+ey0qlqjwVqn6is6uQ9+RQbhU7nM9Z1FlJEmLaDazdXbbDMnZu+
	9noCVFNrTjU/HvWfnX+8mQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv6cbvxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59ADA5WX036943;
	Fri, 10 Oct 2025 14:15:44 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49nv659quu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMnBJ8vF4omk8kgivuHjN0KyGaBvp7T4GHZgCmNkBWeUiFvcd3bokTg6Ti8ls/dSaziR/beXWZ4YCnMYqVWCQKd3XiNIJ7V/9Kv9NGH9XXN5IZbG7RDw1/f2xlCgxY2HTFKpePwyPl/T50tZyhxxBqOw92CKGIzV/Sjv+Mjjn5kphU7MjVj5JbkEgbROefOFKEmR6sdqflUNoZKuUpoRjgo/zR4pXpy3TbMKE5mB52lbs1YYv/Bgd0lWmdfUbgDnTQmBP235tv4j/YWS4fDkpKVOzFSs4R2rFCyvj1R3d7FthXt2zvVxou0e2DyZ6YsEN000uMUYA2/r4a+Yz9Fi7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLgc0ZZ5kB9CaS7MGDaCyc5T4uvTR43Rj5c60z1fX/Q=;
 b=dSAdmbu1v1CsieS3h8f0MAcl4xBvGEs5BNsVmiLPuCTyG98KwBenTrj16hczXaEnQUCzpjCoE6LmO7p9TnPYci+Tt99t7rG48WyE6wqXAc/EVhwpM2jNhy40w+YEDMtgpNkMKVXZ91yE5/IkBhKu2JZvB9qCDsGuPbVMqMzMxBDoiZ3/wClEAZhPUvB/B8zFtb2/dsiANAvlf9qTqOnHawFB3pxjquTlKM+aPxwrVMq9nEz6iakZRPBgFixNDtJEkMQVMhYpew/nXPrJmVuXTWTehkwGT0VYVPsx0lvCc5bn5Uj9UegvDnPQKWHI1UxTCp5jztkDcKpjE/s3XiHsRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLgc0ZZ5kB9CaS7MGDaCyc5T4uvTR43Rj5c60z1fX/Q=;
 b=RzKqVZCZdNli03LYYwcsU4ocuu+pVVpE6eeuQ2Jsqry/hPFwuPjtExCBh35bhf6QW6Nz5FkhAfUmHsE/QAgwkdFp242O7kZsucszigvQ2Ry0oZ0D1kTjCwgRkpSiDfoIsEXZANtRR6lpVRrpDAVNms/UoBA4+QfpuluEL18mevU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:41 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:41 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 6/7] scsi: target: Add WRITE_ATOMIC_16 support to RSOC
Date: Fri, 10 Oct 2025 14:15:07 +0000
Message-ID: <20251010141508.3695908-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: e359f397-b03b-4823-17ce-08de08077e22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ihaZ9/oPEtiFPz1mn7i9vaHiX1XTGCHhFCJBD3PYHLmLR2sWaRdjdNN9Z/1H?=
 =?us-ascii?Q?B2g6n1Nq5N9pknFFFtPfKn8iCAxLh1HQvcHfQy93Ae+0mdeAb+HRHVzhVuD0?=
 =?us-ascii?Q?LStQoC8Z+KM/bcTC+IFrovuhcUwivFDE4/1+77ggVRdyCnTv+HJ00vhGANNb?=
 =?us-ascii?Q?4LYULNiH6i7I05cKNqImCi1jFU13NAhRWS6YO1qm4BBO0E9wiuFGMNCBh4QK?=
 =?us-ascii?Q?sYrf+ZGC8Rj119557awIqFydTnnf4xSUUQ43OXh1ikN4JehynWMMiWdtR/j6?=
 =?us-ascii?Q?k5t7uR7B3W0RgA3bTHw2YACairWRI3HYKc1OPl3ROSSpJGcYQh4BabrTYKsW?=
 =?us-ascii?Q?LjdmvED/3UGbB4ubcqC7kzY70azLHZP+gATiLiM75yooyGZbqDrf06otfiAV?=
 =?us-ascii?Q?dWk3CxROkG4UUBquxrfWgKbzNrI07CY7kZg3WIlYqMBwWMuNi3zwwriTp6vL?=
 =?us-ascii?Q?TMaRw+LSxV2FtgNgAZzZFhuKUZZ3HSDliVIdW4VHDtVRqrA04yGttYadIZsf?=
 =?us-ascii?Q?lO6MKQ2hRn3AHDbG+gYSf33MpqeoG9YIKisDiqr/4EtHqlLpTMIgsMIchRXf?=
 =?us-ascii?Q?MVperbOUcIbQIi5n/V30qbT3wrspRbX2h5taR898pUbpr2BXM8CvSzyqu4o+?=
 =?us-ascii?Q?NAnjn7QitaAjKn43IkkYGehadgz1NNslwprbFRAHaRkZYBej9S7+TjjtBl9d?=
 =?us-ascii?Q?MW89BTGbhiK7lej7zyWygA4sNJ8glVaciKAV/hydGaEDOmPbi6KMMdZhHSyQ?=
 =?us-ascii?Q?AxFQ9YPXmDEpvgt2iR1jM1Oe03iNQ4mVJlzU04GeBDF76aKKdiBTCESUxtRK?=
 =?us-ascii?Q?Fy2luXNFAUZrTlR4Ycn3WQZ4cOwfwy9wSuBJmLxF2dKS6ScovqTXSjqe6AiJ?=
 =?us-ascii?Q?7u9LiT6nPPhTd4wPZiZqMOf8vkAT2kuKDvAEGaEOCNfiatPCzO4mIrdkaBfr?=
 =?us-ascii?Q?lBNnwaXDVxYweLXz+C+U1yiIVXZ0+kFSzMocAzasnDfg1BUIyd2spNIs2rxE?=
 =?us-ascii?Q?/xAYi4rIWVBNq/WByDxp83spnpr4lLe50tBM2MzwWwy8Xuc+aanISZe6yFUF?=
 =?us-ascii?Q?pmurXpdjWZHLU3wVt13SU6DsqGLVKK57PXPYx++IoqSw32UxAfF+yUGCUeYx?=
 =?us-ascii?Q?sXtWJVHIVMjgOY5Aq5cBQ93lk/PFB73EdbmUoiqmJG9YAEbsPEih9rHOBGO6?=
 =?us-ascii?Q?fS7h22UAjshqGyqk3JiffA55AfC+6aVqy9qdoh378SfzWd9Stz1rxhzvK5o/?=
 =?us-ascii?Q?BkPzEcp5jkYpyOPps2ZiLpIl/UDhGAkRULdSwC6NI5mfv5FXM1iGh1wJ+n/o?=
 =?us-ascii?Q?FGs8Gn/dGi79IfV/cy9kNoP+kLhkvLzXz8havJN8gBcxWa7i/RRLIWyOfmoe?=
 =?us-ascii?Q?a/lfMo29j7mKPZQTii5N096XDUlUCF45pITSMpptJDD2GSKxnQ2ZOBzq5JBg?=
 =?us-ascii?Q?wwsI2SZmuVc6AUoKfDBM6MFk3nDnQlhP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/j67vkAmvc/cfz0WfweORGpi+SepWowoS0mVhR+fKMvptl6Sc9YTJAJZGeWw?=
 =?us-ascii?Q?ZbKVMTxLKL5hHqUVv4v2IoT3ooblMaSx8BcMGKm/Eh1ojFb6Qtr5pxxbfXoR?=
 =?us-ascii?Q?+ysVSbrI57hxU55DTmA6wu/SPYuZCHv1NuxDtTqowxyAB897OlDWZv+pyUY5?=
 =?us-ascii?Q?akYfj12cd4SHDppS2omrKFuFDBwJ26PeNwbGPT4kU2nKZtWfRB2wDY2AqmpD?=
 =?us-ascii?Q?bmepBJwYo9qq/O8VgbNIsBI1OAOq1++OkpZjYxPQ4viPmKli1hAXQuNw3uVH?=
 =?us-ascii?Q?TDhL++wcOTT2gI/K8pLEAUsXTD4etjpyZaL6ajA/JGOE+Rs6EVa8/Qgf979v?=
 =?us-ascii?Q?DNPxxJAlOyjH0kWdD4jSwZQeuF556nrMuGbul7VGa/VyQHSz4HRseJD4NUiw?=
 =?us-ascii?Q?96O1MskkcWh18RyAoLoWAXiG2HmtIc/tT6Gll14QU30oVlPIUySDPu7d6qH2?=
 =?us-ascii?Q?8xfZZU+bPBOplaMVzZ3loDxTYG9JO0Oadz4Dmq6U0LxeYTZf/XotO7oqPcYF?=
 =?us-ascii?Q?lbOcLlUnmFHmNK08t1X2g9IZQQAXHImb9ESxpbAiGYhIgRWS0gQfmV23N6fG?=
 =?us-ascii?Q?68/iYuo/fzwubB8IW4vdZ/NJYZqtVN7trbMEeP8TAg25lZt6Zoj91a6D27a1?=
 =?us-ascii?Q?34v0+3XJ9TFYvVnYsLkG7prA2QDrPagyvW9oop40H7nxcSmeRAJ4JbIKka4t?=
 =?us-ascii?Q?G/cFL+lFZVbzOBsQue4qI14KMwqL161gnHOzOn9xQcyxW/7kTPKtjWcMrW+p?=
 =?us-ascii?Q?eMbGlQdwrQ8x12ZnaeBQA2OusPGu2EZMx0oM2zHUeu6BeNgm9k7vkAGHeaCx?=
 =?us-ascii?Q?i/iT95GXARcp9J7vTT6IITJLB4kK0/fUGS2R2qcyyeaK5PRjRnn6Hq5RBEW+?=
 =?us-ascii?Q?x6MEkFNa/LRXN6veb/9/gm6fRblQLRV+ufPHs54N5dt1q2pLvrt/XPQFZbOo?=
 =?us-ascii?Q?LAbmS9jia4XbPJB32Ky+1v1AYrIDQirB63Nlh7Ckr3CPUw7P86h4w5Not28X?=
 =?us-ascii?Q?3xwKGJMHlCRhKQAma/2p7RCJ5kdWmBmX1v7uA/iBOIs8Mscc14quntWlEcrQ?=
 =?us-ascii?Q?5skh6fe5Ao1btM1BGQXlF8uEY7yAYZw8/M6EuoEERyezooasafOjXoEIC3hY?=
 =?us-ascii?Q?/etcnzwx3wP2XUGyFZIm4th6COs4rndeuvvnq3gFCni004l6QSMj8ZRQZNfM?=
 =?us-ascii?Q?Qf8CgmRoY2ZEDIFH1S7xEBHhKfrt5nfOhdqh8eFAEKfqDK4ZyMTaVJRE2Ah4?=
 =?us-ascii?Q?8Md8VKhr76oznVfKxt0nTVkJQvohTLkhuwiS07zCXkQcepznefxQadxqLHIb?=
 =?us-ascii?Q?QwwfJMYyyg+zyqBi1Tp8lCDlxkjotzF7JbKpYVRMBAidQLUU+6a/zsWw74hG?=
 =?us-ascii?Q?7LBisoPKwG21mU49ocPfANKq9hNjJ+N9tuNOb6/ftKjytg4MXDcyx0lstN1B?=
 =?us-ascii?Q?915OHc2Gaw8gLsQgAK3WzRm9HkMVAnWvN3oUlB/NgRWe0JGxeF7iSYc5jnbY?=
 =?us-ascii?Q?PzPR4AXkRvHiyj/3k4uoiLLSbPVpbEZdzoPMk/ji9fljvK22SkUoMIxIU4u6?=
 =?us-ascii?Q?2qwcJgIqMP11iD1TeLW9xkIXzPo5mYaRoXnEtUSMkgkZuUpKUMaddOC2gRHN?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NHxYL+32GYha+9xKZ4GKr5Zn/rHmjSRpsEQLy7InIn7Z0B1J2+eySgNPi57WFp4Ux5LjS3WDZ7LZ/IgiLGvul5BPmKAP1Bs5VFwaApc8mtSX5XUyHBbqpdy8br/30EN4Lx0dmPA4/EvUfsDRTXXB0mm2ZblL/5P750eyH8tVvnW3/6js8HrM3LurFcaFX4Bqbxi1yIs1ZG8hYQOKiaRqy5RHz5keXvfzECeBVeWynOvzo5V8hH/0ap+apqFZJYzo70Q18wSB+xXatKeLXjsF7cZwtuskk41hyPH3WDKztork4ibzqUe2yhaii8lS1r70mt2EJN0h1h+D/n95wtZz9W9EYTmK+zDKXogIsco77d/0SLYuFeypQnPuEPEXGHKFXC/oLEZWLS+rbG86VI6tJDd7olZZsj6gb4xs0xB29zTEamI2jPWBi2ENnPjl0IJPjtWTeLrKxD18NoFz8l6ljy2oGUkwqlUR7ykSYb6QGrIMqf58/JvrY5Vy6MRr7VQ1fjUyntJeOjJrSyedJSN4IKePK05oabUmCDPPfV0ZUrsk+DKIQc+HmKjlmHM8qH2rDfdnySu+DyOEkFWNXOYDTmjMLAKaaMct1w+AXE5FAIw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e359f397-b03b-4823-17ce-08de08077e22
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:41.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2R/+GjZ6jLjhRzv9vERqUbnwpNqVowaeniigv325m7ySAG8auEYfAmSI0isPDkjk28GqmElUpI6zPXSB8tv5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510100082
X-Proofpoint-GUID: V5kiJCED4Y89gh7a-ZDRtnqbxV2fZCh5
X-Proofpoint-ORIG-GUID: V5kiJCED4Y89gh7a-ZDRtnqbxV2fZCh5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX16TPtV0tqAUw
 f/4DgLLpsKfseVy7lxfSRfKRkkeFvgqcpwhCNJrbirwSe/ZbXv4ah40HqNCq43TV7tDYdD8gK3c
 7P9eXYXT5TpuyVsNy5cBtlOueOzCm58BVCodWMBstwAaybYfYbk3NUMQc76vYwuzOmozZtOgdZQ
 xpH9K+JuaVzKCTf7vjal8QAnELxJurAxL7+M4L8Fg+z33JE5ePvWBwfLGs+ESuea4xcWhlNyX0R
 xm9/RhkHGy0+WTSOvRkDVWIAiTVb/uKq681i1voV2B5249YZ3LyokQUtdNdDeFXzvI/YYNpd+A6
 +vhge7kHX6Pr8oJI2kOKzXx3Ebijjv4O/uIh/jLJ1jWHgMLgnaGeANiYswbS89EBuoEVSPnLN71
 3GKPuxOytMiaRVqoZi9IgIT28EAQ18HCPOLPA9fVCRhwSPI3JaM=
X-Authority-Analysis: v=2.4 cv=FYA6BZ+6 c=1 sm=1 tr=0 ts=68e91511 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=O87o8OpA665DpUvGGjwA:9 cc=ntf
 awl=host:13624

From: Mike Christie <michael.christie@oracle.com>

This has us report if the device supports WRITE_ATOMIC_16 in the
REPORT_SUPPORTED_OPERATION_CODES command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_spc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ddf8104645d1e..fe2b888bcb435 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1470,6 +1470,24 @@ static const struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
+static bool tcm_is_atomic_enabled(const struct target_opcode_descriptor *descr,
+				  struct se_cmd *cmd)
+{
+	return cmd->se_dev->dev_attrib.atomic_max_len;
+}
+
+static struct target_opcode_descriptor tcm_opcode_write_atomic16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_ATOMIC_16,
+	.cdb_size = 16,
+	.usage_bits = {WRITE_ATOMIC_16, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_atomic_enabled,
+	.update_usage_bits = set_dpofua_usage_bits,
+};
+
 static bool tcm_is_caw_enabled(const struct target_opcode_descriptor *descr,
 			       struct se_cmd *cmd)
 {
@@ -2026,6 +2044,7 @@ static const struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_write16,
 	&tcm_opcode_write_verify16,
 	&tcm_opcode_write_same32,
+	&tcm_opcode_write_atomic16,
 	&tcm_opcode_compare_write,
 	&tcm_opcode_read_capacity,
 	&tcm_opcode_read_capacity16,
-- 
2.43.5

