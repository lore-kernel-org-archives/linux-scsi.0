Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23EC22CBC9;
	Thu,  6 Feb 2025 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843036; cv=fail; b=bYlKxuUgthmYpUkJPJvnCu2uTLrC47++MklwjGvWH9DNiNeT7YoBIwC/PCWWmtcTow8lKVnrZ2rXRs86jj5glj1IW/BoHXmKq+/wKp9vsz5ogsASX6xbkGdlAO1KEt2pF3WReYin4gHfDnHYCvMv4y5TDuarIGOpVw1rEMN1QiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843036; c=relaxed/simple;
	bh=l/peUuuZz4ye3W4Oq9v1BWQz+0BEP3JsZXA2lqPMdFw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a+Njo8BKxK1PSumR2kVp5GFxHezCBxijovEcduHzz6PnMB8xFuM6aKr1Hlaeuow/90MODZysNf8ck9uwUXgxYdisrCyEG/0y/tcdnUv+v1TcCR8027rwKhmmawHYblxnhYmranzLUlZ2EjkonOgneH/fRLbGjLVMtVw/xdgBq2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L2GDsyTX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AsyLfu+3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L2GDsyTX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AsyLfu+3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5166AlVe031550;
	Thu, 6 Feb 2025 11:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=zeSqNOJZtr+/zDyAwHZ6IAEH79R9IrLxwZhk44gw0/w=; b=
	L2GDsyTXKkRwqUKuiGA8VBF1IcZtCNM36HPflOY8qx7XjgaVzetm4PJ2TQFCtcZi
	RNYt/sY8aiOcWlpgdtvYZxwEWX/FbKXMXelR1o3jKuLccN8LAi/RtAligBJ/wKXA
	APkbWzTfub6ZnwF+B5RlRuS4ip7qgfuwnWu3WVBE0VUeuo/WRP2R7PNJAydysBu3
	CT+WpiEub7TaSMPh7DD7QTgalHO4p2gBpsSR2ARa9NSg1UVF5rimcoJNGNttQ23n
	pKzt0VbwtETJwmoKimPiVxHvuqlN5BHeU1kieEFVCLPBDlMKzAHmeZ2/Dg+waW1K
	bXzKNmuXnWY8MKGpassmJw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mqk88f4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 11:57:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 516ApDdh023549;
	Thu, 6 Feb 2025 11:57:10 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8gkmqj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 11:57:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7rN/HstNokPCDjNzPsAsoFjMjEYFzpgzUtzVL5KovFeF4607niyvEMwHogDyuo3o7liRZbj0lJGa9cgrVyMb70Pl87HpB8LjCnQwQSTXglWp6bub10P4eo2fVGkPx4RiXwkJni0swto08avVmXYCfMXS0ZgxQKAAZuG5C3vzKIWOGL73Pgf8EEQutUdPpPLSutHGa7rha3oJERl6eNsSpniSdPg+myzuA+Nk/Ouxn0qgPKvC8ywaOdPWMv10ODVPDJO2nqSDVeniJbyDgsJv8t3o73cxqw0p0O+e0s+EJAMTXppkchju87h4/WoqRtIbWnfcguKa0NqnHPDn9/ynQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeSqNOJZtr+/zDyAwHZ6IAEH79R9IrLxwZhk44gw0/w=;
 b=GGbM4ELSbMPaw4HlHPNwaku3HaXnQ6LPHP8GKV6vGIijHkYVRcTyP9vXxX9f7URcI0wCGPF+8HIwn+OXJuAskT1SFeVOyBnWCcd68AP9jXB7WM81xVoEKs+Qcnp1bZE1wMJ78y830MKkdRD8b4hogpEpNCmIbs+/LA832AX1sw4RNlJdzVkxfI9Qhh0lJyycoUaxnYElern1EjFwp//ctcmlZ5iuXSQiwV7Snjzc5POYMKgsNF8GGpNf1sO0NeyuBdfg21EKwOeOve0UhGOhrch5dK+KLYbQLN4ugxeguUmlVe6sZxiYpyOIbB1AVRZUPboLN4DhTaQgupmZdXr68A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeSqNOJZtr+/zDyAwHZ6IAEH79R9IrLxwZhk44gw0/w=;
 b=AsyLfu+3VCjiJAIRJfCqbj1TS3X2Ow4TvmZgfJAk7rOxafML3xg3nm5GVRXG1hvlk0eMiWm1zIPtkKKlIKYmnLPnHq3KJvIkxI+6G09lc2zyglmJzdPoaJzGlueYL8laGTCf+SE1soWHBi+9fewPwkV69PpjdM7a8vQ9Ys3SEa8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CYYPR10MB7570.namprd10.prod.outlook.com (2603:10b6:930:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 11:57:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8422.009; Thu, 6 Feb 2025
 11:57:07 +0000
Message-ID: <cd61706d-cb16-471c-bcb7-93cf84c79097@oracle.com>
Date: Thu, 6 Feb 2025 11:57:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 blktests 1/2] scsi/009: add atomic write tests
To: Alan Adamson <alan.adamson@oracle.com>, linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        shinichiro.kawasaki@wdc.com
References: <20250205231100.391005-1-alan.adamson@oracle.com>
 <20250205231100.391005-2-alan.adamson@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250205231100.391005-2-alan.adamson@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CYYPR10MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd1ebc4-fdb5-4a49-cb4d-08dd46a5617b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1gxVmgwV3ZvUXM0VjNHUlU1cThiSFhvMktqb0dDTFRtYkpNUnQyM0p3Z25n?=
 =?utf-8?B?bWFOYUpvYWJaa1pxV2dWeHlVMzBSemZuU1UwejljZDRxUUxKRzlpNEcvQnQv?=
 =?utf-8?B?YmE3bVZqNGZyUEU5VFFaRDZWY0trNFlPSlp1Q0hwR0VMd3FiV1RPN2prUDNQ?=
 =?utf-8?B?TEtsSHdNb00yQklQbGhZcnlBUVNhWG5jV0hVTUtIdG13ZEhWNHl3NHJUUTI1?=
 =?utf-8?B?Q0VXSVN6NWVKa2lTNWtqdEJsaEk5czFBWHAzRDdQMlkyZU5ScFFNQncvcmxj?=
 =?utf-8?B?Qld5MlptSXE3WEFjdEhPaGhISUhxZVIzTnBLMUJIeldFL0FLazZQNE1kOVlE?=
 =?utf-8?B?ZHoyQ2JtRHYxTkJNZk9pK0NqZll2UWN0Ym9JYmt0enZHTmRYUGUwRDNjOWRJ?=
 =?utf-8?B?eVdudWNZZi9Lc09yZlp6S3pzQzVoNGVwM1dUdFZLNXFHMmhRWGZMQkovdkhT?=
 =?utf-8?B?dUZxT0NyYkk1TzJEVVI4ak5QTmdqa1J0TmZUZlc3QlNkaUZDQmhzMkJwS1ZR?=
 =?utf-8?B?WklFV1pPNm5Ec3lFaUxreUh2V3liY2I1S0ljNnBxQy9RS1IxV2VuYmdmWlNn?=
 =?utf-8?B?aVhWNkFrczRiU0Q2aXBXeWxlR3lnYXpFVzRRQngzS2sxSkJKN3BvcVJFaGY0?=
 =?utf-8?B?c1I0RldVc3BVWlpzcjQ4V0U4bTJJWmVDempYWXJaNGE1R3V1STdValBRM3JQ?=
 =?utf-8?B?SHZJR1RtM1NkcmZ5TUltNmpnWEkrY3ZQWHhwK3BMNjBFcUhldGRQdmxuRjNr?=
 =?utf-8?B?dG11Q2ZCKzdlcWd6ZWd2OEVpUGNad0lFN1FqeGVhUzhUVzhRbGh0bEtmd3dU?=
 =?utf-8?B?SGpvMklOV1I3YnlZdkY1ZmZFcGpSWmYvb01Ta3R4ZEdTUW02UTE1ZEdCcG1L?=
 =?utf-8?B?WWdkKzF5Ui9kNzJzK3FjYVhaOVIxaU4zMjBGSWdkUlo1ZnE4Szl0OWZDYVNp?=
 =?utf-8?B?bnl3SWIvZE5CTVV6RjdpNW5qU1NmU1ZSbUlwU2hWSG9XRUJkUERUQU9OMmVH?=
 =?utf-8?B?dXlQdloxVUFrdTlyKzN1aHhQVlpibnpSNXpXN1d2cUtTa091SHRWMXZXclhn?=
 =?utf-8?B?eEFZVmVsdXZIcm9ibmZRQkd3Wnl0SHlUalo5ZVRlS0VXb3V2VUZlc1RtTThY?=
 =?utf-8?B?VmltWTdQbDJPYjRTUnZDaS9pbDk4ck03Nkl2OWpweHFROWYrZGpqNTBvenBS?=
 =?utf-8?B?OGcxQUR0OVE3VkhZTDRacXovUTNWSSs4bnd4bjVUdVNOcnNYTnJKczZuWEJz?=
 =?utf-8?B?Rkdyc1lJWkNFcXBESHZTcmFJVHRMemEvZ1pndDhaQjJRdXNmL1lJSmp1SGUw?=
 =?utf-8?B?ZWpCT09UbUFqU3dtOGZwRjg5UFZLUE1yRVVWQ1FYQU5PTkxKZU80cWVsWC9F?=
 =?utf-8?B?REFrUkZxaUlHQ3MzOTVrM1lvMUZETmhnOGZIMFgrYTNtdjRIZng1bGtzRmJ6?=
 =?utf-8?B?WU5CS3h1WVAwU1RhdTBlbFF3NzR0cDg2Q2plMGdJblIvN0dCK2JGQUdEaVhB?=
 =?utf-8?B?OXhEdm9aaWJTeWRHdGpIV2d1Vit2NEJFbFBvNmVkOEJJSWJ2TUZoS3B2eVVm?=
 =?utf-8?B?QmRzeVRyQTEyTVc2OXJ4bnNHOEdMU1JQbEFEdEVKZlpGL1R3M3hIMlQrbHo5?=
 =?utf-8?B?MkFDOUM2MTErWHozaUErbCtQaXFiVDZPa2tra2VOa29YWXRmaldHc1V2anhE?=
 =?utf-8?B?R2c4NUI4aXI4SktGTGNpcnh6SVRiaWZhNnZXSWV5eXdkOTB6VzM3bGFqbFFE?=
 =?utf-8?B?R3JTZnk5amEvTC83UVJQcVdmMnlSNklYMktlNTRLTlZkbkhCSnhZdTR4cFVR?=
 =?utf-8?B?SVh0RjJGQ096OXJ4NmdGeE52dFVidG0zWmRCcjZOenlvU3F6Qjh3c0VWSnMw?=
 =?utf-8?Q?lvgVQUoCJpB42?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckRsaGkyVjVzWFgyd2ZoL1hzc250dEVYVi93aXlzTFNOaFVLL0hIKzRUMGgr?=
 =?utf-8?B?TGlZbVk2QW5NcGJDeDFlUTJ0ZFVWOGJnSWdycysralhiQVJHVGlIVEVlQ2pz?=
 =?utf-8?B?Z0ppNUZQT2lQWmRyQ2xaVFhIc2I0Y09LT0Q3d0tWTFNIUFFBT040MWk1Z3BX?=
 =?utf-8?B?RkpWZGMxL0U2d3UzMzlqalFpV09yRW13Q255MklLaFZOc05ybDZ4THh0STdn?=
 =?utf-8?B?SlpmK25PaWtOU1hsS1pvT1I1UkRmc1NmV21pQ0FlTUQ0SDNvUENkQW9oMUo0?=
 =?utf-8?B?QzFwL21zU1VUUXFjS05PYmpjK2syK2RZd3pJL0pZM1FDN2t6TkI1emowKzhm?=
 =?utf-8?B?TE00amxMKzN5SnZQNkdMZzAzcWxhOHNmL0FXZ05uMGN5VHVxSkZSTDc5NktJ?=
 =?utf-8?B?RzdDRXFzd3JkcjJ5R0YzZ1BtVTNxY1V4NlU2Zlh6MHdqc0FBZERscS9nYkox?=
 =?utf-8?B?QllMSzltY292NVo0bFJ2QXF5SjFEdXBrS1dsZWNhbFdIc0VQNmorcHFkVkE0?=
 =?utf-8?B?dS81S0tQQ0JncEtuUGVFU2VjN0hROHJLeWFyc29MTzVGSnFpakhPSUtHSzg2?=
 =?utf-8?B?ZFduRDU3TkhoTEtWNlpBRGxNQTNubVpvZTEyZjQ5dzA1SFNMeDgrakFVMnBC?=
 =?utf-8?B?Q2RLV2dHYlkxTTUwMDF4MzZ6Y01VRFg0YjFTZTh5MkhCWFhDTmhLQ2hDSDZp?=
 =?utf-8?B?cEgwN1o3VEVKaFQvZS90OHlJYTg5Tmp6MDZxZVcxK09JYlM5NzRyc3lWcXZK?=
 =?utf-8?B?aXVUcU9nOHBuak5VaVRoUlFFbGpiSS9keUgwNmtSTGtaL1p0eS85WnorVnd2?=
 =?utf-8?B?cDMwUkpNN0Z4eGVnNkI2Znp5b29mRXphaEx2Rk1XUU1pZ1dXWTZpUHovSm9a?=
 =?utf-8?B?c3M1NkJGQnRnOWdoZXozSEc1cFdEVWdMYmFzNVpKcHMrN1gzd3JuMjl4STU0?=
 =?utf-8?B?d0VtWjAxOVUrMysrbWJDVG14UzRKTEZoeWhBZmF5VDdVWTNWR0pYZ3MrdWtN?=
 =?utf-8?B?cS9mMmUyQTI4Z1dRK3JYY2dzdHRUM0hXZnc1QWtoWThYOFNQbnRsSEc4MnRD?=
 =?utf-8?B?bjZyQTZqRlJES3Uvb2U4R3lsZGFodTZva2MrTldINUowQmNRSDE3ZEFoNEJ2?=
 =?utf-8?B?clJjU0RYRURDMEltKzFsVE9DOGRRc0hjMjA3b3V4QXdsVk5kQ3NOSzV2Z1V4?=
 =?utf-8?B?dUJQMHBvOW16MFQyZzBNcG96clpyVmdkL1RjSnR2KzU2YXoxS2FJOXdCTHdZ?=
 =?utf-8?B?RlltYlpFSldzbWlyL3RXMjkxdzgycnh3SktJWTRDTG1tRnh3YjgrZlNtQmJG?=
 =?utf-8?B?a1lTQVlqMy9MbTdNNnh3NTRrYTU4KzB1aDN0SG5ZSTN5aUtsK2NBejhyOGhJ?=
 =?utf-8?B?bVNiN1pSbDJJZ2RDdjhRd1VRNkhDSmM1eXlEeHFKd3J0YXpydml3SE5KSTFX?=
 =?utf-8?B?Szk5cUhnek9oNkt3YStrRXVqWnNLQWQ3TXY1M21ZWjVETHFTTVlRSVA5SmpS?=
 =?utf-8?B?T2k0a0xGZnFYTTZQU08rWklvWjBkeHZJMzY5bk9FZlpoTlM2Zkk5UGNKVXZ4?=
 =?utf-8?B?bkk5aUJRU2JQRU92KzFucXBIeFF2K3BKVWdLbmNkb0Zib3huMkd1MFlDTWhN?=
 =?utf-8?B?OEZqc1JjWkhhNEFUZGNrQ1d3ZGNvdGJBZkJLSnRXOHh2bTlJTDMweGE4RGU4?=
 =?utf-8?B?cGw5M1FQdFdxUVM1SC9TTjBLZm51K2NTVHBEdUZ4OEJqc3N3RDRlRkp5Q0hu?=
 =?utf-8?B?ekFSSlJicUM2eHNYNlpWcTJtelRQL3U4eUlSai94UWViWm1lVHlHVUFhd0pU?=
 =?utf-8?B?b2Z2dDREOVRtZEN0US9vMzFJWENMd1hTNHNJVXVCS05vdjlUM2hDS0VUeSty?=
 =?utf-8?B?WHhTWHFaR3BWR01SRk1vSFc4T1FVbUhqd013elNyS2V1TVIxSENjZTVpbVhI?=
 =?utf-8?B?NEpHLzNwaEd4T1VHTnl0Q1ZxSTQxQWZHMEJOS1d4T0F4WDQ3MGxMNXJmeUNv?=
 =?utf-8?B?ZzRKZEYwU2hhSWlVQWhFcnNBbnJhRkoramNNNVd6aXQzajZ0Nmw4L0dIZUlE?=
 =?utf-8?B?clUwNXBFN0JValJmZjFaU294RjVGRTMzWXRqVFpqbDZqUEJSeGh4QkdyejAy?=
 =?utf-8?B?QTFNcTRoeVV0MnhVQ1MvNmthOHkxeDZobTFLejREaDlhZXhYejJacUhRZ0wv?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aEdPOWVKMjbePMFE0l9oKqBSXEqhzgOu1x6nnkFjLbnrYmCBV0pWazQn+zt9ABwNyhdU4Gu9oZKzjbG/7IyUqwVdKdrDktccdEIEvef7mbsNLBLudw7+l/GL/a7Yug/UKvIQpBXtc07ueBQ8mnw3KBzcnFItL4H2XQS1FY6cCXo3u+hmZuZ9Ygr63+2ek6rJkE3UF8oZ1GfpT71aW6N3kqUu1XMi4FSclibMDaM2YW1FiuHj2BlDI85DQLxWDS0RrU4tJ+X108nL7sBv0eILg03eTenlnoztLc997EHKDo9BI4J6nzSA4qWOrTbMACVyJqLRVg8/MnhLQaPtjtzKgXSCBdS3682Xw0v2bEUtyHP14gYEo8q7AWhAoPkYJrcCTXA++0cKlOVNxqGqstfFqRS8tjdzICciyp28oWh2R3jUgHC9nG5dW5pBlzpiG9wqe4ddDL/d1Ub4aiWeIBIvIMUAoz88PV3q5vflPJkVchWI0SyLnse4bgtBNGXtOa9nE7YaXkSt6eKzGYHk/HfdLgYUtahMI2xwQq8BBiTsqe//8arQhWhPFd4XVNXQ4oqxsH0RN/w+5Q5xbnGHX0nwj+Uy9kkgdAP768UFbBJROxE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd1ebc4-fdb5-4a49-cb4d-08dd46a5617b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 11:57:07.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAqkQYcEKokh3I3xwS+cGazqiWewzoeR4ad8rf1TLo+7/9Pi4dxK2CDi8k5YAdzwdlC6XGD66Jflj1VkAXSSUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502060099
X-Proofpoint-GUID: lEZtoVXgHuoqoQOhFG_FXK0ZaE7l6Oqk
X-Proofpoint-ORIG-GUID: lEZtoVXgHuoqoQOhFG_FXK0ZaE7l6Oqk

On 05/02/2025 23:10, Alan Adamson wrote:
> Tests basic atomic write functionality. If no scsi test device is provided,
> a scsi_debug device will be used. Testing areas include:
> 
> - Verify sysfs atomic write attributes are consistent with
>    atomic write attributes advertised by scsi_debug.
> - Verify the atomic write paramters of statx are correct using
>    xfs_io.
> - Perform a pwritev2() (with and without RWF_ATOMIC flag) using
>    xfs_io:
>      - maximum byte size (atomic_write_unit_max_bytes)
>      - minimum byte size (atomic_write_unit_min_bytes)
>      - a write larger than atomic_write_unit_max_bytes
>      - a write smaller than atomic_write_unit_min_bytes
> 
> Signed-off-by: Alan Adamson <alan.adamson@oracle.com>

generally looks ok, thanks, but a couple of comments

> ---
>   common/rc          |   8 ++
>   common/xfs         |  58 ++++++++++++

I suppose that this common stuff could go in a separate prep patch, but 
it doesn't bother me too much

>   tests/scsi/009     | 229 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/scsi/009.out |  18 ++++
>   4 files changed, 313 insertions(+)
>   create mode 100755 tests/scsi/009
>   create mode 100644 tests/scsi/009.out
> 
> diff --git a/common/rc b/common/rc
> index bcb215d35114..06c0a416e3e1 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -292,6 +292,14 @@ _require_test_dev_can_discard() {
>   	return 0
>   }
>   
> +_require_device_support_atomic_writes() {
> +	_require_test_dev_sysfs queue/atomic_write_max_bytes
> +	if (( $(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes) == 0 )); then
> +		SKIP_REASONS+=("${TEST_DEV} does not support atomic write")
> +		return 1
> +	fi
> +}
> +
>   _test_dev_queue_get() {
>   	if [[ $1 = scheduler ]]; then
>   		sed -e 's/.*\[//' -e 's/\].*//' "${TEST_DEV_SYSFS}/queue/scheduler"
> diff --git a/common/xfs b/common/xfs
> index 569770fecd53..0b1ca7c29049 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -6,6 +6,22 @@
>   
>   . common/shellcheck
>   
> +_have_xfs_io_atomic_write() {
> +	local s
> +
> +	_have_program xfs_io || return $?
> +
> +	# If the pwrite command supports the -A option then this version
> +	# of xfs_io supports atomic writes.
> +	s=$(xfs_io -c help | grep pwrite | awk '{ print $4}')
> +	if [[ $s == *"A"* ]];
> +	then
> +		return 0
> +	fi
> +	SKIP_REASONS+=("xfs_io does not support the -A option")
> +	return 1
> +}
> +
>   _have_xfs() {
>   	_have_fs xfs && _have_program mkfs.xfs
>   }
> @@ -52,3 +68,45 @@ _xfs_run_fio_verify_io() {
>   
>   	return "${rc}"
>   }
> +
> +# Use xfs_io to perform a non-atomic write using pwritev2().
> +# Args:    $1 - device to write to
> +#          $2 - number of bytes to write
> +# Returns: Number of bytes written
> +run_xfs_io_pwritev2() {
> +	local dev=$1
> +	local bytes_to_write=$2
> +	local bytes_written
> +
> +	# Perform write and extract out bytes written from xfs_io output
> +	bytes_written=$(xfs_io -d -C \
> +		"pwrite -b ${bytes_to_write} -V 1 -D 0 ${bytes_to_write}" \
> +		"$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 }')
> +	echo "$bytes_written"
> +}
> +
> +# Use xfs_io to perform an atomic write using pwritev2().
> +# Args:    $1 - device to write to
> +#          $2 - number of bytes to write
> +# Returns: Number of bytes written
> +run_xfs_io_pwritev2_atomic() {
> +	local dev=$1
> +	local bytes_to_write=$2
> +	local bytes_written
> +
> +	# Perform atomic write and extract out bytes written from xfs_io output
> +	bytes_written=$(xfs_io -d -C \
> +		"pwrite -b ${bytes_to_write} -V 1 -A -D 0 ${bytes_to_write}" \
> +		"$dev" | grep "wrote" | sed 's/\// /g' | awk '{ print $2 }')
> +	echo "$bytes_written"
> +}
> +
> +run_xfs_io_xstat() {
> +	local dev=$1
> +	local field=$2
> +	local statx_output
> +
> +	statx_output=$(xfs_io -c "statx -r -m 0x00010000" "$dev" | \
> +		grep "$field" | awk '{ print $3 }')
> +	echo "$statx_output"
> +}
> diff --git a/tests/scsi/009 b/tests/scsi/009
> new file mode 100755
> index 000000000000..b114d92dd3db
> --- /dev/null
> +++ b/tests/scsi/009
> @@ -0,0 +1,229 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2025 Oracle and/or its affiliates
> +#
> +# Test SCSI Atomic Writes with scsi_debug
> +
> +. tests/scsi/rc
> +. common/scsi_debug
> +. common/xfs
> +
> +DESCRIPTION="test scsi atomic writes"
> +QUICK=1
> +
> +requires() {
> +	_have_driver scsi_debug
> +	_have_xfs_io_atomic_write
> +}
> +
> +device_requires() {
> +	_require_device_support_atomic_writes
> +}
> +
> +fallback_device() {
> +	local scsi_debug_params=(
> +		delay=0
> +		atomic_wr=1
> +	)
> +	if ! _configure_scsi_debug "${scsi_debug_params[@]}"; then
> +		return 1
> +		fi
> +	echo "/dev/${SCSI_DEBUG_DEVICES[0]}"
> +}
> +
> +cleanup_fallback_device() {
> +	_exit_scsi_debug
> +}
> +
> +test_device() {
> +	local scsi_debug_atomic_wr_max_length
> +	local scsi_debug_atomic_wr_gran
> +	local scsi_atomic_max_bytes
> +	local scsi_atomic_min_bytes
> +	local sysfs_max_hw_sectors_kb
> +	local max_hw_bytes
> +	local sysfs_logical_block_size
> +	local sysfs_atomic_max_bytes
> +	local sysfs_atomic_unit_max_bytes
> +	local sysfs_atomic_unit_min_bytes
> +	local statx_atomic_min
> +	local statx_atomic_max
> +	local bytes_to_write
> +	local bytes_written
> +	local test_desc
> +
> +	echo "Running ${TEST_NAME}"
> +
> +	sysfs_logical_block_size=$(< "${TEST_DEV_SYSFS}"/queue/logical_block_size)
> +	sysfs_max_hw_sectors_kb=$(< "${TEST_DEV_SYSFS}"/queue/max_hw_sectors_kb)
> +	max_hw_bytes=$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
> +	sysfs_atomic_max_bytes=$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_max_bytes)
> +	sysfs_atomic_unit_max_bytes=$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_unit_max_bytes)
> +	sysfs_atomic_unit_min_bytes=$(< "${TEST_DEV_SYSFS}"/queue/atomic_write_unit_min_bytes)
> +	scsi_debug_atomic_wr_max_length=$(< /sys/module/scsi_debug/parameters/atomic_wr_max_length)
> +	scsi_debug_atomic_wr_gran=$(< /sys/module/scsi_debug/parameters/atomic_wr_gran)
> +	scsi_atomic_max_bytes=$(( "$scsi_debug_atomic_wr_max_length" * "$sysfs_logical_block_size" ))
> +	scsi_atomic_min_bytes=$(( "$scsi_debug_atomic_wr_gran" * "$sysfs_logical_block_size" ))
> +
> +	test_desc="TEST 1 - Verify sysfs atomic attributes"
> +	if [ "$max_hw_bytes" -ge "$sysfs_atomic_max_bytes" ] &&
> +		[ "$sysfs_atomic_max_bytes" -ge "$sysfs_atomic_unit_max_bytes" ] &&
> +		[ "$sysfs_atomic_unit_max_bytes" -ge "$sysfs_atomic_unit_min_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $max_hw_bytes - $sysfs_max_hw_sectors_kb -" \
> +			"$sysfs_atomic_max_bytes - $sysfs_atomic_unit_max_bytes -" \
> +			"$sysfs_atomic_unit_min_bytes"
> +	fi
> +
> +	test_desc="TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes"
> +	if [ "$scsi_atomic_max_bytes" -le "$max_hw_bytes" ]
> +	then
> +		if [ "$scsi_atomic_max_bytes" = "$sysfs_atomic_max_bytes" ]
> +		then
> +			echo "$test_desc - pass"
> +		else
> +			echo "$test_desc - fail $scsi_atomic_max_bytes - $max_hw_bytes -" \
> +				"$sysfs_atomic_max_bytes"
> +		fi
> +	else
> +		if [ "$sysfs_atomic_max_bytes" = "$max_hw_bytes" ]
> +		then
> +			echo "$test_desc - pass"
> +		else
> +			echo "$test_desc - fail $scsi_atomic_max_bytes - $max_hw_bytes -" \
> +				"$sysfs_atomic_max_bytes"
> +		fi
> +	fi
> +
> +	test_desc="TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length"
> +	if (("$sysfs_atomic_unit_max_bytes" <= "$scsi_atomic_max_bytes"))
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $sysfs_atomic_unit_max_bytes - $scsi_atomic_max_bytes"
> +	fi
> +
> +	test_desc="TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran"
> +	if [ "$sysfs_atomic_unit_min_bytes" = "$scsi_atomic_min_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $sysfs_atomic_unit_min_bytes - $scsi_atomic_min_bytes"
> +	fi
> +
> +	test_desc="TEST 5 - check statx stx_atomic_write_unit_min"
> +	statx_atomic_min=$(run_xfs_io_xstat "$TEST_DEV" "stat.atomic_write_unit_min")
> +	if [ "$statx_atomic_min" = "$scsi_atomic_min_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $statx_atomic_min - $scsi_atomic_min_bytes"
> +	fi
> +
> +	test_desc="TEST 6 - check statx stx_atomic_write_unit_max"
> +	statx_atomic_max=$(run_xfs_io_xstat "$TEST_DEV" "stat.atomic_write_unit_max")
> +	if [ "$statx_atomic_max" = "$sysfs_atomic_unit_max_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $statx_atomic_max - $sysfs_atomic_unit_max_bytes"
> +	fi
> +
> +	test_desc="TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes "
> +	test_desc+="with no RWF_ATOMIC flag - pwritev2 should be succesful"
> +	bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$sysfs_atomic_unit_max_bytes")
> +	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
> +	fi
> +
> +	test_desc="TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with "
> +	test_desc+="RWF_ATOMIC flag - pwritev2 should be succesful"
> +	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_unit_max_bytes")
> +	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
> +	fi
> +
> +	test_desc="TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 "
> +	test_desc+="bytes with no RWF_ATOMIC flag - pwritev2 should be succesful"
> +	bytes_to_write=$(( "${sysfs_atomic_unit_max_bytes}" + "$sysfs_logical_block_size" ))
> +	bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$bytes_to_write")
> +	if [ "$bytes_written" = "$bytes_to_write" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $bytes_to_write"
> +	fi
> +
> +	test_desc="TEST 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 "
> +	test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should not be succesful"
> +	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_write")
> +	if [ "$bytes_written" = "" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $bytes_to_write"
> +	fi
> +
> +	test_desc="TEST 11 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes "
> +	test_desc+="with no RWF_ATOMIC flag - pwritev2 should be succesful"
> +	bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$sysfs_atomic_unit_min_bytes")
> +	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $scsi_atomic_min_bytes"
> +	fi
> +
> +	test_desc="TEST 12 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes "
> +	test_desc+="with RWF_ATOMIC flag - pwritev2 should be succesful"
> +	bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$sysfs_atomic_unit_min_bytes")
> +	if [ "$bytes_written" = "$sysfs_atomic_unit_min_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $scsi_atomic_min_bytes"
> +	fi
> +
> +	test_desc="TEST 13 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 "
> +	test_desc+="bytes with no RWF_ATOMIC flag - pwritev2 should be succesful"

Again, I am not really sure that testing with RWF_ATOMIC has any value here.

> +	bytes_to_write=$(( "${sysfs_atomic_unit_min_bytes}" - "${sysfs_logical_block_size}" ))
> +	if [ "$bytes_to_write" = 0 ]
> +	then
> +		echo "$test_desc - pass"
> +		echo "pwrite: Invalid argument"
> +	else
> +		bytes_written=$(run_xfs_io_pwritev2 "$TEST_DEV" "$bytes_to_write")
> +		if [ "$bytes_written" = "$bytes_to_write" ]
> +		then
> +			echo "$test_desc - pass"
> +		else
> +			echo "$test_desc - fail $bytes_written - $bytes_to_write"
> +		fi
> +	fi
> +	test_desc="TEST 14 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 "
> +	test_desc+="bytes with RWF_ATOMIC flag - pwritev2 should fail"
> +	if [ "$bytes_to_write" = 0 ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		bytes_written=$(run_xfs_io_pwritev2_atomic "$TEST_DEV" "$bytes_to_write")
> +		if [ "$bytes_written" = "" ]
> +		then
> +			echo "$test_desc - pass"
> +		else
> +			echo "$test_desc - fail $bytes_written - $bytes_to_write"
> +		fi
> +	fi
> +
> +	_exit_scsi_debug
> +
> +	echo "Test complete"
> +}
> diff --git a/tests/scsi/009.out b/tests/scsi/009.out
> new file mode 100644
> index 000000000000..e31416b93515
> --- /dev/null
> +++ b/tests/scsi/009.out
> @@ -0,0 +1,18 @@
> +Running scsi/009
> +TEST 1 - Verify sysfs atomic attributes - pass
> +TEST 2 - check scsi_debug atomic_wr_max_length is the same as sysfs atomic_write_max_bytes - pass
> +TEST 3 - check sysfs atomic_write_unit_max_bytes <= scsi_debug atomic_wr_max_length - pass
> +TEST 4 - check sysfs atomic_write_unit_min_bytes = scsi_debug atomic_wr_gran - pass
> +TEST 5 - check statx stx_atomic_write_unit_min - pass
> +TEST 6 - check statx stx_atomic_write_unit_max - pass
> +TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +TEST 8 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +TEST 9 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +pwrite: Invalid argument
> +TEST 10 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 512 bytes with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
> +TEST 11 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +TEST 12 - perform a pwritev2 with size of sysfs_atomic_unit_min_bytes with RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +TEST 13 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +pwrite: Invalid argument
> +TEST 14 - perform a pwritev2 with a size of sysfs_atomic_unit_min_bytes - 512 bytes with RWF_ATOMIC flag - pwritev2 should fail - pass
> +Test complete

