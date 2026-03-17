Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF1335F189;
	Tue, 17 Mar 2026 09:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739042; cv=fail; b=lkwtsp38sER2ppsIq/EHatTtoLy5bGvbVZ2LObieRblbjYt72c3kUXcDco1xHZGiKVBqCec3+KrLJ/hwWbJr5b+bcHHXm+2kn2mtfkTMKvWMglzc/kYnE6gperZWcTm6H+mrr/FBUNEAzhFi6HUypdbBE3y5XixS4lnntrQMQPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739042; c=relaxed/simple;
	bh=F1YGxa7LoFzX5pMhlz6piU4wiNVY0T9Nh/w5kPoQlvE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=utL6rfdlOeyF0EOEqzriR3Dq20v1yT5Fyu6bIPwNYnBkRlsicUpvmx+B2Vfe06qSXFT/IUws0oLTIs6my54k1stm0wEbElw3sMEOmaq2vv8ICx5YZwLhLk/GDUCzA1i4UQYxFczP29J6lB3NdBZWrdEnEqpGLFNyK2wfTyx87NY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GxNQX4gD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IvEtOZbN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GxNQX4gD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IvEtOZbN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GNtIag1338265;
	Tue, 17 Mar 2026 09:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vFPzHUtxYEElBG0WuqCUsNqhtoqqHwpa61Vy928eCm8=; b=
	GxNQX4gDOsK4L9vGdYsZaZrlwyN/91mMuz9eUg1rOPmq8WLoV1QH26dgndwaklEd
	FKT4aBu/sdbwgGTbY/l6Z+aT9Nl4TtzYQBPWEpZyqMqZXH/AOv99+nTseumsRpac
	kK1qfZRGMz7gXqjDtmRLvXSREd7H9oLRlGwNNKmRMUAES8aOqii335/0jyx2kPYg
	yTe7qq5pT54xsen6clghMioT7T1CLhe3WzIuIDAtWZp6o9ftGOV3HR36QuWeoise
	UBciGkvwxGkCmCiVeLQEM7fCq7QyW5+anepPtyrZMsbNXgLPwAVHSeDUI6EI1wfa
	AInvmF/bLXzBSOQndOYseg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9ruq52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 09:17:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62H75J7i017799;
	Tue, 17 Mar 2026 09:17:08 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4mavb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 09:17:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/AdxrSsxKYS9hvCWWd/IvQq+HPehH60Rxr+ISz7ppainDM7WMIKlW2lJmKeKd38U7gTfR2HVM3DCCQyx7w3NBw4nclMRv7Vr1jMnm/XV8TL2bVZEpiQZRf7JiFlJXEmlUypxAAuzM1S8CIB4QalkdVeKo76hoXrUycu1H0iTIXREnzsFrFKE6sWBqvhJo6iMYvYe7OFZkPAzWByV+m7ZFGRgyrkCHlV0uaTdQ+vh9tEftDGp/gGb6E0d/ry3ONevBDVChA/oheeafJSUgrkkRik0nUxcdb1xcyKNC0o+AlWUw4Or4v1Dm9wutkQPkCenSHhSVXC2j4QcJGBbpZIRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFPzHUtxYEElBG0WuqCUsNqhtoqqHwpa61Vy928eCm8=;
 b=FovgX7bCWjapV6gbaYtTvdftBmhSMNLsbgJ6SDo++R3thDyECl1x0/cXz2i56OL3cjvG0BhC/yjTKYnOzhA5Jgjrg99v/y/qm+1cdbr2XqYJKb7y3iq/9unr2gNch3buMMNzdCbjA/n9r0tMkgvZPM+ZQbefE0V4gdMnD9kRWznslBx2lNf49CZ7SkeaaD9h/HpoWMTOvVN8TRAL+UaTBEW+0Vh7R/9rUiTZ5n/ql92wOYXkz+rzcgHmP2SPhtCbUjQY2I4/24WGuCjWkmwP4YHCuK9Px3IlyrPCjbT5+/hu0f20X/EHjj6abXQvzmvSQb8r9dbxNIx6y+IC5Z8qQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFPzHUtxYEElBG0WuqCUsNqhtoqqHwpa61Vy928eCm8=;
 b=IvEtOZbNJLuPFWz4xLK3nBO0kusKzagjboTcmMe5g7u06cUf88dmcnQqXObw5wodCMsVY5TdJbkbC9hFvMV8Rz+9QPtCVU5bNJj69EyV0AAzr0j9vdt8ohZN5K6pzQ4WXB4Ss4P353ST6fNDdODZl9WNF27Onrm/rDpaPY8MSdo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB5190.namprd10.prod.outlook.com
 (2603:10b6:408:12b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 09:17:03 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 09:17:03 +0000
Message-ID: <4301ff1e-f80f-4542-bfc1-de254015d5a8@oracle.com>
Date: Tue, 17 Mar 2026 09:17:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: Fix the maximum channel
 scanning issue
To: Yihang Li <liyihang9@huawei.com>, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        liuyonglong@huawei.com, linuxarm@huawei.com
References: <20260317063147.2182562-1-liyihang9@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260317063147.2182562-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0007.eurprd04.prod.outlook.com
 (2603:10a6:10:3b::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB5190:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cc4dfb4-51d9-49b3-16a6-08de8405f3a2
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
 CCyCAYOlGmh/hkqEyB3a83jbad8aOs3cvggMuyQNG6aBxT5TOrBpHqP2MV3axzqwBfhVXeebwZFAcKzbciQhhc/yCZtLLABsIVTaWSrtgQIicMCVT37i6lxjql8QpYjZbJs7j4PqGGfzA++1WypcMAcoZ4JVEqs7mhWRDPifbzE69ScIprfQNnE17A6InGCWipbADR0898Y8W55ReesIy7q9UQ6w5Y1zwVOYdAi9798EHBM94gxJyaatVYXQQ4lFqeapdohTOk0CQywMwRUDvwJH76aaCsIS3kpp+H/bThMc9Jg5xZLW2w9STv9fpbd7UdHfD/NUVjvsWAhX40xZffoifjl/xKEEmX1vb0OAQ6nH9meYjSXBuLqKuI/028yFFguOlgTGhUYCd4cbhurBZ7xGcciSkbZEB6FpDo7j9k6JWPP1r0f+N9sspISngpYLqQ0O3cAhCygiLBhXj1jY6euTmpDSt9kTf0wCjJpebl0PPkhdDqbVLz4h+rWMcxboi4vwVSBAf4m5+Jbcrf6eEqtDdTX1jf9YT20Kg1e8wglNVA1h+vsZlFqDHFWQ5RQOq/dYM6S0mBrfXyOhrOr7yinVajzqXvyBbB2uxsfb7g0wcLhvi/PBOmuEl5Nskxw4VUaj6ZVGQWaCY6cvWDurJiEB0nBTZWRN83Y+75+OW4nwE9c6JZLtA+M3qZu1flD+rXSn96k7VGL0Ni+RnN8a1a+xRfwtVj1ZWQEhuf1YO1s=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZG92VW5NQ29tbkJXSFc2QmE4RFdFYXB2c0p4MWdNbFJybnBhb21XaUZ2NUF5?=
 =?utf-8?B?M1hXRmtUT3cweVkrWnR0V1JTUlhteVMvR3IwU2cvYzF6UC83emJHL0dIZjNZ?=
 =?utf-8?B?bXVnK1d1b2VsWHNsRDVEcHpNWkR0Ti92bFZwb2FoTFRvNUxPbG0vS2x6d1dX?=
 =?utf-8?B?SXZaTmZkdk1mazRmNGNISDVZa0Rvc1VvRzFtQmVHSmNIZUx6V1Y1dlhyMjNm?=
 =?utf-8?B?eUpqa01WcUpkVUVhLzR5RFJtNHpLN3FpS0ZDNmpLQTRoVEk3ZGR3dkZHaGcv?=
 =?utf-8?B?Qi9lVWx6TldLV1pjN2ZscmZqRElkSVBJcDcwbS9pM2VkWWdQZGI0YTBhNkZD?=
 =?utf-8?B?ZWZoRFVsdVNoOEtsVzJjZituUnFGNzRMZUl6Yi92dXNzaEdxTkFvcnZXUUVT?=
 =?utf-8?B?ZzIwajJUSWdMTGFJNFVTNVJUTyt6ZjR0L0NWaWN0UlBwMk9QVld1d2RzTHlI?=
 =?utf-8?B?Q0toMWZqaTJienNubDM4cGYzanVtaUYzeG5nMDdQV1M3dVdlaExOWHFObUpa?=
 =?utf-8?B?c3F2TjZyU1dQNEFTaHdSQWNYRTdMUWtMcGFaN2NqZFlXU2ZTeEFMR3BZU0Fo?=
 =?utf-8?B?Y1FuK0Q5S0tRQmt0NTA5YUlqcWZETVhLdWU0emdqRm1TR2xtemxqZFpjMlJD?=
 =?utf-8?B?bEE2MnZlczdJdFo4REllenhLUmRWZWVtc3BtaWxLcDJZY0VCMVRSZzlVRFVR?=
 =?utf-8?B?VjdQWHJBQ2ZmZGhZMGpXUzFjck9TcFRSOUE3ZEMveWh6WkZVSGN5ZUdtYWhC?=
 =?utf-8?B?dVNtY0czOTB0S3lpYnFCU2Z6anpxN1hJY0xJUWUwa2dqQWMyS0tGWGtNcUMr?=
 =?utf-8?B?WXUxem9CTlVZemwweURHUE5KMXhjOUFiZkdNK3NLdGFJaHpzaGEwSUJtbmV0?=
 =?utf-8?B?YTBVWmYwTW1pWFJGQ2w0VjNtVy80WlFZVW11UGFuMUk4cCtCWG9qY1k5WmRk?=
 =?utf-8?B?M1FiWU9LemRVUkFWRGlqREdHRklWUnZoc1Bna3pySGVPOTMyZmlPZkxSTWsv?=
 =?utf-8?B?KzR5ZkpZaDQ0dENoOUoyMWFqNlNvbUYybVZCVkpjTjQwZDhzdGpQU3NMVFhO?=
 =?utf-8?B?dVFtMTRNa1VIbkV3c0NKT1Z1TFpuMTRZa1NJNHRYZ1gxMWNjemhtSmJBaWZt?=
 =?utf-8?B?bUk4U3pVS2RBclZVc0E5aTNPeVB2cWhvUm0wVWxpT2o5N1NGdEprZkNvZzQx?=
 =?utf-8?B?czJOcERWWWFTV1J1dGE3ODNjS2pYS1hVQWNCWTVFR1dzalUvM3R1RDl2YkJ4?=
 =?utf-8?B?TGdjR1RaZkNRMG5mRkV3VDljck0wUkpSWU53RzVPOStFTklBcEpxcmR6dEF3?=
 =?utf-8?B?a2hwUEpyVENudlV2Q055QUc4b1hleElJRlBPSlhoaUZTdWlLYk5EZGJxSUF5?=
 =?utf-8?B?TmVMZk5QOURaS3hBUmg4UjJRSWlGTjduZnJBUUlXMDlJMjA1ZlZJVFMyQWJm?=
 =?utf-8?B?NEkwN3p3aXg0OHJJanhjL2N5MU8yMVJTVWt6U3FXdmt4MXJPaW91SklqT084?=
 =?utf-8?B?MVlCa2NacHp2SGx3aWF4eTBNMERLSnBuMlMwTFppZ3N4WjlTN2hoby81ZVZI?=
 =?utf-8?B?d1Jjdm1QdkQzeERnUWIyYmJid01McW1KYUJ4ZGVPNzlUMC9nTFczWDZid0VB?=
 =?utf-8?B?ZUtPZTdSM1lLZmJlYnRKNzFaOEo5TW52Z3Jxc0QvZ3hqRHArNlhnWmpqazZK?=
 =?utf-8?B?aENCUkdScXRQdm1tNjE5a1MxRzhsdmNCNkJEL3BjV29vSHlXZzZlTWpKZWQv?=
 =?utf-8?B?RUVlV0cwOHRmRmh5U0dwSFREMG05U0xtMXRNb3Fkam5tei9BVTZoQStsYUcr?=
 =?utf-8?B?TFI1VTdKVzdNTERoOTViY2VTU2MxUkU4MjlRMzZIT2pTY3Z2RDllTUdieHZE?=
 =?utf-8?B?d2U4cExPbWZwMzdGTGgxZ0Q4M0tqZjM3WEhNdTN4Qkl4Ym5yZTR4QmVSbW1R?=
 =?utf-8?B?T3VrV0tvVUJwcU9EY3I2eFZpQS90SFU5V0M1STFTdTdrNG1tNWVNVllQYmpC?=
 =?utf-8?B?N2xnNTlqMTFzNFJ1ZER3TFJjVGdZelRqRDZyelo5dG04dFFOejUxRHZKOFN3?=
 =?utf-8?B?QzdVL203ZHRhVWljSDFnaEhiTWxPY1VRSEVEbkZaNjBSOVpoL2FWek5FazRQ?=
 =?utf-8?B?RHNuV2JYSmdWS2ErVzc0Sm5XVy9rdmE1RkRaSlpnbG5mVCtzd0h6QzdTWXRz?=
 =?utf-8?B?UFA4WGc1YWhpWnJ1SVk4SmxHNG9HcW5zSXZOTFFwSWhxeVJYWDdTajREb0ti?=
 =?utf-8?B?eUVud0w3R3Y3amdiU2ZtUW1yNzB6TTdsNVdpZlhQbEdqRGFRbzE3VXRaSk9B?=
 =?utf-8?B?MkcyYmZuSnpQamNBcDh3Y2lFUHU2emVPTFdjZnVEd2tSL1h2ZUxmZz09?=
X-Exchange-RoutingPolicyChecked:
	wpMvkB6/QVjARrkMcho+ZxOwgC8hlOHqUA1gs8dRWLwofXtrHxqFIXQk72S+Y5UX/QljSQGu8vkS4RshhDyvlCjJ5GHOMVkpGQIYsNgeu+HTp9SZySb7ENSG8BMTJjiNjfz+tngWa5rW1d6rZ1fj7Z+DRGFNc3JBJnWrqvBzbt8mqhJC/tKWHtzirVxuPNL4POHmSVBVANmqI6Zapyf4b/CEwvSvX4MPx8J+dUd1iKpPSH9ulznYDEdficc7jCgK16WSz2ZcqOszNjkZqXWWmUOX2yziNZqZmnj8Worfnif3MuVE+iI9rdlpNp9xxjF+sZ1gX9EdaGI2TJnvDi+HoQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tOs6a9HGjSX+58BGaSa7UL11mdFZigxYbg/WvUO90rdOo71Prd/LJoirLJob/mUxL6uys8n49J8W0QEJSHNwC6/icH83NfO/FL+UjP2Jxm3jRXNq9kWt8AHAap72mRBf5hl5qv417KeVzRoHHJYXHaSWCgdda/Vi2jgujGYchBOmkc3YGworGBBQztzKCjg0WkTqLwVnZZ3Feu8Oqefsjq6JwEhkNFQEIXZM+4q/NNAh40Ad3ar3iHEWKWrIE3U1/fTJJKA1E7rVlxhn46pu4sc74aMXbnoNeGzHy+Tqxu2VBM5u5CO5DLOzKB/vFeODXMppQVvJanTPD0OI5rvRcetpw92AX0ZN/3mo5PtUOfSRyRMRPWm5wshH8yupynNVa6fAgwB+EJjz63CIj11WXyPnrLA8+B0PHwAVKsY2tJgJmR3OoC7BI77Pm804jKyyQEPSEHF5PoeZvlSNEu7DH5cYYoDLipAEc3hTUwCRnrqZuIqueAvARLV6d7bFi6FgL1l2N1xneJxQ3/ZOp9UTDcFwVEsjagzAzEuVtkDThaGY7O7OXyjECMLTJpdrzWja/Ngl1iHc+Qllg57pSlBKGFDAGETtDdDdwraa6AAUvoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc4dfb4-51d9-49b3-16a6-08de8405f3a2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 09:17:03.2654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n0uVzHiw/ZLkx6LFheosuAuUJljtaU+UH3b7Lj2UQSd42+6OS0sRFA2fOW/pGy5lWd88K3MRdbHEo91hvuGEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170081
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69b91c14 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=mZIjh7zGpij64chpgtUA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 cc=ntf awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDA4MSBTYWx0ZWRfX1z4Q24uKyhxd
 33GSucNtz8SOkBcfxzhAII56yR8rkkHavGPGgupIHHdn5in64ejoFdAYHu4g/Gp3ueEnHfJZCpB
 5PQhiGq68QipGHDOv4PGfUlRpn+JnmlKcOx+ZbYivD0wBgRebVKEfpc3y36DwaygB+voxyO28Bj
 h+pjpbd122Qw1xc1kVFtltN/8boatnDi2MVpxyD7sFDAZMsQpNxWeUP9b1+I4BxbIoSOyDnkMYo
 X5Oh3q3jXm5+02Wx+aktvgEq0WX0y+t+K95F2tUShhJyALdS4XtkpRUWcbMnGDF7OH5uY2rcXj3
 XRmFZLCC0YValuRwrnMvxtCSlsHADVOiatD5gY7Ocp9xIs1UfCEw4dx793xQillQIdLdeIS9Jx+
 XLxz62moeWejlOxspEnRFK+pkeL9O0+eE/nQbqXzd7jt3BHN6Woio4293ITx17EhucTOhpEmqZ5
 zLJnvnOGX39aSYGrT/IKA+WoUvpKcLWdhSqNcNdE=
X-Proofpoint-GUID: CaS6gQIHrETxd5pZ3XKSilsHEai2jbRr
X-Proofpoint-ORIG-GUID: CaS6gQIHrETxd5pZ3XKSilsHEai2jbRr

On 17/03/2026 06:31, Yihang Li wrote:
> After the commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle
> wildcard and multi-channel scans"), if the device supports multiple
> channels (0 to shost->max_channel), user_scan() invokes updated
> sas_user_scan() to perform the scan behavior for a specific transfer.
> However, when the user specifies shost->max_channel, it will return
> -EINVAL, which is not expected.
> 
> Fix and support specifying the scan shost->max_channel for scanning.
> 
> Changes since v1:
> - Add the prefix "scsi_transport_sas".

this belongs "below the line"

> 
> Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
> Signed-off-by: Yihang Li<liyihang9@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
