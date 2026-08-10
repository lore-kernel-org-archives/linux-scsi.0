Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A6232FA3C;
	Mon, 10 Aug 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786377434; cv=fail; b=F1IHP9cAA0hNyVy6km8io5LWDMWqza6wcoW1L5fYF0h4ej1QOkuh+LnabnKOB7r1ZlBsSDI9S3QbXCdtRADGTrEg5qnYuA2ELe8mePzjzoU62sIbHkY/k3g+hL7HzcejCBjWuSdjmSmTeV3riHNPD6JxHGck4/tePFfk3zIaFPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786377434; c=relaxed/simple;
	bh=GTYjkH+Ep7S26ekDbw6qJVjgRb/4zD/RHhP7qdSawFc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JUXu1uhyb4q9tovrZ7xpI4sgIwEObG/kqKX3qtUocTHBqX16qU+UEwHJ3EYJuwYT9KzorPjc5hdB3IlcaZ4PILBJ5RAlEpusRt+C21JDhJdcrEBBBaqWiuUAuScG0OM3NWeaTkaQ+QBKj946zEjwAkSdgcMtlliOL2+iOwSQN6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UkcXUJjS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dC3/yrvn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UkcXUJjS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dC3/yrvn"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AFgBpA1302145;
	Mon, 10 Aug 2026 15:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Jqc585SQ5N3JUosu8HV2aUCSPD4yrzMcsPJYkd8YQAU=; b=
	UkcXUJjSXko58pHq9QA5Eaq422cqwucAFapSWZFu4yp6rnBwnSeJ6L7nQSHCgLwo
	7G+8FNBixjzmfjFGvBT6jPkvFgPV6wwrilcVqV0IZt4FLQLW2zbC3PTRD0p8bMv2
	GgEdhhXkGiQqYaBiPvosAA7Ir9IrL7TqXY9OnHhogkz8bTbLviJv1MK40WGufJ8h
	Urdigm6B1/4dd+Ub+jcGXQNMuuyz5FxnnKGktSuoxlcKdppvSikLvfvpFzqR0xdH
	55IL0F32Of5IHkbs070TOsF746rYLRvMAIWXs9V9ovjU8kTuRBgNZcqn+bPnQmDB
	YejpMfJkMA7Fuk9GoynUdQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvhdtw6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Aug 2026 15:51:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67AFo64G008427;
	Mon, 10 Aug 2026 15:51:47 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwc9u0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Aug 2026 15:51:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eqlgme3yh3FJjC0C5ffQPrsrudPlQ7IlsLAHEzZxDBAPDDkFUqHnZSOGONHfiymIXi3apWzz/tUTKeEzGvi8h0NZPzZ9X3NRnVVwdBBC7wy5IoWQ5WUiz7bJJebzfjPgGuYrYbQKYw5MiADCFHsRAyLLPALRmyLr+/YPj3eZYRA14DHBygl249CNPVyv5n1murp0lVmZXjZznlK52b0NqIztzUmGwTydYO8fjXF8GZBn98iKTtPczXzy+eXgR6mo++auDoITxfGRMTdfbbmOTkVM28MSLSP07c66Iyz0w3PGbr96Bqc0F789Z66NUM4vOCNAGrC1eI+9wt8BEScuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jqc585SQ5N3JUosu8HV2aUCSPD4yrzMcsPJYkd8YQAU=;
 b=OdVH85T81Ie5boPNLGuOGgD3SIrqywmonW9ZqzfHxWBlt3Nj2o+xPV/ImUCpB7eW0cudEtwvMeyNqEiITRVTX8FmKlhWJuAaixory3lmwpBUxLQHoZEDP12DAdQAzpdH5WMSMc9u4/3XIdLwWYXtsofcVCc3tWLKtiabL7XktBEXfwPTsZu3ffKuyp4sfg+PqLm3y3MkTY+Bfk0YHiLn8IM+9QkobUXffajXBnZIXYMryZ8JeCbKxObeQm0Se3ChbibYJVOWCKsFboGryuwcuLikTi6wnSv5GFKlERHX3k6BtDGb1c1WNEZ387P6O6Fn83KIWlcbTNWAPpvXSnwPEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jqc585SQ5N3JUosu8HV2aUCSPD4yrzMcsPJYkd8YQAU=;
 b=dC3/yrvnTilRNu3aDWQnsKx9SdzadBhbEJTCz5sNf27Qanfst1iBZd3FCC2xWik/PbAkTkgoyJThOyubtLiLxakS4F24l1SZLDI/pTP4TqWekajzD9Sq0gew+qrTkDJxbnUH6aESKlfmLrHB5HvWg3C6AVdtWwPJOqY/nEKAI8I=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS7PR10MB7375.namprd10.prod.outlook.com (2603:10b6:8:d9::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Mon, 10 Aug 2026 15:51:41 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 15:51:40 +0000
Message-ID: <11581a25-caa6-4ea3-9aa0-2a4dacb7f34e@oracle.com>
Date: Mon, 10 Aug 2026 16:51:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/2] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260624063230.3264029-1-yangxingui@huawei.com>
 <20260624063230.3264029-2-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260624063230.3264029-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS7PR10MB7375:EE_
X-MS-Office365-Filtering-Correlation-Id: 55eb8248-8e05-41d9-0da3-08def6f744af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|22082099003|18002099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	yJkd0x/dT9j3FgZyIkgASyJgDkpnTgw8rpTzyVkX5S6pvm1ET2yrZv2JNkCAlJNXUGvQ5Xqsv06GJ4ibuv/noWullP1PKiqdZDcL1Ajp6/4N5KWsmN/+5sIR/W5s3eq0HLA7i4O8rekdHt+1v4vcLh46PfNxn4bLFw8kgmJRdbW1OF34oHRvvxnTYprqGjq1z3pB2XjXHtWraVXPKKyWDEjT8ny6yzaxNluyWkKB+5ofcLghW0ZCRBioSV6yv5CkY/Gwo+NWIwMJ0KDwX5y9CjRakcXHxIPgFrUlxevRo7rM+ahRr6ijmeiDpQPNCBl+OU3w1nzxft2nAUb8EG9yotGUah+KabZbF8iC1BuwZk2SHFkE9vxyWIO0rpIp/9pJ8F+YPM5NlKsFGgGgV7RIbn9e0zUFkweSUNTj3UiiJU8HV1izdjbyomjBjIWJn7xKiBX9WXz05FpMZHG5xIZ3RRvnlvDQ/vkdsoG+2o3ezqE7edR1ITQq8lyqga9sdeyQzisKo8MKPwnuBmInqLuwx6fshbC9jpRyei9OEg5elPtcaJxQycehWKKi1x9o91RcPZJ2AjVW6d+JKQFpow7I4ee/3ahXXWNYhbDKE6kq9EPGAr2+zxhExhkf3r7cVBoKjo2i3m+nAHY7rp5EndYdxLl2LmCcGvC7nY9ATSRxD/I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmVZNFA4OCtESUhoQllQMlJ6VkZXSm5ybXp0OGU0ZWRVL01kVGlWa3VLMkhm?=
 =?utf-8?B?R1RwZ25ZNVNHNWY2SE5rbmdQbjhUS0JheDlHM3FKa0d3Znl6eGNxQlF3MHJl?=
 =?utf-8?B?bktKREJxNnRsYThZY1ZFcFlBT1pjL2ZUc1pPTjFNUmx3aDBJSThuMXRmMWho?=
 =?utf-8?B?UmxzUS9KeGw3ZzZEZVl4YWNNcmNJdHN0dGdaUzE3ZDZZQS9na05WVlIvTjdQ?=
 =?utf-8?B?K1ZHYWZUTTVTaE11NzhjM09yUWROMU5pTzd6V2o2NGZHSU9VZnE0Y0NrZjlE?=
 =?utf-8?B?WXJJd253dTE5WHhpV1FvOTA5ZWNpU2dYWTB1Q2pzTERPZG5LbWxyZmdJVVJQ?=
 =?utf-8?B?NndwZGFsTFJhbjlLRDBzaHlXSUtYdFZBSTB0c1J6S3hWeFoxaU42bnc0b0tO?=
 =?utf-8?B?ZzY3UXVsMGhONXRqYmErdDJWSWhRQlBTYW1laHpVMFhNT1FUVzV5cXRTOUN5?=
 =?utf-8?B?dkM1ak8xbXJJcWxGaTk0MVNSQXBuZ2Flb0NscTZJYmFHWmNGYjYwNEVreUpy?=
 =?utf-8?B?WC85UTVxUStlbCtjMFowVm5WU3p0OUFHNTRmMUZqVTN1ek5yN0NTcjhNZ0dM?=
 =?utf-8?B?UFg2b2NkQ3cyQjMxMXljcHdBL2s3NGlkdHg5aStJcEh2ODdHcm1GWmozOEg0?=
 =?utf-8?B?UlZKdFllR1gvVEdKWVd3RTBwaVM4VEF6aFBsQzR3cU9pbXlJbGxpb2lOWG9w?=
 =?utf-8?B?V3BHNHF2ZVk5R25xWjZzWkZRV3ZJWDlaYXNXdU52RVJSU3MrMEcvNDl2em9n?=
 =?utf-8?B?NDVHQUZNMXoySlVkaEplb2dsQXBYSlZyNmk2cjJLd05xQ2RoVFhBYmQrWVR2?=
 =?utf-8?B?NVN6bUc0eGNCbjcvUWJyUTRCdlpMMFk1eHB0UUF4bm8zbTU0MU1MSDZqcUpx?=
 =?utf-8?B?QzJYTXBxS1ZsVzRoV3daeXBXU3pLRE9WS2pkT3NqeEFNcUlyNW8yLzNkT2lj?=
 =?utf-8?B?SUZnNjZhUWZFNmQ2VjdpVnZGZFk5YXdBR2ZCY0tYRUpCV2hMNnQwUmpPeVcx?=
 =?utf-8?B?ZFljYmUvVXpndGlsYVlKTU1hUEdVRzRLRXVybzVYVzNEQ04zRmd0enJPNUFH?=
 =?utf-8?B?NkN5Nko0cDROZnhMV3NPTmtBT0xOajByKy9WdXJaU1JYY2FBdDBNS25WeHd4?=
 =?utf-8?B?YytDcHVVVW5HbzY2MXBOc05ycVl1RzZTMVFLSy9wK2R2eFNRK0dGcUlmY3Rh?=
 =?utf-8?B?MTUrT0dyMHl3UnlyOE1WM1l5UVExV1dOS0VLTnhaaXlmeCswRlRCNFh0WXV6?=
 =?utf-8?B?cEExYnhTUDBuWGo0MGJMYzZ1Y0dIVXJsSnY5WGVoNWsxanFsbTZXRU0wYjBj?=
 =?utf-8?B?UmZXRjIzWVV5QUxoeDNQOUxKUkxPb0ZTVjBNZFhoc2pvSm9vWTkrQTFrc0xy?=
 =?utf-8?B?Q1pDUmU5U01QbURtUi9LU3dvYnVPTC9tNFhsMDIwSWs1ZURNaXIwT3VVN1Iy?=
 =?utf-8?B?cEc5Z1VuVmZLMDJVdXdVVlo3cjZmckUzdmNvRk1Ec3B6WktDYnh4VWRlMEVl?=
 =?utf-8?B?MWVGajJTL1huczRDcEgwL2RmZHdvcWRxRTg0RzFLcHV4amZ4S0p2cUx2NTM4?=
 =?utf-8?B?RGxXVXRZUlZLVVhTQTdmbnFlM2d3VStlSTJneGR3bWQzeExzSy85dUxXQ0xJ?=
 =?utf-8?B?MHoxcXhKU29sang5YkJPK0ZKUEt4MzJ1ZVh6aGZsVFFoc0VMbnJ4cTVla1Vp?=
 =?utf-8?B?SllQbjhkb3Jpc0tLblVMN3JUSEJHd0Y5UmVGNG9yKzFydStsZEFOYjA3ZnBJ?=
 =?utf-8?B?NVJZY0h3VVNXVlZSMC9XckVJWElaZytnL3ZxTHpwTEE0c29xNVJ6amdJUHhZ?=
 =?utf-8?B?VGRCQUo5bEc5NjZFT3RYZW5OWnhzOE1UTW1kTnI1clRZNjUwWS9lQlVMSk1J?=
 =?utf-8?B?UjZJMDNHZGtXWlRnaXozVXhPajNjRTRTcVNSV0NnWDJKdkJOQ0FwU3hjL2Jz?=
 =?utf-8?B?M1l5US9GZGFROFMzc3NzdWtGMW95WE5SRUFTWW10YXhCMk1QZytOQzFMYm5u?=
 =?utf-8?B?Z21BYjkwR2IxZHlncWRhYzF4eXR0elJiSWVSL3RoWm83a1dwWDFFZnI2MktJ?=
 =?utf-8?B?SzNqUkdzNWV0bWFEdnhPSmhma09RMEhIcmFVVmRpcG05UG1vTjUvYXpDa2k5?=
 =?utf-8?B?TmpuU1lKMDdlUEhvckNJeDRudFlFS3U2NmFMYXlnQ3l4aGpxVjZ6WnlJcmpk?=
 =?utf-8?B?cVBLdVhoc3VkV2p2YkpIM1ROdS9tNFZnVmRhRlUzaGlLZVpWcW51bllaWUwv?=
 =?utf-8?B?bjBYb0N0aHZleWYxN1pvVVFIRVdBRVFYc0VFMzdKR2pqRS9oWmFDamluMTQz?=
 =?utf-8?B?RFNDbjliT2lpMnJRVitHK0o5alE1a3dmeTBNVFduRHJaMkFUdTM2YmtwakY4?=
 =?utf-8?Q?ZEIP70RHIuAORBNM=3D?=
X-Exchange-RoutingPolicyChecked:
	H5rPxLPJNZIHBHrJoLA7xxHrlVhg8fLnrlaOv4nAukPfXulboSD/iV8Qw81QSWArij8pRnxLpgWiRYzW7z36edgZ5/gBLgvRWYSenplM5dXpCiLPjUJMyStExVbonrPIQNzA0DyzNtKJNAT1Aqa6RcIlWBV9z2do8lwBuS4UDa3u7PkH8t4KyPXD3NdcxKPhmHQXONz4JhVctm8jLDh3wKW4035q/bPHEpfjKOjFZr2xBFiBPpImp9P2dAUBzlogQsK714SqntKnYuECbYN63kQH1YTx0cSYDRSftx1yIIv7FfhPrNn3J6rlxGu9GvyZk+CNXdICddr/EA6OV5s9qg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wI71p6TWWaV2REsGzMRFYDrXAaQLkBXLSiGWOz+YXFdtXuyEaoK4aJrzHIoRo4Yy2lgFEDHcnAAVADWpTJwdin+rCDP4Y+Kijt8uJ5n3ys8mJunQ2iE6hXuveHHtVIOzsgYTyOrYy/uG/7TBtxbKo1Gbk5BTsm8hW7W7iLHf3PVE5upNGyGflbdHg0z7bvt8tdFDrU5ZcrmsjFltN6rV6dYg3SsQeiS2h1MN+I3h5C5i+l2pARa1Qws7Lz/xZeIhXuVPGdo1oR2MpeWxzkLfOLHCBO3f1BedC5ANHMsmjlLKm+8AiKQVgCX1gvA6euqrU92uJBPMH3ekWTxYJkqokAeUbJNDlYxdfDcrUEt1YaPFzK+xlk4KggxK6BE4xJW3XhHSgQiKdy1m5aqfTPM/LpcEa/1ra8hRb4Np1TpCZth7jWp4AmafH8GAqTaK7oHtz8eKXhm2TZr2ZQaSredbSMsSxcFhqWylmP+ZR6mxbcEFGilTX00cpJm0HmvK9m6/a0PuQkMbCQUL2nWqMcwegtiy1XVLD5imF8IA4CBciIAdJoOh0PBy7/vfQSe0y3TimxTznnUNfFdX7ytU73pS7CKeWY+ysYHkADoTuoLVA08=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55eb8248-8e05-41d9-0da3-08def6f744af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 15:51:40.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVBsqylMPvMYOKGLNc00NMRJjKUo9mgByxaCD/T+feaZZeMXSIYpfDfSbWLmXLuVPoCnsqyuPpNGmHFE/SA3ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608100136
X-Proofpoint-ORIG-GUID: jFKGmWp8sGIhm7DA-IkXGVyFqjfjW_AR
X-Proofpoint-GUID: jFKGmWp8sGIhm7DA-IkXGVyFqjfjW_AR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEzNiBTYWx0ZWRfX66VrqZuJ18BV
 JNUYPV6BNdeKIcusDLYztuDZqTNg/gO1NHEWEtGDwb8h0GoJRoe5tl+e1PMoDTIjxsq9cAViTXJ
 H3ThkXKgxfPd6jWzpuDLY4CjunfDjupfI2zcsXIlwlYbsbSpwPdpfh1RmPs0ByOJsSA8P0Ec7Ib
 aMRJP48kAJ2WlNHpZ338MwgiVkUS0Ke1HHJpAuQGK7kAzDY7FNp2Op/T2m5P4N0fLyGPI+3jgyH
 V3+px79uuW7YsEtJvYrtWebZbkqNeTtSKUk4SXAEWniEdHhcZobTj+1KSx95BMsUPaMryDZhe6G
 EOGwaFk0A1Pihj879ZcTJLjgrMmb0JhPIdRYgycUhYpbPMwqpBTjzCVfdO+Vv9lxhkvdEYfsHfk
 ogzNulKmKHkOlgmSLeUcFTsLJq0t2MrFWY8qn5arm0J+LwaGoOgvLNJrjxR4YWU4jhdoM2hKr+e
 ay3BAbHKVdFQQNztDWg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEzNiBTYWx0ZWRfX2BYWC/p+Vsd/
 jcc5GNBgxmSwN+OImB+65BvQQ5la7nf7aFPTQuXrJzkjGnjyJdBIBv2jVh7dzqGrQCa2jZrZhQ1
 YnbvGYy1EEIiesa8ldiDhoPmpX7H3+cYwZUC3Cm90xiWN3+5PVXA
X-Authority-Analysis: v=2.4 cv=L/YtheT8 c=1 sm=1 tr=0 ts=6a79f394 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=i0EeH86SAAAA:8
 a=2KHyMQJGCrOS1kDPBhsA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22

On 24/06/2026 07:32, Xingui Yang wrote:
> Introduce sas_ex_to_dev() to return any device type attached to an
> expander phy. The new helper is then used by sas_ex_to_ata() to reduce
> code duplication.
> 
> Also add a defensive NULL check for ex_dev to guard against callers
> passing a NULL device.
> 

Why would someone want to lookup a device attached to an expander device 
which is NULL? If this is possible later, then mention it.

> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 19 ++++++++++++++-----
>   drivers/scsi/libsas/sas_internal.h |  1 +
>   2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f471ab464a78..fc6d8f3c9dca 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -345,13 +345,16 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
>   		 SAS_ADDR(phy->attached_sas_addr), type);
>   }
>   
> -/* check if we have an existing attached ata device on this expander phy */
> -struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
> +/* return the domain device attached to an expander phy */
> +struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id)
>   {

sas_ex_phy_to_dev() seems a better name, as sas_ex_to_dev() is quite 
vague. I know that it matches sas_ex_to_ata(), but it is not a good 
pattern to match.

> -	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
> -	struct domain_device *dev;
> +	struct ex_phy *ex_phy;
>   	struct sas_rphy *rphy;
>   
> +	if (!ex_dev)
> +		return NULL;
> +
> +	ex_phy = &ex_dev->ex_dev.ex_phy[phy_id];
>   	if (!ex_phy->port)
>   		return NULL;
>   
> @@ -359,7 +362,13 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
>   	if (!rphy)
>   		return NULL;
>   
> -	dev = sas_find_dev_by_rphy(rphy);
> +	return sas_find_dev_by_rphy(rphy);
> +}
> +
> +/* check if we have an existing attached ata device on this expander phy */
> +struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
> +{
> +	struct domain_device *dev = sas_ex_to_dev(ex_dev, phy_id);
>   
>   	if (dev && dev_is_sata(dev))
>   		return dev;
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 7dce0f587149..350a70484bde 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -91,6 +91,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy);
>   
>   void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
>   struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
> +struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int phy_id);
>   struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
>   int sas_ex_phy_discover(struct domain_device *dev, int single);
>   int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,

