Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A091CD0C;
	Tue,  5 Nov 2024 02:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730773898; cv=fail; b=JFir7s56LKrevaLnTOnSrSxZBFGIphcNfACTKfwV3NeJHbAL+7jR8EQY+Jydgl8bzk1f2EMZPyyHNu4N0/0/lTuXzpFr2eT2oDbd6mkfdO86sneEA0tC/G5Bc+crzArw4Z0LuseeBVO/bSoN8ez3G1vkAu/8V02M1b0GiTZ6BFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730773898; c=relaxed/simple;
	bh=zCm8HN9CCQKHWLLwW9uZl1KBUEykoDhHWq55oazdYXw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BlOPEiUg4Vow+5WC5imHWXWTDlr6ibmyzJf8USVaBTjCFhFYUQsizaFs3B07LuqiOMI1gqmNbtfC0rSdvBro6orPgaBBpN701iWsj6riapFdDFQvfz3HsBf2phBB29SF8lyGuXkepZAphDWS2AKLT0JvpFhkZ9ie5evz82t+jqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B9zxf7e0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EcZ2RWYT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B9zxf7e0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EcZ2RWYT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52MafU020596;
	Tue, 5 Nov 2024 02:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=mM7EJvbM/q86v/AVJt
	0Kar3fHEvyL6z9KJf8Gg5fv8c=; b=B9zxf7e0/2PfuYNXkr05Mu99OaR7AzSDUN
	yLOvBQHtzaPKoV+zOjMcNibLtl1HB8E6L57Um+JBzU/7cBJfQ9jTqvajvT2y8pwz
	WrLyDUbDSdT66gLtx2Z6baTM/oqpBuUBEu1fQMuvsygV7OCEKZKs3BEg48C7KdWS
	9+QOaBy4yMkRBDxzgB9K91KhJvjR3eeq7cEZO8U/HuwhUtNtQNRoEncId+Err/lC
	mWPgjzW2mHSmDzph/eDueW2rKPlXDa6EHRQccfk6Z4T5a8kf970oZ4qTFB0BdV+e
	Gh2qlRV47QwG5V57a9R/WjmadPbYEXWuWoKs3lZAzqzpHVikz5JQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nby8v7kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:31:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A4NtHo3039067;
	Tue, 5 Nov 2024 02:31:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2049.outbound.protection.outlook.com [104.47.58.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahcu8n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:31:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vgdhx7TxQ+yCf7U1UweXyDW+jJebm3XJ1ITiN6okx6l2hmjjrmD69wdAgbqrtSlzcnMzhrKVyhe9+KVaFnDqi9qOb1Umqvk3O3vedxPvxy/G91o4erW4dAHJ6WuUMDCGt94idNdOREbWshlne5eCBfr5HriHlpL7+5Jz/zYsN2p2UYy+VKGZBeZCmpH7SiQITft0PuZ+JWnZwjn0I2BpWDcSpoYn7bOh74q+kVlehtAh/SHdKJ81Y+FItxL5a59a+ndJu6AOxAzCos+VzjsjvvKXTAJ1w4HoptC/wtddXvr2f9xAl0HuMjkpQCGZ9h24jAGoGUUCkf5/z0l4G5jmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mM7EJvbM/q86v/AVJt0Kar3fHEvyL6z9KJf8Gg5fv8c=;
 b=b09Q/QoVpFyWxyVRRpR3pi2SdTuL3jK6PZdZ3gVA+H2bs5R8O9brQUmG+1vvCyVNUIMlpYMaNrw1A0g70F7RgVOEGd7vEhvutvViQ0jFi0ESAdZbnxx+kFsUyhRXJg+znz9Tli6OTbKS+lnNkjSYMQP0+7vIhXLlYLpks2lQsr4NKcxX2lNiSx0/RuFjjqXBGCzdnqVlib5Rpb8r5sAt1l9dLdMhj/d8ZrOwWG0ulYmj+xSxkVlBxoTncM29WNUppy+NRUtr51XPYzaA/YGeBx6NOUIGDG/axPuU3kU06mzLPCnWo6GRjT9Jz+yezuf0NKz/oOJ7H3Se5HEVYrNpdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mM7EJvbM/q86v/AVJt0Kar3fHEvyL6z9KJf8Gg5fv8c=;
 b=EcZ2RWYT++v46cVv7isN6hS2RpqsA1f0autMBbtyLlG1LQM7imF+wJNUVnFx9mrMBoHPy/geQMk182CNWawqAEodt64Lv0hDs1R9yu1yVTiDm5avPjVSFVV7gdsCMtTSOyvRJhO1SNhAKY9LChcgMyKjvyLmnXQx/fhvjD04COY=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ2PR10MB7736.namprd10.prod.outlook.com (2603:10b6:a03:574::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 02:31:14 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Tue, 5 Nov 2024
 02:31:13 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        Bean Huo <beanhuo@micron.com>, stable@vger.kernel.org,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang
 <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Maramaina Naresh
 <quic_mnaresh@quicinc.com>,
        Mike Bi <mikebi@micron.com>,
        Thomas
 =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Luca Porzio
 <lporzio@micron.com>
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241031212632.2799127-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 31 Oct 2024 14:26:24 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ttcm4dju.fsf@ca-mkp.ca.oracle.com>
References: <20241031212632.2799127-1-bvanassche@acm.org>
Date: Mon, 04 Nov 2024 21:31:12 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0514.namprd03.prod.outlook.com
 (2603:10b6:408:131::9) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ2PR10MB7736:EE_
X-MS-Office365-Filtering-Correlation-Id: 8860a40f-1fca-4edb-eada-08dcfd41eb09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EG7f4a8xdSNiKmwMVXCwiAfXw6+ed25yWgFRRFOUIpqDunNz8xVFWNBadYbN?=
 =?us-ascii?Q?5mXkflIpx1yLi2UMv8vVwFqKvdS4DfwOloMjM7yvY9D6lfVw/OLevVdOPVgE?=
 =?us-ascii?Q?PiNLS+zzYbZkcaifMPGyCmHUo76Paq/d6/FhC9chkkHsjmkCapn7EhkyDSAN?=
 =?us-ascii?Q?0DKqke5jUT+Rwkaa55FTWKeF4kl2Yb/lTbDSvT59K876OBHUQmxO4nczjkdG?=
 =?us-ascii?Q?XSAkXmWDQRJFkUoFoYSBHOn9V5ea9dOWSL9xNgIDq3tCKO/ucbH6e+SsGER0?=
 =?us-ascii?Q?PCjie1GZFXnNsnn/9kbMayvnPVDl3cVjO+QjsaWZvWPE9uLlfsqjiRKiKKxf?=
 =?us-ascii?Q?lrwOhUSnbxUfTyjxmvDZYbP/o2Z7pfgtZXike7pamn2cfrAaBHutTcVkiO04?=
 =?us-ascii?Q?jW+vrONbUgC60Cg5Ggi5/pjHPHA0SSa0jK2P++HjHRzYO0dQyV+ThOnSnGEw?=
 =?us-ascii?Q?5kFEiRQBZZYLZIzha0noZk1VE7j/MBuZICOrEqfY3NW5CBPAR7rOXnPnlQTC?=
 =?us-ascii?Q?v9JaiKxZGY9h0JUwdDMi6Of327MjMIHN1goNECu7VLZDLFpRqJzEx/L0KihB?=
 =?us-ascii?Q?8C6WiwPQ1RieGBwwNLZZ23g/uf97NAnplif3DM0eC+CStswloWIJeAhJHws3?=
 =?us-ascii?Q?0vt702Efx9SHOEaRheKyY7clYrk9XwKHtU8dqwvYhZQjor1j+JuIMuOMaPLQ?=
 =?us-ascii?Q?vjo11h6hCZNTE980yyw/OzeIxBkZPQNOhxvpyNf72vEfu6WLy+qIq+On0J89?=
 =?us-ascii?Q?LM0A5uFdn+nXv3ajeIsJub80eGHnUJ6Jt6zo95oh5mAPED6Q+reVV9d4R/P4?=
 =?us-ascii?Q?i4LuGKzPnq0fyzmR0zZAUNY33/YmWlEwRuQHSfrHgNjxOkQyDosqRL5lOvHn?=
 =?us-ascii?Q?Rf/DZtR7EfeTj9V6NuhEiyaEgdgnfMNu7bNg6DLVWLXU3YREX9r2mWhj3ZHp?=
 =?us-ascii?Q?YJGPedL+1CDdbJ0edahhQga79wqpt6DhE0OdzubyI5+qXkNPF9gli2D82nUD?=
 =?us-ascii?Q?n0bXm6xP8IQbxZXl++9EnAK3lIV7NW9tAufa9KXThb2zEhufbIp/OLAZBL/Z?=
 =?us-ascii?Q?C56irVeuTtHaiueVkncAuy6s/Ih7bz8ELSVDE4EttYVHJW4pNPKRbOt7NMvN?=
 =?us-ascii?Q?Ve8170+PckUT6uf0jDnKi/0ZDrStUAIpzNInj75ckWAgpSDBxY2OcW8sg8OM?=
 =?us-ascii?Q?JVpNPZbGVNEPp4QWZHnJbOZPOQQQhALWFfGQBa5o7HYyVaQREX8ZEzc6aaaG?=
 =?us-ascii?Q?DLqS8ciOXKnOcfJP0mg9CZVI50c/6UVDNV//uK4nX2/wr69HFkOQnRhyx3ED?=
 =?us-ascii?Q?Eis=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DXbeIq+N04/xtPK1dOW9/lYs+sR8ndVMywlmavZCUwyW5VZ4hyXPse50huRq?=
 =?us-ascii?Q?IFT0XPN1ZPmrim2tVJb4JJPPTvJXQuPWADxQFcLV3mp62ZvYtn+7ugT9vYM9?=
 =?us-ascii?Q?Avj91OrKxQYQ0SxN+Fj8oFsDeyGMeA1jP9QSjZzVFylOg86bFYhskZwwz5Mg?=
 =?us-ascii?Q?5cCtZxKYNmpjo9i5pDX9y0gCeH2oCnRwFIJQiaACh4DQLgni/oRAftj0UcOT?=
 =?us-ascii?Q?XhsS1rQxlqPPoakvihlsWJ9K32/J4nSnbImsPAdY2gTAvY5x5sg10nq+iPcG?=
 =?us-ascii?Q?zHp2nblCyAUTlf/uYPt9g7LE+sb17XmvODX1NQsdlcYQDMEPejdByyb17ezq?=
 =?us-ascii?Q?KSAWuZ6iTv5M8I3QdTpUACfSymKjJ65ym4tbsafZCPWB0bLA8IjOiznv+XRw?=
 =?us-ascii?Q?6Knq1QAgfONydPE6azF6eXPcArU5XPCW2KpBiZIQkcauJDk2xBRZi/bh6wCs?=
 =?us-ascii?Q?EPCswaE7s+K4UcdXmslo1hN5RaUtMqZ58+NzvfP81eAZpcJJfrnkGnm5Ugav?=
 =?us-ascii?Q?SG4WBpVSIkz5pU2eI5onV1qp/KN/JUk2Rv1/4dBvtmGFtRuqNqGnxzCoQ0fJ?=
 =?us-ascii?Q?b9EQJ/m639b1g4D82aHen7nXHkwbqxE4lS0NJMlXgUZpNcsk8IMP6GaxIOJd?=
 =?us-ascii?Q?3KP+bOFxSt0cPxqti0Knr2XFmuf3nptLDKkfHMMiaImvHHNuhZzdnwZqNlEI?=
 =?us-ascii?Q?VAH2HfIdxGYRETeMaURT84bO2IMFHosiVyhnqT2kyTPwa4tMq1QFTPO5q4En?=
 =?us-ascii?Q?0WVDVNlf1aSol/FxOXogzdG7qRvt3w6N+rquRu3DjFwx55tq1jT9WFkPrd8n?=
 =?us-ascii?Q?GbxUTZ9JmbD0cqjSWSq8Ts458iAiWeDoG9Cd3wDW+TcSM2IPgggr2hHcjkz/?=
 =?us-ascii?Q?NekHgcnh1bx0HWB+4z/vKbXD+K4O3Kp3PIGlC9oaRSAvqLmjFiUt861QIZQM?=
 =?us-ascii?Q?NfgNh6dJoJfay50q/ixsMK3aBVE8JR/Hg420hBgwIglXHH5idHYr1gICrkGv?=
 =?us-ascii?Q?S4L7nAQkwbdBJ1zd3IQC45SddU6Ypco43EJINip7/fCmBEWZIaKLR8uG6/hu?=
 =?us-ascii?Q?K2klN5HZI07aVWu7uOPM1EW4GNAD0q4P7MnBpzn+aH5nf2/gscRkWF2B40lU?=
 =?us-ascii?Q?0Qu2ckap7idlR1+Cgy+0MnxJrvcantz1bMlNXIgQUDr5cKKSXEuIxkS8EGEa?=
 =?us-ascii?Q?GXJnjQhE7LBMS0rSYFFpvNDXagpc65hnXTe4bwQPSmLuT9mDGe3Bg+hzIc5s?=
 =?us-ascii?Q?y0zxAkamMwbtLX+mjJf5IlbvYlltlzdYhzI3+4ugMKH2LH/SzDQX4pAyBHwv?=
 =?us-ascii?Q?E+4j1BJDUuF0i2jhQDqKmxnrcDnq5T1NJUj2Wjc4IUjuePTzELVEafzpFZ2T?=
 =?us-ascii?Q?7Ro5H7qpdIBgXrorQn4GIs0wU0jnKfRrSFxzWAeT/gkWEQkwITZB7jK64nk8?=
 =?us-ascii?Q?QGhJUH777pol2sb2Yd6ICZp+OIe/5SBeGOaeF6U0taAOVAiKdStD3WyyMg5I?=
 =?us-ascii?Q?w3nNibisnmsNNf+cH/FYkB7bLAFpyT5vsTsXTlUdm79Z7vK6kEI05ao6dkJi?=
 =?us-ascii?Q?7y7VwoMP1yXL/IazNozGAH+SbpgLjxacFAV/CY0rDlOsK+745B/cD3bZsAr4?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BdveUpaJ6Y08BHfW3fig9bbF868eQlGMBmfDyORkoYPclC/a0lutccKXaUr5qEo3QZmgiezbqFPvwsp24M8icitI+1ABGidTEAPNIS95y9lNuhXaTo7P5waw61GGck8mxc7G9rW1gQCFSGesdIvt3674nnwA4dXqICtjn0CK4xvIHD2rYdr0Fha/5KknQnaU28F8/ZNtzhNKGu6d4I8tyEky+fATgTzS+rLtUElIidqtkEUeCBAT/iLNK20RYALTOwh7jBKBG2onl903dO7zi093DUprXrP9QsIurftdWzbsjhMRUtN6M8zM5tQyqidg3suJnZdGu2rxs9f/wRmRpiZSuFsaz3FwYWD4focdGAuOhuQ01yG0FPaTkXAvtVqg0uhNETGuj19XFB+Y8V/lXvWkLt9LvO90O/xOySyFo7iXZT2FQ/V03ZtIFyLwax0JC6e7GFO2ndyLu7+dFDTVWhhF2Y0ZMhgIfCSxs4pWnmG+nagev1hXMmvTb3+rGVWNKg+PybBSam0v+qtM0wqUxlODlJeJG17x6y4KYvPXYAUjCbEAo/m/V7EJPkVdxilvfTsrQsCFk4XeyNZJJUA8z/nPe8Ny/tjnrNm5G/TOV9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8860a40f-1fca-4edb-eada-08dcfd41eb09
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 02:31:13.8747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wanJH2PE7FhJeycWVeqDw2pplY5LZ6sIP9/SQUbn8PUE942eAHgiL1dnXmFpyAUQGGC1jy2mVFeYq+MWZLcCO5c+Vs4RJtVL7ycuX8OT8Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 mlxlogscore=810 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411050018
X-Proofpoint-ORIG-GUID: 7vW6q0DKLEQhdAUfG6otgcwerh0c3F7d
X-Proofpoint-GUID: 7vW6q0DKLEQhdAUfG6otgcwerh0c3F7d


Bart,

> The RTC update work involves runtime resuming the UFS controller. Hence,
> only start the RTC update work after runtime power management in the UFS
> driver has been fully initialized. This patch fixes the following kernel
> crash:

Applied to 6.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
