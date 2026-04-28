Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D3442316F;
	Tue, 28 Apr 2026 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374971; cv=fail; b=pZtlAkPFtpZ21O7wRJdN5m3GrAY5P95uel3l7DS1RpocSGWUo2JJmxq61+XN53U5qRvmtPce8ANfYwax9HWpk6eMthIQVk5Pk6ox+TJXBcFslE72qP9uRUzayvqKQoU7tI4P/TsE4xA0X4/vJCc4+Nj84WjQpUYwUNka0rXGchM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374971; c=relaxed/simple;
	bh=vDDurl6T+kvAe7q/+utx1w78kjBjoQDO5uBgNrxwr/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TLD9Vk6C7RKqnEXtrvm0KLyk9t37WujVweflF87UE8LyK4HLusrNpVSW6Lx/jAD6CrcwTryFPIRyjfUBoTxlcnDIDmbKQRb2jlTZGVXooG5eTFpamZeggs4UTPzxu8SFD9KFvBOfAbj7XPqrASCC2MgnglFTSXOdVBp3GvtCulQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K7RrTgSE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fQ18h4xP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K7RrTgSE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fQ18h4xP"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAOwfL721101;
	Tue, 28 Apr 2026 11:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rS91hQnNHTH11S4ULuutR46ARKeCcQt/kbtYJhGBqn4=; b=
	K7RrTgSEcCCnz5bIjPPTeDHklQWhFUf0qi7CV68ZsKuWzfsArOGRvanwbzLjq1Fi
	YI22Gi/dqCMmVj4nAdpzu+cGhljnmpU2S3p34L75MPVapRWnA8iwZB82elDWplXJ
	BhAo1hpUY9jgGc1Dv2HhaBJv7YRNo4obNXd1+43AgedguN6c8m4gkkZ/vteYdl3V
	AOjcb9jjhjuEoBwdfLqoN/cbDByOt/ZWvyQVJwbVJuh3/b4j7nBwry7pDasUMxC7
	ixI+h75Q4zFpHbWRy/KeBOLWuOf9Fj2Ote3QbHaBEUM94R0JBvJzdy1qQuzvdYd3
	bXw9oia3jlE8pbXF65VStA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drp5syfq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVc038802;
	Tue, 28 Apr 2026 11:15:40 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s7VR2/yZaGM6HbD/mFl3+DLoTQ3t5iSAjKHz70nq4tY+BIt3mhHg1fkb+SGn7vI1NJ/yBgDa50/eySHw0V05QqFaAK/QIRywE1muuY8mOiPzbCNwcToMCPATk1YT2Sizl/npqAC+WO16x218pH1MG9NE0fGVUajyTzOYZtqwRI80GcXbLHEjhpoOYC1cQ81IDGnvmKnT2pfb4RQGnaFAio+pklgZ3AoFtecjBoPVpLuJRVi+ZfOuf4a8SDZAY/4zE+i4xd19W8KFRQ5BMdr8q+ooEp2q7tOtjD2/LZTfaQzRgcNno75NKkxWNNp6O70lZDJQuL+Mnw1Qets/mPUlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS91hQnNHTH11S4ULuutR46ARKeCcQt/kbtYJhGBqn4=;
 b=WPoPw1mLdTy2bFRSMc1+GT//H1Ms/RInUWAinrVu076R9yPuscCOB96OLBL4eZ0NJVU8uIjKJ7xhGu9CMQaYUpjTFXpIKPNEaRK38z7+z42Vzd9Am0uIxnn+zYHAtsjGdH0aIxoLo6bhMZuq88HTLPaiyHjSaxJp4fm4gJVgaAAEqhJelLMOvVlNNxyOAZGnSBnb0KKXhzHV/CpU+spZ0o5+nqkXL3ir1FbbpNxEHQYlXKxFnm5BhzUkNZWhyjP+2LDwENhI4Pn9HN9wqOCFUt53xNHlaKBZAHkOZWsaq1j1VmI6ABakDbiDJvAsEyvWEp7/3zzGmvw+rCweTGklWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS91hQnNHTH11S4ULuutR46ARKeCcQt/kbtYJhGBqn4=;
 b=fQ18h4xP9WOLA3N4UBgYTaXAPD0y+BLBWnyIYtCOget0L0OTTUh+1RslwgQYiQGaz0YSmvfWQKLSnkH7t20OTz+ZZh9Pln+54J/MvWpEUygW7ZMkqGNCZB308PCFPcclXqaZirpLoZ07ksrBlhCRKcAZvWSiDhFt0RT7R51myg4=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:27 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:27 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 13/18] scsi: sd: add multipath disk class
Date: Tue, 28 Apr 2026 11:14:42 +0000
Message-ID: <20260428111447.1779062-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:610:58::40) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: ba238620-51b3-45a5-711e-08dea51773a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Jt3MMQ1nDntRIq5ETdVCgMctzqk7alt24+ttnv2HEPFJC47opLiiQRJR3xGSmaY8Tp00az7Y3jpLhuFDnMARD8B3Cmeh/HuZk3BnfvDS9EXacYF+zpy1oELmO+D5xmw8G0E6MPax0PhDH1iwFAScH9aCDJ0IgRWuc6m0TNu7spxfGOBVzsIeaivWx8+bSW+oozpeVPJ6tM3qbyDLJJI3F6tXHVV5olH9YzPQPbQ3ReGbedML6g25Xw+u4PJGw3+BiUxRXE7YpLx/VV4yuMg949HyEqibemN0aUTXGBB02ADpp3SaShmXosyR3jBRescZAYzd5XHiUiq6sQAhfNjVQIpo6rA/SjpJZsi4YXVxSQHVO0E41lU6pcqsGz4HbVxBEo6yrpDLJyDUNTDWaaz4CRWRQNBzI4filClHKSpm/hrYIj0OHJnm/VfKtd3wCroTeu+NI6c9wwcWShkjsRr1TIJIJLQ3caZELkSPeS8mnkIzsjDOAuMh1mxhRfMjeNRQVQXiwRHz8xa/P7CyOKrkxnXngYLbiaYYqRtpxgBu2lQ8Ss28CoTp0Qkj5DFCaE86NyE1D5GhW3NwPt3XDYvn3DcwxAQndS8Dc2msvYOKIPvRAhFTfRjbZnIiRYe67grv4tk4HUh4/rVEhICViiQ6dZiHE0X4JFi1qJF+Ak0w3yiDzsbj0DvKN+S3K/P0xLWYfFonLcjemMvDi/y7v5N9Al2O5NG4h+fXe7cXyYuyB/w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lZr3Qo9sas+t+O0Zb2VHu6s6p5KthsGZm578zUVisDRu1FIAYjfJIISF/WVi?=
 =?us-ascii?Q?nXGrDC9OlwQXHYWnP3L8a0rj+Pc7fMuETdWYVN6UnUJnmkOuR8WyH9w+mEZZ?=
 =?us-ascii?Q?JGSdz+j4cUdiCxZx9DvAZa+sV3/DbvXRqVnbn0kbLXS64TPrQeJyCvDOqM8I?=
 =?us-ascii?Q?O5H+gsa39ZyMpQfEcBRKi8FH1vjJP4fA5Of0N1UIwrbxO6ppLzw9+LZRjCvD?=
 =?us-ascii?Q?Sr2ul7qo8rjz4edOMzeFgUbeg1TFYkCUQnkQ5b62ZO9BJlAvNlLHFbj1Mm9W?=
 =?us-ascii?Q?7DKTRGxaJ7yJJGLhrdJaR6/gzTxWS95AfKqPUx9d/n+VOeGYKn3+JvOaih6P?=
 =?us-ascii?Q?s80GsYXjqjii3NJvhu6cgs7wBXg9hYQiCeiQ4HS0V1T39G/UDuVQayvRGLBI?=
 =?us-ascii?Q?cR7cR+thEeY5Z403gBgZKRBLpDffzZlcaOWo4ugp3TMxar1iOZSAAKKD9H54?=
 =?us-ascii?Q?Rd/gESBHGK2jJ+gsf0jKit6rSEVUQUW/x60wJmHrS0DFnZ3j6UJc6gdvt0ts?=
 =?us-ascii?Q?egLsbGyVYml7KWanTMajTM4QSPcGOdBGud5h6dtaJvRr7K+lRi3SoZXoAGjz?=
 =?us-ascii?Q?dfrU74o3Zwog8R3mm7+4nXEufGyzo9lLyEbNiuhRlTZpYQ4sChFMO8F56LoC?=
 =?us-ascii?Q?Z2DC6dIMmg5IlFZXRJ95VMWDb/LWnN+yCPsUoFQSUtDp8er09jv5m6XP+5my?=
 =?us-ascii?Q?3Frit6SWz/7KrietoVTpSPHx/RIFGofkwzCc822GoFKs6VePeZ9i30RbxAGl?=
 =?us-ascii?Q?IgkPfEVal7HP5Mna2TxghCUrc2h8QiH4ih+EfuyfXIRVCEiue5+JD/U7W6ZR?=
 =?us-ascii?Q?b1Jh1k23pTSb9qXmsmhV+TQde99nyx3zj8SY6kt09jBXeaeRcphxaLVKgtZ/?=
 =?us-ascii?Q?9cgB4+hehedCuZA+PMybPEq2dBX75QiDEe0lf0F3Kv1c5CdrF9L2D9VvJlTP?=
 =?us-ascii?Q?q+tcdarhvGR+y33b08oux+iODlqCL7jtfBSH0kxUHaV6me7Y3rMNJhN+GwCI?=
 =?us-ascii?Q?rgHjhZe6zD5gf4ENDe8kjJ8dZOsjp8pqdTYqHQS6NP3XtmPuGMFYOopzeXJu?=
 =?us-ascii?Q?YrOhA3rI/WWK6OMMFNbMrsQlqqHyrc62AIz253LT0doLKX8fxcdX+SLl+ZSn?=
 =?us-ascii?Q?dt0XTLT1IgdAAfqv9VJL1n9o2lLxC6Hv9zsCTYCdgasqfta8P8PeObt7B8kC?=
 =?us-ascii?Q?YfUwGG4cFEI0uBPyHzMTQJY7KxMNiTv1k2JERw6+75C3XozON4bdYmXf2O1U?=
 =?us-ascii?Q?lINLCLvfA6rewXeZyPy4tACDgvxN58E31G0hBQB1Q+ekypXs2lGj0bmBauHb?=
 =?us-ascii?Q?i2EQUQ5rBOpnWBY0M59YnEGLDa5om4loL6OwJnHyXvq2dIrcM7xclhMqcGja?=
 =?us-ascii?Q?AgmvwfiO2telrgmwNaYe8cBfc/tWdraa36sB4jFiIni+ez1ArnPmRuSlANYF?=
 =?us-ascii?Q?ICLuIzIFKd8qa/GZBRHKVp0crTnEWt8N9XeG/zJ0jS+ymAa5DV2wOgHgTY7j?=
 =?us-ascii?Q?fsaAjwTa3QQ9AefB7z3O/Rnaq93YS8eeGk9Ovg21Nd0B1D7gMb5/vKGF23tx?=
 =?us-ascii?Q?tSJ1RbU2vDowyJq9vlKnZhpugPy4SLYcXl5g/AjjxzotDR6z/RZeyfFWRI0c?=
 =?us-ascii?Q?3u8uGBQbia9jCrvd1nUNa7pxsTJjiZquDXnWD4bX7q9sqYDFLwm3981a+v8U?=
 =?us-ascii?Q?zaz6mwqBVTM61QdE0G3znnEzSxD7nzkkNCVec626kRhZphus49TuNCbYOvXS?=
 =?us-ascii?Q?M4d8xhQWw7JAjq3aRibjno/GD0q6SHM=3D?=
X-Exchange-RoutingPolicyChecked:
	uS/nh2fI1vWm972KIITc8CIZA/khzA2cREL34ccBumYzP9aKfhzG7LG26f9nXXuJ7ihDPVHWJ+/YIY1rZZ4R8TPSnRnMzAlqCjHP7cfERuR0h6To1he8L+IQf7HwGTp5yQEuIdkjeek+uvOk/4KE1hPwrCmp0T4lhRZoJase7q14eUMvfGXIkinAcC8xgecpyAuVaShQ1W0GD8F8pM1nAKniS5BhF3sBprRYJ3HlOA59BWg3i94ZRAiuRzgKpYoo0zGC4dfDf/qZrYap0XZZjystyNVATgI/AOTcqYzMVrQiwjQoebfAvxgfsB068eX30KC7g6QeoonBUbAqeMdxvQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KJSYbR2NVHrHsCMdfmVxKdPkY5XoBOmMJnl6/4HaXCtjUb7WwuQQcjSnMjCJarxFKIIUUato1DtnT3jrm15g1edBGMy2vxigL+Z/C0QLVeg7g8OHCUap7tQSTP+OiB+VAS8hjO1eHNrVPyL1V01bL1x4eNt15UDCFEmEXIeO9yHgiKxVFJu7YkTIyaT+NepeP3SVgjlbpp2HBg0RvTVFGkmpd7gd6c2IR1zlPrtvfAUuJ7xcntDWJ60Yg95ndEhUAeGsvRnTJk1pWIEaX0yJ1/gmt/ftcRealBhUaFb3pZDoxOosbe+F3zr7orO76gW98cHFvY+sgmFwlrHw8qM3e6tQfFE/A4kcUAV0Cdf6LtW/ZdgjG4FPbqItEcKvwzxAEUnX7LTbzOEO88CxQZjFfFKKgJrwmsHtp4bYfJwLjgSrZDYRfFQM21uVHmQIkgKlcz2t8FmsvqRvLBKqLNTuBObiHOegIFY/txCzvzLUHyymd51efW0gTqS2i2faYrY5sllAPpTCKgJtsvNDNYaj4Yk2oVxb3lfN8fzKK6UoFaxox+YSuWxOwD+dAf2Q2JnU6l74EFZknYPMB5Bgn6tzNAaQAvb4u/za0iyWSYpwXg8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba238620-51b3-45a5-711e-08dea51773a7
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:27.8106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5bJTuWH4vtDheSzdGyBElMf8xXDbTpi9f/HN9hfwRSu9B6VPVuCFOQc/mm0439Ixrwqg3WZsAgJPHDJE6pNcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfXxZ5RtmivphZu
 qB7lwvoSpmWzPF2nGR1KlqNUraz3oPK9ztABtoHbId5shAPMd+4InSZf9CobI9QLonbFC8/zsL9
 4KCPb25eZUR49tkedQBvY+7FKMj0HnaUy9EnTIsL/bxIkAF/dQw52+9F+pjS6Lg9spUH0JFM6iI
 QXxmdTNhhyHe2mXjmRsu4YK0imOIqdQx+mV7bOuY67GTJ/q6F9oAZiXDJNMmt8B2gPu6203g201
 X7FGWWpZ+fQn/SEgimLXPp3oXbKyDAiPinETh+5L1/dni6DMEHKS8I6ap2xgHeKe6WROSXNSKtT
 Hs/IJxMGRUmVgd5BvsLXMfHgxGyTFdf/T0GawiKv3LV6Jl3w1v++3rEoUEPKtrUghGyEg2dA7Zv
 V0GxfTU/oturfWtXtFHdBtyhSBCGUxITlOdf/ySPMyNKcJn2lfDMAxdD+uGvsLNu/8Y36avWqdP
 P7F7cxV8TxjOjUJAb2OUCloix/msmCHTNEckYGfY=
X-Proofpoint-ORIG-GUID: Ee1yprVMjCnVrG6-EmJ4cBVcp89QV3Vt
X-Proofpoint-GUID: Ee1yprVMjCnVrG6-EmJ4cBVcp89QV3Vt
X-Authority-Analysis: v=2.4 cv=E7v9Y6dl c=1 sm=1 tr=0 ts=69f096dd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=ecQ7zCoEdOpy3JLqRw8A:9 cc=ntf
 awl=host:13844

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 628a1d0a74bac..c74f336f8cba9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -110,6 +111,39 @@ static DEFINE_IDA(sd_index_ida);
 
 static mempool_t *sd_page_pool;
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
@@ -4399,11 +4433,15 @@ static int __init init_sd(void)
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
@@ -4414,6 +4452,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4437,6 +4477,7 @@ static void __exit exit_sd(void)
 	mempool_destroy(sd_page_pool);
 
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
2.43.5

