Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9216CD33;
	Sat, 23 May 2026 01:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779498819; cv=fail; b=JhEIxWbCfjtRGqhs6ezupltV8hX/94FU59RExcIyS21tsuFM33W0NEpYHsuS1j9z4KbvCshtEfrPDWDcyziwMLexVTPs4vY6ehOMhqu/RRxPWxwCFr+1nnn9wbIu2hZ7jANBMxI7qE2kp7CsIuCP4ac8glhPp5zbJG8BoBdFNoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779498819; c=relaxed/simple;
	bh=yU1G+7GQPqO63kaecEgBScHCmf4drZtq6sNl2q6UGrI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DmiHMdgOROy0WTHjSbr5cgd3KFEhnCUaWGJwRUs/dyMkiY2WDnwKHIyp9wcf8Fun2twd4Lft+rRghmgHg15Ak8tNw/ockzFu4URB2l30D/GFz4RsnqidTSnjO6fQnM6e0TgEjhs1kQLOMVvpRuEG3xIP2YGGSO+p//lcpTCWe6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ftiztSxQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Om3O7Y5x; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ftiztSxQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Om3O7Y5x"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N0k80t1582878;
	Sat, 23 May 2026 01:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4gkFSAi2DcCiJZ1b1r
	BZff2+l13JOlDzw7EXOi+6XiM=; b=ftiztSxQgmhdPJZz6fGIGfkjhKZXNRSoUQ
	HcUEnGgwU1MKdG5GEtgri0bvbMNTnZ2+g7QOYfOeztIU3dCqPevoQNO7zrM26tIA
	2Cly7n5m9zfQORaMPgU2CVyesemtPn92D5aP5+oOr5Ct41mBT4Im2Y90wxKaD/xy
	AVbb0qJdN3/IDCOc3qA9Phq6jGASwdS45n8ud5/ZRKr8XTvhQwhnCdmfXF4o6gXG
	9ju2KCG3vFUrWdwqb37jCyX/B5mDXysn7tq8NnUCzVfI/iH5c/0dQFeEkSJpu51u
	2I0yTKopuIGBYB/QqN1oOHda2mufKQqZ74xxTNZHxwTox66FkYSA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h4qc40p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:13:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N19kIU010323;
	Sat, 23 May 2026 01:13:26 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4eau1udubu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:13:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MyTteZbkiukOv8RjEUDTERArU4w4ZkS9bXF9ouMn5Vn7ywTyXvMX0RJVtj8xzIe4IvqS4+DB0hApemdGhOas/cnqUutbB731eqheRS19XYvsnUTgY6xiY1BrcSQr2/E58M894/kKynhZwvDiO0rDzWbYrBzC0mvI8kHA7rBwMbTwNd686hFSrZsmL54+ifoityvGgn4qHlSUlwd22hY/Yu7xs50hE9igF93cVMTwHc7xgYn0d2ESuFx1q1HaP3c+nWV5pJ4v1UCYDQes76bfrrUF5KNmvS8iULjZMVEddkuV38TCpRd8YEEsWuI2+pKXDUBVn4hcUdOH0hNjjtu5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gkFSAi2DcCiJZ1b1rBZff2+l13JOlDzw7EXOi+6XiM=;
 b=caXWPUrPjJFS3b4UgtzNF7JTUHkXCmFu4jOu7rlRrdmUOmNoXNZtYB1PCtHSPprq+ut7gDHp38hwou9TQBp4azj5QKpPF+FrBinYpq/m0ll773cnSjKhyymWVo8A0Kt45nnX1uLhQg6oAQzT19QccobY9R9mDH74W+qa49bAtakETAQziT8FcUePpj7Mzcfr/ZHQpXb518kI1NrQvNfbsjApTDnlv/5LKZp9+YYRAfZUrLKIaPc7jz6m7HLElXSjX5St9wiXM+dvs+nR4Fjx3rEE/vI6trFpepi3JWEoChYkxfIZICpA1n8NZr1GBqQFWo/RieYvusdctun6RZbeQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gkFSAi2DcCiJZ1b1rBZff2+l13JOlDzw7EXOi+6XiM=;
 b=Om3O7Y5xeSPkqKxKc3wTGizAlMsuyHp8tdxDQIHRgIosBsxTzzLV0kwhCNl407sC+xi6VsFvGFlf0KS/Ew2xCS4Lh5bhJsjyAW41PXj0Do8G+XPlBqIUghOvwjghY7kEnaxT54yJw7rlOnLEeJPT7gSp67VUxv/VD+o4zR01/Hw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB7668.namprd10.prod.outlook.com (2603:10b6:208:492::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 01:13:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 01:13:23 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: scsi_ioctl: use strnlen in scsi_ioctl_get_pci
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260517171546.2304-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Sun, 17 May 2026 19:15:47 +0200")
Organization: Oracle Corporation
Message-ID: <yq1mrxrnd1x.fsf@ca-mkp.ca.oracle.com>
References: <20260517171546.2304-2-thorsten.blum@linux.dev>
Date: Fri, 22 May 2026 21:13:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0098.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: c32d71e8-7584-46a0-e7f6-08deb8687be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vfgVOnNP8F15w7mIRyScj2yx3zRjTWb+uSgHAGBS46u3uoHRup64/6m/7v7FPMGcT37/xDivS6HisOwWYV6JyI8F3OPb9wjiYeL4YHIeLejc6jxxIjKrkJTtXD+H6z5tXCKFtNPi0gpf1YDJzm1J+VAm2gxkb8NqlL9C0VTVugm5TUkFD8MkQJ6DFoFJ6xeZMKbkueM1+AZutRyF+0e+2r93Hmv1H8kk2MtNGCYagrqJZmcg3VMjLKJAY7kkE/W0FWaV3tuCGSs3wGdbsl6oz1qi7Q8ZTSZf0Wh6QkwGIdObCOLwJVKUAba+e10JWM2FgAhzhfkdVbKtWIZD3sgX4+3qgs83TjKlcH3nccLd45iZJwRJ5pgHhOk2teL3YhPF/N7dsjMHH+nKtkSmVXUHhHvubq/8Wt6PKv6gRb7Ar/hQh+hJI8fYx1FsUjo9XvUWvCbjBJvP9T73gWT4Dht9sN/4wyCRJlLRQuzlxPY9xeReOSUQCRiVFYQCMRKqR1RrV3g1mY5s0Khwyftlfv6ims5HwRuiOgxr0XXRFpeQvbxs0+lnLthopXtTVsj2h+K2c/IgZMEkeQUGNnLTOD+WKV6f7uWXdGVcUNVn7lz+tNWoiXc7JmnWSfDGyRk7V4YwpCP2lyhqRb4uSxD9UN9SJpuAMjQl2CXsI+DDRlMk/Ov0s6h7cR7BvSSMidUOsyOs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ldVro6nPYRhy0I+XeEk3tQI4jM0jr7sOUqwc+NfZs/mIxmhRDohQnG4UTT2O?=
 =?us-ascii?Q?So/GRQpHkVVUCCPdWyNqRWjsNRejLwAyPadh3f6qYnTLspifSe2/F9cLx1S7?=
 =?us-ascii?Q?OTkk6xjsE1rqa+hWPEaziLY8G85qpIqB9abWor2SZ70ETEY7qdmIH2HRi0pO?=
 =?us-ascii?Q?uQSx1VYnCEuVZu1ZH5i3jCz1ZeU1uY90T7Obeg23TSKyPr0QVutg9yLJsKP4?=
 =?us-ascii?Q?TXYwB1gfzb1bq1rPWMWyovdTvdj2A3HSvl4/pgrjJjBTTOL+I2pZ6ugikkiI?=
 =?us-ascii?Q?f50MB4EprxFsVd5aZEhjhsBiKBKRSOBT3G9+qvgvbsoNSJOppRMluK5c+G6n?=
 =?us-ascii?Q?/lMYBDdJJlV72p90pkC7loxaWezBiWW61lfgURhRPlDnJtT0TFpk/M45khk+?=
 =?us-ascii?Q?WZjty+Tr3UmEGu5pd1CrOb8s+PDmtqRCDKLXcpn4zl2ReYY+1kJ0UAAwVIjS?=
 =?us-ascii?Q?OiNxwcQrXz5QTByJ6t/1xKAiMyUP9F5TzMHMjS+HYRWpWpNWzS/Yu+iOha7j?=
 =?us-ascii?Q?Di9RrmaxqMJAMJSdqVJT9BaYFMdfFiFluK5AHcFtSpF068wFab4FG7DhTeKB?=
 =?us-ascii?Q?vRVJTeSPWn3lVk8j0C4CISC57PvPLv0fuS1Jw1uygAn2KXRivGJtl7dfGAPQ?=
 =?us-ascii?Q?R1qHQYjWUJIoAKEi5lfRbo2+hbCAvo6ffVBw6S9l05OAsDVMzFCHSYEGvyCw?=
 =?us-ascii?Q?UeOUxspRGbXnlPfazk0AVUs4XjdvhqHbK24O4JCj6FCeR9rPwyTw1JlK/x3N?=
 =?us-ascii?Q?w6rYyUDEFkqWD/9mJj5PHuKMzWg1SUwdhwjOzcHhZowsvwp9MTYNjb5ewbdW?=
 =?us-ascii?Q?NuQtYs9LwCx5wGGoeLCq/VzqPrLigCDLXeYcJlPGNPtxuOe7wuCbMeyLSqF7?=
 =?us-ascii?Q?5FOO9M9xaYVwV50u23MdTji0g025RcPDWeYkq3MCjD8Q9FVE3qW3r2l4DTVo?=
 =?us-ascii?Q?c1bAzWO1jf5TnwfrgKfNwd1o5+JOjLOrTH0/Yf9GEDy1uay2fuO1H9L91r5g?=
 =?us-ascii?Q?whh2l8F1cBNJOHNsuM+ziZbQvJPOg1RdXKrVzpFIioarxE6aYAmfVSDh8r1Y?=
 =?us-ascii?Q?Iy4tTLEmAy7T0qrUGJcuSJorvullUfC2tRqcRMD6zivT/ECqLEcuo8AHn1c7?=
 =?us-ascii?Q?EWe8eUJQZvpYzjWqLmo9Y5vjqUgBAXK1iu3d9t/cygeAQw0WMiHfGC0cLhEY?=
 =?us-ascii?Q?q7KQBxsL15FbscvXQoPCoAh7xImIgrgXAo09Jr6lZ1qdf4Fk2HL+OUeIMNVf?=
 =?us-ascii?Q?mcyjNtyXVdn1rNV6wKOSdMe2enHis/ckQEyn7jTDEJYTM9Th+JD+Pxe9e3z/?=
 =?us-ascii?Q?IBSqJpwmaoGqbBY/HG94YmxRUoESWuefQUie3N91LiqQnbIFo9ge/hOtqXFW?=
 =?us-ascii?Q?zeHkC/e3SdI5Z9u95JB/9KiBMY3106cuZ7b+8odt4CZ84qKe7DOIA3phmT1d?=
 =?us-ascii?Q?ET1eDR/BkSsNVLGePs+Gh7LVWPF0u/qEFOqxXRlk36B3eszKILbfVKEZ5B6J?=
 =?us-ascii?Q?OKo+6qIXq44JxVBFeSOHYLpCJ0Y9/NyeRbpQpYknK/lM4f7u7QZA6XZYVYA9?=
 =?us-ascii?Q?s1skr0hMr9d2x4U4zuDtzn3zA0jET+MwpZKp2yIaJ/V98cxsAEMRjSQLO/UI?=
 =?us-ascii?Q?zD259/WHTep5OeMSZvlHx9DLwN6L6Wz7SS+witLSHoigEI/EWwozB/cn3vKt?=
 =?us-ascii?Q?0hu51NUuXJX7b1p5TdmBp8PPdUVtHcQu2QNz3FYVR3KNccHH0yQpGs/lcRQ+?=
 =?us-ascii?Q?AO0PXQC7APR0OBwH0HM8AYRQ1GJ4qr4=3D?=
X-Exchange-RoutingPolicyChecked:
	AkBShXKonp/4QlG/AlxlRo9vGZNUdDZDktEr0ITU880U3j6nZOkysGElbGi9ko3IDyyW7DchkrioD8S1V5F5UXGq0wjExAXXgQiCnFUaoF/9pyzUnxqV/8+KfAzKDKKh8jFVFAMfdA1HCj8b4FP33oolKZ2a3O7lB/U0HCQaycSynEmsN7LGtfI1D7KsL35uwfl2xAjG+6O8ztbHsWf+N3+VCcFd38V7JpYoz4qaKx6gXm+waXbRp5ZhTlxefJenAvro4c1akSxnKceDYNqB0EXLWAHseeEGmr/qiJCZwN0+XjV5Jq/D4A1tIwOE9nteNzn7urhjnDLgEOnrk9BPpA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ej4z76oHcHJx/LJV57Pl+/cYpEkljCUBCTqrcvJC3sBbJULUmiwE+Ix1GudUbOX8FYqcVBWHmLA5dkJv3bo6geSyqiAeS4VRm/OkNLzPBj7VR6eK33bV3Gg77EBCBD1lPKlF8FFhInX395uLZWMCYcfTXYCE1o1Cn4vWNPzP8CEtD5u45aSmnrgB8Gc5DFI/GvOQQIee0alZa9Pn8kHhq2VKvnENL3Y3SZKJLaX2hr5ocphFYL73OySlfWL6BaN1h3+t20+tcVI0REPojnINjmssydpBoAuxGuSM/5uUDN2c+UGTOoS+3buY/xOPZB7qUX9tnDT6S28X5Xj4sGMkaX17Xz+2dD/pZQ3F4z6WylmlYNkyNWB6s5NTzDPG2fhMA6kKvj0TATi1ZMPpLudoO6XafxxUEtC0xz2jT+rlzint9zWeKl8P0DlwJVTGKG8SLmRGPIr1hvytl9YHeSxwc+SW5Up0l/yASvZjBuYZPljbSM8oJ98b5K+JJjHk6SxTDAyQXeujkMVChp6ZMEzH46nFKpPNN3OK5D7q1d4SJzESJ3doRkgerJHaXjAsUwEQCH5mXxYi0dezcWV8CvJdB0SKJvyGdb2kmDA07BNjMJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c32d71e8-7584-46a0-e7f6-08deb8687be1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 01:13:22.9274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmjlfNnec9P/31Q93FCRO5uBCHpRs5uDly5Sd2X64cDh4icUztFRWRd9zcmWmakZiWK21/J1hNY/tHbQgJpVq8xfd8UAdxmkqfeKq5ExQzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_06,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=847
 spamscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230008
X-Authority-Analysis: v=2.4 cv=NdnWEWD4 c=1 sm=1 tr=0 ts=6a10ff37 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=UbfZsb7zY6hhTfayIt8A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13835
X-Proofpoint-GUID: 6FdjYaGQDlq1s8RraQivOC7Fg7diyy3P
X-Proofpoint-ORIG-GUID: 6FdjYaGQDlq1s8RraQivOC7Fg7diyy3P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAwOSBTYWx0ZWRfX5KJ7TMUqRrR1
 NNoABQ7pgAddLTgTEsbH2mRoPbImG6aas+PEWcSLBEqflsI3E3ZXJseXDwPoH6MsQGLcDBH9Ls/
 IXLrGsY3A1iCL8KrCCmRADz+wW/xQszY+EZ1iOLxsTR936okKJ7WYB1xs78LRF49GmgzsXZQC5S
 i/36IideVBlsk4PDjXmhbbMz+GHDoXz6OjkmkwXJf22V5YxGiPVYsLx8oUjZglKjE72+O7aEUt+
 fRyTayVuaQCq0ASqj4YnXo6Pa7VVLxWniCR0DVW+hidIMQwWsY9IY2dr/y2slnALVgb7f0n3aVM
 zLmFT5Sh7HK54ngLVCzLUd5Rt0nh8lm7rcPChEPZY5keqX+T7uLP1fNY3iwsQtFukhp3moyXuRx
 nVEf2PZ7UFNvRorvrxN/bb+ES8KFxeaOWrmB2lqGy5TmwH+gk0fGZ7keSJAtGCH6s9eT80AogC4
 /ZnLZPdfhiG3ZjBNLj65BJNMtQST5BYJd/MQ6rpY=


Thorsten,

> Use strnlen() to limit string scanning to 20 characters.
>
> Reformat the code and use tabs instead of spaces while at it.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
