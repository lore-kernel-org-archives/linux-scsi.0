Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23C03EDABB;
	Wed, 25 Feb 2026 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034053; cv=fail; b=TNXoZuvlVuVJ46pOuxS6jDG3ZMMdugPpvxzniiuXbm2ONwG49bALhE9YwL4jcKfoLPl5hxQ+0xVtSgG8GhF93OjItmLNKFT6BvR8hHMC2w2zmZEltgA6sEvg0AiV4RzWuHjdi0RDi85uMNjm5HmnRqZXHFscN7B1XlJJFSmFSnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034053; c=relaxed/simple;
	bh=XlXtnTX1Fj8w/vOaSfESlOdw0C5tkXxenPdTCbD2POQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WU6Hy78+18kdQiVox5/nmL7xI7LbcWhRqXWNZy7vPGCWWP7Ux7w0fnBeiHoqjrMkfd1rqlF/JXdAtGfdfgr9VCvM/A2DddIafnjCh6IXFOL3dCcDGWF/qUeGqqQBhDfLKSSxHb4lLiURsOKfI0DBZneusMdoxfCW3uOGhv9P4NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EYFVKvHB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FZ0+AXN4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EYFVKvHB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FZ0+AXN4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9k0xV817477;
	Wed, 25 Feb 2026 15:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=998MVt45uUtvfCQ9Hxg1lcbYpxzgObDPVV+uKWtmdxY=; b=
	EYFVKvHBayjltoDSV8w9l0jd5RwZved8/XA3Ynhim+gfGHvHuFSJss8e/sPNxtsd
	1TEJQ/qqLtyn88IosTBWKc8UkxekWc1f3k7MhxUb2DkFbGDgl2fgGJ89KDQmhRrJ
	5ooIDbMbI1OF5fVl6iwHohXsV3FJdnxiJzEBSu0VrpaLdGJ6y4RpJhIos50z/CMH
	cP1KICDITRveTxzLvzACzKeJHdH5vgBTL68ApU5CvY0m+RSsGYyvEzViYSIROFT7
	5EfWEg0EYvzo/i8NornyJMoAy/Hv7M3DyWyhpYPBwxjASmRk/ColJrOSe9bLt7hj
	gNnR9Hw9A9syPVt9788Nyg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areetf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFZiba028449;
	Wed, 25 Feb 2026 15:40:37 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35b7pak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OP7SL/RpCjVqpTg89mia+Kb6yM9kAhBfQmDTGyK2802bM2qtxvmG10w0oVbGw7F+CfQcfDIAWEoU0SJbZIym07a2XIew2QEffjJO/oBzleQTvvf2OhlcVlss3Zeokp7UrHOWUhpnx6uWWv6fu+xGjA8jSIakNIBvxlGdH/zpv9gFglBFRfTIbyHPYk2k7vq8D5W53UcI14b6GBhTpughcSAFOKVXNYnU55fFkhLLV8jRuRJbnZ0iXwSUgBFG6rGF6teFk5/GHNkOT6w3xvKXTjiyAGvBQf/8WlllL7ZU6Y2jQkv4FSrnhTF+sU8eW2U+UcR98FZnocELGwVogNqoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=998MVt45uUtvfCQ9Hxg1lcbYpxzgObDPVV+uKWtmdxY=;
 b=VgvwCszjFW+18ktj2swomZJF3mXg4Asfl7vyk6kh2N8QtuxrK2Rn6v3GROLTGLXl9VolkCet+hMCGYqhJk+egmVfv19RiKZk9hLxcHDd5Ph35MGzqf2EirXmgM0utWhx5AHJ7ceADO3TUDWeZMzFoyrO0QPu60NOcMqyjsoVxsqmVuJIc3Cf2Zb3rHnvepvJyT7nMMEd/zdfGThL1s95e0deS/RR/SQ5DCnezgYqISAcor42r3gaiONrVkihM5lkn+IzsEUQQwiPagZfi9JaMzOgyUgFreisOLsREFdhM7JBAVSixaZZBidV+RHub9rFgUX+u48fYRHJx/9D2y4rUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=998MVt45uUtvfCQ9Hxg1lcbYpxzgObDPVV+uKWtmdxY=;
 b=FZ0+AXN4wYNiCpaSzaKd9PoOLcZb0rT1tDpnNEj0bN4zuqAQ/+paLjFGM/4DjriWNNqJE4GWp9KGt66S/D+9RhNtaURJslpJBVKpEKS9F6hUZJWZBg9VM96oTyCa6TglCB9UjlDwA8iRDxxLxoPZ7zD5KEblOkk1IYRWYG+WzMQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB6319.namprd10.prod.outlook.com
 (2603:10b6:806:252::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:33 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 06/19] nvme-multipath: add nvme_mpath_{add, remove}_cdev()
Date: Wed, 25 Feb 2026 15:39:54 +0000
Message-ID: <20260225154007.1033735-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: d91cd9a2-4a9b-4bcc-ed09-08de74843635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	N4xC8+t6fbgkd0sO5QCy4eFz1k9d+Guah2b7D7eLWSsPO+bH0wCjmHpROg7uetpTT8uioY0Xpcccaxh/UpXvg1wH6hZWNsj6Zpt9mkR9l0DGeoyKvmwTeD+jzK1LWDm6MbEHlEgkIvrMUDq9D3vfLl4ko3o3TdKAOkQoKC+41uspA10O1v6rN7mIqya/HTe/7pZ+sqQWlx5N5LVndsQgr5ALZF2hrpwC5CeDHiqVafc2xcgGowSiIWj7E+eDen2vv/vJI+t+eHeeBhbyN6DXeUadkwCF/cbCYMMz2U8iBKEoiLWAgWIAMr1wP6JXEfoTPrZfdiDUr4JI46+975MLa9tlihqf8nKp6YUWAh1t9vNdjKtKmgu9qrO5c1h3VzRP8/VYKYWjt8fx3PAijEmQSHWGU7wAXtn0vhX5zYraqgDPFuimoCbGWuQ/tFo19BetOV+0scCu2HBfY9jK4U/My2rHBEWoC59WNTBtVaUxcIfekMN+4VAhrAPWPdiSAlTeafTn6k7Str06CE6e1sH7h2eiOztx3cI9+ELtMuXcVQW+am1dZKRdqclL1AuVUI64jhQcAutwS4XJa5poGaupRjj2ww+zN3XvRMz546cTpgbsLQK/i1nLVKBXO/p49rbahec4I5bc6gsp8mW3OSThSBknx9+x7XT11w8FOE0KjeDBI52tp2JckYD0TcgNVfaqBPR8Ghqyja9Fcr6+PO1qkXdT+Z3ybIx59+GpZTQlSB8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ey831KxL2tsWeydATulExoUQAlril0ZUeqnRDpcbTNLhLA0M011pc92kqGgF?=
 =?us-ascii?Q?K7o59rQAB8ypRRy6UD4jJfZL7ONockwIhMu+liVhHzuLLuBJoqKwa/m5txdZ?=
 =?us-ascii?Q?/KVdiWFiEsd7Q9RQyNvm7uSTsyWvIfNplvJfgX7ElVbIhMO8RVLPRg0oJ4XM?=
 =?us-ascii?Q?WmTq8AX/1SpWzQ1XXa4Nop5YpxNldyLx1Rt99+JMxBmJykvWBd6q/lJO5lLq?=
 =?us-ascii?Q?SbZnI224P7wLhvAnO9NOhEGsbLVUIPQjKMUcpQ63P/48nc4GpZUubzWg3iue?=
 =?us-ascii?Q?BBYnWQwfKfIhCLqAtjd3gDPbJn408qn96kMkFiBe/L6EGdo/kq5X2hoF9PlC?=
 =?us-ascii?Q?sZaCtd910vqWzAuKZruvsrq6Y7FNeCeLYbnUXy0Cr5MpjaktZi+wm93gWG7H?=
 =?us-ascii?Q?OVkx8j2Ft69vhKqNsIs5Q43EZEcnexjeh4AJjzYmgoaUp7ChBU0W1+Tkrd2m?=
 =?us-ascii?Q?Vjg9+01tOifSWjvfVklR94I4kns6UUofRu1w8X/t2UM0hePHTll2d2ofxGh8?=
 =?us-ascii?Q?4xWPXomyLvz+GGdhSc0p8+mR3pkaSbZ/TNc1AWiHHccBdM1dVABbwRDqNkDH?=
 =?us-ascii?Q?lc/dEoqrhXNgihUzoicHCjTgz8ohT8UpUSqrKNmI2Z32YM6CV1i/vswK9GRS?=
 =?us-ascii?Q?4Xz1A2rHl7YbTQnRR67CkR1DvP9yUbhHzWHcfy/rj2V5Ro+J7m54KjHMlzLR?=
 =?us-ascii?Q?lVK0HMQaKOZLg/WkSBu3iVwCLC/4qR/58NvkeYirvegDhdZMUcQm8Pcg0McC?=
 =?us-ascii?Q?WgdOk+fY28qphF1nLEQOqDfkJdMeCcRfQuOSFl9oRPtJwzAhEbGm/cxCguSt?=
 =?us-ascii?Q?bkx9uW6ooLRa5lMH27RSQgKCVyU+WU2/1xDIspZidLq4vshIDYZZ0z/3ViLC?=
 =?us-ascii?Q?6zTXCGgeQipPmkg/FMPwmDfVT1mIGHPTflOf57PKC0bK3rbSSezYMsGoMeZO?=
 =?us-ascii?Q?fy0TIHMZYKy6djJ3KcmBdITVZPqWyXbMyLGCVKQJIKStp1uXvLZa90TR+L0N?=
 =?us-ascii?Q?o3OVDV1XZJri808uDH0PtAcuZBjfrKBTZgpf2SBplHQXYHtPC4RiUTFPsTNn?=
 =?us-ascii?Q?xqtsAiUhvWYkUnjC9Bp/mkL4yPAasUNrztBufzWfxlPnFtGxhIOU2FnaU3ae?=
 =?us-ascii?Q?gIF6xzb1V2ZmrqJClTC19IdtD6nQltRmsZR5Gg3QOz5I49WaQ9f+DEcqP2gx?=
 =?us-ascii?Q?FBb0ray3PElHbuWMdW0KgTlX6a/hMygdqcNCiWp5WNbVqgcauT/2rKzNjZqo?=
 =?us-ascii?Q?jgAZtocEFSS36sqrojzYVxql4v0tNIC+gUYUugLcPbMBkxiQ7SgjQeoY0LuK?=
 =?us-ascii?Q?Ap6YJPf/7Qm+1nWmfbgD/wIwZiGj4o+vuLTE0BFsXtnRodpaHuun9LCvvL7s?=
 =?us-ascii?Q?HVjSTrf83s9gSyxDoucCbtcOAvn+RUj/oSSRN01iUFXXWUsO22DJS6Be0qi5?=
 =?us-ascii?Q?BrOuLoKsVt1fdYKywgu0i5sWw2nl0yPUW5WS1EvCqlCuQJSC4oye7kWydyhz?=
 =?us-ascii?Q?d4dH2VNmO7xzjvQf+f7CXTi5zzDAzXICaKbbgCNsQGyuevR3NA799pffwk0K?=
 =?us-ascii?Q?Gf8f9h2eeJRepvM/fGLGnPmANjaWFA34q+jwB20CP4zngBCfiieNehSYik4V?=
 =?us-ascii?Q?nE/HIHK1TG/pW9dIR5jeagbhCBxGV1Il9wMZup0d5q7YwI9dMsjLJHOnYqQ6?=
 =?us-ascii?Q?N8WjbgrpTV1G3ps5fP6PUDFMxeNPEOEiQccoUnbFu3H0HePC5q8AovPgtpGz?=
 =?us-ascii?Q?e/J96mXdWeQbenHeIgxkAv58HxvRd3w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4FcgZEqHpnQryluFW2i6L5onK2BycfAmAbrCEoCn0cuF/Of0fWr/K8sCjRiLN4TDD4AN1gHzz79lSoQQX1McrZxLwWVGWJw+/FDCjyPqZsRGatjTO0EkPrzKc/RFGQTnqL76pbcvJ71PNGmY5RxT69+6q+cZ2BD6fJjJYe2+9CfWx7z4q9LxJjO1b+6cCfqDITf9WDP5paXS/FYggjwC9QuzcAO4IRRVLeTI7uJWQjnq5pxxdHtP4V1wcTzxiqBS30VMOgSCrPq5TxzUx+QT9CjStmSXKvHSWJJtqTZPWc4zCTz1iKusN9suCvCBwNZ57OxuvXagIq3H4Gkyt6w7/GNrWp/2U941PUrSZe++50XNXnRPHCAxSOdXTfIARYY4pazW3Nrr3M0BuX/B10Qh/aJSgQZk7djva+2uWCHQtykOs+eq8ibLOyfu4s/8Kf7q0i8jYlHd/dVOpXtlOj8Y8qGN9Sr6hFm70BuQM2He6NLnxpJ/QjVTPbd5vkjqawCk5JkKdpiPh/pyUTmYQVT6aW/0NYKWY3RquYJNied8YL7azCY7LEu0S3rD3p/8DejsCJTZ8Vxd/jqKvhrAsjSG5fyoiSM/xebjlc1dEwGM7ps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91cd9a2-4a9b-4bcc-ed09-08de74843635
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:32.8580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JK/Kr8xrmAOhx8x9i6qKRau8L1Ry70l8rpeKeulRkO4Gl5ehGjPv6Tec9G2uWBhi4cdtLL84ttA3mThyjt3Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f17f6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=uY95S6If6i8ttexQI8kA:9
X-Proofpoint-ORIG-GUID: Vhf8UqDy0BQnhtw2_RIL7rzpobxc6u98
X-Proofpoint-GUID: Vhf8UqDy0BQnhtw2_RIL7rzpobxc6u98
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX1Dzc+fCmski0
 1p4ON/gy5z+NiHy9b/wIHYwFmzHklFdZ169uoP6oz4M5+ZXXxZyDzAMWK/OU3LUXIwhpBWhTul5
 NAGZyXaKQNTejs3lpol1BEACEVs6ogFpG7CJphwDOsToGe+uL0YDEbqQdm8qmm4r9SKWzNGIo4l
 HFf+eUD4H98bzqwxlgDJBMOA65LRShJpkDut9V9tpkE+p2u90/bN1Y+suoFXVz5i9YxJyGZH6JQ
 wdTtkK9Qy4BEi9CDMAVVjkeJI0snLzeNVOPAvGYHV2/nNSvr2IE0khwjaw8mw6ImOg7YLdg3geU
 MKDRoLTbrRJCMLs7V0uOMGaWYN0cg9zdmfkhh/B7DNbiv2rCs0DS7i+1EvrA7F2nX3gT5pMyR1Y
 7deQ8UmSHabLoy0ZZCHeZWYuShM+MuW/bxQdAcETKKcfqieSRrt7YYUpJKPJhCFeqzx1nzRXi73
 XfQpSVzrwoDEBIivHiw==

These are for mpath_head_template.add_cdev+del_cdev callbacks.

Currently the same functionality is in nvme_add_ns_cdev() and
nvme_cdev_del().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e888791b8947a..c90ac76dbe317 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -628,6 +628,26 @@ const struct block_device_operations nvme_ns_head_ops = {
 	.pr_ops		= &nvme_pr_ops,
 };
 
+static int nvme_mpath_add_cdev(struct mpath_head *mpath_head)
+{
+	struct nvme_ns_head *head = mpath_head->drvdata;
+	int ret;
+
+	mpath_head->cdev_device.parent = &head->subsys->dev;
+	ret = dev_set_name(&mpath_head->cdev_device, "ng%dn%d",
+			   head->subsys->instance, head->instance);
+	if (ret)
+		return ret;
+	ret = nvme_cdev_add(&mpath_head->cdev, &mpath_head->cdev_device,
+			    &mpath_generic_chr_fops, THIS_MODULE);
+	return ret;
+}
+
+static void nvme_mpath_del_cdev(struct mpath_head *mpath_head)
+{
+	nvme_cdev_del(&mpath_head->cdev, &mpath_head->cdev_device);
+}
+
 static inline struct nvme_ns_head *cdev_to_ns_head(struct cdev *cdev)
 {
 	return container_of(cdev, struct nvme_ns_head, cdev);
@@ -1433,4 +1453,6 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 __maybe_unused
 static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
+	.add_cdev = nvme_mpath_add_cdev,
+	.del_cdev = nvme_mpath_del_cdev,
 };
-- 
2.43.5

