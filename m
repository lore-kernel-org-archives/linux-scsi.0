Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0198D282FB;
	Thu, 12 Sep 2024 06:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726124225; cv=fail; b=FdH4HtPX9zH5sJ1LcMrxTuO4d+ANiVOrOue39nIjlVfAdc25T9reQF4iRDBqy9IoEiocuLkzZ8OKvvIBUKm++mw2EfOd1t/bqYWHTs0Vy9yebl5mKYlnNqkYsY6llx136vHOWVi8kxuLrTk93l535sORcblR19IHmucbmNCBFdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726124225; c=relaxed/simple;
	bh=yhox/31faHjNSmK0oT72+J2Lcg/+KP0egV5DZKTu41c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tGESMSEpfHDQg5H+DLi7LuK/m0huqypcdLYd4JaIRlh2KH6f43xFTQoGzSfW0h+QmD7gekux5aLbhDP8Dh4/WDSu8fT03muNKg1/gV/2r2GQhcTYbGCdT7IEi8EkdcJmpIgdjEKaVErzd24nImiq25njAjDB/62ti45r89ijmoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IoSo2GbW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RUT4TX5l; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IoSo2GbW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RUT4TX5l"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726124222; x=1757660222;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yhox/31faHjNSmK0oT72+J2Lcg/+KP0egV5DZKTu41c=;
  b=IoSo2GbWJrFJJtTZsC91nOsBuvV+wL3v6kSbWoWk7uUvcknic+jj8n0Q
   ZR5Xf5C+74ysH/CbtsxQGJnHUe73E5408e1/ZGZ9Efo/GYZ4PGeLkhRMt
   BVrkEI8juANhvc8kFYiK5zCZlAUhYDo3dZrFhOvSrqlRtaZA8prpf0CwT
   71AltjN6NrxvSaUYgarxdRUG2zbJsfBwHRs9cG8aNGBr4HEdOwOMTzYoH
   thVzlMouXw93lDTs1LV519mzPNOp5pTw4n9jNLKnzj/x3NU9TkD2bbYvf
   0e6OMY3xCXb/i4eZz/ZK8UGsY2j/qTBP1+P7cpCycFf/85RCrky6ISOuV
   Q==;
X-CSE-ConnectionGUID: 5Q9fJF4cQhudSe81K5lFCA==
X-CSE-MsgGUID: n4Yt/JOMTzuEKhqLnB0s+Q==
X-IronPort-AV: E=Sophos;i="6.10,222,1719849600"; 
   d="scan'208";a="26887122"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2024 14:56:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yxIZWqG1RtDg3dzbAz3Se/MGyUwxeXW2SIZwUxAKys6FRANG/c1TUnuf0jI46pzSGc6+qULLcRAUU2YurxEWiOOCctANFRlBH4kKUIPDWKa+WaSRf3mRU8V0GxTavOjLl6KPFon75bJR84uX5DQoSOhTw+Ij0g44+iA1u9xymrnHBks20yn78xsQbEfN9OdUskbYkUOGf7Shk6kUfJRkg1VA2ZfbghZJTfulja4GKobrZdoQhT2A8+eOC8cIEyN/pxMz3vb4Od3Ubj4rQUJJfJwzRy/B1JMe0A6SGTk40TNoQVPhmTKhV0nod4khpthvRoeOEen2ItIGCLbtSXewtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhox/31faHjNSmK0oT72+J2Lcg/+KP0egV5DZKTu41c=;
 b=y4B6Fwii1zU/C1o0Z+YpVH3maJIfUncMCDsjdfRjsqBwAeSO3D9y12XCEOxHTd/OVdtDVUTNFShIN5wcP3L8MLnS2s8SV4V8gTRgCEv+X3td/W37uKNNKIRB2xH5yzieqUTS/rDE6f5IKNOnoAGRSPO/ma3RgFN8ZlxQ8q9neurU+r1g0KrbbGWKUzqEcrtCWzwynTPA53ZrJgzYgALOWaY4z0J8qm5UlT+VlZ50oW8JD20HfXLaNpfX74rrXnkzVjlRtbNNclEWZujQdPCJe2WZgkoDj+/HMJKQ0hV/BiA4/9jqx0B7MWgBaUWxTsorFBJhk9vmMyZHkDJZkkNd6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhox/31faHjNSmK0oT72+J2Lcg/+KP0egV5DZKTu41c=;
 b=RUT4TX5lPX8tnotwSJyCVYvpjcsHlYJNK5xub5sHMcMHF0240MXglYWYFBDmPvEblCnRsEVRsVb0qYy571Lf+Fygmnv4d0Jcu1t4znOEpxaGuM/uMrLuYWARoTH9KLvjZ8G+XDx6QS8VxYBQ7n/+J0SxM3rJ7y92sb8nfhMOrlA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB7909.namprd04.prod.outlook.com (2603:10b6:8:a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.17; Thu, 12 Sep 2024 06:56:53 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7962.017; Thu, 12 Sep 2024
 06:56:47 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Topic: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Index: AQHbAzySHjbFr5s36kG7QyddcK5yL7JTLpoAgACMVUA=
Date: Thu, 12 Sep 2024 06:56:47 +0000
Message-ID:
 <DM6PR04MB65757788C5B69C27E9CCB936FC642@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
 <f47a00da-a072-491d-80a0-59b984ea92b0@acm.org>
In-Reply-To: <f47a00da-a072-491d-80a0-59b984ea92b0@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM8PR04MB7909:EE_
x-ms-office365-filtering-correlation-id: b351bbee-a0ae-4aca-a2c0-08dcd2f8120a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dCt1VzVrY3ZPb05NVUpyUHZ0dWtRQ3A4ejRFdk9IVzZ5WHBialI5L1dnb1dS?=
 =?utf-8?B?ZXRSY0ZKdjBGbEJXR29Lc0xEYUdOK1VFNUcrTTM1czlvdlA0Vnpva25hR0Jr?=
 =?utf-8?B?YlJSVEdycmlqODdYWUh4RWdzajhUSDA1K1VkYmxORU01Znk3TFFUSjZhQzZz?=
 =?utf-8?B?S21qSlVEL2J3Z21ab3RzL043S3h6VGhSWk5BbjJRTkJNOTd3Y3FKRUxTOXJ3?=
 =?utf-8?B?N2hOQ09GZFI3L0FKMWl4blYwbHFyM3JmbDI4UWd1eFZKNXVQcTJxL0w2Y2pG?=
 =?utf-8?B?MVIvUzE5R0FpWlN1SzRMcS9OK3pXR1ZjSndZV1hFYnIxM0h6K1JubHhrMDBB?=
 =?utf-8?B?UTFnWUFqRlEvT25zTks5UW1NbWFQYkVNVU1aT2M1RVIzMXhZZE1zUzhqSXVx?=
 =?utf-8?B?cHJqdjg0OEhvQ1NNTklYWWlnVk1YUjJuVnRqOEZuZXpwbDkrS2tESHRudW1o?=
 =?utf-8?B?dUFZenY5RmdCM1VySjFaU2JFYWs2VUg0WCtOQitaNkZMNm9qODZDTk82QmVK?=
 =?utf-8?B?RVVMVis5REs2V1FlWlRFcFlHa1BzUlpzaldRc3N0NGprbFVoc1FXMHZ0NEZN?=
 =?utf-8?B?OFNMMjJiUGQwVFVNMTZFZ2FoaWx5Zk9jN2JKeE9VaDVCSDBOaWFWaFJqcWJL?=
 =?utf-8?B?YlFNVFpxckt0aWJNbk9MNWJvdFpVeE5lTDJwOFgwMUFDWXk4WTYwcWd0M25D?=
 =?utf-8?B?amlLTS95QXo4emlhaEtDMkJhRlQ4cnBsb1Q4cFljK1hHcFhyZjdrSXowbTEy?=
 =?utf-8?B?U2tBaFlsUXpvV1ZWQ2RFTVBvOStHRXdFRHN6VmNLSVZhQWRUWURQZWprSzkz?=
 =?utf-8?B?ZEhoNTEyVlgraWZCL0pMNUNZMUh3UzZLNlpIaWQ0ZlZwa3NsUVg3VTJEbUFk?=
 =?utf-8?B?aXJHT0kvajJJWlY5TlBmSGh4aHJROTJlUXIrbkhwM0NoYlBJY3NUajZnRSty?=
 =?utf-8?B?bGpJVjJTdGVTNEhkQnB4N0s3VkJlbE5xdStUa25RSFRZNUpJVDhYMGMzbHNG?=
 =?utf-8?B?c0twTDVVaEN1b0pFTjFGenJ0MnkrMStzRk1ONXpidVhpNHQyMUJKSmVRdjlr?=
 =?utf-8?B?ZUhLMnZ6TGNybFFEQnRwOGtDSnVOSEdmMHhzMVFTZGpFOExMZ1g3SnMxTzFW?=
 =?utf-8?B?a3A4Z0ZBbTE4NSszMiswWWhXckMvNWlnUE5ZV2xmQmFJQkM0dkd6MlVTU0pT?=
 =?utf-8?B?Q3V2Wnh0ZGVzVkZLMStBWVJGOUJEZHlGRi9wcjRKQ083YkdMZFM1N3Z4bStC?=
 =?utf-8?B?K3NQUTlzajd5c2pyUHp0cFBRdGZKVXV4bWxKdlpiWWJFQTk5NGRYQ0dENjUy?=
 =?utf-8?B?enZwYjN5UDJCZXdac0pEVXNuWTk1VFl5RkFoT0MycHlYcVBrb0cxVE53RXBp?=
 =?utf-8?B?SGljMkxWVEpienNDTUdLY25LVXdUbkI0bzZBbysyMUlEc2ZpQ1o3VklCRU9Z?=
 =?utf-8?B?T2Q4UFkrUkxGOWg3NE4zVFlhaXozMTBZaUNZM3FiV3Y5d0NJWkNrU3dONjA1?=
 =?utf-8?B?QzNreVFKYnAwbGptYTB6dHRjbGw0cVVzejhDUTRyVmpIMDNyTWRGT3VLeHFk?=
 =?utf-8?B?bGlERmRkeG1TakFyYWViVUpxVlVYWXJGWDMwRVpneFEwL2ZMdnFMWXhmVTM1?=
 =?utf-8?B?SWVtS1NKMzVzKzlJZXAxM0c2TnBsd1NUcFhlS2VGVk1oVWpUV21wLzZkaVhi?=
 =?utf-8?B?ZkZvRHZ0b2pIbitkc0UxdEF5RGkxNzIyQ2tlbysyVE5uZlRHSUp4U1VzMTlo?=
 =?utf-8?B?YXhGRUhjTEx4QURkOFFxWS9hSTRyS1VjNDZCUitWU0N4OS9qVlpYQ1pZUTZY?=
 =?utf-8?B?TEMzaXR0N0c3S0RGbmpJbFVtYzZxZjVZblRQbGhsbDk2Qy80V1RTV2pVMkMr?=
 =?utf-8?B?VVpydVhNRnMxVVU0SzF3WUJ5ZGZMSnRTVjBwdTVNa0xRYmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ymh5a3oxcmtWb0MyejI2R3ZQQjNHelAzN2VHcWVZZmRub2x6bXJvSUROQkZi?=
 =?utf-8?B?VU4xYjdWSFJCdXlNR2VFaG9pZi9HQjhiRlpObGs5aEVLV2dZQmxoNjIydHRW?=
 =?utf-8?B?dlZxdjZNNklsWjZpdU5hNkwxb0xJTUlQa3o2aDBRMnBCWmRLN2dXdmhvcThC?=
 =?utf-8?B?OWpGYVdHVWRRK0FLaGMvRU00SUxBOWJYZFpNVmlRN3lHWW4vUjRIY2pXejVC?=
 =?utf-8?B?QUFsWUpiY056RFo4NHdvZXEwbG9ZQWI1VG5LSE8vRlBPN2pGUklYcXQyZkl3?=
 =?utf-8?B?cE9UOUF0dnR2a1QzTDN4TnlVRDJWNjJZYVV5ZkFJVm9saEtmM3BvaWI1K3F1?=
 =?utf-8?B?djJLUG1NdzFrd1ZvSzVkVGk5NWVkQVZSeUZ3VHVibEZZZzdISzhITzU4Q0hp?=
 =?utf-8?B?WUNKRThrRzQ4d2kyakRIRldaTXBUbEFPd1NOTnpXMzhrcEwzeHlTcGhrL0hC?=
 =?utf-8?B?S0FRWTdYaTRrcTUxUEE1OFlXNzBwNXhiSFg2OCs3VDY2TS9NZ0V6WUtvU1Rz?=
 =?utf-8?B?aUVDcnRWTlRoaTkwMCtiZUcyYTJRZ0JWdmlHZTVmVU55aTBidmV0SGU2UnFa?=
 =?utf-8?B?U2xnSVJaZi9wT01pUmtjSjVIMXd5bU9PRjVYMFk5UXV0QXdMWE54MTAraWFY?=
 =?utf-8?B?WHhsTDVSTjBCcnNpSEJNRXdMR0R1UTZNbTB4ZWF4bEVCcVZZUWRZSEhuNlQv?=
 =?utf-8?B?SGU2a21HNDVkQnE3Lyt4Qk5zMi9ldTloYmxoR044eXluL216TVZwLzZqM1ZQ?=
 =?utf-8?B?UEE1MStldC9ZQnNNb2t4OWhXazJTWlpQWDZFZlVTQkt3TDJoZ0hMRHRtN0t2?=
 =?utf-8?B?NDdXL3YrcHdpeTY3Sy92c3pOZEFiWGEwaXdXVmNWQlJPd1ZCNythVFNNMDFB?=
 =?utf-8?B?NlBNWnJzaTNPVFNjc0o0cExPSDIvT2dLTERmT1dGdG9BcHh0S3ZUM2xuRFZh?=
 =?utf-8?B?LytZSlN6VUJ0ZjNxeUQvVXYrSnRsYnEzd1d4N0sybi9abGpDVzdOQ2lxeERh?=
 =?utf-8?B?cGFyb0dXUmlQaTl1QnVlOStQZmJwWmRDaFRZN0kzbE1hZnlnMGY4T2Z0dTV4?=
 =?utf-8?B?ejBQdVhSdHZhZE1HU1BxMll4MUMyaVBYQlRlZ0pDTkNXNFFjUG5rS2NrUEpv?=
 =?utf-8?B?UXhSZDI2b0xhd1R0Qlp5UDY0UTNNMXR4OEJ3KzBseFI1dnpyRjlLTEdBOHhI?=
 =?utf-8?B?QS91U1U3eFdBelMvS3oyeUllejJQbGQwR3NXQWh1NGtkNDk3RHlzSDZuT1NO?=
 =?utf-8?B?d2d2OWJXUDc1WUJsT1J5ZFpQek9OTE5uU3BINjgrZGV3Qmt0ang4SVYzYjY4?=
 =?utf-8?B?bmNCd1hINmxnZUE2bU9UekhoRytkdWkzSHNzTktSa2N5MU8zK3E3MUpRUkFW?=
 =?utf-8?B?WDI5WVQxSW9lUHRWMC9RK0JlNWQ4YTFPdEVqWk4xUVlzcWtUaFJjQU96T0xn?=
 =?utf-8?B?eEszWnRMRGtDSEdwSHNwbGY1MkhoOEFGY2xlM2VGLzhjTm15RXZvSGloenZP?=
 =?utf-8?B?RkpwOGtPYlRQdkxQeWxxd0VlTDZzM0kwcFpWZGhqZDVid29QY0FTWEFvc2hJ?=
 =?utf-8?B?SjNSTE5jNzhNdVhHd0hFNzl3eFRPRnBVa0FsV1J4YWczd3ZrZWRLMHVyTVlI?=
 =?utf-8?B?UEZMcGVGbnNsVnJ5V2lMWnRYQjJmL1V5Vy83YWhoSGJaMUZyTXZaNXFMVEho?=
 =?utf-8?B?NW8rYmVjSXBYTmNVYVlWOEJERC83V1pKaS84T1M3d1RsVm53UENjVzRPdlFs?=
 =?utf-8?B?MmxDVHRTTmswMmFha3h4MERjOW5vK2FSd2kyeFp3M1FmZTdHdjRHUy9objVl?=
 =?utf-8?B?TVJ5ZnpGcUpjUFJZT2JZTUNCQmRIbEc1UzlUakNMVnBxSUV2RjVrcU96Mng2?=
 =?utf-8?B?aXRQRkw2K1grRW0rbEUwUVdRbTRLUHdHM1BkNEJJZDRMYVVMQy9YbW1GZ2NE?=
 =?utf-8?B?TXNxZTREQXB2VVJ4RUczbzR4YVdWbWM1dUJXR3lGVHJjdm9WbjI4dTBGSi95?=
 =?utf-8?B?N0svT3c3T3hYRXJTVzBrMkI4cUhqVEx4VURYVXN5VklNU0szWU9JN0VqNnox?=
 =?utf-8?B?MmYvc1NqNUhxWEVPbzhrMEh3dit5VkJrZ01jRUllNjB6NUx3V2RSWHpaMU9n?=
 =?utf-8?B?TmJqZDdDZEs4bDZ4NGJ0V0ZuaFFuYWJQcmVlNTJ4STNkZnRNTmR2aGZvblUy?=
 =?utf-8?Q?uS7u1FCayCokA/1gHEjRfACdxdF/OMzW9r5bVCjDfQTn?=
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
	sITGYhb+gOZyF+mImGBWPHf4CAwLwwCo3KuVAEmnrX+6yr+Ut1iwkH6BQieBDM4p0ERZ/V3iZ+XQQC0TvDbGVH6Vi/0f8HsZ0bcQkrdawdf0DZ7ny0FK6UNCvMpPW4XpbAUFzhNkYQWDqY+/1gi0V+TG8FxceKk22ySXPACbkeDxounSqff7gX95jpIF8plO4HZTdpb0JUMZbVUCxsikIWkszXx4gzerv78kifO52HqbK84fTD9f+yggN+xUdBwEyPkaF39X8oyQC9u5hs/CkjD4CXdr2LlNg/HZs5jHKyIg8XmEPRAtbz1E+jLV4pMC+zGfznNcUpZWwAT1QNlH1Wx4NXqb9/FhYvcJGEGPohJ16iRNV8jiDlLi+TRLTFETAQD67eMcpdoABdzDa4CCwwEJRxrZ/+O5fcZekZIDSMuDKKkYWx2bU10vRSf1Wdmvz+gOmgOFO68RJE2Gi2munk1cY7AI7p0U2Fy+mJ7/QFunpgIrCRpx27447lLNt2oLBGznWhwGHBj8E3y6O0xUcNpwnCxtIxUpARISwpkvH0MH4ja2DSfNkMSVFdfvlCNpmpzFP5D/PDcYvP2LbvKLzIWP6WYEpC5Jg2odFqRzJ+Y7Q9KnxCafRdh8Ra1RUSFG
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b351bbee-a0ae-4aca-a2c0-08dcd2f8120a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 06:56:47.5596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /rYqQIncVt2uke2SEkbDSBof4FqkVvprv0OUcZRmNAj1P7tUoRMzCUUR6ueISTfudFT8IPSQofEw9G65wsOcVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7909

PiBPbiA5LzkvMjQgOTo0NSBQTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gUmVwbGFjZSBtYW51
YWwgb2Zmc2V0IGNhbGN1bGF0aW9ucyBmb3IgcmVzcG9uc2VfdXBpdSBhbmQgcHJkX3RhYmxlIGlu
DQo+ID4gdWZzaGNkX2luaXRfbHJiKCkgd2l0aCBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFscmVh
ZHkgc3RvcmVkIGluIHRoZQ0KPiA+IHV0cF90cmFuc2Zlcl9yZXFfZGVzYyBzdHJ1Y3R1cmUuIFRo
ZSBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFyZSBzZXQNCj4gPiBkaWZmZXJlbnRseSBpbiB1ZnNo
Y2RfaG9zdF9tZW1vcnlfY29uZmlndXJlKCkgYmFzZWQgb24gdGhlDQo+ID4gVUZTSENEX1FVSVJL
X1BSRFRfQllURV9HUkFOIHF1aXJrLCBlbnN1cmluZyBjb3JyZWN0IGFsaWdubWVudCBhbmQNCj4g
PiBhY2Nlc3MuDQo+IA0KPiBXaXRoIHdoaWNoIGhvc3QgY29udHJvbGxlcnMgaGFzIHRoaXMgcGF0
Y2ggYmVlbiB0ZXN0ZWQ/DQpRdWFsY29tbSBSQjUgcGxhdGZvcm0uDQpJIGd1ZXNzIEknbGwgYmUg
bmVlZGluZyBoZWxwIHdpdGggdGVzdGluZyBpdCBvbiBhbiBleHlub3MgcGxhdGZvcm1zPw0KDQpU
aGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
