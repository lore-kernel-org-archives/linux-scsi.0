Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0FD369203;
	Thu, 23 Jul 2026 10:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801983; cv=fail; b=iWxK3q5jIHSZxj1xO3EfY4BpFvdajnvArCESzsPTtpzbtUeDA1EnmDXrK7i2geSToeqQzd0XzYdaQZw5EQ0W9kQrQvaH3pBz+LggeYUlmDhOz2wS2uDgy1eaOnUvYU/wIRVPT0H62oCbENpQYzA2cMXjb24/vFaqRdMYQP92Q84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801983; c=relaxed/simple;
	bh=HS9/eoDg4kfciNTRgxi93wc12ObKdSDiYaPwurtT/74=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mUI95xIf6rt3qKl6kTPS+bh4fejZQO+AQe+BlyEEiT8K8OynREqxBs4uiSLCKX0k0YDPhlMKWdKwX5h8NHBsGYS6/Vq8qAZvSWuTKWAXXmVYO75IFnWKtokTZTX5hWxQcuWZASLH14VTfTmnp8YQoUYvF9FODb3aNspgQ9ygiPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C2L6JnK1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cYiq56NK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C2L6JnK1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cYiq56NK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtXkw3573774;
	Thu, 23 Jul 2026 10:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iQUeZKG6o+y9AtG5eUkOJE0djheIOXqlfGBMwkYZebI=; b=
	C2L6JnK1GKXlznTtxNEbV2eqwAFy9SePlg4FqA2OcvMOvHr9MOQSj0oDL/QYd0NA
	A2nC6hgR/phjy7Neb8r3qoW/z3X+HmjFn+JtvUg/oeRjQKn8LW7L3+FpF1a3cNQh
	wJTvaWbGMmvgfG4tNAYyDuH5yEKtg7YbnrpNvlDnU8awbyf3au3RCln+CO05x5gN
	wue97QE5Te3hcr3+ygWgVJ1vxSGFw/ihkVTQnYQ7HZ8Q5/dRQ6ZYaVDt4ZGlVs64
	oPgx9gzRfO5BYG5lj/9fBOFjj8tDs+WCbEzmvYabcYRiAVIndyzMpHwPTh97Sutr
	F8F/kTlh6ChEDe+DQpvTkA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqprsq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:19:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAIXHP036608;
	Thu, 23 Jul 2026 10:19:39 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012065.outbound.protection.outlook.com [52.101.43.65])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxseg0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:19:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3HmQX6vmDd1sLunlxSZKALbo1JpdhHjNRgrwkFkq2t7Zw4N8BUNTwk8MyrqkejGRJQpHGBvX2bpaTy7m1vZNjbLbZ85r3RWcDlBAxvYum5xFUcfnugIzZeV62OZiw7PvVyaAJ6kgShEjTnxCTiJeickc6lH/egBzGs+000ezRAQK+3rCR6ggVlZNiX7CJY7LXW4nKCGU30l2Rv33LLrNNK/HecRR+/4vCaJD7FzdKA89gCy7DD8B2hsaf1bNX7RxmkjkviKkUzmig0dRC4Q9xGV+KlQvWS7qnrpsw7SlDKLk5d3eHLtD3t37R+hp5TNtcpbTBhbVX/4eZKBmohD6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQUeZKG6o+y9AtG5eUkOJE0djheIOXqlfGBMwkYZebI=;
 b=jK74oFkjbEpfmfdXuXgurkiYWNNvSdnRwayS2fcNJuDRNvQbx/0002CRq0XWZeedW4rnv7/5bBdPlRh6ZDZkfTs0HpVSnslb4Qe1gAhnU+eyHtpFQkijgLMvy8Dwt2KXuxKkoaq0bShNNwPFa+NOL5tVIZ+RCrWCxGU09xh7LQ1aBjHJs9s9d1abaChN200nVRU3oHJwIXduXTdcppShB+BQzKgPKcHl9pKtTAEgvlBnbVmy+uLY1MWjkF2a/1Us94f6w0Wxy9d8EEL6gM298EXgt57dJQ2PulcMMgLbomPTJWu/N/fq2fIJMmSGRGn6viOsgO3nZzQvuITWRvu+6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQUeZKG6o+y9AtG5eUkOJE0djheIOXqlfGBMwkYZebI=;
 b=cYiq56NKmaANGRbJC+dxE/loZfAsDGgyPAJ0aDyHQnk35JnvFPcXUCBHCEeM9C1mLqlKGQ/ngR5jo1reuR4V3AGYQKic3UbvlU6nuJ4C6kLS33j0z5+jEytLwEBs8yVe5Xse9bt5dhxF8l7gdEThrg0rsi3mWv0PGTpkl53c86k=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:19:36 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:19:35 +0000
Message-ID: <4fca449c-37e8-43d6-8cc6-643b922c6fc8@oracle.com>
Date: Thu, 23 Jul 2026 11:19:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/28] libmultipath: Add initial framework
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-2-john.g.garry@oracle.com>
 <20260723095100.677F01F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723095100.677F01F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0195.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: a38ba000-9a30-4519-ee82-08dee8a3e519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oTVIGSoOKnAzdVsuGikfYXKgtXYwA1EXPlTz67DJPVBSRe86oy8DnNLKwor4lftN9/4BuWWTY1qlrEtsJ61jaxmwPze/544Ls7qAqKx3HR8gBF64ILXGhJ6eIjUEggJg2e96T7dNkxtakHAc93bxSJstqSqrUx3KdiFmZhqhETRMH2XYRat5WTMOvr2B+IWf3NJ1+44QsIKWBZwjr18QACh03o98B1iICRBJC0wXZYVIMrde4i2V1PLUrAbCQZVCnQHMIKXWxWBwxqpFS3ORc9/5FeWJX61VD60oQXh5GTHHxuWf6U+Bk9bpHHdIWiAl0Febdqt/c0BN0QOnR+KaQ487983r6JX2Q+9kWaNKWAJ9haGSDCJg9AZqaCY+4uBILtN40kl/sa6n6XS8NVvHNFh3JPN7guEw2SLK8F0ijw3Dzr8jpT/eKyEy91Uae38PrBPO0omsDX1JDX8j33p8NmgjRjPGRPPZeC52SZvP9Cpl/mC2WDDGuQj2uZHp7zL6uIDYN8V1aZWWXXGmR7s19dCG6/0zOtDvwuVqNAbm58QxbeVlCQ8s0fxq2SIy9k1FLZaObszyXteQkf6G4Wd60de2ioZteRnefYJP7WdCooqo7woBnSmzb/ECoWP73nHTb52pdS5j8pDNIPF6pPmsNJ/BPI1dIhMu1MVphDn/wnI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eitBRm5Qb0hFd2JqOUpwRU1SN2xyd1hNNU44eFVPOGFNdWg0UkY4THN1RjNp?=
 =?utf-8?B?VDl4b3ZlZ0RmZk9SUTF2Vng0ZzhrUTI0TmV4ZkIrTloydjlQNE9MVmI3NjVI?=
 =?utf-8?B?RFJoMWJZRlRXcjh6M01vRDdNbmlUTGhOWHNueHRaVDFOQjd2VDNEQm0zVUlL?=
 =?utf-8?B?V3M2SSs4Z3BVSDZ3WGxiUWN5T1l4aEJjOG5LdkdaNjFTSGVXUjFFTmJNa3Zl?=
 =?utf-8?B?WmdZLzk5a2ZHQjNNOUxLZkJUdTJJY3loMTk5OS90MnNTQmhxTVI0TTRBMGs2?=
 =?utf-8?B?Vlp0ZE0ycGNiTHV6dVJZRGtXYmM0UVNFWGRUaC83QTRDcEZ5aHMxa005bW1o?=
 =?utf-8?B?c0QwNGtFRjZZQ2hjMkUxaUs2NFUzaVdFdWhUWDFDU0FkR09VTHJRRGhWeEkv?=
 =?utf-8?B?UlYrOTZNQTVCSDNJeCt1bGsrQ1hHOTVjQm5SdCtxKzRHbUM3Z1lqNGtZNEln?=
 =?utf-8?B?UVZmazlJck1XT05sTUZiam92aDliSXhDMldZSk9CTVFTMHMwSHhoZXl1U3dG?=
 =?utf-8?B?WTJxWDlPWFV2dGJEQWVJcjFXbGVpTll6WTJnRkJzbVVDVVFnTEFvc2NUMVB1?=
 =?utf-8?B?T0lTQjVBVnZqNHhuVUQ4M3VrZjYzTTJMQ1QwN1JMcHBuQXVDeFR2clc5UEUy?=
 =?utf-8?B?ejMzVU5CbndtbkcvZ21qVUJPb2RsRzNzRDhhZnkxR3VSN1FnTXVwTlNnTlFh?=
 =?utf-8?B?dE5SUU1DS2pqN2RaMTFYdVFHaTBpSHVrdEVXd21MN0ZxMDl4Qmk0dmFRb3ZW?=
 =?utf-8?B?OWwyMENFTnVYYURMOVUwS2dza1IxWFppTVZtbWY5cWdyZU9ZTlZHT1MxbnNn?=
 =?utf-8?B?bGxwam54ZUtmd0QxaUlXZ21IL29FRi9Od0RteWNFZW04MDhDSDE4NG00WHJQ?=
 =?utf-8?B?WVp0SXNRYkhEc0FsOFJIRDAwMkp5SXpZUDBIdXFCSVZka0dqSXJlMytEZDl6?=
 =?utf-8?B?UE90RjhHVWdHUHdPbHBBQVZ4aDc2TXFqTjk2R25icjM2aEJQMVd4emYzcVZW?=
 =?utf-8?B?aFI0NHVpaS93UEEwdGtYSXUzeUhxSzlJaE00Qi9oeGZLdEtKVlRrZDN0MXVh?=
 =?utf-8?B?NmVSc1VYcWErczdSTUFmN0QzVGVzNlBlaktaU3lFbUpiajJ5YjhaL010WUdw?=
 =?utf-8?B?OGVNZUxLZ0R0ZjlWL1lFbTdsL3VuWFBhcWdwSUo5SnlTc25mTG5DLzZjdmZs?=
 =?utf-8?B?T3g4dWlCMkdKMnd1c2cwdmJGR290MXV0cWtJMnhIZTF4dFFiUWhydDhhM2Z3?=
 =?utf-8?B?b2pjRVozdENhbHMyVDhDb09COS9EOFc1UjE2TVo5ODM2T3p6cVVaRXBoandP?=
 =?utf-8?B?WERMMzRORDdVSEplRVJqdWwwTlpGb21CNXh6OW56RDJGbWY3TkRodi9yK01R?=
 =?utf-8?B?OS9Deko2bTd0ZDFwOHU4MlZIRElrRDRmNjRyWkRRUGRuTStpQ1A3d0ZDcnVJ?=
 =?utf-8?B?aVZqbitLM1BsY05hWS9wTFVPTGFHcWVLczVib0FSMTZhMmpZaHJLWlljU0tx?=
 =?utf-8?B?WHN4RHRZK2xHWXBWSkxkZHpROS9QN3FGam5TYXlubjlkNWlXTDcrdFExL1ZR?=
 =?utf-8?B?Z3hNK3hUTzFMTUV3NG9uL3liejArVUFKYXB1dXV2anpQTTl1QmtMTTJuSjZD?=
 =?utf-8?B?bEdhK240eEszay85ZUN1OWxTcnQ2ak91eDY2RXpwZ1phU0JUV0h6d3lUQXdV?=
 =?utf-8?B?Z0hQcExkV1FkWFBUUk1UMmYzVEVWZTRrbXJMWEpXekR3amtRWWhwbTROdCtH?=
 =?utf-8?B?eWNBeE9qYnQyczFNcU5jaDB6Q2MrazhDc09wWWcxSmwyYWd0S1VPUXhNaW0y?=
 =?utf-8?B?aE1JVE84Rm5jdXdoRHU4dkptWXhPbHg4NlFyV3pNSFBwZ0N1ekttVEJSVGZa?=
 =?utf-8?B?YXl3YVYwUGlMODdBRHBMcVJ0SGtMYTdOQy93SFN5MXg5WkhIaWxvUzBHOFlC?=
 =?utf-8?B?dVhnalE5Y29lM3hGL3VUSG1HMm1JeGNYbFpBZ1dVTSs2amNxYzVidzlaVTZu?=
 =?utf-8?B?RDJGM043ZkNWcEJ6cENFWUkxcDZBaTJhSWc1Nkh3TmNKdFJ0ZGJDTk9zMDZS?=
 =?utf-8?B?dUJBRlJWeDVjUER5UDJrTENoQ1QvTFhBcVljQVQ5NkxRdDd0UmdsdXM2ckVx?=
 =?utf-8?B?aW12TmNqR3h6M01HckxqdVlpSzYvZXRsUE82Q2RyT0ZDaG11QUQrSEUwTnI1?=
 =?utf-8?B?cmdYeHVtcjkrek9vamJaNS92ZW94ZUJYdDhhMUtyenZSMUc2UE5HQkc1L1Bx?=
 =?utf-8?B?NEhYRnowai9ybTBUMU96Y0NqbWg4enVnVzhDc0pqZnZyRVBudzZvQk9WV2Nl?=
 =?utf-8?B?OHhyQU9xanJFSlc3Y3QwTWFHdEt1cDZlOFdxWDJpa05qUEd2UzQ3QlhNWm5O?=
 =?utf-8?Q?4QgKYOtsYYBS8jHk=3D?=
X-Exchange-RoutingPolicyChecked:
	cpLx3IC0zPsf8KJH8G6r+O4nUU1sCI7/57BUgBX7Nm81SmndvEa54fuyJBvg3a6/XUVmCvqWqeLalz1xEatJme2uJQgy3T+FGlTYck9u0IU/aghYoWebnyWroyBOS8ZFcSZzV02SppUoc++v/LObgfHXRoV756aRIQgvltD6IWKq+M6Qu4eN9nrwtbpqvaDF2T1ZM8Tbc/y55S7dDhVhokEHazadXql8U19mHBqlJEK2niO44thsNBdzWfKweIObyCO7P16aVomiXij5dXBT+4DD8J29AT2vJFbdQysRreJrOPP/cuekc04jXpUKIBFKHJTrrs4wjPvHbqFu0rPEWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ej9rygB2KAgT0LBIBmv+ifYXv1mdFs03jVqMFhbI0OVg9pFH9L/vQe4vdJa5kOTO7d9cTLzpTRwWBr/2PU48lrn0EHa5ab0Qrd4PwHqWk0/JPIGYJCIuFVxYHU7DYLW0wvvKMuXkc4xDKlZnrB+a6WwUTmtis/N9HzJaNjTFiasEeTNSRZIjmCgmeRa3EWM6ga2iQ8LkhMpkkOG6Kp0+SPN6LlQbqW7idxLmdUYzATr7bccgrOOH3N70kEcjWn3bNxCCvyCwG7E/GYZvNxnWSC1QsS3Am86gIJTmNsp3zxl7Eo2XcXcVtfNSgDBP93IV8mj5Fw7IExzvvF9SlguU1tbQhfKzqAHSqymJwbQfgc3v0mHKCRwZPlJ7DDiwEUfQBOXMuWr8j9JqEVPGHJV0mdlaH+m39RJUr2KshWQYIUru02fZw4eFLU91M9Ku6TFpEdF6djmiqr3SLv+/3zuvc/gZt09SoxrbZ89cMdhLZm8YHhlCi/yBSv/faMpxSeGmIekl6+sd3pAPOTGfJmnWPp9vy2I/E/XjPWDLrSyMue1lnYVlc+3Xrjt0y7ew8EpldoJStri9E7xLJsnSnY3rV3CVgkN636HSEZAFHes14Z0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38ba000-9a30-4519-ee82-08dee8a3e519
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:19:35.8524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lrpyk+prrq7mOghY5Y+yjfV7k5ciwmSJDt+73jBkMXJTlwb2Aau0mT9+WqJcmAlJDQFkcpJQ9IkKqXy3g7o0tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230101
X-Proofpoint-ORIG-GUID: 94qU4TptUQTY2IK7lVdV6NJ73WtT8nHV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwMSBTYWx0ZWRfX1vnLDZUsY+GY
 eZXKHVVBmo2RKhV/lSQrmti4ZPH1wI3p/NL2xGjrTz3cVyDdG43hXKSKzdFdM/4E1yNVu+6Cbzp
 tuKZT5wlT9qcwSObu38jlnieNQ1ODgYQ/sZIvxoc918NBt7c6lU3c8YG27zUNeD4d2zOjzGoHXk
 0cT23DnsY4BEoMpD46G/iqaUU2H2oBtZj5F0A1uPlxcvWmMOrOejvAp4AuKfdaE/BfGmrf/5yFC
 7AUtQy6bv+QLSV1O9J2dkPiswKBTiSvRZjCxyNdgRj3ZRFhLh6CeJygOPfwZxiySYnVYFH8CGDh
 IB95bIRAxRwMiN6N71bXi8wKctuikKjmVzQv2lnCDnWEs18I/pruYhwxXMUA3PI2u6jKANsh/N3
 IFvBblpDC5qZTXzqNNLgO5iUZWoGKw/ne3+ZKjj9i+1W9aW1l4hTTBU6QqPsnLlKY/fP2zsxS5U
 Tw0vPnq/nKcrqDN2Dg1Xi5mad1aAF0+ldihTQ7+0=
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61eabc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=R7_GMZ7xP3J3oXY19CIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12115
X-Proofpoint-GUID: 94qU4TptUQTY2IK7lVdV6NJ73WtT8nHV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwMSBTYWx0ZWRfX5B+KLTscnFDw
 UsbXNtw4p1qpkjPw+mYiXRUb8FYutucETzxOaz7YIPRLqXks9PhQOq5pUsN1Qw0mXMPIzv8k6KL
 01ATVYRJ8MbhKz+M3irNbB92AbwRn8mcexkXPFdKu0Jof9cFh3ms

On 23/07/2026 10:50, sashiko-bot@kernel.org wrote:
>> +static int __init mpath_init(void)
>> +{
>> +	mpath_wq = alloc_workqueue("mpath-wq",
>> +			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
> [Severity: Low]
> Is this workqueue meant to be used in this patch?
> 
> The workqueue mpath_wq is allocated in mpath_init() and destroyed in
> mpath_exit(), but no work is ever queued to it. Does this allocate an unused
> resource, or is it intended to be used by subsequent patches?

Yes, it is used later..
