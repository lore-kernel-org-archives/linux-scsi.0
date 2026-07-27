Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E813F9A0D;
	Mon, 27 Jul 2026 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163431; cv=fail; b=nuVMle9sEATUsh/tj178Yx2FnwOkEo88gTVpE/htXAmIHY20Gi7hdDZEwJJvFz5HzGutZYFXLWHl0ouwN4DTQPwE0yO96+A2GCvAMrRCPYF7ARHLY7uCSyt7Ts5lxEg5FTFiXa6tyYx7J0TjCc0juwgMM/Q/ooKqJEfT23Bf8iM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163431; c=relaxed/simple;
	bh=sWvv+xc/1RfnnYQpGQeGEWzDj9gLDebdJjGzBgT624M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DK91nVEuWyDUHbAX6FyAeSHhFctzJfMgC+yWzDQdTDADAhmx6HpqXv5nvK9gUd7+LZrehstDfE63PYiyR3w01lHPfSDt+D5gvYm3/gObrX5lyBdAa9IlLGuR/yEkSmzO3Ojipw8iufH/awXcSQno4H7aBtyUUhSXiMF0nAFJY0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Oanz+lOO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FlZCCyaj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oanz+lOO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FlZCCyaj"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTKSX2051269;
	Mon, 27 Jul 2026 14:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nVZqkxv9x6COE+vV6uYvjMhiWU8gyAKnGQ9OzC4QRWU=; b=
	Oanz+lOO6sLxVKTAZRajvtNQ6vMruNfXhRj5x9/uxWQVvByEMCptMPIUFg903Gao
	Jeh6TgSNqSi602n8OKT+QBt99O541TK5UTTDTwlG+uUTkRLfqza3GpKbldUNmeki
	W06bQeUpOYlxkegU+Za738aFLa9faAvT0kx9yyHBQmHm8vhmu4BxeHr9mZvgTOfP
	GovDuIZJg6fIfSrQM/KjoBOouS9lvrOa8iXPcGZI0rUGRqTbzwKK00RzATHr3brT
	epLdqizsmiSsU4+t+0MuUFeiEZiPeHSbaEz7S967OHkjCY2hA1ARZCqeP/Arx17s
	i7LOdVGsvW5ya8VoDy02yQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1d9xj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeBOa006867;
	Mon, 27 Jul 2026 14:43:07 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010042.outbound.protection.outlook.com [52.101.46.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhehaw70-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HGYre0Nso7RS1HddiN4HB3CrsIzTRuPG7FZqs8ECBwaQq41IMX/2O/y8wTMUkbAZQ8Z70zvwfiNhJtTQud0OHo73L630pxMneeZ/CdmOaAST7v4NWeP7V92PbIRfXpg7puoqruCvMSMaN9sM6U/sdicbKq9RqqU0dUJRPnvS/dFX0C4TXncFRwGs+EOO1MnW90HhFPIPLSuoMaAislyI3e/rlYh/LXNPOin12UdlUep42ltD3mhur8Zj8qpcwX8ZqoiXmujTRvOjRd/BCnDcQ4EIzWotI5UIU40y0mAw27gUkwvDgbuJosBL+a8duJdJAzVBYc9qC9VPR98FkrNYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVZqkxv9x6COE+vV6uYvjMhiWU8gyAKnGQ9OzC4QRWU=;
 b=jVybM93KtQyRQ1mPXcwTk1L6hy5eAXMzJ5Uf46PGvgbswFjZFO9XklUoD3Y4SloPSNIYvBEpj+jJHEzpw84Sgejtwaopd9O7/hZ4TxQASuoPgMJenKLuZfG3S0Xdi02QXhOyFk+9A5qniqaRctcKE5mnye37Eub5UczOYHDanexUt5kMSAxTTmYEUQBu26DBCFUIHQ+OdNOAFHLpKeF7YH5l9VIvdCfQNO63Bwow4oDlWzhTmcBM2YuDTHdpOENxG/bPSoqvg9T0D+MvTYdw+5X31lOPc0JISpzFzFHBQLG9aL9u1MafWqwr5ohR/3BnkUkWMnt07zoQqddI71yzBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVZqkxv9x6COE+vV6uYvjMhiWU8gyAKnGQ9OzC4QRWU=;
 b=FlZCCyajHNbGElrgJtw+YTOjWNG7khf7VK9SpWDFIHcZdesT70f9HkBBAxJNgvoNGFU5lUtItf/2EOiWliHtWcmuUva9W+YIXt2Tfm5I6vAfJdvLX4FR4vsM5z08ihNtj9R0XWyO0T1/34SBGdrU5bfXANHqEQ1+oLwLqQ6NBp8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:04 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:04 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 06/27] libmultipath: Add delayed removal support
Date: Mon, 27 Jul 2026 14:42:13 +0000
Message-ID: <20260727144234.3802948-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:610:5b::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 37eeb94d-7113-4e75-ab0c-08deebed5d84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LIdRltEzEYUKOIclUOZbdRObGmGbT2uYBdoefsgDQ0koUwYx5FtJLfTVmomPnobbRMlCtlpvr+7P+W83hmNqop7uWdvU3MT7I1SPmu7cMtf5wqUWnh/N2Z27hXbQHZgjCXK5V0dxAwcw2mmvJPzYUufBlX61Oe/OvaFDkVoUEc39vsZxkROTjwpP9FFgaznWSFUrAl+ozwRQmohPEvhIpIg5NpfhJJzDB1b+ZU/utyq+WG2ZLiwv1Q9lM61dRmbxSoxw3Qjww9+g3sWb5U4HM7uy379pW39UInrA1NmIm4x4zC0+I3vwm2IHM36QGxPochDjO8r7XAeMgdIlvVIvHFxgQUAEjf4Tq5Lqp9CcCyLHOQpglmhBPMoPj5EBxL6Z9AF/XvbCIBoPbo1wlGQn6Gtbw1bDiEvSvZ1WqWr/QrgJW3UvAOxS3y2E9otLVSCqRsL11RyAQgxfyrKbktzoNwf2gTLxm6giKg/nmoYw+7G1iIjzWxKY/BSNKJpU9LyWG3i7Rxhfq1njvxLlvfdNy2eH+qvPeDEVEn/4y+VYQE8xnPm9lKFkWAcdYAFqvcBfBTZiFgkaB8OwEe71AWdQLxr/b41hR1xdezHW+QuKi7caQ0O6h9aAFK68n7VaVTjmffu2jqxqfcSV4LUkPYb9sYia2Nd4zP6EkCR5I782PG0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R69LgACGD9HxOYorUucOme33mCO8+p9RQxyy5mMjWE4D1kC5GLnPUu+n4pLt?=
 =?us-ascii?Q?6v4k+Yi5HMmwrdTWB2LwCbBlC7O4Ps8dMzJShnhJDgVLRgYmjX5ntm9VeGyS?=
 =?us-ascii?Q?+4SIgjjE6Rj8CxDKKQFZrgpXUgA7UZy8o095xUh532mnoF/vF0oEcNErFwNK?=
 =?us-ascii?Q?TEE4GIZlBvdoVr5vrtbO8Bpzlef/gM2ul/qhc4w7dCZx6LRmswK3OCTAN7pf?=
 =?us-ascii?Q?Dj90zvmwCKlc74CeSP+IPccns6hLSYHl5q4hCdjahp+HCsFk1oWBqb1mtk9V?=
 =?us-ascii?Q?0Lg7Ii9lRqrZEVgdtkWRepU4EFkg6t5PmRNhipq/TSyh3hjGWUSPrNVOHbWa?=
 =?us-ascii?Q?L+h78PBzb9JWdtH1kRLMP5kBD67zqV0MBPK8jkiTsrKJijn03TBJyZZR/GZK?=
 =?us-ascii?Q?mKFSQHX8FKtmONublN+8e11q3Z6r19lLSNjLAWjs/fhjEbD4in84Nzo58lRN?=
 =?us-ascii?Q?yHMuXNXCOM1G0MoCjgxuJww8V5//oCCYbpTc9fFUHYtNXVkktcB7Vy/jVEU1?=
 =?us-ascii?Q?jg7MDwgJx72NB4yl6DAM5oL810dkrMGtojFq6i+yO01LS69SkqKs8n5Jo6ln?=
 =?us-ascii?Q?efg8N0qdVPptv7dUOlZFL52GVTDnKT0CBAgv9xj2SFFBvzkTv9PLoM1V4J7X?=
 =?us-ascii?Q?Q72Di8Peof2T66pYAAUl3TOHnVIylalx0B2lSI/UfmnTjGHngVy5tBldtEha?=
 =?us-ascii?Q?ygVddRIqIu8SG6dNe16V9h4ujP2y0YRmhipzLyAGXcDlHqJUB0QcbW0es4+7?=
 =?us-ascii?Q?wNb1uC8QyRoSDo9xmbF/dgNIfCNjP/i8YcqlB8Ic2fISqEcO82pvxvVhiR6C?=
 =?us-ascii?Q?t5t/EJrSYB7w65G45tEwyozgb1v0jzqDzccuSfcFsLdYNxK6R//mlfL606yd?=
 =?us-ascii?Q?93KthD2woONE9kvMAnAmHyq6Dcs9dXGrHyekBGQpdoShzb5PaMpk63Z1lauP?=
 =?us-ascii?Q?iXaVCUWVL2YXWxi9uuJf3QJeJikSZqYkK1LL2jpduzD71Jr3lqRXBgLDSTvE?=
 =?us-ascii?Q?PqY1u5szkz1/DjMkvEJL0tkIptyF4wujUyy775uNkQFFEJOyXvpnAGcJai/i?=
 =?us-ascii?Q?qx9A9AjX+lTeEsZ4w+wEEbixyw0KvbUOEPODe4bZev5lR5IYag1j0B1rnhDG?=
 =?us-ascii?Q?mWdchx9bbFhRv1tFJhjAs3grP6b7C5sMZ17Tr3kbWlRc4o8Gkt7qXZP6X4/a?=
 =?us-ascii?Q?EyPzewtNgrsm5Bm0AB8UCaT74tF9VMCcdw7aON00f6f0MeHb3l5mEIpf2qUv?=
 =?us-ascii?Q?Wa0QB3NTKStnv1UpON97p5w6FnTjwMheR/nKZmF9ZvVp4l1VjUHfTvEYttnM?=
 =?us-ascii?Q?aBaFz4h+8lA45Ma93m3H5Xv8ifFm2CT3Ni4lmOSjv4vHsCRsHYciExZ6uhBf?=
 =?us-ascii?Q?AHdOMsSWxf2dsjTuVsckPQ6maGBEwAJj4A1bQWqs6befOvSUO9qVn3bAyCGg?=
 =?us-ascii?Q?KgNCvWTFWdLSOEW2c+euCQK/9Kgpd+l0lr+XOAzitf5CUgUTnEq1KuSr4eQp?=
 =?us-ascii?Q?HE+4oUmPrCwK6r9rlDRlljoNEZgsCNC5iPSUsLWlM+nUjXB6gBatacYHCM8o?=
 =?us-ascii?Q?cQS86ZvTliy1m9MXwIthDPXoSGdLJBbmvkOT97CDsD2Ru3Boje7FVUqFNCzB?=
 =?us-ascii?Q?eyz8XwrU0d5iFvdOugdCwq4QwagUMuJ78Zo5bRq8g1U43R+lVBM28QfZY1X8?=
 =?us-ascii?Q?ZnW0JPkwY5OITrTPmtmZVDlmBBXJutWaJhWptbqle/jvjaLkcmhFUrgY/dYv?=
 =?us-ascii?Q?uxGkGMKAv+1eGruNHFPBRaWFLkgEWpk=3D?=
X-Exchange-RoutingPolicyChecked:
	Etf/qPphsEnaq28SvNZPuyxwW0wWZx+2ILjJhy3MSLsf+hQgTEXs65FKOomos1IFRIp7ceVONunN6g3YPbI7TwCQIO8o7+TmZ9M0Qsju8w3MlwAf88wHwkzVRiiTSGY8haAjRt8q5Bsl7bG6ncud/gEkgHy8JvqlgcFDXIT+o8C4il9UmIstqtQz/IEEBC/P5uF92NaDYGxTK2Z8JEtRZme6kUKMyfVE+etlbDcKQFZWtxXvqR2sJmI+U3B058Eb9V/qSF36J53Cq0giA0PFwhjCSAd2Vc0UWzw8QhfgeRoE0XrgcdRa1fpxO594h+VZxzWUFwPQfptg0xPiQisRdQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Rv3hbxdRxBeeehHx73WqI4y5rLEs0l3F9j+LhDL2J7Dz7WGAntQ61HowJzaB0b219oWKRRmHMJVN/G1XDaLPs3s3s5Ern+1Ip5Wpp58y8LVmn1K7h0KZuo6OGLu6yl7GJlUOIo9i/YHJEu+4UkleuHwIhcqkFZmif2ZUfMSwrjzmboXnCCG/uKDp0QWHuYDOC09ur52kxsjjKND+0M4A3q/2clzMZ7dxu0HLjNphj8hsBQbjaxuxGUmPYI17nhAJKmMRigD/8Ov9QhSE6WTLswLV+vCNGIonEh0qwWHbForuFustM8EGkI9xG+IW8DS1IQjVOhpItH9wjWHXWf51w56zeXPb160wNgHAZfH7ho4dp3etraLhS8OowNEiVuFaDfKHUUEd2ibTz+pRTsKYHqXq5DIMTysEmhY1AN94upFrFreXKP4hZ8crMnegu0F5uVXZvi428rFCWkoaaB0a1mJ9oTUtXq/J2iRf6OM+8P/xsrS9ldYFfLgOF5yGcA/cL1q9W2YbXCVsyt8XwhwxVr8zXWy3ctaDjR8y3JNry8mNMyq9H9DecQkZZ8VrvYJ920qsT7U/bwqlE8LXPIvxU9Ly1kdDYKXOB/6FfCPZ6fc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37eeb94d-7113-4e75-ab0c-08deebed5d84
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:04.3031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ArTG4g/5Gq1o46YM/EMqJma/+eBCZwq9RTtFhEOlgs77IlcQ0+D5wBhaYsOVOcmQDtU3O4fO+JiK8mpl6syzEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-GUID: 8A6ZYswW2y4nTlXvcaHOpLV4KPfH5dp4
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a676e7c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=BfxcaXdt0Lgmg1IeN-8A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfXxbNhKvteRS5k
 /LiNQnzPmKL2YEekGrZc9Iuo4bLsvzzgyGElpe+mvelkj0lPeOc9EC/dW3BOxliXpNb1YAXuwGW
 aL6nrNwEtYCMGFyrlLMx5RaTtB8fLF/DW7psaQvSUpYKruF+dGa6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX83WUYdP1+TBH
 r+h52nmnmOA1sczCjrCUXJWO9E8lIO4VQTAHtDMkcz07kYztb5kFA8Ek6P/vqGhMAWQzlj5KtH/
 YnVHIv7R33oT+s2uX2U1iXtPZtHw0CAor6Emt2DNXlqx4V8wDuftidThTuFpJj0Y98zAIzq/OUz
 VGeL4+4koum3x4VqdCRvzxB0MQYD5YZ+KZZ3H8Pr+fNk1d41nrGOfQAvlRn2CsROpHpbPv4t/FE
 xEJW7a4+B9C1AA6b/5IGdxOePdChzcDc5qyialX4pg6S5INf8c/qmzFBiZ6mt1C69CfhipvE1Jm
 e/kBd+crVtcKk7IJ2Z4JBAU6mdlhxxX3YroUSrnYo/i/lVMvO72Zh/jd4vbBgeDmpuaw9QTMBek
 DZs3Vu1ZUjrygshcKY3B5kgJlT+Lk7R4v2oD1IkbkDxLKd/2TACYxOg9wD75zOHTqIHiwIZNKeN
 UIkerawBdFM+07+1LXg==
X-Proofpoint-ORIG-GUID: 8A6ZYswW2y4nTlXvcaHOpLV4KPfH5dp4

From: John Garry <john.garry@linux.dev>

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 92 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 033ee8d54bbe9..66b6ad9c2219a 100644
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
@@ -111,6 +117,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
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
@@ -126,6 +137,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
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
index f70049b6cede9..ede06e5e901c8 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -65,6 +65,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
 
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
@@ -338,7 +341,17 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
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
@@ -480,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
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
+		unsigned long delay = mpath_head->delayed_removal_secs * HZ;
+
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
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
@@ -525,6 +571,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -568,6 +617,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
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
+	unsigned int sec;
+	ssize_t ret;
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

