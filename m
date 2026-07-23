Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443F53E4504;
	Thu, 23 Jul 2026 10:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803119; cv=fail; b=lqh0KGFSyvvs8rjTcPTTU8jdZ/klYtf1guR/Xp53VYvBmbj+JDLwC86jNh4SNHEH7XSDMZq51yzRzWgePXkYQB6IWWBc20zYaw0UrR2o3O1NrYryYB/385X+R6yeJYiC5/RXzKEPcR+jfwhGi7ZaxZPVrUfPIOLRt4TG9fOErXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803119; c=relaxed/simple;
	bh=qP2WKGJ64VIH7MFCLX0U1vDSFGIsawc7luaU/4d8RIE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SSFVvLq1U/F9sdP9GLjD7oeYa9I/RjKGCdB3zBNa6mKC7EjLT+X4/fqQJQZUzMEjS6pnz2OHru9vTzSoOY3SkFvGu8zjuZqimcf6hVIoeGXDYXRikf3gawe7WZyLj2DtsFt+D0VL6+VzdjZtURwCyRUGFwQDRJ6pdLGNl7dmKzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=etYkd24j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qtbFCBRU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="etYkd24j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qtbFCBRU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtZ2Q3360304;
	Thu, 23 Jul 2026 10:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rwkEovdzkwDC6vJJJUwFFkvkACD6kT+QAAVhSGZrHS0=; b=
	etYkd24jJr+x5wVtk9bsxdUKlJS58PD7UnpSwU7Dp224MB9LECnP7iFxO1SNohzh
	cU9clsp6jfx5xf3Q6xLm8EoPPn4tgkU0znGfkSA+/SpnmU+xDBacC+e28HjAuaxq
	pPWheQWtJXGGxHMktqyiNilykwpz3N2B/FHswKbO6ZSkMFcNdZ29EwLpVXBXqFNz
	9sJ47jl9WDxhSdH3nvz5s9a34HSwky6nndWrQGIVbL3xfk080PEODLfQyiDe+rJD
	H3Ecd1SGF6CTEeOYFcb+mhg5cnJIBZlYOu3Lxhp5Kgzh780OxbbkA32TP8D/1Xzb
	JSBiRd/qnTRjj37OJ4KTPg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6pw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:38:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAcUUV000863;
	Thu, 23 Jul 2026 10:38:35 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxry49m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:38:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSEGcu2+rs2FJ2EwPFfcYURvrw/64LUaekJ7vagHl73+xuQh5UPvNMrGHCurE1+jrs8Roi33b2zeA8zyv5c22pQD1UBQEPV5TvzRXnflq8WsBn10CFGspUFyTzGx90RxgKFR0TNvydU8cqPWP6843GsJaAA7LTp/uEMIcfA9o+WaU7JZSx/vXPe0L4STT2Yj/NN1fjgMD8VentGjO7nPzf+l0yr9DQAlWPzcuYRAmhF5VTF8Sr7CDhSexJ4gvHzCNQarQTaTfOYaohuw8iy9aFAqc+1RyCTEkjbJl5/Z33xF+I90Jj0KDIEoOxpb0M8MSZyQrPdXuj2Cwrwjw0cfrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwkEovdzkwDC6vJJJUwFFkvkACD6kT+QAAVhSGZrHS0=;
 b=FxTQ1HoNHR/4hj9oxVtPjzSEzRNgzzDitgD0c66konb6UNz9RTeYPHtl62oizxihXMVjpSeQ2soPaOncSUuyYgoqegtHb9SOCmFsgDxN1EhMMVkPHis6fLJneigXjhZUbVkmElnfCfUn+cc+d1kWH25/1jhfoOJZhMwRsaNiAhI4AIiEvn4Xva0m4hOhxn//Rzv8rPEnM0KMQGE9bskLMe8cfhwdDuR24iuHND1FSaP4SUijc92gSAGMjrRdBXrPWm7d9TZ9RXSA5FRl4PzFzXk1MCPeDtSU2spUPt6wqNespDcPXPPzygtxcSQU6POOwhOjh7YWzPe9jR9/D6uJ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwkEovdzkwDC6vJJJUwFFkvkACD6kT+QAAVhSGZrHS0=;
 b=qtbFCBRU8WUWLJiKs0KPW5BXjapI6Hbb9OrjRRPvMFXpRifzlM/mlCn09kDIykt660IT+bpr6w3EMidZFhdM5JK03Z1/2SwmEbxAKPqSVhS8gaQx6OJsaRJGFv0VDIh5CKYxuLJD4cdQH1nr2KHaQ2eF+4PfcksXk7Z0Xgy2S/0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 10:37:45 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:37:45 +0000
Message-ID: <6b379cd6-8f77-4b03-9cbb-5a05c46e5c72@oracle.com>
Date: Thu, 23 Jul 2026 11:37:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] libmultipath: Add sysfs helpers
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-8-john.g.garry@oracle.com>
 <20260723100514.C08011F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723100514.C08011F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0050.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: a7323293-3d4e-4efa-5bf8-08dee8a66e4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/ILbWWLhLILO1WITUKKTKrjcRiuJP+0NHjQUV9zqfOs2mL/nImG1v7akOj7kols8eUfJA6wCZ9HrK24W1HYdV32aSRsakczlO+7NJT075M0rEM+f05xwTE/qnVJdZ+c8CJwWD3y6M593OIy20t0y8sC5dyeMxTz0MKBAjAFEuhM8oUZQtoZL9z1XS043GKFFsdVGIFWW0kTiftAaWSn1R007jAYtisd/qtlahiOHvzfcbRk7Bm4t5coViIUpzgksquGtvu5mN+Kk50+EWMEzxj8JLmIzuQFnaQvx93BA9XiD5mJFoTs/eQOjswNvA7ljHZHRDGi4fo3HU/eblhXVJIKh691SBr8X6ZIYNQbQeNxjVbtZe0JP6JVzgSLUg2bqVym4AmhyoWqSvOk7PK+ul9aeHpquqpl4hK4aeT7UuBOTAwbx9gngLPIQJKUxO8s29XF7OWu447cN9qKjWDbo6D58reHUYp/9sHreXbbp6dRGUX8bVLweKGNWOmZFc+0JvqD0jNywqe2s+Fuvy/4xM4jOkBr0WI7CR7QnBxZk8ijCG24dniZmMABE7mvTt9PBYm8XpHf1S9lurazyJJWbc00BfBWLC4schwbiML6H+uc8SVzpHIcsU2aCVA/qJMZtM9f3NZ5Xd5ATIFD9Diugrz9OdkQ3R5Urj21vRaVFTS4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUc5Tm1hekRENEwxeW9PamprYmRrRGlVM3dtUU9KNGEzUGVYQ1MydlpuYllo?=
 =?utf-8?B?SHJka3EvV1k1VlVSd0NJUkNDNXJSRTlqZG9mdE1HS2lFeWYyUTcxbXJuaTJ3?=
 =?utf-8?B?VUNvNVBaQ1p4eDNqa28yOG12VUVLWUd3S09QRU0xSWlZL2kyMUV0NStWZEJi?=
 =?utf-8?B?QmRmbFVTNTUxckowRW1hcElSRjYydStnc0RwY2drc1lZMWJLZkY0Y3BKV2tE?=
 =?utf-8?B?aGtJT1hQQmFWYmQ4S2FDU1QvTnYwOCtuaEdTdUQreEUzZWhFR1lRYU8yMlRM?=
 =?utf-8?B?UEpoWVlHeGJuL3BIK3JyYzdaMytLQlRLUU5XalYrc3pqekNyOVlYZGdPSUVB?=
 =?utf-8?B?bXpwM0crMEpnSkVFaXNBT0IxMUZNdnVEYUl3MUpRL0N4MW9yeHZtUXBHQWZS?=
 =?utf-8?B?QWlsOW1qcGR0STV4NHE1UWdnZlk3YmNSZ2YwUFVOWUJKczJIN0hES3pMbnFm?=
 =?utf-8?B?RDBsc1FHMmlQTGhhYkM3bEJHaFhkSm1Lckw3Q1M1dlNRM0t2N21xRjBVS1pS?=
 =?utf-8?B?WFBiQk5GVjdXTnBJSGxTdGIvMUxwRlRGOVgrNDB4aEkyY3lhdE1UU2RaSXhG?=
 =?utf-8?B?Y0RMNjhMS0ZZZHNvOUtJdU0zVlZubVc3UXFMcW4vVmNpWGxnb3FlQytDdVhG?=
 =?utf-8?B?QUtzeEx6dkxGOWlyRk9UeEQ5MEoyaURYTGptRE8waWJzUWdkVms3VER2L3dL?=
 =?utf-8?B?R3NsNjFEUFRYNkdyQjRXNmhhVU5HZUM1aEhHbGtzbDk0QmRKa0tsd09qTHEv?=
 =?utf-8?B?K1RBdzNnQWdPSU9lZHIyUTUvZWhWZ1VIbFVBYVplNWdNNUJPRndrSzltbHF5?=
 =?utf-8?B?VHV4bFFkRzRuLy8rbHNnNmVxQ3hRZCtBdkJVTkRsRUdYOWxOOHBBWUc1ZS8r?=
 =?utf-8?B?d05xRXZ2TUNmT0RRV21HTEh4V1k0aVNHcXJlZFN4cS9ja3dkUTJmS0c0OFFo?=
 =?utf-8?B?cnVoYU1jZ0MxejZZc3g3MUlsZkJaOFBLTlBYYUZXcFU2cVBRTFo1TTJGdVdi?=
 =?utf-8?B?bzRxcThmaVVaMWJNQ3hpSTdaRzIrS1I0TTkvTHdYZVZoUllnK01OWnlyVWVt?=
 =?utf-8?B?V0xZMjd6Yythd2MrK1RRb1lsa1JCQ2cwZy8waDFJQnhrWE1GYVdhOTdUZkty?=
 =?utf-8?B?azNqODhkTEdjT1hxcVdJNHNqSjZpQUZJUHEwOXFKRHlZUkh1SktzVlAxNitY?=
 =?utf-8?B?cEQ4c3J5YlBOY2ZkOTJwZWZkYlhnS1NiTFFsa1pySTVCaTlFUlArY2pZdlRF?=
 =?utf-8?B?TDFQcWE0Qnd1VEk2U2ZsRC9BV3Vxbm9zNTZ4a1VUWDB0Qm9QVUI1OGpDUVVQ?=
 =?utf-8?B?dWsvUmlVNjlBTE9Rbk5LNWtwRXdPNjhpMTRSa2NQSjl0eldocDFTdzJzVjNK?=
 =?utf-8?B?L3p3WExmb1pQc3paSXhNZURiY2phTWpRMkpTNXBRVEdVWFh5b3RQRU0rOEN1?=
 =?utf-8?B?aEU4VU5YbUZqOEltZ21EQ0dMelh0dUx3Qjc2T3EyQW9nTHNUUnFsUUIwVVY5?=
 =?utf-8?B?ckIvSnBJa01IUngvdTVvM3laaERUbnRCc2RTWmY3NGJoUHRNOFBBNVJzL3lE?=
 =?utf-8?B?M2NielltazhkRE96U2xXYThSZ0UzeG9lVTc0SEwxVkhvdmxTRDRTWXcyY1l1?=
 =?utf-8?B?VEpvcnF2R1BNSjc3L01nZUcxVUVVWmMydGNndHVaNkM3WE1qT1Z3NHphaUxo?=
 =?utf-8?B?dng3Wjk2b3g0ZDJnSWR2TzVQMncwcDhSS1FaQmRvUXFaRGZUN29GV2FLdXRu?=
 =?utf-8?B?WWpadzRnd05YamZ6eEcxL1hxMHNaSE5hOHBYcWJTQWxhTVJPUXVaZkxuT2w5?=
 =?utf-8?B?aVR5N3Z0eUxLblc4KzlrL3pHdW02SXNuZlRtK0pOWk1Sc2lBV3NGdmZCaWda?=
 =?utf-8?B?YmZVUEhTT09LODl1R05LNmpYMjAzUUVpbFNUeEdOSDBIaTJ4TDZOTHN0RXhu?=
 =?utf-8?B?WXRIekZiSTgzV0RDYm1QMlBza0RzSnErQUlpRDZ5UmpEVmNEY3ZycGl2NkVP?=
 =?utf-8?B?SHVKc3lsTVp1aGJLLzNWNEhBb0s0Q0wxOGVRMVAxbENUUTJGMy93VkRwbXZs?=
 =?utf-8?B?NHZRN3d4UjZuZm9GQ0srdDgxNXhtM2RUaHdhamZJMDN4cXhaSEQrVWlybVhQ?=
 =?utf-8?B?RVdUYWVIclhUaEFjZFFjMDQ3eEZoWHNUNW1lREVhQy8rLzdLRG54RUF3SzFC?=
 =?utf-8?B?VHNMKzRWaVlmQnhDcGZCRndRamJIREtHcHJBVDk4alZVd0dacnlOVVFxWVZj?=
 =?utf-8?B?dkJZczRHODZzTURyNXBGdUZMM0lPbDRvZC9xbjJyQVRwY2xlQVVYSmlVREph?=
 =?utf-8?B?OWVmRDNsZmJsaTN5WFQ5RHhTNVR2RUZEZ3hCNU9kN2xSeW5rNmJ1blBZdHIy?=
 =?utf-8?Q?XJQhp0POvZKGPLbo=3D?=
X-Exchange-RoutingPolicyChecked:
	ZbrFHQc5p+hV0pbshIb4w120+pL88G+WXT4Nh4KbTiIdvr0NN7JmD3SfPKRNYaU95BFSWUo3yWQdSPK/PTrr6sB1sQu9FCI5S+RQ3f5x+YMszQ+JbGUt8nGQ4iDx+jC2i+BL1v9hk54qNQsTHLDHDNXoGzahvu+W7vrAFvAAQczFQlt3s/cE5tQYgiBzr3VybRJPsZAJslqML3gMXeSw535If86oO7RLz8G2QyWYW5W2Q+GaI5B1eZ2BXListrrKk/yayacnh5B8bzPUxWqEPxJ2x7tKIjfPPiU4gIV+5w1KtXIW/lEJ/3KsjIl3q2ulNCyLeBC1X9gYLPSa+JMbhQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qx/7yl+IU6Gx999jcxakbpZNDfoXwbTSS8mo6w2wpvSVzc3nn4WpgM/lTmh564CIq6HGKDncwLViip12hraCUoDE5AZTy4BJv+BYu7vLE1tug5gDUYRL5DqJU8R2GgkL4V3O69ohXW39VkW/LtQEanxhM/tMZcfMsJjLze+KvlaQQncFEFnQf4qHwAiOtQ3JqFLKZht6YkW02WpIWINlFDm7ffcEB43ny5YzY9u2q4R6p8EHCKQGsaFAuZg4TKWSumenOSmLuKpznqa/BdB3NHvKAnyUtJvyijG6SNRz2b/Nd6xQ5GfzlpZFDiLPM0MteoR8W0e5jHzqr122L/RC+2WntqQbCAal7XMPSaLKgXxmwG8/sY1+iOiXhRcEiLmBGjrlXaRFywqmdTvV+UFlM9tW+B6bNdoZU0eAEWGpQ0A9iQrGhMJIHD49hJGdITVt7eGTRu7KVM4+rIU3FlRDKdep4Fuo7gXN1YYTW/Dhik1sRynuq1aOvGowrxD1ljHUi20H7JpCe+0mk/w8ZzMyEeczwdbwf1KI0uNl5GGoPDJZ1Ku+y0BDnA+LiheSpmDgQ1Qxt2vGGgf2pCtIe3fRB94sC2jj7yfmjV0umtlHTik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7323293-3d4e-4efa-5bf8-08dee8a66e4a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:37:45.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ug66FXVaw1FNkzz/X5j1IZvX8q80GVXgsZV+lBWQbEzcowa1wqkMmGsWkybpuq8miwsBG8xn0o2yHKvG4DssDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230105
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX4t+0QC3+k/zO
 UOdXZ4i1YXAmXtbd7WKNfiV+EfcryCi1ffHy9VPmpXjiHYScGaIxtn3qqitRh2E8xHtChdhSSaO
 srdvQ/UJbI5WNYJSTYza2bvu10y3cq+/EKyv/qczC32AD/0lUdx4syGyegzzUKEq9+8qdUFQQN1
 B8srkHWPBUXtx3pdnXPK0QclZ6MsXZ1i+mgIPAP2t61OHlNnkkpON+yIXATbQTaPA9+IGBDOaYT
 ZLLMU98ji7mesjHBz1lR9cxpQks84/C6tOKle9eXd/IutMCjCnvrz9zsFwjUH8hMnINBhEmCEKr
 7meK+2VOfwVLy7+u9m8eOTdZpzmiFs9vqMHZSHIqo9rN3rVHbOidgJG0aeSb6YOLyXpS1VabmF2
 UP2KAqqIsPnCjt7IXNG1JT7W0QK/pla9/gYyDlMBjTOGvNEHZRLDqGZT5aBKOanxVwec0oqBW+N
 15SmIEn8Yl87tKKCqDFX//8hL9eWR9SToynymQWM=
X-Proofpoint-GUID: wNug9zcJGoZ0AQovlm0LYVVEivqF4r9_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX8YAJPH6HV4p9
 nSY4oIyOl/CEwJ+ZeQcv2vHpOl3AE+oVH/hQlvvwuWqyWAobRGPHu1NKqGrF+tNiupdwPbvZEx8
 FONxlhcK7p3EnRFIGOMpfMYm4hwcuB6awLoAUqySLe/fIYvuZXtq
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61ef2d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=mVndt0Y6nTK2suhQp00A:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: wNug9zcJGoZ0AQovlm0LYVVEivqF4r9_

On 23/07/2026 11:05, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Calling `kstrtouint()` with an `int *` argument causes a compiler warning and leads to sign-extension overflow when parsed.
> --
> 
> --- Patch [7]: [PATCH v4 07/28] libmultipath: Add sysfs helpers ---
> commit ebebf59df39aef065973319479be0a19b5308cb0
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add sysfs helpers
>      
> This adds helpers for driver sysfs code to get/set iopolicy, show device paths
> per NUMA node, and manage multipath attribute groups.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> new file mode 100644
>> index 0000000000000..3ff4f42a096c2
>> --- /dev/null
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
>> +			const char *buf, size_t count)
>> +{
>> +	ssize_t ret;
>> +	int sec;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
> 
> [Severity: High]
> Does kstrtouint() properly handle being passed a pointer to a signed int?
> If a user writes a value >= 2147483648 to this sysfs attribute, could the
> parsed value be interpreted as negative?

already commented on

> 
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
> 
> [Severity: High]
> If sec is evaluated as a negative number here, does this assignment
> sign-extend the value into the unsigned long delayed_removal_secs field?
> 
> This could result in an extremely large 64-bit value, which might cause a
> permanent resource leak of the multipath disk structures when
> mod_delayed_work() delays the removal indefinitely.
> 
>> +	if (sec)
>> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	else
>> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	mutex_unlock(&mpath_head->lock);
> 

