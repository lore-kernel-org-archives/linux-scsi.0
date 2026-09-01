Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3699047F799;
	Tue,  1 Sep 2026 10:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259607; cv=fail; b=ZNnEH9Zzhd1VKfhNmbeVhw26j0M2BccJa0jkf5vn+W9bdes9lsU8cqP/+Li71YgIeQ5syuOuMJsSw6hbp7FrpXkEtSl+xP3Lg9FuQExEX35v8M8l6XUEq0sYmUdIyEFc36syrgu7IloRP0YWJhsg9406G5L1q1VZ+2e9goeG2CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259607; c=relaxed/simple;
	bh=rN4WLse2mszC5fHR3FpQ2K4e8tFydOaHtdZb0/GqiH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ujk7joD6QC+/DKEOh23Z/bduPSxx0U1GYVJRNPe5Oxm1PxH5pJg+95VKafkpYzR0kP8aN5P+Yj0Z9r3142gEO5opqZj5Cfk7IXgu86R85uU/3GgSRHIBXFuDEQUlDqWBnupPH913dKTPWfqmEf/un7SWYONRUN0OQnnoqxQcbmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nl/vpxvN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IB9AAvQE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nl/vpxvN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IB9AAvQE"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCXqn2681332;
	Tue, 1 Sep 2026 10:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=saPm83WRZ0+DozbHl3Pl8xzLBWl4UAdXTBPeM605qcQ=; b=
	nl/vpxvNQnoRz4pQtJqGdV9LWKA1XBRM08QfFXuK3fnV3B2MGg9fQodZg+Da3kjR
	irgu7A20dZE5P25eGziZoLR6IAu0jGqAe242M5lzWiYJDP97D6bgwI7RtuvIJpHl
	4NQ+pbbmCt1sqDHCyeG392Pl7xSguEUx3GqApK/qCSn9axkXxgjw9t1wgzJcoEVz
	flOfw7I3btPnr7/nn3M8Yd+FaEvx+xv5+45LW6ULnVs0HQYGK68D13MCyI/4h72x
	yycA1ugjH5XkqJQIdGx/pxy0EkwxiF/z+jJKnP3PZXSp2j5XqgVUocM6WqFhGL7R
	u4qO70sgGJ3DAZUA8vsVEw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqa7mbyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681Aj5bj023275;
	Tue, 1 Sep 2026 10:46:14 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve0j8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6IoE3zbEf2VAAYL9c1t2EuLlBS6ynvMMtITsb+PUu1HQpOjcbrttdkVwCh33T/7GMBm2eshxWvKVIe56GS+6gkIRe8e2J8VwBmF4IM20gZ5tlVbPIh8Jf2YUbj5cI7pSD7EBClkmhfsY8NITbUQaZwx05Hf28rrjOVnzu45d3VT9YXmYHKMVfbKcR4vpqhDgdrIKcILvp+DlYIDOrfi1MVPy1galQMKisw7bEotcF8Xypkfz3kHim6KD874ViEEsHeGhP/ia7zYJE7pzoyUe9ELreXSHKlUHGaerWY3tiUdSTUvmLzs3t4v8T25fKmyJuc9QNDqbxYOg/nrslj/7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saPm83WRZ0+DozbHl3Pl8xzLBWl4UAdXTBPeM605qcQ=;
 b=o1LtSkabXT8/qOhvaLe6lGmejPGm8ty73RSzooSWckC45gijHLgYSiR4rk3RcucKVzs0DRQtmp+R/XcFGWMrjxH93hiXCenlT3NQIi2xBR6ffoqcUUiZDEswnUrDUwN3LZ1ZMkFqueqpd+whayhIReLEz+av26RlbuuLBUQXO8LHD8MBPofiuP4lS9+ABVMm5/zLvoEGriP/htCGE0H73qD6TH1E5G2yvZkK1qAQi48U88XCUKHFqIeonuupo2QPwd8qbdw862e/csJatbup3UW/AxkYDQxkjwMDHpN1wVrTEntR5DuZJsXY9OCmK53jY7m4fKf9TWblouXjYGW5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saPm83WRZ0+DozbHl3Pl8xzLBWl4UAdXTBPeM605qcQ=;
 b=IB9AAvQERgo7YycxTkRVgi0ljpcNi14gh/JEcsNvJCr2vZan5Zi1Fa6Mp5W2YzWT9DbYypx1oh3w2vePgizRlmb2iGnTnZx2tsf+b3ZGsWcSefFdbxzswPylJT74vRitwDAU9LemQFB0T1wnNlZxuCSXgEI+GxY9DsvGqgzDYbM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:10 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 16/27] scsi-multipath: clear path when device is blocked
Date: Tue,  1 Sep 2026 10:45:15 +0000
Message-ID: <20260901104526.3850621-17-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: ebd9d1f7-5491-4bbd-e42e-08df08163c31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	l3VRSFdWtAeT8COWcpiw3Icqsz7Krjw2bvr8Nsoh8sKpkxZieJg7NFhjsP0J/uPODbhKYiIJOkOZBMX2Ph4AL5Qq1y/RsuQwSJNDtXizTxNVAHcsoHHmdFDeC5aaU3JiBfpeLvA5WshNxeqNxK9lTicsRER2MfPqHhELCNk5Eoa6+Who46kvreuA8IW2dnoZ2wMnQ8q2m/fbg7sAq9hD+S12d8tYicvml/3zIQJYyxmJGPXBAZrjkQy0LoFEPe31Q2jXaTI21fcBcvZTx0kop8UWYGgYuIq2r8cwMiTtGfgxPy82raKoBKJMzdMpokGbTR4Js8BvsAVGcVDvwj4oNeHsDSILzJgXLMSTB9fMYecZ+H45YMDp73RAOFP/kCV83OAbgpfBee0zt5c/A0fOqPDT85qVmbPCOwI7VbaRQ2oN0SCf4QODZEXG/uGElNfoN9iFOgsakwd2p2ejUXw/wJ/JyShOejdKg43qYQsbfdywuvqtViQb0NI6cdqIrMt5mmZovw1naKataZI/40Gv+HNaWx6qNYeIlDsReut/w7WUpi5X/2byh91u9PyiHhl7TQhBu4Hbqpn6rsxgIY0/HxPy3os7Rwa0NxaLQGHnilE8HK7oOl6w+fmY/BuWdNg2tldCC6cWJseAn1F5Triz4WCGU5EiQGXCxEYadKXsqPE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MUeSRCem6z12mnm86KZXybHhNSYG7+D2+LePMoNMTx7CNSUEGB+K8CcBrN1p?=
 =?us-ascii?Q?Rbn9GF8BtRofWiBOeRy+2yd7z65bYjh3pzVI7kr+GLhScQ4EhkDNjdxGo/Ku?=
 =?us-ascii?Q?FApsq5Ym2yfare2o0kwYbvwUZ4EG+yUv+KL6YP98gfWwqHkzUUEUrP9DOMgq?=
 =?us-ascii?Q?X7XkVDMBfD5Rl7k/zk+1wdesFQs6DdbtH/T3kH6oJha/e3koMSvMIelQEnDm?=
 =?us-ascii?Q?KUEuQAKFoBrF1hr/MDpHEJGJnOXgIhH+8K2Nadm6RsKguN7t5XbZpsmfD0pP?=
 =?us-ascii?Q?sHYPGvUqsTUeKO/md1WXWZfzQMq6ymjaJ+LcA+RUFjdjtcsBxppJ8QhKEdA1?=
 =?us-ascii?Q?3slwulq7eyD3H1Q6UzEx6wStHmBbqtGu8YqaIjESiazsGRPCFO+RrZ/BYQbC?=
 =?us-ascii?Q?iWB91k201bfQ7qS639Ovw8Kc7G4x5pCa6XDfIhJ/mIifzEG9/i5I91SqMRwc?=
 =?us-ascii?Q?2EpOt5CQtXlT3ZkkaXvf497iwp48U03qxHN5ZJNch7laxMr/q/EtYew9NRNZ?=
 =?us-ascii?Q?4pThZJ8BeXhNiVtraunGSE0ERII1ME32YuvhREZd42j1YqlKR7mMdRZKPsm1?=
 =?us-ascii?Q?Genqp+kZZjyaZTY8AyOdm11Sj2VbesoMSd1vRdhdvamyALDYBQ0/Ei2AGt8B?=
 =?us-ascii?Q?WH8HECU5d36gqDEWdsNW7atsDt8bFwzSx7KRGIVtq7jdaTTdkB7iodqsQj49?=
 =?us-ascii?Q?nXUCPq/T6/0We86p02NWbS64qdIK1s5ZnnYb5NLVgF/Ilm75FZpIi7yyNF1d?=
 =?us-ascii?Q?G0id3+6q3MJA2cv8baBTCPrft9v6HTICZP91GXh4gfqC4ojSrtfRisiQK8eA?=
 =?us-ascii?Q?iD07Hea9OXhEwuuxy6EdAfBf+manfi1e8CeSr0LSkQuo+bjArN0C8ncRBaES?=
 =?us-ascii?Q?oBi5q+vkLTZUk91vAQgnxPJUEVABkMGSoAkaQ3NCQ+LIeEYnXKK7o/nDL75o?=
 =?us-ascii?Q?wOx65Q4x9C9HBIFliCVzmSre7te0Ta19mO/aLq4W18PXLD6BWWwOKC4s3jBj?=
 =?us-ascii?Q?odLOsvMPHfwB0v6m6t8fjP0Eh7CCIUq5tdm1VYgoB+YYpyMqLPss7bCwV0xj?=
 =?us-ascii?Q?X7odeS37lWbRwMSOdpvAl9HycXwyi9Sp0vGahxM6Rf4hYbAhpTZbc7FGNxHq?=
 =?us-ascii?Q?UECFpGz9Tgj20q/i+deYezxnDtEZt3X9b8ISmovwkvAXxO980ooqstVsHlie?=
 =?us-ascii?Q?82j72rbxd7R/cShQMHrVOnNxGxtUZ3SYWSGdC3CfkFwwyO77ajGgLo0tGYEv?=
 =?us-ascii?Q?u1HDfGHm3zxGJF0MOuwF8fbpsZiLcjGRQVku3N1QbMjB+Q2AWyxSixGaLlm/?=
 =?us-ascii?Q?qJjNEcYhIQyjgp+ibviizIeaUSsfpsH0B2uFWcVxFGjCoBAm3JzC7D6E8+6c?=
 =?us-ascii?Q?GPoHsy0gdSyWoiQURO4ubCsXna2k/RCJP57SFP8Mtw4wC/ZZi40VORtvloT+?=
 =?us-ascii?Q?JJEp4vGKdwBVlIyaz7snIJamsoJfx+FnvEVLcIwDAT+BIKfETkL9hRCkEsnI?=
 =?us-ascii?Q?zdx/L0D/+3btKLewZqjVU0BnujoygztmazrTnCWlMcWSJ6rdtTvVlZpYEGTZ?=
 =?us-ascii?Q?luHsaLcj+HFavemV8wDhwNeWOMFZ0L24IqUjJVu5JdQ/RNgPGaaJbz/t0G2t?=
 =?us-ascii?Q?a0FNcCUDZXex0PMersUaiT5cKgft/ZUfZBNbUzMFBdBtWVUIRk0Vpe+VkZpM?=
 =?us-ascii?Q?GEECM36DIxH+/De3YR7Ls/FHkxr3HiPYDN7inG6ie1V8ozIjB1qdWa1eWpUf?=
 =?us-ascii?Q?QTWwc/yOdqK++xsBKjg31ZrNKNNZax4=3D?=
X-Exchange-RoutingPolicyChecked:
	D/cD/OT1GZLZb6fE3UCpLB+vyZAiuZ5vgs1+uze0T1ktERLp4FC9pCwi/QjocEOpkEW1gkA04WRHBFdiN72Ik4PMs+i07rVgcFwZNnhk3Gj6AyIkY7gTKpogOfgrZ0let1r6TnJSiC0PrWIo73T04zx2wNswH/guVasC/b52QcKw44yt1ae6kWXD2mD0CrupiaBPnuWbysiB9oiYvOSMQGiWrbxyzkvHvFlkAXCbV35DpNYagAP0XjBoD55jMJHMP16zPpq6nS8OiXszwMQ06XQ1I6UwVfyVIiwSAiw5AUna7/8pnHD2cdlNgDI6rorYYIKWXQIUxZXQsOD/b2WtHQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eNX+mS42NPQ19V3owOr6KTFxyxRG/VmswpUn64qy178HMjUFhhb+CnOfc9OOR4Ih3clJG5FgonLxrgOUBq5S8swJa8mSvenYmLjms5qD+bwxBJo0LsZrAFJGSXZVlUBXJ4kydYHwqVbEyCewff+4NPgdHTqclQ9utNwreRYc9WvzP0TsfivB48uJuBS9YbbcdsDeaEpbX7czfgWRKxP/3w4xrh/fLSZZxDaCGzMg1lKOHp7AcEBqr7MhQA8cxz8YmigsWKRqvPlj3ip9FZtOiFiniEfSFBemVewMQ6vI8rUr3lf4Lf4HR9Dq4/9EcYY8taB6x/ysTkpx2PjAnkkg5tNUCEYfGiUEI3EV7rbR2alfk+Fzvg4+oCZV1sHK2j2iUzzee35orpYD9PjTVOXjuVCDeRwgalIm5Erpg0fyK+4vzdBQtDqvoWpCw2weTG9GwS7k0zBneLUrdu42IR3P0QZl+26BrBjMeaVvCHHUutkbUeFkX4EllbDc8QBBB9IkAMZINuyT9khAF/1x9GD7BrOOTtEPOW2je242b/eG177zq//4mkEXNN0BuyTlGVP1GeE2In/JQy713/fWml5n6HtKQTwQxqgyJsJqWPYC+84=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd9d1f7-5491-4bbd-e42e-08df08163c31
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:10.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIUHqQyf/UTAWFq+IVqDAFwbG3ikgtufmDPYOTcDTcrSOryxoOnEXatJG5oGGxbMFgM3yDhUgdPzPSs7srJsBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXxxFjXb57z5MY
 WCQH2z2HyGISbrqJeVP0x906uFZMxcu4dTg8Qwmp9h9CiagUQnc7hC7S/J7B7nkJG4H1VS96IMO
 I63X99bmE4DlZkUA0wGjZ5lWfZ87dx9QfIJpFIgYz14g6oGWq+3z
X-Proofpoint-GUID: nchGissrZSWQ1JcbVupaccIy-s-RZzFS
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a96acf7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=dGdLxrnxUM9qrin9hOsA:9
X-Proofpoint-ORIG-GUID: nchGissrZSWQ1JcbVupaccIy-s-RZzFS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXxlG9MorF5We9
 xSEM6Srzn75gQ9hEje0FpBoI6bC/Ar6sGHPsRh0m1evhftaZXB+Gg8bdRvCwrPUbEIHE3fhN7Er
 VQrL5HnjtVA2xGZaIMAJZQ2V4caIiZgS58o2kk7IDbZmYU6z8qpv7t4vnpwfoxX7IDm+dJnZqCX
 ukO+5TrGTn95KfTFvfic55MKkvzaOVY9Go8ddkUW7BydTzHUyOziWOJVqGVUaCl1XvL1WQR4oon
 SUGIl2Pu4r608ZWrkr5ocTqLk3/ziweaHsfGS9+0BZcsotme3VBgdvUuwzbGGtBQMprkm+CPt44
 r6wC1ut0SOkmOIY5FK0s3R6ss0hCIPwCIzYNjDtsojVjDL0+8JnxGCzvEUgI2IT+Z1AxkZg1APY
 6chyWuvQcjd8gXi8KsKcNY1/Y8Nb4WabIqvZUSpjUIGqMuGlq+ze0pxeVkgsHq0RSoM98HF0CDT
 0dyPpAJSKqb2qpHltig==

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 10 ++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index af27fd3df8d46..f02b3a50e20cd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_multipath.h>
 
 #include <trace/events/scsi.h>
 
@@ -3009,6 +3010,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 		scsi_stop_queue(sdev);
 
 	mutex_unlock(&sdev->state_mutex);
+	if ((err == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 
 	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
 		  __func__, dev_name(&sdev->sdev_gendev), state);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 68fe50f62158c..b16fe6a55fa73 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       if (mpath_clear_current_path(mpath_device))
+               mpath_synchronize(mpath_head);
+}
+
 static void scsi_mpath_clone_end_io(struct bio *clone)
 {
 	struct bio *master_bio = clone->bi_private;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d2ef94ebd29af..2064a3e922748 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -55,6 +55,7 @@ int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -99,5 +100,9 @@ static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
 {
 }
+static inline
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

