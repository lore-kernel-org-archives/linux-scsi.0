Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C761581E0;
	Tue, 28 May 2024 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716891109; cv=fail; b=A+dvTq/9rEj2VhH/yYlyXtgN/ofC7eXa3ZTUKYR53u1P/ZInxeIg0E0LYhrNsNA1SmDwebDiTT1qdLHiQWmXkJNvBPoku+J8ONM9KdBlnpLQNvuuVF6plEgnnPk23d8FfNuiuHWayfLsRoRhWwZJYpnw7nZ3sU9OWZZftbeVPVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716891109; c=relaxed/simple;
	bh=kUEHjbSZ4up4iWR4BCeXnuUgS1Au7OYALKQReQMgZUQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ej1kNzoBxPsq8zOydgoDikP/meHmkT2l25+pMZPTI8vJbe+WVCKe/qUeagSvKUCVptBzBisSWomUwoU756bzURWEwNKz7Mg4KSd7VnNPGLkcbIEZZP3jaOXo24Xz7ZonHW6nQV7/cVYdrs2wGM4UPE6muC88KuzTXEGvhdtYTQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44S7wk7s031521;
	Tue, 28 May 2024 10:11:31 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DnGA7UueaNT93aBpXJrqiSyXyyY1BwyQ/9s13Dht4b2U=3D;_b?=
 =?UTF-8?Q?=3DRmUx5QIhE48/oZI+rm30qrq8JVN6FLGDJcq2GRfkTQEzJjUzzoiMRiiDNkot?=
 =?UTF-8?Q?ZeFFrRBw_xDwVkbJZ2DR0UGRlIw7JY/nQ7rbpx+13bs7GNur6/gcKivDBIZsIpl?=
 =?UTF-8?Q?+MuW0E0OmLla4i_MHRFtA5qkJZqF9zSbsWniSp9AnCy9gHQ23+8G2d08OIyDlK4?=
 =?UTF-8?Q?jvZmyCcMGK9QzyDyiQ40_k5E3gyals7JtAsAd3yj9UyQWlnTIju29zUHqLAd/xr?=
 =?UTF-8?Q?383MieOh6ousaL9qi1KS50epPi_ZrXqiuwM9JcqmQbjHoVEQ8WYp39MlkZoj0ZN?=
 =?UTF-8?Q?QPpgC22/NKseh8/3qF7gWq2p8PmDPtMX_fw=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8j83vwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 10:11:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SA6ruo037135;
	Tue, 28 May 2024 10:11:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc5355w3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 10:11:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O91h+564Kydmzm9SUNU7/5mAqnZLNL6Ww5iay1us/8jPVuJ4Zq++ogGHSPu8JrJbySd3tt0i7m0+uIvZQQlVSuSWuOYCZGiJPCMrZJ9gSIuA9yWDdsuyVh4/Dlvb1FLWnx85jRanJq1S4CfQWJxGxNIiUzlqbdX4Y97cuDgcqwKUaiSGXZ8cjZBzAyKz24nxeJrsvi5x6lUR4TMJmjFaQp2nXiiyWS20zXyClLkxKTLlbvrbJxnABdU5+yWQktjy+ScRDWHV8e04Txixh6f8Dzyc7QlbT+qLM7BtNMdpxZ7GzJs9XG5Aup3VNC0C+0SI1S2YUC5BaujSZgOpaZivoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGA7UueaNT93aBpXJrqiSyXyyY1BwyQ/9s13Dht4b2U=;
 b=Oh05+c9rKSyeOo/XIqwTJqyDXJRaPpc8ahGNSnV6SyC3kEi8G1xpzbDCHjxmPI/VkXCHd/7ZnkvWr48y7mW9Rlq4TBKuSDgpVNy5PHQXHTo7LJgdayhLZeLRe0b51VvlkiDtY/PrX3LLxX8OT7evErp6ZarluI3MP1PQCcsKsA8Dwq2GmzAVtQ1L5nsiU1ETxYw7s71tmhdZ6VGJQ8wAKps72iSHd7c+uKkDEoYbdJlKjAJwwP1CWiRmclSq9CWJOS/54vODfJ6CTXxesS4Q/bK1txwIsmiqNJlxJVs2vHDtFp9tNz+sdFu09gtXgn5B8xZLIbYxtRsGUo0Q6FSbgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGA7UueaNT93aBpXJrqiSyXyyY1BwyQ/9s13Dht4b2U=;
 b=CmZXg2P/sIWoS2eb2EF08REind3zWywulwl/gdyOPrT18yDWUpQjSSRu22hW+/x/es4XQnpoIipl+iB75MRuMREl1ldC+lKmXKQOGd/OPdNlgXUwFazqmll4yyWEDdguDE9W79s6WUbMpR0f1rySlUOYPc1Qjm7RmpUwP5tKDRg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA3PR10MB7071.namprd10.prod.outlook.com (2603:10b6:806:319::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 10:11:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 10:11:28 +0000
Message-ID: <a8b18cea-cc04-47d0-8ff0-b02dd087dc73@oracle.com>
Date: Tue, 28 May 2024 11:11:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240424080807.8469-1-yangxingui@huawei.com>
 <824c34aa-7c4c-4edd-b41c-f9b5ff5aff03@oracle.com>
 <12ea14e9-5821-b2b5-16c1-ac48985927d7@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <12ea14e9-5821-b2b5-16c1-ac48985927d7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA3PR10MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 704425c6-c643-4e65-9fd8-08dc7efe8a18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WENkKzViSnhRSUlWTWNuS3NBekRJOStnSGFURnJ5YWpXZzZMZndMVEtjRFox?=
 =?utf-8?B?MzJVQldieTRzNVpPdndkb081dS94S3ZiY3hKMXNTTlhiUk9jV21ISmNoZnFV?=
 =?utf-8?B?VjdFbDhDai81WTdiV1hkU3hSYmNJOEgxQUJVNEZGL2tiUHBvRC9HWU9EN0Jl?=
 =?utf-8?B?SGdQU3MvNk5MRFdSSVY0dDZmeEpyMXdXMFZ6dWs4RnN6RnlNQ0tiVFdnQjRT?=
 =?utf-8?B?TmExNGtoVWJCdWNpaFJ1dGZ6OVVsNit1NG9nMTFOcFliQ01od1ZsamxiNEI2?=
 =?utf-8?B?MEcwd0dCcmUyMnVuTzl6VlF4UGh4RFczemtkaG12Q3Z5VTJJMkZKNDUwemgz?=
 =?utf-8?B?Ui9VYk5WL3FMMmpTTlJmYTg5N25yY1dxYlp2MjlvNUsrTzZad29QMTluOGYy?=
 =?utf-8?B?MnE2QnJkQUtWS3QwbWlRTmlNc05JdGhqTWJ2TUd2cFBSVlg3MGdsSVpndXpw?=
 =?utf-8?B?Z3J3cG02RFdOYmJDWVliWUpKQ0VFL3lReHNUZDlqQ3hEdnNEWWxTQWx5K0Vi?=
 =?utf-8?B?RVVPRk1wZldwb3VJWFhwSTFuYjVHK25rWm54UVJ5NHRRWW1vTEpXT3NpeEM4?=
 =?utf-8?B?a0hRR28rV0ZuSzBaOEJtWnF6bUVCMFgwMWFVTUdhRjlUY0ZpeWFPN1g5SGJB?=
 =?utf-8?B?Uk4ydUZTOUJ3YWorQXNWamFYVDIwVUxpaGJJQmFlUlZPT3p6R2ZMdXgwQndR?=
 =?utf-8?B?MG52aGFxeXJSdXgxQThPTXBQMTlXaEFRdG02b2NKaTVUaEZQQ2lvS09vUzhx?=
 =?utf-8?B?c0JjMS90N0N1ckVDeVRnMDc3VUEvbE1zNGJnRS9Gcm1TWEpqMG45K1FaK0lK?=
 =?utf-8?B?SVhGM2hEem9GSFBBdjdKL0p4YlRqMUtUR3FJSm1zZEpmWWVHaW1BTW5ndlIv?=
 =?utf-8?B?YXNrQWtocUlrQk9uZjBSRldJZFdGaFNzNnZWY0JZR3dCVHZUUHJaeWpTcDly?=
 =?utf-8?B?QWt2WFZ1Z1k4WUVyT0JUaEQxbXFoNmNvMzZobGxYUGFkNHVqT29WSDVKZ2xq?=
 =?utf-8?B?VklxS2hWaTk3bWVEZUpTSllvM3ZGY3gwTS9QM3FVM3dRVGlQVEpwMlJPbk5N?=
 =?utf-8?B?UEwyUW0wR21oK211OVZOQXBpRkoxYjFCK3p0NGlORDdFcnFHQTJJZGtMSGJ2?=
 =?utf-8?B?bDNKQnRqYzlFdVI3RmxMeUNxV2Y2dzIzRHpIU0FzMXpBZjRlKzBOVndlQ3E0?=
 =?utf-8?B?a2ZsQlo5Rm1ZZklocVIxNnhBZFlWZWF4MUNEZk9UZWx0VzhsSzNuY2lHb01S?=
 =?utf-8?B?anhGWWdHMXZlN09qSkc5L1paa2NXOVpZZExMSWU5SHlOL28ycitZdng3UXpz?=
 =?utf-8?B?d25hZjdlN3ltNEVoOGZkblU3dzVTeXhGYVJXaGRDSisyY09HdVNSMWhWLzBa?=
 =?utf-8?B?L005anVzRUEwczFOenRwWjhtZDZORjZvd2ZNUVRKcEVpakhQTkY2dWJqOHN0?=
 =?utf-8?B?clkrYmlwVXp4bk9hOG9ITUlSL2pacDUyWERFYzFQeUtCTHE1ZkZ5TFdGZlpR?=
 =?utf-8?B?WEQxZlFsWUI5eE5UMTBsS2RSemI0MUx3Q25Jam0rQ0YzanVhaUgxQ0ZqZDZo?=
 =?utf-8?B?NVAyLytCbmJ6bE16ZjZ0K3dCOTJaU2Z0cFJVb1VQMWNQdGtIcDhjd0E1TS9E?=
 =?utf-8?B?M29NMHJrRS93SURNMVRONG9nZXdiWXF1Zkk0S3p6SjRYZHhPcmE1aWViUkxN?=
 =?utf-8?B?TWlURm1qRzBQelk3dEhPaHY3dHBYa2h2c0d4STRJeTNPcDhoY2VvdVpRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YitLcGs0OG00cFRsaS9BMHNTQm5sd0dlUVM2OTNmUlYxa2VGaHF0VEpwVk5B?=
 =?utf-8?B?YWUvQXBqRXZtMFZ1QnVWWU1BWUZXZEZBZldjWE13dEdsRUZyRlZnbjloeEYz?=
 =?utf-8?B?TkhPN3ZocGswb0kvamtGN1VpMnVJdTUyRWFvQm9HbjRaOVJLSnFMRzFSQkZw?=
 =?utf-8?B?b1RpOGJXbUVHQXZQdjE5QlpxT0tST1BRSmd0SCswZ0cxWTF6ZC9XT0MwSEd1?=
 =?utf-8?B?RnNrZzRJM0dXSThKMm8rbTg5UDBlTVhON0dsYXhIcFphYWQ2Z1VVTHRyMVRk?=
 =?utf-8?B?RjRKb1RJVWNYcFZheCtzY056ZkxJRlQvSGNCaXY5cnpyYXp2cnlsZU5la2Zz?=
 =?utf-8?B?OVNWcEdzSEJ6U3Nkb0gxZWRnNmxtcTM1Q3d2Um9wWW4yaGI4Qkt3VjRlRWFM?=
 =?utf-8?B?Y2RNS0ViUlNTVEZaUHJMSVVYNzhaQmlud1BoMkp0Rld1bHdQWWRzZ1ZUdGxh?=
 =?utf-8?B?djFuYVQ0NzdQUDNWT1RJOWVLMldDdE83NVEydHcxejBiS1B2U0pvRlNaeWRm?=
 =?utf-8?B?VW1Bd25OZ1dZSC9Fa2QxcG04MnlQUEovK0QyOWZWbHhUOEJjN2ZVUnJoQlA4?=
 =?utf-8?B?TnQ4b2NtRURoY3MwQmRDUUZSb29hU0pmRVNTV2lXOCt4ZUowM1YyUEJQdVdr?=
 =?utf-8?B?MVFLUDVLRDdqWiswd0l0ZFptY1dlbkNwWm1za3JqdENybUIzZ1AzN0dsRmdr?=
 =?utf-8?B?NWNrMUlHTStoTUFDd0svMnNwRnJ0VVdqaDZFc2Z4Z25VNkNZZExWK0lVOG1s?=
 =?utf-8?B?YXJ2Qk1xRnVUcHdESERWdFBzUy9CY1pETkhUTUtISWhjMUMxd2QyNW15bW1w?=
 =?utf-8?B?U0R0WTF3dWtlR1dwWVZvejlkOWJMT2E0TzM2RTBTaEdtenUxdVMyK2ZPc2RM?=
 =?utf-8?B?Zi9ieFpVUWFxTWkrMWYvenBlakU5RTQ1Y1JTZTR5NDVYSEdmbWZhV1pWRkUz?=
 =?utf-8?B?RU1zQWM4ZzRsMTNSTWp6NVg0Q1FBKzFONlZVQ1NIRk5aL0ovM0l6VVhrUHdm?=
 =?utf-8?B?TWthd2E5QklEMDVmd1hkSFdCOElqc2NTaGpNYXNsaVJDdTg3a3E1NlNwV1c3?=
 =?utf-8?B?S2JqYnlUbmQvS2RucENKMzlaK3lqZWMrS1JJYTQ0ZUFxNExiZ1VmWDNMemFq?=
 =?utf-8?B?amEydks0cVBDV2p6ZUQ0VnR2YVVuMkJHNnR5VFlLVENySnBaSlRIQUtEMk5q?=
 =?utf-8?B?dUlsbVdwZkZzdURCUFQ5ZE80MjhQRld2Ym1WY2J5bzI1SFhRNCsrSGJRZlpR?=
 =?utf-8?B?UTFYY3BCVEQ1M28wb3dDTTNSdDhudEVmV3JNNEtia1RESHgxQ1ZsRFhOa3Mw?=
 =?utf-8?B?bCt1T0lWc1VMNGJPOFI1cmJwOThLZHpDTlNTR0RFUEJnNzZ0Uy9aZG1JUFdU?=
 =?utf-8?B?UWJrdFBwTUdDeWlRZjdvMnlkZ3QvR1NRa3VjdDBFVTQ5akFwL1BOMEw5VnlV?=
 =?utf-8?B?endTRVA2NUhNWE55bnAvRnJJSXhyMllPTnZnaHBldjFHbVo2a1o5SWUrTThy?=
 =?utf-8?B?TWdBaXpaZ2s4djhOdStzTHJ2WDdKQ1dOYXNYNjlwL2FOY3RBbWlsZ0dTRUE0?=
 =?utf-8?B?ZCt0bEx0QXFDQnVSNXRwWXpqVFBhZm1jaGdydWhjOTBPZG4rYVdZQVNyTWtH?=
 =?utf-8?B?d3RnYWZhQUs0b3FSWDdTSmdjTVpBbysxbjNCeHkzclhKN25TY2EvV25qU2VU?=
 =?utf-8?B?MGdTdFhnUHFsK2hkT3lPZnlUS3FvSERENTFQVlZhMXRUNmFaaEpQb3lRUE5I?=
 =?utf-8?B?RWo2MVhtQ0MwTkhtZ3FndWZtOWlrUnZsMkFUbGRZRm1hUWVsUklDQk5wbzhp?=
 =?utf-8?B?VWtaa2krUExaNGNTTy9YNnFENVhkUjNmdTVzcFRBQXJ4VU5Ic05NbWIxdzk5?=
 =?utf-8?B?R01UTUFwMGxhNkRjM09ncFd4WFEzczZ4WVpnbjk2Q0F4eEVhTzFoK1diNmIv?=
 =?utf-8?B?Qlp6YTlYSVk2WEJLT1k2a09rZ3hJaTVuRWo3c3krai9kbDJSNXBPUWdyMzNp?=
 =?utf-8?B?SVkrT2dZMWZRUXhiWHFtbnMxSloxTWVQa3JBZlJuRlRaSDl3VDZLOGhUYnpH?=
 =?utf-8?B?SE9RSmFVbFVnQ0dKWGV1dXNTLzV0TkJvZUlLOTdiYW5PTTFFRHNYN0JFQ2t2?=
 =?utf-8?Q?EY203mozIvKBX/JMj6lFs7W1y?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nMF6tTbVkXqapBvsEfsnrN0/gFtArOXyZt3+12sjO4Rvp2wsi+HdCttypDjoBLLuJezV6nFvJ090OnoYbazFVp616NCUIr3g8RL3ykhQTp3z0UrdCwhroDeEwjIWqSGOepCoyPnxKT7vExIppyI+b1yCo8CR8pY1mHRnXabsct76aQDbz+HXHVKvtPtVOv9CMNRSroHi8LsMp0681nc1AljKEwFfb5JoSxMdVcOZex3geGSQyklM8tvlc1S+3EC0trHDgAxyFwJ3jXnaJPLfZSGpoxvEzCc3AsTIcr66mpNPls/v5s6UjPevg2xXqmF+V8aHLgGjTm/s+qjlCgDxcTafYix8eyRThC7AqUaPnv0FlqPfcRiemB2LsVliWVNXe9hpFbTEi8zZGMhULLGlnGPQepjsCm2qfm9T0wV4NAtViLV+s8XaXBvw64Q6c199bKYcN4duu8GqHkyLybnhB0F8RZ1onXi1fAPADyFo+bIZ9304oAiz9cBj6hIW5J8Sw6nHRT/PjYe2qQ/eOVZU482ERLee0/YdqYQSQ8Ee0xPpilwMI9SSNj9I6Mbm4zRZ9dV/VCxeHf9oectNcjKkRtN8Ic9MzxqqOBm6C58g/y8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704425c6-c643-4e65-9fd8-08dc7efe8a18
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 10:11:28.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHgf5B22A10PbxtpFnq/c60OTlkhglQHE4IWrFQ6o3dZUBXDCSwqs207cBR9WnvS1nz0TCdW2V9OAwSr/SsNXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_06,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=778 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405280076
X-Proofpoint-ORIG-GUID: Fy-_hBkxDLn07oIV3gUFEDBwp0RDzprd
X-Proofpoint-GUID: Fy-_hBkxDLn07oIV3gUFEDBwp0RDzprd

On 25/05/2024 04:08, yangxingui wrote:
>> Why do these new additions not cover the same job which those calls to 
>> the same functions @out covers?
> For asynchronous probes like sata, the failure occurs after @out. After 
> adding the device to port_delete_list, the port is not deleted 
> immediately. This may cause the device to fail to create a new port 
> because the previous port has not been deleted when the device attached 
> again. as follow:
> 
> 1. REVALIDATING DOMAIN
> 2. new device attached
> 3. ata_sas_async_probe
> 4. done REVALIDATING DOMAIN
> 5. @out, handle parent->port->sas_port_del_list
> 6. sata probe failed
> 7. add phy->port->list to parent->port->sas_port_del_list // port won't 
> delete now
> 
> 8、REVALIDATING DOMAIN
> 9、new device attached
> 10、new port create failed, as port already exits.
> 
ok, so next please consider these items:

- add a helper for calling sas_destruct_devices() and sas_destruct_ports().

- add a comment on why we have this new extra call to 
sas_destruct_devices() and sas_destruct_ports()

- can we put the new call to sas_destruct_devices() and 
sas_destruct_ports() after 7, above? i.e. the
sas_probe_devices() call? It would look a bit neater.

Thanks,
John


