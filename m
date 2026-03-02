Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7129D421882;
	Mon,  2 Mar 2026 15:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466821; cv=fail; b=CwxF5QOm4FzUqybsRpQQe1frn9aP+kPs4KzGsbZ1n4GgREurfXIIwXy8HicMR5X898OxM/faPb+X78pGX4HAH1JKltafcPT0x8UblunKnIv/VbhgUKOMg/lj8C21GXK8tJfUnJefidv/LehGDwzFPg1mrBPBr1USELGkHL4HGjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466821; c=relaxed/simple;
	bh=jTmBI32fpatx9cdMWZ+S1YPHrjj+LmRBGaBEZTwhGxg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PaOgSeGNxLQa14E6csY0hktV8rz7yfDSnsqOP0XE7oEtM0uZ87iAEXFkwIbPgwgZRNiDN1GC/WHOkLCLEueHfnGewYP9HcTEhNXuWpivnpoLEqQAOkNR/dvlus0itae63T+lSe1po5d95V3ppm+PfQLYvUDN+Der8RDKU/vmV7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p5fdSatf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GP/3Pwq7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p5fdSatf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GP/3Pwq7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622EU2FF3617929;
	Mon, 2 Mar 2026 15:53:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7JgdCavw6YRWBSa9TSdR/3dt6kku76B78sf59DtokH0=; b=
	p5fdSatfzkZBpKg6dfer8v1c/KhzBuoh9xIqklQYmoIsxM6ebWIHQg97yyj/zWX9
	sWWQBkIvfAJ9ygjk3qq0OWJIwFruhysEXiVPZMXRQtHmiP9BLXhh6tAVv6QRtzNn
	aTAXgbTOLZl1qCSZLWrq2d4CAH0dDjpSjGQo1c7t43okLRSBgIqr8bR3tCCSKK3C
	cgFBB3SNAankB2zN04RNfyT55qfJWR0qrPgHvR8JbF2x9FVood3nFAlWc0k7zjQk
	7Bz1IGH/eKOPbw/joD7cPQ28DAoQ6b6N7ylpRDU0M9ZZoSkHs4GCIsFbFiccgHW+
	Petca8PT13koPhuXhCVliQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cncc8r5nh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:53:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622FNTOq037723;
	Mon, 2 Mar 2026 15:53:00 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdcuc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:52:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0ygRsZb8hpL0n/IOOfViyvM61XcotNKSDHqqhc7kG5LtRi/oVv7KwN7JBPjDPJn5qiq7WrAJ8IPzGsaRjJwGQ9bWH+lShc/f2oADqTXsE3DBm6eynlDTxz8NGR1JYzzQu00EhT05EZVgfF5tDAZhDfG7jdozKpoDV8NGAt+gyelqgzthMPNaV1lelO6RgMlfVvkXxfK0LLy5zD+UolzPOBgDjyTtAxFhKS9blyxLpbVkVHkNzjeQVi4FECGohh9Xm26oHX6j5cCi/20Ijo9m1vrGgC3CDv4pIbsbXAHGtyINA0Z+rZbQMZCH2Z8s4yWlqEq/luB3Z8HS0yLfQYxuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JgdCavw6YRWBSa9TSdR/3dt6kku76B78sf59DtokH0=;
 b=pMoyO8P0IWATLtnJozakEcJJfvfn0udgXgUZmtjM2s+omXkwHdbUZbVGAi7TkH9vKBwnVToLeUw0bylf4e52Ikf6OPmIWTwihqrtkbrsapqcugemCylulTMeFvcBiEa+qhz6J8fZutR0oQ63poolJt/wtt/tpVal4JzgV5cdFxrDDxTI8HPF9+J/Lo7jtoGOW2tIXgqqlxIwD4OKnlCJPXfCnMzDBNT33WLZmxFkc4t/ERsxz4G9GOzZ60Rh+sl2fukWEKfGNq4EZ9MPMnxzChnKCIyRsZJ91q84f3RUYOnACFO1IyN1RkOpdqcwqBYy7iYplEMLFb+AFTtAqtN8Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JgdCavw6YRWBSa9TSdR/3dt6kku76B78sf59DtokH0=;
 b=GP/3Pwq7DdhhGSgP1H0NWXWrP+/puY0210VvzK3bKHiHsJr1vcSA52Hmq4hk+BAAMSVM7uG/xgnDmV2wt0Ka/fu369GYyXZ27FuiVStZBlpH1uXUAmSfleKGX6P0WB7qYusPV1SqXZUn3kDAGZmnbJ2LJpTGvBSVetfbyJMFx0M=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DM3PPF0AF60B9AF.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c08) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Mon, 2 Mar
 2026 15:52:53 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:52:52 +0000
Message-ID: <20a7c554-b641-48d0-9bdd-fa79d74d3a58@oracle.com>
Date: Mon, 2 Mar 2026 15:52:48 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] libmultipath: Add bio handling
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-5-john.g.garry@oracle.com>
 <a6ffe0f5-7ec3-423c-8702-cf4248fdc168@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a6ffe0f5-7ec3-423c-8702-cf4248fdc168@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0484.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::21) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DM3PPF0AF60B9AF:EE_
X-MS-Office365-Filtering-Correlation-Id: 297648e2-e2fc-416d-be48-08de7873c350
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	OWbpAkBTCVibDnO5XhJy9RDv1RvjHN0AJzAOKE7+jVZcodQmUUTAeIZLoVxSiUVhpvlqSJoreG7YBT5SqJFtH5GV0zwoWgvifKAA6InC02iBXscTVyPYmXteDOPBEjfaxPgrI1SykQ2XYZRnBt4qV5oo6aV79j4v0olyjYAezubpLkeRdaMh82Q32lTSV738bXmeXfPyRX5BHu13IzV/zIxJ8W3Hb3NNyqfsXSFbINA2bUPiH01XBAELHUP85FS/ItDLKwH7XZ3ykO2VxL0kSqeGBKpqaU2+i5auotmC9tsSv9HXWIHfOEKNoXcFSfEOa4v1OL/XuCBtTX2r6jqzaDVsdp4n/foZJjc4Bth/kt3L2yfjWHG/fCOpgKMci+lYCMR5ungS/vhFH/6EW+1ek2Mgt4eWsv9t81NLu5uYoq8OtV24gViwq7bkJXRFpm63sLfO8FPybr1d4Qu4CecfVmohF38fneSlGpYurLIfX/XpaoUxRGPu8l/aS8h4OU3DIIDe/OxOSEqVLUr6luuVSD8z3Te8c7oZqAu4NgxxpsA/6JGXDPGQA/OkVMvQZ99h7NW590qy4ImUmLRdqZJffj5OI2C/ZQW+9otH/tngdBeDOcgR4hpWglOZnZtWFi0HEPyVogRnKMN7tS7BdTbt7hPM4706eTib9M41yJhBrNBCCx6tClvncyBVqR8T1M/S+t5ZNlmL/pg2u3t2SeT8cvYSqV6QZ3K1qHp2dEU5+F0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHFKM3E4VUJRTGNyM25kN0kvSGMydmdOSFlHMC9RQW4zcFVmajRRd3Znblkx?=
 =?utf-8?B?RzY3anQzQ2pmYy9NSkhIMXRnbWRzdWVxLzNUUHNEN1N5SnovdzYrZzQwYXBP?=
 =?utf-8?B?NjF3Nm9hcjNHdEsrVlo0dW1YdWRJb1dXdy9QUFpiVWNIblo2a2dPTUEzdXE5?=
 =?utf-8?B?cVJYSlAwQUFNYzdZTlNTU0ZHQVJTeE51bjgrQXJidE9Oelh1aW5WQWd1ZDJV?=
 =?utf-8?B?anphdFpIZE5HMGpvZnAxbm4wY1ZNUE1IOUJMZnkrY1RuUFkzSFBKNS9uSi91?=
 =?utf-8?B?RVNVT1VWaXVSUzJlWEM0WXBvSDcvYWRLTnFLM3d3RUF2ZEdDalpzeEpoVUNC?=
 =?utf-8?B?dFpLTWwxVUZJNTJvQUhTNWJ0VElXV3Y3MUIyVUpvRUNVU1pEWEJ1YVZoSE1P?=
 =?utf-8?B?bkhxeWpPdDF2U1o0Y3ltT1R2SlgwLzRReVlBV1JKRVNCRWdzdld0djMwckxv?=
 =?utf-8?B?NHJ2YVpXcXlUOCtEZCtYUmE4ZmpKTmcySGhjcThlRHFCODJ4KzR2T3lzRHRQ?=
 =?utf-8?B?cUVHT0lVUnRvdGlQeDFGODJoa3lCdXZDaVNvci9KSTV0VDJFeHdTejRrb0dq?=
 =?utf-8?B?RTZiSDNPNlRKZVhlS0dNc3lpM21SalRQUzA1MzcxcERYVWdnRmdORllIQjN3?=
 =?utf-8?B?WVcwcWJrL21OM0xFWmJRWEZpVXE3cTVCVkVXUngrSnJOaUZKV09kOHB5Y3hS?=
 =?utf-8?B?S0VVWHFtamZrTUlHSHlYcmxJQWQ2a2E0RUhFd245aWZpY1dhalpYNEJzbCs0?=
 =?utf-8?B?bkdkbDA5V2EvTmV2STdINWNLSkNCQmlJSVJHWjVCVHM2cG5RUGNnUVZSN1ky?=
 =?utf-8?B?QmptUlI4T0N2RklHUDN0NjIzRUl0N3NyWFF2OVJRSmZGWGNGTHZmcFVWZXJX?=
 =?utf-8?B?QmdTd0RucUFQZ25NSzRRTVUva2tHbGY5L2o5QTZrd213NkJmNDRlZUZKMU1K?=
 =?utf-8?B?RXJibS9kY0pyWTZXZDVYem8zU1lodFEraERHaFJLbHVkQ2xxSTlOeHF4aVJj?=
 =?utf-8?B?UzdHVytNaU9nMGwzdEhRSFNuQ3VuRTFxR3U2Wm8rL29YUi9GTWN2WXA2NUcy?=
 =?utf-8?B?UHNzV3NwRDlhemZHcUJIMUoyT0MyY3NNVUxnYTlBdmtaQXR3aUl5dCsrUDl2?=
 =?utf-8?B?MkRvdHg2QzVzanlPSnFPTHd5cEJueEdySkwzblpxWjNSQm14SENuT3NuWEUy?=
 =?utf-8?B?TFl6RXh2M2xYSGVZeXZhcHBxSWphNEtGTlBwWjFkMzVuUDdjenQzMC9xb2lS?=
 =?utf-8?B?aFFVOG1vWGpKZXh5dThRVnJ5bG5VMnI3TkEwWU5pSFBTUUZsS0hubUJQNVFQ?=
 =?utf-8?B?SllZdWFEWVBMWlBUMG1ncmpnMHdrdGx3eDYzV2tOcDdNM1FjeFBhZmVrb2hl?=
 =?utf-8?B?WUNHUkRqazhsaHdKcjdLeTJ0Q0RIZWFjTjZpV3pzYlpMblpJRE1aTGhiVFkw?=
 =?utf-8?B?cUFiaGNZTlZnSUFXb2U0Nmx3NEVyVGsyMmFjR2d1TERVWUpFUTlyejVuMjhO?=
 =?utf-8?B?OXAvL2VoNkRoS1dmTGZ0UmhzcGdYaFVJZkZxMGo2ZmNTd2xpZHlucUdiSlNS?=
 =?utf-8?B?bnJtL243MzE3L2hySEo3QjkxaW5OM2drUGsvVTRWUVZUUHNSL3NlcDJkdFhv?=
 =?utf-8?B?bGFZd3RMNVdVY3JzN0VtSjJRZ2pESzVzOW1iajh3M0NMRzF3TVNkZ3ZldWhB?=
 =?utf-8?B?dWdOZzQ4akk4YUkrUkkwWXpPUWJiRXBUdTlUZGdnYTNNblFRM21FVE1Xc2gx?=
 =?utf-8?B?UDlmdzlwUUNvWnpLc2tUM2prMVE1OWhCOVZ3aE13K1NISC84YWgrK1FKWUE5?=
 =?utf-8?B?bElEY1E4MFlOQ212Kys5WmI3OUlGY2V3RGl0MndkSHc3TnRTdjlwZisrNlZT?=
 =?utf-8?B?Vm5lQ2NldjV1WExIY1NWdkdqcDJWeTFzZ1M4cHgwaHgzRTZwSDhsajA0eURr?=
 =?utf-8?B?alRid0pKMjlMQjlQV1F6aFBBVW5HQWVERzdmcmJESDR0SzJOdDZYY3lRejUw?=
 =?utf-8?B?UXhoRXRqV0puL0JDWDR5SmIwQUoyVjA4eDMzVVBNNVhzcFBSNmJyQ1hXbXdL?=
 =?utf-8?B?KzdZQmhxMG5zeVpPZkVlbm1SNmJ2R0FESjhGSnVuOUlCZzlXSmRMdFYvY3JU?=
 =?utf-8?B?bWM3T0JnUnNnMmtZVWh6WEtQVEltYjBEclZvalA4YXBTZHNhZDNLOFJ4VXQ4?=
 =?utf-8?B?VlBVYlVtdFhiUTdSOTVrbkhRZ0FqblRGMHVKV2NFOVdHZzlJYTRneE1pVnZB?=
 =?utf-8?B?NlE1WWxwQWMvakNDaHkzZG5PdThYK1JEYUE0UURVRC9sMmhvbGVUelRjWEtj?=
 =?utf-8?B?WkRqZk1jeUJEZElobmRFa0IwZTFSVlZrZEFQa29HQksvNWxmcWNSajN0bytx?=
 =?utf-8?Q?IcuUofduMGoP83oo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RiqAArsMC07cmz7sphhAzkXyq90OdADJ2y85rE5cbPOFTh+CHULe3ee5QcI0c92pMTUGS72X7klsjCP751c/Ye+o0hPyultyodVOVcdxEOpS3RVaLBU6u4WrLk8WHBmT3t++YjJ6cwDaaayRuk3+HthDNkw49saDZreBXUplIOSDgmxq3jKz96/84Xj63zGdTdLxdA8ouSIb0Tx2WqRzNQki/b1Xdyy2kCvB1ZuNeDoUv0O1NiPWKQZXMJO8ySEVAoLxiBkZmFPP0LjU/kafxlQiGcY/xvIsNVLN8d3N0Gjy0nPOTM8GGjeAcZiU23L0Atdy6id2uBvf9soBzaXTXvdTeJoQ6MSpn8N+0t34re+lkMI+rJyMphz5siy8dWWIF/S6ZhJ0havzx/VUeTWG0Fg/iZGH13yftpwbgT4XgcF3uJnEYGpDgEbjaR0KPzNUINT8LQh07fVmCtp2qWPewZzfKOGfir0x++To8JjHwLS9nKjtlKl+eiDMzeDx7NQpzje1GxpE7XhPIQW3ArOb1FjMQLh8XloUVOiMr5+xoADFd6MxBoEp8Pl89y0Ko+A/vP8OWT0wfUdLgwGIUSrI8Jy7pme669tjWWvJNPmosvs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297648e2-e2fc-416d-be48-08de7873c350
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:52:52.7749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PYdfJWOz5PoSLUi/JWwjf/oB3DjT85Ev1zQavEB/bLZ0eU6y06girZ2/UfBRuqbcMGmFMUZTLANR7ZvUisYgzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF0AF60B9AF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020133
X-Authority-Analysis: v=2.4 cv=HL3O14tv c=1 sm=1 tr=0 ts=69a5b25c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=CphLxdkZq8xbBxM04WsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13810
X-Proofpoint-GUID: kO_geMxj1S1KT0W5dUZHmL43TnSgYt_i
X-Proofpoint-ORIG-GUID: kO_geMxj1S1KT0W5dUZHmL43TnSgYt_i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX2rDR3iWKOM3C
 nbFYiOGdsMOrvNqfTlE4uwayD4aTkyLfWOIYGirobLSn9EhpUTCNnx/VwLVviRSr3L3kTTIKALA
 MP91EdY/rKaYbwu3a+UefmwqbKCEaXSDTJmN/Po20emjO8r4oH7HU6d3JYVx2u2WjQawkFKZLDU
 UovNYsZDb0UxDLRj6lqtGdq66cRS55aWSkPuoWSkLjlD21shQc3lYDc5KPC1klpS8QURHw0a6dL
 eNnjF0QI47v1hxXVp0Fpa9ZSXyMjoglo7OPlZd3Y4wDnq4aJlJLrNAKdgoVujt8SKOkLBFqxek8
 qlI0PD9IHy2c4CsHvF7M5AyXNZTSlah3BykduciI6eRsqIp33XvgwdvACKI59FVcW/OqPOkdBhM
 S7iORhIwtl2SAtTsWqZgPNhg83e4xmvD0Lw8QG6Y63tDbxIqb2BUV3EkwDVR/o/4eGEf+deHPvB
 glscOmEFvxlHL2duPuz6W+nGDpCWj1sfI+FcCdJo=

On 02/03/2026 12:39, Nilay Shroff wrote:
>> static struct mpath_device *mpath_find_path(struct mpath_head 
>> *mpath_head)
>>   {
>>       enum mpath_iopolicy_e iopolicy =
>> @@ -243,6 +243,66 @@ static struct mpath_device 
>> *mpath_find_path(struct mpath_head *mpath_head)
>>       }
>>   }
>> +static bool mpath_available_path(struct mpath_head *mpath_head)
>> +{
>> +    struct mpath_device *mpath_device;
>> +
>> +    if (!test_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags))
>> +        return false;
>> +
>> +    list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, 
>> siblings,
>> +                 srcu_read_lock_held(&mpath_head->srcu)) {
>> +        bool available = false;
>> +
>> +        if (!mpath_head->mpdt->available_path(mpath_device,
>> +                &available))
>> +            continue;
>> +        if (available)
>> +            return true;
>> +    }
>> +
>> +    return false;
>> +}
> 
> IMO, we may further simplify the callback ->available_path() to return 
> true or false instead of passing the result in a separate @available 
> argument.

I have to admit that I am not keen on this abstraction at all, as it is 
purely generated to fit the current code.

Anyway, from checking mainline nvme_available_path(), we skip checking 
the ctrl state if the ctrl failfast flag is set (which means 
mpath_head->mpdt->available_path returns false). But I suppose the 
callback could check both the ctrl flags and state (and just return a 
single boolean), like:

if (failfast flag set)
	return false;
if (ctrl live, resetting, connecting)
	return true;
return false;

Thanks,
John
