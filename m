Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A08E34C80D;
	Tue,  3 Mar 2026 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541737; cv=fail; b=EUzNg0ThCtKbqQ2XpMwe010MKEGWO4U9VnO23WmkYXU0mei++kDvDsqCbaYGdJGRCjCQsx8qME+B50VAUz73zRxrd4fF/nt5u49M76PJ9Skk7cNC08XxJW+shKwAtHZxglItH1n8oUcJSAs5qwLHPyn5SV/dXJRaNlnK2N2YBFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541737; c=relaxed/simple;
	bh=UkYNWACtbqj9G43RR8O3mwRt6X9WIJEs5Qwlx5f5n+Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uZD9jt1HW1hD0d07GQAReNRQ6vLAxUhnR4q4NKFikNtKnMNcd8y0kejya7SQrumFXpAahlYwqRfdcW1PI9pai4OiNgvle5CIdp13HWD5ygJxhFWAFVlnmmNPYiJkauxo/PRZYXF+l1BX0ja8m+f72Hx2GiDzccMvl5+87RPl7R0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R+MRERUr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oD/Yyza3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R+MRERUr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oD/Yyza3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623CZV6O290356;
	Tue, 3 Mar 2026 12:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YE5AKh7kQP4nB8bxMxmYE4SYGxgg92M/Y85cGwXsOAU=; b=
	R+MRERUr4YVlVxqmoxWTtRGX5lRsEJlCGUhYMXOOtB9QDhLCkDQF8UuSQQ22G3l1
	Ch8MkgCNW1G6BHaKIHRimIw8QLBMsTOE9Ezb7xsJ3hNySqVD6z2wyAIVi5uPOTW2
	HBWXejOCeymJQmDbhHZ996uo2Mz2ljUzmMnOY99n2kvlTErVRgZBgFf6eMo+uton
	eZaHifsBs1VhwGWQXmDeI/d2yXqYED0oEPChOEBOjPHuBJEKet8KiBu5bg8JxMVl
	JfGtFV+9dxs1jKfAhY75hQssMPlpBmo9kQOBIXtvB0Pz1Bdlh0YtcJ88mOaRYw6X
	OdMt12he+ZM/A4d917HHbA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnysjg0a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 12:41:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623CUAfE027513;
	Tue, 3 Mar 2026 12:41:57 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012062.outbound.protection.outlook.com [40.107.209.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpta102p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 12:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xLE3pIyGQHHIdFqdTBGUWMXqkbCDvjfosauyx7QPWgGP4XGBZIzHd3lj6Es/ukBRTS6aKrnsvF45wQVEYExVkclhYV3kFGgcBNTVmAS7cx5gk/8khNSRAsBCX6zI/GWiqrno4sz961jn5M1Gvbko/Rs8IkZNCzhT1jn62xO81vNma0bHDR8QLDBbOatx6zMGoupkrqE6Q0Do86DY+vLYR16xliKEzEEB51pHm2YY6UXhTF9kTxEcJC+Ze0HYE6oxW5lSbcSEPHY7AEM4pNJCX0sqD9RHVIhl6WpbVzM40MNnY4jmuXuPcgQpRgQl9uUvdo7qQKy1/oT+toIgXuhhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YE5AKh7kQP4nB8bxMxmYE4SYGxgg92M/Y85cGwXsOAU=;
 b=JaXF8lBLWRiWrJPCrxvXSfVALhdGVqOw1gyxzCHdaO8mU5WjjVYp7Omc8ndmoBzAnCBo6nqoVoSQCcU4KXZP2uSo7Rhn5D2IitedagVV5hNBd0ZvksadBNrBd+qTzsnBaHraANG1s5O73ZPDgbKX8OYqhIeC+cUO/V1jZkDx9DPP3StK6XROVbOUqpHRKsqTmjdg2KDaNTnrBX0MGHNr6y7uORqnkczwzevrps2iGyrvupMICVdA1+AEXt6yvlEOd/nOjeaGX0fDmc6RWFKz5VvS/JJlhPHI0NCyo7mOHh5doJaGJSfKhk7BJLulL+N2dhpnLTmoD4LoEfy1gehFlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YE5AKh7kQP4nB8bxMxmYE4SYGxgg92M/Y85cGwXsOAU=;
 b=oD/Yyza3I9bYfXU/inFdblJ8ygxhmQrIQb5M4ovpfltgx79AF0UKf9jp3Mg4xh4DIdF/k3VqNIMvgYj/rKAuGLkqWqkLcxdiGxhCmPE5b2dHv40ptdw9ddpTMMVYS12+tRL6m/9otgZmsarPRHbKKX5/3qOqD0yMeUeC0MY+pLk=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH4PR10MB8227.namprd10.prod.outlook.com
 (2603:10b6:610:1f6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 3 Mar
 2026 12:41:54 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 12:41:54 +0000
Message-ID: <bfd8c2c2-65f7-44f0-a4ec-01158e249505@oracle.com>
Date: Tue, 3 Mar 2026 12:41:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
 <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
 <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0185.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH4PR10MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f456ab-9390-42f0-0d2e-08de79224011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	NFBGjAaGndQjcI+xG/vX0FwjheRMd6KhL7H+iVjNE8F58T80/9tLHYwlS2rDYKNowvD3Ggz2ysGF/PNP+Vlr1A5s01ifHYbVUfBy7FnXeNsUzw+BGTfd4VnqIjruYJ92Com9GJi588WEpC5TfQWtr5C6dMKYgCbIZSBruioyqnAeMPqwGGN4UNnj4zzoFKG07f0hH35FRgn2S/PACc1UOfPtXuCogxtinmizI8fl71bfODwCf0QPgP3yBg6UAa3KhziPG8bSqidHVHRiLJajm/YKVDsl8Yu/wU7oTLd05EFHFuD+8TTaSNQpdZ7u1z4V59vDDl7fHoUL1NSC9TCO1/U+qMG/NxVu8bPXUTah1h2vkKHW+lSqq59Gz87paeNE/y9fIb0YY0fea+G7q8F2OPGiygbBZlR2DYlCGyQvvjv3LatPYyCGdDfnnqqqJhUB/5kOA2HWz1qzt+G8WH81SN50pm47bsohhpzbRoOTeavkI5cMVuHiJKEz7AvtNTKWQU0hmtYBPRFzqFaNJToPSHdZ2D6LPTnnSFeXEL2jAHHapEyXZKKo5dDXXXBTua+/1sCF8YYEulj0O7w7EXlCKng55vs01pf7/CYtvFzkNZSH2kd7BVtO+cWPrAIlpI/HixGhxIQ9sPMGp5YNo/0qTbRPx6vwPJC1SLwaX5S/Cu4qe9gK8prDvSwd9FBoCSMkHivmpqafoQYMzqyQvrZ54jyICVwmDwEi/P7nUmzY1Ww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzFiUjU0OWJ4eUR5YnNlbEdDRnRiNFNWK1p0Q0EzWCtnR092UTl3bFhXZFIz?=
 =?utf-8?B?S1VDdkttbldjNlNIZG1LajR4QUR1bWR4NzVCd0M5dlpMQkdNRkN6azNHbXpX?=
 =?utf-8?B?ak5aVndlMXJMMVFZN3VqSWtZcWZHYS9VNmpnU0xUc0p1dWgyWmZIcGJLMXFS?=
 =?utf-8?B?dzdGVGFHalgrMzg1TnJiUzVhQlN4TG1OMEQwOFQwU25YRWVnMGl3SEgyTUYv?=
 =?utf-8?B?bVE1VHVXRmhpeWlUS1VNSDI3TzMrMVZlQ2dtWVVPM0dwdUdZY0l2b1dGR0Fm?=
 =?utf-8?B?RDFvUE1ObHZGcUF3UjV2Mkw2TUdJVkxwS2V5aFdpblRLUll0czBqTkcvZUhB?=
 =?utf-8?B?RlQ5bDVCMHZTN3dTOHNCMGhCQ0ttc3pWaFJaSmtHdnJSYkJzSWxpK1BSeTM0?=
 =?utf-8?B?WHVqVDRqc3JJd2lCUnpoaHpYMmV4aEVGVWZLNUc2em1RUFJoWGZZeGxURi9G?=
 =?utf-8?B?NTd1ZXo4cDVnVGQzNmJSQlpRUEFBNlRmVzRMcG92V0plakRVVGdOZktSWjdn?=
 =?utf-8?B?dmc5VEIwRTZPSllyYzhCa3hmQVBrT25DeE85Qy9qcmwxL2JHZjRhV1NQdHFu?=
 =?utf-8?B?Q0JuS0I1L1pJNEhxVnZKbkhKb1pMbkIwRmZZL3ZvS1l5MG91cngwRUgzck5Z?=
 =?utf-8?B?L3p4K2JXcC9yVHB4V3VTNTZsQS9Mc2hnakFuK1Uzck9vQVAySVdPVkt6b2xJ?=
 =?utf-8?B?MDVLVks3Z1VmMmdvbC9TbmpRUFp2amNMNFI5dVVDNklCTDBTR1ptZ281QWt3?=
 =?utf-8?B?OG0rT3FSQ3ZrTDJ0NE52TE1leDJJVnVWQjZMK1BZVm5qRmw4eUt3SzhBb2dV?=
 =?utf-8?B?ekVhZkN2SVJTK0s0ZnQzZnVMVTVMajVpRU9zMUEwZE9NaWVZYVlEY0lVbEZq?=
 =?utf-8?B?cEtQMjBFOVpGNFUxODhRMHBXaTFwajN5TDFkeXlwcy9GeWw5TFZxOXRxMldl?=
 =?utf-8?B?aU0vUE9XbnZkazdId21RK01qREw2OHJaeStQTEpKMjVpRFg3NGdtVm5mbzRU?=
 =?utf-8?B?c1RJSUxHeWRadTRaV3hzK1MxSzRzTGJRcEpTSEFpY3FyNG9RS3pRMlQ4YUFT?=
 =?utf-8?B?OFlZODIxMGwzZVI0SVJ5Y0h5ZkVONzUwM3QvOXpUQm5Hb3NPVDZob3JEMGF5?=
 =?utf-8?B?VmRvekdJY3htYmFjR3NUcWNxUDBPT2p3SnhBQzdBK1hHQXJoSTdaNkkxTWtH?=
 =?utf-8?B?Z1dkRkY2eUNkMmJDOTRhSVRKTk9DRnZpWFE5K0x1WmRVTmVwV1JSZDE3WG00?=
 =?utf-8?B?Tk43Z3lmTHJRQmxtdnVMU2Y1Rzc1YklEZUJjUU9XYUs4cmVFL0EvWUVTTVll?=
 =?utf-8?B?VUp0c0lIQnduV015VTA5aHJIQnlDZHJyUGQ5OVZmeklyazVEcGZNa3Nyc3JJ?=
 =?utf-8?B?OTk1bWRrRHE5clBSbkxSaDNGL2VOWWpFak5mekw2Y1A5L2UzOEdCOG1kTnZ0?=
 =?utf-8?B?b05aYnBFMDh2TDJLSWdTWllxNkR4RngxRGhJdTloYWIwTWVDTnE4QVBYVnhl?=
 =?utf-8?B?bEpwUXY0TWZnTTI3WGNzdnlCWXd3V1FZc25wS0RmNnBjTFM5K0gyWUh2bEp4?=
 =?utf-8?B?SzNXZlBOb3JBcDNHditXaXBqRjN5cFBqd2I1Rmk2V2U3RkRuSEFremtyTlVT?=
 =?utf-8?B?Yk9HUjdQNHgvMWd4NDkyUld2b3VheTRBbnA4ek9wM2VBOTRqOFlVdmFtbjIv?=
 =?utf-8?B?Yk81Nk1pcmU1MkNycnE2My9ZQ3VJUGFVNHdpZUtpdS9zbWcxRkIvWWkybnI4?=
 =?utf-8?B?MU1RM0s3enJFT3MzdUNGM2RuaUovek1kOUdKQll5bC9mbjdmQTVTNHBCOTJn?=
 =?utf-8?B?cnIxeWlQdmRBeEd5TmI5bjdQMUxpTzNYQXZoVFh2SUwyUWE0Z1pFMS9McWJG?=
 =?utf-8?B?VytqamN2UE1xUGJNaFk1ZVNXRklvZ0dkRitENDZITWk2R2d1YUJnQzh2T3pv?=
 =?utf-8?B?R0RMTEwzZ0NlUjdNQlpuRUdSekppcVZNLzArVHRxNEdicDV3R3ZIM2tuMVQz?=
 =?utf-8?B?NStCa05udFNva2RVZzFKRTNjMHJQek15cGpNYzFPTnF5UG16Zmt1TDVQTGJL?=
 =?utf-8?B?b1lrV01zUXZQTDVDanIwL1cwTFZGTGl0QlV0MHJCU1dTTWNBUXhodGs0OTJr?=
 =?utf-8?B?dGF6MFNYZUlFeHQ4QXlSSmI3djNFOXlEZXRrOWJGVHNRaU9hUmRzTnUxRHJo?=
 =?utf-8?B?eFpPc0hwdFM5WmFOTkVLMlZlaFFYeWE1VS80UC9rTTZoM3pSdWEzbWpKQm9y?=
 =?utf-8?B?QXd2bC9yMER3TzNFcFpDVjNOSENxbGFvZEYwWmpzbkxJVUI1eGFlR2VubWRV?=
 =?utf-8?B?czJvSC94U2U2Wk0xenZ6VWMzOGsvckloV214NFVySHdRdXY2TGk5OGcrTGc1?=
 =?utf-8?Q?cRTZIw4wDzQJaxi4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7vaqOLnMN9NgusoqnBdY446C7Lxa/Um13IrBkl0MX1IdN2pMooEnPdaOxnc/JLAu6GN9++PsoEIe/lHWlP7xi7K8PHGJ/mazTEhTYILIIl0LbJv5K2fJkSe5nUuxGOaLwEHmqWedx68xdTVBsnS2fdWKfMIoD1yV1mLMb7LJR9LaKSTpwRrN55LPbvnAe6h12W1WT4OWM0VHUkUn3qKESl+1THK4J2FRCbFHVA/VXfMLoKPjmORhAHWWWdMs6kZPVSdKQ9EvMroopDHed0x3xt4yhf/thqztAvhSxk4uWIEkaiSCsBK1CXZXqkgTeX/97/5s0qtxg54Rx7U6AWBDla7c7ppL0G4jKKtevQ0iv0+KEvRjDhvKqkPa77efpZcCpZ87ZTMMUYfpz2qjdE6QIBVLr9kU+Ii4X7vFKY310Yges8wzVL54ZoxqpqIAnIFT2E10XjsxyhepEmy/fhOZnxIj0F45FS39Phma6WyEN20QNeViqIu8XlderHDAYeUf1MP/cGJG3/ugNlEtlaeqp+cAqPUpqb3xP9qwtBOTZXYGqusk8ePNy/9MywrEC+cDHMlWJZHS/K4xtUw3UIe+RxfLsTcgn/sXU1wAT9zwWCA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f456ab-9390-42f0-0d2e-08de79224011
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 12:41:54.5289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcuTMT9lbo2COs3/0RYJ4SQk/iErIzpcQ3JNPWK7I9GNr6XgE9BOv562MAy2iMex5gOj21JIuiCJPnRYbCQraQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=962 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA5OCBTYWx0ZWRfX4kqtanyLMpT/
 YBd1sFtducZxGpdqKs6sgkNPnWt8Mhou+ew2T9eN8gKkLNuTRwwbhSBcKyB3IaYx1ZVkkpha5T4
 kfGMZFsKCJOGP9gc2hkLG+Q6wRfKpXrWavm4d45UMZrLAJzzGk8utaL37X3S0h7x6eRiLk5XwEe
 /WHU4A9P/EfRgO3qzYGWETL6F3iWh8+bFp+Je+mGRJPRKW0WO5w/SK/58GBpr4mbTlqS7bP1Vj3
 0pqwHcCpXX2PUPn/2I3jzu8SQ4jZCW2Y94voTCXbUBQUhT5Dsys6TilY7Br9OYh2aTy2BPo7ObV
 cruY0JGndsEEfcxh7IOS8FdetdoKW9NOmaUfGaUqqqLTK5peRb7P2c/cQ0bwIaWF8OKGnPOZ1zW
 4djjQMPVFIt7fS+2+3SfPyuDwckaSKz7fpy7X5vY/aK/B57ryC2G4UwmqZvH3UqoAMMMSGCclQ7
 oEYtU4JCAfA4/6ymo0Q==
X-Proofpoint-GUID: zTBoELe52aNsJ3qPda1zu2S4SjYCTxv9
X-Proofpoint-ORIG-GUID: zTBoELe52aNsJ3qPda1zu2S4SjYCTxv9
X-Authority-Analysis: v=2.4 cv=EqnfbCcA c=1 sm=1 tr=0 ts=69a6d716 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=xbldQJShFL9Moz5i8pAA:9
 a=QEXdDO2ut3YA:10

>>
> The nvme_mpath_start_request() increments ns->ctrl->nr_active, and 
> nvme_mpath_end_request() decrements it. This means that nr_active is 
> maintained per controller. If multiple NVMe namespaces are created and 
> attached to the same controller, their I/O activity is accumulated in 
> the single ctrl->nr_active counter.
> 
> In contrast, libmultipath defines nr_active in struct mpath_device, 
> which is referenced from struct nvme_ns. Even if we add code to update 
> mpath_device->nr_active, that accounting would effectively be per 
> namespace, not per controller.

Right, I need to change that back to per-controller.

> 
> The nr_active value is used by the queue-depth policy. Currently, 
> mpath_queue_depth_path() accesses mpath_device->nr_active to make 
> forwarding decisions. However, if mpath_device->nr_active is maintained 
> per namespace, it does not correctly reflect controller-wide load when 
> multiple namespaces share the same controller.

Yes

> 
> Therefore, instead of maintaining a separate nr_active in struct 
> mpath_device, it may be more appropriate for mpath_queue_depth_path() to 
> reference ns->ctrl->nr_active directly. In that case, nr_active could be 
> removed from struct mpath_device entirely.
> 

I think so, but we will need scsi to maintain such a count internally to 
support this policy. And for NVMe we will need some abstraction to 
lookup the per-controller QD for a mpath_device.

Thanks for checking!
