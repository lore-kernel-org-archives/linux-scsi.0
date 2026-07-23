Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968D142A791;
	Thu, 23 Jul 2026 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799442; cv=fail; b=U3ZQncQhCuL7Xm1A0ybfSizneU0cMVl6BYgO4tmRIXMNl12jVR8Ttk4P7uSrfoCPjzTi1ymRKZgG1buLhTahjYG4jajzMF9OHSG+UvOiEl+WQGJxuEwzR7fy8ICKxJs2Xrcb9vDbcmexplkRj2TOuWlBo+ZBfU9B3rYyZP6SI/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799442; c=relaxed/simple;
	bh=6BLGZhC1tLKl4Oc1WoDvM71/G5rdXBlPzZpyTL/dPv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DBVZDH5cUsQ2XpU0/33icjLOPB2jERCKOgB0HaOUfVOowDR8TC5ZrKqHcGPuIXTJk4B4+TSk8Uu4a9GSTOFvjzN57+Mp7FluRJzbvCa9NZuIfbjb837L2oeY1GeUQd8vDVz1hucaPikplp+AcfYwuRDsnxSXjILyeb5pnYEkPr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qajw/Pii; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Dkit2NNL; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qajw/Pii";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Dkit2NNL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtW7S071631;
	Thu, 23 Jul 2026 09:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AvpfttfNabO3y0/gu93AS2K/6m8C1erP9QEeV3pwhk0=; b=
	Qajw/Piiq/EzRs6nmUr34nrz4chGYm8kXxaQii2PBu/WqN3Za/p4WRs+I9VwxfDp
	saofrdW0Le0flNAlIjSaaoDv9b4MRMF/yqeF07QPEL76QBZcg5STJj2ShUxapCBx
	LvnVLQ0Sh4tf7NCymI88miI3JO9AG3psLwwIv0UYoZuZ2wMGPihY4sEy7AiVinWu
	g4Df8n3qqwheYF1r5WxcBBvFtetoC4OJiGevcCQKmTXtB/XsAoFe5vHR2H3+ddqY
	M8+OvoRzd43OBNV3nt3Y72Zhf7MdZMsDgOzMzxVmWnmL0R/f4yrdCToycqCNrumP
	zfUfV7huF+FUfLBAQ0jrFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n36sku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:36:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XA6S021265;
	Thu, 23 Jul 2026 09:36:55 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y3vu-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:36:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4G9gsZnlCTYv5awNXBbXFcZEMIjBKW1ef2IZzE4Rm8mDQN+dOouJGcXxRYckMtVhOPUVrWA1rTpWRvEDzjC04shb7N1R9fjKVYGL6gYZFMlAHxvs0d7lOPKjHe5jSZq6xLCupxipzNOHlGp1SY0wDVr0WbQUO2y104fxgMCG/tuQi97EspHrJq/6dGFQoff654Kvky1glRlsXX2lZMCyaEkEeHr1XsYoFQhfPh4tHBZuRPdTAK/oA311nYyqBimFoCmyB04kXK6RYWtYbJQM/B9oFSrJNwiUUUxEVD6O6XDTRuDtpC3+4xitutvMu2OjbO0jPfaamkvUfaxg9ZQbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvpfttfNabO3y0/gu93AS2K/6m8C1erP9QEeV3pwhk0=;
 b=KLmQhnBJRu5uyRE9CVDeT2P3IIDdzNLuoH70tpF7d/q7BnKTz6HMiA/IQte1O+HRexolyz2z8qLJL6MYKgGNw3lbwJFFdRewMEE3eq6mrw/gwNwppYpVy5Ltyl1D4kLIE/dUTFjfTyfZOuyB63b5WhC7d+XFQ0wUTW60SL27r/pomBwVnzEiWSJqRkY00rJkHRE5/Ma79ue9bZY8+VuoDbJu4GLXIqEkJtfu4Wz5D3YasRm5in6zbzMNnhnNYmvAIkAn98Sgu2QRVJcOtauo70emDUr/QyIQkuSK/2l40ThABsrH67n1RWETneBuN+wlBvNbiSgYJ1dVfKWeEHIokg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvpfttfNabO3y0/gu93AS2K/6m8C1erP9QEeV3pwhk0=;
 b=Dkit2NNLHzl+LQUTLcUsRA6v8nKKEMDFaZ/m8S016PivB+p152TeCe5Y0Ea0g2X80k0jAH2NJ6HpHTtuh15mO27usoZ5+L5z3CZ1FntQloblKezWxER6luGY77DMXLUp+bUgyrSg5rxpRbp3PhQB7f6NJutqAJCPHtXkBQVbAH0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:36:52 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:36:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 03/28] libmultipath: Add path selection support
Date: Thu, 23 Jul 2026 09:36:01 +0000
Message-ID: <20260723093627.2327456-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:8:56::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f6737b-9549-44ea-11b9-08dee89ded64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	2HciUGXLO4zwoKH0AoVrISX+ea9bg3c1Um1CprauEKj9O3AkY/qA/4Y0s5BcoRJqEXKv+WumoQQVRtFT8Il16XqZsCyY1bjXAQAYvtMnTqsqMTJp81ZB0grHk20FHKz91qYC5A4dbH6bmUDWE3YJhsJzhzvg/ceHh7nErQWrEVLaZXWq2ypVUKutW2T4Zm1YopCP+YtdPDZAKa9EKnZU76FYsmzycAr3qhl7FAqQgcymKJdbGQQBwEraeEPF4qKvIzUv5DNaVNvYzrv7Ca4sdNh2D3MIfM5W2FpbTRaHIx3KkOp6Qst9YXZEJIlbgeXY7vB+lOB1KTtFIk8L975GsebbXMURglTpbwAQ6G/YCX1G+jGdsHciRT+/VnAV2hBE3JJa1LjxvzKxGb4ILJvCTe9mELAfsQXrF21Xqd94l+cyDTzDLn2Wm2ynxu0OXzaoim3dKuH5dC8s5KSg0uIEe70mrHERT0Cfi+N/lVXB+72Vykt18Ei3d1lzvroKg/0Pc9eU8qVzKggCK34nWqI13wWRmvROxOWtwongh1n2ll8F3fBYmCx4PCViJv92DwVddVctMYTlszk1lVQNXZk1yVTR+5hXAn1IEwfCKaWmljB7QLxmIoMocihq5F5v3U4aU2CptVozqWEgIjikANqDPwAnYvAHDq5PyGCiEdE3OdM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UBzAwTb5B8LnHK3fgD6pU12oWWqFlt8T6A59c32gUplXb6akWgFmWDq0f15B?=
 =?us-ascii?Q?2OCV0LqG1F1TAYo48njewAWOCV4S23jklSUQJMNsg4zBIX6u1yoZi2vNYhyf?=
 =?us-ascii?Q?J2stnLGeaUvTPnzj7SsvV6BwxmhauMnCMdec8Pzlz0Kv/FMnJF4F41f9syLk?=
 =?us-ascii?Q?iFxJ4xtaSDTZPmAWZXGvtgbNejWB6wtw6OiHwW3oQkatTUj9zlj+1Sr5Sdn5?=
 =?us-ascii?Q?z+F4ZUGM3rfmqJ3isdRiD/OBZaiBCm7ppbaKZAbEjY7WQ2KIE/LnWWwvvj1K?=
 =?us-ascii?Q?yE85NWcoMFT+i6n9nPZC7rk/HxbsLtS212lTK7v4i9AhmeiMr4SYJW/JxmuN?=
 =?us-ascii?Q?dvoCnUO3V9AH356+0QJO0kCeTQXCxvVE8OVhN0zrSyVQwrw7UE3FoXYZKMcc?=
 =?us-ascii?Q?QPEPB9iXgwEH90lzoYF/VRAbZ2R8frCOyoqylR3pzMM51ctPLwH8xCmSfhBt?=
 =?us-ascii?Q?GU3x59KQfD0YT6pPVjJNkN0uhOasrjrM93/oJi6WkSOfUypyjGy4PzXee34B?=
 =?us-ascii?Q?Kf3BFdpPAk6fq4aCo00RCQ0erjQRe5zILysCbQGaz2+t3nRLmaFQPBTDlNtj?=
 =?us-ascii?Q?pMDJbDvdoqCIyrD7UW9la5H7CabL+zb6dBWipXMtEKZS6I/byzaDEUIFjn9g?=
 =?us-ascii?Q?Icz85s6/Ww5r8rQZpbhEoZOx265+4/rlR0H+pt7ZcNlDpeiyC7/A9U37qUae?=
 =?us-ascii?Q?yrHzQQfu+V7GtRfnkoV6JX3tvmypk3xNPHcYe0VQ3A9no1AhDv3fZrQkOEBO?=
 =?us-ascii?Q?vPbq1CAcWge25le2plocmVOX53Z+FxDv3t7F20bny9m4xqsArRzalRHN2lm/?=
 =?us-ascii?Q?VqLI2l/dbau9VGXP/k+5WigKvUSmLRyW8XiajOXB7WkKr3Wnlp/6sX3I/Nva?=
 =?us-ascii?Q?DWztDfl1ZOGPfpHOO8QzwBV/LlBH5w57PAfVW2/otxv7B/VA3/an+Mgh2lxJ?=
 =?us-ascii?Q?mi6BNKTENFciFPL61sFIQGw/Fj7EKwIBAF68HSBmQFfxmVduUH2S0liUGsMI?=
 =?us-ascii?Q?1Xm91kle7gPafkFdqDH9RTIQ1gzaw66YGvXY24wyOlrjT9tHTIIEWVGHVEcM?=
 =?us-ascii?Q?9PuxZr70v9WxQv/h75xFM0UVNB3jVxpGbDQE3bLHniSlNupdzRv3H8ssjqeB?=
 =?us-ascii?Q?hUiNxU3TZVmSnBG4ar6bizfOHz8Bodsv6J5e2ORLEWMnh/Ywier1OhP0SPjW?=
 =?us-ascii?Q?Vz4PWXbf4aechBt0MvwoiwGwvjUNtbLgayWv+y9DS17ebqD3N0Pr9a9NnOds?=
 =?us-ascii?Q?aNtgqHiVDrbm971n5kEwe/DkNH7PCLJ7rQXDA4xwT3MbakPmlYhOeEDIvTc4?=
 =?us-ascii?Q?0mQNnDI2C7jjYWToyLNP0zgZlvRle/JmhWPHpoZvyhft2l/QJtGzU146zn82?=
 =?us-ascii?Q?qRDdstG1OiLTyJBhsU8vPwFpz+/0b0rWvE5nugX4oU70t2g7XjobnOKHfb2w?=
 =?us-ascii?Q?+Gev3bpHaiXKMNhXDA8ZfFZDCJlF3yI+fyJcpmZhNLBTkhyMnBm7hf3zA2rT?=
 =?us-ascii?Q?w4MRGG/qY1jy8WnwG3SJqBktvZHM4v4Z0LBlZqwUKpvj/OjqWEl14xbXUk/2?=
 =?us-ascii?Q?PZBdVxWLanPyNuiZNjdnfdOu37TKqj8Qaq0Q3mGzhzKOgT6DqmB8jxOR/tzd?=
 =?us-ascii?Q?a2DJg+VIze+1VMpQiCUFsm1nj1JlbbLz3SRZvhjzlx5MPD+ILOqHC+JSEhZG?=
 =?us-ascii?Q?FRz80aHmVFZ3Q1KVtaC62Wz1JIjn1RwEItyHxP/T/g86Te1RAqMBX0xMMDoG?=
 =?us-ascii?Q?QBtSHVG9dA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	hrldO01UcQnMHVAEchLztYz3LfVEDNJ9iJs2Zxte6JKcifdpMytmK0Pq+HTWHxxznr8QCZJyI0OnMN2KLBM2DLRgB764hd1tMH6ZJRvKsTZoKI2I59OrDyimAP7O6s6Ff85yuXkoWXJzbePsM+CFiF3AvkvCpsMrW2Hofbb+/iTnMOzfo9UXxBocvHy9A+HgV0xW9sR0vefIVUZZLzSggYPZzzG6okUwyagaN+50zcX9nS3jEMTi9qVQRBOX7gJ3VelW/ZpUcKUvPJiu/MUrPDSWmi1t2zb//WqL3045ptUK/20CuONypG0wfc7N/7/8GZV/UEOFIiyZfOAw4+7ldQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VJbv5rv1uzmoURudaTAzP2d44R6wwOJcw9UncTp+ApajfoNqCBps/p538XCVQIJRiUbqQMHIOmwiua3/iM6JeDSu3ZIvzXRZRt36mA3t5WolQK50/dSAMhNN5lxH6VuC6CeTSpvlIoXCSmX5EPIj41FYtSiUQX2DGmc56TZnOYxc9lwrfU874c6opX2oolukteIO/+ejMdC3uGGHschh8TohwRLGjNMZZU2uHUKslR77qc2VCJUjfeUEP7smWxVgq01f137bXVMs1WiX7KAnn0163xT/P2BZWodOsR7sUgs4DlNt8N2EG47+E3EvCwLzkZ6Sj7gY6UEDSqagyJzfVsfJhy9IvNOil0ki2rHJ3FtEUe3AYQGL0coPjGTuMx3n5RQyoUPzv2D3v0B6X6hEFJaZ4nCGRfe8VBYN117yLBT0K/pqhS2cwLgisdqsM5lp+Mc+HXhnTGaHrd37Kos32RqpblrEcvMAhAXn9lxP8vN60IR0D1fNeD+09NI1+OjgULSqpwttJftjg5HDwVlvpkxc3z4NmkQ0APojIkgPa1/5S+4+PWMMEqZg9+3wZAPr4dPL7QXIrT+ey+v6pCm5envMmNX6hLRvmfdZUcZ/b0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f6737b-9549-44ea-11b9-08dee89ded64
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:36:52.6533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOAbSo3O0Bhwmhi08viTvoY87sk1dMJYIGFqSzEtbhzY4iZIGUGuu+PLmNKRE7xD0o0KBXsooS5sg4QsZnV5cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX5BX3dVykCY6P
 W0ELwl/E1Ne2GdI5FO8eSZkvHRGW78L0/zGsSllM4k41hvFu+gYECsAktGSUPqsjzsxRA/gKznQ
 XQk18cVqFEoqeqrUHvHkxegllPVSqHswqKMybiU9MEZ/PL84UFdMpN5Zp3IaWqVEslLiXtJQ5+p
 9BGcZsOP2o5SyoTMkpjlZO5SsS9RMKtH8IyNeAdx/K6ernOgQXfybx0EWwbvc37TU1duhD2Qse8
 AmMmOlbO/Zugr7FKoEATA9oL1SP5V9CIiTr6OhyOC3JSXCzNAD1RyVVC7U2/Yj0kSDdINSH3m2T
 j8qe+V9eGzsa/dXnSntXGdVbq6zvLikghpW7AEdLlBCdhT3iXnbgvxQFDlXyS9MCcoQznNzxAHg
 d7EwsoMdtCH2y2YdbXbmXuu8/BESD1PLO9eLU//eCKQdAQL/C+jpKWzZLTUsqfm5FayZuKsHUOj
 jLvCnFTjdGIugEN2IRQ==
X-Proofpoint-GUID: qN23QEELbo5dRKZtpZHh4wAd6OjciaY8
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX7PKAauO/+kow
 IWIUreXrLiCqQIyDFYCFiQ6CrdNphWT6mm5SWMsZSX3H+MHxgcTsMaIlgfNrMvJekDeh7U8zXKk
 Kp3/IharKHDrevRuTEjvpIbVrIRfuWGR/zH7ybgSK2GS/PuCIuiX
X-Authority-Analysis: v=2.4 cv=JrfBas4C c=1 sm=1 tr=0 ts=6a61e0b8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=Lb5UtHSxAhypNmDEWQsA:9
X-Proofpoint-ORIG-GUID: qN23QEELbo5dRKZtpZHh4wAd6OjciaY8

Add code for path selection.

NVMe ANA is abstracted into enum mpath_access_state. The motivation here is
so that SCSI ALUA can be used. Callbacks .is_disabled and .is_optimized
are added to get the path access state.

Path selection modes round-robin, NUMA, and queue-depth are added, same
as NVMe supports.

NVMe has almost like-for-like equivalents here:
- __mpath_find_path() -> __nvme_find_path()
- mpath_find_path() -> nvme_find_path()

and similar for all introduced callee functions.

Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
setting default iopolicy.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  33 +++++
 lib/multipath.c           | 254 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 286 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ca8589d5cd8b2..6c75654c12f8f 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -7,13 +7,31 @@
 
 extern const struct block_device_operations mpath_ops;
 
+enum mpath_iopolicy_e {
+	MPATH_IOPOLICY_NUMA,
+	MPATH_IOPOLICY_RR,
+	MPATH_IOPOLICY_QD,
+};
+
+enum mpath_access_state {
+	MPATH_STATE_OPTIMIZED,
+	MPATH_STATE_NONOPTIMIZED,
+	MPATH_STATE_OTHER
+};
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	int			numa_node;
+	atomic_t		*nr_active;
+	enum mpath_access_state access_state;
 };
 
 struct mpath_head_template {
+	bool (*is_disabled)(struct mpath_device *);
+	bool (*is_optimized)(struct mpath_device *);
+	const struct attribute_group **device_groups;
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -25,6 +43,7 @@ struct mpath_head {
 
 	refcount_t		refcount;
 
+	enum mpath_iopolicy_e	*iopolicy;
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -44,6 +63,14 @@ static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
 	return mpath_bd_device_to_head(disk_to_dev(disk));
 }
 
+static inline enum mpath_iopolicy_e mpath_read_iopolicy(
+			struct mpath_head *mpath_head)
+{
+	return READ_ONCE(*mpath_head->iopolicy);
+}
+void mpath_synchronize(struct mpath_head *mpath_head);
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
+int mpath_get_iopolicy(char *buf, int iopolicy);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
@@ -63,4 +90,10 @@ static inline bool is_mpath_disk(struct gendisk *disk)
 	return false;
 	#endif
 }
+
+static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
+{
+	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
+}
+
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 916d01a285284..20bb8cb0ea956 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,8 +6,245 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
+
 static struct workqueue_struct *mpath_wq;
 
+static const char * const mpath_iopolicy_names[] = {
+	[MPATH_IOPOLICY_NUMA]	= "numa",
+	[MPATH_IOPOLICY_RR]	= "round-robin",
+	[MPATH_IOPOLICY_QD]	= "queue-depth",
+};
+
+static int mpath_iopolicy_parse(const char *str)
+{
+	return __sysfs_match_string(mpath_iopolicy_names,
+		ARRAY_SIZE(mpath_iopolicy_names), str);
+}
+
+int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy)
+{
+	int policy;
+
+	if (!str)
+		return -EINVAL;
+	policy = mpath_iopolicy_parse(str);
+	if (policy < 0)
+		return policy;
+	*iopolicy = policy;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_set_iopolicy);
+
+int mpath_get_iopolicy(char *buf, int iopolicy)
+{
+	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
+}
+EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
+
+
+void mpath_synchronize(struct mpath_head *mpath_head)
+{
+	synchronize_srcu(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_synchronize);
+
+static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_disabled(mpath_device);
+}
+
+static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
+					int node)
+{
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+		srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		if (mpath_device->numa_node != NUMA_NO_NODE &&
+		    (mpath_read_iopolicy(mpath_head) ==
+			MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node,
+					mpath_device->numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    found = mpath_device;
+		    }
+		    break;
+		case MPATH_STATE_NONOPTIMIZED:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    fallback = mpath_device;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!found)
+		found = fallback;
+
+	if (found)
+		rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_dev)
+{
+	mpath_dev = list_next_or_null_rcu(&mpath_head->dev_list,
+			&mpath_dev->siblings, struct mpath_device,
+			siblings);
+
+	if (mpath_dev)
+		return mpath_dev;
+	return list_first_or_null_rcu(&mpath_head->dev_list,
+				struct mpath_device, siblings);
+}
+
+static struct mpath_device *mpath_round_robin_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device, *found = NULL;
+	int node = numa_node_id();
+	enum mpath_access_state access_state_old;
+	struct mpath_device *old =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+
+	if (unlikely(!old))
+		return __mpath_find_path(mpath_head, node);
+
+	if (list_is_singular(&mpath_head->dev_list)) {
+		if (mpath_path_is_disabled(mpath_head, old))
+			return NULL;
+		return old;
+	}
+
+	for (mpath_device = mpath_next_dev(mpath_head, old);
+	    mpath_device && mpath_device != old;
+	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
+			found = mpath_device;
+			goto out;
+		}
+		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
+			found = mpath_device;
+	}
+
+	/*
+	 * The loop above skips the current path for round-robin semantics.
+	 * Fall back to the current path if either:
+	 *  - no other optimized path found and current is optimized,
+	 *  - no other usable path found and current is usable.
+	 */
+	access_state_old = old->access_state;
+	if (!mpath_path_is_disabled(mpath_head, old) &&
+	    (access_state_old == MPATH_STATE_OPTIMIZED ||
+	    (!found && access_state_old == MPATH_STATE_NONOPTIMIZED)))
+		return old;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_head->current_path[node], found);
+
+	return found;
+}
+
+static struct mpath_device *mpath_queue_depth_path(
+				struct mpath_head *mpath_head)
+{
+	struct mpath_device *best_opt = NULL, *mpath_device;
+	struct mpath_device *best_nonopt = NULL;
+	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
+	unsigned int depth;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+
+		if (mpath_path_is_disabled(mpath_head, mpath_device))
+			continue;
+
+		depth = atomic_read(mpath_device->nr_active);
+
+		switch (mpath_device->access_state) {
+		case MPATH_STATE_OPTIMIZED:
+			if (depth < min_depth_opt) {
+				min_depth_opt = depth;
+				best_opt = mpath_device;
+			}
+			break;
+		case MPATH_STATE_NONOPTIMIZED:
+			if (depth < min_depth_nonopt) {
+				min_depth_nonopt = depth;
+				best_nonopt = mpath_device;
+			}
+			break;
+		default:
+			break;
+		}
+
+		if (min_depth_opt == 0)
+			return best_opt;
+	}
+
+	return best_opt ? best_opt : best_nonopt;
+}
+
+static inline bool mpath_path_is_optimized(struct mpath_head *mpath_head,
+				struct mpath_device *mpath_device)
+{
+	return mpath_head->mpdt->is_optimized(mpath_device);
+}
+
+static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
+{
+	int node = numa_node_id();
+	struct mpath_device *mpath_device;
+
+	mpath_device = srcu_dereference(mpath_head->current_path[node],
+					&mpath_head->srcu);
+	if (unlikely(!mpath_device))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(mpath_path_is_disabled(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	if (unlikely(!mpath_path_is_optimized(mpath_head, mpath_device)))
+		return __mpath_find_path(mpath_head, node);
+	return mpath_device;
+}
+
+__maybe_unused
+static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
+{
+	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
+
+	switch (iopolicy) {
+	case MPATH_IOPOLICY_QD:
+		return mpath_queue_depth_path(mpath_head);
+	case MPATH_IOPOLICY_RR:
+		return mpath_round_robin_path(mpath_head);
+	default:
+		return mpath_numa_path(mpath_head);
+	}
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -75,6 +312,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -94,7 +332,8 @@ EXPORT_SYMBOL_GPL(mpath_put_disk);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node)
 {
-	if (!mpath_head->disk_groups || !mpath_head->parent)
+	if (!mpath_head->disk_groups || !mpath_head->parent ||
+	    !mpath_head->iopolicy)
 		return -EINVAL;
 
 	mpath_head->disk = blk_alloc_disk(lim, numa_node);
@@ -128,6 +367,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		}
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
+
+	mutex_lock(&mpath_head->lock);
+	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_head->srcu);
+		for_each_online_node(node)
+			__mpath_find_path(mpath_head, node);
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_head->lock);
+
+	mpath_synchronize(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
-- 
2.43.7

