Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A81DF261;
	Mon,  2 Mar 2026 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466031; cv=fail; b=BO86i5pBLTBIoEKZQEvrt9YJahhr2N/x8gKzeWhyv0QXboHX4TNXpvdevVeqtXxqClmdLv18BOpBT9jM3mAxpKCbsx8u7ek0faxFq8TLmKfP6dHgInjgD+bt3DSnCr2IudUUohwDFpNinZy/FwyEJRUD3b7+Lrm6vgwl0zG29LA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466031; c=relaxed/simple;
	bh=rDJvNBCIdVZh47YbbNqfkZdLzy46j7RWFAUBVtrcgzQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bnlnRhsKHnehZL32nQRvDb8/AfGMY3LFWpZJ5kaCBrUC5O4eMK3stoYqiUYKFNo967hefXd4fZa+butV104J0JqU/Scu0j26rreOlHlhAkwg26bhH0Own0z9iSyJ1cLSx1HliOt9JYO1s5NNIRdYtOuVLiLsKdz0p2p7hbDv17M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m6/Hcwnz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PUPVgNfY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m6/Hcwnz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PUPVgNfY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ERIlX1327359;
	Mon, 2 Mar 2026 15:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=keam5hRBAJs5+6lyFy09uZFWZZPsPKlpho9wi+Rz4sw=; b=
	m6/HcwnzEiSnnRz31CQhlF3HhXUb8hEwsTjGgRSx6c3HILC0lxFeeu0sbm2vnV7O
	n7c6RFTFEguOGQq2ZZdUaoVJ/jQJS2vbixg+DUUkkusbE5Mcyu/CR39y/Vh8EUxk
	l71IUjtGHBikAhgodkCIl8j9Lo+CerYWJ6g0H75T7oKUApLkz4tV0A83Z+FEGwo9
	mNWljmt36p7VlrCw9fV7NEySFExzp7bpHMeG7apWnXwnuOmnq6XgEEUo0UpLW7hX
	I6CkBx6rTbumiDu7eDoO55ZTWpUAB53rGMahRC8Q6k4tETISvwm401wZzdex6fS1
	cIR0jzwPC8XwuF4233KR/g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnbw306bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:40:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622EUcRO026772;
	Mon, 2 Mar 2026 15:40:01 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010042.outbound.protection.outlook.com [52.101.85.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8u44g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:40:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OMqUw9DXm5XAEXj1q45iBTenCimm1U2Xu4YXyxOYlQEZRpEbV+U+EcseE5ySiiXFk85fm5b49f6BklYsulAMlbDdjQDdIh74CGv/g7yxJOc25HMk3DyvF8B6cSQyHT/LoLi8Vi3hNp1qROvFxir/HDLP67HFsUGrREp/uMo8kI0UBxXr4pQ5yxAdVXh8BM5eQUk9BjmB1lNae2GwvzWyetfEoyPDN/BWV6vGnJh7fVooz8wpXEUKUKrqKxaAIP3KuyRFW1ofxavNeacGvX/CEQxNG76O9Ti8C1WjlY1n4XjM4s16TeMmU3pRArJ86barFM/pTz35NuACk0J0Mzq4Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keam5hRBAJs5+6lyFy09uZFWZZPsPKlpho9wi+Rz4sw=;
 b=QewK8Ud44UnPLWTfHCpTK6c99ighcI/7/voxY9otlvXyW7STBS6SEV+RHxLSTvq7SOHPttezhrcm4NEzeIqhxSZvF3W9YxtJ4ZKmi2fAkpmsDGgeuu4U9C81yZhwqYRtMxWrMV2gTKQfwxpLpxDNpN5XRaWcIcdfGzyX+lHReJVYayhWkzdROVXd6QKR8prMzhK7JcuQmylPDW1gZzKvnjDsQZJa2EuKJOG3nwYzpa9OA6HzpPf7H+mxOmaSiRihtylKwmoFaN/KGv3ebUOYrcgB5av9yn16EO2W6oHAWOLR1v5TVkQ59ZQowSxJ8Z5Wwpe8w3W+MN4iwRFIe26WVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keam5hRBAJs5+6lyFy09uZFWZZPsPKlpho9wi+Rz4sw=;
 b=PUPVgNfYcLeXmguLGiMCJT7f0sITRnqVn7DilxDyKXgP/fX4s2flX6qoQ+vgC0wn66wbvBZHyjZ0XZuxMj84b06YWnVK/lzWpdzfVFb/OwQdX2xJknPhNrUVRdh1sQ7yCg0gbCE1IGIWwaa3S91rtYpmhrAex9tiMkNdw4q1tfo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB5105.namprd10.prod.outlook.com
 (2603:10b6:208:325::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 15:39:56 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:39:56 +0000
Message-ID: <50b1e223-9c4d-4db9-990d-089540215953@oracle.com>
Date: Mon, 2 Mar 2026 15:39:52 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] libmultipath: Add basic gendisk support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-3-john.g.garry@oracle.com>
 <98aa0bac-bf62-4e7e-b7c6-d2547ab34ef7@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <98aa0bac-bf62-4e7e-b7c6-d2547ab34ef7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0417.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 74396d17-66b0-45de-1b61-08de7871f49e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	Ym7xlyfsQgXHXbiE93GdB9FCnc5RjxR3MdarExYPyI+b33X6hnUUgUaKBQXetDCNbXxDtrPMzrTjN9taGsfiixeYaHRDJL+QtZMhYo8dqXUnrzXmdMiav+55QWMo0XYWzRlc32EiyRuXw8NO3MTyLXIrfDAJZR/exa2N+CNZL6x/CiVjuULKEdQprylb4bjiN+zGeufWz0iESsrciv4L7BN4u3Z0tExf/LHG6jJJDJeox0PvogMs9ZQPzm67m1m3+nWS+ytpopikqifZOnX/5GVs1Z2BnLLYJ81Q7nUdAJ5VVFCLhJ4twZtS4JJLYKKVQhcysKEaKBOqO6+3hv5/K0AHEtTupU555mqZ3zlpDo0u1fWSjJJapMIv1ywgsGJTgMpD2hLY1eaUxBKGK7+mQuUN+qLrVnHf1nHABUqQdUEuzy5TlygZHxuBUfrOoTBHkP1IkelUEvN1paVBVV4h8PRdRI3CiSXernNpL21R8OIJvpHU2Vi8sfYBotrLCGuy65Knjg4Xnm5IJKAwA4H1lRZPDVOowxiQno/U4KLQD2e3W+kEzE6uMa0AZ0WhHNv0wGfXEGSz3MPDdSxYAH0Jts2zOhPfGvLLZWnQcrm2i2QHLpDBFbYHU427c+WnIwU8XdOyIMPVQPSw9U3yI/Qu3GvNmGTVdPuMi2JnAj1LISl22LrfBRTfqi6P35hJfXO//XsxzrBWTQfWJHeMj4oe9LLbMueMkv6u1Csqa5Y384Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkFHbWRnTi8vQ1hnaTlwdnZTdnZqVnpRRUFjMDBITzMvK3VVVGY4K1RKMVJG?=
 =?utf-8?B?YXlobXBLcjZIK3l0MDhXQXhoakVQNnhQc0F1WEdGbUtCWnFjSHZRQSsvK2VI?=
 =?utf-8?B?MWZCR2F4VzltbFhOdkVEWW5NQU9maFNldURqa1JKdlQrenFoaENLbkZCZ1FJ?=
 =?utf-8?B?emRJeG1MZ2RDTU02TlBlVzVwVkZXNlA0UzR1bDQwSElPVEpwYzBpYjFIM3dD?=
 =?utf-8?B?dTU3T0JPR0tvTTRYNU53aWdKT3VxbklBSEZIUlpZOWlybk9zSEdiV3hyQ2Jz?=
 =?utf-8?B?QXF1YVQ3MjlXN0ttbnlYd2dkNU43THNCeGVwbncxSm96VlJ3VnVlWnZha3lI?=
 =?utf-8?B?NTdLMU1ZTEJGMFFhWm0yM3BtaVNRdzI1dUpLT1JxQ09QYm5XVVNZZWZzR2xl?=
 =?utf-8?B?Y2cxQmtYMTVobFo0OEVZVzRUS0pTWlFMZDZRaStnR3pCUzZxaGgwWGxpTDN4?=
 =?utf-8?B?UnVSZkR5V1VITDluTUZBYTNORHdpbHdjNVZvS1EzUE1EMEVkdG93NStBRUdt?=
 =?utf-8?B?ZkVWMzVTVlNuV3hvSnFxU0R1WVcraTVwbzBkNjFkUXdDN0E3Q09YemVIWnZC?=
 =?utf-8?B?aXV0RHFzMmZaWGs1NEhmcFdFQU5jdFFSVUpvUmU2SUhqYW5uSUdkZ090b2g2?=
 =?utf-8?B?eXA3bmVSWUF2bmQ2ZmhQZUFMZ1RuakQvTHNvQjNPSDk5TlVlQlBNOU1RaEJl?=
 =?utf-8?B?cnF5VlkrY0NqVzJIZ3ErZnlkN3lYcUh5NGEyeElWaDNTSFpCVGU5SzNHekh1?=
 =?utf-8?B?MjY2SVBTRHdVODcrMzVMU0tHUndIUDdPb0l6VE5CUU5DZC82a2ZFeUNRY0tr?=
 =?utf-8?B?Z0t0d1JCVUhCcUhtcUtKOFpJZDZvRWF0T2lLSm0yRktjQm5VazZ2NFBwcTBw?=
 =?utf-8?B?QXIyUlhtVUNhcFZiTVZvSmZRRWNRMnZjc2tEbkgxWDV6N3JieWQ4WHBwc3Zj?=
 =?utf-8?B?ZmZmeVNUY0VqZjV4a2h2R2JPelFEZkdhK0ZTT0xDd2JRYWpRanh3dkN0aThn?=
 =?utf-8?B?TGJIRWlLdjN1c09vU2xyQW9HOVB4UE92RU9FRWVCcGFYNVlrVm12YUpjbmth?=
 =?utf-8?B?K0RRN1dqc1dvazhMZ3JOQ0VzNjEyNHpZY0gvYzFJYjFCWkhmNng1NkZFeWc0?=
 =?utf-8?B?U0JpVFE1ZjlNeFhzd1E4YmVZZVovdkxXczVDdTNJMlBFYlBaTndIay9hR0dZ?=
 =?utf-8?B?dlkxRFo3T3c4ZnRmRWp2TmlZZWtIQnYxazBvajJZbWZmRU52TitqRU0xUi9z?=
 =?utf-8?B?WmprL3BXazhQaEM1dmhNb09NU2s4NitXTzFwMU92cmVsK05nRDVEUUlJNHkv?=
 =?utf-8?B?cGRadStSN3dTWHRSMTFCQzlCdGRjWHZFVVJhRmdZL3dtakRQVWsyUmRMd3V0?=
 =?utf-8?B?aDIxRHZmSXZ5Z0lzSEdiMWd0ckNOTGgwQk83ZnNsbEIwM3BLTzl2M2UycjR6?=
 =?utf-8?B?WjlHNTBZV09ZaVFYWTA1ZWhIZnpHUU5talZRZHkzcmFjTDNhSzJKM25zaEFZ?=
 =?utf-8?B?ZjJQZGsvQXNWZ3AvaHZLMVlJcG1ET0J1elgrOUF1L3Vjcys1Rmk1WWpYLy8z?=
 =?utf-8?B?ZDBZcFZ6WUU5ZTVoTG1pdUlHMDR1ekFNWHozMzBrT016V0dyR08zejVSN0FN?=
 =?utf-8?B?SENSMGVDcStaSFR0NTBTRkd0MEp1NG14QTJqMEVhdExOQ2tqT3VCcWwxUS9z?=
 =?utf-8?B?d0ZRSnYwclQ1Z1BkczR3VUJpaHBsTEdpTWdMNnFkcFpKMFdGWk9aUnh4Yk5Z?=
 =?utf-8?B?QmtKdjc4bm9Kb1ZxUHhMa1lNcE5peXZXYm1mM0pHWUFRRm05MmVHRTVDY2lV?=
 =?utf-8?B?bld5NHg0eDRhMHNmdVI5WXBsUEI2MmRIZm5CTk52K0tLYUo1c3gyd0E5Q3ph?=
 =?utf-8?B?aSswT2xQOVlDMitMWWY0Y01jVC9pSU93WVovRDRBQ3FHRFRXNWgvT2lHK3VZ?=
 =?utf-8?B?ZEIxRmZ5Wkl6ait3dzdMaG9BZTNSMEd1dnZtbGZ4cXNKajZKdFQzR2xka1hG?=
 =?utf-8?B?MmxJOVRpM0tmY0Z3WUphdTVWQm5QWkRqZ3Jzd0NJVjI4MVQzdENlNVU5eE9C?=
 =?utf-8?B?U05YYjBWeTFXVW4zT1B1dVdYNDJjRGVKbWtXTlhWTndWcWNVY3ZTRUltOFY1?=
 =?utf-8?B?Mk9BNFgwS01hL2t3TTZqcTlsbENKd1dDc0V5c1M4NlcrQ1dGSk10akVRelVB?=
 =?utf-8?B?blF4TjNsY2NWVXFNMFdFbE1wREFlTWxNT091S2pWT3NkT0s2ZERaVWR0ZFBH?=
 =?utf-8?B?c2t2L0dKOS9kZHkzU2JpZ3RzNDlsZWZVY3IwVEtHeHcrVFA0UlY4ZHdzU09w?=
 =?utf-8?B?aVpvTitGK0Z4TDRnSDRmdUhkbWs5YWg3M1RoZEIveCtRakhoL0VRcXhQcERW?=
 =?utf-8?Q?DKLLWbEDLNimg36w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NKISgNTVPQ8GtcNCdYpNXTI58o2hFFv1Io/N/0mCxQBtJFpJlSdy9Xpnx851/CgmASVUW0llGXrLb5Tfk17bVsGcVWfNAyka1415eWKv2V6b4gRByqUpGkQU8n/7HVF3TSb7AZw/BKl+V+gNb1u4lcaCbE/229nUCwzSBCjbucS35hWGc8E6WWFvKRea5rSb9cMvZaQPRZeQP04Re78l7kYNfAFkVHVKh8kx3drdQV2OHwMrdC91KveyzC4I9tfcCISHBbE29u6LFGZ3vm80YbqsS6lpfYdz8wVBgRKm2HzqaFVV4/csnopPswT0/IQrxc/8N9GVgJRXLdxKCH/eZ7OCbS7PxOt67HmAdAsHTw2iKLQWYUfaX/ZNcAzhFwmClOCrFXBcAYYXgPYVwK/i1kBrPqJXwJ+L6WqWJIqAJYk3Tu5FzDGfi7IFRR9wmnOYAfSFDnvmvuo5qeG5PpNTMvSXHI4P7qLdJsvjTNPx1SmQ0VE2pqViqwAU54Uea2tQ8bEhUH+yFnmdkZc73kiRozVHxltG1V2aVEzFHhLFBiYdiU6Ql1/2Us92wtAEUmKti681QlK9E1nGs3X0I0fnPkLeyaYMtXU9/aLFoJzKqbA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74396d17-66b0-45de-1b61-08de7871f49e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:39:56.5469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iOHRpYFCvUgWGaeqd5w/4PqUjsN5zVBe+xf/5fGViZKv6FyPQ/YIaDR5u98+j3v8eX6MDCv4dBWkX8BY/blIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMiBTYWx0ZWRfX8cTbjxWj1Utd
 z4Ibhaw5G4k9amh8OIjR5ErtmRLiQJTQ6vsA12rX7UIg2XWErCctE0o+mV/C9GOr1lfEMvt4Sxt
 h5lfry8bQZQaq7inPXvGEvQ+ACGzHZ/iwkBPZK32gkEhgvTcVozyXblLokhlT0MLGx7EtfIDC+P
 5TH7kmjrSNDyNe3CcIt0Nmm9GdU4X8DKyycPo86c5yU2BPuO/MYmRcPxgNcKGQHfrNvyXr5H7PE
 IqonJUyRYQtzOzM7Jrif7lb6Fd0ISw6n/bEorM7uk7Ghzups6Iqllzv0vt/cULIStf7wRmhtlpp
 QG5T5T02NEGCTKkDN64iON67V8QsYfqWj8y1d0sJtqwZlaK7QnmUtApc4Bhs+baheE1u8xnretN
 L6EhJzj2qdXIlWvsBnHSwygAreDIg5UjhD/M+SVE8yhNeTRFpuHa21OVLPiPmj35amH5UF3zzI1
 rKCBDYqsVpR044zFbpA==
X-Proofpoint-GUID: c5uzvwOQ5SCc28CjWQurP7MNTGVq32eo
X-Proofpoint-ORIG-GUID: c5uzvwOQ5SCc28CjWQurP7MNTGVq32eo
X-Authority-Analysis: v=2.4 cv=DcMaa/tW c=1 sm=1 tr=0 ts=69a5af52 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=ulYL_mzajyB2STdd4UEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 02/03/2026 12:31, Nilay Shroff wrote:
>>
>> +#define MPATH_HEAD_DISK_LIVE             0
>> +
>>   struct mpath_head {
>>       struct srcu_struct    srcu;
>>       struct list_head    dev_list;    /* list of all mpath_devs */
>> @@ -17,12 +34,36 @@ struct mpath_head {
>>       struct kref        ref;
>> +    unsigned long        flags;
>>       struct mpath_device __rcu         *current_path[MAX_NUMNODES];
>> +    const struct mpath_head_template    *mpdt;
>>       void            *drvdata;
>>   };
> Not sure why we don't have back reference to struct mpath_disk
> from struct mpath_head here. Does it make sense to have this?

We can get away without it.

Some more background info .. so the concept of separate mpath_head and 
mpath_disk is driven by SCSI, which has scsi_device and scsi_disk 
classes. The scsi_disk driver (sd.c) controls the per-path gendisk and 
the mpath_disk, and these internals are hidden from the scsi_core (which 
controls the scsi_device). SCSI having this layered approach makes 
things more complicated. This is unlike NVMe, where the core driver 
controls the NS gendisk also.

> 
> 
>> +static inline struct mpath_disk *mpath_bd_device_to_disk(struct 
>> device *dev)
>> +{
>> +    return dev_get_drvdata(dev);
>> +}
>> +
>> +static inline struct mpath_disk *mpath_gendisk_to_disk(struct gendisk 
>> *disk)
>> +{
>> +    return mpath_bd_device_to_disk(disk_to_dev(disk));
>> +}
>> +
>>   int mpath_get_head(struct mpath_head *mpath_head);
>>   void mpath_put_head(struct mpath_head *mpath_head);
>>   struct mpath_head *mpath_alloc_head(void);
>> +void mpath_put_disk(struct mpath_disk *mpath_disk);
>> +void mpath_remove_disk(struct mpath_disk *mpath_disk);
>> +void mpath_unregister_disk(struct mpath_disk *mpath_disk);
>> +struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
>> +            int numa_node);
>> +void mpath_device_set_live(struct mpath_disk *mpath_disk,
>> +            struct mpath_device *mpath_device);
>> +void mpath_unregister_disk(struct mpath_disk *mpath_disk);
>> +static inline bool is_mpath_head(struct gendisk *disk)
>> +{
>> +    return disk->fops == &mpath_ops;
>> +}
>>   #endif // _LIBMULTIPATH_H
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 15c495675d729..88efb0ae16acb 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -32,6 +32,135 @@ void mpath_put_head(struct mpath_head *mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_put_head);
>> +static void mpath_free_disk(struct kref *ref)
>> +{
>> +    struct mpath_disk *mpath_disk =
>> +        container_of(ref, struct mpath_disk, ref);
>> +    struct mpath_head *mpath_head = mpath_disk->mpath_head;
>> +
>> +    put_disk(mpath_disk->disk);
>> +    mpath_put_head(mpath_head);
>> +    kfree(mpath_disk);
>> +}
>> +
> 
> The mpath_alloc_head_disk() doesn't get a reference to the
> mpath_head object but here while freeing mpath_disk we put
> the reference to mpath_head. Would that create a reference
> imbalance? 

I think that what I done can be improved. If you check 
nvme_mpath_alloc_disk(), when we alloc the head the ref is 1, and then 
we rely on the disk release to release that head reference.

> Yes we got a reference to mpath_head while
> allocating it but then these are two (alloc mpath_disk and
> alloc mpath_head) disjoint operations. In that case, can't
> we have both mpath_disk and mpath_head allocated under one
> libmultipath API?

I would like to have something simpler (like mainline NVMe code), but I 
have it this way because of SCSI, as above.

Thanks

