Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE45E2E5B1B;
	Thu, 23 Jul 2026 10:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803906; cv=fail; b=HU1k8okSwjUgyh0o15I7uYthqgwjmqVl/7dmcQruQ132dKggbAumFZNCAw5Z0f1qMgnQGFj+LIUYi1kgk85vjm1A3H3oMSdBdhP9dIPYbQiZGz0n3eyctyY8QcB5PbFYEXQKzwQE1gNSdIHI0/cl+tILJXeezWK/OiEocyc2e+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803906; c=relaxed/simple;
	bh=2wpVAHBGWq01VElt559hkUPzoGKlJJtGkTZq9q8Nip4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y/xo4AEgxaIMfhxo5crR+hATK87rAqQ2JhPIPLWLBRU7FJcQGEl/YMZ2e8USaBqNd9Xp56mBDp7hRD2kUiOBaLE/SvN2vG6Ap696p5DhIMNgaEo4B1YLzle/BJVyP5Ey3pxaCyq0uIckUOcngQCeKeIAGAoFDJsV5RoWkcouatc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pbNTF+YM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=obwef1cK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pbNTF+YM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="obwef1cK"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtjMd3404252;
	Thu, 23 Jul 2026 10:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=77vBYEKCqEileFBTf5A7u/9esz1oHkTwamivxgpMscs=; b=
	pbNTF+YM+nfoqVkuL0ggFAu0eSpA2xQvrmWRlF+KLB3BXnMR/j29UEYnFzjSqYB8
	Efgcmm0bWWHFBRjPOc0iE4PvpWoyc88oRON846porqbAzRzgENd07nga05Mwgume
	pPQm8pe6QAQHkKi2rlLTOVqzwETag2skIaUPbbPBh4/7mw+czzdF69ahrX2g9YPf
	gMmKFqLuEI8u31EZROsDzoz82f6lUVXVuThoNxWeAgKX/wmhxcKHe2gR1scOttOg
	upNysTTtM5AMWQanA6aLO8p/dE9C0muQR418rY+2LB8Q5OvcSYzGfT4r8Fp0gJxa
	JDEzNWTstGNeL6ciptxTTg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3pq5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:51:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAmBn7038629;
	Thu, 23 Jul 2026 10:51:42 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013023.outbound.protection.outlook.com [40.93.201.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxeq0hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:51:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMuiFe9XwcFQDHiLiWc2TDmhTA/wVQakqU7oAX78XvHwrHnlLJWMo9A+ZI1yheaL9a/XUjxQzqSmpX6cP706EOgLhiMRrLw00AKC3zptP1RaKNWCxKQC9sZJgmLKaOlpgFLiJgDC4MAzfqmpmx9jyM5HbdMXo5c3jrCFxVMBg9t4F0hlBxDtKJN37/fECyfe3XhEvVZRpk5iDAsygcF5WCTQACQg6FPyHNtah9ZfS6zwj0NB0fjJLqQm/OSpdUoipzkR/k+BnAaUl/6pL7jyjGKcsFFo5MZOmHVTxUZFIwvA+hqvfjmE2192FA+rQSZ+zizX83P4vT/Jc8HWKLltZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77vBYEKCqEileFBTf5A7u/9esz1oHkTwamivxgpMscs=;
 b=ClEQl06yBPNcjgNQHT+SJemMILqBtUXXPLHg/+57iS+MGFmBgC5HakgwDwPHpMATy3BPIYB4PsMWovfSp4PlikJ35vdyiIGbvER9qloI7vl86CN6zNTYnpxo5bUa5emNCin9cmG1BrCretwA+uzW4M94P3LMLS3gCjPjikz47l9v/Ggc9X0V7zQqwfOtndH9s4Bc27EUAG6X9NP0lgs4B9lcaVDURh1A37rb2sO+WpGGMAQRPSgOlPlHp4yk8HCodC7ceKz/x9YNfy9RiiYmzgbOTUYhY6M2ab3B9nbl6vQIw+IDP7AyZf9K2uXCqqLVtVQbA+MIV/Lx7WwAGQB+zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77vBYEKCqEileFBTf5A7u/9esz1oHkTwamivxgpMscs=;
 b=obwef1cKLwv1XIpAqnQpj7j1MliQySTbUwJ4shdumKC0sGhS/C5Dd+2oJIDxKlyuRjDZB225bG3PLWTgCVAgZ8yvQBAdvMBS8ggBhwCeZqllHGsuOR2fWLihQXRyTp4quLpIgAScEJCLll02UQlaHHHaFeN35A5LsHU96qa/jbU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6034.namprd10.prod.outlook.com (2603:10b6:510:1fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:51:38 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:51:37 +0000
Message-ID: <ccf508f0-ac3d-47e6-a0d4-b7336578a664@oracle.com>
Date: Thu, 23 Jul 2026 11:51:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/28] scsi-multipath: support iopolicy
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-16-john.g.garry@oracle.com>
 <20260723102046.35B431F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723102046.35B431F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6034:EE_
X-MS-Office365-Filtering-Correlation-Id: 304af65c-11d1-4e86-511d-08dee8a85e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|22082099003|18002099003|6133799003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	i5cOGs4wqQQ9syoIihG34ETSUOEy6RUndjc7TzPsuySVyYRIVvXLMgg/g3hpL+YM+3EtRDKY0/bJJRGSlyq7G61QydJV8MjjB1sps/L5vWr+THHPPf/gTu3gWyTRnvCbwbCgkbi5zCJOtSdroxnXnNqberEBlf7NpcfAXqJnQKIIX93033wLzU881QP9EBL8clETJd8a7fe1sC0z3uGdrsHb8SWdIzTFu4nbVL2OE/DLIENglabilOFnsfZYbM+sd4HxZvY8pHaIzVHP3Xwfcz6byu5gVMDOeSt4mmam4aKC/7QAL8wUyx75m3tgaPCsHb7m03FlrQbx2TPb0LWyXd3VSl58iCERIzV8k+JVLYISUdnA1Al9QAlKoZ8SgkQBwfeJrsX2ZZ8IFYox3VVQ4kI7GuA7zwC8Usn0L98oz/kpPjT6tOtyoQDoLCmVdLkQXg6P1gllFAEC0VHorXiyzXGHG8UjbWJrpzX/CJ3wVhUFmrYw7umv9CrWTUbwIDgJoE5REvw9LAkaj8uRbHyLr+zpwuTE5hkyKVMg4qo3TsG1vGH1AOF2h+pb0DeD1nL6n/xaLqqCX2A6k3UVWV8iqwjlCde/qcwJnhkV57hXqFzrdmHZPorCZXK82fnwHp+3+FLgHZzmfYGlFokT0flV5PQoLkZmOHn8bwXtBSLHBYE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(6133799003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDZ0aVZJQkdnTWtYaEJta1VOVnplcnRJczNTNjcwVlNqR1hqT2loSmd1aERS?=
 =?utf-8?B?RE1JTVlBSjh5VnljR3RDd3VST1VMR2VhVzU4YUFCNFBwR3VjTGxuaXh3YTB0?=
 =?utf-8?B?VHRwQjljV1BTQmZQUXdIVHV4Q1NlNFpqZDRPY25JMGEyY3NmSlZqbG43bXFu?=
 =?utf-8?B?Q3g0RTZEdVVmdEJCSzdXcnJzUXd0QjFVcnExaDk5S2p3b2huOUU2VVBUVmtD?=
 =?utf-8?B?V3BWYW5TdzlwaDM4U0JIM0J2aHlGVjBTYk5idTJqZSsrNFROY0k0QUV4bGpo?=
 =?utf-8?B?bDgyTmpCc3NXeExMbzJWN3R5dElBZEdVcm5jVUl1aTBJNUszNFNpNW8rRmZj?=
 =?utf-8?B?L1lJZUpnRWFIQW1wamhIMGpjNzA1SkRBdlFjY2hIMTVOUDZpWHFKa0ZPZ3Iz?=
 =?utf-8?B?eEpjcFRZQUNMTGlyc05LUTF6U3Z5am9YRkQvM1VhaEQ4VzdMVWl2MEwvNnZN?=
 =?utf-8?B?RDdNVlpVU212Ty9sWEZYZUlrakFWR25hK3FVSW5DZHRieHdVdGlJRVJhZWl4?=
 =?utf-8?B?V1o2YTV4YW9zRm5FSEt2ak9tNTdiYXdIVFZDNHBPSGF5RkhOZ25KZ21oMkY5?=
 =?utf-8?B?d3ZlUmxiSjg3ak1IdGI5YVJDZW9xN3E5eXk4d3lvaXdtVlVtWXY2UXBwRGgw?=
 =?utf-8?B?MjNHNVpvZC9JUUk2emFzcUVQdUljeUprUnpKZnNibnZncnRSd2JIR0hDQWZJ?=
 =?utf-8?B?S0djbEU4YzZualpJYVVPQXF3SHA5V09qbGJEVzdzVWZ0aWRKMHduL3NhUEhn?=
 =?utf-8?B?OVVVWHZBZlI2NmNpdU5mQXJ2NUJOTmZMYTFQRC9xZ2I4VDA1VTBLTHVjOWxY?=
 =?utf-8?B?akUvckEzTEF5eUdPSEk3K0oyek03QlFRbEVzSjNJWVJYdzhDSlZOaWhIU0ZC?=
 =?utf-8?B?elZtaE9pWnNEMEtzcXd5WTJBbzR5bzBmSHJPa0dIM0g5TlZsUzcveUhLeDJS?=
 =?utf-8?B?WStzU09sSXlBN1lrR1BFUE1YeStWWk1SWmF0QWQ3TWdlU0F5b0F1dUczelpR?=
 =?utf-8?B?MjJHa3hYTWh0T2NtZnRWbExrbkRpNHlnVnVmYnc4RWJTcC9MMVpNbGloRVZm?=
 =?utf-8?B?dWpUZUw3TWxtYU1kbC9sSWRvRWVBQit0WGZ2cDM0RzZyMTg0T1BvbUU0WTN6?=
 =?utf-8?B?VGwydG44TEZnNnluTU5YZUhxMnM4MGRkYllNamE2SmRhMnY2cmg2bHFQRTRG?=
 =?utf-8?B?NVo2TWVmRm8wekVVcmkrRnpJRUw3Rjdna0lBUHluVThtWklKLzJjSzI2VFQ1?=
 =?utf-8?B?aFFMNitzNDBwOVdpb29uWXN4MXFSWm9lYzFMZDR1VDdnazhSTDR0Z2phMnY2?=
 =?utf-8?B?MWVZVlU5ck1zM1Q0b1QxeFY2R0s5NittZUZOZmh2RFNqY2RVKzFoaGpXQ0R0?=
 =?utf-8?B?L2ZWWWgvRHp4eXRMdk8wdFMrVUZTaFdvSHJpZEc4MDg5TEtsWEY0RlJPR0FG?=
 =?utf-8?B?YzFrQWFSWC9CS2h4YnhIU09ydkhLOUIyRTRIaDcvQ0lvQ1hvVlZZZUphVFZj?=
 =?utf-8?B?NEVPcDN1Wm5uUnlYUzhTZ2o1WlhOMWoxWFFTaS8vTDZ4QTVUeU1PSFpyRjc3?=
 =?utf-8?B?Mk9UVC9qd09XditNc0dKOWFzWlN4SEdDUGhOS2dteEdBT1FabmVOQ3JUZHlR?=
 =?utf-8?B?S1dXQzBkQUFDQmVjV3lmTU1nOFhMNU1KMW1icW9xVm4rTTZJeWZOQUdib2pm?=
 =?utf-8?B?azRCVlhiK1NTWDdlNDZBQ1ZSU3dYeGM3MWdGV3BnVHEvZjFKWmNpMWF3Q3l0?=
 =?utf-8?B?TFdqSVRwSXhVZGdublpDVnh1ZU1STGMzYUlRZldxNmdPd0IrL3lueXgwcUZh?=
 =?utf-8?B?N1V5ZHIwd1JZaWJ3eFluaU5xSmxMc3ViWk9INGV5M2VNeGEzd0RXWjJNQ1o1?=
 =?utf-8?B?THlwTUs2aUhJRzRiRjZ5S05oVUFWWWlPTkVyMEw4Wi9ZdnNLN2p6eE80Q0lt?=
 =?utf-8?B?eDNzV1ZlWmI3UXdEK1A1L3QxbTNPSlRQbzd0amZVY1ZVT2FZWHNDV1dxVCsy?=
 =?utf-8?B?ajMzUEpCS3NSZkFnNlNYbnlZd3pwakxSWlVtTGNFRW9SbG9DS2pDeE9QMXVs?=
 =?utf-8?B?QTlUVmlGckFsWk5QNXhMZGhnOFhqSy82TjBOS3FpV0UyclB1UldPaEhNRFYx?=
 =?utf-8?B?ZlhSc0kyTXRrM29GanlXM2xDRlhqT0l6Z1kyZEFYVnI0RFUwa2hIM2I0Yk9T?=
 =?utf-8?B?NlFpa2Fxa3BraFlMS2JIVGtUbWlqeE05Q254d25qU1pnUDhrOVpoQjZjdUpT?=
 =?utf-8?B?bkI1WTF4eHh5Nk02ZDdNbHNUYWZRMEZraFBDUDlwTGdkWG44RE5MM0Y0OG9C?=
 =?utf-8?B?bHgyQVZUL09vVmtyRXlwYzhiRlJQbWdoT2dRQkE5TDJqOVRSZXlmT281aTRV?=
 =?utf-8?Q?30Ic593DbPL6rKn0=3D?=
X-Exchange-RoutingPolicyChecked:
	TLnpQhOmbPrE/uiDOW3oVN+JU4kqEsASgLRlrJWsTwIp+RLAghOCmUXFXjr3Cs9EBP8v8bUpUgadUbZJ1dXbpu5fuAKEPWnPDB4/+xpYhtHqnIvblUZLgjgUdypd/d9Rzkop2kQBmt65q/AH2Q5xylWsKKscKXqMo5fg3FG0oon8SB1XLZ81vHZeTTCoxPfwYql3h7xCg0kqxqebXp58gb57I8pKHs6cWaCCHcfiHoXOx1LR3dLUw7IZCRJMuDfZG8hHdnGeFUbBxCn8sisq+jfjY+ZuHKR7b+pjmTB8Uz1dfHrefSMfu7Q7HbStyDWCe7cV9Ft1b5fQZN9dzn4EEQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9nPyi+SY8MlLq42A6TMGMulIjdVsf5/NH6xaq+Ve7ZkxaLgVwecyei6lQO1z1qtET+fSU0Xz3kd+OBeC3Lty3EeoA+H91qMbUqjiGfnWzsZKD/hTxLTvKyxnU0rDHXKnX8jCf63FT9ckV9FnILC6iKjutez+5TlVEGAhw8HAHY4KX/5z57gX0TLKXp/GzmxJjZ9C0pKtBnhkFF0QhLb2JLuIxCp8eNX3Iftnh6tZjxcYAB2MmpWsqdF4dRTv86l8G3ODE2FJ4GmM6s34RGzBQywS49+LaJRPfBxmBdusMrisoGDrwyhJUGmD7Eztz1dax964ZUkzZIfeT8Ek6vvftNRxB/mtQ6vxI7IX+jXfcntpJaGmE2n7I/GeI8f7tBS0rYFCz677TbJFLn21SrrYwo2QIvY5FDFAhYnzzds5H+2Fy1uLzgSgWL8dqBsQNmqkrd6HXwc6MKdlNOq1sVf9JIVGBU5H7n9sft8+gOoafJbhgiou9GOVlAI73lvnKBLfopdeRNKCaDo6AoEBJon/j131nxBZcrxmJQDaGNSBTrp9hKe6fwB20s9BnS/mD0I61caCuO2OO+g4XUAqx1PqiEgdp/i7WGhltq86QRYKizk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 304af65c-11d1-4e86-511d-08dee8a85e8b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:51:37.6431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H72TrKCZYSK6iESzY7Ezj3PwmDJ5TwTBu9opRT2EoPVJaeFq3KN4t1GJ4DLSaS5cpuSVm2I8FUJPZrg6VJuAlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230106
X-Proofpoint-GUID: 3Vf13naAeGHfEKhpGJu3zXpWVI341fdT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNiBTYWx0ZWRfX/5L6Q8rmwkTQ
 SVtxmrgjgFada7UUsYd+BKJdkBnjMpn7nWMunHz0K+dOTGG73Bgqs7XTyng5LLB22RnWkOAbYjK
 OV9f7yEN1XQTXCSps3mSG8eQgTYyiXWim84tnHZsm6d6RflJrbrQ
X-Proofpoint-ORIG-GUID: 3Vf13naAeGHfEKhpGJu3zXpWVI341fdT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNiBTYWx0ZWRfXyts5/BAIbqc7
 1yCPfCwYRry7tp3Cqzv7J4VWTgC6sBwEArFfcn6hCfs9BqTiLFAfi2KqwKSrS6k0wFUaDPWRSYU
 5bKa4525rqnyKOvaY6lov9lRI+S6i4w6nLjZObwr9h7/IgWgSfTUyUGsh+KHQi40Ynk4M2Lax6g
 lQAgKQ0CXoSOXj6g+r6YwWWNWr2eratQ6hivHhRfYdSVMq84vaNW3uP1jc60n1UU3SM7djDeyzI
 uVhuq/dsAJcQqPuTW6v/cVIxR8Yr/4FBP/Tz/o8X8yGHNeEfeBeFzN37z9fOCIOh6UDD+epL/bB
 E2KWwxUnb2V4hRwH/m/FRONKey/iLJChgC0yCbhrLuMfY6B/dhSEiPYiNzGgxkZUKNFLxufi48t
 Hlf0A/+VJb3deFOFrWVG0sqa6Jw61SORClZwcWzosnK2SF69eKfP/7XSAqU77tmHsbA0+CJnoA8
 Is3OgBhfKHuRliQyAvw==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61f23f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=IABs3rU6r0ek2d4Lwx4A:9 a=QEXdDO2ut3YA:10

On 23/07/2026 11:20, sashiko-bot@kernel.org wrote:
>> +static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		container_of(dev, struct scsi_mpath_head, dev);
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
>> +		return -EINVAL;
>> +
>> +	mpath_clear_paths(mpath_head);
>> +	mpath_schedule_requeue_work(mpath_head);
> [Severity: High]
> Can mpath_schedule_requeue_work() trigger a use-after-free during device
> teardown?
> 
> If a sysfs write occurs concurrently with device removal, the asynchronous
> requeue work is scheduled here. The teardown path in scsi_mpath_head_release()
> frees the scsi_mpath_head structure without calling cancel_work_sync() to
> cancel this pending work.
> 
> Could the workqueue access freed memory when it executes the queued function?

we flush the queue when removing the disk, so should not be an issue
