Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E99D29408;
	Thu,  2 Jan 2025 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735842090; cv=fail; b=QvB5KBd0+9hCEXOb2sxngmyswZj6nOGaYgC9M3jBXUy5LQxTpQYBRJB1+Bg//H37jkraL2ESEXx1zzONhovJvMrTq/wn2bJDa/grG7v/QGyYQjmR2LVIwboNrJWoRLRcxUeXKR0zbUveTvfzdi2zGoCbFDEsFTTJXJgX7GWZoNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735842090; c=relaxed/simple;
	bh=yjadGg91DjAbG7/NZRwUK1kNqiwFa62VmLJXTRFJZzs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VFxznfmiRPsA6NL1+dsxUzBsxmb0RK2rITHiddYDG5WDZjcS2jJItymZRBBtg9HhXRCFSsd+RABhrJsLJU4AzRKgsBaUtKWH9qevtgB48HtvWrti8Raz4kg83XIkYdd7CH1oP4vqPDl6vWGv+JygbJ+07NcnL3mfnveamPJ2AbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CdCf+URN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BvLZcbUS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CdCf+URN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BvLZcbUS"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXpwn026556;
	Thu, 2 Jan 2025 18:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=FeE1Y0ybAh/Q7gjYo4
	axKfORnCVNsJw2l+Qyw6NNIVw=; b=CdCf+URNLzBiqxI0xzdU3Xz6LOO/ajQ9Xk
	ttesMtOpnT7z2TEJvcav5CMhaEvCCjdjSJ/bTXUEgsIrEKpYBWBZViLR1zF4WuBd
	F3evSivWXaS/Nj3waglAc/7Gm+/bncmeMe5jHCIdaYIt2A5aiRWU7Mc08xKGyaYr
	1nEGrSJEtEaMFF54UEuMC7iFFRQD+LZLySdrTKdNzIFstMYqdngAGaMOGVJF7R2a
	lrtOVEebJLxJea+SJ+ANDQVeq+NmzyGqAt3Ji9P6nG21t7UardgCP4Vh8pLDXA1n
	07Syd0KtnsILM/tq1dpa95UkiScoj7TflSoQLz1ErH1+GxNXh/Lg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t7rbxaky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:21:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502GnI3B011751;
	Thu, 2 Jan 2025 18:21:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8wkn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wX8P4/2bcAEP6iu3obpcrdwGuHBl1aG77Y/anmrADzMkhNTNDoa3504AVNlDAX0HIIPi1U3r49kEueWw8Ji2RZZjL/33JfPpg20JwmqAEPQOAcMS1MAQsLC9FIkzDvPS3iw+LqbbiXJCic1oqurvcJFw0yoknlUZqNg9WGTGsXOXN2Vs/T9iX79zWEgahZucdTK7SnAHR4O5l5Af0prnzRYGhNdv2WWWAfKMk2x/DvyXqWcPhxLWnZ+sKMIpNdECboVhFYHF38/RqB4QYlPk1m2zEQBNd5iYqij+8PKHJU7dpsJfkG1bxgPOqWRtFIh2RtKRHtsikrh+FEqFnSoJdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeE1Y0ybAh/Q7gjYo4axKfORnCVNsJw2l+Qyw6NNIVw=;
 b=c1Mekuf/K4deVOsBT/Slx5PmKNP6grgXuEgwH8siTG95ATZsSA1OPwWbSUqQM2mCe+djjZdEonQu4FE4GwUYPwoQwSmIiTOgg5vm9pEjeTcz+phYGsauAcUXfKcruzmVK2jZdpYdVVX2cppYJL/2c23Xirx9KbGH0AypNmwJFF8cinlRYFzPKSaNw6c8X1Sb4qf844uKXNNQLIhOROiumCCmRgaMgTvMOa4fV1yMHlQmmxHbVbc8HrzzF29jJVRa/mihHNWuxBMvX2Mpg6tsDKFfN+sQPEiSwM1z2lFBI5ggMkSp9i0CBPwTCmMQnFIk40WjKaTIIsllXyg3XDWyEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FeE1Y0ybAh/Q7gjYo4axKfORnCVNsJw2l+Qyw6NNIVw=;
 b=BvLZcbUSKwR22soweJGS4eOaO1kEGv24azgA3DQRauzoCWfW7Zs/wETbQP1X4PXrNjXvDiTlGILQ28lZM51wmCFazfTjJQF8M0oeKaucBUstNHR2FNA8eX19BewWDC+EouqZ2a12QqvhZOMo/Umgh6WUY4JxZJPvDXRn/x7QnJg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7510.namprd10.prod.outlook.com (2603:10b6:8:166::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Thu, 2 Jan
 2025 18:20:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:20:58 +0000
To: linux@treblig.org
Cc: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: Remove unused iscsi_create_session
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241223180110.50266-1-linux@treblig.org> (linux@treblig.org's
	message of "Mon, 23 Dec 2024 18:01:10 +0000")
Organization: Oracle Corporation
Message-ID: <yq17c7dgjri.fsf@ca-mkp.ca.oracle.com>
References: <20241223180110.50266-1-linux@treblig.org>
Date: Thu, 02 Jan 2025 13:20:55 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0049.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: b7a7e4a7-5c89-44ae-7470-08dd2b5a348d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eFyEpK8oS9riZnHgO2UYnQsFQJn21pU6QryD/iOLe6Drpgj9Mxbcq5XN737N?=
 =?us-ascii?Q?l2TR8WCZfadqljcux3zw63pzbBUhIVK47gdyCzDL9tKq8NKG2yV+C3sJf/b3?=
 =?us-ascii?Q?b9/EA4piaDg749SrvEMOyTMQCZy+C/H+pnoXFr3KNVfvsOusiP9pU0Kq9GuW?=
 =?us-ascii?Q?eJwsO2rnJLSCvu1pvj802goZjxw3aONHBl05xj49XBvAAlb6yywzphfmo6U2?=
 =?us-ascii?Q?EHq5Dqp0kP4jfE6IZlObDgXrxNOBYrPw2XqoUgKRkMz6XCpHoPMg8lY7+5Yi?=
 =?us-ascii?Q?NzDM6zTCsLXIG1hxa7Mab8gxRKKQ6WVso3VwYbNkI2iqYxDWZYRfmotFig+X?=
 =?us-ascii?Q?BP/zPyDIbmuHnAy8vY/v6WTY1b4EkbXtHfRnpAlKyfLacF/I2BXFxgjqTmg7?=
 =?us-ascii?Q?1s3TbEHcydS/+YuiAfgD35GIH7WIgAMYb8GYXl6ilDjznvg6OY8DbeKRM+ex?=
 =?us-ascii?Q?O9xEP+vVBjZH+1tEgr1NPXgpXMrUbKkKk4Zwd6217MRa+QDi+e4xwKT7D7QL?=
 =?us-ascii?Q?yGWbDM77HkDD+fSulyEpFeKr1yF4u7oscMwM8x359s/qxK94QsoP2jLwe/Ad?=
 =?us-ascii?Q?ivvEzf5Fq5dIgCkXFZLMS0CD9n3qYotu54jwzGc2fXbs2OCvVYZXosJNa3C4?=
 =?us-ascii?Q?hV88OaMW2+MF8+nVAluHMVmNfVG+Okl3g1UqejWsA+xNj+gvIysO0fMpgasA?=
 =?us-ascii?Q?3XbWf1FZiGPZHN2H+Mwi3nmAMyS6f2bNeVqY11XyOHfdgPyYC+7PD82EYh1u?=
 =?us-ascii?Q?KfmKOH7wBmNXaQU6IH+cDKeF25yBM/W2sjOXBjEc0RVJmsZzGdHeIat6SPNW?=
 =?us-ascii?Q?YE+0FUZFiXPzCvBk4wXi1prABt+nYa2rXs5fsN6ABKL8Xdah1+4BP8Q2ZCcL?=
 =?us-ascii?Q?dta3yliXL6u8Bt/7mXywEcplrUB0vZMWZNRDNMrRd8/G5hc1wC2H0ZK51pRE?=
 =?us-ascii?Q?ihL0paVeI/3sYuhzz8mNTauGys0epZrpdPrprbe5WhS1E0XiAUacQufWyEi5?=
 =?us-ascii?Q?GFisXRHa+ihHOsNbRYW8eTVW4dMw9IRfYJYKY1MTl4qY5NH4RW/yxMaZuZ4W?=
 =?us-ascii?Q?CpmMEOVLOnaFOGBQN4VqVxFjXZ+Fxj2XO97U9+Vpr5ktzSmsrZXNjWBbwKtB?=
 =?us-ascii?Q?k/q1MpSlM6OM9mZH/UMbrDq2NfM+lwJk7w7rB+o/KZ7g/vHhVYRC9qBJv7pc?=
 =?us-ascii?Q?5a2iuClrP/CjHdDxV2TTSPSOkJsQILH+HpGWpNyEEaSWKHeE/EgSb4PlQQFI?=
 =?us-ascii?Q?pQ/x77uUGJv4KVO0OMZjuGKaq9m1mf7h9Fj7gNz5Z/k/K9CLCtXwrIPRQEq3?=
 =?us-ascii?Q?HwhE85njOnB1Y6Sr4fsaYWUx2aE5YgpZgnD7qk9tffoR/FXriaCPnBDv7Fe9?=
 =?us-ascii?Q?JwX8K6N1e9yqUuR+EAtQmYqKq4rS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cbisJXwZ1rGZYGEIn4rvSNdG8oI1SfN60+yyvQ2iVPRg4jkHi3UUo+XwyUe9?=
 =?us-ascii?Q?dfGcXqEJPjDSaQJ4oUuiXydQsuC13ZS6/H9Jiu0puC2y1tolqTzrXN0NG118?=
 =?us-ascii?Q?spc4leEL/08ib371NtlSMexSgAvij5Uarcb77hCA9+aB2rwqWhDLXM0scqtD?=
 =?us-ascii?Q?SF0/cal8FTBSLZXs4IXiW5ZA0Ijcs8J/Ensglj5HVzJ/O6EWAJSxqBqkAJwI?=
 =?us-ascii?Q?S+Cxonq2nXs/lkeqN5SZb/TCviwY1g6fuZLSXFlPJysJG4k5fmNlsWv+wUhm?=
 =?us-ascii?Q?BVEdXGK3sOkS1UQ4OdW1/sWLp02s31vTlcFHU3bf9VUv93bMeu16e+6nK/Tw?=
 =?us-ascii?Q?/RInTzK9Si6RSyayuxshOyCP+LMNoJc7e9xZiD7sh13/bs1eSYD6p4aMRiv4?=
 =?us-ascii?Q?mPg5zxCpxYK6GDeMCLtw+rWkqyQriifQAKxeTodUvR73uGasd6HQtBk4pWIX?=
 =?us-ascii?Q?huH/dHgqFyFEvht80bEmXa0ZsvEJO99b7LeNfJJBXIO7SrZxCtaGZTByaQCL?=
 =?us-ascii?Q?wgJAg2jLvpjlI1Is2ajzNYXLy+4IEmXr0kPkvnay3A4JfupcC4Rv7TADocKB?=
 =?us-ascii?Q?Jcx20hR5GJQmV0LrZYwBrrowOFUnk+vnRFQNJGkjMelR4J6+yFFZUhopdDln?=
 =?us-ascii?Q?OTmOnys8+wPWsXb3kItHqyluK42LhNa822pYhjHgUWE3cUF3IjLN+X1sKisI?=
 =?us-ascii?Q?BPe2yqQensBszl+9YakESdH+Peee4ty1b/RvlJDnfWNW2Hk/iBKOpyC+V3pE?=
 =?us-ascii?Q?syYsc/gVmas2ZJKdMh+KSWUJhncqxt76GDyP04M1dZ/0bYcAdVtWRt0Sl+3o?=
 =?us-ascii?Q?5NU+VSHZWJGZmGoerHE4vUL2FwmJG2W1IQcrx54GT/sVqAquwOgbaM1ehj1J?=
 =?us-ascii?Q?tzm8NSxNC+BwKPA3Sia4GEuIDA8i+bCgoFPdhMn//Ri55PHhbaT4DF+nrdtQ?=
 =?us-ascii?Q?MXyUBE+eqO5jVHnGpgjyyxMpo+tm8dCT6BGJd3sMXPvHfUc/ndQCdgV+7Ihb?=
 =?us-ascii?Q?ejqKdpDM5R6GF0g1RBgYwYyfCeRXkjlH6DUqs5XBHRsqB4A4qDaZQNdi2M1h?=
 =?us-ascii?Q?YTcS6savP1bIs641Altv06Fu2NCUojPuiKXNDe/SMC3yBSvo4vu8AIKxPwCU?=
 =?us-ascii?Q?nZj6HN/RGKTeEjY4pREYQIkarRFTYaOT9En3ysf3zmR/WD7xyNnX3NlZSd+i?=
 =?us-ascii?Q?z7NU0lTyPmogGs1WgOjsCXR/1mCT+1e2K0vK1HFe/AiEYk9GYwA7NynxgZNF?=
 =?us-ascii?Q?dxoV9KztREVPPpS7OwvI3/pRmqlQO0Hz3x9zTq8ndBfGLnCqNyz1HaMPHzTx?=
 =?us-ascii?Q?IRelFrUp7RAtnbaps7EmPxLiax/YlwUFkJ4X9jhtw38SiSpyJE4N9IXCHf4A?=
 =?us-ascii?Q?7C4m3xBo7KCWvJhBfvNlm1n2MaPQMqjgYgSqwimu2LrqzyUKDvcprvxN6jHN?=
 =?us-ascii?Q?OweRSOdEBsPCy56T56xlYCFnqdMBN0Cz4bqhqnH6qhwlTnmpRdx6C7m8K3+g?=
 =?us-ascii?Q?AgOvPaKbLKK8abjvl9+QlL2phT8AdYjoQfxIYIh2lEjweeILBI9kgBvkIERR?=
 =?us-ascii?Q?SH7hqU24MWFlcS8a72lPK/tHktA0HQAKtiPHE8d01rayjfXN094eYdI1YLmo?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c1uqzA+yb6RoAxyTMPhCBkk3Q47ZDBGoxX7XFpvq7wCpLuvlTolPKCu+EsDS9Yvq8nt3YEyWotMkRfaiOD+siBY587hSLIzDsNMhBp6zIYey/GXBaodyUUMjUQvX5fUZsaYPJ47w+UAOK8THfUrK+J2Lp1m/2a1gaj16buif4XClDLlqQ/l9kdWExbDUE9HkhQ/sv6yXgxx74G+GeX6223xP9+XdLiJWa8V8AXqhKVv4uWx3Dp4h/8zHf4uK9LbBTfbWTiDnU1yC2HGoU6APhU+Aa0WeBImKBCCNQYKf7sMNCAUlXF2BQmIgD7Zpg7iAgebrycZh3SgWxHwiLRptNf1J3NRAbtnWT9bUXLy7TEANw2n0pP38mJ8aHREOHeuA7ONKCGApQGxVHsPFgtPxkv5wXGc4Udm4Bs4yquiOOSZoNMHzk1WcNpDLzNldEM2rmmGnJj+xpk37pKN9rvjEEUxU69dSt4W4K1zgDd002uhZdmY0ccqT/UnSTxGY2dWYTFKdWsc5wNLCxuBJDnHHa1OL9mlTsSM8JdKauN8li0XfGpGCnOFgGN8AbBS0yTorwCFi95qiF82F4/eS5qh8fP5h5rSRBZQmt+BUJSfZvWg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a7e4a7-5c89-44ae-7470-08dd2b5a348d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:20:58.6454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: guz4ZLQW4JgbVUh7N02xE0y5uTMWd/xjOXcWCpvjF2VBALp+vcUJ85tmzRh0AMzx7OFtVHEicg7uKitUnUJk6C8aAFlt+LS60tAlrKqMK0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7510
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=685 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020161
X-Proofpoint-ORIG-GUID: C8lg8-l3ZkLG1opyg_KQ3rTYWKH3T9Nl
X-Proofpoint-GUID: C8lg8-l3ZkLG1opyg_KQ3rTYWKH3T9Nl


> iscsi_create_session() last use was removed in 2008 by commit
> 756135215ec7 ("[SCSI] iscsi: remove session and host binding in
> libiscsi")

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
