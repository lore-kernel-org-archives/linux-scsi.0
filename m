Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA973B7750;
	Tue, 18 Aug 2026 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065763; cv=fail; b=jBYWt8KG0oBPP2VBiLAPsoGiUzD+I0TzET1BPe0l+s85OEMLUuXHIQ9v8llmEMNZg2B2SeVCf738tFZWKfVokga/PA4kb+iuJksH3PIZHizvWlsww9VL5Jp5Zt0VWV3LmHJzvK6DbaXigV4h/TS8FU4agf0SKyyurhlLO6ISDMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065763; c=relaxed/simple;
	bh=rXTM0w/YSfD+TsR9+iVxMO6q5sUz9vjsMmF7jK41ruw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Og8akru5oAybkF+hh4UQpi/ehPFstRIEJ/6mvgQVJIHvX21TJekIGCgYU94IVYD0VnsdpPckvFWQsh4UcpwErXuypQyKwsUu8KYkQEKmgmRpa2dxt82yUCdPPZI4u3Bdc5ZBtg7hvH2+WlNzq1g7sdTt+Kxfp4J+Z0410uIA/pE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N3pqZYoI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ybXPVUjJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N3pqZYoI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ybXPVUjJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IEqlQF367990;
	Tue, 18 Aug 2026 15:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rQ9UeDWvg/ZIUZwyjcHwalBdxDdhcLBA+XcsC/3lhzw=; b=
	N3pqZYoIl3uQK1mlxK0WOs8xhSfhqQnEPViLESXsZQS60kOLwMscZj7Zcnwdnf4c
	71N9rOygu+W4SPwjfkOSzhh0sgjvDqdhJxMGMcu55+wjiI9rv/85RkRbYjcquz26
	LoBumNqfgs3vLwpN8+qfP0hMNjwFBqUii3ulIknFWy9eg6PxHR9QG1+IlgB4FrqJ
	V2iYsFOumgySaHY/sOsvB0C3vsp+LzBRkzEsMX7zSv6sZW2r8XiA1XHugSBn+DBI
	/41FOYLkohfYFCaekDL5cXx43IPIc2vwHCIB/WOD7dkE8BufZ3sW2QfcauVLMaHp
	TYUYUbJNKSIVLXzrI9YCYA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2g5cd2eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 15:09:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67IF59oA040774;
	Tue, 18 Aug 2026 15:09:16 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejcphqw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 18 Aug 2026 15:09:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nR5cSYragUz8gvpqtfyDjmcw27SpYBZKXJqcvmhoeJQQMYVTt8dNT/B13pqEqpar49Iqx/gDpjkHE0/EtcmNx33LnCB7fxrFFXle7enLb/yD6/WlHG1S2/EsDe1QZOFNj0MRreCCOP0Ci2poy7AMO6kiE7mLOMTPxPz9c+92NaLNnnbtt3g/Bj7CPr3ku0jqI/dxlBnPz71x08rnRPaS73JYpr5/clMcJrN3oS0+yers7RORfAHhAOmEo1XpMszgqkhWZlkzIg1TfU+x4SPcaRF7zi/d4KI2miaY1tKLmlt9eUs/HqsYGj64bilh5p5Cj8d/IiWobJIawlxhw608YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQ9UeDWvg/ZIUZwyjcHwalBdxDdhcLBA+XcsC/3lhzw=;
 b=zJbmQd4UqNKDReAJUB50QwFZADUelo0qy+z5dJhJPqOtSvsICKp5Np402gKIMT0yzIF8ivwb8+pQLWM0Rr3tctkzynZOckRHTlEFlLXL5rWG9XCjxxuazKmjTjgKXoUjJNO/+o1V60HpFY3/f33Hipj1erw8RQ0hYdi1wr7VgfWpev5ZMpuDLeHN5dI2i/OYBpNnWDgPxfN+XY/z9LCr0ePTPFCHHFbhgIoZU5IyuwfCe3bjbJDhTAUmgNQl3P25GKYOwzUTcsGFKVdeKf49DrvGDnFw9afPDaXCKdpJF0BePM+Z9dPjhDZQtJiERGUDrSdfs9IeAkMXTUGLF4nrwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQ9UeDWvg/ZIUZwyjcHwalBdxDdhcLBA+XcsC/3lhzw=;
 b=ybXPVUjJNBfDXOYl5b3agOeqR3dvPw4lJQ/xWsz3K7XW+44q3zKczry4jUkcKqczPDwCqev1byoflqmhBvfgHwx/0jhH9kZSGFxYwVfaHbS+q+d63mXUwpCMgmH2xamexTg2xVlCVtjfttbXC6icvRTH1pPL4D0Av8/Ylqgq8kY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 15:09:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 15:09:11 +0000
Message-ID: <ed63506e-4b73-4ce5-a506-23f1411d19f7@oracle.com>
Date: Tue, 18 Aug 2026 16:09:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call
 in _base_assign_reply_queues()
To: Ivy Lopez <skunkolee@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260817221300.43286-1-skunkolee@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260817221300.43286-1-skunkolee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0589.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 741b52fb-db42-4b3d-0379-08defd3aa863
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 Qzptzq7gjdzDDzolTja6xg2Jj2BP/Blh86w9UQR/pkvgxuiddf8TBB8oNlffMrpXzZriBME5ZFd9NwOfH2N4pTPEHKBt9GW4KvCTAHy3GyKGL0QioSOXDVAn4OTPtXzsGuRtWiTuY9jVF7fG94D9yeNp2DGJgK3+sf6nLdtBg5UeVwyH6xUWB/7rRRe946UsqktSOPH8WQVE37YWqUunNipxtgGOPBPWYScPsv21kaLUCUuNLmlJQV9Q4Lt6PtEDuIMfChDudmzVwKyYhDRtHLah+zKMx2ogsl/9CiOJ26aCzMlzHRkQcds90b/WMsSnPLmW2Y5dV3287jPykwVnSur6+1TUrPR/6ZE2YGqv0Us9b5fNX/u7s0sFnPaO8l/LnMtA7NN6fGCLFdzR3E3QHy/NhQyVhnM4z7+mwIH3NC3r3p7NF/th58KyPjRPNkrrVhXfpfOKsQa0HOVK2GLwMndhiJ/NePd/lCPh96PeDP1Qe/I8RYheKdYRhRBtTrJnJYkRCuhJx/1Y0dJM22gds7RnnB/AeSbUtr68LpzfFSE7r7+QaK/XTquB4Y+KlGTmiOYvbXq2izZQ7HMyiQ0M/TVN/8rAdYX3qRDWr2a4dX8UyJKmMU6D6vJ+IL9QiBmPSd7vXTri9JnQN5F3EQBmRJzSPh3YVWzCxSibekcrV4o=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NHl3ZEdJTmxEaVNQVW54VnEveDd5Mmh3eUdpUW5LcDFUbEpBSjVaYnJ2Tmc3?=
 =?utf-8?B?MkxORENTbGIxa3UrVlFWK0dVTFo5dSsxWDd6dE9uTkFiYjM5blVsaDh6ZHR2?=
 =?utf-8?B?aEtkNEw3TlQzWDZmd3NaZFdCaTA3VFY4T2NtWWtXYng5NGdNbG5KSHh2d1JX?=
 =?utf-8?B?RGl2MGhMSHpyTHlJQ0ZGb1hjY2Y4aXh1QytSQkt4OThSTk1pQitjMGZGeU1n?=
 =?utf-8?B?Ri9McHpxWG0xUW91Y2UzVUlHazJsNzBINEFzbDI3YW5FZm9KWnp4OS8vSUJr?=
 =?utf-8?B?VG5YWGI3YW90SnFQMHM0QklqdG13b2lZOENtTy9JWXhnUkV0Nm1ObDRRYzJG?=
 =?utf-8?B?ZVp4SHBLbnB5S2d5WENIaDR5TFRWejd3QURRalJCRG90eGlWQ3dSVDZkcVky?=
 =?utf-8?B?VnpPaVMyQS9oSllKZmxUdEV3NER4MnQ0YjJjby9WMEwySkdkQWtjalA3K0pY?=
 =?utf-8?B?cE1jUWVWZ0JzS1VjTUxuRlRqVlY1RWU4WjV4MEF2YnVnZm5GSUZIaWxQNlQy?=
 =?utf-8?B?akd3cEFDM09mdmZOc0Y2cDVnZmRia0o4M1NCa3N5REMwMFBCZkJvOWlMeE9H?=
 =?utf-8?B?dmt2TFY1TzRWWjhsUlNRdGk5SkhuZlNvU1FFV1MvQmM2Q2xhZDduUi96VGs4?=
 =?utf-8?B?R01XUlhhWGpMZlNMNVdXbklhN3FVQ2RISjA4Qk5PQXdBaVBZTzZ1QlhEd1hQ?=
 =?utf-8?B?V2JmNStVM2hwZzhlRmxzN2xNdHRoSXhxdFRDRUE3OHNMK3JMVnZ0VzBWWjhn?=
 =?utf-8?B?REJaMUd3UDVnM3VVMFhvRzk1M3BjZGpaV3orcitQWHBQME01VE1ra0txU1RL?=
 =?utf-8?B?dGh5UUZ2ZWlnK0c1UTJhQ0J1alZMbmhHT002ajJzUFNEQ1BSc1JxL0RIZjdD?=
 =?utf-8?B?WGpvY2FYNTJFMmdpVVZkUjBXZ2V5MUZGTWREMmg1WlY5bi94ZzBJNU53T0FV?=
 =?utf-8?B?NnU2Wnp4N0VyRFg2VlFvRHQvNk9mT0lpanpRVTN0ZkE4YVZXRWlJOHVZQ3FX?=
 =?utf-8?B?VUdFT1FqMytTRm4wRjVmZm1xNGJQUU9UU3crajNWVUZtc21XNnI3TW81WGdJ?=
 =?utf-8?B?SklCVEZMdk5vUy9xMWJ6TS91QVU3d0E1OUNJUkVNUXc3VG5jaENNNDA3N09E?=
 =?utf-8?B?bjF5WnhmMzUzK09vZlNHMkV1c2xsSS9RdjB4Rkp2Mlh5K0xTbkdqWUUyRWpx?=
 =?utf-8?B?OEMyMW05d1dBMFRhcmpaRjZUNWxpd0xySWd0UUFlK0toRGowbkVCelVMN2pL?=
 =?utf-8?B?U29mc0RZY1A4QjNWZzR1YUJteVNaVm8rVGxBY05KWmh1bjJHMk1ja2o4RE5F?=
 =?utf-8?B?SCtra080emtQditvWGRQZ0ZmcGsyUWMwcm9QQXNFLy9TOUNmZWFjN3l4QUdR?=
 =?utf-8?B?R1pybzdxT3ViODk3L1crcXpHRytiWFJzdFRWazNXNmlMUGtaSmJ6KzB6cjBT?=
 =?utf-8?B?VkVaVUlQU2hHYWNRc0FSYk1mTnB4ejV1TTJXakxGY3lxT1kyVGE2bjA3MXBa?=
 =?utf-8?B?ZmJScHlsejB6MTI4V2Rsb2Jxci9RK3BqZDdRSkRSRms5WUpkaDV3d0U0WTNo?=
 =?utf-8?B?YjN0SU5TalQ1YUc3RldPN2NUT1VpSEthL3FsWm1lOUMxZzJZSjJ2RmVXejRl?=
 =?utf-8?B?NDdpZjRKVXRDTzBQZFY1UTlNeERzQkR4VmxyVmZCMVhZblczRi80L29HWXBV?=
 =?utf-8?B?V2sweXV4b0p1eUpOckNDVVlPOUs0NE9sd0lxalB0eXJoNytSSUxMT01QV3li?=
 =?utf-8?B?R1ZlcC8rRXYydml3Y1ZUZUlKYVJ2ektzaVQxbXBNNjFCOTlOTURtTCtJS3h6?=
 =?utf-8?B?c0kyNDdVTWZiR1JFajhkVUlKZ3JHQlg3dVl2MzUyWU5VMUdiWnBHWExwb0Vw?=
 =?utf-8?B?bjdLa2VIMFJjV1NnazkyeUlEcWV5ZEt0Tm9ORFhXMThhRFYwcnVJdllRa0tm?=
 =?utf-8?B?Y0poMVl0c0pWdTdKaHBWa2hXbHhENTVweEdJNFdTMFd2bHJ5SU5RREdIdldF?=
 =?utf-8?B?Umd1WGpqM2YrNDNwYWJUMWNaQmt6b3NGUGV6WHFIWEVrd1YzZWNPcWNuazBP?=
 =?utf-8?B?ZXl4Vk9SUkZXSnZtK0U3UGE1N2RKVDFpcFRZQ3dPL3NFNUR0VW5YMk9OVzR1?=
 =?utf-8?B?a2xtTHRjNHhESDdzQVZzZUVPdmoxL3RrMldTZTRVNHhZdU1HZWpQUm0yUStr?=
 =?utf-8?B?K3M0NUpzSVpMTEZCWHRwRUIvUFVsYlh6QThzTDUxMGcwanpvZU1pQ0RzTnBl?=
 =?utf-8?B?eXBoWEVOcXZZc0tHNThFME95Vmg1Qm5GS2dXNDdvV0cxMDBnWnQ5bGIxVnd0?=
 =?utf-8?B?dmJCeDd6d29yZDNVS3JlZlF6YmhGWkkwSCs0ODIrMTlXTDFnTnJremEzZDJ2?=
 =?utf-8?Q?Uyk0l4Jw5wxVjc9U=3D?=
X-Exchange-RoutingPolicyChecked:
	QMq+Gqc89N+AkZXx3N0zMgcFOcuGfJiqBs0CxvZx/2d6bR6Ms91iP0NFGrkwzklt5KRIlDkfLsawy8Y8cilByzbCK2WRpqHp/QIQGXaObytTbhI2KtYQI8pSV3HuqkTj6dKD6q6tBP+wEJhSZxk4Ov/ZxaI5lMGH1Wn+L3Q2zKnyAs7UcJmyuRfOZ9FmvyT37wyvAHCghf+OZA4gisNpglyg7I2ERpNAbDaN2kVgr6JWKZxlAEh793Ry5QbQo2f6QNHmdT1vIeA4Zd16UAbEToF18oYReyPOGU1az8/VW3xK/X5KI+AbdQ1hrJd0sETeBHlvVOqHenI7tKg8DnhtbA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E+8lzJ0JG1tIbFNj960HQNdIQ/obD4OcWKCMJGrMQBFuqg9VMHfAvaYMND7Zh4JMSp/Kanm+/F+N/dQzpzNfEig56xORLCHNaWTQsdJ9mNSHCxfEGdW5TVVXhdqU/zToS/5MfWYTLuGWEOh3dN6Ly4jDxyITLY5Hy8xuPZmtBGsCqjSPNSUPDb1FzR8B5VKhddTsKhz/REbRCypjzS4KoiP4Kss4nrFTDLFvVwPtlfJUOwhCVjfxFOvNy2VgEkrCqJj7IF/mED3A0Mr77Lg8+8N7y4Qsbp2biT7pMRURwogGGaueKqaa0cjDtf2+/Svi3tgwcLw8Fmzy6xH1Yi6ErwMSLctL3CYSLLiw0dIFH4UhQdChjDJ7vCsFjvAt/VVwFja8OJ7hjx0pO5vylS2nbXsVMysjsujO42jKRPHJJP0PgL9crKuUclYuFZSguf7H7sio7sbBX7l3cK4nmk/b4GK3/CGwXOyu5/DtOFc7x2IzxcGJAYnXTYbvTqdB1t21ljHuN5Ml5o/pxigeLjQaSU41fSPg7ujy/mSh4/1E8cV3mWOmF+bjAv7viB66IiSTGfTf9WUOFeY0yKifsnPuB4W+OphBDVsh3N+zm6I22uU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 741b52fb-db42-4b3d-0379-08defd3aa863
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 15:09:11.5198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfW22aqCbafjEgL+kn2Y9HolfnEmdGa1Yt95DMzv2/cbRzZwBxs9awMFC+am0MAduL4QNcPpe5YXaQjk4tuk8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608180111
X-Authority-Analysis: v=2.4 cv=INoyzAvG c=1 sm=1 tr=0 ts=6a84759d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ldfOBtFJEoPBdPxSZhYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZxThtpVntKGZhMC-6gQsdWQPQfxhI7iy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDExMSBTYWx0ZWRfXyK3NgvBrKmOZ
 p4mNVh0Ng6MWkOHeOk/uNzJKeHSRMyXGqPdTFeExmJIT2YgPb5QD6G9BEFhAtnHEGFzrGj1wdC6
 qO87/jco4yeU2Rb+P29OEXZC/z3kHlbNVQ65bZvzkEiQurjGblX1qzjhaleUK46bxHjLG4ggQtK
 mmAowN1+FTlVzq1ZLtNVnPPb2qtuvZjwpaGrKr/t7a3cZ32/1bqQI6BBnAvdCoSkMeaEQsj7Kqo
 OVaOJU+7x8w5QCGtEz7Ls+J5nw8+x3oD7N1mcwX9jRI7yo/ct3EAQvvU3utVJ7NnBeOEv/UKOD3
 2p0BbBig0+Zr75P0WW+8/zFlIYw5Fx3Lv7ASbvZAYdGzKoXZPQjI4U1huchFf3CMB9oTy4kmxAW
 VIga0RQP2a3NXI/45W1ZY6g9q5yON7cmXuMVBUWJkbDK7oDxXeZS3ELF99zNriekonNOun/OMN4
 Lp2e6zRCAotHBbyWtJQ==
X-Proofpoint-ORIG-GUID: ZxThtpVntKGZhMC-6gQsdWQPQfxhI7iy
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDExMSBTYWx0ZWRfX3DMkFUtKi1zm
 eWstFVKc80SFdTzqLHAjdxqqzyWJeo2YqzgbnA1vUBXIvPj1ozbGRqV+zCT/HRSSUh1SrPVzd6b
 I76XbkqPUGAQJAzsEI7d8QnEsARaYOeb68rNH//5CHN2vddu1vpc

On 17/08/2026 23:13, Ivy Lopez wrote:
> dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
> topology information for the PCI device, such as single-socket
> boards that don't expose device-to-node affinity. 

I think that this problem would have appeared by now for this driver (if 
it were really a problem).

However, for CONFIG_NUMA=n dev_to_node() always returns NUMA_NO_NODE.

> Passing -1
> directly into cpumask_of_node() indexes node_to_cpumask_map[-1],
> an out-of-bounds array read caught by UBSAN:
> 
>    UBSAN: array-index-out-of-bounds in arch/x86/include/asm/topology.h:72:28
>    index -1 is out of range for type 'cpumask *[1024]'

x86 seems to be only arch which has this problem now.

I have tried unsuccessfully to fix it:
https://lore.kernel.org/lkml/20260107094007.966496-5-john.g.garry@oracle.com/

