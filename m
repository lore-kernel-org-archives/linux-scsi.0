Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C86042315B;
	Tue, 28 Apr 2026 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374968; cv=fail; b=nUG6DvmfOKsnZ5ZBIFfYihu4Ptksi7oAsgTUt7mus+8cBsfKaXTkLG+hQ/PdxK26v5NNxpeCG9yqum/MectvYEOrmoocYZG9a1qyeMPWhD8FUpKoyxyL8csDZet5umrRHbWKLeIIobs/GdVDRYsqUo8mZlmtNhmBQmGPYKGuowo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374968; c=relaxed/simple;
	bh=tbZtTa2TO/XB7yYfh4NdCjNqEz3L3SKIn8/7qqA0uyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FiydEi57/1M00JDQdG/4Yl6vwf7F5IdHmWpW7HEHvFMiTyiL+czR8Qh6Yhxegy8sc7TyqGyfxScQ+2ci6MGYZMJ/mr39yxOdexbkGw8N/zAkSk7dy8l5p7f74NhdvqleCoE6QbBOIj44PKFF+wA1Wbr8nYk963oxzuo71Z4MNjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EX9nxm0o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cxYPHeO3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EX9nxm0o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cxYPHeO3"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9xqNT1015456;
	Tue, 28 Apr 2026 11:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u0uygxMwEG1wI8LfYt+BoJHOelffjPC+vQeaFQwhvVQ=; b=
	EX9nxm0oHZH5qDqP9IK5Xo7dsvySjkP8y8keC+5EnawJUSXXTzdBmTc/HYk7xll7
	jedKzk46n+6Dyf2JRg9nPRQGG0JyecDQSn6hYCbo+Wc0xpQUPkoMoTJLFSLUDS2p
	8JOEwQNLbtm2woSU/soKv9yQ1yICsZPCELflWYkfVXxdbm0L6/ZurxQypKpfKcpl
	z97Y3rk3qK5DSj3qq9k3LAdk0C2OmpHbXeuAaUtS09iCBYWGfm6ZGem7G16dkJT+
	CLFCkARzoHOewU+80/q1KQNPcMBlEmgyj7JOHfLTYjkG3vKRd7k5zhNSHWDNdT7o
	uR+z1J1/Pej5augKZgIqww==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yykc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVh038802;
	Tue, 28 Apr 2026 11:15:44 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVQshZGd9pw/RuRj4dQ53g3GC/KAy8KtXE+iw8EkAYOAqmYUjIfHGJy6zipQ+xUz41e0tONL+w0g8IdNJgSijqYgR3W1e5bTx9nJuimDZvNvQ43Wvk9Ol8JxO3sYxwuqn7c88ycjEkLy+b3v8s5FBt9KlQePn2pYQaBfapHijACoBCLfsEyJPZ8iMnddQmIYe9mXOZn7D9++ORje4HNMD406hJC1obdaysHwi6RUV+zTDecbkBPL810kelRUjlC2M1aaMgKDN/DN2Q5Z6117IB94VHP864xroGbsswGF7qggac3+4TNuUslQoKe20BS85JJ9N0oHbsPp7x9E0kbKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0uygxMwEG1wI8LfYt+BoJHOelffjPC+vQeaFQwhvVQ=;
 b=lQYIWsQ7GWmWvtYlhJz9QIsD8QL7stVwiiyHVR8xU9+fRWLHJDEB72DMDtCoJc5TX2/eikT7KUTrBsZ1oJCaQu5bwt+DFen5kWzm9ORJAQPEQZuuaXYb/jXzKzAfO35kWWtN0140Lp9aH4S/e6b+PW45R92AIiTU7bqGKMtoueytH2x33hlo1HLff+KJT/QRxZrKxJDs8SMJG10+sSlHjRQVns2QPzrE5G6/wW1KWS68KoTCwVfUaELq2Hxc7fMZoMGHzXygFMhz0W5skVEctGpA9WzpdaoVEN4QQteL/wy1zVvPDO0PP/xuqwbZT8DamVyV4xVWVm7/3K/H+FLhdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0uygxMwEG1wI8LfYt+BoJHOelffjPC+vQeaFQwhvVQ=;
 b=cxYPHeO3e3peIhTRIQbybNOrqb2cIMOYmBDO4XVJPF6zRsDratPYt7/LUyIpqctCWMEBd7KU/NS4fhWoobALqXgIOxOXWSzj6iAMrf3zEzoLKPaK5N5i1fdjL7eY9yqZIDumiN4cr0MN9POBzVSzyLXBCSZO4i1Bbkf7mooy2S0=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:37 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 18/18] scsi: sd: add mpath_queue_depth dev attribute
Date: Tue, 28 Apr 2026 11:14:47 +0000
Message-ID: <20260428111447.1779062-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::12) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 023dfde0-cde0-40e2-f4a8-08dea5177998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x5R0y7507uBTmdiuWXbkrd/QtpMujRXsTFmVI2/IC+RCkyWTCxiywGNmpaj5Utm/OjbEsHDLIiJrLvWonzfRjPTGA9fQMnFA+TV+tvs2NZ+YXdgrRhjlTjC3vKfuuzlFC4ih/eyb1ZnyJeHPYCMZ2Z4cyX/USy+H3TERhMEOQypbwPjtgPNLQEXZyMsCip2IWMr3E25WjG1JhiDZ9+VN6KLNpF13kY9iSuNGnOY/hFZDfaHEFRaPo52Lrc/s3paKin+ueRKorUc5qwP0FO8HTFu8+KxjCHPG0+4yA65mg7r1WSYhLs1o4FAcTI8gcFwr6wr3iCF744eTcH2oU7NdEcriplwfu6MPv7ULCAXgO29jux66oi2tlZeMgSmkPUTD0FGkjFE3+ZX9/53UMfA5I14BX/vtgmyJywpZL9jL3LC72Sp7xpRNqSw9fbvMaykwDsPhpC2k5AvI1y0SrrWRMbOdl/Jq0N3kCGSRUYC2huegkAUhQJlsD2ZO7E+qA0xVLUUaeTDgXUJew/JoZxhkLW8Li+rtGs3/mPprP4N9DLa0Ju9+Iuvkt30G3XLKKtxUsdNwlD/G1JFV9A5KnpyiVfr+khF1TbZwNblVT5E25KpBfz16OpEjRwCQI6CK/l6ZkrMDAXCbX7plE58EjZgmPIijSVtGzjzsShyx6XIkIv5n4OhQoOzlC90pTG6NNJrj6tGgjFemMOMwWTPgZf3f10ogA78Ch1e2owU6+L3Ue/c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a9F5cUdeAvlgQjgX9Rjr5q9n+C0dw1dkOPF9wSyJL4xt/cvMXCGx2GLY5me1?=
 =?us-ascii?Q?UcZKLpzuumaeoLqn1n5zD2uBeiebC0aGGZCG4acQJSiOb2F5+H/No7aK+P+G?=
 =?us-ascii?Q?JF2ibVvW5zC+CH1/jAyFEnitdc2dJmh0dwABLpVtz+5233JTF/qBgf5k1i2Z?=
 =?us-ascii?Q?43FuwqEZQDYXgmDO56S8SFhZQZl/Z9YOodBxTZ1/Y0kzm6lMF44tg2XBgXH/?=
 =?us-ascii?Q?ZsUa6/xaqKFMXS0LDPlyrk5zcaTnSGvTL9fJ8yvbngBagKOD/At+Icsktr34?=
 =?us-ascii?Q?dT6udmHZcdijSe9n32aLZOAAMbDDv5zjU+2Su5wmTdUABIfDxBRErhjeauaT?=
 =?us-ascii?Q?ad/LLO7OPNB9z8m35L61MjXye69+CBi9af7fbQooJ00GcEC8CE7XAc/Oii8W?=
 =?us-ascii?Q?c8Y9/KNQaZOMsNSRbpK10JBe11oTg6GxYJD6PYBseHh+6hLOSbXNnelTkROF?=
 =?us-ascii?Q?4Tzm+ZItEFPv7EwO0PNP12AdHuAw+2LqhLZ1xFWkDh+53gpP44+mvTJTy8c5?=
 =?us-ascii?Q?ODQPjF68aLPkgwJa/ZpjRjyfjnMXXJpB2jxE9EB88TdyPfusGAwslr0PQ9eL?=
 =?us-ascii?Q?n+3pc1/MC203cIO8zmsUKVPL4QHs7g9OiidGELxk0lFyNa/2mq+8/c5m5Zt1?=
 =?us-ascii?Q?XgP3f5rd1Cj3aHXNzRcIjyNEkFCNw9mlVPDm+6EHnW+Z5FygzcA99cpbk6Xy?=
 =?us-ascii?Q?GHYigFfwKibWmBlEQvy8vaJvgJ4VsCH8I61jC16OZSkuUp7zSv+t9V3iB8Cb?=
 =?us-ascii?Q?yYONGuIdN3sa1GjK7N9iDoKQFxRqe9Vr6JLoMzzfrhaUzVF1ihLwknrPjpWH?=
 =?us-ascii?Q?9yhC5ewXvooeLAeldWDdQOc98rSK13wEphPRqF8IbAmMpYAh6qvCPdSmxaks?=
 =?us-ascii?Q?OmLIZI5XvtqsoC5G/P2ITakpfxSms0m2DqdHxHEf4ypsvV3eY+1L88L3cxaZ?=
 =?us-ascii?Q?Hq9wy5NLU2PjG5DyTtP1pLGKfrzVY7Wu4m0EJnL34B5oEst1+GaXDnO9BIOF?=
 =?us-ascii?Q?iriB6iJu+z+fJ9mqT668+RSKmTLxQXl/zfwedb+D1OLg57Rjejrfq9M9ry10?=
 =?us-ascii?Q?k6VQmmKXxHaZTV1jLk2qwc4i6Ao8rdJFWYKQfVVLHKr5NJ5clZZ/jOALp1Vy?=
 =?us-ascii?Q?tS9Ag9sbnpYOaUBWip/iR1uI7LQMboN1TaBDpajDhb/U81UyKEPdcCUrsCGU?=
 =?us-ascii?Q?ObLRJar85iUOoCb1FWU7hRiUIhNs/9DaCEwQr21nCXzk8xs9lTZ2ytHtmBLU?=
 =?us-ascii?Q?YPFblJCai4viCulc6Muge7CjwycYkM79MbXeM2crfKZxi3yErHpa30DkLhrc?=
 =?us-ascii?Q?daDQF9cSz00JEDiv646usD7wRkrNnV/SWUmNDjzZ73j7CVQDJuQcYhbrQ6DR?=
 =?us-ascii?Q?mHvDir4Gn0UMemtYQ5/zxiXZr/cd6ZLwLVx3vNDP1CG8raXt4TbLIMcXENPe?=
 =?us-ascii?Q?7XMkh5+MYuwsRuE+xmXvUqp6O4qbPB5RAFfwIQdkOGlHDIFIXohC3yIZWeqt?=
 =?us-ascii?Q?Du9Et0MXbxOICwicoevgnTuEl7pEH8XXFRQkqKaThx86EPTze01EaHeURpfh?=
 =?us-ascii?Q?8M+Oi4ksBgoassoqPGAhXt0nUwqRJn1QF+ufRfH9m6jJKfRZXub5Hd3nqaQK?=
 =?us-ascii?Q?yyxURabDTEJAT6D9rFqxS5+to89gsr6akghgoK0OSmZEi+A11WR9SIQSLzRu?=
 =?us-ascii?Q?jbk2qG4x7YFSrWNLjLPT++oekwHwGgdrFF7fVhPECVloVgtE3xYDODc+kK3G?=
 =?us-ascii?Q?LOUmrTu95KnX/6FX2396BYURzhlB8Y8=3D?=
X-Exchange-RoutingPolicyChecked:
	aal/O8lPe68LJcz//9GoaLQBlPPwUnCyohsu4ZRz3vZQscfIpBrvR9jT4/PP9EVSkbjPlliOLsWMl1B6aiqJO3PxK991tTuGCzZavGJWjO5QAzGvQv7hEr8qEYvYfpXTQgoPlROfvmtiKJBHEgAxVlPMEkcLxdlmLTarnPxIv/APeC3epJ726J8sA41hMGW7LfPsNXn9PyDf3wkM6AG+h6etoki+b2ZezqPFvlreYsXSmnd20sUrUsYNvgsfh/dX5JKF4Dl5PP8G9NHmmKhoW4QG34g1u6XzSsZnlU9vIX7UKLt9gNiPL+C+ZPEC31SZF90pHIvTdEBPQw+yZNXVVA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Esdpwv0ph5tMD2K2/tzyhF6bEXDAi+VAnjoN+kLiEJUgq5+LnXKtyHnvGCxxk2g2YyFQJ/JiBgD/imLw0rhPKc+vmjBGX6E+lzDrbI3s7IPYGONZRxoEcun8UBddJqA5GqZqL9MXPl/6pZT1LyhPtzbmJ1uiegyRCqZNZy2ARk1/7nxlSJAeJITmViFRDyw3VZYk4QKvVWefOuHwrPOzXxElqtpsaQREshHCSibdoA+zyG0dDyOo8lr6VjnQJPYSzqGtLhP3LhiLz0tf/tcyrc4iiY83yfKtQaDvIBidsNKJYt+/Y4xcxQiEYzOI6mnp98p5kThuqwW3xc9nCTz6dUKKdsyBUw5hD7N1jA7ICH+3Ipl7rCPo4njn90Lqbp7qlelyDEaMJVsDRBl0ZB4cthH86bGHba6NPwPdV8N6ur/LHTOguG4EIA+DgfDryXEZryJQ+pmCZ2uUW95XGVZ0FRCuQWJy4KCuLCAtWl1bEuHl4HT8Tr6LOXf8bCelS9hl0Y9rTjc6SfUOSSMcUowEyoU5uM6VOrRF2k1ZAufnSeNNXVGVMS3CpnT60fowkCC1DiNJgoTz7+24lItgQ42T6oDRGUFzFiUtSTLS1/fYIN0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023dfde0-cde0-40e2-f4a8-08dea5177998
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:37.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T4CAkNAgqSzAibCLIIw500Ji/NxpD1RQy+Hd5cs3ijW4oX8EP2G+ot1SEOPJZmIFIGUrEcyO+uFl/wNgTOG4HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: BBqmisNFYIih43HF5u1-jMUxgvdSOizK
X-Proofpoint-ORIG-GUID: BBqmisNFYIih43HF5u1-jMUxgvdSOizK
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f096e1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=bA5FzAUjrTEoIiOIIUIA:9 cc=ntf
 awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfXwbGRVF1GbtWv
 MOvyhLFLFpX8NbMz2R9tIU+GxJ+XgWwyj+Pzy7zL2lY/L1QJ+he8h+hDhgkYhJq9c+gAfGIYckz
 BMMp/qQIRW1ct9esV8VkIzyBnEUjgpal4N7nowc4g3U/LXmINA+vvLSQ3eDtmybhM3IJGvh9Xlo
 nCE8ARGXrS1aMuCyUOELmQb59kVdU0RBGLolOs3zsrp5fEv3k7C0nUNU+jBfqi0hPifa5FH1Bvy
 8UMMMngr+UELiv900jie/7O5f/tkk5nLnoSoISgPw82JOTEC05gSs8n6i4PPEzCZ/WHiX43aGfk
 X0cYptnmfMcvfjDQ4NYAC9jSz5/EnzAEQmLZuLRx/JBAMJTGRb+WYBmv7PG9B3qRXr8Co3gp7ac
 xo2PCPQxwYzpHvXbwyVC1GHZ5GRmpmjuGuL+zi8CHr2Zmw41RlfaHs6pSIJGIojDWvfJyZNYnP3
 jIaR7HQ2S3WrbeWvrB93TzQ1pqw21lFtFzzawvOY=

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ee604f9f8cd20..f416457b5a08f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4049,9 +4049,27 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.5

