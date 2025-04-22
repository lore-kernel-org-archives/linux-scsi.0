Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742B3B19A;
	Tue, 22 Apr 2025 00:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745283319; cv=fail; b=jq6xhR3+Vl57sZF5YMZIPGU0XiIRLgfXMv+PvLYvnEiydB0f3Zg4gGR0SFvC5Gv61cQVGjSkjoRl5SY9upH/WBRU8JUxbJP83SM5yO3n1dqvCjMWC1hLBF73zQ6ZO1UtX1ZHEaRnC2aETtqz1Mg8Fif5hfxiFrUfD34nMoT+dEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745283319; c=relaxed/simple;
	bh=byofq48hOmmb9vgYPA3SE1JrKGB1Zl8Qw78yGrsmxqQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=o9JkF6Bl/fRl7T29Bx7ML6p9A9YdS2ZnEGFkyT25LHVsLTmYT95nKiuhBLNBUMKjGcoFOY9Z4r5JXJ3l1eFmQs+tYBDwjVRMGpuKaRsolEwOUregOl40LaanGLWEsLeU+69pt59oBtzQutk8t+M0boYszNeCi+92GTxwT5JkW0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b5YXU5sp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oa8VSRFH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b5YXU5sp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oa8VSRFH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0g7KG027681;
	Tue, 22 Apr 2025 00:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=U/t807brh9S0yrA0lb
	Uwgpr/2RQ/QwwqvbEkMVT04fY=; b=b5YXU5spDdZ/w95+hD3cSdOmAGSigTmxcW
	CIlKGdYy/xPjzzq75PWA5jV8hOB7uSS6o04azO9EhN3XbKHG14LRwdddIXlcU7/m
	htpniU7bcDJdhp/yYigAttLrxdaUHyY+zMemTaCUYHhwvZe1z++THYdpAHxWmy/E
	6ei4KkeqxYQvGOjY9I/aTz/sBaJZvDcnpSXmxff61ApaLn8SoOnwiPwH3C+wldFj
	9hSlGVocZZ35ijqPPBpVSD+4uc5RMJvYbJNvV4+d/fjQVfp0Rc7ZBjfUih4Ew36T
	23ehWJZCmDkM93aktLRLN6GoP3phXdbpkfJJOAaAyhWwZjsmi13g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4644csuftv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 00:55:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53LMZJrd021093;
	Tue, 22 Apr 2025 00:54:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46429f6syh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 00:54:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wc+ArqZDCyAfERSIrXy8cc4QubgRDnXLBtGXUOUqMO1IwsoLTzmwAeIrqKy29nxkY1PnF8l6xqeDgbmO34sf2BD4Z3CESOtJokCde4A5l4+dbfbCJEUbYRgZ+RjIFCkSGUMtOMuJTrb+2FmyBzeI3GNO/SYvrdbNMmgooNad7C8qVfookBejbaBIJ0Nvs2vjwWmpfDTQs92I8QuB2F6BcqJKfiX1HzFkkZoDevJfQkWufnH6ErJav+JCr1Z3r3z6e0oYm/BesIRCRgREaQxJ6hsuqLEbIm3ZsE2necM5lSxS/engMkapColHTwWA20yPxUExBm1lOXpZq3RsuTwUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/t807brh9S0yrA0lbUwgpr/2RQ/QwwqvbEkMVT04fY=;
 b=fbI7EDFMPl9vBrPPcSHHV9uEQl/C550rXHtazMpd4E+HvcF7/fCulHB5Uzi3K+p1MyFA4FvDTcaMrr3Zsa3+mHYo7WZ8oDXpM3zHFoL9reCNm9+bKDn7BiZ0ySbOG04wohPCt6zbjVySXiOzZUt8syVTUhlzlsBc3FtU1ZzZX970/K+7bDYhJp/3befoWKuTX7AQAGc+TAeZUQSUh5oZVbVRYcMCt/WQOvmCILu5bZYXJphPs3Gk3hIWcFiOatVaFb3PzAa0wcxV+o64ApNumH3M9ZVpneMUXSrFc2LXTlo5eQINvn3KRU5gzp9eGIuBu16x0TgXR3yhPw486+lvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/t807brh9S0yrA0lbUwgpr/2RQ/QwwqvbEkMVT04fY=;
 b=oa8VSRFHJCQgKVGzySnv4J3wP89xXYLjPje/y7bYUXyhTZd6JVAgSPbP76DFf8oFbLNRSiFH0bhqseyBnIKCaVadF2BKLFdDgGwp7QTo+O3vo6ie1VKjljqlRvi8zCCDOLA9EG7/Xh9IlX9dbchDZEMJbx4GKBt0dt/0hAN8Ceo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Tue, 22 Apr
 2025 00:54:52 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 00:54:51 +0000
To: WangYuli <wangyuli@uniontech.com>
Cc: akpm@linux-foundation.org, guanwentao@uniontech.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        niecheng1@uniontech.com, tglx@linutronix.de, zhanjun@uniontech.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        SCSI SUBSYSTEM
 <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] scsi: scsi_transport_fc: Rename del_timer in
 comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <084BD6AB1C4759DA+20250414042629.63019-3-wangyuli@uniontech.com>
	(wangyuli@uniontech.com's message of "Mon, 14 Apr 2025 12:26:27
	+0800")
Organization: Oracle Corporation
Message-ID: <yq17c3daud3.fsf@ca-mkp.ca.oracle.com>
References: <37A1CE32D2AEA134+20250414042251.61846-1-wangyuli@uniontech.com>
	<084BD6AB1C4759DA+20250414042629.63019-3-wangyuli@uniontech.com>
Date: Mon, 21 Apr 2025 20:54:49 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:408:fb::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB4568:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b072703-3684-484b-fb9a-08dd81384a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UTE1Hzc9iThnB3YOAdVygDn7NwKGogL5xnD2hPuMLG3UzDa4zrzc1n4y9F9E?=
 =?us-ascii?Q?rQEe7Lsz6pp5GY1lh/N0BkI7AMRtRq++rMLXkN0mgNLPPkow5L9atJ1L+mUu?=
 =?us-ascii?Q?lElD7lHlpVKkHq1gXnGDgUSskGXLqbjdTTNqvN88gtAq1JOVmdzeAG9pdzt1?=
 =?us-ascii?Q?tA0uDMUQrwRq+lkTeD+D17SSGi8XFWBt/ct9UNgZweOV1M2VgCPXYDAGCGOT?=
 =?us-ascii?Q?lq0yu3+H/so6kwbLtiJ4EUtloQKUAzQ6JIrmkz2V5pgKEjmHPF+eKxLjXTi2?=
 =?us-ascii?Q?JyRbj9jWYdkTFRavPq+QY6ZdSMigQ42OEkDhf74fYTMqXOPvM59ARIAex5PR?=
 =?us-ascii?Q?l9YbeJmyrHqI0dJs7TybYJNyoBQyplA4l4FzqeBL7XRUngmsNTYxT7kNiVdq?=
 =?us-ascii?Q?nTAW9FTx4yIDopYJoKzzIrlGxwpdnJw7t2/uQkQZF0MpJLvAmqdK0HpLryZx?=
 =?us-ascii?Q?K33pSuqcTB5CpSf1n7yuZsqRdXKiBGQWHhPx13RyICtc//tgUez0a4Deg2eg?=
 =?us-ascii?Q?IQ6e8LxXXaOhN1BepNXpTe0HCWfqeWnW06/zQkRo6OkvYv+K1ZyxiVkpPH1f?=
 =?us-ascii?Q?+iMy8Xh6CiPmlfCU1oMlg4rRbdJEd3wimxR3pYqgDV7sOnJVkhYvOSOCaNgJ?=
 =?us-ascii?Q?schhDQs7WiH8TDjqxG+y2IWVKxO+9IDEvCqKNTnYUviNx3ydcSILCjvaK2Gy?=
 =?us-ascii?Q?WKChntr9s3a3EexKTXEKcI6fkxIjL5cGPlOqxpeZbDQGZcQBWOg9idAH+g3T?=
 =?us-ascii?Q?+UZN4EUtZ7cj9NK5RvnXvD8XlQak92XqCpY+O5XDNssN17S826eOZCsm/n5Q?=
 =?us-ascii?Q?/lnR1lFf2y8rOd6G2cGk95zZB6ZhGQEYNDV4+21t0WpQ8h5hkkFdT93qnmwd?=
 =?us-ascii?Q?gi9xkqLqUItY0KGtHPzJYywLbrFn8FwpbwkanFRSZzESviKX/wOCJLruT0kz?=
 =?us-ascii?Q?grESy1vDfxqZNfQCMfBopRXuIyCuSosqJqi362q/FTBSwSie945Cz1812DNH?=
 =?us-ascii?Q?PoZJ3EqzFI51/NwQMXsRI5K4noWNnXkKvOC3tFmbsjtTHXn8gVx3B40F6Fpt?=
 =?us-ascii?Q?efxSaJYVzgWwUKQTL9jMtEvVY50MrPqQlFWQL85oUKltI8FdvuIBGtiiEbbJ?=
 =?us-ascii?Q?c0Mi3zQcU1xBVFlchJAxuUbKWLeHRj4pdDpRbd19anML/IyHqVtJwkIjkJok?=
 =?us-ascii?Q?9yq5U/o1vkIYfeQuwlVeXZ9z1SAfDQ0n9h3f9K+4NMqJGUEAao/12qscsVtT?=
 =?us-ascii?Q?mrjVS7UOstCVexbQq1JR4efoJtdzMi9j8VEBdZZY9D1SJE5Pq6dOm+poc1xF?=
 =?us-ascii?Q?N9crzxm12ZgnYvuRp6tTouDr0wpK41qxZxJkh+Mlq/zyGK1SD/U63si2zZil?=
 =?us-ascii?Q?YhMOrFAiOSJnqwmcg/4J7eD8kJoR1ZoVgQSSOvynJSImP8pGWg++FhkIlU8V?=
 =?us-ascii?Q?5zzblI7IoN4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2c01DVKFa9w9tiGyJV9CU8DoyKNsLTsaODjOHda3ZzmMrCaiMnNNtbr2dNOW?=
 =?us-ascii?Q?jxAsGGQWAbRDgFJVeuBo4232oyGHGbgboDK4WPEtPWsAxkuzvpoP/UxDlOya?=
 =?us-ascii?Q?rT7DG+3YLv0ARtCmxgNc3b1KpOMHUTY3x1XWNOysJBpuTWEHi1eyEGIATAO1?=
 =?us-ascii?Q?AU0VUNsqiVByoMR/e2vs0skJPquBNwQlAoCbNuN9m1ccRPQMUEi01Gms1jBu?=
 =?us-ascii?Q?S5uMyVl+yZaFdOIiLlqmAvcOL6pTcOdPPe/jWgStp7EwfSTzrWom9L/IvYNF?=
 =?us-ascii?Q?sg/n9zsjIo8FFXxfdyHtVhBLBdsafQT/isbimGO4LSxiNuQrBEuLNXzLn5mq?=
 =?us-ascii?Q?7fwmxG06hxYgUesxGpo/+AXDV0XQCDE1ZxDvl6U0yszlY9YYz/dpqiQulDkl?=
 =?us-ascii?Q?zR7CCO65g+PcbR5UgsyeaoBvAof3dn0KtnZ+oJxHjdsQsUmKqPlK77cbYfeM?=
 =?us-ascii?Q?IBDlw5lnbXtP4rWOMM7R3Q0PcNDJIXNe5+WB92Q0BfkPAZJ7Qaj1sv4KsOPZ?=
 =?us-ascii?Q?HyLKo4trLs3TXYckfg40Ss73EE1SxvdLUzW7tfYGPiH0lJf4BAvm1BCeSVB+?=
 =?us-ascii?Q?vc/xBzValOKtZkiiFRrD3GI5sdiwQBvLOu6M9BluYO3h59LfbX6sOw8+YZ9r?=
 =?us-ascii?Q?MO3XLukHiVfL+kuXVUgjvDDHifjG2tt6D9GW7tcainT2Cnr2L0pG8MhlgghB?=
 =?us-ascii?Q?vwo4CiCK5pe7TCzkywL9mjLTfb+S8cuVTF6eiDKnkn195sTkBN15U2ho/I7b?=
 =?us-ascii?Q?0l8GIF5QrNCKJDqOtRLw1CChftjvOdvplFqg7+sDNYmILWr3SPYuJLfHzHaF?=
 =?us-ascii?Q?5onkVpjBS/vj3UfJGADZskn4BEGP7HBLjenegbeTbUQF1o8DVBzcfNWxri0a?=
 =?us-ascii?Q?+R+ste3T1w1s/MWNxe8Sj+1YGroJZ9LKmvA9zeptB+AwrIS2rTjEwJAVBco9?=
 =?us-ascii?Q?p56z+q/M4ouBQsFmMrJPSviyF+tWtK9XppSXDuIpCT1AUvxAPP9oes3hjvZT?=
 =?us-ascii?Q?CamwPmvn5aJqdZw1CUjrg7+UNSVDVVnJM7wpdgmRM22e1tz4KoagNyHvIJF5?=
 =?us-ascii?Q?mAJihNqd7LloVsUntO5U41HOZK01dOt4X+uGc55i72WuLXGO6NjNOmenqdo7?=
 =?us-ascii?Q?3GjIcBPlWfZ4dGc2NMLJtqO7HshNjLwo52clQdinp3UU7bgS+jpeZnd2JHfW?=
 =?us-ascii?Q?+FLo/CL/cDR+t2nXkc69lVl+15QvDoFflqtLeTyl05GnaaaImTKtW/SmUii+?=
 =?us-ascii?Q?sksDg/90rxw+1OXgtZe0Jx9CvnA0msUWoUUdATVJrfEE0HkL8GlIByjclj3y?=
 =?us-ascii?Q?oa8N1QeKxKO74kNh8402m9TjFFricmOghW+H+GyJ/Vt9Sal27gCEz3+Q3HT9?=
 =?us-ascii?Q?z2h3TaeB8Iv5ph10gmTp4agbKVKCbMZZAwzxL6aOgehHDUO7FbMAA8fcrPqt?=
 =?us-ascii?Q?Zu5OOuDbFppcFT9JPIop54ENEcNnujDEyB31up4SupIFAK48qzunFCyZ/T1E?=
 =?us-ascii?Q?Ipc93umrsHAM5SULlCT7ll24ycgb+dNF1qBATeP3+M3M8633H2wTAJUvpP1J?=
 =?us-ascii?Q?MHIrzn0p6X4lwoai51UCDBbVwoDJoJKU/yE5WKkQopz2NFDKvhSh1YeLrBgb?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vMVQq2ZlUG0VYiyH8QcEL44nOhR71MBsfEJKnAnDvYp/LiugdFi8tGknTZowayUXKakKm8dNjbzFAGgze4xMEaJFYduEroeu3qxzNqL4CyHT4PoOPieLF11lMlx3YgbB0a3OYJ/IycgqBpuxfXh8sJAJqt7oSv1djRz+zINKKD5BWOLPjhuduPPxIVwFImzPYwhuwgsaRX9evRD/nVDtqri0OKYmtCpmLEFFKsI0tkdITqCM8bjvuaolkfXyEX2RUq17S0KoJpq2DUQEn4VX5g4MYbISkFTBZq6Gewp+608TooT5JUwD3quVoVfd0q0djNHn+wMOhBDnzsizs9fKYJpAEXsoGM6VW7A9mHIg7R6WWP4QC+40c52nyS38gsIprMsRQEHMai98m7FAswhpUcXWSofTLwt3SaRZ7/4HP2ILAJroX4aHzMwj4eiOc871itaPQ2csGYoCEBrxPbt/ppMS9+ZD2tTdGHxsHUSGm2FLsc2G58g3k3Fyht7tJDqS/lYRKr8q4dvG2eCsSLNREeWcjSlMkyqlF+x7zwEiO7o3nx8EXAbkryQ0OiFlBBB53L8QUdee7pzQaJW/4mpX1oJRPLDlJO4Fij62fMkGoy4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b072703-3684-484b-fb9a-08dd81384a0e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 00:54:51.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McWqQ8Kr8CAZG2MTYmVodng2GlSmJwinsj4Mw/JG5sraczfngzaZcvAK3+5zVZGeSmjSWV9t6w/srcwRtrdXa42y2iSvGTYQQN+/HFHXuO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_01,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=911 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504220004
X-Proofpoint-ORIG-GUID: tvtGn8ZwZ0p-4gAAvBLL3ObDyuf3KZD0
X-Proofpoint-GUID: tvtGn8ZwZ0p-4gAAvBLL3ObDyuf3KZD0


> Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
> switched del_timer to timer_delete, but did not modify the comment for
> fc_remote_port_rolechg(). Now fix it.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
