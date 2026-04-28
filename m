Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9CD413235;
	Tue, 28 Apr 2026 11:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374817; cv=fail; b=obC9whZjLhJYfjk04IKeGsc4o63SdbZJJ8Z4QhXAbdVOcEYpuJ3U/R3M6YQTJhzoa7MnAB6KJ9oOrMC0Z6ttg5Z0m/Yymt+0G6Wg1oXi32lPR02tEUAK4yH5McB4IGlqPS/UwM12MdLQNpv8qQSjGCI8LI8UhP/Uz5ACwf+BVoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374817; c=relaxed/simple;
	bh=k+nKguWP/JYWUXEBMpzdSGmTA+tpntXC0ZR66TncDpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JSA0K9KB0O/TRxZQz53zAL8CHw6lPIx4sb+1g1PRzLDOPlUVPLPx+eXkEfdB/LTsL3uuegdEsRtd+ck6SF9K37YWPNMXe6AFJDiVmTUlbQVEIHXTKjNSkxqQCdWRbT0K7YQjFUTftqRKSPMQrIUbivWF7BRvXX7l9GkxHZ06RZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bZYm6dWp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ty+SHCah; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bZYm6dWp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ty+SHCah"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8s5TO3055274;
	Tue, 28 Apr 2026 11:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HmZ2mrjFuwazczhkx6m1IyXezWkEUO8/pTk0nPpVzCs=; b=
	bZYm6dWpYbg4hQkgaBE0b1ol3hOK/wxNjSdsZHEWpkDU5hhdjT+vQB1XeMwpYjHv
	LRpFiILbAcTupYDd7yhoR9tiogCN2h5qlgAFaM8RLfC3iUfqLN8pXF1SeEuHM+Ht
	qwfT0NYELL0X6+9Y6OnR13BJZ1FD8Xt8yQkMf2Xu2dMGNa6T3azg/WSz+IVEnX98
	jZCwIfxSdeCBGMazNKrhFxMx4A4cY0Dx76aoHv2y/+d1PbVu2Y6vYdB8UBd+aboX
	fMSG04NS5paL7efubneibIfEaP8wXn9arZSdTTwtob31zcRFFbk9Aa5SYQgjsxYZ
	qDUBDQkeI5CF53gI/zd1ew==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5yc0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCk9g004790;
	Tue, 28 Apr 2026 11:13:18 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2jm3d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TLVO7h6dmX+hVA6GZEdYRAAly5nHQkmAk1i8R1zb9QniP6LZ6sGRaJ2G7NAc7vXe2tq8Qlj7zw/Fbbnk/JytGN26eenk2cTAR+4FCNnAA2kAewLz5oTs8fup2DOq3nS2ggQWtrC4o/sEAkU/lt2HYFdKQRk1NrS3fSiINoi8noXT/24Zr5lVhbkuQgyiU4lz82kJh4K41PWdmTqXTYL140zDiK9yvX29XoYzxOASOTYycWe5O6+1BPLlZNx8lH9ISlRXg79OszUGP/xRPG6za286t+1mGdXhHkBCdShbd/dhrNwoU1vvSYnVUDM8760iVnV6hwGtLlfsYi+pMFl1hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmZ2mrjFuwazczhkx6m1IyXezWkEUO8/pTk0nPpVzCs=;
 b=zDRjCvJpU5SeQ+tvdtR/dI/+4l2eXM6gDisf5s3nX7M+VRKibU9RACRgDH2x9F5Q//MM68ZSvXcpbyrRcEdMOhpAy8QWrXQXd0KlyED+5hFZMr84v9KoTJb+MhcHOMzzWSQCd4wEkaMjulhisBxfTdNeq/UyHTx98Kb4lsOh5+L3PZv5fIWsI9oMrY4rrI2/XaXfKgTR0jWqw6ViDrX3ocrh6JzmWMr7e9teX3PMTjmTSICVXojrtP9yxb1hwmY7Dq+Je/RfM5fbQRwa++6dinipIjODeuMHGTvo+AzQwLrGeGRBpZAafCwsyekNf08ZVUP3T1FiW5bdYtfilrXj1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmZ2mrjFuwazczhkx6m1IyXezWkEUO8/pTk0nPpVzCs=;
 b=Ty+SHCahz+GP1IsaOevWRc4GLKLFKnQpe5mi/sSj5TTpGFdWx6yirzIbiVormnsNb9kR3qs4dVuIwQbgHIp2xRRBWy0OurO9vdCUMCRHIn0PQXbmnCA9+RCfKxspQIu2wjERaJxbU3Zanls8BqViU3/7tgledqunNKEd/PCldKM=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:12 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:12 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 05/13] nvme-multipath: add nvme_mpath_is_{disabled, optimised}
Date: Tue, 28 Apr 2026 11:12:48 +0000
Message-ID: <20260428111256.1778475-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:510:4::19) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a92eeb1-2e8d-443a-6586-08dea51722eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kOWizqvVA73WwK+tnVWrWAao6hAwBChdjd8IwUq0mj2mGtVvNbJobcDfI5rrNBCk35mQKap1JJo4iMx7gGEuBsTnCkWnxfe/XVsfkRtWFTxkhxZXvN9Ub+oYenmCJ5uebmr9T1ZKlUqMd3weSqoTDEXGMl5yWphlOq/+zkD6BDugAq1/ghfPAkYJ8rLFCzi06r/0YOYxVKcZp8ofBc6UD9FM1Z2UZ0M7SMHUUsbDZYv5fw4KAgW2NEp/zj7Dbc9+vAv1SS8+YzBMH81bo0+EhBwSf7ajM4kC/KtOQEuXP5H687hEN2J2CQ7niWrCJ8jOuJQEDQniAqhxoUXoutbLqKQJvrJ/IEUp5Y8KYw9H+ob+Rv6BSLZr1qv13Lo+/Q9oL0O+v2mQ2vdx7k5ogvgywBE2xIimGn5plXBNJIM7D4GdGC4yUuJk42Oa9fZxCWxLiIO8XkPYgouPg3pGYLB+NjjW3TSgtIvEiOpMtJme1/WaIJ85h4vT63w2PVjosxN0FzY2xCPz8FcH/etQjdLib7uwitbxsWG+zdEG8Z3XjYuBzi4lp/mjyffRv5ezOYV9u6zjKWIwHPfq7u63KYnXaKHpTfWSfRpZiy//lNm1QAJkWwVvmNQ4aGpAeOjUnsXxTmLDSCpf2y9fNGaf+CcO3NqPY3RlPcnwofoNtknWUQHmLrxQiYakHZym5i/jsjmbrPpZ/XXV0P1Fwzza3cc1ulRvbAdmw7mTqBxbMC6kGms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+lJ6hNoSmbL7D2vM//6qqSR6U4PGVM53N1vcfC9p9DdY0lrZirBNGBk6jfJf?=
 =?us-ascii?Q?mplwXVhMplWD7ULsFwTl/atERR6l4ul3vrwnMvRqgR1NqyX8Ayf0OgxU1x+l?=
 =?us-ascii?Q?n81uG++VfoSkw+QCe62q/nvIG34JJQyDp5LwonVAP7Q3gjw6ewdeCYMBrLrn?=
 =?us-ascii?Q?fuz+JqIS1TMEv+w5x3ceB2mtZJw/pQsxC3RRI3AYkKBH6RZqtyq2+Tv0iH8T?=
 =?us-ascii?Q?DUtsdf906i90pUq6EjeDeWO/mtXA/x1jQ1K08GFGCT3DJCuFE/PbaSGCIp89?=
 =?us-ascii?Q?y4WIECcvQx97IHRNHyJqqxiPk4L0lwRJlzXgKqWE6CxzPOxywoPJEmtuFz8S?=
 =?us-ascii?Q?aUVhzUsURaGdpbEVo5AYGxm9/D2m+73zLgE0qMUIHANrxQmsPan1sFrJnxnD?=
 =?us-ascii?Q?hIeN2TjvdL52T8xOE8WUpdnqIPU8pa87k+HpjUpobjTQ1pddeJ/BBfplZBhJ?=
 =?us-ascii?Q?zWAu0lF+nCXkOa/GUtqkZbtRXXZQJZp/Cgylfm4xDBfuO86fEt9j2s/ezuTh?=
 =?us-ascii?Q?s8zIFMhq5+WuwzgLvOu88X10a7q7qNezkgxOgalaUqDdiDl1N+o0BddUEVtg?=
 =?us-ascii?Q?l+/1k90pElWvayY8/Q92W0y+7gUP8j8NRmb9l9cOAdMDHmtsehIsqaa7ooz5?=
 =?us-ascii?Q?DWaTYwRhu/8w2R29xqOKgf2DIprPOEWuqA2nNSqwPqHxNwLjHpA+FGN8eaqr?=
 =?us-ascii?Q?GcA63plde8hx4BAZcb1NP/XzIm+5rSW8K03PxLzdI1XXHBCPQljmtuR+jxm1?=
 =?us-ascii?Q?EXfJ6trAg0TGQzuAEuAJPogf+/J7h/otoDTroobzjqgjDmI1qs0EzYl0Gp7K?=
 =?us-ascii?Q?ELCAGbuv1gGQ2Dfifv7bI8NZWBNP7E/jaFgV+MCFf08Zm/Ps6YoSq2dAFPFv?=
 =?us-ascii?Q?saIp7HkMEi1lez/1B2ZMoPPeyw4ByT+GInMP8KaJ1o07G1LbJ4nyqkx0lbed?=
 =?us-ascii?Q?lzYVVgRKqUQyANT1MO640sdyCMJDHI2JCg0mSltcL+lUkYJbbl3XQkyMH/Jt?=
 =?us-ascii?Q?3ts1lDjOI7k2xhyfO9AaEXiYIgUD7uEZI1zBjuKtiavtFY7jbgvfGmDrkAVo?=
 =?us-ascii?Q?/ukFdekrUMpuIX9OLlSfpy3xLl7wa/oayEi3k9jDDG8g2Wwb31tqdMSdPCxP?=
 =?us-ascii?Q?Cu3lMNlvZZ6ogGIRw9u34TrRuWV+85kN/w+V7u/c+83JdCPIQZGYW66GbQ9F?=
 =?us-ascii?Q?h+0XIvhmQXCJA6dJM7GhMt1NVvYikPoCwZ2b8hVxyS5V79XAuE7tPCvVN37j?=
 =?us-ascii?Q?nkP5pTEusCFF9yahewO58RD6OxIpy5bvB9WnuM0qodsA0h4EDkvm9TGIQBJd?=
 =?us-ascii?Q?4TPYBPnVKlwS3QQl5SDoQmHpiFzBrhE+AMKJhoSXVmK4PQdZ526gP73LtiyJ?=
 =?us-ascii?Q?7zVQXf1MDCMr/gKNCPF1SFVTvLSJylaa2Fz+3LuW233l39jplOxRgm7NdKhP?=
 =?us-ascii?Q?HIA6Qu0yNZiiZL1xQFhg4ibxlYSf1zK1gNgFfI71Bp8YLToFDv1nH/q7Gcqh?=
 =?us-ascii?Q?UjIzJIsp98LRUZJSSk7trtUdhFFfNyAzRQqbF9bBiSWu7hGBsPbAunWJBSpB?=
 =?us-ascii?Q?cS7lKZ5PlQt6ElfNEjNoOm+v/g3v225sZY/ooBS3YGVLnenrSgDV0efsnRUM?=
 =?us-ascii?Q?CGTBlgQknHX2ATNvO5yujFNPJR7JEIcgZt8jFO0M7WIfSFRqonNxHW16nvvl?=
 =?us-ascii?Q?GoZCYFoYBJmJI55tNyPUSP0EafBK1Wpr8fOsDjyW086Gu6idzGeurLeUdmZi?=
 =?us-ascii?Q?x9WXTQQaiK0wsn4szuBP5NajR7nLApM=3D?=
X-Exchange-RoutingPolicyChecked:
	Ps05diRv47C47AOobLXPRgoLjIcJ8J6CWZHLNA9QTdCXDgYHu0YKACsczyZ1W2YOd6vGMTJXnTLv6tnWaw8RSmO0Fiyj3oshU3KybSck8YukSuH7ZCsgHSxWKR82Lrt8YilgJ1q05RswaTSS53peH4msDrbAAdPxhp5V5ecIbbldRTBHCVFQB0eeXJu+m12NUIBb3tIjJ1QoRESFcKG2ozJQc15k2yDTRokghFNHAR6lWQyxpSyqIFhEA0e+cQ/iZ7AsaGdWl7GjkVl1pwZz4ODsirXlIIoukvKzD0m6EwkavT87ChjORGJHwKpzC6ivzfDNIMQ40Holifh+/6y8uQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gQbX4pkE5ajJcDelTHQFCCYRDLlDFIafFoZYPTfpCcvnKqmeagyVhgAypAgINdzLiGZNf4VAz93kTxOprqjeo3F+TUI88e4alJLDiPhXarMVBdhF9Kl+pRe5ewnyZpIEK9XzOVkNOFSrmN+WM/saTW5Plmi5cHI+CKrTAzkcg5GGOaIsnbURZDxaH48586NC/IHzc9//ar+uoHX22EarfHC0xlMKw2jch5QtkV/+m2zMKPRhPybMlGhKxp6mo/FY5MzAIOxa+AFiUnYAvbsmjQxMbdMRZawKL2QKVx4+UfbJNAOIYLa9LjKdSmQkWV6JoTUgmUWVH8bMFK9bXoekClXb+7SrdMWZey/dn813lPDGwLm4Q32uTCOGpKC9yBYhVszoaQDhM6oMRA2pDkz6HRCG99oTtzcjh+X5onzwVMvxxNz0cVIQqC0TqVdx3iLB8nhbDoX1Ym6C/2DzN4UfsH9qzuYcOK/titnJcnh/geV9ll75EUf9l0EpsN76BgEdGetpXDMPSVGv09+o4cASX4fWI0VSP0srubetj4Og4LY0Vc+gFH++glalk2vOotmEtxDn8LVBuThHaiUsSy1B/a6hZHQGwAB4fqx8/i22SmQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a92eeb1-2e8d-443a-6586-08dea51722eb
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:12.3685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GCjlPTce+3Pa6UVZNW7MsIoM0kiMK6pYMbva4UNt9rDQpBRJTC+IzrDBSTlYVdA8ijHNP+1iUUzSyN4nSWTnNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f0964e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=QNd2FcQEdVqeu-mTEKYA:9 cc=ntf
 awl=host:12309
X-Proofpoint-GUID: j275KCDBDHBr-U_HvSpiMn2Rrw1jaQZf
X-Proofpoint-ORIG-GUID: j275KCDBDHBr-U_HvSpiMn2Rrw1jaQZf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX02QiR9WM9b+6
 dtfVuIaTu7UpnG+YAVU9KC3ZfLsCvzHbNHG8au4PFhPrO8gB7YQP0FJ/bNIKN4BXCg25KNQs4/J
 f6OYDhy5lKAtPGRRvP5RrC8egFMNosltgakpldg0n6BzKpqn3GKTqRH2qFmXMQk642pVRxxDtwx
 M7FBoP5WkE42fVNqyelGKqf4Pxf7gmrp+xazpuVqwGj0g36dmUX3SkWYtAL+CcMu6cp+3bX3EIP
 CbOyK5/LytIpI8p00unr1uu3RgN6mMaAzN1FreQMHQID4mY3NyQzIOsUqs/Fa9x4Q28ivwaii3e
 v32oBTsF8W4nwbGeMj+Z/W9loM4QZyi5k7LO7KpX6VefVhipPsSW7hV+WG2Jo0Mb+u7fDhYg0Jt
 lCRdvvxkBYo3cB/41tZO8sB8zpPFeP3x9P4Af+EKmWYM+Rc0/njVS2bvzxy8le7rTXrq7JUZhOw
 J9UQMVPIdj9cYhsIIhn0WP4aHjG736gSZwkMBlpI=

These are for mpath_head_template.is_{disabled, optimized} callbacks, and
just call into nvme_path_is_disabled() and nvme_path_is_optimized(),
respectively.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0bdc7e0dbce50..d9ab52a29ea8b 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -291,6 +291,11 @@ static bool nvme_path_is_disabled(struct nvme_ns *ns)
 	return false;
 }
 
+static bool nvme_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	return nvme_path_is_disabled(nvme_mpath_to_ns(mpath_device));
+}
+
 static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 {
 	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
@@ -433,6 +438,11 @@ static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 		ns->ana_state == NVME_ANA_OPTIMIZED;
 }
 
+static bool nvme_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	return nvme_path_is_optimized(nvme_mpath_to_ns(mpath_device));
+}
+
 static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
 {
 	int node = numa_node_id();
@@ -1433,4 +1443,6 @@ static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
 	.add_cdev = nvme_mpath_add_cdev,
 	.del_cdev = nvme_mpath_del_cdev,
+	.is_disabled = nvme_mpath_is_disabled,
+	.is_optimized = nvme_mpath_is_optimized,
 };
-- 
2.43.5

