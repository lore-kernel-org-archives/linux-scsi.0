Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D70D517;
	Fri, 12 Apr 2024 02:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712887791; cv=fail; b=SzNK/KUODRr33wJkQiyoP7erCK0ix72f8dbifCB1YYwWB+qofof4Zoxf+bzpGGTzwwVYykv50ATaYBIUZISTTnu6jjN5xOGfwuSM/Rq+08thVdc6ljlFTpEBiH8EcaqqV4cO0VLH2ttaQon9pPuGuF67G2CaDd57LEZs7Vwm+wE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712887791; c=relaxed/simple;
	bh=8Eqs4JADbKfvUPnKIBzjoVQTWfMoawR8yIn40lLFva8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PqQYF0V5c3lTvLX4iPW4XLguV1jiwfmM3ld/aqnqhPLlKRC1uTx/AZifXPKGy1ezhEVYZkwy/4pJ4l8Mylf89jCcO1iQBejZjZg7HxBkRx6MKT5KgOFZN8unq4IRa25bkuN/yAEfopEB0bjMmz9KodEtJOBFEkkjaZ7HsYC/dpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FKMz4sSE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H/sBFzDD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FKMz4sSE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H/sBFzDD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BINnt3011678;
	Fri, 12 Apr 2024 02:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=0Ep0UQACKKxTbRj2MiDZcZooUdaE6W/Qa2oaycvXcy8=;
 b=FKMz4sSEmfBCHpGSi23WlNeoO7EweGMylv4CQ41DwdP77wHMA5K/gvrYs//PmepACmoI
 BAYwshc3bMQEmWAqnJZC0g9iTtxjuixSymYppNddaTxzRG2gzDatEdgZl6wA8lA/aV9O
 /cmW0/3htvoiHy4rYX+6hfrmCgaQu4IUmCfxrWSYw8YeCYb3TVrU+x3710M4/W2O3Ehn
 R0tAuahAwNgOupXBqL8m+EQg1hb0QTl/H0W4HphiIlvT0rMKyX8m+z52OIxZEZMCWwiv
 UF0RriXyoBUUWMZIs3b6jf56pVeQWhU4t0BR0QqTGpUfo3DC4OHkgHhPuxHzMSIBGTq8 8w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvjwkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:09:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43C0C34A032538;
	Fri, 12 Apr 2024 02:09:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavub04fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:09:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIdbJVzUZRwUrcg26hq5nbvkq9eNqAIEat5jA5W0Elv1/lSygA6bkIF52zz64Ggg9PdzNGTlL8/EbcETa4bdEmAUsBvWGobeSBoqj0B+JmN+mFNPXXdOj9xkGJMkjj4Jo5vfzDMRu4i4TnmmbbAfv5H2rbhby3aFdZQXsLyFESRU87dk0uOuiJyWLgU8547nwDYwYlAxxmGw68aOaW4Ks/W/ZSLmLiYoyVkL1k5Oa0ZokKuPiVNFQZEbEz+zy6YO0m0/vaEy18T9vyRqXI1sanvnzrCx071Jq6SqbOZBhg7h3YxSyAY25jSnWNOPto/Cm6ab6H348FhCDcKYk3gQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Ep0UQACKKxTbRj2MiDZcZooUdaE6W/Qa2oaycvXcy8=;
 b=kW2NCSdrn/RrclFaNIaoOOJ5m+EiNuFfLe9w9+Kd8z2L+JPPUoGHDrpYDtctfpI9KmuP1tee+h/kc9WA02OTKjIOsSZAelHyNsPBM5sqSH/uS9Q0wnLd6MGJYJbvpGknKtLE5trvYXgMDVIzzTOIlH9tFfsDWqZ2o9rSUUOpilFxQSp9AdauWJ2M7CCjnLBeX6spwyaaBx0PtjNpqMVwKh0/W6Pokd7JDfGLzdhKrySZq8wnbtKDeTlBCEEK2e7dTv1pgfo6CAUTcFdE72kDEYkojX6FXHWzlhXvVinwINMaSLb6LWbbk6YboOVDpXjCbmJxZPYPAA0Mgy2RweGqrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ep0UQACKKxTbRj2MiDZcZooUdaE6W/Qa2oaycvXcy8=;
 b=H/sBFzDDAPLuZH8OUlaY50HOfw9LUzFU6F/ylWNm0e96o3qnym/4cHlYWuerb5UZF45HRFwqKhOywJGgx0h8AGoGXpj5F1zUXCyIz10mRcZG9U4jIEWOtvpUYCG/ZT6mM7NRJmaQVXqLqt9s+pIjAhXHUnYYk+zgFJrWWYwMSlI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB6797.namprd10.prod.outlook.com (2603:10b6:8:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Fri, 12 Apr
 2024 02:09:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 02:09:42 +0000
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Rankin <rankincj@gmail.com>, linux-scsi@vger.kernel.org,
        Linux
 Stable <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Fwd: [PATCH 6.8 000/143] 6.8.6-rc1 review
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <yq1ttk8ks5f.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
	message of "Thu, 11 Apr 2024 08:22:29 -0400")
Organization: Oracle Corporation
Message-ID: <yq1a5lzjpx7.fsf@ca-mkp.ca.oracle.com>
References: <CAK2bqV+kpG5cm5py24TusikZYO=_vWg7CVEN3oTywVhnq1mhjQ@mail.gmail.com>
	<2024041125-surgery-pending-cd06@gregkh>
	<CAK2bqVJcsjZE8k87_xNU-mQ3xXm58eCFMdouSVEMkkT57wCQFg@mail.gmail.com>
	<CAK2bqV+d-ffQB_nHEnCcTp9mjHAq-LOb3WtaqXZK2Bk64UywNQ@mail.gmail.com>
	<yq1ttk8ks5f.fsf@ca-mkp.ca.oracle.com>
Date: Thu, 11 Apr 2024 22:09:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:a03:114::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 933e6a0a-23e9-4cbe-a1a5-08dc5a959d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	y8d2YUeq2VXdYxMoTKUZf9ZLYDc6TUv6QRS8AdZUdh0E7PFCpRgtDfDwZAajMufYoQ9wSIPMIE67BINiKvVkyth5EhEm6L/Np7WnD05m6JAy3MRIJXDKSmEc/p4A9a9sjtOEesNIN/YN9AdfB7SVjvqWGtFCc4sX9nNqgj4T2OSDGr4+DZfuIfUN+UfYE0Y8StNGJjWyG9KmgL7JkRcCLbdbZ5u8TJUQGRH4DkYcXlZx9Gz/N7RW4VSqCbm1ab3F7KNCv8iHdqKvQnZ1MLGX1BmtxfSTROBQ8EJD3jtnA977R9MD2w7uwSRNxruVy9gJZeM4jVWYxHgIyMkxRXlht6N3bxqcfTPBit+VehHXbydX8Di8ckxiWg5NudR6BSkm3IxtdzMpZKJhcNqZPTZ1ZcfZ6rYBx+A+fEHzTXewwYMGltUYgcWqEIUSLMttewKdyTYkXymJ9csbKSjWYckqChBJy9zUKxaJ/lgteTDtUrMI0LpIuFdnsYpVG9++Vx3IQ/Vdv/0Z5SwrhIGKVtCVOLLVHK7zIqrsZlATpdyMKak9k9O0UmYQ3BE6cwTRGKvXmBAlar/Np+iEvFZxz2HgRD1pQRE518x0wpY90yrjd3YFKj0QBZIYT8uMtnFmDMGsBpFIafUT123EkVYrIoxwldQr1SpkiL7rkZmMyQHlm4U=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?OWetD8FtlQ+TsxAHhH955TEJmKYf2Y2B6hqzZ1LxgGgUoxlhkhLCH5V8mXtf?=
 =?us-ascii?Q?PDgLrW0hV9IwEqpOiWZsS3EWSxsI/VvVTFWCvE1d76BFr1GZJWregkPXzaby?=
 =?us-ascii?Q?IGtY+mRbWQNXCQHhb4YXu6+u87llA3Nu9KAL/DB7LNUj37courGP+UHPMXLi?=
 =?us-ascii?Q?Jd8nS5af+UvsOofzuHA8zUWpN5OYBk8MicVhK4CaxRVZgXIx5PrZX4kYpW4D?=
 =?us-ascii?Q?uqRJCke7uAug1Cy7xiF6NM/6BoszNkQtkGxYBW+OjI4pUybKaEkslRAGZQ9V?=
 =?us-ascii?Q?cQo/X4a6n19UC1C0/pDONeOFs+KObw++nDfJRSl/OIt5Z7fZOIV+xfAXCfXU?=
 =?us-ascii?Q?NPAv4UX87A212LfJPFu6jeHjJpofILvcZfI4Bh6LGwakaFgoi1gqswO9qUzY?=
 =?us-ascii?Q?HY/c3nE3O0Reep64kS0fbS154qrTtO3244a6vCiXBYHbfuJPSO1Oni8Rml7N?=
 =?us-ascii?Q?WU7edegYiSv0mRmSBouYK08iHuizGuctkGhuwB0661hhWQrrygcHupwhE/+a?=
 =?us-ascii?Q?zKoIg5ylJWKcWegLcmNGzN7clEcwfqs+Y7/8JMR9nYSc/YAblmLBdxbUTv+P?=
 =?us-ascii?Q?ruPvVbWoLi4JwnEfE4dzNs85tMLrxYSupnS2r7w8PYGz77Fejw9PGX7OOHO3?=
 =?us-ascii?Q?YBfchZpTKt6UddggFmUrgNx/vwE/F7g7aQpLJPCdN4Dg+tHU0JUvXlzRD3dp?=
 =?us-ascii?Q?5y3fZmtqata6hSmHmb048uOjgZ/ixTHJsDv5c0Y9JCCC/Qxr2cnDBeb7R9SH?=
 =?us-ascii?Q?Jv+GmisjR5FR0AUCAA6vKTL7fPZsCtCTUa7kUPjE97QNe82ZOoM/b6e8UOr7?=
 =?us-ascii?Q?kKD8MHBElxXZ/saEVbsfyTgGOnjkJpO/hprc3Q7yWfLPAgfC4qbpagN/PrGb?=
 =?us-ascii?Q?gSc9lnNP6Hn5Vi3hFoSMhK3075c4CVbKm/cZvPIkJEXjJQowEeMmjNRrH/wy?=
 =?us-ascii?Q?an4HqZCISXiqKsSf1IVhd/RjxiT0mh2keVbpqQOEJVWIQGIW/sogDLPtpfIY?=
 =?us-ascii?Q?NvzhFnJNgP876N2q7WxAGaD9YjdpMsw9bi4wZQNXMFvrp72IBuAOw0+wtmKi?=
 =?us-ascii?Q?JBwrHNXkbZkO7GX5w0KVMZttjiMtsubY+NGmHEtRhzecLDgeR3Q1x0ATGSmg?=
 =?us-ascii?Q?roYIxSdcPAOL04Ad/2eb1V3Wn3uGNlPV+JkJ4a7ZR2e369pkCPgnaU1EX/qY?=
 =?us-ascii?Q?4WuLaHC8v6AdyARp1ioZtZVeaa+9+80w2wHj6yxfakFPqlfXfSmdA1itL41H?=
 =?us-ascii?Q?7riau1xAOQlyPbRSdTmtyxH7ECcNE6lE4h54LUB7oJKthg6Eg/z0ERXOhX+X?=
 =?us-ascii?Q?tpvLGztmbKNT9jcSOGwStXzbuVJV2RoRqXdg5y9B57FA6SRxgckeMk4iixnE?=
 =?us-ascii?Q?eql10YFJG/AcsajCLvQmRWENpFIv9rmqL13qftWAPRkCB4/Wrn0iU57cjpfa?=
 =?us-ascii?Q?12bP4gk+aBbKBsrKLfs+Zkm1htC+mue9GHFq2EOYBsPU9NWOnZ3eif6fvxEf?=
 =?us-ascii?Q?HR+eZstx+08MfOc2nvQqhIh4KOWhaXxCnYyCW4bfv35/7hcEaqkK/wBiD4pV?=
 =?us-ascii?Q?iwfI4PIEIUIc6YQTfUGA/DT5U7i2nYySTd12fWwf0GKW6zW3eLw4Lg1GNyXj?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1E35ENSTxBKyHLg811r404sPvRd4DUibaQzC6vOfnat23CGRqjDs1DnvhtFGuQcrmHQCYYjjSC/JHQvTJXao40i/U/hIcGDih0sx770CqcRxE6Tkv1gwMgRAzuUSzmFRuqPojpEevvaceoJBgujhMfJa6DnKZvdrXxs/YMU9oWtAcwu1saBhRlB/4mxuTFcEg4eI708fhPM3X8YdvDiA+TOsMDR4edjcuiUOGzytjPshStTGoV/ziLNBjPhHnY3BMd+VfNKMFFcLochHzcsmey0SULHR1B/FljNiOL4X9KG6J4kRsUNR/wurdttKrjAZ9qbIu0Z4B63lxZEsFEzqN+WWRs/GF0w+cZqJemJ9A8IXzzOIDFolUT1b1Q8vHJh8BdusRKsmcjPUwR7l+T+Enj+Yzh+dtobTTq0sW6Py4k2O1kXgfMhBS7CEkkT40/xOZb0jA27riJlTzLk+XfBA4phAQp127yl2wd/zFqf9tM+GPdzCf+nNCtUtqZ0egyeInZYW6wcOYLoSdatWkvfnCdHMFDRhF9bYltLf5PR6aRLXzbma2maM1oiHWKBc2u+rqFXKaBHeJA7p50p65viMQsjWeozS13vefolRvU006V0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933e6a0a-23e9-4cbe-a1a5-08dc5a959d89
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 02:09:42.1074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JiUQ/+pKUuNGEkMHyGWb+N3jhxJ/LRR67Hl6ERBp7qv0nMZqH645Q4IyI1IOpCQ6RJcqcB2kG7His1o/oa67uULgPR0Y3ZjnmlmBk3KFpZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_14,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404120014
X-Proofpoint-ORIG-GUID: oMr6Ex2nXCVbiBApe87DId8RsIwsWdrp
X-Proofpoint-GUID: oMr6Ex2nXCVbiBApe87DId8RsIwsWdrp


>>> scsi: sg: Avoid sg device teardown race
>>> [ Upstream commit 27f58c04a8f438078583041468ec60597841284d ]
>>
>> I think I have hit this issue in 6.8.4. Is there a patch ready for
>> this bug yet please?

Commit d4e655c49f47 ("scsi: sg: Avoid race in error handling & drop
bogus warn") is now in Linus' tree and should be applied on top of all
branches which contain a backport of upstream commit 27f58c04a8f4
("scsi: sg: Avoid sg device teardown race").

-- 
Martin K. Petersen	Oracle Linux Engineering
