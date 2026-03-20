Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F1272816;
	Fri, 20 Mar 2026 01:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773971281; cv=fail; b=ss+L0LI3AAoDhOJKXztEylKOeGUOkhC7qvwbyC+YT62AJ5xloB9P50PwoYhaxM5QTIL/dPV6xndPPvUbdl9Vc5NWDXq1muxFAgPdBTDLLGc23YIQJrGope7Y5+WBcr5IYDfpseVqI7TLB/jzXffnP0J6+jwfXrj/QZSk+m0aLIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773971281; c=relaxed/simple;
	bh=6X+q5N8ysA2QVnjze2RKLxU6Pjm87cXRaxeQPWjXxP0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=W0c7d6y6HfL1oGzvKYmzPmddBSlmXe9BT9TPHc5DEIrIfbddGzSLSUwNvMea08YXU+b2cW5AZsBTXDTwI6bjWgj30qbmbnWRaxpewYnqo5JYH6Zj++aXDCmaLpKIAeMY4TzKlLNfjzRi2//zttBY+ofdoBdFYPmSMYcRA0mRElU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G0oZoKor; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HYr25CEB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G0oZoKor";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HYr25CEB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JGqMO32706638;
	Fri, 20 Mar 2026 01:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TunhhcERvWWt9oW5CW
	+szy4azivFnR5UnxTx0yZrm4I=; b=G0oZoKorjPzckrAGzELBWt+aWFovB2euwo
	w3iKTTeawYpf67MbG8nfhjTqbf/fYR0Qa/hIwp6cZ0XkvD//4V8wkIsmSg+GAjT4
	v8RTUzeQ5CgOXAwe2+Rk5ump3RsUnwsJn+rC7ocSjw2/HBo3XL8P9XHJIe3ih6ap
	cj2PO3/tUz7Kt1PpJHajr6rQ8fEAcMsRFFhahQKUwbfauUJQjEGV3iF7BtyjNzhq
	WW7gWuZbD0w+LdErJ+zRAe4tgh9936qDYK4q0QiRrDdtOVF/qqbPsFIIUk2iUNDm
	ezmdzu6N0bYJTAjmedcUDorOdaczXr9co0GgnHI3U9yyVB2ajcwA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxf48tan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 01:47:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62JMLAAJ017799;
	Fri, 20 Mar 2026 01:47:51 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010019.outbound.protection.outlook.com [52.101.201.19])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4r7w51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 01:47:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9s8qSQ/ZxZQ0i5GXks33JpZbpOJgQdba1ez4YiC09XlBz1O/murKlt/1pxHMuGF+zJBsFWfSroEbXatVVCGogzxooIzvg53Ldnuli4X6i23/iEJygSvhDe4XYlRA+R0hT/wsfrRbsduYrXX2S6iwP22NFzke4mJssSicfz52Bb1CEwu1k9L5sdka2mju+R/wiG8dnLPWaW6/UnME8QaA3J1a6U2tnmtnfYLf0S14pMV4y1/hIVwKREukfAU4KT2aTAW246x6C9Nn+IMTzS+OKF1H3Hlm9tHXnpM8jIjMqZ46aruXct8U7LrBeYxQkAq70vp51ObgAUtcSX9YPsz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TunhhcERvWWt9oW5CW+szy4azivFnR5UnxTx0yZrm4I=;
 b=ChSFfkvtmCwG5q0zYC2izMQ8On/TU8rEb2WNGteoiLBWTxZ8iij5V9a/OvQoy28tywBMy0s4jY9K5LeJZ+6mOO9PkMqFo+qFDmZfH3NXXJRy3f77wv0qsEmrcV4W7zGnarzQLm6m0hKqZSB9hQ37Vp4YYynPeoA9BVdq0zYMbxT6WVNjbh4RrOCB84SVU26conagW7jnz3BlXUdHJYD46itu8nT5jxhswXD+c1GJXKFSEgBEHxQz4XXvZ3Be1HYt0aTFILDdRLB780j0uobwxPywmsRuhfYJVaLBPnmvLE3WHSdO+aEaVf6y1+NpiGz1O8Ya5BM0BifcXDb4iGIkDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TunhhcERvWWt9oW5CW+szy4azivFnR5UnxTx0yZrm4I=;
 b=HYr25CEBkU4iuIqmjwbiSgycxeBabP4JQAItQGFfm30pST1nz2f7nryhDKCHq3Kkoi3fec1cUmmiNMFWMYC+gDVP9PlYCIPEH5JkWppy51NrVPLqTwAsENv2PNi6yL39s3iPvJGqgMmo/XOrpTFD52Qh43gAXyRuxX0Sat/TIuE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB5688.namprd10.prod.outlook.com (2603:10b6:806:23e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 01:47:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 01:47:48 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee
 <justin.tee@broadcom.com>,
        Paul Ely <paul.ely@broadcom.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Use the crc32c() function
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260316223631.72361-1-ebiggers@kernel.org> (Eric Biggers's
	message of "Mon, 16 Mar 2026 15:36:31 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ldfnl1ah.fsf@ca-mkp.ca.oracle.com>
References: <20260316223631.72361-1-ebiggers@kernel.org>
Date: Thu, 19 Mar 2026 21:47:44 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0208.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::31) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: faf029cd-56c5-424c-9a8b-08de8622b04b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	faqNC17MMgg8QPqlaAr4Hczzs0N7ccmVChx1Yhwqw3fSGrNxGC7BQ/MzWPbZ/NW7WwipVNWe2gxWzlbsdslDi37snXqG5tcjQH/6CAXuwmbdGDDdgoY7iVt3/eEhO3WXkT7AJKVIIj3xEF6BaMZzo9PkCy7/rGn8GS37ohP9STYw4vAyLe+uosrDUNmgw3kCRbPH2avQCMjFSODT2rSDznSvTBbXq2bkHP5ciWDPZLtRFiMCgQ0mnrHbFT/M0z5ThKklk6a59r8fzv77Svni1u/ndHYB9qMKaoqzebTyX9+2tLwjwGa80l1sIkQLURHqEIg83eMdmydP3DIv24mtrb/h2Cq8S2XeoypyHdxZFCRzzEmU7RDU7FoCfa39FXKHia1SOUEBCECpBzlFauhLyMqRJ5hs3M96JH1u/djwUy1PXPkBHDzBd5OpY6s+nP0P/e2rtqe0FAU0hCz6+hbY612RIfzIKEUzYSLnzZYCKtc0JOr6JfF0hSZlD6Y6N61tSon2bwEaPq+vytPb2ZtAtBlrvpinK6JIRnYvr3YiYRa2/fwpC7Xd09yVFuJBBUPmLu2fdY8gpTnUKaNgTFMBoiSrnKV0HE0+oUbnHuyEPBqe6lWJY4h5XfqJYK0Ae+x0EjW7X2VjWYCTy5OkuPWomMKn81z8o3vJLFNIVICTRn5QF0UVgBsR2TKbGdOCALApa3lDxtEdVVsGUZnjz24n/1byd0JO2/T6xacV+JxCzKk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HevOqQ0xaCYInYxIenpkHlfza0p24sD+UfFo5l/9mKzHViARsRAGKugd5e1A?=
 =?us-ascii?Q?v+0bxO+fgJhEOMquG9hUPJomRmct2BkmqUMiYZ1tDovn5jWW+WwfzQph1lAN?=
 =?us-ascii?Q?w3HhQzs3TaXk+kufTHq1nLgPpAaEZ/Wez4WhlpJglGnOYYQLPsJLS2f+zAMT?=
 =?us-ascii?Q?9K+QT5lE57kNLfw3+C89DYGZBHX0+QnMkUofciKbrdh34xObhegOexLRWH+w?=
 =?us-ascii?Q?ibuGksqOU6/oO4G6oh8k7PNKKQlbl0GGJTe2DprI5QiVByJHKM68svsgw8sX?=
 =?us-ascii?Q?m0fDS5VqwwXkfh20M5pMG2H4HU6td12WP8ZiOJfB9jz48IzcvOOLDZ10YCqR?=
 =?us-ascii?Q?u2Wjq2PnAyVdwhPTo9PgXft0ruH1YsllEiLSOv4/vNznzy5GPLYIoZrNGpSG?=
 =?us-ascii?Q?1/o+m7L2Qzv19Y8YASfzdDmpN48xuB/rCF6lfH89W0KhRkSquLGO4FQfU1NZ?=
 =?us-ascii?Q?zEqtCd5vlibUP/3JOEuZaGfqHk0/P5StAucSIpT3OTylZUxIHb7hZ5tKBS7c?=
 =?us-ascii?Q?AIacOv+UPScxRiU5u7/18WXpkJe7D7AFdya70iEXYnG/jCMNTtZ54FgnsqpS?=
 =?us-ascii?Q?Dn/uit0WPia4VnyCghegj1yKvRAXgTl2G2ZpL/1Hxx2A8x13n73wMhF7FqNq?=
 =?us-ascii?Q?FzAEHicmV9UoWgcpwCO6pg3zfMzXg7+amHtsozRxkaYgsooCxy8K8Wn9+GO3?=
 =?us-ascii?Q?RGZcdjHytwYABPdbRvIVwZ+pMNCWVAOOG7tReciiWo+PFAyVgl9QetN1zD69?=
 =?us-ascii?Q?lrxRB4Jqenuzz2yrFKiF9/Rh774xK+HwJlv+Zn8Y/qR/fgXbwV68Nh0j79aL?=
 =?us-ascii?Q?GTuSe/RzXiGqIetzOGeBmPEDu6x0ZFuRD9nm5H5c8QsMXgqdsYlVwKwj/Gwk?=
 =?us-ascii?Q?4fnHw2ZkCyDe4v4OerV8KFkgpNQU9Ex2FpktEqh2ETAlQtSJuPGMPqfJrCop?=
 =?us-ascii?Q?nXes95LfBjSlSPQc/YVDxu5HkxnFqaLeenB8AQxS1TqA4g8ZNzi2qfR+/9OJ?=
 =?us-ascii?Q?Wrex6SzwJJANX7EYPZxG1G7oPszTqu8X6JNDI70BA/J8BD6WXDGunBLFq64N?=
 =?us-ascii?Q?pmnSkBzxr/rNrGTK2m9s4+PTNQ5p16Qodbjw3d8JYqPYDdpavtt+/jShZKmZ?=
 =?us-ascii?Q?i+PxfOezFcBLALd8XBRhFGzEXPPZcBrU617tzG5I5j6QrJ2LGNgiFDWeLFJB?=
 =?us-ascii?Q?RmeuFoqtKBkcI1vxpcCwAmqtIsBf0ATj09wfM1XwhVsu4DnCqj6mpz7CzCar?=
 =?us-ascii?Q?o/xJFClF4O9yAAULNErZDWpN4+g0VaPPs/CjB99Ez4mm6gCq9SC72ypk3K78?=
 =?us-ascii?Q?pToKiSgS21+dtjeQPBdr/gDXu23JkmqW4C1aMEavskunhlHZr3i97ewVWnNb?=
 =?us-ascii?Q?ag89comuVPC9qneBSkIss8Bginw0gJcr4bl1fEKI9ab0bRh4Rm02h228MB9I?=
 =?us-ascii?Q?oAfJxluf0WVUhDLBd9xfJ0cI8wOV/toJCEf5yAwZND3W5yqdbnuff2GphVgd?=
 =?us-ascii?Q?L5KjTS0pHaHqaOx7WwY6J5zTe+9t7vhhpHUf5KvuGLyzjX+vi37rVrEpHU57?=
 =?us-ascii?Q?gH3iD2Wtn8aVPjpoGPRjEk6h4y667vQc6DnGFRIaY8Qt6oeggtw0CLiZKwsi?=
 =?us-ascii?Q?k0BENcbmEo/Oex7NGZVr0gEbiwlb4SvCr1kDMWf39wd8rrurVahd0Cx1Rksq?=
 =?us-ascii?Q?+Udr1H53pLKEsDM9fJyR79qXJAc4C7p4NYXyGbVMV7pdxm0L/5ZXUdjkoAZB?=
 =?us-ascii?Q?xnQxIc4aKqgfTOQ+PMILPbfzYir4X30=3D?=
X-Exchange-RoutingPolicyChecked:
	OcUTxD5IboPXo2gaK8Z57+hiwk5+LSMAC1I7H370Qs+V52BTKiV86MV2DyUTZ8ahAo11487WpUuu3Ad7btRP04ltM7Ztms/ZcaXQkGc2zOFCGgRuaHv7ZUkDppLqpR4BX+c21G8iu9TxYRGPHbmZ3h5ANdowYB04TI0yg/C2wK0p5DJzl6zPKrKx8uUVO6ex4V1o5lT9zFuDGe+p62vD2LUs+FrO46QuqxuQ+mybBwqaO3pH9FBxr4Vj5oNByxtpKPj7gHFYUqPdiKee+YB11+EztTo8VEmKpT918smOkZgFX98SPyz6ngeGNgrkwJJhxx43nUH01aCn3oZ7Iix+dA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7BfqrwDLz8vu5sg0h9JUvCV0BALl5B4JvOdMoSquauOxyLGwI+G2VUC5lkUA6sgjQeM5O99QI1Y1qJpQlq+cq/PXlpTwSsyfQ/62JGc43ghcBJtKkLd3wg+0kK+RKwrgFvlKZUOsmyOOxDz/8T/gNSTLAogRGxAbe4U7CFgQT/8BQ/02GDzu/H5/L+pb7Ltn1LA3BlciW3keZH2tm6F0n8fGGaN1vx4xm0uUgLrAvp6ardAiThbMKxFQRw3NFcxF9mVSa1/kW0HESmrd5oi2xS+6vO108d1Wz+HM88a1iHthvZE3lq+gK61kBOSTa0bGl8+LQxV7SaSsASUqCyAceRPt+M4s7IQA5xorU7oBUFPsZwPjLMGcEE8UMEkjT6DylCGR09DkK6Kg486d3gdsXdYcbuifuUIVB25JLHhn4pOTvAudjXWMj1QIDrNRGZo8e9mYeeWnaUeNUNaIj2EnEPezlH2R/I48jstGUnttxP+ctgEXg8u3kQWJ7CUPkatwHVc2+cPQig5JQRTHlUapFfb7WEtxQ4SVZ9Uv9VkKqB0C5BAdidmbrSl2hD4uSWKs/GJ27jltyo5kBllWpBRe11+8phx+gkOG8Fb4hGlRvvQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf029cd-56c5-424c-9a8b-08de8622b04b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 01:47:47.9700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00hljoOaHP1NXZzDDu/u883PEu8O8PtY9tJZ7Zp6M+N0E3lWpuXhslOPUFWHYpJSOHFmfliTwGfeNZCL3MV8JGTH2HotwPWup2zHMtxPmDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=568
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200012
X-Authority-Analysis: v=2.4 cv=ftrRpV4f c=1 sm=1 tr=0 ts=69bca748 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=52_T1jr_FX7imiZLLDMA:9 cc=ntf awl=host:12273
X-Proofpoint-GUID: BWV7YliPMHdsQ7xK2bOluClRcrOM57PW
X-Proofpoint-ORIG-GUID: BWV7YliPMHdsQ7xK2bOluClRcrOM57PW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxMiBTYWx0ZWRfX90IgvzKpd8gx
 N4i5eGjjlZWbznkyb3IR471t2Gi+NRc7S+B3ihbiwRPreNb0NKiZ2Fx69NdHCnnl3R5YJ2Q0Ey/
 1VSuO4pkN+BFg7VFf5PWm05H8Adua0d2eTbtj4cA0mXU1NPDPOZWoPYMslrsxMyA+SlJX8SvBXC
 woVEQsJvwSERx09wh8INaXeo/oriJH7ZXbaiwlmqEh/Kb6TkpB+ZTX/XwR3hP8HPRgHHaFlkKEz
 C8pXy1Ilu+rkfzU1hALK2FBnND8dB08zUomEkPpeaFQpQk/4BZurm3HN/exlZg2qJ0Dv1DR/12P
 kZ8oY7bTolUFOn9DZ45QG2aTHUZJ/TofHojwb4iYKh9cxrBvYzfQqojnhxl9o3yB6hecMQvOw1a
 3C5vEBJSQR86uDg1GkVFjbrNQzVmwgF9g38zK1zvSEGRObdp3qk/7McMVHwjLQZiXT8+PNwYMVq
 YK/EWDQYBus/PTleOaHzXvpRzsFoDujMett864Ho=


Eric,

> lpfc_cgn_calc_crc32(data, size, crc) is really just an open-coded
> version of ~crc32c(bitrev32(crc), data, size). However, all callers
> pass crc == ~0, so it can be simplified even further to just
> ~crc32c(~0, data, size). Remove the crc argument and implement it that
> way.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
