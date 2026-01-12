Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F13876D0;
	Mon, 12 Jan 2026 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244181; cv=fail; b=FZwo7EkJ6Vju6BK1gNDiOUM2YCG0pcNnDf4VXV4Ggodpt5k+CR2wv4W2f5LSLYAT2C7M+qarSrtzNFCJLmXcgnmWMksoonNwfDeJ+tltOP8KYGF9H2F2MnvotndkGfyd6TzODyPHG6Dyb5dLmiAbfAqqGyIWynmVIZNcfV7l26s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244181; c=relaxed/simple;
	bh=5G/dmWuy+5OnWsOQtKrZyWg87ljzwG5ApkmmLScSkZU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EFaqX3+zIe2adc3HTvmIUk7Xz8PBDnJ2TvrX+sgG9VDZ9BwIpm2Bm6RiGeni8KtPTzEcqxbDgVMoBkrend1de0CLHp2ynLo4miRduvjpcgebjbfds1vDmbb4jZRym8oaM9OR4TQPiAIyCus9stTD7JX6vSYIoB91Puuewh+GAUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pDYcCtzW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sLEzl51s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pDYcCtzW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sLEzl51s"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60CFwQ41456514;
	Mon, 12 Jan 2026 18:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=shgZTXvm58MnMIWY6yN7pmExZqW/JzEnQgGsX+Vn24I=; b=
	pDYcCtzWnVuOVXhmiELBK946/LSUT36YkTlqXfkf6oFkeE0rPNyp+/ohC+zIq3Xm
	rYYMsE0vxzofFSvHFqzrwQe9Dpqgn7pm98qCZFQhoNGu82Af1Ax6RzqdIAOCBGKY
	FkYAr2gNV3qK28plts5mX0CybiCl+NctA/H5bt61uMZFgFrn1630hP/N4hC9knsc
	OSvXMaeBaLkYOKrAUqcPub4KHfNm8gLCzfkz0AFFnWuvTwIQosI74WUndA62FPTU
	/SQoUapJQPhfT/ghgjRkwR3MtYcaVqHQzAiVCr8YKwcgsty3OQ9+OeYuMgGfx6My
	/Sc0ST7AAiU02LV9HBOAhw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrr8a5hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 18:56:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60CH1Jao003899;
	Mon, 12 Jan 2026 18:56:14 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011005.outbound.protection.outlook.com [52.101.52.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd77rnep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 18:56:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1LDvafLEb5qeHCAluq1vzPnkfIeGgq436QTfpm/c9Itxs0N1Q9cW9Di44CdmtuQ+hIdz/vtDyl59w1YoVt0CMmpwBkBMEMBHSR/VqRQvyGMRC53edH5eR2EH7/CygSgUyjeJo0y2uahJTZ1Tqrl6PpLqL4HFeJZlJvxG+55YaNjlpV3wYo1LjacHpn1u1DI+4O4guzGu92chDsKKDEkoVjh/s0XsE2/9HwWrn48s6GeqOEWYx7o8QfUEviQ5hq5M6bxb5QwoYmRZxoMyyb9YK7mIabjOYcgYD4XBDZsMN97NNQP8yzJShu5oxfXD6X9NnHDZoa3tZfXCiB3cPnQYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shgZTXvm58MnMIWY6yN7pmExZqW/JzEnQgGsX+Vn24I=;
 b=tbFTyfrNfLpQBFnk1CIiAwgmZJvdlKJlYjEto65KMeVt10EW2PSqS4C/keQh+mKFoHG87tV0ZehzXoNUr4T8htEcgoGDpf1ttfKI7pIwuHjNQGDG21WKX7m7UL9mOUWtxWeafPVPUWcLVJGsTV7ivD3WrluOJswx+LXiciyNBlFdQoqaTVDlLO6CdnaK3ji7VZ/QRKG+w/aJ4/+p/ZnnGLbzIvT6kp23d/fjwkMlmr9IzlnYY9Yetw1xg52aScNJflIrjRaEFjUZ6vWfWQbKboh83EuLTO4rjmzR5FREN49Fi6NDQf96FMI5gPRUvhDTq7GkA6jC7BJWpqHQ/4SfJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shgZTXvm58MnMIWY6yN7pmExZqW/JzEnQgGsX+Vn24I=;
 b=sLEzl51szthdc19Zhwv3pKEvJkFa0YktkMXIt6QVs15kcqGA/bmjO/p7YSolJJI/r28cSOgWQ6zEgmVJZnJab13md3S+qyqraCDdOs/3Tl4Vewdnazow4VanGSb1ioJmD/UKg9/mXBl4Du2chH7OsBvoN1kH7SNWFgUSQYDTcKA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 18:56:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::4b43:8603:b9fb:695c]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::4b43:8603:b9fb:695c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 18:56:10 +0000
Message-ID: <c08f088c-2072-4105-a6fb-890f1ccf493b@oracle.com>
Date: Mon, 12 Jan 2026 12:56:10 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: target: iscsi: fix use-after-free in
 iscsit_dec_session_usage_count()
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: mlombard@bsdbackstore.eu, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20260112165352.138606-1-mlombard@redhat.com>
 <20260112165352.138606-3-mlombard@redhat.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260112165352.138606-3-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0038.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: bf3286ec-4c3c-45f4-67ba-08de520c402f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SElybHgycW5GZC9OY245QWJJNTV5WTBiQXdQWU1VeW1NdFozdklwM0FBV2RO?=
 =?utf-8?B?SzBNcUhhVGw0ZDFHZUN1YUlCWU05bjQrZG5nZkVLYnhEb3R6eE1hWTRBcTF2?=
 =?utf-8?B?N0xDWVdQa1JjQWtoSnVvNExrTkE4RXF3a3Q0SHlYa1l5TEZKOHFSOEZkOU1C?=
 =?utf-8?B?OWNadEtsV2EvQzRqbGxuRGNDVlVLeWpuWVpXaDZTMkROMHpSbk9lcUtDM0F3?=
 =?utf-8?B?TE1UUUpoL3Y3WGxEVFVnTDcxaUhpTnRvbEg5YU4wYzdyb3JlejFGVWgrTll0?=
 =?utf-8?B?ZmJPUjhENEhhdkdLK040ZlFLY1g4aVVJZTM3RzZBcnBwNUVOR21NaUtqVTRn?=
 =?utf-8?B?eUdPODJqa0NmMkJ3enBpRENrSExqS01maXhmdHZ0OW10RUIrQ1hLZU0ybXVm?=
 =?utf-8?B?akkxMDV0M0pJQVZyUU5IQzdwN0IzNjJOaVZma3BxdU9sVkdTL2laMi91a2Yz?=
 =?utf-8?B?WGZjQUE5TUtWUlhHUGhBQmxaTS9zUSs4WkF4eFhzZGQwV3NraXcwMXVNOU45?=
 =?utf-8?B?d1ZPaXg3YUtJWUllMDgxdDlycmJKZGM1RlRPVnZseURHQjc1Vy9EeWxFRFZF?=
 =?utf-8?B?MitaVTVsOEtHQ0ZPUllCdEtLdUVXWk96WUpqVXdUU3FTTEZ5ZGlReEN0d2NM?=
 =?utf-8?B?VXNpSkU0NVk2ck9VOFczTGYvMmhsUE9jRHc5NXdRbFVPRGNwdStBZ1pXMTM1?=
 =?utf-8?B?ODRiRytCcTdWN2xOU296UTFzdGdCdlFUVlpneXozWkxpSEtmR0ZRU25OMGdz?=
 =?utf-8?B?QTNPTjBNQnlwUFlZVWdJbHdQM2xXaXZCbDlIdzhRWTA3M1dWYURtTHlRd0Zo?=
 =?utf-8?B?TUxDT25WMFNtclBkdmtScDRnT1ZEWk5ycDk0WHJQWlhNYkZtTmliVWNuUGdJ?=
 =?utf-8?B?azUwUENkb3VoSEhSRHJjYkpwTm5EemFpbEVPRDVHZC9wL1VLaVh6cnFWMUJl?=
 =?utf-8?B?UjViaWJtVVhaemN4KzU2ZUgzVER0NUxsSXI3K2JYdjBIOGpjQXN3bW5NWkpT?=
 =?utf-8?B?TzJTWlJuY3FEdEllL3RwdU9hZlR3ZnQ3OEE3U2NCcDlKR3pwV2p2UXhvMnNa?=
 =?utf-8?B?bk8xN1lXK0JVTzhjcDcvajhESjhUT2VoSkJvNXVEL09KOWNpcUJsT0QrSWpp?=
 =?utf-8?B?UUpmT1RlZ0o2RWk4RFk0Q0c4Zy8vQjdxTVBqZkhMdkJrWlA5dVR3QmI0eU9O?=
 =?utf-8?B?QU1XSm9Ia2F1dXhackdqWXBsSzJDUzVTUXRBRytoWTNUN1NYVmJlQUk5U2oz?=
 =?utf-8?B?TGRsREcva3FrTWI5R1lLMnNRMzcrSHRXMENobWt6QmpOR2hRWGc2WmJyblVX?=
 =?utf-8?B?VTQ0eDlRcHdodHRxWFQwWkhjcEpxRHhTSGhZd05kaS9ObS8vMkFkaEZLajR0?=
 =?utf-8?B?eEk0dFRZNFc3dDVDK1cwUjZCVkt3a3hoK1NGaTdscGNwZ2pVWVNNODVJUFlm?=
 =?utf-8?B?VExNZGZJUWNVbTNjbjJlOTFkbHhWbFc1Ni9BVGNHRURiMFBLY0x5N3Q0UEZD?=
 =?utf-8?B?OWhXeTZRQkpNRXNETSt3NUZGK3FvZUxONDdieEQ1bnpuUWYrSWpCSzJIaXp3?=
 =?utf-8?B?NlhRdGdHNUFEZ2N1WGtnSlpSNXNwMytkZEVxRm95b2NDakxLd3dtUlBVQ2lR?=
 =?utf-8?B?V0J2L0NSemNhSHVkd25vNGhNUk5rZnhNS1hTV2sxSnllMlh2aVBVeXFiK0NC?=
 =?utf-8?B?c1ZycWR2SkNiSWZCNnFWOEdlS00yYUUzS0dBU1poMTJYSkNHQzdnNDFKV1Vi?=
 =?utf-8?B?WHdHdnNuakRYUmxROGhaeDZqRCtaRjNHaHRsRlp0SDJsRmRsNUJMM2dpK0R2?=
 =?utf-8?B?dmNoR3cxNkxSZklTNnJaNUhIVWpYVmt2ZUhGZ3NHRkw2QVFoSTV0Mjdwb2lm?=
 =?utf-8?B?MVR0NGVyQmkwK2FJYm9uYkd4SVB4UlZOTGVtcVk1OHhUY1YwNG81aUJvNTBV?=
 =?utf-8?Q?0+mDewP4H8PfJ0CYJ8shYoEHghQRtxLo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZitWMlRuSkxFeTN5NGlwMEVIWExJMTdlUlBWRm5TVnI4VDRDemh5Z2RSTUow?=
 =?utf-8?B?V3dFK2JHWnhObm02N1Y1cjFhS1Bpb3JPUHZLQUxjWEl0TTh3Um1CQ3BKalZZ?=
 =?utf-8?B?OUxNaFkra201V2t4NCsrQlJTdVNxMjc5cTkwZ3FPOWhZODhmOS9MRUV4NlRr?=
 =?utf-8?B?eWNZWFNLRFRCUlhhanN5V1cvMzh0UEFNdFBzeUZ3STAvZkF3c09DSjRzVlZy?=
 =?utf-8?B?Z2ZEbmswVmdwU1FFRVhIY25hNmtZZmRWQlE4bnFmSGh0SmZFUTJsK09xTURL?=
 =?utf-8?B?WDBHUVYyVUkwZ0dueXhPNHllaHpzUGV6UlFsYWI4M3FneG1meFJVMk91anE3?=
 =?utf-8?B?Q1V1QjY5UmltSklheCsvdHh1YjhqV1Rud09PaWhyd1IzZm1QSjZqMXd6UWtR?=
 =?utf-8?B?S1hjNUtJQWRYWUlIWGpnSVhsU0M1NmJnS3ZTSHFscEtCWkUrTlIxQldXSkhv?=
 =?utf-8?B?cURnQ1UvSm5GMEpJb3U2ZThhOUZMSVUvaFVBcXYvYm9jdjNWbVY3WTIvWG9n?=
 =?utf-8?B?a0ZGM0NwbkZjRUlETGxTd2hKR2U3RnY1bmRTVVZSaC9tOXRGOGNtL0pzeWJh?=
 =?utf-8?B?NjNEUVlOdEtvSXU0akNjRmRmdXFUVmhITE1oS0htVUV5OUY4T1RRQ1FIMDdK?=
 =?utf-8?B?aEJqV1hMRzV3ZThNM0dvbEx4TGRpY2g5ZUM3ellaTzJKTS9wZ1VBZDZwRTl0?=
 =?utf-8?B?eTEwZnZvZEVuSEt5cjEzL2FTQ3dXa2o3MVZZR0Vnby9hMURoTlpJbUgyNEM3?=
 =?utf-8?B?WmlsZEN2Nnl0UFRYaGtHNDN4NFpNSTMxSGVaRFU1Q1VOa0ptVmc0enR0TE5V?=
 =?utf-8?B?WW5YQ0U5ZzYzYm1tMlhFTkNWaStQZDVmdUtobzNqTWVpQTIzbDlsdGJYWG5J?=
 =?utf-8?B?cjVlSXNURmpOMjd3bDZVVnhMVW93UWVQa2w2dW50RVVhNTZTVzc4MUtRajRR?=
 =?utf-8?B?azk1dDF5WXBaRWtaWFpqa2F5RE1ROGprUkpTRjRMTVFQY0JBWEZrVSs1aXlW?=
 =?utf-8?B?cEZYTXlpdDQ5SldiN1V4Y0NYUWhxME1JQUJFS1V3RkRrYXRTRmdaV1NQQzI4?=
 =?utf-8?B?REcxSWI2YWhzTEZWNCs1SERRZERHYzljdlAvZ0NaTXhWdHB1SHhLM3lFWkRN?=
 =?utf-8?B?Q3d3b0hZNGxRRytFUFpaT3RRZWo0b3A2UXFOTWxyZEwwTGdHamhYMzNyYVY3?=
 =?utf-8?B?Mzc4Z2lXM2VJQzkrMENlcUU0L3VYQWhKOGZicXdRZHlmS2htVVkwa3BNN3lT?=
 =?utf-8?B?UFFzU3NSenpzR25jS3R0eExqSC9JdmdmM21BUUxzeTdGRGlUWkVEZ2M1eWhp?=
 =?utf-8?B?Z2Jla1ZwSjduNTMwK0lKSGFUUGxiSHhrc256aVRmQUVmOC9BeHhZTEp2bTFm?=
 =?utf-8?B?NmhtQnJNYnBDSlI0K2V4MnJyZjVXTmg3UExnR2hlWUFYUVlwU05VNStkQnVi?=
 =?utf-8?B?T0k4dTdxcWxCemwwdXJLTW9tR1Q3OVVzZEJOOXVucHZpdWh0UUNUVTMveDhY?=
 =?utf-8?B?ckl3T25ibGx4NzVIZkxqSysrOTRVT0Y0U0ExUzFwNTZ5bnppVGRBYm5kVHc2?=
 =?utf-8?B?b01QblVWVlhmenU3Z1BsYk4waG1TcXFnZlFzRzFPVjloanhvRU5ZR2c2cVRY?=
 =?utf-8?B?OElkUHNaNlBEUW4wdVREMlBEMWZ0aXJoWnpWOXNEcmw2YWdDRTdvQVRudkox?=
 =?utf-8?B?U3BGYytLaXhneGlYeFNSc1hxMVRyUjBWNExSY3lQWWxZbGJ0RzJDUjliY1ZC?=
 =?utf-8?B?Q3o1M2ttb3VMc2ZmaCtoOGFEUUlGWmFLc1dpSG9sdnZ0dmZCdnNrcm9DU1lh?=
 =?utf-8?B?Q3B6V2JQT2xhaDZ5QjhxOTI2bm1mN1Z5aTRVVE1aaHlnc2hYdTVLNGY0U0Jy?=
 =?utf-8?B?N1RkUGxMQ1krenB0OUt2TEhMUEk3WjR0dFRKdUFNd1E0bmxGRVlSSmNMVER2?=
 =?utf-8?B?MFNoNk9scTY3bzNxbFRGMmZaTzJFOHpSQUZHR3JZalZTMWUrdDJ5YmJidVYv?=
 =?utf-8?B?NkJGRkQwNDlLeDZDSG1lbHB5cFRNK0RsNDZZc0FPZDZHOExkbFVWTWZrNVZk?=
 =?utf-8?B?eGc3aE9iMFNkMkxnREpGdWFaZVZma1dyditHb21sMmpkQXF4UkJDZVJGdE5u?=
 =?utf-8?B?Y3V5RHBRRUVzMFRUUzJvbzJ3M0kxdjB6Q21pZTQwN2NRaUFlYUp5UURLTnFw?=
 =?utf-8?B?Q0F4d3pOeW1jT2k0UVFFMHFHcm1WRXZySjVwc3M1WkhRUnJXaXV5OXpRMU9q?=
 =?utf-8?B?V010RkFDVlJnRFhSQW42NjNHcXpYWHVBUkc5alg2WFYwWFBzVXk0YlZJUEpl?=
 =?utf-8?B?NTcwTmxMbHorenEzWHh3OGlqSHkzZ0o4SEZEV2xCbnQwY25qV1NmZzhtNVk3?=
 =?utf-8?Q?AH0/uv25vlbUQDrM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6xvrjzEvluRCyCz8PLOqe6GuPR1D0uFQp8/7JFYK7Zxpes9xJCv0C7gxHDy/AM8Fp5TzEX8tNAq2/5Ff2QeM3iEmsCY0TnJHTP93FtLK98wygCmjPcGJRyr+lWFl7k2OjMdI0LTA448hylfJuTCvW566v2ReVpyGRpBWMpgOtjZBHIw23tYOTRkzwsgYCAfCBaK5MHuRp00XleWaPwHUpsgCKjRSMgsHJBxkm5IAo4RZo1y7EJkmiUz6vH60i8ZzH6g31hmQVx6gCrZmOk7eZyKSjXTvG3TwULdo4LGGC09LWJ9WGK8C1DvgjUclOs8j/LelK3WMYpT5o5aaMlzJAAdjLp7G/gi7QMyRjjO5ulg/h2ALo/ovEJCuyTA0EMzpgwk1NGZqb7mlR4mHh93sEE7UfGfl14mKTpiDavUSlI5ILmZlzhWhjDNNXNci/8D1IZ7xiTZ47saSY/sr9LoXb16x8gDdB9nTrWcLfo9pXQJYkfRU4lv1oMB+/fXOcexYFwvgjFYpWwl5XB5CKYHTfYk99KRVm6HFsa5lYL0XSPYzvXcBekMRt9A7t4mYA8/Q0ncCbvA/jqMas2zFA+drd+Pn/d8/Uhf4BL25doyCRMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf3286ec-4c3c-45f4-67ba-08de520c402f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 18:56:10.5429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1mzM4xOPjreptpkumC76KnCxZCKimvbmdASvBNIsX4oWUXgfMiXpwpWa78UngS2E1M8bb5NPPpyLA2GgSJ5L4MXT89SKyy417K/t+KTjzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_05,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120156
X-Proofpoint-ORIG-GUID: Gtoc6BKIOodzJ0yOAWHotAKFQS7c59Ag
X-Proofpoint-GUID: Gtoc6BKIOodzJ0yOAWHotAKFQS7c59Ag
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDE1NyBTYWx0ZWRfX6r0rSUrtp791
 6Ox0EY1tRx21zSLl37no8+SGF6CO2koE8PWv7rwrAo9IkGIgl70u8Uvxb/JQ3Xt7sjuD7EMeIG6
 BQa/V+ajBc793BAqBigix8CKRanu1zlsLkMzjmXMPIUD3cGojKZNwDs9zVsO3nsg6T5HB0d6b1m
 Y9opRkH8E2fmbtfasDUAbQCMj2Mkt6J5HR3KXpKPCPjVnweLi4o54NzLdpS/Oz5FwoBrxeL9enT
 uWm5YSWgLXcUiEUTkhDMnSmeTgbIk1mu0LVCvqIgqMYRqwS6BSfjTksK1YBXTQuGjoNI9c1mskO
 zR4X57T6QozSESNy2xyBmJ2snAv0tlQBhWBayjiruKwMf2fT9EBfhAbBvan5TwL5Th4n8EVWe6F
 CXesg5f/3VdmxH1O5KVHiCdfMLT0qCbvxYFRQpCDDZU+tmJFwKWIS+Mvf1S8R+r0kHWLvojolct
 opj75MnKW2WU3GSCF4Q==
X-Authority-Analysis: v=2.4 cv=QIllhwLL c=1 sm=1 tr=0 ts=696543cf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=0SJ9h91oYuMxHN3ggCYA:9 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10

On 1/12/26 10:53 AM, Maurizio Lombardi wrote:
> In iscsit_dec_session_usage_count(), the function calls complete() while
> holding the sess->session_usage_lock. Similar to the connection usage
> count logic, the waiter signaled by complete() (e.g., in the session
> release path) may wake up and free the iscsit_session
> structure immediately.
> 
> This creates a race condition where the current thread may attempt to
> execute spin_unlock_bh() on a session structure that has already been
> deallocated, resulting in a KASAN slab-use-after-free.
> 
> To resolve this, release the session_usage_lock before calling complete()
> to ensure all dereferences of the sess pointer are finished before the
> waiter is allowed to proceed with deallocation.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> Reported-by: Zhaojuan Guo <zguo@redhat.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
