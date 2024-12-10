Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FC31A2550;
	Tue, 10 Dec 2024 02:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799324; cv=fail; b=sudvfgI+t3LlLDw0KuXmBrU5JbcNGpojbEGjRTWKYORdmCU41TSBEUpFeut6qFKor/Y8uIpaNXFLoW/jynGnY+zbFe9NRGFCOZZUS3Lzt2S48r9fNIivfzp39SlWklCuaz9if3opQEiGCo5jn20PawYIsFHHFZkdLWPhiHkEFhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799324; c=relaxed/simple;
	bh=dZ6ZxTIdAAI0ImYGaB8XzI2lIsUlEQkuw25pPXRmTPE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=sGHU+drC4CrxGXqfoLCK/QzuS4TrwxUekJIGviKDzTggZoB38t4J4LA9VsL+uwDzHoQ9Ija5yRZn2S3e1T1+lsOJOARBjS6xw8DF5wel3YIPSQDSe/q9pnJqQjHZX6emkhCQ5swwW+TsUPykN8uDz1FOEUvuKTu2ai591yG8u6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=he3VMOZt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J6/j5+tf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="he3VMOZt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J6/j5+tf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1chFH021896;
	Tue, 10 Dec 2024 02:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=FxHhRDE5MSple5+M8d
	PR9Dve9NMaU/GxamnWlb+rH18=; b=he3VMOZtzMlYaQyowCMbDFbR7UPuVh4Lfi
	hh6JA7U5DPgvjU5fzBMImA8dnd60/7LJ/T1Lr0xCMgKy67HP2Ljvyn+5DOEtI5CR
	lyjhhvt5Y1XhAeeM3vochmOVoveksyAauO4U0IjrRqrdy+Tbdj5J6eMgE/nYHpJl
	iJQ1nWVF2gnC2XGfTUg7Vs3VKUHj1tWdpRidVOI2Yk6UxJIvoIfPbdyePzq+fT4S
	Hd4AS5u0UoQus93YSRcmTZSQzgt5YNEHIb9FyJykOcijUMIaypgQxEaSbSo13qtt
	6O7wzScvtLGlYljZY6cIz6qRSNAahWSbeiLmhHHy9CPQcphpjl8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43dx5s1v9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:55:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA0VQ2p035101;
	Tue, 10 Dec 2024 02:55:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf89bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:55:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMzxRLa1Uf0wePIwlSxpZsvjXDRZeWuWKzrSmXbQuxthGN4Ii6N6TBVKHlTQQ2WsECVyJAmGaYZeloyf5fUbs5yvNwPbQ8B+Vw8oDP7bQsOdQuFrXA48eV7PPWniecmQaog3bUCV1spR+D7nXAaa7i4NcK2/jDkLuKrB5kvUwsEcXxNLp/h3aZoxRuulpG/KdBSMOMA77JTWcgqgTzBqx6lB5rykjJxo1Sb3sXKtRQes1RD2FxevVv5EdVsGOyAGNqpfs5tQ39cn4igC4Le574wH2GQXyCtZKjdaJevBjyerQKr5oFfa2sOnBH1WtMPPWvYQTY6/r/XY8OwHhQqS6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxHhRDE5MSple5+M8dPR9Dve9NMaU/GxamnWlb+rH18=;
 b=ZudGRjIgTKZt2L9ImoziXKq/+1vcuuHUFZ5b5+pJH9WChwBbaozXuE7Z+FAAOl+AkNhLzuvurvBvjjGbv5d7T3fKnE7JNVCzhfzrDZEOxOvenm7g2lUCt227H35H54S+SAYDc41mecHhadq4OzWawflNXTYujh0qDqvCqWFouj3h/+2b8/5Zmfe32xRl0+80kTYbTTfQGtqeDxaMXoejxdE8nvvP45YYTVIm++vPqoPc0dg52/B2o9bGJQ83755znD7E5Q0knyYfWUvzoE2AcKf6oVBtXccJ8ELReq4aO5Wh1F0NO/hC2DTE84HB/4Kqn2kqom6g8LZgZtV4D8VtuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxHhRDE5MSple5+M8dPR9Dve9NMaU/GxamnWlb+rH18=;
 b=J6/j5+tfVkWow2wEkQdiiJPwR1JlrTtuQXZkUNNtyjIzveushYoVpQOKt1HkYjXyhZg/lney8dbqYuR87sNnguZ+Q5RQxldwR5JAorY1Ai7IUzKniW6W4dzPhShfPQ5ywCL9XXRpCjiKyqV/qEOXbQqUIgxU4j2WBwd4/kNkjJE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ0PR10MB5566.namprd10.prod.outlook.com (2603:10b6:a03:3d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 02:55:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 02:55:10 +0000
To: Nihar Panda <niharp@linux.ibm.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen
 Maier <maier@linux.ibm.com>
Subject: Re: [PATCH 0/3] zfcp changes for v6.14
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241205141932.1227039-1-niharp@linux.ibm.com> (Nihar Panda's
	message of "Thu, 5 Dec 2024 15:19:29 +0100")
Organization: Oracle Corporation
Message-ID: <yq1bjxkjlh8.fsf@ca-mkp.ca.oracle.com>
References: <20241205141932.1227039-1-niharp@linux.ibm.com>
Date: Mon, 09 Dec 2024 21:55:07 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0185.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ0PR10MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: 3984361d-9b14-42a5-c0ff-08dd18c60fbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vetXLyeF/GhHohMcrS/97So6/sOvotvoRLi38br6RWtX+JJyXDcMwspRXpZr?=
 =?us-ascii?Q?SMyx/z/A4NukG92KMXNk+9dx9/jRI9AONhWAaD5VRXXfuuTidMFH5c9aqzB9?=
 =?us-ascii?Q?UtYiPafDqc7YoU2xnMWDGtXOpLp7W2+SHVysfseGMGr/WZ5//Mzy5Pt4EXI0?=
 =?us-ascii?Q?oFBjt598S/VaNAL2uRqH1+iosUq8lAOa/2BF2EjRTWpukICGzAZ9qeCJBurg?=
 =?us-ascii?Q?ax22XLclUtod0A5o4kkShPphedrR5KpiSlKZFJzoQRYvuMTTauS2eKxhmh/S?=
 =?us-ascii?Q?SverplbdZMXXhOwRMDOTiqA9STYH3IR6jh7cHP7QJQvIN4/RlyVyg7/qLAT+?=
 =?us-ascii?Q?6fkIiUKxHBnoTDS12y8uxL7UMXXk9D+x2abTnkpEhbltRHTEup8ohsWeiZoz?=
 =?us-ascii?Q?eE/9TG9J4pBcY+nT1comz3hLMU16KUV8AJn7IbM0EGMeWa/s5OqGbS40XfRX?=
 =?us-ascii?Q?AxblhkHTq13Lu3VWnEi/2HFCI2O624+52s+DHgLtQsjgL4q9REQWZ2gWTacq?=
 =?us-ascii?Q?ferLeh+2uM0Hauhrtg5tgyrs+gk2iXyzj9xfZ5Sl++WvCVmby0OZQy5zFZdc?=
 =?us-ascii?Q?dI/QuRhQynq6JD+U3gDlw56e0ZwDAFDnGsnRZSeQlStRgBQfWcNSOOhNffNV?=
 =?us-ascii?Q?aCVJLKDbmVkfrmxS07PfgAcIBclxVITjt+D4nzSv1xIAH6uX/IantVqoUI18?=
 =?us-ascii?Q?vjBzpz1clOuJkfB93C4ENSNkyBnY1iGEMx89N9RG8PhtW0/ty6/Rm4Bqhyo3?=
 =?us-ascii?Q?xgmVjPe8xArTF3ZUSYPVvGytJZe/5eI2hMIEtyTea+RdLfMXbTrEMFIaMecb?=
 =?us-ascii?Q?qSX/3u2ghvrBIGo+0er6w6ZZ5iJg1gEvr2J+lbgqZSOHJ+fJSmr4j7lvNwJ3?=
 =?us-ascii?Q?bW4SRyKGCpR0rgBuz6yp1m43eYuTlRzjVOew291riuadWISUdXQewDZypS14?=
 =?us-ascii?Q?kl5ZRxJOm3Q+Rv6GZx1ptvhiKD2tsxud02A7MePPSEpneWCN7DAYCToKQzCw?=
 =?us-ascii?Q?ZX4TrL/fWIixGStrr8x2yBB4vRl0gLKgj0dfc7ffCVhw1gzpCHl4AT8wfgLt?=
 =?us-ascii?Q?68dLB6MO11zh1vr+WszbCgBzU0CzcWfqAZtIL8FHd61HZgqfhEQosgT4bFY5?=
 =?us-ascii?Q?4xsnUg2QZ0nP6HdElu+DaD0OmDQQIiiPq5Ad9sNCfXrv1CJjIsoI9+4NzBP+?=
 =?us-ascii?Q?S6FmsGDRiXD2nz94eRW8HKc65yRWyn4qiDO/L1SbwjiNQypNpEj+WHx0ySD3?=
 =?us-ascii?Q?AWFwcddNLDpecFM2uQyEVIb4Tf9VP24kmt/Kec5DCqGQY1PYTvMGYDov2Bll?=
 =?us-ascii?Q?GzpsVppKNmXzIJSPFOVIA8voca1tZF6OUkcWVGXNOBizTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BzNHJe7wTWiiXEy5vhxa3flSqhoBzmQX2HYD/+9Lf/r9G5+6G6hx1LANra6C?=
 =?us-ascii?Q?u+PnsPVAWWFjaQZUUoOuXQ+PT85IPxXODtlkOqcpC9+de2gCODaA71l10tHf?=
 =?us-ascii?Q?4e+jikcIqm9CdFiUQxHHtHU74POmC0oiJC2P78Pn9Fhg0ZAx53PW6umXzW+4?=
 =?us-ascii?Q?sFxq0S74J87DzVH2unQB6TbeQtuHjRVnUnW76JoLTPrOvGXvLCGT0GejAkEb?=
 =?us-ascii?Q?GHQ7ahrDv8AQslL7FYI659HQUAxb4cxKsDeuQ4P9p5ytU9Jja1F4Zxtgza0d?=
 =?us-ascii?Q?MllypYcYUU4QU2nlbW+B6xZaNBBsVQhvdiCmY9GEfiXeuXC13jh/QCz240oX?=
 =?us-ascii?Q?LgHwYsSnyPktbcJ0OHXElRZi4DCXsgi0HPnEYW/C7x7fGvjV1iDo153T5SLf?=
 =?us-ascii?Q?yRQ0YQxt4NI7WMD1hdDeMfddUgEZhknnTCQfYdtkDSC91Utq5cCuyTm0CrBY?=
 =?us-ascii?Q?6zYbyrkAcXDoGS6rIj8BOBwzeaBcRc3Caop2uYpghmReT+2nW5RrA18z1iUZ?=
 =?us-ascii?Q?YRn1H8/RCr62bI3rkuZjA5SdJcU+Fp2CK4KBe51G/FmcBnPNsprSszC3gvX+?=
 =?us-ascii?Q?WZwOF1oBBoLbJCdDDfUdCYhoNeJEDChP4KeGYHgVUgNWYnOTmGnKde76bkna?=
 =?us-ascii?Q?NF5yDkrS1koj1xG1DFZSQFFpkIPP3r0Z7H4HQJzRMaOF+afnp0VDfeCXqXI8?=
 =?us-ascii?Q?ZipBK8J3BJ7/ufcjdV4SzNrzKGBYzYlUZZsnKu3snBAksJnL+CVl+DuUtHQk?=
 =?us-ascii?Q?x478hQhJjRvLNKNsKjsz88IrlUBRh19C/wFHYVcS3fT9xGYYS5flTMZkPOwF?=
 =?us-ascii?Q?MspC6zatSyZFSUI+NuBscnGlMVba1XyAB9/KR25BJ/yeqtRkcKGJiTMfHMk0?=
 =?us-ascii?Q?K/tSmhea8euWW4cu32kTav4HMUmDg7TD9GZOCs5IjRNocCh1oyCsG0e2wtVD?=
 =?us-ascii?Q?iz4MdGbvFa1Uy/RlQ9vuPnNDzDXjOORQeSazOxgKhv2jBI+nF9tL/lZ2mPFt?=
 =?us-ascii?Q?UNOWLJcOO3KwNM4pQ5gBiJ8ixSkkp9vptaQojDbbHF8xCDwyv0UehVGJx88e?=
 =?us-ascii?Q?ve7iADWufAteL4ajNlwJQw2PZ5pR/YTvqnePXHjcsswP/ziC/ISAvIjPUsRc?=
 =?us-ascii?Q?p1pGuw1h5C5vphW8pKWTXzxL8RY6eT2tJ5fCGxaKs1t0dFj/2AIl2GD8jTen?=
 =?us-ascii?Q?Ofnx4HaDsTb1yFWhtUjd/rzX+Q4NhF59L7arAZ/++B4hU2b/bqFcEAjkuAUt?=
 =?us-ascii?Q?afJ96lwM07IToZFk1dPgIzCd1H7kO6JdDtMEmzfSu69ntUpi837NJD19qgSc?=
 =?us-ascii?Q?0YatwRNeE1oDse/ZJ5wsjigcXVYfMkLZtxVhE17QJZmGIxGMxrivavtYJ5ak?=
 =?us-ascii?Q?Or9gB1KxSB2Lc9Gct5OxwzJN4v4Gmysr4pBKHM/fViMikPMFuFOQ3lLKgMbY?=
 =?us-ascii?Q?ypLxsqrBjlY0lwTgRfHM9/XMoZtVNWADwTC7lcHuHoevUFWJTbM1UvftrXMV?=
 =?us-ascii?Q?X+niJKFoNyelXD05xA6skF6M6dqWlCzPTqmh/zp8OBVl70YmFOmL4NjYQasc?=
 =?us-ascii?Q?f3LWTZ2PYPMASgmSYFC10NQImjQmZGN0MJgBFTx/V8aFoLGl/wjo0rOo5Csu?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qcQaj1USyTGi+l1RFTJ/yUVvmogGetNuk12fduvryqjuakQDnYWSrMa8NbMHBrAsFT39MdKC27A+L748KBQPDbY7WFTbViWXzxzAPCdthIN63v1pCKPwQ6F4TF5JN9ZKBnVEpfa+MDUTNOLmeq8N3krhTQddpUDHrjsG9bSv0o0Vkr8Zb9eI2CQe3pCU79Jvojx2JNb+9sLHLxWSVacd+O/t+bcAQql0GfK+a1qT8shs2VKrqrmKzIec67BHxCai5l2K4XeMQB4m/GcEyLweniW+yo/QZTyn7mLaWzWnqwoqn7UI2EajhskjAIcQiu6jyZruK7N3iRnlNdaRmrPJJknkemCFRMOH51G1pgHPiDifrAqzo2XAqSZyXOoWOwbx8DTSZgoj9TMbESEzuhdKUiohFUUPHR+2KZz+uKsKRMvEUOST+VwpGPAuCfOqOhPcIGteTteS1FotJU6k4RjYYzfdc8dDD+OYR8Ij60M8kF+uWqXJpGjARsm1dZUopztnom5b5h4xI0YAxAgan0Ykw1nxTBm3T2nxWeeE6ktkTX4GKV2KJRHgJZa9OGtm5wKJCIybjSktz96IBtiiOfgAvLCu89+FNUS8pPXVLYXDBog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3984361d-9b14-42a5-c0ff-08dd18c60fbf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 02:55:10.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GX+evAxLxvoYUE9aZqVqVDa7FKxaOeuh1WwXms/tHnii+D/IRzH+axJnhUWp/1ETCn1ZRk/KDYt91PsAf8Gxy+vdVvF5qi5HNSViUsf13c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=689 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100020
X-Proofpoint-ORIG-GUID: 1yn4bXXNsG5PHBMW2GD7JgOiIM6vMYbb
X-Proofpoint-GUID: 1yn4bXXNsG5PHBMW2GD7JgOiIM6vMYbb


Nihar,

> here is a small set of changes for the zFCP device driver.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
