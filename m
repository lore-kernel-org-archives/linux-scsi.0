Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660845000;
	Tue, 23 Jul 2024 00:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721694677; cv=fail; b=DVAWl16OmCZZ5q/yviCZrzwPEgEVDkgSVbP2j308NMuN9+dQ6OUTs9L5POIBRlp5lniVobvRXEw6grWOG6yYhCegIa4YZo3tw+NF+a74MRpDsgwIY/coENjnCuiYbtLqgdKyCI4/uDW+Z26oFQKl3QAhqwGa2em45OoOAnVyGr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721694677; c=relaxed/simple;
	bh=45O89qIfbwt0T57MQmb5asbkAUU7BmA3R1pVPMnKfYM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GSuLLTN1YYpYEZT4B91yr2AP8Qit5KgkN/4FgwWDwq4WauvdJcQRcu0fBFi7PCiWDrSa/v5q32x1KnH7CHKGXKvf0cuzI6ISZvwh2W6M4YisIcOyyuWAF7QWT3xSFNa3Fqx0QR+1ZHXRfhZnlAshe4omL0oGlZ7EuG3npmHiaGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=luAWTR7T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MpQjDb2l; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="luAWTR7T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MpQjDb2l"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKtUGZ023782;
	Tue, 23 Jul 2024 00:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=grLScEztjE+Hf3
	3c/la5x4zLlJz17v//1gqsyg3jNzk=; b=luAWTR7TC77qWGgsBTU9m44tMU5+W0
	JgI4XewJiRZY3b+Iwkgs2KBxPBBHFNgRI4t43QYWsmD7ZyC7OUZfEFFNt+AyBE8H
	4jS4VHfn7MDMU0Ej1qQO7hjCv8jgsAx1mzK3V+TjnZUnTpzTBPtu7uJ9KBneTTHH
	1ko/kNh2Q65FydtkBfoSXj+HnnryBix7TjfWU66+D7tYZN4j9O2TxBwR+rtJqzFB
	fHOAdFjPyDAsZzglNtv6hfEad+J6BWuLVIWlsJzaWxfbyO97zGdKpyRxzx/pGE2j
	H1EWSpaVBGTfjdBeA2H4WPvnTco7VeYXFhByWUgwo9bNGaxdeEV61M3A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfxpcav1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:30:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MMILAJ040109;
	Tue, 23 Jul 2024 00:30:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h26kr122-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:30:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PSaXntVlImJ2haKp7kzt5P5KMxq3RA0cbgWw/pq78fcxxWvO5mXy4FnhWCziswnlV8ASxc/2KdLrgOnfAc8yf1qx6tJtDdY/muK9FxpdWnXLdB9USk9RAiEKVJCTNm2H4R2TnEvV6CJJgVVn951bG61P/zN1j9wzUBZA/v4Rw1bK61m9t6EL2S6s2HTFi/v3L4T2WN6E0uogjBxsyPwa16V/H6qNPysQsBJb/YSMqGqXK41fNgws6K+PaydXhe9iaeMB9MM9nXMAXts3kv/GU5gjp2rb26LSrhoKPYkdS830eG6UBkRUKHIGEWKe6rc0i4fiMLw64d2pDXoYUGdYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grLScEztjE+Hf33c/la5x4zLlJz17v//1gqsyg3jNzk=;
 b=XO4XpWXoeQhMl29IWz7H1l79EljwPj2rdnxp1de54p9hJzZ66SohcMjlbko0Z7kNa03eGFiDJI3KNFjJt5DT6ktN/dZXaKTjwiwBDzspeq6oAK8BfZbaIeTysZzzolm6xWBe05eWu7ws+HE4xkIAA9j3XvcLtHYClZZ4kFaZ8gHCF21Q9bX/L+h9nuvh6liVCCxkhHnqmBCclYzNm0ZZCs82qarS/RXuHT2a5aV1CFjrJhLM+SYPCEGGNV2w5Y2h00UfAv39C5UAMajJOr32odg/QuOpYyloEOXXvbyYJA7l9eN0XlrP/6IhwDVuKt17q4EPRoEYg0LzLYbN7g2IoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grLScEztjE+Hf33c/la5x4zLlJz17v//1gqsyg3jNzk=;
 b=MpQjDb2lhyEgTQrSLttGfzvaS6GMsWZY6/yQdDZ/dMGXGKxcRrXygmwO7mZSkuhP/IHF8RXECKYNI+dZj25CthU2JfpCfx4YjScg3iKbdb14mnyQ/stca46y2qaQa7beZCD5AbcJ+FJUi1tG6nR21NT57+faht1BwQgaNqI3hKM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6145.namprd10.prod.outlook.com (2603:10b6:208:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Tue, 23 Jul
 2024 00:30:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 00:30:50 +0000
To: Johan Hovold <johan+linaro@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal
 <dlemoal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk message"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240716161101.30692-1-johan+linaro@kernel.org> (Johan Hovold's
	message of "Tue, 16 Jul 2024 18:11:01 +0200")
Organization: Oracle Corporation
Message-ID: <yq1cyn5dk5x.fsf@ca-mkp.ca.oracle.com>
References: <20240716161101.30692-1-johan+linaro@kernel.org>
Date: Mon, 22 Jul 2024 20:30:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:335::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e0d14e8-3a0d-4f03-c59e-08dcaaaeb3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?51Xvm3RBuRdnQ4J40GzhZl2c9Ucwi5+Tff5BpLVMSSdQ052T4Sj18lHqccJS?=
 =?us-ascii?Q?XBVtPOhr+4FCiFmxZgvvU7Wst/zOqXLVTqCxAU4nyZFWc3LCp6AUmswUeQjF?=
 =?us-ascii?Q?t8ac7ha7UB/rAKvDlwdYbWu+E0TmWdLNaCcT5VL3KryV/YZNtsQIOvAQWrwS?=
 =?us-ascii?Q?agqV+CFC8sjHY6bYVVhB4uBEBzVvS8uSwfk0VX+44x4W/CPxeLTjcHY4ww1V?=
 =?us-ascii?Q?gLkXbQy+8aU1pvYS6jxnINcCIqrqSb9nf8GGd5wxvYVUpHU3enh6MeLSFRRH?=
 =?us-ascii?Q?GQ+JYgZISx8EHhIhxuBYfAh2Afonkrnl1TNQ2T5njbQtdJgmZbukug6+Bg0i?=
 =?us-ascii?Q?4LHzJp2ca4Y9/72bplUeOf0/BKJP5CAoQExz8rZQSUn3h0/Y4XIFAs5Og37o?=
 =?us-ascii?Q?FU+5Z9cGTsj0KK9OZGiHcFYw+varHNGyp+IygKwSrIrs6V4mmZTZrsxCna4V?=
 =?us-ascii?Q?gs6YdHoQheE8rOx7u4XX+mbWr+EOCQ+FsRbZ2hYntbiYNNTztrrtKcxrZJP3?=
 =?us-ascii?Q?h6B6vnelg9wjC/150b+REKRAAkCrd4yu1pInSCcMJDP/nDlyl4YAyOBpISgQ?=
 =?us-ascii?Q?ZJM+e0zJEftnDd0/H2f2WykINFnsjgNEODwBnpdj8TLN3N8b3IcpV2rH+QYO?=
 =?us-ascii?Q?cLch9KjTN962yCSUMTkK0AQ0ZsYNH0HTD8LRnz5j9SXPeKy1+Qxl9ezTv+yw?=
 =?us-ascii?Q?OljsxqPIB2Ky7tLuHoJ1hTk86YJnes7SgpuY/gITuZ9hCog5yE5UDjMN6ATc?=
 =?us-ascii?Q?1SI0oMrokADGIl9x8L0gv0jk5R7sD3FabVXp1719ZOwbasP5ZwqOVdcUa5jY?=
 =?us-ascii?Q?0Liz+qDSPyPTqsfydHZo8HRvJtrKsItxYWQvRXEplfmAr13tn1mAleH23Uc9?=
 =?us-ascii?Q?y3l8e+P+CX6ylNQ2Ayp2alRchARZFlDjHNSf0bZW8n4qvwVmTAKGsGsyVdvg?=
 =?us-ascii?Q?5aCH76N9HaIMNoMt4OkjlIQslddf1bCYVfPwlos7IOxzP57lD6i7uLbHWk5i?=
 =?us-ascii?Q?BIKrv9uJPkcVU9/lzRPujpZBqNAax9VeIz4BXb/7xPHr5DdSombobcEWoB2l?=
 =?us-ascii?Q?EmxwfitwD97/MXCwvPCY/DvCd7DMDwU5cpcreEl1kfGw3uDmT8yLJAY1FNHX?=
 =?us-ascii?Q?N1IX7ISTa4ouWk38zRTFelnABPpg57yvoT4m2Y7c+hEYEWiUtbtmmp/FxLoI?=
 =?us-ascii?Q?8JTBAgTgCVYPDfmbjGJgwveCtWLOMhbgPGihknSBHLNZLAo0ckp+zpXwpYEr?=
 =?us-ascii?Q?PbTJW6nSM7Eq/+YFZaXlXWjtW61T4M7PCQvvqar3LR1t0PgO5MxQQ6JQamaX?=
 =?us-ascii?Q?onokbX/X0WQsdJlmwkiw+p+UFllNDv/16MewGtNVIjUucQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ej5dB4aYdPzxMEq5ZBv7N68APvugpuCM0z5Dsm5A/zABGRUYUvN2fsRPJ/MC?=
 =?us-ascii?Q?xdmuAIJUl5+B5/J/9ip+/zhaAXcu3H9gfOaXTUKFP/U/3o63TKMbzUnnOpMi?=
 =?us-ascii?Q?C1wdQCywucrI9nrujZhZvNqpu3t83x6v1yYDgy7IP1PVye6OBxKCQzN6qPzt?=
 =?us-ascii?Q?AGgpsuEJVV75i1tqdx/rEup3WIqxlz6SCe1N6lCaJI4/l7GE5PzJ9L+kckzz?=
 =?us-ascii?Q?L/86FCa0ZzJTcL5cGp7xWWlCD5laWrP9Vd4bNjL6fhysncpi4JOmaoeN+guj?=
 =?us-ascii?Q?f90AGZg1UYP9c3uvvP2/nMaI6OY/7ji1FmP51YZ0E8ZRhF8LtNL/4XZjf/ZP?=
 =?us-ascii?Q?GoJjnoPHx1hNGoLAwEvTU3G6RMZlpgeTxqndcu8teIfFGb6mVV+PbgrlU/8C?=
 =?us-ascii?Q?39zj4GoySeZJzXtSnagSZxATYgXAil/9p/fgz4cK58fqnzvmBTSpbAfgAWNj?=
 =?us-ascii?Q?3TlM3a/0J9eHF8/honNBBXcqWfDnl55Vw4mGDNmOKEyBKyqzLO6wgdkMVIGd?=
 =?us-ascii?Q?vM7fdSfQKLoCtd9daMS4VqIeWljm5wdmYeWNrs5Lka5CAzEhXQqwAqfNfYdl?=
 =?us-ascii?Q?tyLyEBJ+2kdfwjcbq+STtwLRg2wDOZRvgwsFC8WN3AynCa9ZovfseDCvwYMA?=
 =?us-ascii?Q?Vf2KaU8bEiu7gdmKLZEet3nHcJT0VLrOT/XWmt0NI2G1cNrXl1WrIndil0sY?=
 =?us-ascii?Q?WxO/s2AS3BI/VS/5IeOBZ8cCg8m1DoWpGCxJRPcSTQ5oY1E8ouflkyHr66K2?=
 =?us-ascii?Q?++ZsOIMSWpEaIr7swTaivtDysTvq6EDpN47NjSGO+KqEDIIM5Vk7prLnCPwR?=
 =?us-ascii?Q?4j/3RN+oQspuSkSBmfVLGHJCMMRboL2IdXFA9p+nmxi2/R0yoxymIPOLgtBP?=
 =?us-ascii?Q?ccFUwGQigRErU+fRQNqHjVhYZgmUlc/X+7aoztRl0PhwCc+PCWu2Kcm8sD5a?=
 =?us-ascii?Q?zO1/1JEmhusIpl0tUU9jZpJY/My/wRjVHXXO6WiRx0XO2ssYDXZZ0yi9HPTr?=
 =?us-ascii?Q?bGcCv6xgjFOoXMDYF0KiMbfalXrOf+YRmNnPIe6z9CG5FSCrPP2nqISv2KxY?=
 =?us-ascii?Q?RcMhxFXm7dzorE4sWJ+qnEyD5Q7gfkgVUPBmfjcWRS3JE+MsIk/Ep3GEhDLu?=
 =?us-ascii?Q?G2UYBFQ0O+XE/IgUjAZ+D36upffwREInP+qPT8tRhvCS3hZLJwX9K693Cmns?=
 =?us-ascii?Q?MNVIuVCULYdMZNZw5D+y3Kmer2HkBNN2uHmVPOsaqKJOEP2GOUPE8BwpE8Z2?=
 =?us-ascii?Q?VLjKciLCZA19VXIiU2OdUzHpJkNzKJXn7sOawumu2ZNwmkHmKq1KQbAqE1vk?=
 =?us-ascii?Q?bV0EjndxTpHwtxy9aWkdwH81V9kMi93j65gHCaEKvsS17VU0OvZ1jVjnfctc?=
 =?us-ascii?Q?Bs/UyKMt5xVvvLvauqmivqlvdJvnl5mOioPixueOzf2HG/wkrdzz1K5rhQNQ?=
 =?us-ascii?Q?WPUXb4W95g6k8bd2AKOT1WOuZeGcgsQE5SN8ZhxxwHKh8GatIZfeKMH8MNq7?=
 =?us-ascii?Q?Od+VaR7eSV+5cf8wbzFIm8MksAoCtEY+RsVHBVxlWUeA3H52r057IhoJWTkX?=
 =?us-ascii?Q?hgvAStG5AaIORG4ppzKsBrBlDw0VcZU60NgrBbg/xw1aCQG7MeauxW3UHJF2?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iS+LMgBPUgCYfPuJDptmylHLSsFjYOavKmJCLVUh+xeI+ADSQ1CjUCGfNiDrBJlC3mIkatAJ7KEUC/+GtRET+7hdEGDDLIqQcQgiq/ofbU/3EaIWzvkAUmghP9pDJJX+bA6UTRZmoXqGBMU2bQUfBQjKjIMht/lEibv7tywYC9aG4Vl1zuQ12hslQqPb6gyDui/S6Te/1dxQIMDKi7qff1mbzoSg9vfkpWn18CrBEGoXMTQ8CRIyst0E7Qb6cGaTSpzUWIPXXl16zOt7ue2M+zJ88SdyetBF230FTH6sMH3DWRKyeiCCmFelALsRKVCwl/fgk+vqk7qBOQgqdOkHzZz7C+26IesDGNb2er0vP1Zrr+fBCI+BdtqaB0DRpJdIvl2egK7d8fQ/glnT16dOWBXVH0E9q15vJMDvwiHG6BNvA6SvP62VAYLdyknbMqf+PMovK+MRBhsJHAI7xuLtc0FXeulXdv/QHxrJ6sVVyurpZVYUdHIjNCfbKvrhSqPDJYxUqRE2OB8yqBV8Qc8cAIH9XPDelKSPPG5QwwR0sD5NeUI//3gXc2RCWdVLgDjf/ibn7fKhuyyEckv6Tf6k2gJT6fFli8eyIVJkbDOeM7U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0d14e8-3a0d-4f03-c59e-08dcaaaeb3e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 00:30:49.9976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pe4LAePJseQnK10JlG4mKcWkwARdp4hfaRfEmfkPZbgRtg77UmxAm2BayJ9GYYkY+i7n3jGdVcGbD3sB9d+Kwi/cEcX/9cy23kEOLHK+LDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=630 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407230001
X-Proofpoint-GUID: P4HifdvtiGLceHPj8DaJywDRkO2pwXZx
X-Proofpoint-ORIG-GUID: P4HifdvtiGLceHPj8DaJywDRkO2pwXZx


Johan,

> This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
