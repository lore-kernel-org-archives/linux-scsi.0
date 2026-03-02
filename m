Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D63337BBD;
	Mon,  2 Mar 2026 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772451248; cv=fail; b=U8fwTD/HXyVqh5mHIistGgcUJ/CANHdqQKzGHbjePFA4bNAVoZlG4Xox8qgut5xCkJLRb55ix1XnOXQk1LNhfzJZr1wUdBc1E7dnyBXrRLuPA+N/JbC50mjJHXVVIkaBB7LxJ7AwrYzKfqbalwdFlsANA9AtHcSCyNcs7CAKOVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772451248; c=relaxed/simple;
	bh=Njj3NZGsSrtU8gGqKhHtoHDfgyi4h3y999toi4NF7jM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aVBsuf0OC0/0RddGxdxXTcyPCvXXY3BCL7iQyML13ZhoFHB+anXIyQxvjc0b0myCXE0O1NeWOcJ/+cI7xRt1V51FM+akXhHvFKRxmoIkI3ZpCCmkOW4pTVa/kfAopmjwyz6X6X/MpaPJRFLuMVy6JDO42PA7/yQL2P/IFzP96cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QbJlOskc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Znc5JsjW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QbJlOskc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Znc5JsjW"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622AGYJ3894909;
	Mon, 2 Mar 2026 11:33:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Njj3NZGsSrtU8gGqKhHtoHDfgyi4h3y999toi4NF7jM=; b=
	QbJlOskcjBHAMAH/tjFN9ZmgKEhUPJokIUzb2RaOq3FS5kR+R/hqHMyDHJcUOpqj
	613QHivOuRXugsOXpqKpuELTUOofgBCYm6bR2jgCa8rgnCNTRofpcukVGLc4cQ1I
	Bl9v4IaPD7RvNKzqcXB1DiOMI7rhIeBHeD99BKJjh5hVkmiDGNZ24OM4rKb//WK8
	Mr43qQMSTiVdlWSbItxZlPcr2aSLjDjeK+RqaS5hwhN49D5fpxMqeXlG/WQzOh8N
	7i2gcj2pUHmbPNVkgbAJRhvMsmlcXDkrIycUqlgQuKVQqx0/0XqkgMSeaO1djr8Y
	aQ33rPP61hBx6HhlTxo6UQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn8ncr3ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:33:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622BC4Ya036919;
	Mon, 2 Mar 2026 11:33:37 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8j5b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:33:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bz0CEd3WEX/NSSTSx6rw6bsFKIWPGX9H6oUEpgfHoQHE56n9zbBegROxtV8kSht2PvBWsXim0Ym6Uv3BhmjUk3inpPQX0shJo+xWiBLNvtL5vadFte60S6emZSPUfZ9TQQZQ3RqM9Y+LxrmpvxUukaQXzqSUTZmZuCkEj6Am4IIvsAEP/LC2GnRQw+0raV7bPL68lZhBz6Xup7wGKpD2pHmxX2VOMKF9ObMaK1gHTQzBsia3HI6nRYAykGeYjEDlllfDtRSYWUOtf6NYP9P7YmfXnD2ttnwwNCZM20+/vXw7Xw+QvTQ63ArV6+95Pnn2GkyrH4Rf9dZQ2JPenFCruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Njj3NZGsSrtU8gGqKhHtoHDfgyi4h3y999toi4NF7jM=;
 b=ML7dXZwSB6Z0s72md+1dEUIhlu7J85qomTPOVI2Gim0II+gOzDaNKe0cawzLZW5hV4O2t4GOxGa4iYDpRSDEJkqZu9h9vT72CRbovClw5XscQBbgtjE/fMr64UYza4hx3a7XzNidO/qPLXLPzJzLH46lrBxg6S4tXL/v30AmpSyeAl6AkpjRtsC1ncYY0MQe+U61yW6X4p7ys2ARIpbifazUj9LRSxNQ8ckatnvprq6R1zeZU/0u9wAAbYrE6rvR+882Y1gWYR6DylgRraeMznfSSSjsQTxJt932jnoa0z9anpA7PWybaLgWY9fjutVXP5y6znWulDJbgzFmov2Kbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Njj3NZGsSrtU8gGqKhHtoHDfgyi4h3y999toi4NF7jM=;
 b=Znc5JsjWTfBZlPuhz0C7OSSMnXFC189JwKgf/CSqV0xz1V5bx2FbFL7T6/gjylQw0G2MV5yzDC1N2ETGqd3BUdXjVSR3DnGboFZ3urMrXMAjcS5xYjd4KfutoTs28p7ugo8Dte2x131h4+ZNU629oeoRNHOC1w9yU5REPE7puDA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB5767.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Mon, 2 Mar
 2026 11:33:29 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 11:33:29 +0000
Message-ID: <04ee5663-6210-404a-91b9-8d4a16400faf@oracle.com>
Date: Mon, 2 Mar 2026 11:33:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
 <aaTzBNPE7lDEyxd1@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaTzBNPE7lDEyxd1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0014.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB5767:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fef877f-eb2e-4000-3be0-08de784f86fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	hw3HgYMmSl0EjQwcvygBCmNVv0YzspQHQEzQ3F4Oq0ESK7ol8boDNqyGV18oSV1WRTbfiYLZeZnP5Z+sSj/4vNDF+UFRhrL9daGOmZedHT3rTP6+NtdESNZ+HBGjGTTGX+s+Hff3OWVx6RR4JSFEX/F+++XU+9UpMeeVQKIFvE1Ld/VbooGRKw7uMrlS0ST1Gr1xeFsyNp48dXt7kpDGSXkCKCVTeC+rX2Ticmjlr/paXQetU33F/APIortHjcbUBJzGoz0euCARR139Zif4pH9CzjOG/J4o4ijtpxq+X3bEUdpdqbKxoCIazS4x4tIcAS00Sna+b0GqrlgTDMirpsIbQ0cBO1jK8ZT8ZSsiE3orJFY/8mw/i7UlTdjctHOQqUoFqtzG7RZMgENRZSZO9o62I0Pe/X663VFpykPam0804VFEi6OwIW4pnyqdEvhwv481H6RlWPNp6GHgy0EZk3P3aZHYIhhcCwp1XRt2BOe+Kv6qdB9TKy/CeI58PxdORXgtYeXxVrMFddjFrHgxmhgZ/zk8EkhDUa+mS3QtfGQFiuhPv7apVsX0eflbBYzlLgCIVIghgxYUFOpD1cIvYEuoe0mdZ78e3kxXLIhgNGdXNavsU8QA/RZ+A2ePMuQNuytEDBXsrhH39okLlAG7W78lUs1giucpjdfFznWIISTzygeCrwZDVIufp3stGWbYDNMlQgM76em76Cw4Xbc1VHD4emYrfbJt2/Q/KNeHsAc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjBweUM5UFZ6ZE8yZVcvRGtjVEdRSUhNQndqbENJVVlzYXlpeGxUN1Rma3h0?=
 =?utf-8?B?YTV5d1RnaHF6dTZLajYwQlpvYTg1WE9MK3JzVXphWnRRcS94QjFQeFVSRVp0?=
 =?utf-8?B?VlhVRzNndUNZMFFjUy9DZDZvbWxCbW5Ma0h4cEZiMkU4amQ4d1BQUzU5amo0?=
 =?utf-8?B?ZXhIamk0M1FtbU1iaTE4RkxkbzBOUUJJOEQ4Q0dacGtwcVNabGlHb2ZzVFFo?=
 =?utf-8?B?a3F3RTVzNWYrM0pGUWdpTS92N0QrRlNsVGdYVml1MXBIQTdZM2VYdVd3bkVL?=
 =?utf-8?B?L3FmeDRadm5CYzhjMURjRytKK201SW9BMngvTDh4cWRSWEN4cHhOQlBtRUpE?=
 =?utf-8?B?T3k4aU1LT1dJeWk3UjhHeTNNcDRaaGNwbE1neXN1R1oxMEh3SzhBR3JtRGdv?=
 =?utf-8?B?TmR4cit1WGhkaEhkZE1naFEyQnVOVXpLYzNEMGcxUlpkdEc5cTQ1cVFGU1hH?=
 =?utf-8?B?SEZEWldTVVhDdE9DQUNSRnlVSmduRkwvUEVxMWorSDlmK0RTVjRtdUFUWVE5?=
 =?utf-8?B?b0FOOWprdFZUYzFtQU5uQTJLUHBPSjJ1ZXpKenh5QWRrM2Zwd3NhamdhWjJF?=
 =?utf-8?B?QW1jbnpzOEtjbXFRbGh5T1kzc0hKQTJBYmgzc3E5WVk1OHB1eGU1Qlg0T2c0?=
 =?utf-8?B?NDZxTXVqbmljUXMrTldxOFp2TTN4RnJJTVBqM0xCaUJkWkJvNXBuVmVIZWRm?=
 =?utf-8?B?cktHZXZtbjZXbHB2OHJRVzZDVSs4ZWFHZE9RVWFLVEJGN3owRHcvM2Jvckkv?=
 =?utf-8?B?TUpzV0E1TTFBM25KSzlud1ptNXp1ZHNLOUNoV05PYkZyQXA0YjlHVThhb2oz?=
 =?utf-8?B?YUwybkhwV2ZTRUtuTDBhZHdIR2xWTk9lUFpHSE5IVjRNOWlVc1Q5bDROZCtW?=
 =?utf-8?B?SnhoU1ZheVgvYjdwNlhPR08vZXdaMWhXV0dEVU0rWUFTY1ViaWpUbGcyV3h3?=
 =?utf-8?B?VTk2bWdRWFZFNkpUZXRlbW5QbVZVcit2WHJvemUxV3F0SmRXNHJVMlhyZjEx?=
 =?utf-8?B?YmxwK1k1ckJoWlpWOGhMK0FZVzA1Rmk0b3B3Y0F0Zkc2N0xUb2hUa2VDSWZ3?=
 =?utf-8?B?MHQ0cU01Y2ZjNDc1USt6TDhka1NVSHJzSFl5U292N0RZbHVYZkM2NWtEbUxJ?=
 =?utf-8?B?YTBsRWorc2YvTndnR0ZZNzNKejRFaSs3disvcjFoSHptNDFDQi9SYTNxQ1pW?=
 =?utf-8?B?V1lkRWJHNTdFZGo1Mnp6Skc1QjNZQUJCSVVVSFRueXUxUVJxa092V09XVmls?=
 =?utf-8?B?R1JWNDc2QzVGZStNOTVqaWNYRXJybnFsYklOZkd1MFNMb3lmdkd3QjNiT2pz?=
 =?utf-8?B?ZkdlK3c2QlA0NkxGNVJScjY3bzR4cjFvdldwcnUyeUZvY2t1YnNRTnA5WHNv?=
 =?utf-8?B?cnpFVjFFaUVyTnJHdHBOa0JJazBlSE1ZcS84dUlVQXFHeklxL0NmMGNPTGV6?=
 =?utf-8?B?aFN1Q1hGVmhkNjJXdERUVkV3MVVvZ0lDUzVLclFyWkJYWVRFY1Z2eUx5enJL?=
 =?utf-8?B?RjlHVW1LQkdONEVQSzJzeXBOaC9LWHFRNlVERTJXakVVMVMyWTRZRU9FdFZX?=
 =?utf-8?B?K2x1Qzg2dzNRajAvUjhRZHFIQ2hrV3RseTFqQmFvRnVvWlJnWnY4WkNldVds?=
 =?utf-8?B?cWdlRXFHM3lLcHpEN2VQWStUVERWQURkNnc1ZzQ0dENFSUZCZUt6NG1GTzNN?=
 =?utf-8?B?dXE1bnlnUmVrMXNwTnJHV1lOYlQxemFtYjR0YkdGUDE5UTVOa2pncllkZGJJ?=
 =?utf-8?B?a2VtRE16OWY1R0xvOUFpQ0lTODVubVpWZXNYeU5XbjBQcGZZeUJqY044Ylhr?=
 =?utf-8?B?dkdXeXhXMk5KWE1KeVpBQlU3V0UxL3RTTk02Ulp0ZWtvenNFMzYrTmEwaGlj?=
 =?utf-8?B?U05qWHE5MFpTNEZpbmhmRll3VlZ2aUsyUjA5TGlYYm8xall0R2FXK3liNzNj?=
 =?utf-8?B?cCs0bFFmQ2JSM0d2ME11QjhQQUx4SnhnVVpvQlBJZUJhSHJOSFZpdTBXWThO?=
 =?utf-8?B?VkxPWitTb3N3UndNSE9ZWXl1VnphcXhhV21RZzBnZzBrR25FV0cwY240WEtH?=
 =?utf-8?B?ZFdLdW55TERsVTg0eHk2WkREVVpLanc4ck1SZmxCQWh1SFAwT1RzYkhwUjhR?=
 =?utf-8?B?WHJIR0RCMUFERk1DekswdUdqS01JUUpPOUdxNEJPbDZEWnZTb05FRGJxTzg2?=
 =?utf-8?B?VFhxM3NWd2FqbzErbFBSbTBObjZBSE82OHVBdEhaV2VHbzhEcGVjc004MllU?=
 =?utf-8?B?RDFTck4xeDkrUVpNd29waHBldFdzWFVvZmRXcGk2d1dvYllKZ0xYMUdWMDRL?=
 =?utf-8?B?SW40UzkrOHhRNkxIZ2VBeEcxNUl1ajZqSHBNcVR3VUdMTXJiR1pKQT09?=
X-Exchange-RoutingPolicyChecked:
	T+e50iqqM8GYr0OyLLl95Y6H2UF+ro8NcaTioSS+GMkYv3rh4ZqLsTEa8Cw+BAZMLkbbHnGZ2D1kyZILB1RDwGGSDU43FV9VrroCSy3EjbSmYDcAXXrrl5EGpwJY3HitGnPhKf2kFD4GxQhOgiCCsKFKm0oPoDVk0Iy4IusAYl20GTNnPMUEGG4g1S/6TpxFcTFuUz+Kop4LQlDlwErhDBVJH6YCoZ9X5D97DM1cuilKMXlpGwKc7qPFIH8DcY4M6gCmUku3nDgyq5gKxxp1v4ugJu5MncKck8YTfmVpfgPqsuBSsX3FanDRWR7boA4wOl/uAblpz8eaVrZ3rd548g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fsaYfDmK3VhD6gm1hT68HC32Ri+AsgyObrsrIaUlScxWy2DxEhf+VLhF5F7/QeFU5qcO+DdwL5ShuDOW5PL/DhcZzw/W47HgmdkzIW//ADQPIdvzYb7fJn9yaadMpO733R9meosOl7MYZViJWhhKtug6zo7oozxtTwWO5qEMfmJpmLA+SzTiJSXXfpes/PiHfbH5d2gtU7i/dls0A264yn8xkv2xumgdguH0pTQvosy92mS2aus5SoQvEHnVcHML7qi7oqKSGuTUK41o7DOKjW8Jzeai6BJRAy5WFSRJXOzFxvve9JTikp3iAErca0QtCjeSIqUPHV/UvAay8fhsFyjZ++ayAtZXIyd68ajyb0ezZ/cm7HCxVpixpFakVxjwaPwQcj4oOruhd+0q+FTN4sFqo7mRYXfg+RdedZowb4FE6lS21o1+vTS+NUfT4yoR9K7oFQVypnsoOTSyh73kg6aWGMJiSNrSbfjeXsfvxA6n7kDPTQcb67IPyiwWpshhldxk8VTXV1GRgOS/5ckBF4LW4bD8Y+3K0nH9Nzci70bZ7wprStZUVdk4Nb8zDI1Y0Q8mHNdSukHauOf/uocJ4Qakmou/fqaXUAaICTBuPNM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fef877f-eb2e-4000-3be0-08de784f86fc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:33:29.7804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICMWeUAZkf7nfdbF5Nzdl0Nb4NbgKmt+Qyq2yMMl5oXR7fRyCTLooVphkPY/DA6mTu6rr97keF9+B/j/BqDaiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5767
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020096
X-Proofpoint-ORIG-GUID: 7exFwuDDmiCFWXZGQxmfVfposMrQ32Wr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5NSBTYWx0ZWRfXzUswyHCRC3SC
 BhmGzHqOx4tMrynjHeC0sw+5FPyRs4QfsU2EqOj8OA5Mz0e/2h44lYZv2pqWEc8Rk0p1eS4uBt7
 U6autv6alX2wY0/d9k+Xu6hQW8pvUMcAB9KTQ0ybBqyG2FY2HpywBb7jjVEEeju9JuslkSiCUqP
 5yVPxtKWNrTY8pOEgb5nBM8qO0zfRxXy6r2BGBX/qQtYwOJpPuv3aKaWQ3Vo6ofgr5lwXnyYMG9
 A1JfJTD1q3NRc7N3CnFNX8IpGlRU0t8gQWJy9fCZHyYzOZwS+w/vcyU6MAY1cj+0bNnyYZNrjs9
 k5bm7ZT2mvax6UQk+GUvI7ZgI6g4YZcWBphHEh70d2VIyVfJZ4laaNo9aRS5oZaCQTTsxMtA7gA
 l99HvLb7JZZDth/Nf2a7z3zXWXbKcb55rO5Swfi2eRW5jvJ4C46OVmxldWleT/PmhJD6rbp5gce
 jbMZrH+tSScJV1SeTuw==
X-Authority-Analysis: v=2.4 cv=XYGEDY55 c=1 sm=1 tr=0 ts=69a57592 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=-zv6qhOvhvydiuV9Ov8A:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: 7exFwuDDmiCFWXZGQxmfVfposMrQ32Wr

On 02/03/2026 02:16, Benjamin Marzinski wrote:
>> +
>> +#ifdef CONFIG_SCSI_MULTIPATH
>> +#define SCSI_MPATH_DEVICE_ID_LEN 40
> Is there a reason that this is set to 40? scsi_vpd_lun_id() can return
> ids larger than 40 (struct alua_port_group uses 256 bytes to hold the
> response), and I don't know of any guarantee that the id will be unique
> within the first 40 characters, although it certainly seems like only
> pathological devices wouldn't.

Right, I will be increasing this to be aligned with what the spec allows.

Thanks!
