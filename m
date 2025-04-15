Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AF921B9CF;
	Tue, 15 Apr 2025 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744737311; cv=fail; b=kRSnOz+zN5PftYHgghURBuVE12reU/5AeLg/Bbwe0b8orKMOJVOlznzVp2BXIxuFVbWPvc7DgpX8mFezpXGssbG3gGpa+ElR1VG71uWbBOJPBkoJc1aXSyBz/PRzq9/M7XvmmQlgJCpY0TrY4C5cGArSTWB1xLQjSZjaM+DrINE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744737311; c=relaxed/simple;
	bh=Ft7xvgwv3xdR2za4Jf9zHApu+KElix4zJjoaxD5DCF0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jAjmKPxjW8CyIfgFm05O3VATMy6v6TMibDqy/hJgJrMylqrIYfWJlZJLjaTIajvnMS9YMJO67WJ7uZa4GU8249Dm6vliBmTiTUyWnRBPbzQJ3Vvvn+aWG3asN3L3Z8i2vFPNxAgIijP6+oHIiNLwcN4mNMM0ckkZPPfNjMLV/GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=CMFJIFF9; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="CMFJIFF9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1744737309; x=1776273309;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ft7xvgwv3xdR2za4Jf9zHApu+KElix4zJjoaxD5DCF0=;
  b=CMFJIFF9qQzTgO/yYVYEGcziYP1gwKRfe2tpPElweUmF5eJWYT2yGt9A
   lvNnvXSj1KmXGxpytiXygQczxxpohSIr6YKb1rEmn4kGh7C5BZoag9HAk
   x9zmIaVuaozhsQ/BZdYZZi3ndLaC7eIpyGqXqsDHfEB9U5JJ5E/yT+pAP
   nmVfRat9Zv859Hw93VJJ+WI6Got9C03lwgPAWU8CXlKJGpTNQG9KjN304
   Q4CMxtAqXtkhcuAh3wtQmyrYyweolw00l47rg3C47F7FlLpq2QfB8vOcF
   fFZ8oBRlV2rSRIAeNEE9+SVOw8OIUMCzZD21YKZglmmlmGbLU0uhTgOP6
   A==;
X-CSE-ConnectionGUID: hHsOPRgfRTifW8VRUKo35A==
X-CSE-MsgGUID: PZdVtwj0Q9SCablu+Q3qmA==
X-IronPort-AV: E=Sophos;i="6.15,213,1739808000"; 
   d="scan'208";a="75539855"
Received: from mail-dm6nam10lp2047.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.47])
  by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2025 01:15:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tixYr7M0qFGOVNoN43QFT807jEW9vMep7jCCjU3JBUiuiFOplDR9CKNkpAMZCuljp21Ew6QRTU5CNbtPWsAXchws5FxL29O82xV3ZcCed+uMwWYOpI3G2tc7caDA9KOrkiNZH1fG9XuMvwW2zfBn4kx2+mjQ8OXgG6vJbeQvYfWUAiRO6wRJn2aic3YUVsxSfxbkVz1ZbONKdpJdo5wYwPufpENi1tPhMtX8cZTRkqsU7AfM6PJDaHU0MUPpHjvU4+a08FmbeEvfL65WFsgBEVfac9bGxSSt58SQd65oZOTaB8QCJZNmvh8GRfkWWPgnGQnOCa4cI3q0zMWgcVC/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ft7xvgwv3xdR2za4Jf9zHApu+KElix4zJjoaxD5DCF0=;
 b=kJ5xC7LOcY7FLsFqjGhT0aD+z85x1d1EtROdeJZXCow9KRKY7slcpJu9O1h2tTYrO/yKKGSC+u4EJplBT8TWG5uKG57S+zJVoni+LsLP3wNfnzYkbqvkWactZp5QJDK6ZBfDCYnM4Hxr2WN2HaOHoSY3sMytQ1jhPGBod0C2UKC5o+WhIxQNn/f3WWoNg5OhX86NvFHsz32cXF2EZDt6INry1WT95UWZYFomAOOmTmC7dvE3fsPO/ml+6qljKbQjRNaOPQ1xk1bGJeTewNy0mwZ7Y8mdcgAsOnyxvINCavMl/C/06QdZ5ieVXC1CfTkqfDRXxiLENYYQP1XXT5IW3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by LV3PR16MB6620.namprd16.prod.outlook.com (2603:10b6:408:27c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 15 Apr
 2025 17:15:04 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%4]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 17:15:04 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Topic: [PATCH v2] ufs: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Index: AQHbrTUz4npqBO2Y/U21sQ/M535xCbOjVqkAgAGimmA=
Date: Tue, 15 Apr 2025 17:15:04 +0000
Message-ID:
 <SA2PR16MB42512DE66D9B2A741B81F554F4B22@SA2PR16MB4251.namprd16.prod.outlook.com>
References: <20250414120257.247858-1-arthur.simchaev@sandisk.com>
 <e038e519-c301-4928-a246-ebd25f16bb32@acm.org>
In-Reply-To: <e038e519-c301-4928-a246-ebd25f16bb32@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|LV3PR16MB6620:EE_
x-ms-office365-filtering-correlation-id: bf60b40f-b887-4fb4-4dd1-08dd7c41106f
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WmtoTFFrQnZlQnNUMFR3VkVpY1I1dlFGS1BmMkZnODhqVEthTmsrM1dVR2Jw?=
 =?utf-8?B?NWRmN2NHTzNpNVJPQURBd2NwQzR4SVltWlVGMW5UZTQ0ZTJ4S05rWkFGRVZJ?=
 =?utf-8?B?V3hIdHN0LzR1Yy9iN3hLVkxVRTlxamhiQ3ZEa0Vod2tNd0FzcmJWaHl4VmRh?=
 =?utf-8?B?V004bm5FWkc1bVFLb0Jqd3llV0NDQU5kSXVLc3grSGZVaW1MTUlsbXdOUlJU?=
 =?utf-8?B?c2dEMm1OdEFxS3pEK3RyRmJob0JnVTFQMmdYR0ViVm1QUTFKckxVMFArSW00?=
 =?utf-8?B?WFdzUG9Qc0VCSzRVV1l4VnhhdVNRVVJQN3EzdHFzRmV2V3JVTGZmNE82UitL?=
 =?utf-8?B?WEVud1ZKV2hhVjdwZ1lsWGJFYmFpQlhoMzFSbHl0U0wvNWhtUXZVS3hmREI0?=
 =?utf-8?B?VitZSnljNWMveVk4Z00rMFpFVjRvOTVkajBGQ3l6TzF3OEpsQTB4TXZiY1Vk?=
 =?utf-8?B?QW1VczJNbHRkMmQrQnVIK1NuT1Q4b091QXg5bHBYaXp2cm1SQldvR0RwVUhJ?=
 =?utf-8?B?YVhsa1E3bkYvczRnQnpQQnd2cTk5bVZ3MDB0eFZ4YjdqN1FpNVViQy8yTHU3?=
 =?utf-8?B?Wk04eXRBczI2MG9nQlE3a1cvYU5oajE5V1JBeC93UktFNVllMCs3ZnNkNTRy?=
 =?utf-8?B?WVp5WWF4QXhiaTVtNjliWjREeHl1TGZpcldqdWZFMFZKemdnTDVSUTNVMkRE?=
 =?utf-8?B?RTBYeXp1TFM0MWFMaG14OFVsaGkwck53bkMxYTlnTnAxMEJab3lqMC9ZUmIv?=
 =?utf-8?B?c2NRbWtWY3hxcHdwb3lNbzBHM0NUTnVUMXN4a2J6eFl6WHRZQmZkVy9LOGYv?=
 =?utf-8?B?WitSM0VhSW5GeEZKTU9OVFJheDd3SU1DKzcxdjVXT1c2UlZwRW5kL1ZjeFkz?=
 =?utf-8?B?VU0zaUNVZlllUGh5OWlGR2RZZjhRN1BvMEdYdFViYXE1UkNYR05nWUM0bG1E?=
 =?utf-8?B?OVZmNUp5bU5rbUlva1Noa29Bd2xqRmhkWWlhSHByRFFVOUFCakh5bzBYWjFt?=
 =?utf-8?B?cHpoaG5lQ2F3RE1DWE8wcHRyTDIySHgySTdhQkJFQVR4L1BlMlBQTjZyUkxi?=
 =?utf-8?B?ZXpDNFBpWG5Iek8zVk4rNHNheGViK0VEdWhKSS8wQkU5a2hlRkQ1NklwZXVw?=
 =?utf-8?B?ampmTXZkQjAreWZ2VGlrcnNheU9Ea0hwM3hyUHAyY3A3QXJ6UnYvWHl2akpY?=
 =?utf-8?B?TytaSkJHejNZV3luNXlTZWduSEk4SnFxNGNZVVNPRmxYYlJNeW1pUExqUk91?=
 =?utf-8?B?NTFER29wNGtJZUtUT0gyRS9OUXNZZ0ZxZ1IwZHRIUFNodFBYZHI0ZzNoVENM?=
 =?utf-8?B?TW1VUGE0TkJ0czNyS1pjTmIzOW5GZXUyWFBOVTBOeUUyV0ZtTTB1UzhYTWEy?=
 =?utf-8?B?YWlQQnZsdUtySFhDSG1uVzl5MlU4c1lQNnQraTY0VmJMdEprUzRHeFFXUFNy?=
 =?utf-8?B?ckg2YWJFMDMwclhVWkx4d2RXQlZ6ajJQY1FKWGxPaFlGRG9RQThWVmd4dWEy?=
 =?utf-8?B?bXN1YmFNMEVZUnN1VHErTW5yVW5IblFmcGxxV1NpUzBHb0cxMkVibk9UU3pI?=
 =?utf-8?B?WnlUTVlsY2RIV2lVenBna3p2Z2FIMHBNVlBpS1IwRFBuNFQwcU00RDNaSTVG?=
 =?utf-8?B?MDUzekh2Y2RtU3dCN3Z4S1NPdkplWlF3eXllSGg3VXRRWUI4OVFGWXhnZ2tk?=
 =?utf-8?B?bFZiS1pyTng2aEpNTzhLUVA2cnZ4VThmQmNCaHNsNW5oWEZPV1prME8zOE02?=
 =?utf-8?B?ZXo1ZGYxRWE2MzRjUDI3Z1NOYko5eTh6MEx4cmdlNVdDWmJadVZBUkdzUW5i?=
 =?utf-8?B?Yjd0dHhXN2R1UVNBR0s3dEpZWkJwZmNrVGtkamVQOXBLcTFpUmFFUk1ZS0lS?=
 =?utf-8?B?ZFBSWjhJYThST1Nzd3Jxb08ySWdtcFNwMGpiUGFGUzFudzdBQTZhVVZ5QmpW?=
 =?utf-8?B?NDQ1bXRzNWZLbFZocHVYVi9hcXRMbTFhTXBMSHU1VklMeStQSGE1R1pwYnlY?=
 =?utf-8?B?RnZnYlVocWFBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cDRFejVhbVkxT3VCbUMyODF6aGxlK2FaQUI1cGtxVlNHTVJkSUhpMUUvSnNn?=
 =?utf-8?B?c2tZalNRdkRIaU84eER0ZStBWFBBTDZjdlJiUzJWb29VZUtkWXY5Zi9YQW9l?=
 =?utf-8?B?aCtUTlBBSWJYZ1EwMFBpNjNyZjhjLzg1bkVPN2ZmczBxZ1RTN1VaMkUvK1U3?=
 =?utf-8?B?OEp2Nng0bHlsS2QwOUQyOHBqazZ1U094TnVBVmV5eXUvdnh5T2lrUFdORWlR?=
 =?utf-8?B?ZkZXQjd1TUZ0cng5c3dmUUdKM0lWUW9hR1VCVEZGeDgzU29BajNOZUovc0tO?=
 =?utf-8?B?Qnlwa1Y2MXNkNnVLTWdrNEZ5ODk4WlEweis3QlRzZmFIUW9jK09TTjdDejVG?=
 =?utf-8?B?cjV4NWZaZzdHYUxCRTFyaVBHN1VYWElLRXZOekk2enFUcnY0eEdVN1NHM0N2?=
 =?utf-8?B?WHhaaUUxU0hwVk9GYzFRR3psbEZZbXRmVDhlSGZIazVXbTVJNm0yQ2RheHNV?=
 =?utf-8?B?R216V25TNFVUTzY1OVpETHF5M3JtNmpjcGRtTWdTM2xJN1VZQ0U2bGFvcjRX?=
 =?utf-8?B?WkU4WG8xWEt0cTZKdHNxR1BsNUVqOWw0eS9aNVNPSzMwUUpXMUk2Ny8xeDlY?=
 =?utf-8?B?UWRkVEtWNUtTKzlPUkc0STZqTXlSUkwvOU1mVW5RQWNFazNmU2ZHV2FYUTFB?=
 =?utf-8?B?aXR3aWgxZWZqdFAzSnFnRDJlUk10NEp4RVNkdVJXU095SElsRjFNU3htMHN1?=
 =?utf-8?B?bzd3VUNOSnd6d01xcTEycHhvVHppczFjOFJJaW4yeTUvelQwM3UrU2Rubjhy?=
 =?utf-8?B?VVZPOVFMVS84UWxQMXd1VUU4UEphUitFVHNEcU01MHN0NEtONGVhdDBxajFM?=
 =?utf-8?B?ZUZRenhyUUxha2tsK1V2NDNOVHdCcko4aWx4c2FwSUl1cDhWVEJLTmJhZzRx?=
 =?utf-8?B?eG5hN2VJd0d5Q0xNd1kxYUViOWhUYm1DZVE1SXovYjBHOUdsMnNva3RPRXFa?=
 =?utf-8?B?ZlJHL0I5NjdDZ2RNUWYxUGNSWXRwQ2NZOGRtQVFzUnJYa2hoRksyNjR3b0tn?=
 =?utf-8?B?cTArVEhwQzREUVJtRUp1WDh3empTZTd5WGVHVGthTDlHZ1pOeWc4NDRINGwv?=
 =?utf-8?B?VW1za2U4b3ZKS09iTXo4Y3FuN3BxeGJzSEdMMGFJS1IrV1RZL1p0eWljUExM?=
 =?utf-8?B?ZE5Pc0x3azMzZzNkSUFyTEpZcGoycnV1VVVQMGZLTFJPMVhOU0VVVmtUMHpI?=
 =?utf-8?B?c1RtdnU1TFhmNVdQVjN2OFhKdmI0ajMwTm1jSlJ1aFg4ZUd4ZjlRYUtMR09C?=
 =?utf-8?B?UUdTeDFSRHF1SlhXZy9xak1hMkk2bzFhckZFOUI0OGlJc3FudTAyRUczUytC?=
 =?utf-8?B?Qy9ZUUk0WmZTYVVSM1YxN2VUeEZQRHV0R0NOT2lpdkZFeE9paGRGNXRrTG5x?=
 =?utf-8?B?UlNTTGI3MDByQStscWpMSlpady9yemJlWTBaY1ErajBjUWc0VHQyQWlhdTB0?=
 =?utf-8?B?VEJibDFRUExNazRBRElmYXB6RnlGMWZ3MzBqSnY0TmRza2lIOXd0VmdMWmVS?=
 =?utf-8?B?VUdxMlducEZhcjZkZ1dNczJtYnhwNmdVcXh2NGN4UzYrenczdHM3dlRzM1M1?=
 =?utf-8?B?MlJWbHZZMTZtbDU5aHRleTFTSFZaQ1dzcjRBVURtbzc5WmtHT3hRMUg1Wksr?=
 =?utf-8?B?UzBqeUFQNHJJWkw4MDJaWDVMUXR3ZGVubGFFcUxsOW5RS0ZLVE1YdGh6Nmp0?=
 =?utf-8?B?Y1plOW5TVEQ5Y2VsUnJNMVAvbTcrNk5aQ3hZL29KL0x3RmQ4UWtQNjU4WG5i?=
 =?utf-8?B?V3lwblVpZC9hc0VvQ0FtVHFvTFFvVW5zZUxuSW8rUndhL1g4RllkVStBYmYz?=
 =?utf-8?B?M3BRdGk2WjB4N3FGRDhUejd4cE8zNGFoUEtaaG5UUHJSRTcyUWo4NGdod3NB?=
 =?utf-8?B?S3MvcVZ2ajhjZFE2QVk0REx3cFpQL0pLdERZdVBQYkJ2S1Vhbkh1SWd1QlVG?=
 =?utf-8?B?RUhNbUxhV29PWm1semMyNlE5d2hCTGg5aUowSzdicDNiQW93NERxYVZ2Znhp?=
 =?utf-8?B?WFhUR3RYWjErUmdLdFlVeVhjV0wyaGV3WnVPTTdtcFpSS3BUWldlUHg5N0Jq?=
 =?utf-8?B?bzUyQ3lIMFNiMXNpdktHMVhJMDJQaE0wak4wL2ZTTWhNVnlOcGtVM2hSOWxw?=
 =?utf-8?B?TDRReHBXZmJkSy81a2M0RXlZWm5tQXAzVzlGVHlaZDg2ci8wVzMxU1B2UDBi?=
 =?utf-8?B?bjhzdHJwcDlLa3BXdGp1b3FCa3hzYXFwOGRzVTByZXpPc1E5NHJ6cnMwMyto?=
 =?utf-8?B?cDg3T3pZYkFyMThBMnJRQXlJL0F3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vR52hQRO7jCpziICb7bU9DWc/f4PwSyWlIeKjYFKJqhAerNQLWlgRoV56LzEGQYLbRqcFrffmTkTYwfCKcLf1DahVPnDhPM3fOSIQXNYWzbD4YD7AljTUiyFajTwPlon7nClS3KQA5UxIfXaLOfj8sNo+Oh6eUfelrzKfsdozTLh+UPKGhQ6fm+QNmyXym+A3npGqBE2JkxzxW72rqFwpZ8gM5sWigbGHbC2Inr4TjiA49+fm14JOXYk90I+txda26NecioffZeDF/r0zYuuIIjtSDoLB4T/UQuH99irwZilnoNdkpRRCN0KNb3dI2TzfE6PZPHEN5mAj6PHsrkSJZoifhJ81eaINL7JSAQrq6COvamzMzD50+Qc9Q6SjYVH/BRr7U7qaW4HaIBWOBYqSz86p3axlDsQQedvLd2lvK36UFC0uQApvg14+XIYNePP2lrvcAJxPFpuQJzyn46T3DVYTtPYVAJpJlJ0IgA4vpR0/6QBeamTnarTpX4zgk2/xObDWzhq4JQJt+FwQtVJ2ERBgTNkrQQ92MU5wXXzEc4GoHVofCLRorbee1tTmZ7F/rPx6HE0BFZ3AGJGKJ5VQAPuRNq58UexYrIwYduVfrtTlWAFFeNWRnKQB+ACrZVIXJzMXmGk06alAAnQd4Rrug==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf60b40f-b887-4fb4-4dd1-08dd7c41106f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 17:15:04.6474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2w2BmqVlLlexF8NFfqT7fkPw934C14pqnUdewdowMIpGQC+r57XxBfukbp4f2PruClo8wjQzmj6U+aIRM9i+rsz/m0EyBib5uStY8E+r4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR16MB6620

PiBUaGlzIGlzIHdyb25nLiBUaGUgQlNHIGludGVyZmFjZSBzaG91bGRuJ3QgYWx0ZXIgdGhlIHBv
d2VyIHN0YXRlIHdpdGhvdXQNCj4gaW5mb3JtaW5nIHRoZSBTQ1NJIGNvcmUgYWJvdXQgdGhlc2Ug
cG93ZXIgc3RhdGUgY2hhbmdlcy4gUGxlYXNlIHVzZSBleGlzdGluZw0KPiBzeXNmcyBhdHRyaWJ1
dGVzIHRvIG1vZGlmeSB0aGUgcG93ZXIgc3RhdGUgb3IgYWRkIG5ldyBzeXNmcyBhdHRyaWJ1dGVz
IGlmDQo+IG5lY2Vzc2FyeS4NCj4gDQo+IEJhcnQuDQoNClRoYW5rIHlvdSBCYXJ0LCBJIHdpbGwg
Zml4IGl0DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4g
QXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IFNlbnQ6IE1vbmRheSwgQXByaWwgMTQsIDIw
MjUgNzoxNiBQTQ0KPiBUbzogQXJ0aHVyIFNpbWNoYWV2IDxBcnRodXIuU2ltY2hhZXZAc2FuZGlz
ay5jb20+DQo+IENjOiBBdnJpIEFsdG1hbiA8QXZyaS5BbHRtYW5Ac2FuZGlzay5jb20+OyBBdmkg
U2hjaGlzbG93c2tpDQo+IDxBdmkuU2hjaGlzbG93c2tpQHNhbmRpc2suY29tPjsgYmVhbmh1b0Bt
aWNyb24uY29tOyBsaW51eC0NCj4gc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gdWZzOiBic2c6IEFkZCBo
aWJlcm44IGVudGVyL2V4aXQgdG8NCj4gdWZzaGNkX3NlbmRfYnNnX3VpY19jbWQNCj4gDQo+IE9u
IDQvMTQvMjUgNTowMiBBTSwgQXJ0aHVyIFNpbWNoYWV2IHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2gg
YWRkcyBmdW5jdGlvbmFsaXR5IHRvIGFsbG93IHVzZXItbGV2ZWwgYXBwbGljYXRpb25zIHRvIHNl
bmQNCj4gPiB0aGUgSGliZXJuOCBFbnRlciBjb21tYW5kIHZpYSB0aGUgQlNHIGZyYW1ld29yay4g
V2l0aCB0aGlzIGZlYXR1cmUsDQo+ID4gYXBwbGljYXRpb25zIGNhbiBwZXJmb3JtIEg4IHN0cmVz
cyB0ZXN0cy4gQWxzbyBjYW4gYmUgdXNlZCBhcyBvbmUgb2YNCj4gPiB0aGUgdHJpZ2dlcnMgZm9y
IHRoZSBFeWUgbW9uaXRvciBtZWFzdXJlbWVudCBmZWF0dXJlIGFkZGVkIHRvIHRoZQ0KPiA+IE0t
UEhZIHY1IHNwZWNpZmljYXRpb24uDQo+ID4gRm9yIGNvbXBsZXRpb24sIGFsbG93IHRoZSBzaWJs
aW5nIGZ1bmN0aW9uYWxpdHkgb2YgaGliZXJuOCBleGl0IGFzIHdlbGwuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBBcnRodXIgU2ltY2hhZXYgPGFydGh1ci5zaW1jaGFldkBzYW5kaXNrLmNvbT4N
Cj4gPg0KPiA+IC0tLQ0KPiA+IENoYW5nZWQgc2luY2UgdjE6DQo+ID4gICAtIGVsYWJvcmF0ZSBj
b21taXQgbG9nDQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgMTAg
KysrKysrKysrKw0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QuYw0KPiA+IGluZGV4IGJlNjVmYzRiNWNjZC4uNTM2YjU0Y2NjODYwIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gQEAgLTQzNjMsNiArNDM2MywxNiBAQCBpbnQgdWZzaGNk
X3NlbmRfYnNnX3VpY19jbWQoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgc3RydWN0IHVpY19jb21t
YW5kICp1aWNfY21kKQ0KPiA+ICAgCQlnb3RvIG91dDsNCj4gPiAgIAl9DQo+ID4NCj4gPiArCWlm
ICh1aWNfY21kLT5jb21tYW5kID09IFVJQ19DTURfRE1FX0hJQkVSX0VOVEVSKSB7DQo+ID4gKwkJ
cmV0ID0gdWZzaGNkX3VpY19oaWJlcm44X2VudGVyKGhiYSk7DQo+ID4gKwkJZ290byBvdXQ7DQo+
ID4gKwl9DQo+ID4gKw0KPiA+ICsJaWYgKHVpY19jbWQtPmNvbW1hbmQgPT0gVUlDX0NNRF9ETUVf
SElCRVJfRVhJVCkgew0KPiA+ICsJCXJldCA9IHVmc2hjZF91aWNfaGliZXJuOF9leGl0KGhiYSwg
dWljX2NtZCk7DQo+ID4gKwkJZ290byBvdXQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICAgCW11dGV4
X2xvY2soJmhiYS0+dWljX2NtZF9tdXRleCk7DQo+ID4gICAJdWZzaGNkX2FkZF9kZWxheV9iZWZv
cmVfZG1lX2NtZChoYmEpOw0KPiANCg==
