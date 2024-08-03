Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAC66AD7;
	Sat,  3 Aug 2024 01:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648616; cv=fail; b=sD+BED+jHkrcXyphfAEFV67he7YlvGPjhsm1NGeRIzcV9Uk6L60E0zm16T7NSDKjWHrxvShoP1W0602U8jZdVsWVZ6ySxNV3loxLKjTH0BdA+Kd4I1EZ79hs7ERTjZQQC2dwJbeh+wKwI5A1/x9BEmNPe2+ilJtI2EhQ0dzIdI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648616; c=relaxed/simple;
	bh=HHolT2mFjsG0dXreKIIkvlIEjsj3OUDkAU8qQCQFsks=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eqA7JYvl3SX+v+j+N/ze70I1sHU9pt+F9dMvUS+CvdmpLubHK3urJ2/bXHeX7kdg4LCaBVApR9taitFMSHUrbrBf/LeDp4aUKViZV/mWiJk1lmQLrGN1zbRHnFmEjTxMQhJqZlxbAfIu6jZVWQaAZR0K0rqV6qJIyuPTFp7Og2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VmtX2h5b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SE5lIUvc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VmtX2h5b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SE5lIUvc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472KHos1010184;
	Sat, 3 Aug 2024 01:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=SiJLVNFYONBiot
	hyvfa9L0es/g2pzC0qYqHNgI0IfS4=; b=VmtX2h5bIoXGMFuv6vUfVEjaKwNdc0
	vpgUwjVpmXaAdNL12nySAHLakMlMNmghttWt1zkj8EHUC8t/kLPuMH0kXwbLlSZa
	mL6warlWAgORhAvxDNAJXfvrifn3jDNZkpYFdYPvmhoysPDC1RG3sn5fdwdDjaFr
	w78wrE+kStVG+hPvZYTjmfARpdmO0EbA7hs4CGK78HmXrrIN9WuQ1HtHP1Xo/zK1
	1IAg4Tbm3OoZT7Agf94qcD8j01FKI9XQ9RT5bKpHCEhVhmqMOHHQqvvLxFP42izL
	aL5AnQOtoDxprAQrXEq2edgMAC6A1XZB0fQ2XP7YhLwHoZxPVFdscD1A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjdsafdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:30:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 472MITpF002519;
	Sat, 3 Aug 2024 01:30:09 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40p4c4wbrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:30:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ca0RtKBB5Ld+CqUPupRvKeo+eNvkNdi/OmijJbZIg1MP6WzGupQ14bTChY3dDkStZ52RKbNGnOvDNcoXuBjCH9hoKphfYW1/5WBiTRbRY2Un1esRwnJ7NmW1dbqc5AcNU0q9zkSljyT56EAYghbVeON1KL4TBHtrBkM5/h0A3H5BTMs7Ro03O//C6tpN6Hn3niDSawl2GXfWUJqnl2HMcyK12FIk9JRoJc8b0l5+hU9L06frMek2+kJlBVkkfDplOhy5lYXh25bQuxnpYOteuen3/68msx4u0EIyMo+iqF6G179eXDXFxmFFE8FXZRDsJbFeQOaZhJNqj3br4axObg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiJLVNFYONBiothyvfa9L0es/g2pzC0qYqHNgI0IfS4=;
 b=dOEQZT5xvJi6lcUeCCOot4g/nj9+KAY5D3o5KlYd1IAqsHUAEa4rvaXTOSiDT+D4imw4hP2kBkrnJ9NdqIlPubEmG9tUej2i4k2zk9CUeoHeqm4AajS1+hjkDG1eSXpOYeU3MCBhvY5XIou3TwiQfddNgJrPfFUdZOyxBoCRsVZohn4X9DpfJTh+DJkYv3f0lwRj6UNcblMZc4NG8PVHUfcOECZyLiKmeGyxk0uLiHZtuJhAsOjkWos25zlX599mM7aG+FwSRJ1p6qpeVSd3NSVw0eqd1mX+MkEfxPFZSGpxgfLL1ukVgKd+FCNehWslTgj4Mc42BNiLLO6+4DVbMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiJLVNFYONBiothyvfa9L0es/g2pzC0qYqHNgI0IfS4=;
 b=SE5lIUvcpfjVJ7X7FACJHMQB5YoTZ/Uy9TdGoy2gLN4dY/HkPUYrlK8aorUSFVbc3Zg5tg0tqIV3f5B1Nexvy1PBSgS7Z17DCHjBQCR3KyErHwMLMl15Mu3RvoV3tkOu94gV97YbM/Yld/aWYZcL6soGDTGBWRqW//wgh1PJHYU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:30:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:30:07 +0000
To: Kees Cook <kees@kernel.org>
Cc: Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: ipr: Replace 1-element arrays with flexible arrays
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711180702.work.536-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 11:07:06 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ed7675rf.fsf@ca-mkp.ca.oracle.com>
References: <20240711180702.work.536-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:30:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0473.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 41577916-a720-4801-7f70-08dcb35bcee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jyYEXSELNfFBHhwg8cZE6lq4sOYuju6X9lZZTa4Gy6V4iCvqE0Xc60CASxY5?=
 =?us-ascii?Q?kXYNGg06XlVQqrJwcnUequdviEiWRtp+XVVqg5HoCNO8Os0/iX51Sfvx4V4s?=
 =?us-ascii?Q?ud5CTN4zaQBJ+/OKKLPfgQIXKKb8UXi3a29Lk6554Ke3UDz4jcNDNgAwLpxp?=
 =?us-ascii?Q?umNkb6s2zV0loA6qIE88pySUlnSeW01GA+JTZXa/z44z+v40vHj7d5j70Dta?=
 =?us-ascii?Q?LUdALb3V993KRlNp2z9k/QUESdna/FvPmJzpiUJMrtsowBb8qJhL9UUovsAB?=
 =?us-ascii?Q?PGxZEexMj08jWNhDQ25ykIkcODxGMWGbdsfU0AaT1BNsBEeDBL3399Q5sIBi?=
 =?us-ascii?Q?V832lRQ8QZfZWnie1pYT35tF4eggyPnaLzirwMOUqyY5npwxyu1U6m7RtY6Y?=
 =?us-ascii?Q?00eXo2io/vuM0T84MWxB1yPUkceFL4GbqW4jfrL4U04FBGy4ec05BG3mK6P9?=
 =?us-ascii?Q?t+fis8BBFpEA9nPF6tPdentfFpms54DcMm+jEwyRHwV1A8f3MhAJaKI1H8sU?=
 =?us-ascii?Q?szNov87v0RNSA3lVCNd0N9mx61nEfESCT5bhsXOjaBsvJ8Dh+3AAj/0g9eB8?=
 =?us-ascii?Q?yiVwSbLGEj/m2QYd7JrwTUeNdrsrNJi6TLJjxyXvSXTVoA4TYs9uLGmMiJ38?=
 =?us-ascii?Q?0jojuh8QbCUCr5/psNNu/52efoUuy/HFw9IdcvYjLplcGvHYmnsGI8Eey8ZR?=
 =?us-ascii?Q?R1Us5sMSS5UhrKv+5SyoA0/ZYAo+uI+Nn/YHE6pAAYw42EESbrQClhG9vdWm?=
 =?us-ascii?Q?89NZWRunlhzx77IhUNPOdDQ7dOIdlPvrKRCPvrCXi9KKHFZavPhMNWj6fUIE?=
 =?us-ascii?Q?mg/Bmlhq1ABXzkOE2018G0pICJ1tHm01vnUsiErKn5HVIg3R3e2h8AxQJl2h?=
 =?us-ascii?Q?WQDfObQp/jq79NMxmT5LZr1E5HQ80UOFNwry3uevnFiaeG5c29n/0wNqprwn?=
 =?us-ascii?Q?kssllV+XK6JS1oBQiOTWo8diqJR+mYS8fdfYrOtas8R7pFc8JGwDREvkxZhM?=
 =?us-ascii?Q?jQD6yyuEa9fOHLDgEBeKCFkl1tEEmNZ3SFZv2q/DhRb0WjhhpfqdXgczxubC?=
 =?us-ascii?Q?ofcT8VpwJHmyfyVLiwxxDMmXjvrCCfsVpiZiDheTKc1hBquCfGVBnZGf0o4j?=
 =?us-ascii?Q?xQcW7bYZAoqlK8aGMMbcfGAu5L7bbfkNuO6XRGW2Sol9qXw3+kL9IsSyBjKG?=
 =?us-ascii?Q?a79sSvk1EoXmP5N+so2cXsX7O4cyD/uxwg4mz4HxgRwC36aLdVA1b1NzM8wl?=
 =?us-ascii?Q?r7XuwSiyejg50yUzfu+ytCAFyDc39162Bn8H9xyekOsq7oeZIsTRC6mM/7ew?=
 =?us-ascii?Q?TkA6Va5X3FqZOPXqSlkT+UanggcrVuqW0OqQjkrl4G3P8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k4vUQaC8hHCLJgooMWKRst7iM1FLhF8JtY75ImoUJPjZkae3W38Fc6x7gGs8?=
 =?us-ascii?Q?HlbHDDIOxCv3wKUDk7HkTJ13T8U+CC7ijOBneC1dNsLkpIHYOuLUjEjzx9re?=
 =?us-ascii?Q?HONhzZYW58lrVcPsIfck8ImJ+rJV5g1LAFTE9ehEc/NBBgCIa2rY5esV5hNo?=
 =?us-ascii?Q?3mepDdLBtQ7X95La8q6aZ4RY5lOPM06B7qLMWiJyDFyjy6MNrsSL8MpLp64B?=
 =?us-ascii?Q?BJt8yw9YQl39Gip8dqyIwu2yrJiQlTDgjijHGgrP/MRohHb4fcqS5GmlYzu+?=
 =?us-ascii?Q?XB37sFwxtfNaDZcfYEv2ZvkMh7Ed+F71zpcB794r64xVW/pAd9SBlQiS7tsG?=
 =?us-ascii?Q?E+sDNxXnHx5AvNmUNuO9yIdfbiJuBKzd3gHgnRlratyJ+a7EfAi/PLA4SzdZ?=
 =?us-ascii?Q?55PzrPmDGyBnRUzTjnHwsOl4e1tYhymZ50C9d4BrywuVLyjKKkUoaG9knjsj?=
 =?us-ascii?Q?qsl0pqrSLO68I1+ZEMVc2emRXOCU4lWI86pkoPHdGh+/hWyaAHxMNHpB97nu?=
 =?us-ascii?Q?CTg1ScpxaZpPJO6WEvVB5vfLYEOdO5798mN5Ab8IesMG0MlXm/gddexB1I+a?=
 =?us-ascii?Q?KEeClgquP8Kx6+nc8W0HepczhMJkwDaR1MuRzGKG4msRHQRgRcPRkp6E8F0n?=
 =?us-ascii?Q?D1Iua+nJqbKy0P5O6K26rjwHudVEfhDZIQHMdP87jvExUxPMCn4tscmp7GLE?=
 =?us-ascii?Q?bIJs6yPSe7xByYt0w4XXvQ5PItLa8+Ovb6HYOvX3LBSy4lHRRYdX75Blvmwg?=
 =?us-ascii?Q?++jl2a2X7cTKQIiDsNiqO+6i3r/aZ/mAu/PilEaNAbYkvNNQrlCoy6egj9yQ?=
 =?us-ascii?Q?btQYlMAn7pw+eWCf/M6zxn+3/TkvoQsbOb+gCkpA1adDz35rerR+6hagY3WW?=
 =?us-ascii?Q?dJF1fHYP7IN/hHxOg/8kpxv1O4YvWNN2eag8xOV2/Mhsi0ss2PnkE3iR1vje?=
 =?us-ascii?Q?0xVx6mECHurcw/pfY8UyE1eoRGdtdhYeP7byFfaAc8+Oz6F2Rdgqj2u5/HCR?=
 =?us-ascii?Q?ItXQED9YJs78jdSxliuRw4tWyQwBRpf254IQNFPXOy36bMMCSShCupxC8Esu?=
 =?us-ascii?Q?DQSB8gitHHwlr+NSEVys7OjPKsZZFpNi1sZT2RioebMHcLb3HTCiEMBpoJ3k?=
 =?us-ascii?Q?PjNhNed59luMAs89VtgdzF/UDOB8JKv4cWXrcigQEaABEn3biM6KipIISUWQ?=
 =?us-ascii?Q?uYFiT4g5ux4k1B5I1yHTbzZ4AHIy6Lpav7zrkiSzoqGOwz4i09jrCtKGpSS+?=
 =?us-ascii?Q?T1fbpXP2ry9ThpRhAWbHaDapiyF067hABhhnlF6/l8zDrP8aiXgf7/ADaMdD?=
 =?us-ascii?Q?B2qji2oxh2v9RXMC0P58Ysd+i2nxNkv4ubN3GBKuxmuHoNJqRJyTIie1NI9v?=
 =?us-ascii?Q?LKdlz/3ARST9rI2lmT0cnLpXpLWHDV0DO/aO3AC+v26YqrrxvfjzRnPvnGaA?=
 =?us-ascii?Q?Jchoa8IGca0pGNAP4LTBHLNhpfkBjKm9qMNEq3lUA1NInVMbl5419e+/plTy?=
 =?us-ascii?Q?8aWtw11k0ppi9/NNOBxRatFiWyOr0cJct7QbF+Zn6bGZxfXM8Icl20PihyCc?=
 =?us-ascii?Q?YrAUi8frTYGI1kKDzGNuuoO8JWlT9mAo+k3Lem+ZxiOeshH5U8zsJdDNxevh?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8pddpAeodADkWxVTORu83jO/f8jV/26t+LIEGnkhO51lCHWmYLIFxy3xphwWCKj/esPGQO2pU6E4Evoa1O1sKPxySFk5frKCFDRmKanV/tIsFAA9wUT8apKzShU9kXMc7N3H+glrCKpz1aCQDb52xzjAKgm2YcIAlAt8je6loitwj6oqGvehvzQUiae5so6ba2muJvKlRWj7UF/woKhzT4JndvN55PVgD788f8pnnBhylNEKAbKIIMcONTfKOQYKEW51M8XzsrMYG0CkqiEXauGp1dFA/7TBGlVsXPFOSQOg+q5y7kJcCvaWzzUxIYkmthvfQwpy+Xu3cxCkUhVsoR3/TziLj482iC2fDasAZarxgn3dUso8kkHnGgUI3LAwta9sJRIc06DF4c6a6XrH2bDJ95i9lqpiyGqgN3PiiAccniE5WCMcHhfcZtI9FMPLMwQ6SRKlP2zTSLT1VF4YmfTi+YDexcIgXTLYdVlsLjx2ZJ5Zbr9+BykDInvUzkodpXH3UBKYyMT5F612lLmInImMQC4yOcFKzANOPLjyGpuB/hMmYyJfsHnnICI/1xZSd4wcrwXeh5158SJ1A7P5DVhn5znglZimmQ2jlIeB/6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41577916-a720-4801-7f70-08dcb35bcee5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:30:07.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEkyTVR6bBkwVv5hV68VgQ7RsTIYiwgk7G+S2K7icUZ5hrzVQ8KBqjcP9+K3Gd1Oj9RKxq0EfBMRfattJQaBt/HKWD1cBZEC4gERs2ON/mI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=820
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030007
X-Proofpoint-ORIG-GUID: LbNvDwi5o7IJp3Lv8Hz9doyfz8xzicwW
X-Proofpoint-GUID: LbNvDwi5o7IJp3Lv8Hz9doyfz8xzicwW


Kees,

> Replace the deprecated[1] use of a 1-element arrays in struct
> ipr_hostrcb_fabric_desc and struct ipr_hostrcb64_fabric_desc with
> modern flexible arrays.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
