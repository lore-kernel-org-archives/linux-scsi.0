Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012027.outbound.protection.outlook.com [52.101.126.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F2D3BF692;
	Tue, 18 Aug 2026 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044661; cv=fail; b=qOEP1qWzYUVUw0Orse646j8CeMt9ctSZWH9OhTT5AhNeLwYsgeZH/w3BFoqUP2G0HnJHHSyh4oKIqDXL/s9KPwqJLDnBRehXIUiSXS6VPj+yoig1BdFzllWsB1kBAREOJp90ekBW/YfJ7mFVhCl5UqVpJCPgixtyetM6j5/LbG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044661; c=relaxed/simple;
	bh=ao0fHH8N677E4/foKlQApsks3YQ/bHFJ8RUeZDLLmgQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bwtMFpWXDZK4llen8hVm+BEH7M3WUc1wyVW5fHxR3gA4s6ZuLmaFBCVOVd6Gj0cRJhorO60h3+t0L2i4EeygMdesGD+KklhDoCiGehkbc7Fgmo9F3P1G6qNKS1GmncXUlQGR/wiuz4tcBvnhgFLCx0H47lMn9vjNw5aPt/aARDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=OFc3ZAkp; arc=fail smtp.client-ip=52.101.126.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="OFc3ZAkp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VO0o+cTqTyIE9m23lP20WV75nus0Bc9S2HFtwndqDTcQLUO2Bqimt6+HqLvX0D3IWUL5B8+fWGe0EkoBhANNvCRv5Gs0NLTOiVensIbYzlM1P6jNd8pripWmBu6Zazt2ZxEP3WFcCVLB8VVx/aquk85GVmfYMULJ7B7k/P2an+jlIMZyqjMbTP+NjzxF9fvX3GLxL1TKwYrCXiwhs56jU7ZfFxFNiyTXo8aGPS3ciDglH2TcNkiaODAQwmztdrbZKezXURqbIY3YjZp28u+n+dE1FQzk5tLCCP/3vbXub5bja4bGZy0Yf2hgaY6Df4En5EQz7mHvJNzD/AZaP0cLfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao0fHH8N677E4/foKlQApsks3YQ/bHFJ8RUeZDLLmgQ=;
 b=khtlxnIwWahOYCQruc+dqR6MsTEEmnm797+CudYkbKzZ3pxp+eyVCe/QWn6PpPRf70kAEKLy2iq50retSVTGY3ke3kFHsC+32t24XL9PUi2KEDqZp+7FPKZrQhUyiuTkJvs+weK4b7YyuyKx6Ux/fTyrK3c0btubpYzTWwKWSx1iw+/56+BU+GvCEULMMQ+p1UE5+NA1c2CkCQYEaOQ8Kf3725b79rQvEMRwZobr7nA7WrEXdy2x7DiIYv5iWaz7fYfRVS2zTbdBIlOrHA4bI6w+8WqkwXcO3zLi0a74zGSvF53Ddi8ah1++rNX7Jvu0gCKVBuEAveJt/2sTw4zFLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ao0fHH8N677E4/foKlQApsks3YQ/bHFJ8RUeZDLLmgQ=;
 b=OFc3ZAkpOv+vaMlDTQOui4jLYpRoCyBADYiy6uRF55Afi87cl8REzCS5alii+qqsw+yD/C/nCn5ygnyQA/oVe+rnO2aapxXsmv21XIno6JQGRE7vaiNM43NIsx6tHalTSSt2ADKrNKTs+TrWAtGrg4Bmw09LsHGobZdgjc/nzbFtbjOHP7SzJJuPktuxjOb3C6HaK5zxXqgPp6jXrGpQelYxgPghXK26aunr4mcUXYhM1Pf+R8cqZH25VkSPH9MCvZdvn1gQa8BzQXs/NN1t9vK1YmtJtKwUpcbH4pEb3/8KZi5EP/IMxbTZFayBGfcj/m0h4y1EX24gg3nvkUvfhA==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by OSNPR06MB8859.apcprd06.prod.outlook.com (2603:1096:604:4a0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 09:17:37 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%6]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 09:17:36 +0000
From: =?gb2312?B?uvrBrMfa?= <hulianqin@vivo.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "hare@suse.de" <hare@suse.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject:
 =?gb2312?B?tPC4tDogW1BBVENIIHYyIDIvMl0gIHNjc2k6IHNkOiBtYXJrIGRpc2sgZGVh?=
 =?gb2312?Q?d_on_surprise_host_removal_to_avoid_I/O_hang?=
Thread-Topic: [PATCH v2 2/2]  scsi: sd: mark disk dead on surprise host
 removal to avoid I/O hang
Thread-Index: Ad0qUjjq9SfafSxZRTCZhWr1AqisVAEn0u+A
Date: Tue, 18 Aug 2026 09:17:36 +0000
Message-ID:
 <TYUPR06MB6217E3739EDF2016EAB78E45D2A62@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <PUZPR06MB622453C37D2BABC5E71B195DD2DC2@PUZPR06MB6224.apcprd06.prod.outlook.com>
In-Reply-To:
 <PUZPR06MB622453C37D2BABC5E71B195DD2DC2@PUZPR06MB6224.apcprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|OSNPR06MB8859:EE_
x-ms-office365-filtering-correlation-id: 747e535c-0bc3-46fb-2c37-08defd098b27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|42112799006|23010399003|376014|366016|38070700021|10067099003|11063799006|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 V4lGNFh5vP8FC/LF8c3hH26lGhe7sUOsCCP8s+mU+4eAEHInAYuGj19GaB5MEi8q/0wcwfbss74yp9y8kQzi3vZue3gzCr8pZbvZCe32EWs6dTC2eODBrMm08PY4j15hYnrfOFfVkJPKGtCCP2xlsp5KcmXRDEDHQlzd6KR5MH+WS9+V2bBgXr1S+kPol8X2mUX3t/PfEnAUOvOKW5fSYnsxeoVzKUciivimcveqhzheFvAsVQbS6hIlBddezx0QxTELlFemoRwqxg/dMKwpszajiZKsQorydxwYq29vGSrNumvnSl9e1mTT50hYeIZjB647DYkAgTxuXh+6bIEVnSONTNfC2i8WAxzGxRpP8IkIa8Ga+5m/qH6qX+AYep6soVTd9Xj/7zGR7/JOhXDehpli87YcEygWKYhbRJzU1QiAbfMJbsCnU1EIofOuFroaFThI8rRJ7uK2icQa3gH8yTbpQyM6ablgRRaLAPg5L/yVx2Dane29Yp0Vca2kXo4g6w/onSo3+LX9KhQ6eUmXyqegsXT+TxGKKxAjhRWk8lVA4fSAhy0EN9/z3akfQaAgXGbaiB9r7/Ei4YwRfI4ynlnDE5OW3EtpEfNQ1+zZNG3YvOBOBrSu8Y5q4ZKTxTazCixTv+8WiZx3UVGIy1ioDbvH8/xzn+3ufBFn47B0NNUw/d9l7uRrf4fsjNgFGsysuSOW6PFpQ77BvHs45yiqE102C39XfkZTC2yIgA3mZcU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(42112799006)(23010399003)(376014)(366016)(38070700021)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?eXRGWHRZOVdIL0hiQ1JTSFNQeXRJb2k5V3Y4d2Z5ZnV4N0F3M0NzTWVscHJr?=
 =?gb2312?B?dVZBd1AvU3ozU0F5ZmdFcGJzNlF3OTgwZXhJajZMTitmQlp2WEk0TG9sN1o1?=
 =?gb2312?B?cGVDL3BQUmpQT1hYS3ljVnZvMVI1NTBqbkJWbW5mcnBtUXBpTVlFRzdOdkJ4?=
 =?gb2312?B?L3dRbXc1QkM3K1hPcjlYRlUrLzlzZDd4TXFRa1lEYUs2VzBFVE9UNzhia3I4?=
 =?gb2312?B?VlN0RWZJSmxRMU0zbHREMHFPOWNMWm5qaWpkZGh0T2ljdC9mQVVHMExNelZv?=
 =?gb2312?B?MENmN1lWeGZTK2FkcjUra1pza0FUWTY1VmozM1l3NGFmRVdQQUJzUGYzUGl5?=
 =?gb2312?B?NytqanM2Y1BrTWVVazZsYTJLbjZ3UFFPcHE4WlJ2cjh1ZFM5SjRpamJmUDNV?=
 =?gb2312?B?VndPK0pDYWNTL1ZqdVYzbkdsU01VbU5Ccmk1Z1BLQnBMazJIa0NtbHdDdWZO?=
 =?gb2312?B?WjN3RVc3R1RBRGFnZlkzcndETWoweDVSK2x5MmpZUFJXditsT1lxR3NMMWxG?=
 =?gb2312?B?WURKT2hFTHFIWUVsckZOYkdHSC9yZmdGcFJvK0FiTjBCRDVxT1Q0NlNBdUdy?=
 =?gb2312?B?Rmw4WjlWM0gwT0NvSjZZdXBESGpsUkVTT2tKWFFlQTFYZ05sdUYrRVlUOXhS?=
 =?gb2312?B?SWRwbkF3ejNKcU5JeWM1UHR1QU1IOU04dVZiYy9jTTUxa0EvYzloampFRHlx?=
 =?gb2312?B?K0pTbjYvRWVZd25uZE96am9sTHRJYWsra1ZpSitlNE1PdThydEpxUnRieFV1?=
 =?gb2312?B?OXhoWjRHdWg3em5KNTFIeTh1TW5pdzNhZE1uNmdkdmlRbmRVTlJkQlhLWk5J?=
 =?gb2312?B?TEUxMzBhaUJtYk9HVjZjdmxtL09oWlNvMzBVUUcyQlM1cFFJTXhYM3luVVQr?=
 =?gb2312?B?akZubUxHbnM4VE9LK0N3TXJIWkpTRGJ6TFpsY2J6OU1NYUU0YjI5bVljUmI1?=
 =?gb2312?B?Snd0OGMweWs3UmRGZFJYNEZRckN6V3ZsL1ZWaDdJNHZiVXp0K0lzaXFUKytG?=
 =?gb2312?B?YWFSQVR4M2krN1hYcEJZeGhoMWZlMFhjck44SWNNVU9jN1NWaS9ER1dVZ1B6?=
 =?gb2312?B?OFBoSU40eFQrN2sxT0ladEgza3UxZ3djb2ovaW0vUUUwWFlQNXlRZWpIcEht?=
 =?gb2312?B?ZU9UbVlKYnBrQUtLUktDY0NERElmSnByMDd5ZkNDa1piVStiTUxQaXB2MlJs?=
 =?gb2312?B?ei9RcHpKUVc3QWxJc1ppcTdkQk1aSEVKTGlocFJuN0gwYUtjTGRyQ3h5WExo?=
 =?gb2312?B?SFFOSGI3emZRa0JlWHgzVVJMaGloVnpKWjRvY041UmxtZ2x0bDJtNldTdGxH?=
 =?gb2312?B?OGNBZlJCU1YrM0JFYXFZRjdnQm9KTVQ2ZmloRm1CcXBXZGV5SXJvNjA5c2V0?=
 =?gb2312?B?Uk9BWWdDdG5xSXEzS3NzSWxYTDFUUUZPM0JWdmFYWEZpRVdnbk5sQnVmUUJa?=
 =?gb2312?B?NkZac2grV3JXb2FQWktBYVNCdTlabTdIZWVlcmpCQjBGOUhDOHptV1FFMXFT?=
 =?gb2312?B?TDlGK3N4L0J4ZDFmMGc4NjRIVlg5OWFLVXRWU1RTMTdSUnhxejJQTVdzZlVI?=
 =?gb2312?B?RXREVmlPU0V3TnF6YlZqcTFJSkRxUTJxcDkxR0RFajhhOXlnNGtFdjNCRjVS?=
 =?gb2312?B?OHphd08vUGh0eUtyYnV2V2ZIM0E3amRZUVNoSUVpOVo3UkxXajVKWlFROWNU?=
 =?gb2312?B?U3FUVmw5N1MwV2poNmxxcG93dXNFVEsvMXFVak1RYjZMWVZqZGVKQXcrRXdk?=
 =?gb2312?B?NTVRM2xqbzhtN1RtTXZMOXZWQS9sREdLc1c0bGZvN1hNdGhxa1N2N0FMcGxZ?=
 =?gb2312?B?dWZManJZNm5TQVczam9xdGdmOWhBZ0x2TEZ2Z3JYdmlrdnFIRkN1TWpidUQ1?=
 =?gb2312?B?Ui9ySDIwcjg1Qm5vR3JmaDkzMWhESlVzMWpkUWRvUy9uRFVFK29XUkJUdjRn?=
 =?gb2312?B?eFU0WllIaGo4c01CZ3Q4R2laTFBHRDQ4M014d0pRQWVXb0tEdk1ONmJpendr?=
 =?gb2312?B?Y2xxdTJUT1J2cTQzMG5lY0ZQYmtNRlRaR2NqRVZCQzh1eHNLcFArZHJDQWFN?=
 =?gb2312?B?UURLdzVRRzhFdDVVUVZRRTUwQklZQWZZUkxiazNvc09wOER1cnZ3TktBV3NP?=
 =?gb2312?B?MmJzbU40WVZuUll6alVzTThZUGRleDZIWnRqWXJHZ3BPYzM4R1UrTDdGWXJQ?=
 =?gb2312?B?bmpRUWErYUJ5akdQN1lqUS9QT1pXSVNoM3lQekg2SnA0eEowc1k5Zk1qaHgz?=
 =?gb2312?B?YVlWZzVBR25oR0VOa1crUG1zY08xZGVIUG5mUkhQTDFmNmR2S3NWaTdYYjFH?=
 =?gb2312?Q?dyOSIazOhy/U24wwd5?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYUPR06MB6217.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747e535c-0bc3-46fb-2c37-08defd098b27
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2026 09:17:36.4054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VlUAIckGqPkk2ONM1QTQsIjpo2x9E28FTz5IrdwAX2dZ38DoKMY0fp91SXnJp80+xxfvDh2FT1ggBleImpTnsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR06MB8859

R2VudGxlIHBpbmcuDQoNClRoZSBjb21wYW5pb24gYmxvY2sgcGF0Y2ggWzFdIGhhcyBiZWVuIHJl
dmlld2VkIGJ5IENocmlzdG9waCBIZWxsd2lnDQphbmQgYXBwbGllZCBieSBKZW5zIEF4Ym9lIChj
b21taXQgN2U5YTQ2MDA0YjQ3MWVhZikuDQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9h
bGwvUFVaUFIwNk1CNjIyNDdFODJFNjZBM0VENDZDQzNFNkM3RDJEQzJAUFVaUFIwNk1CNjIyNC5h
cGNwcmQwNi5wcm9kLm91dGxvb2suY29tLw0KDQoNCj4g1vfM4jogW1BBVENIIHYyIDIvMl0gc2Nz
aTogc2Q6IG1hcmsgZGlzayBkZWFkIG9uIHN1cnByaXNlIGhvc3QgcmVtb3ZhbCB0byBhdm9pZCBJ
L08gaGFuZw0KPiANCg0K
