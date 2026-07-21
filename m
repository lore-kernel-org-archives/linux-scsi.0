Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D848E1D416C;
	Tue, 21 Jul 2026 12:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784637266; cv=fail; b=C8OHlAE+oTWMOH5uz8GtqYqx9SrWxEpj0IlQwFQNXKzsoD3UBBwgmHBHWHYAhSg0unYLQ7sQj3egVJJJ5LdGDoVHUlidt4Llin1aHT9gv1u7NWFYBV703xSwKLayXVKwMZW4EuDR5WzY1rn81CK5TGh0fx+0piOsJwYUEruypYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784637266; c=relaxed/simple;
	bh=L3YXYqyVSdu+2QN/0/Anrd0NZw8qUJWRhPxqOvnjfqw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mLpvSm5+GL0UViKoFGRjuHA9GaRPvYrZGC6y8qgxWAo4NR1q70FZpatYEhEqYGYT2mrzSurpOxygfq0bRUtTbB+E6qf0MChPvhdVxh4vll2ghXa/miwy+R3h2xvZh3SJyolom7ld8sQyCQKc0yYnW/u3nCx9FYJZKCgwren3ig8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e+7QxClM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OwzMysLF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e+7QxClM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OwzMysLF"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L3h7M83501917;
	Tue, 21 Jul 2026 12:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TlpZOew997f1HYQovGohK6PpTRyZ/xd0FjdEQKrxpME=; b=
	e+7QxClM42fCGGCUTSwoeCUe85elPD36B6zkzexdQyIFMiDpzMuZX9TEKffVvAXL
	w4Qbpsw3jpFEWqCTWnlttxIhz7Z92e60vD5tPMuAnPjiwKDzboMxFND7xiw+uFmW
	d1zOlyrcS5dbq5NXzbaHAO/tP6cz8+1Y0Uu67+cQJqUglCgiH08BBq8aXL09CiUJ
	WjV8v1wGIZ0QOGTq2R95g/p2MCuM7HaCt4nmZpQQ0djIacFSPpFUEXrxZlbhgz97
	j8LSgWZh04vsSW+21eXU6hYfgJyGiJkA8/dM+Egd2M5XUe+ZTkoxTQ0uIpbGdJYg
	qMC93LpvpVl45klF+xfwtg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpuc3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 12:34:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66LCXYsm012027;
	Tue, 21 Jul 2026 12:34:05 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011063.outbound.protection.outlook.com [40.93.194.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxpxbk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 21 Jul 2026 12:34:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4+icA5u6DhzzijJDbJjx+VYL+9MBh4rQDbHHSeZ601t7794lh/AlPnV4nbhSR29vfcsgTxO7HAmkpz1GM9bN569OENgCwT3C8e1TZ5FG0nWj/lWO/+zqMAt5wqSdkGQ2fr1cTKL/s4ouqu+neJBWeyo5HW/HvZu1+vNH244gLHUL3LVM9zmzFFys03L+LdM8uhTL+x73iEMF1umqhxyfrdJ+A6oKkPsJt6H6IXLEmby0Vm7bVpOrEfaEW9QSepKyhF49STubwXWFUyME6xKlq7W77XVz2uJ3goaZFhYrVqYUtEE5l70RQ8EUqFxKoQbHwOsvEo6BfF9PQ/J3cqf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlpZOew997f1HYQovGohK6PpTRyZ/xd0FjdEQKrxpME=;
 b=rS+uIHAoj/gZBQJfThi+MC7EQxdd6PI12/b3ykc94JFtjw1PHZiD3HsxuSdtllS7dHuE42DjAvYqIcX65y6kU4zwSy7gqjNtllX5HbOG2AMPvg5EPchOMmzll0hfV0iJEFPapu12AIukqY1TB3I3Tfx86xzZu/peOAQHxsRQBPW7fTUYCh2U6QskkVlrv3nUqI17YlVPk73PytoYjYghlFxH0xfUXmNMRfNpqnwZxWinnkLmdVi/QhoiVZJOuXi1oC+UcyRca2MEIzg5vw+DrdYn7r6OeJBu4WdKU5DjlKL2pjflHqOYz3cmbZpxXYI+SSmJfoaHOtmAXF3Vw3qHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlpZOew997f1HYQovGohK6PpTRyZ/xd0FjdEQKrxpME=;
 b=OwzMysLFzilwWzBRi6t/LgytQzKmmtUpdioyllmc+neMwZ5iRhKcypMq/UQBWmkD2JVCexBZPlFaxlRjUWwtcUxAqJ0vpAr/psZQcn7LabFqJuzF64uufUOvOpFbX9PqO1bu4CgohcXet75PooswnsGVW+j7TF38X6Zs3S+QR2I=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB7700.namprd10.prod.outlook.com (2603:10b6:806:38f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 12:34:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 12:34:00 +0000
Message-ID: <a2ecff55-aabd-48b4-a702-7e052646f22c@oracle.com>
Date: Tue, 21 Jul 2026 13:33:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
To: yangxingui <yangxingui@huawei.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, dlemoal@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        hare@suse.com
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-3-yangxingui@huawei.com>
 <c9a91dd7-b158-4416-93bb-9ae1e1acb8a3@oracle.com>
 <55307987-d86b-f28c-7c39-0a6bafe182bb@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <55307987-d86b-f28c-7c39-0a6bafe182bb@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0086.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b8d552-e4c5-4c57-e371-08dee72456e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|3023799007|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NkJ461QYWSHLuPN3sGnkjNBzbvtRtYqhXEI1xqWfEXQ/AZXvY/ud/qDzLPB7w3kzXEBvWYI9us9ULU4rqga/0RKHJ+nAzbm+5rNufq+Zu79ShzBG9azFfCsJvHeUF1MpGc4aOhC2aznl0npgKRYzzKkUfWyGlVgtVNEiJKyPBGO3mloyfBjJ4VYmp0vOr+mvkcHp8B3iZx8Sl3J3nst9y2IkyU4PN0DTM5Bf+KP3zHglVT2Ncp1TR8uXz54/C3KZrKoTZAno8npQsy7S0be8O7bS4lBKHbrtOxtpmQufxZLOCjOMkVBw7LRcaTPbhiaOKe08FTXIigJfnUR4+elFO0YcyGbUOIDT+HdN/17qwhHQbndNxzPhhaBxSxp2m9FtK4JIGLUxJc8KH9sKpk4SaFGf5cZj2jW3qWGlANCpo21RCsBptMvVNsRftq0NqwSM5wXnFdGCwH1DRg1pdLVJo4aNj/TWIqn7/zCm2hqCHvDVqJagOQbAbtitMnIRaFS9gZWx9tDb57YSxfsDJo/OLSkINk+DmwzpbDNoj763KD+tivwNlVx2HQM1qMhU5C3UNUOLsAeN3qJws0GPRPAtEfm38WQoBk0LI0dbF03CoR0gDf/4RLJ0VLfUtJped6ghvXRI3kw254qvS+EAsaeXLpRo+y6qdZJulxjR+UjpQh8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(3023799007)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm5BY2xDSkV4U1RPbVY1VkJVVzNvRjhGU1duU1I2MFkrbmpNMzJzWmxVWDFN?=
 =?utf-8?B?TGRxR0JueU9QZTRCVlFxb0x2N3prQTRwZk45cWluanVxZWFvS3JKcmFZVExz?=
 =?utf-8?B?eFVNZW5jWkk2NGlvT0pPUk5TV1ljVThrYnYrc1NWdkY2Q01Pckc1R2xoQnBE?=
 =?utf-8?B?YlpuU3hTSDVoamp0Q2ZxVjBsc2ZTWVdOalc4YXlWOHRwSGV2ODllWDFFdCtJ?=
 =?utf-8?B?cEVmMkVFb0ZlNGZTbTN3WE9hZkJzNWNSSW05dTBvRUhWQ0h3Y2x3M1ltWXl2?=
 =?utf-8?B?ejZ5c2RneGV5WElIVHBWV2U2cld4T3pvNG1WdUxnYTlSNkhYbWJyV3R6NXpx?=
 =?utf-8?B?cFBRY3ZvK1dZK2EyZlg0K2FBcHNzZVQ5TGdNSkVDV2RTOHpvd1lKSlFPak5V?=
 =?utf-8?B?Uml5K0FUZTNQNHJHWGRLb0dhY2Vpc3BNdFJoUkw5NEp6cEJQMFBxT2NTSWk2?=
 =?utf-8?B?ZWgyazJDUTdEL3lGbmQ5cHdHMDJPU0FXZGdyUVVnbktCNGVMc1JBRE5FcDND?=
 =?utf-8?B?TGtyenFtM1E2d3BYSmNXNHBjQ0NXRGgyL0FtQzl5V2FJd095K25JRmJvd0R4?=
 =?utf-8?B?b3hEMi8zaGdTVTg0QlNTdU5sRVMzQTgxRjdSd3JsWElqNUpTNjhEUW5rZTVC?=
 =?utf-8?B?OWpSbHV4Q0xsNlIwelZxdzMzMDMrSVlsUXRIY1p4V3NLRDU0TFJvM3k1WHNO?=
 =?utf-8?B?UzZXKzJUTmRPcThNa3B3bk93d2V4MmFadUwxM1ZKUXg1QjFtQ2RVMi9ZVVJy?=
 =?utf-8?B?N3MvRW92akthbkd2emx4TDVGZEZlNEhZSjRNYU03L0t1VkcvSUN1V3I5aHl1?=
 =?utf-8?B?REIvU1hsaW0vVER6VFN6UXZGdk9CY2RuNmhwQ1NuTDE0RWdPbzNCSUlPT3J2?=
 =?utf-8?B?LzlkWmd5WHdJSUpUdUI4SzZyTEdoa0ZuWXNORjA1bXQ1UjBUYVJKQzdndWhZ?=
 =?utf-8?B?bUdmcEhzQlN6WG9vdExWNGdZRk1VYm5RaHp3MmxHU2g0T1JvUkZEcVdkNmxn?=
 =?utf-8?B?SDdFdFBHUnVacVJiUjE1S3dkM25ob3JuNjZyb2ZRZFFiUGdad1dzRnpqUzJq?=
 =?utf-8?B?cGFUMFRhaFo3d0l6Q0VQMkluTUt4cThibVhzdTBaQk1TMDlvdC9BTEZ0ek9K?=
 =?utf-8?B?VS9QVHhMNzkvWDQxWSs1eVdsclk4Y05DZVNjSmxoOHlhUkpBWTNQWEtaeHVB?=
 =?utf-8?B?a1BUd2o0dXRrQ0JZTXhDR3pnd1d3NXZOTkM3Y3JGdlphTVphWDZYWk9Ra3Vo?=
 =?utf-8?B?NUl2SVZtbUNqL21MV1ZOUTVscmFoWTVmeFR3OXpYb0FqUGpsTys4c2w2UUQv?=
 =?utf-8?B?YlVpdlY3NlRScndId1RuY3MzWS8xT25yWmpGUHZDR2o3S01wNHVmK2c0VlNr?=
 =?utf-8?B?cWw0bEZXZjRvN1BGU3BmaG1pbGRxNG9MRVZUeHk4cEdvSHZOYjUwbHE5QThx?=
 =?utf-8?B?Z1N6RU10ODNkNThPczFmbXprQy8vVVZwY3NkWmxNaXdHTTRrdW9pbzdiSnJx?=
 =?utf-8?B?dXV3MGVtMUdUdlZ1MzBkN2o5VkdzamlHdlhOOGJWUi9USk1LRmhRaTArQVBy?=
 =?utf-8?B?M09GVnRZQytFUFZGNGdxNmhESDFEd3FJb3JrQjY5citNS29nV0FtWk5iUEhH?=
 =?utf-8?B?N1ZoNTFaNHdDOTR3Q2Fud2dlMVBaMWdldERVcHZ4YmZnQ29sRnRHMVhvby9l?=
 =?utf-8?B?RkMwMFh0VEw0WGlWWXl0WnkxVU44dU8yMXVib29iNlNkWEpmSGZYdDNEQ3dt?=
 =?utf-8?B?c3doOEIzSWZpaVlGSlBHOTJ0dk9XVk1CVm53UWY1K1gybFRaNFpzaTBubndq?=
 =?utf-8?B?Rzc3Vm45eFREbVdQOXl4SGtKdWxrUE8ydnVoTU5Nc0VXQXhBTFFrclhpVTYr?=
 =?utf-8?B?aUEzREFDc291S1FLTFdIZFFXZkNmcVV2aGxYc2xQUHk1WDhvcGdLOGpXTHF3?=
 =?utf-8?B?OVppQ2tRTUJRbVIyQ01wdFVoQkxDUVkwM1F3MERLNCtjRXB4dFdOdWtOL2Nt?=
 =?utf-8?B?TVBmQzkwTlM5aWpOR1NNNHBLQWtsVWc3RHN5a0ZYZ28yQlp2VWtUWFdMbENG?=
 =?utf-8?B?SUdWdktwdXZvbzJzdmZzMTVOTmQ3ZUF4cUN4Wk8wYUtIV1lGVWNYU1grZE4r?=
 =?utf-8?B?Q1BpRFRkckdhd1ZLNDJZaW1uSHp6YmUrRTJXVkkwZlZId05OMGhJZEQ3dGJB?=
 =?utf-8?B?VWlZa3FFbWl5ZCtpbndGMEY0L1pINVcrYXVtNEZMejhuNmp0WDlEbmQyNHVP?=
 =?utf-8?B?VFlVa1c1VVFUSDBQSjN0N2F1V3d2R284SS9oSXh6Z0x4K2xJSDYyZVNNZFdY?=
 =?utf-8?B?ZVRmbjZFbEVXT0lMUlRQMVpzMW1rQWlWcHJzWUZUOVFVZkdyUVRBUT09?=
X-Exchange-RoutingPolicyChecked:
	A4+bv7or0uKw2USdcezG/sjUyH1fKKzyyLF6ytx0yxwmMFdoGk8NPDmu32IY/LK5zXdkbIXcjxzG2uOdqGr75/3chgyco93gC6Suof0BXN9yABspg12KhtWxOmWhaGkoUFLZKn0RC/npJwMY9UCxrrqS0gFb1eOvFK+sRBE9CUtx+mjTIYfqEGWNRmc+n2deefF9+XeRFAK/Sm05UX5tCXMwsCnnGNDrlenH9iULXYWGxpre1XQDugrFTze8oflWH1Amj6X1ES6UWIxaDA/2LAX3n+I3vNDzhh0+BjuruIUzCDDwsc5ryRP9wUpr4wYjD9VxJuOq6+EapQK5rpvf8g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IM6n7ICPTB+r8TVEDmrfqOP7L4KqHgbPNU5TTqyAtw71+N8ZcqPtTUAOH2cc/iyShXM5rYwksliFpdmfX1ZuubF7swFHbr1wjW70TV6sq2QYwmzCA4Z1++vs9ZHPnY37AO8mxoaIUVi9fRKEh9477yORleg5z1RIGWlELmOtTAcsKxjbQf7nFpTrqLhfdUvdZoRej9f4euPQhmNSqxWqXT0jtNreVgLeUDiUdnSoM3vtZcQK+6/2uMXLSqp6BMEFV2EuUpZWe/lFUiTfier8ZK+hfRWvgzbbsurQISveeSVzznXkqcZY4cE2b6ylhVZhJI7lsuPhIIBWTF+Dc8XKVWrPdesvEJTN1Sq+6Uevfgu5qipyeqTwpD/3sd92mtRnRUT5vvlbUiu4aS/9RwQg/ghTBOv3hbf2mupEgRb3OIo02uMQAveUfcgTFV2p0720uGV557Ib4tENHUqcBeEkR0HNtKQYxiUwVjMtbaRmKll8aecCRs8AzfV4HcwbFB4+EvpQkHTVDkxLeD4tgaH7RP7np56N5/69gOKuWq01YTqO7fz1GOfuLxtJaddXTXPm3vtwmgFFKa7aDEYMbXnknQdeuOej0MA5y9tua1EJeUw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b8d552-e4c5-4c57-e371-08dee72456e8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 12:33:59.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kdkou9TfmYPC2roB+rZVr6mG3w4tVoby7gI4EL+DE13EbsuxwdLiiYmUIc9YW0ILSY8QITH9SePa8Nvu2xKTHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_01,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607210133
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDEzMyBTYWx0ZWRfX3mkfxmpfVanQ
 EXILQRCW2wxQrY/SlxFj4zQJEjZRHtRnegOn74ZkvKg5fiOe4TN0bi7ojU/y6u1Qko4D6zT3fel
 a2k4HX1NXaJOTsxthKTsXyA+m/qg897g045CMGLUxQElcJkubdwi
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a5f673e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=5MEqyI0BfqJA_6nARUEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13632
X-Proofpoint-ORIG-GUID: 6LfoBV_-_r3kTWaTafXhn9GCwt-HcoMS
X-Proofpoint-GUID: 6LfoBV_-_r3kTWaTafXhn9GCwt-HcoMS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDEzMyBTYWx0ZWRfXzDihPbhHBHvI
 iZAG2qmxXDvo2t5yrhiMCmy2lheHHM2t+Gjd+SjWHaEXYjjVEHIaMB5U2Y7XB3lwzzrgtb/+iZ+
 OfbEyuGrH52rKeBq9vGO0XdtMqJuYSy9M23O45YxWHMH2Qcn557jh9RJYm4ErNRCb9VchzSGMhi
 1h6z9eVWjwjn8foRYGlgrGPmKlsrdGJaSEIk7k/bnJivPBvtVlS80XKWFu7r7gteRaP+ppmw0+O
 IRpqasXVlgeA5Yfb+c6QhQDsUwwZluZ9mNF5sByJENITrfJGGgKsNkXLruhv+Z2UDUNc7T5MhBK
 ZljQib0ar+FZu4JDhuWEIRVmRkrESfzn/9dsIMcxTN9iwqag8+a4sg1BS5hINC/T8XqhQ4Whkeg
 UTwoaAsxG7+RFCQi60b+0qBx9KPuEmVYLaBJoVDCLyeAOcvCmgQ4DwnZ+boSNgcUXX7ubY77hmU
 xsJTIfYOG3FpgoV8HfwJRyyqCthAz18yDZGxV03Y=

On 21/07/2026 12:10, yangxingui wrote:
> 
> 
> On 2026/7/20 17:47, John Garry wrote:
>> +
>>
>>> +void hisi_sas_spinup_notify(struct scsi_device *sdev)
>>> +{
>>> +    struct domain_device *dev = sdev_to_domain_dev(sdev);
>>> +    struct sas_ha_struct *sha;
>>> +    struct hisi_hba *hisi_hba;
>>> +    struct sas_phy *local_phy;
>>> +    struct hisi_sas_phy *phy;
>>> +
>>> +    if (dev->parent && dev_is_expander(dev->parent->dev_type))
>>> +        return;
>>> +
>>> +    sha = SHOST_TO_SAS_HA(sdev->host);
>>> +    hisi_hba = sha->lldd_ha;
>>> +
>>> +    local_phy = sas_get_local_phy(dev);
>>> +    phy = &hisi_hba->phy[local_phy->number];
>>> +    if (phy->identify.target_port_protocols & SAS_PROTOCOL_SSP)
>>> +        hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY);
>>> +    sas_put_local_phy(local_phy);
>>> +}
>>> +EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
>> This could go in libsas
> 
> Hi, John.
> Are you suggesting that we add an event like `PHYE_NOTIFY_ENABLE_SPINUP` 
> and a callback like `lldd_notify_enable_spinup` to libsas? If so, should 
> libsas parse the sense data directly—for instance, by handling it within 
> the `sas_ssp_task_response()` function?

Yeah, it would be something like that.

But the method to solve this issue is unclear.

Back to the original issue: hisi_sas_spinup_notify_work() calls 
sl_notify_ssp, but sl_notify_ssp is called already in 
hisi_sas_phyup_work_common() - so why is it needed to be called again? 
If it is because hisi_sas_phyup_work_common() is only for 
direct-attached disks, and we need to call sl_notify_ssp for expander 
attached disks?
