Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CB1433BCA;
	Thu, 23 Jul 2026 09:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799466; cv=fail; b=PxF+D+VC0JcfG3XAvQmAX/r+FfGR8HuychUaGBaHdGMCwDISCkYMEKxc+7adiDqXzLuubB9tVvNThRmtKsQ1M+8E9IK+wZJyOLxkeDWuhA0tUc13Ug22kQnRVH33+8whGwyPR7dncmhePofMgZOygk8hOISP2PZ55WDf+nWxkT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799466; c=relaxed/simple;
	bh=AYcFrMjNcJHOjsHU/azDWM/aYk8nzhX8Qxo1B3KdliA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kRGm5TEnuDE6bJRoHwQBUIk/yq0iv5IrjcnDJcK7VzlxRS9id+BbFE4ZiCQqCZBJUwiUw6nIMSLIaAqx5XHVYhDMSIOSAmNAQA5V0KM4LI4vP6g4kV8OCOiR+q6F0SkHY0J5kGkQa06Yj44mhudb3WNUFh3rQ0ZFVcTnD96XhDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nVejIij4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IEgR6Zd1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nVejIij4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IEgR6Zd1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4JhQs009715;
	Thu, 23 Jul 2026 09:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2huvFp/mAnt2ozXFKwtSvu8IC7sm2+Q6WgAYcXwqf/4=; b=
	nVejIij49akf+x0y7O/jckEJQ+dJN+F85+WWa+hAifYKC9RVKejCN2Q6SXJX0MNb
	CJoa2FGUpmNDnnspEQ/uchDK23RZusex+9fxmXJoxCpFNNBxF2nhcuVAI61Uo3M6
	pqZJTMzQtDmUvjuygAWmctyV2ebSkaRBT9rFQ4fuvYvKVXQ7flwIRu2OjorzF30F
	ITPhX4y3sCGQItAmA+WEYSwJb/X9fGt8tP/UbAlNeEYS7/+dF8xV8VFQYuiccvv0
	xCZI8bZwLW0yM1x5ozlXuC+8MdUqhiVD1+WtUVIjBtAE9sd/6K3aW4eGhvW8YQ/A
	mXL2nksleKyttJ9GySHSag==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6mve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9NXSo008245;
	Thu, 23 Jul 2026 09:37:15 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010029.outbound.protection.outlook.com [52.101.193.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxrwmvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e9nd+osr2LBUiANqShsPsBkbmOEoaQEoheZJY34VbUAHIpeo2tnkx1a6UBQBwnBm1CT/oWedNKYWk/gzhn1LST6ywWSG0Qts6HXOBJS7a2TzuM9uuV7X8HJthV63ryMLNE/C8WFHXQ0IlekshcwvRHZHU/S2paf3+da5SmHd2kYOFgktTamiOjMRLr3meY/F3xeilW5/79w3rPax6ZwBnSjIYX635lWuGG5qYZjTLAKpH5I47NYZDNVEjtVREz7UzGCUrpGJckeXMq7zXUmaV10VEjvKY+QmOQk+MzA5PrjydjUfi7aKjHDwV2HE+eWO749zKQh/UsEawtvPKzhoKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2huvFp/mAnt2ozXFKwtSvu8IC7sm2+Q6WgAYcXwqf/4=;
 b=G4XjJwHwAwo9VDeeLTuXoVwLJM3HqmXD/1JHCW+6VzJVS9C/BZVghTDi28d3pV47fSr/PRyxcaAF9aCQM20w/RHRuO+4KPg4yDZApa78YP0lF6H2+S3K8zIc7T+LIQiNyCj2OWtBxzLEcI/lULRJaHyEOb6L/M/+D6kur74ccC8RPIhzn0xAkfGrI2KhDnONS0ur5Ye9QcCjO6XCB/RWRpnl61f0yAnyxcrehBY6I352WqbtpSlikXsXZVixteOkDmKTMbWjz7ZpmyhRvs0hWs06uEoRCpHV45ivpLQSWUlxAk4IQ85VkE8P+Fe1S3eleiqGAy005sxeszBkzW/7Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2huvFp/mAnt2ozXFKwtSvu8IC7sm2+Q6WgAYcXwqf/4=;
 b=IEgR6Zd1QcwuX6AXq07iquZxSPin6D4DRXg6yYDq+P+JIu58hSc4ayU6teO2raoL5XgPKBSAgD0q25MEZG09PydoeYe79PWWY3Y79ojBBCAC23MvhUIBlMAdbj8j865I58DAvwdm2oSbkU5XCZ59ThSCF8FJCUL7wIal5x5goPw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:11 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 15/28] scsi-multipath: support iopolicy
Date: Thu, 23 Jul 2026 09:36:13 +0000
Message-ID: <20260723093627.2327456-16-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: bf61f809-4dfc-4408-5232-08dee89df8be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Hc+MBhhUamU5cWei1pcNQ6MooK5XPXLAMPVmsZyCp6yXMRJc6dyK6Q64gApUIXgzOD2jp3tncKcRAKd2rTS3k43k+gwsn8sTyP04VdDIsVLNSrUNmlWfiB7TN8qNOwD0X9AbHnC1R2nNuuqHbSuvXk+KNuBtGXZ8zW7FnIBi+CbnkYCicUW68e1Daeq1PTWXB+TcYg7h6BQ5sia6kWjIrt49IjtrQxqNOeZgrhGwarfqN0jD5lDzBLsMPF/ERkOfkG3hZa5qVZZF/jQVsVCfLK7eyx7hiJJIVIi9MuCSzSkrSqG7DVhXDB12477v6jxxct6SBUFATWAI0nRJ0ffbdMjfvNuCNkK/ry+Lu50Ec/CveeO/7jz80nrxhry97XyVlTOze8HJqFJRIYDocmTIKcYUbpQAHd5iMf5gKfR1OZdzjkVE8YBYE3FhlEMFA2GOXwghvULFyuhUfJbhZv7WecjJv7pct8hd7m6aXFJUSa1GDE6J9RZaq2czliMQtM5ZeCsiEN8pGtgCz6SnLpAt9VsfuAyNcT7hCs332xhl+9VG1SW+v1nR30PFE1hFU0PawJW4CEK7JDXAGAOurw7ZHXWt9+78kwAOY3df6ljRo0rg0L+tbfMMEfrJBoIv6p9Ig2Qg6yY6EIVdlNo2OHTZxc4uua7aSXCTIBq6OmqlIT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u+StYWm2JtOhV3N1ekygntusnGDoeD3XxhruGXx0lC+HK1HjZgtADpL44tJ4?=
 =?us-ascii?Q?7Ngh+Z+nifFH5nvdG8IPa9vOmAVkDdJz00J6zVC9wiaLjouHPZAkcpPX1nTo?=
 =?us-ascii?Q?MUe4yn8K6CcmPbX/n2kg/ENNUrthPunsLrgItrA8HsICbse6BGI/vDB1Oyfn?=
 =?us-ascii?Q?HsVmjLIqupcYp3G0XsJeE7ZRJOINP/XG2n0PokzHXSIWccHCu/c4wqbIctjw?=
 =?us-ascii?Q?ByiLLeL90vNcnCpWOTkNuL93v7iWa7RSHZqmkV53ezSzBvHrOJRx1hosExPJ?=
 =?us-ascii?Q?9SYYCPHGNM1sCqcF3I8XUmLctkD/O2cVWrP5benb6wKnzv/6wnrbBlVN064m?=
 =?us-ascii?Q?Kfc8z2cGrHJRzMGEx/W4TL+NC1Cqmse8IdBcc+XfHnK6qZJxsImFb5Sg7LFP?=
 =?us-ascii?Q?/AaZT77X228wxNmXObZXB64LN8wr99oTURhQ6E8bnRvT6M/nJWnUDFpDXvK3?=
 =?us-ascii?Q?6TskWuYatZTTTb2Vo18JX9LbChV0IV30qf1rODfx7GP3sEby5PsMYkmq96+S?=
 =?us-ascii?Q?Jm1YzrUVlK3kMgt+b6m9Ln4ScrCGjopJovW2zWV7NjhLa/NFBf0ux2yMExVG?=
 =?us-ascii?Q?WEVsl65+mYKlwd1oYzdsbHV7fM6eIBxpLRn1XgZADiYmQBP+KVBfxVUZ2EZH?=
 =?us-ascii?Q?pmyVQltaj1wUE7EIjAQ0raOmmlHsDMj7aIm3rmpWrlQjVB2fYy1VAjfmeiEz?=
 =?us-ascii?Q?dAhP7v9g16MXTVYNl0quziYEcmENw8LTjMwOqExxlh1zNzaLVgAJNj1Fh5eA?=
 =?us-ascii?Q?VBrr/JPImvrejeWcRVUWYVqTv23Hz4yLuxFyCTu3LHSI9zhBiV7IntJ/L/To?=
 =?us-ascii?Q?nzrTx3KvUOB6W8F2e9LY6VBJPfBiU39Ah/QsXRfmUbPYSFqYKt3exjQ6/EYo?=
 =?us-ascii?Q?zXmr96iQ7kw5uVOe6zmb5dApRw8VWNaaHEFRfkp/uSwQGKfvtUTsHp7W8epA?=
 =?us-ascii?Q?llS4EnZQL1Kfvx0GUEciHBu89FgN13F49DqEFxujoucNFRGAPNfNKIFMBxYE?=
 =?us-ascii?Q?19woWOkxL+z6DfztHCEBhrK13RqVw5D8WfYqbxH/ahY2iYZVsZeVY3++cWGZ?=
 =?us-ascii?Q?E278fYkwrqspoK4TL16QXmyJQSo+ql3x4/GOjNrINAz8Whp4Iz5m1Djbehrc?=
 =?us-ascii?Q?LjFImzI8MHV1QChgFExROCQhLCdBZ9R83bd9Hh/9bti91bjH2toFoi5F+P7M?=
 =?us-ascii?Q?2EFd9vJanvM351jnaUNpVdUnpBvm9h7ZokioKQvgEBep9Khujl+Li8ebMlQE?=
 =?us-ascii?Q?NWztAXy0PWaYdXhKbJIkK59Iz0BRwsl5meiYSwU41VBORBCp30RUB4fx2bUa?=
 =?us-ascii?Q?Wo/YUTdS82CChGdw9aO7WcJ7HjSjnaF3R8kj3/FJH+EM5qeSGR7IhphKzBA2?=
 =?us-ascii?Q?nnwYXWjj8b6jU5fZKsY56G3fdUv1D410+GRaCCBIhfgtJO/Q3I8JZ+SBwsIz?=
 =?us-ascii?Q?Pt3iNUEwQxwUHLRylSMRDPJWvV4lET1lAvsqxqZeP9wKZ4nFQx95jhQvNgSv?=
 =?us-ascii?Q?lWTli3lxOLA3LeWCTiVLf5V62IfCh+crwzhgQuITQidyHsRp3bv6oXb3Itbr?=
 =?us-ascii?Q?G/SW7IOcR5d7CZwtlgTtTkARVeXn9RpJccf2uSERYU819iLilbfnnK8hf7ZR?=
 =?us-ascii?Q?LN9I+UxX/a+KzRA23rezcce0m11QtBWFpzFv9Vt/Fy0KSINhPpMWSStfzgjV?=
 =?us-ascii?Q?qnPDkfXjkUItR7huZ2PT8RLZgu5j1C2/vXalx4DUMMDDe7PbfnLDNeVHUwRG?=
 =?us-ascii?Q?O9ATICM1LXuom7MOUA4tFDbaY/CVEM8=3D?=
X-Exchange-RoutingPolicyChecked:
	MU0oLo1ziKGAztB4CFKByX2pfBc/rilVmzTIneM7NYhi9oRBVOLsZAmiMVH0xcZ6DOy0jfhtjxPldAYfrbwrf7yHICZZhx63pzUD5NC5Y0w+3WPfb7B6qDSM4IdbpfbRFBtEyzHe0VbyjoFQlSgKParG/Adf8z5bcEGbYqEirwQoViay41upQFP1cH+6ye16n1ndviv6ll+AupmqrQI0PppgEgMGKNQge7qtIGIWupTCd+JYLq36a6qhlpORTpGP21oKqqaL0KN/5xYbCBY1srEeeJNQv61ShA68fC1rZRwyDuQs17kdC4DxOkjlJtyqWPfDq7A+VwYhZSkGrjQ3ng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IijRYVeNxbEBLK5qlmzLby7n3MoYNh/wvonUdSdIxacAUsLfS3SUMZ2UQ5bcN6m3d656OSsPQJ+/ze39yeCN/DX7GrgdgF53nHZMmW1PfhVH3aT0TtIc5sLcO999Eb5wrWjXynjyMu9LA61p8QPehMkEPI3KNmRYkSqomaFZ5vR7ZPpdYx2h2az8c7YWOQ2ErXQa7CledcufHDBDqRxLk611C53fAdQWatWetuAhrma325/kXmRkXvpYyTPrBDNDe5SGOGjDRLz0lfUxi4OB83E4eupAY+dNyu8dTHE70IcZ+1R/3n7qR58z6Kouk8dnLcALoKattSvEMMWCDOF+6DcCMH0j61W9RBagkyvLcYoNZy/BeTUp8sDWt7/pYVUcRCvCIxZn4e1Fw8+Vzv9QKPUdbD5rEHTbx1zPsbsckIs0TFzE1aWBbwDrYmxxP+0BvxQfMkgYBfICTVus3La415SxnAd8dXaBUzsHEbVqXeDm/o1+7gDeU/SVyEF9xCepldcANKeNa5VG4yhO/C6+JCRcZ0oTlqdfc9XVxICRpv+RsuJigw1/4TXuoMkdVn2Gz9eDHBzBosxw42akommcszMZaCw2sq1XkYvsV9od/MU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf61f809-4dfc-4408-5232-08dee89df8be
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:11.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8G+jiCqlSMe88eA5TMsm9BbjKj5dJ8fTUmRV3zb8Mjf3QlNoUVO2Py1NpevWnsr8AtCQGuPyGx6698SPFO5NVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX8MMeNHCcKNwq
 D0RK6xPQU1wNriqe4DEI5o9TCRyHmIQaOBw6PCA98hbhyH+eFwjR0c2B0z7b2wHser0jqXnXhRi
 4xU4udpCumsqmSEUWC3JUWrNiyRWy1yeLV//5n1NUUhU4eJ9d4F4NIMzAHxp1Bq836NbeingFV4
 k98EtJU/D72HOJCycRYkwO1/kMv+MSvV74YN1upaFbKx+TkEei/EHFT9bxKC4xAuXrAhqZru9fj
 G47RGfr8LeMxj4SFd/NSFxP0J09A6zvD3yyq3N5WnNj7q7opWrthxsscf8mllbUfTAa6Z4mirhf
 T02yNVk2YKyK4AcodUqiXRiMfYiUFZTWl/NMjiMcU4Z9xrzRNxPwzKdKahd+zHN7vItXPUsYLKj
 WT9fHfdYx4cKz54CyT+NZoapD3LTseKojhp9tZOaMmdCx0S8u5oEPw9ehg47inONUFBhbyoNYNK
 LCorcjoWhgDtMLVvQlzw36IRrEQ0l0Gnjfdz42FA=
X-Proofpoint-GUID: EOTrwcP_wJLn31FSLKmT0Klviw9j87u-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX+9j7OQpGfN8Z
 /rdktsRHSWjJF4gTRf8dTfbkEnDWQELs7CyPYT/luyEnb4RwhI46Ct+eoBo+/A3kQapoFk4wY9j
 VDADpmw6e+bqqCAWrbgZvuQIUL/c6IG1ZYqkU3WXu4Ggfd6sf5Bc
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61e0cc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=8fwEAWchWUUFBy44-ZgA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: EOTrwcP_wJLn31FSLKmT0Klviw9j87u-

Add support to set the multipath iopolicy.

The iopolicy member is per scsi_mpath_head structure.

A module param is added so that the default iopolicy may be set.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 47 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  3 +++
 2 files changed, 50 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 59d1c0b2d3441..6228ff4be4ff7 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_ops = {
 module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
 MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
 
+static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
+
+static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
+{
+	return mpath_set_iopolicy(val, &iopolicy);
+}
+
+static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
+{
+	return mpath_get_iopolicy(buf, iopolicy);
+}
+
+module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
+		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
+MODULE_PARM_DESC(multipath_iopolicy,
+	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
+
 static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
 {
 	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
@@ -96,8 +113,36 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
 }
 static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
 
+static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
+		return -EINVAL;
+
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+	return count;
+}
+
+static ssize_t scsi_mpath_device_iopolicy_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct scsi_mpath_head *scsi_mpath_head =
+		container_of(dev, struct scsi_mpath_head, dev);
+
+	return mpath_iopolicy_show(&scsi_mpath_head->iopolicy, buf);
+}
+
+static DEVICE_ATTR(iopolicy, S_IRUGO | S_IWUSR,
+		scsi_mpath_device_iopolicy_show, scsi_mpath_device_iopolicy_store);
+
 static struct attribute *scsi_mpath_device_attrs[] = {
 	&dev_attr_vpd_id.attr,
+	&dev_attr_iopolicy.attr,
 	NULL
 };
 
@@ -201,6 +246,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
 		goto out_free;
 	scsi_mpath_head->mpath_head.mpdt = &smpdt;
+	scsi_mpath_head->iopolicy = iopolicy;
+	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
 
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index a9fd02bc42371..2dc02313b0496 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -25,6 +25,7 @@ struct scsi_mpath_head {
 	struct list_head	entry;
 	struct ida		ida;
 	struct kref		ref;
+	enum mpath_iopolicy_e	iopolicy;
 	struct device		dev;
 	int			index;
 };
@@ -40,6 +41,8 @@ struct scsi_mpath_device {
 
 #define to_scsi_mpath_device(d) \
 	container_of(d, struct scsi_mpath_device, mpath_device)
+#define to_scsi_mpath_head(d) \
+	container_of(d, struct scsi_mpath_head, mpath_head)
 
 int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
-- 
2.43.7

