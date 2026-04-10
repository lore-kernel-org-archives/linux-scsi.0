Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F538BF76;
	Fri, 10 Apr 2026 08:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775811358; cv=fail; b=HE5bsWncgNvIXPruCHd61A9PmXZKWsEjW9YU3sh8zcZQ0SX2NNegl8ZqoH7nKK2R+xYTv+045VtNLXBdXkZLvSEK42d9x2/xzRUDuNSKByfT5xBb9+xQLlwRLYaSorQpMLpk+VQR71GWlIZ0aKIcsto218rtCAQS/eoNAF6gEy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775811358; c=relaxed/simple;
	bh=cKFlY+ZgNvnwnmqwfPmW8rFHTDXuzXl4cN5yJaEcpQ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sp/n3+WzTYW0ny/oymTBjrK5HkFO+X1xOsjGXGKu3QhURWfWdD4ZX3Q0h4O0dFH0t8GxIW57Kd/N7XJ146CSXAdGnHk97E4W6SN+2PW5NCPAttnMNsI9EQeMDgHuehm3sBuRXCSTYWsFjmIutDbcB+iPHsKQ1W8TtEDQHyvgcHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I0oH4nD0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z0eE7Cc0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I0oH4nD0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z0eE7Cc0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A8tWCQ1163290;
	Fri, 10 Apr 2026 08:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8uhDRj2Lpiofh5uqwKZrvnOxKdwFt4MW4j7eQIu7Urg=; b=
	I0oH4nD0FfYUd6sM0KV5YIU2IHTWI+UvouYegtHFkwfWBW0OYwIg0+4CbyjaJ2TT
	AardCjP3OAi1nAyoF8pIwBQDU8JuPVFwauVPL2LZIS3oGTf7LL9iSGNxaysRlHOF
	jYlfaB/uVhGZY/p1MGQUb4k2JE7uW/M1dtI4daXY4PK3rYuyPOjYZJdq0v/dGLtz
	XwybilZz3xL8sQBOuROQzDBshJJhW04ueI88D7icd7faIxzcdwEH1f1bxtjifWo8
	fLVy9AJGFCjafN1+T+yfFnpT0sH9p428al/WuoLVTTpPSrOlG25pxo4WeaCeLYPh
	6ivBCgyohX/6wgWa7jfPHA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqeh10d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 08:55:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63A8I3tX005201;
	Fri, 10 Apr 2026 08:55:28 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013057.outbound.protection.outlook.com [40.93.196.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxsxh08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 08:55:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNbaO0qdurG1XJZOJ59mNfgN52vvUXz6EeQo91S09JmXZB5BipCRMz0qxmC8QnwI5v3JSnipOjW2K/QygayrqFndItfrfYyMl9fKNM53twLpQFm5ddA6fOEgqq2xQcOGyzkTOuAAmQ4mpda+akH8PEZhZ+YQceu7Eftww7eYhrzxs3oTHf3BTZh+cvE/wF15rsgWY69yL+QUAmP+v9vA18uU6OOv/PNE49N1ZA+O22+LISWpRnZNyWfHPqwIEB628YDXqe63ibPMAnq94Cv754Sfs4OqDSXl7EEGPHXViVFwKA5R7plyFDfohqP5DlDFbSzl8MGCFGriACmjtFEApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uhDRj2Lpiofh5uqwKZrvnOxKdwFt4MW4j7eQIu7Urg=;
 b=QwBi7HCoUbUtb4hzAFwnvUmd6tOdEQ797ti3tmFv7ZDWhI52cl/3XBY0xQ5MAqRwHaDFsPZAXAeUepZHxGrkYN6Ix8PrwGF5k/iQLBku1QGN3trzC7oxA5ltMLmh6O9v0PGXqt396U9/Yx4kP7VAaZSIPjxxetm+z5cTZGB8/jZudxkDYx3a4MxXu+evo/A7ptQ9frhcfyQkVjBCJZSI/YJQ+rR5lg/YQtMGCvL8ZjoWsdJkMmyRBl1Or8XPRdCrm8SodRgymal+LyrbooEeTX5b84JIxoicFImxcpbPVaSRZLHF3xYhOCoQvjVyVHF9QPidSHf2kXRyF+VQIfKN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uhDRj2Lpiofh5uqwKZrvnOxKdwFt4MW4j7eQIu7Urg=;
 b=z0eE7Cc0i4K8Q1z3TVu5OmInsRYoKK+fI8VeO5KWoSBINMJUmqUAE3m5ILKcAXffR7Bz8UEaN8EbFrvDKli5A+DRYU5QalLitrXXfw/810PC5/vljOo+dICLAMsvvcD6vBvuCwO/JqVcWY+aovnv4vW70ggexfn9lo6woQurnbw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPFAF33AAF2A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7c0) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Fri, 10 Apr
 2026 08:55:24 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 08:55:24 +0000
Message-ID: <b77d5eab-d50f-4102-8bfb-f907cf39ca56@oracle.com>
Date: Fri, 10 Apr 2026 09:55:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Nilay Shroff <nilay@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
        hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
 <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
 <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
 <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
 <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
 <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0374.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPFAF33AAF2A:EE_
X-MS-Office365-Filtering-Correlation-Id: e8c77a8d-3419-4a57-b6e5-08de96dee766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	656CZj+Ne/aXFFctRtQo0e0nCwJ6blSRRXe2jwz3D+ODt51dIuBlfAZhVvubOGrRFrvTUvldeMMkONoYvpVSqNQIi2PqFel2hsc6sNZ6Z+dI51LiWzQsWh9Yr5oBt0xwAN1dKHQnOUqs6EuufuHrl4H+Q1l70GfF8mAzZcLh64h0yqPxJ8fysOmZorTnPyQ2bKffUkc1dTxsFYv2zA634hU++BhuxGCHboyliXGbCgTS2/Rhpr6vSOELgW52KjCtV46UKwl77ZKUjD25woOvxyMldxQPZKnd+7pcCojwONLfSp9SVmh4eJpQIUCv0rgRQtSqBekTtTAHZmCY3GV1/YfsKZ/WTVaJrNH7rwHKBgfis8XJLdWsnPsaesDRzD18kwNZ3Ej+wXKyfM3tqiAPb6FjNvlI6Nhl4iDn4IvbnV06LGnDG60Tq9T6jAsHOBV2O2E0c54Zkr5IsHUjbfSE1vntW5EfbarVQZsnHFusPbqDjMuj3Y575uabaMM27CRdKqIObSsWZp0zVMw7KmrI5mp8bc/XMJyy/0O86MANixneDO5c6O9IeKuhivUti8DVosNoGv/OlXI0c6cje2Mjl0kNZ5pvzGxBwJM1eelRN/2zXwkSPiwhuo/t+vquADwPMhhm42qE/tdVR80xhHeMkMHDkMwZZWEJ2nZ/dvcuOHwXu2hzwaHmSC5ruKhkPLSgjzjwo28y0Qb8eqVO2FfNIqh8Roor+BX5vOO2BC8zgBc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjVMKzlOc0c4V1VJTTY0T1hoV3g0UkZOcUJBWmc2ckZuZ1ZjRCszcUxJVlhP?=
 =?utf-8?B?NGpmbG5VS3VMQUVEZnJJWTU2MVlTZCtHcGZKaGgzS1Jra2hNbUVFRGFidVRi?=
 =?utf-8?B?NlJXR3VONnBzbEdHYk9TZmpaaGhTKzlNeVBPRDh4SFJuWGswWXNzWTg0WGhj?=
 =?utf-8?B?dTMzYXc1dEZtL2NKb2NEc0ZMVjlNUm9XOURKK2FyMzFNWlZucG9VcVZURzMy?=
 =?utf-8?B?dVRTeENuNE1EdTFVTXlOOFRlR056NC90cEJHdmZrUjlyVlhTbzhNaDJIOTVX?=
 =?utf-8?B?YmVVOWovcW5DekhiMEExZ3o5bUo3VStGQUY4SC9HajhmOHptb0NISkdBWjNu?=
 =?utf-8?B?d1k2cGo4VmowOTZpNlU0dFBJN1JFQjFtRFZQaUVKdHU1ZTdOY09GVWJQQ2xL?=
 =?utf-8?B?UUZYbEczVElIcDBRejk2T2MyODZXWldNRzRqUTdDYmZWenVKanpHYjFESU1T?=
 =?utf-8?B?a202MEpOWjdMbGVWUmxqVG9BL3VxZEszcVNERHROQmFBREl3N3IxVUpkMG85?=
 =?utf-8?B?UFoxTThMSHE2RSt4U0hzakYyS2QxWFA5UXFLRE1ORk40VEJOZWNwbXNKYlBk?=
 =?utf-8?B?ZGgwb2RvTXhzV0kxZTdaZUF6WWYySmNpT24rakhSczZhRW5RQ0NUUXhHZ0dv?=
 =?utf-8?B?Yms4ejcxVmtRR2ZBdzRza3pMRkhlNzFhSERuYzQ5dTRORHdURkMxdnJOaUx6?=
 =?utf-8?B?Q2FHV0JmY0xBQmhSNWkxaERqeklvbHBCR2dsbTdERkRnMldpOFRSa1ZBM2xU?=
 =?utf-8?B?elNYMFZLcWZXb1dRenpoY2Z2UzFwaFNsYnpzOGJNL001S24ydjhCQU52OHEv?=
 =?utf-8?B?NW1RYTRTWUV6clVFeHhJeGI2bC83UzZSYmNtSmNwa1pTNmlGSGlUMFNIbUIz?=
 =?utf-8?B?eHgwZmhyK2Y1b0x6Qkl2WXBKa0YrYWR4RDRFeFluNzVETUZBUytPdkN5Z0Z0?=
 =?utf-8?B?T2JTY1BwQjh5cVZwd1YrWXIwbkQwRXpRL3BCS3FLVWt3QVRPODUrRzZtbkxm?=
 =?utf-8?B?UmpjTUpLdGs3aWhlLzdSZUt2OERzeWUwZ0xUZHpIcGJ4YVpJbTdEcEcwV2kx?=
 =?utf-8?B?TFk5V0ZscmIrRnlHeEFhRHBzb2VSMGM2VVlMbW4rcXhqL0Q0WDRYZWdZS2RV?=
 =?utf-8?B?RWEzMFY4MEd1eExqS1RicUY3d0ZNVzN0VUZyOE1IalBPSUVvLzkwc1B1MHJx?=
 =?utf-8?B?RTlBaGRTdDJmRVY1OURVa1NISlNhUkI2T2NjQjZOTlBQcUx6cTN1RGJjWXQ5?=
 =?utf-8?B?c1NrQ01PMGE2TGs4cXFJSlZVY0JoQlkwYWlqWER2cjJ3b3ZXaU1WYXdnS09N?=
 =?utf-8?B?cmRKU1dQWFdrSXJNK1c0dm9VRW5aOTl6WDRpcERWRmVxRHpSL2JFd3orWnN1?=
 =?utf-8?B?WUNnZHEreVFBVDgrdlgzcVBmSTBoQkFnRUcwZXlLWi8vQ0FRRTFQckVzMlAr?=
 =?utf-8?B?Mll0VDlaMWVVVjlhNGE3cVNWWWpqSE1JRG9SRVVNWThRVmN6OFJYejJ2Yzdt?=
 =?utf-8?B?NVoyUS85eC9VSHIzdng3R1BkSXM3Z2I4Z0krbWxVcHZ0MFdpN0gvdElpNHdP?=
 =?utf-8?B?UnhUcGNxR1lVLzBTNXJNY1ZyM3lSNHR1d2ttZUErb01USDJDUHd6d3lVRFlZ?=
 =?utf-8?B?UnhkOXc2WTRLeTRBWnlaUmhQMXFic3IwWnlxL2FWWmw3RXRMNlhPY1R6V1lH?=
 =?utf-8?B?VEsyazFvNEVMMk1HOVhXL2JsaS9sbmUrWjd3UnY4b2tLaDdrc0owWS9jMEdE?=
 =?utf-8?B?UDRQQ2FIL3NZd3hsZlp2Wm9iaCtBaXlXVjU3dWVNL0UrN05ONGd2Q0pORnBQ?=
 =?utf-8?B?SWtYc3ZqblVhVVVDU3RqMmdOUFlvYW4wRHc2Y05YL3Vxb3N0V1lSbjE5dDNx?=
 =?utf-8?B?dk1URUhMNmF5d3hrbWRuYXpOdmhQTmR2RWlzV2ZNOHFrMEhYRHRiU3NnN0lv?=
 =?utf-8?B?dkh4RmcvWmhjVldSYzd3TG5BWVowekJqRHlna0hBK2hiVDRmYXlWazc3a1FN?=
 =?utf-8?B?MzZzQXZwcDU2V0RuaEluTEYrM1llcHRoUWxSUWJwdzJJVlpITnNHalM0QnRJ?=
 =?utf-8?B?c1R4c2ZwQ1A5ZVUwbHFRU3JlbURZd3UyckNKZDg3bkRIRy9rSXh3SXJMVVF1?=
 =?utf-8?B?NkZRNGRORHFZNk1rRGpYeDRCcm1ra2oxanVlbGFCSHFmZlVzeVVhd2ZQSHdO?=
 =?utf-8?B?N0JlSU9EaDNNLzF3NXJ1eVRkVjV0RWRJanVRTkR2RWZPOTZyT3drb041ellX?=
 =?utf-8?B?dTdLdkpuRFBwek9VcmpGUE1qQ3Rmd3VmZnJEdXo4L1B0Qyt3QUVsVUhPU2VI?=
 =?utf-8?B?WFg1ZXN6QnNtL09qbmFxc2ZvM1BMYkNRZW9YWlVGWWtHM3JTU2YxQT09?=
X-Exchange-RoutingPolicyChecked:
	R/Y7zCH0nQ8R7fg/oE0Uy2YWbgKHqsS+qQ/IsiTkWyfYcIp0GhqFBZITNWwuDWFQl/LqsLIFdad9AcGfMLv8EAAtTdfiMyljwtk9vJnSEGXq2mhYGZr0ZHclkgN7rCXRnW8ENHRjOHhNrgdEIlzGPguqX7llK7QzHqj+XCTNoXx8AXoLqaTCx5XfFOp2dQdO3TANvakmBhtKBfccd8bwi564gZMzLUTOM407BOTAwHumQL9a6iSr8mdkE/gLS9uW1UzwlZtKnQBCPnm3r8X0yRI16MDqzwE9h7Y3pjopXIcrFCRzAtv+KTMRmKifL+BNP+sgzcF2vaQ9Ifrn3uNEUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HfAwcLrFlE2NAKtM/FBADpFJzsygq97s/Wx1Px6zdvNH7HujGGUR48wWZIl+U/v1AqLSnl+G2LuoLHrWedepVKh9UCP7unJsraVk+iJ0bz2cZnzJ1AAWB0VuevwUGCutMA1k/zAXFCVUFMSPE7Q064gGLkLEyu0zVr3bnXsM4ZfHuStnT7CjFRQDbPpEwGYX+YcKcwMEISJlzluewmfWT2uOTKBPrAj9CdZa3zl5CEIaaszF+jgHt5HwageXF6oEt9J2uDDB5Kt2Fvmka494YztjduTEP48FITiG3kzEc4r7Dh3v5t1MSFLvWMumSlWsdqrTqWu62i7vXzLanuZcaZEpocSSlOK+Bkl+WDErDNyQ3lIfe2I8n56Jae9Iv0Ry2xQzHF/VVaMmm26nKyiDfJ912xsD7C8732tBhDx9gpD46waepFYniR/0kBGk5ow7eTbma3+eYsCaT/5uArnHg8jr6gY6F7FYee/tdCJgnJzHpz35SDj3X/rAK7YJNH8ZVXFb+1B/FByxOBqS1n7vf4d5F953L7czwrndRoELPDHn9w47pdvtDRvUvuQqVczLqMXaaoMoQeeX4CLU6zXU4uKj46jiawt4kr5LrEDDicg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8c77a8d-3419-4a57-b6e5-08de96dee766
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 08:55:24.5132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hk3jCerjZAV7jo3LPhLdMRsxz8SA3ygMBlzh4Ew5Zm+LqixeFzf04DBTLnamgdWcIlGRe7h2DQyK2NZgkt9YhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAF33AAF2A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604100082
X-Authority-Analysis: v=2.4 cv=MtJiLWae c=1 sm=1 tr=0 ts=69d8bb04 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=zEJw8ZNyH9Y5mYKGL7QA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cFL-gWlERMkqV6lXGxGgmDgzYzPXnIji
X-Proofpoint-ORIG-GUID: cFL-gWlERMkqV6lXGxGgmDgzYzPXnIji
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA4MiBTYWx0ZWRfX9PwSUMUrLFYm
 WNx/Ji+Yh3UmX5mAl9igmmOdN78oA8jTJUbAQkH7zUVLwmyxPUYNwsf2Wl5w4iKiZBKiq8poSl7
 AFqorWiv8P4oRKdZPs9TrfIlExwG0nS8N12RsANK0TvV1Yt5YtGPDGFY/m2V0uiRjExIt9wGksF
 L/2OOx34uuFh0la5FFhehQuQcJBy6r/zG9Dj9uNfIuTefeSvYN8DrrZmfuIiCIikxRy6BISPIFQ
 ps+V/x0LwCtHm9d1qQwBuL2cYnLsCINT1sddOWrWlldhzxXRYFE9JNt2Uv1zwohEFN/EwinO7En
 /0Turm00fnypBtEv45zZVev3s7T55SH4pE0QKMpw3Jf4oyQh8ThZa72eZ8cWRzmlxcGaap0+w1M
 za1c1nQ7wqw/si+T2EoX1emuXZXFsOCOFAefiVqwsdHvD+ePsLa+KJzHa2mnuKMjJNIAEivQt6z
 1pA33azMO09qdANEYxw==

On 10/04/2026 08:06, Nilay Shroff wrote:
>>    # Part b: Ensure writes work for intermittent disconnect
>>      _nvme_connect_subsys
>>
>>      nvmedev=$(_find_nvme_dev "${def_subsysnqn}")
>>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>>      echo 10 > "/sys/block/"$ns"/delayed_removal_secs"
>>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>>      if [ "$bytes_written" != 4096 ]; then
>>          echo "could not write successfully initially"
>>      fi
>>      sleep 1
>>      _nvme_disconnect_ctrl "${nvmedev}"
>>      sleep 1
>>      ns=$(_find_nvme_ns "${def_subsys_uuid}")
>>      if [[ "${ns}" = "" ]]; then
>>          echo "could not find ns after disconnect"
>>      fi
>>      _delayed_nvme_reconnect_ctrl &
>>      sleep 1
>>      bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns" 4096)
>>      if [ "$bytes_written" != 4096 ]; then
>>          echo "could not write successfully with reconnect"
>>      fi
> 
> It seems there may be a race here if we attempt to write to $ns before
> the reconnect has completed in _delayed_nvme_reconnect_ctrl.
> 
> If the intention is simply to verify that the controller reconnect occurs
> within the delayed removal window and test pwrite,

Not exactly. I want to verify that if I write between the disconnect and 
the reconnect, then we write succeeds.

> then it may be 
> sufficient
> to:
> - perform the reconnect, and
> - then validate the write (pwrite) afterwards.

I think that this is something subtly different.

For your revised test, if we reconnect, we always expect the subsequent 
write to succeed even without the delayed removal, so I am not sure what 
we achieve.

> 
> In that case, we could either:
> - run _delayed_nvme_reconnect_ctrl in the foreground, or
> - open-code the reconnect directly in the script before issuing the write.
> 

How would that open-code reconnect look? I was just using the subsystem 
connect, which I think is not optimal.

Thanks,
John
