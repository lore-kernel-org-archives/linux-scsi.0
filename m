Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964D241F7D2;
	Mon, 27 Jul 2026 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163450; cv=fail; b=PGh2/La+sUxdvxtSx+ctyRdn2HBgnAE1X+K/vZHPDeqlsmASB+3LaW+urLMRc49d/AYqzr275CMgdN1BQonKR7nUEoH2ihQ4PRQ9nIMH15GqENYbe2ZyD6DV5o50WJJ/KqdXoPMq8ODvLKVkhTPuhS/ucF1N2VNQ6D2boJUTR24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163450; c=relaxed/simple;
	bh=DvZC3dIInsX/hKdKtAioCS5zUbcJInSFZpFN0T8X2ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CBwBCqiKm0Vmu3CFM6ofkVJurrcwCi6DkkxJouhA8Gq2NFxz1oEdWh24xm5rBoC/k6WfJ8/19YtTga2bZK7p8lwp56byIIy0eC/MI39RnMgL/58ln6TOJEvaCHyVGtdHlCfTBWQpiS3i1if9gv8/21C1ZZqtt9xkaZY0Np/wi28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o/luxMtI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Vt4as8eD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o/luxMtI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Vt4as8eD"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCUNH52096596;
	Mon, 27 Jul 2026 14:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GZPLSKXtNc8uXxzussmHtAQcufPVKsUSEyxsAp+xWMQ=; b=
	o/luxMtIG9vvapneBHMfouJ3Q43DIPVKbKvy3Lhgh9QWsbmObbNTW9K3T3g8NLjP
	3JpLbPiZTmcOPWoYLvh8pVXtf9+HOEfsX89Kdcp6auOyuqj8h18beuu6QwBcD30b
	aAtpCUMURrtFsju/p6jX3Rn9bcvDHUu0luRRIE6AmIXpMhRqrSY7v0Kpd/gq49BV
	9rySX8NmqjASOrUUUs80O2FtE1/eXkhIR7tQWO9jFsWVXDc4yzs07gkdbwjR5+gR
	ryhw7fySpi+asR73Mu7ONwAFApVfE8tfenRJgNfvDqIgtOFyo+DOnMkX8VvPzCnT
	tTuBg3JJUXhHsBEB/K3A4Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xsxj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeapU021472;
	Mon, 27 Jul 2026 14:43:26 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gewqn-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3bCyVLHSVKrJlygha3vA43nkWFJ/GNduHmYNJGruCZjgAsQsLR4oA7er66MyTF56Ei0/60Vzp6pGc5LoZhuAldndhM/cHngSTFg7JwEbWp1QdtH1UyEDNFQLgG5BRfNgyJLOD4NSkXML36YDgREYJOd/jpA4quHSPBxxk7m9G2Gd6vYwNon6QaOH+oUN9fdZ3UJVcBldGE3Y+OlaIvcvpDLxuoI/lYHdRH0gQ4oxLzltLXLH0y6Qghi4O9lotTX2HVZEPUc4+VOrQLRppsMCQM6owxZOSRUIV22aXhwcAgjTkZkoWsTuibr2NIybx/o6Hn58yXNPRosRQ2mG8KxoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZPLSKXtNc8uXxzussmHtAQcufPVKsUSEyxsAp+xWMQ=;
 b=bYJ7x45XB09Cb9gWDASqQcpbYiYVxecSGyGlryD4n08jhxrzoSCnUa1BM4gG8wHynLIm3hxdkvGmeXc3CHOlm/cz8GSQgzPa/s87mkoFKidRuAXsjYO1zRHftTmD/71DUqZhylM9MN6+ZI9iXzmZzaSstuedEUugUJtaefbqDemZ/46bOCbosJZlTSKMdKJQUMp/dAqtP49KNnFXgnZpYHqicvP+vtCqppfPPog40qMO/9a7QUlJhVtmgrUy6rSjeUQC/ZC6iH5z99UcSIGUfSIn6fTmRamhDSGPnTDyD9vhQpXNTwpA4O/eKBmf5sNyMUNupcF9ixWiqGCNSTe48w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZPLSKXtNc8uXxzussmHtAQcufPVKsUSEyxsAp+xWMQ=;
 b=Vt4as8eDUCo4genkwKZEUwDvqam7E6uPxilR5+LY8eFl6GA2bCyy4u3MJEjufD3X4KyA8Xrrm3jcKJ6WS6bc8MA3GswdGVHvWBAsdkjfKWJ4H7FvNyGsmRoSZJ9cbNQuEEIp4z6XQRl55+43NkpWajfO2Qr+nueoSqHYIAxmglo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:23 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:23 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 19/27] scsi-multipath: provide callbacks for path state
Date: Mon, 27 Jul 2026 14:42:26 +0000
Message-ID: <20260727144234.3802948-20-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DSSP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: bebe0e3a-c89b-4472-a75b-08deebed68c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IEgLeJyHLe3jN0afNnfgJPZLAomtPa+NcI5GnNETIrndD9LboqPF6ETOMcwjYww7CD9UZBWWMLgRRSOnbh+grB+RMV0CtE39r+xs+xN2OUYciO4rK/1YAT16CI6cmvTPBUE71Fodt3+YdClutyxd9ez0//ubdsJy90n+Wwyd31AKNUzCx7Dwk21ku5nQoA94423pAHJL78TXvRQ3hGktitTTB4EmybwUcgoTCRDGDoI52cO29kpIGGd94vK+GN8WlWafXHNnvMf/SGEgNN9C/hn+ERzo6hXvcSUsUkhwz1q07g8MxzeY7DcjcLOKx/B8BYxTtNzYB+7GVg4OKT9bOiVJ8jZaWaoIrDxv9sdFs2tSd169qqdRT9lfD9e+s4iJ5w1Tqa8X+PRgtdlug8+DsT/z5rU6LETNC9Vh1Ds93QvNNTBw9Y+hoF4cTw9dVxJFlNSY0BApJoKZs/zj6kRw9vCL+r72nv8OaAmhbgk3x8HkJDz2f1d6uoWGHe7AZjKqeiprmHiUkQJq93hnPaDwU5JNn+UroZPbIz7l4ddkXbmfEEQkxEbkshN0gQmtoSQKwARsPXf+oWzUnLk4BZvGHucFibOolo9gJL743vZBGg2Cp6JDWfix+cU8VA0guwkOSluEZZ+Z10ntOxsBCiRsHHIJ99ct1NKFXwsxXPViyjc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9cmY1mlbfdHAmY+MkkTEuORGqmfviGxZtAyVl3x1+qGvAT5r7vwIuF6ZQ0NH?=
 =?us-ascii?Q?/nUKYiQbs6nEubFl+qbnnScUIJBLInNs4KEvbMEuYKBLAJccRIqF5TAVfekA?=
 =?us-ascii?Q?7Ioq4Oa990MgEHZVghWU36ceIIcFYe/zcuGVMPzkrluJj3Q9AijTRuIIGUNy?=
 =?us-ascii?Q?EWYzAuW93GDmoVnblPyEuBiLGb70+Ix2TCwLmU9zU0SEi1B5FYU2xrVGBOec?=
 =?us-ascii?Q?MOXndY7VAlR4cN2UZ8HmmzMyZ1m6zvdy0slt7MZP9V8S1IryOAlpkr/zVUlG?=
 =?us-ascii?Q?7weQZb6Ls/pyHK1d4lJmV2o0neBrZT9SBKBv/S7g+TpWBoPy4PoCuts2Sdjw?=
 =?us-ascii?Q?OmoBnldMkjP53ClsNmC4qlHuHtoAMzJvJEtg6+Jx0BZhX5KAjARueqRIRieb?=
 =?us-ascii?Q?tTxlNa0VTn41Q1jnrlz5/DziZciMN/8dhkwd+gtrmnCO3WtfCVy0uxlxbl5p?=
 =?us-ascii?Q?qPKx0XRPazyZY+2jRtM1o/u/4ru5ZVAnoBN0jIEySPjDCSMTXdH35AWoy209?=
 =?us-ascii?Q?2S8kWqx1arHPhS1oPPphh0vk5BrlmWn3/ugL4sbdzr4w52pjxaj/1ysZose8?=
 =?us-ascii?Q?SPNGGJlbrW9SzJpr56VKFo61uU7CTWWxPtyfvf8F151iiJrIc+RCmpm1r8a0?=
 =?us-ascii?Q?NnYIOs4ar/kM7uscw7qO3sFyNfSnCX1jzv8sE3AUVzRc+W01Ot0Kd+7pe2US?=
 =?us-ascii?Q?Ht/JiqK64g0SefcKSilUuCGW1aB84WvHQtghKVpoyYYRMNrl/xuU6NF3ML7j?=
 =?us-ascii?Q?bf1ny9aZDGDHaai79emf1EoQQMlnvUQkHB63rfOjuqbAPMsAEFD1AHSWLlkK?=
 =?us-ascii?Q?hgPt6Rnhb6R4Pw+csa7PAZ3NmV0fIJXKQ0yY5fwrvM96xFTvD1dEQS0X1k9+?=
 =?us-ascii?Q?bMCijn0O5QphDlYu7+noSqodDWLyfuyy0aEU2ghIx6gtODXA4HPRel+/WLbK?=
 =?us-ascii?Q?22kq+wA23RtKv4oLgQCukxrBqMBYZH6awcb76WD8++c5tbQSS9109DmaErAt?=
 =?us-ascii?Q?OpWWbVuGCO8fPgmRjz6qyFaaA0GtY/thTF2Zkwd6wvcv1TqAwj7GV88wKRee?=
 =?us-ascii?Q?NkL1ZHgwI+/Mxd+Z2I5mFYpc/m35lzQz0+alooxy7l84B1ozI+NV07pR+Wgl?=
 =?us-ascii?Q?E9GCAEXkLcBGmMLP1huPQsb0mYLQHxY+ORZPtDqQ86UsDckycqt2iyjQMRui?=
 =?us-ascii?Q?rtXEX0n91xC13D2NE8exC55/C94e3IAQbmjQy6DzCAi9j7ECLCsr57giDQF6?=
 =?us-ascii?Q?lL9RGa+vB1H1mw2Uk3kc7WsdIpQ1xg+3p1uXge4THOKDdTuXvFKzmiy9Vt1T?=
 =?us-ascii?Q?uNIZONvLsFYDjDzw8diJlPXesGwYCfxlCuWrDnighF2uEkpyormGRdqLg+fl?=
 =?us-ascii?Q?KpH2Z2iqP0qmxrwv+I4p4O2dPEPdszIpnBxJzesgkvodR3DEpSpQLbI2TF4X?=
 =?us-ascii?Q?jmfHYJS0vb/Ds/gXZ6rQVEIOkLnYvysYW6+NzMcm/LWXipATGCJabOGTeO/M?=
 =?us-ascii?Q?uqt7WkAt6u4sRNbO6HBV/pH4qLWbdFkHQbiN5fxZxubrWFT3KPQ+lur/kHxT?=
 =?us-ascii?Q?kf+1koLvbYQaE54edHNFvy4g4SCtAzqI1YjgNb15d7LlIG+kQmGCQgbvrCmk?=
 =?us-ascii?Q?+TwSKOscS917606ShRo8+WkOxlUAw/fBgGKnW9+PHRBR3jrCn/HPeacfdOBT?=
 =?us-ascii?Q?YQZjRtuXkR2wbRfq862zhG8FU65GbwVnCZzUpWG8kG3/LnNMf4heDKm1y16S?=
 =?us-ascii?Q?n85jd0ewnZy2ZUw5wtgd+9nJ3B2YpkM=3D?=
X-Exchange-RoutingPolicyChecked:
	dhT2gvF1VRCpwIaeb0zcGjA7pKzSgKNdS9UQNiALPIJcKb646uSJzL63uPglAjf9G2cp1ymaWpcINMtFKicTWKWE2861xHg9M3bSho8C/2lSTi52hWQkr/tZnnzdpD/vdWN9TICeqV0uRkD1xwT5LPqfG3pYHbjUrjL8B3YcBacK5i8P0aFIBk0dnQXdWI5fJxMfOI+dCIucI/JHyCI7ivc35oN06ge0UvLPeFODdp8AWBnGrpytntOvQvfRGWt6lvXSJ7EGtuR/wmQ8T2H0ejrMYoR38Y2gTxOPufQzThqV2Upn4ov3gaNEQw/Yk9pF4BXOQx8a0Y1doqP7EHI84Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P2dr1+p0VG/oib9fU3NaL5EfKe9CO9tlMuJd/mmarz7D3mTN+SRbd16h+ma+G/G1kTV1BVa0hO+NQ058/r9E56rxavJiufbPTPqXm7Uyp+PY1WNVPzodXeFel+Yl32/6dtSriPW8PYrRgUmEO9uHeXqQ7HEI8pdIKgzLz8nJrzncJsRTOfngvdWKtJp9jcQ+2rc6VaIZmzDLdyMCQKpqDcCB7lsm/XQ04pxcvCB+eVmolkFz0d+WUQhI5RJRpZ0g2cr9PgElhLVaoDDdVm1OYLtI9xfnmrp/rhlkpL29XiGcekRXDbfm7Jn/0/6cTIAUzVOOFzFwZowkDeJZTIe4qTHVUOq7fcq9/7hPVvz1k0/+MP2iKtUDUnaoaWgU2CtMI5kowZ2vN9jN9RNGzwXZwfCTzFT0K1wP0gF4Uj8IPlKj6wR+l7Dbny0S2YyLaRZYxgjMYQerRVSsSss2ltCw4A87LQ/2QaFChgQGX9BQfHf5a0FUqFhwWSZdNSDQdfKLTKDdz3xetMDTgs8Q59AAC9LyyksWza8H58NKHwwWJoridab3UE+4tXpQ1kEgX+pKwN6lq9vsKTpKmXSqX7cyoqOdj4JhMJAGZwYe9b4/aFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bebe0e3a-c89b-4472-a75b-08deebed68c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:23.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zUEkcx6CBmymONz44qghl98dXh6tOs1zMfwdu6V0CEih+uiU90nQIx5ZqEPNeZQZDJZWG/CUV1k8dDpeBTGt8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-ORIG-GUID: Vud56pZMwMxfS5E8mM-LLkYz_xjY-9K6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfXwGv8qOh30oBs
 VuuAH1bVuZ8mthXejgIDIaRsXucwC2T75yvGhl0Bqmt8cy5SAxMArg9i+U1EJEOXHkOm3fCQECx
 VHvPTUYcTrjWejgyCy0XoRGYL8G3Kk1c7AvVKj/223sEQyGTxvKCFE3DO3/xjZ52IkpNvZnQm9F
 JLt/vPTv6ul75qoCmMLJNe621zDGc+p7YWAZzSS0lLU4pauaq3WnJ6PVx7MYLvOcmMGnSMKFJgr
 XF2IajMhyThii5DIroAq4/8Srw8y8AeQLWKTSq6Ylv1xV9OtJ/c6L4gmDdCPzqE8qf6SKkaC2wA
 fj+XMYwobuOu42ewO0/99HyS9jlKQGX9NEwyKH8fLP+ypQ31NzPL1AkqF7Nqitf3TBZvGdeSjLj
 63UkvUHpP/R3+HkHX51ms5JiokRTjT5eomxhqsQsIYa68KN/hpcdT697VlUFAKxjpatepi3G5i6
 mOgtxQXT09YoxNiaKNXDPWivgZ9QyucM6zqEUggg=
X-Proofpoint-GUID: Vud56pZMwMxfS5E8mM-LLkYz_xjY-9K6
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a676e8f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=DHJJM_rHgSnfI6yttmIA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX0qq3sgbzSczf
 y57opaePGYWbKZvz4QtrVfLE47PeBV+VbCPpEpPAYv2PryXf/QYzRweZ8LNCZv6G2Tb+kjo4foy
 /YOWUqdp1FiAh3wqXb9AX9MJBZehYSV48NrRuHqL2ENy8ojrZ/at

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index ec611f26d7960..d79e1b7b90051 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -314,7 +314,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
 	return clone;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return false;
+
+	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = READ_ONCE(sdev->sdev_state);
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 static struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.clone_bio = scsi_mpath_clone_bio,
 };
 
-- 
2.43.7

