Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769D441A78F;
	Mon,  6 Jul 2026 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347489; cv=fail; b=u/X0edwycPF46+ITj8NcCorcn0ZUG5hSbAoLOPDkK7BlURzx/K0cvWJl9X+vXvupFVT/x9kC6J956YUsa/MDHwgnp5NuiQ9yshClU8YHWkWJCQ/e8WtI4iNlQGRRMnlmId3Gg/K3uDW00OUO/gqY2iNK0tstP4hZrRDNb1DuAvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347489; c=relaxed/simple;
	bh=MXgiuLAeigfkSyPMky+LtyieRAjIGUOeYXtWaOVSGC4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nipZNUleOZppf9Fj6PfVaSOT4MJeEvwcu6AWC+cHPSFIlVbAdy+MfE+Hsmz6NWyjTwYHKj7zJGaHX5Msmjon7lXikT8nkPMuz1mnF6+sc7ATWGZj+y97wNALco+KbU0okBuW5m/Mz0sp1wBfuZwleTwax7fwwuL9t4HJObeuSfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o07S5Cn0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vNBpe6YU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o07S5Cn0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vNBpe6YU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6663Fn0f1420136;
	Mon, 6 Jul 2026 14:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ykKXkBcntuOVtH5B1SizyX5gRCbTyp0D8RFC7lAIMSw=; b=
	o07S5Cn0semgiU/GAVRFI9vl4MYnI5Izj6DZJmG+TgYGsviQmTfhfhVpQ3KZQxUT
	ReDn1tZfRrxDuFS7qUfY3OyehdvQY09YN2pctIecqqpsMAtWrHSPKsS/ALB9nBBu
	AdkSVhr6pupFZNLXVT4by8mzuGMakh6UUlFzHN6b5JgjEF1/Bz6mYs6ngccoqiRr
	ukhjnWdhYYe55K81hNTM46Y2Dxu1WWRlLX76lwJvHq7QJsNs2SOn1Aq0IpgqSlJx
	VuEPMicmCfAHAVeRPjDt1qKa03PANfj+k9f+/NVYXGyywWCx/hpNwTQ+X0KlK8sw
	FDAFpMtyfoayjO/dundAag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6sssbq9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:18:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666EEYVi036962;
	Mon, 6 Jul 2026 14:18:05 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmc5xqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 14:18:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSjcgIg760UGPDEe8yuWKgAty1kBRWmkH6GAUOstKmiAAuhQLSkz1RyhgtfauxY9JoPu3QEPxTkJ00f1YIJEF5s8GsYAQyPlo86Ar+Rgf0ZnSwNooFxIXh+N/1fp6O9jY+cw4ysash89oRTRyEJZ4yyxbKE0r0YU8yWSFequS27WGx6AEetlxRrZo2bqS4Jn5JpgX/Pv5pq6y+hxmt7wIHPw3djKknRn9QF9rb4sWebarUX5sqKg6Ou8VlllPGXtP/Zm5ORPKasSpg1vaNLtAVCjnYcloHaBciLh98Ozuf0hVs661Jz0O0tuCh57r7sbTh5nGfeWheHZkg87jBeJBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykKXkBcntuOVtH5B1SizyX5gRCbTyp0D8RFC7lAIMSw=;
 b=sfKU/JvhSFCKeVewBkgmBIrlvzovrX3d4LH3IyiGhJVcFH04lqgLqPzErlgNLfi/EvDDQ8zOm2d7rhRgvvcSu0KkppZbTgHwXHtzTK5ktTXnFqkUCUexmNyfExG2VDovyyfuJwNDuDxVRiVmcwAZuinbwPSZv8K8PWQDVAv4wT2bd5/Djbd7HM4hrsBRg1CEQuXSNwmOf7IFSGZ8iHPB65EGKlkHb7hVs1FAqGCh/EekrSr7jOnJd3k+fpbmvf2QZx0tJH340Eo8a3Vwfb8TzyJBVhsekhOrfsXRj9cQR+rR92HjhD7tQ7GnsOJTQSwhoVHdjIdV+T4XDalhODa6DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykKXkBcntuOVtH5B1SizyX5gRCbTyp0D8RFC7lAIMSw=;
 b=vNBpe6YU+Wmns3yHRJePUW4tZREiTabQGIiEe8GqiVBCnZgHYIC7qD2Xhv0X7Tkz85aN4d4W1m2+PXhmAK9vkEmiPGRVpOc3f97KfeSXvsdv3Do/6I7+U3rqeNpyWBGRcxr3OMgwv8rieLf7JLNZs+warc/xYVbmGl0KDwGz8jQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA3PR10MB8760.namprd10.prod.outlook.com (2603:10b6:208:581::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 14:16:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 14:16:58 +0000
Message-ID: <f5f8ab29-7e83-4144-a1d1-3b83bae8b5e2@oracle.com>
Date: Mon, 6 Jul 2026 15:16:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] libmultipath: Add support for block device IOCTL
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-12-john.g.garry@oracle.com>
 <20260703105659.31FE71F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703105659.31FE71F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA3PR10MB8760:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d0b0cd-3968-44ef-0ec3-08dedb693d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|18002099003|56012099006|4143699003|5023799004|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	P5m+ASf8jeVBmzBMqViZtx1eeelfNYuX8/Qx/qOj8irlaH1um+nRb+21AClSxK1EOt2fdk3YggMioPnr8i6lIgkSHCX/HDB8UofVI018UotCusoGXQmUqLdgMGKTZIHWVl6cW2igPWccto+xjrYbEwobd7qa27BLlUtk97ja1ntvY0jL8k4CAG0MEphBNzzPs26Ldf6SPG5YzbfH4/A2G+bSwfkGZjWphVYRDD3sgMmPJxQ/Ut6JDkUzHg0SETWvDFKIYoNPEFAe4oKHjthRa1kkH7Mwi+BPJoFOa/nQ0L/lT5K/NHXCwxR4nfQhe+vQQj2S1e+Aq0+OHSf17KDdQtB4VkHJCXqjUJQjbssCxLPQrQuooFgGEyaGnKSzvMHPUWlVTSSKQxp54oUyKF7UUKPelfZjGDxzL6CkM0hs8NfvXH30oXa0HzCNUfMV8YIZj00p0YtJFB8pIBbE6nCDQh7S95Hhd4BpB2HW/nK3PopyZCW8iX9l1AgmUwlvHe6yxTRAY8FmPmul/vWidpQDWvwa3VnMoAMQ+vf07maMhojwHw/w8UUCzjoh9ABiHItaZ6jy2PGgo2UcOM3kdSzltpAAI60z00CaIzqn0PqkFvZd8JJ9e1Ebs/rwJwOazuiw3H9Kg34IA0EnUXm08qLGw4SawzFzMm9JAbSXkaeeBxg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(18002099003)(56012099006)(4143699003)(5023799004)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWFRUXJqdmppeWVCNjNZeEEvem5HeHNvbFdKWjN5ZWM4ZFZXSG9yOXVaR0c1?=
 =?utf-8?B?TEJBcUZuLy8xSE91ZExyL09zVzQ5aTZJa1hyc09BdlpVL0dPNDd2bklmbXhJ?=
 =?utf-8?B?a0lqOTJ2d25pa053TEpuN3JOdWhycEJaYVBHekcvWkdOTUIwRElTTTR5SmM4?=
 =?utf-8?B?bXN0c1VaOGpVb3BxeUNkbTRkVmJ3Q0k2QTNteHlIcVBxTWZicHloa1JWSFlS?=
 =?utf-8?B?RGJnbUI4Q2tYc3BQdE1OYjAwNW9meloyVDM3MFJ1S24yK3J0U2RLTUhoN2hs?=
 =?utf-8?B?V0hYQ0crVzFGcVpLSW5DSlhEeVdvdnpFUFJadzJqMUFHRDBpUmREWVBqVFNq?=
 =?utf-8?B?ek40b0EwRE1JdFN1NzhxMnlZdlQxOElpZElhWFdJblBQSk9zQVpRQzBVVEY4?=
 =?utf-8?B?WmVXYzlVMnBoUU1iL1ZQRloydlJsbEp5WFAwTmJNS1VTaktNMGJCUk9oUVU2?=
 =?utf-8?B?VXlIdVZzY2tyenpnM3U5bnphaHpCREcvTks5VTdFTlpFQXEraXM4NFQzRXh0?=
 =?utf-8?B?MndUZktldStwb0RlSFlYcHZEdExmWTZlNHVXRndGTkNDc2VvbWZBY2I4OFlx?=
 =?utf-8?B?eG1WV1FnUVNqZE1rbjUvNUVBVXRycUE2VHdxYWkyTzQzMGZTYW15VndCRUE2?=
 =?utf-8?B?eTJpWS9qdjg3M0RGUlMvZ2NKN0tTSTZsbWQ2QTFIVTFUbitiMzcrZHlmM25m?=
 =?utf-8?B?VThzZzk5YmQrWDE3VVdUQWRZMjF2SmllZ21PRHV1bGF0ZGQ0MGh4dWYvblZw?=
 =?utf-8?B?bXFMVHo5V3NobGlIWGFxTFdMQmxjVWoyQ1doazZEbFA4Y2pSakdpWTVSTlBT?=
 =?utf-8?B?d2dFeG9yL0p3bGh3b29zU3JHeXRmbWNOOUtNQTg3YlJBSzBHUlpOdWNKOXVF?=
 =?utf-8?B?R1I2ZVBNYy8vQVkwMGI1ZUUvc3VQVHNnZU1UaVR2YVNwOEJiUXlMWllmZFN4?=
 =?utf-8?B?WnE0Vlh1aDFTQ3RnOFkvaWZVbzFCb3F2SDFJelVOWGlFa1hlU0ttbWk3cnB1?=
 =?utf-8?B?Y1k5azZkSVVOUVhKY2ZKUERrZVB4dFJ6OFNUc3lxaFBBRVl2MU1mK0c1aWty?=
 =?utf-8?B?Wkl1RDhXL2pXaXdIaEZsR3lDYUhkSnltWDZ1MzdyNGIrK08wdlhteGlrYVJM?=
 =?utf-8?B?SkVkSVJNald6eUtlcnljNnN6YXVIQzBpRVZSdDhOUGcxS2l3RlVKVTEzdDdC?=
 =?utf-8?B?akR4S3JGV1V6cm9UWWExcDc2R0NBK0sxSmtxTlM4WkR0TXlNK1FCb1o2Y3lx?=
 =?utf-8?B?Zi93QXd5RzlkN21HdVV4Y3NEVUxzQ2dxazRRZldQV3pTdTNES0RzanYzU25V?=
 =?utf-8?B?MlNtN3gyay91OGIyTFhOSUdpOE5QUjdQWGhIdjRwOFRBc0U2Q1FETXdYZFNR?=
 =?utf-8?B?US90Qk1ZMmNSRVI0azU0NjZmOGxHUTI5M0d3U1NuMG5GRzNVQXVRMmFBWllG?=
 =?utf-8?B?eFlKVVJYUG1CYkR3SE9IcDl3YnpDS0hUem1GQzFWSnhnRHM4OFdkOCtGZWlJ?=
 =?utf-8?B?N3hkY0RucGZXTjZhaFRQWkZMb21NSXBCZUhHZlBVK1ZocmJiUVYvR3ZDYzM5?=
 =?utf-8?B?cmc2MlNZNi93VGcvTmhvdnpCeVZIdnRyLzd3MndmZmVxOVkvVkJ2bGZqMXZ0?=
 =?utf-8?B?RmdXL29EQ0NyVjNwdXh4SVZaZDAzS1hHRXRLaHl5akVxRlVUZnk5Rm9UK1Vt?=
 =?utf-8?B?Q2J4ZDdIQldHTUdoeFNCcEJPRzVwcjBGNFkxMi81aG4rUXkvWUMweTVoSEFY?=
 =?utf-8?B?YU9tcXhSSmxmWFMxcW45eGsxMWhXN2I4cHQ3dXBRYjZldDRIaVMxa1VCUmlw?=
 =?utf-8?B?T2taeUxnQ0xtK2w0clQzUGdvQmZ0M1l2djVSa1lBSmhwWnhySFJZeFQrbXJv?=
 =?utf-8?B?WXNDRkpUTHhTZk9LNXJQSXN3WlVFeFJQbDNZTThmUVdyT1YwVVVrRTZuUGt0?=
 =?utf-8?B?QThvWWtLVWtwTmhTQjY4bUMvTmVRNVF1L3cweEdyQ2ZYNHVYcHdKVHJKZ0hP?=
 =?utf-8?B?T0JScDNpMU4vSXhEQnUza01NV09WY2FaZHpsMUVLSzZKZk9BWDNNdW9vUWxG?=
 =?utf-8?B?cHoyYmpsYk52TWVsTkhsWHI5MVdwTjNNNTA2cUFNOHVLVjhRaDZrazljY0M4?=
 =?utf-8?B?OUh2NUFFWmxoQkxyUXNMWnN5MVdBZVg1RlVLWW5odFUvQlJ4RTA5NXF2Wno2?=
 =?utf-8?B?TkpaaXVFRWZVa2Nrd0tLUElMQjhJQjZxMXMxaHpya0hac1V3Zk1MNnBkT0lM?=
 =?utf-8?B?UytzS2k4SXpjbk5LNEo2YVdRYXRSWFdRRFM1S1BqWllRZ2QrSHFuRmExL3M2?=
 =?utf-8?B?NllpZlhTTE8xWjFkaE5ySjIzbUVsTmx3VS9GdjJMRlFpUlBNbFRUSkNMdWNr?=
 =?utf-8?Q?k7GUOOKuNDms4fUM=3D?=
X-Exchange-RoutingPolicyChecked:
	EVB3/srGU+OlQF/PLP9gOVfrsgi9Q/wOUFerBCwMHJa6r8DOdL+ksn4Qpt2A+DhJwZ0hDvCGRvIaL5ZDZFn1G1Pq/dnpWLDeWvb5BKdHC/yHVOLrnF9ZRXtTvQJufBCKBR3xuP7e0mPuaN9FgU+/PRq4xhzGDol8zpUeGJrjrEwR0PxtRKYy2J5y6EkPeJlBTPDNBRic3Au70K7vmrg2PIhQ4T6eKlEn/iVWnRIPk7uGuPdF7rn8nnz+PvmWkyP7wluy6HwuQpn3sGMQOsi2cqro0K7ou4xm+o1QUTBm+wW6wBwd2UKbDr9EtVWf4zUHsEHkczW6IRiXtQb36+GegA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HjxOmT7OfPg4qucgKfd39BhEhksFmOQOWGNEI+Bj1NxqshqcIltuoY54lH/JAbqfW1FRLorW6ssmfrvKBII8+yu/58g7Pa6ynEA/UQFvl1cai+K9/JleXi3KXWen11FuQ3q6u13hJrQ7DBZHLWPl+1DBqILhvSuliyER3Bl0GbWJZnjOJ+HGhldNz+CepwpkC9yABiWYVA8zKnyAnkfqryF+snN/BV+28YQSmOP6hXbrxrG3AoZuOvIfurKq4ao9KoPCKwx5/nzys55KLR6t8xj3VwNRJg9b3xNK5/WovNWmdyVy8wKQq+Gy1H8fskYNNckzr2Q/i11aQ76Y0g7YnwxbHG5Uy+44FGS5GhqtOBdKd0Ls7LUkvzZn01eidWwt4joxRihr5soP2L1LdMU95F9HMA5SC9XZhshkV6NHlBXtdN36WDPUrFAEFvvPNpfzUYKZjx5BoeZTu07Rua4L71wYf1ORcqDIeNxNaddkkzMlhFYUKBg4fpwgIJekphqov3netmNGqZkkMe1aHMtJqTW2rd1yMklX72mD7FFC6qiBKrlEXNIeC64YUB8sTsAGxTkiOp9gOyq2bqZajCZEKqrhp9GVnd9cjnUBUyY/uZk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d0b0cd-3968-44ef-0ec3-08dedb693d57
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 14:16:58.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIfcv3F/R3J4aw6jI0HZPBrRYRQVZNOW7mBpKvG5i1GHFdF7fqQYHDq1B+C1BIyE3suDiEAjtwPXX3s37ioQkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607060145
X-Proofpoint-GUID: IFo4VtiV6Q9J3RyOyKR92Fko4mBtvEZc
X-Proofpoint-ORIG-GUID: IFo4VtiV6Q9J3RyOyKR92Fko4mBtvEZc
X-Authority-Analysis: v=2.4 cv=LpuiDHdc c=1 sm=1 tr=0 ts=6a4bb91e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=DEkzb0VX0XfYXz9J8f4A:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0NSBTYWx0ZWRfXyymSVweNNlRa
 gizCM6STMNxCKpIkesgUG32G390UhzxfHkkSRm6LPmdVPQYSQ+FDNvsQMRGQEZ/1jHnc+/m5nGa
 dkp3IxJmO4WDnCe8YAsh9K2QgLxibGGH3eSbzkEzyjW3z/p7vpl9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0NSBTYWx0ZWRfX54D5IYt1dVgi
 9fyxjwskyz31mjxtNHfB0aW2qNO0hH8afy8moLlzeOM5h860TCKecztSPx9NTEdt14iTOCQhOll
 z6f03mSHNorbWPsimKtxvojCEaTlJtbOLmVhRMpjUl8XXuTfsJ4iQm1dAaf6JT4YGPrx6QIMj1w
 Bxqm59zIB7nRlMVo2IqsvuO6CYyOhl2wRB2jBYNyAWdAi/m8hsIvAuDZRu4sO39RMMeGIl/1TNi
 inoQ3Qwjy46N2XIcrPMqUatUdsq+NvRQH0lYzrysIkufpjydZpoiVu0BDCQj2RecfSO+8QHPI82
 dCCvAS4CfZ/wHpMjrVrgWHLiDTiI4Pdocxihsc+kHQ4tplN5b3uWFswonF7HrRi6SWk8peJp+8W
 us2JOIir/nTA1g0bDxUgKLPLqgzvHkF9l5bBNV6ji/gjVevoIiDMuEekHU8l78lXicL5oAgDb56
 A0z43Q+TPTTEIlQkkJA==

On 03/07/2026 11:56, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Unconditional dereference of optional `fops->ioctl` leads to NULL pointer dereference.
> - [High] Bypass of the underlying block device's custom `.compat_ioctl` handler.
> --
> 
> commit 3f49637890144f68bc3af4119c61a0b330200c0e
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add support for block device IOCTL
> 
> Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
> handler calls into the mpath_device bdev fops handler. Like what is done
> for cdev IOCTL handler, use .ioctl_begin and .ioctl_finish methods.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index d335074eb5bcd..4e4b347875500 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -515,6 +515,38 @@ static void mpath_bdev_release(struct gendisk *disk)
>>   	mpath_put_head(mpath_head);
>>   }
>>   
>> +static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
>> +		    unsigned int cmd, unsigned long arg)
>> +{
>> +	struct gendisk *disk = bdev->bd_disk;
>> +	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
>> +	struct mpath_device *mpath_device;
>> +	int srcu_idx, err;
>> +	void *unlocked_ioctl_data = NULL;
>> +
>> +	srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +	mpath_device = mpath_find_path(mpath_head);
>> +	if (!mpath_device) {
>> +		err = -EWOULDBLOCK;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (mpath_head->mpdt->ioctl_begin)
>> +		mpath_head->mpdt->ioctl_begin(mpath_device, cmd,
>> +					&unlocked_ioctl_data);
>> +	if (unlocked_ioctl_data)
>> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	err = mpath_device->disk->fops->ioctl(
>> +			mpath_device->disk->part0, mode, cmd, arg);
> 
> [Severity: High]
> Does this code dereference the underlying device's ioctl function pointer
> without checking if it's NULL?
> 
> If the active path's block device does not implement the optional .ioctl method
> in its block_device_operations, won't this cause a NULL pointer dereference
> when user-space issues an ioctl on the multipath device node?

ok, I can add that check

> 
>> +	if (unlocked_ioctl_data) {
>> +		mpath_head->mpdt->ioctl_finish(unlocked_ioctl_data);
>> +		return err;
>> +	}
>> +out_unlock:
>> +	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	return err;
>> +}
>> +
> 
> [ ... ]
> 
>> @@ -701,6 +733,8 @@ const struct block_device_operations mpath_ops = {
>>   	.open		= mpath_bdev_open,
>>   	.release	= mpath_bdev_release,
>>   	.submit_bio	= mpath_bdev_submit_bio,
>> +	.ioctl		= mpath_bdev_ioctl,
>> +	.compat_ioctl	= blkdev_compat_ptr_ioctl,
> 
> [Severity: High]
> Does using the generic blkdev_compat_ptr_ioctl wrapper here bypass the
> underlying block device's custom .compat_ioctl handler?
> 
> If a 32-bit user space task invokes a compat ioctl, the core block layer will
> delegate to this generic wrapper, which routes the call to the native
> mpath_bdev_ioctl().
> 
> That native handler then unconditionally forwards the call to the underlying
> path device's native .ioctl method, entirely skipping the underlying device's
> .compat_ioctl handler.
> 
> Could this lead to 32-bit struct layouts being passed directly into a 64-bit
> native .ioctl handler, potentially causing memory corruption or out-of-bounds
> reads if the underlying driver requires custom struct repacking?

ok, I can fix improve this for the .compat_ioctl handler to call into 
the underlying block device .compat_ioctl handler

> 
>> +	.report_zones	= mpath_bdev_report_zones,
>>   	.pr_ops		= &mpath_pr_ops,
>>   };
> 

