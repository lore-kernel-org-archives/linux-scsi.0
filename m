Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3D43ED11B;
	Wed, 25 Feb 2026 15:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034050; cv=fail; b=gOoACZTRhtyn18CYOY90uAAmfae+SkB+UggadDJGRkexqhMJHqUrsHL3gCALJVD/wOgY1lh5bA8/f/Jb2DvQq2mMyu/VAQ1kTI20Qt3LZ0bfF8ip1EZNcKjqSqztUZOXw1eoqur1koMc5j3XgNtwZs8HzQsc3G4f0PXp2o8+sEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034050; c=relaxed/simple;
	bh=0K9gGkBobkRnm0AgT92If3luEBQmU0fMYOPlJY3h8+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CoBJ+1kOrtPwegTbAr7ogYXPOFWWaddDwY3l2h2NsZ5bYErsO6eElSH/4eqafiniEQhxUGEHFiEHUGu1utauhE9gsqpO57rH/PnrSrQ8J2j0XpzGrEX/b2Dv0VrskFHt4vGGiiAH30ltvKYiRoTDKLm3YJ3itzL4yL8lqhlcZig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=itushvEZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G5+D75j5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="itushvEZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G5+D75j5"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAdBgN817942;
	Wed, 25 Feb 2026 15:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QcblJYyW38+86A8vK+xtzRCaO0dLQA8tafh3IYEyBXA=; b=
	itushvEZcVBbl2SCQteyuY//cyZPnglYmzwS9ox39vrm4L9gW6fbAgXksyw/0Mf8
	ZtcL1ZRnh+pCFAAKl/+xgZMSJewQ3Hqqg1DcofXuvHoaZg0J5z1pnucfjR9iBpiw
	QE8tlmnLA+hhXpVwbEKLTHPIZsCl6oCBfLOILs1/Fo51gxTls1YyeqMbddsBD29P
	lEliQrdCSDRn535//ctpy25ROPcq8LKBcH3uFjVs3+CJ/yThbZG85FKrn373ekJ7
	1kdbeoYc3dUlum63X6RsWpAAbWNHAWHfqGUh71GZm0+7QDhMLe+E36O/0jt+kvX+
	/25wOSnXZmv3J+Q/0z0+uQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areet0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PFAHrP027842;
	Wed, 25 Feb 2026 15:40:28 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35g8xf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eItcm7o2tQagMh+U7PfZUnbCga6ESFptat8W+tett737N/eGjmYTpdCcKC2P4opOfwjB99wvvQ8vyNJJaivlPl6dLCi6wn3Z2ib4FnS7onkEgKqTnHaXb6OZA8hxFQOi2Ku0leQbrI+aZ7F0xrUSbow7Z5vOg4Pa65/nQofKtnHol3fWN/JjHnDUfK9r9vhcIFcANmY6Zl6Eh/aUK1bc1+r7nnaLI5j9FQo1thqTBN6AmmcbKuzHgbe1W3pxMiRmYmvEYd+6v4HRNNLzcCv3plSKPkv8AaExR/IqcSpf9pIaJJLsOjhsbeYYNfx7oRh3dlbdFgA8N85Wn/afZTbLjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcblJYyW38+86A8vK+xtzRCaO0dLQA8tafh3IYEyBXA=;
 b=eEVKTMQgqvPs6ZQQR5q0vXgGb0dAj1biH5TyWwmQihoLd2vssGOcso+u3dkDbggQHzDftx6egGG96tASHoIEIOSaXdzklu2rEvAIrwT/opGXTJfU4feKXgfF1S+c1puQ0rbdhRPVASSpQMuFDIACfrdOCBA34byV9Exxj/7k6NPCbIB3Ajycl1l/FeZQncL2HMGTt2zh7xqVe119S7yODCC5TOSFl1IOWBk+ntYV21fFHe4HETVXwqZ0Df9pzul/fThnnOwcGhvkOnx8nASUvEwIPShVVXel9dSXiwI69mb9Mrnb8kaXMErp7BkgUKiTecqza8HXc2FsEP4o5u8BGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcblJYyW38+86A8vK+xtzRCaO0dLQA8tafh3IYEyBXA=;
 b=G5+D75j5Jce/jAPbABqhFyIO368BJvgn345hh/fZ5d1yp22YsRY0zkRbRvrjt+jIzginDbDWNn2Fqk5/x7pCXf9fgwD46LxkVjlyWyH0mG5LNhUeh2MYnuAtP4nK5Jk6ifYIGyp/Iu8w0eBmC4vA1bOZ8i+7cZO+jfUqZaMP980=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:22 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 01/19] nvme-multipath: pass NS head to nvme_mpath_revalidate_paths()
Date: Wed, 25 Feb 2026 15:39:49 +0000
Message-ID: <20260225154007.1033735-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132F1.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::34) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dd6e2e4-d607-4084-0b1f-08de74843004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	zeweYNpolYBeO/Shpion3kb3Y9/r0z/SyJ20xwpP9xWSSLpSCmnyVoupzWwp8gRck0TepPOhfWPtUvdPO9CBr3TjULS6/+/cc/gHhjdYB/292YZXqqzpqpkNc20Xtf/eSgrMEmdpfdL2JGV71ZQ5sCZKMVB0yRjIk6Na1BxQXKWSb+tOQ1c18WeR0zTJIBotBgVhVSGnHELLKzKy5p4oVyOPV4PAAk4SR90ORoxC9sTkt/jVjXmkbM6atEsaTK5G5+h/rNDrlX2K2y71EKexFQktqbsWuxmVc9DXmO0GM+BJOJVMRkKInZscQw2NdpQo1UEbpNobMUUNRYiI8Yv/p7J+iF6Hd1Q2EGyeS+fc90VXZKtunrPg+Y8WMP98V0Hodz1hX8ekWZlXHDMXR7PiGHN4V2X/PUHuo8aWvpqE//VLZvCDY2b4HO2bEyJXbFG/8uxVMXL7GK5ncZ3o/cQd1+fNGUg+P7CGNZ8E+OQvBA8yami5BiljKvUpprdV0U7An+R6+25okm8XZw2yRU+PjVdqkuzWdLtQZS05z/BptGe9PtUwcxxQZetUQJllLdPsvyQhCZdOh4a3q2R3skfrxF8SPxyg9X1lJEZcsP+7Ot069sz8qPQzZV+QzOLqtN/Ui0qQ67SlVgwGyeJtIf43ejh1p2PbsXfFd/dJ4huE4+0HU7Dtu6JkHRE7cuG42IxulAMceHgouZR2HWiKbgF5L8HjoyqOtFbMogNvvPqxxy8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yy+dhYQMZvLKE3N8b6kjk/nqbWwXlRVOi6xjRHtKuZcWepnT10h3/xk1zAtq?=
 =?us-ascii?Q?FER64kNUdZr5L4lJL8mCMquwKaHUTCHXnwLt4nER5/OE/X143/l8E4F6Mwm4?=
 =?us-ascii?Q?eVlw5lPjPEreCWMhEdc3GhdktYpdnIXQVLlLpkJWDsCXSVMFrc+6oO8ILhrS?=
 =?us-ascii?Q?TCB2jlLUJf8CmaKVFbR4Mnj0SXFNhgK+SWpkRYZCWyU4lFcOz2+OJl0UViZi?=
 =?us-ascii?Q?Reeat3zA5DLlfeWPWcUULUtHD/L5aUmwDMFLo9lc4H2JVtHKAhmguhPElQFv?=
 =?us-ascii?Q?XwoMYPy0uo0iDyFOUPuUIjv1TBYmBzgJvPjZmsqR/Tf5SGBElZHgckhJ1E59?=
 =?us-ascii?Q?+19qi0gZXGnVkrqqnlpf6w+0ihYhQ3n6PqQj+T2zKE/1/TVD2/x/tZ6dypBz?=
 =?us-ascii?Q?RfqGaW6ybhUihMb+Sh0ZlYdWlvM4Ggm5FjZfHlH6DILNRBKgL5r0s8pW0iLt?=
 =?us-ascii?Q?O0yGUChmXGCIE3sLwKZMK0tfGszrNcuyUG5hOCDkicY3l9H8rQVG/SFjRk+k?=
 =?us-ascii?Q?OKonTiIt9C23fT3z+CTAp7PVQb7MTkiq/JHmlq8DCtSK9/17MEU5dQzgv3x1?=
 =?us-ascii?Q?j7d8pJu29TPgtq5cmPsRgzlEeGCPEXvVpfP/FrrXDjndz2OLLj6cKu5bhARq?=
 =?us-ascii?Q?N3DX97bmar9OTD9FP/a8PSik/psElNYN3Du25/kbcgSlRWZ0OYAx1NZB+Irs?=
 =?us-ascii?Q?Upn4cd8+IjIA75EHPpXmMYF4R08XXqfRcCR8OzYv8PGDALHfJhGc9QTd+uiV?=
 =?us-ascii?Q?nNMWNHkgzQKqfnsCBymGQ4jBKe//9kPxBJ89KDYu7VZs09Py1FzQgWMZXd2H?=
 =?us-ascii?Q?qLaz17PehLoS2l8nnvoe6iHb/kykcgJQpOupjLp8kbFHANFqxw10DnIcjpCO?=
 =?us-ascii?Q?ZygbTUqZG6FYo6YrL0eR411ZgPYPx2zKP4lb9iDsU6jlAN4SKEeFwlKuUrlR?=
 =?us-ascii?Q?4hAN3FcjELTr54GkYjY83HmOGZNVtg9RGVbodiSbwq3ZI+cZyLeFERLbOvI/?=
 =?us-ascii?Q?Ky9ilCqWe/EpJgfyI5zHjo+uJjgoN0PntOv23v2TQ5OtySSANUkpFczp/1HB?=
 =?us-ascii?Q?b8t9XuBdSCJYpzH8vMjFLMtaZbZ4agzWUSstvWgzUHLnYK0sVkfSIPTpy2Gq?=
 =?us-ascii?Q?LoOc/AVxmscJrSob7QfnQZcruYa3V/KmBPzGHu0Ht46y35dF2Pf7/9lNqzsC?=
 =?us-ascii?Q?9dF7rTRSH5rFgJnU9IxM8btXqM+lcqUzYakjExYHybKQ/Gl/zyZC2LCbQZyM?=
 =?us-ascii?Q?X1l0q4QOMueRVCTmDS82c1vCzBvMEz0XNfWx31gtapF9Q4zcXGeO+WC7Gd44?=
 =?us-ascii?Q?GNC3OKPrV3ZiX1X2VuUUvD52iVNPs3HcCzYPNvPsuwRos/u9aVyUNLWT26DP?=
 =?us-ascii?Q?t60S4tpgTJ5fpJNji8Tz8LNdm8OcLuDlCnAReATpA0nWxURg4ElEXfo06HMo?=
 =?us-ascii?Q?9EJcJymJtaTv7oP7Gddcex7t2hD4bY5EeSO4JOqlK4LJwEKPr6wJRTtiJtpv?=
 =?us-ascii?Q?LTQHiBen5YumsWUKhAPcJeOCrqBF5adyVyI7Ue/MrWv3oG2kXTsRg8FzR61B?=
 =?us-ascii?Q?VQa10nX0Cc5Q2JPbxlRi0BfU5lCXcYLm/h0xqAMIOvPsgpaAYKXh973zn0cn?=
 =?us-ascii?Q?tppD9s8QjWDGjJD+7mOkPLGZ0n0Xnl0GJzu7n33eOn5WYp78Xs6+2qvngDRb?=
 =?us-ascii?Q?nh1AGW+mjRzCIEitJwUvFIJV71mlkR8aZsLup58vN/Lf4VylNyjHbeU62k45?=
 =?us-ascii?Q?n85bPv00s+BYkmpAy7WSzjl1NdNmQGk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zCHQngQu4xVh9+Pvrrx+ktC+dJNzeQTv4NM1T08XzZmVaDvX6/bRlUm1nTIoLlAZizAusIwTcoXhHMaOBSopncY/wZyR8xBn5FmeWzGcZKUorItYxphPLVq/LycNs0mK14AloxeEfEpGFmaWLgn3bfHe+ZHqcagBi4wUaZ2mSO55Ni30DCqQMnmvp7dLT+wKuRSFFD5l5IwIxfFxgk/URoxRJgLMb1uPUQa/5VgIfzjDixUgT7A2NsorMplsH1lYus8j443TpsPVU/DHZfBPQl/Tnf7dIn6fM+cftnm2l/Axw87kgYm1Y8jZDxln65ctdsJESiShuIvW/AfsQyQrw0p6DH4uZe/2IImutXoywUluVxSckwuWZ5or9nZIsOZZ+fsyetGXrbHDA6ZorIuxJI/2lBgpJoSfcNsGbf883hzDh6uZHq86kuCEjR9vEAoDt0H1Zh/WzT1qNsrZyQdjbi3+8fGARuizTtBbXKXZT2i0iDLWDvrAZjZQICULAJoLXBr7RZ3PBhrjfVfUGLPTwQXYw/Eg2mc4H9tMXw2/Z6IgA03wXNGfxdbYAy2D9E+RbFHbUyHzVQ7XuIppyO66+03NWPYNvkkK4/fnemutMek=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd6e2e4-d607-4084-0b1f-08de74843004
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:22.5101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzF/U1FADp3obDRuiIIdyKNyLzdUccsBrJy5SYPE0WS2U8kJ2R9CmQRCq44rjJqSUQf7HAdezfpF9kN/Cbpc0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=829 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f17ed b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=pRep3gAyX0dtP_3rn2kA:9 cc=ntf
 awl=host:12262
X-Proofpoint-ORIG-GUID: 5167WXvQ8AXhfORMW8FJnaYflgDWkadp
X-Proofpoint-GUID: 5167WXvQ8AXhfORMW8FJnaYflgDWkadp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX9hWOui3JA1j0
 tarcfoJ9xY0ci7rbYwDAGipqjQzHxgxzCzGgDk6vWrZliVNgYW36FJfDphOGokmeFNH6caupm1z
 zx/26Ed2++ICXAkDCFrgma3qaxBK9//PbOXQnYwMI9YtPT9AwcdmkNzLsTltUQn5EGuKtOpPAQr
 kzjX0cW2zaLHba/j0HISn/MaJnWgB8UgrPWdnMLzB4YNFQjC56IPrT7hKaYj/cw7CU3AQY8TwBN
 aRITcCqmREdue9i+1EZZBUoZMh8+g82k3hOBxVHgka8uV+J8SBWA9ywlT8Oz6v9vgrFZ8eNIjAi
 SOsb5mv+4FE6Ut6YSfhb70XxQX4HQN1onnjDiJ2yPJlXHwlDyyBQrZNChZK+xgDReCf9djy0nYP
 cIXZIZqxg9bh0KpD7Hy97oCxmdvhghDwZZMZsCDBGl7gfhB3Hcr8V2FPiUvd/EbY5xwBWqSVhf/
 3tJxUwH5ZPTYYj2xhU15LGjroB7BUZfDBppfRUDM=

In nvme_mpath_revalidate_paths(), we are passed a NS pointer and use that
to lookup the NS head and then as a iter variable.

It makes more sense pass the NS head and use a local variable for the NS
iter.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c      | 2 +-
 drivers/nvme/host/multipath.c | 4 ++--
 drivers/nvme/host/nvme.h      | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3a2126584a236..37e30caff4149 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2522,7 +2522,7 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 
 		set_capacity_and_notify(ns->head->disk, get_capacity(ns->disk));
 		set_disk_ro(ns->head->disk, nvme_ns_is_readonly(ns, info));
-		nvme_mpath_revalidate_paths(ns);
+		nvme_mpath_revalidate_paths(ns->head);
 
 		blk_mq_unfreeze_queue(ns->head->disk->queue, memflags);
 	}
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index bfcc5904e6a26..c70fff58b5698 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -271,10 +271,10 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
 
-void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
+void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
 {
-	struct nvme_ns_head *head = ns->head;
 	sector_t capacity = get_capacity(head->disk);
+	struct nvme_ns *ns;
 	int node;
 	int srcu_idx;
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9971045dbc05e..057d051ef925d 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1035,7 +1035,7 @@ void nvme_mpath_update(struct nvme_ctrl *ctrl);
 void nvme_mpath_uninit(struct nvme_ctrl *ctrl);
 void nvme_mpath_stop(struct nvme_ctrl *ctrl);
 bool nvme_mpath_clear_current_path(struct nvme_ns *ns);
-void nvme_mpath_revalidate_paths(struct nvme_ns *ns);
+void nvme_mpath_revalidate_paths(struct nvme_ns_head *head);
 void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
@@ -1100,7 +1100,7 @@ static inline bool nvme_mpath_clear_current_path(struct nvme_ns *ns)
 {
 	return false;
 }
-static inline void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
+static inline void nvme_mpath_revalidate_paths(struct nvme_ns_head *head)
 {
 }
 static inline void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
-- 
2.43.5

