Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B571838D6B5;
	Tue, 28 Apr 2026 23:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777418821; cv=fail; b=r0ndubc3qwJHMfbuxf2vLQWnOqbQd2nevSNUeA6ghlwKPBoLQHrTDwwiMARDN3L+MUhYVY08z6sxtHWADpapoeKeztAZQWfJ1dOMNH2ZcWHWdaC7MCWIeBU6OP+oUQWpMa7u881P5zRdzZww15/329hKXknaQ2jh9BBm8fb1LHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777418821; c=relaxed/simple;
	bh=PdadB/b5alif3/YC0QWFbkaBuVMSSEExFym1buLQ08s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rNJjubzyj7h3bg5H+HXpuRhM9H71vdIhlgAWT+stU+8TY672Tc41Cq6hd7BaH+GGQObWEa0yKt4zyUxXO5J+xaQis3+NQvcxAyLlSdi5BhpzANldhmlAzUGhDb4OtNfTsG2Qj0jzrHSpm7snCJp1Ap7np/noiezMtsV9d1ao80I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sAV77sje; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uC9801j2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sAV77sje";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uC9801j2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SIP3JA752743;
	Tue, 28 Apr 2026 23:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uupwUCUyEg7feJztg2Q+9okT67Bg9n/MZ6FqVgwTkTc=; b=
	sAV77sjenwHvLc1CJjEBhR8DmsZwRjXpSLg9q6IBcVViO8l5/lwEN3YEz2wZCVXs
	RXW+KrzSIF1Zna4/iTr8OE+cqwLEC/UuwFHRTGb7wo2c5wWW+X6GvejKDJIou6af
	58+WQpwWYM/p0Sp/Acsl1NOX0FUCtNOBFzMZ/J+eD8Hsu185YNfXy/iDbYjahahv
	rZ1UpgPYJ33VWGwpbiBr4wP/cm3jSIJLFskRx0NdKZJ/vUvk6B8q0ybGzgsoUorm
	p5xrI/c0w9KasKZO9/pR3/WzRwfFlWj0P0bNywFjIULE2paYIAA7Xp7N3hVTvCWj
	/jTS7xH1BBmRDhx3x/opwA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnneh0bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 23:24:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SNLLbt021006;
	Tue, 28 Apr 2026 23:24:43 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012039.outbound.protection.outlook.com [52.101.53.39])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cr7jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 23:24:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHYMUiHSUUCN7du8rFdwmbeWE+yQFWKi0zOGQwqIQLqJuiSFAT0S7cfVgwVOUPtIb+bvgg3/prBIOTtaIsLHi8WnW6pmA82aRaZzsej5CHDeuBR2fSdJttJHi63mdmxzK/l4OOt5EYrf91hAgVCxxGo8lXD22KUAgrGy3x9Y7jcF7vpR79uPX5H0/0pmgvADA1oPHjJ80wpnNTV6hK+wZAw24kVUft7r68W0tKCqoUjcOFPszxtXDTkyruZhhnqfEPvUdBnmUEQbTQl7ITxgAEMzQ+uOEQEaoEiSPb9zlwmHE0kYF1LpFMDbqi/PGgdKGoJew4j+gzdYeTfMt8pKTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uupwUCUyEg7feJztg2Q+9okT67Bg9n/MZ6FqVgwTkTc=;
 b=bD7jFNawcEUs+XMkgvht1YUN2Kd4BZCkeBt5CMGrxeiQzAWxy+fmJJFF01QuN1DDIMKgBdglIdlI6yeaC3wtABQpfnG7LSwTeEtJCLtuCVmWvgssDqy/cQE84i8vA3oIvH4OM0S1bThW6kOyFR07W39EV54w/BuvVxsaC+7tr8z9WJ2UWwj9/XrjgM4ITKvzdMjPfhpxPJpvAknXcMG36mOqF+Wkw4VVT+VJzHHRDSHN+B4jssy4Z2JhEeWvKUEIy5D2D5Z/FMsFMoe84PYRCdfvsni3UKxgcQ4ZnHWBRir3IVGqlBAbgtr2V7Kt5axp8RYJaf2g4s35jZVcj4fnnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uupwUCUyEg7feJztg2Q+9okT67Bg9n/MZ6FqVgwTkTc=;
 b=uC9801j2fxhKAOCPANBj+uXNyKK8O09ujU/ggxF4rsKMq8Hx2B/cS4UwfAQeGCmWMWcONVA+hA3Gnpg07GzB9msiZByYewi8grSKEdLqd8TsO+b+oKN1/YoTSg09RmMKf8kDqzpcUvwHRetEPz24nPyN7Cz9Jc9jKczFCahf1f4=
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6) by PH3PPFE06E70EA4.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d1) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 28 Apr
 2026 23:24:39 +0000
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3]) by PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 23:24:39 +0000
Message-ID: <269a7bf1-326f-4ffc-9571-abb7f0508879@oracle.com>
Date: Tue, 28 Apr 2026 18:24:36 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: tcm_loop: Fix NULL ptr dereference
To: Guixin Liu <kanie@linux.alibaba.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, Kees Cook <kees@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        James Bottomley
 <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Xunlei Pang <xlpang@linux.alibaba.com>, oliver.yang@linux.alibaba.com
References: <20260424013923.25998-1-kanie@linux.alibaba.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260424013923.25998-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0076.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:259::10) To PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8C8C3D129:EE_|PH3PPFE06E70EA4:EE_
X-MS-Office365-Filtering-Correlation-Id: 30cb8212-6545-4d85-80b7-08dea57d514a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	C5hLw5jjSp9HGgZw7khQDYLlCsRA/JwVzGB7CdLcf8XZd7PNyi4YIEqVupmHm7PGezJ8Z2yzXXC0mPbPh6I+0egM75EdkY4P/LrEiOBGJOULld/+C+skIswxK2v6sOXc6n1hTOtMHH4iHGIcKUydJ4GRjBdQucqLi0QUK0uHKq0vHXV4yIpGjt2d4H34+28A/0SfMpQJcN7rKRYP7pteSJC+T55zoC4ADX8C9925+zNQgDmG65AuefFF6PnfVnwLpUlN/nZexnkAxtF98K7oSS2YLeBSg+4NX+SNAb96LO4e8R2OxR02cPNWESQHJVhm+0tKSJCfHu7pBTSpiCJD/ZX3oQyOD9SCS1+UZtiYg7ScA4+ZrwIgQg4TIely8am/x56+AR4Fz0r+WSwHZpGloFGBeM3U6XGLeRrYUO9/9dYTXo+MNBx0kTWKdBaL/kVHQBOTSDAo5fqQxJw778q6/RtXhBKUvTl8rOk8cWay/IxBLfEpPmpQJq0Zj6XCiQVFiDXZCR+Lu8UP61ncB18iv30aAstBcQWyLxCgnl9MfDQL/R39joOh5u8UB4k7wcjMucrC1/jd816r3CtSztY5aEFqGS4k9d1dO2saHtZvPCAGY0NbfPs9apjx8cuqK03T/6ECTUEmyJvDXdN1vmziR1IZ01SqAY+Ztrib4enN/+tCEtaUYNcvaigxWs9YlRz4Cpvrs3Yh6I/NaUjE4H529OcHtICMMFvEo8vpb/mfCUw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8C8C3D129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHJ0UzJhZFZyVDRSVTg2eGJGZDY2amVaNTMzeGdxTVlPSUpIVnRPNkppTWJO?=
 =?utf-8?B?UnczNmZRcFkwV2xPckpBNENUbUpBQk0yMmhqOGJXbURaRVpMbWNNTWpqNzNm?=
 =?utf-8?B?dFJNTG9WSnJPT2xTaWE1TW9raytJSUFIcXRjczVnRDRDU2tNMm9aS2dQNVFj?=
 =?utf-8?B?U1Z5VVU5TnhRdnh0OU8zRWxUYjY0eFZhdklEZ2hDOUo3aDNibzRrZ3hndW1Q?=
 =?utf-8?B?b0MzKzgyQ1AyM2JUZmRuZk54TWR1Rk5lelZQV3MvbDVMZ1JKdGNvUFZWMk5h?=
 =?utf-8?B?cDk2eDFLZHRvdy9EaXd3aWZqQzE0VitVdHg2dFVjMXVDRlhxRUtmQVQzRDBt?=
 =?utf-8?B?dXNiNGQycXJPWWpGY09lR1NUL0hDZCtlUzFxcHMzWXVORGFSS3ZiU2NMRXVE?=
 =?utf-8?B?Zlk0MDJ6TUFROGhNZnJadVIzMzRQeW5IZjArcks1cXEyV2JXZkhsTWsrd0Zr?=
 =?utf-8?B?MWc1ck5QVHBzZkJ3b0E3RUFxUWFqUFdpR2ZiTEVDWFhFK0grS0Z5b0F3K3RW?=
 =?utf-8?B?Q1BnN2JiWDE5WmNaL2xjbDhwM1lXVUxqcHk4TlpEYzdCT0ZqSytuZGtOeVRT?=
 =?utf-8?B?aVZnRlNaY3Vobi9Ub0pWS2ZHbm42WTdaZFZLVVg0Z2hUZWZMRlBNWmZIK0xR?=
 =?utf-8?B?bFJNeTlBUWFDd3I2UHRLSjduck42dzNiZkVDamJhbFd2YXhMdkk5cVBHOCsv?=
 =?utf-8?B?TlVtYkR5ZXMrN29YbDlmYWNnNXpka0djbDArSVZhNUgyRC9FNEtiamZUZUZO?=
 =?utf-8?B?L1pUdW12dEcwMmp3ZkczQXBKL3QzQnMvSGJyTnplZ3g1U2NyVERiUDh3YTA0?=
 =?utf-8?B?S0s0cDNkcGp2anBBQnFoZWF4L0dUTjlsVThCZ1diNGFpTXJjaVI0d0NwTVlm?=
 =?utf-8?B?aC9NSzhyNEhadjJRTDhWcWdFak9pTmR6RmE0bXVidEpFNXIyaUhiME93YURI?=
 =?utf-8?B?bkdiNFBtdTRLZmZOZmRDUmVoV25FdDNvMEYya3ZMLzJnQVM5M0lzWlQrRURI?=
 =?utf-8?B?SG1ULytlWEVVV2NhZEtvZnduTDRYd1ZmQW0yZzJSTHQ3QVVWZERibWkzVjJV?=
 =?utf-8?B?ZDd5dVh5c3VRRTZWMWFWNXpmS1MrVSszQWREbTJGYzVRYnVjVzlYOHFPOXVX?=
 =?utf-8?B?WHZDVElVR2hjdUgvckgvUWRBaE9tVlh6L2gvSk9DU0pyRlArRkdkOW9wYlNP?=
 =?utf-8?B?ZmFjTHY3MkR0MWFidDMyZ2l3WG5IT2FhUW9MVkhTenBobVVtdzFyd1drZkFu?=
 =?utf-8?B?OVNTaVJkQ1lDNFptRXpUd1ZQVnk2cDZaZzNjZmViNnV4V3RXZXdzNjBsYjFr?=
 =?utf-8?B?TVJlV3NQYlFnUkp5Qno0bVRCYnhvbDl2ckpsbExzcVordko5eHZrM1ZiUEpY?=
 =?utf-8?B?alJ0dFJxVEVmaTNpU0wwUDRwZ1BCRzFkYXF2Rk4vaitrdDd4SlIwUzhnZW9u?=
 =?utf-8?B?ODIrVlBDays4WVZsQkJWcVNTQ1NjR3YzVUNhcmpRellhVVF1VzFQUEpna2Rs?=
 =?utf-8?B?R2U4TlBQSmJJQTUrZlQ4cXRDRXFpTmlJcmlaSkVpMHZMajA4a2dJWWxmbFV5?=
 =?utf-8?B?SEN0VGRVYUxXVWlaTFo0aCtHeVM2ckoxZmRTZ2ZYalVRODV3TWNHVkN2VnBD?=
 =?utf-8?B?d3pLc3JKc015a1JieWxscDNaV3p5NEgvbkVNVWtPNUF3WEIxd000ak8zR1VS?=
 =?utf-8?B?UGdGNmp4M3FyUVlnajljajE3ZEt1dytaajlWaHFSczE4bEw4eXBCRGlMcVZs?=
 =?utf-8?B?c1BWQ0gzeCtranVra3ZpM0FQL01kM01tQkNhT1lJbnFmS3d4S05JSmpzMnZ5?=
 =?utf-8?B?MWlmSmcrRFV3ZjNOcWRSWkZwZzViUzRucUYrVHU2NDhYNVZxNTh5ZmdwZEFQ?=
 =?utf-8?B?VFNmeGk1ZFFiNGtlcmdQQ3hjNSswYWpDNTVmc1gvRTNPVmRITGt4azdPMTZz?=
 =?utf-8?B?TVk0YVZSbzdHa3U5N1Zueml0cXpsZzRNeldxd1VLN3BST0tpT1NtTzhMK0E1?=
 =?utf-8?B?Uzk2ZjhBTm1jRFNuMlNwNVM0a2FnY0JCTS9tcUljUDAyU1M5Q0hZQVpHdmNl?=
 =?utf-8?B?bHNUeFMxOEFiUWo4MFo4YVhvTUpXZVZycHc4UW50eGtCTnFhb2ZMb0tJbE5s?=
 =?utf-8?B?aElzTHRSL3lYd2tNejZma0RQLzNwZnJHU2Y5Q2RuMWFiTXJiUWpBTzJQUjFW?=
 =?utf-8?B?bzIzWEdaMTFXU2JnMUQ3cUo4RHpXblB6UEc4Mnk2azlwTmgzV1Nrand1VkNu?=
 =?utf-8?B?dW9NcEw2THZLeS81c0VhZ283VjRydFRMUHBkMTNPdFhVRzVzS2hCVTFxNnc1?=
 =?utf-8?B?SU5iOWI1ZGU0Uk12LyswQVF2cU9NVng3WFRMbzZlRCtUZnRIN0laUHhFa1hm?=
 =?utf-8?Q?zVfwa9UGz+DUKEDc=3D?=
X-Exchange-RoutingPolicyChecked:
	DuZFHLI2EqSBE0x6jaQuckbpcWet5tFPo587GFdZ66n7KmDKNLdDvpE5X6B7DAE5awgCP2TT6ZSOzKshfeew3i8o1pCings2vTXQaxAr4h6s+6qctwcMVyR4KsCuw5V4HzRwcIJTgi7YgbOlgafrGuAcaPTnQNEM7ybHp604mtnv5SNpotnZQSml7z/aoqdgrzyloHl2imo4tqh9knxT0fxYscPEXpIMPjaamtdKLMwHj7NTmSQ/wV9Qi+i2e+JahXx4Ne+VRjsPdYxSN8pkfcVVTR4Bku7e7nW/uRJSDDVKcL8FjnAAWs4Gai7RMIm0vSllBIKPGbbOhdiDA6dZMw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ncAdcySyZPRPkFdlBd1jfC3gkAJa9ww++wbSDuAaqxXoXrUQUtFyq55lld7+gRPfEYGVawiJLh8dgwBGGfGO4mb1LBlpEQCIRNZzXGOmRoaxKT7vlqSqDRmPO06CSF0b+2AvN71Vle6hM7OOX+0lcIRR9RW8EET+jkjKAYUKOX95fNqdsIPNh3Evc96NFF/UVd8XaODiv8i+s3y8hpL5X50LiFas8Ul/giIFmLcrPN+CW97YDGT5YHZzwmvvRYj/IDaGdd9YQlb227XEwkmrCM19Oxs5g8xV6GLKkP3IVOmh7cvn38Xd99II4jJgJd+sythC2RSeZuYqmENdnpkoxtogQXRED2r9ethyt7unLEoQ+TDV1y4VBGHwjCDEQz1OKyKj/tKP+TiGf6LtDy9z0NpmWvL6HJAK16ieE/6wkgI3Tptwmn3N4Iqvo5BOwMNdt5Rk08DpZvl/F5rL/BNSwntvbVh0xXHFrsyVfwGfQWNsPzKUijCjZ7suF9a0wj2y3H3YR51wwe0YrCcQoQ2j+3P+1xWQcHdLYrnVA+aCZuXca0qDI01Msng13KVaebOJ+elT9XEkCP3QAh9BEHllpyFfI7o8UMNhb7Jq16p9YIw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30cb8212-6545-4d85-80b7-08dea57d514a
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF8C8C3D129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 23:24:38.9942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHconBV8moNVP10w8qhv4V7hfbS7mEKcE3rlPfPVDSwUFpOHbpL3FXiL5ch2VzgmUEMBPyGmIL/Ah4bWYhsPFV0VZ2V0ys+CU2UrhdcsUSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE06E70EA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_05,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280230
X-Proofpoint-GUID: xHQGOFdbITWSKh_8ksOIS-QQxyr62xGN
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f141bb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=SRrdq9N9AAAA:8
 a=yPCof4ZbAAAA:8 a=zonR_yTqebhCNNf90iAA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDIzMCBTYWx0ZWRfX3wJ6HqQ/Dznz
 exgJpjRUNUM8NqWErIPPf5zaww4braV8pCLMhk5L6dvJvGlIVVSlfWcshDJlp3yscLKj8fasg4/
 sHQomPvckTmeWIu9Baytjh2nK+AAqvWSonjNU1HexDl9eYb16RbGEHB1hS7FT6Ot83kr5mHnVfF
 J0UfAaxTPPnsqMASVDdU3ZaobxydWp45+TPbJYxTUTm1jm6ILaiSECbBaUuYyouZl7f1oU+Pfgh
 0pDO7qSYdFz9RGWXvbx0yh0/t3FTLrkCmCTKwqwOebgmAo9kRcOJkc8N3VrWttoeUqgmq3z0Rlp
 C/eLEbNUb+w8eVL2kG2pYUB87mbTkKIrKt1p9R2RsCCkG4Y5AF3ptcYnqGdbTKpOFmKK4zO3QC0
 Pq/VjLHl2j5dWx6FM276IuF/YGP4WrbOKGSXEHCVQ5HDENWtUomfIVBjbCF9+5UdDbP63kYbtbV
 0W7zFctzZY2/yUeW84tk0eWMCqkB7zNc4pnbW7Q0=
X-Proofpoint-ORIG-GUID: xHQGOFdbITWSKh_8ksOIS-QQxyr62xGN

On 4/23/26 8:39 PM, Guixin Liu wrote:
> The TCM_LOOP LUN creation process calls device_register() to create the
> device, which in turn invokes tcm_loop_driver_probe() registered with
> the TCM_LOOP bus to create and register the scsi_host.
> However, if the scsi_host memory allocation fails or scsi_add_host()
> fails, the device_register() process still returns success.
> Subsequently, when the user binds the LUN to a specific backend device,
> it accesses the NULL or freed scsi_host.
> 
> Crash Call Trace:
>   RIP: 0010:scsi_is_host_device+0x7/0x20
>   scsi_alloc_target+0x32/0x2c0
>   __scsi_add_device+0x41/0xf0
>   scsi_add_device+0xd/0x30
>   tcm_loop_port_link+0x25/0x50 [tcm_loop]
>   target_fabric_port_link+0x9c/0xb0 [target_core_mod]
>   ...
> 
> This issue is fixed by:
>   1. Setting the tcm_loop_hba's scsi_host to NULL, if
>      scsi_add_host() fails.
>   2. Checking the tcm_loop_hba's scsi_host after device_register().
>   3. Checking the tcm_loop_hba's scsi_host in tcm_loop_driver_remove().
> 
> Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module")
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>


Reviewed-by: Mike Christie <michael.christie@oracle.com>
