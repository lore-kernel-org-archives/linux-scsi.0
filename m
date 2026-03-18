Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6D536AB7B;
	Wed, 18 Mar 2026 07:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773819893; cv=fail; b=Gs5fjlB4kcyRLYvg3I2cThYgxuMmydAVIT+cMZQmAcguQj8Tmj6iBkhziRWCv4tBINoeov3QkF3efILGZF6Mbedx4DmgKacthwoaOHpZvx76jVz6b6YU4JruwpnaOsVDdXT9RoCCGyPDlW9o/ezVEwd676mznGCbtKOaHgme6fM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773819893; c=relaxed/simple;
	bh=x8IV/IoFV08lTipPUQB6pQU6A76aF7bHG4Hs/oGDYn0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uW7Ayp/ww1ueuq699zwqQjTVOirKN3lxxgdYOn3B9NrqqSS1Chyglss0+3C+d/LJ0zuLcnH9nDlhoGWO3cA4m8zYMbLBmDyJ6pkVsPDf+mXOoo5husVFgyS2Nyne9fy1WcQ1a7Z8DHwwWLPu/4RaGzA7gSQdz4hcvDtoJTElZuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=l9hNdAp4; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="l9hNdAp4"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I4MHxo3632122;
	Wed, 18 Mar 2026 00:43:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=BUOavu+UB
	O520CkfBMbmTDL8sqz4oWMhALhqVlJz0yg=; b=l9hNdAp4MTFWoa/jwNnrStned
	iY9pURBv3673FZQXgvCfeqAJYVI4BA7d/A2slj6MAY525CbYn3kHHXyQ3PoNdode
	WhjB82aXv5CByFlLecD6RabQezPmZSwlhgyMydO7qlC1n4aZRheC/5rhP03FCDT6
	5fp0iplhBOdHkKT4o89vFYj8Qz8rpPvrVmuXpNlCaV1l5KONW4GK7l+CRc1Vq2SF
	iln4k5PGjOShs5mZr7o7/mYNd9tKGRfW3HK8ARuxCxOa/6d5rAKfSc8sMh1KgbZr
	S8J/sdfA4AZuKB1KutHVDyto+FpnntSJsVnFRE7SnPhkOups77yugzf98M49A==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012057.outbound.protection.outlook.com [40.107.200.57])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4cw2y14ct4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 00:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDfVS8OCQ5hVzu6a3BvtIVyB4jMKXBulhBW8ns7X52Zx5dPBLRMgA6Quq7Dy3OIsfJXI7va2TQF5zH07sDN+W5zdZRTzTeOJIVp/j0NP7Af1kpjdXYKUNnwjZPR7tvrjPwsLL2f36Z4kzuoB5V2uZW38dNPTD9unFTO/7BO+lxxSvYoZT7Stfpz/4uRH9BSzgyhG86PD2vEOT6bl2UIJD79QZTfpj29uSt96mVy/A1tF0AYC5qOFBPoRzCOV0X+xviVQoP50dBmPNkaeRzdS95h/uNKZOsIvXed5VlJRDoLOGs/JxqbvQDRavBvSkxeXDDtj6lmRnoKgJ5akFUvVZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUOavu+UBO520CkfBMbmTDL8sqz4oWMhALhqVlJz0yg=;
 b=PJxQBX0rxjZRpHaPaQJVAnX1VDxEJASmNF1TgVj7KXI/cs/lTOcCLFERREK11nPuInkTXdY9WJhMdkpQFCDKoRkCEGB7L/KiFJprWfdCemCyzZkFFcBfUjvv15bD2AEKsaDo9yv3VbhAr3r7aDYqB53MT/cvfl7lXMHTbeFjmNSgNIaqdiO4LYuggoISvhnzk36+2QqkMrcI1IRu+ZFJ60QPiDn9mTyLsA5LiBjvgsigtiBp3h0PzeIhjuuXTEBDMavOLAbJGpnwUbmUrN8N9bOLdfRwsDdi29mqtuwBYYxNNP/S3FzMTL6W7u1rrODZCWv8Up84xDAFD0aJ4KZ3Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by IA4PR11MB9177.namprd11.prod.outlook.com (2603:10b6:208:569::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 07:43:33 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 07:43:32 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: ahuang12@lenovo.com, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
        hch@lst.de, iommu@lists.linux.dev, ionut_n2001@yahoo.com,
        john.g.garry@oracle.com, kbusch@kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, sagi@grimberg.me, stable@vger.kernel.org,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v2 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Wed, 18 Mar 2026 09:43:13 +0200
Message-ID: <20260318074314.17372-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0034.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::21) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|IA4PR11MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: fae519fa-8fab-40b6-5927-08de84c20dca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|376014|10070799003|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5/N0HBhgjtaxlIrIM0YRK+hUVs8S2L5DhUREP30MIG+jof46NC5MP1fZFzmRFQC69JJBj8qmx7CQ6+t8exml5SyRkgwZGPt23KHlOXKbdK/d2D/3/6phefq/wzRTU6nHQyqmqa5kBD+dMaoYi3Sbr04tjkkKDfb95Yi8ajwMBxnJZRFZQVHsNUui6EKsYlFBlBIA6gxUnFAzv/TlK9zidz0erEWZdvnV+1fkysCguNO12BvKFqjGgdMn61ryknBgVu2CCugr/zAhoPDMzzkV7Atky2Fc/Udt/d6GEw8C8u8roHfN+TAVJBjXUFwflecvz5EwvWvgyrwtwxti4rLQ5r4gLppq9icO3qfgb3TkHwvCuPm+KZJQ2V0mAfKTG5BcZgKkiBMIFu3DGVJ/lDFDjkOmS0h0w6P88lmxKgImGGTlMVMut6Rlg/x/OsXqJh1m7TUBFfsLP0NHfzqqX6YVskFlAjKsJsN99QWnylSrKyjdbgDPODf5gthzwjn+8rJuf3hRrvctZ8971W1hBmNrZaJ2141NBcByk3vN2OVE5Uz2wFXsqCf0oHMWA/zNT0IREXlhu4n+bPs8NNgANM2dkxj0pyHKLmgI+3/+hL4WRd0im58xq0qIrQNA66Gc6ijfEXbs6sctfokuPOvvCAFM1XR4sKCRHiMszGWvrdZ7ZVe/bzB3v73/2OZtvZmW9lDzFPWPqh0zRZb81fUq4qYP7gJiKZMuVrNT5sHV0PUeU8c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(376014)(10070799003)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckZvRFU4SzF4WGpnVW9uRDZnNXcwL1llbnNneDVYaEVhWVZONUc2NjFHN0hX?=
 =?utf-8?B?SmhKelZDUTJDVTVWOWNmUHR4bzluc2VrY1Roek1JUlZTeGZzajE4dVQ3Z0xC?=
 =?utf-8?B?ODZRRlNlU0ZsYUNNdlZxMjk0UldDejVVT0J5UVVOalVoYWVRQ3drblNtQVRU?=
 =?utf-8?B?ZUk5SWRYSTZsUHo4OVVSeEdkSHVqbFBpVkw5eFo2T3Q1V0t1ak9vYUtZMjF0?=
 =?utf-8?B?OTJJVVlJZDZBdXJ6VU9DUlp2WitUQnlRZUdpNkQxUVliajZIRzU0dERSekQ1?=
 =?utf-8?B?eVRlcjNVOWJ1c1JGM1V3Z0t0RldoOU1rY0lPUXlpUFJ6MDBQdWw2MHA2akU0?=
 =?utf-8?B?dUxzNlZzSWk5YmJpU0Y4UzlScG4rVWw2d2hmLzZ6WFk2M0FpWms2MlFHa29Q?=
 =?utf-8?B?Nnl5YnJiMzAxRWxRemlJRUhid1prNUhLaXJRSllnZ01NbnpsRkRZTWdKRjgz?=
 =?utf-8?B?WnJFL0tVRmNFQUQxbisvVTdHL2JXc0J3Nks2L21jcFI4Ui9Mc1hpUm93cTNq?=
 =?utf-8?B?NitmRWdqMHE4OTZHcE9hQVhDZ2MweW9sS25sSXdlVzlNZC83Z2hJZEw2NG5Q?=
 =?utf-8?B?ZFloVEZJYzJzWmJRUnpJZ2xSa1J4SzhHeVZ4alVVdm1mUDhMZi85U3Q3RHVt?=
 =?utf-8?B?QVRNaWVkdlpBVlNGTnlXc1pmUERUNEdYNTNUKzRWWDR6MEJ3NHBITUZZbHVH?=
 =?utf-8?B?cFJEekNyZUROejNLQjROMnpMakxPdWRPd0ZsN1IvakcxMW05eEduV0xjOG1K?=
 =?utf-8?B?R1NkbmdGQWdhaE5IV2xmdFdUelFCOXgzenF0VmhQYkVjbytsSDQyY214YVl1?=
 =?utf-8?B?eGZvK2RGNk9zWmZXV2pBYWx6VDNxRUVPTHc3d0JjZGFpYUU0cHBwLzB1d1U4?=
 =?utf-8?B?RE94dHBBYmhCenNZeDZESEIwUGVOSHh4U1h5cnRaMmtQQmxPK2RWcHMzRDJP?=
 =?utf-8?B?ZGU3N2R5K1UwSnlZUE54U3d5MUg1R3V6Q1JEdmozdUhEbzUrZ2Q4OEpKZ3J6?=
 =?utf-8?B?eUtZSCtKNXk5RGk1c0E5ZHdHODlpbkZyVEFwa05kSDZ1Mk0vVmp1Qk13c3I4?=
 =?utf-8?B?Tk5sTmc4dGNLLzBwNEhnYTJjeWNVVU4rVDI0S3J3aTloMFBVVTRITjJuaUUr?=
 =?utf-8?B?YUNxVEplZCtmSVFWMit5K0RSaFdsNFo4S2pTWVc1MXlGUmpCd1lKVUk1MCts?=
 =?utf-8?B?dWRoZi96MnVzUWVQUTB0eldUMmk3bXowbG1mWXdRVlVxQmthM2ROV0tFMDdI?=
 =?utf-8?B?ejR0OWd2WStiR3VvTjJiN0lwMXU5UGx4YTVwZnJseW82TkV6cncyRERRNmRk?=
 =?utf-8?B?SlB6cGNZbzlFMFJGc3p2dHN6TE9yekpqVHVuNjR0MFV2WnRDWmlkL0hZU2Vm?=
 =?utf-8?B?Rit4LzJPZ0JlSzBwbUVNK0ZreHhmeW1oTE96b1lJL25aQTNJVWZlOTErTnBx?=
 =?utf-8?B?c09OUklUZi8rY3kwUllWU1ZNZE93UVR4RzVmdzArUC9rRmxnbkhLRVdkTDIw?=
 =?utf-8?B?cG5YSExFeml0ZkhlV09jSEhOTUZwTi80Y1IyR1NBbDRmUkwyN2Q0Qk5KUkpQ?=
 =?utf-8?B?VU5XTHRNOElKdVB0RUdFdEtYeVFrVTJzL3UvNkFpWVFvNjV4RmJWYWUrYXZQ?=
 =?utf-8?B?UEw2RzdnQU94a2ttck9kRmJiZ0dPSDBnaVhuRmtnNmltNVIvdGdDVjgyeHdY?=
 =?utf-8?B?UkU5WTU3QjBqMlgwK0tXc2pNWERjbFRXR3M0Q1M2cEVwZXJ2clkyMW5BUzg4?=
 =?utf-8?B?RXVGQTUzUXdQd2JmZzlJeTZKZTdacnMvSlR5UFN6ZHZMN2lmVzc4cGlyQjZu?=
 =?utf-8?B?WjUrWTAzT0FpSnIxUkZYby9RdXBSaFBaT0ZhdjkwZFVROHp4OHpZWC9ZR2NZ?=
 =?utf-8?B?Ty9GTENFcm5qL1NxSERYeU9iNEVKWmNrYThOcm5EK3FqMGEvdnh3KzRXendH?=
 =?utf-8?B?anhIWmhDQ3A3R0lhTCtHbG5weFdYR0VSOSt2Yk5hK0FaSnV5NUlSck53VDBT?=
 =?utf-8?B?ZmlwSWs3bUxqWWYxNmtpejN2QzlkdTQ4dXVpVWZYdkZJYUxSL29Fcy94Y2xF?=
 =?utf-8?B?REdHRSsrL09UVU9nZUl6YkhFS2NlVFd4Vjd6SjJDdVRCakw4SEFqUUthVE4r?=
 =?utf-8?B?WVU5M3ZwQW9oQ0FURWhabTByV2pGdlRaL1pmaGdwQS9pWTdXSDN3MEpqMkZa?=
 =?utf-8?B?REl0LzJ3alE4RXF0ZFdqbUR5ME1GUUtJYVppYzdQK0ZtS0t6WkRRYXM0c0tq?=
 =?utf-8?B?Z0w3REVXSkZxbG1DbXJMcldTMkt5b2FHWWR4L0ZnUitxK3lRRVcydUl0Nzly?=
 =?utf-8?B?QUJNckQ4ZEtEdll3S0U2em8rL245cmwzRmFtY3JNWnZNbGc5c2JzdFh6ZlNN?=
 =?utf-8?Q?1SiAZZtyKPhYAwDYgNAit6xCGtFHL9jcZ1BmELVEEbrTH?=
X-MS-Exchange-AntiSpam-MessageData-1: t1+ILAqHnqiUDTyT1LJpjuMnAS2Oi/RsNPE=
X-Exchange-RoutingPolicyChecked:
	D1es1hdqRNN01yuJQIAyrW9QHb7kvA8uiXgPLWihGCfa93Xyf6o8coRi5gF0emo/aYF76T2cPWcec4BXmJNo/Gdx9wowi244v/4TQRzpYP9WSyk5KGPTA7n0Zcz4GeL3qSe4vs7+aKBQ6+b9KGoXPUcQFhWulAVWVcasWSTyAzkFgUnHLOJyWvSDpR6RSGfI42W5geCsxe1GrPS5cUf7V5r8IHfXDzwcGjgZMSbZ5fd6S+Pf/ywVeOsHbuF3HnIrKYfnyoEiS4rpo7HQUhRITmZNLHIRjv5o8cMPi0GJ8cPyi+YWumRzksH1sutjreFBg9lhNsF1UN48iuThBRTUEg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fae519fa-8fab-40b6-5927-08de84c20dca
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 07:43:32.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDY9KgmNrsKOThpWOF3BiMTcXxJP84FZcZU7K/HbU27Dt1z9zumch6fy4yjukIeI5SZY9PMiojqoW0Llj/mpzuDOwuCkEhGLnQLvreKgXT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9177
X-Authority-Analysis: v=2.4 cv=CekFJbrl c=1 sm=1 tr=0 ts=69ba57a8 cx=c_pps
 a=sWN/8n6q3Grq+dQ3JdI7kA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=whUmcxjDfgeoEPKe49cA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA2MyBTYWx0ZWRfX7IElKZnhSUSR
 F/ODOszsZ4XG6jhprgW1ioyh0gqn2MDqpEly4Jwg7Hug3o7LlSDihJJoP921g1+Jchi1SP6swgi
 9JAyq+OWHHzLjxcu2v8DblvuCOBfKKqUf85W08k/ClFs0qtF1vtCEGZIwJm84cmkjuJ4pYQnJeU
 0gw1OIY6RpkG01f3ca531NmXDuIJyoXMiteScN58hT6HmN7OWmr/AICnXXMAw7p2oXtEJqVDprT
 +jcq0JIJ7VBjETl4lSqagW2I39lfYwK75/j2fyuXTOZE1Esowye4TZ6Uasb4f844ydwotyqsg7u
 90NeRsrXj1jxtTDnlzebAgjF9WWQapXU0xKhtyJubc2UTkYzADIOHhNO4o0UXXGRaJA13/8YqIB
 82TSAfOhsG+gpK2s5ec4YpkPgE1rRWdrqwSBV5HP9KbuzbDxJtBHSHakRcPeuOquQhIQSPTHzbC
 D0AQEXYfZYrwP/wdiVQ==
X-Proofpoint-GUID: 8XpIaZ6SZgxrc5UDCDigxDLVRCZRTCV-
X-Proofpoint-ORIG-GUID: 8XpIaZ6SZgxrc5UDCDigxDLVRCZRTCV-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_05,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 adultscore=0 impostorscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603180063

From: Ionut Nechita <ionut.nechita@windriver.com>

v2:
  - Dropped the dma_opt_mapping_size() change per Robin Murphy's feedback:
    the DMA core semantics are correct, the bug is in the caller.
  - Dropped the nvme-pci patch (no longer needed).
  - Single patch now fixes the actual bug in scsi_transport_sas.c by
    checking if dma_opt_mapping_size() == dma_max_mapping_size() before
    setting opt_sectors.  When they are equal, no backend provided a
    real hint.
  - Added concrete values from the affected system (Dell PowerEdge R750,
    mpt3sas, SAMSUNG MZILT800HBHQ0D3) to the commit message.

v1 feedback summary:
  - Robin Murphy: dma_opt_mapping_size() semantics are correct; if no
    restriction exists, the largest efficient size IS the largest size.
    Fix the caller, not the common code.
  - John Garry: Asked for concrete max_sectors/opt_sectors values and
    questioned whether sd_revalidate_disk() would override opt_sectors
    via opt_xfer_blocks.
  - Damien Le Moal: Suggested min_not_zero() for nvme-pci (now moot).

Answer to John's question about opt_xfer_blocks:
  The SAS disks on this system do not report Optimal Transfer Length in
  VPD page B0, so sdkp->opt_xfer_blocks = 0.  sd_revalidate_disk() uses
  min_not_zero(0, opt_sectors) which returns opt_sectors, propagating
  the bogus value.  Observed values:

    shost->max_sectors      = 32767
    opt_sectors             = 32767  (capped at max_sectors)
    optimal_io_size         = 16773120  (visible in lsblk --topology)
    minimum_io_size         = 8192

  mkfs.xfs computes swidth=4095, sunit=2, fails because 4095 % 2 != 0.

Answer to John's question about blk_validate_limits() rounding:
  blk_validate_limits() rounds optimal_io_size down to physical_block_size
  (4096), but does NOT enforce that optimal_io_size is a multiple of
  minimum_io_size (8192).  So optimal_io_size=16773120 survives validation
  unchanged — it is already a multiple of 4096.  The mismatch only shows
  up when mkfs.xfs divides optimal_io_size by minimum_io_size and expects
  an integer result: 16773120 / 8192 = 2047.5, giving swidth=4095 and
  sunit=2, with 4095 % 2 != 0.

Test environment:
  - Dell PowerEdge R750
  - SAS Controller: Broadcom/LSI mpt3sas (SAS3816, FW 33.15.00.00)
  - Disks: SAMSUNG MZILT800HBHQ0D3 (800GB SCSI SAS SSD)
  - Kernel: 6.12.0-1-amd64 with intel_iommu=off
  - IOMMU: Disabled (DMAR: IOMMU disabled), default domain: Passthrough

Based on linux-next (next-20260316).

Link: https://lore.kernel.org/lkml/20260316203956.64515-1-ionut.nechita@windriver.com/

Ionut Nechita (1):
  scsi: sas: skip opt_sectors when DMA reports no real optimization hint

 drivers/scsi/scsi_transport_sas.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--
2.43.0
