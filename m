Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A90C2D949F;
	Tue, 21 Apr 2026 08:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761192; cv=fail; b=EdjFqXY6rVGvC43r0hALXqSyMRxOxV+tQN3uIXbg8muBZaISRgRnjfQQ2l3AA3wi9oT+O8oEQXWBcko6m0zWLiXHexaRf0PP7SXp/PIfmYvLuHhxyQUnXyHkKC4/b1P/9C5OVCcHiYjG62oz37ryyJ5WIMxU8hT55z6G957GjEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761192; c=relaxed/simple;
	bh=Jj4XVD1KK9nQLwmyRKLIgTes5zNOmuoy4sjVElRd/qY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwRmSh2UEyWOaUEvRhC6q6VPCkxT9bey1QQ04vAvgDfaolBSVWOTR8kGNKFR8CplzDENdRNYKi7JJ1sgBMoucLr6ZB+iy99XSfhxDhXrPsIpBzp5JBLB3OxXSXJnD+taJBkydg4+zrRK/XmK3VgUY+J7LaEVyK+YZbk91rc7o4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G/HPBCKP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P5FFZbP/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G/HPBCKP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P5FFZbP/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLu3Lh210241;
	Tue, 21 Apr 2026 08:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KyYhD3+3QTw8gBA5xv3eEhy/S0Z586Bm90BAq0GSOKE=; b=
	G/HPBCKPQirkH5M3UUteM9iNgUP2fVIzV9I4TSizqUvHg0/n1OyxF3EmWoxThyoQ
	ZbvTxxgLKlA+kymgaBQp4Bf3+GuauHApeuDMPGGTUznPKAlbjO0ZccESEbA6OnO5
	k0Pnr6mpNiEdNi5TeV99InLeU3eul1tXmzGEi+B589GOc9uGG8aeZ5RJZlQPSQlA
	UnWB+p+8jTv9VhCxR7ZZi+axtIteWoI49VjcLirfc02lnDb2f1TGwwSUNc9zj+0X
	LEfzMRthnuwBu4JkPYv0cwmvNddUWhxiaIphF3JhvXI497j7N9rffqYNw3Ar9BBJ
	8Yp00SfvXcfD+mkrb6uKJw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2grcxnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 08:46:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L8fKd2039466;
	Tue, 21 Apr 2026 08:46:02 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011069.outbound.protection.outlook.com [40.93.194.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn1889mfg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 08:46:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RP90KdMM2aUoRsPqWN6Eab6C9UZxERrIapGMqrY35Jrd1ziPiqTaH1qdmDGxD0fs2Nb/3MkpbSVY7UAmHn7qqte7JFlfAddwt4IcB7G946bpX2ByDOrd35j8qgLilv70k7jkneWNUBy/anmOltpom/eZyKWVwANk7GEcE+h8bFCxXntSu5aYRap1RT5r7vgdWacSShmzEZoZG48ddS6Kfz91yXFqig2sLbUbfLbChDrAvp2H9Ccsg7Z+BULgoo9i2EkpJcECm5hR2uC8/tyUm/MzK6jSz2ciM2ehxib/ZkT+ltAY5WuDuQvk7oGErLHrth8rrENfdwW+iz0fyZKRXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyYhD3+3QTw8gBA5xv3eEhy/S0Z586Bm90BAq0GSOKE=;
 b=GboqVhoUsPqvWSXBvj35RNJ11/dsrP0btXvsm3YIG9twUzvyOK3bhLwKcUEGVuuhhtM3Bk9PafwSkJ5v3OeAWmmIyipiyftUID8CupLHXgPmIQQX4udULVRpmRnuDO6k0ZRkDv3E/f+uVmNJB9XmLLOWRpeLqs+cZzlOHz6bDkh3n/gCZ9NN+RNfeZmpdt0duMpVryeQFP4Ew7ipOEt9mk04SuiEWrvtPKaxWOxWDmbiXI20WLgL57gI/kpOp9qHg2vGBxrXBKvUIEE7zp+/hDH7YMX4n1b/njg9LtkAfGoXeBFb5jiani04MojXTQZZ/IEODIg24riPbQhUocStgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyYhD3+3QTw8gBA5xv3eEhy/S0Z586Bm90BAq0GSOKE=;
 b=P5FFZbP/o3aRNKpoFWU9yqD4Xg5Ek407blMlhTOGWYohKMCg1qZJwHCoqD61P9UMjc4f6K+CuaEioQbTMsDV0Gcy0TfkOE7xmUVic+voOTvGyegdGLRTjabqJ9eQ2zi7Eya+WMubEyrASxQEN/I1vbAMsJWpLmT7fwkzrIhBvFM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA0PR10MB6914.namprd10.prod.outlook.com
 (2603:10b6:208:432::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Tue, 21 Apr
 2026 08:45:57 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Tue, 21 Apr 2026
 08:45:57 +0000
Message-ID: <ab9e8e26-5522-4072-a2fe-07df5cb64441@oracle.com>
Date: Tue, 21 Apr 2026 09:45:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: use percpu counters for iorequest_cnt and
 iodone_cnt
To: Sumit Saxena <sumit.saxena@broadcom.com>, martin.petersen@oracle.com,
        axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com, Bart Van Assche <bvanassche@acm.org>
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
 <20260420113846.1401374-4-sumit.saxena@broadcom.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260420113846.1401374-4-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0429.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA0PR10MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5620fb-2f85-4ebf-093a-08de9f826829
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
 waPjQSjNpDCDvKTfMVnQTNx9YdkJKDm0Gt5oqUGnEaMOQvKPj+Ci/uFsESiViItPrz51lzADd1n7qWAZj4VqVrJ37n4mCV+wcFjUL3kjg3A4sfctOT7QwAy/12ycT8MMJHH55D8G7fyDxeYSu5IhjrdCyUZ3raLu4mDmgTKl792G1e+8TPC1VYoSSLf+d7OMhMmlOKLi9cJBZrZFLXuYWQM5Xd40KP0+ImH5BEHw7TLC1UQIxKxmeeseRFb5oJLHAUI07msJQKzYF73SH7b9g4XaPTBZ2XH8zteqcDnMNlb1k4SLIYlmpeJLHKKsAIcKVv07B5mUV+v7KN8q+FWKfWU1Y+0oCoZhg23pWHFp3Uo8h88lFfJpmNW5qkZ5hf57knm72zRzyn+nJbsJfNkEpMMb4KRxot72bmFqwELeaV/QWPp2fg28sLo+BPQjhe9hUGWGBAtqySI9y4Fwdt4qmkJcXY8RNTAsdu7Fc23mTzEYNW0nNu6r+DDO1PQQunse8m/8Dk6vDwZrYStFWMfLtyU3DK/odQFFi4J+LML1ry62DLFmHJgYLbWAGGBmg4GZonn77dVDQIPnT0ufdAvJbn9y9hrWfkhBQpQvzCcmfvghAOerojMBy9Ts7bHICFOeAj1iObjon0m1W5mNrI+zhxcEjd+H7yu0VpDGWz6fhRYFeEnlyx9DLUMIANwsJylvPTN+Xn3G1mwHi0ASp5akG+Fp5VyUQNWSy3n89zcEXII=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Mk5hVlhESzJIM3JrWUZDbVJTTmwzaUpuMDcrTWVYUGc3clJYdGhlazJOUjFS?=
 =?utf-8?B?RkRqRzBOQ2x2QVBpUEZHemdHd3I4WStKYTFGYlhTN1F6WWY0OGJuSll2YzBj?=
 =?utf-8?B?WnhrTXFIN1hzVmhoQmsrWTh4RDNLb0pSYkwrNGV2WitwcXZmR29RaUoydlFr?=
 =?utf-8?B?STFTc09rZ0FYUmg1LzNjMFA2UFVUQ3VyZUVKWVN3aTVMZ21pcDl1bCsvcVhm?=
 =?utf-8?B?SXFLS1FINEN6WWZyektZcU9naHU0cVdKREJpZ1FvR2c0VXVWVzIrYWVlc050?=
 =?utf-8?B?cmJKMlM2MVNxUnRWMU1mbUVWMG0yT2FRV1V0ZXdJQ21DMDNEZGJRUWcvQkZo?=
 =?utf-8?B?UHpHSW5DWDdjZHRqR1RXdjJSNWhwakF4QngyMWUzRDZKazRQQUgvaitmOHlT?=
 =?utf-8?B?WWNNRkxKNk11OXhTK3Y5VE1Sd2VJQmEyNjMzMHdaUzhnTzBnazA3blhuYytj?=
 =?utf-8?B?NUxYV21HR1NudkNNL2JoUkI2Y3JlV1ErenNqQ0J3bDQ1MElnWis1bkxwak1v?=
 =?utf-8?B?MVFkOGN3VG9TQVJ6d3BQdmhKN3J1WEZ2d3F0NXFQTjVGdVlXeXlmQnNuUkVo?=
 =?utf-8?B?NitVaFFabTFSVzJMTklaZXFzbGNSd1daOE9lMWFjTDZxRVUrYlpIcHRPTmV4?=
 =?utf-8?B?aU1OVUpPM1ZWbVpwcCtjekpSOW4zVHg1RTZLb25wRTZoZThWYU1KZjRpK0Y3?=
 =?utf-8?B?RHo0a0EyL0JWK05vR2FEZTdNQ0MyaFFZZVAyUjBneDAvaUwyOHUyaVp3UVpO?=
 =?utf-8?B?cGZNVi9uRFQvVVk5T3FENWtORkVOcUVnSitJQlBNaEM2SUlGMmdGd0ZmVmEv?=
 =?utf-8?B?Tk1pNmwzMFN5ek1hT0pWaS9Gb0pmai9tWGtKZW5ZUUJ6MFRicUxVemwrajRv?=
 =?utf-8?B?eTcxUDVIOHd5UlZ2Z2E1Ti9kNVlOKzJiaXBIUTl2YnQwMlU5Tmo5VEIzejR3?=
 =?utf-8?B?M1NIbnM0RmJNYWR3UVJhR1pEMU1MRUg0Q3ZEbGNyU1lMcUdlYnE2Y0c3SUda?=
 =?utf-8?B?Ukt5cDdZT25uQlRGSzR5eHRwN0drYlFjdTNlaFVKbCtpU3ZUZHZtdkNUM1BB?=
 =?utf-8?B?TytRWU1UWFNlR2pmanVjSm5xTndQOG9pbjRUYlNsMGtNa3hiVU83UGJ2VmMy?=
 =?utf-8?B?bHU0WXB2cU1VN2FyaUxrQ2dXRVUzaURrN3pEQ0FPbFN2czVDQ2lBbEI1YnJS?=
 =?utf-8?B?dGJvUUFvbGRqNTlLNVRDUHp5R05HRFNQdmNWM0RnU05CT1c3SXdqSHU2aFpF?=
 =?utf-8?B?bjRIT1VBSStUZ2pjdG5iQmViY09GaDJwSXRVZEhuMDNEVmU0UWJFc2Rnd2Rs?=
 =?utf-8?B?OFNFZmVNQmNwMzFWQlhhdE9Sb2MwZDJlUmlsV1pkTFYxZnVIYnVLeFBpU1Nr?=
 =?utf-8?B?RGIrVlhKMWVxdEs2RUNyd25JUlFNM2RNc0I4ZTJQY3NTNGtoaC9zZ2xxdVQ2?=
 =?utf-8?B?MWZzaS9PSEdzY0hjZVhrbFdDZVZVSTdlV3h4QkNBN1lQcmdYM2RQM01BdXRl?=
 =?utf-8?B?VTRCMXpyaG5ncjBvYVM0L2tpZVcrTHA5UHNueFkyZ1FZSUpIck5oOXJpbzZP?=
 =?utf-8?B?dmh3YTVibjhuS1laTlpGd1ZWVi9HZDJuMnZ1UWw5R3lIdHpjdFp2VWpYazE5?=
 =?utf-8?B?YlhERDlJMXdiVml1TmpxRGc5aFBXVG9MUjZGWTVQUFBWOG9SMXVZUWZmTlZl?=
 =?utf-8?B?RUVGRVZpZnZ1TFNGNzUyd0NkYzFvOGpSUGdSeGtPMkEyYWxhRElaMHVIMCt5?=
 =?utf-8?B?MlpleFBSMGE2VE9NekZFTE9BbXF1QnlOV2MzMS90RDE2ZUhBVVF6R2VVV2ZG?=
 =?utf-8?B?a0NTT0M1NitHeVp3Z041MmJQTjRJZFZ4dTNBSDJYd3AvRFdwQ25sYnBSZmlX?=
 =?utf-8?B?aDk3Ty85WTYxMnlhUzB2Zm50OC9wV2lSTlBIMmdDWTk1UTRsbFJ6Q1Zja2dr?=
 =?utf-8?B?U2lENXM5S2ZyOTY0QkRnSFpuZmZOczZZejBMZlRVNFZ5dStTOXdYaFZoaXZW?=
 =?utf-8?B?Sno5dVNJL1VLYWdQb2hrVFVibDU0anFWVXpUdGd3WHM0dXB0VlRpNXMrWGVP?=
 =?utf-8?B?TU1OWktzME9QS2xTcEdNWDBiWmUrQUxNa3JGeVFaWUw4dnJ3M1ZCOE9EcC9D?=
 =?utf-8?B?blFjdUx3RWRpS3Fad1JYaXJzQW5rSTdNWmU0YTh1bEE5STBXbzlZeGUxM3A1?=
 =?utf-8?B?UDZMNllZcEVSOGZScXd5R2IzcHNxbXpEeW1CUnVheTlIMkxOcUNQaDBNdkVU?=
 =?utf-8?B?YlFObUdvYmF0R0Z5Vk56YTRtRlZxUzhPZ1ZnbXZsY1dpcWdnajBpY2FWaVlh?=
 =?utf-8?B?cXRRTUxxSkxuOU5FMFMva1ZadFBId0Q4ak9CWURjaC9JQ1ZnM0FQZz09?=
X-Exchange-RoutingPolicyChecked:
	Jl6xiZIIFGUD4bYNIhYFm11YR8qdeS3YLILMV0ozUBDjrVgWt6J0UrLE5DjT6+ysWT4SrDa8KMKR4io4d5Wt+4qrYxEXUJjQnM2tNOgwR4m9AOwwMegngxBsHTjqC1r6JX1qMYCC5I+83BGbNUZyxFKRmTc7M9KSfype45Q0A9rBbOFO675c15+HFIPsZa3dFcEw3dC37S1tATn7uHFMO/oCXpeg4rUBbcCEL1DqyMhUf5QSzOO/y7kvN0xrRAlcx3B2TRIRnVoBMIFK7v0GmkfKjc4W9Isp6sC9L5CMoMWGUv3JdwysOFPyAzi8Fn63FY1dceGmTqvfqSMnf+rFVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MO4Igr5r12hLbM2vMI65Z2v0yZO47fkvInRUQ/nbOEzmtTwaAqOkEeh6Ds3o/0ZvSen77rb2rPGg5MklaAZXIlTKC9HXyl+B4HN8BYwpWHla3MdVfrxqeCxTF5uhvkekGhY4Oztf6DRh5wmByo0Bn2s5UL5ai/DO3zNdUfhPaGR0Ige2E7iHD55Nn0jnZJEtfvpDbysoK0kUkYnXsaxKgyA0psBAg84+kGs9r4YDveXKq5Cvqi57tyypGpTaHeDE9gxth7U4Ss+SrIZHysT6R0MlJFL9rJe+ZzmnwY+DVpatwD57ma5oQKdjfyOm89/G2KS+eOSKaoRKtYBIwuAK99nUS1qcHV4oqmn/sD5MzS18ky77WZmIwvq43pnKfTz31V1ZF37bV6Kr7YeLvCHEnbM6Xpl8cyM+2DOcUrYXTf08AuyxSk5gKLisA7parVBvUaHmGAM1Y9IuDUU/cpQewexM7zDKKyHYDpvMb4iQI9zf5y/MZLVqmGWmUEq3dfFDe/HF0H6LIeTwQTbKYCZ37YvaDU3LDPPzC/Nm7dBtPc1a0kZX2qfjAHntYSrxBa6J0Z0kqFCUUjRPteyWyuVCX9M9LCOYnXmTI0QwccS9EEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5620fb-2f85-4ebf-093a-08de9f826829
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 08:45:57.8347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: it2NbiSB7IzfJlFBkqIsNnXq10bhVwlxva84F6B8CzGBjtWbBrahUNbfRgDqQjFAgwGgUDRsZXGxR9+0Htdgrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6914
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604210084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA4NSBTYWx0ZWRfXydxtnVYitfW4
 HCJvCXrSw44/3C9mG/aw5uI1pb5nkDYRF8FFhYmuraZYR1eqyVDMBCZj4UL3ddogoWmTKwcRYuK
 m2exKi6DpwLul0OsThE9KCr84B0mMeL2qoA6bPDTgENBpOUHptAkRdkjt15IT7xAyj4ZLi8dYKK
 NaDMddS1dOtYkotyeal6QWI7L66Vzkq7CMB7352SVoKP0Wrlr8rgAm5bjxEEx8VS6ofbzunzeMu
 5swX1ezT08oIGD05nV5ndpJaOgJR7fWehvIOVg0u8D9eNmJOp9/634GmFn1dRp8VyTLCV1rg45b
 6rQHoBaSbicBSOfiMv+p2ydDUbZX+jxIS/IbcT/95sSuxZzcsAEUjh3Mfis/P6abor9CLcngAj5
 WjAwKyLJkj5DK4cBUOXbUEqoYLBHV931wUNVXBEmmU+5lzSBnSAVcISCnijbCoRG7nD01Wgu5Lh
 K2be6Y9uMbgg/BTxVWQ==
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=69e7394b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=N54-gffFAAAA:8
 a=Q-fNiiVtAAAA:8 a=ZQ6_QC_ej_i6MRqeHC4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: xQFeyFslt5fkSbQaGh__jNcuXUzhvHXP
X-Proofpoint-GUID: xQFeyFslt5fkSbQaGh__jNcuXUzhvHXP

On 20/04/2026 12:38, Sumit Saxena wrote:
> iorequest_cnt and iodone_cnt are updated on every command dispatch and
> completion, often from different CPUs on high queue depth workloads.
> Using adjacent atomic_t fields caused cache line contention between the
> submission and completion paths.
> 
> Represent these statistics with struct percpu_counter so increments are
> mostly local to each CPU, avoiding false sharing without growing
> struct scsi_device further for cache-line padding.
> 
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/scsi_error.c  |  2 +-
>   drivers/scsi/scsi_lib.c    |  8 ++++----
>   drivers/scsi/scsi_scan.c   |  9 +++++++++
>   drivers/scsi/scsi_sysfs.c  | 27 +++++++++++++++++++++++----
>   include/scsi/scsi_device.h |  5 +++--
>   5 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..c7424ce92f3e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -370,7 +370,7 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
>   	 */
>   	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
>   		return BLK_EH_DONE;
> -	atomic_inc(&scmd->device->iodone_cnt);
> +	percpu_counter_inc(&scmd->device->iodone_cnt);
>   	if (scsi_abort_command(scmd) != SUCCESS) {
>   		set_host_byte(scmd, DID_TIME_OUT);
>   		scsi_eh_scmd_add(scmd);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6e8c7a42603e..0b05cb63f630 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1554,7 +1554,7 @@ static void scsi_complete(struct request *rq)
>   
>   	INIT_LIST_HEAD(&cmd->eh_entry);
>   
> -	atomic_inc(&cmd->device->iodone_cnt);
> +	percpu_counter_inc(&cmd->device->iodone_cnt);
>   	if (cmd->result)
>   		atomic_inc(&cmd->device->ioerr_cnt);
>   
> @@ -1592,7 +1592,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   	struct Scsi_Host *host = cmd->device->host;
>   	int rtn = 0;
>   
> -	atomic_inc(&cmd->device->iorequest_cnt);
> +	percpu_counter_inc(&cmd->device->iorequest_cnt);
>   
>   	/* check if the device is still usable */
>   	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
> @@ -1614,7 +1614,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   		 */
>   		SCSI_LOG_MLQUEUE(3, scmd_printk(KERN_INFO, cmd,
>   			"queuecommand : device blocked\n"));
> -		atomic_dec(&cmd->device->iorequest_cnt);
> +		percpu_counter_dec(&cmd->device->iorequest_cnt);
>   		return SCSI_MLQUEUE_DEVICE_BUSY;
>   	}
>   
> @@ -1647,7 +1647,7 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   	trace_scsi_dispatch_cmd_start(cmd);
>   	rtn = host->hostt->queuecommand(host, cmd);
>   	if (rtn) {
> -		atomic_dec(&cmd->device->iorequest_cnt);
> +		percpu_counter_dec(&cmd->device->iorequest_cnt);
>   		trace_scsi_dispatch_cmd_error(cmd, rtn);
>   		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
>   		    rtn != SCSI_MLQUEUE_TARGET_BUSY)
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 9749a8dbe964..0b4fa89149af 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -351,6 +351,15 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   
>   	scsi_sysfs_device_initialize(sdev);
>   
> +	ret = percpu_counter_init(&sdev->iorequest_cnt, 0, GFP_KERNEL);
> +	if (ret)
> +		goto out_device_destroy;
> +	ret = percpu_counter_init(&sdev->iodone_cnt, 0, GFP_KERNEL);
> +	if (ret) {
> +		percpu_counter_destroy(&sdev->iorequest_cnt);
> +		goto out_device_destroy;
> +	}

it could be neater to have:
	if (percpu_counter_init(&sdev->iorequest_cnt, 0, GFP_KERNEL) ||
	    percpu_counter_init(&sdev->iodone_cnt, 0, GFP_KERNEL)) {
		err = some err;
		goto out_device_destroy;
	}	

> +
>   	if (scsi_device_is_pseudo_dev(sdev))
>   		return sdev;
>   
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfc3559e7e04..1f5b2dc156a8 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -516,6 +516,10 @@ static void scsi_device_dev_release(struct device *dev)
>   	if (vpd_pgb7)
>   		kfree_rcu(vpd_pgb7, rcu);
>   	kfree(sdev->inquiry);
> +	if (percpu_counter_initialized(&sdev->iodone_cnt))
> +		percpu_counter_destroy(&sdev->iodone_cnt);
> +	if (percpu_counter_initialized(&sdev->iorequest_cnt))
> +		percpu_counter_destroy(&sdev->iorequest_cnt);

Maybe I am wrong, but doesn't percpu_counter_destroy() handle the case 
of the percpu counter not being initialized? In other words, do we need 
the percpu_counter_initialized() checks?

>   	kfree(sdev);
>   
>   	if (parent)
> @@ -936,11 +940,26 @@ static ssize_t
>   show_iostat_counterbits(struct device *dev, struct device_attribute *attr,
>   			char *buf)
>   {
> -	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
> +	/*
> +	 * iorequest_cnt and iodone_cnt are per-CPU sums (s64); ioerr_cnt and
> +	 * iotmo_cnt remain atomic_t.  Report the widest counter for tools.
> +	 */
> +	return snprintf(buf, 20, "%zu\n", sizeof(s64) * 8);
>   }
>   
>   static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, NULL);
>   
> +#define show_sdev_iostat_percpu(field)					\
> +static ssize_t								\
> +show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
> +		    char *buf)						\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +	unsigned long long count = percpu_counter_sum(&sdev->field);	\
> +	return snprintf(buf, 20, "0x%llx\n", count);			\
> +}									\
> +static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
> +
>   #define show_sdev_iostat(field)						\
>   static ssize_t								\
>   show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
> @@ -950,10 +969,10 @@ show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
>   	unsigned long long count = atomic_read(&sdev->field);		\
>   	return snprintf(buf, 20, "0x%llx\n", count);			\
>   }									\
> -static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
> +static DEVICE_ATTR(field, 0444, show_iostat_##field, NULL)
>   
> -show_sdev_iostat(iorequest_cnt);
> -show_sdev_iostat(iodone_cnt);
> +show_sdev_iostat_percpu(iorequest_cnt);
> +show_sdev_iostat_percpu(iodone_cnt);
>   show_sdev_iostat(ioerr_cnt);
>   show_sdev_iostat(iotmo_cnt);
>   
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 9c2a7bbe5891..ad80b500ced9 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -8,6 +8,7 @@
>   #include <linux/blk-mq.h>
>   #include <scsi/scsi.h>
>   #include <linux/atomic.h>
> +#include <linux/percpu_counter.h>
>   #include <linux/sbitmap.h>
>   
>   struct bsg_device;
> @@ -271,8 +272,8 @@ struct scsi_device {
>   	unsigned int max_device_blocked; /* what device_blocked counts down from  */
>   #define SCSI_DEFAULT_DEVICE_BLOCKED	3
>   
> -	atomic_t iorequest_cnt;
> -	atomic_t iodone_cnt;
> +	struct percpu_counter iorequest_cnt;
> +	struct percpu_counter iodone_cnt;
>   	atomic_t ioerr_cnt;
>   	atomic_t iotmo_cnt;
>   

Would it be simpler to make ioerr_cnt and iotmo_cnt also as 
percpu_counter? We could then drop some sysfs code for handling atomic_t 
counter.

I noticed that there is a percpu_counter_init_many() - maybe we could 
use that, and index into the array of counters. Note that I am not 
fimilar with that API, so it may not be a good idea.
