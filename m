Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C3839099A;
	Tue,  3 Mar 2026 10:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772533546; cv=fail; b=hVHtA0typT+xAEggo5Fb2b7X5ftYYEST1QvXzjrT6Q6VNwWNHsKFr9XPdkUk9f6Jz1hC7UAlroneqLT1E73Fy9te5CZ/g3MOnxpkp4hJ6K661++ai0G6CjGCmiDnOBzW4lFvpehtzKUo9EmonjxIsZkJLgQFV/0aAm85Jt1CKoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772533546; c=relaxed/simple;
	bh=HHBHp0zO5CBqH4vmXKeimYPoWnJVp1CFOBfiv2fZ9OA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fSl7HN8nrZ0RU+WZoCJHiOWsoPwoAYrZkFYDdvpVfFL1/2yuYho3FcE1WkKGedYrbMt0/Od54c8XHzKAfHiE4SPwRL/NXCgwQ2fpRMhxg0KIeNtwZWveZGztWZVz3Orr2mRoa7BMiSXA3ox6aMURzqo1q2YXW3BfkC84MQjiQbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jOgOaRr6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nmjY+8HK; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jOgOaRr6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nmjY+8HK"
X-UUID: 532d884816eb11f1b7fc4fdb8733b2bc-20260303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=HHBHp0zO5CBqH4vmXKeimYPoWnJVp1CFOBfiv2fZ9OA=;
	b=jOgOaRr65moxLokIs6EeQrv5V9Oh/tNxix/vhi0BRdIRkG1Fp0v3k4J1q+Qy/Q2rhe7iAV0tXbdD+3IHdvdolrVaKQoGOKtc9m69yoz39axof52mzq3mJGBV3ge28nQnhjPrhOUdCfyKFgeyiB6GesDf+xmTfIgcyMSkBbX4DoI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:07c7981b-3269-4e67-9072-e30addbce097,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:9db2777b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 532d884816eb11f1b7fc4fdb8733b2bc-20260303
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 167645375; Tue, 03 Mar 2026 18:25:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 3 Mar 2026 18:25:38 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 3 Mar 2026 18:25:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rs3c7ApPZW/OorlgcZqD9DswwRiQ+Gg6t0IaBa4OBdFCn4Y+9AvP6YuxY83yfqS91S+e9dYu7dx/sTJeYTXFxyKhPcz696KghzX2amlhPYHUiBn/ry2Q2qOQZ2dioAUU+9DvBj1jxC3JhWS+FCvGJ6coIwBYBQdswDV0d42hsXeu1W7/XtMET6NVdbajZEBZLGg6B7mvr+NjY2b/GoOOP75a+pFxOxZaUuzq1cOQmfskL8rOfForvFzDNoqQ8ravvgz8vwc+Uucxs6ntTBXV0p532ot34qkC/JfGekzr1FiHiirhKPSFOMrnVIlJtOwYSIBV/mOmM0+OooVLNYTIQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HHBHp0zO5CBqH4vmXKeimYPoWnJVp1CFOBfiv2fZ9OA=;
 b=MXs3JxbO038OEb+8QEs7H2kcvkbOsaZVwtNYzqxUSnp+ALXoXTuuFjqr6vMraRNTuM4CuTe6HnScgVcACdJ9U2GRQJoCHzrgn9cDwygs4NtaUxBULaardMVqUKN+DQfOKZ/FkRoS2HwhSG4d6WDCJFVM48yT9xYcY3vixmRAe1e/MvAkODj+HobBvNTHj0bfwlPudwyRD7y7RFRa0rhy1oOLGXbSSv/6KgZ4fIM7qCjDu0EgLEPQiGiL4q0CKAHy7+EsYhGiSBcLFd2Qx9DI6jLBbh+9vfISljgfhl5EhkU7ThZKyW27qxAVtPuqwHL8ZHgREJ+r9+1LRq6v6hYJig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHBHp0zO5CBqH4vmXKeimYPoWnJVp1CFOBfiv2fZ9OA=;
 b=nmjY+8HKys9YUvErsw6nMAqwFHUN9XARITe93nlDfUBmMdIvQEys3csuEqXDk5DAxgliEw8HJ+cb+zqupPIfL+KxYhdn0B7vUxFpdZOyv4iO7qBWu6rLEMyCA7jpW+gOMDog8nhKD+jbT3vFRksZDv8xDjQGZeypcJNk2YOMadw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9770.apcprd03.prod.outlook.com (2603:1096:405:398::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 10:25:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 10:25:35 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "arthur.simchaev@sandisk.com"
	<arthur.simchaev@sandisk.com>
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
Thread-Topic: [PATCH] scsi: ufs: core: Handle MCQ IAG events
Thread-Index: AQHcqm6tlxTa2NfLgkq8161GkZ8vOLWcm0YA
Date: Tue, 3 Mar 2026 10:25:35 +0000
Message-ID: <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
References: <20260302180117.2797184-1-vamshigajjela@google.com>
In-Reply-To: <20260302180117.2797184-1-vamshigajjela@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9770:EE_
x-ms-office365-filtering-correlation-id: 1fb75123-5c08-4b65-c631-08de790f34e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: W4vVvTE6vcyiv7z4ieCiVJso3V85c+B9m654ZgFRedIUr55dnbImSeUba3a/iIB8Xcs5i2Q2i4RDNigWunM5ajai7Or8WulLJ7vN6gIe7W6Nuo0b4SkpnHr9C2ekGgVhAHfLCLY5eYkregrwfyZO6fkk3nD/J5ozg3UaPFN8MSQe2QMNRM74fgFKQPqpWMOEr4j0jmA5XPMVDapmJjpa79bn/WdHZQM9pe0S86YlAn7U9Gs5DCkBQpxN1Va3nWKfp3J5mdsj9WFvWX1jpbKU1eHugU+Z5fa3oGM9K/Xj+5C7VpT3PZl1WBoKatDDaz4VEGeYzI+fChMyGQBNglD3zcgdR2/jIJ3h6N1vev02LA3tKFW4pl3+TvZqsHQ9Uh5I+y3/JBX3lIY5TTddzUtWUMTK53jNr9nfqu3VZ6lgcMGV6mnckdvMQST1EI2TjiKpQpzErvmDu7Hp+p8WX7X8YFBYFoivLdoULNfWamEJMEkBW+DY3MgQARSkGj3xaojnpoY1f5Y9maSrYdLP7u4mBeQPMblMixGYZa7rf+9pv0/L9Zz5LJd+NKFumenTETtEqdwAH/8hwvpaC+rp3XKDHOeC8a26rTRbzJ677ZL8eMnG1KjCxuU0Bur7//rG9AUvI1LXQYwlP9kthp3CD/XTr9B/0d7NznN4UhvAe62VPA7y5RPRUgqUm/UqbkPH6ofRD9TxeHEnoti4peWyHnt0+eKn0HaQJyEpguWwv+ZJVnbUwNAv+Xy16DG1tC6s/ed80cI4xRdUdGYLKKnGsBz+rSZ8a2X2hDx+hfuOuUPfIzM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVBsRjloQUZoeFEzVEJyUXRPUlZ0bUE1enh6QXdNSGRCdGtyVHlKUTBZY2dm?=
 =?utf-8?B?Y2hTWnM1aU5pWGYxcDBSeWU0d0xlUlNnQjJ4QU1aY0FjdVlaN3o5OVRia3JO?=
 =?utf-8?B?Q0hVU0JrNnNVbFEwUTRpbTFqZ1RlZHRtUDRpMUhmeGkzRE9VMjRhM1Qza2FD?=
 =?utf-8?B?ekdESHp3aHRmazlZdVlWOHgwK25ReDI2U1dGd0djd0JCdFhsRzV4QUtZeDlT?=
 =?utf-8?B?RHBFd0U0aEl1YVJGWHdaenQwUUtoa0dqZDNuWm0zNm5Gcko5THk1QXVDMklY?=
 =?utf-8?B?emVuZXpxQTZkaDBDaElHakZNTVdsQlVDS01DQnN2RTVTN2NBS29Gd2VjTUg2?=
 =?utf-8?B?ZUJBdjJROC9mTy8xUzRIWlJCUG5VMzlwdlk1K2pYMnNQdFdPL3lZOTZuNHM5?=
 =?utf-8?B?SGplREJJSnRaclpOTERKUTl5TTBYTU5xK0tpTHRPYWxRMlZTdkVWMDhkUm1V?=
 =?utf-8?B?Q1pPSUtwenVpTm1WRjBLVUFRUXUvdW9BTFVhT3FQUEN4YlZUUUxTTjBselVp?=
 =?utf-8?B?aXFNUGxjWXFZRzdvbG16TUp4MGhBUXFzTTNYdzdobW1iOERScTFUdnluczBw?=
 =?utf-8?B?WEVhNk1hYjR1dVNneDByNWdNQjY4Qm5zTjQyMElWV1RXNFVBWUxOclNBVE1m?=
 =?utf-8?B?a0NHNGVBU09zNThIV1NURHRCZDZaUkMzVnFvNzF0RWsxbVA1Y1RSd0Y5dklT?=
 =?utf-8?B?cVdmV3IzMnJkV3M1WTI1V0owWWlyOFZRdmNKcUtyWWJuU1JieVVxaUt1S0dw?=
 =?utf-8?B?UldtWkpQU0g4Y0lzN3pZK0NWMGg1SHR6dVhacVRwaDQyU1dtYldBMWFVMEtz?=
 =?utf-8?B?YnUwOFNxS1NiT1NPMm1ZeWp3RE1HV3NWYWN0aHlrU3NxVXlCQTl4a0hhcy9y?=
 =?utf-8?B?cm15Mk1PbG5OMWdDWS9BcHlQaFEwSllnbHF3VG54UGJxVGh1K1hhb0MrU3V3?=
 =?utf-8?B?ZTNWTjRTY01rNWJ6eHdvcFRGQlVua0FTMTJTUWdyVHdUNDI0czZhd2dOQlJZ?=
 =?utf-8?B?VFZROE5uTDhpdjE4Wkk5VmJILzNob2ovd2l3emJMQmlRSElXTk5MQzVWZDBR?=
 =?utf-8?B?SldPSUdWcmFYeTNXcFlQeGRSaGhUMkNjckJUQzZIMWZRcXFmaFpnNVdyT0VJ?=
 =?utf-8?B?RllxVmlWajQrOVRIbkdqd0I3dExaRlhTQ05hbWJnbFVNT1VOMlluS2FLZlV1?=
 =?utf-8?B?SUxxSXByQ2tDY2R2aTJVMEE5dWtoRUc3clRzU1VIdEZOVnlNUmJBR0ZQNkkr?=
 =?utf-8?B?L3V6Q2Izb0FyUnkyRnVUdE0rUGJTeldnQVVKZjNQQitrMjIzUjQ5VnJKWVJQ?=
 =?utf-8?B?djFvTGlleGVUUHkrZmplaEhaaHB6bFZST295em1Sb01NZFd1RzlrWVowQXhF?=
 =?utf-8?B?MXliZCtOMDJ5dU56UmlkaUcwaEdLVE5XRU1TdUtEWWZvay81Rkh5OHloNWc5?=
 =?utf-8?B?MGZ4T0gzNnE2WGxGL2lQaUsxWW5ZRzlWYVUxU3J1Z3grRDdGYm9vZVpmbS8x?=
 =?utf-8?B?K2lwVmc5KzhaNjloKzM0YlNDZmhtOTgyRXY0cGtFeUZ6djEwMHZqMEw3M3Z4?=
 =?utf-8?B?WGp3TldjempKWHR2eEo5dHJZNllSUWtyUVhZWHIwS3ZnTU1RRUlpV1krOUlp?=
 =?utf-8?B?QnovVmRScFJLdis0RmxIWG0yNmtsOWRBc2hpaXJFWFRFQWhuOWhNWDk2QXpi?=
 =?utf-8?B?ZHErbGVZV3QxRFdzdUJEMHhKS2gxR2grdjAxZmxMRkdaUTQ4S2Zza293Mng2?=
 =?utf-8?B?Z28xazEyWFlEem9Lb3JMQXdmL3cvZnZyVTN4TkQzR1FFS0NHWG1mc1MwcWFH?=
 =?utf-8?B?OTZ6VklkM0E0Y2JlOEZZYmE1UitXK0w3VndsTDVxcms4QU5OWGx2TTdoaVRK?=
 =?utf-8?B?bkQ4WHNwdVMzcUNKenYwMW15dWx4YmdYZzlHRTEwbjZTME5ycW5WSDBYT3Aw?=
 =?utf-8?B?a0MwcU5BamJsTVo0aEdGcXd6QVJmR2pDc2FDdExlL0NqVkIrUkI3Mm95V3Jh?=
 =?utf-8?B?d2pid0E2R1pJYWVtWjdXVlRmL24vY2J6L2huak8zVjg5blNBMXAvbFZnemNB?=
 =?utf-8?B?U29wUy84bmFiYk9pajIzTlRKR0MyeEFOVmt1WWpVUVB4QUFlbk94TlQvaDFi?=
 =?utf-8?B?WXMvdWxOMXg1ZTV2amFrd0NPQ3dRWUZXbnJLRVpYM0ZXQnlxSHNWMGkvbXNr?=
 =?utf-8?B?NzV6TEZYY21TamRSTTlSWlpFT0F4dGE2YmJ3cktwQnNyeExlWjFzb2t2RnEw?=
 =?utf-8?B?Tmo1cVFRMWRtc3E5bDhTZWdFMEQ0Sk9kQzlxUVZRUXEvV1NFaGxQUWFDZzRt?=
 =?utf-8?B?Z0x3VUloYXpHSGkxcGdGVGZidG44MjR3Y000cXBNNFRYL3B0WjF5SzdmeW1h?=
 =?utf-8?Q?dzo95noe2vS6HkZM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5EFCB68B4DA53498D70BC6A901D367F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QzvV/TspuqkUO+xpmkg9IRukevQl4nTJd2/eMOA66LhAWReiVOYDI9dB9w5zgZGefIhZJ2NwowrQiQn5Da1XzsYvMVidcO/SOWj5GvPmM/1GcSf4qOQhnrqaEM+pr0zpTGqdMfVVB6HlyygFnuljChtr9d+NCYQv+SrwsiWoxd80QOH8J18xVIkJlB1XMv3S4pmjY9NMtJNFidStaNrrF8yF4URHiM/rfiE82DRbbdfd9xnh2AeXN9MWA18hSRV9caoXjhDqxWYtSxqhwaIXoMRLwDbIWKbQJk3PpP9lMwnODd9SywQvMdAy1GTV4DfVOeYgnNCiOWIKbPleOjeGsg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb75123-5c08-4b65-c631-08de790f34e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 10:25:35.1696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gd1aSslb2tXzn5t1LDJx3kDHqdA5WauEzx8z+6gbIivatJBzOu9bamRCvcAs7SHw7Lw5vNX7rYBK+9AFVzsz7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9770
X-MTK: N

T24gTW9uLCAyMDI2LTAzLTAyIGF0IDIzOjMxICswNTMwLCB2YW1zaGkgZ2FqamVsYSB3cm90ZToN
Cj4gQEAgLTcxNDEsNyArNzE0OSwxMCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX3NsX2lu
dHIoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGludHJfc3RhdHVzKQ0KPiDCoAkJcmV0dmFs
IHw9IHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoaGJhKTsNCj4gwqANCj4gwqAJaWYgKGludHJf
c3RhdHVzICYgTUNRX0NRX0VWRU5UX1NUQVRVUykNCj4gLQkJcmV0dmFsIHw9IHVmc2hjZF9oYW5k
bGVfbWNxX2NxX2V2ZW50cyhoYmEpOw0KPiArCQlyZXR2YWwgfD0gdWZzaGNkX2hhbmRsZV9tY3Ff
Y3FfZXZlbnRzKGhiYSwgZmFsc2UpOw0KPiArDQo+ICsJaWYgKGludHJfc3RhdHVzICYgTUNRX0lB
R19FVkVOVF9TVEFUVVMpDQo+ICsJCXJldHZhbCB8PSB1ZnNoY2RfaGFuZGxlX21jcV9jcV9ldmVu
dHMoaGJhLCB0cnVlKTsNCg0KSGkgVmFtc2hpLA0KDQpUaGlzIGlzIHN0cmFuZ2UgdG8gbWUuDQpX
aHkgZG9lcyByZWNlaXZpbmcgYW4gSUFHX0VWRU5UIGNhbGwgdWZzaGNkX2hhbmRsZV9tY3FfY3Ff
ZXZlbnRzPw0KU2hvdWxkbid0IGl0IGJlIHVmc2hjZF9oYW5kbGVfbWNxX2lhZ19ldmVudHMgaW5z
dGVhZD8NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
