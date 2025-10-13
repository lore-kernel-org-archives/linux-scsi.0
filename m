Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34FC2AD1F;
	Mon, 13 Oct 2025 03:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760327927; cv=fail; b=F/dQVbNK1MlFhrM8myGd4cS1/PpMme+urFfrq13IaRgY4nktewCOcW4lndnftLpSqHl98djirAiLaTikT6lBjfkgq62xw9vKR8xNJNcXIlPjftevD97IDyAPcSvdD0saw3h+queUzh02C/Px1QbM1qgiFJTP4F7G6ZK6zCzlSxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760327927; c=relaxed/simple;
	bh=3DN5PRZb9G06hZBY9Xs12+QVN6abLsq3qf6K6mQsYC4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=esk6nM2fLrxLFceErMVD4yv16NekyGE8jy6DMBYJBy/7Xyf5m/BO3h7qgdQfVMtKU+st04/DXiTg6UFXp1LnN+uJkuuqzEEm/uOq1YcvfKIpjTZLCgpmb9qp9BSlgf9f39XuCHwGSfsvSTEuKJAUeJCksmzcDw6T19Mz562RcrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gdnIVIJt; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=KFs3Xrye; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gdnIVIJt";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="KFs3Xrye"
X-UUID: e4d5974ea7e811f0b33aeb1e7f16c2b6-20251013
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3DN5PRZb9G06hZBY9Xs12+QVN6abLsq3qf6K6mQsYC4=;
	b=gdnIVIJtMTa9YVoLezqJg7MGKztk2ve1nDT4ImHdoopSIjHTqbgiVfy5gff/JQvpaljuqmpJViESEck2/CBDYstsLLBSGCwjYQ6vjOP86bu5OeZ4jnZyoxqfmwObgZA0jgqtTLHJfcUwNXlqyp53hXP75+7KfqlGyE6gi0z4Q3Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:17126a8b-fb54-4570-8120-f45bc806f37e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:f2befb50-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e4d5974ea7e811f0b33aeb1e7f16c2b6-20251013
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 487942874; Mon, 13 Oct 2025 11:58:36 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 13 Oct 2025 11:58:32 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Mon, 13 Oct 2025 11:58:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qR5aVZhnE7bOvd+mZ2+tDKpOwtYgO1EsY4537EermDz4oF4JHslrAY6xHvDXTE+wP1Hz57Y/oCJCFC5QH7msEhiNAl4XMwn7AIUIJI0tHQ6I7B9k53uAbDZgLp2aPKIoICrhAi01flKiuy43YF07VS4NFryZ7fuhDiEJrBym3RwDPlVdtnUr24A/3fw5tcdTmBTh8cfejc5i3VU/GhdP6zhyMMVXJoyMFo02ScwybgN32u+d+O0phQeAFJfqfm+4hZtY5eEgOfCiCnnkBP/QCyVt3ci34A0UdoLaZ+Xu+KjV6X/3QAvJ7C2ghAQc+DecE7QKb7DWnaycMe0OKewbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DN5PRZb9G06hZBY9Xs12+QVN6abLsq3qf6K6mQsYC4=;
 b=Af4YJ3Sicbyb2TYKfhI+xFZDAi3xsM/wZ/DikgGJFaAmg8mMnOBUj89J5J98bgQC+4ZlJS4BSMc9WbQnq1cklfWKzTT0SS3J+28Pa7U4YBM/Ry9Jv/FPXX0LzncKfS7wyoX0r7qWr9LVRgxKXgJC8EJvRJFkP+2BLbVs/kIvIpWDJRTc2orOqOlRbnDkL1UrAxH+XYD4LbF7ICSKWXL/xhawHEO1NRt7OgmHZ9xsUZE4ZuvDscY9qQ7/aJnAJYoJYenfaDa1sLXJUaLy4qTQr60aCCTwN0/geGooBxJ1tBF3772kvG56BK7Z8bARsxu+5uLKjVqo/ReZ9neNqeX0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DN5PRZb9G06hZBY9Xs12+QVN6abLsq3qf6K6mQsYC4=;
 b=KFs3XryeVYcHSf2QR3k8/wm7vovdcncwAG5MPkxmyDCSilJP7SwpdS3jlIdqQPUC9nXSdEMSXm/ooSdM26y1UZspRYxCrl4klhF9h/pL875yYxMkAuFtz2obUcFLuSfBm9wZblDFEy9HIrZqwMrurNTbPz4n7C/ZRLVs7I2x5W8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6712.apcprd03.prod.outlook.com (2603:1096:4:1ec::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 03:58:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Mon, 13 Oct 2025
 03:58:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "ebiggers@kernel.org"
	<ebiggers@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Replace hard coded vcc-off delay
 with a variable
Thread-Topic: [PATCH v2 2/2] scsi: ufs: core: Replace hard coded vcc-off delay
 with a variable
Thread-Index: AQHcOVjwmrnXws3nd0yuw4TWGdaIsbS/eJWA
Date: Mon, 13 Oct 2025 03:58:32 +0000
Message-ID: <714110b991f9ced2c8d496afc767d8666ad8332a.camel@mediatek.com>
References: <cover.1760039554.git.quic_nguyenb@quicinc.com>
	 <7df97c5bf49d7e53435725062bcff2ccd77a6959.1760039554.git.quic_nguyenb@quicinc.com>
In-Reply-To: <7df97c5bf49d7e53435725062bcff2ccd77a6959.1760039554.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6712:EE_
x-ms-office365-filtering-correlation-id: dd0d79a4-a83d-4633-0a67-08de0a0cc6d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TGZOVHZrY1pESEFZOUl3SGJUcEd0L3JpTEdpRTRXcndiV1lsTm1Sby9KNzQw?=
 =?utf-8?B?M3VmNE53VTc4cmY3NG94ektIRFRVTWpnbU41VzlUdllKOWkwOXEyYjFEQmky?=
 =?utf-8?B?Y1pBSmozK0EvYWZ5NDR5WFRhZHJ1VkZwSk5pdVBpTWpEeVpJVjlnazRia3FH?=
 =?utf-8?B?cGNuL1pSUy8vMWxEZUlSSzE0U3cwR092VkhoWk1pbno3Z0lUMlppTGt4ajFF?=
 =?utf-8?B?TnJZTjFQSEh1bXRvZDU3Y2oyWDdURmN6WFJzYTBDU1BsNVF6ZUFqY2cxOThi?=
 =?utf-8?B?SjRVOXBITGdQVlduYm9kbWRQR3ZPVzBhTHBFZWcvVWdRRU1ua3o1VFUydDBX?=
 =?utf-8?B?aHlFNytvVy9adGk0aUxGTm5jVy81QWdydG14NWMzaGVzUmJQTlhkYTIzUU1I?=
 =?utf-8?B?L28yVjJWUDFPcWtIZ2QzeHA1R2R1Q3Y5bDQydG1EQW10OGQzY21UYkd5dDYv?=
 =?utf-8?B?Yjc5UWh0cHc1WFE1dStRbVBEWU90WWR0TVpGVjVMZ2piZnFxN3MzeldHSVZR?=
 =?utf-8?B?dU5zV2VXbG5iSG5xeTZnWTVDWjJMN3loQTFDeCtwQ3BLZ3k3TysyN3lqclFH?=
 =?utf-8?B?MHdkVmRkdjdnVGh3QzNuWTJKQnpZOFZPc1puYmhueDVYazAyQVMvWjlXdHpL?=
 =?utf-8?B?bTZaMXdkZUVmVHZUUk1KaGtMc0YybWdMdnBUVDFRM2FKTU1odjZzM2Vremha?=
 =?utf-8?B?T2hwMGlmeXF3ek1NQmczanJTLzhQWmZxTU1GUE4yTWdQbUpFSDZyTzR5NXdh?=
 =?utf-8?B?bitIS0JudGI3SVBZM1R3TXdVU2E2OUdyWXJFcXQ3TUpwblJpb1IxWlV3SVRl?=
 =?utf-8?B?dE5HcW9XcWNkeFBJWkpHam9ZVSsxNlBGTTB0MDBCNmc5TTBucnJ5TWNRMFBE?=
 =?utf-8?B?RkgrdnFqbjFrdm9BaFo5bG4rTUNlL0NScWRnN3B4cVllN29wMHJELytmTHd5?=
 =?utf-8?B?MEdMZnhaUnBNSmN1b0lHdFJFTDkvbkFzT09WK3VBSEJUN0NoMGtDblJxUHlt?=
 =?utf-8?B?SlVkU28xeGNjS3ZRN2ZhUjZlaUpPZTlpNEpuOVpHaDkrTVdCZ3JTQlB3cnlx?=
 =?utf-8?B?dFdDSTFjMlJlS0FCVHMwZHg3WEFxQkhoY2djdnd0Nk10OS93YytheE9yUll4?=
 =?utf-8?B?azlxRTd5S2lLVFF0RzJwSkxlNnpscmE2dEV6WThXK29EZkI5Q3ZjMUE4Tndl?=
 =?utf-8?B?VEk5cTBLbmxtbHlvdTNvbzYxeTNDM3VhR0UyR1JpN3pJKzFDcG0zQzNIeGZF?=
 =?utf-8?B?cmE5c2hTNXI3VU1hQTFjclFScThYMXJwejlHQU0wc2NLM3NiTFBXN2daYWFL?=
 =?utf-8?B?aFpvUHFMVE9xRGp3L083RVgwTUZJNGVlSkh1ZFRWYWd4VVlnYTE5UEVQZHhy?=
 =?utf-8?B?N1MzTUk3cGV6KzZYNUFzS0l1SzNtR0Z4NFRWRUNvSkhOTVNSUGczdDBoOWln?=
 =?utf-8?B?cE5Ca0diQU12eU4yTUEyaFZ1WVRDSnBoRUJqR0c3bDQxNXYvMFJhUGNIYTdy?=
 =?utf-8?B?V0RyVUVDZ0lWOFo1eC9LVTV1UjMxV3FkYUpVOWJUWVlZYTBreEw4K0tCUHZv?=
 =?utf-8?B?OHZXUml1MFNia0JYK2EwUFR4RkdFaUE0OWNGNkV5alNrbCsreHJwa3VheGJz?=
 =?utf-8?B?cEdMKzcwTWQ3UFY4Umk5ZitXcDJWT2tTWVg2dE1NaDg0NlFLbDVORkhmeW1T?=
 =?utf-8?B?NGQrdmJVSmpmQVhLOXVodFViWldFSXdUaFlpWmtPN1R1SXNGS3FnaFN0MGVw?=
 =?utf-8?B?aUlzaUdjQWJhMWpCcTZYN1JEaFlxc1g0Rk5laWRBVFM1Q2JBTGxuNHFrMEhM?=
 =?utf-8?B?YTcxcnMvZFpXY054MmFXUEpUWDgvQkNKUXhLeURhbDJmM1RjaHQxa2l1b1lR?=
 =?utf-8?B?RUlmNVMxVEZINnp2ZHpZUkYwTmx5WUF1Qk9yNk9mSHp0RDA2a0gvNEIza1h1?=
 =?utf-8?B?Tjl2YTNjdFlNdkdBMTZaUGFJZlQ5MEp6dGZYclRCa1hIall3Nm9DL1o4aU1v?=
 =?utf-8?B?cW5qVFFxbG1CbWtmd3JaV0JUb3VNN21YOUxYV3AzTHlyUEdPTjRNbXJUaVF3?=
 =?utf-8?Q?MQ9BZB?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2locXljTmFWbDRVdlNXa3ZRWVBUUmtUMm9rTHdFTndCeFo2cWYwNUNYenFM?=
 =?utf-8?B?UFpPY0tLZmN6UDZOQlVqVVM4MkFJaXVDNHF0NlRoS3lYRi9uQ1Q2YmpMa0pa?=
 =?utf-8?B?V3BSMndjcHVRRFlxQUMwakQ3ZDh5dlBmSGlJY0dYRHZXSEx4K2cvRVd4ellY?=
 =?utf-8?B?cDM4WGVJWWovYUVNVnRncXRwR1laa3FhNjRDUWI5OWZGeXhzU3JDT3ltR0Iv?=
 =?utf-8?B?UnZ5eDJnY0lueHV1VG1rVG8wbWEzUC9QRm5MOWJFd1hjNkVmSVh2QkdiVi9L?=
 =?utf-8?B?TXQ5ZGxTM2daeEpFZlRJVHA2NWI3eS91SW9LVWpscldNYUtsUExHbnFDNnRE?=
 =?utf-8?B?UkRVRlpzQmRJUGlaZEpmTzFETWNIZlUwcHdlSFlyQktZaGVHV3Yxd0dvblhS?=
 =?utf-8?B?REkvd3FOc0kvWUQ0YkxLaUdia0d3bGpHcWc0YlhwaUtyckd0VUsvQlBJU00x?=
 =?utf-8?B?WGVSREZrdnFmZmRmcSt5TitRbWRKNnRNd1JNeTJRSEpOcGpHRkhJUDFoYUVJ?=
 =?utf-8?B?N2dIbHNidFdTSDdoQVh2NUtZdUpESnY3THN5dXZhYlFZejloU2wrRkw1Rkgw?=
 =?utf-8?B?QnFQTkJEb2dNbEZDTURETElzeGl0WFJOMTV1R0JMUFlZdXhrYVE2OTFhZXQ4?=
 =?utf-8?B?MHl0Z2Z4VExaeXhPNUdBOVI3Y1pPNTRlZ2JoZWgvbG9kQUo4WjE0Slo5b2w0?=
 =?utf-8?B?djNDN1FuWEl4dVBuY0pTSnlXc3owR2JHc0R5UVMyMUtYYUI0QitpR2dVNSsw?=
 =?utf-8?B?QmJnd0c2MVBiKzhPV1dBdUk0YnZ0ZFNoT1BpMVJTZ0dhOURNbDlWeEJGMWxi?=
 =?utf-8?B?S1BEdlR6aTE3dHd4S3Ntd3FnOVEvS0tDekt4ZjBBcUZQRDNKZitPWWxUSWNV?=
 =?utf-8?B?dWdLSXFwQmNUL2M4OW1kSklnTUhVUU1hWXdIR0p3VHFmendsWWY2VnByTW8y?=
 =?utf-8?B?bVd4VjJUYlNxZmM3VnBZSE5qQlAwUHZWbTJqWmRFR252SmwwTStWdmtvMklk?=
 =?utf-8?B?dW9mWXhSVnRKRWRMVE5GRHZ0dE9mOTlaVGEyd2FRZi9GYmZiZURWNnM4N092?=
 =?utf-8?B?bHNTcUxHWjVrc3MwWnlnSUlGdDdKdXUvYXNFZHJNL3lSWVVtQThrYUVTMTdt?=
 =?utf-8?B?OE4rcC9JY2NTbUcrK2Z3SzhrMzI4aCt4RFJZVjVMd1hoN0NGN28yRmd4RnZ1?=
 =?utf-8?B?dWg5WGo4UEg2ckNjZ1N3Qkc2Tnk1ajMzTFVZQnovUUFFbktHNHVxT1dWcDM2?=
 =?utf-8?B?TXA0cnVVQlFvUjA2UWVWZ0pDcTNObE1IMWdBNmNOb3poSTVkajVNcGM2WVpR?=
 =?utf-8?B?dzJuVHpRMWZoV1pMMEhwbWdZV0IveEFhbmtVeHVXMXlrNHJWcmFJV2dnVFNk?=
 =?utf-8?B?VjgvQlFuUWVzNVJGM08wWnVHeHFWL2E3a2grZVhMNG1uNDdRWkVKWEZFTEdD?=
 =?utf-8?B?S0N5aG5oN0NnTGpZaFBVa2lNQ251RjJBa1BhNUhkQmpZZDlIL0UzOE0rclZK?=
 =?utf-8?B?dHhMdUNxVncxelV3UDlvM0VTNE1Ea1hjQkdUeWNpRGg1bndhN2UvL2JDb0Q2?=
 =?utf-8?B?TUdvcEZrdWI1NDdvcllsOEhoeEwwVmtnL0JZZ3E1ellVYmJRQk9semtnQklS?=
 =?utf-8?B?VEl6MGxQb0ZRRlB5MWxWUWVmdHVIczlqTnJqNFV3cGFHbTRsblBsT3ZFS2VT?=
 =?utf-8?B?a3pyQnZXSHFtTkduUFgyazBOMENJM2lQTjMyZUFyNjhtYnluVE1YOFU0bjhi?=
 =?utf-8?B?dDc5YmxZMEVHZzV1Y1VRdHk1MjA2UEFYREFianlwUXh5bW1GajdHdkNvTmpF?=
 =?utf-8?B?QmRlamdRdGJkakwvZjJrSDhmWE5yOHJtWDNGYlg5WlNKUnhuSzNWWDRvaHFq?=
 =?utf-8?B?WFJ4R3EvbEJDZzdXcW8wV3ZuRFIybTZzeXUzMldEeHRPYVZGbkMzMlZrWmh5?=
 =?utf-8?B?VE1wZU9ESTZsaGNYd0tSUUF0K1AvQTFCVC9XRnJYUjZjSWRTczRqS095SnI5?=
 =?utf-8?B?dWowdlhKNGhubURFT25FTGluVXpUNU1mYzIxVnVMbkt4a1hlQXc0eGNnak5F?=
 =?utf-8?B?bE9ld3ZWMFEzbFVIRGRwYlBaMjRxR3BSY2NING1oRzNzMkZBckZNZUJOUll4?=
 =?utf-8?B?R3Q2SXUxTEFIanhMeFNzR29EdlNzanlhNXlkVlU1QVJ5S0hBczJ0Q1pHWkVk?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B97906680C867748A76AD7AB4F2AAD71@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd0d79a4-a83d-4633-0a67-08de0a0cc6d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 03:58:32.4400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JcwPsCvV5fv9K+HUCW6RJhcI3ahv8YY1KzE2LfvbNyLZzVE94A5JlzmFkPjp0lTVX54B/3MzUc9QUqKZj8ICsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6712

T24gVGh1LCAyMDI1LTEwLTA5IGF0IDEzOjEwIC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiANCj4gK8KgwqDCoMKgwqDCoCAvKg0KPiArwqDCoMKgwqDCoMKgwqAgKiBNb3N0IHVmcyBkZXZp
Y2VzIHJlcXVpcmUgMW1zIGRlbGF5IGFmdGVyIHZjYyBpcyBwb3dlcmVkDQo+IG9mZiBiZWZvcmUN
Cj4gK8KgwqDCoMKgwqDCoMKgICogaXQgY2FuIGJlIHBvd2VyZWQgb24gYWdhaW4uIFNldCB0aGUg
ZGVmYXVsdCB0byA1bXMuIFRoZQ0KPiBwbGF0Zm9ybQ0KPiArwqDCoMKgwqDCoMKgwqAgKiBkcml2
ZXJzIGNhbiBvdmVycmlkZSB0aGlzIHNldHRpbmcgYXMgbmVlZGVkLg0KPiArwqDCoMKgwqDCoMKg
wqAgKi8NCj4gK8KgwqDCoMKgwqDCoCBoYmEtPnNsZWVwX3Bvc3RfdmNjX29mZiA9IDUwMDA7DQo+
ICsNCj4gDQoNCkhpIEJhbywNCg0KU2luY2UgMm1zIGlzIHN1ZmZpY2llbnQgZm9yIG1vc3QgZGV2
aWNlcywgd291bGRuJ3QgaXQgbWFrZQ0Kc2Vuc2UgdG8gc2V0IHRoZSBkZWZhdWx0IHZhbHVlIHRv
IDJtcz8NCg0KDQo+IMKgwqDCoMKgwqDCoMKgIGluaXRfY29tcGxldGlvbigmaGJhLT5kZXZfY21k
LmNvbXBsZXRlKTsNCj4gDQo+IMKgwqDCoMKgwqDCoMKgIGVyciA9IHVmc2hjZF9oYmFfaW5pdCho
YmEpOw0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91ZnMvdWZzaGNkLmggYi9pbmNsdWRlL3Vmcy91
ZnNoY2QuaA0KPiBpbmRleCAxZDM5NDM3Li5hZDQ5OTc5IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRl
L3Vmcy91ZnNoY2QuaA0KPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiBAQCAtMTE0MCw2
ICsxMTQwLDggQEAgc3RydWN0IHVmc19oYmEgew0KPiDCoMKgwqDCoMKgwqDCoCBpbnQgY3JpdGlj
YWxfaGVhbHRoX2NvdW50Ow0KPiDCoMKgwqDCoMKgwqDCoCBhdG9taWNfdCBkZXZfbHZsX2V4Y2Vw
dGlvbl9jb3VudDsNCj4gwqDCoMKgwqDCoMKgwqAgdTY0IGRldl9sdmxfZXhjZXB0aW9uX2lkOw0K
PiArDQo+ICvCoMKgwqDCoMKgwqAgdTMyIHNsZWVwX3Bvc3RfdmNjX29mZjsNCj4gDQoNClRoZSBu
YW1lIHNsZWVwX3Bvc3RfdmNjX29mZiBtaWdodCBiZSBtaXN1bmRlcnN0b29kIGFzIGEgDQpzdGF0
dXMgb3IgYSBmbGFnLiBJIHN1Z2dlc3QgY2hhbmdpbmcgaXQgdG8gYSBtb3JlIGV4cGxpY2l0IA0K
bmFtZSwgc3VjaCBhcyB2Y2Nfb2ZmX2RlbGF5X21zLg0KDQoNClRoYW5rcw0KUGV0ZXINCg0KDQo=
