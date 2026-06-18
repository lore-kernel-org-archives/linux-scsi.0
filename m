Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023127.outbound.protection.outlook.com [52.101.127.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EC1146A66
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781764150; cv=fail; b=sb7BuXOOHmxu2/qx1bgDMs1akYTZ0tnFI+Ycmfx1/NDjsjgRAYCSSqL1j90T2XmHAw6ZFUoFejMdjLzI1SJh9lPHTZkDCqWuKxJ91Zbty5UrQ77wfALXv+cAg4hs/S/uehoMx3bLi/bdA+t4Hk5JYxW1jPXY/cnkfGyxM+U7vb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781764150; c=relaxed/simple;
	bh=nFbUzPAqqAmFnmZUAD8+/bukZYrGmvOOGPYU0mCuAnA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RqMHad7LTQZPbPUNOq/aRNv52nfFVnSS58DN/w+0Nf8vRTMisstpoEFbsVLPTbB08YrJpwB/FF/6S99x+g+0vHQn6HBjJaMuVjznqrLJ1gHP2o2/FVMSpYvkb4NY2JCOlZBBh+2JZkMNSa3WxRD1CjNxjKlxThGMQ0SsY6WLqVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com; spf=pass smtp.mailfrom=transsion.com; dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b=c8hN4H06; arc=fail smtp.client-ip=52.101.127.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=transsion.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=transsion.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=transsion.com header.i=@transsion.com header.b="c8hN4H06"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccM8tLDtKAv/N7USOggJ3+mxIbGzAYFqkJKAfsgQCmcAXOtzB/avpti29aw3SpU+Nz2tvP8TecgbgrRcQRdw8C6VbnYwAEmJw5wMnNJmHkjxkazdx57cRTLONPYA2Dk9GEaXxKR74w/usu7kfbbUm9Q2clKp4EZ1uimyP2da07jjVb/V12VHO5BeVzE7HNrEIUZu94C1WWv4Qf9+fbk0UC6mD50bncpshth0oKik0DQaFIQ948uW6mvDkRMPy+w+vT9J/SlYYFtQEFUOrri+gFA3BoGuvutt6IPzCVfSpB81wine0GflZi+mIamPbtYfam3CKRJm9zSfgFeg8mTjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFbUzPAqqAmFnmZUAD8+/bukZYrGmvOOGPYU0mCuAnA=;
 b=CsVDZFcsBsvRQ9T9uaIyNt7nHIVODuQSEAxV/YKY66ws9wsKYWRAH/rA/wQyqa0E0XeZHPLKTuK2/JNIeA2IrNscpA7QCWNIiUdsUdpo9safTqHxtRdd7KEpf0gcjr8a70bHVEsOWZAd0trFZpMELcjXp0dQA/4bSKQ+hSsca59faBzpJg3R9nujGLd3hiyUxdeB0eRAP0Wj9I46KzGOWl/pu4JCNwyq7axfws0wrIOLAfVGgC3lezPA3b7Hbs8O7+COYAH5gA8oH+sMYI5PxPKGCek5Y3MJSyWQh28rkQ7dyJ3EACgKi02iGyCboWb34CE7uyval7QnRLGDVFgYAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFbUzPAqqAmFnmZUAD8+/bukZYrGmvOOGPYU0mCuAnA=;
 b=c8hN4H06b6QgiaOSx2VJ8qWpUG9HhpxX3ztFBXLuouexTQqYl7aeOAxDsiWeipSEomJSRn1AkdDz0dvh9oh9IuLSrdfrprgOasvx3uM4ZUB/5pbQBy+81aq6U7OZAO9++6uTyghgGZ+X440E1UvK8ie/S+f82D0V4RXWGaMwadI=
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com (2603:1096:101:2e8::6)
 by KL1PR04MB8142.apcprd04.prod.outlook.com (2603:1096:820:140::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 06:29:04 +0000
Received: from SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2]) by SE3PR04MB8921.apcprd04.prod.outlook.com
 ([fe80::ebed:1dee:3932:9ba2%3]) with mapi id 15.21.0139.011; Thu, 18 Jun 2026
 06:29:04 +0000
From: Ao Sun <ao.sun@transsion.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "beanhuo@micron.com" <beanhuo@micron.com>
CC: "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jiazi Li
	<jiazi.li@transsion.com>, Hongyan Xia <hongyan.xia@transsion.com>, Ao Sun
	<ao.sun@transsion.com>
Subject: [PATCH] scsi: ufs: Remove redundant ret check in rpmb
Thread-Topic: [PATCH] scsi: ufs: Remove redundant ret check in rpmb
Thread-Index: AQHc/uvCnWRtstb0cUaOpces9hq8iw==
Date: Thu, 18 Jun 2026 06:29:04 +0000
Message-ID: <20260618062752.492-1-ao.sun@transsion.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=transsion.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3PR04MB8921:EE_|KL1PR04MB8142:EE_
x-ms-office365-filtering-correlation-id: 7c475c9c-e2fc-41ed-381e-08decd02e4ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|42112799006|366016|56012099006|11063799006|18002099003|3023799007|38070700021;
x-microsoft-antispam-message-info:
 /g9iUr3U6DG9dux1lp7B6h9QJnuaXHHX0GktWaUxS06IZz/eSi/gU/P3mCDGY1d9y6kGjs3NriJAmp/rcoCX01e3b62nZ6AJrvgBaOF1BMw3IsT8AeiQ5rm3CsTEquzmlg5YOEoQDhwpDit/2z383M/Tw9lhsz7PZ+0rMVqY6zqrzSQGNoXsOGJatMd82aFJjBRrIs8khw7QOVRtnQoBN1L8inmMHelKq1EAxVNNsP0FXZ0pmB8nXMS5MhnQS/paNkponCTxidHgdXf5ercEkwh49UyS9w/FQyDmu9An1VlcvGne2fPgFneuzB6GyKf/EfrattxWv1ZwjfJPWKmmib6WO+4BQoF4hwZRbWjCKkrvK7Y3nnxH0aqheUVbTr+oMrfAvs8nP/Sy87SpQkMUh2ZaEGVDtJqdKYBN5WA4toOTddSVcDcXKMrj7XZ1s4TY0qwrIcRPTvqtCSKwjHo0VC8PInzIhLXj8FXxD3jy7aaTQvZvGYdsb/lWOj2q3iFEx6sCjrcktZQlMW58I771OK1IdE60z1/Uwxdqn/e8lGfYssgFMMPEaiKRvbiqu2pkNP/WFxV8PBJzFCfJF/wYpmMDMzCqmZu+Za+ZQcoW7FguJotyOf28IiA1jNXU1gPaNbuHr3Wmq6MoxzHUYXBohofp1Ct4/9pRAajypc7sE3jBleq1V1+hA8MsRvUgwC6IYeTNENWAOPzJLDXB8ca23+/S4f7c4MbBq0JSETVOX3LrS0dc27fN2WHaTv4ONTiR
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3PR04MB8921.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(42112799006)(366016)(56012099006)(11063799006)(18002099003)(3023799007)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OFpQenZyNW5uRitSdGQ0YUlIZkwyL09NT24vRFNBamF5S1BtSlJ3U0NSREpN?=
 =?utf-8?B?YkhWSUtkNXBvRExoemh3WGJ5QklSZVROMnJpOUVuNlRjRTFzZHJ3eFowUlh5?=
 =?utf-8?B?VnM0ZUQyZENJcDIyV0J4Zlp6SzN1eGMzY0NpQVJOV3U0RjNYSm1uOHZCNERY?=
 =?utf-8?B?MjVKVWhiZzV4c09WRkZtdEJRb2VkRmdjT2NBbkNDTWk2bXFkS3hpYk9Fd1Nt?=
 =?utf-8?B?SWNkaHBWdDR5bUtuMVhLOWZ2aVVBbmpPRFZOTHBQbmpjZGNZeUJDRGYrT2l0?=
 =?utf-8?B?Wk1HTERHL2w0T0p2M1M1dlQ4QjQxQjlpRjV5bXlPaElIT3NWQXB3aTM3bjJo?=
 =?utf-8?B?Z0ZXclZpd1dTdVJyWldCOU1QQ3BQVjJUYjN4alNUQWg2d0o1cnV0bWtzcFNa?=
 =?utf-8?B?YjRaMEtENXY0L1EwTDNPRTRhNjg5MmpHY3NBcjE3ZXg4aXZ6ajhtUXpMdVgx?=
 =?utf-8?B?UTJZZHR1SnFBdUlpMFBIc3k5RGFLUVp5UmlpVkM4MWh2K0hPYXlERWJMTmcw?=
 =?utf-8?B?L1JLNHcrbXpWa3h2ZnhMS0RNZnJvOUZ2U0FnUmFINVFjczFTZTdoZUgwUkRi?=
 =?utf-8?B?L0dtaWRhdXVSVG10ZG1QUkRTdlBsckdPaHo4MTc3NTFZQmJXR1hvY3N3WjVR?=
 =?utf-8?B?ZEcrSEYwRzZsTnJZd3VrTmxYMmgwQ0xHTnJxNXlIeUpOLzZXdENsKy91dFlh?=
 =?utf-8?B?Y091T2RUMG1vR1lPRmhteStWdVdQTEVxd3hyeG9jYkVnYWxWcU5LSnVNNVZL?=
 =?utf-8?B?TEJDanhiTDcydWhVS1dMSDFMTmtkekhrdnl3YlZWMFVKU3NvZitUcU1FRzZz?=
 =?utf-8?B?T1lSSVFiZnFueFFQTEdCNnVBMEU5QjJnNXJNbDJQVi8vY3pwVjRDVGt4cmUx?=
 =?utf-8?B?QlRxb3hBc080bU5VYkIwVU5xcm5NSFlXYUtTUjRzdVJkWUlHdmVCWFdhU1hN?=
 =?utf-8?B?VXdBaFhXYWFrZ01iYnJZenZ1U21lOEk4QkY4NDZXTS94TG9td1BtNjhVMW0x?=
 =?utf-8?B?SnpPUnA1MGdzY0pKNUYzTFpPclovQWlOaU9UYWNJbndJQ25jVjI2cTc5Rlhx?=
 =?utf-8?B?TzZPNklORjFmeWZVN2xNWjljekQvbG1RN0tTS1lUTTl2cVJ0c3ZMZVZ0MlVH?=
 =?utf-8?B?bktieWhmVjM4aHgzc3pCWDMvWU5JM3B2RnFTT25RRGZqNmVzN3BJK0hzMEky?=
 =?utf-8?B?czltai9HYjRHVzhPTXRidlRtQmpOZWEvSFRLK2J1Q1pYOGJMM29LQlpPZjlZ?=
 =?utf-8?B?SUtqd0EydVNYRkhvNTdsY0UwK2FSTHNZMEE1ekVXTCtNcWNnTi9CQlg0RkxM?=
 =?utf-8?B?R3JSK2dOTkF0ekRldEdndVZlRzJ5VC95QkZsZ0N1ZHJwZThrenRQamVNZy9l?=
 =?utf-8?B?WXArbVRhaEVnWm1iZWVmRUQ4bHJiYURVRXoyVDdzWmRDSk9CSDdwTmxKdWdR?=
 =?utf-8?B?d0JObUVXYlNUNnFBN2o4WUtzV3U1ZWp2UDZrR3F3aW1FZG1RSnVFZ0FuQXY5?=
 =?utf-8?B?b29HTUkzTnd1N0lrb1kvbTgvSHFoUU9BYnhPS2pOTzBOODFjaTl4Qlc3Y3VZ?=
 =?utf-8?B?YTFndkxzdDFuV2h6bWlZcU1QNE51aEZlemVjd3BXOTAyMUs4Vy8zNkpKWjE3?=
 =?utf-8?B?dWpHdlhObGJJejdUVS92R1RWRXJjQzJsQktaS1dRM2xOU1NTWWRYblVELzRH?=
 =?utf-8?B?Wko5dFBnVlpPMGdvVm1PWVpuNEtKZXMvU2pRSTNyOVQrUjZVZGVJYzFSZHFp?=
 =?utf-8?B?bzlpU3llVzJRQ1hpMU5SRmpqUEhGcS9NSW1jVzRyRUIyL3FBK2ROOTE0UDhG?=
 =?utf-8?B?bDR5OHhnWFBPRVFaY2l3MVRrdTFsNVd0Rmk1OC9wUG43bWF1dlJQaUcxTis4?=
 =?utf-8?B?bTYyOTJKNHkxcmloRC81QXc0SWkwM2pqOWJNc2xGNVFaNVBIdno0eEh2cVpV?=
 =?utf-8?B?RjZTS0JUaDdCanl6QjFNZWFFVzlvSm0zUUZsUERqdDdqS2grWC9Gc0tXQW1Q?=
 =?utf-8?B?c0hvei9Xem5wNHlBd2UvWm1KOFRPcE9oTCtVeG1FMkJOb3lRSlVrdUl0NDlT?=
 =?utf-8?B?Q2d4aXZQc0picHhxbVB5RkJJTDhKWGovcitneEM1REJuMHpHZTJaOVVtSGta?=
 =?utf-8?B?U1VQK0VNR3JjZHhGZ0pwL2I4M0RVcGo4UWlDdC83NTN3SWZjTTJEcFZUSHZy?=
 =?utf-8?B?V0h3THZRUE52WEVsVGFPajg5YndZUnBmVTRJU1ZXWjRHOFZnbC92bjczQ1Bt?=
 =?utf-8?B?cTNVTGM0MTJwV3gwNnFWbGxPaVUrc2NQSjI0dzFHR0hYOVlGSXdlNnNyMnNJ?=
 =?utf-8?B?MVRSMlRlZ01IcU52bld1dEdIL0RqSzl0U21mNEx0eUJ6S1VNdTVCUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: transsion.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SE3PR04MB8921.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c475c9c-e2fc-41ed-381e-08decd02e4ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2026 06:29:04.3216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Awk04xqSbb3arkWKfq283wPpdkKSkqnEAz59m69ZDnHPDfxQx0UaZ09shBlIpc168AiSqtSu3QEorurh3D3aOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR04MB8142

RnJvbTogQW8gU3VuIDxhby5zdW5AdHJhbnNzaW9uLmNvbT4KCkFsbCBlcnJvciBwYXRocyByZXR1
cm4gZWFybHkgd2l0aCBub24temVybyByZXQsIHNvIHJldCBpcwphbHdheXMgemVybyBhdCB0aGUg
ZmluYWwgcmVhZC4gUmVtb3ZlIHJlZHVuZGFudCBjaGVjay4KClNpZ25lZC1vZmYtYnk6IEFvIFN1
biA8YW8uc3VuQHRyYW5zc2lvbi5jb20+Ci0tLQogZHJpdmVycy91ZnMvY29yZS91ZnMtcnBtYi5j
IHwgOCArKystLS0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1ycG1iLmMgYi9kcml2ZXJz
L3Vmcy9jb3JlL3Vmcy1ycG1iLmMKaW5kZXggZmZhZDA0OTg3MmI5Li41NWQwODg0ZGQ0MTIgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzLXJwbWIuYworKysgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmcy1ycG1iLmMKQEAgLTExNSwxMSArMTE1LDkgQEAgc3RhdGljIGludCB1ZnNfcnBtYl9y
b3V0ZV9mcmFtZXMoc3RydWN0IGRldmljZSAqZGV2LCB1OCAqcmVxLCB1bnNpZ25lZCBpbnQgcmVx
X2wKIAkJfQogCX0KIAotCWlmICghcmV0KSB7Ci0JCXJldCA9IHVmc19zZWNfc3VibWl0KGhiYSwg
cHJvdG9jb2xfaWQsIHJlc3AsIHJlc3BfbGVuLCBmYWxzZSk7Ci0JCWlmIChyZXQpCi0JCQlkZXZf
ZXJyKGRldiwgIlJlc3BvbnNlIHJlYWQgZmFpbGVkIHdpdGggcmV0PSVkXG4iLCByZXQpOwotCX0K
KwlyZXQgPSB1ZnNfc2VjX3N1Ym1pdChoYmEsIHByb3RvY29sX2lkLCByZXNwLCByZXNwX2xlbiwg
ZmFsc2UpOworCWlmIChyZXQpCisJCWRldl9lcnIoZGV2LCAiUmVzcG9uc2UgcmVhZCBmYWlsZWQg
d2l0aCByZXQ9JWRcbiIsIHJldCk7CiAKIAlyZXR1cm4gcmV0OwogfQotLSAKMi4zNC4xCgo=
