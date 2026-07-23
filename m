Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FFD432E85;
	Thu, 23 Jul 2026 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799460; cv=fail; b=kPD8pPNXnVR2rCC95uw8x/LYN9H7G5SQSrbBRZi3wS0N6Q+a3OiYWwQbiEF6YgSy8tAOapSI5CH/ljitggk81Wn+T2466vXwBnBfUY6z7/EksRebsl5uyF60Ga3g9vLFNXK6NZU7mulkJpVxv151W297MOGEGHHz9WnIL9Tfkx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799460; c=relaxed/simple;
	bh=urPaq2w441c8G6b29NuPR6UUMlfY9/XTp+TxQ0OHp4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bUqopC8LD4SKb1jgSvoMKK4q0EYogRWFuUAOyDoMLQe78n8O3XlIsMY2NrmtjmPQv7M/rc2ZTLwHE2SS54YSh+DR2/0ZjnZoVuI5AdcRRKTFH0g9BEUJhW+JbHy7//m0RUOVnkImZsI2aEpdDFJEwB4p+6AUbZZ74hFf/5Gr45g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bciuhJe+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K0B7nfuH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bciuhJe+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K0B7nfuH"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtZbC3391769;
	Thu, 23 Jul 2026 09:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gNgGC0xtc8EfdX7lZEYykCeK6U4aig5OWHUyoHKtOzc=; b=
	bciuhJe+9lkS6WSxIF+XPEepevyWQnA1vqzjOOFAvvKH3+EC6ZUHJlUXX9+nasbZ
	vAPeuQg0Zm64s1LnlpXOgwgPHKotcgEKRTt7E1pijvFhQjZ8ULHl/eOb/moGwWyE
	nHfDABCoQrFYxLwdxGt7rFDm+znVKYfDg1zVFLoZLk1PFvIAtp4VqtQIQp0OcCvd
	Ch9PbzI4/2AX7ONEMVMlcNaIobv9OnTbIZuUDwj7LM2dJPdb5Ca17lgr7+s+EhsT
	1A/tyFm2xGr7SFTnuwA6b/g/Dvc1txF/U+ObPmD5rv1YI5TYB6R2LYxqX74Rw01M
	R0L7UQJhyAXpGha+B5ypwA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1tjxn58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9NVo9008033;
	Thu, 23 Jul 2026 09:37:12 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxrwmtr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4/5mMOYgjiBxhXE0hrIKwnMAOAPXeiPsIHtdLdrVE6E9299/nMoD1weU47t+L/4GjHA6GPEVV//tbgGmwlpeNo7Q6oRv9Q+nFuHtblgcdgAtkIYpklgjPgl9WE/qIFPhe3WvlL5jq4Z0LrA7LFg7GYCNbVV6iPJoNQrFODdXCKmclt7cilD8z2QzQL6TJHq56xd9Gdy5XpaI1ChWPi778JC8nz1bLARijNt1b6KKCkjhj82HyxCLouRXfgy0+yTWmSIFhYpY9I34udcBCcD+xxws4wqMkziiTtZDZ2S7njWu43RF26u2zv/0IVOcAZZZR0J/mbaFW0AFiBpdAqX9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNgGC0xtc8EfdX7lZEYykCeK6U4aig5OWHUyoHKtOzc=;
 b=foMnlHkzOue2p7nrNRzP9mklGAFY9iBSctUI7mxHLvOI/ekK4hWEZC51J+JPaRNpHOsvjLkPkU0iEZw0EToZrLx6lHBr7fNFrcFA6NbEAMx/432xC19ALp+4LrCRoIE7+8+Qgsf4pT53TD7YE093Ocoi2Tj//ExdtXdyC0euKdXFV+YLsLadKhLoT49aKSp3xOVvBQqKvxjLqQ8fJSM1JTezNmC4FMpkPw1UGSOyR6njhjaz/PmV45I7BO4yltOHjuUflxNVau2TIZN+a+R4+IYZ9dwEig90Uoqzhb5dq2cFDEAWlf/BkeHGsYyUmvOp8HI7N2w7bs5OKzrXWWBFLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNgGC0xtc8EfdX7lZEYykCeK6U4aig5OWHUyoHKtOzc=;
 b=K0B7nfuHEmwBPCTdyql3XcFgXFcUPm5xML9DyRiZG8b12OJxru/pR6uhJyf3907AuLY8QBUqLR8SsOkS91+O5gw+piO0juveNrkornhATusPTpYhV1jN3BoG4uxxXir5XRsQ0TvTsaJcWFJReyXCmHzvQxUB31aI58n4anYP7u4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:08 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:08 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 13/28] scsi-multipath: introduce scsi_device head structure
Date: Thu, 23 Jul 2026 09:36:11 +0000
Message-ID: <20260723093627.2327456-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0045.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 02df1ea7-c100-47a5-0f5f-08dee89df6ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7Gkku4LqX5vz/QG3J6vvi2pNGFH4csAViCLvSGwrWU+VDsNeJnKFwhaGHPl6eXHoYNT4Op6YgapGHDSgLxcjUxSlPwzJnxxuOmd3WvHVTUbQkJgz+Eyrn7E7ztTnaKBpbZhsMkw/k5OSZXagOihXoPPUQ2AiW6XUxz9L+xYH2hBWFAA7ZRUlxPrPRKx1RSivhuCO5AQe7OZvHyX5gk0zfMdEaN3y40IDiRzIJpRHONtLxYJaxCzxj/tqjaNbu/s43FUJdSeeVG66diueHZOICbfDxxG6e/XqXafsjEAhL4Ydh92ZH+2OCcgIWl4skz0YupMR+AWIEnKQZd9VTUSTMPzBjLi8WhDZvA08cTWoADA9sLx9nAMmL4sZZv/x+rUiKdUKhhM3ELq9DUfc2RCgodUCnCaaQA2LmqN5jKERqr15WjIS4pVOvZwC/1ONFybnKb324hZEca2YVKoEz5j1ezmEppUopwIcQ5Cdy4IHn2BewVaSj9rv3fs3acDD9sAyWWYazgqPFNWKEOJ/aCgxrCVtHGI+wxjF7NOb07/XizSE3XmwuE55G4RvEx8QkqOSKGzdkuNNn9WGTSY/Br/3CYsVkN40oaYKElBDXshw4fsKO4TqKizgG8q15jHhG04L7NF86mrydqvM/mMbeebgPW4W+3wtwaizHjb+axxPn7k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o6p2I+/QYkTbY5+cNrbtVHxID4+e1C/6bkqZfjNvQqPtsYmJ/V7/c24HhvSt?=
 =?us-ascii?Q?R7u/0nkAlvQ1UscN7TgDTSJejWStOVnw6Wz8IYscG3xl34gXOMHPDHTZTHtB?=
 =?us-ascii?Q?3Ie6pmrQxqQE8aQyNHje2DRNRhbrL9OtcjFirT/lBo7HwJqaLJeWKqYNPaH6?=
 =?us-ascii?Q?XFDA+s3PoLxZiJ9IWnLZkXqyOrRDjUzDK74Kwv3B9OISmO8m2A/rs8yKvYHl?=
 =?us-ascii?Q?Uc7DAnHmDFDqL1BU58i3TI1bTclILVnHpkP+amz9u2HK5DU/5YnDY5RkT8DK?=
 =?us-ascii?Q?BQ2O+0J8MAlnlLdCLMsqAd/8xya00xvwWn2Hu+ZV6j21cih6LP9HWcqphKIu?=
 =?us-ascii?Q?2GXB3A9Qh/ysvqbqt+UMgv3owHEnqZWScFQ4BD+A7O0D3cIAF4DrzyVRtlgW?=
 =?us-ascii?Q?fATfw4epSgkA/xdHqpw4bseKD8TROiAmbPQ0VJJHl92+fZ1xtjwhZRI7emng?=
 =?us-ascii?Q?W5locNqSPfQltCwZrp8wQ06X8kThErrzsJuLD61h1hsQzneA1EnmRFSUiXYb?=
 =?us-ascii?Q?euU0pt+t05L6p0IQRq3ajjrRCuPTxlELLzElv4Ao/1Vb3XOx096a9o4Ry0ev?=
 =?us-ascii?Q?vVFiFW9mvMGTOky1wpeXZX+ou3U6PumT3rB1GqO/xnW2rT7aR4/Wzp/ubgaG?=
 =?us-ascii?Q?8WVkMPs+GE0IS5uXbjwcFRgeEEirLB7AqR15zhCgSOIFcZrI0LI5J6711Mh5?=
 =?us-ascii?Q?QewOx8ps5HQLEnAYjIOGzBxti3CEkd/mbLtgpUPRjEknfksx8MatDn5epk4+?=
 =?us-ascii?Q?7csa5kip9M+IC4sROy2UIQVIccXAd5XA/MoKcBnNoVJsJZut2z3R4w8Tm4bK?=
 =?us-ascii?Q?6lKgb3baE5i6MGeCIPR4UUwfT/jTJ9D6g3HzMN+I6MTRPNlxgRbmL8mi13Dx?=
 =?us-ascii?Q?Q+xwQVluZnz+AZZ/MlK5O0cA4Xe+cUql4J+zlD+MfM2U2GKLf4fp19MKLPhH?=
 =?us-ascii?Q?y8ne1YYYVRZWUd+/34W/UIsvPIlz8gcFE4smYDIqMHhNkotxy8Ry5n+Uto45?=
 =?us-ascii?Q?UgFaCDCqe/wHQ8KJD5WCPEjI0bGtQCmH7kk1+qTNii12YQAkQuV13hu392lq?=
 =?us-ascii?Q?yF44hYfR1idWrsqXk8LogSbeQohsJ4O+BzXAEkeXpZ4cmUuYmQbtSeFPAM1X?=
 =?us-ascii?Q?kve/PR+Us6pm7Dkg5+Ex4xqgzvZt1OFB+GnCDLPXnkEf5inqcq5U0T2cox1Y?=
 =?us-ascii?Q?Qruv8+ADQ/wBAa3bsTqYuHOev/Uxuv8+XyckU461f2eoqQNNmnBjAOyCECHI?=
 =?us-ascii?Q?UXdUCvNP9k2eG2jvyFaaphm7G0oXdlVpBRPjoQEnuWIVNzWkq2pyzO94as2V?=
 =?us-ascii?Q?BbiZ0CLxeyNvXlQ/HEhg2R58fLNZQ92lBd5vIBuOJ/hsK18fCpfTy9IITIBd?=
 =?us-ascii?Q?TF4wusL3fAXFi04IxGPBjyBx47/NLrRWnPG4REtdg0NI4c7hpEyDj8Hql6yJ?=
 =?us-ascii?Q?LAln1lIDMdonOLYhgM25v2Lh5NOrwQ7sIPsNDIcSvqJoemWLqnO/MU+EszmK?=
 =?us-ascii?Q?4Argywf7jp3ZlkqkKB9Tq2G2cbMwRJMz/ekJ6iMnDUc6QXcN5lHulYPWB7Tn?=
 =?us-ascii?Q?E5G4ejM76uPCvnsEd5ljsXcqDxD3bgymQGoGVQOWh20go98qzOtBKI5Fvv34?=
 =?us-ascii?Q?ZVA+MpNlN3FJlvFL8+B7zoC989IDYwKnVszRx1An0i9/wzFBtl2S5IicEaOR?=
 =?us-ascii?Q?L6gEKfIFTgl7wl38fYsAIIHKWyXIQgVqgdvWFX55ovhQrvQmSvkHCe37/3h7?=
 =?us-ascii?Q?/bPgYuy7wYyqNH8f7sb8iDsm4U00PZA=3D?=
X-Exchange-RoutingPolicyChecked:
	QO2b5CU2zT1HvziozDgI2hBu6o727aJegxN5gRSh+7RcUPDWVUEsJWDNy+C+puqFVRfa3BCwEveUiHHrbprMcZr0orzsmZql7PapjFOy9GurrOxMlqATwOHg/ED73AmCGMfWGIzg2Fut/PsjiFgGOWYN7+JQQEgCPeSKho6jpVqzuk/vskNK8HBTs83zKZju/Gmn3TqWAWr9Q/kMWL82d8GIXm2yDd5RgMCqPRChEIhXLcVTHM9GzJmpSPo9V8ag3/WukX1eJmygCeN3UpM9OjsQk9VpqcZJswqCdLu7XYGTQ9P9z8NPOYl6FdrriLcrL6tlEIM4oBtG/sy59SF9ow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IRDOfDost4A49/RUVudm+6oZ+brTVe/o/pE7hhKQXdHTTKn5wxDYumQQQwFqw/hGyBTlDVT9uP/OT3mgbkLJq7p/Q2cUmddb6/0I9PiJCY39I1tOzMuXgSfzRl7u/Guu9M2khDIkRyi9OTqoGE6bUU5XKmEANHL8KAd+Y/3LLkb+CvcJFUhL08KWftlGUPErX9JJ4i5elozmbSYfgIHffEYWt29twIjxgyZKF520UhPIbhSLt02yqYfyq17xfziY0ae1r7aHigvVWod26mqy6X0mQiVBR83VPsQgfd6xSWfYWV61bPBG5r4PH5zzxSUPTZXIxoudGw8gpIOM2ZOX846c/JdwEJgbzr8beqXhjK9ueJseyfRliMzkG9sc1g0WEJCStFFwKRniawYQShwo45dso6ET22BOlzgvFiv12Y1XkkHrgRXhYTwekYu+vulEls/IVqKOesDuSXmr+jcUa4DGxFcbME7wQ3kDiwxiGUu9b6fDM5epCBOF9NIrYqrtaYFXkoYpZZAlICZKcQgDTFfwz31IsEFamVSIzUfDzlr3be5/cGU0CAOh+/yKYNelaEeTJfKDpb18yf+q/ls3dJEeoj39nx7scrDjK+O/9ZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02df1ea7-c100-47a5-0f5f-08dee89df6ea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:08.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYE0xBRzzoKIf0JSR+1Kh5eSrk0PsE41WR6913VVUCxpHSm4rYUy+YpM9ykyVpWtMZ5Yo6Fl2FgEg/u2+iEYUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230093
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=6a61e0c9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=rslDvqJ3sq2LG7fXSO4A:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-GUID: XFwmw5CZLmI9sDLtezQDiMO6mRe5s4Oe
X-Proofpoint-ORIG-GUID: XFwmw5CZLmI9sDLtezQDiMO6mRe5s4Oe
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXwubBNsuqZKEl
 SYZDttHju1xuaoj3AyqVDExh9zSEdOHPFyzAWiblhDNelCIwW4PG0EFTOymgZRrfKpL/4zq/roC
 KMtx04bMKGBcRxbWNxn1Z2fgDmlVOAaUeZVbxJNhWI0WMda1oEOd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX3NjHB8q5eTXh
 d7bRvaklvDmsRIVoB76rW95C38EVen2H97e5a8TuHcd90x8blPxr3jKVrvaKN9lfwUJ+Uh/86HC
 sSbAGcwTLw1AS6WIh92bBhIE0CURQaLURwN5AUhkeWKZEJur4GiqWX10WxpkDgLhAXHy1Jn2Spj
 Sz5QS6e7z2ZbGAFSsFOW10XEcL05HkLXQn0WYfbI64jLisHOgbZSn8xYPx2ufDo2kn4loij4eYB
 yJtoJAYsvMbxC8p7/Y2V0OjbLx1Bk8F3SBZSJuRk+4vt/wnYPaccJONJatmmI0eQpLuKUZx8f0l
 ATK/bzdfFcYalRGX59craWhFi3MqAoZa2yw0gOJIL0wpSZMGf2B6z0a8WAKqvaV2pzMdVITv5Uj
 8RcsmxMv77Ua8hpi+MrWpBOgVGe4lzlsgcZZfIFGp3ZXyRBpdZeyTJOJOewN1lsuSa+uz0N9zzK
 GIx0BwwU3C8i2Ej6MX428hYsuUVyyChYSvUTfgdc=

From: John Garry <john.garry@linux.dev>

Introduce a scsi_device head structure - scsi_mpath_head - to manage
multipathing for a scsi_device. This is similar to nvme_ns_head structure.

There is no reference in scsi_mpath_head to any disk, as this would be
mananged by the scsi_disk driver.

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

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 195 +++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c     |   3 +
 include/scsi/scsi_multipath.h |  31 ++++++
 3 files changed, 227 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index b9b58a3641aa2..609f8009e4ac3 100644
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
@@ -70,6 +74,54 @@ static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_head_release(struct device *dev)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
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
@@ -89,6 +141,71 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct mpath_head_template smpdt = {
+};
+
+static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
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
+			if (scsi_mpath_get_head(scsi_mpath_head))
+				return NULL;
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
@@ -97,6 +214,7 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
+	struct scsi_mpath_head *scsi_mpath_head;
 	int ret;
 
 	if (scsi_multipath == SCSI_MULTIPATH_OFF)
@@ -116,13 +234,52 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	if (ret < 0)
 		goto out_uninit;
 
-	return 0;
+	mutex_lock(&scsi_mpath_heads_lock);
+	scsi_mpath_head = scsi_mpath_find_head(sdev->scsi_mpath_dev);
+	if (scsi_mpath_head)
+		goto found;
+	scsi_mpath_head = scsi_mpath_alloc_head();
+	if (!scsi_mpath_head) {
+		sdev_printk(KERN_NOTICE, sdev, "could not allocate multipath head, device multipathing disabled\n");
+		mutex_unlock(&scsi_mpath_heads_lock);
+		goto out_uninit;
+	}
+
+	strscpy(scsi_mpath_head->vpd_id, sdev->scsi_mpath_dev->device_id_str,
+			SCSI_MPATH_DEVICE_ID_LEN);
+
+	list_add_tail(&scsi_mpath_head->entry, &scsi_mpath_heads_list);
+found:
+	mutex_unlock(&scsi_mpath_heads_lock);
+	ret = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
+	if (ret < 0)
+		goto out_put_head;
+	sdev->scsi_mpath_dev->index = ret;
 
+	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
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
@@ -133,13 +290,47 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
 	scsi_multipath_sdev_uninit(sdev);
 }
 
-int __init scsi_multipath_init(void)
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
 {
+	if (!kref_get_unless_zero(&scsi_mpath_head->ref))
+		return -ENXIO;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(scsi_mpath_get_head);
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
+	class_unregister(&scsi_mpath_device_class);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2f80d703ce640..d6bbaf424bd4a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1501,6 +1501,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	} else
 		put_device(&sdev->sdev_dev);
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
+
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d3d410dafd17a..50298056181f9 100644
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
 
@@ -32,8 +45,13 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
 
+struct scsi_mpath_head {
+};
 struct scsi_mpath_device {
 };
 
@@ -51,5 +69,18 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline
+void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
+static inline
+int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head)
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

