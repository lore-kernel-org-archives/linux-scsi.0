Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4AFE56A;
	Fri, 31 May 2024 01:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717119871; cv=fail; b=acm0WAZfuUlbRnS9Kg9B/ayN8yEIfnb5r1S0IJQ4PTOekcE7az5PYnXfy8ykFrGG5HU9QJfgELWnoaVURhHbWUMm/zF9Qn6TCkAXbWjJqlsPQGqU1bYAmTfjjkUY7Yy3UlqARqzXWZhLTX+uFHGDfAfixf59y/LofZk/63m0n8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717119871; c=relaxed/simple;
	bh=Io15HCCwZp0bTy67/FP1RFJi48o0hH7f0ZCkv+/ZcBc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ff1qyEmgleSlM6KgzWg7K3dXadduWXQG1jpytJlUq6e2kVoKgKexNF9hi7kYWcL5Cz99AUAHCctatDIdv2ecXU3CuiZON7boIKlVyyPY95Zw9ObGpmNIxbzQ0+JE1tLfdKk43eyzL3fAd7ljpdMEyZTOnC/odqBC2V2UYle2cWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V1alQ8019720;
	Fri, 31 May 2024 01:44:23 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3DkfUwWycQ6Yan?=
 =?UTF-8?Q?kXvVnAS6k8lpGh6U5j3x+Kfs5rDbQxs=3D;_b=3DcbmR3/Vj/uOs3qRJckYQ1th?=
 =?UTF-8?Q?3xd+nfShMw1inEfLylrAkM86R3zlEOQgWZpZxraGpnfU3_R1ESv/8Ps3QrArGN0?=
 =?UTF-8?Q?jEiL+su4vmhZK0N+LLSkKybV+RyczYguU38vDXNTPZk3srnFXay_5DgyiCgNy+c?=
 =?UTF-8?Q?Mg5KVNmrrf6Nlnlgfp5kdfeUw2NrD19Tl/CqMFx7RMQGxQ+RyDje5Xoql_u7U5m?=
 =?UTF-8?Q?OIfIQTrSzZom//ScqkSsOO1lXJ3g+dQl55XTc6GwbjXTZwQWeXBZKCNtBeHX7da?=
 =?UTF-8?Q?_RHVmYL5cZo010g4njOZ3LjrogyiOxfQIwlvXwFTy3o3tGfd2xx06PLVU2aOnoh?=
 =?UTF-8?Q?wFELvE_EQ=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8g9tcjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 01:44:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44V1Zelm015377;
	Fri, 31 May 2024 01:44:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc538vfcj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 01:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9bUrdcOYEDh3+i90ZI/G1WXbKUmG4godYVgTjGlB8Axwb0nyJOwnK1KlmMrEcOwkQraN8prSDCOtlo3qvBhJ8SH36rZVJapBVDSk7zoyrrik4+0U6ytfqhismE0c6Bexhsx58bVZ4b99Oe3DHKk8giaG6+RdBF4NDxBC+aPO/HM+nB6CaKxofqbRFs6w9mXuMqjXomNqObDNY/m1/VQAxgjGCxxqNmzVjAyHi2DH/RSDgklziNByuvlN0bzWw0jHQEphYO7I+gKJur/Tp5rwyHUHZig56XQLI3j1mEn1Khoxss7cyPRhE16Zanl9YlTsel6EA5XAdSo5Kmo6v+KWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfUwWycQ6YankXvVnAS6k8lpGh6U5j3x+Kfs5rDbQxs=;
 b=AxvFt2i7gTbFWZuYz29XOafX2neciwnBvG/e2t4xe6pp1vgHgwyiJYhqsgUzNeuBmL0eNVjm70rg+H8N1vud4qhyxAKg7azER9HcwVoXxow7gPsp932r/PwiCCghbkPDb7V7bfjbovU1RkQQUtFdnITrXy9T5d91aPAkO+opsFcqowVZlVG3f9x01n8+k37YYsH8k6LFDIvWYqI6qDR6yxBlRBjlBMeWQU8KfR4lu4j2cUcekVoUqbdLcuAcm6mSJcS4Ch0VL9R2V9GV+eOC5WYVkA65lwM8UCn/lCvLui+Ls/iBivMvo1Bh5gzgecerVudoie/yJCRSInVFt/hvGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfUwWycQ6YankXvVnAS6k8lpGh6U5j3x+Kfs5rDbQxs=;
 b=t/SrkN6UYHKze+rrqPzkydOlAWN2i5kj3lSMPklRIAy5xUuCjTltyNaYCBLNQoF/v4J8BXqEUuRj1rfywkxLC5gTN3HhDOMTjsIZZL7oocd4fttNWZxomKwh6ZuaV9jCBv3t3CzaeDrSoxBFwXUGxjWEFgiuYrN9o1BVL2mV2ic=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 01:44:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 01:44:19 +0000
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pierre Tomon
 <pierretom+12@ik.me>,
        USB mailing list <linux-usb@vger.kernel.org>,
        SCSI
 development list <linux-scsi@vger.kernel.org>
Subject: Re: [Bug 218890] reset SuperSpeed USB device number 2 using xhci_hcd
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <70dd7ae0-b6b1-48e1-bb59-53b7c7f18274@rowland.harvard.edu> (Alan
	Stern's message of "Thu, 30 May 2024 15:03:01 -0400")
Organization: Oracle Corporation
Message-ID: <yq1ikyueoz8.fsf@ca-mkp.ca.oracle.com>
References: <bug-218890-208809@https.bugzilla.kernel.org/>
	<bug-218890-208809-ISXsODEmWC@https.bugzilla.kernel.org/>
	<70dd7ae0-b6b1-48e1-bb59-53b7c7f18274@rowland.harvard.edu>
Date: Thu, 30 May 2024 21:44:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0340.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::16) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d18952-2b96-4667-04cf-08dc81132f9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?fI5k1qMXKPUcl8ZcwOqTQLQJrN+mQjAeBVUltiu88tsiyiE6RRsmgaQGNzSb?=
 =?us-ascii?Q?+P9lf05fbXodZo7xbgeKcFnq2cXTA0wRT8CnzGD1vESIseBz7+q+pymlrPdm?=
 =?us-ascii?Q?bNmKKEwlSKa+v4fsknLSxUpe2wffMTOyZjWyN5OkrbTJWgqAyl5+o+YWEfs2?=
 =?us-ascii?Q?k1AXRpoUOm02Tc/5A64WtF9XGVOsyrwnwlyRInmauLLh8d8dYpu9Vgz/UFK5?=
 =?us-ascii?Q?vaKCJZMp7EK68grSS+wjAvORbOfmBr25050SfRawp74XuJwpteDj96iZ+g2j?=
 =?us-ascii?Q?G2T2v8gTsOtJCG7gcC/bNcTp6PBttJe5tst7yoHH8LNQ36Xq9kw1eFRO06x/?=
 =?us-ascii?Q?8cEm5bYwYNC72QK1WmDotxJGfvHgNMj5EiYzF4Cnhtq3sgz8dlnw4M2IlNEy?=
 =?us-ascii?Q?pxsScEAGA1mOz6nc32ps9oKk1iNrI84OGug/KIXPgksX+FoJHpxUHzo0h8+3?=
 =?us-ascii?Q?CstYSHlsIrYncyi5ESTIWkWKULiUG2uC7wVCn38J6OtJkpOhEfpSd/tSxxQq?=
 =?us-ascii?Q?v7zmfyBxWaOjgQiKz4wxos1Pq8buFg2J1DzcIOcVZMFib1UzXyv3H/vbnb9P?=
 =?us-ascii?Q?bunGhIbJ989bbaTJhylbtCQs5Iwz/eVzDQlVX9T2K3UI47c/FVeBwFjBOsy0?=
 =?us-ascii?Q?igV3sXoOLiJHyTU3K5ulyeTr69qZqTJdqdlW0rTNpAjC4HciFMuPtIde0O4F?=
 =?us-ascii?Q?Fw/3AVkHyTPpqVGGmsPG577d0lHj+h+5l8QphryBJ/4fS9+IK90UTjDLZ3Fd?=
 =?us-ascii?Q?x2/uS2E4i7jLOElOVYcJuwmVI8g0hQ9ji2+ljI0P+ej5xjD/JxVchoD1svAh?=
 =?us-ascii?Q?5vfbqCbfdDZj6UVF9YbAqv+3Dl+lPI46kF7/Z8LBd3LKcZHP0X/r1L106rkY?=
 =?us-ascii?Q?Q2ZiryXBWsRZ/FFpXe8H7gycFDNhCSA4D/oyqhc1mc0SD7ZaPhPdYfhvCc6a?=
 =?us-ascii?Q?RoHB2PeqSiV9gTq3N1v6w3xMLlOTgYEtYz4pTt50/w49ub4+lh24wYRSDKuD?=
 =?us-ascii?Q?gn0jOL+wBLGHHOJwyr2HmuskOLiByCEPlxwxXnuoe9tFWz5LDuGoO5FERsh5?=
 =?us-ascii?Q?r/57n5gMBbHwsl3RLR7drxaFdq0Xw5YCwfTDb0eyObiVeFThYJ8Dk6ku/pWW?=
 =?us-ascii?Q?z9Nv3GYZtu55DsmYdG+ErkZpq7yRh/HFlMJra+LIJ4mVUu/auhtLW5D11zBk?=
 =?us-ascii?Q?Dn9mJs+PxReG1Omq8rkqsNM1+LPwmxXE72MRZh/eWCQ/wxlZe0L4LtZ4nHar?=
 =?us-ascii?Q?c2yoVOWj8g/ckK8yZZklZK9j3DLR0R7gIKuIBQEVZQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wrAembrd/3xl29ivlH1LkJv2KGo5EZhRQZEmPmps1idDP+wB50vrhKy4MJ43?=
 =?us-ascii?Q?+GGFgZ56JpvjDyTQFjaQdXCXcFDd8Vq0TrPb9p+2eFcQ8pEuu9vr4iyQW4NJ?=
 =?us-ascii?Q?X+DZySZVx9sOu97wnjqvMQD705bTiciy3Yl91YWdJdQ+uzrVTH3+J0Dmx+u9?=
 =?us-ascii?Q?kaZXFQ/p6vk9pW6XeEIpNP6J8MtCB9usJ8G9d79/MmhGIfKFWe5HthwAt+CU?=
 =?us-ascii?Q?oAcSXhS39P7nO5sIBUHR+l7EwXX7p5LtN9DdrP/CHnD8I9xM7qPa4klLyboI?=
 =?us-ascii?Q?0UK1ZXZJ0lWjgGlKqDDX8HCXudDb78pscIvGeWwQdRi0ZrBGsuPENCa8ISMN?=
 =?us-ascii?Q?5Y5YpvCWlpG36H0wrbCa/57Qand8YUNhg4Fp2tvj4QDRblRtzF/KXfbmqdYn?=
 =?us-ascii?Q?nWR5Da5gXwC/jNtvGthbfSgstzdsNA1zeQf3kWJb8WBSY2iknvfFvg1YZdbn?=
 =?us-ascii?Q?VnLKEF6XLmlM4uH3Tx3FU/LBuK3bOBP2pgYGfadP3dycR2nv4yTk6Z1189fl?=
 =?us-ascii?Q?s2N8uYmCz7jMYR8MnBRF4/T2rLgQMZcCLQr/rzSNThinzc/6eRtKwFyM0MwJ?=
 =?us-ascii?Q?WHii566fHUEqL8rDHNGTfljF/qPnm3nOcqQ6MP+5P2dAlSLvcX212wHjoIlJ?=
 =?us-ascii?Q?ycJBpqejz4DP5oPvFdQauBblNFbdjCbeGV0tn6JSquU/QkHos0muMuh3tWno?=
 =?us-ascii?Q?gh95iMy3LNS8ddh/c+L0ZRUrTi74kgkjptYDq7AErnGgmXc0TnBf3dTG1A5m?=
 =?us-ascii?Q?s3zP/g4cvTVLwBoEx9IrGAOQ3utgXniJYJ0K9AGqyNh+0jTeuKLo2LovKICc?=
 =?us-ascii?Q?KC7ScYru2bCS5wJKRLCs/+1eRu7B0LC3tl0HQ1AelIGJ8O3eozj5azXYkY3F?=
 =?us-ascii?Q?+EMiftT4HIT3IMco34pUPRFWDxa487p9i6OluN6VvNtXPe6FFZL6iAmaqrtR?=
 =?us-ascii?Q?OCLT67VBRp3+WpaFOM0x/EBn2AcCYm24Gvxa02qhykNfIiKgiHSDn45fPqLZ?=
 =?us-ascii?Q?E2nEog4eB4HPNAu/Cm7SaE39/bh6itGBX8Y+BsJN0Rh9FTqH6NZ7C6xcTyRK?=
 =?us-ascii?Q?dhcKc59vA7qekEEVX/kPiHLt04VqP7hOOV7nogXed8YTU6c/NF6r+NLCuGfR?=
 =?us-ascii?Q?8vvn8qwBT6S66OyYxMXedoQyVjsfivBj55Gysvd0lgBkiyiMJ28hHIvCV+yM?=
 =?us-ascii?Q?qdLpamj6kWTmF5k5v1caGIerdn8TbLvgvvJ2zkmTRGfstVpBR+lmBG/lufm7?=
 =?us-ascii?Q?mMwXAmk6VdCpJlO4rhsXJVV91t5BSiI4gQWgNCK7d7D4Il8N68UawdbyV1SY?=
 =?us-ascii?Q?RyM/QbqscNm2it1zs868bSe5xZhpaL5MQJYVoEciu9LJbFnLLXXqDzJoZh7O?=
 =?us-ascii?Q?IxxjopefzM30xRcPLcm7hwi+ZfzYwJalMy9xdZ6VMnDP7pM7m6Js4Ruj50vy?=
 =?us-ascii?Q?xG82jvVS29zsa/0Dprb+KGEGDuTfORSCds3Ln+7ygHudO3YDy9N5+D8aCJBX?=
 =?us-ascii?Q?thjIPhXE6lxhzWTUWwv68n+9vy9vj1yF+K/2eXdO8X5u+6EnOEQoBAaUYqrD?=
 =?us-ascii?Q?uOguTTkKtWgxDCxBoKWMw/dzF3HYaiNsnS1J2PyNWzjwJjJ7qH+RkAo+b8Q3?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	OVkrgOMHLMyTdlV8iVDdKK+Tg5N2vVRfWDIbuBNcq6shGM+gYxREHTWyuSzooAAuLhtQVvEx0f5T73aBK9FMnxTZ5fc/oakL9cc4Ko3Ayi4KZu6bGXp1ZSv4g77lR4ImlZd54f7Nhl5BXWGcu7kE3is3b195ti+vnDud0Y2Ez/XOFTbutchQ140rNwhradE6tNj1e6uMy50UZrSsCAu5NBrJ3uggK3ZHnxHwVS8oxs8UUd8lckNKoSs7mNS0m7xs/hl1h3hahxFuf+0PFSvrObloLpL6ISjGNuLQd/lF1xyTiAEL1VZAphtNF5iBMytjOLNyAK2wabc1lLB9OUvwITNXGr1OcONYYFoL/Hwx2bFPIfJmxFnv1d9u1TxpB6bKgsA/eez+2xn2jWHwWW/f/NcdnFlZ04aiYrB7TX41md1NSQ4NuZiDTBG6gYtAWYxtRQAG+Nlky+PWq90hNQg4Q0Ticac812xDV5o1Kcs6fOhwKq1BdTH0etHLJ7uoEM/k2g19Z2ByTLw4H2c30YIvFfQVJ9Gq7dRxWerZxxpIBpM2w9HJEeHw4ryQA/RYbGAn2pZrwr4IPqHDEOqSGbnw+4RRE3Ve67pqLdxyp9CFOyc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d18952-2b96-4667-04cf-08dc81132f9e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 01:44:19.9408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: He6OvskHsOrClSo/2VS6uVr4x9Rxy5w45f/xbNM6QSt44/5crKeCk1j1lWp18RWuov4LLQpsMnR6hhg0uH1coby0vj1QnVQiPy/ToA6lfbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310012
X-Proofpoint-GUID: E6by7bCNCntUTG4zRRTLPuzLTxPKcRyz
X-Proofpoint-ORIG-GUID: E6by7bCNCntUTG4zRRTLPuzLTxPKcRyz


Alan,

> This bug report was bisected down to your commit 321da3dc1f3c ("scsi:
> sd: usb_storage: uas: Access media prior to querying device
> properties"). Apparently the drive in question doesn't like READ(10)
> commands but it does work with READ(16).
>
> Can you provide a test patch that updates the new sd_read_block_zero()
> routine to issue READ(16) if the drive has more than 4G logical
> blocks?

Please try the following:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 65cdc8b77e35..6759bd5af58a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3572,16 +3572,23 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 
 static void sd_read_block_zero(struct scsi_disk *sdkp)
 {
-	unsigned int buf_len = sdkp->device->sector_size;
-	char *buffer, cmd[10] = { };
+	struct scsi_device *sdev = sdkp->device;
+	unsigned int buf_len = sdev->sector_size;
+	char *buffer, cmd[16] = { };
 
 	buffer = kmalloc(buf_len, GFP_KERNEL);
 	if (!buffer)
 		return;
 
-	cmd[0] = READ_10;
-	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
-	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	if (sdev->use_16_for_rw) {
+		cmd[0] = READ_16;
+		put_unaligned_be64(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be32(1, &cmd[10]);/* Transfer 1 logical block */
+	} else {
+		cmd[0] = READ_10;
+		put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	}
 
 	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
 			 SD_TIMEOUT, sdkp->max_retries, NULL);
