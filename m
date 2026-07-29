Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800CB3B0ADF;
	Wed, 29 Jul 2026 10:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322379; cv=fail; b=ZG2XPnh3thjb9fa4mK4KpqUovEDgFnkMqW/rG5sc5tnGBIEB1FoHZcnszLBsYc74yM4foA7N4Xd73HQfFANITpZ9cOP8ZZ3iRw9oYgDkJB35qFbGSJj35PS79HEFy/mZVVtHn3PHw+6uppm502HVeYbpe2lK3atL47TQSJuoHjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322379; c=relaxed/simple;
	bh=vFs0T8qy8OIddi/4SCpYdVdQTBfxNyBLljixXBr3CaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OWsqPq4wC7abeK1d1Uk7ODQ4Oj1qSXNj4w8wnHEEdM4hs439lo8zqHf6bReXfuXO5Qi1E09v08K+MaSwtojxrrEE9DZntZ3EhqlE5KT8F4tKW48GzVALdn3wSxNEwfbGUGK/cmK9NPeNbnPesoEBVm+ISVv7fvixPhEUIiRyaVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lAXnwFan; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IaxJc/P9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lAXnwFan";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IaxJc/P9"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9Gt7P1094297;
	Wed, 29 Jul 2026 10:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4XBf0FMbM2K3b63C7DHV4UvO2CpyAVKHudywOXFApAQ=; b=
	lAXnwFangATgdt9ifTvmmOtMFj9FjPwYRelV7D3QoaHTY0NBabOXdvolBtImAYQv
	Vsy8spNcmePjWFrUFnFpuN3x7rHE5vWbwdyHJ2+7W3NkwKeVM2i9+I/kw7h7gWEJ
	TxWGLgWoa4aD8UDX8f5gJcEECWblHVcvrPxYqRjhQCyUBvwwspQIwBRkQKcX6omk
	WXORqUPfiYpb97fssuweVpjnNOQAMzK2mhjy1ALetKJYm8WWK4Eka9UMaRYmYqVj
	tJoteisi5L3LZaYv72+uS+h+L5Tlo4BB5vyee9QRz3n4dNy6gBDdbHUeVPAkvL/4
	j8yFcD+OrDjQvPpavhMh3w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo6SC029959;
	Wed, 29 Jul 2026 10:52:18 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh882kkh-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMggnLiUXSqBYjMuMp3Pua6sbwCDTEo3IbSWf2ErEGFvvbPM4jl4pUWsPczoiQWPQA8pgPwsRnF2E5VfBRsKtf8tJbaPKXUIHK0vhg8WD+/YIfBrCAyalJqb5bwxtUGs6mc4dPh7MFONTcbDaGmXWwUZAamd3KU1hOuuMCqbrP7hCKh0Xqvu0PWlx93l9uorjN9EnY4AtPANLn87JFjWUpKjrW2wBYYsgoz1LGahnrq+luY9qVId0rbwOZK5MXyZhzai2pC7HBEV1bbJnr466ZQEmdFAQ3u8JZJi4IAxbIaQ4BYyH/QqFKfqpA/hvF4o7A89cVb7fsQZjnZwj9wFFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XBf0FMbM2K3b63C7DHV4UvO2CpyAVKHudywOXFApAQ=;
 b=opng4sdvH6lmY93zOedFazU3h8Yl+NPIbiuBj/e71tpLep4KqQ1ggUTQ3E7Z+BYy6yveWcBxPPKxjIRrVKL5SdJix/1TDlK3VjJjRlR09NhCFk/RWvj5Jp1NknxUNJ/vwsxilq5oJHVPIdoUOOL+uvBUx6iJ/DJTiskOKXU1ikhINLOeQXTsJ0r87O7lM7CJfxsnelweXaT90CTHkzNeMmjZtbOy8i5ddmrAL5yc/x48F39xzA7ObfudK3BXJ8yKsJsNTA90Wt+M414EdvM/7Is6LF20WzGU1CjyCQxsL5VHc7Ku1Izaj4TjFcasR7/C+XeP/lKhUy6veqQyzk+G8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XBf0FMbM2K3b63C7DHV4UvO2CpyAVKHudywOXFApAQ=;
 b=IaxJc/P9f/ot7jTbY8gGEn7dcxLOsDpSbCgenpEyZlovjf6hkEbhXN2D9SSBhvocm2EmQbMUkSRdvOg2kuyj0smps9bDxqr6S2e8ucbbMFsWNjpHbtS/nAwI1NDfRNhYIyXiTHxvm2BNIOLvLpqjhVK5usVkN0CvEkC3V7lrR7A=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:15 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 20/27] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Wed, 29 Jul 2026 10:51:00 +0000
Message-ID: <20260729105107.255712-21-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0151.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4bdd54-bf08-4573-4b5b-08deed5f735e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10063799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hcPq6kgEYn0ubkZNKOIxxS8ThXSkQTWsVuVBZiUab+BsgtyM31gapTcNrGBsyn75AdZTQsFKU2KJSz0R9152/4r8L9Ugl+RIw3Zgj4OrjpzipyihbsL9egV9lzWWWnFtnxFCCHDeFXdZzLo+LrOhtI5c4DRsCzhZ/FdkaCosPaRQxPPPI3gupE5/VXV+RW31qYTT3oj9vBKZJlRbdoNyEYaCoLLGxQYiPY+wSzlNGuEFvYCiKXCaefC7rGVOmFDn4d+GVnquytsgYVo9MUTG3M0ePMXm2Sqk6Nz0i+t26vfj79SmdzOpqPpcjBOje0uetmK+oT9IzLS5cZbxnH1ZOP17nnv9H+UniTbJbrKgCD54OMVbARvaLr3QnV9R4L3/1PL0Y4suZ/tPmkvskd3Vujttpt8UIEuoiKBmgLypccpqjvGJZMA5gRhb05cCmcGGKJCIROMoS232/ONFqta7TtFUIhpMWNIEFfTUv7W5xexH5EigvKWx3+ciEfCxaYNuX+KWUFYqZE+Fxf6XmysY+UwAnS0QWh2ZN1fFbD+0okICNsn7vcNJIJIYP5P2lr1jmpc3mHH91wSPuW4QyE/s+xZEBkOzDnGPy3xkOioOMiUwvVQmBGNk4hPOUMO9lh+iD1OPmwVCa0eChZ7b5a/kdG2RT22FCrP/wqU2IOO7jRE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10063799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bCcc3lvsqMv+umB1sD6NKw32Jx9HikDd5CaHQtx/IX/uX9zeCx1cTMKcpwGT?=
 =?us-ascii?Q?3zynIWJHyQFeTV4TcdXooeNZ3onC7JM6RB8BNEA6aL7bg2VTwNY2SeH2GZjd?=
 =?us-ascii?Q?LNUIsxaJ6ZQV20/IQPue6o7xU1uA6Aiy/PYvyy+VCNlYxtwzGc+rclgI76Fh?=
 =?us-ascii?Q?AZxA88sa4l9DuUUMdW4zuW8bUh41eHK6AyWjnW4pqPF+vyhz1jS23Lg1bhwL?=
 =?us-ascii?Q?R5LxumLoKfeMd1aDrqRhXnzinfVvo3kNp6KLH6lffYBskK0uFGVxwt/orJS7?=
 =?us-ascii?Q?Dyu5LifdRhqoVPaRGX4E7nJocUtjtbcPtP4/MIJ/MD04bItZ7U561nk2SdSr?=
 =?us-ascii?Q?Tb+PEC9EV8xKYlfodCVtPxT7J9hF5uYmeJmyWk3m1Dg6jX97bwUE1a9kkQFb?=
 =?us-ascii?Q?93Evdk89lwHkMO0v6s6zsgPiSVr/3qqjLmyJ2bRFx0Whe0F253R6tK7fTxST?=
 =?us-ascii?Q?zbqzmDn48Eleqw4L7HskFD/6kIy1QgWZzhOaMp1U01Zd55uYcGUVEcUdjcKH?=
 =?us-ascii?Q?F3E+3YfjAYHXQqzDSI6HkXV/aUXjUogjP34xhaCH9GlTHUeZj5A/Q9bUxxeT?=
 =?us-ascii?Q?sTRzXXy+47RL2TqTDaxqxk2G/72S/IrnwKkG8SSRMW31nm9iSvvSQla6CJ4e?=
 =?us-ascii?Q?MVgHJpZMItCyv2XD+TkAzMDOZa99X4jegA+EOQqVn9swLYHZKWSaU6UtRfJp?=
 =?us-ascii?Q?oU2d88siCBZun+Dh76Wit/E5xq4iZeO8hwjcMhpLsS+pU4nGYtK413oMREnJ?=
 =?us-ascii?Q?INQZTiEGErbOXxfx5PNQKsN2TIckYK8Jx3woVZjLfeEgmR0bkanwMARTrDz0?=
 =?us-ascii?Q?0Onwgz4ruAb67x7fTtQyaySnd6rib5UAE/c88uxoIeI35jiyvx5NkczFmTJz?=
 =?us-ascii?Q?w8ztIesuqpQVy484ABka7FZ2TQ8VBgK3D+Kw/YEFhyRLYW05f/va/+QzpbRo?=
 =?us-ascii?Q?Aiv1939HQxDM1MXbH3cnl943IUGXBFz5D5buZNMkC3XcGFhH9sPh9cndBjDG?=
 =?us-ascii?Q?OGwFRSsW3ZYaRMMSBKCievek5kmjyP02XHBId4ijPDotLadOe9JpMtEEyA2s?=
 =?us-ascii?Q?aYJ5zLdKMEe5X/Sm8fvRRfH6pTx7LTr3kaXP/ZhjCnmZO2kmHMdbFe/XHWht?=
 =?us-ascii?Q?svYyuJjdEPdFxlTprzRw6I7RxA+jBuoURKG68WWApqkk857e7O91uydvdAAj?=
 =?us-ascii?Q?GI8WiYWZYCtrH7pcoUvyXjJ8fMkqCVdA9x2bdcSxog2Xec++VDLQ54XgYGZi?=
 =?us-ascii?Q?YK4f31PRm17lMHujaEUV9MXF0PcKSJxmBiEXcsA0PZ9xkBTZXCELodMdCp+Y?=
 =?us-ascii?Q?Z+dx6BpNc9MFPW3x+F71d+avMh+7Dz9RF6FP9Icc31tE1yqgZooASzn36tOV?=
 =?us-ascii?Q?E0sNCTSnn5yHS5Z84J0KZOtd9fkNP8kn3Koh0Xkp88E65LO54IS0ySDgobce?=
 =?us-ascii?Q?S9+JhBARfW7mn0JdvLdBpoeygJnfGkaf/EyyXRiZEe0zX67BAxiJioPxQxq/?=
 =?us-ascii?Q?rEZPDr5UPnf+8Y+bTLWsS2+S4eMKafa5q6UrkfuhD7LkKIU4Pe+x1TGPUPtv?=
 =?us-ascii?Q?Pe75Ld3JgdQXkGCMQk1qhhXdhJcL2XgOZl3dDS7VrSkR2p1b5uq3aH4fjywq?=
 =?us-ascii?Q?620IYXpzkGfPA5XI/weEZGq5FjznUXMmeqg8Ps1ptSBrz5BHvOCnfDauzyUT?=
 =?us-ascii?Q?/xkU8PJkbM4P5GNrlPXaaV3qCXnEf0E4yoldHyJiuZZyNgxiY3A13J/MomRy?=
 =?us-ascii?Q?wd4mqKuUlQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Dt70ZwcI5vQGmmrFZpUtMqMXhjWyKA56vylYhUOiBpuuZbX28rL83S9IHeaFxw7SYKms1U2EDiBEpmmIyWK3aLIcn0Oi0/LR4YSr410zxKyJ0aW6wlsbwCEUk2PheO35j88s25dJsCVpnl49+/DshExgH1JFIOEk6WxE2qEnIhZX8bp9op/J6SPT06ce/9sOcAKKxy0ZuT9VUhWxTcurvcEdd8jcRZ95irvxm2i/w3SBTP+PSrks+UeIuJjUF9YH7ie5UqVJqCZ0GmENbcOw/sJaPnJTrbe7H8STFM0w3weLd7mF7iufheMjBPQr65YNuX7qTqcJXSnhyXHerx/cZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vq8f8ylZAAd2V1EKaj11ySVNyLW8QFDf1uLM0qfoKMj9ata2UhHOieQIo+rJqopXzoW261Isw3ogp1q+SrM2DkrixaIv5/ID6MdaEKZRUIxDplpV3UTCZsD6DWe3FiS4rNulxCKsgaARGPIOpz3wrkTQtMvNEpj2MaMRiu3oT5T/WPkpoc9wjVNgJ621kHQ1aotNfpAEzImnZDPyfzyDwuTcu+usdva103UnZrs803MKlb42jL0PyXWIVP4S7iODoMhcilkdLuhIvZUto9O46O1X+ZWALHXzIQYipHATddq4Z49z/jFIkKXNK679aeS3tiN2d9Wa4+tk8KWjiNUmStrK5bimDnGZXymObM6FrbEtVU1hWTfudgY5IbSTbChWbnBbDh1GPpIF9saRxouAGRn5gjinQrG2VHntzIlzuqj6uDxIfdKDdWojcKuDgXAtE4G92D+rrlRUODQOgkNApVyurlop3E/I/bAjTYUcqlZ3SQ2imfiiXyX78s6IfdKlP05qcO8r4JCHJ+UfeJU/00QU83RBClpH8l4Pk3RhR0qVfZl28H7xm71aML4V7+YNdYoGQXdsnPdQ220iYyfOTCmVLwa/7l8YJlnP5TMof1M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4bdd54-bf08-4573-4b5b-08deed5f735e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:15.1284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVLKSM4LLB2H0KQQK7z/Qj7mGeDfEJcPkgTnO4hM0AAAqLOjui40rYdGrKybZQKVBU1KggDc1vrOkYGwSf43vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX8UJm4ZA5tZFX
 X0tYgeNJbgm+uXmqTtX6/leOnCyqOvmB9LjMKZNaCd2EPH9vFazua+azxQHvJ3zsOihI2hhbYUJ
 XfLmhOWOOon9BtNpPB50UL6ukahbIZhFg/U3i3pZs9fQnllGs6XE
X-Proofpoint-ORIG-GUID: uBaQM4NG1BZegCcBgNXMNMLVATTl5k6k
X-Proofpoint-GUID: uBaQM4NG1BZegCcBgNXMNMLVATTl5k6k
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db63 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=e6BYPIScm8OiYhIHgSgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX/vwHtW0Jj6qS
 fVm8xx8GfxBnVz4XoFzUN/hMxvsda9wABwTIRNGpY6PXk+9aj7W/c/5CJ9wzTrK4t0YbBsVat/W
 L+dKb+iQl/VQQj4QJQ8RyVzlPup/GVZiZO0zI3vvoTg3XVb0SqBlaGL24cE0tQ0T936VyRVvbAL
 hwVaM3akzOE/d1hS+JeoO/vu/1me3gmUcHNpfOAQhaoTAUUE4YXXReQ1tqyjHmucKENiVUQj4Ko
 PrTezYLvisNE+PktZXxCCf35engIrCKdZHpLQvyJ9VUg80w1saOGpmJhwAbDsfHHmqxqK+N0MuO
 5yfvh2E7WYmW7Ci81kf1lIJxIbU/1HyYmL3Wh9NUfUnuWHsuT5EW0Tn5K5Tyn27LLZm38VtK/qj
 CW27mL63FnzWbIW9K16WS69emRZLm7Q4dgrtYRD7Xxu4BblacQtJvIWpWr1D67WV4KcW0XEacUf
 j4TJSDJRQO/kbrIypFw==

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  8 +++-
 drivers/scsi/scsi_multipath.c | 69 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  9 ++++-
 include/scsi/scsi_host.h      |  4 ++
 include/scsi/scsi_multipath.h | 11 ++++++
 5 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41d201b7e7def..baafca4eea866 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	if (blk_update_request(req, error, bytes))
+	if (sdev->scsi_mpath_dev && is_mpath_request(req)) {
+		if (scsi_mpath_end_request(req, error, bytes))
+			return true;
+	} else if (blk_update_request(req, error, bytes))
 		return true;
 
 	if (q->limits.features & BLK_FEAT_ADD_RANDOM)
@@ -1917,6 +1920,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (sdev->scsi_mpath_dev && is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 2a05f177a1dcd..0adc5adb4b234 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -562,6 +562,75 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct bio *clone = req->bio, *master;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (blk_rq_is_passthrough(req) || !blk_queue_io_stat(disk->queue))
+		return;
+
+	if (!clone) {
+		scmd->flags &= ~SCMD_MPATH_IO_STATS;
+		return;
+	}
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS)
+		return;
+
+	master = clone->bi_private;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
+				jiffies);
+	scmd->start_bytes = blk_rq_bytes(req);
+}
+
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+				unsigned int nr_bytes)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct block_device *bi_bdev = NULL;
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS) {
+		struct bio *clone = req->bio, *master = clone->bi_private;
+
+		bi_bdev = master->bi_bdev;
+	}
+
+	if (blk_update_request(req, error, nr_bytes))
+		return true;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return false;
+	bdev_end_io_acct(bi_bdev, req_op(req),
+			 scmd->start_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+
+	return false;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..52227e2cd9749 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | \
+				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +142,10 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	unsigned int		start_bytes;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4b..cf4fff3ea1a8e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -753,6 +753,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index cc77e63c43da3..c3398e9f03f16 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -56,6 +56,9 @@ int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_start_request(struct request *req);
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -98,6 +101,14 @@ static inline
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes)
+{
+	return false;
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

