Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AD32F533F;
	Fri, 10 Oct 2025 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760105731; cv=fail; b=M47RmKdXn9wJpmGAWjvdOqRWjBFAVWrkhvGFa/VP3UPC/sVL1WvUSwK+lOCUyRaFzybNsJ1M97oJOPygOpa7V8KKniIutGERnVKbAGCPTxats8k2W7V/q+m2EMM7DpeQqcwR8uiunoabkReuYrVANSR9HzEN8TFM2wBas/nVB0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760105731; c=relaxed/simple;
	bh=JtJ/LtBnre1YvOz500pCCMkOnPMeWlpElora+RsPLBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CiPLnr4U1iolsbua681ukFOFwaJ5eSehAK/6zEseUNVxLfiKOQXrgU8WzAzCLHU6pzR71UqsG3Xlg1LBxXFw9Wbdn8Vs2TMJDO5J/oqeAsCOnDfxOLTL3G9bMGdF+gkMLYf0WGUtFHZP5P9xLnuIsYOhyHUag1ituZmOkOgCpmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f6PKCoef; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HFaCM/I3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f6PKCoef";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HFaCM/I3"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8tMBo011315;
	Fri, 10 Oct 2025 14:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z0kJhT+i/JJiuNXnr1bYF+HwlvMcR0/mLrtVqjVKeRs=; b=
	f6PKCoefAAAsF9I8/PTlwQfdtW4saI0aWqHOqafAL83UB1mz7YZ3De9iSLeqtBkK
	e2a48sm/+fgHjUkxIZlL0Juz/4ah7vFyuwIj0zIHQXQPkkUyas1IXR2K+qwSQ+e9
	JRsx1ceqzKhwSJOgDzx4XoEL9B97LWc41n4KJjAlCwBjw9zM5gsEWDnV53lNa7Co
	lYQYrjr3achN9t5xf5OHrfjJymHq2ahdcCp2WVillxQPwhUyuw7/zDKQsoOuGDVd
	hf5lUKhQTEvY2Q7vQWwZAYgh5MUeppOs/kONM6+MdxNmDKHTpueUcYmeDeoenTAc
	k6R/9O2i7yHYD+OTmjNcIw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nv69urq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59AD4t31022882;
	Fri, 10 Oct 2025 14:15:28 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49nv641m6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 14:15:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sAp4MD06H9zohOs1EKD/5zTyed3LQwdz2WLH51q6dIHYUtuuHvwFDSsqRh26k97qHAwp6uztfZhQSWyzOG14o74tomfRD3DRaEbjUhdtd9rZy2Im9WKkWJJlVwezdsl3/p9zMh2aafdbLS8tbp9uyOtXjqoINOZQGFoy7tbFHQolATnX+kbj1WexKasCmC0R461r17E/hj73lDH1guUbkEMb3b4f1uEM1yXGzgQW3AyzFXlg6roZbhOfBKA7Vg37zuYAY82L97CR7djifcnZrsKMuH7m7FK778JgXmfcj0k+Y1P3EeJ+qqaW01eZr3CL5Oi6JmtT/kqpuzxWndjDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0kJhT+i/JJiuNXnr1bYF+HwlvMcR0/mLrtVqjVKeRs=;
 b=zOLV/QCp39IxCOLLbjxi4mlidmpNT8iVc9/cgAaRC3vUcsJ3+taSQZzH2PRcgRD/S1OvVBiLkRR56hAoh3WIgB/ywQlzSA0C9ZMuTFWT7CVQt9Cpf/8/irZ+emaPgz4eUkG0rAbrO87cNTGaxJoIPcZZa+99OB8aNXCWZtE35Dj6GuJCx05ngICgmtJTSW/RDx8yqzXZt9OUIOgSTyuFapNPTmrJUCIWDjgew0+qru36PI1xJW9Kz+jMDUiw2NED9iEKyAvra08hCE8jBeoVFuiGu4N1VwiKD/w9KOGIyc9voDJzQT0jZ5l5YBbf7CKVM2nas6s4sh5RgGncOPge+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0kJhT+i/JJiuNXnr1bYF+HwlvMcR0/mLrtVqjVKeRs=;
 b=HFaCM/I3LmbvIsi8ZCLlBW2PicmBe1n6tgVZ98tLHZTxfqHTAj1AssLW28adNcmaBQ6cT8K6QkOSVqW3tn7+IANXbVzHBceABFsQHjql9cJLQ+YSvEYku7A52pzKvlLEWDLz10K4AP5NrE1Opq25lf0Z++QL0iAhmC8hJQBDUmc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 14:15:25 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Fri, 10 Oct 2025
 14:15:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/7] scsi: target: Add atomic se_device fields
Date: Fri, 10 Oct 2025 14:15:03 +0000
Message-ID: <20251010141508.3695908-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251010141508.3695908-1-john.g.garry@oracle.com>
References: <20251010141508.3695908-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::33) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cabbbe6-0ee9-4241-8a27-08de080774ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?55ZGHR55ktxc9JMwgkz0G0ARTGAQkA70EmWDyJrpoIaMNiNOI6CmJq0qQbjO?=
 =?us-ascii?Q?A3CnFin39vK9ls3K09JythXntapI87faZjg9AgW24s2l0gbjHjZzIPjdtkJg?=
 =?us-ascii?Q?NqgJpMbi9X7Lf6wmPrVx7Mub6Uu238m+ZiIri9D+QLYGSAzvb9mmESUMiYU1?=
 =?us-ascii?Q?3r7GQ2kGlMRQcbq5AHq0icroQpOEhDcx3ldZ5tKKBLgR0Jldm3CSH9RiSkKw?=
 =?us-ascii?Q?pzeZlDLcWjBuOcCa5zFHpWf4Zwwmv9s0YQoAGZw30KbDJXdGZZ216zBU+ttC?=
 =?us-ascii?Q?cYuAJWIwMBaC7qtetmTJgjGNAwMqc43m5zT8CSDbnlp/nBvkLTRRnZPddIjl?=
 =?us-ascii?Q?xr+C4RD0PsQ0UGMCJcAne8VA7QBwwCBV23j+OU3/eQK8Z7YicEopMqxYBXl+?=
 =?us-ascii?Q?44WE/C11447YLHTAhxaHf/OGHKSrgi4mOP2HBTuoKNKTMYr6lQwxwA2aiVyU?=
 =?us-ascii?Q?266y3cmVeKC+dMVYXo06jtujPAqKtsPdmU5NIaVL6NhIkuaCfEJ9aH5OwjlG?=
 =?us-ascii?Q?jC+T0lKnn8BqbAGJX2vVzT5jZ6TK8ZkN3ASoj9JcfO1YBpFvweoaUkXGhAsT?=
 =?us-ascii?Q?aB93X3Mvuy6BuHfrA0Z4wJCgQvW1lzuxy+vNfGmamJ0pmHnkoGHWlX5nKPa0?=
 =?us-ascii?Q?67UKFqfnRvtghekAnP5X8k2ReCW9ndSLClb/4WaPm5VTqEAaTxMmclr28klA?=
 =?us-ascii?Q?VAkNK4Ns0+Y/Fvjf8eKe/QGbCx9U01TUh2OsgXtPSfGYHvveWnheU4+AQTgJ?=
 =?us-ascii?Q?eXbloYOv0ph+snl5DnsJuVy2Oh0Hg/B6yc7zC4523Jg05HRT7Jkztyc3Hlek?=
 =?us-ascii?Q?z7YpTgCeDoeaaNySlKO/dJ9rIzEhW0HR2KgCgKMSsw5td7qY2xSZiODH0z3g?=
 =?us-ascii?Q?dx4bOnQDZ/9yZoL94mzvulalqR4ZatyUUhHInwDt7+8A2Gb00qA+rP+nsyFa?=
 =?us-ascii?Q?UpDEOKyAyYrg63tO9BZ06GxJBJw3eYBhKCKorIkLX58mVNLbbF1NT6Dg/xyC?=
 =?us-ascii?Q?1/Xh8op16Reifj/HBdrHfS01PXpnoQG18NMpY1/BYbP6VzYeouMjGyvSzAYK?=
 =?us-ascii?Q?sa/UMVALa0BJHksQG/ihjPo/yG9eMcgCexKHxWjm1Uf+KOsxRCbc8iVLrqWe?=
 =?us-ascii?Q?qbJnaicKTddwfLJ0LfuEbybeKPC+NnKFnuEv2axpHFWV2Lr54jXc6e6VIH02?=
 =?us-ascii?Q?ZWpiVDO1jf7I9WT+xR47xWOsO+I8bigX4LpNw8AhvKobDR3BiMSxe3v9abO9?=
 =?us-ascii?Q?pVwgQlnU1XVF8IXPVpO+tKgFn79Nv658QxB6953a8t+E4kNRgbzP0Z401Xg9?=
 =?us-ascii?Q?H2nxTxeUOcNkyjxZBQqvYJuk0Sa3tjhCCylUZnsWewO8Ttsi+LG1egMJ/nNb?=
 =?us-ascii?Q?/lO5mTNrgA+WP9SxaKLPGjIeJpvjNx2p/NcBLXD42XIpY3gJlkZRssVbDdU9?=
 =?us-ascii?Q?Zf3RzzovjLj78q9t2vDnp2rkdsiXTwC6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xzKHsMB/9tkazGlGEey8A/vSpQFz30L6BvPSp/Vh/AQV/qO03nJoM2rm1yui?=
 =?us-ascii?Q?JJbO/yVCA+rki+K2CppXuAFXyEMdIeS4s0Ds5qh5GuDX4JM+nNv9aF9y7RnK?=
 =?us-ascii?Q?DNozcsfWxAiTSc0OjnovPJyZxYD72nKS4ZRCNDWxkdehIpmF4ciWWXi7CjTE?=
 =?us-ascii?Q?sXi+ChaHZp8LXRaytATALd+gFH6rnt7SyUew0qfuFj/GW3p9dIiJSg9gov9c?=
 =?us-ascii?Q?+XngXhuziaBgKOBM7Vfl8NpnJGyWoB4NNld1A5AkiDt6lSl9F2/bHHJTR47W?=
 =?us-ascii?Q?SYy4qIfoVrlkkordUO3xms0/nUqR1VNLshKQAGNPw7tgp+Flw64Z3nPNRbIB?=
 =?us-ascii?Q?8VVQjkoMN1kKFYIjWnNLFwAYyPzqgCojrvjOIlHcL9GkhGQBifBRAatQgTuA?=
 =?us-ascii?Q?BogiC3lIRfYnps9aajcikYgyCoc+9t2HdQ43M/xVHUd/qrAI4u6lOpdl2/dw?=
 =?us-ascii?Q?WK8bLCwNLVH1TsXdRAr9uiuSc2bWZKKScxox7b6AyU0vkCpYQr7gRHz4Wdts?=
 =?us-ascii?Q?LkgrT3iiVHKLRfIofbFWApx2VA7YUtdEUiLODkn41VMotVSGUj1rT8C3vL1I?=
 =?us-ascii?Q?Wgk/kcI5/gFUdPkGAgjn58R9+3GTap3ve1U2TNYlt/dmGukk+0BYe8vKQ2tR?=
 =?us-ascii?Q?C66XiuANjycWJ/SwjwE94PmCfGZKANBTKxImAEjmt2ncNTpssxL2NSGpBoXj?=
 =?us-ascii?Q?GhFvodQIf38PS7fIBBGUH/svFEb15C8qCoeKZpTF1y5sXFGyIOww7WluF25R?=
 =?us-ascii?Q?yQnQM4KE8vuBuLBkIzcw2Ij6dYMP1VdRHzDmqo3AZhdEoqpvVPk26RHJYBH4?=
 =?us-ascii?Q?798gxACRaxz8G0CcIV4MYAe/na6zThJuIxAeeboRP8F6AWWtUsF1LFQhNRz7?=
 =?us-ascii?Q?BpLvsQ/kW41XMUHKBmBb6D2/ZXI5YEftFoKk6iowghtZzvICq4ntwjnvqHCY?=
 =?us-ascii?Q?cA7HPeLOM0gG7MvwVsWvfIEimsPFnTvswE1wkxSMBVhDpbIzRI0irfktGk/7?=
 =?us-ascii?Q?wX3eZVR/bdeZ+rXa+ju+4bYVV2fDBd/pHUDhRCcdUgVnKYjiGDkSZHP6L+Sd?=
 =?us-ascii?Q?EMGagEqvokCYi2zgqCSEP+LV7X4/gp+j77n11WRS0IFbBtDdKol0H7s8JsIu?=
 =?us-ascii?Q?ZL/gg2ZHEhPJL2OYnHiAAf8BslKvhDPDdY2xLdg6RDrPUd7Te1Jaq+Ts4+U4?=
 =?us-ascii?Q?tX9rRV+wJlZub9APPQDEawgI0JoV02TKMfVaZybFPzSFD8rzC9ECDkJrPuzW?=
 =?us-ascii?Q?x29S1Brzq/o9lzD4llt9qAbAKob5i0cP/BcR2DY6+4pHC1gGK/f12/j7SZQk?=
 =?us-ascii?Q?Tw1PrRmxGAZZLJvhRTv9h+myQ4MvpI3FLM8zGaLk0iSybcKcg0p+T8r3nyya?=
 =?us-ascii?Q?VCXOWS8HlTafq0ZwtR3VoL/a8GDpHjNffbS3aGGf9q2Nn584JT/EDWZg94/Y?=
 =?us-ascii?Q?GAMZPmC7wm8jh5D/wxv8TyBCjEkJjXz2odFcYcQebd0RtolnBFyLly2E5U6P?=
 =?us-ascii?Q?tw8XZ0D2X/XGiXw6YaCYJKxwEod8q85kxKGOfyrcpFIaoo7eYWy8wwPWXQrR?=
 =?us-ascii?Q?D1Rcd2g+Jpu+FWF7u1W9/wmvt0q/7FZgzN0SzfC4mlwrdaBFcmGPyI1B4RoP?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/4Rl7Vy9Dr1nofc6+mrjcuwdd1Jr6zzBfUH7LeRaMS3VDXRH4ch2Dz2hbVxm0HqRotUI6KWc8kII0jI/rbuhDbNf9Ts+kaKXOAqlh/eMFWU4I9gHvi6KbAO9/8zU2//rFO61NULRR7pukeE+I5KvtXCT3gAIFVPAsGSi8x+DpYwXpQNknwCuidTK4cyAZJfa2Co74HJcANuxwkWd7+vJOoWz0Il32eTOwRhNj6FKMdtUiCBNTAtGYG1Q746D+ezkVhTPZswzu3Actc3gmvK6nc9GrW4jOGZTS2YkxtmjeIAQlgIL+miCCGc4eVM4sixdqXnWEF6oENd/DPsBOsQS1QX6sC9OGMzARz8VtpSMu0WszcXuv05Na7AT1N9ukPN8ZIopbzuOXG3y2KsXTdv8jnMrMLTXWGqsjp+HUNpsjK/Waz4QnGWXK3iEOap0+qcl6rLqeMjUNBjD4zpBaG4rU+G+RFzP43p6a9XzI+PChihV3mwT+PmQJt8tPOdotlYlXvQavqs5bQ7Zp7eIgGt0yLAvP+5S2JcQIYdFGjxpbp4gAtWcXQxh+8I2kniRVTOnPCRq6ZS5KRB4htfNjONS0I6JT6cXijxr762H6NUmGHY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cabbbe6-0ee9-4241-8a27-08de080774ed
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 14:15:25.5904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05CX6O0K4ootmAzu4oydZawvuBVCwgYil76zSDaleHBg2tG9Svp1RP7CvuS1tD8LiFO6XY6+EzEDA4Vi90oYrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_03,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510100082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX3L0XKcADf4y2
 8Tzl/bvKJCcxbWqpIMOn3mfYokjkrSocMlJCEArVLxvgNimIdc8/JjziXvCxrIZoTEKuFwkxsDK
 LSanIobo0Z+3vZcal7+60/RTIiHVwmvuaLMhyuORsZCZaV2jIdXj6jv8shwJfIVdwphTHJX9aoJ
 XDgSxa25GBIsRcBvvLoL+vKsmxJlDTFX/HhoElhGbhMjFzf/w5u9iohYpaDyBQte8Szf5x2g4KP
 8w+euvk26gb8W/6kvOCskjP9uAseX567VtyTqXZf68YWyiR03ykmJMdjyP8log4RYUOsMlLGKr9
 uF/JDp2uKBWfJlzSiQlpSH7Fima7rc6SiU63ng0LWLrSzjHLmUZaBZgCtwvp0YrjlPPdwvFa7ek
 b0LRBXPf781SGCJL+Lt9geFrnlPep/XP4MT4tzCvrlZF3d3oWpU=
X-Authority-Analysis: v=2.4 cv=dtrWylg4 c=1 sm=1 tr=0 ts=68e91500 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ybRmI6yWmN6hDEXPEKUA:9 cc=ntf
 awl=host:12091
X-Proofpoint-GUID: 2HDnUNydOWBfZeNf7csgTQxaFdDWDAdt
X-Proofpoint-ORIG-GUID: 2HDnUNydOWBfZeNf7csgTQxaFdDWDAdt

From: Mike Christie <michael.christie@oracle.com>

This adds atomic fields to the se_device and exports them in configfs.

Initially only target_core_iblock will be supported and we will inherit
all the settings from the block layer.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: Stop being allowed to configure atomic write alignment,
     remove atomic_supported member
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_configfs.c | 15 +++++++++++++++
 include/target/target_core_base.h     |  5 +++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0904ecae253a8..31d1b28933e96 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -578,6 +578,11 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
 DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
+DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1300,6 +1305,11 @@ CONFIGFS_ATTR(, max_write_same_len);
 CONFIGFS_ATTR(, alua_support);
 CONFIGFS_ATTR(, pgr_support);
 CONFIGFS_ATTR(, submit_type);
+CONFIGFS_ATTR_RO(, atomic_max_len);
+CONFIGFS_ATTR_RO(, atomic_alignment);
+CONFIGFS_ATTR_RO(, atomic_granularity);
+CONFIGFS_ATTR_RO(, atomic_max_with_boundary);
+CONFIGFS_ATTR_RO(, atomic_max_boundary);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
@@ -1343,6 +1353,11 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_pgr_support,
 	&attr_emulate_rsoc,
 	&attr_submit_type,
+	&attr_atomic_alignment,
+	&attr_atomic_max_len,
+	&attr_atomic_granularity,
+	&attr_atomic_max_with_boundary,
+	&attr_atomic_max_boundary,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c4d9116904aa0..70ece58d30780 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -731,6 +731,11 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u32		atomic_max_len;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		atomic_max_with_boundary;
+	u32		atomic_max_boundary;
 	u8		submit_type;
 	struct se_device *da_dev;
 	struct config_group da_group;
-- 
2.43.5

