Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11783330656;
	Tue,  3 Mar 2026 07:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523934; cv=fail; b=AEaHFLfkMcmxUW3nm6M2NOQbvkd7HrOtZJsZ4m1NSnVir8fRvoyV/mmfK/G799IITmd97CmUEvZGqo+R2ij3+TqGg78gIbK45hRLg8+fKgfPlleCugynbzUhvpxe/rsT65r+sBddu4dSdoGWqqNgN5BPO7tZZTe5XE/ejyqFOzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523934; c=relaxed/simple;
	bh=BZvHiZWRwHjX3LBB/saTWlIFWTtllBk3L4QEVrFVvLM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QVlBvutxHsuPE0tOPDjNmR5+5jEEnNEr7MexpMzD04WSkFAuW8vWaPmOitYHEapHKfi5fNSAdzlXgp1HQ2iUHPiWCN8GTHX69TB1kW/kPwDUxUY1qgbdu10IrsyG9vlS4KlF+wFN+gGy0YqTNyeh1+gewqo9qJBR0Ox9JB6oeQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pnjoAu9P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bSccECb6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pnjoAu9P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bSccECb6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6234lJqL3821682;
	Tue, 3 Mar 2026 07:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BceM0Vm8O0lEHsnv+mArLeKE93e3B+mHFVqSV8Tlq34=; b=
	pnjoAu9Pcp9O04ZH5D8jKpyiXel0T9KUKMpJZGhfQcpE92j2W5Px3fQNX7zLp3MJ
	awM7Nqu3c/aYauml1bUgVnKYgriJS6eOqvVjUj/06QVQd3ytxNyGMLqCfYoqGiz1
	76a/eDA/GndWPwXXK/LymQPYno4HWT4Vk9bMgzte2/n8/T6FxD8fOJYZgFBiOuuf
	CX+rNeC+INomI/joRQdAtaFeRFwme/DLhLQNHcVoxK6SJki32IndceqKVpKeMXy0
	iJ0cPv0wB3GQuU9tKjayaO3MHOVn9ke4rExwb0ZdjzBla947Jf325p9DHSJSLL7M
	Qe1I4cKXfw69xVlUwN+0Bw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnrx305t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:45:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6236t9Bm035232;
	Tue, 3 Mar 2026 07:45:10 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013029.outbound.protection.outlook.com [40.107.201.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpte0m2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:45:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ub4nO4l1csYIuyoNclXX54j+TG95juuu4qIfJdqREM/Mnq8tWYDknwmSD4BbR3TUTGisPZLdpidIgrb5T9AFvgWr02tuyJEolyNM8vB6GxS9aBA8vaK0Vr/ye/lTrRx6yTQ+U0uchO9uAqiDiR+LOGFNpmIqVMs8fmzPpJEXO32xWD6PF6ZI8OsW4i1S4LLWToDE8pF6xtclSyMifeTST9ioyev/moo/0z1HlyCeMHsbL/qfjCHyElS53KC5ZoUVzoECuWkRkPRLTu0Eprqtlc62NrAj2HF8XCQ76kLJwUa091+EOvCEsc2cvu+JDN/q2kmW2EPSr+lzQE0r6vAjSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BceM0Vm8O0lEHsnv+mArLeKE93e3B+mHFVqSV8Tlq34=;
 b=v1FeDZBEvKBxyiANXzVMM2S/xDAxjURqFbvV9zbF6vIJKoPH7187/hNJ+GafG+UTo6KcTXbQNNB2ZBpsVIF07TLcRsJUcY1D3KJPPc6yTAKiumKVHADX/rAvhfnd2j84D7cXUgZut2ooBO+vQBxHx6xDdqSyPIfb3WvfvLVeVikoyGF+BVmZcRyAr6n0WcZAnkt75TrQP5+lAZOXL/aVvHL1twRj/HUMtK693nDjtIelxZY13f9WboyzBGA+FsGYBomMxncMc0/Mfg2wsRIgxpVpsr18MTztoKx9GOdyScv/N/Xk+why9sDXQ7230WxtQHcXKNxE9QPAf/VarzYI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BceM0Vm8O0lEHsnv+mArLeKE93e3B+mHFVqSV8Tlq34=;
 b=bSccECb6MeIExBiXeJgoD19cC/lQozFyQGanKTz+eVkFIAB0/XcUtldugoy1JsL7mqQCBxV31Me5Dcr8UIi4raCwj+8V5CLriLY2nxloeK3NPPETvCaNiWzj4GONEiYQxBnUDL80uWYT95O6lywZuHOuKtJv4sNz3jg0ijFM5EI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4965.namprd10.prod.outlook.com
 (2603:10b6:408:126::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 07:45:06 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 07:45:05 +0000
Message-ID: <bf4f8e96-7cc0-4a9b-bca2-676dcd0424c2@oracle.com>
Date: Tue, 3 Mar 2026 07:45:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: add SCSI_MAX_QUEUE_DEPTH
To: Hannes Reinecke <hare@suse.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-2-john.g.garry@oracle.com>
 <d79cb9d5-8935-45ac-b2f0-f86f0728bd8d@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d79cb9d5-8935-45ac-b2f0-f86f0728bd8d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0670.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4965:EE_
X-MS-Office365-Filtering-Correlation-Id: 69583912-bf8f-4e80-39c1-08de78f8c8fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	h0rbNhIrOx5XU0HYmQJU7a0TY3I7tANbArYkiYCKhgFnqIt/RBswapxa3+OfOWb6i8hK1XNP8qoXqI3zHx0did9f2Mzl+luX7yOLr5BhgVp1wbK7tZ55M+4ZdGiiPprptyApKJEdxm6eU3XeF1dj9LPSWlRgyFfMi+2pXsO1pCGRtJLOSrad2QxdSMPZrVfqcgvFaWC/t+m5JiqHYHKYvcoR+FwQyX92kJGUEl+M9YIJm3/VjHea4Y/fhY6z0zQr6wgs3gx28lvEm6uthppwhOFGwLFq3j0sX5aoywULTdiYSHosaYMejoUJN0/gUtug2LMYbBVBNBNaQd6/w/VKoLI20iuW419nmZpO9DKhWGPBRJLU7jmNg6/a4S1udBpucpiLNrXGRSXLQdUnnFea87EhU2yuk8iCQPj4bEqnTHTzIT7Hys3vRvJ9mGZ/iOnH2i1f8f22e4ZOCiO1MYLGUpFIv6FBHbn6Akuwr4Naqyy7xefTxcpYvgE1D7gh2Sv/zrYxNFVicm0NAF87pBUOYPhJmxBjxZmFWK87lENlzdSgjfXNr4IGLsDE0DQedZBSyxEHJJSKhazlhBu3A4aGIELpUG2ZCHafJ8Ko7CxRkC/clxlJEyRKy9Hw1Egd6ly3PXPMRcNMN+CxUd462wpUNKN9XJcVSHfr4REkRa/xsBf7wEB73vlrrot1cd830pN3rzAv4uWNKu7Fl9NRfRuFR/u90yw+52gHzitBHXpBYm0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWxiZ29MZ0VDMFV4WWJkbGJaVzk5b0MxSDlzanlYL2lVa1hLVTBEZTZuUlJi?=
 =?utf-8?B?cEQ0YW9FV0NZNVhua0h5RGVMbG9uUjZJa1U5SnNkck1CeDdFVlZjc2YwQzEx?=
 =?utf-8?B?YkhPRUkrY0FFc2lkVTUxdXIrbEZLbkMvdDBGci9MTFg2azY0dEQ1THFOUThG?=
 =?utf-8?B?NXZ6cWI3NjZSUnJ0SmtaT2tqTlF4R2h3dnhRYXZmNlBvbExYRXQ1MHNqY2xM?=
 =?utf-8?B?d3VDaFRBYVNQZlowOXY3Vnkvdy96SFRLSFNXZm1Ib1dLdHoxRGEwWXN2aXlw?=
 =?utf-8?B?QXdqZDJZMjdqY1JPK0w4T3k5cEl3aG5vem0zTG9qUHppUkltVjlkVG9hd0E4?=
 =?utf-8?B?RFdaQ0RxWFRkV2s2czZPVmttYVdKY0NLcDBIRGJlYmdxWFdYRTBsU2NCcUlE?=
 =?utf-8?B?NFYrS1dwSC9mYXlsemd4OENxNUU0ZFpQSFRqSWZOcGZKa1p6ZnBUN1VWWGpH?=
 =?utf-8?B?bXo4Y21tam45WmVWY21BYTFIRFBZMXBPN0p3MitCR0g4S3ZJWmtTWkJ3UVdC?=
 =?utf-8?B?bkFpWXN2TUJubzI4Q3Q5OXBERTlMNE1FSWlVdFYxMTFoTkNVY1ArZnYydldY?=
 =?utf-8?B?d3hEVVFZTU5TN3BOaGZ5aWUxWUN2cXoyVFJIQU1pd3d4Q2wwR3lqZjFZWWVG?=
 =?utf-8?B?UEpWdndkTzJNU1ZHanlrR0dJNlh6QnphU2YvZzI3Wk1lUzY3ZERWSThQa1dY?=
 =?utf-8?B?Ny9CT2tON0lJMC9aa3V4SGlqaE1LR3c1Z1ZaRE1zK3ZWLzIvNkJQTzg5MGN1?=
 =?utf-8?B?MStzdU12OVV1dnIxVUw4bFRlL2ZLQnpvSFQ0a2xMbzM4SHhZOC9tY2Z0bVF3?=
 =?utf-8?B?L1RiVFp5emF1blExcDdnR3VwSHBlcEdoQk1CQ0JkdmNXS3ZkSS9aemNabEZm?=
 =?utf-8?B?Z2ttNnFkRnZ3bVhrTXgxQWFEL0FsWnAxU08vdVEvc2hDSXhoWHArQURQSTFW?=
 =?utf-8?B?aU1GTEVvOGNTakdWZTJLWStsK2Zkb1dYQXNGTFB6aHB3eWNLNmUvMDRLRU1Q?=
 =?utf-8?B?WHNVUTlLNVpaRnRzMjBiY24yTGRmWFBEVTlsaE8yWEp1ckNnbnlDZGh0dmFM?=
 =?utf-8?B?bjE4dlJjYkhwYXhHdXZoZjZmaUtORldqbVgvSUxmSWpMc0NFNU5FYmRZZHFz?=
 =?utf-8?B?NUFYS2tQWTRhYnhWNTRhdlcvM1lwWXo0Nm85eisxbUtMVGNhVzhwdVVlYkdw?=
 =?utf-8?B?TFlRSW5ONitXMEhJakt4ZTRRWDBSTzVYVU4rb1JnaWo5SS9CUkxjQlFLeFpR?=
 =?utf-8?B?V1FrY1dZdUJpdVFpb2VvSnNlbEc0S3RDSG5oWHFNK3ZvSDFqV3QrM2F5L1Nl?=
 =?utf-8?B?N253NE0ybG8wSFhzaE45aVVtRnVlaFk3eTVKcHNqaDdod1pSVDVMdWlwaURi?=
 =?utf-8?B?TWJDbi9PRWNBWGV6ZzE0MHZnQXZvWFVlMWZKanR3Z0FaMllJUHUxeFBNMC9m?=
 =?utf-8?B?OHlJSU1GM2E0OC9ZcmlFZ0gySVBRWHAwVkVVdWpZT1IxUlNCanhtV2ZIczBF?=
 =?utf-8?B?d2FhVnFNdzR1OXdmRDJtL2hwNW9ITk9GcG5TdjBvdHo2Z3d0V1RNTWtDdCtN?=
 =?utf-8?B?bFFBV2h5dmtmOEYvbHdzenhPZjZXRExRTGZldnpWMTdKeGpvcmJQRXNrT2Ex?=
 =?utf-8?B?c2RpbXd5OThrWkpZMHNSZ3pTLy9pZmJ2VStybGhSUW4rd1JCaU1yR3NDMjdK?=
 =?utf-8?B?aWtNc1lQckF3RXVIblVhQ1NMYmFOU3VTMExBektwTUROa3hUenppMDIwRmtB?=
 =?utf-8?B?NFRzbzFVMUw4bEttd2dta0kyZTBYVzlrckNSVzlGalVHVG9UNDRiZi9SdGdi?=
 =?utf-8?B?RzgyS0RJTnpwYjNEYlNwUWFXRkw0RUVqNE5nbEc5YkdUMmN2WU53bHNYU243?=
 =?utf-8?B?TlJRQzkrQ2o2MGxpaTVTYnBXdlRBci9uQ1FuVzJlQUR2c2hhcklhOUVkaUpT?=
 =?utf-8?B?VXg4Rm1zS0VMUHAzQlpGSVNadllMNnRGa1dKM3NuckQvR2Nnbk9rN2tUNmxX?=
 =?utf-8?B?U2Rma1Izb2FnUkZQak9DVzBielJHRFJrNlNrcVA0WitSOEpic1ZEMlBtTFRq?=
 =?utf-8?B?YlB2cXlySVpreUlMbWVsMG5PL29yZjUvV3pLclRlZVNRNVJ2UkJTam1rTlky?=
 =?utf-8?B?WW42bEJDaWk2ekk2b1F2amgxbElKNFBlSEZjMkFzcDBmUEVkRlRkSUNxQXM2?=
 =?utf-8?B?a3dWZE84dDhIdWVLNUwrbTJMUmcwSEM5L1pmOUlWQzZ2cGZ5bXJ0ZmYwM3pv?=
 =?utf-8?B?MzVwa0hMU3hDTzhQcWN0dkNmVFE5L3BBTWQxRmxMUUtycG14Q1BuMDFlQWZP?=
 =?utf-8?B?M25ZWUNpYVhzZ0VSb29oRUt2RlVBdk4vUFlQbFBXY1hFUGE0dy9BbUE1bTVZ?=
 =?utf-8?Q?mTPyj+vdI6/Jv0Rw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QswZhOCK4w7bjpnXwX7n4l2AAyr3N0DeTcvk29EzBjLSHZwwZQaFGvEeflD5AmeFbhOwCevI1cpnpCRPFNh+53l1gPX+SEVi7zhp1OpUhYwKxZVwVJYpjPOmcG6MYrtUfej0gQwDNeTOIFvWLOAjdf6e4It1qfrTp1PH/1bb+0lzM4l/aI0DQVzH2Jd2BvQSWv1m44KECwg2kJb6qeALEBsT1nQNAWQy1uA2KSFikRq2+hWQ0OXHV02RfmviRA7ZilqJTp0tlDrHJVuRInMbePJ7/T3/kcj1me8ddcM6S8T3SUon8j/jeyzN/h0m/eNZhy14Xasozv20M4DMOB7HWA87JxH6rczNvM5ZYZgDIiYKmMyykg+zmZhQxZruSMLPeUtKJIsZP1deepJdiQNE/ckxOp+yeXLrEQCoISDPTymSxSxGFD66QFNLYkCipCch5r5oWAx5cbC9YxHnJA5AMQAZWrhesVYPqimcSu2b2aPwFCrQIKjkdCmqeslDM4qSIPwPUZ76RWWImyBtQAURY7OIefFrXgLetb1Ie1Yri1lPhkr61Nviz381WiD8IZ86zHAZm9oHASkNTXkBpAu0zGlKq5Lou3oCm64SKiCXCA0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69583912-bf8f-4e80-39c1-08de78f8c8fd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:45:05.4102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1HRuT1jbm6QzlIpD1bRf0OuXDKLrZ/WV84OPBP7hyk8cMdfdlajZPAy2Tz2/eaitEVWABj5dfyN7LOEtJnLWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4965
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603030054
X-Proofpoint-ORIG-GUID: hSUOx39_8Tv76c-u7EFx5IYSF76MVjBw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA1NSBTYWx0ZWRfX0RfbFRraTEw+
 ViR8xkhL44Zf/l15U9RvdSQ44bNkep7NEhF8u4h5u0CgVcl+EsEVfxZnBWkibA3pdysYRdpg2+O
 ZNL+LOmiK1QP87AT8nzDMDL+wwTOy7yATAgRudSBEHuzIzknfiEDvyS81zH8CEzW2guJRoyaKU3
 z9zrgVa/sw8wSV7OyfA/i5GFp+t64tFD49/5jshHTNFkc9QJ4yiiDelGMsBRRopTSersfiHlQXE
 2cm3YkKI5q7Qfogfu6DdHNwyFsMBJheVRV2/uAfU3y7N4mL7d6hTxr8IKeBoQdidx3neCBSM+CY
 8XK+CAzhu37fnkIEltlU1gp2VrgQtdgm6cXEO2nU3r7MBRZfatpTKRpeEYU9QOH7tfGSZDH3ljk
 lHSylV4pR+poENInDq2nYDVp9/dR/3QkQpgoo/mQA41z5UANwZK9M2zAhK1kWwGFjuxotX0BQ6t
 zEaaoZ7ZXKK5KjEjTDWeN+upauwq842vnrY9Ht1E=
X-Proofpoint-GUID: hSUOx39_8Tv76c-u7EFx5IYSF76MVjBw
X-Authority-Analysis: v=2.4 cv=OsZCCi/t c=1 sm=1 tr=0 ts=69a69186 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8
 a=MXHuna_NGcV8fdR-76YA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12261

On 03/03/2026 06:52, Hannes Reinecke wrote:
> On 2/25/26 16:36, John Garry wrote:
>> Add a macro for the max queue depth which is supported.
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   drivers/scsi/scsi.c      | 2 +-
>>   drivers/scsi/scsi_priv.h | 2 ++
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
> Maybe: 'Add a macro for the supported queue depth'?
> 

ok, if you prefer

Note that I may drop this patch since it may not be used elsewhere. 
However, some might say that the value currently used is a magic number.


> Anyway:
> Reviewed-by: Hannes Reinecke <hare@suse.de>

thanks
