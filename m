Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55DB204C09;
	Thu, 13 Feb 2025 02:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415548; cv=fail; b=GsnzMbMWvyXmg2vrbnRg8yC8ASgfryPOWQD2oNxlE0irJlWBkDp2+8AVOFiNCiXk6E5D2vIQwDeTZjFQyfg5IZy8K4JKgJQvZPEA3MIwaBM5Vivc/GJnVmHyqiEBvqq6bNknH4O3CY2ChV1GGy0Khtwroo5ftCKj8Ws0jgkXpWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415548; c=relaxed/simple;
	bh=JlBVdJP5BVgL1xvcUX1ao1x1tAFi45xUcgFJETqDxIM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JxAXaGG89Ln+Ae4wdBZV52kEDu28AK3NpF32m61rpsxq7V1j/swRu1dyix/ZGnzP1YvUxAIRdAGM0MYtQ+aykSkwYJWpP5iYPkHJNPAIl25xKQ4n9JE6Z8B2ivcgihTV7tT/2yjiQKGxLaTNe+oIl56w1o/bT49VFP6KYTSsOgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DgAeeb3V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mwi9N6fU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DgAeeb3V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mwi9N6fU"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1q475008090;
	Thu, 13 Feb 2025 02:58:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=o8R1ncNLFIFU/Jp8vW
	RcvvPs4VTtlB4sb2BhPNIZgLA=; b=DgAeeb3VwY3BWafnDndQuSosgHefB3Qenv
	NKHnEtUd7hUCvfXbLVl+wfTemQokhLtmWbBRjJbChdKbPOJWoN/5ivwQlk4W/Rxb
	9iUt9Xl+cvVjMAhPt9d8NZiOTyQDLD0ciWP/qmaRbapXS2y9+Ruc5zGWmeq1v1vv
	TKim7B+fjFQU3OUC47E3Jem2fgwyUgen3BwZlBnpDmJbKZ4mLIR+P4+3KAb1Argb
	r7iTQpX2rhzUEu/rWuYFmoN3EGpYRYxUM4FOMvuLuk7Suz7SJmct3nPpPBku8EKa
	cq/yjxmiRajouVVpuaXPaZu2oi1RYgx//HjB2rQlNMwuQGJIxMRA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq8vuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 02:58:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1UZ5R012413;
	Thu, 13 Feb 2025 02:58:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb47fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 02:58:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qxD0j8jSMdmY2zvYFIx4amMSkwEyKbz0vCR38Bqt7ZMxvs7cB/kIBhbr5Dlm3cHnxrdccCUV4tBLAUT0Yb6X79Ty8mjoQxhdAEN0ULHBKQOEZ2+MLo6strlNW4Dr1KfL1BK3n3+qpng89fKaa+KYr0LbprICxNlbGfNKKsl5NrSziXknmsyxP3Dv7Qtvs2TXMuc8ADpkHpSMJbyO1LtHPtA/VS5Rpsr2s6WaRJ9aZMEuYfMu1KLIKhtt+B/qxiuQL2doWTgyeWC9coGPLCveKundcuel6eJGJeiSXoep+zPp34XsafjG8r9mOJvjduIenWa71SaZzwh8GBJ0mcFq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8R1ncNLFIFU/Jp8vWRcvvPs4VTtlB4sb2BhPNIZgLA=;
 b=ZPHNNB9in4znpKStagUCQtz/f+EpMeQuOfmkkWDtENoNjgNjIppRBCX90Nmue6eYMnemBArPZ7s9zUB+HTCXq9lGqH0VYIzLrcSadr7/gIzobWTq/FrHPLZ1fruT+b5XZ5PBqDICM3hI01zuD9N1iEObd4aZNEJu2Ytz/jfCpcGf8or5ynfvU//dFSLuq0kVwjF9gq7BKsTSw8iTn7A8CjeYB565vXGytCFBySBwZT93RFOjUdwKYg7VbhZBtsnLUE2j/V+Meini72zscCA3qi9gpexV4xTleGUaM6x/+BkzdS+kN60AYpxpPnKdd5qjNklZq/LT7iWrcaBt8AtzQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8R1ncNLFIFU/Jp8vWRcvvPs4VTtlB4sb2BhPNIZgLA=;
 b=Mwi9N6fUIdWyL1Ymv6G0o6l+Wtr2+pxYIDgz6fdXhzoA9Ag9cmotLniqBKVfAjAeScs8Yyuq9HLG9pkI7Xd3kpPsEZVxfCneykAEnTQmAekBsvXN/gpvUHquc/jzuLSEePXw0vfF0j6bTJo6oMq4EAAwPKJFOh+a69qD56A8ZMQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB5988.namprd10.prod.outlook.com (2603:10b6:930:28::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 02:58:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 02:58:49 +0000
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Reduce log level of `set
 ignore_delay_remove for handle(0x%04x)` to info
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250131171640.30721-1-pmenzel@molgen.mpg.de> (Paul Menzel's
	message of "Fri, 31 Jan 2025 18:16:40 +0100")
Organization: Oracle Corporation
Message-ID: <yq1h64ywnxj.fsf@ca-mkp.ca.oracle.com>
References: <20250131171640.30721-1-pmenzel@molgen.mpg.de>
Date: Wed, 12 Feb 2025 21:58:47 -0500
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB5988:EE_
X-MS-Office365-Filtering-Correlation-Id: 839021f7-8b4f-4164-2465-08dd4bda5719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NCI/KqoaC+GiCSMr1HQrXSsjouWC6aryyZGqeH/bgTmMxSHA1Re60SxGxw7R?=
 =?us-ascii?Q?hTwDotlULyFAPWAxVhoBHQsHWBfnOxIgH8a4pMe5lKHdZ6o25rMUVWiek5xj?=
 =?us-ascii?Q?l0pGi04vse05PnLggXl6Srt5jLDWIgvZvFaBDIPmHmLYkJSLNQ2RYtggK6JE?=
 =?us-ascii?Q?t5QXPmje2H4T18sxaXcEYfPKTBp6i/zaM7vnm1uQZDR9BRB6nLU41ahqIblb?=
 =?us-ascii?Q?p4PH+IH2BZccsQX2B/Ty9QIjJFekL2uQ9FixHiGYHJ90auM0EarJPWThVRRA?=
 =?us-ascii?Q?LSX3b09CXxF2ns+3z/PVx9oOUYKLHXhZbalr8KFumoRbT5SClObcGHgCnVnW?=
 =?us-ascii?Q?eebm/3SkGEbEL8NIX3J9liaJmJF8QZemjvrM3ZDnnu0dK5PIy7bJsxpBqW6t?=
 =?us-ascii?Q?+5zWAuJeRgEGrJ4NxsbIOkDjLTWERPokheUDjT9MGIm5LQ2uV4POCl6wjHIP?=
 =?us-ascii?Q?IC20NpiJv9hpe1qZD9c2G/QXLZ3+9SGKVhsXYn920gS0phWWVlED21V/zq/H?=
 =?us-ascii?Q?Pch2LFL5FRFeitOWvVbiltYWq5tJKAZ/UCZ4s+aXyyWqDOx+bWolgiO+IUvQ?=
 =?us-ascii?Q?xWFTN4jyvTXVTzyochpTiz8S9UzC8QiYVuFlwMAj9s1LWSpsXhqjpbilepgY?=
 =?us-ascii?Q?5R8BbxCZujSRrVdAf3G7EEGT/1vXp0wSbepEBPK2d/9sRnvJ0gMTEQkg30uj?=
 =?us-ascii?Q?GrD3XPPkzY/can+KrUzPiihd1H0XSGrSZ9Jt+b28QGG2KMCchxQ9+pAMi6Fp?=
 =?us-ascii?Q?vPqyTMui2N2ShriDKwCdm8uUXB2ocobCyUEQSuQwB1L3e/MjrZdnYxFy9rV5?=
 =?us-ascii?Q?BzpIG2DaPquyKDuLVoGho6RZ4KE26llyvHxB4HVgdBck0VndZqvhW96ZX7cD?=
 =?us-ascii?Q?6niKBso0pR1TXFq0ouBM5MbN9cu9Dgfp3Q5sh7inbFmLjh+RgcabMGr/uCa0?=
 =?us-ascii?Q?SmSAlNDtKRM6JAjztvh7BDqj2Brs5nnRiigVmuACz1o2XdAKWyFRB1qHbmMp?=
 =?us-ascii?Q?9jcgHnadX113eqjK/kBSgBwgsTtOQmpHYehVkk3CTMYWgT+p4TrEVrgZqyCa?=
 =?us-ascii?Q?DqvkqimudDghSTpYt73jxVYAFDaFXZu9jRGWJgC/sxtpXxx6cxuxQy9nLVYL?=
 =?us-ascii?Q?uF1F9bm0mXYH2hRKDyLJxRpHg12BdWPaxTW4T5ye3JhzT/xRR9tDJ6VbN/Q+?=
 =?us-ascii?Q?fL++Bku9miErvpvcM+g3EVZd/QVE8vElVUdHlSMu2R+YquLDd2GTXmMC1sXX?=
 =?us-ascii?Q?NF8ikHvc0aAyV48ns34BfD2tWe+Be/h64pn7HlsdnvI8FI66Tvo6sWgoVkoY?=
 =?us-ascii?Q?zzD3rHUPnsderCg8COLMIoVvhCb3/sm1n9tIsQHHsMasFJksr4YoUCMPvdBF?=
 =?us-ascii?Q?MFjWDFY61tZXmXJIug1ACHfhlWUw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?omhP3veXNbdwaGIQjlnbp5h48QdUYZ75ffbJ5jt7JUMGkxy/OTnKe6UxI009?=
 =?us-ascii?Q?UOFSQzY3eAtLD5dbB/PCE4HpKSsu92h9MtyDA0O+sJXUumchvvkKlB5PkKJf?=
 =?us-ascii?Q?16KZ1Vc6BBPpyySTNYS3A3ctggHr/duQtQzu+G0hkT/c7HoOoN/B0uSFkW4l?=
 =?us-ascii?Q?7ITOJad3mm3aEG7JdHpZdGq21VkYP8Mw4sD6/7TPP58mhOtBOoKh6Fd6OgVl?=
 =?us-ascii?Q?VyqEy7b0sIU6gQQFY9Aj1Rg/tMk4KW9B+UCcdCJy6f/G+nmwbNC4V6hKhDEJ?=
 =?us-ascii?Q?tmmFZXO6Itrpcw/A4LFEwbqjdo3vusYjXPTnofo7M6Pqqi+PldFq5aMADFFo?=
 =?us-ascii?Q?UQqj2DCyEF6p9oAZWX+xgfdm6tKOFJAFJ4bTvhfeGaZf5dFQ1E8zb9ZdPHVS?=
 =?us-ascii?Q?nl7nopVNxha0Ff7nfprbcvXhvnvAnqJYR2HIFddy5Hl6FaBpWRICOUigIfwH?=
 =?us-ascii?Q?OVVihw9lckVPs3OWOHzVS9Dhs5wTNhbkPlCacDAJSNW1DfaC/YY0gCi7zK6f?=
 =?us-ascii?Q?X2DEMhej4ZPcaUdRVIJxUZwDtToGB3QHiM3EcnKYxW2ZDiOz8DDEoqepR/kw?=
 =?us-ascii?Q?uMI7y9SDX1qhfAPu9fOwnKxkVWvEKDEyBkWDBdLTKg03o+jdZS376NdyNU0e?=
 =?us-ascii?Q?oY/aZiEuxvDKqM7KVGvhJYJHFo+s7+ydvRA+UJCVQbI6VYsX4KCyvN8bJk4z?=
 =?us-ascii?Q?vtcdkBVC0FfpKeFi9YhzNO0+Wkkn35AbhH2dc63DAPqLl0bhQS/2pG9VYb5h?=
 =?us-ascii?Q?7LZohLXq9iWgSdLrdd9/D6UKa1ka6TDhZOX4WSVOhg3xY8fDQqy6WaD4rZIy?=
 =?us-ascii?Q?0BIhzTTv41RCsNSrkcXELqbAmeu/JWUQbP3QbXGuritr8DoBRyllcA221H8l?=
 =?us-ascii?Q?gNXTpJWcjg0fLY8R0is0aHESTb4UvhTpBEVspjCQajSA7vpnQyCQcs/ana0f?=
 =?us-ascii?Q?w1W0mjC+CN70FiDEAZKaTmlwBR7CoPyO2YM1qmc4BnNdTJrqAWWA6reXpygL?=
 =?us-ascii?Q?YpVppMKFdjaZftOgfZcDoJtCZy85hZqLogw3vo0XIq9kip1Lot6zlsIL3tkL?=
 =?us-ascii?Q?VFR0I09+4kRhG0IpRsb1KApQep+tScHzMSK4qtIle2DSW8RY0kzTCOTCNOTR?=
 =?us-ascii?Q?ERq2CRW0NSy5dXdxgq+YNsIzRG10An6pbUmVixL32JLxWap31DuWjKJR/OoS?=
 =?us-ascii?Q?xuCEd79JbS/w+X+qcG/KYGfZNTs/mIBoLEcdThkumMuD2g9ReqRM0PLAzl1B?=
 =?us-ascii?Q?lIJyKJVhoOSaLdU8V+JktYDnfDWpbPukCuF0qRjkvozKYiyX+cGbHSOzm0Cz?=
 =?us-ascii?Q?jhxVtMU2j8FBHtbM6lGr3kCMjdwxomL/inTKATKXRk1Elb4qHBmOCcKp62w5?=
 =?us-ascii?Q?PBWs291F64GubSs/h/L9flEyLAqYHhZ/Oll2SrFvxOY1GTrxDQOO67hY/DpB?=
 =?us-ascii?Q?mst7tlE10dFKcqAqpCD36rcim4Vo3qYIbWzOKq0ausNHxA6sR+vc9btTTQO7?=
 =?us-ascii?Q?ccha4m5RHC/iJRx25/SJd5L+Qx8QiHUTwpI8Kv1j555evNDisJFReRYZzz7A?=
 =?us-ascii?Q?G5eOGMkBUYzsauMZOI+xRJvL4mR3316sFmFbNu/hu4kP55jqOtXfGU+8WWFX?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ZdM37HI7JwjrqADYqWrt5nN4gP6uH1WVYXJTVLQshFZ3Pt2AVvtNNbCNShphEKN+m/j+iuQBnTbQ4FQHsVI2ma/D0Y+U72dTfxGT2M5tmGoUyeAavkzaekQ2aUsp8h1eqcP4gavOL3HrBgaGs+ChvvwdGbOIVfd22WJm2ltyMHK3TxxYhqLVEKsJRHAphnjoqBkJ4Fnc7arweHK475MrvHu3lDJHZp4HyjOnoaJdZ/WJfEj6tFr++jhvMpUINqzQdQ71w4NRNP4PLqR3rUOBbe7Snd9TOXfVNRq5O3JeEHK3XBd0uZ3XkVD8dx3TLs7/jO2349VId4Hl3HGRaK9rucAVXrL9qUpO2wc6UJy5E4wdgrWpjTFFunLg8Mv8zXZLpAy0qN6flBU0r2eQlo+NueuLAjecEqAfWXVdibPMIMDJK+DQ/tZCQjF92Sw5/0e2j8flA615sb7us8g8WSF0D0ZKE19WZ5ILX6kZESewgZ+oO0OZyHW1KwsRy6tepS3RtbJra53+jG7lPceL+kvmRxpVT+e0/Qr9YGQFnycnjWkw+WX/c92OtION1ooVEmTHV4fVIKzI5ZBeGx0BczdeUiGSYqHtF0JHdQORWXWL6o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 839021f7-8b4f-4164-2465-08dd4bda5719
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 02:58:49.5607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyDRCLmxAqdcIUYwqIGErfqYFaSOKkszuzRdLnDNW4WC4JQCHLsORpedGcPZrS6EBYBgnoFSihGNNgPK86n41PWk9dl64HpyxB/MZLCDMwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130022
X-Proofpoint-ORIG-GUID: MH5-45uPPh1Wa2TAjwy5wNbWnTmzDqAz
X-Proofpoint-GUID: MH5-45uPPh1Wa2TAjwy5wNbWnTmzDqAz


Paul,

> On several systems with Dell HBA controller Linux prints the warning below:
>
>     $ dmesg | grep -e "Linux version" -e "DMI: Dell"  -e "ignore_delay_remove"
>     [    0.000000] Linux version 6.12.11.mx64.479 (root@lucy.molgen.mpg.de) (gcc (GCC) 12.3.0, GNU ld (GNU Binutils) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jan 24 13:30:47 CET 2025
>     [    0.000000] DMI: Dell Inc. PowerEdge R7625/0M7YXP, BIOS 1.10.6 12/06/2024
>     [    9.386551] scsi 0:0:4:0: set ignore_delay_remove for handle(0x0012)
>
> A user does not know, what to do about it, and everything seems to work as
> expected. Therefore, remove the log level from warning to info.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
