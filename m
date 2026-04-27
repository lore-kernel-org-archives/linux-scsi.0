Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC08521A447;
	Mon, 27 Apr 2026 01:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253762; cv=fail; b=hE8iCSiHuFlfHrkEG9ReAS0wqjubzOM3+zTSPvR/XhkqLlFrWfDaVRR+GfoAC+q/PxLUepn/XocVMRJlGF6R2vn2ixv9L+iBQ0XnVU1ZyO6vHT+iDfKMP3OS/mZL2JU3jufJTPxF98UABuHwG325oEV+vaXXhU4tBJg/t1yvDbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253762; c=relaxed/simple;
	bh=hxP9AlJ7jq7hghk+0v5fcTr6qm2Hz8hCeKpcT2Oz65Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kZHPzP3gq4dI6Fq4jg8gy+zkXCTg4F5N1Nsig/fgBEFl0o6eQBsNqhAb7lpWpKHWSvnH5ywJS5JotVdi/xD9OvF2Vka4ZY2/2OrtdXX8MBT1/Mr665nSfh1dMOfCGyupIblWRZBBsbfKp8Nu7vu2nlQ+FuQIb5InGJz8gGqF+rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ou+xGfCd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z86p57Ph; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ou+xGfCd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z86p57Ph"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R0ObZ9533797;
	Mon, 27 Apr 2026 01:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vUijGD7/6zDQyMy6IJ
	CmWjJz1y4EpSWYqFi19OKZVX8=; b=Ou+xGfCdydIVGb3GF8IIK9kmRg6K2Er4rn
	/0lLurUlP2tJrIcB2XDof5BolY8mURjTMKJdggTQS3xSueM8xo/Da6PkvzkmI9nY
	ynvWcPUH83ZZkbnc9WNDNkALxkXb8LSi4c19o9E1X1Z3cqPaz7P4+BvxZpmELT2i
	baDI9UzKq+5HUGEbaScSnu8TBFVon2bIe0etizt/lIGw8jZ8fy4TWGxHNhwxAD6p
	+Md/NRSlev5oAOK6Qmd4tqj6TvL4UITt5DK4XclgLC++k/jLx7v/ocugBgAwqmPK
	VDAcehb7PXwQ58tgL6ROVp9AwrRgSuCyaYKckjc2OdSKHr6edvxg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t25x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 01:35:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63R1VJNi007445;
	Mon, 27 Apr 2026 01:35:48 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2aba39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 01:35:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2Lvja9y6a0W69GtnY2fMh4O/DtISw5Cesf7rsBgt8jYIPdB7B8dh2UG8GOer15DYFO0mYdZdAShJw3xkPyFSW+6mi6fPRSQOkylzvmGhF3n0bbjrITlhvUm4VV6gu44Pjh7TWzkel82lxlW6aajQXB1g65rsTUH5DLRySg5Y/PwiqXgsJw0Jc4L9teKNcF1tNT9cxC3ey3Bw+h47noSMHaIlBlCNhpWDjpBkLdzZ/xIUfhYyg5hIq6pqDIOnEEBzh1riFPEpZFj940f/KgwRdGuwZT8SIt8ed9xxhqQJ0VYj+flf8tAe0eo50/z/NFyJ2347LzFRMgb8v2pkclqvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUijGD7/6zDQyMy6IJCmWjJz1y4EpSWYqFi19OKZVX8=;
 b=LHBVMdCC3vkpjHlov3UbXU9YbP3Io1siygUBwxsMew/3kvsc9tHvKG83ei9mwXs7EAIXWctg+Yn5Pup2pyKOxcIbT6Dfp4lQ4+ihGnakboHm4xpba9KNL2GoSX5/4AWfy7Yaa6Y2VlW3i0QNPkXLIcWu9mbelswttrfD3KpLnY4PuNi9jR8rSDXqtV6Nu/dDRm0zOmBMPIYTuV5NBiAn0oGaGhmbKY+KjTALccYDG420n2CPsKdi3ueH78ZbRhcnYeddlwNul9aXpaHWCw01yD9/lVv46SYreoY3pL/4wsEu3gTmZDPHltqgfEmESrLrcv8+HIrZM2CD0pQxH2/Mjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUijGD7/6zDQyMy6IJCmWjJz1y4EpSWYqFi19OKZVX8=;
 b=Z86p57Ph5BgEHk/uA2e4cT/MVlZfbon4DhVpLpTa+//SJFWJsNk5duTrVOn8POKVVEiAellyMsgrJpmlQAed1m/GVFAeN0Xhl4yD4b5CGDswy19hwuZ84r3GAOkAA98oT1HFvzrvoDKeRcamVdfkdGo3YSjG9K5XOWLaZoKzbAQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV8PR10MB7824.namprd10.prod.outlook.com (2603:10b6:408:1e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.24; Mon, 27 Apr
 2026 01:35:45 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 01:35:45 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: Nick Spooner <nicholas.spooner@seagate.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: Use string_choices to fix Coccinelle warnings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <2334cec9-c80f-4fe5-a2e9-e35d4dfddbba@acm.org> (Bart Van Assche's
	message of "Thu, 23 Apr 2026 16:55:47 -0700")
Organization: Oracle Corporation
Message-ID: <yq18qa9i3t1.fsf@ca-mkp.ca.oracle.com>
References: <20260423211644.3481898-1-nicholas.spooner@seagate.com>
	<2334cec9-c80f-4fe5-a2e9-e35d4dfddbba@acm.org>
Date: Sun, 26 Apr 2026 21:35:43 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0030.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV8PR10MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: eaee9078-4d4a-490f-9f69-08dea3fd4d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	r3ep3fg00MO66HdR+awFgOA3kz+PAPpoKkmF8XrsktOc+2Wwx4ZbpIkUWWkrntiAvxq94+51fyTXa7EsK08BWM0SLyeudjjGUT7npRXPodOHH/vGqpTj+9RD2eN1s6q/mcTDOczJorkH3LdYnDIOjZn1RF5o/7Na6IKBxQHsAwqMzAQqk+3Dv6RNZgeVVhpsp9+0yzkSL0uInjiOm7mSiv6SpKm/FdEEAD/Seu8nZaZkiV0VDWCQHKK2eW+3MuFXrcDwtiRI8jeGXnWWwvFVfQJ8FMc3cucJ3YQP7wCvNBlhUZnlg7IJ4keveeybGSbidOYPO2+glM6XX7dAkdbPLASkX+NyTmw4qnrTM9gR9TjA+lGlbeR2VgKEXzoJBBiR8J27Ffok0Vn4RMkvtSEGDEoBbCeMUnhWHkO1aMJAMjJFcHrDmBYnbf3sRU7MPtFfyaZfxkUdjTuj1OqjW2I6RWkkrNevwEiwtbh5TOMY5ZQMvqLywBP54h2eOIWaYshx69Qy0ogjunTnr+g5ACv4u4pK6vZ7Nc7WxBl1i/lvBRuZfZHrYc3M2KlDjGJBrRGYq+DeyqSWTIf39f6KeRrvCc13NgUsX5YcnN9Oe0a8KZvChwDAnIUx2UertG3dKAyxn4jZwyrTdQ12mSv+Usy2AXtjkHU0EWhbu82FDrRfjlEe0ysF7T5Uok53Mt81sedVR+5uv0S8H5I0aybjfOO1FXDlNMmMMgFAn1J6N4VKB8g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aHEKJeEtd7eJGMYkNR8LjdlS2tHNZZG7pNwIbrFERqgj3wqYtTGUax8aDsJJ?=
 =?us-ascii?Q?FFiGwQTErPHr7ZTd5z1O2zi4YJWOLElXYKBk4Rm9NnEYvhJpu7j/aFXyHEyB?=
 =?us-ascii?Q?QPoICJay0RmS9PsFqylo2DUp8OUfDvlLCkfE/HLmK480eIPl+/z+PLfDi8pT?=
 =?us-ascii?Q?Rk4xWXqxOT2L6dwksH1dzZHNwdnu3tHENO9cCEPzgyEAa4mw5XNR9GkbITJw?=
 =?us-ascii?Q?+GLGqwQshlAQFm0EilKEDOs0PmlD5oUtlsw5SgjRFzBPd9seB5JnmQtLgXll?=
 =?us-ascii?Q?SxgNlqkAzb6hI2nF+uLhN/k8jXJ7HztF29u+me56BK7rP5e6MG/eaqtNytcg?=
 =?us-ascii?Q?9zSbhWihSsVasJr7NzPjmc4Z22dqOIcgxU5N/WMH7czLQtaEwRXgZxPARQKw?=
 =?us-ascii?Q?rrNXuFcrfWl0BQdibGS64+VSK+GEQAg+C6UKlAtgMTeV0vZFGxHvU0acv4/1?=
 =?us-ascii?Q?hCdlkAV4+WwUIKQKcDpTPFShQW+1+zUbilM8gUZ0YFXC25lgiXVArw7Ije90?=
 =?us-ascii?Q?Fz6AmPE92fo0y4vuvT4SCnPNghyiu0IVJslvcDwr8q9P4LoX9E+j/HHzTVmX?=
 =?us-ascii?Q?CeEuvq84sGuPHGkeO4M8ktD/PAZOxuJaqfrsS7u7KunM7lLcDSqOkNXZGNBe?=
 =?us-ascii?Q?oqPT9N/eWsZTug2XJEov8QGvnjiEoz97uRyh4mZoiNGq/g/hDfZSixQaSMKL?=
 =?us-ascii?Q?JLzC48eRopjyT2a9Z4SJFR5fgfPcogtd2yDCrxTKjAvfwY97oAvhWXCEv+uC?=
 =?us-ascii?Q?naThhVjY7h+CrpY21q4L/8p/RU2l1GnrkCrFIpE495knqb9nVJnEEbgvjQS6?=
 =?us-ascii?Q?Ug23hd1p7nuqINt41M4HQIB8hv+5mg2jsjiylT1h/Q9jSVr99WBVQrNiT4fW?=
 =?us-ascii?Q?R7ZYNrwokTGsJEjmBT06UhdgEsnVR2pWgBaUKCROdyY6RucrBsxL3tAxICHy?=
 =?us-ascii?Q?BJrbO3CW2ESBDqboUonU7SvrNQdeZiJDuKMuVT+Cfi7sCLVhR8Pgyr6oxq8q?=
 =?us-ascii?Q?4eu5K7iimx/gkf0cqI3yb719U0Qw+4D4F5pU3M3lvPYV10ZwSX8uAclzfXtX?=
 =?us-ascii?Q?XtUDgTXSQ4W7u/jHNLN2mfQe+cEhw9hiCBz5CKlkAhTMKQY1wSMaubAbSlLl?=
 =?us-ascii?Q?45074wSaNXSlKRiZ7tV/Zmw6rpm3674pfUKwgjUKXEcuDfQfAlHNRlqtOSDK?=
 =?us-ascii?Q?l9T8Sp1yaAfBe/hA1sIg7Kp+BqAuVwseV1GMcgkBDEVp8MkuyvGBGHPG/Nd2?=
 =?us-ascii?Q?t9QyoAEU9MREIehiiZBhlJNsK64gjutIroWsSlJWiWREJZHe0tHOeyaBo2QP?=
 =?us-ascii?Q?JF1Jc6BfMeGQyRlRLbtcjpsoDjZuztROkplZzkX6LyawZ/rkQMj0l4TnYVyw?=
 =?us-ascii?Q?Jo8hQs9JIWilvyasDcUvU0xaZxglEZWhVQl6Lp9l7yF3+9N13fW067o5M3FM?=
 =?us-ascii?Q?VjmC7a8KMz3JaiR6ggorRzrvwJpPXvbV+c4MpOENOXFX2RlPo5UjnMvVCRAn?=
 =?us-ascii?Q?PSfstdrsQvtVppZw4cfRDzc+d3YN3YXCPGXhXkvFvpkNiGh6pBLyyIDlU/7/?=
 =?us-ascii?Q?cnfzCHyNxgXd37cp95bNUxLe+XU7rgS8F91vRwD7zUF2P6mq5e56JqVN/RYL?=
 =?us-ascii?Q?vrtNv1DiiKWL6KGkW0JsuGNR9b3lkizwkIJQ8WT4Mi1Qgprsaj7LPM2SVu6L?=
 =?us-ascii?Q?0Ppj6rbsfzhoNKLRuCNnNEZ4feT9McI1Il+mY/kU135FZCA/cMqEbyjtytA2?=
 =?us-ascii?Q?FGVGwUuAhNinxOwFQPQ7DuSZa8BWy/M=3D?=
X-Exchange-RoutingPolicyChecked:
	HiEn4/lrt9o8UOTzn9XgND3rtb1nVtsFwCLY85ulfhO43CPiKF54f7HNtJ4wfhr3EPUOwYr1EmSXBesoDuuFXqpY5EsVWx0urmQk2QzKHvlPy5sAr0MY2Xr31rYj9DVQx0NLi7k57Z2iGRnb6OEGtWmR+04a/fwbE0I1/3mmDoa00J18wxcnfUyts9NtenXJIMtgTvVPBmHfKr9Z5bYlGT6RBcQrLNSpLmCAcjDZt5Vn1HbSrl6FiVkzEyiy3LS9czbXCxPEO1Q63k9gLSoiqyj0nCd6lvgKsuJmJsUQNo6073Iz1zBt2jwHycsaMPCRbZalYqCQltCvDQXVYd/EAw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	od/57ybfCrFqqerv8i/MAsnlDfjFyvFhaqf9gJhWst1stu295PsoJBj5tYQ1jLhsc2x+Vxqti9LuHIfVhpTPcU36k/E70eidDgPT+uFp5zJIPreBppJHM6Fr+p7fDySVvbT7hF5MkLSIxp/eewIO5OmihWIy7E04OSU2pAyAfVrxFDn86gGSwV25ez+DeDkT12yJAS0k+mpHRKrOEEk8ADrZoDSUZ3TOjyOveSn0AQXngAO+f4pCC0h6Y1GohSaCnL4b+spJsEHLJR890DVXHvE0fzKHKTDMwPMKRP1eMMa50tDCbVR1kHjdGtUyRO2xPlS6qzAN36yXGKJmlOMiGksw1EA99ZV+KW6gyvPpn+1SHSar0LOawK/iRmWtpqIt4oKu0XhXzKUD0zJcSeQsh6TOfdoO3IYdx0GbVTymOfyRaG8TOqb4F0+7TWsdqaBfkJPr9JLo3IThPEfoVGP4z6hsVusn5SPeG5+V0vMejBYsaME6zU65CtfNN0cEtRh+kvc13egHGPy/nDYGeou99Srwtpw15EWEDAmklWZTS+pVnomTmgvfFQOSV5K2xm8wBW73RMWO6Xw/bi6gFnupsr1/G2/oQ5wGJNGVJC99ZmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaee9078-4d4a-490f-9f69-08dea3fd4d37
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 01:35:45.2413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K8MMm6fKMPu6GtAHxISbVSreFvNE+eSn/U3vR90a92Ji8PJExKpfWKG2rRkzgCY2k8CgIe3jvCU05s4SDcwRq9/eCsTbAANmZCSefrjEcn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=657 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604270014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxNCBTYWx0ZWRfX8FipP4ezRR/N
 y9NfXNI4yRWrSwI+J8s2M/svF8ZxtHNSnwj9OVu/vS98LqJk9MP4UeDTYcTOmjN/H9o1Iv2b1hM
 HtXHD6RVqVoWvuPIqGi1ilpvK7WyMirkAkYgLf4bs54O7an1zfG9fwOqFCzggW/yfi6Qg7aD3z7
 JpwL8YCSnyW/ZfGVtCo15nCuaw9Q94vEm/SqU+oA6QLg1tS8rozjnRlUSl7Zmq2t8jALASyC1OD
 ses9vpnao2zM+qP4wEBV+NNqgK0K4J4PeEkh9axzjXSH4uccuj4DKq/iVE6zDch0//y8EdIiFUv
 RaRih+0P9gVhRcMKwL03cyA65xrLGF3snoSlVtk/mqO3f1fpNsSRxjded8Wm9zQn2p+nN/I/IGc
 cYzafXc8K5AB6Gf2vghGxPlWLQKQp8/k7VsxSDIZjS42C8xmrH/aj18iDACAg9mliqNA+nubUqN
 KkU0Z1A/l84BTnmmIxDGrdL/CU1FfHoaR6ZrtxI4=
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69eebd75 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=NJ0CVI60cKV4Ele8TpYA:9 cc=ntf awl=host:13844
X-Proofpoint-GUID: DpOI1fRmpBWjpgU4zCt6usT8z_IhO2yv
X-Proofpoint-ORIG-GUID: DpOI1fRmpBWjpgU4zCt6usT8z_IhO2yv


Bart,

> My opinion is that the sd code is easier to read *without* this patch.

Yep, I agree.

-- 
Martin K. Petersen
