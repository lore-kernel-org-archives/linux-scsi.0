Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C8141E6A5;
	Thu, 16 Jul 2026 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784205812; cv=fail; b=f7e1r3rFx8NlJmnHw0tVud/UMNL4sXpUG5bMi2gOT6+31Vs4jVx7FC68iiTiKfG0J1VdeyZ3LMfuV6mgT9xg1cewkVPB/XIoI0hmTf9fJwPB0Zhq+HbHXGpEBoctVv6byCTcE33+PxICB5JnlKPZjziTsVWNBGMqYXCLee4uSE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784205812; c=relaxed/simple;
	bh=2i4gpw89CVVxP/7Dy5BWjZkHqvjt8TnExTXeqd1Bhc0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YjwX1EuSuA7r3QgpITZN+4SxF+BSSErt//v2aeWzOJ5da+77VjBBpWuk/5m0FpbZZucQ/4kUWyeNrm+3Lee9ECoig5rZisJoPlqSgsj71QBRdKcoH1uPv/Shmv0TL9YMzS86fAYX2CmfH9OfKCONIuHJua0oefFuX3Oy0aj6glM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Goelvpk/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PITdcW2K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Goelvpk/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PITdcW2K"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G9TYUx3106441;
	Thu, 16 Jul 2026 12:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=itBysE+asgJyligtnSOrO6ryYUTWPh8i9DLnk7FJOKg=; b=
	Goelvpk/NGtJjQWtr30VczJCe8zF39RihTRFPeKSER/YTilzUsEm7viczI8J7BjT
	55ENs71eyaehpAbWSx+a9am7dv7dIS4lzZ9Ux64G85nIDiINa3/OGKAu3A6QXOCx
	Fj4mXiwMnkahNIkjr0/DOWyiDRjbMPgiw/yK5kKlnYkpfw1rein4AOezutzWOVXK
	1GC2xW3m7w/xangASl1a92fzKQ2jzx56ozxlMq6eV64p1QYS1iZ7R7WIbFY87lRi
	DfJck3BokStUijbkyzEekwbFfRsUVS1b0H8TXiiI/s2QJUD7oPtPZ4UG0DZhSJZS
	um4VqBefk3V3D/VyC8ihaA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedrkj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2026 12:43:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66GChDUj028224;
	Thu, 16 Jul 2026 12:43:13 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012022.outbound.protection.outlook.com [52.101.53.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9g978d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2026 12:43:12 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dn99PqsHfHgMqwu2YQyDxDPwizAlIR/VTXRJ/BfIPtIPGaa7XFNmdkpvMpae2KvinpacFP//HeF+3Oi5NG6cvrQ6Op5o+4qxeCvJCNQmprR3NrXNtpN7k8N1uhu79O2o2CMdbMJA4IsDjMFGw7XuRgenEkgN71Z8YPoGLUKDQ/y92L6Y79VsuiSMRPY/TIKXXfpnZyfCHFa4nu8D38ZYTDYCV1zWgwuotAJDShVIJRZ6NdRnUugPL0RNy4kJyiBb+lOo2/dDHZbP48qZNFW6jhyn+TI3SsOJALUKGn9TV0Q+jQh8Eh0uw41SW4juTtlk1cnvBI7dswKnxzjDSSSUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itBysE+asgJyligtnSOrO6ryYUTWPh8i9DLnk7FJOKg=;
 b=O86ZeOp1q3YAouNwvmpeZhDTCNlgxLmAkiLQOqWJ0Y8dx3GV/Cm6uUwmegqjqPn0qJzasC4GcHWQzgVeMrJ2ZTY6K/fhqi9k+e5hH9XghUZJSGBl0b+PpswOKYGahDQviv3uKx2Mx6HjWpxOB4zcIDSm3CFDmppeiavB6qVNk6pBnRGaELFSI2e9SBJ7DE0bwbRvRlb44tZr7Lj6VCW2mKSvb3+kDbeNwonjBxTng8cQwArvbRZ09uE5/4S4PwMGepb/T/rnP1u0Xo0YhAqsx1RMXZJOGp3OWxQBvctFifm/1lx8QUyqcoTWkA6C+lfF2gwWv6doV6d0HBzm6GCHQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itBysE+asgJyligtnSOrO6ryYUTWPh8i9DLnk7FJOKg=;
 b=PITdcW2KDWfB7Y146Kjf3wj0z7zZSt31o9QKPwFxBIkEXQ1DfEr1qd7eBBF+Q6k/UMLKDcTRuj/WU75bYIAdqKUymr2feCB308qXhwIpgDOYv7CO2j02oKN16sMQdaUbBbn0u79iLCXHbooSYl0NWf7Dx657a6hc+SzLVA5fHhA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN6PR10MB8070.namprd10.prod.outlook.com (2603:10b6:208:4fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 12:42:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Thu, 16 Jul 2026
 12:42:27 +0000
Message-ID: <39bca767-5d89-4b90-85df-7d7f0636b095@oracle.com>
Date: Thu, 16 Jul 2026 13:42:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        dlemoal@kernel.org
References: <20260716081145.3950172-1-yangxingui@huawei.com>
 <160b8fcb-6020-4a97-a23c-3515bfa39e43@oracle.com>
 <1c228b61-4aa5-bbec-2590-ed15d81e45e5@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1c228b61-4aa5-bbec-2590-ed15d81e45e5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0033.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f3::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN6PR10MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: bffc9189-881d-4a4d-e6a4-08dee337b126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GPAwevUnOwmRSxGsPVgxyqj8Ptb53nuviaZEXYcAgEDaHnmipNURsZHMmJQWwHZ26G1ZoqND30P7X5l97F6ZcXGoX1ZzkiPDVRWaFI6Ma1rWsyD5mkRdWsAixVZmdJpDZ6LVX5hXRc6J1ZOCIUSuK0l+GocfnENZtAVvdkfi3XREsURx71ykINScCfAP8Ak91hTb6rrcKp7dHBcCMe3ahPnCkgson7t7UazOq63xnvK9J60nLHbg9IFDBAU8M+4Ew+7HGt1+HgCrLz+OeV3emsNXfHZzz+B0f4ZN57zjtD1lFQh+sJiL5oRqLWm2hsDhT/vnd7UUqPG/klV/A/2AzRLKOYFSOlIVawil+EgYK78qy1CpD5Ye58resOMIqPzhptVP5i0FIRJtE0wZgZjb78iqmPuNvKSaUZlQyo+t4bu8oFET7kZeNsJTG50fvFkqr39Nle0aJUQrRoBHHAktTq04t7EpgVcwUQfh4uPjoHiYORF3P/QjeDSGI6kpZw/jD6Yr1Y5QV1zf9va7DG4iFKibxzYNma9wpBuyF4fqAhdyiZB8NEmreVf3EizuKLCXbzaVIm/xd/Hrnc5/pOBy6MmYQgJcqC7/4ojMesMQXzOzQSz8falOa1nma01sYQWMyKXgRjy6sxIXpoQpCsvwunCaS3NLP40kWpLIHrWrRQk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzZuRitJYzhjMm54cHlYc2U5VmE0RGYzSUwxQm5sY2tHQjFvSWd6RFpISXRx?=
 =?utf-8?B?bGptZ2ZHQVREaURUMEpSU1hYN2VvZ0RXaG53MUg4ZHlWNVlzN3gvclZhMjNX?=
 =?utf-8?B?WlhGNldDR0lmL1cyUGJDdGh2ZnJVT0MzL2lLNXViQVBhUENIY25FTUxIS29u?=
 =?utf-8?B?Mm00RS9hNzRwOHpEcEROWWZZY2lnR0FjRUdWb20rSmJxNUpDU3VyMXBOTE5B?=
 =?utf-8?B?cUFDanZZTkhyUm9jQnlnT0xjeThJekt2eFcrdldUZnBYSHNxWlZweFZ5cEFx?=
 =?utf-8?B?YnlBR1FPbzBId0F5R2cvOVltclhxUmZ2VWJZUDdoODhVTmNsMlR1eDRPWCtk?=
 =?utf-8?B?VVpieW0zZEV0anJUNnAyTm5FNyt1SWVURmNNYXI0anVzMmdnVnJUTi91S0oy?=
 =?utf-8?B?bnBLV1VlKzMwQkVFcTlGTW1IWFRKNGhlTGszQnAwR3N6S24wLzBnRUdhbnFa?=
 =?utf-8?B?ZDZpSXNVNStIYzVJVzdxellkeTRmMW9QRUIwNlhMR2tNRkx4QUdRTENuTmdD?=
 =?utf-8?B?Q1lnNkVKU3lUQnRHUTVNc2lHWWpVWitKc2sxOEZvOTZJRFZvRFkwZUtGd2VH?=
 =?utf-8?B?b3YwbGVLMEY2VUFpSVRwZnhFY242c1Yrb3lvcWNVMnArSlhvM2lNSmJsOWIr?=
 =?utf-8?B?NHBKa1B6SjBUbmpmSHIycFUzQ09rdlM5NGg2djFraWwzOFZUWDVKVCs3WDEr?=
 =?utf-8?B?QUY1SXJsRmNRaWxOaXZ0bk05blEvWndtSm1oVHNKVDlxbTEvckVNWnJoVHBx?=
 =?utf-8?B?bkhYU2FiZ1hYVEJZZ3dlNG1lUjlweUp4dkdLR2FydCtXMGZsemZWT0NFTVp6?=
 =?utf-8?B?b3pwL3VqZW1DN0lrc2ErYVhLTTBKRnJ4L2pJMENURXRqWUNCWU50MzdKdDBX?=
 =?utf-8?B?c3ZqUnc4UGtGLzBYTkttT2ZJOXR5TVdWUjczbkdVWS9TRGl6S2tvRW9VSDhj?=
 =?utf-8?B?d0Y4Qi9nYTZ5TGpHeDN3VXJGaEh1UXFicWxVSVA3MCtKNDZtNGpGNFlsVEw1?=
 =?utf-8?B?R3BXWXIyczV5bDBMaDlkR0ZTU3Q0Y0J0azl3eHNSM21zSUVQWlVNWVc3cGFI?=
 =?utf-8?B?dVVjdUJlRDFjZ1FwUGFyUGpZa1VyNTk1OWpMUkw0aEZNbDd0NUJ4cnFHV0Fi?=
 =?utf-8?B?WDlkNFB0a3B0dDBaeklnTTJ1dnQyUVNiZlpIREhSQkRJcnppVlExWWRKZzU0?=
 =?utf-8?B?eFRUQTV5SlZjMTZHT2tlNmwzQUV6OFZIOHdKL3VDQk5VVzhJOFlHbGpqUHFz?=
 =?utf-8?B?cFBSbjdkREtKNEdZc29hNGp1NEZuV05IZURlckNDWFI4VjdXRG84NW1hc0Vx?=
 =?utf-8?B?RFJKekQyZjNkUTE2T0V0SUJHeFI1bWROTCtWUnp5eFRHYzFqcEtZSHFZNW8z?=
 =?utf-8?B?bnF5bnpXMU10MSt4dW03S3VBSGJJcU92em15Z3VLMnRSbzhqdTZ2cFVwSVNG?=
 =?utf-8?B?RnpFSTk2c0c5YnZzVHNMaE1jWWcrbFR2ZXc2WDlUcERDL0JqYTFXdmtkRFk2?=
 =?utf-8?B?ZnBkZVZMZ3ByYWVDQVpDQ0tkQ01IY2xMZkY0SS8za1M5VGtnTkpOUmpLMjRw?=
 =?utf-8?B?VFpFQWVucEkzTXM3RXdzblVFTHkyeUowdnVwaWptc21tS0c2NnpGYnZCMDc5?=
 =?utf-8?B?OWEwRjI3bEF5NnpIN1d5Y0l5K0ZzYUlHVVFJaERFc09ueVlSOWR6dml5T0xi?=
 =?utf-8?B?ZGs5aWFoUjRPQ0RMMXgwMDRueGkxWVZVUWRFbytFcU9kRjFOMGphUnRFaDR4?=
 =?utf-8?B?NmNRL1B2bDl5azBwRmFRNkRLZCtEZlBLZjF6QncxZ0x2b0dMMEpQK1VweXUw?=
 =?utf-8?B?NFViYmJIWW5KZjJEMjR5eEhWL2tSTU1jZDFTVGI0amZZV2w2bFlXUUVGNG5X?=
 =?utf-8?B?eWtRbFRCNkdJdmJFQ0JzZFZqMEF6MllhVFBJOUZWV1l0SmNiV1JBek01emsr?=
 =?utf-8?B?Y3hEcGJEa2psdnFqTTlxNXhVRm1kUDhzZlI3Nk5EN1ZWZGtYTU9QQSt3ZWd0?=
 =?utf-8?B?cUcxZ1J6dDdOMnVERFJOODZ5ZEh1dS9wQytoU2dZZE5VUjJQZzRhK2pra1ZV?=
 =?utf-8?B?Mjc4bXJSWFVyd202YVpJcERmTWNvRWppQTg0Unp2eEhhSlc1d0JodlI2QXUz?=
 =?utf-8?B?clZmWERZYjU1ZW9VNFc3MERuZWJhUDFHclhLRCtmVVY0WlU2dlV5a2dmSmxB?=
 =?utf-8?B?RzBFZjA4c0JOT1ZSWWxabzdUT0VmNVU1Y09FZG81RTFlQlBrOVRPTkdkU1cx?=
 =?utf-8?B?dUdSM2xwaGI4aGwvbUFtS2s3dHBnNmczajNldHN6Unh6RG9SU1BRd1dtejVq?=
 =?utf-8?B?LzZYVk1EVWlMeXNCbmRTZlR3RGVWeVZ2VFVYMGNpM2hQeHBteTAxVllYUWdk?=
 =?utf-8?Q?fwEQbUCvp02hFTpE=3D?=
X-Exchange-RoutingPolicyChecked:
	UZjPp2H/QVdezQ/TiAarCq3lSfa5sPBlhBRKASpco+zN339lbQbuxNQLVmV2d2Za7sKgShifRB0U64rPb9YIhRm2Vni/5u2XjPft1VvtOBwZqdpEnYLfOa1unvGufgj5Qzrs/5UF152phOMPiG/hFQSyGiWlYI2zvQ9JgEhfLXOO4zLuzVT2WGTNIxNHHX1o3+WsBdDDf5YG/JA6rfjXY/Vqld54fvp9aqPY74imh+MPeksoY1BZCMEwJALnU+X3hJ6Z6n6ionMpBMlXz3obDF+1w0K7ZWtl7qrJloe753pv3onowvR3Bs6CGEyTtfoVUIDDGKCDB2erikKneGp3Jg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PUD1LYZ3QxRZIO+hcrkSA34kEL6mLKb9+EcGlb+NaOyHHqbQOWflgiBbx468BFDUIS5zsWKbsTBKiv7ryQ0V+1ynYpXQUr2S3b1NrlFMih0qUtzEjlb9HJdrPCJgP37OjAQ1yzkvrvRbEr2hU7GwpRTiUtzH3IAtzwWdVCz+9g4jxBTyVdGrL4fLIiR3e3iXrxAujPAVAjMvuw3ZIoPP1W9LVbuMxjUVR0kk3GhrhDUpkpqa1R6ddjZqCZnY+sFt3I3UFNGs5gt8BKk4PUTvkSqxzS5ZPVPlQ/frJRkrRJwP0mxczESCaFW/oxEsZJvBxqCFVufxnKMd3AWas2hDYjZrJJlE2nmZ7T0NqHUOa3BlQrrvnBnGecZ9FzLZ8BVkPFf3vZgwG4wfTwBhG2DpbwFFaorIseWR4njDuAawPMESPtO1CUi9fcTSG2tcDU4ngwQtpbumZcgCmfmpzDcJMUP99WYWwmLkATZiLkb+n0IvdngNNShOj4IR51mbFvsu8SbiLG91x40ODRyQ5oZIaJlPQcv9hWwrT2NU74ja7HQGX4i5S9R3LFfPhk7UTs+zB/0k9AzH2PZZHAM0BG5Z2ohe+rOwc/VciCq6TbOs88Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffc9189-881d-4a4d-e6a4-08dee337b126
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 12:42:27.0036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOW5P4zOEVFFRQPJaN/EELmtVDX8Dnu7VjE/FeoB9eEugjY+sQIUerdOUuXI0oqntRAWYSkJhv6XvwXH5OrO9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_04,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607160131
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a58d1e1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=8cudxr3IJKBV4PzA8-oA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDEzMSBTYWx0ZWRfX89UvbebWBaIP
 guIQ/io98s7prH79s8rq+OYH4MD4FjQk+byCkv2ahxJUuegmpxWFH9UIpWArgnwLPSAx8FfizDB
 vo8pGQ0MOncmjDEQ/er7ULzL0c8SeYTZKr+Bs3KlUfJnDGPDHI/4AeH0u42UatcNzHcrGw+DmKa
 rRS+aOTRz/BnCMey2kALlQIYYUmFgXCG+46nlOUrqxYASdYdc69omEmltsrMIWRF++BTBx7QRwC
 NuIpIeUSMZihELEK2+qJkbjv6pY25Zf0UL4R8tebtzWr8RZ/mhhHdp1LfbsfPdXfvLN97TfDWax
 +nEWiUf2HjDl0Lmg9ZyKDtCil60ICmWyEwRhSwOX9f1MKWArb7nKXzwaGawKxJeY5eEEkg/rj/f
 9KSgXUi9OqMjlZnSISE0DGZxCIyiHgyFRcrHd/9Cv0NsM/x2RVDujMbd9p+2vZq2o1faRY78l7+
 1ZTxeb408q+BOhHsqsA==
X-Proofpoint-GUID: aPVUbHQeei97PY7MfzJbIldQzmKWZs-0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDEzMSBTYWx0ZWRfX4ivfSGZMC3zT
 MiBaJTggFTz49ZZcgXuXOWwNAUfBIqmUZaQ3fqukH6P4x4u5rx+st6wO8Rx+wYavU+4ptmpPvhr
 2niJMGzuUkheMNVNidX0soNB1TFDCLETc6T74VPRQrUbkZeqwX8i
X-Proofpoint-ORIG-GUID: aPVUbHQeei97PY7MfzJbIldQzmKWZs-0

On 16/07/2026 12:48, yangxingui wrote:

+

>>> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event 
>>> workqueue for HA resume")
>>> Signed-off-by: Xingui Yang<yangxingui@huawei.com>
>>
>> Can this possibly be tested on another SCSI HBA which uses libsas? And 
>> using SATA disks.
> 
> Hi John,
> Unfortunately I don't have access to isci or pm8001 hardware for 
> testing. ^-^
> 
> If anyone on the list has such hardware and could help verify, that 
> would be much appreciated.

By checking the mailing lists you can see who has been hacking libsas or 
drivers which use libsas in future.

For now:

Reviewed-by: John Garry <john.g.garry@oracle.com>
