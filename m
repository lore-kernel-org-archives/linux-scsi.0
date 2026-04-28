Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C95423160;
	Tue, 28 Apr 2026 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374970; cv=fail; b=FY7+6o8cVemS8Bap9cQ6TZLEx58qBgJQqiokyZ1KxRSrs/R4at8Tk/yT7wy4pj4HwWW4xjBttAMJZnvToqpw+NlETwY6EGCwhgoOZhrlEYG+GZcZNGezzDrM+C7bG1YwG5KgQjPjmc4fFKrcL8BAgU7hTzuWuWkM4SFsmWprQc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374970; c=relaxed/simple;
	bh=oBQetq8qav/tqp3W2sMMjT7oVv3LTVTrCD1Tt3oXIBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r5froMKSkamUcAu5C9GWHeMcJirHxk0N1xFqzu8MxdvkzIrZB6Q+FNcpQhHCCoMzrkJFJYEkkaU8m7Aj38y60iibouKi6QRAvVF0v1uZsHz0/qEbMwpNPBz6S0Udn8eyeRoI/B2T7WVBCVFE1ige36ZFI7zO9+R0L7Tr5gucj7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oQ4B2D91; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xLZECMwe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oQ4B2D91";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xLZECMwe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAKCXX1015453;
	Tue, 28 Apr 2026 11:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OG2+Hy+rj2lCA/dLjaQv1cRC3hbROwNPhYBHvmlnAcs=; b=
	oQ4B2D91P+uX0HFw+u0ApaR1NeeRlnCqUB7sljBAmjf76lUNIwUPZ7ejGhidarbn
	yINp+TatxaACfIC2EvlrZzITnBZWR37LP8floPdV6O6rxsJPANBAF6YUv0YtaGpa
	lZ/C+kb8vAPv/X3Df0xiBADr/TjZknvzVOqFNxL3SemlQyHzs0yh3koLKO/G0RUi
	IlhdUV52veG7xwJ+vSJkgC65iKtiiQYb+QJN4zo7tErs9r/MSaB8DlJsg8CxZ6uR
	69A1R+qhhKQ7GwMGnCBOVb+5kmIeUJoGJUoQE/MMCdDhdGDl0R70/vjmqcXHuOsA
	TzTKfbz05G1/r3iYYXBurA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yykc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVb038802;
	Tue, 28 Apr 2026 11:15:40 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pmNeHGTheWf7UUTR5smHNwMPVSpIuxojTEhokdOmSYQuNDjNoI2cMVU7dDI33kx/1s+0pQL2hU1qYWnnfLU/bcxulOQk8BhUALgwp7PWrngK28bAVLEI79wYoy/MRnh+rJFBZZD8r0nGwf7TB2mS9+GWPtRfLF7WXyXBNL4Py+W39KYYe6BfbGuBk4HvspLpFZ6Bk5X3sRtzNslALOXKPHa4dBMKjrae7i0FFPYn7KsI2CHBNmurQ1f+UhYb3RSJIORzATgiMBhNhljgG1PegEg+AyWPes7BJRYYaxJKJb/840t5HkPivFSaT37bKt6mKSJuW2tFmNhqQJc+eCiT6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OG2+Hy+rj2lCA/dLjaQv1cRC3hbROwNPhYBHvmlnAcs=;
 b=hLc8JZnji1ZcmwdomsA7zNlHPrYKpxrsGtGchcwNEm+6QobWYgxtTPRTuvJ7cFKWty8sK9UrFRECN5xS0WyoimAAkrwYUEWf9AwaK4QYqM42gGMZag4hrVDTmfrfkCo9mX+Kkt8Q/P+kym1fgTYARF5Iw4O3BIyftnfK2zMwj+uobPjvEXMN6/v6mUe1lT42yq1wBTR33P/InBhnGTkjpgx9g8KMJcHBZ7JgyucqoIiQ7fpbwaiibfWeP1xk6CfWTkGxeFqsLg3p2vGU2Hhw3wLzOnbKrZqFRcUYQ7DLs58oCqj1A0zARt3BnhZzRlFektfSq4f0YlH58JBQPnfdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OG2+Hy+rj2lCA/dLjaQv1cRC3hbROwNPhYBHvmlnAcs=;
 b=xLZECMweo20sx380GDcAv6TerT9j8Ksa3XC+OTBB4+0CSt5lP7qclx7FIgUZbfrYjZZzrur2Ej9yeyIJAz+wPyK3B3N+IERBsGB0v8nXLGmayxaGml23lY973itBlA5vIpH35nCWNolIMaMCakfSedp+jrF201/y1Y6YrIs5LxQ=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:26 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 12/18] scsi-multipath: add delayed disk removal support
Date: Tue, 28 Apr 2026 11:14:41 +0000
Message-ID: <20260428111447.1779062-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:610:38::32) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: acc50c7d-3e43-479d-7388-08dea5177283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6nFHL8pry/yjDkv3Fju/mYO1nSJ0KhLGjQQnGtIG3kioEIZULopdW5Uex5ATX/mCBl55exx9hqfY0FVL5GRG+1WLxTsoId8eXSdaNfSZsxQchHO8C1iokBoG1k6R5PariMN3KZ679lDVRxkGl6n7KO0dbu0FlANeQMklI6tZMvGv/5WltIDRad/2fif6AcAeyW4H0yYtwAATSVUPpSpWTuDOb5gyjFAcTvTUjLJu14NjS0A7Fl6S/Yh8/JoKQoTq/AIrbMjzDJ272JoEK8d6+qDh8o8ggkLLgN8cK+MepGrvEE8Q62c0DCIKwK3wR0Q+HRh6aMr2JoLTRpBWn9m4La4SC8tepr2hFzsR7oXU7htQJpVhMtvLtiBQNPalsB8iomRNc0U/RHjPkJPdx9UrQJpePdWX1Uw5PYKOpvUsAVeKvWX4Lz3h406NxnA42fyord0EHmSI/gqJt3cET8pMedzjKP+0oOK5kIYBKPRY3NIw+OrHBLHzWn0nAnAabxCKIxYd3GZC7+Gja3NLFNbtsH4tTYg44vjqzP4PKHbgSharILF5pjS9u3byoWHFQJhw2oUoG5uBrnJU+AUr2G4n/+Zdu5Np/LxEitNZyl4eeaXugHpLyJVaL9SSrqbLMVCDHvaqdE38x9PIKDK2Ff27FvrXFXCmb4J0FqYF9+abQMDp73/QsFC+e/HbfvLITRzAVE8s6hhyKnT/khBsVrgAvV70K/WWnmPvXkfqp1vAqz4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hACVCPv9oYey0nJNmQ+JLuuhMn0OzJgG3W+r1/9KQnPKZ4yiqs+5O8T/J17S?=
 =?us-ascii?Q?a1zXkfw82iJ4FJAGzNZcyi9GkFsKYGa3cBJbiT94MEy7OSxKIsBcuTxqBzXh?=
 =?us-ascii?Q?BRT8b2Nh3UBMuMSJtZAFFWsxXUYjrCKfy2CN4ADi5QXWMNzCbDKRWzRb8iJW?=
 =?us-ascii?Q?BAH75kRcC147/N9tLnvkIhfPGMh3iLBy6v8lHS9zlsPM4zJzEBgvCRpWYX6/?=
 =?us-ascii?Q?JxPWBjMPv8MyywG6xNQA+kW/emoVLvj2R2WGYZ/Y5T3EAC4/Up8U3JARofmg?=
 =?us-ascii?Q?EnOHLb64ZMc1W8N9EeR9+44cH6wqdDhyoXeggaSorwBXAdPOrKods5Cq4cZD?=
 =?us-ascii?Q?IeFwMEeookU9Crz2lMoD6wJ0+d+ulQY3C5RFsJh3Ip8xDRK33W2t2MbRRJ+q?=
 =?us-ascii?Q?+SfsIbVGDem5ASG4tsreqgCSF0xTfCy+FX+hnMsTb2ERXoX9gUuPOcv+Su4J?=
 =?us-ascii?Q?xb1/2rnz7iR5kuD83090CwqC9sRBvs2pm6VdwfXGyBndhQq4rW2Xxibd0+aP?=
 =?us-ascii?Q?U8xrdp5/CYEQUsgzlqwka1nsrpajUP3dHCC/qNha2yWINBkX4Y6ZIIfgRCRW?=
 =?us-ascii?Q?LRKwrmzgfWkkvXNBLyDt1bzHRK04GK4kCUfFtJ+fXBbn5EvZBG1Syp8+Qelz?=
 =?us-ascii?Q?sUPP8jQBcDATQZ+ahKKJiLTPcc43burAIerWqp1QA/KkwqLL3TCnA/t9F1+U?=
 =?us-ascii?Q?S5Btuvmk3qewJsly5KgfBUIhk4UBRHk7Jxg4/hUqBaZpZ99G3nTbC+CtG9rR?=
 =?us-ascii?Q?FyA3g18QtibqL3blCtQa33KQXEuH2se3iepBMumARyYpJh5de3z1DBaMjJTL?=
 =?us-ascii?Q?rgC7hyHcHGey3sqTY4gjDzpV8381ghk+ql2iXdPN0JdsA7qyXTYvUI0WXkUu?=
 =?us-ascii?Q?C9pML6ayr35BXsQIzLntI5TTqB+ozQb/R0mGHhjqOAkADuEiQCLm1zN7qIys?=
 =?us-ascii?Q?VI8OnG5iQFf+8K34y+tTC+59hIBJapnHYrHuYe3+54pirInQtIQdWNFOFjo9?=
 =?us-ascii?Q?ULARkO9cDc7r63Jwm6iwv2iUN/yiVSfYW8v/vgS5Q2Yr9veMkXshxoHQnlKX?=
 =?us-ascii?Q?XQW31OkUFm/gkUdY2zlfBirTQTG+NcByl550+heksF9LaY6hjmhlcGjvhvr/?=
 =?us-ascii?Q?VEifgeACvYKMlxl/8g36UojYmS+IQ9UrZioJK9Ppzm4QMOr4jzhoFdxF7zdB?=
 =?us-ascii?Q?xvHYh1uGN6SGUlCgKwk/Jr2grkcBC1R8w4u5RJtKsZ+Fy1e8QQ9PHIujohe5?=
 =?us-ascii?Q?fl2XCOU0fmF+iEvnFBKbTZWglvYLtGquOjYISRVakprHSxmJNCvjTGBH/K99?=
 =?us-ascii?Q?/4yhRpaDIVnSceWya3SIkOH6n+HJHjmagHAVNXnb98Q+5lYVATcdp4MW1kvr?=
 =?us-ascii?Q?JWkLgQXMCj4szCSUKp8XVz1EsW6iVoWU/MYpPcrVpm1Pq6HgB34fiPcZWxAK?=
 =?us-ascii?Q?89SK4U7iNLdei7vfWJaVqDej3F2x+JusEENf/VfkEBR4sydmV0oSVhtTJZJ1?=
 =?us-ascii?Q?vraLAp4zEfxOoSc2MXCV/INNlmJaKS9RFVUwgOzrZCXfZvTPawxc0QQWnzPN?=
 =?us-ascii?Q?LkI64c+Chp4JeVBlBHltQke7/wmHYrYXGFmEXkEFcwCk4PjkSF5WtvvM7Y99?=
 =?us-ascii?Q?3QKub0PrKJncq7wQKyvzSmCpq8frVzLzpe+VLg345iQ0muCJu+2w5AmPuqrf?=
 =?us-ascii?Q?mfbQ+SilOMBCFUTde3x16N25E2X6wJoPeYJFp2bvSt981g4idfihL1NXBU1B?=
 =?us-ascii?Q?eLstMjViIuQpe64NkmGAgngk4PoHOOg=3D?=
X-Exchange-RoutingPolicyChecked:
	l6JN+utBv4OdY1VJjIZBanxgGsA7LB0m2UBpyaxChXl9ZCaRWtKD2nHpnA177vTiz5UNolaIYe1MNMnGUhEro+hf/HhVFvBKKAYdkc49l6UM8oOuchm0w8NOjrdM28x43auR2cjjOU8b0uGzgKPGyEqN2TJW1y09oQMD7JFCrc+qdBvFmKy7K7H3IMsy5Rv5COhcL19j+IWuEl/I8DXLJ7Q1NHRoGhW0MIMx1HTnLeUMNe+RRLKaeKhBMM+p3K5e71GrtW4O+Z3f0noTqc2CVoSKYj4cnISUpTzpVCyE5am42qN1VzXKN/yqK+9xj9zpMYFYAjv6xurPA6Y8goojug==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lZ9zfaWB9zVA+AhLDZYykulWaeC3Cm5k+WljS9ZFNeFUV2XI/iGHHJklXALjg0X9Gyd+EdNiaEGMeEMBQsjMisHerlwkIm2rtEXIy1f+RS9zgEmwChiUlFjSAt1et7640BXs+A0g+VOY49bqUs5+BeCWUMMDaWboe8G6fes/B+0700ytthn20WxiJgS5nUQQ7fnKjZ+uokdDlwrjk/zPFm8SPQA/7/xBooH1Q6uMKyyaB4cjW6g+xBjaw4S/TshynTiPQ3hFIzSbFxH3PLEJt1ln3H1YiQORsyg3GDpO8+WLl2Hu2/7C8Q9ze4N76GvbWmftqtKO+KbUoKR+gVeuXPvI49FkZ9GNGPpSSuhwcxliCKZJ2pUi0jL4YerYEM+3j2nO9UvEYxajsu1L3nhE8pGBELoEEEae1LRMGairCNtWOsQWHsfSO4yEBWAa5dZXFKozkAUQ7meox4R6npLGvL5geo1k5vjMerqbBq/Vz1IbQ/brc/Emdeogw9jO6JpG65hVMgDBgpWBhGlkll1QGRjYS15HPgR7+dRtytXSFFm0278YFWTqX2EtgaVhXiFAlVxUZBR9oxfxQ7iiorO0RdhTK7cBzWZIkMid9+zA3x4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc50c7d-3e43-479d-7388-08dea5177283
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:25.9043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOjHG+Bn5EgN6igYkSt3R4giPpcRQxMhR2BO7/ZnGH2YdMsi6mGbdJUCYxC7GY/+9mQFcUa7l8HV1+IIiBLiaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: WOf_IMvtvw-SAhdsZu98KGgW2rWLY4mT
X-Proofpoint-ORIG-GUID: WOf_IMvtvw-SAhdsZu98KGgW2rWLY4mT
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f096dd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=S0-NFRiyq58gb8qD-mcA:9 cc=ntf
 awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfX8CDlpYra+VQ9
 //wDvAfVtOCU+h51okL+aRIbm+jejplSjNa8N5o0Nb+p37ok1Lh0uXWrm/Ewd5zPELgSQr1O5yv
 7X9oeL5qgN4Fqu7g5uIdOColisQ2rCk9/ucSGFbROPE65gBy7Pt2q3w3yTw1ctBdVJCKVnlasDX
 dD26L2DOm/KukYBZHhC+xRrFaPVIctC/Fvp/KSLPZcds6dlFG0ZKndXH7aDA9XE3Dp9MBWavgTf
 bZyY/5/iEEOyfeaW4DEeLImsd6SdKC16IT1MN5LsTG4IaDAXeSNbrvyBQ/8egTjE9DK4Utdtt/C
 xNwiNXtiK6F6aSkozilsZafUmpSuFHnElG9Y+Glyq+R6gXQoZTbFbKeAFK2E3cFKSZXeqo8RgQa
 cH4Vjoh0+j8o6vHI1p/hkMj8Y7/yCMODQ2QWolQowdhCUugAMBTYz7iOvVTwGz6OQ7fNaXzuEXs
 Bz2P6k+4ON97WtE9AuYHGGHwWgflfR1mTam1VIVU=

Add support in core code for delayed disk removal support. In this, the
callback calls into the scsi_driver to do the necessary removal work.

The scsi_disk driver (sd) must ensure that the scsi_mpath_device does not
go away while the delayed removal work is active, i.e. it must keep a
reference.

No reference to the scsi_disk multipath structures are kept outside that
driver, so that driver needs to provide a scsi_driver.mpath_remove_head
callback to do the necessary work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 18 ++++++++++++++++++
 include/scsi/scsi_driver.h    |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index e0670d353e59f..2806477e1137b 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -372,7 +372,25 @@ static int scsi_mpath_get_nr_active(struct mpath_device *mpath_device)
 	return atomic_read(&shost->mpath_nr_active);
 }
 
+static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
+
+	if (scsi_driver->mpath_remove_head)
+		scsi_driver->mpath_remove_head(scsi_mpath_head);
+
+	return 0;
+}
+
+static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
+{
+	bus_for_each_drv(&scsi_bus_type, NULL, mpath_head->drvdata,
+		scsi_mpath_remove_head_drv);
+}
+
 struct mpath_head_template smpdt = {
+	.remove_head = scsi_mpath_remove_head_work,
 	.is_disabled = scsi_mpath_is_disabled,
 	.is_optimized = scsi_mpath_is_optimized,
 	.available_path = scsi_mpath_available_path,
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 249cea724abd1..d92b63d357f2a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -8,6 +8,7 @@
 
 struct module;
 struct request;
+struct scsi_mpath_head;
 
 struct scsi_driver {
 	struct device_driver	gendrv;
@@ -22,6 +23,9 @@ struct scsi_driver {
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 	void (*eh_reset)(struct scsi_cmnd *);
+	#ifdef CONFIG_SCSI_MULTIPATH
+	void (*mpath_remove_head)(struct scsi_mpath_head *);
+	#endif
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
-- 
2.43.5

