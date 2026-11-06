Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793995964;
	b=bdyOjwbOdEba/G7q5uuKNgBFHnPrhjiP3uRl2bl+7jS7X+HM7wC5fIyf45iv/cFJqzpu
	 aPqzEnahblPOcVFiADoRN8Xg27oJPnKdEmGYWFaHvs6Iulfzrd+bx3qMssb+ws5BIFefw
	 1+pVB6SeD3x7RZn1nPHFCNZFB6wA+NHhYxwmwWLkd454eY1U4GbumwmjcKmFZqm7DVWNy
	 AOp0RweXIblrObowwsmr+nl6wbdHWpwc2ZKRY5uHCBjUaymAXBDEk30E63LFTJt4u2DDI
	 VOOMIAntyANY4zzNsaaogPskQFCGYREUSkzMpSPourCNaRY3+M8GCmSzoSHRi0hdYtg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793995964;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc;
	bh=/sGqIbCBX/s40K5TfRRMTZP3ixQz2840RM25eCeopZ0=;
	b=vJJ7+ln4pKu3Uv8PglCEtnIwjOnV/a0+RuYSJhAUfuCjtuelARkZn3ocmmfcfCdS0Lz9
	 Z2HDLet8lCcLFFSJr/bOFEBdz5SDS3T79TDoc5lVi3ImAgSTBq4oUjm4T09Bq5dMTw51Q
	 CLKXozQLAuCEU/eF0hqz9uDHE4cRQx1UlSHfxh5LXS511Q/rhw2sRtTUZLggCG9zlBZBd
	 cER3hAwQ/dR4vPWzVfvsqhnyGov/gnV0h4D1llV9/Pm5nYibN4Qqqgkl3rItQ8xGlz686
	 MSo5dRYnIO+DactVVHpWcbMqDhihvcV7DU9Nq8bn14Vq5jhrmGFFu4a/CKixNg6Ycuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oracle.com;
	spf=pass smtp.mailfrom=oracle.com;
	dkim=pass header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=q+h975Ec;
	dkim=pass header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=NKCuWjcx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.165.32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A00A606A326;
	Fri,  6 Nov 2026 20:12:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A00A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2025-04-25 header.b=q+h975Ec;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=NKCuWjcx
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6FT8PL4118773;
	Fri, 6 Nov 2026 20:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/sGqIbCBX/s40K5TfRRMTZP3ixQz2840RM25eCeopZ0=; b=
	q+h975Ecre8GpoC3bGPgQRBXg96CcfQQA/i9FPQ4f6xeOqUVjHFoOxtCz+KTaSM3
	hU89P3a/XAfuSd+/9A1JU65wCOhKWWfQkHIQh5cObkdcVbYLGJqR/BN+3guevqB0
	MsVUP+dHn3GlJEggzfI1+tWKQIe1ronp0zty3nR4LhpaPYDo2Tv0gccs9DD/rtvH
	X5m9NtlbiMj6Q7LRQmydV3cd81B/yCGKEbhOAOg7MTO+do7mTJFpheWgd6nri/yL
	oQTyjJSwoxLDn2sYEgD7nxAiTx2A4LvMub3/LoYSRvhaYJldZ5GLD1kjjl+XFjnh
	5D4jtZfV0kzDEKExyCpz4g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hs3qp9csd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Fri, 06 Nov 2026 20:12:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6HrcSq1801961;
	Fri, 6 Nov 2026 20:12:30 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010047.outbound.protection.outlook.com [52.101.193.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4hsjx9y2sk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Fri, 06 Nov 2026 20:12:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5txFENIpw5EN+8AZNLo8ERD/zFSvpnRAYD2yVqna7hvP85v9HLr9wN9aI0S3k5GN+l39yPO7rNs9+cbwd1vwgqPRBts9rA51r/9DiBgdYI5iQpi59u7lD3i8VK+jST5hc09w9fDtVpXhhJIDt6dHq0+U2Fz+Ff3bUnnjMllOcgpH8tqiyxQqsCEFU8VBwMxCoL0El4xkr0gWSzqI50ppdXvEre/4eQu+UaiNlHiw/+F7aPfrJ4Y+s0FpNTZlZnMFfAw5vzlciUKqIsWTdgGJ86/Le7/A3MyTTEBHZYjQVNVoxCsGHV1YAsYISCLXBplTNb47GRKj2fN3zBuiI+DRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sGqIbCBX/s40K5TfRRMTZP3ixQz2840RM25eCeopZ0=;
 b=dNCFsr0WYlb1NnGEXUw8mka6lDEB6Z25R9ujbqFKM6vKpc2f8TYsEwzyPWmLbf/2j8tUBqSA82yWIQkqrJB3N+qTwkD/TIyBt+09cFoEszHQdAV7PbXF/Fzh7fduGKvO99X+EPHQ1qYB+99hNZ0n5Ct92rwonma3BRbncp/94RFSMGe4k/9ul8P8D02V3cKy3AnDtsx7FfrReue0/mP9Ts3v6Pq2CDEXm9E2qSK403bHQwZ+NpBEycfDlWgQ8JAAJz9zgDzKWvygT0KT9AbIFRZ4JOMVyOB+xQtZSiNQEM4y0pYEmfFj7scduN1uHMSK0m2bhoSbmHcajhXQw+S8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sGqIbCBX/s40K5TfRRMTZP3ixQz2840RM25eCeopZ0=;
 b=NKCuWjcxxRBENK+sbyUFvZnHY6yxiawKr/2+kYrbCyiEU6psPnABeUNEkXAOGNu+bHx8X7BY9WPXqzIKRPczL72Tfou6nWuXVg8PXlcVkgQqvxT+nXh+DP8GryBYm5D/6S+UNow1jfDvtZde3SaVYMNkeVAoAvk7dTZw/AznLPE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6) by IA3PR10MB8114.namprd10.prod.outlook.com
 (2603:10b6:208:513::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 20:12:25 +0000
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::1e13:1d2c:49a5:e8a1]) by PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::1e13:1d2c:49a5:e8a1%5]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 20:12:21 +0000
Message-ID: <92a8e5e4-2729-476f-82e5-e73e51a010e6@oracle.com>
Date: Fri, 6 Nov 2026 14:12:19 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
To: Stefan Hajnoczi <stefanha@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, mst@redhat.com,
        jasowangio@gmail.com, mkp@kernel.org,
        James.Bottomley@hansenpartnership.com, pbonzini@redhat.com,
        eperezma@redhat.com, virtualization@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        sashiko-bot@kernel.org, kwolf@redhat.com
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
 <20261102200615.GC1738758@shajnocz.csb>
 <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
 <20261103135156.GB2072598@shajnocz.csb>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20261103135156.GB2072598@shajnocz.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:1ca::10) To PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8C8C3D129:EE_|IA3PR10MB8114:EE_
X-MS-Office365-Filtering-Correlation-Id: a0f76bdc-f614-49ba-7760-08df3c4243ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|10067099003|18002099003|22082099003|3023799007|261026121527099003|56012099006|5023799004|4143699003|261021121427099003|261009223027099003|261028144727099003|261102123227099003|261026140227099003|261022075727099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	Ar2NmQzwpiZqLV9fi0MUZpVFPZhWn+v6HU0eqqc6/DYLXvwPlH1Lu+QE3k79afsHkoCYfjXXedEOZWwv/DNCGgq670U+s4qnK7fCPFMxFuxFDhwv3mIXtOE2huY0j55YWGu+gNYM8I2x9Ff8UDS/jFjh98fp2pmro61EXUHJxUg2q+SEERxZRr2DOc0BnD6Ug8FrAjAOF2L60WTyQJa+bnGpB7Ai/bKMquiS3cl6yBsT7k0mR417to460rsqKMbyzMpZP4UEnotTIAQWhBXLhIrTX9lxsWfvecQMHEGDGX6YVVihhXCcaMqSOR/kIjV3ejHCvY1wYuhQgPi4+rd7WqDksZyMUYgYTgCogRIQ3VWmmZx/XYdGhuUGQdCIgnFEmmKDC/8s5qFVoEDCZmoe8buXRwWBm7+aY4h/KDSU/gjIld+zA6iq3K5fc90TnznjaVO8nzym1ciRz9WE41KOuFST2zOoeN1gVE4QHyM/N1O46D312AGx8JmzA5hAZMqD/QRE7na6KzSP5rEHf1xNIaus1Q7eHdv9t7BThD+OdfU5S7gicbpSUPgow2xvEvwCai1bYHl+NIeNPb1Noh8+GbDZ/ZrSpAclYYyK1QYybFS1mCMr8sXX286q49HxKvHDSC0KHGlkrQlq3qikiDLuwTzbQCIgfXSFQUw0RuIH2wo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8C8C3D129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(261026121527099003)(56012099006)(5023799004)(4143699003)(261021121427099003)(261009223027099003)(261028144727099003)(261102123227099003)(261026140227099003)(261022075727099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWZIelhqVUwyZzAxanFHek9Ec3Bic1hZckZMdUZKeEZ3YVpqeFBQcG1kV2hY?=
 =?utf-8?B?M1F5RTJDSUcrSHFrc0ZvQWttWnVCYVhvSi8wZlVlSVF6eHBYRU9qNGJYaWl3?=
 =?utf-8?B?SjAyZVNudkdnd2dlaGRocWdXQkVSNUR6Tzl4cmkvRHY2VGExZkd1VUlDYndY?=
 =?utf-8?B?WVFQN0p6TTF4K1AvVjB0YWpISERYVWRlK0pQS3pIS0JaS2YremFiRXdBZHRm?=
 =?utf-8?B?NnU0dzhLaXBKRHZ2b1FvMUY3dkpNL1NCN0k0SWlPK1htVk9kY3BDTjJLM0VG?=
 =?utf-8?B?ZmRjZTFLUGRNVkFpUDJnTUluZnRwYUxOcFJOTGZtNGFPZytnV1daY0s3WTZk?=
 =?utf-8?B?OWRvQ3gvN3VVcFh2RTV0SkVGQUovSzVrVEFtd3YxMTN3aHk0cGI4ZXQwWENz?=
 =?utf-8?B?NDlCM2FsMys0RU1BRVpwalRqcFBqaG9WNE81bGdad0N4dGFLREdGcjlsR2Nt?=
 =?utf-8?B?VzYrenFIY2VVSFF1QUJKbVRPV1hodzE2Y2oxSC9sV2R1UitZUTEzbXBZOUJR?=
 =?utf-8?B?NFhSOExWb2picjNoaS81K096THdFYmo5NmdOZmdxazZDamJad3h2RFNMWkZL?=
 =?utf-8?B?YzE5RFR0VDVwbkRPcmV3aEdRb2EzdFU2cENOR3UyVVZ4TXJpN09HVkg1dmRU?=
 =?utf-8?B?aWVqTEREY3NxRHM4VHJSOGdSNUJiRlhpU1hWVmFOS2RYV2VsemQ3MkFBN1JR?=
 =?utf-8?B?TkpHZGFMYVV5QnNBMkxqa0E0bXRzemQ5Q0dsL2kxMjU1WTZ3dldwN1lpVlBO?=
 =?utf-8?B?NGl6MmU4eXQwZHlsUWx6a25KRTZMV3FxYk44cTV2bmEyK2pISHBxZVQvZjE0?=
 =?utf-8?B?MUxRZVhMeUFSTGowbGxSdHZKUHMzR0c0ZzhUM0FlSkVubUdZTzFWVVVQd3dQ?=
 =?utf-8?B?S1FFY3BsY0VHR2NyWnUvSFRyU1hnak4zbzk3cGV4M3Bha0JrYlRYRXVHODJL?=
 =?utf-8?B?UzB0aU1OOVgwMWxKK3FVMkJwUmFIUmhZdy9Kc1d4WU5EYUV1bFZkRlJ4d0xI?=
 =?utf-8?B?bURYVjRWZjVBOVcreWxEbG5GdzZIT0Fxd01ndGUrMjZoOWkwRmowSmFRM0Fj?=
 =?utf-8?B?YkQyeHVLU3d5TmhGcjB4czJFUkR1a09CNTVEeDVIK1BFMEFxeWM1VmxRQU9t?=
 =?utf-8?B?ZVZ6Y3hWUFJuay9tNEVQa0hIZXZnUmtNaWk0cC9GeUpqeERiQjh1UTQ0TklY?=
 =?utf-8?B?R1BqYVk5Z2F4T1NsbS9jaytWM1JpaHNxbkVqS1dQc1kzQjEraEowM2tMb214?=
 =?utf-8?B?R2tsdWFDbWdPNTd1aUJnb2RqZVpGYTNEVnJmN0lFV3pjYWRra3BXUktHR21r?=
 =?utf-8?B?Ylo3TlRxMCtaZDJZai9IUUQyb0ttNll2T0IvbU55T3lHWTQxSnp3emNERHZt?=
 =?utf-8?B?NUhxN0hGZThPMUtuOC9wak5rczJHK0VML1E0ZW9qYWkwVnN0czNWdXZQNXhk?=
 =?utf-8?B?M25FQWsyaDBzYUxFck5taEZMbitZeFl4RS9FVkhGanIrdmJTdWhMVHhzRVZw?=
 =?utf-8?B?K3V6UTA5VUFPQzd6RVRuUmlOK0Y4d0dvTG5WbnVCQXRLQ1dWU0pONmRUQlRw?=
 =?utf-8?B?N0pnbk5ZaW04SkpTekFiM2NUV1dKM2M3RnlKK3crSmZ1SXdyTmVGQmxJYk1i?=
 =?utf-8?B?M3ZIWFhEVzlhcy8rSHpGazVpNXh0WTVlVXg5TkhOTHNya0NrWFlpR24zSTNV?=
 =?utf-8?B?cldNTytiVkNqRkRMUVQ5K3dIVzY4QU1LYzFjaExtUVFpTkZ6eVVZS3lZYVJt?=
 =?utf-8?B?T0FYZmt3Z3Z1Vk1MVnBnQ3A3NDdGMUEwRHZFZFlyQUJGdWNkdU5MWjVKSTlS?=
 =?utf-8?B?OVZ4N1ZKY1NFcVoyYUdUQ0kra3l3dFc2MUdrdVVVVFpManVlQVRmN042aHE5?=
 =?utf-8?B?NjFGNk8wajh5Z0w4VC9ERXJGd3BrVmtORXhkOE1xdzVjS05vdGl3R2VENzhR?=
 =?utf-8?B?eWR3TkZxOEgyZnMwMUExbWFvMGFSZUhjdE9kaFU0cVFzRWFnNzdKSnVTK2w3?=
 =?utf-8?B?ejJ4L3FkSUNmS2RtVVRPNnRuTVBzaW5XcDFpV2dwSkU1SlJJQ1lDeWFDMmhF?=
 =?utf-8?B?Qk5ZVjdYdWtDZUsyeDJ3cVkzRVltWVRiZFk1Mm1hNDZpZFByTG8xSzdTYktC?=
 =?utf-8?B?dGg0ODJXa29oN2Y1WnRoekFoZWYwK01oNWVkTGd1ZzkzV0FFRmtPQXp0UHgr?=
 =?utf-8?B?cG8zQ2ExSUR4MEEwcXp2TzlnQk5TZDFNTjdpSm1ZTFdrcGZoV2d4OUkvaTNO?=
 =?utf-8?B?ZkdQUXhyZnYxcEZMTmlJNUgwNHFVMWlkRGRnU2xMNkU1M3ZWNCtnZjEzdkI2?=
 =?utf-8?B?bXFXZW1vanp2YTR0UDJsZXRoQ2oyV0NBR3B4elNMQytXekNSNTFhclNsWGlJ?=
 =?utf-8?Q?N1cuRUFQuHJDS1Xs=3D?=
X-Exchange-RoutingPolicyChecked:
	ku3gVgUEzORBPuFx2TfITF6UbC1rCj71DkaD3vukPrMvH/SqtO8B0KpaJEmf7nIM3SrYwRgUH95nvkf1npdusA/Km/Bj7Ui6MDpG+961iKRwLQ/cRrqlUFTCaoCxnDVrCvCEc6g011PiLe1HWuY6GJ6KF/XNqu9q+NoB1dy/jfba660CscV9SpbDoEDOyqdKYGWxTCMr/eJ3dbwt8rQJ7HAibx61/jQkbnaxkqUHTa0dP+C7YcMeoF3dkrqrl43K66ZWokaK4cm7qozehRdWRXbxmyUJFLSFK40L8QE2aa7llkPxf1aUTzDo7+AJHSDcPqhhrP8hKlQptlG1ZxszSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZHdmX0OkNAT03J/7Dd7+Z/aHSwL+p4Y0xpQEJS8DwDt7Hmn7emceJ/Wuy1MgJ5DqX9gtPyYs8y5JzcKkNxqZk/+HBjdT4/b7ZMF8mCXCE3vlbkjAM7jMDgCXkxBalkHE3s2Tp1sdWq3MpV7L39hJZdXpstYXalEn1AJ0YqRk4sfZr3QyOEIW9YccRsK81FAphmwXQra5LHWsI3P/mOgS+sjrFXWk/glvlsrnf4m4GNRf/8wWFAbQ6gRxD/CoQjtZ/4vLKRRKUmX/VCWg05XVkQrJtbvvoL4c0XtX6SN842vUP5UVUYIBdFcAyN9iqnrchmJj54iLvMQCmD7LHVm6tWPEY9g4oIvN3jZSXpaMm3My5OVgPj9taXzIU9VgdBkcC94fJAt/wKGBlkuJ56R/QjuZeNIULrnF/eeKKEh+lagupeBJSkqFEVILYgkBrCl2yRYuantGlzbWIIVfJVTzRLDY6X5ke25I0t7aPIsRSsKKEYaRE0icRetOwbpwiqhAPRnRmtLNfsBgN0W5+FnSwIClsNcFuCoPHlpRHaQGtK8HBVyvaaj7+KsfcG6LoWXehiX8UwVCxYqOIbTejkDwzl3cFGDMWN7Il5/4cd7uBIA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f76bdc-f614-49ba-7760-08df3c4243ed
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF8C8C3D129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 20:12:21.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8JtBagbHrvE+iXO6/wO3WCFfhbfFSGV263htWs0y2eoJ1DzYESXTVPXV8DkBqfguhHn3jiEjY4HxNGo61vqUll4/Y7V3WGQxlEEDM2osr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-06_06,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2611040001 definitions=main-2611060080
X-Proofpoint-GUID: uwB59zbep00PbSx4gPRmrYu3rmNLQ3KS
X-Authority-Analysis: v=2.4 cv=GLqdgeNK c=1 sm=1 tr=0 ts=6aee34ae b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=pGLkceISAAAA:8
 a=puhylKk3kZJqiNpfFUoA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13532
X-Proofpoint-ORIG-GUID: uwB59zbep00PbSx4gPRmrYu3rmNLQ3KS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA4MCBTYWx0ZWRfX11n59r99ZMxZ
 t2TG3tfQu6uBqzpkL7USOS1APKMRrx9q7BLeLzt1IHT8kAVIzSxeKNeIVl2Y/hHq4g7ZtU6iibW
 +D8OBrvR0MCZY6HBDw7HUHFdLWrPrt136R77ArAN6ZyG2VsYMfDY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA4MCBTYWx0ZWRfX8F6Z89jQLCYc
 /cGRa+casEsbKKvrH/KvDBzj+r0TjrXXjjAGBX+7d/f3EjnqZ34zrIl8gJgbHIILZhKfI0GS7d/
 saZHvFTuc8svYLETjmCcpuG1Pzpoeoh3xKXQZS+4XOre50ShExXEk8nJLd8aYciPlefqwtBTYQS
 59Y667sm2qzVBw6TIdrlbMbcHv91JzECkWB+PMW5x8S/LFv8wVCyHKR5td82P3H6qh6C8mT1m59
 X26U49o9jtTksvdfHQ9Pz7ULTuty4ntwe3AMkUGTQn6IkE/D379d8NfZnnu6UwwKtMWoEOaTyMp
 UmMdpn2HJeqJ65vON62LXadbC0PcAxBsVld/nnxwgQZfGb+dY14eYlkYcr8mIuR9L4vPU95lL7f
 x93Yenvh/v4Umfwfmk83d6np9CwbZZ3iHeS4gMQvJ1uW21jG7tXB4Uh/YQVFuY3AFnadthQMw1m
 qTLU2Itbs4fVsj/XFryHooFh3hC5VOqqbODDKK5E=

On 11/3/26 7:51 AM, Stefan Hajnoczi wrote:
> On Tue, Nov 03, 2026 at 08:27:52AM +0100, Hannes Reinecke wrote:
>> On 11/2/26 9:06 PM, Stefan Hajnoczi wrote:
>>> On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
>>>> Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
>>>> abort and device reset both fail the same way (same dead ctrl vq), and
>>>> since virtio_scsi implements neither target nor bus reset, EH falls
>>>> through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
>>>> buffers without any guarantee the device has actually stopped touching
>>>> them. If bus mastering (or whatever broke the transport) comes back
>>>> later, the device can still write into memory the kernel has already
>>>> reused.
>>>>
>>>> Add a real eh_host_reset_handler instead. virtio_reset_device() is the
>>>> guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
>>>> device will not touch guest memory again, so it is safe to hand
>>>> outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
>>>> virtscsi_init() -- the exact sequence already used across
>>>> suspend/resume -- to tear the virtqueues down and rebuild them.
>>>>
>>>> Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
>>>> mid-write): EH now runs abort -> device reset -> host reset -> abort ->
>>>> device reset -> host reset -> offline, then dd's stuck fsync returns
>>>> EIO and D-state drains to 0, in ~244s total. No task remains
>>>> uninterruptibly blocked.
>>> By the way, there is a known limitation in the QEMU virtio-scsi
>>> implementation where some reset-related operations are implemented
>>> synchronously (can block vCPUs and QEMU activity while waiting for I/O
>>> to drain in some situations) instead of asynchronously. Recently there
>>> has been work in QEMU to make VIRTIO device reset asynchronous, for
>>> example, but it needs to be implemented on a per-device basis and
>>> virtio-scsi hasn't taken advantage of it yet.
>>>
>>> Please let me know if you'd like to discuss or contribute. It's
>>> something that is on my radar but not until 2027.
>>>
>>>> Suggested-by: Hannes Reinecke <hare@suse.de>
>>>> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>>>> ---
>>>> v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
>>>> Reinecke in review of the original RFC, instead of relying solely on
>>>> the EH loop falling through to offline.
>>>> ---
>>>>   drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
>>>>   1 file changed, 24 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>>>> index b4f20c487718..9698f4f91cc6 100644
>>>> --- a/drivers/scsi/virtio_scsi.c
>>>> +++ b/drivers/scsi/virtio_scsi.c
>>>> @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
>>>>   	return SCSI_EH_NOT_HANDLED;
>>>>   }
>>>> +static int virtscsi_host_reset(struct scsi_cmnd *sc);
>>>> +
>>>>   static const struct scsi_host_template virtscsi_host_template = {
>>>>   	.module = THIS_MODULE,
>>>>   	.name = "Virtio SCSI HBA",
>>>> @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
>>>>   	.eh_abort_handler = virtscsi_abort,
>>>>   	.eh_device_reset_handler = virtscsi_device_reset,
>>>>   	.eh_timed_out = virtscsi_eh_timed_out,
>>>> +	.eh_host_reset_handler = virtscsi_host_reset,
>>>>   	.sdev_init = virtscsi_device_alloc,
>>>>   	.dma_boundary = UINT_MAX,
>>>> @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
>>>>   	return err;
>>>>   }
>>>> +/*
>>>> + * No bus/target reset in virtio-scsi, so EH lands here after device
>>> The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
>>> good to me, but I would like clarification on this comment. virtio-scsi
>>> does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
>>> the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
>>> doesn't have target reset? And do you want to go ahead and implement
>>> .eh_target_reset_handler() using I_T_NEXUS_RESET?
>>>
>> Would probably not a bad idea to use I_T_NEXUS_RESET here.
>> Not sure what it does internally, though; _is_ there a nexus
>> to reset?
> Whether there is any benefit to I_T_NEXUS_RESET may depend on the device
> implementation. In QEMU:
> - LOGICAL_UNIT_RESET resets just 1 LUN
> - I_T_NEXUS_RESET resets all LUNs
> - VIRTIO device reset also resets the HBA itself
> 
> In practice QEMU's I_T_NEXUS_RESET is unlikely to fix things if
> LOGICAL_UNIT_RESET wasn't sufficient. Maybe it will help on other device
> implementations though.
> 
> I think the Linux driver mapping should be:
> - .eh_device_reset_handler() -> LOGICAL_UNIT_RESET
> - .eh_target_reset_handler() -> I_T_NEXUS_RESET
> - .eh_host_reset_handler() -> VIRTIO device reset

How are vhost drivers notified of the device reset? For qemu virtio-scsi
this would call virtio_scsi_reset right?

For vhost-scsi though, do we need to add a similar reset function?

