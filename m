Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB3820DD51;
	Wed, 26 Nov 2025 11:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764158031; cv=fail; b=ixgcSCyEoRhmnkWqQ7SItYbdkpajt1NLhDkcm2T0zyI7L1p9/sBIWgls2HyWA4rWst4ID/CHyUUOJcnpt2Z3DNhYBJMSF4X5OlsJiH1Hp72OZTr588/oie8+UglZl0ySuxztgPLZgZURlFb16e/+wTbJjJuFh63gjBJ6mi7x+tE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764158031; c=relaxed/simple;
	bh=liR4wf2WI3/mZcYpEWifdlVVDzTxCOYDNtbsB2kkumA=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CN2g5pXUjUl7nTRKJDKMxKxj13JPIZT1qryMQhKB3S8j8b/8JYveBqqZ12BYorJuSzKk0f9wjpKztff5khtTXkgwAEaOEILIIS0T0mjcmWNXSrz99n8o5uTQhR477cCowC0lFevz9yfPFXg/9pkM8ZLCPlcigaZnGfvdh/ZcaAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EuzXP60w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BpllDs9b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EuzXP60w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BpllDs9b"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQAn5JH1543643;
	Wed, 26 Nov 2025 11:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lokCd72I0FmSs1QufzPP5Z1wbA4gU0ACFQrbQ7TFRaE=; b=
	EuzXP60wjXu/kkfmZoNB+4cY7BmiBv/SbLDnB3uRWihJbXcfRK08A0wyxOPCUFqa
	5oYc690mP7iuHxHUCJlmoybLb2h13xhuNvjYCZwhZsCsxY2Va0fyhbXOYvc0cWHO
	SuyGcxcN+gCtbSAzcPClbwlKmKGZsj+1mB6ORz6z4amrhTUsQGnB3OukPxgW36Dk
	gVtDgDBLdrjdbTr3+diKLktamkSGndAz6Y9eF8s07NDDkhgbynD/+6gfO7d+FDnU
	tlQqgQw9XiAr1lp1XFbdz4fSph7ApTUtxogyd07k3PA6OReZPnoyUVq7Ktl/ukiA
	UnsL0dytXVXKTlPf/bn/Fg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8ddkrq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 11:53:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQBoHox029768;
	Wed, 26 Nov 2025 11:53:46 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3meduwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 11:53:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8VqhmtysFL1DPBxjIXyWRtjmyUOLYH+n4vVPGjnl83Ze8Y8XlyC2Q5u1fo4FewL6RCNWBEw4Zcg3hV0L3UgI9oXVLWuoNT/tAB/7GQlCeXya0bY1xSsKg6EniNSxcXijK+9yzqohs4wx9MZrjzVZoUDSMZvhWf2J8ULS9hfKhSbvj3OiUKB8zsMWoikcFIw7c8b4AgXPO3TwrHXYJJR20zStT7ahXA7HZ7oK+FNtAZjKpWcaCUZf1FfdvydvXq9ZTo7Xa8Xr8o9Kapyl3CXjSXbwYhFz9Jg6ycN4rIjlHdw7y3hu8JhmZq1LNRzXTJ6EYe8QKxN/b1HkFDbDkXvww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lokCd72I0FmSs1QufzPP5Z1wbA4gU0ACFQrbQ7TFRaE=;
 b=hPbfEaBKmngeX2YnKOrrXY3XIBuVff/FKnpLC08sgebaSr1alcbn5IgzwBLWm7lH/HOlsuIYEBJQ9aGvuI3hS12fntZpZ0Hvjv7NwO0MsZzgP0hUCbkCUPcHUfejHcfgXRGfBy2EVKZhMA3Ld/BVwFwrqQiMIYo+/NMeDQOMJS6913Kz/jA2GRmAqDUrw9oaUBWG8R43zBoKz2CocXkh6j8cXIhXUItEVor15CdMaGK9/A/E0FC+VeAHOKO3GR8GFAbwQyxOCl/ZOHEpKarFYwdQmQzUyr0clJjN/2Xps4c3ar8QSXWyMJb92hZNei3hhxMYQ15y2MPDH0eal/Lxzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lokCd72I0FmSs1QufzPP5Z1wbA4gU0ACFQrbQ7TFRaE=;
 b=BpllDs9bmU2MY97U8BU66ogjOUy1by1mcMcVKuN9PyecFH/O6uQzvf+oXEfqle8wcvf76guZj4PFe/ZKPLm8k7D+Or4UOX/WfqgwH2vVMaFjaW4OtRtSatdAeFn8KUoNj/0VZXuKOtcE8WBh83QL0z2QG7ngYt/QoMGuVijw9DI=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SJ5PPF15BB740B9.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 11:53:44 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%6]) with mapi id 15.20.9366.012; Wed, 26 Nov 2025
 11:53:44 +0000
Message-ID: <f668df37-8291-4cf2-bfda-62324b94da13@oracle.com>
Date: Wed, 26 Nov 2025 11:53:31 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
To: Gulam Mohamed <gulam.mohamed@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20251026191309.34968-1-gulam.mohamed@oracle.com>
 <b3c28b7f-503d-4e83-b4c2-b756150bfbd9@oracle.com>
 <IA1PR10MB7240FA764470DDBC324840E898D7A@IA1PR10MB7240.namprd10.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <IA1PR10MB7240FA764470DDBC324840E898D7A@IA1PR10MB7240.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0229.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::7) To BY5PR10MB4307.namprd10.prod.outlook.com
 (2603:10b6:a03:212::18)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|SJ5PPF15BB740B9:EE_
X-MS-Office365-Filtering-Correlation-Id: c863d765-56e7-469a-4b75-08de2ce271cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEpCNlhpMnpNSUFMU0pKQU1GS1V0NHVmdzFoOXZ5Z2h3WXJSUlF0eFM3SjlM?=
 =?utf-8?B?ZGVWc2R2L1RVc2NFRnhSaEVldXBqQVJTSnFOVE9mWHlzbmN4UGJmTDNmZXNU?=
 =?utf-8?B?cTFsMjNTWUhSVURYc3hBZStkeWtnTW00Z2NETVcwMWhSc091NDFEODZBZ0Nq?=
 =?utf-8?B?dW9KVzhJN0JNdGVlVjhDbm9uZ1VJN1FBYjlzVVhwRkROWHdhd1ZUbDRkRDI2?=
 =?utf-8?B?ZS8yV29rcDFtRlBhMHRaNVZ6VG1iUEFsSkxVOE45V0M2MFpCM3FjMHJqalZP?=
 =?utf-8?B?b2UwNXZXTGcyS1pMR0RQL3pLWnphbFlZK01pKytPbHhYZ1F2MmYwakRNUlZa?=
 =?utf-8?B?VXpqU1h5dzBJbUsvZXFQREJSMll5N3habTVDMlFaNGFsSERzekh5Wk5aMjEz?=
 =?utf-8?B?bDd0ajNLZ3hYaDdiLzlEM2s2VkhwS3VSWW5lUEp0WkpTRlZiVmVScXQvK1Zt?=
 =?utf-8?B?dE5oVkZaMmJvejl1QmxyYiszMWVnR2JHVm8wZFJVNjBscFFqei9IUXVVSE84?=
 =?utf-8?B?NFZHQURyM0JDWE02RmRoVllBYjI2cFJlUENoRWIxZ0Y0cHptVEJUK09TVTN0?=
 =?utf-8?B?OUF1dGZteXNvVmRBcWdQSWs4c0I3Q3EySG8yeEM5ZjlZWE1jSUpxR1pISUxP?=
 =?utf-8?B?eVo1N0tMbWZWUnlxaHFYajcvNDQ3YkFmQVM1UmQrUUtIajV6aXlvbXhNcVZx?=
 =?utf-8?B?SHYwZkpFL1RKQWc4NnNVeXN5YnVVMHhyOFBybk5uNUNMbWZQbXpmQ0k3REpZ?=
 =?utf-8?B?RHhCTGJPdFBNcDFVNlBNWkNQajBpdEhKZDQrbFJDS29oVURxdlh2bFZLa1NP?=
 =?utf-8?B?RUw4SjBqWWMwRDFqNzhvcUhnaCtIWnBpT0NmUk94QVVJVzZGbmovdWp1OVhh?=
 =?utf-8?B?T1Q3OG5hVDVvZU94V2ZucW9kd3Y2ajBtSnA5ejVzTUtNWFFvdEJHSmFzYkxV?=
 =?utf-8?B?OWp0aUFQM01XcG9PeE5ZTlJGeHhpN3psZ0F6ckJyMGU2eUVTZitJL2k0U2dh?=
 =?utf-8?B?eTNWWGVyc0k5dTVyODNRMTY0R0N3RTI4NG1lYW1nOWlOc0s5WW5sU2k4UWJQ?=
 =?utf-8?B?MVQxYThFc21kK1VJK1V0WEhrRk1yVFVIMnZ2TFZUQUR1aUJUTlVQdCs4dGVq?=
 =?utf-8?B?NlBSK0JTMkhudkFCR2lIVDA1R1pYU1NxeXhack1WaVhxM0pYSkxXTUFBOS9P?=
 =?utf-8?B?UmNPaTZCenBkT0E4TVRJVE4zbkJpQ0FqK1VjazRwZkdSZWZYMWxzN3NWZlIw?=
 =?utf-8?B?dmppWmtIUndpclBKWlVlVXJPdHdLRzR6dW5nSkhBcWxnKzJOY2R1NGMyQVh5?=
 =?utf-8?B?eHdvYWhwWi9sdE9xQyt3UlByWmRZakY1ZjRmVnl5Y0dKTGk4UHFJRFVCYSth?=
 =?utf-8?B?bHMwRDQyM3h3UU5tNGg3SUVuMFdzNi93Tit2VW5MWUExcEt6b1UwbXdVU3M4?=
 =?utf-8?B?MlNaVkk2MFJSdERuczJSaFJqL0lWK0dPYXhqdGM4VHlRQkJ3c3BrMkllZm1u?=
 =?utf-8?B?YUtuVVo4ZEZVMWptTjBvcjJpYndLV1RnRUMvb0xadVZYSm5oL3dlWFRHV0RV?=
 =?utf-8?B?SHBxTFo1SFExekhkeGdEbEN3d1NmeG85d1V4TS8xbTlhZXBjYUltSnJkb1l4?=
 =?utf-8?B?MjJJeGRsR2xuSHFpSHpMQjJCZ3pVWnpmRlZ0eEIzM0VYR211MTBnaEU2YitI?=
 =?utf-8?B?Tno4MUlQdFIzR2EwZi83MEVKa0tzZTQ2dW1TUGJ0LzFjYkV0QWV1RUNUU3Uz?=
 =?utf-8?B?Z2MySHlXaHZSTXFuN0dSc2VlU0F2NEVuV095RmdJNUdWNkd5ODdRYTVEZUhT?=
 =?utf-8?B?clIzSml3cGdLcndsdU9GZ05laVFKTGIwb0JicVQ2WlhocEFTQ2V5WGlrYngv?=
 =?utf-8?B?YVdDcmM2ZWN6QXRBQTJpSzFBUHJ5bGtXSGpRd2theGVLOEF2ZlBGRGJ4WjlS?=
 =?utf-8?Q?Y+0zXTIGfj6gHgByxmjgJvFuTDFUIxFQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWRYeE5pTWpFREtaSTNuMzVoQXJDL1EvcDFoUnBPR0ZyTUhwejRJbU82enRH?=
 =?utf-8?B?RklhMjdaaHdza3ZvUFpkUDZ3R1piUGlLMmw5b1g0NmJhMENXWVNNb3V1enpw?=
 =?utf-8?B?S2tYZkJOTEgzWFJzRzBKZmV5UlpNY00xVWU4SjE3TWhic2lEQ2RoY3k2d29p?=
 =?utf-8?B?cEEvdm9ydTBwdlFFTG04UzBPWS9Hb09lbFRROGw4T1VXNkRZWjJTdEpsUVoy?=
 =?utf-8?B?VDlTc3BhTjFjdVBGN2RLNE9JaHFQU201OXVPRTY3ZnpSaTJmNTRreUhsTFYy?=
 =?utf-8?B?NWhlQWtJcXlVNlVWaGVZNE5RNlNaR3hXem4wT3RLekxLMUtjRHY3MjlaRmNV?=
 =?utf-8?B?V0NuQ3dMS1hWd3hraFJucStZM1RIZkdlYWtaUVZIMzBBc1JQbjNvMHR2QzRF?=
 =?utf-8?B?WWtwSlZOVlVkYUdrb21QT3Z3SWtPT3BmM1h6bkRYRFBNZVpsbDhzd3lTc3dE?=
 =?utf-8?B?OE1GWkJCN2NoMzJrSzlZWCtmSXE2S3B5bktvRFJJeG11Z2JNb2NtSnl1R2xO?=
 =?utf-8?B?MjJpTEdzRnJJdmZ2WmpsbjlnVlFaNkpaRWVGR2xpZXVRUlBSTk1uNFVEM0ZL?=
 =?utf-8?B?VVRzRk9pcnkxQ1VCVWxhOE9yaFVVaUZFankrNjlGUy9aZC9zOXlSR2c3NHJE?=
 =?utf-8?B?OE82RFBhSk5WNDJ2SVppc2ljT0RneDNRenRWUFdFZ1lGSEl0eDJRNXBzNnZx?=
 =?utf-8?B?cTR6TDNBcnBjb1ZzMWNzNVB4RkpPc0c4ZUdBUUt6WTd4MnNjeThVMXYzK2N6?=
 =?utf-8?B?UVNJcDVoQytYalBWR09ueHMxOG5KcGUydnhkUnB5V0wrWmUzWERaV2FYRmYw?=
 =?utf-8?B?RExFYitKL3IxUThrWEU5THhpaWw3Y2dnbnRLcHVsODY3TzdVajBlSFMvcG9G?=
 =?utf-8?B?UHJKeHpDODZBQ2hYWFF2YVd2bDl5MFBaeUluU3AxV1ZCSXJRUHpBY3h6WHlK?=
 =?utf-8?B?RWpqTE5UdzRHN3pZc2FUK1lBWnZMenlXUHFBZFhXUDVpZ0gvczFBUE9iZXJ2?=
 =?utf-8?B?dXZneDVJWGRJb3VUMjgxZGx2U1JoYkdpeWNrL2k5LzhwNjlpa2JkS01DR212?=
 =?utf-8?B?Z0ZlMmxEeFdYTi90RHRMaXlQYXZvanBVVU8vUThKMUxQdHl0dUh1VU1idWhk?=
 =?utf-8?B?VCtHQUtwd1ZBcUQzcVVrYnpvY05QNThqOXdCSy8rYThRbEIzaFQ5eUlEMGdW?=
 =?utf-8?B?b2ZiWFkyaW9sZ2twcWFpb3NuaUJ2Q1lQa280Q3ZhbmhpRkpWKzNxcUkxNUp6?=
 =?utf-8?B?bmRSbHJKR000dk9zN2lTT1paQVRtN3ZFWjlvRGUyTFVvY0U5QWFuenlCZ3ZF?=
 =?utf-8?B?YzN5RS9mWVFvOEVEaUZTLzc3Q1FVc2hoMXRZaHozUTR5a0orSm8xYjlGMGZL?=
 =?utf-8?B?UGw1MGMyd3F1UVZxWlFkSVJ1VUN3R3ZPMHF4UDVha09USm8wbXdNMGZVNFN2?=
 =?utf-8?B?TUZBYTF2VmVabTE4cTVSTkY4VThxU3NIZjE0Z3FQbVBkOFZ6bWpvOTZBU0xr?=
 =?utf-8?B?UmVVRU5KWjdTemtib3lqRldobWxrM1FtbEEyd0NNUDhNaG82SVl4ZFJ1LzQ4?=
 =?utf-8?B?dG9OOHhtcitYUkVBZlFYSVQ0VDdLR0tVNC81R1IyRjFjczUyb2pnQkp1em5J?=
 =?utf-8?B?blNVUm5BS2FIVWxwQ2JnM1pjTFYyd0pORVA4M2t5WHNER2oySnhuTk5sRVk0?=
 =?utf-8?B?NDdPOUFLVEM2b2NncTU0NVNlSVFGVmZqSlIreTd1TnpoRlpHVlVSaDhSMnF6?=
 =?utf-8?B?UlJ2Ym8wWGZncHN2bm14cWpHdG1yZGcrM25IWlFTZUpLVm9zMG5neTNpWXdY?=
 =?utf-8?B?VXJrcWNzZVlxMjk0K3dXNW1GSXJqc0lVcGo4K2EvVW5vU3ZsdnNQT2xqbTVk?=
 =?utf-8?B?MEhVblFENi9pZGxudkhhcUZBSlJyUGJkaVpiR0krbWJjN3drY0Q1NU1SSHdG?=
 =?utf-8?B?NzVlc3FQQjlhQUJ5VDJaR0lCMDQ5eDhoYWpRTXZ5QkJIVGxFQzl2dlRkN20r?=
 =?utf-8?B?UzlxZ2pNSnVQanROOGdxM1dxNFhvUXNCUkcrQVF1THk5c0RMT2tmV2ZEMGtZ?=
 =?utf-8?B?N3NFWnF2TXl5c3k5T2toUEt2bm56bE15aXZtVjhRMDVJbzBIMk9aRy8wd1BZ?=
 =?utf-8?B?VTZqMnV6dXM4VmZOSmNFTUN3MXpVOHRTcWdpWHpCSWc3OFhFUzB1NWNHNUVw?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bu8FeuSj5tIpZc0aiSFJxCabxX4DQB69mxywKi7R09OlOHSbpNAxQjvnnRkwardd6QUDdoig8n3RmyVnzn8qlb2NCyaLnq5uqkLew0OiWsCSTq3ecE4XbK5hhaV35gBBZZObNE0lPIJnI7hrb0ZCrJZ2uRDoQc9GIp05eQkmXbjj9CQfmYai2TGyOh4KnwJOkHPByOt2gZ9wd/JJfD7ebqTCPhaypJFmPKfFuyb0XBl2e+Gq4BxUci89kfRS3ehoM9femhF3x99UWJnxNUUxWwGj6fFqkQB0HeyzhIOjMBIC2AQUn9ozpja2E543KlmA96HLNZPMtVjZyP+7/IlDLdRdMcex/8fdybm7bEGMKjt4AtUPyBc2jp6dQq/+MPTUgEkynwLYbYlGErxYW9n0JpOuPw8qWfPuJ+bPaPWGrBBpVSc9aaFRpqE3JfxF5QRZFZHPojiPTo15y+BqUtUoeNE3mVy88FzOScyr6zexipUts9mzU6gTt4R3cS6l+fhnX6v+MtOp5rcAeJ5+z0oG4TctZsC7yp5t9bTxyPoxeopiSCw7lU2KJR4t1ukWdiD5beHwlLKc/5pnw8WREfT15DT7IrOjidSDkTM8VIlVu38=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c863d765-56e7-469a-4b75-08de2ce271cb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4307.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 11:53:44.0560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hjXFO7+IXxcID7l7WqcEbLdWQcEoGE4+tw/q1UJUU/JFWmxWpzawo6rn1RZx3eOlWNMordtQgqsKkPKbcR2c8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF15BB740B9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260097
X-Proofpoint-GUID: RkfEEACy1X8m6w0A8FBNGoptN990u8qg
X-Authority-Analysis: v=2.4 cv=ObqVzxTY c=1 sm=1 tr=0 ts=6926ea4b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=WLNyrPGDYzRC8T1XXloA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDA5NyBTYWx0ZWRfX2wRp2wRvc/5L
 CXDl5IOZWgc6r1bMLWOpneADLK2iUoZeIi7RHyPMFk2eliASwN/VOrIAMKkaAymN0lWqvhOhilr
 YXlhUnZeGL3Yp5ksje5/m7oAWEP1rZeNrlRxHgz+rrZXAH74wzCBn7rIvoiWe6GTBWhLBo3VUdg
 dEZFZfxIvFGQqhnGs3xdJz9CTCR5jiCm2zkIkIsZezdhrppJobYcuv9bZrFChxY4QjHCXl3MFs3
 AERGstRF3ncBxks0upgiTs9MdWN2qIDA2bhS0doBbttf9u+qj4tB0gdP/qfUw3Ummo7PLUmDJi6
 eBmbaJBZzL5d0leg2JBQ0FLDYp8kUv0Yk9HUA42dVK1uFn3y8lMupNa8RfUUHcdZxihK/S7e7js
 cYNHhna3kSi44htql5JA6Y7bMGWqzpakfFC7oAxSMTaMc4Dioco=
X-Proofpoint-ORIG-GUID: RkfEEACy1X8m6w0A8FBNGoptN990u8qg


>>> +
>>> +   len = strscpy(buf, page, sizeof(buf));
>>> +   if (len > 0) {
>>
>> Can you just return early if len is too short?
> You mean to return before we check "if (len > 0)"?

I'm not sure. It's just that the checks seem odd to me. Firstly could 
you do a E2BIG check after strscpy (by checking len < 0)?

I think that logically the following is the same, but it is slightly 
neater. Please check it.

	if (strscpy(buf, page, sizeof(buf) < 0)
		return -EOVERFLOW;
	stripped = strstrip(buf);
	if (strlen(stripped) >= PD_TEXT_ID_INFO_LEN)
		return -EOVERFLOW;

> 
>>
>>> +           /* Strip any newline added from userspace. */
>>> +           stripped = strstrip(buf);
>>> +           len = strlen(stripped);
>>> +   }
>>> +
>>> +   if (len < 0 || len >= PD_TEXT_ID_INFO_LEN) {
>>> +           pr_err("Emulated peripheral device text id info exceeds"
>>> +                   " PD_TEXT_ID_INFO_LEN: "
>> __stringify(PD_TEXT_ID_INFO_LEN)
>>> +                   "\n");
>>
>> I think that this can all be a single line.
>>
> Actually here I followed the existing code style. Mike also wanted to restrict the columns per line to be 80.
> Let me know if you want me to change this.

The 80 char limit does not apply to strings, but you are using 
__stringify (so a grey area). Please disregard my comment if you like.

>>> +           return -EOVERFLOW;
>>> +   }
>>> +
>>> +   /*
>>> +    * Check to see if any active exports exist.  If they do exist, fail
>>> +    * here as changing this information on the fly (underneath the
>>> +    * initiator side OS dependent multipath code) could cause negative
>>> +    * effects.
>>> +    */
>>> +   if (dev->export_count) {

...

>>> +static sense_reason_t
>>> +spc_fill_pd_text_id_info(struct se_cmd *cmd, u8 *cdb) {
>>> +   struct se_device *dev = cmd->se_dev;
>>> +   unsigned char *buf;
>>> +   unsigned char *rbuf;
>>> +   u32 header_len = 4;
>>> +   u32 actual_data_len;
>>> +   u32 buf_len;
>>> +   u16 id_len;
>>> +
>>> +   buf_len = get_unaligned_be32(&cdb[6]);
>>> +   if (buf_len < header_len)
>>> +           return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>
>> isn't there a limit of 512 bytes for code 10b?
> Earlier I kept this as 512 bytes as the userspace is sending the size as 512, but Mike pointed out the range mentioned in the specification.
> So, If we see the Table 61 (Table 61 — Identifying information types) of "spc4r37", it says 0-256 bytes for "Peripheral device text identifying information".
> Let me know your comments.

ok, I was checking Peripheral device identifying information.

>>
>>   > +> +       id_len = strlen(dev->t10_wwn.pd_text_id_info);
>>> +   if (id_len > 0)
>>> +           /* trailing null */
>>> +           id_len += 1;
>>> +
>>> +   actual_data_len = id_len + header_len;
>>> +
>>> +   if (actual_data_len < buf_len)
>>> +           buf_len = actual_data_len;
>>> +
>>> +   buf = kzalloc(buf_len, GFP_KERNEL);
>>> +   if (!buf) {
>>> +           pr_err("Unable to allocate response buffer for IDENTITY
>> INFO\n");
>>> +           return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>> +   }
>>> +
>>> +   scnprintf(&buf[header_len], buf_len - header_len, "%s",
>>> +            dev->t10_wwn.pd_text_id_info);
>>> +
>>> +   put_unaligned_be16(id_len, &buf[2]);
>>> +
>>> +   rbuf = transport_kmap_data_sg(cmd);
>>
>> is it really ok if this returns NULL?
> I think its ok to return NULL.  We just don't send any information. I kept it like this because I don't see any information defined by protocol when the memory mapping fails.

If this fails, then we don't supply the pd_text_id_info but we are 
setting the len in the put_unaligned_be16(id_len, &buf[2]) call, which 
seems improper.

> Mike, Can you please correct me if I am missing anything?
>>
>>> +   if (rbuf) {
>>> +           memcpy(rbuf, buf, buf_len);
>>> +           transport_kunmap_data_sg(cmd);
>>> +   }
>>> +   kfree(buf);
>>> +
>>> +   target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, buf_len);
>>> +   return TCM_NO_SENSE;
>>> +}
>>> +
>>> +static sense_reason_t
>>> +spc_emulate_report_id_info(struct se_cmd *cmd) {
>>> +   u8 *cdb = cmd->t_task_cdb;
>>> +   sense_reason_t rc;
>>> +
>>> +   switch ((cdb[10] >> 1)) {
>>> +   case 2:
>>> +           rc = spc_fill_pd_text_id_info(cmd, cdb);
>>> +           break;
>>> +   default:
>>> +           return TCM_UNSUPPORTED_SCSI_OPCODE;
>>> +   }
>>> +
>>> +   return rc;
>>
>> I don't know why default clause is required and not return result from
>> spc_fill_pd_text_id_info() directly?
> 
> Default case is to handle the incorrect information type. As of now we are using the 10b code but in future, we may need to handle others.

ok...
