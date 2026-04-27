Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C543539B4BB;
	Mon, 27 Apr 2026 08:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278428; cv=fail; b=nMs+5LYMx2sjKtlxI/+m5WZoMEKr9Qu6kZ7Xn5csRtWr2KF1YnBdU4IhahhfCdn113QxS3ZEqpmabEYlAiExtEV8Mr2zzwNJjan4r1sE3FlO/dR8dUYEQsCO6MWDo5kdrEk32UnaK9mjpVen7vC5Zv90rhcYfXFbiVDefME0Pas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278428; c=relaxed/simple;
	bh=W9Bme2RAOQ59J9klb9XcyyLYxtU1tQnWwBInRP95S1w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N39/YqdbIdrsUqgK/Lq2ZWKzp6T7x0ru1TRpe8xnpBL7HaMA2OnHmsQEQXJUX/saGjxDLKIWnz0oOaWb1KPssYnARfqZ9f1kD/pV220KyMVQA5FxTFf5/WQF82c2byTcVuwGoNsI/3VX0aYpjJKx23/Lc1ERBtaIwsbLJvHf97E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q1ooiWw9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XlztQxkE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q1ooiWw9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XlztQxkE"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R0gahH3933176;
	Mon, 27 Apr 2026 08:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qSnqTMplrwjUa6lzwDbEfFhZ7k84HDSWSNlBXTgSfYE=; b=
	Q1ooiWw9jK/MR6wtba0sXnVruRtqMa7+sy1iHuOqto6AayaRQd5OAlBMFP98DsJh
	X6SOgYn5+/xOEYgHsTl0JFE9p9QwCZ32Mt8oVu/AvUW3RkLeHJPIeWqxOYUvh+so
	otRr36S6bg6A2I9AYwVnW6yXDyy/DQAb2XM+lF42smqtFmBkeWCQdagQMMjbpVuJ
	ztVOEeJpBVKxzxBpHMhpHR8MnbVIbQyAeeU6l3D9ppCG+CrW36f/PU8oZ2oM7cbZ
	KmA9qlMutdv5IJqQ55VqliNyz7FbcN+Bl3yVCnARsZmVttniTj2ei+YwUAJamdQX
	1uQFwt3TAC2b/CL/UhYHmA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8anf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 08:27:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63R8QF9w006213;
	Mon, 27 Apr 2026 08:27:02 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010003.outbound.protection.outlook.com [52.101.56.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2a5csj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 08:27:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3gDhPmE0AVuhvxbIZDdtBxhLO9ekT37YeMCVTa9h0sMtNtSKmKG5temEPCPtze2zJPG+g1o1qASZp7VEH+AwzL4u10KPevJ16HO2AMhbPptA31k3Z0y+G5t9SRXGrkGs+Khpk8pgLrdKx1TzXiVwDmTN/83V3m3zlDSN28Ptn2EojTgOrqtYuK4dqMj13HwbbpxItH+QFQNYJEpMO/BZLYG9TH8+LX3yL+7jjbVGiu/Fhg9Hwgvr3TJZvC0S8x1QqK4MWneUpr76AgpUAL0gH3hTbIg1RsTEFCKUVzNFMLDMTOJjNX+Vr84J6WmLak/3BiExE4V9oCmQFuMzHs01Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSnqTMplrwjUa6lzwDbEfFhZ7k84HDSWSNlBXTgSfYE=;
 b=X3+Z0s+73aVvLXhDLlCRKQu6fCfye9D+RrMRfg7HITPh8PmzwfrYHC5YEXmQorr3shKsQ8kQ1m6DL2mVhA9GUq/YmJzvPJz+YF7U/3GTxUcLjMxwzow1/mmqL5Me1BYjqa4dbBmCIwFNcgaU+aE/zcy5fLnZAlIKBuHWGdun267gGbFlgcHKbLJEf1WZNy22Jd1Xf+zL1VbjnCwjT9vLXJrMcSXaec4ZlUe6f7eNk4vKyhlmDClwkGmW3yx6ctLozBc4h68gOJcWXoJ4QHIkIQBZJiLHmp4VnucIbp7bnx+zq85Fslu4mPhS2bjfG5wglXHhsjxLz6rgOyUKzf7p3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSnqTMplrwjUa6lzwDbEfFhZ7k84HDSWSNlBXTgSfYE=;
 b=XlztQxkEg4UUoF5AuTKTBd5jroPyZxYxs6BApKKU8sYWjJJo5dAbVAicpVsk1EaLzCX1whMEvYLDVFx4mm4rQYE+PdEJHr3Y45upMATvRHaFfbqmhSYhsPjH1slrBpD/N3QPH6I8ZM5qnAJOR4JC2XQtJCwms8LOgkXNAbgvz7c=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB8055.namprd10.prod.outlook.com
 (2603:10b6:8:1fc::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 27 Apr
 2026 08:26:59 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 08:26:59 +0000
Message-ID: <4fa5c202-e884-41ce-8160-f3dcc289293f@oracle.com>
Date: Mon, 27 Apr 2026 09:26:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: scan: allocate sdev and starget on the NUMA
 node of the host adapter
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        James Rizzo <james.rizzo@broadcom.com>
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
 <20260420113846.1401374-2-sumit.saxena@broadcom.com>
 <a27a04be-6c41-4d7f-b697-b04c4fe9dc8c@oracle.com>
 <CAL2rwxr+7tD1BfxKJCn70wyPT34=sfFMfUNAV63SAW0BxQ-0Ug@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAL2rwxr+7tD1BfxKJCn70wyPT34=sfFMfUNAV63SAW0BxQ-0Ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: 912dccb2-8255-4fc5-0a47-08dea436bfe3
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 I7v0EDw41tWb+thovn+EMSD0BFKOL0RP3xtHweXQgYTsL/EF83BQwwUZZk1jiN+Oq7KORikjIoteYZiWKYoy5aAiA/HahtSQnzHxzskEYCufbWRQbSKrg4KJWbzTJh4R0vBUol0YnceGyI2av3gVGUExa+v507p+yJBxm68hMr9jRo2tU98ACUDOv1/ZtEVMe60CqRbVYZw8I7PJlVhCh9pYPCVIPbTdC7H3PYA4/Ehu5Oegdshm+eva4m0zsS6geGLd0aAwz7DztFU+Ib3scLP2RjasvLQ8QTTt/RF2uuDTPPNeEFNJqlceZRp0PE0jNO8gxM5cJxgA+yPgY6h6kdu4OcLJdHS67XQX8pM1Dm+gExZ2O4iuwjruYRsTYhS0wDOGjUpmRRQrsw2FjFCKqtg/xDfIgRdDyoY8ffdC55wXGWAmfYWCQimSC9cXsWuxFSWIzxbSToj8PKFnalrpgWvkmHAMK7++7fXdkwao/TgLmUMtRmHXD1FJW+4eb5uUWzRy+UEXSSchKV7rVMsmlP8M1krOOZVIhk6ZvozZnsES8DbFVji3A1SImE6CyAfdifkVgUDTG6tQ7x3RPDrLUqQkwNo5KxmR90JDvmIQ0jbLVOil3mxivWNO5IogyQqFZlzz13UT55+b05DhMDXs4/bK51GyAylCF4B+0dHzO8rrRLFq5zU0wpPciQiBL7wANTcebzFkrKXzgF8fnzyu9DPY7zgQKvdXlyWrzXT+qP0=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZjVOc2tQN2pQSjU0UHhPM2JMTFNzSGF1OUNwaXJIaG55T2ZyZVI4NURqSm9O?=
 =?utf-8?B?aXNzQXhpNGF0bStHNmhSbWt6R2JtVmNzZTkvc0xNQWk1NlpEMVVrd0RRVFMx?=
 =?utf-8?B?NW1lakliTnQraVdoRHQ2eE5TL0p5ZDkwSkxtUkJ0bmhpNFc0ejdWUjBrblVh?=
 =?utf-8?B?ZEVjRkptclJ5YVdZVE1SVVdGTE9XR3FzazZFand1L0NnL0JySUw3ZGhuamEz?=
 =?utf-8?B?TStsSUFHaVgzb2g5OUtOblZLMUt6L3FLMmFrVHBHRi83WmtsTjRvZE9hN3Bs?=
 =?utf-8?B?bFRTdFNXb1ZrTjQ5VzB4dlNJSmJpQXY4SkxsRWxwYkZDZDRWVVFMVDR3UlZU?=
 =?utf-8?B?NDY4MUpacnB3aS9oLzVEVmprc1AxNUtTY3BxWFJiYldrVkIzZHJDaC9wdDEr?=
 =?utf-8?B?Vityam9kQ0pRZWdDb3FXYStEb0plRitvREhTMS9TYnJrb3FNTk50TEk0R1BK?=
 =?utf-8?B?TzEwbzZnRTE2ZHhlSVdVejRUWFV3RGQ1TTIzMVV6QXlMYjYvOXdzREk2Z29L?=
 =?utf-8?B?TnA1ZFhXamcrUXF3WXovSEkyekJvLzk0R2RsRVp3amVMdGNpTG93amVWeGFk?=
 =?utf-8?B?N3MyUUhUTkdkWjRvVTA0eTg5THYxYVBaUE95NHltOTE1WHpiZGJmOUxManRX?=
 =?utf-8?B?amRMR0E3TzVHUkVnckxqR2JiaUlSV0ZtKzh6NTNsYkJwTlQxWDEvLzJtZjhx?=
 =?utf-8?B?OXp6LzkrNmtmcFJhVU1pL1FSWG9YNG1LdUtIRnZtbnBPRVNSTWN2UU9hMDRW?=
 =?utf-8?B?TlF5L2FIOGFzU25YbXFpMEdrQk54dlRPY2FtNVgvSVBsY2xrWkhpOXFvK0Fh?=
 =?utf-8?B?YmRzWDZVdUhQVHdKLzFoWXYvZUJyc1o1TTBsWUIxeGU5Wkw1WnQ5WG41czRG?=
 =?utf-8?B?elUxTVFSdi9zUXBDMjB1OGlOajFJMVVmcVNsVS9jeG5EdTRxbE1rZVhmZkRw?=
 =?utf-8?B?dXpxZE5rOGgwMGhNWmtPYTNSQjBkUjRoOEJVREd3OXhteU0zdkdSU3A1V01P?=
 =?utf-8?B?UmlFRlk4M2wzR3d4K0Q2SUZGWXF2SjhWSFh0MFlCVS9XT3E0QkpwSG9wbE5Z?=
 =?utf-8?B?UnQvM0ppeFFHeE1id282eHcwMlRBaUd1Z0dTZEFENm4vL1pyUk16RXVUNkFS?=
 =?utf-8?B?RW5jYkJLVGlJSXRSdjNZODdnZVJoMkkxWnF3YXVrdVAvRGpzT05YcThIQkxH?=
 =?utf-8?B?L3ZBUzJWbVBxN3lUTnlSZTZnVHNIY2JxRTBjaVlEKzJuN25WdmRwZ1RkNmwx?=
 =?utf-8?B?M1UxeGdKS2xFWS95akZaNXBTUURIT3duRXp6QmJ1OVBiQlU3MlR1a3FVSmlR?=
 =?utf-8?B?RDBzOU52MS82UExtTTkrSFkyVm42RWl0bW1qYURRZ1NiQlV5aFV3L0lNSEZi?=
 =?utf-8?B?RDBWdDdjdHREZUR3MUtYZzh3dzhFVVQrMlJ6aXNiOFlaS2kvYnl3eVZ0SzFZ?=
 =?utf-8?B?VE9oTVVXRjdxcHVRMHFVMk1XNjdLZzlXb0tWSWVnT3JCS3pKdnF6TEVnRnlm?=
 =?utf-8?B?MmNxeWNzOXRhT2k4OTZ3Q2xoZE5Cc2YzUkhPQ1kxVVVHck1NYkdpOTI1bXY2?=
 =?utf-8?B?SzBoSGFFL1l3TU5xNHNHMWx3bEI3YytrR2dNSU90V2x1amRUaUlZbkhRYURi?=
 =?utf-8?B?Z0ZSMDE2RWFIRGphd2IyVHdqWWZuSXFQMkN3YUE4bUkvU2tUU0c3RXloYkVy?=
 =?utf-8?B?TTZDR0dwY0xuejUzVm9lZU15LzFYN1FVa1ZxT2FtQWxUTjJGRktXT3lVQmNi?=
 =?utf-8?B?bS8yT1pjSTI3NUF5V0M1TEU0dWxPenJETklDcTFqTy8xQzNkNUZsakdtRHZ5?=
 =?utf-8?B?NTJPT3VyT0hIS3FtUXJDRlRrcVR6KzJQV045WHgwRTJPTnlsaVZZb05lZU1n?=
 =?utf-8?B?WXZTRzdKeTVlWHlzN0VKaTlpT2UxYlAvcnltbDdoQmJOS0dsemd2TkFIajJt?=
 =?utf-8?B?OUpTUVgrRkxENkswSkdseDVMdlgxditFQ2RnbGdXSHZFZGVxalF3dTUwSkhL?=
 =?utf-8?B?cnF2YU9FU1FkRVNQUDZOYjFQZWZMeEI5Vk9vQlJEdEtHZ3lrUi9kTnVnaUZT?=
 =?utf-8?B?SnJ3SU40Ty8zUFlkODV0LzNPeGtGejFyNHI5T00rNmJkV3ZjN3NhNE5Wd09T?=
 =?utf-8?B?MGFKamd5eUlhZGFOUXVISWJMNzRoWWdJbHlmMmdSK0FvTzBjTE56cElpZ0pE?=
 =?utf-8?B?UEQ4dGF2RzJtck96VFljZUxtREJMZDFDTDRTd2xQdFYrR3BaSThJUU9XR0RN?=
 =?utf-8?B?Qjd5Q01ReVZ2Y053cnBYQUp6K1ZKRjA5UmRTMy9JYXZtWVNpZEppT1p4M2NZ?=
 =?utf-8?B?NXZwS0IrVUFqQ0Y2YkpoL2lvaC82K2pLVkkxQW82YlF5Z3BUb0MvQT09?=
X-Exchange-RoutingPolicyChecked:
	GFVhrI6lM2v73K5gCXZS64IYKMOnqKAIc4CJPzulzqfE5q8zmtYUTb8/gPHpz/Vghu135LZFuKcEbycqOFXBCoBI3/nxKTM871F0IRs/xs82+tdW/3Ehh2VLpOeTsn9TXlxl6lmB8vZUEmnzecwfUrqTfl78efLosaEiNWy+WsUPilLDdFg/7BIb6ehaQ7NvDORcloS90Fg8RxOpetsZwx0lBuB1g/Txmh+7qWdCM5JTMGjenj2fPdG9Kpu8JWjK+xOsM0TKtV+HL8hIx/yZkePHVWrtSHUmn9JwqzKgMhMQuJ1qndnUFPJgCypovYF3lDrW4EFKKX7gAzigoQRsAA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fXa2MkxQ4+OtzeyaCcdcNOBlfol0q8ByRSua6iLRXQ4EOTX6FIbcHvqNkAa/1WjItThNDermari2NJj2LLmQuzjCkiW+ktxqVjn94bZHyD78y2kwEHSwMn5VvVyW30DFXXZ253majk3ncez4+VWf8uLEdXVCKfaT2S+FZq1Sgh9bJZJh1FRsAf/muSArnTda0B1nXA81jXJ/ayDl/QZHrIbEvMdH2aXEB40QUu2h9yfFyi8FB8ihesj/9wyQONzjMlcPJ08IV3ntvGAC9z1dNFFFBhcCU6+SdZcha4QtHpzWDLkRmT+y6aAMghvC4pL6NSij2VleUbfXOEOQeHmmsIhnn1RUzlBiwdC0QnouxlzrcFBme7GZCPDrnrX2Hc8/gMglA4OCQav+jKG35othlR54ydRjCqBH6YoourbD5uvPL0eccpYVRujkjmLRuqInWKJzRTiTEY8jwpkTxQhYPqYYFguu7ZDMgEBmiZ1Lyxwk6bT72wcF5x6Cy3HGJmgH7mgN5J0SGu51CnAgufSme/pnysg3N1igrZ9V3byN+32QFybITATUJT3I6RTq52mVQyP36BlKfKvFxRLkXZOJM+O/sNkUvD1QjHZaGCzGU3k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912dccb2-8255-4fc5-0a47-08dea436bfe3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 08:26:58.9291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6RnOitvnY0QWmAs2Pgm512bO+ypojVIXLvtq9A2MpG2AOIGwTm0Lhs/RSLAM1y3a1MwE34TnGpcNT6a5ajbRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604270089
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69ef1dd7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=7Th0mAUQH2o99BY8fMwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDA4OSBTYWx0ZWRfX7ic77SNOWYiG
 DohBEe/LHdCREjyY8dGWATw7PryxoHKEYjbnhGpgCi3h82ZzKJwmj6DIB0XkBhtB22CYB3YTV/e
 5qEYpWnTv0qi8a2AmYVTaWaXhcTFXX1wOKxqyHvWu5i82tjJk/AvbTB87ynV1DcaChKRxVqoyRD
 9Ux+UlxEQpv45lcww65iC7ZAeK2OrkwD8UL+az1jAIjdBUoIyvkhXP1An0T7wp9AsflY4LflXHV
 c6/AbZdT+S1AME37cjrvwbV0gO0Jq7PsQwAM9jlk68ACY3DbV0lqP53w+zSCmZUAm0wAhp7YYNz
 epTIH7HKkjIT7XujOd8FeXgbn/+198k9likBrHEgklauFsC2FiMpTIYmoGnS7Mgtd5BCZdvSSJv
 aNNH64EZXrMpTOvgskxUaA8+bIwnZGNzqODFROV4GaPTvqji+QWOfXtkWxPzdUFhQ3kTquxqse4
 xZ1WwXMqNSG4kcPvdINMh6eePQfqpRfY3yqh9W+s=
X-Proofpoint-GUID: UQxqrLqc4NWS05-XJANofv4NWeKj2rzg
X-Proofpoint-ORIG-GUID: UQxqrLqc4NWS05-XJANofv4NWeKj2rzg

On 24/04/2026 12:33, Sumit Saxena wrote:
>> For the actual shost allocation, we still use kzalloc() in
>> scsi_host_alloc(). However, shost associated device is often a pci
>> device, and we probe pci devices in the same NUMA node it exists, and we
>> try NUMA local allocations by default, so nothing is needed to change
>> for the shost allocation - is this right?
> shost allocation is not an issue, I will drop changes related to it.

But you have not made any changes related shost allocation and I am 
questioning why.

Further to what I was saying, even though most shosts are based on PCI 
device, not all are and I think that it is worth making this same change 
for shost allocation.

> The tests indicate that at times sdev and starget are allocated to
> remote NUMA node.
> So, I will limit these changes to sdev and starget only.

