Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D901B4257;
	Sat, 14 Jun 2025 06:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749883524; cv=fail; b=ThkcA1ortyj7eKBuocxllWi+O38TGB5bNFYqqyMMlyIKfbvoRD8QzSNUt7EenTycTLuBHqbUo7KKlrAtV85ZNngAjn0QSAXHy+phIVLFDEunNCb6l8I+funoro//A2HHiPef6aZzlc6UzXfs/CX/S2664AGwSxR4+aZbeA8OWCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749883524; c=relaxed/simple;
	bh=8xTcBrMq8HM+5b2Rf3oQMbLP1UhgdXFvp7z/ZSEweWw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U1FbDQfZ/F6t89E56H8jqwY3YaEzhG706javOK/pI4mSMV6riJhiJ0ptFfBC3l+xXDTSaiW3KUi/lZH29oLJa7Xm1e7jNnCsyQHFQZrG2QzvbSd8Y6Cz502KMgI8aaL315AWlyIiQxnxVKTHKNJhZBo1ku3VKJqDfnB+kTUIfaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RPZICxkD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nqqIAYaE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RPZICxkD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nqqIAYaE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55E4o2un016455;
	Sat, 14 Jun 2025 06:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N9C2EIiUNlVD02M+cG3ioov3plhol8hN6e55scesE1s=; b=
	RPZICxkD0V1kLee0bi8XcgAtaDDr21Kxyz33KLC9uYrUar1d6fqfyw90BUu3u3j+
	/lefGSPSxNIetNimxUelaLXftDn0eAwJawwjVUplBqFGOaDiDTNEWY4QLiTFfiKB
	ES0xoacjew4BTQqYNtVtDPvTB+vtdCU+Akzv8QIDKm9U8jK+aoLabpJmdIlm9QAd
	g2EV/eh43Jtr63vrSAXIoo0NMBID6dFahMcGsh1mxxflY8Q2ymXSEo+Ow+VcxsGD
	SJp4934MpJ5J/tEJx/KLjYAD35kcHSdFYnqJa4p9rym7Nu6xzo7y5k9hJh8CQPRs
	oHr1x+EBB+t3J+AN+QYeNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4790pvg31e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 06:45:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55E6FU4h032951;
	Sat, 14 Jun 2025 06:45:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh6c1er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 06:45:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlVAm4sD+/L+aIZ5exUsk5q4UjjSXgcMBTLDL9+cHurZ7KK3Js/oWHANvPH+uj936MIyib8YnghSwsyy+PAiV1Y8FKYixSdxpLKhd3rXfYny1pb6lsiD/HM/6RFWaWCqWlCOIVi5oCzxjJci3AQFeWBgMMrOkYOHd7vevXOWHUf0zVEupF6e1tkkR/pAip3pP4uz2cOKc13qtz+lA3rIKo/3+FrCPVHnI2oC5DcJQKL9Fh8zrpZ+aklNZNNzDzutiSilfI9fRRbyfIASgKTXlXRsTJ+POoJpLFA+aHghpVHU2oSUxcKbajGt1OiI8hBzPHmwZ625d3rRIi0CdmzKng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9C2EIiUNlVD02M+cG3ioov3plhol8hN6e55scesE1s=;
 b=nZU2bllaRuh9d6tGfVVhy8yCkPQCInUO0ZGJkzx38RJqq1KPGOEE51KbvufsmGUPrTRebrlCCJC6zQERzDhXRM0igb7Uf4z5qMMOWQlY5IY8TeX+1ea8SExzGqtv8ngbJzLAoIP9/DVoUaR1G8V7rbt8AmTEx6nRiz4EU8P3RHkIJZidnthd8QOpK/aQWiQHwGNWnCCx9Dco5b/ATeEhJr09GrqT2rQiFFV1dM6zdOeUTZoqlQr31+biciR238I/Y7sign8ZOGbPhm/rmQ+aCUnVeSvFLBGXlNXKQPHrCyGwyJtVGWjaM9Ff1ckrYCxscU29XpAX5zTK7FcnBbJujQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9C2EIiUNlVD02M+cG3ioov3plhol8hN6e55scesE1s=;
 b=nqqIAYaEDwE1MLtLxrgJs+k4+ZFWLqRW+BT7kX/hWRV4WiuP2NTO1VgrFFFa6cFZ2W2JG3IPS9CAVUQWpR5fgugYWa63Tmrc677+kjLZXtrMBqbfzg9BH6V88qJKhhDLd0qY1KaasW+/Jr5+GPs5oyhlIGmaTKlAo2ue9McY8fs=
Received: from BLAPR10MB5315.namprd10.prod.outlook.com (2603:10b6:208:324::8)
 by SJ0PR10MB5719.namprd10.prod.outlook.com (2603:10b6:a03:3ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Sat, 14 Jun
 2025 06:45:10 +0000
Received: from BLAPR10MB5315.namprd10.prod.outlook.com
 ([fe80::7056:2e10:874:f3aa]) by BLAPR10MB5315.namprd10.prod.outlook.com
 ([fe80::7056:2e10:874:f3aa%6]) with mapi id 15.20.8835.023; Sat, 14 Jun 2025
 06:45:09 +0000
Message-ID: <0c9391ed-2015-41f7-850c-39c20730ca8c@oracle.com>
Date: Sat, 14 Jun 2025 12:14:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Add initialization for ATTO 24Gb SAS
 HBAs
To: Steve Siwinski <stevensiwinski@gmail.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com
Cc: gustavoars@kernel.org, James.Bottomley@HansenPartnership.com,
        kashyap.desai@broadcom.com, kees@kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, prayas.patel@broadcom.com,
        ranjan.kumar@broadcom.com, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, ssiwinski@atto.com,
        sumit.saxena@broadcom.com, bgrove@atto.com, tdoedline@atto.com
References: <20250613202941.62114-1-ssiwinski@atto.com>
 <20250613202941.62114-2-ssiwinski@atto.com>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250613202941.62114-2-ssiwinski@atto.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::19) To BLAPR10MB5315.namprd10.prod.outlook.com
 (2603:10b6:208:324::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5315:EE_|SJ0PR10MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: a72bbe3c-e930-4d30-42c9-08ddab0f0117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmN1S2FUMUJTa3NZR0NiOEQwS0liYkphUUZVb0duYUthbTVRY1NsSGorS2FK?=
 =?utf-8?B?dkNrcmZIems5V2VWRWNGendNTXU1NkEvYkE2S0lvU05odFhxWXAzSUtIWmpT?=
 =?utf-8?B?N3V0OE96bnlXeEluanNNQzA4UTY5OHRyNlJOczNNQkpVbmN0eVpuOW1KYWxP?=
 =?utf-8?B?SDFRTmM4UE5SSFZrcVM0SjBZYlpQemFyWEJ2eFR3REkzV3NTU3d2R2VVTnVU?=
 =?utf-8?B?aUw4UFJhUlI4TGV5K1dFaGdMWDdyaUwrWUczUkxiS1ljK1lidTJESjY3M0VH?=
 =?utf-8?B?SnBGOTFuaXdHLzBvYUtOUnh2NWFnUkZWNkdOSHpkUDluQll5amdPbXNDTVZT?=
 =?utf-8?B?YXE3eGVadFZXWTltbUYreUVmUUQvd3doWHBOSytnQUN4dmtUK0V1T0l3OS92?=
 =?utf-8?B?NWd6Zk9Fd05SVlJYcmlHRTNMdHdoQWtBTHYrcm9wazk5NlNhU3ZSbmpIMklh?=
 =?utf-8?B?ZkdNdzJxcWgwOW9KK0JYVFl2RmFlTDN5c0V6WmV0aEg0TXh4N3FSWTlkejMz?=
 =?utf-8?B?dzFkdUVGaXhsUTNDTFo0TXcrVjBaYURSU3RuK0xFa2VEb2s2WUNoM1YwYUV5?=
 =?utf-8?B?b0ExNXk5bE5wdkdJbzZtSXRmdDcxZ3kvT2dmdlQ1L0xTZU1vaGJOMnhXWS9J?=
 =?utf-8?B?UGFjTENNVmRZbnlha01MZXFvYjRaYjltQTFnNjNBRmNaR1JTNjNaTmwrV3Y4?=
 =?utf-8?B?cGVWU1h2Vzl1aEJwVE1HR05pelBCUXdCbCtYWU94cVF2ZFFFaEUzMENMMmUz?=
 =?utf-8?B?YmVxTzU1SVdGZXZNME9kK1FPQXNzeE5EcVFNVkpYdGlEYUEzTFllamtzODIy?=
 =?utf-8?B?SlBUZDFpVThWci9SM1BOQkZ2bStQT3Nobm1sdlVDd0NHZGlrSmQ5M3phODBT?=
 =?utf-8?B?MEpxcDJpTDJsNDllcGJ1UlZPR1dTMDB2MnRGTE8wbDZRcm5rbjRFczhoUHJm?=
 =?utf-8?B?QUp4b1k1ek5ESjdDZEk5Z0E4RmdlZmxoc3h5NFZZTkFuSHZVRXBuQzdGdjNq?=
 =?utf-8?B?b2JMR1dScCtCVU9kUUc0aWtpemEwa1A3VjdVbGpXS0VuRE1YdFc1RUpnZlh3?=
 =?utf-8?B?eElvRVlSWlZ1OCtVaThkNGNLL251QlBqREJma3p2NVR6K0svUlFHRDZNT293?=
 =?utf-8?B?cnNzcVpaTjNWR25URUF4UnJLYTB3ek8rWVhIbXF6UDlvNVVqMk1pb0hLUVdP?=
 =?utf-8?B?eVAxZHZTUWtlQ3pVZTBVWFFtRWwweENOOEova0ljRzFjeDUyVmxLeFNmVE5a?=
 =?utf-8?B?Vms1YWFqVnZFZFpucHJ1VmxvM2pRWktCSXRuUnlmYlExNGc3OGJySG53a3V2?=
 =?utf-8?B?K1YrbGlqbHlrNHhpTG1Qb3VBUHQwTVArSHB5OFdtSS9mYStlVDA5R0FtZFRm?=
 =?utf-8?B?RjR2eEh2RHdGTXc5YkVTV3BQNUFCaHFBMVEzanVVT3EyL0xQQ2s3S2Zib0dw?=
 =?utf-8?B?ZUFVSTU5aStJMytIVGdEL3BJUTZoK01VUVNyL2ltc1QxSmYreVlhWVJqUGtD?=
 =?utf-8?B?cHJjNUJOUHpVU0VhbWh6UWVFcy9lS2JURXk3NTFvWlNNR1RXa1I2TDJPVjZ1?=
 =?utf-8?B?MEFVUU94RDVPSWhhZUwxWDNQNkxGaWVRVk52R0VKbVNCQXJrRDNvTFd1VXBh?=
 =?utf-8?B?MGtEOUtKS3BJdDJZcEpTMTVoOXY2MS9nYkdDL2RZcmFJVmRoNEtWUTdEcnJH?=
 =?utf-8?B?bmNPTFZGNEZFanVzQWVoTFpxb2NONW5YMkNJOVo5dTIxdGUxVVRUeU45M0ZO?=
 =?utf-8?B?VVNHRTViV3JoR2VQRlpQQ0dTNnNuaDdNOTVMNWh5YnMrcDJkdUMrc3pZa1E4?=
 =?utf-8?B?NHNPUzNFenZhblE0NWFuZWN6ZW14Ry9EM1VMMzVWeS9nNkVuSXByMGw1bjkw?=
 =?utf-8?B?ZTRTUEM5ZEt6cWpmZmhrYVJneW8xalJRQnkwVTFIeUVvQ1FjNGVkRGVwMzhF?=
 =?utf-8?Q?mPrwbGA+i7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5315.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cksrazlwNDFCbFZiNy9BNHVuZUFJeXZBbGtNejFheWl2bnowZ09keFVPOEg1?=
 =?utf-8?B?T3pldStMRXNkWDRNekpqR0FtaExNUjJvb3E2ejU4eU9rZFN1WDU3QThLbDRE?=
 =?utf-8?B?dWtZbjNORnZoTTRQUU1TWklvd3JFMGp6TExnSFcza3NWalgzaEZiZ0VnNE4w?=
 =?utf-8?B?aVl5azlnYnJtb0pSRDJEKzJLRWpwSlFSRHhGUlpoZGQ5ZlVheHhnK1JhSDdy?=
 =?utf-8?B?Wlp1YlNieXo2RloxcXZuenZ0MTcvdHFHVEduOE5CdWtZOGUyY2t6ZkJMRUNl?=
 =?utf-8?B?bDEwaS9yKzJuNjJRMlREMGVxMXpWbDE4N1pkeE1JZW1HVWxYdXZ5Y29JcUdy?=
 =?utf-8?B?YVBvMk4wNW4xamRBVERZZ0ROWmw4TnVHVEdtVVpGdytrdWxOaHYvR1NZVi9w?=
 =?utf-8?B?SjkrUGRIOFlka29HZFpxWDZRMnFzc1JTOXNzTW43cjJWTjNkODVUd0RSSFlD?=
 =?utf-8?B?RUJObmRKdElHbTQ1emVZTXNxazZTNFlodktVcUVBL1J3bjR4SjY4OFd3NElo?=
 =?utf-8?B?RU9hRTkwZnI0bTNwVGsyS1lqWloxL09RRDZCTWtrT2ZkNXdZRkxxMmtFZTdC?=
 =?utf-8?B?NXp5VW12bkQ4eVB2akdTdnR1bkJwdEZoeVN3VG0zOFJaZDJFL3RSS29yY2k4?=
 =?utf-8?B?VmhUWnJQOHVJSDdxa0pnbGZCUG1HUHFWaUdhWlYxTENTYnBOTDlCUXFkRGNz?=
 =?utf-8?B?ZE5wSWVYWjU1MjJpT1dwOThtcm91OWVyM1B2dFU4NHRwcStlQ1ZYd3FiV01o?=
 =?utf-8?B?MC96dDduZUx2dlVMdGVUaGdVWDJ6VzVnRnc4V3RpYjNBb3RwcFR1a1UvRkVr?=
 =?utf-8?B?RWxhQ0FqVkNmTDlYcER3ckFMc01FUUM2MkR1Y0VEa1JFUVRXQlFtTXV3b1VS?=
 =?utf-8?B?MnVZdFVObVZFdTRDRlphTDFGbnR2cnlJQ1FsQ21rV01kVEpoVytIYlZteVdJ?=
 =?utf-8?B?STFHZXdPb2JseURoN2M3MUFPWkthQnJqZHhVdkpCTjl3dDk2T0Y1c21hMi9M?=
 =?utf-8?B?K21sa24ySVF5OVB2OHhoQjJLb0VQVEJvdjZOeW05SUgwUWphZXNrcXVRa1JB?=
 =?utf-8?B?bzBiMTFHejZzaFlEeHAxN21nYzc1SkRQZ0VPc0FvdGRpSWpDVk9oYWdTaG9m?=
 =?utf-8?B?S3dMSkZFTk95NzRRV3l6alA3QlNjODdKQ0pKYzZtL3J1L3dCSGFzYVVhYVdl?=
 =?utf-8?B?UXVCV25hejA2V0lFbkd2RHk0aVZCYUFLQmwxYkNJRU53dncyREIycS95SzZp?=
 =?utf-8?B?M0NsTVRGSzRYU2F3K2FHRTZDbEtQdUxrMVVKYlFyV0lFaTBNaVJyZUxSL3NY?=
 =?utf-8?B?M0dMbFJWRlZzM1dnR3UwSUF0SVArQzFQWXJuZU51VkdqVndHUG9BK0wzVTNV?=
 =?utf-8?B?T09wcGw1RDFjSW1Eaitocml5ZzRobmJlWTlMNEJXQVlXOFRTUE1oelBQbGFj?=
 =?utf-8?B?Y1ZiSmhPaHJYS1BoQXM2VENZUi9ZcERHWjRiK1BWOHV1NmllSUhzTExqSUlU?=
 =?utf-8?B?aEVCNGMzSjY4QmNHMWI3SzREK2pyVkdPaGRGOEk4aUE1Z2N1Y1dSQU9MNjN3?=
 =?utf-8?B?ODZ2T0Q3QUw3aDYyUG0xbE9VRC9GWERHbVRYV21uMkJwSC9hLzVCNDdzYkQy?=
 =?utf-8?B?OUdFQ3RyQWFwbldLdGxBVVVnVDJHMUdLV3ZqbnJvTjNOcXpraU9ja0l2aS9L?=
 =?utf-8?B?Z1JxZ1BNQjU0Q1NYV3FtaTFQU05Kd0VRWlJaUzdCaFdWQ3p0elQ2cVU1ZE5m?=
 =?utf-8?B?V0c1VGl4Nlh6RjJUUjc0UThBYk9wVXpwbjJZQ2IyUzN6SHZUU3d4TXk5L1Mv?=
 =?utf-8?B?UFNkQkxER3BTOWZoY3RSS05rZ2dUVWZLVFRqbEExNXQvcG1WQ2sxd0JtZ2Zl?=
 =?utf-8?B?UG5reHVESWhSU1dLQjZDMXVHb1dYaGJFY0ppaFMzeGkvQnZKL3I1U0l3TVhB?=
 =?utf-8?B?TEphZ2NjbHNFUGVjZnc2Sm9qWTYwVi9mMWdtU1g0K1BpbDVtUis0SmpkT1Jt?=
 =?utf-8?B?d1JjdmNmMVliOFlkZStJdUZ1cVdBZSt2Y3ZDYmdaTTlPTXJiQm1KNERUNitu?=
 =?utf-8?B?cS9yMThNSHZzM2lOZ1lnQXRrRjJvZHlsbEtha1lvdnBLMTc3V1RVSHNkcFRq?=
 =?utf-8?B?bjZDTlIzUGhJMHZXaEdLWUlQcFJjc3E4T2cxbFZaNUdHYXd1Z2t5TUhtVGVq?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kbNmuohtASVwN63F2XOHLriyQYD2DDDT6YoM+7FeZ74kgT9UY1LifnSLaGyJk2dhaWPVSdYZOziYwSbMTEbWhqDcHCI4EYavt7bTYSSP6Yn9suLbaBNLA5faoe2mPfbGjXPa1R5+wDTYWYmm2mGWoWGYuS20XyjCqfzgmox6vwsijojkVZ8mydjSFDhWvIUO8p8Hnqw0bTl+/pT/jLnvi40x8qRttWHQanyoTb2cLwXEalFp3lLf/Sik0qfuaQcpIgUGUq4/3JiWXX/f6nnxOx28+UFYu4rgdJ1K/4498EfzwP+ki53BwPKa6MtvtRd4rqSQ83lKl3G/Y24Z/oYxAI+wfPKQQJlr1gZ6APDQyT7g+PkcmIljHOfW99LphhJQz6makBPvJ8OH8dx9V/AvqXg1rqmbvS+aiHlouZlK9x7ZHfhJnUVC6qKax8jq9oWWIvgdN3gEEEM6zIfR5Cbroy/oDDnV/e3kIqrJJ8QN2S5KvI9+aVIInxLqorF8ewfoz+5H+gZATtuCzV6xbf1HVJ09i3c1OwZ0PzyOWLLowsBGRqn2y3koN0GnBPll7V+uMATNMBTU0tiAVToxwOMX222oEXWHJNL99ayWiRUQxUA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72bbe3c-e930-4d30-42c9-08ddab0f0117
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5315.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:45:09.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+GRWwTwmXCx7/CM0S+1hivVRio3N8F1Nxab+SuciFbx1sjT5zIL41+t6O0vP4X4qTnOtnURO55gFNQjF1tLbTUIz9BKkaJyJylOZFVVAFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5719
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-14_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506140054
X-Authority-Analysis: v=2.4 cv=b6iy4sGx c=1 sm=1 tr=0 ts=684d1a7a b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=YaA7D_pjAAAA:8 a=6740QzJ9aErTCV-6D_8A:9 a=QEXdDO2ut3YA:10 a=agQd6iE9rmx6UejsZSB5:22
X-Proofpoint-GUID: J4iI3tvRADbhj6Vdfw_-L9Lk8YXzDmmo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE0MDA1NCBTYWx0ZWRfX1Qmj7QPdfOy6 B++NIZ/+p+iRJeFjVc/i8HAG7Oh26Jc4pDbLpOGAmAElQ0Y69lRyHqII008mG7PVjYDycqKbFbg q9ifY8gzTt80t1KTYtFQVl7EEsrOhIvaAULQ54OD+f++xlb65Y6COdFmbQaGh5o+s53l+92x2tU
 AxptOiL9haSKxPqpd8oT9q+uXyAnGcwaG+oIAhj2JkSNFvuaQQKtwr4RrXvXGxA2fciRIOlQGz0 FRLZmUyzvAjryK49rkIUC0boaMjsy46GNV0shCDwN3qcK3+gCXw6DvE3a/Qo545WoHe76+QwizN dWAx4xPfOSlOIGIhxSQ9onhS+IHV2kcUD7QleRu+yapayXOV//v6iQVH8nfeAqyz2QpKeXx/8N2
 RgVBKOPwLcra22XAvyZZ7HKAY7Ba8CFFrc2hw6JptuUv12AbsDCBadsrldUUZYEsAaG6++lF
X-Proofpoint-ORIG-GUID: J4iI3tvRADbhj6Vdfw_-L9Lk8YXzDmmo



On 14-06-2025 01:59, Steve Siwinski wrote:
> This patch adds initialization routines for ATTO 24Gb SAS HBAs.
> It introduces the ATTO NVRAM structure and functions to validate
> NVRAM contents.
> 
> The `mpi3mr_atto_init` function is added to handle ATTO-specific
> controller initialization. This involves reading the ATTO SAS address
> from Driver Page 2 and then assigning unique device names and WWIDs
> to Manufacturing Page 5.
> 
> Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h    |  35 ++++
>   drivers/scsi/mpi3mr/mpi3mr_fw.c | 310 ++++++++++++++++++++++++++++++++
>   2 files changed, 345 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 9bbc7cb98ca3..05583457ffaa 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1438,6 +1438,35 @@ struct delayed_evt_ack_node {
>   	u32 event_ctx;
>   };
>   
> +/*
> + * struct ATTO_SAS_NVRAM - ATTO NVRAM settings
> + * @signature: ATTO NVRAM signature
> + * @version: ATTO NVRAM version
> + * @checksum: NVRAM checksum
> + * @sasaddr: ATTO SAS address
> + */
> +struct ATTO_SAS_NVRAM {
> +	u8		signature[4];
> +	u8		version;
> +#define ATTO_SASNVR_VERSION		0
> +
> +	u8		checksum;
> +#define ATTO_SASNVR_CKSUM_SEED	0x5A
> +	u8		pad[10];
> +	u8		sasaddr[8];
> +#define ATTO_SAS_ADDR_ALIGN		64
> +	u8		reserved[232];
> +};
> +
> +#define ATTO_SAS_ADDR_DEVNAME_BIAS		63
> +
> +union ATTO_SAS_ADDRESS {
> +	u8		b[8];
> +	u16		w[4];
> +	u32		d[2];
> +	u64		q;
> +};
> +
>   int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
>   void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
>   int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
> @@ -1533,10 +1562,16 @@ int mpi3mr_cfg_get_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
>   	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
>   int mpi3mr_cfg_set_sas_io_unit_pg1(struct mpi3mr_ioc *mrioc,
>   	struct mpi3_sas_io_unit_page1 *sas_io_unit_pg1, u16 pg_sz);
> +int mpi3mr_cfg_get_man_pg5(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_man_page5 *man_pg5, u16 pg_sz);
> +int mpi3mr_cfg_set_man_pg5(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_man_page5 *man_pg5, u16 pg_sz);
>   int mpi3mr_cfg_get_driver_pg1(struct mpi3mr_ioc *mrioc,
>   	struct mpi3_driver_page1 *driver_pg1, u16 pg_sz);
>   int mpi3mr_cfg_get_driver_pg2(struct mpi3mr_ioc *mrioc,
>   	struct mpi3_driver_page2 *driver_pg2, u16 pg_sz, u8 page_type);
> +int mpi3mr_cfg_get_page_size(struct mpi3mr_ioc *mrioc,
> +	int page_type, int page_num);
>   
>   u8 mpi3mr_is_expander_device(u16 device_info);
>   int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 1d7901a8f0e4..c0177ad3d200 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -4203,6 +4203,163 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
>   	return retval;
>   }
>   
> +/**
> + * mpi3mr_atto_validate_nvram - validate the ATTO nvram
> + *
> + * @mrioc:  Adapter instance reference

remove extra " " afetr :

> + * @nvram: ptr to the ATTO nvram structure
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int mpi3mr_atto_validate_nvram(struct mpi3mr_ioc *mrioc, struct ATTO_SAS_NVRAM *nvram)
> +{
> +	int r = -EINVAL;
> +	union ATTO_SAS_ADDRESS *sasaddr;
> +	u32 len;
> +	u8 *pb;
> +	u8 cksum;
> +
> +	/* validate nvram checksum */
> +	pb = (u8 *) nvram;
> +	cksum = ATTO_SASNVR_CKSUM_SEED;
> +	len = sizeof(struct ATTO_SAS_NVRAM);
> +
> +	while (len--)
> +		cksum = cksum + pb[len];
> +
> +	if (cksum) {
> +		ioc_err(mrioc, "Invalid ATTO NVRAM checksum\n");
> +		return r;
> +	}
> +
> +	sasaddr = (union ATTO_SAS_ADDRESS *) nvram->sasaddr;
> +
> +	if (nvram->signature[0] != 'E'
> +	|| nvram->signature[1] != 'S'
> +	|| nvram->signature[2] != 'A'
> +	|| nvram->signature[3] != 'S')
> +		ioc_err(mrioc, "Invalid ATTO NVRAM signature\n");
> +	else if (nvram->version > ATTO_SASNVR_VERSION)
> +		ioc_info(mrioc, "Invalid ATTO NVRAM version");
> +	else if ((nvram->sasaddr[7] & (ATTO_SAS_ADDR_ALIGN - 1))
> +			|| sasaddr->b[0] != 0x50
> +			|| sasaddr->b[1] != 0x01
> +			|| sasaddr->b[2] != 0x08
> +			|| (sasaddr->b[3] & 0xF0) != 0x60
> +			|| ((sasaddr->b[3] & 0x0F) | le32_to_cpu(sasaddr->d[1])) == 0) {
> +		ioc_err(mrioc, "Invalid ATTO SAS address\n");
> +	} else
> +		r = 0;
> +	return r;
> +}
> +
> +/**
> + * mpi3mr_atto_get_sas_addr - get the ATTO SAS address from driver page 2
> + *
> + * @mrioc: Adapter instance reference
> + * @*sas_address: return sas address

it should be @sas_address: Pointer to store the sas address.

> + * Return: 0 for success, non-zero for failure.
> + */
> +static int mpi3mr_atto_get_sas_addr(struct mpi3mr_ioc *mrioc, union ATTO_SAS_ADDRESS *sas_address)
> +{
> +	struct mpi3_driver_page2 *driver_pg2 = NULL;
> +	struct ATTO_SAS_NVRAM *nvram;
> +	u16 sz;
> +	int r;
> +	__be64 addr;
> +
> +	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_DRIVER, 2);
> +	driver_pg2 = kzalloc(sz, GFP_KERNEL);
> +	if (!driver_pg2)
> +		goto out;
> +
> +	r = mpi3mr_cfg_get_driver_pg2(mrioc, driver_pg2, sz, MPI3_CONFIG_ACTION_READ_PERSISTENT);
> +	if (r)
> +		goto out;
> +
> +	nvram = (struct ATTO_SAS_NVRAM *) &driver_pg2->trigger;
> +
> +	r = mpi3mr_atto_validate_nvram(mrioc, nvram);
> +	if (r)
> +		goto out;
> +
> +	addr = *((__be64 *) nvram->sasaddr);
> +	sas_address->q = cpu_to_le64(be64_to_cpu(addr));
> +
> +out:
> +	kfree(driver_pg2);
> +	return r;
> +}
> +
> +/**
> + * mpi3mr_atto_init - Initialize the controller
> + * @mrioc: Adapter instance reference
> + *
> + * This the ATTO controller initialization routine
> + *
> + * Return: 0 on success and non-zero on failure.
> + */
> +static int mpi3mr_atto_init(struct mpi3mr_ioc *mrioc)
> +{
> +	int i, bias = 0;
> +	u16 sz;
> +	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
> +	struct mpi3_man_page5 *man_pg5 = NULL;
> +	union ATTO_SAS_ADDRESS base_address;
> +	union ATTO_SAS_ADDRESS dev_address;
> +	union ATTO_SAS_ADDRESS sas_address;
> +
> +	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_SAS_IO_UNIT, 0);
> +	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
> +	if (!sas_io_unit_pg0)
> +		goto out;
> +
> +	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out;
> +	}
> +
> +	sz = mpi3mr_cfg_get_page_size(mrioc, MPI3_CONFIG_PAGETYPE_MANUFACTURING, 5);
> +	man_pg5 = kzalloc(sz, GFP_KERNEL);
> +	if (!man_pg5)
> +		goto out;
> +
> +	if (mpi3mr_cfg_get_man_pg5(mrioc, man_pg5, sz)) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out;
> +	}
> +
> +	mpi3mr_atto_get_sas_addr(mrioc, &base_address);
> +
> +	dev_address.q = base_address.q;
> +	dev_address.b[0] += ATTO_SAS_ADDR_DEVNAME_BIAS;
> +
> +	for (i = 0; i < man_pg5->num_phys; i++) {
> +		if (sas_io_unit_pg0->phy_data[i].phy_flags &
> +			(MPI3_SASIOUNIT0_PHYFLAGS_HOST_PHY |
> +			MPI3_SASIOUNIT0_PHYFLAGS_VIRTUAL_PHY))
> +			continue;
> +
> +		sas_address.q = base_address.q;
> +		sas_address.b[0] += bias++;
> +
> +		man_pg5->phy[i].device_name = dev_address.q;
> +		man_pg5->phy[i].ioc_wwid = sas_address.q;
> +		man_pg5->phy[i].sata_wwid = sas_address.q;
> +	}
> +
> +	if (mpi3mr_cfg_set_man_pg5(mrioc, man_pg5, sz))
> +		ioc_info(mrioc, "ATTO set manufacuring page 5 failed\n");

typo manufacuring -> manufacturing

> +
> +out:
> +	kfree(sas_io_unit_pg0);
> +	kfree(man_pg5);
> +
> +	return 0;
> +}
> +
> +



Thanks
Alok

