Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA6385527;
	Wed, 15 Apr 2026 07:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237609; cv=fail; b=swJgjvZcWqwNdnnZ+Z0p7M0fYL25SnPHi2+5Q8ZAuiciNct1lPA0SpPlycAs9x79gx0+oSvVIPl3/KbQs+2UxnzJHmvMDmL65qunS5gVgQD0GiKdUsFWR9RRX8M/DZ8Sm/FoOhEGKlgjUG07lYjHh/Rka8ZgB4EVh4jlIbfFYS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237609; c=relaxed/simple;
	bh=98w93mUH8zVJ8/KZY/Q/gUBjbaPAXKyO3iiYig+jCfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oUZYmSpvN/EHeUQ0lKCuprdPwYXVRwbRxOV+pgI1bILaSHb40a81dx4csihRBRNsXk3G3mYyIZbYluz4E+p4ubY99WnQE3vszF90R8j1AaWsnDYvfxveQmXOSIzPKgiAjBCe1PRIP+Qvr6+U6eaf6rbKPO8Jkv2wzfC3nbWvnB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mDnFZeqt; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mDnFZeqt"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F3EnTb1808112;
	Wed, 15 Apr 2026 07:19:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=bw60aoT/kbRVvXhAGQ0gojlh/6GAzDYz/g4uvyJ5tuI=; b=
	mDnFZeqteXKGgKU/Z2iPkZhoWUH9mXlTIcJbWrcbrBGedUKCvCxkEolCkkpbVRPu
	BHex7ksGmMI5g7QYbuEBiCkKgVe06NLt3Y+sXo+aj3dN910IiSoEDJecPZe20FZG
	x5sMKBHolyV5kAwtdy1a+KiAvYTvgd7gAesKcg2t5SySHK2zQfnfIBPhbjavITMc
	A+2wbJZMQ0ROO5XXW1AIwIfeZPnNh6y6+Prgz+J5UwQkTXy8xfS/hshTBdRugt+j
	Yl/6f08j1mghHvDmFtWbfhpKzQBEg/p/FN3Ag4MU5KSkAYYHHD0ys551EyJgQT2z
	B0lWkF0thZqOSYuk9ve7yw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010000.outbound.protection.outlook.com [52.101.193.0])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4dh87a9pry-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 07:19:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LWj/mnUeXzYXxpNu7FXJBwpVg6w1720eD9kt7xVMcdpo/v/fW4U91ngzACtfWTTMc/dYt/JsEaSY86iOBqNhSz6G6MxXBbN64HB7yRnraF7sc2e/bECSrw96MDAYU7AWcDbcJsNT+5//t9HlJEpv76G0oMLUYYoAzy8gMjHxv2DTgiWtmt3QzvD4NgqY9SggF6qkc6JJJcaUU66YudJO28kkVPa8ochUxTupVckwj5LkG4T4wkar2PwoYbhXbV8pqTigBt1eEXw38Zqa4AfH807hnUcBBSRT/N4WV14yWqGsesMFkLPuJLLaEoo4kiKNJ1u7BLBkbJZ7E+olvegKtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bw60aoT/kbRVvXhAGQ0gojlh/6GAzDYz/g4uvyJ5tuI=;
 b=HriS6iayQbnHq9dIXLS+RGZQIfWJHarf3SdJppdE6IuaZ8YGk/NWch61Px0L5iw9/cx24P63baNdcc/hYGl5JkM+wBfvvCz5K1q6+WYcGZfzHL8eF7E27oIC15YIbN16C3YOj0Q9o/hX1wTvsAtwOgrRJBkppHu1hMkaMDqMWtVzQmKlhud10TG1/Cro5IY1zS5jcO7EIeVytmbOYjeeQKdrVRvJgQujtMkz8P0L1SZGIKH6M+bk3HZJl9HcbqRacb4xmSMa4mc+dmaoZsn1pUuiFAY/tmXDFaVnjNkbpyjy/GxwmBwmzUxpfV9ij1s/aHY8kWpo5V8H9OBUsRc3qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by PH3PPF4EB9556A6.namprd11.prod.outlook.com (2603:10b6:518:1::d1f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 07:19:18 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 07:19:18 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com, Ionut Nechita <ionut.nechita@windriver.com>
Subject: [PATCH v7 1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Wed, 15 Apr 2026 10:18:49 +0300
Message-ID: <20260415071849.25693-2-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415071849.25693-1-ionut.nechita@windriver.com>
References: <20260415071849.25693-1-ionut.nechita@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0137.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::21) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|PH3PPF4EB9556A6:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e95f968-d81c-4eea-a044-08de9abf4e9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|7416014|10070799003|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	keb1GyPiGIJlsJeyKILZ7Zp8WsHhXkIIWpy7cnZ3kDOBjAc2ki6Yj25aOoIIzSYciSUmxoXwjoD9k0V8Be9BvqyiEsfI+0LuqBZ+aNm0M83uUytO2bENAJTA9pWOGy/i9gUUgwVcn7WulQ0sAxBhYebjip/rERi0JeklIv8Fm+oJ+EDHkJ+BEHpF1CtpWMGDnMqKn94sgKhI+yE3tAxs1IKDHRoz2gpcH5SlRPHQHecfTRvM2YDuuhHFBOIcql3+bgigTH2hVyOkOw+c/tSoBFaxfA37GLi+Y+KJP51B0mkBvJN87cqYXmSaFpRrpBsTlforUB67LRuMiWm8P8vqwHS9J6mSqFGNrf+7uMY3Ez4tcBX2zlLNFW7O6BR4N4I7g9r/3vS28y2nPVOP4njMF8eCt+wuMr1Ck6OJQoVq0svPNXdqIuWSfvfeiHNf8+PsKyBHEkbSYQJ4NZZrhA2tnJH6hwweafjqbifLsAR7kY/8pWkbMST8RjJ9zlJ1dbcXF32gx6ZGexlOatC4QN/HJO9fCwMtryXmYjC1nhcXwoK31/Ydm0Z/1K8+SfjUzaUIXtaet9QhVZBaphUlH3iG2BppO8GrEiM0JRVZnxNaDK79FlMUe641iNwt4Vls+m7OvRH8eJrv06cZyhCBm6D6kw8bNwlJEzH7JOA6+hK7+JrKwGXpjTE++3nsaAdBhIiNGJJ+O8MlANEVtfhpF4DiDQaKWlGLkc9ZZX6r2gc3TYI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(7416014)(10070799003)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TDd3a0QrWWw2K0ZUWFR4cFo0SGpIbmJQaDkrMzlab2M4YmhQQ01BSDdDVHdy?=
 =?utf-8?B?RzQ1cUFVM1preWR5MkVlei9OTXFPK2g0L2ZMVkYrUTZvaDFGTTNmVEpVVExZ?=
 =?utf-8?B?SnBMRDFsTW8yNzlJMkdxcWRkeGNHRzZtL3NXTmdVWUJGTlNuRXJreHpYMytr?=
 =?utf-8?B?ZWxYdTh5cWNQT2RGb3JSVzJxUEw4amxhQ0xmTzJoaE43YzcxTnB1RFoybHFy?=
 =?utf-8?B?enZLRHlJWlRvYnhudzR2NlVZNG5CaE9YaDJRRTRtYU9wbW1EVWNMbDZmNmgv?=
 =?utf-8?B?RVBtUjNOVUFVT01JWXVkeDdodUQzd1Q2cjljT0g0QVAycy9hOHNqN2xLQ0pR?=
 =?utf-8?B?YjZtT2dpYUJjb3BmVGY5dkVSeVI1cFpxbW5lYWprWnFaMzVVTHhqb2ZHOE5W?=
 =?utf-8?B?QlFRSGZqOHpudzZEaHdTbXBmdUpEYVJEcVhtbTMranc5SktldUc5V0FlM21s?=
 =?utf-8?B?OXBWd09FeGVBVjBhSllYMmxyS0pFVDc0TVNPam1GN1V3eExSRWlRUUs5eVRM?=
 =?utf-8?B?UGo4K1c2anVHT1llRkd5b0F0WE5Sd25QMDBFTGx6bTM2VnByVzJiNG1odlVl?=
 =?utf-8?B?YnpCcjE1Q1I5SG9xZS9WTFR5RnhZRnIrdExwckJLZXpNbTJTd0hmdlBwUUU4?=
 =?utf-8?B?SzFabzcrTmtvNm5HRVZOMVZCNkRCOE1uUWZ4ME1ZRGc4cEFGY3lWQVdVQXdZ?=
 =?utf-8?B?aVVBWTZPQjVJQVZRamVSdnUxS0RPeGtpUzFiYk45UER5OEJUVHRSYlFmODM3?=
 =?utf-8?B?ckZ0U0dYZnhiMitWTFlnQjlnMWt1QnZFMUo4RlA2VTJWdVZXZkZFanJPMUpS?=
 =?utf-8?B?R2wrOENrTlNVaUpVZ1VGSzJXcXdmL2JyMys3MCtVRUFVeVArUDJRTG0yZUM5?=
 =?utf-8?B?c2dBL1ZjZ1g1Wnc3b1M3YkVFQXo0WjNKam9zeTV6TkNHb1QwdUZqZXpuZGpJ?=
 =?utf-8?B?S0tlb0hlb2ZsWk5ROG1vc3dRUnc2Tnl5UzV0RThQQ0ViQUl2dmwvR1Yra1ZH?=
 =?utf-8?B?d3NISWJiR0ZFZ0tyT2M4dDdxOXA5dVlWMUJ6Qlpxa0xqUmlxUnFPRHhQWVVn?=
 =?utf-8?B?NXp0Zm1SSURLOVB3bE15MUJmZnZLRkV4cllLenhObHRjczVMNlpQWUplamVF?=
 =?utf-8?B?UmhGaFZxNWQ1OTRtNkFVMk1aTm9uQWpyWlNURm8xWjQ3NjZ4SW84NG1uRFN6?=
 =?utf-8?B?UzYxN1dDWDJlNVpnNk9NOXVkS2UyL3A4NXozbkFJUHlvVEVEWkcwTHQxbkVi?=
 =?utf-8?B?NDA2SkVoOUNHZkNncEV6L0lKMUsrdjBjOXpFNjlqdW56cHpRbVlISG03UlRj?=
 =?utf-8?B?QVFMamg5d0p2cTV6MDk0U0d6ZGZsMm9oQnYrSEd6M0FQWHVrVjNQcmdzOCth?=
 =?utf-8?B?Z0p1Z2N1bVdOV01tZnl6RmdwN3F4emFOazJuQjBDemFDZWRGbVU3N2N3b2E2?=
 =?utf-8?B?ck1CdkkwMFFQcHdpZEhtYVA4WlVRckQ5TGZ4MURkeDNMZzh3eEd3NlZpK094?=
 =?utf-8?B?cEx6MGRnaXlyNHB0T2wwR3VRL3FGYnZENTB2NHp3MDRjNDNjWi9VankzRFdp?=
 =?utf-8?B?R0pFZmJpd0NodDBDOXpxNk5MYTg1bkt2bDZzMGR2cUtnNlFnU29sSW15MW5a?=
 =?utf-8?B?UW1LMTA1MmtVYnExNlFFZjM0RzVnWU9RZW1sNEN3MUxudjlrVkFKcHJhODFz?=
 =?utf-8?B?MVRLQ1k4dzNqdkNyanR6RUFmRHI3a0hraWZQb0REV1Y3eVZYVWwxOHVpc0FX?=
 =?utf-8?B?YUtGV2NnMUxhaU1ZeFNTaUlJVS9rMklaaUNNeGo1MVozM2YxeU9hc1p5aVN1?=
 =?utf-8?B?VWpsenpqVDJud1hBS3JKd3ZER3pHSjhURXVzQitwWHBlNlFYaGpjVnRSYnB6?=
 =?utf-8?B?QXppRzRTblJoakxKUWFWSC8rWFFyNUVpNUhRWVBEdkNONW5PNXMyTlZ2RkNv?=
 =?utf-8?B?MDUyL08vbXZ3eit3cmZkbUxsMktqeXY3SmFrMStyVlRBNEw3bXdvRytvYXlR?=
 =?utf-8?B?WHpMaGZ5eUsyTlZLNmxQdW8rbFNIcG5RbU4xOHdKb0YwTG1mbGl0U21kam5X?=
 =?utf-8?B?S3pTSHlHTG5yS1JxR0dsZnhmczFYQ2grUUpSVldqMTUyWHRrTVNCRDE3Mmt4?=
 =?utf-8?B?NU1QUlQ4ZFd6SDhHWWd2UXh5enlycFpqOGdVY21EZE9Ma2NlYVc4WUk2MjRa?=
 =?utf-8?B?UDJ4aE91OXRPRWw0NUxrY2UrdGxJRUFzdVptemgyamZoaExCQ1VMSXlBcTdW?=
 =?utf-8?B?L2hKS2I2Vnd3RWE5a2tRVkxTMGNyajEvUTZEQ2xPdk00NDJ2K0ZiLzdvelpZ?=
 =?utf-8?B?Y3M5d2l3dStCUlc4UXg1clhmdGV4VUpjME9TcXdmblBjcERhSVBrU0hud0VM?=
 =?utf-8?Q?zNtSJTbch7epqbL85FtO310/XWZOCL6aPTB4Am3AI4PLe?=
X-MS-Exchange-AntiSpam-MessageData-1: wYlj0SlwUyW0eRCVNLpDw/tEn5Ow49MU7s4=
X-Exchange-RoutingPolicyChecked:
	QnI3bcTHl1Ot1u4QTEew8UPPAyuBBjrXkMjRWl/cZ5VvzlcAJ8Q2wBw2NmVjL2941SR6PjjKORDfcv+689bETJn2SWOSTk/vHEqBrCgsfKTYMouOEcvEqi7NldhqNGs1Dcml8KpWCvKd+hjNnD8FNs++Ec+dbhMQ5AOIbmMY99P7ZaASoiMlkPJY3tslTDURqOqa0fK4frCqIiUGQZJsvoqFQSnBGgu+BeFWioOGMiPWiFQzcVsIe5VohVl0fvc6ILqugtEgZpFubZ+XtUtxaKeS9CuaUthaLXRtXJoFvpXiHiW2tItiErjr9XESj7jFIlR5sWvhTi24u/SKf0455g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e95f968-d81c-4eea-a044-08de9abf4e9f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 07:19:18.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HfqfJhLm2wvs2BT8D2SfNIhoy0gTe22VP8soDSDx6snCmbRssNQyanUZ01pRy47tQomAJzlhRpO/KVwZVaO29lu4S/OjbN0lAK9Wtw13uYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4EB9556A6
X-Proofpoint-GUID: 6Oyl1-_TZfVicu3HQUYAVyP_W2DgrT66
X-Authority-Analysis: v=2.4 cv=Q4jiJY2a c=1 sm=1 tr=0 ts=69df3bf8 cx=c_pps
 a=ucUdQIQ8V72PEv2waZrxmA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Rf1WfI4Yvu15uZDE1rgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: 6Oyl1-_TZfVicu3HQUYAVyP_W2DgrT66
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA2NiBTYWx0ZWRfX7/au60ALJj96
 53R7yuUDq8g5HzmQF0ftQINEkytS9AwPmySZUD/cryY7G1+WCTQBLN1ouQziwO0AJzi4cA8GYSV
 xf6U60dTHl7XVRor+3LwoZalU9RDZx4iO/3w99AbXdqMUuswZ0ZdymZSN3T24oaGch8TVnxK0gF
 87izYmJ6yiBNu6dj1jBpeLfz7CtIChyVq60qk5Ops3ERrwYzHeR2mYeY63IkOXNu25fj6sE//Vc
 7zhT3WHPhnpQq85BgdQatLbFS/yCqnfszD8Fh7xZOfzUBmwh51sA9cftBG1Z66yqYT/OdUAJesw
 1i5thVuHN2ikG2LrMgWm4dEXO3aJqxqtHtzSw8pDAVafFgEeC4eVW/o2YOLIgmkz6jEyThcddk1
 ymQ1opV1ujZPjn28yXtAmPJzTFX4OnLLf0EvqhixBcmHdbTGd71yCfav1aKLjRcXJ9lckLdzFp9
 fpOXL2mWuIHXEt6SE5A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150066

From: Ionut Nechita <ionut.nechita@windriver.com>

sas_host_setup() unconditionally sets shost->opt_sectors from
dma_opt_mapping_size().  When the IOMMU is disabled or in passthrough
mode and no DMA ops provide an opt_mapping_size callback,
dma_opt_mapping_size() returns min(dma_max_mapping_size(), SIZE_MAX)
which equals dma_max_mapping_size() — a hard upper bound, not an
optimization hint.

On a Dell PowerEdge R750 with mpt3sas (Broadcom SAS3816, FW 33.15.00.00)
and intel_iommu=off the following values are observed:

  dma_opt_mapping_size()  = dma_max_mapping_size() (no real hint)
  shost->max_sectors      = 32767
  opt_sectors             = min(32767, huge >> 9) = 32767
  optimal_io_size         = 32767 << 9 = 16776704
                          → round_down(16776704, 4096) = 16773120

The SAS disk (SAMSUNG MZILT800HBHQ0D3) does not report an
Optimal Transfer Length in VPD page B0, so sdkp->opt_xfer_blocks
remains 0.  sd_revalidate_disk() then uses min_not_zero(0, opt_sectors)
= opt_sectors, propagating the bogus value into the block device's
optimal_io_size (visible as OPT-IO = 16773120 in lsblk --topology).

mkfs.xfs picks up optimal_io_size and minimum_io_size and computes:

  swidth = 16773120 / 4096 = 4095
  sunit  = 8192 / 4096     = 2

Since 4095 % 2 != 0, XFS rejects the geometry:

  SB stripe unit sanity check failed

This makes it impossible to create XFS filesystems (e.g. for
/var/lib/docker) during system bootstrap.

Fix this by introducing a sas_dma_setup_opt_sectors() helper that
sets opt_sectors only when dma_opt_mapping_size() is strictly less
than dma_max_mapping_size(), indicating a genuine DMA optimization
constraint.  The helper computes min(opt_sectors, max_sectors) first,
then rounds down to a power of two so that filesystem geometry
calculations always produce clean results.  When the two DMA values
are equal, no backend provided a real hint, so opt_sectors stays at
0 ("no preference").

Fixes: 4cbfca5f7750 ("scsi: scsi_transport_sas: cap shost opt_sectors according to DMA optimal limit")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Ionut Nechita <ionut.nechita@windriver.com>
---
Changes in v7:
- Drop redundant !opt check; the !opt_sectors check below already
  handles the opt == 0 case (John Garry).
- Add Reviewed-by from John Garry.
- Rebased onto next-20260414.

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

 drivers/scsi/scsi_transport_sas.c | 38 +++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 13412702188e4..45609259f27db 100644
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
@@ -222,12 +223,42 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
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
+	if (!dma_dev->dma_mask)
+		return;
+
+	opt = dma_opt_mapping_size(dma_dev);
+	max = dma_max_mapping_size(dma_dev);
+
+	if (opt >= max)
+		return;
+
+	opt_sectors = min_t(unsigned int, opt >> SECTOR_SHIFT,
+			    shost->max_sectors);
+	if (!opt_sectors)
+		return;
+
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
@@ -239,10 +270,7 @@ static int sas_host_setup(struct transport_container *tc, struct device *dev,
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
2.53.0

