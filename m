Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3814156F5;
	Mon, 27 Jul 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163440; cv=fail; b=iQGk161DTr03w8aVVaJeZ8J7gVqvczJgG99fefhfC+co/gAKACAvQeLMuKG6nyBCmRYjLAg2Srjh5y35TqtfqGFpK6GKDtKvH/zDXByxcl8XGMqX8rkLpZpoZ+3eZ+GPnGnO9pVeZS+4RwBJSRprgnlrpTKf/oTnaErMHacG5sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163440; c=relaxed/simple;
	bh=j4Fxt7qcGfrBajpSs7vf831KLyzTTedGWXgnIHpia3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ghYUUvc8by2ya7rD/kpAj3Y6szHl5ml3bPSlHXbMDJqh7sKy78y5+oBQCVo753t9wP24NN+QhKqCYNu980sfxUaYKU1g64BCho1fyjcJN6pGuBB3FPUlWm+FUHJro8ENApewDfw9/5Ir9Ne0x8bm8j+lurfwKNCOR6Mg3bgwpeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kSTxCN8/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MhECHMor; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSTxCN8/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MhECHMor"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUvxf2244814;
	Mon, 27 Jul 2026 14:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TD43GsErMsPqs95tyb8wTt4b87P22bcqsWBnx80VcgA=; b=
	kSTxCN8/lp86mzik9L++AdZhhX9XPiL/XmuHBIVghVEB7XXiKuyfNx90ppNLMhsC
	PDmq9Sy0TrORScjfNokKJSYs8ZTQ8f7tRGjJUlh6xRo1ValcMcyfm0XY+X6oOrs2
	tplMfUNCdT6PfXtczD9CnPPmP9Q6ETeze1vprYbKnm0AgqDbRkMnbMIY+mo75jXD
	TsgOdL/M55GZAYhsnpFKsbqbQr7AGfNlZoq5kk6WYLv1Gnbj6Ko5VQpUy7i5sQrb
	7Y1N0puLzOFpJFp4xM00H8RSfRLG/q/mk59O7+3nk+VzNctaEaSe082fdkadUd2I
	FpYdBy0pPCmxob7/EitpyQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3phxde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeCJF006892;
	Mon, 27 Jul 2026 14:43:17 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehawnu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ofw06ceCQsZLamp2eR7+xh+EI7pv0Xx16RhAo9PPoNJap7No5eZ2ZVPIflA5y2hehOPZWl8yabX0NLEIC6oHuRQ9BJBlLIGNv4RoA/H7HPKaJI4rz61XJpA+mRSM+QXpKP2bIHCT3Kr6xLS7r1mFDsk4E6m1pCS3GREdRpjV/+L4kpS0L+oR652tyOsb1sV7ha+Zfh1GdOMVZUA13dO2olpieQE8XHzs1o1AiJBjTsz6dW9LSXVo9i/jzKFkSfpdC07mv+soqo8u6f9fi5/ug5w+EvD376C58RuzMaVQoQ3yJrCfPcxn8r191BYSqvvJZTTetbDSnLmVBosxzDk/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TD43GsErMsPqs95tyb8wTt4b87P22bcqsWBnx80VcgA=;
 b=RvPWCPYeXU0tkW/mxnsDVbR8mqc3Wxnj0Tdy56s81WGwrkMBH6GM/wXLf6TIWkr9Pdd5dbkWWNELzreuV8vnWF1OchgT8Am4fnn1KzNpQZpxeb1RcJ15afkW2BI4tbx+4hxqrZAiYMv/DHJFAYRtE39RuUGvVVIvM27NpGjSrMadhrMr9D6vWXl7qIVGun3JncEr5tZMa9pczyhGO1Y00oYQJnSAOEOb36Un4A/8nCYFgbBV1NG6cru3tMK+DrdLVlNQIfgYN8W231OBgMgQ0hYXZgUz5RJeLfYnQLi1h0caZJzftTy0ziFb+dnTLOTO6UGuDaFVqJnENnz+FdkZeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD43GsErMsPqs95tyb8wTt4b87P22bcqsWBnx80VcgA=;
 b=MhECHMor7eYCR3pp/KXWhQHQ/9ZhbETf++JT5WADcwFldaDPc5W/RqygtQ0fCdzpm7KYGU1DgDSJAlUySnuytZiVV3fcEcPpVaOGaiyJQZCJwgNt81jVO1V95e8NyGbOfpSO2p8xdnOGCmJkPxEd59zWMg0mdCyCsArEQd9ZeAE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:14 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 12/27] scsi-multipath: introduce scsi_device head structure
Date: Mon, 27 Jul 2026 14:42:19 +0000
Message-ID: <20260727144234.3802948-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:610:b1::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: ca706e4e-b515-4a52-3ad2-08deebed62f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oZAv9XOPPgVta4/9c5Ic0wrIILU0CXsuDUqnSBpP9vcsp6tEN2jkCEhYmMLsoCvdWerz8aYQqQPDgM0bGLbKmHS2X80ab/kQ06TW6KnKCrZ4tMYHuMOCuVx4EIuvZWxrNRAz+VJ2wmS8Wjs/VJSwzLlBPUY4O3tDugAWfMjoBDiTmnOMJp/dhYgFlgAj3dKgQaZiWFuVDAQbMzTZpsBdsBo1QDxxzHtntq0TU/lUpSolEPCBpOfVt/j1/A1Dif6LP3wZ2bWTgElxB6r7QnKqCUdeTv9TBWHkICCUbf5Aiapx37xR4An/Ayz3iBe1GgCQFtxYLYD/jCaLmSIgZvu5xw6W8tMfUe6/V7zhvFCU26+hk+dF+6/pMvreEj59cbF3NzBeFkSybzo5kZRsis1AdtpgH56IRFUOroG3p8GYcXE9o/k56LN4sNln49gvPotTVt1FuaoyIqB5iXSdccI/a9boJFKytLn3mrWULvTlyVNMKcN2WF/FTRZSwcrZep5F2AaznUWmzMKYtCG+lxC/f7emASB2EvM+nRvVaAR+cH1J1OF9xhPkvwcdt1JotNx6CxksUGpnMsOFw++YJSNjCr32IyiwkxLqDry7NVB5AkSB91KiIXJC/0m9+BBR5UTgGe38XCPvT1U7dN5EAHgLWMpvghwu6f9Efwlpo9YNtIA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NvKVUlL5/mdMUV2PMaRBTvHMkH/XAuTwYfVLEwR/PVpQrTWKe7IrmUhHlN91?=
 =?us-ascii?Q?9yykkkidBanmbZDfGrAc2orDZWWiJIbPebquonMGzNzqFdqKNjJp8ScJh/4F?=
 =?us-ascii?Q?8s057xgGTwHVcvbxMe1WiZO9ILqSEjvo7Y9PSY0BFh1hnBzzsiB9YgMreuvY?=
 =?us-ascii?Q?ZONGIih4L0lJmQB9NgNx+bQ97wcjjBqgA3fwbG0mLIGtuk2tKbAAOGWCRZeg?=
 =?us-ascii?Q?5h67mGLLUWBOjAFICpeG1V7LLPL/pWnKj0ssjeQiFTPpRD5D73A0f1gB1tb7?=
 =?us-ascii?Q?e1dLP8963L9/esgpRuTxIcwQTUhIVUmn5hzHLGOgdVVveZl6uFfOxC0xLPH5?=
 =?us-ascii?Q?DeA5THXwKOL4YiB3bkXX8IoZF2QocqdqdYBto3WoFqe6nAtjP3FbJTOVBrxT?=
 =?us-ascii?Q?qh9RDOTchYyj38Ycb0OHaogMMiEIjYoszVRUmddeGEuBvZngJdcgiMH4pvvN?=
 =?us-ascii?Q?ZCo7rSCzd5ydql4y+VG+LqYksqjUAHYJoTgEPV7c45jre8hlByL2mWOalnK2?=
 =?us-ascii?Q?CtbX5L0H/WNLno8jqj827QYaipyp59u95jSA788i+0jQ/50iYLLa8YFQltgl?=
 =?us-ascii?Q?m7yGt7sz0NeVPf2zsJDjG4DiZsmlh/+LckNs9fFEZWEpze6OwpqYOt6uzq/0?=
 =?us-ascii?Q?FYocdlAaev4jvtmXB+T2pInb+UDlD44yBkBzn1j7S/fMlErX61T0+2eMhlzq?=
 =?us-ascii?Q?upIIPUrSHAEmihwo9AwXxR2iTSyK1iBB473mBqVnp8jP+2T9JfYOxJgyPSFW?=
 =?us-ascii?Q?5Ds7wOmeWiorZI3lgcGfis/nBeFv6gwRw4U2o2+P+fLNtC5Sv8LxOx/90te+?=
 =?us-ascii?Q?3AxmIY0rapXZk027Ckuw/xKCB4H78hVeMCyual3LtbMIllXdq+Y/mFjnYQcJ?=
 =?us-ascii?Q?AC8rMjgt3J4k34QY5XkB1J+jT5wuKzjwPo+bYgWTx6lo2AG0/0CT4O2LBOfo?=
 =?us-ascii?Q?9nb0N3KEO7wXKO0Yfpg64+9hKNSncfLTvY+UXPbjDe+ezdU037Cug/KTUfbJ?=
 =?us-ascii?Q?0mqoA1QK8bk0eYtqKPuJVrxvJz9E94Ztl9aIcqQ7SUK82/a2WVK3qrHEhaKn?=
 =?us-ascii?Q?I6dXIMgatDCv06XiYRJFYfCDyDSPSbrbELMI9NH5NbPmtElsRoFSXgWQmjhX?=
 =?us-ascii?Q?MJkZ1ZRKj3lCLmKLH4zxxt2wJfTDROQZpSmcm2da5BgFV3lTUpTpPDgQetOh?=
 =?us-ascii?Q?QLSp8s94YIOaWBZaGK1MPFi3WFbGKa5BAkPjkA0cXRIvOlsPiBqSltJc+CbC?=
 =?us-ascii?Q?pncpTMiP4Dxvg2esW7Kk/grrO6XV8J6PDh4OOhJlvMatS7gBhdBK1nLextMt?=
 =?us-ascii?Q?dZ2v97g5vAsInabwkT8vKnyC3yNrst0vw2oi7yD4jUwLRUwUAPIOWxiuILYC?=
 =?us-ascii?Q?VvFbRRGOkYQ6ytzyufcdQIkk+/ohnBk1jyXOOaSLFqLcsAerkRt67n9I3kyz?=
 =?us-ascii?Q?cewqLM0AwS3cTd2FGb+w0jmP1UVjNsfnR9rP1huNgV8uYwigED9eVNNApWXR?=
 =?us-ascii?Q?Bm2eE3gsRt3SoRHILea1Lij7+V6ZO53/b8EpLHDlXXD17Z6lmJCv9Xscp5RO?=
 =?us-ascii?Q?KYM+TxeTVHt4V/mHAiI5cBBP/G1p4DmIqqJfafx7Bv/Ls64dP8okiOwN+jtL?=
 =?us-ascii?Q?EUCWXZLHjv/RUq/qdyhRDyI3TZpdsfvRHSNdlUefXxfFSyYb8RjJc4qpp+f0?=
 =?us-ascii?Q?BlbRjOqETtr4MiJV97W+zcCzPgqxjD5/4EQg4Zx4C4t2+qqGHS0giFdTVWF1?=
 =?us-ascii?Q?l3H2HXaFDGEZO14oqiBk0szhYrYpTNw=3D?=
X-Exchange-RoutingPolicyChecked:
	WZeCLOeIhVugRqPtzC6WNxUB6w4ig8IHi2IIlU5yprs9EXsZl/ACVq8AF1o1AC3RiXGJuV/jvXjlepAM4qgPYzJ0fzPxRIdmDwFIoF3CRcVs2P71bM9RBXt25P2daMgFd6llFdz/I/PQprtTwYk++CxNT3nWVR+U0vWu1m8tNmwaO7+8QaoTqXHa6DnTtAdc6cBrFSu99kfnG3bg6G2fH/Xb8hXRfRS/I8cuvvqUoCm2mrgGo7ZavAcBW/CBA4GBrJIPRTtnGJFBnWrp6DuHIdWytbQP77dq9+2tXEBc5DxzegmHMIyzsxvwna4WEnRQ60GrdNO1qKeNGUQKQvo37w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e69Kq/LPkBsvH8bB1HbkZFG1YVUI458xQHuhr4XI/I0TTVFpf6RuoNMXGo2RaCa7eiw0IioG/SJnb0VJSMma1ftY+FMr4M+wQGCausN5E8+fPc4p8JSw1NElHLRgkeev/QdbhaDC1g07gnfFkD09VvCUyj70mneIoN2XSggQ+YfGJ621Yjmr3LZq5/DQytuK+RKSBECCrMC4mTX/XXPwgdyuEXF4cCJHBTQMd/D123uRJ8oWIHGC1pABpdXn8XAnvKxV03sFSJSNzwc2SiyMSHjgL45WGNNtabAEyf7Zgtqy8ziiOgMskSX2vfXbigOa1YhAWroUsVXzN5sZxXFN+mnw26fqdhs48C8mplCs7JC4K1BeqeHP+g4FXKfhY+IspJgSgFdpd7Fvv0/3BnJFT9mppRA//ITq06xLXbo9LZkiziq96h7rGUFtAxwHRyviow2oPTFUd8m9n4Srs3hcGC3hs1rYX1/2rXIiwoj53mqqsJaJyH7mQPNN+kgVwKQVbxHcOFdDzmiliTIils/ht/9DltqWLrwSLIQAljg+iBo4e83t8uloT3sFlhbDEaEz39FlofsnHd+LJ2+nsxY+kExryk4tyJkKPrRK95Ziatg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca706e4e-b515-4a52-3ad2-08deebed62f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:13.6003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAuM8jD7LwKyoCIPAGk6PUgepXNJzy+PU3qycr4C8P0iP8TI/TrRozB+hnLdo87LgsJuvKMlln6wvqom+nNu7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: csXxJB8c46rC9ABf8688hVR3jK7JZPAc
X-Proofpoint-ORIG-GUID: csXxJB8c46rC9ABf8688hVR3jK7JZPAc
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a676e86 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=rslDvqJ3sq2LG7fXSO4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX+88K5SBcnIZI
 q/xQGwjfH8zGZBytQ9Ej8y7OR6iYRxPl6RC8AV7RqxayxalhTLzydzYo4/o0b+ZWVxaJuHaK0ho
 ltlK59d8N95wLunfU46rsFd6pFUd1La+6bwEtcMbqpNF5uPo3eP1KmSS+bVqI+idt26m0tHVt4g
 97MS6IhJC2pWOuDNr6lefnnbSBvzMPUdD/hhoA9Vybq/P3nDKx2rdnuDoLKN5cQBteCSO+2Lfy+
 kpCenWhDvr7HHxY+EujvrtTOMUD3avDRzUUELYRd3PsiA7c8qvKhRzF+zi3Kt/lRBzRzsys5Uc3
 qKT5NVMCbjoxkdsV8Mi1odeOo8BKAV4SES8fPdxAuGXRMPOUJTW+88+lxUwbx6FjdRReonG1DF1
 c4qlUXw7KIOqTQ9uHJcNxSS1Y3MXb64LDGmPJ4zLUzfDxTZOFKnUUckfO8n47tqNlzSvmvy/Z7z
 VazV0/PWJm/5/johU/g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX4WKe8OlB2m/U
 9h396QQUGrEhCZ65OgFBh7Ycr7l3OQmc5Rer/Xrg2AsT4a7ihR3UXWZASw4TY4UImEhZAN3r7Pf
 d2CtfD8kBQhvNbLIRpniFxytNwHYwN2bMKYwyc3aCyJTD5kwusrA

From: John Garry <john.garry@linux.dev>

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
managed by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 199 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  31 ++++++
 3 files changed, 231 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 947f3e2103e6b..5d19ab6a89eb5 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -29,6 +29,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int mode;
@@ -70,6 +74,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	ida_destroy(&scsi_mpath_head->ida);
+	mpath_head_uninit(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+static const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -89,6 +142,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+
+	strscpy(scsi_mpath_head->vpd_id, vpd_id,
+		SCSI_MPATH_DEVICE_ID_LEN);
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_uninit_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	return scsi_mpath_head;
+
+out_uninit_head:
+	mpath_head_uninit(&scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+			if (scsi_mpath_get_head(scsi_mpath_head))
+				continue;
+			return scsi_mpath_head;
+		}
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -97,6 +218,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -116,13 +238,51 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	if (ret < 0)
 		goto out_uninit;
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head =
+		scsi_mpath_alloc_head(sdev->scsi_mpath_dev->device_id_str);
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	sdev->scsi_mpath_dev->mpath_device.mpath_head =
+				&scsi_mpath_head->mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return 0;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -133,13 +293,48 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	ida_destroy(&scsi_multipath_dev_ida);
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2f80d703ce640..799569b74b535 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1525,6 +1525,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 */
 	scsi_target_reap(scsi_target(sdev));
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	put_device(dev);
 }
 
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..50298056181f9 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	struct mpath_head	mpath_head;
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +69,18 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	return 0;
+}
+static inline
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

