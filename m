Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6994617623A;
	Tue,  3 Sep 2024 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725376127; cv=fail; b=aS8wO1w/5LbzmeaX/P6sZuuu/SsBGKgAGEGeRbsb/oo1xoM98pRuuiLOTl0pA02Y69ixrVW4GsZwst9mfVfZxWTOxkEeGO99x4zMAqBy9tNzYXGGk+hO0aQU/dkAexgSkJpsSpLDltt9yD0/qNSrjmCX6+ZumlGumK0VQahtyy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725376127; c=relaxed/simple;
	bh=fS3rovV3qIIbGZ/n8LdiGt/XBUJhlog66TshY1YkklQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NQQUu9V1eQGOPh1uCW2Rat9w8wpChVmZN8etNGcyPQKGIa+XJiPvDTVOAdA7khUAPPsbTnpObbsBQcWwJZmScMuYImOickv63VCisX/jcZOCsp41OQ4sl1D0U9UWHv6GG2s5HLTz3PWxvzME+RgWg/F42xSm9gs5sgEpMJukNP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fND1rqhG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Um6TFlI1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fND1rqhG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Um6TFlI1"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483EufpP016367;
	Tue, 3 Sep 2024 15:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=SdrjT84eVboeLkbGEN7I3Jq7kyAHgMQohJRPdaq+dUY=; b=
	fND1rqhG/KjT36vcuOemkgBHv7RYVdf79jP2lZ869VPGl7t+qVyG5lFySNjgKwMK
	al9b2oWjqPjsZE7DI1TBpEwXpNjhaE6vT+d6m1d6bAbklcLIpGK/a0T1HUMLmD7a
	+72HJBwd9msTY/VGvzfDMheGpt/ljP0XIYdym4TspjuonIvQR62a9vOAxUZGhPK2
	AaWBfCk/laCWCf6a9nUkb3pg2/pdqoNIpTqqMY2d41h62YDET9ECGUAa8VK406aO
	rY+z/bLCx/47p5k8/bHgoteNVatewUWz2Z2iHFTlZHH7m7T4aeTQyZtLWwaiA7z7
	P89dljJQs9JyL5h5MwkKuQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dvu794tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483Esjlq032636;
	Tue, 3 Sep 2024 15:08:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm9151j-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0QQeeq0pcFheASuxTN0B0M+wxxcVV9gWap0BDY721kjZbfpZrZU4jJS2WSti6I2cXK7ia0Y3rzgiZREV4UE+6oKg5xHYom2wZzDcEI5YwvWUZIjl7ixnBI0pbBWYXiNVWsBvr6JS49JL46WTtupwZWDSQ94LLNiLw7okXwcahS04d1z6i3NTHG2NmkBg7UH+SmlCwFsdJFVxdd4SOioxH7QCZzkRpTxls5D1gWyCWebd7EAwHl37ZtT3+0/majmA9QDSRNy0ccPjiHy0gBxQSebVk5IUjvO1h0Uvjp33KCmOS2wAcsI7t7xgGgSj6vs91puncT/IqFPOiSsW04alw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdrjT84eVboeLkbGEN7I3Jq7kyAHgMQohJRPdaq+dUY=;
 b=tddtmZQLBTXVCOuAwR7bUgq6AY1HJrZ4eQM4KXNGVFhvQufpEnfaSi9sZY4dha8aOA6Eow/ZtPCn0J3K+dM9TJwlRzBb3hE8Xk5+RA+CJA7fu1UGstUnWjk7cC7Eo7axp9DK6nDW4vEZ7hoMwKSqzoNXqNPHEh/OXNXYmGCAwUSzcj6iEOj36WUiaghu8gd+X84FJ9LHcjR4zU33ZjuDw42BnwZ96FyHFr3l9wAy2jjmYvJtIdNRkMBW30eZIQJOb03VfJ9D3zrVswcr/kYiPGXurjjuxe/DYQYdzih1LpafyqUsUX9TDq1/1f1zBcTpsktw504kOqMVrBKKB1XrOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdrjT84eVboeLkbGEN7I3Jq7kyAHgMQohJRPdaq+dUY=;
 b=Um6TFlI12vBjb3IKVhKmrJUXKHoQP89hkqQomUmldTlb/rnN4Apiwam+SQp8+iUhDkGHYKcRvzSwEM29FRce+Yu0HCr3l+AK0z16kZp+LSXN123n5Vb3PtR4hkLxIbyMfVv4WIDnaK9a/vFQQYTQzPhqnH9IDBudge3T4HNIe5U=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 15:08:17 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Tue, 3 Sep 2024
 15:08:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 2/4] block: Add BLK_FEAT_ATOMIC_WRITES flag
Date: Tue,  3 Sep 2024 15:07:46 +0000
Message-Id: <20240903150748.2179966-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240903150748.2179966-1-john.g.garry@oracle.com>
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0055.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::32) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b2a3d9b-82d7-43f8-f111-08dccc2a3d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?awf9bo+I670TtYQ5Gzf0X+eFurZKGxtXFJ9A41nctEFm4PCkcId8FicQLMNE?=
 =?us-ascii?Q?2Q35vvHz6msbqajhpU+ZIk8/YVT1PP+YEHMeBN8Pr2FcWIGy0QIl/QthQ8uf?=
 =?us-ascii?Q?yQ9L/ungWH//77RrYyzCP0d5zqdJpBXz+XZN7L0u3E6S00Z0MvNR+gFnHOQs?=
 =?us-ascii?Q?edyge+kJH8IBJMirKLaix81BEE62sxtyZk2UixSbVtgr6yTJVy0WUigRKelo?=
 =?us-ascii?Q?sOcZIBucdRNpXh3/bFa9mTVUG9x+WJNxSXRLbzSv6xfgcLBwdReobw5O3nOp?=
 =?us-ascii?Q?L6zEKpVk2Ef2LZuXbtMvMzPHGWwpxj36RPforXaMYSxp0CQQA2enEknajWdG?=
 =?us-ascii?Q?5ntSrJ9sL2XQPudq+RWLBN0SSTE8dqY7r+IJoGsbeU/iikOBFB+IJR5w3cMD?=
 =?us-ascii?Q?X27agmSB2nPYnNhr5w6BS/xrcBjin54SbhKWQyXs5hO6rkJvYeKNK9SWYvH4?=
 =?us-ascii?Q?MqCW3ybqCDEtxNbcSTgFKCdRq2vhqBqmnsv1wyv0fuLzcDBPqkZp5WG0T93p?=
 =?us-ascii?Q?X/IcgV+DEQNMkO0eUVMi69NH2j6jf+NNWrnW0kuuYfh2X4o1gnTcZfMzP+Ol?=
 =?us-ascii?Q?JRmWNYAmqL+9mXZuDqn+PwzpHSCxfS9K4w67inNhjIobu9Xkht7sknmyGrMD?=
 =?us-ascii?Q?bxuGHd2L6A+ddlC2FdbzuDnd6o2K8i5C35kKIAcH2tvqIu3KwFko1XhVihW1?=
 =?us-ascii?Q?DA3Z9Mj/HEhQOwsAJtdbSuIjl6aa7gBBhGCX21l3RKRxGc438VGIGpOG1Xjb?=
 =?us-ascii?Q?wQ1gl265X0NnRUmETgcMV+S1vXog3qweHBjwuh1fZvk7anrBC+oqk51UrzA2?=
 =?us-ascii?Q?r7hoU0StDa9lB5QcnYIpLnSLsM/22Nglqht/C1CdjV2xIytW8MvXdgDJuoe6?=
 =?us-ascii?Q?77EG5zA7NYjSX5auNZ5VtiCzxyMsjeG1x6wwwJJmSf63UXARKChKeyP41CgG?=
 =?us-ascii?Q?Cc5SP8pS2+IkR+rJ2r26b6IzlcOkMDns254xxccmKPhvYxxIVZUxbG/mBNLE?=
 =?us-ascii?Q?oTXwVF/BYjYuvViWrb8vRiv9Bjy2cI7o7NB+2Y8uuJp0EkSF5iJFxm+ztNLS?=
 =?us-ascii?Q?MXr4F+EZ3O1nda/rdHFVtl5izoqg7JbiJlzBqoomeL8mmhRTdoeNbFKxoARS?=
 =?us-ascii?Q?s/6TeA9CUFcJD0fLSpH9apXblahzXcN04zLQc/H1lsYi25hPPMtGMdgjP0Rs?=
 =?us-ascii?Q?S2OLZB3kgZAU7scSKMbiOJTts6pyGIxu1PFn8h9wEwIqbR25USxOm896sQBU?=
 =?us-ascii?Q?fuLXuLwS9JQdUEsjoA3fH8lef307qnBLVfCWHZpRhtZmUXZqnAasLLbhio+y?=
 =?us-ascii?Q?mNWcZBF/nfmcDje4XWn+UTcPb7huSf4iUtmmZJ5Q9GRVcA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F/y4pcc2+yGYxfprPNVJUZwkYfVr7mEd2zA4t/evgGyMMtBaz02jRpqu1XKH?=
 =?us-ascii?Q?3Aa/ahfR5CpYVgc6aXCNS2F3K80zB3uKQIlqzSJs/b7YsQiR5P9eBKAs5xgk?=
 =?us-ascii?Q?4gJKMPTopfjgjGuF6AOQAfpIt+S/yrkBrYUac2Yc5iT1NpJ8BVWBR3TW+Pdj?=
 =?us-ascii?Q?SmZ0keVfJSoj2eF1543oKV5WJPKjjenJct1DHQnmh1h6eOwzn+GGYshMLeYe?=
 =?us-ascii?Q?fbHfyClUpswvMMtfaKf0sx1/TatPbn0ON5E7h7TUfsQW7PE7/iLjdSwY4Um4?=
 =?us-ascii?Q?IcbRaxZSmPq0LISl+IkHxUN25mwVYiNPYS71crXeuRf6IO8/PP4TGuY2ez85?=
 =?us-ascii?Q?NWl0KnVEmAt/f7OKs+5Na2IlIl1zHs1XzyyvcPXLgHH9GeBjFfXUunQkP2D2?=
 =?us-ascii?Q?odtcymOefAjzVYQ/x9d8euVkfbnNNSB6UtMizubTtCsKPzLDWoX0MfQcvN+n?=
 =?us-ascii?Q?ALEb/CjyAy/iCK11qUL4IdMYuxWcKjxnEsULAR0t5+b/u2iagLRmAAjXvT6B?=
 =?us-ascii?Q?zGWp6Im8paW7FrRfAyHULkHSFQf3kAWK+R3GCBtwgk7Gve/wWCW6nPaHNC/U?=
 =?us-ascii?Q?xpQ/EcvFGZrb/94zkAE/Y+XYwfnphW48C+0p4FODXyMdHRr18HwTrTCXNFtu?=
 =?us-ascii?Q?BbkXWb32RwEfD+LjWtGoSq9OqDV7hVXe58F6G1Rjv1Yf/+2C2IJLQe697cfF?=
 =?us-ascii?Q?XwueA29AJYpXVHR1KAXWg/EgAM3zE8dJWKlDsSxZfMr1rZDQL+LcC0dMFncx?=
 =?us-ascii?Q?CTBngrnO1DKE/vgCs9ZQF5IndYq4yyhW23mJfds32R7t9LrjlHguSZyn1YdI?=
 =?us-ascii?Q?FGVpNefNiITGp6pRN85wcpHmoALR5/hXt4pCsfyOk0xFq6MB1ip5ayGS3VmJ?=
 =?us-ascii?Q?WRt4u/dIV1cRjjFLmxeqNwVZ+Psz8neoCBU1n3ic1/ssKQY2YDku/u/S9c/v?=
 =?us-ascii?Q?HdJ3ZYkLajjkkvGKZgFl+GtxFkpTy8Jfpn953C2jq4TUsFMTp5RbJMqNnd3G?=
 =?us-ascii?Q?z/LPdUL79maaUVvLNVdmq5xFYdqg8VTD+jTxIxhLgwB7Ya/cR6czGuCK9jq6?=
 =?us-ascii?Q?jF+kpMzUcUD5IJPdnmxFAzgRRcWGf9S1jRo+PEGrJ2oloeH77fL1gpxVrsn1?=
 =?us-ascii?Q?4qpxZY7rWlZtKKCkfyM/DEPtq8InqeyAW3zijnpGIJ+aNEbBp2tCuNmpfVqh?=
 =?us-ascii?Q?O4CTgpywGcpekt8azMb0LICAYZ2nxzGkkfOZTjRx0BcqezREoCDFeLFMqPgO?=
 =?us-ascii?Q?LEJN2puJdNkW8/tIX+j76pyGbsECQ8cpipeSyNZChbGw2XXlHpi0P6x6NiY/?=
 =?us-ascii?Q?ga+6huEeSXDCu10gqyPxse8XHVrbGEzyPutUZnilsos4X3CH8R3XwTJvmid5?=
 =?us-ascii?Q?f0oOVmwdFwXrUYu/znbVfX4cVflMLWhBkU/QQ/9OR0DitAh+AwPt6A9Kr//t?=
 =?us-ascii?Q?k0X/p8kuYrXxG4+grjRt+6kQoJ8ue7L/GqUsY1jOilXvpRmpQzqTX5fwgRMo?=
 =?us-ascii?Q?85Kzb3UBmv/5UUwWuiEURmyU/7PJuz1H6iBmzfMZx+dXh2Wgt4IuRhMX2g0u?=
 =?us-ascii?Q?7H2S3K2ojlL89EvY9Yh3r69+pfXcYo9VKi6yI7kbark/KupXuAaGoKJb+TD/?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qNLruL+PUdcRBqBqPFZCwtztdIrNgEUdeEZNDiDraCgjgttgymgaUy6H8LhsGz7+aTwAhQI3MOdaOicZ8Vc3eLFKowwocrA62f26KUMftDgPl6FuAgutexPfcLynocDFqAIuShcqpKxa6mnEH/wtkE2HnLM4s5OJNQGL7TXNjymv7drPQwsUfEkq0K0MfTrGrHCMHYZkP27KSRSXyPXQ4kbQg3yFCNuiEY9smAQh+naWV1VJKT9T2JROD//4mXdP6wC4ZRUIEtbS+0LrlLOIDDRQBfDKGLvpsFG3m4iEi3duQtMhLwQ/3BExRTULIqjQbi9u6yRQil3el76UxqJbpXu0yEcLxufHedO7ockjz7rfDhMyl2GzSH0YIV27TOXQN+xwgHCeto/oMOceofHA1kfeqtaSSpoquyAQ2JR8hdEN9mBKvf3/b4Kmqlc5BtGc6ERe5BDw0zDtSVtzNkgwXoCnRw2pseQxvB+dao3U3i5OhpBVwMCcgYCqltlvLkAWwoVpgm24lee2uMkomJQomOFousl94B0Oi4i6ECg0ebvUDplriqzFiyomn3hYrvXmMdeoxyPgYG0E8pioVQtkqxKCmNixCCqUnbCbzi1RU0w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2a3d9b-82d7-43f8-f111-08dccc2a3d9a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 15:08:17.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QR2fpq2T3caRVMwcaMac0+5VkWhnOLJeMc31j/WOge1PxNSVEvir4kFbwL4uTrFqoKPhncMyGCmCXdn580c9rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_02,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2409030123
X-Proofpoint-ORIG-GUID: 97I50RQALv0vZkBTcVNwY_-h_lhNQ7OS
X-Proofpoint-GUID: 97I50RQALv0vZkBTcVNwY_-h_lhNQ7OS

For stacking devices, not all underlying bottom devices may support atomic
writes, so a feature flag would be helpful in deciding whether the top
device may support atomic writes.

Furthermore, even if all bottom devices support atomic writes, a md/dm
personality may not.

Add flag BLK_FEAT_ATOMIC_WRITES to decide whether a block device supports
atomic writes.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c     |  3 ++-
 drivers/nvme/host/core.c |  3 +++
 drivers/scsi/sd.c        | 13 ++++++++++---
 include/linux/blkdev.h   |  3 +++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cd8a8eabc9a5..036e67f73116 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -176,7 +176,7 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
 	unsigned int boundary_sectors;
 
-	if (!lim->atomic_write_hw_max)
+	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES) || !lim->atomic_write_hw_max)
 		goto unsupported;
 
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
@@ -217,6 +217,7 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 	lim->atomic_write_boundary_sectors = 0;
 	lim->atomic_write_unit_min = 0;
 	lim->atomic_write_unit_max = 0;
+	lim->features &= ~BLK_FEAT_ATOMIC_WRITES;
 }
 
 /*
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0dc8bcc664f2..c70d8e7602bf 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1975,6 +1975,7 @@ static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
 	lim->atomic_write_hw_boundary = boundary;
 	lim->atomic_write_hw_unit_min = bs;
 	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
+	lim->features |= BLK_FEAT_ATOMIC_WRITES;
 }
 
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
@@ -2025,6 +2026,8 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 			atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
 
 		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
+	} else {
+		lim->features &= ~BLK_FEAT_ATOMIC_WRITES;
 	}
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9db86943d04c..aecd05165ee8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -948,7 +948,7 @@ static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
 
 	if ((!sdkp->max_atomic && !sdkp->max_atomic_with_boundary) ||
 	    sdkp->protection_type == T10_PI_TYPE2_PROTECTION)
-		return;
+		goto out_unsupported;
 
 	physical_block_size_sectors = sdkp->physical_block_size /
 					sdkp->device->sector_size;
@@ -988,15 +988,22 @@ static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
 
 	if (sdkp->atomic_alignment > 1) {
 		if (unit_min > 1 && unit_min % sdkp->atomic_alignment)
-			return;
+			goto out_unsupported;
 		if (unit_max > 1 && unit_max % sdkp->atomic_alignment)
-			return;
+			goto out_unsupported;
 	}
 
 	lim->atomic_write_hw_max = max_atomic * logical_block_size;
 	lim->atomic_write_hw_boundary = 0;
 	lim->atomic_write_hw_unit_min = unit_min * logical_block_size;
 	lim->atomic_write_hw_unit_max = unit_max * logical_block_size;
+
+	lim->features |= BLK_FEAT_ATOMIC_WRITES;
+	return;
+
+out_unsupported:
+	lim->features &= ~BLK_FEAT_ATOMIC_WRITES;
+	return;
 }
 
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index af8434e391fa..c8c6a496a6ed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -332,6 +332,9 @@ typedef unsigned int __bitwise blk_features_t;
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
 
+/* device supports atomic writes */
+#define BLK_FEAT_ATOMIC_WRITES		((__force blk_features_t)(1u << 16))
+
 /*
  * Flags automatically inherited when stacking limits.
  */
-- 
2.31.1

