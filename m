Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0999314A4F0;
	Tue, 20 Aug 2024 23:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196991; cv=fail; b=sRCG8D2K8cXMC4vEB3gKiNCu3GAGKphXB3PjHW9yCrFreSlxTMf5ACPjiBXMHwOhBCn+rJ+j6NmKX/anKf8VqPPsH+/LppCSz+UdGMT09KT9+EaXTztDbrK0ErtmETagmTWOMHbesOjAGMVPBbC1XBeZomuA8COKqii6TNLKyf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196991; c=relaxed/simple;
	bh=KRkLNCDlTaFLVhT1ITFaEm6vNVdRQStygOUxVmkhL5o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m9Ikab/vc6g1VhP3SLSmfp0geVF3hIxOYNTs4DnKRhEUeLYXCCwHZs8BLUBH7HYXRnXqSfHvukhKRTUXYb3SEFmkPJyZhcdyRAE3yVTIxfmL81GhwTgjSFGbC6exgfWXIOfI4A8WnMX+hqb30hezBKj3vc5Y5L6HoSZiLeAx1fA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZAwb+IWg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iEmDx9AB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZAwb+IWg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iEmDx9AB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47KMBXeu016621;
	Tue, 20 Aug 2024 23:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=dL1pvVYeAOPd7P8+Ls8EZQ2NuPSns4XXPwyFuqPHVok=; b=
	ZAwb+IWgu2T3PBJDHwzMhWC3rY0HMEH/LYR75MHiscX3ebbO5MuIkQBiDtUXu4cj
	ww8mgCpNcqVIr8QUKQ4KxFSDrN30btNp22rRCz8D2xinPo7QKFa/+aNw5sPmHVT5
	qOkR+pw2NDjGsM35Y/gSSgFCTLGhwvgw8TIQ/QaFb2tgYr0LcBItHLiMqs0pb3ui
	t2oNV7vYyvCtcldiA/EJDFyQh3KSehxnt2PGxgyKURKDFYgr+wYbSHqP/T8lDwYc
	CphBH6n5JaQAU317S16e9AY4+2x+snuwSsRRX7FWMfxk57QYvtdJO/aa0hxUNPNq
	s2FlbdnSqYci/P73NSZtnA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m2ded67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Aug 2024 23:35:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47KNY4f0023473;
	Tue, 20 Aug 2024 23:35:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4154x7812j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Aug 2024 23:35:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QQ/w4utEpxwUsJp+JkRLooPu+zUStobCyJbCWjC13aKTr30buIWTFewgwS1b5gPCBZalbptHDVuAhvkXyZfbQlWabZgQifUogxVI+c/QMTMzxl3ta0OHVCMY8dkxTa/4iVU/WVCtzhoho/8oNKo2gLJHLmQZzdqm6TU+tuajSdUjsZRVCxr67ZPYKY7odtmaVtBZNM6PR4pzjvkFpZX7ugx4GBpCq3KapmTvp+eNq81ERD5WHYZj2E2/dLT372fG5iRrSSIy2ffQ0jX0TF5ddmyeNToWOKCwWzO0IJzviEKdYMLzjfGELVZqt8fpEHsNxn1wBu4uQq/GiqDDoWuXQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dL1pvVYeAOPd7P8+Ls8EZQ2NuPSns4XXPwyFuqPHVok=;
 b=dCNaUdMmlfEgVRonehh22R3f3ei7d+hfZViPJ5Vd9oOYIX1iorf6bW7alIFkSqWN+t7UHYsAsRpehAO91mb2r8mQzLjUuSjkArklDx7ix/qpv0vmqyaXbsRI4+0Tb2dQhBhNzL4f8nQlrus1VEvHBtbCAKDGCqhGdscdxJm7idKXoPKaoyX0poWB3j16R9azcLuxnf7tZdYmCCStlyxYDJF3hgSivJW2te0Av8H1RXHSElcV2nDzgXkjaqIGqyGLbEGuSW1m2C6MMbYF8U7AOuT2C5nt8pKeI2MTGAPhPIf7UA/zbV4y+H0F2H/N2YwzsCO0I9lq+FYiZDEx7UM0TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dL1pvVYeAOPd7P8+Ls8EZQ2NuPSns4XXPwyFuqPHVok=;
 b=iEmDx9ABq9pFpXvOQEXZXOAv/TZ5MtnmlmCXYs+hI/G9WK1CgsJRalDVRfQAAFBsf/n66TjGyJlqDpOGvEbZ4NFyOXn8Eq5n+VERKCMV6yIiELZ8K6LiuE+6A5SKOHoQZJ4hcuiPtTf4KlLHbgD13JnpRodD8dMi9AbL/FOGXVc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6887.namprd10.prod.outlook.com (2603:10b6:8:101::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.12; Tue, 20 Aug
 2024 23:35:46 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.7897.010; Tue, 20 Aug 2024
 23:35:46 +0000
Message-ID: <dbb75c5a-5a61-4e46-a593-b6fb6d22703e@oracle.com>
Date: Tue, 20 Aug 2024 18:35:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: iscsi: fix reference count leak in
 cxgbi_check_route()
To: Ma Ke <make24@iscas.ac.cn>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, m.muzzammilashraf@gmail.com,
        James.Bottomley@suse.de, kxie@chelsio.com, michaelc@cs.wisc.edu,
        akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20240819092405.1017971-1-make24@iscas.ac.cn>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20240819092405.1017971-1-make24@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0461.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 734bd9d8-ff78-4b88-5080-08dcc170d09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VFovM3A2WnIyRE03THBzVUdERm1vUzdBOEwzWXMwb29RalJWVDhFRVVNVFB1?=
 =?utf-8?B?c25IWWorenFwMDZySk1IQjZjeXdHSS9wQlovQlFZcmNPNUVpVXR1dHlTME14?=
 =?utf-8?B?YjZCRnp5NnBOWmk0elpYaSs0Mnk5S1R4djVWbld6VXRCSFl1dlBkckV2citM?=
 =?utf-8?B?dERHRlVtSUJOYndPYVEvYU85RkpRZkFmN1VYUnJOMFNBd1p0eTFWMlVlZFRW?=
 =?utf-8?B?TjM3S3NaaVlFZ2diMEpvbFdpSG9MNFNaNnNnMEswaGlENGdDZXRmRlR6ZzdR?=
 =?utf-8?B?SVJrN2JnZERFMTdkd0QyaCtycitwamJ1MXVUWnJlUHRJU2IzR2RYdHo2ckNG?=
 =?utf-8?B?Z1JjZ3NtYnd5YjVQNDJDbWNjYndjdG1FM2d6NFp3QkxtNzFaN0k2azJjenMv?=
 =?utf-8?B?OXdiN0NDYUtYYnFTMUcrNlFESGRIR3FqNFBKNEVIQVplVFY4Z0hzcVJMN1ls?=
 =?utf-8?B?cEs2QmFvSU1lOWhOSDNlUFZRUVlRM0x2UXFML0RnOTFIS0JUcnZKaGZTVHVC?=
 =?utf-8?B?UE15TFpLQjdWYVFrbjZvdXhhNTdkOGVXTkhRSFphakhZdkR4ZnhyTHNmZ3lP?=
 =?utf-8?B?TW5FR0ZSbU9idHN2eGpJOFdCdnZzNjN3dWxtZFV4ZEdGUjVvU1JpZ1NXRzlN?=
 =?utf-8?B?NVdGSVRtMGJpS1ZxMUR0bXhKbTAvME16NS9QeVFjd3I3ang2YU9RSys5aTI3?=
 =?utf-8?B?eHI5UkpWM1dnd0tTbitYVHphUU5UdmtGZmpZdnEvM3RkUjZqUC95Yll5TzdO?=
 =?utf-8?B?dEFzRzZQMWtlSVlQaS9jZk1ubmUyNzFkWmZWbmF3UVlaa0dITmllUlhPcmgx?=
 =?utf-8?B?M0RqcTRZcWdxVFUrSHYvclZnOXFqVytIU3FOcnJ3NlNjaGVSK2JaUkhsNjlV?=
 =?utf-8?B?VWM0Z2VUTjNpcldibVNaOGwwL0s4ZFJCbnlOMjgxdVExSEJBaFVMVGh5NWpR?=
 =?utf-8?B?WktEalpyMmxQazVWQSt2WDZBa1dNaWE4YkF3ZlVNQ0ozK3VnUEM5dnNpdmZl?=
 =?utf-8?B?TXYzZTlUazhmeUJRbG5qVWQ1b05WRHcwM3dzNk9qM1lhUDJKcHlLSkE0bGh6?=
 =?utf-8?B?M3NzMDZDbE9ndkJSM1Uzc2NGY1FzS2Iza2YxNkZKbG5lUi90VnhYR3lSTmlY?=
 =?utf-8?B?RkdsRmZEN3dGM3Vad2J5MlozRENlTFZMVkRNV1E4SGxFSXAxTHY4Tm90a3Zj?=
 =?utf-8?B?WnJGZ2JiQ1dSM0JmUHFwcWlqbWd0Y2c4S1FZRm5iYVZaVmhDUjd4VDRuQzFu?=
 =?utf-8?B?NUc0MSsvcGF1SjVRWnlKOTNGM2JMbWFJNlFtMUxBM0x2RVU2MGhESktveUJx?=
 =?utf-8?B?S1AzY0NJeW1RZWJHV1hQY1BOZnpZMlhoS2Z3WHFpQnhtYjl3WlBKeHM5SFdw?=
 =?utf-8?B?VFZrOFhlMHRNYjBQVzJSckVzdjhEZ0JYY3ZKYWp0S0czL3lzQzByT3NYblU3?=
 =?utf-8?B?Qi81SXhNdlVQNVJWUWdCdUlnV3VPT0F2a05xZk42dGd5dDAxNGlSSmUyYTBH?=
 =?utf-8?B?MmFoMzhXNUw2STJXWU5HeGdYVjg5d0pzVUF0RGY1NUx0WTlLSXovUS9jdnZH?=
 =?utf-8?B?VzkzME50TTNINFZYSk1yVGIxTEVWNWdqeWdXVVorZDlpR3BHVWdRV1NnaUgw?=
 =?utf-8?B?ODZCR21wWFJLc3UzYm5mcW4rVDhnSnNCTGxpN1RnYlZZNVYvbXp3bHNSMTEx?=
 =?utf-8?B?UFlPZTFuOWNXWG5ZcllmNnR4cHY1NFRYSStYc2o0eDVoOS9rSEJubHBnYWxU?=
 =?utf-8?B?M1dQMWx3WnBhWkhmL0FkZnIwVGZJZG5NVmozdkJoTWVYeEhpV2t0TGxhYWZr?=
 =?utf-8?B?dm9ZTnM5ODJ6Z09vMUFyZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFdNcmdDYW5tOHFRUEVpQWlNS09aMCtHV1Z0MG9JZ2I3TkFoeWhmOW9MSnpV?=
 =?utf-8?B?MUg0VFdGM1BWWngrSmhCYUVzQ3lLa1BpNVV2aFN5Z2pTZ3RqOFJtMVQxQTho?=
 =?utf-8?B?SThabjl0TmF2dVIrN0xjczh3SjFINWZYbTRSUDY4cFUvRVB1b0hvaHpNSXY0?=
 =?utf-8?B?SnF2bUh6bFlqUkxucC9EWmxVcHpaKzlNYmpuT3QvaXIrOVB5Z2VUSHpBdEE4?=
 =?utf-8?B?MkxubmJxbFJBUjhZcHlqUkoxVG1mQUVoaG0vcU5EaEdkT21VeDdoZlRYZkVE?=
 =?utf-8?B?VDVUREhESHBJQ05EeTVYbGF5eHhFODlPNnZmT052WUVnMHljdDBRNUtEZVFz?=
 =?utf-8?B?ZThKbE4weThXYk5ZQ0lGMGlsMzJBYXpldG5GTkc0Vmg1Q1p1cFhFNDlDaE9m?=
 =?utf-8?B?ZW0rd1BkdWY5VXF0MUQzcEdRZExkYkdOaHlCRDdVWCt5L2hFQk84cEZ3QS9U?=
 =?utf-8?B?VmdCQkRjVFQrRlcvOXNUVE5zOGFwaXpJTkRlSVJGd2VYcWx1WncvRjVrUVAz?=
 =?utf-8?B?aHdGUkZwQ3FveW9MeFhaeFZGZi9pdldoQ2M5dXhqWFhFczMySDVHbnpVanBV?=
 =?utf-8?B?ZFovV21vL3ErbWdpZnB6aFU1Rlp1TW9yTXZXODN4N2pTWHJuTmNtY3ZhVTVm?=
 =?utf-8?B?TVRRM1dNNHpRV0tYZXRsZDZNNzNzc3VCTHI1Qk5VZzBUS1lzSGNYTGg1OFRG?=
 =?utf-8?B?V3JyTVNOWERlOUVaZ3dBei8veExVUGRwODlyL0FpVVhwZ3RUUWpBbzJiZmxR?=
 =?utf-8?B?NmNVQjRlTXVqOFFER05zREN3SllMN3kvdW44NXJnVkFscXg1WjRycllyWWhT?=
 =?utf-8?B?Mm1RSStGdzJuQkhHYzdxREt4YVE5Sm5abU1SMFAyQVVhMXU5TTVNM0lyRHRG?=
 =?utf-8?B?cUpPeVRoVDRvdmltTWhYQXQwTHFRWU5XYWJ1N2VIUEpNdW1JQnQwaCtBU3Vy?=
 =?utf-8?B?ZUVoMzZOR1FJZWhjckFzcUVlRXRGNElsRHI5ajlFTUkrdUpQdTVXaUFjd2Ri?=
 =?utf-8?B?MnpIU29JWHBDL0lQZWJNVlR3bUtJVjY5MitYNFJxVDZiVGxZcklTOUsxVHBw?=
 =?utf-8?B?OENhUWhSbW5nK0NmZlJGeEI5TEZlU0R4MS9ybU0yZTA2ZnNXV1lBcGVkOFJu?=
 =?utf-8?B?K3hMZDk3SzAyZ0xQRTlFUXkxMWFZT0h5ZXdIWDMwcHhZMTBtbmEwSEx5eUwv?=
 =?utf-8?B?eGtVT0RjN0JWL0FyQklpSW9JbzhldXptRUgwZ1ZIRGdmRUxiMzNpd0RKVVRK?=
 =?utf-8?B?M2RCbnZWSC95MjVyWWVEaytRZjZSTHl2TlBPK0U5QWVFS3FxYVl2bVQ2SjN0?=
 =?utf-8?B?Z291RTlFTjBKVTh4eVN6VEROZGN3UmNqUkxuLzFTbDZEcDc3eU9KV0JqTUE5?=
 =?utf-8?B?RkJjbGVyckFqWWVVOHFmYUthT1AwcmRueEkvcWRYQUFDRmFoamhrQm5MR3BK?=
 =?utf-8?B?eTR4WmdpWFRra0dTY0JtZzdnTkpLdUR6VEt5RlVsbTlaSjBxbnEzSGFpR3g5?=
 =?utf-8?B?RUloRHcxTFE5RU1LRXYrUnBwWmw0ekZ3VS9SdjhUdVBRQUFseGZMRUE3T3V6?=
 =?utf-8?B?Uk9lN0ljYnZzdmpXQ01KQ0VabUpzUVZqc09NaWFWZ1pGVUN6a0RiOUFnaURv?=
 =?utf-8?B?UkhXZ0lydTFPRmtCNm82b0dOaTFYVncwNlIrbDY1Q1lzZGFkVTJvTzU4TWEv?=
 =?utf-8?B?QWVWK1Rqa1FWcFVGdmZ5bjNxak9XVzIzQ0Q3T1VRRnhMek8wbk5IcFJvZ09I?=
 =?utf-8?B?dzQremRudXJFVHJMZGZacVZnVit5V0F2aW8zTFhLRGh5ekI5UU0zelQveVhn?=
 =?utf-8?B?N2xjK2p1YXZEZmVHUnFtUEc3c244TWxyY1cvUTZYQWRSWWtkbjB4S05tM1hn?=
 =?utf-8?B?OGJYN2N3enJSandhY0R1WlA4UWFvVHEzR2w3YkJBWktwa051cURsa0pheGty?=
 =?utf-8?B?VVpxZTdOWjFFcXdhYndCazY0ekhvTFVjYlZVbnVhcTdSL0htSTFkNWswT2N1?=
 =?utf-8?B?QVR1NlpPazN3TmhTMDROYnRmZ2RheEVMR3M2TTFyaDE4T3FxYmE3QnJsaVk0?=
 =?utf-8?B?QmEvVzd4NzBwaUpCZ0tyWTA2dkNvc3NPZ2ttTWdjU0l3VjVxU2w4Umkyd0g0?=
 =?utf-8?B?YW1sMWJYaUFvWEhhQ0FMSnJSamJiVzM4VEQxS3g5M05jV3NXKytQSFpiR215?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MhMc7hwyXNoongbpJ0Fao/cqLEw2gwdAt7poXN827bKNJy+TTArU+lFvm3Vs627UjAEVhzjYcl4R2vjKTmiWw0u2x61m4cDu+prWyGsUS8A0VgEl0PmSAxRK99K95cy3YDYOv/+1YvNPtt8LDHzWu+G/h1diB5KiDQXIDxOyUfvctBU4YIH4Y1mf2avUi23KSP1l9tyyvXWWqq5QcCC/9nsSYZA1iEMOx2yJpkQInyuy4mIkYNGZVptU33aPCn6Js23GAB56jP2TsT2OlH1xLYqJmPqhUwJrsAIMOCcIuFfPlw3S3O2wX/WHO9aUmhg4CBz+B+Dz/kCKU2XHCy5XagsWdjAM0DyNfbbkdgonRaavct0iGR5bQ3cHl0i2ygXb9HsZSD/Ds164qQA8hyHW+oQFjfFmTV6vjlBgrqb/t2cQ2WQGTq93u85S3cxSkUjKSXE+Oa5lrKriHfAF2ZI0mzHRMOPYk1E5DYdgnkYobhR61/eamIp5a1+jphh7SIETlpBMl7vSZFUeBERUHbEuMUJbj686YmxpvQDbT6Ji6AdE91OHZI7eGO/g+n/amqK/QT4pYXbZ6+BRJrUH1HGZk2eEyVSaIL3bgoiW1k0WBqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734bd9d8-ff78-4b88-5080-08dcc170d09c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 23:35:46.2663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jpKy51BfLC5dhqpTV84v0+inB09Cfqngw/ZJYhO/fdP5HTi67WY3oTGTsDc/NDbC12PY7og9ldx3+cEmlUFzGKxnxXs1HuP81yiYse4pi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-20_17,2024-08-19_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxlogscore=645 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408200173
X-Proofpoint-GUID: 56Hnz66WhA_xwFlvY98XLxSuGOBL-NNY
X-Proofpoint-ORIG-GUID: 56Hnz66WhA_xwFlvY98XLxSuGOBL-NNY

On 8/19/24 4:24 AM, Ma Ke wrote:
> cxgbi_check_route() dont release the reference acquired by ip_dev_find()
> which introducing a reference count leak. We could remedy this by
> insuring the reference is released.ip_dev_find().
> 
> Cc: stable@vger.kernel.org
> Fixes: 9ba682f01e2f ("[SCSI] libcxgbi: common library for cxgb3i and cxgb4i")
> Signed-off-by: Ma Ke <make24@iscas.ac.cn>
> ---
>  drivers/scsi/cxgbi/libcxgbi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index bf75940f2be1..6b0f1e8dac40 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -670,6 +670,7 @@ cxgbi_check_route(struct sockaddr *dst_addr, int ifindex)
>  		"route to %pI4 :%u, ndev p#%d,%s, cdev 0x%p.\n",
>  		&daddr->sin_addr.s_addr, ntohs(daddr->sin_port),
>  			   port, ndev->name, cdev);
> +	dev_put(ndev);

After we call ip_dev_find can we hit one of the error path gotos like
the test for IFF_UP? If so you would leak the reference in those paths.

The ndev above looks like it could come from the ip_dev_find call when
IFF_LOOPBACK is set or it could come from dst_neigh_lookup call. For the
dst_neigh_lookup case we don't want to do a dev_put do we? If you do,
then we are leaking the reference in the goto error paths.


>  
>  	csk = cxgbi_sock_create(cdev);
>  	if (!csk) {

