Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7DE54705D;
	Wed,  7 Oct 2026 00:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791332095; cv=fail; b=kPD0RrAERoE4v+1KhbUiVf2f5YCihDqXbmaGGwuUC+kFOpYmuYPR2+u4diNF7eErXvxhUB7J//Hr8ZQlQB4WaVlWXYMjj7HoNhBR66veL/bBuyandmhjfqcSX7MzQ2f+RuR8XuEjlE81FGFCkPAVERrjUE5IF22zqa9hCNu87tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791332095; c=relaxed/simple;
	bh=qlWyVdlTnEjGags6aVBP4EJXFrA/GGgTBQ9SdNlEo2E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pGjm6dkp+fLouKnAZfYK+gkOGGrT4DgZrOktmkH15Ex56uXBa7lU6VWqQBR1Clj94GvaDXmhe1U3y45Eddg+qwQpNST9/qW3FyiIN4w2f1cNuDt+5ToPCBHP+jvEF1GOxMCtNG029kIIdu9BUj118/6M1kr8NAkDZY/YTzJfzW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I4wYz/h9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wCTY4Q22; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I4wYz/h9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wCTY4Q22"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696LavmA900730;
	Wed, 7 Oct 2026 00:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YoWiOkSp30tv5qyhkxQH3xPiszp6KJYE5/RoVBqSLWc=; b=
	I4wYz/h9VztZtbyRuqlFF3ZDqBtqQ3IP9qN+D4NdvZylSAxknm4ocuKtuuLz5HB0
	a8UoLs8NG0U1X2bjMnHww9A1KeCJP1wlrvRR2Dbj6td5PT70P92be4CVgh8UhVnQ
	2reXieAiEd9pTDIWpKvrhp02dM25nFz/+5VWT9Syw0HOMEiJSQ45lKIWDSZMkgi0
	fTG5itEsvlzQlSrjJpppqpt4Prkd3M+IAWlYpMOSMl/7C0qbUY5Olx3C+vCqXMgG
	soPX2BOaRAZI2Eeo+MNYfH5OUBpNuJmz8o+sJ5pnOoKekQ/0GrJ04/75ugEHbmbB
	BpCZOWZnj2xywJBACW+1rQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2rg1vvt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:14:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69706o8Z019865;
	Wed, 7 Oct 2026 00:14:47 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d4w95rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:14:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1OH0Db8WZeI3lgf4C0Dn7AdAQob2hxwK31ylRHpm9pfUJwSh5z+ZzZzAkU1RpG/N8sNzB78pgGoh9Tw829dvSxEvBJxHDx54lYBqNtp+vMnL/XOxrpXErC2+ohHI2+lNVFWFDlqbP1DsYoDjudDU4ls96FnK/Kxn7c7QfniOSKhudv083bAvLovedX9/02mgMAY+Uva2xK4EXPicE1lyHMPylrWYErMyvhvGNdWypzMokFLVRJWSN7zQqYp3oFzOWrWCBUPslntLOkcjrRK9baEpEeGZRkRi9Urrs5DluBt0mgzyi7T37h9ET3RsUNyzfeckyaVaTw5UZxscis1hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoWiOkSp30tv5qyhkxQH3xPiszp6KJYE5/RoVBqSLWc=;
 b=e7fv1v16OhDAnIvPdQmerhsCreFwzCnU/CLFmPykFA+Vwj4RjHwjTULYDnl1NRg9wpQCXsbbgDekVTAz5APAHjljOrzj8Hs+Rp5XOdZZ39Hn/6JKFNLZLBrG+XKG7vvZ7MH3paDyc2g4VRIGD4xrfQrRw7PQyImm7QCeZ5SxFZciO3Q7Amu1XjRdyzxTqjnjHay2wgWA1g6Y+oRaKXMbrSrJby6DrydXylm/8kbvxx2VgOjNMsEbWhvZtl8or35svie8+fRAsbTV2C6sfIF/6K6KkLuWmK5t5CyyRaz0lf+TPSj/yk6MnzyiWsQHopsVgZNsMK4ndq3SPb3FsJqy6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoWiOkSp30tv5qyhkxQH3xPiszp6KJYE5/RoVBqSLWc=;
 b=wCTY4Q22/djBHKVtS0kqVEqr6PX2dSEaCKE+bZIOvxT2dBJrgtPxi5i9URuTaidM5Mqt/w5578U9duZcgU00IrbWrkt5Cmo9syXZ76rh7k7NfB0/agSZxNAG667vWy8vSYMXWH5GzGDvG6b04sWXJBELNbVVPFtLif3heHk0Jt0=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by IA1PR10MB7537.namprd10.prod.outlook.com
 (2603:10b6:208:457::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.13; Wed, 7 Oct
 2026 00:14:42 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:14:42 +0000
Message-ID: <838b7f04-d76e-4b23-a37a-d755812c5626@oracle.com>
Date: Tue, 6 Oct 2026 19:14:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: libiscsi: validate the ITT reflected in a
 Reject PDU
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, lduncan@suse.com,
        cleech@redhat.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
 <20260804040546.2264137-3-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260804040546.2264137-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:8:2f::28) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|IA1PR10MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: cea7a65f-ab9d-471a-54d7-08df2407fc44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|260925021911599003|260925021311599003|5023799004|10067099003|260925022911599003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	k1khOakTq7FUn+7tj6hB49GsFEFVtK0EcmvJuSh28z/QPj8kXQov1jv9uZ4zv0IorYHqfDrqcoGiPGYucLssLpSy8tA1emW8puEnaUidbmt6FK1ZE8c/3XOf6BkGR5CuyARIc32UcSv+GD9yfWVtRTHrbAqPji0a4VlVqYmqoPH83JaHLv/3ijtwF6qgiasA2fnAZYpfX38ZMNQEsDOipIz/cA7tq8IRZsGgvTZ8k9XRKGHU1w1ndms1qskxEhkQP6Y1SUBESDvtcg6bm2Y73qgKl2xT0JJMZ29u7ex2o32bIelxPbxZoZHYS1R/kv2aqJeNjVRIlr6D511erswOLizllCI/B9je3cb9N2epfM8bH0+AxJYzet3VdTpp8vnCJQQmzMHQj+QwVJGAs5npM+DzUZKfN99u7MqiKhd1bmEFR42hFlRwB+Q2lmCcZD6fF0Jbns/3vGsDMTh6qxnvH+QYGEaKkd3FT1y8C1oe4W4KbNfV8DV/LEbQpMpuq2YnamrGvBnbx5wLuSNWsAUG2tTpIbmDwVdS1Kr/6RDL6xCjt7QlEBQtHrYA3xvu5aeT7IZLLm6IWXBy4Lp/LZGmA9VqD4C7vtrZymF7DFm8Tddklc8YZyKDvGJop8UylPjmcZ8liUE2P1TnFGgjpGT1Wa8iTMWUSgynDTv5rFJ5NAY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(260925021911599003)(260925021311599003)(5023799004)(10067099003)(260925022911599003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUJ0a05MQXEvNkF2cFdFWHFtOFp4UE5LeGZhRkxXcUdRS2ZIbXZRY0ZNNGdI?=
 =?utf-8?B?RE9ldFVSS1ZsRkpZUWVPdlJES1BycEdTdmVBU0pES1h0QXp6Q291VjRrYS9j?=
 =?utf-8?B?UmU4YzBMRDhwUVl6TmtBR1B6YklURTAzRlcyZlpJYnFJS0s4RzRVL1IzOHYr?=
 =?utf-8?B?LzRRMzg5S0RXczQ1TzZzRzNqWmxTOUZ2Y1NZQ0d3Y0dGUkJPekhpOUE0MmRk?=
 =?utf-8?B?NktKY1hkTVNUWUkrK1lVenhabFlSU3ZZL05oK2xPVFUySEpWQUVmNzNjYyth?=
 =?utf-8?B?MXl1SGVUb3VRVXYrazFYWUFDcGozTVJuYmMxWVFXMGZpdWI0dW1US1pKcU1z?=
 =?utf-8?B?ZnpaOStsWTNCL1dwVjB4b3pPek05WnNkQjZzS1liKzRFZjFlOWtuZlhHd2pI?=
 =?utf-8?B?a29HcEFNUHROWUJFTENQcXZmU0Z4cHlmeUxKWXhTYkY1S1I1dldCOU1UWWYw?=
 =?utf-8?B?SHJFNGVrZWE2VVUySk5vbkpScWx2WDJndENsSXord1N5bWg4c1ZvdmY4TG11?=
 =?utf-8?B?QkNuYkp0S3hzWVNNQWtPb05qY3pKdmx1bnN2K1ZVZ01Vd2pxMldxYlk5cXRN?=
 =?utf-8?B?ZnJEY1FPR2Q3WGlybHFXRjZSOWxGNnNha0g2VlJGdWh4a2dZM05XQmdvOVAy?=
 =?utf-8?B?ajlXTWZLaTdVOS9CVmVvVG1RTGp3dHVYeDdGUDFFdXJmK0hwZjJEcEQyNVdo?=
 =?utf-8?B?VDBLWkhVTmpvZjFka29xYU8wS1Z4UytLWUlFbmlFYzcwMDl6Tm5rUDF2Zisv?=
 =?utf-8?B?aEE0OVN4TDMwMFZDdjFJRzVvT0RJZDRaWERPdTdqaG14eUI2ZC80SXZXL0tN?=
 =?utf-8?B?UEpRNXhHcCsrMHR4T0xrenlFSFdiSXdCTFV5dzlnSTJDbVl3RTNqL2tweGlO?=
 =?utf-8?B?dGtOUWJxTzNBRjNaa3RQYmp5Z21MM1h4NWthZ2dEMDFtY0Y1S2hMWGlYeVBv?=
 =?utf-8?B?VmFTYllJSVE4czFLemZERko5Wm5GM0hTRWlsQlkwWWFMTk02VGNnMGFxbVVB?=
 =?utf-8?B?S1NjOWFvL1lySTdGcGtQaGNKVE9tU2NtUVpjcGdNQUlkaWtNSEdMaERpRm5i?=
 =?utf-8?B?eTVQRWN5ejI5WW55ZzB6b3Rtay85aU5xUVBDT3lwNEVBZ0R3Y2RvWWluMHBv?=
 =?utf-8?B?cUNKWGFZRGhiVDVKT3VNNWRnNVBSRTNkdWc0U2RUdEtIRmpKY0x3TGNnaVNZ?=
 =?utf-8?B?bGNRWUNKdk02NmlPNEdXS0VXbk1tVlVucVlRdXZ4azFvY3RRV09ndEx2Y1Vq?=
 =?utf-8?B?M1B5d0xKZlpxS0FsZzVqWnNmM0lkZjMwOFh6UnVmejg5ZUpQQ0ovR1paaElG?=
 =?utf-8?B?VlBjbDNnOHh0NTB2UzJjWTlQZ0h0YUFTZm5qUkNYMFJ3OU5LT1A4VnRidEZ3?=
 =?utf-8?B?dlFZRzZxV1FpYlpPWWJ1NCtrS253a1JDNGNBdjJQSEUxMHhHVENkQ2pjRzFW?=
 =?utf-8?B?d2hjQkhNWHhWbGxkZlR5dys2ZzB4ZkhKTHRLSmo0TkxaamRIbFA3andtV1RH?=
 =?utf-8?B?Q25xNkp3Q1JROUNtRUFDUytDS0lzMDhYWFFkNk5meHkvL1ptRmNaMU1LMEY2?=
 =?utf-8?B?N1NScW1LOU9zNVEwb2FjMEo2RExPcU9nV2V5ZU1rZVlRZTlsMzR4d0g0Mkt3?=
 =?utf-8?B?eWZlYlR0NU1iNlBob1BiS2pML0lhbHk0OTVyYzVua0F0TlBwR1I0dzdRSk11?=
 =?utf-8?B?SGJMRklDcVI2NnFaK3NEZHJOTHl3WThiZ21WSW9qSFliQjFEV1RjRUV5a2dK?=
 =?utf-8?B?WGNENFUvVkU1N3ZEQWNzV2EvdVRNL0E4bmJwZUNYN0VUVTVBN2VOUi8xTURo?=
 =?utf-8?B?ejZacG1hVWdFc2EvWHlpSG5Md3pWbThDSlkvT0JEUjNGYzBhNjUrbjFmSUIx?=
 =?utf-8?B?aXdiRG15R0xNd0ZhRnN5czRxRGVvNi96MFZKZGtsMXRqWUNTYTFGRXQ5WXMr?=
 =?utf-8?B?eE82VHB5aGpuUUVtaVliQktQc0hscmdneUFIbGJlWVdSSkVka0ZXMUtvaldM?=
 =?utf-8?B?OXlRRGxhcGNHdVROaXBjUDlBSHV6Sk5QSFpORCtVSjB6YzExYkxTRTcvNzlS?=
 =?utf-8?B?OFRxdEU4TVc3ZTcrWjk4OWU0M3JoNDY1bDVWM05iSDFrc1FKQ1hGVXNHeWVN?=
 =?utf-8?B?Q3M5TE84aXRYcm9JdGpTdFMxYzBBUndLRENlZEN6Y2ZYck5FaXlqdVVsbFZx?=
 =?utf-8?B?aGh3WU1XTnJRdXVHQUdYU21nbldRUWpucXNPbG5QRTJPSHZ2TDFyRjN3V3p5?=
 =?utf-8?B?SkI1aGM1eWJJOGRUTWRHV1F4ZDhSZ082emNRUkVGenJ6VkN5eWgrVDllKzlx?=
 =?utf-8?B?dlJhaVVWVm53NGk0U2Vmekl4enNxVkhkTmUzeHJHcUlMRE4wbG4xc0w0OWlB?=
 =?utf-8?Q?60h4d6+DDF6XQc70=3D?=
X-Exchange-RoutingPolicyChecked:
	zGOECdz8cuqFHvca19FGrqcpqQXAytd5fDqmjvNHunrmLNwgn68XnmOt3/zJ+mPklCl6VYFMNAc/Miae/bYNw+Ui+zMkoSC0CNutkw9YNIdGRutHdZK9lvPAeyqZ7qxdGGmg+4ZljFEiycNlsyWN+4RjUg7J/JTE1NttGT0AisATBeeLeJQWFm1wleK89Xi5165qVLWPqJmTa2ADrmtOihay30oSg+tUIHU4P4faafBdTwjRCb9uUb9frv2USTAXdTiIxEu0Mkozh/AeoAdb79IcAqPCC51cA5/AEJo0pjiNyo8MERHfJGJ9lc9l7f9AOiaCj3IZwYHrRSirAOtMZQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8aAO3w8dlzQPkDTjhNnKIhcv+nzVUGN0bUmOAcFLv1SewPR76GssA4hc0iXLXsDdRG4HOUYpDsi4GfHhGZXsK+aKRZTI8sqUCnhthheLJTOTJtbhkNqN8+710CvfLwtkId9hUpv+V7JGVMHiSPhyBflMHdA5uSJ7+I+6+yIz3cKB1Dpx3AlZu9aEN2tGqREycOinmf5xR2zCiUAtaMS59iKfPGfUKJnmtNlZUkFVLJkoPUBbz3AhJJdHzZV96iAgMaABBjnZ0OyEi4hJIR1jwC8WmRFlOav4mesOctyHHmZtWVyqDMsG5zxM1WF24XVf2eTRT/tEWUFI+X8IgxQ6mgRbyHZFSjqXIQew7yFIzV0SLI9aRWngmZQK08dUSbp/cNxzi0yFYjdUMwgedVGM3cCR8I05HIp/vsGKg+0aJS1I3Zhk8nEyqq98haA7fREBQsn91KhOzD+bQM2SG5SPvWUqmr31qlZpY8M0fYXv27Bg3dCX6LA4zCqOZuDghVZ4sTng5uXcC9sOLdG5Q8Z7FgV+Ho256Pw36L40OXOy8MdJiJuYSc6pfZZd0VGrMJTlPWbPRxOHP2rrOZYx7fvvuZAssrdbhHIAtmNtTLjdeG0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea7a65f-ab9d-471a-54d7-08df2407fc44
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:14:42.7348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jozco7Nv60fe4IXoxZL7jSWT7T48oMo2yGRdVnal13h2+SRi9zhR7ROhz/6BPRMmfW3tffZPpKdyUxOTQoXNwOAa7kSSM4xsRKMktTqBuRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7537
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610070000
X-Authority-Analysis: v=2.4 cv=afj0Dhot c=1 sm=1 tr=0 ts=6ac58ef7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=GV3TSIPuBumZIY3Boy0A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX9j7VTWVzf1TQ
 kuE9nX1rHOFkfVlxUtWaudESku31Hnuf4guNDGKaOXKckByZ9pPkTGWUVjbbVpEyOadtVFbXTI8
 C7sZp45PcIiUXMT3EU5F5eyMMIdeyvC2jZ6adZcWPurPXXOlOG8Y0/pAu55hA/Jq9MWAOZ2Udub
 AkKfuOsEMQMrrULvH9mdZgAsFal2lCZkomErmcOvulkqJIAQWtA6aPL6XChASXUqj+EfcRrHzyT
 lNBWLAcVWad9tDA3dX73SlgEwvWsu0ZTOK0ejQC9vumKQb4Ov/ELWXCVx4LLJ444VSWgzkv7eld
 1y+fsq5qRbM7YT1q3XQK7oABUEuR/OKfaWU1etU940sKmseEii3K8XoAwIlKqzF70QLm6Iomdzr
 Y0oWWAJ2kSoClyOE6HlUZ8NueW/GVa3wIpq5r54CvUEkxIe/MyHadBNzW7Shx5cmug2zxzZulxt
 qOixYhkJWfP7sjkFJcyNuq6uomDiCp/ofBHQ8IXQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAwMCBTYWx0ZWRfX6A1cjhtfXGfG
 d4utgzg66ScgoDHwl2z+PJSWvbgm8/txrKXN9eD0l7dQPxKQV5+xQuwr85Ixs89hbEuQ4ina6l5
 2zj2pMynhw4QTA1mzYB/Bun/nYjEVUnrA+WeLXSfXFcmkdbBi2/g
X-Proofpoint-GUID: lKdsswx6ZjznMmuQly8r1giyRMv-YQMJ
X-Proofpoint-ORIG-GUID: lKdsswx6ZjznMmuQly8r1giyRMv-YQMJ

On 8/3/26 11:05 PM, Yehyeong Lee wrote:
> A Reject PDU carries a copy of the header it rejects, and
> iscsi_handle_reject() takes the ITT out of that copy to find the task to
> clean up:
> 
>       memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
>       ...
>       task = iscsi_itt_to_task(conn, rejected_pdu.itt);
> 
> That value is whatever the target put there. iscsi_itt_to_task() bounds
> the index against cmds_max and checks nothing else, so any task in the
> pool can be named, and iscsi_nop_out_rsp() then completes it.
> 
> An index that has never been used gives a NULL task->conn: the pool is
> zeroed at session setup and conn is assigned only when a task is
> allocated. If the task was used and returned, iscsi_complete_task()
> hits its WARN_ON_ONCE(task->state == ISCSI_TASK_FREE) and the refcount
> underflows. An in-flight SCSI command is completed as successful - a
> 1 MiB read returned 1048576 with none of its buffer written and no
> warning.
> 
> Validate the reflected ITT the way iscsi_itt_to_ctask() validates a
> command ITT, and require the task to be in flight and not a SCSI
> command.
> 
> [    6.248477] Oops: general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] SMP KASAN NOPTI
> [    6.249357] KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
> [    6.249951] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted 7.2.0-rc5-ISCSI1-gf5098b6bae76 #1 PREEMPT(lazy)
> [    6.250718] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    6.251616] RIP: 0010:iscsi_nop_out_rsp.constprop.0+0x46/0x160
> [    6.252043] Code: c1 ea 03 48 83 ec 08 80 3c 02 00 0f 85 f5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 58 48 8d 7d 60 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 00 00 00 48 8b 45 60 48 39 c3 74 50 48 b8 00
> [    6.252813] RSP: 0018:ffff88806c907b80 EFLAGS: 00010206
> [    6.253042] RAX: dffffc0000000000 RBX: ffff88800607e000 RCX: ffffffff8d571a25
> [    6.253345] RDX: 000000000000000c RSI: ffff88806c907c38 RDI: 0000000000000060
> [    6.253642] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff235a504
> [    6.253947] R10: 0000000000000003 R11: 7463656e6e6f6320 R12: 0000000000000000
> [    6.254251] R13: 0000000000000000 R14: ffff88806c907c38 R15: 0000000000000000
> [    6.254549] FS:  0000000000000000(0000) GS:ffff8880d95bc000(0000) knlGS:0000000000000000
> [    6.254887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    6.255140] CR2: 00007fc393e8ffc0 CR3: 0000000005252006 CR4: 0000000000770ef0
> [    6.255439] PKRU: 55555554
> [    6.255564] Call Trace:
> [    6.255674]  <IRQ>
> [    6.255768]  __iscsi_complete_pdu+0x18bf/0x22a0
> [    6.256733]  iscsi_complete_pdu+0x54/0xa0
> [    6.256905]  iscsi_tcp_data_recv_done+0xf4/0x250
> [    6.257103]  iscsi_tcp_recv_skb+0x31e/0xec0
> [    6.257680]  iscsi_sw_tcp_recv+0x12f/0x390
> [    6.258061]  __tcp_read_sock+0x1ab/0x810
> [    6.258853]  iscsi_sw_tcp_data_ready+0x18b/0x510
> [    6.259808]  tcp_data_queue+0x1f13/0x4cd0
> [    6.260567]  tcp_rcv_established+0x8a5/0x3a00
> [    6.261931]  tcp_v4_do_rcv+0x449/0x960
> [    6.262269]  tcp_v4_rcv+0x2245/0x3bc0
> 
> Fixes: 8afa1439fcff ("[SCSI] libiscsi: handle immediate command rejections")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

