Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDC21624C2;
	Wed, 26 Mar 2025 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742974234; cv=fail; b=XYyemmfkcaH9tmycrTGHPvxq79na2fK67PX3s923gqDV7SYvU2JLNhPYhGirUPMfY+63oOfnylsvx2Rg/83hBZJdg8rVEzR6UbrAicT2/u+c2skc4+EyegGBk9PLMrvA/xVRtzp1wjEdLQ8UzXIK5a/zetbrpa4TpFXDFoimfL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742974234; c=relaxed/simple;
	bh=wzzloNMkLrZ5oRB1q5WdllCtUbZ6R+qLMav/U92Qo1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u43aMbKPQ6lPNoEfR3zqg8u/IWlRZ+wdzF2drVy49GIXL0A3VvweLVf5Lqoap9f7iLpUQfX0xdVzz/YmBdioJe9y9eUzL5Akp2uKuGQMmlx+KcRFYZFM8MxroyP88/Fia+10O72MmzozVEpL60Avhxy7EvYOZXCfPy6IiXBpCCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=Isj2eCyQ; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="Isj2eCyQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1742974229; x=1774510229;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wzzloNMkLrZ5oRB1q5WdllCtUbZ6R+qLMav/U92Qo1Y=;
  b=Isj2eCyQGnf6j5Ch/HXeQHldB/ylREJcAPuB7OxonVrC7Nyy+APA8Oob
   L2ZnXxn2QZJRUZ5VDePimuAq9Xi13vi+GouZ8V0W/7oXI2x8IPigxatv+
   4ad35tRye903y/6r0hV1yJD7jc2T/lvWBoXDDFuDPMQEjAHw75ByrTfIw
   1PK9Ja9A7eX4RMwoa71zjB/c0mcJeeBNsUHLJGeOn+UpzqUNVrsD9euWD
   +pLnAy+bsJecd+0CP8FIA5gGl4MYx/lhrMHQhmi8ICxhB7H89xM3MvUV8
   GHNO0txcN50In8XB9KlwMR7tQ7xXMiuDqLmcn5D9M4iNAcTGjGkxQ0tar
   A==;
X-CSE-ConnectionGUID: sr8PhD6iSf2bfpK8RQiNYA==
X-CSE-MsgGUID: V8JqzWsXSnGTvQQeXSfMCA==
X-IronPort-AV: E=Sophos;i="6.14,277,1736784000"; 
   d="scan'208";a="63312068"
Received: from mail-mw2nam10lp2049.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.49])
  by ob1.hgst.iphmx.com with ESMTP; 26 Mar 2025 15:30:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=il9HS/rpK7h/gzHCH/+HX5HlR84IGzfJiB8NvRZFn8Pw44thvBjfSKZke1mJmORCD+ENJsC28fBguCF+CnQRdIlVMeqULpablXm+B499ErjgKsJ9KB5mYJCo0BauhEzLncg/mALaGHzD3fmFsALPidKTDLFW5AKbbRYFalAJXtmWr4d5ArIS+k71tPYSrCcyMqyJStAqI1OG7XOnZaFXdt5HbwrOTrnyOGe7K1W04Iqj4mHSSFY8Ac87zHLYWn9u0k0gl6K3EiAorR4OStkn2DO/OZI6Z2JTZq7vE/pyuAhOXGWz3GtkgIB4nZmqlSqNktqxM5itu4/WEIfkDIreqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wzzloNMkLrZ5oRB1q5WdllCtUbZ6R+qLMav/U92Qo1Y=;
 b=G400ceWQLYa43dva1V7WeV5WWyKIZGd26unGFgqGiHACArKaULnd1F37nX6H22CoGMYEiVQ10+uqd2MgKpWG6HZZk8rAPAnkj4SZ90W8siNgACFcSBaFcTeRvbvhAfOiwVScNsHTKRF21QP15RijaDOSPDFRXIzv6bWRSvh/YmQd495BxEggSQaq0FijXS3cvNpb9xNRaO5Pqs3mlHiE1NKpd/3o5Lu8y30bZABbbm1Od6oUc2PAspl4p9hP+kPIun8h0p0TfBNYBirNZ00e3JEGbljC5gp5JvwbElvnJCh3SbMMbcJfEwRGSWd1Oh1i1Rpb/6VYEUdsdKhfAy424Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by LV3PR16MB6210.namprd16.prod.outlook.com (2603:10b6:408:1da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 07:30:17 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%5]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 07:30:17 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Bean Huo <beanhuo@micron.com>,
	Keoseong Park <keosung.park@samsung.com>, Ziqi Chen
	<quic_ziqichen@quicinc.com>, Al Viro <viro@zeniv.linux.org.uk>, Gwendal
 Grignou <gwendal@chromium.org>, Eric Biggers <ebiggers@google.com>, open list
	<linux-kernel@vger.kernel.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>, "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Thread-Topic: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Thread-Index: AQHbmhAfUxUsnAjyAUq7uGmV7Mzy/bOEEBbAgABitICAAI4w0A==
Date: Wed, 26 Mar 2025 07:30:17 +0000
Message-ID:
 <SA2PR16MB4251343F5F595B101950F5E8F4A62@SA2PR16MB4251.namprd16.prod.outlook.com>
References:
 <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
In-Reply-To: <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|LV3PR16MB6210:EE_
x-ms-office365-filtering-correlation-id: bb0976b8-f332-4922-c387-08dd6c380e96
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|10070799003|366016|1800799024|376014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?L3NieXdKeEsvMkNCSnJWT0tteGlLSFEwYlFzYXQwQ1FIRk82VHFnRXVZSUZy?=
 =?utf-8?B?UDk4dktSeFExa0kxMkM3ZERxTnhoREJ1cllBSmJUakJMR1pzV0NndG5Bd0ln?=
 =?utf-8?B?NzVPNWN3cEY3U1graFh1aVl5YmpuSFdMZmREdWE0YmxGZFQxWGMvZFh4S09V?=
 =?utf-8?B?R2dwNEhuenlNVWRuQ3diSkhBenhKRjN0UXd0dzFUY3RxaDlDUEJZZGJCS0NH?=
 =?utf-8?B?VzNzMlV0OVFuTUJ3enh3clE2UEJtSEVycy85TmRIU0Z6R0lRUzdENnJTV2t4?=
 =?utf-8?B?WnZTTVArVi9XVG9GWjdBdlNRdDJQb2dhNWw1ZE9UMzhqN0FqQjlZbHlNWmhO?=
 =?utf-8?B?OTYyelV1dFpWZkpDZ0xkL3FtWnVKbWhyTWwrRlZDQkhRL3FnZTNXVFhvQmNO?=
 =?utf-8?B?OTUzc2RMMzliTW41VlF0ZERGcVNZVllsY2VFUWsyak5BdjBiM25aQ2ZCUWpa?=
 =?utf-8?B?YklCUWRnU1pnVk9wTkQvZmRFZ29ENFp3RjlFSmFGbkRYRG0rb2M3L0xBb3Q1?=
 =?utf-8?B?SmoyTyt5QXA5YWVSdUFkcUpHWEdqT1luWW54aW5SR2hOblVzeHpwYU5QQ1pU?=
 =?utf-8?B?c3BOc2FxMEdVVEE4dUVvYkFVNGlhNFJXQWFvQ2ZWNVp1MFk0eUV5Z2psbkVx?=
 =?utf-8?B?Y0JyZVBYK090d001UFFMaWdBakl6eFU3LzRXcmU5WEdrUDZGS3cxYkRHKzg1?=
 =?utf-8?B?MmpDalA0VDVIQ21YaUNpTTJvUmlNWFc1RHU0UlNQc2JiWE9hYytYb0g2a3FX?=
 =?utf-8?B?Zm5CQklvS0hWWTdqZmNzeGhiRDR5VVF2eFNMY1gzSkw1cStSV0J6ejdIV1V1?=
 =?utf-8?B?c04ycDhXZ1J6RVdTZkMzZG5od0dEVWJ3QmM1UTgzSTd5TFdhSHZYeGZhWHdC?=
 =?utf-8?B?VU1tOXZDNk5jUEtyZHRsWHpmNnJQZXRnNzFLTHQybkdkY1hSSTE3Q3lBUklm?=
 =?utf-8?B?MExQZkMxYlJUVFFQYk15aUd1M0t3MXNQQ3Y1ZWxUWmg3RXg5MEFhR3BHN1lL?=
 =?utf-8?B?LzAzejhMSk1lU3A4bUFLNlI3Lzh5SG4vQ0RuaW9RTUdLZU9xcXVYMlVhL2l1?=
 =?utf-8?B?ZjBvYVZJY1VzSmFPSkVXWjl1OEVWM241ZlJQeFZzbzBNSmV1VGYyMXRwWnRv?=
 =?utf-8?B?b0ZFZHp0aCtFZnNCbDlzYVlnWlVRQzAxVkpNQmt0cFYwYUhhRmRIYnplTTJU?=
 =?utf-8?B?OFUzWk1rMTY2Yi9ucEloYVhhTDZQRnBMRlN4cVNXTUx6ajBxQnhMU3RMNG5I?=
 =?utf-8?B?clYvS2k5VVhqeGdIbS9iWXdodXpBVkxYT20rWkVrbnlDWUV0WXdRcnVXVWs3?=
 =?utf-8?B?SVFmSVVQODFCMDV2UVVYTGhyZ2gyb2xSTnhlNHE4TjRGOUk3K3VCZFREdGVs?=
 =?utf-8?B?bGdvMjdvSkJScXZPOUtWMkVFSzlSM2R2eEFkc3BwNzRNbGMvS01oN3J1cjZ4?=
 =?utf-8?B?bGR6eXFiSStrejdLRmY4SzhsSE9hdFVucWtYdXlnd29CR2ptWkNLRlBrYWZn?=
 =?utf-8?B?VzdEc1JUQ25CSnRLSFFKQkFUZVZNVXlzZ1AxOEZWREswQTNmeCthN3VHMy9u?=
 =?utf-8?B?Q01DUGk5UjZDZ0t6dGFKWWZIVUdiWSsxNGNHMFdaWUREby9tZXVLSnRiWG1E?=
 =?utf-8?B?Z2FWdmJ0QWZvYXlZRFpSYlBJczluTWg0cld1YVRjSEd4MFEzUmR0Y05hMXlM?=
 =?utf-8?B?ekxvdVFIMm5pYXc2L0JrbG9Fem9JdXhQZ3pKbTFjQkhRZDZBeDkwODlIZlps?=
 =?utf-8?B?YzlwMzBNTXNKZXIySXZCb2hZVUVxQmthRE10VnBEcDhtcnNacTlCdzNtRUll?=
 =?utf-8?B?ellGcm94cGFGdXlFdk01dE5icFhWUkw5WGwyeHZUUHVvSE5QRnRqTVpyTVIw?=
 =?utf-8?B?WERFeERRdWYwbzQ1SUNPOVM5YzlsOUwzZHlKWHdLWFNoUDR6aFZjNCs1Ujhn?=
 =?utf-8?B?b0Rtc2xRZWM2SldvTDBDUmJ4MHFRN2o3SWY1TEJkNWV1TnlNdXZUTmEvNWVz?=
 =?utf-8?B?dEsrUjRMODFRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(366016)(1800799024)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TEp2RnRTK2ZkKzdrMlFKUUtCU1Jpclp0NmxyaER5bzJBN3hFZ0RjcURlQzR1?=
 =?utf-8?B?ZlBlb3VxRXM4RVJGM1R0SWtPalZNZVEwMDFBNUdvUjJxMngrL3Z2U2txM3RS?=
 =?utf-8?B?VGJUS25xUE5IYzY3UWwwcXVqVFZNdTAzN05qSER3QnFCSXVTdXJpZGZ3bllU?=
 =?utf-8?B?NnRrWUNZSlpkN3VYK1gxbnp5dnJzTHFubTkzalkzbW5PUlBqYUFheEFFOTlv?=
 =?utf-8?B?M2QvQ0lsWVh5WUEzRElZQTFyS2I5bUVERGNyV20zKytWVFk3SWJzdXd0dDFU?=
 =?utf-8?B?ZUhCem9KNHBscDZQay9HdE84SU9UTzB5NDRmZHRwRlQwY3gwK3p0bEZNM3Nh?=
 =?utf-8?B?UmNJajRVU2N1dnVoOEREeTJMV0RkU013NWwxNzRueW4xcVByRklpNVZjNFVk?=
 =?utf-8?B?aGtiSEE4Tm92ZzBueXJXcEIrYm93RWtlN2tUSlhDeldENGJyMWsyaEdITlBs?=
 =?utf-8?B?UitWVk56SGxleGdsOEVvWXRSRzhnTUNydXNLcE1LL2o2WE5ZejM0TEo2bWdM?=
 =?utf-8?B?NEFEdVFCSHJocHo2M005cjA2SGRNNkZBV3l0Vyt3SmFDOFpGaXY3YTlNd2xG?=
 =?utf-8?B?Y2NHTTVQY1Y1WmJTNk9KUDJvbmhOc2RLQmxpcGd0aHcwQlRCY1RjSTJZcitF?=
 =?utf-8?B?ZVhqRXNRY2dNeDRwOC9PZ2JsQ0dBYnBHNitMWXRCQjQvU3FnZUQ2djZMNkp2?=
 =?utf-8?B?NmZDK09ZK0VxRlRORzRyTUgzeTNRZGdWNnBZMWU1cEw5M216UTR1Q1o4ejlF?=
 =?utf-8?B?M0dkOTJITTBJRlBERU5HTnh4bEt2U09lNkI5MFZ1Ty9Fb2NOc1VCbGgyQzE1?=
 =?utf-8?B?dEFyZG01Y0Evc1lPN3l4RVBGelF2WnJESU50aXV0UlJCNk1pMEk2WFo2TnBp?=
 =?utf-8?B?ekJhR3gxajNFM21Ldlp1VzlGNGVuc3pWdGNwZmJER0l5aVI2MkNUV05NY1M0?=
 =?utf-8?B?T1RTWkFET1c5a1dscks1SHQwOTV4R1JKWmV3a0twcng2eVQzaytpbnA4VzJo?=
 =?utf-8?B?M21UL0NXV2RPbGExUlRXL1l3eEtQWW1VeUFhOTVqejRDUmlRUDVpbUZ5MktF?=
 =?utf-8?B?MkcremVlUGNNZzlySEMwMVRoL3pIbUZKb0J1VFpmdm5nMGdxTFF4WHJTZDFp?=
 =?utf-8?B?aFpkOUdNRDlFK1NyMXZYR0tQWWpkUWE5b2xvbHcwbVpyclBqUW1TQmhuL0JK?=
 =?utf-8?B?SWZqK3dSL0J6K0hIWkZLY3B4WEZvaG16bDlWWU9qdGFKZWpzV01ZT3lnU0Jm?=
 =?utf-8?B?K0Z3aUJ5akZtekpWRi96QU5mOStrRjZ1cG4zMEZOL1BHT3N5Ri9iY04xbTZs?=
 =?utf-8?B?amdrZHkwRHRzSWRRNktOU2VGeitkVm5wLzVuYTVPV2RXbzNtZEFTWVhJS3RQ?=
 =?utf-8?B?TG1sZFdtMmJZd1dEM05zZnZtRktabkZ4dVVYYnhEM3k2MnR1ZXUyMXh6b1pK?=
 =?utf-8?B?K2xubitaVVY2OUdyUkRrUnh6SHlja0Z1bGRMbHVVbW9KbHcwUjkwZlJUU0tQ?=
 =?utf-8?B?K2o2TDQwczRhY0gweU95UXp1d2RNWGdUYlh1QjVGR3hlNHJtdkxNMzk5WUdC?=
 =?utf-8?B?NHU0STJ4OWNRM2g0b1lsY3kybDVTMkpIaFYwYUd1cHRnR2hEdktpRFQyRGpD?=
 =?utf-8?B?SXhobkZ5Q1EzWU0wSWJtTFFmelZPczlaVWppTm1CVHl6eno4dTlmR0RZVlFP?=
 =?utf-8?B?OTltWmpXSER0b1FxZHExQUFNanBrT0ZQRU1Ndnh2Y09WY1lrMERvVC9rdWUy?=
 =?utf-8?B?YTRnUEt5V0VHSXdZTkRnNC9HdnZoOUlMd1NEMURsR01MNUJ6TFdWTjZYNTIw?=
 =?utf-8?B?czdvSml3blZEbjBzenpvNTV2dDZFTTM4WElyMTdySytqWU85VEVHZG1XejFo?=
 =?utf-8?B?MW1GUTBlNnptaGd6L0FDNlNGODdvSUY1TEdDcU1ZeVUrN3JpRENNRWtkWjhX?=
 =?utf-8?B?TkcwUU1yWUNGVnpHeS9EVGFUQXhSRUsvd0VwMzc2VUN4L21IMnpiK25xNU0z?=
 =?utf-8?B?SnJUeDJvNk1reHFOSlJXL0NIbk84anliK2N6bW8ySHdGT1JRY0F0K3luV295?=
 =?utf-8?B?ckdTaEd4VVgzWUFVakVTVTljckFZcVJYeEdhaTRvRDZXTjY0aGZNUWpwYVhx?=
 =?utf-8?B?OWJBV2w1ODNibmxlUnE5RmtxTGUrcnhDdU8zM3d6a3d4amFjQnBsVUNPdmYx?=
 =?utf-8?B?TFVKTE1NSU9RV251THZMQVhJMmJONFdtTk1qcEM1QWZleUs2c0pDVVc1Zmhr?=
 =?utf-8?B?c0lQRTF2VDVnWlJReEoweEcvL3Z3PT0=?=
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
	MZp+9uz65tV+E35Ju+e+K6efI7A0GYcULRglgRq7K9zc86aUA14tyUsoftVROFKJPtVMzZreBfoeplBTywmtzNMwZ7N8FaV9Ej8m5JFFE8f1oWgVLWLwLu9DM8oJhSY49Mw2GyI++1UfJKM/5tLb5Jq4uHJ+dXCM2Q87eSpiN3szxP3fmOdjJx3wbG3kKKZaaX2BJ47s1BUVadrLfUzqU9qtt+yi7+4wj/jQG94xx9YmBn1EEO2ytCl2NvSxwzQlUqQCA0fmPxngNZvn+NJqDG2GEvM9Ozcjn/w4UkARc/5dpfGwysh24ShZf0UtomKp5oHo70XQY8dMrKM9fQXCYSACyAbehEhz14Si83XXfdfo1LlJSDuW9vDmBODfmJNcGo/X2ACWKquPkR4Ieakmrvk4pcjSkF/M/QWR+uJEbOiH9l1mnS3uoIcboXn0FKdqcz61p4pSz2PGUblXYasByWyDDijUH77qoY02x5EaDhs3/h45mMRwNmoMddkVR7Nq0EAgxoz/DKnPt8a4uNkxwq4OTam/f85OXJuG8xZ4Db9E7OJzgkOSMdPvPfEDcASOTSoOGtiSs80rUhgtFctN2umB4atmExMYbQ4GyFBFuRpzMKzNpotxgS+Q3CH0q3Q0V1IQd3eR1Kav3I7rJT/7Sw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0976b8-f332-4922-c387-08dd6c380e96
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2025 07:30:17.4970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fg3Io8jpRnKUmnyUAXBIEHBXj2WMR3sPNPpVJcQfIn4pBannNZiynqXUoCzZypoZFtEVzBjGJC+u2ofS9opLZY16ovoNXIvpvCdto4NEtbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR16MB6210

PiBIaSBBcnRodXIsDQo+IFRoaXMgaXMgbm90IGEgZmxhZ3MgYXR0cmlidXRlLiBUaGlzIGlzIGZv
ciBhIFF1ZXJ5IFJlYWQgNjQtYml0IEF0dHJpYnV0ZSBkYXRhLiBJbg0KPiB0aGUgZXhpc3Rpbmcg
Y29kZSwgd2UgZG8gbm90IGhhdmUgYSByZWFkIDY0LWJpdCBhdHRyaWJ1dGUsIHNvIGFkZGluZyB0
aGlzIG5ldw0KPiBjb2RlIHdvdWxkIGFsc28gYWxsb3cgZnV0dXJlIHJlLXVzZS4NCj4gDQo+IFRo
ZSBuZXcgInN0cnVjdCB1dHBfdXBpdV9xdWVyeV9yZXNwb25zZV92NF8wIiB3b3VsZCBpbXByb3Zl
IHJlYWRhYmlsaXR5DQo+IGJlY2F1c2UgaXQgaXMgZm9ybWF0dGVkIGV4YWN0bHkgYXMgaG93IHRo
ZSBqZWRlYyBzdGFuZGFyZCBkZWZpbmVzIGZvciBBdHRyaWJ1dGUNCj4gUmVhZC4gV2Ugd29uJ3Qg
bmVlZCB0byB1c2UgdHlwZSBjYXN0IHRvIGdldCB0aGUgNjQtYml0IHZhbHVlLg0KPiBUaGVyZSB3
b3VsZCBiZSBubyBpc3N1ZSB3aXRoIGVmZmljaWVuY3kgYmVjYXVzZSB0aGUgc2FtZSBtYWNoaW5l
IGNvZGUNCj4gd291bGQgYmUgZ2VuZXJhdGVkLg0KPiANCj4gVGhlIGV4aXN0aW5nICJzdHJ1Y3Qg
dXRwX3VwaXVfcXVlcnlfdjRfMCIgcHJvYmFibHkgaGFzIGEgYnVnIGluIGl0LiBJdCBkb2VzDQo+
IG5vdCB1c2UgdGhlICBfX2F0dHJpYnV0ZV9fKChfX3BhY2tlZF9fKSkgYXR0cmlidXRlLiBUaGUg
Y29tcGlsZXIgaXMgZnJlZSB0byBhZGQNCj4gcGFkZGluZyBpbiB0aGlzIHN0cnVjdHVyZSwgcmVz
dWx0aW5nIGluIHRoZSByZWFkIGF0dHJpYnV0ZSB2YWx1ZSBiZWluZyBpbmNvcnJlY3QuIEkNCj4g
cGxhbiB0byBwcm92aWRlIGEgc2VwYXJhdGUgcGF0Y2ggdG8gZml4IHRoaXMgaXNzdWUuDQoNCkhp
IEJhbyANCg0KVXBpdV9xdWVyeSBjYW4gYmUgdXNlZCBmb3IgYWxsIGRldmljZSBtYW5hZ2VtZW50
IGNvbW1hbmQgKGRlc2NyaXB0aW9ucywgYXR0cmlidXRlcywgZmxhZ3MpDQpTZWUgc2VjdGlvbiAx
MC43LjkgVVBJVSBRVUVSWSBSRVNQT05TRSBpbiB0aGUgVUZTIDQuMSBzcGVjaWZpY2F0aW9uLg0K
SWYgInN0cnVjdCB1dHBfdXBpdV9xdWVyeSIgd2FzIHByb3Blcmx5IGRlZmluZWQsIGFjY29yZGlu
ZyB0byB0aGUgVUZTIHNwZWNpZmljYXRpb24gIChieSBPU0YncyksDQp3ZSB3b3VsZCBub3QgbmVl
ZCB0byBhZGQgYWRkaXRpb25hbCAic3RydWN0IHV0cF91cGl1X3F1ZXJ5X3Y0XzAiIHN0cnVjdHVy
ZXMuDQpJZiB5b3UgdGhpbmsgdGhlIHN0cnVjdHVyZSBzaG91bGQgYmUgcGFja2FnZWQsIHlvdSBj
YW4gZml4ICJzdHJ1Y3QgdXRwX3VwaXVfcXVlcnkiIGFuZCANCiJzdHJ1Y3QgdXRwX3VwaXVfcXVl
cnlfdjRfMCIuDQoNClJlZ2FyZHMNCkFydGh1cg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+IEZyb206IEJhbyBELiBOZ3V5ZW4gPHF1aWNfbmd1eWVuYkBxdWljaW5jLmNvbT4NCj4g
U2VudDogV2VkbmVzZGF5LCBNYXJjaCAyNiwgMjAyNSAxMjoxNiBBTQ0KPiBUbzogQXJ0aHVyIFNp
bWNoYWV2IDxBcnRodXIuU2ltY2hhZXZAc2FuZGlzay5jb20+Ow0KPiBxdWljX2NhbmdAcXVpY2lu
Yy5jb207IHF1aWNfbml0aXJhd2FAcXVpY2luYy5jb207IGJ2YW5hc3NjaGVAYWNtLm9yZzsNCj4g
YXZyaS5hbHRtYW5Ad2RjLmNvbTsgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb207DQo+IG1hbml2YW5u
YW4uc2FkaGFzaXZhbUBsaW5hcm8ub3JnOyBtaW53b28uaW1Ac2Ftc3VuZy5jb207DQo+IGFkcmlh
bi5odW50ZXJAaW50ZWwuY29tOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbQ0KPiBDYzogbGlu
dXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IEFsaW0gQWtodGFyIDxhbGltLmFraHRhckBzYW1zdW5n
LmNvbT47DQo+IEphbWVzIEUuSi4gQm90dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFy
dG5lcnNoaXAuY29tPjsgTWF0dGhpYXMNCj4gQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNv
bT47IEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vDQo+IDxhbmdlbG9naW9hY2NoaW5vLmRlbHJl
Z25vQGNvbGxhYm9yYS5jb20+OyBCZWFuIEh1bw0KPiA8YmVhbmh1b0BtaWNyb24uY29tPjsgS2Vv
c2VvbmcgUGFyayA8a2Vvc3VuZy5wYXJrQHNhbXN1bmcuY29tPjsNCj4gWmlxaSBDaGVuIDxxdWlj
X3ppcWljaGVuQHF1aWNpbmMuY29tPjsgQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+
Ow0KPiBHd2VuZGFsIEdyaWdub3UgPGd3ZW5kYWxAY2hyb21pdW0ub3JnPjsgRXJpYyBCaWdnZXJz
DQo+IDxlYmlnZ2Vyc0Bnb29nbGUuY29tPjsgb3BlbiBsaXN0IDxsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnPjsgbW9kZXJhdGVkDQo+IGxpc3Q6QVJNL01lZGlhdGVrIFNvQyBzdXBwb3J0Oktl
eXdvcmQ6bWVkaWF0ZWsgPGxpbnV4LWFybS0NCj4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+
OyBtb2RlcmF0ZWQgbGlzdDpBUk0vTWVkaWF0ZWsgU29DDQo+IHN1cHBvcnQ6S2V5d29yZDptZWRp
YXRlayA8bGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFkZWFkLm9yZz4NCj4gU3ViamVjdDogUmU6
IFtQQVRDSCB2NCAxLzFdIHNjc2k6IHVmczogY29yZTogYWRkIGRldmljZSBsZXZlbCBleGNlcHRp
b24gc3VwcG9ydA0KPiANCj4gT24gMy8yNS8yMDI1IDk6MzMgQU0sIEFydGh1ciBTaW1jaGFldiB3
cm90ZToNCj4gPiBIaSBCYW8NCj4gPg0KPiA+IEkgdGhpbmsgYWRkaW5nICJzdHJ1Y3QgdXRwX3Vw
aXVfcXVlcnlfcmVzcG9uc2VfdjRfMCIgaXMgcmVkdW5kYW50IGFuZCBub3QNCj4gY29ycmVjdCBm
b3IgZmxhZ3MgdXBpdSByZXNwb25zZSAuDQo+ID4gWW91IGNhbiB1c2UgInN0cnVjdCB1dHBfdXBp
dV9xdWVyeV92NF8wIg0KPiA+DQo+IEhpIEFydGh1ciwNCj4gVGhpcyBpcyBub3QgYSBmbGFncyBh
dHRyaWJ1dGUuIFRoaXMgaXMgZm9yIGEgUXVlcnkgUmVhZCA2NC1iaXQgQXR0cmlidXRlIGRhdGEu
IEluDQo+IHRoZSBleGlzdGluZyBjb2RlLCB3ZSBkbyBub3QgaGF2ZSBhIHJlYWQgNjQtYml0IGF0
dHJpYnV0ZSwgc28gYWRkaW5nIHRoaXMgbmV3DQo+IGNvZGUgd291bGQgYWxzbyBhbGxvdyBmdXR1
cmUgcmUtdXNlLg0KPiANCj4gVGhlIG5ldyAic3RydWN0IHV0cF91cGl1X3F1ZXJ5X3Jlc3BvbnNl
X3Y0XzAiIHdvdWxkIGltcHJvdmUgcmVhZGFiaWxpdHkNCj4gYmVjYXVzZSBpdCBpcyBmb3JtYXR0
ZWQgZXhhY3RseSBhcyBob3cgdGhlIGplZGVjIHN0YW5kYXJkIGRlZmluZXMgZm9yIEF0dHJpYnV0
ZQ0KPiBSZWFkLiBXZSB3b24ndCBuZWVkIHRvIHVzZSB0eXBlIGNhc3QgdG8gZ2V0IHRoZSA2NC1i
aXQgdmFsdWUuDQo+IFRoZXJlIHdvdWxkIGJlIG5vIGlzc3VlIHdpdGggZWZmaWNpZW5jeSBiZWNh
dXNlIHRoZSBzYW1lIG1hY2hpbmUgY29kZQ0KPiB3b3VsZCBiZSBnZW5lcmF0ZWQuDQo+IA0KPiBU
aGUgZXhpc3RpbmcgInN0cnVjdCB1dHBfdXBpdV9xdWVyeV92NF8wIiBwcm9iYWJseSBoYXMgYSBi
dWcgaW4gaXQuIEl0IGRvZXMNCj4gbm90IHVzZSB0aGUgIF9fYXR0cmlidXRlX18oKF9fcGFja2Vk
X18pKSBhdHRyaWJ1dGUuIFRoZSBjb21waWxlciBpcyBmcmVlIHRvIGFkZA0KPiBwYWRkaW5nIGlu
IHRoaXMgc3RydWN0dXJlLCByZXN1bHRpbmcgaW4gdGhlIHJlYWQgYXR0cmlidXRlIHZhbHVlIGJl
aW5nIGluY29ycmVjdC4gSQ0KPiBwbGFuIHRvIHByb3ZpZGUgYSBzZXBhcmF0ZSBwYXRjaCB0byBm
aXggdGhpcyBpc3N1ZS4NCj4gDQo+IFRoYW5rcywgQmFvDQo=
