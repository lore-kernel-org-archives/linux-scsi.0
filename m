Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025703D0929;
	Fri,  3 Jul 2026 10:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074691; cv=fail; b=W8t2BlYkE3zz7O0jyDgoM+hCF+g9oLkIR9mIfoKo5d6Vc6Qns+kSS1lNYJ6IwkuuHNP8JkFuN9j3wk8VYJKGy/sFvMqZVyS4nVMtPNOA7GJPexBvi/vctw6IL+ASHS0pbJUfS1XhC4UJI2qhojmmBsjjvnFKl8BAgtmNSiOhOkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074691; c=relaxed/simple;
	bh=405eZ+Obzb4tf58Qyi/utIcm0A6BTlBzOn4Altvi9tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tADYezpMPj+9X3WGJTDLZtJhBHwP7sTTfelPQ48vcFX/NLcn2k7wXDu+rKXeT8dFugwGvzyFCAQd/5yQwvGAX6GdiEMhPfs+jo8Haor4uHb6mOaEveg+0M5xOvpIajTv5CWYaUgE8z4JKaIuA+tt7BRjH1Om8oOupfA1Q7ulS1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r+4AYuPd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wWHyoVjy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r+4AYuPd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wWHyoVjy"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uU1E3089755;
	Fri, 3 Jul 2026 10:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OaP5TWnDHRDLVGi7u/1hybnSd/gbV4YQm5mDkLDoHa8=; b=
	r+4AYuPdwbknI2q/kW6SIS+ZmQT7gutU7Ar6Y2LfGV2HNXiQG+d6lvMrqmhy3Y1C
	7Ql/YdSReAsDqcDKHB92Tr7FuHeqCiBdfVn43sXfbCKcmxHi4p6RkluqAf8FqVZE
	Cwg8bpepOsPmaYdBs+wPasiFG17UgXeS58d0X+ec0jAj6LF2X80gv0p6egyz1vFZ
	ZgWAWTf0KEbEu/TF6xAS6KNq16HEzEEejExSIrVnseVYxJx4tLRMUyw9BYVrNJ5o
	iGnmxnd7pMeo/4t33V82YpqiaIK1nRD7qRuWGwsrCYFtR06aVRKVIcki3CadSPpz
	NFWKBaEHsabGuEBZnSEkIw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p4af16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS8xn033859;
	Fri, 3 Jul 2026 10:31:09 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyqwd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=av9dWo8pq2hd/7jYwqB79Q/K0IM+NNzhwWzIPedOPlYBlPuOoHzVlmtz2EYYoxeaI468pPcngMXOZQFuAoZeju/uaBfHNjG8EvvcmkaKEiWZllvL5nD17wdFre/yeqXpKP8ZAj4knfBc0/FjgOouYpJkxE3699flvJ93pEo7aEFbOf6XULlluS01Pi4rK7NY4DvT+xo2w8kksios8Rt4jysR5niyS6A1nRyI13sYrQDQPmwO4gGPqwQxhtY5rVKGDPtRkqNMXWXB84x2zMpuXourLK2qrP+4WFXdFo/pn0qNsOhVxqy3+XXUKb07iqXbK8bVwKhULmU4XQk/D/gjgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaP5TWnDHRDLVGi7u/1hybnSd/gbV4YQm5mDkLDoHa8=;
 b=CiM2Ki+5BjoMLKjSrTQvFQfb+adiU1SBUwUQSZILATimELqaIE778vJ6VVe+anhVkcm9VuyUzLYBk0TSITEsHyVTDmZ5IIeAI7mDF6lKzhXWRcxB8jAG7XYjsrM52iIq/MIBTJCIjvp5cHO75ZA4NgdTLH7TDnVBxljuJGZ231ir4LrQCpX/TKHb/X3vWE9Qb5WrgH8Ymklbf+/6fl6d9XJIMKpztJIfD/JxSio22WmmlONuIgj62NxqvwNxniGvFlNTZ3/nQGejnvj3DfemNQ6hVDm+Ynuj/fkAm9loxLQtef8pTjcgn8GQYovJFERuYYkkZyb2iihiDcDR71twgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaP5TWnDHRDLVGi7u/1hybnSd/gbV4YQm5mDkLDoHa8=;
 b=wWHyoVjyb9A90u6lFimSFJCx9fsk80uO5Jv8ikd4GZZGimpekH6QVzJ07eCJ9JyNr7PgHek2ichFmZA1AvRSy7fK8CviqRyQWh1IprrwIt6eCy6s8vo4Boj0COleOOq5H4ivj/pQWn6DnwC/B6A4x7+jjeUClMfjiO/i5wZZoGs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:31:06 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:31:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 12/13] libmultipath: Add mpath_bdev_getgeo()
Date: Fri,  3 Jul 2026 10:29:17 +0000
Message-ID: <20260703102918.3723667-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0024.namprd14.prod.outlook.com
 (2603:10b6:610:60::34) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e111756-c9e5-44a1-65a4-08ded8ee30b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	E/qnKG5We7QllfCi0yIASeKQcUxO2tWYmVyunnv/cF9Y8SBP5GAkxSBzfUAjWSczxhgC/MFFCX5opULLBMA9Niq+XA0rNbJr8yTichDVUu0lSGR1+BusHbdGNBpNlK8mlihqfLUNepjhRxjgFg8cWsgr1zeW8z27sm9RSnNPIoEvCmLipujEkckIwIngYZ750kykWCtWWPP+H15IS9HTvHJk/nmJSVqh7YO6u81d0BQ83izrQvzlQPnmbo1T82oiX7+Al2unD3L4D6Omxwd/qKEy84g0UBvxCMsoVxa3VvL4+zmmhfGuBGW6tHE6uNzdt/X8NkUDqnUgbxn+Y7ydOg+yS2JiL2IxltuwSoRZXVv/nf3bfFXj/+1TAX0Z6Ofk1Kbduv8nPAI72g9HUtCbccSJs7H/6eibe8yfKGfx3B344jkCAcXGAfDGlcb+udrF9H41YSFG2fzWJc+FPLnSmL9DLDYKLaRzFJOOWsjFpmVP3yG5e8AikZnJHP3YnAZzYwfPW3WiZsFdN6tGTzgFgfGO7JUMkF9rhLZadpreePhBlCdJwOSLlBd3dobP9gzz10dAToYCtcPOrXi7ObT7zlxHPZYIDapY4FRrSu+7g2MrWwNb15OcfJ4gXT0f37EWO77k0FLE7Zh14tX2z9R80J044XrbPXbaHUkDcXJwHic=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dJLiAyNnYZ0V9zpVdc/0kqyGArXgnDP0OFDT10wCByURoYsiKfryLkdTdTRk?=
 =?us-ascii?Q?WiY3tG0MrrKULKGsu2hPil2ZyQ1bYdERF8aW1AZqGSlptCZRMLT0v1nDZWXC?=
 =?us-ascii?Q?EMt4l6tQ+Ag7xE6wxpvFucZC+Evf2r1FCsu/hiODuQjxNoz6DEDcnywFzj13?=
 =?us-ascii?Q?/qAGrnGMPfS2We8VPTOOf/YmAO+h26QrSPOodcSZwjlpnhghSQAPkKg5L0Di?=
 =?us-ascii?Q?23qICc3bIh+nTJQSnloMaax5M3nRmyzjuOSdFJEGd/LbCUMPUM4SoE/j6J3a?=
 =?us-ascii?Q?SvP8ZyNA7tmIC4ZD68b6mtlTBHNFqPiMYA4gVti/ufS/LuvVMW00CI3WgaAh?=
 =?us-ascii?Q?oFMQ68rug1w4ssXUxEKhI1XKNt/i3zSWPO8+Kih3fMcW7xduyLbiJozXfrOA?=
 =?us-ascii?Q?z1kDhkVkCSC77n8bk96qhfuVSge0yFemrJmVXmJHmG40GRmUz47lN3KKpjj5?=
 =?us-ascii?Q?fQnAeW7D3woIwyNodwvA97JymB6+GoK31NG6p41ykYzocZik2cH0df7uIBcI?=
 =?us-ascii?Q?HneZ/5xLuVYiWRAF9aSLYJVmr3bh6zGbNFSzDmqeGLHN5fG7MeD49MH+bEHK?=
 =?us-ascii?Q?Bhyk70biGAjK/DuncUoAzSYVcR9tR2Os3bXITDCKilzX2P8lkWO/u8r4Oljo?=
 =?us-ascii?Q?w2LY0nRumVxX5Q+pH7bkRCHN93lv6GXNVcWdFAdxXyi1Q3chm7jD+OfeEe6E?=
 =?us-ascii?Q?Zl5K+ajqG0A0ckF1UjQ7XukeaENIOXFuOFJ/FEvhparadh7G8HXII0g6+4hn?=
 =?us-ascii?Q?JTbbGM7sHQfo0+8kQ7zIe9R2/6GdPA3AzFE/3EkLojxyhbH75bLGO5OqVJfp?=
 =?us-ascii?Q?xyn0TocYN0etEtqW5yqmzh0YxCotpbl07aNTc5SnK5L2h1sDQuQ+MQUD9nfV?=
 =?us-ascii?Q?he1NWAkUmtCVpm1xAZnYuQjdOZixI+khKb3NNKi9XCFAemGTavV3CN4+shJh?=
 =?us-ascii?Q?/LtsQJ+evlxUAynRUedRSSIxc+eOGPyFpWKNUrPW7S77NzSN6SHdD7o87qfw?=
 =?us-ascii?Q?RbLsBJ+zVwb5MmsJeXoXHwKaQ5bDwaCHS9Ufs0Zm2chHdqQR0FWfdAYaiN9w?=
 =?us-ascii?Q?RxceNawRP1hlivLuY7cYeYPX/onKFZ7qR/eMlYD4itjd5Q5+6zQJDXGJWiq/?=
 =?us-ascii?Q?SCmg1VgM2NMVEK2FeyuuYn2jydYLEaxdoM5d301QITigJHjeFfRH9bGSSWZm?=
 =?us-ascii?Q?kSE8xlDNMDPryb5LvOztNlXLVZec3MZtoxyds9ZC53/2NM3wJOUnanBlntMR?=
 =?us-ascii?Q?2neCaw3hjyJWZaS1DrN2l8Kv8e37LBS4zy/y2psyQ/R0WkGWkcVC7C6ve5+R?=
 =?us-ascii?Q?jr3ob8atOPrhxr+UyZJsHExjnsP+LaD+xp4SLQ15FHDeWUskqQ5+aLXSfO+P?=
 =?us-ascii?Q?vXwR2Yfk/bkBAEI5MSb5H11zFmPCKUVjxdAU0OqdKh37yCVEKKMb692UWVQf?=
 =?us-ascii?Q?KJpa0gw1eWJQznVD8Ss9ff9NX44MwF+KKqh8xlaMRf6cJzCiTSyGhLlEYdMN?=
 =?us-ascii?Q?uJQ8r0e5cmx2CKHmapUqe4TV86AtlQLyhqUFVh3SGKKQJLAg+JTCc8rfk7oa?=
 =?us-ascii?Q?sCVYbGpd7s1nwgfvg3JidE+Xzc9xJk6z3GhhEoRJ+437BTbmCHAXVMnwBV2e?=
 =?us-ascii?Q?7Eke/mybwk64DmkPstb0ohcSTQJ0DEJpaIT817N+6nGFOmpn2Y+hhuy8XBjQ?=
 =?us-ascii?Q?ZHyTONeG46wwO9CyktpBexAWW4RyoFub2tM8uaynk3A+m0onvzwnAaXN8p2r?=
 =?us-ascii?Q?nyv+TVHCoKzFXEErxuKnnPwdHKQYeBM=3D?=
X-Exchange-RoutingPolicyChecked:
	FxYfuacHqjCAZNzrXe5XYME7Khf8o6AdL5qxoGwTGdg8lqzs4/Q1qnzbEfafb9MLfiCFmD4JSJwH4fudCUPBj1dzOukCqtbu2IiAOedqXw8Tj9iYGBPHUSNeLzkACj2cWNieKvfh4/07yEzJ8zl/7nrDyVrkQ4g7UxsPRaZL3ZLk+lafPW4WZoWxZGzUvjvIJAZJ9NJXo19IdYa8Q7f76sU1urFG376DK4zMms6vyz82uzyN/vewUAx+8nUqkKH86S6aGsqOCyCDRVVUkClHNNmnrpMBIu5A9t3sk9/MnpYSVZ5/l3jgOJwx4w6CWBDOFOuMi04fV6aD2WZkpK2ZEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3gRTZ3g/H9RGGRfGqwwgJqO1eCcudNqypdfIAjt9aaFuD3Y6hIo02X+xuP1geXI4On1F6wYjP+zenu7jA+15Ij/EkJtM1MpsZUp9/nuR8jrsb9jGWRK0CMGUOf+S+FLQCDjpXmwBA61iNeIpsauDAHUDdj0KDS7vqfz8NP+vGaKhbcXidDzzsCugrGa1gQgEW7Ckq4oAXIlTuTBmwndztB/LHS9tR64wsp56UkrrvK5bFM8/uLgGFIpWR1IWgsL8h0vY+nBsE4jyElvufNGUou0PYvGv7QL0JvTm0Ji5RvUx3MTpkXHJRnxTwuaJ+r0McaZ/M+KHA77X2Dmc9To/PXlOBQ0S/e4ZN5wKz4A00arbmf/iaKDp+UpSGFUHUP2a/hFi0u3R7lxTbB2ugM+zP+seeJVPL2BMPat3cH9szqVzftTGBAWkCZRjuZPoX1w5O4x6M3xxD1S+rOA/kA2Jlhhmzs/gVtCw3raYLd2T7+A+wNC5WzSrBjwixfjoyby5wNVtbP8WsA/xD6g6DyJIiB7OR/Xa5uSmImzFUkCIRnaFJNHHwvJGC7HTyaHOeJ0DuOvBLmTh0C7eHVZNRg4b1wcSLCgxZUnYCN5QL/JsGlQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e111756-c9e5-44a1-65a4-08ded8ee30b9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:31:06.6466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DMmURb7B8RGy6xfkSOiAwhgRpuGArHrllJkbEUBNPxmybaErXa+HoP+JxxYXrfAd30xRWUks6P6ye5kVfiS8IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: 8GEOcyVnTG99_SsWWqomEJOxrZUKCEXE
X-Proofpoint-GUID: 8GEOcyVnTG99_SsWWqomEJOxrZUKCEXE
X-Authority-Analysis: v=2.4 cv=DK6/JSNb c=1 sm=1 tr=0 ts=6a478f6e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=B9zBlvtF56XJjODUF4sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX924TQnPYAsfb
 3V1XFPehpGkfRDz3dZ+L3GsM+8YydR3dq8fxjFrYU6ZfhW+p0vUA5B0MxTpneBX8eZJNEUAI1Da
 M7MinN5DowjZxYWPFkFqNQtbcH5/NPHCx7rd5btEDVmy3gS5ltkNiAojhQ0gINY8I2DMMmm/Enu
 iykDf0CuUluSgERegmsjqJhxmbUw/MZUqX7HlP1c9U2PCCXp8yUtsejerTo3hzWYVdAswXGk++N
 QG7lWjet5NEEozmX+b39Vn279kfPmrSeGBKKG9YpsMtsltWIGKLXePAI6I21pmBG8td9kTBwIwA
 vk+EQb99osa/jTZt51sKwSwLw+cShrp9cVsgPYFpBrp4W9oORBMmGrJT8g8lfJwR/yYsnjtmJSW
 w5YAmW6I7dAyj1o1/8Jzgj/l6n/FB1ODjLTgZ/GgcKEgO5h4b3zu5l5iKb1HOqZEZoxz/hV6s8I
 tmpi7WJvJaOmWuxOXHg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX/qVuABZMh77R
 9Zt1dWffrgYw4qBp6RwbutB6ZsWERSfjiKXnP+eC+MBwEr7n0ffnv5umQsPD51ZsSsWUvRzckrM
 2VxZJ+rdYL4R+m7Xp0WboN6+TBQKFjltjqN+yPCsR6H4nC0szrrk

Add mpath_bdev_getgeo() as a multipath block device .getgeo handler.

Here we just redirect into the selected mpath_device disk fops->getgeo
handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 4e4b347875500..26d9b17998d66 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -547,6 +547,26 @@ static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return err;
 }
 
+static int mpath_bdev_getgeo(struct gendisk *disk, struct hd_geometry *geo)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->getgeo)
+			ret = mpath_device->disk->fops->getgeo(
+					mpath_device->disk, geo);
+		else
+			ret = -ENOTTY; /* See blkdev_getgeo */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_pr_register(struct block_device *bdev, u64 old_key,
 			u64 new_key, unsigned int flags)
 {
@@ -736,6 +756,7 @@ const struct block_device_operations mpath_ops = {
 	.ioctl		= mpath_bdev_ioctl,
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
+	.getgeo		= mpath_bdev_getgeo,
 	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

