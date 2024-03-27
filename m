Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34A13A884;
	Wed, 27 Mar 2024 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711550504; cv=fail; b=ETTklwBBP3aqo6sF6+YhcDsFpIR9y0drQBbjT3nDUM6wGPDxjMv2m+ev8qtaWkPmvY0jBoX/w5Z0ki5PoIO8QPium94GpIZ+P/iYCOA3HBfQDSNSh3upBoLoRKf8t04CQMQ2TicMMW7IL/J5N4Q9oaNMvM3JMXHm3WGDf9/OaSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711550504; c=relaxed/simple;
	bh=nUNSONj3BD7rY3BqCTZrXdVGPuvA2ZM02jre1d7s3WE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UUvSxf/+7yCHrZdjTjA3DuVTVGspO+KrRq3oufP2w2I6xh4gWPektFEeTR98XR+FwDBrm+tPgcS6GhLHZxOQJ+7JrbCtaAyc4JBIizPzK3qp/0Vth82X5wzdMBDMwQyvUF+guOLftvT9e6I2738YyzkqFaRQqkROLR8CjFkwcMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BqDcv1Oy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z8mJahb+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BqDcv1Oy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z8mJahb+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42REWGJT005399;
	Wed, 27 Mar 2024 14:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=6aDdTwiZKddCnOvfubi4bGTLtzj2NHORoTZDTawnDy4=;
 b=BqDcv1OyIMwUiK56UM41BpFkzql46Vz1CebAZfnYNdH8bcgaNEQD+Qj8kPRn9qi3NgCC
 YmB4fLA0X/mFTkaV5isUwBIJ+zqXjdlB+glubVY8Uf8AiaOI/o9Rdlj5XB5btOvc16Tb
 uVetTrGWq6YNwt5xKeK3nZmy9p6tzaK6so49J36DbHGhmgqtmNWn3ezKuy53Yc7kcUaV
 w9HKm+5gIPumT+6cknJZsw7xROZJdYQWiuIU0OSIYQbGUL842xoFoU+gJtgN+Z5ZYZWp
 6JOHBwnNy5mgvkDJz/BzRUx+cTubWMZZW1sd4Isc+RIbOXLFcDcquYt4/q4KYqvcktJi Zg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2fmhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 14:39:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42REA2m4014376;
	Wed, 27 Mar 2024 14:39:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh8mdf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 14:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffnQgXpYAsdwnmvh71CwN/Df35RxGcoc7+zl70dxb1sLkt4hKIg9YC9bkb7hsvv6rmbWmfNM/cwPUF8kjXVsTI2UOUpybf/7u18M8pT6x8aDfasuMenxRhqxKGlOXTrP41mlSR63HVkBOYobmJ01czO+h28uF9Zmkym/345NWWw1bkcJYNOFhN75Y5Bzq3W/lderAQGeVA1awaHz0PHWrNxKBZjrJj3UZca76LdoecIWyPokLvLubHThlfMlRTSOGx5+VHr1Cy+KV/svP6OHw25vWpoYSQIexevckNRZlfxc+ESq1vWe68hxTvHuFnM7Fz1zpG5Y+Nan6kUDhNnb5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aDdTwiZKddCnOvfubi4bGTLtzj2NHORoTZDTawnDy4=;
 b=hOckVL9o9sBiJqcIWLIbQju5b04myHCu3laYa+eNmz+m6dZJMZEyGVjwWc14eUr8seHBxGhj8Vlhd5WEqzgAze7M7imXvJT03OkH3v39gSprpBXFNMqYIjkChKXzkPFnVzkfxVvTPMrDYPh+cyjPrGhA99+SMQWwgZgOmFbBEzwqqgD7X7SsVRXsYH+o+4l+u3+Sqor5L/T+xohkBdkRPJ1wNWUIc7EymjJtePtQ0EKLTyA60beMF+raOiyWacCzW8m/sqT9r9wlISuFScH37DiEUChZuKJShL2aH8cZ147bQMBAGVePT9pGT5vu5RGoHzI+denaZG9V/2FY3g2Z1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aDdTwiZKddCnOvfubi4bGTLtzj2NHORoTZDTawnDy4=;
 b=Z8mJahb+jCnF9jVSGSGgVtibSSIlTvhs5y7et5PydMrr6T1jNdChhvVLS2VNItCmKAN39/jzg7z9oAFYTaCD/Lk5zRR+fmYPZMhc9znBIKQ0Q9pSNi5dfV73mjOsAUcNz8gH+C8F5L/5goSSz2H+KXUrqv7d0YrGumK9mxDiz/U=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5814.namprd10.prod.outlook.com (2603:10b6:510:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 27 Mar
 2024 14:39:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 14:39:22 +0000
Message-ID: <bfe3c8f6-ee68-4f55-a031-a4cb777eab4a@oracle.com>
Date: Wed, 27 Mar 2024 14:39:14 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/23] mpi3mr: pass queue_limits to bsg_setup_queue
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Yan
 <yanaijie@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-4-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0020.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d1688d2-b099-4f90-9165-08dc4e6bb124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	cPDw177l6s3qBPyW2d3WBKyHFSMI1lIdCY0F5/1jvFDczMSZ0DoP7zZ/AnkkDWvH67CQIOD42YvXEeN5BDgohGhs7/uSaixwSBpiItsFfDnM4deXCd5AKAHo4o6If356a1dEaJ5QD6R4QVy5Y1krDe7sQt6yjt98qkLP7hKFp46oCr9HSo7S7FUF6csJ+2qww2E+38p6okBsRfuvN3Zu0fMmo9yhxFIj3agS/mBlif7xqPSyti0sMdjeNko52R31v0RB9dGy1DZpKS25dkGvFwOAdhzKlaMQUYCl+uwxArcJPKKcZ+5mvsdVpY3AlmfFlyCHE9QXMoBUg76N4ZZs9YziKE9Rm5MYMAok5eKG4jrwq/S0EipJFjAWQ2OVAKI4Zfdj7+EhhS5rZA0gpKnsQS4Ju3r3gH/mzaQYdXzIlj0/kM0qcIuhniIjFZwJirjANLs7yRR0qApTlP5dYD7iQFxvr1n6s5P38uY1rORslmdRU8gV0s1HXnFPQqNVaUH1nmCsoyw3OYzuplSAME64sm+FXbFbwLL31jjTP4M3E4rR+E1RwTL0yxXFR6oXjx1woyC4PPS9jUCEn1u3V/yfkpzQ6gqu6qoFhe+YXz29YwX35Kd0ewhoYlCQ7aenByyQMvMrtYajL//nWwMINzM3MwlnqpIW0ftI5H6LT3kdUlY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SmUyeXphT08zcG5FN0VtM1Nia2RXRWJyc3QvUnNvQ3NkMTdDNTgxMTBJK2gy?=
 =?utf-8?B?WkkxR0lZV3NkOEp3VUZGNzBvOUNxUHluVldzbjZsc0JmMFgrZWNpRkJFSHZw?=
 =?utf-8?B?bjI3V05IcnovbXczWTdENHNlY1E4L2s5RU54UEovUTQyVDVKeWN3KzUrbThQ?=
 =?utf-8?B?NnIxQ1BwZE9ZM3l3NEVTME9tejZpN1N4THc4WnlZV3c2bUxqUnJqaWVLaHVr?=
 =?utf-8?B?MU1mSk93WUIxOGRwRTRlY3ArYXBmK0EvVklzdytUTVVyYnV0cndTWHh0MzV6?=
 =?utf-8?B?azc2NE1sZ0p0eW9XVWhIdm80aHY1NWQyTmZNVEtCN214RTlFU1ZjNjlCK3NF?=
 =?utf-8?B?MDdoVlJXVndtK05jNE9NN280SFBlSUFaU2xMVTZsR1Vmc2MwU0xxOHVGdWJC?=
 =?utf-8?B?WVo2WmwzdzhzdVBYWlFEWS9uVzRPMU13SDdEREhmL1hIdUN4VGpnUVM3a1Ru?=
 =?utf-8?B?V3RtQklFdkFkcC9LWFFmN21Ua1dkb2lhRzlnQzhCM1ByWFZwR1pPMUZmQmxJ?=
 =?utf-8?B?NVlJTUdoM0Zkajl2TmF1dURTVGxkV3ZEOVFMT3gxaWxqcTZqVGgvTXRxUFM5?=
 =?utf-8?B?aXlKNHhNZ1FyY2U1dGl1d3ZlaFRlYkU2UzFvOWgvcjNDay9Cb1dxVmcvQ3VG?=
 =?utf-8?B?aWYydERnb2owWXV3dmgvMnFMTUIxTHBMb01NMWltdnRXeHFZOFhVYnNIc3Az?=
 =?utf-8?B?M0NuellOeUxhZURoN2UwNG85dzJHb3ZnNGtMSWZVWWZoM2tvRS9hQjhJanVi?=
 =?utf-8?B?c1ZwVVYvU2FWMXUwdGczZlpDMjNlNVJHNjRsaXVzYnlJS1ErWndnVG45UCts?=
 =?utf-8?B?RTBSNlZRNTgyaUVCVzNVYTZHSllZaTFJMm15a3R4cUVoemRzQ1ZDSVoyWnRq?=
 =?utf-8?B?QVBKL25KdkNjVTNQWU1YRVZaYjBHK2VTTnJ6Z0dIUlZ0S1E0cHhpbnN2Tkll?=
 =?utf-8?B?SmRLTjlEbVR0QXhmNlVNVEFnL1VNMi9xOUxwWUpUZEtRVWRGNWlZVFJCU28y?=
 =?utf-8?B?OFViT2U5a2FXOGNmMFd4MWlkdTR2Y1cwNmFDT05jSFd6K0taaXpwNEJhbHZY?=
 =?utf-8?B?OVVnN0ZjcFFLTzdSekljeGw4Q1JtZGZISGErbjdsc3hvR2VhWXZGTWJ0T1E1?=
 =?utf-8?B?SVJXaThhQ0Z0eTNTb3dGZTg2TWJwNnJucEpLK1p1eTdTYXN3NEZUKzc3eDda?=
 =?utf-8?B?UzZnZkYxQitlYktQR0tIM3RUTkU3cHdtWmxDWG9YbThxZGN0WE9aWk5VeGVs?=
 =?utf-8?B?ZmswcllOYjVVNmlyTmNKWVFGQzRuaWNoSEYrYi95NUxOc3dkRzZIV3lkZW94?=
 =?utf-8?B?bjkzeHFzR2FKZms4V2V3eEVXOTMrZ3dBa25zN0hpNmdaVjRYWWpkcTlPWUJw?=
 =?utf-8?B?eDZTL0UrYWpSYVRzTFRXVEFFYVlHRW16UVVocW1kUVpYbEMyc25FZndvTFVW?=
 =?utf-8?B?UXdYSlpXSU9VK1c2ejVyWjFGdDFvb3h5cU9jU2lFdDV3YkdSQ3pRK2UyTU4r?=
 =?utf-8?B?ZlNwMXJJR3kyRDAxd0FiMTZKblV5czhtWDNpM0Z1bW1pRjRCVUVMSGVhSU5y?=
 =?utf-8?B?NUtSY1BpSFRhQVVoM3d0ODg4QytDYi9mWnpDZ2F1a09JTHRpdEpERGtDOG5q?=
 =?utf-8?B?RGh0ZFlqZitWL29aZGVpT0M5bDZycTFqbFJIdHdoZGFHSjJJSVJiSUFZYkpz?=
 =?utf-8?B?NXBXR1lJZ2Fkd1RBZDFUUFA5WTBidDZBQXBvV1ZKOVplYnEvMU1PMFJVTnpm?=
 =?utf-8?B?TWduWkZRSlJKQi9sejFYSS9TL0Y2OHdOdEhabElqSnJ4MFdxdk9rM3pETlE4?=
 =?utf-8?B?eEFoZUxpbklrZXZvNW1tSHk2WlM0L0NSbi91T3BjOTJkTUYxeHYzUFVDbElp?=
 =?utf-8?B?SDExVHQvaWtyanZrOERnWnZKdERRai96L3MrT09zbVBmK280dy80OXFIb3NO?=
 =?utf-8?B?OEMvcG9XalJOWVpMQ3ZyWG9CeUZOWHkvcGxGVC81N3p1aGJKR3Fjc3NwaVNr?=
 =?utf-8?B?SDBOSXpKUWdwSC9VR3VnekZRaFFlamR6MkdaK1NwMWUyOFhOTW1uOWIrY3lB?=
 =?utf-8?B?eURLQndhbFlqbGpMdzRVbTMxbVRNVFNvcU5lU1ZvbjdoUnNYWElTcGxEVHYy?=
 =?utf-8?B?SlRvZmNpYWpaYUFMUGQrVVJYOUNlajR2TFhEQnZQcjVoWWRSTkh3cktkVmZu?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9b/jq2nTLnOREmOPK2PECElenO8CS/aB05tg5WrzDKvIIl9BVzB5Zo1Lk23PkUGfg4sSHoaVd+oV2zcPckkBcfAjGidX32wXtkya0L2XeI237jWKOwr1M7BsfTSr+/JoC2tfBxAAdOE8s5u8EmGnfildnOwsERlsoZwcilfLEj8gJOqj3CQxM8IBp3y0HtFQszBtax8dhMWSngkLJcKGgg3eJZp+83JNm8mDTKnSYsnWRo4pWU23gGvy9t1Q/SNDR+OKG9JFdXyW3MLee/Y49LouEJO0BoFtTqv85MIkvb5J81vyGHT5UbnM8kCSFM+/wFZv3uloL/ca/v4MwHc/LNFQYWzqTvWDtsI9CIDe/4RG+kf00EC4Vq6H72WcmnwTvbRy6gt5IFy/0c6IEDoE8lMc/jneOdR159nalHR4oTIZtqXeid735hR8t08Qis44dSfo03cxPqsJW5bCJEBALM/d1Jr5OIcVxcGwbXDK3Mc5fimg8DCMujuzVriZXPeigcevD3+I6vFebFWouFIKTh9IfXjeF9KiJFLQF/3sKdW0Lr3/fVvEfS86OEYUZ9MZwiMlAqjl9maG4XXBJBY2l5CFNziLnkJ6pSc/6VILb9Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1688d2-b099-4f90-9165-08dc4e6bb124
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:39:22.2725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksEiG2ILdnvqRdTa1sLLscAokXin1E1n4gCsY/cDQ0VF6KBgsrpbkp3dJKWM1W5/3UZLpF3ST2G6Ed/VX3qdVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_11,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270100
X-Proofpoint-GUID: _wfDHGmdvotpeEIR4qlY2_ZqCJJSVOdn
X-Proofpoint-ORIG-GUID: _wfDHGmdvotpeEIR4qlY2_ZqCJJSVOdn

On 24/03/2024 23:54, Christoph Hellwig wrote:

- bouncing open-iscsi@googlegroups.com

> Pass the limits to bsg_setup_queue instead of setting them up on the live
> queue.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>
