Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7FA38AC78;
	Tue, 28 Apr 2026 11:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374927; cv=fail; b=n9nh/HLaSp6P8tjC3bRO9WurwhVQWSeckeUS6khiuUGTqsHECCOpzQfTxfYq53JTCTa1cuK/2bqARpOJ6cF6wkPvOszKTkIT4ELhEiy7RDHif94H4Uzpecz1rtA1dsxWXvwqTYqFRJoaHZvxH363gdN6D/y54jrCifz6ap3nNMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374927; c=relaxed/simple;
	bh=j5Uc2nJXxSe0z8XqGUMAEt6NYmLIIyNIUVo3jvtI00U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Buqydj1rzEjtsrkbzTAxP4pPdYGFnz4fyFP8HONKPVtjHrc5DqJLFw9aN/tovD/EPqlkQPOzG9lRksesl8E7B0nlj/aM6ThbZVNzzOwRJThXJK+F175DJKFxZcezW6qTlNe/ZmdVIflCkYn71OKKUCu8vw8/jyVGq3ehCe7nQ/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Aie1vOJA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s0MD34Fa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aie1vOJA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s0MD34Fa"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8JM163055256;
	Tue, 28 Apr 2026 11:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L+iyl0WJy9EUMWwwy0e7BSoYfLQqN2bot0vnA9Xrn64=; b=
	Aie1vOJAnqX5D+xoXkeIkMUG/xgf1eCkeW9hZDxRx4dG0xLCEbU39bNnshk7iQ5j
	VBEHphFaxGK0WqgLOxQJ0icKyC5QJ2UYkTEHAdvFso6d1LeSlGsJb0DFk8h//APo
	fch9WXBKrU8ATpQ/dqjC6IOlvNVu3DwC+DjNGhTltNLmfNp8ztg958hQ8s7FLjLw
	2jinAQv1DVYXDkpNOu+hVjC4XgugKGpOFPqTXsHnL3jTyJDY+kXKcdF8rW1h4B7l
	ycgkf/fpju4QpIycWhpOMPs0OYajKUVXdq+NP3WylEGBe+lfZKBx6Aia/yGg2WH9
	bb4LCRNr7Q+UXdiD7DzUSg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5ycc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCm1Y038743;
	Tue, 28 Apr 2026 11:15:06 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccmrd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3c4DEH6YZ4hYECAEYTJ2muX+tcVKtweFIInwBL+Mk4wvZHZoOktu7tKSWx8969zPFlBJNEZfoyAdGuUdC3zac37Cn7v3FQf2EtEib4lOSsyqjCoBdJ624rTKhvyydIwiPkEiz/TXUVVNBM9iRZ7bM9s0kvqtmZWPdse6P5QRUyjGKzN42fkAWGmRfhuIkvJnGzKYAf5CFew2188Rb0giqALl1hXZoYEjpfhmCyw5rGD4zReVzooBaQKHfsKc5Myft7k9NKM0iUblFl6fKeLNDTkAvGVycaVJMcus7jICnR+5Ym1FhBh35sC60cWvbcAHUtktCmyBc0w4V4rdR3SNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+iyl0WJy9EUMWwwy0e7BSoYfLQqN2bot0vnA9Xrn64=;
 b=m7/t6c9djmvryhtkNMGbRKWf2Rq1wfHom6yRk/DMGZtxsb7vhL/gxxs/ag/nUye+pjqcAmE6VvwWw6lOdv66waaf8DZG3eRIPFnLMiGzMjeOwUUN0eOKQLoOm0/CIvCr2lZUidzgm3RUs6Q28MqaIp/XXircc+e7UoK90sqhSUyBWn0vdg5A2pwSHS08uq3NnqiURJfJASZ5pkpLT7l6XUgTWqCqBgQ2LQRV5yMHMKB16yDJFikC+gWgPNFVATs8wO0bniBgEQmTL/v6XGKUGD8QRbKuHxk/0FkcP7TH7WicrR1gNvjo0isKLUl8wF5L9cditd2fTwdhDJBTeO9f6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+iyl0WJy9EUMWwwy0e7BSoYfLQqN2bot0vnA9Xrn64=;
 b=s0MD34FabYvPGgYZdauvPfBoJreL5n0H1UvF32AF/0QYMVoXKIz2sgr1xPfJRy+qm5VxnLmfdOU5rRKPUPDraOkygMb/Zib6XuNJBb7C1uOf8tXBhYuK6qapdka8Gs3qdED81dwYlUcOZwFvVaPSR9hVJKqSxnVKB8HKofZpKmc=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:03 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 01/18] scsi-multipath: introduce basic SCSI device support
Date: Tue, 28 Apr 2026 11:14:30 +0000
Message-ID: <20260428111447.1779062-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0401.namprd03.prod.outlook.com
 (2603:10b6:610:11b::35) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: b8486b0e-306e-4a3f-f659-08dea5176521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2uxnb6nHnjdkzOKNKbcTGnGHsvFZDLxlhkextgt+xGRuqPPhUw8ItTLy6sC3cXEi17bS2bWqShUSbKqQy6g8cINRi4xzmbUtNTIuvTUyaZ223hjAveObeMeMx+hTP+WoliRg28MNIj0JgzEhxFLjWsnxbfC0Pxc1BLuYzSHV8PHPXEVvUY687aFdbAV0S+2XcVPw6i9+BpmGlFNIcKBCxhyaqoGEhMEEdiNqdbI2iV36bXYTytaMR3pNAr2oeVkfbq+pLiPMjbLit3A7KGsJPNyOlzEQboEFOlwH25DZ60mp+0SEIQopWQ2h+tJFd0szcHx9yIxcDrYSgJvipstD6HMtisgo2wWVr+9vTzFZaLhSPirVW1xBxKMplAO2QyEZf1F+Ti7J16I7pIsZ+nKL5iF42MwqVCgN6z6KtRhEqguQZTapxPb5xdlXndmLNOtE16nhTECcIoe16yVxjx9KvDaQquESVAneVw3Z13P02iPli2naLd89vQZ02lCI0DiduI73XjUUWEpU4aCVnYbZbOY+n67fC9uoehDJfEyqBXn3PT5Owt2LQZ9c83hHPQgw6Q6T3X69CwrFpmeJqTmoir5HeTuFwYJJXTwMnbuuY4EmXq1wQ73XZvSc9UvNkGjpT3VXIdGMn/uv41/U4XDW0qWxB432Yc+4hC/c4ttAjRf3b4emtSnVeSPZaUAC6t2iYcVP0G6WBqibIol3TxOPZDT69yWz5VezZyZIgDdPnk4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DoqVEbe36ogs0j0RTpI4ernQ6TqCabe/Nkrd0QwesWWDGLhKIrIxULBbvPAg?=
 =?us-ascii?Q?XZFtDVFdNSfUTLPxTxNTUT5ACvYY/P462vF6blK6BbjIUtaUiXwncDEjpCjD?=
 =?us-ascii?Q?psFMcB3tJQVYN0eyWbjTna39Sord6b3dWBXvCdhbr9e5cCM4UKw68zh8StTd?=
 =?us-ascii?Q?bbVRX40oqqQ8ZI73RfbnENmM9saL2Pd/ODtJnTYAxmhZ9NXx1Utrh4NKbsoU?=
 =?us-ascii?Q?v7ufQHHwfc7QlM4wK9aAOJwaExbk0mXwqQsg/2Hr35dIpSVIqQr7fh/zblIW?=
 =?us-ascii?Q?w3Fo200Y4dEFz+SPpsp7K/nNxn+hjuXLvNDjhl1FjhXda2a4f0iRwateigy8?=
 =?us-ascii?Q?K3Bqd189W8xrOWknOgstuUnSFBtCb1Eabw8HrxmMfP5mxDAeRPux3zGigpW3?=
 =?us-ascii?Q?Gy7qdBRU12neiSSokhrYUdfYRtmhUHb3J1+i1rjkd9RZyec87gYnIn97J3AZ?=
 =?us-ascii?Q?SCoX9hwjTmPPeRxephCfcnK8EK+eH7oBDepjKJfZydC+bdNoQ+KtWxMeLx+B?=
 =?us-ascii?Q?A2CC2vBp61fVNOa6Fsgee5cS50SkoqywzyjEN1umAW0fh0FtTgHw9NRTW5ke?=
 =?us-ascii?Q?CMG1ZAOyxf8tUNCj2A4aJ5osRS28IlCHs6JKjHWHjXsOjpmWhMGGOOMiw8Rv?=
 =?us-ascii?Q?+S8sXjq+fS6fY3rJTJkT0SPnynrElo8HuhJf+/NsdAblMEGH4H8Nodhak3+i?=
 =?us-ascii?Q?xVQ9skePPRizP+ImeBj2+18pv0g7q9Kp2eMjP/c57TJN7fN4AnovJcHOrTfL?=
 =?us-ascii?Q?8wSxCfvNyl3/97ox0x9v9VF7+mb/TGX8ARU6SktEwlTCNpzjYnexGXsBZQN4?=
 =?us-ascii?Q?MHlbaWWtowmjmQF8RlWYEWl2BgW/UlewNOHsZrhV4NLm5BV3TBmO2NFwWBcd?=
 =?us-ascii?Q?WwNg3JZ5FV7vvPyyHCB3UbPOhXyQ8U2ob5gmsDnTWqCr+6U+2OegaRpnG2S5?=
 =?us-ascii?Q?gWx2jhWmLPpBUDbe02YL/fR/kLTBLg9E3vAXvzK0Rre7vugA3UhYICw4CTPa?=
 =?us-ascii?Q?mWpCJ4D68ZSuPUAhI7ZH1nqMkQJ4PZnj3m7Sb+eqvAlU4U9DbIniNxAorcOX?=
 =?us-ascii?Q?cyelqq2jqGboFjCPm/oZkEJoN+QWkNhIrVSZuY+MEGfD7DLXOOp/Wykf2GuZ?=
 =?us-ascii?Q?9baEUvAW8E0j8ANeY3cL3fstgp1UuZ87ur5EOU5ks4qnjtlK13TNy4GOLInE?=
 =?us-ascii?Q?Qo/SO61VwuV77ug81/DCZhkIgwU0ZqF5HI795px7fgJBJ39mhedvLBZX5n5E?=
 =?us-ascii?Q?DsJjWmihTNWmEQEoXVfhh3WBNMn35zubuyucFxHt78T8c1hTcpmOBUX9Estf?=
 =?us-ascii?Q?0E1X+5KFRF8Og5xtRfB5QcmTOq6e0wMeFWjrHkwWDrE/2FLNijxbJEQOMoeY?=
 =?us-ascii?Q?2gVIaG0wmgLCmCvSMmHePc4pi4JHoXI/UpBTxuYOgppt+XLleB3JgFkGgqM5?=
 =?us-ascii?Q?9TtevFD4xqM0tluCSQKdQcEwzoPyex6P6AkrreurJ6mHvAV/a1b6MulhVxHd?=
 =?us-ascii?Q?+uHZasC5R8FYsHJbbfvLQjZoU96HevNIZbt+8yZSQ3xSVWa8IDrRjwY4EHVk?=
 =?us-ascii?Q?o9R6ANy83C5UIshjnOwp+m6ge4mAtaeGXkRRUNeTsg389KdvZwuiOFxMkFf5?=
 =?us-ascii?Q?UKkfnw3QfEyihQDkKmaS85z9B80JJ1DrISlaYCfZZ90Yj9n4PKWObyXwCCEA?=
 =?us-ascii?Q?2HQKeLXANx+VGqrskW/SvqjSZqsZfVGGp4X76s9dMzvTfos2m1bpw9kba49J?=
 =?us-ascii?Q?nnRiaz2G7sJm/ZXmJJg1l2aaI0R+ML8=3D?=
X-Exchange-RoutingPolicyChecked:
	pUu38JtDdnqCY2nv3E9xa53Wfm6fvJmNu86SABsIGMOOCgQ9ubH0KAZZ5hqikY8Z+ndHipKbf4aM5uF7NCMsznuraE13Hw6hLj/Z7uaEnkCQW6ykO1kkHgeO0rsUFxjSEIub3daKM4SXOxmKFGwPpnqPsk4IbLZ3RvVnBvlN+MiPQxutef/SDbXcFH2AxB5ZVexzzV2EGKgRAG1uI0mtXAEfC/mKrbrL+m+WpaY6+WaL1yEnYzIZqaiA7tVN7WzWwymjBozmlLWEbHrbTWt0h4JIN8qT5GVOEcI6xbpE8HNehTJ3qZLz5njJkpUW0Bv9PYWH5W/oG4G42SZqBLy0GQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jtd1CjuXaqlgEZ76/Cr2gDTlejTIRMCfjD9/Ct03PuUKJFAVW+KGykfsW3YX7GUI6o8U4MVX+jd4cBElA0IiwuS7PMo6W9SFtSZwatKzAlMKWkiOtdfQMb9lNJA+97DtN9fFo+Ow1SXl2qiGrxpcgqyPiS7kI8AC2LQ6D1SZeGoVXzEe2Bun/O+RFRUE2ctuICPHcCyME1HHdTdw2GWl8wurzewtsM9P8VenW5/paPWhSTShzKC5XngJH6Vpmf75VHAK4igSCWVJJn4fd6UenP2BfIsh4ThpnIb6nzM/1bridntToCDzMRz8cZ1XQJ6czVYFz/QIL5g8uHwrkKAl7zhur+x5wKfXv+ACHh4XR9qK+GtDtvs3ZGBuEZ5cSYkqlJD51IMhwGJbGrS8zFH3ZjUORqftiHXRMg4JFjkPj18+6s8ABnhTow2r9LQUmaOA0p/uUCRq+js8/y1sES5a0bQz+OwR+ElIB1Z0/FuDmREskc/O7wyjMOrP1VNfkD6/GrsI6EBP86waIjde3Gbwt0VM31byif10GSfUXM6rqfDYlwdCVg3t3B2NQycGOgEIt5/pXnFnxVimsPysSjZCAdb1+abt0tJvLyKCHivfXyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8486b0e-306e-4a3f-f659-08dea5176521
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:03.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkgIU7ncHw1v8GC8qqMM1OS24/mS8wA1yjs8XxIqDH9a9fS6Sm3oaV9Wwyb+Kjhy20pwUbZVQNEpMaQDMhwU0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f096bb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=pCOl5fTshOrEa-n2-VQA:9 cc=ntf
 awl=host:13844
X-Proofpoint-GUID: _v7pUdtbrDD5zpzZK58Rz2AH50q4H8dR
X-Proofpoint-ORIG-GUID: _v7pUdtbrDD5zpzZK58Rz2AH50q4H8dR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXzOwiAIurFmFZ
 TuNjo2GWUEWrvyo3dhk8aU81wph2TF8uMrnh6cFUewmojbc3tX4dy++CldgkIxsAHlk+UQsu+JR
 43LrxvBaEZSkhYu2VyQDpS1Myl1NGx5vigcz8zZ35e/r7R0y7tP4eGSVmwg3lzWktB0ugB39nXR
 C+vzH0MlQvP/1gSQpHrXmKT3s3vK5LDBMF2hg3WL0k1GZJkMWdlUE73H7dWALurjv/D/ynt8NaO
 YvVdhC5stPbjMmRW/4fFbmQaVzCipNXpdjIYUJHA4JHvXvy/uUat1Rr/4uDZzgLKyAmJgXVaZ+o
 QnWykFgziUmmVsXmYA9vlXPw3ML5I/8GdKNm4M8NLsFLvkEQdwYvqvFa4oCNBVWE+0hLGzh3k5n
 K8cETJYWFOIuWqqpIhSOvq0/COnXwQ6Hm2NXh7sRU3ZEpLIY9HmgQceTOO+q4pcpIoS1XF01Iqr
 efJ5ej0zOntGAc0632SBD6Il/adU/Co7VEE/VN78=

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like nvme_ns structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and ALUA supported and unique ID available in
  VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 146 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 19d0884479a24..2375971db2052 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 16de3e41f94c4..64b7a82828b81 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..70aa1dbeacebf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..ff37cfdf2f9d1
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,146 @@
+// SPDX-License-Indentifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	if (!val)
+		return -EINVAL;
+	if (!strncmp(val, "on", 2))
+		scsi_multipath = SCSI_MULTIPATH_ON;
+	else if (!strncmp(val, "always", 6))
+		scsi_multipath = SCSI_MULTIPATH_ALWAYS;
+	else if (!strncmp(val, "off", 3))
+		scsi_multipath = SCSI_MULTIPATH_OFF;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!scsi_device_tpgs(sdev) && (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0) {
+		ret = 0;
+		goto out_uninit;
+	}
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return ret;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2cfcf1f5d6a46..842dad8cc6a2f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1123,6 +1124,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6b8c5c05f2944..47534d9f2cf9b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -455,6 +456,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d32f5841f4f85..52974dba0a724 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -279,6 +279,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

