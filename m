Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66465371CF8;
	Mon, 21 Sep 2026 08:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978165; cv=fail; b=BQSHmVV6l/YqGSAOLEYSAC6rd1MiXhNRZ0KT3GTQDaY/Hospt4kf8d2tnKSLyq/4sbi8NmE/J0yXl8EdsI1XdlG0dphDfctvl7k1nhNI2ajFzxEQjEqXbiNJ52eafHoERgYAhjHptkjUNyC6EFcUDAInOybCg4M+XnVtCK3IhrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978165; c=relaxed/simple;
	bh=VoA+E8tzHQxnWkUh88Hs2r16o6ZnSMrxod7NbIf4y/o=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OMS7s3TjXUmQROgusn2Pk4dp9IO/BJ/TbaU89YlrAw0W2aVZo8I+8J3y4cix2qhFLatwVEza04IuhiVkl5eK3jCkdcx+mzjxAYj1P2wSwglLcpQXQrhNEctEEyxJYZtupIdHiCLYXAbxvIEMxUKRV1u0SVebMU5Z//AZMPG2TXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=tApw43/6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZtAy9/uc; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tApw43/6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZtAy9/uc"
X-UUID: b83f81a4b59311f18dc8c9802ae25ab1-20260921
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=VoA+E8tzHQxnWkUh88Hs2r16o6ZnSMrxod7NbIf4y/o=;
	b=tApw43/6igGJHCWfpGGBVVhzbORWAD5QQpAre1R8Os78hHHZP28D7MbomcdA2/IzSZF9V3CM1xdv63xbEWCs7q88l4fthUYX9f0ZnfDuCSuLEDnx4sdIRhzFDaNGfEF2R/J3HOTTqG4w5sW13G7pC+ITRSj/O5D0jK/3DH3TgCk=;
X-CID-CACHE: Type:Local,Time:202609211530+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:af2511d6-f2d1-46fb-bf69-5406f24ea54e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:a64df33e-2015-4ac0-848c-dd56b04f9b18,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|136|836|865|888|898,TC:-5,Co
	ntent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b83f81a4b59311f18dc8c9802ae25ab1-20260921
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 681827140; Mon, 21 Sep 2026 16:09:08 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 21 Sep 2026 16:09:06 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 21 Sep 2026 16:09:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWTODB9Ee6zZJoBhzMF9MRwkhKjysoNRphVGLrf3JJyKgPVRNWxkSTdEv+ie86ApJ6/UeIfkEp0tOhnHmvqWpNENHm7oXGURnt6Qf9Vv7d7VSOVcgLQirTmsteEt3t8Idl5J/6b50ql2nVRkOhUPRRZsDqLK9s9MNi4B+ANIRH6DwcsHkctGR6FB92sR4Vd7U6g8VV3NpzEUml5Jmwo2aNzXl9nCvM+RwR1747wYqY+7HvXTnz90MVfKHRci3GnDFjH3cItZXBLr80c5VOFTjs9oV4aKTuomC83qq8JprysVkSmJFwDLJ1flCKMW9C9BrPFb/tfdvz9xlo2YJaiaFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoA+E8tzHQxnWkUh88Hs2r16o6ZnSMrxod7NbIf4y/o=;
 b=vtvH7BTGQXjpugGJ0GpX7JQ3w6Kf2SAYeN+5qSC1HxJo4+c38jd1T3+4bn08Men3w4XNvPbXmqg0m6Won6LHiB7bDTr5KjkruhDK1laq2XgL4IU/i1zvT7K+VfokLF9qbyH3DPFB4CBD3jxbgUVhokmBEmRKE5a9Te95nH/n/WFp0VBCcHLkJXA6H+lHjA4YTdlDTI8cq6vUu3+R4EQkeQ55OmaoP9EFlTLNMS3jMVy3F8v0AjpqTWJ1Ayt5xCBuBOuw+vnmaWIKyUc4CIrs1+DEmgsj/EG0K3SaT69FVKQGjIX+0IqFuY13CcRnQjqORTmSnw+vxHHoo+2LeaPK9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoA+E8tzHQxnWkUh88Hs2r16o6ZnSMrxod7NbIf4y/o=;
 b=ZtAy9/ucu4k8WVxMtoYMw9POBGD/oF0F/NJwaYInQKD38wJyU5cYiTRGK2PrKpurz84t8uQgrJfFCxJYKqJah58Q/tI1GQp7xPXhmdZosYSqkXGsFziPMPLp2XihTPS7kRn3wfh42S4mf1KqFEWs9nZzXr1IIOK79fTqEVZlVIU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7720.apcprd03.prod.outlook.com (2603:1096:820:e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 08:09:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 08:09:03 +0000
From: =?iso-2022-jp?B?UGV0ZXIgV2FuZyAoGyRCMiY/Lk0nGyhCKQ==?=
	<peter.wang@mediatek.com>
To: Pengpeng Hou <hppiscas@163.com>
CC: =?iso-2022-jp?B?Q2hhb3RpYW4gSmluZyAoGyRCMGZEK0U3GyhCKQ==?=
	<Chaotian.Jing@mediatek.com>, "chu.stanley@gmail.com"
	<chu.stanley@gmail.com>, "james.bottomley@hansenpartnership.com"
	<james.bottomley@hansenpartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "stanleyjhu@google.com"
	<stanleyjhu@google.com>
Subject: Re: [PATCH v2] scsi: ufs: mediatek: handle mPHY power-on failures
Thread-Topic: [PATCH v2] scsi: ufs: mediatek: handle mPHY power-on failures
Thread-Index: AQHdSaB21m+QmYf7wEeP//PESgUTOg==
Date: Mon, 21 Sep 2026 08:09:03 +0000
Message-ID: 5767949ea8f226ed1333590d9c94620abb3829de.camel@mediatek.com
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7720:EE_
x-ms-office365-filtering-correlation-id: c456d8ff-91a8-4756-2d0c-08df17b79979
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|18002099003|38070700021|56012099006|11063799006|10067099003;
x-microsoft-antispam-message-info: 6IXiWDl+iw8+llSZf7DCANF+n/52R+CZencAXmxylk2ZAErQLUamwe2XpW7kk4Zw5o7FsTUSTTdz3j4yjUn5Tql9X3r4u/RFlbyUjYF5nfgj3w8oLayLuKPj7tSAX/GZS5KPv+FCypYt89lce4nX0NOlEU1f0o0CaOg/dNCtcXfqrhKovP1UCXOS26A45b+AgYj2eEvQhP8rRRfJUVFEYkEo57E+nYW4vpVrRmtb+xk6wRnwz86JrXN9fthEhg1YeGbQb2lX1f2RTEGKLVwygT+jp9fiDQWvO0v0PgM3BXQzbGwJJxtIUU9Y5sq+oT7qqeONiT1vzmpCKTJuAR4krL+s5W+E5xNlRfdOGb4WthCu1nI+MKZ0BRTnA2eMibhZs02YXQjKN2zY6nVH2HMIo3Akaj65cCv75oX3HGzMcH6d3kJfAwr8XZkYzq2rzuTYHyoMioXA/+lYpyS3mUpgC50m0Ljnwiifor9Z26iWwvyD2GIaWXJTgS+fGCHwlmtH75sr3MV0n9zQ7eitb1fKkSZwU6cnu8udslPjahQuFVb04gjgJ9o8+Elj4iTfwMNEUsKWcXzUzG4syxKQ+5eOSG5hMigSunugpY8F1BAGhn9wql01RS+Cn23M2iKeF5BhQ+AGP1l7jGBluBI9z8ZXjhIGyFZ2Q7yx2GTW2Alt+e2ejXLytfaZQDmWQgAcrI3qCQasLvPSB2/rSHgNSevFrc3jsejRg3zSmD3CUPAmWuo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(38070700021)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?Mjg4N2RIdFpVNGYwbGwyL0t6OFN1VFhHSmlwRlhnQmUzVG1xa0F4WE9L?=
 =?iso-2022-jp?B?NTd5Slh1RHA3U1JncVdOYlRuZ2dxTU5UZFFKekZEVnJmSVd3UXp1UGFW?=
 =?iso-2022-jp?B?eGlIWDNyb3lKOFoyVUVoTFE3WWMybm5BQk9MVEJBaXB1N0N2OE1TbXBw?=
 =?iso-2022-jp?B?YWZLSUk0b3Z6ZDZvUFZjVmpRenVVUEkwSjZkMUVTRzJKbGx4c2l0ODhJ?=
 =?iso-2022-jp?B?djVVdGNNVUhWYkdjNVVHMWNUZnZzaE9NQzF4dEl2WmNuRi9LcktYUHFU?=
 =?iso-2022-jp?B?OElFNmhzajdlT01QTGdqS3paZFpwbGpPcDRUL1cwRE9wRVo4bDJ0NERs?=
 =?iso-2022-jp?B?bUZGbUVSNnMyN0t0bHRvTzVMQVRlSWNOQ1BXNHZ3aVlpTktCd3Q1dHF5?=
 =?iso-2022-jp?B?V0hFbVBUeHFGSnJqUFVINlExYmFTQ3ZUQ1Z5NkFBd0x1bmZCbmRqeHJw?=
 =?iso-2022-jp?B?VTJoVVBGajRYV09CcnF5N3RMWFplM0h3ZHVOVE1oNExIMisxT0ltWk5P?=
 =?iso-2022-jp?B?SWUzZHY5RDNjbUVvNm1NKzZ2djFTSTM2cm5XUWJZb09Db3FvdWZSUkJ4?=
 =?iso-2022-jp?B?REl0eElybm1UcXRveENtUU5LeUM4bTREVkJEQ1ltK0Q0NW4vT2FrejV5?=
 =?iso-2022-jp?B?ekRqYUFnYytkOFVSaEl0bGNMb0tFc25GbFJpc1NabXRwMlhpVk1HRkVx?=
 =?iso-2022-jp?B?VHZpRGV1Wm1vNGdZSWNzK0ZFTGdpaUJhYXUvbk0xYlIxbmc3UG9IaTFJ?=
 =?iso-2022-jp?B?bU9vT2NHYm5wYnlVSndKS3MwQzFFZWZQRGxlb0JnbmNNdkVRK0krbk8v?=
 =?iso-2022-jp?B?bUhJbW1EdnJQaTM1K1FwVTgwUy96V0NyeFU5cU52MGt0T3ZMZjc0YVN0?=
 =?iso-2022-jp?B?cWROdlUzS0dBVGhZeUhKbGQ4K2JyVHNLRkRnWDJRZVZLNnc4V08zMWg1?=
 =?iso-2022-jp?B?SzJEUUZhZzE1OWxvQzB0Qk5QMk1IS0VZQ3VJdW5tTGxYS1N4WkYxTm0w?=
 =?iso-2022-jp?B?TnI0d1FNQ2FEWG55bG50ZGdCdjNOcUd0VTh0S2lrbjdSZHZzMTJXUVF3?=
 =?iso-2022-jp?B?a040VUo3dG8xSTlSRWVWVU40U0hadGttZGF0ZGVHOFdhNnNsWXpiVEk4?=
 =?iso-2022-jp?B?cDlqeG03a1RRMGhMK253OXJ1M1lqeVhXd3V2ajF6YnBLV0tCclp6b0hi?=
 =?iso-2022-jp?B?RW9zQU9GQnFXVXZGcWIrTlNTbEdUSzlJTWZiMjVleWxkRWhTeVlzSUJo?=
 =?iso-2022-jp?B?RDZyRWdTUk8zamtYTHkyYWRWM3g5blJROTArTGI3a1JQMGw1R1E3SGtK?=
 =?iso-2022-jp?B?MUlMVDZqUnhmeTlicjBmdnN1V1J3QzVIN3RTaHFvZmNIMnZ4c3B2bkR4?=
 =?iso-2022-jp?B?WWZwRVgxZDVXbzBTTTVmemgweWUwVTNyem5uV1Ntd1c4N01KMW04YzlE?=
 =?iso-2022-jp?B?S0xnM1VmNDEvbnE3SGF6NHV2Z1hlODhtNXJmNFk1RXNXR0U2VkZWR1dh?=
 =?iso-2022-jp?B?OUdJbk9pSmhwTEdqUDJ2NDRobU10S3hHODNBV1lIdW9xSFZ2TUcrdmlx?=
 =?iso-2022-jp?B?ZnB5TlgyZHZvckNwdVBPcDYrOTN0ZS82WkFYNzBYd0xueTEyMk9FSm15?=
 =?iso-2022-jp?B?QStHUENmRnBtcmlhM1g4ZXhRQXNRbEhXbktOVnY2V0dHODdzbEhTWWRZ?=
 =?iso-2022-jp?B?RzE0YnQxc1N4a0d3eVN4a0FuM281TklmUTF1TFBZQVlBZWlra3BYM1U5?=
 =?iso-2022-jp?B?bE1uUk4vWVdSN05scnhMTjFXU0JpQ29wVkVRa2NTQVd3TDUxZE5EbGxk?=
 =?iso-2022-jp?B?RUFENVFqNVNYTFR3Uk5ZWklrL2lWb3p6c0wxUENla3lLVWV0U3ZoZWNz?=
 =?iso-2022-jp?B?ZFpNWjJVTHNqOHRSR1habVRUd3Z3L3NWbGVHTkhUME5tTE1kVWlROStD?=
 =?iso-2022-jp?B?YndiOC9FampETzVMUStQU0lSZUJkVnRyMmJNSU1SRTJEbFMraGxSTGdW?=
 =?iso-2022-jp?B?eHA3MnVCSW1xeHc3UkpBZzBQbmFQSEY2YzBGdGM5Q0lXZXdQRjl2Wnps?=
 =?iso-2022-jp?B?c0ozWlRiNzJpWG01blkyRHllK3UzdHZlcXBGa3FnMUFTVWhONmpqa1Bp?=
 =?iso-2022-jp?B?cWxLU05SV3ptSkNodWd3T1NKKzZKY2E3Yld1VHBwc1Jyc1ZEcGtKVGwy?=
 =?iso-2022-jp?B?cjVldVBJZzdTYWJyUHMzLzltWlB0NEVSYnRhMXFCTTdTTzk0aU9xN0Nk?=
 =?iso-2022-jp?B?alk3aWZ0T3ArNGV4Ykl3ZnlvSVdPcW5yeFZYLzZOS2RBQXpsUGR3N0lL?=
 =?iso-2022-jp?B?Zm1WbWF5S2swSVcxOGw4d1pXUzltWmwwcGVRK1dBdFBCYldwdVg2ZFJO?=
 =?iso-2022-jp?B?SU54K3VZRjRBZDUvclFlZW84eElRYzVncHJaNisreTJzZjljTDdwVkFC?=
 =?iso-2022-jp?B?d003b09ZVkdGa2RSeXdVOTB1MHJpSm5rVmpPZkxrQ0EzZXJUOU1vL3h0?=
 =?iso-2022-jp?B?UlRzY0NXSDJPenMxbUJrQXhCekFOWjRLOXJQUT09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: flaCQDg3QZlquiGZpIlEkuItAQ/341TMzPxEfQMSnOvYT2HS9kFwGWBDAGeKnercvl6FWptrSQDASUn9p6+PW+khumBG9Au4oPoj5JjahaGXCKCP9UMvLrA2Bkl4W1zCDU3vhDjHY/T1/4LUI0QI1FgiycTY/u1/fOEnW1XcS34UdjDUNFfLAuekDkFe0asjvekRHnc+LGpYRZOrNkKn6O5iVnAM90ks/E699cv3wCyS1dnynLCI0y6WxAG9zQZQJjWLDg+ELHyhHxTRQLLf5Q1zdSQ6IWom2Ki9iq0fxdlVBCKRTQ3kdrqwlweHRlj6XWq+ZATxNuBoqZICigJUzg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c456d8ff-91a8-4756-2d0c-08df17b79979
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2026 08:09:03.0985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W8KAmbaYnbFPDYe3Dc6ruN+Psi5kVD/CB+P0i1ElkBypRMJOUawQ7mXrocJPj7yykhvbp2HWxerefnCpqKx9NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7720
X-MTK: N

On Sun, 2026-09-20 at 11:49 +0800, Pengpeng Hou wrote:=0A=
> The MediaTek helper enables VA09 before powering on the mPHY, but=0A=
> ignores the PHY result. A failure can leave VA09 enabled and publish=0A=
> mphy_powered_on as true, so a later power-on attempt is skipped.=0A=
> =0A=
> Check phy_power_on(), attempt to unwind VA09 on failure, and leave=0A=
> the=0A=
> state flag unchanged. Propagate the helper result from host=0A=
> initialization as well as its existing resume caller. Keep the=0A=
> original=0A=
> PHY error if the supply rollback also fails, and report that rollback=0A=
> separately.=0A=
> =0A=
> The issue was found by our static-analysis tool.=0A=
> =0A=
> Fixes: 561e3a8726b2 ("scsi: ufs-mediatek: Fix unbalanced clock=0A=
> on/off")=0A=
> Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator=0A=
> operations")=0A=
> Assisted-by: gpt 5=0A=
> Signed-off-by: Pengpeng Hou <hppiscas@163.com>=0A=
> ---=0A=
=0A=
Reviewed-by: Peter Wang <peter.wang@mediatek.com>=0A=
=0A=
