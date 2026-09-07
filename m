Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381D46A60E;
	Mon,  7 Sep 2026 10:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778382; cv=fail; b=omI7gnRo8XJ5L+On9qCSCb/jZ3OEhB+iK2x+eOCeYQ7A73VIS/Qkc48mrzU9zKC2yMKW2+J4R2S9QEXBzbd5yh31ZzdnNmpGzRfpPW7catFY3KhmJIXeQzPy4/TaySfZBs/z+ZE8FWpI7lYqSdKRwCH1tZtJpxMArJoyOnQspPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778382; c=relaxed/simple;
	bh=oH3j0HFYrkKLmTnusf8KVHEb8hWHPIfSLZRm9rltz8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nx759RD5R3qUcq9HfDNJpE39KifGwVZqAbVeXjAcYdGD9bn9npbOnnLJeNyghiuNqwHPqohDjXHIjiO6zU+M4QhqKrY7Rh9Su7wR+H+2sA5aEtKaoFOsLVne1WChtkzI3E7xwI3mzVGwsBGtNm7GrEtVIgRKwW2uYSGCxHb0S6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j9455ZGk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wN9uBfkn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j9455ZGk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wN9uBfkn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870l44j227842;
	Mon, 7 Sep 2026 10:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BpTbmunR74CPu09YxsEfFSDfkJsdmcDiiUmNzzu1yAg=; b=
	j9455ZGkTLS2q6O16hApeazjndRZ7cnEpfDnzuJHNzU8d6AxoCN6o+7eBqOTxdbl
	1xbXIosmHnkvzPP/FKz08yvc8avdNy9LqTniWgp/LuHCohHVbrzyAysgTf3klAMo
	YquihdG2mD7pAHRIainrS5wst6FYfh5JzJe6WQ4CGgpotH5nz/dZC/Dp5gcwT8Qt
	jHszROuXPHOIid9i0VgNeW7qvd1GB0wGz2+yYD9Qd08mxbObbn9WQmDeusUXubL8
	TyDoZeYpA7djEH5ijL4B2bp4N6Xp8XTTvHInCPhZjehfCvgaCM++WDxe3uanPhQu
	KD3qtHq6G0MX8/IgarFGGw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdessgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfQ019106;
	Mon, 7 Sep 2026 10:51:23 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-18
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pX6pVv0WWI8DPw87lKur9ZnDqOrMYHwWya25XCrqJ7945OqQybSF+W0zgI+8COh99ich06F4YmNOCdubuQMsVC0Crq4l6MJWKAQRLa3qw+nvI5C/C4kG+WaB0594rFG7eIWz4uVNoWTVmldmrIhxD1ErJK/nOaCZiOva7lh7SU4oUoisp0TPjGL8csIACrDhTapNWYw/UF/er8eo2REZSr6OXvwEK95yZ2BPaxNbPpfQdKPbztML4j+26NhX/k+govcUoLoICNM+BlDo1gASXgFOKBdtyrpdSdnNmpdDqIvusO7SBdFirDFhzXkzM2WQbJ5EE/xixo3P2Zcf5p10YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpTbmunR74CPu09YxsEfFSDfkJsdmcDiiUmNzzu1yAg=;
 b=q1ldITp/f6i69Sf5jJ+R7SUve0WwFzZwsugIl22/mxbUSYTM10yZbnrgAnDXY1cIiFfhfnNUOTOTUtNY2fOqnx7rx9MhMYiF4YLcoWBFFq2t8VpGayxOHKwyCHtCjBYGFrvdFiHz5ZKUWTdc/i6oMqVX3kH1A5h8MYJvllSf5IswUysly7E9qKBa/LrzEXpqf8WvIdkcxGoMyBd54VkrTNNPxv+1VeiTmdIfTnov8e1No9NVYoB1bq8VvptT+RV2sUGBMVKBVpowDX/S1yzMp1FFm2dzODpvNq2dUaieC8rkpFtuzh7CiMqAU0MetOAMmcB8ehxTstNQWwSK/r44oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpTbmunR74CPu09YxsEfFSDfkJsdmcDiiUmNzzu1yAg=;
 b=wN9uBfknT8SzlAEQxnjc9ELHYqOX19uGrl2kZWwSD6HV1G+v7wf6jYv9jJkHYjzqIvECOdDO2Io8gv0tozp7jx62O0txb9OU530HOq9gkzYKt/XqZfAYA5Qvo0QK+BGBQ1M3Ej3+pJRqtvF2gWTk5zIdiIt+t8OkQys7+I2zmek=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:19 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:19 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 22/27] scsi: sd: add multipath disk class
Date: Mon,  7 Sep 2026 10:50:16 +0000
Message-ID: <20260907105021.1763236-23-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0132.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::24) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 81837029-b704-4cf8-23cf-08df0ccdf308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EPYgmtoezN2Twy9arhjkW8AcujWvF0cZUygOmCa/2aOqQEAuMt4jQACcz59UOtZ+6GrMuxmuDODYJRbdAzAt/L7QUN9pf8/nDe+gPXg7R7IAtJnNE4M2t1qrjLdyC4s6MuandRLWdIVFc8U+6bAQFAPbChqIAK/l9Rh1/0kqI1ZmOWRaLjswaXYMyyLFx+FVlnt+0lyvYBhONUFU9QiUAouI68qXJVypshWXgCVRVQ4TzpZaqHOeFkw3WHL9oF7KQiWzn3VHz5Z0L6oqXDLvL24LsltSvrWfYzW36/+TcZVFl86gCiEPkIXpjp9QCLtLcs5Oqquhvtv+sA89Zj9WcRAAZVbLYXYb9prNEtODYo+x9jG3ZFMcZOF6uYy1EduY1xPkJv7rqAsElk2t1T9F2Gw62US/E1TIBlUj0jdsxVQx1UtKrjTXUqysR0eFsxmmG1TiTK2g1HZ+pXbSZa/nvnzOXv8Llgyh7+iTzbm9h3K9hTnmqSlEaOtiQX3vtXjVWloqD2PDtpbSwn9B5x8AGklMfa2L9CAtAWB0uTx+3vKNSghF67jZB27TBwdShwM0rp/VjOTbNl2egrPzc6Iiyk5yTN1Qf9vPHJEd5I/owWolPd5LdtQz3OkK0VoHBNDKJzgGtq8tgyAudEt/9+9e/d8tzRGoCr+faChNSuRajx8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tmmVNNV1H7jXVuqjQ4RKstX/jtqt1jfuD2kXnMQz57I/srpKBTo459ZETpX7?=
 =?us-ascii?Q?lK0vyz1XSBb9hwJZokqidbZ8RKZBOKtrO0Kr0ivLbrtaXsd4U8cZPfGpdmnR?=
 =?us-ascii?Q?Rlu98BWO7WUMFQlOfzffZFtZP28uARATvhNgz0gzOG/PPbXCXbb5TT3uRIq4?=
 =?us-ascii?Q?oQkeeXvx+p0VN58qLVZaFqxYEww//oUx0TknlVWTXpO1RpoaPAPV/dUSD1lL?=
 =?us-ascii?Q?Q1IAtxiLrJCf3btqO6fA4Pc82T+ineYfwwECjx0QirIJPONDSMigEMp+rN3R?=
 =?us-ascii?Q?UEkbL3XQ3hG/XecHs34nCNbE15oeMD2C77VSU2t6fwu7+g8yvmZrpdqrXNzB?=
 =?us-ascii?Q?K80Q+7RX7gv27Yz28qw4anw5jBeBVzVs5brM6dUY4SyTiq3CdBuSPlJaHhnA?=
 =?us-ascii?Q?5iSaqmVDjl3QnU2sN4qt6Mpo5fxCy0QXyyyxOB4XTGjWW3rF/jI24cPw34Tj?=
 =?us-ascii?Q?bpj4LWqiG6qdk2ZbOrO/3RVunjjV8ltpHLhEGxbFZ1FXG97Z9CgHYIiXiCum?=
 =?us-ascii?Q?TretmOF/VVvwbXIMV79nP19Ypvx8SCLhPbacP79lchADk8KS9+dfGKcgnZU+?=
 =?us-ascii?Q?jxwpJLYbajMadyPZKQBSwedoHe8Xcol3UjIZqDcyzS6VrXn3SnK3b3DgQHFH?=
 =?us-ascii?Q?LZgtDGLP2R0+FFGWmyJ5ivzd5z4h3QWhTX0cE6x71RpMsGmnMrg88r13mJsn?=
 =?us-ascii?Q?sSvVV86RHp2TJt79eG/48IGwuRs0XchixNUXbDK756Z3+vfoehgat/Stnrhj?=
 =?us-ascii?Q?rdJjBl8/nI6hnNY2rbooulmn9k2QRxWHKzVFQiGNaNctwTp2y8qhXOA1VkNH?=
 =?us-ascii?Q?DjVJQkingsNmNCiXr6M0LFInWff710YmD/cT1lBmfD7Hsn7Sf3S45XGC7jzA?=
 =?us-ascii?Q?2zJNFwpes9182uNh85ikR8ozpgwx0slkftldh+t/8N8csssS6yW5oXyTUopG?=
 =?us-ascii?Q?PpkbL/TAYFdaX7PVzATyVZ0xGv5CMEIXFkcjCY09GtniKZbIMbWk00VZjUR2?=
 =?us-ascii?Q?kZb/O6jbGDDjwMCT/p3O6XAJNGMn++8/ejKNh2f7fyVat06vj4KXJPDlbgvQ?=
 =?us-ascii?Q?7771x0m/67B6wSB3SvD7o8O49iL/WkqjZGBxewD7X4wdr7oNpmk/A8e4svfd?=
 =?us-ascii?Q?v1EvfyOzl3nYFxblznpGDszg8hJroqwCPTKZo/4iYWQ3PiAF+FnvJiSYA5Dd?=
 =?us-ascii?Q?uYWSrfZuBwjhYCmsJdkRwWuRsUQqt2Xo3gMl9KqOcArGKxTbNIk66mUNjYl9?=
 =?us-ascii?Q?7MFujnqWr8lZZKzQYSF8I9iKwdX38vh6Cf/56HLHdR7DC4iTO/M2tEB3KNIO?=
 =?us-ascii?Q?U1lx5i+dqsA2+UN0XQlm+6LqygnYzDg8JKnvnZhMF17GFXe+Tai02hV1ahM7?=
 =?us-ascii?Q?Fc3QuE7HZ9zPjsvODWgnaX9IUQ2+w0y+OTHGqVxZ2tpSClNCvUPtOCWjfYRQ?=
 =?us-ascii?Q?JAYRJUnEeoOvBUfo87pyvxrbLHUeLi+iJcjjDiwyIAL7qGPLrlSvxWCbTE5/?=
 =?us-ascii?Q?ThGXohP0Mvx5YacrVup18Y6kOZiihn4yNKVK7Fk1lXHtjUjMyGiQBgdl1ZY1?=
 =?us-ascii?Q?RNkYQyU0i3hk3xUYJxuOPmHeuiGTcnPdnDmLam3Cd4e9mSXl1aCrz39bDqSD?=
 =?us-ascii?Q?WA5P6Wi6mgreEENZLlYd7u/uAmjPlPZI76cYSWwHBTHSvPagMuq0AX3lSAYn?=
 =?us-ascii?Q?bJCyL/NAHcNIb8Zo/1hgt+J05qQFUnOgcsercS/mhp5YbO5rk9cYh+9AjfBm?=
 =?us-ascii?Q?S3cqFfLEQw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	keB/qBzxtD1YRHF6VCpXkBl88syxzUXC/zB4QOg71MLokcginFGsQiqgwTUmr9kKIsm+W2oB4/ORfj7iIY9eVojqL/OhLs+ivpmyOZ7cnUJuv5Ne05PLC7zUZUs16QMO6Fh2F4UplwVQPoAl2WfRzCkLVCYoUcfALz4Sougr9yJpk3uBc8p0A06feTpaEA9bG+7AcWRSUH5b3qpwV3ae7ROXp6/08yngFNLuBGQaW9bQ7dYMd/ZYe6W+kS//wUeYBsyrnbOZ5TvoLmD5tZmp+BrNLxLHV71kpQnMHgE/vlpBcfbw0EVg4OI1JqaHTnlThVnj54NAb5aXwsNZnBRbtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sAZ7YHi9uKDaBKPpYTybPZMsjAtcseWvGMtlB9MrXVfhtM34XUw/9fEHckoRo2m04Lk8qyMRPDSAvXB91KtTS3mWjrW4kptalMX0TKtsOyUExj+tPFKgyOmcNm1zFJBVTmrKTVttckY5GwGrdPaJfvhgPlrpwLMA/CEdHAYPICfptiL1Hy/H618exaFiqVIXkBeAKAvNxu057knbtiVX6x0jKIMF3tBCR/v8/9K6CiohrGailwXz6Z80t/cfwHesT+Q9vepX7C4KnwJvwn6/zoMxV6hWhvv4FVU+tXLlFpDLpimcT6M9qA2YRcqlescgLrFtMnB4bAbwraQk/qW0l2PFRqPPj7LlPcxxs7tSAa3Ilnqr4EuC3W9N/eKQK4sING+BXFmNc6Fyyppf36+bbd7A/DhvnuIHVf8iAsVCndXbSFFtSi+Pel4JOquC0bsBZsqoT/kQJR+thfLN/PuzlmHVxS+hQhZydRvtDGRcr0L+Ri4zBxjaA2ziWdL2/hOBwEKlEveX31uyq5DUEvdXkLXDHoktoHeZi2rdaLRfC7Z6Kxi1okI9lA0gYs86WQ6Dr/uCyD9eSpzma3oGLmw+NfKfq5wiLzpLfXR6b7TBDKI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81837029-b704-4cf8-23cf-08df0ccdf308
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:19.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUdcuLtfA/xDKWcRNaVnEew514hZFBtoypR3VDhnjrGaKH6YijCK6rU4OZr89nsq2goGsrJxynyJ5UE/SEdvgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: U3M6giGuQqn0cIG8ZdgW047rGbu6L71y
X-Proofpoint-ORIG-GUID: U3M6giGuQqn0cIG8ZdgW047rGbu6L71y
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9e972c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=ecQ7zCoEdOpy3JLqRw8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX2Kku+Y9cIQxL
 siGB+lVc/0jcYFTE1Lujc2GQ/oJdLAm7Iy/vJ9U2ItMhUeK+Jdpkep1tlBS13xvoHOkLorPQHxN
 SLT3ew/f1w+QUR4IcX9vgkLZvDTYP6e9jkAVhbBsl9TG7K5cBfUWRiEBHYPhhAhu1VqAh4/OXPY
 9fPScahk/uNmZgY6s4n8+RAJ/yJBeVMfKRDKo4uh1aGHoorUX8BpUcxohk1dZC7ffsGFr0cBl/f
 MUFmBz1sV/jlKglz9snthuNytOKKpw/iBXZ17rKGZye928gkBOJj7YyW3hAUkOw5Pbo8atQj2xB
 JwtE2uAWlSje/WkJtKc6E4QoLrIKPV9OYZbyc/NN/0xsd6RYIyRi3R/UbLKSHpji8+3HM8E4drN
 WXQi4Hkbdw0BrSAhs6kMAomehHxID7uztLGoouRLmY+l5GsOAUCiwGoTNgPm4V4SadqxQY38z+I
 Pm4Ceo7aWDi2Ik+xRvw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX12f7nov9XRhz
 GvGhYDTHjDO57f04A9IYbuP8iiOop+DEF8aRcEcvLaF4IsPIQRuUnn1hgqDlUFNWdbH68UHkZiC
 FnUPkdajHhpCYGUTFnwfzUB1wpKXAxoxpLzskYZfjg5uT4cLCF8N

From: John Garry <john.garry@linux.dev>

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e549..6847805215bd7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4468,11 +4502,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4483,6 +4521,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4508,6 +4548,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..22438173ea2f8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.7

