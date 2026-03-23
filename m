Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B529A1;
	Mon, 23 Mar 2026 12:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774270364; cv=fail; b=i5yePA5TGBCvSvnPC1Mf0M/20ObaLc5S11nCPEWPP4s/FA/CbOo1l2J5mRgWiah9p0xdx5Xl4ItgA9kweqCmjM/OUc2+4yFF6qXBJ5uCojHLgp2GEATB5fali4F9+Lp0SQxD6HocHfsDlps5H4Px0rNTGzC2lB/jZdLnGK9QAic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774270364; c=relaxed/simple;
	bh=C4PlEjYbisyXBRdkzpdk3+k2OUx1WRzYyniQlqKBsz8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=suah7bs+svaK1CDkjpMVn+08pwS5BZnMT48H0mevx8fIBes5xod8xpAsruavplETm9ElSqFtLlwHB+spulWPHmDaL4jxiB95eoaYpZd5exKpyYqwZF8SqeeLtHrKxwT0+ltJRKGtJW4mTNxQwus1qhQqdWpv1C1Gmjf9cc2MZ8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U3l5KNMr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YPXT/wML; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U3l5KNMr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YPXT/wML"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N0F2hB1085304;
	Mon, 23 Mar 2026 12:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=49UhrOnJU/du7srVgUj6Ib309KZ1nAz4uxwKjvqXGo4=; b=
	U3l5KNMrMDXGVtrAsaaaqkUH2tIk631mHepB2R2rqbNemrui4770r/IhsDM7iU+S
	dMPPbOXukCDEV/OCBoDDIe76wmRsEjqKEqxk/cIaOLalAC0ImUt7IEI7sWApj3YG
	TvBwMfE6O8epWDDdRd9MCUbGwihPBBCU1156zuEnUxVXxjpGWCvYS4Dx3aZk06Q+
	eJvll71yCfWvcM2KQx+NKackl7zpEYoi+w4BYrWFAY5EPs9nhlqs4JL88pTpIlHG
	4V5veZx/YqnOppJ9HFN4irowlhOk7kHy3LLqEnxG6pBqtgJcqaC27jbCXy7eogpj
	D8LC418UqG8UtTyuGkqvGA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kejj54c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 12:52:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NAxg8m038971;
	Mon, 23 Mar 2026 12:52:29 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8gnnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 12:52:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EbAk9VwYN3mvyO+6XGPg2QeDB0M1xOy2K6mOztGDJII32Q4hFQD4+fmhW6UUfEjaOHKZgfKLeQ8gSpQ799/d2JV80MYVJa2rw5yL4upvSHQZswc3vV9IDgWB3Gjfw2uoaKVeABe2+RSxlGZ2AcPYp6Cfa3nRccZNzcTPgEVue9mdgHBtnoceKSbYtPvcYzeL3QouE9mvaIYIdY3jHUpTLkQlGwUd6zVxhTnrnLBwb1lJD/ChEXJhRgM+rTxY49/bvQV0J6Ntgm9ObXNe09H731XkTgJ3CVTc/dARbISzwNLOPNfUe+keclU3KsBAbNVUErf0r6ERXunTn5VdH5/uMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49UhrOnJU/du7srVgUj6Ib309KZ1nAz4uxwKjvqXGo4=;
 b=Bp5BwThfJkkqtrKq6CBCg60uO+zc5M2B7YmfWL9stI0QcGJ1cRnugKAeHChnLyxycfFP3BLXbfeTW5oVLJlEyvTH39P93EjiQBf1Dbe1vPtI7JV1Bb34vNuNIFRPtFBAZo2vjuZR/lx/eYG96CP+rEjoI3qawmxqnu2K6w00799WFTdp+Ev8mYyw+F1f6ZTljMvVeaFGzfMlrZanFUoLfueJIFbQR4JQ2C24k8fJkYBNsRXjnLQHKdeR9zBVyPkWRIelwIVjWTbNf1u2uUOjdutFE38ggm9tqEyykdlBr2SkxjHIiCxsoVG34GOQJGEDYUaGm/77+9ldAO1GI+yCPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49UhrOnJU/du7srVgUj6Ib309KZ1nAz4uxwKjvqXGo4=;
 b=YPXT/wMLe9aWCTizBWHU/4g/n4Haqqm2y/7Pot/n9jy8gpDc3hvaaO7pwRfGDlyFzPPheqXobHuro/xje6K8MkFHT96k2Tfw9Dibad+7qjamSkW7f33NzJp6cB6cAAGCsoankFjGpnD4aFYQ2ToxEAEJ9nJyMSntfp7sJkUAQnQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5193.namprd10.prod.outlook.com
 (2603:10b6:610:c4::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 12:52:23 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 12:52:23 +0000
Message-ID: <1f6d5e0c-41f9-440b-a7f0-4850477309fe@oracle.com>
Date: Mon, 23 Mar 2026 12:52:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/13] scsi: core: Add implicit ALUA support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-14-john.g.garry@oracle.com>
 <acCeVabspYFjQHPu@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acCeVabspYFjQHPu@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0395.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5193:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee684e6-dd4c-4882-396f-08de88db06fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	d2EaY4ULdFX+QOVAeg1+07QJyMZ8nzQE8XGJhTTPLQdhHuOfYt7w8Xmd6TRgslb71aou/wW/slpIUat8Wz/yDPPLH29tWBCUXBrQn16rPZe50onwJgO2/QyBpgqEjMnLCkHxcbikCQLMRMt4O7LXCHU0Q41Hld6cDpoU4GV2HErsdal0MJN2ULrQ6tNjjNOc0L2MRg+Mb1ZYxaPf3CtL3b6ukwf/VwjztqppKrnlSfu8/hgRv7GjEQktH352tjPgZ+zMkT+6nIAUqAsxlDdO58fuGnSrc60foSFO8rBdycU2YA+AjcChwsdaV37NOfys9BC6niSNBr6lXoSxtaZoYZEGr2y7P4W9NPQx2f172eQ3lBracNtrCZYhz+lzGMZnt/+3e33z1Sou/7cozDNf/HwsRmyiK9itosZ/peRRLTpdMwFG0Phfrc99M8FD3fog6oMkZmu4J5uIoaLEEAADQf2hHiMUX/QvtHewgRLP3rgixaOCZU6F/mV4kEvUAbM6mFfrVvwXp82nH6oOCEGZidAhyF0MWoH0l4M62jTqp2e+yj/vW/q/oGuZFT0G+Pl3+M2M0vp0QxQobawjExW+OiFOLfBXWaohJU2co06BEFnQV96ghyl1yJvMUl8MwDI6J4BY18UXZbmDIQxp2r9AAM7hBeAeuWX+mkcRACuvF3r+9Yoqh/1VL/0Sd9L1L21EpS4XujesSAalBv/KEuP2N5REt6R7AIBOlTF0938r3Dg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y09nd2YvRy9DVVNhNzNQSFlCcDVaa0d6S2ZtclU3OThQOUQ1ZlVIcmVab1Vm?=
 =?utf-8?B?dGdPTFZzNVZwMUlkZWJJNTZnaDNMdElhS0t5VHJnVGpqYi9YQ2Z2dFNvMHhv?=
 =?utf-8?B?SDVwb2JyM1lIUnhrS1QyZ3JTL2JMOFFoUXJZZ1BhNnpkVTU1RkhWdFZoWTBE?=
 =?utf-8?B?eGMydTgrQXFuUVFXNmt0eTdrWE9IeHN6MVE0WGJvc2VqTmNmeERpMHNtTHRS?=
 =?utf-8?B?V3lSMFJPSnVNRmx3emhiWkp4MzF3NFMvS3NkREJnZnh6b1l0Vi9YZ0RtWHlW?=
 =?utf-8?B?UE5ZbmhtclVqcWdpNUdvYUQ5bDZqSEJqQUV3Q0M5V2pxK1Q2YW1NTnJJVVRE?=
 =?utf-8?B?ZkhSZVM0VnhwaU9RVjlhM0JaK1c2RUxsYmY0RlNzMm53M0ttQm4wenlMNVA4?=
 =?utf-8?B?c2tHNGhjVTVqaU5tUDRrMFArejZJYXMvT1kyTUthRGplanBpTVNGSkFuYmZ6?=
 =?utf-8?B?cktTN1pXNEdGSm1tcHVpdzRGL0NKdk02ZVg2RnlqQktOekhJYnNEbldEUUNi?=
 =?utf-8?B?UnM3OVRIc1czYzQrSFFCQll6WG5wVHRCQlNlWVlHcW9NUkIxV1VOOTZscFNZ?=
 =?utf-8?B?OHg5UjkxZWhralQ5Q24xeW5GNVB4VE0yanQ1QlJIQjJqZzNuL0cwbDFTYlhh?=
 =?utf-8?B?M2hMRUNiOWhnQUtDQ0NJNlFQUzZTbFlaSEs2ekxYYzFZNkV5MHVuN2xhNUZR?=
 =?utf-8?B?dVVNR1JKK2VqZHdpTFBYOGxHcDhjVWJRZ2FBWUkrT1JBaUlUMzdjTW53dy9v?=
 =?utf-8?B?Z3poZXdQVi9QdGNuMWFWRW1BOVRsZ3huMVJvUnVzKzZGcW9wMW96M21MSVRO?=
 =?utf-8?B?SHBtcFM4VmdsUnVKNmNYYlM3dmxVNjVjUUUwVXJFMUFLL09wTHk4ZzRlZE5B?=
 =?utf-8?B?cFU0MzRTTXc5OTFzS1g3Um0zMnVPclpjam9RSXVxS0JvcVVuT2NQZ0Z6US9v?=
 =?utf-8?B?R1ZtOTl2em0yeWdCVElHOEhoeDExb2NWc2hnR0lrWHVMdElsZ2I2STM2RERn?=
 =?utf-8?B?RnIza3JDQTlmVEJoT1E5V3dpcytvOFJ6YThwWWtFTEVGQUJ2TG8yWWRUbG1F?=
 =?utf-8?B?d3diUStRZ3JyRDltYnA3NmRYZjZWbFNzL3dkNnFoVzNQUnVvYUJPU0k1eXV5?=
 =?utf-8?B?VUthakllakVPVzdjaGhkanZJZEZhTkFjVGlaQ2FxRnpLaGlYUGVIREI5TS8r?=
 =?utf-8?B?aE4xaWlJQUhQV2xiRWYydHFTY3pxNEhWcC9hMlZ3cHNsYmF0b1lEN3UrcWhF?=
 =?utf-8?B?c2RKM1lWR203K3prU1BldDVScjZTRU40WnFhT2RyQnVYSVJFcmFsSmIrR0Rw?=
 =?utf-8?B?d2NVTGsrRWhXbyt0bE4rSENYVGdiTHhhQjJEU1dsbW5WUzJhUy9tVGJ6Skh3?=
 =?utf-8?B?eXZFNHA3VU91aDd1MEJ1TXdXRThsRWV0RWpvRnpNMjZMdUhZcXRuZ3BjeDBB?=
 =?utf-8?B?ZEtkbjFuZWlSbUJQeHFnUG9xSmEvV1E1OXlrWk53Q1E0Nk9md1FsMEpRdzlT?=
 =?utf-8?B?MWVYNTZpbzdOQ05YVk5ieWJuSE5kQk9DN1I2SzQveGtnWWtEbDNCZ21oWXg5?=
 =?utf-8?B?L3JJTjIzdTNYT3NUZGtiSUduR1lhZnA1d3pGRkVadEdSUzVKTWc0M1loNVdG?=
 =?utf-8?B?WDBqOVo2eGUyRWxoVkFYMTNqZGdrSFpGM1p1NmJuOWd0UURIOE16U0pOVjcr?=
 =?utf-8?B?Y2VzQ1kwZkRxL2xZTVlLTEpIZSt5SDZLL0E4V080dG9rRXcxV1d6T2dkclo4?=
 =?utf-8?B?OGp2UUJlV0VZTUsrdXgyL3lzM3FvelJINUE3dGdOMEkyd0ZhcE1WNmN6UTNE?=
 =?utf-8?B?M1NvY05XNVFOMlJEOERtN2JhbGQwUHo2VENCVXVhdzFzMmlINFNjcmpxUmVI?=
 =?utf-8?B?dWtWUDlrUWE4NFJNWGl4QnU1NEtaaHNzWk5rWjBJQ1ZwMFpoeHJCYzRneElp?=
 =?utf-8?B?cjdoQU5ZRW93Z1JZcHhjSHI5ZGVzc2NFQkpvVnJlVU1LWlEzQjhKMklMRnMy?=
 =?utf-8?B?NUJrRXJOWEpXY3J0SzFia05HSnRLOW4ySkd2Z1pmalBIbWo2anMyMldIeS8x?=
 =?utf-8?B?M0J5TFdQenNoVEgrSW9QZTM5aGRlemQxZDRzYWpOUHFjSXZ0MFhoOEpoaWxl?=
 =?utf-8?B?cnZQTFNFaG5ZTXBqREZodmExY2tyZXJsc2xLbkRvbDA0TzdMOU8zMTRGN0Jp?=
 =?utf-8?B?NTBkTjhIZVMwdFJ1WlhKUHByMmRoTFFzQ1ovOCtJMzdxN2RSdDRmSHJoOUFU?=
 =?utf-8?B?dHNyVTkwQ0d4QnQ2emNZOE5pMFA3MmJSaDNzR3hUL2JwQjVraW1BdzJqSEFZ?=
 =?utf-8?B?b0FYdEVWVXM0RUdZT3U5N2R6QW5hMUk5UG1ndEs2RENQa3NNdGx5Zz09?=
X-Exchange-RoutingPolicyChecked:
	ll94p4ikp7vmB42ql0xiXMK8yRjWc37WWiaZ69d8CJlutw4OdLju6w0aUq2VRyMNwOlLFT0FiPTs6hhr98VNIEq6pIgIWFWK+RNqVvjE1jyRH5jyodQv685av5cI1ODZSXQOlWS9gHt/X+6++S+oedUu4ssv/POZEueFGIP0Y0/sEdk76db5nuqrIMaIumr7f667dvHUj7Kn8ylQPoT1o9jeA/WAhTz0aGTCohPVM4+xGzqypYsOwxsDlJB6b/c5scAoJyDTkzRDLl/lqmv4d9tPNJBvfKdwQkQY4FgoEjTuYdnKWXm06VQ3DHM3UdeCzMCqNh5GxkERlAPLlvwHtQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OAZgMnmmrjL8UhfwBwtmCAV4li6G2Vt+ntJfyVJg4YOPXBedGveyUGFPH0dGEQDTA+ygbtKWPrNWX3FmLwAfAKgMpAZt/wBhNYoya26G9gZLuOhUEFYY5cG8a1DO3ujV5H4lRjJSmLR3/ivV5jVzyfn4soD23eeZh0Yz5sVMh80yOn5OrqhPDhaJTrsO+6xbhQSLxF+Sgmfaa0XAoXC3jUDXcCgxLTNFs8ViIIhi24HVYEgBfpS3v1evhbDN5BkYXCiMpKaa7A4gKoWZiLZ55yZz8kepr9mG+sg5u1nIId2JLZhcCZZcDzYnyZ+RTCHgfwBqFZU1lcL8COhQ6XJhGNUXFEhAFvSEWmWlZ6NuMt8XB1v4QjkMncH4uVmdOLcyMI/TokkTX2L+fzkSQhv0zmdkIth/XKX1hpE2getJg33Y9vu3Ws+Q5gSIhrCxsS60CwJefPIIJeuYIPPlzl4owGwoUDkMbewe3V5Y1axGxSHEC7Ct4VQfZTpxiHrUpbZwmjW1geX2h7ehQzTlhFBKN6edi2YxApt7Y6UofE3ORBZVG3EHQr/sNoTP/tQYgZy0Oy6psp03TV829n/kM100EKH8WaDHNjhCe6e0InImkgw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee684e6-dd4c-4882-396f-08de88db06fd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 12:52:23.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akmfTm+oqQo3j/y3pOdgttokkQQ10TWntM3E3pnMaDfYSoPiisqMTT5mpTGYLddVIwU2IIThs2BKLbrtTtwnYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5193
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA5OSBTYWx0ZWRfXzusU/sEH+W1a
 2gIMEqNqf5qy/o9zv6ESXDYKyTTmEQ03POd2ejwsg/kfdNsKti44wXZFf6uC2evoPLakXz/m8J2
 Sq/1tKwBu1zeCeU1I1PZgXZg6SenCfn0ZJIvnM1K4ZCTv0KVXvMzRfL6keYSqMVerr2TDwNFSPr
 iY89bT41KV68L/+y8iz/vTzbBoF1znzcvy1qT7uj9M50QwDu6TUOm7XZoUCtBLT3083jinxZvX3
 BYljs6vySCJt+RXdaIlvVIBqEQm0DHwp5aRmmKLO9f9IrM8g/4I0Abwpo8Z5ibgHzcYHVNEb1pd
 s2EAtx+BTjIzhbHsvZRMrNAzXyh+OGIXf93Xgyq80Aia+6WpuyEmZ4kuENLZ9gwPwLx+kPo7+sf
 RwWtmHOVE308awdg1/NgoEGWYqxbdAwJNNYf3hqWrD4IPoVL1r1kMQl8RHYimi1VIBt2/79guiY
 tsPHAWlpk6FV6EZvnonSLuRvxYMFquUmYa3YXJl8=
X-Authority-Analysis: v=2.4 cv=GZAaXAXL c=1 sm=1 tr=0 ts=69c1378f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=YDFPINMSSo8qlFbpEkUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13824
X-Proofpoint-ORIG-GUID: ZPPKhTIOyxciMCSJELOF8-Bt1q8C4_M9
X-Proofpoint-GUID: ZPPKhTIOyxciMCSJELOF8-Bt1q8C4_M9

On 23/03/2026 01:58, Benjamin Marzinski wrote:
> On Tue, Mar 17, 2026 at 12:07:03PM +0000, John Garry wrote:
>> For when no device handler is used, add ALUA support.
>>
>> This will be equivalent to when native SCSI multipathing is used.
>>
>> Essentially all the same handling is available as DH alua driver for
>> rescan, request prep, sense handling.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/scsi_alua.c  | 93 +++++++++++++++++++++++++++++++++++++++
>>   drivers/scsi/scsi_error.c |  7 +++
>>   drivers/scsi/scsi_lib.c   |  7 +++
>>   drivers/scsi/scsi_scan.c  |  2 +
>>   drivers/scsi/scsi_sysfs.c |  4 +-
>>   include/scsi/scsi_alua.h  | 14 ++++++
>>   6 files changed, 126 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_alua.c b/drivers/scsi/scsi_alua.c
>> index d3fcd887e5018..ee0229b1a9d12 100644
>> --- a/drivers/scsi/scsi_alua.c
>> +++ b/drivers/scsi/scsi_alua.c
>> @@ -562,6 +562,90 @@ int scsi_alua_stpg_run(struct scsi_device *sdev, bool optimize)
>>   }
>>   EXPORT_SYMBOL_GPL(scsi_alua_stpg_run);
>>   
>> +enum scsi_disposition scsi_alua_check_sense(struct scsi_device *sdev,
>> +					      struct scsi_sense_hdr *sense_hdr)
> 
> This seems like it should be shareable with scsi_dh_alua as well.  In
> might need to take a function to call for rescanning and have
> alua_check_sense() be a wrapper around it, but since the force argument
> to alua_check() is now always set to true in scsi_dh_alua, it's
> unnecessary, so both it and scsi_device_alua_rescan() can have the
> same arguments.

Yeah, I tried it and I just thought that adding the rescan callback was 
a bit messy. I can go with the single function if we think it's better.

> 
>> +{
>> +	switch (sense_hdr->sense_key) {
>> +	case NOT_READY:
>> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
>> +			/*
>> +			 * LUN Not Accessible - ALUA state transition
>> +			 */
>> +			scsi_alua_handle_state_transition(sdev);
>> +			return NEEDS_RETRY;
>> +		}
>> +		break;
>> +	case UNIT_ATTENTION:
>> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
>> +			/*
>> +			 * LUN Not Accessible - ALUA state transition
>> +			 */
>> +			scsi_alua_handle_state_transition(sdev);
>> +			return NEEDS_RETRY;
>> +		}
>> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
>> +			/*
>> +			 * Power On, Reset, or Bus Device Reset.
>> +			 * Might have obscured a state transition,
>> +			 * so schedule a recheck.
>> +			 */
>> +			scsi_device_alua_rescan(sdev);
>> +			return ADD_TO_MLQUEUE;
>> +		}
>> +		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
>> +			/*
>> +			 * Device internal reset
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
>> +			/*
>> +			 * Mode Parameters Changed
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
>> +			/*
>> +			 * ALUA state changed
>> +			 */
>> +			scsi_device_alua_rescan(sdev);
>> +			return ADD_TO_MLQUEUE;
>> +		}
>> +		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
>> +			/*
>> +			 * Implicit ALUA state transition failed
>> +			 */
>> +			scsi_device_alua_rescan(sdev);
>> +			return ADD_TO_MLQUEUE;
>> +		}
>> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
>> +			/*
>> +			 * Inquiry data has changed
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
>> +			/*
>> +			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
>> +			 * when switching controllers on targets like
>> +			 * Intel Multi-Flex. We can just retry.
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>> +		break;
>> +	}
>> +
>> +	return SCSI_RETURN_NOT_HANDLED;
>> +}
>> +
>> +static void alua_rtpg_work(struct work_struct *work)
>> +{
>> +	struct alua_data *alua =
>> +		container_of(work, struct alua_data, work.work);
>> +	int ret;
>> +
>> +	ret = scsi_alua_rtpg_run(alua->sdev);
>> +
>> +	if (ret == -EAGAIN)
>> +		queue_delayed_work(kalua_wq, &alua->work, alua->interval * HZ);
>> +}
>> +
>>   int scsi_alua_sdev_init(struct scsi_device *sdev)
>>   {
>>   	int rel_port, ret, tpgs;
>> @@ -591,6 +675,7 @@ int scsi_alua_sdev_init(struct scsi_device *sdev)
>>   		goto out_free_data;
>>   	}
>>   
>> +	INIT_DELAYED_WORK(&sdev->alua->work, alua_rtpg_work);
>>   	sdev->alua->sdev = sdev;
>>   	sdev->alua->tpgs = tpgs;
>>   	spin_lock_init(&sdev->alua->lock);
>> @@ -638,6 +723,14 @@ bool scsi_device_alua_implicit(struct scsi_device *sdev)
>>   	return sdev->alua->tpgs & TPGS_MODE_IMPLICIT;
>>   }
>>   
>> +void scsi_device_alua_rescan(struct scsi_device *sdev)
>> +{
>> +	struct alua_data *alua = sdev->alua;
>> +
>> +	queue_delayed_work(kalua_wq, &alua->work,
>> +				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS));
> 
> This code doesn't support triggering a new rtpg while the current one is
> running.  I'll leave it to people with more scsi expertise to say how
> important that is, but the scsi_dh_alua code now will always trigger a
> new rtpg in this case (or at least it would, with the issues from patch
> 12 fixed).
> 

If the work is running and we call queue_delayed_work() on the same 
work_struct, then it is enqueued again. If the work is pending and we 
call queue_delayed_work(), then it is not requeued (as it is already 
queued).

Thanks,
John
