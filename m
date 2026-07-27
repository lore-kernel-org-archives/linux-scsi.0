Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B760423E99;
	Mon, 27 Jul 2026 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169270; cv=fail; b=hGLRfJhaCjZR+J1CIh2u/7rbzEP5Y6AXSu1U24Q/VgvVtRY42rMqpzWjzlpNfjlOQROxrdQ6Z2JJC2h8GcW/HN6/DNoumP8Mk5akSYZL+I5y5I/0hpVZHhlrqZiYfogFMLxGPRw+MszhuUv2OlULywZoPjquxQQIRqsPfqLe4Yw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169270; c=relaxed/simple;
	bh=pRab7vel0r1UZyCLMyRqxhPcMAIeau09fbc3xycN3Oc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gYsdszxkuy/ONAGu0MgqOkErPz8FWBf2oAnxP6fC7ve9AqC9LSWbZcxJrn5MRdVglkXy66871y+GqlOMT7l6ncs4a8mL6o6H0QgCbISZqnQaWJwF1dz39aucO14v7JtOkQSuZbbbIInfA7pOlEKM8ZuZvmEukfRd/8wd4DhigLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aE4GN+XG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZhK65IyF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aE4GN+XG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZhK65IyF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGEgua2495013;
	Mon, 27 Jul 2026 16:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eh89npd6BoikRw7uxYQ0yomOHFATil0csSlNE00BG9Y=; b=
	aE4GN+XG8KtLNbkxT+ZICmgPfr0wxf8bJziEOgwsciJYo7an4sRUTGZ0DgNiDYyK
	ZyoAkRsVb1jnjtv48+DXSYQw0OPVgqCWJudfIuazd2P6kU+fDygWQhgCzL613OCv
	aNd58wDJorxApZmJqFl6GEmx2jSq1PCryG7lyDf9gu0EiWVzoSIvnX5JpUwH+M8a
	0EaVxEvV1XLXWx3pLNUmzTOlayi2noCoEamadiTonDS1XXHHKsdhFR1NwYWDiO2h
	HGMcdDRp9arli77XgqlLqB8nemtYStLy5jfvSsVfq6ymeqhJArqOqNJFt4GuvPn1
	Vr0jmsACc/yoaQXpK+iwTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xt55p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:21:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGKci6020343;
	Mon, 27 Jul 2026 16:21:07 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8gjvy5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:21:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8T8UggSDSD2HmSvJyy/E1/S+EMcIf1+MxOwMPBEACDJTpxjfXCgUwhu7yNsqp3qpBJcSKASTwhOiymJD6kp/V4mMnU2eII5liWI9b4lYlN7E9brB86wIZUjXmAdLuHM6teJfi1Ps9m9n3AEoCjiiyPA/Lfj0NlJsWPa9VBasnnstCbvfpsmf6lGQSebPQ6FPikrGGhG8cRAgXGUvHAuL5uSRL96ub97Mx79HW21l0EJqTCDUBM4wkz7VfBmwjb+KuASI+o59PgwVRycXueS23F0atArscD4GuIL/Pf17LBGUx9hGl+qXkY6NA1S+kPubbBh6vSzPRA/D81xPh2ddQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eh89npd6BoikRw7uxYQ0yomOHFATil0csSlNE00BG9Y=;
 b=SnlxHURwGw6IzSm6YT2eqencGURPW0Ww8eSxcWsZv5yGi8r/nGyXenjOqRjhK8MWHiOHZk5mkQUXHBmnMnC87NSsZby3Z1p3iMvTKoOCnk64S3f3bdyr2I0Na8CFdehXg9Pwf2qSgGMglyk3sI/1VC766kQZfm32HBuSBmYL47q/1wrDYkGCg6skq9IEfeZtlctwFPh9mp7TyFL5/nNyY4A3R/FpWU6UMrGYtaUFS9+0fQUO9MMY/YIxDRD8yseK1K2eWku7VlkYKeJ8lrJiWC3l7+MqMJFxLMkEeNj9w5DlqApScN0rr9XCDLaxprEkRmuDK+FErcVKFCjKdrrW4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eh89npd6BoikRw7uxYQ0yomOHFATil0csSlNE00BG9Y=;
 b=ZhK65IyF7KeadImh0ZV5OljWUxQbB8Mf+Jtr78FZ6Gz02vks2g27wxOYnSxypmua6EwJ9f46xRSML1TmUFiOVfqbTvayxbJryMVL7snGKn/fymQeDIuN6Jti3+oCAx2scs8ZRpaaG1orlRksGVFjivqNNHsKm++W+X+VhcaUaBM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN6PR10MB7422.namprd10.prod.outlook.com (2603:10b6:208:46d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 16:20:50 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:20:50 +0000
Message-ID: <c50aa4c4-c762-4c78-a3b6-9b1239639101@oracle.com>
Date: Mon, 27 Jul 2026 17:20:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/27] scsi-multipath: add delayed disk removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-22-john.g.garry@oracle.com>
 <20260727152352.6216D1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152352.6216D1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN6PR10MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: 8724fa31-e9b8-441a-a00b-08deebfb0614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	d4QhKcLHDpFVGScPWtFn385AvWkPr5tUcUJtvoYGnw0/rxo174mytyGi7s1jLMrAQTEGaG/9lIVb10ZWAAfI2uCGmUBx5EVDxLpEE0jD7I4fEBBmIW8V/hLDRuYBCIMzvJocZ22qXiSjKb5vWO/x/57yeKduvCPTzFlQbVnLUW+dAIhSf4LVTA9W0Bn90k1uiZArtQdVaT7uhUrTXpgHa7dzNt80z2FkNHA9M8iojpS/wJJBAobzHiYaga8sNPKDjqGIKVzuvsmcclodF3Seu4F9pctQTCEjKAgbYYIBfHVGNvs7LWPyJs5BOi++dIy1C2xZmzPgolJ7biVIAXpvdPg3ZHBrhuvXrAbEHib3SJBlVPHjiCkWpgg5brPNzOZMQJ+Y1agY6L1GQv/iX+q4oPmy12K7UZG2lKH8sxoldvo4zoqbLXV1hWwTXoap4wnie6cwflG3EHq0TtWh945+AcWl8iiexEKv5yh3Ks/aOooJicGXUzJ3R3QauhAfn3sThgh1ctluoWdovaqhUt02cuUVTHJVIW7vcnLQrw3+Pasv59ztWuOHndou5EkbQVY9YZhqbpVBt5pg/kXFq+GLXS/z6cCVI0qOnmBpIKG0dVTG4ZMqM4WZyjjYADGPYotcdcf1I92EbvGUbE+OQvCQljczo14rvDtyGaUsMS/AIz0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmNmSFdqVWlZTTRJM0RFczlYMEluTCtkQnV1enQ3RVRIRmVmSHprbkVDVE0v?=
 =?utf-8?B?NTl1TFpkVnBzaEhYZ29JRFBMcklXN3lLT2ltUE1zcCtXVVFUdzJEV1RvTWlJ?=
 =?utf-8?B?M3ZyVTNtQ1Nsc0V5SGw0QkxIRnltd3VEWHlmYXlacFJQSzN3ZTJNS1Z6Mi9L?=
 =?utf-8?B?WjdpWEVaajNTMEozb3BzSUJLTW5uSzkya1J4eTdvbUkxYTI0V2ljdTFTdGN3?=
 =?utf-8?B?UVVwb29LemVPTUl6K2htL1N6ZFk2ZStnYzdEV1VBdWNyTzNiZitKbEZnWmxH?=
 =?utf-8?B?b2dVa1l3TlRKUzF1SEpjaG9xMlBiYnZTTjlJUjVMK1ZPelFTeXFMMUp2N1kw?=
 =?utf-8?B?ZXV2VUJlNXNUY01zSUVKQzhBd1ErUC9vUHdmTTEvTnNjaDZVQWQzYkp6T1Z6?=
 =?utf-8?B?WE9xL3FhVzR4cFNzK2JOQ3dhbnpYdHRnNUVkWUNYSW5HZ1huaDd6U1M0Q1VD?=
 =?utf-8?B?ZFYvcHJQcjNjTFJrbWNDWXErZi8wMVNYRmxxZDh6Sml4YS82L3ZRY25la1Fn?=
 =?utf-8?B?SDU5YjFTRnlJMXRvNkdPUEJWWkhST0RjdnpUKzk5UVJFTC9TOTFlWmkrUzFC?=
 =?utf-8?B?Zkl3OXdSWWxhdHpyc21KcSt5Q2tobUFFMHhoKzRuZElQdEswclViVVFtbzR2?=
 =?utf-8?B?TGpTcmhTWkJjWWk5ckFEU0tqVVllZmNlb3ZpelJya0ZOUjc1b2o5Sm9kMXR1?=
 =?utf-8?B?YTQyVXRBOWhHTGtxYnBFbmxHb2xvci9FNE45NC8wQlFsRDlrNXNTaXh6cnln?=
 =?utf-8?B?T3BuT2dJR21YdmtxdUZobDIxRktxSEo0UU13TysrQThlSHJXTCs4dnE3OTFR?=
 =?utf-8?B?dXNHNi9US0dLRi9pREVvL3JDa1paT0NWdmdpUDRiZFNYeWtuOTVjOTVuYytk?=
 =?utf-8?B?ZWFWczZYdEliUTJIQ1oxMTVYNmhtLy9keVhaUXpSWDhuN1lFOHl1NHQ3VElz?=
 =?utf-8?B?UFJESmtjR0JGcEI5Q2psU3daeUZCRlZYQndsaXpFbDJheGRyMUVtY2xWL1Q0?=
 =?utf-8?B?SzJVYlhzY3dRcmlFMDBrQ1pmY3hZVHAwWGwwc29KS0liU2lQUW5NZjdhRTNR?=
 =?utf-8?B?Kzl3SXR6ZkJkeE94NzJmVTNVWWI5SWViSmxUN1FXcmhBNUh4S2l6RDM2U2M4?=
 =?utf-8?B?S0I1SlV6YXdBdVR2QS91N2FVTUN1cGpSNm93Tlk4eEI2MnpvRWJqck5aT3p4?=
 =?utf-8?B?UnhNZWtodVUvcGhVa1VGQWhIT2dRTWcrYUNVK2JIcUtMRFVmRmg2b2VLQ2s3?=
 =?utf-8?B?Mll4RnFZTHlqdG5DMjA0VS90TXM4S3FtWGdtNEFiVFBhODFIdVZCQVpKcHp0?=
 =?utf-8?B?WGY0bndWZDdrdkt3b3JqWHRRZThhV1h1S3RJYVJIdzk1RnQ2YzRHYVZLSzNJ?=
 =?utf-8?B?ampVSjJIc2xHUzdXME1rQ1M2aGVNOFFxUlc3c1k1Tkk1djVvRUlPcVFMZWxE?=
 =?utf-8?B?cC9zYi81b3FMMEVvMlc2aU0xT2FLbDExNGVESi80dGNsN2ZJM1N1RUhweDRR?=
 =?utf-8?B?WW9SNXV2YzA3RStOOVdTM09lWHNVWFJkSFV4VUdSSXJLWVU5OGhXZ1NzR3Iw?=
 =?utf-8?B?ZkxvVlZMTms2NndHV2dHUmZuaGNmLzVaemNqMlZQMGVraTJPRmxuUWY3c0c5?=
 =?utf-8?B?OUplRXBDZzRzK3JQOWRuU0dRREkxak5rM0I1VXJOc0R6UFZwbTV1aTBjdEF0?=
 =?utf-8?B?L0VNQ1piWEgvQTJScmhld09rUXY3Zlg5NHZHSHFlc0hIZXVmand5MmRXNU1Y?=
 =?utf-8?B?cWRZVTVLMjcvbmdwUVBnWnZFYU56cm5ZbW80emZuMHRLNS9zVG5XcmxWeGYz?=
 =?utf-8?B?MHFROGVYb2k1MGVWQUl3K1BUS3RVaE05RDdzY0pXWTIrUFdPY2srRTAvWDBq?=
 =?utf-8?B?QUE5SDQ5YUFFMnZzbzhyNW0zR2szemJITTBFQzdPMlhVZnhKK2FLQ25sTVJN?=
 =?utf-8?B?eHpkdHRIbkg2akVxZXFON0NXNldETDlkWmEzRC9mbm1DSHJ5SmNaMHZRNjkv?=
 =?utf-8?B?NVpaODdIU0FhZnRTa0h1dG9DYWtRL3lvY1Q3Ri9INHc4bDZWWVUwQmR1UkxW?=
 =?utf-8?B?SlJNMkJ2SWc1WjgyOEl4UzJoZkJtaFRGR1llRW5TKzFCR3pvdS9oTDJRZ1pQ?=
 =?utf-8?B?UWl5SjlKL3Q2UDk4Vm1iVkNiTEZzK1dXWkYrdG9NZVZTMU4ycVVWOGhtUWRx?=
 =?utf-8?B?dFl0dE04ejZpYklTVmNDMnlOT3hRdGRvUTJnKzdEVzNuWnZnY1EyM3B3SXJr?=
 =?utf-8?B?VE90Z0xOaFNoanlzVnFCSktZTjJDa2dnRGZXUjhxVlc3NnlIUXg5Rnc5SG5i?=
 =?utf-8?B?bU1MRmY5TVhzVkU4dFc4blVPRWFtN2dzb2xzL2FQcU1VZTRtbzA1SmZhOHIr?=
 =?utf-8?Q?BEJTD5s+yJCozJ4k=3D?=
X-Exchange-RoutingPolicyChecked:
	exgSeJokgx++OVf34mB9Q90sPgie6H5jX/lZIvSiUDgl6XPzepro29HO6wOHwkn9CSjBnUGj4jI/zK6etwnXfgwQEmEPjBGnyEcO8+wXU+pMouh1mxB+xMDCViynOIcrq5u3Y2dZvM6SGAw8D8r1Xld1UTVKiErx0lO2snJLIGd0maZf7YwSYiPYpWbJ1pxYD8bEXSRUAtooy4qrRW714bjixtuvane1ilwNsjRCTvkuUtDOb7BUn9ayLqlra4Ix50rDuCg2fVQaf3SRqK/IhtAR29piGKYswxPtWAeHChaqUTHpe9zGYhb0H9kQnQTB8R/gKYKoJNILRE3BudkZMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jI/p0ljdRM3cKV4zTc5g4zk03lDQVoFSzjHgo81/998zsu+iQEjQ/LHvvrB6+0MZVfKNO3HEQb1wcyvdIDEgfUFYD6AMRCO3iBYlWwFjTxlRRIM4NKDyD4XDpBvhWZXFD64UfU5wAs3z66eNb0VxfVddEl80awrERMpI7EFRb4TSZdGOYd58aauXEiol+hUMSDPon0iqhKucArt7D6oEEQXOhvWfIP/31m48Afo5BSwWIx81b1vzMBnuSy+Y4FHk/wi0Igu7nk7nsjgN+PC8d8v7Ts9OdAKjzXpmYsLsMSB98ZItyR2FsnYe25HwpAJtpVkRqPGJ14z+p0aLgY5XRcGCinG8goKnSUT02mKS4xNPZyIZr5LfGTGe6QwfqwjntexKIFvRHyN1e0FYWZ8U8zOg2V4B9LuSbdbUS8xEpppId3fmNRK9B7Y0tZqP1IzqkNZddy8ixfMsaxMV4VrfxMKGTEKnPmh/25aoMLbBpiKKQlp6v2cmfD8HZDCWwWlLFbF4H8gdTDAlRySP54X9VmQM4JR1C6SAeXJblGW5/A9HGSkB3mn9B6WKJ2xIDeACxvgKvsNwHn89d75TTBbHwq7hDn3L6b35faqmGlv0Rfw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8724fa31-e9b8-441a-a00b-08deebfb0614
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:20:50.6438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bphG0e8ewDaej6kVjfyVEOD5ezvGc2gUCILt1UuSH+8MAKgZVsJkikEbgzmNe5R5Uy6aA9jT6Yiwf9eXLs5QXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270152
X-Proofpoint-ORIG-GUID: Tk47uJeJUNx5Bk1Ow9bOfhtM7VqIpMvJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX6ZNuhMZUH1Zp
 ADSlo6JTO4mYldV5rlZIuAZ04N4po5b4g3bVBEKh5CEBzoR50x/cCKX7XNkUSRPRYZwPFx081or
 S2JsYTLS7hRQ8amu+U7wPLl6jchxCq6X5a59Ygng963cViKKT4bEFHQ8jBWmOvGnMmjDHH21daM
 BjPAil+/kE5B0aAxgAXvrgO3mRMBzVJX4jSWgSfaljuqmczcjZp5YBKOlwjgFXxjTw7ucV7qdkW
 7+IajipDxn7P02ZYaj964Saw+Vel0NDw7FNQMbhU18L++XDOxVu3zfP9T2uZoOvfzMACH1FARJR
 35WiBxWcSSLEoQGDEgqUtN58TWC6DpogwIM4g4uEitG2V+xvcizraWRyr6f64WfJOUW9IHUxtFo
 kjWyBizg1wlUS7cvuKedJFL8roxXVzKA5vCQYnAA8Hm+IV7JN+v3dbiQkaRNg+qz0OuhWISjxvV
 OgR5IxK3OFBJUVh8ObVvgOHzEx5ADYMmvq33M3gY=
X-Proofpoint-GUID: Tk47uJeJUNx5Bk1Ow9bOfhtM7VqIpMvJ
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a678574 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=yKBTQwLrZa3keBBGtvQA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX5ngxrXepo9k3
 k2iKl0n0ZZwiRagSlZoBOr78BZFgClUwINnUtNY829YLx02A6pdPKmjYj1TE9Hb960K87gqQydQ
 er2kHeLHkhDMM0XrkR3YOY9Au8VMC/1yhPsaPvNgIo+Cb4M4jI16

On 27/07/2026 16:23, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] The delayed_work struct for removing the multipath head is never initialized for SCSI.
> --
> 
> --- Patch [21]: [PATCH v5 21/27] scsi-multipath: add delayed disk removal support ---
> commit 75d6c7bf920e841ac7f62e67cc466430605858b8
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: add delayed disk removal support
> 
> Add support in core code for delayed disk removal support. In this, the
> callback calls into the scsi_driver to do the necessary removal work.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index eae5864ce5826..ed9c83189942a 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -360,7 +360,34 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
> [ ... ]
>>   static struct mpath_head_template smpdt = {
>> +	.remove_head = scsi_mpath_remove_head_work,
> 
> [Severity: High]
> Does enabling this feature lead to an uninitialized work struct regression?
> 
> When delayed removal is triggered, it calls mod_delayed_work() on
> mpath_head->remove_work. However, the initialization path for SCSI multipath
> heads appears to omit INIT_DELAYED_WORK() for this work struct.

it's done in mpath_alloc_head_disk()

> 
> In drivers/scsi/scsi_multipath.c:scsi_mpath_alloc_head():
> 
> 	if (mpath_head_init(&scsi_mpath_head->mpath_head))
> 		goto out_free;
> 
> mpath_head_init() zeroes the structure but does not initialize remove_work.
> 
> Could this lead to a panic in the workqueue core when operating on an
> uninitialized work struct?
> 
>>   	.is_disabled = scsi_mpath_is_disabled,
>>   	.is_optimized = scsi_mpath_is_optimized,
>>   	.available_path = scsi_mpath_available_path,
> 
> [ ... ]
> 

