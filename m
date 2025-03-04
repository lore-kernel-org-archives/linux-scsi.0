Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5588A54769;
	Tue,  4 Mar 2025 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741053731; cv=fail; b=K20cJGHRKunwpLOtlMj4ppFeMN95OQHR9LPsGrHvD5cGwqcd5Q2SZ00T5EQ20Ec1+Gl8+EpRttqyBtNc311KJG+hhVED773Jdg0j6PhveYlaJsQqNfVYP8JAaDXbNMYyI/V6ezJUomJNt2M6XNMf7u30BEC9WbTsFTokzrjnchU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741053731; c=relaxed/simple;
	bh=7uKC10S2TFxktTKSjPAyUmERADVTNycHIl7mMwBKmmc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lNcJwaR6a09rI0cc95PW/qnz/UPj0qqW6EEWGjReG2ReWeI7USk6aM+iKL99QfASYaeLemrJsJ8CSHR0uw4/f79k16sGLpj0EaJj2o0z/1iSn88L12iQSk2Ap9CQr6QYQAPxGQ6TrWQWNL4wXf1YetuG6JXBrjH7vjuzp+nSk7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FBSdnn58; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DT53IY0s; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FBSdnn58";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DT53IY0s"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241Mg40013446;
	Tue, 4 Mar 2025 02:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=/8kf3M1TgmVfaHfkgq
	Rwr/AhnolXdEHwXqsUVIK4gxg=; b=FBSdnn58wPmXKFpy6fOZ0pETT/IJ4Q5BUU
	8vOojsKA8fzPEyEdjskj5Xe14yeSoGMIqwdwwqOCwwBRKU7XflvcZEtgvRLjo732
	b8uzKiCJsAw7XYfSedqSwnZD/nPUh6uR4pWdwxtusmAvJgVFwIod3hJS3218QzBe
	w+gdFHsbpOXg1QEdF+BRorVsT0HiHkKbfQo0LS1Fy+TG/Buj0d1NOUX8sLjE1I4T
	KkDeNnf2L+c2mq6DfRXgj2Uab7+qqAA20182rJh5fGQWX1sfhZtDi5mH50CFkuXX
	WCbuGemUujw/UisScgwmj5dXJPdWQMKHIKOOMcYAuuM0Liefau9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub741ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:01:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5240FhiJ038259;
	Tue, 4 Mar 2025 02:01:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpejn60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:01:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YU7skJuEEsCu304AfYx3OOSXaNVydWW7XDPUoWfGVr8m5kUVKTmR5fowKX6rTjxQ+rriUvXU15WMfX6OEIl2BCciUz0agQHN0p0yQgTLtqeNJe7bfgjHPDDLklhdg8lNCkxbyewWY1F33loWZz7iJnoIW3TFSCX/n5YQAf50wjfuj8+VXuF8Y5DzQg2RpP85wviTGX+TfA0nO61YIDK03g9LRAEhj5byegv7KR5wXhlFEWn2SPNp3O+oReopeFRhPT0QHRv66XK/7H2uieBPxxYrTox1qhpXUKlxav6HbMUsH5E7v9lZygMAFGp/4DHpjS8DbCWkMU2+maNLIhf80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8kf3M1TgmVfaHfkgqRwr/AhnolXdEHwXqsUVIK4gxg=;
 b=ptaQLfOviQczaBlJoaNA4uC6qR/Qnx9WA07/VBpFgnhROTtQKouXIt8vVHATslLyc1ZWl5W/1mo49TRVF+iGgUFu2Ku84Zq/vDpXYqG3JF8116tfNeiTylNiU57jHNNTq42jyyCz+LdyxRrAdvvIUgO5eDd2hL2yjJq9jQCDbAONIrwcQ6jiml83La6QYGHvE7iJu1sVkOY6lV4ASteox6H8T5pti1CbAzScOkXppr6mQi48RNhjgJ8UfmIqb+1cN3qef2fG1spKwGVERNEVZ2CYNkAiRYLGNgCI1fIQ7T7psmGpb+uwTSN4BFrdJ9zgtt1OgeTJHsFDm358Kxhu2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8kf3M1TgmVfaHfkgqRwr/AhnolXdEHwXqsUVIK4gxg=;
 b=DT53IY0sXBc1nm0QpvWjMc4+MijmObOy4Q/va+57e+bZNCKX4+uAHojzqQrtBmj0t9CE5sdjIDvA7dbHI+febkt1/CWivgisjP5iJwE3TWxLjqoVba5FQfnVxNXSrG7MsUIW8piccIdTq0mCai9v60jJarvUKUDIx5DYv6Tr99U=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM6PR10MB4220.namprd10.prod.outlook.com (2603:10b6:5:221::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Tue, 4 Mar
 2025 02:01:39 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:01:39 +0000
To: Arnd Bergmann <arnd@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        John Meneghini
 <jmeneghi@redhat.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?=
 <Kai.Makisara@kolumbus.fi>,
        Arnd
 Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
        John
 Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] scsi: scsi_debug: fix uninitialized variable use
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250225095651.2636811-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Tue, 25 Feb 2025 10:56:47 +0100")
Organization: Oracle Corporation
Message-ID: <yq17c55wo3y.fsf@ca-mkp.ca.oracle.com>
References: <20250225095651.2636811-1-arnd@kernel.org>
Date: Mon, 03 Mar 2025 21:01:37 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN1PR12CA0018.namprd12.prod.outlook.com
 (2603:10b6:408:e1::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM6PR10MB4220:EE_
X-MS-Office365-Filtering-Correlation-Id: 3237ce51-72b0-4143-8c5b-08dd5ac0808b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MLNm//+jLjKVhydPdNU0QhzQjSTkuzkQCpFYDYmrufdo+TCc+N3JYHCxnkbP?=
 =?us-ascii?Q?rWu/F9DGNaq+FIn8s7Nx88UeWJh1CgXH9Imt8ioxDyCD9F/cj61dxDr0+znW?=
 =?us-ascii?Q?pNVHyJyiNC/I7z/wGoQTK1AP0Kp5JcpE9ImiiWBRQCNlUkltQJLXfE5H7j0l?=
 =?us-ascii?Q?ZuSVo1/H7E4XJA6ubPuNVMMXPt8iNKf5djNvMqd9apCPZSmYbh3idJ95E8jZ?=
 =?us-ascii?Q?1U28JHkmgBMaSp2ipb4mLU+mSy8Wk2jEyJZQc317TUkXqEDmXBfjyf1kpWxy?=
 =?us-ascii?Q?blbmKqeqPPtufPcm6QbG4/gGFiOoF9Ej5oB1wty7ub/8X0qE08zTRA87QYI5?=
 =?us-ascii?Q?v59CVTkNnXZ2Dr0zj8xgfQ4tJT4tqE/ffdQckpi+m1124Bu5iNbOAZy9legi?=
 =?us-ascii?Q?HdHSQXwfvIsi6p74aqSCMR4y4hGgvf39zoBhRw359CB0dZ4eWu0goxONbGE9?=
 =?us-ascii?Q?D/csaXq9BcbeWU4x6++AfpP+UbxW/Nv7h//g1CPsONSIVqh6XIlRsfoFzTKQ?=
 =?us-ascii?Q?kJIvxI+tVeVcEuXnUxwOE+MdyNjDDuxSC5H2SjioEwzcv4v3xhdyheKekpht?=
 =?us-ascii?Q?MOJNIgaGhlapCHXWmRlw4OrfUf1ye2fdJHCTduoTcape5jidXNzSdRMViBLe?=
 =?us-ascii?Q?94fKDStlxbNBpzlPZErjGNX9Y5Hjr2MWyMG2ebAuNjX0Y9M5A3P33qquyy23?=
 =?us-ascii?Q?1iWv0+c9xwRLniAlaA6IGLrRLvC8+ZN5QDoIEELd9FEBU6tULfnkuv79VABj?=
 =?us-ascii?Q?kEgDG5oCGUS78oLKMlw2Ig2TrfKRqE+VIBY4It2n9JPDasZC3Hu30EuQmaP3?=
 =?us-ascii?Q?B5ik8pLID4EGmDhJwIoF0FZNMTMUufh+AL6m6XyIbHSg38LNpj9LfvoPn11K?=
 =?us-ascii?Q?F+YNXIOO4itoYIgwGsgzsPQWXs5/Z/UMYVPPTNSg25ASCICqzaJJSugvRRdM?=
 =?us-ascii?Q?A2YSZ8JMGMp9v3Sy31Ol09Owq6TA6joBiyxWICtTvCc914hWIjcPffNq5CUL?=
 =?us-ascii?Q?x2xzTx/yZ/X4v3h1Om/7nq6qrrboXkgdm/V3C/XCfFz3SLds3ENz8/jzBV9k?=
 =?us-ascii?Q?/l0KIFPCnDdmCw7VE1QK622zWuyyR+RLgLyLXLDEJX1LCaFOb3aZlkjYqXso?=
 =?us-ascii?Q?6bh6b8+I8cBHdx76M2BU+UYFLA7egFuU4aeV5McZHJ3Xei0nIWLcfZS91gfI?=
 =?us-ascii?Q?oWyoHaP8zcW7zVjQ3re5e9hu0n4J42hhVvc/0Ew+7HTtJQPKR/jAk/NcsZA5?=
 =?us-ascii?Q?U2Xz0qqKOclFU08ERHnMMFMd22rHbNOVZX8a+lEEKMH5zgODluD91HtQn2zA?=
 =?us-ascii?Q?7diE9JIpRdDK/9prFK0R/w9dytePNWshwHlkqNv/uB8DhPRylY6GhiHn/FTu?=
 =?us-ascii?Q?nV9P7ZQtQPPEmBCV6fxT7kRJS+Ja?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KxQ1RXKW4r34hYdXPQ1iluYbskPI/cL3qNAVvLaZrwIRw6PRLBNT2AByzdf3?=
 =?us-ascii?Q?NXq38fzxWnvd7u73N8UC1C3xuvDT3apVNgviaZ62G6KkED/nxvrFsKCws7VW?=
 =?us-ascii?Q?UJe6Z4WIMA/9a1wt2+gbK3N4CTMEzuTkKLAvk7H4t8/o173E6W6bDOKzodzY?=
 =?us-ascii?Q?HBJD2k7EXOf1znKvYTUxstB3JOlvIDsVRFisolp6Pfh4hH/rYEMZ8zIO4OM1?=
 =?us-ascii?Q?IgvF/roOwu67A8b2LhRNZa/L8nUPYRH8PQH1cesZbJeHWEunfKGfxjjp0N8T?=
 =?us-ascii?Q?qBtJy52W6ojzkkuW5rPU8qUUxrMZL91g1YsY925ButbBSgF4BID3OxfQyObR?=
 =?us-ascii?Q?p4tpH2Nge3XTqhVSEj4021718u+H4I8duqZAt5x0mEkyXH5V4VohFU+3ilVS?=
 =?us-ascii?Q?8O9yq4r306H81dOz5cr7b3XjYiw2bkN5IhA1Q4ruVVRogvbsbINnuFOsD7Lh?=
 =?us-ascii?Q?IJb1SEEMzTZfZn+gNXWzjfn4AXLuW8TWkmvTffabsi3+2b9wRheI3H/azHqo?=
 =?us-ascii?Q?f256vezOa0PcXRu0cT5oejQuxNnOJFx+7nSpPipimLE7wm3xiK89OWDeQm5N?=
 =?us-ascii?Q?d9SULVNKwHUYitD5ILRNAnXuowFd5t4nY2/ChxOIxT7O2JYvn1I0Rbx5fKEn?=
 =?us-ascii?Q?ygg9FPHmIPPKMjps9nlCdYhFWViDPkFX58ZVa8I+0HK4Q5pq4ah08mp8cBRw?=
 =?us-ascii?Q?xeQ4CtPDlpMRuxk2+ReUMjOU9GJJkSsQmpIxHWJdw/brLMgKdzRWGv5IdYmr?=
 =?us-ascii?Q?bIB0M5GKFaOVK3SjAoGVPCQo0sHvMGPLgX0k/U+6fvXWTmuggKeCCOeeJ/cX?=
 =?us-ascii?Q?ozJYq3/QJukq4j8XgYJ3g+o7IWfKZc/xr+cxClgwUQxTlM4KZZ0U/QY7GlyR?=
 =?us-ascii?Q?mw5TtGsZLDncm9jneAebDyW4bCoQzZhHJ4Hdmmge8qyGatcI6ZSgVUAMwjVK?=
 =?us-ascii?Q?W7EaknInNdi/IOWVQQdoWUKdZFuNrUnhy5rEIDlNAWkeKgPDP9QZ6V49nJRm?=
 =?us-ascii?Q?HM/m4RY5IGEQ1uzPPn1f/6aiz+wPGTofqfzFdNs3QqscDakWPoFPsmVu0Zhs?=
 =?us-ascii?Q?aV3gPEgACeQnOkITlNgN/ynaivObgY33lsI9AcGjNd1LoQ6ojWq2bGL4eWrs?=
 =?us-ascii?Q?RZaNuPItZR45PzRTSFzqOkcGs51EjHYRpJHPI7yhlumB1mvw+slIYYFjkhK8?=
 =?us-ascii?Q?H2zASSTu6HkK1Bq4lPtO3p/ePu6f1OCDaHrsACBcirhsu1D1UT5pO4/pOWNS?=
 =?us-ascii?Q?cp5S2YwHsQiRXJWeIo4c0RcjQU0ClVKTqSZnq1RrNCuEdXO+L0+zE9iYUweI?=
 =?us-ascii?Q?hmNizZWcKlhUccvSl4zYdfiFIZhfsHNhGbQ/ImKE3GvQ3cj+VY6biKBT028v?=
 =?us-ascii?Q?jNq5etWYy6Ao0km5LoIFIDR0nPlEZAiQpXkKIGwsNudfddkOJRKIVfMsbSDf?=
 =?us-ascii?Q?rfts9w/ucMgKrPZh6gmZvxHTKgzWVsKEHxvmNmz0IXy7OMc/VXg1ioO6AmJK?=
 =?us-ascii?Q?tcCIKVCgFDLlvbvgSjuNYXNqp4h50+F5dqAUCyd3sBf7dBy6Z+ihkEEqy37+?=
 =?us-ascii?Q?mOkNYQ12bh5uaAKPhg9XUDvmES5KlyADQrAxge3q4tmwHJdf+uq0qL4f6t09?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0Sluh6uiH9T6FIWl1Ecybz//E5+Y4gwtar4AVXjthQR2gVfx2mQveiLZt2A1EMC370ZloYa5ZTFcbQKZkElrpW8CNesENTCv4loGIxokk2diwBk1IKmjitF3VSv2UZwBKU7IYz7cYH7dy76F2Yba6FI7BBOvOKytH2nCFGlsSP+tMvnKS/BCiC9u/Grf80wN2QhIMp42tazZkToGlK382ebjyphwaHs1XmvkOzZSWCGoTCIi6Bk49oowCS372DHPVU5+rv8FjjmUkZmGNuFIpfJC1Us+rFR3B7EHbJWjKUKasfmJHR0Q591ArqPJHrP0IQHxDeGoVVoSJ0bWO7tVGXcIqXrxFX4+DJFNmlDqLojYwlMp6HtMlI6F2riJ9DEmWRRXUrOX2rfTGwwC4VNmXwcfZgQ2Uz5UxdugyToGsbwNvaDCP4s1s+ibCBTVSXAehgnZ2MB7TJoIRjELs5whcUl/oeoTPFXUDwKgZEejRK7YD2mt0JrIKU5EINakfSif2Hv0TfAhPy81W/nSmknpYQjvb0MbmVt0+8V3wfY8bTlKh3fwjyvlp06g9tW5Z3t+fZKKYrN5Pr+c5MiZzM8qlmAEvZpGgZtHhcuZQPIT1h0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3237ce51-72b0-4143-8c5b-08dd5ac0808b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:01:39.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdjI5Rl3F1GIY9aU9jFtdV8It6hf1rVRS4ty67AMUKITtkEr5564omGcoGvK7sPF1AxCKkM/jwaKNYFUf1HKgEHMJRAn8th0+IkZ+IqFssM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4220
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=869 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040015
X-Proofpoint-GUID: QpzjtT_dStFaCssqlAIzZ0JQm3f3iUD2
X-Proofpoint-ORIG-GUID: QpzjtT_dStFaCssqlAIzZ0JQm3f3iUD2


Arnd,

> It appears that a typo has made it into the newly added code
>
> drivers/scsi/scsi_debug.c:3035:3: error: variable 'len' is uninitialized when used here [-Werror,-Wuninitialized]
>  3035 |                 len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
>       |                 ^~~
>
> Replace the '+=' with the intended '=' here.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
