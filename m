Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775C041D110;
	Mon, 27 Jul 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163433; cv=fail; b=R6Tef8xcj/jyXmhP2wjgy5tb5FtfabgF2d/vPR9hbQ/ADIUCLU/K+7hBIpXsXAwJqa6Meb6EhU4uqSXfOhQ+32GO98I+bqKGsmFGTMiR1WWZx+pIVlneFZY6dqjPmqm/LVEpkA+m1+zX06DC2RTJKx6rELUtDWcUNefa3NtClq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163433; c=relaxed/simple;
	bh=alyAfTkTr0YY7EPCubJ+jVll2CZ3JFD3DqxtwxoKEEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JWZxwo1GrSXPatI/HNcp6kCZSN5PnjDbaBOTVbwND0yBDk4zUrnDb8j0QHBMJgozPgUl1EE1kp4/sfEAGACDdiTUqS75TddxwRm9TLmvpJEe8Hrs5aeVKeLDL357s32PRFTtJyj3dJk6c15cn3N8xKSo9F6ETXVAtphwadWterM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lIwC6s+G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cE9yv5yf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lIwC6s+G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cE9yv5yf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTI722051247;
	Mon, 27 Jul 2026 14:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kqQTausAq+86R+cyZwa0DznNV2Qe2fGcymZ16+q56lc=; b=
	lIwC6s+GbDlbLX4OvMiv3OEMdQCGUWTUvRK2Gl9BZXSWsGNjV7ogz4DpT90rTiP9
	knCwrZLjrBw5sYHY/MBATIgatVF83cNpkysGWyjeUZTtVcsb4uQDhcCP8SHP2cs0
	BdRA9+2qyG0F9H2lxucgubnJmB35CnZnCP8cDybgjm3RqPqcfdhg6+16ZnaqRxrS
	i/Uma+KcfCuqGIpJEIC66rWQkykFGEIt61EyOhRq3C9dQakbfAhlbM0HqnHfAFw4
	j8dLmAKp9203INS25MqMZ9ZN2d9+mUVtjPwOKYs52OK81dqSF0fZLv4QIH9itL75
	A8C3Pxg014HMgUV+KSI0qg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1d9xj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REZljP023870;
	Mon, 27 Jul 2026 14:43:10 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ngvbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjADfDKT7HcKf+Xmvv3+uz8ffJXOV0bx5865QmyBWXnMCwCmK24BrU9G6s11lAsH2/7d/AGlpMm/Ey/k9/UmDkA0+QBMoP92d5UnRz+6zV9c1tAUXQ0TgNMO+SmmJBWUHGPlurf0cG6zn0r7pfFUqXgTlwhdCfEPIIped1V6FfSdZK7yqloRN0y75gGbTAGvTv/EPsXve67LxN1mUgI5ZFgdg8RCNQlH2mCWuqWjhEw01kzgWnIoyXwnE6+lmKmdRJZMNZBWH/pZtEghQ0EfxUPQn63I1CFE6A/kk9xyk8dgD0bMSNOpYQv1JxfivGPcBwio9p3Wu6MbLzr5DsNVhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqQTausAq+86R+cyZwa0DznNV2Qe2fGcymZ16+q56lc=;
 b=KLe0U95+Fv8s4K/JgjqQ027vRAcKdPRsLYPgws4x+4UPcGuPvIpH8/aJM3FVm0FbGq2sKRxhIOmFOJvx/3p9Gunbzye7dleHweLT8s+5dpj6ApuespWyxtLTjjPWLR4RIJjnk0d/Usgu8qhT/2fzZYSWoIWJ/VPllg/K4PF4aXz4Q2zren6uBwlwwgLs3/Kwp/gNHzxS4Y+fXgxA+zZFXFMy69fIGK60IuUOJVe4lbR8vsGCH0j6rlxySz1OIQrdFTBXdHeMnB2WdpNERkVCejAZsbxp1aYm/PCLvFmN/jKZ1LQRhZwc3t3TvvvaqGqifFE3C8JK/oI0UZBSqAdV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqQTausAq+86R+cyZwa0DznNV2Qe2fGcymZ16+q56lc=;
 b=cE9yv5yffKVA/uG+heqUX0hKQOpBXbeNa1xUesMv+A+hqXZ/9JQ6SFyHjyzqDtJyROWI0CHjNxkcOgP2FTWCf7goYDzjufrOBnNawDm6oAwkPBaZOZPWYHbH1LyNTNG56IQhgIQ7KTZrcgr//iuBR3QvwICeCLGAHjb6batjKhc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 08/27] libmultipath: Add support for block device IOCTL
Date: Mon, 27 Jul 2026 14:42:15 +0000
Message-ID: <20260727144234.3802948-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:610:b1::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 96f884eb-274a-481d-5019-08deebed5f0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|5023799004|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DXZuPWVGQIEgqwd3Uu6ln8DgJCXqdpBLN+TO/Rh6tqh2OGPzr9bX0hqjWYC3iyfeg6uoxnpNc0KNajBmsDR0ffUR5LV/M6XZj2HBghAY3peawaBdAgUdV7+lRduL7t+zF5Gm34nZGiKIFBDkKz77ZxMFquFxNYRywhXbWmHZ//vWl3SfvhnXi+2k40G5R9/8QexhbcGYrVwCC8b1k1VZGLnqdhPoJl9SL3gS2JC4L7FJFeqAvK5OQKznvBqL+HefKZugaR6L+yKUWng/+e+/DZujUBo4zALC9DUwD4m6tfZ3tfv5u3WGNHuXY05OL1JRfZeFUt7LpcUKRRomqf8KAF1ryoIvg6sM797ofHO3rKN3k6PNDnVu6UmEPz4+2veoI61r4mVM0M9b2dXXQm5sM1R/IOVPXMS4248IVm2+U3Sg4zhjdQLkqwpLQTWC1ZULbCii/BOuCB5gL+p9xm6wTsYQH6IfqLBCFiHZTDL+s0T5Ar2MaqlfVGo7JfPOQ+oM5GugAYwfCUfm4KRT0fBwYyC+IrOpvsdLXjuOk+vLlgKX/4kL0o4no29k5sIqhKCdmN0dRZ+psqjdMhlrMQHFj1yUaxe3dOte4LbvBckOy5Oh2ncsN3S+II7bTDN1W6o/wqbrDItXcvz2bcOgQJRl9kX6rcnlboPZdaLP/zL5XiI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(5023799004)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O7izl1kMpaGBQpOXVQC0tlICXQwnKJya9T19biJDNOMpTRo7u6Ezz3wAI4bE?=
 =?us-ascii?Q?fKrDRbl7ZmP+S4asF4JmUBTXi3P7VCc3N89YD+7NzuSQ2QeV2quF5pYprpDl?=
 =?us-ascii?Q?OklxAqgEemNtPg/pCm7XXqKF52ZzNX7mtBik95UGHZ3ooU95jHBP/qLk1ojv?=
 =?us-ascii?Q?BHK2UyCFqkprGz0byqPuAJKXRogvTIU/OHfagwlfpK6ytS7mMdtf9LBK1QHG?=
 =?us-ascii?Q?23afp7JCRle9pj7mfnvaI0oODSZfaFR6PbIE894Ffz5AUWJMlAyT+hEtYBHp?=
 =?us-ascii?Q?Hkvr322NrQSWPLEWS+GqxdLlX8erkCAofgsmNKEP1+XBtK8pUcxTsKBSYk6L?=
 =?us-ascii?Q?yg1lE58X/ueEydV9u0KBlswlcooJ4Dcza5DpTKE+SKbvFni5MqYPJjb3ZmLC?=
 =?us-ascii?Q?9ReqoBgDvilLmalIYLp5fjMfhL7x4BHW7NJyfJeMXvKvaAyk9EltGF2QJMdJ?=
 =?us-ascii?Q?Fj9fJxNcl75iDEVE4eArRgul6zgknKpluXkkyHTYPqE6nhYoOu7zSa8UqU+4?=
 =?us-ascii?Q?y0HGGCHe7Ydfy4tuVWkq2Y9lcshHHOLkhdLlWW8RKKbSoLrOEGfU2RbauNhH?=
 =?us-ascii?Q?3p/XCfa3KzW3i9nk0bJX7fdt2wZT/9ccRY9SzcvQnLM1EW91rTbTJajYzr1M?=
 =?us-ascii?Q?PKa+Rfnz1liLCIWwBeLXJF4E7o2MZ4qloebDjZI3ibHMa7OksdCnd1s3KQUu?=
 =?us-ascii?Q?H98gfEdOnzi0ny21TFG8pQlnYUw0ixgCWfitQG5uagNMkze5bvmwy5aYrWNT?=
 =?us-ascii?Q?IEgYhmlB6oeSGoYxwRoeCicfwIuOFFGy27f/nN8+KAM+g/xLZ+sDGvSq+MhX?=
 =?us-ascii?Q?Vrpd5WfthZeAX1yalOFPMwYogLxES0tGLMKLSMTjfuI+8XL1NSuwX2D5IPqq?=
 =?us-ascii?Q?gA32geGFd5eT4+B7T8biKH8StWgoMEl5SnI18idjwMyenM2BoPTmOJuFmGij?=
 =?us-ascii?Q?9x3wJStq19zYIDszG5J2KJecV/P/6fDL7bdIQIpnzAYcwKrpDcnd/xRWNU8R?=
 =?us-ascii?Q?tNpHP3oqZrLIWDjb8bqZg5eYGWI9LdMwhMHSaRdAMdyzGxlqtkiszGGtdqCn?=
 =?us-ascii?Q?NREFsZG+Q+SF/eX2TPZO1ptW9Z1CqlfnqqYA+ZkRbEeKA/Vwfv+jYAKW6jzf?=
 =?us-ascii?Q?um+r8myj+90nsN9fisj2z3JBNpX4WoG1tk0BeVvl6+GxAMiQsRxq3G7DQpqp?=
 =?us-ascii?Q?px5Sp+RgOHe1CFxWLxQFMhcmr1VfcLQjahFiE8TxpVnDnkHeu/bV1Gccyist?=
 =?us-ascii?Q?YOl1hZUdQ9akzA+9QffJ2kwcHKVlEiIir7h2q6E+Qu9dHu43tHDFQ5VpLizx?=
 =?us-ascii?Q?/HBMXmP+82qYR72Vo4yZ+UINMO2YZvznV3yEDCxNEOUeFryIw71qLFOcRDH/?=
 =?us-ascii?Q?PonhfRNaab583TY4A0UZX4Qp3Uyne8BNqrrEM7jmc5lqmEvXQkkOU48bQtBt?=
 =?us-ascii?Q?dVUgdTnuMC2IBgzju4vml7EIfplXfzhimUzdXXwNKDRWP9ND2FxAK/d9ehsH?=
 =?us-ascii?Q?bGZG3TUyc9fDLltjVTrXODyhApER9ti4PnP4gyjTI9ARGDDwkFk8IUhpel58?=
 =?us-ascii?Q?GD7acPdv9UaSR0ShkGhOymwMy3odX5+SNTTUYS3ebZzq0TjHXztSDkJpyL6G?=
 =?us-ascii?Q?yd/0Na/ayGfob8k1EedslmZ1rBYCXrrNmXN5SZzz8tTQx4h6Vi1tToDduDpS?=
 =?us-ascii?Q?fEify0GNM6uYkW5EOvokzeDKC34BvVlF95+Ptrfv9dT+x1TjzjSXQ8OT7/Sh?=
 =?us-ascii?Q?DpTRW5CDE5e+q9U/+/58zULqOq0mkEQ=3D?=
X-Exchange-RoutingPolicyChecked:
	ht8lOicZZj9fCAZ2Rx1BOk+OYgiHZKgjMnbP8wNs3/2akSfmlpfEin0NdkWJ6lFZHhOaWSMfH7cKMXzfPZ80k70L1Mc21I9kii/9fDTyw3dG7LLmOzQRfU+tA3pS3VXn8dIJZZCZwxVXLgsnX+2MuwTn3eCxfd1cd+c4bH0dH7CpQ02/VO34sDTJUgFOPuCzWY4giZ0TxlRSAKOiFNTyKAQNlg2kU3zJxbO7kLPgBbxK59FAMrJWpSaF4975afQQpQtv99fLgurH3HsK66NhkqDtmgkUztvtK3s0eKdK/Kw9wO6hmTyc4R31DmtCNfy3RP151oh9enxyWld79A3zwg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ego6xe7y5FiJGc1pjAjJ1UhZXitdZoGb8iwFuF3R7ElsoGvE+sxfkHwLjHfdazUvNVsuzQC1jkmc4NSpYydKCjymbyKlCfn7Vy3N1f82VEKy/YcN3wpAedn6its6XSSennSYiLWs9ALrLcqPCknUUWLmPUqCcsPKTOKtSFPWSAR7j9q3CUy0rSew9fR73bKoh2F7tNPIuD2uOQDCbGBJpYVecy13XozYt++4Ra3dc3K5dh47q1lsY6LAuTjUF2apSdjdk0A4ghR7xiikjP0adzZLf92j6OlMGmq16W3NrSGAZkFbo7tGnsCzY0FF2+Q6mc9XSO9/BaL75+YuFY18hFDfIp54/bZb1SVmd13l0Rg3muyViM9Jh693RxCLVWKJzmE0XggTDQSovsD0/U19+V4vRzWpsZtesm0fb/MbjfKAm08IJrI/kHvUkd8OLdJocoUCGThAc2Wdg952DQsL2OUwt5lRl0pvEVuQp7sT1exKTWI9PXgfsqIljxgiG+zQgUluC2g/16FSsb+V9yOBT3JL2S+mJcnwGFqJu9iS5/+26TA6sRRSuCLoMEMFYwYKVaLjo3p9hP+5oep+YOIS1+LSCmEB2q7dbDycLK8MU3U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f884eb-274a-481d-5019-08deebed5f0a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:07.1018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uG16A8xnwa89JYlG9MixYB/uEwl3TEL50gCmcY4yUy+4beH9ASv/lQFMt7jPxEjBBf6m3UryBMIfEWsUokHZzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270138
X-Proofpoint-GUID: W8jAzN3NqpuvIkOSDPW6BBgnaZIdmNio
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a676e80 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=LubjutUiPx9lnAFPkY0A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfXw7ZGpLMguhJ2
 4dMJ+s1S8uBtaI9Wy+WKks/jnCpmk+RAgMqr4317v+lVQkg7lBZPd1eNBzQS1jlrE888Ft4Hx7i
 REw/LItI3aTlh0b1afjnKMmfwyXjjYtnZgvUKVjozWTBS/8RhzaA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX1BvSBJ8LD8Ga
 1PIHLrZ+WOPxtdFrjJIb33BuK4/ieVY5nnxgBitdxurhcNZsgnNs2vy11csIaH8s31UTwwede0D
 iwlvICgCwH0VBYN8VqMT7wh4HxbTloDJlsFK41BKcqHirIa9WvYJHCWgu0xlg2m+uV/H7auMLJi
 RWeYrWtSE+GLmGg8g10Ob7AFF/eF44YFUL3lBw64xUgBnttrQIJUdwrDjRCo+tknCKD6im2e8lw
 AmYV8KMfxNzl81pRs6DtvDHLof2MJV0RPIpL6hUcyo8C8yUCfU+fjBWwzhBLWRxGhDVvxzLAPHF
 YhrJBg/gatcYsZTyE4eJcYqNWttvHwi5oyH/ZMo8HYhJAj9T4veIYtbpSDOMRD91ZTEZ6LPKNb6
 xZZqr0zu6MTUCOFu/V7RNmvXUXieScrl2PVrhhJrA1xPYCXDDhVwW1j1HNcJvwF3eB0+bEB0y5f
 bCePqXP2AYD0xaOjjt/aXuQdu325Xug2dpYsn56E=
X-Proofpoint-ORIG-GUID: W8jAzN3NqpuvIkOSDPW6BBgnaZIdmNio

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index c78d46a446cf3..af90cf38a79d6 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,11 +454,47 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

