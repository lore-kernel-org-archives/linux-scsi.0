Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4C5348C51;
	Tue, 19 May 2026 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779198897; cv=fail; b=WJS45koF1Iui36hGq9a4pVFlAGB/aDic9lTg/eJy9zcMYPnlYkwInKY5EaYulPU6YBzBTmBS7IsFKNMT18M+J9D8bBEtKEawAQeITyIdyhMY4eD6QrKv1cZBgkgCo/c1siCnN/dRFOw520WBXvuNgoZt1rN9uM2VZoHX6u7VxkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779198897; c=relaxed/simple;
	bh=l2c0zqbjgiNFcusQWouOGJ0qIGvBaaC4pCh6GQSy56k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O82TUwtJda+DVeN1pMZlVzMZJlPGXuhpL9eZPfDStt493O1vhZ2QxGY0aDcrELnT5B2A7RoBKHdaY1DfYdMkBSr5iIkeskQ+/+wQTtGXfnZT5rEyit1iVaTGKoEwtUu2zwMJDeCpTJ5fQa8B8N/tD1hJhOrQLU4/OZr3484nhC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=KCfCnug9; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="KCfCnug9"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JAxQLi3722321;
	Tue, 19 May 2026 13:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=d/qGQMxsYYhcVQ6YN7gSvbtcR+aEFjedcGBERrRohtQ=; b=
	KCfCnug9w/JGBTqVsAR1U739ZhiioLDL/lCU71Ai1lAiRk9954fmbO0ar3yXM5gz
	nnJSxOiTEpKQwd+/FhxLUgHTD0r0hFdgRpeKWcQV+Uoqkrtgag+Qvy78dT+qbkE9
	i3cEjb0ChQ1LibHaeuwh4cVbxhwcQgIp/fSa/x8BjPRLqWmZ11iX43tcKJAg/eSq
	mTM+w7PBPpQRkS7j3Q8wSLoYbMUchTorsDOKVy0A2Xiiplmk/P9atQbsi8/ojx8p
	p+qJ/nqUZd/W7VfbWJ/R8RESnzCEi3tpb7jXItNI6GRUvg0mfMz8iB05GV0yMu/v
	UyX6A2oDoNVxcc8++RNYjg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4e6ecf3q20-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 13:54:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzTByNkmQRmwpxNxt1o651n8uPHxst9i3KtfvsjeHcOTqjTh2ZV/6CiVb/ZXrugMYXZ1Yak93wpGl7GKQg/Viqaa7ls7Kj3nVrFJ4pGs1FNepf1eONFlp1UlqLrfq4HFJ7AaXwbnJHVWTA+3DcbjyriDtvou1l29aJ2HsUwfMJpTRDpfIeqYpTeoP9NycI5/qjuxL6jbJr683WJ0rfoJI2rlCdZrGq6Up4DSmtrTaViZz3vPKpm2OcHpzRP5W66Z1eIeI6cL91emAm2ZInidlXjMNGafgiNxEu8+8hn/6g7kiuZAt1Cty8wvRipXdhekrzw+HVA4PIKS5b1wx6jQBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/qGQMxsYYhcVQ6YN7gSvbtcR+aEFjedcGBERrRohtQ=;
 b=JcgBaoDTW3w++l7uCBODSwK6e4c69JUdlEk+qnbitPfF4NSuk8jDHtfUpa7AC4+WLsOTPeBJF0rLx3UwLVBWU0aZkvNkAWEwjufofdq2PvHDOVaoKdO0sJ/5kzic3DsU4CAS2vmAwHUCAu/UXt4P0iKhUuWYNXBiKEtcHPqQglr39WnDhulo0GhAMvd08ZkLjRIby+1llI/6ioBYPTinRUQCIhklk5/6XW9mi3aVcblkCKpP7KqSBn8mF69SVEmeLKhgkrANKRWLhLAfZFhrJz9DtDGgJVAhTIL8TNvcmoFEQNCjL1vNgLxQFoNpOKjpwHpuabhGe3yOZqVT0YvBoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by SJ5PPF0DADD6EFE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::80d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 19 May
 2026 13:53:14 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0025.022; Tue, 19 May 2026
 13:53:13 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v8 1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Tue, 19 May 2026 16:52:33 +0300
Message-ID: <20260519135238.373784-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260519135238.373784-1-ionut.nechita@windriver.com>
References: <20260519135238.373784-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P190CA0045.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::18) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|SJ5PPF0DADD6EFE:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f061a6d-a878-4d1a-3d55-08deb5adf837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|38350700014|11063799006|22082099003|3023799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ZNK/vi8ovsCvePtErNIV6gN1fjk/26mzAvoI3XpT9Yn1C2wiFEVJq/VyZ2EXMyHjC/iKqB9SZj1nqAiI+4K7BnKUNxYhq5wFMMDCq+no28SA3ceRElM6DjkAEZEC2mkTvTB6B5WNlUBKqkOEPeAhyByI/LdcEuZ2kS+WWMbIQpk707pgBGOTRh0goGOUswjNNIYgR7mCjhXMuqAfbaxrOijGYl0ak/RdgdOmU/+Sy5wgBz6q+LzAhBeLGwZEUvvU/iy9L3vbvAjMC8uA8CXaCWHwraU5cAICOdPgV2pthfWhunawLWv6QKgOAkrv0u3FzxtgcGkAi05ktiR1oF+hDFY2KweIRUrUiVE52flownbiWQINiFXIhwrEBtT1tgBgUqGntYy/ZI3xn5Z6GbLksYFgo18tQk6lSL17xjJj47o5OrQlqUekiHwQjATmLIh4M900DJjURvb1gttknGyhDxB+ot9rFiwFmTj2ixVnSXlSpbxoqInm8/xLDzAS15K2rrwInguA6DlLW4kyKwSZ1PUJlRwHyYm6Wh4hdGBjqaaT0ha6wFL+EnHO1w+ZJZwOoOFmmkuRmLX3HvVk3uMm3/DhWfk8O0y+XV3CfnJQWgmk5q00daNgzl3xPyAHvz4EQb2Uor7GPWyqrgl/5IEcd9JT0DXIuSZCluEqxiQw7voLuaHqBXbRNij3hCA2y871vjZ3buJnfNxf1jo3fEOFuKz5/08HA3KpX0FqjhOr0EnjUfZbXqQmZbLkkI6PBwbW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(38350700014)(11063799006)(22082099003)(3023799003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkRPWStvTFhzNXFhblZwcVhzS2xMa3lsaWpkcHdCMjlJRk1MVlVLWTQvd3U3?=
 =?utf-8?B?RXpVY1ZmOUpYajRPMUpkbzZ4M2hiR2E2QXFFL1hmeTM2K1VwVWdENDB4YnV3?=
 =?utf-8?B?V0lIb1Jxa0hHN2lKZVdIaFdvWEpNS1o3Q2lEK2EyRjhEZ0lET3BxaHNYbVVy?=
 =?utf-8?B?WGNVbVRwcFdUMFJVUDlVeXY4Vm5OTkNOMTBCZVRIQjFDOWJQZ0M4c1RRUFZO?=
 =?utf-8?B?R296QTk3RFowYTB3NVRhUFlBMXdzaVpoUVJlUFM3dlBtczRKME1Jd25Wb0sv?=
 =?utf-8?B?R0VTdG5HeUlDVjVIekhTWmkwM0ZRalZUUnR4OEt2L25PNzBwaFE0c0RONXI5?=
 =?utf-8?B?L1N4SFlMYU1vSnJrbVpsbWpDeDJObDUrNFdtRU5lQTR3KzRaRU1FelRSRU5i?=
 =?utf-8?B?NEN6N1pGU2hZYzB4SFd1TnBpM1JiVFRDL2llRlFqUXE1d3FlZmZ3TS9sNkVG?=
 =?utf-8?B?TFBrMDZ6UHF5Ui8xWmUvczVEc2ZsS2xrdzVsQWV3bnB5V1crVmlSQjN6NEJj?=
 =?utf-8?B?VDY5Nis0bVk0SmdWTWlUS3EzR3NBK3JlVHF5MTlUWGljUC9Zc3U1SUN2MmVY?=
 =?utf-8?B?OHlzS213LzNWVTFvL1h3SmdKSFRpR0VOTHBhUFByV1doZHcvS2FBR2dqUXBT?=
 =?utf-8?B?dk1qSUFQbDdIckp4WXlMZnkzUVRidUFmR0hVeDJhalREbXFyNkRQc2Y4WGpL?=
 =?utf-8?B?elkya0hrbUxQUXltMnorMmxKNEVQakNDYnQvV3Bxcmo1MTIxcHRGWHVMOHhR?=
 =?utf-8?B?U0RwbGE5RWFoTXdqNm5hSW1NZmlvcmVxTVVuQnN1c21QcDh4VFM0QW1BQ3BB?=
 =?utf-8?B?SDhDMzlyVFlFMmtVc0VtL3QrSm5FQ2FpS1p6VkxrQk5FdnI3K2U0UzE4YWdL?=
 =?utf-8?B?VE1CWWRRaHUva2dUbktMc2twaVpMZFhvM01MRWdtT1JHM1FxWVpJemplK3RD?=
 =?utf-8?B?dlZaWDYwcVRKRXRWNWxldTZ5V2pSVFRLTTRJSjBEWFBMYmJ2UjlXc1h2Nkc1?=
 =?utf-8?B?TlE2czkzT1JCTkhFbnoyWnZDYnBJTzZwL0RCMk5meFdEa0hpK0k5OCs1cGpx?=
 =?utf-8?B?UDEyeDBYQ2YrVW1jVk9SemdvUVRRNmUzQ1Y1UlJrbThQaHdkN2xRMVJGQzcx?=
 =?utf-8?B?TUpFUzMyOXhmNFRuWHhDdTV5V2hHMmlXVFFNejZ3SXNNTzUrRGdLRzhDQzZI?=
 =?utf-8?B?Y3VFY01WTkE0TGNlSlBDNS9JMUhHcUtGdGs0Y2hjUXBrenBpUXVhUVdkdXRz?=
 =?utf-8?B?SmJScjBORmhlaG02RWN5dGcwTkdUbXhLVWVaVjNsaGNwdUkva2x1Y0ZNVzI1?=
 =?utf-8?B?WkEzMzN6ajV6TDNoNTd2NFpsL3pVeTJCVlUvK2VEWWJUUzliN1UySjJIam9C?=
 =?utf-8?B?UzB0TWFxUy93U0FsYXFiQ0R5SFhWYmc3SlZsMUh1SXlxNkd0Q0ZVci9VWTJB?=
 =?utf-8?B?KzU4ZGxLV2tLbDhvaGlMaXlFcUt3UGl5K3IreVgwVngxZ3FQN09vUnp3VTdI?=
 =?utf-8?B?K1BBYjg4VGlZT2pGUFgzb05ZaDBTN3JRZTd5emQybkozMWRLV0c1UFhBaDkz?=
 =?utf-8?B?TFR1QXpBYWRxcjUzeXN1RldvVDlYeWJUUGZRWExadGxEQVAySkVXUmI5OEo5?=
 =?utf-8?B?SW5Ud0RzZ0hDOUVkdmRsbkoxQllFU2dGU0I2RGIyMFVodHdrcEJQL0xKOWJl?=
 =?utf-8?B?Nnc4QnNHN2pFK3VHQXVacTdnZmtkVHhJeWVqcGQ2U0dWcEdja3BYS2NpckFW?=
 =?utf-8?B?Sk5BU2FZaDNHOVFXVXhTdXdFOVVQRzljUlV6dzNMYi92eEJJU2VkNFdrc3ZB?=
 =?utf-8?B?c1NvK1N0Wk5May8wK0ozUjRuN052U3BOL0FNQVpoNWJFMEF4NjFVbVk3eU5x?=
 =?utf-8?B?VzNZUnY2cmtJakx1cTlMNnRFTjJFNHU2bGpxT1VIZ0luRlUwQmJyckxhR1lV?=
 =?utf-8?B?ZEpPRytOdUtFcTNyUXJ6RFRXQlBJb2RTMFlPMU1pS3h5Wnp3MHRXUEFGQ3BQ?=
 =?utf-8?B?dnd2N3EvZ3NPeTVtT25lTmlRZDFqeWV0QnVOeEI5UXNqMXhNRmtWQTE4TUxh?=
 =?utf-8?B?eGtUNzdVNmdxemc0a0dJc0pjQTQrRTBsTlk4aEcyT2VFZlVTOEp0N2l5cm01?=
 =?utf-8?B?bzVQWmo5WTZBa2ZSelRUVEgvVm5Mb3BzVDZPTXpyWDBScnRaV1NVMm4vVEQ1?=
 =?utf-8?B?RVZURSthK0VuNzBsY1hoZlNSeFVXTkRDaUhQQWNIYlJPMXdxeU5jMmU5amlW?=
 =?utf-8?B?ZEtkWlpldlhiL0E1eGtSb3E5bWVUK3RaRVZSTzY4NWo4UDBCTVBBVmF2Vmkv?=
 =?utf-8?B?UHJrcDB6MmQ4VlZKa0c3ZjBtaVB1Qi9vOU1iN29DR085MGYvd0ZtSzIvSmVp?=
 =?utf-8?Q?MZN/OBKnbv3B1neU=3D?=
X-Exchange-RoutingPolicyChecked:
	i4AwAQ0CZwYwY8QL/39swUz904PeunheNVnsyXeaLW8svh1lxEamywelLoxgwrCv9SrY3/UEvflsrGykYbkgN2ChwP1tHUc0wmnusYKuGgHsyY0Opt95UyZC+yzT+BZy/9BR++C5Q2OmMEcxi83vuy35XEzjzoIIlfx8M4mB5rL6bq0tOOLObXXMwwUsrEYsCrYyO3TYnexxOKcYiqlo3MOge/EZO4DcR/eN5v7rzL8SwXVUz/vFEbvYo4ZDddywgoyLhqCgj3N+aWEw6xFYzjSb1ovLPA4lQTybJ/z0Y5faAdj8FkOLluWAapvMV0l5czkkovHYiN43XCbAwFbZKQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f061a6d-a878-4d1a-3d55-08deb5adf837
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 13:53:13.4186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCxVT7nkwEbF/3An7Sh8lvptqgh/qqhGCuS+P7QwLOz72mf3Z57zK97YcGbYJaR4ljTizRasz62rAzI91Hs0PdMD5oDeA/O6e9nY5sYBXuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0DADD6EFE
X-Proofpoint-ORIG-GUID: 9YoD6SpskaBWCCxISe84WLEB90-6yWCK
X-Proofpoint-GUID: 9YoD6SpskaBWCCxISe84WLEB90-6yWCK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzNyBTYWx0ZWRfX0yH3l+S3vKrX
 gypX2vPnDEJeZQPIZVDhO2wUndVHdlJqFr9AL1n0EbZZJHcJIb8HKw8w0SaSN9OPG8G6Ta5VraC
 NfFiMlXZ3w6IIa3XFMlhNkZufQp3r9qz9G/2XbkJ6cMbqQ/Bjyz9g7nMuaynM7lJEep8ZFnfRkP
 gFwm4AlH94olMP6/kY5uJn7MlyLS0K5p0CI5jRUo7uvG8PYntn7o433zjGfQzKWsHvCXiFXVjnT
 DowwjGYR02xVbHvU29/Vtg+/LRFSLWbILkW0n5pbQOTdbS6v2Bet/+TMZNzvLI5IVjpxfSg5DzC
 sBnjlT+T2Q5TfuHDMJsZuWzHkkBLPFDfEJca3PS74Bm6KtD0qhritr+z/dSJNBvWPd0qHeP7ugN
 9BYbTNM14mBUSfWzl71wASHVq20lAQvoOPL0VPw8cqCiEYf8az97Z1s/4Dx6Cr0FNwRY770V6PS
 4SYNgHDPwnmkQ8zxkvA==
X-Authority-Analysis: v=2.4 cv=dK2WXuZb c=1 sm=1 tr=0 ts=6a0c6b89 cx=c_pps
 a=xqAAW0zfUN0YSepx5EhcMA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=v1UvDAFQwqQqS176xjIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190137

From: Ionut Nechita <ionut.nechita@windriver.com>

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().

When the IOMMU is disabled or in passthrough mode and no DMA ops provide
an opt_mapping_size callback, dma_opt_mapping_size() returns
min(dma_max_mapping_size(), SIZE_MAX) which equals dma_max_mapping_size()
— a hard upper bound, not an optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) does not report an Optimal
Transfer Length in VPD page B0, so sdkp->opt_xfer_blocks remains 0.

sd_revalidate_disk() then uses min_not_zero(0, opt_sectors) = opt_sectors,
propagating the bogus value into the block device's optimal_io_size
(visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by introducing a sas_dma_setup_opt_sectors() helper that sets
opt_sectors only when dma_opt_mapping_size() is strictly less than
dma_max_mapping_size(), indicating a genuine DMA optimization constraint.

The helper computes min(opt_sectors, max_sectors) first, then rounds
down to a power of two so that filesystem geometry calculations always
produce clean results.

When the two DMA values are equal, no backend provided a real hint, so
opt_sectors stays at 0 ("no preference").

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
Changes in v8:
- Remove dma_dev->dma_mask check — dma_opt/max_mapping_size() handle
  the no-DMA case gracefully by returning SIZE_MAX (Christoph Hellwig).
- Add inline comments explaining each conditional (Christoph Hellwig).

Changes in v7:
- Drop redundant !opt check; the !opt_sectors check below already
  handles the opt == 0 case (John Garry).
- Add Reviewed-by from John Garry.

Changes in v6:
- No kerneldoc, short inline comment, removed WARN_ONCE, combined
  checks (!opt || opt >= max), rounddown on min(opt, max_sectors),
  restructured as sas_dma_setup_opt_sectors(shost) (John Garry).

Changes in v5:
- Expanded kdoc, inline comment at opt == max, guard for opt == 0
  before rounddown_pow_of_two, trimmed Cc list (Damien/James/Sashiko).

Changes in v4:
- WARN_ONCE for opt > max, min_t overflow protection, reformatted
  call site (Damien Le Moal).

Changes in v3:
- sas_dma_opt_sectors() helper + rounddown_pow_of_two() (Christoph).

Changes in v2:
- Single patch fixing scsi_transport_sas.c, Fixes: 4cbfca5f7750.

 drivers/scsi/scsi_transport_sas.c | 43 +++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 13412702188e4..ebd063b51bd6b 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/blkdev.h>
@@ -222,12 +223,47 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
  * SAS host attributes
  */
 
+/*
+ * Set shost->opt_sectors from the DMA optimal mapping size, but only
+ * when dma_opt_mapping_size() is strictly less than dma_max_mapping_size(),
+ * indicating a genuine optimization hint from an IOMMU or DMA backend.
+ * When the two are equal (e.g. IOMMU disabled / passthrough), no real
+ * hint exists, so leave opt_sectors at 0 to avoid bogus optimal_io_size
+ * values that break filesystem geometry (e.g. mkfs.xfs stripe alignment).
+ */
+static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
+{
+	struct device *dma_dev = shost->dma_dev;
+	size_t opt, max;
+	unsigned int opt_sectors;
+
+	opt = dma_opt_mapping_size(dma_dev);
+	max = dma_max_mapping_size(dma_dev);
+
+	/* opt >= max means no real hint was provided by the DMA layer */
+	if (opt >= max)
+		return;
+
+	/* Clamp to max_sectors to avoid overflow in sector arithmetic */
+	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
+			    shost->max_sectors);
+
+	/* Guard against zero before rounddown_pow_of_two() */
+	if (!opt_sectors)
+		return;
+
+	/*
+	 * Round down to power-of-two so filesystem geometry calculations
+	 * (e.g. XFS stripe width/unit) always produce clean divisors.
+	 */
+	shost->opt_sectors = rounddown_pow_of_two(opt_sectors);
+}
+
 static int sas_host_setup(struct transport_container *tc, struct device *dev,
 			  struct device *cdev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct device *dma_dev = shost->dma_dev;
 
 	INIT_LIST_HEAD(&sas_host->rphy_list);
 	mutex_init(&sas_host->lock);
@@ -239,10 +275,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
 		dev_printk(KERN_ERR, dev, "fail to a bsg device %d\n",
 			   shost->host_no);
 
-	if (dma_dev->dma_mask) {
-		shost->opt_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_opt_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	sas_dma_setup_opt_sectors(shost);
 
 	return 0;
 }
-- 
2.43.0

