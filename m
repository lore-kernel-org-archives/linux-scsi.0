Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4FB47F2F7;
	Wed, 29 Jul 2026 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785335151; cv=fail; b=YTk+1CsQt2uAMab9crrgDk7O3w86rRDzVpvCLJ7MYFsFWYRJO2TUozalwmtzBx6nP8Av9IcIeHtvxXXI9slug4ZxxbWxobrcqjFIXSQfbeMbiVuO8NnC+QHbFd2hzzhPK9Ni/q+5Chto24JP2ta4peNoS8i54RyBt0nGgHYDn1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785335151; c=relaxed/simple;
	bh=9iVSHy729N25+Gcz5QEPzNtnJ4QjVPRsq1C7EjtSXaE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GfOJwG35AIpvxgLU3/Ir68v3IurIhgcOLUjNmxX5GOUIig5tHzpaGEypOmfaA2muwKfWsoYhkNcHmAfdDgBkVyFUdYf4JMNXqvojOVSIVm0ZTbP5NGsVpG+ZfajQHzwExxFvHGHS1SzBss8RxHSw/s6ntdpJqxmX7KUNDefUJMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bY9MVwd3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AMoYyOpk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bY9MVwd3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AMoYyOpk"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTKF93035331;
	Wed, 29 Jul 2026 14:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TobZKZFgsAltKWBlO9kQqc3B+ywEgUUGlpHSyXv/Xas=; b=
	bY9MVwd3F5hdCHw++D3Lxrp68Rjt0Jb2MLXT11/QLOEhsy7xmMYIeSQC0tJT+vsP
	Pq3ELg5k7QnGAeoqRy2IY6flr62c7uZ5pjML+PC+iNFo4W/y0vVoxgWR0WU2QPzv
	NCA7e9jAI8wf40aHqlI/RRrYVxlXH92gXcGKy551AB8GSpj3KwvAr31KTW3BDycj
	8wZeDeOkuYvRZYf8STTaApphC6CKXGtI2tcbt9ktILTsOFVIBp0yN90hfn+HXgAE
	LHSLvAUoqC7AxKZEyKzANXvpZI7WiRA0AdGjB5ZmGdNwF49F4GT5txNj90WFz2Hu
	k6GNpCaTsLFpidsu+9IN3Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5np0my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 14:25:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TEKUpJ012551;
	Wed, 29 Jul 2026 14:25:47 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhem055w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 14:25:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odGTk4lExl7qaSnh/pWi8nJ0WxKRbwb9I2b0Fy0+QDCquYsmVRdkmBcgnPlL5SMl2QSKrNAPc/w9rMHKe6EeaQUw1vtHZEs6IgOpdifOQJpvLWAScaRC7oz+84lA0PhWvVvBCIRWh+NdwYq7LGslkdlGFIyFCxpQO8vt3SWisZTD/wXlEWL8stBusEH1g4KZ8Llvy4qNQ9beh63MqHJcEm6orEiSDWIsSCOndreGpyMs+Zy8NJ72JKlFVLj4oSSIyiINnaKAGR88MhoQI3RTY/eS6ODnJKgwVwBCkwQUAFCLDLY+RuXTexUyry2DCH85dCuJMZVo7z6XObiD4ukAxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TobZKZFgsAltKWBlO9kQqc3B+ywEgUUGlpHSyXv/Xas=;
 b=zG53A6CPpbEJCFyfvjco0mOoAimI5gXBdQ/uyZqpfOF6nRe5iR6fQq5uKV0r09ZW4iHjbUZJNRLcxuEUxMgl71oe3D2cnmVN3rhnU1UjpSdE2Cey8/Vw84EnJTmVSAS7nGlNb66CtrzQg6SfqDwHK57nTtjwKVYRYoaRNrV19vpCrYd/ELmBwnT8bAhXqRyn/EsIPnPDGlJGKwv/5Ql3u0ThzOVOgWnQyolA7eFK6MI+YrpH+0WMI0GwcvXI2b5cdwXtDgWw6oZaqpP/Gsc6RPTw2OGhty9iLi0jXxvKHx7icFGKe8nWtQtbD9rrIR6CVBn8o8aahy3hGuNrncftig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TobZKZFgsAltKWBlO9kQqc3B+ywEgUUGlpHSyXv/Xas=;
 b=AMoYyOpk21tigq3z0cJ7gwT68P+djOy3u7y8aFbWAQaWgMca1xj4FhJazItWQro/h6YR4etEFjPKRahguJ1MqZuKkxOO0mlRiH9jh1IUQSqLJV0sZkzI42entSnpH3NHePI6xxurZhjL0l+noiP4qKSRi7H/FfZRK7hORFpDtkA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS0PR10MB7522.namprd10.prod.outlook.com (2603:10b6:8:15e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 14:25:41 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 14:25:41 +0000
Message-ID: <4d8144e3-7686-47f2-a19e-60b910d81bb9@oracle.com>
Date: Wed, 29 Jul 2026 15:25:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/27] scsi-multipath: clone each bio
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-16-john.g.garry@oracle.com>
 <20260729142321.5ADAB1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729142321.5ADAB1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0044.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS0PR10MB7522:EE_
X-MS-Office365-Filtering-Correlation-Id: 602e07a1-cd69-4a25-d601-08deed7d44c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|6133799003|22082099003|18002099003|5023799004|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	G2/ZrZGssnfeR8kC5iXlHm5Ioenld51yftUvDc1YONF78728GdPg4d3RXn4AYzwPIffJ76VK7DgbJH8tbwC/VfroxsGQBS1j4tjCQaS0J2MKrq4heSDtzqVryQ3FIGybzR/8egjUOw7icBb/biUnLTnMQ6+ASCQPWnhbIx+olN5uuod78DicOZ+ChTWVFOjSzv8IrNCuatAR1Nc5ASZ1n79xbCJCK4Dlx31Feag7+R1OWjCMRYn2agSdR9Hh2YL44C8boLGMbzuy8+iWY8/8CxmyxBFpA42qyNubQ2Eji7q3wGpWEjvKWUWnubP58hkat8+0HIy4Lr52V/KViqRZAUKsZ+AbyXSo2ab7qn7/pcmiNCKHYpH95e4FUx+UidUUNFMfMirl7nY8flar8mr7IKKP8MtSoYRXYeZebGA/zOTYZRfXjsjWJixY/kGJEB/KTDlBT4HRwf2WBw2Mbd7PAdtW8sKJzwJhZqqo8QeBI29hNdFCTQQ54BiFzb+m/q5jrU6n7BxX6VoDNjl/S/La6GeeW3eoy/5z8PEnNkxwI8+fsafvqj6euwC+MhS2n5WYITvxHnvxUAjT6RfC9yG1zO/mhs5JuIl8Awnj2VRL9h1nrm+tPfUsutCnQnD6/hy2Cn/Eec2Y5BVX1tihbHB7L3JLACfHmOdevGaI2aRJ8j4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(5023799004)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHdHSk82WjhYWDByZmVNM3ExZ3FMZ1g1U0ZBVWlKU2c4ODJ4MUloZ1FoT1ZC?=
 =?utf-8?B?TkI2YU1LeTlvQnIxY3YwWUVzNUV1YXBNQVgvTk1ibjR6QkFvaW1mNm9WOXV5?=
 =?utf-8?B?Vm9xUkFrTzZtS21rWCs1ajgxZEFzenZBMHN5L0hteXhkeTJpVEF0bU1YQ0Vk?=
 =?utf-8?B?WlVuVXdUZUluV2VGRWNUeElvQzdwK0M5R0hHNmtFdkYrMXZ6U1V2LysxemNF?=
 =?utf-8?B?RUVYVGNPS2w0YW5CcjRUNjVXU3pBb0hIZktwbnprYWwzWUVIOC9veUF6eHdu?=
 =?utf-8?B?S3dvVXdEczNLZGtpSFRoN1hYRnVZUE10cSs0bXVsRDdvOE9HWkoyejRpK3l5?=
 =?utf-8?B?UUIyZ0xaZ2J4VWxzVUxhTVZaNzFzL2s3Slh1MUQ2RHF6cFY1UWRoOTFUNXpr?=
 =?utf-8?B?eDRVTHlWRDRDN0wvT1crQ2twVFdUazQ0T2VrZTUrejR1WEtrU25SVkRwdHUw?=
 =?utf-8?B?VEdmcmloZFQxdVpsdkhwWE1VSUlPQ05XZ2RBL0g5MW5IZlB5RDVqcDV4ajBP?=
 =?utf-8?B?QnZmK3hUMnZRWERFOVBBQUhvcGw0UkdxcnNkY2EvM0UycExpYmlaclkxSGto?=
 =?utf-8?B?a2lvT0YwN21OdEY4cEpSSy9ZZDRrQ0NYYzI0L2Q0ZWZYWldlOHFpdGF5Y0Nx?=
 =?utf-8?B?RGVhV3pIcjNSdHJSeDUvMVFpbExONlhqNXd4SE5oSzIvd3l3NDVhbnJJa05v?=
 =?utf-8?B?RWdIR29sOFZSZ2E0Z3B2elhsSEphTjMydWVlZnpjR1kvSW0yVG81N0xhWFV3?=
 =?utf-8?B?dkFIQ01DUXd4ZjBwWC85NFdya3AyYmtZMGhXM0hvMHl4a0hJSWIya2I2blE4?=
 =?utf-8?B?dnVsTVlRdG5JTXlFaXFaeUNOaERyV1lwNWVSbHQxbzNFUXZjdDZLVTl6anh6?=
 =?utf-8?B?Snc1TUxuNGYvZk5KSkxJL1o0cDVYTk85VnJhY1NrWHc3ZmFSbGJLWFliWUY5?=
 =?utf-8?B?eldvbXJ6eDlLTnpRUC9Na3ovODJsZHFZYmFtVWxWWkRoK1RieXJZem8yWUhm?=
 =?utf-8?B?alJ5czBXTUVWUE54bGIvM2s2ajZZZ1B1T3MvOFdoY1ZHOGFzeVZ5RjJMT05G?=
 =?utf-8?B?OXpCWGRrazFHaEUyNlRxSCtmVUdTeVBKSUtyWFI2dWRZZTlIY2FObkpvaFZU?=
 =?utf-8?B?MjNCQ1NVRFR6Skt2Ty9xeTJwMmM3bGdQY3ZlRjJ6VWFDdmZKbjRNUm92cE11?=
 =?utf-8?B?VmdVdGFXMkhlOTE5TlpUbmVQMzViRmQwTnBmLzFub1VOb0ZzeFlSWVJNWWNS?=
 =?utf-8?B?MEFRTjY1L01XMzh0anY3cEFyVERJWjd5Tzl2NXBFM1YyUTY5Nlk2TGlPTVpP?=
 =?utf-8?B?RG5TdGJWWEFPbk5WM3N4U2hlV1dZMTN4RzdZeTdrRDVVSDV2Tzc3em90NlNY?=
 =?utf-8?B?bE9TZThyTndsYi80Um1yZDhBN1lvdjlxcFBTVmtQL1VCcnBXalhhR3pBZGtX?=
 =?utf-8?B?dWFNTUp1cTBjQllCallDTTlHOWpqYzk4Q0VCRkZRRklrNm9TTFBlczBDSTY3?=
 =?utf-8?B?bXhYZmpVUEpDVnZMdWRVa2IyUDNZeWcwNlljUWtPWWtFZ2pjZEs4RGd4amx1?=
 =?utf-8?B?UXU0dWl4VDFna0g3ZVpTNGRMVnVtbEl0TmhxejJIendxTEdER04xVTllT20w?=
 =?utf-8?B?SFIyeG1WSms1Zng3YnVvL1ZFUmpzamJBQm91anFYMVZ3UUJ2VEdObUxRaUVW?=
 =?utf-8?B?Y0NGS3RpUml1eEtNa3NaNFpXNHNOZkxENW9mWmxOMHpPZCtiaDYyeWYzMHdE?=
 =?utf-8?B?eDNoRVpKbC9Nb3hUdDZaTEhLdlh2K3JieGc1MVRoQ0tUd0JYU0NiTDlEQlgz?=
 =?utf-8?B?WXB3OGkrUHFBQ0NFdytYU1ZVNGpNYXdQZWtXQlpRQzlMakNYbWcycytORFdq?=
 =?utf-8?B?N0tFTnRydFRxNkN5cTBqb2ovL3pOem1YZEFaKzNpZ0ttZi96Y3FTdkd2YWg1?=
 =?utf-8?B?S3pVYkFvL1NBRVZEbFhHM1RaNnU1VytmUmZPMS9vNUhXUGh5UE95TFRNM2Zn?=
 =?utf-8?B?RmYrWWFyMTE4Q0xTQ2t5OFlOMUYxbkNpSnM1Y09sVmFHcjJoS0UyK2djdkJG?=
 =?utf-8?B?dFIvaUJXRmd3ZXExb0kwNTFDMzVSTlZtazhTc25QUW1hZ09ZOUNxNUg0NWpC?=
 =?utf-8?B?WENwYzJrbWQ4UGZLcUFWS0JzN0FMVVR0MXRsamJVdTJsYTMrZEpQRk92MlIv?=
 =?utf-8?B?NWpsUUpxam9zMWZLNW84ZCt4S0RlbkNEc2FtMmhYSVAzQWpQMldoT1FlSFIw?=
 =?utf-8?B?ZFNRam0zcFRBRktBbkp3SXd5MTFJRzFWS3NVckFKYzlVZkllbjFZemJ3d2FW?=
 =?utf-8?B?dlhxRHdMa2JLVWFiREI4NklTaExNeDNqTmg2amVYdDNIS3NqOXhWdWwyK05J?=
 =?utf-8?Q?GO6q6akgB4KC8KhM=3D?=
X-Exchange-RoutingPolicyChecked:
	DCSCsL/X66We1COv9qBXTXxa+Qd6iU47ocodH+iLXoPBcRlILtiCK7ujXgBI4Pi+3AuS3qgc498X/som3meAo/QKNwoqRc8NLeGoCRdPlGo2ywu6EqDuI22x7RVBJlXyl1xdPCiLPdzMnWdHsV8dr30Yp4scI+7q8T72k6kGGGXnMmMPIQ6fHRDbiSiz2CPJ//b1OTzB9HlM75TFchd+tLnrWomRRqKKJCw0gqgNQlH8BQLQqZ8dVDp4gHt3l4qOkFx1PM9ZfldikJHfuYezSt9cLkiTD766ACssPMemsixxXUN/PhRuzRP4ESTnxTxeqUtOv8batJUbCLelVypkhA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zhImwJAxG60VZrLK84S0QiTSrE4mfZzRrRF3OkwgOrjEGYfQavaN1LxuVG/FKJr/2YsWN4JZcBBK9yHYiQzZhFxe4E35fUAzEXQhZgl2mkjncvgqhN8lG/F1twJzqR4xKknEDfGNpJ9CI99rKh3gt8SnXeIhKAJic84KrJLdp1nbIMaxAbB7rq7Z2HJrkD9ulnjmt/+oo0LiLAbcr9n0KVTSwez1oX0lCJWWrODZyaSUJIYc0+pkJmgpRrOO0npXNTbtXdYhbBcqfQMFTrWgGKbaJh9i/PNwrF26s+X7DMt1dGyylFzizXCw20jMnbGJDomi8Qsk02GY00Wyn+PO5l1lYFq5uha88P4+i2UOybBRcMV0r/4Kvebfa5+2tMfSv63lsxhGQ9Kc+x+cRLFT0hONGtFtsF9JI4QjuKIOxKRCVRYVH1O+/We/D53+Sep9knASWuc/pJ2imVHBuN1K4Duxr06qQo505P+bmm7Kv8YFXYmEnuKaIdN6MhlH3TvU5xlRg1ctGfEGy5Qv1JOk42UOSROJSjZR5BEjnoUhmFO9/nulANjwM5J0Av6CIBR5F8+hCvGk1/mQhPKWtzVR/kzf/HMOyLNS2xXOyneirQA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 602e07a1-cd69-4a25-d601-08deed7d44c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 14:25:41.5583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5J1LOWcjhSLwrOjfY8MH5oT4HxOH01IP88PDSPfu5iEfFkWDqPT+Y5yqkKsLmN2RMUYvR4snVmSMAx0AAwwww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290117
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a6a0d6c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=BiRJoDMCrcOmvMzpfPAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _lDxKj31fYTVaZ0YpFXmMW2j2XQsG8uM
X-Proofpoint-GUID: _lDxKj31fYTVaZ0YpFXmMW2j2XQsG8uM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDExNyBTYWx0ZWRfXyiopRCUpRXob
 BdBh00wMVgs8vjvo14+zN3+xvE7g5yS28RsgWRV53JMfhSLMMzjmuCuQRwYzhxy3thOKohVxEoW
 fZUjjmqo0CpgjTFTPL1qIRvc4LoQcHQVWKDIS0DIfIBCrXdkrC9l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDExNyBTYWx0ZWRfX7FUbtdnUcbzc
 SDOJD9belPUCI+qQIOUtLhMbqF+QXwzc5MVEcLzoBwPTIp8/m0K4xkjlfxizk5zIhOuDcY50He6
 1lAAJw9hgTZsHSRxHpFRRYdtx0SWS4MM+/pbsBWMc+tJUIxOktGDcV78/DF0Pf7CXKr7rEYFhm1
 TrPXi2O6f3vnYVM4Yw0DN6gU55iuQnRzg/OpG02sfvbVMMQLwKl5bl5ewd7DwA7h33jpxNGzO+d
 SYmPVAHWR0mppQUhLm9UCJifaWOrg8SOw83NlARZsm0hBBAuOLQagIas5XlfiOyeFCSEOuWpv7/
 1LMtlwl25JLdyYLFtcQ2buz03Z0F5ihr61do7PBqix7Re6AuF07qRIaqr7U/a5aTiIkw8M7tj9e
 pJvhQ1Th0kfCk7aOwDu4+O5dvhk2d+la8UEG8EUm4c4qGzhtAC2B3p4K42PtjAbOvgCCWkmg4j9
 iZM4P3pD/m/lkrOZfBw==

On 29/07/2026 15:23, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] The `smpdt` structure fails to implement mandatory `mpath_head_template` callbacks, leading to a NULL pointer dereference.
> - [High] The clone completion callback entirely lacks the failover resubmission logic claimed in the commit message, breaking failover handling.
> - [High] The `bio_pool` mempool is destroyed before waiting for active users to drain, leading to a use-after-free when in-flight cloned bios complete.
> --
> 
> --- Patch [15]: [PATCH v6 15/27] scsi-multipath: clone each bio ---
> commit ea53159f3e5b8959582afd4b035267bb7a201a6d
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clone each bio
> 
> For failover handling, we will take the approach to resubmit each
> bio.
> 
> However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
> is either all or none completed.
> 
> As such, for SCSI, for failover handling we will take the approach to
> just re-submit the original bio. For this, clone and submit each bio.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 593f94aac70e9..0d439cac6447a 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -99,6 +99,7 @@ static void scsi_mpath_head_release(struct device *dev)
>>   		container_of(dev, struct scsi_mpath_head, dev);
>>   	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>>   
>> +	bioset_exit(&scsi_mpath_head->bio_pool);
>>   	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
>>   	ida_destroy(&scsi_mpath_head->ida);
>>   	mpath_head_uninit(mpath_head);
> 
> [Severity: High]
> Does this code destroy the mempool before all users have drained?

Yes, all bios should be finished at this stage

> 
> When the last SCSI path is removed, scsi_mpath_head_release() calls
> bioset_exit() immediately. It then calls mpath_head_uninit(), which
> synchronously waits for all users to release their references.
> 
> If there are in-flight cloned bios completing, or if the block device is
> still open and receives new I/O while waiting, they could access the
> already-freed bio_pool via bio_put() or bio_alloc_clone().
> 
> Can this result in a use-after-free on the destroyed mempool?
> 
> [ ... ]
> 
>> @@ -237,7 +238,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static void scsi_mpath_clone_end_io(struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	master_bio->bi_status = clone->bi_status;
>> +	bio_put(clone);
>> +	bio_endio(master_bio);
>> +}
> 
> [Severity: High]
> Does this callback omit the failover resubmission logic mentioned in the
> commit message?
> 
> When an underlying SCSI path fails an I/O, this function unconditionally
> copies the error to master_bio and calls bio_endio().
> 
> Since the commit message states the approach is to re-submit the original
> bio for failover handling, shouldn't there be code here to intercept the
> error and requeue it, rather than immediately returning the error to the
> issuer?
> 

this is done in a later patch

> [ ... ]
> 
>>   static struct mpath_head_template smpdt = {
>> +	.clone_bio = scsi_mpath_clone_bio,
>>   };
> 
> [Severity: High]
> Is this struct missing mandatory mpath_head_template callbacks?
> 
> Any I/O submission to the multipath block device invokes mpath_find_path(),
> which unconditionally calls mpath_head->mpdt->is_disabled(mpath_device).
> 
> Because smpdt only initializes .clone_bio, functions like is_disabled,
> is_optimized, and available_path will be NULL.
> 
> Will this cause an immediate kernel panic due to a NULL pointer dereference
> when an I/O is issued?
> 

they are added later
