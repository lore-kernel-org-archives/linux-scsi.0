Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8B96AAD;
	Tue, 13 Aug 2024 01:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723512832; cv=fail; b=p8RJ4YvqugMIyla26hjqXAAQ034iUGQqS9Zun670vV4SIvAaVzbRyFn54nCvuwGNLbxtIBEmf+QWo+z0u0z1ZxTydjUWFyAwYUnoAXnj5oX5/6dUlFYLnz6Gs2FdWcIqOy34rFx7d5rIuX7SJNXHh8JHTds2PILlDuymKP325es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723512832; c=relaxed/simple;
	bh=q42OaeRtF1fl5kpVYVZ3K081AvaxwkVWox3BBLWbdgE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KKMsia+UPCl2KJtB8uGObaxaPwYXmEoZQPbIfSchuXcaEryeGXkeejFyXFQwfseufrb3z0psaO+7G2afucfyEswze+L1lS4bp/I/FhwwneA3ilyLwj9PTXnqliRugUFjxD1Yxel23LJ2N4amdsPBfme68VUMnbOjbkT1jcP6jC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jQFCHwQE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FD1Dp5Au; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jQFCHwQE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FD1Dp5Au"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JdG015040;
	Tue, 13 Aug 2024 01:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=UmSFrSNJfAAyLd
	WDKCCQW1Hf9obMIvPEqpQb7/+IZg4=; b=jQFCHwQEekrxCh57JFjtxQ3UwGhgIi
	sw4q8atXh8WMv0y05CivTf+2jAF3za9xycjZw54AbSSk9LK7RypTzZiS/FCn6GrG
	tbylpXxbpscP6hNNs8d1oiO5WMz1+ZSm6DrXyu60l3eYkYz0RFMiPJxe56dqnb4v
	o66ziAanfkgpBLujNB7qn6sNQGc4ZYv4IgAPQDLh6ZUVyBsqc+2KlIcvv1EIXGab
	2FTyBo7rAt1a0V012V2ZPWHyoXSZFNrdJ+P7ISXYnc37ed6aCvIL1I3FDAZLb1bh
	F2CDaO6K/7wOOMGPP1ZgxhNjSjTmHiFoEpY9yy9Yt6sUxKApLB5Cb+qA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtmwfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:33:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CMwlMv003460;
	Tue, 13 Aug 2024 01:33:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7ux44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:33:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zSN/K19TGPDMks2pLHL+cn6R50tNuQYI0AXJPRpGKWBjX9UZUNRL2POeXoidlkA3sjmU5PpvtvxYekjt27zAJUDSpkS2DD9KG8eeXIP5EtwEB6k+9+VcVyUS1URo3ef4k/yI6YFsDnQE5atPcqJ4rYRv8KMVwl/loxyilZhLnn5axvVi48IWhwGnBIhApyYFttfOsthNr7z11PlFFzrcQGU2/dwpuj14GC2U8rKFbaC9NMhR/028ZnD0/Ug22dvM2Ls382ji9ehgPFk1yxTXZUVdbfPOVFWuvA6OJCak2sZE5fH7Sq4gQyTDDeD9eOfd1mAsUUudJFAaP23EPbbUmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmSFrSNJfAAyLdWDKCCQW1Hf9obMIvPEqpQb7/+IZg4=;
 b=by/0BZg+xFN1Qkz2lDGfY6BPwRDX0xCpSlovfuueRVde/FhN7jquqgnVIt854noO2oXoObKt7z7etESiPVyKKqP8aaahJwyGwSBoHt+g3j8Vnm1gR6S+HLccQBGLQVshlI6iBXRMb2Qeo8Lp6+OZG/DaeNpfTBnm6EO5g1kiHQ1JcFs1lyMh7o6sqwpNmrRjPs/Vw3aNCeJo4ogQu4hs+oSlIUWBHyYUKVP+4zs8A0thV2EYqBI98QpttCZQdSMd4tnufYAwBg9ghmkUSFLVAlZ4mJYHafa5MuH4P028WT+zrHqvLvrSZMMUc31FezMlPwP8bysVuk08uEqjhdYfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmSFrSNJfAAyLdWDKCCQW1Hf9obMIvPEqpQb7/+IZg4=;
 b=FD1Dp5AuVKFh59yoNhh84TLVdbMy4E2Bbb4rEVFjJuIILire/kZcJuqTLK4rJswt+kTyj6DWugt2yyE4CCTwXlDdOfKCqX0K3IxH0dp7dqIMVOHD/FqzSX+Tl5h0H5q5xzoOZxjahnWNG7PRwQ+s4pBuEO1ti2n6bb7GqN2Aa6I=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Tue, 13 Aug
 2024 01:33:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 01:33:31 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, prime.zeng@huawei.com,
        linuxarm@huawei.com
Subject: Re: [PATCH] scsi: sd: retry command SYNC CACHE if format in progress
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <7e6669da-d723-4eb4-8849-77e4deed5ffa@acm.org> (Bart Van Assche's
	message of "Fri, 9 Aug 2024 12:14:54 -0700")
Organization: Oracle Corporation
Message-ID: <yq1h6bpxmiw.fsf@ca-mkp.ca.oracle.com>
References: <20240808021719.4167352-1-liyihang9@huawei.com>
	<1cd0b145-431a-4d9f-979f-04d4063eeda8@acm.org>
	<e6b05d46-7acd-8364-2826-c14e342f8e2d@huawei.com>
	<7e6669da-d723-4eb4-8849-77e4deed5ffa@acm.org>
Date: Mon, 12 Aug 2024 21:33:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0666.namprd03.prod.outlook.com
 (2603:10b6:408:10e::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4459:EE_
X-MS-Office365-Filtering-Correlation-Id: 357c244e-bec0-48d3-8088-08dcbb37f0bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?djFtLgg0o1ulU+VNsJ9yHFQsrUiNGM0XcAjOyUi8TSnqhwLxsZzHxl0ODr2j?=
 =?us-ascii?Q?zaxOQzbVl2q2HsSPttuHYXxWjnYPmv4YWn7VRR0HUPlDzQrh9G0SIhj+O1kw?=
 =?us-ascii?Q?KAPQexrOcQf7wQbtBdbq5k/eWGSninPgKiQdZI/R69B1P/k1n14HykeIUnvA?=
 =?us-ascii?Q?IYcgGqROwjKg0O+GbGs/H552xud7467kGp5ayLXuMpqDEDPEk1xNLOhBZgpy?=
 =?us-ascii?Q?twAswukYd9t9njdTHShCrWPi5by6qqqsPBjstR7sXjskrTmaHNVwH5XFVVU9?=
 =?us-ascii?Q?pFKTCa14UNVrDEVF1zqYh5mO+9PdVG4s9ysbAsrkzixCDeOOkbUQcltAB7xj?=
 =?us-ascii?Q?tw68PNxfvs6MzpabN2VSLAAmuN1tXAtJ+/PAi/8elkaaAZdn4E7u93Q2HIDo?=
 =?us-ascii?Q?+l/wIaxKwYkQL3b6AGHOAeTyFhZ76ib5j3+PvBOaDaQpiAvOJME19Tun6HTt?=
 =?us-ascii?Q?S4iPHStcR9hOHIAxD1C70r+2ZpI/+5UyG28L1DUngCZSZSEhUwIyHNBEutYs?=
 =?us-ascii?Q?f0ySKKER401rivzumMJEYtJg9kZXPmgLgOFfoFwsRcIpFj0wxuBhLkNtZkR5?=
 =?us-ascii?Q?uPEAPddKSrLN+IhYTy7RtBaQ36BkI6HMKMwOIjZEXyTFqSuGZbe5TH3QEwdc?=
 =?us-ascii?Q?1zgscdaYXDgHnB9es9xzDZnEDtdTJ3g/nZ/EwYjjapcNYgAqcJYyvuyqdjdM?=
 =?us-ascii?Q?In/oLp7uCJ7U6kPEyU8i8l+wyFvMEQtwc7F2tyPTHFnMV+p6k8rqA946yt/6?=
 =?us-ascii?Q?yb0NwnCzi2oNhTtQbZwdpBlLzuP7QGnm4ykzFVKjYJB8gOk8evOeay/Tmml+?=
 =?us-ascii?Q?0GuJuFNwD0ZlzvXEvmrsNP4DaAr+bQYIV4xCh/jPm731C94XpPxmbDnRLsZf?=
 =?us-ascii?Q?mqLSDdl+bTN4OC83wNU/1T1Nvasyis1XXYq3Vtfq7S1rs+CppAf1p9E6eyp4?=
 =?us-ascii?Q?wlhgv+vE5X03xvui1ENAV4gJvbxDeJCXKv0SeS5Ofw6p5NUy9+CmPxXL4NUQ?=
 =?us-ascii?Q?t4/5mZcGD2V9L4xtvIh/ZZEvIT5yJR3E5puUJo4Fddx92RWxp1ePLYwB2deM?=
 =?us-ascii?Q?yAw+4FQftMD+bfJB/0LVwErJLsy2WIMgFjo6j6KX0LhMjFgG4gTcLAkwfMrT?=
 =?us-ascii?Q?CRPcJieKaBkZArzDyElEILDgSgb3t3YNWf9eh3eLfhq6y3PoPqNvERx1iYYV?=
 =?us-ascii?Q?v/AIXGMRoWAIyLV5Q3109PbKKSl3ZuggAYyVEosOz6E9XAZHJsvONK64BJUK?=
 =?us-ascii?Q?jVJEed+qMeJkAVUcoztf8tE3wiJIXmNhxtiT30/iwPufb3zm5GLoCDyv+YuG?=
 =?us-ascii?Q?BVSvscGPcUsC8sWI0yPtLPqLsGunc6Z9ChKX8F4mUJtpyw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xiF54MEd46w2hriTB1xn0E+PUc7s5EJ74Eymd2pmpIx4l66jEKTb8upoiuT7?=
 =?us-ascii?Q?PBKekFKmRAy33/Epk7CE+RxJr1naAPQw57JMdY+AC7PQ1VUbTxfyo5d+sAwf?=
 =?us-ascii?Q?YI0r361A5bXGr4LKiyTxeoorxT5uQaKEjsA76Ly7gxc95/s/IjTlLX1PqSbW?=
 =?us-ascii?Q?YLINVYqyhrI8RLDM3ayXIMYJtZ+YGasua1KMuNERvXXsoCFmXQ/OPvosLrj9?=
 =?us-ascii?Q?zr140HhVlcoPkVHDJqItmVAVSkHvy5pL4gvOQafCmaWwWQu35s/NR32rUgBv?=
 =?us-ascii?Q?1qCC/O/EosmrUcZjog58B5x4EHzz4QqSRUGdsBgi5HCYp2EKKVVqYGQClzFQ?=
 =?us-ascii?Q?OVSqkQyR2/LF9tuvvf51RUv8BDkkh6mAVyLEHCq543EQuaDsgjr8OgMDS498?=
 =?us-ascii?Q?/UBd4rR79Mih0Mybr1FZIjap6ljDnQ9bWzm9UHcdiUdUB30+9nugifxaZ0RK?=
 =?us-ascii?Q?1o0FVDU9h/pMT2re8R7EL/Kj3hboXzUfj9nk+gK+ONFyAnsSGv/tYv+lmr43?=
 =?us-ascii?Q?W7Zbody/1dJc1Pq4tYNR2ZrRYK8I2MCeiQ/u93KayX4Ou8pUpWNB8wa+RfqL?=
 =?us-ascii?Q?khPurA/+kE3yI8pObKoDbXC9oEhAK6I+s1ZhfeW2e6+FC7DlzHSZzN3MsPGs?=
 =?us-ascii?Q?SHWUalVK71MtFZP/AOKbrHxm48/ZzuclCNaf1crNMx7bHzxCqOSDkcSUjXhy?=
 =?us-ascii?Q?HicaColqVVJhojULAbJ5UHI2aYumAQ97L406pnQI+jMhw/36c1AfVa3+AHBB?=
 =?us-ascii?Q?zZqKjIm3+vh6o2e6xeB2I7yxcnfVTqk+/VfiPQafUaupc2oiCoODnEJoNSRk?=
 =?us-ascii?Q?A6w7ad2N+N5gMXhG1EarqXyUMQMM3RD8NuSCdVu1hotBNk9vkyTfyrfiH2YO?=
 =?us-ascii?Q?KltaLP07UskQj3P9pgw2BiiKKjTsnTsxIyZTcOBvQe7+J9h7pIRLPv6Lxuxo?=
 =?us-ascii?Q?JUTp8hdeF+Gz0/VwKA/hTVh/PbJ/HoooMbveUY5KKkQegPLasmBUMZ409vz+?=
 =?us-ascii?Q?8MkzFSpVyXMTa1KicIBGnfV2hMEEbgEu6CCO7NRbjhbrn51Srw4eQleTyqUL?=
 =?us-ascii?Q?HfTbs+62FxLqljNrxi1AggwF/FaqCqMqk3vYbM+/oIMAdZM43+L9d6MJEzSk?=
 =?us-ascii?Q?AQEFZoP4IgFmZYADxBgdSLJamSxFq/Z/9nBBZ8vZd4rVFHgGNy3V14sg12XY?=
 =?us-ascii?Q?e7EQrpPwf5XQ39rHne1eKzdLryJ0QD6EGmnPnb/4461fzIdczxqz9wWEjdZK?=
 =?us-ascii?Q?tSMZoKR4i2QeuLj1cTkYXixvbVhLrES9BwAlwyvdud/uTuBTTeSnGwJOrfaZ?=
 =?us-ascii?Q?WljEYZ6NTzelDdoehVOTosb69QD3xQc6ZHYuMsGDvsTRHlPTgq0BMRdzll/g?=
 =?us-ascii?Q?zoaNFrVLasNGt16W1JTiMDLjvqIygycpZ1282tcKVCjQdRpzYQsmtRQHNUFE?=
 =?us-ascii?Q?i5aIwSTDspybR+CEW/EHfU/tqckO+Ijk+zBiW9R0mS60vNyJ8b3/88SP4uLO?=
 =?us-ascii?Q?bTBmRDR24xf8eLp4x9WViXrDxBHwLq/4jMJgJnkISsLHZbTaKIKcZyaukADS?=
 =?us-ascii?Q?EJg0+r7S/dyhBujyJmdBDyJJJ8muEqu9df2HJrjaACF1nBjhztnM4SMlUUQs?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RL3wmto7MZ4IXKOFOqReWKtdvx6WlqcZaDxvxf/GO2jAtb1IzAmzA66aCYu2W4XrDCQG5KNDG0zROes1xZyXlg8bcZNnYUfq2NMaWZUhDU6vPS8rr/xQS7LZr2KIIj6z+uICXNoHppAfvUEXiT3fuYG0DOr/Wc8S4GFYQX/H4/54V/SebZ5JWGBCwgRcELSs3bqnuXu84G9UVmUL23plRsSZ06Q1zmg3HggV/PiCEyB1Oph3MKTHz5tsCAqaZBBPSSn/F8FWjwzWZTccZywQ2z17H46LKKM95nY8vbhTjGbhr1c/TyVOXi2v5oXu3P2akfRYmywkQ8n1sDHfQ1LoMMnn/Z2yWFuQnLxj+Qm0dfWY+ByRHU3qSVtueTll3A3kVQ6KcLs68Qr9Vv3d8Bvs3t1EZYiscNMGgVJLGgePiPZYbKeGJdtk+3y5x8V6KAOAXaFxWevHXm1I2sRbFTyUPc+VzrziIurMgL1iOKSbbPmICJLl8GgMd8ob4PeALeFzx9yuDpkdC0BnbfbNwZCxTQyivluKVRikDbznMBWx81GiJBw+rw//7zurKvuOujRJBCRb0nPkEseS0JLIfWSoX5TCoRjcabQnR63dSi/RwEE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357c244e-bec0-48d3-8088-08dcbb37f0bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 01:33:31.7360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2yypyevWiYEOFFV9oRtyVIBOIv+TEwfBxLbcjI2IColxtVoMN7pmZ4x1uemLo3tpyJmrysBcETILJK33G1K34TssZkjxFJMWNzU2ASDTmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130009
X-Proofpoint-ORIG-GUID: 8flq0LSPez1ijx8kEO35BzrEX0BFyRhG
X-Proofpoint-GUID: 8flq0LSPez1ijx8kEO35BzrEX0BFyRhG


> It seems like the PCI core supports binding and unbinding through
> sysfs but the SCSI core not. So it's probably easier to add support
> for ASC/ASCQ 04h / 04h rather than to add bind/unbind support to the
> SCSI core.

I am not a fan of trying to cover all these revalidation corner cases.
Having the ULD attached during a format operation makes zero sense.

NVMe handles formatting and a few other commands differently based on
the Commands Supported and Effects Log Page. The SCSI protocol doesn't
have the same elaborate reporting scheme but that doesn't mean we
couldn't handle disruptive operations similar to what the NVMe driver is
doing.

-- 
Martin K. Petersen	Oracle Linux Engineering
