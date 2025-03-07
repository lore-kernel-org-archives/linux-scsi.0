Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C931DE3AB;
	Fri,  7 Mar 2025 09:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741338628; cv=fail; b=bl7hu0cl/FvvxFN8VSyCXjrOlyh4LnWRYbjiodGYx+JPWakXAveMAbCpTFGmKthnEUuOUHNjY1M01UblbcOSaVxTVOx2f+1ZmVxt+SmfVEUB5KzILEmt9jBYoafHZGcOk4PM/W4JtExseeG9FI0buELyi1VGL3GN2MjH4Rdhn9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741338628; c=relaxed/simple;
	bh=Ml7H+IiSqwyiUMX+0SS6q8VRX/OQCFSp9jpuugE46a8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t+FUv7G7orCrtvWDUb1Th99Goj5Yg5u699w3D7pfog6PAX+k9S3HcHuoLpFC16XSPJYSHuxygZELchocSrDs+3g/2PFijccudzay3oah+a3Lgmh6Aooz7UDjWGNJ4IU7pHLLlbSu0BLDRg8UKnRO9QjHr9DG1KuDPmGo8Qb4l48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=DHFnNL1z; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="DHFnNL1z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1741338626; x=1772874626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ml7H+IiSqwyiUMX+0SS6q8VRX/OQCFSp9jpuugE46a8=;
  b=DHFnNL1zTqXs+4Ks4UnJF78w4kx1Z9NGy0gC8ZTs/bwNhcJ1k2FD+8tX
   p1R2lAvxjskKEJRgaHlzofRT2ffaXFYb90Ob1MOYHIG1Z9ofYedidtPfM
   FFzP9JSe0Tp9in2dSou44Bl4ScxH6iejmveOYLs18K9pGQaVwZR+OVANj
   ENUtDCqT4efYNhAEnK65M0hzhunGM6LjvARgiQXQ6ufPrdlkq9s/wC3ro
   neVr1ZeVj7UZjUFz8938966/Mq0G7z2zquI0vc9V6nnudA0HeReIfcMXh
   vqutrsdRAb8wYmqDD/VwDlZpISZ1LY5GDobLUVd2pKn/ow/0wa/k3JN7E
   Q==;
X-CSE-ConnectionGUID: NR1WX1jkQimFZLPuZBdqiA==
X-CSE-MsgGUID: U+RoLWEdQ3iTTPdpOyJF7Q==
X-IronPort-AV: E=Sophos;i="6.14,228,1736784000"; 
   d="scan'208";a="44053428"
Received: from mail-dm6nam10lp2042.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.42])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2025 17:10:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XK7nT/mvt+61537JnIc+etuRbtIzxuxRFmEsker/UhqSENbC3kxMKVUhzAHSruMF6AjK1LM7C4j/rD67O0kQ9b9hUoOlRl/Xl8Dpmpmxuw5ejLKG07awFKBzB13eDIoLzMApBgRjzqGynGTEv+GgMuCAUV/fJUE/8dbCVm9D1qk7E98ddfb01lw/1d4jUuFrZQGMhgw9yhklhsTMBIfxTLumTyXsqRqepXbwKeAIB/IEfuztJcIVoxDUGnmKGvjbNwvsZynRbPT0dUsvevm1mDPsKMOiZvkUPZhMGnQN5NCa4U0QPK8HOFrRdelgJzncHTbRl+0Zv4K4T7lUKVY+lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ml7H+IiSqwyiUMX+0SS6q8VRX/OQCFSp9jpuugE46a8=;
 b=fzT/gdBKchpDuaGA8dRQdrRzVC554EHJLPI0G0JKQ6dOPRVqgiYhHO6foRgpzUqAp8OeqkXH8jGCmKbpUZ52PMhM9h/1ez5jBFI7VTZJyb3vAtqEhTZHDvA/3VL9E0ephj3IGY4pIf9mC/iu5JuLAgJfRqCysOyqLdYnsVjgzLYCYbDV/9ZRRc8fFHIXb1hz/Vk6XTkJL0SAmfjD7dpDZ7C0Yllty8AbKk7UwBgSGfw8Jhj+ey3sPgTN89NG9nTmuTDAcSxwZDc3xM90W4J2HaF621ldHES3SXi6JWk0CMF49Q94HZhV+yDaqcRPjhVctsZFOpFK8jojBX0PbGbv6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by MW5PR16MB4691.namprd16.prod.outlook.com (2603:10b6:303:19f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Fri, 7 Mar
 2025 09:10:15 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%5]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 09:10:15 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Can Guo <quic_cang@quicinc.com>, Bean Huo <huobean@gmail.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"quic_mapa@quicinc.com" <quic_mapa@quicinc.com>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: RE: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Topic: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Index: AQHbjPsw3ucJcBmYkUmzp81f56cI4rNmEpWAgAAEGYCAAVCLoA==
Date: Fri, 7 Mar 2025 09:10:15 +0000
Message-ID:
 <SA2PR16MB4251A7C0633761D1F5DEAF88F4D52@SA2PR16MB4251.namprd16.prod.outlook.com>
References: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
 <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
 <c3f0d284-07d8-42a2-85d0-f4023b9b6bbc@quicinc.com>
In-Reply-To: <c3f0d284-07d8-42a2-85d0-f4023b9b6bbc@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|MW5PR16MB4691:EE_
x-ms-office365-filtering-correlation-id: 633a00f4-599d-4738-f5cc-08dd5d57dfa3
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dW9QclFVVkppVmhOZ3k5VTBScDdJZFhuQkhCb09VdktvOWFNMG9SRHNxZnJP?=
 =?utf-8?B?OXB5NlJmZ2RDZ3RsdmF4TjZJdThvSkpKZlBONTFTMklMVEN6V2NRcER6WjA2?=
 =?utf-8?B?dkswK09WMW9XY2RsMWdGNFA1U2dSZ2l2NHRSa3YrOHRyTUhLMkREeE1GZTdk?=
 =?utf-8?B?c01WOWo2dDErdEJkSktTMklKUk43MzZPbDRrZHpzalkxVzdjWG55REdwUDBt?=
 =?utf-8?B?MWVHNUJ0by9BbzlFa3AyY210U2diQVQyZkdLZEtVQlpTbVVTN3RRMlg2N09M?=
 =?utf-8?B?WTJxTkhxMXVRZUx3c0N4OHVvZnRraFFrdW85OUt4SmduRk1yRDM3VDAyUTc3?=
 =?utf-8?B?NFVvRTcydmtsall4c3MyT2VRK0YybFhGWFEwNDJJTVhGTy9nT1ZaVDlacGNa?=
 =?utf-8?B?YVZDZ0JHN3E2UnpzNHUxVXVZaGRkVlkvcFg3YXBUM2dNMm0vWnhWQjR6VUUz?=
 =?utf-8?B?UW8zdExkdThka2xWL25SOVJDa0R1dXdEdWkxMzdsL3R3d1ZQNTVFWnF2UGY2?=
 =?utf-8?B?dDRiUy84SG1xeDV6Sm5BR3ZINmp6Y2Y5OERsVkova0Zwck9wLzg0Rlp2aTQr?=
 =?utf-8?B?ZXBVNkFVbi9lY2I2K2ZHNWovdnFVbUZVcm5vRGR1emFXUWVWV0UrWXR1TkJ1?=
 =?utf-8?B?UkpUbThHcjJpN0Q2cHJyMjYyKys1RFVOUjRMbTRZbmYzMjVWMzBNdXRkcG5k?=
 =?utf-8?B?dzhuUTVYdERRamJ3NHpNRThnVVFSNUNxUGhLSVg0YlJsdVZIb0kxdUQ2eUxE?=
 =?utf-8?B?djBQRFFyOThod1JsemFxa0o1eEFGeC9iU1U3eER6dzl1UFpVZ3hCNnFTQ1p2?=
 =?utf-8?B?NmNvRFNsM2pWQlBHcVdRN1gxT2E0VXJSUDRvR2J4Z3hJaEZ2cXpLL2lNT1M2?=
 =?utf-8?B?blkwd3J5a2tLSlkvbTFKeE1ubFhBVk9zM3ZhTUFIbG9STHJRK2hFb2c3ZGh4?=
 =?utf-8?B?NWZSaUJrdmZxWStkOEZsT0xoblQvU1Vzd1U2bS8rNG5xcVRBWkJObDJQMFk1?=
 =?utf-8?B?ZitIZnc0ZG5CWWdzSXo1aHJ0dWF6aTZUdkJwOEd0dVJuc0k4UEZSVmNqRTVt?=
 =?utf-8?B?UlMrTDdManNSY2RueThnVnFTTTBnUmJaMGV3dytxZ1ZXTkd3ZFpYY3gxWjls?=
 =?utf-8?B?Rkh1RU02N0hSNDFvMlZieU9ObWh6WW1MSm96Q0QrR2ZxK3BOWVh6QTlxWkhG?=
 =?utf-8?B?VXArOXVUUW8zZlVCaWVUbEpUTndOYVk2aWlibWM1cTV1ZXpsSnhjQkdqWHI0?=
 =?utf-8?B?OUtjRUlGaTlyenJ0VjZoeE10dEF2TU93aWhwdGNGSUdHNzRNSlpER1k3cnRT?=
 =?utf-8?B?N1FFcmVDMlZFTVNmcUxLMGttWXJvYi9WbVIxazlvbVY3b1NoUFlTcnNxSC9R?=
 =?utf-8?B?VGFMZFhQQmFheDNCUWhoYUlnTmwwdW8yTWd6aDJRUXZncnVOOThUT2RxN1NZ?=
 =?utf-8?B?NW0wUTB1dEk5VTI4VDk1NFloeWJQNjkxSXEzTVYrWWowVlhuZW8rWTAweHI5?=
 =?utf-8?B?bHBVU3IrclpwNHhBNHY2UFBmMStVbkt5aGdKV2FBNmg3WEZiMS9pMzRrM1Rv?=
 =?utf-8?B?ejhGWkNTTUh5dTJ3OHRLYkx2VEI5ZEFWazg4QnpCa2tzYS92bkdWbzhiL1I5?=
 =?utf-8?B?bG1zazBSZUpDbU1PU0FVZ0xRMVNzN0FIZGsyMUIzclpDQkZrcmR4di9KRXRo?=
 =?utf-8?B?Y1k5ejVkb3BVbGZ0RVJXamFBYm9DU0RVdG5zMityZnBnTmVuUmkzd2FOTlZo?=
 =?utf-8?B?TzNGRzc2QlYxRytMRkVPY3paM1NyMms4SExFUXBUTkVTNldITm44c3Y2eVZp?=
 =?utf-8?B?elNKZEJjaHpZaVhrNHZidkVNTjc3YjBLQWRVd21EcVF5T2RLRHJKS2prZDFq?=
 =?utf-8?B?QzlBZ2U2YzBPOEs4cDYvb0hBWXZyZkFJZWpRc3JMcE00Rk1TWGt6d1lDckh2?=
 =?utf-8?Q?bycP4lzsfIzCNH/Igc+0N8Ics7IZi8FF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S0UzY1JraGpyVndNSTVjb2lvWGVWNEtiNGhFVWRsOTNyVmlpYnk3TXFabU5D?=
 =?utf-8?B?bm9PSVp2Rmx0d1AvNXFxaXlUcWZhZzV6VVhjVjlXRXJKbTUvZkt0VmtrWnAr?=
 =?utf-8?B?SXc1UnNQbWRxamxXOXk0ZEVlZlBoVDMrMG1BVEErS2lNdEgwYlZ3MEY3Qjdy?=
 =?utf-8?B?OVphM3FlQ2hJRnVRRHNBM25LczFQUlg5M1doNDM0S0FRLzZGMEdOTmx6SG9S?=
 =?utf-8?B?Ky9MbnhyV1c1akMrU3UvcEFvUEhGbEZwQWI0MjBRMGE3bkxPMmZPZitFYWsy?=
 =?utf-8?B?K2dZNDd5VzNZMUt6ZGVVTk9sbE9YdUVSQ0xmSE9ldFhucEIxYWFrZlM0RlVL?=
 =?utf-8?B?TXpGdTJxMTBuMmxJdml2QzBid21KRXRHZ2JFTEE5eTQ2bjhqbVY3L2plVllh?=
 =?utf-8?B?TGRTL1pGbnV2cVdpS21RY3FYNzFNL0wvenU2T2Vzdm5MZVc4eWlMMUJZNHFW?=
 =?utf-8?B?QzRFa3pseUxlK0s3QnlRTHdWZGhPUXhWemdwbmI2RjQxVEFGQ3VtWGQvTmpW?=
 =?utf-8?B?ZGVMT2h3ZEpHQ1k4WmUvYVFnenY3R2cvVE8zcjdiTmhGYzNPZjlRQVhFdzFJ?=
 =?utf-8?B?eU9UMUU5MWZ2aVBINzdaV3dQMlFLaEY1Wm1oT3dxTWN2NWJyU3VoWjNwSmpP?=
 =?utf-8?B?MjlTSjRmaEE2WHZHa2lNcWNqeXJRSkovSlJMVkhFb3BvTGRKVzdUVWxKeU9k?=
 =?utf-8?B?NVNnbGVkWjJzQVloYVQ5bXpydkVjNWJqSDlPb0EyNm5jekZ6WkVQdkhKR0Ry?=
 =?utf-8?B?czBzSXJ6TGFaODZxRWlsYjB2d1dvOG9KSVo5ajlreWZuVEw1TVZDRVdWdTNR?=
 =?utf-8?B?dGJjbHRFbjdRWkxhUEd3aTdFMFU2Z01rY21XT0V2eUNlWGpOSFFZM0trYmww?=
 =?utf-8?B?NUV5VUgvdlVQNHA3Vk5jZEdHVElPSVplTFdRZ09UWmtjZVhURDRpcDJ2Unl5?=
 =?utf-8?B?RmdwcCs4SXBPdDlmYXV5cytuaGlVWVpYMnR5dkVYZktZR3JRTkVLRFk5cGw2?=
 =?utf-8?B?aHhOSTVpcEUyc3IyYTlUOWtvRWhGT3FRT3U0Tkh0VUJNVTZRZzRDZVFVQVVk?=
 =?utf-8?B?ZE5UczN1Slova1lIVkNSR0xLMXNoQ3c5N1lqNjJReU1mb2xFaFUvZjBOY2pB?=
 =?utf-8?B?b1N0anpDSitVZ3poTDloTlZaOWVpeS9QNENlVit1Z0pyVWt6TklKRU9nYzND?=
 =?utf-8?B?NmVmdGxCemFzNmtVa1pmTUx2SUdlTk1vRWQrOXhKeWg0aHpKdUZiM2Q3eU9R?=
 =?utf-8?B?WG5CeVV4VU11cVZJcTBYWXRmMHcxNTVGVWJoVFNuM2lYS1haU2dINGF1bkk4?=
 =?utf-8?B?aEpia1c2ZkJyeC9GbFFOTVhDUEtmYm1xNmx5QUFyQS9XVVpGZ0MrR2ljLzd5?=
 =?utf-8?B?TDJzc0hhNFJxc3N5UDhTUmE1dG1jejJEQWVPMWloOGdiU1pQOE54RE1YcFJG?=
 =?utf-8?B?dUNXVUIyMlltS2hseFdaZWs2V0gySUkwUzhQZy9Wa3EycVQrb1FqNlU3bzVr?=
 =?utf-8?B?Y2xrTTVwZnExTlVjWlpDQldHWEhjWDViVEdIaDZtZmRQSU5jSFZESno3MElr?=
 =?utf-8?B?YWdtTGlwMnVGUDM4V2xiMnAyRkt0bGd5Vnk4Snp3TlZXMExHNXE4M1h4K2d6?=
 =?utf-8?B?dFNsb21UL0Y4NE9VZnZQcWVndEV0emlkQ1l2U0pGZzNhZlFmWTNIclB2NGRR?=
 =?utf-8?B?VUZhUFdMQ0xEVzZpNTUwUm11MXlLVW9URTZBZVdsNFZpY1RoVW82bjAybXZV?=
 =?utf-8?B?TWJLVS8vT05YeDB1YXRhcE4wUzZVZmdqODU0TjBvREV2bXF4SHBpK1JvdlMx?=
 =?utf-8?B?b1hDbmQ3Z0xhbi9POUIzU3pMMUFHbml6ejVSS0VsbGhPMTV4WFNxbFk1Y1A2?=
 =?utf-8?B?SzZtUTd0SWhZbVhPcXdESnVGL3BYZkxEeUJtUTE0R0dlYlRBWTVKS2tCTXI0?=
 =?utf-8?B?aXBWY1BlMUVRZjFJSUpZTWhKdG1QcDVWTWVxNW9sT2xHYVgwM05HVGMwOTZ4?=
 =?utf-8?B?YllDVWRWb1FCWCtobzliQVd5RE1oL3RWQStoSmUwZURZU2JjZkZnNGZTRWRQ?=
 =?utf-8?B?YWxuZWtFMlNNZ1lFZ3paU0oxb2J4SHlSN01jWkNIU0gwU29ldkJlbU5sbHBF?=
 =?utf-8?B?bXNWSlZSYWZ5ZnFwc3F2Qm4rKzJ1bjFSemx4SStwckdPdWNnblJvUjJnbkli?=
 =?utf-8?B?RUE9PQ==?=
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
	+NGG9lWQ38CeXao+9UsP/WxZht3HMILjlmFNzUFevh9G/VChxrB5ceNN8Y1LGjLKWztXtapbm9YqTvwAdKym2tyMDiZ4WjoWH7+S6caXyIF51llHpMvuruklAU0ua/6XKkYJTUmGlhiPMHgSoFYSjpuX1eRSNT6r1NHHnPaDVJCoOtlivyElIJ5F2ZAcLL3hsjO7dWwD6Q69WfAjROfFIleZ1eQhEL1E9X3eEN2B1tNcgV5gUMAPnAE56XSYhiYGsdXRm6DXQ+hpb5CBBPBWeAt9jGre8o4mG4AxLkh8ztEaR1PVCt7WTdFJiixBfJpN5Q+CQ3ALLxM0mqsNkpawUhDO6LNm7Vcj3MFNoAsFO+SdKMQ9tSLPOHiizcbV2G3XlzIPrVoJPYfg9CeV/nVVMHF6YtORi1zoQDvC2YmMHefRpFoE9V4pAeXuw3S+PpiSwvwcHMDkuMn7MWHMQoRQcHSOJqpiBmBjdB0NcpwUtcBEPpWUbO9fgJUeK0eekEi1b+KGHUSOjjhiVnlioGAd6WbOUbVmZ4KVjgnAc2hIVD2IKDh69g9Y/jmtfSMY320M+3d1UIxCzma5LtVaW7THDES/ArKCujzRkaZtiFnXhbHvSi1IZj579wSrdIO24boc
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633a00f4-599d-4738-f5cc-08dd5d57dfa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2025 09:10:15.1913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +prOWWvKhCgKp8uK3eahR+GnDo8h1P1cIAaf1vFqHcUOQoeK0kYR1Dc+0U2l+ILX0o3szwGZcsnAUAYfcMdLkOYJ9yUYorUOT1HzbS6VBLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR16MB4691

PiBJIGNhbiB1bmRlcnN0YW5kIHRoYXQgeW91IHdhbnQgdG8gdXNlIGhpYmVybjggZW50ZXImZXhp
dCB0byB0cmlnZ2VyIGEgUkNUIHRvDQo+IGtpY2sgc3RhcnQgdGhlIEVPTSwgaG93ZXZlciB0aGVy
ZSBpcyBhIGJldHRlci9zaW1wbGVyIHdheSB0byBkbyBzbzogeW91IGNhbg0KPiB0cmlnZ2VyIGEg
cG93ZXIgbW9kZSBjaGFuZ2UgdG8gdGhlIHNhbWUgcG93ZXIgbW9kZSAoZS5nLiwgZnJvbSBIUy1H
NSB0bw0KPiBIUy1HNSkgdG8gdHJpZ2dlciBhIFJDVCAod2l0aG91dCBpbnZva2luZyBoaWJlcm44
IGVudGVyJmV4aXQpIGZyb20gdXNlciBsYXllcg0KPiBieSBkbWVfc2V0KFBBX1BXUk1PREUpLg0K
PiANCj4gRllJLCB3ZSBoYXZlIG9wZW4tc291cmNlZCBRY29tJ3MgRU9NIHRvb2wgaW4gR2l0SHVi
IGFuZCB2YWxpZGF0ZWQgdGhlIEVPTQ0KPiBmdW5jdGlvbiBvbiBtb3N0IFVGUzQueCBkZXZpY2Vz
IGZyb20gVUZTIHZlbmRvcnMsIHlvdSBjYW4gZmluZCB0aGUgY29kZSBmb3INCj4geW91ciByZWZl
cmVuY2U6DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9xdWljL3Vmcy10b29scy9ibG9iL21haW4vdWZz
LWNsaS91ZnNfZW9tLmMjTDI2Ng0KPiANCj4gVGhlIHJlY2VudCBjaGFuZ2UgZnJvbSBaaXFpIENo
ZW4gaXMgdG8gc2VydmUgdGhlIHBvd2VyIG1vZGUgY2hhbmdlIHB1cnBvc2UNCj4gSSBtZW50aW9u
ZWQgYWJvdmU6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI0MTIxMjE0NDI0OC45
OTAxMDMxMDdAbGludXhmb3VkYXRpb24ub3INCj4gZy8NCj4gDQo+IEhvcGUgYWJvdmUgaW5mbyBj
YW4gaGVscCB5b3UuDQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQoNClRoYW5rIHlvdSwgQ2Fu
LiANCg0KSSBhbSBmYW1pbGlhciB3aXRoIHRoaXMgdmVyeSB1c2VmdWwgdG9vbC4gSW4gZmFjdCwg
SSBwdWJsaXNoZWQgdGhlIHBhdGNoIGR1ZSB0byB0aGUgdG9vbCANCkluIG9yZGVyIHRvIGV4dGVu
ZCB0aGUgZGVidWcgZnVuY3Rpb25hbGl0eSBmcm9tIHRoZSB1c2VyIHNwYWNlLg0KSW4gbXkgb3Bp
bmlvbiwgdGhlIGhpYmVybjggZW50ZXIgZnVuY3Rpb24gY2FuIGJlIHVzZWQgaW4gYSBzaW1pbGFy
IG1hbm5lciBhcyB0aGUgUE1DLg0KRm9yIGluc3RhbmNlLCBpZiB0aGUgaG9zdCBmYWlscyB0byBj
aGFuZ2UgdGhlIHBvd2VyIG1vZGUgdG8gRkFTVCBNT0RFIHdpdGggTk8gQURBUFQuIA0KDQpSZWdh
cmRzDQpBcnRodXINCg==
