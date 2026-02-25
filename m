Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9EF3E9588;
	Wed, 25 Feb 2026 15:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033616; cv=fail; b=n73MvXG19ZCX1qPZ0E+Z31uLMcmxi4egiG+NtW8iYAQMycU771wk3Ln+buG37u+UGzsBdOCdVb6tNotEXL4c97TH8G2tu3ZqvYNlPa1Et1kNLDP/LdoXadLHtLvLtMCXMa2ESR5rdUfdjtyiYj1GqfCT9X6PsBkVmEiou3v/rdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033616; c=relaxed/simple;
	bh=Q++pX0tksdtAPOB3/6zVd1eYyLrIU/NalTU4IF1Nv8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fxgJsWe5xosoturvB/5BrYTT0o0KDEcaIFVVdB1JpW/E72ltOz13x8RZG+j4xWjVsafi40gZpkBbs3zB/eTnFtuvfxFp+/M7CVAEZh5K5h1DVwReuy75f9+wvuafMWUtizqTc9c0LtrsGUWFrvce+HzlVVHd9G6CEk4MHEdDNXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pau2FD4F; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cISqY1BY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pau2FD4F";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cISqY1BY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAjt6j817332;
	Wed, 25 Feb 2026 15:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5S+884VTI51q8PYnMTG+jRcBo/DcyKqpvTpi9U6WS1M=; b=
	pau2FD4Fu2Vv5PRWMfOF2rdWjreb/B5+TaMYjXoVss6knkpeknAVeS2FeBylC4w4
	OI/yZF0986FHggjq7WpyWpCuIblii2cBIB2CCrZaYXpIvJ4JBWcm2eoUEnbt2vPV
	eHfQWEOtA5CUBB4uqKo2XvMaK2K3lUen9PxeIIH51RT3YIWgIex1TaUTA+38jjDa
	0/WZRE/ol5je8/0f25ke2qsqPFadkUSrq41UvhEJBNnQ+Z4Iy+JDXhGUHU/XrIpx
	PyFlZnbHBtEJtjGO3W1RbRLHIXZu++gpVOhIe3jVBQ7uU6MR1Q7DInre/4343XJN
	1BWPWqYaUyv6/ZCdztspcw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areed0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF0tiw006261;
	Wed, 25 Feb 2026 15:33:13 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg537-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkztH3WNdtMSJZb316jow53JaRIbwQO/8YNisa/Rj2y4TqncMlq72Ese0LjfWkmGDte8MxpZ5rosDBINMU3xfL7Zz8TIsZRE/FJZH9BU4FHa48UxtOe2T2zWVXxeYlTxoicQx182XV/9zi4EnjYsgvax+g0tiexyUIkDW4V0HCYfDS8pLwsAu4se8JIgKFosatNamy8PgWqJ8mMVa0miinbcKrcYLtQPO1aN5MtVuLZW8ny7VGsBxxwDM6CNWxVxg5MB3N9ocSAfsK4/54R1g59K8GYiXO8BuoF9b9ZO1gYaLsVZvKBC7gswKDj6nYSIpQc7haiWtvsBdwdl3P0Q5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5S+884VTI51q8PYnMTG+jRcBo/DcyKqpvTpi9U6WS1M=;
 b=Wk9rkfzunkBTUV3/mFgAQceGqG/uHO77y3cBAUojI3E+dliaJiBSwqKFqNdnC3R9DoWPx7AGAU97Gv3u96jVcAFg5Tp33NW36jHrbXJJyZXnxLC6l9ZHgx+LCXHiuCA59QVhvD0E5LuA0QvfjCPg9ay0DGe04xpap04QDRbjja4bWxhTK+jo0ovPBe8aboPPh4MBMzXjCoo6/bLWi36FS4Z1rHt5D8X0XNAdsS1mrfV3sclvU3jN0ljCIetVAnv59bxhipVFZa1QfIqoy3PNNPu1P5udIOucTmXBg/20FEsyjD2Qb8spK/SObq/eSxFTXqaG+p0UdakwYtz5PS2EwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5S+884VTI51q8PYnMTG+jRcBo/DcyKqpvTpi9U6WS1M=;
 b=cISqY1BYTP0WMWJoccUB/Rz8CRD3OAi9KSPdlRwPdrFFpdebT2A00iu0M8eB09Pf+2okdyuosMxGA0PR/MIYJUfR7YEZ5Axpixwmm1TFxScqTxAHpuhqURg5zNCZzyIlYdRZD1RyqKLKYRKD8CnKkYwU2r6V8pHPT8Ym2kwZTkQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:33:10 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:33:10 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 12/13] libmultipath: Add mpath_bdev_getgeo()
Date: Wed, 25 Feb 2026 15:32:24 +0000
Message-ID: <20260225153225.1031169-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 26a03bb5-1d23-4ccd-dad1-08de74832e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	xK5YlGBNqChpSNYbJmdsb18hH4Mt1N2I5uKEjQ43nh8PzqRMQe6GQ7T9E1OKobOoKIRlKn+kEs1sTxtNMJVU+qfiflbj9JMaa4GGTXM4RrsS1YCrL30GX69KaqE4CyMgug1W3zCKuAbm45LVqfiqNViE1eTA6lq1AZULKmYPJRIviLdzNFa9Gaio+G8nJiOhlaCVwI9XU4a4yMpaKsyBxBB3N1JsUhJmtaAFPgxybWYxMiyuQPYbDN9WLsrFF6cPuB8DDAZebUS8oDkzUEqdVrK8wUnWaPWRap6bZF+PiWmsH5rgUUVxXGmuWh6Ww1MYj4cZx2dp5zsk6BxHXWzHZw7k32QDf4gFIGQNuhtoyl+kL63/etRwatOkwLVI766KU1Dc4Gb2dGj5oJe6UOg+Rw54zrtALBdO/+pnCP+E7F/YUjIzfiWJysfCTffUdLgsPol1GDJfsCkd/x9CCugdT95K5GFIHCwgAqM+SrhSMhh0u6Fq4PiX0MgRNxMYOGj7sN6GRN1zngkzliG4oEs81ScWI4D/1jbqp5Ic+J3IvbK8bdS3QBktFoK48cELG90D7YsXSBQw1erXkG6yWGY0OG3viV1x9cf0UvmWhXfRky1aARbZpPoXJUBaB1d7bHgae3uk371qS4HtSBju2tgMNM/sifuaU0lsnML0rmwrkPhJhiuEmeYGexEbiHVFWRvx+QFdi9PPq3ZHDbARmmssnq7SdB+EyyBR7YFel+j9rhg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AuwnJ91uVrt85Sriecjp2lY55ywgE6cTQqoh7taZ1g5MNoAHdYvspzitWXmn?=
 =?us-ascii?Q?Bagye/ian5xPFGUnvbNXcuQR3Zw0NDXbSyk+768p5pExih1EyIDW6dvGminR?=
 =?us-ascii?Q?O4GiJC5pPjx+3nHk3UVJT4TIdAuCk94EiAh7jmBqNNFCkfx9KZAWZt2OfmNJ?=
 =?us-ascii?Q?jTyW4IcoFM2EovUL7X9bnASGRYBbMrhTNi2kHxoAXnlRipuxtDiSlF4V9IFJ?=
 =?us-ascii?Q?ZgxgJTK6NE3MJpAnq6iNzT+GK2/V6A7MnZPdNBSXq2ODYfmZvxs1SXMs52Us?=
 =?us-ascii?Q?qJVOQOaHhXUWqJf7tzyOZFfyKMtXt40hTO8QB5ySNIs7SwyHs1IEv5l8iVhm?=
 =?us-ascii?Q?Xbf3tvnbmZRJWdHaf6jBYc9xE6Y9ike26r0yk11O2W+2A/xQUYDlcCCdBzM0?=
 =?us-ascii?Q?LuE/lvIhC5hI1+Tq2OL86I/SHnn+Ri8W08ubvD3qJF8Jh1+PjIcYUMWvizYD?=
 =?us-ascii?Q?fUknBi8Y53cXY97KSuhWOpfdVESQGxBWF9gdfFFH7pJsQFdJQcWgWRbt5vBy?=
 =?us-ascii?Q?ombQLoSvUXH1MKAIn0Z2G2YjleaG4b/J2l40+0KK6Ay8d3lf5ECTj103Bpqt?=
 =?us-ascii?Q?TIlNN5VjbIq15ZFqeQLWqFXPZLnBBq0L0WTV697qlgSS5PZEzXXXO6S1DSIW?=
 =?us-ascii?Q?DcMIYted2EKyzd92DYX/3U+Q+K1TmyngUOR0CkHo7mkTesShqAqnphCsB975?=
 =?us-ascii?Q?0Hjl8ce3QxK8T1GJuIHaF7Lvt3sIptE2PESX8F/fYFZaMM56RPt6483Dvaj5?=
 =?us-ascii?Q?RpDakrdMXKYrAaHouMLb20OzJSalGTStIe+teUYGDQMPjmN5c+RL6LW6lvYM?=
 =?us-ascii?Q?qrHaBzEPouhuBmTsWFedB5WOADZez3hGSvD0ZkUfx97WuMrYOv1z0n2cl3lK?=
 =?us-ascii?Q?gTReF3pn0kTEhx1ujIUxt3O/dv4r2DAhAq5eMT30f1hj+mhtb2zS7ycD6WNS?=
 =?us-ascii?Q?QVklIirTZXyhXO5dgZcl3E0noUXOny5ThoomlBtjNsbn/3MY6+qv/AtXN+MN?=
 =?us-ascii?Q?CWfOz/9G/aWEzr8TNRTV4pldIxX0aOK+Mry1cI6gyqmcAgLD18asQqNVY4BL?=
 =?us-ascii?Q?dAEoOn0EW6M/eLnkeuCcKSh4dm1ipi/MPO5FPMLfvqLMcRumXmTTJzOz1J3A?=
 =?us-ascii?Q?XNKslNLmk0qnmn8qnlCMEzaM5ZYWTqgu5Y4s4hZSdHkmdayaeFpkV8Mauwpn?=
 =?us-ascii?Q?dcF5xkCpTiZFQ+T5soaOEDSdd51wTmGJwTJHn51gp96PsYT/YKZ7jHis4uMb?=
 =?us-ascii?Q?VFalGdJUasJko8fR+qFewW5A/Q4hV39J4UBXmHAbpPAGtmqKe/wMRlk+9aDl?=
 =?us-ascii?Q?JihC2su+U//chpzC7f050CETqenqwlCXozRqR6CiceP9rb10mUaWeOm9zXwf?=
 =?us-ascii?Q?LgEi64YX5v9sdyzDqCSAJ/XgAEFBVuM2z/ipXuJBWJFiEeA7XSK4G02JSfRM?=
 =?us-ascii?Q?Dw9Z6zuJnSx0lk+5s6r48H1ZpjlrHmOWix51jAYGTO3IiI8CwXYNDO5UGwgS?=
 =?us-ascii?Q?7h0Yh5l19LFf6UIjNz5ZGUateECGrzmxiwzNqxJhJZGfedH5Jaet3r5+Sf0c?=
 =?us-ascii?Q?2W/5TDzqhi1TTpdNToVwKfU3lCafqqTfMSppKN6oIE/dqxKDxQaItcfrVLHD?=
 =?us-ascii?Q?afVIeTL1jK/PMXUXtWlfv3efW+rTZ07XYdVOUm2DY/bXOI9B2EXcS3W/BjtP?=
 =?us-ascii?Q?lfn/8xrR8dYsC7T7uzt8uvknlDleHOSfjHsSIhxHmRhLcW4lJtJkN5V85ASv?=
 =?us-ascii?Q?/EgTT+WczZkrkbmYtAfDRCYYZBQcjxM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3ICvNtsLm5c6kyyf82Y5NHmcMrViwxGohD+s2pqtkC42ogZ29IXch5wDSD+03njmbWZxbsgkHj/S2lDmU4iEBe5eIJN9pBUzBriJSYJsFUJ7TsM9bflhGJHaGOLpOfoTHidkfmFVYnfGa0r2zv50bj8NJCborEFnTow+NFif1jqa1pzZUz+nk8J54X1C8iF0ztAG0zVM0z23YohThS+K7YmhltNlTYatydJt8q0jZJIfWxojqM9fjIDXIFRFt72/C8Lnu3BQztlkV/XH5vdbq+qEbcaRu/VbupsR0TkjRwf0pXvKE91bEBLcqMjwidXvy1eE7ASV9kc/YcVl7/i3OOMkno3EALXK09xhboksjNRy71dYJlT+NzUwqfh3qtPDqILQv5+evFlRTMH5PilAeTNQlKnV5ZPYUVBeFqmmo+byUG4XRYrm6c/uoIo9y0WdIdDQv4ZNbKwi5GF2ubeWauTRZ7+UzzsgaTbnA/LCzSQ+OpXDAGOct1ZiWu2yHmY0o7SOm6dHeeYRkm7KXrNI4ufjTzPf1zvCPyvGvazymbTk7ilX/2EtQKRHBTkJbw27ifyudbV0rdOg2mK9Agz//lDSTqblo3Gw/7z0X4OwDnc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a03bb5-1d23-4ccd-dad1-08de74832e59
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:33:10.1990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWbZBi8FBDMCYCguHCsCoOOB0vrmYCEMZUEnQVudC/Zgpwfmoq+A3hwIqlziFUzSSvC6PgjR6UgSmKG+7rchRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250148
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f163a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=SJyMSP20wIX46-KvpqMA:9
X-Proofpoint-ORIG-GUID: hwsdY4RIIuZHEBNYa5WkYl8GQ7E3tZ-T
X-Proofpoint-GUID: hwsdY4RIIuZHEBNYa5WkYl8GQ7E3tZ-T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfXxFwnrsJ/TPMe
 PWeLDfVzRYSKJDHePhK2LOnS1EwRPdEMDLJZi5KM1ABbNT23dtmvnRW3HTtjfnHMaowBqbveEDs
 lj0ltwu5mcd9o1zh9CiyNbAx7lRbMwPxD7eQnMKGNjIQ2RHGKP1+y8njdc5qMuBtoSUlwoXXbeK
 teG2A2b72YmN+xPNlC4zGRinIC3AIzcG3HchW3qK2QqOO93vzR2FKQqTRo1pUBTvg28g11BzMV8
 HCqnnHSmdO9ZgbyKru0a86Her9J2jaJy+RNKi3BnrWeFtBTZjA2d9HAC787GjkfsbCByY4NBXqj
 FB0PPoCgATrYrv+gT0h9lZa37R3ygJ1dGnENSKZ68TMhLlgIhKFl9SD29aQwZrVz/Xmr78w3OfR
 wKxPYrqAsBjl0i/w/CqC9cK1UONtDIezIrrOz3lKL6liaomzH37/ihi5r46gOgFgmhRv0HWPsUq
 uV5Mwr3KQnB5XG6B9MQ==

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 537579ad5989e..192ecd886b958 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -536,6 +536,22 @@ __releases(&mpath_head->srcu)
 }
 EXPORT_SYMBOL_GPL(mpath_head_read_unlock);
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_disk *mpath_disk = mpath_gendisk_to_disk(disk);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = mpath_device->disk->fops->getgeo(mpath_device->disk, geo);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_pr_register(struct block_device *bdev, u64 old_key,
 			u64 new_key, unsigned int flags)
 {
@@ -689,6 +705,7 @@ const struct block_device_operations mpath_ops = {
 	.ioctl		= mpath_bdev_ioctl,
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
+	.getgeo		= mpath_bdev_getgeo,
 	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.5

