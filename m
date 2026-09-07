Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126D831280D;
	Mon,  7 Sep 2026 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799528; cv=fail; b=VPUMx9TAmEZ5r+y59iNv+/iez9AN9vw0bpYWQ8e+5d/xc0Z90DvDFx8g06EnmLD7MVxXYsHNuLgGD89YBZ2BT8S7EIAAGCid1NZ0Ca4ZL2lgxiE+kk5R46fU3sA+ODj99m4XOu3VC/g0oaDXbtuqiG3jyQ62nh/heHwSNru5570=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799528; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O9YhMVz1fzyQ91sXZOsCBIRYbKypGSuQ6kjILTEA++Fb3unPsTZKHsaI4Asdv/40VwaOKnXhfEGU4RWXwRjMVI2mAG9Zn6zepAFT+wgTPm8JMNCSWXLVVZVTuRXUCnxbB5sIJd12mgF4oUTDUqOJE9WZWh/2RwbF/bzinCXlyVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=f6UU5P1Z; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=j6cOW46N; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="f6UU5P1Z";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="j6cOW46N"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788799526; x=1820335526;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=f6UU5P1ZcKYfjzlNkAGmZR21MWlAds7e5f5YSDLlOVzaWv3v9MCU5SvM
   nj5K1C630QBmoOLT/p9iw9abKcyySxkN7YfRPm7jQsET9b3gNEp7M+uPT
   nh53PtyJEzpnR9k7ly6KsgjkBqqYZLVYj/kqsQTepvTIInCnl9x8H0i64
   HwaR/OKaC+AVFRdhZMZcibltqnxDXuvK7wFFGXwwZ/ebq7EV8lFAQLwej
   wzigKcqGxd1zHO0UGGpQ8zbT6LKtnBsU1aLVliHrAK980344hEOfeVnWw
   Wtj2/wVukx3cfIXUh29WwZL1zoD9p5J35VUvPdBvoUlKivy37iznxGwPo
   g==;
X-CSE-ConnectionGUID: smECWb8AQV6jDdksjrregg==
X-CSE-MsgGUID: AxvETbAiTjK2lOghvj+7pw==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="150926260"
Received: from mail-eastus2azon11011046.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.46])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 00:45:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oi/faODd2y72AsM4K+dz1kaEu2T1ScgKmUW2oxwPO9jMqgFL/vjtAJMxB4iYAE8B6PI5qKf6FHkh3Q/jPSpgDvCf1Esqos5rd9ol+Ru+jtdHNJRAIzgGvZCgrGfFHBWBUZfM2itoih9QwnmyI4v7HQK6R72Z0NM3t3SvmiO+sSUMJlGznW0jNyzM3OIXLSJF0d9ejUHefPVmhXLx3SlkAgLf27KZa3KzP8T1OEGnct9P5eJ3ZNtIBN9T+o3Kw9AWkkm58W4WzdA/KC8V146k5Z4RakO5ICCidlVkid7GKu37hnOUKVbqtFjlsbLqrvRva1DzmpwFb3uF2j0A6PsUvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=uFPxIbzjw+8ovEgxG9SwEtYgVc6U4K9piwPADYv8Z1o2Ite+sWdXT3yCthZSGXTZdR+5Ossv+rNkChsXS9Q5pAEbq7ktH8QdpcP2pQQ5dDVmuqE+lkwUVwe/U/wLeIQqEJeoWdEXU4U+YQpLA2/6OCK8FEu9d+a7Pk6xbHff8uSKm0Dg3podCo5gr6wKiq9AsvqgC4doZkSOjJEfonZ9+QUqVz+u58GvLB4BCCKCNusFnIyH/ylaOgGynUNizFF4NPcvAq5CvXxe4+aoHwyBDj0Gm3hzBgyoUzf5dwdQMCQ2wX7N9OaEg2hpSQpCTAuXzXrD/eYvHfjE06NToTb0Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=j6cOW46N/+sVeYkCiaivVDncKvKq7ipc0napqPNjHNWoFAZc7yufzslg0FEX1KA5oJpaCbi/F5yknx3aUyHxHSkcHnlGwVHYPlBmiCbDPv9XAoVEGKGkDuTzIYFqhd7HqhJmd42zCxNvTa6nHazw19+2RW8G3Gk8MvCVFal7cJk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by EA8PPFF1B08A684.namprd04.prod.outlook.com (2603:10b6:30f:fff5::895) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 16:45:21 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 16:45:20 +0000
Message-ID: <f76b87f6-92dd-4295-b81f-1dfddb00c33f@wdc.com>
Date: Mon, 7 Sep 2026 18:45:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 39/40] scsi: cleanup scsi_proto.h
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-40-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-40-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::17) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|EA8PPFF1B08A684:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c6988fa-d523-45a8-535d-08df0cff67b6
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|19092799006|7416014|376014|1800799024|4143699003|10067099003|22082099003|18002099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	N5f71Biy4nPQSnD/NGjNdQoQ7NA2oIbz38LvDiJnBPzLNp4qmkMyNNjnViouzSWyMFxWCAGbUchN5ksTpm3yPI++n/QYmYxACqXOClLghmzPRVG0e3coAZiUvEl4Fitb3MSMlK0erT4BWSwd9yqvMQq6W4+foOGhbha/WzGuur62ecu5k1EvpEZM0Gg9g7/OsckQVAc6MdcXwxDH37hpoz35pBy3qyFJh7+h78Oad+06atRRy7esiqfhV0WvqWivtmJhKx0VKIZ5RfU7cmTdUVM7sFO9iFfSNOWX2K1m5rySzgxlJAAxkbinQlP+o5VDiGQ8D46+uhruf7+/j+j4F8MBUxI5tA+Fvs1zAenptxSWKCkzlzUWiuR6Jz3XVpPNJoQfJncD19BBAfQ1aql3OoW1P865jgVLTc6h+pVmQbpr1Agv5H2aMVgaZcED6IaeLILIqg3IMbCRDAtqUgHmbgY9Mt4niyExlNHLyhNL9wVHU2LUGboUMIJuMIk8WORWCx/+jmB0E2424P81bUi1pa5bvRnf6Qz5G5YBFFjMFIYgKrwGVrMzWqbWmopz1WMxNV0iNI5f/CgNZJyXFxCj+bn9zKJSGCPeRDQod675CAf7yNPbSADBueUc4bZejv5HgYDtbq+fDWAGUvdjXN06hlni2HxS9SfeUAk+tmXkhlWczHxwngDuFgGVgotf7E9Bw01/HRsYrNrbowtRw1rFOg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(19092799006)(7416014)(376014)(1800799024)(4143699003)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3hwd2tCV29QbEZDM3V6MlVwam1SSVB3dWU4L1YwanZLMEhGMHZwZEtOYWNW?=
 =?utf-8?B?RmxQaHFpKzNaOGZBaFJoZUw4OW5tK3JwWFZxUC9WT1I0SVJSVGx0RitSQjJG?=
 =?utf-8?B?ZGFnam9VcjRLcHdDSUR4WUlSRHN4aW1JTUJOR3Q2bnduQTZmRVZYd25iRjJ5?=
 =?utf-8?B?NlhqOVJDQ0N2RVc4Y0c1ME5qOU5xRm9ZRmgweHRIMW1keDRkUlc4eWplcjln?=
 =?utf-8?B?UERkSkZITXBjUjVTVnVyRmlrWnhlY0pZSjBUMFFIZStOOXZmd3QrYWp4cGpr?=
 =?utf-8?B?NUYzbjVJNnRMUUFpOThqZzhNR3I4VWNsVVRpL0pUdmpydVZNczkzUFRvVm5L?=
 =?utf-8?B?cm5tSGtVeGdnY2YreFJrMEVJSzI1U2h3OVhDVmYyaGJyZU13SlovOUcxVDIz?=
 =?utf-8?B?a1BCRFBxdXI3UlN2NFBPNUxvcXRFblFBc0VjUUZOcU5EN256VXoxTjU5M3lE?=
 =?utf-8?B?TERTSzlodndBT3kwdFhzUUorNGtOVzE5QS8rejdiRklucUFmU1J2VFJZa21u?=
 =?utf-8?B?dmhIYzFpUGNlMjY0Zk5pMzNPMVl3OVpDaTFaSFk0d1NUc3U1VEVGQTdYSkR5?=
 =?utf-8?B?clRZWWxyUTNoYktGMEIvVWxJaE5RV1BycFNoKzBOa1QvRWxSc2lBdTcvNVNG?=
 =?utf-8?B?YnpGMlJKNGNEUlZ1dC9QNWltZmJwL0krKzh1QzVEZzhvVTF5TW1lZVp6MVZS?=
 =?utf-8?B?SmxhVlgzeEthTHh0dG1WbjdTbEtRUHRKWVA1TGwyczZHUTRHNjZXTlVLL2Vm?=
 =?utf-8?B?b1Rxenk4SzQvN044TC9oSEh2L2hBY1NxdndnL3c0NElJSFhyUFQrMlczTTBp?=
 =?utf-8?B?dUR3SUJtMVRleGVGRTN3aFViRFVZOWpkVDFRbit3eVR6aVNtV3lVcXVSemxI?=
 =?utf-8?B?NWFaNTVsTE9XNTlCa3dJK3J4UTRkM1NRbDV6N2R5d25SNGxoeVB0NTd0cHJl?=
 =?utf-8?B?N2dIbVN3RDVnclBZM1RRTnExSVlDRnoxSTQzSUlBVFJIMHVIYWNYN0YzL1E3?=
 =?utf-8?B?NkhLc0RGQ2NxUG55d3ROTWtFNGNhRDVvYmVyR0pKZWx2TWlURWo3Y3VFRVlt?=
 =?utf-8?B?WUNVQXNaVjJsMGpYM3pvNTVFVzBNdGpVMEQyVDMwNXp0eFJqMUh0Y2N4NVo5?=
 =?utf-8?B?N1pLbE51QWo5NmFHY2JrZ3ZtZGdFK25nN3ArR1crdUlvQVVFdmZMUFY5Mzg1?=
 =?utf-8?B?V05NV0ozeitEeks1UzFaaGVHNVBkSTRRcVFDR1JzMkt3TlJ4SDlkNFdMTDJ5?=
 =?utf-8?B?SWhLMndKVk11TEVuWmNGSFJ1WTZrbXNiU0FKMHlMWEQ2WHRjaEh2QjRrQWZt?=
 =?utf-8?B?L1RLSURqRG12MWtVZzIyUDkvSDRLcTBKL0l6RWNPMW5jOXc5c1N3OG1tODY3?=
 =?utf-8?B?QVFaR0FoRlpGSUlSNEJrYlRrMlA1L0N4RHE3Z0Y1cXdWdFBPUzFFNnMyQXBX?=
 =?utf-8?B?N0V6dXdPaW1wQ0gyTjNZaDd6QmRMbnZJUXlhMDJ4dEZVNHJyODhsQmxLai9y?=
 =?utf-8?B?QW5HMnllTm8zV09tRW5UVHVMQ2pMRzJrUUE1TE1Td2xUQ3RobUI5b2JVQnND?=
 =?utf-8?B?Zk8xSTlVWi9DbXN6M2g1cU1zWkVsd21uVmVZUEdGSXdsWFduSEZ3WGgvRWpS?=
 =?utf-8?B?UG9ZZGJ2VmU4ZFY0dVlvL0hWbWR5Z1FaMDhlSlloV3NkMVd5ckcrellHUFlw?=
 =?utf-8?B?aFBJZEIwOWZmUzNxSmM2UnRpdVJHNHhYdWZlUGNScFJ6RHZHR1hBV3U0aE4v?=
 =?utf-8?B?V04xYTNVWEZLazl4dVJoNTlJSU9qR09CYVIzZHozRmRjUFZmR04xZnJ5RzNZ?=
 =?utf-8?B?VHo1VGtzaVdHbUdXdXZKU2R4b2oxU3VkT1pIdXJLd2NpSUJKUDBIN1g1MTdq?=
 =?utf-8?B?aG1sZDNaRDV1QjFLVDFzM2Y4dHV4a1VHMWRpcWlyUEtFYkt4MEdVQ0hESmRi?=
 =?utf-8?B?bmRaK2I5V3RadmFxOGxVaWVZWUF2dVdzMEZrcWFDeXh2bXpISjFUVXNmM3h2?=
 =?utf-8?B?bi9IOUlqMk55aDhDbWV3andpWEEyVy8yV1c1NlloRzJMNlNzK0FuT0tJZ0VZ?=
 =?utf-8?B?OUt3d1RuMEZKSUZVbVUzbXhRdFNJamVjRExaV0JEbFROSkJORGJiVi9xVHpz?=
 =?utf-8?B?bUZLT0p4Zy9mRjVLOWMvR3d2UFRld3ZINGQrZ08xTk80bnQyL3QwMFlhQUF6?=
 =?utf-8?B?cm1QL28rSmxjRTRmYTFLYnQxL2NHc2NHVzByYlNzNXA3WjVwM3FjSW1aeVkw?=
 =?utf-8?B?a2VwWEJ4VGxYaEJVUzlPaW13Vi8yVElnMFlCd2d5QTkwMk9LT1IwcnUvRWFq?=
 =?utf-8?B?SkZGa1ovQmhxSmtuMEpXdlR2UVUyYVc2QlZrcXMrakt4RjVQMWtJeExpZVY1?=
 =?utf-8?Q?im9m0CHZLGw2ktU0=3D?=
X-Exchange-RoutingPolicyChecked:
	RcPKm2hIUQQcYceEL1d565wUMjwn2iAY+IjXmo4AwvZ+rR8bUOzYJH32SS/S1tQhkH7s6qp8Zw5oap6u86KA6cI5opztaR6k1S/HcbHyq6AOlYYRq58cAlX76anXiZ4i3XizQik4aJS8Ifod+J/aXteSN+Az4LSekTrjQUAZHqEoF5srrn8dWcyUYZxxp/z2mxKoFCvNliyt4sONSUc7KjKVptoPsUQOYWXXfUIv5xqumTe/MoJxmWeODKhge/Cs8siJ4QU+QCVk1Rg5miKb5ReXm0X2da9JFS8A6jK8+EEjHnK4Fw2JAOcu0Ikjk0O1oA9ZpRXvPQ65ue+qbFMXzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dZ90oNNG9zAaV9W5SjzAx1wrdSAaaDUhKiB/ZMuHOqsn8eiG/X7B0ZJpUhhdzvOI12NUlsMTbd9vRScPLpRxo3NrVXxzV2BM0gJ4DTp+kmK4vo0nMt8pHr/VrEWkVp47dLNDhtdcwMfkPNvuWLuxOpMLZRFGNlmrOqok4SsKs4bYvAJaASGtkhpkXbKtQ1U5zt07oJnOuFFZIVa0M9ZU8nnJBj6z3ZspdyqV9TIjMISaKXNEl56J5+3ynUxUmoqJSvCZGQeRsX4PUS/DVe/A2HQDIpyw8Skw/egeID2pMsdyyRv4W2SERAqcfA6zdRt5Lb0zwMJQWLr3P4C4pWDNBbuDMY9OwTs7PanlhOI4YkSt12h8bpdhzXPg7bwePsDaBPB7CXn4ZkR+m5nHnSl2bYCEj33nvMsFeFp/2vhEb4AVRHc+hSq9O2YXBYNwA+M4WvLc9CNi/+yS7kUtOQnIHLsze6VR3iTcZvvxZXAqQ4XJlOIBInFUDkY+VaC6uj3ofwXI9wKX8vdAIjCWHiPTfEbPtqUPaRvqPlgyEY5Fi94RClNUBRBo/hl5YKQIWSc2PVq7N0hIH2PWWS4m38yPrmiQlyrXbO60n+vww4/apamKLmFUXuHCw4bzyicoFC7u
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6988fa-d523-45a8-535d-08df0cff67b6
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 16:45:20.8302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tfbpmtFSK6IOiXm7qLRjHrRCXLcy4RYzW2aE6Uf9pBJJkCfs4DCOU7vJsQLc280dhk46wWDUvIQacPjBRfWVircbBMRTqOYIS2mGZrxzh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA8PPFF1B08A684

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

