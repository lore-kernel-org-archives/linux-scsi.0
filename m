Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5722B21A447;
	Mon,  5 Oct 2026 07:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791185868; cv=fail; b=CSXyo6W5vbygGJb/BZCdKoH4DaZff0KIaLa6EJ9iffnB6SqaXenUbDru8w+k2n4+07SLE4HHZt7y7wPld77e3g4Y8QcPqYjPJAKXFxJBtpLLOR1BuvB3ZIRVlo1QYLw2ESmD/iEyFWTLObDPadxtiA9R1fSqT8kMGtAvmMX9DQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791185868; c=relaxed/simple;
	bh=d7NCfN/8joTlFV9dRcmW3ucQPSY5WoPu9bN9DUEijCU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BmIf3sO9oQro8vUEmscmBKl7goXJYGrf7YjzOetAlAy0W1JWuUNybugjIk8OW2ct2EqtIEYPMooupbWmnxPnEwAPxRu+viuSCuuQ0iN321JZSxY2RS4nY5BrZr9ZitLi8CEajoZocOXNA7OGaakE3YLSgUaBybc9dsUlEY7kO+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=thW0h96O; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="thW0h96O"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1791185872; x=1822721872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d7NCfN/8joTlFV9dRcmW3ucQPSY5WoPu9bN9DUEijCU=;
  b=thW0h96ONj7c3u9l9/n3sDhKLJVi8a54cQ5IFTTxOfT+X8sWjISTFQ7x
   BWBbloKgtJs5Jacra3SdSCy9Oymohsij8o4K7cADOnSyyPqeR/sfcL068
   EvW0klwQsuGB7anLscYhGB4YMqA9fbpJPdIbtpbI6B22CUSzAM/5pu+Om
   shBKEjVrJ1XR+NY7v2s+J9KvOD2d/y46m6Dvn2tbKt6ivhsfRAv2yhiqZ
   2QwbjxqGnL9WVOhGS7pie9zL8wGBF6X+GLpRVasqMkFD176kG5W/bvACb
   vWg6ouOo7h95WEO/b41bTQUqexTnIFLcWl6cCPBx89t7fnE0+gU7h12+Y
   g==;
X-CSE-ConnectionGUID: 39RLYtECS6KGE0BgqmY7rQ==
X-CSE-MsgGUID: ZERZpin7QaqhVfWN5s7MhA==
X-IronPort-RemoteIP: 52.101.62.84
X-IronPort-MID: 31574825
X-IronPort-Reputation: None
X-IronPort-Listener: OutgoingMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-centralusazon11021084.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([52.101.62.84])
  by ob1.hc6817-7.iphmx.com with ESMTP; 05 Oct 2026 00:36:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHvimakY+84qhs++j9jxGJJn+6PKEp+W1fKvXmT8su9R3LgYgV1pEQd/9krveu8602r6BwFQ9Rsxvd2Zshurz797D/2PSaBkoKcXf9qKdHoKkIkyd9zxk24Un8yS9L0FMi1a0LIS1OBSjTmnumC0v/0hs32c9wrRz8ZvxhoKCvcXX1hjrllDFMa07Jxbh4QX7MIQ+1CEUHPCHxzFNuY0J+V6geThIE0ZQZstzDTIhCmpsvgU+wKyrlNRvuX1pHznhvc89e+bWScNhNrp8/HFf/nrHwXoU4lOL4iceOK4mhEr9n3LQBSTZ7DFvG4zPPRL4Yj737/4T7wcCmYGffwD1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7NCfN/8joTlFV9dRcmW3ucQPSY5WoPu9bN9DUEijCU=;
 b=iHqI8In+O7WJ2CeAMjM0mANB7jaLpEKboKalL8nK19uzGc3Uvg6HN3fPy1WiTN0FU8aKjA99XDRFCdJZgAGaQag6EEFc+6vHEbWs/Onaf+rp7T6ECVeGJuNSy9Um2o722orik7kL7XvNWIqfGPa/bNBUgBCH3pz4RQpTDMzb4MltZ2y7oCmyJhjM8gN842KQd98wrz0DMcdGsL5KPbyzle1wFQ4/tIMPCrHvWO25Sl87Mt0JEZI8Tb44ZTErpVH81gudgFD9imv+wCCU5/Zm2J6pHBucF+2gM9vvliDRLug2Sad5A7+ClIGCwJsS8gMKxFGGUixAWVe89YOYEL//fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from BL3PR16MB4473.namprd16.prod.outlook.com (2603:10b6:208:344::6)
 by DM8PR16MB4390.namprd16.prod.outlook.com (2603:10b6:8:4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.23; Mon, 5 Oct 2026 07:32:40 +0000
Received: from BL3PR16MB4473.namprd16.prod.outlook.com
 ([fe80::f768:136d:184a:ebb6]) by BL3PR16MB4473.namprd16.prod.outlook.com
 ([fe80::f768:136d:184a:ebb6%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 07:32:40 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@iokpp.de>, Stanley
 Jhu <stanleyjhu@google.com>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E . J . Bottomley"
	<James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
Thread-Topic: [PATCH] MAINTAINERS: Remove Avri Altman as UFS reviewer
Thread-Index:
 AQHdUOP5btbY7IsP8kidmN0lGPhABLbqQwMAgAACzACAAsrBIIAAHuqAgADR64CAAJPREA==
Date: Mon, 5 Oct 2026 07:32:40 +0000
Message-ID:
 <BL3PR16MB4473EA8F18B6CE741C6F1EC5E5962@BL3PR16MB4473.namprd16.prod.outlook.com>
References: <20260930135947.2339918-1-stanleyjhu@google.com>
 <2fbff86c-f276-4e46-b7d3-549461706d37@acm.org>
 <20261002134158.2844652-1-stanleyjhu@google.com>
 <BL3PR16MB4473EF5053283779F18B4161E5972@BL3PR16MB4473.namprd16.prod.outlook.com>
 <481d737323a2925e68f08e1129e1ca904effbea5.camel@iokpp.de>
 <21853b19-d02a-4268-80a7-e457ef813522@acm.org>
In-Reply-To: <21853b19-d02a-4268-80a7-e457ef813522@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL3PR16MB4473:EE_|DM8PR16MB4390:EE_
x-ms-office365-filtering-correlation-id: 20d08446-cf11-4552-5cc7-08df22b2d652
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|55112099003|38070700021;
x-microsoft-antispam-message-info:
 PSV9k94MX7QIkAVmskuhXZcr7Wrx/uUCAlISaf0o4284lkKH9jcuvQr6UDzoGerWWEaML7puujd3P7zZlLT2HxeBJkVyJ8U+D7diCyzjSgG5kXmM5eF0dic63cYWsyX0duh8qTpSSJleBOGbmwGS+SPnIDF+ADDSoPUAyCKI1AfsCfFwpNZZPZFjH4BelNNEKOOMAtAi2yu0FX0xPKWYv7v1hL3F3xOvIOamIy0SW2WRsJPlccGnlpdnSjT+TL/QU++cwij4fj5193MfEWQxCB7GORxDlsyKoPi1RSNovI6vnMHqLc5gOIBrlRZcL3e1YITMAGklfX0jtd3m368WvknLbs8e9uE3cauxVT2LXDF/nv066/NWA3bcAQPPQahPi7950wh0PN2q/0cfpgJ9+QNc5GcA5wLo5DEbAEc7TYpXEFQj1SLvMLs5gkHiRFmtu65O33IhRKCgONRYW14UA/bmE6H10V3VUkN2PaehNqW6TGqgcSwAOznlGuYVH8y+XS2ZqYPh8EkGVUjfl4wcOm906UPcJiXpCpsAERMpe/v82nEvPdhjLR9AJPLWfpS75uhTFdARWApw3G+fnmvRLj7b9veX6oqCHIhvk9SKbMplEcHgbnsOeWB9RjvzSl+kVh/sQcrSzKsZDS4hQ82XgsOVOdwr89blTynuTKQlgPZvaM73rvZm9g9xngSYeOVZYbtIhwXhxxNcB8seiieAJPO2J16p8zDBGGerPzyavr8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR16MB4473.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(55112099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b0w5SVNMbjJvSE81Y2FBZDlGREdIbEpOV2QyeVBJY2VObEtwZUt1TUpHSUxM?=
 =?utf-8?B?K1htQitrU1BjZ1pUMGRINzVzMG9YMkZLanlMLzZpZk5LRktkTTNqNWJVS2ZW?=
 =?utf-8?B?a3VvT0NINms2NFpuNGN6bUZ1cTIrcW9wVnFacmR6M0Nwc1hNeEZYTGUxLzRx?=
 =?utf-8?B?L0cyUkF5NkhaK2MvdjdjTnRJTEplQVhVN1FrVzdzeWFmQWJuSFU2bElOaHZw?=
 =?utf-8?B?YXpmMEdnL24zYUJCNU1OajdYS0VRQ3VhZEFUYVBWb095L3ZrbFhOK1crTEVH?=
 =?utf-8?B?ZHZnenBoZkVudGFPb1N4azROQlNDbE05T0lxYzdXQ2R2b1pQa1FQMHdEeEF0?=
 =?utf-8?B?NVpuY1VIekJEZ2NURU9yK3BDcFVndHgzMDFTV3BQellWSTczU0w5U0tsblZm?=
 =?utf-8?B?REtNNkdFdm05d3lSUXEzWmJHVUhRWUw0R01xOHZHeElKKzNWVXY1cGEzOVZN?=
 =?utf-8?B?Z1pZMW8wY3A2NnMwOVlLUFJPaFVWbklvVnBvaDF1VmtGVEkyTGRoMjJQNWZ5?=
 =?utf-8?B?M2xaU1A3cW5ESXdXemFoK25XQld1aDd1eVV3Q0V6MEpWcXhNZENXMThIc3lp?=
 =?utf-8?B?Ym5kM0hYOWdVVm1TNFkzVG5GNm0zTnZjbXRIb3N4SXdTaTFzTlA4U1Fsc3F3?=
 =?utf-8?B?ZDFiZFBYNE5DeXJ5ODBxbHpCQ0lqSlpOSXM2VzFvK1NiSHlNRWhIcDFVL2c0?=
 =?utf-8?B?Y3phTUEyQVZsUjFwVis2MDJxNEVFYlZrbTNMSFF3bXd6cytZZkRYTE83ZkEv?=
 =?utf-8?B?Um5YaVBVYi8xMjdCVy9lT2lwMU9WV2tEQjhXN1hVekdxK3ZVejJNOEE0Q3BH?=
 =?utf-8?B?MURDbXFqU1o2dis0cDNNWmkzWGNGR05pcHRrZ05HQmt0S2lDNVdYNnQ2aFkw?=
 =?utf-8?B?bHpyWUgrN2lXejQ2bGk4ckRMQXVVMnlnMHFaTnBCNlZxRVRtRks4REw0TjJu?=
 =?utf-8?B?ZGxodHF3dUowT2d6U3JJUExEWXN5TDAwKzAvVTh6MmRWc3UvY0R2OFVweTYr?=
 =?utf-8?B?TG4yb05oWWt0UGc4MHlMYXlWNHBUb3JtUlpPR1ByUU1DUzNWakJXWS9obzdU?=
 =?utf-8?B?WEpxVFdlMWdaRnNabTJNWENMaFJWWEhKb3RYNnJkdmJKSGxNSE9BT0F0cjYr?=
 =?utf-8?B?R1BodnNDMkdzSWdoUk5IVUY2cTVyemNKa0V6b2pHN2dBMFhpa2lzajJlUnJu?=
 =?utf-8?B?S1BacTRkaUYzZlkwME15VnRreFhTRzFvbVB5RDMveGlWMzZ3VjFTSjhyMmN2?=
 =?utf-8?B?b0pZanZKcWtFMUl5T3FuZFVFZHRic1NnYTdIWkNGT3kzcWJ3ZXNFKy92WG4w?=
 =?utf-8?B?eGltT3htNS9GRVRtQ1F3ZXVrb241dCsyc1lIN3V6WXRRZGN0NUJSdHBsRElQ?=
 =?utf-8?B?ckhQeEl1U1M1bWI3MlYwTk92K0p5bVlhSUxuQWlMNWN0WFdydHBGMmp0MldD?=
 =?utf-8?B?R3lnU1Irdkk0bk1Dd25Kc3JFQmhNOCtIM3VsaFg4NFFJVWZISDN5ZzB1YkpI?=
 =?utf-8?B?cXF6QWs4TklHd3ZWQ1A5V3hSNnpjcGlVcmluR2JyQU51Sk4xUnUvSkFTMkQ1?=
 =?utf-8?B?aEYvak5WM2xCejU2a0YxT3RQejF6T2E4R1JwSHNJM1F4dzFGaVhEQWRFZTJ2?=
 =?utf-8?B?Y3RlVW55TDhheHpkVWtJdjFqVHZwVUFiMlRSTVFvc1ZLaW1EallWbjZRaWxE?=
 =?utf-8?B?TkJoME9pTW5IS0wySjc2M3pOVnF5dGEycG1aVWNGbWc1d3BYZHVocFFzUU42?=
 =?utf-8?B?YjNDWGRKbWNhdk56VGZpWWptNDBhbFAzS0ZxWlZ3bEk0ZzBFQ0dXL0lFU2g1?=
 =?utf-8?B?RmMybDVLajlwUERoSWVieVZsWTc1RDNNQWxKTjFLWTAwYnR6S2s2Z3pUN1pI?=
 =?utf-8?B?M25zdDFqeFpKNUJNSzZ0YnI1SjYxaVU4ZEVTb2R6RVZkTC9jM0FsdjdRbnlw?=
 =?utf-8?B?bGdJVnBVZWQ0bEFQMHJ4QW85WnRrTlNIMDZxRXZwMy8veUFvY2lPNjRWcjYw?=
 =?utf-8?B?V2tZS2FQaEpjMHVRN2RBMVJKZG45OGkwMkxnbmlMcHFGVDl1dDNIL2JjS3d4?=
 =?utf-8?B?V2VpRHBCOEZEUlVkOE5TYVRiNFJJZWdsUnlnUERERWw1R3IrbUJRdHBUc2R5?=
 =?utf-8?B?QWExNTNRbUh2b01XaWpraWZrQVRSUkxOeXVFMnpsd1lhMlNhRHBLS09LKzRU?=
 =?utf-8?B?T0FTdy8xMWhGZlJxWitnVC8vWGhKbWc1VGtWZ010a2Z3V3dQaGZ6V0M5c2Vs?=
 =?utf-8?B?UmNZUjdyblV6RVZaemNRWUVpQ3BmTXhoOFprY25jTE9XS2VubGhibmI4NFVz?=
 =?utf-8?B?ZXQ5aXpBMHNBZ0J5OWdNQk1WSmVnRHhzdEpWQmJFQTBhRGNDVXRsQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	avt+H830tBab9pn2Hr1cIfR0XVdUpJkqSgBn9NpeLFrM2nZBLQBNcQQd1HicVA2xybxmI+QEKKgsrPCP2gRrVkT3zJ4Ko3q45JRc77I/ouRAitJb8Et9Alkz6PsWNo2kxwAEbGeEvT7vXhB1OUzW6AlEh53RGTbGl63OixI9TXvsMRVauw07mZyXLdTWA63D2ulUS/fnjYHMeWC8RwUv/pcVWApTV9zGmurEIK30YiqCLeTkZpjVDqtLJZVS3qOwg2rfxdfPDJDoNIY+7oIj4UchSrDY+F9T0pyn71YaWroWyCkgtkc/5NZr/CKpn6OV+dBHJGiQSi+FCkuqUSAZRA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H80xgrkOYo5UOOGMNdSXjIqMeeB3YHf/xt2hpeSKCMIrEYpsMrSHapmT5tToML5Gf+yg6SXPs6Mb2juhWr+uH5NIpHGgGvuS7wOrmeIiXOBAmADgYLCQowON9rq8F97tHm7bJt7EKPoiL34tiUJdSrBOSGR0yeosbJlxphvwpZdX772sG/BmryGmBLKRgx1gOA6JoGK8Yo8m+a5hgvY+986OR8X2+XAisK2NZCAiaKHXVCibOZiPrU6JJf6KVxRE3Mee5WnY51Tqrv/828gKpSNh6PcnPHVg69O2yAVH9mOdn027x3Pf7wJdrAsCe9Ry7+zONpcxD55HKAeWf1jcSOht5S7fP7nmH41IRZL6awrQjworPyNONORmJ+vJxnUZdAicRXJ+k4Md2znHDjAd6lUohBO9K/XqKJSy8GtELaEmZo9s8gkMHs32lM9ml2VYL6/Vb6iaJtULjCsNaqUt0DEHEfYL28Uyt/qvNapfmFY3E0Qt6hkM8W8CdOIbEqkuLY09VgLlkmkpwrncajenx6OPwzr/WxBDENP++LCmL5jm8BckLMbabtK7Pje5suIIzO9/asvbKtDqRxKhaPqU4I/591GZhfaxMY+Yq2wY3HeNnIfB/xxdCHL8d8tk5x1qEsihYYCfqgAH7Gwc6Qmxow==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR16MB4473.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d08446-cf11-4552-5cc7-08df22b2d652
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2026 07:32:40.5131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dg+xf9lbhPuYcR05QffUzBRohmOKYA93O5OfwOpkLfIxX8AScR5EHO+JtgL9UyjSWc7RMFJOvn2CG6SRPzanVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR16MB4390

PiBPbiAxMC80LzI2IDM6MTAgQU0sIEJlYW4gSHVvIHdyb3RlOg0KPiA+IE9uIFN1biwgMjAyNi0x
MC0wNCBhdCAwODoyMSArMDAwMCwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+DQo+ID4+PiBJdCB3
YXMgb2ZmLWxpc3QuIEkgYXNrZWQgQXZyaSBvbiBTZXAgMjkgYWJvdXQgdXBkYXRpbmcgdGhlIGJv
dW5jaW5nDQo+ID4+PiB3ZGMuY29tIGFkZHJlc3MsIGFuZCBoZSBhc2tlZCB0byBiZSByZW1vdmVk
IGFzIGEgcmV2aWV3ZXIgaW5zdGVhZC4NCj4gPj4+DQo+ID4+PiBBdnJpLCBjb3VsZCB5b3UgcmVw
bHkgd2l0aCB5b3VyIEFja2VkLWJ5Pw0KPiA+PiBBY2tlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmku
YWx0bWFuQHNhbmRpc2suY29tPg0KPiA+Pg0KPiA+PiBTdGFubGV5IHRoYW5rcyAtIHNvcnJ5IGZv
ciBteSBsYXRlIHJlc3BvbnNlLg0KPiA+PiBJIGRvIGZlZWwgdGhhdCB0aGUgcmV2aWV3ZXIgcm9s
ZSBpcyBubyBsb25nZXIgbmVlZGVkIGZvciB0aGUgdWZzIGRyaXZlci4NCj4gPg0KPiA+IEEgc2Fk
IGRheSBmb3IgdGhlIFVGUyBkcml2ZXIsIHdl4oCZdmUganVzdCBsb3N0IGEgYnJpbGxpYW50IHJl
dmlld2VyIQ0KPiANCj4gVGhhbmtzIEF2cmkgZm9yIHlvdXIgbnVtZXJvdXMgaGlnaC1xdWFsaXR5
IHJldmlld3Mgb2YgVUZTIGtlcm5lbCBkcml2ZXINCj4gcGF0Y2hlcyENCllvIGd1eXMgLSBJIGFt
IG5vdCBkZWFkLiAgSnVzdCB0aG91Z2h0IHRoYXQgdGhlICJyZXZpZXdlciIgZW50cnkgaXMgbm8g
bG9uZ2VyIG5lZWRlZC4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBCYXJ0Lg0K
