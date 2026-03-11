Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6D936E480;
	Wed, 11 Mar 2026 01:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773193444; cv=fail; b=AOxlHH+nwdyCxT8RXzWCW9V11E9p/7FsRkBtm0EOvVDR8KQpuUB37vzgUOYX+qGWsfumPdCo85y/gUi6HMuohl4JcFLmzRkRZ3aHQEwAif8L81lWXrqBg7ye/Bbg1wJRKrLBv01f6F0BAdw5UwjtOaQbVdg8fjSacHa0kz23/No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773193444; c=relaxed/simple;
	bh=rqh2NDqeebwnFLf0dnGVwu+T59UabakxgNsRdxB+OH8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PfxF43Hdw1lSpTTxHmMnQSQnxaqlNc1EqaNqGV3oqd2PndBdFE8BaVfMx3Xh1zi2hnY89FmfgxZ9ENGWOd/+Hxg61jDHTrx09Nb2SpbfPb1tvFRQzjVzCqL86Dfk434ZsplYNSxDkHa5nsFDi7O7hXHE+rsO92WbyK3eey8CQuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eZqMY5Yq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Py8NEmVy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eZqMY5Yq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Py8NEmVy"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AInhJf094181;
	Wed, 11 Mar 2026 01:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+4/VgRFbJQVnOXC9BO
	2Im5/0HHQCNcifxJ2hK2cjZj0=; b=eZqMY5YqfgraUoGNmHMQvjjR54NghvOQKH
	HJVl4ZXoRzAgS6mnmoUX5zxzt3eRADfw3PM2QnMew5HciXspvLwD9TNA1xkUkhrX
	890cphXUx1fkO49xThgKLjl2cIGSWhYsyYIc4ci+j9A59e++HhWoKG88bPssyNtW
	mFMYjJTSIk5y2t8S3pdU6e0Ucgte2+d9DvTCgC0n/dj9D3VF7Se5aJhAWOn2aWge
	mhfLILRSPUXPZA9vzvXwkgKC3F5g6DL234L8iwgmv1Lh6pkp/SiCC3xua9Ddsnou
	H5ijXakohOl9MDGiPAscn0bMPLKW4p7OFiac+pLmloTH51dgZi7g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkm2yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 01:43:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ANHfYq039564;
	Wed, 11 Mar 2026 01:43:45 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011058.outbound.protection.outlook.com [52.101.57.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafaxkj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 01:43:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W0nlEqqjK3LWvYgxaWnoti0ENAwe/mIAszm3ZdgOfjn4CqFxo3LxK7ulh8qOuk57jqAqdwo9jM78aZmIwJi9jJMC7Ye1PdgSzO4qLWyXD8LloLEr7vMO6VYcOSVcddXBzWgCQM5ftsjNSivm+KCMwHAx7Ku8PHUvtlV266Bf/1657WhVIFia7Eq+b965V8XV9r20MOcGK2bhnrOpu3NNvOr9EA/rcZnUiPknUwYxmvDzT57iuWPW/dWYMvCtPbhvJm4xIwqwNZBptxYb813MYxtfJ8CjakfPnw+vDV0EPqL1MLvcYpBkW8oTBd/UgMADqMTVrfOn12rmSAwMbwFhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4/VgRFbJQVnOXC9BO2Im5/0HHQCNcifxJ2hK2cjZj0=;
 b=deUKfopb25PqPcViddxAzM8g0cRESOCb1YjRu82AyDxhCOLSuQUyKtyJcHCkHTa8IhV1RkZRwlwCCzgPUVbfohoW0CkiiBUfyUnzZqniShhgaisjKJ3lVgVXDAnQvGqQkABtN2fsH0mgeIiPnpQRKQ1AR+T1SANWLhSHh5c2Qxe+r4Fxud4db9+MkW0v3ihHeXuSCScY0zvCxUcH+BVcrdxf86NbJHeA77iGHjdSOooUd5lGzm69jdHzfjJ3jDbxmK9LiQwy6t+VilKmOo5Ca7IYkolPmOsFe4pERBw+05TOXTGAmHUHUvd7CfXSZ+nbSiKxr1RHTVK7vasdYKcayQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4/VgRFbJQVnOXC9BO2Im5/0HHQCNcifxJ2hK2cjZj0=;
 b=Py8NEmVyAa4TrqJUVlpAh9XJdfhJP/6UxUzv0zMrpR16EBtNKeFTHqvRd5JCEFLxRwZAXz4gy84OP8ls/7hcTAteYPZtuOHds6Vv6KesX/zw0YrJ3EMRr0KDVVewpviHzdIxpk/oxSpdMJS58yh9hdwpoobpXrOv7T+0jscaB64=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Wed, 11 Mar
 2026 01:43:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 01:43:40 +0000
To: <ed.tsai@mediatek.com>
Cc: <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri
 Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
        <naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ufs: core: Add quirks for VCC ramp-up delay
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260310005230.4001904-4-ed.tsai@mediatek.com> (ed tsai's
	message of "Tue, 10 Mar 2026 08:52:28 +0800")
Organization: Oracle Corporation
Message-ID: <yq1jyvjtadh.fsf@ca-mkp.ca.oracle.com>
References: <20260310005230.4001904-2-ed.tsai@mediatek.com>
	<20260310005230.4001904-4-ed.tsai@mediatek.com>
Date: Tue, 10 Mar 2026 21:43:38 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0168.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB4808:EE_
X-MS-Office365-Filtering-Correlation-Id: e19b00cb-26a7-40d4-9990-08de7f0f9f3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AkRblo/Y+3Yo2SnsgEwC3NopAliZRpQTgCwQI62Z7onbLSg8+sbR+JdjGFKJ+2FT+jkToxysXs0IOVoKwNP/1uk+aojtIVPvAxCe1TXrq8U2np0i3kVf3meKVomVxaORRmtn6tLcxj2UA1L79F1+qPW/+1kQaK8iqhex/dFX2q/C5PWOPvODevmQuKXuKAOO2UEAZTDZbb8xDdMSeVGAj3FgAVDSNMMVlSZ25rWSOS1/mc4Khhn9uDZ1IfFQpCxTCJ40823ghWtvBN+czO896WcjUQhQnVhLLapU4DoYBP0p8Nu1mtHBcRD0m3AW6cO3lCCJmLZ1PXPBng4LsPuSjtI62yjtIPFcyt8h60kp3Ab6bOvTASqFlwOcmEhNh3GWu3iBx8QtslWyO2QLZF0l1BO//eZELfcOEhcnXAyp/eNyZgHTxpx6BfuzBwpDzujAxiB+AUP+29OH3gfbKSWq1VhpBO81t0XB14NjDFfEW9Lg7vZQUtIhCX9TV+qCaAy6MalDoNsRgNqIrDYyL29u9ltv4Q1YmJdoW+03a5dGZ0Sh1TSPDoyCBK4lebj/x98EVLPVryOEKuK9ow5PsFQJQJx7eM4CkIHKBlbExOIYZ0ywtPZtyo+j4SrARkMxSeiWrxy9jH4v4E3Qn6Ns2pKyRLEDSJhG8xvIIrECy5qYyfbmg6eU3kOIZBPjhrb1RSH/IdWqXaNIgLOnDvzPgKyTW4dhdqsKGyRJTxfjPKy9Wj8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JH+HTkg//w0esDw5+ldq9Glzu9sABymKFvVl2RE3rO5by0KLk8H25fYoFoBN?=
 =?us-ascii?Q?MK+LRa7PYL3XWKIxJWD+hdRDZrR2f9RRp901Rap0fakPQUHBXNaCuNKHLRZN?=
 =?us-ascii?Q?kft/NbxVCeUjCoGelxnUMRJrBdUo1pMimL847IhtLdo9w7SFS6XZREjmTy05?=
 =?us-ascii?Q?RsLfih8yP4N8p6UwgfLvI+k2OF5iugdlFTorpvk1yI0lI8xsd1DCc38HGe8I?=
 =?us-ascii?Q?Z7Tq3HtqLN16eaPBY3ac+UtsjsYHZY+nhkEbZ+zyd6AFU+0AqHL+ftb9iQk0?=
 =?us-ascii?Q?pPQMGgbHgfbTtIYGLyDP6VLk7N49uvM4JJ+kWKOE6lsknNkQVQ3oQs/Shdl3?=
 =?us-ascii?Q?U+tXLbADAbqvtSuEQprLk+K1rAh/yawMQR6vPNjqwM5Vbp1yVLXlq+JpKi/W?=
 =?us-ascii?Q?Q//R4NXpykIlOwZTZk/ml+xIsYaZvNSqkjeWk7UvguHBta/y5IzO3plBMLbW?=
 =?us-ascii?Q?iooJT7laDA2v0vVDLm0sph4tJ9tqt95UCuxDhBCBd/V0u3GljGwFG8x2PWv0?=
 =?us-ascii?Q?VMLb19kQzgFhv5Kt+HnImzvKvnjJPFKiBSXwWOIutJ8YhiGXPoQXygwhBYpa?=
 =?us-ascii?Q?UPgzlg/edjUnSZe9eNK311oR6wfv3oSCV7ueCXZOyZmnCS4hgYAVy2vcptMC?=
 =?us-ascii?Q?q7plJDAQL/+XQfVh8E8pv4JjH7kxEWeMmUjdyuLv65XhEhZAQ+5wicVZfTnJ?=
 =?us-ascii?Q?v373ztyZnGaiSL/5RpzodXnORIWSUOxreQZLwC4KKZGGbKs7g2clK4/5lBJA?=
 =?us-ascii?Q?Hg5KE2O61maDKeAQmN2dVwpb0L3MtzM8B4avm+tZAU/136R83jsyKVhPOgqX?=
 =?us-ascii?Q?6VGMKg0btKWpZoybmddXta4sDiNwrKSAWu9SQ8iTK/aScHX+Q8hK4h4d44/J?=
 =?us-ascii?Q?cXZcZvQsqNae/qljAFhZZrX1gySXOt4on8VQiOxuBkX2iLzWG7OyE1rmnRSi?=
 =?us-ascii?Q?6OQyWg7RxwEOF47X/oxIgedNGAwrd+F9U8lJeMRlfMHQ4wC/mhrZZXPW5gkU?=
 =?us-ascii?Q?ch41+Bfb3J6PQ6McXqz+THwSVSnp1P2XWSGon1cd3k+M0Ofh02ES7ORAGIIb?=
 =?us-ascii?Q?rhB5oLiZChZxv+6Z4eT8/BZ24pQpovGmRiblb7G6zlgjPL62+PEDYBqYt33k?=
 =?us-ascii?Q?P5NPGtvNQAEprGi/1Kwu1N/gK1UelLbzX7hle+IvVvDqgbrUuZYfNPqqQkda?=
 =?us-ascii?Q?dRMj2492GV2eARyd1fZO9YfrM8jdxogp4xss03fN0/3zY7NNqnhGOpEJRUQX?=
 =?us-ascii?Q?tuWCo0DU+aXJCKHgGTKIkAAwy3TO51gsqxd0/mmVKQWQAAZNnKKrm69Q/fzs?=
 =?us-ascii?Q?uOfAyKTzy4k7+/UOKihtRmQi5LocbOtZukCZHikH5nWBG11MqEfoGkr9cFBn?=
 =?us-ascii?Q?IZ9F2zybWGwXp0qGKOVthbMDAmVfdfVq0AOZyJEnHLqav77GUDI+YoygbBiN?=
 =?us-ascii?Q?zpg7tldTVv4kRKzpFGsl+sTB/EH3WnV1p6T2KiIKyjS+Yjfsj2iR9ve2qFGU?=
 =?us-ascii?Q?gsmBua4PiWLBhomouYdIo7K58PgVyXEXRR5RML9WtJslrSyxidZMsMrfwZ3f?=
 =?us-ascii?Q?LDWR1u0iQuob2ZpkRm42HRlEZxrD0IvMt1USbxpLec02bLVvSw2MoexXTVRh?=
 =?us-ascii?Q?l0FELsi5rT/zsMxP+pYWTxfCb6sZCQVAY5qM42maaza0M4bgQRBuyDc9wI99?=
 =?us-ascii?Q?A/CjSOlsw4frBlZcg54cqijy2j/FXIYZuaU+TPfHnW+XVIqplhR4wlW+lmi3?=
 =?us-ascii?Q?jZ8K20mNHyPrqKe9CGonEGwdupW3hl8=3D?=
X-Exchange-RoutingPolicyChecked:
	hK/Jdv8XW+uojoqNP4mAIr9SvguaRx/KarWnI6+dqcHgeItOezsFOGOHttfIXd4t2DKZwW4DQdVTEKqML7arn97QloRax8NvOV3uv3pmHQa1D4ZuxElyxb+xMwpsRdxtCwrH8PNNIfhFhKrKXSn5+hlbgcnsmN4EzLjg9yDPYE6C2pY3WKFmYUHY4lQpfj/qAa9jxVrzEHXwu/0x9+xLw0oqgUUsBu3ac2IlSeZj9/2xMf1ALKoP6GxtJ2QPUMEAtUMxN40RMO7Mqo4hMzh74zIlJieVSSeJ4HwjHV36bAAKtPZ2HIW0GRZss1Sh8DOPD1+3lQTUaUtE72WYPRRiPQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sq3BfnuYdqFeDzb2Y35XfcLCXLrBID0I+FUZtVTElp1Tn6byQtSc+a2VssoO+AvHxIogNYR8j+CBbGPdnZt/DLg5hNrEM5PO35q7IhWdlyjodKZ61DTcB82uEYIHXM5PFZchogHSPUCWANK4t/Eq09vELSpwRyNg8C9hti93QX5C4udZoR057LR45B/pSEXENNarJQWZJKnGykOLoKPfbJ0IqFPPdxG48WtDJBLK7seNjNn/aGlwh4QG6dGX8ugwnf6dxm7qaoHuMw8fZ6nz7l2fYzoUOL1N7OB6jYRJ6TLi81FWrVSSu4grhbbkYLcpACu7XTXNdmmCHdNdOOh89hBUrOEvAKd5Ggu44Zxs84DbSCeS9NY29P7yRUI8v1ITqJ7/67PQXWPJBgpJk5U+GtF0Gz/Q/x7xlpq1kWwTFITh23+CXCBAnBZAqmEFD7NWXliA9OI+/PslILYCREVeeqD8UXY+kz0oDaeQl537P+VYGmA7sCUbRrICTxmFEOz2G3iBT7NZzfA1rEymUWp0+CKLZhNeqqNn2ljQXXa4OIWK9QE90Mx4kSYInP7+imdS++kCnrbohkvE7YRpbzKqPZXKk44j8bfSjLj7izqAxAE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19b00cb-26a7-40d4-9990-08de7f0f9f3c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 01:43:40.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ijBubjzodv+1KeyhroBPf8lynD6QaejUKjNRfDvZzvqBc8c6C5iKqr9/x2SNiqWufnHMGpK8vpnta69DqPRUD5Jknk9vJl5HwFMfHK3QoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110013
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69b0c8d2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=f-qNvxFYkqVvo9AqJ9EA:9
X-Proofpoint-ORIG-GUID: YyZNOy6qGIOjVjp9Jq-ddh6HhBQHGGpN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxMyBTYWx0ZWRfXxPdCnySrikIN
 ykA9/Ku4HJT/fwGKDjUrJYUp+vz9vAeAHXZ2WTQWySwHH8VDQazk6ilajBfYBEZbb0lWLcuA8VL
 Ukg0Dfk2u0sGC389vQXH/NLgrXY6/3lIohe+n3eQUNE7YdaDgl4EeVDErV0VFAI1OoHexGDdrxf
 3VkelZrY3Hjujy55TI52CYvKV9AyHaN0YvWGMamusGUTgaXaSCJYhet/eC09/ogAlDkGJUWiGbU
 HmFeoN36WmWUN1Zy+iXzF6TW2OQzsh3cwq6O0/35vrv4tvonFM6RxHXL1kEnVL3cXgrbQ01jZIZ
 pplb+WYPW3TaWFsWaYzpT2hPEdlEiHjGfmkuMC3MD6pK9jsVAWRhUFBYL4wdjZqa/XVq1Y5KKhu
 fyiz3MehwPx6WUuaitIzgEEyKo0m4XFQIMR/wzooPHfdLhcLBbW44xIRpOCfVNux4JVSq9gtMzg
 pF7TaMPJ16lPd9UvFMw==
X-Proofpoint-GUID: YyZNOy6qGIOjVjp9Jq-ddh6HhBQHGGpN


Ed,

> On some platforms, the VCC regulator has a slow ramp-up time. Add a
> delay after enabling VCC to ensure voltage has fully stabilized before
> we enable the clocks.

Applied #1 + #2 to 7.1/scsi-staging, thanks!


-- 
Martin K. Petersen
