Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA05C371CEC;
	Tue, 31 Mar 2026 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774945549; cv=fail; b=PHLLuZNl1jY8nE48wFPh/U4jnL4KCRV0ZrLeme0FU68d/iaxiDuAdkrlespFk37asYN6FCoG9+IsboyoEEywVJ1ChZJQ2RuRwHRR06AF8rKq68LXlFDi7sVfLp2nLqXHaLwMXF/7UxZioeauyo4d37okXCFjVoRRbgXdCv9+iNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774945549; c=relaxed/simple;
	bh=yTxAaNhCr9+/mr3h8HkOt0DKRYWo8GW33nYFkHlTcsY=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a7qJ+qFeXiGLwNWsEOTg9gdXSeI35G8rH/op0dUqp376ThTyu7Vig15ye0gnLqCtkjlqg95Se6aQ+QYt8d5XpxuM4xfMmxpwDgo1zyNc0Rjr8cCtxFmFMuvPryB5BfJK9H85dKCr81HRpPW82veRx/mbYE5P4icKlmrcIqN3GMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b9u2d0of; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pg0Mdi0H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b9u2d0of";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pg0Mdi0H"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UMHYXA1800706;
	Tue, 31 Mar 2026 08:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bB+7/FO8au5mHpJhsjH78hCmsfFtC4mfW8w3tigOkf0=; b=
	b9u2d0offtbnRk/kJOkoTEiwBHVkYEbacUC4Lo3W6WkVZNWCpcm5fg++qQFyVIms
	aISVR3gCAYqQLD2QYAgx+mS0xGn4vOpaDYAsvEzt/jv66jV+8TUR9JKd097rKDf7
	2IkSzUULs10vkrEFVzGHVqUMK7ovN7K8D+DVo3HRXWcwmuTPAUmrjcJf1fuoc//f
	uyBRGU3qXfhcSiIUURA31xgUGptnP/W+DsDOIDzZq69LajVl4CmJMDlViwRq3AeE
	GpbEHddgwDFDHK8cRHYfBJ47WpYtFKGRA0XPVIJslhc8hEm9QqICPKskXpqWH8xi
	M9lzMEz808jtP4CErUB8Mg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d67hqbr3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 08:25:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62V8NfF7006878;
	Tue, 31 Mar 2026 08:25:23 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011022.outbound.protection.outlook.com [52.101.62.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65e9v2pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 08:25:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQT0mH5ghxIHrSbnBGkYsd+0HRidoBl4/WH5q3fZJ726EruyBmOkT1Dupp/NaBhYQe1ghbJn0vbZXPhrx4HTh9S1Xs3gXnPzQNi4gOB0Xah0inzDl6WCcxsqDHtlHdyeV+v+LIlXBkorcGU14dRIzmBsjyDETl+vG590gY1dwle5baImU0YCMhDx+3Nd/HYkMr5jl6vHzRXfXJM+l+ScwMuVpBCxA2SacaK+rJJ56QHxsWsoxRFdUjtAU8OfZLLLLSPkyJd4GJIPuYYH2+j1SWVjrFC7lLXFjqBjOaBHkMwlB3Zn60pHvarojjsNMLeRWqB94ufLrvQUpsF130U4LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bB+7/FO8au5mHpJhsjH78hCmsfFtC4mfW8w3tigOkf0=;
 b=arX+qpTesSSKbW9xFnWKAQFlVj+kUzpPMQMyOh58Pgff67fwxPUhXmU5ZTXgChfuZJDEb/78lkrxHq1LKn76ABxZXeUVZ/aMiQs2Ag3mTpaHfAlgJyJeDTneV/1r22TO0oMD0s355u5llQ0YddPNJZJc/oJDENP3qU6buoOhhVTqaUQE62IINh/cs8WIcxY7KWoHt/yIsgNPIAKObK9g7g9nspamyNpTfy3chXaZGWTav3gbB7I2r8qy8G+pJxZQiondAFP8Nsu9PlE9YwnAklCzL1tyd+ZGK20qclrPC1bib+397oIOY8AX8ixdV9skBlj/2HlUVq9yUj09WNT3XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bB+7/FO8au5mHpJhsjH78hCmsfFtC4mfW8w3tigOkf0=;
 b=pg0Mdi0Hp0tKG9tG7+BN1BvH/LT1JHotnPvJMq3S0a9RIPJvlWdK8VS9eXQOEkNJ3L1Flx4DIWyo8y65nGFjiXdv0gpNPLrVXdd05aHg6Z/2HtQl63PZYf+rM6/Pzjb7tjIxmL5XzfWjSkZKGaywycbMqVAulfGFygh0c711TVo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by LV3PR10MB7963.namprd10.prod.outlook.com
 (2603:10b6:408:20e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 08:25:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 08:25:19 +0000
Message-ID: <97e1ee63-23a3-4869-bd54-6ab3e01fcf91@oracle.com>
Date: Tue, 31 Mar 2026 09:25:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] nvme: switch to libmultipath
From: John Garry <john.g.garry@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260302141206.GA23439@lst.de>
 <69040b90-1be1-4b9d-8318-5ff06ee9f697@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <69040b90-1be1-4b9d-8318-5ff06ee9f697@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0387.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|LV3PR10MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: 339619bf-eb20-44ab-147f-08de8eff0b17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	phq0o6DrLIEOtpszm+EgjtiKrMPEgrpkfmEAJT8dxfjip/llyZq5ljaL+3w30lQY74JiDtmmBMlUrqUacXpFbGSbfIAGwRw0UgIr5R/XbnRTTyijXyQ1xlS09T8fzRoGJZANUOc5HA3YBdVRyh5fN4voCW7wTQ/z/nZTpdhzTJRsDGGRyqnc+hIAEGAC/c1W9SUFc5Adum2NWGEC3PWkpmDXaaw56hpGYubtg415/D0qz3S7CHrLRPvvE1I/0pARPYYRV7NW2i4qdQycWN/lcP/9GVH2lYBaQ7hwfPt1LPxZBQB5xfY0GKB6WrQpS3bIvwCpjPgAQIsUGstpDxCRRRJLz6bckYMy+WIPASD+nN7us1+On2+F11fewhqRJF2xthXLDTyYAHHy08eY6FUpRo8D2ASVcv9JPYOx65X7w8M/5qiFhP74+MAdidKBjHefOdKlqh8PEoyIzEPWtk3+i4qtiPUiF0y8L7jEGh3Mfbz0gKySAGQSVuleAjF0ZDbNL8pKPBREJJJE1EryJ3lnvBMOT35CqcXrY3kQxsH6/a07TCVxtZB3Do5AxRyp0wvstMtL+/yrfs86vRNrYl46Zo1EXOn+8oUpOCyab2w/Vpdew6PxBNq3adbxlzJGvr3U/9ULHQTfFuGln1HC2a31IpX2ZYKCytYxusuDQfYDNwWzKY28G0GZx9JMd9hAF8NdN7utHFF2LNtlzb3KSuyheEcm/C2e87v69nFRDuA2a9Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEJHaUV0VFdhWko4cjdHZnd4RHI2K3NqTXNlMWt4Z01tNkN6VnhvcWxDcUNp?=
 =?utf-8?B?SHpsQjR4VmJ3R2t1eDF0dmpYWTRYUGtuTHVGcjNvY0ppMmxLM0IxbndIWW0r?=
 =?utf-8?B?TnEvem5vVjVuamlzZ01MWmZRcERLK200UVRlcDBSZkRwLzFoNENHaG4yMWNx?=
 =?utf-8?B?WndWdlRVUzFjTytCdXZkUUJobExuTXNzMURvSDdRMVU4RnZ4QURKMjZCVlM1?=
 =?utf-8?B?OE1heStWc1BhUE1KZHgydFc0YjNlVkJNWHlJUU1WRDNIQitJbXliQlJWYng1?=
 =?utf-8?B?WGRhdG9LRzNSSXpmczZYS252RVdMYzZPcWFITHZHWXFiVzhycEF5eHNYa3VY?=
 =?utf-8?B?QXJrRWM0R1A0MFJIUHZRb2YwRmdrcjhheDMvWnp6bHMrc2xsSG8rR2hUU284?=
 =?utf-8?B?MDJHbDlTVDBiYnBHV1Y1M2VHamNiZ0RlUmtLampBdnlUQ3BxcCtLSnpiTTF5?=
 =?utf-8?B?WXFqcmg5bkE2SWZHTU8yYXBscjlyQzdFRVpSbGNoVFVFQU1JSm5FQ1JVLzZj?=
 =?utf-8?B?U3BrZmNEUXh4eHpNNkRUYllNaiszd1k1Y2lYUFYrZHB1Q1l6VWhaakw4U2Ev?=
 =?utf-8?B?SEI4bE5nOFIrOUttTW1Sem5Gb21jdEk2MDBxWkYrYjFGaGl0bjBTZnNNNVZq?=
 =?utf-8?B?aC9CQ2psTTBxalNzbXpSSHFHd1dwUW5TMFNuT1dicFVnWU5ZZXhEbm5VUlhu?=
 =?utf-8?B?R3R1Y2VVU09wYWhrSVNyWE55NlB1bVhyYis3ZklHbVhBMlhMUEQveDZoNjNQ?=
 =?utf-8?B?SHQ3dmJaTmdJQkhwRnZaQW90NWpaSVpSYVRmNXY0WnlOSUlxYVpOTGdiNHd5?=
 =?utf-8?B?QW5ndXNkMEc1ZUhmUGJWNkYxejhVOTA0ODJMZ3Flby9GTHFrcDM1ZmVQbXVw?=
 =?utf-8?B?VXUwVmRYTkZLRDZ2OUdVdlJYWU4wTk5QMExoVGhNQUpFaXVWamFwNlN3Y0g1?=
 =?utf-8?B?a0ZGbEtDNldmRGpROGZqRStvZjd0VE9yWTNLc3hDdzI2eVRoTnEvUzRaVGFm?=
 =?utf-8?B?UW5WcUt5aEFXeWFJbWVQQTJiS0dGNmZmRXhzTlhSZUppOWRZUnZvSEdOcnFK?=
 =?utf-8?B?WUJ5REN6S3NyNFM3dXg2bnhrVEl2OFR3WDk0VzJocGduUWI4QU1xRDQrVEpy?=
 =?utf-8?B?S2gzT0gvSEVtVmZTcHJLU2ZJaTIzT25qRlJEcDdUNUV5Sk9BV1RRZFB6S3lI?=
 =?utf-8?B?V3pUUkNPNHNPTmZpS2RWVk9PWnNabjJIYnRzNHprN3RveExXbW9MTWpsdlRK?=
 =?utf-8?B?OVhhb3JxYkEweTFoVnZRNWdxVTRRbkhmRkdwTHRjS1ZOWEF0QlhBV0xSWm5Z?=
 =?utf-8?B?TUtoZDZYdk5weCtKVC9TK0ZaSGpWZk13dlIxaVFqd0hvV3l3L0h5aVNuWEo1?=
 =?utf-8?B?dVRvdTZQczE2N29PeENXUnB4bzBUYWYySFdKeHVid3JhUndQQkI2Q0ZtVXZZ?=
 =?utf-8?B?OXR0VEdENUgxRlVndDY5amxlL1lQNEdFVno1R1YzNTNOZEhOUUk3ODExMW14?=
 =?utf-8?B?aGdHMkVqeENWa2pNK3hLeUF6NmRVNXc3QTJBaXM5Nmx2T0hvell3WDFyL2RI?=
 =?utf-8?B?ZnBtd0gwQ0tZeFI2Tnd5dDFLTWx3bGcrMDVXaFNXR2VsUVVoODFRS3JVUmEv?=
 =?utf-8?B?cHNUdUc2WTI1VkQ1WlRtK205Q2xzSTNoZy9zOWF3T2x5STZFTFVCU2R6UGxQ?=
 =?utf-8?B?dGw1eW9sRThJTmdlS0FZL1RpL3lMRUxsTzhxZWlBN0NXbUhzb1AvVDJ0Nlhp?=
 =?utf-8?B?M1ZnR1lZck03MFdDWkhoRXZFS3lsUVkvZGw1bzk0K2ZXZWVGY256Tnkwa1dj?=
 =?utf-8?B?Q0E1Vk1WVzRMZlU1WDAvVnVuMFllS085bjVyNlRzSlVuQXgvajludGF4Z0xy?=
 =?utf-8?B?QVBvU1MwQWxtamtwRHJNazlneGpVaGRlT2lFMmZZV3RNQzJRblREZEFraFk4?=
 =?utf-8?B?eDRSaWhrRjQxdFZvLzRJd05ham9rVCt4RE9wSWVIS1BINm10dGUvWVoxT3lL?=
 =?utf-8?B?WW16V3dOL25kNjNtSk0zOHozZzhKb3Q3SFgxT0M4VTFxQnlnQU9lck9jc0l4?=
 =?utf-8?B?VkwzanNrUGthVmMxelUzdHJuWDNzVUdZSmJRNFBKdUZlYWVOdWxUTjFET0JX?=
 =?utf-8?B?UGNZbHVOL2sxeEVpSlJiZUtxWklYcjAzSE41bmg5WXFaWnV3MGNPNGlvZjB2?=
 =?utf-8?B?SnFpNHd2NkJGMlFNT0YxU3VEVjZpQnlnVkxPbk1rdEhhV2FqSmduZEdBcExh?=
 =?utf-8?B?bUZtajkrSmZSclRvc2c1RDFkSkZnYlhNLzZ1Vk94UkkzakxBVXhSa3lCc3pE?=
 =?utf-8?B?QjlwOS9MRzY2V0VPWXRGcTFmWkNBY0hvVmdvN0g4RVI2djh5ck9uUT09?=
X-Exchange-RoutingPolicyChecked:
	tOx2vGhr57lI8AfWrUenwJOSYzcXUBef7GMIUjCQZG4qWGn5gAA9hk0C8NmLoBmRSN+qJzm2PrLB6FlYEl9FafqLN7/wQLrNDb1u4YYpzlNZLTyjhfOmq9teS1Hr9QnhdTR3ZAjpIAGPwlpfGO90zerDQzJGD0ExgSQ7BIy/yuEVOHmsR/HzIXKJxJYUWSZ25iKpujV7hsvxf9ANLuHbsdCxz2UZZz8IK4dq9qxwLFYhpvSdCfYjCCBWLV4iph4m5AZlHdBb1sYj6kHh3VY1RXQNAZGc2NV8RqvrAziH3S8Q2y2ivpBoIQGFucweouaaJOT+GnGAMKSlrlqB847Xhw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RKn/5dPB1Srhukqm8V1lts3Aak2SlpaLUrdGa/C7Qsr5STB3B/nrCBNcjqqEy6ea84ZLFzo2vGmOPYAlTjC/iKuKimSdYlQBwiyGq+ubTEXIbMDlOx5yK69o/fX85RPscmK5xJsT58pINn5dQlR2nWEXHfyZLqZqQHLrvxNv8Ldhr/WYo99JQ3+jza74y2SRr3ri+G0xDH3lE5icfDL5JkpCfr6MJgALQjMt9m0VxlbSCCaR+OFMgdE4U0irkXc+q1Jqc36toihUios8pwYkZ+/BBhiB+IBWNMQmOkwhYpBWFfRdzu0YpM2wCEtOkejWMUZenv4Uy42mRf09K3e1nEf28c2bYHDb1DvDiHJRuR/Qb+K3nU2U8rH4ujgnLbsBKMsVal1bSPCu0Ur2Nq8w8Se0Ucw9z4W/0eF9pSVg0198aoJnD8fuixjJAISH2fEejLNfeSiwTea8Xia05x8CPet9IHtdn3JYExmFbQIpMmnvIzTeLA6YFp4Mtj8uhXKWtMTjPzM5BM2TMp/mSGNlSM7cNa2owON50MyVDN4pVHaZToC5niXzx88izvxlsZE4yVj+sjHLwCK3VrQtPcjm6vgt28b4gs7HJAamh0cRA9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339619bf-eb20-44ab-147f-08de8eff0b17
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:25:19.0937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hukRfQk84ZbsePYMSPyGDDyuDdHBf8cu8fjt5tD3aUPtbKaU84o1+a6VFmiPLEmAguAkFC80uF8VNiSltjUBLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_02,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603310079
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=69cb84f4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VUHgZIE3kZyzxbyzL1QA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: GMUj_tLHZw7lpoPW0GVWIv4N79dlE79W
X-Proofpoint-GUID: GMUj_tLHZw7lpoPW0GVWIv4N79dlE79W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDA3OSBTYWx0ZWRfX1/+aHDUTbiHv
 h0qFJU7VKimacumQNYsBXse6+q8PGHNK2sHuuw2bUg49g9wNqVbNGVUy9QstRlMogRJZ2962KIc
 sp5I37H+LpAD95O3OE96vYuwtCGlgcI4YoKPZTzsXdBxsuFNMUg5rkrU93qUZjH/Wsl1I0kb0Bw
 s/2PW2oz8smPdM27Oox/eCGESUncCPfViXhmwVn4VsRNnETrmzWEII9hIQ8TUZXT7LwzxCBH55V
 0WKY+H62eRj1dByntj0V15DGQmxfbUvLjuB2QlK0hCtEk6bx3lVNdvklsN4c0aAOMUE+RNJhIJs
 Ko2HDtiRd0HJSfeBzz2k+TE2NFiIEna38A4MYX7GpuBjEt3PI1iNo1qRiBLSYrvxd+br68IOW2k
 oj4rJdDyxO7YkFsEi1GYB2RvCev2E87L99Alab2yVIZi36ctjY4Jpq1roUgX/KwcYmF7YE9jG9e
 FILxWwBvIy7n5Guwoyg==

On 02/03/2026 14:58, John Garry wrote:
>> Given how little code this removes while adding the new libmultipath
>> dependency and abstractions I can't say I like this at all.
>>
> 

I have been doing some code trimming, and now I am getting a diff like this:

  drivers/nvme/host/core.c      |  84 ++--
  drivers/nvme/host/ioctl.c     | 110 ++--
  drivers/nvme/host/multipath.c | 917 +++++++---------------------------
  drivers/nvme/host/nvme.h      | 144 +++---
  drivers/nvme/host/pr.c        |  18 -
  drivers/nvme/host/sysfs.c     |  86 +---
  6 files changed, 357 insertions(+), 1002 deletions(-)

That is losing 645 LoC - previously it was 282. Would that be a sort of 
acceptable diff?
Obviously that is before thorough review (so prone to change).
