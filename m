Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B35713D26B;
	Fri, 20 Sep 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726858849; cv=fail; b=AlbAvCU0NrJMtobw5jj8eqdG0XDkfN967waeV+vbRRiS14hxyRSCBCXb6ETBF70YoiL1MjowwmiTpny0kh4ZHnGM9fYrlT75SOOMrUVeJgm12cwWth+pKPWgAqMlqBYHyPoMcDAp7hK35PKT+dkmwoWpFl93TWqnFfW7cS3Frr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726858849; c=relaxed/simple;
	bh=5fEsD1wkCvpfAAgbAhwMKqrNUHMQnM+ceA8MYCfE/VQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=spz2S219Vc0BztoecGHcujxnuv/8ski9F3u/wZuDFtSwjD23i17nwIK817J7hjjXxOCNv7xTRl986p6iCZd+wCmmW/eK0ZvhJE8hkhCiRYVlyKzKY4EGPw/YlSQyFCCGBBOzQWohKwyh/vWk+1QeM/e2gLZBAav1GhctJNtrZuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cbU43czR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=dsSQemM/; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cbU43czR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dsSQemM/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726858847; x=1758394847;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5fEsD1wkCvpfAAgbAhwMKqrNUHMQnM+ceA8MYCfE/VQ=;
  b=cbU43czRKT9tK1qOtYEOjVQur+tMl/fOdYWOa+6eqb0gfhelelPE/M6Q
   KjjHeoIoAC9ViUfAty1wCfOCAKOcKip9gCgAFE/mhfoFpcyBtZflWvhbi
   IoTpALSwcFEqal6szm84RPk6V5JWBL+P3SB0/gV6q9Gh3D0p0xO6le/yb
   /qaQY0gagVarU9n8cYhlGTw6Fgn+8wESK9wnv38ej5omeBKUQDljE7ZYW
   678iYIOxkoEBi4yMwcN/Td830CItsP8OF50zYzhGa4C3X8WcU50kkvrwB
   M0EEcogkLKpLDfy7Y4ZIEpZwc5Cb+riJ1rF/NHOCrrGXW+09Ch6MzvCst
   Q==;
X-CSE-ConnectionGUID: qTanYdN6ThC5GA+MDGcvjQ==
X-CSE-MsgGUID: /E8d45/2R6uJKwtOCYEVJA==
X-IronPort-AV: E=Sophos;i="6.10,245,1719849600"; 
   d="scan'208";a="26549902"
Received: from mail-southcentralusazlp17012053.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.53])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2024 03:00:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H2WtifcvO+KlfLPUTH6MVSL5Usrttp7xuO1L9drV/1x0SEY9bxXM971MTkkhRVewZf/1FB86yNpeOxs/YjzbfSU3uC1TmrWFhfmPRIAlKhFQD74eW6BrFLO79oy+od8CY73l0bNEMyRk9pkauVMIU1QXxT1N1ge+r+/yf9iA6IRHI6GKMHmu3sas+CQ9K28+5zkXJwuh1KdiGEDXNrDz0QiY1b9vW7aEbYPQDfOQocUq+bd6Skc3y9/BjlxHMhl5hNSZvTV5n259MC/ToGL+f95WYv3myvQ8MfT05yk+5EkSc87CocuGIBsk3zQIdszHsW3k0X+0WwQpaUkSM76WCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5fEsD1wkCvpfAAgbAhwMKqrNUHMQnM+ceA8MYCfE/VQ=;
 b=xXX6KGyzdY2rh3om8XDq0lppVG/e7fFYqPT8gBUUEgcDze4ZwglWV7fRGAlYp0df7E+lLOT8uplRyqg70deG46f5dCNlTtWDIP9RnErev+fkE5fgj8IC+JJdhIEtOiZJaQcupQvdF4ok7asCIH4EC15r9wMluv/kqh9IPB+04+x5vttR1N0hBYJnCas6A+MKRQIgvm/FffbY+P0Pv+Mh5W+LVzpE+KQVkspKlqyvvy2aCrGb/T2MXGSQnI3/5VrPycxisW0jTqpjpB8PjII/POMuZVguYZgxmF2tWrdH5YlE7crAFxR9z3EL1inftZKNMKQW9XnaT+cEnQe8kJdqPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5fEsD1wkCvpfAAgbAhwMKqrNUHMQnM+ceA8MYCfE/VQ=;
 b=dsSQemM/9TJKgOt1b/h6OwlJ4n0P0mcjeqUJP4x4aEDImLbvUgyUH8WHHp7a3ETkV4G5jzstG0fI3p65I2tAioemwjwwqFT0Fxk/jcrjEA68e30Gm368enXIFuhRi/aBGHhSYh4x4cBuJKvVgOkT4sX4H22F53S9FDaEjxYjX10=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL3PR04MB8121.namprd04.prod.outlook.com (2603:10b6:208:348::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Fri, 20 Sep
 2024 19:00:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7982.022; Fri, 20 Sep 2024
 19:00:37 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Do not open code read_poll_timeout
Thread-Topic: [PATCH] scsi: ufs: Do not open code read_poll_timeout
Thread-Index: AQHbCobRdkB4+QqnHUKRt4+7TQpHarJg/12AgAAJKhA=
Date: Fri, 20 Sep 2024 19:00:37 +0000
Message-ID:
 <DM6PR04MB657543C148391E6F60921083FC6C2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240919112442.48491-1-avri.altman@wdc.com>
 <ff33de4f-d111-4499-afff-231baaccf61c@acm.org>
In-Reply-To: <ff33de4f-d111-4499-afff-231baaccf61c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL3PR04MB8121:EE_
x-ms-office365-filtering-correlation-id: 1b577d1e-fd3f-4a77-91b1-08dcd9a683b9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bUdZbXZWOEJVOU53Zk1wQy9YQXVyc3pzYmtwclh2T2tlVmw1OEdPcDFuR2l2?=
 =?utf-8?B?ajlOdGEyT1dxaEk3cGxoY0RrNHg1cE9TNDc5QjQ5UGR5b3pMV3pQTk1yQW1m?=
 =?utf-8?B?ZE9BbHJpWHBNWlMzSkNaaFJPeitQVUVFZ1FjTnFFcmdSMUJtREJJWGRsRjRt?=
 =?utf-8?B?TXRzWEhvME56Y0dvM0VQWVFSaFl6ejdLZU1mR0dDTHU1ZDZpTjBCQ1JWbmpV?=
 =?utf-8?B?SnFhTlV2TU54WGF2L0hiVnFMOENpbmZDNXI1TjBKQjFzQ01JUW9SWVRvYjIw?=
 =?utf-8?B?bFBScDJISC9yUjhENUdkZCtRU3pQN0F0WTJGNG9oYXJOMEJHMEFtaTRGVGZm?=
 =?utf-8?B?R3FIQkZwQi9ZSzNxZVo2dk5hanZXbnAraGRTdUwzMWpmKzRUOWZ0bXo3RUQ4?=
 =?utf-8?B?bE1pbUw1eko1Y3M0NjhtNkxuRU56ekVKS1AzaVV3RDNTYW9abm1QUVdNNWNz?=
 =?utf-8?B?dGlVNDhPL3ROL1FTK050UTgrbDQ2SC84ZEZ6T0tMRDJRemNoZU43dytqcHNo?=
 =?utf-8?B?RGhmREcwK1RsRHByVnAraHA0UmdmVmtnamEvUUdnS2k3bzVRaSt4eHNtQjRY?=
 =?utf-8?B?YkRORzdsUzdnTEc0SHVVUG05T2Y0K0Z2SEkrZVdRS2c2N01EUmkyejd1SjU2?=
 =?utf-8?B?LzVYdWczRjhpVEVlT05NUy9hZXMzN080QnB4OTNoNnZ3U0RNTjRHa0pRaVdX?=
 =?utf-8?B?NWtMN1R4TDN1eVBXYzBhaXdzUkRTTzBDNHhkMGswYUdyTFk1MUhIV3NwRUFU?=
 =?utf-8?B?K2t1NW5DV2JGbmNPVDl3VXIxOXZvZXFRU0lsVkgrUE51UE5FblFSTGlXdGVN?=
 =?utf-8?B?TU5NN2p2RS9MTFplNEZDeUFPVjl5N0VpdmZVR2hsc2xEM2Z1ZjI4SDY0RGlV?=
 =?utf-8?B?eS9maU5teThMS2FkU1N0T0JjbjF0NGhBVWdIOVpZUXNseGFmM1lZaWhsWnJw?=
 =?utf-8?B?dlFmRkF2anpvRWFvblJ0SzViV3NFSlFQQnFMek5NQUszNGlhZUwxcXJLMmtv?=
 =?utf-8?B?Y1d2Sm0xaERveGxNa2NmVkloQnR2QklhWVhyZCs1VVhtTUFYL0FyQ3dOdHF5?=
 =?utf-8?B?K0V6REQ1WFVQS2hSci9uejBnbjE4NVMvS2d5MmVjS0M3cEhaVzl0aTlCdE9o?=
 =?utf-8?B?a2hzVk9IbzkxMXpIVCs2WU93SmlvS3BsMmNrUkdweGFSQUxqdGFIaE9jcUZQ?=
 =?utf-8?B?MUxEcW9QVEF1R2lkS0FZUWUyKzA2SW00QkFWUWthQlBOVGgzUUkzc2l5SlpR?=
 =?utf-8?B?SU9XK3laajlQcm9VMEhkNnAyOWtvNlh0NEUrMFl2dW5KWDlLV3JBaFl6aU96?=
 =?utf-8?B?bmoybWVwYlVvS055clFwcE1PcklvNGFDMFh0UE9vRFA1em96eit0Um5GaXhx?=
 =?utf-8?B?NXc1bkVaOTNGU0xlamZ2d29tcDRvUGFnQ2dKdHhYUlZBR0hrSTRHS0Jta0Nn?=
 =?utf-8?B?YnVDK21KUk1WbUtCT2JocDlCcXlhY2JSUjlPTm01TUpPS1lBUHVhS3g4ZlVy?=
 =?utf-8?B?MFVpUWR5dGhwN2d5ZHZ5MDRnOTdNVHB1SFVzKzBpUncxRFIzNDJnVW85ZnRE?=
 =?utf-8?B?SG9HcDFFQ1BnT25ZdzYxSEs2TEEyVDFxcWljTlNGUGZhRG55a3QzVXJjWFZa?=
 =?utf-8?B?dGF0K21FQkIzdDBBVmVPOXVaMEI1bDhWMW5lcU1GNGZzTVUrY1JWcDRIdmFk?=
 =?utf-8?B?cDVub09VT1lHbzZ5d3lkeXVJcFVSWHpKRGdIckhKYjJwemtLUnNpek1DQWlm?=
 =?utf-8?B?b09EUGpicDRPS0QvalpkTXROcXpRamZ4eWhJLzB5L3R4aFlwWVhJMHJGTHRv?=
 =?utf-8?B?cVdERERkckdva2VCbTBLUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q2lDRC9rVFFMODJPb1pJbHkvNVc1OWF3cGVPamlBbE1Ia0JXNFErdnoyanRJ?=
 =?utf-8?B?RzlMR1hteXJzRk1nUWlZRXpCd2Q2bCtBMDRseFRDZ0R3blJtbnpoQXpnSFNH?=
 =?utf-8?B?Ynp3MXRyUkJCNDcrTjU1d0ZkWWtIajI2VzJYVnBNL2xsM1ZxUitlNUZQTUR3?=
 =?utf-8?B?UzlhOGEwTlNUNTZENlNBS3k0b3BOUk5KYmh4Q0kybkF5WlU4b2tRYmxiUnFL?=
 =?utf-8?B?clpSTGVOTnRib29COTluV1AyV1EzRHVXVWR2cTZWc1RxUFhEYklkOC9rUnZC?=
 =?utf-8?B?Znc2VG5vZFFVT2pvNG15Z2F1emoveEdXUi9JTnhhaG1uWTdUV2Q1b2ZVTmZT?=
 =?utf-8?B?Sk9IQmhPTWFZbUloWlJYejY2SWQzMGZFSHhsMVpyZ09mMDR0d0djVWR1cmR6?=
 =?utf-8?B?SnNqVjlKbW5hU2JSSUp0bVpRTnpYTzFVQ1gvSFJKb2xOSkN4d0J3bnZVUGM5?=
 =?utf-8?B?enlvUnFBaUpjcHBrUWVTaCtaYVFBTmJGbWpUTFNvK3pPWEdtSGZHKzV0bTNZ?=
 =?utf-8?B?NHRPc1ZKNjh3eHNXMWZxR1NrNWFOUmZkMlFWNEp3N1ovTnZlWnJrdnpJU0JO?=
 =?utf-8?B?a3hyenN3ak9jY0xYbi91T3VHc0o4KzBiY2xzSVpMTVFNbU03Q2IraEpSclRI?=
 =?utf-8?B?aWN4MWhPYjRxNkhLNm4ydjdNQVl2N2k4aFc4Ny9mcWpsQ0FtbnNXUEtGR1lD?=
 =?utf-8?B?ZXBQaHJ4YXBoNzVXSkRmUGFUWlExd0FxYnBWV1dRcDYrTU1WUDBJOWNFbldI?=
 =?utf-8?B?QlRRTVh5SXNNRjhhUFgrSUJvSU1ONE1WWVIrTnlHSno1Rnhoalhxd1RnS3dk?=
 =?utf-8?B?VVJtSjF0WXR5M1BXQkIvUW1SdWpVVUVwdXYzdS9lLy9nMDhmcVRGVGlNR3lv?=
 =?utf-8?B?dXRBaWs3YWVHdjcvU0l6TEg3Lzgxa2xkNDJXcW8wZG5LTlpiOG1uVGV4V3Bs?=
 =?utf-8?B?cjRKTXVYSW5IMmdGZnpKNFNaWUdtMTVVQk5HK2JrM2hiNjhxeVA4bkV3dUVJ?=
 =?utf-8?B?WDBSd3JtMlFkRXFLVldSVzh6TGxOR1Y4bGVFUVgrUXhhTE9ndk9obmpHOGdO?=
 =?utf-8?B?NWtHQnlTanVXNUg0UzAyOEJCWi92L2I4eUQxTlR2dW9XWVMvRjI4WENWZDRq?=
 =?utf-8?B?TjRGZXdKNDN6K0lYNm9uc2plbGZuZ0R4K1pJdllQWVhNQTVaZ3E2U1VvcG03?=
 =?utf-8?B?Zmswc3AyWEpFemZCY29rTTgrTTFsWjFxRWNma2ZYZTFNMFZBaFNoVElGZFJZ?=
 =?utf-8?B?WWdWN3R5MmFzOHNhWml6Mlg4NXprbW9xcmIycHAwaEtibDBZTHg2ZmYxb0NT?=
 =?utf-8?B?YmNxYnhZdDBoM2Z5dlhxbFpWajRsWGE2clhoV01FSGprQ0xVSVRDL2wvOXVP?=
 =?utf-8?B?RkIxNk56Sm5KSG9DUE9NTkgyT2tSUWw1Y1MwMTczTlQ0YThhRG0rUXpZZktQ?=
 =?utf-8?B?bHRDNFl5aG9XQi9EYlEvUE9FT2lJekl0c2VJazI0UGdmd3I3WXplT2lmejQ4?=
 =?utf-8?B?Q2p6Zm1YYy9ZdTNKQmlEWTBhMHJ5NVdDanRuRmsrS0sreG1ETXpUczlGdlpy?=
 =?utf-8?B?bUFpN3BjK3ZhRGJPMGd6cGlKYmtqTnRZOEkxZThFek1CN3FtbTVXT3NWQmZH?=
 =?utf-8?B?c2pDd29CMndoS1ZNTDR6UEswZEFGU1ZJbThDRU9ITGpPV3A1clF0VEV5anFO?=
 =?utf-8?B?YjVyLzBtMEgrdHV0UWpBU3hjbTc2b2p3UHZ0cHJBVkF6dlpXZWNUZG5UeGVB?=
 =?utf-8?B?cG1ZMC9KUnNXY0Z1S21SQkFMa3d4WUM1MEdXaW8xekhTQTI2MTd6enFjQVFp?=
 =?utf-8?B?dGhMb0Y3Rk16UksrclRlakpEa3d6VXlORXFNQ21mZTZ4QW9SeVZ6VGs2akZB?=
 =?utf-8?B?Z1RxWkRmK2JVdkJMSkc0MGxOTEpUUkR4a1lLMVB0WTNkVFhIekY3VGZYa250?=
 =?utf-8?B?ZDIrN2xxajRGczBOODhKeU82bE1FYU1ad2VOdFNwck5xUkdhVWwzcHhlM0c4?=
 =?utf-8?B?eVI5NUxtUmtGNUw0dXVmb0JCb0V3N0R1cldBczlucUx0WXBMTjJYZnNHR20w?=
 =?utf-8?B?V2t1R1FvQ1Q2M2t2eFBXdGlZM2liVlBvS29KT0JJNmpuNnB0YTl6UUNsNXNV?=
 =?utf-8?B?NThNM21PelRTSTJEQkRVWXUwYll0bGVXNkgxVHpKeUZhZ0lTZE16bTVLa0lD?=
 =?utf-8?Q?iBYMDYY5Ryu4+4dLDcD4VI4ashW29WoUO4C+4RIdQBFK?=
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
	yngQLXqw3tvt33YCzt3oXSIeA3epB0aECL0/rDU+LmbwYzEq6FsTri0/DcC6yxaIMN+CIJ4vhCVh5s/bXvZB6HxLPUjgyJ/ne/zMsQtvTvYmFYOA3LspmYrI4disg7w4T8i6JS1fL/cYUwXD1wGiBwltKWy4hT8X/KpAXUEsJ5A5gyph7pMm0jaQpd6jnj/zt6M6Q0QHU+/Yjg002cnG3n8Dhcdxd+Lu37M2KMil3NARvl1TtKdvhy4QFkMj9QU91mj7aoDEWTXC5U/weNnCLry8htSkBacJ0yUgGsa/FF/WVshNYiQsBg1GkjuDUjC6I6jJ3L+URuapJAVU3XMIPx5te0c18SMvPN7Wn1og22b2vuXeP8g9uV9ZnwZfaSdVsnOC3vSkhJm3K17KaY9ngmqnlgzFIAEQw7/SEwL1RGoF2FU+KEAafsa2gUcrpVzl3+2MJRpthvTzhg0OQtI2L5IocWuo+BLfqY/NfAl77Ra/3wHpcd+yjnO+gDPNbzFq+LnS4EePj4NKTpNS8n27uhTKgCJIjBzmlcNTkSx7m+SwX7gnLCHa2gRt9WSdSwzcZgJWkPoPlg+9o5YE+eem/GOvIgNmnJ4aHy5+3MYwi7efcCy4/9pJzVmfNzDKVphx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b577d1e-fd3f-4a77-91b1-08dcd9a683b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2024 19:00:37.7019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vWv1KPrOAXBUTOUQf0pV5uSkHjX5vFbwKhnS8wUVsYW53n70wf6lli/zRGjR2rABw/7HDZoli07eemicrT114Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8121

PiBIYXMgaXQgYmVlbiBjb25zaWRlcmVkIHRvIHJlbW92ZSB0aGUgdWZzaGNkX3dhaXRfZm9yX3Jl
Z2lzdGVyKCkgZnVuY3Rpb24gYW5kDQo+IHRvIHVzZSByZWFkX3BvbGxfdGltZW91dCgpIGRpcmVj
dGx5IGluIHRoZQ0KPiB1ZnNoY2Rfd2FpdF9mb3JfcmVnaXN0ZXIoKSBjYWxsZXJzPyBUaGUgYWJv
dmUgcGF0Y2ggbWFrZXMNCj4gdWZzaGNkX3dhaXRfZm9yX3JlZ2lzdGVyKCkgc28gc2hvcnQgdGhh
dCBpdCdzIHByb2JhYmx5IGJldHRlciB0byByZW1vdmUgdGhpcw0KPiBmdW5jdGlvbiBlbnRpcmVs
eS4NClllcyAtIEkgdGhvdWdodCBhYm91dCBpdC4NCkkgdGhpbmsgdGhhdCB0aGUgd2FpdF9mb3Jf
cmVnaXN0ZXIgbWFrZXMgaXQgbXVjaCBjbGVhcmVyIHdoYXQgdGhlIGZ1bmN0aW9uIGFjdHVhbGx5
IGRvZXMsDQpBbmQgZm9yIHRoYXQgcmVhc29uLCBvbmx5LCBpdCB3b3J0aCBrZWVwaW5nIHRoZSBm
dW5jdGlvbiBuYW1lLg0KSG93ZXZlciwgaWYgaXTigJlzIGEgbXVzdCBJIGNhbiByZW1vdmUgaXQg
YXMgeW91IHN1Z2dlc3RlZC4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBCYXJ0Lg0KDQo=
