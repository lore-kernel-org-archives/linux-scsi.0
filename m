Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434D53C6A41;
	Tue, 17 Mar 2026 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773752730; cv=fail; b=e8uMPL++2U7fPspIJV7yA8KWtkfK2O8XfDrCvyYMuibUFz474YopG5ZqziaY5Kgxnt+xr+HfpSaojr9JhfBXtKq64OhB+sDmUZSb6UjjvjvgZBH7wDv7lhUCBNGJGLkIEUcE3jFKfdrkUuYdDVJpLdruKF/xfFsYJUNLHd2V1bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773752730; c=relaxed/simple;
	bh=CBnP7PvhAMJ5xcQ7oqew7SLROJ8zZ521aSFoVms03l0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G2JolO8enmm0VIhhZzWduRRnSNEYRxod0qRK3Q61nPbeF2tYpy8yp1Ndaf1AyaD1/2st5sTBA/hNmipLyQxpN2DUcmpxX6GUu2MgCSe+FZSx3xuxbB77QD6TVI6y9OfBZ2aEg1iAmLTlP6UBsxujniJQfV/TSxBbTXV909C6NF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gtEY2Mbk; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Lzngw7fw; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gtEY2Mbk";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Lzngw7fw"
X-UUID: f45fed48220111f1a02d4725871ece0b-20260317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=CBnP7PvhAMJ5xcQ7oqew7SLROJ8zZ521aSFoVms03l0=;
	b=gtEY2Mbk8UNsB8BhfdiuCnndek4MJESTp4FKjHApLH/rHQ7+Z8ZHo43puPeKHuqs9ilhh/BgdHmLUgt2k8ClyZYYeJ40bWHxOUxM0yHlEAy6QRwS6VBkHL6TMBAvaBDn4TJeMEALOK54Vt+SyVkRsgIE4F15eolGZPbgFehDzIE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2ca6abb8-cf96-4237-9baa-93b939e292b7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:ced1d2d4-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f45fed48220111f1a02d4725871ece0b-20260317
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1364438758; Tue, 17 Mar 2026 21:05:21 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 17 Mar 2026 21:05:20 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 17 Mar 2026 21:05:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y4SPLIEWrVvep9zTL5WkFMMDiVX6ixeMTUuS/YqF9HYXwxC3afhNSlUxxbwPNa0Hdiokiq2j4sYUeiikrChuCKBFacSaMutrA2UPQHMhV5GEdynHHtkGUx5kgP4SkZUeacUakHZdv7dlhj7i7TLiJM9WANxeE1IrEUb4b9Ahm4nKL6ikKMQi3WXEPvR6uqjHFsAoozSqC1ZBuclqDM1aZfkFs0+8POOalmGzv/7KAoP4rIy3IE0Xtw/eiTCIGW3j9vZ4byuGNTgTB7GG5/Are/PLA8LW+BVtn3eQlT8/Ztg4N5UkB6tzqVCOvM1PJTmPI95hgNkb1E/XohkMtl07Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBnP7PvhAMJ5xcQ7oqew7SLROJ8zZ521aSFoVms03l0=;
 b=uTzPcZTaE9GB1CBXQRBxyf9V0oBqSPemv0aQnMrM6n8nyCZSvFaBEQ3lpKjhQLlUIixl0DTHrBadKCDIlBaV2VggUARxPPWNXWtZnzwYmF8tDSLcqWWBKF/NObEOKa6QXBGeOPxW/3c9fRcM/UoEbfpEXuWxYQBFUct7AYJORYHRfMf+j4H1RvrewSQfWBjpeQIggROXH+/mDt54DqWFQ9g5dLpZDh73IjEHOIe/IoAKbWUwMkFAdZiPZQV9BaCqRCI1SYKeIQKcZVwYWI09rTNPaHYwsmZY3u/RR1oUV8ts6iOovdXucd0xzcqooqSdn7mKv1cchrN+HRo7CoS6ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBnP7PvhAMJ5xcQ7oqew7SLROJ8zZ521aSFoVms03l0=;
 b=Lzngw7fwPWJzEB82OB45jQ0w+l7maPXMXPa0M3XwijPeT/jqA0+sDQWU6WJkSlS5fi+/RPczZAJo1iF0+0MulTunxo0wd1krlY+bCadYA+YzCMBNEr/lSUROSbxL2qt2PNmxsGbWt6Co2n1LMWvUjGFKGw4tv0Q0/5lAl0186Mg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8413.apcprd03.prod.outlook.com (2603:1096:820:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 13:05:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9700.025; Tue, 17 Mar 2026
 13:05:15 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX
 Equalization via debugfs
Thread-Topic: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX
 Equalization via debugfs
Thread-Index: AQHcrw5/t/XNR1jcTkOyw+9WW6PDK7WtE9EAgADNVYCAA5FZgIABTMcA
Date: Tue, 17 Mar 2026 13:05:15 +0000
Message-ID: <af0553d67deb4ece5e16041747f4999d2c95852e.camel@mediatek.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
	 <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
	 <bf64badf-161b-421a-a9e6-76e6679d5c9d@acm.org>
	 <d537b40f-70d4-42f3-bed6-616da2489950@oss.qualcomm.com>
	 <c9df8dcb-4711-4678-8759-c0c72b5d5f8b@acm.org>
In-Reply-To: <c9df8dcb-4711-4678-8759-c0c72b5d5f8b@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8413:EE_
x-ms-office365-filtering-correlation-id: d90ede4e-851e-4078-cd55-08de8425d527
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: ZepGLtl2ZskEt0FWeaNx+xQGJ9okLx/rAZLSxfvDOIs5EDErbsyW3ctEO7sbHWQ/pJ2bamiCBwX0XFrwhxioo55HlRhv8Rx2O6bzkbvWuqjCxSJ+eIqpnUlaUeJ26vAtxrPidhHcw2nJRAsSJC1/UvnLmOhQm4voLiy0UdaOduM619yLORQA/x7rBXn3xt2PwXVbmP8SblhCg2o4r+veHpM4zirDP2gWNDPKHP4B779WsLdl5h4K0cO3mGbrV/my6kB877Vtc+5dyfQg5+EMvmCvCVYD9EZ0EfKSppWyzAHmVeVoYK2N4t2s5qfJ7I/4siWvVK+Y7E/7tNZSq6ZNyvJm/03P8j4IaWl0NIaFWzGu4StDE0O0NFxZlStAVINA/nWNh9yTfdkkj6A4CHE0/b3AVY32KxYWoIovvrND+Sa6jnuJb10OIt9FwF1ptbrfeNoAnYaaTK+OCDkhpPSrQvvWs0jK6C5irF1rWJPr+TGCAhIosBmCmY9Nb49NhDSL0j4Q+U4Orl8ljkfUEUFWrFmZbRqU/NkYAa2FN9MWw/83QIhtZbKPfouuS8O/I7G1HLJ03Ch/sNqo1ZhHdnSpAoOjBNtX0VZ2r3/r5mnqFnIS1JeDnD1P2xS+nH+VAkd6GJZA7AVVwml2bGKowppSIB9Fug9yoCH8Fyqs25r9PDyqeRZtGCDKVYffZJKsf+L4kpC4FaJ3zwwOjzeZs76I78wDPK+TyzfOi+tEgfHvIvpROmnThKNlDmXijJ83N/6AMPubEa0E6PNonyAXsmsceOL8ZoiP+ZEqePIBfCadvNE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFBqZ21ENld5WkRqa2YrVjc2YXVTV21HcEh3K1FEeEtiOXhCcmtSTEpuenZa?=
 =?utf-8?B?cytkL0JtQXN1QjB3WVQ3NkZsQjJNNWh0azNnWUNWZVUwYTVwbVdZVjBodFUv?=
 =?utf-8?B?a0tRZk00MkJjRFR0MytHR1ZFK1F2WGN6WnRZSEN0d3BRUmlKZS95UE42ZnZ2?=
 =?utf-8?B?eGJPTmVEaXFxMHBMeWI2NlVLZW1mWnNaQ3RwK3J2VWFyTnFCYjhnN09FRGJX?=
 =?utf-8?B?ZkJ2ZERVM3B1UDZTdzFoTkxuNnJtbmVlWllDMzdsejYrTmp1WDZMcWEvL0Zl?=
 =?utf-8?B?R0FjRU9xejBkbXAwRDhyUjRmeWRpZnRiZmxTWm1Ba1N2Z2Y4S3RvRU9LU0Z1?=
 =?utf-8?B?dzN1SVlBVlB4SzdnS2wxZE1pTlpQcXlsT1VOd01xb2NrSUpidFNyVVRCTFhH?=
 =?utf-8?B?STRJWWlvT3NxOXRUVW15NDNSaHI0S3l2SisyazZFd3lBbHNKVFo0SUxNVDJM?=
 =?utf-8?B?aTZCbFUrQjY5KzgwQlljNERmRmN2aFgzSG5zUFVETldBcDNYVUVpUXQyMUVv?=
 =?utf-8?B?RncrSGhjdjVFWTVwOENJUlpXcWhYSnd1UlR4K3E2OXoxak1QaDRZa3pZaVFQ?=
 =?utf-8?B?dlY2ejEwZGJ3eVR5ZHdoRDNkdDFrSklCVlJqRmxodGxsMWVUb0ZnRzNyczk3?=
 =?utf-8?B?TUVCTHYxNStvcTB3dUhlbE5jTmtYZjVxS2tlRWtyczBURnpIc2FmNWR4V3VI?=
 =?utf-8?B?SU1iU0pCQThUeGtRN0NYTE16MEZVOVRBMVhkVVptbU1jL0hWWThaY1NyazBV?=
 =?utf-8?B?emdmeUpOajZxYklsUmpQWGRvamE3QnAyRTdmUWFraHlSNXhqd0VQbVAyWGlF?=
 =?utf-8?B?RG9BVFVxbHpIYVE4QXM2c2c5VXlJQ2hUNElwN21tWWNmOGpwczI2UGswWWlC?=
 =?utf-8?B?NVlnbVhXYk9YaFJJSi8zbXNqT3E4YmxpeENLNnFHZmJXZFZtMFZFRmpYb1c4?=
 =?utf-8?B?Ync1M1U1cUpQMklmNC9NNXZMempuM1JieVVmNFpyL0UxWURKQXBkNTc5OU81?=
 =?utf-8?B?ODQ3V0djZVRMK05DUjFwTDByWHdibDlwMWxSemFpNGV4d0ZYaHlNbG5lWmlW?=
 =?utf-8?B?enNFV09WN0lkZnJKa01hRVlFZU4vc0kvTkpMUmdJcnAwUDE0a1ROWjVkWWk3?=
 =?utf-8?B?VG1Fc29NNFBkSERQd3VHQXE3NFl5L2pEQVpxdUU4eGJRVnl4b3JsSHNHSDVp?=
 =?utf-8?B?OGRORnprK2RFVzhQeDd3UVlqYTRVUFFzdTluU01GUFZ3amZTVU5GcW1xSXYz?=
 =?utf-8?B?TVI3Vm9GVFh3K3d5Mm9TU1ZQamhxMnVObldDd05uZHpwbys1WGdKS0tUMjNJ?=
 =?utf-8?B?c3JHdW5LZmxDUGhlcmYyN3o4bEJ4TWFSZHhRaXcyR1Foem4xd3hrL2laUWI5?=
 =?utf-8?B?bFJNbnVvU1E1aDRJYlpsTnZMNHllekdrdUZIR1Q5Ty9YRVRTV245b2hLZHZU?=
 =?utf-8?B?alBkMUtKRDVUL3dZVXdjSDFaQ0VTN0VHSnBsV20wUXhvdzNCcW91WjFKc0Zu?=
 =?utf-8?B?bGZjZ3VyL1ZYanpvSk8xWHVBc21lYnBxc3MzbFh5RG8rRGNFNWhjKzNIZlRU?=
 =?utf-8?B?alROWG1tY0cwTDE4V2hvWXk2S0NUK0V5aTZtNC9YMTRyY2ljd1BGa1JWYlBL?=
 =?utf-8?B?N0hwNzJ4TXkxK0JndGFmVkJOenU1M2daU0w1QVBtc3E1bGt5VWVwOXEyNGVz?=
 =?utf-8?B?cXFOQTkwUlVCMGtjUHByZHU1T0prZXlUVUMvN1Zjc2FySXp4alRQK2tJOUUr?=
 =?utf-8?B?aml5VzN0N0VVUThwandpUm5DK0lYbVBzLzBYSkxxemtRWFBzZzNYbnB0c29W?=
 =?utf-8?B?UDBjbE9JUVFRSlRNYWRmTVhJaDdaV0haaU5neGU0UGpEWVJvN3poWTRNV01C?=
 =?utf-8?B?eVNwdkZ1K0pWbWhRRTg1MXY2dk00RkpER3U0aHd3ZVNtL0NBSWdVQkF1ci93?=
 =?utf-8?B?VEZMam9FNDhxdDByT0U2YTN1ZCt0dGVtMDFNZnppekVqZFBkK3ZXb0xTbVR1?=
 =?utf-8?B?NHlSL0RoOFBlL0ZQU25FSnRYdllpRWh0eGtRTmsvMFliV1liSFl3Q3ZBNE54?=
 =?utf-8?B?enc5Nkp6eUQ2L3JKYUN3cVFvUDA4alVHVnNtTlU1cG4zSlk4cUtkems1R0NQ?=
 =?utf-8?B?ZmFFM1ljUzF0ajhmaDJuemhraU9RRGJwanRhaWRldHNWWGN1b3Jyd2g2VWF1?=
 =?utf-8?B?YWlodmJsOGQ2bXF6RHJ5SHBTYy8xU0FXZHpjQk8xYjR5d2pQMXpXdEgyQ3BX?=
 =?utf-8?B?bm5zWE83bjg5OEkxMy9XbS9rMHJ1a0Y1ZmRKdFhaV2FDSXVXVm4vdFVCUkcw?=
 =?utf-8?B?UXkwUTlKK0pIajUwSWVFMFhTUzFhTTA5V0RXYkU0WE5TcnVqd1g5ZzQwcVdN?=
 =?utf-8?Q?CjKJoj/DBIoDr5SY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC577AAAA1DA904D8E27A4FB2F44A4AC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: v3NenGgqWXx9/9aoxq50qiZEoeg2xh0Y79e/R+GRiMeCY53SIVPg5DxSs0Eth5tm4qBtXxIb2V0sT55ByLjICzHnoZDe4GAS6oJuCdy4MNeta4H18msYpSUHOu7s02LxeobxcskjUq792xcSdOYgumhHmgs+8SUNibUNGTg4ZdWt1AceqGgfgTTmPOD1HAjJQid7rs2y0k5xyBBNAHb3VEpDl1n7f4TMJmkhE+ZutR/ZQGMphUFu1DkP05T+9O2w5l7mCB1eLFw/bZEfUK582klmHLXzVf+z2/RyzkYW9DdUttQfuiiCp/TlkWpqor4RPo53l61+NmxROXjNH5EBbA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90ede4e-851e-4078-cd55-08de8425d527
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 13:05:15.7600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xgqNrHJf/9B3Ka0VMBuBCEK6Pg28YW8yF064uL72/9rjcenfJuopJsZheLKzuHtUeLzvDH5oBC9Kn61Y96Uu7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8413
X-MTK: N

T24gTW9uLCAyMDI2LTAzLTE2IGF0IDEwOjE0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDMvMTQvMjYgMzo0NSBBTSwgQ2FuIEd1byB3cm90ZToNCj4gPiBJIGNob3NlICdyZWZy
ZXNoJyBiZWNhdXNlIHRoZSBjb2RlIGNvbmR1Y3RzIG1vcmUgdGhhbiBqdXN0DQo+ID4gcmV0cmFp
bmluZyBvZg0KPiA+IFRYIEVRLA0KPiA+IHRoZSBjb2RlIGFsc28gY2FycmllcyBvdXQgYSBQb3dl
ciBNb2RlIGNoYW5nZSBhZnRlciB0aGF0LCBhbmQgb25seQ0KPiA+IGJ5DQo+ID4gZG9pbmcgYQ0K
PiA+IFBvd2VyIE1vZGUgY2hhbmdlLCB0aGUgbmV3IChvcHRpbWFsKSBUWCBFUSBzZXR0aW5ncyBh
cmUgcmVhbGx5IHVzZWQNCj4gPiBieQ0KPiA+IGJvdGggSG9zdA0KPiA+IGFuZCBEZXZpY2UuDQo+
IA0KPiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4gTm90IHN1cmUgd2hhdCBvdGhlcnMgdGhpbmsg
YnV0IEkgc3RpbGwgdGhpbmsNCj4gdGhhdCAicmV0cmFpbiIgbWFrZXMgaXQgbW9yZSBjbGVhciB3
aGF0IGhhcHBlbnMgdGhhbiAicmVmcmVzaCIuDQo+IA0KPiBCYXJ0Lg0KDQpIaSBDYW4gYW5kIEJh
cnQsDQoNCkkgYWdyZWUgd2l0aCBCYXJ04oCZcyBvcGluaW9uLg0KDQpUaGFua3MNClBldGVyDQoN
Cg0K
