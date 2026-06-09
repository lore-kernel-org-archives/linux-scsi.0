Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EACB403E9D;
	Tue,  9 Jun 2026 12:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781007289; cv=fail; b=g+TMwXIRxGzUY64jOrXa3VUeRb8I/6xtXDfdcnMJKcmQJEMwNBL7Hhsx7cppNgCX8gPBex9VlIIbxwtULTMJpOyfd58ME2F8OsQZnBO4DwRQiMinXpLuLshxxLi69HkInHjZHF+GJnEhbBQdBOmyvmOL/ppXqfHjsQ0c2nZ7hw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781007289; c=relaxed/simple;
	bh=G57gIkKTTKOibtJqe3HF7KbFXNaB+PWlVKJnCR73kWM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gb/0nVl7tjFiNx/k7lHIzVtQj7FqGvQIJBeyj3Y9omwhFMXEvW4yvZlmB/Z/eB6p6Qj0TQM5znYtzWXnCckcQFbaE7j7ptKyfuMFn0ko6gy4AhXsaKvRnLyhUhvxfyFeN6Qj/Jb7sv6IK1ulht9V4JwVcXCP1PVRgcV00Ur6XYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UxBQGFnb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uJkJDgej; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UxBQGFnb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uJkJDgej"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6590MZQ61127041;
	Tue, 9 Jun 2026 12:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mlsi+UEJaxHUqJgMep0JSRB/lUu6xndvlU55dCXUZ94=; b=
	UxBQGFnbN/QwHCnCrdSO7cgVPJELCoRx8aP4bDRbMnEl4wEM909yyfe4zqt4Ea/Z
	F/AT0Yr1onC5SUZC7Pdvuxso4KEX2PAK+5EAYSx7lgq0DZNgLzkxpNvfJi5rkS6V
	2bgl32ZaikNrq7ghH5Xeju+9lCsi+Cpy+09fuN9H4xhxCYLy9x5IOEHEnpo6nKcY
	4REN2x1fFiZBbuVL9nLNfHOLpaeMZA3Tlow+4jM33Jd3YrfjdhpgL4udCE77WMv2
	4S+Xh+iPym9jb+6tBbTgr6lm4aMCmF7gXmb3HQtl5IHYZ03llnBZeD3//yEDK2TG
	3Et9v0Y0me6b/3xsEgyMlQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embe7m5k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 12:14:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 659C8aXW025077;
	Tue, 9 Jun 2026 12:14:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0q1fsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 12:14:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bahgQQxtrFSOJTOCB0bXHt9YJQFlk2HVn5P9vFSgZYXTjmqFJ0igh+zoaNNh4IbhPzgOXL12GyyJx7Gl+RzvvzhgqMrVqkQC0RPoZeMokToM0i2ASzUb5c8sR/q2kPQSDlMBulFPvMOXDf0kbKQvo4Y8AZvGzXZhaqI5eGV/joeHQtKBF4Znwjr7dxD3GOAvcfPeoqtGeJkbhoUWvEAQE9IBieIBea7i0zfY/V+0dbidDF8+t/UUmpA3jfSo0XKs/aMZMGQmu1BJRXJX98osOiphqCBeD08lrVp/5goRR9Gba3btmtW3B3cwoey8PFB7RKRJIvYcJ9d0CmhWJoaYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlsi+UEJaxHUqJgMep0JSRB/lUu6xndvlU55dCXUZ94=;
 b=VUxWcH9qWL3V5URrKpwuBhIFOzjdYB2w2EVjNjujZIbywxHJ4+ZvNFYZs6/RHiKlZtKZfvavzFcSDKLGtaCPTgqz5OELOwsOrfFOxfhfHqrYdtWPhY87h9JVxDIYpgbhDH4DAVUu1PgWy7YvNHQuzACXT6Nxbe8u1TczntNHoQRLqKWYcgkwkSlCAvyqqNq9zix6jYMe1uhY7XI325S4Ke8/sVVoJfphuwB2LxqNArTywTjIyCDsewkt06qbwI0uR6kEH+l5HG4RC6370Yhr2BoEzpUfwLDDTTkuDZTicVk1Dyfwc2PNZxay5VbCdrlbx5HZjjEqwJ+CxPoHs7DaaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlsi+UEJaxHUqJgMep0JSRB/lUu6xndvlU55dCXUZ94=;
 b=uJkJDgejEHF80s5FvBs5Wb9a23paeOvPI/9TYKfLpi9S0kzVuWVqhY2XUWCp60x6sDqhUDv1KlFtWPd0PoR8wYpzukddcSbnxAIShdDO1Lf+R3CTqSeu0p1tbyU7stJHoQllUM4NayI1fJBeBXjevBXC+9rPAzTTyE3kkk7kKiU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN7PR10MB862668.namprd10.prod.outlook.com
 (2603:10b6:208:5f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Tue, 9 Jun 2026
 12:14:29 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 12:14:29 +0000
Message-ID: <6b6ebec8-0e92-41bd-8001-0608ee6e804b@oracle.com>
Date: Tue, 9 Jun 2026 13:14:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: copy iSCSI ISID before unmapping the PR
 OUT buffer
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bryam Vargas <hexlabsecurity@proton.me>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        David Disseldorp <ddiss@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260609005858.17504-1-hexlabsecurity@proton.me>
 <fdb07a39-cf7d-48aa-9e75-1a79dc7ad620@oracle.com>
 <239dd72a5ee388486f60eff7e6b025d130e08266.camel@HansenPartnership.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <239dd72a5ee388486f60eff7e6b025d130e08266.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN7PR10MB862668:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f00b12-9e7a-421d-5ecb-08dec620a815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|6133799003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	qGaQHpIKic40x4v7vlhSNcewjgS+CWAgk3o1YfkBU9VhngB+gHkQXe4tVZ4IDVmvdGoB0c+IAUNTHKJkgyPIoFy8BNrdCrS12w4l39JoGQhK7g70sQUAvAObpRrdLQVVxD6q0JFdLpvKsAUZEJkfAh8mPawhE5yxymuky+ev3koNbC6rR0joRqPqLeWEy+4WqchEOw3bFExg0ryUWK9FPZPLaWRgvaZoUnOzCieg/wpBFgrNKIyy9BRjYGesMV2DdqOKKryxUiuGCVcxTlXZOQQgoKXvTyAqoSgreuqALo0hWPgInWjNojl1TGdDl7ROoB1JHJrsLpVTx2EInii/ReUAw7Q34bC81J7TPpdyNmEJab53kB0BO3g+54MJ2pzz6xszb9KzJWwfwpDseSHw2EA3vNhs/Gp0CaLiM/7Hh/5ds0M+8scQhILg/ib0COLKVyja+HFxU0hqAmpKkirkg2jYICUK6WQMADUuny/7fhrBDUGspQ6p9P7srG2CT1vJjq5VePjhILeNm2AqzRk9MxcsF5SnFsx3BSiyQlDN2Cwedclx/Ttoyy5NgnjBgXnxblQzqxsKhmItuljC+rdx5jo5thD3dy/MR0PickFiVUggog6JJ4+DNF1bzFSRhXxl/3GEcshrUM1tt0QEh3QAfJJS2nqTgXFZEy6zlimrBnPSUPOAYQ4+F3CN1fEEaY8m
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUh0VkQ0c2JENXU3Wmd3L2phL1h0TDk3R0VHWUF0NG5WK1puVEwxeitucGNL?=
 =?utf-8?B?bWtwbW1oL1B3R0JXN3F5bkJJNm9ucC9xQW05UlNQTEM3WVRxS2JtWG1YUWs4?=
 =?utf-8?B?eDMxVkVjalBBL0FzdEpOQWhod2diNVFUcXdUQmkzOUYzT1NxTGZyaDNFRjFu?=
 =?utf-8?B?dWtuNXNpMzZKSi9meGI3OEVMTDFuOVFCUDhMeWZoK243V3Y3dWVVbEh4ZnlJ?=
 =?utf-8?B?Z3Z5d2FXQzQ0M3FaUEk4WXl4OVhPM0RGQlUyZC9VYkZVOTNRVjZvSmpBK2Z3?=
 =?utf-8?B?cFBwWGdJckc3RjFHdDB5ZDlEczk3Skt2ZVBVNk1yc1pPS3pIeFBYTys0NzIx?=
 =?utf-8?B?d0ZMSURhejVYK2pOQzVVbXB2N2hPQW1ZMGtZU3FMTWE5azlwOVkyUUZsSkRz?=
 =?utf-8?B?Y0hkT1VXblFyL2Y4UWM2UDdRQWpsV3pCN0lPaFloNTFsbzBvUWNXTVMxcVFl?=
 =?utf-8?B?dkFkOE00VFZmbVB2aU9YNlZjTkZ5TjJXSEJRaGJpVGhRYXZ6WmN2TXYvQnFF?=
 =?utf-8?B?czZhbmtEcDd5cjVjVk0wbGRHYVFlNHVWYVFVaU9lZXRLNjhGWTh1U3BTOEZZ?=
 =?utf-8?B?YmI3Znd3c2JJd3oxK3hUOERkY1N1dzlYM3pmWFRDRnRNakk0Y3pKR3lCcUwx?=
 =?utf-8?B?cDRHQXB2T1ZSYWgzMzJPT2s0QTZpQUZhVCt3ajJ1ZW5tem9weWxjNURTS01o?=
 =?utf-8?B?QUlUSU1EcTZXazlhZ3hzWHUvWG81VUN2SDVRKzFJWmFnVERjU3Vmb1oyNVI1?=
 =?utf-8?B?azFkMG95ZWQ0UHdQZ3ZvMVJTUlBJTE55aE0xT3puSW1IRW9sN0VPOWVxaFhj?=
 =?utf-8?B?WitoOGhBRktQTlpNOE5yZEZhclBVT3Byd2VwUFZTTTNOdEUxNld1ZFBZNHpi?=
 =?utf-8?B?TGFhV3E3VU5ZNFdDR2I5ZEkva0FFVUpsa3h5YkkxSnpHQ296YVpHckhrYjln?=
 =?utf-8?B?SGtvK0VSajlYZTUrV25HekhqUkxGekFkYkJvYndCS0RIc1lnUy81bi91UVJB?=
 =?utf-8?B?aTkrYzFSbUg4eGdvY01PVnhtb1RuUExOMVYvMWU5VnplN0QzVzhBWWxvYUFO?=
 =?utf-8?B?aWhEM05CYmZEc0VIYWJya3NmZXNtbTNsS1ZDcE9seVpWOHE4WjltNXMwV3Fj?=
 =?utf-8?B?VkJZZXZPQyt4N1JDQlYySGpGVXBMR3MrRW8wWno2RTFTZXIvTG04eDBPSUJz?=
 =?utf-8?B?UUhtcFNueTFKUFRqWmFmNzIrSTVQWW52bEhKTml1cTlUalkwTE9RNG9TM3Y5?=
 =?utf-8?B?YUk2aTBsSWd4S1BEMUNicktTWDBKTUR4QnVXeEsrOUl2Qkh5RVVObk5qRDhY?=
 =?utf-8?B?TlZRY3JONGJ6UmJSVXNZNkdFanE1TzBSZ1htb0V1WW9wcWhGK0NKc2FTVFJ3?=
 =?utf-8?B?djV6VmFyc3EzVEtmcW00TmNLejdRbFA4bFlLU2xSUkoyYzlPbVhOMlg4N0cy?=
 =?utf-8?B?MTBpSXNyZ1JPRU16VWIyMklpSE9VTUNvamNQb25GTklESjA1aUVKdkNGNkUv?=
 =?utf-8?B?dEdhVjBrczIrdFp6dHRqU0V5RFFZMloxTUhmUU1xdXVRdFYxSGViMk5DR3dB?=
 =?utf-8?B?L1I2Si9rOVh2TUEycjdaM2craDBUUHdpR2ZEQldnZHlHNmFZV1hDVWpMaWxH?=
 =?utf-8?B?b2ttZXBaQmwxMXowS2ZQOFczby9VSWZRcldmb3RKbFpobm45VHErenA5OXNC?=
 =?utf-8?B?WElVRjRBSXBUMXh1aTZrdTJaeEhzdnExeWRhajQxc3ZheDhzODJVNlcySkRU?=
 =?utf-8?B?a1RnLytvd3hIR1lmNG9HVGN3bWgwMkVOQXJzRDgwbGgzYlVDaGRYOENpT3V3?=
 =?utf-8?B?WWg4SExycGdLaHFrSkRiNkllRXRkZFZKZHdxdnJKY0U3RTRJZDVvQ3E1RzZN?=
 =?utf-8?B?WDdMOUFHaXB1TUk3QjJiRzlaeVZRZFgrWTh2Q0VKWTVQM05oNkFadSsyNWVw?=
 =?utf-8?B?djBGUlpvZEU5RE5QZEkvVE5DZUd2NkNYL3B3MlZlWmN2RU9ZaC8zeGcxdURo?=
 =?utf-8?B?a0VDRXVyNW9xcmk3bnNNdkFlQnI4amU2WEdadFdtZmMvemFoQXpRcDV5M0No?=
 =?utf-8?B?VGJsZytTKytZUVdibkV1YUNtZmEySmtFTGVWb1JQTU1tRmdIc0pFNWdJREZx?=
 =?utf-8?B?T0NjWTZZbm5lVFlQOWtEbEh2SXhZSDUzMStjUWErL0hnRXlaN3Y4REQwdTFj?=
 =?utf-8?B?WDJ6dVNRd0VZaGZianhvS3pmSDA0bXo5S3orZG4yTDkrRnk4UXp3MWFvWDJO?=
 =?utf-8?B?UVcvTjlhMlNnUUl5RzQvam9QTzlsQk11S3ROeXRCT1p4K3NrSU5wWExqcDhO?=
 =?utf-8?B?amZQL2hZK3BqSU5RKy9tZ0tmQmlJRm9xNjhocWVHcjkzbG5pa0pxUT09?=
X-Exchange-RoutingPolicyChecked:
	KuZBF+oi35I4AKs1A+56a9zIuyHGV4vgKKzKakjYnSIlYnMLIaZ9yP1bIj1saAIBoy2FI6jEsMVbGdnS+UyOo5XnwZiXrJo/27YzSxdmoj8fefVvklIjTOtMgLqU7NNgvVCkAXkVX2qiRPlvdFd/flxU4RzqI3TZnt0U0BCkZ31X45qV1DeLXcCIv9QyAZlCVzJQWhdRgEFG4GruTFppF9Aa6qoxEkSk1VLZtX1CUjGnq42swVZkt6zUx0ikGKmICsgzZ5puefiPHWhcJxndIEaHTYDpZl7iADgFLuP+ilEnS4a1l2j2at8yCLiszea/RHEWLQ4Ke+jn7FjnVP0oGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oXb4Fpa4MFHwRrwkqZI9T4pUhfuHt5njmJnPRXrf5EBnSRMEQAb0oJTtwfyoskwTiiSe9WYrg3H/euGYVkyAgo4Iz5+icCOas/VLJe8u3YJYhh73asTdaSSyFJjK8ZECARaaFChh7KOohNVwFTVHSL0Bj1fYi/MSzg1am9CUdr6C44gpQho4yNAosDPbFbj4R82BRygKAAf+4axmWh3zErDGjXC/IA8CI4cES/VV1zb15L6cPYXlKkt+lv52Mf/I3axGqV0uoujlcsLBlL1Wnb+liuvXfqGkB1dFIGqvQaDc1ntmBOjaSV7yshwaRD6JROqsWakIQg1U7hHi84alXvhq73Sps5GOaAwKq3eqeX6aRhu7YZ3UVQjRfkW52JgAdjwKgFZCRgTRdgSScNy+ctu5avd8pT4rZrOjUSfzm8fStasKA6TVPf1WHJ4GViDvQAbOlXsLrm15cB4GVdY0NEVTz0zSuWJn4u/Gc6WazJ3NiN8CH8I8vP99z6W4jWq72T6KUHbOcXLz4BYXKpqFc7jPd8V4U75xDH+AalgAHrnRESMYsbtsllZKwU2rKNuhy9OwNgS0no0WVj+BYaQHSzHlE/cqqrRiHbQdkPQSEhY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f00b12-9e7a-421d-5ecb-08dec620a815
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 12:14:29.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDV+0DbrrF0gUaHxMdzuF77+VyNA+M+GBtCAmE+bHhXMbjkwG7GUH43zyS8Zp+umzDXKDmFbvje/f5DdPL4mYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR10MB862668
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=874 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606090115
X-Proofpoint-ORIG-GUID: iZsupihxuYWoF3KtS2OSTzzJAyquQH1E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDExNiBTYWx0ZWRfX4xllm6Xzwu2+
 mz54OATQyJBNDHGzfA1PHggUvfNPy6Ql24/O3YTZbz1v5URQ61QiLjcl9xUoYloG9NlEK2TrAFz
 N0KgzOfuCe/D86/gWRXTNLi7n2T3PkHeOiwUz6w9dixDf3oncTh49+8WQ2Rg8DqvQlc6pn7gn1T
 jtf+1MUb5YHbthkyr4PRUQzbu71fxh9SpNwNJVlCCf8A0QYcavxNR04yXkKqO/gUZYN/LpdYhn5
 AcrE42y8YGfhcIbVGReyghS6Q07nQZuj0AGGKZ1835uikzDZYOoNHtaHDZCIGuPZnY3s6AHL22k
 IESvizM7MZHOIzQNevjTgjA/GDvf6nZfSvFtEXh7MvRwvgomNwHtx9kttshUZWNhV8yav6NfX/Q
 221P+3BY3u8rtnNPYIuawLfUna/O41YT+D8V8D5+W7JlRPz86rQY1dUMpivpmoCiTidZqNOfRD2
 tzFU4yJWVzzvFFT1ih6w6XD5loQ8kGgGQ5R5zC80=
X-Proofpoint-GUID: iZsupihxuYWoF3KtS2OSTzzJAyquQH1E
X-Authority-Analysis: v=2.4 cv=AufeGu9P c=1 sm=1 tr=0 ts=6a2803a9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=owEh_JCckNZbef9bl5UA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312

On 09/06/2026 12:36, James Bottomley wrote:
> On Tue, 2026-06-09 at 09:50 +0100, John Garry wrote:
>>> @@ -1808,9 +1809,11 @@ core_scsi3_decode_spec_i_port(
>>>     		core_scsi3_tpg_undepend_item(dest_tpg);
>>>     	}
>>>
>>> +	kfree(iport_ptr);
>>>     	return 0;
>>>     out_unmap:
>>>     	transport_kunmap_data_sg(cmd);
>>> +	kfree(iport_ptr);
>>
>> sorry for suggesting this change, but this is worse than what you had
>> originally, as we have so many paths to call kfree() [which means
>> more bugs possible]
>>
>> it's hard to make good suggestions for this target code as the
>> functions are so large and complex.
> 
> Given that it's allocated in a function called by the routine but never
> actually retained by anything what about defining it as
> 
> chat *iport_ptr __free(kfree) = NULL;
> 
> ?  That way we don't need to care about freeing it in the error legs.

It's not just freed in the error legs, as 
core_scsi3_decode_spec_i_port() calls target_parse_pr_out() in a loop

while (tpdl > 0) {

...

	spin_lock(&dev->se_port_lock);
	list_for_each_entry(tmp_lun, &dev->dev_sep_list, lun_dev_link) {
		...

		kfree(iport_ptr);
		iport_ptr = NULL;
		tid_found = target_parse_pr_out_transport_id(tmp_tpg,
				ptr, &tid_len, &iport_ptr, i_str);
		if (!tid_found)
			continue;

....

	kfree(iport_ptr);
out_unmap:
	kfree(iport_ptr);
out:
	...

If __free(kfree) attr can still handle this sort of flow, then ok.

I still think that it would be simpler to keep the mapping in place for 
longer (to avoid all of this), if possible.

Thanks,
John
