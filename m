Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3942F6904;
	Sat,  7 Mar 2026 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772899168; cv=fail; b=T6o9yej8aQQRIddoF9Mj/D/tbi9h8xdUTg/Q1bs/dMEo9lYkBNi6HvKiiXAa4VrOz9nQpLvxq9e8uxXuGIybw4Vh0m0lOtfa+LGor9haQb8Wjw8OXBOhxXRJaqGTe4wGMz2eZHjQHQ+CS/OuTPdHn2tIeV63aKS7hhNAcLFjmxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772899168; c=relaxed/simple;
	bh=twybm9fDpS9dwXP35b0XHu/cid8KvGTFzo2PLrb4iqU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=M5+T58ogN/VM5XS9c5VCynGyevDj9v9uB0/M5n4sSMGcaG+Bzer0GspyufkDfGshTpZKVHfvSwKAY/YtGFIPp1ZhcSMMhAeGcJDCo3twdAPoTdf5VV/JyKyHHl1Rl6mJNpS+dkpIIHT5ZQvdcLgABKc4pXYdr+Km3Dqsjg0O6jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YV78EtfO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M4OCHjn6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YV78EtfO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M4OCHjn6"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 627FpStj1662618;
	Sat, 7 Mar 2026 15:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hdzlzi2mHr9yxSpw3S
	aS0+o0piSKpg3Nrs5mYP76D4s=; b=YV78EtfOrxFsfInEGQrwjp9KX2frKHUbwC
	sHxCwUDgGo5G06n/Mkp13b+8NF8gk57XfpRtB+24VsGAwpzl+BeRA5IhMBYl7L9/
	ODZhiU+3uvv3D/IlF2BoktcOm+zasr39LJv4DeVm2+LGTksFU9vkstRx7cFKQqWC
	8Z5YdeaqbU/MewTsTvNT7VSgvIOwX5NmutKk3n4hCdUvRzEK5sj/aRi7V4E3nmka
	WZGhCfnnvbfxGTJipOQIq4wqapZTP9qFhjEssqe/phL5lYUJdQm2lXevQdiVQBsl
	vNkQvcjoVJQ2pXJUs8SHKzkH3DYxOxHWzssBM3LUhVwx1b+RJ4YA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4crnxs00wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 15:58:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 627ArSdL014805;
	Sat, 7 Mar 2026 15:58:57 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbe0xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Mar 2026 15:58:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=euF6rEm0TtcSg/zowBE8nVkMzIbh1xxt62ArZArc9SdcrHJHBWsiFvM/up1y6ZzIP3OtHgeA6BaL2e8fDORGO1n+lLagOEojRvYyJDtLIbcupW/7Gw1owzrzhvBQVYCNEEKdmo+q6prd6+o16Uosoos2H9kUrFtw6LKrIt/D/0j28cXaHqws4r2RkOnmSnoH8FQ7Of6O35ZHznYoX5N6dreeec1dH8HNBKiQoAVpPpI6tXOYUzz+7ypUbN+OA/Kzf1LzyIuwo2m0CKBbha9e/s1EEEAgTs10AhwYH7JumTWmGcyKBhZkYNnI4qdITezDj8y67bhKMquZdQb+Jz20cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdzlzi2mHr9yxSpw3SaS0+o0piSKpg3Nrs5mYP76D4s=;
 b=KHFizZ6KKN02Kdn5DUdrHftJwWvFsN1feC8nj/AZV76VxcIApgdhNkCal7NWNaBTXf5UPZfl4N7xf4WcuJocvqw+8GgYRV6yKUb2ItVuLFpMKFSfOTdiMEk0l5rH/mur/OjZfmV9DhOyeaLt2g2guoIwJIu5nCkZSlngIHOnAc+kLzfVFwn6hnKuoedydn8xoIl4snkk68R2nOEw4TWR3gPBk6J76DAqShMlCYcxfcGuR2fagLWLUKDk6dKtAYKxxkVbtlaonlBds/GXIotiVaxP4GDa7kqT1v7Tt1TwEFFWZotp/JtgzdQGLFIdd5VyAw5NdrRnPGLbx/Nh6WWxjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdzlzi2mHr9yxSpw3SaS0+o0piSKpg3Nrs5mYP76D4s=;
 b=M4OCHjn6olZF3I8h2RNEIxwFcUPmVWuqiEgnGH+iDckznHFb6OFGciCTgH/6pffU1y7+r64Q69IRgK5eJcZvQcYjrmchw9iGslUItq0V3pvTT9EadaP7XuZg0LnK6w25Ebnd2UVJ3DFBeh4lwGoowLKB1yQeyQ5ZU8uaYAjbLDs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB7046.namprd10.prod.outlook.com (2603:10b6:806:346::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.20; Sat, 7 Mar
 2026 15:58:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 15:58:54 +0000
To: Chaohai Chen <wdhh6@aliyun.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        dlemoal@kernel.org, bvanassche@acm.org, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] scsi: core: Drop using the host_lock to protect
 async_scan race condition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260305025125.3649517-1-wdhh6@aliyun.com> (Chaohai Chen's
	message of "Thu, 5 Mar 2026 10:51:24 +0800")
Organization: Oracle Corporation
Message-ID: <yq1wlznws0c.fsf@ca-mkp.ca.oracle.com>
References: <20260305025125.3649517-1-wdhh6@aliyun.com>
Date: Sat, 07 Mar 2026 10:58:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0006.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB7046:EE_
X-MS-Office365-Filtering-Correlation-Id: b312503f-f24c-4cb1-22b4-08de7c626ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	5lOsOcZ4Z4ratstcvWaXrgdYROQYiAiN09C8dTnFp6ZywZ8lxKBqu70GKNXjpL82Fu557iUMgvuSGPjTsed7wfTb9I3KEwkz4A0103M5uZsX2bcoWJDxuYZd5+Mn0uUl0U9edLSRdI8aBgWFlblJ2lBSWKdyE1LpfPwRhvd0jnvmAd3ieYNj+88us69Qy1LXXkTf28MrCnWmkd7Oa9wi7I0qqjGU3ZWvhIhgwonl755Ckl4S7y5NSPxqYbD1Z/VtIRInc1YG+qLDeRLtAN4+zs7ycLJjBXVvX5FzoXMuWcjZnsQZcDOVZruA+5jtCBF8QmJ7WEvEcPDmtFhK4jR7hfIC3F7ZW0wiMS/SqAA8AaLlJ7Bi5jdRH44EPh1u1Cteu5NdDoYiWbnzXJ9g+FmNzLYV+A0ai8vfzoapG44lS0EQBUA3kEb4XX2BrOCh3Kr2VbZ/+SBK91UpUOM9GF9ihje9oU9i9RzgeR3LLogXeQ3EVUr+GTJHvqbLCnzOQ9oaUBzUPz3+/vP86yW2N3/EeutSC2Mw05L88KcHjnUyvkL8Wl2crp5GIVpdETnPKqr6NfYC8uESUaLSY57PRhHlSuASmMWOjwm8BJzWhh6I2iymiOdNn0mWPptgW0Y/WTGlta+0mcPYOi9Fwe9FPi4wuuAZUdVBJnlyZPjc6gJ4AdfrooTYJq4YrinyDsG2DSHDxoXke+dn1sJ1EFg/XccuUPsSSRnyirB2MdO/kcA8xNA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rdacd6CsFD9A2A/welNgyv2Tz0H+5q2Pe7xwyRdTAG+tTpKqIoaWAwss3r7h?=
 =?us-ascii?Q?aoOHHNGITP4IJQu69+AyQmNg/L/5Hf+dFeAnuEunPCVzgmNbNsibTFxlEODv?=
 =?us-ascii?Q?JH3Q43ymLN8vMF/NyR7I4VrobFj3pUOGxBqRxgb5k7aIipxjbX8pou0y5yQj?=
 =?us-ascii?Q?fJSLk4UkVIdUELtPpeVMB/M5wJl1Hs2l/N3cK4TmNOojyaxfXByEzVElGOoM?=
 =?us-ascii?Q?cNzTgjvbBE+GcpQxmtIsyWXmDn+QYbFyZYpLEKiYMIIufBuSj0H6kS3N5oL7?=
 =?us-ascii?Q?plRWKuBbwvtpGXUhOqfscXmLkimws9mC5i7w5FIMrM6sxJvKjoxhg+BvP1w5?=
 =?us-ascii?Q?z0dItxTV+b34lGVNGm/qBb12jnCIcs99yJRatgJUKUwrIcI3DocatrBb5QIW?=
 =?us-ascii?Q?rvqnOcnhYjKp2j3AWk/3jf2t/VHFGEwVEoYHrp0h2rt1TQ8aDfFT7mDPu1Q1?=
 =?us-ascii?Q?tsJcZuA9avg5ijaqjdifs7uJ9JnONZKzPGTd6BXWsRSBTpCi74AX80fyJKEM?=
 =?us-ascii?Q?v2eeg5+gPdytkBTWR9/eMnnSzPP0tMvHmCdHtf1vl2gvVXusRY74y9DHIQKo?=
 =?us-ascii?Q?H2jrhEPBJUyVypSom4wTfg+pXAlLOxgORlfKmOpSagFt3VGvoIZ3UN8ECasT?=
 =?us-ascii?Q?7hU9Xy/zOej4DPSeecQlNuO6tZrywNpXxoJUl/LDqOjfm81k999UXp38lGhj?=
 =?us-ascii?Q?H2YabweSSEGLtqvcwU/2VC3GeYabMWUFLvjw+174B4EHU753Lgs1DdW+Dl4G?=
 =?us-ascii?Q?vUMmjAEEuTsQyM1CC45qOMtGvu5HGb487mVY5XxmPVqlkhHnRotFgLnZ5Aa9?=
 =?us-ascii?Q?XVkU11H0Dwewl8TdqdI38fTvtppGjtOitcq8D/MR1OioAarNvyBAu50b5BOJ?=
 =?us-ascii?Q?B7EQPT3+1F4gmre2upiCo+MtN5/Fx83sbhv/n4azDcJAdoQsikPGUobbVOmC?=
 =?us-ascii?Q?v/+0abWA38w17iIVOmvCpkVUdrKH7hrT4wa+wDJaecupLkkT+XDYbOVHw/ZT?=
 =?us-ascii?Q?gW8BiBWVlozBG4AyMseD+cechMRAMoC9dEJ9FDkhqvdw1Mi2pR76vyevlsMJ?=
 =?us-ascii?Q?QHBZbtOIMtX/YOd+J+nKIISRmByajwslGs6Lw9sY+NrE487AcBHWB/IvHopX?=
 =?us-ascii?Q?Eu+Y24mAkQiCkMGPJFTQNLpnJ1YD0RsTOPNNn+34a1YkIBN0V6zr8okdbGdX?=
 =?us-ascii?Q?cplq0SRNQhgXcj6Is1CPvnB0kFUxazPaNAWhM1yO67A4QEDKafeUstzRxnDR?=
 =?us-ascii?Q?14Xk3QZPx3l/N+6oGm7+N/oLke9GEEYyx1UWlC5PV1o83XvjhDIrBaAQfKz9?=
 =?us-ascii?Q?j1I4t9FDmyvKm4OZOvjEODlP5jl24eLBatf/UuodavdHwl7iYwtYSDRa5JAP?=
 =?us-ascii?Q?PyAd9+os29piA+9raLm3xAahY1/9fCIq0hlPZgeLOXJzm9gvE+HvdumMbrYd?=
 =?us-ascii?Q?8y2soinYHHGHiZvAH+i6rrkUv1jADCJE2sKq3ftof2nLC1n/buK2nuzWUsQX?=
 =?us-ascii?Q?CrZKxqgI93Fweh0hpfPTfBZCOi1Dr+fsdi3buglchvzX46r9RQvl9E+PIdMe?=
 =?us-ascii?Q?RyUvuSTPAVt1s8IQBu/1a5dLadXoYV037HH756Avn2C/UIB2mJZ3NyvhEXD3?=
 =?us-ascii?Q?e6DiEObqchHC+CyzItteGu5FOy2q7Qzpo661uccpfIV22pod/z9z1LOQkfWv?=
 =?us-ascii?Q?zRb+nm4G6AbKcFg9mWUTE/z+G+q1D5O+Lp9AGI6cqn9dSw9vgmSP0wPS/t/v?=
 =?us-ascii?Q?yOBYop5fnzmCZyNGbxV2T7xY4R/zaC8=3D?=
X-Exchange-RoutingPolicyChecked:
	LOtJ6hnUt/pJ7wl1wn3UfgsYNyhqLfjbDNW2kRMjlIEf06eSGD+UQAzPgKNpxt/K2+FI4Bzf0EWG3wOdZYFXZ1nw5TVCu83NMqlwPIGbCdjzJUc8f4J605BV2owYMfajW+KXsIsoL0ANtm/MmYCI+ig7YHZMEMWF26yMKT5HqHjjgS2khCrQn4PqpX/RAJqQMPZqTvJSjMiFiJxB1l6cmueNAdJOfRBDnv+uWPhLZKlFDyHH/fzLE0DbywEfBOrWEzqAZz/ccAyB9lwoiB+0y3uZ8m2/xUYP0SzkomWGf+IT1iyWEUNqRMGWdb2rL3FCNn15C5N1hCbd6dCpwUMccw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U7SWdcL0P2it86Psf6qBpfjx07kKQOQSSceS8KriIvf7o5M/P8SVUWnx3ylAg2mqYJDgBkTB2/cjJQm/Evn7+eP8xMHhWWsUKdv9iMViSnp/kVEN2dPuUPnx/yBWFiAQwM4BgMnAYASCTs3noFuG6xZX5Z4t2ITzGXQMeda2G2D3yJc3XEAhXO+UkdbiNa9rrufmxMX0fkQgvkLtrdLph5FAHcyhGkZdGfbNoNn95U2IIN/cmd4sBK+aAgEzjKSx8UCB6Zg5g7hNTmcqOaRMTdJYGDHQsYYMLl13PSXplx4SHfdTMQ34apBJkz+LfcBpi7B4GwFdc3lb7uevti/padPYXOuQINABgv9OxgPiXg+D/l+yQ7uPcuqk6D3wEdtbtkxE9ratxVfXkB8Z4cjMYLIB0ChWsVI3QWffL69qLGztJwGSVCUplvgJgUnynr3ftAfw3OeDQglsbw0NMT5p6tRaduyKD9Msh8iGDYefXP3stEQbq602+l85e/F47erK6C8YvVZkTsREIxF56HIov3V3SkSbryRvTQzeVJdZsGE6A8I/oPgG8Fa+OLfy1WQ5kjQGvpjARIwX/D3Tpp7iSsu/HABqhNcdyH/c34tLjJg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b312503f-f24c-4cb1-22b4-08de7c626ea8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 15:58:54.0354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LbOG/5BD1NtinzZoq64hC443hHLAOPkK4uxpR9sKQ2VpINZkOYmP/uOGm/cNzJR0ffqXyQ6BBtwuxdZWsFnyBMA1SiDe1KhwphpheCtYwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-07_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603070151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA3MDE1MSBTYWx0ZWRfX4qywET8jtR/u
 1XHX2vSOAz5ZgexVm2NJo4ySUfKIT5CmfCKlJ1hpP0wiz2w9iEnrApQWLbGwfxP6ne/RlrKs/I1
 Ep4uiL9XdLgyLLtUSM0kWS0TWjNYtdUUElWtvEmUZQ+hdU7GZr0CKvWlMPsvlwW/os1WeQUBYZ8
 0tSrM/LbIlSoo5j7MO8uP7FBuV2VGC3kILr6hgn9qIRzeCdSW0ZitZIsTJoSXBNRs8a6NEivgzX
 NCmalxANzpe62ALhTY4e95znerPWwdFDlrswymNLWTfzCFJ2E8dA0JYE9M/J3+p23Cieb9hDzNW
 ajQ+BvwFAR+XbF/AxtHZ/igiDiEwhKpkwbQZi4ZyGP4QmtrTGEXu1mwsTKJW/QdwwPg+Far0Di0
 N4BH1k7ps3ndba8qL9FXQu4dzQSS+I+u/NvI273P3I3Zo/3Sf1TJOzLvILDI0aMAyALE9Vxn9v5
 kEB0zFdrOqugoklmJqzM8At/XQ1yEMjxWEqfXD5c=
X-Authority-Analysis: v=2.4 cv=e/QLiKp/ c=1 sm=1 tr=0 ts=69ac4b43 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=KCjta9fn88f86Q3yJZQA:9 cc=ntf awl=host:12267
X-Proofpoint-GUID: iOXVT_D8bY7w5pxGSMC1QvAOU47ixzSj
X-Proofpoint-ORIG-GUID: iOXVT_D8bY7w5pxGSMC1QvAOU47ixzSj


Chaohai,

> Previously, host_lock was used to prevent bit-set conflicts in
> async_scan, but this approach introduced naked reads in some code
> paths.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
