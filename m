Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46F43BB9EC;
	Tue, 17 Mar 2026 12:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749263; cv=fail; b=TRRz5iWtJ6ikcgmSJPxybGVqdW1mC51VTl7ZbvyD4TliPK64yUtNDot5FqaaK5h+fr04aim74MAdyU1CU1b9X+rx7Kmrj4SRVT+c2yhSkTq5VdLtTp5pinZsTrmgVG1wJr7AVY8VxafZabUIlQ66o1JIlIfOtVvot9+vLCSBJUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749263; c=relaxed/simple;
	bh=dmnO8KPE5l+jUZsgvli3jrP3FZzrd54IG6vpnuv+tu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e/hX9nsoNJ1lWWsiy9UjhdQFCH9lGvfMGbS7bhFP2Kv9VbkKPp70hFm0ZKb/cfWUwB4kL1BClkwCyVHKYQpPsnN7gvU2SOPNZ+r9DmvFzFESkP+M0CKlaj3iYzFspFYZevSOmM+yIhy94Rd6GkK6Ri2sK6NVVsZP25AzprrOSpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=egBB3eu7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DMhMh+wV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="egBB3eu7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DMhMh+wV"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GNp6Ri1338917;
	Tue, 17 Mar 2026 12:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U7Fk0noflicseDIIY0B05/u91wrEnrK/qP+8PpTuvZw=; b=
	egBB3eu7oe1VyJubnWzoucme126T8jePEK63+xiVFEBkBuH0Pj+4J8ciWPTz73V/
	8R3JtlmnLEgryXgLWf6MBXSxEQ67SyhnzgSW34TZQ2PubTMCEKWmgfmJ7EkujT7J
	Ml7p0uR97SJ623V1K7VODC4Nb/fXiryHQvxx7bjandpGym+5XTzrU69iBLUg4zdY
	PpUVfzv4Dk9o3fCjwJbQDwl/KLXLLs0nTZIhvyO+qarDHnmN7iGkRMpxki2Dn6nG
	I47ePCnvb5ADydaixrjeH25pzJCMO76zEBH8VOHVgoneFFRRTPb/+8oMa7RYDPTt
	vg9XIsHxHzJfhKExc8GvCA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx3b3xhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HBwS4g002825;
	Tue, 17 Mar 2026 12:07:26 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011037.outbound.protection.outlook.com [52.101.57.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4m7tgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1PbyBZxd2Pmk1usKJw0MMLfdKmqhHlWPCz+Ts93LA2kUdglRsjWUUQDy5wkf1KpWnc5em0mlR5WsLfDuoVhAm1hSX6fGDB7CIR3/6ln3W0iX+1XsOQ8XIRZtEH4omdD4GzVLwYkIUlLtsxcyHk8rxikqRf8wqfZohYFSc4nFlqkQDK67kqdyQIyMIdC9MsAdu/NUCkzq+GGACGQaJWbKbD23u9S3G56ZwzNtnL/o7cvLw3h7R23yU3Wq+FZqxuNxrvNSx/SMArZG2uHdWTudw/mViJkq43aJjyONnGxm9Pyu82eCb1SPYrBPyCjjRCUbgDJpIfsJEAcCq4HaJxbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7Fk0noflicseDIIY0B05/u91wrEnrK/qP+8PpTuvZw=;
 b=IW+qCqCldh8RT7UfrQQK3Wjwm4yRiOyG8Vt7n4XCuXkTLdeb4g3Ii18FuA2Vf6oKKGXXSePLeAnw1jtLBrKGKwHu72QHriJ+zzygBLT6/A5HQdE0VspZ2Y5eLy946AYhMJLvzmtDDkgEnYLD71eskKWZtgQR+DAn+9yapiHdO9nrmhaEyccNCfHX44eb6D4bTZe4kV0f7blSSMLsIKQBnaylpHBRxIm7JC9W8RabuOEZJGWaL2bZnzSv8qdU4VGTCtBDPgjShDIW8DU6J3fTN/Rbu56gPf2uMWoLiUwkQg7biTwXwV0rhXu+XH+ffs4cyvGPKYdSyreP4DDsPVKtkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7Fk0noflicseDIIY0B05/u91wrEnrK/qP+8PpTuvZw=;
 b=DMhMh+wV6Va8XbYrCcJmHIyR7EzcdWqOLRA/OqDE/bfg1IHxMoxCtt7bb6sJy/+1+ShGFuCIw2F/WyWeRQCVsKD0zeojXISx9PHPHTNqzO1+HvBmGO0HRIkt/jzaAK9TIHTbSlXsbfLsEAkYuVAWh1Eqyp2bBoX+Wm2SU9Ti8rw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:24 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 04/13] scsi: alua: Add scsi_alua_stpg()
Date: Tue, 17 Mar 2026 12:06:54 +0000
Message-ID: <20260317120703.3702387-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0151.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:33b::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 861ef62f-842a-452e-8905-08de841dbfb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	M3iqijtN13ka6Sc5O1pYP/GPNAWvV7oyxAyMz5tOk4lotrKW4JYPrBzoDcmpi4ewf1kHK1uKoGdS8kjJxVGWHtSsdQnDBzIKX27xL+HW+zG6TUf4ZprpSDTO4kgcqEmHWesOOUvEVTFhNyyNFgmSUwSm5UAsr3NxyJf1hHuufetDhfcLoP73slzi0L6cdqOB+vtJff6KNeIGu5FCZvIbZKueAvAeHRHF8DJYlYEnOQcn56Ni4FJ9SYy3egI3lA8mlvGVQHRQ5MU13kvCiMlaBKsmD7PWi0JZUP5ORGVuR4lh1gtLEMt/KplhBVay8uRjCekC5cFdTSz+z3psJOscZtUr0rqphB7iaZVHLQpQtkzDNxipg56m0dFXBemk4JYPihOE+oSMQtT0GsGcldCZoXHfefQ44dC9lAUoOXoublfNG0NKw3sa9u5kOzWHR6XSUZ+tpT0R03H/G5sJWtipZ3mio0l3Hq3eftR7C0wvMyjk3sWhaY1XfjiUQvNCQ55AYcGPcyXTUDBEAAh0qJUQfgzRFB5BKbJNEnJN1v+AgheW2Q3HsciA1ywIJaafjFB72bjtHPq0omcvn4zLdJ+++lk2/PyT+k99+mQZb7J7uzIU9tgtiT2cC5c+HiMupBIEWpdr4FjJuM6NisAqv3oBp1yWIX7hVLVo6YvfQDrnu1kh2a4RdXMQ6mAmGf5ovTSyfZgq4VGSrh4+cN9JbHELMQT0JqX0zSE44HeVbf3RrMU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9+P7Ey8PHpOCyTvlhySyfAjjo/m6hjYBypu6/4feN/FJOh9ukMrLTru7YzEO?=
 =?us-ascii?Q?WM/egY8e0bif9WXShJktPg9Ui9zvY6CxE4BxrfLJJxVooVmO9i46ghXl+6hw?=
 =?us-ascii?Q?+5TLTxcVMgGrt7/tFE7XP3ZjHd52sJ/jY70UltA1jZxA5M0NLq6LKF+9wNhv?=
 =?us-ascii?Q?doWexkoaYrfb50aqS10Oy1QOh24TGOF63Oz4dxStWUie/jEUcxa+Fr6DF30V?=
 =?us-ascii?Q?xfIvt6pnOZtcMH15IYMVwJGNkzt/GkX7XS68oK4BPkOQ8IJpGQUq0NkuwOkr?=
 =?us-ascii?Q?tgp8+DLeQrgvbYCl5/648llMBcVwkX4KVE4WXYlNmg+/kbVUxt+ps9h7d5w/?=
 =?us-ascii?Q?tT62VUdHA+qsf7KUbUpUEE6S2vj6CtjXTkRQKRAWnI5p3GrbUhP6Tt0+L8/2?=
 =?us-ascii?Q?qBG9k4pwzX8B2fJGkowi1HTdFk4GOypI1R6UNHMRRVZ0NFYKfYj60w/lTDHr?=
 =?us-ascii?Q?7Y9RHXb+NWl6OMNXDQ+unwBejrz7ZK3zM6LG0IflNM8L7SWmHBd+ve1wfTYG?=
 =?us-ascii?Q?7NL2OluylHCtqdnlWEYl8QqFrnyMcJI3svaBqkN/ea3icVweTH4/VofoE+oz?=
 =?us-ascii?Q?LlBL9JaIbOiiQfUfJXLD4a+ZvRO58juBgCeE+OcJ/I7aj/Ei22GtZ4NPEjnv?=
 =?us-ascii?Q?z0j6ch2GAhiA8uPrC046DMH5XMNJ90fBDTCpWp3Bu+JMCmHYoUuUiQ/EzSPx?=
 =?us-ascii?Q?WEx1XmG8mBsASYbgPFVCxvbjAdKSO18Zdu2dCz3pzS14BT6/C2409CDJjcMf?=
 =?us-ascii?Q?L82/LeaqN6jVX8xTqt+Dr64CIhmLRM0kXkHMVyrod9Od4SwC0kexrN0yktfJ?=
 =?us-ascii?Q?uJ7GSf4OZXz2jBHHe+IkdxmH8QzRau2WaZV2RdxWCO9TdHuNRqUrMWuTfx9u?=
 =?us-ascii?Q?q2x882UATx3UtfFymAKBaoi32nX1liNO5z7nnfqP7tjyThsDpLSRhQpnfzwX?=
 =?us-ascii?Q?VPJpweMfSOwIHszPU3+zZnDpQMIIQ5ewrvy9C+C0HQ+GCJIFMgO3kXREJQID?=
 =?us-ascii?Q?pIIm8mQmZ2MY5L8sVwsd0ySWItOL4R++S0hXyQICeL+AZBrPeccjG88XXjkr?=
 =?us-ascii?Q?xfzLNN9Q5V2+Je54kwx7rW/y8f7Luc6MyFsfYp+lLweSqUesIaJdQ82KdAdR?=
 =?us-ascii?Q?tcDv1Df5gfoVNV5DTTpkgMUMw6b6NWEeqY/LymRolwCxBUTnni1znPuK4GNF?=
 =?us-ascii?Q?tv9tQCrReVR6gWyDtTflZG4i2Z3yYk+zAa9nrVqKGbEiAAg4OGkrNZeaz0e6?=
 =?us-ascii?Q?PbZpTg8dAmS1ixfYdGji8uYRZ2m4obaTdKD93Cp7sewuQzB2DfHelzkDB4Wh?=
 =?us-ascii?Q?mbq4v2XB1AePXRQBSn/Cbrvr9AdX3sv8vfzs8GUJf0KQOT32aY58oyBOmKmi?=
 =?us-ascii?Q?cLsEK4xRuObalZytTwavpj7yhOiJONqW99Hwm+NA7F5EHMmaC8wHAJAS6rPM?=
 =?us-ascii?Q?y4sM1w9oQGnVJ5nGo2xL1NuewOdixc/g6wvko6NG7Cn762x7AjnPvVoOkbos?=
 =?us-ascii?Q?b56myGdELXMgsOwy/HePq4AXFJeIjqNfnhH2i4PljA8/xbi3j7mLoWaDMYlX?=
 =?us-ascii?Q?3ot00/z4HgvgGeC5UENJnx0WbTxRxyQah0cAls786TOZLPSnRkE4VKJIOk5b?=
 =?us-ascii?Q?mECJOX0C9xdZared7mzQ26tyy6cFDCbR0avn+qNN3A7jJ6fGedBHBUTc09Up?=
 =?us-ascii?Q?luN/7Pkp8ML3Eh2Vp4nYLZNXqMO3OdKsWywfEQquRSOv7Xcu1g95xnz315tw?=
 =?us-ascii?Q?Uh0oRIKSIZo6lKwvItQyu7WHTlR/LG8=3D?=
X-Exchange-RoutingPolicyChecked:
	RkjzyVE3EbOq8tC1yJt6zrfkTRiwVzMUuAf4OlLo6ocrLHsqokm+M2Bi3ls/vhl5MNcLosGG+m4YuHAecXY9VlH+8V2k5j0wQCkxvRlEwQsi1/vhNUKWITsfo12yqTsnHAXgmnmYRQ3cb8N2itLhnVAKvXLalfMSU+1IQKpx/n2lJ4nMWJCtoYffL51DWbYeBDFKJIsYhRI4NZcqXcgJ3oCtdL9UhOt94HhO7HY/z1q7Dh+nFdLSI+RPSEUL/4/QDqjTqNYyMX09spqUpbembXgzBZY+k4cZ40deak8QqiRV7siUMIOpyrXX0j9a1qYJkA/eK/VXJGMmj9ZlAqjbnQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FZ5MqByJ9OKWlqxK0THFQDbpgFUGd947NKTFdNmm3lBOg/QjkxpK8aDQIAjrvviGmoHOvpZF76Jb0EhvOXb0CPor4gAn618MKt6EWba6CdemjRSc/N37BLsFR/+UtaxpQ4dEt7NXwcdqVA/k+062kEDcFdxgmDLFp/3VcrWKI1pToTVzsadTNZcQq8y2bU8eWSUJAIuCqM1/OO8RvEkhQVClE2OaUoi5R0Ns/MD8lWaMQEFVbQ+Z4l3n+irQ0yl5woWNaZiVW9H0mOm9Yds5hdlJCQrUZR9MYa4loACen62CdF4SPpbWvVES7BSEwmn/GqaMAfsR5fzI8XxAuRYNRD0MgE0F6bzXHiTFSaZ9bsg5alMH+Id42Dz/EQl/LX4Ninwx2DBoXSzUQAeI/OJzlT1qJ2CDr7qeNzPhfDd+oQ2GAzslLcT2IYdiO5tQxMDndPvcVcvyVEKTiO2wrpRJKJ9afh3o5TaVoitTtEBiqLs8Il3sXzHzOn1/bqv0AagE5zMrP6O9GE0PvCw/21kNEJbzE5ryBSYLaTLYVJK5qb2eL+Z8u4zWBDIKMrG0l8TgsLoR2XAjewCLcKpdm4KzRh36EGuh5Osfc7RNMxS+nTk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861ef62f-842a-452e-8905-08de841dbfb2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:23.9991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gC1MG5UFwu48IxRv6hm5vGH/womPz3NEzXMb3vJzgocpgh0+3MfRoUvJYr/odz3APERR67fnZ422fnPve4sorQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603170107
X-Proofpoint-GUID: r4Xb16XV01uOLEw6f-Q4OENfz80Bl7DC
X-Proofpoint-ORIG-GUID: r4Xb16XV01uOLEw6f-Q4OENfz80Bl7DC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX18z8UOUNA7J3
 L4DyY5BONEaTnko3SGEG022DO5LmLEVlj7qAV2GdON0tY7v9905bS/PcxKwd/6iMkQc6vJn5sL0
 uR0C9n3tMZ/slTay5TzSljsZbUCYgibHaAME7ddmbzzBj9rFbP0YFyBla5cno40DgCg/GVR8uf4
 yc29hCOeZZweaaxFLMZ0omaynYirH37gAMXIMklR0q09Fq4+vF8cL8P5FnFMU6+mYhIZB36/zjf
 JKHO14tPUXZwhe3gG5xU40AUV4j2OY0TtAoov8fze/W/XlKAQqv/oyh3bVQVuwuXibZXRzP+HxE
 vkqR33aCdXc+BItTYSNXMQ3qEhDjUfpgACR3NxcLL3INghLT2KkcK3iuk+89bexRNl3WTw4D3fX
 ThbVan6BO3vaRPVc4Egt8y7E+vBbq3w3Qmy5CQCEVOeKsG/e5nWpuErIXTRegE4nocvLAz66cRT
 UjKorJIW0HYSPSvMMru4BTKv/WfwbzOjGKdvxxGc=
X-Authority-Analysis: v=2.4 cv=IN4PywvG c=1 sm=1 tr=0 ts=69b943ff b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=P8ANGnkCntlzGNEWBNIA:9 cc=ntf
 awl=host:12272

Add a core equivalent of alua_stpg() from scsi_dh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 99 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index 50c1d17b52dc7..1045885f74169 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -30,6 +30,9 @@ static struct workqueue_struct *kalua_wq;
 
 #define RTPG_FMT_MASK			0x70
 #define RTPG_FMT_EXT_HDR		0x10
+#define TPGS_MODE_NONE			0x0
+#define TPGS_MODE_IMPLICIT		0x1
+#define TPGS_MODE_EXPLICIT		0x2
 
 #define ALUA_RTPG_SIZE			128
 #define ALUA_FAILOVER_TIMEOUT		60
@@ -65,6 +68,41 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 				ALUA_FAILOVER_RETRIES, &exec_args);
 }
 
+/*
+ * submit_stpg - Issue a SET TARGET PORT GROUP command
+ *
+ * Currently we're only setting the current target port group state
+ * to 'active/optimized' and let the array firmware figure out
+ * the states of the remaining groups.
+ */
+static int submit_stpg(struct scsi_device *sdev,
+				struct scsi_sense_hdr *sshdr)
+{
+	u8 cdb[MAX_COMMAND_SIZE];
+	unsigned char stpg_data[8];
+	int stpg_len = 8;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
+
+	/* Prepare the data buffer */
+	memset(stpg_data, 0, stpg_len);
+	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL;
+	put_unaligned_be16(sdev->alua->group_id, &stpg_data[6]);
+
+	/* Prepare the command. */
+	memset(cdb, 0x0, MAX_COMMAND_SIZE);
+	cdb[0] = MAINTENANCE_OUT;
+	cdb[1] = MO_SET_TARGET_PGS;
+	put_unaligned_be32(stpg_len, &cdb[6]);
+
+	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
+				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES, &exec_args);
+}
+
 static char print_alua_state(unsigned char state)
 {
 	switch (state) {
@@ -326,6 +364,67 @@ static int scsi_alua_rtpg(struct scsi_device *sdev)
 	return err;
 }
 
+
+/*
+ * scsi_alua_stpg - Issue a SET TARGET PORT GROUP command
+ *
+ * Issue a SET TARGET PORT GROUP command and evaluate the
+ * response. Returns SCSI_DH_RETRY per default to trigger
+ * a re-evaluation of the target group state or SCSI_DH_OK
+ * if no further action needs to be taken.
+ */
+__maybe_unused
+static int scsi_alua_stpg(struct scsi_device *sdev, bool optimize)
+{
+	struct alua_data *alua = sdev->alua;
+	int retval;
+	struct scsi_sense_hdr sense_hdr;
+
+	if (!(alua->tpgs & TPGS_MODE_EXPLICIT)) {
+		/* Only implicit ALUA supported, retry */
+		return -EAGAIN;//SCSI_DH_RETRY;
+	}
+	switch (alua->state) {
+	case SCSI_ACCESS_STATE_OPTIMAL:
+		return 0;//SCSI_DH_OK;
+	case SCSI_ACCESS_STATE_ACTIVE:
+		if (optimize &&
+		    !alua->pref &&
+		    (alua->tpgs & TPGS_MODE_IMPLICIT))
+			return 0;//SCSI_DH_OK;
+		break;
+	case SCSI_ACCESS_STATE_STANDBY:
+	case SCSI_ACCESS_STATE_UNAVAILABLE:
+		break;
+	case SCSI_ACCESS_STATE_OFFLINE:
+		return -EIO;//SCSI_DH_IO;
+	case SCSI_ACCESS_STATE_TRANSITIONING:
+		break;
+	default:
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: stpg failed, unhandled TPGS state %d",
+			    DRV_NAME, alua->state);
+		return -ENOSYS ;//SCSI_DH_NOSYS;
+	}
+	retval = submit_stpg(sdev, &sense_hdr);
+
+	if (retval) {
+		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: stpg failed, result %d",
+				    DRV_NAME, retval);
+			if (retval < 0)
+				return -EBUSY;//SCSI_DH_DEV_TEMP_BUSY;
+		} else {
+			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
+				    DRV_NAME);
+			scsi_print_sense_hdr(sdev, DRV_NAME, &sense_hdr);
+		}
+	}
+	/* Retry RTPG */
+	return -EAGAIN;//SCSI_DH_RETRY;
+}
+
 int scsi_alua_sdev_init(struct scsi_device *sdev)
 {
 	int rel_port, ret, tpgs;
-- 
2.43.5

