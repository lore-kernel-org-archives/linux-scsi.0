Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5913A6B7F;
	Tue,  1 Sep 2026 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259648; cv=fail; b=d+39b6Ili+8NpUj+HHHTmKg5TfZXN4jPI1MVya/wVRGwDcwr24SXJIJe5xxDt1lVmNajKklawMiXXG3Q+wjM9rI0Fe0oe27QemOCgIGqWd/KFr3YegEYfDRLEHV6rI249HlS3w0RqL/DF002VqHTnA8eJ7Jur+G13//+n8nt168=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259648; c=relaxed/simple;
	bh=MGGrufQaSGL2FwUkrQj798UD2jkmU9tA5Vzo3TQkJgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J+wT4h7n1v1nO568Cl+CUymuBI0xr03pUPrXiH0j/0vTGkHvSuF3IKBpb0tXAVeSfuvQfdM5r4NZnFquiBWDerlK2f1f/84k/3fL57HsIrifhSCYTxpcRj85E32RGmqKn/JOP1lLepDmxpIUkLOvjecJqhHMbjTkcSVxbrx50MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QNa5C3RS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rZxAerAQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QNa5C3RS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rZxAerAQ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBou82296182;
	Tue, 1 Sep 2026 10:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rfdl0hAxhFN9NXSE9lI2c+/yAF7yG0Mi6W5owcq80Os=; b=
	QNa5C3RSBadwWRA5TVDtOA8586IzTSu0SM2EMtmJjyJxDaj5xamrREbQBZMY6y4n
	F4lSWBKP8D7ytKR/mzI+2bTuYB7X5tn9s7ex5A4JIGCY2syRm96NYqoeqYkqQzTl
	H6zXhcfQslumlbbkZgBHLS2vh7FrMEUjOd9RZ5sUOXQwSlp/73j2Xs+9XIpfyo55
	sk1a04W7ZsWBoqItutsVooTQr2kf8VuKQl2/z08QXnx5oS9jri95qEy26OalC3Qd
	363Wf2nRXb4dBhtnFAB0RZnTsYNyXIeJfrQhZt6MkYrjCiPrrM801c46lDljZRJy
	tqjPECRh7L7BJIEWGzrVNQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvdas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjYA7036488;
	Tue, 1 Sep 2026 10:46:00 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFks1dEwziiEuqSz6YtCptmI1Y+oYaHCXz7Y7LJIAxgJo09uhrCvnu2Lxe4TgYXGtWKkc+X8Uu63aVxVi8MEj30zoorwiQV6mGBZ3p9Brw2SI6PSyFws+j4UJW8+ZGX8vzQliH7VoxX3VLfRZ1uFILQEMVF0sovSu66P1BNM1ceCUJt0Aytxg0imVHufqhyK8q1VIwGqKOoxMJ7EBPWRgQhlgYSVJyjoXRo7/yvIXewfzL+CTbn+tTj6iWeaEtyKHmNheWwV8TVc2E04GicNsBaHxbh+T08sSMhtad9VaHkPklA0wm9HPChBDo4+YH11ClWalTpYcdm8d2+qCZy4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfdl0hAxhFN9NXSE9lI2c+/yAF7yG0Mi6W5owcq80Os=;
 b=c4rEoYHqXmYlntOVX3o5EGiy0Z4tsTPVxlBbuEN9zQHazbILJFE0v5ChHzJkAMFPQ9Qq4b1r+rOPfGeLg9zRPpgxDsZtVboIy2Ww5IVwVFcnQGoMVLT+dNN3Cm6d6D3iQkxXDCDY/ioUZg7unGJiM2GthWMVsnO+pQ2LYA/FuxmJxRLWeA7X7LCIk/OeXxVpAGTJfb4nNx6MfaeKcob4VfM1aqT5Fhzfx29iOa3TV6RvCkK8UmOaXzROgp5441e7V92NuknaD+IjDpUdkyp8tYc0tjq//+4D/RRKYMrPlNAHJz70zTgU9jQhE03pHjSooF5tjREswmx+wIuxEAT4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfdl0hAxhFN9NXSE9lI2c+/yAF7yG0Mi6W5owcq80Os=;
 b=rZxAerAQVjQzm1Blpa7/PIDefc2n5eTw1KLn84pyjtDHjwWwz53TKtbqyLglbT5YIF5ydXoKTeLSrheI5XSecOqTDoWBqp9pW/oL03N8p5fl190GD0PE18IPfWjCFJ5HpV6obcwLUAYs2mobXqgSWPf+C6icTOkfVNg557nNmug=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 12/27] scsi-multipath: introduce scsi_device head structure
Date: Tue,  1 Sep 2026 10:45:11 +0000
Message-ID: <20260901104526.3850621-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0007.namprd19.prod.outlook.com
 (2603:10b6:610:4d::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: a72c5499-15d1-4dd9-0069-08df08163368
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	oDU7D5Xe0cXxYjtT67Hygx1vi0CBKkTa4BHLVwTLDfC1wgMjtAERmpVkQ+pCj2rE0ThuLo1fNGe861Sia1RtxrfPcG0X19ouVE4fy5dwN+gsCfcz1SoWtlsewR+x8nGzF+9lk14Zv3wt6Tz8x/8aN9WAWzt0fO681h+OBQoDwQ5BIOy+aEGSvhr8rU02PDFURMpZDqFplqgAZr4fT5QnKvsSezkDefHkXTgis214cZccCyF2nhE9N9kumlEiUg02rKPmeE47Vl2yFgdDxTSmV67ADPTeK6hqkv3LnohIFMhYGR60sF2KVCzdbhxCZyJh/IIuBANChqfMxa501U/d6c4bpKphBwvmcwxRdShj5+pSbt5p4J2u3nKYWfnBvTSiy5CsrL3FRKr83kZyBu7M0Qq7ink7LHNK6me6I2c+ejYvBivC02SkZWahR8/+bXjnsg6j7p2ilC5yyM1LZNvfAvNNSjafUtjw1Mk68jdpimflkPy0g/LKC4ZIxAHhfeWGUtVL72ASunbcfdaRHrgMNyojrNIlz0Mlo76DiaJK106Juk4XMXdVjde0wxQjjYJ9Qr6ZSuiWSJ2+c/ysmS07ZOpiqlnBdiDTUM+DHIkNUVrPuu46D9/TF+4y91D+bAE41as/dPvVWdzANKEq5HLrAZMi0IiF5rbSJq4OwPo9Hhw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dEnqGg4R4dK+gzPWjBA3MTwJDimqF5iasio8mT3y5mvBTyYLrZCtFaSf6lcL?=
 =?us-ascii?Q?1cGQc6ZKi+gT4hMwYUI8JzN8coe4h826nH5entcXI/1irpnNYdjjTKPDxE1p?=
 =?us-ascii?Q?NI9vk/o2ken86mz2Y2SFID7u5CPTu8qHa2dX11gRSa1LBRmPXNNFsNEHzZpR?=
 =?us-ascii?Q?goAKmW85dqFr/7BTSE77pv31jvbRWUikDhBm+M7MVOw6GnIbHTITreb6z2YM?=
 =?us-ascii?Q?6VQu+QLlaWpFxPj5xLsIFrLLRd1fXcS9J0BcFt2RolNQ6b39daMwEgL0DsQw?=
 =?us-ascii?Q?8acBMryZqJQ4O7Sw+6ia+YI9YLjssdC+5G1EYfYbGELUrBT8mxtEHvELxaB9?=
 =?us-ascii?Q?qO+1ajpJ1X+cTS082rOw5nNQNcMO7KW1kNQ/0KbXiIAFIFddlujEuMvkqLuq?=
 =?us-ascii?Q?Kaq+ScLV8C5DH58nj2ILVnOJgpAoMvL2LWujkMwlGJGPNaFxSuf8VdRZgQ2d?=
 =?us-ascii?Q?x6MeqA7075LDYWu+mA7WYnZfKAMfa0YPkl7da0ALWhpALMRrWL7edMy0Or/r?=
 =?us-ascii?Q?EQihl1lAifDWxy36dQde5Byldv+CycVUhBZf6FdXoWz4WV38RiA1OKIVyaWQ?=
 =?us-ascii?Q?t6xTKSdSSEsmqSQq3DJ5iUm0T89RjHxYJoAJ2pVSAQOe6SHWv8Xs3/vN7gGc?=
 =?us-ascii?Q?D5AqkhpmjeRC616Wf2Qf7VTkHcjIyh6Nh7tIyQrOBdSsTZTQw4e/MUNfu8vQ?=
 =?us-ascii?Q?oDH3LdWVwHuNJYMV94uXVf/yUtQWeRe4dcGhui9yl/rZi2r+ZezE6h40k0z7?=
 =?us-ascii?Q?i/SBq4HWT+RgNSRzNEnSF4x2dBFDalKAVoULpt3k/3cJTDxdhOtj/J+BhT3y?=
 =?us-ascii?Q?FTGAnEctT7vchu7uYdEwA+zzmCy0fVNHNQ7HcvoKyAQ95/abLt483AkHL9WI?=
 =?us-ascii?Q?ZDoTviHmTaOx7ouqLtWCSNvOalfskKVHNVN/ltWerZY05Q+mywttA+j6E+oP?=
 =?us-ascii?Q?J4Ao1WjctG8/D0HBL9ULGubPrvfNqpCWsI/3TxRFrEO5LioUvAylTqsPMU1D?=
 =?us-ascii?Q?Fh8vl91+epopey7AXj15kWDqmma3InwfIACrO3/YELDzBpAGjj7bQKwdYKkA?=
 =?us-ascii?Q?a4ZFOgTGAllv8+xVnfFmvmFaDGxTk+lnULCQBblMPfAIC0v1IfSV+zyTxVcf?=
 =?us-ascii?Q?PLwgZwA2wU2WrMrxMCH3Q2XlPoWFVXMQplDZf/W3KZt5Nnj8aJfV1mPZrfbf?=
 =?us-ascii?Q?zDBZbRwNrx9urG6UdKbTBH/Eme/CJpkEVf1SdpwjPjqSSDQZZzkUq9TOihg0?=
 =?us-ascii?Q?qn8bsTqsipBPzhVFlbrwv2HIfjkYo+cHimpjeUA+3dCSneibhhV75VeW3dAY?=
 =?us-ascii?Q?O+NJHwC0Tssnl24fKlub7FSHhpFNeDeow8MRDtPQiClgQUhTqvW9oKe6UZah?=
 =?us-ascii?Q?aXhRa2dog5XYQzXWpAn/QSnReTr1OIoXlqzDo8wRZytXo2vD1wWQgMaQFZPq?=
 =?us-ascii?Q?M98JKit/bBoPvl29SESa+NhHyDDWhnZVvF8ORRAk1WvZBjVLAk9ry8w30PaA?=
 =?us-ascii?Q?Ey2IAHVsMrGJXJGfDhZxiu7WoQxZ+mxOJgNX6Nk8+xS2cWTi5aEnJBnUr0VC?=
 =?us-ascii?Q?WS4dqCHVgVZVn93spU1dVZ+519HO6b3wt6fbAslx12yPwgmsfYsmCFOrPJ3h?=
 =?us-ascii?Q?If8D1eqszojE6flnxwaYWJzQDMwwP25CL7bKmQCFZUuq8L6lL0dXsQROBkwv?=
 =?us-ascii?Q?YvlF/hqpWduGvnrOIMZSGlFAAfhoZi6q7b8LNMbki3YzRe7v7zw/VocwtJQY?=
 =?us-ascii?Q?hRs3JiFLmQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	W7rgOB5u4EKDzavxFPo28xGGwKZ5Hf8pWdfTxtbXS949NyDvUZasVry/CBTdZ6YEjMRwT8I9mXQj7DPqi2N/6kUalcj6UPW7P3WDIFdpvplvFrBk5sBnJOm98nqz0Fszs02fzPP5rMrEKmtWk+yZusnLT9cmLMlPv2JZIcaNye/j0pgmJP/Xtz7V7kpiA/21fKCDvlWkWTTCdcbHkbsU/lEWslPhD9eaeIy5wgg2OUfyJQMNM19fDBwYo4VYb3rFRG1eMm7Y5Vob6Im2m7LuyHIQ/soc01VBvPJmiXJM5f/SJ//UEz9j3LJUTQfo1a1/cFnK2XK/RdnXaWTYFK89qw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K16sZH2IlN/HbA7Gw24XhLDCXH9dPLxBVYeJwPmk+keg4d2Qxy7/LORs5RpxB+/WUR4bemE28r36cVrgniuLQlQJc6+fyJijebLKV6KgPTU1y59dAri0GljX/hvEeB6XetCc6MqzUlW4N9jD6fMl2CBZJScQ24QmiKGcngcwdCTVUEVz3v+3oY9JTz3QqkOrFobXOlJHneRVjB0Qxs4xNKwW73y8QrYTH+z/QtA8Kbj8vewqMmzT9U/qBlK4SWrlCQjAbxMlOxtWBTGDd8RexDn34q3kPeHB5MWommrVY9Tf3x5NNo3rs+IvZ6vjJqPBoNJ4VfChhCf/Cd/UOupSjOaPLBURMNoG93mWQhCbWwaGQsPw4yz5r33zJ0lLU9KlP5TT0bYeDlF6HeKyIG4GuvQjLegzY2hTCtZ5AnthvN9Ua9SQT4WmWgmRJIks5/l7uba1hjqi5WgffrAnYxq+5kZH/rKyX9XlHoUSXkmYzOknSPJ9kqIqwnIpRhaa/6OcQlFMpqE31gYr/BulfDKrFov8U3guhgnFCxvhy3jxMABLY9Fh2DdIQJRXajxUz/YksLszUck21lsqxJP/mLwS+6AzSZoCrcROVmfCoqmyU6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72c5499-15d1-4dd9-0069-08df08163368
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:55.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFj31GUNojYu+4MWHmYJZ8acaoeiIJSOfMwpoMp67UACcCy2UWOsUsuDT1rdteP87P4ycDm4cttgzXk9CNfT7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-ORIG-GUID: 2jrcrvEGAvKupgekDu3t5KBbhZAADHkI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX8Vswaj33FB2L
 iDMNJIwdPWQ5imlXP39gwYEtiv7xJpx/LbTkMUl+fdAy7flYP0/iPMmx6xgJrUUsXzwZKY4Vebp
 y7HyWGKt9IdSYJxxK6z4XaTcU6EOBAcziI1ERotigZDjfu6/r3bEskbRWUKNI1EsvzKqz2j0dGw
 stk+TyyWTw6KfMx1P5bX8UgHwHjZKmLEyI9uGLVDGZ/3pO2ruRwmklSsrR/xe4R2I04H2+TV/Ra
 HXHL++Lp9eybGcl/Zx2bDLnSoMt407s/oc0uOmOIWhyZmmvhex5/jF2jOtMhHgvboK8qNgWVdKY
 VXTv6DU/K7hLVvUne9RZkj1YIMuaCGWck/W0PWAYSi+uNM5xZ/XbX7t4dhzNVdKlO/rk0t2KTHy
 xEPD+KeX9jcCbBpji4iK5oP14uxvq3tpXUesJ54QG+m2OlS9R1M2RyHG4kMV0w/Xl33uP5vmmxJ
 DI+kXcuErIrGp6XMCanUfblD37IfNkuYaRv1GV+E=
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96ace9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=rslDvqJ3sq2LG7fXSO4A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: 2jrcrvEGAvKupgekDu3t5KBbhZAADHkI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX/HEuBljDMPfL
 luJ9NixQLBhdb94W1OGQMFyHQbiRjnbWWg2H0f9rYnq+BGin1ifvZoYDnxoA13m8XSO/VqKGwri
 6Fss0Sv+3C/aBphzK/6jExte3r80bGoNxlsjFQ+QZCkAaNQRmsgN

From: John Garry <john.garry@linux.dev>

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
managed by the scsi_disk driver.

A list of scsi_mpath_head structures is managed to lookup for matching
multipathed scsi_device's. Matching is done through the scsi_device
unique id.

A new class for multipathed devices is added, scsi_mpath_device_class.

The purpose of this class is for managing the scsi_mpath_head.dev member.

The naming for the scsi_device structure is in form H:C:I:L,
where H is host, C is channel, I is ID, and L is lun.

However, for a multipathed scsi_device, all the naming members may be
different between member scsi_device's. As such, just use a simple
single-number naming index for each scsi_mpath_head.

The sysfs device folder will have links to the scsi_device's so, it will
be possible to lookup the member scsi_device's.

An example sysfs entry is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
drwxr-xr-x    2 root     root             0 Apr 13 15:48 power
lrwxrwxrwx    1 root     root             0 Apr 13 15:48 subsystem -> ../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Apr 13 15:48 uevent
-r--r--r--    1 root     root          4096 Apr 13 15:48 vpd_id

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 205 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  36 ++++++
 3 files changed, 242 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 5559e2e8d64a8..0fd4347725134 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -29,6 +29,10 @@ static const char *scsi_multipath_modes[] = {
 
 static int scsi_multipath = SCSI_MULTIPATH_OFF;
 
+static LIST_HEAD(scsi_mpath_heads_list);
+static DEFINE_MUTEX(scsi_mpath_heads_lock);
+static DEFINE_IDA(scsi_multipath_dev_ida);
+
 static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
 {
 	int mode;
@@ -72,6 +76,55 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
+	ida_destroy(&scsi_mpath_head->ida);
+	mpath_head_uninit(mpath_head);
+	kfree(scsi_mpath_head);
+}
+
+static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return sysfs_emit(buf, "%s\n", scsi_mpath_head->vpd_id);
+}
+static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
+
+static struct attribute *scsi_mpath_device_attrs[] = {
+	&dev_attr_vpd_id.attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_device_attrs_group = {
+	.attrs = scsi_mpath_device_attrs,
+};
+
+static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	return true;
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+
+static const struct attribute_group *scsi_mpath_device_groups[] = {
+	&scsi_mpath_device_attrs_group,
+	NULL
+};
+
+static const struct class scsi_mpath_device_class = {
+	.name = "scsi_mpath_device",
+	.dev_groups = scsi_mpath_device_groups,
+	.dev_release = scsi_mpath_head_release,
+};
+
 static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -91,6 +144,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+	int ret;
+
+	scsi_mpath_head = kzalloc(sizeof(*scsi_mpath_head), GFP_KERNEL);
+	if (!scsi_mpath_head)
+		return NULL;
+
+	ida_init(&scsi_mpath_head->ida);
+
+	if (mpath_head_init(&scsi_mpath_head->mpath_head))
+		goto out_free;
+	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+
+	strscpy(scsi_mpath_head->vpd_id, vpd_id,
+		SCSI_MPATH_DEVICE_ID_LEN);
+
+	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
+	if (scsi_mpath_head->index < 0)
+		goto out_uninit_head;
+	kref_init(&scsi_mpath_head->ref);
+
+	device_initialize(&scsi_mpath_head->dev);
+	scsi_mpath_head->dev.class = &scsi_mpath_device_class;
+	ret = dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
+				scsi_mpath_head->index);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	ret = device_add(&scsi_mpath_head->dev);
+	if (ret) {
+		put_device(&scsi_mpath_head->dev);
+		return NULL;
+	}
+
+	return scsi_mpath_head;
+
+out_uninit_head:
+	mpath_head_uninit(&scsi_mpath_head->mpath_head);
+out_free:
+	kfree(scsi_mpath_head);
+	return NULL;
+}
+
+static struct scsi_mpath_head *scsi_mpath_find_head(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head;
+
+	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
+		if (strncmp(scsi_mpath_head->vpd_id,
+			scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
+			if (scsi_mpath_try_get_head(scsi_mpath_head))
+				continue;
+			return scsi_mpath_head;
+		}
+	}
+
+	return NULL;
+}
+
 static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 {
 	kfree(sdev->scsi_mpath_dev);
@@ -99,6 +220,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -118,13 +240,51 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	if (ret < 0)
 		goto out_uninit;
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head =
+		scsi_mpath_alloc_head(sdev->scsi_mpath_dev->device_id_str);
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
 
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
+	sdev->scsi_mpath_dev->mpath_device.mpath_head =
+				&scsi_mpath_head->mpath_head;
+	return 0;
+out_put_head:
+	scsi_mpath_put_head(scsi_mpath_head);
 out_uninit:
 	scsi_multipath_sdev_uninit(sdev);
 	return 0;
 }
 
+static void scsi_mpath_remove_head(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	scsi_mpath_put_head(scsi_mpath_dev->scsi_mpath_head);
+	scsi_mpath_dev->scsi_mpath_head = NULL;
+}
+
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+
+	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
+
+	scsi_mpath_remove_head(scsi_mpath_dev);
+}
+
 void scsi_mpath_dev_release(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -135,13 +295,54 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	kref_get(&scsi_mpath_head->ref);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
+
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_try_get_head);
+
+static void scsi_mpath_free_head(struct kref *ref)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(ref, struct scsi_mpath_head, ref);
+
+	/*
+	 * If we race with scsi_mpath_find_head(), then that function may
+	 * find this scsi_mpath_head in the heads list; however we would fail
+	 * to take a reference to this scsi_mpath_head and continue the search.
+	 * As such, it is safe to call device_unregister (and free
+	 * scsi_mpath_head) after we delete this head from the list.
+	 */
+	mutex_lock(&scsi_mpath_heads_lock);
+	list_del_init(&scsi_mpath_head->entry);
+	mutex_unlock(&scsi_mpath_heads_lock);
+
+	device_unregister(&scsi_mpath_head->dev);
+}
+
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	kref_put(&scsi_mpath_head->ref, scsi_mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
+
+int __init scsi_multipath_init(void)
+{
+	return class_register(&scsi_mpath_device_class);
+}
 
 void __exit scsi_multipath_exit(void)
 {
+	ida_destroy(&scsi_multipath_dev_ida);
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6a0c43a048a0..52eb87b03cebf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1526,6 +1526,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	 */
 	scsi_target_reap(scsi_target(sdev));
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	put_device(dev);
 }
 
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..50d422798d835 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -19,12 +19,25 @@
 #ifdef CONFIG_SCSI_MULTIPATH
 #define SCSI_MPATH_DEVICE_ID_LEN 256
 
+struct scsi_mpath_head {
+	struct mpath_head	mpath_head;
+	char			vpd_id[SCSI_MPATH_DEVICE_ID_LEN];
+	struct list_head	entry;
+	struct ida		ida;
+	struct kref		ref;
+	struct device		dev;
+	int			index;
+};
+
 struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
+	int			index;
+	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
+
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
 
@@ -32,8 +45,14 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +70,22 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
+static inline
+int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+	return 0;
+}
+static inline
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

