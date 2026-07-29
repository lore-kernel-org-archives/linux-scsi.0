Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685BA46D2CE;
	Wed, 29 Jul 2026 10:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322390; cv=fail; b=eDzn78sRDCkKwEBzWq6Q6/p0DSFPpokfXiOsAej7ZJY8V8C8/qRBBeev7O1eINJ8yte66ug4v+DzrI6wKNVlw+wMvOjosNLR0lZU5aikuGbV41psnru4oUoDD5GJxl5zY/Ix5afjb1efQxR6IOigZvEXO0xAQApZ7T9e7cWttxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322390; c=relaxed/simple;
	bh=6xJSbzkMtyyaamPANYzEuXqA4HDet+O947RHp4AQWuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HJDiP3StGGVngY1kPPapsF50bv4d00L4DfJ2yDCpT8qjz0QPxVJp+gUT9shilBHE0HykndZylvIPzWxPlR8Gt0H77QrtFnfr5xE6q5IArURm+IbSSXWAIgewQyog+gVVnbsJW5Ous1NuykXQ/rGp1fj/VBTQy90On3B0l6qgy0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CQERt29l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=THoivIiR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CQERt29l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="THoivIiR"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T8OArD2091526;
	Wed, 29 Jul 2026 10:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pdT4jikPoGY9rEptZbTlXC5WEwYHIXeWLINAcd1jOdk=; b=
	CQERt29ldbRaACIjDfBcYJ+A35/k3UMyLJ4gJUsLxXxcFvXDzLgb1fLKdf4Y4VlF
	9SbHiselm+/w++FVsoKpDz1f0vXt0y78FPP8FEojnsaTXTFCm1tbNaPi+YBsVuEs
	tr/F7i/vcM39vhxnLvdw9IV4Ekd/vlktlBRlIawTWhKTSaBBrxfAAg9fWT4vjGjj
	Zs26rQLYmztzkjOUalZ+nNR0vNaSn/mcuKXZTGgTNbZXKitQPXvn+Ya4hQQ5lcaM
	Yb0IGuOJnSRQmwYfA1w+/2ytOyDvHIrpIfUyNdGmuwvDoRoeNsK9DLb7cffuS5En
	xcGFoutPyu9Uwp71o+GGcg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydqh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo688040104;
	Wed, 29 Jul 2026 10:52:29 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrkm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdikRTWwgpsOZ7iHv5GfdmUxV1TNdGpAzvS1y4Ys4jru7A/TF86RzZi5dLMfFGoODmGZ/OL8LaiAdN/r0afGDKvqTorzQ/nOjIVJ0Mupw3jWlFPBlgr5UUrF4F1s6amIlbL8vFyR9lhu5/vns1ckDkmcQAl+TPrigconrAn4ja8WDgnCUIbq1XhvBnIE4MZ7M3qSJx8tAl2zETjzAaAsx/JSD1jkeoKQHTTWOzL8SyqO2yy0H81cSROQwJXb36iLW2Y2ASHeJQznHrfTGfbin9ZfEWsC0sCg2w+IAlKcY1BhbGiyl8tiKoIrkzz1vMHnWxm4AaBHdwXzJauHlSzXhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdT4jikPoGY9rEptZbTlXC5WEwYHIXeWLINAcd1jOdk=;
 b=mpykE1r+Pm1RGeZotsM5R0skuYa6iQMKg3WMDRqo7uWPZaCSKlGC2zhmgf0r1Cd8MeC/9a7GpjQWyVF7SJdeHbV7DYzkzAw85uNVb8Nst95akqM8U1HTXF5Oev8loLtg9RUZDKGcZIxE7ah85FNshWlzr8tC2zCy5PE1Av0H9Cfwzo0oEfHaR6a8ly1k9ImFLoI941eTYpgE7rORu5kg2hy+yvHy+4of3boE+uIjP2Un5H5Xl5iUyRwbKV40eoWOfqXBCqbuSobDhuTWo0CtvN9kfvgKUx0MqS2yrYZpIlVHk9kxWbNBqMgun3f8KYLUFCR3o/tIjoBKRL8Hy8jbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdT4jikPoGY9rEptZbTlXC5WEwYHIXeWLINAcd1jOdk=;
 b=THoivIiRoEmUtn5110yqD3qkaF3Dunfr0hnLDMFFs/fcJk8Ln+Ghto+YioLsUqk28wrW+1+O8rMIyeof71K3I6exkJLXnVJHlM/CB3G/+Ohytlp3qdW15LOeDZjoEDB/II3z0dO3y3f4YEFuLC013EcKPqKDup3AfrgSbvBVo5I=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:24 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 24/27] scsi: sd: support multipath disk
Date: Wed, 29 Jul 2026 10:51:04 +0000
Message-ID: <20260729105107.255712-25-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: aa64d825-665f-4559-38a8-08deed5f78f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|5023799004|10063799003|10067099003|6133799003|20046099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1rqM3dd4v6YNiqOg0IcGX3KhCMpZiA7hXFcjLxpk8QR+eAanH0BFb2g/kVAQi1XtTbuyoTOyBFOyMzoDG06DaGRPZ8WcHlKm70jFs3pqiNC+bwjm9c9qJlgBIAkGB9QfExFdDwSN7mBmeN9DbwwC3uaM7bdGd+NLa27nMAKnDoPyh6sZsbZ296FYSOzk5imJAFplPwkDzLCFQXdWcJ5n0ZKD3bo3rhsETx8g2OYimWKC1YFITUF8DoCI8J0X2Iv4R/vYZQ9oVci0n/jCkIBiyrZVrtC7LwfMZgQxOqeYt2tqPeAYBs2SV4zolibudXshOZ1zQj4dT1SswmdnQBP90mXZ11g6Nw6dr3ISSAgZLFCjCu2lM75GtDpBOQ/uFn07H0T/+8yr87x58zAYpP3QMQq9R+rOTQAncN7rvgkO9G0XCb8WUbPyF7jsPONUIvhPn/X0oTmlol3Tg82KfbtogqyDCerK+Kksl2bMUvTfVHU20eLpDEQCbPHZnyN2knL31sFmiTBesAkY7hhN0gPbfd19vUFyHtqbXFsLURaYDe0Ws+Gho+jqfOQWfXsprw0fiPHnwgxRT3yhEd5C37NwBr9mXyKlalOBBSF/ntkUL/5sa4SN3I4LUXrojF8cM1HQyWa2hddj1LzH3fbYiIFbKtpPeMABNUacndonvMsh9vI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(5023799004)(10063799003)(10067099003)(6133799003)(20046099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LeKzP5zBlJlQ3zprYVRcTU8+f87R+9Vtv9bDgx2hvsGissvz0Pq2ewwnDiu/?=
 =?us-ascii?Q?gZ78BlAaxzTo0YRvxiNWAnsFzEfgTIiXUNIYvt8wJFfv4BzIQN3al1xJzFFj?=
 =?us-ascii?Q?JGYwEQoB+Fo/4oRTYM2LKqoJoxJfRCtmugqMxPh9oLcVtjYv6aSLjPEYajYr?=
 =?us-ascii?Q?JAW2BbGMzMDaGAkpWg0db1jc1p/sgRFM1fIu4wx3/evhOPSZcNjylpa/lsqY?=
 =?us-ascii?Q?DInQJ/pNaA9ZFYaZE8kSDQkSVPdU4Vje66ib9tavCW1ds1qonMySh9M8Uish?=
 =?us-ascii?Q?pIxmYFNz9PIq/t5FdQqupUMXOnozViOnKHJ/82sBkar5GBxjTpFojA14ckuW?=
 =?us-ascii?Q?Bi3/jP/eMaUCQN8DaecRsZlv/6Rw4Knvhc3tgVJT4dN/3ocSV+kAtbKGSdQj?=
 =?us-ascii?Q?R0sTr7rRWPy1wF7suDTuZpWTHybuvZkZNePxAtK9xykRSLeq30sXeH9fOa7q?=
 =?us-ascii?Q?nCnJ8nblWhfzHjr8ymSche2G/7mI1WVodpJyADl6YQvW4PGThpjnn3LcLr2I?=
 =?us-ascii?Q?bMPW26+QFpeRVQ1h4/kfXwUAaQ7zlYNn5ePYWLInonE+uEWok02Iq/NnrM82?=
 =?us-ascii?Q?joxHTZ2evLFDMAcnJ0y073pobLf9TL4NIwb/xkSRxdlqTA8AgWc0tTlCJADE?=
 =?us-ascii?Q?oyYB3JgyEsSVOKd+tKizuF5TMSnxJgwnGcYpD0gV3MfqKs8o5Q7yod3LsB/H?=
 =?us-ascii?Q?t1RYXrRxbvKWAA4yuIoJxIElb/GwHoYQtcopH8ggeqltBGPn45JcXzSzv3/M?=
 =?us-ascii?Q?sR8bnQrvJnPRJDTElfPsJjo4RlgM9o41BH+wGJ6cHZDm7Cl0iSLLKJGdf2dK?=
 =?us-ascii?Q?Nddqb/gapqlqq+D38svJ9cUqgis/7tKsHgSkQNAeK0d1tYFvFcdqCT9odsVs?=
 =?us-ascii?Q?4NyjDFycQ+rjLw0iQNAYzGlIYHVwjr8WWyuTU4ZeSrvy9eBOjCkuVjYLCC+c?=
 =?us-ascii?Q?zON+LArWPLYESWwvaINvNl9/Qj5IBNxteEul3iQDqfe6M0JgP6lnkllg7rVN?=
 =?us-ascii?Q?hJ4os/clV5YEMLXD6n0aBtr5fO0pMr/E69RluDCOZJqKztVofkd2NdIMFpdL?=
 =?us-ascii?Q?bhBfTV7zZhl1AuyFiNIcpsZNVTjPcm9jpuD04LdV2+kQww28CSZ2Ts1O8wTX?=
 =?us-ascii?Q?wAj9zpVJAbScC0X15T5QOUphUQ/50S0efhtZ8pYQueySeOclVFKLbPDEfKur?=
 =?us-ascii?Q?9Aj2PPWb2RDh3FWg0DmZ9f8yGmlNcXwWV3XPd9fHRLvOW5P79B9wkbxPccE3?=
 =?us-ascii?Q?6amwz2aMJbjAvTRQEhV+xOUwZh4PXV7Ox00TfnLh19q6GLLmRDFXHqdfYFSl?=
 =?us-ascii?Q?5GpcTLh/EhR/qu7JhDJyTa1WUl2SMNbOOSQ7qv6eHfTgK8lc5LEyQnRTdE5d?=
 =?us-ascii?Q?OeBoIPvjO7n6mAyjnPA+c4EIsxDrA0RdMZw0Y7Sg0lX/Uv94UYXBZ7EAVLeI?=
 =?us-ascii?Q?f0o9SPKCztjRiI8scEb1HRzzXAGsInXMN/5qXa8dvHs2ZRzulGcov2zhBZ4n?=
 =?us-ascii?Q?9CTCKpihFbj7+fc1T44fZ4gHNmi6qvjRHAwPhp7aE01Z9ityT8lxkBScFQfg?=
 =?us-ascii?Q?TxrBf1PAFevnex9q6C1CDtV+geWwY9O9JfwLHHeVAF6l/O0UweVqEnbs80gQ?=
 =?us-ascii?Q?J9rfTd+uejl5HEvTs1sTmn0OkMMtJpYmfqOUz1NhrHC8b2g6pFKdCBEeR0gL?=
 =?us-ascii?Q?PmCaHQtLn+9geJ3a8c9FdfjZmjqJv5dqR4HiYArXFyjac4P7ZXcoH1cV5zhk?=
 =?us-ascii?Q?Q6pU9NXQmA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Nr7k+PHW7t8QsVepSCA8M8m5tQ0PJEJMpCPBWN1/sffb+4kiC3XhJiFLd07gtTwuyEsh4XO6wdy6Qk1stk+yqKLt1wVf3j79LRoV9IbrjTQO2YjfNtmUnWePgHNz6P+0x+rnoNkpehqYX6YfhTVVNwwrV+rpiEvapNtulI3+R/7NIguom151Fiq/KxoguHd3GeAfmDenKrHqVospI8DUdpDiQSZsHyBnUNYrcWvTs6Ns4eg4n/3ldUQJ02RLQvJC2gb59Gz7Xa0Nm6b+9iHBkUFGAxXtQ3AppkurMb21gxtNke0Rdn6VaH9v6BAkmv7aNQXfAT9exy6p981Bn2dodA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uqRz/InSh5DcXmFv8iuyaCLeuzWkgeXpp8377Cr5T/okfDIvAxKNRgAzbyt6uYTR3sfP3E4Z81t6vr73xaJfN0NUo+aDrLLMFOC4xNk4GoYSYHaT++V7ymS4hPx6Ud2ScwHqHeCyafF5tW5tT+qjXsGT0cwDogCpawlzW1ojQTftXqyqIJeBbsaOMYL8YYU+wBAdUN5p9NywglyqkpWmlS7BTLOJLS06QMH3SPB/cyTgMHPxSuENX7OhGfA2S2p6D+i1y/QgRrS6DoZgoRXL/ME4WXP1J3R6fbko7s9fCEMKtPqHwF/uFAdSzclKOAsV8PWkmLUMWVdPRJRLtqgDzTRI6pw0xALrckT5+1c+MCBfzJ4Hzd9R89Gzc4/QhZKmnoZDSak8HLTyuqC8D4ZVcyrKva/xriY/SwPCpLahK3BpaXTDkaGzys0H47tmYa+HDGItfK8BeJEgTV7o7D4Pq7EYL+sOH6lncg38IIZH+8qV2bKQQ+mV2hl/WGVSfytR1EH0uysvSDkSIekUBCS/aYA7OXdrqHIQlemUObVDgGG8CX64mRrCOGSQ8Xa9aw9E44iGByEp25O2Z4FxLq4lVoe0jVnJkv1MK1i8hIG/5tM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa64d825-665f-4559-38a8-08deed5f78f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:24.3277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PjrTekiIhrR5Ma0VZtjD3qpNHWO5vphxeX58bJa5Z4Fe/llb6ITiKuLqYvgsZys/FAOwNr0R+vQOPIrP9XLaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX5HFGdtOebRd1
 p8Zq7dPTipabTRvgPoLaMzv5nowFdX7Gy7OeYq1W8uPw/sSMKpj2aAXxUBgvanSUQ0vZPesajrJ
 zPnnzpkqGlI2kcAnLgoEL/E+uVLq0sv9SHHD6IqYlRRBO1vbZtTP
X-Proofpoint-GUID: lTQ0kHir81vPCI580CDcACX5mJP_aNY9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX0s5OnQd9CR8G
 xXL6s59iAT538XT2WaiLZNm0UX+fgskUrzFejlSWDajxNXgq7fYo07AR21mRZiFCoJ8YPgeZyFL
 6uTwtbPZvlY7cPCYsKHEVsf5wC7QBqCa2APeuBju/IzzBp96WFeG5JsBsoWBJ//Kc+4HPmWsQwW
 Pe0UBEwvJBINbhMUnXatEhRgXIhVFi5ghlvTUIJz9uzPRpptIptxDB/SzXzaWiCunp4GhpT6jM9
 JF1a6OE1dk//q8P/3HYjNWLKn3AaEGfouoheCr0GXT+zPeuuAirC+a2ElvE1bNQv954DbunCzrN
 4Epjzg0mjbJSE2FEefXMkgSp03HylHeL4KuqONuw6Oql0EZ0L1VDwMYku5DM2FwEKfzZA4l0dl6
 iuoo1wuYKjxamqcix6czmdxCWKSruPBRYcuB7c58FuuOqevo33vkajTqe4pUxVRgYxyueR9ZhCh
 BQlg8yJFJlaKlyNut7Q==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69db6e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=UnEsLBAWqG5TZJypXWwA:9
X-Proofpoint-ORIG-GUID: lTQ0kHir81vPCI580CDcACX5mJP_aNY9

From: John Garry <john.garry@linux.dev>

Add support to attach a multipath disk.

We still allocate the gendisk per path, and this is required for the
per-path submission. However, those gendisks are marked as hidden. Those
disks are named sdX:Y, where X is the multipath disk index and Y is the
per-path index.

A global list of sd_mpath_disks is kept for matching scsi_device's.

The multipath gendisk has the name and disk->major/minor set to minic a
scsi_disk.

The following is an example of relevant scsi_disk and block sysfs
directories:

$ ls -l /sys/block/ | grep sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc -> ../devices/virtual/scsi_mpath_disk/0/sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 sdc:0 -> ../devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:02 sdc:1 -> ../devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 24 16:03 power
drwxr-xr-x   11 root     root             0 Feb 24 16:01 sdc
lrwxrwxrwx    1 root     root             0 Feb 24 16:01 subsystem -> ../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 24 16:01 uevent

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:0 -> ../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 24 16:20 sdc:1 -> ../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc*
brw-rw----    1 root     disk        8,  32 Feb 24 16:01 /dev/sdc
brw-rw----    1 root     disk        8,  33 Feb 24 16:01 /dev/sdc1
brw-rw----    1 root     disk        8,  34 Feb 24 16:01 /dev/sdc2

$ lsblk /dev/sdc
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc               8:32   0  600M  0 disk
|-sdc1            8:33   0    9M  0 part
`-sdc2            8:34   0  568M  0 part

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 425 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 405 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 36c745cbb2619..f044b2dfaa9fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
 #ifdef CONFIG_SCSI_MULTIPATH
+static LIST_HEAD(sd_mpath_disks_list);
+static DEFINE_MUTEX(sd_mpath_disks_lock);
+
 struct sd_mpath_disk {
+	struct device			dev;
+	int				disk_index;
+	int				disk_count;
+	struct list_head		entry;
 	struct scsi_mpath_head		*scsi_mpath_head;
 };
 
 static void sd_mpath_disk_release(struct device *dev)
 {
+	struct sd_mpath_disk *sd_mpath_disk =
+		container_of(dev, struct sd_mpath_disk, dev);
+	struct scsi_mpath_head *scsi_mpath_head =
+		sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	mpath_put_disk(mpath_head);
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+	scsi_mpath_put_head(scsi_mpath_head);
+
+	kfree(sd_mpath_disk);
 }
 
 static const struct class sd_mpath_disk_class = {
@@ -817,7 +835,8 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	ida_free(&sd_index_ida, sdkp->index);
+	if (sdkp->index >= 0)
+		ida_free(&sd_index_ida, sdkp->index);
 	put_device(&sdkp->device->sdev_gendev);
 	free_opal_dev(sdkp->opal_dev);
 
@@ -4006,6 +4025,90 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+	struct queue_limits *sdkp_lim = &sdkp->disk->queue->limits;
+	struct queue_limits lim;
+	unsigned int memflags;
+	int ret;
+
+	lim = queue_limits_start_update(disk->queue);
+	memflags = blk_mq_freeze_queue(disk->queue);
+
+	lim.logical_block_size = sdkp_lim->logical_block_size;
+	lim.physical_block_size = sdkp_lim->physical_block_size;
+	lim.io_min = sdkp_lim->io_min;
+	lim.io_opt = sdkp_lim->io_opt;
+
+	queue_limits_stack_bdev(&lim, sdkp->disk->part0, 0,
+					disk->disk_name);
+
+	/* TODO: setup integrity and zoned limits */
+	lim.max_write_streams = sdkp_lim->max_write_streams;
+	lim.write_stream_granularity = sdkp_lim->write_stream_granularity;
+	ret = queue_limits_commit_update(disk->queue, &lim);
+
+	set_capacity_and_notify(disk, get_capacity(sdkp->disk));
+
+	mpath_revalidate_paths(mpath_head);
+
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	return ret;
+}
+
+static int sd_mpath_get_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	if (!get_device(&sd_mpath_disk->dev))
+		return -ENXIO;
+	return 0;
+}
+
+static void sd_mpath_put_disk(struct sd_mpath_disk *sd_mpath_disk)
+{
+	put_device(&sd_mpath_disk->dev);
+}
+
+static struct sd_mpath_disk *sd_mpath_find_disk(
+			struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct sd_mpath_disk *sd_mpath_disk;
+	int ret;
+
+	list_for_each_entry(sd_mpath_disk, &sd_mpath_disks_list, entry) {
+		ret = sd_mpath_get_disk(sd_mpath_disk);
+		if (ret)
+			continue;
+
+		if (sd_mpath_disk->scsi_mpath_head == scsi_mpath_head)
+			return sd_mpath_disk;
+
+		sd_mpath_put_disk(sd_mpath_disk);
+	}
+
+	return NULL;
+}
+
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	int ret;
+
+	ret = mpath_add_device(mpath_device, sdkp->disk,
+		dev_to_node(sdp->host->dma_dev), &sdp->host->mpath_nr_active);
+	if (ret)
+		return ret;
+	mpath_device_set_live(mpath_device);
+	return 0;
+}
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4035,13 +4138,259 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
 	.attrs		= sd_mpath_disk_attrs,
 };
 
-__maybe_unused
 static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
 	&sd_mpath_disk_attr_group,
 	&mpath_attr_group,
 	NULL
 };
 
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct device *dma_dev = sdp->host->dma_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	char disk_name[DISK_NAME_LEN - 2];
+	struct queue_limits lim;
+	struct gendisk *disk;
+	int error;
+
+	/*
+	 * sd_mpath_disks_list is kept locked if no disk found.
+	 * Otherwise an extra reference is taken.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (sd_mpath_disk) {
+		error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+		if (error < 0) {
+			/*
+			 * Should not happen as would fail for the same when
+			 * allocating the sd_mpath_disk
+			 */
+			sd_mpath_put_disk(sd_mpath_disk);
+			mutex_unlock(&sd_mpath_disks_lock);
+			return error;
+		}
+		sd_mpath_disk->disk_count++;
+		mutex_unlock(&sd_mpath_disks_lock);
+
+		goto found;
+	}
+
+	sd_mpath_disk = kzalloc(sizeof(*sd_mpath_disk), GFP_KERNEL);
+	if (!sd_mpath_disk) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
+
+	blk_set_stacking_limits(&lim);
+	lim.dma_alignment = 3;
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
+
+	mpath_head->parent = &sd_mpath_disk->dev;
+	mpath_head->drv_module = THIS_MODULE;
+	mpath_head->disk_groups = sd_mpath_disk_attr_groups;
+	error = mpath_alloc_head_disk(mpath_head, &lim,
+				dev_to_node(dma_dev));
+	if (error)
+		goto out_free_disk;
+	disk = mpath_head->disk;
+
+	error = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	if (error < 0) {
+		sdev_printk(KERN_WARNING, sdp, "sd_mpath_probe: memory exhausted.\n");
+		goto out_put_disk;
+	}
+	sd_mpath_disk->disk_index = error;
+	error = sd_format_disk_name("sd", sd_mpath_disk->disk_index,
+				disk->disk_name, DISK_NAME_LEN);
+	if (error)
+		goto out_free_index;
+
+	error = sized_strscpy(disk_name, mpath_head->disk->disk_name,
+				sizeof(disk_name));
+	if (error < 0)
+		goto out_free_index;
+
+	device_initialize(&sd_mpath_disk->dev);
+	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
+
+	/* undone in sd_mpath_disk_release() */
+	scsi_mpath_get_head(scsi_mpath_head);
+
+	error = dev_set_name(&sd_mpath_disk->dev, "scsi_mpath_disk%d",
+				scsi_mpath_head->index);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	error = device_add(&sd_mpath_disk->dev);
+	if (error) {
+		put_device(&sd_mpath_disk->dev);
+		goto out_unlock;
+	}
+
+	list_add_tail(&sd_mpath_disk->entry, &sd_mpath_disks_list);
+	disk->major = sd_major((sd_mpath_disk->disk_index & 0xf0) >> 4);
+	disk->first_minor = ((sd_mpath_disk->disk_index & 0xf) << 4) |
+				(sd_mpath_disk->disk_index & 0xfff00);
+	disk->minors = SD_MINORS;
+
+	sd_mpath_disk->disk_count = 1;
+	mutex_unlock(&sd_mpath_disks_lock);
+found:
+	sdkp->sd_mpath_disk = sd_mpath_disk;
+	sdkp->disk->flags |= GENHD_FL_HIDDEN;
+	snprintf(sdkp->disk->disk_name, DISK_NAME_LEN, "%s:%d",
+		disk_name, scsi_mpath_dev->index);
+
+	sdkp->index = -1;
+	return 0;
+
+out_free_index:
+	ida_free(&sd_index_ida, sd_mpath_disk->disk_index);
+out_put_disk:
+	mpath_put_disk(mpath_head);
+out_free_disk:
+	kfree(sd_mpath_disk);
+out_unlock:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return error;
+}
+
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdp->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	bool remove = false;
+
+	mpath_synchronize(mpath_head);
+
+	if (mpath_clear_current_path(mpath_device))
+		mpath_synchronize(mpath_head);
+
+	mpath_delete_device(mpath_device);
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_remove_sysfs_link(mpath_device);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *dev = &scsi_mpath_head->dev;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk) {
+		dev_warn(dev, "could not find mpath disk\n");
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	if (sd_mpath_disk->disk_count) {
+		dev_dbg(dev, "non-zero multipath disk count in removal\n");
+		sd_mpath_put_disk(sd_mpath_disk);
+		mutex_unlock(&sd_mpath_disks_lock);
+		return;
+	}
+
+	list_del_init(&sd_mpath_disk->entry);
+	mutex_unlock(&sd_mpath_disks_lock);
+
+	device_del(&sd_mpath_disk->dev);
+	mpath_remove_disk(mpath_head);
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+/*
+ * Always calls for a failed probe, so we need to handle that some structures
+ * have not been setup.
+ */
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mpath_head *scsi_mpath_head;
+	struct mpath_head *mpath_head;
+	bool remove = false;
+
+	if (!sd_mpath_disk)
+		return;
+
+	scsi_mpath_dev = sdp->scsi_mpath_dev;
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	mpath_head = &scsi_mpath_head->mpath_head;
+
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk->disk_count--;
+	if (!sd_mpath_disk->disk_count) {
+		list_del_init(&sd_mpath_disk->entry);
+		remove = true;
+	}
+	mutex_unlock(&sd_mpath_disks_lock);
+	mpath_device->disk = NULL;
+
+	if (remove) {
+		device_del(&sd_mpath_disk->dev);
+		mpath_remove_disk(mpath_head);
+	}
+	sd_mpath_put_disk(sd_mpath_disk);
+}
+
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_probe(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static void sd_mpath_remove(struct scsi_disk *sdkp)
+{
+	return;
+}
+static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
+{
+
+}
+static int sd_mpath_revalidate_head(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+static int sd_mpath_add_disk(struct scsi_disk *sdkp)
+{
+	return 0;
+}
+#endif
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -4065,7 +4414,7 @@ static int sd_probe(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	int index;
+	int index = -1;
 	int error;
 
 	scsi_autopm_get_device(sdp);
@@ -4094,22 +4443,33 @@ static int sd_probe(struct scsi_device *sdp)
 					 &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
+	sdkp->disk = gd;
+	sdkp->device = sdp;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
-	if (index < 0) {
-		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
-		goto out_put;
-	}
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_probe(sdkp);
+		if (error)
+			goto out_put;
+	} else {
+		index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+		if (index < 0) {
+			sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
+			goto out_put;
+		}
 
-	error = sd_format_disk_name("sd", index, gd->disk_name, DISK_NAME_LEN);
-	if (error) {
-		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
-		goto out_free_index;
+		error = sd_format_disk_name("sd", index, gd->disk_name,
+					DISK_NAME_LEN);
+		if (error) {
+			sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
+			goto out_free_index;
+		}
+		sdkp->index = index;
+
+		gd->major = sd_major((index & 0xf0) >> 4);
+		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+		gd->minors = SD_MINORS;
 	}
 
-	sdkp->device = sdp;
-	sdkp->disk = gd;
-	sdkp->index = index;
 	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
@@ -4129,6 +4489,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		put_device(&sdkp->disk_dev);
 		put_disk(gd);
 		goto out;
@@ -4136,10 +4497,6 @@ static int sd_probe(struct scsi_device *sdp)
 
 	dev_set_drvdata(dev, sdkp);
 
-	gd->major = sd_major((index & 0xf0) >> 4);
-	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
-	gd->minors = SD_MINORS;
-
 	gd->fops = &sd_fops;
 	gd->private_data = sdkp;
 
@@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
 	sd_revalidate_disk(gd);
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
+			sd_mpath_fail_probe(sdkp);
 			error = -ENOMEM;
 			goto out_free_index;
 		}
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_revalidate_head(sdkp);
+		if (error)
+			sdev_printk(KERN_WARNING, sdp, "could not revalidate multipath limits\n");
+	}
+
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
@@ -4177,6 +4541,7 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
+		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
 		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
@@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
 		goto out;
 	}
 
+	if (sdp->scsi_mpath_dev) {
+		error = sd_mpath_add_disk(sdkp);
+		if (error) {
+			sd_mpath_fail_probe(sdkp);
+			device_del(&sdkp->disk_dev);
+			del_gendisk(sdkp->disk);
+
+			put_disk(sdkp->disk);
+			if (sdp->sector_size > PAGE_SIZE)
+				sd_large_pool_destroy();
+			goto out;
+		}
+	}
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
@@ -4197,7 +4575,8 @@ static int sd_probe(struct scsi_device *sdp)
 	return 0;
 
  out_free_index:
-	ida_free(&sd_index_ida, index);
+	if (index >= 0)
+		ida_free(&sd_index_ida, index);
  out_put:
 	put_disk(gd);
  out_free:
@@ -4325,6 +4704,9 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (sdp->scsi_mpath_dev)
+		sd_mpath_remove(sdkp);
+
 	scsi_autopm_get_device(sdkp->device);
 
 	device_del(&sdkp->disk_dev);
@@ -4493,6 +4875,9 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_remove_head	= sd_mpath_remove_head,
+#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
-- 
2.43.7

