Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B85C3BD649;
	Fri,  3 Jul 2026 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074699; cv=fail; b=LjAUawu2hxIvv/ddvTntUnvemP7mqbZZz0BAie7jpKikwZR3ER8qUc5gr0Bze+8UC5u7JzueaUJvUgdBjt55jTBI3i75ANuL04UF0QtNJW3YZ55oLoGs095mhZX7a3HvNygJswC9p7XrwtbzqalXLFZAfDzVADVU9o704uXsgJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074699; c=relaxed/simple;
	bh=XuwNpnjPRm7UNeg85nmGHNWRC0qP6YubSRkg3x07hiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d4riaDS7ttkroar6+eAz48WhAzaImJ4eF4k9QFlMULwtoIBCMtciumrBM6VUAeUJ1AbJkKaCuYxII9cO9fXtmfE49+XFM3yeZ/kYGCeClK42s+35CFxngJ0juoAU7Mwt8hmSkdko3mcoTY0wi+o+4istx86BuiBupEH+MWhu2Gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jHYPPJFy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A8JM9zMh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jHYPPJFy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A8JM9zMh"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638u4IY3081231;
	Fri, 3 Jul 2026 10:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sOwhNiok9zuY1srllEV6Y+HGrmqhPk1GWDu3WzRDaas=; b=
	jHYPPJFywA851m7NAwUvUC0+n1ToSVD6dkPkK4Z/fRab7xkTh0ooQIdwDMjxHQqa
	HNchFy1cjkbf4BNd7AztXz+LKRWV3AWMAjht+DdWVBkO2AcD9E/p4MW/noBm1r4S
	0FTXsmIOsQpkYB0X3lP2jPQU/3ISf2uIQyKZuVuSWNwpA3jhtYdFS8JB3OBv186X
	bNmMaqT6gBppX9wrdAcP7+WzibCGsMdzgG8FnI+TjVb85lDz0L2U7ydI58AZA8SP
	ggn3AMB7tdJ8v6DqVDNcc07BnEaVLxIG6MpfuEJs3LI8IeiwSNU/4qUXAvcoMHe6
	q9FTdAPfwNx0hSIZoI/heg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqaher-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ANU9c006478;
	Fri, 3 Jul 2026 10:31:11 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fr8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u6sMkBb42Yon6GObfuPSiBmL9CbccICTyqL1Qo8MIi/QfnpepEg+cCRA0asI0fP7gEmf9Ew83KNEuFBQQU3axXbKKRklsT/Mk1LK4yaKr3fQJX9t7LnoTMxK+tglCfCuq35AqpdSJiaP+LddpsI4BLlLH4HVxJf9F8rcECULBQFLc1AXcVBinI8GWjrUCpl/rqURP8TkA/sMFv/0qkcm9TmnM1SxyA5jfxEAx0DJvQIaPLXRrRMbcGpXad1BUYv1eOtzKP/GDefAo3umXWo/okBpurwTntV88UHILU66Itrv7X6OHUrI+0SpwQOikhG9uh+U5tDtdWQ/mo3ZYzJRfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOwhNiok9zuY1srllEV6Y+HGrmqhPk1GWDu3WzRDaas=;
 b=vqOGFzazbbk++AdCEelHVURmZZBF2YL6eraTlhyHAZynadBKW1YWSF0jXuStrpjXWgyPjuPUpkos8JVcFzzu5VyQEZVNzUBZVTOTiXE2u5J/JwRM/PFUGP4LEyLHFyBfo38fQEI7S2vxMxg0/IiGXi26cJkatMXpQS3X1w4P2r2jg44yWge8Ys/rc+0yvqhHRVBqv4ZrpH3IgPo1AxwjdQRO0J3Dl1efLvS1EVXSKs/AhIoOpbJ74kiULCJrcnQgIwTARhxjhXoKPLMKNTX246jaXa/YmGjoI2u63TSstmvOVze8kduCc8ohINAKVIvYlVUzXsiQDZWNH72Df/j7hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOwhNiok9zuY1srllEV6Y+HGrmqhPk1GWDu3WzRDaas=;
 b=A8JM9zMhBYbcSRq/xzCorAAHcdjQHgCYiengX81xfwsG6TGQ+jdUggBNHhDjYzlfXZO7MnGG3tOwZG1oC8WMM4lniPMRVBPdP5SZQINiFpQN9PFzYXflAsWq8LLjI/1Qt6dEVjr4BX3PAv8x3NKHkoTIW58O84gR/ZzW+A3ax5o=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:31:08 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:31:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 13/13] libmultipath: Add mpath_bdev_get_unique_id()
Date: Fri,  3 Jul 2026 10:29:18 +0000
Message-ID: <20260703102918.3723667-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0043.namprd13.prod.outlook.com
 (2603:10b6:610:b2::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 10580bc4-9ff5-4b5b-4f40-08ded8ee3168
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	a3S3rplYg4mu7MffqMyPD8zn36+RO3ZFN4cWvTHIYKPLI2ix6SNI3auzZY5JeWrWw5T5/mPssTn4oDV3h7Rwx9DSSMgyMbGDqeR3AvGPHf3eBpwtiWuEvktzVwazZY3g3EfJ6bAq4oAUVqwQY4fDnrlt81ySCUizQUHA80jEaMCzN25cc2EKbSEQX9nDDcu+lDCBWPNe6LfMeQGEpDR71L3oMgyX8qxZJlRvQbkCpq3lOEaC9nqu6jr/MS6wFzmkwm3a5wWsGjAE2d5yArCOJfZa06UTmhh6H7vWkQ9K9/qvGd7sivAVWaEjHjU4PAOqpEZaLD0Q80omRNfHx05B+G9qS0rRiwa2zvqcbnSxfMPvvTAkGCMjGmAeH827u/UA7PI0ooYZPrpl5+Udbo8Sy8hI88/jXtzVEEzPZjoavT3m7a7x7oGfxxfqs8LGx6FFrViWoLz2FAcBKADJ/6G5g4pvSVBPxp6riEsahsCwPBnVRanPfEaJU01gelnD4aaoxlzvGpoLFBIP9s+zoMAOepnt5NNcofeMwhIY2THUtUMgMvsuEgq0PwidZ/X5tgJWeE+ebScqrDnNjdilYtAnQDGka09d1bNIiGqum81+wWlTRxkWW3TyTNq0kQdMQaWiWFJfb2gBOlmPS/wvPNSEL0DEte9msrVdPSbBcy/trQg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Kre2dp5Bts1Q1uMZEvrQ+RjVJlsDSAS+/+MaLhMp7fXfoAfSFzJYF3dT01I/?=
 =?us-ascii?Q?lycHiAjjK09UCGJxdyURtQushrWCNjlTmLBHbjH5WuDdVenorRrvm2LA4wmW?=
 =?us-ascii?Q?JWvNxg+WpRrZdWZrbEzrNuonddPkzgLc7dmS8BmS2X+dy72opVS9gaXlYdaa?=
 =?us-ascii?Q?N78EUxezsKS3+fZV4OGJCt0inR1uo3oEtyAnm+X9atjS0SuJqeFAhdQmw+mb?=
 =?us-ascii?Q?1eLtRkXQtp7L4QiS6g8+lEBFwNxc5fYjktN7IWrUNc/UhZBJeOWt/ldclu1I?=
 =?us-ascii?Q?mYjYqkTOYlTIr8bxGJxL8uRbbG+PiW89htzqtzdTQLZCe8CIFjaZHljNNJ+O?=
 =?us-ascii?Q?BsXiDNA5NBqWBiUlqd27Ff6QtHS61S7IGv1zA2H3OSu1a0vwaih1evD6RPQz?=
 =?us-ascii?Q?8PqjKzNo8qeQ5KWHzloPSAsykCuTSlZ3uDdBAq349/GWIY67sn8Uw4D9oHDi?=
 =?us-ascii?Q?HYvzNMGQHvImxsnfzIwlvJWPlABLOCmanAzSpSPFJuvAzr/dyXhBg+dV4tRE?=
 =?us-ascii?Q?zooNk3SLG/NM7ZfMWG/CKeIMew9IZm7zg20MEqHAKE+yX0fzdniPSFB+aqJR?=
 =?us-ascii?Q?eSaZg41b66wUa+BCJG9xzRxAQX07MH9Ix7jd+HYONNPfvPaWS2ei8CrcP0sp?=
 =?us-ascii?Q?yqdmgo6QrxjlW4mzxkQidnZdwoCne6TYFuSVi+yEzXuMdM27W9hoDDlB1veF?=
 =?us-ascii?Q?K9E/Kb2+4RM1l3dt7dLWpc2bba02jG7A3ulwpowpBUr5BnwN/nBl+G+xwpTD?=
 =?us-ascii?Q?qEFxpblpypN7AZzM5Ces2+jJK4Rlb+FZQZX0mK6ovXj68x5JNPUVN27Az1Gh?=
 =?us-ascii?Q?bgpc0HRux1Sslzb6DJ/40dvNBBqs4G2yZjlcdng8FAqHcFqFfHpReldJT4e5?=
 =?us-ascii?Q?AhpvxX1TLltmZfSIZyQHt0L4AGs3dZumniS/05OEju4P2j0HPdu7GYrQFlV7?=
 =?us-ascii?Q?QdWEwaDbptpZbk2MDaigNQ2OifH7DrMufQynKFKFofpIfPWP0ViCWAL3+CYV?=
 =?us-ascii?Q?dc96hnjENp/wbKLTWz1FMwTcIm6lZeQz3f8tMuKxzRFByRFsUkTZcMH92FZ6?=
 =?us-ascii?Q?fzPc0S4Gd8AgxHBvMme1YCFc6fgOQHew7AvGkSdK0U8qDNthAUs/l7fGhbNN?=
 =?us-ascii?Q?ISDPdsqSFLjWU9cn79J4YxJnnLHBZEqKepjy9Z4xAAEgF1RDYGoFQrPDGvln?=
 =?us-ascii?Q?2iXT93syG860jGrqDRDm9rV1ZtyUEospCwQ+/9SI8Ev5LqlAGNoqBjB7t1k7?=
 =?us-ascii?Q?AziNih809Dg42phQcgZ20g81Gu9uQsKBevikdrV0+RNnhUbTPAhd710gphsO?=
 =?us-ascii?Q?Hkhhxahe8usBkbYLhMNVLNM3XEMpP+O0LQbrnOErEbHTNFX/LVz0bIyuNOdw?=
 =?us-ascii?Q?2+3rRnr3xk46JgxBMCsqQms/B/3cKpj4yyaK+wItR371QKYXKUyQhNY1orLS?=
 =?us-ascii?Q?I9hD0u32doWSv67stO9eQYovuvGztsoJsDBQ1/Gca9t2X0RT4MXkuedxSV6x?=
 =?us-ascii?Q?66dPsassws0qtn/ga8XUDV9IosE+eDcNbjdCTLi9YIhxo6ssu9XY7yOUMHXe?=
 =?us-ascii?Q?Cm5d6xg+bRerGgzombYFRiEacxxaBFatkSXnDkBa/9wzefRmkZlZGqgvntwA?=
 =?us-ascii?Q?H2n7YvoF3DEaaEJuoxlPOOsNbtS6Hq7hvhwbvw7XL81QsePSRJJzgDhRllgV?=
 =?us-ascii?Q?UVaUlvT4NrKrXkXbLOakIOjCnefPJO2umZPAfvVO0snZO6Af0B9IPM2Fp1J1?=
 =?us-ascii?Q?f1K0j+MauRH5sHAd4j/gaaZM1OcV9sg=3D?=
X-Exchange-RoutingPolicyChecked:
	LwKIWr81DhBY9g5vl8dJWBA6S42++ESalyPCkDjpsgG/bLTY0Jj9mb1ndp7QgnIV0pMFmfghtdQQcNLMsXHYypD4EPKI+vyA2lhd16t2d1KY2LJSLq8X+kGO4CQuBLgoyHaVZXZTpsXQ4n0R9QLTBML3WfL4xY07uFTz3oDKGM8K5D7JhRVUGcKcX/08DLR9W9eI7ZIisZi4RIWywaHUn5P7TV4z76EDn5/u395M/OqRTimG2P0XAumxAwcbAkBVENi+/kAOsQnDdzpP8MIBJy5myLSR59RaGmNCRkapwVDwNWhPna7Ioiw4iPAqORLlYC4aBsJ1aTancKBW9XYvuA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QgMg6UX8MyhncqJMO4DYKx6BlAS8CPxb7f2h8LdOp+em8/EKggdFzeTrUMkuubv1bw88/PIO9/1I+eZa7VZyxZVN3s3QarZaufqlDr36Hqd6/uhI4EMZdhsZZUhTY4bx0uME+u9/UdyXdJylb+W9y1vWSk3ATxbynm1C1hvA/Grh07SdZgkCDoJ7oIaNAyda/zIuF46h0luVsAdJ0w0YbCnRhunmVegH1MB0WH571ey1+03d2q53DcIwk1sLn81dVUZY8g0RPl6M5rf0iCJu/gy+fB4GT+fxwZvUT8byPVVZFU7guh9xKTap2ySRc2ixG2pbr8+ftIhFUlYwYXuEaiv6s3zizIPRW32LfRMB4h8hl8XAvoGhb3Ic6TjZ3v+79K1p7+IcGi9HZsM/e5ZhTbVzPXPloVkgO4nQrsM8xG+AuswMnkfcIoTi65uOmuJWaGK4DHo5/KnKE5yq8uULdazhioCTgE6S8pg0mkSzqwmjyPHfQqnDtz2vorKedNH24k619vx4FLOLUMWGBzoSwzyixca9TdIR/1EjVjHgxcDt2ujFZ84PNOEoXmKe4eArynzCxglkFk83O+eqmIWvFjcDZHVtyjLpHevVVDWdeco=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10580bc4-9ff5-4b5b-4f40-08ded8ee3168
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:31:07.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0HuUS8B5vi0yuH3/ln8FBmXXkTmYj25UwVC6tZMtuaoCcj/6SJmNgf7R49mUuvV3DWSksRF8QJ10oP3EHiqPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030100
X-Proofpoint-ORIG-GUID: SGhWNjtD0YMpggCnw9Sa3gKgp0bgX7wB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX2IaGsnXd5Smc
 34QGwPpZ7BOaXSML0rvr/j69PSzw0eOm85SifSZqCYkbQIDCYTL4CXMW3+1zWjprmCYhzT5gzey
 uE4z4+U454KwJgu4EvURGaFVUHpEVSLkmHBIzYalcMNtyaI+b9pvPx5OHse3smb6EEZ6jxm8ZKY
 Cubfhzl0fz0b5T3d7u3z8muzFUmdFUjOK8TeScV4YBHh4GD7x5013pwLMcTq3Rn28tItWcHknBo
 Ak5A70+phSnFG22o3VMouozZdb3+PGSb8fNRW2eoPURPZE1TazzYs6daz3Bv4S6LMhtF/m4yMef
 RWgFx8peo9SlmvMC7GLPRGgSN4HB4Re5mIESP+U/eK9DHXwuIiY6JCi9gqryKpQJpuPEUch7jg7
 Z45hmGas8F9/Z/LvonmONL7mcRPPgQPnotsGYQ7yhMwCkao+HZuIFsQID2O5UXcF0bipYCouZ5e
 eUZ3stwk8nDYGZ6Th8BpROUV5v0b+gLWVIuvfz+I=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX8uJvayT0l4eR
 XWl02AUnnM+MHyDf/ZG8wf+hA9POVacKs7cDraCC2DYapTahIOHjv9H6GXNcD0HzDSQhFdK88CV
 oIGq2DSOOyDXFGuVphn+DGE1Fg+LksQbjAOmRyJdevQZvmQ88drY
X-Proofpoint-GUID: SGhWNjtD0YMpggCnw9Sa3gKgp0bgX7wB
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a478f70 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=efw4t0O7uBeM5UPCTWwA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 26d9b17998d66..fba1716a165c7 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -515,6 +515,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -755,6 +776,7 @@ const struct block_device_operations mpath_ops = {
 	.submit_bio	= mpath_bdev_submit_bio,
 	.ioctl		= mpath_bdev_ioctl,
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.report_zones	= mpath_bdev_report_zones,
 	.getgeo		= mpath_bdev_getgeo,
 	.pr_ops		= &mpath_pr_ops,
-- 
2.43.7

