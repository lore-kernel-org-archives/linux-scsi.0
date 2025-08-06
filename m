Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65925BAF0;
	Wed,  6 Aug 2025 02:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447459; cv=fail; b=m8qUWaQPPQvHQxhvzx31tHQFRuM1yYAlwaW7DDl0/rOT1q7MWrjzkKDeMXwt3J1wKvzwDuo01xAotThw02ELGpw5eZyCvhwQpQUZVqlled3qkwlbEmo/s/gat5CrpIBZoapzap1tcaUtjTabMwt+q41HgXTCHd8Mu3kysOwv738=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447459; c=relaxed/simple;
	bh=zfMXf9w/SrB2jh3IpKIOq5ZBU/7aBLgUkYvQUOET+kY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qTqFiZJNcVKZi8tK2q121Etm+nE48DU68jKD9sqKahD7AEb+m4K2VwNi2OAO218o5PjIJAVBd0SPoDh9H3n5YJ9aSN+Y3GUhwMOjvaBENsHaqN2ICVs5/CixEpq65x9WClviezFWRbSiZfMiOxxSxMcmbiPkUVjcQc/JlTfoub0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IJhxsMW5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qt/i6IuD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IJhxsMW5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qt/i6IuD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761u2QO021158;
	Wed, 6 Aug 2025 02:30:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UmfyfHSjDzBrW/45bg
	67IPoYgvR6FSAkRkMrQorEncY=; b=IJhxsMW51TQqZTYEy9Ce6k9fQB+rbVlrM+
	8zlpyvetIagM1DaSKswKgqB90ryWpOxlSZtg/ByOixKDBm4j1F3t5Qv77T3WN1Uk
	hHAmiklbwT7wSL3RrjMVR8w440qzj3tQz0Riwjm1eCUGGdZvzUDKILqnnRadSvUZ
	l0VWEkHULpuiCSFQgfyn2p+3+UqwSX3e72ywP49Zm9rQdqoZ9IvcnxiTc0oLDKdq
	GzMek3VYegX6VAJ+nBMtph6PJJmBpbN7gC5QDCvc+G3E+tmpV7ZZigl084HS2wpW
	AmbKZLjoE0lQIjrqKHKpztbYrvCgdHpTkjY4TtCosgXP4HtsljTg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvjrm4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:30:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5762MTIN028154;
	Wed, 6 Aug 2025 02:30:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwkndj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:30:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s+GjVDpn9cBlnkF20ky4s7+ze0stvEgvBmXpnSdwilt9OGatsaj+zUFEMRiKg8Nv2dFkPd8ZACxAjO4hR/vVcu0QYTmhHSmqIAp71xS9pdxPuZAxf6J4DvdDyl8FDqyr3tC5QH4alBR3ZWu+MM/tLA59k6KCEyBiDO/sV3BBJOC1tvO5qd4X7kHL/VGk4a5vx6lkc1wON6k98j348V1Td077kxD0I1x/6tyRYxadZvguonN3cEwvSf1ZC8m4Tnq3Fy8lX4hJmY+8sQ7rggxluHuQSsRYfPc9HzgwgVKzw9WimogGlmkDepKjDl8YVipTut/sHzkUjYNzssOyiTF6FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmfyfHSjDzBrW/45bg67IPoYgvR6FSAkRkMrQorEncY=;
 b=GQY1uGYt/jK4wIGE05RX2e6yAcfVGzkJ+wa7kxaqSaWWQ85uwDKboGOes2lXRDDZZdjNAyG1gLP3+NzKueMv33+5BbkXlR6c5/Uuy4T8XTXe60RA6MpMNHwoX6guTKVZ8p9ymm0RjbfksDrPSKF1oKU6Cw2tzP0ATQ/y/9KypK6WOqRnpG6+K28VRp/xQ9TVIb8DnST+mTKZyocFwKSisdA9OS0NUJzrWWSz1P4ZiBoHXYNSr+cmf/exMcXmTyXos0DpFALUFtiybQKnpeNAjvrBMMkEOVbXae+OYBK9IryPj7jQ2LoSsso2O/0ccEmJy/61X5ToeDU0CohuuTh6Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmfyfHSjDzBrW/45bg67IPoYgvR6FSAkRkMrQorEncY=;
 b=qt/i6IuD1fz18/LPWFvdPHTQtgmLhBVLkduLk9f7AxUjqnL+pLHT2hqh6jRJUGpxQf8AS0IUVWFK6CupSCdAmXXJHaWFy3B3KWp9DdI+vMLyvZEaPcOqzjZAgY6TJ/UzQmsY7HWNHNyB3yL85OvCWXWlqiGLeTje3tNij07yPe4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7953.namprd10.prod.outlook.com (2603:10b6:8:1a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 02:30:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 02:30:48 +0000
To: Francisco Gutierrez <frankramirez@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry.Wong@microchip.com, vishakhavc@google.com
Subject: Re: [PATCH] scsi: pm80xx: Fix race condition caused by static
 variables
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250723183543.1443301-1-frankramirez@google.com> (Francisco
	Gutierrez's message of "Wed, 23 Jul 2025 18:35:43 +0000")
Organization: Oracle Corporation
Message-ID: <yq1y0rx9odi.fsf@ca-mkp.ca.oracle.com>
References: <20250723183543.1443301-1-frankramirez@google.com>
Date: Tue, 05 Aug 2025 22:30:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0799.namprd03.prod.outlook.com
 (2603:10b6:408:13f::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a3eb78-716c-4c00-961c-08ddd49140b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r4U4vZa+iZKBSCKcdq4eShZcuGOudoAAtaiw0W0pw/r7rvw5xwv6j4pPld7Z?=
 =?us-ascii?Q?bZYDIbrF4lvJDduLTqxjjBdJnKOMkqEyU7wV5XJ7tp2Y1SLvsjJ/zcQaLOJL?=
 =?us-ascii?Q?m4LALmoigBlJEU29QHbM+OztC0/ZlbExuqrvHSCHN2wuSNiN+MmIkDNDWah4?=
 =?us-ascii?Q?sLnswR/7GEoMHUZJnV0ShCLWoxWLf0tBa+b6hjJ2y91f3nqfRs/Eml7TnUoM?=
 =?us-ascii?Q?rKZLaDWp3+aOeTSrh/tkCOCYXnnvjaqObx7X0+JHDAY/Q/GYdJigm2g9KVGS?=
 =?us-ascii?Q?Jb4yIILetonIjv8/crKqth0xbZqemZCaNdQz9X6ggMKTNX02P202YhGb9ufB?=
 =?us-ascii?Q?tC53mk4MR5XkdYr2kwNIvREp1qTAjR7tt/dcPNDq8myDejiUKegnfs5pXIN3?=
 =?us-ascii?Q?qGkHkgINH6p1zrRqdF+zr8QzgDq+wVdY7PYATOEad2wNiRkEUfpK478B9vJZ?=
 =?us-ascii?Q?FiXC7jkhjvOCPPnwPppMiLXM+HWgPem5E+dNYxKGCOlzTVS30zARMluZDXrT?=
 =?us-ascii?Q?VJHur+sSmAIt5rp/+vw3GO2hHHX/1tZSuMuPa/PyMMMMyevzwy8NeJd0p2N9?=
 =?us-ascii?Q?MUVRwCEB+rh+aTnIR4ReVYzSRoDU08G8b51yVDKT64V6omMnOMrSYHJUcA1s?=
 =?us-ascii?Q?E1cz0AACyLNCLxz+wm0c24MTICEaHgknAsfOZ+V3YNDJNbySHHijQtXEbR8P?=
 =?us-ascii?Q?sT7Rcrbg1yqkpcH8IOvEmh0Q++wGloG1cXKcoLEdk62q2qTH4cnY6wunLbTy?=
 =?us-ascii?Q?whtKo2DDK+BDTe2uc0BwvTMhnutDXbbJtIbVgtUTc98SrkxQl4VJ1UbDWPRt?=
 =?us-ascii?Q?W+xB0UdJruirihSUhFL4Gadc+PlTKIYq5As7/Dzkjito9P3hMXG3rtatixS/?=
 =?us-ascii?Q?vORQiQjB4vPpJuPHSl95bRU3XhEmrSjBkbZ46Cjk+Nm7KKTJ+illEANiVZTo?=
 =?us-ascii?Q?s/oaMMM4tP8pdSr7Nl0ZGquA/BgiUF4HmUJPvkUjapvKDH4ueSVwiBO5CvSH?=
 =?us-ascii?Q?KGeeNR4juxAaYq5RP7a/ADT23fSVShw3GlULITqsHucjC/XuRZRDbuvH0/Gy?=
 =?us-ascii?Q?6BphwLo+Oz5xpzo3arA4i9Rq6dhn5HCTK4Z91INZVzOc2Awszf33av1ItHGC?=
 =?us-ascii?Q?MgX/JRVPlXvB7RX+PohiQuigeuy8xnuQQp67QcrKp64NIhthMnyTwtFyGKNq?=
 =?us-ascii?Q?1H44iChOx1TMxvPDYuhiwNpHqVbZ2KsJVBqD3nTHpyE3L4SV/6rqs+6/sEsj?=
 =?us-ascii?Q?cd3W5ZY9IiZHro8UKjxDi9M6rGsMlMJ32Qlsafb5AOSaHk69M2qMpPtNoX9f?=
 =?us-ascii?Q?1Cfi47d1MOmUmq+WJOJ2mAAJZMOwjH5CzsRAxi2OQ9eppRRahacJ9qcTIgff?=
 =?us-ascii?Q?bpnnbq6bjtyfOJqOCY1PFeIvyGDR/9uDfiY4tATTlW2Zu9HDdR8vcy2mOnpz?=
 =?us-ascii?Q?mR/ytwVQI3U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IU+8OclUmOzDj4MvF+lVkxvT2/HOGUd6SAcVN7uu5D6cjPIZCdavQfeGtTNt?=
 =?us-ascii?Q?KBI88VtwmZrwfwwQBJopWuNtZ42GXHMNMGJExNxSqDvJkpXM35loHcWfja1I?=
 =?us-ascii?Q?NNXI78RFPQBG7YeQ5Z4S4O8bzYG2sBOoZE8o/sxOkM4aIX4RIXSvp7jIWMlx?=
 =?us-ascii?Q?o9YJwoQE6cTXpsV+v3UaUVQ9hw2paVhiiI1S33GnbtO5FtaCyynzaKANvES7?=
 =?us-ascii?Q?lHanm64+ucqlLFpZAzC65WousSA2U1ktGvhuECfc1qeACYIwL2C2lhsWBOFL?=
 =?us-ascii?Q?EQ0vwOgy4nWkxWCg7sWQ+txnJt4lJbbhaR9IZBPfDKfieqKtJ/bPn3Q3n0Qw?=
 =?us-ascii?Q?IC/xxtALHgXdEvHNV1XTE0M5bgX/riMCBQ2UHUIwTY2US7iRflamglQoib5Y?=
 =?us-ascii?Q?x0PSmsUx61OQIv3RZZTcJ1PIKiq1UxPuEcLWNI56OpQ1aEt+3KkRYl87QKmR?=
 =?us-ascii?Q?1dD9tWhKIrMLhOXluMGMWYmGZQC77zd6idMeQXC7fG5NRbYuRr5UXVhCwI7Z?=
 =?us-ascii?Q?c9czEAdPSIEIc6p1mXK14xZSbcUnrdvFRIZe4bzsfqNhWdKPDEV/DoXbvVFs?=
 =?us-ascii?Q?mZk7BGS3OlgmMUOVse2Mg948cU6t0H3iAlhOPCM2RLnwwXDUTbY5A/yVsfG3?=
 =?us-ascii?Q?qfDOgv0KB9nS1YWTz6SLLjQ1MDvFXEPzCz097zMk7S6pLKc95kpZF0nWuOjs?=
 =?us-ascii?Q?k1mq1IH+UaAVaTNOFAPDd3VDBEI9m8OJ6nftrGX0nLk6rMaM4WfCRKSkdwv2?=
 =?us-ascii?Q?8a16wSaWIIMTG0ukUQC4hVR2EiBAt/U0ApUSZLjRNOmjCpXBdUsIuOYsjeY1?=
 =?us-ascii?Q?6Osz/S5McFJlYiFf0kHcA5ekonvO5Dmplmd+SPm8vr9bnmJNaaDgaID4XXVw?=
 =?us-ascii?Q?T+fzlROkgfiKlwH6/UNYqTtSPPAsHLSTr+D5bR0p5GggAJvYWCj9Y6sQQKsg?=
 =?us-ascii?Q?t+JskbhA8ESMl5BKQWEa2E3KSu4kN8W2fsYtNC6BbakoCTdWQi7wmXUzRUaw?=
 =?us-ascii?Q?jWaS5K2j27ZAIcJjFRbQ9vYTSY59f5UrkamE3e2XCZOfsabAZMvlEiNxZWT4?=
 =?us-ascii?Q?5Vhe0mPufIxDYFIwMOS+sR7a/2Du97glVabdqArxTNrZQGEMtJm9tNtkSHRM?=
 =?us-ascii?Q?yAal8U9LneWoxCttU7vC55K1mtbjtIJqaL3Fd26IrrYzrzhLbVVTtvQJTv5B?=
 =?us-ascii?Q?4LlEAH/NV8hKJEe/nqKLP1apTkTw1yxGyNXyWjdb1tc+Rnqimbfkc4BgnfUa?=
 =?us-ascii?Q?vLcZHMRqsTJw6uJPsgSNLgQFO1eNXuecYwFR4UxPfGzDhMSlXhPt5SHALzCo?=
 =?us-ascii?Q?lO5rOBQA1y+Qn3kzbhVOXaZoaE//o6a4moYOWSCWtNZMXCERkvQA4INya8RH?=
 =?us-ascii?Q?G749jfsWGNOqFFbdWEF90itIhetyY3+fAcRy+o6L3gKFfmvRIJ2ySCl3eslo?=
 =?us-ascii?Q?+S7tQhM+AMhpd0kapz4xez97NuGl1n/dJ4Vh9cstD3RsYN2xX3zBynWsWnxb?=
 =?us-ascii?Q?Ei4iHYV7hmq2i63wZiyLPVunxfifem04EBv04wE2KzTh6J55RErrsuSyLQ1Z?=
 =?us-ascii?Q?fE5g1RNks98aOerz232vg6AB2cLf6WDpxE320D/elk3rCCIMCjhmTM/8Ix5s?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XKC+VWq6SxDAAgjGpIDJmgbQc5EhDJqkbkC9ujmr0cTBf5rPXvn7bbX+o3+EU/M4c8MLV5BilS/5VINZydhz7/2zBKlLuu3j/NPlv20Ms21MDqDcHg7EErwroyZntHtP3kkLci4iuG9SmQlOzFBu6Em6eDOqcm4lbuhx80/tHC0CKqyFbJ/O1pdR3PGNdTasz8CtpoVzuvsUT4bYNMclCXG0zGDg81jDxrtGBdrCf1+cDtjzjFKh3dXKReWmu/boQssRfg0kFVs5hikLfabYq7Nc1zpMqIN18YPyYCkzmLHfRTIeRNXDHATHGmYZQXcMA+reQYQ0opAL91RDEFZkOsEgFgZGwEdTR/b+qgGb8QbsFWphj564jgpy2TSFVC9tpwJWSUjWP3UoXy3z6BgRzBfldXJnWCI0fb4jnMH54HLIKR+53kfRdI5fAAafSCt7uqrm+9oULOLD0ghcLG+OhRaukizJ3jvOy6iCYTIug+a/LzATYlAG/KGoHLjZRPLkTNufoPmf/Tz2NoPBv1DcA7evALYU3XAEfUtuXbNxefMyTEZQ+dW+mSbCP+mMt3XYku7PPwsqwEm4zWbLN1wIQpE7f3PkOs2rB5ju0apaiFY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a3eb78-716c-4c00-961c-08ddd49140b6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:30:47.8855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5f31NkgVsahFjR//quhLGSo6+n3ki3Ae0c/f8wZJfzYq5ytbPXH+7igq5pExS2QuHzyCHMQrCDmslKVScVxrUe7wFUjYXFPxsGbtJbTO3Qc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7953
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=817
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060016
X-Proofpoint-ORIG-GUID: qWbz-G2QXvi0i1jms0__BKP7dTFK_bzE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNSBTYWx0ZWRfXxBxns9ZR3xtl
 u+L/kA5lwl1z8+65tTrSmym0s+VJxHbznIr6AYadY2w04sow1/8hRlowUbtn+4E1BR7N9siYqWx
 On2XRpUteQj7EtlPSl3sYGVqBmUbVXHRNZr1UBygVpIKtopCd3wjUoQAAMk3J1OUyKboRLr93YM
 VpkXXnpURQIrc7QVLkxgI8i5zSb2VtqOBcTeWTyu0PRs896ovhrs8d5n74rkfN8IfhtRP/Oq1aQ
 WKuiz4HuPWrUCi2QRzS5lcap04JNpqKeRZthC8fAaevLACgakSKyWbhBv+LMHO8SskOAxM+QVQM
 1DCKYjYVUDlfuD2x02D1OueGTkYYiQ/zggrpF6iUv07jsZ59lRxw05z8DjejE09iTaTfXL6GJpN
 GfiOKDTdZamHqPME79wyvz0sxvgLrbbrz60XB4fBquyws1oDslTqkiR6JZeWGHCQ4QFPn73Y
X-Authority-Analysis: v=2.4 cv=dobbC0g4 c=1 sm=1 tr=0 ts=6892be5c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=7FkJLgSbwo1y8gAkaWcA:9
X-Proofpoint-GUID: qWbz-G2QXvi0i1jms0__BKP7dTFK_bzE


Francisco,

> -	for (; start < end; start++)
> -		str += sprintf(str, "%08x ", *(temp+start));
> -	count++;

> +	for (; pm8001_ha->iop_log_start < pm8001_ha->iop_log_end; pm8001_ha->iop_log_start++)
> +		str += sprintf(str, "%08x ", *(temp+pm8001_ha->iop_log_start));
> +	pm8001_ha->iop_log_count++;

Since the start, end, and count variables are only used in this
function, what is the point of putting them in 'struct pm8001_hba_info'?
It makes the lines longer and harder to read...

-- 
Martin K. Petersen
