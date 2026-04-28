Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6CC402435;
	Tue, 28 Apr 2026 11:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374960; cv=fail; b=p6q4gNuxKUA2hr3MMoYtUM9Fl3NMmPau7pLjo8JLXbB0BW+lu1P00C7dDgUV8IY5D0N1rjU+CIOtalisP4JlBcjz6UPVmXJDv4qcYM7M/C4oduU27YK1sPJktumd0cdmGelI3A5oO0lv3I6v2+BUHae+2aopND8aEi25+R6qjIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374960; c=relaxed/simple;
	bh=n8Rr0XJtMG0kFiBShcSGwvsSHAv3AL0ttuKnoKMzCtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QsKt9AyDXz4zWJ8avkLGZy+QtttZRtJOsO2fejSPig9BHo+HPGF4rW0y8fGvzcgQlAMd/o5U2xaNVB2E9WbRvHdNzfry89AEu9taFA8vpzzcNFF2+kK+7M1HOmszirbhFFaKarwC9o5FX1ipl6/mFRdisWV3/bpehUEb9WB/qnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ab4Eb4E6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y8r7Fa/6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ab4Eb4E6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y8r7Fa/6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SA5DLS2603484;
	Tue, 28 Apr 2026 11:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wYva7sJ8OJqR8xscOMaAfGclfnVqGLJTcSO8fvOGhzo=; b=
	Ab4Eb4E6FRW6+8lpjWKa/JmHwmYi+BTEdFjdqR6V3qkbco0N+O+x/Lq7N4dl2U3L
	AKh0ug5Vz1elme5MDvWnfRrXNzWI6xd6btM5dNrhmdp+xF26Dy11J+qbDN1PNVgx
	j5+zKEE8tc/Dn+ABsh92d3LSN2xEPJsKZCuFITjBFntrWjGgBXXpZQK5LYDfeV3p
	4dZK9d6H5Ft92x9C0rH0CIS3Hv1OgdaLMQX/iBfYC908+zpbnx2Ao91aVo6nCfnj
	OUfke+FuFDSzyBvgOh7YlO0/V7c2Aj3QbVqsa+cXoqf5lYEe6wNYJZzCQh0aCr0A
	Cfmvu+Up+8yO505+An2U/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm1cy8xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCJKI033129;
	Tue, 28 Apr 2026 11:15:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013011.outbound.protection.outlook.com [40.93.201.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cujcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lY3cMNXPHlCmD+bUoiZY0x7/s1RH4NMQtLsx2eA/RnbpTbnVBdE99HfAmQxPVpilfryg/2fmBKDdoIG5nl+fXkWpeZg7xt6PsyySuzslOthfxRSciv4Jmr30iR2VlYo7KwBxeGvSs+M51jzw5Wij90e/LwsV6u+eJH7m8RxCMvx/nttfGhSBKA5qB6ttBxD0E8HCEbI8gDcXB2FQQjc+0OYXqT2LCJLhTksJTwo59T5frA72hFTbHv5kpqPXvLzE90k56mcwNsCyTFztO5VblYcFLrrUfAEYZNJzDl3jliapNNZoFLK5SaqscjEpp6756vky8qi65ohqRCjPSB8kVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wYva7sJ8OJqR8xscOMaAfGclfnVqGLJTcSO8fvOGhzo=;
 b=PIyFzTwrPg8+3WWwfd1PTjg7i2UHY/ocWjz/qyqQ7b3Zrp/dJYgAJ6UrDClEbhySIVOokozl5VOmN2IuktgAIKb+XXFCirNkFNUQ4bnLUSnbr1Fhma1O76Fvb4w1ZZWVKnszHM7R+aKgUeAAQqpc59IpFXOXD1JKoiaffAxGvvvijpJs+cIAsJdTmVL3ExyFhaQ2PM5eYUr2m/64EYSRooCBRiZtgqQcHGbCxvJyEBmlCOz0ry7X4CEv94liIJbXc6N0O4D5Gm9UPXxD3z/I0Lk2xMEJ2p77EaRlXBzWKOxVnpXn1L2CIGJmJvyormNjAjNHwMMizp+BXgsdKh39kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYva7sJ8OJqR8xscOMaAfGclfnVqGLJTcSO8fvOGhzo=;
 b=Y8r7Fa/6+OE++Fo/89spWqgwDtr+0N3VNC1r47rgmjJc5UhjThh9boiW8jA/9so/ksRitSaLa1OgTEWCNlJWB+ob8UbSa+UA9ohrhYeYOv42YehVhslXzZaRW+IUj/q0/1mmQfqzZyu+D4x28HUb5kmEBKOBYgyAV4IbeP8TbOA=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:16 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 07/18] scsi-multipath: failover handling
Date: Tue, 28 Apr 2026 11:14:36 +0000
Message-ID: <20260428111447.1779062-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0074.namprd04.prod.outlook.com
 (2603:10b6:610:74::19) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 34b12708-f83f-4aff-e96d-08dea5176c88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nqmMD/CRRuZ1WqhhfxIVpa6P9sisVQjdrhktrNeDsy9tWlq9JVhHv/TMvLjlkk5xponItTjICFthcQAB+klszibPfxybzSing+yfYhX7W5OSLJfPodr1GM0QWeu6CuAqnesj9meWUOO8FyjIA8ZGbg0vKqs6jizTdn1oa7tncnjZtqWac4eLkqIW6kDM4shhLjNADU2YJPQsOLt0prtHl2rt5gn1lX4j6qzPeKsq5ABTvpB+kl30cQS9xnIv1wLrlovQBIk5kQsThGQ8qqQyBcCgQonhlY+2UP4jqp+CiLc3RWBzqxLAYuzZVU1t92JN3uBv/ARTY79Q0rR5QzMFUxa3S11Iq2IH4+rADx+nqmHP89QHJtwDV442SwCTgmu4jk0rzoELzhfULxOPBi38HFyDgMphbUtYcfJm5lHAjaxmZszHvVqxoMZS//p40of/ZaPiHf6arzxi58hjotn0J5o9dK0MXtPehlWRyV4isPI5FrMqI2avw8BAOWymwWBSPcRwNZOc4gPZaS+atI+6wxiV6KTNa6peu3o9CvJKR6OZDBxfR3spfiqGIZGdItq4LrG07lp0TowIxjAOSSz2fu+1zRB/KlZ4YsHBkrvvkMTU777NlpWFGZaSHrbd9mYcqFyDN7C82tRBLInO+5NuQaOZV2QP/77LAHV9LAgUJNyjetEfYXm8mjNPfxUymsjFit+8437d844QQyDX/LHGRdfwo8V2/N+Ws2YLqjB83Uw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SE08iU5q5gtpK375Dx5eeb3G4lbBY/1QJPZPdYbdp8sB39zjm822LqEfGVDN?=
 =?us-ascii?Q?4S3cm4HfGJUDP+TmLmhAVH1XrK2PT5Y0a5P0Cmq0FMj1MdRhG/pttr03yRMr?=
 =?us-ascii?Q?blPcN5hsjnidJi4obPs/B8z8PIOTxUd1uH52yFgibTR5VABy4Swp0oiHUrii?=
 =?us-ascii?Q?VRkn0zoRUuYuuAW6lkSzILdnuiVDQlwxO17kMRFeRC0OS8THl/P9vL8wra04?=
 =?us-ascii?Q?gRc69S4nMg8xynrvUgxeJsSIMKQOzCZvzcjrWqGzVHyfioSBgSEob7gSI1ta?=
 =?us-ascii?Q?FLvr3XsU8a+i5P7vrwX0cewklYp9XEplk/y8xCZmumya1rqFx4Tj+zrWCg9P?=
 =?us-ascii?Q?oXeWXkuA/L6HFPB2dq1IJ/rrXwxtdaZv7f690jGUcuKzIdCC25GxKr9q80z7?=
 =?us-ascii?Q?QDLX7gyuY0AXF3+klDOdJbAYh8QtdmHuiKpzhdXVyNw+WuIYE/WJGaFKNvf3?=
 =?us-ascii?Q?taLptXaUEnXaS0SK6rSxPSwmnkcfTiRKymJCH+1MlVn61UT2CvYoCXR7W+jw?=
 =?us-ascii?Q?ZKqpFSo+XqvoWZKcA/5XfAGjTcwnKjizgzHzbQkiYCCWZJ0gIcUjatZpcG3N?=
 =?us-ascii?Q?uSwiLvWCoSMgyD74TLzzObgXXHdndnNb66uDJ1TYe0oHbIn9rcPabz5XHAUl?=
 =?us-ascii?Q?pNsx+GwRZJs4NF1La0t/ZAUXAk/0EZ0hdA5Z1j9z6bIqObIXRxvlhDuZIa8J?=
 =?us-ascii?Q?hyR6QK4vs0Pbvyp9D+dX2RrcTDXfDNdqpYjFi7vXSgTyLXcIJPOQd2QZk5Pu?=
 =?us-ascii?Q?QJz0a6kyHeeTgI735QlBd/oXAQQPc132Go6MPV2N44f9uQzt1x7SJJ/huahN?=
 =?us-ascii?Q?0gJ9NqKQZGJUeXUkK9TWC/MZL3gmcgAX7M2nL0hATHUwX3HtS2jkLOMiyEH/?=
 =?us-ascii?Q?QQB78A5kgYe4c5cEPvy7gmf5m5mzqDkRwAVfAkdVQ3+n/p87TqkZNZ0iDcsq?=
 =?us-ascii?Q?fVpwe6xWVVoM0FSWqJ/vQi+NM9JnTDYXQGYxQY7NJVL5DuOpjOvQYkn2lkWO?=
 =?us-ascii?Q?Tu2oJLpunFJlz77TbgQLAAY8BZjwY+KK+60p4lW9pB+n4OTxKQwOXxOEBnRU?=
 =?us-ascii?Q?NlSqk2thgxvgkFaGhKRIkE2GHaAFv1+7p8/n9DvgXZCJiP46bpbV0xHz+YXJ?=
 =?us-ascii?Q?kRWEfBcn7Cte7XOHkVGTrvB5LzAlqervrCycTH3rKYy05QR8IYHOLmEsQvLi?=
 =?us-ascii?Q?ttzOOCZzOni364oBbAxLaOc7ulV8oKpe5JMx2pkcuhC5B1fW7GQ3h4it5PXd?=
 =?us-ascii?Q?e3v4nfXyZDP3LajKaghjI93ur6Oi+5ABW0Bh2eGIuye0Kd01TS68o9pBNFWP?=
 =?us-ascii?Q?n3ehYU7iPqyEYj4U3nhcnjkqQ7A8rVklGj5mTIn+DTR0jrxsQLl5h7npMtTr?=
 =?us-ascii?Q?uGzKAZWWAs9HJZWMNnNm4p8yfvbH4UAq90SJ6NGgWU0lTF8XFIqqtlDJ7e4+?=
 =?us-ascii?Q?zm9rLwpSHcYNiattX5Hko6PD2GJ0SWKncvaoXCQ4sPIO9oq/by/mB11ilj1Q?=
 =?us-ascii?Q?nni0Xo8CCF+cz9c9ll44O1HQZKKo3GDVQczv3rv7RtMn5ajc5e/xiU0lAvAY?=
 =?us-ascii?Q?Bo3YxfizbvDNA/9G8edplD+WMCl1/78NpHDFw3WyCUoycq+qAVx6kl+/f9Wh?=
 =?us-ascii?Q?o2euu/3IgtxvpU7wlYZ8ZZAEeKoYwt9/lTzEYlC5UGld0K6v856EKriklgPW?=
 =?us-ascii?Q?Phx9tfxdx7t81yRrgbxDVXxzQyGUQK52d8PmegwwFF38xJSJ3DqYXkaDcwfS?=
 =?us-ascii?Q?YiASpUGTas5tz1ji/sEW/BAz6ulpvwM=3D?=
X-Exchange-RoutingPolicyChecked:
	MMCjXX2J5yquQ3+OP4StZrwVNCvLcZ8iwb7iZ9rG+tvGxbH/iN+7qyER0lRGUBc0nqpwrodr7JYWKFcMIjtIHi06njCugw3pM3ElN7Cdf/4Qj+KIv7CEMGx1Ze/1x5IGH/sy2daBWywk6jMKwRapUdUIyd5quAs4LkB4AxUX7rrD7z5b2Yfb90wWqySsfm07wC4O4Vkf7PVunRFlaUDenDhdTf7qhzrJhTtAVB+S/SR5rMb/X2wNKJxt9fh+PILIFjBh4+3GmsW2iQmFVSq5I8X+R7ZFjx3vlHN4NJdEk6xmJVXjaC+55ahRmiZBZwqaXRyp2NWONnhlkswr92jxkQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SHC3Y7BbS1M4L3xRocZDApEOZmyY/rHLz3kIcahhIXnDb7db0213vAqXWFtXSzisHumA/lKN8Um6yq91gmsEDyNaUp+l/mjXlNk8PU0VR542SP+q/j/ACBD3/koMr7krOBKeelAj5oxHyc8x9hDNyN2q156/ZWYsJEks3DJ9Dba8bMLsjarghWcyZxLBPLhVQNkL8S54DSD5yicxg1VYpV5VlIBYGsHpGqtg6akRI5nIKuPkDuzsVUv2wqC8vnN0guggbrTDFx2SkK7brIft4UMKRSdIkfKOdnKACe9gNZAjGl8YPIcRFJRTzX5j8g+6i3Q0vuOJQQ2ISwX5Vyr8zyN406fu03opJg5ZRrgdwv/LcKoNMOcqynNu85Qfk9nD+pxLkp84Up1pTCPiFrKUmK0Kd3bfpjcRKlOZ9S0vM4ojgeY4Br4w5Hm4yIKDw3pKc5n0O3yumDRuwq+el/IIqTwujX1V4wEatD9eFHW3FL8UtG+V/JmBF+at4QU2EYuFJ5R0k5/xLeTip3rd40GpxI7K3zvnXL6KtRG8fCpixSci5vj2+mtbazb+k8drUuGfKvcTQhQCRbBx57Qlnp2qoThX/p/VKWmmvdpjniHc+Vg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b12708-f83f-4aff-e96d-08dea5176c88
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:15.9108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Z0CkygQK0d2njqAp2N2KZTGlJ1rzwSne1mnUKS9Iv4ccKXp5s8U3zulbfagQEJwXG9VhVRbLU2Sn2Ac1JwrhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: JIK6DhIg_ygGzbN1zWlfqy1IEuEC2TC9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXwkiabb8q/rhc
 AMGPUCIFLPLqoCAYrTOgIO8vH6+WFmCDU+LeXdkStsHrZsPw1OCQGmHkcYk4N8aVGgPc8xTM88t
 MJ487QPj9GyEWysfC2OIze5ukbqbFsU04BAUxj9/xCpevr8aL85957MozTG/fATxsZnihBqPmGS
 gijy1Nj++sDvU7zt78Z19r01Ub7KKQz3MINGbuwU6jAfqKIN2SxyUlMwQ+PkroUp3QKANxKt+Sb
 NbB7UPt7vbWrsnctAN0m7NPObdmaJtQtHsQ+LvhzbFEDqO1miWzdwFWKnjPgTsqQ+PFI4jHrMSZ
 HK3TaC1jsezrPuGjNVZYpBAhBBO/kL2U4uAftm+ICQc7ONcc748OrA0MfjIs5tz/ZvqtMB0NsKz
 dPMmE9rccNg5nL4ILmm0mXBlmyfN0EZKsYXlfvbYA7FtRVuCSLom+tXXpqgtt4kADkFNS8MFdDb
 9olkMXzx+A4CfgCtFsQ==
X-Authority-Analysis: v=2.4 cv=I89Vgtgg c=1 sm=1 tr=0 ts=69f096c8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=5mQu9_vmmXT8XsUthawA:9
X-Proofpoint-ORIG-GUID: JIK6DhIg_ygGzbN1zWlfqy1IEuEC2TC9

Failover occurs when the scsi_cmnd has failed and it is discovered that the
target scsi_device has transport down.

For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

A bio which for which failover occurs is handled in
scsi_mpath_clone_end_io(). Failover is detected for blk_path_error()
occurring, same as how dm-mpath detects this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index a4636a53ffbf4..0dcbf12217165 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -242,11 +242,44 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static inline void bio_list_add_clone(struct bio_list *bl,
+				struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	if (bl->tail)
+		bl->tail->bi_next = master_bio;
+	else
+		bl->head = master_bio;
+	bl->tail = master_bio;
+	bio_put(clone);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
 
 	master_bio->bi_status = clone->bi_status;
+
+	if (clone->bi_status && blk_path_error(clone->bi_status)) {
+		struct block_device *bi_bdev = clone->bi_bdev;
+		struct request_queue *q = bi_bdev->bd_queue;
+		struct scsi_device *sdev = scsi_device_from_queue(q);
+		struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+		struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+		struct mpath_head *mpath_head = mpath_device->mpath_head;
+		unsigned long flags;
+
+		scsi_mpath_dev_clear_path(scsi_mpath_dev);
+
+		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
+		bio_list_add_clone(&mpath_head->requeue_list, clone);
+		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
+
+		mpath_schedule_requeue_work(mpath_head);
+		return;
+	}
+
 	bio_put(clone);
 	bio_endio(master_bio);
 }
-- 
2.43.5

