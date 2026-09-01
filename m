Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F14E47B439;
	Tue,  1 Sep 2026 10:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259574; cv=fail; b=lJDFfPuRf47A/EbmUA7hzV5hmVqbCcQ6xEXj641Ee7EzbFqnx6ebthnaBocPCHrgqhm7VJgVKqniUE1ffAh6uqX0JUt9dO03JnE25I+RoMPJ1+m/IEjf7FwTogQR3G97qTVp+x3DpZB8FO81VfEFeLi/aj235+z3bTE1XwT/UNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259574; c=relaxed/simple;
	bh=6iK7AsgaBWJeqs9ICeclYH26UuCoLOooL8REcMQoLto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a8MkUbrk9jyrPqqdEgRCce2JSivsVuMLp6YQfsm3oteTNUm21X46s81f2E+2Jl5Jl7zdZmzZOBKQlAOPAuklJ2D4X7lASl+JJxsdmpCG0G47gGyH/gs9l42xSJhqgCSWeEMvIiqfE4YKgKfYTYbySq0uGofyRn+wYRJ6eD9d/CE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TBpuRdZS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n70QCG3i; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TBpuRdZS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n70QCG3i"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBpPQ2679686;
	Tue, 1 Sep 2026 10:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DKSFKTdoWfDQmvLxvUJGgl+xWWAh7awUAfTfe7zHED4=; b=
	TBpuRdZSK/tqjzZTo9GweFwI4Mvl/xHQ5DEpDdVhpVLRhrMTzkjYKSPEl3ktSzFd
	dT5aO1l+bPhGa/5RdB/nHLJfxgNIc+cUEubibjOo57Zut+jU8vf2ciFZFoeAw41t
	dMuHlLBTcurHfN1zEoDhv6eFV6b2kA5bMA/v/dMgAX81PhjZYE6Gt5Mwsk2F5TAY
	fBSN9WnptowHaWkaqEzQ5oPtveKVuDB/T5o6Mk/Jnj4NCum4/rRyUuV4Rkkr79ID
	2vsR+QClsuzVYQuRXZcRuYVIQzI0HNF1Wq1jMKKIvC+JXLcQZr7wZqbtPOnWRT4E
	qVTizzEZ8FhzeU8FFUc/yw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqa7mbxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjJtC036963;
	Tue, 1 Sep 2026 10:45:46 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve348d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W0+JDrNNDSAfOI4E9gIJnDoQvwkviFPgf8XJ7I1wEUVWSgd/1xSylnLkR5vi+unw1GUM7KGKtjEUibKyeEXXFuYPQT50zwoMXsiB+Hn1/Xo3eVXN7mXN5AaiJi2FNnkqxGQPXv1a8rGUa8fZm4aQ58fOM6cWxqaozCo7Wp/KgoBn0t10PGqS7PRQN91P4T9Zco7TYIllfdomTh7m8AeR3cvBDvbfm+uvlN0cjNEd6puEJKKYnLgbTmM/u8iZCVuRsb93T62H/Q+MZDEhVyiy/ntjk3xKg0g8n/f8nf6vat1JOWIiG7qFQ1bROv3EoaxShammTezNNpKsRx6FoD3uQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKSFKTdoWfDQmvLxvUJGgl+xWWAh7awUAfTfe7zHED4=;
 b=MR4uxkDteLM+zi6+RTe2b51P0dFWOH3BycLtaojljvLVUGC0IklOdAr3pDmXA4BRBu8nvPwu5mNzT+sGVU9f6//33pSy+QSWeArysMCoArInH2FDYozLpFlpdgZtee3C+lNtRKkB9gTZqiHCmSEaET+ffC2OZwK8sA/Ss3Y56vSdPbWDPUxPX4CL0RyHMRWaMC+N0CI/jmVeohuxxOlb62s5mgevl1NpEavDhFJ0t5bxgxhXRMoE30ubnft2TegY3bpi1wj3V/kvbAciS+hSwVjZq8BVt2/cjslbppgAqI1nEvj9WuzUPUUJgHQQKJASgHsjCbVRfG65fLB9r1opcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKSFKTdoWfDQmvLxvUJGgl+xWWAh7awUAfTfe7zHED4=;
 b=n70QCG3iCGhWZhy8mpf8UbNLMS1AHaqXKwS3Mz/HRqqM8/pE2LEJtjqFwKZXuLPjT50i0y/xIqBxugaSlvbJZpLjVkSYwgCfkkekXTeMZDN+MBKlA9gkdHOEqHbIGaerjjjyetYFuFf3Xta3fESeviZoCB0CqTxZzQbQ42N81Ag=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:42 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:42 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 03/27] libmultipath: Add path selection support
Date: Tue,  1 Sep 2026 10:45:02 +0000
Message-ID: <20260901104526.3850621-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::25) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f8539d4-93c6-465a-c1c9-08df08162bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iqYaTIs/G5A/pHZ2N7dl8Hv5gu+PZ3QMiTh93HS2KKag8JbA5ZdOEEjE+UCjkRONflp2+rZvlm+/oVhu2Ofga/9JU+Ndda/hkurDTFgxj+ELxpp0DdrhzQAp5af5+UWfyvIqs1s3a+0v7zoSJd48JcJNWgrU14PrP8+cQrHg/mKjKvpiVj1RjkjQqBe0sb/uLix6JDsU6dEfN5hpNF2fwADirQyOC9W94/Dala4jTRiX6HaZDIy42/AuZvqTkz7ov8HpBc1RYbMLdZHnxkWvx07MT09DFzE+EmYNp9G27V3RmzySxbjiYiqY3alvBgVOteAAfqMlM2I6hNKFxHk07aoyO9WJvcwT8qZocmzjZPHFE++KSpD769Duk9AYHES/xomBYJ2vUrDfTeWiANHsfo2egpy7pp0EC5qDWozrDUBsNUQr6coXXk+wVQDCCshqLayP5/WkOzvloiR6hSm8wWbSUO9U80Z6pkTAJVBjjXPQGg2K9+Ni3Sq2RP9e2q9B6882L9a8B+DNWzVI7pCWLmjPP0ugakuw1fZJ7PdKZcfejWf8NgcGpdNu8oixwFMj75Dx+VMUXBgMbk4TyagOmnW++fxAZvdFMw9m78Fm3ghwM343t1FPIfPyUt/V8qAJfUNed00gU8ZMbCovjHxK+CiRbjZ7LaeGOeoki34k7Ss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9TM0Nnh+LrxfetB2Jj5aXw2qV03KRPPO0OyMqoThZq8KrTjYqvkABidf0x0q?=
 =?us-ascii?Q?ce8LioGgoPv4yBnKhKq9mOAnPpp3c2JxY9Ex3f/FUNZvSbzyIXQWr+iuXAui?=
 =?us-ascii?Q?K4n4tXdqUvrae3Pr8OpQU2/lPvFR5YaH32qiPI79LpMQsKaG+d40ChhOFgq5?=
 =?us-ascii?Q?3g7RVm4UsqBwlJXu9Gz4Wcpu7vzLPw+Gc39lHNOqQ6O9+n8aAUXq6Hpzm2Nv?=
 =?us-ascii?Q?rOJIW7y0uB4/f/c5KhGSx5Wwxl2l29bQyBFlzy8Ssfb96hg1tUlj3lZ5sguW?=
 =?us-ascii?Q?vBGK3eV7dTdn6zlmMTKhNsFpqPp9nvAdTB2sQhXvpIc00xUQrl+apvS1CekI?=
 =?us-ascii?Q?z4e5hh9M9mSAVS4H6rcRuy8XDYY2NcWzU7XBNST35U1GOoJ8WoJ38Y+2K8t6?=
 =?us-ascii?Q?3A25p2vy1kFrVKZ9CurtlsbD/jGfN2Ykiqtg9Y9m8UVr6bwmd1OhZo9ZPvTE?=
 =?us-ascii?Q?Jsf7htPw6DGIG5G3JSAiZ457yoERZMuZlz/fM9RcnYDRCHHKhXUXJidr65TJ?=
 =?us-ascii?Q?zA4itxij1uiVG/jBUfa30AXwun4fup5nce3oCtk7FWlUr0760dnVbSgOKUx9?=
 =?us-ascii?Q?ir2HNRZTbpCWGU68CtJHRPX4ZCzZHI7j4rJNUTSaLb7rzvZwniWjgNi1qGfS?=
 =?us-ascii?Q?3Fm+qlR/b4DHaKgzOtXUqdgQiVXhZNQOHd7kpygHX+0o3t9pzYMcu6t+RJCZ?=
 =?us-ascii?Q?lUkIuG6sMdiMDsqxTn8SaSeZXHmQELbS1skndvQyOwmzsJh5sJLHrdl0Xnop?=
 =?us-ascii?Q?pO13WBfX02CyPsJ+SD2ToH0Ow+4zJbmHLeHVv3F+8Ik2s6/OhiISFFH5GWHn?=
 =?us-ascii?Q?FjrssiqjiaJLDVMUHNynCiZrbJ54L033QNwhpuuSpL5UxxM/5MOnxRfuPd1f?=
 =?us-ascii?Q?BFRmuOpEGJGADON9rkolyUnhjdYiyzsedS6MW41ROagNGdZghROP4YK8yjGc?=
 =?us-ascii?Q?PhSHxRjNpSJyZAG6ftOqhc9Yl6TejrCQlzQ0HmCBWOOJRRLJ9X0sEck6ZcDi?=
 =?us-ascii?Q?JUPdK/BpPO4Db+cXmBCvOiwMXvOdTzVV0gHZP+5G7fnXqqY+/32AEXKh7nxp?=
 =?us-ascii?Q?wz3aU7IJH0+Op8mM6e1xrFW3oAF1+DaXYA83j396H6BigIMlT9aBJWCwupcT?=
 =?us-ascii?Q?qLNWyGUG2vjMSwAIg1j+IyllapwavgjBCWiqRAQoeXMhFuqfOvxZg+8KgVoD?=
 =?us-ascii?Q?s2VXKrZvr0xDMyNel5UnEDFKKXYHBLne8HpZqvP6rRxFwcgIAYnvdNXhqhC4?=
 =?us-ascii?Q?VMtV3XX9rK08XAHEdMJgCLNCP7GOahbZ2upXVsvOMx8wrmFMs8nrqxhIaYBf?=
 =?us-ascii?Q?nTDn0CafnIv6HWmjeX9lerMTwcsjD0lqxwNy5FJB5/Ndml/WVhWu6H6VyoDM?=
 =?us-ascii?Q?4wfISBPISv3UDfit6sHJfexy9T/PSyQN3cdkSLHeyeXCufzr7TZclCmPOlxh?=
 =?us-ascii?Q?bT29VtHIAUMk5vaJifveFNfEFdFCVKSmVlydSSPpyDa+uL7B3hCiZ2dxokVh?=
 =?us-ascii?Q?T+ApUkq0gYDDo1vejeTTMTlOToTDKh6l0UtArG2957oG1RuvO+wxsf7av+eg?=
 =?us-ascii?Q?FXVn9Xg3kLsO88fmkUheqjBHYMt/Vk+odQTJvXWp2X4/KUOzNqIo3dbxMy1r?=
 =?us-ascii?Q?MmSrVsV1W3PJGBik6VeVyCqorAXNeWeCPYZBTGKgaYQLt6xV8bEyRSxUteJv?=
 =?us-ascii?Q?VUOKyetVRfH9nSmc454y0+2iJNHX8bVbHmJLR+4fp9vwU17Zwrfnlpk4ZsY5?=
 =?us-ascii?Q?toIS0NGu5Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	nuMw9/bETXPlH13efh+k0aSW44cGnLxK1uEmh68JI8QvCJTQ84K5ltBmDB5T983gzKTddFEoBTDD8eLT9aG4QUA8/xdO4BrylFZk0BKqHLWxdSd54ZvWU2tzyvnmoSs6czbH+K8jVwRWACL7Vca0J5W/9RLb5QyvxntuzFUICREQf8hnixTategwOYQ5/yOJ20s1OPoAO1dkI2vBo2R5RFZB1vRoCT6ApdlyQYQ278gdwZBcg7rL+L2aZHRKRjDqXuxrsbTzTaNMA8UslLsh6IaqIVy4PVnRau4y1tm/znO2Xm+jj6cF5p61+EcenMqmC+SEHcMuCRMf7mAO1McaqQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bANdlXgoQ1Zj1sRyFoBI2yLULXwyM1sQk/bLoP9ibaA6gZG0QN6rmDA3icBu528Vp3QGGYdXfJytqzHHgR8Q81aWkKhhTUh+E6wISHg1z3Z5X99Og0baVegMOlDuHpY0GTSW/gkdxkhVjaosOYkeS0vGyPm5E4MChmU3at3veI5F0oa63du9mi1+R6+QU1ny2ZcciowdpoHBZ+dRqnLmE0LkTKhfXY3i0PZWth8jwNXWinjB3rng9wk3QkP7LCEHgtZVDhBpe/K9B/QlTgCaDq3LGPPtSEh61lvor8Q3MOPu8PbZ+bfUrhlLFcypdeEl9dKHxTOZojKfiHMEJvkNR2ZK4sCrl4wMTt8FHYNl4x4hc0ZJWWaGlCBodWsAwNoiEjuX8qBXkw2xbUlAPP2itXiVbv4cWVevIiFas1ZgWxk5sYTtXj4Q4oIm770EL7M3qM+lz1gKTPjn4YKbAxhiBj8sbvbrDOSn1AkDNgrS16H9mN/+dZxgZh3fbwnifq55VEyRP9gJDq8e1aSu2SxU8WJGqJcYspuW/MCTQdUvonb8r4QWekJZMj19fGng+0T5iI2xQ5VHKepLZAgfNVpFQWCH4etziFCH1bUQ/CVfHRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8539d4-93c6-465a-c1c9-08df08162bcc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:42.8883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SQ/INCTddttnEJyAg4um6A9XFDIftbJB9xgHsHkPYfBSVwrQycHLzO8iZwkZ3i6nhuuu8DfyRWTLwLiUbqAXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX5f0gaya682UG
 eT8vhPM0Kfu/cqw7Yk08LBIFoo14dhDkDp2jVAnlmkralAdTK1V/phkJjcZ+S8z6NiT/3najnES
 wAG8L+gObgN34jfm8OtYRgQeaUIeCsBoHf60rIrPywQEeImuCzkx
X-Proofpoint-GUID: ogzVaZ6qsIfxrz7GTNlXADHbaxo9JGZx
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a96acdb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=Lb5UtHSxAhypNmDEWQsA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: ogzVaZ6qsIfxrz7GTNlXADHbaxo9JGZx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXw/XEZJUFsfE3
 1ikwwDXDgTGm0eQmXyd6kEqCBoFii77qMtj0Ag9SmXNY8cRJvcdudzesx5CDdtx9Rg1LalM2BAJ
 VLa89CH8AhvcFP4w5ttoUdqMYHCmk11M2KeLmi5/AzWon/prKkRtU+JWWNKjuIztbfUe9/W6GsX
 k3m9B/9BQ7RBos7Qwo2WaFcEav3oRcZnrjI74GunVlviEYLv6+SJfBs54c4YD/1OrmKyJ1nMLLl
 V8x/4wJx0YaPT75709BYTRoV7PmophjN4OGTx+rXkZCO2QIn1umuKaCAD4uP2EpCOGePQvKel0Z
 Ol1/RHDnE7vyfkCb/cGLdPC4t4P8X4kptYiKA0nX9t+v7cw4TQb4HKqZZeC/dLramd7XNuzwmQZ
 L68vj3QTNcZKxaxW98qUXixj333WrSArtgQQLI2dcjcKvl+td0zeFOXm84Sz3bp8+/Sw00h4u7X
 KS0UvLLLpwW37onbhPQ==

From: John Garry <john.garry@linux.dev>

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

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  33 +++++
 lib/multipath.c           | 253 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 285 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ca6e02505be43..9bbab0aa8961a 100644
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
index 1cf20b0f62d07..26714116023a3 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -7,8 +7,245 @@
 #include <linux/multipath.h>
 #include <linux/wait_bit.h>
 
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
+	WRITE_ONCE(*iopolicy, policy);
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
@@ -76,6 +313,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
 }
@@ -99,7 +337,7 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	struct gendisk *disk;
 
 	if (!mpath_head->disk_groups || !mpath_head->parent ||
-	    mpath_head->disk)
+	     !mpath_head->iopolicy || mpath_head->disk)
 		return -EINVAL;
 
 	disk = blk_alloc_disk(lim, numa_node);
@@ -134,6 +372,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
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

