Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8504437C;
	Thu, 16 May 2024 00:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715819033; cv=fail; b=NIE9lhUzv4kglZ2OOk7dPvs9VxT0fCmIaxCc8HZZ1/5dpmL3drsyS8LrSTZn+a9N965WzyglIWM7m4NCVbJsPQQ8BeK4Vc5pdTNGhsSyudvHaL3kssYfpSeEQbTplMC410VWH6PNaeMTb2qNVBbbcEzrsl4mfW/+Mgt9cE3bIAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715819033; c=relaxed/simple;
	bh=7dEM1XjTCHq60eN0ZVumCiSw1a4B76gL1gH4uF8wbjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P+qzzOQ3GJQHTGNzVzA1Etx79rg3+nLQpRVx3Sls51V8R5a39BXbig7lAGhdmDZ557pZnh/CZtQ8d/umEzUqahnkgiJe7X+bOQmoLZAtgJSEhxInKlsekZGCuV90cqXujvrm0JZRggvF8R9OXW/Ct8tt8MUPnvd55excD4RfMnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dgp+JtrV; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=g1jxxCXo; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dgp+JtrV";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="g1jxxCXo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715819031; x=1747355031;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7dEM1XjTCHq60eN0ZVumCiSw1a4B76gL1gH4uF8wbjM=;
  b=dgp+JtrVCVHCcTSekL2QZBtnOqrYfgzZIGwsK/FAxeSlbBeNeT5oQ/n2
   kouM/769NDSJWkR5a5Wfui7ZgrGGFtd8ep5AQI1cZg0ZHQz0xFuuiWLfB
   p3ezFPUDkm5V60QdnkG/x5FYlE3advmWgx30Sy2UF0jG2emyLa/VD5TPW
   PtuTKddDiuRxlpW2JQKNc57dwH0nypeVxbRsG5d4S2975zNn51mUMSlMv
   724aPkjNzBEuSd+W5q0e8etdf2s19wnjbcg2hirHPFPmi5mAK9yChAnEV
   Izj0M+XiPYad2REu/lqI8oDOcvFOzBOJtnSFG5UZy/NE61W1KSuu7LeFB
   w==;
X-CSE-ConnectionGUID: zZj5oFAjQDenpUUB5AEJsw==
X-CSE-MsgGUID: H/T/BsePSxubOAu3sW69lg==
X-IronPort-AV: E=Sophos;i="6.08,162,1712592000"; 
   d="scan'208";a="15775872"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 08:23:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX2va8T5rMCID475u5tuJDRGm1lX/da3xu4m/xa70cFNJFGymbj9IQd+akEjZOKUmTdGLQuGQrXncvd2SK0xtD8cXpCe3fP8R6KWdLuJ8S54UCzxfvwMjYfVEvd9FCwnus6WMaCp/chYd1CgTNMUPKBhMGtidExnNop/DREiK0mDCmgmXk9blnl0XK20h53y9ZJN8xL9jWAJe/j8THUI4iGqFt0nqZXvXLdwGoRh9EWXpVLI1pu8TWJFM7l0v82/h35YYRNTpZHmxZamsCxgglCwpc3IP4MSJpV4VlsqAF7UPwxkpz5BtWj5TPIuzOy4w9Iu/Gzo08wVhwt5lWuUCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dEM1XjTCHq60eN0ZVumCiSw1a4B76gL1gH4uF8wbjM=;
 b=RHu2skkbxW7k7rE/MKxIOx6BELsBJjysI0tD+0Up3uRpbqp2PonkwOYK7vJF9iFnNRg08xu40kbmAJSLMcys9AGJzXsIe/Eil139aiLuuKI7J4YvZfSV44f7Ap65JYk8weoDsI3EUXSySFqmgGA8J0ceeZ2fZj2nF0VIRTL58+NMfmHMxOn2wd73KQrVH7mjHTjHzsapTlaTH92zRA+47AuPE7JjCxa1Rk+5STDRTHyKexBk0ycA4JMsJe0nKpLEpUO0++/s0i5NDEU1p1IUQCJd/vK7DU5sJ66N/cob4CG0QT+b4rkBj+UxrYWS/BuBo0VxxQ1iurkRwE16uVxD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dEM1XjTCHq60eN0ZVumCiSw1a4B76gL1gH4uF8wbjM=;
 b=g1jxxCXo9WdIdHNNy366TLIHyWN6ZZ47FztYvSVIb81ufrrH7L8Nr4bAeKUYF3vrW1/6qfyD4ugOrY0RQxOpCrx1NZk0um8FKp8lqz/QCsrq/AXIOZpInUl2gQKPvBYNw52Q4zmS91MbTHgTT6H09WFcvVmouA10HypTZgEUkH8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7543.namprd04.prod.outlook.com (2603:10b6:510:55::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.27; Thu, 16 May 2024 00:23:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 00:23:41 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Index:
 AQHapbzIAmCD9ZFsDE2/LZDUaio3E7GWsCQAgACAZcCAAAW+AIAAAyWQgAB88QCAAAOoUIAAjGcAgAC8MVA=
Date: Thu, 16 May 2024 00:23:41 +0000
Message-ID:
 <DM6PR04MB6575C839E620F38990BB770BFCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240514050823.735-1-avri.altman@wdc.com>
 <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
 <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
 <DM6PR04MB65759D4064B9FBF13BBFCF72FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <de19c4be-ef6d-4b1a-be26-fb697ac29026@acm.org>
 <DM6PR04MB657562B04C1394FF8FC1D9A3FCEC2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <982ae15e-d3f2-4d0e-983d-fc2c55e6411b@acm.org>
In-Reply-To: <982ae15e-d3f2-4d0e-983d-fc2c55e6411b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|PH0PR04MB7543:EE_
x-ms-office365-filtering-correlation-id: ba0a53e3-d268-4043-3a49-08dc753e7076
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?WEN3cWhCd2dvY01zUzA1ekdUTTNidGMrODJHblppSUMrdlg1ZEtjYlJaYTdZ?=
 =?utf-8?B?VjVzVGlwa1pLb280cHAzcnVLMGxjWEJ5SWpQWUkwdXZmWlBLbWtKckYrV2w4?=
 =?utf-8?B?ZTE1a1VIRWowdHRyY2N4TDdGcFcvUnNVTWwwNXRIZ3AyTHdaaUxLRysxeVJ2?=
 =?utf-8?B?Q3VBaXBBUzFMeGQrTUFWYUNVbndSUWI4MG1rdytBOTZWY3ptZzQzZk9TcG1J?=
 =?utf-8?B?RUNHbkhpYitCSjZuQ2V2NGt5b2ZuZGxSeUprK1J4ZmF0U0thV1p3ZkJrYTYw?=
 =?utf-8?B?NTFKYVhFZ21yMkdrdEN0VzUyc3pZUExRc24yZ21UcnFpK2xyWUFZbmg4Z0g4?=
 =?utf-8?B?ZDlyRmJScmtqOWwvaTYxSE4yeFpjOUhHc1h4ZitHTk1EQ2kzajkwSnZKNEdL?=
 =?utf-8?B?bENRZEtjZmwydW8rZWpkdy9iT3NoemNMTGw0UFhRNWdOcVNuUjl2TUNpOUlP?=
 =?utf-8?B?V09wTjlFbEoxRXNwRWlmbXFFK3RrZS9Dak5CamtmY0p2akE1Rm1SVzR1c1F6?=
 =?utf-8?B?UFpyVmNMWWNNbi96eG9SazdwS3ZZOHBPWmdrSyt1NGRVVkRneTlmTE5Ga3Ji?=
 =?utf-8?B?aDJkT2VadkxCdjNhbk02WHBSMFVZUEFZTHlteUpqdlMvb3B4c1ZiVklXZDh1?=
 =?utf-8?B?dCtuL1A4WnZReVgyNGlHcEd0N1hWYVRiVnEwYkY0S0M3RElFTEZ1SDFBRHNH?=
 =?utf-8?B?d0s4TXFJVXR4OWVDdy9yNnk3RHF1djRBVWVQWWFQS3JBZ1VML3E3aTM3TmFx?=
 =?utf-8?B?elQ3clE1Z2I1Y3FkaUdNRG16cE1aL2RjcWZqWldNM1BQazlvOWgxeStHb0Rr?=
 =?utf-8?B?SEpucVpsODZQNkhKYnNiVTY2N3ZkTmJtUE5HdHJKRzRFUEhHdUZrQTY2bFZq?=
 =?utf-8?B?MVBjY2RPUGt1NHZRRmMzcTdjQWswSWRGQmwzWDlDVWZ6b1VoWnJDdllkck5t?=
 =?utf-8?B?cFkzeTBMUm5peVA4alV3SUxxWlh4bTBUWlFqaXdKUHZZVkdqMHFlWVBKZHJk?=
 =?utf-8?B?U2E4b0pnbW9kQzRJY0J1bU1YcWI1SHBETzhFdlhBNnd3czc4NytFbHU0czhr?=
 =?utf-8?B?WXdYR3dTNDZiVENTUHplQW9KTVR2YW11cHFNY05sMFBjZFZhVEpvQVZPdTRR?=
 =?utf-8?B?c1M5VXQ0SkppQnE4bE9qbk5EOFFYZkZnZnQyTGt2TGxOM1hHQzZqY05GSHVT?=
 =?utf-8?B?N3MxK1hkWEZ4b0Z0TlhoOEo4c3dQNHJjSktLZlZrNHdabzFyWEE4ZWdqS2Z4?=
 =?utf-8?B?N0J2VEFyaVJGZzFhRml3QjgwY2N5eWVsQzlkU1RzZnk0K2xlUnl2NUFhOGd2?=
 =?utf-8?B?WEhqb2ZOMWVpdC9TallhMG1iZzdZTG1GTTMvak1MR3lyeGxISGY0ZGV3YmE1?=
 =?utf-8?B?c1dPY1hROVhWL1EwSUNPRDZhQzUwcnVJdisvTldBNWlvK0FHcDI4ZFdnZndR?=
 =?utf-8?B?STdKNGRmTHZvalBhbHJyWjFVTW9EMXJIT0MxTHI1VTZQU3piUmZneGc4Tkts?=
 =?utf-8?B?RWFxNTdNeGhHSUFSRktYeEFiVS9Nb3hIbm1aRDdzUHJDMEpGZWF6bllUdmp6?=
 =?utf-8?B?MmNnLy9JYnMyK08wYXphZnRSV3FvVDNSbmhRUy8vS2wzWkthU25kaG55N05W?=
 =?utf-8?B?ZDlDVXJ1eThyQ0Vaakwwdm5rOVQ0Q0ttTXRibnJDVEduNkJtQW9zTENwcGNz?=
 =?utf-8?B?MHZhMmpsZVJYR2dMSnoyTzVXeVFCNDJNQjM0WkxrNHFIRHNzYkpzTVBBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TlRjWUIwZmZuWnpVaHFuT1RoMlJ3c0h5UjVsM2tQTHZteEhvekFhcy9zWmRD?=
 =?utf-8?B?aXVocVpFRnZjQWlDczY5cVUxTmR1SFUvTzRyYkQ2bjRpWTBIQ2R0MzR5MTgx?=
 =?utf-8?B?dDhnNWdqc2tsSWliZVpxLzdUamtwU0hjdDA1TE9ydldiU0NSYVBseUNhdDZx?=
 =?utf-8?B?MXB3TVhKS3NxWDZOcTFpZ3lVNzAvbTlHaHE5MldMT212d0RVTWNzRGVEWjd2?=
 =?utf-8?B?dUEzVjRpQ3hwMWpLUnA4OW5YS2gzZy9Ua004TlhlNGVJWkFCaFBhRGZtYlZJ?=
 =?utf-8?B?em1nR2JZOUlsZU01emExRG5rMjEyaGU1TEVXMEVWOHJYZEZaVkNWaDdGRnEy?=
 =?utf-8?B?ZlNURnVPNU9QQ0VwQzAyVUlOYTY0c1RmQVpPOTJ2OHVma2U0N0MvUnlVcGs0?=
 =?utf-8?B?QkZtb3Nvdko1Tm5PSjlha0lvbnpwSTlDMlBYVkpSamdqRGRaZzJKeW1ta0VG?=
 =?utf-8?B?VDlWQnJUVkhaRzN2bWtUcjlIdzJ1aWh1RXMxN3QzaVVXVm51RmFZREpvMC9L?=
 =?utf-8?B?SWl5ZE83TWxpRWd3NVhORXFUUkNDZDFZbFFjZUF5VkNnbWtNZEVsd0gzWDVD?=
 =?utf-8?B?NTA4eEI1YUtzR1cxeEgvdkFrSFIyVzRWY0VjUUR0Y3JkZ1BRWWI1cXhuNmVi?=
 =?utf-8?B?T0Fxc3ZDQytkUDlXdkwyOTFFeUN4Q0JoYk92R1FBTDdpUWhpK2crbGU4WXRL?=
 =?utf-8?B?V0ZOTHhVbW1CWnpsb1RaOHZnb0dRV0crS1RlM2R2VlgyTjdycWt1d2pqdVVS?=
 =?utf-8?B?aTdGSS9oZm03amx4T3lCWFJGM29CN1FWSUNQajVLSDNQMTdzQVdTdHJjUDZK?=
 =?utf-8?B?cUF0UjRJQU1ROFltTzd5OHcrbmVnbm1FMUwyQk1aMmg1Tm1YcGluSHhwQ3hV?=
 =?utf-8?B?QkV5TGErNitSQjdKTXNEWkFCMGhmOHAvUUJjTE9zZ09CVDFEUldHWTZQQjlH?=
 =?utf-8?B?N1c1cENiY1dhUmdUWGxZQ3lXSXhXR0JNMyttWDdXTDU5R1ZHSFI3emNRcThl?=
 =?utf-8?B?YllxMXZxeUFtM1hqM0IwWHhYQTYzYnR5N0ozZ1F5VEk2VFNiWHRMVThYV0Yx?=
 =?utf-8?B?dGdiMSsvWVBhSWpEYkphZk9xbmlVMkIxR0Q2YTYwMXZXamVPNy92TFlOdU5j?=
 =?utf-8?B?MEloVkYyMUc1dTJqVVJJaXRNSlhxYkxQOU9oSVZEY3NTZmZaRlE5ZVZOaHFG?=
 =?utf-8?B?c3RnWWJDQ1lFYXhFZnpVTWpua24yTGtBSFlnREk2YlNMVGI3MERvbjcyQzN1?=
 =?utf-8?B?aXVaWmFmWFRBT3dNZnpLc1pXcHBBK2QxRlRXeUJLOGFSREdpNkxDY01ZS3Iy?=
 =?utf-8?B?RC91OXlIUFhCQ0xsRFlYQ2VGM3RqNWh2OUlWRlFYTlVWcUY2VmRTbXZrR3FZ?=
 =?utf-8?B?NkE5RGZkcmhDamxIRHhUd3ZmVTNJdUNzTmYvYWlkNUVqMGVyemhMU2NVRklZ?=
 =?utf-8?B?dURXT0V3TWMwZkc4dDdLYTV3eFBrVWJsTGl0OUdHZU9NTVdCdUhxOUJiaXY5?=
 =?utf-8?B?N29NaDZEV2NsTXpLbXlQZ25QZUVmMHFPK3RqcmN2Q1ZEb0hHRVpWTnZIU2xl?=
 =?utf-8?B?N1dUazhSMnpEa29NNy9GQldxcHVQQ0YwV3JiZW1US3BWaTI5ODFIUktISTVx?=
 =?utf-8?B?MStQajJUa0g2R2IxWlA2Q3B5Ym10ZHJvZzhOSkdnR241cHJGRURGOUJIYVJ5?=
 =?utf-8?B?b2R1L3BYeEpKUktvZGx3M2ZYWmlCbi8xeDNCaUpSSlhMa2U1Ynd5TmRHbDN2?=
 =?utf-8?B?cVArUjcxa05tMGhYYmI3ZjRGZnV2RVFaV0cxa3hVWUpDdG4vYnQrdzcwSXJt?=
 =?utf-8?B?UitSckpBN0dxVjhSS2FXMS9vNnEzaVNGdDZvRkc5ZXF6SC9GRVphUEVVZ082?=
 =?utf-8?B?SW5MemU2R2xDTWQ5R3V0bkVhUE9pMmJod3JwQnFnYXRtRXRrV2RWU2dmTVV5?=
 =?utf-8?B?VS9EaExpNUIzaG96QVFUSGZBbGw3WVJzTWxLNXhyVEJvWStONGdPaXdzZXVT?=
 =?utf-8?B?UUhEWnRCMHpiT3RCZW1ScmliTnNER2taZTU1aFNqeTFkNXhkMFNaM29OcEF6?=
 =?utf-8?B?ZFJXWmtNMEJMSy9xb2t5V29Tb1Q5MWJkT0tWbWdPdkZZY1ByWUlrMmhydTZl?=
 =?utf-8?Q?Kpn0=3D?=
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
	mNf47Zv+2aVmZ9d1QY5X3+EJ7a7yq6UC2IevSBNesiYxQ0E4ig7gXcrMzvMaCTLpVKoqiU39zmbnAuBlKJXvSlet2R1f8WiINPtUPnyAJt3Q0uqpg96RQgpbIf0D6VkiL/JtQqdcWvjifrJKhBxoDteD24OGoZBA/ebN8HyULD3WT8HqZXBjXzKu6vPjssR3IV9IdA2Na/AfQXViGKVCzPdyF/67i0vVhdYeFCPvPabfErJyfnLJIr0tk3K2TZ/dTPbrknHNXk61M6Y8/owom/118YjvOPRTDZiy+2IElPdNTCG/YzS7ODSOkjE6vWg2+rUKQOQL2Jddoy5u4LcpG9s9EoVLsOguutdn2k60cywmvI/dRXC/vdZbR+SkyUZyyY3nWL3N2pwEHjsu3HmONojRQPMzUAPyM7/pCTgepJ4WWrok8h3sIMVtkVMIDYU0YB+bhXZhKhrke5hWj9nU1XYtRnQmuFoB/uQvvn3uDDx6WsxkTYCMFpNxiPWiMGJV/aRR6Cffds4Mgh0J/eiyElYe2/OjDvFadfjvSSyiPECc1Lg2AV26DDd4Lx0GF+S5VPE4+Qq++vkiBVKqeSwidTR+YYy6fkEPrONWND4EQSz+w0Wxdj734ONVp6WEy1zt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0a53e3-d268-4043-3a49-08dc753e7076
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 00:23:41.4578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bCup1vtDFoDro/y9Gha/+d+9nBz0FwQfpCSP4kvKI0eCReTIkvWW1qHEzY25x0rXE1up3hOIKjrKVxbm6pzEZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7543

PiBPbiA1LzE0LzI0IDIyOjU2LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBWaWEgdWZzLXV0aWxz
IC0gaHR0cHM6Ly9naXRodWIuY29tL3dlc3Rlcm5kaWdpdGFsY29ycG9yYXRpb24vdWZzLXV0aWxz
DQo+ID4gWW91IG1heSByZW1lbWJlciAtIHRoaXMgaXMgd2h5IHdlIG5lZWRlZCB0aGUgdWZzLWJz
ZyBpbnRlcmZhY2Ugd2UgYWRkZWQgZmV3DQo+IHllYXJzIGFnby4NCj4gPiBVZnMtdXRpbHMgaXMg
dGhlIGluZHVzdHJ5IHN0YW5kYXJkIHdpdGggcmVzcGVjdCBvZiBjb25maWd1cmluZyBhbmQgcHJv
dmlzaW9uaW5nIHVmcw0KPiBkZXZpY2VzLA0KPiA+IEFuZCBjdXJyZW50bHkgaXMgYmVpbmcgdXNl
ZCBieSB0aGUgdmFzdCBtYWpvcml0eSBvZiB1ZnMgc3Rha2UtaG9sZGVyczoNCj4gPiBkZXZpY2Ug
bWFudWZhY3R1cmVycywgcGxhdGZvcm0gbWFudWZhY3R1cmVycywgbW9iaWxlIHZlbmRvcnMsIGV0
Yy4NCj4gDQo+IEdpdmVuIHRoZSBpbXBvcnRhbmNlIG9mIHRoZSBSVFQgcGFyYW1ldGVyLCBwbGVh
c2UgcHJvdmlkZSBhIHN5c2ZzDQo+IGF0dHJpYnV0ZSBmb3IgcmVhZGluZyBhbmQgY29uZmlndXJp
bmcgdGhpcyBwYXJhbWV0ZXIuIFVGUyB1c2VycyBzaG91bGQNCj4gbm90IGJlIGVuY291cmFnZWQg
dG8gY2hhbmdlIFVGUyBkZXZpY2UgcGFyYW1ldGVycyB3aXRob3V0IHRoZSBVRlNIQ0kNCj4gZHJp
dmVyIGJlaW5nIGF3YXJlIG9mIHRoZXNlIGNoYW5nZXMuDQpPSy4NCg0KQnR3LCBtYXhfbnVtYmVy
X29mX3J0dCBpcyBhdmFpbGFibGUgZm9yIHJlYWRpbmcsIGxpa2UgYW55IG90aGVyIGF0dHJpYnV0
ZS4NCldpbGwgYWxsb3cgdG8gd3JpdGUgaXQgYXMgd2VsbC4NCg0KVGhhbmtzLA0KQXZyaSANCg0K
PiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
