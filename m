Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34BF3FB07C;
	Tue, 28 Apr 2026 11:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374798; cv=fail; b=oO4eD3CUqMYxLQkaTbgF8zSj2kpoNSMYuIOSXPCJxl10rjh1lG/AX17Hx2+iyv4QoEtzo3plSB509CIbckVZWIHfdseW8LrYWW9czQvzEYRtz/H6njbw+p/hL5oLCg2SITdm44raf5J47bO09ie51pVKz1vYp4IHnycMF4/Z5Wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374798; c=relaxed/simple;
	bh=AqtCCNzAzS+a2zplJXYrhIscr+ibX08xkgHt3r8kNh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V1pNN/OEVMmkmQmLwDFoT9h1WDxhXTIdLe8QQImzltbz0bC9dotWp42DrXFZjna0a/xmxhSsO+7+akgk59irvhPsbeY/BHT6WGTELYWRWE4gnJQNRGZcabnTfrYipP9XREew7VPU02+RWxSWcXJrtlKUX4v+/Vw5xnLUCmbT21M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WJ4DtQjm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jVTyilvr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WJ4DtQjm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jVTyilvr"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SB4JJi1905228;
	Tue, 28 Apr 2026 11:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J+fTTfuXXagzHNA00pfeIG70ZATpM2PEUYnH3mefXDk=; b=
	WJ4DtQjmcNQLTq7fHGMoVDENha9TyXj873qMAc6oR9vjiexbxF7Qt6JASrQdorxW
	0lP/aohQLt6EGyVSf3izDPaGTCE63Zh8mt6/rTa6ebhO5VwBn4WYbBKwoejUJCth
	WMP7ZibKGE5ml2ZSXCFqNpCvtwq5qqNGNXIY8CKwOoQ8ZSDL2YYjm7PLOKLKdKq3
	YzY6R8wVTPRiuefHH+9wqR4lZkMNfdLg6g56xmvDxV4aV40o5o14fV/WClNx1mO0
	2gMMxjOK4sSS/q0D0i1MlQLbdWSob8b8c1Zf8z+u8ZVFDhKtxvlOBcrBLjUb34rM
	jZ6UvFT66Jo0qtwfZ8IYxg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8fcnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2kNo040801;
	Tue, 28 Apr 2026 11:11:32 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cudth-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUQlBY4mtiGiv1kogzYpZEjWDMA5HrsXVi+zjLKxeEkuLQ5UMOpB5aQAE7K2I/VCBUpJp9CV/QhFxYC75cdtZB635Kl2Z0F6ZHjJzvJDApwDsOGWO8ABrKSTI86YAT41FOnp45N2DJcmFLtx25w2xQs4on7hayBjVShB5n/adf7XrwIsqaD9CUynSZjZu1cV4Bg08AAye9dWY02JNciIMdhALD3UE3Q8BU2CvieHaFaKNbDumWtNvFxvmve5P948l4E3IV3+DzwfKIc8npuz4V+yyX7ukvHRSTptl3QBnv90vMP31Hja48e+UHnzl04SO70jhqhTBiLPkDYDzYpZdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+fTTfuXXagzHNA00pfeIG70ZATpM2PEUYnH3mefXDk=;
 b=PNSPna7sjCSgVHjKxCZtFR2+edEm8u+q7mSzqSIIpHDQF+nwfMWmZc9Bu88RI8O//wYqQ5y1F1G2DIddD+WIBQBkSywDKXO/KwZy24X0ph2oH5allqM1JM8HULmtwoCH4+6myxna+2g5VBQy8XN9SO+qz3BC3QhKG6KokoELxuXQAKOcZg6cHfK39Z9cABovOmcUCUU7wlh4iXNi9ayRQdrGan+olS1+kpct7lT+EtRQL2oLnK5vlX1JlD1L9MNC6hbrva5RtbuuxMo72SzWyiLsBMBY0NCaI1XWa1N/Up2gWnzOYRgQWiHQcpJU6Qy73/9k1OEeR/+OXdMXpfr51w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+fTTfuXXagzHNA00pfeIG70ZATpM2PEUYnH3mefXDk=;
 b=jVTyilvrNTPQgLDH3A7j6klcNciO3B2so+QVlaOiUf+nnqi9Gezw8Q9BGe0+X1jhJFIiSzXOgiwudRWfXmL47Gf+IcVqNRjfAjJPpjriWuC4Wyhf+8z9WzyeBPX6dklompoFg7v9AqRdIJLS/cqqXm013XsljhMHYZZ+My2S//4=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:29 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:29 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 07/13] libmultipath: Add delayed removal support
Date: Tue, 28 Apr 2026 11:10:59 +0000
Message-ID: <20260428111105.1778008-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::8) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: cd71a154-09f7-48bf-0cf0-08dea516e588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	405zQJs/EhB8827tGNPVcB16y3jm9bUqAjIsbrPbeC7zPJ26dbzQxk1TWjckXcOYO3Ct6aviUXK/F73YpaJZQNbAy2Lqc7jO8o7lg9+tCTrreA0RYuv5lXa59tbekQa68Rev068iIz3SxPBZ4iLoUs6tJVwOS+qtn5jKMizqXGppjJp4QBg3T9NtzcGsQ4S1NZ5N/suinDTUQk56sI9xKTYw6F+Udtgbq3ZqbzuhjFMj/rCUu1nOrgwFzYYAL7+okLyEVqaRoIShVhYM0TxdKcSX5M52irYGHGDQgw1YLL+S2M43X/NA8AYb01FwnjjUbxKIJJToG6K44CiiobA1STd2cswEj76/R/T9n33sR5om3cy+RdplypbQpiSsagH/jCr11RZZyw3nZmtcDeAvdjkqchRV+uqY3yxqDYPN9mRR3YZri0ctaCTD960vcky7/d9MKFhLJ/br+Kf6ztmwI0EVCCrMa1ay6+C/bWD/6MQC5TS9vLNyBGOcB09PP/tGQ7pBXnzPRP4p8Ug5qj9xUZvyfK+Nh6kPNWro0qj9AID0x88/YG38UVhEl9qEVNRJNBjcP5MKGzobepnkF7vMZMz37gutdrxdSUHdW2yi4DjLwiA6ipHLL2hacrhfnhqse+qn2JBHHfglC+bsRLoRvfJgcsxGSO9wI3MF6M/RVf/LpOQVr8GHk+n61MAlyXfQ8oJ6BJ8IbumT0MPLZThYlbqQCguKm+M+w3a5+VBMUeE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fpzoJUFymEvx3B3QnRI4YfdE0x1gRmV/EXlhiFNYgYp6NQ7G2SAjNSwdLe7h?=
 =?us-ascii?Q?K/VJALmW+My/eBxG3TWVIuzsjIuCVB/Ulu9zz5kQfP4lXZai1jnYZiRbMJXN?=
 =?us-ascii?Q?nQL/vbqrsoES6x8yppzaHNVrt/7yYxBQMT1Cqs+S60Md9Sjk50Jowce6fDQj?=
 =?us-ascii?Q?xLEE6XVgRhuypleq9vRNgvJeePgQNF8SUXPdtG9vxrRbKku49jXvV9yda4yd?=
 =?us-ascii?Q?R5YFCpLA7Qh4TRSnIhjR3ovqyInklOlrLv6PKlAhYdWDwVMhDa+qz1bohtAp?=
 =?us-ascii?Q?bJqbe8GuSD6sT+1CV3LTkddht3MDB8I27zUs5qCcJnmQ0iUSq6wVDP7gOyji?=
 =?us-ascii?Q?vX6rIJvVZUWKFwoyCiNM9ZLHx2XpdjoTzSn/27NF4i5+vIMQOz5izr5/JS48?=
 =?us-ascii?Q?JNg27XDU365HfFJwbeomMl08FH4p2/YwPLyMiWSyruyCgdt1EPql3LYXmK3g?=
 =?us-ascii?Q?YoMz4nrOfmy4iBRkLjdApheCFT+wb1ceOo8Cm2X2cNG/byX6lWeNarX9pqwT?=
 =?us-ascii?Q?xQzNI+05K/VbQQb6ELJP+Jq3YfXOmb47I+aOgq66HO4rgsy658e6HVBNNkKC?=
 =?us-ascii?Q?uNuVSUlVBENV0r6A7erMBZ1QdG/sxswAUAa8vFLDrAGUvN7GGVRVoA+dlPko?=
 =?us-ascii?Q?RHIXLDOD/zPtpGhZOO+WRbBSLxOzDVyFbM1n4F1ELqnBh33erqFwfadIKaOm?=
 =?us-ascii?Q?YEdJJXSydugOnbhClyWIwGlbPYPoh3iztC3Wrc43FE3nRp49DPKNC4nnMo5+?=
 =?us-ascii?Q?wHsIW67n4qP1XKMmcMMLKGthhHKCMVU+mUevBVjnzxQjxPZNO4VjwivdXbxc?=
 =?us-ascii?Q?n4q5MNmbV2/9qQq86X0+UxTgfPZlCEBV1Ta31tD5MlOcPkKjA+kB7J6RJDGs?=
 =?us-ascii?Q?48Pww7zjZUStWm2B5rx1HZabVK/mFLcY8YBbDC9qFS97vcGKPf3AuDWX7k0I?=
 =?us-ascii?Q?biWN8teoUAjBRjcJn4vRq+iEOgrZxAYboDeG9NYlYQckmgoN571lHFT5y8ho?=
 =?us-ascii?Q?Ktxpx2bStKDGhslf1jbC9gUWV0IVeOjQby9gXrXrNuaXI4YMaaCOLz1VyZn/?=
 =?us-ascii?Q?Jqy1C1w2PrgifzlUhvYW6ivy0yOsVOyWENeMNiBhKKRdTXZPXRkG/QVFDm2a?=
 =?us-ascii?Q?n8SsmDIAXqLTGwU1NEqvqxUTyaquc5Bnf9AQMpAafzaynTC0Rm96C+z9PvBZ?=
 =?us-ascii?Q?vdT4EZ6gNLQ4Exrlg8xIyHFODN3FdDHNW7XGyq2jdXJTsfNo+tHxWxtOPkMI?=
 =?us-ascii?Q?A7lJ2EOox0yUMShMjaK85mIximz0qeC2axKQ60R5akEOMPxyGbJaaDxTfd6s?=
 =?us-ascii?Q?eGzy8u9+jkG4Kn83PSarpw7EI9XW9+dREfmru33wMK0n5ImexawPqtxKv5wD?=
 =?us-ascii?Q?2WHvhzE2on+03iRVQRfeMQtgExy20I0g8zDq3u25mkUVntQDU0Xvi6WfvMki?=
 =?us-ascii?Q?bXk7R9iJO72HA0WfomeZ4qivjs/JujxTrGHPi4RkTRTWGDEh2/4o26CGKdwb?=
 =?us-ascii?Q?QG1KCvBjdBxwzMyJLESfEhhyJUmgcOcba/hTXGPZWfXPheyrX23NHieLnIyU?=
 =?us-ascii?Q?+ncmEePkeU8XBKXYgkSF6vuoF0kl3Oxj+k7yRrcVd40qd3VkB2ox1xkDyY8I?=
 =?us-ascii?Q?ZNVAfMTggb2klHLAYkuWWZI0/+aKTe6yuP0c1hXJQ2uIAww2hyF+isYduGK0?=
 =?us-ascii?Q?2FNRFzMpQiuaOlFCEa4elrikfwiL08e+GjOs6tuSZectat63YvxDlGzVFT6C?=
 =?us-ascii?Q?IZ4kuQAkfl0REogRgON3/eVTv9IA9JY=3D?=
X-Exchange-RoutingPolicyChecked:
	k3mJTicO26tayQNOKc1QdRxmPh0Tf6TkuKQYhQklhFlxaYge0a+tF32ozyeE9AB9C0ODjVjE3rxRa/MubmjAngzi8r1A8gZpmV6bTqyqfV0EROYeWujUNgTBePD50TzRDAB7SR99gsg4MBSNOi9K6Iu0rqEEbSOPH7vVwjTNcaaT3ns2BNNdN9KqRAYAnhM9+6fO7hfKhsSrKHoA3c08iey++d5AStMvI+TilY+9ZVT9lY/sa8O0CkK3bKrEXPaMdA5MF5btbTrcqH3HdwBnYhi5UzleMuOp5lCwr3q5X61eS5eRJBRI04zneOwxE73ZqOCadY5TwFIXyNd6zSn61Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eJnQaQiCd6n6+cCQ1FL0qHpamD8EdN+7skY0vIODFyIPeToX7L04znO18L/0kswbwziTxbE04fsmaBiW2Zz3OeV0L3XhzhT640SjEBJH5uOsB+hDHbgKeZvk26uO853UeJmQzE2oTu3Lkh/Rh8t7AEw06W/9B61Rn1V/BCzPuH6p74VgJfjoVd30oo+oTQOBC6dj11+VNhn/mHVYmcM8YgVHZ0oKiACxhjigA3qMijJZWcJuZQISQxBH3n/LsUX+/QyY5qFh8RMDTm+yEz+Qw+wE4yr6l+QgK2dsb66znNUgE1t2whQ85WKlCAUeH6+Y7Mfnt0k6X1eBk1CZbBaKIRHDlYk/4FbP/13hmgRvCgGWajAIr9Mfgp9SqRLVTXvdyiQclW54Qzx7umQNH5brFVeSbjYl5aDRbdMtb3iS5gm1/g2Fadu1RwatQ3Y3PXoiPZcrZiDEXzNqOJmTbH5bDKi6lOFoyro9B9VbBHgn5ehYJAJyPdl2lg3CzvimHcBM6bPwyuhJii2GQchwxeWgKaG5BWnWVtHgnjSfjI+hDMtuUF7wUVSJWAiBOyoue+5Nn8kAWH8rGlJLkc6u3AptP3p2o1pKHXfchFluaAVpsso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd71a154-09f7-48bf-0cf0-08dea516e588
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:29.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXifTYOCnr1a6x5gxg41v3MHy+YQ8VznoAl89v912z3XX8eNE9VUC1oiEKsi9Y6hNRAysEGa4xz/olVlvX62zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69f095e5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=BfxcaXdt0Lgmg1IeN-8A:9
 a=yzZZxD1ETDaWDB-n6lAJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXz0JetD5YVxaU
 jQByfbfiGW8WBgzmLMUXBvdAocXV6KG/W3s45Yv6AzEt2AMdBimOkb7poh28NBmKWwhh/mTimUd
 w4R5tiqk0BC/fIWPEYKt85L5vwrR2q5dQiSyANAjrovoYUKjVtNV+zlK9BoBuqU8NuG2s+YZwQb
 cAB/f9vsR79gPCFtNjKgEefAJ+JOHwm4HPT7BTTjDOyii+byFFUV6mUUpYI8YEoG25356V5SqDT
 mO35dMgabyVskJbdSbeUDLpPtRK9+BKMwU1LLGhL3kjSfknJnVUyQ4yU0vYSiFIQe3BF4SJWfBe
 LFPs39MB5Tc6rH0UkFbVGQ1pES6a+sVjDRLvnWdvWEbpAR0g2hQFR4RUwShnqy4QY9srqvLUi9G
 iPDEIj7BJhsyr5QxUUoo268Qpj67swzgfGdYwlNqyIIprMq8e/OB7nTBE3aK7gfRXyf3+EugOrU
 OgAmtq7/jDuPPfitiFg==
X-Proofpoint-GUID: S8T5TjtCV91HXEKUIuCqrTG46VWoM6xb
X-Proofpoint-ORIG-GUID: S8T5TjtCV91HXEKUIuCqrTG46VWoM6xb

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 91 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 3ac77c089a58c..6afbf6ae1d2a9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -40,6 +40,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	int (*add_cdev)(struct mpath_head *);
 	void (*del_cdev)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
@@ -61,6 +62,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -76,6 +78,10 @@ struct mpath_head {
 	struct cdev		cdev;
 	struct device		cdev_device;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	void			*drvdata;
 	unsigned long		flags;
 	struct gendisk		*disk;
@@ -133,6 +139,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -148,6 +159,13 @@ static inline bool mpath_qd_iopolicy(struct mpath_iopolicy *mpath_iopolicy)
 	return mpath_read_iopolicy(mpath_iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index 69e48ca3169c2..9a1a8cb4a417f 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -53,6 +53,8 @@ void mpath_add_device(struct mpath_head *mpath_head,
 	mutex_lock(&mpath_head->lock);
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
 
@@ -363,7 +365,17 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
+
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -609,6 +621,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+		try_module_get(mpath_head->drv_module)) {
+
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
+				mpath_head->delayed_removal_secs * HZ);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -660,6 +705,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -705,6 +753,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	ssize_t ret;
+	int sec;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.5

