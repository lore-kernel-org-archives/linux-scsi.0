Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209F735F8D1;
	Tue,  7 Apr 2026 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775579699; cv=fail; b=gr/A5N+/IMp59yq9DeCFdpvHPPAJAED/DQDQVxvhCWKoh6F/TYVNWt9GnONVbfpv1bSP2xmn61oh2jkTJ3Ga7+bXx1XTgndkmjlvRMjukQlbfAStOa5NqHGbTP8fyhpBwRI3axHpCzyyizvyuoQhd4T5FvbgScQJBfHsWhsw/Kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775579699; c=relaxed/simple;
	bh=S7HYpx9vHYFYQxMbbl/hFt4F/D8f82RyXUq7CB2NgW4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QlUns3KaZh8akbJ3M+eCbUbazs+3Lla65Aqp/62qKvcoUgRP8I6VBr6ngw87ce4DvZCr6rCdIceuXb85hqY8loprDP19hUh5mWhXX1n69t79yHUqd6I8ZGMG5WrTG3SPYlZPUQdyEY1FKs4xa/eaiNUWDkfOLDu+dsMl8yJmcJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OxoBBngo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gn0HuALS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OxoBBngo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gn0HuALS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637EBJMj172641;
	Tue, 7 Apr 2026 16:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z9wD5v9GntSy0oAAwFQjT/U8aqqRViSvbHuZ/TkQHU4=; b=
	OxoBBngoXsO6o6OCC+FfDG4UFPlLuDI6eC1yJCMNa0EhA4I+mrvMvvjUp4aDWBcW
	px3R/F+w+tpdtxlGTMowvwj+A+16uPbsV6etqMPyTXn5rgZ6Oemc6J//RnE4f5E5
	gE7VSZTK4rOCJ3ypEz0QeLVjcFCbQGrhRfJwPPdtMqqD9hQuzDsWelN3ainMWCtF
	+9zYkwCfY96AMQYj0l8NM4QGE+H4qQ+vgXLsCcxKMSeayq0uOHriHjpCZfFDDrbl
	mJfnl6VWN+xabYUEFfWYxVp/3BFB/Cv1lG7uYt2H4+uYGJwUsD0VhI66IyPunRat
	fGgswNoi9HSCTf1uYSLtfg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqasuxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Apr 2026 16:34:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 637GST6b033421;
	Tue, 7 Apr 2026 16:34:36 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010038.outbound.protection.outlook.com [40.93.198.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmea4kac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Apr 2026 16:34:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEBpQWF6IMxCGP1uKd0cohXiN4WiYWYKSNx3XRFOm8wWP+SdpogRbytD0nlvkDmfyiAWNYejQAZTefPKoOWNRK5NTXwzXuaHDLtA9wFnbTt9mPjTwvx0lSjKag8QAlWsc6Fr0zf3mvMmvvLmhpdh9tG+ix9msmhLc7N7aPSbCvwBASIsyubqsJlHpicngcCGXhxKFpeM0IwHlKUplHp3bXHiKh3KQ7YQMOkwhA2Vy1dr56MNlMM0CmblGJP1lNKZeCI9PzULD324zyjUrHwpsNahL4YRvYVj4pHqUtZKBFTX2Pgi7Td+vemwFa1WOPpcJycS2CcpC94BccOYknUO9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9wD5v9GntSy0oAAwFQjT/U8aqqRViSvbHuZ/TkQHU4=;
 b=RiqUC8wPLmPd8C0xGciWseC8x96gX+KVkedft8ZH9uz5EK8azT/n3oCEcpsl+kEPK9G80XPIsQYHWZuhSbh8RxgOQ5rSF/1Mml9Hng195rtjNaKRXNz0r2FLsFD4DHDL5Kz0gJDAsP7t3cxl9YUi5X0HIMAlh8sxXb/ctwsAn/MdBECEz3z9KlM0OFpX1BuvAEKv5Hq5bkrSzQ7eJ+DWtU4IH00sEo3LYVRd2scIZ03EbCSq93f0sdvqu2oiaUevM15rMWD9yMWjyFBsc9fK/IPIus1pZS7dPn/obCdjblNKXDuSfDSRh8xpbFGw2at0Q+31v/R3aEvUKpfCOZcojA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9wD5v9GntSy0oAAwFQjT/U8aqqRViSvbHuZ/TkQHU4=;
 b=Gn0HuALSKvF9AfD90+JWGBswAYzKm9Y+CFU/ymE0MIzGtwGcL8euEoKT+NGla++wVO+maPLbszwl33+g13Mzi8PQdTKDii7tyAVTe7xK591DRAWKgFFWEvsZ+SDfFDr0CID/mnoKKqBKPuG9sMttfTNTslilMgeDu+vq49orL0Y=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6490.namprd10.prod.outlook.com
 (2603:10b6:930:5e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Tue, 7 Apr
 2026 16:34:31 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Tue, 7 Apr 2026
 16:34:31 +0000
Message-ID: <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com>
Date: Tue, 7 Apr 2026 17:34:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
To: David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org,
        driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>,
        =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
        Jordan Richards <jordanrichards@google.com>,
        Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
        "Lombardi, Maurizio" <mlombard@redhat.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260407153532.6395-1-djeffery@redhat.com>
 <20260407153532.6395-6-djeffery@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260407153532.6395-6-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0511.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6490:EE_
X-MS-Office365-Filtering-Correlation-Id: 99e598b9-b8e7-426d-9d39-08de94c38b38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UKcJSLyHawGwY+kqRgN+ZFReIF/aA2KJ6xBIRU6vjhnhtXO0+N9wIZi9/rQ6pngALD3UNgCZjZg8e/YkKONfR3IfOc6RaoGKN2zs9Z52JH9CVr5O0C7yhFH5uoftndrmuMbCjA0pXHMMFqqBF28+96xsvO1WLxsw5xTEHvCDYpDs+EeKDm9dPauZr8zg+UohLL55vbyycFBtALKDSHUJSKCfBfiAxIv7NslsTNacMw74vTx40Kj8hy9oRLEwSEJcaw3bh7Chac+KmyAh6fIFRISidccmF3mgCTj0EhQFbp9btD5Epz4vXqITreREHlWT4cXbyN+08N3dcf2gXJBsy3if8i+asBd+fSNJsvC4M40X7MeVBaHmkUi3z0VrvScV5MmwaEBnpJigrEusddu6zhfWtFqzOiiZ/CwATHy9X6YG0UD2jeIr/vy+j/1Hrmm5ZJCPnh/X7b3AM8Z2aPX0JiLIDMKJZUwsv2sWdkhaSkl9xg98guYdtwXILF7GE4sVdh/EulfEN0W+6lBPYt7p9EbDE5+++yhZNWwf1I6nzfX8Lpj2fZgd25fXxeztR0IuGQIvAGDSq0tV08eqGAuSbIQ6I9O0hnSdsxUbgRT5ZOsTnw/ydxW4KdMvo+N1EhzGkAxd+scxcomhv4TLP2kLpX5PfgDWTkvsjSA42FBCfpj2G1r8uGC3ll2U28eIhemqcYd+zWyYsl8udw+HFSNQQyHsW5RjoZg3V+wzSopVE/g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDFaL3BETW1CbFNpMmh6RkVlRDBoQTV3VFFJU1hia1gwaVVUcHVXRUk3b0xJ?=
 =?utf-8?B?M1lGUDJiUEYrZXlDaHRkU2RueGRoMWNha3pGMXJsWUJLUGpKTVNjYlFhUmRt?=
 =?utf-8?B?QWZjcWNXOXAwdmFGcWpFc0thR0xLVzkvQVpzTnErNjArNTU0VnlLOE16endC?=
 =?utf-8?B?L0dubFNJY1VwTEdpRXlLdGJvaUVNRmRLUHFnYVpqZE5HeC90cWtIVEVrL28w?=
 =?utf-8?B?MXBIRHNRL2h3WWxjZGpKaTE1ZHR5alF3c3hMcDl3SStYdGpubndwSWwxZ2N3?=
 =?utf-8?B?RzlKVG16TlVHVzhDUDdRUjFCQVZSeFM4bDNpYldPQ2l3b0hmZGtKUjB0WWdm?=
 =?utf-8?B?bG8wUS9FcnZaTkVmVGJrcWxrZFFEbHlFUVJLbHdhdGtkMjBmSFRLc21zdEUw?=
 =?utf-8?B?am5jYTZIYk0vbTFVQWJHeCtNNjJiU0oraUExOUxTUVduU0JoUlpaTGNkSEpp?=
 =?utf-8?B?cWM2UE5Vc1RtN3psUXRVSVBlaGFJck5tc2NzcUJmeDJlUDQzRUJFVEdIV0FR?=
 =?utf-8?B?d3pDajI1WVM4eG5LNEJYTXNhSjQwZWttdEM5WVdKYlFEcDFOOFhUYTdGRG1u?=
 =?utf-8?B?OVYrMlVZOHJmdFJvVFR6M2dxSlVKaUN2ZG5VcytNYWhRd21iSXFOdmxFQll3?=
 =?utf-8?B?dXhMUWdUUDdoaWxlZlVuZHRUOEM2MHZNVTJpMFhIUlpWZ28wQnhRdHFSZVdC?=
 =?utf-8?B?WG1nS1JjY3hpcCt3QktrUEovRWRWOG9Xc1RDR2pDRzZueDBpWlV4ZTlZaHJX?=
 =?utf-8?B?ZERXK2FvdDJteEF0eXFPbjV4ZjhWbGVPbmliSDBpS2xkSVdoeGVCejVnUTh5?=
 =?utf-8?B?Q3E5MTMzcmFHMWJscGUrTEEyMTZjZEFkcCs3K2svbXpnN2QySG9tNHRZb0l4?=
 =?utf-8?B?dTNsMnlhbnVaWExRa3h1NHdnTGVycXNWdTdLdG90ZUh3OEtNRko3RXhncklX?=
 =?utf-8?B?eWhwS3pidHJaeS9LMHpvLzlZOXBFYjNOUjRjL050YkxpdisyeG1pY3JZTGs5?=
 =?utf-8?B?NnA3M2lVVUVqRVdXSnlJcGorck5UaFVPZkUvN1NjazlFbkRBRHpuTGV5UzVT?=
 =?utf-8?B?dHJNOFlSanFiR1RVSG12SitMcEZBbE5URVFQOUp2MW9VZFhWSzBXYUpTS3Qy?=
 =?utf-8?B?SXo1TzdLem43bXBuZXEzK1lGVGZwdWR5ekpITEx3S3J2U1dlRExHRXIwYkZl?=
 =?utf-8?B?Q1lSMldJM0FJM3NleVk4dDA5RFlRMlVTU0N1ckgvV1g2aCs1T2I4cHdCUTJ0?=
 =?utf-8?B?Ly9jcGI3cGVOZ3g3eXBHWVB6MEs1ME5rTDBVL3oxWDhrcUNjdTVPS2pBV3lt?=
 =?utf-8?B?VDVrVWFCYUdRZHIvOXN0NWF6bzMzWk1scENydmRuZWE4RGV5Vkg4aTRKZ1B0?=
 =?utf-8?B?T092Ryt5b3pib2pkZnkrUG1EWDJZMVZ6RWx2aFRhQ2grV2NNM09pTCtXWEpF?=
 =?utf-8?B?VFF3OUZUNWZWMEdKSWFMMU51di9MREViNHRFL0dzOHg0Yk1JNDRSR2NnZUJB?=
 =?utf-8?B?dXJEeXlXVGJDOXpscW0xaVdtU1pMeXYvQzJmZWtIN1ExS25vci9aM3R6NVhM?=
 =?utf-8?B?U0V6QThYNDdraDlZTmVUREhtak05Qnp5R2NtbFQ5K2RHQnh6M21Xck95ZmIy?=
 =?utf-8?B?c2sxeGtmTkQ0M25GZWEwdTQ2R0Q5TEdReWprZVlGeFZtZlJ4RFlOOE1Qa3ho?=
 =?utf-8?B?TG9NZXg5U3BncStrTEU2U3RFeldOYmUyai91YU9HVWhQN0w0K2EvNVF5Y2d4?=
 =?utf-8?B?VE1ZZ3kySWkrV2NMcERjUEhqWmRQcDRKNi9XSngwZkUvN0tIRyswdkxZbFZR?=
 =?utf-8?B?UmI4emI3OUxadnJPMVlJdytFQkM2VjRGR0JDdU42UlE1QlhwRG5tWjZKenEw?=
 =?utf-8?B?TVNwRlZ6eGtiOVZJQ2pSL1plNkZudzNzNjJ2WVpBVU5Bbk1na3JsbDJja1B6?=
 =?utf-8?B?YloxUGg0UkxiZGlobTZTZ2lGaUJZNXcxaDF1WkhwMm5Qc0NqQ1NKejRGYTF1?=
 =?utf-8?B?L0IyU2lvNjU2QlVlcVlwcXBWL25jaGcxN25ycnFwSU1DRWphbWhIRTh2NmU2?=
 =?utf-8?B?TkczczJjRGxaQVhTRWMvQSs5TWNhUXR0NmwzRU9hNkhzbnVCb1JQejA3aG91?=
 =?utf-8?B?QW41OWdHeWFYQmZlcm8vdkVuNUZ2NCtGT0xNdDZsK2VIeHZQN3lZMm5xZnlo?=
 =?utf-8?B?Zm5UZm1lZDBOWXVWbGxQTXl3VDlzVlBCTWhwRFM4RlF0VEhqREd6YVZlN1o1?=
 =?utf-8?B?YnIwQW8vSVMyNzdDcXNzWUt6UXlsdFBweVJOdUdPTSs5NHpZOHU2STQ2T2h0?=
 =?utf-8?B?VGpoblMxVjhSWDVLTm84ZVFDZ3Nzb09LVDBka3BUSlpSYXZ0RXNBdz09?=
X-Exchange-RoutingPolicyChecked:
	clt+MCJuL97RlpdY9DyZa8O5stCG4WjSo0BgZkFJUMWVi6Dv+SujeyAOJ1MnDUQaFGxpCX6fMISmM3GNeN0bI4BO18x1XAW455v48BjkTrZxrI8iBIlK78uPFGg5T8laebdR+VA1XwgA2MkwTNMLjSZZ4a7VOItgVCopnPF9G+1B5i/lqefKtWsyLLaCfX14uIJjsTxBj9SGmbqeoMBbkwXuD+UIHZqme67vfS0Zmpc9440co8tUhM+HE0gQVcE4KyAyH2U2nqM9yg25T0psP7NFVeKf/qjqUHYRfhlGxwTimzm0Ot3a7VZbmcGOown+RRgoaiAUyTaErsi1xMI3GA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZBtExhSuL83GT/I9GHREzk+7diq+rS7+VkCi8Xfuwfr1KtKfBznxwefN30RHzhmxW4Yxjv4pdGsVTQxVvtkEI9MfAgaDms5ieLk0PRbuXAyUAPg+Tg4RTQ7IT5H6XXbNH/x+2zbOxP1sHxpGKwVQRbcH/tJr95FdRzQwDMl+7Da7fDkM+AzzBWqnOTbYMkHE8NsVtS6itNDKkgmiWjBbvhk6dw5uRKsvaLWESPWPpgJBMKGhSqHjR5XR2UL4uCIFWaF1RGqtb5YfMLOkLcuzlSAFW09LoHUBAcb532gkocf6DBfsIh3p0W3foxL6KD0JJ5MaoHhbPS6NyAqNKJCkaIz1MOKepkxpzLhUtbWlsxRVhd9NMGp9nc6h8deMf6F5eBflb4aSTC4tzUyofBn6MWb/bc8wqPlKiRJQDbe4BJJ3CN3e4KePLOQcbuD8GFU4ZrJ/u389U9S9IfeJEnrqe9l9jgRf3cGwhws6Yk7Rse4xoZZ12WaSJLBKK4fSeuUsPJQIjMpzHwxScn7xYtQacdPP0cjE6iWlS6kRosLfQzXq8JfX+aMc6bibc/lfD699Fd17kylWOrmKt1co23y7PrRooIPgrGActlbM+XWyhjg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e598b9-b8e7-426d-9d39-08de94c38b38
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 16:34:31.1038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UX7pOP4TvFwdfCsS2osBCvzhOS+hFUyg+Q02A5g4O+bF58gsH8kBvPvq6bMg8jR4RfEnQ3R/WRNHcHHMsvT3XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6490
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_03,2026-04-07_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604070149
X-Proofpoint-ORIG-GUID: 4xiUFcWrLmW0PfzgDz0-j2L6nMuPc9iR
X-Proofpoint-GUID: 4xiUFcWrLmW0PfzgDz0-j2L6nMuPc9iR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDE0OSBTYWx0ZWRfX8KQs6piqxKec
 xkAQ8aihGGYMChujdkOG+qDQ08tmmpkhyqXJ20NrUqMVjkJXULBueG8nGomzxuXSDh6o/+UxH0o
 wBVPII2otE8TQmKqu5EYiJdgYn+Koa+DAN5CJNg1vUNqqxzHPm9LezvSmm8KZdSVUqGCZIbl+mw
 aIVb4+ec6ZyQukH7UCZaLMOsVMG5cqcix1K8qD5nTebn1WL7YyDlUgKZK7ISLoP1O6IncliWBmK
 YnXzIaOUiQO46kUynlASLvfkFRKsJQdjUE1YFIryaG7NCfHLwkhRVqQRTJBL+xlJKiF9YC6jJBL
 ipIEHDCUt0tfwU+5SmuZYmgIO862YAzg34/WS703nDBwlOO72uy6NGxmrJ7Tt4MJCMiw4H5aen3
 jITe7nVEkeeHFffoB3tEOLvebKzjw0qmyYYclSR0+GA3r3Jy+JLSpTULpZwbc256LNOpEzkFjqE
 W/9vN+eftsx1dxsR3xl/TgPZ5hKnE6VlrqnYsgQQ=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d5321d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=PrIx1TivJyALbbpQ1rAA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12292


>   }
> @@ -1396,6 +1397,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   	transport_configure_device(&starget->dev);
>   
>   	device_enable_async_suspend(&sdev->sdev_gendev);
> +	device_enable_async_shutdown(&sdev->sdev_gendev);

We call device_enable_async_shutdown(&sdev->sdev_gendev) here and 
scsi_sysfs_device_initialize() - any reason for that?

>   	scsi_autopm_get_target(starget);
>   	pm_runtime_set_active(&sdev->sdev_gendev);
>   	if (!sdev->rpm_autosuspend)
> @@ -1415,6 +1417,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   	}
>   
>   	device_enable_async_suspend(&sdev->sdev_dev);
> +	device_enable_async_shutdown(&sdev->sdev_dev);
>   	error = device_add(&sdev->sdev_dev);
>   	if (error) {
>   		sdev_printk(KERN_INFO, sdev,
> @@ -1670,6 +1673,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>   	sdev->sdev_gendev.bus = &scsi_bus_type;
>   	sdev->sdev_gendev.type = &scsi_dev_type;
>   	scsi_enable_async_suspend(&sdev->sdev_gendev);
> +	device_enable_async_shutdown(&sdev->sdev_gendev);
>   	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
>   		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
>   	sdev->sdev_gendev.groups = hostt->sdev_groups;

