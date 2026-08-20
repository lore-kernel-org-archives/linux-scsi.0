Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DB3B71B0;
	Thu, 20 Aug 2026 12:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230335; cv=fail; b=U86ouGcP9PEBP5csLVlEpwO7SEDPp2KBYV0kvC6DCOAb1gjZYTcyuAVYb2rAgx88LObHGiNhgAZH7p841a6K6JJPcBz1gFzrBXRF/6xKBKxwB7WdF+jtSRBVlJ7dahjzT+Lp72gtG1EoNyVxYFjvPMINEZiUkE5S17OxjuLyaPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230335; c=relaxed/simple;
	bh=pHIQ+ou2PYZibJp+01d7OX8MbLHDVFwFWtTkdP5sq7U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G7eZ9KpZwYMSaO6LVn9ybhjB3CoU27X4/HVZgHNfBu0En5mCTBz7we8+diby9sLShFDZVlL7NIIa0xU28OdE6kpWQob7R1upgRCUldh7mo5q7e9GqTqLa8rPmHKong90tS6zXHvgG4xMDHhseqvkCXkssFY3AoB704jC0amf8GE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mO7NnPAJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p9sDF+cp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mO7NnPAJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p9sDF+cp"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K9AFBa2189425;
	Thu, 20 Aug 2026 12:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/aHb+FYA+Bl44RRGXp7YgF/AwauDf4T67sKv2jEMXKY=; b=
	mO7NnPAJNQ1GOjgs1ytG/OF+bw7lfWC5LD/kvpNElDE0ZL6x7kTTU1sA6073y9Qi
	JbQiajTYXQXu42rlpeQ0uOfuf+kxnjb+wQmbXp4ApVV+SWnBIUnXKY6+NOgJSMpg
	+0nwBARP9Mf+5T97o33DKM1lC3Cj3lNSIw7k6Byils+S0rgzq0ZdSMv4MV0AGYcA
	Ve6GIug2o4txBatpQjf3QEJJwkbzoB5lykqJf47A2E9Ku7gflinmMRFY4dDatO94
	vhejvztewt/U1s61QK4vQC7cW/YQcTe3iU5gEYJVcddukXrBu/6mZlReP/+VLMG/
	7dHA4H/RMiflwYtBDpTecQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g4ydek7ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 12:51:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67KCnuck014215;
	Thu, 20 Aug 2026 12:51:54 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejf30h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 20 Aug 2026 12:51:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9gKaPQR1D1ABrC8IsSzl/djBGcvLl5iXt7IJdiPhcRaom8GJy7k2mmyfe0mhFmflILUsBhfSJ1f3R4ELfqy1Wyb14NkM3TBUlIYcUsAYb1+F2TB91KxhGN2+twA2679bmmjNHw12qa1Rw3nyvGDlsLlV8HOMzVsbHX+xAd4JxDfG3Sn4w8crELQvVhVtNANMJa+Vy78NZjQ18aVncKEll9W0oDcoq/WPjdoXWI50Nv5NGNW9jLAjy96/clLsKc8w1vfJsEMYbgTbJ9uvK9FR4ko4q1BbVSKVcG4VHLFc4rA8Eg5evgmNOgeNxK/V3zM4h+uWe6lox0BozYfNQyRjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aHb+FYA+Bl44RRGXp7YgF/AwauDf4T67sKv2jEMXKY=;
 b=yf9Jec7Nqi7GBmqtGnNY/aea2igjE40vO2oN2s+xVaUcHhytTIP74Qg7svL4pPdOeF4B5YPmB4o/QPgywIl6lOG+yHfJtGY3+CWK6WJYvfXMLGmbpM9Vq8O1FdfLpnUVYuMD9ZQaTplzTMuNy/eBghTApF+8dVIwFhY2QTKJZHIvMyB3FdUJGK4sYEkVvVBIZh232lVnfBSnGBY4WrE9gvcq7BTHtJljyLUlhZsxiLWonjl6XE3ZaxGyEnzGf7N4vUSJdIFIxdHA2sBJkRF82NJmCSKAKrtYZpLQTLCcNRVTqaQdatbT1vsdLGKvzYwC4W8qhBVCyw5vD69tjoJWKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aHb+FYA+Bl44RRGXp7YgF/AwauDf4T67sKv2jEMXKY=;
 b=p9sDF+cpUL2487g+QFFy8ops/035jI98QQ/XhiqJ+r2dDnetCZwTZr0NVFDElS/JH6ZKR492tZ1ITynNEIsducG9em0CcbcofBpfGreG6ztRMehmMIF8uyZ2IF4jy7ySuz4iJDcddJZEytACMb3ShvpFvd7tfbheaJ5kj9+Xli4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN6PR10MB8143.namprd10.prod.outlook.com (2603:10b6:208:4f5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Thu, 20 Aug
 2026 12:51:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 12:51:51 +0000
Message-ID: <b1c6e097-4021-4c48-be3b-26507848262e@oracle.com>
Date: Thu, 20 Aug 2026 13:51:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Fix control flow in sas_ex_add_parent_port()
To: Eshaan Deshmukh <eshaan2031@icloud.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260819032321.493746-1-eshaan2031@icloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260819032321.493746-1-eshaan2031@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN6PR10MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c8c634-b39c-4692-e91a-08defeb9cdb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+yyCmx8gxrmFnlUNk51q+mIC2SXuo865tFCtMOFBtywX5sD3lY/ve+piesLbigX/g6oSmOrmOREgkaaOHA1bViDbLo0VV7/U4wB/2kZvQSUnT04LrYdjrSEPQ1e3EU2TXMi6BVzgVWlETSA0ZpPn0cPBTYeS8+jsUdfEi/6Yv3dMoBW1gVJ1kMvJ69yd3icWaX+RLNSUb21sX9PBPC85K+TTKKnTacVMYs3aOIQOiWof60OZumnArCkaIf3KflVC48yDqWWdMgZ5BWHk9hHi2VNfwLwe/9AatMUcXTfmUKUiYLFymV5f+sxOwZhGqkdRqLNfIYcOJGlMgdbkwGKrqVK3mdH+JwVd2Tt6PnMgPVru/W7buPXbaVjr3pEctXTT1ihQXfDuwN7+46YsEKgRDFGcBJRP4iQImjyG9WDgwks04mCz51/wMlMKhqAncPL3roQzT5ncc547xXcq4bSKWOccTuAVyzQyBr4wBql6ntcf8gw4DaP7T3q5U0T8i3xx7wv76PswY9dg29/MuQhiiDxWUNwDzO3yk+g2UaepTTnq/PJ8QCUsK7Dht71fM5t1TgqP163S3JmW6QcMd0SMoVo0Njgeu4w+vCcp0Jh/zyc1feZtJ4qTABImkKTSl15q/Dlex/rUceX1WOfziurjgCoUMSDg72dzCtpCfQQEUi8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WG84dFRJdm9TWVhHdUdyL2tqY2RLOHhiV1JrQ0RGU3ArWThUMmpTZGgxZmc4?=
 =?utf-8?B?YXFwL1RQa0ZIQkNmZUFKU2dmOXJrOElHWDZXS3BCUXlxVE9Cb0ZJdFduc2xi?=
 =?utf-8?B?ck1jU1RzNkQ3dTlQYWlNQndha0hkSjA4MFZ4ZDJZSkhWNmZEZzRqM0FPYm1G?=
 =?utf-8?B?Q1FrTjRDblFDMXdCWHJoUkRkemNhYWJUb1E0c1N0bGl4OHFSc08xRWZqTFl2?=
 =?utf-8?B?UkIyYTVKT1htQjJWWHRQSGIrbTh5NFJzSzJYb0tETmVtS0dmWGgwN2NWa2dk?=
 =?utf-8?B?aE0xU2ExenlFaklGcG12aG9XdHJDOHFxbUFlUUhIVHFPV2YzWVoyVGtieUNM?=
 =?utf-8?B?c2hSYUN0Wkk3TzNneDFhamZXUDNzTTVrOEVJTmp2YzQ5cE9lN3p0ejdva2JI?=
 =?utf-8?B?My9rZ29tK2ptQ1JQUS9ZaEliSnBILzF2aGs1WkZnWGZjK2VTQ2FFZE95Qi9h?=
 =?utf-8?B?R3lqSWFLQWVDNlR0ejU4czBPRjZSSFpqUVF5d3ZNOXlBOW9aZjhyVXZRRFUy?=
 =?utf-8?B?a1hoa2tOWUJBMm93OENiMWtuOEl4bzl6L3Vna2poQ0o1UUw2U0lMb3A1OS9Z?=
 =?utf-8?B?Z0tsNnliSzBTbllINEVYR3RZck9xSEIyeUtkQUFxcVlxVzF1YzZaR2N3WTdI?=
 =?utf-8?B?M2VnRHcvUEN2M3dhQlYwcDVJc3ZkSGVYcEFZQ1UxWHpBeHZ5bG5PN2d0UGNY?=
 =?utf-8?B?YnV0Z3BLbkx2TE91MGNyUDVPd0Q2TDJSOW9PZGJyTDNuMjl5cWhJeXJtWWpt?=
 =?utf-8?B?K1YzZVNxVlJqbm53U1hnai9KVkJBd2dxM1dzdFB0L1E3cmEwSzdwUjlvTkR2?=
 =?utf-8?B?UTFvQSsvOU90OU5Dck43N09oVkxGdUVLbWdsZStabWVLWEQzS0NMNURRZDdY?=
 =?utf-8?B?OXpuWldkaktrNTZDRkt2bVNDckJXYjRDT3h3T25XWHlDQzBhNEQ1Ni9raXEr?=
 =?utf-8?B?eU9aQmhpS0tsZTNMSFV6RUF1ZnpVL2p6b2FoNWY0SEFvYkFZYTBYc1JpOGdp?=
 =?utf-8?B?SHlKNEpXbTFpM2VrcFNDVXJ6WUtDNHkzSW1Yb0FZMHNlNFIvRDBiUzNrdEhZ?=
 =?utf-8?B?alVOWlpXOExTYzgzcnpORVF2QndaL3Zrc3FndHQ2ZEtKcDgzKzBTcFdDRGIv?=
 =?utf-8?B?Nnk5YlpTRnQ3MXJkVjE5eVB0MjFSZlVWOGlOckRhNSttSEJIajZsTFMxWWE1?=
 =?utf-8?B?azZnZVpGc0RYNWUrR2RPaW1ublZmZmhKSlZXZ2tmVGl2cERGeElVb3dRS0tq?=
 =?utf-8?B?OGZ2WmIvb3U1MzRaenlySGZES1B0czhrdnU3bXdXUGtRbWtsUndXWVlQZDdq?=
 =?utf-8?B?bFU5emtiQnlSZ2dPVWw0RjZzNlU4czBQTzVCMzRwOWd2RXlNMkVRTmoram5Q?=
 =?utf-8?B?TDRMQ0laMGxHeW9wWTQ4a2lmQnVGajNjeWVXeDdsMTJKc2JwSTYwLzd3Y1Ft?=
 =?utf-8?B?SzE0bXdKVURsOHZ4Z3VrQXE1d0R6cWMvS1MxVk9TV29DWEdtYUI0ZnQxaFA0?=
 =?utf-8?B?VFppbWV1SXpqY0NTZldLenMxMVlkRElueUpKbXB2NW1ORkZ5cWtjemNpOWU5?=
 =?utf-8?B?M24yNnUvVHZFNXViNC9IUjBkdFMxZHNQVlA0RzducnF6S29qOUZzdndhNXFn?=
 =?utf-8?B?eWtJSjYrcElOV1hQRUsxVVJxZytoZ3F5SFZVVm14cTBVMkRqSmZEUzRMOXdz?=
 =?utf-8?B?aU13dzlSbWhyZjlIN1lTdnRGZjJMUFFrWXgzQ0ROSE5velRLNE42WnVlcW9U?=
 =?utf-8?B?VTZEcTMyVmpOSVoxYTFPb2g5VVBPK1lYS3lnK1k2cTlWOE1PaURzUStMNk1I?=
 =?utf-8?B?VEdQckVoaXNERkNsRjJWcWd6LzZsYVBPQTdaOHdyVDArTlFpWDc2bjVmREMw?=
 =?utf-8?B?THR2bXY2Y1lxSUcyVW5YQnpzQjRWdGZTVGtZTkx6citWSXdldUhjR1pxb292?=
 =?utf-8?B?WGE4aHVRdFdpNWFaa05KZFkvd0w4a3l0Q1NPeDRKeG5pVXU2bFVEeDdZM2RG?=
 =?utf-8?B?OG5MSENnT0UzVE1QVFBiTW5WZ3dLbWIrYlRxU1kzSzhHOFJKcS9lNm56OWNx?=
 =?utf-8?B?TCtTQTcwK2piTXllNmVXeFhtdE11amh2SXBhdys0d3FuUUpNYTU2UkNMekdp?=
 =?utf-8?B?MHZ2djNOcThncnZjNzNwUHpwdVlnR2ZnSjY3RkNIdHdJWDU4OWd0UlZHWGtw?=
 =?utf-8?B?REhxWlVERFZwaldnamsweTdTbjVRVkVVVFZkN1FFWU5xWmFjWEdPWldTOURR?=
 =?utf-8?B?VjBZNG9tT0N0SnJCMUJWZTRJU2dPMGl1UlhMTmNSMHJHYUZGQUxCMW1QdDdU?=
 =?utf-8?B?UHFrd1RiNmxrUm5MSlQ5UlhaeFh2dnZHQ3F1OEptajUvYWg1S1k3dz09?=
X-Exchange-RoutingPolicyChecked:
	fWVPMwXBDTEAe3XkDJqnPJKmR3BCsl6cIRp9BWMOR+APJUN9JF5Ico5bDE1no3u9cCAG3jeCMf3whOS+aIsu3KBcSoMsVoLKMzi3H9s54u49sjjPrP8KuYYAfX7NGbSapdA1wsYkeIYTknwOQHqaLCuDqXnkC8WqEO/pXuxbc3U4QMW5vAnmQ6zh1ovxy0acwGVxLRAP9OyuqdVBZnB4QEkZibKMUZYNijoovXXZJ4mjFPP8tYel5WIlHpnHsDOLOautGguxvxtezudJBUOytSvLa6Ze5zho6jZtezcCTjfAfLr12LxVIHqVDQl0BQ1XOh+V0PiClkhmIjKUhQMaXw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8802rz+322OdjPxnA0WSPk5BvMcmeWuz/mnAkFlsZ7bP/xPWkbQdTDuryvJL9rKJZj+/S1w6RITfkPfmwV8/dfnTjfqCXydYGhUBCWY7uMvLDybisbGRcy9LlcJSkJgUX+heFemA22Cigsl0pQYjBOAUt81FGEVxsU503dv9nNkY+VUQKjE5Rfm+mILnkSB8h9xkXZuaDranIHhvZYncOu1uKA1VgMCe3M9TlpBeQdnyl7lLS4vGD9dT6DbJ4brshAIjbR7H2sBTLg9SeUGjOfg041PdEHzjvhJzEaLvhFKu+7fwdPuJZLvl71Bp8SrS3iePPGorBEDQ8SR1eeb86jt+w3ob86NBDvl7Gkcn6/mHepsFT8fDxGweQ1LLJQO4S8ltc42ecGhIqwxtlYviuaaREdQygR7gInUU/LfUoztQpSOKSL4lXiGy+zmqKxjd129Bv11mj9CsIwucQKp1ZOv0zZ3mOynH1TNwuPdZoVaLViSiSLZaW4iqqurMZgAjj9L7Mkz5kEdmYG7XCM0h9RbpVygg3ElofX6dZ+8ykUAdV+fllketoy1/b51zhv+XlnFdxPcsjkAAszGlQRVqh9dsdDMDaZ6Bv3syddw7rK8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c8c634-b39c-4692-e91a-08defeb9cdb8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 12:51:51.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsuUb4ZuA7UDXVh8iW96QCmvUJVcevKVQqGrJwd5VKw4jAja92z4tRDISI6uTgSJ6CgmL6Y4ZG6XFIhXYS86JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8143
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608200096
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA5NSBTYWx0ZWRfX8QfdcNnSN1fs
 +sQtz2WyuSQefOz0wtf7fd6iY4w0Tpr410ThU5L/tz6uq4TQRrgn4Wx20VhfMh9WdlWbz/U5PNs
 SK6hAYN6dr+/0IszDb1OJE1zgt5kEztMKqVXqXxY8Eo73QV1XRFy
X-Proofpoint-GUID: X4BXwXJ27Qni49VCRJLC72b3pSOHWOq1
X-Proofpoint-ORIG-GUID: X4BXwXJ27Qni49VCRJLC72b3pSOHWOq1
X-Authority-Analysis: v=2.4 cv=WNBPmHsR c=1 sm=1 tr=0 ts=6a86f86b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=63fX0vQLjrNfYtIIRR8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA5NSBTYWx0ZWRfX8nlyp7SzDdN6
 5wCRmVlhrTizuMvEQ7Kd+sktDQwNNgUDTBE2ge5qqPZnz3NChoOZdXuPsuY5ouxnKywmfFO96nY
 2rtG7WntBVWJiHMBY9OLW7amo9qEs7e2kf+jNTYbMz15IzDvE80l+5TUcVd77MNxtjzh0i4nD3c
 QAteqXJrmq3sCxlCnJXE34BaQyJ0Mq2FBWhLJGBW9CuDqLcDmsMS9O/W/o/y4/tO7/HQC4JHM7t
 jdKFgK0w2g/aIiNI/SDi1qnVJC8jcUGxQSDOcgWH94va2W7qj+Zy94obtrxfzUoyGHH3zVr+Uie
 MYVu/RmIz9zKmrJgmICWKf+HIyMrAvPi+IsF2G8AIOslL/7ZDFYdmE+WwHiUfg76G6pmODjM6zw
 rnIrwLjtbLM0gO/KPaluO9adOFBRcjADPIO4k5NyLrDyVFpeiUJtBtZjc2G5wwxnSLs27/W8HYn
 8bzX6UHlwEY4prAuJ3A==

On 19/08/2026 04:23, Eshaan Deshmukh wrote:
> 
> Fix label control flow for the function sas_ex_add_parent_port(). Remove
> labels and move the code back to their original places.
> 
> Eshaan Deshmukh (3):
>     scsi: libsas: Handle errors in sas_ex_add_parent_port()
>     scsi: libsas: Handle errors in sas_set_ex_phy()
>     scsi: libsas: Handle errors in  sas_ex_discover_expander()
> 
>    drivers/scsi/libsas/sas_expander.c | 75 ++++++++++++++++++++----------
>    1 file changed, 50 insertions(+), 25 deletions(-)

These changes look ok to me.

However they don't apply to the maintainers 7.3 staging branch - see 
mkp-scsi git. Regardless, we are in the merge window now, so I suggest 
that you rebase and post again when v7.3-rc1 is released.
