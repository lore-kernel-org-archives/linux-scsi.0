Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92AC238171;
	Wed, 10 Sep 2025 02:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757471562; cv=fail; b=lH4IkKjzhPzyYnHTwiueATCXATCAP3s2LcFVq0joX75e1BHHLxK/orp/O2nIuaWmEsdFDeRoac8fpBq+9zU1aP2XdgLyccM3wBO7H1IagRn1s8cx0O5oc6ECRs7hoJ9oslfikJoJVsm09BxDXBEzhNPPqm/tvMp4aCKc+2qEfTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757471562; c=relaxed/simple;
	bh=OR1WotpxaaAdHCke/e6e95xnkM0sP+uZUuOGBEbKqiU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=LFT9G+95uQ7IdjWh8+kXLHtzMs02pQW+YOqMCOSDTMqBKQ4qszZJF4C0mjmh9k8biF2a6N0Ms20nO1LuL79ZgTbk1yeNf15u2AV1AqYraTJXBoDXAd2xroejS+UDnfNOiZ78K5hBFIvvO4m0rl4ipo7k+cZ0IyaWV6w8zh4c7Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BR3wuSx4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lC7tJbEO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BR3wuSx4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lC7tJbEO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0Ynq004919;
	Wed, 10 Sep 2025 02:32:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tJRd+IoVo6OmK0Yf1K
	9XN0E9V6n8ECTpA6sNnVe4BG8=; b=BR3wuSx4ql/s6MA/Ua09c3kI7xoinPrKND
	lxnTQ4WJALDi3WZv/i1SHceeska7WqoXJZGu8QSXHJE0SnQa2suOH2bFypM/40ji
	SIuMAuLmpyxUffLg6om+b1YQc/EvWwgz4pp23H4DG5m4TGSEGXQG0iGZN0E6xJ8U
	yFJmnNN/XFD5QG5APOv62mkoBw1RZ523Kw6U5Rk69jePjAroZOH86dps07JADqgC
	VYQfIQ1zVVFVtvRT0/3mg2FKxC1mvJW/CoHChSvumP7YKe5RD7bHeS/wg4bBLKfk
	VShogcdr+X6KXk1yPxqaQ2SCIjx/v9bGZ81i4j8iQvaEE+/mukmA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shu1x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:32:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A1LNUZ038740;
	Wed, 10 Sep 2025 02:32:31 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadn63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 02:32:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=szeG5IORQ8dmoIp0TFf+oJR0SXZPq4AyMBZk7M0MncjtkqBdVUo8J87c7+d1lelBdeeV+T+haAkVyOpoSo+mqf3ZOEgqEhPHTU2Ra212Dzli4pMV37YBbyYl0ee+uLDsWbygicn2sJpCxs7EclvsDL27m8jIZItuSgY7rTnPsEsRasceKld0m0Qi69pBv+rNs/t4de4sF0/znbT9WL/y53FgyDFM5k2X6yJJyy05By/heHTgIGAy+ABhjiTRA54UulojXCwfZWdEt9oFV0RwUrK6oVGydMIfdGA2MQ8cUHyp6A6wiKI6MHJlKHwCw/1kgvDvpgiDk8xkWxphx7KgDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJRd+IoVo6OmK0Yf1K9XN0E9V6n8ECTpA6sNnVe4BG8=;
 b=IBPy9lKGkvj3LjDr4RUv+JyyCNsudIR+lwgbevy32WLloPbtPArUlMxoPQK9ki5Y9KyDzmA7tixDZYBPp6JSDsMO3VaP7dsvSCUf6IiPTnq9O3M1hcFev17MJ/hZVzt8CmMr0220js+7E9TPaZVMzi7Rywqc5UQIZl8SyUrNRN+Hl3iF9ornih2F1LgAahVnLfGzU7D09sb9+bWVrh33p5QQIoCNMk6yb/yfWHS56NntYe+vOScZo9JUhOsCiX890fmgER8bRYd81pIEiYCDbSihwIkWX5xw7K1PBAKhkTkgJD0Q8p6i7cjLqW/XvKYVwbAKyKTOtWt2A8XTprouvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJRd+IoVo6OmK0Yf1K9XN0E9V6n8ECTpA6sNnVe4BG8=;
 b=lC7tJbEOfF+Z/zczrafdGHTG1S4UO5F0++NCG7gVqxBlg+TU4pC4S1sz9qSKwPLtVZKldU4QOSlec2TCCzPqqUvBU/4XQiBsuKDt9K5svTPLw/Urq4SDxLsQysInVnKk33Aeg6HFYUCdeTtCrXGeYkfyUcf/qVI5cxmK7TBi3GQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6864.namprd10.prod.outlook.com (2603:10b6:8:103::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 02:32:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 02:32:23 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: Replace kzalloc() + copy_from_user()
 with memdup_user_nul()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250905103144.423722-3-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Fri, 5 Sep 2025 12:31:45 +0200")
Organization: Oracle Corporation
Message-ID: <yq1qzwf597c.fsf@ca-mkp.ca.oracle.com>
References: <20250905103144.423722-3-thorsten.blum@linux.dev>
Date: Tue, 09 Sep 2025 22:32:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0015.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: b435a9c0-0db1-452c-d003-08ddf012464c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kNfugKVfwSH7mGqPjqsk90xr6SG0icCLfT/eF7ILCELRAbOkqyyhhQdA+P3G?=
 =?us-ascii?Q?DM6UXcHnVhXAt3gXltGov0mxXLlOlL7OSHbMrJIAKX66fF845vfR9OqCirNP?=
 =?us-ascii?Q?TyOXpfUATNrFCyk/a9dzHJk0ZBg/mj4Rno4QB7t10oxVkQddH4373gJDACw8?=
 =?us-ascii?Q?vpEW8nYjnzHhJAPB0awNfnD20fgbFA0EaGe7rcuDwy9GSSEmWUDNm3teWIIr?=
 =?us-ascii?Q?Myehig6uoe5VJHKLhy36sRsqmflV1l3JKcwZvlrXWbPBjVjL+DI5nWky1AME?=
 =?us-ascii?Q?xmKyYfaa6zFjDVeBuj6jviG91rR+LLD2kyrPOUbvf0MgxdqH619Ns01/H7JV?=
 =?us-ascii?Q?LFC2c3+x/XTHsVnYAhpCA7DP8I/AYUiyLIMtC7TP5NLkWF+x7yEJI5ojCh1v?=
 =?us-ascii?Q?AabnKzfHMTUbUYIR1IBGZOyWlWo1evU2/wT1nHoUJ9S7DIL7BniwnPjgz6wt?=
 =?us-ascii?Q?diwJjfJfz4B3kfkqPVqAEBnTGxKw8Q9fZqipu6ZUO7MQD30g0J2ni7omMGuk?=
 =?us-ascii?Q?H1hB+s1pCVujrrAnii3uic7+yr7LBi2QvsNoIjqt8xYJ109QAXD/SZRNAHig?=
 =?us-ascii?Q?dNzUqVK6/UpmICebpdZ0sd+Nnvu/N+hraxDe7vh1W25FlaZ42Yy5ZqiGicaN?=
 =?us-ascii?Q?dWf+tBpGn8vWMGRM/yHSlmuYzKieUAzHNLYADWFydK3kKdDZNaCaNwa3uzZ6?=
 =?us-ascii?Q?/mR28ABhlXnOccWYqHovjJboNA63PijDDf4ZtJj8duXLUo0hZXDzEBeT7RFr?=
 =?us-ascii?Q?JjuOIdCLZV08O5vUY5JEuOfcp2nx9P2bk1KrWpg9dj5l+oNSbiiBNHUcURE+?=
 =?us-ascii?Q?zubXpdjJzAtZwo7t8NESlOQtSCTnjlZ5HcuOKXWUHn+DajFevbh8CesfzP9B?=
 =?us-ascii?Q?kV9ESBzlHFXqV3R05KTRxX63glRZcgpEaKca8IYuGvBPRMCDogJ98gLbEfGX?=
 =?us-ascii?Q?eY8t41wfvM8H9ejEHx7ObA6U38+BjfnArUz3flrfskVpxcGqrsaExtrJ8RH4?=
 =?us-ascii?Q?y3IceE5TSCzS62AYanh0EsFxBkdLaCRypvVMPmT8Lw2XRWwjS4asI8ol9/am?=
 =?us-ascii?Q?fU/PcMTtVKSqI8hOZ8AqjmOSyj9IhM5/UC5DT2rrm7qL9/PD/ZfyoNyQWlGy?=
 =?us-ascii?Q?lAMtUu3RbIE7r5r2Ia62/TN6A4niNKp3+BCtB3fejC2M1k1zlX59AuFGlKfj?=
 =?us-ascii?Q?z1gvz3gigi24A8SJqN/hmT2cCurHaSQm2lDCmVikAur4iBucSRuejN1/bs9a?=
 =?us-ascii?Q?ED9MKLiYxphqaEAFjn8XufB15pTF0U06IOaLejKrfk79n/NTf1YpylCiTnTZ?=
 =?us-ascii?Q?RrqQd8NFut20jTVYdD0Cjs8kpQFCKkZyH0YSCdZ9V6vP+7Cu+rslNe5c3Xhv?=
 =?us-ascii?Q?0TcebpjKzOrB2jWwFouwsSQwQCs8iOY70LAEJWdCaCYnM2f19AAts0eCSi4I?=
 =?us-ascii?Q?8H7hK9PIhXs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QHgmwsdhE6ZJWkwS9jGhSY8WLWB81vUotWAWeyIATGlHY7j753QkQXdGERU2?=
 =?us-ascii?Q?l+K+pi00nTVe+o3DzyP0lHiaYP4oeaQotdDB1MuJhejh34Bbvsgob+eJLfTr?=
 =?us-ascii?Q?onfDXwxRyow1kxJHs1ySP/9t1+luBX5J+/RkI59NE7DIJ2C6XDNHj7osGqrr?=
 =?us-ascii?Q?pkBZ+rYPBLf4bj+OZY9iiKQlQxZlQbUwEevOoNhKBM/uIYfY/d64Gh0EFQZE?=
 =?us-ascii?Q?EtnzXP6DrNII/3ircRYkWd/aMBKPDnYn2+U2sCvf+s7ZKxpZ47D4feZG9PAq?=
 =?us-ascii?Q?yYzn52leLfGa96KZUDV428y++su4EMCh99Afx9MIkzbcONTSfi8by6qFE+wp?=
 =?us-ascii?Q?dAT8DT8/0LLQIEG6k4SJtEFzcMG1QkUyZRm2Y3xsO7RlsIf9sGztUCfRxT0+?=
 =?us-ascii?Q?LVIrzRK0DFlrgtFQOVnjyl+HbCGNN9MGelYruR2XD8HOs2P8yA4LWKY4SpoB?=
 =?us-ascii?Q?9fZck89DjKJSwDUaPXlT01Gc7ohdu044D5xrZ55uTpyeRCG+A0NrnNzQxfw8?=
 =?us-ascii?Q?ZRz/ore9A+uQDk75PVbcvOyL3Lr3O2Y9y4YxpaptQNyP2s8wwbBMtRf2eMDi?=
 =?us-ascii?Q?a1KGlDed2MxUV7Xjdmx5Qd+FDLm1IlwnUUsuPuM3rVwT2QCe8LqnDzT9FXnA?=
 =?us-ascii?Q?rhHdUlO8AbsV91N3+DpS2I2cR0wAVqvwu208yAyAc/0mH2iwRn2AGy1GtsAw?=
 =?us-ascii?Q?iWB4EIX65+ftp29Ba4yyOhNe4uQYIUQIVBe9zzdsfrx02uktbWlN8o8tI8sX?=
 =?us-ascii?Q?nFnN0WivSDQHhbyPw3JYA8S9mj9DszffgwH1fo8i6Tlc9Yf87BCmkM4M1c/9?=
 =?us-ascii?Q?lyQwDk2MdNTkul84NX3Flg035kHewUNCwoG2isZoqgp8aKMPKaXx54S9tZcB?=
 =?us-ascii?Q?XnR1NDn4Cp0tkD47kAwcoq/uiF7noa7822IG4Fxo+XTLUM6/Z38KMq3ozxgc?=
 =?us-ascii?Q?I9BdqhU5RmiLO61qSj+iFt1XAGhIHBnicgSWfIPQLCzAfkncUxhfqDOzW9tz?=
 =?us-ascii?Q?+FQqRk7YkW1KOS15nqu0Xnc73sa1F8nRlK5+eFXJTZE+3Z48DGDU4RHD5gMp?=
 =?us-ascii?Q?RdzPL14Qf7Xe13zaygPRw+NZsInOTqH5uMmcTvWn1o4uFVe4tCEKWeNtbSbL?=
 =?us-ascii?Q?it3h3DUgFRhkGYQSyCDasjW7PQH+cmikjQ7Wc0eJs7D8DctW7DebvRlVxxJo?=
 =?us-ascii?Q?iPbnQKpEnLhBrYIQ3w/oaWywHZzeQVs7SSGdoUqk8bcak2fHHw67HgfhnJkL?=
 =?us-ascii?Q?E1oUDBXsw5qsuDIc1BTofpkuZERwGcfENxK8LYtiVo6o5QIeAPhkmzX2+SS/?=
 =?us-ascii?Q?p4TfvkCkRHkNhvsfnMIaAHm/rFmO0P+xTSHsz4uirfq7LrDO/6sRF4VAAET1?=
 =?us-ascii?Q?lEtxKuNFzNwId50WJ8LnVCFrUQZ/Am6nc6X+JfR1VMu+qcs5LlcMuoDWHQtv?=
 =?us-ascii?Q?4maHerGWRTTx+5t2B12olWn/JKqmbjNjjY4k8jnFtFxihpJbV2cHcSVZdb5j?=
 =?us-ascii?Q?2JF3pKDQiKCIaYeOF447ZF2f8sKSUPBPmy1+Ry5wiaCIMeMCjNqmhhUtdn0h?=
 =?us-ascii?Q?/YW/p4Q4aybAaSA+5Ut0Et4jx1Bohh1XeRGS1LJU3R+0u6dBFDzC3hL0G6V5?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+4bEhW++FJJp7mIGqfarSA1u5msjtfjWPGAGZdkFG8OukCpqgh6zuUvAKmy4f7XQnSioiVyBxsttYirPSNaBSGE9Du5w+JALye844ftDFRL+rZWWK3+y5iVFDqq9RiTjVCRvm38mTOSSSacvJR2Ct600+Mv8NTDUc0reu/5+iLPHD6FNeWTlc9GKkpf8ahg4/agTdCp3E+iT2JVJCPwyTU5J7vFFqsSdjoKKXVbfx3QBfTAYlO9tX0yTd6RHvnv7UJW4ubVTPmDWZoSkB+UacOHimcBFp0xO0MbT77TAntNdUQRMn1IRlFDanDDLYH0UkQaJTu9+RhpZwrGL1ipS5z4CXXJzGKt8K5J6g+ky/K5c9GQP/8BvLnPbAS8/j4AgQI268XG9YmMibahu7Ti+gQEJF2Yo0vgHu2pv+lJ6Fv5LW8RKv7/rMjdq3vb/yNREmHKdOflOoKzb4Sj9dRxjbVY4SYe5+lJ3/zy0D7s+fK6tClXnW3LtTilrfbJbfzfKT+JmN2m8mSGhGIhbrY7Sg9JwxgdHiqxS4MeHacpWBT2BEBGUvKCccUJtfk4TxUoNC/TjzUUnkKDEfa5ZuWFLo9J/9SIKBtMJqSgKNOQXQBE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b435a9c0-0db1-452c-d003-08ddf012464c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 02:32:23.7123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdiN/lXqZYpeksOfKia2I7OJgP90Pl5IgQ8LfDqDhiaeURx2TBgDQqiYB8jkbPHLVdbzLkWY1EjCpzy/EVzjw91j2MbD7Kjw8sHqDNMcwtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=779 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100019
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c0e340 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX396ILyUn35ry
 fuJ9ydaca/rsjuZJpVilDy9uJaFbCSPUmP9U80ZIBV3yuOiIy1ckGnVdvVNEyXRFYjJAP5hLRvb
 nTKKWQToMNGElMy9Z7ln+vJ/LRKr9P7ZjcqjKenlvDOGnBZLw7jnMunYikZeJ/JsaRvPsyOlet/
 8A/8gOqBmVdpPE667PODXY+ul4iscGVx+vZYBZxOzjH0D7AuSkpbajl2N/hjHVOfoPYPff7PyUf
 a0B94pO6J6DSXSfF3RG9mToek3QdP7kcjWVNGtWFT4WktoF9rDmkrv0ManQHHQlvou5sp9Qu5gM
 zEJiDFoCD7uvQ2Ue/3rWxo/firJhxS2WqPnI3aPVCElJoMnP5xx+MpHLVCnImxOKw/+VjTxYBJv
 U8RZJ6PIMSMN9HsMWAY5jyXKwg2jpw==
X-Proofpoint-GUID: JK69DT4txcEt22BIgA-SMXomQkKscZu1
X-Proofpoint-ORIG-GUID: JK69DT4txcEt22BIgA-SMXomQkKscZu1


Thorsten,

> Replace kzalloc() followed by copy_from_user() with memdup_user_nul()
> to improve and simplify sdebug_error_write().

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
