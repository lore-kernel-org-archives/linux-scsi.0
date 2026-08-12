Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E63238C438;
	Wed, 12 Aug 2026 13:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786541337; cv=fail; b=PLXHHG8lE2SG68D75lwqZw31GJGfzAo21Zj5qu/dKA706git4aLyq+/ZKBgz9iB+6uFpjxrMgprul1PhJWfgc2UWZGxCQmZ5wwzjh5cV9ECKjdtXrZ4giDMNjGjuOmXG3t3ynHiI8NBMNQhscjWwHUOPwFGzejkzDgZDSwuFjek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786541337; c=relaxed/simple;
	bh=3aug6ZyKjKehE9LXb1CCbFVJ5m5FbI3Im0PQGsFhVvk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WN2Fyg+5HF6a8s+sCnUHzYdKE7iBwFsMeWKIR9ZGFL5hBd8cbINDlwQTo+6Eg5pnEURWSam943pEn9Tep5CVw38ul/d4GN9vx96GxZKvnMzFqKH59iQ2hYQC0iltBCagH6JMJiAQSeuFs9AaO4gQDPyuIAQYgeqwD7cCLPv9zug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C+EpX0yf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VZDQqBDo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C+EpX0yf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VZDQqBDo"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67BLc2hY299302;
	Wed, 12 Aug 2026 13:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=k6Jfeb/fozwlGqUiqPfsM8t6XsrTUGkPYTu5699aO/M=; b=
	C+EpX0yfVLM2CBFzrY0vrdNOnmEc3iSJ3YHbn3pjZpZAMVc44y94T+4GXOjzLPhT
	nQsqq07P6iFvh7wjRXL9DhYUPnPe3EIGWz3YrEgXVV9g04+th7d1yHoD5W5VB5DJ
	ZmSvFId+nnp84AJD2cEvmnO4oUUYvPDtQXPz6yik4bkMuTbJ9UdWGy1XsaZzyjDK
	SE780CyXqZpBQcroq4ZtoLvGMO2IzYYuBhAQQ6FFo/QtN455NCmhlbGOVPKvjcLT
	opDTpGHyAvD65HtaP9a24NUM8GXp5lwpBKgaCarZGc1mzXuaFKAlL7LPwcGQWud0
	YC2GG1zqqGQ+uZhEBmJH7w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvhdxuf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Aug 2026 13:28:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67CDLDu6008895;
	Wed, 12 Aug 2026 13:28:37 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtweker0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 12 Aug 2026 13:28:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNEOenzlrX3YuSne2g343o3Z7lhSGGeGD5wrQyhgX0A9+dFpSFGwUtQFWf201vmkod45sixN4BNzWdUmSVXJrtlLQ4IRCw8hokJueHJcCfOm/skHglXN6ePoH6wUi+uK5sHelDRBshNpPv3xWk+2PRed/qpLfkAb0ahW1psziMO9o5RXXjXvZzCcrM5DKderTqKg4D3bve11mKSWI78j1L1EhvpnRZ7mSyHUWzcboOD/KwjJZKsA09/51uLJ2g9vVXJalU2bKT/QMaWYTsP6WRKUyAYJp3U9Muay0ivPfDiFx+dtduXq4zQ/fqdaYnEMHii0i1rk1gU1wN0Hhm4z5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6Jfeb/fozwlGqUiqPfsM8t6XsrTUGkPYTu5699aO/M=;
 b=so+2JA5EtVhDfmpa9AhsB44bz3GHHB3XCM5WZdkEOQ6GthVhyp6DZ0pSUWOUOyLbsA/OflENrlG2BJSZaxRQeK/P4WLBZ/PleHAhe2yWoG9dEuXqoqkkA9GY1Cup98hubeD3rn0382gu4MMkILLAjGc3N2ir1blY0zWYAlnu1gz7Y1PjNKuqWRNT4Fi/A+BScT43ZgnoYhKqX2I8XVyH5qLJ6+hOfBaaO34MH2l4QdVOZlSNJ0b8vyiWwt4sZJcS0dYAdpj8Yve6hFBM3bmZH1jpd68Rc1ZUeSEGqjyBSjqqOvMDqP4nc3m6+oC//w42cpVb6/rxPBXTiK57oWcy1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6Jfeb/fozwlGqUiqPfsM8t6XsrTUGkPYTu5699aO/M=;
 b=VZDQqBDoUgnRmCk1uQwaQdz7Cq4vA69RdXjpH3K0X8WGWPTyWTCToU6GQb7PL6if+E+kI4HBVs3IO5Qd5cjDNl2Wifg8k+lss6DLO2rRnF6AhnRqR6uUyutpQ8EA2zD/VGx7uTPC3hb4bHQYFtLNd5e9fYiYSQn0r/u9zyO4Nbs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB7856.namprd10.prod.outlook.com (2603:10b6:806:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 13:28:33 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.012; Wed, 12 Aug 2026
 13:28:33 +0000
Message-ID: <f9aa7c30-a0b9-4afb-8735-6ed0c3cdf167@oracle.com>
Date: Wed, 12 Aug 2026 14:28:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: libsas: Handle errors in sas_set_ex_phy()
To: Eshaan Deshmukh <eshaan2031@icloud.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260811162223.411052-1-eshaan2031@icloud.com>
 <20260811162223.411052-3-eshaan2031@icloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260811162223.411052-3-eshaan2031@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0097.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5c::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: f53b008d-4c21-4987-dfb7-08def8759ad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|56012099006|10067099003|22082099003|18002099003|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info:
	HycDbW86b0X2HIzCMZ/nItEtKhEweph+eJBaxpp4GSx18VyWYj2yw81MzNJL6emtaej+X/B/WC3bFb8LjR6XieNVFTZVABSnmOUuWru3uHS6tHpo6JC2Cd1qk9lQPhzFkLw8VzlqDTsmVuz+B3fep66Z2btmOqKTVe8CukIxJmF3tJ0gM6tkSb2WM7REqFYiPBqPQO91rdKdu7qCGrT75FtuQrLNLdbfL/V/ctLJ0o1ZWMe5gG+5OP4LBtUU0SzxCKx5xNPFQZN/2WJXIS5+NmyS4yZdJ2STMri0cMaKyNB2mJTd7UwJTZ0ra4F329S/INVDahXQVsR0OUpe44gF6UbVAHG+Sn7tWzXUd0J0+CKH0/zWEjIpOU3s3WyETOcVGAlxh+we9GO3vT2Z4yAOJrH2r3oeAQTTqWOMoutNP8bq+k/ntVAH943T/105yx+XP5KHrGnQhOmcDTdW83SvMOOUW+HICZDW5gtCYlVCDRyq0+SFLj7sVaeAhN0OTyGaCtPu682gzu0FJZ2C+WurlybRZcjICg03i5t1eqoAr8Irf2o5dvhouoNC8exaI5ulT0DuilUv3CdrZD22Q1o+D4XaboWwNgbtav2Bgm8X1cL51ofCJeTf61WhiLrlm539THOu/lAeA1BViO6vzqx8tDxGRWnHt5bruQ+R20JWZDY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(56012099006)(10067099003)(22082099003)(18002099003)(3023799007)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1dCMU1PdDZ6RFk4QWFONU5adlF3SHJTclE1aGJ4TDNpbWxpRWNlOUdvL3Az?=
 =?utf-8?B?QVFlOExKcnRpU1hKWEt0a2dLK1FKNFlZemZEZ0dzb04wczVtNFhSanVZZ3BN?=
 =?utf-8?B?WnIyVFV2SERwQzBTUXZSTWdXVVFjUDd4eU9BcUN2NGdZdGg5TlJscWFoTDZW?=
 =?utf-8?B?VWRuVmF4VjdSZWg0MkozVHJ4TG0vTzJwYlhubW9acyt2MHRMbjUzL2E1SFAx?=
 =?utf-8?B?eGg5ODhrMTdJdzRhS2M1SnNDSDBQTlJmWjVyV2RXTkpVL0Z5bWJnS2lnYWp0?=
 =?utf-8?B?N3dnWjMwMkUrRjNOMGNTM1oveWhaYjNTWmNlV0FtRzVFOTBHa011OG5HOE9K?=
 =?utf-8?B?NmFLWXB6Q3FNMHYwcWxyOWdGaUdYZkxlWVpPQ3lOY09zWEsyT1I5STFES1Y3?=
 =?utf-8?B?ZEMyemVUb2l6ZnQ4Wi93RDBaQ3BYZXNBMzlsVUlZTUVuTkV6YnZBU2VjTWp4?=
 =?utf-8?B?M3VLZExHa1MxQ1ZSdGc1OVkyYmlLSnpMZko1OFd0blBodlpvcFc4dnJwanBk?=
 =?utf-8?B?YmVRUFRpRklPTStjeU1mdmh6cU1HQVFKa3V5TTE4WkdMc2FFUVk3WmRZQTFX?=
 =?utf-8?B?NnJ0Yy9DbW84NkRqTjdIaExuSUhIUGVEaUxoV3pITXV5bXlnVzFCYlhKU3BE?=
 =?utf-8?B?bitrZndFYjVadDZCRnFwR2NaVkpmQ0c2VE1SNkJIVmdBLzQrYzllKzlqYnBi?=
 =?utf-8?B?WXBZMzUvNCtZb0tudTZJdE4rZER6RGpBSEhxVFRnbWwwSjlVYllSRGZCTERu?=
 =?utf-8?B?YlZ6V3RTZ2o4VnRXUTlaUS9hN1B5cGprUUVadUxJeFhLTWhURllyYnZ2bzNF?=
 =?utf-8?B?RU03aTRLZUZoR1piejNvMzRxemlNSTZ4aDkxY21IR2hXYlNrR0I0Qmh6VjBH?=
 =?utf-8?B?RUlPMFgrOE0wMUNsRndZTDBENzNlajBrUldsMTZSTkp3UWR5TllaSnVGQndD?=
 =?utf-8?B?WTZVY3hNQ1Z5ZWlEcDE0UlFrOWZ1dFZleHNoMmw2bnNRSjJKdjN0dnJsb1hJ?=
 =?utf-8?B?M2pXTVVnUDVQOFcvRmMyZDVaa2lvcTh0OUVPWEc1MERCQzNkRjVVZS9hdXRx?=
 =?utf-8?B?aEsrT0VoRHdaek9haTYvdHVrSklpRCtLWCt0MXE0MWNoZnhERlBGRkMzeHdi?=
 =?utf-8?B?MEtiSlFZS0FSMnMwbGN0aHgxcnErb0c0dlllYThNeTlSa3B1K2VSNzl5bTVB?=
 =?utf-8?B?bEszRkdUcHc3cmJXYWFRallWcWZTZnhZZWFOenM2YzZsV1lUTzBsK0hjRGZk?=
 =?utf-8?B?djMxcGRYSUtFNXNsU3M1RmxKc0VtS3V5MWhBM0wxT29yczh3blBqU1BqLzF0?=
 =?utf-8?B?MG1MUnM4WmFPTDZPNEN1UEFLb0hjUmhZOE5nMVptOFMybllPcU4xRUZKYllR?=
 =?utf-8?B?V0FXSFhXc3oydC9kc3YyaG9uVTArNCtVWUdsSDFDb1MxL2JYMFd4eTEwZzZR?=
 =?utf-8?B?MVNuZFhaOWRzazE4Vml4UVV0TndvWHFkdm9WMnlMbjMxc25VT00yN3JrUGdu?=
 =?utf-8?B?cjJTS25HdHJkaTk1cmZCbHNKaFE3MWpZTGdQREs0L0FKTG5pQXRUT3htZ2ZY?=
 =?utf-8?B?TWVtaVk4aWRoREhZOUoyeEhsbUJ2L1JoWURITW9zNjBaOWhaM2YyMlYzdlM2?=
 =?utf-8?B?bFExaEcrZmtvVmgrK2hjbzdrMDJ6TElHWmxtSVhGTm5Pd3gvcU4yV0dDbSth?=
 =?utf-8?B?SHhnZlh3bHVxUlF5NVVNNjcyS0lGMm9vMVEzNXZ5MG1LZVhzeHlOUmRCZ3Jp?=
 =?utf-8?B?cUZSMkdxaGJlZFVxQ0VSOWdPc3RIZ2JuY2Q5djhPWm1YcEZPYUZrRTBYdnNq?=
 =?utf-8?B?cFpSRlpuaGlzOEJKL3RhMnJhZDdzUU1hVG9WV3hUWitSRkhiaXdPS1Q1M0Jm?=
 =?utf-8?B?bDRQNVNPb0xGRzFkakZKTUZaUUxiL3JLMG4zSGhYL3AyRmpzelFFK2V3bGdr?=
 =?utf-8?B?cHFiTHR1Z2VCM0MzK3hqcDNrT2F2dk9mSGJteUxCbSthQU4vcFFCY1ZsWHBz?=
 =?utf-8?B?NHVJaHVlNC9hUmVvR0tDME9IN0liYTVvdm9YbWdtRWtlVXJwaC9CbkFwdmYz?=
 =?utf-8?B?Ym1zR052OWhiQjdGTVJmWW56UTBqVUdEWnlzeHJVRXNyaGJPS0JzUXdPSFpq?=
 =?utf-8?B?b0xHSEFWc0F6WU95Z3R3RXNlZHJ2YXpMbk9vMy9DMEczWnd1WTl6bDJ6M0hS?=
 =?utf-8?B?QzNLRmJDcWtadWIvbzRwRi80NFcwSS85WG5JRkZrcXVrZ1NuamJyaGRsZ1lE?=
 =?utf-8?B?WXQ4WXorbmV5bHRqamdCWitkaWpZSEJLTzNQeVBBMm1LOE03V09jVFB1bnhp?=
 =?utf-8?B?bVRPUWo2YVVrUnFVYUN5Mmc0YjEwc1BnOTFWMnczWndyQmR1RnFpeExYZkxV?=
 =?utf-8?Q?bDSkpVyuXvurVRUw=3D?=
X-Exchange-RoutingPolicyChecked:
	ieric+HllR7tW/DZvs75FHxIjuD2Lnw80QRKl8eMlVGFDJ54cHaDNkUTZ3HCbD7XOe/rN3DvX8yueYkvxt1aHAoWBZKGiwjhrFiZV/DEjj/w5ffp6BWMnShb5Rm8pUl4UseXjQSl0QuSrQaA41Sd7jQlF99jK1uGPKbB2DfC0P70HOdGGgXV+6o7tgAdc4+9KHD/lv30J/PPmDLRMjbbRTXcjBh5YecIvPjMY4TAGxriAocG3Py7MeEbDoTMRI4pma61FeRyBc7Eh2JhOJ7p6p/Qvor8KM52NT6NJJh0Ji9PBk0YCenyFcwSqxMtQMxMBitnWqumqxIn4QSKPBxntQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2aTnijvl/TYT2R3R7f4rluJZIXghLJXPjCVO7rwye0uUch0fWonlwAgdjsGth38576iDIeid0eKq6Jnrh3YhZgkFsv6WCSesIi/j7R/6JJpr/c1ioEw4tJjO8In/TrntiF28Jei7ferWkegVU9xXUPMfFtyc6Ic7CymhydtgMr1YLRgik7cdMP0GTouJxMCybdyj2OheJBei+WcNVQkoqr3XLaEChKSA7N2qa3/qzIfJoWYDTmMdMbOuy6CjnCyrV0EkuI2QC02G/odpu6jmwaNaqM5lMBNrXklPH7tfW9kSQRKL9ncSCl1qjpf9gHf+8D8sEDmb7LF6glVNDpuGkJ1vbLPHJ957CapuDkioZVB9yo4Rn832XZz5scNjuXbsseHRcLKqMTux6MH6q0F1VkVW/j7zydfrUVep02xcKyNzFiTFkt+hK47hzaJoU5nWqbyaIk4ECBGq4IpWo4kCp9aQLNB9W598lZpb+/2qTjzqlJIpg3M/6daXMVnlcAKkfY1eruPNycD4yXaW1zXIPxmbhF8WaLW3077NMCV1PtVmsM06fCAmlXJfpz9w//8LsfKO7VEALQd2UDb58V/7SuxoNvq32pzy3cs643+DM9g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53b008d-4c21-4987-dfb7-08def8759ad4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 13:28:32.9564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: swuhKP0/0qFWeXGoiu9l3az0K8+hspvia/EmhGiUFri9iTtIBSrQnhGuSTEwXPtQinfyZfpDNH7DYtMhmgEtwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7856
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=937
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608120109
X-Proofpoint-ORIG-GUID: LkOe57l5DfKtNszYbwgwqL5DpmVHOyjd
X-Proofpoint-GUID: LkOe57l5DfKtNszYbwgwqL5DpmVHOyjd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDExMCBTYWx0ZWRfX4ID4+9sQb7vH
 jWdBpO0INCVRzBVrHMmENxhryePnA8a68G38cOBdabG5cE3TZk4CXERNUGthI3g7yMlF30dyspY
 /Usml9oJnu0eWuTkYTt0CAiIJEOPY3jahOZcLHIAHowK0APkLdevsnZSpquReFphA8y+hYXBaQK
 2qk7plwYn7KVSOZi3Jkyi6C321BTcdiMBlMtaFfNopWEj7HvL6gds8Bv6nNcYb+jkNySZPJClvb
 Ulxu/sIYMvZfTMMIb8soxQVQcQwoQe1a1Q6rUa2hsJYOt04Vb/TcAgZKfyynheXGtiK7zjGwEYH
 Mr5EjeCWWzZpbDcj8ahyCpYw9x1AvJJDvYyiZxA1yPbooftrp8aqFlLlsjMbVuVsb2TY8K3fRUy
 aB+d3pT6lZsJ9ya0s+Uk/PpR4+vhbyimaNUvmODulo3EaUMhX5XijRZRLISvvg4q8NCmZE98rWt
 OTh6pcmb9zEGDdZcJFw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDExMCBTYWx0ZWRfX6ioah03LNdNB
 UPWyOgb/YNZrtAAC6FM/mA9YWe4H7D/LPLlm2NG8HIUaUESkOFJ9+S8gc1LknmnvqgUVXjCyYUo
 01k8W5N27gtw0M6sH31M6hh2g1uD99W3+XOgrqIdT4ukven9KB9Y
X-Authority-Analysis: v=2.4 cv=L/YtheT8 c=1 sm=1 tr=0 ts=6a7c7506 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=UFZO8tVL01KODhc41ZUA:9
 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22

On 11/08/2026 17:22, Eshaan Deshmukh wrote:
>    	if (new_phy) {
>    		if (WARN_ON_ONCE(test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)))
> -			return;
> +			return 0;

Even though we output the WARN, I am not sure that returning 0 here is 
proper. 0 means success, and we have not been successful.

