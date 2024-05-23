Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B64171A5;
	Thu, 23 May 2024 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716490437; cv=fail; b=cIcmGqvUyRI4NV8ZwXPziOgbXjMSFPO8w3uQBb1U3Muz5Bl6QSOwNIOpJAbIO4FBdmpqJdea4N9k0X18BLzxH5mBvhgbyXbRL1fS/zJN2Ls1VQW1j1bGZ4G3r0yHAjhsDJsVBJEhAg4eifzSSgXiOdY+CO1/9qVdtz9OYbIUbxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716490437; c=relaxed/simple;
	bh=IdlyLLQa/l3HKJrvTzk+mu/nJZDsc3b6sfSfxiV2MZE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=htJqfrpX6MQhuIoU+xxlNlHdbuBxtgjpDhagvXmLTw2Jyg8BlydCkXyYiXsYcllSCGcIp+sx8WMZZiUOdNWfNPDUtZpWIs50mGbIgRKZOdElkdov9NpqUeHQYkBiV8E1kW2rxk/0lydR74EbHbeVUQHQaDvvTflXyaK13ruPZLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m9JkVG9R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DW+/9MCo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m9JkVG9R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DW+/9MCo"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NIl2pV007177;
	Thu, 23 May 2024 18:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=+7yvjHoDZdEjm+isdPT0OPO3BIGroV91ioqPWt05Tac=;
 b=m9JkVG9RWF/hJOLYW4Pu0x6McwDE+rVEusLXG5DWHL/l3XjL83RrfAO65Cpi4EusRr5I
 ouTB+E65whGx6EwoaQkT6Wh7TseubtQc6MCkx0XuGcXTciw+b0rlfvrXIjL2I0u8STt2
 NGuAqRA4XqEXmf9xjz3qpJOhchZLj0vMf5qkFRvStvk0NFSx+BCvzMubr8KLoOjg6HkI
 SCM5O88Qzzy9n938jHgLoeoRdFTQeV1/ftcD7R1n0BsePwbhy6OSEu7FJQyngg/ZmkSA
 sIgy07IHlZMhECUAJ/7f1OG0BDlMtlIn2+NV/gWIbp7NkN+6KIIq1urWz6COpyuwVlJy ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6m7bak8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:53:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NHFCCV037823;
	Thu, 23 May 2024 18:53:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsh0908-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYaE3DzHM5cWKI5RYuvzN46g5aG5CEEigssXr153rrEo61e5e9Qla5qaHUZanxUc3Uo8ITW/9HJIKpjgT7X3d56/iJsocAMogyB4qYMYK+wWA5+UQB9L6f/JET1qE7ReEepnLZ9pUzx2/fsvm5Oy/yauneOCFAZk57RWfBG0IaTiqmXKDwu91QoFHF3me+bpImsZdf0jAi3+Ckbv5kCmcGCVuaCop68iSkzkp/+3dLJx6FdJFSIvalgsGEABnaGWsB9dyJ0GKtAyoH09269p2uwaKBy+NjK7kt5jJ7AtFzgzXlK95s4hEUplyCRHifskaiJp8xzeX3HbNqXRWL7KeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7yvjHoDZdEjm+isdPT0OPO3BIGroV91ioqPWt05Tac=;
 b=IXu1A5iWlYyrMtiS9u0Xh1DzKA4j2fkhrb+FBhQLy4QEAx28DK20GGR7FjPwiTQ8FHKGNkFDWHLtrK5ImYgdkVsr9IT89T2Fsb1mjhTH0RhzgCszawZTNEUnSgMBygS1m1hICKk47at/PrD1Mi4EsT2iHVl2ZnKVIiQxOpDemwJrevUG+606Fnze7kEZ2HkeL8D9Da/Me/UsSmhBd1eTexD+56fzGSDpLhbIevD/XvbOUZadWeDligHeTJNlZd97f0EJSnCksGpkC8LAhxJNysVh91ZWxWcdZLlIspr6IBCGF+QJexbCEpMcI6rA+Defg+dln4lys4zh6C2EvRkscQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7yvjHoDZdEjm+isdPT0OPO3BIGroV91ioqPWt05Tac=;
 b=DW+/9MCodX28j2UgI4XFgtLey7lgsOybx9SxfKiobt/3RhN7mR2NtlH2K30cS+N+JucAO9SexnxM3bzEkOCxufZpTPImeosSWJunYYPT/YvMZHRimMbFSFnoUJWyWzXdE2mh63jMvLzeDsWTH1h62YCMTiTVSK0+IaCtKfhC8HQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV8PR10MB7799.namprd10.prod.outlook.com (2603:10b6:408:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Thu, 23 May
 2024 18:53:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 18:53:43 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] sd: also set max_user_sectors when setting max_sectors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240523182618.602003-2-hch@lst.de> (Christoph Hellwig's message
	of "Thu, 23 May 2024 20:26:13 +0200")
Organization: Oracle Corporation
Message-ID: <yq1o78wjrsw.fsf@ca-mkp.ca.oracle.com>
References: <20240523182618.602003-1-hch@lst.de>
	<20240523182618.602003-2-hch@lst.de>
Date: Thu, 23 May 2024 14:53:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: CYZPR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:930:8a::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV8PR10MB7799:EE_
X-MS-Office365-Filtering-Correlation-Id: 52b5bdeb-c735-4339-4107-08dc7b59aaf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Qu89BCUNT2+Oqh9ab9hGydRcF58toeT/h5Zur7930MHImoUWt+h4eLO+1GjU?=
 =?us-ascii?Q?OgRby04yfr7JX6R4af1mAwMveMkU7h8qui6ZFYVfrD07LMHkgwB+FHe8xiYt?=
 =?us-ascii?Q?lmaEktB2aNRVaW8kwIDZqGbFcbyOekAGtXBs1vq8mvmBoFtcbxt25pkA4RoD?=
 =?us-ascii?Q?p0BPWiskL0uBk93YEf92c6XPMFXS8BLrajZ2SUW4C5T6oQsiLqz/75+iIOsX?=
 =?us-ascii?Q?0Yi598nrvYVfhjNuSERFXj+kc0CVECfVQHQCngVhld+4tAS4fpsa9zKtbRxQ?=
 =?us-ascii?Q?i/crTTHS/OwXNqLdQeAZ6j5TObW2v0i/agbwHsDOwlgaQoUnduL14J+Zj3Tz?=
 =?us-ascii?Q?VIobSqUe9dd53EU+ixr9u2rVj4dqOyZKJgP6O/kx0TKrdMkiaPHExMIwjSDY?=
 =?us-ascii?Q?TjSjbiADWvmLUWeoUtn2IBefALck6PkzQlB4lpvyVuwvIOFLX7JgI0R2Y2YH?=
 =?us-ascii?Q?Mi6ATWUTFkCQ/YY+jcPeKt4vju91lkTUYJj39NJ1p8tfJBpaqpaJNhqYV0So?=
 =?us-ascii?Q?osarmYcUkmJlMjfXpUny2G/0/ua5jaaRX7qjDVBQJw4UNAhWK2LlZxj5gOP6?=
 =?us-ascii?Q?GwOsxsNg8jDhtcm3Zl/Ytm2+7anuL5VNS2onFUYQoIz3E/UNeBmMWE2zHxzD?=
 =?us-ascii?Q?x2xVpSmsJ69049j+JqNIplXO8j3SGh5wXXVDVkNpBDrsGvAoZHCLsDNOjbmO?=
 =?us-ascii?Q?b18KcFi7kLZn+169u4hc4To9Iws7wA+Q8cfKbGQtBt6fN/r4VSC71CsoIRFb?=
 =?us-ascii?Q?fdsxIFXZIBpqSL8yM6IJhehYDwA6D03WbkgSOurgvsthffkLmwIyQUZFEq+T?=
 =?us-ascii?Q?XjnoWfn5EYHIJwTbu+Rr34v0oC5K97mNuQDpecLQCrtn0y4IBK7bwTt1avLD?=
 =?us-ascii?Q?181aMg8W4kIOgwvVtIjQZZFIfo+n+HPmqBlmuS95RgDONUnBgXXxYIqcPGov?=
 =?us-ascii?Q?RciThg2+35lXet+vjcGWY/KEluHwo9bsRZxCBqfB07EhLcj2XAFX8+2Ebsk9?=
 =?us-ascii?Q?eW+/5Xdrhbe4oO07UTZnlu0TqpSEsSpRY0haKthxQKihexim6CgdTvL/3x6V?=
 =?us-ascii?Q?Wg7waLthl0fxA7GyabvrvQONRvN4ic1TcekWpRIWQWBKaBaxqGeR1fkS2Rvt?=
 =?us-ascii?Q?47BH1iDAqqcEsOinypJI+xCh9g/ZnPZuAH5C3G5EWxWa1aGHRO8nve7Z0PXI?=
 =?us-ascii?Q?YqsZPjq/pUMP/8AKQulPGocD8uFh+71NiVlilKyj3QLWEVwsosf6Z+VzSEyk?=
 =?us-ascii?Q?F3pn0ZiQpqj6ACX2tRWCEUd3wqiKK5RANcoM0p2FkQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4lmspZF9hDtoSkbEjNqwMpg+hMr1S8/TyFp8Rs7C85AfRlhJweFhNC8i6iUx?=
 =?us-ascii?Q?lIytuE7RSbxM1ydHq8g/FbJuvi5U4WD5ATmrLXbBqpYAiFN73dRwltS+GEbD?=
 =?us-ascii?Q?FUeLiByw+rInAWctMZhNkZii9dja7D+eNNjuwMVr7G7UOTvxAi8A7gVDGS00?=
 =?us-ascii?Q?E/mble6dKGLtWVWtGXqnHVR/gFQToHBVd8ZoaH6B3+/IYp5VbSC6XqdIj8fE?=
 =?us-ascii?Q?5i4PkKXIko5pB1r97RBlEG2Zx0Mx3ygDd6OXTM5IW82vBxPw2RNIcmLKGJnf?=
 =?us-ascii?Q?aLSMI+Hb6WgwMbQblpPaCQCo8xZiAnGdttFnUqxet0OMhbpLJriUKmXo3jCS?=
 =?us-ascii?Q?zPc4mneRlhAqxmyOD7/HrPCvUgJlvfiiFR14fmjBVsHNSX9B6HtdYqLsyNsS?=
 =?us-ascii?Q?o4OyLNs9K4uWT/joseyAHFgTqA7Zd7CjIpCNF0WRqeFjNtrxzaZGZYjIINNn?=
 =?us-ascii?Q?pJkLUHrL0NqC3eNv+bhOcqdGSuV15tVugpb7qjX3Ytvbe7C8SrrrrCcNPwOO?=
 =?us-ascii?Q?Hc1am4rGdjwea00chElWVBIiyh+fDIaaRd0Yfm51YbtWmoznTzTJvPaGSgqx?=
 =?us-ascii?Q?zYVZDWgRT+Rhxg7y6R3WB0vDNG63gMo1pcfQzgDOBuPGAiR2wDfjiisE95T2?=
 =?us-ascii?Q?YnnvECD6TyL+j7w1go+RYRLbdAy9rtEy14oTJSqCgsuEi0HCypTcg/4Y4SaA?=
 =?us-ascii?Q?bh85UAbB6jGfGc7zh9lF1wNurF0bV27PFBzDGcjeinRYkMe7CiIFDm2Mo39m?=
 =?us-ascii?Q?XwoKuhn7EKjV/aPILO1dtZ82ipGyjm8dEyqhKy2N+YPslX5uYr3RB9S1kJT7?=
 =?us-ascii?Q?0X0JodQu9OcoWhPRqO3yuWYXwBNeTq/lQEQPDTO55jgxKcSliSMlC5Ug47Hu?=
 =?us-ascii?Q?b3x6hk3dSAlMfEQlnr0P4scpfybzCQE9zqPkUQ9qk1IpM1F+JVMcmsBiSUFJ?=
 =?us-ascii?Q?gJSbZYt949hISQEGfdcnINkisYuxAlT2Zz1P8Jf6IhRCNN5ztjK08oyju+sU?=
 =?us-ascii?Q?NgzOUwWX2bCwTR6Rakg9bLqBiY/qxaGyBBPcPJdqyOzpWzuCVaE7dk0+2fbk?=
 =?us-ascii?Q?9QldFye6a7z+lfx3ezTcZL39L+jvYD8TCUykbtZDuoKtnDrXU5lwp0FwC/Fu?=
 =?us-ascii?Q?Pvg7n5CDV6+rHQAvCW8M3ZnZfhiDzp7zYS0GDfhjE5L0krV5B2IVbxrVxpFj?=
 =?us-ascii?Q?gRm1IIBS4tlJgodAYzWb8s+ebs9KzkxLytJkj8VY3sIZrtnGT3seMaNUoT9v?=
 =?us-ascii?Q?Ocnhjk5e/tg5ln/W8MS6WlQ1LVJyOimxpg4gxEez6UeUC6ydBAC9a6MmXPLQ?=
 =?us-ascii?Q?xGQ0ZmMEizVc+KyJxGjZEorR1YdCDhy3ETAFSsv0jz4n2KJ1B/vUzpIk07FH?=
 =?us-ascii?Q?Sg0vsf1iRXkbxZmsILpoF0C2KBh3JqBz+WJCOpebaB5veg0xRCENj9BCRRo0?=
 =?us-ascii?Q?kpcMF29ntvDAMUbF4XGr5386D268P0tgO/rC5y0TCKcPFymjsQNiJ/HMRNUX?=
 =?us-ascii?Q?XnxAzTs2Dv1qPOid6R/U1WYMb432NreqrheE6u7Cwy3jdpoaFKBlEndh7Y/u?=
 =?us-ascii?Q?6lMQvN/46SfA3T1p/IW8uStBAWy2uYb1BsEh8uz2dbTYLaubCiANditSF3UE?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ykbrARymbPnXWqWRYL8BH6Vn3zhbkgsjkUBYasols9iO+qf+Gt7mzLWVt9hWtlwMyEBQU5L9Vxn6UcCgn8Dk9ysgZ4/q3moyeFAvm538R5YdysW9KYexOzLdYMEbIgn/I33I2aI/w3D3NYMOUNUI0bJKt/bnbnoMCzwgKczelq8eW6wnAGxcY2GfqSAq6FTxPU5Dxqx4Gn4i/kMX6JR2cbaqdbeHT2LVZBW2UVG05iGjESvo0uRzwI/Q0339StjQyCQnCxdK650zUJMssWr/9IHqOOWffrWrBO55FFCu2ORq8sRfpuvTHxXD3sgER5dxbvDgYuvGKfsUgW4MG/hh7dsMqEtGHWkIx/J8BKXZH9QgjeDwk7fHdbe3ynqnXnrJwsIjYGxFat0phRrbhPSHNOiCOMjdTOk6gGzfcIbFw9xqUmNvWkPqFTdKSjMQ2ISFqKuav3MiHXXMCp/V7byNFe+aApYNmxV8BOSOi5pVgxWqxJR+WFcQLYLjEJYRIlSb3unMuRsqRMsQ5P5rfbTnOV1BWDkmKZgbBoM5YD/1Yu+k4uy7gNvSJGdv9yWSRhRl1O5ZhnnuK1CyD6BcoJlxMvS6gtsDzIGVpRNkcpoJ5po=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b5bdeb-c735-4339-4107-08dc7b59aaf8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 18:53:43.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsz0RfkjkBWRw+DOGth1Q15/HYgVDesRrPoZ6izHS5JnQrYUc7ogDZ+HyuWxT3GuICjKdhAWWRZ0/kiOcB8Ge40lk5QEnihp1mCXrk3qvMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7799
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_11,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230130
X-Proofpoint-ORIG-GUID: wiTTvpTtZ3umdB1eYJDbCgeOkj3segZ9
X-Proofpoint-GUID: wiTTvpTtZ3umdB1eYJDbCgeOkj3segZ9


Christoph,

> sd can set a max_sectors value that is lower than the max_hw_sectors
> limit based on the block limits VPD page.   While this is rather
> unusual,

It's not particularly unusual. Virtually all arrays have a much smaller
stripe or cache line size than what the average HBA can handle in one
transfer. Using the device's preferred I/O size to configure max_sectors
made a substantial difference performance-wise.

> it used to work until the max_user_sectors field was split out to
> cleanly deal with conflicting hardware and user limits when the
> hardware limit changes. Also set max_user_sectors to ensure the limit
> can properly be stacked.

Fine for a quick fix.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
