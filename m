Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A430258A;
	Wed, 18 Jun 2025 06:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750229378; cv=fail; b=adyobhQn/l6w1mkvYp4VIk9nHSmoZOGXit3+VpH3tZ2sF+sNMU35+S4m/MAQSg8n0SnVEr4YB7BpKkQrcHNeIWypoVOWm1vOp0BxvA5sjFwHBaA0euyUuk3a+svjz18I4R2qlDdA1hp+HXWuEOHeV9HWWKnH4l5ansq0f41R7RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750229378; c=relaxed/simple;
	bh=oQbvnazYYR+rlQ3lXHboDLdMYTL/IK3m0r4OCwUEYk4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H8e8UK4dF8MzOaanZzsSQ1gNz1YUILdJb+gFptj8RKVb7u9uMX9zs1InlRdPQsp2wKtxab9GW6o4n1+sYwtpCp7CkglQtfMtjx6f4T7XHLwW0XCAWI6McYfg/pCIGWRco6/1ReYqTom+78td7CeJCpTS5oDDowIkS8C/9lF3FkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ibb2KdwF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iGQ8mq4b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ibb2KdwF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iGQ8mq4b"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I1twCw028449;
	Wed, 18 Jun 2025 06:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qYeW5NjUWB9e7ia81Zmshpsbgj01He4XNvd7gdvYlfM=; b=
	Ibb2KdwFqV0kvJIoVyTyL7y5hUvxHPFnVl1oxqIJTvrJLBDU//RMkCziCk6gw5nx
	tCeBNs5IrgWJcAYtU4JQc9Jcp783hG01l8xfVrCg/35fW9m1Rf/QADjAjqWSqOGk
	KXe+NLmu54b7IgEHRac4/L5QjDcffHYNNqt4v9mn1VbuC5Wr78kNp9dePiI1FxHd
	gqUptUal6TVBfByj95XChpjDZcpqmjz4mHDdb6P/1xwW7Y6zVBLUEnCNOd1nT9JV
	9cX136AgsGI52UlKgkHEYBkeZu4NmkXGE7VzmI0JOjJYicET+U1ji7SjkwrDBzfS
	f8yu1IqQl4UX85o1TD67kA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yv5721g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 06:49:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55I5bCjN036382;
	Wed, 18 Jun 2025 06:49:28 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhgrnp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 06:49:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkyjPb87En/I3oRYzHaC0lqhwI71OoZNNTbPRUVwSmAb3uG0b3jdxTz6vJuYHeiIHX2C5DxG1r9DskQYZJWnQ7P/yufswJelA+BajE6uFeH+raIxtf4tO8FPRVloRRWcl1zABS/MmynhlLVSa207A3TcTc6YM3+Olkwg6RMEtw1sausRJFdLj3yY8k5oqOQL9o7+lWj+NBcshSZkwBb2JpIhMJwvz17/44YHrU9rRbo73wDNOuqBAiqCf7HMYVQa8H4zrzCLP14pElt+UNuTwvmdLR5GN/WJJZswNa+vXKlzr/0MAVJQmrFc2SeEEVBKEVIJHjvJ9h1+a+dtz1vAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYeW5NjUWB9e7ia81Zmshpsbgj01He4XNvd7gdvYlfM=;
 b=bIgBjWDdxJcEnKyRUexuUt8A90cZJs1ddsimYtA4HpcJ3RMAB66+sYExrdmKqsyaXeOUYZ7F8wuAV7i9hd8WVQEMcnsfP0bdzpRiAZ2YU3dDcLFROo4/jRSq4o1zIQ1SEm/svKP6GCtARGHi2xlXRGFd1iN5iVkEmkS1q3xym6xTzHyxlJWN/u5jRGLQtwXKMT+YmbSSPab7CysVcpop1wnRsFJ9kXdFqKlNTH1s+AlI7/mX9F8CHLzi1Z/lxSpPWZ3dJfXdCV8Tm4KCFdscEZYBKHh/DHirfLkATU459d5YAI9nroM1G+rI9ileQ85OMmiWiaogRC/wzHE65eMm6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYeW5NjUWB9e7ia81Zmshpsbgj01He4XNvd7gdvYlfM=;
 b=iGQ8mq4bD1AuMRrYjp+PpeA0a6TLxtnMB46Kq/VjkU2oWwUc5L7wuRpizb5neEjmth/dhWK28DCbr3hCY1la2hhsdaDQO2IMdBrbBWZUIbkVvlAftXnpT3eVbHtKJ/hluBqSVUDAmikH9L3MVC04N9iGEqkGFSPC5jMb/QYIXas=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7849.namprd10.prod.outlook.com (2603:10b6:510:308::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 06:49:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 06:49:20 +0000
Message-ID: <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
Date: Wed, 18 Jun 2025 07:49:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
To: "Sean A." <sean@ashe.io>
Cc: "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0256.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7849:EE_
X-MS-Office365-Filtering-Correlation-Id: e00cc1bf-096c-4c23-683a-08ddae3440b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXY1YU5tNWU1aEIyenp3bDBYdHVUWUJLL0Z5MnJBemU3bmw1MTFXRFF1WFpK?=
 =?utf-8?B?ei9zTnVLNURtNHZrRHdGTHFTSjlQeElleDAyWGRwQjZPem9zUXJjNHZiWHFj?=
 =?utf-8?B?WUtqMnVHS0I2THYxU1hyMGlUcVE1UFBuZ1V5SGxwT1M2UTcwOGhaK1ZlSVFO?=
 =?utf-8?B?YlBJdklzMHRNaGNHOGM0YzQ5cVpIZmxKeVZnSG5hdk9YRnoxNDRDMS9jL2Fq?=
 =?utf-8?B?TzNaMEUxWStEeEFtb3J5SnF1OVJweG14M2hqRGN3bjR1Z25sbGh4Q005TGZx?=
 =?utf-8?B?MHErWUpIZzUycnpjd3hEbVprZ2VaaGtMU052VkFiQjl6NnNWUmx1UUEyd0l2?=
 =?utf-8?B?TEZIR2g5d1FoMjZDbkxYU3hnNjdvbzhuNHlMa0hzNDlwbzJ5ek5ON2g2cnMx?=
 =?utf-8?B?VlFleGQrMTVnV3JGN3k4Q3dGZXBobEpQV0dITmdMKzVlT3kyWEdlamJNY1Qy?=
 =?utf-8?B?UnJ4Z2FZM2I1dEFJZm4yL2g5Nlp6dElLaFVtUkZQRVROVkNMVTI3dU1Ddzly?=
 =?utf-8?B?V2p5cTQ0TWlqeVZCVE1KOVJqT0t4UGord2xac0VRelNINlcrSmJOSzJJZFdE?=
 =?utf-8?B?S0ZzYS9qTWNFbEQ4d0FGMjY3bksvbE9PNEZpTmZ1MEZ1Q1huS1JPUGRQeG9l?=
 =?utf-8?B?amo0eW9KZWE1NVRCdUJpM1hOU1RaK0J1WXh1Vm9vcnNyditCbmxKaU9SNUFx?=
 =?utf-8?B?MXc1ZGZaTzVhd1FWMElDSXRYbEJMa0pUVFllRXNoWFF5WDN0bmhySCtCRnRt?=
 =?utf-8?B?OG5Rc3pRVHlWR3h3MDBHUWUvQzVoNmNSMW5wQlRiYlJPeXpIazBaMlFyTmRC?=
 =?utf-8?B?NjIyV1doRm13ZWdrbzVDUnozUVdRVlp0QjdBWkxaT1ptSGFWT2xDbVpROE1N?=
 =?utf-8?B?Rmg2M3ZZU2ZOamJsZVppNWpTdXRRd1V3Qlh2Y0ZVU2RXZjQrL1JuSEd1RlJ6?=
 =?utf-8?B?U3pGS3BvRnZiNHhSTXRLTXNPeGlGY0xNRU9iTElVL2lwM1pLS3BvRk04UWJW?=
 =?utf-8?B?b3R6blU0WmxFKzZiSW12dEZ6dkMzOFB4YW5XQXFNTG1rZEtHbHhGS25zNU9m?=
 =?utf-8?B?YlZtbjJxejRTM1VmejlXTzBKMFdHQXJzSUY1QzNEcEh0OUJXN3M3QlE1UHJN?=
 =?utf-8?B?cEJvWldkbWUzNFI1VDBPdmZOOFd0RjIwRm94eDdWT3VSZEtzakE5cGtHMXNw?=
 =?utf-8?B?ZXJJaUl2dVJXV0FXTVBKN0VJTEFGQjZ2cHZYSURWR0ROc3dmc09aaWxyVzd2?=
 =?utf-8?B?UkphZlBXaEtYby80STEyTEFNcDg1T2szMy9DR2ppWXA1MEJYaUh3Si9RZlNj?=
 =?utf-8?B?akFSMXpwVnJYR2dKVHhBdUNxc01jcGJ1VklOa3Q1VDlxdDFVV1VLeXRGZkpa?=
 =?utf-8?B?VExxSktjNVNpcTkrVkFhTHZUNjBUcmpQbm9XanFKbDQ1V0N0MTJwRjRHall0?=
 =?utf-8?B?eFB3Ly9mOW4vaG53bGd6VWZYRmttZk9QRHViaWEyWm9aZXV5TTdibTFZL2Z3?=
 =?utf-8?B?YXkrZUV1b2hmQlZzaWtaVG5Eb3M1NTVWRmo1bXMvSHdrZ0loVXlJeUYycW40?=
 =?utf-8?B?Nm1XRkdJUFJWN1gwbG0rWnB4N05veStXS3ZEOEt0SWhJNCtVSG9jM0VXNlVO?=
 =?utf-8?B?a3BCUlgrVTZsdCtnQ1lIZE9qWTl0QkJWUFpaTU9CQnZIN3h4NFNyN0lnU3pa?=
 =?utf-8?B?eEJFcW9qWnRJdkt4dTRFYlFnMDRpY2pKWk80YVowRUplcjZicGVscWJhRVAw?=
 =?utf-8?B?OVBDVjZna1hKQVZ5eU5YQ2F3TU00K3NwM0hneGlZeEdJK0NZMVJiTkxqN3pl?=
 =?utf-8?B?bHlmWSszY2ZkamJ5M3RhK0VRWnluSXE0bkxkMnh5bW9HTUhDUGxFTjFBR2wy?=
 =?utf-8?B?REFhZmNCRW9zNm80WGxGYm9MS1dHeHZtaDhudEZNWVRyc245cURXZW1Oa2VV?=
 =?utf-8?Q?gVhRDUYtwhY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEw4Q3VPL0d5NXQ1S1BDdjYyQk5na3lUMWU2ZkxTQnhGb1dSNlBxQ2dwYVBG?=
 =?utf-8?B?V0JzVHppcVV4cmR2L3Y3dnlnNlk3ZGViUGkxQkN3UlhQZlZPbWdLZnJHc010?=
 =?utf-8?B?MzI5UlNXOHQvZWk3dmE4bjlvdDJXSDY2WThwNVBIR2Z3azFISzY2a3Nrc2xP?=
 =?utf-8?B?eUR3Tlk1NCtrdXhzem5TSndNNFRINGJCWmZwMDlWMHhXVW5jRmhrWmZKR0Fu?=
 =?utf-8?B?RG80SFlXVmw5djFpUWEvVnMyTnlUbmJxNjZuNUlWUDJhcXVWMEVnemwzUHp3?=
 =?utf-8?B?R2UwZWpKbTZXRnF3Rk1XOEtrU3VDSjI1WmY3aVRybFZhcWlmamdqaERsSjlj?=
 =?utf-8?B?TUxpME5leGIxQ2hyVFQxUEwvbUttK0FjWHBscTZ5eEpoeHlub1VFTXRVTk1S?=
 =?utf-8?B?V3p2M3ZyTlF5eEx4S1pGM1c4U2xMSG5ueWNPRDhFd0FKZ0tQdnF3V1V1VG5h?=
 =?utf-8?B?ZXp1OTlHOGY5MWR4ZFJ4UDg4cFlSdlhzZHI3aTZQM1hsT3QrSmJZZVRrMmc2?=
 =?utf-8?B?U3FvU0lvWVNXRkpoYmFzR2ViWUE0QXhOQk9MSnNFK3Jjbm9VY09hb0dtQkhB?=
 =?utf-8?B?ei82YWo5RXg2YXdseUdQbkFTSW9iWFZjaXlRREFPenR4THNZeTBXbkdseXdv?=
 =?utf-8?B?dTR5UzFtWHJwN1ZESXVDNXJFWXNudEdYcjM1Vmd6ekp6Ti9pKzBIbi84YzFT?=
 =?utf-8?B?b25tTnp0MnlQT1VBWTZVcng4MDJZVTNjeDJQZ0lmRUl0RS9ldWZ0LzB2SnFE?=
 =?utf-8?B?R0JQNTdTU01nUU4wOE1TdlRBNzNZcGVoWXZHbWFuWTNhTXFQU3dUd2F3YmY3?=
 =?utf-8?B?Um9UcW9SSmJ0MHdVeEtTcjhRS2srUGVXSkpuaEd6REpodThSamI5YXJZby94?=
 =?utf-8?B?dXNQNkE3TnFiOEpNckVuYVdlUE51R3hLS2w2eHRLUjlrK1l1UDRXSVBlRUlr?=
 =?utf-8?B?KzBBVzVLbXlLV04yYUw4T3pmQnBidndCVjV1NG9ibTJMUkswdy9raXpLY1JN?=
 =?utf-8?B?b05hUnpVcWFkeCsvUWJwOG1qcnNOSDNyc1VqQ3JJd25wV2xzaXJBNW1ZY2Fs?=
 =?utf-8?B?VDQ4YTZvSmtPcjNxUHg0WVAxbE5SQlpqV3ZDeXJXRjhJUTJvZDhUTnB5VXZ0?=
 =?utf-8?B?WmlzZk84U00xQ0tuaGhWMS9TSUYyZktJZEN2UkxEbDdjcU91dG9hM0EvRGYv?=
 =?utf-8?B?TGxhVU1nZEtTT0NpajBSdUY5Mm9hRUUrbU9XVzlHbytCVFZzOFZiKzFXZHhQ?=
 =?utf-8?B?RFZ1UFIzMXNIWUxyRFk2MFpGQjdOTndvSHFCSmtscThhT0pucjVKczBzOWFw?=
 =?utf-8?B?cEVsTkNBUDBEditXY0tJbm1mbjFaaDZLVVVQaFF0Mnc5d0YzRVpadmI3anpY?=
 =?utf-8?B?Nm9NTUxvZzBtbHNQL05KV1JFU2hEVzFma09RSEc3U203eDFCaGdqVE04ZERh?=
 =?utf-8?B?b0daQ25NSHZsQ2lBVWEvL0VXOWQ1cUQvSVF4dmdkYjhtUHJUdFlwdFNDV055?=
 =?utf-8?B?Y1J3azJjQ0Q4UmJBdWxYMTNaWTJDemhTd1dTd052N1p6cTQza3pCWGQrTG5Y?=
 =?utf-8?B?eEZLTWxyRHdnTm9sSlNyQyttR1dMTXBybmMrOUhQanZ3UUl5b0xsU1pNM2E3?=
 =?utf-8?B?cHhEY0ZXVWdoTXhNUTU4Nm1hZHVvdzJhbHZuUU13Qk1nUk5vYXg1elBYMEph?=
 =?utf-8?B?cHRXSWo1cUlRTTYzTHdJbXFydVhLUkR6b2dqQitxdEhRRU1qUVVoOUt5REhY?=
 =?utf-8?B?QTVvMnNmVU9aS2RGN2c0VHNROEJBZU1uN3QrMjdORnpZcHZrMjZheFl4ZG5k?=
 =?utf-8?B?eWNGbUtNaisyYmtLR0VEL29YY3FJMTk1MTN3dE14T04vNEg3enVQa1UwbWJ0?=
 =?utf-8?B?TTlQQjVyOFhBNkhoL01uRVpIRjNtT3dCMmxUbGNnK09JZUI5T3VDWFY3dUZE?=
 =?utf-8?B?Y0N6YUFxK2VNVUN2Z21yYnRZWERXcGdkUTFEWWRuUnNCWCsveU9DYjNjcFNr?=
 =?utf-8?B?WHhIYU1BTk0vZWd4V3BpaHg4YkFpc0ZNUlZnbXFvNXdReCsrZEk0RFZtTmJE?=
 =?utf-8?B?cW51Zlgzc3c1MkovaDU0N0VabmVBb09NRk1OTzgycENQa01ha281RlJXb1ho?=
 =?utf-8?Q?6rmIWQaCsYpqeJEpPiCIvanO6?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s8r20CbnmIXoS7bFKPTt8OS3m9TeTZEim+lfNwCBhX4scOETf3T9pVDtXjUVGdjPh75c1vniMfRwYGXR//OmzorUP5RwEJPjf+RKm7xvGmE3Fe+PtPS708noYmvm1FJJVmRVEJC00bF1n9Jz1s6MJnM7ZZTLMxcDFwV9XQrI1N85A1hKq71NOhkJKBwj46XpSwe7uDzGjqv5MZUxFHZIr5it1XRRJv5Yjsh+Izqor4KvSa87Lya8/1LGCXGeN8nqeKgaDhvgnP6ZeYogwaB6mRRwB0YaI4X4O2e2H5s0a6beionGu3niN8S/kPHbQPUC1kmPds6wKRbV6BunH1JXJ7uiUphTNB8FN1BZodNG041bXnaYlL0i5M5nhvt6fjYOCrHgQpMy3exgaYxCQucqN6W+BlLiq2iuUVq8jUa/kstI3TIn+Nwobd1H1SyKNImZjIlpbtihnp9naKgBIiJ+rkSN7TIY9fa38I/atUHvFegiVq+vkiZ5lmErT0wFU04QOQx8jzeTf+3tJxnfhQIhGm5M/VkldPtn3js0vpkSIvj2srCusX/CPXbYgz0srKEeF2H6vDE/URowmdlgK0iPUUX+uUpmAtwJwrNnbbhXip8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e00cc1bf-096c-4c23-683a-08ddae3440b5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:49:20.6040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RoXEVV1eJnHP6nOLlNYKOGzmig0J4BYPXU0c/Xm4r8B7ymUzLt2NtQ/+/D9TIclHMxy73NOak6djLL4sGP7CPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506180057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA1NyBTYWx0ZWRfXzDoSM62kD3Ou 55jeMVch+wZbiUY/bBXByj3CoDyPRVWQSy4U5ONM0AbwkZ2CK2TQQe8erZfJZSQYv7hF/d5PHEq dZI/k4/11XwY8N6ianMip6j/t8vgRl33aLE9RSnM1ZQ7Oxx90BTJaDdnc0uBDqbveWApP7Du+y0
 NSeuHp3BNXtPC25WstsPFqr4IxacXWYkLXxNS3Vyspn76a+gQa8OAJURLIKTfu05FpbmP00Ayss JT/sPfnfG0GCGNwNuBUCICdowN3Q7F+lu522oc7+UMxHAgI47mfa4+8VAXvu+vL6QdVuM/sx8o+ 4J9qCD2vp17R/sVKLM22b/8dZ4x+rMZIHXz9yCWgx561jJKyet4m/CY50MFBcPZtAWgDfinHWWK
 xcag2/ImjQAyS8Xc9JB6Gh7e52p4/6hvIfFLzfpI2VWL0lps2yz6LLgcRtaLFNWyTS4EwtnT
X-Proofpoint-GUID: 8IwL4WG72wZ7yhnhG41Z-y5Agst6w6ih
X-Proofpoint-ORIG-GUID: 8IwL4WG72wZ7yhnhG41Z-y5Agst6w6ih
X-Authority-Analysis: v=2.4 cv=W9c4VQWk c=1 sm=1 tr=0 ts=68526178 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VqnRvCtiyri55oQ9m_MA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714

On 17/06/2025 17:34, Sean A. wrote:
> 
> Le 17 Jun 2025, John Garry a écrit :
>> You have given no substantial motivation for this change
> 
>  From my perspective, workloads exist (defense, telecom, finance, RT etc) that prefer not to be interrupted and developers may opt to utilize CPU isolation and other mechanisms to reduce the likelihood of being pre-empted, evicted, etc. This includes steering interrupts away from an isolated set of cores. Also while this doesn't result from any actual benchmarking, it would seem that forcing your way on to every core in a 192 core system and refusing to move might be needlessly greedy or even detrimental to performance if most of the core set is NUMA-foreign to the storage controller. One should be able to make placement decisions to protect app threads from interruption and to ensure the interrupt handler has a sleepy, local core to play with without lighting up a bunch of interconnect paths on the way.
> 
> Generically, I believe interfaces like /proc/$pid/smp_affinity[_list] should be allowed to work as expected, and things like irqbalance should also be able to do their jobs unless there's a good (documented) reason they should not.

There is a good reason. Some of these storage controllers have hundreds 
of MSI-Xs - typically one per CPU. If you offline CPUs, those interrupts 
need to be migrated to target other CPUs. And for architectures like 
x86, CPUs can only handle a finite and relatively modest amount of 
interrupts (being targeted). That is why managed interrupts are used 
(which this module parameter would disable for this controller).

BTW, if you use taskset to set the affinity of a process and ensure that 
/sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU 
as submitted, then I thought that this would ensure that interrupts are 
not bothering other CPUs.
