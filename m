Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FEF2EDD58;
	Tue, 18 Nov 2025 19:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763495875; cv=fail; b=BSR1AlQ7FFLazZflsNs/OVZPi+lFymL9rQa8Y12Ea4t5v4VlVusKVE/o9qNxHAP0CYsg6DL5/KfPWUoQcXuIYIbM1deyMoWF3swckz8UubrQJIFyJP8+pbP88wNZBRiqT4v9Z6BfRxr6ov7uyexXpwoL+KfC0DHZfjvAC8IzfXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763495875; c=relaxed/simple;
	bh=p8FWlk4A5lo8GxhknBtMHrFbZHwHojzq76NXPAWo/J8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pc9i/XMcT8yk59/D3mUSLlclq/kzR/o7A2AVTzVBtBafq86frbyFM6fsdn7wkYTc7GDAcztlbG4j0a2PhEowAOET7Jhplncn688vS+QgeVErEy1s2in8ZjjuYOnVm8L/Lvji+6upBKJUwYvOBa2ZhSRiH6vtLxRAkqFWO3MfNxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AUF1tRsF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JWK3jD48; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AUF1tRsF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JWK3jD48"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIHNN3R007992;
	Tue, 18 Nov 2025 19:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kCm32RX/zD8J6fgoHlmSYafdpuIgPiuE4xLjKMR91HI=; b=
	AUF1tRsF1TbavP5OnJFAnEJ0gvsKb/TJHF+th0gi+d4TnmrbnvVm0DrZmWozWmfn
	k5q3D7LiHntdCKw9ViM8u3D2FSwpctCOd+lemMfIFY121NzrFVKt+w7vtVduumDF
	LYpOq615yEDbab2GP49RdsStyrkeGkTkobPIAiooxIxh1ifX+HZleH4aw0n4Nb+i
	o/mv5D0B9jW9Ag8lSylBx5p5Y0KhtBzEwiOJjK/1sXqsdi351ypnxYzcc5lxQEf9
	mbrzGQ5xL652yGuMWIhPyEigZ6a/amTxgu0q2Y8AoMMZVQycQ3p64UR9+R3Inle0
	JHICnS5dsqY7A+7cI8GzZA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1dhya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 19:57:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIIVJ4Z008014;
	Tue, 18 Nov 2025 19:57:41 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy9mesp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 19:57:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JxavN9NDj7UsSgA6XH/T1UjYCdk8PGOpUouu/s6kC6umbYXNTjqCnrn8uNGFHt3um3oWVTlLC2a+Nmws2fmzEk1hflIDeCG9ibFp/kAr/yaqYnX0CRRALRTmqu8X7TZLOQRF8mH4YzxzaGbe/9e5PUaBfroVuBJ5IJGXblZqbGVWFyWm1GjYnujnDmvjZGTeIHnclf34FOoak5x/mKHr6MAFjmzhNShe4JAiyKlB6bDPIb0Pv/NyDdFOC8l6d0trJS0AmjPDB81qUzBCaZgPBD4fUPvFzbbe92u3ulPc3Ez1JeBCN5sOys1bQnwoeyu8U4E0nRpZXoK7MqXWm3ZkZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCm32RX/zD8J6fgoHlmSYafdpuIgPiuE4xLjKMR91HI=;
 b=SuOQYOlPtMCjvcUyqmHUBfym4x/BZqNrDppv0JXHm3NYhMclqlkO+XIkGp9MKijTy3oa2LNZfK4+fxcu6n/fWWIknvlNClDGMiHGWA0n57FZoK3CkxR+DBVKNmHpMCzP8i1H3Aw5ESoI6LmPA5IzLwWXgbCTTlkyT8xmi34buot4cPCZ7CGoaAxZvRUx+gD3sHmyJ1RXqzSjqd8LcrrZYjTp9DPx7CotgeJXJDezu0iHfKSTwSu4uj2t+ryP/ieWh2wgTYIj4w3QJyvDwwX5lqSyiqPL1NsZxVIRj7JjSOxWsyxPhMVYglMCixOxi7xct8F2KiGK3ca3uvFGhqUZeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCm32RX/zD8J6fgoHlmSYafdpuIgPiuE4xLjKMR91HI=;
 b=JWK3jD48eewEbnwsTNOVDVTsME8biDgTCZU9YxaFhZrWeeNeyMX/h9hcc6dG6F9iZVZnWO0cCIzd6tOVM+T8oLjkB/0idIsnVsOTp38eaX7JESni2HCov70F/RVXvlr0zF8n0ONaSDwWnNTvOIakM1OeiXFqKPYGp21KOR0rJhw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY8PR10MB6633.namprd10.prod.outlook.com (2603:10b6:930:57::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 19:57:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 19:57:33 +0000
Message-ID: <d8d6830a-76f9-46d8-8643-69aec7ffb399@oracle.com>
Date: Tue, 18 Nov 2025 13:57:31 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: reset t_task_cdb pointer in error case
To: =?UTF-8?B?0JLQsNGC0L7RgNC+0L/QuNC9INCQ0L3QtNGA0LXQuQ==?=
 <a.vatoropin@crpt.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20251118084014.324940-1-a.vatoropin@crpt.ru>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20251118084014.324940-1-a.vatoropin@crpt.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:5:334::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY8PR10MB6633:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e107ab-fabc-4724-2e6f-08de26dcb69f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHpaQnZhMUM5NVRPRlZhMHZ5RWIyVGZWVkZFTUx2OGI2UzJvTDBMOStqaWtw?=
 =?utf-8?B?QStMeGpUdnN5UUJ3bTdJYzlZSktaL1dURGhMQlprOW5rZkNGVFk3VjFBZmY1?=
 =?utf-8?B?QjVNUjNlZ0ZyN2Zta3ZOU0ZsTllLWkVTN01mcmtXZkEzNm9qQ0pKekhoM2U0?=
 =?utf-8?B?a3RNVXc5dmsyK1VjWFptS1hmOERQb3dLaDJzeTgvM3RzTWVOTEtiSGdjaDB6?=
 =?utf-8?B?V1A0QUczU0xYRFpjYXhlVHVGNUdnY29qTldMQnRYWUhtMXNOeDVrWmRBTExs?=
 =?utf-8?B?QVlRT3ArQi9Qdm9uTkk1dWRPVzg3TEJ4YUN4Y08raEtOR0hIY3ZzREFvTG9H?=
 =?utf-8?B?SVBrR2Q5QW1RTmpJKzZ2YWJwWnY2bEpzUG9JYUplSnBDWXhaamVMYTFPNVlL?=
 =?utf-8?B?T2hqYm5nb3gwY3RRY1NmS0xxU29WSitOaVlOb2Z5a2RsVytsdzM3RGNKcVVN?=
 =?utf-8?B?ZjRHaFdWMW1vcHFZT1lrclNFbGpzcnRVVUxETGlnVVh5OEEvbGJlQTY2eG5m?=
 =?utf-8?B?ZDM5VkRFSHE4VzdPYW9DMVV5VFNOZlhBMUpRNTltUml4Y29lR1lTRHE2SzZR?=
 =?utf-8?B?SXJ3VWVteG9lb3NhdW9KbVJQYS9qeFJrUlJoQjZZNHhDWkVwaFpnWjJaU0ky?=
 =?utf-8?B?RjhBWGZQc3l4cGo2cDBTQVRodEQ0bG5adW5sellQcVRUZzRKaHdWbzVldzF2?=
 =?utf-8?B?OWFmam5wUmI1RHFTWG5BbXNwZVlsT0hMNzd0ckkrb3R3VTV4dmpRWHIzMUV6?=
 =?utf-8?B?WnJYUVNPMGN2ZjVOa2Q3SHZ6WVRiVFhzZ2E0NkpiQ0NqOXVNaFRZOXEwWXBo?=
 =?utf-8?B?aWFUeTB4UytZNGNDdFd3UHNWaGJCaVZGZk1aMHY3TGxodFY2WjRBazc4T09n?=
 =?utf-8?B?cEVYeDF0RXkrdFhDSUp1SGNOTC9xZm11YlNod0ZPRm5YVUpDaENVWmlvMHN3?=
 =?utf-8?B?V0VjdXgzVWZCcjZzamRicWErRjBiTFUwWlNhVW1qM2xra2M4OURDdmZxUVdm?=
 =?utf-8?B?d2x1NUg4M1FnR1dVWkFSeEVmK3J3OFg1cjhtQlcva0xZM21QOWw5L1daeEl5?=
 =?utf-8?B?UE94RFVwVGhpYkNGbG00OEQ5MVk3akNTeWcrakFReXFUSVpwTTlMY3duWGRh?=
 =?utf-8?B?Q2tOam02dXMyeVZ0V25FbGMzS2RiT1JUSHlzaFhvK2xoY0p4T2RiNDlGUVkz?=
 =?utf-8?B?VUdXMW84NkQwdUlYTUxNSFhlUFVNOTlnZzhYWjJKVDl2Ujh3aVZKNFlaWUhZ?=
 =?utf-8?B?MkFrRjdHTGl4QThXRlRmd1RMTWxyMXNVam9FZ2hPUjRKVHBiY3Q1L1R5cE05?=
 =?utf-8?B?d010bzRlL1Q5QWFPQlJrb1ZxWWZMOWxXZVowUXVQV2poT0hhWUFiKzdlUDVh?=
 =?utf-8?B?WlVDa2tnWFlZeHB4QWwvUE1pSk9RWXpvVGpORm9mU0tia2QvdGVwSlA2NXFW?=
 =?utf-8?B?Mlk0UmJBYUY0MTZzWGlzNzUrWlBCS1VnOXZmU2szaTVSNHZrZnZYN3RkTFpO?=
 =?utf-8?B?SXk2NzNteVhQOE1rZ1VXTmJvWEljN2hwZDd5dXRkWGRieFNNZXUvV2lZSTlQ?=
 =?utf-8?B?OEM3Y1FvV1B3REIvaUtiVEJBLzJaUGV6OFUzMGw2aXUvNTNpZ01OYlByYkQv?=
 =?utf-8?B?b252L1FaanQyN0pmYzhybU5LTEpkNmI2R204TUs2cWRkQ2NiR2xHUVd4cjl6?=
 =?utf-8?B?dG9nYVBkUnR5Q2o5Qk82NDMxd1pzYUdjeUZRd2N5eEpQWHd4RE5mTFRMWlc0?=
 =?utf-8?B?Und5NU1jYS8wYVdzanlWL2dSUzg0MjRIT1EyYy9GN00vSEkvRmNNUi82MFUy?=
 =?utf-8?B?b1lURHFXSHIwWjc2MVQ5VmE0VWxXWkxBYVNiYVlGa05oYTRKajRKb2NFV0tk?=
 =?utf-8?B?K0NOdGlvL1QvRnNTakcvT1RUdWtXNXZWN0RqcG5ha3RBT24ydHY4RHp2VFlm?=
 =?utf-8?Q?shoE691DG5eNYQtFfpbXrcMl6Xxoa9vh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG8rVytuMTQxU1UwNi9DN2M4NXV0UDg2YW9nZDJlc2IxblltTndWQ21laUhI?=
 =?utf-8?B?VTJqUThyeUh5bkRBZTU3dW5OODMrNlRMRWVjK2xDekNJcGM4Rng3N08vbjhS?=
 =?utf-8?B?REx6cW16NXJNV09sek5kaGJqV1lNc1NMWWllL2d1UCtEMUFwRStNUklrcnFk?=
 =?utf-8?B?RUpIMWNGakhaVnovUGw4YXBjN2VqZlZnc1o1cS8vbENxMDR1THFOZHJiNFdB?=
 =?utf-8?B?Y3BOczYzZjZPUWRiSXVVc0ZhbHZBcnNQcFF2cjlSY3FrYi9UQ1FmZU5wRW9Q?=
 =?utf-8?B?NGNWdUhYdVR1SEQ3MlRXMlhGQzlzSytzY2FmQ0xqZDFXUEhlWDFRUmdMcHhO?=
 =?utf-8?B?d25rMW5YR0pGWWxoenRURVY3eXV2NzdWTnNHTDhnVGVGUWhQaDVSem40aXFj?=
 =?utf-8?B?eU4zN0Vjdkhxbk1HV1RidjlSelNjK3kvT1ZVaGx6aXB4OUhIcmJpR2ZUT2sx?=
 =?utf-8?B?eEw0MElFYjMyR2MwYmxmNmdRYzV2b0xIKzdRaU5sTXp3N0Q2MDhsd2tzV1N6?=
 =?utf-8?B?R3lwdVgxTWl0dUZHemJ5aE5SMURMWlVjNitPQjFIVzR1d3FEajNsQVlxM0E3?=
 =?utf-8?B?cFZxRTdzV25IQXlPM3RFTU9hazhYdk9xeU5iZ0hpMjI0Q1RGT0tvWjJudEtH?=
 =?utf-8?B?ZE5JeHdQZnloU01Pa2lQOUhzQkc1Vzd0N1FZQ01TYlovWWVYRDRDbnpPclE5?=
 =?utf-8?B?YXZ1MVM1NkJod09GQVBBS2MzVFc1K2d4TlN0b0ROT0Nrb2JRQmFxeFhvUXZl?=
 =?utf-8?B?czJqYUVUSXlPZmdXbmYyMXNueDJuK0ZORG5CZ2htN3lWVnVxeDRHRjE1M0Nl?=
 =?utf-8?B?UXhiOTFmV2s3dEpEbjNyVmV1Y1o2RkJNa1k5ZFJzSG9JSk0vUlFNeGxxYm1E?=
 =?utf-8?B?WEpyV2paUC9WMU1GZ2R6bmo3akRKL3RRN3lYcUdLdFp3djFBeWpVQzJIcVNv?=
 =?utf-8?B?bksyU2xteTJTUGZJcm9sSzVJeWZqZGNCdWk3aHQ1UUhESXFNNG1xVnM5alJB?=
 =?utf-8?B?U0ZxOXJTU3lCR053Q2ZxMjZ2SEpCSm41Mk5KWG0vaEVsMWh6TmJpbUlVZEVV?=
 =?utf-8?B?c0plYTlxcjBxbDdSQlBlVXlaK3lkVnREazNRRXEyT3ZUQ0VTeTVRRUZ6cWtj?=
 =?utf-8?B?VUV3emRJeE0xQjJHL2VhVENjZzJoN1RwMmZldnBFaHZ1NFY2TE1wcWdyMWU5?=
 =?utf-8?B?MHdSRzEzOVQ3TktpVHhxdEZBL1o5OXRMQ0xvNGx6bUM0QzIvditCQXV2Tkdq?=
 =?utf-8?B?ZkdPR0M1SDBLWS9ScWhZUlNDYkVIYjF1NVFWRjdVUXhGYmMyV1RFelZ6aGVP?=
 =?utf-8?B?c2dCako4aWh4MFFWN052aFllU09tZlkra0x0VDlQcVE2RUxJd2syRkRsRys3?=
 =?utf-8?B?ZTdIQnFwWGE2QWl6Qy82T3FyTzVBOThmdElWdGVKeWQrRHU5N1BDQzB2MFJR?=
 =?utf-8?B?RlJCNHowS05LOG9zcmREM3FXVW9PRlplZUcrSEhDRS9RWTIwdEJkRkhCS204?=
 =?utf-8?B?UXNTM2o5K29hL3hLL052R0VxSFhxRlZJSlpleTVlamVwRkI2ZFVrT1h3Vm1T?=
 =?utf-8?B?U0dlL3JaNWdvS1lOZXRWUDNXQ2Fmd2JwdjErbkhmNTB5TUdEZnYwZkJsUzBN?=
 =?utf-8?B?VkVoS0U2WTVSd1F5U25oYWJtYnFCTm4wR0pGZzEyZjYwYnNCcDltMzI4OWt4?=
 =?utf-8?B?dVQxQ0tyZXFlYmlDdEwzejRpMnFUbnFvYWFMOXd0aFNYVndTWGEwdHFWZmhU?=
 =?utf-8?B?Z003R0NJRXMvRmhLTERaQkVXZWpyVi82dGFzdVVnWHZYOHkvYm9mL0U3Ymp5?=
 =?utf-8?B?QmlvVlpLeHNEd0tnOE1BV0J2N3N4TGhodVpLcWhIMjJUaDFDTWJieEQvWmlv?=
 =?utf-8?B?TE94cE01ZW5xZGxwd1BiOUNwRUZkbi9KUlpnbFlzS2FJSzU3U094SGhQK3Qr?=
 =?utf-8?B?RStEanB2Mk1vMTk0Nndtd3V6aUpqMG5HS0ZZaTVsRDdrTFAzRGY2UmQ3eEJi?=
 =?utf-8?B?NGV3VW9yTDVUK2ZhTmRsekdmdElmOUdyanpzUnB6Z0ZqKzZRdzVJZGV2RHBY?=
 =?utf-8?B?ZmJzakZGNEN6QVJSNUVVMEdKVjY2N1A0eWMvd0ZpU3VqaS8xWjdpWDZ1c3ZZ?=
 =?utf-8?B?WHF2U0g2Tk9CZm5pamlYRWhNdWhCeVpCMkh3cndWeGpGVE1FMW9FcEplNTh5?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xp+x9/CXkHgWZn8gaJvODxOr6mM918qXD8JfD0nRdgxVYLghbgKXi+FtD+hovTluu4ixAcfOeTVgLoIfiXk7YbgPqHLAKarZ/6Qi3STiE28+5ImNMiB2WyWzTsvzT6iGnphY2evJLpZSyVYvCliVKnz+s8c8EDR0B2e3eAUI18KygXUoGvKa/aDlBEAeLJ1QIn0Y6mC0V7nF1diT6j0JrCWl6N/Y9M1OV9PUmxc4/nYW9E+nxD7hNoJ6X54pi4DGnjpiMO5KBWsRGp6/6llIOd+cZecvZELURsA4PMrxTBIZmSAlp5VlpbPFLTQwDaIBxJ+58xH5dcygVAhpbKy55fx49qFRq9ZNFIiJMLu7bHN/ivl0iW0R+v2/fUa1egjmBSR2aeV19piPPd73OtoOuZSjPIz+0lv8goRpTLKo0kcOviIVZFq8FwJrGUI9Llb3G92OLZb6OlA5OGEMDMXrZkwKa7wbmp/oX1GPda9Ar0klleFOsNrCOggg2hncobruoD3v+08Th1Du+K9VKkkODcWmyFDqgWbbUPPbJi2o41qITm272K47a38SrbuZRn3sWZS/j02gp9sUG/NapIsD5leLmCcxQdekLlR4tHkJaOk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e107ab-fabc-4724-2e6f-08de26dcb69f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 19:57:33.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AkoCmmPR/4kcYKupn6OCHd4qb6nqDH3ExnB1S1p0UI+XPJX7uCXZ4mBUC3FfyXsh8TRbXWZFVWywmWO+QxU/Q+D9gD13tUv3juBwRQvKFYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6633
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180160
X-Proofpoint-GUID: 4XjLbWMmPhVg-YxlaYoNwMnyQItZmMLD
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691ccfb5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Qv6f_SBzAAAA:8 a=HH5vDtPzAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HkRCkYfpzbB93zaOjz0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=B2Vw0FeNgNaa9BrQLqC2:22 a=QM_-zKB-Ew0MsOlNKMB5:22 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=poXaRoVlC6wW9_mwW8W4:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXxc1ClrwumgBg
 q6zlQ32ekGhTpCfuDhJ1z8D/lvquWaL+iX3bA85StP+IkDEFho6zvT+audt3nyS3dtaf/9rqXtz
 iw/sfkIsv3RPjzIIVBfo9wLW0X7EL2bxnlzxSrrTbMD43chNXwf5bLYrrLb3vKuYBIFem+oqnqL
 L7Rtpc69gLkyLMQHjs4P2PahR2iiV9ig0aC94Jje6FCltxt0OIIaruHP0AeHgOJx9YHdbmuYaVr
 g2e6Bh5Cd6ogPdzraoMGBAdTMgdxe27YZ7SnXn6CxK5veMXfh12cPT00G4olGAXaJ86wL73Tmjg
 tYBEWdYf/soI4cytQh89Jid7ODxSjDMyChlVSD0kMd+kG4EYl3iVq3wdPuJBlZ6+qb0QHchD9zS
 46F9dRuPwFDlRwXqRlJ3GvlZ5+jNQA==
X-Proofpoint-ORIG-GUID: 4XjLbWMmPhVg-YxlaYoNwMnyQItZmMLD

On 11/18/25 2:42 AM, Ваторопин Андрей wrote:
> From: Andrey Vatoropin <a.vatoropin@crpt.ru>
> 
> If allocation of cmd->t_task_cdb fails, it remains NULL but is later
> dereferenced at the 'err' path.
> 
> In case of error reset NULL t_task_cdb value to point at the default
> fixed-size buffer.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 9e95fb805dc0 ("scsi: target: Fix NULL pointer dereference")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
> ---
>  drivers/target/target_core_transport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 0a76bdfe5528..88544c911949 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1524,6 +1524,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb, gfp_t gfp)
>  	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
>  		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
>  		if (!cmd->t_task_cdb) {
> +			cmd->t_task_cdb = &cmd->__t_task_cdb[0];
>  			pr_err("Unable to allocate cmd->t_task_cdb"
>  				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
>  				scsi_command_size(cdb),


Reviewed-by: Mike Christie <michael.christie@oracle.com>
