Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351047DF96;
	Wed, 29 Jul 2026 12:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327122; cv=fail; b=h8e3AWoDgT4NlvRQiUpfQcfOupu5F2en3N3Pqr2eIiSuq9jhJakMUvaMaB4KkOMjGeP5gKeJaplIT894FLgxi+hOa+xFNXb6j0NMQmiIkUykkAsoPvhMtTeEVrPBq/I0QIZf8miBbUF7LPOL+IlVfZhz0nVVG4j3KJCpNxD4NxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327122; c=relaxed/simple;
	bh=gbJYaJmndSmR/h69UsSirWtE+bUZdamMD+t5FUNDZ5U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dtRd/cR7RUCjqQa4NleQXG/K/5wcv6DENxgs7ZGL1/iHdE1DrTeSYMRm7cHFdlpv9RcHQ3I6mmbifCbDj+gCTzSneBB52thZxeZBd6D0w3jXzvOahr1+o2l3MbLw4YyvrzbhPAjSAY0RgNf5BiAUopungPqC0M+ZNznjkRqpph4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fE5FDpFy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SCbBaHo8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fE5FDpFy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SCbBaHo8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T3jXDf2192167;
	Wed, 29 Jul 2026 12:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=r/F3A4z4HZcjCPXiP0AIfYae0fxb/g4ZnfRMg9Qvmm0=; b=
	fE5FDpFyRAFXkosJBKQ071TBf0fid3w0QcC696VSazZwt+PpPm1qSaP6jRqTq8YW
	5rE+GbXMDSo6XLTSoNWLsoy8kJPSvkKSi+FgZ21p/Uek/SyF5a6bovsed1Wbd6NA
	C/0Ss2drqdDrE57HExvLx931MdGFMjjUvj3bPexiynHV/wKqHUQ+bZU0nFG5WvJl
	Pyj2KIQrnf/lRhkZDhNmM1h5F7Rec+EQjMaW2Zw1qqV/KwV2QknKHw+3NfY+Jo9m
	AbgxQ8yH6d/5zHITnFI9Cp9F8CYpGje0ZkmvrXwQtFv/4LH87OR9ophwhWU/6IJe
	4huZwtfNN0+ZGxNnxuga2A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pnr1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 12:11:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TC5TBl014308;
	Wed, 29 Jul 2026 12:11:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8jqh45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 12:11:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bun1FUdYAMyTghU7j28utS6YL9Y8NvzG2MAZujzPgdCAWXculbIGe9Po60QfcZccoDrwNkLCG6h5Rsxkv8tfCGPDTEsZ1lG2v23AuJDUYWTyUcu6ywIxpyIgx3vac/3nrMUjjs490GrEt558OMhX8i+s4pXVJmwToiQCYyVwpL61ghZuuX+VmcT5F73NcPjSkgQrlFz+OcZGzQ92i2+qwHhU/YoBWRNBFAe5ThWQTluKq2moprn+Z1QwLSucS7QtYUZU/Nbt/TZL/yttqnUEfzIpmQ0YiFPN00K/i7dClE7LopNB53jxyqpk7GJ7SZzNWGnZcpkgeGccqKzT4/9MuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/F3A4z4HZcjCPXiP0AIfYae0fxb/g4ZnfRMg9Qvmm0=;
 b=tKk2nfKPKHZrYOI4Zij07/i6FRnC2eor7v01sxG55AdcSNasiegedEKNT2ARJT3tWovc97hR/eO98vbK1+U9nTwmCJL/aLTfm6UlLB6iENhED/dmsHcTAPRXlx6HR2x8EFdIKI9LuSIF/RZFNKRAlYxNOQ4xHmPf8z0USeBGEiDdx1q0WqeiB4mduQnzXP5vxey2BpkKLwAvANk4AWjrUsc4Gqfb1A9/oL0qfiOsHeKP0QWgoZlqDcQJN/oQAJe4RWJkjoYuMtiSZ44FWzq8GXGvlBXr2qP8A/aB7cgxzWyB68bArIkERs/ouJGGJYsr2SXVzbbVM97RB9RlS7AG7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/F3A4z4HZcjCPXiP0AIfYae0fxb/g4ZnfRMg9Qvmm0=;
 b=SCbBaHo8AIL38uHihqbVm2dErubPq55mTYplpKK9nxwxxS7u8XXgxvLOECUokuys8HlDsdJLVEH29pnaP9VGjEjSERHhb5KWQIpXJXgAgNtsluAKIkumOrYaiJUhozHQ53fLvs4Vgp6qlGx8KccQaS1IfgVpDEDvO5XDpvZwhf4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA0PR10MB7160.namprd10.prod.outlook.com (2603:10b6:208:409::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Wed, 29 Jul
 2026 12:11:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 12:11:46 +0000
Message-ID: <a99a3404-d2ed-4a34-848b-8f0731634064@oracle.com>
Date: Wed, 29 Jul 2026 13:11:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/27] libmultipath: Add support for mpath_device
 management
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-6-john.g.garry@oracle.com>
 <20260729115704.31F781F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729115704.31F781F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA0PR10MB7160:EE_
X-MS-Office365-Filtering-Correlation-Id: dd266f58-252a-4290-54d6-08deed6a8fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|4143699003|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/GwMHBu7t6nDpnhfWR8NlxcmGAdmwcJj/nAHnRjMdUQyjDFOP6+xbuoPwpbWeZOsh71wLyUVO96j0NEOgQ/V/RNQunmHp9zMD14096HuW/19Ie1yXM8/AoasLq2hAXo5+3BlZv8wL3DpcePehLIlGonCS6SkMQVXxCoXEdyFkYRzrwA7zV7Cnl1V3cZUZX8p7bwrZwNhZYUYv4RhHqcwp55m2kd91j594b3kgI0imdBqm6xpw2L8LTKLJut78ucjIFngmmxu5vdZdZIzM1GRro3IR+JCQkZSNrYW1Yzq+WuhjOsTCnQyCvCOXpyij6amcohPzK6MXnu+rQUqA0rC4coaW9qSO5L5OBRvn6rlM9PvoOgAiRFIlMJCQTFeieFyb3jmB5Ee7VfifdcuszC2P/3oViQy8Cap8VGNm3fHNxe/Lm+2OYoLAWt0OSa2rr5jkTv6U9MoVyySqboElg0ekH+esOgYS/BhWFcKVdMDDuhQ28Zsg8/jGKd0vSh2rTK/IgiT/Bex0HVlwJDoWyriXfmzetMA0XqqACUflWDUmjmHdmSscIJcWfcaIs6OIn0FGbJpMf1OqFdjEhmxfMN8bmeZQJ7HpJfTMDx7y0p7i/n2vw0nTie/CRZZ7FMegzeGE7YpkrNJ4Zaot7uyyfJsTWG9sPzDWi2QJUo6OgVxYKE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(4143699003)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0ZKa2hUcWVXVDYxU21lS0daTU5RWk5Ca2Q5c211UlZ4ZWw5TGV0K29KTFhH?=
 =?utf-8?B?VkhtQU0zbmlrMlVtSVhRdnFSYlNselhkakExYlk5OWtIN1FCVDM4MFFNdGox?=
 =?utf-8?B?OXJrUkh1OFJHSXdaSGxtNE5XQlBNMTZEZytla29BZ3dmV01lWHNXVXJCYzlK?=
 =?utf-8?B?bU9ITTE0TDBpUW11aUF0TlVHSFY0eEVMNjF2T0FHbndZRHp4TVQ0NU5mQzVi?=
 =?utf-8?B?dmt5cTZiaXp6ZVlxbDVkNkhtN0cxbytudnJEUklpdytkVW8veDlPK2dXaWZH?=
 =?utf-8?B?cklXaUt3QjNEQmpnYTNsVGhIa1FvUGdxSkM4eDBIbWRVNDBtWXlHN2d4UWRj?=
 =?utf-8?B?UVcreTl0anNqSWZua2RKTjJFTnBHN3pzcnREeTlHb3A4bm4waVlIUzdjYjhJ?=
 =?utf-8?B?a2ZUL3kvMlVYb0RGT2xoaXBGak1JSS82ZTduMGttUEVUSmFEbnVEaU5udzdJ?=
 =?utf-8?B?YlNyK1ZZdVExUTF6WHFSb3BkemtlekxiU0l4MWZPUGwyZlVxMkV5L0s4b0FZ?=
 =?utf-8?B?VDNCd1VXUlZsWnVTZlc4TGM1c2owemU3ek96aHNqeXdpN3FiVitTNnZ2WkNn?=
 =?utf-8?B?MHpjRno4aGpEdnhTYWRlTzZoVkNKYzVwWHdabVhNa25jQk5VMXZmZmxrOWJq?=
 =?utf-8?B?akltYnppaTNHeU9aWlhwcGkxN3dMYkhnUHlNTTZwdXhPN21WUEh3Y0dTdXZs?=
 =?utf-8?B?aExheG0rR25iY1VVcmRKdEtwc1B4Szh0c0wxdlYwRmZzbXU2L05taXZqQnZz?=
 =?utf-8?B?YVIwZ29QaVV6VVBpTzdZdlpXSUExLzNGUDNmUWdOZnlWMVhQVlh1MlgyTGda?=
 =?utf-8?B?cUJpZklvN1lTajRXZVBCNzNjUlZ4OGNHU2ZwZHozOTN2TGxIOVFkM2x3RmZ2?=
 =?utf-8?B?bzZkWEp1bUlNcCt4c3hUcnJYVTV1b0V6Rjl5OTNPc0hwNW5XTzRGMWxFWWkr?=
 =?utf-8?B?TlgrbVFLR3RrRDB4YXZXS2dQNHZoMjVWNmlVd0h3OUdmbjcvN2VIdjVCVnBh?=
 =?utf-8?B?TjgySFA5YjRzamJSSWpKVm0yNTdXSWpVV1RHVncySWdJSlVLVWIwL3FLcnIw?=
 =?utf-8?B?aGtUU3hUYUVtNU5LS1UzS29LTkExNEp2Rk96bWVqUVdCN25nbFpWemozWlM5?=
 =?utf-8?B?VkhLT0syOEJSMGJ1eGZ0dEZXenNRemxuMHV4UzloRTJFQlR5ZS9aQ0pYSEg4?=
 =?utf-8?B?VFFRamRCNTRsejBKQzNGdEdoSVp5T055bHg1WHdZMWI0c0ZHazNKcjNjV1VU?=
 =?utf-8?B?ZDNHUW9PWndRQ1BFWGdqK094WnRZdnd1ck9RTU9FR2VqSTdoT2ZEMlRWK3Vy?=
 =?utf-8?B?VVh4cTFRTWpzWGU4c2RrTzR4ZmMzNW5Zd3J5STFqZ0tUMnN4UGdhMUdlT3hE?=
 =?utf-8?B?YW01R1RCWFdORWQzcEphNkxnT1F0WFlwREozQmMwVGpnbkVqWjlKcFN2cFlT?=
 =?utf-8?B?eWpoMzM3ZVp3WjRrcThUUExjU2kvSjc4dnBmQ2JHWjdwYnBMV25QRFdyMlpr?=
 =?utf-8?B?V1BlcTNGN21LcXV3blhBUk5aUjJveWQxdmR4Q3UzdDJQNnE4OXV4ZlpMdjdV?=
 =?utf-8?B?OXRtZFN3M1JwbDZEYkE1ZktueDJaTkFjN1EvOXorbFh4MUZwVGlpc0lFekRo?=
 =?utf-8?B?RXVlMURxL2xldTFKSjBndnAzSzBHTzRwNUNzbmszNUFPRGFWbDc2SXowZDlj?=
 =?utf-8?B?L2JkOUVsbmNTbXJlakNWNzBOMkljZWRFazd3c2dGamZOdkthTms2aUpVSlY2?=
 =?utf-8?B?NDB0UHk2Q1lyUzlJVVNGYmk4NGRmQ24xSllmQ3hMQUNhR0VkSFhpVWZ2dmxB?=
 =?utf-8?B?UXF1L0JHSUx3UlJIL2Q3SEdwNTQ3aU5WQ0Q5KzR1a3BsNTVJSDRrc0VlT0FZ?=
 =?utf-8?B?L0hKaUpGdUV2dW9haEQ1WEVzUEdRVmZWTmM3UnpCVGdCWGE0TVB1T290VHAr?=
 =?utf-8?B?a2FDZk9UeExEcjl3Wk1USi8wclRLRzF3b0ltam0wbngxOW92N3BIbVZkKzZC?=
 =?utf-8?B?SjVBSUNCVVNZaFVWclN2Z2g3cVR4dFFHYTVDTEhUamZ3SzBWYTVjMGJ4b0lP?=
 =?utf-8?B?UTA3VUU5dCtnVFlwbU9vajRkaUw2TVlHS1dEWUpQa1hxMFRBaG85V244K0Iy?=
 =?utf-8?B?TFI3MFNjdkJFR3ZIckVuVkRCT1g4L3lvV3FlTEdGeGJJUWNtZ3RibG9TeCtr?=
 =?utf-8?B?UHRDYnVpNnpyK2xiUEtVNnVJNFY4MU1kQzhva082M01OU3dBM21PWnR0U2dl?=
 =?utf-8?B?OG50bnhlSFBYaGtzLzQyWHRoLytGbCtYeHdxdHowQXBaUERpVTBhWHFWR2hO?=
 =?utf-8?B?RTJmUlA2TW9GbDV6dTVmZDIvaWo4ZnhYK1d4Tnpzc1NTSjJmbzEwbGNJZEZR?=
 =?utf-8?Q?BYhTBAZE6wsc8VOw=3D?=
X-Exchange-RoutingPolicyChecked:
	OE0s/QfQ9g4cm8AVjLQ1vtIOPHcYvzgVWWMwJwbRq3veKQuQhc7cWwt1S7/jMuKmhRYreLGrFYb9iczHw//vSAJjLxHWERtL1z7OwmIZmaBC7LIfKqfnAIRlg02+ETZylqygQ/d/1FEOMJZp4pcDe3+Tn0aksRopOKc5phVJ944HWM7CwaYb8S/q42TtW/7dE9Z1MALskIaig/IP+xrZHxWEL6B39jPDChmRAiwi2X8XODlsvJ1blVL8IwJ/N1/zoeaXK8WOFq7E/c9lHxXb7iS59eZKUmNwIYxElHyacPOZEcnczdg+CTvbUEouvyxIYW6LURDZjg/SeH8RiTEAfQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KnYkGo2sS54SLNFTmS87u2cq5ywq0sJ9sfzJKiHJ1DrYP3JF85oLdx54i00CBNRqy/Mr7LSBbd+W1Owh4nm+YbTfT/XGakFFocEgHGqfaPFlfcPDzknSgGjWL1E25SDfYSYbJxbI9jVqr09qIcwZUp4a+rzk8PMbQ2wKdMaEjz8zepPDG9tfU3Eol8C351yx6OHS92J5ltTlKR5+kgbDRzQTNGb7hMApzq1jFggfDHXmw9merUIDKj0MgJMeFMl3sRT797VGE4ALnRarqIMKwvNjClxecY/OpQ+0+nxdkEZ+hJFJ5ThcCcWwmOBT28zDGbKMOmqmix/pgQOG3DMOWsKkdaQsCnJJf1EXF6ZpLzgdI3dHwxmjdtVP9FbDBhlC5H8YpvySVycyXAl19Othugvcwo0Urqarmikn+OZu6IL7UIMFmxjEYZQQMCL9VEvQSAyU1Y0l129WBglm0OJX12hm/DeynE3BEGyUpMqyB/6xPrKjmwsIko6azFrsa/JVxa8oVmh/5jyzX0ZlXTr0A0orIkCmRV0XiEWFgSxANIqyNuNIMLhMXo4gGQaN4NYak17re2ACBFw/MsiO4bmuqeY2bdAFvEWWgJ/rTVWwxsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd266f58-252a-4290-54d6-08deed6a8fc3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 12:11:46.8823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EaYKg5o3pGl7Uh79tYNCUXYKRSigmWVCv5eOh1tgNm0bTQFEklEbx4C5bxMepH9Xfx+WpKad10pKvqidFqz8Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290100
X-Proofpoint-GUID: UuUzujAl1ceQH__GC1KPeRnTZq8P3LZL
X-Proofpoint-ORIG-GUID: UuUzujAl1ceQH__GC1KPeRnTZq8P3LZL
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a69ee09 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=P8JKzHY5eYOKgoxmxfIA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEwMSBTYWx0ZWRfX4DjnAlKekBPx
 6W0q9RL4ccd+5FnYO1HC8wut/VK0sX1mEWHNbynyYcBNYSIWTAzIPUPZF1HenLZFbidB6E4yKYY
 5h5iesXK0ULjrc1nSwGQNZ1m0c+V/ZSbgJVJ32zANOCK6owGb7+uBlf7XZU6i3apoCQVHucZTmA
 qWPxpRiSe6tfT+I+BW7QDFoKcM2iuuvBP6zxpF6SxM2m6lPKjGb0LmM2xpYUHX90XhbsoBHWN8t
 yDMa7Vpn2wFoWPUWb+9tGX56P22taQI21yCHy/Fu4Pk8eAgeLjy6jwsml8EsBxQ+SCtbcIxJ6Ip
 fohRgjT/O6EO2YJMSy5Whk3sr0jMn4KRwA8PVyhzoH9cNfp2oGy6D8Y0LBBUsLJkomywh65rrpr
 AZkZr1X+IDPbCoYzlo11WtgrzPYnO7uDA8vY5oKYO2r3XLtzCLXh1ow8OV/EN0woI/c7LMGjKRp
 nBEBL9G3CahVSkVZv1Ndvgn56fAsftm+lrn1nARk=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEwMSBTYWx0ZWRfX8WcW6izW+Y2x
 Mj08VcewUiKdkK8wtnqaQ0gpwJX214Lod6fbkFsyoopESHyx8cYHanTwy4nJt34nntyEK6UvZ0e
 gBklxNfImtfyIGCYJe5vPTlrxw+7tINn2vdCLJ2+TI5Gwu7hJcZq

On 29/07/2026 12:57, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] RCU Use-After-Free Vulnerability in mpath_delete_device()
> - [High] NULL Pointer Dereference in sysfs link management
> - [High] Race condition causing sysfs link leak and dangling kobject references
> - [Medium] TOCTOU race in mpath_remove_sysfs_link
> --
> 
> --- Patch [5]: [PATCH v6 05/27] libmultipath: Add support for mpath_device management ---
> commit a32651ca51a97ca7e06ffd62321d0190b9e9cfa0
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add support for mpath_device management
>      
> Add support to add or remove a mpath_device as a path.
>      
> NVMe has almost like-for-like equivalents here:
> - nvme_mpath_clear_current_path() -> mpath_clear_current_path()
> - nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
> - nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
> - nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()
> 
> The functionality in mpath_clear_paths() and mpath_synchronize() have the
> same pattern which is frequently used in the NVMe code.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 93b82eea7d38b..6b8f6e846987a 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -51,6 +51,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_synchronize);
>>   
> 
> [ ... ]
> 
>> +bool mpath_delete_device(struct mpath_device *mpath_device)
>> +{
>> +	bool empty;
>> +
>> +	mutex_lock(&mpath_device->mpath_head->lock);
>> +	list_del_rcu(&mpath_device->siblings);
>> +	empty = list_empty(&mpath_device->mpath_head->dev_list);
>> +	mutex_unlock(&mpath_device->mpath_head->lock);
>> +
>> +	mpath_synchronize(mpath_device->mpath_head);
> 
> [Severity: High]
> Does this sequence safely handle RCU readers accessing current_path?
> 
> Because mpath_delete_device() removes the device from dev_list and
> immediately calls mpath_synchronize() without clearing it from
> mpath_head->current_path, the RCU-protected current_path array may still
> hold a pointer to the device. Lockless readers can then dereference the
> freed device.

it is removed in sd_mpath_remove() -> mpath_clear_current_path()

> 
> If callers attempt to clear current_path before calling
> mpath_delete_device(), couldn't the pointer be repopulated from dev_list
> by concurrent readers during the race window? If cleared after, the
> synchronization has already passed, providing no protection against
> use-after-free.
> 
>> +
>> +	return empty;
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_delete_device);
> 
> [ ... ]
> 
>> @@ -489,6 +572,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_device_set_live);
>>   
>> +void mpath_add_sysfs_link(struct mpath_head *mpath_head)
>> +{
>> +	struct device *target;
>> +	struct device *source;
>> +	int rc, srcu_idx;
>> +	struct kobject *mpath_gd_kobj;
>> +	struct mpath_device *mpath_device;
>> +
>> +	/*
>> +	 * Ensure head disk node is already added otherwise we may get invalid
>> +	 * kobj for head disk node
>> +	 */
>> +	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
>> +		return;
> 
> [Severity: High]
> Is it possible for mpath_head->disk to be NULL here?
> 
> When a multi-path head disk is removed, mpath_put_disk() is called, which
> sets mpath_head->disk = NULL. If a path subsequently goes live,
> mpath_add_sysfs_link() appears to dereference it without checking for NULL.
> 
> Could this cause a deterministic oops when path teardown outlives the head,
> such as during an abrupt controller removal?

if a new device is going live, then mpath_head->disk has to be present 
as it has a reference to it

> 
>> +
>> +	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +
>> +	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
>> +				 srcu_read_lock_held(&mpath_head->srcu)) {
>> +		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
>> +			continue;
>> +
>> +		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
>> +					&mpath_device->flags))
>> +			continue;
>> +
>> +		target = disk_to_dev(mpath_device->disk);
>> +		source = disk_to_dev(mpath_head->disk);
>> +		/*
>> +		 * Create sysfs link from head gendisk kobject @kobj to the
>> +		 * ns path gendisk kobject @target->kobj.
>> +		 */
> 
> [Severity: High]
> Could this re-create a sysfs link for a device that is in the middle of
> being deleted?
> 
> During path removal, mpath_remove_sysfs_link() clears the
> MPATH_DEVICE_SYSFS_ATTR_LINK bit before mpath_delete_device() removes
> the device from the RCU dev_list.
> 
> If a different path concurrently goes live, mpath_add_sysfs_link() iterates
> over dev_list, observes the cleared bit on the dying device, and might
> mistakenly re-create the sysfs link. When the dying device is finally
> removed and freed, the re-created sysfs link is permanently leaked and
> points to a freed block device kobject.

we call mpath_delete_device() before mpath_remove_sysfs_link() in 
sd_mpath_remove(), so this should not happen

> 
>> +		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
>> +				&target->kobj, dev_name(target));
> 
> [ ... ]
> 
>> +void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
>> +{
>> +	struct device *target;
>> +	struct kobject *mpath_gd_kobj;
>> +	struct mpath_head *mpath_head = mpath_device->mpath_head;
>> +
>> +	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
>> +		return;
>> +
>> +	target = disk_to_dev(mpath_device->disk);
>> +	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
> 
> [Severity: High]
> Does mpath_head->disk need to be checked for NULL before dereferencing it
> here?
> 
> Similar to mpath_add_sysfs_link(), if underlying paths are detached after
> mpath_put_disk() sets mpath_head->disk = NULL, this will cause a NULL
> pointer dereference during teardown.

the paths cannot be detached after mpath_put_disk()

> 
>> +
>> +	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
>> +			dev_name(target));
>> +
>> +	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
> 
> [Severity: Medium]
> Is there a race condition between test_bit() at the start of this function
> and clear_bit() here?
> 
> A concurrent execution for the same device could pass the test_bit() check
> and issue duplicate removals to the sysfs core. 

We don't call for the same device concurrently

> Should this diverging
> non-atomic pattern be replaced with test_and_clear_bit() to match the safe
> pattern used in mpath_add_sysfs_link()?
> 
>> +}
> 

