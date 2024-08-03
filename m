Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ACC5227;
	Sat,  3 Aug 2024 01:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722648533; cv=fail; b=EfY0vO/f06twz1mRBF4aft2rjKh9fteJWzJjOGs80xSy0lXENeCOXcytgYtfCvEa90infPf6bF9U2PhMN/6oQyuoISsYe1gj2mZEtdVNnyfM1IZZRoWRGb0GaJCjctuxHO4rD9Uud12hJavQ5dcGtvBsL9D1/RSvSZmtHCH3wms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722648533; c=relaxed/simple;
	bh=/hQl6pKcpcuRMQBpRt47dgp4lZU+wZZqN40oSwmI+dc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=EQ4yVsSlc9CaLcQNuB8fQWnv1knQf4kf0VzQCB5eIu6h06d0QRvZHvRTrPeXAGHeUHfat95VfBFDNb23tfGUMpXBFZBo5SITGA5HNqBVkWcg0hIw+Wfb0guiIGv+imqziKLZznDnJz8ki9SPgsVsG8+5Fw3nxtvIB+IHk3IOwuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iVBKuXMI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M8InBmIi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iVBKuXMI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M8InBmIi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtYwJ022338;
	Sat, 3 Aug 2024 01:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=RTbQOVkww3hJHA
	91AlelO0nQegVlbz261QPnIeJNQ8w=; b=iVBKuXMIUi8uH0/HPmjgEUeEaSH2PG
	6sXtc2U7V4Y1B/Kc9DWE5S3mKn+VP6/t/X6kpGzWKK3tMteTSlttDQuOOtUEr7bc
	RihPAm1wx4El7JkTg818ZQ/a7u8p2VgWzWZe0CDiedecMbusvfUl9FUTVso3eMWW
	EaasWJxk80z1hvMuzoIvZJM7JL/f2/0+IsKR4bavLFHQwuykgmxh3r0F/XjOu6fK
	LZ4PKvyKi8NUzWLH2fwRojPFW6tDafUkJVQlGJA/90nZd/ri3ioLzlYykNDJipmz
	eeXvh8hqjEOc/zDBd2FYIhz1ZDmLYcz6AIlnvuNooDD/qhLmAAlAv2vA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjdwje0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:28:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 472MITp2002519;
	Sat, 3 Aug 2024 01:28:43 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40p4c4wb33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:28:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZAKgI4DzzSv+yOg1lJwWYvArTFWS0KfMLhZ5HflhNtjgUAqGnsyq0VNFpI4CAxAwA4KH0jQPM9BijZIocmS+xmmGygUzQccM5QjQu/wd2+Wn6O7PvjEY5AOF43yqLCfhypStXURXM2KI6NCvbLXFVz5iqPJ2m2ZHtRln76B7zAV2NZhJaI6y+MKdmKy6EcTGc870bxvYfY1s2StMx9rN27eUFkwoMkLWLzhTAeL9ZqSqpKj+MSWOgBNoHEGu2lFKB0FTB6oMQ05FhQuG7j7jR643dWmosdEbkKbKheaSjOgGs91b4uEZYGIjmuGfUIQalcIVr/Kw/HT8FSczzW68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTbQOVkww3hJHA91AlelO0nQegVlbz261QPnIeJNQ8w=;
 b=YCMEeOCgYfQcSyjRXN70hUXkHjyvNikRQ/pjbfKjZtGaiVLrDFOXCSs4LCtFmrARbpFdPL5Ssi/hOtxUknk800/7AHSpGxC9ItMwfrCZfSGu+OIYC1hUowx6UdkKmQW6yQVzYNy+PX7Ja3m4wGX+EJQaS1S8b2O3QeejdVIVFOgt8/H1j7t5bJ5WxpRzGmfl2jzzH4h6NCXIepj5dMMfxcqpudUGhufdDSPdYEwEKFWo12n6be0a8u/V5mEImsXPlTOmSPSSF7jF079lfDx38FB+lQULe00682e+fZ3ABupxOIor3TQL6IByxNCcHa/3w2CGe021+yf8aVZcZGSSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTbQOVkww3hJHA91AlelO0nQegVlbz261QPnIeJNQ8w=;
 b=M8InBmIinOrUTNvAHBfxRW5jx0tn5lLDLps8TP9vhrHihH13HQJbW1dchSKCaMQ0geeiiTCaErRfw/uKCDXV/ggcg/JbFBODiPX+lTJpQvM1F5/BCSCJoXL5wXXlxf5mCN0jyJTw+ARd3Jrd9t+Ru/RKi76aqpQrPncUPwjeLB8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:28:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:28:40 +0000
To: Kees Cook <kees@kernel.org>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Gustavo A. R.
 Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: aacraid: union aac_init: Replace 1-element array
 with flexible array
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711174815.work.689-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 10:48:23 -0700")
Organization: Oracle Corporation
Message-ID: <yq1plqq75tt.fsf@ca-mkp.ca.oracle.com>
References: <20240711174815.work.689-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:28:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 408debb1-01b2-446c-de74-08dcb35b9b2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FTySwAdB1J7aeKPzULbEzLShgaXQS8DWxKB5ozmp1U1/SyJXNz8EPUN3QFsQ?=
 =?us-ascii?Q?dryzmhdDFOIy1sisA2d6Y5ZWENS1/35EnL43JoJytLdhwd1muSGuXoPaYC73?=
 =?us-ascii?Q?1qJSJdN+wHpEvbn2Lb04MRUHZw2gT02Pcayw5n7t23wq5Puw3MJUxHN1ANWa?=
 =?us-ascii?Q?nSncOlufuE0QmO1RL4GKLPKS7QyhGUXBI80ef0GS2mPg1ISXsrsQZ4I5syMr?=
 =?us-ascii?Q?YcgXj/EPBBo7MnngS6kisMXQGpprrw7f1IOWsBQXjz/VZJStpsogBY7z12YK?=
 =?us-ascii?Q?lVqKjhaUnpAFDPFMKQzfzaEs688ydPv9ji9TzA8Nc4Niq/GXKSH3r+y2LTfL?=
 =?us-ascii?Q?PZzW8I8QqGjwCmUxPc+6o6gqLrAjdMxziKcU8CuufLpc8cvn3cYPb85FoXqn?=
 =?us-ascii?Q?B0mALIGlLcg/ObTfkQWZyLvbU9EbZUydZRLkjIlrvD7JvcsYl70K8xDchFFB?=
 =?us-ascii?Q?mer51OX7wtJ3EwqLNuKp2FEaDmwXXGa2XX+AcyfXfrSImFlZ/C6QzwjsPZiZ?=
 =?us-ascii?Q?KV+OAKPpt94wgLdXEmcF2b1jYab2ce/3U2xW86Ksjp3gbWIKN719DkwB0aw6?=
 =?us-ascii?Q?P3HihsMqQKbrKtpAuPoH/Nkfik24bqVDzrsgwejAVKACMrLpt1a5/PXMTCFb?=
 =?us-ascii?Q?Wal0i6kJoqcRTKyVeLidhE+opETofQvJLhD4NYX6pE1BZEu4jPbyDWT0LWXE?=
 =?us-ascii?Q?95IzfVCM3+Ct4VMTtiEWe16xBpeglOgviJy2oCfa8aL4nChlnOj9L/BPidsh?=
 =?us-ascii?Q?0zv453nklBUfIwV+te3Mq7LO8Kv79QNejr2Ds4GhWL6MPRGwQyuaAu5rLLzL?=
 =?us-ascii?Q?61UxX4VJeaZPRQBHf5q8xpFnnkMm7jASZRluLtZsCIFr0BehNgBRHsSaau0i?=
 =?us-ascii?Q?YwsME4L1nz83Ka13ZiuMqN/bWiKicXH9GkMGM54rwNzGUAT4TfZaz6fc6Yhg?=
 =?us-ascii?Q?zBYYOujZRkHpsb7BWSGwC3jI2M2nu6U+GjPxnl+put9fuyFyx0WyHqtr+cdV?=
 =?us-ascii?Q?BvNEpqpVkpoQXkGvYmTMvlbW3pL9JIl+opkYcdqzGll6SBPMEJJTI275xgOZ?=
 =?us-ascii?Q?W+8ygcTa48HIMdqBi8JCIk2P70HHAlZNkGgcf4lu04nzXJ/9u6+NNYuQc82L?=
 =?us-ascii?Q?N7dHYsNIZ3vEh76LXw87u+Auvn7yQZr/GPcHQ6cx5mX7HJPaEvZ2mbBYLA58?=
 =?us-ascii?Q?v8YPEpe60x761nI3TmYln/j7Ocmof1ohk7we55GVFUOg8YIku6dbgd2XDKPF?=
 =?us-ascii?Q?U0Zvk6ZRjxou/toMe3DRpeT9ioGrkbjfNaq9+NqeLY9y6E+sLjVYFtjvthoG?=
 =?us-ascii?Q?c4pML1Ah2qo224E2hC42aNCgfhrI+zyn897aVwVgB7uzeA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Tg+4T+lbzdVyIDMXG4l5ZoXQilojLxOQTJNzq8IfWPWP6zXFO02wGWsGjPp?=
 =?us-ascii?Q?HTmJfa0drZils9WhgyVmhH6My7WqQxuR3+8tM6+lEGmumizYdBzvI/j7DgMj?=
 =?us-ascii?Q?W6sIXSKxqKGqY8P/Ik4jeXTv7J4FTko71KCHB1sXtMYaS2jBO+SyTEiwbWaS?=
 =?us-ascii?Q?VHOuw5euZziGrz8PkEHOLiEMUYgwUIq/jJKdbp23BKyc3e6GZBduEhSbHXA6?=
 =?us-ascii?Q?rn3jwd8uN5HUH8aqcgg+h9rI6NnQWdDVM0v4HJ5+djc2N8qF4XdrYGYmMB+g?=
 =?us-ascii?Q?qA7oYO+Ur6qFv2ZbFiDVDzi6MvONG0dPeu9o5Tl3mkwi7HQmAPrdo7AEQcph?=
 =?us-ascii?Q?VSUiVnwSYcS6dSiW7VBXsIplP0pJz6FDlV2n1gi6X6DG1Yr74sECHNT6CcAp?=
 =?us-ascii?Q?Ypah50+RyeOzcFTASmjSVEKIFKz68ZGIWM9kfPigEcMYdxlFR/6m/1uXjrTy?=
 =?us-ascii?Q?CCnxHv6oUOrUExArY6IQCNn47aCL/CYphju6XSDaJFPB62ElPpyU7PaMAukN?=
 =?us-ascii?Q?BmpUj7eVYvi2WyfGu349GEEn+oam2NLnck6u6GRuMUkbPWbxxstu5COIaQ+4?=
 =?us-ascii?Q?GG7TUmyJSqrcMAu8AbzRxl6gQ0YsCocrfYDKyWcHiBXdlmLQZiNxwxKRG8iZ?=
 =?us-ascii?Q?pfocr3XJSeJb29Ddcn5se+dYs8javuFATTFKtNCudhGoki1lXbIUHkFPsDR2?=
 =?us-ascii?Q?H2Ij9Xch9O90aB9sQgZSOftrH5TmM/gJYwBvVcYoyn1c1PzJrm0gQdBig2Fp?=
 =?us-ascii?Q?ZZy3iwVssdE1P9LLjzJu4A6gYIxNgdNmei82OwA5TfgBRDV+516eEsBibQUv?=
 =?us-ascii?Q?PuFcPj/wGV4dYasuFB8MnOMA3Fpb57gU8Pru+OMRAuNXQCcnj3grul6Ss7fL?=
 =?us-ascii?Q?mgSuB3erDLrfENhktox/G38c2gO3TQ1iM0Hw1zdl9CXvNdxv+9V3buu+6ZCL?=
 =?us-ascii?Q?7OKtps4nay+BhtYf5wC/aDhrL34sNAiX8Iy6bI95uJvSsj9r8nMAY7jgZdWq?=
 =?us-ascii?Q?t/OzUUM6dn6bjZx+diGoJjsOua5w3+pDIk5eNEF6zLxiq5niENQjVPkaveQK?=
 =?us-ascii?Q?+/2myxwD2SyTzYwMI1UG1y48g22WHmapWDdEAscaS9XswZsbRleIbA4C293p?=
 =?us-ascii?Q?/4PmfTvn/gI7J3VsHL8gWGAgy25AU59fyJh86HuyhYLuAEueSAOFKirMz492?=
 =?us-ascii?Q?rrDdFQVUg+KcTOJOJ3OwsnqBNGSPYb6H0lJXE0q50VPtc/59h81HRHUf0kdZ?=
 =?us-ascii?Q?tAbxTm4w1H2tjzRdIAPc6kzTohzOVvKo0Kd3L77aKuLofX6JDcATTnGxeMw8?=
 =?us-ascii?Q?XfLwBRXbdagfZga6xxaDrVDFGQLeGgMEoF3ZY8XEcStU83yHyRU+FMA9tx+7?=
 =?us-ascii?Q?YnVezdbFuJQZ2oudLQuNsy68Zsm1qCRoW3GwrXApDXEypUSrYu4z87whsOEP?=
 =?us-ascii?Q?ykcfnt8Uxee0ud8fOGOmh97skq/odFzIFveoj2oC+Pe34VNkYHnmgCXGc5Dz?=
 =?us-ascii?Q?IDweQ5CojCtj9PQdMUtunwCP56NstXIMwbVC7KW841ZqMIv5zSjX6DZmVMuT?=
 =?us-ascii?Q?cW1xqe9k54nzchxxHjo/WCqbwceUiq8o3zg73tufgjXA910sUewBsukAOZ0s?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2esMIRdpyxBHm9KWrcbB7VO58TikCIkWduE0lkmq0rLlAQreIYDcx7cKVOue/nDDnGkq8sFWIP6rKaE85jPSMeAxCpT9u57KXULmyfdnvgmVEbTyy+r9SdQXso6uxGd/dcNkEPcLvr+FZorCvoKeFdnk7BvPIzVQQ9nzURHI+078UurFxAo/SnvGPDXdETjK+87Co4K9kMtlIjDQeUfTcFKF7+n4Xtq2BrT47HrqLQSlLir4IWbZkvclGZhiX3utk+KJjZRYsj0YA5sG4d7lBKSm3tCzWyaUCdVTQiUZXa0VqL0o+F5B28KEWXi2Tqj4UWK+QE+QfCn3YmHY+AOwL3ZqsBnIikK/jNYGq+pj1vHVqt3P17ItacDBhGXoSFAV+uS8wmxW1zMVVMaCoBC4Yaj5+JPwPul12x9tqHqBBM8IMICb9fgqQD/WOQzSl28oHIfTSG9TsrIy3xAcET4uNVYAn8Po1gO8vqSRBrf23ZAZ/a9JFf3a/7rxfn3mwUAHEHevOOJ0ROONZIt6841Z//wCHslQdJicbemR80nuS485uw0aKZLMFUKkgPLZajtleV9rYtJxa5iO0K2PO4I+2vBrD1rTwn3jsnuQCwnETzg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408debb1-01b2-446c-de74-08dcb35b9b2b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:28:40.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZsuqA68oagW3N9w6+sYzwQ/rply62aUjPTWnyYaxJIxkV+JdEpBfw9GUhSxFJ2HTGdF3tQw2QI6xXUGpk53iMz11kavRwzPQa7Usc5/Rtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=624
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408030007
X-Proofpoint-ORIG-GUID: jEyCl7f6ORe-5g8MNSoi3emYNsiJRAzo
X-Proofpoint-GUID: jEyCl7f6ORe-5g8MNSoi3emYNsiJRAzo


Kees,

> Replace the deprecated[1] use of a 1-element array in union aac_init
> with a modern flexible array.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
