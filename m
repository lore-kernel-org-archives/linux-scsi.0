Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1679476CC2;
	Tue,  1 Sep 2026 10:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259583; cv=fail; b=SKBfLRd/+gBN5KD8zZN2Yc2DfMTnrRSoWKzkGzuk2zdRaNPg4137ObXoqBkxxBi0hRsdT7GRlf0pPR51AwbT83GvPwb+iYO+MkiLwOPNhvkjGJ3aZrDsPMgrjIMJXVmsH1Cob9NAcioJRZsgb31BBgGXfMqTl0ULLhR1y4Bku/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259583; c=relaxed/simple;
	bh=n1ZHkZejQUckZdRrC7phXm/Ks2LMJJoS1p0UyBezGS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pTT3e79kbZWR+ehz+sIcKO+t9FZUdfFFCKrL9yGT51rM3v6ih5blQAz07PVpdbfuyIBlRf1p9g8C3/MTTm83dFbAORdBN/UdmBc74YoQAaC9gLVzkDI8SFMxjM60LmgnBefQ7MlT1PRHtLjLR9mSjKh6Fe5c2mU1m639YUFTeqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XBvQheuB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oZZ+aNvn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XBvQheuB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oZZ+aNvn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBvCG2846793;
	Tue, 1 Sep 2026 10:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ur5FzgoLQOLKvnMIPofATlM/EaZmZTVUw4Pkj6EOhIk=; b=
	XBvQheuBUUoTVZG3/QBpcCy6laJSoKe+iP4IVjgn9fh2WGRIQYGzDDRxbko71yFk
	zxyOo6s3PwuBhLcnRvZYZ4UlqPtwJpVKXENPm8z864GXc9KlnRhkvIbXENPb6Jm7
	wrcO6wc9PBS9xjz9bxZQKniW+r448D7+r7lcd7cHMYG4xg2t2QsYMLVdz6mjOHzC
	ASU8DsmD0Cve7iU7Lwb9G+rnLFL85HaoM0DR1zdkZzHgN+X0eIXmKNi8YN8HtuzM
	NhU7aLzVMzw6RWUnP929prt9zjtVfGb0sLM5O2JvmWJxVVIiy2yUihFjDuG80Gv/
	rOQtxv2kBYkDk0VCrDwr6A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbavegw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjY9x036488;
	Tue, 1 Sep 2026 10:45:56 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5hIIf/vTTH0iE7/E0DP0sykH8YBddXziswO6BjrN/PqJfgrPpa75bngET2h1X4ALZIJ4ZjdLwF+0e/Fod/9x6Qex7GZLpElbEIT6A3ka4a2FoKg7PAlOM7RO/MnbAuAE4DHIpS97DEkB3OccHC7IeuoihdxQSEPKcWAhg7zzh65L7Oy27QXnUpZ/rYfKSZAxT9JCEAZ+Z/jOC+lFscnsRUPbp0M3KnAJiGVXKKarsUdqfo3EQm6PPkZd1ej2zc0vPqtjTpSx7ZdnOmxY6SHlC/JaCJ2PVAdczuisC5VdcZmJgtC+5ynS7K/ciGEs9HucuXAes4uF25WxVYpYgyHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ur5FzgoLQOLKvnMIPofATlM/EaZmZTVUw4Pkj6EOhIk=;
 b=melN0CWVj5ZN16YnK5uEt+E/ZLwxK84tlCvhIv0xn6VN4DPDlhCkLX6DirY76SJf42MW3Az9IBG340ESvqn+VSrbxxedJaiT4Rp4hA9XMgENlvaZgmSxgAU9NXK6RVU65AksHmQsnnXO4AW8jm1zfnvu7EYDnfjbg0KG9E24LPn1kAQYH4wz0kEersc/4h+RS7Ho9HUxg2LE6wAyw5gJK3SArBtIfNR8viXJqc4mBC2/9/1hpsj1hMa8dAqVHnjUXdgm5JHOVU/H5hlTKkkxwAeBYjBTbr7h217KsbqKM9Kr2EoMR4U6USfZdHwUQZ+RlR7tnxwsgPoguxi0ioYwEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur5FzgoLQOLKvnMIPofATlM/EaZmZTVUw4Pkj6EOhIk=;
 b=oZZ+aNvnrq3ywo/EmotBezSWQBMIMWTfnls3xA8StC7nfaHaQrwsLtjHZl177eoswIjOUJ94Nm1IrUhYRfEx+MIByds73943lE1QTNZxOLFAIGWV9IykbibbNRPH3ZWfs1zi8VywgspI8lms+x+i8SEMuMqNv3wcUzFaMocbbuI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 06/27] libmultipath: Add delayed removal support
Date: Tue,  1 Sep 2026 10:45:05 +0000
Message-ID: <20260901104526.3850621-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:610:4e::36) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 7edefc4c-bd6a-4553-a232-08df08162e8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	mj+v0CbPx0Q0s0C25hkIaSPCds2fMgNmQ/u4FW1r0TdPFm+IRVYwqJd/CIEzeAyEm+7sH/IqMG7hdY/7bpl6qPiM005FnAzK69pLu3Tt5ZGgf9QHPZ5+qXSAIFrfEFhPUvOc2l8IC6peGgjNdyaTlXJRfAe2ejV5kbwJFbSGdjJSoIYSHRO816aqaGI3v8eE58aIdhdVb7ftv2TWMHA05tSi3ii3YlMbPwbcVWUtbiClf/N0gn26WXUmG5skuWzYACIM3gYBdd+jRZBOsO+EoNm+3KWbu2VP1ja1OyvpnCCyW/DJFb4N0yKsaeUNethrxGsZiQ3vqSMjRhifwiPXrhQprwm4v2WAyyChJ60DxtMyTr8kdzP1fsy/vFJGkwyTFdb48TIhJqCoVbBlHjDO6ubt+e4i9h+wroOZAmX8rfTtQST7/hHTW5sPsa7Y8dxAlxCFz38N2QzGlwXmQSz+Doipz51Y09fwy4DfwCVyxL5EV+h3FeBB35CcuMA1NkOYDGA2dpjlJVIwD78YM4SxLg0+WmO3QulsOOw06EuKmRiJbRj4UDQBECQ9I8R7nV/8YbtIOMcfXyGGi1mg+busM/ZmxChTDdrZcYgFm6GaFJCOxsa8DFipvGH0l+hO2XrufNGTUsr2y9LTmT0PXlcntrT+a8qKG9YL0f/AuIdLouk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QsMZFrkcqafnViX7lBVW67FXU9qwpkIiFGCjtupZJwNbbHCk4TEDvX31LVS4?=
 =?us-ascii?Q?MwbcR/f7qjW9CWRqr0wmJ/GNvj3/xV8l2gRnR59kfEXT32iFmKbPU2Ay7a14?=
 =?us-ascii?Q?gLhRgkIrGJGHXf8CyGbZ7EbI1DGlXuJNlfGLBc8KnmmJ0wmB856bOZh21VY/?=
 =?us-ascii?Q?KzF0jyDYdEyaZQvZ2SnnBbDkhrpFqZXPMylTcGdo2cvOfEZkwg8/YxiH8gSB?=
 =?us-ascii?Q?RM9jx9uRJSG4IujZpzOim7y5swkV84mUHN9KhZJC8mtjG3kJlFmGMvG71pWp?=
 =?us-ascii?Q?O4pNHKwxWm4AcIS32D58Kme3uYtnr21DNbtgBHlIl7x+63BvTgr2lWv9I6eA?=
 =?us-ascii?Q?UNciZ+PcbhrSq/Z7z5KaEKJiyDLM0mRbMI/Z5yFsYTWIXKyYSsPimbRTFOUp?=
 =?us-ascii?Q?PAL4ESCfw6+KPeqRKzLgyHAE3kJ5qSGLsfkb2hfhhtF8iXe5nEAD0IeEMioX?=
 =?us-ascii?Q?+XjnT47481NeGA8SDdlc2T9KcP68BAY280/EZ3ZAcJYx3a30qfNa7HicXoIC?=
 =?us-ascii?Q?w1UpF5SNP9UGXadfpVE/MgWJk9MBvv+An0vzpmAog92bjZiH7r0MKxb/iHIS?=
 =?us-ascii?Q?8NCzhg0kdDdtSO1HLf9soBCNGGc3rB1LyoIVKNKMq4w1071/+h00ZIiMeRxB?=
 =?us-ascii?Q?H1yzKKE3GZaXUvv7ONqRxznWQNrlpLGvGs2mEk/C4hcBFqa9HsaVWKiSMtKB?=
 =?us-ascii?Q?eQuyzm831fPybPAzfn7it7+kvGEClyFQIZFnHzgIwZjsEkLaeR5+GKryefD2?=
 =?us-ascii?Q?YZxkBQZk7aVDSJkMNdoOPQf1KrgNSNBqqTMHsjyr1bLRPvfBPg5xsZr/8qUk?=
 =?us-ascii?Q?Lg+mJqemtyaFs0cfm4G71QHEE9idpUyzs79CSfQmYHrBdrG+G6jh9Ly3aPRU?=
 =?us-ascii?Q?7NpjWofx5dsDEEtMsffKNfvK7SQaNyaZ9ZTkCj5DYOGqRz9sJBIsjjNUvwdl?=
 =?us-ascii?Q?54Meq+q9pata5jJIjR0u3EbYwYTWSuQeY/gHQlPIRcNDpDrEHk26yoGdfCj7?=
 =?us-ascii?Q?ajMP1q7e/AqW6O8gGKriwYNtu5VHxTQroLRk8dNTdFpwFMkxT/T5C38HRZlG?=
 =?us-ascii?Q?PRMj7mqe85QWpgQJE94Fvucv3lXn29UO2hBN/Q9KTmJAcjEiQYtutFUKcW1H?=
 =?us-ascii?Q?HNmsgSmyQZB6HoVHPJMM8N2kljh8QL4MCMaR6Re1fjjipBzBieUqHLUlOVdP?=
 =?us-ascii?Q?pHwbzp43yFWEgmhydmdT4EWUzztCj9xYzIG7bJUykfcFGUyfkZu3TQ1jMzVq?=
 =?us-ascii?Q?n+jWldLJ8wnQqbGDMBcimcYI33Me8FuT/PWTcmPUksLZLJy5AiWaCEFRUTtv?=
 =?us-ascii?Q?twekYi39iyCdo+J4T9ISvopCD2ui2uPvSHolz18VbPuC/je+2JWRoty2t62l?=
 =?us-ascii?Q?jsipCv2QFTNQV9RwlYOyjjIqxOV0ev90tbqT7r/hYuX7jXtSRX8DhsmPGNHR?=
 =?us-ascii?Q?2TZbJwUiNwSCG7qhdDh7CYnwAB0aDvbKD2VsghboxknjDArFfj9FNxKKET/2?=
 =?us-ascii?Q?Ciho8wMIx0WF5omdtJw6B+hQ7zPnCtb9z04nD4QocKv64PsqcA3pdNimThaa?=
 =?us-ascii?Q?9aMMeNdqLn6IOhLx5/OPJ6oUi8y0StWTLmMwQn8TxF7AgYsMNrO4wLMu5LqS?=
 =?us-ascii?Q?DIZUwxGvFhItUTWsYQ/1YPO7zkWieuj8Kat6FhLgPGfhQKBluo32yAY2nTof?=
 =?us-ascii?Q?+lN0tV0L70r2S+qkGLL2NbU/yRoJLTI3sa09NeM3oggJK482nkNFsUtMH6K2?=
 =?us-ascii?Q?7zmogRpTNA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	CzS7C8lSg2d/DGOiJ1kRqrP2kTC9SkLXFXBy/5qCfzv8HWvu7N+aacZlJmiYsUUs4RY4AUXIWY+i+SKitdVKFE7PLxhWwbGTJ+FkRav3MAPPaNv+sbc+5c/NcSARX0xpkU+iDKdW0cWnoz8V7/UzAM/OX6oRHsHC3whgaKKWgWRzolVZRf9zsug1Q+dozn8gl4oqeyB4l4mC72fpHksRFzlfOym4t0fGutmq2fsB2gw7L2iif/716f+XES4Wq2krdXFpeW/9dbSWLIre5AoQsJk40qsjs0QzmtqM+m9P+2EeX5cUwtkbDfsk+vhoBqRv0ufTyqzFxJrvivj5RKVXkg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CFzD23zVUuA1YW8OQrvFVV58MR3+2c1z9DnuTGgwlqbgoH713rd4hGGeikxhSHxlwPn9Lbd1eY6pkUfbzusrzViQ2JuucvhVCxD0l7dJszRzLniITpbwph3nYyKH5Wh6gxSxk6NU4ETV8ermBRVkn9jsnbvy5w6DUyPNdegQjV5aEVwwT7ZDzNfdQ7lUk7Ex5o/8ziqoEmGDRofW1Gv3zVMbtkIbT0Lg4bq7MTWtFMy89vLBkBa8w8jICFVPqsOI3oMkKWHEur94xrzXZynrVfqet/F8mM/7prYmBIDWghWUAMiOVAsP+BR9foLAL5MVfVWh/7Q3hVp3XtKLG/AT1ef2o/kXL0/D+PF+oAr9M7Cik7ttrl++pKiLVYBJsFaX2AQyDNA+FAAOypTufKJWR42RJ4azLqoa66CYaREuYrT+EowyNIcmgVmTy6dmoVyU0yJ0McWhQEmgjgn/xAdKiPvu2xqsuTmOxbYJPqcK35k6RUacBtxO8yUM8HGD3F/lgvkPWV4VgIkw5fSdmUO5XKNv/8j/E7Av05R4HESSf51MUBjq/I7E8k758utzOy8leGXGFnxC7us15ooKInKceNG39IGMKIjNPvxGueBfigs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7edefc4c-bd6a-4553-a232-08df08162e8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:47.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMbdWqO48zW8rlTQ0n/mor6porfo5F+9zS9ul8H12I7/RSUlkoTwlCTcsRnYClN0S5y1SYE73y7jvCdj/nyRpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX7Xz5w9Y/hgpT
 GnjlxsM3dDv9mFT/tVYZMmrSIWOLkvcqrtJVuxVF76WNUfbsZpdyClZQJl570hLMNIpXi6EbwcX
 6eC2LIBnjiag/pK4phR6NwBnnA2u/zcdMSdN9UHAIJGjFeXx1fYp
X-Proofpoint-ORIG-GUID: As53WtS4RIiqP6sSO3YcfGka6l_o0BE_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfXy5LWwMtOWdMa
 3dHnWu8S96Hf94Kkhe2F2Rykb7wAZHBpvi+/lVcrWO8utnqaZQqZ5bhSXyfAujcQusoDuTP9e9l
 zG7wF0nJ3zNy3DmR17mYV3t3IEMf8g+sN5LECZq8+SmMNJH9QdgnucQ37fJRf2/7oFYp3on4X29
 lPI1+X9ZnDAqf+X3Qteyomj4BrIXZwKM1ddlUzU0H33/NTDPI7hYKLJzKrpyLqqMTTtd8L8DSwh
 7FgW/n9nj/lIevRlwkCxtYkAkk0HQEhlIhnd5tAx2t9XsxLX4/02H7ClybbXV88wiaiDZzRec0I
 FhjmA/dElZZb9vLaU5glHf4hUNP/kVJ8m1W7C69xaNSCa43553Y1AbfErgahaUKTSVycChvlgjl
 d6VN3VUHIZz/deOatOWtjhz72DVzYzS+/HV4DioESfYk/qKdlq2N8XEv1l0rtX67LKektiFhaYW
 jTdtq44UQkfEGyAmTxMLmg96FQKwwsr2AFNV4Fh8=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a96ace6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=BfxcaXdt0Lgmg1IeN-8A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: As53WtS4RIiqP6sSO3YcfGka6l_o0BE_

From: John Garry <john.garry@linux.dev>

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 91 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 033ee8d54bbe9..66b6ad9c2219a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -34,6 +34,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	struct bio *(*clone_bio)(struct bio *);
@@ -41,6 +42,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -58,6 +60,10 @@ struct mpath_head {
 	atomic_long_t		requeue_no_usable_path_cnt;
 	atomic_long_t		fail_no_avail_path_cnt;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -111,6 +117,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -126,6 +137,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index 6b8f6e846987a..fada92bf9754c 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -66,6 +66,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
 
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
@@ -339,7 +342,16 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -481,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	unsigned long delay;
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&
+	    try_module_get(mpath_head->drv_module)) {
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -529,6 +574,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -572,6 +620,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	unsigned int sec;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.7

