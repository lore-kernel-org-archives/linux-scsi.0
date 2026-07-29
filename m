Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B173955E7;
	Wed, 29 Jul 2026 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322363; cv=fail; b=fhMglogrB1PcJWjvu0CSXXbU6cbQ8rs0sJMVy0wYxXkXXAM9YsIvb4JiHS7fO+X5igYZtxsuA/2D1dnfEbv8jK7Ie+xg9cPY38NuhW5HmaU7PsI2O8mrxHiJK6DXk+dYAOE9BkYSMjLWKdIqpTTBNeexw2Xwr7oarTKMn2C+rHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322363; c=relaxed/simple;
	bh=NdYu3jUGchvntbXEy9K93YJHEVS1xPGrOOFSb+ba3r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QzS0A4AtC7FHmYyRMBq7yFPhW2VGWPQMGyaI2GDt9LfD/vF/0DVeTS/eHkaLm29C7VO+spuRLn4w2nPxnlG1kyVZdE40j6BKvVqoI0Fk3tLIPdlYWCADhrmOQx2ijWxsQjtqU9+sGrrh2KDoXqsXOqV2jgCHlyjUCvtWY17v/aM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gnG+UzU8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MurRzxUU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gnG+UzU8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MurRzxUU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TAGQ2V1120905;
	Wed, 29 Jul 2026 10:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wfaItvoc5RIHbWBYhUeN7HxOauXiTh4KGAgokkpNy/s=; b=
	gnG+UzU8nJ2ZgcoeXtzjr8BLMWI29QJDOJhMo5MU3BLTFgMKD2NK1L/htGOwGYQb
	CEFcQAuAbYN7x+cy/d/U+QzwmzqM3syHNYGwcNdzfamfQXC8qIcaJ0QPvJ/Lw7+1
	gSyT7oCVM/j3pyt7U6rZvmtfqipBTjTIPCq+w7xHyRWAmcnxN6qBykYuqlI0+ezu
	IB9n+/9Q3ECgTrVApj6ugjPlUxtVJ7IiilKm3mNq1JdnrgmRtqWxLxE07NsEa9Pe
	1RwgQ8SFZYUF1ZFthh62liuXP2qWIk09t+y7f86PCEKm0pBy9lYMuvfkIERKE2L6
	RYAn0XFb83DkMS2pgoIlDg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nnmg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:52:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAoYPD005012;
	Wed, 29 Jul 2026 10:52:05 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013000.outbound.protection.outlook.com [40.93.201.0])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6dt9eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:52:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zT01/lm+8IPDUtGvRE8LJzMoV4OKzOMLp/6pJlQxCjDndF2XyfkKCoOG2x+4CRi1UUjiuaFWEEqCsebf4KNXtrFKfEEjYrGCFF+RvaK4OuOVZuKQ8YwSNqkrPz21Ji/XgImwMKngSmiCAI4hGIZoCEDBA9KN+eq4ckJP9pKkeVYsGGzUW4vCQhjn5qN+c500zEEDMSUW8fQCHZN+201MUzigf8ZXlVac5qezFrMrbORecJotXpmxtJD/lREzV2XWLxevkTvq4Rl0CheH4tPrYJSv1t37wMuPa515xkBXzGHnzQoOXybehwmeJxu00mJpLSbxTyCTX+3T1wV3B4IlCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfaItvoc5RIHbWBYhUeN7HxOauXiTh4KGAgokkpNy/s=;
 b=gUQp0AWeh/y4TVwCMEss1O2+1lKuykgWjIG4oo+i+ZZQCJ5+ZBcaDPCFvk77aFhUyTe2puFcp2da2lGOeg4vQ18ItgapjnYMaBntLv3+EpEQLI1WtLJYROmHfiVr0xqW+ujruxBjFk94Uf283TI+tBrwMHbvkhSXq3q2ZBNMzmV3bAAtt7iG/Ruoz+sY9mNr4gBDyqpFsJnlK05qfEhorwj3C6jrm3u6F4Np/4xtXtd55FuKB6/8aGIJnf4as7mfB7x2pmi9/7zU8GmSYul8dKr9yLCPpN/FKaOpdHeqk206/R+zNMEsdDcU8YOIg3k3Onu34o8clkAana0kOrv5zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfaItvoc5RIHbWBYhUeN7HxOauXiTh4KGAgokkpNy/s=;
 b=MurRzxUUdRRnfhRSsjARMKkFuzWMm2bYYdzS8Sjjyor8uK/mp/7ZQrjMNUFcQQs56lZsNdmNW2bGCUWHYbgLmAGx6Lrc0JawThWcSyGn7ZcU66W1jSEimsK0fvLYFRK7lGfLennpBMSlSQDtwvzBElMTpdLhaGGIgGxGrqNkmaI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 10:52:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:52:01 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 14/27] scsi-multipath: support iopolicy
Date: Wed, 29 Jul 2026 10:50:54 +0000
Message-ID: <20260729105107.255712-15-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729105107.255712-1-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bab9553-408c-4e03-5c65-08deed5f6af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	87HQ5PkBBNdqrm15WxephD3hiSGSuDs2CrtUUfW9kYs0iYrTgWv/YUwW1c07KIL4wnrzW4HBVM6I9oCduSmHZtjzIgnzGiEhIU18w+IU1g33FpjcPfG1J124OAMCOQYnfZBdDyGmktMTFALdZPVOOUwCDBqn7qIFt7SnUHx+/Xwyue7DFqTlcMueo8LccFGOOQi1YgiNEHKKpiLdQpoX3lIs4vL/lnOFMdhcPdNiKKoONgcMEaTebjwF3vMXEumsem8Zm9lpPc1fPLYIDJEqEeplkvmOqylSa/hcEKrKwluhBeE+RR9KGcwbVzq14TOXRpWSO7lRu9F36O5nNC3vo5Ymq2gcr6X6Nd9vhiF2oDCiHkAbPLF6nqmRZWsvyexvrdohFszgdF4CJ4ffnDbzzygB7u0hQivJG1hwtGZwJ44sGmCzma2ncj6UZ60o7AucLTuaD3HqcCK8n5F2sylZqHbFGNHqqz+dA/gTVHG9LdylGy6DIlJXF+mA3kPuPaISM+COlNnlK14b5XZngOFnX81IFNLm8C3suimhzjXkboz2xN0jDrVTZ0PTaQSFkc5jrfcp2TmAbLalXqT46y69dlAAdS7UUC9EwAtD8fQtxnku4HuU6oiMJCb2xJPcd/+dxpASKnWrfTK3OtKYv+J1bE/WvFYoyfeGU+eJ1LsBrhE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SJByELklFrBaVo/02fVX4c4/tL9ElZWfnx8tva0Cgb0NXZy1/hf8I5p8SUCQ?=
 =?us-ascii?Q?wr9lk2rPqrgdzo6aenLjkDkfgwp/Y6dEnqICNihxQS8EvhxXVCKQtFYiJThC?=
 =?us-ascii?Q?VSuMtpHmlTKLusT8FnjJWjdBvZSMmTUPhhRuR6kqzsz9rH2yRIeJnjswW19t?=
 =?us-ascii?Q?xCe3QnKmdP3bc7yMuMcQC8bhGzdvLVI3cHMrCu5TYVH8lPur5hexObcoGNWy?=
 =?us-ascii?Q?KQLk3cFkZIrJ5/B36pLj7U28rwVm2logM2yYtgBB6iXhczEFHtUDIlc/x5/2?=
 =?us-ascii?Q?vRvjZBYwZQt7T7mhAqSVCltU0yuwYUPwAOpo/IbG724NqVfP2SCo9cgC0odV?=
 =?us-ascii?Q?XP2CKvuKdt4AXt0D92sYTxxFUgSf77Ay4sGxnUDIxaLvAfqv7JVGffXigY+8?=
 =?us-ascii?Q?pC/IV5g+/SDjOHEt5gH3VV8GNZGpkrFAWWw58xXgNMJ+aBEu/Ipt/oQMAa6x?=
 =?us-ascii?Q?KaUP7889TuLWdEXDpJihzGmc1K0F8wYrowwB3X8wGG5LLqWVPysUcp36EE1l?=
 =?us-ascii?Q?QQLWzap4c1us6uhNmemf15nVDYmoXDrseASvdKtNW/daUSzh7s8dAiC/zzpv?=
 =?us-ascii?Q?fhDb4sYqfoovIZ6oSfWmfdYnhFWNtxfw6tbcVCuB3yx3FgIgg6gUD0XPNm6/?=
 =?us-ascii?Q?P3CFsAMU5FN9nsQWUMRcqM7kSBacv6kBooi49MVoHJLQpbmbXwk5yHojhpCw?=
 =?us-ascii?Q?urcoAWDduBaubXAvwxuk3Oj+m+ZGWj7gIYwbQmJkHClndks+vRhGRNQu/sQl?=
 =?us-ascii?Q?o88L486+L1lGrHY7eLYHArBzSqQQjlawyMEMQsciF6EB8xNN5IQOlN6zmTrw?=
 =?us-ascii?Q?eSXz2/SyBD2auAhdQ5+ww+iUHKLllofsEFrKNx0n8B1hYFkOGWBfrviQkd+o?=
 =?us-ascii?Q?7IkK1vBMpGBTeAa1QQkhvcG+bHZHDVJyX0zazx8ee2XAQg0QUUAJ7cRBkdUg?=
 =?us-ascii?Q?xcimDj+D03Qrc9efYHXlRIOEisY96jUyyydT0yDnHTTh/XrCfhBXEOANS8aI?=
 =?us-ascii?Q?hkDJ8NdEevADADcwpdnkuiZh/hfi8GbpgYfug+qRPPM9xdpXCIMXywO6s3FM?=
 =?us-ascii?Q?g2EswizQ1mUFa4iQZNWDe4Hyv2/xPk00E/wY0O4xi8DxjahcAZxpHbuNiWyA?=
 =?us-ascii?Q?SvCrMZyF3ytcCQnddGAnJErnwMkLt5rFCpPGVtTISe8UDdw6TisivgtiF6+2?=
 =?us-ascii?Q?+IS7VbYHemEA+J62I4geVcS4a7MlnYUCSuU8GDbYFJxgHiz6fluMi12B+jPE?=
 =?us-ascii?Q?IsSagGJgA+D7awtpUZ0+szAUnwx9DAkA+j/S90tvW3XzIduNKKAA4PXxhf1e?=
 =?us-ascii?Q?F84bzLJUky78qoSt2s9CJF29X1i1DxRk/FCw/5+c0p9oG7OSLs4LGx1EBNgQ?=
 =?us-ascii?Q?G5CsxdEVND7SP1ZAqNE69S7WMg1GfkLtdReKUsWq1PEIkZHA5PsEuvnmKZIQ?=
 =?us-ascii?Q?6k5kACPFfu4f4qAgbWbE/7eRcq4g+4jh5TTRuIgD3r4fv1BawZDkX4GS1BKf?=
 =?us-ascii?Q?RsdfRor2yvwls877BDVRJ2CoH7Jb/xcRa4zm4zGxLGO0CUJcYTn2lR06fMIi?=
 =?us-ascii?Q?1gCT56YC5zwk7VMhX436lw9MuCRSGLeiL71IJ5LV7fy6XFqOwLnRrQc7q1uo?=
 =?us-ascii?Q?/364TVqGz/+TAVNip2JaY/acyDiDjbKpI3h0cjhE4R4vcLa6Nv/r7upRbNLX?=
 =?us-ascii?Q?K8lmLprFJx+d9nVEs9De7AhzStS4E1HWRtDoKaI9LHuczAsMXRtX8YisrvIa?=
 =?us-ascii?Q?JteQEcF1aw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	mkQ+A8iempVo3GsQxVsiHYZ5yBa2/JeKoeP/m4BkUXRV7iIJYf84iDaSP2r5HWIinMoAA2hO5zFlFkXa/rW7yACDvMCqcPRQeq6RERDclhoL8Ipy2EES+TaphM1RfTfwQL3L/yddNzuA4mls6l7uBr+w42diPcM3LV06HdF67vK6JR2OQxDoOBavhMfdrEMILrgtD03A1+jNExaI09PIySPK2eRZ4G79QGmMPEvUGOQa/46mh3+hJyZWrHKsJhLy3oLPZyJzXW+2mGlu3LEkwuGwuJrf9iv3L2g7fL6lUN6dgnbw9hk/B8yCFhOCvJIBUTI0pkp67OJVmDHR2SoFaw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZgtjgY5YlYtL/RuOeQo/fTCTIRkLrPksRNvGGk42PnJYixVv6DoJUnPxn4FKM+067braK984Wo4Ecc7HIUH6PJeG6kpq11WOsoyZt6rb9XiuYPRt8fgIuOXmzDnV3lbuZwdaDVc6r4w//AI72cHgh4M0DPsRzpWTPPFWSjzl/H+QSysX67zddXdSo9kJOgkva3BXQ2Vn2tVGH5CUGVlCXUe1e3LqmtqtmOi6y/1zRBYj5bkhXGNHNwwcE/djR0Jb035M5EzqiclAo1B8edDk6n77LasQ3R0XrcfOo66lnZPP/szDGYTFv0kTb8mqf1TegGSBIY09MnB+Al6vqigshujv+eYdDlR20eDBTNoZwqrpp5UiZ9Fuk9aLweT0L7T/cGQP5MZNvePPPpAfi23XNxvOvkIIVWbgttFt6ffECPAWVzHFVHGUshxgfYWjGjsyX0vJZZ0n55ch3QlN8o9JBqRmCU00rAS/dL+ome1womXSfclfcDPnCG0EmkD9Bp5qv22j8TO4olro0/RolYMCx6s9mOVrxYTpQUXF0yS7XqShEI4akC1YJZG1pKIiGdObKQ+Lvr9QFKCu1d/ATDCHh87l159U6o8YfmwT5RQW0fY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bab9553-408c-4e03-5c65-08deed5f6af7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:52:01.2833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wJgv6lUiT6GNduaWyb9ZyFqU7A97JQ0n6RAIUbkz80wgLUdXQGujgtooafxhhdPWzJGJKGT4SKLattm31KEy6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a69db56 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=YKYambv--S9dnOAEj4gA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: 7pfWmCfm1LHAJlGYXPFOpzqq29uXUiA4
X-Proofpoint-GUID: 7pfWmCfm1LHAJlGYXPFOpzqq29uXUiA4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX7VcUBcnOOuAh
 fJRYXWEUzXrIC7ewaCD7UXIl4TEZTJRGkN0/SHRawCUfb3V88Yv7hCM8tXBEIO18OT3OkqOTk4K
 6MMSGHH+CMZ5//VlI2dMScI89nyiL9dJpQTXHbWlOB7mMhskbwmX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX93s1WYVLDIaK
 /b91IZ+8jBJnNRzpJgqbI6caZ7GtKTBB915HWGz+9X/2TfFizccNJc1TW0QgvwLJqUxXZIljI8l
 WT5Sh8IZiD/zpDZU5+7ccHrMhG2BPaegy2WHTswjvdZ7ZmRAV3wekGkHRZVskHgN15cFqJllsVF
 9XSz6IduEebU2pffMttoSoXQO40mjrsGtABe903Uqj/3eGYteOG3SV9w17YYVOq+dEBVVOltFT/
 Uuc3RP4dYh2Ww9tlDRBU2ny49orSt8CEA/9AU6AkPxzLTDNmAPXXFl9XDDdj3Xo6f+G61lPXaGJ
 Ed9tKoUK+EiezxHnB4hXNo6R7aXiQ+YePszSxFHkrLyXcUQfHDwjSItqdw0EoEi8F4V88Huz+ga
 dVG7ZbfVYwZzxYborFK6MDox++QYu0ob/xSUx8GNXd/zlYZIyd28IwmoylKOyAXmS6hEX5atEiF
 vwZhcgH4KK4O4YlfPSYa3mkYM6xgS97vE6DOzQMI=

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 52 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  3 ++
 2 files changed, 55 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1ec7bf1835de0..593f94aac70e9 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
+		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
+MODULE_PARM_DESC(multipath_iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -99,8 +116,41 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	/*
+	 * Ensure requeue work completes, as this work could run later when
+	 * the mpath_head is gone.
+	 */
+	flush_work(&mpath_head->requeue_work);
+	return count;
+}
+
+static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_show(&scsi_mpath_head->iopolicy, buf);
+}
+
+static DEVICE_ATTR(iopolicy, S_IRUGO | S_IWUSR,
+		scsi_mpath_device_iopolicy_show, scsi_mpath_device_iopolicy_store);
+
 static struct attribute *scsi_mpath_device_attrs[] = {
 	&dev_attr_vpd_id.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -204,6 +254,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
 		goto out_free;
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+	scsi_mpath_head->iopolicy = iopolicy;
+	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
 	strscpy(scsi_mpath_head->vpd_id, vpd_id,
 		SCSI_MPATH_DEVICE_ID_LEN);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index a9fd02bc42371..2dc02313b0496 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	enum mpath_iopolicy_e	iopolicy;
 	struct device		dev;
 	int			index;
 };
@@ -40,6 +41,8 @@ struct scsi_mpath_device {
 
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
+#define to_scsi_mpath_head(d) \
+	container_of(d, struct scsi_mpath_head, mpath_head)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
-- 
2.43.7

