Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5CD2E7F07;
	Wed, 19 Nov 2025 09:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763543901; cv=fail; b=JBiykduH2wHH0NZYV0I8DcBXQU1oBGHFwZHWNmwCTzk69d6Ns9Q0G1CmWHZVIb7BtoC+Jy2DqMRYBNs9CfTJlWegk+mS8AxSEsNMM0UEOFwInbcb4BY7ZsM8wL1hO9FzEOzkdbUGEpYnfqQPFvIILzI0TZiRvF28wXnqFwT/6/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763543901; c=relaxed/simple;
	bh=2w0vE7t93CBLWx4xrnpP67DaNhzkwkoqZRBOWLf4qzg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rtCkdG7wmbZUd08+x3xu8uWbFnBogsRW0BIzviEpCi6wuHy67b3XoA+4RkjDNIEr1sdvdt9CAwuIG7XVxC4bv3YrFsq037PM5uU8Lp9vomeOBuRy8DIlibwegsfMTOJOHimTBObd/S+tcstzlqScBzmnORIcqPHNjC7lfTn3cjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qs3wHUCw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=PrcUW1V6; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qs3wHUCw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="PrcUW1V6"
X-UUID: ac68c93cc52811f0b33aeb1e7f16c2b6-20251119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2w0vE7t93CBLWx4xrnpP67DaNhzkwkoqZRBOWLf4qzg=;
	b=qs3wHUCwxwFS6/k6IYXsXE03LvDfZqnP23GN6aqdbP5nURXJ+UEChsAjJkiaLTqxeZ2qtjPIl/B4aKMCbX0D7tlY8jVhjhPB0MH6WFOhMTjuw9KEE3Htsj6Qd58kfCGJCtSyL7lSQOgXMU7QeVxto1UopQu4eklfli8vdBYXKm0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:33f2f414-bde8-44a2-b962-e98b2b775ff0,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:19271158-17e4-43d2-bf73-55337eed999a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ac68c93cc52811f0b33aeb1e7f16c2b6-20251119
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 974217344; Wed, 19 Nov 2025 17:18:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 19 Nov 2025 17:18:11 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 19 Nov 2025 17:18:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gh2OY+Efr38LC484K1FVGLhzhAFRrKM43/xB4cpqxLItbX5nzXdQryhH7l2lJ8gCB3R3unG5b/kWYKdHSRAyLuCpzNKG4yBeP5PbaWSXi9hVLUUXKBDSrjwq4ROr9GB7Q2nNId2sJIGUiB2QuNJiH8wTRgiCcT2Adn05SXF8y/TCgXoYt/LGjvNHt146m/w5zRqTsQeZ7YBFDRueWE3ZtdZzVXoyTPzIRlwuFFaT8/5DiW8FdoZHz7Rr+OZpC8OZWvpyiie5Zpba1A/Q/76ejuCs9rk9lS7ESALyAIMjnYj1WfeJl9IPR+iB3MYm2JVmL4k3CRcS2WyX/tGiRdbxqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2w0vE7t93CBLWx4xrnpP67DaNhzkwkoqZRBOWLf4qzg=;
 b=JRFknk83Y1Nsg9rQH/mv+/BB5Ro3ds+//CobLcjyMdb6hwJIbdHEYQsn+4K6RJxGA9z0lqQCTufknBpglEUKoikdIK3HSdLl5lqNede3fQ4R7sxBYJ6xXEagdsr9omcxFzuM49I9kSYVmsMM/jjvxLGAwbYI3d2PcageZlI0Iiwcv514/G4/qNzaS5ve/QkfTypJrCJHNacV6wdaP2ky7s3ao+D92Nxxq4Qi0aYXxqFiL4qeiuxaps1C4V5CAimJPIHDooDvioHqv97lMfLpoihb5NzcUB81VrVqTMYEcDnMPOcEu3hmh6tUThoW4dfz/Y37cgRJYJmUdlKRrCZ3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2w0vE7t93CBLWx4xrnpP67DaNhzkwkoqZRBOWLf4qzg=;
 b=PrcUW1V6oZvTgzs3L4PpdhOQAzWnNaISOM5Qmx6czS6aBtjK/lh3ZDvcOWrRSjnmSvIWQG9DVjAwPLBQXLbgfZPW2G9X2LzlKU87RUcm7nj23mdhyIm4tcuTt2QQoRK/0WoXLlArjGTA0zhSqOm7G8O4wc4gFtm4/RcSiGfpB5E=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB6986.apcprd03.prod.outlook.com (2603:1096:301:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 09:18:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.021; Wed, 19 Nov 2025
 09:18:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "powenkao@google.com" <powenkao@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Topic: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Index: AQHcU55F6G16JbOQOEePCVKNWnq4HrTuslIAgAARGoCAAZ+hAIAHru6AgAGxngA=
Date: Wed, 19 Nov 2025 09:18:09 +0000
Message-ID: <301cc0724a9e22bf195cb0bafb0c5d298e93e99d.camel@mediatek.com>
References: <20251112063214.1195761-1-powenkao@google.com>
	 <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
	 <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
	 <c4bd6532b003089fedf518db878a3843c516217c.camel@mediatek.com>
	 <CA+=0d2aYn_q=i6Yy=zSu6eE=Fj0oTk4t00e1uezBxqNc5E7pdg@mail.gmail.com>
In-Reply-To: <CA+=0d2aYn_q=i6Yy=zSu6eE=Fj0oTk4t00e1uezBxqNc5E7pdg@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB6986:EE_
x-ms-office365-filtering-correlation-id: 5fdb76f3-9fe3-477e-c1e8-08de274c8e6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bzlVMS9wUUJQOGgrcUgwV2ZWRTYxRUIvc0s5Z1QyWWM2SlJqK291dXdOelYw?=
 =?utf-8?B?ZmhVajI3ZEN0OEgzbEZKTjRKSkN5WWdvZVVraVU0cWliRkhwOFBNVHVLaDZz?=
 =?utf-8?B?d1JncDRxcWlOb1BxSDlDNGlHZ29kM1h6aDNpZndQVmVETysxY3ZqVE9nZG5V?=
 =?utf-8?B?bjB0eWtSOXpSUEp2djJ0T3FSTXZVYk45dzhjZkk2TGxzYmVrbFJnamRWeTJE?=
 =?utf-8?B?TjE0blh1aXlCb3d0WlJzWGx5R2QyeXkzeEZpMDMyYytLUUZkUTlBODBBYmVS?=
 =?utf-8?B?SHNBNnoxS1BCRm1TbDZBeXhhdHFxd05ZUTRvT2o1ZmhJSnAzYXh3eUZTREN3?=
 =?utf-8?B?c2hIUHdudWpUSGg4UmpPZFVLUnBzajlLV1NvZUhoVTd3bkFLdVFYV1M2QVBX?=
 =?utf-8?B?ZVNQWDZNNnJwc3Y1eXZmZEloZEU5OXpXcUcvTFppcENqcG9ZeERDWnM0Vjcv?=
 =?utf-8?B?MG43Z1VJQ2dCMGYrcDQrSU9xaTVJNmJHTk8rSmVsbDBQS2FxOVpORFZGSUho?=
 =?utf-8?B?ak5qV2pveENsbWtjT1Q2RmF3WHBwYzZEaFF3ZDVVZlRJUDZKa09sMVNBRGl1?=
 =?utf-8?B?Ukk2ZmRqNU5SV1N0V0I2elpOaUEvVXUwdUpJQ0NhbS9HL01nUUFxSjYvakow?=
 =?utf-8?B?RDQrNDFwalFuandoNUdJcnlCS3NwNFl4aVNrK0g4MkxHckl6aitwc0FQOVU4?=
 =?utf-8?B?ZXdtQTdjZ1JTRUhiNlMxTHpmbjU4eDV1Z1RDalJWTTN4SUd5Zmg3V3lUNlBk?=
 =?utf-8?B?YVIza1lXSmZEVCsxb2hJMGplS0R0SE1RUkJYcTN3Y0duYkd6bVM4d3F2dk82?=
 =?utf-8?B?cW5rRzR5WHJ4NlEwM3pUUG1TTXlpQmh6MDBKeU1GSkZtdlI1VmpGRkp3K093?=
 =?utf-8?B?V3dkTVBKZ2RCT1FJQVhpZ25QaXZaSEFmRDhUVHVmWkVSTzNFalRPV3hQeGpi?=
 =?utf-8?B?NklCTFZOSGY1bW4xOHd4c1oyeEJLUTdITzBnUDlCam1USHBIeGd6STB1YXBY?=
 =?utf-8?B?R1F5Q2s5Q2VrZ0RKODYxQXZ1MWNCRFdlbXJlMVUrRE1qelR5UzFLUjFFSkhi?=
 =?utf-8?B?RDRmUzJvMTR6UHhxODBGdGFqYUdDT09pT3VmT1djSkxTZ0gzWUw5dk5uOUI3?=
 =?utf-8?B?cG5LNlIxY1NKR2JJZXVoMll5WXJHdEVPTENDOGVqV3hQazJXZm9HM0tVaStx?=
 =?utf-8?B?eFIzT0I3Y3N1Z2RkSFZqTFRqclN0R1pCNnV5a1F1Q200UGJTTVBVa1QxMkQ1?=
 =?utf-8?B?eXRIOEhZNnlHanlJQWQ3WnlCbi9pWElsN1pzWUlsaXZObVJPUWI1Y2RnVUNk?=
 =?utf-8?B?UkxsYmM4cWRvdXo0b2JDcFo0UzAraE15NERQbm9jM0NEQ3paZGpzSDdqMmxt?=
 =?utf-8?B?QmM2K0IyN0hYTnBZL0NRMmVOMjhWeWk2OE52cHRCdFMxcUhvZXBJOERTWVRt?=
 =?utf-8?B?c0ZXNFRFTkJXV2dNY0lHVmdUK0NFYlB0aXlybVk3RTQwSGhaQ3lRaVk0UGly?=
 =?utf-8?B?bUFoWk8vTmh6bVkva1llY0w3TWR0dUQ3TlI2dmVmOGdzQ2NJTHp5ZFZzZE1Z?=
 =?utf-8?B?bmtOK0JWMnp0SXZyUnZsSmc2YUJEM2pSdno3bVRRTW1VWXhJMm0raUFGTWt0?=
 =?utf-8?B?bGdrNkx0TUZHWlFEelRVN0JoSTdWd0FpNm5uWWl4bXZ3b0NKQXpjQUVHMHlr?=
 =?utf-8?B?M2FlSlo4YjdORk51R25LbjdaSXRBNTVaTmJLN2JDUnlIdUdmTjJlMXZXWlp6?=
 =?utf-8?B?em5VU2gvRGNDSTFmVEkvdFVIWThSdUlRQzNKS01tYTU3WHVYc1c1N1ZQRytP?=
 =?utf-8?B?UjJnazAwUStZaG53ZkRMNEZYNmFWdE9uMC9lQVpaS0IvWUpwOC81NGZBYS8v?=
 =?utf-8?B?UzZVdWVMam40VkNtM3p5OU1QR1BSVlYvOXBqK2lCS2puM25zYk9YT0dIRVNM?=
 =?utf-8?B?cmYrSmU4Slo0R0x0eDk5WkZ0Mjd2dUpjZnVzM1ZWZkE1UWt1b0YxYjlkWFlD?=
 =?utf-8?B?SXRWd3BQc3hQcmJRRDR0b2FKSlBPK29NWGd0emtFcVYzYnVQUWFlTTNHWHZR?=
 =?utf-8?Q?+zD2Xt?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a01qNUt4U3RxMkV3dWE4TDJFanhQZ0o1ajAzOGNja0pXaUZPNGF4QkNMRUlE?=
 =?utf-8?B?TFNTL0paQytQYUFSZG1YNjcyWEhNays3Vm1QZzdjL1RNVE1qK3hyaVZOejdJ?=
 =?utf-8?B?TUQyZXRLa3FLYU5KWDl0THc3NXhlU24zRVphcjNnTzVaOEt0eEFmbHJXZGRx?=
 =?utf-8?B?SFI2cFhNd0FQOEtBMHdIa3g4bjJZd29remVCUlZ1c0VseE5DZHdKMjhCMDFI?=
 =?utf-8?B?VjdKbTN6SXJCaE5weVM3M1dOYngyank1K21nSngvZzErUUFiMm94TGRZMWJa?=
 =?utf-8?B?ejJ4ZTVETW5qaGgvVG5kcmlzcjFqME81c1p3VkhtSDQ4elVITmMxdlNUMENq?=
 =?utf-8?B?bGRFZ0p4bmM0S2V6QTV6WDBtSjRFdW5FaEJOVW5rNU9IaEpuSTZrQmsyejV2?=
 =?utf-8?B?RHlPcjNCMncranhRRHRlMUtYSHdRUDVzSTVrZjhnWEdLTnV1Mm9tK0kvWnJB?=
 =?utf-8?B?Y1g0WERPZW0raGE2UW9oRUFCVXlnNE9iNDNKMHdLckgvUVQxblloZU91M3JR?=
 =?utf-8?B?Mkp3cDEzRk9qckowTVBHL0VqTFNhYlMyVzd0SmRXaFpPNDEvMlNXV05sblpK?=
 =?utf-8?B?WXdwRTVRRng2SmtMTUZ5QXQzVy9xUVJveTY1SkJUeG1FUjlZdTVVQ3VWQUo3?=
 =?utf-8?B?OFRIQksySXhzdlNxTHZJYXRlRXZSVWg4emJhUXBKajVkMWloeWxEaEhSVnZs?=
 =?utf-8?B?Nzh1TENndUtXR2ZxRXBjYUY4ZzBCczByajRsNENTRWV0MlRYdExVcFBnek5Q?=
 =?utf-8?B?M1dtTjBidmc2ZDEwbnE0eGR6LzhOSWNKUVVncDRRZlgrUEVHRG44ZGdIQUln?=
 =?utf-8?B?NEtLbnlGYUFiY242Z2JDalRjZHp2bHJueHlCcDQ5Rlk3YVJaWXhxWlp5eGl3?=
 =?utf-8?B?MDBsV3NSZGU1N0hQcFN0aENvSGI2Q3hYM3o1UjRFK242SW9MZFJZZXhOYWlF?=
 =?utf-8?B?ZjhDTnEzRG1JRTdINjFnVEJzOGNmV2FSb3A2T0VRTHdTak1WWVRQVUVvbklq?=
 =?utf-8?B?S1VYYjBQS1dUeXJuRU82bVdjbjlLYUEreDIzWVd2MWNkZGpuRE5HYWVCUDVn?=
 =?utf-8?B?VEtVRyt4Z24wV3ZuZm9zSFZ0czNwbXJXQmkyOGpOUTNGY1RtRFZyYmJiVnVj?=
 =?utf-8?B?RmhMSERGT3hzVFp1TlNpVGkvdDFDQnJqbWw1SUJLRlRZdHJ5VUlsZTVHeTBi?=
 =?utf-8?B?Nm1KQkZ3ZENKQjdLL2YwMTB2WU51ajFzOUY4SllGVW53bTFZSkd0bUc4VkFL?=
 =?utf-8?B?T1YyWGV3MmZjK0hrTFJ0REFPd0NrbnlwdEgyUlg3R0hWcU10MHJsVjZCWm10?=
 =?utf-8?B?Vk9rSDc2dmF0YTYvdXZiY1ZkT1JIaFRnOTlCdWYyd1VuaUZJU0tFTnRXQ0NY?=
 =?utf-8?B?ZGhydUNLcklQZlRVZGNQN0lVUkpaZ20vTEtBYm4vM2tmUlZCcHczcGdRdktR?=
 =?utf-8?B?dG5Beit5OUVUVE1YV2RpWjlQVnZ6Vk01ZGo1ODhrT1h3c0U5RmI4Mm10Yisz?=
 =?utf-8?B?MTNRKzNLU1ZWNXJXMWwzVGs5dE5Lck9KUXF5dlc3ZVFUWndCcHpaRFFWLzI1?=
 =?utf-8?B?YjU2UG5WWFdjSHY2Mm9GVTQ1RVVEYlFqNjhkSXRkL3dBWTlkdkxobUVpMXda?=
 =?utf-8?B?OFZhK1FKa014emlPbTZHSmxIOThEdWVPdDdHc1FzaDBSMEpNZ296OEcxam94?=
 =?utf-8?B?RWZjVkhxQ1hBSldjbUJUTGRXaHhOTW5UZThhUk1zLzN2S3RJejNLRU9lU3dB?=
 =?utf-8?B?OFlvU1VmTmtVMVUyU3g0anRXUlZGNVRtZ1VVazBlaXdWeDcva0lUdmN0VUVK?=
 =?utf-8?B?OE8xbW9xSU5FMmw3RUowSUR1S3BiR0ZweU9idXR1ZktXWXlLbTE1dkIvNkZa?=
 =?utf-8?B?ZEcyd09qY1gxMHdDT1cyZ0pNMWVZL1BrQTlMNnE4czFpbEN4ZzB0enhUaGcv?=
 =?utf-8?B?V0I1WDdKN1Fha2tzUUM2RWtESFA0MHptL3hSVHVEVTF6Y25LQlVDNGxGZWJW?=
 =?utf-8?B?cTVqOUd0Ly9ZRWtIMU85VG1lZGtIV09yRlE5S3UrUFBjZDVaQndlRnp1RW1O?=
 =?utf-8?B?cnRVbEEySVk3Ykw3NUY5c0UwL0R1RFlpQVZaRW9FQW1pR3plY1FveTBqM3Bw?=
 =?utf-8?B?YnRMeHVaeHpqdnZYYmNHQzFDYXZVVnlvN0k1N01jYXFKK1A2Si9hT2dXK3Y0?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F6004EB42E58545B82A47DD792A20BB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fdb76f3-9fe3-477e-c1e8-08de274c8e6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 09:18:09.3448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 39su+KT0tooUNBlc+lQ0gBI6V1UlZz/GVbXESz+UQ6uKN/Q2lU36mCzmENdncZGVLRCQwp3RU3y3ToEsLy+SLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6986

T24gVHVlLCAyMDI1LTExLTE4IGF0IDE1OjI2ICswODAwLCBCcmlhbiBLYW8gd3JvdGUNCj4gDQo+
IEhpIFBldGVyLA0KPiANCj4gU29ycnkgdGhhdCBJIGRpZG4ndCBtZW50aW9uIHRoYXQgdGhpcyBp
cyBpbiB0aGUgcmVzdW1lIHBhdGguDQo+IFRoZSByZXN1bWUgZmxvdyBpbiBiZWxsb3cgd2lsbCBy
ZS1lbmFibGUgSVJRIGFuZCBnbyB0aHJvdWdoIGZ1bGwNCj4gcmUtaW5pdGlhbGl6YXRpb24gd2hp
Y2ggcG90ZW50aWFsbHkgdHJpZ2dlciBpc3N1ZSBJIGRlc2NyaWJlZA0KPiBwcmV2aW91c2x5DQo+
IGBgYA0KPiB1ZnNoY2RfcmVzdW1lKCkNCj4gwqDCoMKgIHVmc2hjZF9lbmFibGVfaXJxKGhiYSk7
DQo+IHVmc2hjZF93bF9yZXN1bWUoKQ0KPiDCoMKgwqAgdWZzaGNkX3Jlc2V0X2FuZF9yZXN0b3Jl
KCnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
PD09IGRlcGVuZHMNCj4gb24gUE0gbGV2ZWwNCj4gwqDCoMKgwqDCoMKgwqAgdWZzaGNkX2hiYV9l
bmFibGUoKQ0KPiDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfcHJvYmVfaGJhKCkNCj4gwqDCoMKgIHVm
c2hjZF9zZXRfZGV2X3B3cl9tb2RlKGhiYSwgVUZTX0FDVElWRV9QV1JfTU9ERSk7wqDCoMKgIDw9
PSBFSCBpcw0KPiBzY2hlZHVsZWQgYmVmb3JlIHRoaXMgcG9pbnQNCj4gwqDCoMKgIC4uLi4NCj4g
YGBgDQoNCkhpIEJyaWFuLA0KDQpZb3UgbWVhbiB0aGF0IHRoZSBzdXNwZW5kIGxldmVsIHNldHMg
dGhlIGxpbmsgdG8gb2ZmLCBhbmQgdGhlbg0KdWZzaGNkX3Jlc2V0X2FuZF9yZXN0b3JlIGVuY291
bnRlcnMgYW4gZXJyb3IgZHVyaW5nIHRoZSByZXN1bWUgDQpmbG93LCByaWdodD8gVGhpcyBkb2Vz
IHNlZW0gdG8gYmUgYSBwb3RlbnRpYWwgaXNzdWUuDQoNClRoYW5rcw0KUGV0ZXINCg0K
