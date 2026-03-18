Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B6271448;
	Wed, 18 Mar 2026 20:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773864410; cv=fail; b=ML9IYBd09VWmKjHBbTV5jrjjcstV9xYUw71Oe8GBLdijDMbJJarvCvQ2sBm1jchXYrIiQRkViOskrmYySOUFD2IMQOswW6Q3ChvauNpd4rRXPYMcGcCNcxoPmEqoZr14/LktopVB8cKXtTcimIsrQNm5oNNymz53BJc6gNqjuSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773864410; c=relaxed/simple;
	bh=CAWEvaAJ316+gYnDqMHiauid+orvVyqAxa3b65Y6TOI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=s6TV/60Vqy56Ge51Ky7dA7KEco6EYzPOVrn+fSCQbfzJsDWf5h6ue1W3WqvwQZHuMOz5MYgCXKfWnKMen29r3AO49JH9MZJh1OjZGUS8YSUyV9euebAXf4Q0+wasKFpik8TeC9uP7qRqHS7DJQ1pMumf4sRt2SwI8Tp/3LL00Uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ZbU6aKfn; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ZbU6aKfn"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I4ThbZ3789154;
	Wed, 18 Mar 2026 13:05:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=uqdbEAoQC
	4sLcy4g0gH+xjP+8LUmokvLC350jaASy64=; b=ZbU6aKfn+SnE9b2/N70gvF0Gv
	bRj7y5UE7wFibsObC75DN2m/6Fh8Rue/cKs2WOrS2uIXm4+yN64b/8jqaPqbVSGF
	raZLpeMYc4UzY1HCVZAQzi4VcP1erE6qUxlKmOq69JCQU/IqQHRGgoCQwC4qm/0f
	tx99LCtBkL0G7jTW/4UpLPDg45vzAsIvJMSh1/6Wb3gQrThlgY+l4Q6cPD4HdrtZ
	88WYFu3ionfLmiQ+dd+Dd/srOVq+eoqPC0b5+n8fLrQkt5UCIdPJrXIYvMEerIl2
	F+zD8k+HWzSv6JR1ObPIpjHAA8dC9f0ZZMX3t7rjcHkbA+fwELvG9tZHkt1Ag==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010057.outbound.protection.outlook.com [52.101.61.57])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cw76dw4k6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 13:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aFrlVF5bFUqgFkv1M9xh4afwtbwLKCH1HAA7Qex1soLtgWjXS+Uf/lz0kD8CdbuaoUPwbmjyTEfqKamPxmAZQQgPAAUom6KsFc2gznYwLrPtUWWytdLH6RFRE/h1xPwRsuDaiv0Y2TdEevJSM1948AOFRckajf66x+O6jylbv+8y9phIMr99sK+Zb44oQJMlULi2y2dDuemhNPZGPLzG8y0Vsx/L0cYtOnCSu+9SG874CEwcI6/BuZXBaDOtyPEZPMV3057jh1zhz2Iyq594YAe/DX+FKL1hXU4wkLJGVNN1KznwfTDctbYSXN6zWzrZIj3N8eop7RHNJD2+EE9HZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqdbEAoQC4sLcy4g0gH+xjP+8LUmokvLC350jaASy64=;
 b=JWp0BSOE+hoJudFb1soqxdLxCOfcN0gc8oaw8GTHSp3mzrjZyZLdrbhwbJ6flBmO6OL+IbAlFXOEX0xTzd+dyDGl+EAQqEOnMGNs0tlxgCxjaQQZyHuLd7zynpMrd9iN5oSfLBKgWClyidEeJa9DCZo/xyzJhkiDGiH7JzAdhBucq4aCvtjwVy20RKPu9M60J4AIMsvlJWxCkn4Q8erDAS4npWzk7+1CfUqfXIiGh3UaSXvAWOhuG4l176wGQlrx/YJ213gMDo1n3al05t2NcqFQN+d+SlWaHGP3UkV6rH4yJkA2YFkwNtEEC/U4+S7cV2GqKjXKf8+HOD1T8tH2UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DS0PR11MB7409.namprd11.prod.outlook.com (2603:10b6:8:153::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 20:05:50 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 20:05:48 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, kbusch@kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v3 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Wed, 18 Mar 2026 22:05:31 +0200
Message-ID: <20260318200532.51232-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::19) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DS0PR11MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: e6886e76-ea24-4171-0db8-08de8529bef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|10070799003|376014|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ssODObNS9jeNhRIStnQMDhlIqho6pYplzi8blziroPCzDscNHMIYPGuUSyKlcq500DTnvE0IdzI1S0X/Dx60jieVY+Cma+Fz2T/phxRywLVaMUc3cS34+yeAT7VQ0ijOBcYHASbTM0BGLpjxSc7xD6O/p6ri4wNz/qU03zESV421zepga/F8ddInAnyGM7rAHT5ju525IuyYumPvbvPd0qDqpKfrawkUQPWAlqvCTN/5SDzVCv78DjExBwTdzeA+07ItcD+jt3cr1g30tJo/Dkm3YtrSTrQ7Fd1g6faDLwiG5IGfLV/ryCf0i570II8wAaM6LIJnvkCiFNDyrE6qAZ1+PRrFyswSRdlv/9XMMZhZAFv7Tux3jaxzBqowf9KNQ5r6HlyEyw2hI6ojumOAZi8STTfGTJIwHPbFiylHxv5hYfBjXVo1PUlDCgRyCQKpDLBFEl4GlIXFqQJTIhy5WCa0oGIVJMmeL94hKceUczPQHkTZd/98s8+CnjYlnGVAy8gHj775ezSo2WLA6TXKENgbNgLrh9xpj6GLjupZQwb6ybvJFpT0bCETEfnLB+H08Mvlz0TcwzMdqCwNIxelAceFH+cCHk/M8xEdSXIQDZlec7Edhj9mPxGKrQ807sbB7DW15j35IOwKGbEjMtVjYMtX5r4HnmQaOrHypAei1iNhSiYCRQseAYuNSq/1JyY1E+4sJtEo1BQ+dooNJiePdhkr1SZcOYglxX6zhH33iFVDgTA6mBNBO3HhHq7Qxe4+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(10070799003)(376014)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0FCUjJlWXVNSEk2d2d4WmNtZGF5Q0hvQkZkRnc4UE9LbUNzYlBWV0l2VHZl?=
 =?utf-8?B?RmFUbnZINlRaUkplU1NWcDZxVUxKQkEwRFNzQkJDL2FJTHMzbFVBTHMrM2hy?=
 =?utf-8?B?QnQ1c0JmYUpaOUxNUWhFSlA4MEFRTmpCZnVhQVREVFpqeHNaQXllaFJRbkFB?=
 =?utf-8?B?MnFsUTZyY0RrMnVUN2VFdEVaa3d1Q2FoZUhTVFVMWjNQNm1YVVpoVS9kcDgv?=
 =?utf-8?B?dXJacE00Q1BZWG01TFFEZFZlWERTbVdubmNsSGZvaEFES0hHMXFNdEUzUW1l?=
 =?utf-8?B?TkpIblMzTmhUenRmdUs5N2dkcUVqbUp4SWNrUzNxKzREK3J0TkFKbmlqV3NS?=
 =?utf-8?B?aWs2MGhjTXZmMjlhc0kzMDZzemVhcmpkZ05FL3gxYVdRVk1Pbk1TRWZGUjAx?=
 =?utf-8?B?TUllMEh3SjRMZ0ljUXhiODM4Mkt3U2ZhTEVWWFNIcjFqL0RSZ24vcURwb0xY?=
 =?utf-8?B?Y1p5YmhTTnR4bmcreTVWRnZlUCtBTG52WU5lZFU4OUhlVTRrbmNsSEZiL09s?=
 =?utf-8?B?SlhWTFltRkRmRlNFOEJ3NVJhbTRLZG5oK3pFNTJOWVlZVlR5SXhCYjZpZXRR?=
 =?utf-8?B?QVJ5SUFWWDBodzZwQnZlMFdRelJjUTZ0V3BrMThLcFBEQzJpVFJrcm13a2JV?=
 =?utf-8?B?bDBBWmZqRHUzcmJjZUY2dE1ZL0ZseVBwSitPWGduNk50R0l0UllnVGVGdC9t?=
 =?utf-8?B?cEJrblV0UWRoTWdTa1E5MFZjWkY0dXkyZ041ZS83V1o1R05ER1drMjRMRXFO?=
 =?utf-8?B?cWlYMU1ySGZvY2VGQlRhRzVkVmlRSEFSeEFVS3ZWMUhrWXNyeGhRU1NoYVNY?=
 =?utf-8?B?dE9MT2hweC9Fbk10SmRqZmJGRUh5aFlDbzE2ekdkMUJOY0tRc2NmbWpIVlNO?=
 =?utf-8?B?aW9oNVVnOHcxOUp6R3QvZGcwRmZFYWNZK0g3T2dIU3V4WlBlTjF6cXZkOGxD?=
 =?utf-8?B?T21QdXYyRkNlRWU1TnQ5ZEx3KzlqSStCemZuZEc3ekI0dWYxMXl4NHE5TkhN?=
 =?utf-8?B?aVh1YllxQ0FPNUVPY2p5YjREVmVQWmwrWG5rWDRyNW13cUhvWjUwczdwSStD?=
 =?utf-8?B?S3ppQ2FSSG45K3J5WGdScU52ZDBOOEx6R1czS0M0a05UTDU5M3NmV0t0eC8v?=
 =?utf-8?B?Y3ZmaVdjUXZhSUkwK01HYUQzR0tYTUF3UVhGbFVaZis3RDROUGFoUzAxRlFx?=
 =?utf-8?B?cnJwaUdIZUpTb2E1M1BnYlVUbWhhMzNnczIxQU1mUVR1RUhueTNMb0JPSXE4?=
 =?utf-8?B?Wm5qUDE2UTJVb1pudDRUdU5md0hrMVExa1NuaVZSck1KK2ZLYXB6Mno2MlNy?=
 =?utf-8?B?OVMwVFpLMzF6ZXp1UkJMangrVWpneWs1dlk5U1pQb3JoOTJFdXNvTzZkemRC?=
 =?utf-8?B?REgwKzdzWHZqRXkxQTFjclhLSVpRa0pwU205bFh5TXV1a2xtNjFjcUh5NE5I?=
 =?utf-8?B?azZscGVBQlJrTUR5YWU5bTV1UTA2N0ZDZ3EzL3hhZDhDeFUzREVENnNoRUtR?=
 =?utf-8?B?UEFTYWlha0dPTG5rbXZlRURuWElzZ28xUFZKczBVUkd5YTFjblN4SUt1cUxq?=
 =?utf-8?B?aGZ4YkJoM2Q1NUUrV2FndkZiSjZHdXBIMHloZUVRcTdLbjd4encrdWFYVzFi?=
 =?utf-8?B?bWY3ejJUT1hBN0ZxeUVpZVE1Y05JYkt4cjV5QktmRHNtYzZuOW5oTFVwMXFB?=
 =?utf-8?B?bnhtbjFOaDlUbDNrTjdJWXV6djlHODMySjJpc0Y3c28zN3ZEZmdacWtBYWRl?=
 =?utf-8?B?eldkV2RxRkRUOCtDZUY3NWplQzJtbE9XdzBtVzBaNVJyeGhaQjhOeEFIcHJp?=
 =?utf-8?B?QlRIbkYzSkR6Y3kxVFJ0dWJaejJvQTRSVENqWnhEeUpzRkMrZ0ZCd3ZaNy8r?=
 =?utf-8?B?MkdzR1J2NXFlQVpVeXZDcVdkWTA4Nk1mZmkwTlFwYXduallIZEN1QmtROGgv?=
 =?utf-8?B?ZXFKTUZQa0VweHo1bHNLMVl0eXdyWjVWS3BUTVBQWjJZb0p3dHNMK1YxOEV0?=
 =?utf-8?B?dE9uSVpndklwRzhxcHlVb1E0QWpJUDk5ZlA3Q3VOVjNiQnhDakFxcEF4ZUIr?=
 =?utf-8?B?cmF2SlFSN2xtNTBzM255RlA1V3ZpQzdHcWh2eEx4Y0ZXa3BLK3RHOEdyYnV0?=
 =?utf-8?B?R2orRklwUURTL0RlT2h4MldqMDZmRzRsdzJSL2NVcDI3YUFvTHhLTGo3ekhD?=
 =?utf-8?B?ZWR3cUFuQ2xNLysxUDhkS0MrV2NJaDVHU08vU0FtM0xLcDI4VWhWT3F5VkhJ?=
 =?utf-8?B?Kys0MFlRQm5jWWt6Z1dVZFVmYTBvSlBhWG9NMlpmZ25XN1BSRXo5bEtDQWY4?=
 =?utf-8?B?ZGw0aFBWTFRvVmZnTDR3TjNOTUQ1ZXRzYXR6SFl4cXRmdXl1VHV6ODdsa3Za?=
 =?utf-8?Q?ej1Q5LO7wQVd/8zE0cTK7WOCpHAGl67CWjoO6utxhMMM1?=
X-MS-Exchange-AntiSpam-MessageData-1: FC66yrgJ9cLvYJoglkHg8fpHYSMqiEaEDlo=
X-Exchange-RoutingPolicyChecked:
	U6EYmmTyspOtZqs/MfqWSaxoKGVPos63ZCqbhzxz6laY57FT9ETNUhkAtn8TrZLNkoLDrW/YmJkbMPvAtSgOQgH01OyeA0q5Cl6R9/PoGA/NcFxJOQnoboWYU1EOmjjExR8LzqmR6CZmLCUx47j+RG9dGpCabYUASjSdC3n8pScHnC9aGgWAiyLg8uSEH2WrkY2qEfui1EF05Ow7Wzt/tbXxMCZ5+8fp8zztLnSU6+B6NBSMd6IFgxKjKvrBMMSb0gk0KFLGFQgxx8qSJRHlpfq04tldr5yOh0T1yIyatCxU+/EErKpFznGw66+jTbV/JjKGEX+5Dt3LUhu6Ev1/Gg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6886e76-ea24-4171-0db8-08de8529bef9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 20:05:48.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4147i/bCtmlK5T9GnPDO1Vr+830XrEoGjLmimRBMWpomfGKEXMmwm4CVUTLXfjOqpGkUetJRbrD3ZDkjbnOfAFUW/um4U8cLA+hjgazWg8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7409
X-Authority-Analysis: v=2.4 cv=S9nUAYsP c=1 sm=1 tr=0 ts=69bb05a2 cx=c_pps
 a=b4Rf/daEBCJdqA7qdazqbw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=ATXrihDLxW9Sk9wyQAYA:9 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDE3MiBTYWx0ZWRfX/UEevV9TTATG
 3Z/h1Dufpna9ChwD7gJB08jNXVP7wskxWD3skoGX1Tbeu6TXOk90iYbo1XAUczO0ID4+LroHtyO
 yyhjmWNo1OKGCgofbZzBo+iwRX13kDOexlZ+W30WMKdrKLh3GKv3DhDSrF4VQPEUM1pBo/bGGw5
 BRP00bkWB3qu59K/u5fHP1PlSnn01vwH1pnDZ9ybJdfANezy8V5PhTISxxwWlpbtQd9KBuglJNA
 qXMvI2fp+HOuaGHZoHo61D+tly5GcvzTTia48u2WSlKOu/QHyGUSMBW1/N/MUQ9LAt2RdDEcteX
 hSk+9WISDhwNy0XmLSKsx2ihHs6oKQuhc8xsRqJGP7kJk3QGd1qaLwUorUe7vrlE9wVBdIMX5HD
 3Fromi9GAaNq02tTu8auYjxdVnI5ryxO70hYO39gl3gphqfCiFeLOBtRA8bWYMm4uMeAJUvTyuK
 ZErPvySXA8WWUZg7SHA==
X-Proofpoint-ORIG-GUID: fJ9ZEwIxvLtAs6NL6mfCgeeXguV-LE3C
X-Proofpoint-GUID: fJ9ZEwIxvLtAs6NL6mfCgeeXguV-LE3C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180172

From: Ionut Nechita <ionut.nechita@windriver.com>

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
  - Single patch now fixes the actual bug in scsi_transport_sas.c by
    checking if dma_opt_mapping_size() == dma_max_mapping_size() before
    setting opt_sectors.  When they are equal, no backend provided a
    real hint.
  - Added concrete values from the affected system (Dell PowerEdge R750,
    mpt3sas, SAMSUNG MZILT800HBHQ0D3) to the commit message.

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

  John also noted that io_opt should ideally be a multiple of io_min and
  that blk_validate_limits() should enforce it, but acknowledged that
  doing so would mask problems like this one.

Test environment:
  - Dell PowerEdge R750
  - SAS Controller: Broadcom/LSI mpt3sas (SAS3816, FW 33.15.00.00)
  - Disks: SAMSUNG MZILT800HBHQ0D3 (800GB SCSI SAS SSD)
  - Kernel: 6.12.0-1-amd64 with intel_iommu=off
  - IOMMU: Disabled (DMAR: IOMMU disabled), default domain: Passthrough

Based on linux-next (next-20260318).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/
Link: https://lore.kernel.org/all/20260318074314.17372-1-ionut.nechita@windriver.com/

Ionut Nechita (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 36 +++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--
2.43.0
