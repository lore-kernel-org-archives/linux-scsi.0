Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D872456B8C;
	Tue, 17 Sep 2024 06:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726555956; cv=fail; b=TinunCmuqq2eCtJEznEtuD5l4ue83YtQUySYBOLrGHhBuY79wbWXrM8tYrB5LntN9TygRGN6Pq2Nl9AX9CWtSJ2nBNA17wPlLrCIPV1LA7RUBQfouuywM6tlC0t8pRAzyMVe6mzwBj0iqlLoAGoFJJdUrR3ZFzPcuwewAiUlctM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726555956; c=relaxed/simple;
	bh=rk0lToLlqaBktUo1LlDpeWRYDFZsA1i+qhcP6aUV6TA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NFHW1iQ+Vo5+w+GMUGH05sSwR6ubaaMFacabicLscCtg9YTSYBlspYKgkqbcbTcXWT2tiiGuHYum1viKjsvzYnhP+9zgHYH9RlROBl7Cu/U2fb2BzZtlqV7JyZ0q1vxiBd0utTXP7TyvB7namuhiRdhHgtJ73N+XVPaofjqbEB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=V8ZjOSbb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=fdAkJZJ2; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V8ZjOSbb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fdAkJZJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726555954; x=1758091954;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rk0lToLlqaBktUo1LlDpeWRYDFZsA1i+qhcP6aUV6TA=;
  b=V8ZjOSbb07NBXx3thPpOgINI2ah2hR4bVsWh1yXZuhHouxvD8jVH0zib
   mIee6rg2U7dzYII/L/lC99KFf1lbat7cO6aKLAzm/nSHn0+axXTcINm1H
   oia9xgu05ZBrYkIM46TpBOSCWmJKgiKbOa9lFEj69vHEJba4KT26JLGhQ
   /5YCRm6lqWVbCkyslIqdvT5okVvZUGQ5dkJ7FfU+jsUvMB30ilrmp7aGE
   D/4MBOWX4inYydhokvq9souXe+xbRtVCZykD0oydGjuwDjTVYi5QDnsah
   wuQYhbmrtbkVn3an7vVksTd2koSONCOmxC39J9kn4UMc9gyqXsnQTJIis
   A==;
X-CSE-ConnectionGUID: ojc2EUeeR6yMr9rtaorsjA==
X-CSE-MsgGUID: 7N11XCtFQLigkYMXKn8h4A==
X-IronPort-AV: E=Sophos;i="6.10,234,1719849600"; 
   d="scan'208";a="27704537"
Received: from mail-eastusazlp17010007.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.7])
  by ob1.hgst.iphmx.com with ESMTP; 17 Sep 2024 14:52:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wp4O6nOqptXhSpp43+xe1GCT6qrWqFyK2RfqaKAHahjf54/HjNdio8RpqQmmyHp67zj42AdIkcjNS2fivOterhPayI99atyf97IMdFrQUa7xcocmiwuKe6mJyx95WpHDsZfd/vak5qFcV6zwqXbElLatZItxsDwEbmTfOxYNODCD/hE0ffZ4/ulXaO9l0PE+VrATYURir9z+MMzHHmRuxD79stJ8C05rkjwj0OM7NC+8NEF1xrbDQzfrM6dX2UAIDjZE3xjJFDWYui1/cnytAYD2OR+Qktm1PNZwzY9R0uLoQc0oO+gQ+uX0v8oB9RwU4KaqHVzgpQT3M9fxLuFR4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rk0lToLlqaBktUo1LlDpeWRYDFZsA1i+qhcP6aUV6TA=;
 b=iOe/FrmGUWKGVXDINknfgIGtHJLO6QkrWKAaBLKgcD2bhcWTPOgCqmKNvqZIYQZwnd+dU95hQ0m76MyFy+L8s7tYQU5gZn9PNvRHKgzJFQ0W2FL/r3BDVK9Xi8VD9LIl8C+nUdXLRcCOz3rYHqs78KMqp5t5JZBjsbv31UqyteU+cfBHIDhOJD0Jz08HtfuhB6ZlYgNGwuc+LERmEl4Lwnu0X40tca3eKhPK0ZDDrvySDzFoKGRjAPV0LpZFwh0zgqZQFlgLNBm902X993nZndcKaRjM8QDEi6gUBFRE3lbgtPq8gyhTCfUXYCUYEnRasnpUZCiRcufXXUH+wNATag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk0lToLlqaBktUo1LlDpeWRYDFZsA1i+qhcP6aUV6TA=;
 b=fdAkJZJ2Uk36wKjf/k5S6Llp8Apbj2CZrD1+FGoUAcMOl3xEf9S5QWwYn3GjzWM3P+MocdiEuCNMrP5Opae9rsrDBUbzKjB7O3Ld9tMoMJWxnsspkPI6Y301x16A3HKXbPFkUNa1sjNRioT23ALhIyBjnJvtO/ejDC1s1jBF1Ts=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB8129.namprd04.prod.outlook.com (2603:10b6:610:f5::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.24; Tue, 17 Sep 2024 06:52:27 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7962.022; Tue, 17 Sep 2024
 06:52:27 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Topic: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Index: AQHbB0P1xNgr2xhkc0aS4aiTVb0xxbJa/qOAgACMpLA=
Date: Tue, 17 Sep 2024 06:52:26 +0000
Message-ID:
 <DM6PR04MB657549C63703AECEA2169CC4FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240915074842.4111336-1-avri.altman@wdc.com>
 <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
In-Reply-To: <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB8129:EE_
x-ms-office365-filtering-correlation-id: 1a9ac3ab-8a18-4f82-e64e-08dcd6e54abe
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cWE4TWwwNFFLa0FXVjVobW1vVnNhNEZMajIyZnZJY3FnUlJkU0lqbEt6Z2RD?=
 =?utf-8?B?bHFFT294dUdJVlJrVW9rVjB2S05aa013cDZwWmVieHNnd0FFOEc0WmYvZFpJ?=
 =?utf-8?B?U3pYcmZtcUZUTnRZd0hKS3FqSEVPZ2FMVk15WThGR0ZoMXNKejlueFJBNGdp?=
 =?utf-8?B?NWdYYkRMb0t6QVRMaEJ4NFJ0QTltN1V2ZmhJQzBqa29raEFVMEk4dTR0cTdr?=
 =?utf-8?B?RVBPN1lvZ2JkZm5iellmVzl5YTc4akdpd2J4YXBtYlNDVG9kZ2J0SVNJVTYy?=
 =?utf-8?B?SGhibSs0bGdSYmtBUVFRakVvdlBSVVJQMjFEdHBWUWkvcmwxZ1IwU0UzQ3Bx?=
 =?utf-8?B?NEIvYWp1VStJUmdvbmpOamdCcFB3R3l5b1lvR1pXeEo5dDR6M05RRHRWM1lu?=
 =?utf-8?B?djFxV1JDVjJCMUpoUHVldjljNkFkdENGNFQveTQ4OTlid0xuZ0lMVmhocjgx?=
 =?utf-8?B?VXoxTGY0UjB3aHJ0bE1MYlRtYkwvaFVWUWpXZDU0ZVZTcmZldFVDNjhXcWwy?=
 =?utf-8?B?bzY1RnlTRHV3Wmt0OWpWd0E4bmk0Q1EvcVlDSmhTZFFIUkdWMmRYUGVUUUxS?=
 =?utf-8?B?dmQxSWpKNGNpTEhhdlB2dDZsV01Kc3dGdVVHb2RNSlBwNkJWQWJ5b1dtb2wx?=
 =?utf-8?B?dE43WitoeFhmYmVaUHBLVUEzeGIvOWhyVVdLRFNqN3BzMU00d0wxTStzN2N1?=
 =?utf-8?B?MkRuSkNpUTY5NjdmTFFLdm9sNlM4bWN5S0hCSzRuNXQ5NmFTRGpSNDNkWUxw?=
 =?utf-8?B?cDg4V1EzYkdzL3hETG9BODNPelpNNjloaTM0WXFRTEc2M0JjTzRvSUxqWmVB?=
 =?utf-8?B?Y1JMZGdtZ2VGLzZMMDFVMTNYOTE3cUlIYjBnZzJFREswbzJiZHdMS1VXUzNt?=
 =?utf-8?B?RXZ0aURscTVTRVQ4L241L1JKTzc4NnVtTUdQelpPZTlYMGRoSERGSW51QmJI?=
 =?utf-8?B?NUhReFdoU1B1MlRKZWFCd0hkUnRkcWpINzhBd1pBakkxMDlWNTh6dXNrTDY3?=
 =?utf-8?B?QW0wWmZmNWxuakRFTTRiVkExQXBlU2x0NVVSaE1HNTFLV2FCY1hQSEJFWm9j?=
 =?utf-8?B?ODBmTmRBRXUrY1JUK1gzZStOcXZuVGdCeERkZXcrSFpoYThOUnB5YnovVjFx?=
 =?utf-8?B?SkdFa1NDUC9vUXRwdG0wY1JKbXpNcTlpeDVoOXlmbkJvNU91bHpHalZYa2ho?=
 =?utf-8?B?enE5Rkl6dEphN1JJMCtVZktsR3pHR0taSjVFRHorRE9qZnlLM1pMaWZDN1Qx?=
 =?utf-8?B?elhncUpGTmF2MjBaaTlCRGJVdVBOUnhmUEc4d1BFMFRUYmpKczJrN1g2c0l5?=
 =?utf-8?B?MEdiTkZWVXRJV01EWTJwN2ltYVVPcEVvSzlSR3R5M0RjTlNzRUNRUDNvdkY2?=
 =?utf-8?B?VkVOTVYxNjR2TVhKazdmSXVvM05veEdhaTYzVnhSV2NQTjdpd2pTR2ZUTkFQ?=
 =?utf-8?B?R2N4QjREek0yNE4zaVlwamVsdjBQdlRJc2VMSlZWWnk2YWNGOW42MElWWXYy?=
 =?utf-8?B?ZG5TTVZhNE94cldVdnV1c3BzSk9UZStuRGMvdEhjNmpTaU5BeWMwSFgwclJF?=
 =?utf-8?B?TE1NZUh5dDRSaHpWRFliRytqK1NhTElnLzNnMmxXZS85WmlXOFNESHBKSUxB?=
 =?utf-8?B?Wm0vRy9PNUY0MTZJQnpxTG1GMTJPc0g3dDR1aFJPTlNFZk1hR2dVcVJVQTBr?=
 =?utf-8?B?akRodmlaLzlSNml5WTkwaXNHZGIrc21MWHZuWWs4TndteTBHelQyNGlMd2I0?=
 =?utf-8?B?NnRQcTJacVBsUUJrYTN0elBDcUtCOXRVdXZ2cXFFZmVZZnpYMnVTeWJEUUdN?=
 =?utf-8?B?SEpvNDIvd3VydDhoZFhmV09UNFZGRDBkYXpCajhudTdWOEIvekYzVGlkNTdV?=
 =?utf-8?B?QjdtLzUvODdyL2d6T2RKTkFBTnpmdGJaOS9uK2hSL0VLU2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c1orS0N1blZ4N2NxNStHT01mZkp4aktORFB1alBWR25FV1owcHdmTzQyaE9L?=
 =?utf-8?B?VzE5QUM3SFhPRmRMQTdRUzhtV0N5SkcvYVp0b0I0WTl5eWhJVjN3TmJTVnoy?=
 =?utf-8?B?b1YrV2ZkRFI5NzdiV2xJeTNXYllMajExN25remNQS3QwTnA5dzhQdFpCa255?=
 =?utf-8?B?NXM2aElzdVZ2SU5RLzg4a3liSGdoeG5IQ3NRcmNlYWxqWGhBY25GcWE0cy94?=
 =?utf-8?B?N203UllMVmZ3MjBXVUQ2MmNJUVdmbml2cWNoOWt1djRXbFk0V043cEdTREkr?=
 =?utf-8?B?Q3I5UWVuVE1XN05DdGdwQXY4bE9OTWNJMVdEM0hBOWI1NGxoWTExK2ExeHk0?=
 =?utf-8?B?MWg4VUxuNXpGclI4dHlwcE5wSEsrSERkZFZTSWV5clpQMHlJejdXTC9RR2xP?=
 =?utf-8?B?ZU1CZ2dHYkNOTGNWeW03bFNCWklWbEZQN2UrQnMxL0xxdjRHOS9Ia3A4dWhP?=
 =?utf-8?B?cURiQU5BMTUxN3F5VXA0RXVFVDNwUnVHZGpPamRGQ3VCSzBVUEZPbnJGTFUz?=
 =?utf-8?B?RVpEMGZZRCtOUndGQzVWNWFHUWJiSHJXcjZXRy9lenM4V3Rsb0dJNHI1NVdC?=
 =?utf-8?B?TW1hTnVYZ3lGd3hlNWVhN25JaEtoMU9vK01nZjhyeS9LSFVHdjhSaThCSHpt?=
 =?utf-8?B?NjlFYlNlOXdHUzVzclMzK2piZ1FUdTI1cFg1MUsrRTVBeVF1b2xCckkzbStT?=
 =?utf-8?B?VlFROXRuSFFBOGRqMFJJM1pVUkVjNXk2d0hUaGRFM3dUR0xHTkQwT0tiZmpF?=
 =?utf-8?B?VkJRbGVHTk1ubHlrMzBCSTcrSE41TnhjZUVBREpLbFA2UGdrUnovWHEzZ2pJ?=
 =?utf-8?B?NHBWelFTajV3NTlZUVVTdWpWZnFuL0lMRGVjKzFHcGlJSVNDVmI5QklhYy9F?=
 =?utf-8?B?VnBJK0lLK1N6bjNrNFdYRUNUcFJjVndmNm5jRnFpVmtzcWIzWXB1MkhUQ3c2?=
 =?utf-8?B?Y0pycW53MTdGVHYzcVIrb05PS3dwTmZoU1crck81dGpObXhZR1JzL2w3ZDU1?=
 =?utf-8?B?ajhHWWlqa1Y5ckh1RkNBaDhTUitGYUVlTmR3VlZYcGU0aEtmeTRiWTlYTWJu?=
 =?utf-8?B?ekluV3lOQ2p3Q1NoZHV2YzFRQlNhVnNXSkRGZXorZGwwVk9IdnFLUVoxN2Vo?=
 =?utf-8?B?NElCd3ZjVjd6UXpybnQ4c0MxN1RBWnBRUkJGQjZCZElFSHpNT2w1WmZqa1Vy?=
 =?utf-8?B?OU9wZGRrRmI0cUswcDNibHhGTGo3WkdyV0tCOHNFZU0xSXA1eUVxUzhTZWJr?=
 =?utf-8?B?aW9ETDVJWmN1TUEvRmc5QlZITXhBZUxycXJEY05vOWVuQzBadnV3WFgrSnlM?=
 =?utf-8?B?YzNNajZvZ090c0haUHZmMEFqUjY3Tjd2a3VaOTA3MEwyQWdaVnR2dWQzUEta?=
 =?utf-8?B?Zmo5THMxZEl0VTNIT0Q4Y2FZMFV1eUwyQU5BeG4wU0pydDBPckc0NnhvajNM?=
 =?utf-8?B?bzVSbWdST29wRjJsY2ZkYWRDYU8vRXgycjdCbng3ajYzekRKcWZidTlla0xp?=
 =?utf-8?B?Wld0cENPZEtUKy9nMHdvZks3cVk3RDFYZ1BvMnh0anJRZWZpZjhhb0dRd3VY?=
 =?utf-8?B?clQvWlpMak54WWhmcEtYSUlzejJaL0V3VWF4SG8wWHVHUUZLNUo2WnJYOW45?=
 =?utf-8?B?dXo0d29vL2dPdmVMeFlvZHNFN2k3Z3JTRG5PR0M5Q0tKOW1wWUlHTEIrcUtT?=
 =?utf-8?B?NG1nelV3Sm8xZDBmSDg2NW9OQUQrZjlxa2QrSUtYN1V4TmNqRW5KOTd2NWkw?=
 =?utf-8?B?N3RrTEszc1gxRDludmM5bzdzUEYzcENJYkx4U25SQ09Scjg1dTlwd2cvbThN?=
 =?utf-8?B?L0VPNzg5QnBaRFVLSENEZ0FSLzY4TVEvWmQyVDFGa2tMVnpxY0ZBTjBaODNU?=
 =?utf-8?B?b1Y0ZFRpTXUwaHhqb3BDVUlGL3crTE9lelNEUzJsUUNuU2dwL3ZYbUYrUkpJ?=
 =?utf-8?B?U1kyY2d1NE1CV3dOZE12UHM1ZFZPOXRJRzFmMitmVXRRRzZxTVBnbmx0ZHFJ?=
 =?utf-8?B?elpVUXlMclZzazdranlYeFhIZXBrVU1DYi9aUW1JOVRiODhsWmVzeXZHZ0ds?=
 =?utf-8?B?SEVpdFFCTFN6dm5FY3NYTnNzYjFSRUdLQkl0MXRjTXBwc1JrUkNYWnp3M2hr?=
 =?utf-8?Q?l+iFgUCCw2xnfuupkWsZNb31M?=
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
	pw6sv6b15N2pk9HO9D6qGipqkRZvZJqtUjnfcdE6pvCbqiqrwms4WsdHDxHwOq7LAInT+AAwCjU9B5VHMk/vOmyWT5rXBJhIGv5kRCZ4HN6fkHsMevppTDsOhlKSkJrlCams2avj/s5LxmVwgXGGhCH4a9DGyOPpuXnMYwK+VZRU86aOLfQ8TIW1MjYeOfGT9eS5KeJISVUulH4rLz9XzsLjabQY3yPcXKuJzrX64Y8+xJlsddRWgN/t3xd9Ype9HH2AhyFvXK/5CtF/YyOGYx+RaiErE4XlwciE5QY1kh3W+U/+oZn0FT5m428lCZnRmpoYG3HBkMT3XrrOYCUopjZTk+I7cXCk4dr+xYglaY72KyeZ8QrdDsnHzsQ9acvoifMllO4ntXbCwYjihBCDKWNOz0YKfNRTLRyU0mH6KjXZ25Y76Fk8HmAiqqGe3rEFRQW9z/vvpMfNmcjXQQTMIZq9IWUF4ZiKtcm0wNTuqQHF/1RYqNCJbgZ4DESD4bUeZJOkGMtaz/rVXTOphGI2toxvnd5kWoLV3GMqMxDv+Yaq2rMe6556nwjblS5QZcl7Nfw5nSZlquZJJtUs5SsfDG1PMhgjdpgVQRAWiqMfX8DLSlNcQDdqveBWQCjdmJhH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9ac3ab-8a18-4f82-e64e-08dcd6e54abe
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2024 06:52:26.9541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gSNHZ0s78jP9jSU/4iBYp8D0fXPf+6udFP0ZGRgMYhPyLByDaWPu029LJooYf+i8NzlGThSXyLpqZX65+CQJBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8129

PiANCj4gT24gOS8xNS8yNCAxMjo0OCBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jDQo+ID4gaW5kZXggOGVhNWE4MjUwM2E5Li4xZjY1NzVhZmMxYzUgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gPiBAQCAtMjc2MSw3ICsyNzYxLDYgQEAgdm9pZCB1ZnNoY2RfcHJlcGFyZV91
dHBfc2NzaV9jbWRfdXBpdShzdHJ1Y3QNCj4gdWZzaGNkX2xyYiAqbHJicCwgdTggdXBpdV9mbGFn
cykNCj4gPiAgICAgICB1Y2RfcmVxX3B0ci0+c2MuZXhwX2RhdGFfdHJhbnNmZXJfbGVuID0NCj4g
PiBjcHVfdG9fYmUzMihjbWQtPnNkYi5sZW5ndGgpOw0KPiA+DQo+ID4gICAgICAgY2RiX2xlbiA9
IG1pbl90KHVuc2lnbmVkIHNob3J0LCBjbWQtPmNtZF9sZW4sIFVGU19DREJfU0laRSk7DQo+ID4g
LSAgICAgbWVtc2V0KHVjZF9yZXFfcHRyLT5zYy5jZGIsIDAsIFVGU19DREJfU0laRSk7DQo+ID4g
ICAgICAgbWVtY3B5KHVjZF9yZXFfcHRyLT5zYy5jZGIsIGNtZC0+Y21uZCwgY2RiX2xlbik7DQo+
ID4NCj4gPiAgICAgICBtZW1zZXQobHJicC0+dWNkX3JzcF9wdHIsIDAsIHNpemVvZihzdHJ1Y3Qg
dXRwX3VwaXVfcnNwKSk7IEBADQo+ID4gLTI4MzQsNiArMjgzMyw4IEBAIHN0YXRpYyBpbnQgdWZz
aGNkX2NvbXBvc2VfZGV2bWFuX3VwaXUoc3RydWN0IHVmc19oYmENCj4gKmhiYSwNCj4gPiAgICAg
ICB1OCB1cGl1X2ZsYWdzOw0KPiA+ICAgICAgIGludCByZXQgPSAwOw0KPiA+DQo+ID4gKyAgICAg
bWVtc2V0KGxyYnAtPnVjZF9yZXFfcHRyLCAwLCBzaXplb2YoKmxyYnAtPnVjZF9yZXFfcHRyKSk7
DQo+ID4gKw0KPiA+ICAgICAgIHVmc2hjZF9wcmVwYXJlX3JlcV9kZXNjX2hkcihoYmEsIGxyYnAs
ICZ1cGl1X2ZsYWdzLCBETUFfTk9ORSwNCj4gPiAwKTsNCj4gPg0KPiA+ICAgICAgIGlmIChoYmEt
PmRldl9jbWQudHlwZSA9PSBERVZfQ01EX1RZUEVfUVVFUlkpIEBAIC0yODU4LDYgKzI4NTksOA0K
PiA+IEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9jb21wX3Njc2lfdXBpdShzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCBzdHJ1Y3QgdWZzaGNkX2xyYg0KPiAqbHJicCkNCj4gPiAgICAgICB1bnNpZ25lZCBpbnQg
aW9wcmlvX2NsYXNzID0gSU9QUklPX1BSSU9fQ0xBU1MocmVxX2dldF9pb3ByaW8ocnEpKTsNCj4g
PiAgICAgICB1OCB1cGl1X2ZsYWdzOw0KPiA+DQo+ID4gKyAgICAgbWVtc2V0KGxyYnAtPnVjZF9y
ZXFfcHRyLCAwLCBzaXplb2YoKmxyYnAtPnVjZF9yZXFfcHRyKSk7DQo+ID4gKw0KPiA+ICAgICAg
IHVmc2hjZF9wcmVwYXJlX3JlcV9kZXNjX2hkcihoYmEsIGxyYnAsICZ1cGl1X2ZsYWdzLCBscmJw
LT5jbWQtDQo+ID5zY19kYXRhX2RpcmVjdGlvbiwgMCk7DQo+ID4gICAgICAgaWYgKGlvcHJpb19j
bGFzcyA9PSBJT1BSSU9fQ0xBU1NfUlQpDQo+ID4gICAgICAgICAgICAgICB1cGl1X2ZsYWdzIHw9
IFVQSVVfQ01EX0ZMQUdTX0NQOyBAQCAtNzE2NSw2ICs3MTY4LDggQEANCj4gPiBzdGF0aWMgaW50
IHVmc2hjZF9pc3N1ZV9kZXZtYW5fdXBpdV9jbWQoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4gPg0K
PiA+ICAgICAgIHVmc2hjZF9zZXR1cF9kZXZfY21kKGhiYSwgbHJicCwgY21kX3R5cGUsIDAsIHRh
Zyk7DQo+ID4NCj4gPiArICAgICBtZW1zZXQobHJicC0+dWNkX3JlcV9wdHIsIDAsIHNpemVvZigq
bHJicC0+dWNkX3JlcV9wdHIpKTsNCj4gPiArDQo+ID4gICAgICAgdWZzaGNkX3ByZXBhcmVfcmVx
X2Rlc2NfaGRyKGhiYSwgbHJicCwgJnVwaXVfZmxhZ3MsIERNQV9OT05FLA0KPiA+IDApOw0KPiA+
DQo+ID4gICAgICAgLyogdXBkYXRlIHRoZSB0YXNrIHRhZyBpbiB0aGUgcmVxdWVzdCB1cGl1ICov
IEBAIC03MzE3LDYgKzczMjIsOA0KPiA+IEBAIGludCB1ZnNoY2RfYWR2YW5jZWRfcnBtYl9yZXFf
aGFuZGxlcihzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QNCj4gPiB1dHBfdXBpdV9yZXEgKnIN
Cj4gPg0KPiA+ICAgICAgIHVmc2hjZF9zZXR1cF9kZXZfY21kKGhiYSwgbHJicCwgREVWX0NNRF9U
WVBFX1JQTUIsDQo+ID4gVUZTX1VQSVVfUlBNQl9XTFVOLCB0YWcpOw0KPiA+DQo+ID4gKyAgICAg
bWVtc2V0KGxyYnAtPnVjZF9yZXFfcHRyLCAwLCBzaXplb2YoKmxyYnAtPnVjZF9yZXFfcHRyKSk7
DQo+ID4gKw0KPiA+ICAgICAgIHVmc2hjZF9wcmVwYXJlX3JlcV9kZXNjX2hkcihoYmEsIGxyYnAs
ICZ1cGl1X2ZsYWdzLCBETUFfTk9ORSwNCj4gPiBlaHMpOw0KPiA+DQo+ID4gICAgICAgLyogdXBk
YXRlIHRoZSB0YXNrIHRhZyAqLw0KPiANCj4gU29tZXRoaW5nIHVuZm9ydHVuYXRlIGFib3V0IHRo
ZSBhYm92ZSBwYXRjaCBpcyB0aGF0IGl0IHNwcmVhZHMgdGhlIGluaXRpYWxpemF0aW9uDQo+IG9m
ICpscmJwLT51Y2RfcmVxX3B0ciBvdmVyIHR3byBmdW5jdGlvbnMuIFdvdWxkbid0IGl0IGJlIGJl
dHRlciB0byBoYXZlIGFsbCB0aGUNCj4gY29kZSB0aGF0IGluaXRpYWxpemVzICpscmJwLT51Y2Rf
cmVxX3B0ciBpbiB0aGUgc2FtZSBmdW5jdGlvbiwgZS5nLiBhcyBpbiB0aGUNCj4gdW50ZXN0ZWQg
cGF0Y2ggYmVsb3c/DQpJdCBkb2VzIHRoYXQgZm9yIHRoZSA0IGRpZmZlcmVudCByZXF1aXJlZCBp
bnN0YW5jZXM6IGNvbW1hbmQsIHF1ZXJ5LCByYXcgcXVlcnksIGFuZCBycG1iIGV4dGVuZGVkIGhl
YWRlci4NCklzIHRoZSBiZWxvdyBwcm9wb3NhbCBldmlkZW50bHkgYmV0dGVyPyBlLmcuIHdpdGgg
cmVzcGVjdCBvZiBlZmZpY2llbmN5LCBzaW1wbGljaXR5LCByZWFkYWJpbGl0eSBldGMuPw0KDQpU
aGFua3MsDQpBdnJpDQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hj
ZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBpbmRleA0KPiA4ZDkwYWY2NDM0ZGEuLjlk
ODI2ZTVkNjEwYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiAr
KysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC0yNzcwLDEzICsyNzcwLDE0IEBA
IHZvaWQgdWZzaGNkX3ByZXBhcmVfdXRwX3Njc2lfY21kX3VwaXUoc3RydWN0DQo+IHVmc2hjZF9s
cmIgKmxyYnAsIHU4IHVwaXVfZmxhZ3MpDQo+ICAgICAgICAgICAgICAgICAudGFza190YWcgPSBs
cmJwLT50YXNrX3RhZywNCj4gICAgICAgICAgICAgICAgIC5jb21tYW5kX3NldF90eXBlID0gVVBJ
VV9DT01NQU5EX1NFVF9UWVBFX1NDU0ksDQo+ICAgICAgICAgfTsNCj4gKyAgICAgICBtZW1zZXQo
JnVjZF9yZXFfcHRyLT5oZWFkZXIgKyAxLCAwLCBzaXplb2YoKnVjZF9yZXFfcHRyKSAtDQo+ICsg
ICAgICAgICAgICAgIHNpemVvZih1Y2RfcmVxX3B0ci0+aGVhZGVyKSk7DQo+IA0KPiAgICAgICAg
IFdBUk5fT05fT05DRSh1Y2RfcmVxX3B0ci0+aGVhZGVyLnRhc2tfdGFnICE9IGxyYnAtPnRhc2tf
dGFnKTsNCj4gDQo+ICAgICAgICAgdWNkX3JlcV9wdHItPnNjLmV4cF9kYXRhX3RyYW5zZmVyX2xl
biA9IGNwdV90b19iZTMyKGNtZC0+c2RiLmxlbmd0aCk7DQo+IA0KPiAgICAgICAgIGNkYl9sZW4g
PSBtaW5fdCh1bnNpZ25lZCBzaG9ydCwgY21kLT5jbWRfbGVuLCBVRlNfQ0RCX1NJWkUpOw0KPiAt
ICAgICAgIG1lbXNldCh1Y2RfcmVxX3B0ci0+c2MuY2RiLCAwLCBVRlNfQ0RCX1NJWkUpOw0KPiAg
ICAgICAgIG1lbWNweSh1Y2RfcmVxX3B0ci0+c2MuY2RiLCBjbWQtPmNtbmQsIGNkYl9sZW4pOw0K
PiANCj4gICAgICAgICBtZW1zZXQobHJicC0+dWNkX3JzcF9wdHIsIDAsIHNpemVvZihzdHJ1Y3Qg
dXRwX3VwaXVfcnNwKSk7IEBAIC0yODA5LDYNCj4gKzI4MTAsOCBAQCBzdGF0aWMgdm9pZCB1ZnNo
Y2RfcHJlcGFyZV91dHBfcXVlcnlfcmVxX3VwaXUoc3RydWN0IHVmc19oYmENCj4gKmhiYSwNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjcHVfdG9fYmUxNihsZW4pIDoNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAwLA0KPiAgICAgICAgIH07DQo+ICsgICAgICAg
bWVtc2V0KCZ1Y2RfcmVxX3B0ci0+aGVhZGVyICsgMSwgMCwgc2l6ZW9mKCp1Y2RfcmVxX3B0cikg
LQ0KPiArICAgICAgICAgICAgICBzaXplb2YodWNkX3JlcV9wdHItPmhlYWRlcikpOw0KPiANCj4g
ICAgICAgICAvKiBDb3B5IHRoZSBRdWVyeSBSZXF1ZXN0IGJ1ZmZlciBhcyBpcyAqLw0KPiAgICAg
ICAgIG1lbWNweSgmdWNkX3JlcV9wdHItPnFyLCAmcXVlcnktPnJlcXVlc3QudXBpdV9yZXEsIEBA
IC0yODI1LDEyDQo+ICsyODI4LDEyIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB1ZnNoY2RfcHJlcGFy
ZV91dHBfbm9wX3VwaXUoc3RydWN0IHVmc2hjZF9scmINCj4gKmxyYnApDQo+ICAgew0KPiAgICAg
ICAgIHN0cnVjdCB1dHBfdXBpdV9yZXEgKnVjZF9yZXFfcHRyID0gbHJicC0+dWNkX3JlcV9wdHI7
DQo+IA0KPiAtICAgICAgIG1lbXNldCh1Y2RfcmVxX3B0ciwgMCwgc2l6ZW9mKHN0cnVjdCB1dHBf
dXBpdV9yZXEpKTsNCj4gLQ0KPiAgICAgICAgIHVjZF9yZXFfcHRyLT5oZWFkZXIgPSAoc3RydWN0
IHV0cF91cGl1X2hlYWRlcil7DQo+ICAgICAgICAgICAgICAgICAudHJhbnNhY3Rpb25fY29kZSA9
IFVQSVVfVFJBTlNBQ1RJT05fTk9QX09VVCwNCj4gICAgICAgICAgICAgICAgIC50YXNrX3RhZyA9
IGxyYnAtPnRhc2tfdGFnLA0KPiAgICAgICAgIH07DQo+ICsgICAgICAgbWVtc2V0KCZ1Y2RfcmVx
X3B0ci0+aGVhZGVyICsgMSwgMCwgc2l6ZW9mKCp1Y2RfcmVxX3B0cikgLQ0KPiArICAgICAgICAg
ICAgICBzaXplb2YodWNkX3JlcV9wdHItPmhlYWRlcikpOw0KPiANCj4gICAgICAgICBtZW1zZXQo
bHJicC0+dWNkX3JzcF9wdHIsIDAsIHNpemVvZihzdHJ1Y3QgdXRwX3VwaXVfcnNwKSk7DQo+ICAg
fQ0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
