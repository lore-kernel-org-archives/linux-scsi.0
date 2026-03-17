Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7743BA22B;
	Tue, 17 Mar 2026 12:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749258; cv=fail; b=PWwJLgrn1rM8tslkhJWSVTsD9Gcfq9w6+mqId4lUfm0w/tX5FApW85ruCtJw0QrZmXlmoWjdo3H71Nh3f/l28+8VYbMhxynb6BAqfMLU9xElG0jhcKAewdRMtm1uarlD8zo86wr7hFAWd+Ttpo/G3DiBAdwbhBjDwlHcO6ylgaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749258; c=relaxed/simple;
	bh=7E45LziP9EkOewPvo+dqYmXA2975IVpAXfy9qT6LFD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b6v8av3XddU5t/FPR3QNnGRrDkLpWneaj5Z2t2OBjbQI85qrclEItbN4LycndKkv3I+7Z8aHe47BXJHE5qLFmCtsynyPfGRSwlWLCDjqcyllY+HVTAY++9fPUPAtwrLGzgPksn49pArINHFUY+YPdhVRYeCBujjfPAk1FW91q+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oGCYqmfa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hCeJCLwo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oGCYqmfa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hCeJCLwo"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GMfERV2838188;
	Tue, 17 Mar 2026 12:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jcyDmr7jNbSyEeEpe1qI25t7xl+2e6NWB8vDHnxWAd4=; b=
	oGCYqmfa7eqrAYaSZ29aVXWe+2wL+kfRXlnw7uvuRmmqUqws1Ka2cVIjF9M9dy56
	8Uuu2bGccqOojXlXaZlpCTbKNN0BoGefVgMalyceDOyxV9JXfIAAA0w+j2yaVCzy
	ingV5rvYBPKlKNt0Wuvelp7Mzb7MrPvVXvCMSJbBMyp765gEfCbMKvf+T9LWU2IS
	/o+OZDaI7Vbyp8XOzYCcF8toNSKNSWC2ZwWY127sV7JF/QnZRpZtWCH34012pq58
	DPJ/tYwRxjMnqzOs+mkfY0AX0l++m5yz56Y9Fik5l1V9VTaeVDhpBCb4EaTJLjmB
	HS0VOfxR9n1ukqHxNt+r1A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbuy62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HAYoke014043;
	Tue, 17 Mar 2026 12:07:28 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011039.outbound.protection.outlook.com [52.101.57.39])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx49yre1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCFctNqKPrIjsA0dbVxa4vp3ku5zdQ46dIDqNoZoDapZT9OvwmaDRGOvk7Wt1dXaag4DIqy2msVrmazhgBy8Y6SDIM29endzKvebdVdkkCm4AcGUm4qxjdpjt6sne49/KYOCQW3DWZMKDHLP5M1JKeyP1TthOwqdw6DaFgErtG3HJYrd/vD3OV/u/hdk+RQIezN3pTrC5dNc/C4zseahNQHTQ+30Rgo0v1+Op35Sr7874rMm1n2WC2hai89z61/KXVouCC9qeC85JdWf7xqg5zvlbjOFT1Wm3rURFaJe4XXCmTIETt4fvKa59K3XzwdTqrRU2BIq3aex2o5H0wz+Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcyDmr7jNbSyEeEpe1qI25t7xl+2e6NWB8vDHnxWAd4=;
 b=xRbYnsX+2YTqWuDOLbxNcQrrAELm9nKaQ//uP17H3kQlESHCvbg66oNEXrNG78pRdJEQpOKpooRjfusg2rsXQq97ysiZUhxk10xzUQ4SIRCCEWB8UuQAcYkYO0SaSc0/DTOR7yhWkKBmnxjgyQkM0j7Ydsp1KgcXWl1zXhg8kDP8/KCavNolNTRz0hoFFUUaMbDM4qzf8KS3RZjfwTQDM+wBYsLLXwu8vQ/MPY20+/gkdPo7WwDB0BrE++zxEKtN/V7CD1ZuczH5Fnlm7bi4Gc3+oKiaUv1oZ9gQ/3NZD8cQXcLNCWRw7DlTlTtZTVc9a1UfOlRq9GWDlUE0KU7bpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcyDmr7jNbSyEeEpe1qI25t7xl+2e6NWB8vDHnxWAd4=;
 b=hCeJCLwoIW1PkgOE3ZgDhkHAj8YCTaQJ8ZuvG07pPSnEIAloa3xvb2e29+lGl9FJ2v5/3h8gwka3j/FBF4UGcjF058Ku6H5zvlVNYtquJvgwEduB3+op7lX7veArZqojUviS+lV06iOeiPMupvHH7sCtlqT4DDLTQx9WZGwuKAg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7454.namprd10.prod.outlook.com
 (2603:10b6:8:163::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 12:07:26 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:26 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 05/13] scsi: alua: Add scsi_alua_tur()
Date: Tue, 17 Mar 2026 12:06:55 +0000
Message-ID: <20260317120703.3702387-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 549e0fff-4766-46c9-08b3-08de841dc0e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	sS8QgC3WRiDLLNmBsuWCY7A8wlLxcdOWEukbrlkilZPkBTwbyL0BnsZV9y4OLd+MHS9kVmmETj+/OYEdg3tFmlcOCf3GOPlnuqPuyXIrMEGKzdKVzmLRtm3ifMVyFbO+bFAd/bZisQcTjbQ4PjdzJqlUAHxzq7otVLzrz0lHtnazJWt9S3lhEvDd5uiuHXUdI8xiBuqqgkL7hddlZa5DcIfG+KzLP9hRn2zOCVSMjc2oGP3WINVj+MjcMJnCKMz+Id1z0u1P20M3QA3E9JV/ms0JKUriL3Nm9xHOicgwVVJ2p2brUAKLAdUuvfKx4vn7NA+hiDfFUMe0J6zXRbsyRLiixsgG5qNA5wrbZnqTQghwTb1gNaupqUqrndPBFnzCpvH6D/pt2PnxftmxIY8TwbjewhGLNXK5O6hZ6dJReGcwvQofDiRra+SlXtCXhh0pKvBJwsRgh63i7e1N199U7jJlp77XuZFDfcxNtAAAzj/UY9j0JBGnw5vyoh1xQDZ9s+YOiTWidGncjd8NRd/dUshXs7HujHlnI7z9GupPD8oS57FgYuwVKNvvqhC136IPuFnIynoirsnzWHXp5ipHetEa+wluDHfm4WtvkHysRwvDpQX4X7flbSVsJMpKab5sXtxB4vJrSxgR258Km+/9Lwb2XQDd62zxTvBXOa86d7OWynh1rb7B4sP7JJ3vUzfBHiO9Z+xmiyY/xhgHNRR9f+anyfLpmzCrZ/Ue5I3MwRU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OS+gSY7QpIO+j4S94bBxDfN/z6NZA9/7bcdLs1K6q9HE9ETp5uQgSOCYEQQC?=
 =?us-ascii?Q?ZcPtWEHs2SKQIr4rGoWON9cOZSfJRmDWQpHlMoq6qCl6ea3hPQrezWitUEaT?=
 =?us-ascii?Q?rago1Ud9GIkMi2J3eS2UcfMHmeMQIsmZUgV4mkevE1gWOjx7AKk8d1sEUfZK?=
 =?us-ascii?Q?ikUtls5lYgdGQa0j0Fj73XX/CWnoi5GeSuPTE203hlfwhC1aMu4vum9c/vlt?=
 =?us-ascii?Q?ZDRz9xaGCIqhKIVqxoBUZeKcnsUwvbATSK4ic3MpM2KMfV1SCKMpUaD3fKJ3?=
 =?us-ascii?Q?yFtby92u4eTDCy5RhnpZN0Usl6Z8r6yFHUJ823h59Uvmb6K3O+7DgvNth3aC?=
 =?us-ascii?Q?EXtttdnWzo6PlLJhFvA1MVwp+2MA1TCrKHypPYEsb0Z2Vf9x6wiTCivETutf?=
 =?us-ascii?Q?1gVgpT/2PimdksZoBFvFJwq8/dpQ20+IZPkuZi687KMDcLgKfkxg35EDnad3?=
 =?us-ascii?Q?S4o0V1OHBztIEj8PZqFcOVmub2gmejzMVfZehbV6xWsRLvEXZ7U/6JjwE3b8?=
 =?us-ascii?Q?Cm1uYLHCcVaQBGC+ugN2l64OJamyhHNeyHK/pxfKDCYwg0luSyj26FlqhB8B?=
 =?us-ascii?Q?YockS38yqEQ4ZSfJvMITp98FDGVg2WBqFLCECDZKSq/+z+z/RlvLjpf32pDQ?=
 =?us-ascii?Q?7J8V436I1VUocbK9zph79m3UKYb/Uqui5y4yNZ1cNc3ZpAqqCf8vD6VZhrcd?=
 =?us-ascii?Q?OnYDyE0NfsTFq72CIsvPMIpo6gZzwr7E/hMuMIa5Jj2siZsjEAkKIweCTupu?=
 =?us-ascii?Q?vdRj3AkfC3N9wIMIOH27+XrMhBgqUpTj1R+JVnHwfFYU1JGeA2us1ejVUlCx?=
 =?us-ascii?Q?xWdiviDZ7BJXA2u0kQ3u2FDa0r7EigwCSUgGT1hwIfRlyR9ohUQZq3r3EgCy?=
 =?us-ascii?Q?m34bHKndlbid72/d06eE9BVidTB2Z3sBzfqpvGj0yrpRlzvLiiuMkJZPxtee?=
 =?us-ascii?Q?sBoBZ7ELA4Ttr37g/kfRoB5+m6EVkwLHVGDMiWET7gJ6ts7GtGCx9k5PsvTI?=
 =?us-ascii?Q?ko5qMu0Oi0cgRfDBwYp2ePBIOTHLexrXsk61mRp0n32amWRgCGRM4OArrxFE?=
 =?us-ascii?Q?8a1zCCVlsm/7UjYTrpUwjVyQspvGGOGtOmOYyTh5I2nWZinZfWWnxU5FZ0c6?=
 =?us-ascii?Q?42te3zFmRh8qsX1nAWCyqIehLB5L1HaESOleVFQpno9zKht45DQvOZ7DlycM?=
 =?us-ascii?Q?EnCt1i9jKBsk90FGMMVh1IKeDjDzob0ZIf0aae/w76R0xITspQvK6gVgJXRc?=
 =?us-ascii?Q?IX521NqUiI+svzauVj2L4aTdZQD14UKYDifFksk8aMgLPe5ZBFM7T4SCsWT0?=
 =?us-ascii?Q?v+H410A6EJDxx4BYJ4pnxj1G+mphvrn7f78ER9jsTZ52EOh+xSEp1fmf1Fdw?=
 =?us-ascii?Q?g4vLnXWHjSEMxXlxUUzajtRw2UqX2OTZU15a+2Sqcyahs+hxN/zqK4zuLRli?=
 =?us-ascii?Q?XXcUF/KLUD/2joPxW3dk1HUcI67fX+AjSGxM6lNYqiK0Qktw+oYG4zTpVsOa?=
 =?us-ascii?Q?MrldEUTn5ttx8ResXt4L72faXlZRO9hRF9Ywj/W1NzCf8PEnxRi+JfIHjWMO?=
 =?us-ascii?Q?AYp9lVRoBwWVMdOCPup9S1fWqIuODHE1lRl8V6CNTDVK5Ksw70Jq4dM42q2t?=
 =?us-ascii?Q?GPa+PWL14lU6Vgn3eWiEZUxGXw7PIFMFUzhMrg27o+4yBw3Bbiy/9rYcZHff?=
 =?us-ascii?Q?HTG+5f7DVSxN4fIA2oLCmY4NROX/+k4zB/r4yztr7dXypQtIeIhwZ8IVtYK+?=
 =?us-ascii?Q?XkFHhDFcLR9q1hKPZHHg0w2XUtfIlhI=3D?=
X-Exchange-RoutingPolicyChecked:
	c+gofYBdQnk+bVGVjce9S2Vq0acTpJfBoaQusrFWhV1c5dw0aGIxKAoS3ihfHIwawSLlDxH0CQNplAsS9k/H1tOBw1WuIOylfercYZb1KrjckH8hneGQ64a8b2XQ47doc2NH3H1bX01CGVFAbIE52YtnO2OsvpH39NwXDXGK7Y6HQHmQXCKnOy/1ohtlj91cOr/3YW7XOFd5WqWr0lahhdNCfLKoaxB+HYy32S2EtgyMT4BcBmgO8AFxn+bubOTncZVN4ozd+o0l8EFseThry1pf/aENIeJ8t71STqYzhl5wUgyHc/slQ6bQbMZj0yFDoEHq/P8+6FSRe1rNeotJgQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DYPubBR4lXXkcWpBYaZFCud3g/PwAsLI1KgJcaKMAKxjE2CxlRTXqX7mUeMad+fwrP2KUcC7rKn4xiiN97WyyohArizGRqJeLTr32Yp0LXMwkQKjioidFmPeihiKNRy/m7Tm7/K8WuFvqzFxBlYKbLMDARTE9KXKMt2y5+FZfrhZJmAxRaGExcB8gybUXQou+30AzptrQAA6qhp+iEfKjVmeYQHetoQAHSNADvwLN2bl+B7Cb9T/+MumBBcmz4xbp57w7luBrcI5plADahFCE0DX+ZP9O8RNzPL+dl0Lq+UHsSVbfzUp8hq4kIL1YZW0cNIZy50kXmzK877IKuVyWsfF+rkYuD5dJHHdJTIf0H+113156JQ8z55+2Ezg3SCMGdRBIcQUBItEjQ7FutI7q/iL8LpoH1qVkI87GURYLGs4KEaBhziF0lSrlY9UpNBDpD9+UiG5KqiyWQ1NPM5oD0PGZlanWT0DBHcsPFTMEVz2w+152JCRNLGcqQciGR8YdxJeKUaULFjLYBBytGUz9VCh4VcIStv5QaUN6aNFKb5dbdhQ3yTQckCuQxwzNGMSPlaQxVMbYAfRqcXDQyWBO/oEmshwMIR5o85tsSFOu7U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549e0fff-4766-46c9-08b3-08de841dc0e5
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:25.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBKCa8jsah4l+avitzQfJ+ae3ljJG9LfgnaJOlaWmv1cctzU/+/H+relbxhwnIcECsnuQEmLOgSc0u0MmFyl0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603170107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX8vclRx+cRXoB
 V9IQH97C3xkfOtseA425T/GsF3sDHZzIbR2eCiaHyXbluVLXJZ/PLSPPlQeFhiZ1Q4u2yQ+QdIh
 JmzN06fD6v7QkM4DpJ8VxUy3yoOORSnqGJScFF8hR5nFpG58ihYc6bc65nErRJa8aI1+UR4Xkre
 mhXh+XxBDDd/mw8IZif7yd+asqsPSF6ABFeZQEjmqFB57IjCPIHCoOjirvMUn5xfAzv3AXaqVJh
 oHIFmyrPin6F4aq6QVK1Vl5gvOiRzmOrlmNlKuKQmHTJuCtUYngIT7heGtVLmzeBVOphe63TpzG
 AIdTZ3uGfXJrgWrgF4NFb9MJhGxiwdEEv749Vc43/DmnrX1se6JzpkZ+U4SNuxHfmWHA4B7i9tD
 lqZ9znRfQ8D2a2rdQchNaCFTgGz3jdv0eNrCvnke9NQ7YAQ9X1emQQ8QukAbNNPzNaEmDydAa4J
 Rda2atwUkoZUuxZ1GnA==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b94401 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=mXXEoj_3trUtFsI1lXEA:9
X-Proofpoint-GUID: y5LlJ6Ft7pXlmNU-yK8Vj8mUGOsCXtrU
X-Proofpoint-ORIG-GUID: y5LlJ6Ft7pXlmNU-yK8Vj8mUGOsCXtrU

Add same as alua_tur() from scsi_dh_alua.c

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_alua.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
index 1045885f74169..d8825ad7a1672 100644
--- a/drivers/scsi/scsi_alua.c
+++ b/drivers/scsi/scsi_alua.c
@@ -40,6 +40,32 @@ static struct workqueue_struct *kalua_wq;
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
 
+/*
+ * alua_tur - Send a TEST UNIT READY
+ * @sdev: device to which the TEST UNIT READY command should be send
+ *
+ * Send a TEST UNIT READY to @sdev to figure out the device state
+ * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
+ * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
+ */
+__maybe_unused
+static int scsi_alua_tur(struct scsi_device *sdev)
+{
+	struct scsi_sense_hdr sense_hdr;
+	int retval;
+
+	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
+				      ALUA_FAILOVER_RETRIES, &sense_hdr);
+	if ((sense_hdr.sense_key == NOT_READY ||
+	     sense_hdr.sense_key == UNIT_ATTENTION) &&
+	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+		return -EAGAIN;//SCSI_DH_RETRY;
+	else if (retval)
+		return -EIO;//SCSI_DH_IO;
+	else
+		return 0;//SCSI_DH_OK;
+}
+
 /*
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
-- 
2.43.5

