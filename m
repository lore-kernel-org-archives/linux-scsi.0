Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341702D3A8A;
	Fri,  5 Sep 2025 07:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055914; cv=fail; b=cNeflLMcMrCb91+EasL3x3HGnEsiqxzyEJyrGws8xgaModsA08sP0HII6fE8r/Bsnr43QO1YKHsep9NMSqeztiVwxHCHQq+ekoRPOZ2IJVUhQjb9TcznmlWd9LdVp1FtV24aetvU8TSWR4SpeMb7FNylMfXpvWUszsYm0m1ylXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055914; c=relaxed/simple;
	bh=13FRlW+x0iRbZIBz1FHqerl3CIOwYbnxny7jH86z7qQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=acUAzzfnYbgYWvgx06mYXcJn2QH97aAqyG8cHZTx5hQ1nXbAiecz+EkRPBdSqqHAWxjgwcuVj0S9X6nmZRDz98tB6sX0Ee+1f+PhyjrccT2on+SjWUvPMUNRqJDI/jfz2RKnzNcUpdcwtuMNUPvpK1MpMzNQzQJYm/jbcuTEZqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SO6VvnFJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Egd7qvSw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SO6VvnFJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Egd7qvSw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585700n4013529;
	Fri, 5 Sep 2025 07:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IEgSrK+mwDcXhUllL6VjqpY5LwciZvAd3gTwa/o3FYE=; b=
	SO6VvnFJvVZX+GVqJO/0n3JvQfn7DgV72/BBjQtH4f2BR/u/9QImCuA649LyCXHk
	9GO2A4c/vQA/ly6a2gG1E7TIKU0818eai4UdVmv805hEsHwbpUUN35atEDIzjmHo
	u4SbzLGs4Hfcm9m0r4s2yxNt9qaT3cdFTo5c/xkwvRgnlHoFw8+OHfkLUOuOCliF
	8weNLTsgfCjjIISUhMBIE9NAxVwecbzqYViiLyqMSvl9z819t+tng/9Q2OXz7ewi
	GEiAR6qibzwgK15ZOPnB3DtI6Gxv5KQgF9yaSuFG7YBQ289frBsB8YkgqfAZnRK6
	ayHA1VifvUlrhXvjvxSKqg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yu31r09t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 07:05:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585740um015744;
	Fri, 5 Sep 2025 07:05:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01rt3nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 07:05:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nrdDCLbyYXYGCW8eyGiwCZbPVpCeYK4iydeLewQyJfxfdu2vAxk+yIoNwOX0/TDxIDHm9sDQm775lptUZVoSEt5HU3eK3jvP/XURypyQqlWZeDqun70RPPBI4Ae7dlvwyaiCTrqGa7Jon1AMzr2u+sBTOd5aRJfSIQY3WXk/Cd67nALEpCuK6irR0/64DjSyJo2F5lmVju8U0bTn/DEP5s7FIiLOdgH55o+lsYjER9bQSuP6bNZ9Mf9nuXJ+9ZAn7o3COMOiC68/2juK2FZ/rgOWyfyr8jaojKn2tjcLDIFyQRcwn6yyjHjdzimK4Od3FxWuf5Nc1DGvrCcht2L0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEgSrK+mwDcXhUllL6VjqpY5LwciZvAd3gTwa/o3FYE=;
 b=xOkVzWHQEnupsiZqKej795KUxPSXw8ZmhxyC3lgFl5IPY4qDCn2SS0TS3G1wdXFeYsVr90CTX5vPcSaQ1kX6i6KiMCUJq4k+bnY8JVM2qZImg7uUnTqwWj+AVdGfxyuKzmKca5NIi2FXhsmw1/tkitg79KWozrhItvvHqdxy+NiwbdALAHUapQ+PUWJw+oxP+89634FdZRhPLbYkSc7U+p3W/hF0/V0XGOsG4eO1wNjosEevOGoqbV+KoykCtyhTFYHaaHRCy2unUX1pzVhgX/1W7T1rpDmy/5O+KS2I5JX/SuAWqLC9vuLv4Ne397Ng30NUc7YM0osDfKJgvYOs0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEgSrK+mwDcXhUllL6VjqpY5LwciZvAd3gTwa/o3FYE=;
 b=Egd7qvSwBwgLdP8O5HtGQcIGsoWQiqoXygV1jhlj0S7Pby67abJQ70stYtlNJ4Nj+THOmSrQHtDeW7pYYFvm2lWCd3hZ0HvhNuih3Qc7GWdWXNx8t9b8Z7xmDr1LPi5wdCfmp4SIADN4KVy1Z3iJD+05aPwgpeoguOkyGFvSD38=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW4PR10MB6348.namprd10.prod.outlook.com (2603:10b6:303:1ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 07:05:04 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 07:05:04 +0000
Message-ID: <47624b76-3b19-4805-b48a-040e943c7f2a@oracle.com>
Date: Fri, 5 Sep 2025 08:05:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] scsi: pm80xx: Avoid
 -Wflex-array-member-not-at-end warnings
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <aLmoE8CznVPres5r@kspp>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aLmoE8CznVPres5r@kspp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0274.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::6) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW4PR10MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 88af5c4d-412f-4649-012a-08ddec4a897b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ai9CR3QwUldsVVlHREJ1cXdSMSt6NjBteWt5aE0rbENWMTUvWEwzRmlaaHJx?=
 =?utf-8?B?UHBydW5UUFlRSHZuMnJzWThGQVFEaFNwQjRIYllBZFFyenVuSDN4eHFPL1Ir?=
 =?utf-8?B?V3dsdlE3c2xVK05GRGFXYXVYNS9ubzN2citIM2VXQnhMQUxRdi9NZWhKdStU?=
 =?utf-8?B?enlIaHprY1dDb3RqbnhDdnZNcUVFZlpQU3ppQ1hKdFpwMStuamRjamVjVjB4?=
 =?utf-8?B?Mng2aU5IcVBWYUQ0M2dtdVdPWC9ac1ZLZHB5VmF4Z285MC9saWhna3Vzd3hl?=
 =?utf-8?B?bG5UdnI2TE53REhXOEMzT3RCNXpLY3lRM3NCMFlqMnN3VG9NbXhDYVB4Szcz?=
 =?utf-8?B?YUxOVWlsS2ZHM3J3VERnZy9hMVlFOXVvb3dMSmtpY3NGb0NBV0dFQ054b0JH?=
 =?utf-8?B?RDE0Tk0vcEk0UkNNVm1pMjFTQlNEWFZadlZPcmgyd1JId3Rha2pxbVY2RzBJ?=
 =?utf-8?B?Qk45UDRzL25ERVBHTTljOE1rc1ZzaSsxRWlMVUpobTQvRnFHaUt4d0loN3ZG?=
 =?utf-8?B?UU9PQk1wNHgyS24xSHQrTE9HWHdzY3diTzRMUzZlMGRQYTVEN1lobVF1UGth?=
 =?utf-8?B?VlU1blg2c1kydlNqVXZONnFrSkVzZGk2SW4zNEJjbWt0cGJFSWw5V2ZhUWlP?=
 =?utf-8?B?czNod2hSN3paMVFrYndjVHZDUDhDVStLdDg5K1FQVXVWTDFGMmZ6N0QvMTBO?=
 =?utf-8?B?SFJkc1hZS1hGeDVnT3ErLzduY2kxQWlBRXp0eGIxOXV5ZFR4TExCMVVzTWIz?=
 =?utf-8?B?bnRib2d5aEFvNzU3dnRzVXNVbnBpaWFxZHpqME9aeFJqaW9tOEJkUENPQmdw?=
 =?utf-8?B?Zk85Q2w2MlpNYkI0UFdFajI4RnUzb1JiMWlzZjBKSlZzbmRhV2RVYnYrU1ZJ?=
 =?utf-8?B?UkVPbjFRQXkxd1l4c29mZjMzd0JXZkZGeHF6d0VxbmRnY01uTVY5dlg5QkVm?=
 =?utf-8?B?c1QwWUVlYm9yd3lDYWtXN1BkTTdTSTZWOURqZXArZm5TUDU2S2xmS0dkazBZ?=
 =?utf-8?B?bHVvYmxWRG1WN3Myb1ZaVFRDcDMwalhtTjh5RkY3ME5TcWlTZ3R1WkdUeGJB?=
 =?utf-8?B?TU44Ym5SWG5KWEVrSUNlQWh2WGFCZ3FOeDNSQUFWQWsrSzM4Vmt1Z3NSNGda?=
 =?utf-8?B?K1cxSU5ESFFZbmI5bHpyMWV2SHRVOVhmTnlraGlpb0NhaWlVTkZmbWtLRWd2?=
 =?utf-8?B?SmdoWDJEK210V1ZzVVFSNEN2bFk1aTdYN3pDVjJ6NTc2d1gyUVhTZjAzRVZD?=
 =?utf-8?B?Rm1ib3Q0eTJWcXk0SGdMUlZTcWh0cnp2dGlOTk91WFRJdjl4S0VRdXNBYk9R?=
 =?utf-8?B?cHRqSWlDelZST2ZOQlFSN1B3Mm52dGhFRHRncWs5YkQ1MC9XQmxoNkxTY0JR?=
 =?utf-8?B?MmFvNmFVOU11NWxrRmM2UW9uNjl2Ukx4eG81ck52TEJ0OTVWUkZHRnJKUUNz?=
 =?utf-8?B?Wk9BcFBKNCtsc1F0eFNhQzdqTWF5UUJqVEppeFVKZUh2SXNRcTc4dG5EV3hx?=
 =?utf-8?B?MUpRc3NXckJIajZnTnZERnBHaU9JRFh5cERDM25pRFZoQnpxSElEUEdyekNI?=
 =?utf-8?B?YmZGSG10dXhkQ2FGSXZocXNTYnRrSldmUjkyeXZTZklwWDd3SzlDV2ZZNnE1?=
 =?utf-8?B?YjlzY0E2bXNUQ3gzY1FKdkZpUjdzZnUxaUhTeDQ5bzliV0IvdnM2Vy9CNVRF?=
 =?utf-8?B?bjBRbHRwNlI3NlRCSDJzQTdKcHFQZTYxVWtRdFJURlBUbkFsQnY5b1l0bzcx?=
 =?utf-8?B?QnkwYTVXYmE2ck9oQUdZMDQ3Zm50Tm83Nlh0c0pqN0duVEdtL2hlRXFRc0kw?=
 =?utf-8?B?Nk0wN3gxUlN5Y2h6L1ZQZUJOZkUrOUptK1k2YnpQL09FSjMvaEZjY2Y4ejcw?=
 =?utf-8?B?Tms3c2EvMnkxTkF6aVRTVCtRd21WRXQvbnJBUjgwaitqY3VJTkZvdFpraWYx?=
 =?utf-8?Q?Xi6whKmDwFw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2JEUkp1SzdSdURZNjdsQ2s1WlpzSHNyRkdwUzdjKzJaU1kwaElkSlNmbUZD?=
 =?utf-8?B?Yk9zbXVlK2tCNkJIWURGNkdCVGNQeFBiOEIzaGpWUmxHWm05UFFlaXRySXlO?=
 =?utf-8?B?djVGZTJpZFhXVTdneHNRSGkwbW1RK2dWR29PWWdBaFE2MEw5ekd6TisyQ3RZ?=
 =?utf-8?B?VGpBb3E2TVluMWpOUExoaVYyOTk4cEJMd0d0K0VvOHI0aklaSEV5UjZvRStF?=
 =?utf-8?B?d0paZ2REOGNTM3FXR3lGa2sycFlqYVUrd2pPRzhPVlEzSm1iZjk0NjhLOVRs?=
 =?utf-8?B?Kzl2emRjaWMyQVBEbTRENFVLMW1USUJ2aTB0K0w5cUV4a0dkUVBDZGsyNUxJ?=
 =?utf-8?B?aStweU9SMjMwMEJCNXNNVDk3Qk5mOUxQdysvejNxQVRqZW5naFBGNEJtQVlD?=
 =?utf-8?B?ZSt0c3hva2xtQWdma1AxVXRYdDFCYk8yL2cyT1FGL0FVaWYxbk1tR1NPWEFu?=
 =?utf-8?B?eGxacWF2OW1uUUx2Q2g0ZFBOdlQxVGFtaXkxUFpDOWk0UWxPTlN2Qjd2cHF0?=
 =?utf-8?B?YWkwcG15SlRuRGNnenNXdjVwS051WHdaWlNkUzVvYUw1aTg5dGpuQnc5aVNG?=
 =?utf-8?B?cFV3Uzh5ODdWMnUyOUZCZzZ0Q2hqTjlqckZyWmJ0OXJLSjVLU3EybUZaQnYz?=
 =?utf-8?B?WGQraXJRRk5tMGJpQ0U5QWl0Z1dUYy9iN3Y5VUhnK0dsNVhvc3h1WitwelM1?=
 =?utf-8?B?bjdTbDd6blZqTHNaa05ReGFjM1pnZnV0M2gxYTRGczhUZTNoQldmcE5qNWFO?=
 =?utf-8?B?STZscjQvVGJnaFZxQ0dKeGRvcnU3SzRGcWZqSmxUbkh5SmxaVjU0UXJRdGVn?=
 =?utf-8?B?MC9ZQU1HVG85MkFOODl0OGpzeWZCQ2V2dmw4VFdNcjMzVksrNVpXaktkL2pR?=
 =?utf-8?B?RjU5ZHhUbk8wK2hva29mYmU2dHdidUZ1YzhwbHh0Q29PU2tDaHdJL1lHeWlQ?=
 =?utf-8?B?ZkMwNVJBR1VGMHZVZEJsYS9rcnVBekp2OUV1QXhlMlhnZktHU2YyUk9ob0U5?=
 =?utf-8?B?RGNweW4wclhaRkZYRW1XaDZtc09NeFI5N2lGcjJFRGNhd2Njd3RRTldmMXFh?=
 =?utf-8?B?RElIYkxUc1N1N3I2N0o0a0NlRThKZXYxeVZNU2hKUTNLMWYxcnRHL0FuMjlo?=
 =?utf-8?B?U0pwTm90byt6YjE5MXR3UTBacm9PVnkvdGF2SzVoN0c1L2tKWjMyYVNDVTdl?=
 =?utf-8?B?V1luVGRVYzZVNEEwaWxBTUNoVXo3WTNMdytqUWdVK0k5L2lvRXp3TGhtMHZR?=
 =?utf-8?B?MnZiVFA2S1ZiZWRIZmxzWldtQUhjbmxzZWV1b1ZuOHZvd0RnWXVMNnVISjRm?=
 =?utf-8?B?YVpSRXd1ZTJDSzE1aWpDM1RyNkdpMDN1bTZxS0tqd1UwZ3pwNml2K1JHczlG?=
 =?utf-8?B?Z1NWZm44dnUvdUY4cU5sRlRPcmpTYitBcWxFeGNFK0YwTkt2ZlB5MlV1VkVY?=
 =?utf-8?B?T0xmNUYwMG1rVVpOMHN0RzExcWFQakJwNFhmc0pJclpKVWNJcVppVnRUdzZB?=
 =?utf-8?B?VlNhbW5QZkFjZmo5TlNFYkFZV3JtYldNR2M0RUVrd3FQNXB0ZVlyVmJpMWFj?=
 =?utf-8?B?RzE0bHJRZ0UzSXNMcGpEaW9xVFVraUhXSjV4YnVweEtmZXhiSGFMVE9EK0lF?=
 =?utf-8?B?UFlodUZZWUVEcEMvMHFIOGNYd09XN011cjdNbXY5S2pZNEJiaEY3eVJVREFa?=
 =?utf-8?B?RGxEVFNaeG9pZDFKWEJFaERMU09xM1VpUEpLUUVJM3N4RUprVzlhSytNYTVO?=
 =?utf-8?B?alFSdGJuSzdrY3VFeVNoR2NobXU2djZlYVNhUkEvN1E5Z3BvQlZzRjJpZ3Jt?=
 =?utf-8?B?V0hDWTRya0RLb0VuSXlhTUUvUVNRN28rTVN1bXZHekFEb215Z2VwREZrUHBO?=
 =?utf-8?B?OEYxOWk1YmdQYWhDTG9WVkxHKzJvN2RDNlpEalM3SkFZaENYY0R1bkRqc3pa?=
 =?utf-8?B?MmZCTzRDVTJiSEtKcDRTSk1rVzBaa09tMEduSlhSMHZVMlEvZ1FpYnk4SHA0?=
 =?utf-8?B?U1p5cmNHY1BGdEFoaHhyYllIV1pEdkxPSFhvSWtHbzc0K1JIUDZwSTh5S0ww?=
 =?utf-8?B?Z0dmTm00MXdsQjJlaGw0TUNpL2hLejByQnJGUW9SeHBJSGpkZWtkc29mNEh4?=
 =?utf-8?Q?MLPeNBAagKNFGiiptWedLvt4b?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0XVYx8zmml67z24FQCPZ08348XnSeDtvxNXePl16gPdwUNqJDIqAoqlT7kSoXX8plrln55lwhVnCIz4Z0vJ3Y28YSEwK+tSU7OnQvoNCDNAT28ffuZC0TFiuWkNNa8Rq4jKr/j9gQdH3nPC9ZVYCEmTXqZSJk9+oFLSS8Pp5Z3vezG9HDZVnvBxC12I7QEPuIYTL4zsoW3XQxPmye3LBzjLRvPbsUEywRD5tZ1n30J7P0lQ1QFS44hEg32JLxp8xQqBaceMf9sphpcxfEmTtCPAu1vEvF8xA2kSzYXtLlSGmTXlspafI/fZn0L2CMaY6WvTy3pyUfRlM4PUvNy94bFlWFxGB1T1JmIBauf7u6yljgTXT8p6g/qxGnrjlzDc+nU4xFB2ii9psK08kAGYFtsYjQxpBPSMKP5AX/nDuHnN3Mz70Y/eU6T3hAPRohuMDIwzmjYln2IW3hH9ReQSNTYLQTs+oMLjal7eT7VKZ1NqUAUCwvBRr0JVGdmpEAsDHIfDsQilr2nsCVvER7gNV+92Nn/4QZWwU05ht7vJr8prTD9OaOA3Oy+R1LNx5mLyVbApoIlsetBeXQvT9TADMpscHfjjqinwRMwIui2CgSgE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88af5c4d-412f-4649-012a-08ddec4a897b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 07:05:04.3415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDeukJnN3YoQF78zE8uMaMNi+ZlIKYPfAXm1Vh5WdEusjDAq8RHuxIv6NTEC4Vhw5aVAvH2Ur3mIgQFtVALWMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509050068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDA2NyBTYWx0ZWRfXwBgQgipeuH5Z
 C9AcIdN3TZSCRMXoXkHeDqOegjTvaFvCV272STg/t+gJeRnpQMnL+WT0boYOoLnTuC4NLI4zjfJ
 Kyu+1fJoM4gbe4zXkgo3G0cybHcvD4LrFEpNbhuBknOq0XgLO48lBVx57SwREbJlYe2o6R4PzPj
 VEWtR3kS/y9qMF/eibq/Ggmt5suHtJt7Ip72itLnzhZsAgaEcSugN2ESSdFhuK3j3wtzhcDvOir
 Uf+79NYXD9suteaYQaZkNMJKsP+LwCoY1SGsSVqoVeuYdD2zFd/17oNYvcAfNJ+H/ZJngUvILkR
 6N+KwW6YUiiex9N9TNrdpYlmI1XW/+sD9IkXjfDNQnp+qhVJcwOrVbTOchbD8OFyex5bw5NZ5cI
 NGK7dQhJ
X-Authority-Analysis: v=2.4 cv=CYcI5Krl c=1 sm=1 tr=0 ts=68ba8ba4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=3AOUiuKR4zjeQEg06JwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: prVzXE1GchzzlM50OR-ReJ7ie-ZemVX5
X-Proofpoint-GUID: prVzXE1GchzzlM50OR-ReJ7ie-ZemVX5

On 04/09/2025 15:54, Gustavo A. R. Silva wrote:
> Remove unused field residual_count in a couple of structures,
> and with this, fix the following -Wflex-array-member-not-at-end
> warnings:
> 
> drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Personally I think that it would be better to comment-out the 
residual_count member, so that future developers can know about this 
field and why it is not there.

Anyway,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> Changes in v2:
>   - Remove unused field residual_count. (James)
> 
> v1:
>   - Link: https://urldefense.com/v3/__https://lore.kernel.org/linux-hardening/aLiMoNzLs1_bu4eJ@kspp/__;!!ACWV5N9M2RV99hQ!OLkXLNymYqQz8gxMAEHXcks7WQ22V0FhWPT1wD58j2Zoq0rgh_0zDnxZnBV0wK-FEGTDmnSbCMbqSVJGScIysEk$
> 
>   drivers/scsi/pm8001/pm8001_hwi.h | 3 ++-
>   drivers/scsi/pm8001/pm80xx_hwi.h | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> index fc2127dcb58d..170853dbf952 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -339,8 +339,9 @@ struct ssp_completion_resp {
>   	__le32	status;
>   	__le32	param;
>   	__le32	ssptag_rescv_rescpad;
> +
> +	/* Must be last --ends in a flexible-array member. */
>   	struct ssp_response_iu  ssp_resp_iu;
> -	__le32	residual_count;
>   } __attribute__((packed, aligned(4)));
>   
>   
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index eb8fd37b2066..b13d42701b1b 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -558,8 +558,9 @@ struct ssp_completion_resp {
>   	__le32	status;
>   	__le32	param;
>   	__le32	ssptag_rescv_rescpad;
> +
> +	/* Must be last --ends in a flexible-array member. */
>   	struct ssp_response_iu ssp_resp_iu;
> -	__le32	residual_count;
>   } __attribute__((packed, aligned(4)));
>   
>   #define SSP_RESCV_BIT	0x00010000

