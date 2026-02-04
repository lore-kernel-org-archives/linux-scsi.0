Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01761272E6A;
	Wed,  4 Feb 2026 03:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770175469; cv=fail; b=jJfawUUot9kAkLrv0rRI+Mg7zfRUD6ilg1dNh7kep8oDutgY37NoddDjShwoyZwqtehs6oywDWtwJ1HoTGgqApq8f68NkizmCSnBCHE8PD7wH6XAGaVvsCGHnRGn0u6a088YsSi/MHOTZw9i+ps4+pvtXGzlJGXE1jYxFCJLibg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770175469; c=relaxed/simple;
	bh=P5n3DRX5tWVmLJ0fZlReRCJkSBccrwpG9dY13YD5xHQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oFO8WSHm8rOJF0Nx45iyzCDsnHgStNmgK4/DNw9VANTpe9xQ9A+VZ+WyBugydEhZ2NfwNabUjZ9u0GYAlvEd5lDcDGc+f29X9voqthAHMzPl4guN5wKVtBaSqj6XFKdopYNImbZqlIKm/79Kv76jR3qdUNQ1kJY6GK6b/iBcf3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nce72ZLS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MTcANCPD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nce72ZLS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MTcANCPD"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuDc41423442;
	Wed, 4 Feb 2026 03:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F5b+i4zt8tHpGHvu7M
	Cmm8N46FxDR82brhlSBljerxo=; b=nce72ZLSqVd2HeJpUzWix+ijFNJ62Sd4Rl
	kDtJJa54Bv2apD7j2b1PbWNeDYuatPSHu0r8/P3kwsi3AI9Y4c67vswva4MtyD55
	AtLRl9bQ/m+DkxhFBmQSL0nqSTJANJ7a5dD3Inie29rrY7W3JO1i+pz30RO/AwAN
	tH6m/IBL0T+xlmBYFZ3nZ/Rz26bFFZ0+SgXo1NbnfYjYbSkZ5Wk37y/2wrC8pI5l
	WN2nhBA7yLd8Jb1yxmHfLvIllNorN/okD05enPFkiPTNrRK7ui2zpTZEuLjcEYb8
	FscTl44qNCGjy+8S1/2JU/gMsmcckjOMw61ep0KqSsRYY2hmbGjQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jsqh41j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:24:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61433hpr025798;
	Wed, 4 Feb 2026 03:24:19 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012037.outbound.protection.outlook.com [52.101.53.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186aubeq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:24:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5HGIMUQxNnwXxSV7HDngnGCuBzWFm/YjBlfDtHEVvPcVAV5b9Et5IWMfUgDnGuZicLr7jJK8epL6hbgKtjAPGL2Vb9HLtcgAtPMrAEk/3chabnAcZ6qaTp8iyKAU0agSBLTMv66NMK0OJnZAJx7vSLXQlN3kh+u/DalPSWs2SMwTD4i4GV3LAKYQFLjXFkcqb0pi/dleRMniDzAZq4E9R91q/CFhB7C68F1Srj1TBtkfc+enGo2I7DCjhC03cWrbblRJUjnehDUe8d9Wj1VCp0ITfdQrOpzNOoWrSHeymaKR7erKfMU+573A0cgzYrWvyxYUXTBIEKwDLC9oy0rAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5b+i4zt8tHpGHvu7MCmm8N46FxDR82brhlSBljerxo=;
 b=hP3MyVGR1rcYl2izNx0/yghoBq2F9ahzm1mERyze3rxok7tKKn1+T12fQEIkVZXdbqy3yMhjwt+YljNowdhFuscVLs0OQ0GMs5LCasR7O6AAGaNvjFgZolZA1oqT1mK9xTfYsna7CWcUFeqDLzR3q4BbB9nWSAr3id+Pt8xlceQXSgJe+KSX2ZExSOJvUIpzAurZtTL/wkcOKxQBDCQuoUZZboDMQCIDxjuLrLTh4ZrGlcWEXbQvYHUvlM+3Zg0DIf2V7WB83UTcpFV7Uop9NQfuyVQxL9GwJSvbPj53f+A1YMdahzZY+O7tilkGugxLGT0cpXVeC5IB5GE32Kvh5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5b+i4zt8tHpGHvu7MCmm8N46FxDR82brhlSBljerxo=;
 b=MTcANCPDhzmEQgx58mxxrcrLYyYV2uVZ6aCJsOz5mD42q67339QckErGHfcabc+VV1caDngZhv9TSjGfyFqlGyShJyNewPAOll6WqBm7WIfcUpZXLUC9rMJO8JCzrDc25Y2Xe2iLL5wdaC7fl28UHdLz47OTrE6J67eXOcB1T48=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF109C7C399.namprd10.prod.outlook.com (2603:10b6:f:fc00::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 03:24:15 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:24:15 +0000
To: Zilin Guan <zilin@seu.edu.cn>
Cc: don.brace@microchip.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, scott.teel@microchip.com,
        john.p.donnelly@oracle.com, scott.benesh@microchip.com,
        Mike.McGowen@microchip.com, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] scsi: smartpqi: fix memory leak in pqi_report_phys_luns()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260131093641.1008117-1-zilin@seu.edu.cn> (Zilin Guan's message
	of "Sat, 31 Jan 2026 09:36:41 +0000")
Organization: Oracle Corporation
Message-ID: <yq1pl6lnqdd.fsf@ca-mkp.ca.oracle.com>
References: <20260131093641.1008117-1-zilin@seu.edu.cn>
Date: Tue, 03 Feb 2026 22:24:13 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0009.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::7) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF109C7C399:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e3f43b-582a-4898-97b7-08de639cdfe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KSbep7htW5Pqyc9zkcZKb3VxgdhacuaDfd8ap+meJx4DHRklAhBXGUYwGuKt?=
 =?us-ascii?Q?A4MU8o8eWSkeft8mLDU+Cgiw5qdmh0ydaKFdII6ZB2boyjuwQ17Kyt30RHB5?=
 =?us-ascii?Q?JP4EnU/nGBcvNZEN93uV7i4hNiJf30TLUaqEAun1qhb63Q7fBNyUtjkawyoP?=
 =?us-ascii?Q?jY9hJTh35zVFT6EJIlNFlsfJrZyPK/fUxs2FDsROKCdJ+gzVsPOXNKoNMSOs?=
 =?us-ascii?Q?qAa3Qd5ilq42qLchdK+VqNkpKi9bHp3duIjJpZsgFPueVUFCKa1SRGIbhwnu?=
 =?us-ascii?Q?mZYxr76GIub/u3aWYJFYu5V69zhMhwDU3GewqFwzC6doMbZtdKSJijAdHzmz?=
 =?us-ascii?Q?oSqI5d5oYVsHDu+V20gzml7Ju/nhb+WwEQGDyhdPSoXN8zmZjGJB46Qh7+qr?=
 =?us-ascii?Q?QqORPEdjSPCSa2mP/lV2mQw63QjYWEhbnnXFoxXhkcBQJE7cfxeTkpEERKrr?=
 =?us-ascii?Q?7pusWNGI0R3HqqVR8ZfjOoHCl/4XVNB3lsmch5d/ih8gGaBo3FEo9ACyaAWY?=
 =?us-ascii?Q?CrZHwETShyeQulTvf/WdanCV4j2NLwVhL0VTu57tHpGF6SmE9hKylpFkxTyW?=
 =?us-ascii?Q?eruDBWpfzFlMUMz928LCjWGwuKkExw3mqegPM6HeaU8BDsUov+HPl9wydhTa?=
 =?us-ascii?Q?ZgqNmcvOU2GDRnKOyQxw9Gk5MCBfEZKTKcNXqnKsmwt6izWj/YNC+JrxNDEx?=
 =?us-ascii?Q?V4ThL5753yFwnBSdcWSedCN6a5r62LO7tlDcZWulsuOE0o6UDElNafwQX261?=
 =?us-ascii?Q?kTFzSx9TlvT8/Hp9S9Pbuzd7bpjrl4oS66XDLRVxvwRj0uzKkYJYRDOkVL8Q?=
 =?us-ascii?Q?sZ7th1PmPd1WPRP0otEEjIAE6Kby32mhRLlGgK1gRsHylr68edgWtHqF8usP?=
 =?us-ascii?Q?jYsb8lCODgM3xQkuBU/TJl138XZmlDSZG5idJshqTpn0ZjRtS568Ig2Xzlrw?=
 =?us-ascii?Q?GpuMBRCABhTC/wuAyZE3sg+GIadIAEZHNXnAThxluDwboSic2Kpqtk8hjeEh?=
 =?us-ascii?Q?jasmPL8qOuLyzebvsw8VoYvbaTXIk1/Tr3Lw9BiyykRyedIWdz5ZfzSvNr8c?=
 =?us-ascii?Q?7wj1ZxFH9U7A0m4+DHZsXUv6l1NbIjGwV96/Yw1jnECg9Sc3Rryy2h/MmXAd?=
 =?us-ascii?Q?T1JLVM+udp/4DCxRq97N5RL98ZrvCmrLVRodI57FjGylDLgB4OIk0Syjm5PU?=
 =?us-ascii?Q?zEyI1+r6lzjayu5N5mTWS05qXgv7L8835dnoT1f1kDMY+fP3SlKlNy24ef9g?=
 =?us-ascii?Q?L0L7qWj4BmCA45j8Z7otLRJqcqDuERGGFyy6H5Dvyy5TYCw9qbIszI8E8+8t?=
 =?us-ascii?Q?94tP/ieNA/NFNSiqPFKEsEYw8eE8mVyjfZUZz4TCOtzHEAnmeUZ/mfKjsx4V?=
 =?us-ascii?Q?CE+RXhzXQQKMBt4NJqAke54WOTBnpP7kgCurWF4yCtAo9gHDjOMI+rSlNTY0?=
 =?us-ascii?Q?BhEsUgiA/KRyZXA/5m4qWIh/ldh+a/OHdra/5hS1L41S4tdbQp6hLc3K2AHI?=
 =?us-ascii?Q?bTPbWCAgEQ5d/6ajD8E3hK0Y3+dhyzM2ko3qd+RYS9eaNKYR7GdRme/0SbtY?=
 =?us-ascii?Q?H1cEJNRPWoayQIi/010=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/gPRIH4SzE0W9qBAT3X3WeD3bGa4kQL11/K/tfoBbKeIbQK2ZtiYiNxLCH6Q?=
 =?us-ascii?Q?JYeLXMSpHfj180PWXdpi8iGU8Z8buIthtN18yGn5vLJ5cbZ9YI3fcFFnPwmV?=
 =?us-ascii?Q?JcETOSUfI8d+ICNjd5cNjTCRnZ3z9/xOEv6cn2mdedvEeaAaQ2WtkWxGYjtw?=
 =?us-ascii?Q?Y/Rby6FaMAlgwIBgbdk5caFG85teG89e5+6bEPVH8SgvA9sWDz1zXubH6kF2?=
 =?us-ascii?Q?KEWsddiyFfklTVycq9P3QyRl9BpgJpaccK/o4HpyzFXDk82aecrDzH8W10G7?=
 =?us-ascii?Q?4FBd6kGdtizfzBFQb6vQfaxUNeT9zORXdS/pWY6ULSL9fFdDDYUvi6/F1K0+?=
 =?us-ascii?Q?MEqjh9wcJ8h+KZRqzAKtnLQb5J3G2Oxzscu0onv2izJkev+fA9klQSyVqOqz?=
 =?us-ascii?Q?Px5YXxowyS/PTRgQfeZeDSsfZkb3qDszkqEfIA8G7Tf7cvUmNhpAtpSKiJYn?=
 =?us-ascii?Q?OO5OxsZp+77IJsX+llYqP9ONk/exNmC+7zWvaaRUeM/mtaT6FzhMSBXIMP8p?=
 =?us-ascii?Q?KDW7OrefgblhOJmxN/AOQs560YA2lCUEtdjK7Tn1fXrJMhJKjl9q5YddUiDk?=
 =?us-ascii?Q?2wNgK2FD0dFq/vsi22QbkprDxEdRGdnonXZIt/dGuuR/PCPZAb/Ynh7LW5uz?=
 =?us-ascii?Q?8FfszJUTYkG/xCaKoEEHeH+girtp55FnKpKCi0AveOFTcWXn/sF8QhqnSGz5?=
 =?us-ascii?Q?ORoPycnTMhpwFfbqETzfTcDzFvL61vSUaSDS868BPNhdcqDBiWrnzPlnSlRp?=
 =?us-ascii?Q?+P8B6a3lgwIIwj+uEZ9qtByonA174MrbdJZGt8MtuI41vp+wgsh5cN2yzf2E?=
 =?us-ascii?Q?gyn1OndaIDwxxiVJgIwK9+bve19TRlhAAoqYCoa9GYUt6q2b3foVKpXf/2pU?=
 =?us-ascii?Q?ard/MSk31NY7ns//vojECyX0um6rPgjP9TDPqN3UU9ubwG8WI75uQPVKSZCY?=
 =?us-ascii?Q?SHOBObYqhMx1yyOG90SLdi//oIBjO3Ipn2Xec9enGq+RaumzHU5j6XSoeCCC?=
 =?us-ascii?Q?8iUpUDZXQOO+3wHzO1kCqz2XIHB5+E7nzi0QTaUJohotRVle21Cz8rFGSDMa?=
 =?us-ascii?Q?SXUUkM9LyZaA0zbH9eaagbWeqjIEQK08Nefubr9JJ58ID8ekMbZVKHNFFDK1?=
 =?us-ascii?Q?ugv4c5L3b8oIASyFzWdBwwr21r9pZKO3i/NPpeIE4x6tPmTVX34skwrO9m40?=
 =?us-ascii?Q?WrlHO3+AK4V3RcMPOfbFTbBtIymY1NatuUPpR/Kt9e0QnfB+dBYvRI+BI3Uh?=
 =?us-ascii?Q?MdA9Ytt1uKrmwtOLJOHKfDP73ZYXn53d2a1xqX4Svc24ddTJ85GD/DaRinW2?=
 =?us-ascii?Q?CaK4Aw43lsOSCb+KA5JYORj+ExMlBhdI7eF8O4mowbr98C3SJEGLJyrPA630?=
 =?us-ascii?Q?XgQ3qimGwEOY54TE+WQLdMsxKQMp+cDB36znA8xgxqaO3VwCkS+gczQRZZg9?=
 =?us-ascii?Q?iIk9DD5figs1uM4Kyt40f5vevA33nCek0dYt8Z2cEKlEsCZLyeEw0Oljqpmq?=
 =?us-ascii?Q?ZjtDuXsvIa1T+WQDWFSk/e0YwUvJJdCIiyyrAJeVuDaFfPcXp72lJvKDcbst?=
 =?us-ascii?Q?fb6t5jIK+Ks3Tm1ejLblNw/phPMvJ373GYzaB2XoNqkEfAQ+vS83qdXUtD+/?=
 =?us-ascii?Q?gkVQkm6nuG2ADR8+OosXdnrd6NLzsC6ADasaX+YA/g+aYysthuWGYSvkGE3/?=
 =?us-ascii?Q?rJSiBGp6ox0DoFT4qBNRf4T2ixOBNmqzF2df/nXqOmN3YKk0EGwzYIT1MrPQ?=
 =?us-ascii?Q?vHvs0en+r3/33tOinU4I0e59r7oxUzs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wiFcYkBqfcs70eu5JiHekKyoPVFIG/6Cnj5Z091lsPP1ORCft8LMbKyrpZkhspqBWE80jm7IhQ2Gk71LSzradTEbTJilBxZ4ZzPBFbyVlFo5+J1dduCo0SGvgyLXV/GVkpa8JkJE1X2G9kyn2I0arSiSkBxlxN8ol3rymQa1qL6nXWEvk3yjKS/SBToIpeAQg63E2fv8bQVO6KSJAm4DXE1muN2G5FVlPqsBE4msHnUtLb/BE5YGpRHF3vWn6geQg0sD313Ko+dgtp3z1Jr1DtJxZr0vM3ojoZ3eahDhV+vUZ0OwB383N1Xqj7saISDRvZIpvHeADDjc560Il9fe3o/pH/ToswzSsaWAbbCnXZHwx6nroVam+Npl1jGJ8a0PaGaC8lbwwJWh92vIuAl1tTYGFKjSeMiKImNjoThRHmZ7o6JBY2raaofMcm81bxWlLxYaSm4Emoov2N/VVfuW9roAt3HPYDkEybHQt+1xi3KX2/AVhowcsmILbeS2kHUSBJWEjPMxkdbOJG9EcRSSTBM/TIOW9T/omdCw+IYRRyFfDOxKqTTue4OsKXCUJgdS3gJP0NPLEWS4/dJvHc+fR8CTTe3AcMmMglkoKM4HSo0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e3f43b-582a-4898-97b7-08de639cdfe2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:24:15.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eH4TLA2b8kX7kJmjmMCphvGbB5MbdY/BYb+BovVFbk6mtxQ2gHc49HTHxl2LK47WlAOis0DbRmum8b/cs+p2NbcRfAQ6xUVcP5kq2IwCsao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF109C7C399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=909
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040021
X-Authority-Analysis: v=2.4 cv=Db0aa/tW c=1 sm=1 tr=0 ts=6982bbe4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
X-Proofpoint-ORIG-GUID: XDlq3n3ipXbfSrr7xoZRV-n0h2yVIL9t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyMSBTYWx0ZWRfX4//HZAZ596Ld
 ox/M02A4mRJaE770FIWqfA/VnDLZdYLqS2S9oUYn+hkakF+Tr/iwMIgSaavUmtn0QJPX9aoPYai
 dp9h+WmVWB350mbUGxSSH9hCshyqFm+PiLiXovY8oq8hlCGFh/bY/VQognPm+NmGnGmhVsPJjKs
 wh8+gR7j7r8DDHG4KX4m9xXyq2VkoF/+HfhieZKmXICYl7Olmp4eCZe2YkRJ+SrOrkpw6JDzCKY
 IP9XkIcehkuzvfV1u6CTfFGxBEOvV5ivn7ZkdLeMJ58jsjeyImkRz5ewcOjsYX5DLOaFZu0gATp
 yQsGoW9Mpu+F8XfJzjfdi6+9D+IGWT2GYVtRgRJ/g9sTclzItCav8IQcqUjHq8taWYQf9haLgeV
 NEA+P5xtF10GRBd3YOsGC1EkgchjX4G0TWZ13esIgq5/p791NDRACIQemYvtPm+BuIzFXCuxat+
 4t1wuTEiHZ2sKJHsmlA==
X-Proofpoint-GUID: XDlq3n3ipXbfSrr7xoZRV-n0h2yVIL9t


Zilin,

> pqi_report_phys_luns() fails to release the rpl_list buffer when
> encountering an unsupported data format or when the allocation for
> rpl_16byte_wwid_list fails. These early returns bypass the cleanup
> logic, leading to memory leaks.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
