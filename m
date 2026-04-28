Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C28B40759F;
	Tue, 28 Apr 2026 11:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374735; cv=fail; b=NQ0icjCxANsQt5i28omG5ZFWcAW8uPt6QCtxMCMQgmWIiq9Pes4cr66zFb92NGOza+EC9Msz2vbBmDxhhco7tFdbK5b3TEz3Kh1saEqOKilShIp8+Yo6zH4+CAIv7o8hhpSU8VvvvU41hWFzGHfjlNF++NmRyHFsV3xbyh6tDWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374735; c=relaxed/simple;
	bh=NUjNwHaBLFn7URh87DnY7+y65xCD8AQTkyHP/VSZLU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hnaopqnALTLycxUwDhNM2hL0NWDoQZC2+H5bhJT3VBQLgDS4BrcRCfzGdu1MUGam1eDVRz+4U1NO+cEG/bbeBHxp/9slfOF++vGWZ7FL9rnTAZWTS858MJH9bJbt0JHCnhYn0ct5SaM27ejC5PGiVuJFOmMshAQxjuYp413+heE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=olLJaaV0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n1AXbekv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="olLJaaV0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n1AXbekv"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8qi1A2128105;
	Tue, 28 Apr 2026 11:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fEfU7PLmbUBy/Yii4Jt+qOXwsvuXoah8X9IYRHjBLm8=; b=
	olLJaaV0UDzfI8rZJJJGCGEjYnQyqwNTlDcXRJPvv0yQ1tpWc7y65EcWSZahiih/
	RbmRK69MiJpVV9wuuYpWcIlfLNg4dhMCQ7G6qmAymzrRHkweCEe+ze2Dpudh0WJ3
	d5aZJZWLpzADDDfgKLTlmVhN2LRcq06awPacz6Aor/r04C7ULyBBWpv4yvg+Q3/U
	XVl1wAS5LJxr8dMy3Soc+YnQMQQ8MSoHbkFVze7HcxxHkVkfa0TfugbesIFiUZQP
	PIlYOyh9Qh71ujJZuk5yHTF/th9sJXB/1iXQl3IhNxHxGJ1x7bVGjiH7MsTCDCCC
	WxooCHaGUk7tE9bk7vFb3w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmha7jdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2t2Q033493;
	Tue, 28 Apr 2026 11:11:37 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cu2dh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=svlX7V3jC3eU+Uis8chJDb1wakOUj6JCH6oLKKXSSZ2VSONbgXGRc3l2k/OTl07Sx969QSQWJkDooI5fNvEI57HgmChYmAU2ZPlkIBUqd7WC/OO0pL1eCYQ6KlF69IzH5mUC78KOV8zLDojuda3KhKY2G14Oo97Jxes8Q3/gtZFruQFHW4TfNWC3KHFi5Retta+uEzYQ8Y5WemHzFrgKMiy+CK2AiMHnuxzfH5UzQOd0i2SK9jQtEPsSVFPky6e/cRO/ZIxyB/nQbRE0oDxJviShNGZ8NaI27+JAQnOITxqVsr+qLZDKENU/E/b+2MLiEgRNF+5xg2Vf3OQy/gWfXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEfU7PLmbUBy/Yii4Jt+qOXwsvuXoah8X9IYRHjBLm8=;
 b=liWocKZ38PMemY/enaSEUFwJTegYkbEJWzWAGqWGl0aSexq6dQcZJvjRlrGbKX/EVFP2AeHn35WoE0ib6Od9Hnhu9JvGkuGo8f4CoPDAQMRmUjupVi6i8k0m/yeMYbAiG756QmEI1SSzKCcbwix+ZFsIqrcuaSlrQx/HVEi6lRT9ygSUYbgcTCJTVSOEt7lB9znxEBXqa6kV3BQ9COi2SivIw1ZUFubqsnhZbFQm/lFivUeoTfvUYrDC256IHSzvkVGHMdjZp62J7ZtXco+hYhuDZvPIqXqJIQHVttPytLh92GsH48qohi7QdcYTE9f1Fe6z3LUa6oBk5Agi/qVFzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEfU7PLmbUBy/Yii4Jt+qOXwsvuXoah8X9IYRHjBLm8=;
 b=n1AXbekvskQsdjw3Hv1YGuvoFZ3uvTvaoFYkzWzMoZwD2SLNZMmcjiUiJ4BhIY6Q8+E90kyXbRr2tGF7KhDgJW/cjlW2LuLltwE7bJuPAfCWOFre2V2JXkgbosO3qxPTXSZAY/8HgfJRiLfm35ubB4TZd8UfCgWEslsQ1vwIUZE=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:34 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 10/13] libmultipath: Add mpath_bdev_report_zones()
Date: Tue, 28 Apr 2026 11:11:02 +0000
Message-ID: <20260428111105.1778008-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P222CA0010.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::11) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 861b12bf-4795-45b0-6aaf-08dea516e865
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	i2lokoVy2fRlzVMQb4it+GGKtBjsL4tX/hlJQ6/HF9IFyopM1Ar00OM7ShF+dzepreL5YhhDM6xPGiI1Nil6Qrf7hMjKDwTRxZoTFlrvkF8tn1bl/YyJ8s/dTT7Bf9trDeHP3BPQq+M7x8r+w+jZtjiaIrKtYKoiqQByUoYdwTzMVzoRjGq5fevK0AZPjS1HnET7J9FUyzrzbDeOHqoYZpggxTsivjRQghncCToQtugvpiozuu/je61pnszQXNUC12zQ27thzPF6AaVT3tYSZGiy7P/YuCHQO000l6E2roBy/QSjefL8FPNent2WbXLcUVp/NEjYfXIszWNM8M74Mc4fFSLORL8EcgtBWyE5sNBYNnVJk/Bht5CtqcXZ5dfBD2nvD3ooDqZkl8NQepROMIc32434QWthxB8/epYRcGNiBetvf5+Lx3/7ds4EoYAKjK/vnIKnV2el4jUCAoCh8g9t1m4YBgVOLBu6gc/54f3foy38NRS6aLoUhgiRGXHdtFvNUSIA4INivaruOfuWrYB8sl85vpFwaYn/CNlDiqtfbfUlDUmh0VqjdoF7KiWo9dFjZBHme0g7MJ2uzpewDvvpVXrpOPOXB3y4xhLkUV2NtHPjub5hsToOiJHoLWdIebobgTwifMtJIDqJvqga89+IqxrCbAE/2Qvw3ts3c1RSxbZ5Y5g8jTvkNmN/nDWyrioXDtegJK56wXewp/TW4LQdFIB+hX+FcL98p1Rqaq4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2IEYMmy/fD1vzlqqXHXf3e6cW88jYvMk26Mk2TQZ8CaQdPHZkM18h5oykVjn?=
 =?us-ascii?Q?3TMZZpRbI5wR4MIL1A3PHtdN7xbOgtqdRtz2uZktdR8w9ly10598YQhfERH/?=
 =?us-ascii?Q?UpChc2XX7mcT0EZazkuFD9Lpr7Phl/QM3BstW7brRlhColygcQ52mOad1AYQ?=
 =?us-ascii?Q?YnYpE/pc+4X9d5Aio5v0BEYHOuY+fkUSqDsV5U3rRqoGgtQdztwFNioWv8fV?=
 =?us-ascii?Q?WY8TfFq2dGpiLaCINEuRGA7AesqZhha2yUmeyXPC5cN9Yj20RJtDV1dUg9IJ?=
 =?us-ascii?Q?a7vaH0NkMBhGrkqgr2/kmIlIpN2JLD+ecTawNKUpQsncvm6fFl+MeXhKUWXJ?=
 =?us-ascii?Q?K3opEDDTEJZkWgCIgMZIbMTM0tprjRag6jISjEMwIIfcQDrV/YnTiAzca+gv?=
 =?us-ascii?Q?5idcbG6n1kabFZtk2tkH2jpF4GNj3Z668ftFeShvl+3R6tJS8d1pK/LrME6P?=
 =?us-ascii?Q?87H6rKduw2YEVL3WguGLECU6VA3LDhWwWME5hupQlhp0vRSDU+xGvA4k2EwS?=
 =?us-ascii?Q?fZLiV6KHczYMYz6RgyChDZ1zISUHJamBLl8EK6r+c5jawGtpYBDRKtwaP88+?=
 =?us-ascii?Q?F+fVP0eIM39DvAqZ5M2Me32zJ0RUcLLP/ycdxa/m4dMgH+Dn0FU0dZjMQDv+?=
 =?us-ascii?Q?sedV1rTSUn8eHO3nI1UJg1jgeXy9jQvbVmvnWjAx++soqYXEHhgCqEt2+z/e?=
 =?us-ascii?Q?NNm2a6bDokHC7sh7vSchkdh98VuviHlplSJwDk8E0+752SwK1e87vQARX4RY?=
 =?us-ascii?Q?JDE4Lzdb3S8k/59xbImW7C3WtIHGgMtGqx6DCAMF1MjtfSiTvFPSC9MS/rZE?=
 =?us-ascii?Q?gvRmreDfx+sqVL12BCHlhDA/hvkZOQo4gnyZf0lpKMp6TmVAyHu46cY68E5e?=
 =?us-ascii?Q?cOJ0dWdJ5QF2PZWUj0JgkValmdn/o66PMdYEU6phkP5CRJbChyzitBxPOOXS?=
 =?us-ascii?Q?3lIIKMNwmUfWKV53kBKWtr9nIknCyFCasFQdgXW88soStAMz0TmNmgImvO7a?=
 =?us-ascii?Q?oqYPcIwq1NuG9DnKzMiflkNiujP1eid+vcUTQ4NEWIMvZa2zEO3LrbqHhI8b?=
 =?us-ascii?Q?MszYybh8WIR8gEo50yvmiLCU39Bm8NtnfcKm0N7Uy9O98iHaG1dC91tDl4lG?=
 =?us-ascii?Q?WUlRKTX+mYdrTTHlXuH9ZIFGB5PngdQ3TLjAATYOH5UOmviCliX8hxWasywn?=
 =?us-ascii?Q?tm77q1Ab9gTsFCPj3ftLOwA0tSNu6uMBTJTHXo6ti90Inu9wfC7vgl9JwaX3?=
 =?us-ascii?Q?yL7FhUm4UmfNni7G4iQ7sjdJLCCSzbJOlMnnCmv0ppkeQoBcg2okNeR4u7L1?=
 =?us-ascii?Q?1P5FU9FmQySCJkGghWS/BcAJT6psf0YcvAgy/N+81eSxWOvUO1O0AN+DfYdQ?=
 =?us-ascii?Q?9vTvJd1VBJpIKkWgtJ6HDWNKjkkNaQulPdcQqvYrL34Kq5NvgS58ebKqnaQw?=
 =?us-ascii?Q?EkZtyAlOi+M6WKMvEpArDg2A1IDtIwgNQPS0JXGtuRKO/7zM+OcatK/aR+UF?=
 =?us-ascii?Q?OsO0ZWdWcPi/jj6Zuqx84jIzGKSvAJa0I97qvHMY5mgK4vkOhr8nj/3HyKKn?=
 =?us-ascii?Q?aTg+vxN568ZfbUBEA93SgB6Sdzz/eOxKHdgPUSklPAY9eqTJHtr1Dudi83Az?=
 =?us-ascii?Q?Y9Tw3DnR6jlvTxg4nlt5UNzsTH43MIUEPn6H2s4iJzpldJcLG7b8StMVUkhS?=
 =?us-ascii?Q?TrUoJIJexhopKo03z7DNByqRETORtrg2+U/jGamgZ7dJYAwhz5WvQwvMUrie?=
 =?us-ascii?Q?hg8fTT7wK2u+fhj989bYbaXDipW93lU=3D?=
X-Exchange-RoutingPolicyChecked:
	DiMMYFUF5c9BqpKewI6tt1QjDkCcZFhCn1FzQFLKton6mvg6bXmZdGGayQcrESVUDknH51ZR5FS446oi3I8URS54X1Nq1B0PhR4jSlE+Zn4RHCo66zK+IPMLwWCZMhhlhhdtWeMMDem2c1P0VMFdqoCZKAK2gIqlSxCn4LSlsw3lej9zLs/TxTgp/CGwMbgXTbH44ePCqHtkcTNG9OYujULRVk5BZ44rcCjvuYROVvi2awUgjixBJX33CXqFokOqjEOdharliTlFnt57+RgxOWLEG+exeJ7ia7p5+RXT7yr9vrYP+cIElNMvgv8QABRoxusG/odM1e8aSMfrENWOQg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DQz43Yaeb+5E4/tOcD0xcvpOdjNjx6G1dOkdkzLARizgaoK1NrhY1+w+P6T+s6Dn+amOOFYM89WOikfdvJiWB7lEdqQV1tVTMrwonIEtkD4J+jCdeiV1PeMtZNA5INRVJ1P74lIc5DDS92hynsP+VJOAE0/99IS1IqkMcDdMRAxjhogvxt1cm+HArn+Xgy+Cnx5sqQveSB8LBnfGB1kOc8HytiPmcQnsKBE2hfwytWa/PDKV88NkUlaauDk+0sF6tZlBcvC4WeBb2/rMnf+hxonUvYm1sJdSGDTxDeaDdFjqxnxYohfKJtCN1P0qynqduI74osuCHXXIBMrIQYcPiqWikICclQ1xhBZJiUfvm6r65Mzy0D00NVSx9ktnZFOaDvEZAMABDOWCRBaCWC2loUPQBvm1jAp91G2H/vp1BmCHzMT+z8HR6qDTxq8DYN+P4ttRmV4J42H4pNaqWnFl1iiCE45ogQvME1/sMK0uMMb36Uplgz8HMUvNfLYfGIH9yY6l6aicOZ551wkdkevDsje5ui2iWSeXgktHGODgXjWkfJXJChi38gj5cJPEbSMUs6V4/cU55Dbl2gcfUFqCtrJTb4YJh61KzzaYXARboaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861b12bf-4795-45b0-6aaf-08dea516e865
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:34.1843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sKs3MVdDCzjCFyakRZG2t7Z3ZywR1kvPzzuDI945UyEcFhq/V5q+c2/XSpjMtwEixAvruzeN3QsZeKsNLDjFSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: 2jB6GF3w2VjiIb1oybnRB-OLwlv-heku
X-Proofpoint-ORIG-GUID: 2jB6GF3w2VjiIb1oybnRB-OLwlv-heku
X-Authority-Analysis: v=2.4 cv=CrOPtH4D c=1 sm=1 tr=0 ts=69f095ea cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=hSvAkUGrqjTGy68UynwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX2xVMsPkUlTWy
 ambPQzeRT/wj9Ir/A7EHBYRyeTQstGJ4tUFpHUSnkYqZsoSrJU2FTakD1G5ETyUsMlBHvc4HkPo
 VCw+4+GYE472Hstl1tfSWrrIukUoqjQx1TNJTr5dCR9bCpTcV7Ng19JEltdIUmvUybHYvfY1Ijt
 UbhSWM+MvK/xDbn2yRjhmUr+dsXKp/mkGjcRDKXwAwuugy6XkmHMQVq2ey5EhUiBb7opPNSfxJW
 xaSLoMfLg0OBOj+QrOvwiWvGoEUFemL/zVmeLamjfv7yOJgrfLqbQF9ppGBJTaNGWLGdfOtTjRq
 Px0GK+YDwcZdJPmNOXk+O51EX19Vj4OJoMm2Ce0zQ3qrprWDbNRevlOJO25xmN8dJpoL0qTTt0r
 BW+OFpC/iuR+nx0uYxrHcRUxCJK47uobs8L6ZOglb5tYmrcS+bdLX471AzNra0DEm0MOrY3kecr
 2yne77y8LKoAjriHbqQ==

Add a multipath handler for block_device_operations.report_zones

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index d2270c70b9913..c72f35e02e2ab 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -40,6 +40,30 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
+#ifdef CONFIG_BLK_DEV_ZONED
+static int mpath_bdev_report_zones(struct gendisk *disk, sector_t sector,
+		unsigned int nr_zones, struct blk_report_zones_args *args)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->report_zones)
+			ret = mpath_device->disk->fops->report_zones
+				(mpath_device->disk, sector, nr_zones, args);
+		else
+			ret = -EOPNOTSUPP;
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+#else
+#define mpath_bdev_report_zones	NULL
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -652,6 +676,7 @@ const struct block_device_operations mpath_ops = {
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.report_zones	= mpath_bdev_report_zones,
 	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.5

