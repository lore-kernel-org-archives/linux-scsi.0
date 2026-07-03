Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93D83BADB1;
	Fri,  3 Jul 2026 10:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074698; cv=fail; b=tmchdNoss66BKvk0nQECBsL0yLEoBu1fmSFmbqNwFCp7FI76ACr8JvdrhvPiqPkaLhWmy0ivBdPSTxuW0CzRkeXmy8M3ym3XV0FmyZBKvaVkCHHgapzMKop8H9BsVm8w6MB7xiZGUv9ls47LoFOz+mTzHUfsatm0f+fH7wobN0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074698; c=relaxed/simple;
	bh=wWmAJabTeNo9o7Uf+U9jwn/yCEdX1tYeL0SXK0dm61k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ru8aD9NvyrXo81G22Zc9h5iXoia7YTGjCWG6qFo1WWrsQfifKC6/l7S+nE+wJ/keVFFbRsi12WS/Z34IVK3ZumhJVHn0r4ehLwft9xfYqBRlSPCnSQ7mnNMC+r+e7Jxzia18HRidAslrqlNHshR6HOnKGy39GBW7elnmDn5EzJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mBFqfMj3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r+169O9M; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mBFqfMj3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r+169O9M"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638u4IW3081231;
	Fri, 3 Jul 2026 10:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=su9VGZeRu0Ki9v2wAR2LUS9++ysQdzWWW4YXK0yNgXM=; b=
	mBFqfMj3q9+1Eo25GmkdlG7HUpyRbVU8knG6jV/uZRWYBHhyi5llFowv2hPYN3mV
	SS45wW1hlvhWh9z7nVqu4174AOtt3xuAllsM86YR7gACPAcf0butofhTacup25fz
	Ip40uvoY4Zo964qBfGQ2AwH45Gs3ubn86jq1u6iobIA2dvzfvEXUR0rHCZGun8xl
	r2opSQjUcjvXLk1ymdsTG63/oqoCWhND6uQl4UsVDvtmpH/HjaawTuBW1IVXQ8eG
	dH2kfKekYpXPG57r/HAxamZmZUWr8Dy9iqtmUBcGI4EjaJZW6ogy2UMYrO3soHro
	tdUKxWvQT08Ip3RJ31vepQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS700033784;
	Fri, 3 Jul 2026 10:31:02 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyqnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2a8FgnzbdYJ2n6x7M3K9i14YdQZudf2ng8LN97WiY53yg1vDN8CHAQ0flBfbsMdXNanKvBFOD8tyQj/HtJWFVPxxOWvESzxjmBHzPSetxJx0qxhPy33mI+T4Y5ngPMS2lkGNMHrnpT6agGSPvxA2GvdCxecZ/um+ZzKAuY3fq6ijsvfMANhSILI9E4OiwSs6ZnywZjIL0abJuhB4GQffHAw97FWxmUqUYFb9P+hrpPp5eNVxZO+qUpynPcob2e3j4bcR4SVJJIAB8qYWkkfZFksI59ATls4QZHLXXgHMvUFTvC1IWecFL3usz6OPKNY87GrPwcbTXufqrnqCTM0eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=su9VGZeRu0Ki9v2wAR2LUS9++ysQdzWWW4YXK0yNgXM=;
 b=aH6uzVlaxZbaiuPRTbxeMiKlfwklkUbpTu3n2inXOrx7pqsEMZe3CpxnG9PzD8HwIytAfrzJ2ATxTCYW7CE25wP56h04fH505HbqT3tZOfrnWVM3qSTItsegdeI8omg47smDOnK1BRKnJPAmUxI5XZJ1h8CURFIF2g5TdhFjReTFChjQlwZLBBpymIBCVizzqgsFqI0uHRJ4RtLLNGxPEKheQN4xiy/lQrWLqDc+JKZak2mo7mM/ftQxPlVypOEnLHoRzpDrgDi0XjtqMafQzP1GwhFOAYf7OlV2Wd/cSkn/znemoio98DsRJXUwriiaZTZLLFrpdjaytYmyfsWnUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=su9VGZeRu0Ki9v2wAR2LUS9++ysQdzWWW4YXK0yNgXM=;
 b=r+169O9MO2U0XeSJzevipCvTwgdr+wWzxkMdvcXRkfCfuVF4fYe1mGhEHv8wl2VNob5oXC4kWVCVkVzvMaelFtObvoVfQK92EjSrXGxDBlGO/5AIMbN+6xeHgSco9Cp5bSd5ZoJ2TFCRF75J15uHw0KT7Mz6kmZgGqoGthmoOPw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:30:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 06/13] libmultipath: Add delayed removal support
Date: Fri,  3 Jul 2026 10:29:11 +0000
Message-ID: <20260703102918.3723667-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:610:53::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: 39e28a9a-2c5a-4b8b-3dd0-08ded8ee2962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	CBuyhrn8MjUj79lDLW2usX1oIuVcbxkVE9YYb1qWT/77le0JGXk7SzgVhnSjBmzHqYG9TI+edhaQzKo3SuCaSEbYuDzDjuS5bwzphLeYNPRNPtXHzxBEUZHe2RhnAtyzwJckXHn0FDrJS2dbNowaWcsJqHKROrxup85x2nO5P1xZdWR4uRYLmPBntKUAX35Mk9/lQfO/kXkGyO3jC+mpEFxtbN4A0hOSPUDktAIS4FZOcpsG/ywiNg+cyJ0LBouj5Y6jMz8wcRQnGVjqZiiLI4IcDVQjzlQbGaQpZDsZfXjXCkjxlJ4U95geRDAubdWmv/ieNhsBQllD/ULizmW7fd5O7vMo0NUAvPIqJIAttkDJ+YHVP3QF9CoxcTN5o9qgDP3i79UmXWORcBgGHsj/wzuit2rkZDIjh22X4h8qVBIjM7yp/ZNYrAKDtHbLpgjDm6zAPLnh749r6AQnFhwF2sqdNYG9BddtHpdBDap72un8+tDMwhDfd9iBU7fPbEcSDhEXn/ZxJoYqf56jZyMSOTS5xoj3i7MF4W07lEuhIuY2P86HLHH3ruuBrSFqAZTzcYB5z4Exs0CMYBNvEFQBKQR6jwHiZLXxdrgTHytYRPjGqZw7U8zVHHSlA01gxwNq0wXlIh8bRZlRgoFFr4FSiCmDCOmkA9bBsS9eQW8TJac=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IOgv/8VcnB7zKqIg26YMggomFgS/hxNUql944kNCOCnTaCeUe1444frIPalh?=
 =?us-ascii?Q?YwWw1KIVyg0v4eqXjAEXc3TulAJSxWPRhK0Mwkzmgfs6NiMMt2lzHuVBCMX6?=
 =?us-ascii?Q?ZK/51qKVqETTIOLfRHEdZDU+3PFvrAxc2cWkp9p9AJXgeyFznGS9QDarKDGS?=
 =?us-ascii?Q?D0QuIxnehLW3XMsMO+PIgRKHgHC8HidLgFCeMMMcH5MgsYqRNUR+EV4SWMTv?=
 =?us-ascii?Q?DRp+5MPSrL/JreNk0PrT2Ip4c5hlW72eFbZ49zYY4GOx191/LC+3Hc+Tsc1U?=
 =?us-ascii?Q?I0CV7K3KTIQp/6RjFZpML93oQVkgw0RAk084wwpw0vkOkcCukizgZTbzqsy1?=
 =?us-ascii?Q?SMh42Rmw1Pwp7yZlnGTNs4D7taFAz3fOUTFIWw9x5a90xoLkWjQCHM6nL7qc?=
 =?us-ascii?Q?0BfztXN+J6fkCWboARPxnc9U+z7YHZNN42Uc2FgdhaI5NU/uTutWAKI3ic/o?=
 =?us-ascii?Q?gEVjcigekCADxsAQ/rv6lpPzs7/nPkF8ynbtyt6dOr+ci1OcUyRVpDfrsZrg?=
 =?us-ascii?Q?qYafbEDf/bGe3oTD3bdOY8SW3xBYX9DSQXBlZ3AH21RywPAMFfyx7ojLtxZD?=
 =?us-ascii?Q?p1EJdwHNyeLn1p0rvCI219fzw9mEvEBlc7Hwa+2DCUaVRmg3G+ekf+BcM+7M?=
 =?us-ascii?Q?4PXQiut3wQaEVfgZDC89oBSZOE/MlJnXsP4r29iYLOggBUpoqUOiDAV0K8Wt?=
 =?us-ascii?Q?ajT1mkAp554W9vUbkKfy/Tb+sK8yasqugC6Za1KaQWBOb++0T0icJ5Ne1T6i?=
 =?us-ascii?Q?BhTzzvnRPCabBUmajjVcoFknr/b8yPhb22eM4T3x7XJlvblHb7znSEqvb6Mq?=
 =?us-ascii?Q?1NJDPxGUFjAYlHHonNODaO3fpjGpfVChRQaCCFhrJqSdswcD9jnf0jzrkTvo?=
 =?us-ascii?Q?e4eQlEVWZ0GUyYoMJ6N+2Hhq5wK7qK2btucGvCGKq24UvcOMiTOxKA9Km3rJ?=
 =?us-ascii?Q?3Tvu77ZzeuVFL4Izd/n5qInn934SgDtfryi0F9JwB1fRYp953csbx4DMQ3hf?=
 =?us-ascii?Q?YgwTX1Ikn3GL55nkvBRBOvmRR37tatAQ6/yMihllZ6kXxdBOxstbmMtGSm0j?=
 =?us-ascii?Q?QBpMNxEdZhQAt+9bMxj4mYH8yh1ohCieirDGEies/AVf7bUG7JYsFgiELupL?=
 =?us-ascii?Q?qUAJgsYSG4VG9wVvtuXzMP14BhgPfPi/WSrGlGa47y3x2geHclXgITHfNJ8U?=
 =?us-ascii?Q?YDltQOA35MomAZURsoBbyn3A2bw+4cFhnDLCbAsrK3Uow4Nmzai2xm126R1m?=
 =?us-ascii?Q?IJhQDftKRaSoQNbYW7QLbDY3fghrkYmSnPzu0kGFh1A7sQ9crbuyjw0umQJ+?=
 =?us-ascii?Q?7zujR4eYq4Gaf2s5UJwUWWAA1zchI3RUCdyOkrblNQnM1ArJ5fDIJcRx3MLU?=
 =?us-ascii?Q?Is9sI3k5xOnW/BBj15Vv5Acxk0q5cj0vTBYzG2C4Ld+Neh9qYYcOWnSnHl9/?=
 =?us-ascii?Q?WSU/LfCe3OzyDisfQNXZJM6BXm7Fq5M43I9cMxHTMZ/A5ORQ+3OHeLF1O5tL?=
 =?us-ascii?Q?z1ix1Ifesg/tnzpJy2mk1sZZDtVjHFSiN8k56vKojvfSbJHNqZON5d2NcuiD?=
 =?us-ascii?Q?TA8LW5uJzoec4v0lWnZhYe11YByG2/IZGCXDlLXYGzrX02o4oYrt0R32QVoV?=
 =?us-ascii?Q?bJH6LMHv2IdH3Cc95G0/gw1UYUu4lXrm2Net69zXrOKhML9AGbJjuBGAM11X?=
 =?us-ascii?Q?ZYAGacxTZ7sQXl99ckVv8LmQtsqDZXmnvepWvOPG5pwxAGsE2XhyTnH/9gTI?=
 =?us-ascii?Q?UI4jIlW0v2nf/hodd6TbhQM7OrZtToY=3D?=
X-Exchange-RoutingPolicyChecked:
	PXAHsy6yTkDMZalZnrGOeVLKCF1RJ2YvTaAKKLC1WiOBcECrw3k68bhLsuAp0q7AMnyjq8Af81rwXCjMWim0SdXWH0bFOctgN+v3XmVEDNSffiPtqkDyowfIXJKyIOm1L7Cd8IPSh4GernrTFUQ4ZGdtVhlqY/2IYjf6Ut9G9RHVL4+I0U6qQXX1fQmRlb/XTlo+2iwEhndU6QBf+PbEMiXDf+VpOB9giM25c/Ou2moyh2MwQ8d7/tMBDkGT5KFqyLkh0LPA6uC0in5wCBzsWT2Q1wIGlhRom4nosW4s8SRh6D606F13hH0i/8uD6yN+lf5wfN6/PhbHcY1P0BBbNw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zIE8wzCQ45lUUQ9uwASHx8oyWpNJD57cSXTIgG8FHohLZMw7DdlC2uAFJVLAkE3OwMK8dzgALvWRMD5wLXOjJVxdGaVw8IJR+BHQ4XSkphJCkaRZkaqz05V2bsmF8SyRoRy2UX3Ub78jN2yNZ97k8LThdh/63J++8AbAnAuItfcgiVNdvPz8cA1bZ9onGQs1vvu6x4mYPgcxrQSXzHLSVPyoQlg9gguJeSBWW05zkqUm5/1yBWcUqP3ZAeD/2u0LCEGIinxTw676BOWBMHT1RNiMzHXdBqJ92/Es+7xhrUqZGrCnqil7oJnxd0k5HnKr0Douhj0j7LyTslsDsw7vkjg3z3RA1b7Hj5zS3vKelAclv47iLuYq3rHuS2HjTGW/NZO4ZS0LzisNeyD8ClDvLH0nVWll77vmg+4d/Txkk7UV3sLvoCRk7fMOHekeukzkPyWyj7psCPGLJMO1ca6TJR4q4/HuRb0SMSNzARGK+BDjFpCxlH3SpdpekCYm7UPZhmNoiVrKQ4pxsFknj/gyIoeQpkxe6Ol6gfEbYJOJ2N09OEu8R7xsRWf7mgMAxJhj1PQ4eRtCJm6prWrFtUJmV9GRX9ZNLANEx5FICm8z8vg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e28a9a-2c5a-4b8b-3dd0-08ded8ee2962
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:54.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8d+W4YtomtOmFmIdal+NPRok+YziamJgh65Yfvy/N9UP+U/QuG0KUeRH9oCJquwlwSU1dY+FsxuFk28oeN4QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: RkiWyG42T_uD5cMea3rC6VuiLRZzgFWJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX//O24fdr1oCA
 BY4ampq5RtvuhKgIL1n2LOt0COaQ37DOB96M/CUgleE1IrSUm2W6JToWGMWPl5lihLm8Jj2I7sL
 woY/j24wJOPH5TyJuN+8p1RDJ64JGtAwOKJOoImqrSIJZVG4zIB1E2jMSeISUzszyRp29s1UJx/
 8YTB1H7CoLpi39mzHxChTzgerBjLoBd3B1JJu1sYEOPchRBX1GvAmkkiYB7Nf5p9sIoxISEnjEH
 IlRoL8H/rDmcZEb0HZYdUZ1eW+83hRk7Yn47LAyxcvRhFUXjFnd82id0T2B/BkyEqbscQV/Je++
 Iq/fnHOIEEhpEtqlZ4Qi3922N+a4T2ELPRPHFnLQPt3Yl7X82mcHlAhM4OuDYbx0hZBO39Rgk7M
 qsTmGabCSZeuhtjoMPJd62/7C3S1TTdKirtdmwKEPy4deJRE5eD19YC6dX7KkbfzaXFpEHyxUQZ
 XcC7Nl+Ejzf/S9oThXg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX1JoJxzq+2FzC
 FaTaRUPPYgWfFkYG5RKS7YaWCtQJoBfGED+63xjxL8bv3ATheh2gbpsW+JpzeEu3wkisg7v+SZK
 UJwjVSAhtZBxFPD8uZnP1EN2TCE17zAstzIbS50o8QaPDQvJSRc8
X-Proofpoint-GUID: RkiWyG42T_uD5cMea3rC6VuiLRZzgFWJ
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a478f68 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=BfxcaXdt0Lgmg1IeN-8A:9

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.g.garry@oracle.com>=
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 91 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index ec4325b77cf8c..8e4b3fc197637 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -34,6 +34,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	struct bio *(*clone_bio)(struct bio *);
@@ -41,6 +42,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -58,6 +60,10 @@ struct mpath_head {
 	atomic_long_t		requeue_no_usable_path_cnt;
 	atomic_long_t		fail_no_avail_path_cnt;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -116,6 +122,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -131,6 +142,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index 007aa34796569..78f88b0664c78 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -61,6 +61,8 @@ void mpath_add_device(struct mpath_device *mpath_device,
 	mutex_lock(&mpath_head->lock);
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
 
@@ -367,7 +369,17 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
+
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -518,6 +530,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+		try_module_get(mpath_head->drv_module)) {
+
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
+				mpath_head->delayed_removal_secs * HZ);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -562,6 +607,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -605,6 +653,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	ssize_t ret;
+	int sec;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.7

