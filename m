Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096CF18F2C3;
	Thu, 19 Sep 2024 06:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726729187; cv=fail; b=BJveblWdgRzJCu6EF1F0tcf3RzHdXlmaIrtBzaH2wVCh9Q7gI6XlFaciSbu5u8uu+gO86Q/xja4p4n+gt3Puz7CgPrHj6Lj8m0cScRSZYbH4U1A2whS60i5WBOr08a9n9jpzVs38nEyfoTjVGk7L9vSF7+yzz0qqeVujk2jJ3rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726729187; c=relaxed/simple;
	bh=VUH1eTvq0Tqh7TG0ToTWh6OPO2TvPU4XStGcHBvpWvg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pp+oshLAI3OW8bqYTEvEOBInFwPLFfJaBKNUbUosF7DEGAjMg0lQ+QzkR9/2X0+0S6INc7nbl999Amswuz+IVL6JMU62gBrWhHkY+GHH6VVEAaEo1BW0HZFDvjuS2YvGKkiBTA8pSg9amJ50kGxPF8OKik4FlK2kjkuAkuZQDGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q8l6UgSx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GFv4ntfM; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q8l6UgSx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GFv4ntfM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726729184; x=1758265184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VUH1eTvq0Tqh7TG0ToTWh6OPO2TvPU4XStGcHBvpWvg=;
  b=Q8l6UgSxI/tLfXde9vG4ebvh8ZxqHBqyE1t9gNf78H9EvkjAxunFDLGC
   au0x8Bly6yQC91b/r6WB3OGZde0eeQYnnICrKsYBiNM78/Wj5qXoJv/HL
   gyG73yGi7/Sq255x2jmc1L9oRYYGoIaQ+ZOzR5sX4c2leFIvbg5SSQ7jp
   C5+EMnyLPDZTBSENzkYcztNp3Qj9qLw8OTIpd1oh3lIN4X3y5sMmWblql
   WaOQAptd30RcVKyis0ihhKaFyqEL4UmV7kTH9Nu6wCgrHx1i6x1edhrc8
   PvoT4cL0X46l0ATMWlJhWwawQtkVyiAnZsowulRda8DT3/0HKmRyVzgNy
   A==;
X-CSE-ConnectionGUID: lKT9HCKMT5i/98m7nDD+FQ==
X-CSE-MsgGUID: eSgeihVkTkCfGLiA9GYPxg==
X-IronPort-AV: E=Sophos;i="6.10,241,1719849600"; 
   d="scan'208";a="28048004"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2024 14:59:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c5FBhlDc+tab8hHhTU9LqiYhEv/8o2ieNAb3ft0YPqNWEyyzKor2FiftozOnacfriWJPyxwCFbKaEekIo28wD/iZnOFzsShg6GKkaDV1w7zgp492HJhoBPNIXnygftxuc5gahHscXu7papV4QuJABZ408F/FMqWhvkNg0pz1mkmazDH/t5nGdjdiqyzvhQbUHOXa4H5fNRjxV0ZmbjBTy9TYjtlT6jWDzjtQmc/UGS4Of7hCuRh+u5Tie5m7hY5eOEXzCy0qjdpRF+54KWJpOWOYWo/j5d4aIuilFEIi0jut5O2JeObKOv/zAen6dcDL7gwB1YxLSn6ZJuQipRCqMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUH1eTvq0Tqh7TG0ToTWh6OPO2TvPU4XStGcHBvpWvg=;
 b=l5GuHYh/Hvb++oQBrAWB37d48v0nHElCGMTcBaAHRumq0QgI6odSVv5TcQRyL1f8zdmuujMir8W1eLJia/xkh/KDkxg/Cnx9MfUGHZfvDZsKAAW2f5wbsIeKmlwn3rwejl+CasMpWVkVTLReUpw0nkRRhplOLwOueyMG0/c+ynaHyu8NIJcyIjG1lOmu2X5Z5MhBmAyO2zeAzghRVXHYwzkDTvhTXhlMl0504lzRrcXqPbk8G7HlcYUjh8q2dTYRaG/ohfAoKX7x+/rsS6bxwZ3PmIVGy6QKXDoVfphNmg8NtfNz9UGo2D5dYl+4tZ3AGjzO15DIy/xR4hbCYnx+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUH1eTvq0Tqh7TG0ToTWh6OPO2TvPU4XStGcHBvpWvg=;
 b=GFv4ntfMFrDcA6qLPjKuvxPVTJenYQfgtV4KbSEymB7lHzj7F8CswUP2PnccYBfsXMRoKxNxTRR7U2ZYPpLOadjXwluj+HF/FxaZRLLd6DOjxXBrKHR4+jiyrWMCtrZKRQYg/qamXnuGj0Aq9FR7SGU5r/T3PyoCNtowinRAV0c=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB8098.namprd04.prod.outlook.com (2603:10b6:610:f9::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.17; Thu, 19 Sep 2024 06:59:36 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7982.018; Thu, 19 Sep 2024
 06:59:35 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Topic: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
Thread-Index:
 AQHbB0P1xNgr2xhkc0aS4aiTVb0xxbJa/qOAgACMpLCAAIKegIAA/pQAgADLpICAANNaMA==
Date: Thu, 19 Sep 2024 06:59:35 +0000
Message-ID:
 <DM6PR04MB6575FD6BCCDC3327885E6DF6FC632@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240915074842.4111336-1-avri.altman@wdc.com>
 <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
 <DM6PR04MB657549C63703AECEA2169CC4FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
 <b7a05da9-7a80-42f7-bf95-379d78f3296b@acm.org>
 <DM6PR04MB6575F0F368FD49B191CAD7D4FC622@DM6PR04MB6575.namprd04.prod.outlook.com>
 <6bb14e23-7711-4d27-8efa-4e60cd737fa5@acm.org>
In-Reply-To: <6bb14e23-7711-4d27-8efa-4e60cd737fa5@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB8098:EE_
x-ms-office365-filtering-correlation-id: 881b207d-1e43-4424-bf72-08dcd8789f43
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Rld1SXRuZVNmZW9oMDhXdCtJZVNHTTZ5enAvOW53M3dFWVE3aktKL3hpcUhD?=
 =?utf-8?B?U2s3dGtKay90OUViaU9wY1BZVi9DSW5NVVU3UllSVHJ2N0s1bUFyNXhIT1Vw?=
 =?utf-8?B?MzYrdWRKS3BTNlluTGw2UWkzN3JOTFQrZk1WKzBXWkVuMDdxL3B4dHlRQnJz?=
 =?utf-8?B?dmJjdnR3TWpoaXIrakdoQVJCTVAyUWl3MVRGV2QySU5JeGxJYVhpNnkyS3A4?=
 =?utf-8?B?TlVQd1JQNG9ZSS8xUyt2VGZ1MXBNL1lsWEg3UWNzMXVhdmRlQjV3R1BCWExt?=
 =?utf-8?B?S0dUSXM3bzZaZzdoNUphOCtWNkJsWWRmME5DZjhiYy9tbkRudlJSQXR0eHRh?=
 =?utf-8?B?aUtKcGs2SDRwYjhNbzJBbFJpSlNFMnJGeDZXSC9ZV0w2cnpvZHIvMjh5Rmxw?=
 =?utf-8?B?ZUZXN3hHVERCQnp1RWlVYytab0hWSTd6NnVIS01RNXZFM1FQL3Z1bXR6OVJE?=
 =?utf-8?B?eUNXTmc5Q2pQUnVEN3htT1dxc00vWGpMWittZDlkVUJYVFhnSVFQWlloSXBE?=
 =?utf-8?B?dGdEanhabUNlbTA1ZHlJOEdwYmdncXVyZllPaExFZ0tycTNtSGdqSnZ0cHpt?=
 =?utf-8?B?UFg5YmlEekREUG16UjNpaS9pVWIwMmJzVFlla1N3bnhlS3R4d3dZZERjU0tR?=
 =?utf-8?B?NE1QdjZyaE1Ja1YwYlg2UkEvODc4WEQ3MnVIS29tNFdwVVRoaW5FOXBBT0ZZ?=
 =?utf-8?B?MnJaQW42WnpRUHRWMGNlajdYY0Y3OFZBbWQ4Q1JIUXpTNEFaYWEvSlRpNnhY?=
 =?utf-8?B?cUF5NzMxMG81Mm5VdlhtWHpBMFdWTGw0UW9PckMySkRlZUdwQWlZNTZDRy9L?=
 =?utf-8?B?SFBPTngxUEpmUWRvUEg4L3FVb3I0VFFNQ01sTDJJSUNtUEpQb2tJMEJ3ZHhM?=
 =?utf-8?B?QTgwV2M3ZXNBZjVxeU5MQTM0K2dpSTRzTTl2amJwQkpVa05CalU2TndvRzJJ?=
 =?utf-8?B?bXpWdlB4WnQ1bEdlVzY3QTNaS3RWZm9Qa2RiQkhuRUh2dHM2aW90clREY2tn?=
 =?utf-8?B?STdveDFkTkZWQXdjeUFQbWdCWHBrQXNSRXY4N3o0SXM4d2EyMUhqeEdYeTFn?=
 =?utf-8?B?M0dpS1dCZWxFTHcrUFpFdXVkb3lEVitmUzRjb0Y2NWlxQXFHd01kNlkzakxz?=
 =?utf-8?B?aEQrQmd5MHI3QmlWME5pVzdBVHVLSUl4N1hTRWNPZTBrUmxYZ3cwU2RuSkhH?=
 =?utf-8?B?U2QrUTZqTzRsOVh0WHNzbWx0UzdTVWhQRzA1YVZwa1hqdVFwaklVeDV0S1dV?=
 =?utf-8?B?a0lEd3RVd1hRZXhtNFFDS3NjQ2JQTEpRcXZVemZSQ0VLTFZQSHRhVXRDWm1j?=
 =?utf-8?B?R3l1MXZYa2sydFU4UUZCaUFVOEtmVXdVSWFCQWp3Z0d0TU1rOEpyRkRGOHV1?=
 =?utf-8?B?OWoxYjlKbjZ5UHY2ZUYzaHBSNkxYZ1JMTzBNd1B2R25JVjlBWU5SenJLdWpt?=
 =?utf-8?B?VXpFMUFlejBNY0U1c0NHU3UrNGhmUm51NllrZ3pjSzBWVSt6eXdIRWV4ZTh6?=
 =?utf-8?B?RDdyUGNEUDh4OEZkb0Ezemd5aVQrL3dTSEhXY0xTMkMxVlA4dTF0aGFOd08v?=
 =?utf-8?B?K2JlQkNwK3p1K0Z2RnZ3WGx0UUptZTN3d3lIOXNFRkxCR1h1WXZmeEpHUits?=
 =?utf-8?B?bnZIbWRDOStJUHYyOHZIeG9PYTFiN3lWM25NbzJFOWFQTGxSUjlrR0Vxa2FZ?=
 =?utf-8?B?U3V6WkdFcTdSb0hMSXdXN2JUQUZZNWVYSzlKR2xsTDQrVExHVzJ3SEVRZDFM?=
 =?utf-8?B?WFdjL3NOWFNIRCs4V2lhMzlCc0lCZyt6NU5ET1kxUEhZSUVVSjVGRGRvMTYz?=
 =?utf-8?B?dVhkb3BRTlJOWklnVXl2T0RVRFVHUHo5ZUh2VzRZQS9MV3FZZy92dWxYdi9J?=
 =?utf-8?B?RS9lRk9NaHB4ZkFHYjBVajVhSlJ3ZWI0eUxVMlVaT0tTQ2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QnRPRzhoZjYyQzdCUTdPN0grSC9zSnZMeldWRG04cmw4a3RHSno2ZGRaUjk3?=
 =?utf-8?B?eTZoaDdBaGFFSWRqSlVPdW03Z2U1aXQ3eFJWWmp5U0JoZlhwZ3Z0NUFuL2tj?=
 =?utf-8?B?cmRLYXo0cU5HYVJrQlFJYUR4a2JENktkZXJUY0xVMk9SeHRremhYVUZuTG5i?=
 =?utf-8?B?T0F3ak9PMzRpMVRoNjdCQmFuQnNlbG9Wc3o0MnhPZ0NPSnB6azMwUUl5WVBP?=
 =?utf-8?B?Rm0yZ3JGN0RxSHF0NnU0TGF0MnF1emdhdW5jb09rUWFYb1hxMWRpSUc5VCt3?=
 =?utf-8?B?VFVid0FBbDZjWmlnZzdxTU5HNWdyWENYTUhVZzJRZUNuNDlBeitoWGx3bGty?=
 =?utf-8?B?dmVMcThUSFhDYldZLy92bCtoWHFpZUp4OGZEcXhIaUJLT2V4NkJCQ1NsNUtN?=
 =?utf-8?B?Tm1hTVJJcDJoQjNPVXZxNnYvS0tkNzVwSGk3WWV1RTBndXJNVUNyNWN3MHd0?=
 =?utf-8?B?bm11clJ3dXd3ejNaMEowTXhKRmg5TnhoU25zVlFSZnJwdSt2amp6VWNYNUxS?=
 =?utf-8?B?aWR4ZDlOMGxUakVTTGFSV0dERUFmNEoybFNHejRNOUYvTTZQUnRHYmU5Qmor?=
 =?utf-8?B?Yjk3cFd3RWl3bGpWSGxtWDV5NFIwcjA2Vm5Yb0VFOUR5NTdUTkpiTHR3dDUx?=
 =?utf-8?B?REZDSGptdklDS042S0lZWDZ5THhYTEdqOXV6YzdSMlp2WVBEWTg4WDlwb1h3?=
 =?utf-8?B?MWJnS2duSnZ5N2xLTnFYUzArMzVTMEpCS0Y0ck81OEZyUXI3cUpXT2hLNWtu?=
 =?utf-8?B?cXN5aEk4QVAyWmdPbEtNdFRrSWlZNkVUSFNzU3V3aWl2TnpWdDJGWnBtNlNu?=
 =?utf-8?B?Nm5VT2xNU1Q1MXBmRmxnVFdoRjAxMjNtOEh3MzlQVVFNU3dXc1VGYm55akt2?=
 =?utf-8?B?SVVoV29KQ0g4TDU2Uis5eGZFbWhxdjZVa1JoSzRoYm4wL1luemNydXBBTnBB?=
 =?utf-8?B?SGtWc1hCQWZCUG9RMlZPRk9SMjFEcFZSU3hnYlg3d1dORmNJMkQvRTYxelNh?=
 =?utf-8?B?MkgyU0Y1Um54R2xuV0pCYTQwZVc3UVV5OFhsL1BKMTh2dnlrWEpsVkY4STcw?=
 =?utf-8?B?a2FEbFVnUVF3S3VrTHhnVGk2TWVqY2dVSU82M3VPRlRsY09jcGVNbHJEWXUz?=
 =?utf-8?B?YmJWclUwU2JiQ01yVWh0MnJjUUk5VDJjNDV4MXh1OGtHZEpDdkpvZEwvWUhU?=
 =?utf-8?B?QXZ5K3NHeHk4aXlUTGs0bWRpMHVqWEFQelIrRlQ1d1NOZjlOdDBaREhSek9K?=
 =?utf-8?B?WE1wMThzdVg1Z2RLa0NhUUU4djAvL01yK2tESm1nSzFLSk5CR016bEl4QmlS?=
 =?utf-8?B?czQyUVl5U2xNQ3NzSitnZlhFbDczRGhNbkdURFc4eHRsWGhTOWhvNHYzV3F5?=
 =?utf-8?B?cXAwVitmOHdlbDBSVFNHY1RKTm94MGs3cThBS2dPTmNpVVhYTG1INGdwdkhQ?=
 =?utf-8?B?YXlJeUJVUUNzL1N2NmVzQUUzTjVQUGxLaHBxL21GL3ZoZnFLVUI3cy8yMmNq?=
 =?utf-8?B?R0lja0hkU2NkMmpQWGlkdERUL3FTSWNHUFh0ZDNQZUtkUktQck9TQ25XVXpj?=
 =?utf-8?B?b3haM3ZvZVBoYnVaczNVRE1CNlVwWEJWdFFia01wcHZaVU1DanBnNmUzbHN0?=
 =?utf-8?B?MmN1bWpnN1F5aFhSeUJnTzdEQmpxOXlNUmlrY1NOT3pudjgxY3ZRME9Tc0hI?=
 =?utf-8?B?VlR4a1F3b1dqbEpTelNWUXd1TGV3anRadW1iSmRFek9pYnlIQThOK295N25j?=
 =?utf-8?B?ZEpUTkRFOFFTL0dPMGhzbE1HVytvV29TSjVFMFpIdzE4N2xoOUVva2VHbStL?=
 =?utf-8?B?K3lMZU1FRHRCNjYvck1sdjZNb2dNMHVZZGsveS9FY1Zmb3dPRmhXdFZ2UHVP?=
 =?utf-8?B?SjRQSVhFaXBrUzRkeHlrRVpSb3gySEZJZE03UnYyYWpnakk3YkFBOFp1SUdI?=
 =?utf-8?B?RitGYzVCZVQvOXBlTklzYUVlMVRBVjZhTk02ZXRBSUltcTgvRkMvSndMaS8w?=
 =?utf-8?B?M2crZkR1L1pQbHBvdkZ6ZExlb0pHbEZrRjF4bXpaZVFGd2ZLMzdKL2RyVUJR?=
 =?utf-8?B?TURsRGZ1Ulc1M3JrTHZrZUNucllOeFNUVVJTQVBERnk0RCtHMk1QZWptVllO?=
 =?utf-8?Q?H4u5KHNpLX6sKAwJ96RTfF0Vd?=
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
	TDXwhyURfkYKRdENlWKVBIbXW2jt0lOs74ladGh9zOW5g5eEq772WIpof01TwROxOShYzy+mbFmqwiWY5CYfvBcwDzY37EUgfIHTG/4j+hf0p5AigFwlO8eOubnc8kPaoxayNUFsg/ueRXxYz0O+iWrBRXUpc0BCReF/toXQpi6HjItJUQe1NzYZpaS26mvVv59cquQs9iD4Po0GlcjirJJYeOAsGoORROce7+JZpyxbHSkpT+fFPucY/j0RSUX3fgdrEvPuxrXDo8iqHGIkDuYdwA+3AYFG51e44nS533uZT6Nj534fhVSLHHV0BGMgJ6elVR7d4Yu6dTLWoZWkbMwY3jvYSEnXfWvKGYjDAlMOntPkCO97b1gdwRKLCceZEO0t6LEC+/VAF9MKhOugKqOC2K3dcG7komcbX/neIBkhBn/lr15iFcwea9aTOPNT4D5Cw5yaMZkOrmhnds6/MstCRHSiiMPVusiN8nga9+yan71dRrWLDbtg1U4ky2dlj9E8BLFlU35GQOeVa/Vhv5ugKzQexaw9BKSigfsv/iZcLhecfwbhB6GnilZS4xkf/lPUrH4Dzz0JhvwiQQoi0x2ognjd4bvrp8aBy3glmF5hFYe7qZYVobvzv4G03EpA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881b207d-1e43-4424-bf72-08dcd8789f43
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2024 06:59:35.9373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 596sqRI5ONqq0+wnZGZ2dymu9coBGSol+VgOMSaVCoRpPNZ01CeeTsVbzbow2OshZU73ErOLw3uq98BaHTEW7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8098

PiBPbiA5LzE3LzI0IDExOjAzIFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBNeSBwcm9wb3Nh
bCBpcyBtYWtpbmcgNCBjaGFuZ2VzLCBhdHRlbmRpbmcgdGhlIDUgdXBpdSB0eXBlczoNCj4gPiAg
IDEpIFplcm8gcXVlcnkgdXBpdSBhbmQgbm9wIHVwaXUgaW4gdWZzaGNkX2NvbXBvc2VfZGV2bWFu
X3VwaXUNCj4gPiAgIDIpIHplcm8gY29tbWFuZCB1cGl1IGluIHVmc2hjZF9jb21wX3Njc2lfdXBp
dQ0KPiA+ICAgMykgemVybyByYXcgcXVlcnkgdXBpdSBpbiB1ZnNoY2RfaXNzdWVfZGV2bWFuX3Vw
aXVfY21kLCBhbmQNCj4gPiAgIDQpIHplcm8gcnBtYiBleHRlbmRlZCBoZWFkZXIgKHJhdyBjb21t
YW5kIHVwaXUpIGluDQo+ID4gdWZzaGNkX2FkdmFuY2VkX3JwbWJfcmVxX2hhbmRsZXINCj4gPg0K
PiA+IFlvdXIgcHJvcG9zYWwgaXMgbWFraW5nIDMgY2hhbmdlczoNCj4gPiAgIC0gemVybyBxdWVy
eSB1cGl1IGluIHVmc2hjZF9wcmVwYXJlX3V0cF9xdWVyeV9yZXFfdXBpdQ0KPiA+ICAgLSB6ZXJv
IG5vcCB1cGl1IGluIHVmc2hjZF9wcmVwYXJlX3V0cF9ub3BfdXBpdQ0KPiA+ICAgLSB6ZXJvIGNv
bW1hbmQgdXBpdSBpbiB1ZnNoY2RfcHJlcGFyZV91dHBfc2NzaV9jbWRfdXBpdSBBbmQgeW91DQo+
ID4gaGF2ZW4ndCB6ZXJvIHRoZSByYXcgcXVlcnkgdXBpdSBub3IgdGhlIHJwbWIgZXh0ZW5kZWQg
aGVhZGVyIC4NCj4gICBIaSBBdnJpLA0KPiANCj4gV291bGQgaXQgYmUgcG9zc2libGUgdG8gY29t
YmluZSBvdXIgcGF0Y2hlcyBpbiBzdWNoIGEgd2F5IHRoYXQgYWxsIFVQSVUgdHlwZXMgYXJlDQo+
IGNvdmVyZWQgYW5kIHN1Y2ggdGhhdCB0aGUgbWVtc2V0KCkgY2FsbHMgZm9yIHF1ZXJ5LCBub3Ag
YW5kIGNvbW1hbmQgVVBJVXMNCj4gb2NjdXIgaW4gdGhlIGZ1bmN0aW9ucyB0aGF0IGluaXRpYWxp
emUgKnVjZF9yZXFfcHRyLT5oZWFkZXI/DQpJIGd1ZXNzIHNvLg0KT25lIGFwcHJvYWNoIGlzIHRv
IHVzZSB0aGUgZmFjdCB0aGF0IGFsbCBwcmVwIGluc3RhbmNlcyBjYWxscyB1ZnNoY2RfcHJlcGFy
ZV9yZXFfZGVzY19oZHIgIHdoaWNoIGluc3RhbnRpYXRlIHRoZSBVVFJEIGhlYWRlci4NCkFsdGhv
dWdoIGl0IHJlZHVjZXMgdGhlIG1lbXNldCgpIGNhbGxzIHRvIGEgc2luZ2xlIGNhbGwsDQp0aGlz
IG9wdGlvbiBpcyBsZXNzIGdvb2QgSU1PIGJlY2F1c2UgdGhlIFVUUkQgaGVhZGVyIHNob3VsZG4n
dCBoYXZlIGFueXRoaW5nIHRvIGRvIHdpdGggdGhlIHVwaXUgaXRzZWxmLg0KDQpBbHRlcm5hdGl2
ZWx5LCB3ZSBjYW4gbW92ZSBpdCB0byB1ZnNoY2Rfc2V0dXBfZGV2X2NtZCBpbiB3aGljaCB3ZSds
bCBlbmQgdXAgd2l0aCAyIGNhbGxzOg0KT25lIGZvciBjb21tYW5kIHVwaXUgaW4gdWZzaGNkX2Nv
bXBfc2NzaV91cGl1IGFuZCBvbmUgZm9yIGFsbCBvdGhlcnMgaW4gdWZzaGNkX3NldHVwX2Rldl9j
bWQsDQpXaGljaCBtYWtlcyBtb3JlIHNlbnNlIHRvIG1lLg0KDQpUaGFua3MsDQpBdnJpDQo+IA0K
PiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
