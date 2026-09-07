Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB546D087;
	Mon,  7 Sep 2026 10:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778417; cv=fail; b=DGpKr3/eJ/RTOrxhG7mMXIa0QjdXK38pH6/PeUmfjAg7mgnvKqZeUesSYBDj0iLJdJUGnEKZwfwtIWYTxRfeY1FSBf6NpkAOeJ2y6UJ2P+86aLt2q12E9fLLuZwQrumbLL2O/x082rMK8e+irhQN7YN/04MJ89kBRP7hTd7AUlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778417; c=relaxed/simple;
	bh=owmzdSnRU3Npol/nErMOuWZNNj4mpIIsnzxYXTMd1VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E8pLPFoRwu7ZA9U97CpenW/Z5KFC2vOGhV86saX5VblY0AL3mUrSHAvwTzFmUr4hm8vCYlkxYuRPwVy71Ja9FHlbicRMiftNJlpCAcpZ2RtpwD0TAmkWFKUzV/sg8FichNPrZslzQPR/quM+UYspnT+QRIJy5WIO1sJKHSucepY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IMNsAdoB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vUylcbMV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IMNsAdoB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vUylcbMV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6874BIFh643862;
	Mon, 7 Sep 2026 10:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Bz6vYg0DEpsHOsyJklMsgYwQlV3aN2Vvtd+RjA89ao0=; b=
	IMNsAdoBqV2P00xJYQHUOoXziFMn4YFEXtizuoYUjwcJAW+FgpwIM5HG9hYO2z1T
	aGjGKiIYnG03MjX2vqTlid3UM4xGo0LAnfI4DO/4/jJrQgYyyLqyFlhT6xotV1C+
	gQjFoehKoXM7Ei8SL+YWo08wiOoC7uR7Yw6wkB5u9nFtri9FFdHyTOFjpTwlKg3P
	YteEtg+5b1gcOd/Zs/sBR/4N4GaLxMrMNKJxTu1k1nXt7LSwlOiK2fkHqOM5DuBl
	vhSVyydUxmKE9V113YVEsI4lbCIwK79nfARK5KCFLvtRuWttQkj+yCgIQyK8iGoW
	syUAocFX9Feu3VOW0IqSrg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbg1ssj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:52:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Apr1o013241;
	Mon, 7 Sep 2026 10:52:07 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7atpvdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:52:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyUI86otKqJoBZ4ycW7wnf8O9E2ahhw6U86fudyaRAAf9iNUev9ZRA/h6XIVSZiELnwAvdfubE5ssA8q3A5YnhpzSHE2lMQfwYwVahhvbt9A9+iJYmM7bLHbkgblSHWb0YtItC1rEEVt8O/qwTdi0mFRepEPagPZF5QAO16s6iv70k4x2SC8s/7KRII8wF3pN1gxUcVHiovnyq2neYh4R4aDhER0kJHGNk+QlyFZZdLr7yCuRXTcn6ymsJ5RPSNvspGKmAEzvPHPlx4fnaxvw4GSrqlKpK4MJa2LU/3IHGQZwcJOp3+NRth/35VUF/gdL3XfdFAN7ZuGXVefMByQWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bz6vYg0DEpsHOsyJklMsgYwQlV3aN2Vvtd+RjA89ao0=;
 b=bKcIVZaQlRPAedxfjzbgL4nF15UoJHWFGC4yo2gRG3ZNTthSEZkCE+qkp89NpdaGdxextptBJ0sxE20uTXroE1G0rDExlNPbEK81I8MoM6siBmD8jLSl5oe0iv8oQU/xdvKYuP3OIDDCPy1Bxp9N9TM7S3WZntSNf6fWU0KUxOk7VuYltfeSV6NVXVroVokC6aEr8uh+IzbuUyUmaX6W1OAgbKZ1zSJllJwBq7tAhKqoGkhh/sJtiRm/FZnHTd/Q/rbQ46CEMCixvx+3QBwbByLnHo7N4XuO0lVQTc+xbe4Q5i4KSR8wsXaRXbgKl68iKe3U5zr8ULeMkXEACm4P7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz6vYg0DEpsHOsyJklMsgYwQlV3aN2Vvtd+RjA89ao0=;
 b=vUylcbMVjwQwEDAB0uLH1v42u4b2STwS8Jpq1wDv/CJFwsPYFMVgtVbgI+ZRNem6/sXsuVLMBcLZQpb97IygWsSbrFuB523J4pY2kLi3lzIIPidePLyFGzxPJmLbKrPwyEzByeDnJJJwEzaG/+PXcXo5Nzuo2lBWdd2cZMRIml0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 05/27] libmultipath: Add support for mpath_device management
Date: Mon,  7 Sep 2026 10:49:59 +0000
Message-ID: <20260907105021.1763236-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 232108d4-3f73-484e-1c76-08df0ccdde1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sVmQFpw2EkXjzvmV/fFB11cngDrUWz96hDI91B2Hgolj2Mz7d8+Qe53kcCs731t97o+YV5dtOXz0fgXsEp9UQ4Jiuy+prEHildq2qMf7AgU5jBR2vYz8LNjfmUidlkncVENUXfxWvA9hZkTFlc1BWlVT0Xat7WpGgmNzAl3CiBGaYs8xUjMDCvGZJeahZfnPKk1WSChFqoeubJRRBsd5iWB/M8eHwJIvz9udYCPgAUeFCWR+UbEfCZN3c4Z0K+JKCHP0mafo8EVpVx9o3IW/qGQCl7rPx8Q8hH5wAoer555ygLZS+EKbYoDca4ZimRNJn/5u4DnwJpaeRplgPJCURz8hTVnpsNVyRGzRAahBiO+2pX1xyAqOPOAULqwnwh/O6VE/WfBHoyuqaiCSrUSseOWEbpOUBaomHat5g7EfgzrLqiid4aYaUJOoxIFjCfFNpo6zmKSuj+PLVMCMXdSXLdyXCJrDgl+BEqvwY8+2YkSeBBdh6WaqVV/guxVT2gswa1HYHBf3Eh3xRViNAmXBSa9YRipKT3gAr0rthC5LHPmT8kAt27Lp/KW5HRGyNFcFRQm0THnM5BYOWskDf+8jPo+RW3wwJ5wASbu8NJUjatDq3cgNqe5MothhPCrT5VBkn0B85N759vck1YNMR7QkDc8aeSJzj2mHVvKIpsQ1AT4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NYzIVfb/2/ueiqpG7oJ3LXnr2phitdapQzMIY4JsPQqU9lbR/S924PzMgq01?=
 =?us-ascii?Q?DyC0Mv9WSOiTPRX7ccvCwA4cL1xxtndPz8vOFTxX4H2NCguhk27UGajoWA/D?=
 =?us-ascii?Q?e4AKyhcsZERgDBAD0DtyU4/Iq8r+BDhPaCTYFP+nW0mjviVA+QCrftvZGQOv?=
 =?us-ascii?Q?90YMkzDjeQMFtY4pBFTp0YVTIIJUD0tZVhW95OFn7obpLxOBNnvh7pvg7dB9?=
 =?us-ascii?Q?WH40x9Cwz+UT8KJU5Cj/WcmUsj9cemyxDMi9irN1Z2BACxLuBKWaNp+LgSAW?=
 =?us-ascii?Q?/hYoOCDvElOARFx4d2AZqq9jm5Ct+KEQF2yUfPWC6lAZY/MdRESZy9sEe8OZ?=
 =?us-ascii?Q?MqoKMJd7CzmHSswc+vHre9Ag+2k8G6JwymIzo2t1Mbk0JEuRtI+KsuGsyjV/?=
 =?us-ascii?Q?KVKqh/kzp4uRGW1Aw1/vy0sX1LhGFSluzEMScgj24V/kA8FWDuqMJeDW/4VN?=
 =?us-ascii?Q?M6DtuoQ8bdDrEYNuedlTjZrqa37JwyB1rl3QSbElypXoOWwJNPHZaBTWO5UY?=
 =?us-ascii?Q?/7nn3Gcu+PC6jUEaUpP7BAOjLmqW2GYw7dQQOvw6nYMXI6cgqAbhR542bsKY?=
 =?us-ascii?Q?AWqet6R5UWGLNPfj/ueK4kcL2cP1TaSwNPkOatU88oIMzmiNJoDjDYTbJuC5?=
 =?us-ascii?Q?k6b4ik6dPxo653G0CjT2STFriTzQ/5o4dpeiSoNMjEF9R5bUB8YP6SAkDfal?=
 =?us-ascii?Q?qM/8fBRXiVL9vMxvRRucQDvpK+3WSPmx4owrba/pHyBr2ped+6Mob5fRawYe?=
 =?us-ascii?Q?Y6OsKs/2hxjjKMgJczJ80wecaAil/5bdq57old6ODS/PCCxZcprGM93XxavS?=
 =?us-ascii?Q?3R00H7XK4bbk43WkdRF+2Og9KxFjKZCuH04yk0FB2/7Hrv++Ti8A+9SUKPhU?=
 =?us-ascii?Q?gLugmATXBCdxOIpGaEKz+VuWUKgTjUHJX+WJCcKkRp5864tPXHIu2tpQLEtd?=
 =?us-ascii?Q?e4mfgHOezXgzrGym+EhesfPdy8eJ5DoQMrOEy7fc0cauVCfJczkGmjCcS0aP?=
 =?us-ascii?Q?4aZQJqhirV4LhRrHu2G9BjjPZyDv6uLi0gnVViKsjnyRvU4m4PebNyGdCLJg?=
 =?us-ascii?Q?BoZKs1QDkyrRr0usTxOgC/RtxcOv7IeR1aABrhiDO1Yu2J5zNZ8FdHNz9/tx?=
 =?us-ascii?Q?PpefN91B0eAcnWVY0ELHyiMx2JLvvczJr2bv00LhQAdhNN/o7qpjs8ieEcmh?=
 =?us-ascii?Q?U1dunhKXRsc1r+w5FpV4A7nCkL2szmNzdZK5BvlgIUfVDIaAYFa8QUgDLjy1?=
 =?us-ascii?Q?3iE6P0pQx+cQylttXrh11SsKezKlFpBw6QNED+FInziUsHrEwiYc7CkahpV3?=
 =?us-ascii?Q?hbH0hbKxPHm21abPFlukGbpHtkponuQoNcy/RcrLWZ469kS0e0TJrci0HySh?=
 =?us-ascii?Q?8n5kj0tVqrP4HLQsWeFWPaQn+0oKkp58vaINgD+m05An9pgoBS9sHt5Jsg9X?=
 =?us-ascii?Q?A2R5gWfors81eMz398dejDZxIS8ntWFIIHDKUcHhLR0g/q07uzn+VfvlKPM2?=
 =?us-ascii?Q?6RgEl5su1QNs2ULzOZk0rW75LpobZAg7o4p5fHOVVpb4YEpidEythnPyC/on?=
 =?us-ascii?Q?UwIz25JChFUNmSTyjvP7z/EFh6SFAUrfXQxRu5sFIs2ooGGIyPlg+T86AhGO?=
 =?us-ascii?Q?v3ffcrOMCOAvwYe4yww9F7NFyYuMBloNbsFaaoZQzqh7wVF0ROkt24jlua5h?=
 =?us-ascii?Q?ECcx2Xs6UoHBt/R+avpa3twq1TP9RQChAC1d5rNihhGedm0jl29DgL/7vBm8?=
 =?us-ascii?Q?alole/DJHWe8dZRYg0fBMfpxjMcpHl0=3D?=
X-Exchange-RoutingPolicyChecked:
	iXz2plrtuT2KFE3a0HKCDKsDNMpztfB637xW7zb7IgAPqy0TTNeyFkClou+BueVhyQy6yQ+DruR258lujEXzYQNqC5kcDtPIebi1dzYXpp/cBozYJcCEb6u33/kiqnwUCmM0QXGhyrpeCuMHYXsyCzkk+r2ACJfGAiYrvQJEMyNyEApMDQsjyM1Ds4Kxy2wNI5gneOEh7PeajOftZCZSisUBwbfe8CZxWCGqMlnyK1EoO6Oz57d2kMcU8U2QN58mZa1hm3QOo0Yt1BRpCqsUp8WkEIfxRIE9w/MTvhjlkKR45kpLtqmQwcPeOGLdai0wxstZWzOjc5Cjml2d7E1ozQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lXYPUcFpJPCoLshwGNYgFgLWeZp+lFno+E7TWuyOh/srxv4YjHSCGuc8aPYRVru0/iB05GrWA2flPzUFSj5a2ALVqAomngw2DzU218Uw9mWvh0Of5Hfi3wads14p+m17+NI68KnoGW1ACK8r1kOVm5FkDxRUPlQPz6CIfycj4Z/xfE07AgEDvI+at8Q+OZQvNyp4gkO4ze/kd48LByFl0rKGOOnD9l05AMAeVXJLgMeZcZNHj00muVxVY7jWS0KrYeOb8+x94BQJtZLHjDijSJZVR1+CPO2C77dcfK7sQa70WcSvt+QSZdWealt+WD43r9aDfk6M/mSR6miWYLgtvWOZJutwupCS6tPaB+JIv6yvjsyerDgu0Hyk0JX/BYdWtuPPnv5U4RkeRTkkOI11u2f4FMaM6evAwvH2CtFFJhF/TjNXZ0vtjGkU8mUmoazZ6hq+PL2GyvGGr2cygNhC0JBwYZcqjKcV6A4ijE0O8fHLZWUE/7lTY+Q7J87LaIT6Bcjvr4hxwGOK6+LvxApqidBu4CxHIsIGYR+POU1jeerRAobJxkS84KhItpCohEdUG0o/EUJmPWLrvO8afBLMBjpIyk1DFWHTi4+6KgES6L8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232108d4-3f73-484e-1c76-08df0ccdde1d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:44.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2wnkkVxinYAb+EYFslGQBXeqknXRddp0tg82cA1opt2xDt6walc1PMPggpjKuyNSPA5EgXRA5g5u9DirSpY6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=VpYTxe2n c=1 sm=1 tr=0 ts=6a9e9758 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=WlZ9DiTZ2y1qVm1cHVYA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-ORIG-GUID: 7J2pEAsSBeLPplKYQboaLF28FSJibrpM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX75wdYQgJjyFa
 rgZHY3kzz7PoMyWVnjTYesJFZvtIrtH+ofI8ZjZJ5TFeQOmVivRy8aa1TPvsFKocMk/GL2MLi+6
 CP0J7WUnOSDkStT1VrlzxT+DyiiJ3MmJ7pmQgsSStum/eLb0irr0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX/5g7FPrqp4cJ
 YyyuxmFhUKfXmD2LFdwV6NzCKJGhWn/drEXwER0z0cxPWH/T21JeZwTj4WNFEfWu8Jqy4f06+T1
 MNcvDjiiKPfMaYhrVmQI3o/jPkNk4umvxMLoecF7HevjGNkxUwBureuPyHqANV9msuIlgPj2Gyf
 NhbhFeOU1MDKpI9WPN40Y2yce28xST3pg31YIbnhFLOvkehfuCYsJwRa/ZctcaMqVg9zCiiMpH8
 FkoNm60JmlggENibM9lkrlm6p51ujUyZlgNVvQrbTCp5zIL1QYo/w4OTKGET4cxAMRb3YYRM+jp
 mPNpCZwG8+Rsefcl7YQVEDrPZ0vSJePg3EBalBGY2xYAViduFWkMB3aYC9UNRsKDhAVEyLpMw8+
 cijUiX7pUClu94ZxalLgjeH5vaHcdJIdu+wrjRA38lI/CMg+vLeJIVT9tgRNDK5P7m44gqWaRq5
 4yifzecpNEzQyz/9csEtqFHMUnQGPaYPlJCLAdig=
X-Proofpoint-GUID: 7J2pEAsSBeLPplKYQboaLF28FSJibrpM

From: John Garry <john.garry@linux.dev>

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  12 +++
 lib/multipath.c           | 154 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 374f0531f7e07..033ee8d54bbe9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -20,10 +20,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	atomic_t		*nr_active;
 	enum mpath_access_state access_state;
@@ -89,6 +92,15 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head);
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
diff --git a/lib/multipath.c b/lib/multipath.c
index 3b801c52e1a3b..f24086a6e3012 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -51,6 +51,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!disk || !nr_active)
+		return -EINVAL;
+
+	mpath_device->disk = disk;
+	mpath_device->numa_node = numa_node;
+	mpath_device->nr_active = nr_active;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	mpath_synchronize(mpath_device->mpath_head);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head)
+{
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -472,6 +553,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -488,6 +571,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
-- 
2.43.7

