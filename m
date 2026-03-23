Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1C436E484;
	Mon, 23 Mar 2026 08:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774255540; cv=fail; b=ciCE0I7O69vgLk4U+sA2PlJ4dMw0TzSEhFThIRcAT6nV02gZBDwxFu10BKz1Eei9Pea4tV9PBbyh56tyOjfJcvTqJRUReMIWdza6IST80H9gy4U4fcJHGv+28DpfxfSmzyAI7leX9u9VT/mDDX6MV9tTfF72hRBsQS+TSApG7K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774255540; c=relaxed/simple;
	bh=lZBi7qeiF4Y9qThHcngB2ACPy1JG8xkdThOeKnLu4ng=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=resUdyrBQ1vZVNAvrG0QRyCcbMDIvNehcWyzzfLJj/T28TD46hqhOezUy/5aWGEj8exY/mNITrR1HyShFYHEzdDexF5kjWYgJ0cwJrvUWth6TvXAh/+AfCWlq+O2p/JhQQpRSMAAsYPwCxOECVR32iSFDwWkcE0wZ6FElxCIiPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dl5EOYcu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RDUG+wLX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dl5EOYcu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RDUG+wLX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MMUcQf1960215;
	Mon, 23 Mar 2026 08:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lD/ndwQD9HV77lcqjv3q5rYrhqAKA+kuE1NYQ7CumfY=; b=
	Dl5EOYcu0EvoJvy/S1wF0pOtbpmkYCjbJhKcVRSW9FIIAR0S+m2ezUL3BB67UuLa
	KRYUP/0Pl833mjtNut2ptQ8I+rYwo+rBOVT0baFAfR7I5SBMBCPWyQLbD1opWkxJ
	NZhOX+SGKGeoAd0XNReiabCTpcdFnLXilbpkCefYIoeOk5lFCZukskYKgHa4gvvN
	Nf5UvrfLyUcSvtSNgafU+e04d/kNBYnGjsg7RrH6th+CqX6PKyEtI95m/EgZnhfU
	JgJGb6hsmzNLjDHLnnSms78VM2+RxrtQFCuoak7CTIgNd8LIYb0jQ6QQqD5DpK0n
	Rp5lvUK9x1QTZIwAqQ2Lnw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kja1u8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 08:45:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62N8EhaM000671;
	Mon, 23 Mar 2026 08:45:13 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011029.outbound.protection.outlook.com [52.101.57.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs870p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 08:45:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RuCgv12HspU5AkhZVUU3uiuFtkF+6Dp0Zn66DdAft3gNMp4Uj/Ni7bDq1/b5V6DJBG35PgEyMG7ZR9554AYV+ZQwm8NsUshTxwwo557FfYKnTBB+uVTcdB2TGeXOyF4zFIMbYXVbHN2eJjF6OX5r0HfLSyp3IhQYUtkhdCigBe0hu4k879byLzbA8JsgHBcfJB8iE4w2b/AxW3CDo2/rYehD57ataFJdM3GqkQJKorQC3yjqBoOy2CZwILSImi4sUMslvprLiPS4j7O1Ryu6cLLUKkoxDl8BWRqonYuMHIW3bLQwK4TtIO08TOkaZ+MykoACROxzNHbDnKPk84L5sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lD/ndwQD9HV77lcqjv3q5rYrhqAKA+kuE1NYQ7CumfY=;
 b=rFzg184q+ibOlb+LP+CMy3o50vLnz7KmowfupQyIHrl7B47ThJxriwDQnp4jKLsFoEGSF+yTsDFKV9piGFRL6rSNDx2YNi5W27PIwRQIsxl1xYv2HaPASjBAChOM2fA8gHXdxb2NDcLOGyz+IPojGKAiA4w4ON5hOj20oHzbZhzQKaW3BMQrB8+Skwo5xrGNWJcu6zb5q0tF+Egi6mdGadR+e+sNJHkOezd+B/lMmknORssB0INMKI+04yne5TBBTEuVx/rh6LclX7hLu9gvu628MuAwxNKSL2ophay3rsTFNmvvBfNuuqsWgxG3XTI9cVsMms9hUAWrSIflhSz0XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD/ndwQD9HV77lcqjv3q5rYrhqAKA+kuE1NYQ7CumfY=;
 b=RDUG+wLX6dAcRqiZaB8YJcyG7Zjov0grf0yjejb61ad+metwqyObFlICpKv+ycDjRZBoM55iO7EFP+f72U+LAhOUHvra+DEFpveaaV2mrwQv7tnfn4QmyRjDGt7aH/Dw3LTQtL4qD1Q1lMpI4sY+//qhBDNLl0kRLiS/jquVrgI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO6PR10MB5604.namprd10.prod.outlook.com
 (2603:10b6:303:14b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 08:45:10 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 08:45:10 +0000
Message-ID: <c03ccf98-a86c-4c30-bc24-e76178ea8bdd@oracle.com>
Date: Mon, 23 Mar 2026 08:45:05 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, dlemoal@kernel.org, hch@lst.de,
        ionut_n2001@yahoo.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sunlightlinux@gmail.com, stable@vger.kernel.org
References: <20260320081429.42106-1-ionut.nechita@windriver.com>
 <20260320081429.42106-2-ionut.nechita@windriver.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260320081429.42106-2-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO6PR10MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: 574dd0dd-9bf3-4292-591f-08de88b87ddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|56012099003|7053199007|18002099003;
X-Microsoft-Antispam-Message-Info:
	So/N0/fVUsmBQWo1aHcO4cEVn8cFOKo/L11d2gzA1iI7tEHeByjT+e8FO/i7o0EIxq9AbAhK3sP1K/bwQnf6s0wYYeUayqv/BAmlMvNB4ZvghDNTApBY+OGHy9t7NtaJlIAkNM8PcsIWVUSLYQJm5WhueQaMWpx6qeV5d3P6dwszq+cLZa8vL4UOOTtpSAox7gwn3wg3YkRImSM0LGTPSkW6ziCXNz3yUcSNwdERzb3N7lC2QjeKJOvyhtIujD281bJbjnOj2L4sQV/KChm26bsB4E0GLRDS/2Flyhf7lHGrRUcEoeU18WSXC6+cjs896yljK8cWgjT4DF1Bz0ulhIZaDBuvn2DP/7LHgP8Eo6o24olV2dxv3ew4yJ+rQObaSEN3iVMvrHavMRa3DdwNOTMrT2CzOSN/mLf/5Q3tv7iZDZ4qcn1F9qLtcSQeVWj/in+xFtNLhDbLkg4qv1vGIicPCjeoq4JVt00BeCnWPb5U6q/0gwWW9fvo3WBeDUM8zF9nc2QUmOFz7px4+ksubN7UdYVnIQxYJJghov+p1BCkid05PaIvHCKBUfUPn+LWs3yEB3Xur0TmiiuFlUmBuTqis3nF0iOb6SaCAKhJzrrS9YCgolu/3Mle0O8xEHHnHvzNeLix+QE6HVKGU+MOJyCLtBUQ9OVwE5Vxw8YBDmhdAKr5UYrOLtBkiIDhEfXlw9wTC/hrNsEtBHdLYR/5VhKYSdnzzeE/sBQqqHEN3Ss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(56012099003)(7053199007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnhQdGZuQTZxUVFXRHk0c1I3eHhjTXNrUHBRaHRQb2gzaEtmWkkwR1RIZ1ZX?=
 =?utf-8?B?MmljM2JSRmFiMkNYUXBadi9UdmNmTWdjeWhlZSs1WmRseXJMNXQ2VkNZWUtn?=
 =?utf-8?B?RlpDQjJ0bUFTMlBHbUJ0a0h1RkZ5WkQ5L1lxVTNmWDc4VG9NT3NtdHZCL3R0?=
 =?utf-8?B?ejNvV2Z2U2V4THB2QTd1QWZDRVlOV2tTOVRmWEE0dDNDeTFMU0ZHRmE5a3F2?=
 =?utf-8?B?MFRnMUh5a2VVWGR2V09WVmJWMlVrcWVRYWtxRmJXay93NitMTmlTRzlEUnBw?=
 =?utf-8?B?VTFxaHBDZDhLUU83Y1JtUGR4ei9xY0wrN2lGTjdFMXFuZjhWUU95QjU3bUJm?=
 =?utf-8?B?Rm1Wc2xXT0g3Uk5jZnEyOXBJMUVLSGFQN08vakpYV00yYzJBK1hJZVYyc2p6?=
 =?utf-8?B?dTNQRzBRS292WE80U0IyK1ozRnV5WmZUQ1NJcjBVTmtjcTdrOEszVS9TN2Vu?=
 =?utf-8?B?bkZqK3RiSlhVamptTEE3V1crTVpiQldLZG83Tk0xczJmTmpsYXlQOTBmVWUz?=
 =?utf-8?B?bFpKYkFEbnJIZlRpZk45MGJ6SHo3ZUU2ZlgyeE9UK0N2SENlV1NsaGpFM0t5?=
 =?utf-8?B?bXh4T1FBRjdFVmM1TmRsVFNrdEFMZFEwWkNBbGhLL3QvQVFSSmRsaFAxMjli?=
 =?utf-8?B?RWxyNHlnbllPeDcyMGkxTldhZjFTK3FoQ2JkQWsza0RrYitMZVpJVGo5YnU3?=
 =?utf-8?B?S3FleCtnYkNITnJhSHlZSllEU2p3d0VZelM1MnhsQktFajB1NWlUa0tHb1JJ?=
 =?utf-8?B?UFlpdHZQakk3T21lYkVaQ1RHM3FkQ25pOVRhK0Q5S0pSbkpjNVdPQmVGT0J5?=
 =?utf-8?B?WTJJVmJnQUN4bm1YWTVIR2k1bGprUUllekQ0dTk0bnhBb1MyZDZvTXNFd1Bx?=
 =?utf-8?B?WjI5bVZ5bCtWeVdBbFR4S3FoeHVIUUJHMTZheVNZYzlUKzUxQzUrRklOMDZa?=
 =?utf-8?B?Ny9QeHpZZTFKQUFFcXBZMDBRWEhtT3dGVXRQVWExVXhRVlhvRk5teTdVOVhh?=
 =?utf-8?B?RkZDS1JwTmN1WlRWRWNWcXRMUmJDVFNjWEZaQ3VHOEQ1aXNuOFFVYXF4M3oz?=
 =?utf-8?B?bWZkaEp4UWtkeitkMXBDNWZiQkVVS3NyeVZTRHRVTDNmemtWYlEyV3dvZFZC?=
 =?utf-8?B?c1dSbGNvMDI2Yk83N3ZtcmsreHMyODZQTWpPMjhhb0ZWN041NkVxNmVyVGRx?=
 =?utf-8?B?cTJwS3JLOFhoY2k4L3VsNUtydERYY0dFK1BSZllxQWNWTU8yWktpWWlCcnBP?=
 =?utf-8?B?eCszRG5BMmlUWDJQQVRLQldvRWNZQjhQM0tjeW1neGNyZmtYWTJtM3hxZzVj?=
 =?utf-8?B?djJzQnhXdEJ5SlFkUUJWTFlnQ0NHR2F1bVNtdGpadmp4T1Y5QkVHbzNTbDNv?=
 =?utf-8?B?LzR5am92Z2RkckRTV0d6Smt2aUMyRmM3dTFzQjJaOFRKUVVVZ0JvalQyc2I4?=
 =?utf-8?B?TDVvNEFDYmRNSlYyRURwa3VhNHo1bHRQT3VqVFJMdkFndmVzMHM5M3h0M01L?=
 =?utf-8?B?eUc0NDh3MTI5dE9IaFZGTXNLWW5FazdFVHBjNEt0cGREMG0rSGFPc0x3ZVFq?=
 =?utf-8?B?NERURDBGVDJpbktiWjMwQjN6UUJJTjdPdnV3NzViQnU4NkNJTHBhVEFPOUMw?=
 =?utf-8?B?Zzlyb1lnbDkzSDZlekdPZ0w0aHhkc3ZmV1JjSDJTM0h6MU55YjhPb214eC82?=
 =?utf-8?B?dis0Q2N6d1FCU2tBZEVDUVRHdkE2QUVsQSt2Umtrd3NGa0hGcUJkQVBXY0Fm?=
 =?utf-8?B?UXJwczJ6WElRRVlCL0JTODhiaTNUMS9CWVpsbzFZQmNCY2U4WHJOUUs4Uldu?=
 =?utf-8?B?OWpnUStCZ2xlUC9rblR4MllJK1dGSGFHK3hvcUs5dGhydGdnejZqaVVnZm9p?=
 =?utf-8?B?dDNZR0RtaWdoL3NmSDNMVStKdWcwSmRQUFB5dHFyYjM0SWcrY2ZWMUVJd1lQ?=
 =?utf-8?B?UVk1Z2UzZDErV3VCVWVCT1VybkszdjhBL09BdXJkUzdYTmMyZk43ZnljTWtY?=
 =?utf-8?B?Y1BrSFBrelVNd0pjMUt3b21VTEYyTzJsaXMyUTdSb2pmVEVMYWZXTzFubk9N?=
 =?utf-8?B?RnJxQVowRXNZbHRXWE42cTFieEN0Y25lNWZvNWZBQU03UXIwQzFFNzZJb0sz?=
 =?utf-8?B?QS9mbk5oeUZOS0xSd1Q3azdPdEZnWWpHOHhTRWV6bk40ejlxejNGRGlYOHlF?=
 =?utf-8?B?bEFaZ3ZTaXkrZEUydTJjWXNwVk5LSTYrOXNtdWJxSm1tc05MalkrVXFFc2E5?=
 =?utf-8?B?enVnbHpkRXgyellzVld4Q2ZFYWI5MCtFS3RSMEd1RmRPVHYxcjJrODVxMjND?=
 =?utf-8?B?R2NRYXp5RTF6bHFZLzl5QWppbEJMajdZV21KYXQxUzFJQzkxWXNNZz09?=
X-Exchange-RoutingPolicyChecked:
	QilsnWuVQd6pYg9rVbi4qhIH+nP1BkbF2s+QgoEDb75fKdUZizH/LPNHrp/A7VbYjCznXsGbbdg7sLMJvRPInZqFLNhI78uenJ1GJXKdIcJzD4JSZ/RQ+T1Q0qKHDaH9T84wonGAceK8lwNvQJcTaZaDS9+JFUmS/G2gb+2VGnX3e4ee/UyVrV7CSZBRo1RF8kAHQaJqpxJnctuebb8Bq1b2yTE2f0mjnmymkVXofRA6dQQqr1y31sKJeX3YC1UgJ87ozNNl0tcZ63HGPKrtCgvjIBlnj6sjtqDGP3cNGShWc9bB9zm+1UjGHqnwfLwCL5RjGk4/TFQQVaPR2pvV2g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wJIB6gKW/IwE0aDCxewOwnPCZU0mxRjwgCD1XvgzVSc1JvIfDx0g9XwdYNOJbUkx+vCIgiRtrdTTB5RGCs5mFd09TQ8vMgKcGwQCSa8GMpkWqQ5ljErWSociptGZEzvnDfQi7R3xzz30PUNQjw5cRJLUMCJ+HxigvsILp4NTMV3cz+aXEM0dyh/ojMay+ZTm1fljdYtz4h9hKrVfbDNtTws4lORGlHU4/VHFMmpFo1PvhFA/hE7TdzonBcEZQ2l+PZeQAmY2KacxCIvOW0q1++Cug62UCitZeaA4CIsSreON4QnUq9coCJ81YXW9q/yz4ulL5XuoxHp2oo0Pq+soqHdmA1PRPvT7FW+uoYruy9tZcPZwQgOxSJHWdEbtqZhm+6MlLQshMewBoctwKCur3qQ4iW1lQV8rDrk7AuTOeRtrz+BVgJz2jV67pBPNr0nTLHwa6PgnPL/r/o1sIc+LrereDbJyc2ELcYMEfv+FJXwTOcnxg1kTmkKz/1FiFSB94DgmEoD+jAOo/+EzuZ1lkfSs8NzYZ8UXXgmRHcJLWKuBHWwjVFXuVeJPj017OHh0dFJ1vZ9re9OJjf/hzc0R9+Bc7fZ+T1Td8Ea6fx0yO6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 574dd0dd-9bf3-4292-591f-08de88b87ddd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 08:45:10.2138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzn+tE53LeUR640cxu8AkVmLdYpw0QLKfyRaTRwsbSh6gjlPELkPB2PODmO6ZE33gGEgPra51sY5zI2uFb0heA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA2NyBTYWx0ZWRfX8QWCDXbqPk8O
 9yzW8EQP7Zd6QtlIn03ByueU/1J9lEaO6oDsTev72X1eT0ckopn0GFX7Gs+T3EAdM1jXNvQz+HY
 wS95pXIL3vewOcYeRurHazjE6rimzQJOv7N/bUtRt6q01S2ms2ofRL4SZ+N3BvqjkeBPPgHNyTN
 gomdQoJbsW7FHJ5Kf9UsIUBpTv/4vlHTcHB05YJA0IZdNu+xkNeBQcmkda028cucfu9LeMDyIey
 LwDuLYYDq7mlK5Krprla2v6FCnmzXXtycTLNupum4fNMdO446zC+msG3fUAkbh5pOvLDlnzxPSO
 bdGYfzQlssH1dnpQN6NrO47VJs3CiuYysOS44QB1cP70QTnD3YzxeJR/9o3dUrkEhfOV48qCKbm
 Bb9mGMDxaLDS2GRiQxip8ErIqISye3TZ7lnbVvHqVjT/KUlfidyYuPSN+sWLG3TyQG3jMVGmVMu
 k4fzcoLYPvI3eQxyQ6g==
X-Proofpoint-GUID: -h4axbOnz6uFuo_0PVkvqClGhh3k4s0W
X-Authority-Analysis: v=2.4 cv=TPdIilla c=1 sm=1 tr=0 ts=69c0fd9a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=t7CeM3EgAAAA:8
 a=VwQbUJbxAAAA:8 a=JlixuO2OR9UiyFLh5MkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: -h4axbOnz6uFuo_0PVkvqClGhh3k4s0W

On 20/03/2026 08:14, Ionut Nechita (Wind River) wrote:
> From: Ionut Nechita <ionut.nechita@windriver.com>
> 
> sas_host_setup() unconditionally sets shost->opt_sectors from
> dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
> mode and no DMA ops provide an opt_mapping_size callback,
> dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
> which equals dma_max_mapping_size() — a hard upper bound, not an
> optimization hint.
> 
> On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
> and intel_iommu=off the following values are observed:
> 
>    dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
>    shost->max_sectors      = 32767
>    opt_sectors             = min(32767, huge >> 9) = 32767
>    optimal_io_size         = 32767 << 9 = 16776704
>                            → round_down(16776704, 4096) = 16773120
> 
> The SAS disk (SAMSUNG MZILT800HBHQ0D3) do not report an
> Optimal Transfer Length in VPD page B0,so sdkp->opt_xfer_blocks remains 0.
> sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) = opt_sectors,
> propagating the bogus value into the block device's optimal_io_size
> (visible as OPT-IO = 16773120 in lsblk --topology).
> 
> mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:
> 
>    swidth = 16773120 / 4096 = 4095
>    sunit  = 8192 / 4096     = 2
> 
> Since 4095 % 2 != 0, XFS rejects the geometry:
> 
>    SB stripe unit sanity check failed
> 
> This makes it impossible to create XFS filesystems (e.g. for
> /var/lib/docker) during system bootstrap.
> 
> Fix this by introducing a sas_dma_opt_sectors() helper that only returns
> a non-zero opt_sectors when dma_opt_mapping_size() is strictly less than
> dma_max_mapping_size(), indicating a genuine DMA optimization constraint
> from an IOMMU or DMA ops backend.  The helper also rounds the value down
> to a power of two so that filesystem geometry calculations always produce
> clean results.  When the two DMA values are equal, no backend provided a
> real hint, so opt_sectors stays at 0 ("no preference").
> 
> A WARN_ONCE guards against dma_opt_mapping_size() returning a value
> larger than dma_max_mapping_size(), which would indicate a driver bug.
> A zero check on opt guards against undefined behavior from
> rounddown_pow_of_two(0).  The return value uses min_t(unsigned int, ...)
> to avoid any potential overflow when shifting the size_t opt value down
> to sectors.
> 
> Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
> ---
>   drivers/scsi/scsi_transport_sas.c | 52 ++++++++++++++++++++++++++++---
>   1 file changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 12124f9d5ccd0..a5207caf8565e 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -27,6 +27,7 @@
>   #include <linux/module.h>
>   #include <linux/jiffies.h>
>   #include <linux/err.h>
> +#include <linux/log2.h>
>   #include <linux/slab.h>
>   #include <linux/string.h>
>   #include <linux/blkdev.h>
> @@ -222,6 +223,50 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
>    * SAS host attributes
>    */
>   
> +/**

this is static, so really should not be a kerneldoc comment

> + * sas_dma_opt_sectors - derive opt_sectors from DMA optimal mapping size
> + * @dma_dev: device to query DMA parameters for
> + * @max_sectors: upper bound from the host adapter
> + *
> + * When the DMA layer reports a genuine optimization constraint (i.e.
> + * dma_opt_mapping_size() < dma_max_mapping_size()), convert it to a
> + * sector count, round it down to a power of two so that filesystem
> + * geometry calculations stay sane, and cap it at @max_sectors.
> + *
> + * When the two values are equal no backend provided a real hint and
> + * the function returns 0 ("no preference").  This happens when the
> + * IOMMU is disabled or in passthrough mode: dma_opt_mapping_size()
> + * falls back to min(SIZE_MAX, dma_max_mapping_size()) which equals
> + * dma_max_mapping_size().  Letting that value through would produce
> + * opt_sectors == max_sectors (e.g. 32767), leading to bogus
> + * optimal_io_size values that break mkfs.xfs stripe geometry.
> + *
> + * A WARN_ONCE guards against dma_opt_mapping_size() returning a value
> + * larger than dma_max_mapping_size(), which would indicate a driver bug.
> + */

too much is written here, it can be one paragraph

> +static unsigned int sas_dma_opt_sectors(struct device *dma_dev,
> +					unsigned int max_sectors)
> +{
> +	size_t opt = dma_opt_mapping_size(dma_dev);
> +	size_t max = dma_max_mapping_size(dma_dev);
> +
> +	if (WARN_ONCE(opt > max,
> +		      "dma_opt_mapping_size (%zu) > dma_max_mapping_size (%zu)\n",
> +		      opt, max))
> +		return 0;
> +

this can or should not happen, so it is not the drivers job to check it

> +	/* opt == max means no backend provided a real hint; see above. */
> +	if (opt == max)
> +		return 0;
> +
> +	if (!opt)
> +		return 0;

this can be combined with the previous check:

	if (!opt || opt == max)
		return;

> +
> +	opt = rounddown_pow_of_two(opt);
> +
> +	return min_t(unsigned int, opt >> SECTOR_SHIFT, max_sectors);

max_sectors can really be any value.

I would think that is is better to rounddown to a power-of-2 the min of 
opt sectors and max_sectors

> +}
> +
>   static int sas_host_setup(struct transport_container *tc, struct device *dev,
>   			  struct device *cdev)
>   {
> @@ -239,10 +284,9 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
>   		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
>   			   shost->host_no);
>   
> -	if (dma_dev->dma_mask) {
> -		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
> -				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
> -	}
> +	if (dma_dev->dma_mask)

I think that we don't need to declare dma_dev here, so can have:

static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
{
	struct device *dma_dev = shost->dma_dev;

	if (!dma_dev->dma_mask)
		return;

	/* continue to evaluate opt sectors */
	...
}

> +		shost->opt_sectors =
> +			sas_dma_opt_sectors(dma_dev, shost->max_sectors);
>   
>   	return 0;
>   }

