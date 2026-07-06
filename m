Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD09539E9AC;
	Mon,  6 Jul 2026 15:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783352676; cv=fail; b=iHKa/BpLqJvl6CFJD9ld/jYZNPitNv4HqATqHG4BhCHWaFKr+FkzwLj0s8mzU3A5Q7CaDRO+CTvOA5oH5Q0Is+hdaMN7Is9rTLpi0manDtFnSHjFiEQy2ewgmwCu8kOh2Fg+DKgF9WKN70Nm9XXDA2vRkjuI+nhGj9PwlMFo+so=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783352676; c=relaxed/simple;
	bh=jlfOjPvnvaKGx5lgGLJnZ9F2p/HegQ9AhsejckbtMT8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OjscvcPbLslbsyQLP7o2aJf0/r7UeFHn+1OBxFmgAW/VvRqgDIZ66w71mNncKF2kq5AaORyoGztd788I3RAnbMQF0lrWTjws7OdwldXmb46YT02tzP1K7DnuZOehc5nNLXElgw4huJ0ncbBu2JcAB1KoLewE/VxA6qQPYWpZg6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RemY2a2i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OQPw9zeq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RemY2a2i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OQPw9zeq"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666F5LNI1338073;
	Mon, 6 Jul 2026 15:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=E1ZUfWXWVrXcW1PTnUEzJwhZlQvYinjan+1ZCwQiyK8=; b=
	RemY2a2iAYaAxKnmPYTZ3U5MRoWcMKg20Z/Y6oNAzFWJUAWYFTNfdnyMiRCThfwB
	YpwfPzlWtiyqdm82lZQpEaYO65DdF/gkAsZEC5mcUyNKU6DZdZBIA1ZpzbS+6cO6
	SdUKJH2VAHOYwXB355L7vljd24HjVZI5NlU0cWUtODruVWH0UPPgITYojlirxZqk
	VGbwxrScP6/WrWleU2oh3gVeBfXgMFQQ1hJHBktb5vzU4aoMjVlQOGO6CYGuJUrF
	ZM01mOVq2H+V1xXv5EbMpHYsIHfm+GCHkJuyrQjnfbu/37tAObjBWx2/vnOVuyMU
	YoYZc41bSgnnpCHXGMSQfA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rs1byj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:44:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666Fh1aj000706;
	Mon, 6 Jul 2026 15:44:33 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6twgsdxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:44:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nJaAqlvF6q87vHwDKoMt9FJ/PbqeKpz5p45CWrNzfHvpXQFX5NbeShH7OshsbgMrngXEH4Y7qkm+ct+XFEzSgA61CZ7WnfVAltoitvTqYfG+P/tIoa63iNwUEeLX8UjcdNZE9WC9bNmuANct1F2NFkhq0tFTifTKDKGI1NjG0MCAEQXItXxTUS7yzqDg+bOkZ7QlYmtKuJuIgRWQG+5jtpq2srEU6YLe8JtGkzyvN6qPwDJvzSZf2sa0fVPmBLr1hUlb/Ee8l4mSrcG9r/Uo6xauWE+rOjq3oiLHNXYQ8/RTLVuxf3jEPDukwCMloRdd5DrCJg6cAvFOOSo30nYmpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1ZUfWXWVrXcW1PTnUEzJwhZlQvYinjan+1ZCwQiyK8=;
 b=h33amCeTNPWzO2h6sOsrczr6zeEGBJf/HEzmjGkDMW+CopoUqLY/R3UmdoEjwt03C4eURBYU/vXbJo592jG8UOSsYEnhhTJhigCA5i7cffA4zL7KdVKAO7ASmsYDZHSirjDlzladl5nuxeOQIzv5H7IK71rATs6s8Qw4KzFqY/9Cmx7IJwlgBgaXH8lETWJW53Mhdg7bN2+ZQZiNoU7+RZeFY37um9hpS3Yyy3Ztqg1HH7vG3ki28LuOyeg4RQ9mQMbL0hysJ+8TZT36wHyJCpuB7oJyw2ELweI+OH5LoLAhMqT0UIPQF4Tx/pKGLn5Va2/2daJSdjzGR8cokN8rKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1ZUfWXWVrXcW1PTnUEzJwhZlQvYinjan+1ZCwQiyK8=;
 b=OQPw9zeqvwugGsaLEo/bnZqg+Fyq8BQDM23+9BEnObgVTHzxQk7rIoEAEMhJy5nhbuBdA0f7DN2YaHhro1XKErHGJZS9oA7Rnwr11G6Mi+8SiZ1SqRr1QYgJ2VP0v70KaX0Tx9IvFnfEiyiLy4KfIBiYrA8XuuMXqvqrqlWcbnc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CY5PR10MB6144.namprd10.prod.outlook.com (2603:10b6:930:34::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Mon, 6 Jul 2026 15:44:27 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:44:26 +0000
Message-ID: <8c615426-aac5-4aaa-8af4-a1a5afd642ce@oracle.com>
Date: Mon, 6 Jul 2026 16:44:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/17] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-10-john.g.garry@oracle.com>
 <20260703115351.1C2E31F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703115351.1C2E31F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX1P273CA0018.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:21::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CY5PR10MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b54175f-67b7-403b-a6fa-08dedb757555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XzZ4HJXtoh2LHBlO6Tao0vAkYz8B1x4mnQfdA2NI9lsdYLzjpAOKhbQmyzZekvyzXmT+uMqaZ4EmL0//TQY/DVa1F6kvsXBiwyuuuVY2nxlHAfPxR7RqhlQV1tMp7UoeVcrLQLzMt4NUawh76VJAYVmmYFzeUtduj+K2kIAxOteG0YnwGTHqiz8wpLJ+5LMZxCt3JNl5BZmeFtqxgGxs8TvPwh3kVYL1EBpY4gH9J48080R0B8JUKYl/DToTHI9agQm8eTRiVfX3uZ2qsOokeRBnSzGdfKUKc01FKqaHILyo1iEyCC2aEt25AKY12lKNgML6W8tfXWlF+qUqj4uT2eGLlnH9TZpmD2PfstKcbwOzSiayprnnZU9pbvN8PoLYXICZs3XUnavQe1MieVyR7HR0BigCDtYcfRAZ005MEBcAS805yOFz7e681yQyCax84W7ESeUhqoROndJbUohNQJn+sqKjlWLzBytRkOqzf38jPLj4tACLzXQBNdJVN2dCwIkegKKh9JtbwDWTm6tmoyaMSVR0jlDonG9jepA2OirkcMAP55eNrvUh8idIE6VGB52sQ8+VbPz734Zw8dimyegv4CJtu44B57FK812yDDwruUaKdxK+6R7bNc4PqoBv3aqtXl2f/2cSKLeo4UdTh+fm6XTiI3ZqkOY61CuzRZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDhtM1VEVE9CYnordFNBYXVPVmJZVlJtblZxemY5bWMyZDBRdllVdkNpcGlm?=
 =?utf-8?B?dEl2T00xVXJkaEJkaEpubWhTV0hwWFBSSVhQQXdFR1pzSWtHR3hQRFZhL1Fn?=
 =?utf-8?B?VzlBOWszcGQ3cVBvcENnQkJkdGRnNk1sWjg3UUovUXl3K0NBbGZ2bDlTakZj?=
 =?utf-8?B?ZzFEdEEwRXlEcEZYbldHcHR0bXprS04xaXh5Qnp5UU54R3JwKzlvNXJKUGlC?=
 =?utf-8?B?TGVpS2hHUDF3bG05N3hmVlV3ODA4YnNPcTZnMEt4eTdMT0tYZDViZlZ4eUlZ?=
 =?utf-8?B?NWhoZWdBcHZKaHNyRitVdmxYYTN3bnNuS21URkRuTXlCYnJ1cEtFcFlETTdM?=
 =?utf-8?B?WHpkQzU3SW1DLys0V2lPSHo4R2ZhY1daY1hxVmlwNEE0QVhVUmVNZldtcDMr?=
 =?utf-8?B?T1hQMHZ6akNtVGVDa0c5UURNcXNadWN6WVlKcGxxWEdDVkJ0THd1T0dOL1Y5?=
 =?utf-8?B?MTUxbmh2ZGxpRnFOQzgxODVESEtKVnNYcjNOTDA4UllWN1h2OGhrK0Zucmow?=
 =?utf-8?B?NG05dyt1ekI4RlNOYmhHbXpwelhUcmtjWXhZQzEvZjRIY21Gbjk0V2x3ZVh0?=
 =?utf-8?B?QkdMSnB5TnhFT1hWMDZ5alRnR1hyZ0lLWDRnUDFMMG1Fc2JNZVZrc0c2VWZv?=
 =?utf-8?B?K3RQSkd5bkFvcEkveCtzYW1NbjhUZlkrVjg2REpuNjZTeHFINkVFeGVzUXly?=
 =?utf-8?B?ZDNMYzM5MS9WWGNhYjlSQXdjZVQ5T01uRTRUcGRMMThxZUsyamFjZHR6YmY0?=
 =?utf-8?B?c0VSYmVTWGF5K0k2UFNRR3g5cEhwd2NsRDFvL2ZTUWMvdWtoWXRSdVQ5Zkpy?=
 =?utf-8?B?SHFRTmh6MW5SN3FlQUxKeHluOUZPT2o1Qy9pTmxJWE9Gb2MvdlJYcUZjdTlL?=
 =?utf-8?B?L1ZWNkpuSFY1UDZlTUovd1RIem1GSHFFMGJXdEZSamczdUQxbTZZQWtTRXNq?=
 =?utf-8?B?MTkzejZBenpxc2RsK0VpUUJyM3E2dk5PbE1iakRPbkcybnBuRU1LVUcxczll?=
 =?utf-8?B?VFpXZGpuMjZ0VVZFU3pVbTd3NUh3TlByMG01YjdLd3RSOHVaeGNVdGJnU3hO?=
 =?utf-8?B?MDEwRitGUkVWdDVvSjhsbU9NdTg5ejN1WFNVeFF2MVQvWjhKL25uWVNJdFpW?=
 =?utf-8?B?bnd2bkdvNHVIK0V1ZkkyS3FmQVRIVTZIVVVpa2ZoN0FONWlmSzFjdnJhUzI4?=
 =?utf-8?B?U1pYV0U5Ujkzc3kvWUc3M0VJTU5YMHZ1dTBUU2M2V1h0MGhhN0drMXl0WVpu?=
 =?utf-8?B?UHZYUkExeERmSUtOZlRKMmRXZDVERVNMVVdDcHR4b3hIM0toUVpKUm9wb2Fn?=
 =?utf-8?B?SDVGNitNMVNPb29FMDM0M280N2paV21UU28zUzdGbkJySnZ5V3Byb0VOZTV5?=
 =?utf-8?B?L20zT1RGc1V3TWdrSlRUTVY4b0JRb3VPOEM1aWxlQVBRb1hCMmNYOUR2aUZX?=
 =?utf-8?B?UUxnSG9oeEM5U0pwTDhtK20xWGdWRHJWVmlDcFRTSDYzamxreUtVeUE4WjNM?=
 =?utf-8?B?b0drNmhMY2J2MDh3NHA5cjM0RGVWeVY4NUV5cUJKK0RjcXBwSWZNNVhhSlFP?=
 =?utf-8?B?dDZRR0dRMVJNMDBTbUsrRXpPWkMrTit0dm8wcXUwVVlWYllFT3ZxYkNjTy9m?=
 =?utf-8?B?VFcwcHZ2YkZOVmw1N3E5a2ErWGNJYTloeFF5a1g0MVdRZXYvZU42RUZHTjVR?=
 =?utf-8?B?VW5LMk82aUNLeVdsZGFoajhBb0swNUVtMnJaK3lKWnk1MGV2Qm45VEk1aHlx?=
 =?utf-8?B?Q0U5RFk3ZFI1VHRpYXZxRllXeXNoR0c5R1VyL2RoZnJsejA5TzNTTUJEbWN5?=
 =?utf-8?B?OHY5TlJTSkNwdllwSi8yS1NDNElJWWVMOTNiOXp1eGZYK3dQM2tkbEg3ZktV?=
 =?utf-8?B?YUhXNDBidVhoMy84K1pERzc3OWtwdU9raWFVTVRvVkZYcWN6ZVRCUFBXZTln?=
 =?utf-8?B?eXNiN2tZMXN2aXZ3MjVFN25KNGVRRkVPU0RrSGovRGw2SlkwZmg3dkg3bWcx?=
 =?utf-8?B?SmhyKzIvUkM2QlhNNm9LMjhuZWdiSjA2UEpxRGdMN3FUNlZ5WXg2dHlkV3Zh?=
 =?utf-8?B?UGRWQzUrRWdGTWFScHV2d0VlODlqWHM0K3dDZ0liL1FjWlJPTC9VUmd6dHo3?=
 =?utf-8?B?OFN4SUJ6bDdveFN1WlV5TDhXR3EyUXEzK3Z3d2VOZXhCQ0d1MjNoR25mUFhw?=
 =?utf-8?B?c0x6UmcyNHBIZmdtM3pGSkhmV0dFL3UwemxBSkQzSnpobVo4VGF3dzNKTFBh?=
 =?utf-8?B?cHhiS3A3dXNvZkJvcjFCSjl2RExkMW5iZWZYeTBFLzkwTHNRY0FBRndqSlRo?=
 =?utf-8?B?dGw5UVc1enQzWjF3NFR0d0dRRFR5U1F0WitHWWU5NUw0OHZqVTc4R04zalB4?=
 =?utf-8?Q?XAEstPny/wqP3J8M=3D?=
X-Exchange-RoutingPolicyChecked:
	Pz2P6hq9hEJ23RMCewVcZhgcjaurP3pGC/OUDGkyE+DiI/z2MwOXUSgJRCHcBktnch//DzG46sKsu8TR+oJqyTwH5iGLE6wtit6FgE/bY6C8rRUW/o5Ou3DVU9ECNnCB8YpRfWlERe4lkVDH6T2R33eg3ttfRhQqbkWr7dX3SnEf/xsl76sdWMJmobE/+yAorsmyyIJ293SxOfa31JSXMnKSaRbTYX/RLSZZB6v2ZnD5y1jP3hHWHrvWv8MX6l5CIrxGo1NO2u+ERk9h4JWwvIE+X6DyOLPCi9EuC9K21ic26G7Vc+7QvcrILMvF2lE13Ylm+W0pOFCuwIilQW0Aag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BmjV9AOpK/Y6Rijh3zEaJDHRLdTmiBmNqFHXSqPCwhyhhDkOQ4cN6Ob+3KYE/EOTdYKyXSOWzB9nD7XZ0X+1E447k4yr2BSPwKJJKIn3tua7K0dYCDoeNe8PfZbIE/0YRe4baoFna5E/AZd5D4EAfaJpIZ5ckDZQCfXuX4FZEcVpFCKEI/S3yX87bk48cjjxOlzEsNGVJubQqJHGIg6YWLn5BVOH52m+ppLLSlYo8yzNJ0XEdHT/dL+TGkQF7PwtjjC0VOG1vkHBvSNn2FI0lMWUL1ZI/HT+ozE5qG4OzDpixZEBgr+3wuUnNQ4vBNQERjdt4KAAgk+6BOqD5VUaYLLLqWZjcFT2jFLxUI9e21rhSEcmrTIElbfBKZycZgvC0Lq4iCrbwWHwVhCY+c+AiYGQVvz/dQYa6n/2WzkhGeCkiiKIx1FnD/My0TqgA//yU+CS+kGyCm3pKgfP/ojrLvJBXinZ9sWhjydYSurMF8ROGuP23dhwuXdhIfaXbBRxpunvwnLitwnaATMLFCkTG0dC4EkGFjII7dGdJexicqAzHN9aQUIcXdvXSRVfZWGJ4R5gPcoRvF+3WixswVI/RVRRz/Wdr7gQHHCo15rb3e0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b54175f-67b7-403b-a6fa-08dedb757555
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:44:26.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tToQLDJ9rWrbYZRCw0iv4Kt9CoyxEmheAAMwG7YKb60iPg5wOrbNPEAGg7wsFbpI00i03jTS/I/D9CzPdsukhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060160
X-Proofpoint-ORIG-GUID: Nn9aU-djDzZIYpwXoQYuEv0dmktQbv2a
X-Proofpoint-GUID: Nn9aU-djDzZIYpwXoQYuEv0dmktQbv2a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE2MCBTYWx0ZWRfX2Y9Ue9YGFZ06
 veFFfZkBD9gPFBaThM+9wsB2P6OSUd7QHWg9be+1HRrr7GtSnKuZcsMbjNrHtQ+EZEHedWeqSc3
 V+Ezz5Sq/JvPDs6JH/4VNT0Wbk48YnxLcApYByZhIRWjdtf5wWrQaw5DAoBk0mVMALRTth/6zuB
 SeNyPV5M2TiuK3JZdJ26W7MMZiBP7WvR0mVyd9zv2CsQhrfTyRWdEBIwGYEf+2Q3WQmA9b2KpSs
 KUvnRGT34zdzHEZJ29BE0lcUXq2GinAmscXmXa/Qo5BwTkNM5cQJ3sAEyF3LB/ZjDRTOGzMZxSK
 LCG1Yb6gisi5GFZxkrvcvjW/4KFzkXo9IB7nXZWXrmrOQ6v3N3LmcxdnSPK0ve+Ygezq0DB7ZJ0
 iykarlPDuIU5VckzgEr+U0ra/imcVlbLqphQRBL0V4ScEgxLSrisIe5YIXmdIrkVjH3eCmN8ZcU
 6X9ebsBa5o++bvk5Hvw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE2MCBTYWx0ZWRfX0ca4DmiXZcef
 7YavmGA16pEKNkd3CVKYdRrpyuuZ0/60EyXlk4+SULb/SepLWLZTehBiE45FgiGrLofen/cNzV6
 s030YpSKZgJc7HAKw4MB8ndTSdDrutTy23YTulSDoX9bvbOmj6ii
X-Authority-Analysis: v=2.4 cv=Vu0Txe2n c=1 sm=1 tr=0 ts=6a4bcd61 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=kAacejJ5YOGKPR9-DwkA:9 a=QEXdDO2ut3YA:10

On 03/07/2026 12:53, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Requeueing a command causes permanent leaks of `mpath_nr_active` and block device in-flight I/O statistics because `SCMD_MPATH_*` flags are not preserved.
> - [High] Premature termination of I/O accounting and double-accounting on partial request completions because `scsi_mpath_end_request()` is called before `blk_update_request()`.
> - [Low] Implicit function declarations of `is_mpath_request` and `mpath_qd_iopolicy` cause build failures.
> --
> 
> commit 6d78b641877657fb26302d1c7965b47fd751383b
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: add scsi_mpath_{start,end}_request()
> 
> This patch adds scsi_mpath_start_request() and scsi_mpath_end_request() to
> handle updating private multipath request data. It also introduces
> mpath_nr_active to Scsi_Host to support queue depth multipath iopolicy.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 3c493068adb98..72ba066235911 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -669,6 +669,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>>   	struct scsi_device *sdev = cmd->device;
>>   	struct request_queue *q = sdev->request_queue;
>>   
>> +	if (is_mpath_request(req))
>> +		scsi_mpath_end_request(req);
>> +
> 
> [Severity: Low]
> Are the functions is_mpath_request() and mpath_qd_iopolicy() defined anywhere?
> It looks like they are used in this patch but not declared, which would cause
> a build failure.
> 
> [Severity: High]
> Does calling scsi_mpath_end_request() before blk_update_request() cause double
> accounting on partial completions?
> 
> If blk_update_request() returns true for a partial completion, the request is
> retried. Since scsi_mpath_end_request() has already decremented
> mpath_nr_active and called bdev_end_io_acct() without clearing the state
> flags, a later completion will decrement these again. Should this be called
> after blk_update_request() finishes the entire request?

There was an ordering issue previously, in that calling after 
blk_update_request() meant that the request size was then zero. I'll 
check this further.

> 
>>   	if (blk_update_request(req, error, bytes))
>>   		return true;
>>   
> [ ... ]
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 8ecfb94049db5..c6571a36e577b 100644
>> --- a/include/scsi/scsi_cmnd.h

