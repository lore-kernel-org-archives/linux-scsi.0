Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A84435A85;
	Wed,  5 Aug 2026 11:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930251; cv=fail; b=pvbi4G06RPanP6YUamEai32EEJ09GDBUd5oX7zKqco43JEcXi2rZ2uIEzipQXmQgYtPcQErE+vUnH+Rvbgh0qY1QYQtby7NTUMWRNvefJXQr3HJeIV6aSOgkvqpi3Bws73oojlVstkVAn0XAC2s1Wx40Av9POiPM1d07003EgMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930251; c=relaxed/simple;
	bh=52TABTWIYJW3s/FVkPzi0iTxHx4F3lnip6NSb/LlHDk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PFbcAf7raQRCLG4boU+Qm4gXFItxfvO16iUMI1FvhbF8AyplA/kwE6TPXqk+JZv4jeMs0UedshB2mgWMujnn3UUsulk4hw9Numket/x/FoufoZ8hYWU+ZM1HNsOAXfFsQP0BXGEKOsGlZHESJ8btyGgjVHCF1b+k8IWZMIs+coY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oX/6Agwc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HmpAs1Qi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oX/6Agwc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HmpAs1Qi"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675AdA853110575;
	Wed, 5 Aug 2026 11:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s9Z0wJ0aMVJix/xEB98qPAUtiUt7o8RieNljSrctyF8=; b=
	oX/6AgwcssKpF7Z8Wuv8iXyDNZ0Pj55i0NVUQJlEgki0phtuqVSg2sEpYSR95q54
	mwPM2SA21XwYLgUoQl/t1G9Wnalc8130/dvwire0nEjtXoFz/Xni+esbSAb1HJL3
	nkLfGd+3bnqTjEJd1Vv55Q+wEF3NqROH49t8ytFJGBgSiaHqmLPcDnqyXsepOVI3
	RykKy6LclV7tA9thrcSPupcSAAMm+y/kmktiyQEemxCVn45Hacrjl0aZuGwnDIUB
	/HpbPnkFoKtcfB0e9Ll7QdPou+fq50pTN3q8BErvJdsS2lg/02kgpp26vk/xjvv2
	3xZvzHz8e4Sus0AIOlWGog==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e4yqqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Aug 2026 11:43:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 675BefvP007925;
	Wed, 5 Aug 2026 11:43:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78uebur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 05 Aug 2026 11:43:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FEfRdHa0e2CS+lZoJJFmNSRdr+lPOulm1kHq2oNfO5G/ZEZu6Xoain5iss94tf2PPPQIyiY0xGaZKz6N4gz0BowMyyVlXI2QfTjrYLK7GsQPTUDZpWRbHGvAnek72rdruY7OvsftZQLOtZcBydqvVVPevAd68DmfeM1xM2f+M02NGH7dxEUevi4C+DSLeBadLBvb9294g71nnpgPtX+3IroCvqOfwLz4eI0MAY7yVB+yd43caZUeM05gqOwCxXdGwM0QkI7FHW9aJkIEYbDorXlQyP6GRZGekm/Fe9C+nhVyNyruSDRfIqcawKYpt7OG38j/r1dw8SPayvJnV5oUDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9Z0wJ0aMVJix/xEB98qPAUtiUt7o8RieNljSrctyF8=;
 b=u72mLvL8UZKoGHXnCy+3rd8ju059yfB3+1GH4i98PNB2/fSQLetrGqdCcmxXunKhFf9FkjAQoM/jknYez5TedC/QzSoc+QrxUBPE6VjYViyGMcPX8XF3Um3Ozga5KoRx3jpSzRFPWYUrxFUqsIKTYqTGQPiP76zlu/Si45g4EjCnCQWhW/MMxoCXxHcSOiNQNKMRo6b/Cj5EI+rOpAsD5EriJjvoYRN9b7Qp++gtGzAvKvxGX4wZY/362QwnhlbEEuRzJhlb5rulUr6bLYm63XQ8QJ8uy1xGy+C75S95W9eNEEZ77nvXrOLQFINsXAMgVWPVKxDwmw48v7FMj3/lnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9Z0wJ0aMVJix/xEB98qPAUtiUt7o8RieNljSrctyF8=;
 b=HmpAs1Qi5RztbfxOqOe8WYqqerKwg3+jMvFHq8MPWPH5KGzucSLZKytofrAz3whcyZbCoVGnj9Trr+w3FZFZJXYSRe0niS4rROVsPZYR5FWTKd/ZJdCNM2pJI+19GGbvWh5iCLA/KDpI41x5Ro3Un6ZAZAfg3zfyz5e9iHqoqp4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BY5PR10MB4147.namprd10.prod.outlook.com (2603:10b6:a03:20e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 11:43:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Wed, 5 Aug 2026
 11:43:46 +0000
Message-ID: <9e4c4aab-81d2-4f5b-bbcf-087eb92feb6d@oracle.com>
Date: Wed, 5 Aug 2026 12:43:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] scsi: libsas: Support spinup notification for SAS
 devices
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260803020536.546544-1-yangxingui@huawei.com>
 <e34a40de-474c-4a3c-8013-726d473bc79c@oracle.com>
 <28879664-7e0f-60d5-caf7-60a1e2442d77@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <28879664-7e0f-60d5-caf7-60a1e2442d77@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0104.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5c::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BY5PR10MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: 5859e2eb-dc0d-4eb8-2fdb-08def2e6cec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|22082099003|18002099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	CM7Hjfj17ujTCQOU3bp3va/HdRB30AbndpYQcNxpjDLuuXm1OgK5nJOL2z848RoysE+rtTZpCx83efaSMXB2WkPcJdLTlJgpB9FWjpBYhBWnstBd33TQnJ10P66XK+NlJLXIuvx7odpNBuJwu3t5YplZqX+BoGwSezZAO47+itAPGxyHnzcPC5WxgX48qoVTEEN0999UFouCFX9TdNUgCG6O6XcfR/W6ukcEceq3lfx2cEFZteldjnA6M2o3b3658zCISFAiKXwyC7aDRj1V2f3j83hrfd6pQPxjd4YWqnw6Eo6w83NUS6ClAj/WnzZ/0X3bDx4RfwfAR7acd/z2F763c8zZ6LvFNBchalz3Ssu16qCX66SswcgY0PQ1sTIP/xaUemIcveFVocXbyFHdiYo81FXMoao2njSF5FQjp1Zmk+r4VwMy2pjhjVchyOULkenIb1Cro76M5QjwZcnAFrBBcvNOsmpaN8U/7yC0kFzGhoNZuoc83VGcZ0jKAuwJ9U5qfQiRzeNSs7yvavdzHcOlymQDcVwfl9prR7bzIAvxGJf/MeFwvaH9Eo7EemDJSTbFJU024it8FqFT1/6v/zCgxke1uhFiRnD0MbP2g/v+f+DVMeymu4VfnKJ3ofK5NJac7qPUMeMmZ3LT97zKkNzJpUZHfju0YtGZOKfEXNQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(22082099003)(18002099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnN5TXBzTXpCT2RLQk9qRmdwbGExRDNDckl0VE9oaG1pZmh1c2l6cWZiYmxx?=
 =?utf-8?B?MElQa0J6dkYxeHhZS0tlRWU0NTdTQjZKSng0ckgxVjg4OUpoSUNENFRaaWp1?=
 =?utf-8?B?RDNvamozRFkzU2pQMm1yVmlXMW9qVVpZZ1JpbTFHSHVPYkFxR2JTbXdZdzhz?=
 =?utf-8?B?RHlJM3FDeTBjOUxZZ3hoaUI3YjVDNDgrc2FaZHRlOTN2UDl0WE1VSE83UjBC?=
 =?utf-8?B?b1Z5WDA0N3VGd3pqOFZWTGQxMGJNVmlhbjZTYzRrVUdxNVU2ZWRqSUJkTTRH?=
 =?utf-8?B?dkYrbEN6eWtxTDc3S0VpSE5KNmhuclZKaU5IZDVsVEI3UXFEQTZSL2k0NGtp?=
 =?utf-8?B?TkFOSkdydG1pNDdVWTRZemVQd2NQbEloNzlRSnZacEo0Ukk4RVA4SVZqVjdT?=
 =?utf-8?B?c0Y2N290SWRXeTl0cG9vNTZyTUphaGo4K1VUNDlDbWdzOGVwQkJCVExLWko4?=
 =?utf-8?B?UFdpa2IrNFovZWxyVXhVR2dpZmRsL21JV3I4cVlnbXZCSUxmYVlzWFgwb0dD?=
 =?utf-8?B?c3pacTVJbCtoT3huc3JBNXNDWm1yU0x1ekc1bXduUEI2Z2dkZUNocmFUQkVm?=
 =?utf-8?B?UnF5V2F5WVZmWHkrSVpBUE9vODZ6OVppM0pjMllnVHFCamkyRkNra1FIM2Rm?=
 =?utf-8?B?UXBTQkROdkxVMlRyUGp4YlJPbEtUUmZscDJpZkFUSlZvOUs2eU96MWhBV25K?=
 =?utf-8?B?dnNoQUJLUEh6UkxhY2JNRDZVMFZ4Y1czOHkxdzdwTjR6ZHd6eTE1T25ZKzJX?=
 =?utf-8?B?M0d1K1JYbjZncGVpbnMxWmRzckh3MFEvemF3b2ZLRjZiSHZkNVBreFRVMlRH?=
 =?utf-8?B?MnRYRU5XbHNZSlhxVzMzZ3QwTHhub2JhNHVzTm4rTkZmTU1VMTg3MDNGN2x4?=
 =?utf-8?B?Q3A0eEZCSnJpTTlLbXZ5cFB1a0x5c0ZYYk9xdXJFdDNwQ1c5dG41Y28rWDFT?=
 =?utf-8?B?d1hBSzVGaGxEMTNnSGI3VzlqY0xMZ0dTNXRlODNTU0o5U3ZSZXN3aFRUZU53?=
 =?utf-8?B?b0ZHL3M2a1ZQK2lQcVR4NTlUT0lnRGtDazBkT0Z4TlNxVHNoMmF0TjlBVFdK?=
 =?utf-8?B?cFFVUHZiQ0EyOU9UVWtnbnU4Z2g5a1NnQkxFOWlGU05PSXRnM1QwU2p5NVJr?=
 =?utf-8?B?TEJHWkMxemdCbTN2czdnOFloaEdqcXhuNFppdExjTEgzcTV2b2dPM0tWVGoz?=
 =?utf-8?B?clBLeThNSkdIMFl0eDFNS0NDUFM4QVBTeXdTSDZwSko3YkNTUTAyNWd4bVUr?=
 =?utf-8?B?NlZtTzNZVnE5Z2E4SE5RRmR6a3drK1UxcUZmWFJvVFY3MTFFSDd6RHJxaURp?=
 =?utf-8?B?WlpQWkhkSTQ4V2lkZHhwOCtsdGVoMSsyQ1pHdUs5eW8razU2Z1JHZ29TTXVy?=
 =?utf-8?B?MDJHMHpaTmM2QnJaSk1CaUhqZC8vb0g3WklSdjF1SG1FeHg4eXAzYkZxb3h1?=
 =?utf-8?B?K3AxOTJwQVI5OEU1QXArSENKQ1FRSkJybEFIWEpudGtiVGQ0OHVUb0dJc0ZK?=
 =?utf-8?B?eXlUUm4wb1BMd1lIbDRkUXVYWE5FbTR0MGM4UitxZkFLV3M3cTZjNjJ0ODND?=
 =?utf-8?B?SVJUKzQ0dUdDQk1IY3dDYWFRWjhrendMYkJHUXJKQ3lDRHdVK2pMY3dDeVRD?=
 =?utf-8?B?L1NFVEEvZ0F6NkdaVEc1YThJZkhzaGtHYnIxZk4vVHZVNU40VURLZzIyNWdE?=
 =?utf-8?B?YndOUG93NjRTSTRORXArMWtLTFpWUmRvcCt1RTZzdS9GNkt3cmgxc2U1aFp6?=
 =?utf-8?B?ZUV3RndaUVdHM1VmUW0vbFN5dkRsam9Fb0ZVcnFwUXdoTmNKdTNkVitnTHVm?=
 =?utf-8?B?Tk5HWVA2WHZwVUZNK0s4a3BsMzZRYmdVa2ZDTnozVXNQNi9ybys4TWtZZ1dF?=
 =?utf-8?B?aG5NcEJyaE5qb1Z0WnphcHJNQXVjM1BDdS9ZOFZselRNQ0pkWFlqS3VZUEcv?=
 =?utf-8?B?NzRjbWFnOHVSTTU1cUtoY2I5ZmQrakNZMW1KVEdvRHhocGtvNWs4SS9lWWtD?=
 =?utf-8?B?N1FMUkJzQ3FIQkR2RXZkNlZ5NGxLaUVwb2UySGRDKzNrbW93S0d3T2hNVGtZ?=
 =?utf-8?B?OHZmM2pPY2VKMmk1WjhqWnhOR2VBdmdtMHl0cXcvYlgvMkpoZGQ3Z2ZwcThO?=
 =?utf-8?B?OEp5Y016UEFMRVdzcnVJUGkydytQS3pieG5rd2o1VGlIKzZHT2V2UUtYQXpa?=
 =?utf-8?B?MXM4VnV2cG5iTldEeUdVYmMydE45OFpFTS90UktmVXhvdGVVTHdzT3FUODFJ?=
 =?utf-8?B?azhPa1V3L1E3dkFBeGtZNkJ3Q05iS04wcWlxNFlkbmFmL0ZZanlDMXNKN21J?=
 =?utf-8?B?S21ZZ3dYY3dvdVI5RHl6LzAxRGdqMnkwb0s4WjBKd2Z0a3QzQlhVUT09?=
X-Exchange-RoutingPolicyChecked:
	T7X7yyXoCmOtEqHwCubWTzQJ+d5JqJgktZqBf3wg590/DFauT84jKoLJNS3ognNmUq2cvyu1otG43P2CDwzA2/MyJ5P1Ld5c0IHC5/HSUV4GTLMr+i5CuFFwmJaqu+tX3yXYRDv0mp7a5B9zBQlde0xpN4KyM3Zdm+JLKW0tiR432VH6J9zesBj8waGv0TMVY8vjzPNagcbrd1fj0Rpo6iOq7MZhXZHaZGlxNmsgo7HP+ZTh/83qA9h8zDoOjLzyaErweT0HiRSYPfjQ3RXFKQXX4mi0do2a+ZRNuN5bMmWJa0kTRjkfQVajSzQxPqSPOx7+ZLQizR6EER+rhllGKw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b2SJj3dyE2Zw3IyI6JXdkxhcSvCuik2sz+K7bIJu8NTIGzmRCq+HPjiQYkbKCyrlcRILiJOA3Bttoexv86QgBO6cRMKh9kGo3PqN5pjF/0ZdHbfo1n2jNjWNV1zrh0EbQqedWo8yBmcnnlZcU3ecea8sZFQwghMfT3ptZqRe/8cdwZ17ulwLkTvYr7/IX2yg0JgvP1XB+ly20KIJS+nTi41w1Pef4ahCtFIBd9iAvnVQMtWtmJGAGPrSf7CWifUC5MMRwX4Qkz08MTOyVz2ans4ZLUqaXf1XVP02mk9k8UXjl/nsc5XF0144eRc1jNWd9g2xh6GbzPGUM+4r4v9shHVuJoVzmq4r3jcuQTlqSi8SiDqALqnPrZ1i9JHQQ9xOvWkS0gPi4SwEFJnqJHkCjfaDA517ggeijbHAll9TbTzQAFZks15ojpGkrk5tlGgD5dGWXcu+TTw085QUTOOIPYJG/UmJLDfd7w3vim7w1tSUfM67dzzDtRsKzXh9Mf6Qi2/g+gL05jmt110LlG7wjFOuXO3Oi89Z5ZAKKTjawfaE55P/M/+w52uP8lPmoocQAqRSSLwvKuQYVh/EqAmD9/bDr9X0hq/0wRXLxJWy93A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5859e2eb-dc0d-4eb8-2fdb-08def2e6cec1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 11:43:46.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4Zldh0rhXO3KPvnb//FJsZdHnQIHE9+19uFjrK/Ap3/d4YPcSc5P6Xu/l3+UQZka4YlvJoUv6Wvrapm0rRQzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4147
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608050093
X-Proofpoint-ORIG-GUID: 5um7BHokw2hS8Bmw5ftRLQ-gXrquutEI
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA5NCBTYWx0ZWRfX0UAPjf425U25
 wClrDw15796UPqVYwb4kR3/aq41zfMHidoBdpcuaGiWppwbWzIReqBGKyMqzJzecmue/jpjrLoL
 0dkDpbu2F0oLd9yOxNsS7blhGuUVF4wIW7U5z5OA/Ub8mokrDTW5
X-Proofpoint-GUID: 5um7BHokw2hS8Bmw5ftRLQ-gXrquutEI
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a7321f6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=sWKEhP36mHoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22
 a=BUHHqgaoHvXrS9nulu0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA5NCBTYWx0ZWRfXyoXfGV2ypwgf
 DvFWLpqhARmXFKiVooI9kUz0tZGiZtKGoguQCVy8vGxUy51Ngz+UdAImWv5ODsPXYR2IYQmnkDk
 XeZZRkoQLo1WePFheTNhP18bBcL+8Ybq73b8wL4hYrbanzZ20K/ytFKcp7bTt/PKGJRZHewmbry
 yngzZJIKKzb86PqLwm6ZsKRcsMOCOQ/fVkNSEX4HO1sMWZxzSg6h92ttCLvhf0j9MdzJBo4zOC0
 ZHqAmDD/AYXLLOWa75dyZ0NAk/uvEyIK/LBqf7/sQpCHU3OoPtd5C2fc+oNrWaveS9BvTWK6CNn
 TTjVL4r9NjOvRWPhCzqDswi/MiTKtJ6x25nElnzrXP+MfyRL3j40kEqTW54Q82e3IQH6pc8qsiS
 fOmdVJVjJN5CK7vbLpeNuv5SKnuLCbEwDZRE6/xbXt/7Xpk1hXVPgAwjBDSOvlpy1UTTKS8uDNc
 UoSzWxSEA6lebUdcgR5aBz0WkatF8XTjA0MEUXsM=

On 04/08/2026 10:30, yangxingui wrote:
>>
>> How would other SAS HBAs which use libsas handle this scenario? Since 
>> they have FW, would the FW automatically issue this NOTIFY(ENABLE 
>> SPINUP)?
>>
>> I just wonder why hisi_sas seems to be only driver which would need this.
> 
> Thanks for the question. This affects only SAS HDDs. I checked pm8001, 
> isci, and aic94xx — all handle NOTIFY(ENABLE SPINUP) at the driver level:
> 
> - pm8001: sends once at phy-up, then mdelay(200) — comment: "delay a 
> moment to wait disk to spinup" — before notifying libsas.
> 
> - isci: enables hardware periodic insertion during link idle (ENABLE bit 
> in notify_enable_spinup_control), cleared at phy stop.
> 
> - aic94xx: enables microcode periodic insertion during link idle 
> (NOTIFY_TIMER_TIMEOUT = 500ms interval), stops at phy down.
> 
> hisi_sas also calls sl_notify_ssp() at phy-up, but the NOTIFY_EN bit is 
> held for only 1ms — msleep(1) between setting and clearing — before 
> immediately notifying libsas.
> 
> The root cause appears to be that 1ms is insufficient compared to 
> pm8001's 200ms. An alternative to hisi_sas would be to simply increase 
> the hold time in sl_notify_ssp() to match pm8001's approach, keeping the 
> fix within hisi_sas.
> 
> Would you prefer this simpler approach, or do you still see value in the 
> libsas-level sense detection and callback from hisi_sas? ^-^

I think that if you can resolve this in the LL driver then that would be 
better.
