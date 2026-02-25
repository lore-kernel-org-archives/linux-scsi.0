Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60449413259;
	Wed, 25 Feb 2026 15:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034082; cv=fail; b=lF3RXha5Jyv8mDOcRrqWoyGg6o3d8nRaU3LJZajQTek0D3q3wqCqqYiFpScQKIQN6UUyBcCH/bSDy7ZWnX6rkjyqfb8WGk0zYVqdIQHQW6IOrVdZTjB0wW1XtGxirXEQhpi364CCreCvlI8UyMXVpar+GhBWfZeKYHVg3u0fDpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034082; c=relaxed/simple;
	bh=WS1kZSWl/fCKtCmRMZb9YdYmbjKOoFEFRBHdWh+nK8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LOTIRjBV0GSB71uAT+B124s81uErL7cTPZaRtCIP/uWCmZysy49ab3cJy0v/HTwNmC/isqbnAPLk09+KGXAYjmKR0zDRoHNzkr12H978A5XgiOMKXwFwH/DqaUARRC8ATCf6cR/Nfxp7YTocnP4Xx+Zsf8EdysVYy3NduqCaEYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eOkPE/wT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JPvUl2sN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eOkPE/wT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JPvUl2sN"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9wt31359631;
	Wed, 25 Feb 2026 15:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6TnP7EGk+XWBF+XXQQwdakC4NOwFWDgTYTOguiucEfA=; b=
	eOkPE/wT8xD9FX5s4noN2Yw0ys9RTFC8Q7H6drtzeNXWW615ObCTPrWiIGGzMQf2
	e5HgvyEx6ispkphvjXV2+72NOyVE05Ea64DWsH/j4k0SjgzLWx46XpX/DKU46J+h
	G+gS3RfKuTzl0c6+oFS7lbg6N88KG46xAoGVB8ZqEtbb29H0iJVez9kLLIbKD1m2
	gcxgZf4c2MH0VBsfx29rMZQC+ZQ4j0M5RgYbGJ3v5Sa6icptIuic1T7aaKsy3o9g
	lNYNQVt6vAALLsEySbwk22i+MiEMB/o20WkZ6SpUroMyKBlOWRN4C3cSIzRaii0o
	JVKHh821GXCV3edW0MOT4A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7xftu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:41:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEE0dm006327;
	Wed, 25 Feb 2026 15:41:05 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bgejk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:41:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzHI7meBspKYuzl1ECDOkUmKQepz16OSFXKEWZ11RZxfxzA0M+7IBPaBIAo53IAJ8T7DifZVg5tsRvzYr+U7PZRECkrZAPJKJom5LfFqN5sI6t0btYs/yGOOCyhGIyFKJyp/st3VKZNSTmh8jKM4CHUK6cWxah4tzWA+JG++81WmqrLBMzLcuRKDJ0GBTeK0ckzrLSqcU31Z5K839d5Ji07MRsOz5b2cTpBc6t+zO6wnLfGIyxY+Gu3JKsCiK8mI8vfbbCdCKN0xoa5gUQhIt0XuDu5RgsqTa3OLzOl3/kajBScprptEThVnyiNs+R5OIBG3I+9m/XY30OBQB8CRIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TnP7EGk+XWBF+XXQQwdakC4NOwFWDgTYTOguiucEfA=;
 b=WTU+zz3xY3D824Kcccb8k59VYvqj9vWQrQ4m1xUlj1JkatYCCPIRdAPIsVlI6ESG+uwlAv9XDGJ5DsDVMN0KwxfyPUvdTnWdq4ttIdsmCybgXeN6rvftxeZgBDQRWGbJs4IzH5uV8wUDe+pVlrH7QTqb+Riz/oKfN+I1fLGBNpf2LR4Vabgi6k4iOq+Me6BiMVD3GGzT7UcI10b7S31W9rBv+N5l1NOGymC4VYImahYaQmrl5GFlLQoKymrmq4JB709sI07HE74wyQIsbABsTfcKprusB5T6S9O/kgW0yG/vMpMeAV3wgZXiKe0Y8+w2cKKKhyyZVTLQHan0szuGGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TnP7EGk+XWBF+XXQQwdakC4NOwFWDgTYTOguiucEfA=;
 b=JPvUl2sNcNwArujU8XZmPJcfNg8oTb48iVH+69gKM1E9q2jNGi2wddtaFAkLLmN2NQXfEra8qbd3yKMNwpRXE1feRkHEwHITn+9Hx7FsSnuy+Q7BsUSs1DZpwIY7Hcr9S5IFeeLfkF3WgRFpLwyRUvrv1iMj4ue8RNTeZUtfu6Q=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB8149.namprd10.prod.outlook.com
 (2603:10b6:8:1ff::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:40:55 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 18/19] nvme-multipath: set mpath_head_template.device_groups
Date: Wed, 25 Feb 2026 15:40:06 +0000
Message-ID: <20260225154007.1033735-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0616.namprd03.prod.outlook.com
 (2603:10b6:408:106::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ee733c9-2be1-4d7a-78c1-08de748443c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	O3NLLbFUQvRm3DtgEEZqnRs5BOBheDUc4kKb1kuCHLHTZd2nc0AFX+z7gGW9FEsI41FWErTnCodSiNSOlfnVohH0GtHgu9aGaXTOyS5axlez0URckVcJOgTNavwsJvBKLIEpKunPdfLjZtWoZjfDMX+tOzFGBBlo2k8zuBfpc1U14B4TmcNOHRM8BGv0DBrRLNcs6yz0V51xv8e25oV8/+ZObD6ruIiSy6I52DBXQZoKLjksQSMO2wYEwnTv9kc20/7kjCRUwWDofEhVZrzk28NsqIXDuOcsvxI369vAUX0zl1QzrNnYzqRvGOLxZ7nSNWcBHURMwb9mDJxSyPbyZtfxS3+VYbV+7ZqFKsxUUAmhK86K0l1r/85wxw+NxYX6/dCM/HDnwIn/ft/8f0Y2w51sCnQaiSfMeQpsVXyDSbGcPx3bp480fYH6q9oxQq71O95hfsQlAHT5Klq8xvP4OrhyLX9BvJAhoYUg1r/NLiJMR3P3H41C+zdaBo7mOd89S6PTVDN7O7Prprp4Rn6QkcDy5aElvHsvGHMuzip+FX1HXEvglT4epuYUZ7zJvYw3DentOsHRVjEvwerUqAAmX3Q21glgB394RbR8gSPcXfPCr1X0Ho3izPlRW0mxnbUbZxPlBATD+I0No0fA+JafRFVWucZDg1+y/8cedkBRRwbm3ou6JVrtwZRLOKle16GCwG+VI5AJ1xCSzTI/FB1muYl3I+N4s/lcLyya1EqsVsw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+gAb9HEMMW35t6MyglH7vJXAS8Cd5818hveESJAIe/cswfujU/ya32mWKQiq?=
 =?us-ascii?Q?n7lfjQoAJ3omCRbAmcyp0Lv2aekzrnc/+UUnhbrh86zPBsPGjsQLK2J7iaHo?=
 =?us-ascii?Q?+cnokLC/KoCTCsNNVsYXOks4z5VdzEHjAkRI0bPhIF1r7nNAihTbCBb5JTDd?=
 =?us-ascii?Q?G2nVvX0De+sOybiFjNeqOw3DS2yS3aVyhJOYWziMUVzQlQrIVOdG+zz+t01A?=
 =?us-ascii?Q?hAQ8SBTuVL8QpbPyNzgW2Pvj+Dk7aKXPfhLTlPF/u3yx/jSqA6A6aMgoeOqd?=
 =?us-ascii?Q?okqz9Db17UjgW64tdCogzgvfIvq3M0hYuTiODModKAFzUEl+K1WKFGzxz5K+?=
 =?us-ascii?Q?qPT73YCQjrQm9ZSGHKvjEalmCjUgVOjNi92jQl8KkjPVZqek0gcALl9NhqiD?=
 =?us-ascii?Q?I3IKY7bMlzcuhoagpJFM2crZFui7d95p8gegf37xbC/u7hgHD//vILx4C8q5?=
 =?us-ascii?Q?JrTSC7lDDBsoqH9nAbo0YOsLdNZ1Jx0QlYG7McmeubPGhqmRszHjOKiFNJtl?=
 =?us-ascii?Q?oCSomw+gbYReHM5hNWkxlDAt1KJoiwORig2r7OE1nN9Ftd3rrP+SOXPB45oi?=
 =?us-ascii?Q?3yVWLAB7jnmm5Od5lpuSS6MyJ1tNlLLI1WFZF1w5Kf+gAqyoxWRhoeW/4Kq1?=
 =?us-ascii?Q?hpaKqCnJc5X2rxk2VA65wbaJG0XFWizWzjUcyfyd8RI1tep6soBMOqCAJjEm?=
 =?us-ascii?Q?EUJQjBz6lrtAP3o8JTyZJgnpHRuoeyjIt1pQ3GhNB2SGPFgvjIcF2dfqP+UX?=
 =?us-ascii?Q?U2BV7fd7KY3WbJum9xe0NDCL4AofV2fqWwhS/kG2jUsXav7lLSdurU0ymwEi?=
 =?us-ascii?Q?21aEYfftq+ttUtVeR4i5qVYxCVma76Ln0Cud5oxtY1kW0429e3Y3Vz1sNa/t?=
 =?us-ascii?Q?wo3Ei9JhDdKNVsP6KIQDPqT5I1qykEgE1c4ThCesurp3LIY/O0ItrJ/Vo02Z?=
 =?us-ascii?Q?6wRixmyEesvNpswPtbSvYoMLvcwYtMS/DoqPnCpQ+1JrUIbx7j6j79jBzm8F?=
 =?us-ascii?Q?HZLyX5LTZ+VUiVu/DwqQEG2x7Hjs7mGQ+IzDCxLva/xYRwyX7tbiqFiLDKDy?=
 =?us-ascii?Q?A40ONXBwnXArvGaIXzbyJkVf7HsfNwnUsJ0xW2G1HLmp36zgyrBTbkD5g15W?=
 =?us-ascii?Q?kKIniE6r1qv74a6irhirInjFaPKQ+ACpWWFouPT4VSIIPlfJs9LeOWZqUXDa?=
 =?us-ascii?Q?3y+NFK1aC3kUAaEwlqckLEopWkrE89uLAsSJM7Jk/kE87Srh5WX6PNoaHMAu?=
 =?us-ascii?Q?wlCePvK7oB4E0j3lR/Sz60x5rUp7V2yboL7hM3zTk9NEVLGzrb7kNA696d3l?=
 =?us-ascii?Q?1FpoyXWEXRYxDARczwpEt9KgmoTWTh9XGvh/ClpALhgsXgt39QZbwxR97ih4?=
 =?us-ascii?Q?oWkN0KxU68PBmQMxGpE94ITryxT0sTaUlTrKi0DYThJq59Q2SeM1hyfwpTYj?=
 =?us-ascii?Q?EKUqTycVFq3eMZF2f191Cf243AcJiYV4yKJ5rUch3b2BZPhQiBqpa02i3Nt7?=
 =?us-ascii?Q?n1s/mbVRO1wmp8wEIp+VXfd1QAPdpfS30Oc8fwMHRcvfrw+JOywzNOn0pbLe?=
 =?us-ascii?Q?h7KvsKOLQYyysMtd8PiLk1VfG6WswL1hAEJ1RJSLjgJ1+cW96ynn1RaI5Dwu?=
 =?us-ascii?Q?nNcHn3Kry2H4BLVOLoxVqTuFgPVY5CtznVG/6IkfIB5rgfrriAECjj/bh9TQ?=
 =?us-ascii?Q?xoS8CioVS+QteS8A4ZcfWgVt4MwrqmdJqnUCQI1t/2AzyJLNc7DTQ1b6Xwa0?=
 =?us-ascii?Q?Ct5EhuLOYYZRiU1To9WjoWLYvVjbPgQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VDV8LHxmtX9MeQY0cMPj3zpASpTSRYDMJ8nJojQqpHCdqRwaVdS6FEq3xLRCBoW7uzzg41n42rftEBHabGurIlp4kUqOuG3QaZV+24UYgbtwjOMPeExd+zak4FRNxd0Vpc4n9fcT+omIyNuLBH60AoI10kj6jSXVGWCPHOy3J4qoDSPRD4BV+ZIlgUlthrBLtsw3Rhfj/6EuBeoiIzLR067RO21692PB27c+TuJuxeTpVmBFTRun82yNKPTMrYqptOIth0PC5GpSC53pjcyVmFDny/LG/kNEAu3ULyNX7d91S/ah7aQmpo/ZEp+pKY4pwR6r6rK029Ek42OGW7BEn1YDrPWnbOQM4t2uCHr6qcg4jLn+yfgx/LRoyhwb/Wga/HbLUxFfgWwZmG2UnIWOWjpTQETQw3HSW8al1ndD9hGITJvuBbHXMhRke6LDWUisq7H/79xDYGVQlKVpIw2lwsK17Xc7EKY0zlIi9Cz2F53ht6yADUEEWoLt1I0pCFsNEhBqsukHi1F07WvnO76slpnU64Y8AApUR8qRHWij83XLL90el2BH4Nu9zeriARMBu6Y0C5Rsi1l2oZxVTotRAJ5b2vvYLtbSphj0kr7l+gI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee733c9-2be1-4d7a-78c1-08de748443c2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:55.5518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejK+MW6qYs23Gb2Ycr4XsEb0dVt/30gh5jhSwvQ6mREZU5aPuqJVqvOa/Rl5wK2R8Cr7LhWYDKMO7Q6F7f7dxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699f1812 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=VmATWuChC3tPMlDHdnAA:9
X-Proofpoint-GUID: CnivKmfMi_8c7EUd9iAB6nA0OxWSzdUD
X-Proofpoint-ORIG-GUID: CnivKmfMi_8c7EUd9iAB6nA0OxWSzdUD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX6H13iVrByyzU
 EdfSsZN2PO08kCaYTJ8YC9DQDxwqrQfb5AnWaixD05zovTkWQB0lsXt6Ary7GwoxxbVee1s+Cqn
 nOSwQzs6XXopLzsUMPZeLixWKp0Q/6e0StoSgCOLEA65yMan0V2rMPd95Xldm9mJZ1b0nche5ht
 tsSj1p+jQFsmQZmRqMJlDwWBxFc0ss0DhxZiBLq0kLdR/cB21KpgraTV3gs18pf57t7UzxEmCtH
 IrSCjCQ9NDXkOKCCDrg7pMIid8adiH+H8Jq/17dVVOUco1m+5XLVCZFnhQJscqFHywJ+c/U75EJ
 MS9l0quPfivHtqBX+43aDd38uvUf3BF4p5ec9NCaSDW7JE4kBjyq1L2sRj095m3nODUKjGvfEaR
 DHTmmgQtr/vpVGEFfTZyoTtvZw5E4JVcvbn3o0jzLc6VEei7EESJGoCvRhnAEoC56Ma28WDrlrI
 77lhGRQs7phq8nZPtSg==

Set the instance of mpath_head_template.device_groups to
nvme_ns_attr_groups.

This callback is used for setting the attribute groups in adding the
multipath gendisk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index fdb7f3b55a197..081a8a20a9908 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1570,4 +1570,5 @@ static const struct mpath_head_template mpdt = {
 	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 	.get_iopolicy = nvme_mpath_get_iopolicy,
 	.get_unique_id = nvme_mpath_get_unique_id,
+	.device_groups = nvme_ns_attr_groups,
 };
-- 
2.43.5

