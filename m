Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469A818FC7B;
	Thu,  6 Feb 2025 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738864138; cv=fail; b=qXkzUedsWvgQvCXXDFvzrO0Xe5iwUaDBfFqWP8pFIuBWflPbVxofjgRDUFsMhRp7LqNwDo+Dmzfm5eroTnhMYsUU4RBzRUNN9Ep2Og0gEwsdly4WtCTl2LRaPOGw+Od9ycwMXaPv70qs4WTIZJoSCcoGR6Jpy6q4Zldx8k8lDyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738864138; c=relaxed/simple;
	bh=JTGdpVu1EUyZ46fk9rFQCZnaNrltIu9bd/k4tdyOmc0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D/GcpGoQwRMyLodOcgpWpL8MQSwXxMbNMyAxvaLprSnFHLkJfR5k6BdHXN6REPxCvRjIKQLq9A5VowrHYaa51XULic7P8/31NiMdxGgKwdOV9d70UCObhTAMITJWU2eBDykGGxiqdqamrohbqOW7IyDMut9YhtoFSIx5XiY3+B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=aFXl8Yaq; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oTTO9WOg; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aFXl8Yaq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oTTO9WOg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738864136; x=1770400136;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JTGdpVu1EUyZ46fk9rFQCZnaNrltIu9bd/k4tdyOmc0=;
  b=aFXl8Yaq61INewTizgkpkVqvMyH5gExXxBcZRO0VPaz2UoTYGKtpRusI
   Ziklw2/WSBcK7AeQfwlE4wVfK8KcSDhL9CqLt0gAclCbMAPmBK1BLQCqd
   hZGItwptpc3vb+tItLKydfq+w0fVXG8o6hLD9h0fx+qalFGcwHcFLFelL
   e6l4zj3ICpBnmqzvt5sviAG8hdtnvFdW+4BoNNyGcYpnjj8rFrZyQ1fW5
   JMP1kXwJG5xYtFdgu7nxvq1WdAkI5XC5wFeQUVXzb2CgT0IYq4DSBx5l1
   XB7Uyuq4QJutTOsN00DH/vFlD+3bhNQqQIiQibKdq+fYnFMFgnqhGW3Hs
   A==;
X-CSE-ConnectionGUID: qBXkEFklTB6zEHVRnNwg3Q==
X-CSE-MsgGUID: /xi/8sMBRNGkBeLeNExRLg==
X-IronPort-AV: E=Sophos;i="6.13,264,1732550400"; 
   d="scan'208";a="37570370"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.8])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2025 01:47:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkGBMVVbq59J+Cn6gWvY9HTXRmAM2oBzIlxVQba1VFPhqKEt3db+cY/loxFkZflNeacuUbtEGwmXEvtMvC4T83aaIo4vD6jKrHHq6gvNSYi61vUEuGfrp7mF2i1qHpNbwWY3Ty5OE5vBFYB1sqMsEYO/qB0DdBWV1FkfSROLBsYHbt3EmlSSzrfvYoIsvWH5ih0jy7ksw5rnDrfFDNw4AE2IAFaf2lCHkH7tAZsbMOdz7UXuRV7fy+PygExAtuhAWu7qT0sSRtMF5Q84tEN6zG0r6cdFNf5trDMCbVSyGZVSvoH8GUHdIgdpu90NlZoEKV55hfUFxzT5rqLc4i7vgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTGdpVu1EUyZ46fk9rFQCZnaNrltIu9bd/k4tdyOmc0=;
 b=m552Is/9OTXUZj3Jfbs09anajcDXxk12usOO3xvdcbGfnagvThfR+00ON8YH4knoRB81PD0pGCCd65LHLlKdbFkOu1Bq5L9OVwSMofOXS50m+kkudn1Rz4oqUw/eVdBZw5vhSutHGfsC7IujVDlPbiayDOAUFEIeNLG0qzcLSDXcfJECEIuQWqWwCsL36iItGOS9/3etFckV1JNZuJpUZaRqjs+QTZfIrhrHadRaCh76O73fNvQfx93N2kNv6Vdc26aw9Mf8PM6s4Oix2ZuXbGkrIRPGEVG0jKNFftLUrLpSUuWRUyZN6mFSQ7Tg3u0whYzuGx/WbQiI6KRgIa1BYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTGdpVu1EUyZ46fk9rFQCZnaNrltIu9bd/k4tdyOmc0=;
 b=oTTO9WOgjh32eB+eF9oKrA99otv0h/MEpwovTY6KYkcMXCopQWtn2/dhi2Taaw9qTzse+rLrSkq7vOhttVIFXEgzFGJZ7SwY4f6dzX4L73fjydZECElrlO6sHB007w9A0h89sGUFgFW8xMIcGR1yo6tmmuUvjZiCtB+0wLAI5nc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL0PR04MB6610.namprd04.prod.outlook.com (2603:10b6:208:1cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Thu, 6 Feb
 2025 17:47:47 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.8422.011; Thu, 6 Feb 2025
 17:47:46 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: critical health condition
Thread-Topic: [PATCH v2] scsi: ufs: critical health condition
Thread-Index: AQHbdxHmvf69B4w9AEaXxutfZEUuCLM5AagAgAASWaCAAORSAIAAeE6AgAAcwwA=
Date: Thu, 6 Feb 2025 17:47:46 +0000
Message-ID:
 <DM6PR04MB657573C4DE11B13E58B1B5ADFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB65757320A1761FE473BFC5CCFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b962df63-42c4-4bc9-9815-9871be1ce2d5@acm.org>
In-Reply-To: <b962df63-42c4-4bc9-9815-9871be1ce2d5@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BL0PR04MB6610:EE_
x-ms-office365-filtering-correlation-id: 83b55eea-b886-404a-6875-08dd46d65dc7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OG52TG1ibjloZWhjZm90NWNMVVNBbEVxVmRjY2hDcldRSUdDaGdwL0MvYnpY?=
 =?utf-8?B?elJsejhlR0thYU9FMktUMXF5Rk03OU1nQzBqZW91ZlY0S0gxYXFZS2dQbHdP?=
 =?utf-8?B?QXFoTkJPMWs1MEg2UlFXK3VyTnVhTDFlcXhLendaSnczVWVTWG1TcGpkaTBX?=
 =?utf-8?B?TDZXZVN3bW9JdXR3MG1yZi9ON2hsM0xnMmFiTDY2Smd2OHdjdEtZV2Nuc2l5?=
 =?utf-8?B?RzJHR2g3ZFNMNFBaYlpjbWU2SkJmTjBTajZTbk5kSStZamJpRGEvRmJKMXVP?=
 =?utf-8?B?R3A0UzhBbUxMZlZRV1gxOTZ1TDBPWVVJRWErbDlJU1RNbFFSUEVHczMrNUxi?=
 =?utf-8?B?c3JMR1hrU3I1bkdNdFI2SlRrZGMybWNLQjJlYm1FdSt6anF4UDZSaFNLTEJ2?=
 =?utf-8?B?dlBmcldKQXgrekdGbjI4M1N3RXlmbGtKWTA2b0lOd2hEZlpCWU9tSzJZQnFh?=
 =?utf-8?B?WHJjbnZ2Rnl5ajA0TUkrb2N2MzNkbm0zUVJDV2wzUDFML2NsVEE2bmJMUy85?=
 =?utf-8?B?V1Zkc3M2ODl1UlE5QjV0ajh3c2J4QnBmcW5lVmdaV1A2WWhkWHBuejlHb3BP?=
 =?utf-8?B?SDAwNjkvTWNqVCsza1Mvb2c1MmRYdm4vUEZyOHdhSWFNeUdjS1N6Y0tudlA2?=
 =?utf-8?B?TkYxMWZmVW1XY1JZS0RVWjZ6RzZ3NUxpRkZTTCtQd2hKS3dsZjExc3B3cEMw?=
 =?utf-8?B?OTR1Ui9JM2VGWS9uU3JOZERsZ28yeG03eHNNQmNLU05QbUk4b1huWWt6Wm1O?=
 =?utf-8?B?ZnYyaVFaNDk4eVJtL3B5T0NuUU1SQVBWZXViUmppdHhkSExPMkwwUDduR0Rm?=
 =?utf-8?B?SHBPaWRYeTU5elFZQzdTbEk0UUxDME5GVUp6eHhuRjRuekdTZk0yTFdzeFkz?=
 =?utf-8?B?bjFXQXJkWFhTTG1pTlhpKyt6RitjY1dRb05BRzJ5eUlyQjdDK01aM3BDaFl3?=
 =?utf-8?B?UDFrWDBMUUpHTWVqbHJwK20wdXNkWk9SRjdYaEhrU0ZMajV4aCtZSW01RGpB?=
 =?utf-8?B?ZlBzS00vOTUxMld5M2JMM1FrQjlzdkpMbFVFMjltaE55WU56WTFYUllZOE5s?=
 =?utf-8?B?VmRkWlc4OFpKSW8wRWJ6bkE4WDN4RTJTSittZmQ1TWlJQ2ZmM0VUVW1JajRn?=
 =?utf-8?B?cm14enFaS0VNYUFMcmNiSUpWME11c0FqR3VMMXJWVVBJakkwM0xiajFzclpy?=
 =?utf-8?B?SmYyZmprQUJLaXdNSXEyT0RhR0NxS01FUmxlVXR3aFZ4aFdzWXJRdTVHYkc0?=
 =?utf-8?B?RnZNaTBRRnVzWkFZYjYyK2pKSTZDZDhGdjNBLy82Y09nUzU3UXdodXFMRzF1?=
 =?utf-8?B?SGhmYnFuRWUreHZhSGN3VnBzbHJ2ZHRVdWVQVWdFY0FORk5TSyszNmwrQ216?=
 =?utf-8?B?UFdhOHB1SUNSR1BFSUNEcmdLNmpmVjZ1ZkFyTHdSSkxRcG4yTU1YQ21lUFNL?=
 =?utf-8?B?ZnhUMGIwcW9MbjhRTjE2OXdGZGRUNjdEQkpGdDFCdk1iUEtVMVBEZ1lwOG9D?=
 =?utf-8?B?S01RMmFXaktFckZLRjI2b21wMGUyVFROUzZOS2haQ25qK2NxZWdsVHVnSmxJ?=
 =?utf-8?B?UVkvbHN0OXJ2aHBiT3Ird0xlMCtZT0xaSFkxL2g4Q2xYWDJ1V2xTVU9OVER2?=
 =?utf-8?B?d1paTlVscWRwbFRaNE1lUURZS243UjFnODBNQW93TFFqaXFjRHFPcmNKNE5D?=
 =?utf-8?B?VWR0b3VFUnlVS1RHcjJHWjRXamdiWFErOTlEVnBaY0FpVVRpbG9mbHpoWWoy?=
 =?utf-8?B?OEpXeW9pZUZBdGZPNEVPQTZtZUpGZEMwdUxjR2Q2YzJWRzg2ZDlpRHBMWnJy?=
 =?utf-8?B?MVJtRFJobWxmWWI5VkxPL1VwbGhlTWlBamZZckVYMGN1dytYaXoyNzBMUFNl?=
 =?utf-8?B?WnFoVUdTNkJkRmNEaWVhdjdJYStYZE9nSG9uSGVRWU43T3pTcUFMZ0pKcjFi?=
 =?utf-8?Q?KU2L6kyPqgE79eX/28GMhtt/Hlx9qq8t?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0xHSFBhT1pzb2h0alc1dUswSVdEd3NRQnVoRXZwZUg3dC9VTjRCTDlHZGFt?=
 =?utf-8?B?QWhqSE5yZmtBQ2NJY0ZBR2JGSmVBME1lZk43VzhQK2xVOFVxVkw0R2JnWnFz?=
 =?utf-8?B?dE5tSFlNdEJ2LzVBci80TElRYnp5VS9Ocm5mNHlMSWVlNzROQUVMcUI2OXph?=
 =?utf-8?B?bVE5anNUUmJVOFdMYXFQb1NmQnJLTTVGMGxYYWVqclNoZzFla3pvUUVYYlcr?=
 =?utf-8?B?VzhCYTd5NE1FQ0wyN1M4bCtZcEtNQ28rSjMwM3VadG9ZOG10TTEwMlJNbEp1?=
 =?utf-8?B?VjkyY2RNT0tQaXExYW5JeE10WFFHTUU0ZDlYOTFIR1gvWFFRZjhGeEh2RHRw?=
 =?utf-8?B?ODJMbmhLWm5rc1Vvc2RhcnFGQ044Q2VFaSs1N3hudGJkU2h6M1VNMEs1L0Iy?=
 =?utf-8?B?RUJ5V013Q2p0YTBYa25jQUdRNGNudkNWMS80M2dUVG94Nm5zbWs3bEkvejBs?=
 =?utf-8?B?ZzN3TUNPRUVXWVhGeWdzd2pxT2drZDBCMHFJKzRxVkM0NncxUkFzMFJncDNT?=
 =?utf-8?B?bmcvTUVyNkVKY29HTGh1SmJkN2lGeU52T1FqQVN6d0paNGkvRUdjKzhyYk91?=
 =?utf-8?B?TCs1OFVrZzJRd0VzN2gxQTJuMFpVZDFPYUw0UWZZT0s3NTdhZDRGV2RlMlR1?=
 =?utf-8?B?QnBrRWI2c1lhazkwZTVpUnJQR2ZkSVBWV1R2NzEwQnRXandJdTIvYzJTcWtK?=
 =?utf-8?B?ZFdSUjdXbkpiUjRCZHI4VitQN3ZRVlAxcWhzOVJMdjcxQXZsT2dBWGpnTFIr?=
 =?utf-8?B?ZzF0SnRwa21kWTlEN0wrN3pHRy9IbElUTVJIWmNuTFk3T3pPSHBNOVp5c2Jl?=
 =?utf-8?B?UXlBZS9TbVMrWDFoRmxNY3pRTUhZaFE5TmtTcDJaYVVZMEJJenEzL2ZEWVVj?=
 =?utf-8?B?dlRIQXRwaHFOcUdkNjJNUGQxdTBPZm9RbmwrN05iSFdZTUJnYll0eTJOcnpz?=
 =?utf-8?B?cFptVzlhL2dFdXg2ZERvd2xPbnE2OXowZXF4Z2t1MlFTbzRRdWJzaXpiWENN?=
 =?utf-8?B?SkkrTUZqYnVIbys4aC9ZZm5NUTVQSlliNS9qMnFlYUNuaEFrMGR2TzQwOE4w?=
 =?utf-8?B?SU9LVjV5TVpaUysvS1orZ0pwZFZzNU1lTDdCQ2dBVHArNVZWaHJiazRWYmNk?=
 =?utf-8?B?YjR0bEEwbXFHSnZRS3p0SFpKU05jNE44VndHS2FMcWw5b1JCaG5YWHVGTlBT?=
 =?utf-8?B?QlU1Mlp6Q3pvMWZaL3EzN1RnL1pYaXl4MUpDYk9yTUJvM2pyeEozaTNCa0pG?=
 =?utf-8?B?aHY2c0dkVVduVUcyY21FT0dBK1lNVXpuRWNiMktiNi9nMi9JYTRGRXJpT012?=
 =?utf-8?B?Q1ZPK0RlUVljM0EvckVWR1VBNTd0cXViQ1FBR2RSYU5DeStWWjlLRVQxMzRu?=
 =?utf-8?B?ZDRCTlBOMlFwcllNc1M4djNRZGFkK0FrSFZHc21SRjl3ZG0vY3dsTmZmblZK?=
 =?utf-8?B?TC90Y1JWMGE2VUZmNExreTJwcGtPRGNuQU5OY2x0Zi9NVWF2WUEwUFgvblkr?=
 =?utf-8?B?RU1uTE16QVhzdVhJS0wxU21pZzZqaVhVRGxrQW0yTlpJY1JnN05hVVB1aTlr?=
 =?utf-8?B?YS94UTNTRUpzVUpSNlVKQ0Z5SnBMa3NqczhPTlZ2djU1c1RnN2phcEN0Mjcv?=
 =?utf-8?B?SnM3Y2RybW1jaTlvV1M3K25lVnRWbWR5TEdzbUVvcGljWXlsbWE2Ri9WbVhP?=
 =?utf-8?B?cm9uclNKM2tVWnBOcS9kenhtMEkrZUdwOS9jVnQ3VUJkMGVRa0k3SUw5UDhx?=
 =?utf-8?B?TDZGZFpEMU04K1JGUTc3K2l6bmJEaE9VcDJ1aUp5bzE4ZGFLZ2VYaDFSMk5W?=
 =?utf-8?B?WWZUN3IwSHdxNzduQ3RhaU1YL2JiYzFDbXhKRm9kRFNhMDVSR3VFd001NEJz?=
 =?utf-8?B?VkhLdnlGOEpuSWFaYlIzZzljZ3RLcUc2NE13dXVvRC9pZU5OQlhLVFB3UXhP?=
 =?utf-8?B?bmVhSG16ZHJ1dnBqYWE0UFZYTnlvUit1L1pNREhxdlpSc1ZUM1VnOEIvYjJD?=
 =?utf-8?B?TE9Sd2NsMFlzZ0p1V1ZEYUplVXVzLzlpTGpKTTVNN25MSlEvbWhTTVlyL096?=
 =?utf-8?B?WDZXL05aTzg0Z09YeXhjMFMyRVZuZWVLVWE4V2tvWUlyQjhNeUNGMWViMUsv?=
 =?utf-8?B?Wkc0Zmw5NFJMVFJrNzRENlk2WlNqVkhTNzNnUWlBc0xKcHdkdVFUaGFmUnVj?=
 =?utf-8?Q?06/uXro1n3xzh6slTg5FluPJSxy95l11pH2+2+FNs0Nb?=
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
	WhAFhK5s3A+odfkcP8Vp8F8nLgk6AU366zK+49CYEObdDEbdZ5ITeLVYeCEsNEYCSf83IVR4LYcGsWXqK3R0gP7JeS3URA5MlG+nu0Yu+zHtIfQukU7QFkfQBvkmdTAjD48itIIwHZ7F/WU+ffupCyAJljWXyDg/cMevdyL4TRbwIZNTF/BFhoSZmPStpZ2CqLv+nH9x16bLyVDUAYOhTlzrEBeD7q46XzdUQemOHYPGib0oyxu9Qx5mv04nzxXrw21vivvG1vRismncu/1ADj8EtHzwdaRJOiw8IpzZsCCO4vWS3qn1MFc59aL9uLdl6s9DqM63fPoZZDI3W6dvDTBnUTa3flOsSsflYzIKnU6LqohpbVCvZJPuqauIEWlMklc9JTKPksOxVBVzHakpiqtRmVJ+GLidfD7f2KbKttbBaDcx13bAJb3+uExXFtLHJ+dfA7JZh6p2lGIDxUkkVFuYTt7GhIhUWjRvEz7zWEjEcCn2otVVBky9EVglsyyivmJp9dXw6xhYvyqoc8JQag9ooieJM2KPmLsbl9EJ2rDGBjAFGEuEuxULmmuSsTspAVcdviwq1x4VQ6PUKVcYHcruugJT148sWxpeys6OJ7OfjwE4oMPP4iO0nI/4abXj
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b55eea-b886-404a-6875-08dd46d65dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2025 17:47:46.6235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S6XYhRZG1DmLNZlC8Jy/xyF6pQ2p9XiVNazx+IjBjbzlavOIiQm0VWZoUxiU6VpTsiRXxLMlZLu1sX3CdyshLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6610

PiBPbiAyLzYvMjUgMTI6NTQgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IEFmdGVyIHNvbWUg
ZnVydGhlciBpbnRlcm5hbCBkaXNjdXNzaW9uczogVGhlIHNldCBjb25kaXRpb25zIGFyZSB2ZW5k
b3INCj4gPiBzcGVjaWZpYzsgVGhlIGRldmljZSBtYXkgc2V0IGl0IGFzIG1hbnkgdGltZXMgaXQg
d2FudHMgZGVwZW5kaW5nIG9uDQo+ID4gaXRzIGNyaXRpY2FsaXR5LiBUaGUgc3BlYyBkb2VzIG5v
dCBkZWZpbmUgdGhhdCBub3Igd2hhdCB0aGUgaG9zdA0KPiA+IHNob3VsZCBkby4gU28gdGhlcmUg
aXMgdGhpcyBjb25jZXJuIHRoYXQgc29tZSB2ZW5kb3JzIHdpbGwgcmVwb3J0DQo+ID4gbXVsdGlw
bGUgdGltZXMsIHdoaWxlIG90aGVyIHdvbnQuIEhlbmNlLCByZWFkaW5nIGNyaXRpY2FsX2hlYWx0
aCA9IDENCj4gPiBtaWdodCBiZSBtaXNsZWFkaW5nLiBXaGF0IGRvIHlvdSB0aGluaz8NClN0aWxs
IG5vdCBzdXJlIGlmIHlvdSB3YW50IHRoaXMgdG8gYmUgYSBjb3VudGVyPw0KDQo+IA0KPiBIb3cg
YWJvdXQgZW1pdHRpbmcgYSB1ZXZlbnQgaWYgYSBjcml0aWNhbCBoZWFsdGggY29uZGl0aW9uIGhh
cyBiZWVuIHJlcG9ydGVkIGJ5IGENCj4gVUZTIGRldmljZT8gU2VlIGFsc28gc2Rldl9ldnRfc2Vu
ZCgpLg0KVGhhbmtzIGZvciBwb2ludGluZyB0aGlzIG91dC4NCkEgdWZzIGV2ZW50IGluIGVudW0g
c2NzaV9kZXZpY2VfZXZlbnQgc2VlbXMgbWlzcGxhY2VkIC0gbG9va3MgbGlrZSBpdCB3YXMgaW52
ZW50ZWQgZm9yIHVuaXQgYXR0ZW50aW9uIGNvZGVzLg0KSG93IGFib3V0IGNhbGxpbmcga29iamVj
dF91ZXZlbnQoKSBvciAga29iamVjdF91ZXZlbnRfZW52KCkgZGlyZWN0bHkgZnJvbSB0aGUgZHJp
dmVyPw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
