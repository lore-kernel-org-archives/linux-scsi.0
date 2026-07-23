Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B55735E1BF;
	Thu, 23 Jul 2026 10:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803207; cv=fail; b=tPgudIXELkHsG2QblGVBijKqW35OP+w3PwemHi/9zrmPT0aCuFZ/KKVlfl6+nScUqzr3EQAgI5fp8iSwG9IY9BCSMvq+7AGjiMUBCC0imgBLkyj2BIX2Ovo9yDZhtkielv/E4kGMVyKKWSLKPPaKvh/KVCnSau/DwMDeScx1W8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803207; c=relaxed/simple;
	bh=HCV/v2SmOnDGDi1kqyYphmzZqqq7es2W8v5deZr4pVc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zg/BdehgU3bMky0NafIfaiNRSMeV4BSZKfF/AeIciblNa1nXCvd6A38THelKP6TQR8h9MFu+TbDzKp6Hg1GVBU4WN4CuhY18tSoQHtinPO5pIiTUWoN5R5o34UIWsku6GXQEAM3waWbAsO4xVfpYLEbsPPc5CM6iIW37wd3uhj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BsSdOOOG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ynZE3nd0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BsSdOOOG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ynZE3nd0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtf1D3573953;
	Thu, 23 Jul 2026 10:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gsE6G63Uk5Ozp+5O0uLYAYnFhdR4odKY+gS/N2sNVMI=; b=
	BsSdOOOGSqSNMGOzUoGdDSLhc/ueLhdzmYBvlhdcEZZaYGbXBuri4/Ti6H7xzhme
	9uPKPg18SirtdbsiuF2dRox0UbFSJAiS8wOEf7UW0lKCaObFXdnlNS1cy+Rb/pMl
	axwkZS3aVzc+phW1KWYzryMKhDYCkc8JLlIwP8z8kkRHA547x1gIVOgMhhp7edsR
	c5PgtwwLUgOLSGcP+mW/c126xXkJgRGWNN5qzvBCvGE7Xkn8cwBk5cMIn4Ryj8K8
	SRu1DUtKiFoFu0/IYNbY7rbF3YWOZHGuGM/pjaDwdwXxbzjuLWH3laIjKPr+Ku6/
	Uu6WynVY7xyjlFGV5SgzPw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqpsdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:40:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAcXix014979;
	Thu, 23 Jul 2026 10:40:03 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010041.outbound.protection.outlook.com [52.101.46.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxsexj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:40:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ismBIyvmi32TVAZ7so80Dj6bD6Ys5UI4c8qCHTcUPuLl5B/tR2dpmygu+//kH7s9Xpoorjo1ar9gU5HClZwuNAPwjMBow3BOKSGFOUvQ8GiLNTNWD7zy/DtnyGV57BizxFGLCtrG9HEfitDDRuslXxedeBA6BBHY+IWJ5MyEp++Yd1JKiHqdcgV8w8MioPaUKoD8Oo9QZoNFRSV37Dog4uV75qKt6O8/maNDQ03gKj3cx7Asgk24+V1D60kb8yMk4SyOv5iN31pmOEjv1YfdaUltwxCioodlfWPvwipQQd2DgBuu1KtLqhICJLVPPxBFInKa1hHXvXHTQArl6g++eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsE6G63Uk5Ozp+5O0uLYAYnFhdR4odKY+gS/N2sNVMI=;
 b=BmhMfNYCle9F6TNVSkDtCjkptJBLaxPhjvTLQsSJR2rW1GC1NVp8NbfujRidasqRW0cpBd2GbWba7zpQLZDhSgybDYP/PkV2ameV8fN7u6cdv5pSYtAyF7v/Q3EPnq8iX7uJbrVW79qV77o70xMwgtqDNejqF7vu/Vn7fQ5OPoI3NnTdSpil35IriiYz+TvGp7EZrrhhy3EJ8RKiR+sP7hJvszD0D9WWRNqs1sqKYf/XgSTdI2KkXWNWGuit8/g/vsfPIlrFpApzK2IhtX0qEE15q96uJYkrHMoWlK9x+58YE9aUri+AKHJad93KkgQ+pq8DdNhg/JGFMHaLh21rBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsE6G63Uk5Ozp+5O0uLYAYnFhdR4odKY+gS/N2sNVMI=;
 b=ynZE3nd0v76qB4zf7W0vkohkwPpywyVG9w/iKPN6lbyQYmc5RQVHVy234QHyt1qNwfYvVp0rkgl0uTyASFCdfnw2CtdE/uxi8YH/Ets2IdOJcNb6EihNRMSdYcL6HTzffRTDfsFCWdW1Wezx6GVvSHan44Bwah586h3AZ/ou5dw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH8PR10MB997765.namprd10.prod.outlook.com (2603:10b6:510:39f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:40:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:40:00 +0000
Message-ID: <e539fc03-b60d-4585-abd7-7a6b102034d8@oracle.com>
Date: Thu, 23 Jul 2026 11:39:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/28] libmultipath: Add mpath_bdev_report_zones()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-9-john.g.garry@oracle.com>
 <20260723101514.8731C1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723101514.8731C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH8PR10MB997765:EE_
X-MS-Office365-Filtering-Correlation-Id: acdbbade-7e44-42d8-9c86-08dee8a6bf18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nVGeeye3SzJ3EOmULrvqJVnGbheXcxAnwVYmMVgTUf8SDm4jyWFXrg8Pej2R8p6alSIAe0uIniHR53IgnS3BHhryi1L1barbf+PD5qnHAl/5SqK1m8JwhYr7YjHPt80+8b1RN7lKasQO3hd5B5QUClECA6ggA2ImbiaBe66LuVw/uUjGZ0pEyx8CQlCY+wku4D9fbD7rtHBW9m/3p/m4B8SQNFcT7FH5kYnlZ7Ke5Vsv5jEduBO9azj9CuUnyEPyKeJlXxpqAR1dY4vXhpIRKJzwP5EDqU+KHJmbOVz6axTw0kfGVz2T6mswvaCEW9/j0u6AaLrJsryODIiE9nlDHScG/UHs0DsOx78aHJtdEKRuYSazC8LOLez6zCCZy9gDIShq9Eai6LgLPlwMdOWtF6v/AtO3FOfLD5di8REdBe9sGdeKFVjwHgis4WrmF2uLBSn2gsaol9oxYMDQOjT8w2akeBKdnFLbvXyw+TmGV8BeEj278naRD9RLp5wD8/yYqFxZrCI/KefvMTdgblWlxa+3yGMtFuwqOIPXhJeqXpua/QSoD1qp9gPHemkEsAllS6simz/CZtTkvOke9YrJBILzIGvhJ/C1QNamNhKAZEDKN7Xh6F1t2AeI60Kl6LMjhxCLyzINZuSZnTwY6AHpliKrPuMF+P2828zjfsg4GyQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWtBN2JpcWFRSHhCaUY2alFGUnJaeTl5am01aTlGblRBdDkvYlZNZXVsMkpY?=
 =?utf-8?B?THVSSWllclZpOUFIbHRFYXJqK1orTDZJY3JvOWdla1puVkQwdTZ2YS90Skhx?=
 =?utf-8?B?eFlBWk53MnE1VWJwTEptQnY1Y3cxMlIwV3MzL0h3eDkzRkxBYVRNUDNINHkz?=
 =?utf-8?B?c2hWeVR0Ui81UlJTNFV5TU1ESVVCM2dpdWJWNmgxV01pc2Jaa01XaDY1NllC?=
 =?utf-8?B?ZGExU2lxN0FTRDdrOElQU2M3MTZBcHQ4NlpWcnNNUWtDRWNZRzl3TTRFNGxC?=
 =?utf-8?B?T1VLZDI4TkFoVmQyZ3krQ0prcXVOam9JOFFtL3JqendrU0hJNUhMZEs4S2Jv?=
 =?utf-8?B?Qm9GR05PbTh3UDZkaXB0V0pOcWx6NVdOUjJrcitJeW0vN3BTYkJwTUU3cmhz?=
 =?utf-8?B?cEV4RlJta25Hamc5b1BVL3o4ZU04eXdueXduVWxaSWRJaUdSSzZETFBwRE0v?=
 =?utf-8?B?RDBybFBuWWNvMU9vVk1lV2w1THFVMTlsbHl0ZXJ6RTEvM3dYa2hab2JBbFhZ?=
 =?utf-8?B?bjU4dzNEeURmUTV6ZS94TzB3QitocDhqSzlHQ1VFV1hpbko3aTEwVC9ERVRl?=
 =?utf-8?B?WnZqc2syNkFiUU9TSWN4aXFYMDZmWHp4QXVlMjU5c2loTWRza0owd0R0YUsx?=
 =?utf-8?B?YWJFRkhFOHBrNWEyRWpsYzRVL2ROT0s4V2VPNFdoejJNSUlvQmw5eFJmaS95?=
 =?utf-8?B?MWRKUGhud1YwcDJXeHhLN25sY2lLMXUrZkRpN2hxMVVrMmJoVzIzcU94Mm0v?=
 =?utf-8?B?ci9uYWllZU9WNkloUkJBRmhGRzNtZWFiY0NTY3oyQnlnc0I3eUhhMDROdnpy?=
 =?utf-8?B?dmJzNFA5LzNMbEFURGdKYmhKWmhxSjU1bWdBaUtGSkFlTmVuTjFSU0pYV2Jv?=
 =?utf-8?B?c1Z1d1V3YUw0dXFYZlg3akxGVGxONElqN0Y0VFM1Q3NYMUlnRWs4SmNkcldQ?=
 =?utf-8?B?TnlBaG1FVDNtelhXdWZXR2s3RG5QWWxhOFJuc2c0SzBJNWZLd1pwUTRZNGVW?=
 =?utf-8?B?S0ZGQUZ4U3VXR3dlejIzNXRLbGZoeFhzRVQyQUZoUTNqZk1KR1pMY0NZN2hV?=
 =?utf-8?B?SWlPOGpSWGllenF0NjhnazFmcFQ2OWlFQ0pDY01mMzBJbW1qSDg4WUpVeUxN?=
 =?utf-8?B?SGNBUUVTcmtYVlJZTEoyMmJSOFp5S0lkc2FMcTE4QXpxbXN3QXd2cm1kQ1VI?=
 =?utf-8?B?dnJjbC9wQnB2eE92c0Z3UHFVYUN5Z0lJZEpGSzlFNTljaUtzMTJMR0lHUHdq?=
 =?utf-8?B?aTVFTWlrWVdqS0tSSEk5UXNaTGR2QXlFN25ORUpobjVCMnpsd1pkc3NJWFlm?=
 =?utf-8?B?eGswd1hGM3YwekNyQ20vQkxmWEtuOFppaTNlbkFqcEVxTDlpY0U3V3JibVNQ?=
 =?utf-8?B?SDh4YUc3N3cwd0NKaFpDSkNOdzI2YUxJOVdPSnRlaUN0Skg2eGlqVThhSUYx?=
 =?utf-8?B?SVAvNmxoczBRemMyT2Rzb3JiYlExWVlpNHBpUFlZYnh4bjltc3Q0SG95clZ2?=
 =?utf-8?B?Y2IyRkRRSWhLempuSDJzTGUralpiZFRnR3ZXUld1NjhocGdhZDh3QU1kUHdK?=
 =?utf-8?B?NDF4TE9wcDhPSFBuaVd6TExOT0pURXdSNjNDcWdsenF4SVZ4QzJsZW5qc2ZV?=
 =?utf-8?B?L3lXeHhubzZmNGJKRXoxSjNZeHJuZStQeFlSRG1iNk5iMHM3bFNsVk9xL2N1?=
 =?utf-8?B?RjVRZEF5dWIwQXp4Q1RXWkJSdVZFTTB2aHBzMERGSktqa1kzNUhRamUvbC8w?=
 =?utf-8?B?ZGVEZ0ZlbURidkFtOEM0WGl0dC83M2U4S0MxK3k0cERvSUYvbU1VUGF3ekxW?=
 =?utf-8?B?eWh3NTN2Z1pwSy9KUkZNTUlaUjYvWERlNStaRFN2NStuek9sN2JEVUMyZjdm?=
 =?utf-8?B?MnRVNlNta2xDNUxnVlhOOGlreXdyUTV4dnZlcWY4ME5INmdqQzRSU3oyOXFC?=
 =?utf-8?B?TGhSWUhUZTE0ZElCTFZSNkxnT3RTbW1YRHZPTmZRZ2FUZFAvZ1lHeUNYL2oz?=
 =?utf-8?B?N2ltQTIwNEgwejBaSFMySUlzZitkY2FXVCtJRUJJRnlkV2IzS0ZvUXNSY3FW?=
 =?utf-8?B?S1pBeFJSdTBTUVk0S0VHRVozUGlDeG9yN1hTR29SUFhLNmNsU3FnRHRFSVh6?=
 =?utf-8?B?TGRGL0R4QnBRYTIwTWl6RVQ4T3lXaHk1bEhBbFVqZ2g2NTZWVEtpalNFbndG?=
 =?utf-8?B?VmdQSXoxMW53YkFoY1JxRnA0RzlEMnhta21TM3c2OStzRUNlQ25nakZwRG1H?=
 =?utf-8?B?QStFSzJudUlpUjZFMlNYd1BoT0xqOHdiZ0VSUDBjSzBDR3RJbDBEWkIyUkNz?=
 =?utf-8?B?cFFyZ05rN0pmb1JzaUVLTkIxeEE5WUZUdk1JVk1tK3VSM0hmY0k1bmJxdXA0?=
 =?utf-8?Q?ya1dHSoLrQTloKLU=3D?=
X-Exchange-RoutingPolicyChecked:
	rr1uqcPKbMg7wOQDtd/fQi7OF8SN55WRQUmKPNLgGb2M8jbne9INky2zTTQgkEu9PAP+KixeSlDGFVJ4D6kI29ZQDswig5WJF1HwSWLqaKrioGZ7zkGVkL1Hf2AZXzaPPLa3S2zSuuIi5rMYhd8w+OeW5A4u6qqnD76JerQ6EXRsvz41Wzslj0Qub2BANqPg4cwULBhna+d2HJFiU8YI2A/dgSoeKlLoxkcRcFdAXwiiJZmSEwIOfWnwRw2wUUnKwTXu70BJcNsELTOU9jhOkneZE6NTQYqidDe22Sinc3EbquXlA9WDnYQyZkaJF++e0E2V1ZSsFjp/v7AMECrxvg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x3BSRIH1rhCSvSPOLNEkRANadjxBsaVGlvM9yl1SDVcz7coyIKte8mTXmQRqRi/agAqStJwH8poH4z8BdDWEioYq6rppi0BFOhS7DEY/HaX0agENh/xo6x/rA6/lQeXqvy34aylhwlnDWHF6goEbYLRtibxnH6oU/Xp2nngp+doYeDAoF88qIWwfkC/zuV8EChFe3FKz5usbbIUo67FPjqL4/D9yc4yzjHTmg+jcqnDjGpwe7CBeNfysfcgogfbbWXwpiitnHM+rRjpuju2QQGiGqeV1wk/nGoYW5pNz7f6simP+Ev9FFRzXzKFsp8TjP/z3dg8ZX+0UnSaotbMZEpB4g7gAhetl21hMroAK3wivcRstQgzj45WIjk7MpAQiawgD6hwZp1NoqvNpGSTzXvx3VljVYtWgMNhsF51tnNB54fVF4yV0OrRTs6RZYlWQrDjdQ5KjV2YT0o5JOIAOBUkO8Pap1EISKpjas+wXtUFVPIelFlePNf8m271M5qVKOKi73z8ajE+CfOKADDZISfKi29occI1e+o979YemWS43daEUesBOQ3h2LZtuy123OI/1rQhQ05+nx9hsA92yfaDt2Yo7DbN6ZNS39gAoXrY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acdbbade-7e44-42d8-9c86-08dee8a6bf18
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:40:00.4021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RP2PcA/TOfDLjsogFMbvY4IGyxZBV1Qu9MUqJl41ssZmOYhyI5/cKKBrO0+uTe18DpcQXQapcBcAnbbE4NYfiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230105
X-Proofpoint-ORIG-GUID: oixFt_WMWYnPBbb1BqHw4QARrgfGzWub
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX/O2CgBT44sEm
 wIHX/hlOztChTkH6o+pTDJXQpsYSFKvtblm08KdzfigkBpa2qwBFTcN8aEmubb8htYeJH22j9zT
 2jJGqzKMynyyv1gCDttphW8qJeXLV95oHglvMZFZ2DGdHtA/VV+4s2Jtr30rt+WCDMuy67LLU8Y
 oqc848TgUmcrglvfiRrS2zmc+QMonthSNJlPEIP9Q/YbRDxMX8Srhr+oZfzU0r6mYAR3j86fFEX
 iN5MHuWyTGG6vVBwPIxttdGKlUsPstELM8WazK7xbMVHgLVEtDUAtg4l/C7TBbCVzXdDzfZPjMg
 3edzxRKtRLne518VPz4xp54K/ysPUAp0KHK+CndebZzASpMZYQ5kIt6WHKbwWcPYBECk2rRUaSV
 dJVJUfcBwT17DnRLMTbc/yHI2NTAWeI0S5KyyhNcnZO7v8/BhmLZCO1bR+bMxR85b4p+ZxJr8CF
 bG5l9HR0iJ4lA6OMjeZDMeMPZPT3nWk8/J6uXaAI=
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61ef85 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=BBmZeFGkOafRQ-eAW0UA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-GUID: oixFt_WMWYnPBbb1BqHw4QARrgfGzWub
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX2H3MJ/jEq1Qw
 h3qn80P35gCsVM7OaPwhlLOZWqBckji3/eBz+rm+/LB6bMYh8UclOr2E3+Rizt+oLqVipUdCiFu
 dmhz7ofXZ1N64SItz7WJhgXMfnOluD7B6VTY6xj75DJYA+ly5AZj

On 23/07/2026 11:15, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The multipath head disk fails to initialize `nr_zones`, `zone_capacity`, and `last_zone_capacity`, leaving them as 0.
> --
> 
> --- Patch [8]: [PATCH v4 08/28] libmultipath: Add mpath_bdev_report_zones() ---
> commit 62d62f772c0199a5085c139be78e6b1dcd14b410
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add mpath_bdev_report_zones()
> 
> This commit adds a multipath handler for block_device_operations.report_zones
> to libmultipath.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 3ff4f42a096c2..0232f51f64742 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -44,6 +44,30 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
>>   
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static int mpath_bdev_report_zones(struct gendisk *disk, sector_t sector,
>> +		unsigned int nr_zones, struct blk_report_zones_args *args)
> 

I may just drop this support for now

> [Severity: High]
> With this function advertising report_zones capability to the block layer, are
> the zoned attributes for the multipath head disk properly initialized?
> 
> If a zoned block device driver uses the libmultipath framework to create a
> multipath head, path disks are added via mpath_add_device(). However, it
> doesn't appear to propagate the zoned attributes (nr_zones, zone_capacity,
> last_zone_capacity) from the underlying path to the head disk.
> 
> Since the head disk is bio-based without zone append emulation, the block
> layer doesn't automatically trigger blk_revalidate_disk_zones() on it. Will
> this leave these attributes at 0, potentially causing zoned filesystems or
> userspace tools relying on bdev_nr_zones() and bdev_zone_capacity() to fail
> or trigger division-by-zero errors when querying the multipath device?
> 
>> +{
>> +	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, ret = -EWOULDBLOCK;
> [ ... ]
> 

