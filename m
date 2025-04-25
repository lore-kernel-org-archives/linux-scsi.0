Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C023022A1F1;
	Fri, 25 Apr 2025 05:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745559528; cv=fail; b=EkY6oAEnHgoHsuXKFwQv2M80WMGCRmePR765FI7gAi9/WAeRCL5sRRtEBRubbWycIrBs4jXCADGLZqQlB3N+PGCUAOTW40nX9xsxoO6zesD20dHQIKuLFVBKHkfTQekekq3hvB9GgsyS7kHS/QL0uhu80iqsc2oDNwuF/oqffCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745559528; c=relaxed/simple;
	bh=VXTe/uCqvEWwaGUZrbs6qkQKWIdO3VtkT6QnM394ZAE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KMowXf0vuBIaddCaBtdRhDj89Ec7v9Zpf781ZrkFkhJisrhBKnKJJ53/o4z6zJpE3zYfIwCOGbk+Co70VC7iQWyStfIq9AtOkWd/Sz7UXLxLJWREPaR1LLo8zyIALiNRKaviA7Pc+CNn9iPf1JdXXkAVQ76jXd3HD7bL7SDHWpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=XkwRx1zl; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="XkwRx1zl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1745559526; x=1777095526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VXTe/uCqvEWwaGUZrbs6qkQKWIdO3VtkT6QnM394ZAE=;
  b=XkwRx1zl6wNqo0xJdm6y40YUHsC4VUksqAH80XI9EurCUpgrLo/aRi2y
   uYE+Oyi9/PDnQScFo5oBrbwZxEWscu7g0W2UQFmpguJcSMFc3+60kcz2w
   vVAWt3T2DkS0hQh80b5j5UlQ6vjMfXBf09P3GG/dNKzMsGydJC/gMHG1k
   i+vwm/HJ3RCR9DEzemzVmUZpSvkKDVUfxz+KF1EiKRE5LJ4/ZZX4HUkTM
   CPwagcEB8UdP/VnaMhT4zz7kkQDduX1VWm09UzVVhKwMxvE2/xuA09tnC
   Mmj7rxbvW723fH6VY6E4Q6yJPS4Jv7DkTx4WDK0CVOa/UzzArr68qmde9
   g==;
X-CSE-ConnectionGUID: 8SHSw+MrSHqBtvHbHXs55Q==
X-CSE-MsgGUID: U15msuW7Sqe0uqgcVkGrGw==
X-IronPort-AV: E=Sophos;i="6.15,238,1739808000"; 
   d="scan'208";a="77118189"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2025 13:38:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JwUhpjYZndj8elqDh5VrJ0rYVa4+1RKPigM6sqq53Jec4EOhCCxhcI4Qdcr+FXzXp8abVK8rzQdPKXXzCp4Tg1tgOQZPgkuCWGYHY/giw+vlJhHywlwP2yFN4gFZlCt95Fwv3i7qpOLH2+hQ2FstXonF/nu8/l7CiJMgaqs1IAtfxFYPlhyCuGMaKmg5kGscnx73GooTqzT48OC8ILPADq7EGf/N8vlPI3JdX+77b6+T1+LhtAOYcGx/PULsnQSR+AkmwRLLwA7h0Qwz+hC9ey06rwPPE4EXZLzu/xgBBY1PvXeeR/Z12OZslasx70uLvaLLA6AgFFhLlNDi2AJzxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXTe/uCqvEWwaGUZrbs6qkQKWIdO3VtkT6QnM394ZAE=;
 b=uB7qZ+ppjURuibpwONXZREpQZwCgug7nK8D/H4asCD3rIuD42TovJ7DS5Z5gSJTtY9UqoztQpaTbshCYkVJGGkUudAfTyIs9msqLswjOq/7QTPPKNHxdbfFqm8gY2KzX7xHWQv0ibjKy0+9tA7/Ozy8tpdFSA5ZFE04WASG+FIl21yPiNqvV8DkNVkivLiYX2ekzW67QMJNPyX3u/PMBxQqsGZmjicsAEBE3BuE44DQvvbbLpvXcyJNLNQpE9oQqpvtBiy+pPsKdpHeH74SuTlcoK7JvAzyCx5Hf54bRMdaLatGUYoX5vUDxp7OGP5sKRFgrmNeotfHlmOHwpkPm1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BN7PPF52F30F1FE.namprd16.prod.outlook.com (2603:10b6:40f:fc02::70e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Fri, 25 Apr
 2025 05:38:43 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::fff9:726d:943f:6852%7]) with mapi id 15.20.8678.023; Fri, 25 Apr 2025
 05:38:43 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "keosung.park@samsung.com" <keosung.park@samsung.com>, ALIM AKHTAR
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ufs: core: Remove redundant query_complete trace
Thread-Topic: [PATCH] ufs: core: Remove redundant query_complete trace
Thread-Index: AQHbtX5Ip6OdafELmU2a+8Sv02/mybOz3SBA
Date: Fri, 25 Apr 2025 05:38:43 +0000
Message-ID:
 <PH7PR16MB61962DED035E3F1F5F03B142E5842@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <CGME20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
 <20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
In-Reply-To: <20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BN7PPF52F30F1FE:EE_
x-ms-office365-filtering-correlation-id: 28a13e98-c519-4f35-c931-08dd83bb70e4
x-ms-exchange-atpmessageproperties: SA
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?THhTcm5DREZhTGQ2WWlvTnNZZXRaQ0xncE1TZGxVcS9MVGtzcXdNTTRJT3o1?=
 =?utf-8?B?VDVpbjlHWnJlOFAyemgza2NVc0p3ODlpOXQ3bTdCR3IvaDdGRDAxNUg1SS85?=
 =?utf-8?B?Vmx5eWF5NWQ1dFpETUVPN0U5NDBPREZiN1llTG9VT1VsVTI4UkRucHh4VXI3?=
 =?utf-8?B?a0pwOHZCYmFXMUwvOGxaZkZYRDVVYXREazFHMUIvL050TTFqYTFicXEwR1ZP?=
 =?utf-8?B?OWZvbGkwK1VSTUMya25NTVA3WjlKNFNEb0JEVmhUTUhrZEo5N1RERlFldFFP?=
 =?utf-8?B?dGpjYWJ1Tlk1YUQwc0orQzNmOTJMUnRyYWNITDNPdjNmOVM2ZmRYZks5bzU5?=
 =?utf-8?B?dmt6ZVdiYzlJQ045SVQ2eU9DVXBZc2FtUDZLN2QwUkJpZ1F5cWR2QnB0TlR0?=
 =?utf-8?B?UEoyVVd1YlZJWVcwV0lFSFdndlR3UWZzTnFHMmtMZnJIRUlyUGRadzRaeWFR?=
 =?utf-8?B?RkQwUHVHeEFOeS9HMnM3cXR3MlYyczUyNzJrL0FvcW5rNWJ5RW8yQlozQTR3?=
 =?utf-8?B?RjNRalBpOERFM3BIOVNoY1Fzc0RmQUR3VWpRYjIvK3FQQTF0L1pFUXlObC8w?=
 =?utf-8?B?SnU3UDZnTFV2c2NkMFlPdzU2b1VqQS9NQkwxdFNhLzhWYzlkQ3Q2MzMwclRY?=
 =?utf-8?B?RmdIN1FybkFxcmMrd2R5OTkxTE1JYUhTOTRVR0xRbmtMdDJ2NzVkeVNFRVN4?=
 =?utf-8?B?bjRHTTZ2akoxNk5KWGtMNnJqRENOYUt5ak1uWDJvekZKR1VQQm91T2hPTFBD?=
 =?utf-8?B?K3UxV3NuYUF4anhtU0pUODZLdS92WkhpQ2pJbXRlZjRmaFZUOWJnTjNvbDRU?=
 =?utf-8?B?OGdEemovc0pNRTdvRjhNYVVud3VQWG83SWNDd0JTbUxDcXZlM092OGNJQ2pU?=
 =?utf-8?B?OEtEbUd5RThNUWlZTDdKTUFhS0dla1BRbDg3RDlSNzJqWXg1ay96V0lUczFi?=
 =?utf-8?B?dnJ4eVhFVTJmL040VjBDc1hRSjM5OXFmcUtSQUE4Rkt6U0M5QmNDblhPZCsz?=
 =?utf-8?B?ZUJ1Q1Z0QlFoNDlORHg5V2traXZhZ2lDajhNKzM1WVZFT3lWNUdSbTR0WFBU?=
 =?utf-8?B?ZGsyYTY4cVdYcFVTaWtXZWphNDhLbXBGaUtFZXl6RW4wbjMzbVAwcHZnSnNx?=
 =?utf-8?B?b0FoclM0WEhIeWIwOFA5cjlia1NZTlFRRXVCM2YyOUFtV2VabnNUc0ZRaTBR?=
 =?utf-8?B?YldwS3AyRHJWeHZyVyttSC9YNWl4NTV2dGVCWHQzVVpsY3dzVzY2M0tDcS8v?=
 =?utf-8?B?UHBoa3ZhOXV5aUpiWjVsYVo5bWNjWlJuVkFsdk1XcFArTUhiK2NSa1o1eUpJ?=
 =?utf-8?B?Y2t1Q1NxUkZrR2IweTdPTC9RZU5xdGxvZ2h3eFpWM2tVMTF6VnZGNEUxSnJ1?=
 =?utf-8?B?Ujc2VVA5WTRlTjZCVGwzYlAwckNucjl4aTFNQTRheWVmRmZ6ZkVmMU0zQ2lt?=
 =?utf-8?B?bnNKdTRNN2c3SzYrZ0JRb0pmeHpPWmtDZ1BnbGdMeTg5R0FSamg3Z3l3Zm93?=
 =?utf-8?B?WFB3ZVlnSXQrQ1YxS1ZlRjNoRFpYVnJsVFJKaU9JWU5HN2xSMUFzNm4rRmNK?=
 =?utf-8?B?d3lFV0RoNWZkRGdidEYveGNwVTdDNUcxVk9nYUoydzZHSFFMZ2V1YkRJb3pV?=
 =?utf-8?B?Y3VFN0tNQ05LWXdXQ1Bjc1NWb2VmTHZSaWpYUUdFb1JrNXVjdDVJTlYvc0NZ?=
 =?utf-8?B?cUduRkwvTjdwTUNDSmp4YlJ1MzN3OTFBa2srRnBIcWVwTVFubzZ3MTBxNDhj?=
 =?utf-8?B?WXBOcWFXdllFckxoMWxLYVQ5OFFJQS9ybGViSXpCeVlXOUxaYXpQVSs0UjQ3?=
 =?utf-8?B?Wk9RUFhkRmcxNE1sUThBMmVkckdlS25OWHpJZzE5VVlTZXIydm1pTXJoZ2Rz?=
 =?utf-8?B?OW9QNTA3dEJRK1NPVEhRWXo1dkM4TmoyTENYR05IYTVCZGd6T2x2b0hzeHpQ?=
 =?utf-8?B?Q2p2L3pmd0FhNUJ4RVBUZmY2UzBlWnBIK01waUN2MGp6V3ZWT2dyWWFyMWZQ?=
 =?utf-8?Q?O21jH32DSv1V7NlA1g9MuJHGj8zy+M=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YVhXTkNDdCtIK2M5L2NuUFE5cGFDVStVcjZkRk5sREFKSFJ1UDduS2hWMTQv?=
 =?utf-8?B?MC9CNFhFbk42UlVhTm1VbHZYcjlIdE0rZGVLenQvVnR2cW5wb3NVT1doVnZh?=
 =?utf-8?B?dERRYWJ0ZW1vSUhXV0dwSzhMY2Y5dEtTT2RqN2xiNjh3U0pKcS9HaE1vcUp2?=
 =?utf-8?B?UGkrcSs2S2lSRHh2UkF1SkFCaVRQR254TGZnMnlHaWVudGd4c20raFlVU2RQ?=
 =?utf-8?B?dGhMcklXRUFvNzhkY2ZSdURJcEppQ0VDV0p5NmtQZWtZUDNITlo0RVI1NXdR?=
 =?utf-8?B?WDRYQVBUa3JTNUw0L1NXZ01PWnFjUExPYTFmNmVyTUU1VHQ1eFNnNU5KMEI5?=
 =?utf-8?B?bHZOTFhVYjJsZmoyWkovcUdKdGhBZmdvRTNUUDFBYWdmZmFLL1gvT1MxUXQ4?=
 =?utf-8?B?R3BOTTN1S0xYdUVuWjFYTE5tNUNhY21zK2JRVnIrd2JncmU0VjlTWXNGRndm?=
 =?utf-8?B?RlRYWmFJdFZGNEdpNWtKQWhTVzdwRkN4QlJxSGZEMG91NzB1V3JUOVhQcVhP?=
 =?utf-8?B?UUo2cmlvTXVpK2pxSFU0a0IrM2xXQXNsUHRhWURSSTdtb2wzUUU0eU5qU1hn?=
 =?utf-8?B?TWFOVDU2WG9IY1lSempUc3dGMHA3UXJoM1pzcHFSYytPc2tNbzNkWVIxWWIv?=
 =?utf-8?B?cTdZZFJPcW1qMEJMMCtvbzgwUlJ0UVZIQmFsdGpPOFJyK0FjTTZsREZwakxz?=
 =?utf-8?B?R3BabEVOT0U1VUZsZGJNL1hESysyRy9QK09mTSs3aEFHQjRKcUNxN3FFOTF3?=
 =?utf-8?B?Yjd5OG9FZWwvelNQZDFWUkh6eWwrcjhqR3B3UDBvUU40TXlIZlpBbzNWa0xm?=
 =?utf-8?B?c1NlZlJOUG1kWXhmUjJhNHNsaFBvZjhIR29MbDZPS0lYWnRwcm5VUElRalBT?=
 =?utf-8?B?VWtzeGVtcGdRU3N3bWRUK0lnT1NPQzVodS9meVhDZkNYbzJwUFc4UERCZFBG?=
 =?utf-8?B?YjN1R0xYblY2N3d1Tkx6OHFqZXErVUg5eS92QktHUStVN0ZYenRJcHprc1lz?=
 =?utf-8?B?MnZmUURBcDF3dEQ0K2tzOTk1N0FCMGcyTElVcXRtZDNkSk9VV2xuNk00cEVV?=
 =?utf-8?B?R2d6b1VNTHY4WmRHak1Camg5ajQ4clRBQUczWmZYV0FqUzZkdzg2U0RSVEla?=
 =?utf-8?B?K1lDMEJhTXBxd2s5a1l3L3lRc0lwdXdLZzU1ZHZpZ1VxenZWU1pNK1dTUlls?=
 =?utf-8?B?SWt2SGJKSXBGMnhzSjNiZ1NkcUNaZ2thZUZzd3JoTHBCOC8xdzcvcVE4TEJE?=
 =?utf-8?B?a0JoVnZhUzA3UzFsQlNPWFFBeENpeW5QT3RKdlRxMWtLSS9JZ1FQMEo4Yitt?=
 =?utf-8?B?RWNGOXhSM1RheUZEWE40UldWeEllS3AzWnpzeFN1dzNZWC9NbFMvWHppaU1R?=
 =?utf-8?B?RFBDa2pIMXlmTmpnLzNVSGcrMmV2Yk5tZVVnNmJpV003dFI3dlNMZ09KdWQ2?=
 =?utf-8?B?Zmk5NDZ5NXIvWlZSdk1icjRoNE9vQkUzcExrNWJxOEpnNWpta2pWNzk1U08x?=
 =?utf-8?B?dGhvb29sSEhHL2dBdzIzUGxadFptWTlTWGp0LzExcmRFMlVsaEQxWTdkYnB3?=
 =?utf-8?B?Z1h3d3FJWFA1U3RTQW1sSmNzc2VNa2N5WVA5QVVYczQ2QXZsQXB5TjBYMUlB?=
 =?utf-8?B?WERtMFZyalMxWUMyZ21HcHVpQW5OaVI4R1NTS3NrbGUxZ2thYlpXVzlvaUt2?=
 =?utf-8?B?YVVJYkluT1BEWjlCUjBiWHFzd0VRVXBSY2NrR0NSV3g2bVNxVFB1b09iOFNp?=
 =?utf-8?B?TWpGVVlBUUpBazREb1VRbEEyaHdDTTZFOThiL1VWcDROZE1MUGwvbjhYMjQr?=
 =?utf-8?B?aGsrZ01ZcHNrZFFiQUVRbGVZSUpNeVlra2NoMkY2eXBNc3BjMDNxTVk0ZFB6?=
 =?utf-8?B?RXlMNVhIbVBqZGd2SFlqZW9NNTc5dyt5MGZNSWdPcU1OZ3FRTzViNVFhUGJ5?=
 =?utf-8?B?VmgvaTRaL2l2SlFpSEdEODEwWUJIZE1NN3VPNXV5Zytaa0s3QTY4TnhUaCsv?=
 =?utf-8?B?blltQ1hvV0tFdVBYZHlpbUYzTFNDamZJNWJJU2N6SkNPeG9BKzFzbG5LTDlO?=
 =?utf-8?B?anY3a2hvOUdWMjZ0eDBxRkFIaDk5VXhzSWVJNlM2Nkh4cWJqaDR5Und5R0Ex?=
 =?utf-8?Q?eK6m1tkqDLYFReBVLVHNJoteD?=
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
	9FzkxiH1fmLxn0/0Rx3aBsL/4Zsz2lqmd0yJWHEWQojjnFaNsppblP0fLa1/c9bXmTMWyV/ACXTy1mA3fXrXtzZN5GhfXkS11CqSLja69wzopJBBpzyVbhjgchLABU5Ne1xJrmhqEmyIMv0WY6NJqqopxyJB0LYvMBz2W6JvCeIMkB9MNbJ2V2bPtnOpPmC9Inh17dFbmPP54+t5tEI5MqJAaxKuoSVSaK/fhZXGka07+zzzxirtab2phUGS20l/gZpUpuLJE5C/7xAocWhaRKcHQFF32EmAvlUc9vDzsGCtCeUX2bEvlK+FIBJ1WBNB4c4YAJW1/mcr4ln0WGXY9TTl/Bo8CVkaKRKombCvMn1DkOdWxyuxmj1HgMmZe/U2dVUbhsadaXFrPE8juRobJG1b4igL8Vn0umUH+PFwenXKWMXld+TFh9TRBQwRcbW8Duxd/r55XhzaC2+yhSCFWSaZ+v339Pg9XaRY5fv+8yDlhpBC4BfC+ko/jtgokUXIxP+PZNUMkcMI8tTI+jbQ7BQq0eulsDe/TXZKuCHXCHlLwJJ22EoW3Lj6gMGaTmIaMaImYep+zMn76LhNpE5WcxBVgB2pw75wvh8cbF7eUyba3RLxk50B2to+3CSSlrEYuD1nbcLuhK9E07p5Ol3/iQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a13e98-c519-4f35-c931-08dd83bb70e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2025 05:38:43.2541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ux6O4PAfAgK13CM/v1mg9uk5ZLVqkxL5RnA9CX03NAbrRimwVeyrVHmnypWrV5PwKws/UVP8RlmvutkHJapGrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF52F30F1FE

PiBUaGUgcXVlcnlfY29tcGxldGUgdHJhY2Ugd2FzIG5vdCByZW1vdmVkIGFmdGVyIHVmc2hjZF9p
c3N1ZV9kZXZfY21kKCkNCj4gd2FzIGNhbGxlZCBmcm9tIHRoZSBic2cgcGF0aCwgcmVzdWx0aW5n
IGluIGR1cGxpY2F0ZSBvdXRwdXQuDQo+IA0KPiBCZWxvdyBpcyBhbiBleGFtcGxlIG9mIHRoZSB0
cmFjZToNCj4gDQo+ICB1ZnMtdXRpbHMtNzczICAgICBbMDAwXSAuLi4uLiAgIDIxOC4xNzY5MzM6
IHVmc2hjZF91cGl1OiBxdWVyeV9zZW5kOg0KPiAwMDAwOjAwOjA0LjA6IEhEUjoxNiAwMCAwMCAx
ZiAwMCAwMSAwMCAwMCAwMCAwMCAwMCAwMCwgT1NGOjAzIDA3IDAwIDAwIDAwDQo+IDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwDQo+ICB1ZnMtdXRpbHMtNzczICAgICBbMDAwXSAuLi4u
LiAgIDIxOC4xNzcxNDU6IHVmc2hjZF91cGl1OiBxdWVyeV9jb21wbGV0ZToNCj4gMDAwMDowMDow
NC4wOiBIRFI6MzYgMDAgMDAgMWYgMDAgMDEgMDAgMDAgMDAgMDAgMDAgMDAsIE9TRjowMyAwNyAw
MCAwMCAwMA0KPiAwMCAwMCAwMCAwMCAwMCAwMCAwOCAwMCAwMCAwMCAwMA0KPiAgdWZzLXV0aWxz
LTc3MyAgICAgWzAwMF0gLi4uLi4gICAyMTguMTc3MTQ2OiB1ZnNoY2RfdXBpdTogcXVlcnlfY29t
cGxldGU6DQo+IDAwMDA6MDA6MDQuMDogSERSOjM2IDAwIDAwIDFmIDAwIDAxIDAwIDAwIDAwIDAw
IDAwIDAwLCBPU0Y6MDMgMDcgMDAgMDAgMDANCj4gMDAgMDAgMDAgMDAgMDAgMDAgMDggMDAgMDAg
MDAgMDANCj4gDQo+IFRoaXMgY29tbWl0IHJlbW92ZXMgdGhlIHJlZHVuZGFudCB0cmFjZSBjYWxs
IGluIHRoZSBic2cgcGF0aCwgcHJldmVudGluZw0KPiBkdXBsaWNhdGlvbi4NCj4gDQoNCkZpeGVz
OiA3MWFhYmI3NDdkNWYgKCJzY3NpOiB1ZnM6IGNvcmU6IFJldXNlIGV4ZWNfZGV2X2NtZCIpDQo+
IFNpZ25lZC1vZmYtYnk6IEtlb3Nlb25nIFBhcmsgPGtlb3N1bmcucGFya0BzYW1zdW5nLmNvbT4N
ClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ac2FuZGlzay5jb20+DQoNCj4g
LS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgMiAtLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggYmU2NWZjNGI1Y2Nk
Li5jNzhjN2FkNGUzOTMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMN
Cj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtNzI3MSw4ICs3MjcxLDYg
QEAgc3RhdGljIGludCB1ZnNoY2RfaXNzdWVfZGV2bWFuX3VwaXVfY21kKHN0cnVjdA0KPiB1ZnNf
aGJhICpoYmEsDQo+ICAJCQllcnIgPSAtRUlOVkFMOw0KPiAgCQl9DQo+ICAJfQ0KPiAtCXVmc2hj
ZF9hZGRfcXVlcnlfdXBpdV90cmFjZShoYmEsIGVyciA/IFVGU19RVUVSWV9FUlIgOg0KPiBVRlNf
UVVFUllfQ09NUCwNCj4gLQkJCQkgICAgKHN0cnVjdCB1dHBfdXBpdV9yZXEgKilscmJwLT51Y2Rf
cnNwX3B0cik7DQo+IA0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+IC0tDQo+IDIuMjUuMQ0KPiAN
Cg0K
