Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70374A4842;
	Thu,  3 Sep 2026 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439160; cv=fail; b=e+HnuyI+0aDayKJcGiGuiO6dflEo/HG+htvD5ifaJVZ4lNM+T7vf+mnST1TfVOXd72tyzJCii7zcY0YbuexbH1f15tx3GvRCfG/qz96zr3YB0yFy/nGaefG+0itoBYpomFO17Z/levgUG4W86d3JE1jT1l/zpJ1yTL4Lle9Y9U4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439160; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HakbLTo3dKFgq1AvUNV84rLm2fzDOY6OtJiAwzn5lwucse+ZquxSIGC8UIt61Fuj/9uRkRaUcwzb0tcsU+p8LMuTqr35BZry1/YXFm6ZnwazkSCClJPmCPlNF0rr1fkRAjIG2yoAP2B+3PKKdl8vODGkoGSSGvlJFMh+yuRkdtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=D7L9J4fE; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=s9wY/Ell; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D7L9J4fE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="s9wY/Ell"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788439158; x=1819975158;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=D7L9J4fERhqGc4v27NbrS2IMZy1rjiroxjogMlDad/NKFWsltMkqmQum
   nrnrKBKgSrBXZUKEq5d21AZhJ7Qtsi74DbmqdJEt6ZVztHHy1a96BejOH
   s/ZvMjJvXiFKZx+qGAGD+Z/RgHVT7QUE9ZvM4/eehgjpwPsYAf+sMYbFi
   qvI4GbN4oIpc8w55pdf95rAgyEYYpb5QXLLEskyCJcDXzbnJ46QLOcQf1
   vipmp1XTw9nvslY1vLz47bxPxT6dGVliQiX6EiLImrJowbPFH2qesJz2N
   +K0D62lVFA8o/YObnxAv+E2MJdz6NlkJtsQYoZbfIBfykKgrHjwaEhYhO
   g==;
X-CSE-ConnectionGUID: NS+PiWYGQcqbD/Y0JyIowQ==
X-CSE-MsgGUID: vFN844WzTSG5iFsoxDOOBQ==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="150667847"
Received: from mail-westus2azon11012052.outbound.protection.outlook.com (HELO MW6PR02CU001.outbound.protection.outlook.com) ([52.101.48.52])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Sep 2026 20:39:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEbajb3cOVn627X6O/vjAk5w4xBJwsKJqat5jTaeo+74++nGWjnrxn65K2T+T79lYudL0tEh0iqpKdc9xmFZtKT6JfH+nEMzIa02K87pjCT/yKf1YQWxCh6i63abGGO8IDb8Vw4NIbUobvLpGDpgrvWmC1APbIRyfn6d6dvVYX9Qtvuqt39ees6K/Lzw+Uuy1BJIMProaqc8sgrS2JMwVSyA6vki0G8lUf+jWuDiIKXeMpdjOEmZbX8DPhOeYyeWGSH9PMG6AkZprAGV18BnLFV5l1sTgfBi6jcPxHCl5N0yHZhhFnOd8lZqmwKQe28qSP6fv6T3bF7YurbkccHtcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=svTC6nnN8/duYEUOSvLJG4i5kifn65whXLfxMhg0ru0yfARV9hAyWYbumPbGZmH+heBZkI0r5gaO2ObOgnIjLcptBe98bf3kcx4jkuclIpZ+hTFl8LWZjx4UmZwbRtHCjQO4ztQtALoYUq7KpcjOrAW5NO7pQ6/ZKXdOIc3oqZcolTeHpOYc3gbx149csSnCCtS8R3Lr9QZ9EHtuE7W8zhsDR6EFg6Shhv+b7b1d2puloSEBlc5/uBSNPgiTLJZXeB2RzeHLkgLGcn1ixZpmjx8vjV9MwUCm0k01zmyy7yd+xNAmjDqNcV/oWK3g3kCv/hcYEwPHm4MjfMmL1NSmCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=s9wY/ElldV7ydfkEP7HoxFBOfGWDSjv1dqqlsK0qXShexQYRUoYareImAFtsIEqAd4n+nUIB6e3ZO6a9EaBXyhrqjPChUDFwsAmPnX9rPU8dwOSqLCoV2uTVffs7j6WNekDbssgx5Zb6pIX83EDV1Hzk8g/12H05LfvTAn9+jLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CO1PR04MB9534.namprd04.prod.outlook.com (2603:10b6:303:274::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 12:39:14 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 12:39:14 +0000
Message-ID: <9d975a36-078d-4e87-b546-1f5c01fab938@wdc.com>
Date: Thu, 3 Sep 2026 14:39:09 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/40] scsi: prepare for using 16-bits defined sense
 codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-6-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260903034201.112211-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::16) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CO1PR04MB9534:EE_
X-MS-Office365-Filtering-Correlation-Id: 198ab3b0-82da-42b1-2897-08df09b85caf
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|23010399003|366016|19092799006|921020|4143699003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+mHyzXXZnj0xpV87tkjCBBSKaVHjNsZCw9q1DjxKSU0UB4jLlHIiaF4sDgbNqCErBwoTwpdTfVjBsUNyO/zEaBka6REC0bIQwNoriBCUSTVEHMWfdrZij5TD/FxeDBHYsQG415/d0BQGTgNE6YplBU4XDeL0VVQkYd+EwM6npktynktVoe+5aoAa/V7etAmYBG+2cVRoiBa/QMI1i1FSfGsmBFWekp4HlpQ+h/29oIjEIIuPHYMpgsmnATiXFx+We/piy0ucpwB8qBxfO5UEwndOMXfo81a/1t8nuLbK92xA3vkj8S80nGUoFe/2tp13FQHWvTqftvgpFUp2eWo1NBjZW8cDuMjTFjPX88CtUk14UDCOoEJW46se+v6KGuViNlNImPousexAzOb/mQVWxiVc7ySDsTKW0BbVmwWYDFJ7c9+q0gNulxIxH58ikzijb1t6ogAkHNwPPp6DxuGYnhq1A005KppoBs114FU5aF7ZnVWZu3El5ZjPNQMLxkjm8xpMMDnjGv884QCU+fuFdNtP3FP38tFUODLZbX3xJPWGFE6eQdFnJcmy3NLUemR9gyZhGJgeMaNWPl/FmfNzptecssY0UeIxMXIEepFsjXPStAkqCuq+O42c/epywQDsCXxc/HTltY++MuqmGc05ASyoUNmOsViHm6AR822yQA3ebZJDCOeu7qgDx/0FawBzcCZjUaEYiysZaBAyUoEi+g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(23010399003)(366016)(19092799006)(921020)(4143699003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1A2L0lBN1I1TXVzbTZLeU96VW9IQzg5VzN2dHFFY1NFNVR6b3g5UzhPZ0JQ?=
 =?utf-8?B?UTE0WDFQakI4NVBVdSswbkZBNzdQd0RZZTkwdWlocEt0M0hlU08yWkNqQ3dH?=
 =?utf-8?B?bVZuU2lxcXdIYUthN25pRmZITHVrMHJpY2pDRmdyaFZabjJ5R25lTFR2d0JS?=
 =?utf-8?B?U1ZDQUxqOFdIR2owZnJ6UGlra0tHL3RUOEd5Ny95ZldINFo2S05peEpUZWdl?=
 =?utf-8?B?NHh6ZXRWZExqT2t3dk9EczN3Z21oeFp5LzMrOUd0U09wSVJuNm5oeVZrS2gv?=
 =?utf-8?B?aVhTdjlXZ2FuNmltd05DYXk0aC9uSnJtQU1UZ0xMZjE4LzVjK3E3c0NFTVAr?=
 =?utf-8?B?MHNEM2Z3d3pReWxuakVpNzJja2drem1ad0F4TDBpdUQyZ05OajRtRlVERGRS?=
 =?utf-8?B?OTc5ejBaaWp2Sy9RWlBWYkJTQlMvTExwSmx4RUp0eXBLanNMYU1JditmTEdl?=
 =?utf-8?B?aHl2T0FsYWM3M0JYb1lCZlNXMEZYYVUvN0p4NTFPN0xrNjBMem5icERQcnFo?=
 =?utf-8?B?a1FQT0FXNW1zdlNGaklzdWNKRFBpbGRrY054dUVVVnlpNE1wcFVkaGF4Tjk0?=
 =?utf-8?B?ZXdPMm1ZTHZrL0NrZTBRdmtobFkxeGFZYUNacnlvWmNPTWE4cERRT2IvSXpX?=
 =?utf-8?B?bnVLSkw3eTd0RWdLazhYekpwdVUza0hyazcvOHp5WUxnalBxSS9CTzB2cEFa?=
 =?utf-8?B?NWJJZG1SQk9udzdxOEhNRWFXZzlYV25HVGRCU0lNSUtXYTdrWEZFekdaK0Yr?=
 =?utf-8?B?bWVNK1NFK0RBRVdjK1orTldzUDdLZC9MUzRFc2k5dk9GM2hrY1JrT3NmOElO?=
 =?utf-8?B?U291cE01d21CcDFhYmxBa2hwanBUUmZHNXFOOVAwM2ZjTEpqNTU5WUpNTmJz?=
 =?utf-8?B?ZzB4QjlPS1p5UURVWlJ3eFVoc3pqa0p1RWtoeGRRVDdqd0tjbHpueUFqbUpO?=
 =?utf-8?B?MzlUUjRaclNEVDArNEJwYVV2RWdhanN4UWplbThLd20wSDVnTmpsQWgyMUpX?=
 =?utf-8?B?MmZ3cUVadjZTWkI4YkFtbmRLRHR5VEYzR29jRzhqWUhvc1duakFrOHRzQktW?=
 =?utf-8?B?ZFZmcnlZSDdpZFBBVUFvM05ZWklGU29rYmpIZnR4aHNENU5ERFF4SmVjQVRF?=
 =?utf-8?B?WUM5emRqclVkUUNSRmNGcmtCZ0UzMElYN0xWaUo4TVg2NmVEUzM0V0ZDRjhy?=
 =?utf-8?B?LzVjTzd5dThESTZkYnlIaUZJNUM2MnVLZjYxOVpRYXFKS0tqNU1NaXFHQnFh?=
 =?utf-8?B?bUZVMXkyNWppZDZyaDZkSDdqa1dUQnBzQ0h5bWN6VEUzblVES2YvZmhUSDR5?=
 =?utf-8?B?cmJjcGgyU0QxanlUbHlzOUxlcjJ6RDhkNHBMNjRLUDl6WWZ1ckhBUzVNN29r?=
 =?utf-8?B?d2VnK0lWS1ZSalhOQW1jUEh5TXpVRlpLUDEydzlmbXN2Zk9SN1ZLQ3JDd1Ju?=
 =?utf-8?B?T0ZScFdCVGhiZ21BVzdzSFdSUXBubTZyTmh2OVN0ZlR2QUZKNkdiQ1N2Ymhk?=
 =?utf-8?B?a05nVHpranREbVE1SmZkeStTV0tOemt6aFUrQTREd1lRK2hhbTQzWWRZaGZJ?=
 =?utf-8?B?anJ4K3kxd3VZdFJEZXJETHNpMlNxSHQ1QlE0Rk5xREdkYmcyK1d4VFdBZmMx?=
 =?utf-8?B?VUtRZVg5djE2MWQzVnU2bFFQN2xkVmdNUkV4V3VWZFV1RjR2SjlVanFhZEFU?=
 =?utf-8?B?amgzVHpsRjIySWNaS3NLTU1CWTZnY1h3M0FqTVhXcHE2bWtXVFhzWGloZmR3?=
 =?utf-8?B?T1ZoUnQ5MVNJVmQwOHA3c0NxbXRFZnNONksxNjE4SXBHZTllRzhGQnRsOGpP?=
 =?utf-8?B?U29kQlpSemlUVi94NkNiL1gzNGI4NjdzbDdMc0pvRDh0d05BMmxKTTZPOE5l?=
 =?utf-8?B?QUJwbTJydSt3VXNYQi8zKzM5c0tyc01FYkNoZTZEb3h2VDZReHZPc3FHTVlD?=
 =?utf-8?B?L1BqSnlvVUxLdm9ycC94RUVpTTQwOFVkOTRXL3VyN1JBbEVxYXVua0p6bnk3?=
 =?utf-8?B?WWtaWUMrMWlQVUgwbnR2N0ZHZ0hXMDdBVXNZUkU5OGlXRWJDSUl4Tnd3RE1H?=
 =?utf-8?B?SDRlQjU3UUUxTmZWaG5MYnoyS3NVMjNSS0ZFblVKUjhvUThERWVEcWVuN0cw?=
 =?utf-8?B?TGhab1d3QXN2UUJ5WVgvMTlTZXdZVW10Umt6TGJ2VVRzVVNTSGEvL1ZqOFh5?=
 =?utf-8?B?UUNyUHVFZ2dpZGdNUTJLQkxhM3ZRblNnSWZNM3M5WkNEbjNocVR6RzlVRVpS?=
 =?utf-8?B?TzBNYVlvRWJDMTB5YW02eUt3TmFCcW9SOFFFNU53akNEcTRYSUFkOEpXNEMz?=
 =?utf-8?B?QjVoRTBBWjNXazQ2VlRHUjRqM09nb1dGSkZpeW5lMGdFaHZWckkvcnR5NmZn?=
 =?utf-8?Q?ojjY/AO7++pCHaUFIuuVX7t059+LVNn9MtihhCvSNTQMW?=
X-MS-Exchange-AntiSpam-MessageData-1: KsTk4ZX7LSsDWnJY81FrMyisssh9TbVoY6M=
X-Exchange-RoutingPolicyChecked:
	lETcYb44b0hkZbAf3dI7sjIRmudrlFTGqX23xNLK/n4xGp1Ay//lBT/zdHidBtzmdoHJcBnX6Efykwjxo78o8EzYOByg9ah8OF1jc/mgT6tYNMFqtqOyc+58wTOgvx/ZZLnwwNniu9shSeWUcHy0ul4dFfbSDLdENlzzHkFU8rpnwu7DbWEoyBySPMNJMA7WXsuQm4id6dV1/SCyzR4B8+jtfS9pW+Ncr924qT0oD4Wpmihc2X0sSkcQ2svp+wMkecaoQ8EakpPgx/KURGunF75xRijOBaBWkKl+RhKm9Jxgv+BHHTcG2nISSPTQCpZbhEjfucr90PvKqG7oehlqgw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7HpRImvJj3pSa4aZFNzPdjpJT9ZsvOW43Qsq9LDgCBKrDPNgQ4gR1K8MHUxyDs1wH0ZWismMAyMgde3szHG6l4neVHcoo8dKdh8OcbzirxKieSg4OCzS6hFyK1HjrubLhjGJZ2OHA6IsXV5fhaKdoK2FFMZlf2Q0QV9rcUpfxIr6/nizOrcihl9w2wfHAODBXhULw2yG/4y3T8/sTk87mUxKbp6IAMRzN7r2GWLPzqBb5HibDnJfVUJxMQJjl+AzldPPbYmNFQ+4yFoVRRBDdYGE9oORXvlIkTvGzyfajJl2mkMPUff0yyw38RNIOUBzNevfmRNV19QB8DcLfVUySxslRoYvMRur8No1f9y2eGBMATPnv7lIrVtbuX890sqZLGVPsvjPHHFQFRoM1cSb+jmS6ESX9KF2qgLDv1aid7SSL/r1zwt/b7UiTAvChCKeAujkH4KU/Rc0KISQhTmB34K+afaahD67rYqAxP5DadUY4qgY+o5JltXmZjbuflBd9pxfXsavoJQzL2dsSCh63DLQEwzDdwwctcuwTxrKxCeQe1OKOAHTpknVlxyL9+80w+pdmcehNg9DY+I3p7F+Oeye0ObNHS+CflILhfwaLwI64jI0fVLZVJxepQKWWa61
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198ab3b0-82da-42b1-2897-08df09b85caf
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 12:39:14.5605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bp1MJ+VnG70oR2xPc3KUj7IGyP9BshY/Nsj/JYG0nYVt0kuoNNP/fh1Iu+IY+jsgz3cDBg5Cql/vAHxgBy6uhnnbH8HjklWzi/nyTZFeU3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB9534

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

