Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8814915C3;
	Tue,  6 Aug 2024 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722957314; cv=fail; b=Xqmc7qjpTzdc+6E2MNw0nVLVsdpKATeUQZE5YBHrb5/MuxTKfMOduQzW5yE2hwBWhGT56WZc2Tax7ltTW9P+1N7IYWPgzFqSw2rP0Tuir8JGwBmfjMhTSnyWWDQhqvF+6CN3OSkiEWeBYJbxUQXoRdDSWaTz2SP5Km4/37j4rko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722957314; c=relaxed/simple;
	bh=ZTXh+VaV461AYNw6Xr/AR4qIySWT0k1l/4OPb3Iiqk0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C65JB+TZufd5KTzaO9MEA9P4ijYNo5+269UVwkKtBwEU6udIktkLCvO87ajaUNf+OBhdAezmFD6eEDIPfXpnGF6KXVu+QbYOHf1Bny+74YAqBitqDFvdGNXvrNOe/hlI576i1ZiGMxrPWSWN9Ri4VhtNeBiZTpfT97yBKS3OHRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D4yEpiMR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QracSulA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D4yEpiMR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QracSulA"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 476EVpkf020892;
	Tue, 6 Aug 2024 15:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=WXkEesyz6BfpUqkC7Me/PlmrUVWvIztL9vg2WuKGlqI=; b=
	D4yEpiMRWKpcjtr45f0JvuixvSpygZeDzx25gi6QHxxYHeF5UcK8ErEq1+g23qAI
	Keibs7u05OVAPPmRraniGxWp2HlxT7Ph33MJ1pZjTy5dLUAvRr840TpzV6tLBrFZ
	nq2q2Y4+yCNRrv6sItQbeKDXIeXNontu0MKeDqoCmQyWV38ltNipclYZTm2NM+1I
	1chlPyR1GzvCQG+OPs0KHS2DD8juFIRgZlrAl18pBrMeB8iFWtk7wg/udIwJ0A8o
	BUwg25aYn2Yp7eVlyIN7UH5CjJ4o3bpP4Byxb5efHQFdF5Uj1gdKHa6tQyz+UDPK
	NZ5A1nGnomhG5to7rOOohQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sc5tdjc6-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Aug 2024 15:14:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 476ErY7l004648;
	Tue, 6 Aug 2024 15:04:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb0eu46c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Aug 2024 15:04:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsYWf39GACk4mPRL3mK7C0DM3MQtGePpOYPUVDhchsUfyWsayqlYLDAURYjzfvvJzriKkaB49gK0W4JRGiVPeadSuJhgQM+h/kRvN54b503yr0JgPx8ftfwjurzTI4KSAsuG0eO2hQ03bBqVGqPYnitGM8PAk2yotHDBNLUf6rJQi3txgg2WHRz+9VTjD03bpr4sNQYnDbBeQl30/E5bfnjfYuHAkMa3ivaJzDjpaD07+zQmUYWUYfjWhapStgx4MdrSM5PwCp64uLrPgWxjg8gotN0UWPgb992qafXhlAgFvT4uD1QSlCxgqwQAftDADqQFTGtXrbQeEf+w4HFvkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXkEesyz6BfpUqkC7Me/PlmrUVWvIztL9vg2WuKGlqI=;
 b=fP6rYNCC+4PWvp+a+RDaADqjzGPITI22ZJX6PwTtNdzvcsZgxFPIRzFyhydi1ASMDb8B38mMdmYed04Y66bVgKJgokfwX5VqpoKYYHamEe0HVe9XCfafBySyatuxZF+e8Jwb7cVfutB96SJ0v7kbQoY3ImcrBoww4MkJt2rJDMGvaSHpbVJQk8jVSY0pg2dTkeVQohK07m3aUf67+3J8rYBJmBi6a8oCbIHSQqafYwSXbfDCFVArO9HwhnbMMEVg8wZouLies1sVZGh13gdpqV1ZeXbG8dtLpEwEN/BafkQKkTJd3DMAf+dMNJsYv4E6nhoWvXYQ4OYSrgXsPkcbkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXkEesyz6BfpUqkC7Me/PlmrUVWvIztL9vg2WuKGlqI=;
 b=QracSulANj+rvNAsXBJhaxs++OP3EfIYzVkvcqsROD2UKl9HfoYvCGsr6K5g18eBY6ync/4mcb5HbNZsZQ2N6PbZ5zr3MhYvWPj0uCTf8DQ0toINo2EqiIe3gxf0sSIs6dugQmMpdbLwkqF5O4kr3QyiiRQQGWlwAAhf+JjjDpE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH8PR10MB6409.namprd10.prod.outlook.com (2603:10b6:510:1c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Tue, 6 Aug
 2024 15:03:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 15:03:35 +0000
Message-ID: <9205eee9-533d-4817-a541-0f39896af487@oracle.com>
Date: Tue, 6 Aug 2024 16:03:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/15] scsi: pm8001: do not overwrite PCI queue mapping
To: Daniel Wagner <dwagner@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Sridhar Balaraman <sbalaraman@parallelwireless.com>,
        "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
        storagedev@microchip.com, linux-doc@vger.kernel.org
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-1-da0eecfeaf8b@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240806-isolcpus-io-queues-v3-1-da0eecfeaf8b@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0636.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH8PR10MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4b403b-b926-440d-8a83-08dcb628f1d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SG15M1BEdjV6eG5mcE1iTnZpN3BXMG5lSkx1K1B0c0RLdnBuV1Q1NmJkbHhn?=
 =?utf-8?B?R1ZTZGNqRDk3UklkbTNESk9mcXN0bDVYVG01eER3bmN2U0VsNHk3R3RYSjcr?=
 =?utf-8?B?TTdXa216SFAzeDdHdkRNdTFTbkFmQmRtbVlXaEhTUzJ6T2pyYjNUZlUwdTJF?=
 =?utf-8?B?Qk00S25QbUU0b3Jpek9uTmt6Mlc4VDFLbm43YlVUNzdoR3FnMnZTRmVYNjc5?=
 =?utf-8?B?dlhsaXh3M0VUYWtiUVhDK1B1Mk5ieHByRzRaNERFRWphQUE3UGhnUU5oakVw?=
 =?utf-8?B?S3duMFBkTHhMVkNCTVM2NUM0YVJBZkJwbXVJZXdlU1VWNkdhMmhlS1pLT2Nq?=
 =?utf-8?B?RXdSZVlTRTlwNmlMWExOWDhjQUdFN3ZVOUlvcTA5M0MvVHRpMDNOU1lXWkhL?=
 =?utf-8?B?UmVlNDhzSCtPZUNVTU9BVUNmU3l4UDlVZUhFdm83TnZFYkY2YndnaU4yMnVy?=
 =?utf-8?B?cHduekQ2UmJ0SFVvWlJCalkrWElqNm1SUlFUd3lZYlRrdWRhekFsYWthMTFT?=
 =?utf-8?B?NlhCZ0FZci9HTkJLNS9sR1M1aUYvdGIyVU1rblBPZ1ZWTEJpL3BwQkRwWGp3?=
 =?utf-8?B?TWRBblYwZ3E3SkpXMWFEN0FjWEZYUEZRNGxhUzRjYlZvRUZsT2ZxSy92UGNN?=
 =?utf-8?B?ZnY1UmhuUkpxZEFZclFMNzhISDNWMllhMHhmTFNCZGJNYThPb21hYjRGUkx1?=
 =?utf-8?B?dzcvbmRpZkJ1U3E5TXMyaG9ZK2tvUGFRbWhsQ2V1a3Z3bU1VSUp1MTB4bUpl?=
 =?utf-8?B?UWd2TXNzWXdVUWtCdFFUVHgyWjl2MkVhL01rUml2a1VBUFlTN2o5MGlKZmdt?=
 =?utf-8?B?VWVIWTlEa25YTTlzWElxSlVQR0x4SW9zSkprTjNOUmZETisvN3d5UG9sMmNj?=
 =?utf-8?B?ejBTaDJQTWNHR3hsN3VRVGlSbjFJcE1oNjI2OVcyUEs4UXVOcUh3Zkx2UnFO?=
 =?utf-8?B?b2ZUUG9hVENYMFMxUGdJQkV3UDVpRzZSaHQwcUM1cXFGb3huM1NvOWxrSjJ4?=
 =?utf-8?B?N2pzVytKTUEyRVhDSllVS01UNE56MVVUOGdBOVRWS29PWDRxaE5mdzRxbk1Y?=
 =?utf-8?B?OGlFWms1RDlGdFp4UDh3WjcwU2ZnZFpCU3RIdU80VE5qMjVoS2VTZmhYNmJs?=
 =?utf-8?B?SGN6dWNnNk9pM2U3cnpMNm5PWU5pc1l2dEE1T3Q0anV2eTMwOERTY2IzdWY1?=
 =?utf-8?B?SFVWMUJIWC81MkJMMVdMQ2pxK3FKdTBicmtFNG5ndS8vRDh1SlpxYXg4MW8r?=
 =?utf-8?B?S2NyZmh2MVoxVHVJSU5vM3RvcUhvZ3JYYlBERlRZekFoMkdOL3pNV1BXd1Vq?=
 =?utf-8?B?ZEdCSS9CN3p6eVRSVUt1ajJiUlVpTjFFa0FoRjhCVnlDU1ZZMDR0VUgrVk5C?=
 =?utf-8?B?aEh2dFY5aVd4WU9vc0NtcVYwdVBDM081c3R6dVZrQ0V5alNzK094RXhCOGlw?=
 =?utf-8?B?eFVGMW9EdXc5ckpETU51V0tjUW5oOFZFcFlSd3d1alVKaUkyMWRPNkJ5enVa?=
 =?utf-8?B?aFNhWVlNRlJselBsZHo0RG5nZVYrNzVVa2tQMUVOMFovUWVyVlJ0VDBQQ2xv?=
 =?utf-8?B?UWkyV09VQkpkV2ErZ1BOTjhvWFUyQ3Axby9JSmhQRlZnVE8vS3pmVjZKbHVZ?=
 =?utf-8?B?R2l6TTJWZWVTQ2hjeWN6dk1udC9Vai9ScE5DTDdtQVdZQkVmcDNMVUJ6eEhp?=
 =?utf-8?B?ZW9DeFg5aGIyZTFUZ1pXYUVjMXRFLzRwZGMwVHZ3U3F5N3dRNndPS3ExU2xn?=
 =?utf-8?B?YXFNUkVhMEx2NXFobXFsVU05azZEa21RR3NkTVJWSG81eTBDdUJvbUREbnVz?=
 =?utf-8?B?d0xJUGxEeldPVHhvKzZveWo1Si82MHdqY3EwMkdJWDEzZkhHdHl4VkdRaXdh?=
 =?utf-8?Q?wrW65d011zVrJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlFrRmlJclRWcnVLQ2xRbXJkYXVRenp4ZllGQ2I1K204UVpPSHhaaXBlVjFF?=
 =?utf-8?B?dGp3MURCY3E0Q3lvdzFIN09mVjdLQWhkOG9wNCtLRjVVL1lIeWkzV013eFpq?=
 =?utf-8?B?YUw4U0FlODhvWFhHVnp1ZkZUeWMxT0V6djd0M2JSSTBydzROenVkaHY1VGFL?=
 =?utf-8?B?U0lXVk5yY0VNcjUxM3cyZGhDWkFLb0c1ck1NeDFFZWNEeGJIQjEwMW1EQkhD?=
 =?utf-8?B?U0JkbFRpdUpLK2QrY1pRUUtkRDJpL05SL1Vqa3ZuVzRodjVmdDFrRVc3Q2RM?=
 =?utf-8?B?U0lwa3JSRzNybVo5eVNCQ2U5bGxNMUxEMGVYQlZ5MkxJamhsT0d6K2hVY3Uz?=
 =?utf-8?B?M0RZY2NwQlFLSUpMRUpyZzBON1JNWEJNS1BBY1QzZlhEZGZsQUhpZ3hKRnRO?=
 =?utf-8?B?aWRrMGNaZVhxbUM1NUQ3MVZ1QlhnQkxKN2d2dUVVS3l2d05WcDdrTzE3SVB3?=
 =?utf-8?B?eVN3NVhKVFJjUEdSTDlqUE05SVVvdGY4bW1HZmNQbGlyd3NHNTVYZXZzeGpE?=
 =?utf-8?B?SkoyaXAva29GNHcwaHEyUzIrNzN1eTkremN4N3k3MHpDcGxMU0ZkSU5SRGZL?=
 =?utf-8?B?WlBQZTN0Y0x6anA3enZxalVLcUtkL2NnQk5aMWI2a2JTRDZwaFYxUGUzUEFH?=
 =?utf-8?B?UGdjbitPdGIwdkpyK3Noenp2WjV2cWxENEVUa2RqL1VpcFZiVFowUVNiajho?=
 =?utf-8?B?Mkp0TVRqdWpCTEVvUjMzWWRGY3grRXg1aG14SitiMzBWMy9hdWdGUnhrcHRH?=
 =?utf-8?B?cnZUVUdlV00wbGpnM3NvTFNKV0VUQmdyVmdrbWVETHUzWHpzZy83ZXVBTzNL?=
 =?utf-8?B?dXFhRzlsOVJmS0JvNDliOXFzNnNqb21vTWdXa053d09ZZVZMb0ZSZHFkbDRi?=
 =?utf-8?B?Z012L1N2M1N6STFMNXFBZmpnNlZiaTVka0NPb0RqbWxsWkFvRCtGUGFydUdO?=
 =?utf-8?B?RnVwS1NFWnk0emF2TytMRWlyMVpiOENudzFzd1JJQUJBcnB1UjdBUWZyVXVY?=
 =?utf-8?B?ZjI2SjJGUDUzWWVyYnhHam0zNmFrcDdIeFl1akZ1a3E1SXN1MjUzUWJnY2xS?=
 =?utf-8?B?MTNXMVZZaUFxaFQ4LzZwZ2h6MmdUb2JKakVFdVdHWTN2Z21XWUN1RTFibEp2?=
 =?utf-8?B?TUlzMWxOMkR5bTRLOEU1b29tK1RCZHR4d3RHMTBOOTlwMFcxYnFCVFpNbkpw?=
 =?utf-8?B?QU4yWGlURVdEaGdzVnloU1ZNOS9oRW5vK0ZLWE9RT0NrODE0RFFsYzVtd09a?=
 =?utf-8?B?NlNVdkhBMTdlUWFMOGhNTnBRQWZ5alpOY1RpbTZXL2ZVd1pqN1BZRlo1U25H?=
 =?utf-8?B?eXZtWEVCYVQybUYxKzVNdkZkbnk5TE41elp2MklkOXN6azBnWkRkdDlzMnBh?=
 =?utf-8?B?dEFJQ3R5TlREcnB4TVBBd25RM0Y0R3BUbElWc3duMlRmVHB4L2J3NFhEcExH?=
 =?utf-8?B?MDh1dkRSYURLSUlJYTJDK3pLeUJMU2FQcHA0RkE3Nk9PeitPZ1VFVDBsdGNk?=
 =?utf-8?B?emJxS1RpV3hDN2owWW4wdE1OY0dyVk54YTdPRDR4bXZPYW0vMkpJcmhNaU9I?=
 =?utf-8?B?dXZpRGZWOUdsZ3RoQzhFMmcyZ0kxbFhYcHFwcWx1SzlTUkNWWHlJZld3SHJn?=
 =?utf-8?B?eEFUTmMwU1grSEJnQlZjNEEyOEt6clhTODhYcWJRUUIzYk0wdW5aTW85SWpn?=
 =?utf-8?B?ODJLNzQwMDhMTmY3SzRBS3p2VUltRUlmRnlSWFJkVktnODJkL1RwSXcvQUgw?=
 =?utf-8?B?ckVuME8xRmJ6bkNsS0xWL052SHNRczJHTXoycWluNk4yRjNrcGtGTHRpTnh0?=
 =?utf-8?B?Uk9idnF2VVhoa0FqN2VEb0xTY3I0b3dkd0RzK1djMXVZYTMvdWN1MXRZRlZG?=
 =?utf-8?B?T0hiNnMzaGVHUTBpcmNNTktIelZQM0JmT1JPem40ZTRTMWtHQW5ac29GUmlq?=
 =?utf-8?B?SVZQWEgrNDFSOHJsT1JtdVhFcUxYUTQwcmxIVDNSQmFpVnlrbTVDNTR3WVhq?=
 =?utf-8?B?K2Uvd0pjbnRUdWVIdU8rUUJiNmRoVjI5N20vaXUxZ21zUEgxSGwvRE5vOEtr?=
 =?utf-8?B?YVc5MnJiekNPRVBnUXl5VmdWZ09jVHh0ZlZPVlFwV3NWWFZudXBzRjdQRG9D?=
 =?utf-8?Q?8U27tp4qGfROuOa5iYPlYJYEn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K8cfTJKxHlmendPrP125ao7L0G6AHbgmhE3Zp8BDI/skGpluzg9FgZAdu0bpjAOBdCfuD1WmzWIwxen1JOYM4NRdWxZQA6BMTtLdyxyni85DrcuDBB69qAXFB+LgyMtnudlXCvkiWOFc2L27f74hVibPzhzrSeutyjslTYAXQIRp+aXeE08teLr4U9SnyERsd+dwILQM3XW/12U769hYAe9hC4ZUUinjrmWTmgyZHYfr1v+uWOaTEQkP6LrpyxGaroEpJ/ne+kOiP78lc+s6sT+Q+QxrggR7JGHZ5OOIlG1jwQ/WjUupfq3XF1LKYsenOtkWH9p9MQnrJou2LRB4nR3IFcMOIs0WSiJc/rryoSDLA5zX0lfgsDPAFF3//9yqsKXhJjgfsX6Q83vRZXPJJRW76+ePaQ0/EGGhzCt7FVFxGQaeRtC2DWNw5iZreKFKpGz6IU1T/eX7zVWMk/ZfVQC4Y54eJbRXDZnUptUVPg5voLk5lhFg1Cmf+3Tzcs0mNBlywoP1dysHsOPqsASnXogwmhmE+Ym/Zb1QsECzhybQzjTZiPAcGsKI6KPVmK7buOrEPNspGElxJzB54hLxz8ArUJv32ygdI03uUe8PddQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4b403b-b926-440d-8a83-08dcb628f1d6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 15:03:35.4124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unskj1rA3eb8/n8pgDsAnzcy18ezdixnDCPzYLakYy0MdgBHoStn3CYAh+dzUC15TljtG8tsteg/BF6aNMfcJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_12,2024-08-06_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408060105
X-Proofpoint-ORIG-GUID: h-5hLMrEtsxTw-5bIc6hGA94kdLZQrDD
X-Proofpoint-GUID: h-5hLMrEtsxTw-5bIc6hGA94kdLZQrDD

On 06/08/2024 13:06, Daniel Wagner wrote:
> blk_mq_pci_map_queues maps all queues but right after this, we
> overwrite these mappings by calling blk_mq_map_queues. Just use one
> helper but not both.
> 
> Fixes: 42f22fe36d51 ("scsi: pm8001: Expose hardware queues for pm80xx")
> Signed-off-by: Daniel Wagner<dwagner@suse.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
