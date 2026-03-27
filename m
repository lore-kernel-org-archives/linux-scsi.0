Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7376364925;
	Fri, 27 Mar 2026 21:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774646743; cv=fail; b=FH2SvqHvIxtZ6kQYZKO77iX035t1DFeC+fUgglCtDOlZHY69QBp2Zqql0TXbSL+VRqetpb8uQ5SyGzciSchwoswZnwwvcvYy5Sai2SxjUYblJMPJN3SBwRaJ2KDr2BiZfbGb/Usb6RjF8npiy1vJzJGO17o4qYGMzTzPo3kZicU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774646743; c=relaxed/simple;
	bh=Xears1omE0uIJPJMKcHSnvYUHhmdJK+Bqr7yB2gXUu8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XYXFipmysjw0ojRQmTD1o2jF66S/piXcZrBrEa8HAiuv0leMtVl9krY6NXRjx50s7NizH480ANfo48ad86yVFFkiZ/JtbSkrJNYJt90SvYv/H9ZliWb+uDX9w/c46Tjq0jJeK3UUjHw23UtaikHzKPiPVT+dp5mAGCHjWSOPL4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T2wh0P/3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SD7bW+wQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T2wh0P/3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SD7bW+wQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RGu3213575414;
	Fri, 27 Mar 2026 21:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cd5uUH6iYAM/sctUzc
	Rfn+LvtaQb++INNgjOiXvBkDg=; b=T2wh0P/3327VIjzQU2bsndAI7I4agMykxL
	S36aZDGU8NCrQjCPXg8sPq2qxE1oTvPVGP0APXimqGGp7ozRGA4hji7pHrv9KHa5
	iY5dA2ViWiMbpcZWhWFe42W8O3+9gju/GlX+crRc5SScwqgzXjlYdwvZfHs9U4Ni
	Jdo9CzZ/jzsl02bkgKlNKrLU4o9s+ir8RrbEtKMC3qBag+cgUPR7Sv08lHjS4XhE
	+fd4TTBZkiM8JaAMrQBcNXojKlyZXZ1aZePg2uT4Fu4k3U++XGHi9nhgyOe97L94
	eLMdCh1dNqJXGBMHwV8v7YWRpkR9hxFUUYocRPDmkR+L7xv8qmEQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kvntwuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 21:25:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62RJq4Dv012307;
	Fri, 27 Mar 2026 21:25:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsn04s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 21:25:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGHowcs0FGzY3rlNxUpM8dt2G50Ghqvdnv99ORFImRuOpXvOHXPD7NQUsYG4d0uDtqEvOsbA0JWmbJ6+DiPovEH6LiB5itlRBtpac7fTfive6Gre3WbJwMTsRW3Y2owQnAt1TYpOGNWGcEtcDqwrGZaypPi7yhfhfKq6Txj7bZjFum3IpJMukvBoTE5rJaykxgu34bnm2tooSZeKiGUDq8S/gVm+6EiJelKT68uynIpWlvysfnnYbkWk6WMFyUwLTIk0jTifbPIwY4wsgX5WP31+4yGcV6Y1x7/VzY2d5iWh0bOod3e7OY81TA1uK3DVuOEDOvLSaGPQHS6masVg5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cd5uUH6iYAM/sctUzcRfn+LvtaQb++INNgjOiXvBkDg=;
 b=ELueBcW90Tu3h9JpgZP365RsDdEuzJ352wMn7Sq2Uau7eJoi5Wb6ChWkpwyuFIdctQgwyt/3Q4GBXjaUy6oMN79saGUldjPXg+8GfRYLvGYZRAHkJWr36iplDUTh3nPWbRgk/JuDejw/0bxeQqsI10G8JDlvGVuYDT8Qk3EnPl6xixVdFd2NdUXSkkMEfSmcyeBpvP7y1ahdK3WtHfWXmweVaGXb4jkP5aJBZwwW7b71BaXyod6fra/YeCs50TR96WhLqXh49pjoT+kV14nduM1jVyYgKSbkap5KUmGHHrgdiGMGeoo3B/FOKkx9amvcU1OZ8wzw+v92AguPwMnV5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cd5uUH6iYAM/sctUzcRfn+LvtaQb++INNgjOiXvBkDg=;
 b=SD7bW+wQaBZkOlF7Vj/u8o3ciYFj3SRWu3qdwTwRZg4ZvkrCxUUICg2ysoT1McCwJ3qbaevcydf2oFNpHPb7zlZCiZ9w3j76fpgx3wAoDzx3dj7whJMERMstmayEqkIzMm1/GPYpsabBffe6+mzCupHk/WCKl6YGHAJy5+h19+A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6879.namprd10.prod.outlook.com (2603:10b6:208:421::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Fri, 27 Mar
 2026 21:25:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9745.023; Fri, 27 Mar 2026
 21:25:16 +0000
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC
 support:Keyword:mediatek),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek)
Subject: Re: [PATCH v5 00/12] scsi: ufs: Add TX Equalization support for UFS
 5.0
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260325152154.1604082-1-can.guo@oss.qualcomm.com> (Can Guo's
	message of "Wed, 25 Mar 2026 08:21:42 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jyux7yok.fsf@ca-mkp.ca.oracle.com>
References: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
Date: Fri, 27 Mar 2026 17:25:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: c13b3b93-661d-426b-e2a2-08de8c4756ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	e4IWbbGCuH8xj47YJXqjvs75DF+TsXKlLI6xypOEZUUAKwM297+CPUAaz/tibBpY8OwqPRv65xzpoxayVMJ/VtgGi+NdP25skI9kcduHN+GMmeqwUs/iu0B6OZ5KdaKj+yJLo+SvDyIPujp55HLFv9qhtZRSG53g8t2gI5FnAOrrpdzbqfVsHumhfqHHIjQJM1YwXsdl/o+ZGLdpctPg/LI/iuOS4+UGRmWuJTqvfAMJ8vwRAEhgOAj6Tv197BbBZ26pAcwy+SJAGX4a2nSZDbTtZh8ASX4lWRjbBqK9Xm9gOz0h9wCoDHGuvLEPQmtTTUP5ZactzC/9BucJrDumZFsbz3bfsksM46TT+59K25t5Wk752uu6bLXA5+unN433HNh+0eQY6wdgekgWq5AnkjiCk0P7/JRAjepOhW+ydXuy9FgTHhpIQcPHZA/+W+Ujc1mu7myk3JNyxhdH7i5CocoiJbgNfHhg0mE5gtQOz2PUWtks9TEodTB9/3bEvLp7Lz4LCLpb/ppy3XqXlax5OJuC/xZrth/igx7EZg5peQGUnHhyBc9od0qw+SfTKX+pLk8c+iZNHE6abfRm9FHOZdYQRGuCElm+PO6h6o7nAhfiOw5BplZZEWA3qaTodZjdVnHq/7H2R12gAH0CX/15vZAeo57LmK1CViW8t2VMum3Pv0SqLYCIwtj3jUO4EPclW1TnzP/8y29rjQ10U1svmmGGrgJgJJE9bGzsKFwnrAI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eLyXYbOqX0Fpz3vHwgHufcpgHw+Z5z+C2wqu3tfVYNBey7XFkiafaBKthNN8?=
 =?us-ascii?Q?9UiM9bpE05z9+WXlZjxig766GJ0kqpSW+WNDqLcXJxsYvilKoaA1cF2oIo6u?=
 =?us-ascii?Q?N7+TqmHksATSHkeslNK7o4Govh8Fdeq5sd0sRAZ4lIFi41YgaX3PAytAoZ7i?=
 =?us-ascii?Q?d/imA+P1KxwHJtNb6iGLJxUkZTuge5FT/3TevPgVbPCqFCF0abMhiRTqhSOz?=
 =?us-ascii?Q?EZiDL7Sz+2utwPUh0qdY5mRFUoUv9jgkQTrjbJTEHFYBfBZ2vFg+brlQt3pJ?=
 =?us-ascii?Q?4igDawmimjA8SkaY5IUvU7wB+u3whgsZjP/BkM12yawYABktq9I9yDS+cnBb?=
 =?us-ascii?Q?9xbWVFnH76BkrZ5glfcXn18km1/TX/38/D8LZiiFhL9NKfq/GmACWfRlSiXo?=
 =?us-ascii?Q?W0UuhebsF1OG53I+EmTD+J1iveQmzAXd/DYACFGaHYoGKl/tre+/SFPOVaFe?=
 =?us-ascii?Q?9bjilv1IOHVTp2G+U0NwFcpVlYIsQIVzarQoTsZuS4QkdRMCxIgkNUs5rJ0r?=
 =?us-ascii?Q?c6uYWbrHObkkyQ8k7O2L6gIn+FnKglbrOlWAV/28LOpZGNe+oyRH5Jxppz5Q?=
 =?us-ascii?Q?WI2P3ULNmCvRwqfi3pB0RUOCHPPZo/KTzw18Eada252M8uRuhP7kvXv5pQNe?=
 =?us-ascii?Q?xCdvTOxId0j/kSUbA8EvtILTLpnM5vsjMOiqX+MrXf+QwESM5TA5r8GCU8YG?=
 =?us-ascii?Q?K8/l7IjLdWS/ICf18D+VvQq/fRrjKbMhLRQC2Exl+kyGa8RkdSUhrCdVJBSn?=
 =?us-ascii?Q?ymlrOXo5W5a9tEx9QT46d3CZ1cKeveDdo0Yd2z+gZ7zqKdaEIqvPtjbLqihd?=
 =?us-ascii?Q?dyoV/mK8At7ZdV6BTEh+V9+lyZoNbKDG9HeWLZzLGiOUGtQDigfBb3/HbGwI?=
 =?us-ascii?Q?d4I9Gf1mAPJ6t0EellCAApGI/Qq8lKdzdBZN6UahomSWYd2lmANyCRqFyc8t?=
 =?us-ascii?Q?ggLqFERkxcudgCO1gMBTLk0a/7b0HWB88KZzfXbw11sHdq3JtsDSRZ9fGyGv?=
 =?us-ascii?Q?NyH36UJZWg/qq+AaofUgydsu3RQlL99HmTSQL9PFIsTVrkrC94OCaIxikg8+?=
 =?us-ascii?Q?4/JqJEf7TCvt4ay3bXUIpF42E4mCzPTeacRyB0CGghMLjZX96bBYIqZFT4Z8?=
 =?us-ascii?Q?3InVd11UDNLKjIiREF1ZnB9t9qXafq/Qkfb08RyPU4PPS5rn5xtUakYv67O1?=
 =?us-ascii?Q?ZcpnzWk8jfmLC7zfpq/xKZnUdKsV2Cl1q3nS1q/GqY65xoopYmnNgMaeRJSp?=
 =?us-ascii?Q?Q7DO6gKjkPL3Sr3k5u/ziCQCqtPOukNd6dRVydi5R8Mit7ZtR9FTNuK3ctjP?=
 =?us-ascii?Q?IOK9EyCvV40ifoGKQsYZp8SROG+eAY4hOGvV0I52yeVX0E1+6P93ilP2Fxbq?=
 =?us-ascii?Q?NXgYq99vR1RXPgW9V3MJH7zNasX43wWWjl1R4q3G7w3YQSgQWn5ajoT2rSKi?=
 =?us-ascii?Q?dDExbklUY4p7DX2sPvlRBN/BsyRtHR7G6hJtG8qIyAtTqkEpE6sDDERvFEwx?=
 =?us-ascii?Q?mvOXZuOYs3PZUsjQMu72grVqRnR/1cVP+t1z/0GR8PQP2aXxxvQt5DWWZprp?=
 =?us-ascii?Q?fZR1DPYenJ1iExUYcpkUjqIx/B0GE0L5HYKiwqsMcezUVpM5d2oguWvvSN2N?=
 =?us-ascii?Q?BOBWCUkhLJWTLZOSTMcjXZejpz/jPPWjnf5DaQiGIXd+BlDsHy2ll4q+FKDu?=
 =?us-ascii?Q?RMoH6kb5rFb1oDsQbrhZqU+mCAuaI3NmWDUFT0P7vIp885wv/JXmHj5egnmU?=
 =?us-ascii?Q?e/66MKzL+dzCbD4Nq5BIRNs38rSPdZ0=3D?=
X-Exchange-RoutingPolicyChecked:
	QWQIZ6pv3BYtFI9B3vN3xxeI+G6CfAcrxtMacLcPfnJu+rErg/YWYxqQA6927LLXHFoiiQWbLsMnN4eFxJNZsUTZsOMm8cmIWNeiPqfK2NfLOpm7i1+5BcSS48RkTZm3ettkA2JIjzN/qMH4Moi0aFaa/R3xvFpgjxEyib9bWxtPetB94EBg+FNedjKwy608Pr0kYbrL8N3gjSLzTVoluKpriHhFxN8rnPksPCJHkM97AOUmja4vCGUuJfXng3Dq+wYNxzRoaWz0Tdbo4RQ8ii1+UK9OIXSp4dzV8OUuISyTtQSktQHeGIojBF3dpqbpgSdibs46U01NGo++ETHBPQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nng98+KGrKgCvjUzMXDL5UEnvZDT3OYqUMI3Rl3HA26IMh0EpQwSrQJHWHW41RpRPHjgJTWLkUXzPbRjCIAMGHSi8VOiYBS9dMfxGvdRAHj2BA5XORyx8CA9/AAGeeiJakhw744vTsszTZRPiH4fKruEItEbgGz5rEH02T0Uypu3REXih3EDvHy8A5jLpvPsEVPBzD3KEfFUwl3reQ+v+ebTfAukUV4FLvimbU+r8mS4c4Jm9sjKzTQbvSZHCBb+Xn/XiA8crDJ2N3blWAkySAaK0WN7i6h187NrW/LjfGBXq0yqW7WpTY61Hc90TuLmuyfFzD99BxaAQqYsaZ6LW0GLduAR3qHtBgrwsDJZuxG5U24nkkMwnXBWUKEX4Mh5I4b7Are9vZfJ622o/BrVNh4rg+klH4JK7RILsM4LB478WZQyxNodcVz/3xCkq7eMGq+/RMYHUjFmQ2gd7ttAh8nCR0Q7IQghBgekePlTE/5jJ9+uR60eMAvIoLm+O/jusNQViZxPqrfdwuCJYxC+yxqPLI6a3+dcTm3CMXxLOUMPk8gEPIiZKISZIv06YpdI/Dxy0ZQxN2JQWGUM/U+lD77k5CZpI7cnbpByU91aXBg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13b3b93-661d-426b-e2a2-08de8c4756ad
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 21:25:15.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z54Vkja20x+ZsLWvTa2nBsvR/g/OUlcIoiAcf2dhM4rU9MGLjD5cf8xflB+8Sd9MBV0FKDfS5VkHC6fx5BOPEdvd6sVLEd3wZeKOlxYznxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6879
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603270150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDE1MCBTYWx0ZWRfXyrERv4P7gNnI
 zrmu/JQ6P1f/gTbe1WLN7M4E3oYvqFIQG/Rx/57jq57MOlOcuhqg32Yz4+liISDk2L1Shte1PWW
 hetjGqatVHiUPMPvfy+H+Xg3znX5reiwJ111URQrX3xIZT8Ad7jZgxoHlf1LmBqeZ/nve0gKSUH
 OxCEtZBSSj7Pxf61yQc/UuqEtppATPzsDS3mHCD4aLjwLpjMLcM4pEvqrUcWVJ8bMWqLJa7MEQS
 VzHdE7Uf3jmFCKsK3iRr2XLv2AFjtiTy//v34hwbNmhUI5gULR1zpH4fQ6XNyubRcLthGcpWHQ2
 39egD5NY5G4BA2XeHxZf+N8E4G5T3DyAaQleQThsFtGb9lCBWSvgjB0/hnCFbkoznCQoPKybN4T
 MMD0s3dYR6si0+59sqHcIqKhWuRZFc7gc56lbmzWkS2+ADDxLw0ZrMGNGpNfuLjHU6eHmhLL8st
 oiVU3m0F+syR5K++SIzRs6259eaiNy4btJeuwCo0=
X-Proofpoint-GUID: 2vGVFJbs_xpQz-qMYsU6XMoqlP8-Zt45
X-Authority-Analysis: v=2.4 cv=GrtPO01C c=1 sm=1 tr=0 ts=69c6f5c1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=52_T1jr_FX7imiZLLDMA:9 cc=ntf awl=host:12275
X-Proofpoint-ORIG-GUID: 2vGVFJbs_xpQz-qMYsU6XMoqlP8-Zt45


Can,

> The UFS v5.0 and UFSHCI v5.0 standards have published, introducing
> support for HS-G6 (46.6 Gbps per lane) through the new UniPro V3.0
> interconnect layer and M-PHY V6.0 physical layer specifications. To
> achieve reliable operation at these higher speeds, UniPro V3.0
> introduces TX Equalization and Pre-Coding mechanisms that are
> essential for signal integrity.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
