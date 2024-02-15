Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6548639FFA;
	Thu, 15 Feb 2024 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708015454; cv=fail; b=Bc2VmDw39jAlEE0uSaNgf9Br1hZZNRPTaaJDMZ4ADRwCHLAyQwLVEvhIdMiwwVMp0pmf5raY0iBpxt9Uc9wvGRMaTl1ZQgiC7mn4atKPWHW3pqtWnA33Dy64hO11lzhJRGQwDrokIustej2WUbHGSb0d9okMEPGpWpcW98InoVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708015454; c=relaxed/simple;
	bh=TO7iXZM0kRaEOkenxkp7A/l3g9FhM2V1LhALGllyFf4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r8wTB+R/s97Razp41U4JhMFqEc0PO5EDtFS6/WsC2BDpzPGnHAdlYZIrcLc5CVE/ebgHpZrYN1GseUWJmaJ1ZM1OecG6XtKSuftoKdkzSIhX2glIKMYCRWRFegU5isQxaqi4DRA5jc/cz+z5f9zWr0QNcT7O+yTpLi18gkony6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jhfSWSzm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZHN55Fe3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jhfSWSzm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZHN55Fe3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTTHM006082;
	Thu, 15 Feb 2024 16:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=MYKGRmpg+pLYifeyM4CrK7OwWVdCCfG5ORu60qd/uec=;
 b=jhfSWSzmPq8Gq6uCQinvRbOm8KypJAHMq64Wxh8ty5ZlJumEXBpNYcCt5C8DRkjMmzyZ
 PHJyAA2Px752CAU3Ikt1zs77nokHiWjGSHi/NM8ZqYPl+fmnYvNGkT1+ihwbdmgW9Xii
 qykjesb5zy5YjHWG29zx45MqCUuko8wMdaL9geAA+VmG4JdjXqOWoKMcr6qVLEqR6jWw
 GjO8Qb/OERL3QcsDRmLjiUQpXL/PXuQA9NhBkTSzXj/XiGpJ6XtQ6tVuBC3xXq8Zayco
 8Rc96+HW/M92qIqaIsgdER5UowbtlMY1ZSEemidJxe+8jhQhTLEU6Ly3WnTaragn/9Vw MA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w92s72n4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:44:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFeg8X031673;
	Thu, 15 Feb 2024 16:44:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykasaqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:44:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNZaGFydLoZTHWBeTDHCW1cIzqUwRj1cLHRnENJy3mPsgzbxw2PcoUHP9N4JEjaAT+bk1zPRBRDVPRFLndKFse46DmDQosv2VEmpqBU6daJf1HYs+gQY5ic7YFVbJSU0QTC/iWcUh9xRJZ8XS+XWlpkVDsf2Y6BldzsvD9BAUPDSbbWhNYQw6w5jIxjG2kVtJ3nNVJsNCjqXpnZwUpzGPz2q7dGaVTnUjYg/10A3AsGcdsPr2hWyTZCe19VUbE9ZHJIy7x5RAZaS29GrAY35M1YMVnE5J1dfPfAEHHGiLi89Sh1Ch4zRmTZK1tGtCfI2hN+7+Y9XxrYWh13wEBkCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYKGRmpg+pLYifeyM4CrK7OwWVdCCfG5ORu60qd/uec=;
 b=HMllS06KIctBqjyVCuNGEqYeFSEPZaL6gACG/29oxXqgEbO5YtEbfONxJ4c+vFCtCUpqT5jM6vuBjCU9g9R1fL+rXbqozIIPD3xLyKGOiNjw3vZdoErckGCF/UVaal/3R0E9dkK1jNYyhE0fZBrgDv51eKu9aoHhMOEFowx2UTJ+uKN/7sbSeuXG+cd8qebWYD6S8JqMqRw0WpzRiAPcf4wW5RzeJdLl+L8y3+LBDjMQi0Ap3gitP6pph95/wmsLfnKBBLtIXxvLU4f1RzGUMOJdBjO1HnJ/xxK0Aeu3CKOHqdrxx9oPeOJbVbYRwdAwcJGDCFYIK4gCepJsTfOSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYKGRmpg+pLYifeyM4CrK7OwWVdCCfG5ORu60qd/uec=;
 b=ZHN55Fe37KG3ZRpYkriOiZls572JTfuuQOo/78GaGF45DnIyMiJIDKCMGSwuWSW9T1Re0hj3RodG+QLN2kj5xFTT+y2VnF85hxOXAW4wG2pUnNkvtKr7JwDqAxle6USe0LfANTsKpIXfUYsOa7VkmkBEP7HPULl++/89iTGQOXA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.29; Thu, 15 Feb
 2024 16:44:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7292.029; Thu, 15 Feb 2024
 16:44:05 +0000
Message-ID: <094cd372-eb90-4738-acce-a3725dd2c0fb@oracle.com>
Date: Thu, 15 Feb 2024 10:44:03 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] target: fix selinux error when systemd-modules
 loads the target module
Content-Language: en-US
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20240215143944.847184-1-mlombard@redhat.com>
 <20240215143944.847184-2-mlombard@redhat.com>
From: michael.christie@oracle.com
In-Reply-To: <20240215143944.847184-2-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:8:2f::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|MN2PR10MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: 82c8fc20-39fc-4201-6bfa-08dc2e455257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JsALj8OB8nlYgdzKtPkdSj0yblchei6c6A5FMYAtzhY0qclVH8g1VebEVHEo6/TySTY9vL6v3EWo10YSxIKYDFXi1BehSotGzd7qxQcaSTjLPPPb82OibRcPjgk59i52T6ZxFzXdyEsv5rb3sGCls8/xJjlIUqjyCfCodCywcUAAVBl9sFncoOJ9rdHE/5aWoBGrPdUR2LARLtEnSnEYQbW/yY0iifQloJrHpgIC5RWDRqrzJ4zxMhusfxJNw4B4SP6ntsjSdlMza0YUSpqxbTJe/BMbO8aOlhiLAtnAeYpn8RDIqGtFnYiOfJucSiLXJqkPDjVj/n8zcTLeEyy+IofgTRvqg64YK1LdTmzsHEFw0r8KrMgYuxzJQH1p0hJuCHXwTaDasPhRsFF18cikVhbsdIVsIWhKv5KZxpne+ZodltU6AUQXjCIs6fX8H4j2G7etC5SvPCKoCOBVx/u7vmsMV8AAr5MKlVpuWdADI8ad8ZlhPi0yau3H3UvRLuMvwWCCszcQRVX3DfvJjO8zeIh2jR2z0jKzCYqILXE2DacyAncY5srNI07htUlncW5H
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(8936002)(478600001)(83380400001)(26005)(41300700001)(4326008)(2616005)(66476007)(8676002)(6916009)(316002)(66946007)(66556008)(9686003)(6486002)(6512007)(6506007)(53546011)(36756003)(38100700002)(86362001)(31696002)(5660300002)(2906002)(31686004)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dVVFdXhBZDk5Z3RwRXkrK1JEYlFqRmZUQ2NUY3d2WmFMY3lBVG80ZTdkN0lB?=
 =?utf-8?B?ZlZsbittRHc5ZTUwNkNMY2p0UVZpdTFaUWlTV1QyQ0QwejNyTlRFNlpLdi9s?=
 =?utf-8?B?b3d3ZUdXd3Nici8xVnVZWTM3NWNSeHpESHFqTDBudUlVSEg0RmhjRVQ2VkJv?=
 =?utf-8?B?Z3BSMDViaXIzMFl0VldCd0VySHZXWmUrYlR3QXR1Uy90TlN2ZC9lODVhekh0?=
 =?utf-8?B?a2d2Skozb21LNDc4a0dDL0FGTXRPb0tubWM5cENlMEtjTTdsL01UYUtHVEZV?=
 =?utf-8?B?THBqdWlrQ0dUa01OQWtNVWRpQnUxTmpIN0FpNzFkSElVWlZkZ1NFa0h3Zm5p?=
 =?utf-8?B?dUlsVlMwOUpVUWRsYm1YTnQ5WDZIMnRYOVZZajIxZ0J4VVhXK0hkUmNVc1Zx?=
 =?utf-8?B?b0NZa2VBQjErRzdNdXZxZnRZOEJ5QisxdEdwbSt3YVdPNzE5bXZxQWdvNTY1?=
 =?utf-8?B?cXlPRWVsZ0NmNFRROVhnMkhyQ0JDeTdzeGFCZkdQK3Bqb0lvWGZrSjZONjhs?=
 =?utf-8?B?Zkttbml0ODdSRVVlaFVPT21jTXRndnFvOFdEdVp2ZHFaOS8zakhVZkZib0ky?=
 =?utf-8?B?YzQ3WkU5S2h4TjQ1dmVtSU9yZTA3M1pkYUd4dXo4ZXRNYkQ0eTEzMWdMUFpw?=
 =?utf-8?B?ZnZNQ05CdEljYTMzNkJLTTh6czNlSTNTNGN6a2NTVG1QVTZZN3VIY2hLWFg1?=
 =?utf-8?B?R0QzRW12MnV2OGprRkxJSEdFeGZYVDJzblUwRDRpemV5eUZyZU9CWkYxcElN?=
 =?utf-8?B?SDlaUG44Zi82SWtOMFErSmRRZzN0UTllelJJY09oUzhXQ1k0T1F2OXZ2S1E2?=
 =?utf-8?B?azNxKzZvajFGR0E4dlVjVkZzcE5IejU2RzdYaTVOVzNBUlNEZlBXS3oycllm?=
 =?utf-8?B?RDhSNFRzYVhGblJKbVFERHh2eXhJcDZiZ3JSaER3dHI2UEhsMHozRm1PUkhG?=
 =?utf-8?B?aEtmVUlVYUFjQ3B5RHZSRW8wT09oQzQ5M1JTc0YxVmp4bGNSVXl6OS9FUVUw?=
 =?utf-8?B?RG1zbTNNOVRXcVFwT0lRNm9OVlZaQUJ6UEVsRmUrQWtsQUphTGNhZG51ci8r?=
 =?utf-8?B?S1l0Qk1ZQS9RMkFDWnFwd2NGNzJYS3hvUE1jMGxhV3FjZmt3M0pMNjhyVFBB?=
 =?utf-8?B?TmlwWStHWmJTa2xRcktpWDVXc2dWOGNlek9DR2tBRTRTWVdVamRpVlZPZ3JG?=
 =?utf-8?B?bUh4bVdaR3VvV2ZjS2JVK0VZZlI1SlhFYW94RVFBdm43cnVYN0ovY3ZETGoz?=
 =?utf-8?B?aFR1VGxYN3NFM3RkdEY2TllHdWxmdEdnYSs0eDNiQjRDUmd0eDJjVDZGZC9B?=
 =?utf-8?B?elUrUnZMUG1mV3dVS3VDaWQvbnVHTVQzZnpWcm53Uy9lakFUTjFBbEtDamhS?=
 =?utf-8?B?allBRjRDTUgzWVVQVitaanVWSDR1WTJpQUtia2N3YmNSM2FIUHNWRGwwSHdq?=
 =?utf-8?B?L3FHc1RIbm9CMFV2dlpVbmZMRHdSYmVKbWExMzM5N085cHVHblB0d2c2R2Ri?=
 =?utf-8?B?N0tXcm1yN2VNVHZDYTd6QXdmdnk0UkJVcWYwM0crZWNZZnZLMW5CZ2ZoaFpZ?=
 =?utf-8?B?eCtNc09WSmphUTRZb2dUcFZic3lZOTNFUGVKdkRPQllDS05aZGZ3QkpCS3VJ?=
 =?utf-8?B?MTIvck9kWm13UTVyQkNqcGVDcVRWSFpCd21QREJlbTNLaGNYbDRqYjI3eFA3?=
 =?utf-8?B?VlFGOEMvMVZRZ3VrL1FMZW9WUXlQR0N2Wko5NTJtaUw3dEtoYVRwRDNFcWdJ?=
 =?utf-8?B?Z09zL05Ca0doTGdFQ3hwVm5HM3Z2aSt0MmJHd2FrN3RWSmliVlo0R2ZPY2lT?=
 =?utf-8?B?UXJGTFRZb0ZDaTBLQmJmZ1Y2aTU3aFU5c0tFZlFQUjArZkRFNzV2dEsrcE9j?=
 =?utf-8?B?NitKeDRlbWZPWFFXVHZqcWx6Y1VUaTdxTk50MGlVZndXL1dNdFk4SnA1WDZS?=
 =?utf-8?B?S0l3L2xoQzVFc3NQV2JmNGR2OTBQSW9FbU9WM2xaNzNIV0t0VU00a3hHR2Nx?=
 =?utf-8?B?MndzRFdReHdNUHl2WFM4SW9VQzhRK0pKK0R1TkZ2S3JsRnNjeFJ5OWdlektS?=
 =?utf-8?B?aFIwOXV6Ukhaa0hiaGFsaDl2UkY2MDcwdVdCR2VlTnkzaEJRQ3ZlNllDNUV3?=
 =?utf-8?B?MHc4dXM5V0R0MjVOUFZQdDNIY201Z21vSTRvckFIN1p2aitFeWxMQng1WGF1?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mxVCUeu6CaOyM18ikjQ7H8jJUV2cqx0grgF6vxWeVrM8vi8Oa1Abgb1C9c12G8shJgSeVXxfvXvf5Ty37cjReRX+TQF3EiGI6Q6F2FRitHr2DUZXurP9fn9B3ZmtpTlmL/DpURqJTVm75mn4ckC4D/8xS3k/pVvKBMim5O8hFLtCyBETeRv9Nth5ICA6/P+/cm0b5TIqch0SEGuze9WaHv5vJdOHuhTE71uZ2caVXeiWA5ibGeGXsrgXsi2jE+Xex9x9OsYxHVAX+3mhJTgzOMLatIUKw1Kf7WYlwsEuD88hMBnbCGPYF4M+e6/nBl6OVM/mnNg6HycMz9xvSW+/d452NQG6V2+mRlkOsWWcSwkOtTg5lSYRiAO6iuHnZhG9S1YyyjNtWsYhI9i7WI1vEHuI8cX7y3CR3m+Sgg2jXvM2OhIeous+GMNmQmXvVbWE30q2Zsf5j9ozui9WbhtGI7CpxJEbIHooz2D9YESTwh4xlE56QZNo1MG7/Mv1IBb/zj9QaoutjKzHycjxjhB0VBYNvvhxTRtpjdxKdBEi2kFPaRxC28Vtds06tnGjFJKOxV3KrEoe6zC9sUY3fOFMyzNx0MSLspltW9KDkHR7C4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c8fc20-39fc-4201-6bfa-08dc2e455257
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 16:44:04.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6r1gVhCVricyChBX7WlFVaMIKdjKBJmXNHrjFIvp/TiWgo5Y/2vulHd9DdHSDN84biVWoDwflhrAftEQ+r9XgQSQ3nbsCfNWwrhAi9QGyss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_15,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402150134
X-Proofpoint-GUID: yx-kN1KdfcvkzfOzjHhLi0la92h2l8A3
X-Proofpoint-ORIG-GUID: yx-kN1KdfcvkzfOzjHhLi0la92h2l8A3

On 2/15/24 8:39 AM, Maurizio Lombardi wrote:
> If the systemd-modules service loads the target module, the credentials
> of that userspace process will be used to validate the access to the
> target db directory.
> selinux will prevent it, reporting an error like the following:
> 
> kernel: audit: type=1400 audit(1676301082.205:4): avc: denied  { read }
> for  pid=1020 comm="systemd-modules" name="target" dev="dm-3"
> ino=4657583 scontext=system_u:system_r:systemd_modules_load_t:s0
> tcontext=system_u:object_r:targetd_etc_rw_t:s0 tclass=dir permissive=0
> 
> Fix the error by using the kernel credentials to access the db directory
> 

Do you need something similar for the pr related dirs/files or how does
that work but not this?

