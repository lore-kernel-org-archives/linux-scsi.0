Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B7C23185A;
	Fri, 20 Jun 2025 10:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750416241; cv=fail; b=oi8bek+Vplod8KNzCwYHGhFOfpXfyBN8rHQd6ibnRVGrk1jt2G2338LvyyRiSg3G9No9PPUDYD9Fu59eXQJin4isL2wSpxCZh1ibgAX94S2l8e90QD9FS4E7pOjql2Ecn7jkNIkxH5XsrUjZK+29lo9yR4Qqu0mYlZ1l4KU73PE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750416241; c=relaxed/simple;
	bh=xIFTOPxSI8iUpqBlE13uD00RKOfOnT3ZK42XVXWMXA0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WVKe226kp3Lu79avZBIubkZPQK51nGnj+czpZ5vsgk6p7tSV/OIDlEw0EGPfi8fuJ91iT/QkUw+bIYzpY/0o+l+4RZeeUKS1IwsI7b45BExJZ5xY8kruVJaKbx7lX8f1czPwBbDYHOE9LCcR91VY1tzJ8OebiYbLMD3di+1CZ9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WSUElMO2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VFIpIvKO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WSUElMO2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VFIpIvKO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K7faj6000886;
	Fri, 20 Jun 2025 10:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9+2kk9FJWxnP63it5PGQi/8RopfiWp1dp7wH/5UvQxE=; b=
	WSUElMO2iEZ3rJGYdAITMBLU/mIKvOkzjclhe5/6hCVYaONn1wHv/o65DgBDvAr5
	nAeqab4PWH9Oy9os+kT+CxtGt69elR7DNRx8cYsd0eLiEThYcDyiIJFvprozd6CS
	njE/lC+uJ6JTSQAQyxLfu5gLXQ5mtBcV5IKcoycpbWuFoCp9XN3TDyTbnNgkPEqW
	CfxcUu05GWpYDOwTMxZzJwgm+W9mUwHRdwKRJHEiTIFAqBHnIu3icqlNwyxt7PoZ
	sAl6VA928eU8OPBaVp93AwP6iLl30A8qjb134q4a0EhZF0gIcX/7alYn2zs4Ok47
	SLHNZZo4q1KmR0hyLWfPsQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvnat18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 10:43:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55KA0cMU037493;
	Fri, 20 Jun 2025 10:43:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yhcj5m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 10:43:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IpMleEcs8lg+cyX9BKLXSkZY2NJ96dljJoj61aAzEPrnM2elkYFVzppH9AE591KkUbojm4MG7xEg+O0nVzCQxLG88HnEQrgDbVaYGYGv5L60G3wBzYkIrEFnqDWnimzRK2q0QnzlHZxk56Qpvv3J75BUV6TsT389KiBSQYfBUgxId2wxeCJDOUb4akVceBOztHlBODlBJNrYu3bKHFRFiuma9RYLWoLIa+80/D05KiIUS67gaN8mj6hSTErFWDDwUy2tN3av7/7T7ymT9j+aGxtWQzGB7SkMpgs8t48AuZU2js+BKI6rJzWGp6S4A//FD8M+qLNmSEg9ciX9yQIPeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+2kk9FJWxnP63it5PGQi/8RopfiWp1dp7wH/5UvQxE=;
 b=Q0Ak0XKAGkkPkwKfnUaTZIIAN7+FVuEY6N98yBdG6hwzxqTCky6dWMDKk6SJsYFprLifSlYu63YNIi/lDiuN6eL0Pj04cXKPhIPNbSPZ4ur9X4A9rXZgv7c7lBED1qKVCoaBE84WjE5+FaBJTNQ6R4Ak6P9yYI4v4VXen6vTCgMJOnFa1779HioXkSGeZob7Fh6aap8gOLEc5ClE9SjXkC3LJcY9J1f7jNq9+qS2qVwjClurnFtT8JDq5b99P9l4oLkfsTEn4hVgDyuTZnGISw7RZ3iOYV4LeanZp7muOAHuvuTxMWfFWi9Ufd0LJ3sUWFh5NSG8FST+R8R98LbqZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+2kk9FJWxnP63it5PGQi/8RopfiWp1dp7wH/5UvQxE=;
 b=VFIpIvKO9Y0gqhqZ42v8z5GXEGJw3klNsmHj1GiGHTe+PJX+5LYlntrABvgv8pPBQ+sjb5r8VHNMl2sCVjqYvnKwMuFV8Xr1yH4J1N2PmbqXaqpDqAeFvSI37oosZ/y2aaH5zj6QGfgflrZUXUI1S3BKpWtJBBIo8KgPcbTOz7g=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7838.namprd10.prod.outlook.com (2603:10b6:510:30a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Fri, 20 Jun
 2025 10:43:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8857.022; Fri, 20 Jun 2025
 10:43:46 +0000
Message-ID: <fcec4cd7-8e0a-4dca-a1b4-519b5e683c52@oracle.com>
Date: Fri, 20 Jun 2025 11:43:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: "Sean A." <sean@ashe.io>,
        "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@hansenpartnership.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
 <ntxbqgnwvjdxggl5hno7eqae6ccpzwoyule3gwo4pnb53h4jiy@qfvkb3ocdeef>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ntxbqgnwvjdxggl5hno7eqae6ccpzwoyule3gwo4pnb53h4jiy@qfvkb3ocdeef>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7838:EE_
X-MS-Office365-Filtering-Correlation-Id: e1773d45-863e-4bbb-14ec-08ddafe75529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M213bHFyZjRLdUhsREhJbzhweDJsMGJuRHVrdmlZcEp2bjY4eEJTOUZNT29S?=
 =?utf-8?B?Y3pWbTYwbFFHUTROU0VpTXY4ekFNRVozN09TU092M2c3bTRCOUsxdnhjckN2?=
 =?utf-8?B?OWw3K0JrWTNmME8zS0dSS0wzMWllOGoydGRwcTVxWDZGTll2NURNQVdzbmtK?=
 =?utf-8?B?ZGd6WWlZQnFMdW9NbEw5bjNCNGc1aHNaRmpkRHBreHhVcU55YkFtUCtXVGRV?=
 =?utf-8?B?TlZQK1l6aE8wQ3MyaG50SkEyOW5yb2xnTkhWTnJxQWt5M0VjUTFxbzdxcVU0?=
 =?utf-8?B?Z2FQUXIxT01JYllpU1lZTHVsWmpGMDJRRy9lR1U5dk9QSGdWZUxDckRjVS9G?=
 =?utf-8?B?N1E4VThvdy9LMjJQbEsrNzRzVEQ0RVlvdVpJOGdrZjBIamhVNVEzaHVQKzdp?=
 =?utf-8?B?YVVaa0F6V2VNNmQ5VTFxNmdydEhuWTlEUzRONzg1Nldlb0VyZjFoZ1U5TElJ?=
 =?utf-8?B?WGZNY1BCWnlGYW93dUUweTVtTVNOVDMxQnpGWFdxZHRXT1AySmtrbUltRkpV?=
 =?utf-8?B?QTR4ZXltNkQwNkhxeWRwMGhoVWlhelQ2LzlkeGx2M1hEVXpqOThmczh4dkpR?=
 =?utf-8?B?RUVhbmx6RnVId09NbmhBdE5vS0JsdGZ2Wi9jbmZGQ09LbjlVc0ZCYmFSck1l?=
 =?utf-8?B?L0JKMEg5c0tlbjQ2UFVkNUJUMEQ1TlFaNUp1VHkyTXBJd0E2b0FZdkZOa0Jx?=
 =?utf-8?B?NnNCTVpmTnh1N2tNYlcxajVTZktPaEVoWXhkenVEeDBjNTdLb3JpTlIrMFhm?=
 =?utf-8?B?VURicjg1bUlzUzhrWjA4MHYzZitGUDRFWWlKV0oxZ0hwMWJyYlYwcytVSEtW?=
 =?utf-8?B?YUwrckJxemU5RElLdGNua1F6a0Z6SzNrbitYRVJWN3NEN2I4cXhRUVVwM3Ry?=
 =?utf-8?B?NXI4SEpMUEdNK1phdjNXZERCVmFQTFd5Z2Zramd3ZUQ1MjhnTzZPUlc5Y3VN?=
 =?utf-8?B?NklRc0FHUDloQnBLNVBMVFlvUmlyOWVEU2czUHFURUN2ZkZlVWFnV01DYlNX?=
 =?utf-8?B?OFhOT01WS0lUVUFsMUd6TjFlMW1YYm5aaWlZVFoxYVJKZlZHakNJbC9rdnY1?=
 =?utf-8?B?QmRDZGRnVHlSaFRQMURra1hlSk9TZllZdklGalFodmZZK1ArY095UUduWEhG?=
 =?utf-8?B?OTY4TGNUS3hrWlovbmkwVUdmbWJlVitrVFpNMlExcU5uZy9STDI1QTFaSGdE?=
 =?utf-8?B?ODFGcVQxZVpjLzBQKzYzWndWckR5ZGNkZDJtSFoyQ0M4cncxb3VKWTg2d0Vr?=
 =?utf-8?B?ck94UGRLV3hQcUtTd3ZYcEd0RXBDbFdieWhQellZUnNlajBPSlluQzFvOVJ3?=
 =?utf-8?B?Ymh0dUhJbGNUUVp3eXZxT2JtRjRiT1dvcWE5VVdhWEZneWg3eFdrV3lqRFg1?=
 =?utf-8?B?M0krMGEvNnNIVmkyTUE0QmR6ditnUzJqdUVYY2kwTTR1QjI3R0pnOGpzc291?=
 =?utf-8?B?UElOWlkzQXZJdy8wUFhGcU9SeXI2RDBjTnF3d2FUMW4yTFIvSWJudzRxWUVJ?=
 =?utf-8?B?U1ZMSGZFVnQvZlVlZWl3bjN3c2lJc2EySGxqRllGRXhCQnJrRC9QdDRqRmcy?=
 =?utf-8?B?YnFJdEZJUFBBOHB2VmhnUjRkREVJWXpFNGVMZGtPMmdZTkNMZjdrcjRBeTJQ?=
 =?utf-8?B?WFovcEVCT0tvUmdtd2JFdlNsQUhWcHI1RERxY1F3dVJzdnRNM1ZYZFoxZnMx?=
 =?utf-8?B?NWNXbFBiYXpsQmNjWGU2RXYvdk12T3dKM2VscklzZWM0NkNlVmNoQ2JSMCsy?=
 =?utf-8?B?bnQzUXhncy9sRHh4NkJ6ZnhrZC9nM2w3RUZ4ZTN6eC9VZFNVTjZhYzVrc2Vy?=
 =?utf-8?B?ekdBSWJzTDVuY2NJLzRsemhjMjZpSUlRTENWWjFVelJ5SFQvTDZhdzF2MVJZ?=
 =?utf-8?B?aFdha3NwWDYwbXV0RFpkMkw2WDR3VGVNZUNvTFZZdWlRT1ZyVnJheitQNEgr?=
 =?utf-8?Q?zY6FjYs2VYM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWo5OE9EMkNTRXRITllFaDhtS25nVVN6ZHQ2TGtGdmNYVXdLRW1iR0VKNHhF?=
 =?utf-8?B?M0tGL0x6eHpwRjE2M1I0ay9PaC9sMkNEeXBvNUxXb1JDTkVkYmNrbWNJajFv?=
 =?utf-8?B?S3ZFRlBTckVhVmNBb2VFNnUvb2xQSWRyVFNHVkM2djE2bVBPTkpKWmRoNXQy?=
 =?utf-8?B?ckVIN3V5cHZZcHBwQTBjNDFPVEVlT3VqN21BeWxCeDZmSlR3MStuZ0xwK1A0?=
 =?utf-8?B?d2tydGtyaCtIYzFhYlNtOHliVm1QdUF4Vkw5S1pqdUMwZGRic29FNVc1YUVQ?=
 =?utf-8?B?enVUdzAyRUNaQmNwdGtoZHMyd2c2WDBXbytCQVlScEpMeVlQeWEvdVV6OG5K?=
 =?utf-8?B?UVlTTnYwenQvcVhnTWE2MUxPQ2dNaS9Fak5mWDN0SGJUMEZhL25YZmQwV1BM?=
 =?utf-8?B?OVl3Ulh0ZFlyTS8vNnBLRjFrd2hHY0tLUFAyOVFuTHpEekllR0p6cTRacmhF?=
 =?utf-8?B?UlJFVTA3d014RDN2aytpOU1lajhEY1BXMlFNQWpQRmllZmhQS095cDRkRmJ2?=
 =?utf-8?B?T3p5RVA2WDVxczViQWVxeWZIT1JGSmkvWU9jUWlMYnp4ZVhOUlZZYmxSaUhl?=
 =?utf-8?B?VjNrQk1LUnkvdTRIYS9zQlZyeFl5SjF0aUVaOFgwcFU0aDV4ajJVUGQ2ck1V?=
 =?utf-8?B?RUVwTGtBOWNuTmFyVFpITCsvcUtSZlJCaytDZmRYY0tpOWpnM2VhbEFPYVJE?=
 =?utf-8?B?YWtyRHBxK1NFeFY4dXQxUEtmQkg1UmVBUDBKTStYcEl6RUVveENDWEtiQ2Rn?=
 =?utf-8?B?TTF2T05QcHE1RDJlQ0xOYloxUTZCdmt2ZUJDQmtSTkxsMXdrRUI3eDRzY0dv?=
 =?utf-8?B?SDRIT2N3bGRmUGZucVpHRnpTczFtQkQ1dnQzTHpQZ1Mrc1ovbEp5TzM3dkZX?=
 =?utf-8?B?aGsrMEdNNTlpYnpCNUVrQTVoVW9VdjhsYTM2dzlNL1UxMlZNSFBiUUJmcFYz?=
 =?utf-8?B?TWJxbjRWNGtmazJqd2MzcmI0YXlCZC96dWtJR3d0OVRGRlpvRU5iblcrVmN2?=
 =?utf-8?B?M0hTeUlVYkZNQzhKWnYwRjBoWWZacGxXbGd4a1FnSWMxTkJHdnhPSTFQUE9q?=
 =?utf-8?B?bGlvMXh3SWlNK0ViYTRCdUF5UGhDR2x0RDVNbG1TOEdLT0ZFOWRuM0o2VkZE?=
 =?utf-8?B?QVFHQlowYmlOaTdQbnFXVnNJUWd1OHY5MDJwNDc1UVppTkhlcXphNUp1NUJZ?=
 =?utf-8?B?SzhySVpwTjFJVGRIdmNRSFV4SDd3dFlpL25HSEtGTmZ1VndUMHRCYVhNdkRS?=
 =?utf-8?B?ejdtdCtHTGJkTk02WkpEcXcyK3ljaGxDUDJ6QjVTbkYyYTB6dzk1eFg2TlpE?=
 =?utf-8?B?bVZ5dzdPNElIdWtlcGtCSzhNelNyejcwZlNIRVRCOG9qc2s2SlZlanFOcHc1?=
 =?utf-8?B?eDd6WW9Fa0xDcjZWWnA2Z3FlcHNBNmVMQ2hOSkJqQXBCL3E2UWZMME1aak50?=
 =?utf-8?B?dkIySkJ5YzY0dldtTVpCclE4d1hCQUNrYjNzbW52M0ZjM3dLM3FacEtoNHBZ?=
 =?utf-8?B?dUlHVWFBTWptSlIvUUVoVnNkeDkwVEdZUUV0RHNWUlBkQ1ovaTVjcFRhUGFv?=
 =?utf-8?B?cEY4SndLbXd1OHJ1dzFXVXBSaW5naitzK1h5S2JHNklvdTdobUtHRDk4RkN5?=
 =?utf-8?B?TmJEUTkrellnZUFDVkRKZVlMak5CVUFBUXdUTkVzOUozaWdBNTJTRE9ZMkRL?=
 =?utf-8?B?Ym1IRWFHaXZRZnBzZllEOG5wSFpEVWZWeWVMb1BvN2NZNmR3K3R4b2hFN0dq?=
 =?utf-8?B?aDFVOFFoMlVOMmJqNjRiNVJhQ01IdVM5QjZnRTVEVHdCeStpUER2TnBKVEhM?=
 =?utf-8?B?Ly84djJFY1BWQUNwVmhUVkI3RmFUSm8rMjI2NFZ1cm94Y3I2QlErNU53L3pi?=
 =?utf-8?B?czhOTW04U0ZPSnVDOWtaVVltNzM4YmNVMzRWVEtqQ3R5Q01BczJ6NllqaHor?=
 =?utf-8?B?TDlQWE1DNXdnZWx6WTcvVjJ6dmNZQTFHa1J5SlZWOW1LUHdRVE15VEZBRnRm?=
 =?utf-8?B?NXY3Mlh3M2pITkd1QlFsUXZrcWx4dUMrYjR4THdtdTRnSEw5NGZwR0lleVdX?=
 =?utf-8?B?VUNkbG9wMldVMXlTdm52Y1hzQ0pGVmxXNjVOcExndGYvcUx6RHBCMklZWmpK?=
 =?utf-8?B?UTRpYXpkc1RnUkkvTS9ONHRXdHJZcUlOWVBISzNBaXZhekxKaGM2MTFGSnRs?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LtiGkLMz+9QrU7zt5E697k8QIlbxzCV5cxGbFBTQylkOedKxC5OY4fimyUeL0apadT7DndLXbrmAnni895ufp6Gfj+9rTqBkCFBEIVTZA0mTDiEhrTbiiXS5UDYwbP33LOkYGl0xS7KjPtpYCiREW5uTF0bgpL5p4/MjkfEvtZD/6d5LkeeEQQxQCYS88uRpBEcsXIDzz3tTG/m9kMOZ2bmhhG4ci0Q4zOIQzG8SybfZrqQgFXvwEkRx+xFS/FOr/tyDBIMKAUuJ7jaUm9Q0OgDLGMzq9r6lIOSq8MfIVXzDq5IHHL/jCBOWmSGi3C1EFFHFwMnzyOMgZt5SbojGbWnDh2sdE3KO12RtdQPfsqXHlq5mD1mm0FCttcTzrVeJqL94iEFWtaFVNQxBNuD8MD8/Vdi5IurQ8R0DYy3Lcb5mMm2TkrKUsDe7eV9UADeTxSYEaVLKVOR35jbTrGoKmogS8sQrCNfXh3fVNC+iynJdl7dqnG6etllIZf4xTlgGMGmIXJ6XXyuqT+i0gvn961EJLQC3BsE1ZuU31xg4vjjabLcxP6gqC1ALxkFzhgj4vStr4mbWb9xvTin93AwqT09apZO4vIh4C/o9TaUZAYM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1773d45-863e-4bbb-14ec-08ddafe75529
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 10:43:46.0520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQlQfOneX6qu2vXZKvEXsLv9ZLBkO5InmLMQvmROgYECMkC9Z4+IE7hAbgPoSiYfRUDMHxW9lRg3BSGMZ8KmqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7838
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_04,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506200078
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=68553b66 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=k6aI6Z0B8vvFVdieJA0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: jPsCdHIfmmbVxM-Ys8aFMbpqfcb3OAGB
X-Proofpoint-GUID: jPsCdHIfmmbVxM-Ys8aFMbpqfcb3OAGB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDA3OCBTYWx0ZWRfX98aCPc0Pa78z 4KQTh1ya7yk5znE+HM2GRPY+0OyZzcI0Ljj9+uRiA9N2h6eKDMJKCTdZZVaWcF+ijoynxrsf4hp M4otBOtx6fPc72ANPIQDXZXwL6TfY/aP2QckNmmXvaqFGTn1MTw2XOz+GK52If5vFm1Oq4OrjFc
 xo75RQUTXIXeEZktraH+jXO4106FDyiS7inzXJHSFrH50OtSkJGAH0muu4VydnZtwy0HznxB63H Pwsnz3YQzjjHDqoBDmfmSIxdVLM8qq0N2jbUmkqc6YWqA/s1OH8NFNC8DfjvXpIMyLOKPQPwJdl WMPkV83fhbbO6ybmTS4eeExlmQ1SnVxnBb4L1HKHu7sabMnteXSIiORrrgpY4blqsf4iarni51D
 6UA5EHoVefC7mBW1CfkeozqeaiWNLMOdqn9lsF9jL0qe6Mpok5wPKoiCiUfKLvf4v6Du98uN

On 19/06/2025 20:35, Aaron Tomlin wrote:
> On Wed, Jun 18, 2025 at 07:49:16AM +0100, John Garry wrote:
>> BTW, if you use taskset to set the affinity of a process and ensure that
>> /sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU as
>> submitted, then I thought that this would ensure that interrupts are not
>> bothering other CPUs.
> Hi John,
> 
> I'm trying to understand this better. If I'm not mistaken, modifying
> /sys/block/[device]/queue/rq_affinity impacts where requests are processed.
> Could you clarify how this would prevent an IRQ from being delivered to an
> isolated CPU?

If you echo 2 > /sys/block/[device]/queue/rq_affinity, then completions 
will occur on the same CPU which their originated. And through taskset, 
if you keep the processes generating traffic on a certain group of CPUs, 
then other CPUs should not see any loading from those same processes.

I am assuming that there is a one-to-one CPU <-> HW queue relationship.

That's my unverified idea...
