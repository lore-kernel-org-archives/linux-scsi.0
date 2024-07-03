Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B048D17741;
	Wed,  3 Jul 2024 10:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720001187; cv=fail; b=GGZRpmr7ozBaqjN/0y2BqPnKYA9YfFt4YlKxoGiokFboITIEiU4b9Ls21FhYMftCulSA8koBUpInbjHtTyD4UcFDaOk+vRl+/0q4707sB1Zln3POGmBrb2UThi44QFbHSpN50mqfZEWkwWH7L4V5sx+Y50hNrJqYfRqkmNEQ1SE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720001187; c=relaxed/simple;
	bh=SXT3O/42/y/WY+FXrvlPhK3n/l2esY9kU5chhcBnk24=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ph6kZAdLBrOnWlO2CLNNB3GqUzPrE9xEkHvl85RoTpGWsFreidAQKuWlwfzZRkBReADrWyKo6Rjpj6nvqPjaj3X1dZve/0RyDCQuB8qgHZi76qeKNyVnCcgnVn9F0/QymgGaDFA7I/vlh1I1wgVJehXpKaxqTYvrJqtH/W2USLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KKpbYqYJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xFzRjxnA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KKpbYqYJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xFzRjxnA"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4638OKsn015900;
	Wed, 3 Jul 2024 10:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=7kz8Z2lryf52HaaCpnCx5DpHs7bhaaETL7TiashxMCM=; b=
	KKpbYqYJ5rEioDqouppnOVCQE+EEXshuJn3e/S0Pz58MUA9R6zNn1EXisldf1xiI
	l49dm823TvxtsqorUf7w2iR0DmiCFN+KaUy2yNe1CtoXFciVQU0hD3q/f8RaLN1j
	af7Jv7TuX70e76QTM2WmsHvbhHJZmNxaQkxaUd5B9rxu5piBHjA0bWrAeEEjz594
	V8yqZx1qEuC9GptuvoPLQ6QiT7CfovjxKfNtM/J2R/q7hvuyzoNm0Ezyl6uCCoz4
	BRqnNIYbQmkYcZiFxBtwQwsuSDwZeffkvbTqPLEOmu4x6ro2nAKs6W2DxblebnUp
	PHftDH8HnTxBJ9vTbAC3Aw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402attfu5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 10:06:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4638Y633010972;
	Wed, 3 Jul 2024 10:06:13 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q91fy2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 10:06:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNJninyYlHTZWIJeXi8RsUI3Fb4cNrdr/WCVdfWdnYbk2mdop1oykCF8terM/I8+CQ3KvACEB8+LvqAFy+so5HLTHRnIdEVCQxumQSWghMR9+Igj11wUgnbi5wGBHZ/3HcYszEoqv5BWFWa1xGJ8vrsLclz/kUuvemIMIwgVR/mXL01tHEqBu6HhD/xH8JLg/1JDis4kN8ggPymZGKC2t0QWQ/V+8b/tS4V6PHyubELHC8aWPULTPbxzWJFbHwDkH8prm5rDbaPopAsLWdUg2ieOMao/YKlFPolS4tGHYfhivikbjBfMDqWMwF25NQMpH1/waIbsiBu1FLicHuyNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kz8Z2lryf52HaaCpnCx5DpHs7bhaaETL7TiashxMCM=;
 b=Mv9bpFqvn7LFX9gn4TTgoQqFkimDWNOwLlzt8y00bidzCo2qfiI09e/K2/W6r6EphR1GWcIk0uwTZtNWupQs+EOJHS5wIl+r4+MIl/PJxB29G1t2gsEMdiYW/9VWdBQHZJqBmGitYnXes3aLAjO+IyX9ccgs2+Ai7/w8vAxYLSXosY3Beri00GwIWtwkpoSf2uMwVXFFg+4smSH6QHibqjguN1LuVw54YFRtrXiS9dTfVYPkfy4lNWvJFY9x9IbSdW2utqW1NLv9oXmFAcfetRnaskQC8Rx0B+QtPHK4qtFN9AK6N/ryXjoLnVuOks8jI1zID86Br7k2cBwftyFXlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kz8Z2lryf52HaaCpnCx5DpHs7bhaaETL7TiashxMCM=;
 b=xFzRjxnA3Qi1+meRMrOus2JqGokCCXmBMzJTuYKKekK5FiX7dViM5VqMnzBEg5/IB+DeuIqHtZWOMFusTynkJTff0ptTCs6l1UWqa9ZEESrrE0iviPuItYjXpnVTzl4ek7vrebyX5rj/A5zz7KCjlJMTsAC6pqmbM04BHL2bnuk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5889.namprd10.prod.outlook.com (2603:10b6:a03:3ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Wed, 3 Jul
 2024 10:06:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7741.025; Wed, 3 Jul 2024
 10:06:11 +0000
Message-ID: <0b0310c0-a868-4474-bb1a-ce36167dec6e@oracle.com>
Date: Wed, 3 Jul 2024 11:06:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] ata,scsi: Remove useless wrappers
 ata_sas_tport_{add,delete}()
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        linux-ide@vger.kernel.org
References: <20240702160756.596955-11-cassel@kernel.org>
 <20240702160756.596955-12-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240702160756.596955-12-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR09CA0015.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: 97964e1d-97b4-4198-63c0-08dc9b47c3b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?clMzb3FNUE1UNWZnQzUxVlRIandWWFZaWWdzTlBZNC9XdG9UYWF1ZmVVd2d0?=
 =?utf-8?B?bW5EZlpnSnZZVEs2Ri9WTFhtSmlKVDB5Z1VQOHhoN1RFaHJjRzZnK3V2WEtE?=
 =?utf-8?B?QkcvNTZlZG91U0llbUZ1a2dGU0RMSm52MGxMSC9KdjhPUkhvVE5UeC9FUk53?=
 =?utf-8?B?eXJ5ZTVIUmVGNEt6Z280QitZd3BnVW9uNHZQMm1uUDd2b2NxcFgzOWRBQmo5?=
 =?utf-8?B?ZldOUmNoNG9peFNkQy81WjJMN3pldWFHbWtTNkV5aXV6YVh0a3kvQ1I5NlJ3?=
 =?utf-8?B?V3ptSXhpZWdtc0JoSzBCeWp1WUhaTW8yMFdXanhmak05MnZXWTNLeUE3NzNa?=
 =?utf-8?B?S2NxMjNhM3AwTXlHUGhwMzQrdnJBRjN4KzE4c2xxcldmRlJQTmViNWN4cStn?=
 =?utf-8?B?U2NhV2lKMldiRzFUblVHa1NPNDZhcE1mclpCeXRXUit4eXd1Y1hxMytjMFFm?=
 =?utf-8?B?WWM2RlNVRkZ6SXF1RFZwMEt0dStCRDB6ZkJ1MXBsKytvem5mQlJhUHU0bjlz?=
 =?utf-8?B?M2JNbnk5bUVwaDc0YTQ4WVpHMXFWa1N0Qms0bFZTOVd0dy9NOFBhbWRsSGJK?=
 =?utf-8?B?OUFpbk5wWThNRENJQWxVajBlcHNFM0JFLzVNbXRnSm1TY3Zza2RyOGNFY3BU?=
 =?utf-8?B?dldybllQS0QvRkw4VXZiZDNsZzNNSjVhWXpLVGVaWTdKYVFDRU5YMzd5dXRR?=
 =?utf-8?B?ZEw2eGtEMUVob0xqejh6ak92QXIxc0lFQ1hlODlxN1kvK0ZzbHZGNlFBb3Vy?=
 =?utf-8?B?V2ZiRUx3Mkc1VmtwbmUrK1NOYURLd3JaWERKSVp4dTBBd05FcWFHTjRIZnlP?=
 =?utf-8?B?Q1RFRzB6a3dsZk85VHpYZDl6ZkZGMzRPRUVSSytzdzR6bCtVUFJJVDdMN1lt?=
 =?utf-8?B?elB1RHJEUERBVTlEYjFUSm8vcFlLT1BUUnZFL1h2OXA5NmdiYldTV0gxQWNh?=
 =?utf-8?B?QmFhUEROblk2RC9TRmJYYUdNUzN5R2JMakszMGNGakswZ1Y3akczOWE1Z1I2?=
 =?utf-8?B?RS94ZDAwYXljOEpQY3lFM0pUNEluS3FTT3dWajdFa2twMDVDMVBycldOdGQ2?=
 =?utf-8?B?aUVBVHd4REJpam9Jallsd3ZueTU5S1gyY2FmeXlaYkFZQjdEMWZhVzQxZkM2?=
 =?utf-8?B?UEpBRnJlZzhocUVwZVlQbklCbUVvSGMxTUFQSXFYeG9rT0hra2lsRzNrZ3RU?=
 =?utf-8?B?Z3h3RTBzSFArNFZ0NWJCZFlmUlNaaGZhR2pKZ3BZUnFVVHJmZEJtZ2liYWdL?=
 =?utf-8?B?ZlVuUUliNjhTYUxpNG4reklDQnNvSE9ybVU2ZEdpWElLTXJwbnRvVTl6V2hq?=
 =?utf-8?B?QTNRYWJqVXBEUUR5dkRsUU95TzRmZDEvL2p6QnZ5QTNGMjdtWTRvUjU5b1Z1?=
 =?utf-8?B?QmtSTGJUZStuRndJM2htK2Nvd08wTWZmM0dLOXJFeEJnbFNuWE1rMTNMaUtN?=
 =?utf-8?B?STRIL1ZRam9jU1dJRHBWQnVCMEg0SUpuSnNhOWlnRXUyVk5DeUtQeGVMRElE?=
 =?utf-8?B?NzVVWlhMOUkrclQyT2k5cUc5MitMa2crNStKblFsT0VmNmI2eWt3Y1NPSk45?=
 =?utf-8?B?OXVzOGI5dG5OOFFnM3JhM2Q3Qk5xQlAyM0tiQ0lWbmlpVTJ1dlV0ajJseWRE?=
 =?utf-8?B?VTZuWFc0bGtvSTdQRmYxM2RvS01qNjRwc3FNK3VvaTVUTEZIeXpjWE1QcmVt?=
 =?utf-8?B?RWswMGFiWnRZQlkyYXNwVEZzazBUc0VHTmRUaisybWt2TDgzd0JwRjhuSVUy?=
 =?utf-8?B?b0FMSnVSVmQwRmxBam1UdlgranY3clRnWVo1dlMxZ3cyWlNGTGM3WUQ1YUxM?=
 =?utf-8?B?YmdpRnpJQVNGQjNiN05WZz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Skpxckc0Q2RYNHVoeStRbWR3eXFESmVyKy9qdnRSN3piYUVvSE1BSTRHZVp4?=
 =?utf-8?B?M1hWeVUvVEZ4NjdPUTJ5WkQ1OStTeDFrMHA5U3dEZjFJTWc5MVFkcEZoWmp4?=
 =?utf-8?B?bXdxTzFqdEV2MFI3a3lCcXhKOGlScXRGQ24vcUlxOWx5OWd0NmNQOHRVVi9o?=
 =?utf-8?B?MnptOStGc1JMaE5xRkdtVzdJQnh0dGZ0T3gvWXZFWHEvMWtwQTNsNXhZSnBO?=
 =?utf-8?B?VDhtMHRwSmpFTVZDMDhZQm15UVpTaE1IN0hPQjVOMHdjenlwMEhXRGpKWDdq?=
 =?utf-8?B?SElYa1o4eW5YVDFVdlJkb1FVV3NGQndGZlQrK0lXVkRCcEJEbzhFSm9DUlpC?=
 =?utf-8?B?Wi9kTEhVSGwzWThFSjB3bjQxQURYYkFWSk5SQ0FCMklBVzJhK1B4WGtKbEdv?=
 =?utf-8?B?T1RudjFvWVo5bUF1QVpGVTFKVDluYk1IcVFqamt1MVRWaHpueFk3RTZFV09u?=
 =?utf-8?B?cGRWZUtQak1uQXF4bXd1RTErdDdqWVZSZ1dCakpYWEVlNW9RbHpHVkhuRlht?=
 =?utf-8?B?bFR2V2pma2szYTJmVS8yQkpVNUZPS1pKdWtiRWNUazF6eldCUDlTRkFYdXlx?=
 =?utf-8?B?bStXZEZaM3gySFdRRTkwUUhQaTRNQTUyTktYUnF4Q0MyOGZ0UHRzNVFFajd5?=
 =?utf-8?B?RDl6TzUzUWFHcUlaZDM1QkErQ3lqSUZTWWFPa0VvUGRUaFI5YUR0aWZ2WGk4?=
 =?utf-8?B?UVcyN1FWRXlsdkFJajlnc1ZCYjN5RytQTGg1K0xGcWJyUWIvRnUzV3hQUFla?=
 =?utf-8?B?dG1NRWRxT2k1b0lZeFFpbGUxSjk4UUNjQVFJYi84REhnR3R3eDUyK3JhVWw4?=
 =?utf-8?B?TXU3Z05ERXI0K3ZEMHNlZHYwMy8wcjVZa1dzdzhaWmxaVUdPZGg3MjRUb2p1?=
 =?utf-8?B?MlpBUEVaTi9MVnhlNUdlU2U0WG5PdTV1MnZRYURHNy9uVmtESVZZYnpKTnBJ?=
 =?utf-8?B?ZDN5dmlTR3I4em9VeTVsUTk0Z1duWUpPZkRhQUFnRE0zY0tTOFN3WEFTcWJR?=
 =?utf-8?B?aEsxU1dYR3ZoS1IyQmVoMmdWdnE0ZWUxUVZ2QWZHRHhBbGRzUDdwR2V1VjV1?=
 =?utf-8?B?V2hoN3FjQkVqQlpwRGFvL3BodjMyZnBqUjFVNDN1bkpFOC9iQWZVUzcrM1px?=
 =?utf-8?B?dXB1bThyMmZuNGQ1STZ5U2FvVnZob0tXNFBYeFVJakNKQ2RUMDI0SytOdTBD?=
 =?utf-8?B?ejhST2h5cDZkOVVqVFdSNWJTalpKWkpLeWt5NE5FZ3JRSm41anNXOGp4Z0Jh?=
 =?utf-8?B?Vm1tZlNydzZKRFY5UDR5bzIzKyt6WW9LSmMzZW91N3lFMHYxS2pES3ZkcnNO?=
 =?utf-8?B?TVhKazFaSVV6RTVqUzZWNnZ4WWNNbHlBUzdaUWFYeFpER1NkbVZseVkzTFRz?=
 =?utf-8?B?S2MrTTN5YUpFOUpqSzZreFhKWkVBTFZncks5UUJWbmZzb2IxUWN5TTRDdkds?=
 =?utf-8?B?SGhMRy95UHllUWlacDBYdU9Ta3ZPWWZXK1Rld3NPYktxc2FLT3NyZHJaWXRZ?=
 =?utf-8?B?bFFhM1BqMDNQamVMbVlTQUpWK2VIOEpBMFU2ZVdLcHEzZnVlVTBzRVlod3ph?=
 =?utf-8?B?OS8zMzI5USs4Z1Z6SURHZGJXZW9ydk1oYjI3Yk1PUHR4RE51OUJSQXVNb2dj?=
 =?utf-8?B?ZlNFR245TUJSdEpDZGx6bTlwZXVUK1cxdTNNTXNUQmkzU0JEMGFEWFIyWFl1?=
 =?utf-8?B?MjJ2YXg2Q2VPUUVZQlhJeUxiTnE3K3JSQ3ZodWlrdkhNMXQ4ajYvWnJDYjNi?=
 =?utf-8?B?eXhVQWl1S3lmeUFGbnBybzlIbVdoclVmT09XNkk5YmcrSmE2WGE5ekN2aHh4?=
 =?utf-8?B?SmNiOEF3eHlYa2ZLZXMvU0RUbHpIMzYxcUM0R1NaVzVKWWFhZHBJSGdxVXdT?=
 =?utf-8?B?UXl2aExSVFpqYXYzN09WNkhhTVJBTHdMdUNhTEZWTzdpNGhqUXBlVGZyb0tx?=
 =?utf-8?B?ZGVlOHpUbmtRbE9vcWZXZTFQb0RyaUNaVzBXSmFvOVd5K2laanlQMmhuSW9i?=
 =?utf-8?B?V1Vkc2RiVityb0VGUGhkalNxN1Jwb3dqMHZSeWNUdkZxVmVWa1g4OUZZY2VO?=
 =?utf-8?B?d0NSaTlRVmw5U3RCNndadndkVFRJY2JwcVlxaEpST0RQNDlqc3EveVpIdUZs?=
 =?utf-8?Q?XxY2tAvHzpwL9cWzMpLOGw2OB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	gUMjNSntbifJf04UybZXXrSMCUmYmBYZ32gI6LP0jMPqbv9/JJ48MzChi6pppRkVkUTJadMg/DggvaZS4fESP+XglI9e7yVAsbBZsE5ZCxrEQ5Jm/j3h/Mug2mvaH1UJUzEPBNaLcUCeM4oiQH41iooA1ns2IfTVdrm7RGX4Ol7Pf/bca7grmVxaoFRYYhFD0AoG7wjAjOtTJyrplgsELH+Ft5po1uYgwzLS1vCMzbnH3DqzWUx4jGITeKEvCm8d84WmXh55KoIj3xW/UAjufGOWNLmJ2jcPFJSf/KKTlLuSX7O0S1KEdgzvWfdIjIpYVLm6roXVDjseLcKMPmDSXd7jsTtofyraS3+RbrxmFUmn/ChpdXRudAjIZt5Ly/kxf4repMKfJ3Pp4y8GCt1Jgk87YhXKmjFiem8Y5/hRr8M3s80H/04xQWfPMJssGGk+O6G0vBX8e5Gs7GOUZ+/zlY04bbcBJfMnl5O5e0vFB1nNZ1ziXcV1c6a3EfMSJsNc+Gma0JJxA7yT9EXQoAVjUQtcjtwYLUNW1TrdKsUcHEg6q82Jdg95w6sgvIrLttPYzFPdYe+IpUDIWjovKlKQlBNJReRG09kKav0AfZeCtMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97964e1d-97b4-4198-63c0-08dc9b47c3b2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 10:06:11.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TtRD7lovawfVt9aha+rB2x6lAWa7Pzg+al7VxyBjcp5foL4Tzy6l26AYiIiPwhjeAZdv6yFAm5sKkI6B02uug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5889
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_06,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407030074
X-Proofpoint-GUID: sifCkBfmdktSdd_kzjj3iPwoAe6m5L4n
X-Proofpoint-ORIG-GUID: sifCkBfmdktSdd_kzjj3iPwoAe6m5L4n

On 02/07/2024 17:07, Niklas Cassel wrote:
> Remove useless wrappers ata_sas_tport_add() and ata_sas_tport_delete().
> 
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
