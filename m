Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3138635A;
	Fri, 14 Feb 2025 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739555216; cv=fail; b=JfCB6BDgFRanPRJRtPH/3DkvTlGCvDzhDlquouxApPziMSrU+5axyAxz0MSch7bWUswOZBYDjCW1B9uI/7qiUspY8h6RFfJl6lGN8VsKF9xFMB/xO5NbMkCsICQJNn3iASPWA6fqvM9iaEw7ojUqz5AxAAczOJOp4trFFz80kS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739555216; c=relaxed/simple;
	bh=uqaA3zN0x7OP7qaQwtKlkbw3tXubqt+4aRGGv6ihvQM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QIYwQxalrRLWZ6MLDEToym50McpJzFOKzjgCCyFuhKix85YL9U2DmM55QqZDTVQtHjA0ocLYmP2bg7ktEzjKzdTvLULIa6NpbsABxeeC2ctlerT+zNZnErj73yCqEtI7IeDtpuTeVcepe+PTHiJliQRnwXosQVk1GoaI4g2Y3no=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=dTIsYfHM; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="dTIsYfHM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1739555213; x=1771091213;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uqaA3zN0x7OP7qaQwtKlkbw3tXubqt+4aRGGv6ihvQM=;
  b=dTIsYfHMEslXbjg0DQKWDmXR+Ryi23jNF4Q+63t38QAt02KOoanBGKfI
   SmjxXMqqLK4rw+0icsEglTii6Y96s2ZMxpzELF4AO047NhAmY2sirFKH1
   eRXbPrUD6/+dhowSCLIwq147AQK2FlSB1WvhXVcQSLAi+vIhxoW04mM99
   JlmNBMVuK3ARwA8/tLtwS9SbOslev6SXI0N93EAilOCvKWi8h2OW2gdH+
   A7iboRo8pyovcvALdvNcET+M7cLFI+ARj8KhV0FJQhUmhb49Nx+G2KzQW
   BtnHcm6k1Mc5NpUnKnZcEe5WhDoFGC1rpVWtVyCc4B1YUyWZp68wuiPyx
   g==;
X-CSE-ConnectionGUID: O4B1IZbyQw+Jvvhn6GqZTg==
X-CSE-MsgGUID: 3R0EhrZSRt+/WpcPQcjscQ==
X-IronPort-AV: E=Sophos;i="6.13,286,1732550400"; 
   d="scan'208";a="39129180"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2025 01:46:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zM/q01LbjMkPXIkD7mJpCVrpdsiXOVCkjru3uJS4Z412OzYyKxsIbtiseYLMa/UKUWYUrTsW5/8k/mlhlEWEaarD0ZvWEufKMzqmLmZMVSt7TozPkcpHg1W+UR+CyJsiRE3mjm18t5Jv1ALpPBQnS5TVA/Xm1odBaIwgHRz4TfoRGBuIV7A+Tv/y/Zt41LEuEqOqYcDH6t6jfCso3AP9oIvKdsB3ACl6nFbC8ntrXK9zoDI154gL/nKUbA3k3lIuRP4UeOeAs8Wl7YMEuQa6l7lxdVNK8DJPYJaDumC1a8cgAL8RGtFuch+/S4nvwQzzNUD1rjCKtUc3wnqhPzDNpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqaA3zN0x7OP7qaQwtKlkbw3tXubqt+4aRGGv6ihvQM=;
 b=AciJlqOfV0PIJ03qBatBXD6mDKcKBJOmpreTynXl+V9DcFutDcbYub8F4R9e03UgJTB93VitNFTqgxd7zD9C/2CJpDQjpWYN4VsfFeazHRLay8jptifalwsDj0e3AALqgUlOgQZ7R9rPeN3d0ffFilbqF5O48jtN7RmzxmPpBMXZY0Mcib8hcPxTRhwijopa7JIcqfHAMxcMKmkpktfZ0sjp5AO4BGDM5jO033VRkAr9RxaGqvfjDaVPa/XUXrXCUzd7XGlZO/8y0zwbh0fxq7Tzwuyqik2cF1sblGPuE2mf/wRFkBmKb3b8sB6/jL+df+t/79R9T+Mc+JlouD44bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by PH7PR16MB5065.namprd16.prod.outlook.com (2603:10b6:510:12d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Fri, 14 Feb
 2025 17:46:47 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808%7]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:46:46 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "keosung.park@samsung.com" <keosung.park@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>, Daejun Park
	<daejun7.park@samsung.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Bao D .
 Nguyen" <quic_nguyenb@quicinc.com>
Subject: RE: [PATCH] scsi: ufs: Fix incorrect bit assignment for temperature
 notifications
Thread-Topic: [PATCH] scsi: ufs: Fix incorrect bit assignment for temperature
 notifications
Thread-Index: AQHbftrRZIpRLDr4vkm1nRLDOID1RbNHEqow
Date: Fri, 14 Feb 2025 17:46:46 +0000
Message-ID:
 <PH7PR16MB61965AFF2D91331975BBD24EE5FE2@PH7PR16MB6196.namprd16.prod.outlook.com>
References:
 <CGME20250214105219epcms2p3a60810a14e6181092cb397924ce36019@epcms2p3>
 <1891546521.01739535602406.JavaMail.epsvc@epcpadp1new>
In-Reply-To: <1891546521.01739535602406.JavaMail.epsvc@epcpadp1new>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|PH7PR16MB5065:EE_
x-ms-office365-filtering-correlation-id: 6395c2a6-d38a-45f3-ddb6-08dd4d1f8d58
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y2F2WXZMUVdXMjkzMTAvRXdVWTlxOGo2WkxTdkZQcDJQRnhWeW15SkVBUWJa?=
 =?utf-8?B?TE1JMTk4MGdWYTBOYitORWI3b1BCK21ucHdGdFlKVHlXbzBzWGEvWnFMZ2tE?=
 =?utf-8?B?U3JmbloxaWdSbHlnZUZqS1lQNWpSQ1pSdHhlVDFCYUpXTDhmcGttREtYMms1?=
 =?utf-8?B?Z21jT3RKcDVFZ25hTXZsSmJOdzVMSDM1QURNNXRUek9LTU1idnNGZHNOQ1hS?=
 =?utf-8?B?eDAyYW9LTW0vQnR6S2xxM2tJQjFTa0N6dkMyK2UvTEp5enhoeXh6M012dnlM?=
 =?utf-8?B?SFg4VTk3bGVaZlQvdkxPUWRzV21DYkRpTWcxaGpzd3ZSc3A2T2hPOEJnV2Yw?=
 =?utf-8?B?dTd0SXZTZnduWmk2L0MreVR2OXFLcDcxRjFmY2hKbXhGT3Bmb3VHa1VUbEhZ?=
 =?utf-8?B?OU1POVJRRzhoZjZram5sSkdqSnZDRHFXOU1mT2o0WEdSUXR1VHBtUFVGOSsv?=
 =?utf-8?B?QyszZDJuMGdDQnlCM2VXd0JrU2pKRThpNXZaUEVPQzhvTWFEL29xV0R0anpk?=
 =?utf-8?B?VFlxcVIvdTdHQ3BPNlVVeUNRNFQwV1NjUUoyWXhsNEFvMDJ5Z3IvNlNiNmJL?=
 =?utf-8?B?UlZpTkVuQVVmcmxhM3czbFhURTBXclZBdjB6akxOUlJWaGtGOTlWTENTM1lP?=
 =?utf-8?B?Vk1UeUh3enE5YUpEN2lxcENUV0hTSkhydTlrd3AxUU03ZGExOTFrMVdNVGUy?=
 =?utf-8?B?YllMZmMxeFRFdlBTd0lHQzR3QnZveVRWR1dEc0FTMzM2QTJldHk1QytoQXEw?=
 =?utf-8?B?UWZYRWVFVTF2ZlZQYklDR3Q2UHZaTGxDMy9pSkhxc0w3emVDYkZyRnJvMGNa?=
 =?utf-8?B?cFlVZHZGa1ZtZHR5SmlKaHk4RXYvOE02d1c2ZTZpTi8wYWpPdnBsU0N1aGd1?=
 =?utf-8?B?MjliMndUSUNsWXdGTWpRTi9va0V4Vkg5MXNuWStxbHFUQWg4MlZEWFd1VE5m?=
 =?utf-8?B?NXMzcVRVZHBpU2VQQmlqQktqNjRaNTJWZG9MN3VqQzh3T3lFcDY3ZUVUNWlJ?=
 =?utf-8?B?VVQvbzRZZHF2WlBUZTV1RG5ZeWVVeVFOUk1iU1lLbEx0Nnk4R0hBeXRPNDFD?=
 =?utf-8?B?YnZScWlXc3Z1T3RpZW1kWjh4anVaaG9tL3Q4VldjbnZlTnNSUXptc1ZYM3Jx?=
 =?utf-8?B?MGVKMEFBdy9DdkYvajUwa1YyN1dpTXdUcy9RV0dlOGEyc0ZEaFJaWUwzWlhT?=
 =?utf-8?B?aXdOREE0RjlRSnFNWjJXTkR6Z3prSENzTWNpd3Uydm1SNG1FeWtEZGp1NFh2?=
 =?utf-8?B?TGdsRldnVFI2SEtFMTJFeTRXRkhXQ09EU2Z5WFdxT0tkdThGWUxJdUxrdFZq?=
 =?utf-8?B?ckdkVDRjNUgySW04SXRsdm9EYXdYY0xnQThpQ0o2dWVvSHNqdW54M0d4VXRx?=
 =?utf-8?B?NFErVGlPbk5ybG9vcHErNlFCMWN3YVRrcjVsZkhDZldpMFo1ZHc4dzFQUDJr?=
 =?utf-8?B?ZVRMcSt0NlF4Y0hydnJ6MzhvWjUvRFQ1TTdoMDB5WlRldzA4M0tEenBzNWVu?=
 =?utf-8?B?RFJ5ekViM3p0b2tyM3ZhU2t0NlgrcE1LRXI4cXdpdnJlWmRCK043aTFzamZh?=
 =?utf-8?B?K0p5SCs4QzhlbFBkbjY5V20zVittVjV6d0xnWk1Dd3c0L2ZHWCtCdmFZbGNG?=
 =?utf-8?B?VEUwbWtWWHQxMkdrWllxUnVOai96aThFVXY3bExjaGdyZGEvanFJK04wY1pn?=
 =?utf-8?B?eUFkRnN6WGlPODB3KzMwWlc2SC8vTkxYeTdMQ1JJNWx3VDRyeE5qMmJBTnJk?=
 =?utf-8?B?VU40dkdDdEdsWGpXOFE0Z0FzZEplU0JicVcydGVtSDllNUlDdnVlR1p3L3Zy?=
 =?utf-8?B?ZXV3MDVyNXJSelRzd21hY09FUG8zWGFGVWIzU3U0d3g2NnlkNC9NYTNEUUhE?=
 =?utf-8?B?Qk9GcTg5dDdoOWtzeEZxSFNycDFkblFEaHNQYktLNFduYnc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGF6ckVXL1A0UG5hS244ZERXMG9xV285azZHbitYd0tVWVh1bzNLMEMxUXov?=
 =?utf-8?B?OHdsTVN2VmtqSEpmZ2xwVkczZVNQNm1GeUR6alNzR1VOSU1OdE9abyttYzBI?=
 =?utf-8?B?WWkyVzU1TGNoYUd4eFdWNEhHc21wQ21rMWsybTNMRzNxR2ZrRWs1aWg5STNv?=
 =?utf-8?B?cU1jNmRiS0Jhb2tJdjl3WStYQ0JLUlo2OUwwWnJqUE4yTGUrMEhqcWZWYnFQ?=
 =?utf-8?B?YmZwUCs0MnhRMnh0YnR1Ui9kamVOa1lGWlpPZnVwT0xyZmtDcGdFVjZQVjVR?=
 =?utf-8?B?d2JpZnVrREI5M2VxeFlnellsdVVjcnByYjl3czlJb1A3RmlLWnZCOXhTSXBW?=
 =?utf-8?B?bzJTdFdVWW9OZXgrOEJRWE11T014TW43VGhuaHhPR2lya3hOc2hBS0QyNzhH?=
 =?utf-8?B?R1F0SVdsdDB6WS9UNGhBWWdJVTAvTStmNVlvam9aTXd6aHR3ZGx3dHczZjhn?=
 =?utf-8?B?b1Vud2FsVWNoaHFMbExzQ1hoWHZsSWtnRGJ6Sm9UMmZWUm9nZGVlTWlqWVl5?=
 =?utf-8?B?WWxRYU5Fa0laOU13OU5La2Q0RCtycXhWeFRNc2hSQjNBVFFQS1hLRkVVYmtP?=
 =?utf-8?B?N0QwbkdKVFVienI5bjdXbUxiRFhVWjNnWXV4S0M0SlJrYzRuMmdGUFJQZ1lU?=
 =?utf-8?B?T3NCOGpGMDYvL3FwSFpNcTFXWElRaGw3SDRUS1VyeWprcEZYRmV2eTVtNmJp?=
 =?utf-8?B?U1dBTGExdlFqbFlPVFVzK2lES2xLR2tZNzJFQVA1d21TamJOT3lYeXcxL01j?=
 =?utf-8?B?aTVHVm10Tmx5dE5OVUZmZDJIUVIzZTJ2MU9jVkFJRVBObGQ4YWdLakloYjhE?=
 =?utf-8?B?bXFZUk8zR1dhOXpOckY4T3pRNlBoajcydkZnR1VFLzFKc0NoOTRZeEp0SXdj?=
 =?utf-8?B?eGoxOW5oZzIyWWVCMGVkaW9RdWxsOHN3UnVmQ3ZublpMdVVERE1BTHByNm9B?=
 =?utf-8?B?d1dXUVk4UzVTejg1Njk2bldZbndOZSs3WjZZQU9zRGtpQTlGK05BUHZxRXBj?=
 =?utf-8?B?Y3V6Tk0yK0xHYU93MFZ3VjZuaW5qSGdyQStXenFkZksxekJqMUNRL1BwMkdv?=
 =?utf-8?B?eTZzUFZuZHBmTG0zdi8zbGExNU55b2NiT0w3UGlZRGwrUSttYWkwSUN3eVFy?=
 =?utf-8?B?cEwrWklTM3VEdUQzNy80Q2ZwdXVobzdQbWo5NXBGSGdUTFRmSlNZdkNmb0JM?=
 =?utf-8?B?dnNpbnZmb0JwLytvUlltdXVyd2dRU3lGdVV6bUxRbjF2UDFyalZQemVnZ2NE?=
 =?utf-8?B?Q2NDTy91NDgzMDVmd3NCTG02NWNVbStadWdpWEV3QU94d3hWanNDemVxNjlT?=
 =?utf-8?B?YXJzTTRHSWlJQ25yaGJxRXVQUWFyb2dEUjhRVVpHSEdRRzZFWEFJNnZ6UVY2?=
 =?utf-8?B?U3FEY2Y5T2xqeGR4VGdNZGQ4L3NIbGdaNWhRdVFuOW5sT3RBWFh2aWFxTFJK?=
 =?utf-8?B?dit4RGxTYkJhMWZBdzhpRGc3KzR6RUdoVjh2UTFiTVY3RnZwL0lUbkRuYVpD?=
 =?utf-8?B?cFZTZEVpdnJIRzRYK25RK0tpb1hma0xJSlNVSkFSSGZxZWJqVDlLSlBNcnFT?=
 =?utf-8?B?WXA3V2JNTTc3L0FMeUxycmZWNFFFeTh5d1UzUHZRTDVSMTlNUmNMQTl3aWE5?=
 =?utf-8?B?TmtUSUhUc3V1bmszSjFjUmptYWR3UGhRYVZtQTlNbkd1SkI1UUUyanhSOHA3?=
 =?utf-8?B?TGJlNUhmQlJ5N2N3eG0wTHIzcEtoZXRjVG5lQnNNM3UvZVh0V0p5UWxJT09O?=
 =?utf-8?B?aW9kVHhzbDN4THJOMnl1K3BFRmlUaVhyVURZb0pRQTJxSFR3SzN0U1JlN21s?=
 =?utf-8?B?TFBIaVNtL2xNd2dVWDVEWGFOOVM0WFVJZTVSdzZ3SHI0aFRHbVdCcm5mYW1i?=
 =?utf-8?B?UHlUOWZ4VC82YlM0YStxdkcyMzU4VFgrWWNqci83ZjBoZlhpWnpDMHZudG9p?=
 =?utf-8?B?eU01a3NmdXdibVBCd1Nhbm95MUdJK2pGczVxSk92SUlEY05xUXpVaXc1SWdD?=
 =?utf-8?B?TGZxbXk1dHkwdEhxSTRTVHZrc3hmYzROY1ZsOW5BYStlOU05aEc2QzlnVllq?=
 =?utf-8?B?eXhPdm8zcEVFSno1Q1g0THIzbFdnMnY1dHVFVWF0VEJlUjVlWUh1dDhvRGVZ?=
 =?utf-8?B?WTdrLzJsZFRtZkhrWE5OT0RhaU15V0hZQzE0VHhYWTlMejJXU0hJRVRGSjk3?=
 =?utf-8?Q?rCSE1/Hu7Naj3ctq+lzGSe4kue8JxoHmeM+90GehlDgM?=
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
	ByS2vPj3uz1F7p4HqiGfRVKrO8vp6u91odUMOHsOhY0izoHO3kZ90c0dPQjIlzLVRigFpyj1YpW7SjXJquVGIwBqmeUje3UiwqwexkG7l6TQT1khW6Iwv2oxphq0hhwcLU5vRUCyAs2+aGaZvQeeDmCDdVx5a3xZCorlvUjNnh/Xbq5F7ibGfGnKuVFcar4N1hKqZPvzzIBvFQIKA2DLPDqwPGgNoE6X7RrL4O6IiSBNtO5mIshAJ9Zx0STUKqgXyRUIwlWJNKibOCh1UFidEsZ25osj/xXa/IMorcPsQhK3ulZJ/4s68PB7CNBhhEsZq2yNOLxpSHcAwyMht25edtgq1tPB3H9j9scC5PT1KpApevrRWUxnpos1mceVYgO5WlO43tnBMdUryUvUuAK/ilpfKIhTyi57WWIIJMUcXLhe4Rg8bUhzgYk4j2qOUU9TmfJR4rdlrzSVkt5Y9A6d1107RFRiw+dimlpjar+RggazDqiDGI5eYB0UZte9J5bEGfQcp5m+NYYca4LxOjVHYbJCHsjIrNBBBrcqdRoRkIwcGOumhE8C0p9xYJQkVlMKb+BSCMrVCavesCiyaizhTfvosa8RkY59W8TYO8Ya5vOpcW74nFhSsFb/JxfO9gazUIdais+/123qzTnk2nXzTw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6395c2a6-d38a-45f3-ddb6-08dd4d1f8d58
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2025 17:46:46.6893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yvL0z9sxS4zfwwCGD8E1ZR/8caloRmduz7MnEp62bUuYTBWTA6NeHd8LmfhlQ1eX0dRVgUNa6vckHZwUbGAI7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR16MB5065

KyBCYW8NCg0KPiBBY2NvcmRpbmcgdG8gdGhlIFVGUyBzcGVjaWZpY2F0aW9uLCB0aGUgYml0IHBv
c2l0aW9ucyBmb3INCj4gYFVGU19ERVZfSElHSF9URU1QX05PVElGYCBhbmQgYFVGU19ERVZfTE9X
X1RFTVBfTk9USUZgIHdlcmUNCj4gaW5jb3JyZWN0bHkgYXNzaWduZWQuIFRoaXMgcGF0Y2ggY29y
cmVjdHMgdGhlIGJpdCBhc3NpZ25tZW50IHRvIGFsaWduIHdpdGggdGhlDQo+IHNwZWNpZmljYXRp
b24uDQo+IA0KPiBJZiB0aGlzIGlzc3VlIGlzIG5vdCBmaXhlZCwgZGV2aWNlcyB0aGF0IHN1cHBv
cnQgYm90aCBoaWdoIGFuZCBsb3cgdGVtcGVyYXR1cmUNCj4gbm90aWZpY2F0aW9ucyBtYXkgZnVu
Y3Rpb24gY29ycmVjdGx5LCBidXQgZGV2aWNlcyB0aGF0IHN1cHBvcnQgb25seSBvbmUgb2YNCj4g
dGhlbSBtYXkgZmFpbCB0byB0cmlnZ2VyIHRoZSBjb3JyZXNwb25kaW5nIGV4Y2VwdGlvbiBldmVu
dC4NCj4gDQo+IEZpeGVzOiBlODhlMmQzMjIwMGEgKCJzY3NpOiB1ZnM6IGNvcmU6IFByb2JlIGZv
ciB0ZW1wZXJhdHVyZSBub3RpZmljYXRpb24NCj4gc3VwcG9ydCIpDQo+IFNpZ25lZC1vZmYtYnk6
IEtlb3Nlb25nIFBhcmsgPGtlb3N1bmcucGFya0BzYW1zdW5nLmNvbT4NCkFscmVhZHkgbm90aWNl
ZCBieSBCYW8gRC4gTmd1eWVuIC0gc2VlIGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xp
bnV4LXNjc2kvbXNnMjAyMTYyLmh0bWwNCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IC0tLQ0KPiAgaW5j
bHVkZS91ZnMvdWZzLmggfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91ZnMvdWZzLmgg
Yi9pbmNsdWRlL3Vmcy91ZnMuaCBpbmRleA0KPiBkMzM1YmZmMWEzMTAuLjhhMjRlZDU5ZWM0NiAx
MDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91ZnMvdWZzLmgNCj4gKysrIGIvaW5jbHVkZS91ZnMvdWZz
LmgNCj4gQEAgLTM4NSw4ICszODUsOCBAQCBlbnVtIHsNCj4gDQo+ICAvKiBQb3NzaWJsZSB2YWx1
ZXMgZm9yIGRFeHRlbmRlZFVGU0ZlYXR1cmVzU3VwcG9ydCAqLyAgZW51bSB7DQo+IC0JVUZTX0RF
Vl9MT1dfVEVNUF9OT1RJRgkJPSBCSVQoNCksDQo+IC0JVUZTX0RFVl9ISUdIX1RFTVBfTk9USUYJ
CT0gQklUKDUpLA0KPiArCVVGU19ERVZfSElHSF9URU1QX05PVElGCQk9IEJJVCg0KSwNCj4gKwlV
RlNfREVWX0xPV19URU1QX05PVElGCQk9IEJJVCg1KSwNCj4gIAlVRlNfREVWX0VYVF9URU1QX05P
VElGCQk9IEJJVCg2KSwNCj4gIAlVRlNfREVWX0hQQl9TVVBQT1JUCQk9IEJJVCg3KSwNCj4gIAlV
RlNfREVWX1dSSVRFX0JPT1NURVJfU1VQCT0gQklUKDgpLA0KPiAtLQ0KPiAyLjI1LjENCj4gDQo+
IA0KDQo=
