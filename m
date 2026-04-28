Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C3407588;
	Tue, 28 Apr 2026 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374733; cv=fail; b=LwPvrHPuXSr6rAyZFnKFpBHZNSnDHuJutejslG67rjvvhEXTUQaMjtq+VkhToCjvEGIIq2RVFWK0dbPmgWwgAdVYSkBmmZuk6s9x+olXTLb5zoxctdJCp2gJFn6EOC76nmQf8xkfGBI0WAT4ciOmlPP3BBQbrPgDm5ImgDYKeJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374733; c=relaxed/simple;
	bh=ZvL+ebxL6zHRLFgwfZ52a0Pcvn+ygMsc3D++Qil0PiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hIL9qT71fq6X3NYOzAnKYg/9DqCLu3RZhVgcCw1+AHaI1E+HyDeYvjqnj2TkkBWDN1AbkHa9INaIfpTfmBlko29/DwstTFvxTGwZYeMOD4EkhNlIrcFWWLkUKocZowf6/j8C7AydeJRYSwJ4R1kFVphgMr5HMhF4Qz+yr8Qr+ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QYiDbOPE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iSD5aGNh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QYiDbOPE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iSD5aGNh"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SASLeA3055306;
	Tue, 28 Apr 2026 11:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o2bzohmzWs35G1bLcemxkwopQNnYgftFu+fbc6tgD4k=; b=
	QYiDbOPEn3xmuUZSXjybeHDb7FYDACYfsMLJc2SP62vp9Q4hH/qPO21Br7qPfJ0v
	rAjloFzm/QjaIbwXLD0jEKuoucYQqwzgIXyo3wswphkO/QyfT9t0YqqJIUwJFM2w
	FTHeB5lpXU3UnM4CX+4VGUk0LFK9i7gYI/QN+iUDFcqY3RjtszJ90JDEdleKapQ5
	5O0i9WbyhAT/r+ohqz4TXZjolvTBqLIlrnTA4x80eCwbUgdxM8TLiGsQSuU8XL9y
	9/LE0aHFlAMeGq9QHaSUfZwcXXB9NOSLffEhQrH4A/PENnb5sKNB79QARZE9uY/1
	JscbBT30bOEGH9QutxWuJw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5ybrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2t2P033493;
	Tue, 28 Apr 2026 11:11:37 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cu2dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evT5ZA4sM7H7jI9kv1VKX9uQjPjlOhyj7cesGpUCzDJQErzPDbbw7LhdqC/rlIbaFf9Jm5sfUoj80Hqk4udEH4qAmSJQ5MzX4+LH/S6tY7uNaIPXT5cnOYoQyY9KQ9qOYNaAil2QSm2tItfnh9uP5AcUPsZGNy4ZZU/jhXwEX/HRyKsvzLOoATGxJU7fijdVS9/crx+nM7gLbChx+k1wT0As/bBFf3709+tyKR7C/7PCVNf011wtE0s28xQZ9Es+CmcVh3bc4/EXrJwEeq7KCt/itC6yJsLmobMxAmuKAg4Xvmav+JR71rvMRBjJViz+huePzWv+xefElb+RCvge3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2bzohmzWs35G1bLcemxkwopQNnYgftFu+fbc6tgD4k=;
 b=jzKvWEqZT6Ng1wazIDF3/X46t73+OvyHNlnlrkvbOn0HOCru2zNaATsj+rvbXJfGdRUn0FgcuKTrGO8m+44HMbK830c9FiUY8k4slZpCcaIVGpzm/bF15Fscdknc7HLzc3Fk4ihBnwPCC64FTDQSOAy99sg3mEZe3jpIHCKerDg/5lZp+fqaGEicr4xOg8x/d/saartNH3ArtZUNICSt4Rqcze+WneCVXPM594vNWP4bgDHY0ifPRAA5BEwomy/uwOkN+GsCKm5K5lF95F1iAXM5l71bGb5GRO3iD5MBQfmrygxQ4/XjQHxiPF9wrg4O0kcRTm0kghCNJinNWey7uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2bzohmzWs35G1bLcemxkwopQNnYgftFu+fbc6tgD4k=;
 b=iSD5aGNhrOgThxzrNhGH62JCVfZvOf7b/czNJfg7gZFpw2fMGW0Oehuuf1Yf011kF+xOHPo0804R9ncEVsCH2DNAO0TrNb0u25S60GJXMEQw91Ov/JZBxSr0bOhwNUKw3HdSZ329beBbsmIJGdGxoejtnOhXMH68bGraojIhYss=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:32 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 09/13] libmultipath: Add PR support
Date: Tue, 28 Apr 2026 11:11:01 +0000
Message-ID: <20260428111105.1778008-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0058.namprd17.prod.outlook.com
 (2603:10b6:510:325::7) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 25aad70d-f5ef-4660-f265-08dea516e778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aZ70VOLdhhahnEPHiMwWC91+fkkwBFcQpvQ8PooxY0fNO+AliPuc29tcDdEajKwYHEDS/+5otwbX+rcCRQUNP527B6cPj0tf1vcSdeZfizXCDUlM1Xcg/kI5ZgLjbLymHEh5tBOYh+mzP9hIgxGNQKKLDe4fVky2LWBJEEoVaY+c6ZYumZGy5pGjvjc6xeegHCXylA/O+vijIKT42IaLVkGq6FgRzlfUIAeIeiFciIZfJm6V2YGq9pCFn9wzYtDU8TUO0VwCIh8PY4d/YZalmTyKnZTuDsXcomBUsErE6Nis99AIfTHpGoWEgJ83ACvafot/vJhCFT245Txiv/vX08Hd475YQdhU5rqYdbpftNQrfeu8D0YfG5Hh4aqN8Q7cNqGvkwBKTnS5CWWDgp8AKUINfg7ctbtq5DC7kYO9mEImGqukro8DiJ+BqTtEDv73beR2G7bjmL4bdBBSJy8Lde+Da7NnvBBwKUQ01TwAnD04T1+jv6hIoTVIhfl5T+hrZG6rDowXjnbFGxFN1/m3zqvckEzONT8Z0QcCXJ4lB8xS3FsabQ6mWqt+xhIWIU3IZqF9A7FuK1SkbqwKWtIYbeNh22lQwlwLAjlz6Ib+AJjMpN4wJq9uCCUUnubG+wt82/M7h88UVXIaLypcon0iB3KRga3dLMV9zKyJCW1bvgtZeD+Rku6nTfGmbzVpLL+DUZej4sCABCdTujxm/Z2jIENCtar7gjgh+Duy77rlnyk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eRxF/7svV2uV0qyiGXczigEk06oM24Z4P0ddElT7GAx1cFTmJtgiHmbZATeD?=
 =?us-ascii?Q?KNhuULaOLHE9RsEhgRqaN0DBWRm7BkcV0+XvhEOTLi7sbw3LvHRrdXYYU2MH?=
 =?us-ascii?Q?6PUD4JY9oXfA4LzE/zxdRH1dZqeq8Io4MbMdwWUnY1SWxnwf/G/4JLxA0/Uj?=
 =?us-ascii?Q?jUiObQzCQADb+/NpzKlpCzodALe6LjL1sGsgTRzFfQTHRhkiE0zzWS90QphM?=
 =?us-ascii?Q?RC0RAuNeg5DFHktb69trsNDOXYt6sgBNf/XKB3OKGCypeqfMDGIhuPeEtdf0?=
 =?us-ascii?Q?3N7eVMS+hLCblGzGUaWe0coB/BRccoHqZyvuhAWJ5bCEjlrYLdRVwjAKIgEo?=
 =?us-ascii?Q?CXGtVBlTla9CYuWPNxciqJo5kHd0ns02+9pnqpEbbG+jqBrrxNMc69Zq0S3n?=
 =?us-ascii?Q?9QB4wbJty4IO/leYIZ4+Rk+aAUE0S/aBuGDZetS7+unqK/4GmzOfKhFKISKM?=
 =?us-ascii?Q?1tH4CPEGsMK417I5Ic+F+qx7exP3nEfev6MCquit48bduIjqcj2SnmK10a8d?=
 =?us-ascii?Q?gG17zF+GjQetJIBQRTtLaKDLkr9fo/gCInhSa1TarstnY9FiLRWg18zNrmGh?=
 =?us-ascii?Q?KoEDE3B03I7g+QTgtDhqs5YNEuNlMbWGrU1C6+bO7O5RsOZdPSuv5KHM3X6n?=
 =?us-ascii?Q?Rneq9FaSwVys0KnIC7xQovDRSIPS4Mv9kzuEt6D/3ZuDv9goCSYNvbBw8cOy?=
 =?us-ascii?Q?f+Xb5iv3N5J70ezPBpl9jd8Kb6aL4NK+Ga+9dOuN1XBYqT2RIea1SQd5NvAV?=
 =?us-ascii?Q?vdxJxhKv7PS6iscqHSybALQjLoAxfPkr7DMj+BfEQIFwAtPHwl3DNlEz0iRa?=
 =?us-ascii?Q?wNnDp9orGchN1I+kw+lqwOCT2GOtUf/yofXSrrWf5P0tbfVbWDMNYbFtfbmz?=
 =?us-ascii?Q?dzv5tja6QrA8GGk43r+27M0qnQpg4OUZuIiL7/47hzI66pc5bSnk/JeM/lwA?=
 =?us-ascii?Q?Oa2gWkjESK+jdgDqnLAkCmG5bj9i2De/1+RsmHXNIOeeJbuyaCFnXAP4e/et?=
 =?us-ascii?Q?I3NSoOWyAAftgk8ayaK9z5bC+7xuaCbRrpUshyW9ocTOGdLmWNCj3bmQ8q09?=
 =?us-ascii?Q?jG5jzLs0MkgwpB4m7vH92P+6k5NE+xYnKXYQ1nSo0YWpyWK7yWJchqOQlvn6?=
 =?us-ascii?Q?EYHHrGvFEwDjne41uOfTXnZqbQw1VFdwPHcmk1//OML+CXYgvpqDkCACasgs?=
 =?us-ascii?Q?lomFXe2CL7LGePYYol5b2gwfKO0PBlvWQhYsrjX7+3hTe7lr95e8/0EVfzwo?=
 =?us-ascii?Q?Ev1uW4sXkh2BFxo9mbautIApXu09ORstu+O0REgTkWmaMJaSVm7AaXEJ+T1N?=
 =?us-ascii?Q?f4NBU8bFq7w/VlZNbOMbYJv1mZD7TEZvp7+VYytqrFyQd2aKUWz7fHIpyDfq?=
 =?us-ascii?Q?OwRCel9yT/FoNxrkDFtSxjGghZYdf6LX3CThPXwcDIHUjosa4ieR4iSnvyr2?=
 =?us-ascii?Q?5gp91kHSjc6LFzg182XTBjAfngH/bCO9u+Zu3a6D2gAKaGaAK22U6FOo9uQ0?=
 =?us-ascii?Q?ukSVqUtnwEcwimmJThU6+WUqLHoSpcrH8nEpIRJSctRNaSBC8qHia3fm5SSD?=
 =?us-ascii?Q?PobyQ7pzwz8NEgRziH07GDtM03gur0o+1v6SwgzvGv9AgUV8DwTRk+SFz7J9?=
 =?us-ascii?Q?ny8/WkBGxiaefRgbJbneFpFi37vI4+22mEEQDP2/H97r+siszpppoxi4bCBY?=
 =?us-ascii?Q?1dGBW6rczXBcoBOi/LI9DddBb+RA29wVBbAlzAXwrSR2KmupyCFTO69J43JP?=
 =?us-ascii?Q?UoPApKZdQK33L//MCtxZ7bxO229tsf8=3D?=
X-Exchange-RoutingPolicyChecked:
	AZEQnq+22is/k+3YzhgFnXQv18pms7+M3hfu5luJHzafPICGz0WoM/5iXa6NtDRw7TJKSdvCfFF1m1fR7SpaSxQYIajX7FwcdLucMw1YTbL0vvm7dDnwGNXg7tc0Y/ESeKQQ8ZmbpJGyp46qpfYbdzQM8RM4vmYTWFvv2Jy3YWjWVPp3Eg9hUm0XaON0AdPAur82hcXhvBFzGNxbP664BBjYIRlZushKzZ7PW8wauMxZjEp1cmbyA6oDX3nBwUPYbXqU46yG1LUeJ2cywcn+3iNKWf9IsTQHKazRdEsMmvElXX5Nq6eMn85EMxMaaruM7gnaTiShGzgmFYHvsY5AUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	adcIz42J8kBFp8ZPq6jD6rbI6rpKzX8hg2mOuY6+60XTaJsOBWUXyF2v4AuymToqb/JL7irwsiP2qcLBOka/Eq+PASWlr8aJGugCzTXLaWPM9keFCxUgLLQguMIzHqPeuKtR5Si9XO0C+XbS60Sv3wIsfPNO9s3GchLbwp25ZMT3WgfbF+QIVMbElClbPm+92OoBmuVZxgp5R9fIomzaG+3AHfKye1Lm66XZ+osZ0N8xUJqnTUDhe27Gz9IP5Ve6d5JLHFgjRysXJLGukmIRH7SZAxnTd9qdA26FWq7pjdnWnHbaI2u2MlfUNfDLMd08oqkC0xdzesq0Sccxy+gSE20haiLLWGeaaGgY4XW1ms1xgADSno5uj3iRrEt7nnkDNIwTOKt56GRQam9IidB+myO7sGYBvHUiyr7lXaWjv57vYGB99cxV1Q78cBz1TuM9JhCG2IGLLuniRIj9Rq3X5WmKKSk0mDRLIkSeXuSrUVRhypQ78XbrQRmWGTC3ONpg9o14TLUoY+xQWHU/HJq05w8o4EXqRuDtn6vi8/zGstkqAj/O1HgjlS+4vClVQkLWeCGJMY3cvu1VTUFfQl1kuf3Og+Il6DymLW9kCFqzkqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25aad70d-f5ef-4660-f265-08dea516e778
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:32.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7d6STmijpgY5X3aN5J+k220o2pUdIfJ4QqICaRsDI6O5q4roZkbEKg6A9eavHXFyJZ5TRcB+g/lyhPans7nHlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f095ea cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=zSmYoRqB51LVswEeA60A:9
X-Proofpoint-GUID: 6cYKHBIOVLx4LRDzaK6Htwx7drQvSkrF
X-Proofpoint-ORIG-GUID: 6cYKHBIOVLx4LRDzaK6Htwx7drQvSkrF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX09LSZUE/sO4/
 IeG815C7QvudgXy3VRevehVvnY9Kf+H1Gx2xtE6S2ZOXm3Qh3Gdo8+AEyG3buRdIEJfuksCr3IZ
 lFs/2IRaFewIDQj7hhYIbLazu/B67RINSO3plX92IrZkSpQveZGc5IW5PRljkxaOb4u/ygooVwI
 oajrH6xVPq5+rBemcOAOwdqdtcji6ZScuEt11C4BwC+HL67WDKbC1SIWfUGxolRhMIQ4mdAPGC+
 NmqxDR3SdQevNUdqHD/IVKKPmBEqOzTDE+TCpJgjphiH5NoEOaOykCb+UePoQQoSBhsFsMxrxNJ
 UO2IJrLUHSYdfMQao4Uk7VdlJ+B/ZkE03qDl7PvhxrUFfg2SSIEicgs0b10ycyCu96wKlE/dtIg
 ZbD5qeYsvGaI1lD/rbcQr/St20jeYVI7iWa6LfRoB3G7KdQLP3KD771gI4FsUcseP769appftvD
 6tvTcnXhhopBC+rfQRw==

Add support for persistent reservations.

Effectively all that is done here is that a multipath version of pr_ops is
created which calls into the bdev fops callback for the mpath_device
selected.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |   1 +
 lib/multipath.c           | 182 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index b18491c1d077f..7464c94fbcc3e 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,6 +5,7 @@
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/cdev.h>
+#include <linux/pr.h>
 #include <linux/srcu.h>
 #include <linux/io_uring/cmd.h>
 
diff --git a/lib/multipath.c b/lib/multipath.c
index 680bb4f0ae237..d2270c70b9913 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -466,11 +466,193 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_pr_register(struct block_device *bdev, u64 old_key,
+			u64 new_key, unsigned int flags)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_register) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_register(mpath_device->disk->part0,
+				old_key, new_key, flags);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_reserve) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_reserve(mpath_device->disk->part0, key,
+				type, flags);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_release(struct block_device *bdev, u64 key,
+				enum pr_type type)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_release) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_release(mpath_device->disk->part0, key, type);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_preempt) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_preempt(mpath_device->disk->part0, old,
+				new, type, abort);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_clear(struct block_device *bdev, u64 key)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_clear) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_clear(mpath_device->disk->part0, key);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_read_keys) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_read_keys(mpath_device->disk->part0, keys_info);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_read_reservation) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_read_reservation(mpath_device->disk->part0,
+				resv);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static const struct pr_ops mpath_pr_ops = {
+	.pr_register	= mpath_pr_register,
+	.pr_reserve	= mpath_pr_reserve,
+	.pr_release	= mpath_pr_release,
+	.pr_preempt	= mpath_pr_preempt,
+	.pr_clear	= mpath_pr_clear,
+	.pr_read_keys	= mpath_pr_read_keys,
+	.pr_read_reservation = mpath_pr_read_reservation,
+};
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.5

