Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2F046F4A3;
	Mon,  7 Sep 2026 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778315; cv=fail; b=nV5Of3K3TC2MN5t9pcwWa0Jqtxxt9O2lSEKQVDiZ4wyx4HRCgZ5MbF0ac3pPCN27pp7YHEPsLqONOqLgxEkNnczJ1Dxhtt2d0fRLXlDQDD0ESdGz1Ro5bx4Ok/7pTJLhD3wTr3bPzaSlNXM3HYM+1TwwylzkgVHTMWMYm29D/g0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778315; c=relaxed/simple;
	bh=l3Jx527Njv3LB2p0FnrgaL31M3DwO6Wwp0N/7KEesfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GS0Pq6cJ3Dn2oCpIwcq3tdsrw+wXANzz1qZhpfJpj5eh6KLaJzcvuuUVpQc97Iv3i20jD2JuGAh2OYZfnNhNsPYexae/Nzq2s9dzR2K2ufjoTou+zjQ8oTyeiYelRXBmelBckYIqr/YwAJFVNds66s8QLDhrh54+94NNdcjbFZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GnLrAQUj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=szs5w2kZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GnLrAQUj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="szs5w2kZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6872umgh1096886;
	Mon, 7 Sep 2026 10:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2HkUozqt65yLP54LrOYLAmfMxqTb0yoKfg7Dpwq68d0=; b=
	GnLrAQUjs15OBkJc/mhtsStbmBk7e81GB+4s0BaKEbOxeSQyM6q3LPZhEChHKkrq
	0Eq13ENwHEm5SOvx1myMSN5H7TmfYi9VlcvJoz6pWPh98JubsfJAtb905dubFQg3
	dOH6u0tt7i3jVIb0p7AqlytalufdtRqfAaT/NIP2XgApygAnwqh34n0hbQkDgYZY
	Y0Q350H3qaHn5G02YEjZZPWALVyu6CL7IQa9EsgWayXugYpwDX+LTRePBzTIVawp
	Z2xkIyT3Wu7Dd7ukwunEIZ0ZrJ1WZCM2RRpj9jwfCcLro7mbQnNztckrAphWfWKF
	n8HwoyXIqPUVrAr5xXL1Eg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbh09twv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfA019106;
	Mon, 7 Sep 2026 10:51:15 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dt7yHZckVbAB80GTQE47W49hxc8HlJAlYO52tTi+LyInyo+BSw0QqErH5TFLoPj10X56w75ZtKy2RL7j2oQ0OWTtxNG1hhNyxt/ShNRIBGESzD2U7kt/t5GKJ/outrNU+FK/InhbhfKHqLEVQKYWJZxFc0bhXkpvWRF6iMgSVReklyrHmy5YGtTnhgj9IaFhutGFSsKlM1BOusbr2m5E6vj57JUO5nfUTHB5BDoYfyeZciauDTFeaRUK3jdiIPoPqDX1dL/kcr5E1yswpdSdaNUfDY1nizIEI1cJKcpOzww0bGpVu5ASbYzRuTcrRCbLM87rgPk1Qvas1BvbjCj/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HkUozqt65yLP54LrOYLAmfMxqTb0yoKfg7Dpwq68d0=;
 b=YElFYg/QygFYKzTndKDmKrypBk7E1IBnHM2MlL4XC6bxc26uoGV2SvVOttcz5V96OQU24nMwwdvVUCJA09mtB636U4mMtqKfJ4KBsP0tovW3HM9Im7BUX0YlhSK+vWDqomZyVN/5StoWYIt3MkH0yNmWlcyebD09puCw/tA0hiuktiHQnVjIGwVqh0oINYW5Dx9GC6HRiYDJkRVKgkhfxwO3DbAJAupcG7AdSBkQagkKKv4qMFxQtfzulTzKE3kwZhVWoMcqj1SkQHiaAxcYCWhwq2OwiWtQ8HxJOb9qyNBe4ig4+0FR74/PBaB9G4T2lUNX9mnqidml/v7nvf7VRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HkUozqt65yLP54LrOYLAmfMxqTb0yoKfg7Dpwq68d0=;
 b=szs5w2kZUZWlTiuv1/MEfp0IRiY9PYlEiDVovOe3QjFP+Cd9RMJmf8bd7SQohlDjkBKbywsvU3whSGR62fc2BHFQMSXIj1Q0/dqomUs1OWQnYE0icAP5xickL+I8+mLUIfnAZmOGG/7FdA0nUcJbpVQTSoW8dUf95+w4xH2htxk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:51 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 08/27] libmultipath: Add support for block device IOCTL
Date: Mon,  7 Sep 2026 10:50:02 +0000
Message-ID: <20260907105021.1763236-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0049.namprd17.prod.outlook.com
 (2603:10b6:510:325::26) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fa8300b-95f4-44ab-d7fb-08df0ccde212
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iSpXNGh5vkxMyvUPtzNOscaQWURH2Ld1XlTPPwiX//bdv7GbjP0QPvRasg2DkxWMkC/uBlN/z9vD9d9iLv9tVMiqETRkqtqsQg4eJuoeoKRqqlaAN6H+m+zqgYn+eatn7K0glgNKwhm7B9LQYmHzcp8/Wm0Fx1XlDyzL6lz6vc6p3u4r9ziYP5lZp+yONEsNDblvoDGBeRMxC2RMwMRQF9vhEVkddeOYG5ZRG8nbx2xKFGRtQFIh8gt6qNnnrBKS8fHxdbQaZz846PLB8zWvgH/Hd6tzg9BSvAAOjWegeQs+xBkuyUFbgpQGjBruN2dUXxPZpntuTMkx85AUKamoroqYa6z8FaRAGP4TzDxrXJ1d4xTkX3RUvx8PKVKFerC8LvkKRMYn/RtLtPr2Z2RQ1YNjXFxuDwBESyuoiZVBB0mmd+hNMSkeLUaiSoQXGFQeX9qthR51arJtmKXsLkzdObBQasNG1elnxR8ot+bKs/qpKzrxAEQ7u3pfOSaTzkwC+9lSE2Vxr9GQhXrxTpoYK4zvvQfIbH7PSG9GG2/qF6vPCXd+U8GxWInU2/CgBY+DSJdpNt0MdC31pZJzrOr6klBkEsm9nsrf+7LSphK5JazV4Y5hokOh4h9nwNX8CePrkqQrjjDabrhyUTVONt/RhtJWglnTO+y2bjuBLfcKHjo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wJ/ZIxbpBoN/TUMnWel63B4uDPt7u3UKsoTR2bsqnpafTk23GTJgb9Nw7hty?=
 =?us-ascii?Q?p8/PRBs2GXbSBYvSXH76aaw4gNwYuTn+48UIkc+bZNcTMFX/s9/RQdJkzx5F?=
 =?us-ascii?Q?KW+gzrlK8+aZYNpb4EKyTE8pxlv0Qr/Al8JeK6+sL2Pl5RIL7Y4C9Ny4Z+9u?=
 =?us-ascii?Q?VIW1rBULYKKAapgeQ84T4bJZk3VDo3vjauaFz30kndarlTmQGUIFsXxRJk1V?=
 =?us-ascii?Q?be3aQE0Cr2SDOTe/l/j9CtSzcoKJI/fklgu+s5e658L/9LuS+a0ZdKhaT7Wv?=
 =?us-ascii?Q?9c6RO+uVJHP+4FFymw/vGKhLBwtYwYC0RcLcmD0+F4yGGN37LIrhoyayGNxG?=
 =?us-ascii?Q?9zFCVnDosh2ZfimQM/uZnhQLs/1cvfdmXI+qWgT4A7P5UuBpCcVYFuGqTxmP?=
 =?us-ascii?Q?63HS/G4hHqg/yIQH0yZ+q2bgjaI36n4Qj9U1zKf/751/F9bt91oPGS4rPuQG?=
 =?us-ascii?Q?tR6LCL5C9KD2sjBw9AmqGoBcTeSQE4bOZZkpPiK79ZEmJT5sb+oNSi7aI7Qk?=
 =?us-ascii?Q?qESwZjXIa4LK5/TvGuzlOoGCpPKriv4nx12Mk1h52gFLfqUIMYBV1cSNQFSh?=
 =?us-ascii?Q?UpFuA1VLnPDukJEZTgvoLC1stq8pjLAjUHxVvHTKTm1rB1l95FVJsrIOMbvV?=
 =?us-ascii?Q?WfVbTx0i7yvSYOaEVzwNLf4OXMimMknqYRxGLLaFTdaa8pxhQT7XtFgrnDUl?=
 =?us-ascii?Q?fnmuDb6lWS7yVlpd98IskFZyngle/9wr5yBwn2wixHTlhxcHwe0XaUF8EmpR?=
 =?us-ascii?Q?Tr3SgF/TrK1VbRSFQWlcWrK4cA0hiEoX8/G+KnDwDE2OBrsh//TRE2wBvAtv?=
 =?us-ascii?Q?+IHMrvbE2Q7L+ncS2/bi5Cb/EHvOrqXaSmZu75vD3mzx48dq8TK48ZN+R4nm?=
 =?us-ascii?Q?kEN0wUYTIuwbqT8tA2GdUMdVckPCPiAi0JvPgd/go0CPxqq43N8jDiHUWTWz?=
 =?us-ascii?Q?KcyOLSklKHlpKMIyoapc1I1h0qOyT7tvfretXcgksUCGTBRL8nms1zygXcxv?=
 =?us-ascii?Q?YmVdZWCvg9aOjj5e7aKS+WVsPSsQvv/4H3MLKjcwYjb5rCwYJ/4sYQWOhzgr?=
 =?us-ascii?Q?DB3qblBBccbQlcmbEfjJJUgGcltvCdK5WAmMLR6EHuu/+cLAdoDzJZwk3i5N?=
 =?us-ascii?Q?yZUcQgIvvck/E3JEwPMLDdXSgVYxqunLiA66Xl4i9CH/JxK1Th7KR7eQlm19?=
 =?us-ascii?Q?kPz+iVMzqJQz92Kr6I3dGk2m3+kj9ER118tkR2rPFLYEvPJupiY0/9Od6vmh?=
 =?us-ascii?Q?Gd9EICxCbE5kHAoHIzeLALyrCMdqfbTTHtZUL3/0X2khbXXWhWLWEdi3sHjr?=
 =?us-ascii?Q?ExjVsuT2vrs6Y0b22cAzDx6QuA2tExIA/GCLFRO6M0yssgp/4uXmsh7vppr8?=
 =?us-ascii?Q?2EBIu+sNqLgjQbZM7mSRzrDJcURLDRF/MFa+GGyctpY/3S3bGKr743t2NJbE?=
 =?us-ascii?Q?c4kU3J6HVIsIVaHCFT7Bk5zgHUKvY7Rmyvtw8wmQLIXanZh4aR09jixVGFxs?=
 =?us-ascii?Q?Qwvhn9TbCfwGnC8jZ3TKUJsM0PECEMsdhdGGe79sBcemZL24ABOeJlz77Uch?=
 =?us-ascii?Q?QZCn5/84eYOquUiEDCiFki8qr4JI1plTuslPyih0GthAAD6oFaaUdMmQlR4H?=
 =?us-ascii?Q?nOchPWkszSm31QfSvAne2ZDANqkHy3q1K4ZpPbcN5hrINt/YUfIApfyUujs3?=
 =?us-ascii?Q?pVevdILukM5knAeRB8Z0kRVVXqGvIIW/vlBToTEQvHD4S4YaPQuKYz1/bUJ8?=
 =?us-ascii?Q?4HU5JQIi+w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	1IGMzPyFFeE+MEd1PLinsQYjAV1Zq4ZhJgwAekIOp6Me9npqsASkaoXdLt/CsgLtwHJ6U5FckCUuoR45TiRe5H2RSU7EqI4D1zCWm8vkNNguferJLJaa7GD1n+av951xVFVa+/jE6TeyM8eZJ7jwg4e7S4lP+h5/W1ADAzVUh/+9SYMfzSWxVHWIk3jPvhusZwY1emDJAxht2AHTbaebL0UBSsod2pTa3VhSc76638wkN20uhI9dXFgyaP8gJMMSh40+QhMfG9m3x1CIFgR0UwiixDcanNlIKX3+CA1cK+QnGcUVI1Nkvtkhhj8sDISv3mZXyIRRzg5qAfFwTTmS3w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C97Dg9OEwgMcOUeGyFIDEjxuzommWMAjuZganbFNFVpdgOmFomuWM2YN5TeaWKy6IOQB3jh4beoywpFzMW4DQlvGHasVit0WlzdnmZle6H7ca9a0Ude6ozccJuJzgN0MIA1lhATq5kGx/K4aKJSRsaauAuEQbo6VPTQPioIwyyNX2oHkgvI//1DcfpZknJ9HOgTG2VVY6lMIM6s4D7RgB2PTROxUVeZGGERsoCeXxgFYYy3usF51PgDI6EL71USLgQkkRX/w93xAYrKA7eE7YrwVryG9197WEt/37or/Q8zsZfdd+MG51KdQPS5KgdQWRI0ZrsIG2Gzd1lDyVrjod4+i8r9I3I38AHOyMXAtZLbZgVzsgYrPQEXg6tV8WZnZ3YCQh5O3RwDDrhc8EawjXUVarDZ3n4Edqy1dyfaruShKWty+22YOuiOWWIriRScOr2LSRO6Obf6clXrLt0C9I4KpbOvyxzAC8YlYvfkPYW6Q8r5G/cVEkNa3P4UIQSgf7r7pC0VlA1cfT9WEZKh8OTQjhCfxkgR5728nvaR9oN5Vyuac5AVZkrEuiOdFtPZB5PW54sWAB790DykJb5xoGYaJViJ2M+Ck8o8RAHaVHlw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa8300b-95f4-44ab-d7fb-08df0ccde212
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:51.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DT2f7mB4BIKwnFmDu8llZzUd50kBENrwOMgsFTae8lo227ilcKv+e8OSsjjen3QpKSEIMRhU0d0kPx8HCpbZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-ORIG-GUID: gIEW-AcZsupSoElcLVhqMWn4rHIRq7Vc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfXzbKuNPQhX1S+
 a1RzjFPEaPXY25gFYPm5/eiZodgC0up7ACdO+PJvxc1x61NEERfcNiH1mzkXlbMmUkG4IvyWosT
 bVcsVcMFexOtIs6v1j8otVAEvNbLYeWrQG3IrwBjGX47s94uMjFwz71I85sqdpF0hSuNEs7qAXE
 PHyspGWBJjo1XpwhA1KwdMcClhZB9gcK5CGcO0ncx0obS75C7OMv4iC8LJLQ3jy9Rd7Ou3W5c8O
 zJUH68F7Ej0nltUhZW+HV5FLs0uIuOmhZov3qNgK+fXoYN5HcUhrK8FvVTMTCKN38Rqh/clI3mD
 U7MCJZ99nabddHVTbcG7Ai6Gv4veF5uNECBvgSTK0E/wgICeV4DvnLUuIr+NVDvFGHL6HyOjUl7
 uCbHyd9ugUasC9te/aAwJpMkCisoOAbfuMXna/mFDTS4/VkLVwYYQti0ZvmcSr/j7T47UkHOArz
 9u0OLY6RyhbA2Z3FoCw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX143BYEJfsC+J
 GygMKRZrVd/jeKENqqXY3gFKZzlXaWAlHsZXG4jQw2yFD9Xi4j4WIc4vWhf+VmEWxqFZc0+aEwU
 gQjZZFktWLMBCsYPkykIKCQjOi5Z8OKqD/rxQ6Sj9c8MqFHWQvHz
X-Authority-Analysis: v=2.4 cv=GKE41ONK c=1 sm=1 tr=0 ts=6a9e9724 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=6nTNfoCXqZZSb6MP1VAA:9
X-Proofpoint-GUID: gIEW-AcZsupSoElcLVhqMWn4rHIRq7Vc

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 2bcad0a9fda02..4afb55b5bda51 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,11 +454,53 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	/*
+	 * This check is duplicated from sd_ioctl() as we don't pass the
+	 * partition bdev to fops->ioctl. That is not yet possible as the
+	 * per-path disk is hidden and, as such, does not have partitions
+	 * scanned.
+	 */
+	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
+		return -ENOIOCTLCMD;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -ENOTTY;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

