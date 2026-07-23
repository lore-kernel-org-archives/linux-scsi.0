Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909D346E018;
	Thu, 23 Jul 2026 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806084; cv=fail; b=fg2qYxa6+XImJhGsAY5rlHDiA40hAVW2Wd5yGBe+HMzlsihMeAscW04Y/W2/1dsDoN+hQAiEaeD6TGJGjjK7C1RU0jsFBidQbP57qK8H3JXECmFRaReGjUCnYY5MwFAd3o6xT5jM2HbURsC6Sj2sC05bmwjdXXc7qDXsCTdC/5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806084; c=relaxed/simple;
	bh=Md4hVwgSpEcuAOq18mHsx61T714dWHNxOgSbP3OHSXk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qP4s3pAAv62D0XdnzHQZ6H6N3nagZknCj5NQaTKojD8zKzKoywkD35MPIyIKie1Cat6hb2k1VXw6kDSXDhLonu2CEHZT9e3GKvb2gwclK4qjHdt4V2C0dRh58y84KxkdJ4XjeIeKe4iZK1VFI78dU/1NF2yCgLy61Kg2gEe4YMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=czOV30lr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LFgCYvD/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="czOV30lr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LFgCYvD/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtXoq3573774;
	Thu, 23 Jul 2026 11:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=p+fNFg3B3xnTKZDEh+qb8gxt5M5QqE9qjzFsaGcUA0w=; b=
	czOV30lr8JOiXvOsF6QU7Q1rGK7JqJjfPZOb1yWHO2hjfEaNHbzF8CvcuJxfbvU4
	lD9aXHHpA+34dWm27++ogcANhiE9GHJVKD+8OApOn5xSVxyOJ4TFiIpq7uYsgzRb
	49WwmHgnecqiHyRxtfAhXA06UIVWFEtSRjibzO16XcLtctpQWVkUBHPI/+YbRGqY
	XRrhlQ6TjLKW3WcI550WNh2RyBX7htUhUhLhugx4LvIQnJW4vjBi6uvqBnVen/wk
	hQrcxMhNnbkuj2JmsoB3bwyo9C9FGiH2GtTEogF+lcj5z1NGTHJe8FekbJmjklD3
	fTL4vm6+/8U7UAObk5lvEA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqptu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:28:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBNBbT021827;
	Thu, 23 Jul 2026 11:28:00 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxeque7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:28:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kw5ZjM2eRexaXrcS3wK8cVf/UKG5d5TkIJXPFlG/20dyfLwUH1QtHgR0cc5hGPdifxYwF6o+57k30RN9OjGN86ojZbuk4SUPsbzsjMWdtMKDqEM5WwensrLi15KgDgmtyDfO7r/dWtwrBlTm+A7NbycgSejkyNB5tFtj9b0eJkzbyXiBQKcYky+Urhu65y1+7soimFvYurzIkhZBk9qor9MDrAkt3+DIVonOgk8xCIoNPngBe2jSrMxbEzDue+qsoVkXDaPSPITzNbm6ppLm433pJmuWpSHpJUkv8AssvgSzS7f6EJy7vHBSh+q9nH6ZraANyznqjVEoBF/Y07BUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+fNFg3B3xnTKZDEh+qb8gxt5M5QqE9qjzFsaGcUA0w=;
 b=Tm325kDMh2HyKrvZrNKuDX8q/qAFDx7uox1R/Xm8hAXmoLlix+Y+IyA/5qvp9IBcuPO67IBgVYiPL12j7JKbm4/ZAm/1EZsANf9fyoznBpFDdsVzZggeuD6LlgJLBALG3ZE+Cqi450cyTer8tHqTNYVORGN+WgjttOdK5A0kVpOojSdgu3STUz/UBR/FigefE/NMSfo4NOALZh8JtgdCMiDDTfY7vrJq6rF4Q65Rlrici3+WkPldAokJ4CwoHEdcuGGBQfF0SDfFTlQ9BKP4INI00IVtTIz53qAEdvLhQNx+s6EEq4ACAUM+5+0rtmkgerpmBnhszSZwEuAq+iBWTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+fNFg3B3xnTKZDEh+qb8gxt5M5QqE9qjzFsaGcUA0w=;
 b=LFgCYvD/InP70QgjE9gJXWPRzXDY90UWuD9RA/gawrk7w5T53kC7S3n/r9qZFUJsKB7fGxSOj2psKmDYgTq9IMJzDqVcxOpMiUUtmklpBEo4FkpblF5LEU5qTHowqa76hMjVFgQZXTy+ZgMeQsTsRq7sQVcMw+tkkCF7j+nLQUU=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH9PR10MB997856.namprd10.prod.outlook.com (2603:10b6:610:345::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:27:55 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:27:55 +0000
Message-ID: <12619e95-6a8b-4925-8fc5-e12b14d88f11@oracle.com>
Date: Thu, 23 Jul 2026 12:27:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 25/28] scsi: sd: support multipath disk
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-26-john.g.garry@oracle.com>
 <20260723104735.40A5C1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723104735.40A5C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::15) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH9PR10MB997856:EE_
X-MS-Office365-Filtering-Correlation-Id: d4007a11-238e-49d0-1bc0-08dee8ad70f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|6133799003|56012099006|5023799004|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9PENfy+MyGtoL5GvXksyNPB9b2DSmdIaT5vyhMdml2U8iNlexk/lcagluOBh1xEp4qwdAfPf56rZE9jnxTOeC5wuO2pi8LjtTJ9TTgQqzYPcxquLc74Aw0JU/6T5t7cdyS/shWUcvVLEBII5Vy1RnWrQ7b4Fe+CHlnDAUC39JPBIBaM4sC+MSHDMr8Z/Aah8vZg1yxjo0HG425D+YkDwLAdEIWkhlKijKYvbkuO5WoS5dSfZWSAq0kC28GrkhNeE08Ruwi5aDtFsjv8EuD12i2rPRjXgCzGc3Ra6js813+FVZXpxF/D368eEAeCQnnWRRCkz0f/Eu8VI6l0NWep+yEk3Dtpy4IVz9E1fOuJnTOnHQEGRPpHjSYe8+unnj84U3CxzLE6+gw6n/OemKapwBQvZaLsgKhwmYyqa0ucSQcTKY5QoOhV3az0SxQPQFqA0pq/6xTywL1l/RN/ZYDwbuFI3xF9CpCMTAkGV11AipdDUDVR4OHaeGuGkSi0QfGoBgOFEgnbcT/m7+ImhrdQpdE30UTIzEj/Vu0HreW5uSgpMUJS60BYHAF729Mt8ZyChmEfMem/AwYe/OpHnD5q5o0mebNvsY8aEpmVHpttThhWbOIWQmk2eTlFUQjtpA0s6/WtRiiHBJUlaWvnWNepXo2ufyqGlnVmUMLAS23s4mJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(6133799003)(56012099006)(5023799004)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emJHMm9pSDVNMzlnZTh3UlViczVORXFiRmVDUlNSRkdMSVl6ckhEWGo5TkRp?=
 =?utf-8?B?Umk0dUJYRUcyZVFNbmw3d1RqTXdWMHJQSkd4RFBCcko3azFXZkVKOC9MM2N0?=
 =?utf-8?B?SEtRbUkrN3Y4Umk0d3FUNG96RExIOHgvV3RSOEJUN2pQTzZUUkRqWldIcUxR?=
 =?utf-8?B?TkVFTXBrT0dTR3F2aUd4Q0g4RU4ybnh3ZkxqczdHVlRHL2Z5cHg3RThjVk1s?=
 =?utf-8?B?Wkh5UXdRaXFQbmxvS2VURHRROFNPakRUZllyclRWYkJPZDFDNitoMFlQdktU?=
 =?utf-8?B?SHdiVklXVkQzQzRoWUpFZjYvK3JqWFp0WlBSVDk5bHN5MVFIUXZDdGVEZzEx?=
 =?utf-8?B?RCtNem5INzc5UGx6M3dSZFd4dlpaM0dCcWxSeGs2enJLZ3hFL0NvZmlFeDIr?=
 =?utf-8?B?L0R0d09SYW4yaW4yNXVpSWtYVTIvbnRPY3JNZGM0NDBQaVFYVFFtT3hIb1BI?=
 =?utf-8?B?QlV1RnhBekphUjNaTnZ5TWxGdk4zL1pRZWY5Y0dMTzdZMTkwemlUNlI3ZGpo?=
 =?utf-8?B?MEEyMEh6NllWblhqL25VcFpXM3ptWHl4UXVNalF0V2RReVFsekFSd0lTSVlQ?=
 =?utf-8?B?SkVYZjV6N3AwOG0rV2p2VXA3OS8vQUtCVVh3eis5MzBLZG5sczJYMWNpQlVt?=
 =?utf-8?B?N1JZNHZTdU5iVHBMQVNXamJoN0ZRWUVCSGFXZFNqODdUbERXT2c3OXVTVVZQ?=
 =?utf-8?B?KzlPWm9TTzNpS2pDNXBBeFA1REplM09Hd3NDRWM0RWpUNjI2bUs2czBORGFV?=
 =?utf-8?B?cXk0N1hoM0ZRd2VxM3QxQTI3d1hkU3hmK2ZLRVBuWUFZbEl4YjJuZTArRWt4?=
 =?utf-8?B?QmNFUVZlTWRVYStubmlkd2lWTnM2R25zVld6ZXdUVmhPTjN0Y3lqUi9IWHZU?=
 =?utf-8?B?eUtsWVk5L1Rxc0RwbFFxMUZPaTZHUmdEUG50eXJIbnRwWHk1aVNWbm94V25B?=
 =?utf-8?B?RlMrM09mbmM5ek03NWVab0poL2JsTEpicHVTSXJFVXZnTnJwKzZ6b0d2cXB5?=
 =?utf-8?B?Wm1GRGtKejl4V2o1UWYxdjBGT0RXcFk3cElycE1ZOFpjcTJNUFJ4M2NqUHNq?=
 =?utf-8?B?TnlBYU5jNmh5aFlLYVdSQ2Z3NEV3czJrSFgxMUN4dkZGc0g2TTFXcHRWWWZ0?=
 =?utf-8?B?a1RCSDBMbmpRK2lDamgrTHJ5RnBGMXg2RGtrZlFzNFpWa3h0cldsWXI5a1Yx?=
 =?utf-8?B?dk1qMTFWaWwvOTVLMXRRSGtQQ1htRzNXdGxSRlFla2dBbHo2ZXY1T1JEN012?=
 =?utf-8?B?UmRESlNZNjZkWTdwZTE3MlI1V1loR0RiRHdXalJVb1VIcGhSY09PdHlLMHI4?=
 =?utf-8?B?TW5yeUo1RmNMbHR2Zkp5akpRQy9CK0lFdVpoVjh3UENpNmJyY2hyOEtNbjgv?=
 =?utf-8?B?MzEzRVkwb295Z2FQeWRiOEE0WkVSRlJpQXMvdmlnbkEyNlhIVjNDTGk3MDJ1?=
 =?utf-8?B?aEJRR1oyc09aazBMTHRJVVN5Q2lPV3ZGR2pSWWxIZGlUaHdkcU5EZEZtOEt4?=
 =?utf-8?B?MVQweVc5eUoraW1tU1Y1d09BNndqR1RCdFoyZkpoZ3RleTVCYnFZVlI1Vitv?=
 =?utf-8?B?ejNxNy9BeFRNSjNaRC9uWEZiQUZuS2tCN0ZCRUlqOWtyRVBVWGFZQVpMUkJz?=
 =?utf-8?B?Z1ZvdnI2M05veG1BRlBIMUQ5ZjI3U0ZpMVRMOWhIbFE0dEg2ME5lZ0xjZFBB?=
 =?utf-8?B?MUJKUFdvNmtEaDBNL3NkMEk5NTVGMUlWRXdySTY3ckZQbEFUUWJ6V0NvdHo2?=
 =?utf-8?B?cFVoeURSWGpiNlNJVjluZkV2K1MxZDg1SHRwSDFuc1VsZzl3UTFCUlcxblIr?=
 =?utf-8?B?N3V0Y2phMnpqa3JtcWl1b2NWZ1NIMDQ0dnh1cTNsQlJwOWNMbVlIdzM0WkxM?=
 =?utf-8?B?Sk56aUZaSU55NUtERFVsQVpxZGFZc2lmcjdHQXJzUGh0VkVTYnRrTGFLMXVY?=
 =?utf-8?B?T04xWjJEOHBwemdvNjB2YW1ReFo2UHRuQkdqMEhvNTNjT2c0TlJTS002Nm1i?=
 =?utf-8?B?UE85SzdkZHpQMnlmZDk4Y0RTcmJxOFNMU0FSSFpzTG1oRzNXcDBISW83STZj?=
 =?utf-8?B?QkFoVFVva0RUUC81OXZwOXBaRkFFZ3JscGdIZFY4alhqcURna2JJK0NZWHJN?=
 =?utf-8?B?K2FWV0tGMkNKQkFESDVsdmkyclVDdVYwMjc5R0c0d0dmN1FRT2NDaHhNTlNJ?=
 =?utf-8?B?QzVBNEdlVE92V3czSFRjVWk4MmgzNUZqTHFBVkN1OXVERWMxQ1ZMVnZkNHpt?=
 =?utf-8?B?ZldoQnhjdDZvZVVXaHJOSHF2eXV4QS9BKzNrd1Mvejd5UDBUaHFxZHFCR2F2?=
 =?utf-8?B?YmlwNlMzNE81VTd1dmtITVoxU0RNc1N0emt5bHhSdnVNbS9IRnlWbWZOZHFD?=
 =?utf-8?Q?MzfMsv1DgC/TacW8=3D?=
X-Exchange-RoutingPolicyChecked:
	sQpBm95TLnGNo8gXKAi15f2Kg5jv1U7NSHCRYeL7kuoGLuj7DhQ6GJcYCjuDG/atA+Gv7FtwVcKcU0jQr0oiAqEjKcVxfB7zwBJbMZlI8/XaMXrCHBY4FaAPMbnAsCKvrhjcGzDQX2uwNLm056gAKHMW3UhZThDBy9l30Vvuv5wlrJSHbNYVIuozJhgJVs5lqg4Cmh6tVujSChskPfFkOKnz0ZVrEw/3EU/9lQlocR3yE3mh+p+n/Ly+V754haj4m+47oEhTiH2+z+2rPTkTA0HTlxWTc6PD90Zh5Qe7WBFX43XKcFOv6Lt4i6QHKL/yIjWGIaDhGNJBKPnCdLfWFg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UobSnnl9yIXOlX5SN7INHsSSkapo36i88Dcpk54dM4RaBRt1l+oiY37WUk7nQ1B9eV7jnOnyT5W28fpDc2Ezatx4GP1kbzrL30uRJjdGfu9gXvYiK9WyKwrVR6dlFEbZUP1J6pL1W1DZFVoTcQgs+Zkh+eG8Yxy9EnRt9bvK68qBdzhl4KCtc2aXkwqb4iQUE+moQGekcGOO9S5QN3luH78mUXNfghwv/qg812eTqyQAUUWeiTdnN++A6lVhUII5h+ikQxmpqbFX3GZKfaCUTbgocSKke8CZ2/mWdN3oi09XeEFd2Eul900fcy8QlQiJy4KNSo/MDDJFppzMnwlg+WvzCmjlAjqEDA2KNzZ9/Xne5x+7I8ab6/qN/WcW+i3iBMtZsaL9WF1ZW/O2JyJLAEKm4ohRhMGx3h/Kvb8UQWDxWjVCFrtrBt0LVdxiYEwnQlwdK/S4BGT7JWCyKnl5pui41w6uKRrro54TYkgdbPCtI/kCNFsXzopav4RDAEToVEC1gOUUCy+e9Y8XX1c1Z+SYjkBFKkTwSYhst+OSG+SV1qmWhIsLmIJBxj4QNGdPqsQjkhkacFciJ0PUOx7sRznxBkXe97vthJ2qwrJyP9w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4007a11-238e-49d0-1bc0-08dee8ad70f2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:27:55.6413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7NfjT0q+mle5gBAqo2Mr4mjHwGvW76fM3jLKzUWtCWdVVKug712uTqppZ9D5epT+2R4ST7r9HVH41yPp76m/1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230112
X-Proofpoint-ORIG-GUID: ahQJc82IlQF0S7VVdBMehOO8Gqm6vXq7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMyBTYWx0ZWRfX+acl8BlZzxBn
 spWpr3z6qYgaHbpLBZ4zYCd7luBC9YDrwgahL65BlqlWkcNYZElMgzPIx9b8aT/X7mvEq6XH5mu
 vHe0Lzy/t7e8s9bOOfZVuPCTzKiMoBw+r2WQQ9eWJOkACDaJK6NJ9ts7T9w9t5a/TWkUlfI+1m/
 Rve944rsyX0cmi0VhJXwBtOwn6r7UdMmet0k3sg+9q6xmRmJ6Cm3ACZIm/pOO/vonfC/PQZeXRA
 44FsZpIN5qgDyvJ3LdVixKOeJetff3T7rjSKfM/y2w7XyjL7JytMqnTeklu7All0SB56dFYBsaH
 O4mRLQnU/rBI11HJhlGyxZdyAtxEgCosBX92vl5m9TSEMgnqT6dFkUDD46HJUJMGW6deCBMVG/1
 Xqll0boIDunETsYgqya4BA9YD3EUNhKHa6Ywkr9aLZasOM7UetUUAt4DhegX9Sg8dOEdltFGpxo
 B29AyBuYV+g8c5ZRp8A==
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61fac1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=9JAisoIBxrVVzb-2mlYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ahQJc82IlQF0S7VVdBMehOO8Gqm6vXq7
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMyBTYWx0ZWRfX4iO1INVL5O14
 xkD6o3lHsfDWlLXC+tYU1B9l9N2zxBCPHnQJD1cnwpfw7ywFU2yoy5uc8Kwbbt1y6pubOcPyhGt
 xWJ6SKdZI0Kj0X+709jvEIsp88Ze0ap79NVR6FAxKlWT0S6Quu2R

On 23/07/2026 11:47, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> 
> New issues:
> - [High] Unconditional sd_mpath_put_disk() in sd_mpath_remove() destroys the multipath disk structure while delayed removal is pending, causing a use-after-free.
> - [High] Uncanceled delayed work accesses freed mpath_head after sd_mpath_fail_probe unconditionally deletes the device.
> - [High] Concurrent execution of sd_mpath_remove_head and sd_mpath_probe creates a race condition that incorrectly deletes a newly allocated gendisk.
> - [Medium] Missing put_device() in sd_probe() error path for sd_mpath_add_disk() failure leaks sdkp and its parent's reference.
> - [Medium] Error paths in sd_mpath_probe() call kfree() on a device object after device_initialize(), leaking kobject internals.
> 
> Pre-existing issues:
> - [High] If sd_large_pool_create() fails, sd_probe() jumps to out_free_index bypassing device unregistration and freeing active sysfs device memory (sdkp).
> --
> 
> --- Patch [25]: [PATCH v4 25/28] scsi: sd: support multipath disk ---
> commit 7776d470d97b7568b27daa7f4e53e7184172c0bc
> Author: John Garry <john.garry@linux.dev>
> 
> scsi: sd: support multipath disk
> 
> This commit adds support to attach a multipath disk. It allocates a
> gendisk per path and marks them as hidden while keeping a global list of
> sd_mpath_disks for matching scsi_devices.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 36c745cbb2619..d5a37b1b312c3 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4035,13 +4139,258 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
> [ ... ]
>> +static int sd_mpath_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	sd_mpath_disk->scsi_mpath_head = scsi_mpath_head;
>> +	device_initialize(&sd_mpath_disk->dev);
>> +	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
> [ ... ]
>> +	error = mpath_alloc_head_disk(mpath_head, &lim,
>> +				dev_to_node(dma_dev));
>> +	if (error)
>> +		goto out_free_disk;
> [ ... ]
>> +out_free_disk:
>> +	kfree(sd_mpath_disk);
> 
> [Severity: Medium]
> Is it safe to call kfree() directly on the device object here?
> Since device_initialize() was already called on sd_mpath_disk->dev,
> shouldn't we use put_device() to prevent leaking resources allocated by
> the kobject core?

will fix

> 
> [ ... ]
>> +static void sd_mpath_remove(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk->disk_count--;
>> +	if (!sd_mpath_disk->disk_count && mpath_can_remove_head(mpath_head)) {
>> +		list_del_init(&sd_mpath_disk->entry);
>> +		remove = true;
>> +	}
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	mpath_remove_sysfs_link(mpath_device);
>> +	mpath_device->disk = NULL;
>> +
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> 
> [Severity: High]
> Does this sequence risk a use-after-free if delayed removal is pending?
> If mpath_can_remove_head() returns false, the object remains on the
> global list and is not fully removed, but we unconditionally drop the
> reference via sd_mpath_put_disk() at the end. This could free the object
> while it is still globally accessible.

not an issue

> 
> [ ... ]
>> +static void sd_mpath_remove_head(struct scsi_mpath_head *scsi_mpath_head)
>> +{
> [ ... ]
>> +	list_del_init(&sd_mpath_disk->entry);
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +
>> +	device_del(&sd_mpath_disk->dev);
>> +	mpath_remove_disk(mpath_head);
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> 
> [Severity: High]
> Could dropping the mutex here race with a concurrent sd_mpath_probe()?
> We drop sd_mpath_disks_lock before calling mpath_remove_disk(mpath_head).
> If a new probe allocates a new disk and overwrites mpath_head->disk
> in that window, mpath_remove_disk() might delete the newly allocated
> gendisk instead of the old one being removed.

will check

> 
> [ ... ]
>> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	mutex_lock(&sd_mpath_disks_lock);
>> +	sd_mpath_disk->disk_count--;
>> +	if (!sd_mpath_disk->disk_count) {
>> +		list_del_init(&sd_mpath_disk->entry);
>> +		remove = true;
>> +	}
>> +	mutex_unlock(&sd_mpath_disks_lock);
>> +	mpath_device->disk = NULL;
>> +
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> 
> [Severity: High]
> What happens if there is pending delayed work on mpath_head->remove_work
> when we hit this error path? If a previous removal queued the work,
> and a subsequent failed probe triggers this code, we delete and free the
> head without canceling the delayed work. Will the workqueue then trigger
> a use-after-free on the freed mpath_head?

will check

> 
> [ ... ]
>> @@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
>>   	sd_revalidate_disk(gd);
>>   	if (sdp->sector_size > PAGE_SIZE) {
>>   		if (sd_large_pool_create()) {
>> +			sd_mpath_fail_probe(sdkp);
>>   			error = -ENOMEM;
>>   			goto out_free_index;
>>   		}
>>   	}
> 
> [Severity: High]
> This is a pre-existing issue,

don't tell me pre-existing issues

  but can this lead to a use-after-free in
> sysfs? At this point, device_add() has already succeeded. Bypassing
> device_del() or device_unregister() and jumping directly to
> out_free_index (which frees sdkp) leaves the device linked in the sysfs
> hierarchy.
> 
> [ ... ]
>> @@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
>>   		goto out;
>>   	}
>>   
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_add_disk(sdkp);
>> +		if (error) {
>> +			sd_mpath_fail_probe(sdkp);
>> +			device_del(&sdkp->disk_dev);
>> +			del_gendisk(sdkp->disk);
>> +
>> +			put_disk(sdkp->disk);
>> +			if (sdp->sector_size > PAGE_SIZE)
>> +				sd_large_pool_destroy();
>> +			goto out;
>> +		}
>> +	}
> 
> [Severity: Medium]
> Are we leaking the scsi_disk structure and its parent reference here?
> We call device_del(&sdkp->disk_dev), but we don't call put_device()
> to drop the base reference acquired during device_initialize().
> 

not an issue as I think thAT del_gendisk handles it

