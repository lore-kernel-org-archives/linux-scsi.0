Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B559B17E0;
	Mon,  6 Jan 2025 08:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736153438; cv=fail; b=af4vA2pYiWKPur5Klsai7cOyRmv0QqmHFM0qFSOA+eZtadtwBEC/ejWI80+2exihPnM+iDAGBVkqPxiFODcTxDuBULfezjhdQPfLDp/Qj1DTXa5sqMN1jSAqI3JqHAZoDjKV1n2KDnKYq3dK5zPNO1ju/8a5TqlP97K8K2HAH9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736153438; c=relaxed/simple;
	bh=re1EF9USSNq+fuPHNZU5TRgHbAFkHewBGLy+OfcwY5U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eQ1sg8evFHu7infotBjsG3pEkobKAmKrUX+pR445dPvswItasyaVjTdHRxvG4r+XUH+KBt9pRC2nnM9PMZgX4bSSh+HUznqapuFTR/7GyMoYCMXslt4RypGaDjZy9qAsf0B35Ii1KFwKOd/JNk1Hxa1vFuvb8p98uAmZPKkmRZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BZmuU+YE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=euwIozUB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BZmuU+YE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="euwIozUB"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 505KP2AI011855;
	Mon, 6 Jan 2025 08:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Zd1h5CL7wEvh+wUkNZCvx31FDOxM/81Ftzr1h+PsYLA=; b=
	BZmuU+YEQtsWwL1An4U9N7S2tuTuRaMaR06J4XGgBbaVFwr+eQlNXvzWzewf61yJ
	KuKfucMSZ23gmQnsy31h8lDzL5WKWPfsf+l7IMdBj1FkKZR8Fh/NTPscU9C0zHbq
	9gE89OKNgwpScY+12CfuQIYxRb0Xn0RxICkAV/i7yjjceZNsxYJJPlmkl13rGJ2o
	mDmmFrmntZIdOHQxK019U3c9OkNWkRJHoZnaWsd6jpRPTwQAnsNuSpuU9N6YCiw4
	2jtfarQ4z/lqxnpOlGpPiQE8BHAehaKR4zj/y1vTNhgU/SjR31SpDUWi+AE554DA
	MjyAjLZwJq//XTe7veiLnA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xvv91wbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 08:50:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50671iaS022724;
	Mon, 6 Jan 2025 08:50:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xue71hx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 08:50:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dxvHRH4T+l7q2iW/ksLNxqziTS7/CzF67hJcjc3J0SZrIivDR2iVSsvPpWbIB+ZW3hjc0jatMORj6W43QRVU5xPE20i6BQrxlXCifOmLdl8VDWLDn1t8hKw7p9aOfI5AbVu1PPZCU3fUvhAGwSTTPXKrmfMiNr46P+5/aQHQuWT+6aBSA2A+9IuLA/8CgOXcv2ng0Ldk8UY2XZtgDWyyXbC8nCU3TuyrLPXJlWV/v+gwgaFNbyQephgYRLN6gZyaYeB0Gf8i4Huf5I5QCju8j9cKYTxjP/lFE/ixP5th2/euWr940e9I5RqIFQYKKl9WonJzhGzuC9EzXzKtww2UZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zd1h5CL7wEvh+wUkNZCvx31FDOxM/81Ftzr1h+PsYLA=;
 b=UOfvDBtehygBQlx4c+4i3V25jO8UJ0NC10HrXzqb4RxjCzciu0hSz1ocK3jJy8pGk9iJ0Z2B/hHBgg72FdiIT8qLKCp9ZK9pxqaxBdlFwgxNQ/I0nNgEe/DZjNbGCsStEzqaINw1CL7ZktwV0F6XPX6QQhn2EgCL/kunZpuOxfFnPOOT5PZzhwcicWMfEIRlmmVSosPB/66N2qhpsQ+MBcH3VQskWwnfAmc+O34Hwr9t+xXzWFoD9xiAbTUfRRIuRIuanuSbd9kyRsaOoZ1EJ2IbOwuvJ7eNc3JnyISRSB3nCHIvZdP8BWIq5RTdr6UkPgy0O0hj5uf8iYJYzdrvdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zd1h5CL7wEvh+wUkNZCvx31FDOxM/81Ftzr1h+PsYLA=;
 b=euwIozUBwasex/28jCBa8OoA3UpmOVB/k+wwlYQaQDJbDyCrxNeSmC7H57yaZFRZUBYQFbEUvhYUQx91/1Iia9EDKZIydE7fz3QKPVRwiztKq8VToGWNx6TP0JibB4dleYqO40ZQbXpumvlgqARukpKxxVOck9xWM4hAqm8WjBU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB5142.namprd10.prod.outlook.com (2603:10b6:408:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 08:50:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 08:50:23 +0000
Message-ID: <10f1383a-fe7e-4cf8-a15f-14cd4385a7de@oracle.com>
Date: Mon, 6 Jan 2025 08:50:20 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250106083531.799976-1-hch@lst.de>
 <20250106083531.799976-5-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250106083531.799976-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0255.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: f843df99-2f2b-4211-5f73-08dd2e2f2844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXZtcUxGWEFYOHBGL3U4dm5pUmZtYTdLSUFTaUNpWGRCNVRYL3hMcnNiTDFs?=
 =?utf-8?B?SFo5OXVGMmZvNXAxWFgrU1pLdXYvQ0pvcjdJMHdsSENJNW9jakFKMnJXT2N3?=
 =?utf-8?B?UUZxV1pxU2lMd05OcW1aSnFJeWJUL25ETWthQmFjdGJ6dDVsWkk3aUgxK2Ri?=
 =?utf-8?B?akZyQ2EwVlkwUThtRFlPVFkyMkVkSFRHTWRHTGlBQW83L210RHB6NVUyeDhq?=
 =?utf-8?B?VkplOHh0NjI3WFNPaXZmenFMZzRlbjJkcjRCNnB2QkVwUUYwanlSb1VxdzJD?=
 =?utf-8?B?QUJueHpjL2hsenhya1ViOEpCOWtkM3FKUldOdXFjSzNIRW1peVVjZlJOZHRZ?=
 =?utf-8?B?Y0p4ZnlMa1FZSHZJTHJCbkdUaDgwb2FCZnNwVThEeUhEb2NoUzRPYlZMaG1U?=
 =?utf-8?B?UzE3aU1lSTc4TUZHQ0VXUnJUS0N5UWhtMjBockt3QnpJeGtPR0tFRGp4OGZx?=
 =?utf-8?B?YW9ZWWtGV1JzOHRaUnNFSE5BRmpOUGM2VGRqblZxOGRRYzFMWDViSElZeitC?=
 =?utf-8?B?RzI0a0V0c05aRkdCYUZzTmdNVUp0OHlCRnNMd040YXY0Nlo5RTV6VWRobUh1?=
 =?utf-8?B?OVVIZXp5Vi9OWjVVeXQwdlN2cU4zaUx4YVErY3Y2cVR4Z0p5Y3JDOVJwa1Mx?=
 =?utf-8?B?VHlBODJvRktMNkFmUWdrRVRlYzN3cEpRdnJJaEM1ak1TVmFVbUJLMWgrWnNu?=
 =?utf-8?B?d1FsSnpzNVBDNkUyZHBmNlRhVUhnbTRxWUZMeGRyZGNRT1k0UDNuUTlsL0Jt?=
 =?utf-8?B?SHU2a3VyN2wxdFE1cXdmTnJkRWZWUUIvQml6eXRJOHJVdE1MTXk2ZlVaYkFJ?=
 =?utf-8?B?MENSb0JRUER4MHpWVzB4N1BIZVh5SER6RC9UUUtSRHBzNlZzZjgwTkpTTnM4?=
 =?utf-8?B?VXFQVk5FZDVTNVFCc3MzdVhPLzFPa3RDWE05NmQrTXhER3RWUlFNemF6YkFx?=
 =?utf-8?B?UHJ0YnRDRXlIZWRzSUN5MHhDMWozdjZwWEtPNDRUR2l4OU91cmlSR05oLy8y?=
 =?utf-8?B?c0g0dDdSWkR2ZWNIUVVhRnlVbjRVZGVYNnhGb0JkTm9PWXhjVS8reDlXNXAz?=
 =?utf-8?B?UVpQSXFLcXlNb0E5eVFJZHR4bVhPbVNla1JyclhKWENkdHZ5V3BnSzBNaXRK?=
 =?utf-8?B?Q3U0d2NuM1RsaUJlcW42Qkl3WXA5OUtpa2IyZitCdXBGZUVwMFpGbFBVdzlx?=
 =?utf-8?B?dW1lb3pudER0MUZRNmZsRkpqV0p3L21sNVEvYmhPLzBnOStYejBXN0l1anpH?=
 =?utf-8?B?T2VCdmVMSnR2b3dTalh5Y0g4a0UwbDMyU05aUE9xbEFyTm5iM0lkYm1GOHFp?=
 =?utf-8?B?NjdvREdRc2tWRWJVbUdPeDNVSGFSSnE4aUg4MEs5bzFzbDJYZmZZRHhGeUpp?=
 =?utf-8?B?L0c0RXNMbWxJZGR4UTdrM1B4SndtVkxZQ3h2QXNKNlJkV1JITXF4MXd4V21T?=
 =?utf-8?B?b0ZpZVhVZFR6M0NZSHcyTkRqUXhPWXAzclJINWFDRVd4Y3llL2Jld1RmY0lw?=
 =?utf-8?B?UUpqSnhXR2Z5cHZyalhIOXlwbjE2c2FUWTB1V2NSdmIzU21LMFhUbTB1OVFJ?=
 =?utf-8?B?d09MVWxBWGlSVXl0ZDE0eVA4Ty9CWS9VcTJjME9RMmZsS0JQRXNDcHg3Zlkr?=
 =?utf-8?B?SWFITC9lVGhCak9oSW1oWDBsbExJVXVUd1lBMzdNTWNFaExQeG42WSt2Mm4y?=
 =?utf-8?B?UFdWNmVJK0lONVlLSHFFYTNCbGJlMnI1MVpKNldaSjhtdnFQSi9aRGFXTzAy?=
 =?utf-8?B?WDYyRmNkNFBNZ3NhV2M5OXd3dlJUUnhhMFU3dWRyV1FQVTVUQTgvSzNqNC9Q?=
 =?utf-8?B?Z21SZjNQd0dObkh5SEhabStjZnJQbWY5V3RCSTg4SVpwazR5ZkFoT3VPMm12?=
 =?utf-8?Q?WrQ2nNKaJ9pLw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2psQnh0aWFTRGZhMnc1UVB0eVlKQURCcFVjMkdUSXdFc3F3QnNQbFkwT1FE?=
 =?utf-8?B?UTFNdWdCd1RTUlBpTmllV01YNkZjdUJMd2QvYm1wZ1BLa2NWVk0vQzJsK1dn?=
 =?utf-8?B?cDkraGpsMWg0bGc0clBJVis3eUNUUFFaQk1KTHRmWnFiaEd2RGFQbGI4MzQ5?=
 =?utf-8?B?cjE5aGtCa2xQakhXK1VaUkRQeEF3TncyL0dlM2dITEs0Nmo4Y2M2bkNOVjR5?=
 =?utf-8?B?MHhaMUVEcUp1aDFyeVMreUNxM0ZQSmNFa0Y2a0QvODQydWNxdVZpcjY3b1Jq?=
 =?utf-8?B?SG4weGgrei9tWDJiNzZHczVPenUxQi9zYzRzRUw0cmZXcUM3MldKYVJYWDNT?=
 =?utf-8?B?amlWc09vYXNqMmtOR002VmhIV3F3TjN2SnVsMzhmdW05aEgzWG92RGdJZzhk?=
 =?utf-8?B?SU9udVl3ZFlZd3NJdmd0Ky82ekVGd3ExdXFCOXJYUmZielkzeWhKNlc2ZEQ0?=
 =?utf-8?B?U2RyUC9pMzFHNlFHUTVMQXpaME9ETkk2VjlybGpSSG8rYVhXQW1wU2ZJcjBW?=
 =?utf-8?B?TW51Z2NzQXN6MEJ2cjd2eFJWUGlyZHdXQzNnL1FxRXFlRUYraUhwMUUvdGRE?=
 =?utf-8?B?U2szTTQ0dGJnK21BU3FCYWY3Smx4dXdrQTNQSG9NTjM2SlJZd2ZkbWhPaWh5?=
 =?utf-8?B?N3IzeExTS3o1T3k4dGEvSHpXY3FrOGpLcGFLd1lhelhqY2Vwek94K2x3Rzgy?=
 =?utf-8?B?UFM2V0dOdGJ2cmg3b1YyUk1LQTJyYzdHWTR6MEx3Qi96RFNCTnBCSFJlblhi?=
 =?utf-8?B?RlhPYnFoZlJGKzVnWDdIMXF0cDcvOWtvd1JMTG9RZlFwMlZ1SFNpVmgwd01K?=
 =?utf-8?B?VGY5QWVPYkhzWTdjcENsYVFYL3lmL05HRDYyTTVHSU5uMFBzdVJ5M2c3R0hs?=
 =?utf-8?B?cUdjdzRFVzUvdWs0SUNPNWJ6U01qZEFpaUs2M3NPTDVPREZ4Mmw2UDFiYjJo?=
 =?utf-8?B?K3QwM3VDNCtqcmFnMmZOb3NFOG51TTNCL2hEUE5LMGpOWWNuS2pjZWM0d0pm?=
 =?utf-8?B?ZjJ1Q1pnWGw4cmVKYktRai9rdHJXUFpLdEt2YXhIMHUwVEJTc1ZmcTFTbzk0?=
 =?utf-8?B?MXdsQTMxUkVGVE9XQXlDcEgyNTE0ck5LUUV0WGhMbXU5MytDZVMwSVVIZ0hk?=
 =?utf-8?B?NHoyZnZKUUFYS1JxTEpFbHlPenFyWDJDKy9vWFBaQ1RaSHVIb0d3dWlIUzh5?=
 =?utf-8?B?NmpJaVJrRldIR29GVG5rUkEwQ2JJQWlHdEZiampXM1d1RnpyaEpNZWZRa0gw?=
 =?utf-8?B?L1dKTUF0cW1OcDQ2Y0p4YmJjMmNYN3F3dzZMaDdueXRZUE10L1k2TDIrdkxR?=
 =?utf-8?B?RDFzNG1lUFNNazZwMC9oVndzdFpaNTREUzFuZmdSUDN6eExwY2dTZytJWW43?=
 =?utf-8?B?b3ZOaFVkSm1CVW9WaGdVVlJGOUNnY2Q4dHlQNC8yOVRkN1J2NHh0dnJtdERC?=
 =?utf-8?B?RFNSZkFzdjJ0UWVZQ3hTYWxYb0tmY25TY3lTdGUzWk9yaWF3dW5EWU5WOFI1?=
 =?utf-8?B?TVhkVnJiWURiL1BIZEk3ZHZTVThSc25NREhpUG1LTmwzcXcyeUJjVXhnVzNT?=
 =?utf-8?B?ajNLZFQ4SFN1T2Q2b29TZi9yNWh6UDd3b3JoNUUyOXFRYlBTM3Q0d3lqQ1U1?=
 =?utf-8?B?OEpFdlJSL3hZVFVvaDQ3c2h2QjcwK3VkMnJwUytvS3F3MFZXZ3ZhbFpwRGZC?=
 =?utf-8?B?MjhkQ3FEbG1OM1crUlAvWEhKWUVnWWpNQ1o3Y0dmK2QrVHA5cWZUeW5lbmdu?=
 =?utf-8?B?b1hLVFJDYkgwR0N6Nk8xaWRqUDJiT2k1UXkrQ2V1eG9kZ2hjRDdYalRtZjFk?=
 =?utf-8?B?V3JxbjY2MWQ4dHg3WVlISEdzZzFPMXBnWEtHYWw2UEZucGEyTGUvY0RpWkM5?=
 =?utf-8?B?RXpUZWkvZHNROVJwVDVubWRzTDF3c242N2JyeDdzNE5CUmxBS1E3U0Z5ZTVM?=
 =?utf-8?B?MVIvM2krWVpEclRGKytidndmZXd2MzZwMTlaU3RtUGFDMWpOUUxKTFVwbXJt?=
 =?utf-8?B?SC9sMXp1dHdHb0hETU43QzhHTmNPejlFdUsrRmY2OTVEbldhNzZIaFd5N3VE?=
 =?utf-8?B?Nng0SlVwcTQzZi9OL2h3aUlGajJoSURhOEpaUm5Ca1VvV21iMXBnV2hORXBE?=
 =?utf-8?B?Lzk4cGJpT3lTZkFKOTlrRXI4SzlIQXIyamhzbWZNb0REWDJ1N3N0azBpYWZS?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UNsJaVZiQJSIn5FZ1MaosTZTO+WbeZuHH1g2kmNSBcyGUX6YbZOAPbwrReakIKR0Vg7ncjWJAFso+HIwzLFbVbK62SY9KJifERPwgGaCQlEFQQEJKa2knquBZiDDmJ25NJTDswEjkZj4OXdwlLTrS/LTOgyiUPf4TlkwVh0spNS6+j00pW2WsGRC+cb4rBFHOq3P43Pzl8rPZmMmrWWv0rTjrO77qEvxZN4NL9H6hONtMYro34l2fri2p/67L62MA09WD5YD3WYpicZGALJFiOxkYxxHFU9vVKy38EvbS9a6ZRKI2iznthceXz7vMFM9dRmNpeSC6Mmp1GPlcYr6ueCX+PvBVfK3jQy2HKNoInHAEIS6VBL4Oqwv+U9S2uhB9+i0hwhaAyrF7FeGr9rw25ENK83bKNGwsry7g5ttUHtJFRBC3gHMJZiMTgLrieMMNMl26XN+nsk2a5gfbWbE5DCSKAtlvp4CyrgXicvNbD8yLZxMBMNJGEP2Y6wr8z57xLjVm6keB3p0NlJJ0P9cw5jLA18aXIIbRs8Vxc/SL9YBHwaAO4Tp6NiATAxsDvWG7GlK14LrsoRm+vZv57osrnP5CVe7VQbCt42kE3nppPo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f843df99-2f2b-4211-5f73-08dd2e2f2844
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 08:50:23.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uro231Vag7BQIcIrKGoEAd+R7oL1Z995PdW5dWAC4EgJw7B2BprnCBKB/Xo5BWjyzqfeUKYPHmj1s4Jm6prL6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5142
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060077
X-Proofpoint-GUID: 3kJDcl39UL27WYtUiHtVt8bQP0wLvymg
X-Proofpoint-ORIG-GUID: 3kJDcl39UL27WYtUiHtVt8bQP0wLvymg

On 06/01/2025 08:35, Christoph Hellwig wrote:
> Use a plain BLK_MQ_F_* flag to select the round robin tag selection
> instead of overlaying an enum with just two possible values into the
> flags space.
> 
> Doing so allows adding a BLK_MQ_F_MAX sentinel for simplified overflow
> checking in the messy debugfs helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks fine, but some small comments still. However, feel free to add:

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   /*
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index 72c03cbdaff4..935b13e79dec 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -378,7 +378,6 @@ static const struct scsi_host_template sil24_sht = {
>   	.can_queue		= SIL24_MAX_CMDS,
>   	.sg_tablesize		= SIL24_MAX_SGE,
>   	.dma_boundary		= ATA_DMA_BOUNDARY,
> -	.tag_alloc_policy	= BLK_TAG_ALLOC_FIFO,

nit: maybe that could be a separate patch, but no biggie

>   	.sdev_groups		= ata_ncq_sdev_groups,
>   	.change_queue_depth	= ata_scsi_change_queue_depth,
>   	.device_configure	= ata_scsi_device_configure
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 79129c977704..35501d0aa655 100644

> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -438,8 +438,10 @@ struct scsi_host_template {
>   	 */
>   	short cmd_per_lun;
>   
> -	/* If use block layer to manage tags, this is tag allocation policy */
> -	int tag_alloc_policy;
> +	/*
> +	 * Allocate tags starting from last allocated tag.
> +	 */
> +	bool tag_alloc_policy_rr : 1;

Is it proper to use bool here? I am not sure. Others use unsigned int or 
unsigned.

nit: coding style elsewhere in scsi_host_template would be to use 
"tag_alloc_policy_rr:1;"

>   
>   	/*
>   	 * Track QUEUE_FULL events and reduce queue depth on demand.

