Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ED33D4123;
	Fri,  3 Jul 2026 10:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074814; cv=fail; b=sZt2K01Cmqh6OQxK/FmE42bGqyAFb4O1AAr/6BoO8iSEOEMmH1Z+3MNKSVcSWSZ4X7r6AeRHzcQVd3GXtKEJINJhkphmzWz7FL6aXoKdmZzvqm6ptaHdn3PptLX8WmPErzk/WifTDk+bKwPA8KzA7jFlNkdSO48YT02v4AGR0Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074814; c=relaxed/simple;
	bh=OYU/aP+yY8/hDDfn2H4fwpYHRHCgJQnTKoPcvl0486w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NPiR/uLVg2GFNv8rCXNQXxfZrsGnYlbI4lSeJAvraAmEROELqyXMMcHdhsvd/JOvxqW8zVz9RITBKM+adD3kfaGOwzT/zsHfA0lIQ+L4iUSv7zmyMggqdqWjI1PYdOHY4YK1lpZFEh+WWaUREBX6RlbVM7TXDRzk856kkaaH6zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IzI+dpGD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rpTUWIh3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IzI+dpGD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rpTUWIh3"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638ttQm3080961;
	Fri, 3 Jul 2026 10:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HfqYQOpcaZsGdxFR6AnR3a2m+23mpG0nEnyKC5LjilY=; b=
	IzI+dpGDCalpMRtV+/hL9Z/IlB2pFKFajjWBM0uXyxx4rFNCdXp/WnCuWaZDS1C5
	GHlEnjFvMS6kbQgKyutH30feB2eZfm/o+6QdFH1u/VDUykS76CGclaWQXjKetuhC
	acfNERwdHmr4XNP6ZvTNzCMljf6rDSuJCwIlzC9rOyaHUEULW5Ffd/bISJerXKXR
	1XPu6IL+kpR7ZldEdB+PzigK6fqUAeay5l94Dr64PdF9p39ccSya4BiHgn++wMs6
	Es0hGcnsKYRKEEcaH/zN3FuBlUBkB8UhdzYL5cQUGDsOnlx3O6Vm4O1SUdqXlkwH
	m1pAcfKwQcIGcROilsXNdA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26jqahhg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXBrc022590;
	Fri, 3 Jul 2026 10:33:16 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010012.outbound.protection.outlook.com [52.101.61.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yj6058-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:33:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLxhGkBshz/SbtLKG5xZpcqBWhOvzK21YzMvI05wVRVQC/v+BoBphl7J+0GJZvLPYXfVVYq+UnisajRo8Tb0ytdvbMAsJGbmTjD5DNMDgzxi/XFZzovamOw4zS+QOoknXNUrL1HG7gjaYPRFgnkdE/2/qUYzCfv2Ax/Dy8Q+UtndGcQavCetFmWpbcJkTX3BSX08wr/99B0CwGHEzRElk6tC3HhBAzw5dCZeoNvN/69NVTdOdQdS5nKillbwb5Up1Wd9UuBtKeOvhkLrfpt089oS+ygHle0lmFyfXYEdvFD9uaUhvc+3vBB8/bVXVQZkHEuyNdRX2yTWN7c+8C9nlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfqYQOpcaZsGdxFR6AnR3a2m+23mpG0nEnyKC5LjilY=;
 b=FpcZMWH3afpuzVNJ/EUGB+uL1AcxvsTVJBjUiYxpyMmyXnFTJstiFQ+ohKiHXoXhlSi1djJ0B+g3fD8U50nOfOoVtv3LuwrdSmGjoxEu6QLpVPKDIE6p3CLbS3W6xlmyVtaXo32IXZndkd2AQCb9XjoV+8dI9LTKmt9nldzmLOQkz6uPBoVkfTgwDjnmJ2WN51cwYbWqIlJIOLsibeS98MHLW+HEVhGtE1GnjMU4nkJgqYaEf19zfuCTNS3Sjbw6XNXJ+K1f5UhyUrkxED97Ogyv64tzFWMLfiw9jGHjsEgB86FsRRwyYNHe9liZHcmg0xi9bPNXu9Eq4FTR2BpvjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfqYQOpcaZsGdxFR6AnR3a2m+23mpG0nEnyKC5LjilY=;
 b=rpTUWIh3XpVth0x2OYg8j75QPRIy7a08fJIRKKMQJ6MmM4t11tOU70oxgMop6N7u1OcoBf1bg0KgNSgQG+L9cKfQWzuCgW8Q8g+4ng0CQbT8Lsaven37v3hFzb5Z0qYXqqYQFWp/Vtypsn1/4X8UxO0qqqpQMZCklddfZpgRHdA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:25 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 07/10] nvme-multipath: add nvme_mpath_synchronize()
Date: Fri,  3 Jul 2026 10:32:01 +0000
Message-ID: <20260703103204.3724406-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:8:44a::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 62f4a6cc-fb56-4a1e-088e-08ded8ee5f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	773vBjRJiUHUk6SRRJ06Q5rn5XHlA2Ke3D30A8Tq+WeIdlBy/hhkAbBQUHlgE+MoozWeWeKY7DSVMm9x/0s6veds3VesXYL5iR/02Rd8f2jED8fnTz48p3LovDj6PhE1WUsE9lGG4CmCla81RpTeD2gsakVbGTw/KZ1PArYL3QXbTTWnTd6ySgtgZ2Bw38ijTBbPvukY2zbPmH8IBFfrOOax8nkpt62i7O0NtZitmI0X6R7njvba6rBrwaeDZow92DCfuz8WtIegsZDMIDnjTlReOcn8HlHuxBnCOwjQTURpKuBxnkUVzhrEe8QTjQdbZS0NeSfpfdBZ4jfyGtjWQBBE8G0hnIdCWVfDHru9JygjOZiu0ssStSxSl/dm8yRmNxP4Pc6GNjf0e67F52h3sTcgfOJJIMRpV9Tqh9odgYjRd9dl5mVXioPmk3WJ46xntyO7mmuvYKeTneToODMVFRL/ktgIoT8DkOprMV0YaAVXQOH8WQDTaTLfQH9o8zV2/Y/L1uBb0AwQR1Y66H9oqRKNihKXdUeZZREaerh2aay2hb2IlpwG9sRiYok9PVFJcxGsf/5K6huN3mLAzSGmbXkunEmdGA3TamahHD9SPFgmvhr4B0yl8w0h6tSaYOxn9dVk45h9mIU2QBPWG3eQgI1u0fWqv+ZTR/hImAM4t6I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M3b/CRzjiINcpkcsIOD2L7kOcYJNRIeJv9YlCSKE/cKhgvWZA60lfrIqpjZJ?=
 =?us-ascii?Q?FhfcCtiHrII3QOlKHu19IlnwAU/fHc/PCRaev2VaC8wVc3TLW6PachaEp7AW?=
 =?us-ascii?Q?ttipR83ItwNJr0drBrTqjnxGFC7YYkpGz009cRx+Y1ei7t5dP4khBiimEwsK?=
 =?us-ascii?Q?dDvEMPaMiAaAtF2YZ/ORwJZLbo7IDtjWd0wRWdzClFCEqzmcrcG/50kJgkm4?=
 =?us-ascii?Q?9A3YR60zLEU4qBJQZEDejJarzwA8k/bQx00s6i2CJ0LOMNByjkKF1MdpPcOV?=
 =?us-ascii?Q?x9YijAJMO1CtQ8fOUzF1aGS+umbBpeNar7uErWl82mI+nFixtlHVvmDvthOT?=
 =?us-ascii?Q?8B2NNqQuiqpgdUZ52kcrOVbBV5fO4vayDOTsl5j4FGeOnaojK3oApqMlUT9h?=
 =?us-ascii?Q?vpggU7NRb+RlXGvosMeT1zlBtZBu9m6YDX1D/eNj6raSHEewl5sd8054DQIu?=
 =?us-ascii?Q?yB+nFPPBPYOfjehvfETVbWf9rKnHx36tBALxfXWe96gMUCTIn/Tz2TU8o3Ve?=
 =?us-ascii?Q?4lNQpTXh2K0FQPG2hH4wlwxfH7Xb2pBU0fypsdMKlx/elSz74owOmkk6zjwg?=
 =?us-ascii?Q?lZxK2t/ZlzekdfnNNatregJMO0OMBhXy1wSCz314x2sjdYZHGzEKOQr3BZq9?=
 =?us-ascii?Q?SIo4jJzG3DuBM7DHSUJxCIDFy34771mbDy+BB6tA5LKHNlFMv81fHpWijEN0?=
 =?us-ascii?Q?ra0pGwdsopxInktsvno5yMI4tz+nOh7O7aTVfgeC9zF287IW66BUTnDf5MSf?=
 =?us-ascii?Q?norP+cB3FF2JoCibZ3reC8t0tLdPyRtnXcGEI9v/Z0CECQO12ZUeIgV3zTKi?=
 =?us-ascii?Q?fTInmLDEAid6Lmsn2cVY9OMfUnxE6eM7g2+Pkh5p3L7o4KFU5KqT5EYhRfJo?=
 =?us-ascii?Q?+pX8EnTSqz+nbkpV8g0SqJIiK2ASHbDzB76Av2mdLJKXSOxdAqm2ABPeb8m5?=
 =?us-ascii?Q?nnBa4swMzGLxjBQlWFLIMGnpZlFTCK6nbmnMalYKZQI6LoGV/cfGnaURBUp/?=
 =?us-ascii?Q?aVoEmafWE7kaLGra8gxiOwrfvnG+McM7oST2hw7HJhStMy7E5Uql8+SZwmot?=
 =?us-ascii?Q?tTqh9Z4ByEkBBU8yUqcwUgzONylKakFyxC0VoNKo13r68+akwZVg63hG6P5x?=
 =?us-ascii?Q?giN4KKWVGZyWOnd/4P5vs1IWVhrqjkxv4/ls6jh8rWncXiiBoQMTYR5rfW85?=
 =?us-ascii?Q?UDTLBMZ/XEarKxLnaZNZfqtez3tXu2NYCTJmabf3sHWoS6tm+UJyauP2Ydtv?=
 =?us-ascii?Q?Fwenc0Yn3ru+2BhcDOMBEw0Vp2/ycvtGzKT2WjC4fkUypBS3vAFk/mBVUTDB?=
 =?us-ascii?Q?+GE3Wzu7GgfkKciBxMhnXN4QewDAKCr7WCJYmXCZa2a29Q3g1fxZdpCBwCuw?=
 =?us-ascii?Q?xsoUuaHzapbbp76Ffq6lsqlOskdy9apiUfxzPf9YDD7Qo0zBeJMSJdQsrfM4?=
 =?us-ascii?Q?HS7T8g4Zz+3UVBAoSoLIIdRcUoe7fvjqXqpNTAutad4BoT0Udn9uX6IBkCah?=
 =?us-ascii?Q?5pthWFo6vWOwVDkl9uoxTySDkHgSFgxPvsGW2LRuiDsZmWNkTmMV9uCfMtsu?=
 =?us-ascii?Q?oBPAJCpkODO/XJ0SfWtnaUxSSPnEcQwX0pHUDnuaGAeqNx0mT3efAShJejhM?=
 =?us-ascii?Q?/hdnYnEyY5Pp9pZUg2A9N0+AMBlIDeiCKxrS4vzUbLfCmTa4W8C3mSxOFNWX?=
 =?us-ascii?Q?ZfzburL+G9GuXnANQnCeTT6SjVg6RCiTVARSz2mMGCb8WMF5QWf/NBPfe1bq?=
 =?us-ascii?Q?7TMd3e0ohl/rufY/GMcYatLgRP0rlnQ=3D?=
X-Exchange-RoutingPolicyChecked:
	IoAVCzAJ2BDMFtNh/6xw3f3S/XILgrVxrZ2IL5GYZ8taOomPBKEspIQvlEnSGmxw1YmfsSTNrL8WZu4rk7NtwGREHdwRJH/m3FreUYilegJNzex9RDXgtJ2EbL7kShCXoqtp3iTdsnGt/6bsjSaAyDYNSsWWfp2W+KkTlW82HcJbwlT9X7b3ycX4judkZPk2snpG5j4jABbMs4OWdPqVmKRsYiRjeiF0DmUrtQyIBwHcIFxIAxo1u6H4cdNRATZQ2fo0JPbnmBgFIEQ1RStGeXXzNGFNkLNx95SMKr/4gKArVf2ILxcVkUmlPSK3ETwJg7v5Z46LerI2Fk3ewuGTtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cOpp8Uuw9cxiW+KJYgV5QZIH+9KBWNqqDDTt3oO8Me4m6XONRJB4lmPAonK8QrXskiqhbDi/VFymJYhWFyWk2S03EIePodVKalA8pvG2zNVhPu5en7u7rThQAexqfNWzzk83wJe3zLmNMFZPQs/88l5UaP8I8jIhGq4tmw3cYXuHnCRELKVETTENP2u6sB6RmB9VaKXMtJOotP6dNSUXCNI3UOoCgeN72PRFM+ixiVV5xQBGxKdlFrO1lLcsmDzdjJxmNgmySJWDwLTnk3RpTIbOi+NiFirFtJJdcbVtL1Aumdkv0oji2j+xspRJxkJ7PcspCVkCzotMKfwPJpjqC4bfl1a1T4FhNTbprFSUCh0fb7346tbNd1beEq/IvPCQ3NpWEuSlLeGqksFZKuYaOWJBMk0fR2iMfPIlUI1Oqrivoo8E15sP5mEOWEhkUjPx0q26+HZEG+JRSvTE71G6gUekJnBiEcJ8wJkT1VuWy5dfeRm6UhfgUdMcYofATBp1Q56Z5Rd3yjVssoHImSh7oM03OufXOKnTNJ1elGPwEIHuX0lH0k8pAZeFETm+nHxXcb2dGMkoWwbZCV79g+C+AkFvqaVn17LhjyUVsyXQDps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f4a6cc-fb56-4a1e-088e-08ded8ee5f1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:24.4932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeJCWkf6/RhtlJjxbI5WKGpvkqhsoUOzN5PrDDDuzLu/8Ca7RPWfh8U+4rTyq2irDNOK8F2Ys5a4iJzskegyZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-ORIG-GUID: zpWCGZTY70FmkisosXwuleZGojau9_Fx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX/Fdt0lhA6YgG
 gq+YPbF1IQA0xUG/Hm2a2oKtClG2x5/gxrALIVUIb64rFzJft/m2+rHyVX3t0gkUtKfge35bEcx
 grRMHgJsxp1U1+jG0l7QW+COliimoVoqHPTDWFGwdE0lh96qgMWmuyM0zbRGYIleajAlP/k+eJR
 BtlkH4ofG7KWKy9NdpIiByqM6bFJJXPPZvO9x3ToYFn3xkdKuu9TQa4ETKBwa3l15g0RUbfJaVz
 5z7NwaUrV0KweDwsub74S0BHwOIrjhIiuT/JSMd/ro2OL59AZNb+t8qlC/m0BBqV42Yc1VLSZRy
 O0jvEmKsXnl59GVRndt0yqLeIa9UpH6UYUB9Py2CoEfV9aEIqe7w26C6v/JPheZuU9URyJWiAXO
 mgOhnZAbbbF+6Ew4yLDjnEhdHBB2mW6PCaFFSITjoWzPRVRcJe7fGGkxSU8TJDpyekUgmm+ytKp
 OSSAjQ7KbzEZJq371Mg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX/VK/QLZhkFmP
 SR+UpEFeFD/ae4zBE487hmHu6B0Vtm4iMWaQoZ2hNvrdgRdQ8T4w4K2dLVGxXtcy+B6WcKr2PWf
 wlvHwHnfuHyX+ETRNWu+W55GNWyhtsfx41Hmv9loSFfKEDUKimX/
X-Proofpoint-GUID: zpWCGZTY70FmkisosXwuleZGojau9_Fx
X-Authority-Analysis: v=2.4 cv=XrbK/1F9 c=1 sm=1 tr=0 ts=6a478fed cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=Aed8ZSgTGLsvUS2N6I8A:9

Add a wrapper which calls into mpath_synchronize.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/nvme.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 35618285caf89..292526c9dda29 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1078,6 +1078,11 @@ void nvme_mpath_ioctl_begin(struct mpath_device *mpath_device,
 			unsigned int cmd, void **opaque);
 void nvme_mpath_ioctl_finish(void *opaque);
 
+static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
+{
+	mpath_synchronize(&head->mpath_head);
+}
+
 static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -1113,6 +1118,9 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 {
 	return false;
 }
+static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
+{
+}
 static inline void nvme_failover_req(struct request *req)
 {
 }
-- 
2.43.7

