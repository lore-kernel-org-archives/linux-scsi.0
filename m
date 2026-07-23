Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677F4380FE5;
	Thu, 23 Jul 2026 11:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805345; cv=fail; b=KTwgLBmBFz7tTpmKei3XVB4IdHo9aI5WTkqV3lbpludye8XUOBr1KzmVKkRUMipPzXzkos9DjJQDXQtx3+NI4WjOPnLFl3qZiabKKiy7NYdr74OjLyFHkxEd2IqkP1Xy6voMHI9oBaBP8Gw6ENqs8ZpKCVcLr3DYSQg26oCqPuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805345; c=relaxed/simple;
	bh=bT0jkKPB8G/qhJIxuQrci88zdZhbHQyxBnC1ezKbLG4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DjCdL+32exsLgcf+clp6Bz/bA66fQ68kiDojf50yPkUtCQVRRYOS6oSCtZbQXOKGR01oeoMBbN7LYLaxY7aLYSqn4xesUWr70BE6dYgxnM32lx130qiD9xhXRSAeOzaTIBm1loyNlV4ewQ2cvpGWzGAVMq6NrHb4Q14BZI3GxjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R8obbjaT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u8z4Gi6R; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R8obbjaT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u8z4Gi6R"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtiJT3353534;
	Thu, 23 Jul 2026 11:15:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mQB6yo90HRQfMdkMI2MxBuYB7/sMFlmoeNN4p/oqpoU=; b=
	R8obbjaT/bspvk2eSr+RGyjJh64nHhEviQhRm4ls4mr5L6SxSL5+4P895ffkAWMV
	9Mymszk+pxjIY7vPUGqA4POwy3FNRZZV5WAWk9IjDRyxazsKw+P5NAyrtPQoLF8e
	Qrzdmoh0AYonHA01k6Rm7CAeLgSLvCjZcR4Oi39+f91T1eUl5x1p2bqFK7x+LSod
	E0UtIVBYItkYtSzbqN6Y4zx9TfnC62kfldiLbz4SP5VTJlgLmsEiOHtA+11tbxi2
	l2gD4Cht9Sc89hgoTD7B5ogfLohjqva92aXi731U7I7NK2uoI+VT6mLgTkWO1Iip
	dlqQfhGT4b6wXl4QwKI+sQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6px3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:15:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NB8YtT002758;
	Thu, 23 Jul 2026 11:15:42 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs8aqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:15:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rt3Ugs60Vq5qH+64BZDllUumaJtRAwPm4jGe1gx+kkN4VoioRvDhk5cDpsAYMRfHkZN3t2J+5ixqG7h7VEDVFPwsI8n/iXVjUGn1i20RRnuSHp8g31eO4rQr1GisYgVt4ZfopvF1czd10lxcxmzV3LvH0v7N8nWdiRVpkrVnNj+aF/zTdeiQxG79QJS1GGjcNwwJSeiYoMO2kT5XqQBlR7e50xLlvyVgnfGuMCD86vmd2UzHAEeXj5Cxa2RUujOi8sdhH0XNmS8p7drvyCL0gJ7EwJ+eaygh1KOBfUr2HKcmbHmHmLCKQ1kcEJxmx4fCWiltlfWUiLqZvoJsm3T0aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQB6yo90HRQfMdkMI2MxBuYB7/sMFlmoeNN4p/oqpoU=;
 b=XvSykpHamIx9gT3VRaY1XcQlihtXtGSuMQeNrBLkHJ1pvvVbrwNoZbQGfh5Au9+1Qj6Lsy2ygUlshYIcRR1QgvTDuqyedeMfwoOq6GqYn1qtdYtb7TwQaEWsXvnMlbzWPa+hk3UY3E01jxc5tJVdgpkGgYyGv4AtrIjmhPBBGBKGXn0OhlKiC+AvzdEGZdaiMsQa5+bVT6qxPDaiJW+SivI1yKCRMfTT7t9vGISM4dN2+UI5wuLfdDeXjVN4TOj322N6xpVJxEtUhEqnNG5QXNJ/0kEuqPoLNFC50Z2MtO1oJ3IByzFFD6KuJzlfPOLF/NY1PQWPdQzxMTDRQ6VbUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQB6yo90HRQfMdkMI2MxBuYB7/sMFlmoeNN4p/oqpoU=;
 b=u8z4Gi6R/eZXh8KDws2wzuM7fyxnXyRzdyWpJeqgwxY2dYzgFk3yLp0d6L5q+IQgxuGUwOjl9YHori7UmyFXu8BPnC0eQqlE6jm1bTzWNiJkcZnZ9+sZmQbtGBspf4YX1/p/JDgW0CvCHot4OxWyW9yyX/tokRA+zBnFoa5a9qs=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH2PR10MB4279.namprd10.prod.outlook.com (2603:10b6:610:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:15:39 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:15:39 +0000
Message-ID: <afc07590-272b-48ce-a936-b3df56ee9ae4@oracle.com>
Date: Thu, 23 Jul 2026 12:15:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/28] scsi-multipath: revalidate paths upon device
 unblock
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-19-john.g.garry@oracle.com>
 <20260723103904.43CA01F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103904.43CA01F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0324.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::14) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH2PR10MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: 60a28186-f7c2-4ea3-c275-08dee8abb9e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|4143699003|56012099006|18002099003|22082099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	VoU4IGLqaX4DPbsiBoThHcs1UrxgJSXXL5UlJj8TIVxhqoV1h2bgb8HZFrdVOSPz++o65Xm69QyXUbr3adlUEBm2zix3I0AZkU474fLoEnMfAZkXHa4S4m3kK2qEj/ZOHDaEa8oe/rIMXfkmddxv1kPh0FzQJ+hqJ5V+rjIiAi0JZTIjD1x/n6gl/olYzoCiS8k8KWV5b4TXXbKTfBuRpDiRA3H30sA3aAJhmC3sut5AWDyKy1kLJHU7kLaTzwS0QBdrgJmqd4kOlyspgyILIeg1IAYekXZXw2R3kdCYuJ2ahiPLA3I3m2mQp8Wp7RdEdwzTXY5p/8qn1y6goGL6z4lv7rglJoFtaRyuPvvUpNtoC9nH1XnXJRYCD/nkhMZaMYzIT3aCRAqF2LmEBNStIUYrfA+enh2ZoDpfS7OIhwgtD1ydkYouxWxKl3+oI+2RhtD8XL6Em4tN/TaAPUvLI6S3Cycvgz3XV17Fmwa0wKkWtw6DPHu42Dqa+R9UMFFucXusOV9hMPno6nGDB4nUF9oTm9lHo3oJBNcYudBxUpTq6+eV5gdwhIXSUkmNwsIGIIHbY1mNTSS8Yi8NUjaS9JlAli69h2TH7xq6OVrlwADNc2+FYXneQXaIGevymPcJ50jLPGegwRShVV9YPXwYiW7FlKrgJ0L1Omc0vEwMPKw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(4143699003)(56012099006)(18002099003)(22082099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEtiVXJOelBqeGpwM3NzY3F1ZEJzWnRrU2Y1bWJDZU1HSVJUSXYyVEdHVFRR?=
 =?utf-8?B?MnRjbjlESFpOcWFYdnFzK1EyRUVGd3FEa0FqUkRnUXAzKy9wdFFJaTZsTlJv?=
 =?utf-8?B?NlpPSFFzV1RtSnAyd1ZrMTBhVFV4OXpaMUZqaFlndWtla045WFNUNGE4eXBU?=
 =?utf-8?B?bUhGSWxwWXp4ZmdhNURzN2U3b1BaZE9hQXBJTGd2ejkyS0JzdTRjaGZ0amZG?=
 =?utf-8?B?WjhVTUpaTy9vbzVBUVNmK09JOVhmRzNkd0c2RG1DaGRaWGkxRTUwMG5UczJq?=
 =?utf-8?B?QVNZVW91aGlibDZEdEFQZ210ZlFSeGErQ05PdHRkQWpBYWlHVnhnOHo4dTBZ?=
 =?utf-8?B?Z1BRZHNuK3FzTXhZblRsSFppbUVma3diWW5mMk5pSkJOdXBiakVSZWI4RGpR?=
 =?utf-8?B?eTdKbXYrT3h3NGF2Q0ZWbFhEM2syT3pYby91WERHOFA3bjRHM2ZVMG4vTDIy?=
 =?utf-8?B?aXJRZzB1THpDZTB2c1JNdnVRY0k5andRVXl5MFhPeldINm96d1IvZU9Vd3R5?=
 =?utf-8?B?Wml0dncyQkk4Mk5RY0h5MHFQZzU1SXlyYlk2a3UxRjdORjdMakwrSS9QV2tI?=
 =?utf-8?B?WWRaN3BPWlQyU2tvYlU1VitTbTA0WXI5eGl4QUJVS2J5SDgraGN2Q1pzWDZS?=
 =?utf-8?B?djdPZ2tsVzFNaCt5MzBuYklGTmRNUVpNSnhwaVhoRDRIZ3JIb2pPRjQvTlBw?=
 =?utf-8?B?NjY5RVR0RFNDTWdwU0NKcTF2Q2NlQUE1dDg5aWQ2R29QNFdpZXEvUEk0bVRR?=
 =?utf-8?B?dHl5Y08vbzRRZDVZYW85d2JuK1grVWcyeGxDQTNINXJyWTNIbVNqVGkvQ2hW?=
 =?utf-8?B?cWFZZFNYcUk2Rk96Q0RlTmx4VTVGY0dZcDNGaUIvUHVYQks4RVE0UUtzczNI?=
 =?utf-8?B?WCt4NmwvZjJWRHlqbzIxZUpkeXhESFNRN1ZSOFFPNWprNDRZcFNNUzBPaEVE?=
 =?utf-8?B?YUR5NlFGR2pDd2Qyb05iVi9zTEhSUUtPTUhydlpxbTBMdHFFbHVEUUpIRGo4?=
 =?utf-8?B?a1FUdVRPOWRZTVhUVjYrQTNIaTRUbUc1dGQ1eW85Q2pIVk9jYUNDb21iemFN?=
 =?utf-8?B?cGxJSjhoN0xaZWFRSmd2dk9vdk5mYTBRL3Bqc2FicitsQ0gwY00wTW5iUURR?=
 =?utf-8?B?czlwZ1U1UHhrYVB0ZnpwMVlVdzNKRm5jRUtSMnVvSlcwZjY0WHRlNi9MWno2?=
 =?utf-8?B?dDVxMEJJcm9tbmYxVzI1eHRXeExDdUwxZ1FJRFNCT1BVY0NYVHI3NXp4K1U4?=
 =?utf-8?B?ZzM2ckI2N0pqN3hkclRtUzI1Y3dzR1c1cmpSbVJYT05YZEl1ZEF6UVA1THlU?=
 =?utf-8?B?TFlUZVpKZFV6UlNsUGFTVlhZMEtzdjQxVXBldmcxUE1mcDY3N3JHMlI3OWZq?=
 =?utf-8?B?MFI4dFdMSjNNcXo4ajF5NVQ5bE4wblZoNzU4bkRWcTNXSmtWV2g2R0NSZnhH?=
 =?utf-8?B?V1UyVXZmbDRlcStYUG05V2syZTdSc2lJempkNld0NjBuZTJnS1dzQ2EzSDNy?=
 =?utf-8?B?b2Zpdk5LUzlOS0VKaXFPQW5Oa2NncjJ2dEc1OHM3azNid203MFQ4bGR1T3BB?=
 =?utf-8?B?cVZqUjlrbExzY25mcGpOQU13WXpmVFptaXVyK2dkblRvbHIrOHBSNjhHeFQw?=
 =?utf-8?B?OW5IREZ2dkcvTndqR2xqZmtHbWF2Y3p0UnFDTTVOR1BTRWFkSjN2d3p3dytJ?=
 =?utf-8?B?ZE5ORlg5Y0J6a3lZZzF5ZlNYTmZvY1p3TWtkU1pIUmJ4bDU5VVlxNHVyWnRh?=
 =?utf-8?B?UUhTYmJOYllNRDQ3N0ViNGdkRXZCSG1CdnRydm8ycENuMGlxSkxkUFk1cVF1?=
 =?utf-8?B?c0hLNzRSZjdNNDhCU1hyNGhHbFNiRzdpZm1jN2lDSTZGQlVVWWpLRkdaM2Rp?=
 =?utf-8?B?TVNIUHh1OU56Z2I4WWloU3NNSFNEZlAwaXdtNGE1T2RXbE5MM29YenFJQnFx?=
 =?utf-8?B?K3lGcnFiYzJUaTRNaWd6cmtBZmxCQjV0RE5zTkRtbjJPa3JReEZ1SnlFK3dK?=
 =?utf-8?B?cWxTa044ZDMybktvcnoxNFhSU2hsRGhpZDVuYURpSndVRjlBbnlCbnZuRTB3?=
 =?utf-8?B?dDc1MkM3VGUwVGI1bmNwOTl5aHNGVWpxTmxkTlhic0xtRE5GMlBuWXR4MEYv?=
 =?utf-8?B?L0xLMitDSFk5MDM1VUw2YVo5dERlL2IzS1o2UzEyUWJZdy9IN0w0R3oxQlNG?=
 =?utf-8?B?NU10S0pxY2FhOXhXSU91QlBpamxpano4enNZajZmRHNwM0pQQ1BMd3N3YXNa?=
 =?utf-8?B?ZzBXOUVGTW5WeUxLVFk2RFFjL3M2cXgxNXcwcEFxdGhoeFUrTE40UWZTc2Qr?=
 =?utf-8?B?eGdLMEtmMTR4bWVDdEpmNitFakd4bi90M3g2emw5c1dPVnhCSS9pdDdrWkNx?=
 =?utf-8?Q?jMyUkNMAhEAtH3Ug=3D?=
X-Exchange-RoutingPolicyChecked:
	mQlTOdtS5kJatGO9ZRIwDpB+BlDsr8QcAKYNV9QBuhWLauxoutWv4FqwH13/s0B3I7WwR/bMRy9oXJb+ij1FWe7lClZceJuTh/ot4wOXWei2Q99erIthWoMxVnHRKsafE73mtcYkE9LHFTBJYj55XVBzV6+LixcYoH3XYlFVvEX5mMvB7y0aeKEhxcKJD8etVTdashwVwASSBB3VN1j5bibr3ivj+gcVW4nvWsyUwmVUcwmzlkg9rzeZcYxEKUn7aqEkG73V1uo45DeQLCBGZGa1/NDbn6CXGaXoKExFvLFaOoORWX8gagiNZgChn356p/6RqtG+t0qeR/PjLZ1JVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k9mdzHkT181t8jdku57nhiGu9TAdetly5dQAkLyyr4abId005jxdgDWFsl6NyaKaGlB9tq2PpPIZn437iPc3SSQ/4yoqSowz8xyqAzS6w9pR3VEynzeV+eLc26x/3zcpzx6afCTa3MmWJGfN8QQ366EnBg9kK+tWBpdIsn/yl17eT/UIh2WFtaL83EpcZnoMET8SG08h/rG91PoTxRq+jyy5uL0YheAlSef5erOqsR7xCXC90/JaguQCbwD1lmThpr3HS+jjCnr96Zo4/0gtIOrMta6EDUtEYGGU52h73XXmrWtQcc4k7LQZJvGzRhOINgNvBsBVLRL0OQlFRUo3qArS/3L2o9Q83JVi3CHLiQQcUn2GpKV7+FyWBurk0dLOahmzMoUIgi0TzLoICYw5dj/lXKUnafO3YQCHbRltxWlJcgIIc2PQB6BlFeE+W8g8uJBfDq2vCmV1eScJ7DcNlU/ftzpaVDUu1VJA96Vu98J+9Gt2j7cNbTL06J1QaqG0+/KybIPSAK6Nf/lxJW0S48TnDEomnOeTfuIqGE32w8I/ijcpmrzdyKPR0CfHZ1XE45UbkY70QfFLVpRKiE8PDFZcl4692YrwlZkoVjZUjzY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a28186-f7c2-4ea3-c275-08dee8abb9e5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:15:39.1587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FZ7gwPWVX4zDsOX7l0k4fZ56D7AEE4DaXSr35MFgGol2+pCpGSm8bs3A4TZs2TVqFmcZf/0y0eW0K8+bUf0dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=930 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230110
X-Proofpoint-GUID: XPUeSL5R-MEAofuLlnxiXy_TYePh1K0Z
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMCBTYWx0ZWRfX4s7cZtvaLn6m
 MB5HvUr9ls2Gs3qwF1Lxj4xguIDzW0HtEAm5KWoBFi5cQ21EhjlkBp4Fq+eVXq9RV5masThwac4
 NvBvNNDJHX/knPgWoyP3cSXXjb55tfQ1R+MiZU0B1Me2HJIi3ELJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMCBTYWx0ZWRfX8WCMAWJkv7Wz
 l4wVwcCaoscrPg6NGr//8q49CydgdhocmgQi+lArKO7SXxX8BXM6w0ltJDlzxERIXMFqzoOX1il
 iayprrjpmfSCnhtrVoaeC5UzNZcgqW39ecjGN3SW7IZnYfkDnlIyh4NE0VnesR/L2BQdBWLZWAC
 o0PCSax8Iw+CT/aRYbv6rZTLrCx4hr9IhxMHwY+esEiL/1v9kAPqGXhtOIxvGBAoeqFkB2Njf8/
 jr6Rvw9zn2k02bsGcQqXiTjh/CK/Gmdg0UlzG7ER4mS/hZHDbTYdt98J9DMh2DCAS74R09z87nV
 5SPfU4f9SJEdGqM9eXT8foZQgD9jg2jWfo3O4DFKTK2GMdepqXi+USpOxLVFoOz0giI1V0dvTOH
 5mdrldirXm2dX4chcNF36dLTfTmgiSq99bHhfkP9Ma3+7EKzVd8Q61wPtUM2CspybtPZ47WAptQ
 CmJNwVDLLaXZczu1gzlTbC/Qkjek3312NjLQMPYw=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61f7df b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=IMuXsgyDNOJxrMGzPD4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: XPUeSL5R-MEAofuLlnxiXy_TYePh1K0Z

On 23/07/2026 11:39, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] The newly added call to `scsi_mpath_revalidate_paths()` in `scsi_internal_device_unblock()` races with device initialization and teardown, leading to a NULL pointer dereference or Use-After-Free.
> - [High] Missing cancellation of `mpath_head->requeue_work` causes use-after-free when `scsi_mpath_head` is freed.
> - [Medium] Path revalidation is skipped for devices unblocked via `scsi_internal_device_unblock_nowait()`.
> --
> 
> --- Patch [18]: [PATCH v4 18/28] scsi-multipath: revalidate paths upon device unblock ---
> commit b434ea17223b4b11754a84ac3b62a1af5b823144
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: revalidate paths upon device unblock
> 
> This patch adds functionality to revalidate paths when a scsi_device is
> unblocked. It introduces scsi_mpath_revalidate_paths() to clear paths and
> requeue bios, and hooks it into scsi_internal_device_unblock().
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index f2729c0969801..d98c3239c13ad 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -3092,6 +3092,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
>>   
>>   	mutex_lock(&sdev->state_mutex);
>>   	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
>> +	if ((ret == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Can this lead to a use-after-free or NULL pointer dereference during device
> removal?
> 
> If __scsi_remove_device() transitions the device to SDEV_CANCEL and unlocks
> state_mutex, it then locklessly calls scsi_mpath_remove_device() which sets
> scsi_mpath_head to NULL and frees it.
> 
> If scsi_internal_device_unblock() runs concurrently,
> scsi_internal_device_unblock_nowait() will return 0 (success) because the
> device state is SDEV_CANCEL.
> 
> Does this cause the unblock path to mistakenly proceed and call
> scsi_mpath_revalidate_paths(), dereferencing the freed or NULL
> scsi_mpath_head?


will check

> 
> [Severity: Medium]
> Are there callers that bypass scsi_internal_device_unblock() and call
> scsi_internal_device_unblock_nowait() directly?


will check

> 
> If drivers directly call the nowait variant to unblock a device, it seems
> they will successfully transition the device to SDEV_RUNNING but skip this
> new path revalidation. Will this leave their queued bios stuck?
> 
>>   	mutex_unlock(&sdev->state_mutex);
>>   
>>   	return ret;
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 6a2b06c148c1a..b896d28a7dd9a 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> [ ... ]
>> @@ -230,6 +230,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +       mpath_revalidate_paths(mpath_head);
>> +}
> 
> [Severity: High]
> Does this introduce a race condition with mpath_head->requeue_work?
> 
> Calling mpath_revalidate_paths() schedules requeue_work locklessly. If this
> revalidation happens right as the device is being removed, is the work item
> properly canceled?
> 
> If scsi_mpath_head_release() frees the scsi_mpath_head structure without
> calling cancel_work_sync() or flush_work() on the embedded requeue_work,
> could the mpath_requeue_work() callback execute against freed memory?

will check

> 
>> +
>>   void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>>   {
> 

