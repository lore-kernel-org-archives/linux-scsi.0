Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3E741B361;
	Mon,  2 Mar 2026 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466929; cv=fail; b=ir0+C3XyQo1D6+Jo5cgtgQkycvFn7i2jRObU3V1DOcDBkG5YicGuHEoBgNKDhbQoA6+E2uJmoSqUYdu+Gv3uAsl5ZSyLU69vshcSkZHPVWyYmSiNh6yG0rpS+O1nPNdrfC1jIrd0D74mVO76ICJG66JzMs9kwgz7MvLA6cE4O3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466929; c=relaxed/simple;
	bh=1VCM7VMD0XcG5KqPVkLuTwn8zIZK8sDPGJxhicAfZzw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rqi9uhgeG30dulgaYwvbgwZI4Dc9J/hFZs2z9vy685fOuwybcKWEH0f6L5yVeWci0afl0nSbKNZjUhGyF08yAA1pKg/9dEwvsbW0BsJU1WaPFCHyerdhYgq9E6Qb2pZwRdv3cpFxK0keKmZD/l0EvcezYvkgRbkBQua3ovLo64w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AVZSpPzV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SHFXdwyQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AVZSpPzV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SHFXdwyQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622FP8Co2214845;
	Mon, 2 Mar 2026 15:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UuZD4Nl96HOg92G7u0i40WtCNVLBbqTau2ibaL5u+Zs=; b=
	AVZSpPzV3V6ZnlbCI3H17KG73KLD4EcGkrqOSp5923H3y9cjg2tSmAR9hjlPU56x
	zX+E60/NX/5RlRdU39LKIvjHT7dNjReOYtCTXfk3LMCB3NCLsBjcQXBGR39if6JJ
	mwfwzzGDbVkoOcQy11ZIPNTBwK80qjV+6Gfr1yEHyjet4zeZ59r1Y+BWuEEFCv/D
	uoMzm5I4R2to04gySz/wPckskCOL/m7JVIc8QMXcyHoEi60xXrUcBuWggrq21TKf
	yJd18i3eG1zhZBwr9o0K0Pmw6NE7jz39806ZprRnkVK7LnLdocN4FP2J4katNiNR
	aojqW8fuVAOZLuuNutQz5w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnd62r213-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:55:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622EEKGC034683;
	Mon, 2 Mar 2026 15:55:04 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011049.outbound.protection.outlook.com [40.107.208.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd4cm6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:55:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EXCVyVg5rjKM6JSBgda/uks/pcXqP/Af8u602MQP0zrb+KFy+THFk8mhYWzKATkuzmnxnuRaqifp7hyIPnlmMYazKeQVqa4ZAVwxs80olNuAkTWjefZFepIKQAzBWGVdpbmLr4CoP6OTsFktXf/nK5zhi/jPSJOY55aZMHZfSikcg+ibdJV8rHp/nWeMQJg/Ovher3dk0omk4rHmZVf2lWttpz4ZDZGsqxKYyHeCVf7cISNFWqsfWxXLJx7lkMscD9HEWIVP6tsbL5rJN2cBO0dHKQOlasN6XNNMo9aYiAZDkPQZsxe9jnS79ROD4hGh/mqMfskaW9nQWje/kTJXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UuZD4Nl96HOg92G7u0i40WtCNVLBbqTau2ibaL5u+Zs=;
 b=L3xJDlbcRQq+RuQ0bSS00v+eZ75NNdb5tbi6tdpTwM2EDnC/Z41aDrloPY74XOcYE81JWyMfc8payUEpqoM18xTE/Me8OFoUNDn3i7eUkJ9xKeDKf/glNdWoq/0vc70ZRD3vHQSt9Z5LLrSUd1duhQebfQAJeqKzGgeQZPKafugMXQe6KpppK62HN+qA5Jo6Uqxp1tk+vYQb+m9plAN5F1DhMOi9PVupqxu9xFmhS+NxsZHMTkSEmoRsNrFn2GcUTAKkOwcTVgfZ8NbJ5symNf48znhD98GMYqEdvckW/cIqWFVqRIJvB1Txlc86G99kFf4vx5t3DHqDW9WGispcYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuZD4Nl96HOg92G7u0i40WtCNVLBbqTau2ibaL5u+Zs=;
 b=SHFXdwyQS6FRhd+fQcbTjFJin9m9NwCZ8hazabP4FrflrzkfpfBA56iSznQ4d8wSIOxM4yxjc4e51+98LpCJyvXAgRUKAGduUbWms5lTZ4MzTBlcuka2Pnqs4TlmgSREw20TI7LtLp80xM0c3wZHqX+rPFDa9GyDkYXyTnEgdVM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF0D6E81A30.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d07) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Mon, 2 Mar
 2026 15:54:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:54:57 +0000
Message-ID: <5533987f-c99c-4b62-bdc6-35c7fb0f6452@oracle.com>
Date: Mon, 2 Mar 2026 15:54:51 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0277.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::9) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF0D6E81A30:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f6c6096-eb49-4458-1be8-08de78740d58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	Z0SJuNDmm2GCHpvgwMCMmei+Z3HEjw0Flnb0cVruDgbBISVZ5qknUItj+bH4H9kZ3dWK871ftG8aKlbuDvT3GlNUbyonaYmkiEWIOMb6tT4WFD1Hmu6S/HAFSa5U8q+k7Yht6+EW3dTVoGGa0FKm+Fz1G6m52oxYd1AX0oZc7MN8cYn4n9+kuVNb99G5LzGfQCKa+GYwrBDDzooXxGU+lsApKSxSLBAjym+z7MTXWkB1Df/2MxlspAftXvbu/d5L0ruT+XlbFVOyiLu3q4iAcz/X5yzDR6l2iI5CL5meGOqXUhdH105xIUaN9MHS1gtHSzFyFUWK30PIOFqm3McmCBnX6h/UahGOLc0leqhsvl3kbxh9DIiJrVjAX2DdyiCDSPgZsnIYDop+3wPbZDb+oopw/B+mp0KjzFSvt1j0kF5WYXn4Z415caZZEi59l2tCQAD5S2SvcOysJIqpYUdrvEa0UMXpOz2bzp3ntMTNcnpoy42ZeEA1++OQRIrIlHDLAB9OcvymRODLjnQQJ5k9j2as8g4Rz6HBWGemm3XAs8e47q25cKhqXyJAL8tQZdxFBV5P0O7OjwbniM7a4qtqxx70YdokNBKb2BOakEJ5chp6OUYR4YW765n2ePkSeSpCnDX/7bES3TdWaNtoaWraqAzYihOKI4mg7S0zArUeTc8TqbkOhAaYsEYFm/uOOWcswRMEWsWZlfDEnib3eslo0DUQAsx/iuYgr6GkSzpIFA8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm1xRyt1azBiTHNSdzRoTW1XVElobTU0NnRJWW5XMFNqT1RCQ3RibTNZeHBT?=
 =?utf-8?B?L2Q5R1E0UlRBK1IxOVp0K0NGWnJLZ1FxbGtiREppbHZDaGtLeVpqYkhyZ3pS?=
 =?utf-8?B?SlhOSWJCK0RYcEFEcE40b1gzODBIMTk3c3B3a3FRL2Fha1NGWmQxVGh2bE5F?=
 =?utf-8?B?R2xITjRqK3RDd1F2RlBPQzlJZzZJd29yZVZEZjBUbHNvNTh3YW9ubE9jOU9O?=
 =?utf-8?B?VHZBWllONlFqSVVZSEhUcHZQcUVua2drOFIrZDU0SUp4MXRwZFFWbVJJcGpG?=
 =?utf-8?B?TjBVcnZYZHpXVW43NnRBVDNWbHRJRnppWEErY3RYd0RqREJVTjVKT1F1Znhx?=
 =?utf-8?B?Q01TMk10ZFhWdThCc3JqU3ROUnMyU2RVTUMyc29acEY0ZjJQNFFTQjRjQnpu?=
 =?utf-8?B?YzZIeEpDYVNFVCs4NlFlbjYvNTRsT0FLNndtSFloY0RQRm5kR1RzajhJVW1h?=
 =?utf-8?B?U1R1Z0NhOXdXa3Q5S0xSdE13WjJiU0pnNnY1U1JlazRkdlBkUklKdlBZckhR?=
 =?utf-8?B?aTUyZ2xCQXdEWHJmcEV2bWxFZjZwcHAvL3lHcis2amtZdEN4eFJPTEE3d2Uv?=
 =?utf-8?B?MDcwVXFuc0o0Vm9BN2QxN0pLL2d6TEdUNWlDcW52UFEzKzMyeU1FekRkSlRF?=
 =?utf-8?B?VUZaOG9IdkdGbjlJMWc5cWorQktCNlpzcThSQTZMdWxsOFRKeWpKdnpFa0x6?=
 =?utf-8?B?ajRNYkVHVTNXc05KYitXSUIvbVFWenBqN0ZnYnlJbFViL3l5VHhRLzNLR3Nu?=
 =?utf-8?B?bytoM0dYNC9qWENwazZ4ckhwVGNTelVTSW9vaGRGN3dSbjUwWnBGb0dPWUlQ?=
 =?utf-8?B?U0M3YkRPQjkxSzc1bFJMOVhWSWFxRVJjeWdFcFZwbCtPZEhrTGtVUWNUQ0dM?=
 =?utf-8?B?KzR3eUF1MlBoZGFJL3g3bHNZM0hCMzRtaFlNQmg1aTExNzNNUElqMjNLOGc0?=
 =?utf-8?B?Y0ZFMXdnWEwvZ09ERVllT0hJY0dDRWVlZXRQM3gvY1VMeG1Zc2ZJc1FxVGVl?=
 =?utf-8?B?QVdXNkFaQUFBODZ5eVgvc3BYdDZJRitNZE1kR3BKVklwYzRHOUl5MVBCdHRW?=
 =?utf-8?B?Q2RoMEVYWjlESlhhV2h2emUvTHdWSVVxSXg4cTMxZEtIRmpMSFpsTjJpWGlQ?=
 =?utf-8?B?WVU4NWh4aWZHM3ZrODNHTWpoMTIrdytjTjVUSXMxWXNJakVCclMySjBkYlNO?=
 =?utf-8?B?RzkvRFJlMjA0R0VzcUszSGpITVRrL1NPa252ZnpXOWxVcWhDVkovNE1GUS9r?=
 =?utf-8?B?YzlJdDR5ZEw1NTJMK0VCbnNKL0x4bTF1Ky96TVVDSWVpekhPaVlvVmxTdHoy?=
 =?utf-8?B?VzBZU2t1dVNzdHdselJhOW1wamNienVZKzZIQURwWGFPSTJlamZWY2VGYk1B?=
 =?utf-8?B?UnpmTEQvd0lRbkhkaE5ueTAvbUxFQmpqK0ViQWM3R3IyeWt2Q2l0RjdLazJV?=
 =?utf-8?B?bHJwaDJmWU9vblBNWUJKNCtUOEQwZWJaWlhBbENaNjRrR1kwYWFrYWhWdXZo?=
 =?utf-8?B?MVFRbnczVUVYSFV5SjRWTDFUWDdKRWlSZlpKYU9YWXNEdmoxQjdpd2poemlP?=
 =?utf-8?B?SFFQVmZJTWdPVWhnd1B0QThDeHYzdVY0YWNyMmd3NTAxdjkyek4wV1ZjTzk2?=
 =?utf-8?B?ai9uWlFiRzZySWc2Z0RqL1J0eXg3TUZyNDhMUkFGNVRIbU1udTdnN2RzWmZL?=
 =?utf-8?B?eUJrZVZtV3FDNk9KRzBjVlhzcy81R1liYXFPSk54YnB1b1oxNzkxTmdlRFNF?=
 =?utf-8?B?c1F4R2NicXZha2NoeGR2S0tUeVc3dmpQbWtMcW5ldXlTK1paUXhRdUJjTitY?=
 =?utf-8?B?TWYwdnpnak1qUzZMeVZMbFJlQzByT0pzN01WejRjVmYxS3pxMzB5SGJqQXlG?=
 =?utf-8?B?aUg1eERlZWhjNDY5VTNZQTRKMC9UOVgxbFNBV05YVG1vdjVFeVlqYUNwejBi?=
 =?utf-8?B?eEdlVHduZWtyWVRHYk16dTRTTm5FelIvb1I2Q244UkY5S2FrN3R2bDUyNWJ4?=
 =?utf-8?B?MDh3UzBIQkVtUjFqdnRkdlVCc2Rad04weW1IQVdUYjVwaEIxSnJpVWtDYW16?=
 =?utf-8?B?RGtKMUMwVFUxR1pMNzRzaEp5cGZEdFpCK1dGWU5sVHhHaXhyNE04MnlGNGVs?=
 =?utf-8?B?d09lR2lBcERNcFRab0NHZ0RwSFJ0L0tLdTZwcVFXZnBVczdTRXdHZCsycms5?=
 =?utf-8?B?VUk0Sjc5SHRmN2tlUUlFamNMcG1JQUQwNEUwcmJUV2hRMlp2VU9WQncwbTBU?=
 =?utf-8?B?Yy9WcnhsMC82U21BdjBDU1lJZEJWdDBlcFRWV21pUkIvUTVha2IzTGZHSE45?=
 =?utf-8?B?anlLay9FbDZobVZlZDZROC9BdDJORC8xVXNsTkgvellSZFE5aWhoNHhFZFJh?=
 =?utf-8?Q?l0jYbuLGEqY6j40w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VwxOd+jXNpxo5dQD6WSK7yJ4lWRevQZS+zon1CuzchFfPgIxew8z4WB6yz7RXfFu/a7+P+GXMEbG38Ey2TDc9XYrJ+/iOe1uzFkLDNPVKW3qH4e2/j6rfHZFrLUzuOzT19WTy+upsKKIloCtHuedlCQUBrLVsfZwciWCMr3WW9pyQH7n3/kcxyjQ8DXUNhS+qpnZvaf5aBiud/QE321nib3JVwdmlt+oansLRUiSoIMP/8J8qm9Ij7psII11URXnxe7D4LGiOO2qPmpW9RX1Vc2NJ9sBrMJCutbj0qTwDOjbxCdTZQekH3FeMhcTQzqPxRPTUeTBRw19wCJ1hrTC0fGKb1TaJ05D98IirdUgS3UhMCF2mOM2zaDshq4oGgn4i6YB5b/kQBQBbCow+VpaAjz5ZWflJlfLmp/5gNAgR/qZ8GCCXQjCqKJIf83/AeyrES/9uf77bDNe+XMUdLzYWoAlIagTSapC7IbgSdefLqatXaebRQUOjioXZ5Uq4O8CuNsFxOdI33vEPtPWsofQJwaIysZbKTc9pFKUgqfdARavuFdj1vrtyUh02pwDVlw32OSarfOGCAFdOluTdw1LGUDKZIWDhX4V8vza26SjIMc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6c6096-eb49-4458-1be8-08de78740d58
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:54:57.1302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfVj45nasdwKEvo1X1Lbo0uEGNuQzI98lEE6rogtSAwOErWnDiSEADp0H0Jdk+aY9XDC5uK5Zcu+8b9PI/SvNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0D6E81A30
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020133
X-Authority-Analysis: v=2.4 cv=G7MR0tk5 c=1 sm=1 tr=0 ts=69a5b2d9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=SHLv58NeNCR32GBbl4EA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12261
X-Proofpoint-GUID: cc3RbcMxi-p42jnCfIAXfICbupzSM6wI
X-Proofpoint-ORIG-GUID: cc3RbcMxi-p42jnCfIAXfICbupzSM6wI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX6NskERuEXwyL
 ev/doh/VBObGg7h/IBpcgtIH7xgWrC9JevqNfr8pwMp8hUJIQYhqvX3KFoIBwLb+cQh2VWeHhJN
 lDdAL8mUYcwAbOJUlPLlbJmw1yOY33RSHX5RaLZ8vS41VLuJ/coEHDKi4Vj83ndggVm4dZkHJdr
 cCtMnv9Ok2SPaWx/4jyDhmeqlO1gqlFiou3xIknlnzXIS5USC0T+tCu4mo4rA59R50u9NvzyO66
 W1v6NLA7pfpQZEDDidVNFn1SB0kiy3PsRI5/tnLCZYpAlwh8+fQ3yUK+3Tc4XKsGuL1Oubvj0UP
 J2EmmnspnwoWt/MgXDRC0ouG6xVypIl8h1nO0cgU4XQbpgyGldKKkT/s4YLx7Zeh/KOzfHF+WTf
 ltvsuYNervH4Z2McOUXQy+4y6Xl9wnRUPuQsbzeAc1wwATmpUzJzyVLalXuLA3rnbI85Em/VnDb
 DKXrL9jOEgM4RtN/pnk5U/oQ7EBOveFkGA0z2RGc=

On 02/03/2026 12:41, Nilay Shroff wrote:
>> +
>>   void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
>>   {
>>       struct mpath_head *mpath_head = mpath_disk->mpath_head;
>> @@ -793,6 +868,8 @@ struct mpath_head *mpath_alloc_head(void)
>>       mutex_init(&mpath_head->lock);
>>       kref_init(&mpath_head->ref);
>> +    mpath_head->delayed_removal_secs = 0;
>> +
>>       INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
>>       spin_lock_init(&mpath_head->requeue_lock);
>>       bio_list_init(&mpath_head->requeue_list);
> 
> I think we also need to initialize ->drv_module here.

Yes, thanks!
