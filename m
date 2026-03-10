Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FEA3D1715;
	Tue, 10 Mar 2026 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773163314; cv=fail; b=P7g99lQTG+iVbHrTCIni2l9yAJgDG1an5DA4ypAK1bn+N0P7coIFtlsf5MYpcZFsJrp0dg0bK7jQXCZJz6Fub3LdB/2lBe+WImV9nYIKW408Ol25wLK1mIEH72YRkbmqXSgsF3gIVHJPDQuadsAtA6ToqQtwU83pJkTANSAtmFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773163314; c=relaxed/simple;
	bh=Yb/aH8fEjrpHJCiQElUU2bIgr50ZXz9hlIye0nOjL/0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=trE7Di47i6Ask+i6xpfnTykFUpKiHvOfho5RNNuwr3T2oqcv72l9EEcVXtT1snXN2v4hdn0sNuVQclV4+xM/7fIZdtFYu8Hyi79Yy7nR1SnP45Vx7uITwmlhbxavovejG7tLoiR4q4jlNt7XRfprXYg65oI+DMFxE1UOth+8PmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XgTJl+qm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kke1jDCX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XgTJl+qm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kke1jDCX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9Mh0j2910645;
	Tue, 10 Mar 2026 17:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XPKtkt5xwkFlTkxWoUPLNVcTkM3IjTCn2O1DTi5Y9eU=; b=
	XgTJl+qmpiKHfuDM3KiKA9L/H6LDNC2aAgMlAeR9jbeCfDy1/qFPoT1fCC7GiueC
	a6yQapTJZ5tqBrEiTJkcgg+JipKLCH7uk46HTLiRkEaEkOGbuFVLQeW8wNVTb15c
	vGC7jUTfzEgFcrarCHuFSj52q7UDbdeUoGCCmkh9AzjiPwF07uDNL0QPCwT2NL1M
	Osv56KCn/5BsOcQcb1qS741AFfCD7FbXJi9Dete9MGbzUQnt7L8xB8k7ZEVk45iL
	XNptywMEOunAjDC/nLwZTR+1NTLhlr8E+L5+1pbqLD54AndPefZXrLr0fnCeO/De
	/IpIrb0Lw/3Pc4c9ogQuTw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskua3au9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 17:21:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AFmTPQ022734;
	Tue, 10 Mar 2026 17:21:24 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafadfvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 17:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJhVuOIgJNDHyZoUZ71szdIP0ADRYRqA+94mdk8Af+SZfKl7Ocq1IKJ5jmZO7Q6VKXhTaEEKOCCaNPgZbUelBhjx80Fh8vwO2ncV8vRJXpVtqakVUwDV+qbk9UQs5MHJYrX8H17qV8Ub48ZiHoIsIwBs5DcaXzhl3TWiQuf5cpXoiUiDqIaeLpxwEYsBLTJgFBf+IV9j/sKGgJtaEzxyeP2XBg92FAW1r8UA0F5Nqw9roZbhinjCXC7Red+TbVcU8xyUkbf8QsfLY2APTmzfh4P6wcZXqyYljaTgtDNWg1ZQydDetGahosrzPo0AL0Zo7UHu6A+bXQrDBM4Hpfe7EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPKtkt5xwkFlTkxWoUPLNVcTkM3IjTCn2O1DTi5Y9eU=;
 b=ldQ3C3UAP+x/6HXxD214ojbvfaK/14CGBHzvgYj7DANf9pc6IOAUf0NIJqxhi6a/b8QSfuI2I22rAjkgxmKKHrT4+BRYMAw0S8DXM7iFovVYVicSfj416v8VXOfTWPk1bEZDkmERguyN2BGgXwBfWX+Iur2gzpEILze4M8IbqWxX6C3rgZRV77eHNKorWnxp+rQfxFBLsK3EaawLPfurxiBmdDGeHxtIsmipxuTNE22ReWc/utNC6emrTlHU8lwF0DQL1M9TMUQAFcjdz2BTg+0m0au+3d0XGD+Ssfoov7L8CIkKj1ElOWn1HMu99oHhehQaJcF1LthxJTRaHtb0pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPKtkt5xwkFlTkxWoUPLNVcTkM3IjTCn2O1DTi5Y9eU=;
 b=kke1jDCXUQqI0Q5v1rCl8GlT5s7owvhrJ+yBwR/ZhBPXqv3WHXAtueM1Wr9H326UyUbOavL4kStyaMlaXykbqrTrEQYIwvFEoi+SWLxQPJ7K1kVF5uCRbU/yyX5Pt3Nbx57qdXvqWSs2ikx61mCoXHcqdhyhyovwTUkqVbMMxi4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4614.namprd10.prod.outlook.com
 (2603:10b6:510:42::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 17:21:21 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 17:21:21 +0000
Message-ID: <43d86b29-7fc5-4d11-b5db-a1389140f8e1@oracle.com>
Date: Tue, 10 Mar 2026 17:21:10 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] scsi: scsi-multipath: Issue a periodic TUR per path
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-8-john.g.garry@oracle.com>
 <fa7061d7-20f1-43e8-af65-2afb02e428f9@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <fa7061d7-20f1-43e8-af65-2afb02e428f9@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0068.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f25bafd-4dcf-4c5a-b1ec-08de7ec97282
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	65KetPiUHqH1kVwJie/gV6b2HxfyRievo9FcquOqaofn2fR/l/ioGLe2807w8K7SHJy+gYFkxaKa8gkjwHIh9vZZh/zCu5kei30W7+ugW6XDn/2YlvpiObWE+vdxgNS0AWTkGuJWZXHXPHhiJ3rr1SPo4G5BD7IRG79fodeRSwLVGET/5PpfEr6ttyTnMWYlHgD3tKkR1VpqCMjtT3mdcf0B8lbze1OTjuvR+BBuA7OOhNSQQsQ6pbmCz/D84zVrFfwuwxgGLiyKEY50qUL+2DROCuXCR1dUjc6dbhXuve6wzPnbdXDqaLLuWiTJ3nm02HbFtU1kGlvylgsvNVbMxTtKjbAAhsVH025GYq0U/zYWYs9CB7HnunWrQ/j3+LWcUZU5efh/clroeVJSfjgsS0zJs5IT0Dnxwhi14ItWih8tigS+nvSqrLwQude41z84ttpcFcqZj6z/ALdWKhWRyx1lnkDruPe0ukkccuiw4Zs5urb4OyJMxil0Z1lNoF+4CyaGd459vSav9/NPXM2IwQn+WvKjuqvuBQxuj/j+xwjc+99+kXj/GTXs6tbg9hiA5jyrfgtl4P4Vtlpluktq7Sjw/vMUiK+/dEQKZ3Qtk+VjtnokUwXXMko0JIzWAo0YoLk658sOilrHpuRSk1VObgo9KMnjGbhN2/KNT9YoWzi9vun0034dm8HS8Zv5RF7GsO0rejGFEMIIJ4mEH/VVKc5yeJYzaOTWBdBU+fb0xaM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M21RWXVFRlZjZm9tTjdDeTRaUXdzN2F5VmdJVmc2V3V5NW15Vmw3eTNMM2Vr?=
 =?utf-8?B?ZUtieFdKMXE1NTQwQytkYTJiOFZEV1g4UWp4M2ZHeGJXN21DZ2lld2pMUGkz?=
 =?utf-8?B?S2FKVEtoYTBnQ2xBQml5dTNNbXUwdGo5ckxtbEZoaERLcllXdGZJdDhVZlYy?=
 =?utf-8?B?NFNtRFd3NnBQUk9GMU1QQXNoaXpnS1hBWTNhS2hSODNCOE1oSEFzamI0YW9C?=
 =?utf-8?B?MzJqOUtzWlBFR1pNaE1vQWNUVFVpUitvZHRCN0pqamNtVHFmMzdyUWZheEIz?=
 =?utf-8?B?MEtCK1VLd1hBTzM2SlJUV1BFeENCd2RDLzYzaU9ocUtuRnN4WnJ5OEdwZkpG?=
 =?utf-8?B?VzZYdkVMbnR5VisyT2t2MTl3dkdkM2lyZ2t2THh4NVBSR2dycVU1MXI1b1R5?=
 =?utf-8?B?T2ErdTJVRmc2cnFPNzZmYUtUWThITzc5L1VFNTljT2hJaEZIbUlGSGdzMUxu?=
 =?utf-8?B?Tk0xUjZzMENkNjAvbWtQVjFRTERhQktPKzE4VDhFb0pKejkrU3IxUDl6S05T?=
 =?utf-8?B?Q3ZJUHRsY3BrOWI1QUVqN1FoVms3cUtyZXlDV2hGKzFsdFd0ZmJDNzFZOWVR?=
 =?utf-8?B?V3d4UzF0cHN4UDlIemtCckxoUkhDR2RabFc4bTlscHl1UE94eHRpOGNlNWEx?=
 =?utf-8?B?b1Yzc3NWeG15Z0tZK2swT2lEd0R5UHprR2Jxa1dDRzl1ZXlwNE10NGtST2FL?=
 =?utf-8?B?a0F6Vmx4Mkx5SHpIL2JmU3gzTWNGZFN0WE1xYUhlbnkwNEt0b3RJbWU1bmN4?=
 =?utf-8?B?aDVYZmJ0bjU4TVlBQVdETm9VcGJBcm41eUxHMXBMakVEREZCTEtyZ1B4ME1G?=
 =?utf-8?B?M3RDTGF6Vkxia1VTRThTZyticU5Va1RzbTlXV2s4aE9XQStxZ0VXN0VnWkJC?=
 =?utf-8?B?dTdFNmI2YlRTRnBqUWZvVThHZWkvZkR6RWFRT0NaVjllNjNnNU5Ob0dkdEFY?=
 =?utf-8?B?OEhFSnZZeGpxbFN4bG81Y1JyMnAxS1NOSXlDWmFUSkcwQU1ueUlTWUZ4MUM1?=
 =?utf-8?B?MEl6aTdBZENaczRUMzMrVmNnb3ROUmZIMXhtdUlnSkNDSVV1by9HdjlEb0FI?=
 =?utf-8?B?OSs2aVRVenBhZTIxZ2lBT2xvZXlCZVgyV2VHbUtlQVJ0SVRHYlFIYVlXVFZJ?=
 =?utf-8?B?RkM3a1ZNcHQxVER1ejBjc05MRWl3S3h4RVJYNjNqNlpxUzhJRVpKN3huUkZT?=
 =?utf-8?B?bHZQQ2kydFVaa2VoY0hzT1V3RXdHN25HNjdXK3kyTGVIdDM4ZFpWVlk2UTNx?=
 =?utf-8?B?Q0tETTJSRVpIcEg2MTE1QjlPWTNhOHBrY3gxSmhPUjVlRnZOOWxVaG1Qbm1O?=
 =?utf-8?B?a1BiSWRHdTBtUlZYR1NPb1ZpWnhRK2FsR3lVa1ljSlhLblltTnFyL2VkM3p2?=
 =?utf-8?B?VUZNQmhhTE8zY1lQeU45RHd3aWtVZ3AwZlNzY0cxWjY5eVl4Zit0anZ1Mk94?=
 =?utf-8?B?T2ZnRnBSWE5PeEhnL0lYbG1SNHkwdzF4MHBDL3NoMm1iMXMzeVpvcGdnaWJX?=
 =?utf-8?B?b1diLzBiN01pUkJFRjNPOUNDck8yVUlrUUpaVkI4dHZ6Y05tc3czblptTG1K?=
 =?utf-8?B?YzZsVGllL2dGT3p4ZG1QSGtucGsyVnVmblB6ZmQ0NTZyM0VaUlBEUWw5ejJl?=
 =?utf-8?B?OEpnN1U1Y0dzSWxmWWtDMWpYN0Eyd21GOUFjSHdZeDROazdONGJYOG5IRHFy?=
 =?utf-8?B?VjA1c3IvbGNLS1dPUlBJVnM5VVdQMUs4U0RDYlFSVGhmTmIxWnhmNE9tbXdm?=
 =?utf-8?B?RlZLNzZQbGdFZVE2WEowczVNQWtXeDJrdHF6cE8vLzRueDNSQUNlUGNETUlN?=
 =?utf-8?B?Vko5ZVBRUmlpNTIxRkNZRDlqUVZsZzUvdmtoR29qclo2SURmNTBDRVFGeE1U?=
 =?utf-8?B?SGxuY0U3b2dpeVFkdmcxTnJXTDhOYmZCN1hWZGphWnprUGkvcEJ2SFBuaHJq?=
 =?utf-8?B?S2o2UTFJVWl6UXlac3FPV0dJUEp5OFg1dWJET2NqZ2x2a3ZvaXZZU2d2YjRP?=
 =?utf-8?B?SzlqZjhOcW4yamI2U1JucUMzZUZpci9HRGRoaDhqckdHdVRxeGh2S0tJL3lo?=
 =?utf-8?B?S2JJS0JZem5HMWkwYjVoWUtxSFZWZVNaZUpTUUFha3lWeDNFb3FlajBMVFdk?=
 =?utf-8?B?T3gwTWlmZ1U5MHQ1azBUMGo0dFByazJSaFVMcjFOb052SGFtUVl3SjdGTUI5?=
 =?utf-8?B?cGJjcmRFMjR1V08xek9XTEJXeldSZXpURWtNMC81YXJBZ2ZBd0hsNXhCNktz?=
 =?utf-8?B?ajVZRkYrOGJFamVwVlNPbWh3TzBkanVrYkdZZG1IMTIrbWFCL1ZqZnFBT2I0?=
 =?utf-8?B?NlNKYWlZNUVDQmFIYi9kTkxDaHQ4Wm1IQWVNNjc5RDBUdlNpRHJtQkRybGNx?=
 =?utf-8?Q?ptNMxKqT2MuFCB/Q=3D?=
X-Exchange-RoutingPolicyChecked:
	kfJiW64QGm9yZO413nO8Ax+lunmYJklGFG5AjqZHwGC0qz8lVRd0M63MmMLrMSXXtpTFs+7zaRC0hMr4IXbWj1LosUA8jvv+XfCvRr57dhGik4CusSgrHXPEvx7NRVzgi/Cas1s3IR4RkBcTcPcO2+VtopKCA3/llfJtfNClQyrSyp3t/mmSwlxZe1kFkuUnFeN18SFoBRRyZ1pgDgDQAlifKJnQEQqskvR7vGRbODOtHPive43FrZMWI5cNpGWA+954AgT7gZpmEvcr+e/Uj55cZABXbEq5Kt+Yw60CWo8l4L9zXb/PZpShfeqTOpc0ah2QvX4EJ5CyeBC2NISt6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0eENMuDspV61dTQEcc3drs7IqUKtR5ct9qxE5vzUQdcHeAXxL3nHoOxtW2Eg+1RmBvxoklCtc05AE12Tqgdg93axlR8ATb88OHZddNvFSOMsqeMu2kzfT3Gwifwmk9Ak5KXmJDDJU7bl5yKEw9zwhw2KF/oEfuwANnyIFveeAKXfnt8H97F4TQENPosLGLzn0GT8p5Jir3EzCVP2m9cl9NbEBvrXN67AxROmSGzOoHY2IV3kB0xnqJNzdbfVuLTaA/bLcnnck14UAORc2fPZhXz6rb3kk6K266Ymujgrj00czcuk4pkv4Yw3HmE/6ambNPi6/73DtLIZnyJrYIBu8w9vY3DwaIsfN8SUkIvgi/mllfGKkUB8dM5dOiE1VITBgQVQWgYAbWOHU2qA44dqjH+AIUwZOgCo1g1/oiA+5RScisvWl9fd2MSx7WxNenT7LPHg0zjPqesa4qM9s0vogsQuvLW+AAhyLte5WkCl8XfYFA6JGDXgFKHQQZJe2yIIoNIPhlyKgfhSc6ZSwCI1VXhybheh8cUTEyFszdgKPd5/4RZynokIP3wcYvYbK9edraUyLfYOeGnWUAm28xM2TVCXiuFUjgFqmkyTTgCvTzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f25bafd-4dcf-4c5a-b1ec-08de7ec97282
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 17:21:21.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7p8d90VK9Q9DfbmhXLSMtOAmQ3GfSa9mg8UAVd2DD2A/HIDB+L+Mgoll8FDHgsEy4wyTSSEDH2LAKV7wrBzDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100150
X-Authority-Analysis: v=2.4 cv=Methep/f c=1 sm=1 tr=0 ts=69b05315 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=lcsUVGDTQm4pBSCVfgMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE1MCBTYWx0ZWRfXx+AyGl3a4try
 KjkI6I6T9GLAspLebELuN20SKr8Nj96+7F+c5ivaE0Y2RzYYV1etXgSNUWFirJUrXvUsRB7Gmle
 Nt3pjP2ieIAZXZMiVxddkSl/WxzZhgafpc23O4UDDFXBCl/6Rprk8cH+ywRnGA/T/E988ZIQNDn
 dcDBgw819K/sYDkEubSsO8LcTH5t8KrC27IlabRG8TVFx6+mQn8WRs9WcMv8JfxU2kBkIuNaRB9
 oM9+w+pgwC9HRtN9rIyb7V8QMouw5yMz41kUq9Z/mAcr+8NDnfZu9/NrJfSsM4QnvZNnObZgH+h
 YXyEVH2lkLldrrj7+l9aK564o/29tpVghXqOJr5xkOQCQzZxf4VwlVhMNaaGaUJSnKLAQVAE+CJ
 Xaa12bV49icPG5PKpoUgtHIgg3S6K8UqrAecnAF8S3lKDqTrUaiGOJV7LT2k7Rr8QmM5neiCs6d
 oEWqS5u/gvrV5byPocg==
X-Proofpoint-ORIG-GUID: MSuJzanzvdV-Dv3n3ntxco7INKZKpvQL
X-Proofpoint-GUID: MSuJzanzvdV-Dv3n3ntxco7INKZKpvQL

On 10/03/2026 13:34, Hannes Reinecke wrote:
>>       struct device        dev;
>>       int            index;
>> +    struct task_struct    *kua;
>>   };
>>   struct scsi_mpath_device {
> 
> Please, don't. We should _not_ go into the business of doing TUR path 
> checkers.
> Path checkers turned out to be a major issue for multipathing, and
> are mostly pointless for things like FC where you get reliable
> path information via RSCNs.
> Additionally I would advocate for scsi-multipath to be a _simple_
> implementation, restricting to the most common scenarios.

Sure,

> Namely
> implicit ALUA only and reliable fabric notifications.
> If you have anything else, fine, use dm-multipath.

ok, fine

I was just testing with linux target for this, which uses this in-band 
method AFAICS

Cheers
