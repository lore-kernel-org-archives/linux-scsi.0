Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717604C9D;
	Thu, 16 Oct 2025 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760628123; cv=fail; b=JcNYWbSHYr160Pl7zWwt9CZuGNBeHaHLsi7w37T+IkjjjXRCMJUpC6Dg106OhuWQNjY+4RxQe+FMEFnGmioDU8W9VTwd4heR0uxZ7wgAt6aCmDq+cH4bIwxX67SBcB6BQHKsLCl0fef92umm+9r0eSc/jf4+2Xi/hOU8cSwV9i0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760628123; c=relaxed/simple;
	bh=BGptPAT4voiigsk27cpEIPymWTdms/NpH0rkfoLvUjc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J/nv4mFxI/TcdvHcARua5kcXh+sGR0gtYLPOMQHyqn1puXHS0x825YQVzsnP+d/e633Yvn3hYWqpQibhntM3WXyNV+52u1HO6m3Pv0ORvWw93R7T+w9K+YBrbvj8xg1Xsu8dwmmb7LOtKSWi0Jb6GOA4lii0B1a7mqgkfHKbDKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hWkz7AXE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B+RdLYOr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hWkz7AXE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B+RdLYOr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59GEVKdC000766;
	Thu, 16 Oct 2025 15:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3nBuES/rwcadcPz/XTm69OzqH9K9yn9L0raXd6kYe2Q=; b=
	hWkz7AXEKJHZRQfWnB+VjRem5Xn2hqFVj7x8dZHIVDwtwkCuIDthD/6jOFB1hsfD
	jGhI2jgk/l4rgGnSIanhOqFVUrhWE8YdJEjvr/TA1dlNkmplTJblH1D8s67ps9nT
	Fuu7MjGD0ipF+weM0zZQc6Jb7rz7Z4gIg2CX9KkEkVNaKP9g3VlUAo1Sg1euLsCB
	Vv3WQtDp0HkgUY3c5FASrJmOofg5mmEempzD/8U0XM4gB14SuyV81RphlK8NxKrn
	WXGetL8b9SY71GxF2wzd+X7MDwXDPtje2KSMif5h6qlgHnKIi9ARaOkGebwKywuY
	9rUiRGNzaOrtPNzbRuW0FQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfss14g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 15:21:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59GDTnRq025790;
	Thu, 16 Oct 2025 15:21:52 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdphuy7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 15:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MXtcpuSguhwpqpSfTJOP9CnyNWXJosO0z/IpPXEa6XsA4x4PzamtYXvNfnnPwzhKMI14x+X59hxbPTqiv6DjPH5DD3Vv5rsBO8+/CBaCebum4zvKDPfmrxJRbgt58ltA+TaAKtAKFnahrbM5WVsK7Za3FSpHNprUCpIVaBzHBefMfBX/eN4X0JPR6mfbEfmcMk1azo3Nkrpp9NdkVoGL5QLNxp08d49NWrjqqwJVGfFch4flij0zPztZnz1JQpbjQfcC9ZqRfN6hAjhcdb1OuYfSsaP1gDslXUySuE1fV7OTsi4V2TGgeneXuV0SAWrMRHndnGuiTo1PgsLbjoH/dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3nBuES/rwcadcPz/XTm69OzqH9K9yn9L0raXd6kYe2Q=;
 b=LG8QjcxkQN4Gl+fQ45j6AJCMjSRW9UMTDsGvRMN/t9Qy/MDiJWAZWM2uu6X2lXalKYVti3ubXw5terK/vrpR+XVVNrQEIGvt7qhPNBM/Lr+NZfCUhypJkx/+nRIfxDHwu4jyy+aW9/vT0oKmfE8p1+CJIk7g8FIkd8De3qNNY7XPZr7V86HWlUOwA8GTF9/MJbO4R9bKxy3dMIPzOJXzVMy3WL/+9Cf1IQf1kDekV5vTn4QtRCCkfs3N7qumbAcsBkMRE4c2Fj22BsE3vrtuVb0cZOFl+0QfDqjWxkgV2N1D8ktRTjoaPqZOHB92o0sJN+B2PkFrR9BHFCdLI+KsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nBuES/rwcadcPz/XTm69OzqH9K9yn9L0raXd6kYe2Q=;
 b=B+RdLYOrMiiz4dp+NIPl6va7gbJiir561He/6ZUzc5ww6GxhiqF+DDc1CM7JaV7xHDgu6SCsp0B7QT9yZ+v/Uty1tljk42v+kiIWT5h8G9h7CqbVJK3Er+BumjpYWrsHcaiOWFQyYj+V8sAyljRtCXuAq3oc3zNzknzLybh08qU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Thu, 16 Oct
 2025 15:21:49 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%2]) with mapi id 15.20.9228.012; Thu, 16 Oct 2025
 15:21:48 +0000
Message-ID: <fd29c302-3730-4fd1-aff6-ac80cda19816@oracle.com>
Date: Thu, 16 Oct 2025 10:21:46 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] scsi: target: Move LUN stats to per CPU
To: Hannes Reinecke <hare@suse.com>, mlombard@redhat.com,
        martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250917221338.14813-1-michael.christie@oracle.com>
 <20250917221338.14813-4-michael.christie@oracle.com>
 <03e53a96-d94e-4608-b52e-bbd87b8a90af@suse.com>
 <76ba1773-60ae-485d-a124-f2040bb07cbf@oracle.com>
 <5e272360-899e-4f27-8b29-5d696ed53ab0@suse.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <5e272360-899e-4f27-8b29-5d696ed53ab0@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:208:234::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS7PR10MB5038:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a92e8a-9ea3-4e65-9dba-08de0cc7b9b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RS9TNi9aaGwrZ0hxc1RPSUZ4dGZDRzNsYnp4Q2tNaXVQMERGWUZtaEhCNmln?=
 =?utf-8?B?akR1NmN5R21tZVdnYkF4RzlRck5FYUZ3VWhwM2pjMXQvZ05NTUV5S3ZqUjE1?=
 =?utf-8?B?ak8zQ2xaejRadExTbk44MFNYTUQvaGNoNFRacnkrYkpTZ3FhQVowRGVLT3Ey?=
 =?utf-8?B?WTh4R3V5YXZ3dVBGR3FBYlNJZXdYaFgzZEdaVlBoam9INzArWTBNbHkrNnhu?=
 =?utf-8?B?aFhlSVJiVkxmbTBlL2xxYWh6Q0Urck8yaGhXN0xnRUhSUjdaN0VYQlJML3Y0?=
 =?utf-8?B?OEJuSG01N3Q5Zm5QWVJ1VVZYTlNLRHJEWFkxejNEZHQzVWdVOHpWZmZ6YUlL?=
 =?utf-8?B?NjlCbGozNUxPUXhERy9HSWg2SzVUWno1THJ4cVQ2Uk1lRXJONllGaHVZdHEv?=
 =?utf-8?B?ZEdWb2pXZ1k3aEFvWUFmcmhxSi9tYjFKcjNtVEtiUTV5aE9EYjVXdlFGT2dn?=
 =?utf-8?B?Z2R4eTljLzAzT0R6RTBDNlp2ZVdxL01KQmh4b0xZVXZILzJ2RlBBdkdOOWxa?=
 =?utf-8?B?V0x2aHdGTTBBMzVQaFNSTzluVUhNekM5OXRoeVhKYkxlSTliMURRVzBLY3NK?=
 =?utf-8?B?OXBvak1vaHgwaU1xdWw0cFp5YlpMdlkzeUVHNU10NEVsQmE4cmsxWDdjcE5a?=
 =?utf-8?B?MnJXbEVIWWpCN3I3RENUL3hmUDhlRFRMN25aYzIzZlRGa3c0L2FBN0RnVyt3?=
 =?utf-8?B?cFRiZlB3dityWW1OckpYVVFFNWtWK1RwWmtEUlZlRVNyTlVEeVlqVDgwdlJK?=
 =?utf-8?B?c0E0amJRbTMzcDh5ZS9pVi9PeEpQbkx1alVpd2FRd2RJVEgxQ05XcFNnaHJF?=
 =?utf-8?B?Q0w3UHh2U1N5dytwRFo0MEp0MElWSkQ5WkhTZlZwM2hKTDNsSFV0TzBaaExa?=
 =?utf-8?B?cDJqeXRHYVFLTzVTbDZkZHpGdS9objdxdlNLK01pcm5lbWdRTXoySEtuM2h2?=
 =?utf-8?B?OVNrNm1KVURCN1NwL3NNcVlsRlh3RVd2bllzNUt6Z2VpU2hwZkxKTGt5dFhD?=
 =?utf-8?B?bURSbUVqR05VWWNRMU9aMHRVWXBFWVQweDZ3alg3dUwyTnRYRzhPZmxBMDhZ?=
 =?utf-8?B?ZGJpTTVESjBXUkIzOWdoTVR5TGQybW8wcWZKMkZiYStSRkRZbHlYdG5tbW9v?=
 =?utf-8?B?dHBWbDBqVHppbW03TTB5Z0FUcTZRUkRDRExrOGVrV2lrM1NyTEJpOFdLUFFn?=
 =?utf-8?B?SnVLMEpxaVkxQmR1cTVrcldmNmNtYjl6NUdKWEdHTjhHYXVwb1Y5UlJZaE45?=
 =?utf-8?B?c2k5Vy9pRjhCS1JiNndvY045QWRvNmxNZm51Zkc5elVSSHR3RVFVNUtqQzNN?=
 =?utf-8?B?VTNUNnZibHp5aTBqd1ZJTVc1UDk1dklVT1hrMjlxakJ1ZW1HUUtQS3pOZm84?=
 =?utf-8?B?OWJ2WnpueFVwSEFRWU1ibEF6VGZvWVpZNkY0OGFkaUJPTUJoTjhFb0xYTnFN?=
 =?utf-8?B?bkVpb2pGM2ZWR25KZmdvbE9LQVkrYm1xeWRUYlNuZmoyMkdhS1hVdDhuL1Bh?=
 =?utf-8?B?N1JLb2lMZ0hNRUU1OEdkWHZBUm5IdGNXVmFORFc1aGFFalRCcmNRQ1R3Qllh?=
 =?utf-8?B?eXRPVGFqUjNkdG9hREQ1UmRsazNuZ3hKaFFMd214NHFjRE03Tms4Y2hVL0Nj?=
 =?utf-8?B?ekFhVVRIbzVaSWdPK0Z1ZXBMUHNRTXl2UGdNcHU4TWZTODA2VU5vcXdNNEF0?=
 =?utf-8?B?b1VpRnpSNFNTZlIwaml4VzhYMHhldlFJSTBObEJObXlGZzJOdFBsVGRUOTRM?=
 =?utf-8?B?dDF0WmdlMUgyYVgrcW0vRnBlaGdLb1FYTE9vbjFvSWJtVGt1RHV2ZXo3bUtr?=
 =?utf-8?B?dmEwMjBJaFp3RVdnU1FuWlNCNW1Pd0RMdmo2QWxUM1l6Q3hhUFdtSWoxcEFx?=
 =?utf-8?B?RTRrZW01UG4vUzA0NEpxeDgrMGkvVmVhNE9HL1MyMzZTdFVad0pnbWtjQnIx?=
 =?utf-8?Q?4PGMATWWjoQqVvMnSt9a4UZ0JMIY8rCv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OXdPWGxZNWNtOFZ4Skg0TGZrUTRYeTR2aFhPc2owR0lsWlRGcDZGYkRYbFBL?=
 =?utf-8?B?aG5hT0pzTGdiMk9ha0lBWlc0R3NvSTF0eVo3YkxDa0JmYkxUR0tDdnpHaUhW?=
 =?utf-8?B?d25uOFVPUDhneWNLMC9vOVpRLzlMSWJnTit2VzZRY0E3OUc1SHM5eG9YTU80?=
 =?utf-8?B?NElzbEtaMkNtYm5KYmcvb3BHUXB6SHBVS2FtSm9STGNBR0c3V2NwcldoNFVJ?=
 =?utf-8?B?eVY4dWFqOVBGakc3QjFqWmk4V3Y0SXlTbnd6ME54ZUVzYythcGFPeENEMGJq?=
 =?utf-8?B?MUlPbzRmUFAwZUdERkNOM0ZZSHJWRWgrLzhZMmNscUJwYzhWbnp4V1BuRDZv?=
 =?utf-8?B?MVdVSjhxaUNFbFlYUDBnK0RkSkd3SWUzUWM5bHgxOWZOZW1wZnRESXJJcVJ2?=
 =?utf-8?B?N29BdjBaS3NoaDN5RXJLRlA4dTU4S2RzQVd2dGcvVlE1T0kvdDJmQzJ5V0cw?=
 =?utf-8?B?VHRQYWpBc1hvQ0VGTlFGWlhkOFRyRnUyREF4bFZtU0x2WHZwRjhoWVBzM1ls?=
 =?utf-8?B?cUpSZXhlM2xoaXBKaTVUaklkeGwzbEhoeGlhSER5cGx3cWpEY0Z3Z3lVUkxh?=
 =?utf-8?B?b0FTMzlkam9JUy84ZWtXVFRiQ0t5ZTJXLzFrd0JLRE8wc2JXZ1hBeFViY050?=
 =?utf-8?B?L20ydmZ2ZnFUVHdYOTNFQVdXQ1N6eEdVK2tTbHMwNk5zUFRLd1ZRVDIxTG0y?=
 =?utf-8?B?SVU0Mnc4UUhGcXJEUWVNN25pUDh1V3JBd1RKemNvTFlVcVNheGZPcFlHUFU3?=
 =?utf-8?B?QUFST2UrQUZ2clgxM2F5dXhiUlV6K3c2NCt1cUNrOTh5bkFVeVVZOTJBWnhw?=
 =?utf-8?B?aUhpcTRJa0JRejAvT04zQzBCN0dvL0h3bXdCeEgvOE9qTjFldTl2UWxOR3cr?=
 =?utf-8?B?NmtUWEJJVjEvQlBXSlRTNDJodzJ1eVgwYVphOEM0c0R4QldzTHJTelNWeWxD?=
 =?utf-8?B?eEE0SW9WMXJVRGtSNi8zWEFaTWVvVTZkTHZiWHh5NHk4MWFGdTRyZ3czdlhT?=
 =?utf-8?B?TXJrNnhJRFpOazNKQXpVUjdSK1hVVDJIU25Ta3NQSlRvV0NmOEdtWVhMMHlW?=
 =?utf-8?B?Z05LVW1NTG1VcUNiaUQvbGZDYVhiRGZiSHhraUh4ZkRYYmFxNzNkZjJhdE5S?=
 =?utf-8?B?VnZWcUIyQWtxOER2UFBkMTNUQnBxL0M5czl3elU2eGtuMmllMXp4VUg1N2xV?=
 =?utf-8?B?TGF5N3hRVC9pdS9JT1BJMjZqUHQ3K0NkRHhqRkd2YzBmRFhiVksrK2pDQUFW?=
 =?utf-8?B?L2lkZzhNSjVWRVU2TG54RXdXQTIwRGxUZzlvWjZldUIwS25XNEFEZGQySXYz?=
 =?utf-8?B?WmZLRE1rRjVSV1hNeFkyOU0rM2pabzRGaE5GZ25LRkdEVk9ZMitHOWNQaDkz?=
 =?utf-8?B?czZUZ1NIMTNzYjdzLzFaYXlZR01PYnMwMjg4MGJMcXZ4K0xvRXU0ZWQ2UFo3?=
 =?utf-8?B?UkZFdFlqVkxSNEs3S0xicFhzU2MzSm5jaFFpUG5EU3lNNGlVa3BCd3paS1pH?=
 =?utf-8?B?d3dxM3crL3R1RWVjekFhNWY3MTlHM1BtaDRxWWZxTEJucGRWVWRJc2JvblBi?=
 =?utf-8?B?MTFOcGRJalE5bHpnQmxxR1dpeWoxV3VNL3ZvQndhSXhKSkdZN1Q0bEN2M21n?=
 =?utf-8?B?VGRsajBRU0FqbG9xeml6OTcvMlVvMHBzQzZEWkZNWjRqeDQ3SWFXL0RzU3Fr?=
 =?utf-8?B?bHpPWmpyeGFmSG1NdVNTa1NzWkZ4QTRNQXVWdDVGd3JsaytIWkpIT1N4Unlx?=
 =?utf-8?B?RSt0QmFIODRIeEoxeWRFc2N4a3FQdU5MV3pRdEd0bDl4ZzRYTFIrdDRteTFK?=
 =?utf-8?B?TmxZTnN5RnJ6VVZnTS9MTzY0QWUyUFBsdWl3ZFovS0xBUUcrVmNrY1lES3V3?=
 =?utf-8?B?UHREa1V1ckF5cm9pVUMva3NhZ04wYkhuMlBPMGFsV2FTNURBaHRDbnk4ek9E?=
 =?utf-8?B?S28rTW1jNmFNanZpSTFqOS93NE9OVjJ3cGF0VGVrY1JBVlRVUnV0Sm1VZHM3?=
 =?utf-8?B?ZVRMckdUSkE5eGFSUUpPbmliY0JsSHg5ekFJR1lqMCtzTzVkeEJWNzhTN3p1?=
 =?utf-8?B?YnA4TzFsSTdjRm0zZDQ2TmcrQ3JzUkVQVGp6Uk1BZlM0cFpQVU45SDRkZXdi?=
 =?utf-8?B?bU9rSDVZcU1tbTNPMmRDZXZ3eUN4OUFzY21yd3ZGdndCZ0dRUCt6L2Q2TnpP?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aXjUScNLRaTFWJ3bmOwxK7veDFt8RHRyrWLcUQ/S0gjm5R31HUKrUg8jNAqX2gPK2TVEJrDX+ifv2oAGU6ilBs1JozulVblGjzqa6hEwytxU9H4/dIAFfMaQyik9+31O02oP5gaorbS4ghI24COKF2tGwhLRWnDrm2/yXrUHOmnZIfgSXcnZnBB2bAEe53oW/+mFd+z8K4fXkKGbSr0lVn6l6RLiFDQiTp0lLdObz0W170/cYoy67BFzrhQ9gQO3B35ztAGLGRHQ69cezqKhk9ajLa/gSRuBto/uIXUTutwOaA2gJMfiTai/NBwHI7D7yoqv9LxVAkrk5YYfMiKu66cXyskbVi2/7XLMdUQkRbDudTC+4tTwMpQrMqh5CyvQkM/qrTsIFL4axPQOA/KCx7FoqNsAGZLUhy/iXox1GITeMPQff8wP3+N+J0sdNlMXNfJuLkvEg6iU8brCxxPCM0MICeh4JeXT5p5wKpZGJSrbrRWkbuDwxowm3OC4DG4O/rI6nPOMiLJILadPhZ7Hwerte+D+3YEe3g8O9uHhtVzfwTTUPZeF2nEdW/2J37K4BNKsZCL9rKH7LWNOWsm2RR+BCdmPwqmY2olmrXDH1pY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a92e8a-9ea3-4e65-9dba-08de0cc7b9b9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 15:21:48.9289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /UeZBP7MFK0h5MOt8cjoM6fIeoQ5E4fRWqVLo03sak19I3IgApcy/NbmeWLAEBSD67CSlLRu/JpgwXw9XEao51a1EZFf25VY1nsod4ThHcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5038
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510160111
X-Proofpoint-GUID: vusVAhbFi55ozNv-T6POo6BaCQG1XE1o
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68f10d91 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=-c9VzbpeAAAA:8 a=k8JKQ-SPUqrC8Erv4ikA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=WAq88MDkwfy8HpmZFCM0:22 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfX9CfWOmW3e2it
 u7heV32Ak+PNfwTAi61Hsgg7jEfbiy0mCohUpXPCKK8XWeQm1yQTnmGohs35AZ4yt/xhTj7F0f0
 2B33FxGdvBydnSxwL13B2uB4y3t0S5yYMHHsuoQFQzCerkXjU+SMIB+mErvdUS9/urmNc34Vu9h
 8IPGubuhQqMz96xu9xIoCgnB4pEi3Quz+trCpEd5Gn5p89gt9uqbuPSS3ZJntONeiggeAvxMs16
 czfYOLD8hkS30GvlvDyH8FC+IVLJKa2m+KiEweEoPPqsIDpeo4znGI8dM2HUmvjf9eUVCSDy6yf
 IySwRiHXQaNP+Ks2xFGSDNPwazaULF9fCBVfsq4TI8K4ITClqubdGn3vvhRnqfjxDwJr3eHtZQ9
 H/defliDyj/ePHVk+T3yuv5QR8HVdFTfedMMVJj1DG2sBAzV4/g=
X-Proofpoint-ORIG-GUID: vusVAhbFi55ozNv-T6POo6BaCQG1XE1o

On 10/16/25 1:21 AM, Hannes Reinecke wrote:
> On 9/18/25 16:50, michael.christie@oracle.com wrote:
>> On 9/18/25 1:31 AM, Hannes Reinecke wrote:
>>> On 9/18/25 00:12, Mike Christie wrote:
>>>> The atomic use in the main I/O path is causing perf issues when using
>>>> higher performance backend devices and multiple queues (more than
>>>> 10 when using vhost-scsi) like with this fio workload:
>>>>
>>>> [global]
>>>> bs=4K
>>>> iodepth=128
>>>> direct=1
>>>> ioengine=libaio
>>>> group_reporting
>>>> time_based
>>>> runtime=120
>>>> name=standard-iops
>>>> rw=randread
>>>> numjobs=16
>>>> cpus_allowed=0-15
>>>>
>>>> To fix this issue, this moves the LUN stats to per CPU.
>>>>
>>>> Note: I forgot to include this patch with the delayed/ordered per CPU
>>>> tracking and per device/device entry per CPU stats. With this patch you
>>>> get the full 33% improvements when using fast backends, multiple queues
>>>> and multiple IO submiters.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>>> ---
>>>>    drivers/target/target_core_device.c          |  1 +
>>>>    drivers/target/target_core_fabric_configfs.c |  2 +-
>>>>    drivers/target/target_core_internal.h        |  1 +
>>>>    drivers/target/target_core_stat.c            | 67 ++++++
>>>> +-------------
>>>>    drivers/target/target_core_tpg.c             | 23 ++++++-
>>>>    drivers/target/target_core_transport.c       | 22 +++++--
>>>>    include/target/target_core_base.h            |  8 +--
>>>>    7 files changed, 65 insertions(+), 59 deletions(-)
>>>>
>>> Ho-hum.
>>>
>>> That only works if both submission and completion paths do run on the
>>> _same_ cpu. Are we sure that they do?
>>>
>> What do you mean by it only works if they run on the same CPU? Do you
>> mean I won't get the perf gains I think I will or is there a crash type
>> of bug?
>>
>> The default is for cmds to complete on the submitting CPU. The
>> user/driver can override it though.
> 
> Exactly. And the transport can interfere.
> But if they do the stats become garbled as the completion statistics
> are added to the wrong CPU.

What is the issue for that though? For this patch and I think every
place we do per cpu stats like in this patch, when we report the stats
we loop over all cpus and just add up the totals for each cpu and report
the total.

It's how percpu_counter counters work as well.


> Can't you store the submitting CPU in 'struct se_cmd', and then use that
> value on the completion path?
> Then we can be sure to correctly update statistics in the correct
> per-cpu slot.

When we loop over each cpu to calculate the stats, then you get the same
end total though, right?


> 
> Cheers,
> 
> Hannes

