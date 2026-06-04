Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE78373C1E;
	Thu,  4 Jun 2026 05:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780551606; cv=fail; b=V6Duhn3kr71DzMIw6mPOdQUgDovexQUclAZ0Ye52odjTy4Sp7z1X1Sb7mOJjGJz+TnS+ZQ+Pg2fIFqoRktCc/JM4WZEjZlh8I4kHw5Shh4bWpnpCeW8iPnBKkq0i/2Gv7q2F1Ty2oqHpULtNcF+Ktgoe5IuPoRCaBPayHeFCyo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780551606; c=relaxed/simple;
	bh=X0fQ6rYP236od6RGJn4L2VFfFCSFsZNDCq94huwCQeM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ULuakQXqwwJwH0R1cm7HwuUMOLfL7MidJUDRRkAjMFg/vztgYhqk6H5eVS9Bqp1O9X0Ngy4/9vIWhoMHMA5WqAN4PcoP+pijHAG+MpYEH3Pd6pkWdlWPVttmINLnKQ05IXAW4L8WeKIUmhF3fadiNViBA2fXRCB4l7bw/zLoQuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JAqWzXor; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=TlIUaD53; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JAqWzXor";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="TlIUaD53"
X-UUID: cf2adb1e5fd711f1b1788b6acf885367-20260604
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=X0fQ6rYP236od6RGJn4L2VFfFCSFsZNDCq94huwCQeM=;
	b=JAqWzXorR2zm6NrJkD1yNgO5EyL8quHt8D6BHMQycfkf+1jAoPjoXsKR0mWsbyVfAhx7On4JBBPcz7gfzCzJXs3jPCJ6wtP6mBzfmqdTc1QrZuok1VOue2iMpwYW8oIWiCUXhTCayxd1UyclkNt/YbWI/w0NajvOPr4Fhal+oiw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:2c731302-09c5-4627-ba2a-825096507319,IP:0,U
	RL:0,TC:0,Content:7,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:7
X-CID-META: VersionHash:e276073,CLOUDID:831c1450-23b6-41e0-a310-51c498ab6908,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:4|15|52,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cf2adb1e5fd711f1b1788b6acf885367-20260604
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1053249120; Thu, 04 Jun 2026 13:39:52 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Jun 2026 13:39:51 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 4 Jun 2026 13:39:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KatVNEzeUlxL/nf55qFa6EmH+jqarzFxYX60IV3/eqcdEsE19H9C8r9Z9uTTrAK/ZPDjJ4gaq2vqjoIPduD5ylXZecoYasQmBVvnqgWoGUKJMVmQAlzoCRDjJd1n1CLaizbWhjn4uebkAiDhljU9SomULWfQj68gRJ5riRmlldWcG2lrBeAuurTj6wNcPmMwwWDXHH7yZxSGeH61Uq/kPqSiSslGXXMKm8kkXxKo1jlCiRovNknImtnjxu52Klc1q+MS3IRCJQecvADxNCG4eB/S0yfFqoqovrlQYqBz4H7NuROwlW7YoPHym8TFqww8tcywnbNLeXmqhsI4VFmHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0fQ6rYP236od6RGJn4L2VFfFCSFsZNDCq94huwCQeM=;
 b=cyiRLFvfthnuxey4+Q9DLrzwMYxQD3AyndwCyIudnFwNDJFGDLmbYd2a5vb9X8U2Hgspega4qxSgPmG4M2Mi0EYY29TBoSPitEN0BeyPMfHudGqZWWP21T0GYOwvEYz1ni2JoBxtjZVWmV3+XYciK0ikTjP/sLKoRHZbw7qiblj2gpc8d0JFYTt+8Q5b6sqZxff4XoLAjGZVGYJJMllKG5AKcZMUIixTirkK6UAO5C065izIqEfPeacFZqCM+fA3TEjLX/eS4UimvsUlw33uTywENBVGX0tRHjXPiHkjJlcdMorDsC340cLnfmwVC7lq91rAisdjZGYgodo+m9Hrdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0fQ6rYP236od6RGJn4L2VFfFCSFsZNDCq94huwCQeM=;
 b=TlIUaD53LT+EmPvyLizwXkd58yc8GucKhHATpLhNu3krMznSV4GD6OHSt+yLqK0W1/+xMiMAqbMpe3ywB/5VfTobI/VddFHWj/vzK7fnhxVsVSy4BVC4B6jg4mH+lolyKMEmxD7I5SOo1eC/sE+3NN7crnTBNyfHqsNbrtnJoWk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSNPR03MB10373.apcprd03.prod.outlook.com (2603:1096:604:49c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Thu, 4 Jun 2026
 05:39:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 05:39:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "hongjiefang@asrmicro.com" <hongjiefang@asrmicro.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Topic: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Index: AQHc8o1A3BWLkA6ncUmhT2LgQSEKpbYsZsGAgABEegCAAABAsIABOIWA
Date: Thu, 4 Jun 2026 05:39:48 +0000
Message-ID: <9b00734a666a2b68a3a6dfb31ce78ffccc5c3686.camel@mediatek.com>
References: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
	 <7404d3067b87d33bb446a1b7f4432b5ae9d98486.camel@mediatek.com>
	 <5c2f95f00b484bca9c5df97219230acc@exch02.asrmicro.com>
	 <27ad241130a34ece8d2645b687f6ffc7@exch02.asrmicro.com>
In-Reply-To: <27ad241130a34ece8d2645b687f6ffc7@exch02.asrmicro.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSNPR03MB10373:EE_
x-ms-office365-filtering-correlation-id: 3000020b-62fa-4339-0c0a-08dec1fbb15f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|38070700021|4143699003|11063799006|56012099006|3023799007;
x-microsoft-antispam-message-info: 5gAyNl9RDrUfrPp46Mglifs9BEYKh2OhnxpGZiwnDmYW/Hmam2b6U8BOEydm10cF187z2C/kH4S9to7al3mDmY0966y3UXA2lCbAxno14+Gw/pYg//XAEOJhi/F3NKLvvSTKwVqRrLK6ZmnfLcG2PIWQMxIX7uGYHwp7iJOculqwbWaYg+Pf2VL6Rf3Bo5meDkfEeKiK2Sgimfj1larSio2iu1NVqzAM6gpS5fcTnyaCk9aKgYPRkXYq7wjJmObS3Gi7q4BrRXj+wyAJzrmkI/T8Onr7PTf+srHJB0+rHVUnuAfuXT2eQhojtaML48tFssbCXIVc42rlG6cMCJAHs/0Wa+qu+ltsEvVl3r4ShoKXnz6H1ygq4DsBH3GmLv4CDbOPQ3c4OIdcnpLFEvTHIjkesjEkFr+5TB4PQkYGUjTVI0sGq064tCAt7loCYy7sbhDnJyTZn6buLd+WXVVT42QshT6PLW4DhrduDbW9LLKVqJzTNiH/ufeW/VKpOUN3atGjLrzbCg8iOLMDjMrkDnpOXc1T/Koo94VL98XJ1vyh3FrjticwBYihd1hlA68mAkBZCmjVacCsThJWfaMiqmYTSLlgI0RilC7pFJCZoktKYScV1ltIeIhAQ08UXhoCrnmxd4l1FZ7A1Z6b0vht2UIFuKDTbum7IPK1AQeDGJnvVm3gVsXyEZ/zMkCDtOEevMOcWhOdbdErhy/ENWtBbUdUCBW8vyLVVyKx2fQOHXPnP5xzSG0roEw71qNqRurW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(38070700021)(4143699003)(11063799006)(56012099006)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWg2OUdUdzlTYnNIWk1FSXprSStEREJ6Y1hnRy9oaDhQRU1yN1NBWWhiUUx6?=
 =?utf-8?B?YUs5VlVQZHY0RXJSaHBLa2NBVUl2TmpIdHB5alJwNjRCVG5XNEhUWEt3Umtz?=
 =?utf-8?B?T1JJQ2tSaE5WcE1NV0VYdk5oVWljc3VoSWJOQnBwNVh2T1Z5RFVuY3d0UXFi?=
 =?utf-8?B?UU9QL01oQWwyOXFmUzZXd2c4ODVPbE1RUnRidms4K0t5YkFkUHZLbGVwK0NF?=
 =?utf-8?B?eWZ6M2U5eTlRdHV4SkpaOGpTRkNZUEVaUmxvRGVXZzArMkhoQ1BJUVVrVEJV?=
 =?utf-8?B?MXNvRHlZQTJwWmtpKzh0VllUZGdvWlVwM0RGTENQdnlyMnRGMG0ycEtkRWpj?=
 =?utf-8?B?NWpJM3ZNbW5MSDh3S204bTUrakJGZEQvVjJOSUhOdzBsQXpjOUVNR1lndlVh?=
 =?utf-8?B?SFhDdk9jZGYwa0x2TUFCV2F0Nm9Ya3lBRlhKZGZyME5SdGZSZmxwWEdvKzJN?=
 =?utf-8?B?R1ZMcnZCUU1YUU9ZcjZjSVRpenFmVnBPR3RNVWpoN0hQY2JJOWtCY3k2cHda?=
 =?utf-8?B?SHR0Ni9YZWtSTmdDckxxT2pOVjRZNWVsNnBQK0QxWVMvWGlOSE9Pald1SWJn?=
 =?utf-8?B?WVYza2I3cXFBb0E2MmpUdVg0a3ZtVmg1QTdTY3g1d2FnQUpqbEJpajBPbEl5?=
 =?utf-8?B?c1pEMXNzanRFWGloMEN2WVNvdVowZmp4ZzZORTh5STAzTzl4V0JsNjA3Ny80?=
 =?utf-8?B?TDUyZk1HbjZJQXVHRmt1by8yT2J2Z0tMZzJISEtDOXNxZUVBd3RNbjVmVWs2?=
 =?utf-8?B?OUF3dVkvRWdjN2FYU0ZqWHRZZzBTeFE0RURaSElEZVhPZ2JBYlpzVzlVN2d1?=
 =?utf-8?B?UzBtZmtVMEJjaG5KU1BXNHdoaWFIWk9IbzAvc1VLd1RTVHlUTCtwWDdaYnpW?=
 =?utf-8?B?T29VRkV6Mll0czVKdmdkN0xtbnVNMFVXallzUW04V1hueWNQV0VTb0RYK1g0?=
 =?utf-8?B?MnVaWEdmcHdwczBNSVI0L1JDV2hGem1YQW5CVFg2U0xRNWJUYWdVYm5GaVA4?=
 =?utf-8?B?MUZWQXhVT2plZ3VYZWpJNll6Y3JtNzJ0eTd6a3p4OEZVeWZlVktPYVhMWDZS?=
 =?utf-8?B?MHcrT2psSlNzZVd2eG5sUmIvWWo1WERWVm9oZjI4NmRHK2t3MWdRQWtpV0RC?=
 =?utf-8?B?N2dGQjNjaFlPQTdVdlViZWdwTXMrWUVYQXJES1dSbXNWNERabk92SnlsQ1Ny?=
 =?utf-8?B?MTkyTWJlaHB5MlpHRTRuL3d3RUdBUU5UL2FyaE9taGM4VGlhWGpTS3lLTTRO?=
 =?utf-8?B?RTd3RVQzVE9mRFVreHFzMXE1Nit5Q1cvSkdKNlJGRHpwUE9HWWhYUVppbG5W?=
 =?utf-8?B?eXRyY3Y5UUx2VzVReHU1VmxrWDl6eTg1RVdNVDM1WWRhSEh2OUlMbkF6NGdz?=
 =?utf-8?B?b0V6ejl0RGFYSTdoNTJaN3plZjdPRGI0cGJEY0kvVDlEdG1vY21mcEVPWWdL?=
 =?utf-8?B?YkFXUy9kMGFLWHFGQWpMUzhYMkpXZm8ydzBYczdmSlp0V09iSklkUExVTDNa?=
 =?utf-8?B?ZkJjWWNVRUVuc05UbWt4elN5NmRTVE56a2luSW5haHhnWHMyMTMvUFNTejlL?=
 =?utf-8?B?Y2VleXpQUnhCa3Q4L1h1c01iV0t4STZaZS9SY2NHS0hKR1cvcnVFMlhtRE1l?=
 =?utf-8?B?NTgybjl2WVVvemduS2FTaEZOTGhyYWRUTUtMTlE2UXVWcjgyMzNzc2pqR0xP?=
 =?utf-8?B?Z0E3M240a0V3Tkw2T2QzMC9ObGt0cVFlYmZqUFJoajNtMUNFVWRVNGR6M1Ns?=
 =?utf-8?B?cWIyWlAvdUNXY3ZIRU9wMDJOWEIrdnFYSjJhTEVlRXc3cVpTRE51VHRVQzlJ?=
 =?utf-8?B?aE8xV3hxcGRGL0kvQnV3cmJOZU1NS2JCa0Nnc1ZtZ3NNeHZ6SU90emY5VG1w?=
 =?utf-8?B?ajh2Q2ZHTnN2WWZyK3NLN1Y1S0JrNWFWdXJyTmdoc2p3L2hCcGRBVmdQRzFK?=
 =?utf-8?B?QllhbkY0WVN1SzU1NXpMb245cUtLMnhRLzFmU1lRUEh6K3hDbTlvMTJQTm5O?=
 =?utf-8?B?VnExVXhmL1JmSzNMSTdXUHkzWURaeEFZTUNEVWJHcG9XUk5GRkF4UFI3am53?=
 =?utf-8?B?bjlYbmFJcFU1ejdyTFQ4enNaNGswZ2pGamNuRnpvbGtjRzZEbU9HVU44MzZX?=
 =?utf-8?B?d3dFQlRZdHhKVjh6QUs1RnE5L3JzdTZsZy9wMU52aFJxejVqaFFINU5sUTRN?=
 =?utf-8?B?SVdMbWJROThsVVdOWjE2V21IREdYaUp3Z0lQRk1kMDNyeDNwQ1BJZ0Zsem5o?=
 =?utf-8?B?aWNrQk5lbzZxV2puSmdWcnI0R3ZlUzVQejNBV3BsNnZneDBzQ3ZxRWk5WkJx?=
 =?utf-8?B?T2NSRzBENnk3QzVXdVZ5Ny93Ny82bG1aTzYwVHc3dTl3b2d1Y2VRd1RMc1pa?=
 =?utf-8?Q?h57MQcq/YlL1nc7c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CCD3CC20E50464285A0E8C574881EC3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: aNPJ2OK6j1hfyuDmbShL4wvIyKRNd+20tcevQPTG0WazqlRkkd3r5WnjoiJA1EQgo2R3YPtIAScdfQb4Ksn4Gcu80GZ4HfOOiHPacts48MJc40bt6kXM7UTLOYcs9ml1swBYgDHgpMfxRfDQAy3tTlFo3SmrsN7JyvNozUCmCEAXVfXHAGHAdxH7KUd7Y7VCtV41UZkUNT2a5DRVmLxMZmIZ13cNHS8spQudzgh6/2I1Vd6QYUBDRHSbATmL3BPDGPPBinofP+Mdpz0sPNrNAK1bqRgsAxqmbOm7zsTVNYdVIlT+QOBqcanwgHOaDV9EK120i2Wyq2RBsaj1kO8YAQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3000020b-62fa-4339-0c0a-08dec1fbb15f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2026 05:39:48.9638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hsDo7qHOAQLz8uC9bvGgGQ6XnveGSeFBxREmhWf20Wuto1j/QuDFIKxJAqAM+l6/rtydGgPc2PEjsmck+1oWig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR03MB10373
X-MTK: N

T24gV2VkLCAyMDI2LTA2LTAzIGF0IDExOjA4ICswMDAwLCBGYW5nIEhvbmdqaWUo5pa55rSq5p2w
KSB3cm90ZToNCj4gDQo+IA0KPiBUaGUgIWhiYS0+bWNxX2VuYWJsZWQgY2hlY2sgaXMgb25seSBm
b3IgY2xlYXJpbmcgb3V0c3RhbmRpbmdfcmVxcywNCj4gd2hpY2ggaXMgdGhlIGxlZ2FjeSBzaW5n
bGUtZG9vcmJlbGwgc29mdHdhcmUgYml0bWFwLg0KPiBNQ1EgZG9lcyBub3QgdXNlIG91dHN0YW5k
aW5nX3JlcXMgZm9yIHJlcXVlc3QgdHJhY2tpbmcuDQo+IA0KDQpIaSBIb25namllLA0KDQpJIGtu
b3csIGJ1dCB3aGF0IEkgbWVhbiBpcywgaWYgdGhpcyBjaGVjayAoIWhiYS0+bWNxX2VuYWJsZWQp
IA0KYWx3YXlzIGV2YWx1YXRlcyB0byB0cnVlLCB0aGVuIGl0IGlzIGEgcmVkdW5kYW50IGNoZWNr
LCByaWdodD8NCkkgZG9uJ3Qgc2VlIGFueSBzY2VuYXJpbyB3aGVyZSBpdCB3b3VsZCByZXR1cm4g
ZmFsc2UuDQoNCj4gDQo+ID4gDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgcmVxdWVzdCAqcnEgPQ0KPiA+
ID4gc2NzaV9jbWRfdG9fcnEoc2NtZCk7DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Bpbl9sb2NrX2lycXNhdmUoJmhiYS0+b3V0
c3RhbmRpbmdfbG9jaywNCj4gPiA+IGZsYWdzKTsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2NsZWFyX2JpdChycS0+dGFnLCAmaGJhLQ0KPiA+
ID4gPm91dHN0YW5kaW5nX3JlcXMpOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhiYS0NCj4gPiA+ID4g
b3V0c3RhbmRpbmdfbG9jaywgZmxhZ3MpOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfQ0KPiA+ID4gKw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0
X2hvc3RfYnl0ZShzY21kLCBESURfVElNRV9PVVQpOw0KPiA+ID4gDQo+ID4gDQo+ID4gV2h5IGRv
ZXMgTUNRIG1vZGUgc2V0IERJRF9SRVFVRVVFLCB3aGlsZSBsZWdhY3kgbW9kZSBzZXRzDQo+ID4g
RElEX1RJTUVfT1VUPw0KPiA+IA0KPiBOb3JtYWwgU0NTSSBQTSBjb21tYW5kcyB1c2UgRElEX1JF
UVVFVUUsIG1hdGNoaW5nIHRoZSBleGlzdGluZw0KPiBNQ1EgZm9yY2UtY29tcGxldGlvbiBiZWhh
dmlvci4gUmVzZXJ2ZWQgaW50ZXJuYWwgZGV2aWNlLW1hbmFnZW1lbnQNCj4gY29tbWFuZHMgY29u
dGludWUgdG8gdXNlIERJRF9USU1FX09VVCwgcmlnaHQgPw0KPiANCg0KU29ycnksIEkgZG9uJ3Qg
Z2V0IGl0Lg0KSSBtZWFuLCBpbiBNQ1EgbW9kZSwgdGhlIHVmc2hjZF9tY3FfZm9yY2VfY29tcGxf
b25lIGZ1bmN0aW9uIA0KaGFuZGxlcyB0aGUgc2FtZSB1bmNvbXBsZXRlZCBjb25kaXRpb24sIGJ1
dCB3aHkgaXMgdGhlIHByb2Nlc3NpbmcNCmxvZ2ljIGRpZmZlcmVudD8NCg0KaWYgKCF0ZXN0X2Jp
dChTQ01EX1NUQVRFX0NPTVBMRVRFLCAmY21kLT5zdGF0ZSkpIHsNCiAgICBzZXRfaG9zdF9ieXRl
KGNtZCwgRElEX1JFUVVFVUUpOw0KICAgIHVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKGhiYSwgY21k
KTsNCiAgICBzY3NpX2RvbmUoY21kKTsNCn0NCg0KVGhhbmtzDQpQZXRlcg0KDQoNCg==
