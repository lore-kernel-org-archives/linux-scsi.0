Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864EC548E0;
	Thu, 12 Sep 2024 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726154553; cv=fail; b=ZRDOVRINX5kini/v5dz2cJQtRDzQLgeH//MJNoEBPUI9fMOh5u5xc0nXwjsNIsoonAMRJQGWJWTeYGdYWC07uyT8bBZ60F9Y5/Tmvi6rSlG97dWlo4W9jse7cRs+k6Zh6QLKdyi+r2XwQ9RAr444xBkiS+Ac19JeIkTzZcPy52w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726154553; c=relaxed/simple;
	bh=P0RKFfzf71PvLXwmnGIpn5/ENOnBjI5IP/qdV7NhcBI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dkf1SE5UEJa3ZRPyIPM03cKXk1YfEZ/gUaY7pyrNKNB10TuRJHD3A4tQQNte9DKKPcWsWm9tmG6SJFM6MNyLtv9Z7SREM8e02ucTbVH+wJ5/x/hjHJh2vyh/YZe+CPNHbcx0+s0KnoJns0YoNCRSPXX0LLwS6JWxpgyrG6ljw6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jY00VLbs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iORYhJKb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jY00VLbs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iORYhJKb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtWsa014141;
	Thu, 12 Sep 2024 15:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=L/u9PpKH0HgOfZU7UOgtGaSuxbQSso9VUERR/RbIoeM=; b=
	jY00VLbs6YW18lL8duyD6N/x7vYQVPqPYO6Ht+mZhJmzdNv2LOP9Whk+0iuGyUdU
	Ukr6/WupTFTCHwMa3mPWZPCKKwYHu9s4zzWZGwiE9fnCeCYlOmyFhbURG9EBzBom
	LpIXDj7VFv0TowFEfw6pXH771zlH1zqbrvrCcoRgrB6wueGSimC+puz6dWkKsiFs
	4EyaVhugunJNvfxfiNE/mZgq8sZPXVNOXiE09uLG0oEHenL+iCq4KICuqPqchd09
	1CzkGHUywdquAGpnFOLWyVVA28eMRmB1hFVBSO4V9Dwb7LdDPCT1nnemm0N6H1aF
	qUN6ZOyv2wzaU1E55Ly1CQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gevcu7x8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:22:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CE1Vi5040958;
	Thu, 12 Sep 2024 15:22:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9d26mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:22:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WidPFI3ogWBJaWP/cC1NpjUfqIpc1AFJA+KvnHj+xTnK2PIyIBa19KVrqbwI5q3pjZiSqV0Dv3Qb0foUmm4EmrCSIFsduj9g5DxsZlX1umHFsh0So65AAWUB5reWdMyDadQ+cnhdUn/gc6An54AxGRdsJaDamNChtF/AAmwXkpULjRTtzCy3bKy5epVhdLFe2pcM5r70mkmo0UI3QmmqtNeGsPiqNCesaMLdYa1jB38Et8iMBbgJfsOHRYx+xVyzJk956TZ7P1I+rlHNHhH4RaS2Qii277O3RqRJPWfejve5yJTNWw8ftap4WtHa23vVnYoyUDRXqG5WhCv60gULyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/u9PpKH0HgOfZU7UOgtGaSuxbQSso9VUERR/RbIoeM=;
 b=WT2f8kwKsUowPZLC0IMf+K3FCJg21PwySuaIkqypCpPUlB6T6X9YSC/OnS9GwgKBg+oYnVZmrTdxhhIu8a0z2P1qKxws6zhXBaWEPA37PemI9ewJk5NozNBLOJ+hfdUJ6M6cdfPZRm9w4uSwzdrPg7wpQefqkauX5oHjcXez91r8yK3f9qlcQ7bdN4C3FjOk+mEVrxiwU52CHiCfDOhJpQ1+aTTEHZkQJz0sLwb8+9XyYRPzPfo+YQDeQ9lGBCsQQHhQMHe8gXP5CPRbrZcGG7AprYiFqYMkIpOVe+FOIKufxi0eDUX3ujVWurl2FKkiKpv2lOTl2B9HzmBIoLAuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/u9PpKH0HgOfZU7UOgtGaSuxbQSso9VUERR/RbIoeM=;
 b=iORYhJKbXfquKjkL7v1Q/UQ4QPAUU8KYDydWUZGlinBP2DU1fv98DmWOKJ5EUmQLTCKRnI/wMrqmCKTfiOkX3/w7yGLFB2/DjkVW901/KPAXogVUjocx7n9zYsYgxs4O+kYjHA5qw2VTTY5ohOW660N88IODxJ+DDfg0Wy/rEWM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7225.namprd10.prod.outlook.com (2603:10b6:8:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Thu, 12 Sep
 2024 15:22:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.008; Thu, 12 Sep 2024
 15:22:09 +0000
Message-ID: <4a015015-ae7f-4eb5-ad00-420db5961d96@oracle.com>
Date: Thu, 12 Sep 2024 16:22:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/4] block: Make bdev_can_atomic_write() robust
 against mis-aligned bdev size
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-2-john.g.garry@oracle.com>
 <20240912131506.GA29641@lst.de>
 <0f2652ce-63e1-4399-8414-0bd150521e1b@oracle.com>
 <20240912150736.GA5534@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240912150736.GA5534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7225:EE_
X-MS-Office365-Filtering-Correlation-Id: aefa00ac-5254-4ac5-d744-08dcd33eab06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3pvR2hhL1JnYlRleHRSK0JTbzN4WHFlUllZMFNWeGtJNDZtUUhzVzZuVDRo?=
 =?utf-8?B?UU8rZkxiWkVpVnR3Ymk0QzVISFluNTFQemF4Q0Vvbk5LL0FxRHhCT0J5R05l?=
 =?utf-8?B?cVdicTArY1RtK1R2OUVRdDRieENkaHM5TGRVSENkblFUNkUwNVl0UWlET3FJ?=
 =?utf-8?B?TGhmN3V4dmR1RTFWU1l5aSsySUlsNDg0WTMvUkpsSVRiK0htN2pGbFFxU3g1?=
 =?utf-8?B?aVllZFhWQjdheW93YXRkclcwTFJDUGZmTExuYk00azh3ZFh2eSt4M2FUL3g1?=
 =?utf-8?B?ckp0Q2Z5cEF2dk5Jc2VaLzdKYlRjcTZqRGNrSGZoc21QWEprdys4eHpGZkxq?=
 =?utf-8?B?NG9LdmR5T1NDemRUbUFXUjAzMk1WZmpjekNDUWtNMFpFS3BQN21qWUZwM0hm?=
 =?utf-8?B?VlBTRjdWbnJqa2I0TnBYdjdYMHVQYzM1OWEyOU1GZkhqclgzQ0Jabld2YmVq?=
 =?utf-8?B?d09FRXZjQU5WOU1vWWZ5cWhuam45elduNUwvdHJQbEp6a1VVbzBJYXM2LzM5?=
 =?utf-8?B?MkV0N3hvYkN6UWRncTU2R2FXTEh3YTZkbVV1MmFvNlZyUkhURXFJSEthUUlk?=
 =?utf-8?B?ZCtWQUdoMytkaHpxT0hEOEF0bmFod0pMWTUyU1dpajNQNyt3ZmNlMlk0WkRY?=
 =?utf-8?B?amY3akdocDVOckdmMDRGTzloZ0VVL1VBaVdZTloxNTB2UTV3Z01uTy9mK1NT?=
 =?utf-8?B?V2x1VjlCZnQ1bkRDWENscUJMS00vcGJlSUpsQzdadmQvRnZ6MFY5alE1UzZF?=
 =?utf-8?B?dWxnSENJK0RrZ0l0T3hJb1MwYnYvL2hYQTVFQmp1RUE2bldUY2E1L2xScWw0?=
 =?utf-8?B?NFZNSzgybGRQLzMxaFVDYVE0eHgwOHBuTG1leDFaMmtwRnpDT1g5WlYreTd4?=
 =?utf-8?B?bFNXNHo5eEVHVWxZV0tqNTNiVjBPaUlPTXE1aXJwUGwrZ1ZRcDYrc3pVOC85?=
 =?utf-8?B?SElBaVBrS3JoTytzbFYrRHlBbzhBemFXMWg5V3k4RC9lc2xIZ0RpeXViTzBp?=
 =?utf-8?B?a1VVd2s4S2tOYUxzVnAxNzVMMlhySDZNcDRWQlpka0RicHI1K1NmQnFkcnNS?=
 =?utf-8?B?NU5jNkppTHZSVTBIRXdPTTNhQTVzWFBDRlRJZjN0K0pSMDRzYzZJN1g0QWdk?=
 =?utf-8?B?NXpGajBvcDVGWHI2anovbFBiT1RCdjNET2N1azVWay9zbW5LQ1dvcXFmWWkz?=
 =?utf-8?B?cHpBRkN1OE9kNDVVQmFNUTErK1Rkd2p1UEhLcHRCS04vdUY4ejRjUkFqTHVt?=
 =?utf-8?B?S0w4OEhqbUlxWjMxNkJKSzFWUjFOUEhNNk5oUjNkRFFLVHJld3N1MmhVcFlN?=
 =?utf-8?B?UEFqeWhRdklUQldFMkZRY3FuNlNVY1RmWlBicXh3TEpqTXBJS2lCeDl4dzFK?=
 =?utf-8?B?bXRSNUk5MlRnN3cxb3pab0ZyTjBmRkpSTjFRQXAzMUxkUVJ3V2hxUWxMUWZ1?=
 =?utf-8?B?aHJ3WFZ3RzlKQnkzVnhwRlJkN1gyREJSWmltdkVadVBTeGNKZmNKTTFwRktX?=
 =?utf-8?B?bXAzYmJrRW9uNkl4MEtiOStqTENYK3ZjVi9DTXMvV01PcVI5cFpnRjhIMmVM?=
 =?utf-8?B?UjZBREsybi9wdFM5Ly8zTHh4UFRUOE1Nd1FqeW8yY1RyRGZRck0vdnYvVzNW?=
 =?utf-8?B?TlRvTFpNekpHWDZPeFgyZWozc0N4SVBGYWVYa1p1UFI0OFVNdjlLY1Q4eFF5?=
 =?utf-8?B?ckhwcmgrbGcxTTl6eUhFcC8zMFFXY2EvWGdyUE1aYkk0UlFuVGdzRzVPNmJO?=
 =?utf-8?B?VEY1UFpvdzJyNzhvVlMvekxlUjNZOEgyNkFFS05JcGtKQXkrNkYyNW5mekhK?=
 =?utf-8?B?aVVRS1NvVVp3YTU1eE1JUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eklkdVh0ZVN5SlhkT01nbWNBa2RVVlVzaGkvL0oyTkYyNENTbm9qME5OS1NZ?=
 =?utf-8?B?WnlwNlRlZEtUZVdzbWNFaXhaa0taSUxMeVl2UUJ6OXBic3ZneS9ZdXhmeGh3?=
 =?utf-8?B?ZWFKNEdmRG91V3lqWS9pVjFNK01OZkdrKzlkT0ZBcEVIaVY1U0R4UFdZNGtM?=
 =?utf-8?B?MFFKbFRBdGRyS2ZsemZuY1lVY1JkalRsaU9PMXJQZlF2bzl5VEZSZEZWM1FH?=
 =?utf-8?B?em5xODhvZzkraDlsb0ZXdlY3bG1VNCtBRGJhaW5IRTg3YVJkMUtLSUFybllR?=
 =?utf-8?B?RU9tL2tDRHFGK1cvcmpadFh5SFk0aW5valIvUkMrQUdOcm5mbkJSSVFVN2J5?=
 =?utf-8?B?TkFzVXRMMGtlTEdxZjcrc1p2SWVhLzJkT2RhaytkaTVEVndQYlp3Y1hWbzZL?=
 =?utf-8?B?dHFPRXV1c2pjS2JxUlMrT04xYnVhdEtWZWJKQi9HMVNuSW5vZlQvUjRzZXhF?=
 =?utf-8?B?UHhCa0RZeExYcklCQkptSW1HRjdTbkNlOVVHYngwWno1dExOUG5WeDBhWXNs?=
 =?utf-8?B?dUMrOXdVTStxNWl0QVFEVDRnVmRMVzJQcWRVZVdnK2ZVeHBTY3gwSkl5THYy?=
 =?utf-8?B?NWo4TDd6dEwyaWdkRzRNZ1pmcWxjOUcwWEVuSlNrak8zQTVPd0NPUUdzdEIr?=
 =?utf-8?B?V1RzTG10RWtabnJLTHpBVUR5N2dIRzdCRldhNHFacU92MTZlL3RlaVAwc2NM?=
 =?utf-8?B?YlZMNVIxWU5STXJ1RzRmb21FL1pLeWFsTTdGWGNTajNaU2ZiVzAwVlMycFRU?=
 =?utf-8?B?cGI0bzJ1OHozMlQzK1Azb3FkNG1NdGtiNGVHY1lZUG5ualA5cXppRXRRY0p1?=
 =?utf-8?B?d3BqcHVwRVpoNGtJNHZGYU5oSzNHYW9aOEd5U1ZqSFNIRlpDL3A3MnE2NUc0?=
 =?utf-8?B?cVl1OEJLTExrZGZVWjJTcjl1eU53ZXJGRVlRMlVsZWdFNHBjaUx0c3ZZNXVN?=
 =?utf-8?B?ejRQVDRMNXFNWFFKRDczMHJtTW9NN3V3Z2g2YmxCeXRLRmcwbFV1UWsxQmU1?=
 =?utf-8?B?TlE1TVVLQzFMR3hFcWQzbFVlV0ZncEkrY0Z3SXVvT2NoU0M1RWI2T1dVZVEz?=
 =?utf-8?B?N1p3MkdGRUcwUC9obTdhZStCSWRTTzZ2b3FxUExQTnJac0JVOFFSQ3ErUFNU?=
 =?utf-8?B?UFB5ZW5SRUpreVZPbEZ6ekFOdXRWWE9mc2ZBWmpDbDNaVHRudm5pQ2FDMGhx?=
 =?utf-8?B?dk1HMjNBTHpDVmIvOHQxRmRWenRPaXlsSlI1S0NlclpvVFMvSWlocUlkMGNR?=
 =?utf-8?B?TUsrQWpnZStYbDVyeTJ0R1gzZTkxQVZjb255MlR1VEMwWEVqbDJCYUZtemY0?=
 =?utf-8?B?SVUzSW9peHFPVmMxSGxnUmhSNXQ2dVZQS24rWVZ3RC9VdTU3SlE0WS9uT014?=
 =?utf-8?B?SVllVXh4VUVJdC9CbHExbDJWTFNqYzArdVdCS1NlaWtTcFVzWnNOUWdPaGgz?=
 =?utf-8?B?d0cyVlMxbFZBTVY1SExvSUxCU0JPYjBtOUtOL09ZK0p5MldmRVl2dUFnc1ow?=
 =?utf-8?B?WDZubmlVVG95eFNQWUpUQ0orZWhJTEVaWHBmZUtYME82KzlMaUlWYWZLTjZr?=
 =?utf-8?B?QVI1NXFiTFBMekVhWTFUczJ1a05PckZXK01NbE4xWEFaUkc1MlhxQ1g5Z0N5?=
 =?utf-8?B?eHEvdkc0aEFUQldTVUVRN0lNTVQwVFRNbnhoTGZNc2tpT1RMNGthUFVJVWRI?=
 =?utf-8?B?K254V0tXL01RazZvTmFUQ29kZDNveWNEczZpRmt4Y2JpVTV0YVgycXNzZHk5?=
 =?utf-8?B?OHdhaVFjVDJiQldMUE9GZS95eEhqSGxtTkE5SGJXKzVNRjFiOGFXUGJGald3?=
 =?utf-8?B?ak9sbEFtbXNTTHdNd3ZiZ1FYT2daRStoYnVlQlV4bzJadDFhUTVsZDZjUXE4?=
 =?utf-8?B?MDNNQVBhWGVmU0tHTXZIdUdJWHNwUFVJdmM0Y0hIWEU0VXhpMHFMdTRnbzJa?=
 =?utf-8?B?YlVac01KMU5TUGM5N2NoanVKYXJpeVFwRlBkaCs0bGNNcnd1bG55ZjZNa3px?=
 =?utf-8?B?U0I2amRQN1NyWEpEMTZTWk93ZzdEa1BHRlJRYTlSa0JxZ0NYNTY2MVAyL0NI?=
 =?utf-8?B?VWwveFloOTc4UDF1cDE1WWQyTlIwT0E3SXRvWmtSWXU1M3BXY0RIdTJSUlBY?=
 =?utf-8?Q?j8Vu2Ae1gNwslD+FroSHczQzj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sFUD5ia+Mmd0Ml8Y63Dv5YGTKcLvPgr+MfwGnVBchgNYKhXGZaa9XW2PpK0ONgz7ekOxYE+333ECI2I8Cn0TbwI7NGBuhsaYh/GysLGqrq3nBdEVQE78GGe3x16oBaWM82lRmbgO5iveqM4nd49eixkHBvpGqs6VbttGJ/kiOeXXzuawEE5ftdcGk/pyVo1j+v//ew10cnaC9zBpEhBk/5VEuyajt72L+Hp9D3n9zv9q+KsH3GT17gAV4OmtvhToN7OQg0sJ3S01kRT6MWsBskhdEaZEdGI/hNMctrwH1+5HTTkZaP+NOcYoru6Sg44h4owxfWPRhw0zPzWox7fXSVAkSmd6zuM+VbP32eOl/LNLw7nzKcc3n58aMNsRRPpA6Zy5OSwHYpRKfcQ/BnIqitswjBaWHGxdySVQ0yLtzDm1HDMGY5ZDwW9Ih90gCytkWtEJ+NHzR40pgzmJkgqtRnAAvwzhc4JgTD33cFM75ckTUNftOkuLYD7VBwKxROqeiyJsuEOjtkRqAEAHYq8AhdYq9jP2HU0Job5yGfq2ZSh/cEc8CAlOlBUE7yrbcWB9S7X0JDXXz3zGjjELYjLLasD1jzX1g1mzrZqsGpCiCTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aefa00ac-5254-4ac5-d744-08dcd33eab06
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 15:22:09.2575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: flmpOyTGeXOypyPYFV9TJebm77/7fWeuxqzE3TrPZCLcsIL/C7wQ2j+nLnge8I4IIypDoUcE29tocA7MCrEkbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120112
X-Proofpoint-ORIG-GUID: lq6OHqmnpS_vGuP6Rf-sdyHBrxJ6DnXB
X-Proofpoint-GUID: lq6OHqmnpS_vGuP6Rf-sdyHBrxJ6DnXB

On 12/09/2024 16:07, Christoph Hellwig wrote:
>> We should do be able to, but with this patch we cannot. However, a
>> misaligned partition would be very much unexpected.
> Yes, misaligned partitions is very unexpected, but with large and
> potentially unlimited atomic boundaries I would not expect the size
> to always be aligned.  But then again at least in NVMe atomic writes
> don't need to match the max size anyway, so I'm not entirely sure
> what the problem actually is.

Actually it's not an alignment issue, but a size issue.

Consider a 3.5MB partition and atomic write max is 1MB. If we tried to 
atomic write 1MB at offset 3MB, then it would be truncated to a 0.5MB write.

So maybe it is an application bug.

> 
>> I could also just reject any truncation on the atomic write in fops. Maybe
>> that is better.

