Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A223368AC;
	Wed, 29 Jul 2026 02:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292278; cv=fail; b=YIBvw6DIIuj8Q9iqlDZTKIEVCV8oluZi0QDdL/xC8FdlNrn0vSrNWh6CPcO+pZi4HqJ91mmHiQ/Fxuidzf+yuuZuOaSP6kUixamGwsy8ZVMTEKCfm/mDM1/i561ewzhVz6ZI4IN4G/f+FT2H51QAt7zWLFPAHTE9zEA5VSZrg0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292278; c=relaxed/simple;
	bh=Dlv3EjXEgZYbFCHCwFPysxrM67r7V03900dyQRfrloE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=l2sE4aRM6CYVz+aHHSr0EzCil6IT99TLXQywykbGdAIVTiUF7dwIxsRSWn9AxYqKcVs7sHvxisL1WdVxITehjtsEoLg1xTzX1VJhjs9rQ9XnGH6U46686hktZwzXcJxkBEYdCOHfwril6vTEnoP3SduIBnzJhr0y+ihGzsgwY3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dFErMwYu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Agxwwyo3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dFErMwYu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Agxwwyo3"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItpqM2091565;
	Wed, 29 Jul 2026 02:31:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rVUtm195cB2sBZxGmb
	G5GaY15H7kBob73ow9T0qhRNA=; b=dFErMwYupL73UdLOQrQM4yj9REW9vxMHLE
	4W/jrWLXYIKNrw+SAJL8JiAPiZNu+Q/3+B9jbFa8yjFYx2gOibTLdxBayE/xKAo2
	NIEfcTxKp149BL1RLgkS3crv6webHe/Uv57PsTQEBsg9yllhNrr8wzuKB/4hFEPA
	MbWvgJvagb9KFqLkGq6zKaZw5vHBFpVh8iYYOTuUpyA+eC3CPgG0Xq8tJaA9hX45
	3mnh2BkKzNr1s7IfuiwX6AovHBgXzU+D2lxLITw+QUJhPl15s7piKYkzhxyS4y2T
	BDMjDcBVOX4AFHg+S2HqIIhPxHWVMNfdrDltr3eQYEfgYQj4MIHA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyyd7dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:31:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2TvS4018658;
	Wed, 29 Jul 2026 02:31:09 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8a1ejx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 02:31:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hL5qto/KRMMGc7Yf1BLloJEHowe9qoWytmv2gPlNHI9d2vdm0n/yDFVAOgK+bX7wbNEazOnrFusqW+Kn88w2VO/0NxP42Futs0iE396d6IDQZVH1fHnw1cySW5DpB6aqTUssdWwQPWZYk6PXw5npOZEyEgn+AEkkoxA5uSEif/sbxDI6DOgqHloFx8fB6v6cBaKMq25eADYTNhNQ5AuNTNcH7R0IxLUjddyXZmcLv+DT0eRrXJaVSid74rejTsqWm2bau5YRXr3N9sfwS110barm4VkoTrCzjrsY8+saCvMTPlC95XQARZz772RIG9bC+ITtNOkbyKNpxZIBvWsZiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rVUtm195cB2sBZxGmbG5GaY15H7kBob73ow9T0qhRNA=;
 b=fHLyPu+VKTnrPPGFpE7bHK4KZKtgqm3caSaHjG+x3X2MlUWI2IDOWrk6fWIei0UxkSSaCDR889iPMWMIFgE8jHehnXPcvuW5wV8hRZbrxtkGKDSrro87ZTCd9TkfG2HRn0TWiROb/twWEjlzHz72cJ91PMOfcyJYZZ+Ca5jkZAYW4wsea2voxcbbU04beL6ax6UyxtFPNJ7B9athouRe75/XYeNhv0LXlcK11Jzv5HiWLpmAi+V7brwVo//HYpqwRXOO1GwFk7lAkxlRsL9oZ40uZbp5eYK1+vN5MxdUdygq9SKbCQa4IM9eDbDwWEyt3A3gk04V0ZMkTa3Qs1+cnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVUtm195cB2sBZxGmbG5GaY15H7kBob73ow9T0qhRNA=;
 b=Agxwwyo3X2TE8SFT5WZGcpHtxvcLpzzPL2JFfU8y6xBRS6xTyOMittAJEhePsKlMlxyuzf5jTWrxn7ciWcr8wvFKLcyTLUzWiGCCIQcEMXAzzdQ1Ps+GFil4slO/DZG9N5kKI5sNHIVbxYl1XhgtlMvN6QKW69IzNbMJorQqzOw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4571.namprd10.prod.outlook.com (2603:10b6:806:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Wed, 29 Jul
 2026 02:31:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 02:31:05 +0000
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Julia.Lawall@inria.fr, Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar
 <ranjan.kumar@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>, cocci@inria.fr,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH 30/36] scsi: mpt3sas: remove conditional return with no
 effect
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260723184538.3888637-31-ekffu200098@gmail.com> (Sang-Heon
	Jeon's message of "Fri, 24 Jul 2026 03:45:32 +0900")
Message-ID: <yq1ecgmwmqx.fsf@ca-mkp.ca.oracle.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
	<20260723184538.3888637-31-ekffu200098@gmail.com>
Date: Tue, 28 Jul 2026 22:31:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4571:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c79454e-88d2-4c98-0a15-08deed1970a0
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 2WKFyI/PoFjStOCxMI+TNs7BDCptTrVxp8C97w6pzuVbZY0/hHZR2BR7uearFOcXuaqBxU3PtAEMiBtSDU0MUhMWOmHkaIS21+GGctOZBDG5zU/CGsiUmEUZ9jrz0tfv9PgavzhcIFqedp2DezXcnsbUIP6YXbU28ENETIUtNXGpAC/+gCBSwB+IQahaEjlRUgJbKcOmUCTGUoS23EUHvoYBx6hq63dMyeIUBhqYmhU0su//vSVM+19BxBMMavooZK1eRaj+mij2l5mF6xmxfcKyewkKLSz/E0W22ZdMNrHpBhkkzeRo8XKr+MI+JHhPOhs/ihMW11nvADXFNl+uUJlnHGF+MR9K+f/6v+GzDnUabogXTfX7LELpZxUZFdNJAueid44Jbh3skuHhXxmk80bWn+oysJwCLMlgIPNWQUmW3WFk5k4ZuOStmSX70a9RGV9/YaxWotlRdalqdUzKTG6ygJINDvMd/wv/eBC9FBHLqgKD2etztsAS5U+dni/blb742Z5H46lfzHUXD2S4eG4LZUTGZk6tK9cSxPTIWnhHVLBwV30OxRuQRizO02O0hLKv1a2RVBIUFgIItbxbrSxCz3p1Uc43p/WRdAGka61ptfYUVVGPTliY2SFVYKWCo/5VScmojybEdPDEE1EUKTLMTJPXmBkK7/4DASNrmMA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?bU0m8Lq4Y28b4Be2Vr2Yosm+AQ1giH7BHqu5fJEcMDfpUe/0UWvR4ujE0cYE?=
 =?us-ascii?Q?2ueeftUEu/haQEhE4Mq42zzbuqbEh2meeq+nIngX5ruXcxZCUuXide7CFswM?=
 =?us-ascii?Q?ZhO5l4/H2qpZVXJQMkql8D7+YdlS6Q0g+fNoHNk+0BRb08od2AQUtBt9nkvg?=
 =?us-ascii?Q?DK289nyHoFqlPFqG2AT/9i/LqrWzkMZBCjJGvRVUGWJhlj3aJ9Sey/7hfPgU?=
 =?us-ascii?Q?ilBv4/zYqJJsVJ3vRnp/qsIHtdg6wSIHNySuYc0G93svpd+7Kx92bY8zihKK?=
 =?us-ascii?Q?CxGEh0+MJbG4siBou/YnZ036dPkaWiVcjNn2ILvjCqiqiSXcs6mmSHgqxqPc?=
 =?us-ascii?Q?gjOheE10lUEFieOe67sWQqGnIc9sa21a8ajxoFr37hag8QC9TwMV9bUXlolq?=
 =?us-ascii?Q?aybaZM7RVMnpACZIKQ/vtIbDEm8FBzzUo4zjBpAiasMrUSSYRt4tPTVmYtVN?=
 =?us-ascii?Q?hsS9sDitVA8DYwMFHw5744lbwZUnDTW+ig3XqhmXtBy1RW9/BqD7Vhs+9Y1B?=
 =?us-ascii?Q?XECi8Z8sTOLrI9pMOiMa9Z+Jx3Dptnh6d1AWm1ZIK0l831TlozPgfVHo2Q47?=
 =?us-ascii?Q?O25qaHUy8TraAVfnmwbGfSY+y90X55xhfG7IGI4D3rPQxyO37jaNiKDtZOTJ?=
 =?us-ascii?Q?bZK7xqCN+LIenASgM8qFS8fpxMOLcPt7XYXq1SLwUbX1cH+sAKsnJzfCPH1Q?=
 =?us-ascii?Q?UHqMMGoUKYrLfA/ytJjsbgL87SgnW2qLlia/mFbJlfQwR0w/nDqzZ+DRNyTs?=
 =?us-ascii?Q?z6JvcF7GA4mqqqUgcVUGP1eb/imHY+xDBEuQLgjzdJcM0cVgSFptdClqgA/q?=
 =?us-ascii?Q?W3rmj1CzBe/jIQ+CDpZ2lCxHZKKLcl92hlfKKgNClClX8SoU7NCGJL5MTuu8?=
 =?us-ascii?Q?3ELEsFGYeuK62lJGew7IHuFJMaW7r5ioMNuxN2r9hwY6NMoWRYoYA+8XslAn?=
 =?us-ascii?Q?czCWylOj7JYIb1PfkQrQXgNxYM6ln0DcTsEqWpOhVTS1Jp/SPfJB4U9I+F9H?=
 =?us-ascii?Q?fFmENNItKguX0ryLjW5mpgrsv6yoMMBtKnrJIY9/DvdKR5Y4PiOUw5uM1Nvw?=
 =?us-ascii?Q?5XzcyLrsCeuvtB9vj30L3sLv6Ub3LeZS8eq7qLXA+fQyhDMZMx8+1JSiEYDz?=
 =?us-ascii?Q?wSNhey8Ci4I5gBBiGQ7fAhSHMzdFOr1McWAmeC6tQtlUIHsD/h9f9L8Jfy1s?=
 =?us-ascii?Q?79/0BuatXmwqQiVrQgQXv1urvymCbrNBJJPAFDQH1tiHhqWmFff34z1VO3Cp?=
 =?us-ascii?Q?h6PMikGelLQYQ14UjV9ihqj2sAiZ1yDfnL4VPRxq0WE5VJAD4t91gweS32hZ?=
 =?us-ascii?Q?HQQH5b+7BmD4w0FqwjLGw2ZCCVYoG1Hc3tdBSnBvLIC1pceIYh2/wYijxfwu?=
 =?us-ascii?Q?yTlAMifFlxdZBN0oG136wWhfoT+7MN8lmJEbR0/+q49jniYpggu6NmypnNsw?=
 =?us-ascii?Q?4rJAzfRuDVSkH9AJiHX4otEpsIbzrqs5oO/+KFeQBMDwhZSgeG+rmdj9rcQn?=
 =?us-ascii?Q?5ACJEAaXLsvZ7doA1Rglyg9dl7JD6UMM02/s2ZPBTDUvgDcokTbxPqLT/GCT?=
 =?us-ascii?Q?xrZ74emcG+ZOxXeVbMG+Q5lZ61dDo8NGBnJpomnzdo3t+I0xuaNbz4QjtBMT?=
 =?us-ascii?Q?gqV1MLy6LH54T0ink32d+nRfaioqBR+dF4lDu/rjfqq/I35+55jVhopoK8aG?=
 =?us-ascii?Q?yhrt/KVLHENVZQJm1GL9bKaLle5r3CXx2/Nay4tOidJpHwOpG6HCor/dAsKW?=
 =?us-ascii?Q?pww+Vet+RY0zC0YnoGCmgthRb9SEngg=3D?=
X-Exchange-RoutingPolicyChecked:
	fIX0u1B4rnccVm+n4GyyFn7LBnYnZOxsNVst7C4uVAla4unFPZgtpPcuMnMqiA8JWnYnkd5Jp0eSYdqwNoD63W/BlEOj+ZQ9KsVUC0EL7/jEyKOONHdv6RICl8jaAmyYgJ6IgqCWlCnFNYrerfVvZwMWG9BZSZFP+3NZomwFW+0AdpjyMHEYrh5xqVfs+dwXkpLBjQsFessovd+7oOm8C8KPRHZNc4mDHxTFfy63NufOxk4Uo6gO6xo2DVNxHF/AfUOsXU/R0AorpRwFkYDp9b27TblLTcYRQIDJJYB4PQaabWNIb9IH6W+PTcov2c4wiv4kutMcgKtDg7S5xsxFMA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dwbO+WMUj8Vhq9epVc2x1rMGHtO2VhzBSkV11LOitLRz46sQne/Ofu8259oVze3+b3yfF+zksZwj9ARI1Q5zvR7ytjp/FXfM3yGDaHylAHzO0mJHyrOm46k67cIyZWQ9NzN25O4GACw1lm30BuE6okYrvCgb3cFsAlMrQWaz6g6YAGUKIAXH0mw0a/EdxAlVeBMBSexEsIQLtRifp955+lzvOTgaRrNsFBOboqExXeGpWL7bP1F64835nbbWwm/hgh6nxRYAyu7ooJ75/uqwsNhQw2aEpV+btm8IbwcjzM2sm1H5X8CX4H++sxbrgosJssiqp5ffQ56tSVEDLS5mW1T7Ikgmtj7bNFVEBYI2EdAaud6e5mU4ZaGZhRe7wKX+cBeZ5aciVcz78rkueXgBJJc445GO0YjwMI90NmxvouarMYVcxPY/pgTpyzkn+ofcPYi/8J0pQzdWY9dKYcn6VOeN7tVDzOdVG/h5N0EnzjTWug6TyVNH7oStZP2hjC94KKlCd1tNszqNsCuShvofW44XtFJWh4kWwxiDPBjZq8LMi0QsNzMlPV9JAvQqE2VPCLQX0qeQOWVtRZubjrpljojWk1EvCPuuoJ3MfCylch8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c79454e-88d2-4c98-0a15-08deed1970a0
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 02:31:05.4124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bX4ozoruzAHZes6JRo/0syuu5r4B4R4XfVQAq/GMwrl926m0yt0xEQNeogeZpKZ8oI5gYHI8le9fQ37D6XuyUr8Y/UJVFFiO0AHOV6Dbf8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=860 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290018
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxOCBTYWx0ZWRfX/pWrz5Ekbokb
 ZqrcMXjIj+xkFa2+Luwk8N/pMn0Fd2FA9gFo6NUbynZ5rBAsnNnVVwTxIdw+2+lUgktOMZwLPmo
 jfMzD9Wh81BsmjfuzT+NQtvemXsqRLHNu9DO5QAvHP99pNSoxmaD
X-Proofpoint-GUID: wmY7H72Nuu2leY6DUEEgKcQkiolcvLGI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxOCBTYWx0ZWRfX1rISV/IKsTFz
 n23+ihd1lwYqaMl8Oz39obKbma3GHzYDp8P0P+AWF/s/APw93tgfQ3/ilz60vJ+STiUGShS1nKr
 7/6YYbqHLEokDyNVa6STFPF2B5tOqjxkT53BItxrg3Z2Lyoo+wYy7KQgtuTruZWB3vI2HtSABhm
 us2hfvgCep3St34V+KVu2lbdOUtU+M2rQ4OydcfxkANhMLYOLpcYGq2FJ/fx7hQJsVEFmNSUEiL
 W+dO5P7TmDJ/CdSqeRzfI+4md8VoVFvDDSFdX7Bg200dIXEXTtd/QjbFNoBT/6jf6oRPdFcXDt1
 duQ3P+cfU2MppHrVid4wm3hAUchkjkiAtpWTr3S68wpH4CrkeFnPN4XA/nM11u0BY2TDFbY6PaT
 S9ctHK/s+Bfg4Wv7o8w+Ix/r4gVSPSZm3MEFEZb3gRtk/eVuJ1l9VlYIm692BZ6iMhkw3B2w2ly
 jD2tR+WZFaaPwKDsZlg==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6965ee b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=uALulf2T401AiPjdZQkA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: wmY7H72Nuu2leY6DUEEgKcQkiolcvLGI


Sang-Heon,

> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
