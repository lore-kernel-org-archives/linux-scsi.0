Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACB4242910;
	Wed, 15 Jul 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784137060; cv=fail; b=tFUhoGh3At7wY6xV0A9V07UcumUp9DoZfVgMk944Nf7XTTYg35nNQyVjvY5QKrWrD1iwjbOzs/lO+zDEj/De1NnhH8HmwruGTh7Z19qzRcF1bz+olfE8ONPZlzMZpQPcvxhF949cF9IEHfRK1L9GEgsDOpfggvvwFdPBnTR1phs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784137060; c=relaxed/simple;
	bh=OVaYSPyDh1ZcCfq9G/1f6K2h37W1bJdIrTmuB4z0I3o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k8T7tEMspGycosbx1w+8WadOz+i1iN8PRsV9msnTnIH4RVGdI8bSS6W1EA2SZUCdfBIOlsRDNMNujwuIvyrXXwyBBUhsENJV8H9dQKr8rQsrURrtyVAJ/MOAkNY8MCj255U94gDenYTkPQSBxi9Kv36tKw2vKG1/Fnchcj4y93o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SuFAG0mQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k76pIEda; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SuFAG0mQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k76pIEda"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66F9icla205871;
	Wed, 15 Jul 2026 17:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=d71wMEhF+G01rh4MKZDVWTQihiJka2QzIqxpoDwBxAU=; b=
	SuFAG0mQlus8A5eeAWIflXn8B/j7O79Z61RlgXnT+UjvZSgdI35bu+loJVb6I8Q3
	wQG86TOhwQ22frpFhPbzLSSwDDYApfcvMNX5Gt5sxsAHcKjBhpBV4iRmOwTfalp1
	L1xictn3yRfItwfC/CvL5DQFI5I7IuHnHfd2za4Jha6/L+wRLaSWB3k5jB9MtOY4
	4xvSnRObHRURJjs15Y4nC1uwnbk3XJGkNL2vjIPRIG0aD58QrR9sfBbOyCYUtwZR
	5+RBLr5vLjRCk+ZVIhQYCZO2u9Lqh8NQMG1a2cSCjGetvTaHZn6WP+mXbouFZhJH
	goEVRPWSKcRMm+TRHNBeow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbep377w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 17:37:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66FHX81H009807;
	Wed, 15 Jul 2026 17:37:25 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9faxxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 15 Jul 2026 17:37:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acei4u+CL9t3l4gQ2jHBHnoPB0pnv7aJ5CWBr+3JZp9mEx8zaiQ1QxObEQZjG/pLtigWgnR175fxlwyCjrCfDfNcjy37wR2+aJzYtQHhGcau6ZmSH/6Aj90cgewVJDpYidb7yWSxiBXRKxkE5QZMIdCLXHx4Ah2ra+7deSvctxn2YlkhaTdAYYFDR5f99JSdypOR73Hk4ooyhknHikn9IjQxA1sR+HSSToalVFDtPHi4NEZRkbv00/7C5lc0L3DeUhgJnF3jn4bgsCV0KO56lmCz81ugoSlj1KjP8xQq5riGB1+0e4SLsZS5USu7ZrsZDSjl5fFBYJYnDrY1itVD+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d71wMEhF+G01rh4MKZDVWTQihiJka2QzIqxpoDwBxAU=;
 b=KNsHetA8SzoPjuOdZzPAtDQwMAjhKpYUk3j8OlqjfFoEq2EzSMV6TC6wRJEIxerJrDopGTYNPJjGQOeyn9FcwrD/P0kZ6neDfOMCe5ubGd8Jp5kvJv9DghPH3TBLyl17Mgc4UyBgkGJDm3LQjgfsaMYJ8CNvnZxKptUq3lz0oG5Fz8GU+f55UljwJIlWrGiw9GRV2wMAj7VUpVj+ujzZ4MzM3ux0LFE35J0TXx+FON9/QFay/af23chldGEqq7arSpd+EQq0tK1DCmqZI6mj3p2zkgD3+wd3AYEOMAU8/Xm0sqP2Bk3N48jdpFEjxfEYx+a7hYb3kT7GJypsvsG7Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d71wMEhF+G01rh4MKZDVWTQihiJka2QzIqxpoDwBxAU=;
 b=k76pIEdaU0vCsLMVNwX3/bW0vV3EuO2Z0vSbGKLC+IQFx2YUddMbnFTQqjNfHn/J5tXeFKnd22KBDKESm22Ln/MQK0lvyy4WWdHK1MLR+dxo1E1dVEBW0Z1FX7VFGT5AydzUCbeZ/cj8KcyjnsWkrWj6zMUPua/y+GErWU0qOeI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH3PPF517B7003F.namprd10.prod.outlook.com (2603:10b6:518:1::79d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 17:37:21 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Wed, 15 Jul 2026
 17:37:21 +0000
Message-ID: <b2300bba-73dc-4555-ad99-4e440b918a91@oracle.com>
Date: Wed, 15 Jul 2026 18:37:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: libsas: terminate deferred commands on time
 out
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Jason Yan <yanaijie@huawei.com>
References: <20260715085824.854200-1-dlemoal@kernel.org>
 <20260715085824.854200-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260715085824.854200-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH3PPF517B7003F:EE_
X-MS-Office365-Filtering-Correlation-Id: 56617592-1eaa-4ffc-a69c-08dee297b940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|4143699003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wJ2he7lVQkgeCewphJNeUY0RVPACbYJerVQH2UE2Nne1epQSEgJElgHA/qD+Ir1gePmjFph9QOmqXj/oPqmEd0uLWxqGQbmc4G/rN3iQmJWh8DpKvPA+ofDZUxjcQ1Hwq/HN2Qedk+9TyWq58p0wiZox6vuAq0FXTdQwEjKuCtuLRONB/ax7GggP9Rb3zjNcI5RilfxY/3fpROxChCvyeYhGo2NZ3v6DAsBpo9Ncz6k3SmB/oigX7VluzAkpv/ypSeEYNXAZCBJgt2/oyObjBulx/qm5sWoBR40Xh+yuv5m6RZgWxRkVsXiSPFVWd7+V21dccR0SKVmNm72vO7NRTUsekvQmswOWQzaqJaAnTfOWsdh13CTACsxSuS7RwbBsUHm8TQXp5GkaAdx1/Wc5D6j3P5JPmxRMTzzFelgjWxonJpmXYSVzKrqf1AWlQH5mNQ4kVNLJ/Jl+jpYQKquOCdApmU7LUJZIxBy4unmKsFhXEi3ZZrz0fOuEKL9xLxdYBUfBHRG08kBYEAOHGMCitbTuxQRzNvAfzpj7yTydi1OF5ARBYOduhgXN2MgXNYpo/vYMOwyXi691BY15vPgFl/71MGK2P6Sz9Rkjha3PRJz61lcVF5s2BD0/GLisMhNj7b1Q6N2k01vOdQTWFNyu+4iSMYrnYlGp8KT7ph3kVlo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW9PcUFYTDR5UGlsTW1PT3BIRzhLcmpYMzNVOTFSK0IySHpOTGdhdWQ1NGRW?=
 =?utf-8?B?MUk3c0tsWWV4SzVCVmROV3BIQXlXMFdoY3h1TldwR2hLOWZuL29UelZJQ0lL?=
 =?utf-8?B?SUlmcmViTW5tQ3RiTVc0R1dRZEJtQ0VCUHBUdHpMTzg5TFFLYkFFbkh4Z1Iv?=
 =?utf-8?B?ZUFlcmtZcWpGL3NtV2pzYXVsTTBYbVVYczBpMWVkbXpaZjNjamFpWmtIRU9R?=
 =?utf-8?B?ZGtmR1FncWFqNmhUQzN4OG1hQTJsUy84VGkxalYzTG1MRXhvdmp1a1dDNW9L?=
 =?utf-8?B?MFI2VHQ3WnpPNmgxU1dyRktrc3hOTkhQUS9ldW5QWWVNVFVJRmJHbHpOVWI5?=
 =?utf-8?B?V2daQXVJK3FvSkZadDJuMTFyVDNwYTV2dVpXZW1wSWFLR1FSSy9YTXlVakZn?=
 =?utf-8?B?bE9zaHZRQ053ZnZPV3A1TS9lbWlmUXc4NVZpNG9lQWVOM0oxalRnM3JPZUlT?=
 =?utf-8?B?UncyYTlZNjhCZFM4Mmd5K1dvVlVyN3ZXNTJLeU5JZUQrbm9KcVZUei9WdHhU?=
 =?utf-8?B?dTZxZlhhRGloMUt6QWh0SC9yT1hRMFlkeDdEZVEzMG0wVzNWUnY3QUROSURR?=
 =?utf-8?B?czRpRVQ5emtLQjdNajZXbXorbEF6L24rbG15aDM0aDFxQ2JDcUVXQVJEZ2kr?=
 =?utf-8?B?b3pJVGM0TVhPUmkxSnpxb3ZOK3ZZR0JJZWl6elRXQk1pdmZNVXl0Q2dUT2Yz?=
 =?utf-8?B?ejdBTmxsMVcyb3EreVp2K0VvSlVnczJEMEFLdjhiVTdpUW5xVHVzWDBzL2Vq?=
 =?utf-8?B?WVMyWVVBODlscnFoWWhDbnh5dXROSzBYdkgxbHhDVkVTL3A2d25FS0VLUmJr?=
 =?utf-8?B?TXZRY2JXUy9CSDVNcjNGck9vTHd6UzJWdU9DbHVTemZhWlZMbDRESjR1eW9T?=
 =?utf-8?B?ZU5DYTVGR285R1BUeDBTSDM5THN3ayszR0toK2RTeEZCYTB6NVQ2S1AzY0Nz?=
 =?utf-8?B?TTUwaG5PbzFKUXUxdEpPbXRNWDVOSXVOazhPU3lPY0R2TkV1Y1R3YzFtT1RY?=
 =?utf-8?B?WTZIbG1hb0pvYXZaR2xBWlp4NmlRMlI3WTh1djl6QW43ejNaanhuUFVYd2tj?=
 =?utf-8?B?ci80bVJMQWJGQlFtczZLTFRTSjZuTXhuaTJvQ0Y3WngyMHVzdkNVaGlqMHpO?=
 =?utf-8?B?M0ltNkk5YzEyOGpVOVNmdGhOVDdZWlZ3cVlML1RuZ1VYcy8rSnVFUm53SGZK?=
 =?utf-8?B?eHJ1Wm9mK2luNzVmczA1N2dhNFp2a1JCMk9QbTN0ZzFmTXM5eS9oWmQ2cFVM?=
 =?utf-8?B?YWVOSGtRMzluRVNmZldLMlJPWlZGNUtuR3g4NzJqczFTaUMvRFVRUTNBb0Er?=
 =?utf-8?B?RFh5dVpja2t5UUJhL0RkT0xIeU9FN3IrTDNmOWlEQVRvVkFxN1dXVDVISTNl?=
 =?utf-8?B?cExLaytmQldBQmRwMU5acHBWZ2sra2t5Ly9ITTkrRDAvcHNQcFZJcUFrWkRq?=
 =?utf-8?B?M0VUN2ZSTk11Y25TeXFkbVd6dlBNVGx2a0w0eDE0aGJFRHFLMlN2d0NLcWxX?=
 =?utf-8?B?ODAvSHBRNVRkeFlZWFlneUpXUDE3RzZwYUxVOUp6MEFDaW9FSDVTWmoxWDBX?=
 =?utf-8?B?OVBkTXFsYUJtSmRqbE1YWkVXUk9uVThNMG1BaDJ6Y0ZvZkpXVWRockNzcHhI?=
 =?utf-8?B?MTI5SEw4L1crTDhPWkh1REV6N2IrNFl1Ny96WVh5YlRMTnFXeGwyd3JDRTNo?=
 =?utf-8?B?R0xGaDFaUkNOTEVBTzVmNEJJeDJIWkxjZU16MU54Z3V6RVEwbGZiZ1RIcVM5?=
 =?utf-8?B?Z01zZlJWTTJycG1CTDhKdEY2TVI0aVIxTGNlcDhQY1phdFhQK3o3aWJYN1NP?=
 =?utf-8?B?dFpUTEkyb3M0bm1YZ0xROXBnc0NVOFV6Qm5BNkVrUm9EWmxQcERlUUxOd1Y3?=
 =?utf-8?B?dGdIYk5aMldQY2lWU3ByWW1YQXhlK3FQSUErZkhYZnQyZHB4bEprek5hMDBx?=
 =?utf-8?B?SDVXcmdpY25YeG4rWEZmY0VMWjUzcWFQcXIzTUxidUxQc3JRY0hYaWdvbVdK?=
 =?utf-8?B?NUdpR3l2dFBDZXVKbHBQZ2RLbFh4SW1jWmdaVDIyNFAxZUNRbm1WNVhsTWFT?=
 =?utf-8?B?ZVdtTGpIVXlJKzRsdVMwY29PcHhsNm1WemlEcERMdStuNndkNzJrcE1STXV2?=
 =?utf-8?B?eXl2ejlOQjBOcklVQURZcVRUenFSQ0oxbE4yL3JlcWMxOGpRaU1sUkFjY3Uw?=
 =?utf-8?B?cmQ3azFkcHRUbGhnWVZWTU9yOTI1bldrTE5taWpHV1p0SUtEY0VqYUVhUkk5?=
 =?utf-8?B?V01lN0hXbzg0bytXNThTeXdUd0pTY2JIeFQvUG1BaXRaajhqc2k1RHU0aDFM?=
 =?utf-8?B?UEpHSzlYdnkyamVEWlJDWi94d3NRRmorYWJxV3Y5UVJ5NGRPN3RuTTVxeGxH?=
 =?utf-8?Q?fQ03I1RUXUNAoB1g=3D?=
X-Exchange-RoutingPolicyChecked:
	sToyROYVcH70QINMx4JAeTnOmd+W3i5+j7DbLombUpmVNkhR4Bz2VeejurYPx3KkEzUgJRmR2+KBzK5kPAHh/7b0HAtIzqlHv363opBkX8s7OaE/ioEVgEA1Ja6PohD97Aftn9nRFOY8R7RSt7lI+dyGIxCPV37WmbX4oqSEfzT5Q9deJ9snGwcpyUMsKiY5dYy993RRDSaNaztSHf5Ix2zvHGZBei/Opat/cKKFi20YTrcXj41gKiQ+Jj80elIWeieBOHVVmxceeo+Y4gG6tbfSacj1Ohd2FZrcTTHiTA17u061RELkszBDCb5mDi+V1+CtyBtsWbk+tAcVj7s31Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uGl2ChA8zSLgXlLeAgWxG+YC1WoC/BBSw4lli045VWBUCfjFRoA7HwbJ2FfoRCDcmtNtpAELpPTd1wQl2fBKOps9e8ddEdRvl2RvwPtO6RbO+ra0CUgoz/92Qpgr/3/XlzdAiG66C8R8VRVwsqZMXIeq+w7Y/8aosaeJUnYnzA5LNU3TadX2qkM/dIEK7eVJA1CSXLwT2+P0R5sABfZnMDUsqzlyOV76fiHsmXvWY+Pru2uoq0hSZrGZlgJPkXWXt6qOkHF5v/hgMLHJ+d86yq8ASwz0puh6YlJqGS1DwDMUR7ft0Wrw2nnoHovb5a4CIxkzGDrY0j8MJfCcPOKkeD1agvuY4UjeA0MT5J3RffjhVNdNMRimfb57w+HFcpjuRgmXcZjVQ+91n+VMdnvGz/BDASw5InEAnEqsYMXRw+3DHzO6GH58JuMbJwVayG/psUb8dM8OE4d/d6Y6h2q/HaKxsVvR4AmBISdDELQf7EvsN30OuNlOWU5pgzA6Hhu5/F4Ggq4uc5fUPmIeFGN3y2jAdRmPRveZInc9QNZMPEkKp1WpZRQlG5QDW/rRPVUpw8VYoyGDAT4Dz7l+DDwFUcJC46sk1lFX3ACE/JMXSw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56617592-1eaa-4ffc-a69c-08dee297b940
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 17:37:21.1498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmtVFb2M9L/rhWgYJFZhFug2Vce/bBK65oaKCNfM9ampnd16Eqr2MNX5z/y1hCdGnE50DKjtivTcrCYUJYTmOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF517B7003F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_04,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607150175
X-Proofpoint-GUID: _gjNcoX4hF80QzqvFz3ky0ADkhSEcz8d
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDE3NSBTYWx0ZWRfXzB0t313a3sHu
 V0uaycePLpv88Qk2JycJdt7dUpMhbOyawbCgeOdc5ShVN6NPZzcHTrkwhtr2tej5cvCS5c9VAo5
 xU0IoF9nFxQaUAMJT6aivfwcjIyQxRuV5Zc6mcdfQLZiMveabznH
X-Proofpoint-ORIG-GUID: _gjNcoX4hF80QzqvFz3ky0ADkhSEcz8d
X-Authority-Analysis: v=2.4 cv=dYawG3Xe c=1 sm=1 tr=0 ts=6a57c556 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=1XWaLZrsAAAA:8
 a=VwQbUJbxAAAA:8 a=sNgjVDEP3_FOiLJXNKIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDE3NSBTYWx0ZWRfX/7UNjF9lDECI
 vd1z+hlEtGQsEwbeZtHcLw1lqyIRTRygMHRCuNqPkKsNN619MztWAnzVBpeVsk22ZO2+sskMq+/
 zi34HbFaFj75AnQsz62hI+C26cJtcn4u7ftTfMl9rCL7zU0tmBnSKTZSbyd9PEMkD+RlTqR6Saa
 SoJer2islOnCiHGf23njf6tfTVAvoUjAmnU6+bhr/Vto+O9WHmbjUCIVjuGJKg+3gs+N9c9e0+d
 oSvbk+3uwrbw6Odcnpx5oqMlHQT1MdWa4SCBBxgymM/37BdFI0yxDCvhg+kW7VLR7XUgShfsTcy
 MkTRP48Jc62ZY1MFYGpJy8wfAWKSw/ascIpRau7qlZMTK5m90+dodCX60RLJRDaXLtVyHelZBS9
 3twXNVMwEJuOF7IbZJAl600CmpUeCD1YOhVsMhpF8sYXKbU5sntq7wZQKf4K4u8m+6Ie54wjUz1
 kARYTE6RpdcUD5fLkyA==

On 15/07/2026 09:58, Damien Le Moal wrote:
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred command is never issued nor completed, thus leaving this
> command to always be counted as "busy" for the SCSI host. This results in
> the test "shost->host_failed != scsi_host_busy(shost))" in the function
> scsi_error_handler() to always be true, keeping the EH task sleeping.
> Eventually, when the deferred command also times out, the SCSI EH task
> is woken up and the timeout processing occurs.
> 
> Avoid this unnecessary additional SCSI EH trigger wait time with the same
> method as implemented in libata-scsi, using the eh_timed_out SCSI host
> template operation. The function sas_eh_timed_out() implements this
> operation and executes the function ata_scsi_retry_deferred_qc()
> for SATA devices.
> 
> Co-developed-by: Igor Pylypiv <ipylypiv@google.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-scsi.c           |  4 ++--
>   drivers/scsi/libsas/sas_scsi_host.c | 17 +++++++++++++++++
>   include/linux/libata.h              |  1 +
>   include/scsi/libsas.h               |  2 ++
>   4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 1870669b8e05..878527cc2b0e 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1708,8 +1708,7 @@ static void ata_scsi_schedule_deferred_qc(struct ata_link *link)
>   		queue_work(system_highpri_wq, &link->deferred_qc_work);
>   }
>   
> -static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
> -				       struct scsi_cmnd *scmd)
> +void ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd)
>   {
>   	unsigned long flags;
>   
> @@ -1717,6 +1716,7 @@ static void ata_scsi_retry_deferred_qc(struct ata_port *ap,
>   	ata_eh_retry_deferred_qc(ap, scmd);
>   	spin_unlock_irqrestore(ap->lock, flags);
>   }
> +EXPORT_SYMBOL_GPL(ata_scsi_retry_deferred_qc);
>   
>   enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *scmd)
>   {
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index c83282733ec4..ca497cfc1353 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -502,6 +502,23 @@ int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
>   }
>   EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
>   
> +/*
> + * Handle deferred QCs in case of a command timeout.
> + * See ata_scsi_eh_timed_out() for details.
> + */
> +enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd)
> +{
> +	struct domain_device *dev = NULL;
> +
> +	if (cmd)

Can cmd ever be NULL? AFAICS, the only caller is scsi_timeout() and cmd 
can never be NULL there.

> +		dev = cmd_to_domain_dev(cmd);
> +	if (dev && dev_is_sata(dev))

furthermore, I don't think that dev can ever be NULL (even from 
cmd_to_domain_dev())

> +		ata_scsi_retry_deferred_qc(dev->sata_dev.ap, cmd);
> +
> +	return SCSI_EH_NOT_HANDLED;
> +}
> +EXPORT_SYMBOL_GPL(sas_eh_timed_out);
> +
>   /* Try to reset a device */
>   static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
>   {
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 51178acd68d7..18f76c3db4a4 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1153,6 +1153,7 @@ extern int ata_scsi_ioctl(struct scsi_device *dev, unsigned int cmd,
>   #endif
>   extern enum scsi_qc_status ata_scsi_queuecmd(struct Scsi_Host *h,
>   					     struct scsi_cmnd *cmd);
> +void ata_scsi_retry_deferred_qc(struct ata_port *ap, struct scsi_cmnd *scmd);
>   enum scsi_timeout_action ata_scsi_eh_timed_out(struct scsi_cmnd *cmd);
>   #if IS_REACHABLE(CONFIG_ATA)
>   bool ata_scsi_dma_need_drain(struct request *rq);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 163f23c92b41..c7017ae76c61 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -705,6 +705,7 @@ void sas_task_abort(struct sas_task *);
>   int sas_eh_abort_handler(struct scsi_cmnd *cmd);
>   int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
>   int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
> +enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd);
>   
>   extern void sas_target_destroy(struct scsi_target *);
>   extern int sas_sdev_init(struct scsi_device *);
> @@ -743,6 +744,7 @@ void sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
>   	.this_id			= -1,				\
>   	.eh_device_reset_handler	= sas_eh_device_reset_handler,	\
>   	.eh_target_reset_handler	= sas_eh_target_reset_handler,	\
> +	.eh_timed_out			= sas_eh_timed_out,		\
>   	.target_destroy			= sas_target_destroy,		\
>   	.ioctl				= sas_ioctl,			\
>   

