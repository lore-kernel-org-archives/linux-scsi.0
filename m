Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D682EA146;
	Mon, 20 Oct 2025 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956716; cv=fail; b=E+CMUm78+wvpoavcEyfI2sd7evWrwfw2zO5vLKNqJXwB8At+uugZ0Gx1ocWuykBODftzj91n7rjCOashSfbP82ySj6QHcTgLsLSA/lfEfL6NE5e9++QSR7fkrdtJ0qWjkrpnzpq3qN6zIOFLjFmdIbgdCWTLq5Lc8xi07jdeZUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956716; c=relaxed/simple;
	bh=qOn8dwWKDFiVzs94VJMfzIcDMjHmSj9OkATrA49Gq5M=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Hw6YT4cbxWtyanRBk13g8iKDp+5jQ92Evh/p26E408bu4Es8P+0l3Cpal8ktuoLDh2l2fFnLfCg3I5f5uSES8DKS1U0ozn8CXcvSjW5Volp1hv8f0pIKEY85WyX4lLPgAqlNgXb+rruoj0+WNOn4ucn3tfknsnxuu+ZQAuiQiX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BB0Vuil1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M5hg6OC9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BB0Vuil1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M5hg6OC9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SI6x001384;
	Mon, 20 Oct 2025 10:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=3vx1VKDG7hs3nHhE
	pDw8rBOvcwGmIvF1KtXTz3JGFjg=; b=BB0Vuil1f9FJkb5O6HzIatbRxJZT07fM
	mDjIEsxN1Jm7p/f1C96BP6w7dBZweebQqfvgRXS2Y6t4Jx8rrxVo2QhoM2S/eRnt
	GkFvNK1HK0hxC/Eq+GVbxrE2qOM0PEb5yVL7Y/mu01q3APnfws//DRZFICEQMS7i
	/DA1HytoDFpjEEzaLkOHCFPx05Njbu4+ypjtIlu3u2WL3jRpyv25xstnyvY65o8w
	YPYTh9txEr0HLFTI8v43dcjqFfS+x75a8N0Kexn7p1aL630UU5VxAq1s/5/SIcg5
	xCbRWN0uXHnKFBOITtB15VEXQLj9KDZgKT/JiU+enilL+m3OcVbvFg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3071yvf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59K7KU90024893;
	Mon, 20 Oct 2025 10:38:27 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1baj6b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xC87coCL5CsAhWJzVybANBJmUdKSldLnoc19pTUKTbDwHksl+1rhIPfPKmrGgXymb7jOuC/GpicPnqJEmJLha8SxDfMP1JhSMeIoy/kZf4O9f1nFcf7r/qICczUqs/ZiP7Hl+EtRk4tEvpfHstTWE+W4hiC5fiIpkx78W9MsUTmj5137wSPeRo+g2xpwpKbLGAQaesCEpny09JeD9Y05/D15SCTA37BFuYQj4zL72vwcdG+yX4ZbfL9jYtOJuOMdtDvgs5Fi7kImOMpjWs6Y27xak8xdtLYt4Z8oOHW8RcZsc5DxRnOFLPOd5ZB6btaZ562Ge03VhqZJmKoxwb/cnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vx1VKDG7hs3nHhEpDw8rBOvcwGmIvF1KtXTz3JGFjg=;
 b=woAJQxvUCI7k/Hf5YJkvTIaZBRiGJ9DAYYUCHtxHkyRdFjPkuSwA9WGeqt95H0HfCCQUN03KDMyEuCB46Fm7IJSxrstQX4ao0ToHA7khokA6n1I4YYwIwGYMObJKBhZ8MfT7Bmch0XtV422yGXSxex+adscGi/lX/sqwMpX7iwYNzhp0H4zSPnvr3oE3dpo1bnfNBY+grxzh7OXj/C1blkbtvkEIWYXquRANGtUQWll02xAQcoz24TuQAyMiHTOIcU3RAXyS1QoS4GFhdPTy2pa//vjSQo58rNlRZdleT+yW8S9rmcLr9QRZ9HnE+XSwf+DRCmOfYHWcFmFlkF3jGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vx1VKDG7hs3nHhEpDw8rBOvcwGmIvF1KtXTz3JGFjg=;
 b=M5hg6OC9E/J0lnb/eWIeTbfiRjnfEQJhpKXFQKA+dVKd/oszfqMT46lLvafFQNlJjmQ18JiuQ3n3bf3RVdJ+1BwwJ5uyPZIb0f4Vjg5MVn0Ve/MtW8MNXT9hdbL3kzPxor9X16sJnESQAR1TnmmMRUyvdB4xWqQPnQqx43MuE6c=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:25 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 0/7] scsi: target: Add WRITE_ATOMIC_16 support
Date: Mon, 20 Oct 2025 10:38:13 +0000
Message-ID: <20251020103820.2917593-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013315.namprd07.prod.outlook.com
 (2603:10b6:518:1::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cd623dd-24f9-44c7-463d-08de0fc4cb96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZkYUK4KSIz4FyZkXFmU+SaFKXx7ETi4wnbwbmocq2o8DsdF24TRydWhZuxDO?=
 =?us-ascii?Q?7nZ5634jgSb4Ksqei6LK++6YFFdnrb3W8ljNgHoKMnQSQ/sXLgBPRzDKiBRt?=
 =?us-ascii?Q?vk8zShUwAk1gPjilQIXSsVIlGpxyRpZBU/elFCVG2tSCLrHNfd9/naRQ/MSe?=
 =?us-ascii?Q?IEupWg/kZl41cvEcJfi86nIHSXQDRmSr1VwxwzCCgcMCcFVq3Ie+tw12oi4B?=
 =?us-ascii?Q?qJWLGbtcWf6EqncI20Y4c2gtDLPr4twuKYFAIsYpPba+svtc579G/l3I1kVd?=
 =?us-ascii?Q?dw56dr1THrLXxoO8UANpPp4rLOcbj7hgaGm4irdFsjP2VYcIEOtlvMTh8MY5?=
 =?us-ascii?Q?63dNlHgug7ujtIKnePoW2GlgNb3QWQq9/1RTj8w1jKyJV8T2pZ7Ir1JCWcNI?=
 =?us-ascii?Q?Iy0NnxRa7hhixAtfqY9z7xCL4X0Li05nplWJY9mBwks0vR+Veu01MGJnofh0?=
 =?us-ascii?Q?2OyoUg0NTwVFSt287DX2/iPam8UWRScBJS3OgDI3Y7ntngNNGGQll3jS9tMU?=
 =?us-ascii?Q?/47HiiciTBjapLp9xCyNlMHompQ+VU3aPM8UTqTRevVZIm+L/s9Rq0IWce9F?=
 =?us-ascii?Q?bNOU4AOSnCd4rnwQUBl+wn/w1N0qsr0d3y9SDtNbQ3W7r62WfWSjX3hS/537?=
 =?us-ascii?Q?l3H08BHSL8NPFcAx5j/GJt4iDTWsNBIp/ZX4aA/asCrIR2xMMR05+AvaHW6T?=
 =?us-ascii?Q?fuYBELZ1/Pg1iyPupGB5CWzjkZuhUj1GCtmNXYJq3YdbZ6d9RoV33k9kYa+G?=
 =?us-ascii?Q?IG+D79096ocOKeU1uDWZWdpo4mOMg0VK9qjGTL68Tz7KJ3ypS/xGcwVbvD4l?=
 =?us-ascii?Q?V3G7M11EWCcUkh9GFleR3S8RY7xUmriLMoGt8o/r2FuzUaB7iLfUdKRH3qZB?=
 =?us-ascii?Q?DhBNO9WlWo7du8KJnZjxZC3lJmgg8nQMNC3OoHL7TURml7Cd+g0ToBrpeJLE?=
 =?us-ascii?Q?JAMbo5T2pjWcloLzRG+VzhudRjzPM9Zt8tGVbc7fbtr+FCImy+nVCc1BRIdR?=
 =?us-ascii?Q?5rpSYM4HzUwBMAHJgQJFCWygBfDR79W2Y91Ghs/mPGsGkvuWTeh4MA0dfN7N?=
 =?us-ascii?Q?taRhG9kqErvb9LZukb4ybG5uJjrWlxqtv0x6rLv/8v6H7Cioo8wNnxMr12Xt?=
 =?us-ascii?Q?AGHEfhnVoTivTGE5+VO0IH71q4tqfSS48w5Tkj2R6R+cGwebP1UsfOMM32ht?=
 =?us-ascii?Q?owPCAh1pK7gS1EzWxP402pXY3kVekUGWUdj2+k51712pCrdUzT4qqulAlpnC?=
 =?us-ascii?Q?BTkC6yGG7VnLigLaR0OCfEE9r6T1byEPS0knC/uie6x3t3tnyoKRFU9DtAlO?=
 =?us-ascii?Q?TU8paWDPc5x+blO/RnT73StPD8dS1XIHs8XbvMYn5Pr5iFiMEjfK48nPPheI?=
 =?us-ascii?Q?38H4Km0tuJQtTVtqdI1LyNw+dQ46Sbn2aQYKRgqYp4SAlnBCi46JxPgNSrM2?=
 =?us-ascii?Q?+O9GxaTWWeg+3Kg7UmaxEAmfykogtfbX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wDMWlVW+l+E6tmJBSoGchNjqhRIfRDoKdYkkZDiGBPFNWn87USaF0DDkDtvL?=
 =?us-ascii?Q?3478d25Ny4fsfw9O01QZp1Bg1U910Svsj0Z1TADIFKBna2TkO9/N5XT+aCTm?=
 =?us-ascii?Q?O+886J7Twb3fHGgLCNsiecvsF55fPGYKc4BSffbV9bGF3Xwl8FHSHE696jM1?=
 =?us-ascii?Q?t5y+dhJK75sxxYYzU5uNW4o6HPvfpTTtJ0CB0iq0mAOi60yE0SW8rPq8wT17?=
 =?us-ascii?Q?BWjEpTuH9T850dTZcWIir7XSOgq8SE3ABnFHOZqv+MY1U6X7F3WOJBS19YQr?=
 =?us-ascii?Q?L7Yl6kZFtqRlDEvtbYbuZgpGxWSMnTxp2geTKs3PWc3DkEyRn/bwln6ySkfJ?=
 =?us-ascii?Q?ejmbl41mQUVzfMaN0nequJMn5ei2KMJakEj5Vv9+XFhmMneIgylBEWtovJjp?=
 =?us-ascii?Q?KjTMKOfmuA8wGi087mOBvk3HhIcWFnmcFADuUdyawp4W/byXFrq5oCtwBAZK?=
 =?us-ascii?Q?QqHSCXgMiYFIVG71e7EG5EfbDs49QI06aJJyPAflUjvnrNc1nh3A1syZgaGj?=
 =?us-ascii?Q?hjsAbZaVoDeOW3GCVq7xxhdtsaCNrLB2k7/p8Tk9ajdLs+EXWgu2q1wVqQTY?=
 =?us-ascii?Q?no9vV4r1x0AcT/iFgEnVBCwCHNCl2gUcoIMj5Npg99p3naeDRRWtZnu6jXyl?=
 =?us-ascii?Q?+Quzhsj+gT+cZv7mOoQ6SMrxnGrHVCfHa7rgQMXrAh6dEh4hRpmYs7WplVl8?=
 =?us-ascii?Q?PEo9Yl0LoNUfsCPWP68UOt/9e9riwzHfpacdb8zBbnsn7n/VYQpOTCNf71xa?=
 =?us-ascii?Q?y4TSXWsdf0TesQroSomUErd3DzpPcDlYOSr1oGkj7Zw59DVkDjxPlIbCh50r?=
 =?us-ascii?Q?SkTmUOhlG6eMUAdatOXNKV69HSr1j4FS9+lCEGXWIG/5+wT3pTulgE6sI23j?=
 =?us-ascii?Q?RmiBkpcDW9V5EDOCEpV8IDQ/b0bdua2Isx7JrXR0C14YnkDX85JDinvDWNiU?=
 =?us-ascii?Q?Ic31k2lz7Rv6eJHynAKTx4+Qnm/rc/2i02XVSQgSlz2+/SMtSlAQRQUVow7B?=
 =?us-ascii?Q?nvvPJ1ux4LbldafRHjE7t9lCqdE1dxqM+eHdFmgteXRPlPAIMcNJLQJPCVJD?=
 =?us-ascii?Q?504RqIyruMJiNOXjibcGgTzonQ5OkCjqmLH2f4v7gLylcZAh67ssK0YLWG88?=
 =?us-ascii?Q?23NJ+Dq5roI1J5PexzPmqC5z4igQ20kohZFb6s+GUSC6K7Rjg2GjrVFA/eIb?=
 =?us-ascii?Q?XWfQjHRUCgYLQ06oyxSie5jA2sI/m6KYoP55Nftv4+SeZr7oF9qvKuhNNnUb?=
 =?us-ascii?Q?EDZg2sjsPY2bqdMmyK2E428D3zWwfgopU8IeN6ogcc8OuSGqWUH9Bf8xauRv?=
 =?us-ascii?Q?Hj6jXXvatYArXyQCGK81RGqLuCTqQ+i0ioBh1xmVqYHI6w3UXU21qZGe+m/E?=
 =?us-ascii?Q?ZwVtj5CCzDQXbA6yJvchkkw9wiaI2gRgNk1aR0iW6VLqUjCmQrxR2SLwaMH5?=
 =?us-ascii?Q?Z4RkRBiUyKl1iP0uUv2TXOJdiz4qh7YWUNMLEceKhXUTolgTOk6EQvLusAiT?=
 =?us-ascii?Q?ckesN9bFLwTvap9vUw6AO/JNNYL/ZHTFvLX6wnQJzWryBr/nZ2PF5h+MV9Ai?=
 =?us-ascii?Q?80hzWX09YYAMJZs8NVYN6bol/9tGO4CxjrOr5qFQ6U0K8meGmRBz74IvRJM9?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hC2kqyUwnFWkqjctv94OskZ2caJ0d8wPTNEGlY/xG28TFhRtv4vY6eMQjlrk+VSAKqInqASVvfqk50r5PYq+g8T5SrR+WIucJIkUpesmNe6qcvb8y6pM3Ss8PiizPZObDnhRd79E2kjaOTzit4wB5m94nc49Xyp72jJQoeTsbn2yPNIokcZByJBV5dJSHV0xpQnCH4EQcWJcTfy0vhxkoQav/Fz6Oip0xYPLwnfADR8IKMBWJSE+G1jnmMg2w24IvG1ftVYQOo/p5/GNvMopLRYBABBKR3cxndx3XHtorsmciUBTBxc7Cfmsp5Kruw3HfWsXDPOKpWaME6CrTREI5mQlFcA7tb1pfLHzJipTW1PLXGUdPEZIqCIr9TpgAm72rzI0fmSXUL6CqwQ0ZGh4ShoWhHYgs8FCCV31ImO9b6qx/sv32tLJS/3xWUwzpIcxM8YwCRzubd6kewGPcCvvIaK90bJucBCKK49FC2l5huGeckL1CtLZI/3uYVSI+Zmn+rDjZcqPWLmQYWdF8K92/S6oaP7jdyEwfzPZNqBGCIJwHYLB8cFfsms80T5sZg6mHIAoCF+rTYC4w1o+J3kiNBgsIADmdogzRmg11Ot0Iik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd623dd-24f9-44c7-463d-08de0fc4cb96
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:24.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WO+cRqmlZWgDUZPNRqSwkqZUEbgv/J+Zo85Xj/MDLqE4td5jVnMeHvQ9CsNYngCar2Ed2GGLLsHqWyt6BCEkrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510200087
X-Proofpoint-ORIG-GUID: lxn5XYh6TF4RZJMVuT9qcugPYBQdFXu7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXz5yqrKtInVtf
 /MMCfa0vtdsKkD6VlHy1Iy22S5nji6l917B6c20CQ6S0ZcnFdaSOxJ1VKNb21E6HmU1DQm41S/S
 aRo30sw3eCL7DSt7YRsfOBikZCpM4rhRyCmgJvN5Um3fbbJ0w/eonnaRMZPU9pXyG1bWaAQeukA
 CQbIoy4H8MRYL8dAIj28HUknBT4JksBDl+tt1fQ4mRhODosa4r5AH0Fe7hEnWZ2pf2oK4YvO3dJ
 AdnwJCqYakfy4FouaRjeaPNftZzeuKCA4maCc+kZCBzg0a5Lu3TT2G1iYqOw4VKLdYwa79rX09N
 1J60ZZIZcn6M8WZw/CH8ONCosUeHdt4iIMoOOMzc++sbYfRRZomqsPzKvQU7bnrdpKJKBagYTk1
 1h/U35Q4VD9Zb/h0ZNlgoCgqsycpdg==
X-Proofpoint-GUID: lxn5XYh6TF4RZJMVuT9qcugPYBQdFXu7
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f61124 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Qo1nWHBUvXFxagpMxwIA:9

This is a reposting of Mike's atomic writes support for the SCSI target.

Again, we are now only supporting target_core_iblock. It's implemented
similar to UNMAP where we do not do any emulation and instead pass the
operation to the block layer.

Changes since v2:
- Fix 32b build error

Changes since v1:
- Don't make atomic alignment configurable
- Drop atomic_supported configfs entry
- reformatting
- fix lba size in sbc_check_atomic()
- fix return code from sbc_check_atomic()

Mike Christie (7):
  scsi: target: Rename target_configure_unmap_from_queue
  scsi: target: Add atomic se_device fields
  scsi: target: Add helper to setup atomic values from block_device
  scsi: target: Add WRITE_ATOMIC_16 handler
  scsi: target: Report atomic values in INQUIRY
  scsi: target: Add WRITE_ATOMIC_16 support to RSOC
  scsi: target: Add atomic support to target_core_iblock

 drivers/target/target_core_configfs.c | 15 ++++++++
 drivers/target/target_core_device.c   | 23 ++++++++++--
 drivers/target/target_core_file.c     |  4 +--
 drivers/target/target_core_iblock.c   |  9 +++--
 drivers/target/target_core_sbc.c      | 51 +++++++++++++++++++++++++++
 drivers/target/target_core_spc.c      | 49 +++++++++++++++++++++----
 include/target/target_core_backend.h  |  6 ++--
 include/target/target_core_base.h     |  6 ++++
 8 files changed, 148 insertions(+), 15 deletions(-)

-- 
2.43.5

