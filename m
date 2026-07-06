Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F137998A;
	Mon,  6 Jul 2026 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347191; cv=fail; b=l06C4uHt0cAxjry//ZKMHVH4OGa1gaGNbZh1r2cnNrktRhuKb/lY+RiMbRt1GDZ5u3y6HMIvN0lSZfeVgs8qood/nLB7pGTGz1sDl5h+ZBj991SOhZ6S2c2lAbQQ3BD0144RT/PUHQHaeHkIE1Gh5LKzcnYbl9iCMj2gNjiX7ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347191; c=relaxed/simple;
	bh=kqPEIe32vBke57Ow6NtfvFb1iAoVsdVeLnVebaKSxPA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QP8tzP9ILC+SaGyd6QeTcggXYfDRyqEQ94Im+HC8SryikUtEhIaaKUUoArfo9bWekfpmjaqq1Q3j788eGcqnb51m7Jv4XDRqVIUVQYZem8szqqddgP20YfExxfv3KwSPA5zOVMMOUBz1U2bPsSvGrBY4vEYMmclCsR+MM3F50WE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H4ncgdbm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GhHidVPG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H4ncgdbm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GhHidVPG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6660U25p1418018;
	Mon, 6 Jul 2026 14:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LoA3ZPqwIL0AGan3BmeM4BdYX0TuP19bYaJ90uFUo8c=; b=
	H4ncgdbmWmao8FWJARt6OPTG9eVlKIs107xTpnfZ866ypTirgxWwXYs7r/YfSL/P
	iH41yZkro400XFqP1snRWDM23R/mwOzJond9x1uTCDPW0XeUCRR1gluINIR0Y6ES
	hi+E2cZ4whiBmE3f2t5BZxBcaHlp4V4kXz6kMZFx4HpuPYlISQiUnmj+3jrpUVqk
	UPLO/pEmjTDqO4C7LM5DkCviTeW8LgfLI1f6lB1xjHupSducw4ZEmXD02OuVJGZ+
	Q5DkuX6shsNj6yTXrHwk2Mug+JDNRI4RQJBxyNK5hLScKEehqyTr7UX+jE0X1GVW
	8zrPZPpHZhxepnKjl8op6A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t7ckrdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:13:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666E87ex014519;
	Mon, 6 Jul 2026 14:13:07 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmc5g5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:13:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3x+FUqF56Vj8fkKYgdnXKZIfwYUxB/mXbxmDiNJ4NQAtHYj0lpHQ6evosx5moUf2HTvCvLSe9lC1QoGf2AxYQvH6uEkbdlVQsOuCU9D9CORrBrsRmTtsEHOtD8RajkI0D7yJiuJuNG76zhinbKSeVfO48UdfHnR2DS8ypZWEqXvPlT6mTlJCD0XGFFPx6TlxmatELAZy12VfC48+tpsOz/iD7TDhKOqfgBWZWuyDEWwQNXzv82GKvbXtguOoRucyA7dlZAFSlpLBh268sYAS6FHSArfHYwwOd5EDDvOAS/SMuQ3Ot4lS9nkGluVT76Ca/ii5f1fOfDWeV1Oq2hOLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LoA3ZPqwIL0AGan3BmeM4BdYX0TuP19bYaJ90uFUo8c=;
 b=k0BVYyKbefLd5ybgwhspNd5gPfU2BlnbIriJMTkWSxd0ZXhf0J1RmzaIQLgfjGjzT1in7ONIQE+uZke+qh6J+vbcz3ABQlhlqlO3gROh9Y6Td3J+1Enb2/LmQ1lOSdg7/N/mixQyMit8VGrgpdVcIYQ2FTUwbSBmdtCdtHOjLh/xSMZtIsH73kfP1LM6BK7MdCmVWXbSFt+epgg5Sqoweb0LUe7zB6Gd32CLzwPSRYt8MQ47KObM1E5iOVPI8M9gWcQYm1k44l1wLtEVOn371TanC+8clbTwS8kLJ4SGzEp5Jgap/QsGjHuCEhSdomp38CMQvaC6CSeaiq1v6rRtbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoA3ZPqwIL0AGan3BmeM4BdYX0TuP19bYaJ90uFUo8c=;
 b=GhHidVPGV1oBh5T/hd37APSBsqQRLOq5BfFAkDVZ4v5iIDScPmHebC2Vw6cKcqTaQ+Ji06CfbJuMVUbvMzVh2p5orDVhf9dzXnCaUZPuPFwbGEyTnEv4S089zsf1SVst65MSvkWB1ghNRf4hsU0VItWc7JsI5+9KIeZTskOVA2o=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH4PR10MB8100.namprd10.prod.outlook.com (2603:10b6:610:23b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Mon, 6 Jul
 2026 14:13:02 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:13:02 +0000
Message-ID: <b76cf79b-b1d0-47ef-ad33-0b544d5e2f68@oracle.com>
Date: Mon, 6 Jul 2026 15:12:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/13] libmultipath: Add PR support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-10-john.g.garry@oracle.com>
 <20260703104815.96E011F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703104815.96E011F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0304.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::21) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH4PR10MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: 07a78bb5-d5fe-47ee-587b-08dedb68b0cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	owVpk/ZEFnrQBfGK7zwZyLHP0iQY+Wyy/dwsSEdEvWqVV3/8Rj8D7tGo3tHUXoJ3LS4hGoVqYl0lkmBdIZ4Pruf+1ba7pUCo61wa41lzSpZNQ7GTRvRiYAJG710Vfls8cpITxhjcuzyRtEgTOKJGwF6JMPxEgrT2UfN8Jg+rQ89vHvEJa89IlQWBhvd1Bn6L8zI6KVdbRKl/G8F7v7pXk8Qz7DGR7QNGF1jbOmABCLImX33z8LUo35wGyn4W2mq/K+HAKS8Laie1so1tfyDegFVTQrzLJ9CtHyoXYdAo1vbVjWsZKh5wey/iUiNBDAgUiHuzCQTVf/K2acSpMO1xSC/alG7JdBJWeEgmJjdopR0BrxzPtCC42S8nw/OZBCZL1s4kMyHBVaNR7QJoP1X/h+212OiaFgOsEk8pxejesD9sBg6y+qJ7nn+2s/0iIYgDokxTD2tdHFGEUI/x9y9OozCp+a6W1FFJ15qUVsy/CqPkslqIKbhNrfpCHHr8snh1NHWE5zoptQCSXH2cRcCZNFsddsiijx9Ys79U5s7Z+72/3GvRTb2MYiR0Zfs5QYrUF/UY0oFKlgJR8MX15+fsNRuRgo4KnGyUOA6cSww4GdEX7GMsoxE8u4V/TNggoMzzUKnsmOcNcsmZJ5etlMxWOxGdjfKEOUvEMT7ps0JubkA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmNWcmlEWmRobStjNWE5ZG5xNktCYzE2R2ZrZGdXZFFhdjZvNkl1Q0FQQnlm?=
 =?utf-8?B?aFk3R1VKcVQ0d25IY1VBUUYwKzlUdmJUcjdmaVJqemRNVk9uazBqRTlnTlI2?=
 =?utf-8?B?cWpUeTFONFprdmR0QkdFKzY3QS9lWENyS25ua1V4RVVISkwwMzBJWHVsV3hO?=
 =?utf-8?B?ZUJqMm1uQ3NYenVDT2duRFVVUW5PNVVkbmlaSktmZS9LSnJFbXZ1M2U3Zkk4?=
 =?utf-8?B?M0NuUGN5eGkzTFdmWnRHUmtmUVZlNDErb1FCUVBhUVR5dWZkSm0rRm12Z1Np?=
 =?utf-8?B?MkE4aHpOQVBKSzFMemJweFkreWJqYVFxcTVRenNoMnJ3S0g4S0tpV0wrWlU3?=
 =?utf-8?B?STdBZnJrZlhmQkxxeTdodXd6RzU2QWZiUmJVOTVCbEFoR1V6V2d3aFFzN2lr?=
 =?utf-8?B?eXZ3UWtjVzVwWURCQnhDa2V4OUxoNGs4Ym1mZCs3WVUyMVIxbUwxUzJ6Nm9L?=
 =?utf-8?B?TVFJdGpUUHNiREh3N3h2UFpoZFhSRzk1VkV5dVc4NmtZamVBdlJmalNadnhV?=
 =?utf-8?B?UFhDeExZRjVlbjBrNVBQL0hJK2huRzJKUzZiNHdJMGk3Rk9TRzBYWE9nbHRv?=
 =?utf-8?B?Z1BRaFB4RDdaYnRGd1JPZ0F5RkZNLzhHdlZOMDJhbHR3bFVETkdOTnMzVkQ3?=
 =?utf-8?B?WXNjMFJpQm5QSXNINW9LMm9MNmFZbG1ldDBlcUtsb0xGRVgxWXJ1L1Y5V2dM?=
 =?utf-8?B?Y3ZxUlNEVmxNaFFCSVRaVy8xU3F2ODRLYnVmZ0wrV3JyOEhYeDdPQVFyWXpS?=
 =?utf-8?B?UVdNcm9kemhPc2twTnZqS0NnMm81ZEFBcGkrWXNPZ0hqM0ZKUWoxUVdUWVA1?=
 =?utf-8?B?NEU2dWRNRld3dGk2c2p1OFI2UWh4VHBwbFprcGN3QmI2MEllYmszdjVXSWF4?=
 =?utf-8?B?bGRJQlVxNTBjZFlmVjZXWXVXOXNLTFVVeWdHUGdEbmd6TGRkNFcySTQ2UWdX?=
 =?utf-8?B?Yzl5NUVkNW1PZGxyR0cwVGVEWHFxNlpFUEhzRmFYU2g0ZVNlWVRLSVRGMXN1?=
 =?utf-8?B?bnpHdlh5by94TDlRTEJ1Y05kTGtIbG9KUGJPa29WVDJrTHBPeE8wVW5YZHIy?=
 =?utf-8?B?cGxKYjZ3NlJQWTVLc2NqbXFYNitiQjNLQm53QUREU1B4WW5GYVpQbmVUUnA5?=
 =?utf-8?B?YjdpV2lCSGFhR1d2VTh4OEdBdGlqYmp4RkcyU0lYNEp6aTcycHFhR3FBNW14?=
 =?utf-8?B?a3VlR29OOEZITDhyOVJUeWZrd2hQWWUrZmtvMG54L3RBMDlDdHp1ZTRSSmJM?=
 =?utf-8?B?ejhkeE9ZUDg1UzVaTDZHRG9rSG5KdmEyeEZTMzcwaG9zZ2pPWlU1UnUzNTR5?=
 =?utf-8?B?Qlh1R21JeGZha1JkZEZzVlZ0QnpKeXRmbk9veW1vWjd1cEVBOEhyYk1ibUt2?=
 =?utf-8?B?SmNSdDd5QTUvdEl2WXVpTXloMTQyZTlJeWhDa3RlaE5rQVpVKzA5YTJ3ekxp?=
 =?utf-8?B?VklnOEZoUE5YaE9oU25hRis5bHVBOGc2RjJnVUwycnk3OGJZMFRVUlZiTGtk?=
 =?utf-8?B?TDBqa1pZTEJkMW9zUHQ0cEdiMzNNMWo2WkozQ0hrd0tibXljWnVuT2krUUNm?=
 =?utf-8?B?ZnFmOTdFQ2pEdktIQi9IWVBnWmJqbXVJOUdwY2dIeTRLaVlTakhpUDd4Sy9m?=
 =?utf-8?B?QTV1T1BJZXRSY2pmMXNpVlR6TE84WVRwRzdibTNBV243aExMdVIrc1AvNjVr?=
 =?utf-8?B?QmQvTGFRMFJCSnh0Q0hqMEJuRUNYRXhLVE80SkhyUEs0cWd4U2diR1BTdVFC?=
 =?utf-8?B?UGVuUU5mTmdWQndzZ1RuWmc4VGM0aUY5azlCYVI5NUtiYmlHV29yQnhIL3pr?=
 =?utf-8?B?RWd5QTV4K3VjR0I2eFU4MXFLVTJHd1pSNHZPYm13aVBRTE1VMktOSHdrQ0gw?=
 =?utf-8?B?dlNtMmVkMXhaTStacXNxWHFzNVJPVDN0MzhOcjdpamdZbXlvWklsVzYzeEFi?=
 =?utf-8?B?anlCTHFhV1BYb1ZGZUg5ZGpCY3BSbU41bHBCRGlsV1BZa1pXbzlPYmhTT094?=
 =?utf-8?B?VGtiendxeFhTK2kwSWRmbnNsY1BCRDZKbm1tTjRzMW9WWkhoL2NOMzd4TmlM?=
 =?utf-8?B?d1FiVGJwaGFkNTNvZE1USi9aOXIvNTlMajQvSmcxWURZYzUrc1M3c091OHAr?=
 =?utf-8?B?U1ZDbnZuWUVESTdsOWVYaXByMGtwcDFrdlZnNE1ucEdSNmU3S29vU09ScVpD?=
 =?utf-8?B?LzRzRzE5WTRkT3lSZ0h3ZC9maUdXZmRGOVIxZEYvb3hMdVJBQUF3WTBoaStz?=
 =?utf-8?B?UTJDM3lueHJRRHYvby9tWlRsUFMxaEU2YXdOc2J3V29vT2tkV2Z3d0xVQTJ4?=
 =?utf-8?B?clZhR0F4dTl5M2JvWDdLc1V4RWtQNG9ZNnlDdVBYdG83eGN6QUtIUkxHUkdX?=
 =?utf-8?Q?YsvAOPvi76E/8qIc=3D?=
X-Exchange-RoutingPolicyChecked:
	FP12eDm4QjUtMpbEDWGvA5L3TTKQHLrfrVq2xOvvMZZtlGMOfloQHgDn5KCAzvWUHKzsdv7TYlXrnkytVt0zP/jy7KYKwcf+d0h54nNXveKRhLybAXPB7cfR1cTYfpWX/sIfnEIW+w0zIQw5sPmXRnTOs+6apJOP5odjRdXsKA1TnHlOBVbq06BYtyQH20ya8zU1dZYT4t2QMO6HlMInGTGOnZlhn5lh+RzQXNBsFunQpxfIVWBNzlwAfoSTz6KS0N5d6cd+yKPuE5ldWiJeHw9jZzthN3/PSzj4PODE+VIYUBq9vF5xhLpUdd84QiVObtyrylsRhAODWHH1N6c9Cw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0+0JnnySLX49SqoJYUvEjhGDVM9YGTaX66vg4qgeOZXJJ7R0wIHI5AK9pIuyhyroslA8kxRBvSIJ5naPMAzzo7yx8dkup5132s6ay1/jesj1tq0lcz20941OCQC0puYeZuOfGN9+fhhnhIr1OrNO6PxhfxUocjBxYp8BMhkoxqJWR+j7d/ATBlYtwEWeIQHf/dS4rV2yNuQ7vhtaxuBODZ/FOkkRowrtJrb9jHStRhhr5B1ogCyqIaff5fHKqVLuF0K0j2lkYhnmLNs45k+2tgA09+jr9+XEFQOjnr7nHGNs+0ghoFPgw7fQCQh55flT7dF46e9hil/wijFLfa5TW6EpnTpd4p8wtkjaL2qOzlHbDTEdXdYbkeOw+tw5gcrMskggVojb/jh/FhJ6awISgNk/Pxz8TYPb+ygRpzHP2u90caxmhNyCddxadI0WtnEwztkxvU7R5uBU9I+keP8ebSdG7k7V8eNt4fgpcayGpATZaxdHMJypp2c+6dRVb3LsAgyUhFNVidmPh/Tm0h/DqZTuTop3s616JQlwcpN45DBIcrT+kgEdTuj9MGBqE1/Skn4qIO4g6bjvlx0h4sy14Nh9BOLxNXcKIUKS2isn2t8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a78bb5-d5fe-47ee-587b-08dedb68b0cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:13:02.3531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EM6kV2FEVieItrVZ/eaNYTUoYkzHiW+ItVcxr5IM4BX6337FWKBrFR3QoUF0S0vfIKHzcp7BavXEr7xZP95HvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607060144
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0NSBTYWx0ZWRfX52BIVCN2cGZT
 0bvu3PmnRVP0aKCu1P0V8n0Tr12yj2T23Ls2cLwY3U/yEg0pLjGpYw74QGXvz8G1Rrghh/Q82id
 TZTHGpZQOqdg1bHUWYF4tRsqjrETzOLcjCdM/v4PJz/FAmMjplv9w6eLqrREJoeadEJpVraoqO1
 fIEKBpc3BuRuczl2zkz3EknNisFxTU/Y8UgBXhBEv8+AHJ7ZNLn+6hLmBaERIARsQUBaLnmIzN4
 Ktdw7QSUxF3RSrnrHs7E4uWxjr+EHSr4sEZnDtfIMuwqh0AjIeC9rrm73lhNQ41JWFqDOMsX7r0
 e3Yq0EpEbYTGgMqNtld5V024hXlYv+RehYQ++RFlm8PcbNgKEmbHGCf4xnZDxKfrA+WLEsnIivW
 OwmRViHjvLwOyvIWyehPRQc272hhQ23Erjn/rVKGaubF9tXKRknrX2tSeCtKKXzaOPf8NJQngpZ
 1U+RM7TvzS96cKyiULA==
X-Authority-Analysis: v=2.4 cv=P+QKQCAu c=1 sm=1 tr=0 ts=6a4bb7f4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=knGeU7AHHoaSzoMHiuoA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: SkB8BaRMG33zKGuM9Tu6lrornt-kqZ0E
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0NSBTYWx0ZWRfX+B9/x7Ow5G0M
 xMEk/uaWEM5kWC7bG+CpIE8xTHk6AbzHqmEDyjLIvrYMhLRdze/cZzZ4cxSddQQyx+Eu7XgFeaN
 fGW5StPQbij9I0sxPwkbzg+/PJhaDYWX7N6wWHBUye9OBOtWdTyL
X-Proofpoint-ORIG-GUID: SkB8BaRMG33zKGuM9Tu6lrornt-kqZ0E

On 03/07/2026 11:48, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Calling Persistent Reservation (PR) operations on a multipath partition causes a NULL pointer dereference.
> --
> 
> commit ed0ad48ae1e1adac4c8ee8809fa3bba6ef9f4ac5
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add PR support
> 
> Add support for persistent reservations.
> 
> Effectively all that is done here is that a multipath version of pr_ops is
> created which calls into the bdev fops callback for the mpath_device
> selected.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 4945f2d847fbf..cec7047ce7b9b 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -491,11 +491,193 @@ static void mpath_bdev_release(struct gendisk *disk)
>>   	mpath_put_head(mpath_head);
>>   }
>>   
>> +static int mpath_pr_register(struct block_device *bdev, u64 old_key,
>> +			u64 new_key, unsigned int flags)
>> +{
>> +	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, ret = -EWOULDBLOCK;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
> 
> [Severity: Critical]
> Will this cause a NULL pointer dereference if the persistent reservation
> operation is called on a partition?
> 
> If the target_core_iblock backend is configured for PR passthrough on a
> partition of a multipath device,

PR ops are rejected for partitions, but I can still use 
mpath_gendisk_to_head() which is better

> bdev will be the partition's block_device.
> Because dev_set_drvdata() is only called for the base disk's device,
> dev_get_drvdata(&bdev->bd_device) will return NULL for partition devices.
> 
> Other functions in this file, like mpath_bdev_ioctl(), seem to handle this by
> resolving the disk first using mpath_gendisk_to_head(bdev->bd_disk). Should
> the PR callbacks do the same?
> 
> [ ... ]
> 
>> +static int mpath_pr_reserve(struct block_device *bdev, u64 key,
>> +		enum pr_type type, unsigned flags)
>> +{
>> +	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, ret = -EWOULDBLOCK;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
> 
> [Severity: Critical]
> The same NULL pointer dereference risk applies here for partition devices, as
> well as to mpath_pr_release(), mpath_pr_preempt(), mpath_pr_clear(),
> mpath_pr_read_keys(), and mpath_pr_read_reservation() introduced below.
> 
> [ ... ]
> 

