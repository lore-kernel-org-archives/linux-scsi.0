Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F27BC2E0;
	Wed, 23 Jul 2025 15:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285719; cv=fail; b=esD1XRw3uHb3dlIqeCsYYNHDC/mLJFsAvqXYZTetlCxJjQrjZeuV1fdMx/FaUtyDHu+TgkK0e0HCfl9gl3dySsEJtCEhyf4HrF+iHvPIDUUUswIhVMTOHyftzamH4NBWoQcMLaWHc+HDcvgs2Rm+UCSgomispVwa+UxjiFUY5xY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285719; c=relaxed/simple;
	bh=P8Ia3toQEculmiBxlxdAEug6EhG1KzPHRyuXMMA0uGc=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aDRdR+3Qx+a1dLB9I+IL9DYlE/T/tvylFoE36WZMgwkUfsfDv1nbQVi9ps+iXp2nIudr58dACPVFD3yG8waCYUH+FGiSXHowseszVKHPym15LzypaYsUmk/L62ca6HMImdXY2nCjt8ud7NKrTlOyBAeKTZrbdtPKr/TgzjlXcBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FuJv2Bx/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nYrAQfT5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FuJv2Bx/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nYrAQfT5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NSXu000516;
	Wed, 23 Jul 2025 15:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cA1gONopVmOL4LXTUCpO661WSse2AxdEMEJEwgqJWe8=; b=
	FuJv2Bx/5Q7pGHegOm4QBKKUFEigAwKfX+wh6QezI+hEIbWxVXMjSdo68dhN+m1B
	w+GTmYjnslferGtXJOmLKVc4tqZWX1h44MDmjEQhAM6+YCbeBt3cRdJ1Mc3+ExDj
	n2SggURHRcPweI5pTIuXzpwvrgvtceSEksAXH6V6nflm20mtRQxsnbku97ym9qEZ
	1dZ3X4La7jMyj8V3VKbF9k0QC7/gTHdOHh5Ii0Oo8k0lU4bqcBJXnB8wIg0jGbPI
	k7rCf4++HImtnDw+otQSvwqSxkui+IvZMxIrcq2G8c8E0DiAWOqV75EzYbPXTz/I
	kV/aiydaR9ODopRd/9zQfw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056eftya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 15:48:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NFM0mC011306;
	Wed, 23 Jul 2025 15:48:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tar3eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 15:48:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SeD83dowY5JtiGH4e1DTMO1a0MKVHAowGxZJt+TV+RtjHRzNC/iKfRHA/VL2JOLYuzcq19+EpUWZdLoM1aVXI45A5i68gN91XrwOVTY8e4YNkTF7E+FQ9oY4nSVbEaraUEnrSjgPsnO/mRnFDHx+MKevR3A+zwx7C2FCVpfYCcDuJ+WiJ0dq2vxuN4NGepJetgxQNE7Ev1fabfDdeAeLdT/BXPF5B0IDEAz7QWbzzUrx8HfIxbIrArCZOvzMc/g7xCgzR7D54xcg3XGshS8XwYQlC5yx8Q/SBFjGJoyufLEAM3H50RQ2T6AHkTtwroQ6X0EuN8+4vnFScPwNkarDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cA1gONopVmOL4LXTUCpO661WSse2AxdEMEJEwgqJWe8=;
 b=Jsxu32dU8RqL/uNbXPOrFm8uSy9qD3l/bRzGZKG6Fvy+2erOtaNRoi5lS78rGxL71kHxhLPc8TarLrXianqpyIVicIRk7DGjRwJIxfr7Q7EfEukk+5O8A4CLvK8MWIslm3bYwwnMM5nMM8/gbjQ5dBNYpPOOphqyZ1eUCJ1ybEEEPWVm7rIbdwa9vmYJJahhUATw9dAv/ik0pbuupU448xHzjgrQU/uOf6rFO1yxRfXNWJvIyCmIh4k3SEBTDQJlVYTzumDOvsD8+Yx+dIYk4PLQsXBmJ/o7Pc+SbjJalfge1ylFiqntie/ZbX4J3bsla5a8KE7gBhvIKXGPP2I5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cA1gONopVmOL4LXTUCpO661WSse2AxdEMEJEwgqJWe8=;
 b=nYrAQfT5IxH0HipUgGR0zsIg4+rQQq6dbfmta12VzukPWgJpBiHrcNVZj7E+NYtjj05eBXwkRFNywvH9Hj9lhNaXNYIArP7dBqMqAJiSj1VrOPfNtMKNbK2AG4uV6CIPxjydmvevOSazjJsl4OJHr6LLkz8xXFm2RH1NrJHghAk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM3PPFBBE6F5DB9.namprd10.prod.outlook.com (2603:10b6:f:fc00::c45) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 15:48:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 15:48:32 +0000
Message-ID: <f6efa59c-680f-43a4-b477-0a3791f06f2e@oracle.com>
Date: Wed, 23 Jul 2025 10:48:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] scsi: target: Add atomic se_device fields
From: michael.christie@oracle.com
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-3-michael.christie@oracle.com>
 <9e789a42-2522-4df0-8c33-db44b790a7ab@oracle.com>
 <2eae4fbf-66ef-4602-91e0-d92838dcabe6@oracle.com>
 <951f5d23-19a8-4f6a-abcd-204aec160e74@oracle.com>
 <481bcab0-7bc0-40f1-9384-7d3c20ccc22c@oracle.com>
Content-Language: en-US
In-Reply-To: <481bcab0-7bc0-40f1-9384-7d3c20ccc22c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR07CA0051.namprd07.prod.outlook.com
 (2603:10b6:610:5b::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM3PPFBBE6F5DB9:EE_
X-MS-Office365-Filtering-Correlation-Id: c97899ce-7731-43f1-faec-08ddca006038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U20vZm5zblFRcTNza1pVTHpCQzZxUTlCZk54TU1hc3JpdUtwcmd6OSswVkg4?=
 =?utf-8?B?aWlvNktaOTltdC9qMWxHK2pUM054bVVJc2hNQkkxcnN3TGtzR3pkd0l6UTU4?=
 =?utf-8?B?c05uVnR6SlhNNDFUeWN5dlV6azN3V2Zld241VHY0Y0swMjcrWjhFQTNJYUNz?=
 =?utf-8?B?cXpzbUNkQWZuaVVDTy8zYVVNMU9YNGlMNTR0RzlJMHVxVjlmR1laVU91c1lT?=
 =?utf-8?B?N1RLczlmWUZBSm1sUW1Ta2hiL0Y1aEdOb280c21tL056RERhUE91eGZQWUdz?=
 =?utf-8?B?QWpXS2JUVkZCdHlsRlExeGV3NmpRRXdEL3JEdjhsTTZJR3dPd2FWeHZLNzNs?=
 =?utf-8?B?citna1J6Sk1KQll6ek91aWZEQ1dzRVlQaUd2M3JXNmN0V25VS0VBeHhkcEJG?=
 =?utf-8?B?NEd4WTg0bUVxRjlvSDd4ai9kRFNBUXduZEJteVpZTmR4bG9BWEdBTTd1TEEx?=
 =?utf-8?B?SUE0c0xyQkw3T1JtRGRwZ0NzRlBxaitmVldOOFc5WWs0S2Rsa0VRVmZlUWNo?=
 =?utf-8?B?WHR0bVV4RFpDcHpTaDhXV2lNUjZ6ZFUyL1JVZ0NNbVp5cFBSVWU4N3dlM2VV?=
 =?utf-8?B?OGhCWWpQbForeFExUnl2dnZ0eUJhYWI5YXBOVE9KdXZKUm1Sb0pWazZmSmNT?=
 =?utf-8?B?TC9ubXFBLzU5ckEvMEtLMzNtSWF1Y0ZZOXdCUU90MEp3MjlNTG1pcmxFaVRP?=
 =?utf-8?B?TGNBUGJGOW1yclZXcnNtVjNKQk5pSGlZNmpCbnNCeUI0MWxZMXpPSFFTaVRy?=
 =?utf-8?B?TGV1STFsRFlJbmZSUGxXL3FudVZzOURsc05tRUptb1ZDNzlCRlgzT0h0VFl2?=
 =?utf-8?B?MGpMM2xaRWxEWmlBUmwyZ2Vxa3F5TTJMNFBtb0FKRzZlbmFRWGZBaHY0ZVVC?=
 =?utf-8?B?ekhOQVc4Tlpqd0ZBbjRnZEEyQ0VQV0crTk9ucnhMeEdqZU9sM1JZOW1KUTk5?=
 =?utf-8?B?STdDVmRzc2VoM21FRXhuOEYzd3VJTmJjNDBhdEhwYzVKdzU4K2lsL2NrczZI?=
 =?utf-8?B?a2hrdGtkWWFKdTcxN1E2L3JRRW96Q3lYbTdoQXNid1RjSk9RTmFCZkIxZjdl?=
 =?utf-8?B?dStCTDcvaXdWb0RpSWpLWkN1OEtyb2xMVHlQOVVDRXFsOE1qTno1ZzQ2d3dv?=
 =?utf-8?B?MnFzZXBqelJOL053SFcyT2dUVWhpM3hSYVBqVXRDRWxQWGYzcHJtOHRjSlM1?=
 =?utf-8?B?QXI5UEhsaGRsVmJpQVR2VVNsZ2t2MnN0Q2p5Nk5zL3ZsdjI4Y3MvMVhQSjJh?=
 =?utf-8?B?NUNqd3VrYTgwSWNpTjVIWkY2RlRBNFMzT2lvQUJVNWd1MTB4N2RrVXNPQVFy?=
 =?utf-8?B?ZGVUZlR6NkgydVUxaFlzWUxlZ1VmMTZiRndJMWdBcG1ldkovQUZZTm1FZ0Jw?=
 =?utf-8?B?SmJQM3RWKzVOeVUrOVlPNGRLdEdTNHVOQlYzZ25zdktaYWdlNU5YaVRYN0du?=
 =?utf-8?B?aUIzNTZ2VUdwelB1NER6SU5iUXRkc2t0K2ZUc1N1TjV3Q1pTcVZBUG9JZ0ln?=
 =?utf-8?B?bVBtN2tGQzJGUVl0QlVDTzNjeE5UVWJRQnA4WnpCR2NiRkVCc2pwNXpJNGY0?=
 =?utf-8?B?b0EvNzRuUWVJRHRyMGYvQzYzQVhQSFN0Kzlmd29HY3NGRFdjRVY2RG9KMjlJ?=
 =?utf-8?B?NjZIeVFuVW5QZkFwM0tJOVJhWVdyd1pscCt0bFUraWtjaVNJNEVmUmlZeUZN?=
 =?utf-8?B?akNBTm5hbzFqU25WajcyMDBBM3lJYzkwRjgwd2NlWFVXS1JyWGd4UEtHSW1S?=
 =?utf-8?B?bGdabkZZSi9TWExRdXdLSk9VZityWkQ4eHlNVmxta2dBNytmdDVWYlljZldn?=
 =?utf-8?B?YU1lbDlBL2FUVDJubU81V0M1VDBsYW55MW1TdENOK2YwL1NnZXZ3MkpLVTNh?=
 =?utf-8?B?b2NsQzNsTFVpUVRLYU11VXhrL3lmaEloUnhWT3JiSjNEbmJHWHpVZXFQSVBH?=
 =?utf-8?Q?oyOBqYhXnzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2x2M1p5Sjg4a0NUOTNPL0tHMlJDb0lwMzZWQXV2MHNxRTl3OW5jVUpIa0xK?=
 =?utf-8?B?dTVBYXpUU1h2blo0T0xValZ4MGpoUzdEYnZhRVhuVjZBMEdReHpENlBtaC9m?=
 =?utf-8?B?TlpsQW9Fam1tMTZQRWdyMmxKTkJmL085aFVkL2pKRW45bFFpa2UyVnRzR200?=
 =?utf-8?B?OUd4NW5kd1d5OU9QenYrcUdpOXozQmc5MTJUTGZoenhGc2huVC8xb1VVTTgz?=
 =?utf-8?B?d1RDYm9zNTFJa2k4MkRKNzU0ZG56aWJTS3ZDbldKcWs4SUZOeFZuRFRKdU0r?=
 =?utf-8?B?NURyQnI5aTdwUzNHUmtkT3VkNjNsbHZnQTJiaFluOFJlR0tabVRFUm1UbmhL?=
 =?utf-8?B?QWNRVnEzTDhTaGFNOVcxRnYwaWFNamp5NDJJZzRDZmFNV2pBLzNSUFFEKzNU?=
 =?utf-8?B?VEZrS080dUlqeGcwN1phbVNQVWpGOFJXaDQ5WjJEelE4S0RPMzZiUWFnUkI1?=
 =?utf-8?B?RnIrTjNITmVaVytYS2szQ0JWNk5UeXI5MVJEdjFiZ0VoaGJrV1Nuc2hqekxR?=
 =?utf-8?B?NHBXZmtJV0xtMC9XeGptV3BDMUE2ZE9OSnh1ZTdHMEd1bTVEUWhNYVJUUEQ3?=
 =?utf-8?B?S3BaUEJHUFpieUZWTjEzT2NzU1Q0cXhDcWZ1SVMyNG9EUlV1RnM0aTh2QW5D?=
 =?utf-8?B?NXZUbkFTREVBbjdnWFhrMksySis4R0d5MjVaYlhScjlxek56eXpZbzdrcjFp?=
 =?utf-8?B?b2VpTGxjUk0yL05OaktCajRCeHdwN2ZOOXJEYjVVMUhyWnFSaFcrU3RXeGJG?=
 =?utf-8?B?Tnlrdk5IMDFHRktCNHJXUjZadC92V01YR014a0FMNFlqaE51S0RhdEJCV1ow?=
 =?utf-8?B?Mk9KZFlWUEkrdTZSMG8vbXBtcjljVFlQemF5ZkNJTmg3NWxPZzQ2dWNxSUZ0?=
 =?utf-8?B?ZkNNdmIxdFYxdGJvVG9iZDV6MTZPSWhOcFNNNFkwY2R3R3JxSGJjaDhyOEl3?=
 =?utf-8?B?U0twdTJxd2RHeXhmMG1uTE9HUzAwcm8wbUUraWtXUkZaeGNYMy9CL2J3TjY1?=
 =?utf-8?B?VVJYZFdpeTNlSDRBY0VjUXVudzRzalJLc1ZibFdMbDduNkIrWjU3MUNMQVVE?=
 =?utf-8?B?WnBPTklyanRRd1lXdE5JYXFZNGFuSi9CM3I4bEZTQ2dhZVVPMFFMTW5hRC9V?=
 =?utf-8?B?aldSUXZ4cUxsckxOU0l5Slp4dkFUemNnL0o0eml1eDkxTGh4Tk9sREN1T20v?=
 =?utf-8?B?Tzk4Sm5WL1NVa2g0TmIzaEJUODJhZWZidC9UekJ3VjhDWm5pSnA2cmZGeFNa?=
 =?utf-8?B?UXNwVXRkYUZrVlcyZDhxV2thNzNjeElXU0xaQmVHWFNJKzhRelhmM0MwK09M?=
 =?utf-8?B?R3doa28vN2dwVndVdTZaTFFxTmc1TkNtb0QveEhhdFRYOXRlSzYrM0FvdFBW?=
 =?utf-8?B?T2VVOFlXbkZKMEJnMzNIcWJLdytpeUdpa1g2TGx2dkFwUzlhTDZWeURqRHhj?=
 =?utf-8?B?RDVUVDhmcHNEZGJ1V0RmdHU4TVpzdk5Rc1RES2tXUWF5SUdWRy9semZUWGt2?=
 =?utf-8?B?UWFPSzF6eU9FN0tpd0ZiR1JoUnBuWnlTcXBVdkNnZ3IzRk5YSDNkWE1Xdks4?=
 =?utf-8?B?ZkJqMVdnUUpHMWRrRHMyNkxSenNBSitBazQrMVViUVk2YUlCQUd3TnlSakpa?=
 =?utf-8?B?Z0RuUkxTb20zK1dNZWQ1V1FFUU9US05PUUh5UHc0VWx6RmdzR0xLUVU0R216?=
 =?utf-8?B?Wkk0VGVYZjA0ejE1dmljYnBYVGFabUFlRWJDa2tZSFJHcUZHdzZmM3hOWUZD?=
 =?utf-8?B?YmdjOVp3WkE1aTZod0dNVmtXTkgzcVUremZnWHZaVEVoNFk2T0pQeHU3alBu?=
 =?utf-8?B?OWFDMUJaU1o0U056U0QzTjUvVjZpR3krM21wM2hhWk1tNG9uU1hlY0Q0RVRH?=
 =?utf-8?B?Y3FmUVJUcEtNRS9LVG1ydnBQT2VWeExSTFlUTEFBZFJZUXZMWDc5UzFjajNM?=
 =?utf-8?B?TVpzNWtEbi9jUy8zdVRFb2VmbnZ4UVRLc2ltZURkb0xHUFdNRFJncHJiRmpW?=
 =?utf-8?B?Q0FwZGpiY2twb2h6KzdBYUFpWWY2YmpNS0x3eTM1NnQxamNHdStoYTJqZHd3?=
 =?utf-8?B?RVVQaWtIaitENEVYSUhPenNFVkNOUk45djZ6bktBV2Zqek5WOXNteEpRTUho?=
 =?utf-8?B?eFltZURXaVlLdjBrbThHK256bnQ1ZDA4Zy9qVDg2clV1M21JbjllMUh1dVIz?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u1PwzL4IBPCBNF53fKH6m17SoQAGXHCoDF5pYUSMZG026tVbfm5hU7S/tJslnr2TfKQvwRO1IukGEjMN3ntpklGUOjdrDG5uYd+az3qcGWp5PNNMmoRkFSVNiyh+e7qZbLUlrMwVe7eDM/KauXaa6vAetPHmXbhlg1DYMsk3rIF9VlRYOF3XGdlz9gAVkHZKGQ4bLgqw4J58WUPB6sqjCG0R1eCMzgssdhykSVmRWsp1OwsQt/uLF9AuqWur4Kplo+no150jKNhPsq4o0QbL+gXYYwfjn+qRC0dEFD4s7h7idqVY8sg5Ea6OQpu97Vmf7XMSyI0p+uQiehcPZvRUMbN24fpcKL8G/sKxVcfnfSq0vGK0qKDriMjZsplhGLvCUDwSPPDL38rsFkvDKovi8RhBhsbl91OejXDMni2vsqvdupBrrxM/wNXU/byLdQQoHxAjQjcO8bKOX/7m+ss0cMishxJe+3Yq3vK7i8X47dpNIwUrf88eD9pbduQaGF3uIMNGP1aFk3W6RoxVMa9c+kzUwBCl0MQwDfN5fOXsLdwI+6ZX+HuNAxCKFatoxJMQQAqydgHYoOut0YagifEZ7Pt65z9vCDbIBV0fQBBkwgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c97899ce-7731-43f1-faec-08ddca006038
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:48:32.1947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4sFxTgRBiI5nKRzvcxezoYbFNL4u9wHCdLmXIPUvcNDnXszs3feSEnaWfClIvzNTni4v4zrzoAuo2kn7+YEpLZCii/+da8LOA7K/xh507A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBBE6F5DB9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230136
X-Proofpoint-ORIG-GUID: -P65ftfwn8plcWwPtlv0Q_2v2wAxE6br
X-Proofpoint-GUID: -P65ftfwn8plcWwPtlv0Q_2v2wAxE6br
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDEzNiBTYWx0ZWRfX5+J34ZKoRoBT
 2y8H/t4YJ8bAIhaRn2GLIiy7cgsEsPa93X4iUp3TLLVt0o8i2YPV8yesVnU6rpw1p3ZjNJrE5R5
 rWaVRKDS7J/TVR5UfgZpoN0CbIWQKl8bHPKb+nJBekdgIiihh6XSHy11qemxk1ldkqX6Kgxrb8s
 q3czmew94hcvKDFUPSQjZsxDX+h39I4zzeCTWDwfEj34dsI4114/8njcyyVsUfwzrb/Y8YciBQ5
 4gdGTYvHMtHOJovtw+WexDXVG+cE9rAQBD4U6Lkf7Rt3eHNFN85W0xmQ/lhpXM7D1N2O30eO6xB
 FxThYVWBTPiuEZ3Qf0AVAH/x+cCdEUSbYQGtbOCzO7btNJCw3irNRuueQjn4t8XtHxvToEJpBnA
 5MBvqvFjR25KQjwg5iugG2n/dOnk3oktE+e1ypmu3c+DH/wnx/RfHDQJKKTBLJnOSTKckYsp
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=68810453 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=sRwvCrKH7tD6YUmv35QA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 7/23/25 10:10 AM, michael.christie@oracle.com wrote:
> On 7/23/25 6:28 AM, John Garry wrote:
>> On 20/07/2025 23:15, Mike Christie wrote:
>>> On 5/14/25 5:26 AM, John Garry wrote:
>>>> On 08/10/2024 03:03, Mike Christie wrote:
>>>>> This adds atomic fields to the se_device and exports them in configfs.
>>>>>
>>>>> Initially only target_core_iblock will be supported and we will inherit
>>>>> all the settings from the block layer except the alignment which
>>>>> userspace
>>>>> will set.
>>>>>
>>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>>> ---
>>>>>    drivers/target/target_core_configfs.c | 42 ++++++++++++++++++++++
>>>>> +++++
>>>>>    include/target/target_core_base.h     |  6 ++++
>>>>>    2 files changed, 48 insertions(+)
>>>>>
>>>>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/
>>>>> target_core_configfs.c
>>>>> index c40217f44b1b..f3c7da650f65 100644
>>>>> --- a/drivers/target/target_core_configfs.c
>>>>> +++ b/drivers/target/target_core_configfs.c
>>>>> @@ -578,6 +578,12 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
>>>>>    DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
>>>>>    DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
>>>>>    DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
>>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_supported);
>>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
>>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
>>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
>>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_with_boundary);
>>>>> +DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_boundary);
>>>>>      #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)                \
>>>>>    static ssize_t _name##_store(struct config_item *item, const char
>>>>> *page,\
>>>>> @@ -1266,6 +1272,30 @@ static ssize_t submit_type_store(struct
>>>>> config_item *item, const char *page,
>>>>>        return count;
>>>>>    }
>>>>>    +static ssize_t atomic_alignment_store(struct config_item *item,
>>>>> +                      const char *page, size_t count)
>>>>
>>>> What is special about alignment that we need to be able to configure
>>>> this?
>>>>
>>>> Won't that be derived from the block device queue_limits (like
>>>> granularity)?
>>>
>>> What if you are not using a physical block device like using LIO's
>>> ramdisk mode
>>> to perform testing?
>>
>> But would this non-physical device still need to support atomics? I
>> would assume so.
> 
> It depends. For just a testing mode not necessarily. It can be relaxed
> so you can test different scenarios like you want to test when atomics
> are not supported correctly. For real support yes.
> 
> But just to be clear for either case, there won't always be a
> request_queue/block_device. For example, rd and tcmu don't use
> target_configure_write_atomic_from_bdev, so the atomic values can be
> whatever they want to support.

I think I misunderstood the last comment.

I'm trying to make sure I can support a broken device for testing so I
tried to make as flexible as possible.

With the code as is though I think your concern in the last comment is
that a user could set some valid settings, use rd/tcmu, and think they
were safe when they are not. If so, then I agree that can happen.

Or are you saying even for broken device simulation that we will never
need to set values like alignment above?
