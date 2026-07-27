Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4655136B902;
	Mon, 27 Jul 2026 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165666; cv=fail; b=n9og1c0FisRlF++uCLdKRsPIyU6QpnDV4OHBYFbjpAAVzvU5OYpZ2//tKA5lSkiU6s+XsnAkLmxkFKZMswNsEwvKwuLVKu17ULsEVVPUJxXOgV4mK7EYJ0/aFEDq70JXMd2ju5NfI2khiLu217uhup2jUEjxt1Lzces3DoJ9RoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165666; c=relaxed/simple;
	bh=lnc3qVhSyoZcdlUdmlqwpmVA2/nOusOFUcOdQqs6l8o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lfkt9guFU+Lan/KF4Iqw3CTpCWU3Oc3BdiqGZJb+Qpp5vzs2aPGJ9MP0F5Av8/WFMZHHJ63R19TQKr0UhQfBUktnI7G96IrlaGmxMsazqli1EbPU/c3a8NtD6XId56I0FmoNVXYtTdhBcN4x6Y2JQe8/2SxkwGL3bQMtpnaNKSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NTIi6oJO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZSlXIvGn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NTIi6oJO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZSlXIvGn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66REtiT52340210;
	Mon, 27 Jul 2026 15:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DjzkfiDLyRIlTcuWhEHith7b+wJWpP2s4NafLHYDk9w=; b=
	NTIi6oJOhSHfrl7jbJTMkkcZBFq88TDYZQF1L4qqZ+ssTRbvVs9P6XaNe/yx2J07
	fJgjhpBqpQ3+mYTRdiRXWXmQt+2HOwzpj4y9EaZmGPm3wwNEQv+PGlNS0wBRmPjf
	cn+y1V/Sja+6B42BZf0OZNJC2LI3MvWdOLUtUGFFdmIQY9di0AxYkjy+255coPIt
	98hBhNEOeQJdJpL0ScyvvwkesJXo4TRyUyzsKxnr+5RCsMAYC6AuY0Ab/4GSRjBX
	dx3jueiaMrLLRSVfCGu+jbWZTNA3HiMerA1USqFFJoQyGHBlUJK+wJheq6VbC/Bk
	ijelNv1kMeKBSHWL1Sg+Qw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym210w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:21:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFKAab019816;
	Mon, 27 Jul 2026 15:21:02 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85tqc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 15:21:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qM+ceXCTUA5A4nxZhwD5wi47nGRjmH6axoXWLbAkG3eeWLR1T2nrj4LRRzKBE3dOfUR8agX7N9CuV/tkTDxRM+SDI9EbGNwhGfgxEM4/HRCoK4vgGA3XxeDCwULyfdheuzZWoKoHbjj3c2yhiNWQLvHioAdTISORrNJ7uSNtBSLVLXK3GVq0aWS5MzQEONDzsznnUgbsT+auKKFKgh3cI/QuSiIhhuUzQ49inP9SVRASJFBXErO2cpzJgJj+R9uH7Gvo0C2jBZgjCQMd/ABw3fxTA5mKRLbOJNtGXAM3vcNz4OIoMXA9v6oUOdbNAcn8A8NcwTfPr7455Z2KAJ1lzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjzkfiDLyRIlTcuWhEHith7b+wJWpP2s4NafLHYDk9w=;
 b=YY6oPbETnbinDHgIlfYqjsr+tzMKY9P2BeLt/n/mZ55B/In4wlp0ela0VMUESnM1XBE07UykK67RXxWD5a5buzG7bc0/2YSRiVFBmejAo85ZL3XRhPaJSaF309r7bhL4LR8j8Y7G69qXhVK5GXjTWCV4Qh30WPdqkpc0L9TYegCgGegKOq3vFmutC0KJpaGTAY+AIUwmdqooj8Y39Z1rFtIm8O0wZAbs9EIvRi9IRG3gh1Gx3EpQgHMm5Yblfvy4/5JEgxQoUpZGSyrWuQYmVZqHelEpaBKhvr6GjSHS6czFlTN79CFfggov+8ngzB3jtGeJ9pEL+mS1ItgV6XM/2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjzkfiDLyRIlTcuWhEHith7b+wJWpP2s4NafLHYDk9w=;
 b=ZSlXIvGnnWXhgHail/EGhT9w7Y+CTxcs3luPB3TXxHHAFF6DYZyNzvvSmpmAa/x3zUwpXa2MV+N48/UZZrvnXPd0A7UyvFVmQwvLY1sJyYgZrN3ugKr0RbWGyrdIy8WShY7YmWyM1A+sDaGCmxI8BbyYi6xiSnfyR04qk/3x3nk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM6PR10MB4331.namprd10.prod.outlook.com (2603:10b6:5:222::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 15:20:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 15:20:59 +0000
Message-ID: <362edeb3-20be-415d-8719-163cfcee99fb@oracle.com>
Date: Mon, 27 Jul 2026 16:20:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/27] libmultipath: Add path selection support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-4-john.g.garry@oracle.com>
 <20260727150304.A28121F00A3E@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150304.A28121F00A3E@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0032.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM6PR10MB4331:EE_
X-MS-Office365-Filtering-Correlation-Id: a10c68df-e91e-4387-e856-08deebf2a9a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|6133799003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	toYrQlg7fetuWpu+0xJgXWi0d0SczR4foSzG006+YqUEYKnnK1dTtRr8qjU6SqPg/hQAWspi1Hg+0twTBudzdkUkrp6hb5L+tXd7ijiKxD4wntc2f0WdkmaSHmiZbuwfm2sIid63tgstXnyRTeQokeJ6v/bgEQJ+Fk6tL0NMN+xXAfuUyEr1l9UAvcF9x3vUo9C4pGnBGYFEJDlm8M24tSd+MXZ9vaNGq2aPzbjrw4p+adR9HCZIPb7ttUVWfr/Jz++W1BZnDfO7LXDXaMkCFDP3vKlVcu/LRhab70C0WyO9XwiJoE62EQbb6rXReLn/ZxGm+VqOwVTRuQF3ED3rIeRcgwkFh8Kq02pcshqx4h+tHqeDe0gy5y1iYrbp1mPpyN2KHLb3HBiUh9UMFe4895XMMjUlhK3sBPloff2/4p6ymzVg69EdbOcFvGbupbxh7fdtV7vfXjkQQ7WeZNlhSpUgis9IBK370Sj2RLM/sxl8/eCN+G4DihBGzKwyoTKN55yrMAgI5AXWQktinRY+ii7tQKiljPmHqObihgMy7XpVGGrbomOUICmJVb8gGPzOPrS4pEElfyOEAK43MeA73nfOTHxVSY23vwA3gNslGWHo679+RsDfawkHniKMO5QvbM8zPNXnB1SwBcyQb4PFwrNSnyNdqUCpf2vQGzWSrpU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(6133799003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzFHOXFxN1h0ZlcwbHR2LzFVZHlQaVJtRFJjTUpzaXo5RlVPTVVLQXc4bFRL?=
 =?utf-8?B?Rkp6TllhOXA2dVp4RkdZWEtFUmlCSXQ3MzJHQ3E1cXo4V0dBbkJmaXNxTHZP?=
 =?utf-8?B?K1o3MUk2MFFXOXN1M3h5T1hhNnVwQXFONWRneGRNZGNkS0wrbndHSjNnVTgz?=
 =?utf-8?B?dEx5U3o2QkNDODNtQkM2eFVDbW5rbUJIdVpYZlUxWWVaWkxVdHN1ZmFHOGxT?=
 =?utf-8?B?SGIzd2RxdlRqOWFwYVFIQ1JINkMwL1hBa0p3Z3M3R3Jjb3pHUE52NEllNEpM?=
 =?utf-8?B?a3lhMWdOMEY1UFlFRmdDVVNaZEt3bWp1NFo2bXNFMUZ2TERoK0NYZnM5b1Qz?=
 =?utf-8?B?MTFTa2VZZEZ0RWJWeUtlZlFYS21aT3ovU2QrWFZ3VDdKVjFIRXZUMmN5ZTFh?=
 =?utf-8?B?ZHluN0tOdlhNcTcxOTRodjd5a1Y1cU1GRkpZNHpVTXBGRTBkbzZYdlhReXVl?=
 =?utf-8?B?Z0Fjekl1VzRhOC8yQjlsSWpLQ0xQTjVkWFA0R2U0SXhhSVQ3Vis4cG5kVUZh?=
 =?utf-8?B?NzdRRXEvN0F5RkRKRTZ1VWZIbHdDSlhQTzhLTVN1Z2E4M29RWjdUc1Nya2pQ?=
 =?utf-8?B?Si80TWFYS2lzRmpmUzNINlc1SSsyTzhqTkNpRU16QXVmRW9ueWs0d1k5bTZu?=
 =?utf-8?B?U0ZteGlITFVDS1NKWE9KMjhPM3ZnK0cwV3IwOGRadjBSTkFHZFRUd0Y4bVFY?=
 =?utf-8?B?NVU3M0k2QmtNV00zYjdYeWl5ZDJMaysrR1hxRExuTjkrcjVDbEN1SHZBSnpi?=
 =?utf-8?B?amNrZUdpK21hVVFzRDdpK0x4RU1UKzRhcmh6d0pxRG5vMkh5VGRCMVFxV1lm?=
 =?utf-8?B?SHl2ZDlabDdubCtPbnMvOUdkVUk5UllCZE9aRjdIVWlUTmRrMnlCTERKVHZJ?=
 =?utf-8?B?S1VCU292R3V3YTVSbFA0ZXF5cGhOWVdCMWtFaE5XTGRJVWcwUnZSbklLS1hl?=
 =?utf-8?B?YUtlYUdqYUk1NXNUekxEUHllYUVuSXpYOVVmckJteGxsM3lyQnZLMjdmdzZ3?=
 =?utf-8?B?NnVhZE1GTDJDOGs3aEtHaHYxN0U3MUVHYWpWNlFBU0tUbUpSRjNOSGl1R0lL?=
 =?utf-8?B?Y3hQWGxKUjMzWFVOOXlScXU3d0dHdVhnWmFsN25xV3BWMGtCY2w1SlozTVVz?=
 =?utf-8?B?YlVhbG1VVkxxYk1OMExTdmpUdUt3S1ZkVW9Jak1Lb3ZqVTZteE9HakhQaU0z?=
 =?utf-8?B?akpCcU12SDV4MENFMWR6NWwyZUZxdmlzdU1Hblk5RjBTMzVFVExScEZTWEEw?=
 =?utf-8?B?UFBEMitJeHJZc2p4blNsUW8rSEVoWW1oSTI0SG9ick9tOE04N2daczRzYUtB?=
 =?utf-8?B?dWoyWmpYOWZBeUMyT05FV2huRzJ6a21mZEU3aGVWZUFVUG5TWkhmdG9Nci9r?=
 =?utf-8?B?SzhiNUdncnh0NHAvaWpLWnhYODJBek1QaTJybDNrWnFnSCtjNk55cWxOM0I5?=
 =?utf-8?B?T1pQOWwxS25ublRZWmtxS0orNFVWaVBSSDd1TGdqVTl6NVVnZHJnRC9ZRGVK?=
 =?utf-8?B?UHF6bjI1SXBrVENtZ242ZGJKUHVJWEZDM0NLeTh5TjJHWU56QWRLanVRZnpj?=
 =?utf-8?B?L1BzOGpDY0d0bmtKY3lpWTM5RjIxTFNDa0lzb2FSWm83UXZ4RGlSMCt6bm9C?=
 =?utf-8?B?OHRsajFYQVlsdXg4Smo0QzZIM01lNFVsQlpwVEFhNm8vRjVCWWRMM053dHNl?=
 =?utf-8?B?cWZVV05yT21iZXJRa3Q3N2V1MU5xNjBLSFJERkhOVU5SSEp2bXc4WUQ3bVkz?=
 =?utf-8?B?elNFQmV0Tno1akVCc1RLT0llV09PaFBLZjBQMlp2VitIZ0F6WHQyUDJzNGZ3?=
 =?utf-8?B?RnZSaUxaY002ZDdIK0E5Q25qSzVta0M2MHdBcEh3Y3ZqZjJ4M3FBUHp1eTlY?=
 =?utf-8?B?R21LZ25nT2JvOGFadEllMDBEWkJWSHdNMGtDUHk4UWU2U2dEQWdsMnNlYWVn?=
 =?utf-8?B?MnhlR0Z2ZnhOdEFnNTdselkyVGRFRGFqTHRZc1JNeEpITXJKKzBRSzNsRTha?=
 =?utf-8?B?YVpGQ2F1TVBiSnNTalBvS2I4SEFzakNiSXpva1VIZTRINzdCNjlaYUNaR3RJ?=
 =?utf-8?B?NXg3eFpNMGFWZGxhTlNYQVlkWDYwU3pYUGRKUWx6Y01FTjQ5VVFnOU5paUVz?=
 =?utf-8?B?bk9Hd1JnVmNPcXR2bDI0aTY1Qnd5eEw4ODB6enJjMWtkUXU5aCtESkF1b2Vr?=
 =?utf-8?B?WHNoQS9FRW1HZGhxZnI2N2lXNEpOYS9GY2U3SHg5dXFYL01ZMXgveHUyU0Fq?=
 =?utf-8?B?VENrR3MrRnVnYkRVVXJhbkQ5VlNJaUdxSnNPY29iTzBLMlY2cGRMb1Y2K0g0?=
 =?utf-8?B?WkRoRjR2MEttL0twODJaWWlCMWkwTmxMb3IyM0lISDRxV2dVTkN4VDNEckVq?=
 =?utf-8?Q?rb9Z4agQRAu3TBVs=3D?=
X-Exchange-RoutingPolicyChecked:
	j+8k9T5jplr2eZRWkDlB2/Gu8zD7zMXi3eTAtdJlj9Xr+uapbxB7jv2KKwH1lgMTxBzRWv6fxMLiEmyZLJ83tMPQnUeBEYZ5sWAKPiiiuvqsD7NpTNiz5n9UpULd+adbfFGUsXkGrMp+VeKJoB/DJujOUX5MltnbRwjO5IKsdZLDX+sOEqiCRyvSpc6c9xnt2xD97vg+0utUGne+oVTsjmEiEisnstfY6e0Y/TFkCSHb6LI6dookzYEH10MpAJL/Hjq1n0hb12jfvGS3epe+/krCAHBSZOQGdBy5dAhK2PyvKuR1xDcCY95PkhWd7DwWuwJwpXmUqTeNUOfPlAyLHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZeJVnn3tGNbONLcN+lFsGUhufqj5Dhzc0uo7EPl4lb08z3QW3DjyRkjmqdV4PWbIuEAtyMCozHp7ttFR+eKn7kUoQ7vSA+bHhVgvb5598jJUm3f4JPH07sy8jJvECWlOYiNgVt1HaMZ5iEoCLTIJirWqcwb5ecUIdjIO4ybeJBX1y4+Iv2I423N1pfSE4oItNeSHjQEvFhRy9Mn1WdwsT/QI9h93vMTdNblRBAl44N0F8GJy76KZol3hzAgrEbh+BarwqNFcgiRDaTimfgCO/BMEK642B6EusJLAS7n9KhQf6m5S/QKEVAfIya0qPU+hwXavXo5qTUlhl/KrrAUnSb3lBRUZtKnzqVKRoIvh9W1Li7RpWXxFYKSiA3ggDtpYeifO3znyNXvXG6kkVs11c7i4/AhBZvtpIMIFlGUirm83imScTR4wuh9kIcn/Zj/R4q/zUhpYLICzpydooSUWYBhnezoptzO2jURWNJbtDtNScjJzsqdiVL0U5t5kRRck+rpslAE+ZNmOniW27RtLDaHn4M5XTL/Cxy+FD3+k4Tyo0ynjxRBBeVNQhtjfQEInY8XaulCGPv91+afYKSTj2sW6Z0hWWmBNkGU8C5GU6ps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a10c68df-e91e-4387-e856-08deebf2a9a8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 15:20:59.6377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLXSHVXKFQ2U3rdilxxL0gPrJLy2vA7toMkGa/hnmIlL/PN3+wg8eYK9JEL0PkwIOat/hpJOHfsSkvAVhrr+VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270144
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NCBTYWx0ZWRfX/m++gNINXtdl
 sOjVM6uJRcLM3gYPw3C4MJOeXZcvGrjB0lggfJ4HRUIiJ4ZsmS+aic0tMv/HPjQe0QpolAVU202
 O4YZIutDFmtdhvvKEObAyp+39FyFRvbf1o3v0oMYTDKQ9sefc8/+
X-Proofpoint-ORIG-GUID: xUBotz9OljJdZR_No0vW_jn4Il7WhnNd
X-Proofpoint-GUID: xUBotz9OljJdZR_No0vW_jn4Il7WhnNd
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a67775f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=K42rdxG4EqJBI-sW9rIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NCBTYWx0ZWRfX3IGKLK9AUgoj
 8z5HQRnBA1oTJDSTqYWaUD/GFP7d0HgwDiEsEsCfzOLiYcoftEYeUpMs1MJUTxkHr2U5zIdTQaY
 ckz+YqkDA5cDVroXp4uHvhimMnNKFpMdHlmMZSaRqE6tDFCaC9D7h9w5HnjUHfvxh2XQZfW7Swa
 WqLe6jns63FPMOu8gq2EMdMmJ+vknFXImGWDVxgVvhTx5AxmEedHIrmfQtO33qDQTBlGKPFwvHS
 iXAieWFxFpvYV/6ZICFN04MQ+/AJpJjQM/ra5V92lIQkHdvgD3eUh4aHJRp/UpGQjWVLhRINuN5
 3FeArH+KgTg7Dx6haEMyVo++ONXnUEr2qOxHWtq4JXlk/80JzreKnfql7eTUt0j8qaiNZN5XozB
 ALL/AvC2v9eKwpEqm0S4NLPcfTCPWXdHIbW//rXPWIplcym/sY6SDcS9nYAC+xcWLSPYN2wWL6W
 m5XhZqP98ZWsFE/5Dvw==

On 27/07/2026 16:03, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Round-robin path selection can enter an infinite loop under the SRCU read lock if the current path is concurrently removed.
> - [High] If `blk_alloc_disk()` fails, an `ERR_PTR` is left in `mpath_head->disk`, which will cause a kernel panic during cleanup.
> - [High] Missing requeue list flushes in `mpath_device_set_live` and `mpath_remove_disk` cause IO stalls and bio leaks.
> - [High] `mpath_round_robin_path` incorrectly returns a deleted path when the path list becomes singular.
> --
> 
> --- Patch [3]: [PATCH v5 03/27] libmultipath: Add path selection support ---
> commit 88605e74a8a44a0f658b820940be9c7cdbbebc25
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add path selection support
> 
> This commit adds path selection support for NVMe ANA, abstracting it into
> enum mpath_access_state. It introduces round-robin, NUMA, and queue-depth
> selection modes along with iopolicy configuration functions.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index d2e334259f3c1..2b22c74760868 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> +static struct mpath_device *mpath_round_robin_path(
>> +				struct mpath_head *mpath_head)
>> +{
>> +	struct mpath_device *mpath_device, *found = NULL;
>> +	int node = numa_node_id();
>> +	enum mpath_access_state access_state_old;
>> +	struct mpath_device *old =
>> +			srcu_dereference(mpath_head->current_path[node],
>> +				&mpath_head->srcu);
>> +
>> +	if (unlikely(!old))
>> +		return __mpath_find_path(mpath_head, node);
>> +
>> +	if (list_is_singular(&mpath_head->dev_list)) {
>> +		if (mpath_path_is_disabled(mpath_head, old))
>> +			return NULL;
>> +		return old;
>> +	}
> 
> [Severity: High]
> If the cached path (old) was concurrently unlinked from the list, is it
> possible that list_is_singular() evaluates to true because there is exactly
> one other valid path remaining? If so, does this mistakenly return the
> unlinked old path (or NULL) instead of evaluating the single remaining valid
> path?
> 
>> +
>> +	for (mpath_device = mpath_next_dev(mpath_head, old);
>> +	    mpath_device && mpath_device != old;
>> +	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
> 
> [Severity: High]
> If the currently cached path (old) is concurrently removed via
> list_del_rcu(), it is unlinked from dev_list. Since mpath_next_dev()
> iterates through the list, will this loop fail to encounter the unlinked
> old pointer? If all remaining paths are non-optimized or disabled, could
> this result in an infinite loop inside an SRCU read-side critical section?

locking is added later, which is being ignored

> 
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
> 
> [ ... ]
> 
>> @@ -75,6 +312,7 @@ void mpath_remove_disk(struct mpath_head *mpath_head)
>>   	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
>>   		struct gendisk *disk = mpath_head->disk;
>>   
>> +		mpath_synchronize(mpath_head);
>>   		del_gendisk(disk);
>>   	}
> 
> [Severity: High]
> When the disk is removed, are there potentially stranded bios left in the
> mpath_head->requeue_list? Without a call to mpath_schedule_requeue_work()
> here to flush the list, do these queued bios leak?

that is done elsewhere

> 
>>   }
> 
> [ ... ]
> 
>> @@ -96,7 +334,7 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>>   			struct queue_limits *lim, int numa_node)
>>   {
>>   	if (!mpath_head->disk_groups || !mpath_head->parent ||
>> -	    mpath_head->disk)
>> +	     !mpath_head->iopolicy || mpath_head->disk)
>>   		return -EINVAL;
>>   
>>   	mpath_head->disk = blk_alloc_disk(lim, numa_node);
> 
> [Severity: High]
> If blk_alloc_disk() fails, does it leave an ERR_PTR in mpath_head->disk?
> If the error pointer is not cleared here, would the cleanup path in
> mpath_put_disk() mistakenly evaluate "if (!mpath_head->disk)" as false
> and attempt to call put_disk() on the error pointer?

already commented on

> 
> [ ... ]
> 
>> @@ -130,6 +368,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>>   		}
>>   		queue_work(mpath_wq, &mpath_head->partition_scan_work);
>>   	}
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
>> +		int node, srcu_idx;
>> +
>> +		srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +		for_each_online_node(node)
>> +			__mpath_find_path(mpath_head, node);
>> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	}
>> +	mutex_unlock(&mpath_head->lock);
>> +
>> +	mpath_synchronize(mpath_head);
>>   }
> 
> [Severity: High]
> When a new path becomes available and transitions to live, does this function
> need to call mpath_schedule_requeue_work()? If bios were held in the
> requeue_list while no paths were available, could omitting this flush lead
> to permanent I/O stalls?

I don't think so

> 

