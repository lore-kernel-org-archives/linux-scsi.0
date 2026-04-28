Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A7D3F9F3C;
	Tue, 28 Apr 2026 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374728; cv=fail; b=cnXchtT7r6SlSHX3xBWx8I4F12xYJYMJmgc3r/EU6LsFUFDmk756VZYZPloP9DifO2GzzwxlKxbRL1MQ7vzujsD5Ty9Ce+W7nIvcA6t5fbBp6EVEh693XK7IZaOAZsChNpVesHYR8HxWYQcd/f/nPxhnIAE3rujv/c8ljDJUFkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374728; c=relaxed/simple;
	bh=8Aotsj+R/Mu8n8kjrVWf5GG7I8eeeVEDaVFilXoD7AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iiQaoneE8esir40FFd71wG4ZQFEekMZLBl9bjq07aHhQzEYwRfZvzeSvXt9d2EAD7ODwmQRedpxCJwLxZC47gVBiKkkg1ZscnHnhIsv1AoE5EVQhSp/glkDtUWTiHj284Mp6IVRWX78rY665sVH6r3UfqxuQs26TbBxNOGCqWEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q9000RbX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hGByxeXk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q9000RbX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hGByxeXk"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAqb401015452;
	Tue, 28 Apr 2026 11:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=h4Ag0pzhG3ZUhMb9s0uerkDDASEyD7QSGIlHpUlSnC4=; b=
	q9000RbX5aVGxr3SSP8E8Q7G+uBzdZGuWQg9CNPRYUvgnLYBAE+b9wwJB+v+mVII
	c+jEhceoSvtZsgpLlB6maMzAutNrRSIFSWQJoUzQ4X2E3vsupY1DQgmJSogJPDpZ
	LKKu1ulJEznJ0shRmbGRtWLgM15+hrqxX89Uwy4dzpINWFUIP6vSnK0FdctZomnt
	z4xnhXwqICFnMaYpCw8KA/qV4ft3soCh9mAQeGFcPbHUdpoOMxSwIhh5+g62Iygm
	fa2tLLz3y4f3Sj2qFFHY3XI2s78+q816Bp3gtP1FesdOpfFvwZl5YaZVSAQaEbdQ
	tqMyA0SCNGvpUZy8w5D3MA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yyjuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2kNm040801;
	Tue, 28 Apr 2026 11:11:31 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cudth-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMD/LKnKkl1kanohBXmF/Or/goPEes70VBFplSaoga6x6rHwOPWNFOBQwL4Ve4xNtEGWdgvXZVQNnrpekzbqoRfQAAMFfCl54qZawWrXOMaP9GNTOzvOSyLOqe0BVkT65sU5grunhJ5Vzf3sGtOd3Txy/k3rsTsEO2joFsuA3PVpzw2alFxM56kBtmFDCN4QPlhSCyF5uRcsM6Yd4xwjlcEQ4yMunBAwUwoPrYSpKpt5dLcW5DLP2zjTIgvYhP/48FS0ywckDkmBMB7jAJb0P5mLwTMhdNDRQrQETmW6fsCH5F7NEQpDE+ubAO6LYgYCqGSAwmSPfobnrnqsFmK8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4Ag0pzhG3ZUhMb9s0uerkDDASEyD7QSGIlHpUlSnC4=;
 b=hDUwyyX6Av9mYHJBnfje9sTtKxPzLVqW3EHYOELQOpWDnWze9m5SERX8Z52avA2Ae4Z1S7okPJ2EiCRb9nKOwOFEhl90NVZZn+Ih72ON1Nuqn52wmiCGet4QvvhRsnxA5LiIjzVez73+uMasKFYG0azfQSx0jX4Ck7P0pxvLucY5NW+jpPWx1JSqSAPPRjNJZGTWcB3pX1V+jVWL9z8anXq0p0Pxuj2QKTwUaAKI6eOUYZWrR804+V77HyLeY4y69sSEsIURRc/ErWtozGnBc1BZ8+gf516gB/2M9xwyiu5JkrT3MGUO8PsjQKWVxm/YF+li55TL2tGprd3YP7PpEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4Ag0pzhG3ZUhMb9s0uerkDDASEyD7QSGIlHpUlSnC4=;
 b=hGByxeXkIFpcEgsDYfOZDbKaDybIqxipQ5bJVTXbl+DcrPHC5lqdHCMaZ65wltMqSEsSZpw3ppScgjLtdwySeB0oz1unsOkOl+8LBFRwcMmadhghwZgrnLyftEkw077lCMLQGeMulDpOGJw6E2ld6HQaWUWQVxjobj0Cop+fyn0=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:26 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 05/13] libmultipath: Add support for mpath_device management
Date: Tue, 28 Apr 2026 11:10:57 +0000
Message-ID: <20260428111105.1778008-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0037.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:2d9::9) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: d5aa288d-6a53-4daf-0dd4-08dea516e389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oT5zSARvYbhsUzQGsVKYy0YLQZPDA41gD2UhGgquU+a4/mVG6E49KDLPyAt9rSS+gXIbA/wWKtMsu0pNGP4jMhNScrdKite1uXcYHGRrjYL4buL7aksxhPo9V73uvq6I6XmPX4wiG+piymd/bB6T2Kz2EOKXSJKS440EI6qbhHQxRi89m2Vn5yFHy2uez+oD+/iqg1JYIv2lwRnUElAGyKyIfLfMlqJw33QoDy6dDzoxAugowv13vPlZDL9jc2wesQ0Y/6N45AYetydTjIjlLTWFFj9k5ndQcWYbNleHZcfASOVBDeMBJUgb9H4ECT03SBe4E1mEbMfAG8pZ9/LnZxcbZPtzB4iGBKLs0ldW/1F2Az+i0qkVc1B4E94T1cBu4dGOlsOB/X3d86JSA1n7XBdSD+yPhryblvsuokJBS37iLZFO9cxfEuYI2KEKjRu/PVjoGteeCxy+78R04lLfzNOe8+f7620mLZ0118gqdg13SXSm2K7CFOlaCkkN7o7ae+v/ALKd0ZtYeeXULq8elTOiTxuDqT9KKdOraBaCbgp+qUwr616mYL0s/EqIdCSabACg19DwDZi8jFFLluEiJ1hNFm4kdxQqUGSLg/3OayC+KKhZE56wqMfcNURsZT2vYrpdzOP4ot/hm6Yo0dI6F1pWmMsRLS+WgyA8KlIY0UkgHpCVc7bkHAA8/q43ZXmwFEiSJzxTZjIeJHsk+NcUikd6Pj9QtFTz7VvYmoqVu9I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jHdzvod5ZJzZJm6b4BK2VRtxe/vZpvuOkyF2Zvtuf2GYwPQutf3qsHHvBA0w?=
 =?us-ascii?Q?ZD2Uwe2u4xeoPjC4axr1fc2Lu8/asFIILd+ZdFaWY58QH/xeogRkIuw2iHNo?=
 =?us-ascii?Q?9AMVOu92jUC9FdyeybSEcGtLAe4Zm+QwYp2RjsoR1T/bjS9O6BNvItKz+UZT?=
 =?us-ascii?Q?Ym33MSODxTIMLInZoU69ZfJ9SZhLu+PKWHyv7+qB+1XFE2IXPuDGq4RxpZee?=
 =?us-ascii?Q?R7bjCdFoOd15Jluxc5w1vjYJVjbkqzrCySLjn0bk/jKVkXKUhhAgRiXkZCpe?=
 =?us-ascii?Q?1IXnPu1wTqPAbv8uowktP+mUOkChuusbuN0abxxHkfS7wuoynrUXKtQlzVWD?=
 =?us-ascii?Q?iTLWlt8FAb7Uk0rvkm2TmFQtYewQKS+zgXN/sp0j+h2fIQ/AOVqD1E4gk3Mb?=
 =?us-ascii?Q?+8k+UxRPwQXgc0Mnq1Ym/zkztBNntKATPgPcFF+z5mVVQoziclHVd3Hnkxew?=
 =?us-ascii?Q?w5ecSd4MdcmwPKgOP9g462Eb3ggN3jH2skl01T4KI808y0B47XM4QLEDDNXe?=
 =?us-ascii?Q?n/iO6Ap6lkPXDexCFecojP41YI0MMSihe6qgKO4lxachIImHNxu3k82gLvAp?=
 =?us-ascii?Q?LjjOChIsbnFo8gMttdt3OF+7it0Yg+gSoTU08sdZpaUEFXmS7hTuKepS01tn?=
 =?us-ascii?Q?A4oLPEvJr/gIweQ5jVxuofgC0K8YeG+sXn/2kZZP3GH2INVVK2bi9KGwslxW?=
 =?us-ascii?Q?2n/Ee1a4UYUDq3glTIDKPHxEa1BDcRgT+YJk+UiYkPdbizCsVf2r6tK+qxXG?=
 =?us-ascii?Q?vgijiheicwONAonM0GiV8k8WfFySVhUVJnUZqtvC2CNWjK8TTpZa7nLB/LPr?=
 =?us-ascii?Q?lF6wwlU/7dbV6kdK9HUxr2X97nnJJt9jfrEzODMuZVFlq3VKqTLgGGR2Ds0e?=
 =?us-ascii?Q?iJXJKoz4xgHtD3C+pcwFeD5W4pdSkC9wmvLOibpLtny2KZzRXO3AAfZEusKt?=
 =?us-ascii?Q?miD54WA9WcJFWkZxRGtxntID4pvPnOt7OH8XvjMd/TQ19Wlg8KC7FdvdBuHE?=
 =?us-ascii?Q?LJ9rQAknicB+3DnJv34HcVnTqgB1eC/MjUzN+atL3mtPcl0HTqzFPApYyPrX?=
 =?us-ascii?Q?yo7qj73N0BZmp38bb/BjYBJ+bVw7Q6HDpJ6Koicam+8n2daB9nAfhUS7TgzR?=
 =?us-ascii?Q?U96TtbG0pcsQeT4SBD7yDJPXCypaKnTMLOc5+mY3DN9bIR5a1GDo5iISHPxK?=
 =?us-ascii?Q?Qa2yI8CgHGNvCNaQE5r5TewH97zpGMZqncF7tOKKiqdsX4vM80Lhe55Cx0zy?=
 =?us-ascii?Q?cN3DZPGiVdWGNo2i5E1x1rytY02ovlmuVh/c2fiJITRK38KJ9kJe92m0CNI7?=
 =?us-ascii?Q?ckpAIC0eFQQ/VLFTXKc1mTo7AUsHYktP3ktzg/7dCmLkNXaE3v54NOoUk9lO?=
 =?us-ascii?Q?L6OaLatWibrNzW46lmhqFsutKsr53EZXqIWUJqkxZtUswYHt5UruhupRMmJZ?=
 =?us-ascii?Q?LsXZaj/paLfc2MBibnIT31uQjprpsInXINlgqMHq6CjmEyOFa+LJ/J4y8oxz?=
 =?us-ascii?Q?clWbiL+9jrVsV+YAKQOGmx0H4KMwH3DVE3TADf6eIf9NtKU2q+BXIof3iT2N?=
 =?us-ascii?Q?PN9M7EnonCHbbd30OEUAYd+3LrNm+65wD7ho1Jh0X+4GTN1HSv0Sw4yWtpzE?=
 =?us-ascii?Q?cp3KspKx0jE71gDGGTiWO596CpMdUXQAgCW8A6MBw3Lr7e5Qd8WuJAq2luQL?=
 =?us-ascii?Q?ORmGzbo5JPdi8YOILJYWwz6F9OVi8dmcgNivb0QEMO/spiUCgmTT4wNZSfmp?=
 =?us-ascii?Q?Y5oKJLxtthvAYShMQB+QAwsSP2senf8=3D?=
X-Exchange-RoutingPolicyChecked:
	VnDL9LpwjnJ2F2wUH+jx3618tTH3PpHhrqgRJxakLPBVVBpCALYijS+0BXef0M+tQtZ8wlWVty+C3Wpm3vVAnIwUhZHCIJ8V9e6Nc6Ad/T01t3OubF9vOHct3TnpEVd26KffN6CM6IZimyJX0NBXhJWvMxyf1P08wFMp9DeS37sIqBE2iXYBxg6+/9MCbjREXHgf/3C1aVphc8L+x1Cj8nrohDFhzdSqnUvsM3FhsRCPDnP2GSl2bK3cIbWyWc5zU3clsggMGRUXSif/YOMuc9+GkNB2CPto+DpuVKX/11LW+6WAVhdFN7extqRrmjyD4aZSlaEaqsQ4+ob+o4vsIw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tms9WHtJ5DaCkMFdLrk2xsSnhx56vXOR5QHZ0loFFxDnOo+BD9+uMMs1T5e0pgrsEhgQLN783dA5NoSMl0zj1boAExOxu7qtkGt2kzXR/ZLc7eptJIgJnQxOwGDJscz8pp2Sm08pnxoqowhkBHJq/s4KYbyMOr8+Ew3KW618oQ1pMtVZE8jaQISO12g7hieDaMY6wpP5NCWqh4/rFiJ9fEebCKZx5eoRRzfPTuuDTj8ING9ot2lIQPxWDgbFTPaSDTwh+8YrRyVF3k+i4q+BFNV0RLYOSRvZ3WE0mz1XFA5LH8RqP2QV8SU+I7m7tRNqzRaBZx+YP6fTxEPGgsED+wX2pdl+n8SFMg82qpqWt5pzFKOW3+7CaRImdAOyTiPnjVGaN/AGFOBJnazNMucX9C1am3pq35zlFMPaMzEUhHOH0SvxG0sPxqEkTtV9eKJ7GZdYRqLkCbJN3Gi6c1Y42UQnr0hXdQR4GwVfxI9ny4HpxKGvWzI7QjfitQuyUr6k7BvW4qg11RBADsqpI3hBz49vIsrzyYUg4zTdzFM1cF0wc8d/K7HPPVZIADrEBoONinfh4BXTD2wtZTD2hSyVUo5yo+Yk/ATXj4UDDgpAnbo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5aa288d-6a53-4daf-0dd4-08dea516e389
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:26.0427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiLUQzCFKtUgnfIvf5hGa+IMpiLOKXk/QtwVILX1utwEnd5guySGgPP2EYcPcjtYiE5O4PlBgy80ScCK2BZRSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: aamZ0SxR84lDyt-sgGauWQcnaWpW8-R8
X-Proofpoint-ORIG-GUID: aamZ0SxR84lDyt-sgGauWQcnaWpW8-R8
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f095e4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=ldRTlTcT5PaS6-tWTisA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX2T5MTdxVDcMW
 6DjAeL4nMJbk0vW2/v89ajeGrHwjIFTNYhbEaEXcZ1Q9uHo5do8V7fOfSJGrBxS46LbRnNnKtD1
 4D/tIBhZVFfw7e2wNLSjeEoYjtKj6TlSKyg0uH3wP7UFzrHrNmm5uohPGyw1h8+oDO2K//Zy1Qt
 HbFBQU81/Rakwuxd9RTEbzYNEcqAQO/7Fs2SnKNnwivY3jzlhKXs2QASp+htuk/RKIp+GZ/CWlk
 bTQcC3i4ecdTpSv+N04cnmytNSFKlWLbfAOqPbTbintTm7PzcMvFnFDPQeNw4aWw/YH23Yo0T0w
 CTCggdtlutnz26HUI6D5nDALj7e9ZCVbv/uPIKy9P2QjNWKsfmPTdw4LxcU6XgzhKlcKdyX2fZ4
 /VT0tdwKcSmunQ39kK2DYANDh5oFwX4uA1MbkdpkVpDKFKuDoBt6oqExO87qo0VTKovCWyB2yX8
 zrz1+I+dGoZwRGGQebA==

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

mpath_revalidate_paths() has a CB arg for NVMe specific handling.

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Helper mpath_call_for_device() is added to allow a driver run a callback
on any path available. It is intended to be used for occasions when the
NVMe drivers accesses the list of paths outside its multipath code, like
NVMe sysfs.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  16 ++++
 lib/multipath.c           | 182 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 198 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 2a5a9236480f7..72186ab220083 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -24,10 +24,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	enum mpath_access_state access_state;
 };
@@ -90,6 +93,19 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *val, int *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+void mpath_synchronize(struct mpath_head *mpath_head);
+void mpath_add_device(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+int mpath_call_for_device(struct mpath_head *mpath_head,
+			int (*cb)(struct mpath_device *mpath_device));
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head,
+	void (*not_ready_cb)(struct mpath_device *mpath_device));
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 struct mpath_head *mpath_alloc_head(void);
diff --git a/lib/multipath.c b/lib/multipath.c
index eabf1347d9acc..1232e057199ae 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -46,6 +46,115 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+void mpath_add_device(struct mpath_head *mpath_head,
+			struct mpath_device *mpath_device)
+{
+	mpath_device->mpath_head = mpath_head;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+int mpath_call_for_device(struct mpath_head *mpath_head,
+			int (*cb)(struct mpath_device *mpath_device))
+{
+	struct mpath_device *mpath_device;
+	int ret = -EWOULDBLOCK, srcu_idx;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device)
+		ret = cb(mpath_device);
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_call_for_device);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+static void mpath_revalidate_paths_iter(struct mpath_head *mpath_head,
+	void (*not_ready_cb)(struct mpath_device *mpath_device))
+{
+	sector_t capacity = get_capacity(mpath_head->disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	if (!not_ready_cb)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (capacity != get_capacity(mpath_device->disk))
+			not_ready_cb(mpath_device);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head,
+	void (*not_ready_cb)(struct mpath_device *mpath_device))
+{
+
+	mpath_revalidate_paths_iter(mpath_head, not_ready_cb);
+	mpath_clear_paths(mpath_head);
+
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -449,6 +558,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -465,6 +576,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 struct mpath_head *mpath_alloc_head(void)
 {
 	struct mpath_head *mpath_head;
-- 
2.43.5

