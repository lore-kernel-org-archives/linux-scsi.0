Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700DB4A1A;
	Thu, 27 Feb 2025 07:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740642935; cv=fail; b=YnRaPsba1JSHQBsbP5AT39nNlUEHlJf4y70hazxqv4U55iuQW9GHfSrAtMiZnSKH7e5XO0AXtGFiBPH4qgwJMEX6QXHqoGVr0Wqu2A7WIJsZgZcyG19DRkhgO/Mry7toRrv08/BJ70nEqYNVvDC5UxBn13flQFfS3YOEbx1pU+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740642935; c=relaxed/simple;
	bh=5jwyQHh6TqP0umwFxRc9INJbvTZw1c5Oj2n1czhiVNs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rXPjOuTYvtE1pPekxqk3fba+qLDiE8bUxwGd6tfic6qaTTRPaTDX3N8LCzTtTjZ13njup8N9c/F4OrgQJlRVKIJzyKfxl5qEi0ZCdVUVnAnAeQ0BEkZgioxXF1K1+rssOlaD7ek93zZ9rGGnNQ9MzfnxEMHwETt/8BzD3J6+Pgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=opnoI4F0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Je/FKO1X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="opnoI4F0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Je/FKO1X"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51R6sWA9026726;
	Thu, 27 Feb 2025 07:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=YZuEQt0lbiQoQ/etMWLXD/r7Lb2yfQwpfcmxAV6fQr8=; b=
	opnoI4F03vqmdVilnpgYjjbW5uaDWKCIg9IHa0E/ok2u+uGzD66evhl/UdReaqjg
	6K/8aydn5+zeO7sDlfx663COdyAxfnPXQYIpR66QlLss0kxwXP5TqoeKJop5pRmD
	0A6veDDd0vDweJ0ivGIvYB3QTGe1BEvmE2eOuYazdMLE1/GVKnR9wNvelqYDaZ8g
	KLLMSaL1zeJMcCEg1o5METVhWwnzlwAVHoNnjRcgG3S9P1ROji1yk5agPZBTRvcE
	A1bpultu6yZO6sONdlQyX85mSK0UzjIW2oc66wneMvn7TOt5EqAhZ3BpWwfngZhp
	CO6be+4MhKrcC/4plPDVCw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451psf2s1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 07:55:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51R6Il8q007414;
	Thu, 27 Feb 2025 07:55:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51hukur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Feb 2025 07:55:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sP9u+viCBhTd6FiyL9bSiJOfJ+u6uMsqnafhZVYc9TgL5u6KP+XJvrLTk+WyDy/enQB2La/28LmiVU2P/eRK1qQV/W7crpRuctvfVqxhyIu/SiKgbs+XgK6+6swX2dUVHVuaDI5okO3kAeQSodCIQdQGCJSFonrAqojEU2mqCK+aHMJt/oZ+5vSTd/aN9GM3Ovep0H3n03KswffZFtRvNP9JHjuusESoEaULoKB8GbIFuprAZSiaymb9Y/bwX47ERNrDolU6d8vkgUXJxptUnFXhNyD/t9dUmJVLW4Wfn+EbiTAUbYKjKg/OtjCh/j2iWjyzjZt3nb452UETPim5kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZuEQt0lbiQoQ/etMWLXD/r7Lb2yfQwpfcmxAV6fQr8=;
 b=DDzjRkz7TmL21ARrpDFCEYO2SN+l1Bn+X4GR0KxURoGz+xoOnDkRLd8ZkMLGQAxbgEwc+yOFn8H2n05cNZQGhveTM+2KjuNT8cecul/NAxZ2nGsi9wRZmkuL+/csoDeQ0F7Yi726ajYZKIA/JqdLBWnAZD8xluMG6xAWIyYRSysn3jqI7S9dh7IKNzf07cC2pVbIEvOcVV25uuC2z76YoKhFqdNiHvDUA2LdJsrKWKj9pPCaD1LYB+Gj30zBKhYU+D/4b2JqJRuZAUaNLH8Dq/XLL0nhe3//nTWKgP6sZ3ZjwKxqwlwbqrHjhVgQFQwShnpPdFvf3a1XQ4Kpys/Omw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZuEQt0lbiQoQ/etMWLXD/r7Lb2yfQwpfcmxAV6fQr8=;
 b=Je/FKO1XDP1AAP5H1XLBW98Fx/jZj2w//R+9DR9mYgziZpEb8mYunpjNAD1s49PcLZmHVJ6ACX07foHGivUI8ADeR2nt6M9zwFCMqKwJa9UKThMqKXiZwhUnnCYxtiQ3aenATxDve4//frY9lT50jbyaAIIf1/i97u8FxD/yx4Q=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by SN7PR10MB6382.namprd10.prod.outlook.com (2603:10b6:806:26e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Thu, 27 Feb
 2025 07:55:10 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%5]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 07:55:10 +0000
Message-ID: <bd7a4016-d922-47a0-a912-1a2928b8298a@oracle.com>
Date: Thu, 27 Feb 2025 07:55:07 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: stop judging after finding a VPD page expected
 to be processed.
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
References: <20250227060618.15787-1-wdhh6@aliyun.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250227060618.15787-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0083.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::16) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|SN7PR10MB6382:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efd5ff7-5b66-4e11-484e-08dd57040ecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3F6MlBwRmtQYk5ReHpBNzgrcERkQnNvRG9rQXRZYzkyMnp4U0w2NDRseE9i?=
 =?utf-8?B?QkVsUkdiUDhnQmhiYTdSWW5sbnlYdGZyU3dwMUlpZnBvY054MjlZNjJrcGVl?=
 =?utf-8?B?Q1dsU0pSVVpZVUV0TDBuaGhucms2WHdyNmc5ZkJqWjVuampXQmFCakw2V0pr?=
 =?utf-8?B?andPdm11K2s2cEIzUnlNN1o3WmFKd3o3Wm1jQTdOZXpCamoybXNNMG9sNTls?=
 =?utf-8?B?Y2RYWUxZekVWaWpuci9oZ1dLNkhTVVVTb2hheXp0ckV5U1RSOExWUDE5Q0pw?=
 =?utf-8?B?a3J3K0dTZmY2NVU1T2s4U3VhYmdiVEVYT1RvR3FaeVRlWXJld1Z1NUJEM01W?=
 =?utf-8?B?T1ZNK1J1N1JxWnN6ODU2bHhHclQvcUcrQ2VoMEFOODRQZG5IcDBmYmF5QjJo?=
 =?utf-8?B?V1JiV1FoVVV4NmhrS3Vwb2UyU3IwVkNxUFBQbXkzOUZEZEd1SWlXVWF0Q1Nr?=
 =?utf-8?B?UnZ4K244Sjg3ZXJwK2pPaHltaS9RcGNNNHZpK1FsNktPM0RSUWU5Yk5VdDY5?=
 =?utf-8?B?QVBjamNCVlU2U0tUWlo1RytwY1NJS2JHZ1R6TkF3QnZwUjBpeXhmaEFobmQ2?=
 =?utf-8?B?WjNKcG83L2pFTnJaWjdQblVTM2tjRmRqRENKbjgyS0l4S041RHh3WXcrTHA3?=
 =?utf-8?B?STh0R1hQTjBrbmtjcURmenRQaXozK25neCtkOFNmUWt4TloyeXRtck10VDVW?=
 =?utf-8?B?NkhCRGZqSmc4TXoxS3N4Y1F3UFlhY2RzZ3hoc1Zha3VjNUYyVmdDRU1uN0xW?=
 =?utf-8?B?aWxwT25qV29rSHk0cjBEeUY1anBRZ0RobWk4UUIwMGFRSnIxYTY5VWxDNlF2?=
 =?utf-8?B?K0ZSbVIxdWJ0ai9EaGkybEtsSW5Ia3NHekJmMmJJRmxyQ0ViV0pMZms3VEpu?=
 =?utf-8?B?bko5alkxUUFtQjRxY0UvMlMxamlncm9lL29xR29uOWdZTVdTeVBHWW9ONkNO?=
 =?utf-8?B?dFYrNXN1dkphd3l3OUcwOWloZGxoaUhKalArVWFNNGhwWUlxSXdvN0dzck1h?=
 =?utf-8?B?Nk56cFlLZUdZTUhjU2VmdjdyNlVLOExGNFN4WXA5czU3REIrZXpkWHRsN2Ix?=
 =?utf-8?B?S1NnakVyR1BPR1ExN2tqNFFmZE10RkNMZWR1QWhXZWtuR0EvMmlCUHJUVDA1?=
 =?utf-8?B?akhIU010Qk5WektaYlZ0aGJmc0NjNHo1NDV5WXlFOWJadDYvOTlTendqZ2RE?=
 =?utf-8?B?NUZWcmRuSDc1L1pmUlNWSVpJNjhYMXBybllScXBIeUFsekY3Mlk5TUl4eDlq?=
 =?utf-8?B?Q3FnNmNGQWhBV1hXWk5SU3ppNERrdzlCVVFkdnZzSWREeTFNUllXUVNHN2N5?=
 =?utf-8?B?SE9acWpyZ3ZKWFVqbjVaQ1NIcjdqUkxGR2hDdzlybmhpQ0dMOFIxR2dkWHFz?=
 =?utf-8?B?Z3BQNXA4bnJaR21pN1pDdnJPVFJ1VEp4RW5HWWYxQTM1NU1ZanV4QklVMEQw?=
 =?utf-8?B?U0hHWnFoMWhXaWVFRUNqazlFS0hzVkVwcHBFRkttVFlvNEpmaE51RDZyNFQ5?=
 =?utf-8?B?WFoyVk5kY2dUNThtVkhlckVRVDhLWGZqcDdieWtZQ1lNU0Zid0tqbnVkSTZx?=
 =?utf-8?B?aDhUa3MxV1I2YjdCc1A0Q01nL0RKbFhjaHpoNU1zMTZsR3Q4a3FHWHVaUGtu?=
 =?utf-8?B?SXRuWERWNm1uRS9BNXIyVllzc21wYkdWTGNnNnh6UVFOS015M0xISGk0TTcw?=
 =?utf-8?B?RERXL0d4cm0zRjI5SXdwRVRVWkxDVGtheHcvWmNvWGw2WkY5aFI2MVNEV21D?=
 =?utf-8?B?bTVFVXdEcW40dTMxV0dEcjRxaUNKMG1nTFdyVFBXY3czL1JoZjZJRDVwNkFX?=
 =?utf-8?B?WWk1bjRyTkxVY0dhWjErVitrZWNWcHJkRForaitTUXlGTU1oWDlMWGxrSENQ?=
 =?utf-8?Q?4nh13T5eFTR9p?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bk9SMHVYTURNMGJaOXBNaklFU3V1bFB4YVliNHhqL1V0bnIxdVhFTVM5dE9E?=
 =?utf-8?B?KzI5NG90akgyY3luVHQ1ZzBXQTFTbjBwSGRkZmhoL0kwVDFCOUpRbmkwSzVP?=
 =?utf-8?B?emtZUFRsQkE2eUhUL21PVTlQRlhPcGg5VDBrMmE1WGhZaFpxTGR4K0VqVVZh?=
 =?utf-8?B?ZmgwQVY0aGZtSXVMWjVESFhUVlpNSUM1M2VjajhpTmoza3licHRrREpsMWpN?=
 =?utf-8?B?c2VGdWp0bTE5TDhNbDU1dTREWmhOWDh0MTJZZGJueGdUTDJ4aVdNUGhCa08r?=
 =?utf-8?B?MksySkJ2bHU0R2NuaTRaOTF2cWtzdWZvbEJEQVQ3UDVaZTVGN2xpc0ZFcnZC?=
 =?utf-8?B?bE9UV00xWktQd2V5aXU2STZYcGx5K0pxMmJ3VWVzNm5jY1l6c0llZ2FCelJF?=
 =?utf-8?B?UlBES1pFbHFVRFg2TXloMXd2NHZ5cUQxWHJ1UXB6RFQ0U1VRTEhRV1VvN3NJ?=
 =?utf-8?B?VDhPNUZnYUMrN2l0eTVVbnVvRFhiYVFwTnhjV1BKc2tudUZJQldBTTNMM0NP?=
 =?utf-8?B?bC80dG9qMzkzQThYMEoxOGx3NHowNklsZFdqemhtV3R6NFpuZDFVSjZ5bjc1?=
 =?utf-8?B?S2xjaTFLRUNzMDBVTXVoM3RlSVNMcFFHVGR4Yk0reE9tTHpYQ2RaZFU0NG5p?=
 =?utf-8?B?c01ZWS9zemxORWdVUHFUalllYmwrZVVNZVkvS2xPY3BIbVU0QnRNakloUFE3?=
 =?utf-8?B?UFZlSGdQVW80UElTWThpWWU3QlZ0S2dzc3N0cUJjQWsvbGFUTHFIK21hNTIv?=
 =?utf-8?B?dFZvcENNRE4vRnBvMTlUUlZJbUd0Tkp3UWNMU3VJQTRrb1c5VVg1LzFzYWt4?=
 =?utf-8?B?OUhzTUZNOVNVbnhCaTNmVWtkUjQvd0JhVFIvV0pwazJSRlFaVG5tUVpqM2xD?=
 =?utf-8?B?dlB5VnlwM1kybXJPb0ZlVVh4dndYK3o4a3BSbmd3c1NKWHhIb1JEUXgzOENP?=
 =?utf-8?B?VnZiVkthUVpOKzVWbGNXR2hOczdmRnVYcU12akxJNGJONzFoNWFUbXNud0dC?=
 =?utf-8?B?SkRWQU1DbmdFa1RxQlBoMkd2K0pwV3dQbHllVDFvRGtNanZ6N3BYK1hMR1lO?=
 =?utf-8?B?ZWRGbzVSM1A5UUptYkdrclVkWXlPWFB3eWV0bGJZUlBMYXlTWTc5b0g5MFJS?=
 =?utf-8?B?b3ZRZi9QTXdXQmYrSmZ1c0ZOTVZsb0ZvTHZVVDUrOEdKWTFYQ2xkUitjMDEy?=
 =?utf-8?B?UWpNd2E3b1cyNGp6bGo4bko2YnVTYnFVMDFoK3hkN01XMUl2ZkZ6RjNUOVVT?=
 =?utf-8?B?SW1qdVFtRXp2aXZPQUw4TWVFNit3MlV1ekNSQ0JtQzZsdU1sc2hsS1ExT3g0?=
 =?utf-8?B?MS9GVWNpeGJlQllkeGp2SDBEcncrL3lrRkpPOEdaTTlhZU1oNEs4NExYUHk3?=
 =?utf-8?B?dlptdW9ZTHhoRHVMcTBxUTltYk40NWpkc0hkSFVocVhUTTZ2TTNEMWoxOHA0?=
 =?utf-8?B?VTAyNzgwd3doTVBNMTJHNWR0QzdSTkF1SFJJRmFFdTJlN3YvVGhuRWVyVXIz?=
 =?utf-8?B?TlBBNStaeHFFVEUyMjF3Uzl5OGwzWkluajM2TVNVRi9kYkt1RE1aOWNaV0ZF?=
 =?utf-8?B?T0JMb1VHUXlDL29iSk0wbmNtSG5nendpQi9VSnpHTVZmakRNcEIxYjFTdjRo?=
 =?utf-8?B?YWd3bFYxbVJMWFM2ZkZORHdWOHBqeDgweUFIdEs1VjJuOUM5VURkMU5iVDI5?=
 =?utf-8?B?aERhTlRUU08rNkkyZnBDcTNjdjU5SThwdDRUVXVwb0lpVWI2aTFRb25HaWNJ?=
 =?utf-8?B?eUlmWFdVZHk1L1h3eDRXL0M3UEthR3ZpOEoyVkxzNit3Tm1UQUpRZkRkNVZD?=
 =?utf-8?B?R21LeGhuM3lERHkwbWlYNS83ckg0TWx1aVlKRFpPS0NaZFY0ZnZyVjd0U0E0?=
 =?utf-8?B?aDNMWXFqV3Y4YldPNVNic2NuWGNJQk1VQlVtc1Jrd1RONDc0WUozYk9SUUJG?=
 =?utf-8?B?bzdYR1QyOXBhMGdmdSt3USsvTmRReDhPcWVaTUxObG53UDVxOTlscUhsQnQy?=
 =?utf-8?B?WTJxT2ZFVVluRFB1QytEY2FoVXl6THIwbnFNTno2bWJnTmtsNWhRTnl2SlZX?=
 =?utf-8?B?b25rUUkrY3o0YW4wenBBZVpiejdsci9iRE81c3pLK1RXM2MrMzBMdlFrQjlG?=
 =?utf-8?Q?9SeqxUTtU1BsbH+l6iv+ys6ME?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XVuz6OJqj0kVOd8vY+Wapbx8O8WoB9ZFF1GwggKjve+k8oVMCH818n8bJELNclBbOVEabdHehHlpbGlJHZ3oDnWUeLS7cs2qfV2Q7HISTrMLoQ3IoYRY3etw+C8kweLJsRUt/MxjE6zcY0Tp0Lam1Gjby8nhT7IB5nDBCm6in+OEjpVjRb2DAzTAfisCcC8HN5oyLeM9EW8IXyetWiDytid2FtASKKPvWKF5NhX3mMOJOAzsX1dH5TZsRuHZfBz8HtVm/u8khsoTIeqixa8VWv1oz2p2IGow/6Nzr8qXwHCCtOduGLl6BmqJ5B2qLyI1U1s6vSVX7aqK2dSaQV9uda9BRnW9OBoIKuuQpvSG4tpcxXkv5PKhPXIy0+d7H7HgrN1unWVSR+18/01LdXyBvSOxqsBZRI+39nwpiIYY6vt8qeE1KXpkt9aW+vDvDJjJlt9nfAgOINCNX9deicqBCgI1gM6Fvsn49ubPbsSd9EQBIhCB83SlMjEX6xHJkw63wpkwZ7aqnWDZnpVWgi01klaXY1II5jw4Eb6vDHvJ/QHYX14npVgJH8TymknDd4vSyCxjb5mzzO2Qa2Ea4rcH7fxBXnbrqW3bNsFgyu3SN0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efd5ff7-5b66-4e11-484e-08dd57040ecb
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 07:55:09.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yac74BINmCB9ebF7YQPJh7nqhwbqhOCrRaOUxU5fCcCRss7CU+bauqdFn09SlBnrpLr48x3mNit3b30wrAQRvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6382
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_03,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502270059
X-Proofpoint-ORIG-GUID: 4f_LXJfZJQXF8H0XKJkw0MLzfTbonGZU
X-Proofpoint-GUID: 4f_LXJfZJQXF8H0XKJkw0MLzfTbonGZU

On 27/02/2025 06:06, Chaohai Chen wrote:
> +#define SCSI_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) - sizeof(char))
> +
> +#define VPD_PAGE_INFO(vpd_page)							\
> +	{ 0x##vpd_page, offsetof(struct scsi_device, vpd_pg##vpd_page) + \
> +		SCSI_BUILD_BUG_ON(!__same_type(&((struct scsi_device *)NULL)->vpd_pg##vpd_page, \
> +				struct scsi_vpd __rcu **))} \
> +
>   #define	to_scsi_device(d)	\

That's unreadable....
