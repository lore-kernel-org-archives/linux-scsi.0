Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A71B3FAE19;
	Tue, 14 Jul 2026 08:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017915; cv=fail; b=MrlXHqegwnxwzf/1oqxpiK4htPgiQ8K0bvJTk3mh/xGf/Tb8UHM+TYsj13YcVu+7i8Ag+6kHDGDztWhj2jFJN9C41Wmcg4TBQx4+2BORrHNo8s8nFBShAPnPo/JHTIUHyZOCHp46/3nOqsy/p1QHrs0RQDRtMt79avr5d7NLhKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017915; c=relaxed/simple;
	bh=TUMxuaZxEoWS1N3A7KBPfkuXhxP0ceAsV7y5EihQV68=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZJVmXNaid8Mi7fEFCdwnlbRHwlEAeZng475xzbcvXF+Fxg1/sZZ48qdyNhF6WfIUT7V0PsuKMOO+a0U4jICRiL99O5u30Y9QhAu0mRbeREhmzAE5n099OoaxLQmVA4oPgRirL+wTcYyHajhg8cAtFce/pgsezSTD6xflTxaewyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o3HXgTEI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mGrZTTV5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o3HXgTEI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mGrZTTV5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DL45xT1379899;
	Tue, 14 Jul 2026 08:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Zkcz2hE10DIE55mWIGcqRRpQu53hEXnyZ70/fiLwxKE=; b=
	o3HXgTEI82IdUtt1mbcz7JHkqvBvOOJTWfcHj5TspJ8SgVpNoe7r2qpwOA1fQkwt
	vhX8I+Y4X1ezzMn/DniBOQ0X9CQhIDQzPWkYekIMl6E3L3rH4ucpQbK7/v+Eds2A
	9SmkuBTpCooLE9nHcEAhdmGqo4zIGW7/+hs65H/0jrf2wbduMW1K4JUNYD08QFo7
	nF49q9v6qBSUpc0UDCtcyJWc5Ssp/HMWvzGP/PLdg6Z8Ubf83Rd1K5Uvtlpqr5/8
	T/pQMLmA27951rICa5VMNntEQuIS+tlUYpQJ3BdyyyY7UwOz4jSctC7rndgkoc+m
	oaLDRFFJBbcF1oiZR5ZgWw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed83r7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jul 2026 08:26:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66E8ODlG016577;
	Tue, 14 Jul 2026 08:26:25 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010006.outbound.protection.outlook.com [52.101.56.6])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9qw2tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 14 Jul 2026 08:26:25 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HicKS23JC9nfsbUmwoGxwfDLatMoQhqnmJZnj5UEaV54FklY84Aqpn1Gb1khY63+MFB9us+bi1Yg13hgxIoOoh7jeQWQaCEQ8YuSPv64aglLnQeglzU1fsBzgOZtaefxBE4Kccmk6MUGa9mn2MOIqK97vFGSpzaqH0QNYyjE1Q9O/tGa8hxIbfovG7JiPBjElAaZEPrCT3dvY4kuGJYcOnASLe6wWmrVUiQqP69073j1l9s5dN9jJ94cST6kt78Q590oDWJlgcJQumm/Z/ox4ZjsiJQ0BG2WrPA7dud1j9PBazC1nBzMRdGOSDkl210W0HkzALX8cnScTVf0ZfRqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zkcz2hE10DIE55mWIGcqRRpQu53hEXnyZ70/fiLwxKE=;
 b=uDd8nWwWV4ZaR/t4CH7tqskDsSXSLNfqixXBKAKtSx8FkhQHI4Sw2/vblSeu2drZoGh6lTMBZohOyw5TVX7bBff7LBFxhgw1VQR637si9MFxcuzo2gn5Rc7umKV3luoCc+XQ9a3ccYQOiJ54TyEWuudJ61OdFE6QQ4jQQnnCz2bQWhNW4s7UfZvCCNvlnOccCz24nFbxbSQh3Cku2jEs7eJ7xNTOn/WeLz6DAZGadMy44qf3xOfAfR0tTjKQ/l36r8q5oXfn9vM1bn+stt/zvTJZ5PiJj7/sSeGOavi3P2iBJb1WTUsjb8us5CLGCLpCvbLHh2b7WkTfBukxgBVItQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zkcz2hE10DIE55mWIGcqRRpQu53hEXnyZ70/fiLwxKE=;
 b=mGrZTTV5/p5ydQcYttm8sg6+hpP35pW9Fn6nkAEwquW/2kbsUDNWB4k2e8FMw/j353L1c+mRnAJfJ/rlxQw6/7J46OMf1F3ZApULuzFutJ/Ld6GhPdWf5JHpgUGMH/JsXc2uZWScVYak2Xgq8upvJaCklamIYt1f08BNjjKu/I8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 08:26:22 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 08:26:22 +0000
Message-ID: <de319ce0-ca42-46cf-87ea-98c93c73bc8e@oracle.com>
Date: Tue, 14 Jul 2026 09:26:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260702033211.1743313-1-yangxingui@huawei.com>
 <379091c9-3cd2-7599-baae-8c7f278e7ec3@huawei.com>
 <56d1c5d9-cb3f-4bef-a099-304ef0c49837@oracle.com>
 <e91cdddb-2323-904f-dc63-3d00597b5c8f@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e91cdddb-2323-904f-dc63-3d00597b5c8f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0045.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BLAPR10MB4817:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c0ab0b6-5e48-4bf0-bab9-08dee181965a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|22082099003|18002099003|6133799003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TxOD1ZhZ0fJVXsKMnBbqyOAOzpNTqz86nXRThCwGGisYF7bRjHWMtY5f7gJNpTxvSdIIf6D5IWr1jk5Q86fDnhle5PcnlAvLuyh7Vu1vZkupPAW0d2H+W8e/os86acF+egA9YNU8+HsLm/gx3Ncqx3zKIQ+fvwMGxNJDyyulEGvlmCTA/BA301Kwn94UdOKzbSwmmjXHvWFgJbyrxPC2WulK5qRlXch/7ZYW8av+DsUZ7mpbwZYP84whPHVcvG1PPwScLuiHrUCZt+3vuDGtz/mL3DISbuwVPqEXhHsQtdQ/ecFsZHxf9Ec5aZMHI8KKKPy6qZ917hJV/xcp+x5Gaic51f58q+3JrCL7X/x50F/k4eU+NFk9vz+bgKGJ+j9stnQ9antwTC5ojP0eyzhhYoMbcDMsIiOiNsiJkagdgamVP0CAjhPL1qY4GYlHyK4MdF0j9m2JxAEqS3Q0tMsPJTImluSwhzxLeo4bX8OfdDfiEdUpvenMYiYkdO1om/JtqPqqZmjoebI0XLtJMMOCotJ+BDlGeUbNxEjqUMUmO8jzRILe4Q4Y7qbuVHKz6z8NNsiBixfX/st33i5H2H4Ukz0PU27MNGqcoGOZhMWbk2EBtAsGgYZmkblmAopSrUVZ3NQJb3MsGKMsOYI6HP0c/RBrODwYjr9SoRVm1yGf/98=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(6133799003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUZOV25TNWYxY0lwdVlIczlDWUZPeWptYXdpUitRbWwxeEFyWW9iMlRodVFo?=
 =?utf-8?B?YXVpT2xCOEIva081ejA4enZ3RnJKck9hN2RHcHE1V1hDZnY1Q29EMkZUcWNU?=
 =?utf-8?B?MEh1ZlN5Y2gvOUErWm5WR1VnTjR0UFhNT3BVVjdBZFI1Qk5sTVByTjd3bkMy?=
 =?utf-8?B?U083eElwWCtMYmQ2aGhvVFlqa0g3dmhMc1lFUWlNTFVSbzlYcnMxV1U4NVdT?=
 =?utf-8?B?TE5PVmdqTUVtVElsaGJDdHIwSG5tdFVycCtGUVVqaXNERnc0UE1lblRMVnFr?=
 =?utf-8?B?bzUxc29EdnIweGpiL3JuYis5V3gzS0hOWDkzWm9XWU1sUWlnQi9LTU16cVgv?=
 =?utf-8?B?NnZ6b00rQTA4NUViam9TekRLSitVellsRVl1Rm8yUmlWUTMzRTFUT0pBZWVm?=
 =?utf-8?B?MlJpdWhTcEpsNDZWNGF5UU8vR3hJVUp2ZmVUbithOTl6QzhmM3lOc3BFeGZV?=
 =?utf-8?B?LzZmQ0ZFVzZkL21yOTl1ME9lTGYybFcxK1lqNXI4S1Ixc1NTdDlYOGNzbTls?=
 =?utf-8?B?ZTRtWE1sZzRoaUxWbnVJaFhzcmdrM2k0cS9UMld3S3VrcXZEdzJ3RDJ0Uzlj?=
 =?utf-8?B?VU5XZ1ZFWVVybGZzeW5BSUZFTnJSSHNKZU9EbGEzUVlieXZQbTNsYmR6eHp1?=
 =?utf-8?B?RFF2Z2U1OTRRcHllZGlFY3lEZ2wySUlqOXo1MW10ZHp2anhVNVZKeVVnbnhx?=
 =?utf-8?B?REExOGk4eWo3NTY1UWNCc2pwcjN4WGx2Q0NkVkdweHFVMTZPaWg1MnZlL2Qz?=
 =?utf-8?B?WkRyU1d3R2Y5LzBVbTFrdjB3TlU2TDM0K0grRHBNWStaM1hIdnRGcW1sZzJH?=
 =?utf-8?B?YUNaZTMrZFVYUzdhaHk5SjNYdTFYaER4NTdvU2N3TmdHMkRpejNDWHE5UnhR?=
 =?utf-8?B?UlJpeFFxM1JtblhocWg3bFFjV21CazZKZnlpZHJlQU05VzZPQUdjUFZIeDZv?=
 =?utf-8?B?aGFLTHllUVNqZVViYVkwaXhDaXhwQi9KcWM5cDZTT3dmOHJ0bnQ0bklwejBy?=
 =?utf-8?B?bnQxWHNTd2pQV01BQktDb1lvbnpETFlaQTJ4YTA1enZubEdXY01XTlVtRCtl?=
 =?utf-8?B?ME5OWnZycW5hbThmNWg5ZXBpMU5yZm9RdTgwY1hHTS9FeUFoQ3ExN0pOYUw3?=
 =?utf-8?B?enpLRjZBYWozMUF5RlBBTFk2SldOVTRDRW01Z2JqRUU2Rlp0TEtVL01MckM0?=
 =?utf-8?B?a0xMZkdQMjgzV2M4Wk5yV3JOdzlaSFJmRmxMZmFRMWEvaXc4L0dkb3lHeTNu?=
 =?utf-8?B?cEFOclBnaERENU16NHN4eERTQyt5RUR6cGgrWTJwUENmb0VNNDFFUlI0S0RF?=
 =?utf-8?B?MkM2MmRWT202M0hnSm9MOXFVNEdlMUZKUG1KTWdwRzBtWEVLQmFPR3kvU2sz?=
 =?utf-8?B?TFIxNGRjZ2Ntd1h6bzE5aWo3NGtyeEpySEZOK2ZjSHBsZVRGZUxrNVhOVE5B?=
 =?utf-8?B?QjJkVzlYd0haL2ZJNEtBR1hQbGpnc2hydUxIUDMvcmpGT2dVelljK01yU0pq?=
 =?utf-8?B?Zi9hZ1RVeGpVSmpvSGdNSXRPbWVLcnhReXRmclBqby92N1BtRWNpdHJ0Uit5?=
 =?utf-8?B?b2FEeENMUGZHaUxEWWM1T3pZSVFrTFVXZzBjTE1zYklINUFOOUFvbjcrU1Ur?=
 =?utf-8?B?VHE0UGcwVCtuWTZDdzYzeGJJZlJCeEdzV3RKVUVaNW5WeU8yZ2FTM0xpbzA5?=
 =?utf-8?B?M1IwblllSUNqa0NSM1JNdm5DQ2prc2N2b21PZEkreEpCTHJhUjJRZHN6dHov?=
 =?utf-8?B?U3JFNWR0UThlUUgzZ0w1ZFVpczFGNlRhejl1akprY0kvRkJHTWdMS2VjM201?=
 =?utf-8?B?MHUrQVl1V2JDSGxaRVlkanUwTDlFdFl3ZUcwQ0pQZWdINkxIMHRFeGJUVUhp?=
 =?utf-8?B?ZWZiY2VrK1ArR1lPSEZ4QXVpQjFBaFVWU1ZlOG9ndEtzVG01MElIUFBlRVVo?=
 =?utf-8?B?WlYrS1lBZXBOVVJ3SnZvS2MxNWp3UTZtOTVkLy9LS01KSUxFNWZzRnM0ZEtO?=
 =?utf-8?B?NFFLaDdsdXU2YlRCOHloMTQ0OHc1TG9rSGVLenQ2Y0EwVE15MzU2VllRTmdr?=
 =?utf-8?B?eGVhWTU5dElQbVFEeEhXM2YzZ2xlcjYzMWNYcXdWOHV1SFcwdVJVKzZMZEJv?=
 =?utf-8?B?d3NINVRrZ0xHb2x6ZVhPNzkrUDQ1NDRvaWVxc04rQkNLRjB2ZjBjN1loNXVJ?=
 =?utf-8?B?SUpEL1ZWSDhObm1rYmpsQmVlS1VQN3RZUjNZTXUranpYbml4aFVWZTZ6dGp5?=
 =?utf-8?B?Slp4VXo0V3EwTUpBczJjSnJUSWVIVC9tUjFpWnk5QnJBQ1BEdnhnQ0I3cFI3?=
 =?utf-8?B?S2ttQVAyKzY1RWhlS0NuM1puT2FzQVNyTC9nd0JiTDFrSEF1ZW9qQm9aYnhW?=
 =?utf-8?Q?HzgochC+rYlmC9Mk=3D?=
X-Exchange-RoutingPolicyChecked:
	mfhi1+AVvFP7I+KvuOmNQCYLWCthMF8ySUkQEoVfQJrHpwcJ1e1NcLEb1+paXnIej0mO8FTqJixZZTCl64bRT/p4ghv+FcRjrqp/woEmIsO+1YxpdTkjgo/awdF0yvpJefkrnShFONSz9MuKvuoy++Ojm8rsFFYcdgN6I8TrkZMXYKOz4qWNwvP+kOn4zJ8sKojTWBhTq3RtUKqLj4BvvODkJaasG3mNMX8OHBr07xJwErPGYh7KAhtAuA8SGAQGXyJSrFNc4REKOOz2GF6ZhwqIYAo1WXzxZvw8kY+x243+MZt0S5wiic2cKoPXZcQ6Gufl3hFFP+8+zuchRDtwkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	taA0M1vaX/WbDzxcxO0paLiWvezGFd5/OMF01lFx82FKaLApEehLW0LYlI+A0/LNXq57gmkpY9E741r7MPleRulRLnBcquxjtN3EW8J9CvLGSM86Ui2YLAVunLknBwDpiD8ScPjrmBZFEgBrqehU9fleF5s80L/Z1M1K2jMW6EpJEUrYbfiqDz0vgHomEunOcw0geV8NrWjdpeSD6zFHyoISVMeHxfd7sNzFQkfX0qkwZW7xFBupf41dZfyg3T3kQ54LJJ2+fxlifqdgqU0N7HBnKn2UoF4B9hASNoj4SBOyDZCmTtC6TBBfPc/JgoHS3glawiwmt8c9yXPOzeWGi2SHFB467SV59FzHDD/1Ekhrno6xYAYJ/x/5v2bCv41rtf3yNqWX60bColMxuicafAjgS6rOsaqEEvfdf5YF86ZNxLR3pO7fbpJ42+swKj/PQPk8MXqX0M7271DqCLi5XF/0MPya0kzMEmf8pb/Or9WnNnwQ09CNDGdkm1vtogulj7gd6rwkbN/LSZkN+7r5BDrzFxPYykOuivtMhrqCvs2dArW4WMIgHjY7GUdknTwfp+dstGycpFO0jakciMILB3K/eiaO0x2vjYoB/xpOzjI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0ab0b6-5e48-4bf0-bab9-08dee181965a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 08:26:22.5907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdTaRsfeIDNv26A+OW8XEzabR77Y6HDuyTu9LXKMLCs1qsM6iiarNlmpNnmOD5sjxnyAWAmFqkQ5ewvobOmuWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607140087
X-Proofpoint-GUID: LgZ690v8z-i7Zo72ysZUuaWg8NOfzADy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDA4NyBTYWx0ZWRfX+eUjGjN9yl+y
 a1JGnBpr25JmdLYFH9SnCrIxDPyKpL9KOjvLqjnItngXh+MhCfoVApW3Ep5N5NND0w+qkm/ztlN
 fXmubNOT+hxaBUrFCetack0/lCXKhp6mmbzo+a3N/W3iPA9is+ni
X-Authority-Analysis: v=2.4 cv=JKALdcKb c=1 sm=1 tr=0 ts=6a55f2b2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=i0EeH86SAAAA:8
 a=yhZUGwCR0fVt3Uxw9U0A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-ORIG-GUID: LgZ690v8z-i7Zo72ysZUuaWg8NOfzADy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDA4NyBTYWx0ZWRfX8Y1jKkTNWVuz
 KUxC2g50n6xMF+lUsGFrIRxe1pi2YcHe8I8pMg3hyvz03INgPBFLlbfMzekgdr/BYGdsgzfuG81
 NAtH7va9OrpFacuhhgnhmD3sWu6QbFQtaw6tuBEF9i44an3MCF7jlL3j8hCzxbKF3X2nGaMbxQ2
 CoHuMhU2AtvAOFxUKVbGwH+fodhnXDRBdClZx+HDth9NWvmqnj1UrojlMzWnhpxwXblgGPhVVWU
 /ce1o9TkoDP8g+2GlBko5wNFHDPrq3Ymea4D4ejlVPcBBgJ+7tHDPNJUFjE/Lg1/CGUqTtXB+xW
 6dxBaPRCwPC0sxRqHBUv7rfNstSovbk+67hL2sKPU9Ne8LHZEb0N9H/dOZL2NfSea5YFchp5FtN
 J4NrG8/gdWyOEId1zdmRTC+yitXwfwEU8p5cHIipmjmopqV/8fMLzJOBsjglahANrc0DkTze1aa
 pYOoKPI5UxXOT8jnPbpVnHD6iK1RtkmrROjRPObw=

On 14/07/2026 03:15, yangxingui wrote:
>>>> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event 
>>>> workqueue for HA resume")
>>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> 
>> Any idea why this problem has only been discovered after 5 years (from 
>> fbefe22811c3140 being merged)?
>> 
>> Is there some new test case?

ok, I can check below. But another question is if this applies to only 
hisi_sas driver? I mean, you are changing libsas and the hisi_sas, but 
not other libsas-based drivers - why? They support suspend/resume.

> 
> Yes, the test environment is connected to more SATA disks. During the
> wake-up process, the controller wakes up first, and then the disks wake
> up one by one. Since the number of SATA disks has increased, and the
> SATA disk enter the EH (Error Handling) process when waking up, the
> wake-up time has become longer than before. It is possible that the
> controller has already entered the next suspend state, while many disks
> are still in the previous wake-up process, leading to a failure in disk
> wake-up and the disks being disabled.
> 
> However, we have tested some different kernel versions in between and
> found that the following patch significantly improves this issue, but it
> does not completely resolve it.
> 
> bede543d2f8a: ACPI: OSL: Use usleep_range() in acpi_os_sleep()
> 
> In addition, if some disks wake up a bit slowly, it may also lead to
> ssubsequent disk wake-up failure.
> [  286.932540] hisi_sas_v3_hw 0000:32:04.0: resuming from operating
> state [D0]
> [  287.732627] hisi_sas_v3_hw 0000:32:04.0: end of resuming controller
> [  293.167893] hisi_sas_v3_hw 0000:32:04.0: entering suspend state
> [  341.760789] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [  341.761006] sas: Executing internal abort failed 5000000000000307 (-22)
> [  341.761021] hisi_sas_v3_hw 0000:32:04.0: I_T nexus reset: internal
> abort (-22)
> [  341.761028] sas: ata4: end_device-3:3: Unable to reset ata device?
> [  341.916134] sas: lldd_execute_task returned: -22
> [  341.916161] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> [  341.916165] ata4.00: revalidation failed (errno=-5)
> [  346.980523] sas: Executing internal abort failed 5000000000000307 (-22)
> [  346.980542] hisi_sas_v3_hw 0000:32:04.0: I_T nexus reset: internal
> abort (-22)
> [  346.980552] sas: ata4: end_device-3:3: Unable to reset ata device?
> [  347.136137] sas: lldd_execute_task returned: -22
> [  347.136163] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> [  347.136169] ata4.00: revalidation failed (errno=-5)
> [  352.356924] sas: Executing internal abort failed 5000000000000307 (-22)
> [  352.357001] hisi_sas_v3_hw 0000:32:04.0: I_T nexus reset: internal
> abort (-22)
> [  352.357011] sas: ata4: end_device-3:3: Unable to reset ata device?
> [  352.512174] sas: lldd_execute_task returned: -22
> [  352.512255] ata4.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> [  352.512263] ata4.00: revalidation failed (errno=-5)
> [  352.512269] ata4.00: disable device
> [  352.512324] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
> tries: 1
> [  352.512408] sas: sas_resume_sata: for direct-attached device
> 5000000000000307 returned -19

