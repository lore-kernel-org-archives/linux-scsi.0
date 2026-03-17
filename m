Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59763BD627;
	Tue, 17 Mar 2026 12:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749269; cv=fail; b=WXToUbPxgjgU1c/CWDwLi2l0YwHYBH5fmGM9KcI3h8vHjzLIowRePauonjUGoU1DWjUc446TmiDiijl496fC8QLhdttwmkv5cgZrxPHq8GpnrkjXZ4zGKi/hqS4zRgLBqWJ6jC4CK97RuRkIb6GayNdD1CG8X7Q54XT9b7Pg8oY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749269; c=relaxed/simple;
	bh=D6kRsgZnL8a5kX/23N3tVM7zPImbgWRuRCPfI8htioU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CAqF1HcVrM5CqxcKfjMrtAyuFePhQ3UvYiLaZTLXgR0azMy46AMj4tE+O7S71o/b4HRp7DDsZuFcWzWgKmZhbbhTafd5MLcE+Di8ntH9anMFhn31LhNHkNq2/Ch57xbSXVOld1PWQg2UzZ70AMkWeKg268pnMHB235XwnupWRTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XFpcG9Re; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J1mJ+srb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XFpcG9Re";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J1mJ+srb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GN7VTf3005786;
	Tue, 17 Mar 2026 12:07:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SUWSbEjEQ9FkkqYJYlK0nz6w3cgMcg89TTGXL4rTREM=; b=
	XFpcG9Reab62sMAyyRoQ0apZqYMB7cOy6G63uykys5kriD7f1bUBj3Dxdf/3wOxJ
	c/8HSc1AftNGUxTOavELZ47Cp78t4YdZnzDkAr/eI04rYNPS0q9lbBbVxYFpqEAJ
	qdcBm30zXgFsuuJ5yHoyVF6K6t3r2giXnm3lkcIt07uBr1BuzHboaUWeT2OSG09S
	FWST3dbU+71vd8DTjuwRFsrQebxSpqVt7PFlFSybv5mjPGghG9v26ac/6Tn6+hNm
	rdGMMJ1xkIseuIsvkNBwEZgZhFG4dZaIugKCnXhE8lm3MOgWBar+/46jACP5qIrw
	YbFdr7NO+XoSHpk3e4e6gQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbuy6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HBPCbC002699;
	Tue, 17 Mar 2026 12:07:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011035.outbound.protection.outlook.com [40.107.208.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4m7tkr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r9KUbLA+ijsqc6zCTLVoVEtLkMotMznbvUWHCGP9Tn/EfgFO4n5ZaoQfAyaZ2q1yirZjb1o+Az2fdTr/naqgRprRTcvUuYtsD+3ToNaH8O7ev9ReTPNL9PtV8Kdu+pzSVhUWDCrCBZFMXuLyXts3JfMP8EVNt61yEfnT9NfUUQe45zBC9XpFTDpy2+12ZeIV+qdP/0oBVNt3qDxKp8TmgVyHi97j3ZqeAFcPaYtm+KB+i+XPp2OGZcwSgwOh8IB+PTvz3g90ZE96oh7dxdFXn6oawYmo11Bl/2bWS6KRGY62W0J9GyVQgmFidXghnqXVe7PeO63QFOG4OFoe+bwCVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUWSbEjEQ9FkkqYJYlK0nz6w3cgMcg89TTGXL4rTREM=;
 b=PInaQEdu5al49jFJjhZWspUNrjRdNjX6ZQiO1j1qdCkj6leNNBPPKbqjwL11O24kva6s/OSGjSPzdXnyOj1lFfP+pwljknzTph6C4oInji1+XyKoUUsHwp0Sl4zY/f3EGJv6UuJyIAIbP18okC1w1I0j6tN+SIf8unm+TdF6ZGIrHEFpqP1BIhPnPs4unftiz+o0G9qPcaIVNv6NLZbsx14/6SFlBsWDDfm7nP6zKdXmAlB0ewVYtoEFB56RXCffotMcowrOb2ySu0XKjg3bEBYDv1RKGu0PnYHp9R2klE2cl3vIsU+9EWrLYbYWQsplkkitbvWG+Uu6WWzSfalQ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUWSbEjEQ9FkkqYJYlK0nz6w3cgMcg89TTGXL4rTREM=;
 b=J1mJ+srbg8rEANWGJ79XsyUBvcW47PocwUu5dyPy0leZ0t0c9d93OdET0oXydLcyWZYBPMlQIlK+I0NTLBxbwFMMbhXMglyqDKBetYWylFksWXwmwkrkAA4/QbiBWfcQDlHXdgfj2wC2898NhwHs7ijg5vLZ6dkYb+aSpn8HRHo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:34 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:34 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 09/13] scsi: alua: Add scsi_alua_handle_state_transition()
Date: Tue, 17 Mar 2026 12:06:59 +0000
Message-ID: <20260317120703.3702387-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::30) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 103909e6-82d4-4918-5aee-08de841dc5d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	iKzkPu9L8P6eeMC9KYsBtv2qzp6yVHyhFyqRqDY0CsxFz4R4N+x0cgpMmCF2at0PGOdBQgdHOcT4xDX0xEbqSbptiGf1mL8Pt9bujr2HnS8Y4dUStMjEArq0k+aGUzgjGmV39ZuOAut8ZuZbrisCMRoj2NyuDOoChPXmt1PzPtlf4gYJxeQ5yEAZL32CUJo2aybyE1hns9edTjQLf+UajKCK7jsG8BzkpZg71xd5+AKThyq/6gHUyLwERCniP1M9Lv04syq6v1fdNAHWkbiQE7M7P+n0fm9Z6G8Ir8fN4IypYv16B7d4rkBVTvrSlSeu2awb3yjOlUzGiQ/xvhDyIBixOblLXrVm7hrK1uFXgZ0RQhYeegd8rNYOSYNFzjzjANVlit+0Qm6hJfTFTTPZcz959+RIzVT42ziHIwYmcB88vq7kIbckjVrtKJmEEZfs0cYcc5A3291FNzR6SlOC8eNjjc//6BHJrhHPypPIQw4Ehn+oldWW7tGVNXSfYo+GByiXezgK2RXMLr8qIsQu0n/NnTHt+P4liwB0Fu0G72kuEeq1KfNbUIm9kI7260tB+Nw9CpIdh9fpRh5Xq9pks2THzkBEPKUASZhhWsBEwwYwA84i1By0xk6j9Vcc0EzitV1fRDcFrm51QocG++wjg/TC5jqNQnMhngk0jl2lh0uIutViF++H2g98WY9G7Dy5N1XwYHtqi/G95ZwJTs+2oYtqMqhMz05mncTz3R/SJtM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ynd/3zkLvBHm6sxxa9QOxwZo4668MvhA0Ph7xM+2Vqv+w1k0/pxRZeRqix0A?=
 =?us-ascii?Q?fY6CQhtqJxIYrhV1Dw1lE5vQsVkVnTTYzVn0toD+kDbg1UsLzQCGHDb499qi?=
 =?us-ascii?Q?b9K5u6O6ij/KRAlWDC+bBjM/ZnNcbXUQF4LqGXVu9ApySZ8y/emjOElEgUEx?=
 =?us-ascii?Q?1KGdglDBNqJtg1tzRxPJJXjH2pSAEG6C/ahLvLknSJ7qwlFRUyLdqBeUQDav?=
 =?us-ascii?Q?+pIMmCJhSVLAG1oaE8pgKNx2G1Dx375WuE4x0cr8gHcl/75EXDQwFs17hA4c?=
 =?us-ascii?Q?gjEfmAa2XNknGdkn8pgR1+WWFZWYQnZhxwXDUdnFtGWsJhiBcclhaW/CoDJz?=
 =?us-ascii?Q?N4aPKxutSO2JC3Eu/I+jTLvVRy2i6lCW1OGWOWIkYNJhyMgt/+Cs8JPAGcSZ?=
 =?us-ascii?Q?GcqyAhw+rmU1feaDusddLg776YMPbfodcCdnfLkq35o8hSCnmkmaV8NymeTT?=
 =?us-ascii?Q?LX1cTQnYbhGHeC9/73ZVfCoXAKJT8T9JqKCX9YKEIDVSfwIZPT/25/Wp5qeM?=
 =?us-ascii?Q?aLN5icD8iMr7HG71tgX/QsPEGzzAD6vpSSfsKj4zj35eubNxumdFabt0Kiqn?=
 =?us-ascii?Q?xZFXQDSRajgORL42W5Azn2amGEVm1O28Bgw6EBoMHIOMyJJOPVAWBxvQ1j/j?=
 =?us-ascii?Q?B/8dPKU9pdCj4uJCgxL731y2PStvtKKrQ8OWqMXjRdqbBMEhJghl5zrmPFHJ?=
 =?us-ascii?Q?MB9GXbc406T3v9zfFw5US4ang59zQZvXrYqBiWUSpPleVyZ2y5S6LO0W1+hv?=
 =?us-ascii?Q?Mfg1UmUW3jEiKMTY+EQQokL25dpqSH52O+HJ75n9iyRXyLNldm06WCpfKO6R?=
 =?us-ascii?Q?NJRQTeiqvGokxFMaz4ukvdIMELUKKBDHPKK5oUzLiU3o1dqp6kSAz0UvlnVy?=
 =?us-ascii?Q?cAhq13vyqOxnak7GBWhXP5NlkkDqULE0Y5YknZt3obmgbWIc1EyOjZEqeHBc?=
 =?us-ascii?Q?/O6gkgOr1LyzWzn0HNwS1fN5Ko5oDH8hFbiJWiIIa6mxsUHKG9/HFp4aw5iR?=
 =?us-ascii?Q?I4rrPO2yWFzt+o3hOVgBxcUamyS/E6LpnZreX6kOAigKDZAvEpFL5TACyyVd?=
 =?us-ascii?Q?OA/wd8jMitM8CgFbH52gCKFgyjwVv7qDUzTJNZy5oMpCvIN5nB+pKrYWKiw1?=
 =?us-ascii?Q?owNqGZNt2Z5mPqJAvOchJYvJB1CSrF/JFNFX4/CJ139L98Jv57AgmTCR/Oov?=
 =?us-ascii?Q?6J4S8l/LuNPJ9m3Vt9UHYax3OphXyDKcX3ds+ffUsA8/ZfmmNfY/q+pVAaL9?=
 =?us-ascii?Q?2T1LPrJkc61qS5lu9xfPKguxNIq0ui8Jfkl4X+Q+diCQRXZ6v6CwxIDzgDOK?=
 =?us-ascii?Q?LcAVxjjFRlWh6G/ruUuejWVE6GcKk0/hxpqKRj9GNvzA5oryOoJ72NCHZ3UX?=
 =?us-ascii?Q?TE3Jl6a6z9FQ/l3XPB03pMmaaPRDAlJuGqXHJemIVATQzBmtv6eim4aTc436?=
 =?us-ascii?Q?/gSwBp7bcRLhmclU0P0w9RVJc/Zp2Gu0LL+elhMwo4HRaCkc+FLRnCzfYaQK?=
 =?us-ascii?Q?FZLyb/ZvsQGcP5X50rk+EqrhMGFgDkRMKPwSZXEry/w6PHsZxAGugnP4C7ow?=
 =?us-ascii?Q?oUvJjYLBnGpMFAghHryiXk0+PVbqEqRfXkoO9gsfwW+zpWt02PBiDO7S4JzU?=
 =?us-ascii?Q?lCK+Yn6w29j4ZOXSMPOaO08XiKfXgUbouQiVK/chMWJeY5EHGHXhKuBAQ7Yn?=
 =?us-ascii?Q?o2xj1O1E1FSYwxXbNwrB/o6tpRRsmINsX7eUkBHyylZ1cCEz7i19x3XdLx9C?=
 =?us-ascii?Q?8AJp0+M1TXL+HjXCUUOCCdPA/prwT3o=3D?=
X-Exchange-RoutingPolicyChecked:
	JHxXtvFeBgcYbCsmmaGps3CZgzVXaAplHi9sM2oPDQxkxbhph4as+us8/LRVZiK/5ahxukVN2Zcmvnu5Zc75Af0i5kL910hf9YlVl84FVJwHqFhaxDPgvpJ84nwh6kDX2gWn/sXxM0du5rFyyI+LALM1gQwzz8ur/w/vThH51D9CLrsdSCrC/TmsrrE0brSGQQCfahFLXWMxC8WPtkEdAZafncAWjpEiHU7yx5Jv841FwlpMLP6MD5HhX+kSZfDcrZnrTE1Lf3kGspc0k3/GpK2Q8gHXEBltlkekUtCcdz5O/ZuzfKpmWFKz2buM663Y5Q/noxk7PQOBdyh+x4jHMw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sCaDCn6LapAH/IGiSgFKRl3Ck0pdnBnIveTEpeXpshz7P02UTIi0r2Kg98TMmQC+bSkpbgDrKiucvKw+WysR3OOMi/MLuS5xFXhjATveXIOdnL7MVmT3zD+T1P4/CGb0x+lWdvWBVOyIy3S9E5sFjw36I8NS9gpub2PwPgaMh8w67Fg8ecoIzrVK+f+8Wbdvqa7m+rYoUzhn3dLn/CmCFI1wT/JkfMHVyaeAKQn9aKQ6DkBVBWtEHWgqeJbKgLb7fUWVDVGvTrOD0iiJcmDBzU50crviUyqnfn4UtLfUTx9ePiSdILkUoYtNcf/a/i/UoywS7fbgolho63au1G/vLyTTJFKwJCqhAYGoHkvM/MsEilU6lrIxaoXqgvZqiolycbBa6e2vETxKvFp840/8UPQ/22BOecfMtfO+i5p6LBqLghw+Cywiv64Mud+2U3oqJ0U0x21gf5qwdJgMqJGjvQpfwzT1Ggqn7zuit+8Vjv6fm45vRkPZcsH3lJ+f+dKKhvoIkZro8yVGblx8nsgujtfA2rIg//jzTGxW28PmKvRwVTMe5rPK4tVOy/s3Cunm2mokA3awJSCFiA3CsDNrSDs2gJeFR/RSeEBysT5wHyo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103909e6-82d4-4918-5aee-08de841dc5d1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:34.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhMkAqphF9QzajZ6BWq7mqVRTFm7xXm8kpydJwV6Yc1+LfzioaiEEKTp3Lq+qHt1O6wwAFI+rl9Om1K2wF3aAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603170107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX+001yxmJuIto
 9Iv23KwmlXXtIE1OrmGij6njUYnJhziQTMiAC0Dlao76ULAxTpetP+LCs5TjES2Lmf5A1bH0A07
 OSwoop7jSoBPzcRGmtv+4NFxmoZR5aMkaoRVTx9YSCOjVH4zL9aVqhw9K6n2kDdoMy7xDU0xiZc
 hbtJOKR8WKogbdtCwUABmIoqOHqRQKFRdydsemZFn8I0269fq3f5o0xWYBYkVgd4cCkKiWBUCUp
 EMVc6lpzKExrxD1wtJa9JF6MKWavoIbKcIoDpnT4JyBpNFBxawtKycvWBaMr6pf4SbQZQIWbVki
 BSqFVtGNF3tZ3XLlWxZUe9UpLeYARbhBR0ZL4pQywcngFksStVrGbr+VT6u2hzASSlojDIGCSdD
 +1iARhsBADRLa58N/Mkt9yUmU2bJ4DMq1m6R7+YGlfy7IDmyjbVEAbFTttKx5SKYFRbxjNKOM8q
 50wIh3voCrhM6nMeNjXjepyoSFsPELSL41Co/qE0=
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b9440b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=aG-FcTSS9aIwPrGjZIgA:9 cc=ntf
 awl=host:12272
X-Proofpoint-GUID: usNcTsC3sxn6i-K-ptWTAtKxBBcvZ_Kx
X-Proofpoint-ORIG-GUID: usNcTsC3sxn6i-K-ptWTAtKxBBcvZ_Kx

Add an equivalent of alua_handle_state_transition() from scsi_dh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 11 +++++++++++
 include/scsi/scsi_alua.h |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index 9c317e60d031e..d19d1845bc324 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -40,6 +40,17 @@ static struct workqueue_struct *kalua_wq;
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
 
+void scsi_alua_handle_state_transition(struct scsi_device *sdev)
+{
+	struct alua_data *alua = sdev->alua;
+	unsigned long flags;
+
+	spin_lock_irqsave(&alua->lock, flags);
+	alua->state = SCSI_ACCESS_STATE_TRANSITIONING;
+	spin_unlock_irqrestore(&alua->lock, flags);
+}
+EXPORT_SYMBOL_GPL(scsi_alua_handle_state_transition);
+
 /*
  * alua_tur - Send a TEST UNIT READY
  * @sdev: device to which the TEST UNIT READY command should be send
diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
index 2e664f20d9681..5b3a12861658f 100644
--- a/include/scsi/scsi_alua.h
+++ b/include/scsi/scsi_alua.h
@@ -30,6 +30,8 @@ struct alua_data {
 int scsi_alua_sdev_init(struct scsi_device *sdev);
 void scsi_alua_sdev_exit(struct scsi_device *sdev);
 
+void scsi_alua_handle_state_transition(struct scsi_device *sdev);
+
 int scsi_alua_check_tpgs(struct scsi_device *sdev);
 
 int scsi_alua_rtpg_run(struct scsi_device *sdev);
@@ -39,6 +41,9 @@ int scsi_alua_init(void);
 void scsi_exit_alua(void);
 #else //CONFIG_SCSI_ALUA
 
+static inline void scsi_alua_handle_state_transition(struct scsi_device *sdev)
+{
+}
 static inline int scsi_alua_check_tpgs(struct scsi_device *sdev)
 {
 	return 0;
-- 
2.43.5

