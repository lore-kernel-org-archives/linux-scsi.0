Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53F546A606;
	Wed, 29 Jul 2026 10:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322337; cv=fail; b=ISqFpJwQ3Y62sKIgL7cO8AW2oOt6H61+04Mw+U5UYYdzqRMjdYoE5s8y5FsLy9vdNcfHxGT5zcShMHkJojiUEfHs0XAvLXetTlIFdlYzo4+H0jm/+YXbbOJPuPEPLufrNfWR6JwLdCpt7jqjm9trNlZ8vDL41f3uiRIrMWsnbH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322337; c=relaxed/simple;
	bh=KcplV7/+X8qDqHlFvCFUS/9pLZC35g6JhjZOSF5mQ+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=usCO0rjkl55ECSP0xMBQy6cMoma/8NW6I6kXul01tJS0syuK3g+V5sM1+P3fun5WHauiCN+4Rpec+KEo3VPcQ/oaEn8v1IR1kpfTyrVU7kdh9nWAc303yzfWtt4VPHvJHv0wBsM8z0ZERsT2xx9aPc1dOl5phn+EagFhbsXuabU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rLGT0fSS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dHBwYc81; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rLGT0fSS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dHBwYc81"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9vggB1074594;
	Wed, 29 Jul 2026 10:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DDUgoQOEICwOwnCIucYR/rbqk2oh1uSa1UFhvPMQq/8=; b=
	rLGT0fSSmxZQEBWQp7qOI1LxPVHQdsFOenqoo1DbvJXtLMOEsDmw2/7WUycx4Omt
	61/YRGi8qEXK2tYQ2YPAPSoMECxdcgF5Swm+wpK21qpCBMWDtxtmehHKEADkFS5a
	/m+n2TuryxSKHXDAO/Wed8Fh683YLbzj82cGvzLcBNF4bgIzmZQIxt2tszqPvMtT
	L4VAbPLNJyDgWVlC1bWv6T8dMWsGACZReq857WBMTWOr00GfkEr/nPBEJRlEZE+j
	ixIrMdNzeYBtV+xen12lhMVZgMEJX4NzhjN539qTaQ62XTCgAK5rvBBdxAHW/vhA
	jb9JeoaUeLwAI4kaJlbIEw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq5kd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5t4039998;
	Wed, 29 Jul 2026 10:51:48 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010048.outbound.protection.outlook.com [52.101.85.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSqj7KhNJzu/GJT4/5SENGiZCZpjU7TG8Ne/ODY4Dscl++JkNaWRxLitXJ+FeYfOs7gkUyLh2ohfM0vFQBym3ZJlhVsK7BrWCkihuVKGUU8F7Kav+IuJAj73Kvwsp7M/wdtrp+/T16TsmHxvOVUWfGB7swluwNqeTIuelqMuU/uI03O0vPLbiFT/1lAEh39ykRer0T0qSoxXC4Z0u9YTLdKTeC6Su3O4UILxb9niL60Op8YWalGpTtOhAuFVYWkOJ6UhZqI2fyYN3PDGCxNsJzY0ySn3Gm0kmTbZjGUlPykbGKsksNuvzSvk/MARkhh+31uT+eTGlQfbemAQ5Add2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDUgoQOEICwOwnCIucYR/rbqk2oh1uSa1UFhvPMQq/8=;
 b=KZQguTjUqW2fGKMKbRjUtgimlo6d9BbJHJ1ExcaqHQqcQBX+ziYb/oxUrI5L7sogKr5m7Jx3VwUW27iMWuE3sGnSb33oWeBnBHULjp2YZntiVdu714NP+iGkDA1Zq2zS35ivhW+MpzFyz7J+NkI6vo9MCSYxk84EFfoOZ6qBbfitJG04wEGwKLAPP7wUSnQi6uVIDkR6SM8+o3+TsMiTwGFHur5alMtvxuKqMnsQraOTXvnVQZDR2n1mt6rkiUDax8SWW5FpihiXCz2MJgAZYJTTJmVjV2tjg8vycuFMVHwHigYTcE+X/w2UGW/fY8Vf7VzNAYXW2FczUgIjSrL/6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDUgoQOEICwOwnCIucYR/rbqk2oh1uSa1UFhvPMQq/8=;
 b=dHBwYc81krIMvyNSjDB/RdiZGDTtnB8WMa+rAqG7XyhBiSHsLSaJ5ysBMFtuhwYEoL9+mBM01w98QvYASNlAWJmm9MtL9S5CsACwkYdfsFifLNsJgL4Hd2GDm6CCSWZJzCInqfu1PL5T8g8xUvMkpZml/v3UIOxp93fsMUtHHrs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:42 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:42 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 04/27] libmultipath: Add bio handling
Date: Wed, 29 Jul 2026 10:50:44 +0000
Message-ID: <20260729105107.255712-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS3P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:45f::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 600e26d7-0e27-4643-a7d5-08deed5f5fac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5fS0rBqKMis+8GPXbloGM5oam2Vz2jdMbF3vGuFmYT8WhzauPOlLF/hkwRHPUg50uOyRwH8WJpspy7O2HfDYg3u08yFw2/cHnppfy6zPru1d0cq15SUi6yPwhkt2MVN2mWnNF8Y6uV3pzTiVOgIOCQ6DOOyIhXFUU12PJ5/CX0MniqpVrVcqZeRGbGI84PIFMoI7WtVpOknXU2+VrLRTo2wlwtooWyDgwvFuTK+hbCIz11EJYNya7BYADh5sYDP1BPe37Qe7jbFmTf1B26rzXagCzzYXSM6oZZsmO9dNrQ6QbM/5nJo5X265P4jjnAL+CWxFzOJdelmhUj3o69JY8wTZ5V1VSDhr+ZrQqAqcbVmywQ83DBg9Oyfd4lYlfQYBJnzphxHeNrmlmG6QhWZjY3TB3Tlr8TGDEypLQAv8/vt3yG9tSLFfgaHfaSY/HrAmOjYY/yRt6eNb+l9TGHbj78Uf0jBjYSZUxVVeWqENJt1ltYKbTZvrTuDZuZRA+M6Ts0fE78FzguT5oMezdjzq2fzLrCak6ZTyrILoSlN2XE/Q3ZtCvDN1cbH9CKF7suvgfyLchr9BAjI9JBGwxIWsYb5Dc/SmTjrlP7Ka30muDGJH0jMfeV7aj/vqXryGMR63lYx+etQx3RWw7bI6/AnRa2KExuB6CrsQ/EgUVo0uGE8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l8VPNr51vQN+KMA3foHYSebnncOX9jEYdIOTN4W+JlJ72nPSSsLsqnpnNIef?=
 =?us-ascii?Q?onymj89t4kqkKE1OweTjsgI3w8pHQ3WTRsTa/u1KZvC/FimK+0qg65XyZ7us?=
 =?us-ascii?Q?iqX3L+yd/PLkP+in1zv5W9i5PoV9tbokCilalDrhF+zeNcM2SKKkjceQ3TJ2?=
 =?us-ascii?Q?7mQ+64Eqr1pk4SPWC7FvN9YNG/3AX6LQ/ue7D7VbXz8BNGinkmT7+0pQirJw?=
 =?us-ascii?Q?4GxPNQTwYmala8d/Q/uSH9z2lQFph8o+/H7UimLxsbt1OWlBWMlRxcZKOiIb?=
 =?us-ascii?Q?zPDqA64ANq362GKOw6+lEih2co12NBJojgrEpKi7bycP44ldLS0BLiAlVg9V?=
 =?us-ascii?Q?sSOWPHSWNpXVEKLANVzTi/XpBvQEuwPko7ftymyLKgM4QfuDsStZgJdnRq8g?=
 =?us-ascii?Q?AXeFAusn42g+eUNvViXta282YJ/CIJOwM9QBSN4PBd/yehGThXe8t11I8G4/?=
 =?us-ascii?Q?klsQ2rjfmZHOm8ETE84E0fLAxqB1RghPuVojGlgH3EghW+oszojvbx4ir3pQ?=
 =?us-ascii?Q?OpNV7lKVKLzii/Qf9T6n0DCMhGWC83LHudo83/gqUkraR2jCyw5HvzymioFR?=
 =?us-ascii?Q?PtPyqrp4gv1VHeEhCFR/yh/Et0XIyTYG8Vh4iQIvrqDN594tYyEQYX9WCLqO?=
 =?us-ascii?Q?jIMHc7Yf601nVL8Bo0SAOmGJzSMHOTSCZl2eVEXY+NEekt/yGVu8bfZ2nq+z?=
 =?us-ascii?Q?2i0+DQ2IRw1Sjan+FjAw8NTNmEpGw6BwDgb5t5SC2ET1HYAKHZviag6ISYoM?=
 =?us-ascii?Q?tJxHPFVbDEaZwEDOZM52CHVYaC9+jDpIw99PJHn7Pu5hr2J8qV4n41UX/0cX?=
 =?us-ascii?Q?NOJ0l136WL6V30ZaEGvC/kztkd3hiLxD8ZwsnWL2KQmOxrFNpUX3piz6/Mnp?=
 =?us-ascii?Q?Eq+E5tJ5rSpsfX6F1HHet1BY24fzigL1HRcKx6IA9asmwSmdpm7m5JRNJZGf?=
 =?us-ascii?Q?e57JRFBUJTuoLTd1XfBIwPDetdNN/Ztek7frHwe3VSRNxhIYktGSoa3ZhCFp?=
 =?us-ascii?Q?R8eQ3FN2qe+GW1PTnvhu897/IKjY/5aXVOwo/CxylaNN2hpWnFWq9GbTspYI?=
 =?us-ascii?Q?7vKytOM+HqZnE/842DtS4czRXXRjucivrsw7WK5NP2rszAObTrxp8MV2qocQ?=
 =?us-ascii?Q?ww/FQyiwH9gUEj4R4wqTn/S3y8QOGihaqcjBwjnwYtuttHqPUVj3ytMZc96s?=
 =?us-ascii?Q?wvx0waT5GGs//Vjd3tsTqVEcUiCnxyW/FpDTZbbiIPczrfKWbwq+UXbuGELn?=
 =?us-ascii?Q?QpCT98YwPL0nb8/AT3im7BMmtk059h/URzTOFglFTbQLdPA+2pAVLJn8MezW?=
 =?us-ascii?Q?s4un3vW1zlqDFhzHCW6sKuFJ4N2NUNsvQud+7pFGLm0k9J0/jVD3ZfoeUSG6?=
 =?us-ascii?Q?G88JR7b7XPLuJ98rKbEsCaoRLWIGIiNs/oMjh3+vEgRiMGeY4M6yBpqbCOVQ?=
 =?us-ascii?Q?7bgcL8jUGjTcE42cvy+9oBwvShqRE0DeUi/qeiIQqiRjhV3bOf6+SV7tb8TQ?=
 =?us-ascii?Q?xIehm3rnseGYyrthUiJ19zfaELTADuHhNVlDeZtPWIPFg0wSsruiiuQ8cqDI?=
 =?us-ascii?Q?eDJEQfZSM/CjyOhr/rV59o+PHxYuNMBL4PzrH09TNzrd7uzjd20cvA2Q9IUO?=
 =?us-ascii?Q?HPTh9UcSLQyHYxN6hBUULc7nwsmhEU/J4y7p8esjizPwPAYMf/yblwE5EX5M?=
 =?us-ascii?Q?71Tpogc3liQmhN4SKWzhHzyM4JQTAYzfG2hxsQ3Sf7dZU+7Zz14/QjIPPhA9?=
 =?us-ascii?Q?8DHBNaq7XQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	KmeZ3PzVITMINuMd/mYCt91aUv0NlYR/OlzjJiTQTx39eXPR2Lt4ji75+TW/ezjTeFglXbAsr2+fRMQTD8kIsymKLmWLqlwHr54uXrc5v4kXgtdAxDcyTumvYeO7RE0nh+vYLAqBQJ47QAMNbAe3Oe8HJxX3xD356TQ6BJNwC4SW2iHod+gmWQN7aFHVjt6vIugKbOdlN9qOWlejCaT+iPjv1tfy7vdT0/aCIqJ6Lq3cm2V4EXxScm3IhQCOjvl6bOqxKTIpqyDIbYczu0ae2G+wdJFfgZm1z8SCPa2M7mY2BA6s+JWvVUdxXIpqmGjE9BisWbLGZz5EqRUXOiZx7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9tKvSqrg1Noc/OoMAKgqHJChojO72T9Yd5guzgaJNZnld2PJuzQuqyyX4/RS4uxfmHbFyxfp6qPquSvn2qD0KHrDELpfSo5kpHN01sjnPykjwygHHDqpHGWNwHfFCtL8ZOPxC6MIJ/4rcR27LW+OxnM6yjdfkaXqhPWCwQVGLrJFiHvLWwGnI4w8R11CcBb9uERXdNUib+omAH0y3bWp8dPGIqJuky1ZrfCR3cV0LTJZwLAW9DRcsOEZ/MtMOtIEKnfnI9KugVfy9Zxci6UKKSKFUxXpQStAAnQ9YBCpcMUoa33nQ70cugXbzaub/5znLKi8WClJa80b3nMkbTSTw9CekrhHXgWYTR7GHcV3bzlnbZiDLz/+DCnT9Q7OqzFhekzk1jqKiK8i2oQEtMe/swNKgxC7+4XnCBlmAeIYLNmTz2CPN1WnnhnHyJS/FD6Gn80xWwAaMTUJOxkiY3Upbf1H3OfVa0wTLAFQ3I9l2AHr/DyCECF4b2hFUKQE40jAzej8cjq3f1nrFByiauyFBhmJYJp+xY6JyqilvrNz9zgWiULjYUWfc9f4BmYRbRVNx/fW2IMGlSurJU6fWBB4SJOQhkS+MeGJyGqkeWiRKvk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600e26d7-0e27-4643-a7d5-08deed5f5fac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:42.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csLwjya2CowMl0dwte1uYB2EsQcgbeJ41vVRaAzjLvbLi6vPl4xRG5Wv0rKLLJtkVyrFLlcl88T9SoTRnIBNmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX/27by38j5h7B
 M7Byk0Hfq4YDtyTWMOhrecJA30PyVlwzLb1fer+Kp6VsoxtpLqlgtX2NX3Kao5+egsWeCLyLKxb
 vVu+DUDWofGo3lajss6JyFSGEHzRrw9u+pBUp3vDerQ4dt+sgpXoLXUvxGdWZiE41SAkg5ezoq2
 wqCDvwaPgRXb0z0VN5wd5zcQHbJJ5pppe/bxD1ztZMZF6gik9/Kz2+oCSicyaLVjaO1CM0dZ96t
 2AhERI7+JwhGvxUuVrSbCPbioMQ9XYL5JJgrGmiENkf0w13AodEJ+ElwJ6ldSN7B0kK6Y6a8RPN
 5coBZ7Lho1jMS4erIdr28ox+oOOvV9di854rPnVITuCYPGo0nivdvPIbix9SYuUCkr72XVEqO/r
 g1ixzfwzOw1/13OS9Qswi9Q4buDcLGv5WuyNB09gkrcWrYRpgpScsf+RG1f9+FIorBpAy1UONty
 7mJi3iHElVI3HteP3LQ==
X-Proofpoint-GUID: QjpEyoYJXCXbnSMokuW1wI2C84ItIcUN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX2A1xTw5laPlW
 7a7ioOGh0y5ri8gLH9d+ckoqHXh2JW8bBrQRPpgZbhQP4EIecKIvSe1R/6+iQB/oEwikvd9VxrK
 XHW5AvQem/nE3rIT/E/807Nfpr3J2zs/XpeQjQJTLqq4Vovvsd4E
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a69db45 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=0Q2gd2vOsnR98QmcnEwA:9
X-Proofpoint-ORIG-GUID: QjpEyoYJXCXbnSMokuW1wI2C84ItIcUN

From: John Garry <john.garry@linux.dev>

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  22 ++++++++
 lib/multipath.c           | 108 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 9bbab0aa8961a..374f0531f7e07 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -29,8 +30,10 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -44,6 +47,14 @@ struct mpath_head {
 	refcount_t		refcount;
 
 	enum mpath_iopolicy_e	*iopolicy;
+
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
+	atomic_long_t		requeue_no_usable_path_cnt;
+	atomic_long_t		fail_no_avail_path_cnt;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -53,6 +64,13 @@ struct mpath_head {
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -96,4 +114,8 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 26714116023a3..93b82eea7d38b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/multipath.h>
 #include <linux/wait_bit.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -44,7 +45,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -231,7 +231,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy = mpath_read_iopolicy(mpath_head);
@@ -246,6 +245,81 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_device might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+
+		bio_set_dev(bio, mpath_device->disk->part0);
+		/*
+		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
+		 * enters submit_bio_noacct() for the per-path device. The EOD
+		 * check already passed on the multipath head.
+		 */
+		bio_set_flag(bio, BIO_REMAPPED);
+		bio->bi_opf |= REQ_MPATH;
+		trace_block_bio_remap(bio, disk_devt(mpath_head->disk),
+				      bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+		atomic_long_inc(&mpath_head->fail_no_avail_path_cnt);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 int mpath_get_head(struct mpath_head *mpath_head)
 {
 	if (!refcount_inc_not_zero(&mpath_head->refcount))
@@ -291,6 +365,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -308,12 +383,35 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
 		mpath_synchronize(mpath_head);
+		mpath_schedule_requeue_work(mpath_head);
+
 		del_gendisk(disk);
 	}
 }
@@ -325,6 +423,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 	mpath_head->disk = NULL;
@@ -385,6 +485,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -397,6 +498,9 @@ int mpath_head_init(struct mpath_head *mpath_head)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	return init_srcu_struct(&mpath_head->srcu);
 }
-- 
2.43.7

