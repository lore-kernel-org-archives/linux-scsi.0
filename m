Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66851B4223;
	Mon, 23 Mar 2026 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273873; cv=fail; b=OSPpJIXL3AXadrYC/sE+mwKmwDG++6ZdIA+Bh+YRJW8x4DjeN1+89snOpLKvGZSZtmlvh8yth4+sju1pGkMkjwgpcphkkZetQUP9f2Z9nHBBSqRnHSefKwNF02Od2l1cElUaVJLPbs5BLiOtpm9ikJMX3q9QbBzplGDRQcGzirk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273873; c=relaxed/simple;
	bh=WMqxqiEy91LqwZBJlAnT1ZUodzJPwJeFIpyoCVVHyX0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r8xJixdlYd29jfsBDceMDnYFd6amonI2EszgsA2ivkqQ77JvlTrK6DnBE5gB4EDOsy6kNFH2i75/UftPEoBbV1l+dj9UzCiVrzta64s/AVD52guLvuEMkP1lnnk858cyygu2ra8Yt3DKNk6OHFbtT3Hmpgh4i0SlWepepIWEfhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k5ns3SGg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TweuTgSO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k5ns3SGg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TweuTgSO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N1sRiG2283679;
	Mon, 23 Mar 2026 13:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8zSijlJOa+2kc8IevWW6PplXSv1Wq7+A7ZZgVwf4R+Y=; b=
	k5ns3SGgIJRHwRdHglYQtx8UcIqywaBTVly2ttDHYQXAZkhcZ4SzWI4ubBnk7sBQ
	UFTPflfKT7yrunE8Bn2FtUmODGeX9QfPJA9bubnHOr4CZ1e0lCjxXHjRsqrjvY0K
	g/6i9zbLjJc/hc+d52NsvA+OFd3HVGIzbW+KFZF4DCu6WL8oMEA7KknURQFJ5oA9
	63bSUKhIiBlkS9t167qcpbOLpBfbE4S7Y7oeYG80/JVVvW9r2I6pza048FBjV/QY
	gZbnxuTfWYKK+wk9fZzKPXFek3648qVLUIaLbLgRTei6+3FAAm06exfZksIvDnST
	HqQkGqMWi5N8EXPOC6D2Gg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kja2axw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:51:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NDb3uS000625;
	Mon, 23 Mar 2026 13:51:03 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8gmcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 13:51:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eleWMJj+D90foi+zL7V9eGjgENxdV7lFAOlcSSfzCOQ7+1Co7tU/vfEX83cJzfN+CgzaRoeEsqYbiDasBy3wJhKX1Eo+le445QHlPhbEUEc3FwX4s7Woc2Sgry0grln6+cvm8Rol16VX3c7vINhlITvEa82Wxke2MGUrj+qObBouj2ulSYs8qyMmKz3qpw/dH5KOCU5lqdUlSTitkcb2b0d4sCD1kCj8P4mFsvoRg/RuwiUUooHHMW09rhTnfXFdRIs7MwGRflKDQVIDwSMNy3ZYPThVXQAAsh47xlZXfCfzhv6GpnKtH5tKIg/IjLNzM4L34WdUqKX0jbWaUJTIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zSijlJOa+2kc8IevWW6PplXSv1Wq7+A7ZZgVwf4R+Y=;
 b=vB5Ps6pdN1w/djIXaRPG9qY/mD5Zt76wrebkHeO5YclWfhR1RqfmWoepm72KVx4sRIfqIft4TnR98t9FXtHI/wGCqSgPmeQqlLved9GpmSwc6+6AHF4AV8Dnx5ZPVe6et79U1ol3LwvIwdpYrD7aNQPejLCoK+lof5xpK3lo3wVtz4zgBXokUAGy15MDBMutujt1s77WC3WgLEE/esyPWOLIVrsiD8o27tpjvqQ8b9+JCG6cK9phD/TUlAN37/wzKnIB3hkMpqcjKxcW5kjwp97nUzZ9QGD+D015e9go9KRiS6Pwk6IFew7iZQZ5Rz8qMa9lESb3IGPEkMcE84Jq7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zSijlJOa+2kc8IevWW6PplXSv1Wq7+A7ZZgVwf4R+Y=;
 b=TweuTgSOybQmTwsfBT+q8vrcXmUOmXWklMLFkvvxsxwo8JfGbfIyO2bMQMWd5kEPCMaqrU1cqmwXcOqptrFkXVswvdCEPbO+QbybHSQy0R5oK6CAJ9fkXaC4CpApJBYqLXB+RdouSl9pPSUTJs9tlfhppyDIyjLFrmTEb8oGMlk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB997736.namprd10.prod.outlook.com
 (2603:10b6:806:4bd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 13:51:00 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 13:51:00 +0000
Message-ID: <ae8536ed-e597-494e-ac22-0d3da7433abc@oracle.com>
Date: Mon, 23 Mar 2026 13:50:56 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/13] scsi: alua: Add scsi_device_alua_implicit()
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-12-john.g.garry@oracle.com>
 <9d34285e-1230-40df-a7c0-d0efd9d4c495@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9d34285e-1230-40df-a7c0-d0efd9d4c495@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB997736:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cf725a-8ab3-40fb-032c-08de88e33798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xIKIyVEmG7HVvbCPiT2oZEEkRBiMyzgNRIwR+5WZb6ejMxu9sTl/vFpDaaoJq/RZuDdNjBCFZOEV6ooHN8eWAON6E4Gid/qsQV/vSwiNMjWsEZpWPMAGVbTfUge5Zp0iNEszj7zN31nx6Mc2Vw5wJWg6RmI2+mFaqHhs4DW2wc29ilnJ6+NNd+EnjWP8TyD/beo3iZ02u58908SzXeT6LbJxBVFsY0Xbv8vtHoT7bpMmg+y85ws7zAE9HksuxWdm6fk/Mj/RjT9WI+eFyjvNg6ifODYZ6nTLc+sSJG6rDHWsqQAf+UyPghhHFgeLkpP9zu/g/B6MGU4AIxTbTuzeYmWSR6MpCwBp/fF74YF7K33jygIkt9ANr/krZkJzG8OF/bMzlL1A6FzFmutBOhekBJbQySE1d2bptDVrjxhI8nNCv5xgnDP2L/fPaobzeXrVE4sYPImbrjziQ8MfbOGjNvHhngNX2BGM8FTmdCPAU5bG46csdIEONczDlhl4KRIMtjmhs5QqYsiLQDSZrKPAVknCzvOKhXZHe4KRBA9BWNX8x6OLJ/b2t1SxhuUUOh105gSo9I9csB+L14f8UT1sGkyXaKHLiFvfJoVnX7XUnEGRTb6adMgHOD9mhO9Z/fKsa8YkTACm+McBaswnosc2ETgTJoM2hzEuTImkQi/P6PtT2Kkqg5DQwaVWAmeK6DVa3i6RysVc/8+fviGDzifq6nq5dL1uo/nrgYDkP2l/TfE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHJHRjRwTzJJSHMxaEcrLytsY3pIV3VFYUJseDVFOHJyTDdJTi9jTUE2bWRJ?=
 =?utf-8?B?WGZkMDJZcW1Wd0JtSjlIOXdZODg5QTIzQ0QxRmZ5OGRldHU5Rms2ekU2aFhn?=
 =?utf-8?B?TTR0S0dhS0JwKytIRzA4ZXliODZxYk9EVEFxSjNsVnBvY0NnZnpFeUV4S2lJ?=
 =?utf-8?B?Vk1ycDZWekgycFc2eTk5dGNuNUlNNmpCTkI4alhZR0UyMEtOekcvMkhYcE54?=
 =?utf-8?B?d0hJdEZFakJMcXJZR09DOWNZT0EvY1ZCVHpTS2hmT2NuUzlldjE0Q20yZk1T?=
 =?utf-8?B?L080dUZ2UkIyZVhTUEljdkxjUzBoL1ZjdFprYUlIVjFQRGpSR3RBQlZLWG91?=
 =?utf-8?B?UG9PaDQrNFhwd2xLWjNEOHRmQ0ZLb0Zqci9vRDJaQ0VNcUJjT2x3R0EraDE2?=
 =?utf-8?B?Wnk0UWNKdi9HOCttZlA4UWRWVW1YMFMyNnR4Y0xhK01FYlpQRDgzK095eEpk?=
 =?utf-8?B?UVBCaDh5dFBJMlVGUVNucFVjeUlnT2pBamc2dFk3cU82b1JIbW15cmdTUTFu?=
 =?utf-8?B?bmttR1pVMHBXdlozazl1NmNCWnlQakpwWWZBTE1lSGp6T0ptUnNSK2JLKy9W?=
 =?utf-8?B?alVMTVUzRjJyc2tnUUE1M0tYRFdTbGl6NzJiNTc2L3V1aUpSOHZrdVJrTFBV?=
 =?utf-8?B?ejdGUDdVSndQL1o0TXRCcWdZQjNoWWZCbU5uZUZRWDRyN1F5TkZ1N0ltN1lt?=
 =?utf-8?B?cGFUMkJUdkxTbFR0cDhwTWNkeWVFSzVnT1ZsTEg2TmtGazhTSFRtcTlERll6?=
 =?utf-8?B?NHJmMDAwa2dHTHpxRmh3c0g4OE1ZOXNFOHJKazQzZWhzYUJabm5SYktMUWZo?=
 =?utf-8?B?eWZLRkppMFZqckNhM2ZFM29LY3RlZUNwYnY3UDd3UXhSbjNzalk2VzhFLzVT?=
 =?utf-8?B?U3hZbEdCblZERkZ3bkVaQ2ljTEJhMHBpYVdJOHJ4Q2Y5VHlRbGdoTy9iWHp5?=
 =?utf-8?B?bTlBeXZ5VHVPcXZqQjFUZFRKRjVJS3ladlNTVy9SbTRqWVE5eTAwMi96RjJi?=
 =?utf-8?B?czRpSnl2Qng4blRuWGIzR1NYcnhXU2ZnbEhScXpVcEgvelR1L3JCc1lhZVFx?=
 =?utf-8?B?SDBqQXNLYnVER3hUa29DcnJzT21DOVFoL25MSFBscERWTnV3dEljRE1NTVU5?=
 =?utf-8?B?ajZIc09ONUJzeThGSnV4aVJFeThXdFZrdXpPNWgwZ3BGQUhyckRlbEg0NFdo?=
 =?utf-8?B?Uk9XNy82Uzk0YWVDMGtUNGhSQ2JNU2ErVEJlK1NMOXBEZDhsWmpyekttY1RL?=
 =?utf-8?B?cFVXYnhvQUdUWThLOE9TODBkRTBleGgrOXljRFlZUWlybkZqRktVTmFVVDha?=
 =?utf-8?B?VFdwaFhZM25nRlZ4ZjRQQ0xJSkdqUVJCR3BZL1pjVHlQZGJWZFdaZHdiOW50?=
 =?utf-8?B?U2F4R3duZFNUWXZIUWdGWVlBdG5oZjJ0UGg1Rzlma29GVzBFS2dPd2NKUjVM?=
 =?utf-8?B?cjk1alcyWlNoL1FqcDdqaWtaS25Kc0VkT0tzbnRUbTdzUnJmWVN5MzNHbUM3?=
 =?utf-8?B?L290bkw1U1JzRjFiYnp6Szh0TDVQZEJIUnk2em54MWJBZE82SEVuekJId2t2?=
 =?utf-8?B?UHlHQkhtai9TUllIYVhzaGxtNzFoVllENC9CQ1A3RlpQZXRKOGx5ZDhEdXVv?=
 =?utf-8?B?SjlHL1VsRjB0VWVGQ2hWZFhROXVjUGtIalN1UGZNNkhEYStkV1pKcmc0VXg4?=
 =?utf-8?B?ZjlMdmdYWXlkRXpLMnZ0WmFRMTU2K1BYOGE5VWpTZDZsVVNOYUY3aUh1SnRa?=
 =?utf-8?B?NE1od1FKOTJubUNMajY5cU9VczE5cmhtZmpxRThzVmh6MGFBcGNDQUNFWVdy?=
 =?utf-8?B?YXJDN2tRZlJaVkRKSytNODI4Q3djRkFnUExCTUowR0lOOFF6dERDMG1kUjQ1?=
 =?utf-8?B?WHh3YVZNbHhVQVVLaDdiZnhqbzNvakhycE02ZkRzVS9IcjBDN3pTQjN5b0hn?=
 =?utf-8?B?S2hoRkFBOFIyZ2pJWk81YWkvdjlaaEpyTzlTL2l5SlZiVVJQZ0NCcXlLbHRo?=
 =?utf-8?B?Zmd1WFFnTXdJN0pCdlVOUnRUcDM0Z1JaZkJ4MzN6dmtkU293UDAwdXBqeE85?=
 =?utf-8?B?R1BmdzU4SUhEWHlqcmxQUzFFdkpzNXZnK0xUU3pmTStOcEFiUSt3SjRHSTZU?=
 =?utf-8?B?cXlZbXZlTDZIaHJ3ZzZaVHhQaWZrWE82Q09OUFRDTVcxODd0OGhOQThLSlVa?=
 =?utf-8?B?c3hxSHkydXZ2aEVIQ0FmZUNMQ244QjYyd2ZqRVl0VTBYak50eGd6ZGV0RkpL?=
 =?utf-8?B?UVVBQlluRGNJdURpSWpCM2hMUGMzUDRZcVBJY04vNTl1SDJWRTk5TmdmamZr?=
 =?utf-8?B?bWRrQXRON3R6QTlzVThnSFAvNkpsOWhxUWRBU3EzNHlGS1NRc21oN1pUYTg3?=
 =?utf-8?Q?lTngRIwT8BTbAfcg=3D?=
X-Exchange-RoutingPolicyChecked:
	Pjc2RTVS9jBYYubqQcboT/KwRPkDM9mamBzhID/NTh3UVzY3fcVNNxVb7dXxdUpJ2yYaeefSfmoIXgxYclwBEVzngZACfyj4J7qD/RamxbyND6HaAS1fvtv22GskS6koEAd82RXOlqU9s9NDxeHZo4e4RQljWDCMR3RUcrHy24FexE7oMVziIBvIBA8C6ECyQ3kzfsIl1SfrjtOlXAr3gekJHUH7/IhJdkapHMqZpWtF+JJPhAKyjHIxV6zBwK21UyOeDwMKgV6pQna+Elt+Jxg5Z1v2IYF5q8bVIfXBxG86PZu1BwAwhOtDWJTrc9+kZeYJZW68SaxOrY/Z4PMFdQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jNRXr/3WtCnEHDYgOJrHGhZuCfhvFtoPUqzYbllE9fmh+924eZrDvalzObjbZixsw/THEJ9iPDhGG3rzobbmh6kZcNtD2cJAJ0e8VBFT3+8tVMFEqmO5lyMRD+q/e9WB+0Sq9P9xtZcg8Mf7wwwIySYl1wh9CvuOIEvxdrVUEULboaFn+Ku6d1huqJLYxWBHGHQrVB8E3ggANynZML0v0+O8YLjJfeu0SRU7Tuh5XCKDCa6KtVvy0LstSDw2s/G9W+TC3QKUZf+2JbBCd8zRyJhleS1LTQJOhn+NZXArN1uXHgd5F8dHu62rBQvoacG2mzhINYxGSn7usLkMTwqdqHY4dnDVMmJ4wOe2cHwz2CCPIAjQCS1CM7cPfDubm9FXBjc2CYhreuHw4U7QyQumVajjHG/BLx9ni/ST04iJnW7urJrlca8g/V8aocS3ZWMOg1XB+Lb02XIfEDzjTa9Xtk9N3s8C8KL2HAuEWd494uiBAYT275DOo+nKf6i9Bc1KyGsC+loEW5tUt2G2EOKdGDXcTVYUBJnEfyKgqlJlK/NXwu6rNtOAWPnZ2hD3juh6gNc1hiMnoNDjwlQd565iLVNMssRfpvINN4X1Jd4Lg0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cf725a-8ab3-40fb-032c-08de88e33798
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 13:51:00.6166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L56kGg7oCSlVvggO0+x38Q+91erX7uw7VLbaCjeBFaRUVurKL8/tGBxH6mxn/zkn8/21mCbodIDhIsXN7SnKPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwNyBTYWx0ZWRfXxUyVkaLeiaDk
 RVwXj9j1q6o32GmNqtHi6o4beQ8NN6rxVZ1ExdCZZGhKQI2effFmNlykZvIub/JYOnc+VoVlK7M
 ffUgJ4MRbxCJR25R1Rlznsi/PmXEx3yJmgguj4ydp9/Nc5fS7fU18nrLpMXt0WPdHVZO0DsnLrr
 wJDNel2wV8OC+430TkEoqqiCGydoGMda3Y7zcmWL3wh2cr/XfDAtI3drZz2JdKucLdLg2mO/3JO
 /QDnjDV6lyoV3RaoapAsegUBPqnE0+0L0Q+KoMX5eEHkYI53+jI36M7ZGJKVoykVZ6YcQXLOht0
 P2Y6+ikCKFWWjn1QmV6wmkU4LGSOTy/hxdA62EZnvx/nUbdET/eC850ihJ/NYx6eltRjxzDbGoN
 tlDbOEyTynRUESC5BHSrJ7DL/SxFcZCeJSBZtkTEc4tGR9IO55iT+OfN7ZeVWgAomPcc3ZBAf4q
 S90LRm/LexJAQkELahQ==
X-Proofpoint-GUID: JohaerbnjEmgXVy9lhg6fRnGoLweXJR1
X-Authority-Analysis: v=2.4 cv=TPdIilla c=1 sm=1 tr=0 ts=69c14548 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=wwLkOf7oQXgFedlNtxAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: JohaerbnjEmgXVy9lhg6fRnGoLweXJR1

On 18/03/2026 08:02, Hannes Reinecke wrote:
>> +
>>   int scsi_alua_init(void);
>>   void scsi_exit_alua(void);
>>   #else //CONFIG_SCSI_ALUA
>> @@ -64,6 +66,10 @@ blk_status_t scsi_alua_prep_fn(struct scsi_device 
>> *sdev, struct request *req)
>>   {
>>       return BLK_STS_OK;
>>   }
>> +static inline bool scsi_device_alua_implicit(struct scsi_device *sdev)
>> +{
>> +    return false;
>> +}
>>   static inline int scsi_alua_sdev_init(struct scsi_device *sdev)
>>   {
>>       return 0;
> 
> Hmm. Can you fold it into the patch where it's actually called?
> It's getting hard to review without that.

Sure, this series is taking baby steps ..

Thanks,
John
