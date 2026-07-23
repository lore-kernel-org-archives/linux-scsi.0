Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12333B5E01;
	Thu, 23 Jul 2026 10:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804139; cv=fail; b=fbibvtGJ7MOy32EfkABc3IhXt1qd7pkQLkCl+zpY3tWq6Y33PGNc9AvetwUUPsNdGQo5i0O5vGnmYwSjN3jdUyu9r5FIlRSPk14XLgMCBsaC6NuofHGJYmNPM8ihUdycSWBoxxLp/IyFiy9ac8PQr1gmaa8sv13TUkBeJplXN/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804139; c=relaxed/simple;
	bh=/z0hKCp5ENIh1PO9dKFr7J9ho6ldEXngLyHUsDtfCiU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SLktTDRsnV/D0d/MLldPVxf3VC4Qtgva9WdueErYQquMswN6cc273SKZk/h94xqfNf1rV19sOC5NGBr4pmqf0JBsHkLViNLeQsoPSU5mHzjRyFlrP554MQbIw0Tze/mmAhovTU5f9bMYzwSXB44yx0TZDEjae8cbuescAb/avDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A8gPWG+C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mi1ckDi5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A8gPWG+C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mi1ckDi5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtZ313360304;
	Thu, 23 Jul 2026 10:55:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XcAtvOeyMHy5xoF+xVn0yQIr+c73GGX07o6mN30MjW8=; b=
	A8gPWG+CnvmdhGY8jfbTe3WvhhHktp0XhsJ9TVUBdr+mCP1zhpWsbT9iKBM4J04i
	nMxOsgQd+YD6WdtDL8TpRLccrEgRaMzokC+oDjr4xQyyX09pex53pk5gc/IyBAnd
	p7SUoqszrkqoI2FplnjbEGHiWcTF6dlGwa3WgB90Z9uKqOFdzxKVgm5Zmqn/mrz3
	rxdiD5Ou+rUaK9Cv/bd2CZEhgRR4UqC9zwFuGSMzNjSIazJwX7j8ZiBElY/oVum4
	bpezp7yxH/Jby4OM+BzTqwXzoBG8dMCpH/rnnB/hWdFyzTw7rxmqdmg0mYlAR3ij
	yKr6nnqDdIt4w6rkmzeN9g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6qbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:55:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NArZqG037092;
	Thu, 23 Jul 2026 10:55:35 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013005.outbound.protection.outlook.com [40.93.201.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs7tu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:55:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DN3tKy7U3PxbEHKKfwlSlljpjXDu1J9Iqe7XvBovfr0LVEqsGcVaNG2t7MVawHfFGpa9KPx92NkERRkQg/5kH0LiSVPEB3zYoW/R07xd8coFemuOXEslnb4oOudFkXCJx6/fIJIIUCJwSaacQ0ycJMmba2QzV3LETgWsAFnfGeW4ec2j2EPQfoS9NmS5MCFl5yOKs11uyobN73bbb3PGXoaEFGFB3MBsH1WJ2FbIoa0rvjp8G0jAwX7dCDHvf0SqCCrbD4XHZs4p7AEqKzRT2lfRHgR7KahV3wUBk6cr3S7nHcuYWT9gsoJsORboSgkOEXQYk50/dztbHi0GLsmALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XcAtvOeyMHy5xoF+xVn0yQIr+c73GGX07o6mN30MjW8=;
 b=fN5s7Ltgh1d12AiOuVc1YRBHA+xHs08SFFKfe0E5i6jPhOKB0pCRAwMyml3IlER3Rs7glIc46ymn2nY2A1yBgH22UzpsdmbCB0BglmsyhTmq1Z9SlSQCC+s/ACF41ncGVKs199MUcdH/YwAlE56vySTT9fmkMHqZoCYm7qYrJm9/dkLnfZ1zxUAFgVOXFoYJ+EI8MLCWzQ0QiW3/yIq0ckZuPjJA3dfrMLlj9ejvdJT4eDXaEoimVYAmo8nVOwzy7oFF8EjTp+KyheC3j+hH44ou3BMVngiiOJ06DHUQFccKWieZLN+I2DqBPyEz5NVMJeVDsNdokAG5G/x6c6XS3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcAtvOeyMHy5xoF+xVn0yQIr+c73GGX07o6mN30MjW8=;
 b=Mi1ckDi5YDM3/8eHxqNVkT6sLj0KEl1sSqJ7ycjgaLs1jn2IfnqiB2VfANIlaNACvxTqI1CA8mjXtuks1R7UfXxcevc7Tm07YMudtwT7WNrU9Sn14iWHQp1+RX8+UZACcfjDEfwRe4fhhF2fVgSjXmFkwWHpz111KjIPfyeCnEU=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by IA1PR10MB7486.namprd10.prod.outlook.com (2603:10b6:208:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:55:32 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:55:32 +0000
Message-ID: <91a3ec38-0aa8-4d5a-8063-3373559e1985@oracle.com>
Date: Thu, 23 Jul 2026 11:55:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/28] scsi-multipath: clone each bio
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-17-john.g.garry@oracle.com>
 <20260723102717.30BAC1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723102717.30BAC1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0427.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|IA1PR10MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: 288deed6-7f21-4559-dcba-08dee8a8ea0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|4143699003|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YZ9agU/WfhanTtxfQnMbfVm7IHK+l46mlnjbobJEJKQpY8B0btv25HMSIbwpwHchb+GAKQlmEMXMrrUy97b3O6GcUvEfHZLFCuoNpt6757T5CNHDdUY/Sk2sUjRPoviwfC26m1Uu3OfG66TPmSEhs4709+CJCnIOkNj5QhyygfSEjvLh8jGkufccqm0DkNdgz7OX1s+VLmreSMOeEa2hoyZvtmOOM1siLY5UTZYfDTbwh/53S+Jq4uNRdbKzREA7WfLNH1NrtXckeaShbL2zxS871r+WV/HCYyXkW6tNmyxU33qUnJC323Y8C1SA2uU2VTUaZJnTm6yofguZFTcdNZ0/bcxOk74yZNoKxp5IuRKw/hIVV0LoFz0pmZLTH7jnat37qtAW5fGVXpbSV1wrY8MmB4Knm8i41P/TDc/BYQJjcFRsq4YpMBCXZGWl4fAnZgEjRQAxqUVGYAJD2GdqlEnanFvyy1kIDXc3tuOnIMlLVA/dTnBngl2OhqN6nGtRNDdE1w3Y/N/UxXbvfdFJwX/xecb1YNTm1RKmZGIpfaWmTmyugrWo8Ra0ExSKMr620BGScyksuM9foGcf7JhaqS6kJJ/NKmrMZukMP1k+B6i2GIw9oyC/p6H5AhMfb2BoLSLBTDusqN4G/vA5g7aU9/+FPQ781iTy93i2xI82bgQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(4143699003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RER6TEVIY25IeG1NdUJWakRZV0RKb0VpTkE0NStSYS93Y2VHR09Ia0plbGlK?=
 =?utf-8?B?VDI4MVRBK0QyaVFKNjA5SU8xTUozUmFqb2d5SDVlb25tRWlObTV6ZDZIaXpJ?=
 =?utf-8?B?WEpXbEF6WGdBOXdNM3lvcGx2NHZiL0lVMWF0RWNpK0xIdW1KRzNSQWJORmhV?=
 =?utf-8?B?MTl3d0Z3OC9GL0o3Q3BQUTJNOE52SU1lbHRmOVZNWFRaVlI1c25MMnVxclBD?=
 =?utf-8?B?OC9CWlVNdEdQNnBoR0NhYTQ3eEdJeFNJeFBicU12MXdrN0FBSDh3NFBheVF0?=
 =?utf-8?B?RlRUc2lXRlk0cFV2TzVLVFE5blRxbktybGxkalVsOHZlVlJHbmpBbWhDVWND?=
 =?utf-8?B?cWpCU3FiTE9HN0RLcUx3OWpTeVRrNzdZZkYveU1aNHNFWnVrSmNhSENkTDU0?=
 =?utf-8?B?QTRyVVV6WHl6eDk3SzluZHB0cFUyb1VLdWVOZkR2OGtBdStzc25qN0JKUUFU?=
 =?utf-8?B?cEZ4RnVWQUpmU3QxUFhONWNKNlV6RWdDalZZQ2xhU1NIZkFvYisyREdnaytI?=
 =?utf-8?B?azNBNDh0bkYrejVnSmV0UFB1VkxJb0xwWXFBT1RWd2Rqc0M4bllzK0gvYS9n?=
 =?utf-8?B?ZGlmWUZVTVJKalFUbnpyMXVQYkxodW9DMDkzMmozZThsUEI0ck4zUkJ6TjJw?=
 =?utf-8?B?dDlxcWxUWElobUoxbTROczJDaFJRSE14ZGVKRjEwbFZXT3dlNE8wd1RQTWVm?=
 =?utf-8?B?VWxkZk1JL29oTDR4cWVRWmc3MDhDSWNXUzZvM3RzMUU0VUhQUUtNaTFJeU5t?=
 =?utf-8?B?VHBHZi9RSmd2SGdjaWd2UFNWRWVyMzduWWpyN2pMWWJPVVByWTBlb1lSNldV?=
 =?utf-8?B?NmxrdW1BdkRZWXpVR1JwYzU3MEVwUit2V1I3VzZJL3ZWM001OVFTMFRVaU1v?=
 =?utf-8?B?UDZCYng3ZlI1VklDMDc4ekdZdUJTK1I5MjI4SzBNRW1FdWYrSkJPajNyTkt2?=
 =?utf-8?B?ZTJMQUlhc05Oa0dqZWR5a0dOU1ZVOXVOcURZTnlQT2FaNC9sYzFtVGJydCsz?=
 =?utf-8?B?S2RSTGdQbk5WY2pjUHNyckdpSVdVdzBHNWlZaFV3YVlrR0MxQXNRb2FJMWt6?=
 =?utf-8?B?L1ViU3hEaEh0eURheHM0SEd0RWVrNDIrdnN3TDRnT2N2cDBTRTNEL3NTT1Bu?=
 =?utf-8?B?T0Qzdi8ySnJNcGpIWGxvVkJjZTdxVmltKyswMUdXQ1hJSjdGeU95bEo5REN3?=
 =?utf-8?B?bFllMDdRc3B1QlcwcGlJOWlqaHdGeS9YODIwWnlrdXh2cEo3OUZIWU1vRVY1?=
 =?utf-8?B?d1Fvak8rcXZpcUhxK3JVNWF5KzV4di9jcU9XNEh0cS9aRVNMSGpEQTlESmE0?=
 =?utf-8?B?TEJMaTZHUlZSd1c0cUZLZ2tETEdOamp3blNvVUFiTk5LSlBhazVTUlU2eWdE?=
 =?utf-8?B?R05wenRNTDVsdFJpTFRGQ0hITEcxc0tTeGV5TXZ0MW5kV3V5eWFnNzNEZzBv?=
 =?utf-8?B?VjBuZ0xsRGlxMHA3eHd0NFdQNXNBLzl2TlRDcEhjcDFValJMY2NnaDFraTV6?=
 =?utf-8?B?SmNCWkgzVTBZNHRzei8zRWF0cURGekFoa3Q2amxZb1NKTGUvMEM4S05yYnJW?=
 =?utf-8?B?K3NvWTlaUERxVXljdWFTNDBQSHprTDVFUzRidzNmM2MrS1l0ZXBONk9nRlg5?=
 =?utf-8?B?T2J5STY1R1Y2VysrNVFNUEVSUzU4TW1QT3FMcjhKLzhPYnFhYjIxS3gwb3Uw?=
 =?utf-8?B?Q2RYdHQ2TnhudXpaN1EvQ0x4RXppUjBUaWpIaXBRWnpGVUZiRTNaMnFEM21J?=
 =?utf-8?B?aFV6UUpMUHYrN3JCaWo1NGI5VVR5M2owT3FETmtBby9wY2h2NzdMQVJmOWhI?=
 =?utf-8?B?cDVqS0FnWWY5YkFrNmtRV2NVYzBQRGFvVldHQ2k1ajRkanpNUFlQV0diczFJ?=
 =?utf-8?B?OExTejJtb3IyYU0wcmJhcWNWcWdRWTRMY3U1Tk14SkxhU3ZIeVRUZnVTOUpD?=
 =?utf-8?B?NGFpNzB3YXN6N0ZPVmZzL1h3SUkyazJiVGVFTU82a1pGTWVOKzk3cS9JOE1I?=
 =?utf-8?B?T2hwR3FVcDNFMWpBOGMyVTVrTzYxREZYYWtBODdZdlZGcnJ3QTlNMU4ySFFW?=
 =?utf-8?B?MXk2K1pwUXlRY1BxUHpCNFVodythcFhVNUpZdWJCcTlCK2Fza2tnOUI0LzJ5?=
 =?utf-8?B?aUl0RzB2WkNFVGVkQ0Z2N3FubWFXK1FONU92T1dpaVdQU2o1T0MyUmNjVkRL?=
 =?utf-8?B?MkUrcFFuanh0NGRRZUNkZ1liUzJHRDVOS1k0bnNIR1VoY1YvaVFOZU5PVzIr?=
 =?utf-8?B?ZlB1SXdzTHVUVTVzenVCcTZUajFkenN0SFBHN2Rack1NRlFzUFZoOTdmMUJi?=
 =?utf-8?B?VStreHhrQ2hVRjRjUDFNZTU0ZVRVSXQ2WUxvb1Z1M1ZicHIwNkxWakhJYmZE?=
 =?utf-8?Q?9RXmhWMjK1zFi/FE=3D?=
X-Exchange-RoutingPolicyChecked:
	g/Fs7Uy2xtUdbG0KpKai+/JmxK1ralCBDtN+uNofNpTTDkuhJZJI82pc78eX1e5hlxnuxKSqeLtock5zkJNVMJFlOdpcDnMwwrTv5Kg/VJCM1/SlcaXwUoFqI3RDyIbYUP9Bpz2X5QmP/DCOlNcsJ6bClJQscMtuDNAdiseNGued1HQLAaj/gEVh8+OAENXLFnu68ULeruH2QCLMqx95n748H6Gw0agqqvL1o/Ge/F9xNM5TOO8p2Ut9HD8EigtfoZlkC0lgsT8+HFtJxHabXMF0ORFfMpIKborgfM1wZ/FnZNX1xz6sISv3M4UkkgPwzBmYx/Z5XFCHRQsDKcCoDw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YUU9RlmFfV2DDFWzdyR1E5x92vbblBMYIprsub/JfX2O905V28yfFBGfLMbvRYmn3+T4jOzWC/w+KsUUcftGhPonQsWweixGosk3Lrmea7BXc3R6Qs4i1rSZrxutpFzs3CO7/pyR6cBOC2cw6U0bW5bzTSEYok6uX9Gmy2bBcjBGLaZcHgF7KC0NIRgfgvUjIuw6u4vXHo7W98ZFsESY7q/280SJFIFsRhcRgta2GT6XNzaUEofoYVhGo+vKpoEZah3+VL+mgnqEHEYembMvlwwZS18NMdOo6YYIkP2pBEAGAQxvmOOcPFibP+B2yWK7rMRy7b272oJs2f3Fc3MNhiJBUtL9shNsw65AZOaI7Y4c0azK6ggBq9TEYGaU5e7b095ZfPQdzB5ge08/DrbkO4tF6z0AuPyLzSU1QncgGVQJLt4byAY+5TMHy+vitoEowEtMm8GG9MaZ5BJoxKSOFiqb57azT92U8umQbrn0Mh2YkZeHwuE3ewwaDlhzrHH2hhceMwUJEccSLDkFJOZ93+LY/Y6WrnJZnsTsrMKMg1KOxFKRA9tz3jCSZGUfNuTX8TmJGgZ2kD+sYVd9gIGa4OhCSBd826U6r7s8aK41APc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288deed6-7f21-4559-dcba-08dee8a8ea0b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:55:32.0795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/ENbd3Rs4W/C15aBNjJAk+KZwVK27gNcpwYs+V9Q+GpdQQTmGNIwLISf0uu7Rf0+ctN5ww1mFkep9lDLbSeXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNyBTYWx0ZWRfX55Ic4oenQqcJ
 6ZmmD+Thq38MLvNzWvQaW4XIO5rqBFzina31MZEs+W90nPCyoH8RDWhHNUl0KvLyUkajh0eT592
 mhXkan9ekP/tuVLudy+Qmb8qFPc0I+Du+EaSSClPCcW5nGHtaGao9TbIdHlQd2cGSU0Hxh5/Q2s
 68p6OuezHAq0oF2370rkxs8GtBtPFt6/ATirA2sVDhqwm9J1RnTLX6MzrSpnd0PyWuBxA9FG1XR
 PylNTNZ019lVud0s2NUZmbGylfahIN/rGkEQr3bFvptrfeIufo6m0k5gQmXVQ3Fdr97COLqgGXk
 0fIZhWHseFUtdWJzzzBA/onIl9IfCwM4Kb/nQyKgz/yOrrFoKzkrTuHDVmqaymti8dEH34TzUMa
 czGLCnS39BfN9h+aqdqA6Z7Bb04gMtKib9tOB3PULCw84yC8S34RDzEvJ9oMgIE79J9QH1wPNUb
 1IRfFzEIGDdpnXss+rmTrBql2Xs4XE6xZoXOevJI=
X-Proofpoint-GUID: izouJhmUUXEEV0apkemzJ5Yy58PDqNt1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNyBTYWx0ZWRfX4VACcQX3H7zm
 Az/50UzCNbmphwC1r7e7dyjE1a1FqPh4VzNnBCLhH/fRlwUZBZS9/VyQ1dyGdQQP2LSRMFziGcX
 7ZjOQPSACvBajZEVD96nVna/eVT4Kdg4nEZulQAdsgrjwo+sbsv7
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61f328 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=BVOJYAlpiqRsy4K-ciIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: izouJhmUUXEEV0apkemzJ5Yy58PDqNt1

On 23/07/2026 11:27, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] NULL pointer dereference due to missing mandatory template callbacks
> - [High] Missing failover handling in clone completion
> - [High] Bio allocation deadlock due to missing BIOSET_NEED_RESCUER
> - [Medium] Memory leak due to missing ida_destroy()
> --
> 
> --- Patch [16]: [PATCH v4 16/28] scsi-multipath: clone each bio ---
> commit a74e2254f4409451e96518ce4d539e122559fac1
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clone each bio
>      
> For failover handling, we will take the approach to resubmit each
> bio.
> 
> However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
> is either all or none completed.
> 
> As such, for SCSI, for failover handling we will take the approach to
> just re-submit the original bio. For this, clone and submit each bio.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 6228ff4be4ff7..9a4b35c597778 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -97,6 +97,7 @@ static void scsi_mpath_head_release(struct device *dev)
>>   		container_of(dev, struct scsi_mpath_head, dev);
>>   	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>>   
>> +	bioset_exit(&scsi_mpath_head->bio_pool);
>>   	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>>   	mpath_head_uninit(mpath_head);
>>   	kfree(scsi_mpath_head);
> 
> [Severity: Medium]
> Will this leak memory if the embedded IDA isn't destroyed?
> 
> Even though empty IDAs free their bitmaps, the XArray API contract requires
> calling ida_destroy() or xa_destroy() to ensure all internally allocated
> memory is fully released. Can we add a call to
> ida_destroy(&scsi_mpath_head->ida) before freeing the structure?

will fix

> 
> [ ... ]
>> @@ -229,7 +230,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static void scsi_mpath_clone_end_io(struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	master_bio->bi_status = clone->bi_status;
>> +	bio_put(clone);
>> +	bio_endio(master_bio);
>> +}
> 
> [Severity: High]
> Does this skip all multipath failover logic on error?
> 
> When an underlying SCSI path fails, the error status is unconditionally
> propagated to the master bio and completed. Should this be checking
> blk_path_error() and requeueing the master bio to the requeue_list for a
> retry on an alternate path instead?

we do it later

> 
> [ ... ]
>> +static struct mpath_head_template smpdt = {
>> +	.clone_bio = scsi_mpath_clone_bio,
>>   };
> 
> [Severity: Critical]
> Will this trigger a NULL pointer dereference?
> 
> The template omits the .is_disabled, .is_optimized, .available_path, and
> .remove_head callbacks. The libmultipath core does not check if these are
> NULL before calling them. For example, submitting any bio to the device
> triggers __mpath_find_path() which calls:

check later patches

> 
> lib/multipath.c:mpath_path_is_disabled() {
>      return mpath_head->mpdt->is_disabled(mpath_device);
> }
> 
> Should these mandatory callbacks be implemented in the template?
> 
>>   
>>   static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>> @@ -252,6 +280,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>>   	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
>>   	if (scsi_mpath_head->index < 0)
>>   		goto out_uninit_head;
>> +	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
>> +			0, BIOSET_PERCPU_CACHE))
> 
> [Severity: High]
> Could this cause a system deadlock?
> 
> The bioset is initialized without the BIOSET_NEED_RESCUER flag. Later,
> scsi_mpath_clone_bio() allocates from this pool via bio_alloc_clone(). Since
> this allocation occurs inside submit_bio_noacct(), an exhausted mempool will
> block waiting for completions.
> 
> Without BIOSET_NEED_RESCUER, the block layer's deadlock avoidance cannot
> intervene. Should BIOSET_NEED_RESCUER be added to the flags here?

will check it

> 
>> +		goto out_ida_free;
>>   	kref_init(&scsi_mpath_head->ref);
>>   
>>   	device_initialize(&scsi_mpath_head->dev);
> 

