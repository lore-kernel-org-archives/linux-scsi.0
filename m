Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC34779BE;
	Wed, 29 Jul 2026 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329536; cv=fail; b=tr2aPBVWmtY5Ywc0ddQqQFE/RV0HYA8Jy8/9rUPKMlw9/B/WUGxhhH48O948nv/w3n6QE0QKvl3ErL2zA6PVPIa6R8zXbs+12KZ5hOCGKe2iuwQco2SIKEUv0E9y5HGe1qIIQ6z228JuiKfrPN0OdyhXyfl/yKsckykRmcUlUMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329536; c=relaxed/simple;
	bh=Q0JavoMf1Y1cjXpzXno8drfwS+BMHhQ1zOF6ZAMPY/0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JynrP9Qp72/g9N8nV7kVhNaZO+yLTJgiNSJg3OyBWp6PQK0ctuK3A2nUhW/d9OE7iMq2je5HLBMt9KCOswDfzeCLhDpoMkjeYBpfU4/SndHO84d2A7oLRCvhuqRHaKxzXu97yPcH9eLbVPs4rSIiv+2k4dvUhtrk9alOwTKbU7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GC/qLteS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jjnKnis7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GC/qLteS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jjnKnis7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T96mOY2091613;
	Wed, 29 Jul 2026 12:52:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=skcFTlBmqV3Wr0tBAVVdW+k3YdaAk+sA9E4Dwvnimds=; b=
	GC/qLteSADG7mbXCOD/nnet5+JDWAASPO4bnMj+/iuPAdkb2Tt76/xthtUpEFChN
	gHDIEfmy9I6dT4mVYDA30nPkh8SceMZ5MOX1DCiS8+XRB2LaeQm46TFOsjY/4gM8
	UwzWfZLUmgU8Wqx81E0vv+e2fZVl893b7n3V24nD4BFBeTpMgSWqiGjlL+BDey0x
	dhj1xCkxWG6gp/T/L+rbeAvuxvStkqpo9q6RxdNmZiNDok1aV0DZTwjgL44Lb0LL
	PKRgWXjDqFX/rmDKH2YauC8Bj7pB/MSHAlmwxME3BK8qEnFl4KjS4R6M9OuC9SJj
	Y8sIVyYcZSoWFivBpdB0RA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyydx8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 12:52:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TCnvCn034044;
	Wed, 29 Jul 2026 12:52:07 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012048.outbound.protection.outlook.com [52.101.48.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekvrmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 12:52:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bIRC0t/OpSw0b7oe1FStCK5Ud3g3l2RsDYjlHLCl1QcydNee3uXvjS1bwDES7g5J5uxHc1yax/LYnjG9eqGj+/nRpreGQ2b3N+uUmws8huZ6G+gn/iRdzDrepGMqP1GtGkeyYt/rqW1ypJ044UjS0RUr5Bad4b80aguagXrpuME0MlHTwLqBz86eRO5QGLQlwtgx1Ye7zbqk/wqL1tY4C2decpChp+zoXJIX7+HaPvAOCwCE/9tMd8Nj0Kg0NzBZ6ajR6frqkDcdvNGxovk9g1wfkHgAmoOVl/79ap36h6H9IKaK7cOqyUPW1aJ18w7Aqm3hvRD6dKtS5qDYmmSQKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skcFTlBmqV3Wr0tBAVVdW+k3YdaAk+sA9E4Dwvnimds=;
 b=G+7Y3UuOkWtq/x8gio1CBtr5B69c0v5eiYXTayVBlZ9XffBWV5ykyb5tN0XDEQN37FjCwz0RBvm513/L4bxM+y7taNUnwN70RCFq9fUPrqAEw+yn1en7l7uCUpuKtoFpOteSqFSYvQ+Ey1G5EXAk5XIro7lSwWVQS8BjN0Lz4x//HgZlHDTbeML6O6pi9miZDFmCRsMQFVr4dQktmQ5sR2bWNPn5NWBZI9Jqz82h2DONCFJlSWNgCXGkC3HgSTEnxJpK9d8qooA+zP5OO88WcBpVkKHSfGW42ySQDzzveIlnIgGjFyr6NkWLu0GEqHkWOcWZ5tBS3Ue5Pn7pf4k2BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skcFTlBmqV3Wr0tBAVVdW+k3YdaAk+sA9E4Dwvnimds=;
 b=jjnKnis7YZiqFWHJjmF/SkaLhop7Bmn6LICcwz4bVxaGHE/WPUkIofDRbMl6ZtaQJ3aLPpm4TGJgTPiseM71NIkQM2BFcX/+PwCeQVYfQqdBQCA0NhBLwqBE7oeKs+FYA+v2X6rT+B3rc7MA6yqRyXf/MLVhaoFFLttC7cLDsEI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BL3PR10MB6211.namprd10.prod.outlook.com (2603:10b6:208:3bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 12:52:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 12:52:03 +0000
Message-ID: <fd1f7b4f-5457-44d8-9e84-821de78d6803@oracle.com>
Date: Wed, 29 Jul 2026 13:51:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/27] libmultipath: Add sysfs helpers
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-8-john.g.garry@oracle.com>
 <20260729122808.874581F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729122808.874581F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0089.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BL3PR10MB6211:EE_
X-MS-Office365-Filtering-Correlation-Id: a4cdc0b4-395e-41f8-149f-08deed702f91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10063799003|6133799003|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UjEur7jhHCTvVkpKQd1WBL7eWzhlZ2eIZY14F0NMp+x+Zv3F2uJquzpzrMTfcgxhex85mQpR2x5XnarkBEYb4iKY/VeGAjJoagfb7M5pXbwHCPP7ttA4AVXOv2Ze2xpBRsOzj8jaxgWL25nP3iwUyKz71B3zVS4wGZ4hQOf2uI0iKW0oykKpYjmLWHQ5ID7u1+x0wJo1wk21M4X7D6ihMSrwFDtFn7KouLMrV0//I27FfGeTRNl5OJ9TMJCPH4qCCGL1oC2pbb23zsadw9CiTgLZgf1ztH9ugtkgC8iIuuKdOCsNiZrBjvqDI2/1q4UgNmSn0oyq7ydbEF+7/HtIYBeutl0bBAshmJPyuzRBCipsLgEG1QLsoU65qYUeA5u12tz/n+um8qxyFcRSAOCEeKUvJljxtIWOsP49n8N28F1cnnafUg7V7vmeclfsVGRvb4MIV8rLrcYm2olvyhYOeG6y6lMXCEbRdb+yb2deUeGelRw7co5mXxIFzfKE1vVYWUlJyUkgAJDAdeNnO4VBQsXEo/Zsr3VNW7a0L1K8PIiNWcyske9m8/cVZanCuZwRbvuVpYW8ezphTDZ94dklIwroIz/Hq9Xb5oSASiMXJCKD/RlZnVb4IdA3Nig8+cj7ZYwj8LnXSaZa1q7Z5ZsCJfCN+bowYDSOTImRbGX3cBU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10063799003)(6133799003)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1QyS2E5aTNDVFhCM0Y2clZpMHBDYk0ycXdLTXZweElTRmc4OTZ2cXo5UXZt?=
 =?utf-8?B?RUJxUkFBeGNrVTM0MDdrcytwem1IQkdpSE9kY2FiMlV2RkY3NTVIUnpHckpl?=
 =?utf-8?B?RmFrckFQRDJldFBmUGxjRnZCZFRkVDRLQkZYcU5iOUV4WWozRVc0WlBKWFA0?=
 =?utf-8?B?dTY4VTJadzlFU3JXWkpxbHB4SFUrNVFIQm5hZWQ3dFVYVmJhR2JiRDBvcjAz?=
 =?utf-8?B?MkxMTnNxSk92RU1JeWZxZGdPVlgwNmNFelppZDMzc1hHcHRZdldsQnl2TXl2?=
 =?utf-8?B?eDEyMkJxTExnTDNPdWdCVnVkVVpTb0tYYUx0ZHJ2RzY3ZVNBelAraUQrUHdI?=
 =?utf-8?B?aEhnZDBtSjBYM0lyUHRLYjBTTzJEdmVGQ0pKLzQzNDZJMVNNR2VPNzJFV0tw?=
 =?utf-8?B?UW5jSW9GaHk4T3lMWnkvRXVZMktBY3NCbk56eFNXbE84ckFqZVhuOCtBS3R5?=
 =?utf-8?B?WTRlajMrMlVYODNNQXJYQ0g3dW5qcUdaNlJ4Z3lBM3pmV205TEpiSWtJTEd1?=
 =?utf-8?B?aHdYWEllMEExblg3aHExL0V2bTRjZ0oyeXhtR0hrdmNMRnNIRDZjeXZjUTNl?=
 =?utf-8?B?dzNMQlpWekNHdEt1cXBOTnRsTGJ6VlJYSlRvb2pCQUJDQ3FOVUl1WU1CdzVR?=
 =?utf-8?B?cDdKUmowTjZGQ2hZdmFuUXBwMzhXenlBTmtYQVlVUHRiUWJRNEV1ZEEzM3Jr?=
 =?utf-8?B?YjJUYjBGM1FFWUNiUy9BNnNWT2ZVNy9tSUhuSWU3T2I2bnJ4REtEVVlHYncx?=
 =?utf-8?B?dkZpczJyRGZEa3VZNExWWjk0bk4wdUowdkRkd1JRM2hRZ3dZODlsSGt5bUNv?=
 =?utf-8?B?c3dBMGpzY2l1VTQrL2dacUFaQkdUaFhJRWV6MUdhNVVHZlkyTy9XaTJjSkhP?=
 =?utf-8?B?NEtkOXl3NlJJVjVPdnQxVXIydWxEeFE5QzRJWTM5SUFZR3VERnJjbDhoOWZt?=
 =?utf-8?B?UW54WmhtdkJaVjZRVVF5VEtob2ZNd3NTSHdLVjU0MmQ2bU5qb3lNS25sNFZl?=
 =?utf-8?B?ZkNpK1RwMEZ5Mzk0ZzFuK3hVYnc3NkdPVlBIVEZRYURzUFh4Y2hHZzFwQ1Rs?=
 =?utf-8?B?TGduZVBiMVRZRm5Tb0JUZmozVmZDdTBJenFoWEtaVGRGaXJYY2E1dU5xV25T?=
 =?utf-8?B?dnJSbngvNVQ5WHlVc1lGQWN1TE1XTDhUckJrRWNaa05ZTDFwVkFJMTZIb216?=
 =?utf-8?B?alQxazhEVTM1cUkyMkU0eStJOWk4SkRLSE9FUW1UWURaNndXK05BR1RmU25R?=
 =?utf-8?B?c2xhcFljd1lxQlh3TjJvN0JqdklveDRaWDY0NFZNZC9DZGRxbDFkaVpDZmRK?=
 =?utf-8?B?NHQycVVVSFRPcm5XWFpDQlIzUGZoMFFLbU5FRmNLbitNejJlcjBZOUtjdStH?=
 =?utf-8?B?Tld0ZVJuWnVsaEtVdE5YTWYxZTQ2TU81djlDcDBCK3lHTmhXZTdqalYvRnha?=
 =?utf-8?B?NVlnNnJ5U0VaQURuSUdXY2V1djhUTEpqejBCQU9vQk5lbHNwTS9VREJTR0VU?=
 =?utf-8?B?cE5xYythdWJHWDNHYTJlbWh0OXRJeEZKek45MzcwdVdqUUNaOUg0QjlOR3Bw?=
 =?utf-8?B?b2F4S052WnBUZkp0blNmd2tqSko4b0Rha0JhbmVnTmcwSnZ1NVBLRkFRdVl5?=
 =?utf-8?B?L2l1MVd4Y1F6N3RUZmRYNnVvYVpFSHV3blhGeWZCcVlPNHVScjc5RDRNOTFt?=
 =?utf-8?B?Tk5zQmxQOW1oSWhuWFhLVzRrYmlpOGlrSkJ1TmVlVWZRRldwOFl6MUtMNXRx?=
 =?utf-8?B?Vk5MelNtMUxneEE4Q0hQTElQd2VHVU05SlJjUEtUSUNkWk80S3F5a1FJUW9r?=
 =?utf-8?B?MWhzZVdhbTVmelhYODlSb1VObUgxelV5OXczcG96dEE3Um82WlBHKzhPOEtO?=
 =?utf-8?B?SElLVDFxZ0xpSFI3eTVzcU5lcnlUUkg3RmVuSitYb05GR1hlVS9NRnlhWlNx?=
 =?utf-8?B?dXNRaGtoTnN1VjE0NWI4Z2N2RTNRcElvWUF6cWZXQktoWEdJY1ZETUk4YVc4?=
 =?utf-8?B?MVRYUU04cVVBN3RBMkFzWVJ4MllpRVhjTnNLR05veTlnQk03cWw5WHhoMGdK?=
 =?utf-8?B?aDExN21HcXJQTHV6TjM5ZFJ6dUlBK0lNN0lVbWJVVnNBVlBLUU84bmZ6YXFj?=
 =?utf-8?B?S21GSXlaR0ZpaWFzTjB0WUpSaWdzZmFjT3cyUExJU3FVbzdHNHk2U05Qa1My?=
 =?utf-8?B?OG9ibk5rNWNqTE51VnpXVktDQ2hYdlhoTEFhMVQxTUcyU3BadXFSS2hCeUpK?=
 =?utf-8?B?Q1RDY2RaeGpudEVyRC9mblg4UmYrbER6ZWJoekJ0c0dOSmVVNGJFRVozMDZK?=
 =?utf-8?B?Y0wzQ2JLbEp3OWpRV29wVGM1RmJUMnJvbjcrcXBGbkI4KzJyUGpnMkFSc0N5?=
 =?utf-8?Q?uIjLfaT74zCLqDRY=3D?=
X-Exchange-RoutingPolicyChecked:
	X89yaOi6Tc39RNboMpvVOnIM0A3KyLRvwK0+TkjvH2x3uaXd0mjAAeVxqnAGQGuhrCHmIGFZu5Yi9RU0qL4ZiHDeYigYYVkv+2933Yn6THUmCAuoH+OysLvFUSI+XNNRxOezbC1GxOA5Rfjb7Y4f/ufD6JRKtLLGyjv8oUQYI2T+RWIU+bLwuQaA2l0t9Kw7eD5bcT5uzLtmCMZ1VACyQXKjJWIpXnENLA2S5y0HCEXjuJApkvrzXNg7sSLhaO/5pMCaoZMJdx/Wp/TlrA565Gf7C+GxwLEkm+KVTjnqwJazjCARIJjPlpeaV9ZU0ZOYaqmP9zQWRJdIs+cK0OmK1Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0zuGsuqHrFqkpNsE3Ajpdo7fqYHBiWBn0JnyXoPwnYGva0KxQgfF/CU8cwZ2UOTG/RafSEtbCt3cS7d69bv341PF/1V/rUZPeUo6bANfP+L/NbJYZbwhEDXVad0KO1AZ7wqwzOH6u0arLBlmWDe5iNRB8AmXQs9lR8vHYRJgl7ykh1ZBniuSnACzH2mLMY3Mpad32WifgbNjud+ruQk9IQx4Fzbr6AZM3kJG6wls+Br/JLdo4R3WbWLPfmu0S+WQkUttjPE/BaCfXcdi1Kk6esMdTymcKHYi/dkoouUZDjSNPDfBP0UsSBe2kDo6fGZ8DZ9BqqXITFS7mwC6PhevHRJyRtSGJ4eE3uHGbBJmCdcn+PJ8Pfgmmkfcx0RQm9+5X+p1m/xAiKTA5C+t56zBVk5vR1WYFMRgxH+IAWxotz535pSmu738c1JprgDulM61LIjkdYXXNTodgQiolmYCjYJAdnOzqbyW/nrmLHAU9IkqxUEuq1YzljXZFTpmCML/T3jZV11gKKn2TM6LR+kW5UANbr9RRoirB9uhAP0+oBB5FO67puM5drWmQCa3cCSXjyK8LbnQTmaIcOg8jKbAkvCt7eIpj68JZQUvU9QuEQI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cdc0b4-395e-41f8-149f-08deed702f91
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 12:52:03.0324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiNVTU1xM97TS8t/TgnmBOPDQo/qNOg6y5V6TWFOs9ckwdrgGJdnqUtg88B+E5myavf+6Rk5n5YjfbmzmTjnPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290106
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEwNiBTYWx0ZWRfX+qgme66jf6Nd
 aTWJVdRFWqItgmLu7La7yNKIKLKP1KL0q8eL62xMWozIQFGCWae7r/fe9RclI678Gpy7V0a5ze0
 8enIZ1mXzmhkncBAGy7j5i45PK+NBVA+Vu+n0mx4lkeEaPDydDdM
X-Proofpoint-GUID: RF8QOEojHoxGEZNnh4qAkcgyzu58YfjT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEwNiBTYWx0ZWRfX6lwZXl3tATuO
 1sy4n/7XFcbKZ7L2T6yNSV/J52VogeQqHQPksI1OneOMxrkszJE/Wp/oEIcbHbcJtxXJBIPbYRi
 MaUNDoSIvgTsRSIyAhN3ZVCjkpQr0FXRSrzCSJLfIUObnTOEKSqWuq1I5auCvXcPXHB0AYRfR47
 972XCDMNgiOAUcz0ZxGSKSsweupUWx7lKpYK83B2iL5F2/Yu21YKi5l+mEcqsXrXMZoALyPETrt
 eY+k2+UUhRG8Af4AItCYF2wCFK9SqHDg7JYe4pCU6P+C583HpVoPGhfnmkOwTfKNxsjiY28Z81T
 sA8xSefEjoa+e1B7WNUSArwVJ2PIiSrRCJPLmEJphdWELapuVo1SFfqwbR+eJzG3oCsH6NuW5hS
 7UPMw5s+RUqO0pTs9MOxSQ6mALL/0LgLQM5vejZFgfKZRYCT3HRNRwdve3yh43Ak0UHQTaTAknE
 uw5BKmj5JEHg+7WJuqw==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a69f778 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=pcfBoJhvdCgKc5sL1nsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RF8QOEojHoxGEZNnh4qAkcgyzu58YfjT

On 29/07/2026 13:28, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The sysfs store helper `mpath_iopolicy_store` updates the `iopolicy` locklessly and without invalidating cached paths, creating a TOCTOU race on concurrent writes and leaving the system operating on stale paths.
> - [Medium] Inconsistent evaluation of `iopolicy` in `__mpath_find_path` due to reading the state inside the device loop.
> --
> 
> --- Patch [7]: [PATCH v6 07/27] libmultipath: Add sysfs helpers ---
> commit ceaf280cc3938326ee64a5bab20fde5b9a603a83
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add sysfs helpers
> 
> This commit adds helper functions for driver sysfs code to get/set the
> iopolicy, show device paths per NUMA node, and manage multipath attribute
> groups.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index fada92bf9754c..58eb9be5bebbe 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -620,6 +620,100 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
> 
> [ ... ]
> 
>> +static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
>> +		int new)
>> +{
>> +	int old = READ_ONCE(*iopolicy);
>> +
>> +	if (old == new)
>> +		return;
>> +
>> +	WRITE_ONCE(*iopolicy, new);
> 
> [Severity: High]
> Since kernfs does not serialize store callbacks, can this lockless
> read-compare-update sequence lead to TOCTOU races on concurrent writes?
> 
> If multiple threads execute this simultaneously, could they both read the
> same old state, overwrite it, and emit inconsistent logs?

Don't call it concurrently then

> 
> Additionally, does this policy update need a way to invalidate the cached
> paths? Because this helper only updates the policy and has no reference to
> mpath_head, it doesn't invalidate mpath_head->current_path.
> 
> Will the new policy continue using the stale path cached by the old policy?
> 
>> +
>> +	pr_info("iopolicy changed from %s to %s\n",
>> +		mpath_iopolicy_names[old],
>> +		mpath_iopolicy_names[new]);
>> +}
> 
> [Severity: Medium]
> Does introducing this concurrent sysfs update expose a TOCTOU race in
> __mpath_find_path()?
> 
> If __mpath_find_path() iterates over devices and reads the IO policy on each
> iteration via mpath_read_iopolicy(mpath_head):
> 
> 	if (mpath_device->numa_node != NUMA_NO_NODE &&
> 	    (mpath_read_iopolicy(mpath_head) ==
> 		MPATH_IOPOLICY_NUMA))
> 		distance = node_distance(node,
> 				mpath_device->numa_node);
> 	else
> 		distance = LOCAL_DISTANCE;
> 
> Could a concurrent change here transition the policy mid-loop, causing the
> function to mix incompatible node_distance metrics with LOCAL_DISTANCE and
> potentially corrupting the minimum-finding logic?
> 
> Should the policy be read exactly once before the loop?
> 

So we choose not the best/appropiate path once - it won't make a difference

