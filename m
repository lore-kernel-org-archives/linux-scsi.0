Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A505661;
	Wed, 18 Sep 2024 06:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726639412; cv=fail; b=qcBJtKRqh2ILvXV6xVLarVptbgcqtLokkl6NwR83qauWWxXkixxlG5a8to+4nHBHTVyne2hV1+TWADwnu3VOwH5X1n2aRVerzC78fYQ4B8XA4Ub6MisY77Bc6aXDJXq1vbed3+7LzmRft2B+DStXdoBbvC7J5pXlS+Q61wL0noY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726639412; c=relaxed/simple;
	bh=BkbOdkT8iTCmzgqoYO4pFCD7xcijniXgWzxJTUG6+pY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ela869BksUzwjOlf0memkLp6gi4alc1AgkKbyUHGOc6TjlczPADGn6qIgfvi/L3g35OEtrLr2DYkzhy60dePbvRee9g+u9nyWl2f59eUxkL5Yz5f8437k5mdiUk9L/6w99GQFuTtVkw+kBeNxJ1t889moxR/Vf38L0auPyeuTl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gj07YnhK; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=XuqofCQ3; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gj07YnhK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="XuqofCQ3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726639410; x=1758175410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BkbOdkT8iTCmzgqoYO4pFCD7xcijniXgWzxJTUG6+pY=;
  b=gj07YnhKAdFS/o3V+3bgs1d3MuByC+eDRfez1CrSgaNB3jNF60hW9QsV
   BNeCj8QXIjGieCuS2c6htSikCjgfQ/9aGbQyZ+IoAHerf63wIafPLIZpQ
   dK/7K5xZeRpRcx/tO5DExsIqxEg+1QHp8QPws/EoVRkgFD9yGiaiEhZ+e
   EP+DWX+K4a6bGrAjMNNWDJAdHSM4Z4pqoA4iY5kmtJhTO8rd0SGnxEij8
   umk/0rkhcax0vrTZdcJct4tamlCMXtApuBlP82BgalGGu/rBjQf+FChYU
   VhaacCzSEBYYAx4rQ74VqwFTwC20axg6Otm+VDTZMYlkhAe89Qv/YMEco
   w==;
X-CSE-ConnectionGUID: 4485btulTCKYM6p/sHW5VQ==
X-CSE-MsgGUID: aR1nGcg+StaHmR5acSpoCA==
X-IronPort-AV: E=Sophos;i="6.10,235,1719849600"; 
   d="scan'208";a="27798595"
Received: from mail-eastusazlp17010000.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.0])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2024 14:03:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+slvGT95olwJB+gsjZdRNXMhgT2vNztbOrRejC3HZ2kCOGtv7LlfuZOuMortTspNLOnV10EvIPT3XTg/Hf1ekUpqY6KCkjzLJGRv8WRq7REno0f1yzb7G5QEwyYZC8SnPKpMFU3NvdLGG/r4MagjGjJ0s/sB19N2z2vrIrauQ/VnBXO+TgQ/nB1e+/+y6QVNMO4tSY30zAd7tY6UyzgS2B1f+raF5q3Xb+Od93NDXUm+26HGLyg2jxefIT3vlIONuLPt2W/c/saxp3EvitSrwNm1KxNLT2LpbuEdOgjQufWq68AE6ufiWRf6rz5Rr4ldtPR5/uG+PfO4lnIZ7KFXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkbOdkT8iTCmzgqoYO4pFCD7xcijniXgWzxJTUG6+pY=;
 b=hXk1Fr7TYADISCrQFC2kna4yeYjLMUlqOL3V7ezGZ2RL+btilPPjG7le++rTYoHb2+aQpwMOXHRkKtov8wH2XxuNFlvy/SgfzuZq+NqoKZbKOAHCSniOZvOtTWmQUQ5hTpJ3tHypd451bD8AggEoT1DtRs2eZptHEZCNMRTgCAoUGfJFN1Nwo5Y6pnRvk2UAb4IMle7YbYPGRM4F7xtdifOyHEVrkFzXpJIt4xO7iJRElAFoKKyqtNNgGbMnKq/VtRQcvaXNxXNkqqMxPVzSwA1maayTos0u9DNohvqx69bjQh5M7ycbcnNUPH3VqzoKmXSNItiXvmggMopX/eA6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkbOdkT8iTCmzgqoYO4pFCD7xcijniXgWzxJTUG6+pY=;
 b=XuqofCQ31fzO3dD9qtYSxn+BiT3qWvg+uTLQAXXUq5sadJpZiXP6TrvDai8K/8QvX9NpC8EriVrqMIoPZ/sgIsTE21dUOqZG3Sy3Dksie5nmQiX4DlnSeMKwY8P/VFgp+kCJeSDTTfaGjPOu19nDDiNSJTayVvGs5OXisHUZV4I=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB7125.namprd04.prod.outlook.com (2603:10b6:610:a3::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.16; Wed, 18 Sep 2024 06:03:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7962.022; Wed, 18 Sep 2024
 06:03:18 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Topic: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Index: AQHbB0P1xNgr2xhkc0aS4aiTVb0xxbJa/qOAgACMpLCAAIKegIAA/pQA
Date: Wed, 18 Sep 2024 06:03:18 +0000
Message-ID:
 <DM6PR04MB6575F0F368FD49B191CAD7D4FC622@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240915074842.4111336-1-avri.altman@wdc.com>
 <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
 <DM6PR04MB657549C63703AECEA2169CC4FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b7a05da9-7a80-42f7-bf95-379d78f3296b@acm.org>
In-Reply-To: <b7a05da9-7a80-42f7-bf95-379d78f3296b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB7125:EE_
x-ms-office365-filtering-correlation-id: dc0dfdf2-6b3c-4535-aa7b-08dcd7a797c8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?V1BJQnVYNDlKSnpTOXEvN3d5K3hMRjdZemtMRjkvVVFCSnUrZ3dVeXFxRGp5?=
 =?utf-8?B?WlpRV3Z1eWNmU3krOFdqZ3YzZlUweklZZ0w0UjFvTXdIOEhqc3JFTFhKYy9Q?=
 =?utf-8?B?RWpZZE5WWDNZYTJiZjNzL0FHZHdYeVo0Z0tPVmdkZjNvNlFEUEVxRjZnS0R0?=
 =?utf-8?B?aWhZRlQzQjI3WHI1WEhSVnI4RU1KVTAremFQOUxwUmNzRnhRMkxtbEcwRFNy?=
 =?utf-8?B?YWdRclFiR0Q1YmpLU3ZLb2xoOXo5WGxoRkV1eGZvQ0tuWlVmSGlZNHRpOElH?=
 =?utf-8?B?WTN3UVVxQWRSUTh2NVdkL0V0RWJFYjdwWTkrR0wrbmRQTUkzVHhZVzNCckRu?=
 =?utf-8?B?bTEyaVVvQzhzbHRUanJLNWJCcG1YZFhDQnFiOFZiV0JEaXpsOXp1b2dWVGRu?=
 =?utf-8?B?eDRnWkYzSXZlL1F6QkpwV0NhYzFlejFERlIreE5xL3ZVZnhDQk1DSThvazNu?=
 =?utf-8?B?eEJITGR5RU9RYzhJaEcwTDJaUXRlZkYrNW1EOWZ6RDNZSnZTY0Z3UCtrc2dt?=
 =?utf-8?B?bUpraWpnR1FFbTdSVDdxYWExTnFjUms1dGpmdTF6WXFNUGE5NGRKZkladGhK?=
 =?utf-8?B?a0RyeHBiSEc4SSt4Y0NKb3JGRjc1VVVxamdkQ3UrZ1Bma0NKZU91bHJSd1A4?=
 =?utf-8?B?VVZqa2VwR0VsNW5SVU55L3RKSVRFVUIyd0JnUUpiWkZKT3g4cDU2VzJCclRC?=
 =?utf-8?B?VmlsdkJoblJzMkZIQVhNeTRiMUJlTmNZYWVoOFdmSDI4SHVQU0s1L2E2dnRV?=
 =?utf-8?B?NkV4c2VWVW5TVGRwOWhCVnZBNWFIb1RVbW5MTGVsc3J3RVRyaFZyTU9pMjV6?=
 =?utf-8?B?R2NHYlEyMkViV2svbDJhUk5uZVBFd1BoNFNWaXJndnFPYnVWbURVenh1MlhS?=
 =?utf-8?B?VlhQL2tEQ1lNR1NkaVp4bGdrUHdyelVQWjhwa0VNS1hnKzdIb0dTNCtSMy9R?=
 =?utf-8?B?WmUyL29IMXg5MkJIcm5DeklvSFpPNmF6WW82UlUzZGkwWXdvbGhuQWgrVGVW?=
 =?utf-8?B?ZVVuVG1wVFpWaFNvd2Z2bDZISG1KOTNNTGxNejdrV1ZybTF3MTNjM0Z5Z0sz?=
 =?utf-8?B?d01PaTVoVWZhb1c1K1FWT2xoMVZxNDBYdHE0NDVDQzF3UWdGRnMycjloQmZO?=
 =?utf-8?B?eHErYi91QlN1bmpmYlBLNllheU1FcnEyd1FCNTdld3luU1ZIdTcxMTFNcGRN?=
 =?utf-8?B?TXphUU5DcWg3S2tkKzV4emlLdlIrVDdhVmpCTWY3aTczRG9lbGhOOVY2eU9F?=
 =?utf-8?B?OFZCUmRzZVJvTmcvNk9MbGdUbVpDNm9sZ3BqN1Qxam0zVkplZURCZlhsYkZP?=
 =?utf-8?B?ZXNTa1R4end6QjFvZ2puV0VTVzV3KytUL1oycnFEdGI4bWxod2NReUMwVnBz?=
 =?utf-8?B?SUNyM2hZM1dYVkZ4bDRXc0syaFFITkxKcmRJdzZJdDN2WDRra1FYblhGclMr?=
 =?utf-8?B?SHFland5TTl1ZXJEOVhzWHJDS0IvL1pYZWIrc3d0YmJhc2NqMllXM0FkcUJB?=
 =?utf-8?B?aDlJeXlwZGRhQWRNY1h6bW1DU3FEd3BNOXltVWtIcWx4b3dvbThRbUJHK1I1?=
 =?utf-8?B?by9oUS8vUUZkMHZ0VVV4dlRkYjdzTFpMSzF5WTlzM0xIQXBtTFpuRUxLR2pF?=
 =?utf-8?B?SzVOelQ5TXR4aW85aFFTWUZqNmlWRFhoTnVpSi9HUkdXcDNTdHZjQ0R6OHNq?=
 =?utf-8?B?VmJWYW1pSUFqWmNLb3dQMHFPaENBd216elNIRCt5MXNUVW5LN0tSendxRWp5?=
 =?utf-8?B?dnJqaXp4RVEveCtaNjRCSVFSVXd6anl0Sk9XQkdzVnE4UHlLM2lrL2FiT203?=
 =?utf-8?B?cjg3MzZHSGsyTXcxOHdqV2x0bXdRdWoyd2hxYkE2RlpZTWFkdkhpZ3JYaDVX?=
 =?utf-8?B?blpNNWZFSC9NdGMvaS9YV3MxckhVYjVhYld3TkRRaDQ5Y2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V3ZiNUJ1NGJYVUJXVGJPZFl0N3JXM0JENUdNOHlCUURodmxVd05mTXlweUM4?=
 =?utf-8?B?cytEVDh5MEI3eVhIRE5aRndWa1MwWFRsUHkzbW4zeEhkWmtYaUkvQXlrUW1n?=
 =?utf-8?B?Ykw4UUlaUTVGMnROMHErMityTmpDcWJFZXppMFNSZDR3UXR4M1hiZVBVTXpz?=
 =?utf-8?B?TG9qS1cwY0xOaGdkbHpyNVNKTXhSQWVqYWFDUmFPSnAzZTBPcTVjcU9nbHNu?=
 =?utf-8?B?RHMrbXFqR04yOFo2NlVNUStDZ0VlNnBCOHNnT25jcXpoQnZCRTRUVmtwaTlp?=
 =?utf-8?B?RGZjRXQ2eUQ5aWlsbm9qRCtDZy9QK3pvNVFFN2JpK1V5UjZ6RzRqN1BxZlBn?=
 =?utf-8?B?eU05SDVPUlJHRGNzUkZOK0JLa1R4dk5nY2dLZWRYMkZyNVJkaHVndEY1OGNJ?=
 =?utf-8?B?WmFDTEJjVHgwYmtjaWw2WDdCSUpmVEYyM0c4Q1lxUExvcFRpd0h5VlJxQkxh?=
 =?utf-8?B?eGswLzF4ODljQnpWZTY5MGdnSFdIbVhMUUUvekRIejRoM2tpN2NUTkEzZEw4?=
 =?utf-8?B?a2xVa0JMSTFzMGsyeTREUUFlUWFmY04zTHcvaVFkQ2IzMjlndWFLL1pnMEph?=
 =?utf-8?B?NXMycmZYR2xnWXJRVStOeE8wSml2MDAvQ25ESnZBSjV3N2tPSGVtaW5LZVFl?=
 =?utf-8?B?SHg4QlJCTytpeGJVdHg5M0I1VzBpN2dhOW1FQWxHVkxOZ3JLMUxmVHN5Zkpx?=
 =?utf-8?B?R3ZkSmtUVTRiMVIxMXVZeFgxTjhiZWRGVHAyK0RNZHlqMzNvc09HbzRsRVJu?=
 =?utf-8?B?YXdpM0VWRE5LZi9kSlhtK3JXMlA2SGdlODNsTEQ5dktQYS80bFNHMVk1dmZr?=
 =?utf-8?B?c3BoY3FvTmpmN1J5K3FiTG0xZUlXbFQydGRXSUdzNVVEK2VKMXdVTGdDTjVC?=
 =?utf-8?B?S1A5Z0J0YmdJUk5vRmhIMElmTXhjdUh2YndsN0dNKzBXbXdDNGY5VVVJQVh5?=
 =?utf-8?B?VTFiZSt4c2p5WVVSSncwMlJxQzQ2ak41ZmpaTk1YUHk3NzRoRmpEMVBzbEM2?=
 =?utf-8?B?ZCtDNXdQaG0wWFlMYXFlRDZGbytYYzZQZDdUUDFjT3EvSmRYSnVPa1B0YUJq?=
 =?utf-8?B?M1pQTzIxVFlNTlYxZVpLck5UalE5RENINWJpRjh1cE56TmtBZ20rNkplRU1F?=
 =?utf-8?B?Q2RPa0hjRlcvb3lXRmRMd3FQT3pyU2NoZ1B0WmxPWVp0RXpmZ3lQTzFYOXZT?=
 =?utf-8?B?eXZ1bG5icXYvQUV2MU5KV2RIMzZ4YkdYQXpYbmk1UDlnOHI4cmUwU21BaUw3?=
 =?utf-8?B?RFl5UmE4NnlQVVhhZUUzeVl0emxRZTBpODgzZG96ay9ZZ3o0dkJ3czNrQzY1?=
 =?utf-8?B?TnllRCszOEtUNVlIT3BaV2FyVXpOUDdHUlEyMU10a2Z6bGljNXhKWUQvOWJT?=
 =?utf-8?B?cGRBUFZzYUREQnRIY3hLSUdEVUJhL3FoaWc2cFdxdXJEd3lsVjVGM29zZUpD?=
 =?utf-8?B?a1pGR1RTZFB0VmJXbDlKL09iQ1JoSy9Fc0ExRTNXSERHYlBtenNmVG12WDRa?=
 =?utf-8?B?TDdkOTdMM2JpODJCY080WDlCc2p0d2wxNUVHOG1UY0hYYkdkemhINUd2eFFI?=
 =?utf-8?B?MDhQRitKU0ZKRDVCODJxc2c3anF6NFllMi8yaUZhVm8vUDF6WkxScWVYbjR5?=
 =?utf-8?B?UTJVUFlTc0tKWlRtMisraU1GTTdlellGRk0wR0dXamE5QlEwMFdlSm8wTmhG?=
 =?utf-8?B?MXRTT0FpZDZFM3ZhdXFzY0ZwVzI0WithM3lrQXRkN3RqU3JtTkhNQXgxejJm?=
 =?utf-8?B?eWpjNlY0WkJha2VoMFIrYjNKSlZWQlEvUENLbjJ1OGVMZFBTbWhtOTdMZ0ds?=
 =?utf-8?B?TVhuc1NlSlB3NDBmZTJPdUVmSEJTZnJPblZvNnAvaThZcW4wVFNwK2lsYnow?=
 =?utf-8?B?bmVMTUR4aU50d1ozWW5LKytDV05aTzc3c1h6SmlwelZMN0lXL3VtSklTUVhP?=
 =?utf-8?B?WmJGcWNPcU1XRFdCQmlBcy9TU0tkaEw3eVc5bGlDS2R2V25hTXNuVFRJekM0?=
 =?utf-8?B?TzJDT2ZNRDFpWEMrUmxYWFhQczRJVmtJb1pPREFEcUtHa2FSaFJkVEJNUmU1?=
 =?utf-8?B?ejR4RXU1c3A5YktyS3FNUkZnZjFnZnBLR05qRzRFL1BYaUQyK05sZFpqK2xW?=
 =?utf-8?B?SGpmTG8vcnltbXJmYUdVa3lOOGtleGVvcnZ5MXlkQm5vcFE5UHliZ2J4MW1m?=
 =?utf-8?Q?0sOV6eP5L+Ql9eN0vLvlCmfOkAC737gdNemP+57Lhs+o?=
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
	/PfteK1RbKSe+7XAOKxISgrREoYUSiPPhZ261Rvt5LHrQUbQeszhVwEYLE4HEPX7+E6ZA6gdNULZMbWAMZRbwW1+lDID+RZgOzIHgCDxKS5bAC8LPM1EXM8VxP7MHXjT9gQmcCujK2tbRs2qgngepWDHXSw2h5n/qvB9DcksTb5r+pRGFD6gEAnOitCwMsbwjoWQV+vluYckKGS6OkMqmC95NSYk4rtloF3l5lAuS/e3VFuGz3Gwd9+5nbhjShYO/s4a9GSJXiYifH9BGWDk1po7+rWQeyWZQ02ZCwzqMA/aMXFlEvB+y694eprR6Y1Sl6TtfPRW1Elj9IG+denMH6ciJgQVGBYoN3KmPct1RJhd5LnYurP71n49RBOFvWc12r57JF0EvYf7qcKZ6tq7BeTHiWfxg833aoUOVMBdaYOPcs0ozFl7gO+yKa+a+P1X0r324TIWplV9uOx+8DbZ1yjYCztjVv9Hggsm5nLguYzYtEGJUVpxx3yRXF/6WN5Zu5bEl+HfyGGR8J677quLrbyTxvEsWT5SZ9J8XFvrePM2POslLDmGABKrMZAO21mktWSWjYRNu60OuHLMFgOOkZshR5qezrYXBS2GWxI9HsFAr4ERzkWFuqJkM3Y0zUnv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0dfdf2-6b3c-4535-aa7b-08dcd7a797c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2024 06:03:18.5649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1iq+y9PngCaS+d47JJB50yng8WGlaCAky47kil8MU7gad8dxZoTla73ePUv2VJgilmqfSnZU3/leM28mhmQ6jA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7125

PiBPbiA5LzE2LzI0IDExOjUyIFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBJcyB0aGUgYmVs
b3cgcHJvcG9zYWwgZXZpZGVudGx5IGJldHRlcj8gZS5nLiB3aXRoIHJlc3BlY3Qgb2YNCj4gPiBl
ZmZpY2llbmN5LCBzaW1wbGljaXR5LCByZWFkYWJpbGl0eSBldGMuPw0KPiANCj4gVGhlIGFwcHJv
YWNoIEkgcHJvcG9zZWQgaGFzIHR3byBhZHZhbnRhZ2VzOg0KPiAqIEFsbCBjb2RlIHRoYXQgaW5p
dGlhbGl6ZXMgKmxyYnAtPnVjZF9yZXFfcHRyIG9jY3VycyBpbiB0aGUgc2FtZSBmdW5jdGlvbi4g
SSB0aGluaw0KPiB0aGF0IGlzIGEgc2lnbmlmaWNhbnQgYWR2YW50YWdlIHdpdGggcmVnYXJkIHRv
IG1haW50YWluYWJpbGl0eS4NCj4gKiB1Y2RfcmVxX3B0ci0+aGVhZGVyIGlzIGluaXRpYWxpemVk
IG9uY2UgaW5zdGVhZCBvZiB0d2ljZS4gSGVuY2UgdGhlIGFwcHJvYWNoIEkNCj4gcHJvcG9zZWQg
aXMgbW9yZSBlZmZpY2llbnQuDQpTb3JyeSwgbm90IGJlaW5nIHN0dWJib3JuIG9yIGFueXRoaW5n
LCBJIG1pZ2h0IGJlIG1pcy1yZWFkaW5nIHlvdXIgcHJvcG9zYWwuDQoNCk15IHByb3Bvc2FsIGlz
IG1ha2luZyA0IGNoYW5nZXMsIGF0dGVuZGluZyB0aGUgNSB1cGl1IHR5cGVzOg0KIDEpIFplcm8g
cXVlcnkgdXBpdSBhbmQgbm9wIHVwaXUgaW4gdWZzaGNkX2NvbXBvc2VfZGV2bWFuX3VwaXUNCiAy
KSB6ZXJvIGNvbW1hbmQgdXBpdSBpbiB1ZnNoY2RfY29tcF9zY3NpX3VwaXUNCiAzKSB6ZXJvIHJh
dyBxdWVyeSB1cGl1IGluIHVmc2hjZF9pc3N1ZV9kZXZtYW5fdXBpdV9jbWQsIGFuZA0KIDQpIHpl
cm8gcnBtYiBleHRlbmRlZCBoZWFkZXIgKHJhdyBjb21tYW5kIHVwaXUpIGluIHVmc2hjZF9hZHZh
bmNlZF9ycG1iX3JlcV9oYW5kbGVyDQoNCllvdXIgcHJvcG9zYWwgaXMgbWFraW5nIDMgY2hhbmdl
czoNCiAtIHplcm8gcXVlcnkgdXBpdSBpbiB1ZnNoY2RfcHJlcGFyZV91dHBfcXVlcnlfcmVxX3Vw
aXUNCiAtIHplcm8gbm9wIHVwaXUgaW4gdWZzaGNkX3ByZXBhcmVfdXRwX25vcF91cGl1DQogLSB6
ZXJvIGNvbW1hbmQgdXBpdSBpbiB1ZnNoY2RfcHJlcGFyZV91dHBfc2NzaV9jbWRfdXBpdQ0KQW5k
IHlvdSBoYXZlbid0IHplcm8gdGhlIHJhdyBxdWVyeSB1cGl1IG5vciB0aGUgcnBtYiBleHRlbmRl
ZCBoZWFkZXIgLg0KDQpXaGF0IGFtIEkgbWlzc2luZz8NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4g
VGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
