Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5592C3D6D;
	Wed,  4 Jun 2025 02:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749003589; cv=fail; b=aiEiw8695oet05KmgEyzp7UsBbeAXCTW2m0ZoXtamrL68IMw/fFmNJ1GIQWWKEyoj48M/tF9QQaAe3U29oxm1//9NsdyXEzmIgiuLkPd9tVulrl5ZlPLjqRvVAMvkaOsC9gJx59vdYXjAxRSa6cz95dhH/HpfQyDvLlTMzxojDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749003589; c=relaxed/simple;
	bh=dJH9XPbwshSgVll7P8XpJ1oDDLP2oZnIfCWmpmOuq7U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hJWNG5UsrP4mzn3zRuHe/xSBooQhDpZsex9RG4nPlz1Nd9WipcX41IIjSuVvylp3pQwG4fXkkOR93Ul1g2znjvdCi/zrABMTChYh4Kej9eiCa/bnTtZhPwtlyJZ4ssglSMpN2iSqmYJ2vCEw+U1q++Q8Sfw49E0HT9yvvOU+8x4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kdwTtJtR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qEzHUqRn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kdwTtJtR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qEzHUqRn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553MNMa9006194;
	Wed, 4 Jun 2025 02:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lO1c1xoaBmNm+YDFuU
	hyFBmw74WzoQ3Ihlr9rkJOlzY=; b=kdwTtJtRZ8zgQ9m4C5kkGBlALTzKOas+wt
	bEF2rPXCx/heTRsYOoz5JFrpSVuBMPXItDYtniIIco/1zUZoNqdG76qYOey33hJd
	P3FFM++ZgnNkwLpguHzwfpV2jPj+/t59P7Jd5AHmTz9Xu2SWQPuwpq5kYN47XRyL
	TtvRayxW2aXINTX0VxwHGVkN/01Lshd6lcR2Ia24ir2cBZHd6s1Q+ZMJXUVroMLM
	UQFmM55PZ0XFYRnlhKeBDvST3DoHRbQsMfghbP4hNznnBR92vxk/z4kXYlxhEBb3
	Q6HkcZ3yVhQMBtKCDmkOFcxEXNOV+zBEIwuoYiv252RbvV99Vakg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8j343y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 02:19:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5541tj40033839;
	Wed, 4 Jun 2025 02:19:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7a65vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 02:19:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4GwdnLh/rVUbelWjk4bN1Nupm86ckpCTXPaK//Z7bY/CE7sQOjkks7e50YIf79ey3R5XKbNJ28PLgyMmhr+EBVtKTCn9vKxbFCU2l3zSR3DpdgaWfgNZaD0wXQz7Hy70dcVacLYGNfZkvDAJJtkNJz5+Nbj0OJaJ5gm5c0VvvvmabYEXnSnz6aU/ejGWGdayMr0zq7/9x0cD69fjrAU/RN6Gfr1D5AzoUQzr6iFys4PiGeO3fq77wetVZHjVlPLxW33U/yLsy5X8vOw/McwXrQDDMj4162NsrbfVhb8j4mKUa3tVQJTIGjT1IujxNrT91Q6i2qqwnJbVhTPsc1Aew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lO1c1xoaBmNm+YDFuUhyFBmw74WzoQ3Ihlr9rkJOlzY=;
 b=aoDFf+N76IvOs8OJ/KSlYOuqk3BPmJYELQp/WHL4CjHAcv/dSy51FvseehYmDsPOqqj3aa6+OzfbS6CzUcIx2T8aXUfe5lmYoEpHq+qG/5YmKch6Bx/THpXLuY6qGfOCg6BT7dSPL+orIXIFzYtRCFNywOFR5EvUH8DjGCXiUunw2b+jl8MVGYwuBJ9BZPSt1nUgyzVwH0TFagfVRAtLy7ez68CRR5CwkqfFizE7wVcoKESzU+g+YMh+Jx9na2sff8OirJroMbv2T6xzY3SFr32WEeVvEsV5OHfigK0Ql545DGbEe9iqR14vZF9AjoMCK7BCTqCjdA2B+pcNoInsRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lO1c1xoaBmNm+YDFuUhyFBmw74WzoQ3Ihlr9rkJOlzY=;
 b=qEzHUqRnJyB3H5VmjdO5V1ErVNGT4ToPKF4jvoNgTGePSlzxdBQe0Rn26vE0wWOscwTa6LL0F7EM+lbKpxW4S3EEqwEn1LJmeUw9XYYQMU1l1ba43jaHEjC4abDb08CGrvQBZwjlEJdvguzOYQzOlOD7XgiOQBsZARcu1nVs8d0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6082.namprd10.prod.outlook.com (2603:10b6:510:1fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Wed, 4 Jun
 2025 02:19:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 02:19:41 +0000
To: Nihar Panda <niharp@linux.ibm.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: Re: [PATCH] s390/zfcp: Ensure synchronous unit_add
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250603182252.2287285-2-niharp@linux.ibm.com> (Nihar Panda's
	message of "Tue, 3 Jun 2025 20:21:56 +0200")
Organization: Oracle Corporation
Message-ID: <yq1wm9sckpj.fsf@ca-mkp.ca.oracle.com>
References: <20250603182252.2287285-1-niharp@linux.ibm.com>
	<20250603182252.2287285-2-niharp@linux.ibm.com>
Date: Tue, 03 Jun 2025 22:19:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:408:f8::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ebfa98-8717-4e84-ad1b-08dda30e436d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gtvbQJuPTKOG0rZ1PUwEVK+rFUqlopove+7IpqL4+DwFX6Z/cAd2ftW70Vn+?=
 =?us-ascii?Q?GhnNnrsMuuIJ5cOm8oscKRIFLZI7M7G0C+IkiEN62V2I8LYLQRb2IDfyaHSb?=
 =?us-ascii?Q?kkyV29cHU66WVNV0bCHFMp9OKKy8EDsShC/AqAVvCgotyfHIt6jqY++Bcdmg?=
 =?us-ascii?Q?FAl0TjdpUGaWpD764hkxBYAEnOs1C3tb3mFObLpd7YO36HpNIoJoFeYSBlRU?=
 =?us-ascii?Q?yNd1f4j8Ujs3R9PeNbhg/24zoBY+8uh4dSTmHIas9kndfE5FmkuasQBE2um3?=
 =?us-ascii?Q?vzd21ee1+fM+Z7vXBZuG9xi+9LhxArHh4sUyqfoyJQtcJ6IaaR5yNo08IwKk?=
 =?us-ascii?Q?lYfykzTXUFuoPEIkvvbX2RPRrekVJqvZOvUXtgAndrnZkdZ58vx++fXEa4Gm?=
 =?us-ascii?Q?FCE2UvC+nv2VvKe8xrhP88tus66RJK2Mb52/tk7qcvqvNncKBCz6aHurIiuc?=
 =?us-ascii?Q?V+XUCmbO1Yamtof//V1Futtsb57MPNvrQWlKTUF4Zb1kSeBDDcb6VJLiMC/N?=
 =?us-ascii?Q?8k35rqTJMolfo5KbXik4NMHYi61F+u4naPOGHnGJxpM3VE7IblR9uRP8P9Ub?=
 =?us-ascii?Q?JbRc1O3M/mDkZTBqsWI0jnNM2LZyZaEknNKz30l6oZVoiffMMm5gd0V3sY7q?=
 =?us-ascii?Q?GGFVwJXR2AboGaOtqnSy4hDeNBROkd7QGSKeZLbnWvLzvyDDyvDitZ87lTpe?=
 =?us-ascii?Q?LHiXSma3C/07oYNfPo6tPmJYfmt2mA4pzwQPAQsWPVrhHzGptzjtRtbd+w1Q?=
 =?us-ascii?Q?zL3eYtHZi7AU0aCGOq9B1S1/xjF5Z7CJ5KtwsbEZGPUvhzxP2uQaCoyntOTV?=
 =?us-ascii?Q?PUiO9VB+1uMMcG1U4fUySaYgD5IVJDhZXXz2+QdfjCb/PVT/UoOsKMbpHzVv?=
 =?us-ascii?Q?DHFK5MEYEMfPv6XdnDDue1WOkdxz0XQGu+T1zBu42p7QMQIrWvwbDKr9clmS?=
 =?us-ascii?Q?RVbr4zAeI3D2cwA9/BTmniqT+gYOVXJDnw8arl8j3dDsasf/sd5awnc3LUf2?=
 =?us-ascii?Q?JJwZxLmyQiFuK333IZODjSQZoFcubjT4k0vMZ0MK8vpCGHTm5gh/sbRRhf+q?=
 =?us-ascii?Q?huTb2te6WkrxfG0Q42meagN0S9gbybIZNkqJB/EusyDZS5UjU9hf54steaI3?=
 =?us-ascii?Q?j7r1baFMofmdZd3B9fyV5xFJee4oV8uc5fzGwqnn6AZ+P1rK6uAzZvz0SEqR?=
 =?us-ascii?Q?xoh9xht8ku6PaaShgIOCCPptV1/LVhCiYIqJXaJpNtHsI+FgzLFB9qg7lda5?=
 =?us-ascii?Q?G1vLRK/5SbIw/FZHgeC2VYJLvIS9FF6/nXozNnOdy48T9rWadsRV2C2e3OHD?=
 =?us-ascii?Q?xnIibOdF5SI5u0b7RYhJn2mJr/iv95NfUkYDyWzb41DjpFQl2qqrMDNaajRx?=
 =?us-ascii?Q?q4HDS3szWO8ss2LijktXxnAjSbB4Mx6TCtSSBNxnemlCh7Vwr+1ptcxFu5gX?=
 =?us-ascii?Q?UhWg4ifgGW8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sxflY9QAHhH3jUfQ6cdCs5wdVTXYvbJQHsz3CBWc8eir8ZvNKuFSfmuUXPCK?=
 =?us-ascii?Q?eFhrHmBUpC1uFNBvvSss9DFpCzjCXDQWEMnHTbx0qJ5BSEWfDexd/GizLS50?=
 =?us-ascii?Q?zjOjPQpLZdxfCwFXw/U0OHvp3EqlZj6icpxytJEmQ9kqwYxVD1MnkaDe06w8?=
 =?us-ascii?Q?2sBaazGaqfAdvNG+Prvpe50BobCoF1ZbIR2oiBcHLxxLU0lc69AWa32ktSyH?=
 =?us-ascii?Q?9WeGs6GSKD7lKrFLPSZRGjQVpq32BqryUM/4ZqYGo5y/yVIHihynLH4vz9pI?=
 =?us-ascii?Q?y7jxnKNgF3Cfz+Zu0vNKhKo2ov0zP4JCHoyhuZ4LmTPD2mRidocDxURp+HD7?=
 =?us-ascii?Q?X3Pq9ai7j4GKgCJn8mtOFWwRIGWwi6N6/1Bgu2RyQvnDtb9zdUN6FZCh2hQs?=
 =?us-ascii?Q?DolEBEqkPC09J0WEY+01SCqGvGHUbuPgA1Wr2EI9YsCfP26kqCktCGIsC5bn?=
 =?us-ascii?Q?fDlDgyPAAYwOzQjXnOC0cGw/cVBlacdDra24BapZh3wk5PCM3DuikcqJ5qjD?=
 =?us-ascii?Q?LB1EbayuNc9/WW+5Tq8iMexsEeoFUcnGcwZ8TtotoqwTdsitOYSefP7lA0cz?=
 =?us-ascii?Q?QxfjW0UEVSvvNVK9whqdYNDNTolSTWOIyDMRfa9/wlBJf3oU00RpGOFF9eG3?=
 =?us-ascii?Q?G6SqkieVYFQ33PrVhbxwH79ykRLa0wRR2HKPQqt+m52ecPmTJB0vAgH+MZXV?=
 =?us-ascii?Q?JCGcH7VyMHv7sXF/3ovFY/PRSYRWmHlkA4tixPs9hfHF/PKFkYlRvfNRx+Vi?=
 =?us-ascii?Q?yec3fxcfNPa5h7en6HNaIbDqGqDrHPTLt9z/zzm+d8f7aAKvgQBC4kyTLJV0?=
 =?us-ascii?Q?XlVS0sGi1mZ0GtFQnw5LcGp0NYjVjNvv2K7DYVBrwXp2eB8JrS8LJAH0mwFj?=
 =?us-ascii?Q?1YCWzumGHJxN/dYs+wHWjmffh1ctMp/7Z5DYnYejZAk6h9ipdZ3d5pTbWLc3?=
 =?us-ascii?Q?EdZOGAMj7LrjIWu8s9/LADNdvaVvrZS3HrZ4o18SlUGuMXs6+f4n5WrVJtYx?=
 =?us-ascii?Q?vSkxEwLqfD1Xa5uP3lyF6O/LgtJOgT5ElKOhsEb/BS/Pia4OdmtFUxqVFlK3?=
 =?us-ascii?Q?cnqwFbtGK1YI0FK15GZ86NHQnX6dlYn4s25xPSdiZ28zEy41LGCGBOK344wo?=
 =?us-ascii?Q?4KTc4Ey0Fvj9h1D8ommmNYVyGghOi5xaH1xIOmDpDdzB07VprOl5UaeFdgz7?=
 =?us-ascii?Q?UtifKkYjVtvR7twy9H/QzbK8Wu8F/ml4dgGgwtO3zp1EZO2eoAs8vHoy/XjN?=
 =?us-ascii?Q?2Qki/wIHWfe4o8Y6dxW6tenoOXqVz8XLcyh/aUJVwcLAogbcMYZGy0/PpFHz?=
 =?us-ascii?Q?R3aDerI9DLj2Rvo2wW+pPmWMnVsaCpLlIFnJ7I32itpgvYkDaRiliy6JAfb9?=
 =?us-ascii?Q?zxs1qsD1qr///Z9V2D6Yk4TuwWWcUchBD/RTFkYWpNeXjvw57lmETo6GIobo?=
 =?us-ascii?Q?DdS4c9WxSfgAILgdAtjATqIRA4kJDqTW8cSNQhs3Jy28JSRlb+ZwjUsSCiHB?=
 =?us-ascii?Q?xJf6J0xsWA3ESCzTySxbvlc+n9Vq2hlhveHGnn68xNRX6YiRixzYs1jVU7RS?=
 =?us-ascii?Q?pzsE+3CoHYSQSjqqheaqxPXMt79CdWRHuYmwnY9U1f+VcUyZ6YyfhE0OixCM?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7h4CQnCAI60x812hQMm3WnHgCfU7Y2lN6z7KmDxv/dwOQXO970//pIXnIfbDuT+5NKCt+CodCXPm2jXjZVGpnyr+e1afb2NbxDWiuE20Ai+lFbzvI+Dr5dzbhAkrs1hCl0gHKpimf6upu1vBfaSzUWIboJPS6Taub5bbCD+ZQA2AT2nEjE9OIzxT9+CKPGVvIQZAKPLmXsUOp3iiLDBsTAiKJA+lVBV8QlojcFQEyn/fMt507KN0ePj//xZO9XY72pQQ12bebNdI2he42jrQc8EodLXCL62skvRMT4C2Gjs/sTZlD6BJOcmSW2u+KhfrbAYzadwLhmBKx7EpD1xUlfz0ScYvJkHMhW32pF7UG4s+XiXRFNhlDfGrvy0B5vqvC7Wx/CETxXZier56cV1fZNKzgBjL+rTgrHCCSB0W7dShDuIlYtnPU9i2uAaV7jZ6pRa1SYkBI8NeQAbXkefrhvQvhLWVeG4h9xaa8+su9WLrs19FfN5Cv5TiuDWBf5izguSsadsmQMwuDIRcVNWWChJ4/JJAPYLz/C4KKHaJYuSDiJN8QjBXWHtL7cMdenZJuftuou8pDpmOIxnlLWfLpiFkEZwEKWSPLA1hdbXm/8s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ebfa98-8717-4e84-ad1b-08dda30e436d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 02:19:41.3854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkqkm8pteQuGvwM/yfZqWzW5Ur25R7DAuUdEGr+7FwJ4qRS0+LlleR7z/hw9RjrvYb7RQMFsCU3y5TM3+0qaoE5xRS4HqZ3fqA2rCqdn6aE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=720 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506040017
X-Proofpoint-GUID: DiU8k_io2Xeg7HiwnGprDqkjF0m7PdUs
X-Proofpoint-ORIG-GUID: DiU8k_io2Xeg7HiwnGprDqkjF0m7PdUs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDAxNyBTYWx0ZWRfXzAhE0Oby4lGs 0z/evrMPq5XH7lnV43VXHD3Z+vBdWr8UGkUEUeDkS4T7QiZ5VmolwjD3xm7g+6uBJrZZ5p/r0eU oevWS5/gaZWj8hvvrRSAcNOehY/m0pFnJ5ozCMNjxlud6E7+uPy/6YWkKj8TDtQAzeLzrwKPF3U
 xRxrWK3hLkYcRQlC1J6IJg25VG0rjPH85FM3WbRfIPrx9VarWIn9LUjq4m16iYRET58y/ltCIxx ee8A5JboCs3D3O+d5qtr7z4BOCHsoNSeo2ePEsRoKLL8d8P+SqLKRRGTIMl3HGUS9nYLi+RcNkZ By4oB/AGRcC7f6uMnZoRTTrsZD1dA206P9gQbBTK7HVml2KbIsxWFhzkLS3NCVcPW4ZM3ZKFyF6
 v7c5+ZeRQqcbAerWJYl85zcII95tTqzzazNi14hnv/MVCs431MXfApMGt74PDm1o1/u0k854
X-Authority-Analysis: v=2.4 cv=QI1oRhLL c=1 sm=1 tr=0 ts=683fad40 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 cc=ntf awl=host:13207


Nihar,

> To ensure synchronous unit_add processing, wait for remote port scanning
> to complete before initiating the FCP LUN scan.
>
> Note: Adding Cc: stable since this commit addresses a usability bug
>       of the unit_add sysfs attribute.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
