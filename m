Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291CC3FAE02;
	Tue, 28 Apr 2026 11:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374729; cv=fail; b=sxDyThdc6v5k+9x9sPZZg7ebQqfJU2YJMtuYuZYZv1MHm4WR/qpH+ukl6xGgvAHY8kqDoTrnjuTHQfh3wuM56YxFpQThXcUh+LIX3Ry+PiR/w5Ws2+2fOAYaJazPzdDF5huN0T/497e0Z0KsWc9T3EnvrZ181g33PyzNOZ8mtuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374729; c=relaxed/simple;
	bh=+7yH+R9/Eh5L8tSbc0OczuhWw0TgBu7HPp3TMW/6ZZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NsBKC5NaMHzFHdWdMGqrIMZFA+4XkD1EXIBVw8tT1YjBHWyFLm9brdrlqxliuljumu7DhfY9nwg5xbNNZWsH4sNIrvjU42wKEuFhON81PcxdIYd9f5EkpoGpoKbvhlif2zTQ9TRhk1MibSt/NFhxrgTQMDqH2ypMKn7G5pgdGx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P1EbTZjx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ygad4HHu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P1EbTZjx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ygad4HHu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9jIkc720982;
	Tue, 28 Apr 2026 11:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZMfVht24w6rCImAj08eDnbix/wVPGRRu4Q66GVQu3uk=; b=
	P1EbTZjxhQHvMFhCitnf8p+8usqcNSmxvJWh8XL+P/9IFBsANaMCi+HnRx1voE/o
	m/sRS6hniraPE2NIzsH/hrv6y9/1uJVoY/+7NWMGqzx1pGrMMuNJDO623KdG0Rt3
	T3B4HTiT+iRkgbh5JGObDlfiDCsCvnUAcs6JV/EUFgDembDli5vOtEX4CeZJrBi4
	m8OAk8w3V4WudiBjH7HrwKhzEmzjZwVk68yPX8mKu7VDzbvIwsWoJ0ujtVrnrbhe
	urgMpYnMg6FUbNJNFiDJ3LUYYmBJrlzBEDS5rNgh9pPK1BmDVea2qQN8ltFWZntV
	r13CR+/awE7AyMiFAXCUZg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drp5syesp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2kNk040801;
	Tue, 28 Apr 2026 11:11:30 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cudth-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLecWJWzPyMZAXsu3yfTvPWSyKjPJUOa/WqI1goc428U++ldeAWabv6EcSG3mGEXQA2lV5ZMKUM+91f/hB4IzwSdblvozS0kvFHasT7AIKwbPvu83om5RWIYySiUarIoMB/N+3RoXD1U+RSVd9unU1ohK6CJLXNLfj17HltEbn9wRa5swtvCrz5R1O2QYBnTS8pNLAOu2H4K8FtDJJcALVcPxJSvvYWXkxndqqPp/ljUlwASfUbletF2/5TwlMeqhQi+u7UfmurvKRYAQ7zEJvi0MZNE/wJYC2QN3NEFrzJIQOC1yOgGNz6pOsgtHGP7n70TcRq1DHwxwMae5uQYEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMfVht24w6rCImAj08eDnbix/wVPGRRu4Q66GVQu3uk=;
 b=pB3M1UqRuWU6eUGqj/3x4rggX4qdqbrjnytiq20aHbJJ9hVg9u1lNSnaL/Ox555gCVqJVJcf0el7CHCIkxBPgJ85KGzUl5zTHUaOjUlJlsqcndXLcIlM73MMdKp5fMSL4/itiLpQrpXY3AY00l1fPq4yZOuapk5kj3LiOv2vjuATvBYDxzV8vS3GcNc16aMEm1gTfKCGHgpF5KyWUcE0tnEUFvqwPwvjbIJYX8+z6PdFOtLfN7osHmjY0UJM/EkthdxnVqrXO5OqNGnNpl+A3ybrOGqVMkKjxBwr2zX4hspcnvxFR5h1D52Uk/0wWb+CsLMsScJRehr/Ri+OM+qZxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMfVht24w6rCImAj08eDnbix/wVPGRRu4Q66GVQu3uk=;
 b=Ygad4HHu2AsfLh60p+wQ8LhcGhwf0XKg5Z6R/kRjUyHM0zxtsr2PwiS+tw8OVocKY+PGqcqDjnBzYyBUPkPG477WpQZLLbympRy/OQhjOzrjr9AwNlcesHnoijRPzROo9Ulf7vsBC0iFLcoWvU2mfcKvTJRRi0V0cNSn6t5C/Mw=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:24 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 04/13] libmultipath: Add bio handling
Date: Tue, 28 Apr 2026 11:10:56 +0000
Message-ID: <20260428111105.1778008-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0044.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:2d9::11) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: da8f4909-ab11-4624-7426-08dea516e237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iRiogBpSS4aVqJ51dDtv1ON8OuR8fvWuc9t6u96SrIrhpV91bp5dlGZqhlDb6b9za2hCtrVX4vu+11MhmW2te5jKuiPxtc4YGey+ZeQyKM9FZXPAL1O+acvYKVEzmc4W8D79JkPc1h0AERFZU7MO0m3MKVADHP2IjmHjc6Rq+s7dDZoYN4A5KaEyjPBUQtikPidSRv2tabMt/8N9JTA2gHbb4nXWZvjHh5voheKkxqbg5jH2U38fs8YMsEaAun+ye+oyJHIp8D4MBv+x7RjBUxwdKtnHPLk70hGfEFFL0xScXlPx2Wln9MQ+XR/25p5C8fFgP+H6jZ8oC5lXhEYfaqiOutfEuVA9D/OLacIkgonJhOb7K5T9dpgmAh94TiRduvX6ejc8He0UriHxWM63+ZTcpoQTSRk9yDSnItId5o/eXptPiUayw/mw/HQDKoS9tKaNItvWuEfs1DpRmFPSk0VUn97J3gYL6rnge/sevvp2gHl7jRY91QJatqzizrrUaz3dU3ovl2Bv80JXBL/nvpcEoJbJ5InVDVEd0spQju2GSXgaiOdZQtA9cdia7O1M1XENB8/YelQ9zuSTOxGyw/sD5gVVxMRN4W2e/oItM1ROQAlr5BEryDbA0x0JQYp+N7bVP4To/u9qICet4i0/SMyZaIEF6x5nMI0TdaqVD3Q12VL/5CqXKOrxHdmGKeOeDdxoZQhlTB21RNVx3qN5DCEonXHbwJUZY0RqkNbLrxw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gVG1eyEhmugNW91xb+9kZo/SFpTIKz5PnQjYdtxIR/O/eLT7gBmwJg5ZkzMG?=
 =?us-ascii?Q?nCGVCx7urcL6tWYPiQGqspOEcV/uWbQ3eMn51EJVDetZlQnfij7B+/GVnTAE?=
 =?us-ascii?Q?GclOyA20f7x5pK+1q5tP9s2yjC4mcmk+TRw5sZvduATERCkum7uBeK5CY6RO?=
 =?us-ascii?Q?qCQuQzEHckl0ykvg1dmPkW6rMKsLDg74UjpMBepSH1wYmkQIVgPRbWXC9rDK?=
 =?us-ascii?Q?j5bV69HpzStZHdcN9v2Qp1isu5WREABNf1gFDkbKBEO1trRheaVL4ncC0Cvt?=
 =?us-ascii?Q?HzX08ibRVnBtxsSCU1Hu1zuw4vBjygr0dVYWRD4sDLfRd77a4Zwooat9x0Rc?=
 =?us-ascii?Q?/215K2t2aAm+g8Pm+8uN4g/0rbfus14hySODmItUQ7x7pAIzoC2aLuFOiZJA?=
 =?us-ascii?Q?i+/9gVtfITQX3lm0748PmQxBMAPgh2hq2xcNnHFgpSKATYhy5CNmSqsnBfXU?=
 =?us-ascii?Q?zxSuSDWJpqYYJRGf4XTtRG3YZwb1fnxuPgGqzTOWxIolqzFXVip8kefOvJ97?=
 =?us-ascii?Q?qrCCABwprxqYIXjCcF0LdmgbyRTVqyu7Hj6CaFQQgUzEQlRN53sfBngz6XpI?=
 =?us-ascii?Q?P1NPB2FmkAl7ZJKNYPu1JvBb40F/FS/x/tRJuXvahiRcyBnpWWSWrDtdumvw?=
 =?us-ascii?Q?rOCvM/vIwoRJktjBIF6jRlS4z+hwjkv2LrsuX1X88TTEhev9NHmk2nPiRURj?=
 =?us-ascii?Q?8P3Da3gNYTbNRFAi942zEsxSM9yLR4nh/r++m2AxVVi/vkfGPllCmW9VQt0X?=
 =?us-ascii?Q?vNVnWalEnyUMmC9V7Eeae6FSLVWOqyL//LHbxoCbImvFn7cctAbzkYtrJWmK?=
 =?us-ascii?Q?ob3hog9xV+/FgmqeZsWfa2I4REk0kXYyh8cEOmVU4bFbEw4Rgj2K7RfPsDgr?=
 =?us-ascii?Q?97SUvjk73pECNuzxGECY2pvbfC/tt977C5iB9/lFoVyVBwg2+6RzQZqVW8qw?=
 =?us-ascii?Q?cIXpQQrKjMbZ8swMOi3OQIhLWiVo/wOr7rGZBkFcRvr6KsUQyykhHfnBDwkz?=
 =?us-ascii?Q?mNB2dH/7U3jzS6P3R2w4e7VQOl8hyoRn9ACDIQ0nt8hL5djknBuvZzBSCkXm?=
 =?us-ascii?Q?q3TJ8FlIsTBoiiOqDyrL1J3HGiLUA+/yYKxK/qBwQrqNpsPE51fKZJPfoAcG?=
 =?us-ascii?Q?+Eh/Kj3bEmyRUQsyraCP7ykZtSQRPK9DlCRhLZoxphGYEZAuC1dX+Lidn197?=
 =?us-ascii?Q?rzU6XTao08+aMgxO6EtQkalVzRncqAwnLQmSkYV6It2zhpkfC1CGlWtpIdSy?=
 =?us-ascii?Q?BFH25r4TDBwQHZPEovRj6Iu/1kJ0za7pduOMmzqcYGPCzdReMZKRlUX2uD5b?=
 =?us-ascii?Q?i03rsCAYRnARKmr2o3Ar++hotWa5Tab0xz4UH/0sI4GZhslRKvZpVChebLiZ?=
 =?us-ascii?Q?L6MYnlS29QCveXy1VDaKchGHb9ebu/oq5c+cnMLykj0l3FxA9DNMNriB4bAM?=
 =?us-ascii?Q?zzWE5mMQguNGXmB2xiJJ5op/e8VkwCV3A66eUYzge1WLPu2dLmo0BTTOpqli?=
 =?us-ascii?Q?lj/FIQ66p8gZyKBKrRpWSPZtwpAft/3UYF6vVtuCg3UjCDJmnbpqXlpxNfrs?=
 =?us-ascii?Q?4KOCWYZUcvIM86eMPPVIrhgeEZv6ZgwUi2DsNSijq9SD2ISx+Vm7eu1W5ldv?=
 =?us-ascii?Q?WGnD+NB1PK4tpAGYjU0aAddXl7a+9pPYg79MkjTtjPe7N11/ik00LObSJDU/?=
 =?us-ascii?Q?Q97Nn69iVxREdRouIet6/SeJn4q+ozHtASUXSjOJPKaysBtk0MvU57PyjUjW?=
 =?us-ascii?Q?VkBwIe5BeGRIaeP4UwLcpdfnByU7AgQ=3D?=
X-Exchange-RoutingPolicyChecked:
	QYEcdMJYMePvso3iNf1A16pR/V5WSV3bp6tk0Bnfafqdz4JypSEV/glo8obbF2+hxWdADBpAalLVTGmYRNFq8x126zKOSAX8vnioayITc1tNH5R2YaruUfxZ4ghzMOMmNiRrduZMnCWqEideJ8FIc8v0VsyLgU+tO4Cj+dkaPvegDGrBZwI4ciMkdyHD9cNHmS/u15B3oSaU/QbW5JmagX4zDFMAQht0ElYvJv7VEP+GbS3BQiu0XGQaFnel9fCT5+YpIUD8j79lKQW6O7Y/1IJM/ahntn+ZLT2u6VUDu9XvzhTLHIsRpTGE1sVM4tYQmo5D5YobDTLQ6Nz+yI8UPQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dNzDHsuWNo24T8j+m5+rI4rV7P6Hk84l+eOYRRsgEaBj/iJvRbwXdhKPugWqpQwYuu6k/mgwOr4SSzRsEW+2vT4XcYjzVDb7eWSBsurWuRxUqfL/o31L5Y4C+McwzJof9pQm0BDD036mRZ0sTOBfJKBjgwPZ6k/w4rCPAy0AUzJHwky7JXk5R05Ai8iBvvxSkQBTKHsGuAPzxaikT5bYIvbXD+1IbzUTgqV8K/SclsNLrfDGfP2pzQKiFrfPilv12ACcPf76PJSmTLLqhdmlRIOaN9CGaZk71hs9nzqMTnxiuAjIh+w3O1OgrDvFWqvkFA+Oem3pS5JRIAq/ueTgnYvPSVuI1eE9QtDsJr3MpmHbM6GWY2Yx55NiKIx3qs2+aTuGaErp24eC/0TSfSLdU1bQIpqR+NV3+EezRNwFb+0/F7RuCZR6QZ61vRstR4bKTq8oJp09kLXihYRymZ25UJ86esJ1W9gHaE1zxqDhM11AGpuGw64A+/HRS439wDVLsbFtcHJZqMNzWMtMYeh87gFd5vIgyqTazmwUxO3gRirMuAEykZb3wIgU/nTiEieuKOm5u1sp3j3pgVqc3Xv5Btq0Mfahq13LFAGujaOY1RI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8f4909-ab11-4624-7426-08dea516e237
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:23.9603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4IKAjOI8/zsUsU0w8yR3mdw+VaRbvFIeDdqrwutNo6ZF/kuBL0MjSl9dXHDbG8ZekQEhYFDegRG2Q9SOQIMxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX4w2xbsApmJmr
 V6DRia0Vj78kefyXDra+RVX1K7peKnB2lRb7Z14coH0vjVTFnSpDYL0koUWUMTjoBw0vjeS37/y
 I0Vsm3Y0/N/FQlcic+dIN8zUG6lAqTVvc1iy+frsdnzYP4Qugn8mPLK9OwkrYtk31/Kb4rIce8y
 jXP/iQH1jZRwkLs8eKed325RJH8oXsBr1ZiJgzVCXhWmg1yibwoXuL+cBKi+GYE7wQ2s79W48IR
 evlPP2asgYmCUDKxhMpWa6mGFSeRBO3KSJIesouz5/6rWXkNvNm2x7Y/qQjhCyuegdKZxvubqiE
 KScs+njHI9yOxR9d7ok7dxGIunsWBzGrxJNi+OUXH1OnPI0uCRaFlbPekmw3kY03Pi9G7uvcjhw
 ny8AxIV8KhUzquUfN9PMBr5ZylNhe5Kn+NQy0LF/m32bzkmjGqJZyrCzAQ49y3fcCIuft5e6FNX
 TVfbgDebuIKjYy6XhsQ==
X-Proofpoint-ORIG-GUID: 0u4NB0JyQhVFohoLx_oh28azzmbeBYWQ
X-Proofpoint-GUID: 0u4NB0JyQhVFohoLx_oh28azzmbeBYWQ
X-Authority-Analysis: v=2.4 cv=E7v9Y6dl c=1 sm=1 tr=0 ts=69f095e3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=NCbfIFLLqE_mmLRBXG4A:9

Add support to submit a bio per-path. In addition, for failover, add
support to requeue a failed bio.

NVMe has almost like-for-like equivalents here:
    - nvme_available_path() -> mpath_available_path()
    - nvme_requeue_work() -> mpath_requeue_work()
    - nvme_ns_head_submit_bio() -> mpath_bdev_submit_bio()

For failover, a driver may want to re-submit a bio, so add support to
clone a bio prior to submission.

A bio which is submitted to a per-path device has flag REQ_MPATH set,
same as what is done for NVMe with REQ_NVME_MPATH.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  18 +++++++
 lib/multipath.c           | 100 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 13d810148a96a..2a5a9236480f7 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -3,6 +3,7 @@
 #define _LIBMULTIPATH_H
 
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/srcu.h>
 
 extern const struct block_device_operations mpath_ops;
@@ -32,10 +33,12 @@ struct mpath_device {
 };
 
 struct mpath_head_template {
+	bool (*available_path)(struct mpath_device *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	int (*get_nr_active)(struct mpath_device *);
 	enum mpath_iopolicy_e (*get_iopolicy)(struct mpath_head *);
+	struct bio *(*clone_bio)(struct bio *);
 	const struct attribute_group **device_groups;
 };
 
@@ -48,6 +51,10 @@ struct mpath_head {
 
 	struct kref		ref;
 
+	struct bio_list		requeue_list; /* list for requeing bio */
+	spinlock_t		requeue_lock;
+	struct work_struct	requeue_work; /* work struct for requeue */
+
 	void			*drvdata;
 	unsigned long		flags;
 	struct gendisk		*disk;
@@ -58,6 +65,13 @@ struct mpath_head {
 	struct mpath_device __rcu		*current_path[];
 };
 
+#define REQ_MPATH		REQ_DRV
+
+static inline bool is_mpath_request(struct request *req)
+{
+	return req->cmd_flags & REQ_MPATH;
+}
+
 static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
 {
 	return dev_get_drvdata(dev);
@@ -100,4 +114,8 @@ static inline bool mpath_qd_iopolicy(struct mpath_iopolicy *mpath_iopolicy)
 	return mpath_read_iopolicy(mpath_iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
+{
+	kblockd_schedule_work(&mpath_head->requeue_work);
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index fa211420b72c3..eabf1347d9acc 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -5,6 +5,7 @@
  */
 #include <linux/module.h>
 #include <linux/multipath.h>
+#include <trace/events/block.h>
 
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head);
 
@@ -39,7 +40,6 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
 }
 EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
 
-
 void mpath_synchronize(struct mpath_head *mpath_head)
 {
 	synchronize_srcu(&mpath_head->srcu);
@@ -226,7 +226,6 @@ static struct mpath_device *mpath_numa_path(struct mpath_head *mpath_head)
 	return mpath_device;
 }
 
-__maybe_unused
 static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 {
 	enum mpath_iopolicy_e iopolicy =
@@ -242,6 +241,73 @@ static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
 	}
 }
 
+static bool mpath_available_path(struct mpath_head *mpath_head)
+{
+	struct mpath_device *mpath_device;
+
+	if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
+		return false;
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (mpath_head->mpdt->available_path(mpath_device))
+			return true;
+	}
+
+	return false;
+}
+
+static void mpath_bdev_submit_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct device *dev = mpath_head->parent;
+	struct mpath_device *mpath_device;
+	int srcu_idx;
+
+	/*
+	 * The mpath_devuce might be going away and the bio might be moved to a
+	 * different queue in failover, so we need to use the bio_split
+	 * pool from the original queue to allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+
+	if (likely(mpath_device)) {
+		if (mpath_head->mpdt->clone_bio) {
+			struct bio *orig = bio;
+
+			bio = mpath_head->mpdt->clone_bio(bio);
+			if (!bio) {
+				bio_io_error(orig);
+				goto out;
+			}
+		}
+		trace_block_bio_remap(bio, disk_devt(mpath_device->disk),
+				      bio->bi_iter.bi_sector);
+		bio_set_dev(bio, mpath_device->disk->part0);
+		bio->bi_opf |= REQ_MPATH;
+
+		submit_bio_noacct(bio);
+	} else if (mpath_available_path(mpath_head)) {
+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
+
+		spin_lock_irq(&mpath_head->requeue_lock);
+		bio_list_add(&mpath_head->requeue_list, bio);
+		spin_unlock_irq(&mpath_head->requeue_lock);
+	} else {
+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
+
+		bio_io_error(bio);
+	}
+
+out:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+
 static void mpath_free_head(struct kref *ref)
 {
 	struct mpath_head *mpath_head =
@@ -283,6 +349,7 @@ const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
+	.submit_bio	= mpath_bdev_submit_bio,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
@@ -300,11 +367,34 @@ static void multipath_partition_scan_work(struct work_struct *work)
 	mutex_unlock(&mpath_head->disk->open_mutex);
 }
 
+static void mpath_requeue_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+	    container_of(work, struct mpath_head, requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_head->requeue_lock);
+	next = bio_list_get(&mpath_head->requeue_list);
+	spin_unlock_irq(&mpath_head->requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
 		struct gendisk *disk = mpath_head->disk;
 
+		/*
+		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
+		 * to allow multipath to fail all I/O.
+		 */
+		mpath_schedule_requeue_work(mpath_head);
+
 		mpath_synchronize(mpath_head);
 		del_gendisk(disk);
 	}
@@ -317,6 +407,8 @@ void mpath_put_disk(struct mpath_head *mpath_head)
 		return;
 
 	/* make sure all pending bios are cleaned up */
+	kblockd_schedule_work(&mpath_head->requeue_work);
+	flush_work(&mpath_head->requeue_work);
 	flush_work(&mpath_head->partition_scan_work);
 	put_disk(mpath_head->disk);
 }
@@ -369,6 +461,7 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 	mutex_unlock(&mpath_head->lock);
 
 	mpath_synchronize(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
@@ -387,6 +480,9 @@ struct mpath_head *mpath_alloc_head(void)
 
 	INIT_WORK(&mpath_head->partition_scan_work,
 		multipath_partition_scan_work);
+	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
+	spin_lock_init(&mpath_head->requeue_lock);
+	bio_list_init(&mpath_head->requeue_list);
 
 	ret = init_srcu_struct(&mpath_head->srcu);
 	if (ret) {
-- 
2.43.5

