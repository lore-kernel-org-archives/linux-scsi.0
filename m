Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E864B39DBED;
	Mon, 23 Mar 2026 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774270748; cv=fail; b=NWxNpF4X+Ghc85LAzoPfuqdnHlSh5z2BQtcKtcVs/FF1J2KDeMo5umU9HS0JX6EkgJPSHoPzVQvah0hbHRNq6JNoOl1IzuvMGhP44LHz69vGzohq6S6ITjsbJuDanmH8oE9lUT1O+DDSTWzyveWVJiBDC5uilvPtLhlEDB1/C9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774270748; c=relaxed/simple;
	bh=1wAyaYi0hfeJK/MTe9BLotxpMMyLIAGo4QX3ovZqDks=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JR5YSPr4dVYKgrQnJbkN0OOGLuiAcOSLRR2LZi+FuvztUEMgHQmL8wwnBLuIHWAs7XywDSqZQhrKdfYWLKOa/RyKe9YwMWZgnBOGQwezMH6iHOaYfLsvXDN/FRxyI8zdVsQezgSvSJeG6f3GEbLJCCZiZlTJ+vTeu48sy5sKGlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d2V5/mYd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gUwxMW1v; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d2V5/mYd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gUwxMW1v"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N0F2kA1085304;
	Mon, 23 Mar 2026 12:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zAFAn+xZyR3nP5GGdxzyVEV+C1B0q9DuBys3jlk//l8=; b=
	d2V5/mYduf3dWxJV8o20VUcpORySALtKxWHnlkSQy5wCmkd8CyCimCQp4yecqmK1
	va+zuAVtpVdLpLAfgUOyg/TnnHnKejCyMJDb5l3i+sJNyZ0SFUG/nYuYl+pYXPrc
	yqmLMa6uTQCY2qnMSFoiRbTO9ZRyar7Dt6muufgY4sQznKo9RIidntIsjkbIt14G
	wK5jdkJ1bIFnbQWSkFqrZsa7gZoC5xIPRyVf7RMYHWwHTRY2fLQl9NrnoCaa9J8K
	hJqQGdifZmeZcYwLSX/F1kLim2umvIjVlrVF8Y5FA3UILsvz3h+mS9kFoyULdTOa
	kd8GbcQBEtwY/oazU4FmUA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kejj673-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 12:58:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NBEKQs012336;
	Mon, 23 Mar 2026 12:58:54 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsefg9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 12:58:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6mVEZ8+abU3eK8e83mJ2D6lxY3S+68+TiRf8mTPnW88n8QNV+zQcOHV9oF7xroC0UC2a2nSYL/spmp5wN19He4uFFi5SRqQmke7HIJDpmW8UXxV/l6Uo1q01FOZCX3wjbCAemoVTEbGcHe4yyLc0IEVAMIfWyodehTGGwYWsmHwxw//Pz8ju5IcXd2eSi2o7venWfYPtM2ayx7ENVTdxIg+knQQTQj+LUTOs40qgKnZ79mO7Qz6wi9Zh4ZjiHxv8lVI3DWlTQZH1+rHrgIcfnRwMRaMxe/pVndEDfaLkPzowgaXPP/+i8IytK4mewkLpK5u3oIrI6CxV1RiabPgmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAFAn+xZyR3nP5GGdxzyVEV+C1B0q9DuBys3jlk//l8=;
 b=BdO+PzYLSSjWZpKZyoEiKjDubeJkCnqWB3ICmB8wDqol0EzIe06K7OoV++fxfPtCXY+XsKo+hMy5Pw2SvAspxkwNTSthibjLWAswKxe+Hmc22xnvuvNu6t1kAhc8Ikv2e8WyMEUWvjcKMko1MyoACF4RtgduZD6wFNDk0DQWesMsAUTR7h8b2MrWTRonUayR0KvOlQTQBsXih90CgDYZhonZgier/E1WElQAsEFBGgxVCdPDxTeX3JWWN2hOFLI9ZzDEeqDrLtgDgPjzHIC+CBSuBe5YEHEWhdAG6rXaAcf1qOwOcwMRiXwk3FGeTFejhWB8MhPkVcVVuhBfm4LwIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAFAn+xZyR3nP5GGdxzyVEV+C1B0q9DuBys3jlk//l8=;
 b=gUwxMW1vvIsezOBCw02b/d/oXveWY0zVAEb6UJ/Kc3rsVKgxHWV+hUs4+haTGhpOTnCY6G/MSJC4vggCOhzDGw81row6lkRsw3K2FS7Q1aPCAYDNmhbwdY0mmd1ZgNhZdfgkRlg2yyGYbgFOo925qnUhXrpy6KOhqx/O743UOlg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH7PR10MB6356.namprd10.prod.outlook.com
 (2603:10b6:510:1b7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 12:58:50 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 12:58:50 +0000
Message-ID: <3a2787b2-e875-4e70-9b0f-80071c0f7aba@oracle.com>
Date: Mon, 23 Mar 2026 12:58:45 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] scsi: alua: Add scsi_alua_rtpg()
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-4-john.g.garry@oracle.com>
 <fc8e8f45-6b82-4400-a5d7-f155287942f8@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <fc8e8f45-6b82-4400-a5d7-f155287942f8@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0151.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH7PR10MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: c2cfcca1-6ab4-45d8-9e28-08de88dbed97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8cDNwtpokrCgPE0oj5hMvX9sy+ts8Xb4L/NtQ9otXUZ9yR02mR8eShexLOBEGjabWFOIHea59JdOzATeRf82DN9XuW+zKa9dWyFzedY2pw7KQT/sa1uL4Hbs1/Ie944kKtythYaaIx4bvH5lWnB7e0KBQyU3j3rGsV4pI94e5iRf4mmfgDAD6jJmb/nE95Q/dElnZiBetimNALw+KxQuzvLLV7GzTWZni/E1Ujup+zl4ZJVBrp4qZSWopjJ8PY+IeO1qzf5R3ItJyZwToRC+mRELHQXl3KiwIJyDfewLps7jGqofwSUMjaF+Kb9eodR3vZvvqY21Fsm1pwrgK72cT7ZFSiUyOwTRRl3F/fre83BQB6hZwRNr03cokX+O3LJuSr3VFuFWz8hUYlI1TFCvkkj/6AUu37rbs6t06/vWpXAnOVQ1zghogri0GuStVEtPxQPNxVaZTkLi8YPXY9BAoSBnUwpmhIpCQWOYYfbDnAFxECsaz2cukXrYEeEhHurO4dCzNnp/ajUsgSGwc5EKt4ABpyVHVUhfFwFLxmKaOlXaWvvudDfgEs5iPGAaXhr8wuKHdcmg7dpG37IPXJbYjheExHuQGCrdKdN80RBXoS5sL/KCqFsFShd7TNqUYWrcU8zdWoIoFxV6bhC6ANavpBJNQI0JoPrr9VCxqjikpbQ7AdZHBLjocfWrbCOEtLHxcXeAMM6+IQlTw1TwNuwiw+em17++KOQ3PI3r4J+IvU8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFh4R2VLN0NPaU1kNUk4WEFzMmhQazUvZVlVSEpPUHZsTnl5dmdETU15RWsv?=
 =?utf-8?B?WW4vb3ZYRFhZU0M0ZC8zWmtPZHFOSDhIUnU1dHAwTnp3cnh2WWVoUmJEZnVL?=
 =?utf-8?B?aklHdjYwdnErc2dJd29VMVlIVG1YN0cxL1ZGZzk2T2lhbitHK2tUbDBaMU1y?=
 =?utf-8?B?ZDYwZUFmWTNIS3EzS2o4dk5ycEMySXhsbHFMaVl6VDdXQ2ZocjMwcllOVTRw?=
 =?utf-8?B?SFZoTVI3aFIwODA3Y3lyNDRuK1NlVFBDODkyUjlSZjRlV3c3b3lKODhjVkNH?=
 =?utf-8?B?QncyeFhrcGdZc2htNThrZGxmc05LdHZRa2hobUU3VzdLbXlyYjlaZ0c4eTI0?=
 =?utf-8?B?ZkxPbTc4VmR0a0tFZmRCaHN3S20zZjFOUDBUNFZudHZYeGFweVo4TWJaNEl0?=
 =?utf-8?B?eUJiL0J1OTZ0Q0xmTnY4aTBtdlF2VlhCeXl0bnhTS1dUY0JPQjdXVkxlbnVl?=
 =?utf-8?B?V3dmVHIwSDR4cVJxTVV1MjY2eGJKTHk5YVJXbldjSVJMMFBkUnJ5cXhodFBj?=
 =?utf-8?B?Q1dzV2RoVkZKYlFlYVB3SnVUY0NDbGdmdE5JQTRvZkxLN0U5ckxhVXNES05y?=
 =?utf-8?B?eGNHZzh5RGZqcCtCSFNobDBpQ0Vmb1lQYlliRHg3a1ptS3pJVld1bWVReXc5?=
 =?utf-8?B?dUd2cERUMm5Fa3lTQjMrUERTY2ZmajJNYkxBQjAzbGhqei80MytVL2VvanJN?=
 =?utf-8?B?bWhTeEdnRnhvYUl6TTJUM2g4UEp3bjdrd1VEbzUxNndLMHZSUStvRTVWQ3N1?=
 =?utf-8?B?N2RWaEl0eUMvMTlpS1ltUHdBaDQ5ZnJLajl2TXJSbkxVbVNRbU16R0ZQWFk1?=
 =?utf-8?B?ZmRGa2FzT0VEdC9WdXowWmlCaEhJV1QyVS8rcGVySWRsTDdva29ZS3RCR01G?=
 =?utf-8?B?eTEwV0xaQWpMeFZZM2orbDFXWjFtbUU1cktWMVI0R3ZYc3dNYVZOanEza0tq?=
 =?utf-8?B?Smx1S1ZrdFJkc2NNVUVnUFExSTIvMFRKZmVlZ2tiRWRmWHgwc2lWaWRWSUdQ?=
 =?utf-8?B?TXUvN2hzeFJQclg5YzBjN3IwV2NFOFg1T2tBdnN3bTJjWWtSUXoyTFdKNUZF?=
 =?utf-8?B?bHZ3ZENVaVFsSFZ3dGM3L0JRYlUvYkpiSjB2a0QyWHBZNUcxMFlRQk1TU0hv?=
 =?utf-8?B?TGlxd1A3dGJCM1JXdThIcTBWZFJXaklrczBOOXFkckN1anBzaEt2Y0RWT2Ri?=
 =?utf-8?B?bmE1Y0pBNEw2b0M4OHMrQkdQMzloQkxSQlZLeDNSMDVubHdsT0xZak96ODRv?=
 =?utf-8?B?QjI4ajRLMnNUS1pPUloxSzBOb3ZXcUJwUTFpQnEyMlJ2TjV1UXU1dmExQVdt?=
 =?utf-8?B?Z1RIY3d0UVpicndJWGhnZjI2MnRkb0dDd05UNzEwdkNBUGpQRWs1UTRSeC9a?=
 =?utf-8?B?OEN6YTRSQkV6VVR2TXRTNkF5U2E4c3RSaS90QlliTFlEZStqUk5HVnpSeFJM?=
 =?utf-8?B?SmpVVzh6ZFdUOGkxaWt4RlZBQkJkc1I0M1VhOWhhMmtBalEyOTBFZ3A4anZi?=
 =?utf-8?B?N2huOURUTHZSTHVVdlhtMWtFQXRYR2xML1hQbVprdnNLeWxkempmaW1EMGNN?=
 =?utf-8?B?Y2NyRVhsTmQ0VGlJalBaTS94OGRoOGxwQ1NMZGpoajl4TFhQU0M5TEV4Um1H?=
 =?utf-8?B?MEEzSWQ2OTdpQ3gxcDUrak84bllpVVdOL2E1ODQxak5vQ0FzZkFhamZTNGJZ?=
 =?utf-8?B?WkZVUGY1VVNHdm1BaTNPSlcrSjhNYUZTTUc4UW02M0pHdnBod0RIdVpDR1h5?=
 =?utf-8?B?ck0yN21LNTJGOXlKS3BzS3FpUCsySW5Kb1JVV3RlOWJpRnpINzk4a1FCREhn?=
 =?utf-8?B?eXpUVnEvV3lDRzlHTnFCQktIbXNYdUNtVnhwaUNLL1J1SEVxR0ZRTStyOTR6?=
 =?utf-8?B?ckVKNnB0c3pCZmJwSVZheHlLZk1icSt1alRUeWhWUmovaEt6UEw4dzl3SXk1?=
 =?utf-8?B?NjFvS3pQbk80VSt5alhKYktMQWlOaE1ESVJabzBQNTFHSE5ac1VnUC9YMzF3?=
 =?utf-8?B?dXlKVDFPdndhYUF4WjhIcWJrK2gwZm91VXIwcEcwTk4rcklUNXVhbUY0amlm?=
 =?utf-8?B?Q3crTWxqTkZyamJ2cW01T0pUbWlEYmg0eXc3bFhTVlJ5bHV4ak43bHhZaUFH?=
 =?utf-8?B?SklCOUlJUzg3Z0hkQmtXdk5PcTE4b1NmQm4xZ1dmQmkxZ2NCMmltSTVJNmdo?=
 =?utf-8?B?YnFSM2R1V0w3NnRxc0E2ZFRqNlVqd2o0UThnWjBSR1pvY2VsVjA2RjA2bFg3?=
 =?utf-8?B?RjZiSmpCeUlNbFBwZ3NuUVVTZWVuV1RNQ1AwSmZIQWhYclRqbHZLRm9OY0pH?=
 =?utf-8?B?OXVWRUlwV0xWbUhFS0FwK052ZVRvMjhmR0NaM1dMdHJLZ2hOOWdINkEybndq?=
 =?utf-8?Q?35xSV3hDQ3ifXzHk=3D?=
X-Exchange-RoutingPolicyChecked:
	YCrK3fHWHG3S40we7JuvhOk9ODp0Dxs+evqLAmZjJqBB27Qo2e0Had0SnDTabHMX1Gd6d35cDEmqu1kw3nXrZnEAqbJ4nT+/JtHm4V+k6c0NZm00eLoxuuxNZO3NA/384NipTWuat35XOGtECHK3TqhCjkA+lIVJmOYnEQYv2Dy1Xb+Je43O4ma5+Ozzb0NOuz8OrYm2GGLcM8iGljxOMPF4xJkqF0oBPgrttRzQwJ4gWt/bKymVVKObD6Yyv3tx8aeS9FQ02D2Bjpm/l5SbZY4XFsMVVJJ5Ujhd02UHdReKrmnBQOWQN+yFyS0/GtYU33DFnnOPX6GMMxNwKtH3IQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x1p1dac6wZ3u+50QENL6swJKn4CVjipMzUZOOj+URyGtuJgkRLvAQfL2HO7AZt+xZRuEqAv2NK4/MWQohX0SGQ6ouJjV12d+vZ8/DS5nXA613p4VIe/y5v8tx6w9dfvTY4mDGRzqOojwXgbDhBzl8ZH88kzuMpiIVrVxaYNuKZSINGDfpJOE81T2DS/rihwQFmCIVdEjRwVIiAwTe3Cp0TguWXuvXgTcswCxvFviKw8WhF6jh2bc8g/AgIZWhj2w9DcuzsFwGMmodt7Gn5Vd25oEBFjT4cUelIrOe8hTTnXeqKgV6+czsNg9IgKYF3dM/+3eXioz8132d0uA120JPGjYN9Sa1mrozH+tWYzCg8py2g+EYgDbLSYNkgT9r2LHkCih/c3Ifu74Pttbw2eY7A505FnkbvzAwt6iivtDDvkeqjF29hQp+Sj1cpEYIJtJccnsM/G8uxQ7AWYpddNxQ5ce3V4iE7bmm1+beTGWDR+o4Lci0kZn8BhDY6HjwfIsMYfo9FddwLRTnEvvRgO6/VNMiQnJawcqUx92qqoBF3v//rWCRvErqRxhHJTKjflwqha9RNZHvO6yVZNffzSAuZGVSw82cP4UCR07eISIjZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2cfcca1-6ab4-45d8-9e28-08de88dbed97
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 12:58:50.1025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZ0fnnm71zopAmn3q1xVITk0d1c6CTkdio/SExG9Zc45b+yXSkwmC2Oz9dKgVLNJDede27r3plmSL4QFWea5wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEwMSBTYWx0ZWRfX9vxhxbzVmdVJ
 4oibncyJVPwqH1WccgpofrN0G1D/AMyElTXg073ti8X9r5hMBrAEnmRaHm6dnhZqwa1R0AeWUHw
 OlRgTkTjIR0IABGnW2q8NONnNliiqWHKZBl5R9zaLe3zayWPKHGqAra4HdZax9ezVa4z3OcWmt7
 NfvNfdoXTFKd6dC0FgDv6U68XUCpQMItomP2ivTfpb8ChbPVh+ny0q5S72zU4N1K/eqEZ0D00HH
 tEYBj8hhbmcqHwpnCQZs9jI8IEEv9Rq4wCLVfJhlelNhl+KZxK5TfwlUri6rxngZGFlQAoJRkpO
 3GFGOdS8+5gUfzQ2Ws9D+0pOSRV1oL0aYlNb2OUrGCmd2N2K+SOOtzeBHOFE+83fVlZmKhFH4Nn
 nn/HrpSU0eEDfXpiMWEZ6icQ6g+8GIJP86D9It0UkilX57UoiUiAyiyIdi6xesqbx2jQysUPCp4
 d3QDkIma/He4uvRFTeIytxQqMpHF10kkUg2T/9OI=
X-Authority-Analysis: v=2.4 cv=GZAaXAXL c=1 sm=1 tr=0 ts=69c1390f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=SRBp8-0gWoqQ_nJRA_gA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: bqY4vBlGySp41fv17GDZRLtxwPJZlitA
X-Proofpoint-GUID: bqY4vBlGySp41fv17GDZRLtxwPJZlitA

On 18/03/2026 07:50, Hannes Reinecke wrote:
>> diff --git a/include/scsi/scsi_alua.h b/include/scsi/scsi_alua.h
>> index 07cdcb4f5b518..068277261ed9d 100644
>> --- a/include/scsi/scsi_alua.h
>> +++ b/include/scsi/scsi_alua.h
>> @@ -16,7 +16,15 @@
>>   struct alua_data {
>>       int            group_id;
>>       int            tpgs;
>> +    int            state;
>> +    int            pref;
>> +    int            valid_states;
>> +    bool            rtpg_ext_hdr_unsupp;
>> +    unsigned char        transition_tmo;
>> +    unsigned long        expiry;
>> +    unsigned long        interval;
>>       struct scsi_device    *sdev;
>> +    spinlock_t        lock;
>>   };
>>   int scsi_alua_sdev_init(struct scsi_device *sdev);
> 
> Ah, right. Now I see where you want to go with the separate
> structure. Still wonder why you need the 'sdev' back link in
> there, though.

at some points we need to look up the sdev from alua data, like 
scsi_alua_rtpg_run()

> 
> Other than that:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

cheers
