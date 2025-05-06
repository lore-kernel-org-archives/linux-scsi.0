Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31BC2FFC66;
	Tue,  6 May 2025 02:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746498176; cv=fail; b=dLQ1o+nDU6f4UXpEVwa1movSdbX4zKo+OnebGg+sSkQ6KUVkZNdzGkEQFmiuIABsBTyIatDoltBNzFBvlWQZBP/4YVQVPY3OJ31SRNoJIr1tMfPEgLUGRnN06gRYQ+q1nEG1BBcjIRSbRLBs3A173oeYKmqvltneJy4NOIVQSzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746498176; c=relaxed/simple;
	bh=cfe1iJngx8KUOA19e0RHSja9zsiZboqnuxWSFg94XU4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IWw6M1El0NTm4pwcsJ/syMo3AsM2YEw6Z95cgp5VyhoxpUVhbEop+KR0QxTuxGO8K1X1aq6BLebhrkNT+5t2PRL5TVwFPpbJjus7ZkrVOiRdLF5UNPC5NdN7DTu3rllTyczgoB8BXsadglIwiDeufGrw0+h8OFbKjPBX/tw1Rag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sD2ubt1M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gCGeS9wY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sD2ubt1M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gCGeS9wY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5462GqtF006178;
	Tue, 6 May 2025 02:22:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dZZZvr0HoDUFgULEhF
	c1z/Vf1dLwkKJSmNSI5LXnQoM=; b=sD2ubt1M3SyYlho3YighFcrUfNUFJdPYLU
	o7mS+A/oIPWOYTLFstyKqHCJM23G138kJl0i0JAexucS3H8MP/XmFtm266wcLXM/
	ipOOLk8mqpsyqfzikw/EVLkZvCu0vTOzk+QqeweXQczH53W/+F9hdtN8GPY8cJ+Y
	Z/GieLDQjc1uHZ4yYSMu1VjEz31MD1faQ+bwTYPi3t6g1XJL4KuGm1aTWtdrsrOt
	9MxBMbXaCuWal5j1rkOwegWGlsJut8x2CH+qt4Ht5cxp0+DMBF9ePZmR/j5zPdJV
	LWdQpM4oiQbTlGbPyKqEe4sW8d5wYpJdSSMB9Xd7CpMUkJfn419Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f92fr145-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:22:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5462CiS5035319;
	Tue, 6 May 2025 02:22:50 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazlp17011031.outbound.protection.outlook.com [40.93.6.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8e8r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:22:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B81mOhvZbtZ4xAglmGpmI7ISX20SEg0mhnu+yOc6MASGQbXTvym/K/sayGovwpuB/RrjFp0BavX3qFV+WPpZOEDnnSdhq66frsFSDeTBRkOaK7Eo5s6ureVf3/ABrNZA2DaxmgjHjcl3eA4rE1XZn8OovvNdGKjDytXxi3ol1b7vw0+aZ3kBB2ziJ1tQEJo4CkPrfy60JfZzepJTWV5ZoSNf4xp6fzgOCjguYDyAFWMDJ8orCMDvLyH72+L4oeMXVYMOAtX03obUrF0ZsKJD3WNTN5VkALc5w9QnBB+PCOlkVvDdCMitLaqc5TjZJ0MGlsC3p1C7JQZiFjTsOQSaYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZZZvr0HoDUFgULEhFc1z/Vf1dLwkKJSmNSI5LXnQoM=;
 b=SL5r7QVqM8t/bTqcbWNynEPoK3yRlVHUrxwipmbyT91fsSageOPZBx1qANdF02hTWQnmW7+82kg5WryzZz1jiK6+DF51BcWTgR5LsRtsRgLnQJjl7vT/AISNJ5eT53byOBXZ2yc90dhBnoZO+1oXPqqGhzw6Rw0z/jXBPDIzlzRtlksj6SMX2qCjqbRIGOXscZ+Nf027OWsLN/+KnUXucmX/iyUPX6bJ/eox4DbL3YSs8tdHQwArTOUdlhPbOd6CI2MdScv8LTKeML1MyhVwZDxxCrV+LtD9/VHOJAZahBwWAsAaI6g9F63Dgn+YcuBrrgi0wffCrixVwsVAs24Dyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZZZvr0HoDUFgULEhFc1z/Vf1dLwkKJSmNSI5LXnQoM=;
 b=gCGeS9wY4KukaUm8d7dbIgcY7ycw4PNlW/Uqjr3v8fVogSF4HTyGXP7dpaykkiWIoZcKryliv29DXXWUjHyop9PEH/u+F/y7THRn146ujaFj5x7SQf5eneyWCM/lrq1RIWQyy3zB4ytDBrx7g2zC+mFcizJvuNJ/XeiPp4h4fXE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF3984739DB.namprd10.prod.outlook.com (2603:10b6:f:fc00::d15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Tue, 6 May
 2025 02:22:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:22:44 +0000
To: linux@treblig.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Remove unused scsi_dev_info_list_del_keyed
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250503230743.124978-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 4 May 2025 00:07:42 +0100")
Organization: Oracle Corporation
Message-ID: <yq1jz6uv5p1.fsf@ca-mkp.ca.oracle.com>
References: <20250503230743.124978-1-linux@treblig.org>
Date: Mon, 05 May 2025 22:22:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:52c::15) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF3984739DB:EE_
X-MS-Office365-Filtering-Correlation-Id: 079737a7-1a6a-4108-3058-08dd8c44e23e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qcw8vI+/0pz5mZmMDuWz/zidx20rMS7a1dyu6hYM1IuM9w/yv5K7IafCAF4K?=
 =?us-ascii?Q?mzNIXSKQuiPJ+rw7FPjXP5XyTcRF9e7dXbek6yc4FAtM63X9Hw6PnyzYU69E?=
 =?us-ascii?Q?cit5vmWhHVuPBfxVgPGb4Ei11MNKwxmhP4wcAzlhF4QkSVhkrDpg4IRNkDCz?=
 =?us-ascii?Q?E0LFuN+gThn1VTx5d0ca5651udi1xSjf4uUZxLmH574mFL76Wbp6JN79XCyC?=
 =?us-ascii?Q?iU+ajv1+P8Wl99mvtBgqSlkPziy/ywIumcJJoT99cZh+0/6Hr78XTKmHRUgD?=
 =?us-ascii?Q?2DkEYHBo8efaGi5p79pDF9rx61knBz4U4lIlyCDaHAI3yHA9cUCvnM+triYp?=
 =?us-ascii?Q?m2AWEpWrnxgSehASSziaWG1yn0s6HJjvuGaIFqRLv3TxLfwH6GA8q3LQBL0E?=
 =?us-ascii?Q?3e0lmEM/h5zeR4IUdfaBOHxfxxa3n3TUAWPXFBWTFOehBkGjfXnkR1MCFr35?=
 =?us-ascii?Q?syCkY6X5VPOmEzO2wIG4KlqYDLUJ1FQX9anTgp3wLX+rKBloFvpOm1fx2vDE?=
 =?us-ascii?Q?malmESkyKtueomXtO3QCaH8Cm7UJdQu1OEVNoq5iANqrsfr3bQI3hcNPGgzy?=
 =?us-ascii?Q?SKuGd7z1Mqa6DmCAArfHKUWb2QZU5z90nBwywwiMdl8HnDK7mIG0cW1K9eQh?=
 =?us-ascii?Q?8vf+gOChhFDTRBvBoCtn+H1aKBkd5cyCrOh2asRZbJTzaYkZhiRkUPhDeixl?=
 =?us-ascii?Q?MZeGrcNeO+CdFtBCOW/5QXLEGHCet8oF0rICuXEYsK+seI2wNaTWDkK2HjaB?=
 =?us-ascii?Q?9r1wPg8vihK8ZnWr5xsphTDQAVludaVr9MFmYzRzHWdAJ5ZhXh+ZJYpbWAt4?=
 =?us-ascii?Q?ES+iOMaIKMfePqpC6BlKUlaYEtdnOI7++rTEaSCzH8v4OJ51d5md7ax+L7Uv?=
 =?us-ascii?Q?JPcE4ejjivUC9SqBIbkCozZzy7ht8xzYkvWET+ER7A7aNgnDfa9jga2EaDG9?=
 =?us-ascii?Q?RmF9ao8aqhEW8KQoZcnIqsNCFrsnNp4S2ypbn1M5tc8xMdNaQqFBLRWzyPgB?=
 =?us-ascii?Q?Vo+orF33HAhZmsYuLQ10O8sq9GW7GEVn7oS8u6C6zvs3w6z8VSSn4HesrFWW?=
 =?us-ascii?Q?n0p/3tXY/3swO1NkWUFPBQ+6qiU/WPO0mcOo0GVbQPN4RoujFmeYHRbpt1aN?=
 =?us-ascii?Q?7vp+2ZxSWGWG/zRmKGXqrwstsmhsg6kxQteJgyoGO/7pITuliS/eqAMDrBpz?=
 =?us-ascii?Q?laTHy5labwsJXirnzpJUfRItUWX/Fr9OApxcDJp4e/oeYeItipyQX0gCGKBk?=
 =?us-ascii?Q?pHhx+yiuHtcs9tY2+L/6Esg5vnwyQeVOQv4B8v5X+4urfMhkKo+CdhvXVYCY?=
 =?us-ascii?Q?1BXUkO6YJmIh4Ay2GDQvgUN7oUd5LM8S8iOFsrie34EkS+QyHNZLVuHwXTRa?=
 =?us-ascii?Q?HO9q/y6mVYFYHB7YUW7Tlkug6HRtvVxirdZa6ODLJtjoy6AgAms/PMi2qkh7?=
 =?us-ascii?Q?Rt9/IcRCqyc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wBNdoraZ+JP9f/T2eN1AWiwrruuDxL3XjcsKZbQnfT4aJXbqF1A/Rqb+h6mg?=
 =?us-ascii?Q?+EqFKrYqi3n7SdRL8B3UpvleUwOLSIBwsVhreYe7Evh9IM4P1dbkCXu05ikw?=
 =?us-ascii?Q?tl+fV5oOtVQV6liA8Ly2xwEGrmmvDbWFcezIdsoCp7zuZ7/gprISo0v0PjGx?=
 =?us-ascii?Q?ga7wcG8z8JPZp0tigBECWVvx4kUgpCwdNv6a7l8eNLM6j1Y/jnNVvKzfFKQv?=
 =?us-ascii?Q?ufkWb9zEaL26oTV7EvIj73eC1VXDE42x4aLKu7MDFUUCmvfR9aCKhTKZhDmF?=
 =?us-ascii?Q?tBMKZ5ZKuG162tFHIqF695N51HD4jBxCuH32avNKNPBoaLoPLkLoUpYxmghl?=
 =?us-ascii?Q?5PRLsRjjjzJBnNYfu6ItycQWA4Hi/QHmpFdE376ermr5qYd8Q0xBktcagjnf?=
 =?us-ascii?Q?ONR2Ej7gqRhixsa6qNgwKFBoeSymoTUEM5EZjACMQgiVxvCdQvCUjdcYdabh?=
 =?us-ascii?Q?7z4IIoWzctUEoix60vX7kbavoGK7hvTp7MJKnjM0vXYcM/JrCBOtVhHTj1q/?=
 =?us-ascii?Q?YVahKcbLjO29tVg0SVgMFedpjCtXXBluiyadfN2kwIu4cMKDGnU/GEtA8Kl3?=
 =?us-ascii?Q?dVdWJpPztkVFBrVp74fIjtRwjacQ70kopam4hUI/61ozDeWyzVsbl5V0y8vs?=
 =?us-ascii?Q?cS2+qgoKbo5nAnFcDJwVacmUN39mpGAa42/HKCoavvlyebXbXLQWBQW+M8Wx?=
 =?us-ascii?Q?G548fgz64VITnwe0nQcdGJvEaDfhx2DTCsr29m0WC2IW/Ii3pUw/trRRlmQv?=
 =?us-ascii?Q?6AlaWsEM1Q6r4FCM5abscada0LvkG4TMV1YJ6XS/cEqqaA5c06zFAonOHgEB?=
 =?us-ascii?Q?vrEHroF2rw8FH0K2x1D9zODsiv3MoWiult6ljoMhREXurig8P33FBht6ZgZu?=
 =?us-ascii?Q?oIQxDvG/nLeuxotIsdmd/HWvyptX3HgjsChXP1JaHvaiitqcdyiGkBCDpKWi?=
 =?us-ascii?Q?ffOCzP92p6ssVyCNt1mmqqoIcvs9ztQ7bsceka8dQpuxPM51FpznJiF8wmyx?=
 =?us-ascii?Q?HG+XB+FXMv6+rGbs03Fs8JUmL2WSgjdUc9YWCMrGut5ddX1lrforu3uZ7wCu?=
 =?us-ascii?Q?L+qUideDsYBcSY2rF6vDpCzbtFtcLAjTU+UPKNg7phbVB23BhoxGR0FWGkfc?=
 =?us-ascii?Q?6ac7yXjJhvkvK6G8Wv5T6tHeFhHwnjEidTFkONZTGYd+E0ZQC71/MTGrgBMM?=
 =?us-ascii?Q?wPlEs4ZhkaiyioOVw+PBm1wSfH+mELmzsbw7tVPp5SuWBvkIbl1zfi6ANLDn?=
 =?us-ascii?Q?8jhM/aHAmrnseeah38drtxCPPUVHGJxSPagHX85e/4+niO+7M1/i8d2cjjQj?=
 =?us-ascii?Q?HX2Y+yFcneTvIQvu+KAaYSQZGNA3hCUK2SfxVOYMAqT3thTE/s038PvKSDAz?=
 =?us-ascii?Q?NC9xyU5BQL1wZ+5dAC36NDbFeI2cJZUxqkIlX71Yu4XuLBbrxoOJ8fSddYuI?=
 =?us-ascii?Q?kmHsxYWawoCC+SEbrAcMlu3WR3+7EJm7x36Sm1mmRqT3v+IkTtstc6wNjD4v?=
 =?us-ascii?Q?8E5uR77P+8aRMrBLRnLYS3Uc+5rh44TjEdoYVyj6gUjDehi7wq0x02yAeCZO?=
 =?us-ascii?Q?C4hCmH07RPs0n48FiQstlZNBCJGJvEu2qVSZJoEJ7yrLEseZMgEAg9+JkqMT?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yWPU5GsNGy8szkOahakdg5snKnj/fOizFdFiKC+mTJMGLcQdQwsFWKWo1relhZfPnI/EMSbRSA3z0bvtgj3bkbMX8JaYZk0c8AJfgvf4gxAz4QA12RYV3KP6I9Db6pliyHXcrzC8F80J3YMMfujbz95J6srtnNiWGuU9CIOXeAJFxqp7BAwU98RdoskhyXLPwvgLCP9AOBW9mrPO9fdbzIlGXp3An3xfEblCRWzaFe+Z8ur01uNLBlmSWZdLeAF+h2FM57Hsmlf/OibMAhsjfp15y/E9948xEi/o3CtMdWR8BI693oU860uY4PLwZgtKxk4iykYPvF5PmjmXcoJMNE7j2Lja69fbzOCnPPPlZacXj1G+gQZqfsEDv+hC1H/tfOMM8R6/bKxp0AihVEvYu2zjdlO247n1sKKwrhJI8ZrXsaDWMSENlV5uM/qP9enIo8uMhXsYPA+5Krf0Yn1maNx0Lhi16mGVCdc9d7MSOw2Sp2lO39Sr8tqRHcRM1742vzTw5ZEzj602qexk59xS+eNG0XHMb/smoxciwdz7Vu5Q8XJSouUDWnCGGmJoImaDz7pzwwicQYvFqfd6OId8MZw5V/7LK6NB5lKtpLHHH0s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079737a7-1a6a-4108-3058-08dd8c44e23e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:22:43.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oofu0OGpZHxLpR9BiqxJ6ag8RboDDJ+JIKvbHZyJh+Fn0+5LTEeCdpx3W0I7dRS0rgtIl3shy6weCRnbZa5o1x/Foo/TjOoCBSeji3/eTaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF3984739DB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=895 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060020
X-Proofpoint-ORIG-GUID: w177WMmAEPEqxMBmOI8BV-XzghICjJ3O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAyMCBTYWx0ZWRfXz+icnlQMCJW5 jGTzc6jf7K0dY6ZxwAmM7DP1lB6x4Eah2e5/TR9hd58WchXEmMtKDis5WKR/x8eH0F3SV45zRbb ROLXKhq8BGPAGcwJr7zikCm+SkxlKh0gg8EkthWEUffQR8iAuh4Aus+VVtxll6Ueg9rWcIb7Cja
 J/YACVKeDcMm2oXG7m5YyBiROJDaq8nK4kppJPmzHN9FX5ff26OLztF5BTIQj8dnZpMc0ATYxIn zvIx9VJvMG2EAcqazlwbLv4Z/ypf+bLWbXJ4Uv6aGK0dtHMEyQqx2eJHf+dYztgaa+cQIg2sl5+ tN3YUfyljf4yF7vQAq8lvW9vQe21pG61riAEl7itAQNYmYQKSYLeG6mVNEI7IazvRGofFfVVmpB
 uldHYk8coNLkOn63DCzu8hQyzKXj2UJOBnMl8sZwFvwZNdDI91v6yJzm+3XaesMrDVVspAAd
X-Authority-Analysis: v=2.4 cv=C7fpyRP+ c=1 sm=1 tr=0 ts=6819727b b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=cNMCkp2XhuoQE_LABBQA:9
X-Proofpoint-GUID: w177WMmAEPEqxMBmOI8BV-XzghICjJ3O


> The last use of scsi_dev_info_list_del_keyed() was removed by 2011's
> commit 2b132577a05e ("[SCSI] scsi_dh: code cleanup and remove the
> references to scsi_dev_info")

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
