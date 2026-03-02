Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148CB421F04;
	Mon,  2 Mar 2026 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467187; cv=fail; b=Hd1pRjnQ3QZGkP8th7EULYRxJil5/4nsnaQdOlKD1oysi6SLlrYYX2N7JmuJJBRwB2jVsfA525UY33OmbGtLsY/E6YTD490vAFMniUX22O+/SPD6TRvZ7RyMVqalKa9Ea3THXjmnZH22bE63ax7fsPR2DUPzFRQrC540+jtSLwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467187; c=relaxed/simple;
	bh=FpInnkTqydNzsuBoCMmltQ586H6zlxPzafyguWk/mXU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cL1HgTFWNXZrEHXweIELB6cAgTEMDexYGFJlqFDv7jSJtBuOZDeacSNJ7jQhNza+e2/XAQ87M4+2kFptiue3FMLPFCTe0e+AEjjss3EnSTwbr84gMniekm4ksPBLsLQ94RYGpz5CXhpJwALBPe09oB+CImpxlsSjT5fwVXhutUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E2+ZT6v7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IrOtjdB/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2+ZT6v7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IrOtjdB/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ENxhO1915915;
	Mon, 2 Mar 2026 15:59:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IvqawACacuC+OO9c2FgPaYhdTOjB3LjWrkmnUeGQs68=; b=
	E2+ZT6v7slOfqgwHTFV74O3M/Wk4Y7HTn7Bah7uDl3gUa3jxeAhKapNrR0A74Odo
	BrOJzvWN0XTeUQUrclkq5FeHuuoS3IVZDobWqpy9pdO9OVbzUdT61C9QcFaPAkii
	eB40uTzckMdnNLF1S+te5oOvgyaBelknR2G2k3avwiPHRJtFRwYBt844UEWM0fX1
	z5NEeCtFoMHcPk6KzMMcFuHeOmgMviTqSbcomJMBskkgVWyL71j9uGFe84gZTMvV
	O77HM6iszlNt4D+P+Pg/Pf4+wAuFWY8IQR9/zraLX/mALv4ssRKJEjChBy21ZzuG
	2B8VvQJnBHKAvcNXr35U4w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnb9w09yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:59:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622Fr5BA035398;
	Mon, 2 Mar 2026 15:59:21 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd4hdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:59:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PHhaQ6TnFicqK6b6qvqBfyyr4MPh/6uQe2GeB5/tMZK+bckR6/6H0jfP2Wf5v93NE3DPP0yeszhIuDfQKJFoMcEewy2VXZr2ARqu+GUkgVAWmKkUdMFzudAjfTOa7zmCz/vI1LD9gaMwCZ5SqL93vLyT8FYQ1LLQ7VhRVGEg49eAV2rAaqRFKmaklf+URqmarKjD7fovXpDy/wy0O4ztWxEMnoQ4ln1aNt4m/mGgKr6Ard+JbyZOWgw7fXaqNxY5gq5NpvLS+Ob4ZLkhZ5FxB26OZa8N0Cmla9klNf3QDvZFjpSQrMoFKZk7s+9F5plsjA9KGVqxABluuDelLARmFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvqawACacuC+OO9c2FgPaYhdTOjB3LjWrkmnUeGQs68=;
 b=NQOfzx5cZbMwPYviCxF2VFxApGNZ48jl0nojD1BZS4HmKb1rdfQ0SPxYsDzhplzEe8DP3J6Sbs9hIbKOuLfhX4Vivw9/O9WGEvKaoD6GoWL6oPUcbDvXH9J3m4lsmpugHF1HHLRTXs5Bz/xucoGi11wzC5U+IAZJQ4Hzwv9r1UJ3kiIwlTsTs1UbZZstsGDZjTsvT1fL0JRcaIYJgEnrbT4Vr+mRql7dtek5UEgqJDa1mtPBlB6J3WoTUspeMGh9FTKMjBZSS+tnUlaCI789gfMm3K1ZkO67LzgZJ21/zYVmTQL5jSiXaouIq5T/cnc570yKIIhnFnstUiXJRe6Gxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvqawACacuC+OO9c2FgPaYhdTOjB3LjWrkmnUeGQs68=;
 b=IrOtjdB/xNeCqDx3I3kbnQLfL0S2naHGB8W9+9dperWhhcPtVksipiZsmhItgMRBFjPY+qSmAoOislniViPdslz1/INdQaVnX5Ys26ZlqEx65WoalNT4hWTGXL5Sj2mlv3c6ErXpWbzIAEJRtjBbJqHNCMk619pmSnkbgM66xoo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF0D6E81A30.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d07) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Mon, 2 Mar
 2026 15:59:15 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:59:15 +0000
Message-ID: <dfde34f1-c665-444d-8aaf-0c0be9d32b9b@oracle.com>
Date: Mon, 2 Mar 2026 15:59:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/19] nvme-multipath: add nvme_mpath_{add,delete}_ns()
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260225154007.1033735-17-john.g.garry@oracle.com>
 <82090fb6-7cdc-40e0-98a7-21b688aaeefc@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <82090fb6-7cdc-40e0-98a7-21b688aaeefc@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0027.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF0D6E81A30:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8280f7-63bb-49bb-b664-08de7874a737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	F+1+M1vOYy6TnS3q2x8fEVsuCA/yIhFFYPXp+yAQHyDtv3AD2J88mcAnzjUKdxFk2PSnBYLwPtJHSGYzWDK/zycUidCJeaGTtNc+tElS+eBkMqw5T8/AqseBDEojuuQtZ1X/Q8wVwXFE9kQ6SSrBg7Z/tCrCoztgDa+mjG3u/D44Ru8U1ZgZrloxCuUohrPZRWd+RGIEGPrkeeF9MtHP8J23TRBgPGGdTwjrbCGF68bl+T5az+HcbWN9ioK3mOP1h/5cgC6ybE/AKHWcRfd670josGzd5y0OnEphyjvU1Rz14htanwLtDK+AQmk+sDQaCqbWzuqjSTGh+GWfVmyEABP6z1Dh8uSkfFI6okrTHmOGgt/pQQGIfcOLdVEiQaUVfXOPz3S8bcMaB+NbN6jPNyBwbtQva5iKHjKiHfsTsCjx5I3mHNwHUXsD3buR3jlnMAl9tBSRdcBT3t5RO2fSqvRdQzhlDk7M0o695R9VKL2anKe36j0hlzX9CwCS7Zm2plAwKCxx14PpNr8CBHS64T1OhMR5mwyPbzU2nitePzPc+drNDfgWFSUYT0/y7gweze68yPW9h3lr8AFdHNvgzybZ2crjyG2dpSIV0y2j6htSTNkcaUnLLujsMIzkQktLZG8ZB+5e3a2M/K/USISimDIHnM96vRoh8q+QUfUx29DISlsFZN+MX2P7fe5bvVmXnfuZ4kbSrGAIF/WmTk0Tk3HAl7a7WRC6jI79CP3KwGE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NWMDNOVE9vSEF6WGNUYTFOVXRZbkpoWnRMRjYzOGU3SS9IZjhUWWkyUklv?=
 =?utf-8?B?U0IzNzVJRWYzbGxzczNjQnd5YzdFb0NPeTNWWllncjBjazQyUVlkbi9Ldlgv?=
 =?utf-8?B?Y3Zaamt4aTdVSTBSc3M4Ynd6c2N3Z0VBemJrdHN0RjVTSTJibC9TUUtaRGZq?=
 =?utf-8?B?a2hQcW9HV2NLWUJKZ21LWGdvK0hsUXRJWEZvdmkzYnlJQ0ZjdTk5azZSMnNZ?=
 =?utf-8?B?b1FUMEF6NnlVcHVMVy83dDhyQUNCVHBFejF3VTFlK0doNnI0UmtiWTBjVERZ?=
 =?utf-8?B?TDNCTHl1VEg1SWxpSlk2TWRqVTJ5bGFmMmJmRHRDNnpadG1qaFhlYkUvNXVj?=
 =?utf-8?B?bjZtMkpYM2UraXFvbXRSUWdmM0kwbjBqRmZBU1ppUmluTnUrWkg1WlJKakc0?=
 =?utf-8?B?ejh2aW0zc3AyNFBRZ2g5b0tjVEQ3ME52UXFiYTZVaGVoditGT0VIWTRLeFVa?=
 =?utf-8?B?bHgzM055clBNaHlSTnprLzdpYkdHd3hRU0ZXSzVjbTRpQ0dRV0NNT0F6dFFG?=
 =?utf-8?B?Y1pNc1NkckVya05uUnJoSndKdnIrd0ZXN0dkUmxndHU4QzQzbllhT1BYdDNW?=
 =?utf-8?B?UHdadWxGM01qSGlUYVBmUkR1WFl2eXdsYnpWdC9qY05na0s4RkhzY1BEaFd5?=
 =?utf-8?B?blJTanNHNzFYSTVZZHMvVEZ0ejBhQzVFQVRBL2huam5YY0dDM3lGRUlobWNN?=
 =?utf-8?B?Vkc1dUltMzlvaUcxekhmRGtUSlNIQ253MU1jckNIWGJITXBjdEl6cGhGQ1V0?=
 =?utf-8?B?MnMwVkZzRngwd0hXT1NUT2V2eUdEVk1JUC9NUjF5Y0VqUi9pUThCVVdTTWJX?=
 =?utf-8?B?ZWEvQ0NXVGNYa1d0WWZZWHh0M2NYVlBJWGdhWGZldFM3US9IMjgwd2h3elhj?=
 =?utf-8?B?YXczWTlZNlJHUDRIK0pYN3dYeHN1aCtoMWtJWHBwTjJTRlBEQThjOUNJYSs2?=
 =?utf-8?B?WXVjK2U2YVZWNEcvOHovcU9vU2ZIanhoR05uZnhCYzF3bVZUL3UvbVhieWtz?=
 =?utf-8?B?ZWYwL2dxZDBsSWR2TW1PRkNERU9mVFU1Vk5tTFFnTDd0bmVzSVcwYlRmbzJY?=
 =?utf-8?B?anpIUW0xNkJPVnpGeXNwTTR3VkRwWHNKbTdWVVpuYVpLY1pWeGx2N2xhVHlE?=
 =?utf-8?B?ODZoVFBOdndDMW5rRXBQRGlxWi9kaDEwOHFyTk5RU1N5dnZpWDBYYkdVVzQw?=
 =?utf-8?B?YVM5NnU5ZXVSSVg2czlQbWtsb1d1T1dFc0tFTU1aL2xMTFJCbUdnbU9uSWJR?=
 =?utf-8?B?WEwrUE1QM1prVHNlYXlJN29zbnhZZ3Fwdkk5S1NiNFJvK0ltQXVlWlMrdjda?=
 =?utf-8?B?eVowU1pIQTRka2NScVo2alNVUFNhdW05eDhWREhrVE5mR0ZHMjlZM2VZSGtO?=
 =?utf-8?B?T0hJSm9jaTBKcW9CckgvNnJCT3lYSFpsSzlkSmJaVDNzZnB4dkE4bncxN2FN?=
 =?utf-8?B?RS9YMGdrcWJKOERaOFVoM0M5VWdiVTZ6cm0rMkVzMCs5eHVzYi9aQzJXTW1I?=
 =?utf-8?B?aFpQUnV4c3djYXIrT2JyMjNxQkhONGJTdWJUempua3ZxdkpqMHVZRkVZb2pw?=
 =?utf-8?B?YmdSK2QwUXd1VExDSnQzRmhCc1F5VUx1ZnF0WmgyR0NKY2gxL0VFYUNYaENh?=
 =?utf-8?B?by9MT1ZXVXVZejBDeFhGc1hlSDNqUUNlNDlQV2NNb0VnQ01tSW0va2RyMkQ2?=
 =?utf-8?B?aXBsWnhHdEFxcmd2KzJNNVQwcjQ2dmJFR3JTbHFOK25xUVpPRWcwQ25zV0s0?=
 =?utf-8?B?emJsRisyOG9VMy95OURYRjVhOEtqOXFrNGdLQlY3eEVmckZkbDJWREdnMzlw?=
 =?utf-8?B?Uk9yVkd2SFRtMWc3VnBWSldTVjlQY3NxSUs2SXlBaTFhUzhncHJ2anBPd2Nq?=
 =?utf-8?B?Nnh6WFBxY2NObnVsNk5DTXd2emYzaHlNN1dRTGVvdEZLNjl6MGtpM3J2YnhI?=
 =?utf-8?B?OHJ0aWxNbHN5M29kNC92bFAyNEt6RjdLTXh2UWsxdmRDQWFNcGp3dVdna1k2?=
 =?utf-8?B?ZHhROUhiamo1MzEvZ1NPRklhUUJua1gxTENBTW51R1ROWXFMVmhrZUM5VENy?=
 =?utf-8?B?dlZrTlhxTVhxQUtEMGxzQ3JOMlBUZklnVmUrL3NOY1V3SDByRS82c2NYN084?=
 =?utf-8?B?UlZEZ0pmQndneEMxMU1SVWx0TVl1S2d1STljYS9UdUpOMUJOYkFEVzV0a054?=
 =?utf-8?B?d0VHU2ZtSFkyUEc1ZDgvN21vNWtKZDV1Snk2Smpnb2R0NVhXaGdSYnRWTUsy?=
 =?utf-8?B?dnhhRWVkdEpnR20zalMzR21PWlNRY1p2RzhyOEVxMTJWZFQ0bllQUXZYT1RM?=
 =?utf-8?B?NGZVbXFWK0Nmb3J2YndxNlUrL2xUTlc3bkJSNmN1eGNsakQ1KytxYi92Sk8r?=
 =?utf-8?Q?JF+6uDYC78AyaHEc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vhxTEg6u1U0rTyJRwbYXrSpRWRgdCG7qjUeiCqj7+kX1/D3WFDIFhrfy52s+qjfuhyS2W3GTUHok+BnnhbL5X6WmL0cV4QNsTvZ1MUOxbK+X+xjaIo6znOUZH2h4ToqX5MgRD0CsM8IgX3eF+cXFFKXhI7uaGerTCutGGN33wUVgFXnQZ4k4Kp0MyZQqJtZJFr9tJz9DJvjEPYfwZeDldgo7qSMm7s8DY+8a95r8tUzaTGoQrLthRmcQYf4rHycR+8JW/15hNuNYGZzOO6NJMVXS0sJ0nxbzeDOwFq0CxzWZc0Kmlq9PYDJjwhstD6sISSSl1s+CheHqcyb4XvtvtplcLBgkMkIdGHo7kRcxAHbLKWp8FumgI7LEUVT/Ls3mE+/VZjRC3hwwltpJtG886y2XhzLZZgKGK7hJPLRx/BPavOZsgSf6riPe9Db5N6HRD2OkSCA482cTvSe7nxuWh0ivMAY5uj5ctZZ9bAliDqgejS1qaNg4LepNohlkL2CBfd03lOdltdxbiYVoLMMeXslntr2lpiH/hlgVsiVS17UtQxX94XspRn/JRS62Py+9csnDCeuTEt45xhnyGDtnprOndvPNYakzC8sNSi1JWms=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8280f7-63bb-49bb-b664-08de7874a737
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:59:15.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vQYJYFLg1V6lWPdGLfQDTw5D4gqDBU72I6NXubnGsSeg7xHrsTxMXnvE0+iiKvt3UtQ8xG21TOeO6mxf3zxTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0D6E81A30
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020134
X-Authority-Analysis: v=2.4 cv=GesaXAXL c=1 sm=1 tr=0 ts=69a5b3da b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=3uA2oVYaNK8HjpyUojMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12261
X-Proofpoint-ORIG-GUID: fdtIEwLLA0pqyArOCn1VupdGdjJ7jO5B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX1cfErWEXwCR8
 bZ2Yz/ZxjzzyM4ZZPESr8HLg+o/4S0arSmSiAXrRoEPsKiW6aZYzkJun5L2RlIPO5YXS20aGgoX
 hvvXw5jzMqkVDsn7EFY2lC40u0wrMQhWeNURtjOAWddAluDv8tYAHpsUSf442uYdbHoQZpJMNZs
 8vuw1gzalFzcMXz+lPB6JyTxB0Xw/DHx8eQ2iW1m/tex/jg+N+Z/T/gMP7FhCbWfoGNELZ2G7Wa
 oUyKeMIe9FSfnc7tprT8paq9EXt87Qh5yioverHcs7JE9DIb/uXnPFBbqmuZnaM5HLtqkIPavTA
 DcsQAXWd2kkSsaaF66V0pCCvDEWPucjvmyXreBdPWSoS1CbAfwKe77LQn0mHmw2kYsaed3cvTYh
 7ctQxD6CnXELHocK7nTFC/qnuCDIlUqTxbXTgCMV8MEmLEZ6JnIG/2QlKpZm+5+DJchSvr6T713
 riVj0Hm1U77htNcHifKkdPrOVx1qNboVnpVkG8hI=
X-Proofpoint-GUID: fdtIEwLLA0pqyArOCn1VupdGdjJ7jO5B

On 02/03/2026 12:48, Nilay Shroff wrote:
>> +void nvme_mpath_add_ns(struct nvme_ns *ns)
>> +{
>> +    struct nvme_ns_head *head = ns->head;
>> +    struct mpath_disk *mpath_disk = head->mpath_disk;
>> +    struct mpath_head *mpath_head;
>> +
>> +    if (!mpath_disk)
>> +        return;
>> +
>> +    mpath_head = mpath_disk->mpath_head;
>> +
>> +    ns->mpath_device.disk = ns->disk;
>> +    mpath_add_device(mpath_head, &ns->mpath_device);
>> +}
> 
> As we have now reference to mpath_device from struct nvme_ns
> then why do we still maintain reference to ns->disk? We may
> want to directly access path device disk using ns->mpath_device.disk,
> makes sense?

For !CONFIG_NVME_MULTIPATH or !multipath mod param set, mpath_device is 
not properly maintained, so I would rather not use it in the core code.

Thanks,
John
