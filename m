Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E804422B8AB;
	Mon,  2 Mar 2026 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463549; cv=fail; b=UCxaGxOljXi4wMcH5pEHWn4/jx2+nvkS3u6KerTNkTSaT4OrSwov+KyG1yRtGpw34rOZZ5V/0NwIQYItpaOlnqf1yF4osuK5nr9ln2qMM0p9Oi/ER/WsZzQp6mgtORBlMtbxSae7JVUg5fw7xBw2eql2Qu4LeLfmAvT853sjpPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463549; c=relaxed/simple;
	bh=K8fezE6KQmedgkfw9WG8OzaEap4LOWT/+w+KP5gIRuM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gXS1tbITdvpvbOhtbq9NmnVlMA7E86tTIF/kb7/EdwVhC1KW5fDjmBWy5mE3FkL6imkCuUqMnLzK4Twkstp4GQ+MoUWgpfkNBtLpe099Gg4XA5Ou7JHm5kKpWKPFGF/vm2e8WhOhTxTz4tPP2dnaxqkfEmIPrfLTEd6xHcB1lCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EGY04DtR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SbdpcqXS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EGY04DtR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SbdpcqXS"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ENu2S2394693;
	Mon, 2 Mar 2026 14:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kbqMbhox9pyMovHzi/pEktFdJhfLJiYDm3AsAHJThAs=; b=
	EGY04DtRLWmc03lw04BHiEAqKofPVSk1uRSjypzjoVm72VHbPie3s/SFZ3AcQcuc
	1409IdB+cglvLhQamQOC0lfgses2fN6d9Pb8TtpqHg//3rIRqSbUZTH+frjV1N2V
	TsrCAYzwEQlUUD1yy4u3UepXcCLhofvmQBjwXqjbRsLLkNtBhdfNrZd6LE8l92VG
	/ng4ptR98XtE5YSZEwSof0WMGy/SkUTRoMMAFcABx1dSufC9N9/oKohzvBDx5YLg
	7hUO+Vfj8fwS+tqfaWHUyEMT0DKIJ2UdmF48iAndSvkTmtwCEDVYL8JGw0Zmz14+
	4Yhn2p/Ssx7NrYOhq/YpJg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnann0a1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 14:58:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622DJmf6037876;
	Mon, 2 Mar 2026 14:58:42 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010012.outbound.protection.outlook.com [52.101.85.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdajqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 14:58:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADeAtnVREuuc8GnWNX+AzoL0fafjmHVydGfwyLLUgs0g6wxvsLky8s8Bz2aUkcxLxSMOPgGHlmajvSI/fm9C+5ijaUQokBtUk7aoQ5AtXa1ur+LXp9JwFlIDVcm3bGXC3HDviEN8JPkjZIYR0tJ9kJNQgxLHHIlT8Lf6VY9wMBG6xtD5x4M4LU77bNVR30l3LXxschx40we6/JFYhLiQhDI8ZTbQu1YyHeonhMvHTatauWKLDfkMtvmXn+ksWmuP4xZqzfxX/wKad7XkrU9FkmMlc65N3cM92gw16HpS+8VDb5trdHrX6A/ZO5/UofZrr9OwemNmHWk26pL6BaLgjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbqMbhox9pyMovHzi/pEktFdJhfLJiYDm3AsAHJThAs=;
 b=JbgGvAK0iIg9GM55SQBYd1V6cOKtXpHNYaI3M39htogo3OGSJDssH1HMpjY54PO7m61S2N+U+3sgZgBlCQE919Aibgm7ZvhVzulYDzLcw+FnkIsIAUd/mUBOrp6ZMdeMxv37wIS5C0gMj41xhPqShaGoTzfSO5BMcQB4KC4yoUG+oVhk0W8ZK1n17s7I8zkwDgKjt50j+VVRbSE3rSRrMWImow1NVFOab6asUiE9nc3xbc4KdWHzxInWJLeg/Nd/vIdtFvIYNM7UdTgyi6XcFCDwg3weIFb74YG/2vbyKPYO+zeMMYE+02rh6+Ya0sW2rA4D7bveW51RfbaBKzLjQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbqMbhox9pyMovHzi/pEktFdJhfLJiYDm3AsAHJThAs=;
 b=SbdpcqXSixs8eruVC8RS2o8OXkkfTZ4NDX1qlmwDd7d6HTfDEUg/i9XwvySSf5AyZ6H7GWhf3BuhpJviBUWOc1MW5Kfmf+OyM2N5ykPqc4lAtXtUZg+eDmVF38WyK2k/WapmqNBwX9Z4OTXPJ/Umq9zvDwsiGCjcopK6O0Zy21s=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN0PR10MB6005.namprd10.prod.outlook.com
 (2603:10b6:208:3cb::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 14:58:35 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 14:58:35 +0000
Message-ID: <69040b90-1be1-4b9d-8318-5ff06ee9f697@oracle.com>
Date: Mon, 2 Mar 2026 14:58:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] nvme: switch to libmultipath
To: Christoph Hellwig <hch@lst.de>
Cc: kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260302141206.GA23439@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260302141206.GA23439@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0518.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN0PR10MB6005:EE_
X-MS-Office365-Filtering-Correlation-Id: 62de0724-800a-4e4f-983d-08de786c2d93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	C/Y+A37thG7iceGbQAa6mLm4GO6bIAh7sQrH8MgQ/z6i125l8UOgLeYAiCtOrirssfYoQRXfwQKMfWC8LE1S26vio/GtcXGvxfrun6VtLWaYFEnwtQyFdAXidy8FATpOUcWHVTFrnwevkHAeuDb9kmtkTY5mgPGV4+Ko3OH5cI69AWV0TB3snJPbAcJyMgWVcVpGxwsU4MMiTxSD1REA2Dp2yXbS34FygZMtqhKs1ZUAsNJwwDC3i2kapA8M80Fwstskx6pFasJ+KWAgub1cy9P8IlI5MGoMQ9hfcbLPTrgC2iPEa/+PgsgM27OvSDFWvKIZdiXFgy8VxRwxpb14QrZxQ5HqPt5hKuKJU9kZ2T+O2mTstZfvKhcl7OISaaVi7uJP5naqOh6b5cQRqEQuXyLdLBbUGFjmGR/t+1M0ijmhlryTcCK6nPr1H7R9aJkJwByLk6W+JE/P5Qm7LyZiwnn+zMNHGSckG9bkSdZxD6QsE5/hNnTgtKxTvtTmoecUNH6zQnoes/VQkBgjbTrujEGIfEEXs0p1wvXRYNwIv20h2Lqf+hMm0ahnshaY4UtZAIDXhD1s3v3RGPz2sKQLlx3BjApZXOXswrk7ZK4F/yXvKsq5l38ZRD9uLK5UoFvZN8zjM/5VqY8NKB8kM3pU3sPdC0rXi4RNNeKe7K2eCPzL7QyDYrbkPdUTx1rc8pLQFL9cSe+i4usPlWl+H17Mr6BvopvrEWcLZMsPUs09J3U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnRkb1R6Z1lsY3hjTW1FYmk1cjh2L2dKUXJvd0d6UWdBQkFDWGtyVnVHQXJS?=
 =?utf-8?B?azVlL2lPV3I0MnQ3ekpkeU42ZmxaNlhBSjJJNXdnVVpocW1PRmJRZHp2d1hu?=
 =?utf-8?B?cjRGNlhFa0k1WGlBS1pESERUbHI3am9WN0V3UHNpSnllZTBlQmNpTFpiSlh6?=
 =?utf-8?B?dUJINGM0TUlyYitIU0F1YjQzQW5Ra2tOQldNRVREZEh2cHZlQW53RGo5M1ZF?=
 =?utf-8?B?V0huNkZnVGRBUWZmSE5ScC9MMk9LSDVFN3VuTXFDdmw1NFVxdFN6Ukw3NWI1?=
 =?utf-8?B?R2ttM09hYk00V0ZDeVgzVlUwL3pOSU5GemtoYk9Vd2JhWUtHUnA4eWlBOC9C?=
 =?utf-8?B?QXRPMWtkYTlwMDdqYWlBOGNScy9rZGF1WTJxaGxYczArMHc1bGswYTQvM1d6?=
 =?utf-8?B?MGVKVU1MTW5kVFJQZ3Y0WkdzUFluMXVPVHJ0eHpzN0pXc0J1RWVBeGVxeXFu?=
 =?utf-8?B?S1U3RWpON0pndWFXSjhpMElNb3d0czcvWGpHclVsSUw5Sk5DcjRyRVc2d3Iy?=
 =?utf-8?B?bm9WUVJJc280dUNZLzNLemRJalFQSVRwdTg5blBla0lYOEV1U29lN1I5ZzRv?=
 =?utf-8?B?cFRmUFFVdVg3RE9YMEh0a0kvRno3MklrKzNkaHVjZlVjRFRwZWJISC96ODJl?=
 =?utf-8?B?VWRpTVRsd0JrOG5KZ1BEU0xJTk85RjZNQzFxRURTazBtaGVCeVI2QnVEeUl1?=
 =?utf-8?B?bEt6UENxWk9iUEtOZXFMbnpzZ3Ira09PdEorRDZoMTM2eWRocEFLQ3c2b1hP?=
 =?utf-8?B?ODhFc3QxblRNbU94OWlFNURpMlg2bWkxVXREQkxSUndnQmxDL050MElsekVF?=
 =?utf-8?B?ZERaM3VlNXAwN2NYaFQ0RENpS2tGNEZEam1TVmFwTk1JbmdWdytnQzlwSjYw?=
 =?utf-8?B?cHlPZklIYUNUbnVrd3ZVTnFmUVBFUkNqMStMaTY1QUxhYnk4NUloenpwM25C?=
 =?utf-8?B?VnRQTHBQak0vd1hQVEdVd2pqTEg2VzZSdlh3aXFRZFBIc0wrcDNvQ2QwRlR0?=
 =?utf-8?B?NVRWZnkwQ0VHTnRqM2tiRTRsWTJzazZrbDFkcFYrb0x2S1FqR0ZlWCtla1hS?=
 =?utf-8?B?VkpybFh2K0VacmJRcTRsalhFcWFCWGd1RlJRUEM1QWpOc1FCRFdsSnZ0aFNl?=
 =?utf-8?B?VmRld2lBSy9ZN0U1aWhUd0tXRFFMcU52bEQ0U2VzK2JyUnkxRytvMmhiTmVF?=
 =?utf-8?B?RnhWckZDbXVlamFoRjJWMlRRQ1VqOFByYjkrUmh5dUFIZjdvL3NYc1FLSmZv?=
 =?utf-8?B?M2tmTG1maXYyMk1xZVpHeFNXYWhVdGowc28wUXlBdXpIc3J2OVVrRUFBdElV?=
 =?utf-8?B?dTBuUUFSb0dJSkkxUlZVV0RrYTBuZHNBZUlLdlorcTNTMG5vZVpTZzM0VW16?=
 =?utf-8?B?N2lJSXZOSmRiVXcvdmZObnhNV1lrbk15dFFLblE3cE5UQlEwVjl0d1hzZFRQ?=
 =?utf-8?B?UDFleDNhek9xYkN2UWdDbzlyRWwrYlRjdWpUS2RFQkxqdVJrSEQ1WnVKcGZJ?=
 =?utf-8?B?OFo2Z0l3VFRiMm9OVmlrdkVBbE9ETE0zR3oyZkxVODlJNXlRYjdNajZlMVBs?=
 =?utf-8?B?ZDNId3hMcHBpbkllWVZHZmxBV2Y5b2M0MDhXbkt3TkExdnZQRDRiVGVLU2JW?=
 =?utf-8?B?V2IySWNCZ2N4T0JRcGFJR2Q1TDc1bldqWEx1UWE2cmNKc2RyMmhoR0xtcUwz?=
 =?utf-8?B?ZmVqWDJ6RXk4YTRCQW1iWVVzeG5JaVlvdlFaNEt0cTd0dkZtcS8zZ2V6N0pU?=
 =?utf-8?B?MnZUVkZLbWRNUjJ2RzFQemI0WTB1b3lSamNLZjJKa1k2aW5UbWl2NFlQNzNk?=
 =?utf-8?B?Q0gxaysrMDQvNitQdFBYNGlyenU1YXh4Mzk1SWJ0aVdDcFN2TUZueUVFT3lQ?=
 =?utf-8?B?RGtnYWpYL29yZjR4bU11cVAvdjBScXlUWWx0RXJqRDdrbWVaTk9pemoydHpG?=
 =?utf-8?B?dlk0OEZVVjNDSHExc1I3Y0lWbVppRWxxVG15UE11KzY5eUF6OUJDNG9iSXd3?=
 =?utf-8?B?R1AzbW5FWVp2NGdadFBKb3dEdGVPTStQeURJR2JWNVZ3QUdjTENCbXB0OVVK?=
 =?utf-8?B?cVEzWEttckRjbXNVWDlWQmJqN1poMFlsSlc4TzgwRGE1dXM1WGRENFFuVWVn?=
 =?utf-8?B?dVJtdlorNm5XbUNwMkRwNWVFYlpEZ0pqMXBlWUlFcVhmSk1YMng3UUN1T0Ru?=
 =?utf-8?B?UGhlWFlTNVVaNUtPSEVzeGxQNDg1MHFFU050amhieGQ3bWRwa1NyMFdLTlNS?=
 =?utf-8?B?YkZuN3BFYWRoSVJHZ1dud1lmdmRTNkNpSml4Q3hDMkcxMDJRbjRoMzFXTVhj?=
 =?utf-8?B?cmo5dGhYWHR3aGRkWkZIdGtWMlRvMGVTcW1IMS9tUVh4VFRnVVYvWlA5Mm13?=
 =?utf-8?Q?haa8njd5ZCowgm/Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V8TiJHlBg34DTvtz6Dpo4mtW6V1ItvmmoJspjmZBblJ0zbkOnMosEuURkCaLwhIe9olFO4mJzRPdKFU5YiOtTRB6t8NCgXYlT9Du9YThZYGhyjAo6lc9zQ0BEgB2drva/LJgCJ2fPgooolyd+eT+WKFOVB1mwMP4berm4ODOt+wN6QJ/SuuwYrq96Ve8PaeQwUC0Jp2RmfEB3/2Re2uWdtyb4aTVRXwVCNcvMVAQmoITOQx7s1mKsvVUHWFTDJBxkDJjzG0zk6FpJLy6ZC3vYOXRfcb6/hJKbAlZAUo57uq24h8B+x1sCbIqfYPyRooQqAK6AvBZfRrWBm1NpIzsv1BxdHSVrUE1HkRjRFhkKXyZVduaAtD7tfuz5dcrSc41QUF8bO0u3scgsOVhSWrdN07OifOot4Oe9FeerOR8i7mGjyd93I0ZfWYJnosy7H8v/I1M2Zam2urTmbHOBzHl61mxkkK3IwL8NxnhgUdzMHNW1kUhic1Hmgjy7coZrKC2SOkOctBRGaxyPWisCF8QhtXRYwsm6fB3FEonpDTrclkjITOeaezTKJ02gHLxml5xioIPLe20atudXwUhrwXyJ6ydn7/beM2BIAHoQl9UMvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62de0724-800a-4e4f-983d-08de786c2d93
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 14:58:35.1922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvrJ2tbnTuQm1v9r+IMNwvmkcg2IEh33tR3pudS68JFXGoCqp66zieGZgXQElklnLvLoovQjRnt/tyQEboSDMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB6005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020125
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEyNSBTYWx0ZWRfX3/rqQkKqgFEH
 jTNgEXlIYNCvW0lvf+sBdd2ln8VAbqGKpZ7/u/KqHM6Uy3UY1cuMWZZrvEs/BHk09j7bK+BpPja
 SRwikvxZf/8BACemmDMTpjq+qF5WAfky6GXoyA6Tr/8+SFM+aSs5Mw2tYF5WsmZ2d7RM+1rIagO
 OmevwNP5H1ATryW7Oxh+C7GeHMrrjtgT2zsvQRd2WxwQNvyHovNGVDSZCfZWQhOww4OK5zzHZlJ
 pg1HtbYv2l1haTOHkbokwwE2Bs1CuKwNIIhA0rIdCUQF+inXICJ2u93ICMRawkgkwDYmarC1q1p
 LqUCwJvIUtrnm8fpItpBMzYTMq6JVdNomFEHEQo/X7x524fAJpHT5Z8vgNCBtr8frinoA7zz7fh
 fA78vvs56uPARhLFtzkZB86dNCYAsoGxChNqKGsclF6/dSaITnjs38xrdqm0YouLdhp0xBYmsco
 yJWmwSPv0HoEHghQLIoyBIzM5wgm1iDUi6kyH+qo=
X-Proofpoint-ORIG-GUID: BZnR7G9Se1b_UVsQd1IpsQbJAegBVmE-
X-Proofpoint-GUID: BZnR7G9Se1b_UVsQd1IpsQbJAegBVmE-
X-Authority-Analysis: v=2.4 cv=Q9nfIo2a c=1 sm=1 tr=0 ts=69a5a5a3 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=cEYrepEvNO7bqJQquuwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13810

On 02/03/2026 14:12, Christoph Hellwig wrote:
> On Wed, Feb 25, 2026 at 03:39:48PM +0000, John Garry wrote:
>> This switches the NVMe host driver to use libmultipath. That library
>> is very heavily based on the NVMe multipath code, so the change over
>> should hopefully be straightforward. There is often a direct replacement
>> for functions.
> 
> Given how little code this removes while adding the new libmultipath
> dependency and abstractions I can't say I like this at all.
> 

Yeah, so we're losing about 300 lines here in the conversion. However 
nvme mulitpath.c goes from 1410 -> 1250 lines with this series - that's 
not good enough to justify the change.

In a quick review of the code, there is more stuff which I push down 
(into the lib). And a lot of the abstraction code can be condensed - if 
you check something like numa_node_show(), there are 6 variables needed 
just to get to the point where the common helper could be called - that 
is just silly.

Another issue is just that the remaining code is NVMe specific, like ANA 
support, or just doesn't fit the SCSI model, e.g. NVMe iopolicy is per 
subsystem, while for SCSI we don't have a subsystem concept and I so 
made iopolicy per multipathed SCSI disk.

