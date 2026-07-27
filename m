Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69C732B12F;
	Mon, 27 Jul 2026 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168453; cv=fail; b=iMHW8puzu81OnevjT4u+bQ4LWkmba93bCXmJgerlhLYIN+N4eM96eXALRYgs3Nh5sy3NTX8VBai28AfOIHk1UhznMayv7ejI146pmCAkh8Vn1mExhhvR4nm6DjNW1rpSO6RJ9yR/b+pkt0TPzlEVGW2Ut6qfx7ti1+y31sj4QXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168453; c=relaxed/simple;
	bh=lHO6wwZDoFMxQMrQ1bsgAbg1+LZUYVkIeOEUiYqU3ZA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gs7Hryl4r5CTxuMWYlbfRJTHk7+9BM+moZkytS4mRDu53qIF20INyTbaVzppwhSpSmLtH3+mbhIsP9sRcsjsiOIbeD0eX72FZj5HCJl/TzZTmC0PCSc3MldGMnYzKOtKYHe/CPJ0OYSEEGod3qoTE9GF3idISQrNf5pIa6V4bMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SG8KMA2O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m273frP5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SG8KMA2O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m273frP5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFtVsn2610532;
	Mon, 27 Jul 2026 16:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kmV/RVDsZBcaLnhSdMqtR1EHroeDP0i4/Jpov4XlFiI=; b=
	SG8KMA2O9GmeQXXpCUNal8fCutHDSU8mmwzJSmlYV5HRcpj2G0XjPgF2+SnV/dJN
	4KQTrrol05/iYtt4gPUxM8dq+Q8VKIuobLqCEYsUPQXe9dpJ+kwqnMI29pbHH9qe
	OvLQ/sjxwIRr91RC7twaIOTas5QZMcq5MlIMEqJLauoGjTZWVrUXo7uAHz1VbtF2
	4KWvtg3OoxPOOBwTcxD/LMSS22r+WHyYhmiTkRrLNLC2if/QWRk6uwrXvrm/+uHF
	pRIDPTx5/eHJdKm6AV7AnB3/H0cc7v7LZA+yuaJBNordnKcriK2BxG1/P0ja2rvy
	YW5v8P+oJlfsUovWpBHl/g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pj3w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:07:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RG588g024269;
	Mon, 27 Jul 2026 16:07:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011070.outbound.protection.outlook.com [40.93.194.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85vmnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:07:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dC3ZWpHrMQznHCFBtZWx7JeRrw7y8hQDp6aqR+CGBulE9HpTV0yTvGWMBKD65EfEbKopTmFZHmXRst7nnahlDqUJdVLn2VB4v7L9Ju8tQbzyGVMn+QKRakU7O9p08fKshHxMRyIe42vV5Qyy6jsyfDPOnkM5wScG8T82/+WqvgRmB74BF28vDXD33+OIAdOopXXW5/9nq+WJ8Yu4XgBNIHj3X5SHpTnA0E9bfcYbOJppd1/kiNio1gfJBL8Km8ctgieyuOSx+MdZaHpKJxueTGECZP2w+n2CqznyRbRoFG6DeI1Jh0H2U92qPIX34ghsAjBigBtyqpf7o2tE0jXwFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmV/RVDsZBcaLnhSdMqtR1EHroeDP0i4/Jpov4XlFiI=;
 b=CcaDi8ODfjhax3+knP5+nl2d1FqIzz+e2gpbyVl0JZZNP1qM8jPvVYCf457zbCEO6eygmu97ARJOuyCs0wiiLE3uoUTBxI3o9i66MN2ZVbZPw3EJhvN0BQ/V0uk6MJQJxgOZKqJZrWXZhXS1BrNIPLX+Hmy39oNgq4ZJkgTJq3cd3Z3xEUNXF/U2kxVYEW9bjS/dDkhSFav9+9sfDjECQQo6gzSpRHxAVYT1fpD8t/YX0DnHlT/gQOz4lEkhuUjsziw4SA9FnuVHjyR1GpfVwu/ajizrb5r0ea7/E1/ulwa0GPMGFlSr9HBYE3V2vdRcuLaqqOtuVt8/gS4+Vie1Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmV/RVDsZBcaLnhSdMqtR1EHroeDP0i4/Jpov4XlFiI=;
 b=m273frP5YcBP8SiUUuAQTywgRT3pAYMDeECiV4Yj26KXoq/b/gOoFnv6+TUCz2UBqy65bAJVaVOcVgHzEIXuqbmrwecOzUSk4/pvwxWk0xgZGQQDOpS5d7is2ahHv5Zlkc15GfMEHiI1nqOpxNXHJhHaFUfrq/uMXw7vxbzOL+o=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LVUPR10MB997810.namprd10.prod.outlook.com (2603:10b6:408:39e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:07:17 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:07:17 +0000
Message-ID: <ae7e6c1d-bd37-4d7b-84d6-d37949d842c3@oracle.com>
Date: Mon, 27 Jul 2026 17:07:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/27] scsi-multipath: provide callbacks for path state
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-20-john.g.garry@oracle.com>
 <20260727152429.526281F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152429.526281F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0104.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5c::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LVUPR10MB997810:EE_
X-MS-Office365-Filtering-Correlation-Id: f016c6c9-0d49-482e-e7e2-08deebf92117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|6133799003|5023799004|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BeiFpBF0WOIA9Neko1LmFsFpPtaPC6VEcgy5NfcFBlaoqIqKDGzyh4tnsH759ONzGjmcNQQyfLmYX6kFmRDz3gpiEZlWGF8xEYFRnS+3WOX8WohMXkmDdputhVeC6ensiGtGlABcHt71UYYcYJV3RMV+BHPSgYyI5UQAbp+U8M5LpAk/0BLJYg3PmvyP8Al1WZiVx3Go2siYpswTdhdIsqYUWOTz8CC15alKYqtCMfv1BrrfVgqhDCNqHfIxwznsZ3nYl6ya6yr/QOecqpSVxoshop5blgawUfu9rGLRWSNOcopcdXUXTePfmf4CmRvYNY2hjvz7mughy5696nEBnocyaXn8x97KgXXzNpriyzTcKCNgzB6pwFxUzOuL6Sr93I1vtDW+D4gUKYrZYYE5rvDiIrAuDKYWDeUOC3trQHqktc7WWLg19hN67s1P0xXJxHdfwAmJCf8hYLKdf9dw/vxp2RvowNRXukRRHrcHK934444zJwQdrXdYYyq2x5g7ZLY8hYGndRd5Y9+TNlKeCFJzKAZtTXuJeDuPtxoHaQOijgF+1BAOggqFmhvAcQbiXJbnCOQTdh7yQ20h5KbcJ7ZvJYJmqeEcD6GlGlIfBCxfyMX3WdzmbRvS208Ph2to3VM8P2BTj8gSInS+uvOTVFFAI+nj4fOByJN1+R6IqhI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(6133799003)(5023799004)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1hnMDBUU2dwZ3BTMFhVc1ZRdUhVejdnNnhsbnhVUjU0TGcybWlOOHE0Vzda?=
 =?utf-8?B?enZKK2c2a3ROdnBBZGFNbGZUWDhXbjl5dXFVcHdQeEEwWkx6SjV1aWVrMTlC?=
 =?utf-8?B?eGVFNFdVa1FabEs4WVpoVFBhd29ZeUxKUHdpaW1BNm1CWlN1ZUVONHJXeGR5?=
 =?utf-8?B?cklPVC9RV0NZZkJzUUMxVW5iazNCdE1JTVUwZG1abk9pdmRWV3hUTkhvNGZ1?=
 =?utf-8?B?MXMrL2QrdUFyazgwYmZYeXU3aFNaM0U0YXM4NW1TZGtlNDJVMDVQMHFLV0Fj?=
 =?utf-8?B?ZjJuT1g2SXdPME9od2JtazRKck1MZnpjbVBoWkRxTS8xNmV1NGJjVlBNbVRn?=
 =?utf-8?B?VmJIdlRQMGE1VHZGdUlsa0NRM2tFRW1NSTdhazdoV0NpUVVKTElnTHhUUFhE?=
 =?utf-8?B?WHNaR2ZGWVI0OXhudU5peHAzNkpmd29RbzJNVitRR1ZjLzhnQzhRMXllYVJJ?=
 =?utf-8?B?bXdra1ZsSjM1c2NBRnh6eUR6TFRhVGFmR3UwTnA1cWF6dGlUb1duQUFUOW8v?=
 =?utf-8?B?em1uejJvN1JyVGI2WUNFN2lPTkxYTXJQVlE2ZmRUOXhMUGMzVlBGTVlSZWNu?=
 =?utf-8?B?MlJ3Q2kwOXdTangzTW10cGhwWmpUTnJDZmowTFg0RXREbDN2blhBTGRpZkMz?=
 =?utf-8?B?OUZRMXliMUtVeHF3TTdSdTJaT0NodlllNWRyTmxmeWRSd0Rab3JMaXFxK2hw?=
 =?utf-8?B?YjQzOGRFU1lLb2JNVmErVzd1Y3lKYUp6elJuNkR1WEJUdjNBZUxJUTVkTnpv?=
 =?utf-8?B?WGdVQnJsd1dVRlR6MFpJVmxKOVFGL3dKaUdyVlQvZ2J3cnlBY1ZmZ2NUVXZM?=
 =?utf-8?B?K3FVY3AreVpNdWZtSTZFd0tvK2dOc01INEhyUG5XSDVoa2ZZTFp6ckl0dHFL?=
 =?utf-8?B?SDRici9Yd2RCeDVGclJYMER4SkJwMllQbThHWnZxZHU2YTJsRWNac2xsT1Mr?=
 =?utf-8?B?aldHSW1ZYUt2Rm9Yd0JxV0c0d3ZUa1hVM2RBM3JYbXJtNTEyb2NlMmJiMDFB?=
 =?utf-8?B?V2YwbFg4anlVcnpOT3RyYjhTSDFDWjZNUzJZeHhacVdCZnpKNlN2bW51eGlP?=
 =?utf-8?B?ZndsRFEvVEZESWFCWFRKOFpFVjNnQlhJdE9rckVmeHV6UzAyUWh2OTgzbjlJ?=
 =?utf-8?B?UXFVT2xoWnRIVWxvRXBOZmdNZVZKdkdGOCszWExmZDdXZEx6eHE4UXhabTJP?=
 =?utf-8?B?WEpKTFJhclo5cE1kbmhZM3VUYXJNeGZyVmNPSEtsK1Z5SGROVVJhVFZwTFdY?=
 =?utf-8?B?THdadUNLVnNlZDRSTUNaTFlNRUtWSlZFdTJjbG15VW5PMjd2MTEwb0FQS21B?=
 =?utf-8?B?TURQODE4cG4rcm9kRURVWkExOVU2dEk3ZDY2eEFKcWVCdTdvRW9kckNoNG0r?=
 =?utf-8?B?YUJkRG1vbHk2aXdWK0tZdndOblA3RUJVTUgra2NMSmtBazlmNG1SVnBRaFFB?=
 =?utf-8?B?RmJ5cHhuTzRYcW9GNkZ3eG1WVDZrdytYUUlPV2NnamV2dGZlY2lSTnhMVlF4?=
 =?utf-8?B?RjNpZGZOQ2JLWEpaVTJCV3ZtV3dpeGdPTFFQZVZSaXVqb045bmY5bTNjNjVG?=
 =?utf-8?B?M3JER3I3OXF2QmxzWnNhWWFIdDBKb2pEemVVMXY3TWpXM2ZKaERzbzA0WVMw?=
 =?utf-8?B?aG56dlc1NDJPNHlSK0FBU21VQ3pjcUU4V1A2QWJTUmJnb0VWMHV3VEhuK3dQ?=
 =?utf-8?B?MlZlMnZIQTFaR3ZiQjRPNzE2dXlnUWZvRUY0N3FtL2JkZXdYSFpDeGRFeUJH?=
 =?utf-8?B?UDdXSTZRa0kyWDVUZmpna0tqbkdwMFJYWXo5cXBJTW05NGV6UzNkYWhkVkEz?=
 =?utf-8?B?bTduTzA0WkRSckFJWDdHelhVY0ZxOVh3RW95KzBCNXN1Qm9OM3FrK1MyVzZ5?=
 =?utf-8?B?dDdFcHZBcnVqc1RXdS9qN1dhM2h1ak5IZ3h3QXd2WldwRmJMRlVORExDWjFh?=
 =?utf-8?B?ZzRXbUpNTkFMLzF2UXpzOWxOSlpMajEyUFcwcDErRG5yQ1J1T1lScVoyT1VC?=
 =?utf-8?B?TEptTWNYSjlzZ3lRTHBkRW9aeHBZYVUxRVZNVjB0ZFlmZmJjd3Blc0tXSWt6?=
 =?utf-8?B?MjhrR3dOdzluREhBMkw4T3JzcEJ3aGY2MlpFbFBJblFBSnV5allnUTloaDE0?=
 =?utf-8?B?UG02ZGh1R0E1amtrMUk4a3ZjeFJ4VkdwT3A4QTdWSUw1dFQzSk1lV0w2Q3Jv?=
 =?utf-8?B?K2hEU2l0d0g1SENCRldVUSsvWXlEQXZrcVltc1dUTHdtaE12NnpnT3hPWDhH?=
 =?utf-8?B?UzA2TFlUWGpja3hUR1czaW5NTDlMay84eWxDVDd0RmtOQ1pWdVQ4Q01TVTZM?=
 =?utf-8?B?bWVQQnArcXVoY0IrVVdybExRcUxwZHViYU5CUDc2NlFOdUg2NEc2bjBpL3cw?=
 =?utf-8?Q?TxwmDedo/ZL332n0=3D?=
X-Exchange-RoutingPolicyChecked:
	jBPszWJmfMdQeCy7nqUNDPgnPMgTvZAailsJ54OFP4lS0DRT3RIaRYlFl1ShX+/7YHdg5IXHcumnWQ4CKv/do8QcMiEdDm2xotak4P3bwed+B9wSMx8KZxuEpLywr5PA3EMT0LhETdxAwZkjCYOyGvrhevRFCoUrPtubWQJ2mYO7bwC0ehDyfE1Eboo7cYop/t/KohCCtowE1Ncn+taxVeR8ig8r6XZDzj2M6XEjp/LPKm0OKNv7tRED4HWbjHZ+pLBxu8eKdnYsvo2dFRplYU1q1N8I0bGptfBAqSjpF2SZLlozYWNGrCu6Upc6k2rXciSo/OdKnAHTscx4IfuR2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w5/1ly1XN+RQ50jGrxESCpnP1IUoTqGcbhDoXZya3Bc8VHSuBHUMcPoTYdlvePotg7/Xiv2mDkCGNEwc1KUW7F3vvVlbJniePwINrhEYB8iDB8JOafVZQibpwbZpkSos+hQhXdu9JTg+zkHlZE0Kv5zPQb1la7UKCD9rVPtxS8qdKRF34S/uX7QJ20EVVDVjrDQn90mYCNehYU/LUZgUsnzlrU4KXLJn6+513uqZ5llvnwX83FFhBPB4B3di+1cWlqyRMxUTPyOvKsCC7FqlYtwMS4MVBVwH0M9Pf1396G5OXFzUkveLgdCpVfPSgpGKqDoKjXxrBRVcaJwGR4haF4tt4Rf8tNstEZIlw0/XfrTec6hAs+KIauyRuIEKDsuqTp1F9Tva8GDpUBhR9ShcnYGktKcaXg24/QtwkyPKy8XHuAJ44GOEgk+UScaN+/OH6mF2p6mHeJzf3O17lAeMULAK5r7n2C/j/c1GGXHesoEKoglXA3Too/PRlM3Xu+LVvedlXYlNwG8toFglVQOY/weJrzPa9nE3BnpS6USIYEb6QH5cu1D637ZJO4jHxF34r610YwRIKrdMqL6YTG83kRrP8tYmA0gjmCW10eAhVpc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f016c6c9-0d49-482e-e7e2-08deebf92117
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:07:17.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYdt4vS4QPIeXR18juA5ST9YBSAaaaC69NNHmOWZImJ+fAe+FPdVvuwFTPbVb+rGvdoOVWsOr2+4Bs922JmEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270150
X-Proofpoint-GUID: Hl0UTUY4BCJWXYqVkqHToi3QkUhowxJg
X-Proofpoint-ORIG-GUID: Hl0UTUY4BCJWXYqVkqHToi3QkUhowxJg
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a678242 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=q23SzqnpkpqsztcQhNIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MCBTYWx0ZWRfX6tVAvP4DN/Dg
 gRrKmdAfXjkW3a7oW4Yl0g/BzSelqVl8B/RYsQnT2ts/GjG7rDmdKqNy6ei++UIaZZ8r3DQ54Pc
 nUtW6J57ulRFEVQo/lruaa5HMo9m9rnF32oEsWnizTbgFUmdj7erEUyb937/qp3kSd4uTZwSz88
 c3l/sgA8YwO2C/SK5lZ603jQ3Bjx5jpnKbGDI4Sy87z7yh2JUH9Nme1oob7K2eeypyjR0Kn+6Nh
 cHczsFvecUX4oLABkCxz99w0HKxhnNFAfYRhg5jLjGQHGGAD9aEQeKkaIkU4AVvrqdeB2HJdzHL
 qpq8n9Hm0GogvFzyLrBiem4daD/lVSjGKNG0amESuh5WBp4hXzCaBg1k5ZHurFwY+GTAUv8YO0N
 /TrOWVOO0URaRbETtw7hD6QS+aDPaRXUykGVpBS39jBC60OgAWYmxSY1mwAqlAtsMKIgJqeUw00
 dDliqCiMpeZ71pQXCuA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MCBTYWx0ZWRfX6NcxZNURykyK
 Qhmuby8mm+bTcDbWbfH5/LyF9d4ueFebqHaMBlqCf048odQ4Rgq/26dYeSlWUkavOedV98amMg5
 TqJiuDk7z5MT9j1C7sj3OhfG5mWmwjN+JqHtER14e5uzh4N3qNC3

On 27/07/2026 16:24, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] scsi-multipath fails to kick the multipath head's requeue list when underlying paths transition back to a usable state, causing pending I/Os to hang indefinitely.
> - [High] Core path selectors ignore the newly added `.is_optimized` callback, breaking ALUA priorities for round-robin and queue-depth I/O policies.
> - [High] LBA-dependent ALUA paths are incorrectly treated as disabled, leading to complete I/O failure for LBA-dependent arrays.
> --
> 
> --- Patch [19]: [PATCH v5 19/27] scsi-multipath: provide callbacks for path state ---
> commit c99fff5c406ddb30334df26d8cb6dcc7c86e7a13
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: provide callbacks for path state
> 
> Provide callbacks for .is_disabled, .is_optimized, and .available_path.
> These all use scsi_device.sdev_state and scsi_device.access_state.
> Member scsi_device.access_state will be driven by ALUA.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index ec611f26d7960..d79e1b7b90051 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -314,7 +314,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
> 
> [ ... ]
> 
>> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state) &
>> +					SCSI_ACCESS_STATE_MASK;
>> +
>> +	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
>> +		return true;
>> +
>> +	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
>> +	    access_state == SCSI_ACCESS_STATE_ACTIVE)
>> +		return false;
> 
> [Severity: High]
> Does this code inadvertently exclude SCSI_ACCESS_STATE_LBA?
> 
> If a path is in SCSI_ACCESS_STATE_LBA, it is considered a valid, usable active
> path by ALUA. By returning true for any state other than OPTIMAL or ACTIVE,
> won't this cause complete I/O failure if all available paths are
> LBA-dependent?

We don't fully support ALUA yet

> 
>> +
>> +	return true;
>> +}
> 
> [Severity: High]
> If a path's state changes to become usable again (for example, transitioning
> from SDEV_QUIESCE back to SDEV_RUNNING in scsi_device_resume(), or when the
> ALUA state changes to SCSI_ACCESS_STATE_OPTIMAL asynchronously), how is the
> multipath head notified?
> 
> Without a corresponding transition hook in the SCSI core or ALUA handlers
> to invoke mpath_schedule_requeue_work(), won't pending I/Os on the
> requeue_list hang indefinitely instead of being retried?
> 
>> +
>> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state) &
>> +					SCSI_ACCESS_STATE_MASK;
>> +
>> +	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
>> +		return false;
>> +
>> +	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
>> +}
> 
> [Severity: High]
> Are core path selectors actually invoking this new callback?

It's ok as we will make it work properly when ALUA is supported

> 
> Looking at the core selection algorithms in lib/multipath.c, such as
> __mpath_find_path() or mpath_round_robin_path(), it appears they check the
> static field mpath_device->access_state instead of invoking the
> is_optimized() callback.
> 
> Because scsi_multipath_sdev_init() hardcodes mpath_device->access_state to
> MPATH_STATE_OPTIMIZED, won't all SCSI paths be incorrectly treated as optimized
> by the core logic, bypassing ALUA path weighting for round-robin and
> queue-depth policies?
> 

