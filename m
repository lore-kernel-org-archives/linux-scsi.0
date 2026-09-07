Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954CB46D554;
	Mon,  7 Sep 2026 10:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778314; cv=fail; b=DJr0/izljBCZzOSI8imtHKkBgn0cenqDb6070ny/CwSEMf4Q/TJ67Yh0a6B/avgNFcZGLAEjusKfHO6T9xd2rS6HpvH56zoDeVWdxm9FAaZ8MG2aGbmryNWLJ/5hGYd+RL3objqj/muSwyRKx0FaLkbxjyCxTWp2eCpp6lShtFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778314; c=relaxed/simple;
	bh=ezUVb7R/l00PyTmp1Fnunx76QqQTTH/ssrxL3g3CEoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tyJn1wqeHTu1osEsbqPAZID1XNPjzc3xfeAYnDQTYTzIvP7vfK0KtJxLsQamndVfS9cyKrFWDrBdwy5yjPPE1FuSzHHr4J7RUS6mc1Okxvp/HIhrsmAIdMExB4ZNm1vsjck6TDTMzS+zjhrK7Ii13ioivcoGqSmP67FSY1QbAnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G9hZv8e8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OhKtm1Hp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G9hZv8e8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OhKtm1Hp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686Nwj2Z229226;
	Mon, 7 Sep 2026 10:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+HSlvr6KaBXEc4vTGwl0gYkaxMc4vWr0BcwqGoGVvfU=; b=
	G9hZv8e89a1AuNZ0zP3SNOS2MUX3d3tJqfo6NJjsynPnBO3rRyT7vby/l0jsKpZa
	yu/XYybpvuawQQTYdGhgf4WnTXweAEvUTnXXwCUiX00uqWhWDN3hNcBHGxToWdTc
	aGIJn7FCTztbDMKqnNDqrnd7xY34Z8bEW6xgQupPtdymaLdwmqM994cdIjog/Fvq
	sQB3PfTVJ3/URQdQnmXrPaBpbGxfoOMKzLlxVAH+b1LsRnpTasPDhGcMyEX5Dhn1
	GAL3lGb2lTF6B1inPiG2IwymcHYtolY/jC6EiWiwEpdAf57SO4PhYVtNJxi7QERD
	AzjrZxR0WBL4EegLXTxquw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbg1ssha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfB019106;
	Mon, 7 Sep 2026 10:51:16 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgtEu40f86ySc9sBPwToAoYWlt1tejJZTdiVv7upz768vYX6lxGON2DtnuC4IWq1ES4PdoTuPzJdDtxlibyPaZf3GkeNH1DG47Z4n3/AHqmPg+bFm+MaMyK8d46+MQ3CZMUZ2XVGJrV3jnEeBwPYeTNd59YWnXrLFuPsBXsETgxrIvSC1hYdHVnJnEwQvSLnDNuKP2Vki4ZERGgcYcp/fu6yKfcNRWh4NlJekW5RV8F2WDYA7Tcvjve1Mb1AcH3II3Uwqn6r4jCz9A0krk7WzQd4qg+KxWL6QwZK4gkTLvfv/ZEnQaVHFvTCec+l6lR9GM8r9Gxqi9G/XkcDv3lSbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HSlvr6KaBXEc4vTGwl0gYkaxMc4vWr0BcwqGoGVvfU=;
 b=aWqeNLdQSVGvE1ZPPEeoJhbPJ+as/zwJXyEHyKXy7zNtmirDdQlbIeJwzj8yOS8NgsWeEaTtMAr+hUX40f14EFocXwLzTUM+eSWDqEnoha63voI01c2idpWXTDo6nrIEVZMjZyp0w45R7afntWUaJKMY5OEhQwB9ZMfzquRd4iHpQzOtOPxRzVndeUX4GzEuFM5bTfq81OY/tMb8Nbi0A028Pc+xOXdLopXZiRZdhY1yLzKEHlaT6c+fuf+0s0DyWB/5tId7xdnTvU2HJ2/TfAdO7OErj2B4M91HbMJbY/fmdQ1E2sNM4a7UXqIMAJ5dy/noOEGIB9+eJ6SEXI78SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HSlvr6KaBXEc4vTGwl0gYkaxMc4vWr0BcwqGoGVvfU=;
 b=OhKtm1Hpj4J1HfCP5onha1oFBBLccBCo8quDhwApDZRZnhsmh34Y91/riConJvLihRicFl7T69CrhowlQL4pOK6Ev/f8qBSTvA+oOiOyPZAUG6G1183025ZFaySN0CJgE1AMNvhK/63LHxgJcP0/egQtfQoR7M/tQFU6lQ29cy8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:53 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 09/27] libmultipath: Add mpath_bdev_getgeo()
Date: Mon,  7 Sep 2026 10:50:03 +0000
Message-ID: <20260907105021.1763236-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH2PEPF00003851.namprd17.prod.outlook.com
 (2603:10b6:518:1::76) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b500f63-81a1-48c5-50a7-08df0ccde34b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	w/c0KZrGzcIrafgO07hDd/bDQF0S1rfNpFz0Li+HTBb0uJTzHEi5JtJWGWfvHK1e3O/sMkgtNvtQxKAlRyfe//+COchVqTL1vNTGO4TGpk9kSaXqTTacXBfcyMsWzG7Hw6yuO2hB/l/xZ+g2vvBiIE2gCbAXGS5IFbCpLy37MwhaVLjc36ny0LIDEKChY3OkSMXb9l9GBSGyqAToQ4skYmpka96v5BCx7wNQDw9HRCQOfYnXV36KRqHjo703bzpyChdk6W3Y+EN7XgDH7AQ8qKv7ANI73Qsd/mUcnKQHshM0W+3YmehFKaU2IKaassYVJKdiO1xI0O/6lheb0x2EMGpo1YByHyVZKJqVL05pnR64S4hiMBOlUKsHNIlP56zYZ2ruzTWPfOBWPNSRVp/JgLRNgp2Qy9VwlrjNPonYJEb5hHf5X8fRtJOou81qNL02hnabD+7jrSXerXu3+s0Z8cswBLPURr1Ce+928jKvy6K356/vS5sldEvPVxnii0DyLB1wy1BlPuhc6kXMwzlh+o/JAVHpJSuQJZ/77YwFfXyZw0zkXLLNr7azBeP9e7KW9N5MGiZHi+MmuQHqzwQ8GoWjOjreSIrYWO4T0wiB6Idh4OiEzUH2Ao+RDqYc5fuRFK6ZhO0MMC5ICsF6MxpFHwD9/0QKfqRT/iElvgCtV1A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CG5XP07Gx6y3A38GaHLWDvixPtPCqRsEroEZlSpO+IM96SwXvQPpPXA7sgy3?=
 =?us-ascii?Q?/Mc13Cdrt6mrsvZst0UgvfM1ZSzmtI7rxtLWWE9fUbluYChMeGd/74vJ4h7S?=
 =?us-ascii?Q?FF9k44Pw8sVKmhlh42oaJ8f8xAtzyOsfvKsjJnl5uw+j23i560wFq78c7rOR?=
 =?us-ascii?Q?7Xu+Mg7bPDyh6b4SyR57KbF8h0+x0aYF8Ed0hX/XXaxZWnAPdxHdprdMxl/m?=
 =?us-ascii?Q?ExnDgEKvaaKQIXd4ee+Fv+HP9HH8nRMoqWFoZh72nplXGfGGRmrgN+QDj3Ko?=
 =?us-ascii?Q?q9Z9YrdFiwXNpUIkZmLptetdQh+nuF34B5x/IYc6nc+3P5wJmyKawLWYKLVt?=
 =?us-ascii?Q?hTe8ZgxSB0Z2I4ooKCKymz+ZPQ5R6yBvrrQaUawFCN1agPEAwN1wpFJuOBSE?=
 =?us-ascii?Q?2JpJ8LCdsWQXhQr1LO+vznbURn3dgvXyocUeMVakYqnjRHngLBDPUAyhi4Vr?=
 =?us-ascii?Q?eFmVNfKZwjRNvdBdSJvNjEXdcLVyDyIsGWH4IjHulQ5RBjqldtXAYCWxZhhn?=
 =?us-ascii?Q?gd25XS9J1JeFGS7cN8gTFSy6LEgXMnoOmFjIu5M4no7HdfpK9PPS+HUXwp/h?=
 =?us-ascii?Q?OJKn0qejX1Nvkjo2s7P7fXqRkkT2Dg/NYn5DiJRXJDJ0RuvXWilVDnx3sXYU?=
 =?us-ascii?Q?vUJC4/oXLQiw5yrHosoJeynb2ZowV+ta5LSvcVZa5cv32wCn6N8HpEDyMpL2?=
 =?us-ascii?Q?S07qfgVyM4pn4lmtVW6MCHeJJUfQ1en9pwuRc2SyUyYfzIvUnFpUtZzfQkRR?=
 =?us-ascii?Q?2LpDkkdvbeuh7Y4HqG9zxdNfn5vt+IHRo1m0HW2HcCxBXZAYimzKHoZ8n1/4?=
 =?us-ascii?Q?dHinmqJIWpiQm9VAJs/It4GJQ7QsNYF5IFLnv6gVjEsYjQfTsvccMRcMwhR3?=
 =?us-ascii?Q?0YiOCBx73pXpyL4iA4l1mSBwxMWA+ykxaRbArlkfJSBiR7r3gmKzoqO+5MHD?=
 =?us-ascii?Q?5k/uXUN2DtbAad/xxbRKQpN+kKVGgKE8OSDnxZ8PbUosKEB/1ZZjxfLoUsdd?=
 =?us-ascii?Q?Ou3STsaUfsKxlNJ3/ssJBoHguvrf+zK/c8wuI8w8HClIG0fh0dOHHWqMTdue?=
 =?us-ascii?Q?gREWNW3QpPedTGcJ1H3RuD4DxhKw5IS+Ss9JZEycAk1/Jpx1mdqCBtntN1oy?=
 =?us-ascii?Q?I7btwW7CzYNHCX7M6ZiyL0Wkrg45CgiPle+LdPTNhh8KXSX28EihqOoNlQ4k?=
 =?us-ascii?Q?jWFsyDvG2RHI9CczzGsV5MLnIUT+ahcdofy1qiT0Yf1n5bVk3dELE52qDzLF?=
 =?us-ascii?Q?dqRC3N6CCTSGRHQLalwDxuQKGOyN8q6zUAyCavSyBR1sswRfKs34cAAnXgzW?=
 =?us-ascii?Q?xgTXCgR+qLKjZEidN3wGUNrb2tP3SL8+AF/xoMeu4MRRNSFEg1JjF+Tk31rx?=
 =?us-ascii?Q?ykPo93161oHoCCJ5l5OqK80MDF/MEG7unYnv3Jj4nhTAmDYSAm6pfCDCg65c?=
 =?us-ascii?Q?sL4/etdpo8gSgnxwOeVGPWLMhDhISPiKn1bVBrZ35L+uxNZz9qFh1hg4EI53?=
 =?us-ascii?Q?rzYI96NVANHD0n74ZAQMhEiOxbgSutTj1wdyubGKiI9+C1UdKuLLwNSS+hXL?=
 =?us-ascii?Q?NIUrW2+PZr1X8rZdw1kWUlZtNmcp99SRaZoyAPkK5mhUgPM7Icrh3UoIdG8z?=
 =?us-ascii?Q?8x6KFypBX1Ea3InVmtMmgXyVzHo+pArUe+7L7OVJzTQCkAS0N/5PITpPu1o5?=
 =?us-ascii?Q?0EpVRF2Qw93nSE6cTi0xAHxJ3/JW3uKf1Ij1yE8F9Z3j6a381g/aJQDwgAs8?=
 =?us-ascii?Q?xCD7lBkL1Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	fE65mDVCud6tpeiGiEvp3+kZ8GdoWeLWR2g3unPn4gGIeS1HCfU7FwMRab0ncXYfG1jPcyt1eRq6ed+lKf6UTjTDwBM0NhnSG++4HdW7yUoyK+U408CkxNd4fXUHacqlvsjvEoke/GJRmoQ60xs3UcSxdt+yXL0g0XTM2wex48iluaeI/dXs6BFJqdNQoZz6vUob6kHcreZYTj5qoBc8rAqxsMuV+hLr7jZCgbmyZJ3nOWHfPCcizSisP99Fdl4Q70gMI6MfXC+mXBIcBn1+1HGA7dmC2B5lBuqkecQnrEV1lftoUXn1IrF1k7iytbvAd+aRVkphzQ37/3FYtVLW2Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JGkuA53FQkl35EZPUo6pdbYcTcxfYecvzdWeCxOWO8WWg3Rpl1kdC9bwN7cH8J6pAp9oJ34ChFxhsmXOsBFx+qHZlaNB/X0eK9YQ0hL/rNdfDUU+6K9e/io0krWinJOq7Uz4Keh7/X6iIIG+5gl/5pM/U+bDn3C2bQrjs0s5bq3sZry0Nq7+j9osf8rP2dO6bcbGEpi6ThpQR720zM/m6KskdFBMJ0kdQWVbt4ZlONdrANOE1lqdWg1VKP9WW/+R+GC3RwICqy6C863FVz4xVv5uk0wjEOIhstPsWCY93W2KJqUu26g/TvVow/Lerctzz8UQvnP1PDzD+E/MpjwVvwdk6V7AdCa2dODcE6b6JdzmPM2JXiPsoPr5JzR0ZnerYuMDPqrdN6O+FMy4WxkuJj1qMQQSc3QyQo4fThY8T1yfdjQyFkg5kYfYTo+DzKx2FcPm+QCuk9QyYHQFLCH+ZOworeI40hnbrNcAMjwQ+3Lvub8INaTtVmqYs3P2mvu+/+UgqAdVAaKW2s0ObtTKvc84+sV3eAf1t8uVY2yrUh4lz9LL0GELGODALgBaW/f+m9VMUX22JXGgBjpI+KMClQpEfApFOQ9qxaC9wH5iy/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b500f63-81a1-48c5-50a7-08df0ccde34b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:53.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixdp6+wxhdgrr94EZUY4ETGUbrk8yAl0dlOvF/Mgm91oEjnqDzPKFiy5dse1ddnwFSO35rS9Ace27GKfvGuIyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=VpYTxe2n c=1 sm=1 tr=0 ts=6a9e9725 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=-Y819F9slc_s4kW3I9oA:9
X-Proofpoint-ORIG-GUID: L75up5-ON5CoADiB-zOmCqAcToGkFRmB
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX+XTqlSIDG/V3
 MQdutaZnWkJ+1TLCUOH8IZpubCjOl46Sm4hKYshFyiVQbOBS8++Fyt8vBoCxwmHzn2uSBwfjisJ
 aevsYpbgGQYIHupkzTJ652QfBzwfPe4qUg5SxuVywf0OkiveKGCT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX/DSnWutvNk6Y
 RcoHU3yB86gkylWB6AVHvsmIHRZB1Tkf7yCJqK7ie5RLOMRKKTemqvheWa8ZW7R0NUZo2fchx+C
 TCfP0jWquDv9p4eYaD2BIUKQkGzgEEAFQcQb69RvFW5qagg0R8/LfVZX0yV9kE4rhSiQXjugP9r
 eBxFImrWldWdfMi6+tAzc3LuAVR/CRam/+ImNDGdQuXFO4zmgR7ZgQj90BSZuBVZ7IL8pxu9mmA
 G0v+SHlU1pkBrp7Br4s0CSMPALIvVA+jBkwirBb4aPmxb1RYufQ1gUUKDU6+HOOoeCXkbofRPbp
 kow9IMbJCCV8zvSy/LZARkx8EzdwreqKm33nYPSWECSuD7IEMKAsNY4vLzsayMrrH4BtS+LrKXF
 2piV3vO0ng6284HHu7lRT4o3SrSZJFSp0C7euivYMnM+QRNyNdsbunM/lMasjnZd62qoAuDJlMH
 S+QZ/v936OI8U9REJVQ==
X-Proofpoint-GUID: L75up5-ON5CoADiB-zOmCqAcToGkFRmB

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 4afb55b5bda51..ee0afb0f4246b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -490,6 +490,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
@@ -501,6 +521,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

