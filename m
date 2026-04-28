Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06FB402426;
	Tue, 28 Apr 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374947; cv=fail; b=j2ygUo1lMwsrtWd/vMcFwrLiLLRTp51LEV+ITzmREU/T62Zao2Rlk9tOmcNDpgeFeGkmDA9iiEBLkT0cnN1Xm5QTctCbyEo/u5BpJfMqIsjfjy3t8yXNrAcMgZJSS2q2hY5di0YonZ6rgqG7oGgLl7rP0OvmA4vFoGTFisXUwAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374947; c=relaxed/simple;
	bh=AC3I0Zy9IjLwt0lG+18cVSXcAy3XMN3Pyku+LsBIEZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U6LO8kdWDantOa/Af7zXC7MukwKDzPkIzGEKN9F3IVEFOyLmR49ksz/5939bTyQtDaHmOwoCwnTvcfMvIX+GeRFLuuDcOB8hOzQ4/KrBogRDwQSv7TRTETektgQxTnkkzdFM9hQfAE/gYs2rYixa5yilKCv/2QuF2UEsWZUzOug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qlfmCKhC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u7K6OYWn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qlfmCKhC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u7K6OYWn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8KHkp2722020;
	Tue, 28 Apr 2026 11:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y+hk0Y4Y6oM6rF7SESH9WUbMyyAMj9t79S2nlzJRPRU=; b=
	qlfmCKhC+FJQidsZUvQVuyu2KN8zJft83uLre6JTjvAAE/bQ7kyrqG6vkEa8B7E1
	CGeM+wGnKRZjfNRSxEtoBKa3y8Jrt1t31hHuhRoU5HHUxbc7/3InzMxXNSj9Dty7
	PBHF4rIl2YYLxvVjNbWCYElG2WCQLTXHFyruphklptWiH/L2a0kC97Md04n68Ley
	0W5ZI7U+rTIBXa8MgzJU6sCIKf4bkmk7WI+34oWxyaZgoWwRQdbuSmizGDMKpjyy
	w6oTzByEvDjN1NDD38l0z0XxZYqWSM4Hmx0ySpZiWh0fq83tzD8YBJFgwZPg4YnJ
	9bZAWFNp73PYF1V2K0xoMQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drn7t78hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCjVZ030416;
	Tue, 28 Apr 2026 11:15:25 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvjgs-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0kmcHcuHqsbzKoGQRMYFDgVYky6IgK1fKE5IKuEEiXpTw/w4CMrU6W/bKvAvmFc21lv4u1aZeqF7ZqZIri8205BxP+TOzC9oQO0+fyy+EDJ33H/FkNkh1lSh4/H8t3qhABZbBoAyfoIabsevNhb4fIwrda+KUxB58hCskyDLwKFcP/wnOtmwiSgaukbnha7lHfNtpkHJWh4GLxciBo6kWtHgRI5KtbLkAecIDx/u/SZSUBERt3rCwDVYt49Jj/8N5uHTzDrLrNStVXzL1335hpA19zYXXjDuB4EOEzcVpcVkShj94tbhIkS/nzwJbEAu+JbYUCB73T9Lbk9Rok+Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+hk0Y4Y6oM6rF7SESH9WUbMyyAMj9t79S2nlzJRPRU=;
 b=hWhdhq3x/phKVdkfjodB/cfxysM4PIup0699e4Q51LyEU7FlRXLQ2KWAwpEd3qJvxVJ6IGN9cP7sfnRj/h3YRchgAT/mxOFcvERVSYLGfe1b0zPOEXSnSxxSZFC2nf2bvZVz3LMXry/DYOPTklte2f9Kbh43Glw+eOk9bhZFuOzkYXSUPiuwODk+cLA4cAwqHBALefa68OS05BKyOS7C2MqZggsrcRqg8qBfMSHy7XwIdq3A89DHe8QvDqNiJCKQjUgRDbJOk8readv1WqS8IrTfHGuZstLTCPU9+SiMQfzq91cy2f4bJoGBdcy5m2yB9Xdw3Nn790LQacCDDmQHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+hk0Y4Y6oM6rF7SESH9WUbMyyAMj9t79S2nlzJRPRU=;
 b=u7K6OYWnFtIjQxC+MSLwKQ+rQR7BHidZthnTwMsoMEaiAoYpVb29KZxdu2V3Ewt+buIgbwwR8arK6OSM+8T924hBPYfE/gjKDm0nI0Lqbbk2/KFQE2dRL9SC/R7teTPSZoXZdpf8590ZV5GtopSsHTymYMiyn8YMgMyCpgUTCL0=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:22 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 10/18] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Tue, 28 Apr 2026 11:14:39 +0000
Message-ID: <20260428111447.1779062-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0449.namprd03.prod.outlook.com
 (2603:10b6:610:10e::25) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: a16a752f-d75c-472b-16f7-08dea5177022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	N2Yu2tgxnapE1wZHh3bZ/gvn06sFh52hu2uY/wRzbSWiaGjQXPUceldnx8om+TzfEdroq/Ivxz2bddt/jDXvJL47+zE0NSL2IatrcYf2kHk1+4NYgQGe2UoM3cEH2injT/Sv64DflXQ/vWrt5n+hUCydLAIaYulbNahTOI8e4ANylJdXK693d/fGedCetVKrjffjRrmKc6+JzTlNf1ikkTHCvFH4FbKsM/QV0jsXKEjCaUqlMJG0naOBf5WfdNmybqHBQERIUHBBoLqgQ4t9182w+4QJrjIPoo4VWPOeII+mLVqh/VOxK7ruezWETQVX180mPzhKXIDnPHq1EoG7Wg6P+FRGo7ADD6e3F4m1efdtnBqp8AQfLoAP5scpyGfhfbduqBWCgMItQB8MWh+meYTzQ7+eUL4YExBfUZaVrJExyLdtfhYichW/xQceYRe2Bc1UDoGhqtB8I01XTByIdtneNNndMwD3O/Rt5Y/H8F2kSXo0+x0ifu6FxUnMri3fPLOyAnVO3kIyXjCnL42u6DFTlwjp6hMSOtcRAsVKhdEbghrkSYv+teqSmUr0C+aMK3KFq5R0TOKzqBa67aWZUorT96vEhpeT1QVfZojKT7vtAesPB5iHbG13f1uF9Pzus8Z/g0ay2fnUOrffamOSFYN09ZF0O9a+7lFhtS+P0E0+OEhQrjAGvbOrnr/0TbrNYiwNRRBA6WNg3YULjUc8bmcQeix8T0ay2vioNV8Zxzs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Qe3VbdOzAPInW+dGsUagyTgwWChzyiNIrnq8RZSbtiy63gq9FR5k1ZxGEpf?=
 =?us-ascii?Q?cPCFrHpphQvWXvRrDn9NhlKlEoMfmixHsjz5p5WtaGMQqDkG+XTbkbD4mT4U?=
 =?us-ascii?Q?i/UdRW9WMBqVT38SxdXfDUImwQMj41pT354PZHJ4k5K8JdD1rfH417jSIMIB?=
 =?us-ascii?Q?I0tqqyRrNZwPjXavW657yOW9Aia9kGk7wXvknkE1hNXM7FGhsrQ5w0zZ46TA?=
 =?us-ascii?Q?LSzqZeKXCZEFnkJeUgkREVdjTn9QAV4OEG3KGeYcHqm5s919CghyUqRBpXat?=
 =?us-ascii?Q?k/RAa8+LugLB+KuImxV5f3mpv3ssr8YTwv9GN/exz3Wu/9WzxqG7FtLIgZEz?=
 =?us-ascii?Q?0mpNK91BmpPYoM1QzvK+vwz9zpRHD/5omrV/fPgm8Ifafvr+7UzS5VEsTAdU?=
 =?us-ascii?Q?ri1cltiYYBm70cPPoJiCYAzqh+GZrcvNJ5IF5Ql0mRTl/zMKKqyyKmffK/8x?=
 =?us-ascii?Q?M8hr2PCXAmGznJzd0fOfj2UnebRzJhkDQV7K8Rm5zDR6CXretN9BZNb7hWC3?=
 =?us-ascii?Q?jO+Hxb1gZQCHGuBwgLAbxMo7pBWiSvLs1PQ/Y3WDTyzeukKfPU3Mv3d0eXyB?=
 =?us-ascii?Q?psoIkqy7r6jPNEhPH81W8cH+rSno5QVm2VW3lbl0QWTzF9N0NpHGUuJvIe1+?=
 =?us-ascii?Q?znFPTi+eUG33E3DHOPbkg5R/sH/ySTMfuVFWxOaGq0CVtlbPHMCCnH4VbFpi?=
 =?us-ascii?Q?kBuayClOoHCtf7qrvvajSC4U97Irl6xGhdxhWAMrTkPmxpTFPqCB8e0QxWSK?=
 =?us-ascii?Q?LUsBdmD5s7HSus6dMXuBn6qNSOR7LjIIzr71fB28MjxYTa1pBy/Ho+ejGJCY?=
 =?us-ascii?Q?12aQMW1mJ0gOVrJwm/NUyytAxJWOSPG+HPldECNWw0zKU6zasa98eyg3Kv/I?=
 =?us-ascii?Q?AUE5mmfEAaP1hCILWW1OU1vX9sbSZ2D8TzhdUrVIrd56zK5y6OmTClr1TFrl?=
 =?us-ascii?Q?yU+zysAZa8zgbw8Gz1JJOq4YpSz0Ahet6vMywtWDtKO2hyLDCmEfOGgy5GQF?=
 =?us-ascii?Q?lKBZLdMi/aPLInJCuOLuQNsW+RJmK/qaEnGtZiffwZwpKo0Y+EON/6Ln+UXM?=
 =?us-ascii?Q?7k07aZZN/A8EkSHcpjTarHpZsIzCH/DUMvMum3IxZ/4wz6pkElQ/n6Edtgnt?=
 =?us-ascii?Q?r9t+V4F3ljX865jfMwX6Fdbda5ChXjtYkhA/HqVXerxnn/57zYKkiEo5jGsC?=
 =?us-ascii?Q?epkQEFB3yUsgpAos6xQw4ZwtCiEh8a+h9KKXJ0fNgPX0Gcxx4ReNfEVbnpJj?=
 =?us-ascii?Q?OPING7+h9Di+c5a6fc/dbQZ6AIPCFhC/4tTNDfziZjRCO0avIo22k2TQwnip?=
 =?us-ascii?Q?bCRHFHMVOKoBhnwedR2O1ubArZ1mHD/vUSbrLDIjC5zLRU/zvEIzUfpfxHmG?=
 =?us-ascii?Q?BZ2X89W3CZIBsBLHwijd0BjnsRfU8axP66IFZb3NVTjZAJgMOiEQwcJArPMy?=
 =?us-ascii?Q?FMd1iXr6p7YTx/aNEMHSurAXR6wds3BepaP0ug67++1jatHR+oI67ORR250l?=
 =?us-ascii?Q?xPwz0YgajIu77w1ctApBpsI/hDz5KADs9WMbJr5XPKK2l+fbkCcXl9FIZNx6?=
 =?us-ascii?Q?MZiFoIguTXE5RKOrhWgYVs/9x/MrexgRb40MDmwzvwwDThGgENcaYvR/9iu4?=
 =?us-ascii?Q?olOYGGrOTztEcE8E90z7A8g5OVEU19cLRD0oDKpPWUMwlUS2xBsPDqqMfQzo?=
 =?us-ascii?Q?vuVURqq/AIW5/G1c3+4HGPyECq7wsAkgea6g1Shf0/hinE78HOCCAEtX/qPe?=
 =?us-ascii?Q?huxJ1l2pzlvfLXcqc/kR/eauckqtAh4=3D?=
X-Exchange-RoutingPolicyChecked:
	oGFW7wayPHqJww5ThFmYMIEwrnVsA3I7n11Fyj14t+in6G8H2Yt0Ns/0cPsvr4rVwO1X5NbDeJUIUC6QsyRLp4JQgEHf17ni3k53PEMhiViKU73IggIk07hpGkIHDb/R5kZAAppDuEzkciVL59XfQzPhRUeh9cqSkEsEe8P8hdQRGDnyoCf2fqiuFHmxg7m6jth21AkqMTa4UbBRTcW6/mA2hCNRYD4oFLar11rF8+pqWf09pk1o/qYH8ZL1ae0tLmz1kZvh8B3Lo2EDZFrzt0J/Pd5dOHghFymB5HoopS4fWda04Hi2WyM/APZPB9HAH+bVCxL+pkzJqG+nAbXrFQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HTsVxknaAi86foWPl5BcX985DsbANXmCj2bwgZE0uyC1GAlqHbQUndLncFi7G7vPVOdQmT0F46+FuncWmhqDrM2WoR3vYcHFIeTL09o6M8E1ezePvt4nkTfDQIF9JAPx3n77R6cO5EE95VNvxBZ5QqkEzCRtG/gt1R5x83E44kjBwdbJTdicP5GJTq8a2nYucn9AEJjeTieq7WkVDWkc+um+Knb40pUz8M2wxUc7vPN6Mc3Xmiwgjp22JEOyilxVGobWjwmdna7X80tJf/UuYrgN2gt1/8UBEsfdDM3FyLmV3EreqiVzdPk/TWE7hTOtjm67NjcG85IM1XLw5X756FLj+47Vsj0pvPGaaQJzhcLKOpxLdaP8BvCHozurZpWZEz03P1OY1l8rkCp8Ev5LlSzof9o3KTvay02KFxsHLXXt4wmtKDYqHSj86leYo6/cl/W2Lv1QuiWs4F0IYZ15mj1CgRkWkJMlmhl1r/vxlRIOkPgG4SWAIEXc2Zjc5P99qiN5tQPDz0Jm2R7mqvEonmXuLXSCF+jjIS0oUM9InHFxIF7tmFkrXBjNIxc8ze6GywMiCXIWpzhrY+0PBmaw54axXlFqHtT6WnpR9cUGltY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16a752f-d75c-472b-16f7-08dea5177022
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:21.9631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: es5nxlxm7QQ2g5ZFLxYXbOQiqsJrLGETFFanw6HW01VMIE2sgWN0zBvntfTKwEWzrF5PRwdTKW5AJA7ZdPjlNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXwUBvyBQU/V4Q
 U3gk0SIpL/w/Dc9TkvMqkNayamFxTT4OTtZfTtGnIOdbrU4BK6yyBsaYCtbcJp9OoT8Eu26foJN
 oXZNEQ6JOjNM3IxRz+TJMDugzQ9911u8K1Y5CRJERWpUHuQiZpRbzIAXy0lqYMgJNkiMcFph2MN
 FzSiJrjFkL3zmPzThJ9FNoqeCHQiWJGOpOELGsSScNxAI7Y8yjsMdlu5M6m8tqBajGgtf50pUWa
 XRsQRp2bssnMkcrQrMG67h2eY6t6IzSOZfTD4nRxaworQCt6XZuZCFag54FbfelprctfLT1qWPS
 Fi2962/l6u0fENEBZBBUiCPVVKCY1bOLAaVCF9hlcGD8p7NsrMHfdZ3cumq0c8hgw0LgH+v/tVq
 3y+fR8v00b8aW9qCm3XK4t0vUzuBgV95+bTmXRr+FAHOpp1vzXqiiqNfnL3NRvCK9F89tZ3g06a
 eQIetuVp7rJaIbqeW7WtPk8cfgN+neEXsDM2kRH4=
X-Authority-Analysis: v=2.4 cv=QO5YgALL c=1 sm=1 tr=0 ts=69f096ce b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=BcKsWnYKv64lrvakBtkA:9 cc=ntf
 awl=host:12310
X-Proofpoint-GUID: f3nL4tI_V_tC8XJf01IrPcjwm10csSHo
X-Proofpoint-ORIG-GUID: f3nL4tI_V_tC8XJf01IrPcjwm10csSHo

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  6 +++++
 drivers/scsi/scsi_multipath.c | 51 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  5 ++++
 include/scsi/scsi_multipath.h |  9 +++++++
 4 files changed, 71 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 43154f521198a..46ed669c41dc9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -645,6 +645,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
+	if (is_mpath_request(req))
+		scsi_mpath_end_request(req);
+
 	if (blk_update_request(req, error, bytes))
 		return true;
 
@@ -1893,6 +1896,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 80f32b940339f..a2a21793db895 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -564,6 +564,57 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(req) ||
+	    (scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(disk->part0, req_op(req),
+				jiffies);
+}
+
+void scsi_mpath_end_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev =
+			sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+			scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+	bdev_end_io_acct(disk->part0, req_op(req),
+			 blk_rq_bytes(req) >> SECTOR_SHIFT,
+			 scmd->start_time);
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..c6571a36e577b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -60,6 +60,8 @@ struct scsi_pointer {
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +141,9 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d0e1cda836865..fdbdb0e5d02e0 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -53,6 +53,9 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *);
 void scsi_mpath_put_head(struct scsi_mpath_head *);
+void scsi_mpath_start_request(struct request *req);
+void scsi_mpath_end_request(struct request *req);
+
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -89,6 +92,12 @@ static inline int scsi_mpath_get_head(struct scsi_mpath_head *)
 static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
 {
 }
+static inline void scsi_mpath_start_request(struct request *)
+{
+}
+static inline void scsi_mpath_end_request(struct request *)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.5

