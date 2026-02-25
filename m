Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260E3EF0BF;
	Wed, 25 Feb 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033873; cv=fail; b=jcAaCPTk/KsGUHLdmYM0i3Il0jdLUMq2cWJthaIkDD5R6720Q8tkXp+qKt4WdX5X9dXq4L1xPirdt6MUzES7qQWEr0Rc2Hsu4wNWQ4gn7p+r1nJNYzwSizW1VO8O/N7bdfnfDJ1koJ/xmOaUO4FNRAIdzr8GuafsWhPCi1QNk64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033873; c=relaxed/simple;
	bh=Cdt7kSTe46cVc1nnVcq8ZyfcuqmNL16/+DHyCNpbf7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XboP6vt4OKd6Uu2ViekpWKdTHE438ngl4SrVUCI0jAy7wAx/SkUQ7mLxjuykLPkAuKoP76UvJTPeQKHFTyV18zWCf94qbI0qO3FsStW898WFfDkUvJQCiDrVJaUV1wDHpplyL8E3k7DpDnMPZ29uQmq+fAeqS9bJBnuutTmusXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=awYM9JA0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DUP2zW4q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="awYM9JA0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DUP2zW4q"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PETBIo2703463;
	Wed, 25 Feb 2026 15:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eFCeLHzw0m1Yfpz3sNYA1mrDVW94BDP8GhcIEEYWDq8=; b=
	awYM9JA0EEHkHT+CppyuvdY0lzqSpSZToETKXEKolDWG+X7fh1Sp0tpyN5+hma9K
	jrztQVhI41zgK7Vr2SkuP0th0hKVgHQ5wvLj18a35vilyASqn7O+ErH1HW3ffwa1
	uWMNCIM77DvBr6kZSLAddlc0pu5LhCsasJMtPEg8ncH48r/SFf+QxFfbCJU4W5v2
	SREgA6NZWsJdv0ToIKCWHT/dx4AdY3AS54qogr4ifHVMv7ijRe9sUmpKlWW+hkPH
	OKAuIy6peXhBjuitlZNUSG0G96OsmsC1IkVSw9Iu3XubZ+l3MlXwd/fg/uauvkp1
	tV+g19ibE4FgHfOLmo1eaA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbegj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PExug0006258;
	Wed, 25 Feb 2026 15:37:33 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9u1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SsBLFPsUSvMD4zrz0Ol20fEfXGKdEBKEmcVQVDaf1VGla3MCHFUPj1ccAgmXfr+MCAtMlMEY+PfSTfbXvOqyFS8nKhSEp5g+Z8rGx8gB9tzZQBwQ570lXonkGmXpi93oeJ7mdu+zj3dN9jN04w2dJD8TnTKWVav92KWt/wdXS7C086N80h1NXNLm8eLchRIi9doCPVi3eWuXaMd/6VgQ1vMsmYeZF6rsSrFoplvbSNQ4/wKo60fIZYInX4HA63zFDLvAPeRluGM6vP1ihxM6LllMRy0dkyMOGV17YmHtmUb2DZsKLL5CS+VupCbbB1S/wmFSB1mps/lLySrHFOZYWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFCeLHzw0m1Yfpz3sNYA1mrDVW94BDP8GhcIEEYWDq8=;
 b=GmAZbg9EznQGZPxTd9W6XNK4z8hv8SdT0ZhW3TbFMDOkB5oBTVbLdxFmzdfFZzx81DIhK1fspb7NQb6ShBeDLzZUOfR1SNtItLDLzD/OI/pIRLDsz/satF/H0btBywEG4WNBoFpReK9dwTB+u9kK8Sjw/7T+nPcCKhuUO7F2qNwb3Sq+ox72PreX+YTKMWFM5UTH6Wu/kKvJig0Ei2k/pzSnt3gT6v+zBHojf48laDR8/gmTb5d70pxNXWYnf5ri1x4iQ0R0Z4WZ+TwQN8dZ/JEYVyo3Vi9W3lbdA8vwUoNfjtay7eS/SLispfzwJWsScI981mq/yFlIo3Ann7Hi4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFCeLHzw0m1Yfpz3sNYA1mrDVW94BDP8GhcIEEYWDq8=;
 b=DUP2zW4q6oB2wkEYMUbC5MqrzxJQ1kKGkgq7ww2CdnP/pMaqX1zMMP0lNpGs7g56/ecGfvLWoFcqewCxcUMIq0kTTcjlXOAdrkC7SKS9Urwe+wVTDOmwwlsiucwBWUnBESRP4vnMboVK91S70yTW9FLdXLSP7JZFWVr8prITjNg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:26 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 21/24] scsi: sd: support multipath disk
Date: Wed, 25 Feb 2026 15:36:24 +0000
Message-ID: <20260225153627.1032500-22-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d6a647-e262-47fc-3376-08de7483c742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	/KH0M8dwGlxgpwRtWqzNXrq9L6wbBCb0wc3qxRmQYsBpOlUahlETeogobWhk1h6OF5b4GTic2xNvyN5WE3oE3mGYQ593CXb4q/WWw6agltPvb4XpVAYMg47qw3IgGb5PrQeAo5FO3FkhlH+KAaSSy61EUS4j3xWc6RTkKrCYjavZXCU/fvtFWBn6sSh/EOZeEqW+USt3ly56/C86Eo19q+CkPZH+/U0BaGYu/I3Ui6TqkziGk2PYdrqzp1VIcv6fKYxT3FmtpyQNEDhhuZaFFCcj9FyvqSAs0uWKfXdx1DaBDOtD0cBrTAZGuAGAKsUFXIVC7eGcBz32kYWFlYIHAavnt9hFg5IwOdrwg/BDWSrKAsd265q6Es1WoU1OGf7p9qN8OjjZ3FMwoKeZhHyw2MNsWzMWv880PEoSuLsK6becDjqEAukX0vaDOv2ARq2lSLU3y91+7G3zvZYrp7/bnNKDVeqFUTU2nM0rZWVDV10zUEqzoGW/6ZGBrtDFk4ueo4htSUGHiZ609qiYHieaqNTui3YHzyL/jG9vUo0TsE+SDQyXDmt7PH/jOVEw4iAWp6OoUrVKy++HdlA7ZTZ82GygwFZWz0SP3WwF0vwhU5CRwXvUOkkkJrE1hZf6+iiy+ykX/EOcDIeBqG3JmO1MLQRXD0Hp6cfAZ7vV5153wxZiP+Nq6gAWGS67wlFvG92P/ez8RVyPaCyKpgMNmsjoeKUXoS2pQs07yH/wgzoRo9c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lIncdmImMUiInbFSh2EkXrPIKWU3lFSnVxK62AT1O6EmB3G8HB2BbJBN4IWO?=
 =?us-ascii?Q?AGwrVT2xGF7Pz2cBNHgxoAJZiS/vwtYCtCPYOnMEf5Oi3cYa/Fdht3Ym6INN?=
 =?us-ascii?Q?1q+mTfu8eC1Yz+dr4ziZNOyJa2fnlXs7qTuHpkhfUrYbT/Qmc8Q7NJGcQ26c?=
 =?us-ascii?Q?3ODJ300Kv+YtvrI3OvNkOPsS53dVpkPqY4uf3spY8d7QXMdIUB+ox8kEUMMf?=
 =?us-ascii?Q?O2COh9+wi8FAo0ydMawtR+gMW38Aq47Ytw3LchWjSBIfzkWfWGzMGtoHOD1p?=
 =?us-ascii?Q?7YKBT2U6Oys0wwQuEnVe5hVPKxQAI/ViTiLZYUk3BjZWoORE7asvOjbSXFEv?=
 =?us-ascii?Q?XoIcOiD/6NXXrDc5ozwwhSbwJ2hYIyK4+uznfDlQMggyZ4ziY9sTDSbfe0T5?=
 =?us-ascii?Q?lDX+X+1yXdCJ0e/7XqdfsuaoemKT9Q0O4ETjB9LiayckpapUmg9yDU3MBwE4?=
 =?us-ascii?Q?NfXQ0UZNgASa297PAF6bCfgMnzdXEZG47LXl6p61Nof3XaIqIknyf9DtLX+x?=
 =?us-ascii?Q?o06gmpAedejBRrr2RRlG80tnKURyiwrdi4qDNu0fA0w4bWXvRwrUIABBMFgJ?=
 =?us-ascii?Q?Tyx+SayxjhzL3lVZy/dO1MS6CaXs6MifbGY1rAkDkLiORQzEb605ATZDeYIb?=
 =?us-ascii?Q?EszIne4ihJOI8k1iNoiluxYG7rS6BKnF1d0+me6smIuqhPKc+0o8A3O2ftwz?=
 =?us-ascii?Q?BwHcxaGlo3Q2oygDG3HGRbArbKprdD2ePyBcuVgMFblocc7LJeVEjJxei/vh?=
 =?us-ascii?Q?f7VkNgY0SFYdhexZdlX0UqxksTlIcLNxPbfDhekxI9F/mcBt5FRxrzhAAzRp?=
 =?us-ascii?Q?U7B+POzsd0ZujZSoEXcAC5E0cC5jgc3Yjk59UEy8IzXQr9ytcAH2TLuuaOMq?=
 =?us-ascii?Q?i4+Ci7ieppl/XZYa7/5ziLyzMP18FG4FOm4+YTvifNBgCSz7qI5RImYUxalX?=
 =?us-ascii?Q?A7/UI+tBJI78QWxVoi2loTpnZdvJjJ5XwYzL427rhegcenD39WGmHYEz0zyN?=
 =?us-ascii?Q?adJhSoGAMjfOIazar8otAOmfduzAyaQOlLNaGMHj1hlu86320PfzEbm0O1bP?=
 =?us-ascii?Q?5Q2yXqYP2u1l1Rx+/NSaPz/uA5FsvGmTZfNO6K3KqR+kXFaN/Wy7Ojo9oWbB?=
 =?us-ascii?Q?o8zOhnwnja0K5hy2U3T82cTSTk4SXTRftRukxh15kj7Anu4/d/RjuEuuJlqD?=
 =?us-ascii?Q?SjvL44ws8SxENmDDYV5BLQhCf1Xp5wJVTDf17LBv2kjYMpXZ/86QinZxNlxS?=
 =?us-ascii?Q?Dj8popC57UQm876C85HuSk3OwL5hl77UoL8Mj8ta1c7hUn9AgoU5xzkF+05V?=
 =?us-ascii?Q?NA9cPqJ6ngnbAVOqlBfp14ck7hXiTc9uO5jZH2a9F20X5uQlTCO8laMnGAyR?=
 =?us-ascii?Q?IHlamKA2qt9fuZnVZep6hT4Q/OfPh/Ti7BI0tXAOeaGCz1qxuTQGybQmGzSf?=
 =?us-ascii?Q?DUMH9qvMfqnVfhEukiqjShucJOVoqT0bflLzePHZFy+x7J6hzI5TlID9YZP/?=
 =?us-ascii?Q?Dj4IddEb55hGHt8tj46bAW2bfTi6vjvqOX7khYGOrNk6Upuyh7mxPLn4zeq4?=
 =?us-ascii?Q?UURaeUI5u6qBga8Hx3qOC+rwDX5DkhNB6ZKDFfk1wEaeB5Gt2j9IUlsbssLu?=
 =?us-ascii?Q?9FG9jR0xrsxBDDlYMRpL3jO/Uiz3fiKg30U2kn4HXNPDO9VCG/HFGtc2jHc6?=
 =?us-ascii?Q?r8viFFyUsYX9Bs/y0zYn2orfr5SNPp/cOLy97M3iJhOYyIyu4G6235cP9xu2?=
 =?us-ascii?Q?lqY+3kYOM1+drmJM591fhmBNoFkt+Bo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OvGTM2/yLkLF7IYLrpkTYaW5LVjj+yEnVAHV8qaoyLRTIKjGLqgdppxRwzEi66qkJDKhiRcIai0czjsNPnAamjewnEoLDWI89f9HVwiLrYApA4x2YZRCnqFt38Q8vrg4DCU4aSAub+CV9LaYyDp5BzSgJTGGajpQoJXqaz3PT3EeQNrLUth9bn25JgYPRmf7Ddu+hEQwGUbzQtGv+rKum4EH7tYvpWefy3ifd7XpYMdzCcK8xShsB2xz9DzmbGhvPIw2S5djr3Zhpo4EFV/H85tDntIecK5HP4xsZoliJloKkCHiZZGMZek+Iq0x8vkcNpWdRo/LOZLTwkcemTXtExKh3NYRHPibzj0LXAVxOJLDsu40AIAvzztljSvEtdrRWTY0XMWsnFkFGT6f0AxboQsiyveeLu0aa6Uulq7rKIlSei1aIbcuJHteUA9Czi+cafgO+UfNcvSW9A6a/BK0SJELCbArvTCbjIH/8i2vnqzziLl4W/TBJVk67QjwDRFYOT9MajDsXJWj81TEdKbLKsjz/A+ADOohEwdXZKI5NrNWslUphQbbS2df472yaecGdWswQVefWxvr20LoR5Rd31C5xT/DWZ3RjSCjZGq7iJA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d6a647-e262-47fc-3376-08de7483c742
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:26.7363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omZi3KGYyl2zc9SqBstiC56v3TGDqsbKWC6LW5zhqqcX/skfCHWnd/FXnLqvpWZCbfXj9jBAZCxudkkkIzfttA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXx+Dxb1jNzxEb
 WK9xg/Wt0MHCY523r0B+W601BwmerQfA+A7mc9m9GOcIIOeXQ3a8WR0xvG0L0cHNudHTcyXBLGs
 bf6U2DCbSMhHZcdr7by7do+k5z93CER1pYvSSHmH1WaZpL5YXB/rbQmVf3kDHNzd531iM9Y8Nnz
 QOyIDDR2BS7gqXpvkcRAKc4p+E6N+8rW07wmRbT9vItS0KKPjxsRbSJLn+CThxs24pDD5nqe/L0
 SgyzfBKWHhECRjEX51gRc0AqMmzF2lA9k4dTY9iTn+peeCREXVdqwYY35fmfUahicWXxc7FhbkF
 T33zCb3K4Jqg1BOdgdSkYhUJ/lyzojgjB8DhJ18CakOB0CSRsr6lgJYJYQ1t+9sEcOHwsUYezzk
 cmuwntOCHFRg6+eGreTDK6MHPkICI0tM6o/3U3MMNFFj2RlzWIwUbLCTHFHegkOQDIzh03Y4Uow
 od5DnAohJaF5X6BPBmg==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699f173e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=f7EEZqLDhX8ApkaZtTcA:9
X-Proofpoint-ORIG-GUID: IrK6_GdlUKZEBKpV_-txGPCvb3gKNlJx
X-Proofpoint-GUID: IrK6_GdlUKZEBKpV_-txGPCvb3gKNlJx

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1


$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2


$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 376 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 358 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9617878b53ec6..409c0937764d9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -117,12 +117,33 @@ static DEFINE_IDA(sd_index_ida);
 static mempool_t *sd_page_pool;
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
+	struct mutex			lock;
 	struct mpath_disk		*mpath_disk;
+	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+
+	mpath_put_disk(mpath_disk);
+
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -4144,7 +4165,302 @@ static const struct scsi_mpath_pr_ops sd_mpath_pr_ops = {
 	.pr_read_keys	= sd_mpath_pr_read_keys,
 	.pr_read_reservation = sd_mpath_pr_read_reservation,
 };
+
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;;
+	struct gendisk *disk = mpath_disk->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(struct scsi_device *sdp)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		struct scsi_mpath_head *scsi_mpath_head;
+		struct mpath_disk *mpath_disk;
+		struct mpath_head *mpath_head;
+
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+		mpath_disk = sd_mpath_disk->mpath_disk;
+		mpath_head = mpath_disk->mpath_head;
+		scsi_mpath_head = mpath_head->drvdata;
+
+		if (strncmp(scsi_mpath_head->wwid,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+
+			mutex_unlock(&sd_mpath_disks_lock);
+			return sd_mpath_disk;
+		}
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static void sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+
+	mpath_device->disk = sdkp->disk;
+	mpath_add_device(mpath_head, mpath_device);
+	mpath_device_set_live(mpath_disk, mpath_device);
+}
+
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	sd_mpath_disk = sd_mpath_find_disk(sdp);
+	if (sd_mpath_disk) {
+		mutex_lock(&sd_mpath_disk->lock);
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disk->lock);
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+	device_initialize(&sd_mpath_disk->dev);
+	mutex_init(&sd_mpath_disk->lock);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	sd_mpath_disk->mpath_disk = mpath_alloc_head_disk(&lim,
+						dev_to_node(dma_dev));
+	if (!sd_mpath_disk->mpath_disk) {
+		error = -ENOMEM;
+		goto out_free_disk;
+	}
+	disk = sd_mpath_disk->mpath_disk->disk;
+	mpath_get_head(mpath_head); /* undone in mpath_free_disk() */
+
+	sd_mpath_disk->mpath_disk->mpath_head = mpath_head;
+	sd_mpath_disk->mpath_disk->parent = &sd_mpath_disk->dev;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = dev_set_name(&sd_mpath_disk->dev, "%s",
+				dev_name(&scsi_mpath_head->dev));
+	if (error)
+		goto out_free_index;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		sd_mpath_disk->mpath_disk->disk->disk_name,
+		scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(sd_mpath_disk->mpath_disk);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_head, mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_head, mpath_device);
+
+	mutex_lock(&sd_mpath_disk->lock);
+	sd_mpath_disk->disk_count--;
+	/* delayed removal not yet supported */
+	if (!sd_mpath_disk->disk_count) {
+		mutex_lock(&sd_mpath_disks_lock);
+		list_del_init(&sd_mpath_disk->entry);
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disk->lock);
+	mpath_remove_sysfs_link(mpath_disk, mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_disk);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct mpath_disk *mpath_disk;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	mpath_disk = sd_mpath_disk->mpath_disk;
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+
+	mutex_lock(&sd_mpath_disk->lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		mutex_lock(&sd_mpath_disks_lock);
+		list_del_init(&sd_mpath_disk->entry);
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disk->lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_disk);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
 #else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+}
 #endif
 /**
  *	sd_probe - called during driver initialization and whenever a
@@ -4198,22 +4514,33 @@ static int sd_probe(struct device *dev)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4233,16 +4560,13 @@ static int sd_probe(struct device *dev)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		goto out;
 	}
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4260,6 +4584,12 @@ static int sd_probe(struct device *dev)
 
 	sd_revalidate_disk(gd);
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4274,11 +4604,15 @@ static int sd_probe(struct device *dev)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_add_disk(sdkp);
+
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4292,7 +4626,8 @@ static int sd_probe(struct device *dev)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4316,6 +4651,10 @@ static int sd_probe(struct device *dev)
 static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_device *sdp = sdkp->device; // new code
+
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
 
 	scsi_autopm_get_device(sdkp->device);
 
@@ -4332,7 +4671,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
-- 
2.43.5

