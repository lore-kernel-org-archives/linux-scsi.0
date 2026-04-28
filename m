Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77AA3FB044;
	Tue, 28 Apr 2026 11:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374798; cv=fail; b=nN+9b7hSNcW/ZqKHMb+8pPuCBwX1vUa6g55M5CjK/sx9wd6wDgbcwbPST55rCRYjRYmkKAAAamLli3mVBQqS7vlZg/P+04s/NCU3HPBtWxMMiBc0sJeQ7LVoLzZbA63ZXqoRQokn39WvjbdreIZHTXPbAr1uug+8TTbocxlf/LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374798; c=relaxed/simple;
	bh=Afyh97dA4Ml76f7Z6foTZEF5PK4538q3lH/POb2UdPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NK10wjE0Cj0ZEVptNJONRA7QekqotBv9KWGAwHTmfWQN1I7zpmxNnnd+EI1+gMLJvLnkkkkugxfbDv3tRIE2LZ+hHNei0iSPYt2kYRRo1p3SDlzeAHs2j+JbBJebtWNIWl2rsJ3qZnepCdzYrl8nZClytPSNwojCmpK9QuHcTI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L034I506; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mt84GTSb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L034I506";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mt84GTSb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAOwcb721101;
	Tue, 28 Apr 2026 11:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Yjo2CbkYEzSaTxbZjtDA5EJ96JtQ85mr7cha0pCXnDs=; b=
	L034I506e/V8CVhE3JY23MQbuUGezZP5omn9LRRStvU3z2+NpoKwbTWuk0YylLZe
	libupHMF6JYIJuxAXRH9uvdya88yvnfOk3P7vhN+C4P3C8m4SVSG2FShnbHIDy7y
	v4qCes0ZCPXrfxJ6Ai3B9z5a/SrD6bB0fcggDFm8YdC7if6dVvHiOdAR538KcLtR
	bFtMs1KTXJ9qARuqer6hGFnSj32JYYXFxQ4DEDiMPaM2GaODdmQ7VCJLf/G2MkMJ
	E2K1ROEtnelR0bjWXhJSEE8UJbKQhFhfMKR6J5k+hc/gKkYhkzB91rGpnTQnWnuC
	6ZV0Q8NmEOzFIeJ8iOPhhQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drp5syest-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2kNn040801;
	Tue, 28 Apr 2026 11:11:32 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cudth-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eni8RUMs/R+qrak3Ptel99i7ZSvbs4OotGNE9bYe9hRUsdQjCQk8f0Hxkv4mC4O/SSvM73A5i2uN2ajKNACMH8GxeZ4T99iv6u1169m17mm6usuRMzvGRioCokp2splLTZaLI3tqIV7XWU673mE+lgTrdj2NWRq3MUXVCMsKmAmrFrr9RNy/VI1pjNxtYhvx6RQFazcfXGXera2ty2Rink/MuBoVSu3oKMgdh6x8msvIqPY9kO4+zpTZ8FCft/AS3GJOGcAfpcKron8v6KaXCCpV6m9PaXqLNZ/Ehcef6F3+2vgS2+sTxVpCh2kZ08ArvMkYlb1n7WDKeCGdDiGb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yjo2CbkYEzSaTxbZjtDA5EJ96JtQ85mr7cha0pCXnDs=;
 b=e4opa1plgW+N5kiZeZtrr7AhhX9v9l6CUB03PbNg86GP9WrqfkXFfVpz9ALcp7unP5rutVsDGpoR/jsR54dcNhXggoGG9RhAEY6B0IIlP5Fd4kfME3RWLf+uHCyGE37MbqPrQacTqRuUppfT4rWgR/cvr1AnnB8uw4Xawv7gSUnLhZ/pPXMZVgW85M1zbMkb6I+EhD86i9ew2evYLjqREBJg/DLQZuWIUQcTVXOw0/HNHcP3crayYQy+/BCSnWx1frDqr5OteC9AcUBx8Mu6gTwQM2S73r8F6YOlU9Ru16xtfR1ekN30RCeCtu055KC2Tuzi9YaBR1XUkxfMbE9CCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yjo2CbkYEzSaTxbZjtDA5EJ96JtQ85mr7cha0pCXnDs=;
 b=Mt84GTSb0EZgdnlw9Ezg7ZU0g2jExcqvgkO0xD8D+uzAalrJ7CE15MzSlT+sXA25WWK/9NTeQ36comEJtEHQEblC1s0bEdd2ly2ed5IoxAztw+uk3K5qxi1tFiazGCifO0QZkrV1x9evuBxoNCVZhMfslEgOoePSgJlGr3T+zrc=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:27 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 06/13] libmultipath: Add cdev support
Date: Tue, 28 Apr 2026 11:10:58 +0000
Message-ID: <20260428111105.1778008-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF000132E5.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:518:1::25) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 30194107-03e7-42c4-6fbb-08dea516e48c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fWV9f+e2Y+ZdOWenVc1BOfS+sNQ5SOoYFyUwbNpuL2mNVTwalmoBNjqin5CGnhzKhkptUAgqeTMY/XIGoAunNmsQSHI+VK05K0SgqBK3PuMNKd2g5A23Nz05jxq2iA+XxdGY9Sgyut4dGhhUmGN9sJoNonCMUMjl1SY2NugxSWNCPioaUVPdmwNkluwc4tibrPGqG7V1Brh95V4JM16anmjhXcYJUbdE3INVMn7H5+DTC5Z0T0pFWFkR3x51uEiSuH0rAH8xx7k0jmhHR2Jm6uBMpPkvRMgTqd9WpbyHsGpJVE9gmyRO4cdTas6CWQioPSm1n0W2EsOrMhf7vKB/qNT5ti4OzjkFk5iZ1EJplfNRlhoBLDdhIFq39QRJ+PoXbufdfg0Gl7yMkn6apYYfmlj4Uck3MVUO/3V6Zg0GS4+jq8jDCd85+HiNHBifZSVwM1lq0geFNLCLrrooTSjEYIpo9Juf9LgZETk7qGyJq+2V0NZDqFhd4GOAot/BTfzUu+obF5Vp3oNz37mCLaLXwIkxGhJIyzBU3NMFxJqelfET+ekLrbuBCs5Fk5fOPsQuaodsw1ExC/TT5V6v2rzx9NLDtNNfaSEqW0OxRqlrOgoozA1pCQ0J2LLM1zWx1iyAqKpQ9WpNeupNWUpJp2/AKiWwhDx0Goq9YBGVBp/RVrpN3zHcJMXJZ50cgK5XO29qdjjGwQIeOZy0tL3b9lhdOgLuu+RvPh+OQESLfsXwBp8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1uJeUBPu73PgjAZDfBZzaWLMui62GUFKCb9rNJLed5GY9RGjSmsDhbnNPT2L?=
 =?us-ascii?Q?n0/oOdS9fUyL2zeuob0fchmchqV6MAnb3gqV/ovEt3WOEEyhVMciHuN5DaUX?=
 =?us-ascii?Q?vAUKgHC3nwP5eef1VTGNVaG+jgV+SdTV+g823FZ7Jj8/E+5I4xyRiXzApK6E?=
 =?us-ascii?Q?Mn1utIdKAxRQS+0kdaO3stNhj9/ANfB+B9E8zlRUozqQIAmH3iu9BSzdJzPG?=
 =?us-ascii?Q?nz+N3d3AI510SzAFnt4+a8JRdeU51n89NoTm5/m2DdKKCKzQJ0NYeTKzHVO1?=
 =?us-ascii?Q?+553WOkR1pWRX+x1FUdbBlIJTo/TzkqX9wUafJ6+F2QveiHnkydIPIld1IzA?=
 =?us-ascii?Q?646nKpc7xc+FGc++DRw4u/Vwvt11pFGd5Vop2But53MIVL9MXLsgoG6bSlR5?=
 =?us-ascii?Q?5AxIIBoFlUrCLDhUdWtDieraF3Cl3eoDDnfWbp9ltb6r8HvQvp4LA5pSCRNa?=
 =?us-ascii?Q?1TS829DIorwYtpEK3nH5AcCKmLuLkOOMwPS7rbgVwvu824ufPsMuHmkfkSq/?=
 =?us-ascii?Q?tNKiOGjP5mzDPuUjEMaZlkdDazaU12Qpy9uBodTxwaKhuKaJnE+sspBf0oJx?=
 =?us-ascii?Q?nGts7ulCTtoisxBczDNONUb0pVKjOuOjcYa+u82sg7x9KggoX2kFwJu2cVoM?=
 =?us-ascii?Q?QtF1Nf3ceKnnfEe5YdlqNma+bOvlktE+dNjskYfyV9zehSUUenQaabYGo7Eu?=
 =?us-ascii?Q?z/g+o4RwaLTlbnCdIa8Rewp4Y5E2fhy8n/1AsE6nH+3YhiMQLZmrKndFY6pT?=
 =?us-ascii?Q?jQ82l7ceHJskVgo0wroGXsDK1M7SCVzBID3E1Xd4UX+bP+8oC6GptgBbGjIC?=
 =?us-ascii?Q?TfsfTwlfGIKXMiXFv2vYGGtmLCW1Bk+J+lgars0g252B/7J1FqlgXiTQIyVL?=
 =?us-ascii?Q?0xG7KdHA7B3ayOheu3mzaYB0xTm2tuM1hyFt8u+0Vt2ZnmKoRuNSXE9Kl6QT?=
 =?us-ascii?Q?uVMYvuvbaZAQVkyYuauK75ctMXsDsw1V+TeGXK2FZEIfTUJHX6vFrVhDOeN6?=
 =?us-ascii?Q?LId9KGTtGs5ZXlG/2nQtDvP9gxEsfBXeQdR6Zo0BTgV8zOdZCfBWm25c0BeS?=
 =?us-ascii?Q?htEohuSu0ALRMxJU1bL3j68ujaYjeSg2+yGAXoMNWz/Mvjs8iRfYRHxB+3N7?=
 =?us-ascii?Q?FFPN0j/wdtL/LDkEDpXLNJdg0K4dQEL2r7HKVIeO4XizZH1KDZR7lR+hi10N?=
 =?us-ascii?Q?8+0+rLR8LIrJ3xZ3oWU9zcSH94VCQYHjCfEARpQ5yLbeIUZNHNOt2Ek2Qi8r?=
 =?us-ascii?Q?hWNH/puIVuypUvDdQDYYP/Cv6wIsxWhB9mtkZklpFgPKF7f3+EKh8zJ07aek?=
 =?us-ascii?Q?Y2Gr9OYhRD3qS5ptzPGKadLpiFaC9fIRutxr0FoOA7irRQiQbXZBTV00316n?=
 =?us-ascii?Q?k2+xWigOpPin4ZI3V7w0fpwF0li+ZC8FSHOE4AQZb1WWhnSPeRe99AwwPGRS?=
 =?us-ascii?Q?DmGlschWl4gsY698JI1Egca63lyq7AIkAzOJXuEw0BbSgrVYqXDdeyR/5la8?=
 =?us-ascii?Q?nVBGn+17GvxHEN6bpwn4cFeshshSij6x6NBKbLTqb8HUmVRc3F9inySWRyXB?=
 =?us-ascii?Q?VgXKTcaVl1qdl/pbqB7el56/iBSwWvjH1hTtxUxIBqVtq7RjIXE6NVmikxsz?=
 =?us-ascii?Q?QJByjA6AhcThGipLukoDLbHnfh4ZUDaIpLnnfPjjylNQjJZqkuvuS8d9Qjcv?=
 =?us-ascii?Q?B6PAFsAfhgd5B2QqG6g0tStcdmLkjqEg97nrv6xYdWsAq49HWvVttsZ8ISJr?=
 =?us-ascii?Q?917JBWF5Ab0pf2EG57t03CgsSkhLBxs=3D?=
X-Exchange-RoutingPolicyChecked:
	jgMd8zU/vBQx/84Ia/fdKRkLoTpbhEavuZzLi11+so5w8yHy3FwPqYqJOg3B+XTrMBrs7i1qeGJTKd+uzF+8xnyyG3xVDH3dbgTemGKUQGupVrZDcoAgIppmR7ukf+JfODfBaFRoMTtBiToHCv4240xQfLi2pMUn34wxCfjDdie4MCWxclmRzFCa3fYPSU83t97/mwa34JQRUD5Xuvt1SDioCe42vMPygyAxyJUhhZ0NunGchu9DD2fTI3RZSTzOlPl1SZOlY9BmkBwu+TGVRrdOKNC3tffBY5ny30XkmzLA8bDjhhGq5C7a48/pn5qtMF5qT26M0dg35ZE424+lSQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wVrqXhqnmqjhDiqGL/qp7XzloIG1w8cMGG/fM5W2ae/kMZe8qmJCulE2V8PofNWaxrCgmcSl1gs8TcxJuUPm12f1Vup3OdFcAPO9GBbg2TQ/1UyVBPYaVSKUGbksNaAu/O8cTa84O7CGo52K1Pw6yRnyKS+DTSvMT9xNR+H9Dpm/IU4LhvgGfx+rHMApRweyIZBBbnqe+0DelMkLZUQAQoMyOPZIIbHmxDA6LTrGW6Z2Kw2nJDGyOktsumVNbEgEIvsoOxy+q3u04sOzRqksHM4iIUt0D+2RhlawO/XrpVXMDJC7xUQ0W/oH2FV9ZTzPQI+lFnYqBzl0zkCO0XBfzVbQf182R0zgEormjw6ARJ6xJdIwQk250Qenxk1oBk3Y9LMW+rYDPMrJnaM8B6RAJ5TsWnGVAFdQ2ih8zcgNiK9uJxcE1b9wR6yPhmLjfYuLYb9QMBGAvsNv26fTADg2Ci5kGg+/15buEzFBSCjaubporAvXRkHq3V+/GiD6cZPgHDGIve08fi+9Uz5sIq+HNzHH/YNaznjje9+Kq1jZ2lWZnbV/DBMwERnE8U3aaFhLntM5J+X8ih58g9DQxcesbLHsTOfE6bRBT3S1DdGF9RI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30194107-03e7-42c4-6fbb-08dea516e48c
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:27.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z2q0LLYCx/+YaGxVVYfWYFqCoA5AIcK8u7TvhANP4CnKG2Jd1RmIMJtyeGgFPTc3gCyUaVjqKTqXjHrad2GzBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX6Nw+Hv2lUd/p
 axmGPAQ1yQuHNu0Aj9vL3Wcv16JRX2A0M88e1++YJFJBSN2lvnVl49TGDGc8xs06InWqRmGP7FV
 MQCPFWjTI3sB/pjtMQ8Ql9WUvycuToobgQ83tryii7IA/MhXs587Nh3DE6QCqDMzqay8JNwu4Hj
 /uS9ZCBpxUrcqH0DpvXpTFYbRAs+Hd95ELpeE+5MD/Y26nWSNsISuPNlDoLJSMyIk4BIlHOzJnK
 KfH+gUW+5qmDvjMzv/TNEysJQ2FR3yIXeHraABzZh0qZ6UjvaLys/EF6B2GTD88BxL6eDVTeneM
 yimZ+KCYkvpE5X68ONodDXPub0kPJLSQzFHGmsmFZnp+1HDniwdRrULhGR7VThWyKdJHBm9itHd
 mxS+hVs/Hw7ljbb4LxtcMMyxKtiigwjAjKTiO6aomBw1vBR7pqlZOSxagjF0RsuPX9cDfLraygF
 dKEw8wIImKFOXhe/a0w==
X-Proofpoint-ORIG-GUID: BtthFeEj0aWh1FKu4_GO_6PGL8SLxWe2
X-Proofpoint-GUID: BtthFeEj0aWh1FKu4_GO_6PGL8SLxWe2
X-Authority-Analysis: v=2.4 cv=E7v9Y6dl c=1 sm=1 tr=0 ts=69f095e4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=NMmg5B4swMUXEhaZ7owA:9

Add support to create a cdev multipath device. The functionality is much
the same as NVMe, where the cdev is created when a mpath device is set
live.

The driver must provide a mpath_head_template.cdev_ioctl callback to
actually handle the ioctl.

Structure mpath_generic_chr_fops would be used for setting the cdev fops in
the mpath_head_template.add_cdev callback.

NVMe cdev iotcl handler has special handling for NVMe controller commands.
In this case, the SRCU read lock is dropped before executing the ioctl.
For reference, see nvme_ns_head_ctrl_ioctl(). This makes having the SRCU
lock when calling not always possible. To handle this scenario, add template
callbacks .ioctl_begin and .ioctl_finish to be called around the before and
after the ioctl callback - if the .ioctl_begin returns data then we know
to drop the SRCU lock before calling the ioctl callback, and then later
call .ioctl_finish callback with that same data. For NVMe using
libmultipath, we would take a reference to the controller structure and
pass a pointer to the controller structure back in .ioctl_begin callback
and use that same data in the .ioctl_finish callback to put the reference
to the controller.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  18 ++++++
 lib/multipath.c           | 129 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 72186ab220083..3ac77c089a58c 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -4,8 +4,11 @@
 
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/cdev.h>
 #include <linux/srcu.h>
+#include <linux/io_uring/cmd.h>
 
+extern const struct file_operations mpath_chr_fops;
 extern const struct block_device_operations mpath_ops;
 
 enum mpath_iopolicy_e {
@@ -37,12 +40,24 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	int (*add_cdev)(struct mpath_head *);
+	void (*del_cdev)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	int (*get_nr_active)(struct mpath_device *);
+	long (*cdev_ioctl)(struct mpath_device *, unsigned int cmd,
+				unsigned long arg, bool open_for_write);
+	int (*chr_uring_cmd)(struct mpath_device *,
+				struct io_uring_cmd *ioucmd,
+				unsigned int issue_flags);
+	int (*chr_uring_cmd_iopoll)(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags);
 	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
 	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
+	void (*ioctl_begin)(struct mpath_device *, unsigned int cmd, void **);
+	void (*ioctl_finish)(void *opaque);
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
@@ -58,6 +73,9 @@ struct mpath_head {
 	spinlock_t		requeue_lock;
 	struct work_struct	requeue_work; /* work struct for requeue */
 
+	struct cdev		cdev;
+	struct device		cdev_device;
+
 	void			*drvdata;
 	unsigned long		flags;
 	struct gendisk		*disk;
diff --git a/lib/multipath.c b/lib/multipath.c
index 1232e057199ae..69e48ca3169c2 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -462,6 +462,122 @@ const struct block_device_operations mpath_ops = {
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
+static int mpath_chr_open(struct inode *inode, struct file *file)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	return mpath_get_head(mpath_head);
+}
+
+static int mpath_chr_release(struct inode *inode, struct file *file)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	mpath_put_head(mpath_head);
+	return 0;
+}
+
+static long mpath_chr_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	struct cdev *cdev = file_inode(file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err = -EWOULDBLOCK;
+	void *unlocked_ioctl_data = NULL;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device)
+		goto out_unlock;
+	if (mpath_head->mpdt->ioctl_begin)
+		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
+					&unlocked_ioctl_data);
+	if (unlocked_ioctl_data)
+		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	err = mpath_head->mpdt->cdev_ioctl(mpath_device, cmd, arg,
+					file->f_mode & FMODE_WRITE);
+	if (unlocked_ioctl_data) {
+		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
+		return err;
+	}
+
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
+static int mpath_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+		unsigned int issue_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+	struct mpath_device *mpath_device;
+	/* error code copied from nvme_ns_head_chr_uring_cmd */
+	int srcu_idx, ret = -EINVAL;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (!mpath_device)
+		goto out_unlock;
+
+	if (!mpath_head->mpdt->chr_uring_cmd) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	ret = mpath_head->mpdt->chr_uring_cmd(mpath_device, ioucmd,
+			issue_flags);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return ret;
+}
+
+static int mpath_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd,
+				 struct io_comp_batch *iob,
+				 unsigned int poll_flags)
+{
+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+	struct mpath_head *mpath_head =
+			container_of(cdev, struct mpath_head, cdev);
+
+	if (!mpath_head->mpdt->chr_uring_cmd_iopoll)
+		return -EOPNOTSUPP;
+
+	return mpath_head->mpdt->chr_uring_cmd_iopoll(ioucmd, iob, poll_flags);
+}
+
+const struct file_operations mpath_chr_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mpath_chr_open,
+	.release	= mpath_chr_release,
+	.unlocked_ioctl	= mpath_chr_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
+	.uring_cmd	= mpath_chr_uring_cmd,
+	.uring_cmd_iopoll = mpath_chr_uring_cmd_iopoll,
+};
+EXPORT_SYMBOL_GPL(mpath_chr_fops);
+
+static int mpath_head_add_cdev(struct mpath_head *mpath_head)
+{
+	if (mpath_head->mpdt->add_cdev)
+		return mpath_head->mpdt->add_cdev(mpath_head);
+	return 0;
+}
+
+static void mpath_head_del_cdev(struct mpath_head *mpath_head)
+{
+	if (mpath_head->mpdt->del_cdev)
+		mpath_head->mpdt->del_cdev(mpath_head);
+}
+
 static void multipath_partition_scan_work(struct work_struct *work)
 {
 	struct mpath_head *mpath_head =
@@ -504,6 +620,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
 		 */
 		mpath_schedule_requeue_work(mpath_head);
 
+		mpath_head_del_cdev(mpath_head);
 		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
@@ -526,6 +643,16 @@ EXPORT_SYMBOL_GPL(mpath_put_disk);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node)
 {
+	/* Do limited sanity checks on template */
+	if (!mpath_head->mpdt->ioctl_begin ^ !mpath_head->mpdt->ioctl_finish)
+		return -EINVAL;
+
+	if (!mpath_head->mpdt->add_cdev ^ !mpath_head->mpdt->del_cdev)
+		return -EINVAL;
+
+	if (!mpath_head->mpdt->add_cdev ^ !mpath_head->mpdt->cdev_ioctl)
+		return -EINVAL;
+
 	mpath_head->disk = blk_alloc_disk(lim, numa_node);
 	if (IS_ERR(mpath_head->disk))
 		return PTR_ERR(mpath_head->disk);
@@ -555,6 +682,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
 			return;
 		}
+
+		mpath_head_add_cdev(mpath_head);
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
-- 
2.43.5

