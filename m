Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171EE3AA1B8;
	Fri,  3 Jul 2026 10:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074796; cv=fail; b=HYz35rVRtyxYrxQQPbRA2RvXSWcsZqONwmRB9r5/FZSlE5kEe5GVBtJf3kHmqwo2rO4Pg9Rza6mk3RJI6aEFDXACF+3IJaI5fBxvAkUrsescjus9q1H8MCR3g+O+qYQUxUWquiZ6fqVj+zLbUhk0oWZBF16WIBA+ySSbwte4Z7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074796; c=relaxed/simple;
	bh=QWCBZvUx/tRRr1AKzXxkEuxwIF0IMX7dbA7FxJFNe3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XH/2u4ULIEErIpGLl7Gf5qyHI2zk8Y/D37v7yNPFDa/+uZk/ahARE4Kz0CBqXFan2cYtPhpgei/AncbGrGRcz6cmHWehyknZ8bCfN2Z+VTW27iTto1WHu3/lasnn8D/ZlecptE/yhJyFjFcjv74We0NrPsQvC3ZMCzKze0wCKRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g6EXF0bB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fFWmbFDa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g6EXF0bB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fFWmbFDa"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tprn3329559;
	Fri, 3 Jul 2026 10:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DTv4LdENgc3g30L+gp1b5mSk2AVZ48b4TuIBNDy1Y4Y=; b=
	g6EXF0bBEGiD6alDLtWRuiNeLJjoeqpX+wTaSMJCNcpbmV9/ENI2FlhARefp5abm
	Hfbk3lsNbm8S2MIskLypA8iCOaeofk7lUwigPyYoeETq84JkuqfLrKOwKCl8gte8
	gNxgPWBQDG+SvJYS3oZciWpOLMbltFRUmnqcNFpG9XpCPqGUPyya3/sDrtQ1iUJM
	3VtUQVLx+JBqYlHwjzHf4ncQLqGWLKLZcYP3/r4/VzvqMcs/FmrmxzBVBcS3JCfe
	tPmr2A8McUxKxc/L2vWnyHDTpvRvsVYoPDMAJ3G2YhtGvVHFmIWW78WcAy/jwWDp
	jst3KmjC7qXxdhOSs/zfYQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkae0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663ASTmQ035035;
	Fri, 3 Jul 2026 10:32:26 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013053.outbound.protection.outlook.com [40.107.201.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yugvde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=of0mTcZNNyHNjfzsm6j2pxdDno1vk8CNkJGQ/m1j1PI081oNlgoACUag4Gd+jpiyQq2YiZSN4B2r5WDUsQsGeai0iJZr2WCCZjuZXED3e99E84x54sSLbstOKj7jfjLui30HWBXycXir23/334FcuNUHGnSVD17+mlIFLhBys++gmch48xB2r2yDTmX8+r3FCClBwxIxLOLqpaLG5Gsee0NKQmLb2NXBBszEID+K3o+nRmQV5CKG5OORCoKNcBdpy0A/fEl0GgOe30EeXA2idCpJ9JshGIbeD8EnkvXMeQbF9bp2QcXc5fVbnR74ut/5vb6NRWZJFU9l5/GJSycK+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DTv4LdENgc3g30L+gp1b5mSk2AVZ48b4TuIBNDy1Y4Y=;
 b=AGsJalSnJXPnZnZgEIXxPTK9PLUqWY1kCYKH98nsz2Awslkqw7fjHDwDeXrcGyTsWrV5t5rDJZU7EIS8VMzGLr80t3PiIWZ/kSUCRs3YK3rHUEM9K2yLgCe5lsIFJlTczlHNnOiWMXQIUAVF4yZ1HpgABkieOPf8I02pbvStdSsY0yjXEA67NLv1XUXTtOT/gADQ1sL1niMX52rjCW8/xTOObvBalRmuetiyZASgtKm5r89OP7MLaPvRwAgnckwXgp0GRSrLZ9EzIEGKgEuqyG9oZYBynBH47ZCqgW8dsl1m8De/zEtMrNIHICv6XryZ4kHOMLSPlwXm7STCayHkrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTv4LdENgc3g30L+gp1b5mSk2AVZ48b4TuIBNDy1Y4Y=;
 b=fFWmbFDaYz1pcZWqnd+EOUDmeCqAsU0Ww1jj2DriLM3PvqXmcEOqM+giquHrzikfcP9Qw+CY1a89D/B0w75SrKaqrnXB67F51TpEdp4X7t8plcaoz//KRYvUv8h4PsKt3JEaVPYvYNoGqxyjLxi25DjYOWtvs+S7bmHPFbhH1eE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:23 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:23 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 06/10] nvme-multipath: add uring_cmd support
Date: Fri,  3 Jul 2026 10:32:00 +0000
Message-ID: <20260703103204.3724406-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103204.3724406-1-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:8:44a::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5da81e-731d-4627-3590-08ded8ee5e16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	W8gpH2af4EZN0QtZoO9CJZ41gG5HP9l3OqGjcoDcgOe/zpuA/DJOmJwlXeoj+jWGYfav+RFOP9hHccgfhJKppOyUtjCU1Gir1nzi+p6sL0PnUqNM0LGRlJtygIywcHAT6wgg7jrS5dlLdGRX0Ns8BYknoU32f7wy/jms8tlN2ulsmjqz9xjF89R90gvqkQj7TxCH2i87FSeckNPy4wb8J9r4zkac6w8XChGpxWNhxB9PQnliHc1mM6W8BIjuH+Gaflvq/QPuLGgTfm4tP6AXpRZl2lZ60Y2Z1g48QMv1F8QHliFbH3SlQez/PGpGnH2OSsASNUK/FYNWYZaWo9CwFU1j6NZrwfGodmtQVcBjLAMIzS/pbq7DN2nc8a5Ip1YhkcIPSFKnnhmQrVh07KLCjACYGFarorpsXq10ycdJgJGBnexvmTYoz8GUXWo5oL5LXkGI3s2iNILf5NK2LQFgsJjXHTPBN/ZUJuRcnYw8qJzbIRvDKgZH3CXEtHHijugTm1VlDLp/rCURSJYJnf5OQ65caxYyTeIRtILmqs7ltwORoRDsXgii3ZOFT9RZESvL/x4tuA10dfmsnZ9wtfoSK2C+NWzxbIULqd9ZsVkR8akd4ExhvQwlQppZ/wS6Ogm/Eo5L9d82UmHg09u73FXXbAgYSUqWJ4O+gr4WHH2c7II=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fDvyK0Po89ZF2f3xvx2vWAC6+WTchXiDxl7yaWYaIZ0/7OyUUxt37h1Z/vAU?=
 =?us-ascii?Q?fSbLOW7zFPycVXTHtfw5x3zSiIaWkulQXtGtaB9whgmr8tfcHRSQ6NZQL63u?=
 =?us-ascii?Q?NWEFCpUDyGFCw3h5M3wFJ4fhIBtnzAh2iyvPgbEXjmkL7suX5wyaAsYmrI3Q?=
 =?us-ascii?Q?tupvWOrQRj/LU9rQBLjV8i++Lbj57AK1aBJNQarm/KuiFcorwK/FmOHF/Qz/?=
 =?us-ascii?Q?gtDWpJgq3Acdl4wLB6OjtqbofaGor2jrdEsABtoymyuubxdR/cCZkfs/hers?=
 =?us-ascii?Q?5Viw3H/qqeb+WHx7v9G0LEMKtXYxrL7S4baAXKN2QqVTa6cjuV/wBZrl64YM?=
 =?us-ascii?Q?rEwhoaE9SOzBvjJ7D2iEc+6H52TNkU66JS6vIo7p/YuoIR3QAyhEhHYWiaLb?=
 =?us-ascii?Q?qLmknK/pPapxNU5q3kFFn/ei6YhpYtm6vi4u9yXy3L1I6SeP10nQYfOAVMfU?=
 =?us-ascii?Q?GR05jQSP3/NmLaVawYwJpbM0hJXtqDsfTjIGZgGyWc2kMGGu+yNEsOciFkwt?=
 =?us-ascii?Q?dqta8REa/vqxUQQVolPxqL0W1QUjd3l+9s2TYCgXauYxqzntt+b7yxwZISc6?=
 =?us-ascii?Q?GEjBMBjdTs7cdtH0WokqAnbDVoP2qcgxkwi/TUSry0oUa/8PdZqzJjdt2PHo?=
 =?us-ascii?Q?0ky6pY1vtTfQbRzciTFLR9AF2DQVi9pLG/TtYrU00DdSfCthrqsLYX0t8/Mv?=
 =?us-ascii?Q?N2I2UHdDOGLjlqBGA+F305nZBdUfTwrdpzThUnGjNoupyFkqn/tqwugh1rUK?=
 =?us-ascii?Q?a5B3qq9/yc13wKg9RQ0E3TEkqQ/dzO/zBxWtd1LE6GJaZUp9DaxqJ4/6nfV6?=
 =?us-ascii?Q?mhehZ/Pv/yTsPNgpkTOZWbP98mdcJH+96o/ybniX5MtWfZoHfSsT+u1vDGg1?=
 =?us-ascii?Q?utJRsa8LO7+HeazHYMzYNe7wHcnSCLqf4z+Lxj08zVF54M6CwuDFmBcqVwWI?=
 =?us-ascii?Q?CyRKO3v3LT9zJcx3FfJ0Zo1JmSrONWepwOxJlw4H4WhR4WEubHL3T+59OzSr?=
 =?us-ascii?Q?wZzXBpZfz2QpruCtyr4ah4G/ul8HFrUtJmQPftzQJs2l5py7xsRW5oZjOg61?=
 =?us-ascii?Q?P9OCKimF6Hltb3mrdglnc5H+CrYZ6f52LvSVMfTOUt9Q5M/E70hqndDMDC8h?=
 =?us-ascii?Q?nLj0AV527qDwg/dnTrq1lDBwC5zQMTs9BRIo+xjlbt7IgodDISAtihmRDZR+?=
 =?us-ascii?Q?3pcZEl5tgirJqq7E9QGXDixr0jm+C065XI5jh3X/Ep6UEoe08c4JiVjkfNP4?=
 =?us-ascii?Q?dUXLwSNw2XhTMLquvlWYpilEMT15RJlgtE8/NOVncAO7h9uMINyn5osOxmQG?=
 =?us-ascii?Q?hnZyiAy+WsMJXAM2C8DbULk7WmjtpNpnMKM0/foxtc6drCABSOjQL3NM7riq?=
 =?us-ascii?Q?iqvy3Lmwgy009RM60tonBq/yCm1pJIGIOg0qtKvU9ZSyI2IJlfpnV2DcbBln?=
 =?us-ascii?Q?km/Qb8ZnSHB88Vo8608E/YfM5A0r1eh6sY9+8LqNBZJyh86Xf/gjo0l/ktPx?=
 =?us-ascii?Q?GcWxEhfPjjld2QxBUiD/y3WWahhau4D2Hz2nFMh46YsscD5L5bSuqP+lUnY/?=
 =?us-ascii?Q?DvBTz6TlMU4iwLSRMhCnZovnJvs7I+dAitZt/v7JWyh2TRZukM/TAy0npgZE?=
 =?us-ascii?Q?SlSuoXMP4IE+eBf1K27ck2pMlvPV1AD21woKE1B6y1NMbnqqsbA01IFl3dob?=
 =?us-ascii?Q?JuCjz5kgDvTEt8qnHEBguEhtpasdvwc8BM+Y0vJtqnTdg8Tcal1JvC61eo1Z?=
 =?us-ascii?Q?ffu0Quontnt5o3BKJv6Rv7cTn+ZHlj0=3D?=
X-Exchange-RoutingPolicyChecked:
	oEZTh2lpY0G+ZX0x0VRy6Jof9AOSsDhmTl+rzoMyAXb3k2SkLczwyW/936eQX1EUUp3+bFImQqVsgqTQuW8poU/MWnWoLQ7vUbL4vXGMctEo/TqBeZFRLBytgEfm3KGa8aakADMsA9BFwWXxp4BGO5rmvsmFgaVnkHbl609MFyCkPM7xER7h59zp/hIEOr5B9Fjlrcjw6R5KdcyOoemp9rXDKTtOVAs6n8VNXfWTqn0ea+mdGRdEM/dFcUWfVX1dorBSDzDbTK5X4HgRVSAw+kccEvDY2iUzOmFg03CKxQ9xBNPKsHY6YGtSZ+7dQRgZEC/HXDkcpFXFx4SJYM7giw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wf0ybpWfmIPUKrAX9YTUK4MWWZpoCl3PqugxKxS18wVSAIuk8nDSYAJGjL7OegF/IF+xDWMZeOgK6dpm3SVibSeRGaXkS1wHJPM793vcZ7FCk2PQ8dyCcAmDCNKYct/QZB0q8+SuU9NOMMyoXzWUQYD7GvNJRkTbLVBIYuhd6Wc8GWxaa86S7NUUAt5tT2zVG6UhF64FDXtZJJhKDv0J7hsN0GqJ0P3n+ST0M5cJC6Hvfo6cmmQpXL3rJIY7oklS/HJUl1IcTeD0SuDnPQLNx1MI+xwrJ8f0R+NbdHSoP5iv4WnxxFsNgTJ8nJ4kIGWlQE4CG2FsxPzwcnvKcsPjPT4+Q5U7cr45HqFlCnFD6DDuzIiWJAl28hDqjaadQCUsOuUqiQnOybimDRzbJMeT+zEYeW+yEJEV6rlTwL5b2whElrvCsCBEaY2bLlIXoXkekM5to56N4nLJN59cnW73SkfHZf5AzlVk3JqYdF7nyPxc7X/WJ530abbxbVozpUAKNSs03pDnkU95Ze3i+S6E+XGkhdEgpcxBTTA02SAElUDwX3OU2FOUuz2RB7fs3Z5iVNxg/ffkHR5/BotSAEyVYB+i8lh6q9byhpEOlVPorQY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5da81e-731d-4627-3590-08ded8ee5e16
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:22.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tX+r7A2UzhZ89YabAc6cFul5ojBd/be1dZMzdc4OwW6yCgsTeVdF0fP9ha8lxaiT70TMspz/iYqjnjtCXaFGnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX2SyIkuPmsHeb
 dBiKu9PBe1WBYdqR9AYdnEAcXxk0SHaUySn6aGDRxE72rVG7cPy3fT9LU0p/HdmEZSdw+QSYgph
 k1zg89GwJcTmRhc6D1zGIbPNDHQOQLeFRf9b34je06716wee1xHc
X-Proofpoint-GUID: lu8-iXyZNbM3uvFpFvRm7DuhTGeb7g4k
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a478fbb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=9AqYmpHzZGUCEUQmZP8A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-ORIG-GUID: lu8-iXyZNbM3uvFpFvRm7DuhTGeb7g4k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXwzEj0UGw6nH5
 4fBCs8m9xDtmnV08DhYLUW6YQF3ieWYB+NbndonGg2TJDsyNlPK4w2KTloMOYdz5CdG7xDBZ69a
 6paH6DZtL5vI7zX1PypVKXH0G6nkaFmWl34jukzRuZ+CbzdbVVQtKy5p0r91LxvrpoXeLl8vY6D
 jh75KPK2cZUlzCBM+LBoE6/s6Z1NBapCmvvsgdvxYhAofZ4pxOUEF4nKkIze5KABh+YgFeVBYy/
 RFtyhiC9Oi+421oP1nrIpgZZAk7WRHlfl2291hhQyx3T6mnJOvFFBr3NLD8bYbgs8FEGTC+guHj
 BvluTCO8zpsPAi9XSfqotQcsGrnFGTlY6j5X/FyRGgf9pMXLDBZN4Uy7UWAd2orIzg19oYhtIj8
 u73CZcecto4eOgi29BV7geS8L+PfX50i9UEB45t+DgvwKohqAH4U5KlLiqe9U5QHjWzpHCJXWfK
 PemAECpfk4HP+5AOUeH7o/lZqValH8ji4HK0DHvk=

Add callback nvme_mpath_chr_uring_cmd, which is equivalent to
nvme_ns_head_chr_uring_cmd().

Also fill in chr_uring_cmd_iopoll with same function as currently used,
chr_uring_cmd_iopoll().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/ioctl.c     | 8 ++++++++
 drivers/nvme/host/multipath.c | 2 ++
 drivers/nvme/host/nvme.h      | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 14ac86b8b1a8a..d9eee6e685f96 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -718,6 +718,14 @@ void nvme_mpath_ioctl_finish(void *opaque)
 	nvme_put_ctrl(opaque);
 }
 
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	return nvme_ns_uring_cmd(nvme_mpath_to_ns(mpath_device), ioucmd,
+					issue_flags);
+}
+
 static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 		void __user *argp, struct nvme_ns_head *head, int srcu_idx,
 		bool open_for_write)
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 9a1703f01ef60..b27b45c59c883 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1554,4 +1554,6 @@ static const struct mpath_head_template mpdt = {
 	.cdev_ioctl = nvme_mpath_cdev_ioctl,
 	.ioctl_begin = nvme_mpath_ioctl_begin,
 	.ioctl_finish = nvme_mpath_ioctl_finish,
+	.chr_uring_cmd = nvme_mpath_chr_uring_cmd,
+	.chr_uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
 };
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 4405e47bfe1d9..35618285caf89 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1069,6 +1069,8 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl);
 void nvme_mpath_remove_disk(struct nvme_ns_head *head);
 void nvme_mpath_start_request(struct request *rq);
 void nvme_mpath_end_request(struct request *rq);
+int nvme_mpath_chr_uring_cmd(struct mpath_device *mpath_device,
+		struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 
 long nvme_mpath_cdev_ioctl(struct mpath_device *mpath_device, unsigned int cmd,
 			unsigned long arg, bool open_for_write);
-- 
2.43.7

