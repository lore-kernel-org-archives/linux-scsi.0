Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7F403E82;
	Fri,  3 Jul 2026 10:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074933; cv=fail; b=RGrBVN6vGBuxNCgpdk1FQWfSeySTzrdXv0AUYp760DAinoeOpWltQyn9DSy660WEYFSf2JJ7dbbCsFZyWbugyF/Dd821HuLjowQIosV945Q+vzho2rq2YkM0R/r4LRhveyZiLa5e5MdFEUrRqitKuzVdQ2PUMa7a+0OL5T7r+Pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074933; c=relaxed/simple;
	bh=VhKboXGuMwIOVGOfv42aqalImvUo8hmH6ZtDVhsRm5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TYmUpjAhhVVaKKZM8B9le3ytZC/qwUJR3jcG9J0QWedxyODpR9JnHRWb/GHVDfDP7c+kS18OITJ5cr9IrBE5HRma7sKEhOgtUxrWzdL6cRgOpCbGEx5PzHkzf7w+bWp5NIlO65sNJsuX9OZ1xmt7qJwNu4I5YzEVT7GM/lQkLxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jNsLBPoV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tm0yScjW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jNsLBPoV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tm0yScjW"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638th7n3088864;
	Fri, 3 Jul 2026 10:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NGHwTZz18H6I/MB7c36ghyxfhyp1tjhdoXl6BmjK1uQ=; b=
	jNsLBPoVLg03ngUNYwKF8fvqrUY887OW4JOqcJKoL48BMTUoGIEAQA9BLFV0UoM0
	A1eGQcUg7YJI/xjRbdXgY07ROxFuxyWIQbJz3crGbp6tA0qljIOLVJPFXs01DOQK
	NrvANDitvnaw/rUfQu84stkccK2/F3ofFttsE23gUWywGrG2mTIKV0R4GWCPRRwl
	mkgrWJAjEzVD/IkrKAofsN9kreKlV7usDkwfnYkn7KvTKoOhU3TkKd09m4SnFwxN
	/8qUY2mF4oC3j5wN1k40N3GvOkge8D6kIyJcVMQxyrJLsnl8cmDaieaaAskR00CN
	tB+nXBJm64I/PhfiCMXUFw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26p4afjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7JS013101;
	Fri, 3 Jul 2026 10:34:58 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010027.outbound.protection.outlook.com [52.101.56.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvtsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jbr5X43WDu1Z5qUUTcK0aZOj3Q44Prw0OWYRk6q8pOvzLYoIO37GGp7oAOCFPQrfp7pG7HbssP/yoERLlwCRnZGwUc74SPfitPtglLGSFwArM/wZ1YwWRs+lX0+3ABTcClAznUKA62dvMdTQKRHht1pXuE6PY2sUINSnx92HJ7o8gVtBS6F1yAGMDn84W1/uwDzoSIAyT/q2UJI8qRWk1Xu3ndd3ZT4C8sL2857hU4I/hjjx6nPYcyrThlJIA1YmgtcBTzQl3sNzWj01hIEDcEI1wL1d6PncFTQ/pqk8OvHLNjPbYpjd2M5qiTRCJms0a0PrYH1QIffhbcX8RB3A0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGHwTZz18H6I/MB7c36ghyxfhyp1tjhdoXl6BmjK1uQ=;
 b=qZZAm94XodIJQC4PV8Qa/6HTr4wkl+PAouET6rlrb13EEBUL/lODn6tE1znuA9yuL7XlP+nmftKAG5Kd4GXtoJpCov1c/BxPXXJTQW9Ydo+LNdUl1kxyncUl0IW0nGQ6qg6xZeb1v5gytnFrvQ6FL3Ulk/YcFp/UYf3kJvLbtRtoyFK2ChB7JGWX1lGLxiU22LGg+JtIU3a+9WQRvNPiruH71hNFfKTjr21e2VMjERgb23vl6TVsob4uhWSSYE3Lt7UisoNm7ljy0YmHutAaoRpgCDri9qPKEyTB+aTGnNRU30vbhQYBP1lI9YJWl4xk/b15kCo+ZRzLfwwyvbCSSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGHwTZz18H6I/MB7c36ghyxfhyp1tjhdoXl6BmjK1uQ=;
 b=Tm0yScjWYTp2znilJibo2OMIli44Cc047FGvpEO1EKjSN/lOlzZvkaStudPvC9AL0fGvSZchQWYS1hmBsil5QBH2Y2hEEIvLyr+Md6l+lNqXRcrdaZvpw1fQTF8ByMZbFIiR/DskrUcR9ZgelXhJr/94OF0yxBjxqVUgalCstAk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:34:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 12/17] scsi: sd: add multipath disk class
Date: Fri,  3 Jul 2026 10:33:57 +0000
Message-ID: <20260703103402.3725011-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e2d6bd5-0fe0-478e-a6e0-08ded8eeb89f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GeUAjRcI3oLVdD0ZzaKr2YxHYMtqtEqs4v89B0mElIfICoWHq5J1b+d/ZclYRYrqKZy3MFPZUoo2n5RPELo+R8xhtHdspfapwk00FKd85k4J792Hg4hzGkQp73NLvfuvnBNM5QXPR+LqFNG+I7TjwWCAdPihEJNXKrZIBfUfvju+dgtXpyV0VogOwOl/c6nAw0+fL95wi2+HRRA6cnA20S+83z22HPcpAcmyLcacgqFHLS8UCLJ/2vcKwi6KFRjhMQlaspXzQ7jvyVjhFF6kRLol2CO7uwvDtw/avv3nZE/aHvjbMHRbHr5yN3MrilKXZAQhOMwyUkQWsPgMNOcfJOpUwLbebpCFPN8fEfk2jxJBPcghyjrm5eaMjOnwz+xwFWLrD+fKqr2uHKXXfV5gupRLrcuOvuGxzMB0eipip9a9TpkCGjOjrW2Wl/Brkg7l4VNyiqn2xRlw2nvm2dCdU1DvhgjN5wYN4J8cPWbeVFVSGK/5M7cvElUusqD8AGuqdgYvSCViE0BnsY3v0fQdt21cfow77adsh6bJPZ1coeuM0Cn6HoqewjERzt54nuKH6ufM5OJZaPrVv/wYQyR9ZXVE14E+fxJvFp6mwf3C5v1ISS272FyPRWUVWERLYSBVOqhQtWisypFeCg0nxx8KsKeyrzROWlRFzQdiLqfkyD0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ubqnh8FkNWuBi8FEy4HJyRkQyZ3cIs1RWjoZ9R8D6TThNW4ReeYZfN+qcjy6?=
 =?us-ascii?Q?C1B/zhxp0/7M39sHjyoJIbLyajb+MRtHc27l/YtZmrKkRHGCP189wXlUjYoE?=
 =?us-ascii?Q?rVaQCyKFe2qmopTGa9gXyKF4ktKDLcFcjEBOBK1lMUeLQT2h//tNfvS5PyQ/?=
 =?us-ascii?Q?2banNOIb+wpIFdGd0lGR1O6geoh41DADjpn2whsVVGLB9ReMCT6dSMHVTBGy?=
 =?us-ascii?Q?rxNkuGPbDUQCN7prmK7UQF59IJ4lydjgo9TVyYcJ13OtXiY7HvKE1Hf7OyKD?=
 =?us-ascii?Q?IBGg3HF9YdZZPQSYsel8uT2n0H+0F/ceGX2F0/ki7bsOPx1obQEEDwmvB5jV?=
 =?us-ascii?Q?viDnon7au6ibewfTfPUht3C7XyXjivqPalxUJ6eVDirjwBKx39nKGyB+Qkqo?=
 =?us-ascii?Q?Tyj2hrAx5OiWwnVcJ4FjkTOmPwr2DEKCK5S7P60+4KYz6tFE+TSIxQsUhlhe?=
 =?us-ascii?Q?idLCiytSwzDiuIg7h0oc4kzLLRiYxA98zRguLyn5j4+RaFeMgYcOA08alsBN?=
 =?us-ascii?Q?YK63LXAjyE1s7h3D8QtSgSx0wehvL1zQVRs13wbHaVtkuoNbR/7XRkFGE0+z?=
 =?us-ascii?Q?z15z16smEfTMKAkC8TbKYikZpgqwhmmb1HHLB+fHG1nFAzkrEJ6otOPvT0an?=
 =?us-ascii?Q?kFHMrDm2nY/DZdTdAA8qxif8PHtAokagewx6HVdyb5GjlxmEJxiuWK0qxWtF?=
 =?us-ascii?Q?Qui8/ff+2sNZg2RRS6thOUA8fO1BKTstnp7PTduSCe6aku7hseO+v0AnqOrd?=
 =?us-ascii?Q?t/fSsSV3apFiWmjOj4UZ/CSKyd4vE95kyuzdT+dj/eF9knRJswvNypuPeK30?=
 =?us-ascii?Q?40uBEqKITSe2564Jrw8LKry1CwK3xesnFghnDNYt83s+uuDzJHAdG1siNfcM?=
 =?us-ascii?Q?EfdwgXgwkX99EEk1hFOBbRkPGJh56kSJRZjM1hzFUyEhrICsHyKpV29f9qTW?=
 =?us-ascii?Q?LkfK72fRPDQauyUWpsCd5iTfrb6tvkgZKS3texpPRVfUI1W9javJpDnW/VhE?=
 =?us-ascii?Q?Gsninz4O1TmevcYEkojbbppPaWDzQvPeaYTzyXlXsqczATHbHdxbmaUSoSD3?=
 =?us-ascii?Q?Rp3LyOlHVfyuYrhfEWBeXqDjfMHTKOOYwPuhnUaUT4BSbACg90hi31oL8ll5?=
 =?us-ascii?Q?rtoS4NdKfnkGyrTUCiJi6//fl1d30Y1K8BEvCfZdrKCs5ST2HF2hNqyhwVRG?=
 =?us-ascii?Q?IXOEE1Dc/Gh6wu39zmLVfWf8h7bjS4rmqAhOt81R5ATEnsw9lBHCon61b3Nr?=
 =?us-ascii?Q?0UqYl33TWKRVCFutwPQy6LugIkF6e6q4/4WWUhkb8DEZ2Z4ODUNKo6J9jtKP?=
 =?us-ascii?Q?6uKnuRFkJT/6xB6TcWxwPtlm600bzgocpBJNNgAmX3vv/Pxlg3DCWIA8GkjE?=
 =?us-ascii?Q?QW+YcA3Mw0XPpmHpm7CcyB3HXivXF7LPtgnrJAk4v8hsQZngYk6hAbZqgi3I?=
 =?us-ascii?Q?CJ5YR+xRN26pCQ5rfFJYwFUZwYISx8AKasGG476jlhUrpBx6wXp2h6E8TCON?=
 =?us-ascii?Q?V1gMrmNirqlmYSt9Q41kIv2YlGsmxFPaUorJ0Tw+R/WAXLjkpHlAi5MdjYPF?=
 =?us-ascii?Q?w+AEQydoJiYaMbiZ5XBSxZkj3gdsvr5uR1IgOMm1KNaRrovpIfmr4BjtA/DT?=
 =?us-ascii?Q?OCfGMTIc8S4RrdFNsQZeeuLV9yHDMw8kXsQxNAFhtPUUi1t+FJi/r7ByE2BK?=
 =?us-ascii?Q?yUZqogVzQZ+CZg61x92MGnqB4a42dbj5VXXfCm6ImwQADlw1WEgsfS8fwoof?=
 =?us-ascii?Q?hFjhOcu4vgNlWeYHA8YK3R/UxZpNXag=3D?=
X-Exchange-RoutingPolicyChecked:
	ZqYzPyWtRQMHouDCc8yH06KbiimpsI5YgkI57VaNiRJm4W1yh7oULL7IzFmZRtLZc0Ce80o4iLBm28x2nnytZLQ1zRRgnX132Qnsor+EQ+ixd1GHs8x0E6NqTY9zsg9IMLHo4xU93TvKI/R5UuvXDkLjTT0Qm5OekMkFkZCgF76iOnxNQ0qy8tb6gBJg4TKbXipjcDHrCkdRCV+rikZf36GbO0h6/uPaaDGrG1QWo8EKbWYWAaURljL6ZPfjfck64Mp+20Q0A08HwHWjl6hZwkcPbN2RdRA/uEvJE6XMfAqWfLDESjAUzV51wUutUK+x+e7SsDriHEygPD1vOgC76Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4PhKRkBv59KwztZCxqcCbjG38XkZ9kwxHBS4gV79kmnlspeRB2F/CNmLQ3dEgFp65XS4oHEwziLi3SKT4IN2GBCm3m4Ev+bZ+4r3QI3bAqUDVHkBVQGGUQVv17YtygiY3PKYDP7gi74ije+N1kCRl9c0gcs2GuiUSsaClg2pjj34zmaxB/iInS3pGPSpmBV1gl2Sup0ETtMso1oMKsLD5K5Qzd32Bh4FKKOwAJTrWedAijy76/XvBswIbNIcwEDg0oGu6lSpdZoNaykzP6EBeGfW104mldY0PRMv/1KTwqMONQmlIK4+nw5Wdb8bC7tCVFV3iYZLM5QlIScrWPaaoI8QZDCfwpMrswBuGeV4aoCfsULWvNfMCSUXj86iJDiNuMLG5Oflt1zdlHyuZAbkzyPaPxZx3Z0X5imQjtBOvnFLh30yi++6LhHqgmI4/k+PO/KiyGugRE3GHcGBC6hktGkhi8vX7Js4RPZRytJMH6sToBgbxM9yCCAhqVPkC5bQGPPPK2Dc8gWovlzx5Zo3788G9rAR618uaIBJ/Bt8zOEjx2hQMAMeKd6CtfD57ykh2O6tnWfRxn4ZQ+dtGZJnToMyEiGTna3N2ma5YVtjUKU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2d6bd5-0fe0-478e-a6e0-08ded8eeb89f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:55.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvjRyq6gJHOFln2t2tronpy7VVidxc7j/zNquQDfxfu3YASTMMd4t4mktB0x1m8W82hGpHpZCyXodOjakFOmWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-ORIG-GUID: yNWpZhPe3Ob89b_XQl_0gsomnQuh8Ht1
X-Proofpoint-GUID: yNWpZhPe3Ob89b_XQl_0gsomnQuh8Ht1
X-Authority-Analysis: v=2.4 cv=DK6/JSNb c=1 sm=1 tr=0 ts=6a479053 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=ecQ7zCoEdOpy3JLqRw8A:9
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX6zLYTnTCrEcJ
 sC0wq9VtKbQqiW2e05QkMIiAeqUD7Jp3EFrezV2hxuavUXM5CrcENRCvLcEgnZD9JDw/aN52Pn5
 FUNIPyskbf2zQw3vMpht3MtRYMFEPg0EqWqSeyGlmkgwDr4pzOHWF2UpK5+46Yf/jTHa005JuZV
 jJTS66+B/X7x+/lSO/L/TmjtEIzQgNSCs0mZBVm/rqeo0a+IhSJu0eMX3UUy7oo63E8wRwH1y74
 KK+joXxjHLcmAUHI1tWP/uSQNAx5Z2L6cC/OcxdnAYPu49VoLr5u9/sWDJtuGna7Yvs14ABkIZf
 8PQ3NO1Fnves4Sxf0h/hJzBpWulafN3fz/+2znuI2Ayq+QmUVG2y9QjcJiAZDPGkIb8yxOPpMY6
 rDX6fX89PxhLWmGw55jPD0nqqpFOhvoxNOHayYVVg1COLY7/vGEzjohW/6daqb328GWC+D1BbTd
 fKUKSuQibJJbog6tZMg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4ZoNNZufUsNs
 ttN5RulD2obAAJLbMOGLlgcJa/TsPj2ehLxhM+CWe//exLWG5IbI0tGU2eIGvl2PHMEQWxi54KA
 IYLHTL6V+RXjN/qT5K57r3C6MUTjyZDQX31aN5hGd/Xmeil60+9L

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..242a15bc2c5bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4453,11 +4487,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4468,6 +4506,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4493,6 +4533,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..304b24644d942 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+	#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+	#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.7

