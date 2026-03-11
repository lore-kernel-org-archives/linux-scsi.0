Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1615E36CDE2;
	Wed, 11 Mar 2026 01:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773192753; cv=fail; b=H4YsOcDhp+8hFHhv2s/J6VhqyxLKr8xzhDP1S3p4llURCCQC9tHWJIjQ0wGbna0dBZzWZruCnPW9vWZ4KBro7zH/FCcfE7ifl18m6YU6Q/mhrCsrLVlUzw4m4/xYYtlkAf7G99ZuN06K4yZjGyTNY/5AMpxg85Z6RjX+LxyESxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773192753; c=relaxed/simple;
	bh=47/k+i3zxmZVds5+FLRP3mD8N41iVJnaHSh0zz9dHD4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NyLq45MOxD6ugnxDDxInZrp2qa2Gg0WzqCRD2LJQ0Ij4OiA1k7VS8XDSf15LvRsWlRcdFTTZszA04G78KmSECHVSmopjsFyuFXuvADiL6PpBo5bSBcV+s6mR/mhKMcgTFNXC6hsKSw6oHvLC1IvEg87U8EQW0K+FORXerhttgj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MQJaltrc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m/7VKSbZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MQJaltrc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m/7VKSbZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIN6KF2344356;
	Wed, 11 Mar 2026 01:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6/00A8PVj14ZbVKDaE
	NaRweV8zs2o54+Cf8vziZmvi8=; b=MQJaltrcQTLR+yIucTQB+ZwTx7LS50rt8a
	4Pq1NHc9eZthUuQ7u4A7KeohR/9b3NuYZ2MbouGY2fSzQOaItH0M8zRl42jO34w/
	naNE7H/spM7OOdpTctMEzompCTUBs9n/oCxgPZj27ek0HfA+/k8N1/E1Dw7dyMIu
	GiLA2hPDbHKrmIYoB3+1W4ZE37PrSmkpVtocA/I43rLmvnCPYBrX9qrTnxvf0/Jl
	wCCD0SFfqS2ANA6AkcL5toMVvnKDQu14oXY/4SpEjrHaDbELIhxNxklNAu12tLN5
	5tgCQik2l/3Ff4f16jTg0BaDSnKj9lMzvr27XPDsVrttXtWnVkHQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csks2m3uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 01:32:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AMg4Gs012925;
	Wed, 11 Mar 2026 01:32:29 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffe3x7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 01:32:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6atIvHfjNwypZ9Lxrj4N0iYefOiK5e6eT1A+R+R2JZIrcABPh4ZvUIW3CueTabNyBZozxx3gQx9X9tckDi8Fk+CKy/D6xXaAGaRtGEZZfE7TAeoDwSccw9k6H7jG34dJHKUBO9EaZsOJiRIi+yKVjw3C94YdyzB+V3v5KFHqyybJqVNzpNrsVU4ScFTQu42Tz6er4AGfYsPWvTW0tlLJR7+yA40b/3q/RQzr3WRAK+41ChRuWyPnl3l72uQvwmnO5W17bfl0HkfJ721lXdKCt+bZdCYG2U8MN9LpHvuDd3cpgVAsm+xxgVy+hH7aVkO1c04/Yp1uoznBsulan/Oxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/00A8PVj14ZbVKDaENaRweV8zs2o54+Cf8vziZmvi8=;
 b=tbZ7+Q/Gb6QQoIjmPrydQbhl7uOB3nO0pZjCBh0f9DmceZKUcmouQukjv0aTKLWMJ+fRpI+MeaMVDPV/k/nG23DAj66JHgJi8bub0UERmMkhRSHTU5ufanwqqJuqQNwfvECLt50Rb/ofFDz8YFA0bMRIvHl3LgdNo58ARwz+nl4wHEx+ryjXh7gxysDstbUDQRvw1b5sXMm4nXqrqCmsCxJvRTi0Q3CbRS/fyAMa7HdSg2rrOSGGNPmXpgeNL4fYV2XDYMF5U8Ia+QiUJh99TxQKZDxaIYkmwaNwEGPCQEBKYiDvCGCLfdnKxvlmWaLosNmh6ktAHn6RkBUyhebx2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/00A8PVj14ZbVKDaENaRweV8zs2o54+Cf8vziZmvi8=;
 b=m/7VKSbZ7ZB+ELm7XKMdX281bU+NquFn7kG4tkeX685lo5YWYnNa7oVL3P53lbyBVbm7i2eBlF6F7WG50TvmkB1GoHbjZ/CmS8oegAoYHwvjG3Kzn853/nxaEoQny1LFMBWUZZM+sMxGoSUgj4oJ6pZYL2tLIIJmhX1XgXJEUH8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPF350708D76.namprd10.prod.outlook.com (2603:10b6:518:1::794) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.22; Wed, 11 Mar
 2026 01:32:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 01:32:26 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: target: Fix complete_type use
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260307220630.131008-1-michael.christie@oracle.com> (Mike
	Christie's message of "Sat, 7 Mar 2026 16:06:30 -0600")
Organization: Oracle Corporation
Message-ID: <yq1v7f3talj.fsf@ca-mkp.ca.oracle.com>
References: <20260307220630.131008-1-michael.christie@oracle.com>
Date: Tue, 10 Mar 2026 21:32:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::23) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPF350708D76:EE_
X-MS-Office365-Filtering-Correlation-Id: b182b75e-3378-48a9-25b1-08de7f0e0d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	WJB1lIYdJJPuLZnMsTyBD330fSZKHgKogdrLOX5hj4fsfhQYWXwUzP8FW6+57ZkByuyEC6Cg0Z7TvvJHFdzVblFt7TzxE/9cwBtBn5mSjRLuZvqcVn8W0wYsr7Vf1PZMWfuhCi0YN3Z3dNcesWScTcbeRVmnuRfJSdffbIy87lczsr2RdW7oqb69r6vJ5NahkH+17ykONnDveVzaUT4Po6+d0aymFYOqLJYFNNcfdttsXJDTrhHFczkcytDpRXPXKj5ZPRQ58fnn+P9cqVmaSkls3gqRJoMClfz3o/LZQy6YY3yhVXMIvuIS78BDBDEXt0FNslbg7hpCyY0/NvH4FSyGh+wtyKKpXq1aiqn/p5FYZv0AQJi4gbLeOTJSkhwYbwaoAkSXH+F/E1vaNfIJTNIERDwQbp+XmUH06ayfeoQwAyiil9KDhlETxiSZPHkcQqjC12SPoZn5hlWCKahVD9WnZZrt2meNxvHG53f1YVASl88H3oThzl/l8Yjp7eSOZWsxROrZHpqfS2a1x6fpTip1A2FLjlvUswDDxM/q9CDHfggJWBR3MX947Rk47CPyjaq+E28aE6/uwcXpEsSnmihTON/sSwOv5m3YQQRjw0JnkF6PeEd7j8T0do8zqQfZTYtzLijsgfpXqZvaL5S9WWDWfUFY2WFfmzjt8KXV1OH37J7GfsSbUboslXYFvjff+VwMHRBl1jsGvspFphfd1C01RGIj0330Tx+hiSrDfWw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fiSWorzbQvgkchFAv5OU+EngDNwrcb3eg+fZW/FTU5KkmFDaUqoHiPexCPqW?=
 =?us-ascii?Q?LwB9iDsVw+wgoiGf0l/B24strNKyVDD9v6YL7XyWMMl6X/NChP1IMBrNlWsy?=
 =?us-ascii?Q?PNyXcSfFiKAMcVn7LHKVNU8g02cPRxXJ/DPG9ZX+Q/nQFm4RSW8AFMXB1Odf?=
 =?us-ascii?Q?KX9s5PNvRE3/p3je+qvyNA6AmxMW+pfvs7MtV8X7QaLMVKs4BNpTnOq0h2xe?=
 =?us-ascii?Q?9h1emnr80QThgImctTFC1lpwW3CwlEMUZUx0YtP+A1P/b3MPY0UEt8AHF7iU?=
 =?us-ascii?Q?USdxtWHhFknGM4RfUOyfrXlCgGE2tPAOfXJJ0OUK0J02U92IBzYZ2Y/iTwsH?=
 =?us-ascii?Q?SUAKg8Z1Ek3W9ddbT0FdJU/WI1W8+ae0DXglfNfeZLn8hHACYneplfRmiTD4?=
 =?us-ascii?Q?fpZp3sMsfZSoeFm/lg0qCwBJykghys+VNBjwkTI1L5zeWossN3KfUTKXHb6I?=
 =?us-ascii?Q?g9AoG2F8/YVlTAYqv+3bYR+YJumgbdYUKSXsfdbgYAK9cyqjcYQ4Pl7pqXuU?=
 =?us-ascii?Q?f26Bx7htcjFuSPlveGN7jZjQPRA51NdcaSY+ws8SSRJuLkfmR7k/P47X9ySh?=
 =?us-ascii?Q?LbfMjZf/wuEZMfpZe9hbUK/R658pVmTyfqWvwFFSvXfLnpAtFT2TUWVJ9MGd?=
 =?us-ascii?Q?ZIqvZD6x+5HjrsunGnHdOIP/z2Ua5UZ0cC76PrZOwvqgiDZeJWB+lNBNJPxV?=
 =?us-ascii?Q?jlO7fpxavdOt8cwzpWbj3DsWzgxKYvVBvuSQjywpT7tmsoVZjj+WU92uXE3q?=
 =?us-ascii?Q?rf+WCB5EQWf2G4CpOZxqx3UH3OnHa4mpsM0FJnIWJGMae4LyG60WMTzAwdBS?=
 =?us-ascii?Q?tVT8W6QOQI/i+8sOUXrsTqZmDGwmffHStCzBxgMze9N0qLEjDZ0Qo+eJvnMq?=
 =?us-ascii?Q?83FIucLzgZ+SHuBADCHbMlbGkLEhjuqr59kcvv18XoNRUVoyScldXtmmksFI?=
 =?us-ascii?Q?FRcMr4XryxE/8UA4Bt3GRMxqeHXvF2uWiSBnLZpl7lQfcvgPLR4/HJ2pmoGu?=
 =?us-ascii?Q?NoFJLTohb+rJl6eot1XgJJzRw47x4shA9t6Bzkx19KIYjP6la1n/q+G5t/Nf?=
 =?us-ascii?Q?sERDZ8rAtA9qt1h7m7ESBC9ecO3406I1sr9gYjgcRPwauYAlv6xzt+JKPKrl?=
 =?us-ascii?Q?rZOetjYHdePogVfh2xcBUGjL8Q6C3TiYk18xUYVh4J02tnGAddmwut7bTUS0?=
 =?us-ascii?Q?pE/V/UMcw2bxH6/1edaXKbz2xNyQryCg1jrGG669XdgID3+d2s6WYY2JMRWp?=
 =?us-ascii?Q?gclVvtZtpks1v0EmnpCajxtSNX61PB/hwCPXY8YmSPR6yfbAFD9aiQWx5VCI?=
 =?us-ascii?Q?rUZ0aabCW7DXCKgRg3BnuhREvv70+HGvqQhFGp+5oUW/Tr7NhfHzLKbxMfTT?=
 =?us-ascii?Q?v+lNXlt2LTyf0mvf/zyPef7FrlUI9jBtqHmcu908YTmqLpDXn8bSF0Bs149H?=
 =?us-ascii?Q?SZdco78DxWmRDV4MPpnVF8N/H8xyWOHgO0/zuEjSq8b/97tfETaM3ldCT+0f?=
 =?us-ascii?Q?0AQaSabroMZkUJt8iMFgyrKAZowIBhat6H2WGkFWoEt5S219tSECBmdh4fUU?=
 =?us-ascii?Q?2WMNkWRzyiYBdp19/ksrGSMhUDFtJp6jhuegyThcFtJx/nAYj1qWZFOqgGgB?=
 =?us-ascii?Q?tA3oBJalodPZ2OM/iBN1v1cm/MbO/BMdTrHqjHEpUg8hGKwf0xwJOQo1l9u/?=
 =?us-ascii?Q?3m6EZKCeRPc/TIA9sEmwH+DDP24fJG0rOt+JZBClMO6Aw2W8mGF3PFxzQLkp?=
 =?us-ascii?Q?1TOXYIRNZtT7v988EUf+s9llP7vitbE=3D?=
X-Exchange-RoutingPolicyChecked:
	nSdo6OIFEBOGpaGJudCB9CQTpE2Ig0fnkBSO5YE2I1X033FRB8RPhRV9OIy4VZoIUCTOVvLwwAhEazjLfIpvfjQF4j0K+m3vWS9ZOn6hrq7roj1LnWUaqw2ebF1y/++bba/7YLVjjJRql17L8OSUVP6yZWtPJelI+q20jzDaxR9NCby4NwjMgvqd5pyaMBSaG/J72ZuA5hg3hWJNTSrR1zHFlA2IrW8xbpWH9vm0tHkkykN2IxsME94p5FjQbea+uGbtfirDXyPn3sA5p/UykKrhSB0HMTYO/qning8/d+T2ppfZQCVwP6HB9Xg5SFh0Al2EXJjd3pc+wYqvqnXa9Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMV36IrBfd6aV6wqgBUoEBF0DOKqdsd6qY3OevRcBlA1XyNhU5OyjQh67nBafw+qYsFmgftbVV/9niDm6iZ4QR3LqZ++bgdL9qWfquRtxJwQrJGIrQN9VIlT2ToOxOgfWM9q2JCBukNo7AGElT7HyLpuu+mWH1NTquyMs5bAltjPqqL7KAc82E1+Ckir1TcnpuYjrHmVmNszHcamSWdWwJXtoqjOFYYM90JlP9ALygSLyawz2ynIlnkDzatUYKXtaEO/v666zSgBNZdcrCslINLHPeXJr9L9OjMwKoa43C8CyqqvCWiwb9a1QjH/dIQa9rLxjaJXTFgzgNMyKIYVv5gx3KZpfjo3VpksZyklRyiqntUcHnLV5khsv+7LVAhhsDvDRocmNdQVPw4OW03Bz2siUr/8E0SOCkHKyv7GxUyvu7/f0cbO8fXR3sC6l7nNAyPlXHL352HMcCssipTQnyf12DZI0hNst7Hn7aWc9Qc/isQ7OQvn4E1pW45B0beKz8H2mcvlGV1UYu9190aOMp6v6mNMnznETxAQ9PpyDZf5wZ0gZafo9qE2hL5sySHp2PJoPqmlwRvGFLSGHFBAJwPDGTYZr5qZOFNlilx1kao=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b182b75e-3378-48a9-25b1-08de7f0e0d36
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 01:32:26.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ybri2gua0od1gcIJkv3qZ7zEcKRzhO/LRKJMLQSRf1nSx4KdlUXcIfxVDahz+NArG44jjYaFoTcMKN/G+G9STyi9IGZqHNJIitoBhPMbEOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF350708D76
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=966 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110010
X-Proofpoint-ORIG-GUID: SdURCHLrUXc_XUtsSY5bZeGLLcd29eil
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxMSBTYWx0ZWRfX/rufs1x+QsaR
 0xTzv2+pD7JOcGmlokNrVce+nGM1XldFN17cUaHd/FvLBdXBdVQ6rbylFEhz0/z9RKLS+I5BFhJ
 qI373djcdFKwFdLTeaY2Ph1kVBq9v6rSb/DIkw0aDhZSOeYIVv/jLEyBh8E7y4lOdB+PRblgkgr
 XG2sIxO6/gTUkPMosuqHoLuTUk3KnPPAGoknHZSBvxUV5MnpjZzGDhdV5r2xX+eOIXl7yWxMN4h
 Uy9qQiIWJtLYVY5pdEMkYeKkIo5U4PCNZxCMM8CV3AuZjG4w2XzCcYAFaykbf+0uGc9rPQHLHJi
 Y/wx80T+tvg6wLocwf1UM9kjYHKZ4RLyTCtz1O5d8QbpTVLmAjpHflcfk4ILFe3+UmfzWqas1Hy
 bnrQcFYwg2IHQiMYfIFdIrtrQXrhvKcFljEa3QFyOCc31gc9TUW1NPVWuWwv1TQHUCaGachwaOR
 ND1bdH8DXIOWKFr9j9hd9h+jq8aiSepwJwrvoxRs=
X-Authority-Analysis: v=2.4 cv=S4vUAYsP c=1 sm=1 tr=0 ts=69b0c62e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=anrGc2dYs3bqXeueZeAA:9 cc=ntf awl=host:13819
X-Proofpoint-GUID: SdURCHLrUXc_XUtsSY5bZeGLLcd29eil


Mike,

> There were two copy and paste type of errors where I swapped complete
> with submit names. This patch uses the correct variables and
> definitions.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
