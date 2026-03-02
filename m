Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1380E35DA60;
	Mon,  2 Mar 2026 11:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772449936; cv=fail; b=p5MPpF4xnB6OFrieXqmrMOw7ofWZ5TyBDM50F7C+3Wm90jVywgKtBG7tmFfYceuRmeXE0fpQRPH1rnh7rh8JPUoKBg4szxvuK36FD5wAbLdsI7zVEtFoRM/gDJUoKwjQZvqzgjo+kD0vYK0d/FpFQia78ZctiRRoP5rwFQQHP54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772449936; c=relaxed/simple;
	bh=4L+PbxvUSZOPZB5DoC28m6qwJA7haqWnZMgRjBnTkDk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=au/J9q9oiIJNYlywspSY0KuGc7z0MhuBx43md4xYzOfCZM5bVC0s7VZWYtjLs/6zbaMgEf/oQIEnmQ5x18W5bbdw055zc8KHriXv3jyvAIGH2akZxX1+EkkK3lA+dUVcd9oehfdNsreNBSXzOlMVnHEwZaryQo+t/gHt5CEpSM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j3DKuZI9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=G80t2g7x; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j3DKuZI9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="G80t2g7x"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622B3YLP3252838;
	Mon, 2 Mar 2026 11:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gAHbpuvC12MlUP/8E2fHXvBFBQuTaLLL1hUks/TfmAA=; b=
	j3DKuZI9lvQLomkKxXWEFgPmmphJmjEUqkEvhHeOvoC8ExssVJKsNLkZrgkQpCkt
	DXczuP5nbGKQNK7kEeCsIWqdzRZR6O3dsHCWITwwIh6aYzuUAhXqz7LKtNe77olq
	F5+aiJABd2YdV7QBt1x2Mfksk/u4Aes3fYCfE4FR0oQKdwHivUsieuP/2eM1ad9m
	mqYKZGNSw3fM2jRzcf7sQP0lOcTEEmyshm6VH2g1SY2saygo+dXWb/2HMY3yJNY3
	BSuXUQHL8RQgFv1HdZiKrOeRvcDALahhB2xCBTEXYsX28GorpeLS+oN9YQ6auL9C
	3RwjihfzbXvKzrxJI6b8Iw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn9bc00gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:11:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6229egMx037868;
	Mon, 2 Mar 2026 11:11:52 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd2wfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZ+pq5T2EUaoNCR+nX3VwmM+WeuJYnTJIhYE8YUkbl4za1nTfyJs/6SLi+Bp5Fl3XQDpBw9iaocY+oituqhZYeJpQIQV3M4fmY2o/60B6IvCInKIl59tDUUkftFLi4w1uEe+W+BKGvkBTBC8jTMsu3/LQCqCAp9RBVFwpbx7kHr63E+W9XBCO0sy8UZNfJSZ2p/HjnhfR0s7CdTV1ogTYUtoBrxD5hREqsD+5p/+M5Q/nM6POHMq9jd91YF+8zVRv1mGYvtT/08snxFwVX1U+PWo9h+6Ba8wDgFte4YBRCeUQgLFx7YlVdRKoHz0lLJL+zS3qYl3u1wphu/hlGPRlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAHbpuvC12MlUP/8E2fHXvBFBQuTaLLL1hUks/TfmAA=;
 b=kCCnCltulYllvFT+0SrQj+r/QXlRdMqMkUgZhR1jDFqSTcFIkqYEMLlZOjTNGcIW9TJuRFx67URv7gG82sHOSSen+NmSfix+T2tILhYFUxwvkEqyEh+Ifxd94HMjkkHC7bXCCYwAyd4lOFYBg3PsTzmROgiMb/cVwX2ECwyedexTRDcLUAN/YE8MthCGWVe0JNkLbzToeEaIJCzfHpvEyyeTZOX/+ngtfdXxHOb6h/WMVCUQxHxlWIJb0+0EVz9P2bLMes8NS7RR++t15AY0cdPw0OpVEkd4D64yU6mrh6gGANs83XD15qw78wQBuMkNU4Dyz7Fr7zuQMugQLBVlaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAHbpuvC12MlUP/8E2fHXvBFBQuTaLLL1hUks/TfmAA=;
 b=G80t2g7xg2ZuyeknGByXAATj55aRHPfnDI4bu1JfC51gjQoiAfJVZerdMCnjsSFQ4hkf/1tE3Juf/Jw6OXawKiUJPQgbydinHD0bBBUaZiIsxwdGQyH++dkFpUsxL6GFfedP1pWqziew/l+bgOH6iUl3nFeF3NlZ+MawQ8H8iwI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA1PR10MB6877.namprd10.prod.outlook.com
 (2603:10b6:208:423::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 11:11:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 11:11:42 +0000
Message-ID: <c9e0f2cc-8c64-41e7-bc46-823d8a5f9844@oracle.com>
Date: Mon, 2 Mar 2026 11:11:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] libmultipath: Add sysfs helpers
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-9-john.g.garry@oracle.com>
 <aaHq5EjVVYODGxjA@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaHq5EjVVYODGxjA@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0177.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c420e7-42c3-45c6-0567-08de784c7b78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	KmCtHfHf72QY6VQlYMX24mpTI8/AN6JL9rfyVR1gGeUAhDyEZRPMTc6F/tBVAdqqZMF9hseentnI6N4+QN9CPJhrTkiq2DUX/QvwNPtKgxY6Op8peIeW/K/WJ3zijp244zU79JwoLNKdw9G6pxrvYfJNa6G5TfM3wrBDJBnceIMiIkYfA5NbowHN5PWcIRp9ooJ7XilWBHdjpxWM+h2pO6y2kx8nxMxY//X69VFxbejVSe3arAcBIQwOIldwbJ79YSnwucTXZJwtjGSg+syOzCIo1a4wreWOV/AULtSoQqpFz00q+BG8WU2IkxGv9W7wXfcNYg6Z2fjXjb/J/FTB7UOGptWnKcca/wy6ryJgY5rUcI3NjNv7gGlMAgM0qcAVjYKS4vZVxVt9n+82IQ59SLzlcegSzXqzluFBzEcL8jA183ftE+hxqjSDdS+7+rILBWgiLbZuW4j9sOjm58RY2T4IAxUXUsYyQe6b3uLuxuuNaHzFo1sg6iuHnge01t0hjQCesjbY3Tl1eL3gDsBAey9Xt3HHUk0NRm+G1pmkxmSWypNuub+Ja3igasIUi9HMB67Tzquxq43FtOMay/htu1GNFNHf3pHmBF2sOZJbcm1sIOJ97nyfzg3K563SNmqERUbuKMbafyIpOG/QK6tJ7TjGaifnWDeXK+8xBbt361aNGarts5hvAtaYWNzw7HjWaItbLrsxUsk9+UTFce1IoQx84W4dFQnDCNf9UylIQNU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEVBd0JkcDNld0lTOTNOZ2JNcVo4OEVMSHc0dDg4RjVJZUxYWnMrU2trdjB0?=
 =?utf-8?B?YkEwc3lBNVBDd3ZxZDY5QmgzdENYU1g5SDV1U2lZK1VYeGJ3YldhZEhLUnkw?=
 =?utf-8?B?dXlnZ1BCeG1aZjE3dDJYZFZMcUVpTFlVSHF3ZzA1OTdjSFZ6OFJtWDU2b28v?=
 =?utf-8?B?QkRzOUdFT09LazkydDJYL3U0YUw5NHJqZWVYMzIwalcxV3kzOEpndWRveEps?=
 =?utf-8?B?S2pyOU4rRGFzYmZnYUhGYmY0a0FkamxHMzdBZk8vVzB6Y3l0YWg1QWNaaUVG?=
 =?utf-8?B?MG0vdzFKaTVsRFVZQlFrY3htM1dUc085dTdNZEhRMkhGM3RpUzVXdGJNVWlG?=
 =?utf-8?B?SlE5ZmhaRGM1RkFSU1JJUytNSnE3aDhlUXZCQnBtZ2VraWpIb3pjU1dsdHc2?=
 =?utf-8?B?d2RyT3podEVaN2lJQmZrdnhEMHZBWFVacTc0dFpGdWtGcGhEL0d6LzdWYjBt?=
 =?utf-8?B?NFdlSHlFTnB5bkFoSCtmVjQ3cm5mVVIvck56WXAzSFpjSDdSZXRGUWFMYXFn?=
 =?utf-8?B?dHRWSXBvYWp4M0J2cUx3Yng4anFHMkt5ZUpKektuTG9TY3FYMnN6Um0ycVR6?=
 =?utf-8?B?Y0srMWR5ZGxwYXFCcFkySTRaSVN2aFFhM3hxdzdJSlJMK2VtSWJnZ3BQTHdP?=
 =?utf-8?B?SW1VTUEzbUFDWG1ycXhTVzJBZ1JGYWlzZk1MckxzcmdndUc2RnpuRStlWGxl?=
 =?utf-8?B?Z1pmWlVjMCtFVE50WUVlelFob1lqblQrWlA1NnVhUkh6Y0cyK2dIT1gvMVFr?=
 =?utf-8?B?UDNwVkpUMmRzaTJNWTJkN3g5OWNiN0o0UW11MzRVWExrTTg5Vytab2phMnAy?=
 =?utf-8?B?RG1XQWt2R0wzSXlUU0hzLzJiYzBLS2IxV3M2NVp3ajRUOGhBWkpsam1iaTIv?=
 =?utf-8?B?RE9rRTNvKzFEU0pIMTVsTEpvYlhheTMxMnhkVUxNQVJucEM3R2lzNUF3L2ll?=
 =?utf-8?B?ZkRLL0phSWl2aEJBSEowSkM1ajF1LzFONGZ2bkQvOENiMTdBdUNTN1pMOHBZ?=
 =?utf-8?B?TmZFK0dUdHBnaERFL1M3bnhORU9tZmNUbnNMZkdPeDB6dVJtUG9VcWVQb3RX?=
 =?utf-8?B?bFNZZEYxeUNZcTBtZXh6ckRRY3QyUUVQcGVzY1BEZk1pT28vTGtqbi9CVUhU?=
 =?utf-8?B?TTFDdTRtUXlKdlBhODY1bG9NKzRTK0FYejFpQkJSbktocW1WampsdGpPK2xX?=
 =?utf-8?B?TWVkdlBiTkp6cy9BTDdRTGNiSmFoM3djOWQzM0NVM0FCZFJ5Qk1pMDhxTU9U?=
 =?utf-8?B?b0ZNL0VGSVU0SFNKdXZnaEpGVmZuY0d3MWl5ZDFqakhtR1A0SEpOb01KRXgx?=
 =?utf-8?B?L0pMaFdlTGZ0Z1F3WmNzM0RFRnE2YllCdnpwbDFPTmFNSTMvOHUwR0ZMSkJU?=
 =?utf-8?B?K2ErVmJjczIwMXpyc1hHUzA5akN4Mlc5eGdvV0x3N2R2SFV1V0xIVk1pblNL?=
 =?utf-8?B?L2lvekwvc2ZtY3NmQU44ckVGdmVMWEF4Vi9jNmJMQjR2R3hlVnlwcEFCdFRG?=
 =?utf-8?B?UFdFQ1FyQ3ZRdzNGeWd4RWVudzZpU1JZM29lS1N6Nk1IaDNXbjRoWklpZFN5?=
 =?utf-8?B?NFN2TC9nSkZjQXlGRmtldzlqdjF0WHd2eXloaURXTFRpTUtzYnp6a0NCQTlt?=
 =?utf-8?B?SjJjcGpmM2t3VGs0QllrdXJkQkNncE9LWjcrcWdwTUhIcXpxUjV5Ym9DMUI2?=
 =?utf-8?B?bWZDZEUrc0YyRVUveWU2ZXAremlkTThGM0ZQaFF2aTVFekZhUXFDSVVaUWxL?=
 =?utf-8?B?WlExOS9HczNrWWNGQ1MrVE81MDE0YmVlVVJHYS9iWk8ybm9Mb1pPd0loYjJq?=
 =?utf-8?B?enRpK2Y3YnZQZG1tclVqMlI3akxTQndlY0QrRDR5OWlpVmJndzlmRlZvd0lY?=
 =?utf-8?B?enRTUUEzLzV6OXMvVzd2b1IvRWtWN01DcnhKbC9VRWJ6WEpPN0dYY3VVejdO?=
 =?utf-8?B?YTh2bG5jY0p2d013ZVZ3V0tEb0d1aHg3VjhLeHRSNVl3dW1odC9pRDZTZDZW?=
 =?utf-8?B?WVpDWHByeHp1K2tMZTNUMlZPSWl6Z2NKd0dWYXAxTlJjL2hzS0tTTUIyKzM1?=
 =?utf-8?B?VnBRM0dGOEhWazh3THRWNnoxZGhOZDk3bkVScUNPWlpKM1BEeGdkRXp2L0Q2?=
 =?utf-8?B?OTk1a2xJeTE4a2d3M0taWTBkV1o5TUtOcXo5dkcxc3RDS3dsbmlwMVEzYzFr?=
 =?utf-8?B?N0o0VFN0UWFJdUxoZ2hsd1RiMjlNTEFiNkpweVk4dktJS2RseXIrRkV4NjJ1?=
 =?utf-8?B?UEgrdnJ0WkpFckozbWdGZ09TWmZnNTk5aFFhMGhHd2NxcGZqKzFmT1J5OEo5?=
 =?utf-8?B?Z1Q5cHdhSGVObndwQlEvU0VZczUrVzdsd3NMUk93bTdGeDgyZWIyUFQxL2Iz?=
 =?utf-8?Q?ESPYWHqeprfQS+vs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PspcKhYcRn7xdNxi8uS95XgFKDE0W6Vtxa8Led3PhuptinIcYAeTjZpkNQ2v0oyARygDgp6+EdFNEaeXqUVYGHuu4Iz7j1JZ0jUDeQuMSHlq8XD+ZZ5AxMXEUUzuq3vuOY0TTcPMnI+7ozFGMVStHCi8KvbDLEcardFm+dmfjGx0UmUpMgeIhu/hKTTQ4q2qvF56TFX+At+3rlzZ0xPhVQE+TRr8LIUj9o5dnr29MTUWWJdXfVWJH/iJtHCGP1WmnBd91DsaLab42z6AuopxqT2+zMLhJniOqlmj6XlzYVp4tBhzoOU7tnS3Hd1x5nBuZLhtIDmj4uOX0rLLpnsH81WYNX8CSylvMM9p9XgWyamte3fLiyxQYfScI+Ldz2bXME0p1hL4v9OFzkj0KfwimFKEzkPljVOuRujgouVnNa8OpdzyNKmzq5i0dFN4G+NRMxGCkyZgcu05pQGsIv2XpM5cm9+ovlz+2g5mkxIIEgyqowC1V2V1hNWXWcNTnk4+PSFqJ5XrMM1r43c9FmTVDOJsCshY3rz6VPyWbfCEhlRlyuohzf9BxOdDdNPttl8jgg0zkdz1+JoH7z8zEm+V/m3akVud588J9rggiXhrlPc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c420e7-42c3-45c6-0567-08de784c7b78
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:11:42.0199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8qzlfKurnzGXePmNBwLozMUwlkssfwPof0vt83poAX9oul7knXGIue1wsrug766rOc+z4vTLUgMFQzcq9uq9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5MyBTYWx0ZWRfX7lajOWha8fQq
 Ts0j4WT2cqo8EzE7E+SL8BqKhGmUJGJboYTycESRxSq8XCxWAPQcdJtcWnwIEIppXS1lFN9yo/G
 ejKrkdmgdcLTc7dMf9A5tKHG+MPVe6V4eRDdWsT6SWpAu+D4ZRwd5J30lpCpokCKsjG0KZqHSyC
 Jbc+JGscaQMJEWAUBhaHq+S2n0mXoA6lI7StHysqVApBfiqF0duGwxYZH8XQjsAfIBRFJom3LB+
 T62DtNzsspuqJ7vzJEwIV2VGndiAz6HncfgFSu89v0sVkOC64xXseMnFfVF63zJuiRUrRM8GQ0l
 s1MLihSGJH6GzYBkfg5QinRCb/So1+Arvx4yajCQC203C4tA62PlRGvNuBeWyEry6ZQ1s+R4uWz
 jJtrsxJgXc8Y8Y+R/Ls6qIeUBY8RNZp9aMKMazq6hAufT2D9uova45Rm2leBSSseBpcXjryZ0gi
 ampNpPKGFn/jK+R0eS016NBNrFFCeOS5ewulXNOw=
X-Authority-Analysis: v=2.4 cv=bNQb4f+Z c=1 sm=1 tr=0 ts=69a57079 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8
 a=qN2o6ahs7BG0VJ4wYiwA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13810
X-Proofpoint-GUID: esO244YgZ8DWuLZduLDpCM_o9csDMXrQ
X-Proofpoint-ORIG-GUID: esO244YgZ8DWuLZduLDpCM_o9csDMXrQ

On 27/02/2026 19:05, Benjamin Marzinski wrote:
> On Wed, Feb 25, 2026 at 03:32:20PM +0000, John Garry wrote:
>> Add helpers for driver sysfs code for the following functionality:
>> - get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
>> - show device path per NUMA node
>> - "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
>> - device groups attribute array, similar to nvme_ns_attr_groups but not
>>    containing NVMe members.
>>
>> Note that mpath_iopolicy_store() has a update callback to allow same
>> functionality as nvme_subsys_iopolicy_update() be run for clearing paths.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 1ce57b9b14d2e..c05b4d25ca223 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -745,6 +745,116 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_device_set_live);
>>   
>> +static struct attribute dummy_attr = {
>> +	.name = "dummy",
>> +};
>> +
>> +static struct attribute *mpath_attrs[] = {
>> +	&dummy_attr,
>> +	NULL
>> +};
>> +
>> +static bool multipath_sysfs_group_visible(struct kobject *kobj)
>> +{
>> +	struct device *dev = container_of(kobj, struct device, kobj);
>> +	struct gendisk *disk = dev_to_disk(dev);
>> +
>> +	return is_mpath_head(disk);
>> +}
>> +
>> +static bool multipath_sysfs_attr_visible(struct kobject *kobj,
>> +		struct attribute *attr, int n)
>> +{
>> +	return false;
>> +}
>> +
>> +DEFINE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
> 
> nitpick: this could use DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE instead.
> 

Yes, that seems reasonable. And, FWIW, I think that 
multipath_sysfs_attr_visible() should return umode_t.

BTW, this is same as mainline NVMe code, so that could be updated first.

>> +
>> +const struct attribute_group mpath_attr_group = {
>> +	.name           = "multipath",
>> +	.attrs		= mpath_attrs,
>> +	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
>> +};
>> +EXPORT_SYMBOL_GPL(mpath_attr_group);
>> +
>> +const struct attribute_group *mpath_device_groups[] = {
>> +	&mpath_attr_group,
>> +	NULL
>> +};
>> +EXPORT_SYMBOL_GPL(mpath_device_groups);
>> +
>> +ssize_t mpath_iopolicy_show(struct mpath_iopolicy *mpath_iopolicy, char *buf)
>> +{
>> +	return sysfs_emit(buf, "%s\n",
>> +		mpath_iopolicy_names[mpath_read_iopolicy(mpath_iopolicy)]);
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
>> +
>> +static void mpath_iopolicy_update(struct mpath_iopolicy *mpath_iopolicy,
>> +		int iopolicy, void (*update)(void *), void *data)
>> +{
>> +	int old_iopolicy = READ_ONCE(mpath_iopolicy->iopolicy);
>> +
>> +	if (old_iopolicy == iopolicy)
>> +		return;
>> +
>> +	WRITE_ONCE(mpath_iopolicy->iopolicy, iopolicy);
>> +
>> +	/*
>> +	 * iopolicy changes clear the mpath by design, which @update
>> +	 * must do.
>> +	 */
>> +	update(data);
>> +
>> +	pr_err("iopolicy changed from %s to %s\n",
>> +		mpath_iopolicy_names[old_iopolicy],
>> +		mpath_iopolicy_names[iopolicy]);
> 
> I not sure this warrants a pr_err().
> 

Agreed, I can downgrade this to something like pr_info or notice.

Thanks

