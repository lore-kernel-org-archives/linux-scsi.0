Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399A38A299;
	Thu, 19 Mar 2026 08:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773909687; cv=fail; b=bqa8rwfuLmYRyONWHQnq/eYpQCWqQGyrv6pE5HLQC3laqcwoi3ZXDI4C8y/DetxdqSkGU7q5GTLYO2cIkT+GHVD5udfcfwMe+3IOXgOpfpFQ9YoGmRSm7moX4K0DChdtVX6U2MtvVD84hVSs4zIkCklCjgbawCg0c5BP58urDAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773909687; c=relaxed/simple;
	bh=P6CjPnl+pBqAwgi/SENKf/W6jS2h5FO5aw1PIszx3Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=l7JJd2aYyu841Dr3tqloeuY5ggJGb38LWSZz7T7lzElbCRRfE/A7sur5zkntxTfwri/g9a91lGKp/qEIDdRegL9dGazcUuXJ6PeFjQD8nLHclHSzQ15HAxeWSH5pfgB3b3ycrG/cF4YlGkX9YwuO33FJqFhvmkWIfnuB0k90FmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=S4+B3rZy; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="S4+B3rZy"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62J4rOjn3710506;
	Thu, 19 Mar 2026 08:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=EacNoMxRT
	LiumRnjECvojRzW0JMjB95olGSP3o1mlfg=; b=S4+B3rZyckHuRv3Zlzpr8EbMw
	L0tH/xSzkYyQvdTT76cpJokFgabWW3mh8JQYqrPvargwFlNq9UBH7x6AYJZLPNpC
	Gi+oUwABer60OkYrMfr5ZyOkPpaCXxMilFKg8kOfFhjdd7aWqHGWLl0a1vG/uLLx
	zNtaKa6wUt2ujczEwXdm57NIVF2kOxwx0B+AsKZbwAUFPOcpeLpHJgwW42rGY+2m
	EAjeuh6Pxawpx05bVx55YQEAID3rizLY2/wTc93G+dhs1d2jMDB0mRWbbOI/va4I
	XA5qbHJO8IjLOT8Zkk+IG8cR+VdB0k5N9U3FVwe3yDwjPnAwD3j7bRdEEBtYQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cxm66c1q8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Mar 2026 08:40:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HornCgeSKOmfV7bQBUuUcr4bDOTIOIbSHdY4u56jXcmAz+HR0dUXmmmWWQKeyHXnDR9TjAtwVkeVoZnOBtpQRn/Mjij3AN7NFFQDYj/49zSag7Gig5/X2XQa+OVjPN0q/k6/eyUAliFnptFt4OFH9HVGBQNHmwZY7dGjdf4uCUp0oKH08mCqmrrOaDdGlFnjoCEtn98p+PVdt3oBWF1W8CiN54hBC3VMVQtgWhXGFCX7G2tcLE0xG4wWGMEJlFcHHvB3xb6+Az+5ePFW98eeFZNodpfgj5k2k2cJBHErPTFPBuDOjN2WlddwStbezv751HqTAt/87VBcoI7JfLvNFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EacNoMxRTLiumRnjECvojRzW0JMjB95olGSP3o1mlfg=;
 b=F8cPJ3yOSt/gIKnVdS0ya/DvGz2g4FaMdDnLYiwnw9silJdC1t5O0koDe1zLvsxoToBjBmoir3D+10jc5y0XdyBKZ1xtY0yBc2uLmE1lhR64swVSFEniw/5htJZun59Tw3EhAfs24Fp0K0tP1fsF1SFHJHtlViqFWY4B+UbQCL1p7NionBTvise5+irw36ML8indb5hamc0S1Cjh5z/h5wtAUDiBNlg62bRj8PHQ2fOyfiUlHxLFLvEkecABQJ2JFPWbBskQQpcBiHwr+Z/uoaP3YwQg6kIaRy66DbqjUdqNyV1hqgaj+NYnf5X2y7CpxW7GhEb1pKnNpnfGGwFFuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by PH3PPF37A184CA6.namprd11.prod.outlook.com (2603:10b6:518:1::d15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Thu, 19 Mar
 2026 08:40:11 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9745.007; Thu, 19 Mar 2026
 08:40:11 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, ahuang12@lenovo.com,
        axboe@kernel.dk, damien.lemoal@opensource.wdc.com, dlemoal@kernel.org,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, kbusch@kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        m.szyprowski@samsung.com, martin.petersen@oracle.com,
        robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v4 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Thu, 19 Mar 2026 10:39:53 +0200
Message-ID: <20260319083954.21056-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|PH3PPF37A184CA6:EE_
X-MS-Office365-Filtering-Correlation-Id: 2982a6aa-b9a9-4ef5-b426-08de859321f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|52116014|10070799003|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4rbcOgHSgXqwIG2UKJaDEBHXSj5DjW6k7x6NRkztgxD1Tdg6CCqDVFh7PcT5DJfy41Zz2HJJQgTXpDYb9C5SPdkTL7iJVJ4N0c/YGh+EmofREEvxHjs1llbz2K7ckOHaixATkAQk9QG5hPM1JDp4dLz4B7scJTPHLXs9t1nlglCp34CS4ZQbI3Yob9yCWWEZRQ1R5vW3L4S+oXd6NJFi3iDXhsX9GBibZ5KOibYmqa0utyYfCc/hqZwPsHKp0nqaMG5bu+xqEPtauvr05YueQiJF90GgV007Ii86lvJZUfSqZeKLpx1l8KWdN4gfGBQoGVuZkymE2vTy218Qlbi8C1nQAGYz412Q+GhghpKck1xXS7LmL4XZUKgdkQ9Uf0SE6qLzkiNONst/dXlGKIgfb1N9nM6GjxZCxRjOjqcGdzttbJpsLu+e9P0cwjCRyW/qCWIlINWJ/+Rnf7khJn3tx0ZwQnUbCiK7pj8q6znyQKoVqGsdVailcG9b1FtjhCZTzxap9RjqPCSFD8X34gbABxhwFsKbWvy/L74ponXROvgSsoPpPv8pqIewihTAOdDl9uOioTix21PNxhlNTAQOvryovff0IZ4fOVT5NT4pC7u1Wgt/QZGwU8Tqrxh4XQvztL0FEbsxx0QLoamJuBK2ZMQrqgB1ips97I27liV1CgJf6KTLQJo7/okQylpLuzcbxMasls8WDhDZgPldw2Wf+nNeJAi9hDEUj6U5TIOzvNZZBw6awzkAM73h/XR3c8Wl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(52116014)(10070799003)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?em85dlRsM2dhSDNCYmp0ejltVnlRcUVLN0dxU2tPY3ppM1RWdHF5ZjhvdjV6?=
 =?utf-8?B?ZysyNTR3OTN1V1hOR2tzeUlzLzZSeVVUTzZ4d3ZHeFROc0M2MHdKZ0hQM2xy?=
 =?utf-8?B?bXJqTGtDcVhHNm9vdTA4RWZCSThmUVl2Q2RRcXI1MC9NQitjMlJqTVZPYlhp?=
 =?utf-8?B?RUZuNFArc0ZNazNMN3RTTFpERzlQUllJYUQ4aytMNDRaZWdDZkh5Mm1PNHpS?=
 =?utf-8?B?czQ1eUthMjFsSVdPalJ5Y0JBbERITThWNUt1c1lEeFpMWTJJUUFqWXpHc29v?=
 =?utf-8?B?WXVWRVVxNkZNZm55azNpeVhLNlFnNkFXNExuS3ljc1FBcU5tZjJNaWd4cXY2?=
 =?utf-8?B?bHkveXBxUlJQL1ltOEoxWWpVd0JaYkxyU0lyOEt2NXdXcGEzQXZOa0ZxRVM3?=
 =?utf-8?B?cTR0ZG93dzZJRTBaWFNKM3JqNENyWm45U2lISXF1RmV6eFdMcGpjVk1CME9k?=
 =?utf-8?B?dllIdHVMQUliL0l0QnRYd05CbzVHQnlMWUVTbUN6L2ozMnArTkFvMDZ0emN6?=
 =?utf-8?B?WmU0aDU2YWthdkJLUitmeUdDaEZIWnBMbEZ3bE5VUHV1VnVPSndRMXY3a0pE?=
 =?utf-8?B?a3d3WkZKanZmZ29oTW5hNlZKWHk2RlQvb1o4OWJCcDJDZjNjQlUyUmVwUXNk?=
 =?utf-8?B?OTdiM3lpazg0NWIzUmVCTng4S2x2NHNuUXBvdkM0VDNXeDBJdlBNV3pzS2w5?=
 =?utf-8?B?VkYwOXBtNFlHWGljRCtxTlVTQUthQXdWQjhIeHJaYVFnOE9ZUnVEVzRFa2Z4?=
 =?utf-8?B?TWZZYXVGS1QrRHhTaUNHcnppTnd6cXN1aW0wQUp3eVFkK20rREd2dzZGZmxD?=
 =?utf-8?B?QW5HdDhERjB6dXhNTVFuU1JqOTlYVG45bXRGTzNibGViYkhGOVpoZXgvWEJM?=
 =?utf-8?B?a0pZSkg5U2Npdm9xcmphb2g0b1BvUE9BWkNrSVB4YlgxOHZzYmd2c2xyVUtT?=
 =?utf-8?B?VVBjOEFMTm9JN0RVM0c4OVdJWklrOGFIaXMzNFpJNXN1ZmJmSG40SlU0a2ZI?=
 =?utf-8?B?L3RtdTd5YWxHMVY4YklMTXEwSWZVSFBTMlEzRjNjTW81RUJyY042RzlZTjRu?=
 =?utf-8?B?bGtrRzZkZitFYmRKZUovMkVKdnQvR1NBRm5WQXE2WWM4YXVyT2RKWTFVYXJT?=
 =?utf-8?B?ZjBzeHB5OW1od3Jhc2lCOTZ3Vk9wL2wxYklJVnZHbFBIaE5jN28xMzliRUpz?=
 =?utf-8?B?WDRKTTJZVmMxbUgyRjlwVTh0M29NL1plVjBkbDhEZnVlTW9ic3FSM2ZrS1BT?=
 =?utf-8?B?QjB3VElSbGtla3FBeVQ3U3FhbjJHVlFNZ051Wlh0RzB2L2dUdDlaK2Q5ME1N?=
 =?utf-8?B?cURzSERXUU9lckZ2K1htQzRrSUNMWk9OWElIbWVvKzg4dDhIbldOaHJVZjI5?=
 =?utf-8?B?QTVYUHkrTGY4ZHJFblNxcGFXWUpYMmNDZWJ0YnpQVkZMUUdGdkpDQ0xXcVZ4?=
 =?utf-8?B?Y0tHaU1zWlNSNU82dGhMcmNRYmtWTlRZWCtxSzFaUnZDR1dYWVhDZ0VoTU0r?=
 =?utf-8?B?SHdKTHZDVVp0Q1RKRnhFcklhNzNFUzIyRDEzeEhPbFY2ZFhSMVY3VHNuMHBI?=
 =?utf-8?B?cUNtZjNZVGlTcVNlbGdGRHhDVWpGVXVpVkRnSGw0V3NzWEJCb2pEUjNzcTJt?=
 =?utf-8?B?SmdEL2NIRnlKMTBJclBpZnFzWjZYN25iUmF1cVBVN090UExJUGdNZ0Q5V1Q1?=
 =?utf-8?B?S284c29abjVvcXZxRUhFUzB0R3Q0VHVtbElISWVFZmQ5TnlMWitKby9NMzhY?=
 =?utf-8?B?OGQxN1AzQThjUStGdjdrallxRXFLT2s5M1lENzR5WE1MSXZNemZRTE1kcnhF?=
 =?utf-8?B?NnRRNlFCME4zcHJoZTFrbkY3cjhvWWtuOTJHV1phMVhVMXg5TTJFdFNJdmhT?=
 =?utf-8?B?TWhHdFlDUGhrUy8zYk5ucGNBcVhjS0xnVmNpWnNlcmFCZHc5MmxBcTM4QkNv?=
 =?utf-8?B?UFZ3SjJweTZtR1ViV2hVcnZNZFFIVUZkSVNqQkZCT2IvTEFFVWdha2RmdnVW?=
 =?utf-8?B?SzkwVGRlclJNWGFxUzRhN1hkcW5XdjdXVjVZKzByYk1XT2hlWFVwckhhbnUv?=
 =?utf-8?B?ZFp6UEZUNVdJOHVHVWQ3NnFwcmFHSzZXZjNHdjhLQlFzLytiR2NvNUtrK1lF?=
 =?utf-8?B?YkEyWlJ6ZmIxb24xdCtNK3ZlVENIUFhlZnNjdE00Q0I0K2pzaU1kUHd1cGZY?=
 =?utf-8?B?bzhLOTdoSUM1N2JNdFVKaU9SdFRNS01IUVVGci9xaWdieFd6WlIzMDBnZVd6?=
 =?utf-8?B?TGg1V1QvdkJHalo5Q05tWEovZW1teldFMkNpSVpveHB5TmdZNjhqc1RXNHY5?=
 =?utf-8?B?cUpBOERpU2gyVEJ3RkliL1hNZmtpR29FeTlzQzJ4L09xQ3RhbE8vbStSVGxU?=
 =?utf-8?Q?Rw/PjnHdnnl8rgAtXYlE5I/jOIqMqulYBm3q7dHKKQ1LP?=
X-MS-Exchange-AntiSpam-MessageData-1: lTwQmDmdWVrqoTflnRnTbjl77sJ1JcUCbw8=
X-Exchange-RoutingPolicyChecked:
	oRTkhdff9jjNirf3St+S7DH1cEDCOvaEs6alAGIq/+rQRYmCn5FaKW7MsAvEdYt1hj0saaZBJBDjL0vnhaqYusrLqq9sNK9y2RNDaDvGaH5i868UoTGsfx4dX29CQjZgGHCbEW3NTq19s//Xf+nlvzfMy0lOcMzeOfvt9jwMo8G2oM3MyIetGUqxOGjObkAa50C2k5xIAjewAk1jLVqwOmGhH/BrMP3BXig3/bm5wbtiAX4kNDLCY7EIhQZKT5FFyH9QPMzXJTVSLML9DQ5FetVzvpUJbi31UQBvXH2VzFGO8wicUUx5J9LGPcHMoy7stAS1TmkjHn8aL2TheVuYHQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2982a6aa-b9a9-4ef5-b426-08de859321f9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 08:40:11.2425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kVcjs6NL6htKR5JQViGMzFw/4v9bjz9KtIU34DzM2ity2PDC7NMHZ0X0mKaDy42gDw5BU94ol01gAQtx/IHlr2Y/kw1JTQpuWj9nEtTvFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF37A184CA6
X-Proofpoint-ORIG-GUID: 1K8aBBnnYMSEBNqLJv9jW2EAGIG81V03
X-Proofpoint-GUID: 1K8aBBnnYMSEBNqLJv9jW2EAGIG81V03
X-Authority-Analysis: v=2.4 cv=fLk0HJae c=1 sm=1 tr=0 ts=69bbb66e cx=c_pps
 a=+gGuMjfID3j0L7k8h/8w9A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=peZQmNii5BG9Q2hMFvcA:9 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDA2NyBTYWx0ZWRfX8v/T/VIlYYSJ
 JjOdMu+Pu2GUckr4PazwQ7pi0dwIM5wsz7r3vBQSZYBGdxYj4lKGpxgSsXlnGN9nxgD7/pijoqi
 CtsxK5TbRCG8p/eBQgVCEYsDo/RY97DT2Ta7nMrC49COC1jrafXgyrssALmGhPhgIt8CO3PGRV1
 yNYu+qg1fd/9E7dp2XIewUPZMc/kq9ZJvvFmiB9ElyHtj1x1YYez7G1/XwsU2/xeU5UrxqoOiPw
 YcFbyoLTU+XukwhUaI0Xn9WT7eyrUt2T/hH7mWpPfVX+oIHxw+ARTLWIXzAbnPynBKFJRDVQv4w
 SBFXSshfmNOPYxJmKEZY0Xsh4btixc0AXLhVSf2780w+w9U3zA/5/9fOWC9igDavfrbNLz0XS2I
 PsQ/6LXLrUOY7xAHxJ2dnOKYVd5iPgluy19LELnbe0xYyPjZCG8jH482y8dVJk6WL3L685kbsHk
 Ztqye1Y7+mXp1TVUJ6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603190067

From: Ionut Nechita <ionut.nechita@windriver.com>

v4 (per Damien Le Moal's review of v3):
  - Split the opt >= max check into a WARN_ONCE for the impossible
    opt > max case (driver bug) and a plain == check for the "no hint"
    case.
  - Used min_t(unsigned int, ...) for the return value to avoid any
    potential overflow when shifting size_t down to sectors.
  - Reformatted the call site as suggested:
      shost->opt_sectors =
          sas_dma_opt_sectors(dma_dev, shost->max_sectors);

v3 (per Christoph Hellwig's review of v2):
  - Extracted the opt_sectors logic into a dedicated sas_dma_opt_sectors()
    helper function, clearly split out from sas_host_setup().
  - Added rounddown_pow_of_two() on the DMA optimal mapping size so that
    the resulting opt_sectors is always a power of two, keeping filesystem
    geometry calculations clean.
  - Added #include <linux/log2.h> for rounddown_pow_of_two().

v2:
  - Dropped the dma_opt_mapping_size() change per Robin Murphy's feedback:
    the DMA core semantics are correct, the bug is in the caller.
  - Dropped the nvme-pci patch (no longer needed).
  - Single patch now fixes the actual bug in scsi_transport_sas.c.

v1 feedback summary:
  - Robin Murphy: dma_opt_mapping_size() semantics are correct; if no
    restriction exists, the largest efficient size IS the largest size.
    Fix the caller, not the common code.
  - John Garry: Asked for concrete max_sectors/opt_sectors values and
    questioned whether sd_revalidate_disk() would override opt_sectors
    via opt_xfer_blocks.
  - Damien Le Moal: Suggested min_not_zero() for nvme-pci (now moot).

Answer to John's question (from v2, still relevant):
  The SAS disks on this system do not report Optimal Transfer Length in
  VPD page B0, so sdkp->opt_xfer_blocks = 0.  sd_revalidate_disk() uses
  min_not_zero(0, opt_sectors) which returns opt_sectors, propagating
  the bogus value.  Observed values:

    shost->max_sectors      = 32767
    opt_sectors             = 32767  (capped at max_sectors)
    optimal_io_size         = 16773120  (visible in lsblk --topology)
    minimum_io_size         = 8192

  mkfs.xfs computes swidth=4095, sunit=2, fails because 4095 % 2 != 0.

Test environment:
  - Dell PowerEdge R750
  - SAS Controller: Broadcom/LSI mpt3sas (SAS3816, FW 33.15.00.00)
  - Disks: SAMSUNG MZILT800HBHQ0D3 (800GB SCSI SAS SSD)
  - Kernel: 6.12.0-1-amd64 with intel_iommu=off
  - IOMMU: Disabled (DMAR: IOMMU disabled), default domain: Passthrough

Based on linux-next (next-20260318).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/
Link: https://lore.kernel.org/all/20260318074314.17372-1-ionut.nechita@windriver.com/
Link: https://lore.kernel.org/all/20260318200532.51232-1-ionut.nechita@windriver.com/

Ionut Nechita (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 40 +++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

--
2.43.0
