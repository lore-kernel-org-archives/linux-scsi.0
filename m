Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A434D4D3;
	Fri, 20 Mar 2026 08:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994523; cv=fail; b=dEXI2Ah1YMH9GP/Dp/BsKOOsrgo4mP2yBhXXUOvNCA7Be7M/YR6rM+ZcY90mKtcF1e3pNDgXXvZ3ZYIRRnV3CU+HUuZmpDNxLvTL6EWuaJJqNrvXRGizCS8ABF5ffeapqWFzfwyNX1e2wokQr8V0beoc+fmKfL7iqwWsFSFpKBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994523; c=relaxed/simple;
	bh=j4zpLQnohP9X+col5K2BVLU7GmAdZhxc+Kr+brh2Gjg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BWatRf1bDEZo12S4ijM7b7Kjz3SIXkVhn6lqJY5XtnCRBCAJGQJcv/4wYer+Xi/uidKJRYbQcfD4+TU+Qze9h9gd6jOL08o6xI4CNj/70xNFM3nN4NH2eicoz7mUMqd2mPAhHQYzS3pJ4+OBhuE+KHmUyfFij/IAEL1hy7HE/so=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=e2tH4Dsc; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="e2tH4Dsc"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62K7o5Bj866817;
	Fri, 20 Mar 2026 01:14:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=isX445hcG
	uPuWVYrtJvVbd3d2/UgZ+FyugLcZAB5428=; b=e2tH4Dsca7xY/LIvfCyJNtR3p
	rxazJYDKlQVG3yAxgJwVOf4dhl52xG1HOrMbVdZV+2FD2yWVo+UasC1T9NjQGwTF
	WRA0hGtbt5raa9P3z1EdyDOuensq5qswgTneP9RaFDhMWSFfc7Jya3nN2/NOulVz
	R430i4biDXECbFrl1hrJO8jtGq/ICOkzMWegkDiiYLkgyBaLl7zNDp9tXZxHr52Y
	xG17SzEutKBaayL1xt8nvVr1V8fDRb6f1C2gkZxJ8VUr/e81cbvlob3JINChITBJ
	dPi0L38sDzXnWWso8MNh03eEUmAjkZwezAZqaZoOsTKWBXcs/Az7CkRLU5OOQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cw2y17qdg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 20 Mar 2026 01:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+mBE3ueq+ME/nNZW+wEkCseeUMzI+tZlxpdbBZWgR4aNadiGc51iewjiJZCE7IBlVn2IvXbw4wEGH+LenRE+BMb9FY+2AAg9x96ClDR7CtllThSQ9RVONocI3XXImQ7QQJaWY2l/xtxNL7wVoO3VUQSa24TP9SHd1c/qN4gXjL9qr3vFftRnGtzYP4ZqT6GHrt9zYbp5uSi3hEHnTxwuzjb7VjMuFYmgCLGbQlfrmshuMaD4M+zdQElDJNN4E8EdHE5M+/F/Ad7SjAtMddKqkPZrGsRuHLhrQWoKx2T6dOaaAPOwS2vXSQDNmOaIJsbXf6rVsmmeY9mzk+skz4dbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isX445hcGuPuWVYrtJvVbd3d2/UgZ+FyugLcZAB5428=;
 b=iMWXhL/iR8959xhvoey/E6fGovgePU/FByCaoIJYowvu2FbMvy5i3EQXt5VOsXZDYI1U5n2BLHtcK7TTzYsaQPI//qe25RbBqm8ZQKgYz0YIjnokyhP2uORwHz0qmVxtcUoIihhMxCHa4zDRsxcrXxLUJP7XQRJxU6EFsIvcWgkpyzoeZ5E1NMWZl62NApTmr2DsZggssNWu9BtGwkEDf+ewuqgcz2EElED2l+h1AYBbAW1X6MvXyuAxQmbfL/B+RrCwJqiFnCxU2JqV5w7zIqxOF4LdvsNsk893kt73FsI0yVwPHiV8HKk+VkdINSWzusXi/WF72hWaWVM9hnhWuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SA1PR11MB5828.namprd11.prod.outlook.com (2603:10b6:806:237::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 08:14:47 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9745.007; Fri, 20 Mar 2026
 08:14:45 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, dlemoal@kernel.org, hch@lst.de,
        ionut.nechita@windriver.com, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sunlightlinux@gmail.com
Subject: [PATCH v5 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Fri, 20 Mar 2026 10:14:28 +0200
Message-ID: <20260320081429.42106-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P190CA0015.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::28) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SA1PR11MB5828:EE_
X-MS-Office365-Filtering-Correlation-Id: a6aed834-84eb-4d29-8235-08de8658bed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|10070799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	yW+zamkB14+9Ru7wzri4pis2IsIXL8I51EgxkQpp3P2SiRnybL3Y4L+Pzwf11HJ3gSbtiEuKvkRDaOnNx/CLfmmFwxy96qOts9f1EHQydPFMvfMQ3Hf0oOSAAY1NTgUzmUtEtriJFJpfbA8c3GKQm4ISlsJzMF4znfz0dvzjxVqhNeeZEdc42MevNOxtdBcFIfood5jmnKv+vRUrti/hjcrq28vjcoJ1d8XsrXSxlBYHpg0XlTxT+b+SP15lDfQr4i8VxHpBsMKQngXUN7ZghhKC7GJsEUB3TptYwT1mZU1k6M7wGOA1txCdxcyLfjexW3ofjRsxn7SZgrDyXt2Z0TSRk8ov8UR9brMjqW5YNxJDS+gwQTL4XMeUP8F1hV12La2Q1HJguXCqOYz17Jz8NLBkpyyGjE3Arh178WPDut9es7iqRTqGS3yYLD0wvEePg8fuzkSGY7ZtKLa6/6UxA8I4qQGCufSq0h68Ig0RiUa483uo7Xrnw3hl7T8M3u33AP2YafQExy2gIa65DV4LXK15uUHEYYbBOTMdBMINut1oEf81oT6zf3X3ytWpoxnSNZ+WcayqAuPbCquts95/UyDSwna5JHNDoNzHbnb2VUvXicKosw+tr09Vc2IqMnenVAqDuHkdjxm29c0UDlCt4QNsvz/Oc4xEocLc2ZrRqHo8AdFNkIgsbnS/3vqvMN3K3xhN8G5nAM8wTJSdU0EUIiKTzMESLjeIElFBu7DIqekICLpCSJshGFhFPEws80tI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(10070799003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjJEejZidFk3Rjl5aGtjbDBTMWFLTy92d1prdHNGVEtIdDNIM0dPeWNpUmJS?=
 =?utf-8?B?d0ZDVU1VL0s1TmJGYU1lUnJoRXcwZlhiUUQ4Q1RNdkpPVTduUHpQcGxFZXdp?=
 =?utf-8?B?elFoVzZGUTRLUHBhVmVVYjMvSm9aUGpmRXFyZVNTMkRuditUZzU4U0hLYWU2?=
 =?utf-8?B?WDdCNlhUR1UvcGo5OEJOUkloV1l2TlVuckNXaVhncW1SWld5VHlReVdacm03?=
 =?utf-8?B?eStnRkJ0Y2lhTFNrMzFseFRBMEJmMlJhNzYrQVRMK1YvSVdyS2tqSWhKdDZ4?=
 =?utf-8?B?VDMreHV5ZGxVTHhqRkZ3bC9CRVVCeHk4Rys0cG9aTmVJRE1CN0h4eHBBQzlo?=
 =?utf-8?B?Ym5sK1V5a2FVeXdPR05DelVTdU1jTENwaHc5NjlzWnpTY2YvRkxId0lzMXpw?=
 =?utf-8?B?KzhwSDJEN3JXZGVHaHQzb2gwbXhDUkZsVGhkWlR6b0xFSnl6UlQyVDZGRzFM?=
 =?utf-8?B?MUNJVElOL1EzeGdSdU40aGREQlVzV2NhYTJlTWQzMTF5M3dGZkttM3I2M1Zj?=
 =?utf-8?B?ZHdmckJQazRUcXBzbVJaOWRWWHBnMk5GVDREQ0x1WVRlc1pDcURaRjhTK2pv?=
 =?utf-8?B?SkJ1MmhHS3JveWZwZ21qOWhBRjdrbWtzSkZEbVcra2tCaTFlTXhFRTE5ZzRU?=
 =?utf-8?B?Q0tkRGQzMjNxK2RsUlcxRDFpYkIvQ3d1NzhRQit2MW1GbkwvREgzRkh5K2hl?=
 =?utf-8?B?SHpmTGtaKytYNVVUak9kTVJWOUtub2tWbERLRlNQNld4MFNZN044eC9FTDVF?=
 =?utf-8?B?eG53Tk90YjdRalZZR2t2WjBmNDIrckNVeElaT1VhNzJsWTJGQ1dUTjIwb1Fo?=
 =?utf-8?B?Z0VBOEdIdnVyUkVNTm0zNWU3ampEc0dZUEFxU256SlVKWm14c2g4RDM0djI5?=
 =?utf-8?B?aVhuUEViZVgyMEg5U05ZdGZ5bnpScGFJWm8rcCtsZ0I5WmtkUUFzNTFERmlm?=
 =?utf-8?B?ZHE3N1dHd3RqcWNBOUJQUUtNeXNRdmZvVkEwaVRQMmV6UnFHeHdRRkNjYUl4?=
 =?utf-8?B?SGFOOUF0ZGhlN25xTUE3d05EVlQ1RlV2SkRpSGliUFpYZHF3Kzl2WmVyOU4r?=
 =?utf-8?B?NUhPREZZSjFFWllZVXZqaVIwaTNIZTY1b0t0Si8zM0Q5NHcyVXBwVWxRQU0w?=
 =?utf-8?B?RUdtOFU3RUdKRXZ5aHcvSFZIdmlzcFphTm41bUhSZS8wNlRqYUYrSkVnSTU1?=
 =?utf-8?B?ZUZNU2dpaWVhN3pORDZBaWRJK0QwSTFiNzBFMlhzdDZZSDlDeUpNWEdDeUE4?=
 =?utf-8?B?SEdhcnhsVUt1MHB5NlFKL2FRdDN5eHdtTWhPTzYrOEl3MHJ3UEdSaUk1alNU?=
 =?utf-8?B?SlpRMmlsV3REVis3YWdpcGdMTnBjOHJTOTFNNmRWUHNlWENvUEFoL3FGQXhC?=
 =?utf-8?B?QkdOSEJOVHdQQ0RMcEFHZ0RyL2RWM0psdlpkQWtML2pMRkFDaWdHRG16S0w0?=
 =?utf-8?B?U0hqVVZyZzlYMVd5aFFxN2tMYUNKRzQ4dFhyNC93M1R4UCtlR0dJcTZzb2Rr?=
 =?utf-8?B?blRYcG8yb01Zb01xbURzSUZhS2tqZGw4MUp6Zy9CZDRMMXRXM1lTZ2U0M3Qy?=
 =?utf-8?B?OGtlbUhhS05QNzBhOFBZUXJqWWZzMVRZMEk1NDA3dFRrU3hNb0N5VFN6aG04?=
 =?utf-8?B?NDJ4VXZjWkN6Nm9SWXhHdjFMUDdROEdKQ0ZHbks5TG1hMzF4UzhUWlRZc0pa?=
 =?utf-8?B?Wm5Ia0hyQy9BNFVSRG5USDhGekg5L0JTYUh3V090c203MnZjQkFScTRYQ3k4?=
 =?utf-8?B?QnAvdUJqTFRnMTloNGt1SUwvUXh6S1h0N3ZFY29XR202NUhJY2VsUmZWOStF?=
 =?utf-8?B?TXB3V25EMDBLRURsMlBsWXJDSzZKZitUazJ6Rkp3VWJVTmFldFRreXlNMWZS?=
 =?utf-8?B?RXZhcC9ENWMzK2xuS254U2tVSk04K2kvZFVERWhBSGZKMVR0TmFIUDRoRU9U?=
 =?utf-8?B?Ny9STGVsbVJtcEt5cktCR2JWM01XU3BwODkzeEtaazRKS2o1RTlhZlJhcFZZ?=
 =?utf-8?B?eFBVcVNTeUFWSGtjWnpqWnZjQmwrTzVCajRRNngwUGYrU2dzdDhwRnRmNnVS?=
 =?utf-8?B?K1FkaDRmQ29zK01GRVhSaitSQVFJcXFKcDhtcG1yUW53SkRjRFN3VVFia2ta?=
 =?utf-8?B?ZEcyOVIrSFhvL0NNSTJGdzdyRmsxNHA5eWtIRXByTVQxZnViZ1EvL3RjbkN0?=
 =?utf-8?B?blNxa0NVNWpVcHN3bEh2NE8rWXMwVGliMUluM2wxckFMWGRId3R5MGxObnNT?=
 =?utf-8?B?b2pONlR2ZWZ1Zjl5Tk9WVFM2MUg3eXNIZFZPaDN0Q2xQR0hiWlkxK2RkV2Zo?=
 =?utf-8?B?MlUvWTFqYXd3OEhYS3ZkNU9YSGczbStXN3Z3RC9rc0ovc0lsbmlQV2k4ZGJ6?=
 =?utf-8?Q?3sOsompNZ565aj4OUUQskqPGkIocmHSMuBDn9RxFhB0Lv?=
X-MS-Exchange-AntiSpam-MessageData-1: C3Z4lpNaaaRUz41p1wnibSHpzhLnh8+8lOw=
X-Exchange-RoutingPolicyChecked:
	ARoFRHK8Af+Ycb5Ugognh3kmaM8YSydrqT5qSXoMwYaEKSVEJ2XvrHAajh1N5we0ssxy+1ZbnVPYeTIQ2jq7Vg1EjZBatA6AIliE+NGAYmFgRJuQgm9T29s1W1xns5Rgqx3lfn7ecAMNM2xVGSPepSsbK7ES7bk/ZJpO2goho2P8THW8FAhng7JbBPiuXI7tr7jtY8IROXhc2bZ7z9cAk7FojIpnuwHuJLFI+fc2iDnt8VU/mAzsN4vlus/XK5UeRCqx/G+znyukL7Wpj9P9w/4Y6sDM4sMoyOnbEpMFg9X5Xp3pBYLGDLLkmm8qyC0NJ6BBAhoGCxNKsTjMFfxHpg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6aed834-84eb-4d29-8235-08de8658bed0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 08:14:45.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SZbMfsgLtWB1ha+6LtHT0DaMS1mVV2e+/RfeU36dzc2Zpe5fV5BFc2HgbtZD4RAo2EqIi+e9E3EBp7LhNvR1TW48xMTJIkUcgeGVtMRgsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5828
X-Authority-Analysis: v=2.4 cv=CekFJbrl c=1 sm=1 tr=0 ts=69bd01fa cx=c_pps
 a=MMVmnpyRbxvAcRc6a9dgEg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=VbJ5aWF8PIlrz2hMgywA:9 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDA2MSBTYWx0ZWRfX2KDmxcNZ4WLb
 ECfB05B+n4vIgWRsAqIXX4BloYoieFpfxeQyqvDGbEeB+2lRV+8wGeIE+cOCWPdFtD9vIed/Vj2
 dmxH6eGFi2fCiooTiRLJG9SWlPXRBFoUpmWVnMnJQ+3SMswl5mLpEfMeb6Tr6PxIsKucheGAjO8
 AJa/RXlR9tbi69kzfoLE3dTXJRKpTFU3s9t55ZyF6DyrPakUSI0oCEP6EVIW1w5tRrDU1k77HLO
 jXSWejLCIyQ3FTmSXe73ac6i+qmFJXvLiGJcqyY0dupnN0zfGOSPo8FPEr3v7ei064IDCRzbKta
 4Cv9TwGZB4jZp/macNByUQYRmorS6JvyWz1iKfHrpTkaD22LqatjodNcCKpH5E9v3xOwPn1PkUL
 6zm4ZkMwJiND12zCA/QtvtP5MRSvNiRR/dUsEbvnf3/Cu15mO6y0ORGl7CcB5JA1nn5YgSakaxx
 lN/sgoLnrTWq1lgjBig==
X-Proofpoint-GUID: gXtJtj2q0MbTR9-gU3QjzJmCBAtbCut5
X-Proofpoint-ORIG-GUID: gXtJtj2q0MbTR9-gU3QjzJmCBAtbCut5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-20_01,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603200061

From: Ionut Nechita <ionut.nechita@windriver.com>

v5 (per Damien Le Moal's and James Bottomley's review of v4):
  - Expanded the kdoc comment on sas_dma_opt_sectors() to explain
    *why* opt == max means "no preference" and must return 0,
    including the IOMMU passthrough fallback path and the mkfs.xfs
    breakage it causes.
  - Added an inline comment at the opt == max check itself.
  - Added a guard for opt == 0 before rounddown_pow_of_two() to
    avoid undefined behavior (per Sashiko/James).
  - Trimmed Cc list to scsi-relevant recipients (per Damien).

v4 (per Damien Le Moal's review of v3):
  - Split the opt >= max check into a WARN_ONCE for the impossible
    opt > max case (driver bug) and a plain == check for the "no hint"
    case.
  - Used min_t(unsigned int, ...) for the return value to avoid any
    potential overflow when shifting size_t down to sectors.
  - Reformatted the call site as suggested.

v3 (per Christoph Hellwig's review of v2):
  - Extracted the opt_sectors logic into a dedicated sas_dma_opt_sectors()
    helper function, clearly split out from sas_host_setup().
  - Added rounddown_pow_of_two() on the DMA optimal mapping size so that
    the resulting opt_sectors is always a power of two, keeping filesystem
    geometry calculations clean.
  - Added #include <linux/log2.h> for rounddown_pow_of_two().

v2:
  - Dropped the dma_opt_mapping_size() change per Robin Murphy's feedback:
    the DMA core semantics are correct, the bug is in the caller.
  - Dropped the nvme-pci patch (no longer needed).
  - Single patch now fixes the actual bug in scsi_transport_sas.c.

v1 feedback summary:
  - Robin Murphy: dma_opt_mapping_size() semantics are correct; if no
    restriction exists, the largest efficient size IS the largest size.
    Fix the caller, not the common code.
  - John Garry: Asked for concrete max_sectors/opt_sectors values and
    questioned whether sd_revalidate_disk() would override opt_sectors
    via opt_xfer_blocks.
  - Damien Le Moal: Suggested min_not_zero() for nvme-pci (now moot).

Answer to John's question (from v2, still relevant):
  The SAS disks on this system do not report Optimal Transfer Length in
  VPD page B0, so sdkp->opt_xfer_blocks = 0.  sd_revalidate_disk() uses
  min_not_zero(0, opt_sectors) which returns opt_sectors, propagating
  the bogus value.  Observed values:

    shost->max_sectors      = 32767
    opt_sectors             = 32767  (capped at max_sectors)
    optimal_io_size         = 16773120  (visible in lsblk --topology)
    minimum_io_size         = 8192

  mkfs.xfs computes swidth=4095, sunit=2, fails because 4095 % 2 != 0.

Test environment:
  - Dell PowerEdge R750
  - SAS Controller: Broadcom/LSI mpt3sas (SAS3816, FW 33.15.00.00)
  - Disks: SAMSUNG MZILT800HBHQ0D3 (800GB SCSI SAS SSD)
  - Kernel: 6.12.0-1-amd64 with intel_iommu=off
  - IOMMU: Disabled (DMAR: IOMMU disabled), default domain: Passthrough

Based on linux-next (next-20260319).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/
Link: https://lore.kernel.org/all/20260318074314.17372-1-ionut.nechita@windriver.com/
Link: https://lore.kernel.org/all/20260318200532.51232-1-ionut.nechita@windriver.com/
Link: https://lore.kernel.org/lkml/20260319083954.21056-1-ionut.nechita@windriver.com/

Ionut Nechita (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 52 ++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)

--
2.53.0
