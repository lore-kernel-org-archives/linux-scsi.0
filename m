Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7882347CA94;
	Tue,  1 Sep 2026 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259574; cv=fail; b=uQXV12Z1vKmryMsjGzlrM7wEo/RdEDoELcn1QntcJAFLSRzxjgeY9lR8HLLigcJGtK90r/jU1tz2SdmgGhU9SyVtkxq/pXAK8TRZ2EiUzuuVQn227sS0ZyBQEALzFkx1DbABq/7yILN4Ch4U/fYZ9R5gK2IowsLuC4bKnbb9NWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259574; c=relaxed/simple;
	bh=Edo62s8j8b8nwQ4aHgilEN5qnjwYHbVl1kCEaSaXRNA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QpYcemBNAqpYWGKbDxGl5MCBi8c+XGzGqEuPzdlrxIvvgasz1qFkniKpt0rAtwh/pbpl6zgtMeBM8trTX87eNpbTE1uN0ZEAhG41435cpXyBdUdSDjTrcJ0X4bYJ7ORpAOz4mr3K5bV+iU/mHEZE/IAoclbFusmWUd8fJ49/1HQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f1jPFkSi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P6JDHMIH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f1jPFkSi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P6JDHMIH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6813SmFf3308103;
	Tue, 1 Sep 2026 10:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=RADppwjjPW99CxzU
	G+dL66cxE6KZ33i47UYK/RQ3xbM=; b=f1jPFkSi2mnmUG6qVdWVeneQshFBqP7E
	X6lmvgdp2GSUWKyFKXvlvxca+REovOfu+5ZYCP5ykBo3DTM8YLtTR9uuSgkthl39
	MInmGr90lR5A7IRYLHipPds/SILo4grP2dm/tXxuhTH+/FusEw7mQT4GUcJ1K3g4
	bsjYGKDhfEAgPYVspgCgP5VkDiJMDhdOjp9w3gjpQNydyVqzK4Ts114FOz6uLR9D
	u3FWXRwff8C2lrDBkEVodud74+ZeI5KHP20Rc1anzIbpvt7OfD4SF5t4dwf7gBTl
	MdnJgkGBdHPI1UeTZAXBhObmGpaPy0orluzwaQoRlxXZvxJuslTy5A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqa7mbxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjMx4037329;
	Tue, 1 Sep 2026 10:45:42 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve3463-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pkzCoEzxWCJhFBplvYCBrNMSIZzF1YKoLiS9WRqDdRQ6rtWtIuRDpTlNw7TnZ1FH8uyLRdX/HdP33u5oC3E0SGxLNSauRI7SjQQ05gScVsI55pKZEac20Ox4qSbErrGpT/C8aFMDayj+AGeDDrFkhUtssomylSRS607LoJAqLT0tnfEGE8yIzriFawyd/m1EoHyu0MdHmqlTByzVIWVLldBSLVDsWzeA8Ey4IdjwdfGKxZoTAnn8FDC3UrDJY6SaLadNqQjg4gVIVillKz5jG9NZeFWjVld41WbqrElxeOxwucidjUaOfBWlx/JMvHz5EgN0nIxV3R/x3D91phmYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RADppwjjPW99CxzUG+dL66cxE6KZ33i47UYK/RQ3xbM=;
 b=ZMzoZzCJ+zhfdpd0oH/IKaMc/uqW6NrZ+A1EUG+frx4UekyMxSWQPi0+kRlpN3zPeMVTkjZMs3C7FO7it26yGcmDYp5Brs9VBLvYJGrgIFfYAaRzce8KgIJr2X3gjZpB53Kancme3Ger7t2oGntpmFqh/2vSPbd/4RRg0ctRjt9DudjEGpZTFquyjSsAilZuw/0wNYpo+Wk44xo2dS7sRpFEaTZVIid7/rT8pZ1HCseM/dI3Pb0+2PYpr74wilt8qSmEWtoH9W55khL7TeVXVJclWCEVHSDhVDr8WlgDxyEpIjj5XvdIVoH56lQnpMYvkmwWISLPgWiK2wWGX8dCTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RADppwjjPW99CxzUG+dL66cxE6KZ33i47UYK/RQ3xbM=;
 b=P6JDHMIHu3bn6NmE2MyNAeChnP25eu5xk7C5lcp+q3eWUuCjo7ba8tsAbgcDUkIgwZE5/uW3Fc+HFQ2DHZLbXE65CRLxSxIu1G/rOsOK9sCKqQNugEIULLPx3l9f8jRHBJ4GsQuGDtVNUQbheUGcXXxenDlIZMjqNNI8JElKmPs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:39 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 00/27] Native SCSI Multipath support
Date: Tue,  1 Sep 2026 10:44:59 +0000
Message-ID: <20260901104526.3850621-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0034.namprd14.prod.outlook.com
 (2603:10b6:610:56::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: b3b2cc81-3ddd-4a85-eefd-08df08162975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|5023799004|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	IwxLq/syMhL82lbjreqWpEME794O9OaPCcBYWPu3gFkRl1jr+3bwRrDjQQr1nzj8oGGWEvyA7FfcbtLwf96to0tPiwmTKiYiLMgPx9bBTmZwPSIAWCkaKCmzkY9ALTBkBJg14eIWHi8zinfsqrdgnff3808MJZ5mPeeLPjyYovTiJnP/CocFYSvhNDC45h75ADSuinmhSiByNz7M5et2kWA/+gvHfVUNI6qDMGLzm2U1PUzpev3bShtMfjoQ17U5PLQhNFCWqLlil1HjW1VSAHcuQURdXtobTS9OBorwMnFSogBo1uoY9QLEBrHc+g62Yb+EVvbrdyeq/X0xyFuPz+45PVCAB1dBDPsw9qIyX9FR4S7XfuF7dangcSG+Ga75eKi9aoGkq5HeP8SK6gapkoTmSPKMlDuT266ZDdFWuMidL8KFqSbJ5xa7PT8Q9z6eAc2cHjyBKtmmNNxampkZyJFb5mlV1X7HXupAOU8DOsecdl084YQtQOZOAf0jKMr5XjSeV8rKCdit+tXcE6ZLY9d3ONKaA8WsDbLStDlwE+3W9hrR+SBVnWG7seaULDNwWIHZDrwos1LX6JQqOc8xcbgojaYg1emQqHOL96pu5r0iNiB4Y7yHKI1NFrTU+PuFdAUPp+FdtBOVKejVSkLYCeB5jLot7yAO12pKBp1JQnw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(5023799004)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0KGINM/PbND6nuTshpz5Yxh9sYVUvoRaMdyH9ALX20as6VoSYNyjemBsBwtE?=
 =?us-ascii?Q?ZMcu65P2hqftxwBaepbAfVjzE7zIdYtJ1TYw1EdnvBJx+HqV8Z73i18AYHGj?=
 =?us-ascii?Q?ahQ1Yg6g3WWkNlL/ImFLW/KPSKs6AnW9ZWIAp7wGoX+E0Qtv7KfWE/0E1XCy?=
 =?us-ascii?Q?dHu50nX/PAQhNCN4fW6hpEURq0babRRTnBXUHjQxO0XLEDKiWeyP1mse8cVm?=
 =?us-ascii?Q?X0xYn3Xcq8ZbvC3y0OpGvSMhRR8irckHgNOsk7cPhf3DQlK0DEJEMq2lNq0W?=
 =?us-ascii?Q?p/9c643BolsUstg1KOYlLFzBGmd5Pk1tOHv+iaDj5v4Qgl42gJV7Mjc63mkj?=
 =?us-ascii?Q?T66/SSsUqiQzeQAQIX7R9p1nsN/+JOtKuBC+6JnNUO1+COQWYw6/x5uNiM5z?=
 =?us-ascii?Q?xKD2oFCjO9dzHH7oxGACr7eZhmrxGkyxJX4S3efW8YKpkAE5Q57zB/w+yAcX?=
 =?us-ascii?Q?hg5cw9rw3/6+W/fVmusKUvmd1gINgNDFgVKmTbyMp4zidBjhm2gb1mCCEzX4?=
 =?us-ascii?Q?XrkGyzxjmFvviKrMym0c9XD8YTPv5P/3Sv1klAOIGVOrZ6H57UDUR7Uampkc?=
 =?us-ascii?Q?SJ6yDoPcUNKbwEe54bLcXZUa6xfLMQB4MAhy1vwlqIXMpFFq2xZOrmzE4E9O?=
 =?us-ascii?Q?XELayv+K3JgqqDVhMNCMVNUTuxqGf7xgjD+IdwCBhB8auctwqWc7n3xPhA1g?=
 =?us-ascii?Q?eaqIs6w4XQ79Aqj3OYtgvp6daHnMqcusAFYCxEIBEoiX28+/mDnO4mDqNIKi?=
 =?us-ascii?Q?LqzTScclY9NSqsBNzzjx2Ow306Q3E9koDSYJy6TLlztmBRYAqzo3r5UGOW+p?=
 =?us-ascii?Q?YFT28XvrGfyhZdMuFJv0ttFlD7ewAEdwMs/Rh1kebdUtXVfJpvapIPbyFaeL?=
 =?us-ascii?Q?ot4+N5UbNzJM40sYF/ohAZ9uJ6iLJ0k9Kl5cnCc8BljREo6OTS4U8sfsAyNp?=
 =?us-ascii?Q?C6R6MMx1mLAMHviAvtQIETWv77vf19EviVBR2wU+6BqjkpcBiSq+rS/bJIea?=
 =?us-ascii?Q?kXWZt7gyR7jNvCqRqwIRGtmw1AbmSayZ83ZfedyRe1wpmOeaiF/zINZUzni9?=
 =?us-ascii?Q?cG72n2IUTWDVScKc5g973OXls0MvCvCa+rlyTvbPtdQM9rusLb1HQn4TE9z5?=
 =?us-ascii?Q?L5hWCFKWAgDV4/yx9JAdzNpyDxdX7f1f9mNrvKDauZybX19F335ElK+k39Ky?=
 =?us-ascii?Q?e1u2/eIidLFZwWsAnPyNCQ5iQpjzkPDK1awi6ws7hs7EU9dPVOFD+cHnE2IR?=
 =?us-ascii?Q?uAXz3A/ESMKbTHwzjZML79GqWLB4O3UD34vva2dVLw1odDfHWYXBw+ri1KAE?=
 =?us-ascii?Q?YAj5oYLLDht/G//JE6lvzxFvi7+EGBekIbbxJ7zqfjUiyxmNmSzAq9zaRAag?=
 =?us-ascii?Q?/uAHGMSuJaMgOgOR4ApNhKiCJ58dZVqjgBBVJhNTizlX+ZIFM1jGPjiY51+L?=
 =?us-ascii?Q?w765GChBf+8z+RkEKhQanXbfCQOnFKFMMFeExVAnYio0xoN3/tjbst6Ururv?=
 =?us-ascii?Q?hGV2Mggwh+V3yZtCMvFkzHHgFzjRZm7VDYEGaItBQyOAt2t1sj66sAaHQJR0?=
 =?us-ascii?Q?8YlCBDfeyfcIv7ZTWAy5fTqB7aq51XJmCRozIIMLD3netJfy4mCOFqBdXXFa?=
 =?us-ascii?Q?zGrGdwKS/azC7ZaI9uTA6FbYCZDUMYhkFwJWPswj5aS4Ijzv5ILfYlazXwvW?=
 =?us-ascii?Q?LBDa/WEpuvgepVXQUktaArm2+ePEEo0xZfrMpurQppzCryetzD/bUFYgOCDu?=
 =?us-ascii?Q?Au1YA6iPwh+sBHH/xiWmJ06I+vvw1xw=3D?=
X-Exchange-RoutingPolicyChecked:
	Sneg6vgM3aB/Xd/B4dhTAT6byskwN4mgRGdWnfHJo4R+8ubYo6S6lNWyP8Urst5ybQ0mvckYMVNOEvWoBXra/wDUImMj02Qm/uESjylX1hPyxpX7OIssS0UQIFKb/lr1jeYs48SLgeGgqhZ5tf42Wlk/F9lISCx5OuPm3ZDveAOAwwoCW9EIKTeACbgAlsZA6W5tUTGh3amhe8eiws8saZSHQ1MwKVKXvNO+pclD+qN1IJ1NHYTmANN1ftm94o2P/nQfN98VM9pT2TU0TPJfObRoqz0bqQN5Tqhb0q64Z+5DLYV5NZODDTqmh+2/ivcX6cYG4/9VWmBcvLkb+ppAAg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f9MKorJkJLThsDt91cXWXjYdZkeLpKFQNoYoCejyFKqiyJlgLdbFNMXng9LD9Qyo5+eoTQ4iKRekQxAqsLUeKdX8QrZF+n1CjZMM6Q2UGxFXRMnkE21GMpFfWd+yC6OQfFzdlO3yDYi02CCJdQlYRjzZYjwQTmimsFiFj0vEgT2Pj8JBFWvjYQPOz0vhNSYbw27O9vTR2r0mUL2pbDRJYw6qtQZtMClN+nbwxFDp8kbrSa+lp7ignkiMxK8dN+jYxVkz+OydNW4w8YjPDBVukB9KYQDwEmsGrF7maQ9D8qXYsYgarFtVhXeMcS4THtmjPov0bu8OCh9esRbWTpXAeKWHZRp3iECww8qCFpkq9KkX55jWk5pwwXFZPFFuRLTnoJck3rotWAT1Ux8Sr90L6xH05PGB9sZR8pNBOOBv95Td+RvY16Yc/mdf3gp1PPy/hWzu6d8aqIrel1PYV6WM2S0UDTcWMMuUOezfYky+nfm2LdgEzD+pt3IaegyK0E5VMzrtKpZph3FDR0wzZr/CQZG82mGEwfiFT2+Pdgs0+WlG+VKjvzu8plox0CGuC0sj2HNQJI1twMsDXQ5Yd+7PNW1IGwYdC3kvxxviYT9pJto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b2cc81-3ddd-4a85-eefd-08df08162975
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:38.8896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hP9Ryzcu2eOBD450BQoIlUbj6jnFuc+OX+JZi9JAsBMs6f4lW0ExRM9twleWKwyugi14tJ/1gSSgWmgMMHGqsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX4p4CFB3eeDjM
 lF4ZYdVIhfhbILVksG8ZfuWt9dWlVs/eCoc+O9MdxOWa0vTt0ZuVfM7JTVCLtYu2b702/YeVyvG
 o/RTA+R/QP/Nt5sj5BRRaliZCcf0Mj6/DjXELztDy0/hW7sGNzp6
X-Proofpoint-GUID: zExpvlvF69sQO40Gqn2yu4UqDJ4gstWG
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a96acd6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=tPCbtmrUit6F0t18becA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: zExpvlvF69sQO40Gqn2yu4UqDJ4gstWG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX2noGfUysr1yI
 XapzIDDlx7/U0yQplF5QaSTUZKCyxqv1T30THWxN0iVtu8CMCxHCXj730ttFVLP3QLFKBuUpwno
 Z0sXtJuHzFX/PZ8Y2SHqDqbqH8fZpKvsNusnl1BxyXpJIDKd6i03NvXKKtvhONgQaOvDBQ/M7OA
 SEusOt4y4FT8E6QVrqKkVY1SACDk8zFLaM7AdS5Rdz7VXOSeeV6kMvlGGcovXtF+ovnvHVW66Hb
 6e7aNAmVFUWVkAXQHfiATKHV3bznKc4DwIViei2QxxJKfYi8Z7H/tepmxZwfcAAOzwKcFxhLRdh
 fMVdmRcdZhruDFi4R3ct5s/Hq9oMaBHBG3vBlhPYMhke0DReTHJqGls9OJbh6tgrbvkNfmYiffL
 VP5LLBO1ji2oc5SautWKu/W5/FRyl0zwZdi7zyslDXThHN7tpmXqnIjxzotSKuBWLWG5fLX7sgN
 JJxWAvNQZYvSTTEGSqw==

NATIVE SCSI MULTIPATH:

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

LIBMULTIPATH:

This series introduces also libmultipath. It is essentially a refactoring
of NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
-may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.3-v7/

Differences to v6:
- rebase
- add scsi_mpath_get_head()

Differences to v5:
- deal with issues sashiko found in libmultipath:
 - include wait_bit.h
 - don't store error in mpath_head->disk
 - use check_mul_overflow() in mpath_can_remove_head()
 - use -ENOTTY in mpath_bdev_ioctl()
- deal with issues sashiko found in scsi mpath support:
 - check 0 returned from scsi_vpd_lun_id()
 - call flush_work() in scsi_mpath_device_iopolicy_store()
 - clear SCMD_MPATH_IO_STATS for !bio in scsi_mpath_start_request()
 - add checks for calling scsi_mpath_{start,end}_request()
 - tweak sd_mpath_dev_show()

John Garry (27):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: revalidate paths upon device unblock
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: add multipath disk attr groups
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  13 +-
 drivers/scsi/scsi_multipath.c | 679 ++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 610 +++++++++++++++++++++-
 drivers/scsi/sd.h             |   3 +
 include/linux/multipath.h     | 156 ++++++
 include/scsi/scsi_cmnd.h      |   9 +-
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 124 +++++
 lib/Kconfig                   |   6 +
 lib/Makefile                  |   2 +
 lib/multipath.c               | 948 ++++++++++++++++++++++++++++++++++
 18 files changed, 2569 insertions(+), 24 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/linux/multipath.h
 create mode 100644 include/scsi/scsi_multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.7

