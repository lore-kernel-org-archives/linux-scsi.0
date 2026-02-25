Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1AE3033CB;
	Wed, 25 Feb 2026 09:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772011622; cv=fail; b=RAcW577tjAPKlCwbwAnM5kZ9pDf1RQDXAz3/bd7SdhMHn0mubqEwKF1TlNvtdNCGXsIDI2pFWJOntBX4PZPstTnEGHfJzPgF5bDX314JByvtE5qWU/TZ53YfRp2tkr7kksuQiDdLwXImX8nubVc+Fl0ez3SpYQsI6n+TbRm5hTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772011622; c=relaxed/simple;
	bh=YjHyo2lC8qvc2vOCH/VHvXGYzJ3oqqPSbw306XxlNpw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pmvFo9T66V8H/L7Jdew5xO43JCdn4fy9AW+m1HW+sMbH4eQJwme2Aq3RPyibQDmO95vIX1GZe5HudBxSfpY+AOHvPqoOGo6Z13WT9/mo7MvKPxNWKzVM7j8qOmxYeOFXXBctwGu5gbTeH6TwLTUz4NFChOZsPDzHTJUr/uF77Do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gBgEiq2B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OCe2M8jl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gBgEiq2B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OCe2M8jl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIvVN93930646;
	Wed, 25 Feb 2026 09:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YjHyo2lC8qvc2vOCH/VHvXGYzJ3oqqPSbw306XxlNpw=; b=
	gBgEiq2B93v2/IViNqyONZ3RZqKAihbFTsC3e1rhmmT/0Z8Ng5GPm+77M2MfQe8A
	1zTx6cnQSAvq0Bzm6zjeCdNSvywgl6PafsL8WLgnGG/TbZ5+wzMs+hsqReqI68f6
	N+ZgjJPxA9/4nnYjyzq0XOjP8EUcaV+0OBr+LgVlZihzA5x4iUQBNS3ZdWWS6BxE
	4ZwsFud613B2l61M2pSWu9k3wIBn8wWT5IMpWF90gOZzqWgo2C2eJlOEqmmKLVHx
	aJ19mOesDjtxszuCSZ4MZnwqLL8/gWcHOkCuSL8bNYdbDmxfeJi+6mAgMxTtpdMv
	fqshflxfcAle2mlqMRex8w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qdrn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 09:26:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P8r64L027938;
	Wed, 25 Feb 2026 09:26:47 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fvyg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 09:26:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5jE/JZJqaWL42upkYBBvkGHLl+XgI07iq4YA6eISgPbozLsAvcm7bKLpje90NvcAp+hMIg8kJ8N61xyHOMNoIHcgI5xgz4+g0Bj+byPSWF33QYI39OoxWiz7nJ+xS5ltxoGiqEYCapdrQmuIvASLmbaTjbi+k1xnUhH1Qa1aENfJcr6AAgh6qKZAZFRteBQv3WcWrFi81116Vhgg0s8OjRVVk99eD0n69W7MN1CjpY0lHXzYhM6F/t67qur4cLFG+kPBut+lnwSYwca5sgizh/5bFB6UDOkB7K+B3NKALSTeK1y0h2JtmuX4s+blZHhHiJ4Ym7pBarK2hWwlEr5Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjHyo2lC8qvc2vOCH/VHvXGYzJ3oqqPSbw306XxlNpw=;
 b=B5qpEOhNsSMXzfSV3ped2SymePNDK+/0RhU9PJ51e0j5PogexrcJfnXrbxyyItHUK4pHAN6Ut7pPCQO5FN13vtD7BRYlfhbBj+SgbetrtXfsPk6cduv0lw1DXUJ6UiVM5GLaX0O2bsw+wIeYH6zwulMUQ3gfyWIb+T2TDVZKOvtC+t0nW8EO9hJup4p1PUfGu3rJC9Tg5P5CEbwFv0w5xkM8znTbqrex+dn/TIXM0B4XNDqEvI6yT50PBHEq6QdevzLoyC6MvcIHEtUhNUz89RaTymZmyG+iGah8ItqiKfzwqVnJ4dbzv6VIP317M9y9jIk5s4Y5XrEiFaHfAga6sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjHyo2lC8qvc2vOCH/VHvXGYzJ3oqqPSbw306XxlNpw=;
 b=OCe2M8jlhYWo0246OKSMvPwReO4sg5x3u/i+lwqb6H2EiNwIV6Hv8P52xCi1j6BA4YsDA94tZbL8ML7zLj8sy7Z4r0/FflJzx+iRLSktDp5Hrn9efuiW8EaXla8NuUO4E/ll6Bl796E+aujP3nTZw9S1kb7sIraXQmj4AhKNHwM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BY5PR10MB4241.namprd10.prod.outlook.com
 (2603:10b6:a03:208::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 09:26:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 09:26:43 +0000
Message-ID: <a1e5c1ac-fb5f-46f7-ad7c-e21a545e128d@oracle.com>
Date: Wed, 25 Feb 2026 09:26:39 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@lists.linux.dev
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <aZnuSC0qYfw0hiwM@kernel.org> <aZ5GbVxDT3gcS6WE@redhat.com>
 <0a6ec8d3-7623-4809-b275-3eccb94419d4@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0a6ec8d3-7623-4809-b275-3eccb94419d4@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BY5PR10MB4241:EE_
X-MS-Office365-Filtering-Correlation-Id: a9193d19-54c8-4243-b825-08de744ffc96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	AylOfSDRvTIOvn7segPfivwjcDDGszBCI08l0nIzVYwfOPxllsU0ev24lE5ZdgAYWsLmTFl65GtEcboW5PP41LmzM1okLGVD+Ueg2g5UgoEqP6Wr+JLG6oxkQcwzWAfJjMylWCS51Xe5UFnvCN6CjHe6yko8XPG0a4uNKD8zgBKWDD/MTq2gCPJMWi5kifWn9wWum+4CX63U+AkNhkwlLmw4aPlP0QEZGP9yZTLapGv+FWEu85/4nLSk4RyLeIo+1NDEl5U8AJN5kYeEgZBRMBRqNEX0cP+HyYc3SgvuBO9rViRYCgBoA6yTiyDhYPCrU4phGHJ4/XlpzyOJ+015qdXI9ZdRXhj1lU4aemBV7EWWsZ5su+SgBYJiBKBqjtUU5Xh7J3QY6CBWrtW6JvfoODpL1U7JspAdXqmq0e47+HGNb5cIE/f1z3pVtk+j90+xsHcekFlAR+pg27CynbhA404din6fChmmGzSgW5huq4b/SJ3ApDg92wBv7AL7YRgVuG+moBBbwXC4A6RyegaZymG5lTwYVbBdn/wq/17OmHUatJVDRW9Qtkr4ebQonAvJNCe98GTgb1pfqVvF530PgnN5j1WXAQlbTY4RW55AKLOg4Bl3n5tmfhciaZ+OHHAvp92oowzWZAaDjZGfqfq1pyal0eRYyW1w/ZgYhXy8GsIyhg3EwImpq8gDpRuirZkyVaeOVdT99JSgNtzOlPAn60YP0ZKZD1z4bFN/88ysmJM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGVDem5Va2RQK1RvY29RUXJsTEVLN3AwZTFIdjlyNHNldUttNXY3dzNVNm5O?=
 =?utf-8?B?cjhwV3Z6YlFOZFF4NkRMZjFxVVRPeGlNKzhHOFFqUnR3ei9mYjhKR21KMVBn?=
 =?utf-8?B?SUZ0bkdUeHBITG1MWlRjeUdkc09EMUdLSGhXMjYxSUdFQWw4Y2F0NUJGNXFo?=
 =?utf-8?B?K1JsZHJXTDNETjIrN0JxeERKdTAxOXNFMEhFN1c4ajdjVGN2UG44eFVHbnRQ?=
 =?utf-8?B?bEJsNXJLZCtCV2NvV0lWTUlXQklNVmxRRkVyYXEva01PQ3Mwd3VnTWFWZHFT?=
 =?utf-8?B?bDk5WklqNExXa2M2SUM3MEw0YmU3bi9hd0NJOHF3RVRSdVFZbkJjZFRkcHU4?=
 =?utf-8?B?Y1d1NlJWZXo4SDIrZFl5ZU9EWmpuT1E0UkxLZGQzaVJKMUVNR1lMY1YxQTdn?=
 =?utf-8?B?WjZ5K2ZaUjhRUnRqeDdPWmo4WjNTRjhBMjZPVkcwL1NTWVJaNjYzMm5lK0cv?=
 =?utf-8?B?NDRTcmFyWWZjY29WUWRBMk1PT2orWUhKdUJBd1BYZklJNmZXWG5EU2ZIY1Vm?=
 =?utf-8?B?VlpCSmpxWFFwa1ZSV2dLOVRyOWtSbjV1K0kxTlNDd0ZFTW1JdU9sRjB4a0Nu?=
 =?utf-8?B?ZW83VVhLaThveDEyWVlVZXRBQzdsaFdUTzhZOHlGRCtHRG56c1NZK0xSQVRX?=
 =?utf-8?B?cjQwcnZIUWZibWtjbEJBcG1iMDhRbXJ0N0Z2N3BPR3hJeXFuWHhFTmJZeERT?=
 =?utf-8?B?ZmZ4NDkyL3MzVXJNL0tBOWFjcFlIUEF5TkdLd3BlTFBmeEtmRXExbzFzeC9K?=
 =?utf-8?B?VXNSS3RsRmRYTlJMaHhmbm9sSC9PYVh5cEJCV1Q4K2g3Ui9kc0oxQmVCMlF4?=
 =?utf-8?B?ZGk5dlNEQzV1VEpNVkErakIyTm1ZN055M0pJVFh0MGNrWXArOVJuT1hSdURy?=
 =?utf-8?B?RFRVc05QeWY5N2FESUd5Ym1RSWozeFZVVVZIV0l5b1doL21xeHM0cWNaMkxI?=
 =?utf-8?B?Yll1QjBjYXJSRXVrd05pQVRFQ1I1T1VTLzNvN0lXeVFHZFRmL3l0aGxTM3pR?=
 =?utf-8?B?Z0N5RUYxWHc3TEVvNnNlUmUwNXl3RUhNb0tsM2d5ZEptR2M0UTROYXdteGJi?=
 =?utf-8?B?bFIxcDRSdnVZS2hjL2hJNjVFc3VrbTRUbzlLbm9DbS8xYmdnUFc3MWhYajF2?=
 =?utf-8?B?cEFCOVZGdGZjbXV1SThuMjlFYUlUZ3BSczg3T3A2V2hEV1hCYzFpNm44ZndD?=
 =?utf-8?B?RzNnOGJ0NWRBQklISnQzMGFhVFdRRXV3NGp4S1BDV25xdXhVbzE4aG1pSHJU?=
 =?utf-8?B?VzBMK3pVKzF2SjJqT1BuSFNqa2dXMW5xQlhOWmRmWXFoNjJPVDZjMnVqMW40?=
 =?utf-8?B?cFo1bnhhc2Y4T2tVdGhHblgyQ0l1ZWE2TTNUMndYU0FicWJjekE2RGNiaVJq?=
 =?utf-8?B?TURuT25qNVE1ZUlCaHZFRFR1YWJTd1ppTUx4MnJRbWQ4NHFzK01JWTZobklY?=
 =?utf-8?B?Y0VzS0JMNnVtL2h5dFZCbjJ1V1diNzR6eFh0Y2gxb2JVdWt6Nk1ER2lxZXRv?=
 =?utf-8?B?ZmlTRUl2aDdEaVllRVZYNWg0YW1mM1ZtcmFocEhYMjlHNXdrUUV4UXFwdlFu?=
 =?utf-8?B?SjlzdS9wbWZJbHlwM1pvQ2haZGVJdDlFZmZzazFKMzUzUjZqdlNUVUFpSDdv?=
 =?utf-8?B?SlhLNDdFOUd2UlBlWFBtaGdoeUhVdkc4YndjVld2S2lNdWlwU05neldwN05x?=
 =?utf-8?B?YkE4THQvQkdtL2lNZ01HeFVWdVJqdnB5enZsUnNadUNFNjlpNnhHVjRwcTYz?=
 =?utf-8?B?c1RVS3V1SHFZRDdnYVZqS0QxZjdhM0dqT3VubUEyeUtrc0syNzI3V0hTeUk3?=
 =?utf-8?B?NXhMVWNkdjFRUzdJRk9sSkVmQ01mdmxiR09xSVN4S3FKTlB5N3VKazVFL0U5?=
 =?utf-8?B?MEJoNGVXVzdabytrMUFGczVndW5vcTIzVnNZb3Fra1ZtWE8xbjluZmhkVGhp?=
 =?utf-8?B?YjlPbmdlLzhmMVdTelFJOXNmWVNUdHFJcnV5TjZhN3g2Qm1YWGhZTHoweXRE?=
 =?utf-8?B?djdIOXAyZm9rN2FpdDR4YlBBUEgzbWFqV0g5bCtDc081YTR2RHdSTnM2TW1s?=
 =?utf-8?B?alF5MStmbnBxdjZaekQyTkk2YzRQL0xnSDRiVWd3WDA1RU8rd1VhM2lGOU54?=
 =?utf-8?B?aFlyZnRkQTNhei8zRTlBS1BCSEdYMHhWd21YMTFqUGhCYVFTa2FsdTNwYXUv?=
 =?utf-8?B?Vm02Vk5XMXcxZ0Q2S1NZQmtDRlFzemlCMWJvdlc1Q29mRzMvVkJLazhvWmxX?=
 =?utf-8?B?dm1WVXlCQmFHUWZldTM3dXo0K2hWWng1Z2tPRk5Na0xrQS9sYURiMytGSzVF?=
 =?utf-8?B?VFpucURGMUlOL01YaldGbnAza0NGNU12SlY2Z0NCS0VuQXhWaFUzZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EWajjINM/UD20QKXO74cICldEPQqDou/YthKQ39pnbmgq9+H3tyNv9/mDObKNjxu4e8I68oDUcMWQWCJfTwFWlFXVnrfS05gQ24Ut/zP7geIltV2FsQjfAjj7YaSalJmGWL+j2t7AKMsWeT8pp/U3E4tA/l4mjMWr0ck/9MI994D38nz5OW6hHrNRCPd7Yb5TFY4bkySG6zkPptZFZ82LQleDBnMlJXo7mi1o1umTv4n3JWCeG36L8/63OuSZQ60VcV9YHQwIz/O4EJQKKoO7w2f9DsLYWxICCdpY2pvOlz4+KNVZYNUsZxsl14zcZN3tRXsGqRycNHO5ZCD3SOY0IXfCge/b7mtCN4u1dyU6v7I5rHmaZyjPG88F0GH3iGaikCb7tD+QacBjqVGNCw/UnSbqYK1QpH7oyS0NaQHlC+/ApD6shCo9c87KwU0pI/9JaJq2OlNoxMY8FTA5jnSkMDCEoAFcdr2uSd3kL8vPLBFKNzSqFtMr1ZzLgmwlbTuNgfbHZsfll36NvK75neyHWWF+aLlbzwDl9B+sIwUEw8tvqgIGBg6Ufo9ABIIHdpy8FYFnPjHGdU8wT1GGZhTyKPiv/iLyhcxCFO9Sgbc8dM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9193d19-54c8-4243-b825-08de744ffc96
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 09:26:42.5470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Huiq9N8T6pWD4DbK43E7hOMwlzInFL/I7fUDg0FHY/a03huOjZi5RMJkYxs0QSKaCHK0Wj7HULTLoo9iXCUw0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4241
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDA5MSBTYWx0ZWRfXwfao4jLSZ9YH
 LQmfkXd4Npt4LRwk6QB7ARPQyAEPOA5AGSyvTb0pwfj/C565DtnZ21UOm4EhR66d6bTqtUt/ALR
 WR63Q/mMoakS4iX8X9gZjUzCclkR5yk1+v6SwFVU38RTRU0kg+N/c9YHtE7Ld01n4eiPkmGb1p+
 gnu2VgFWzEuBcpvnLFfU+rXJB78qrz2anvythvZzjm6/SSSgoUd6t2U3KP+j/b6cSCMo+jd07U2
 KDbzxEawNWadFU7eTwrqKoEs4NjvQuR1iLVZSkheuN0mN8/D6konZ62Ljj3+/1TIF8FlCkQYZgv
 R/WM290fOa1anjJ1pBtFt2eR7KrNKNhCufAUs5mvhf0mCDQcAaxRHCsltlt+kbmM2bLMJ6bCJ/e
 Xqjr4BR4xPbDCnjOXn9Q3G2Q2q/pePzMFUfgjD7nC0WW6hjBVlcTNnECMWDiFbCi14gwIQ+/5jl
 VfbWM9qKli51SaOfhe3BRpQvPig/ZCbSar63Xteg=
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699ec058 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=_4atbBc_SbYbbAjX0H8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: oS0KjTU6ZhEDcTRkqhQgHj4q-iodaRPm
X-Proofpoint-GUID: oS0KjTU6ZhEDcTRkqhQgHj4q-iodaRPm

On 25/02/2026 08:11, Hannes Reinecke wrote:
> And I _still_ want to have a blktests for persistent reservations ...
nvme/054 supports resv testing.

For scsi PR, we could use util-linux, which has blkpr.


