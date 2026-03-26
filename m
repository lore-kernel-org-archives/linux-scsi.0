Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1770B3BB9F8;
	Thu, 26 Mar 2026 08:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774514845; cv=fail; b=g0oktjEyBLyFXAxU4LHJ6E/l01PREYX++CDVw4njWrexLRDIReYMLShwKOBgAuvweVjb2vfE1GL+972PtTX+olpkCFVcZbBq2QKA+rkbb3dcMgsWGaPSyH0cLgnlBqF2vwJfPuHZt9Tq+4ee7qkhNaz4kXBgvH9JSivOvhqWvmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774514845; c=relaxed/simple;
	bh=ipgPIcj+es1/t9+o0FPuZUVdMdfG838U5x98iZV42zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VaxxSDQ56LlbFgYnKzSPI1krhbKipRfxEdrLVFpkHZPmLPTGYpUxWl9c1Mpz906dBqhhjdNy7ZBWm71kTPUbMzGGl6hTEhu70CUc1AGfnHzbABUOVAQ3pB0U7Vm4AMx2hryUyDAWQOK17ED9JtCSioeIynO41oXRfXfQ8IdWPbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=RIwgQeuE; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="RIwgQeuE"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62Q5rODt2097709;
	Thu, 26 Mar 2026 08:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=Z3kqtiyZNCm/sSuse5SB+yDUe8xsO3zcpIF3w/LMV60=; b=
	RIwgQeuEpvhHtJ3ERoNi4CwZAsD5H+S/F6IwrvbJWNX6sRdmFS7wM3RHQVUXSvWi
	dsB3GxSykEbwjelWDITSl5M5oJ51H9SPDXsfa/VdOvvzy+YnKws582iX4SVc7wgt
	/24zTA1HVSIt7BU1gtltMkx71hmhico/xspYGo9LNaGEu6RGz2SNeCBhKRwdRD3c
	uqMzdi6gMQksn3O4fr8gwRd0WJT/bC0y2kXp4lGtsSGMa1bUtl3HA8Cr5NqlgYbY
	rB3wUvzN9QHtn3bHoFmxzGWy5bCvb3eAumq5fdcSTigl62ZlkRwwrMDkGosGVq1P
	TY+29evny1e0A0yp8ErU7g==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013066.outbound.protection.outlook.com [40.93.196.66])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4d1gj868v7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 08:47:03 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXayM7+V+jZCqKcGkOrxWIu146tT2tjH5Qeout9e3UO/59HCtlIRq/Hwt4w0bxHxKZdoD8RBltkDLw7aMGc0/DhNaiOXkoOdHTBrvcFugQCp9H5k/r63br9mcCw/5vfo5Auil3CPbs397SnbkWahzyz3RLb7rAYUyM6nT5fsMa7iVj+8wWr7vqyQkbI9nzKQOmJHQQD88UCtc+J5pv4gwYa8O8SjBh1ciGITRd3Wb81stWcvEHd8jOxch/XEX8jHbGuRTd47wEXpoJVzIQI9FFuKYwRy5Ul2TESugTlRKV7pYPVcs8f7W3ikATS/wikQqlT7lqKNBj7ioqytGvmxKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3kqtiyZNCm/sSuse5SB+yDUe8xsO3zcpIF3w/LMV60=;
 b=bTu+lvrwbrg+YjwqJ8G6JG6aRBfniovAvDxLGlZy8xsCuTTL8t3ak3nlznfeU9b6CmzH4s3O0RSss+OH3I1+zblnxeMQ1n2U2SOU73LwKKtSAQ0BHSCwch6hLa2MwwMGlunYLJOlRwuKJZ5o/zW8mW2VgyVZVdOq/VW6cD9SVkDHtYJl6zQ931ivVWQT+O5OCK36H2IOJxsQ+njx+3BxFHtBp2u+zKDEBEnvh45BJt8U61PeAfSuq7SJb/JQd3B+Lg7gNJ8cEjOaMkHx1ZnHtys68KD6FYuVG7yX5vNn64BRFzpDw0FRdp+gqC8+oN1KF0LazIu4+mcijbmvKv9FcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by DS0PR11MB7406.namprd11.prod.outlook.com (2603:10b6:8:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 08:47:01 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9769.004; Thu, 26 Mar 2026
 08:47:01 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com,
        "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Subject: [PATCH v6 1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Thu, 26 Mar 2026 10:46:44 +0200
Message-ID: <20260326084644.27162-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326084644.27162-1-ionut.nechita@windriver.com>
References: <20260326084644.27162-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0372.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:82::14) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|DS0PR11MB7406:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bd8babe-6961-41fa-0c10-08de8b143f2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|1800799024|366016|10070799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JngH5E5lqHDLB2PhWqkITSpFHMu8+ZpkJECusGfnihJ5oJ8nvwFl3PyBwLmj8aq0+jnY4GH9peGkYF65RzdU2/3LpBzQ3lNaDbYIvfDw2XX9yQK3aHHbI8jhGsZkxz3pzibyeNdr84HEpSKJInsPjimPTF8Ez08mWwyVJiOqq9f+IBODbJ0nqLsvJuyyXPDU8BmQlLs/eX1dATndw6kPxEDDDyMUVmAgnSeAB38bv61MOOtqMNG/sl8P8feNTm4Xu+QX1WjNhD/c5/FEETwPnXsNpFBzPPRx0DGxc5U2815YhOm7tR/4/zRJ/l+H2cOsVirG/9zkq+VnPSsipmjAt8uWf1aNAGbC1LIGM9Qgsv0ikSx+fsOjgDxKBLxiMaKxPpIROGbqmd4Bk2drVpBlXgMlfVKid0ltqzS0Hc9TvKrYcWHfWTyjgdYXErlJxqair+QedCzPJq0XdzJwq7PT2v34pDt7Ptg2+n5kul4zFL5sipDGhuFMAxRXFEme+ZRp+gvNtwYmL8rCgRzjviMUGmByCvYblNNDu79PdB+6JbxldAQOQmDBDrWtQ3zdfbyUFPnwkPFReewSdP25QXXNJG7t5vas3JRnb4AXNJRAUC8lhWPltoAkUdpjkduFqpmYzQwRvS0Mzi91uEpg59NmRsAec/zPqIfIfZZ0DcayPcVOO1iqG57dW+tn2/JpGUdA9rAYVOseq4OLI7wdqDUbscF4lvflt3FBK4Qqnyibj5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(1800799024)(366016)(10070799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2hkZi9IZmYweXd4cCtOR2plMys3bzYzNmdVUi9LSWU1RDRwMnIyNTJkMXFK?=
 =?utf-8?B?R2RZb28vekVtUWdYSllxVkxoakpkRFZ0eWVjWERVYTBpVHo1M096dDY3bnN4?=
 =?utf-8?B?c3p0OWZSSmMxbzRpRTd4ZWtwUFg5d0NkWlluRkdTSmp2WGRiOStrUFJucUF6?=
 =?utf-8?B?dzhKWHAyaVBxS3Z1WmZVTUJaUjd0VlFJTi9wWGl6QjlTOUZOZURVUi9qSGF5?=
 =?utf-8?B?TEd2Qzh6bzNWTTZEejc4MkNzcUM2WmNheDVkQ213UWNreS9xRmxpMEhNOFgx?=
 =?utf-8?B?cGN1eEZzVEhzOTRUV2FiYzU2QmRUdEw3ZFByVlRmeEorOWdnMDM2VEJWQi9R?=
 =?utf-8?B?T1N4QnlqQnNOVWJwaXhCaUV1bHR5WmxMWjFBbHlOZmRDejdDZVhlUjhyK25T?=
 =?utf-8?B?dkNRK2ZHaVZKaWVaZllzWVppay9uVDErcEd2U1J5ejVENG5UOFFZbERiWmVn?=
 =?utf-8?B?UkRvZEJTeXVrWUt2RUhIYnhQTlJUVStNVXc5Y2tFM21RU0xSV1llbERHRmZz?=
 =?utf-8?B?N0FFQVN4Qzk2MjJtem42UzVsYWl0R0lPcVNXeGpJNUJXWENrUVhTR3NjeEhq?=
 =?utf-8?B?MFp1MzJmbEFkbmVTdFdoQzNqR1JRREo3dFp2RW85MVF1aGRzRUNDdTYrRi8w?=
 =?utf-8?B?T2ZqNzZQaWtRWkQwNkZsNzVra2xzcmZQaW1ZNXlON25pbTl1Rk5DbDF1dWh3?=
 =?utf-8?B?NU1JUitjdW1tUkpLWnY4MEFEMzFPeFZtTWR3QkFCUE9CN1kvOWxNaFZGbTJs?=
 =?utf-8?B?emw3WlJwQmtGa1FvU29mVVYrSm41N3ZqelJmRUIrODNCUmlIdUsyL3JrSFAr?=
 =?utf-8?B?KytVQmJlOHlEMDNYNU1Cem0wZmlIV3dhb1lFVHhnbTdVK1BNN2szSFFHSTh3?=
 =?utf-8?B?YWVnemIyR1A1bTBtdWwzNjhVdkt0WG5rTVZ1eENxOVZIWmVIZHQ1cVNLSmJR?=
 =?utf-8?B?ZS84Nks4TWVjbzlpbHJOczA3blMvMlpDVXhMbksyVFFIaWsxYVRCdS9ZMW5N?=
 =?utf-8?B?ZGpYZGxid1loQmdWbDlMZkxaUVJUWXBUbUNYQTFhdXZ5bU52V213TVp5Szc3?=
 =?utf-8?B?dkk5VENPUmcrZTRBVks5QlA0M1pIQVNiMjRFazh5enlGRXB3RU11aWh5WnN5?=
 =?utf-8?B?UThFWlUvL3Bham5JajlOalpyOHJ0RHdUOWxoOFQ3NTlzVEZjL2xwWkFvbjdz?=
 =?utf-8?B?VWl3elJUU1V4eEJ1NG00dlNwSmRLMTFhdGNRa0V0QXoxN1JQKzVQUHB6WHJZ?=
 =?utf-8?B?WitLUERvaTIrMW80dFNaSTJ1WHNIYXJWSFNHMHEvTXdxWWUyenRaemJ3ZXY0?=
 =?utf-8?B?YUdzRjZQem5rTzVQczBrVWVrY1FSdGpuYWZDWUM1VXJrNjFSYVdBRG9Edkl5?=
 =?utf-8?B?eWk0cHZBbmxlVThJbGFheDYzUHhLQlJOWmNUck9QNTdiUnRXcTNRYWVnTDlH?=
 =?utf-8?B?WUxtOWJ2ZjR2VlFPanRhaUZPYTFOeWFodHNUOW05L1NzL0d3eC9SQUp5YTh3?=
 =?utf-8?B?c3d1MHpSTE1QcjdCTko3YlgyTENlaUx6ZGZjYlBZODlyV1JJTnpiWlhOSFVS?=
 =?utf-8?B?Snh2UVcyUmN6MnlDUWFYV3hteUE5UzhzcEtnVjN4aFN0K2g3R1QwRVcwY2RV?=
 =?utf-8?B?bXdDd2FZcDZVTjcvSWtraEZwZHora0FhWDZWcmpSY1p3SFZidXJpWTl0VzVq?=
 =?utf-8?B?bENCWGlFM2N4N0hRck9iNVV0NlB2OStDVVdhVnRibkllR1A1QS9IcjRsV2l3?=
 =?utf-8?B?U2tpVFFVOUphN0cvaFU1bFJ6ZUxqY0VIRXhWNE5sSkdMbTRVVXdmTDNONDZs?=
 =?utf-8?B?WlcvdzUrcnExMlphVmVaQTNidlR2VXRFN3VTc29GUGZrU0NkVy93YnZhNjZC?=
 =?utf-8?B?bUErT2VQbVY5WU5VK1NtZWtuMm10eENsYmplNWVuMXhBTnZyN2hSNTZQN3JZ?=
 =?utf-8?B?dmdSWFBwWTI3T21Ka2svOGI5ZWtZeU0rUUZMUndIUUVqWG4vTlc5ZFRyQ0hY?=
 =?utf-8?B?K0dFMDNpQ0R0QmlmMjlXSkoxOXl1azZDNHN3dVRGT1ZTdlNWdWZyOENycSta?=
 =?utf-8?B?ZHFYQVZER2dhWDBMaVNvZmE2U0F2RVVyQ0VwN3M5Y1ZJdUxQamlzeG5pcUJF?=
 =?utf-8?B?VUJua0t4OHp0RDhZZE54Um10ckQzNWVxbWZFT2IzTGFKVElTZkZ1bGZOUHJq?=
 =?utf-8?B?Qkp3WFNqdTFtVEpnSFBmVGtEZmZsY3lCRTM2KzY4UmhObjlQRlpWbU1weklq?=
 =?utf-8?B?UXBoeEdqMWtvc1FNU3lDS25wb2JIaE12U2diN2tDanFGNVpNZmNja3lzYlVt?=
 =?utf-8?B?cWZRY0VIMTQ3UW55K09JQU82QVc3R3VTYmJPWGYrRHE5OHRyTnZ6N0VPa1lt?=
 =?utf-8?Q?FHH/LO86mFzEzpaAJML2MqvmF54zdk3cURxySsD0Zktn6?=
X-MS-Exchange-AntiSpam-MessageData-1: zNhV8LlMUcB7Ke6UHvtYejUYHkj7odtOnrU=
X-Exchange-RoutingPolicyChecked:
	shwoo6/gNQwUdRhTSrTpc2ieDT30hdC4Qm3VuBMlPwZytRG1Cra12KzA6QLsEVm1bZLtTU7dP9QmLTMq0GIsdanvZH6Cpg9C/NcyzfJ5ymSjDn7fke5WS5yeWLY8u+MoXBRjk6Bh2KTvgvmFFa1OJvGAd1vjv91+Xg6+6Fon35k+Yu0AB/+Xzv6w9S7OZKMCJwOgJfU1sIPdnn38zTk9iUxlpl61w1q8sjh8wtVAFaHdxY74EjqvSW6OxGl9flqLsD0jrEv37SgxhOkUyKMjJo7Cys3fQxSw/oNTHbJy50HrrqsMSPz1ZfdiWY7tEYkytPrFcCkqvGLZICVEeenNEQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd8babe-6961-41fa-0c10-08de8b143f2a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 08:47:01.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HWytMFY0e8aVoz0S1G3BEth5LNdXoxbaIK+ZhHJLksNuASH1iAhTqqg0lQsOgDLiDgrbHM+9m/cykh6rKGHMX/d3NMR+lUh+z/TtDOowaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7406
X-Proofpoint-ORIG-GUID: X32qEgIWsCWvz1FbLYNFYQdhU1x-val2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MyBTYWx0ZWRfXw96BH/BhaF4n
 dw2WpFad3F5TCxC7y1oFUmZVI2IO5AiGaAji8ckmm1WMjLjVuh70bOrM27uzZS8FnKQBcYmFfQe
 dtPePK4wfLm2M5tfWT+Hzyu7/8Y2i/5sZ8x3ffdWKKoaDeHT+gNRk7G0PTnw9Ekx5jjfxFJLOU3
 BNIxc0x46nveDpnM2pOdTpNEdWv3Qlwx0BoBnEHtiTdGntNEyyEC3fXZyeqOZZ+6rX9FIJ4InKU
 CGBoRPML68rYbuCJDA3TEzJj5wlD2uzlopYMF0V8quZaOjHIYqR/pudwjfrjuetFpW/x9XbA8ZZ
 MpZfoyS8Nuq0+ikTM2FNVSI4mNHNFCGL1nSnaMg/GVPAK1eQOvaW/yLfN+a4rCnEe4Coi83PLbL
 HAGLJDH2YFvDFscecrpjuEEVJ9VYzc2TKQozhmD8sdjtnJwIIEhjrj0wSNH0OVn1hPsIdi6uNZ+
 9AFp2F+OCQLZ6LkG3gw==
X-Authority-Analysis: v=2.4 cv=LtqfC3dc c=1 sm=1 tr=0 ts=69c4f287 cx=c_pps
 a=yvofFnGdSAaTKL5iNkS0vw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=mtAXYDBbDpUEqFYiRnoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: X32qEgIWsCWvz1FbLYNFYQdhU1x-val2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603260063

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
mode and no DMA ops provide an opt_mapping_size callback,
dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
which equals dma_max_mapping_size() — a hard upper bound, not an
optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) does not report an
Optimal Transfer Length in VPD page B0, so sdkp->opt_xfer_blocks
remains 0.  sd_revalidate_disk() then uses min_not_zero(0, opt_sectors)
= opt_sectors, propagating the bogus value into the block device's
optimal_io_size (visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by introducing a sas_dma_setup_opt_sectors() helper that
sets opt_sectors only when dma_opt_mapping_size() is strictly less
than dma_max_mapping_size(), indicating a genuine DMA optimization
constraint.  The helper computes min(opt_sectors, max_sectors) first,
then rounds down to a power of two so that filesystem geometry
calculations always produce clean results.  When the two DMA values
are equal, no backend provided a real hint, so opt_sectors stays at
0 ("no preference").

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
 drivers/scsi/scsi_transport_sas.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 13412702188e4..fa79a0883bb3d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/blkdev.h>
@@ -222,12 +223,42 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
  * SAS host attributes
  */
 
+/*
+ * Set shost->opt_sectors from the DMA optimal mapping size, but only
+ * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),
+ * indicating a genuine optimization hint from an IOMMU or DMA backend.
+ * When the two are equal (e.g. IOMMU disabled / passthrough), no real
+ * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
+ * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
+ */
+static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
+{
+	struct device *dma_dev = shost->dma_dev;
+	size_t opt, max;
+	unsigned int opt_sectors;
+
+	if (!dma_dev->dma_mask)
+		return;
+
+	opt = dma_opt_mapping_size(dma_dev);
+	max = dma_max_mapping_size(dma_dev);
+
+	if (!opt || opt >= max)
+		return;
+
+	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
+			    shost->max_sectors);
+	if (!opt_sectors)
+		return;
+
+	shost->opt_sectors = rounddown_pow_of_two(opt_sectors);
+}
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct device *dma_dev = shost->dma_dev;
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
@@ -239,10 +270,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
-	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	sas_dma_setup_opt_sectors(shost);
 
 	return 0;
 }
-- 
2.53.0

