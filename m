Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80B41B4120;
	Thu,  2 Jan 2025 18:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735843552; cv=fail; b=a2mMI4mBHNB37evNGf6XW/wpMheYTDDA+d75MlaC7KkeVKr2qZwmPoeKhUSH+00xmY1MvoVEj/MJGtiBG4EAbkqyo+71pER1Xo+YCCmldx5EKCdu9k4ekfqzCD8qlB19LAPgLDwr71kMJfLg63axDkJEhUYzCQeuzzaISIA/bVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735843552; c=relaxed/simple;
	bh=NjDW470UMeuZsIm6tK1CXdoNGDUpqDi5tIWeFN9XyVI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=d6DoLNFImUcJHr1EipBww9S5Fc7kdJz/JHF9qXHApRtEobcQ3h1UihtKOJ4J0+gj/o9raq7ZKREeW2N/O9F67rmW0xJoQxLfRKA638bhPkrkIfo3VOcMpK4AKzOTEEgDbLYJjkLX1rEo76W5CiZnsSZjnWXLjV8siZ3Al2gu20Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nfliB5Y+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nalRzC4Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nfliB5Y+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nalRzC4Z"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXsN0018959;
	Thu, 2 Jan 2025 18:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=OsVJXAyw2FhzL6okvi
	l1Vbh7sKA/nAq4ZoDdlTYVTk8=; b=nfliB5Y+TQLVcnEv6XO+OLLR8ctWbeA0eW
	9tkKR/eOaJbWqkumZT0nC9pi8g1EdmxFbovcqCZcMVwK6l613JgGKolA6RFxhvIB
	sD1c13pJF6gtIyaB5ebcrYmPbdL6vqntj8fYTK48J/wSyNgL4QKRzPuaYqhLj5i8
	XcKkBhFKR5ll3qm8h9JMgi2DeV/ddFThxBFVumccSmLE1vjqTCbvZ5HbGBzsvpsA
	4xCL0Cu4WVdmgtXgW76cQyaEwhrnCVb4Vzl7bxwFXMKO1Q7zsesjajr6R7yrlHKr
	XMiZTRp9bJTCVpwCmirJk9WOhGMbQqxw19ENOUcy+EDFK7VLGD7A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t978pdcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:45:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502IIRnY034195;
	Thu, 2 Jan 2025 18:45:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8nsn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:45:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VEzBYMRipTTYtva6BHWc7tHx4h/asSiUtrdlxi5uS5ysNycMR7ei8P7ts6dmWJGEktJXfuQrR9EAFLppEYUOiO7S79vRVqNL4T5Hto+VxD08hK6TIjXG3zIZgeZ8nDmgKfh0x/W6W1A7KiHP9eXnB9E9QmXUQzfhzKlDnq8Xfuw2+4KIG6JFuLUlp2kvLQHBsLf65O9T5cus3ArfY9iRVc6Z6kswNlpnn+prMn5fVZ2viNm11Wo+q++UOdAd6rDfDC3bE/WuCdXkRQ6lJ0TebChd9AyIYqKJ1haYeWeFhkVdRUxFYRtVMc49nWcCmZ5X4OAUkduhSzaGrYvB/DSHIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OsVJXAyw2FhzL6okvil1Vbh7sKA/nAq4ZoDdlTYVTk8=;
 b=qzJzXSXF3TDbh06YadPOYcZAh+t9EHA8n23CjJD5Ckq6wZjK/ujgG7AaKNlMxNjHdemZWBRLeuIyClfmBhUNC01Cz2dofAO69Qhrp3s6heaoiwOUWeXefWZrHsACg6I5M58FzVXk0eQE8a2NFidKEN84z1Nvttp35e/r8zjNrxcYt/VfyvWSgokwNKGnaS3+aHQ/vuhxgZsB+GIFe6JoqtZ1c8Mk2vx73Z9b+I6ECWqPqW2+d7EORlk1Ju6HFdMAxmlrn4A7SlghnpadgQT0QbNwQgUI/pk4+iDcQLbUlX33sn9K/CAcdbBVT6fvo5eLbmAv1XpjUebSpSxcX3J5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsVJXAyw2FhzL6okvil1Vbh7sKA/nAq4ZoDdlTYVTk8=;
 b=nalRzC4Z0l24QfzwUFXQI2C8jSwVIG7s9P5XjalTy1k1ymKuIdZJK9m9rixtY5wHTA9Q0G4z5GykQEmvIaUh4oWcTmWK1naiLvy/YS2Hif9Q8Qe4o6AWl/liGPI2ReeBbaYIrQhqCObMiznff7efy3mNPj2wUrXVopuGOSBtkDA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB5863.namprd10.prod.outlook.com (2603:10b6:303:18e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Thu, 2 Jan
 2025 18:45:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:45:27 +0000
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: mpt3sas: Add details to EEDPTagMode error
 message
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241212221817.78940-1-pmenzel@molgen.mpg.de> (Paul Menzel's
	message of "Thu, 12 Dec 2024 23:18:11 +0100")
Organization: Oracle Corporation
Message-ID: <yq1pll5f41v.fsf@ca-mkp.ca.oracle.com>
References: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
Date: Thu, 02 Jan 2025 13:45:24 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e5424e5-ae7d-448d-7f8a-08dd2b5da024
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y2zJg9yA3OH+Y5Ze+qSeLTR+zqeiHOxixUXXN3oUxeW3CPtGWEnK22eQ3wNX?=
 =?us-ascii?Q?A6MzgRihix2EPnjNKlMk4pXNYtgxdPau8EmvNcmfqTXK7GIzws+A9GzW0j0k?=
 =?us-ascii?Q?r2qY8FWMbLa0PVdNoeBHZQ4FE2P7f36GF93aveA3+OszJLuETgubnPdPe4Uh?=
 =?us-ascii?Q?Hfe4QbxxehhVAxDsZQuhp2Lq7EgQkyWhOpvEk2OY/pcadZz91WtJJnSkRG1X?=
 =?us-ascii?Q?Dyp2IJ0xcscX6loOTHDNqff4oCltSmNLSj482Khk7BXibLfb8ioUpJTrgFcJ?=
 =?us-ascii?Q?j6mVBA7UAYPP0I9XC+v4J7k1OUuYwPiv/LWQmWmXyJwelzJZ9Qks692UiMuo?=
 =?us-ascii?Q?U2I/fEDxgr//zRLeQ3XVuv4Zi7TpTTA0vcn3QTX5uyrdM5p5bhNcQSRd+7pJ?=
 =?us-ascii?Q?SbzVE2jITVDKYUSyjiV5KVDeO9W4aL5vo7TbF/P3IT0okJEQOnfI0m4/TrKb?=
 =?us-ascii?Q?6S0Xhn/yLaIC1QbHofNvs5CyRHc6Gs1ZuIICeIf+lNKB2MTvhbRqiDbNPiIE?=
 =?us-ascii?Q?67GKvycxWALybV/Z/0r2h8vvfW0hBbplGqSi2v8gLPveHtQm+gmZbpq3wwa9?=
 =?us-ascii?Q?byshv/z3BsuUpVqS0+0XN20bF0nj1dii5Lsrgs2tpVqEfPdpvr892oWNiMst?=
 =?us-ascii?Q?GtDCyT1ne4dmPCFs1JcefQTq66YqOnNVygYB2lI7uRPL+FGMUdZ+m4NZ6huf?=
 =?us-ascii?Q?ccTZhQmEZ/PhFF3zFb6CJlvWCuCAxvvxqEfo6x1K6UNsl3C8YvMx2NY2xjB3?=
 =?us-ascii?Q?oFDOa8sV6NQ7vqJrhL1BV+c7Nel0D+gbrp9k23Uay4BCuO6CuRSw/LC3Rsar?=
 =?us-ascii?Q?8BwUt41c5nZY/mOhxiV+Sh9Fkd6Sv0DpdqvV53MtgdDEKV8FtG6tEpqp24Ki?=
 =?us-ascii?Q?HF+Ru4RtwEAegqac6S/nV130i+d/OsZF++DjzRRJ45oJySDG83QHX8JE2w6s?=
 =?us-ascii?Q?u4vIriw6ZoZ6BGZ2u1YHheSZvZJRQrVICyanmFBb3TNPexo/+qEihUQJZbq2?=
 =?us-ascii?Q?/EUiZ9KrlKKtyiTaTaB54JCaCYnvQ7+yAIjL50fIUufuwkACrCNWOFZgca2U?=
 =?us-ascii?Q?tRveD+6s5q68uJ7SK5YEyBUiTl9hZouM7O/7dIgY1qSyef2Jk/RnbVdDc5AV?=
 =?us-ascii?Q?FyaIgTwdXxCON2M7z8yQ12g6zHFDCAAZIS2AutbomUQEVk3yDH1lSCWWRgRt?=
 =?us-ascii?Q?qXFCl07qiIpqnZYKBCJbNnVzFnEX+VCMPcJrGmvuHZcjW/T9H3TZz5hQiEYP?=
 =?us-ascii?Q?Y/2pgGzNyhyn2TlZ6D/D5bUoY1tSJ0s2Rb0G0KqaVLt570j3MWnJVmTu/NCJ?=
 =?us-ascii?Q?dy89pS6t6a4MKSn1Ow7SMw8j45iGFF8msfFVMVeULuNurpSyzEetOsxcUfKL?=
 =?us-ascii?Q?Qr/Ycoj1rFjzGk5873O/iBdGR9Ew?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SWpgW5U6nWNzcdFGWdkQ3jiSEXtBRyY/OHSBI5OZAQSCKafhaICwCmboxhKS?=
 =?us-ascii?Q?KIEQsPBtvx5kkMM4FmvgbCsDcRiMqa/pHI2bEPbnr56iYb8ZEemdEU254wYu?=
 =?us-ascii?Q?FZkJFwVx1P/dPZppaoLyU3g+Iahn7Qd0GYuA5ID9xLp6LLxV5WDD3tk8tNaf?=
 =?us-ascii?Q?7teaF0chCsj37Xwq3CBO6+iSVysLnqlp0M+Rng5yFMqY5DdI1LuOF+CHN4sC?=
 =?us-ascii?Q?b2fYAgv5v+e8b05/iHNlUL3Nmz/60VQ0Kzn3p6MdpFB5NwGIbJVHs037mF2d?=
 =?us-ascii?Q?5SSk757LxQo9ScHpwdcfa+4iyPERUAs4VwbZDvfOixX4sQbrh+c/NKHmsN5M?=
 =?us-ascii?Q?tnRxJhizkFHFbZFbiiFHMoaft5fwVle4LC1rBGAJRKAzNMAZfBo4sMXFScCt?=
 =?us-ascii?Q?+u/3vPwL++qXBEgr7BQDsAFwiHS+PMMsnUXlKrdUazB2PASAOYIESiBgZqxd?=
 =?us-ascii?Q?UPiv+xw7kSOtOeahrgARCBj5f7aitbQ17MquSIlk5j0XNxY1DkdqTASOXS6V?=
 =?us-ascii?Q?Wx/smf6bwWb0kfHgwFmCcl1jG9xUndI1n/pm+GPeR2G0wgbU/TTE3JAOu8hS?=
 =?us-ascii?Q?7OSvoK4tgekvIil8wajI35UHwuS3IHrBnCZCqZoD/euw9iu6iOCjCo7DAwy2?=
 =?us-ascii?Q?kj5gjtZxpjMdjtK0/L9ELH6nC/TfpI/roYlEqVnchEtdVq+qJ3ocU1+vGOvz?=
 =?us-ascii?Q?GpBA5NBu0dMscYu6dar/I7sfbgNdH5HIG99xtZIIdNI8J09lvhIIzYIwhpI6?=
 =?us-ascii?Q?5IFQFL2st43G6iMGfo3+p+x5HlDOrWF52KrwDq+2Gy5XtOJGM2UbGhfadwd8?=
 =?us-ascii?Q?YPvB1Y0AYYnC7BHhbh1J47MG6lvUWVUQWpGR6MTmiK/ney/3glMCGerGPorU?=
 =?us-ascii?Q?6Bp4UmysereiHVSTp07I/AyVBzCp0iIi41XPJzIGjjVGxclaeW7rIk4TintA?=
 =?us-ascii?Q?cWFXDtfAHg+QuelBKO4t5wiiKqlkp1vURQh6jkHeNylzLTszoZ1+g+52TNda?=
 =?us-ascii?Q?flIfxu0PXM3fclCihxzWuIf3iHLtrcvohWb6B0DVVZJhV27ky5DG7ZOKxOI7?=
 =?us-ascii?Q?dZ+Wf1NepyNdhOBbZ6B6Mg5swTXMwS/WIRNbOxp3dCGtdeL/xpONsmP0p1lY?=
 =?us-ascii?Q?JKW4DMO8HqbbCa02J6ByfdXWuw9Ef8TI99ChRxElyjGRlr+uDbof2DOWaW5F?=
 =?us-ascii?Q?uTu6QXlEVD5FucpfSrNa/t8e4Wet/5mjAy3v2RRMUX63inHzLbNjW1Po/bCu?=
 =?us-ascii?Q?zWxs9RHfSTATaFqoB4GS7ljBFmlypxi47FAcfvUkIIjgMccEagBohZVwJhCv?=
 =?us-ascii?Q?Z/oPlemSP3DwWQTds15vKNGFHNUorFXxQdpRvuXMRjgSWLug65aPDM1EZOzB?=
 =?us-ascii?Q?u0HQAKH6BYLZjaFSnlvRZHev0S31VrEkhbrxbcyMLwc6vN7I7xlO8iAccaDI?=
 =?us-ascii?Q?iL0CZcKNSI5e/OqOCrqaGdCbagLmQ+72SdHJheEuZYWpTlGqskV1glvMQKTr?=
 =?us-ascii?Q?RvvaDE8tIFdUvAe/mN+f9LB+GmXBPfTD3ulTE2Du16ake962mzqhE/Hh5mTr?=
 =?us-ascii?Q?LbbbzFkpVTfOkCawpvsOHPi3bH+FyxAElOtvPXU38jQwLukn9JFxbypoIudW?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	imrPD0CI2eTojZL0uvmTsnT1CYqHh7Zhc/jE9Q7biED1V5Lu4eSCZORjcyjCyAzB+XNb78BVI9+Rm4IfD6bqL/zP5XH3nsBx3L0EHLGM9YPAefb4mfbmGv9zKapMyO4EQj746bv5sAioVlH1Px1EN38CrTUMw8yEYqT54O8aQgo4GSGax0QM5EB7IjK/Tvtih+x8gTUdeGP/fuBrlnPX0GL4pEiXe4QRTQxT2/+ulzS2MPpFg5LHnMRqmpluFa0rn1kQAKegp2xq5L2cnS+9gFK0imF5sRlesOwysCjDRM+ZMGxM/upziT8fTL0lIOyVG7Bej30+y1bxA7lnhqJJjdqevBSYAi0cmwdH/Iwql7pUrHAyvaNKWQd6yEoxaITNizoYRIuuN2jyFTP9VTrrxHh5MPjdaxlYy4Tp47gMOrQYkUjctTE2vNWn7ZyB0PZDreKg12uWmU6WAQ5+Eufv0w5Q530qgubq+wh1oz4LoxBL/yJPswQe1nwaICaofFoXm3ksAbddQiWSaQSOVXLAh1MARO6tbzL/qnu2FbFnLhCXcRJCmba62W/RWbgxejVklTG1CBQbFBMLDM7rG1z/4DKzMTllCiJykWN9HjN1OIM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5424e5-ae7d-448d-7f8a-08dd2b5da024
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:45:27.6271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZVtDYggVdDoBVGi5jr5rSKAii+Ry1kxt4KU+gSBqTyRVlgsQJCMYBERgaKzs3+OlpYkaRKlECXAdVA32mK6581x8q/RLv/62SouhRakuGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=943 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020164
X-Proofpoint-ORIG-GUID: sdQm_R0_KS1yiaBCy-7Q4tiyDJl0J_xa
X-Proofpoint-GUID: sdQm_R0_KS1yiaBCy-7Q4tiyDJl0J_xa


Paul,

> Linux 5.15 logs the error below
>
>     mpt3sas_cm0: overriding NVDATA EEDPTagMode setting
>
> on a Dell PowerEdge T440 with the card below.
>
>     5e:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
