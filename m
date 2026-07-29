Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E505473C9E;
	Wed, 29 Jul 2026 10:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322386; cv=fail; b=NDR26iQFLc8MptnpsH6D8rr3qdZDJdHhjUPhk75KaJzjjKHLVDrZD31p0vnd5FubUj6fQXaajjNtJ7neZJZiZH0HaznLyb4MQWFfv9pkEkVlIq9zS6lxgjf/iyGAM7GiUpXsC+DATe7z2Ew5KuG/774wXPiippC3cIfw3wEXghs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322386; c=relaxed/simple;
	bh=c0KjNn68NpgeDhd0dTZn4BexU28e28bKzf+hVvWjkck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gVHz7jYgo+n/iDJdDyxcKwuoJMBV7mbSajJo/BAHiKlEvt/RdeH4eqNbW8vNANWJ4MnWbQcYfJjxk0YvCuHQW0D1o0fD4HEdVk4M+F2qXVqqn+Yyh3bcToLA3lgnhGsv/ex7SrKtUi+aEUBVdUgVZ8j7dy88eGjfrSnZYITvl30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jvPS8Ktx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HkK7dOrf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jvPS8Ktx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HkK7dOrf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T8ookH1120918;
	Wed, 29 Jul 2026 10:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gQi+YvA2rJ05xevo5RmfOLjNrxjhnLXgnTWi3nEpm4I=; b=
	jvPS8KtxgL1JDrHCEaNhI4m6qH1r4N9PxM92eC2oh2C/IezrFIBghxli1vsgN1PY
	SZ/3sgch+lrFpiXUxsAmdt+iUXnQOhhJ9Wskq9wJk8hQD7hh0/m2E6Q8AsX4gT8X
	HMr/zipLBNidePn6AZH4N/Xj9Me3yE6b5mROCHJMpBHnM73ykDR1jPGxdjq3bHlm
	NWvJpGUDuSjraJGE1LGabEjshYlfkM6b0W7YlxEawraTnu/TxUq9meUk4lqdCizJ
	pEaRG6Vc44+zuTDvt0GFu7vstTSvrVgM2ZFgIObKaTrV92rwBMyKV/zVstRj9Slr
	Hl1AkXnVq2IERRmdGveGQQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnmhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAoYj1004983;
	Wed, 29 Jul 2026 10:52:23 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dt9m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tzs6amlDLqMzfWvEflfTp1y4XtsYtban4kVUXO7ZEu/ThqBSRwv04gr4wtha1uid+TmIo7CObWMOp8lqbFfpk98aE11eiWoK8/UrVoeT2oIkv2w1I5jT23Fe7GnVA1+miHSk9UiXUwN3XyHTJibJyQnxpc8GriaB0+cLAZXuMqmJO41uzFYsTSxD6X+CQ1n7/DVJ3wVFcU3PxEGMTyEbhWmvGnqEnkclsn28fQOlhil8W9mSNU5scuke642DQOlJIfLehccvpSvV/sUHN2qg/hTKcuzYAvaZHIhx8B5oAzmPViIYC09KaKcgPNDKQ3dOG5ZbJGh2+Z2yCAeSOEP+zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQi+YvA2rJ05xevo5RmfOLjNrxjhnLXgnTWi3nEpm4I=;
 b=tn+872I2QSlgkuv2/VYvH1xXAmuxfA2ZdRn5PTvbEGizNV+INXvetLG73Bksig1LUnB21IPEMhpOAt2zAOxCtceOf5jvupItCzSA3p1NOsfsrSOJ50zVCi217excnuMfmxZYLwWanUek6dAPoL77ic/SNvNmUFHPI05uQetBM00gaXGff0yU2p9idAeM64awFqKKHMcuBvk3YUBDh70sUPf0a8zVW6fjuigIU3M2A5VuFpqOdzzYid0RrW9slaCf4vWYs1WRoTYNJ14WKPvLdSpQlV7kLBf9SnCmW6GszPmgcTP1ZCj68F4dIwJBSFYYITW+P0FoiaF6vgWwIV26eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQi+YvA2rJ05xevo5RmfOLjNrxjhnLXgnTWi3nEpm4I=;
 b=HkK7dOrfY7UjACpyYyVmj/WsL+MN5gL9/HdPU7lpl/L1iBmdI+l36NL9cD6dynPiIRsMjFMSEvnhIlf1do+YQkkA6gOoKqVNKraZnkUINK1OEes8rOBH+WkRS38GQcwGEiLF+x8LQpE/9/vNcV6zPydDre3iyZ1NEjfvJaI3jPA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 22/27] scsi: sd: add multipath disk class
Date: Wed, 29 Jul 2026 10:51:02 +0000
Message-ID: <20260729105107.255712-23-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132F7.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::3c) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: e7a12703-b255-48b4-549d-08deed5f7600
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3HkVSVk3I1LXpVWeDRrTMoI2aTWr0IyRYRxvVWIpR2piUWpspKBtgkr/iHTm2tW4PmVIXYqiXLrEaOqGG/1sQHbFuNjTUCR0La7jeNXm1Gp2JB4vEOKknXi/Vge28CFqtApclw56UH+3+TDWlF0cxEzHVU+ygco3y5yCVZlwnTChIpqbwOmcbLZMmKGBOykghKZXy8mrJ5zDpCnMbcT+yzusPl2lqcPdqZJ3J8DxeZLsWiJLB3NKc43HHQOout7jB9QDixy/fV7BZhV686S1g00kutjzKhjNzOZYFXpUGrCg6Z1b3t84k3Eo/AA5ItBPuertW6Ui9s3H2awCfS8GwQS6X0He7p3g5+o3KQ8Yjuoz397j4U4Ts/T/dEpOIksT8MYOc/30JIVDUuH2ostWAVkBdLKSPq76S8zw/vQOqUkEugy5Ne5okOZ1gY+R7oMJcd/wu0ZddFToxzfouwOwtKU5SQ+KJNLyDz1t3kNPqiax3Y2/IMq/1Reh66K7ROMsMlsf9cB6zlA00d0/yH5wBweBhGcHxVqBlcvjutkJCjQMkReTaiYWZabrok7AgUD7RnlEN9RR1bQB6SL+bFJ3oWF/fIjnsxwoieCQrZrdVURWYebu7XrT9fP32Fz/Gun1TDXZg2SXTRYk3ahTRnvHsr3DzqxZUuxRNQFz9Lt/+aU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iZ1JuHtG7/8sKu71DQC/ZOcehWlyJPAm6aKJ0qZWF5oxlGR5ogmzbi5Cdlp8?=
 =?us-ascii?Q?Oe74Ng7sU9dE4jshA0ll5z0BsQ6hNXHzDTpiNbxp1g7d2pOIlrVAyT12BFLZ?=
 =?us-ascii?Q?1I2CsR5gkH0Rd6ZZ1zrYAbE98bQ3roIUZkMyLHJWEzwFPS7dwMk8x7h1o/O6?=
 =?us-ascii?Q?n5eJjCWcLFiJp2YkmL4SS4fVMrY8Y0uOu7bMfp2lMW+YAgQAJ1K2nmFC0Xej?=
 =?us-ascii?Q?39zZocSjC26ahGEtBe2rVKQkEoBWJxVvMEsr2/Zc+AbTGAfFVh2nGnkwVq09?=
 =?us-ascii?Q?RCV8r8IDfXnkPKGQvscm/UXUUWE4YPojc7FypLg3gPs0R7WQVXC3B2nDSano?=
 =?us-ascii?Q?l54dezZTHtvMCfR1+iXcmtiUzYnVd60MO9D55NOXjvQOm6WakdZbtfmKJFle?=
 =?us-ascii?Q?W3aHvlVz0WXS3cKFcBk+YC7zB9/B2JFs542hTnNolY6xxmwIGk61p9WHhvU5?=
 =?us-ascii?Q?AuyB1kKs+e/KxA2LCd4H1BY3iEEVGlfiBQz4Ptr3u+mDirVWrv8afVN8zAaj?=
 =?us-ascii?Q?If0TNZZ3JkFmZIY+RNfST7zwrOXw0CG2JnUDSUBJz7xXJing4iMG4MnyleXq?=
 =?us-ascii?Q?iQi5or0tlXOdreSUUY9XOEUO+QVYk0DRejhXHGhKaSO9aEzauUMlVrwnokVz?=
 =?us-ascii?Q?x5QpjRZSQFBYjMy0EvmQ190m/m6iX9X5AVPAJT2jV9Y09hiaDkFIJ6ZodA5D?=
 =?us-ascii?Q?O/2gAr/d8P95EkkQaNRM2AnNmA14o/dT5He0uuXtyu/+SBTcWGwXfJaEogec?=
 =?us-ascii?Q?v1B8IlfEG11pznA5If2OzqgkO3Zjc9RyWEv6qsMOlT84B/fuiQs8ijdH9+0b?=
 =?us-ascii?Q?kkJjYedQA/z3Lk06RJErJoa+YZUop8mQgXB6nec8XjCfQfUNNsCAAKD+sYka?=
 =?us-ascii?Q?MEMYPimsFfirx87Dsrec6U5dH6o2r+bAF7il16xsR9cIPHqDWCOG8nK9x8rd?=
 =?us-ascii?Q?V6n6nhOB+/pBzTnvTwqmNb6a1fuI+MFkgEECDguevhm6wPSyKoB91oALIm8U?=
 =?us-ascii?Q?GFfxxFziAaNZUvHzrEmJWCuNq2bJFbeDpiNnllXn5kwFtlc95n6NFOjYg5tL?=
 =?us-ascii?Q?8LTsQMLA2azK0Vcw7Mi7ihcCj001iLtzqFL/Gy5CTIi0t3hTzEfN/3vMu73h?=
 =?us-ascii?Q?5m9anEwj1UnF20fXROie9vi81l0GD6TWBCzSBylyf9cbvoqQ9qMDAYgkMG40?=
 =?us-ascii?Q?PaoC5PQQZGKG6WcE2IlkKIkP7VpEiutgcObrQ5Gv48nYKbBgYTdIQ6gnlQfg?=
 =?us-ascii?Q?boOU+RLPHH4cZ5MN4KKTxmlcTliWE2NXgZxs68opLG6NZXnT3JM4hUYViM85?=
 =?us-ascii?Q?FkphUt2sm6Y2VnVtJeLtTxh70W7ODB5yIPdI4/stO7oSfZczxLvsmR30bLHA?=
 =?us-ascii?Q?hsv1hEKHk9ptBjiR9PrYyZxRDCGY03uxWTgZlBAUvV3fLHXzha3mKK1lpT0+?=
 =?us-ascii?Q?rF4pxiukISbl43LE+oknbGW8o95hFh1ZsQZkjLeNVhxAEN24q7J7oLxb4TPf?=
 =?us-ascii?Q?yqL82W2wHudWOPMH7qUv0IUaCbvP+ZztSRFU0LejwEW96TNqSL5mhP2q17yJ?=
 =?us-ascii?Q?acXyvbrSYRg4fF1idfI0M1i492df0eP3xHdtfK6IV2+LXLDr8uNBlx+YFiMA?=
 =?us-ascii?Q?9CK2IwUEkOa3HP2+nJjCe6EZLsghEZd5eR03vnE6yibd5dntCIjyaxa0ueJv?=
 =?us-ascii?Q?IE7sn6klieY4u4vFrqcAI8T0sO46bcOBOXLGRfGHcd0N8zA+QOzZRgJWAxOq?=
 =?us-ascii?Q?Huh3zyWrlw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	O3Clau+/+zW31PbuF0KLBY5ur+7QUD0QdFBSsdZBtP0eyzlB7p1+0QXBqSls1D2BLRfFsdEXQkU3ApmcdQtT/mI6GkuO+sZMPP4t0AAaAT6AA7vcGTn+BQ7DWTAdU/ZanlSB1EAZ+P232ClaK+4TAUlE92Rd52xYJ2fLmRE4Gy0g5gy0jmQXDpcI8MUGfi0kCym3IPxfxVeHQ75Ktqd5dAuyIa3ncyFsv5Lg0ZW1D0di/aJ2WyaoDUxOVVWopeNqqazJ7lTPISg4sqIKvML0refUPDYU0U9iCQuu0fm4rYoNQuwrVVZCJ+VwCayIQ0r5b9YpBtZmM7XmRLEIkIETIg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AJwVsamuBuw41baLIVTHmXoxnYPSgWsLYPZlMEaTCkgxrnxuwg5yIR/1sJl8OMB5yT22oUlk29tpTS4K9JDQruapt4FbrOAGFPW0uoKH6iTnDSK4OKlnrSLZO7xX0goG6UZYPYQL/WuvGluC5s+Tbv+3luZN/oiaTsspfSo+e3gL8E1Nib7mGAurzj127SK6GLsNj7HNJ1L60yZA6VEdmtV07wzc9XMChdIdI2tpAw8HMJAuldLAhxJi/18AZZUCyWwOqB2oRqN/j3+C/aaQej4pvVO1XlnjMn52VRJUBk0QZ5S19yGFtfFIYR5jqPvDbpUXbyEyCFduvUMcoPGXW5j5nNClVdCFOoJUqHE6ZH6tMezqmbMguuuiVrJP1Ebzh/aiPv1aDS0tRZR1MPb2yHJEKl2f/77sOrJrmnLysXJSVtzWy6M4s012krnLKb84+8qpA8zs1rNH0+Dn/7OKClg7xDbyHsWiHB2wdMHsw+PDTl0dayY9OlHPtau+HEDScxDsPe0LsVcVgIJ9JzhnweTeGsqIwKNkCynoiQnENsnULZqjeE64Eb7NC2LEKowI3a7IttuTL04q27/uW3fgeI/UGaZPqiRrTnori7kgr34=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a12703-b255-48b4-549d-08deed5f7600
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:19.4022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6qPtYhhWHiCUJIyzO8hp1wxS7Gl780ilvJh6D1h7s2CrzHyreQjZS8E+yciXK0BWM1UPJQfGn0X1kGCeKM+iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69db68 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=ecQ7zCoEdOpy3JLqRw8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: GNCFpH-e7Jxu9E7lFbmCOAAduZ841NAS
X-Proofpoint-GUID: GNCFpH-e7Jxu9E7lFbmCOAAduZ841NAS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX9KUKf3ja/Rhj
 2gFsrxESul+h6joLhavf/xIX6i4Bdy5mQ5+DW3f8Wc3KX9ABqBxSeaPP5ToIeC75FUZWEiRmBn5
 HWdFQF2kBWmsJ3lmaJdZeflqIJdibsq3ZA3oL7RK+spDG+rQhBFk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX7UjfJWxKGqRK
 8ib46y9yi7zq5oK2CrGRMJHBpXjFc8N9CmMxDrkJ6GS3rxqhg+TINvzF2hNdN06j62TwsbwBCyk
 ScxZVaoAZTsZRTCyEIVORRhXek2VXl//Pnl7PUdp2HVDos63O4EVOw3+bUKOigfNTpkw3nTs52v
 l+yqsio+lh9il8A7DPIzLTksz6EzWQfWxi9f1sGvTq2yQ+2WHxN8Kiz7hWa3XrVxlYOV6beNT0M
 MgkrW/tiUevdcXkzv0FD8D8+LziRnie70xmI5TI1nZ/no8a8BhrsqcpwNjhkLBv2PO2CjDhpyVd
 FSzORpTI3R05w5ytoCPChLtRFKv/1tP9hL9W2oqNEoYhSIMcrF+iBZOYFgbkL1Vk5cbdW1THaXK
 T3VziU58uRM2n2pE2/D/HcIr+DF/c+/TZSgnDhbjHqFy3BXFvSL9orZHKwQj/6bNinXnRgBxpw5
 2d28FU3iPr0ivfVYIaAEKmPprKDnD68eOV3umh9M=

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..242a15bc2c5bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4453,11 +4487,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4468,6 +4506,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4493,6 +4533,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..22438173ea2f8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.7

