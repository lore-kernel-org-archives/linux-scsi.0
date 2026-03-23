Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A0138838D;
	Mon, 23 Mar 2026 09:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259857; cv=fail; b=XdwpFaXu22La501zQGrGZzCI18ONRHdjBaHIyUCkDzgId+Z7/czAPZ+ao9oe/UPCttimRjW2Kpmh+qBJ9oNeHdV/ozAEhRWTCyO/eIw5N9tFVXwHeIis2M6bZu8snHX5qLvPcwnvvn83g9B8VMCgv418LCeTHaw55q/aSv5eh10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259857; c=relaxed/simple;
	bh=Dto0jo/al3SXdqj2vX1oIKtgJ60DYuJyNuCezgRbsr8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZvfIQYtuRakE1TMWiKT5Hv9ZjbfKfRW8YN+Uaj5I1hVM6t+9S51eCeXOSSVk2WK1pmS51yQEgVwNatpbwzAu5Qw7Pv+CtEfZCFIps9XixEgA/7JThdM6YYcQ6ODsdhjKhpLQO5/k1lGc85AwfeAVL5ILhYJxVP7xuTwM/7ppLh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HHb2lkBS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JW/13TG+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HHb2lkBS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JW/13TG+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MMdPMV3143003;
	Mon, 23 Mar 2026 09:57:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Sm7mFuJg6s0fRm7gJniH2EnKJ5Si1ont45Kb9GuZun0=; b=
	HHb2lkBSWxjfY0oXmh+SHvvARB2ojldu/F4h8RbRkIGhHsfysl3x+yPkgUJK+pD5
	Gf8wUCySROw+NzL5MGAo9l14RBrnki7zKVbatejsiHHYOsHus0aKJXy4aAvyE05o
	0sPrcV4+xJ4I8uWwxl5ZdZ07nS/PmkzKDRpX4V00jOVEheGsRm8K080sQPHX+Jey
	RPq9y1e62PIBsKkBtmQZ20ztlE8X6N+xNtIFZwnKh3gzqsEr/GOSEKBH7ezbTA83
	nBA8OSX2Os8fkNIZZxK5Tmj+qYx7e9ZIGQ40hy/8BvzA75XdwY78wEMovbhkeML4
	SDHynHL0fs+pqZktt0XYBw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1khvsy6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 09:57:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62N7K5Yr000619;
	Mon, 23 Mar 2026 09:57:22 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010058.outbound.protection.outlook.com [52.101.85.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs892cb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 09:57:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oAeQILmG7Pvnpc1KkVFoPqe9X6l37pyclJdpeptoEOvzEbIwqrYdhGk+i2nKV3/x98Hy7Fx/8SXEidYG+SkzH6Jsgb+jB8hk+N++puaNxzSZaeODn134UYfv9UW5chBlYaav4o93O3m14yntbCeZczCR+iaCTvp0pk2xItPX4/gZ/32KwWqnKk6AcJhSpFhyI2E3qkTFWGlH/mfU/GLVw+LJIklAVGKlM9+6+EglQj7UKOimXgILmnph0nmprNoi8uM2tszX6k2kmmxj8OcZQvLAxupnPEERNCJZAIESj3lz+SB/p49XcXRxQx81qkeyw4DQeQ+ceICh98F/5Ti6yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sm7mFuJg6s0fRm7gJniH2EnKJ5Si1ont45Kb9GuZun0=;
 b=MkvlgCRllbLvUpzE0HFTmFTifnydO8UWBCZgLDCH++9C7a6m8oNSG7ggLT2k5IJKt9qDImlOcwAPVBTto+1HcSCixnHn25ziqeurF56OpXgIHeaXoMWOAX0+w4ziu9pcqXw1vNL8788t8dZc0xpcN2hjFUzSN02oBTxbTeF7dilvijUB7jCIvIeuyccoSKKrT2bsjMCdKG+ljWm4SGWrPfIz5gKjrtiZTxQ/JLPsPoC/nm5GpTdCUx+840GdG2QRb4ZycmCLkSwSxjX0RZCP+FxTCPWH3NZ3GR1DxW1kjar7iHWXgFeGFuY/lS5uWKgVcnQe7tXt8mkQiIjUihuL1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sm7mFuJg6s0fRm7gJniH2EnKJ5Si1ont45Kb9GuZun0=;
 b=JW/13TG+o84gVtAQ8Pte/UJpYv0w7oaOH+0WdA0gTbIR2UagjsIz1rCxJq6/PCD5K/26fZHlaYgmB8Oe8DHZ2fhXP4TTawybzWFlsJ79CTYeiYuqTFkIl17qECglfwY0lAh87+qiTo0CfZmgY3HA7/Cp9CayVwsdptrag4Px1Hs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA2PR10MB4746.namprd10.prod.outlook.com
 (2603:10b6:806:11c::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 09:57:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 09:57:18 +0000
Message-ID: <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
Date: Mon, 23 Mar 2026 09:57:15 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acAo0hr4BxXueQFM@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA2PR10MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a6f4680-9b9a-4a53-6da4-08de88c291dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	vk97wjOkSUVlvrxl4Wrez5SuKkis8wf/sQUnWISWpaHB5nE26ANmrD2Ey737v/hi6ot1IhxYpTqSfiAX/R4cjRrWhbXi6DRJ7FQX04uaxTqoknmh5I5OIk3UByXtul8jqpVDLhP/otw1M2uwNcabv02VBznkBkiZbMwOkyW/zw3tPag5PJzBnlcJWva8kUVzlZCAYDltK1QFpz3LaIv0Ok56fnNXle2Ko6pmHLDb1N3y0TjOel92RBLtqKR5WmR5/HjvfsZARfhm3lI+eoN3DfJQHiAZvUKGthoZvsEs0Cu6GUxVsRFykmhjEdtF7JRLBl58/aH1r61XB3UToDppM6eGEtNwVDWS1ttg0nm9D3sE++Sz9Ulv/fOJf8pkdAeSV3C+Lr7iQIpu96aZ8s2bMMOdoTm8YIr09nAS9kl7L6YdUIqUr6XoYNgAkvyUMdoHTYLzrFfTqlMuMLt1rWPv4f0ool6LE4nAFKwYPz+dPmLIfWFyvbs3GDuVgXwrxnKEnC/OlvhCL/zc5dz1nP6O/e7GGAhB8n2660jMLBtzDmvnaY80bVtuRCsSlhbuJcuvjUgeyZy9uZVg7LBUwn38FrIeNlQX10AZ0j2q79ow6BWmmV5PljlG65LfZLF5yYUSP7pl/YvPD48BpKvHKKhRl1JFjBnYp63z2vkOynH4EPZzMyOv8BssVfXFLEsjuZwgTkDP6SwiadnKEgsfDnZzmump5kDIQO39nz5526KTKoE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0VoV0kyRjQ2ekxHZmxtRFI4RVFHRlFNMk1pbHIyOVhSemJ3QW9jUXVIWTk0?=
 =?utf-8?B?UlB3dWpiQnJaV1djT2FpTTBqZG94NnRZTk8wRWU3NElmZy82WFhZRXlzTWk4?=
 =?utf-8?B?SWszOHBQWG0xWExzWDZKajF5TnIxRmpOTnF6TEwwNFJIcHJ3R2FKUFpCUmxh?=
 =?utf-8?B?R1p0ZmtxK1dwQ0I0TFRNMm5KRVdzd0Z4N0NYVi9JRnQ2Y3RncVpBanp1ZW40?=
 =?utf-8?B?Y1ZKemIrSUhHT3I0UE04RlBIMWdxZDlnWTgrQndxOEtzd3gyU1VjSXlkdVg2?=
 =?utf-8?B?R1pFbmlyVmtBOEVYQ0hiK0h6SGZ3Q3dNRmk2V3Mzd2t0cWxlYkovUWFWTm9v?=
 =?utf-8?B?YjhrWFVVNEpoclBTTlRZZkt2bVZhRGoxdEtQVjlvT2xWWE41TmJKRmZiNE1h?=
 =?utf-8?B?RDMxV3FydVI4a3V0b3JXZnJERG9ZUzhWdnFqb0QxYXBxRXI3eTJsRmRZVC85?=
 =?utf-8?B?d2pvSWdUNms5SGtId2c0REhxdThDNVdxOWN6dkZiL0VtRi9BbTMyUytBaHdP?=
 =?utf-8?B?bTkyM1JSODBxb2NHRkc1ZHYyb1dsMHB4ZlFUMlVCT2E4ZlgxWHdteVFMVzhV?=
 =?utf-8?B?Um5FaEpFbXFmcWV5UTJtaUtUakxGNU9TajdZRkFCNlNETkJaVDF5L0FKTE1O?=
 =?utf-8?B?dCsrd1lSa1RyWE5IdjdLdU9iZzhxTFZ2UGtuVGlKaWhwbk1QU3dveWRZUHcv?=
 =?utf-8?B?Y1NxVWJlOWhmNWI2RzQ5TmdteU5wSXcxOVZTQjdEYTlhU3RKQlNlMjZTYW1N?=
 =?utf-8?B?ejVpbk1MRS9wTEZCODE0YmIvWTA5N3RQUEpzc2xqUmZVZlA0MmhpZi9HV1RV?=
 =?utf-8?B?ekUvYjFVZG1UemtFRXNQZUFLdVl5aXJMd1dTVUNNdUNFMHBpK0dJaEVHcE10?=
 =?utf-8?B?clBEU25mUENLamlCMHQxbjdkMTVjUkdnRllLTm1Xd0ptS0JQWU1TK3l5MCsx?=
 =?utf-8?B?TVBCd3ZNbGJNUmZKSDRocHBRYVhaWkZrYmJTMkY3eFZqbHpMSm5UbHpoaytU?=
 =?utf-8?B?WmtITDRzbE1vQUJDZFU3Y25aSHVRc2l4b0tYZDczVnA5alZCMU5PSTRncmdk?=
 =?utf-8?B?ZGpMcnpZYWUybHA0bXZ3YmNPS2cwc2drTkF0U1dKUTQyZ2dBZjI1SjJiNFpJ?=
 =?utf-8?B?WGdOV3hyenBGN1c0Nnd5OXlSVjhBVTVTY1c2N0phSUtuQUhiSzV2NzF2UEdt?=
 =?utf-8?B?dkdMbWhzQ0liUitjempBT1dVdDlTdFpuZG9NT2F5OVlSeVhlYVN5T01Yb0Zi?=
 =?utf-8?B?V3REUWl1RENDNDlnVDArSWNJS2VwY3YxSy9GbERldk5CbHd2dlc2SVY3UlFY?=
 =?utf-8?B?VVpQaHF2V2FrS2c2cFNZTjRpU2VEZEFvWWlJQkZPN3M2REdXNUsvMERnRXV3?=
 =?utf-8?B?MGdvZG1XOHYwbmJrSklMbGtESDJuTmdVbWthVHRxRXd3cTJMNGJaQk8rdXFu?=
 =?utf-8?B?MEpLYXlLalJ1K0I1djFrZmIwSW9reUtpOEtLSldLcFpVcjAwQnNOTG1UUEZR?=
 =?utf-8?B?dTI2am9nYUdqZVJYU0trd3ZqUkNRQUErQUM0d0grdVI4OWNzMWxjZldSclh3?=
 =?utf-8?B?VkRiZy8zSWQxTEo3eU44SHZPTFVhR250cDFqZFM5cDk5WkNDUXZYN2tIU1dY?=
 =?utf-8?B?T0VVeXlzT0xoY211LzhjbnpyUU9XdW5waVVveE01ZWdqUHMwcTBTekUxR2xz?=
 =?utf-8?B?TnduUzRzNjdJR0pTV3NTNVNnWUpSN2NRTkdycFFiaEdCMlAvV3lqditlTXdx?=
 =?utf-8?B?NGxXMjQvZUM3TWh1R0NnUURWbnNkdDVBbEpKN2lqMnVoQTZac05LcjMwV2Vp?=
 =?utf-8?B?Nm9JbkM3TXhzblpET1ByTDFDek5hL2RLTXdRSDdET1JQcThwTVVFR2llYS9R?=
 =?utf-8?B?eXE0Q3ZtenFrdlpJRHJZWHhTbTU4d0tURFY4Tm9jQVR2cUo1eGZVS0lObVpQ?=
 =?utf-8?B?YTkwT0hCd0doclQyTUtjUlJSY3pBamNnbVZmOEl5b2E2cjc0ZlY4VVBLdk1y?=
 =?utf-8?B?N0E3emxJL21UdndaTG52Nk5FRElxUWVkK2NuU1oweFVsaFBqSS9sNTBoWXhj?=
 =?utf-8?B?TTlZZEpFQzkzZjFnbUVQcTIxNjgwbmZIZ2l3V1VjVGh4T08rcWQ5eDVxVVZR?=
 =?utf-8?B?VHlLWnNUMDZvSnQvcittR2NLY2lZRmNDZkNDbnlNa2Z2eFlaY3lodkNIRHd5?=
 =?utf-8?B?dnZlZkNGcFQ1Rzh6R3ZzMUlBbS9vY0plTXBSNVYyMGl3d2JFNm56dEZtY0RG?=
 =?utf-8?B?eko3WUE1aUZlTW5UVFp5dEg2VGt3TzlySlhMblpkUTkzbjloRmRxL3UvWUlE?=
 =?utf-8?B?WmEyVDVWV3FLbUE0TUdVMlNaYjhZblpEZDdaUmtzaUU5SWY4MGYvdz09?=
X-Exchange-RoutingPolicyChecked:
	X6Y5gvK5DUeoW8VS1b07ZsInLVj+gaKIPNUn85gCuH/qxjL267CrdshvsXj8pVusaA+wUtauM9A+waXrL3M7JIfSh1vIixONanJ7wp2UquLXtKSS/o6yKpKJgEI30xv9GkxZo1/mCaGKHwChawEbdDEPgxsaws/FqhFGPHPiCsc/UvGPJ/PK2eEIb3m0/4ImEOSN2MNcYo/+0wGoijpPmNWmiUsFxQnbdH/k/UjOxTCer04FkvPfmweXrj7+fgjCUBfhnSQr5+oQX7svtk+T1vuf7MaT2SOmqhlulpvDF1XINNvLaJD4XH1dFEcWD+wS2aZmWwtr1zQkW4jETLiKbA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C8RFv3CmLafwTdDN7U2oiMpV4oOIPMxA7W9P2zC0nPVy88/GpWUFjb9sTfO+FpqsyR7TB7iuFTxTGjNbJHTnqDuNO6c0I1vlAJY+FyFlXKXY6j4UJhrMrMVbSOXUk4rKAPWhQDp2FgXPH7AuPVyIuCj7RLMoorzfxapktZyL3lmpw+MC2+L/IBKjiRV7Y9O+Z2i0DbhlFijxp93JoeyZAL40LnvySFDFWCjFbHQm8hBchlRsZIaN/wngLrUFI09nt2vFJk3lwNmeTM0h/pxJ/M+OsDJRpmmWbQnUUH8oGooMZJTb7EXsPrRgmwuRCyIogTZuOChraLyXI53VeUUiyq1h+EC0EEFbloFcRXXvz/kHQx2Q3EuzpEC3tfJefdope/YdF6g2+O1wM/AdAKpsHcvOAW1Ee/TFOLQ5TWHPehNxAg42e2uKiCnSZRCc8uw1bK7/r6avEw+ohpjW4rHnoHr8iHgaIzmY1LOsoTYhXf/Zm8de4wf7p0wT15FhQwqhAAny/seouTrTPawBV0DN43wkSSapJhVf7Xy9Vfcwvc47Denx3ahfaFEgMu9+BvdczaMca0ZjAvD2T1dFdUCRGJ8RqGJ/m5iLxt1ft/Mr1do=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6f4680-9b9a-4a53-6da4-08de88c291dc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:57:18.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sp9aLsQOEasPfQ3ORpS4OrNmIYTGUqQ7uuQYFh18gUumVzNftNXfy4I/G8BZ3ZuANox+icRj3yXI4yhW3cdifg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=989 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230076
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3NiBTYWx0ZWRfX229Qoe/ahMBT
 y1j4+uJca6/lfgPSuKzRckJm5ZPaz6Z2YpOzMUIlaV9cEPlg2L5D79Gigr9ICxOBZDXyDwd7tb4
 XB8UYRpKJ4BN/0kuEa9BMTLw7IBKwXD5G4stouKJjd95sYj7OVhr0tylXh/5Fg88bZJDXpjFgGE
 tWygHR7IprLPuQ8q18pwLy9u2oEQbOy0QHdyDhc0eiM+VNZ3uiCbMikUN5eKPvz2b/cWREhWFWW
 UMhQInxeQZTROwlOccFy5VyUFPCsmr2lk9wTEM4bnvL510vjo/gjpV6GjfmbGnKZYk/d+ogQrJm
 3Sh9qk6pzKvFOofoOAz/GXYlzHDEkd6xT3AI6CNQlb3muCRgOIvd5QaIcyMrTuAH6HRktYvpngR
 dsMqgvlbZCiVe0OoG2R5yIEnRr2q0RBIW5y3Wa/ihJeCs5u3lCru8bQBX4QngFDB98xJrF/AXDh
 Ml8jX4oozXbFpDBeebw==
X-Authority-Analysis: v=2.4 cv=VIXQXtPX c=1 sm=1 tr=0 ts=69c10e83 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=B9RD5g75Ysv-OWcPL7UA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: MQh7xqq_Hhuk0awXQ7NEiRjhUdgv5Hpe
X-Proofpoint-ORIG-GUID: MQh7xqq_Hhuk0awXQ7NEiRjhUdgv5Hpe

On 22/03/2026 17:37, Benjamin Marzinski wrote:
>> I think that this work is a real regression possibility for
>> dm-multipath, so we need to be careful.
> At the risk of showing just how limited my SCSI knowledge is, I need to
> ask, Is any of this actually necessary to get native scsi multipath
> working with Implicit ALUA?
> 
> If the goal is to limit this to IMPLICT ALUA only, I was expecting that
> you could just leave the scsi_dh_alua code completely alone. If native
> scsi multipathing didn't disable the device handler, it seemed that this
> would basically just work. With the device handler attached,

We only get the scsi_dh_activate() -> alua_activate() call from 
dm-mpath.c, and that callchain could not happen for native SCSI 
multipath. But, yes, we do the alua_rtpg_queue() call from a rescan, but 
we should be checking if the path is available first (and not rely on a 
rescan).

> when the
> array updates the ALUA state, that should, at least I believe, trigger a
> unit attention that will fire off a RTPG command. That should update the
> sdev->access_state, which the multipath code could use to pick the
> correct path. Right? What am I missing here?
> Is this just a parallel
> exercise to overhaul the ALUA code?

The SCSI community would rather not see more usage for device handlers.

How we then get ALUA support for native SCSI multipath is the question. 
My original series just really duplicated the scsi_dh_alua.c RTPG 
support for native SCSI multipath into a limited "core" driver. Hannes 
thinks that a core ALUA driver to also support DH would be better 
(IIUC), which I am attempting in this series. I will re-iterate that I 
would rather not touch scsi_dh_alua.c, unless the changes are simple and 
obvious(ly correct).

Thanks,
John
