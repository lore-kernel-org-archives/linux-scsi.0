Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011005.outbound.protection.outlook.com [52.101.57.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2923FB7FC;
	Fri, 24 Apr 2026 20:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777063620; cv=fail; b=IDkYSDHGrLEHT4Tnf7bcgguH/sqizHeZ7Y+LnqmKKFS1SjAF+D2KUbiFmIcIDK0gZfJR/4brCzc7yNUkyA2HtSzsggt9q3AGcZwQSsIqD2cPYU1fkdaGcc66gFJteNQB+Lmttl6pUA0jA1UxIYDi33uq7UVYCaKywMZ3qX4R3RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777063620; c=relaxed/simple;
	bh=BtlS0FKiguAtxp+5jLs9RdWZHt77U2r2ia2rnkKiafY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dKapuKT/42A5fBOd5NI/569xd0EwBP804RP9+rpSHUSyXg8521MzhFN+5hTGyOB/kspQj6MAw2/+sVgjt3A/rwlkXtYWOxBDVb3D/Yhu5/tWyx0QzqG+f8bbRKioXDeB/ULWfs9fPTsw3a9JB6NM/LFJ/IwKfa1NF8y8znKyzDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=r0ZtaKsu; arc=fail smtp.client-ip=52.101.57.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="r0ZtaKsu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eB4i5mL6sknpuSlgtQq49y14rbwZ1sPf3zdbKtDo/akdncIMKLgGG2N4U1OWoi48EXkaVXIB5dTIwrg+KjaObd/Vy3QuEbUaIzu/3ct3x/Zk5dHnZknk0T2u9LtAfo9UZWYc055E5hhpzJEIuKKQ851eCst43ZZbqL/tPCla0xB5n6uFBW3uYVXpZGMmdFE3IUlbu1DiFf3nLWqn4FkzMuHQ4gutVCgjZpGrcxJo1j0bg79G07Y9dLDSXXlUiB8oHZHc5SOw75yb2Sp0GollzvB6GN+UCYgpui2BXj3K3gS++qywbmoNL54CLqbusDiU0pHErnb3BiSWgx3TGHTtdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtlS0FKiguAtxp+5jLs9RdWZHt77U2r2ia2rnkKiafY=;
 b=OhaLmW/8erpqRMOkWHC7lMeKy+LZVFHSZTOmPCiIR96h8wDHpHw9PuMjMVc1Bu6CNssPPoM7xIRYaq0sb8g5tuiyLEDLhcuW051WSOXpE951grRctSzUl2pXA7t+gZhFQAugv1ZA9PqKUJJTgt5u/jD5ObcpUBLt7ewibcqZRYqYB97Ztg6uPRUCA19ad9VzK/eR9YvhQdEmcHYHgfRbPiq4yOsyRVRYwFSFj+MOyTi/HylA7fWRkcBov8QlXZpj/uwqWoskMmWKXXxhLupCKCoFC4vw4dVYEGJXkaGQWxO813bFOtcmcxo7eoZJDl7a76uKGHWRbYGOc3QvQiCOAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtlS0FKiguAtxp+5jLs9RdWZHt77U2r2ia2rnkKiafY=;
 b=r0ZtaKsujCtdZqmxQcX+YLmwHM7w0Gv6aAEAIPjUgewuIPrmy7csjpSnV9mm/jhgiT/6fDW4rXmgkCI56UOlSZVH+kSWsn6Pxk9uG01qXDFqf+kQyMvNPTprAUFLGq1GBuu0iqbbKfPBFEvnuL4kfTo1jQjNL/OVVpPW18QbcmJE3wTcCFvSjpmjZK/ujJ8l6bPqk4Fye+NtDbxQ2OVg4htSgZoWz461HzXmxLalp0p2Wf2k+RaA1ksLboo8yy21YgaFP56dZK3mBmdlUTtB0YPVExlVsqyWfTnFEH0zcwHu1PrdHw6UbVrwt6z2NYIjc2spaaanvxixOFkIOOPSBA==
Received: from PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8)
 by SJ0PR11MB5101.namprd11.prod.outlook.com (2603:10b6:a03:2dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Fri, 24 Apr
 2026 20:46:55 +0000
Received: from PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::2f1a:88db:3b2a:e6d0]) by PH7PR11MB7570.namprd11.prod.outlook.com
 ([fe80::2f1a:88db:3b2a:e6d0%5]) with mapi id 15.20.9846.016; Fri, 24 Apr 2026
 20:46:54 +0000
From: <Sagar.Biradar@microchip.com>
To: <jinpu.wang@ionos.com>, <dlemoal@kernel.org>
CC: <martin.petersen@oracle.com>, <James.Bottomley@hansenpartnership.com>,
	<linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>,
	<Don.Brace@microchip.com>, <Raja.VS@microchip.com>,
	<Kumar.Meiyappan@microchip.com>, <Abhinav.Kuchibhotla@microchip.com>,
	<Udaykumar.Bagam@microchip.com>, <Advait.Churi@microchip.com>
Subject: RE: [PATCH] scsi: pm8001: add MODULE_AUTHOR entries for new
 contributors
Thread-Topic: [PATCH] scsi: pm8001: add MODULE_AUTHOR entries for new
 contributors
Thread-Index: AQHc0dT2ny8dAprvqEy8wrx0ApvFn7XtglIAgAA5T4CAAPWFIA==
Date: Fri, 24 Apr 2026 20:46:54 +0000
Message-ID:
 <PH7PR11MB7570016CBC1B9F73CB30D950FA2B2@PH7PR11MB7570.namprd11.prod.outlook.com>
References: <20260421212218.433963-1-sagar.biradar@microchip.com>
 <66414927-481a-4464-8a3d-d6d77ab1aefb@kernel.org>
 <CAMGffEmirEUEy75ZULdXFE13WLMnciWLa_YsLQOyF0r6TArzPw@mail.gmail.com>
In-Reply-To:
 <CAMGffEmirEUEy75ZULdXFE13WLMnciWLa_YsLQOyF0r6TArzPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7570:EE_|SJ0PR11MB5101:EE_
x-ms-office365-filtering-correlation-id: 37b1d497-e0a4-4a36-36ee-08dea2429ec4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 y4z3gvcZh+CVgaz3uH8A+2lD96wKOg/3NeB5pSXuvRJ/ipZFIv2PsgrcCDXD/WMuCi6fwuGpb90ln0fJWm/i35couJklFX3xcsBThsZxXhcIwWPLnEXEAM63UvVMzlu3WJkzKSfzc+v+Vfbnrivo59j4tJDBsGTaYVXn3Zi5+yr5WocHE0j14jC5Q29ujL/Xcf2P/4ZlAaHKRt9tBBXJQLNSgu6HMS7z1RdcuMKY6xBKIMATLrzWfAZpbplMf2xCnCQd/1w+Bpzeofu/c9vsLEVMicl9SOfM9JVJnoT7iAVGhYfx3SiD/CzJVKzGGfPyCk7YEi9pb6QT5hHgOkRIRiZcoP23lKo/S7uyAmLMV+bfWlPhus6B25IqwNnmBAO3TG6uaKUn+WPprlaKL1b8/uHLyQ54VtJK1G1JuTI8yPJ444AA5VpSBMNZishMjZ/tp5v0zhQIUFuSgFmnHmw0mT+P6dLSv64uRGVWsIagSFAzNNBkzPeNY3ZXIemnH2bd3e2CNdyChhm2kTsFC0acXOPp/j9qM614w1xQRbzlcMD5XBO7FZf3nFyOsRBe/zpoFFSUsnr9PwA+1BCVoGtbeV+1HsREWZpfgMpAqrXucGF8cz3bFM1RnY4Uu2tXXsESN/WurAMgKxk+ZQ3XEfSn+eMzmn856I3fgs3STes14c2koLc2PZNb7DQEruYGnTr/RepCqaZ0BZR0NvE/11aKv6tNBa2BlFFvZwhlo5BW7nS+y5caRdVOYJ0y0ve2nnRsAHirmcz6pXThFDO5YMEtNeRi9CfZlHTnU2yEzVVlWIs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7570.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aEViREIwRTNzVmtkZTZ0NVh6MzJ2TFo3c09QRzFyMUI5VUs4VncyOWtvSnlG?=
 =?utf-8?B?RFFGSitZdDFDeWVGV3NtbkRRbkVwbzhiWWZaMEZIMnJmU2I3ZVlqMlZNTW5l?=
 =?utf-8?B?enpSQlBudDZVN3NZTGZsSmlJZFlaY3A4eVBRU2djTGxXdG9ucjVVVlNraGRn?=
 =?utf-8?B?NVNhdkVpUnhlWSt4LzlUYmt0Z05KZEFKd3k2Wmc0QmVEZmdvU28yRzRlWnlE?=
 =?utf-8?B?NU1OcU1jZXM5Y1pOWnhIVXBxcjQxc0FId21uZVJKaVBHNlJaVmM3dnE5Y0lS?=
 =?utf-8?B?TGZpN1ArYXZmQ2htWWtVbmNGK0xteWVpRzdVUWVlbkl3VHlzRjdCN3hoYXVD?=
 =?utf-8?B?bllob0NHWGZCcG1TdDEzMEZ3V0k5MXNqNWhtLzI1dUp4YmFlVFhxcU1rcWRI?=
 =?utf-8?B?Tzh0THZsUVVyeDdDQnhLQWIxcVB3ZU5RTDdUYzdjczRRa0tzN1FkeHd3OTBp?=
 =?utf-8?B?YlRGWUNZYkQxcnpHbFd2bWN0WE5xMEYxVWN6Qk1EVTl0ODBYUmNSQzB3YXhE?=
 =?utf-8?B?UnU4QVN4WEpua0xEQytWQTFaK252OE9wczgzdm95VURFZ2RlSUpRNitWZHcw?=
 =?utf-8?B?QzJZM3AvWnN0VVhzQ3d0V3JCdkVyakxVdFZkWG1PN0ZXMy8ySDZTSndGWmcr?=
 =?utf-8?B?eFZFdzR3N0hzcERXSTlwbmdDQUVwbkY2L3A2SEVHR1htMkhxemRCMnI5T1R4?=
 =?utf-8?B?QXBzbk9TdXVRQUNLZDhuZnFSRE1LcHhMYTEwRitPMHVyU2V4dlQ1bkdyVnFs?=
 =?utf-8?B?dW1TRUtvVE9RWjEvbWtaTXVJRUZsK0w2cVpNUFk3cTEzZUZpekZMRWNTNFVV?=
 =?utf-8?B?TVZBTWM5eGgrOHBqZ2oxdlZMQytNSEZsZ2M5R0pPaWtsQVlyYUgyT3F5ZWNY?=
 =?utf-8?B?VE5oSHFDSiszaHo0WkxTYXlPZm1iSjA1Nmd5RnlIU25EUnR3YWY0SEVDVHo1?=
 =?utf-8?B?Qnl6TWxhMGMrRngzUWp4VVVWL2ZCaCsxdFQvT2F6WTUwTFFCTmdFV25QQVFq?=
 =?utf-8?B?T3VMREx2NGZjU0Mzak56SDZjZURaZEkxd2lCMHQ0QUs5OHZKaXBHWU52WnE1?=
 =?utf-8?B?ZFhmZURQSnJzZWVGVVZWRHR6OUhEYkpjSUdtS1c0T1c2ZlZaSVVnKzB4am13?=
 =?utf-8?B?MWJSeEhrRWsxK2RjRDRlTmhPVi8yM3BSVmZTS2xVUUl1WG1FcHlGdG5GSkM2?=
 =?utf-8?B?amhnNkZRWFFtMW1rczRlQk9ibjhZdWtjMGI0U1dkL3B1Z2VyK2N2ZUk2SDVi?=
 =?utf-8?B?Zms4eW0zdGZRRFFlN0FoNUlvS1hCMkNyaEl0OFZjaUpkdkRhTGV6WEVSdmZF?=
 =?utf-8?B?Tkh2eFpXSXpSZm5jc1FVcFVGYjRpOGt3NlFoRi9CVE1FU0RGOUF0UmFNd21G?=
 =?utf-8?B?VTlmQzhZN0FKZERVWEZhMDJjblZ5SmFBZ1YybVpnWnIxajgrNTdOa0ZlaWx5?=
 =?utf-8?B?MCtwaVA5SkZLNzVqbUN1Q01PdWl2QUFJSnVWNUE1TTc2bC9hRXEvWG9LRmxa?=
 =?utf-8?B?V2REcndsL09SUHNva280bmcyc0V0NVdxWkxKNEp6bHI3czh3UXVlRkVIYnIv?=
 =?utf-8?B?SkdVYnU5anhvcEtpWnptMlNxSVkrYlB5UmdWaVJzeWFJd1VOSStLTVRSMWxM?=
 =?utf-8?B?S0laTXlMM3RWNHNSNk93a3h3Y2lLc3FxOVhRMHpkUDFmQ2RrbzNmb2IvRkVh?=
 =?utf-8?B?ZGJsUndNWTFFUGp1WDd3a0FBYTN2UURSMU9SZFZ5VmM5ZlZFS3JnTjBaRWZl?=
 =?utf-8?B?YW15SmFlMVY1OWJXNGRFK3ZFSFZiME9jS1dweW5ZYUF3Rzl6YlpTVmErY0Vk?=
 =?utf-8?B?aktmUk1aUlZZamNLMTJ5NlBHZWRqWlVLYWh4U1pONDdRYk9EK2s0K21VNWNh?=
 =?utf-8?B?Vk9zUnpUcHlHRFFtQk4wWjVuT2taZ2hPY05vd1l1T1hWd3FsMUNmRHlSaWM4?=
 =?utf-8?B?TXF5N2EzTTVTdVI1akxOcms4OUVjS3Y1WUEvWERXTTBkMEhQYmlXdDhuTGhr?=
 =?utf-8?B?d3prUUlGNUFCYm5NMDJ4QXIwN3VtdXFuVEdWZEZ5WUxEa2s0STA0bUJjS3Vi?=
 =?utf-8?B?c2U4bk5QZW9ONVY3THZ6eXpjdmhWaGxDUFJLUWhqVVJsL3ZzcklhYllFMDY0?=
 =?utf-8?B?YnNhRU05ek0rTTRlZUJzUEhFTE0wdERoN2FkRGdpQ3Z5V09NalRXVkVFZm1K?=
 =?utf-8?B?eEx3M29IWGVELzJBeEl0aFI0eEh1NS90N20zSEc0c0VXTnFRZThTbUpOY01l?=
 =?utf-8?B?YTVXUmtucHpYRFFXeGxZbEI2V3VUOHdtNWgvYVpyTFRnMjdkSzNIeEsxTkNP?=
 =?utf-8?B?RW5uUmFNQjNFNkh0UG1idkVpMkcwYXc5ZUhPVmZ5WVNMOGZkM1hyUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7570.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b1d497-e0a4-4a36-36ee-08dea2429ec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2026 20:46:54.8199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fXJmTzmyVYrzX5vaqYWN5sw4+QAXCxzR4xwnAQW90+F5HarqONrX+hx4rX2OfuPzq4QsBq0PGFr7+qudyDY57qGdpVkuScR13sopLIvyNEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5101

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmlucHUgV2FuZyA8amlu
cHUud2FuZ0Bpb25vcy5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAyMywgMjAyNiAxMTow
MCBQTQ0KPiBUbzogRGFtaWVuIExlIE1vYWwgPGRsZW1vYWxAa2VybmVsLm9yZz4NCj4gQ2M6IFNh
Z2FyIEJpcmFkYXIgLSBDMzQyNDkgPFNhZ2FyLkJpcmFkYXJAbWljcm9jaGlwLmNvbT47IE1hcnRp
biBLLiBQZXRlcnNlbg0KPiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBKYW1lcyBCb3R0
b21sZXkNCj4gPEphbWVzLkJvdHRvbWxleUBoYW5zZW5wYXJ0bmVyc2hpcC5jb20+OyBsaW51eC1z
Y3NpIDxsaW51eC0NCj4gc2NzaUB2Z2VyLmtlcm5lbC5vcmc+OyBzdGFibGVAdmdlci5rZXJuZWwu
b3JnOyBEb24gQnJhY2UgLSBDMzM3MDYNCj4gPERvbi5CcmFjZUBtaWNyb2NoaXAuY29tPjsgUmFq
YSBWUyAtIEMzMzUyMiA8UmFqYS5WU0BtaWNyb2NoaXAuY29tPjsNCj4gS3VtYXIgTWVpeWFwcGFu
IC0gQzYyMDY5IDxLdW1hci5NZWl5YXBwYW5AbWljcm9jaGlwLmNvbT47IEFiaGluYXYNCj4gS3Vj
aGliaG90bGEgLSBDNzAzMjIgPEFiaGluYXYuS3VjaGliaG90bGFAbWljcm9jaGlwLmNvbT47IFVk
YXkga3VtYXINCj4gQmFnYW0gLSBDNzQzNzUgPFVkYXlrdW1hci5CYWdhbUBtaWNyb2NoaXAuY29t
PjsgQWR2YWl0IENodXJpIC0gQzcyNzYzDQo+IDxBZHZhaXQuQ2h1cmlAbWljcm9jaGlwLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSF0gc2NzaTogcG04MDAxOiBhZGQgTU9EVUxFX0FVVEhPUiBl
bnRyaWVzIGZvciBuZXcNCj4gY29udHJpYnV0b3JzDQo+IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8g
bm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQ0K
PiBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIEZyaSwgQXByIDI0LCAyMDI2IGF0IDQ6MzXigK9B
TSBEYW1pZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9u
IDQvMjIvMjYgMDY6MjIsIFNhZ2FyIEJpcmFkYXIgd3JvdGU6DQo+ID4gPiBBZGQgTU9EVUxFX0FV
VEhPUiBkZWNsYXJhdGlvbnMgZm9yIHRoZSBkZXZlbG9wZXJzIHdobyBoYXZlDQo+ID4gPiBiZWVu
IGFjdGl2ZWx5IHdvcmtpbmcgb24gdGhlIHBtODAwMS9wbTgweHggZHJpdmVyIGluIHJlY2VudCB5
ZWFycy4NCj4gPiA+DQo+ID4gPiBUaGlzIGhlbHBzIHByb3Blcmx5IGNyZWRpdCB0aGUgcGVvcGxl
IGludm9sdmVkIGluIHRoZSBvbmdvaW5nDQo+ID4gPiBtYWludGVuYW5jZSBhbmQgdGhlIGN1cnJl
bnQgdXBzdHJlYW1pbmcgZWZmb3J0Lg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNhZ2Fy
IEJpcmFkYXIgPHNhZ2FyLmJpcmFkYXJAbWljcm9jaGlwLmNvbT4NCj4gPg0KPiA+IFdlbGwsIGlm
IHlvdSBnbyB0aGVyZSwgdGhlbiB5b3UgYXJlIHJlYWxseSBtaXNzaW5nICphIGxvdCogb2YgcGVv
cGxlLg0KPiA+IEp1c3QgcnVuOg0KPiA+DQo+ID4gZ2l0IHNob3J0bG9nIC1uIC1zIC0tIGRyaXZl
cnMvc2NzaS9wbTgwMDENCj4gPg0KPiA+IGFuZCBzZWUgdGhlIHJhbmtpbmcgYnkgbnVtYmVyIG9m
IGNvbW1pdHMuDQo+ID4NCj4gPiBTbyBpbiB0aGUgZW5kLCBJIHJlYWxseSBkbyBub3Qgc2VlIHRo
ZSBwb2ludCBvZiB0aGlzIHBhdGNoIHNpbmNlIGdpdCBsb2cgY2FuDQo+ID4gZ2l2ZSBhIGZ1bGwg
KGFuZCBjb3JyZWN0KSBsaXN0IG9mIGNvbnRyaWJ1dG9ycy4NCj4gKzENCj4gPg0KSGkgRGFtaWVu
L0ppbnB1LA0KVGhhbmtzIGZvciB5b3VyIHJldmlldyBhbmQgZm9yIHBvaW50aW5nIHRoaXMgb3V0
LiBJIHZhbHVlIHRoZW0uDQpUaGUgaW50ZW50IHdhcyB0byBtYWtlIHRoZSBjdXJyZW50IE1pY3Jv
Y2hpcC1zaWRlIHBvaW50cyBvZiBjb250YWN0IGZvciB0aGUgcG04MDAxL3BtODB4eCBkcml2ZXIg
bW9yZSB2aXNpYmxlLCAgc2luY2UgTWljcm9jaGlwIG93bnMgdGhlIGhhcmR3YXJlIGFuZCB3ZSBw
bGFuIHRvIHNlbmQgbW9yZSBjaGFuZ2VzIHVwc3RyZWFtLg0KSXQgd2FzIG5vdCBtZWFudCB0byBv
dmVybG9vayBvciBkaXNwbGFjZSB0aGUgZXhpc3RpbmcgY29udHJpYnV0b3JzLg0KDQpJIG5vdyBz
ZWUgdGhhdCBNT0RVTEVfQVVUSE9SKCkgaXMgbm90IHRoZSByaWdodCBtZWNoYW5pc20gZm9yIHRo
aXMgc2luY2UgZ2l0IGhpc3RvcnkgYWxyZWFkeSBjYXB0dXJlcyB0aGUgY29udHJpYnV0b3IgcmVj
b3JkIGFjY3VyYXRlbHkuIEnigJlsbCBkcm9wIHRoaXMgcGF0Y2guDQoNCldl4oCZbGwgbG9vayBh
dCBhIE1BSU5UQUlORVJTIHVwZGF0ZSBzZXBhcmF0ZWx5IGlmL3doZW4gYXBwcm9wcmlhdGUuDQpU
aGFua3MgYWdhaW4NCg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9zY3NpL3BtODAwMS9wbTgw
MDFfaW5pdC5jIHwgMyArKysNCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
DQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2lu
aXQuYw0KPiBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2luaXQuYw0KPiA+ID4gaW5kZXgg
ZTkzZWE3NmI1NjVlLi40ODdmOWJjMjM3ZWYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3Nj
c2kvcG04MDAxL3BtODAwMV9pbml0LmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEv
cG04MDAxX2luaXQuYw0KPiA+ID4gQEAgLTE1NjksNiArMTU2OSw5IEBAIE1PRFVMRV9BVVRIT1Io
IkphY2sgV2FuZw0KPiA8amFja193YW5nQHVzaXNoLmNvbT4iKTsNCj4gPiA+ICBNT0RVTEVfQVVU
SE9SKCJBbmFuZCBLdW1hciBTYW50aGFuYW0NCj4gPEFuYW5kS3VtYXIuU2FudGhhbmFtQHBtY3Mu
Y29tPiIpOw0KPiA+ID4gIE1PRFVMRV9BVVRIT1IoIlNhbmdlZXRoYSBHbmFuYXNla2FyYW4NCj4g
PFNhbmdlZXRoYS5HbmFuYXNla2FyYW5AcG1jcy5jb20+Iik7DQo+ID4gPiAgTU9EVUxFX0FVVEhP
UigiTmlraXRoIEdhbmlnYXJha29wcGFsDQo+IDxOaWtpdGguR2FuaWdhcmFrb3BwYWxAcG1jcy5j
b20+Iik7DQo+ID4gPiArTU9EVUxFX0FVVEhPUigiQWJoaW5hdiBLdWNoaWJob3RsYQ0KPiA8QWJo
aW5hdi5LdWNoaWJob3RsYUBtaWNyb2NoaXAuY29tPiIpOw0KPiA+ID4gK01PRFVMRV9BVVRIT1Io
Ikt1bWFyIE1laXlhcHBhbg0KPiA8S3VtYXIuTWVpeWFwcGFuQG1pY3JvY2hpcC5jb20+Iik7DQo+
ID4gPiArTU9EVUxFX0FVVEhPUigiU2FnYXIgQmlyYWRhciA8U2FnYXIuQmlyYWRhckBtaWNyb2No
aXAuY29tPiIpOw0KPiA+ID4gIE1PRFVMRV9ERVNDUklQVElPTigNCj4gPiA+ICAgICAgICAgICAg
ICAgIlBNQy1TaWVycmENCj4gUE04MDAxLzgwMDYvODA4MS84MDg4LzgwODkvODA3NC84MDc2Lzgw
NzcvODA3MC84MDcyICINCj4gPiA+ICAgICAgICAgICAgICAgIlNBUy9TQVRBIGNvbnRyb2xsZXIg
ZHJpdmVyIik7DQo+ID4NCj4gPg0KPiA+IC0tDQo+ID4gRGFtaWVuIExlIE1vYWwNCj4gPiBXZXN0
ZXJuIERpZ2l0YWwgUmVzZWFyY2gNCg0K
