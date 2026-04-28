Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737A73F0768;
	Tue, 28 Apr 2026 11:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374903; cv=fail; b=OH54tjP8s3iU/ownjUPPe3ivLfpbTbXKVxgn9QdUL66U3rB5/NtICOgbyCbnXzhYTk9ofOEj8yClh6FFz+i5n2ooLrdcKwqgxGgCWAv50ESVZdg8XpqL27p3NfDRm9CnnKpNTT88mDBZyASjJDmWsZsZkhoAlLpoobk4jA/tq1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374903; c=relaxed/simple;
	bh=riKDEUHpdNYs9xxqBEPwqUI+x4vRDZVNJ9TURhiAv/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sJw5On7xz1D1ag2X8O+tgyrUpYcKW+t3WnyJg1ZiGzMGMA6bsLOvdnaUIrMHGpX00/To8mqaOihHK90jUNVut4L0afEJbVzo80+psWYOExONYM9/gerkn6wmYSOoVYi7UPrHXxjlRswLaRGcGZreDvfYOWm2w0i/UEb5ZU05cyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GGM5etxq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m3PZ8pTy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GGM5etxq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m3PZ8pTy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAFoG52603529;
	Tue, 28 Apr 2026 11:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8zySTP8VYF+iOd/YAGjBR7zoL6fZgJwFOoVmAUlLfko=; b=
	GGM5etxql40mVIdssbnKhKWdsbEjwdhEyYeBtZ5EnADPx/44WgQuN9qB8xDB6E7J
	Kmahz/Opjen1Elv9Y1C5cfQ45sIg42tL5qfOjoZMXz8nZq61ZCAWsWpJwc7N4FCG
	ts4EoBouy7/+e1xFA1LQMbdaBPDZF+wOXjovnS5pjwNjn0RFmOenPOYITN9ENdst
	Su1+cTdUtGsXzERxpr3fuC8rlZEjpooNTMb/odl5c6bCduRFg+gevGtFgd8ULc9C
	Z7Cpl5xIHPqm/lSeoyOmRJLH3jPeDbCHxa1HLpk/g1qrl0uhk3HvejW3m8mCiWEh
	XPOdF8CbT/+JNdItjG3Ceg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm1cy8w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCJKW033104;
	Tue, 28 Apr 2026 11:13:24 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010027.outbound.protection.outlook.com [52.101.46.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cufg4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XnFtNthvShN6FhJ68eNS8KNCIvtif+e/U0uR3zMt/fSYZq8Zk2PD6ygD52hce37LIkVd5Js66L45clIkeP6GG9aNsKEGT/C2kzj0rEMqxEbNVCZirzil9nXwDCWFN6rx7uQCvyi0nx9RU3xIGXqY+9UytLfxjRjMahg7OtxXFqQa7/HsKWj1WXNt/LoEz9/wZVsUnj48Z0CMu9Ajes+BOG3eFKqU6wFq4Rnz87Awz3qAE4L7i75XsYF+otwIs3+RZJO3fh8U6ff+gqjQQBdbSPgBLrfT1+UWHr2MPRP32+KEqFA81ZUxGwPUuswQ+G7TVnutEswC7rZ1rkci3fJyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zySTP8VYF+iOd/YAGjBR7zoL6fZgJwFOoVmAUlLfko=;
 b=BvrHs9Gcq6rYUyFlNjyEj5GfR2EFA0OaIvQHauwXHQq1/nNmXL1XbimDQ3w1mMfK8ttBdBURbEi9gR3OEI3wE5WywT2hrgh1KQvv1UssgzvDNPtUiStGn8/yONQ7PGbLw6670+Ptsw4lNWjV5Qk1AheWjz61TqCPIZo9MGZ75Pz8TU1oJm1pvdnbRqcSUIXCG7rw5kZGryOsIDAFz1lX9eLoHNkIWF5af+/oXnsKzyZPFj3sKe/jVICarjB0V0X1C/PiZa4IMCGG5jxXqtsC3FiCgHCXWbRVaUNmyne7hpVPXmemGEbOR1d33WiooUBfTq8itmSuWtXQqG53Rbx1Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zySTP8VYF+iOd/YAGjBR7zoL6fZgJwFOoVmAUlLfko=;
 b=m3PZ8pTyRr4VGDaHXNFq8NoAISdkNoIwogt3Bv/pPDLwYwtFLE8y5d/vLeJFRrhC0Arg2zu2/i/mRSoPGfqGgkdHLZ52l3Z6L9V3aph0jB2UC8NU2LucTbIb89CV0WOFxlhEG0+5RgNg0vHMN8MTHPQgYMDIR07gPczkNYOjY+M=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:20 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:20 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 10/13] nvme-multipath: add nvme_{add,delete}_ns()
Date: Tue, 28 Apr 2026 11:12:53 +0000
Message-ID: <20260428111256.1778475-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:510:324::7) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: f14e9b71-c8cc-4478-6ead-08dea51727c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z5M7Vt2REjXGD5dX/0wZdMVhbE3Zbr66jHUqaq4o18Xj5O/Mq/dpucWsZXHGsY6+EA/GCWLQpqSYd/U9B0NsAXPpxTP13NTzwAM/yFO4Ay/qKo46AKGS3OKE6oKe4TupfBiKH2aew0+GTQV2hzcRmElV/+JAc+Le2pCa/csCgivRWbIXrnB5Vpp/3jHoOkar8pJy55VfhY2xzF7eMz9IJ5YMc0KvbaWDoW9WuE9JYGf1aQq+zxSxXSyMQpKnVCRaPvuZfVXzoqVvKhnicpjy0OSkf4Ge3fn7UBZHeM3dBkL38m7f+N4FUofq6Rto+TITdxREFUxSlNDS5rxDIkEOJ5L/Klih3w/W2tIaehtVfCie1/f23PRteBqRNCjz6R+W5zw0ml6VOco2EE5XXsutR+HyGEUc06pvzupcXDiiKYh5Zsj44FL24WoGoUISolTZD7ZetyoXIHyZPCRMm4rd+i4JorwnKpMwji8P4F5DdsJXOTIXWTmS+0puJzywIi5rGevmjUQ8jtY0Jiif7gCaNGgMNN2RBDOrk3jxZjB/Ghh8xYaMCxFXNQN9Kc/nLTQJg/TysL33vn+SMs87MwD4B544+Q6Oh568Xvs/LB//8YKEX/p/v9Bx4DF985q0QMyiXYVrAoWjGVfkpOp8uCC7UvZClYBgMQqiXz50kx5OA0fndr2qhVNonix7NbgXDTp7ZFPoxV3tTgB6WaNDPkz42WR2TspukVLqIvegZUMXfHw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GlVaZPPG48RA9R3qaLdHEpNypv8guyRToNCxe7JCG6EQYKG6fIYG+QHZU2jn?=
 =?us-ascii?Q?+E411XfbcA6ew3uI4twWEvnFOH8AbXFOXa4muFB4vf41EXbR9B3cCgEsd+01?=
 =?us-ascii?Q?l2nVmjJaahGxSKXl7L4f92BtOoff9k54VwvJd7wvPutrfDGj72HYxisKPgBL?=
 =?us-ascii?Q?pCdm5qcsGadbWEZHQan2GxHnGpvA6OZFdf3ECiw4tQKdQ6fVbOVWvaiiY1xX?=
 =?us-ascii?Q?NCJkgTdJDfxo2kmctg6iz2ua0Fr46p3EG5uHTn3hk29/B9T2QufAuvxyt57M?=
 =?us-ascii?Q?i6xwAkqEwyybuS/B0qUtxL3QxPdQ2uVnW3UE9dtsuI3ThACwQVJPigfZSGHI?=
 =?us-ascii?Q?2bYn7q5s5/N9spJP/hHKhgguM5+JFfy8NDRcJIRTotKFneQ8oz2nszgf89XP?=
 =?us-ascii?Q?rwRAdnnQcLi7A5LliT14ijpa1jZFBb8tLA415SNVm3APS7VJNsKI8v58tpVO?=
 =?us-ascii?Q?LQxB+bdGJ4XBFxE4HuPbgBm0qtQlahZ6Ykd94rRdwo63ZjLnAkK+3AFJTGkZ?=
 =?us-ascii?Q?Rur3uyDc6WLNNH/94o7avWWAp02u2gNW0psyofz2X5FssUa7kDLtULiuIY4O?=
 =?us-ascii?Q?16Snp4Uv6EiGTUoI0QeXL3StLKTax/Hg1qNeiaL1Ym7efDbFBT7QTwXcXc7m?=
 =?us-ascii?Q?2ODQs7dpfh70yEYdOyxhXKWMU4ynIdXd4e2CButdwCcq0ohSuVYQZMIL2VLu?=
 =?us-ascii?Q?qnmG/ZyokX58uXfb5vPwksHeUe9gJNhQE304Qz0mZv54LBAxfBN4E5oqjeT1?=
 =?us-ascii?Q?CT1ZqGXYAguFBwlEirFoa6Tz6HKIrrWJnjTt1o6BLd30Yf2YMAt14+wlhgt6?=
 =?us-ascii?Q?SwdP1GL4uB+/WLotvFvU7Y18HHZlK6kMiPmV0Nvgfh4Nl+WZjwl9MtVoMqGG?=
 =?us-ascii?Q?ErC0ac35jbkXmNeGCbST0qkb9YoGt8X7mcNCpjZknO79efJ6fLTDrMC3fRYk?=
 =?us-ascii?Q?oFnDxZ1AM/J9RMcf0xJ7J9i655BDw1LIrMX+guqHzwOf7tXcYwg9Q+BBJmpX?=
 =?us-ascii?Q?PgPft7ljigwqZHQtd3aRJicDbUs2cBUrGDdkbKqu4MdzfozPD4WH6EPofNZr?=
 =?us-ascii?Q?+tfRQoq6e5uNQZw0I0PAv3cwkYZgOzpHYg5Y0mUZMPD6RQl1L9MtY8pilgGE?=
 =?us-ascii?Q?rFobYKGNxyTwbR9xQ2vi9RhjLEbF+qIP5F7GlG1rO35fcg2a8EOHrwIXcqzj?=
 =?us-ascii?Q?8IVAWFPcKhkb1Qt+StK97EMEjsla7R/FfjKm2J9w9VoEiuKYFxTbo//9b49L?=
 =?us-ascii?Q?iiqbUB4EKj+nIODdY3j0Jqmbc0W7mkcBqS3VDKnrgAOPbOi+W3b3Mr2+n1eO?=
 =?us-ascii?Q?dNWzyCxJTPbEmXhn/D59GrksNOvpc2sq/RvFJ/9qONgP11zznd+N6j6e/x38?=
 =?us-ascii?Q?Ec9nic879jod+5Z6Mb1sua49squpswZwHSqTulT0InygY3eV765jX/BVdqle?=
 =?us-ascii?Q?EGwOZu89VAZfOZsDoSZWVDgdxtFOJbroRExSU6Xpj/QglIh10wj+0NX/M1D3?=
 =?us-ascii?Q?JAnLz5UG//715pFgTG1TutxrPKApZtTLnsbyys+ElD+PZ0kvbOWfIfLellpz?=
 =?us-ascii?Q?FNJ89izxllhKxfNbVvhAgUBC3rw2jHP0bJvBdeOz+50SAbWM5j9ENUCGpJwZ?=
 =?us-ascii?Q?uV9wM+HE1yXsq6QZhaVZbVWhq1TMTb1R1nTJL+Zm8sA/gDbVt11K1KkojMLV?=
 =?us-ascii?Q?EJ/CrDT72ZfcIjKQ4JydmfAqu/chifphqATlvNF/0nJ/F8xCnkZeianW9Zd2?=
 =?us-ascii?Q?cParMlHud6wAzvpwFhJylUylcAoGIqA=3D?=
X-Exchange-RoutingPolicyChecked:
	A5AhLZFfAKsg2lr2YKNYAwrXBVzPWGJD+IMoaSUZElXUUoSutUVAEMPGrHEsdf8aSZwubzShY5+oZCQJ57KiQdjsS1ETQU0rvZzm7SWMGnFM3lD58C1j21PeJqcqc0BIEkrAG8Jx64oL9pKdLcvxA6sdfbL8SUHWkn0ZEubr+pBF7D4j1GV8LV/iPo6FKKrGjplQppCA3o83nci94vqvAuB1oOSHggu1cafSQlfB2xXds+jImjPzKAbknL1UXpudnsuD98VjgLPEoneyrK1gtMTg3TxJgCFMTUfZxV6cXApVyc/ULQkbBQs5I41FmVerByNS/SNHSufKp9ALk4YEsw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mqTgTOsnRvsaxFh9GcDg6qi+k4ZkFxu6Uo2mkw2I1VMMhZhkYWKqksaoXv7huJdvUpT6kZjecUFcJh4X7z5Y2Ij8DDYEQWMCLYX3EMbUyODGA6iKX7vv3DsZqyj6uuOvyfkmWfqjoGDTU0Km6H0IPWN78bWncprOfemrBwzeME7trW3S6AFTN0zG7CznxDD7AEMVUZELVVqhFRPr0v4clTZyfEcF4zq65Hb3mMwaAKFjBh0S6SOTutvMQ08NJkbhBZRdgOSWr7+77TXWYakNnN5a/Ckv7/qIS9+0bRLdD8+urKsMpylVJ015j1/uoxc3K+K6a4NJrqmW9g2FpeSVMllWdd71c+PByW5kBFSmdC0GhHiYa+ZF6KzQ/3ivWYPoGhZF8FkOEGFqJEAwiIJHWMeasbMYtKvqjS2VbgX7lm9bKPtuNoZoSrDj8QW8R8GfQg6gd3mr8p8sZjc6qpX/Hcp9uLtSNlO//Ia0Fz3QSvTxGTsr01s/3W287ursO015jQADu7ujchXlVJJ08uA3qU+CuTSu5lxH8QC5Jym+yfZZ+GRTRhdo7EF9J/ZFAensjl4NXsDV107fDok8qpZo4VSe7NuIKDL1FIru+44VGQ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14e9b71-c8cc-4478-6ead-08dea51727c4
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:20.5017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6i35crL5a2FxI59nKruht8nStL9oPqkVxsbMofkUw8f5npKGLwnYClK8KEi3GOK+N8RncIAvnt+6TIpBbzJpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: YwxvVCSCZnwd00A4ZXfm4rGGydKNR6mZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX0gBcleOf/ZYE
 IZ5dROhXLrCZAF2CxVV6IjHzo5ENw4zX2pYsCgV1diAFqyrdOmg9RPs2rMRKRShoCE29tDfZlAM
 CobZfXnM39sYtRcjq58cNGNzkScUsDO4zkSZ1/Yz5NCndgrvQCeNFnyZkIMkG7wr3xBo2yAALFh
 8pm5ZFQk0h5MLtc44Xzsa5DIr6GrVcBluSR0ksdE+qnqQRxZpMF0YEQmeZNHHRH4B2vVHIQxxma
 tOUl59TFYJ9VhB/a04JhRKzryVGccHDPJmAiGvqz3t7V+Na/RZ2bOW8+7LS2aB4Yn/aEx9lcw+9
 bk3QejeYXf9SFZTuzY7bFJ229UtS2mgEvug5J9njiWllSmxT44Sq7sa0ZktnfOEo9MUUB7MWzS+
 7JND/1oB++ZmVPjHcxcBNb1c+ldrKbZ0I/O3nMpQcFHvc2dNwfXiByGp+MxEM8XNwOuFyucM8I9
 mDuyYYNX1bxI9cwH4bg==
X-Authority-Analysis: v=2.4 cv=I89Vgtgg c=1 sm=1 tr=0 ts=69f09655 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=tcljfNdi_H3tkDvoszsA:9
X-Proofpoint-ORIG-GUID: YwxvVCSCZnwd00A4ZXfm4rGGydKNR6mZ

Add functions to call into the mpath_add_device() and mpath_delete_device()
functions.

The per-NS gendisk pointer is used as the mpath_device disk pointer, which
is used in libmultipath for references the per-path block device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/nvme.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index cc63ed8131c36..b4fe7a7dd7f73 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1025,6 +1025,19 @@ extern const struct block_device_operations nvme_bdev_ops;
 
 void nvme_delete_ctrl_sync(struct nvme_ctrl *ctrl);
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
+
+static inline void nvme_add_ns(struct nvme_ns *ns)
+{
+	ns->mpath_device.disk = ns->disk;
+	ns->mpath_device.numa_node = ns->ctrl->numa_node;
+	mpath_add_device(ns->head->mpath_head, &ns->mpath_device);
+}
+
+static inline bool nvme_delete_ns(struct nvme_ns *ns)
+{
+	return mpath_delete_device(&ns->mpath_device);
+}
+
 #ifdef CONFIG_NVME_MULTIPATH
 static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 {
-- 
2.43.5

