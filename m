Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE85C42983E;
	Wed,  1 Jul 2026 10:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903204; cv=fail; b=IgKj4Tb54yDOKGXzn1iAIETiNj6u8vxhC0U4EziS1e4u/Qgpn4aMKngRI+QKElMXDGSkGkwsV1iXbRHUyQfMpewAEafNJ++3xFhBUw0ytRVHjOOeYL9bLMpgJp2tOOYkjP26xFb0LQFeJ2XVxxEb5+qJvKGjchLb5XWqLwrx2AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903204; c=relaxed/simple;
	bh=mE+sqkoDMhFqQlRtbuWgeyva44vCB+lWbj+Mvwv4Jjg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U1Qc+hY14svMRTUsIHA60HhLwjcDcbB5ewpxBF2AIbgu+Kvbp/Ni6+TTJz8qmpBGGm3V7c0ZCegWPQLKgXL+qgfmSfZRojTkU7aG3ijMP/lpJ3SlVuqk8SEaxxfGDO1uXF221mJgBfWidrmkHaLFkvjrK7yzhLgpsrtt3Q0o/hg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sIZGTXVT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s1QbK+Js; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sIZGTXVT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s1QbK+Js"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65UKtfDl1133435;
	Wed, 1 Jul 2026 10:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8wp8atpYymG82si0k7+hQgLCtByIB4EVilLssKLZ+sw=; b=
	sIZGTXVTFaqPF88rxMwTpdyRr4kXpQmgPJR/WTBNDbOkZ9g0Zr5JPSM7gK9wCpXf
	iTek0JG5lw4Vpl05S4EFkNT5JA7M79TKLutlkC2A7OpAmDTkMyYXX/Ij5T39XAKU
	oAgjR6GETxdcTOYSUGRMH+LfibqYNruhjUVhIopnT7cJRuNFzr9JJJbdeI3Do/07
	AzbUH6WeSkVf07C2fzeIgVh+gl8GnActK237G1VfnGnk5WWYn+Fig3epQkGIGmUJ
	HW/ceFr/Q73TniTpmFBYb5iEFhQrTiCvUvJN5ANZ1Fhalzp4L0bEa7iLknHLUPiC
	OKguWLCGA8oWUH5kytMhUg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kydwwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Jul 2026 10:52:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 661AqtwM022576;
	Wed, 1 Jul 2026 10:52:58 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011015.outbound.protection.outlook.com [52.101.57.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50ys92n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Jul 2026 10:52:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PL8kMnDzkl0R/rWK8CSJJGnXFAiZ8rGX+gqg6eNitOG7l+c4VdJOag704zMWeSzemTVetrpoWPVeiIbsg0szXHVY9EqB0Y2X6KuMbIRA+2k7wJ59LbGDzDWCcun4mIOIfzlCr90pCtOZRm0pVRwjtAsPK8z7A/Z5/fNAyBPtqE1G54u56eTChDm0sZfAsIvpXaRaUDvu3d7YrjDL3bmo4LAow34mq5+Cg4EDZdYfc7eT1YDb8fcdygUmXLZgQ7d6ULPe7MsVK3J3YO0RK/ZtOesWLAsMWv7oZikjOjWncPVDF6+TsJNPlwsWEo3WGX1+5VBxX0CgNYBs9ORgDTkXhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wp8atpYymG82si0k7+hQgLCtByIB4EVilLssKLZ+sw=;
 b=GZEc8YDZddYDOleW7+D5ah31kg9EEPUd9CZs7oDEOaap5h8Z7X82YaJgo9QwI09uvRIPga7CfYXo8fVCKPHJadFSSYpw3y4NLMyD89n44m2xlzSZKgbmSFDqoz+H2DJ5xiXWeJq5+3M0zTygQ0jrnwlo6dEkGWdAm7dFxtpVvcqCXfuGBvx7+2ZwcLZ21vwAbjpHs2VCDbFBJfh7CteUjGbfQPEs3yH4oPG0i11Mxk3/q/FXkmyEwUdHd+Rq39dnc9fOU3ZVedCIvwyybvIwTJ3ncJYzeEtedvbyTR5we+V4MmyYPwkuQdqLEOuLZmFS+TnGnZBpLS0ZWKMDaccx1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8wp8atpYymG82si0k7+hQgLCtByIB4EVilLssKLZ+sw=;
 b=s1QbK+JscJGi2cKGSSXD2s69bGTVoEqD3TKHhjPm1xPE2kyFru92zAW2FxFzcVp/pTNa1Cp7LO2LLq2xx4yLOS2KEXwPgfxkl7bbAwK8ozwHxReHm/64EUUjoEUaP4ha7SVwoIg906W2cDH+6kzXEhNGJQ+ly2VHljAULpzKuug=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4697.namprd10.prod.outlook.com (2603:10b6:806:112::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 1 Jul
 2026 10:52:26 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0159.018; Wed, 1 Jul 2026
 10:52:26 +0000
Message-ID: <9d23ada8-8b43-4ab8-beeb-b51c99ea0eba@oracle.com>
Date: Wed, 1 Jul 2026 11:52:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: proc: use kmalloc() in proc writers
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260630-b4-scsi-v1-2-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4697:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fea44df-6f28-43d6-90c8-08ded75ed651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	jrn5eoTy/4+id1L+hg0qJotZMcD0Y2fLz03Qb48BrSbI02FdqW8molHlg3VH4vQSG+MzMAitIlFJ0akGJHyi0zZ6bHZA5nmshBOTRdOik/bAA1AVGhezxEWJOuJDRA+IT+tfZ9uVzTo+E9KWJHHGu90nodXDqQTXyCOT164P9kJ0r6Y8vKIkUucd4Ok9c6Q12AsNvBReIP3sICejvmIi/6HWHTBnfUjjfeQulf3Mh+w5Vj30jF9/spOzREYy3fu7YJWmZ6yMYa4tfCsPOrSawupDtghHJggBvhRb/9lH4rY+VlXpfrM0NHdMnbME4cnY9QeU4VPYlm/ejVXZxkEjb87/I3fMy9Qy8FaYd8OQNE2Tzf503PG+ga+PVV4bIpv8N9AoBf0mq4G+5kT5lC3/u9k/4FXa3evEMKBzDMHxUnNDM52qU81mGgLColrX9uz33N85gROVwoy4405NzsBVIgpoi7fpS5FMuPcsSQaRxAeMnEjtzeUoRLjvuky+VVS17KgzVoms9HvYhI1CnLwJbbD6qyUjl2zEPQc8jJQO9SFiHsXgAfKAoLyfJBYmTMfqTjaYTgI/7MgLY2B6mtZEva1NVj9cx/OBRPCBBpcfK+mrsx7Iy/7ut8FarUm5ncdFoNrEWae0FxF5wTdw3eeZrW9fJCarZ3DWk9gFHo/dLpw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUduQmdkM1RXalJFUzFES1VTaENLV2diV1F5QzFXY0VRTUlFbE5CaWJhbWNQ?=
 =?utf-8?B?bndWTUorV0RtcmJvVXJvcklUMGFTMkttUjB4SXB6UGhqYTVjdjVkc0N1U1E4?=
 =?utf-8?B?S3pxd0FUUE5pWWpiTlMvdEdYZHNNcy9RWnB2UmdBU0VUN1lvTUxDZVo0cG1C?=
 =?utf-8?B?SWIxUW4rV1ZxM3E3dVIrUmFiR0VnNEpLMmE1K3hYQU5oL3BYYlNHUVU0bFJL?=
 =?utf-8?B?bjBPN3B4NTlNVlF5S3ZsSmo1aGptQW5UZUluMTZQRDFIOVdxT3RVbW9sU3Br?=
 =?utf-8?B?aHNVYXpabWtLU1FDc3Yxc0dZbFp3eGl6bG0xQXFVVjloTUpVOE8wVDNxNXJ0?=
 =?utf-8?B?cVdOektKZlhhcGRuK2Zsa2ZKZU5tbzJ1Vk1WMUNISGVPS2pwc2xUbkpRbFRU?=
 =?utf-8?B?Z1ZDeWhKMTVXaE5sN3hJazVxZVc5eEtTQzdib2hDV3lnb0JxWms3NUdHRjJC?=
 =?utf-8?B?eTcwV3UzbklkZjJtZUozMUQxYWJzNVJ0blhiUUF1VWxnUit6UmI2dEhIbW8y?=
 =?utf-8?B?ZjZCSVdEeWRmYjJVTW1vcUkzaUdqMXhLUkFTbDRTR1E3elNzWnJCcFNaOTVv?=
 =?utf-8?B?NmtvMStuVUhaT3V4WmVjSHFqYWtoUFprNlV5QlF1K0NvNVpSaXVnNWIyTHh5?=
 =?utf-8?B?TllnQi83WFltVHNxZkUyeWhhdHU2dDhXTEdhMGdyYmNkUTcrd25YOG5Pam5w?=
 =?utf-8?B?c3h1Z2t3dkZGc2t4UFo0ZThJb3JtVDBDdFRORElFTXd1RVE0cVlJRXk4ZEFZ?=
 =?utf-8?B?TndIZWEzcEZkYXdPRmFNbUV2aExUallHcklSdFZvZk9PMU5EeUNCWVQvcXRG?=
 =?utf-8?B?cmtaTFlOallPRHMwK0FRWFJDb3ZWYTJPRzBUSDhOME5wVHA2aXZyMEJuNUM1?=
 =?utf-8?B?RlRUbHpGK3NNNlBBSWtyWllodG5BQVVoNHNiWWhGczVFSVJEOGNieHV1T2E2?=
 =?utf-8?B?R0xOZ1k1RjJWM1g0enFCMHd4RnMvQ2l6b3dPb2FGN01zUjh6TmpTMnNGd1hY?=
 =?utf-8?B?TFhPWlB6RkpvVlplMFNMeDJ0dmFOSFROL0RNTnZ4RTRabGxtV2pjdDJ1MlBr?=
 =?utf-8?B?SDM5aHN6T0o1d1kxeERsOEpwNFdqYnlGcnhLa3gyNmZkdnFsWHRQNVNCTHQv?=
 =?utf-8?B?ZU4vZDRpbGNzdWloN3doYlNJS3VXblVRTjJZNFV4Rk5yNjc4Y3RWeTN4V2dV?=
 =?utf-8?B?WmNOTXBLVThkTkk3aUhlOE1hQlJKNjFFS3JlQXhObEFqa3Q4UjJqRXBTNUp2?=
 =?utf-8?B?dGVLQ05OTFZNcE5RZWx0ZWd3dnZNQmdRTy9ScFhFWnRENDQ5aUVseUZodlgr?=
 =?utf-8?B?cVcwampMVWJCa0FjN0JaTmlreXByODFERmhvdjl1dlQ2UjJYNWJSYmV6UlFE?=
 =?utf-8?B?OW5qZGo5YWNpQlZOc2hPcE1VV2FmdzRSUnVoR3h6em1QWkxac1JPWWF0UG5P?=
 =?utf-8?B?WEhaWldhVE5SL29Tb2ZqYWNVaVphYmoxWE9FOEd3eG5nYVhSRXdYWGxsSzNr?=
 =?utf-8?B?NkZ0NEt2TXczRXZPM091QzNEQmhzZnZRclFlYkVkU1FjVCs2TUlocndHMFg0?=
 =?utf-8?B?b2NPRjBNRDRORE1NUWwxVkVXMm1paGNHWXpEdXJkMC82eVJlNCtmNitENlc2?=
 =?utf-8?B?a2p1czNVYURWSnZoTWVKTEpIRDBsLzBjRGRiNmE3RkNOZUJoSjVSQTEwK1dT?=
 =?utf-8?B?RVFQajBqZVA5NEhXUmxyTy8xbTVRcHFXU0hjL3BZbDM4L25Ba1JMZmNGN2J0?=
 =?utf-8?B?Q0tnZGFOSmF3U2s1U2lhTkR2NWlBNkg2TURnL3ltOWdBenFwcmJ6c3h0dGdQ?=
 =?utf-8?B?RkpvNGtpYTRhK3lSSW40cFlSTlFzN2ZJTFlkSzNidzRuWk5lZERFaVJOSWMz?=
 =?utf-8?B?S0NKL1ZNUHJmYmdYSEYyOWthN0tJaHBwTXBYL0I5eVRjSXc5aDV3aCtwTEZ1?=
 =?utf-8?B?WDByRlFaZjZPUWczVTgwejNkbmUxbzJsTldKclF4VmZwb0RscnhWR09KRlNL?=
 =?utf-8?B?UnBtYlJmcHhKb3RGUFNLK2Y1cHlscEQyenNuZ0sxZXNtVnNSZW9ENnh4UjVO?=
 =?utf-8?B?YW9RLzFPZE5wN1hKM3ArZzNqQjI1NmE4TFd6Lzgyd29XWWpIT1R5Ri8vNS9a?=
 =?utf-8?B?SjlXeE5DL1FPUE5nRTVzazh5Y2NXVmh4ck8weVMvak5MdDhacUpRd2VxeTNI?=
 =?utf-8?B?WjZFNVNSb2NBOHhkMWt6UUtDYUoyK0krYTE3T3NIYkpaZzdsK1dCVloycmFE?=
 =?utf-8?B?dWV2RU81QjUxVkJOMWg5RlNGNytoVXUvSnhRTkk2akF4dG81d2FlVHUyNW1X?=
 =?utf-8?B?QW1GZkhIdlZBdS9YZGFuRVBEemIxdnlIYkovMCtSNmEvQTJueU9Zdz09?=
X-Exchange-RoutingPolicyChecked:
	kpm9UqUN4M4Gy4NUH7jWd+GptFYg5cw0q/GKwDTN79VrSu73kxU4BwlMXnI+RRretRymF7kWPYDjUTKjoFHG5rZXdURH3DCze2bV7SdCcduAru+7+bGJuwYwK7O6FrCXHRuSUmfoZvDxvpxIvzWiKfVkVd15KBHfGsYP7LKED4VUQm+H6+AkAMMk7h7R712cEbJQdvzL1cvJu6xPpBfbu2vNx2dIn4XC9hqagkhvpO1h+AOBLC05LyfFlMyQ4Yz1E5MBXC/hdbalEUzChdwZVmyzVnb3LH5faYQqOZOa4mjjG4ci7sPU/03pvV1uB593glG0eaZI4d1oyDc/h49Osw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UL8sdwykFTFU91vR8ffI4Q1+jloqI2mim84UEiLZd5AFlOj+3wpSZ4lyRGva+ornMqWNhH2Pjz7Pgip9vrJiyBaJoGXBkZFdHjc6O1b7zLLHweF5CGtGRkKJnikSn2kB7k4hLEFaeYqtTOTdmKZDTcV85UEgYA/sDXc1ZiCxPXO3OU3DdOOE7Dp/qWBkGElihUtzfgn5VHaO5djmXGpljMD7fQVzENNVd6pX0GWnpKjP64LfIpi1k74DoOsEt9hko83clm6xRtUGctA2PM9GcevEA7B7Hi+LfZ1rG5MaHgvICKmEqg0zNqrcNyr3Bn9EDdlIQoulIO/VHcU6VRlcYgj84Y6/ZFPTYJmN8WM6LmgHyO/R0sKlhF4kYg575HPuh/PqYWITrT2qvaxJFciiOZbK5kchogzmqOEMK8c9MBCmvMCipxjjzlw3pPYfQUYYG9jlT5hPPJSL6IOxHy5OGG4b1c7D2bbZNCDKgL1qDfUnl/7KYZBUbRTARyL3lLc8p9ALmDku69MgrUk7pmPOaCcRZ5w3rJLQQvYtgP61Iz3Y7IN5N4fhb+yyAi7oZbleDBMNGmOvjXD8oKGXHqUxwUAXv6Np0CoIxzpd2ST99fg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fea44df-6f28-43d6-90c8-08ded75ed651
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 10:52:25.8533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1xunIz8c5jLNSQ8SQ3PUAMpPIIwZ7SFByo7jMUeJq5tobuYVvELxPkxp8q0hx2E0my/acUzfExHYnNL8q9Ozg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4697
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607010114
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDExNCBTYWx0ZWRfX075UM3a9niGN
 opFJG6ZlZaFbBRU6A6u+VzkI7uYDWJsSbFFOcQ0P0YKKmlb6tV+p68VJ4a4ZqTS6bxVN7gB29U4
 x89CHlt0rqnbB9ba1QDfpvW5ZrLiw9zcEr5WOiIYR2nPElkBWZW3
X-Proofpoint-ORIG-GUID: k385WDwo8pBCP2AhyriASfIDw9TEd66M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDExNCBTYWx0ZWRfX917x2QAtXFuE
 Wuz7FhZH7hxR4YgjSymqES5pxzRJyBaif6EHTw2gUs2qPyVJuVGXmva2NY3ZFPJS3h5cIJd8W2Y
 jfo9oRoi68KjBztnNO+OJvpwWuHzuK35FG5m5eh090oUVwrrjqCMpgjkrG/5UUc3V/VFwv9fbZ2
 rcj8jQx5D4cyngufkZWHZNvoJjikRDLArH6AzXji5rtNogOv/m8oxFq66XYYZCMhe7+8eGgZOn9
 WuQKBqxBgLwj5WmzSqsHe6TEuD1/9vwrBfhYc01y+UCgtQiNjzNqMSf2L4+r6bF4hg5e42UunTM
 7S7U2kIUdn6vkNv3ex8attPiMjUPCSvqCShBVy8QEjG8Oyeih0fYvlKBYVAot3pMvkHSz/3X6nw
 Vg9egikZ+nl7xGcphoo6C27KiwegLppTcOORDwagG2NL2g3WVZiI5kKlCS6TWgOY6RilcBD9l0u
 3xtHOpHbqm8qO9t8AMw==
X-Proofpoint-GUID: k385WDwo8pBCP2AhyriASfIDw9TEd66M
X-Authority-Analysis: v=2.4 cv=ROaD2Yi+ c=1 sm=1 tr=0 ts=6a44f18b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=wRHJfR215QFwQOHyMiEA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22

On 30/06/2026 11:54, Mike Rapoport (Microsoft) wrote:
>   	if (!buf || length>PAGE_SIZE)
>   		return -EINVAL;
> -	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
> +	if (!(buffer = kmalloc(PAGE_SIZE, GFP_KERNEL)))
>   		return -ENOMEM;

It would have been nice to use standard coding style checks for 
allocation failures, i.e.

	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
	if (!buffer)
		return -ENOMEM;
	

>   	if (copy_from_user(buffer, buf


Regardless of that:

Reviewed-by: John Garry <john.g.garry@oracle.com>
