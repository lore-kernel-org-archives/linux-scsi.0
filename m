Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16BD2836A3;
	Wed, 23 Jul 2025 09:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263268; cv=fail; b=t5qV8J7B7+zYnqY1sDa8cbJUqi2gpJhYfOBYwhe1VUNeNi07NNZey04TuWsLa+LdSrbe/AUORsccXiImNpEoqULTBoEH1bFfDSvEplI25RT8n3Ihn+YGHmI9cjKZyC25lTrrBz6wW+5BPGc/kzufSX7MwzHQ0RjjrOoeWlOz23I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263268; c=relaxed/simple;
	bh=o5EpWYsoHbSm2bxmU7NrTuDgMS+Mvjjqkwv3RuTZis0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UfJ1PxQUxVez+gq6j3CKkL5IEZ4q8OGwlw0XQfumyAtIXMcVJ3HGL8q4G/IMbUMPKcT5PWEQ6qtEBG0cFAZy/24Ftj9K479/OSoWRKyFd96OKckI5oWnkSFfllQZnSagwdQneiArTy2Uz/XxB476h9Ci2yTzsHlkDJgpSPWbp8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=UIA91fPn; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=lQw5IZgA; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UIA91fPn";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="lQw5IZgA"
X-UUID: 34e4245c67a811f08b7dc59d57013e23-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=o5EpWYsoHbSm2bxmU7NrTuDgMS+Mvjjqkwv3RuTZis0=;
	b=UIA91fPnml+6hHGE+YP6s3h3ubHSTQ/2TRJ1FOK3v0DVV6YkwA4mgqtHizD7i+19E7EDmRKPkid+TiQ3Rwih85uxT5HKctYsZFd//AG3iCcoBSWzkTxtT27Hv3BYqfV/6mPG5aewz6EfA0wIP2CxmeyD1kZ17OGe1PmzqOIOiw8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:b8649e9c-3e5e-4dc4-b6a7-551032e27550,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:87512a50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34e4245c67a811f08b7dc59d57013e23-20250723
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1832469226; Wed, 23 Jul 2025 17:34:18 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 17:34:16 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 17:34:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9K/IfiHFw7KXGQu2ZnSQbHnRaWLFPIQolURU+0QGFHZu/+h2ulQUFhiscXJmVeBUDnhjAkQPkCwyQqQnGjxokklNLzGIW3azED1pr6WGxQXzzYtQ2qDSiuiWG+6OhMLQmlJ5fiOIvhDimqwsrM7TDCCH0tv1L4WuFfLt4OGz1ctbigvYWZmUGvRYfDKlFbM3RSwGXi+2jMlBPAmEpRlHA7X7wotTM1yMX5Izs7d7GftsALb+1LKdvuAxlkGU8poc0iwLlYq5hh4bgdScG6FDvpPsq7VrWWKSHibI/Akc3StXNbj/choK/P02o9KuJKjYnW8koNMPyhnoxobQzf2Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5EpWYsoHbSm2bxmU7NrTuDgMS+Mvjjqkwv3RuTZis0=;
 b=GSMSssqCO5smSH8qpIbKAp73oDBluge+2MEEl+mHS6E1IvgRWRHqsLKXh8oYjK8EnqZI3UJk3O9mULwy0Ous8uZVjOa8owOn9UyDFE2faQQb54HhwRAa46LV0W4lz2opJDZ9cKfXJMQTzIoe5qoQjY8kV/BhUGx7EbCRyY5ainqNEH29w9r/kDOIkwb8qtO1lYO3IR58c5knoYGgb1en36fuzniP1YYk9jU0IgcbFUndjs6QHp/Be4fd4sx3pZPuj/Nq/Sn/2xykPIjrEvsbOMi41F/s3t2r5pyllhuASicwZup8hHJo2X4xLYzFh/tYUyRIz1VUvJMtmu3tUHAxYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5EpWYsoHbSm2bxmU7NrTuDgMS+Mvjjqkwv3RuTZis0=;
 b=lQw5IZgALwxFNH9+JrQnLOI6+RjTe+VnY8JuI7w4Vb/3lB1W2IXO7z1NGoGUHA/VxzEnXLvox7bqlG9LAs1RPC+sSAxpr79zubpZgL3dgcYV654iIkymR7P974tOxp3tVKNtmoIowv2Z3BVrn3FmUWXV9M/BYQo355UGAth7yvc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7709.apcprd03.prod.outlook.com (2603:1096:400:421::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 09:34:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 09:34:15 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?=
	<Macpaul.Lin@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?UmljZVlKIExlZSAo5p2O5L2p55yfKQ==?= <ot_riceyj.lee@mediatek.com>,
	"macpaul@gmail.com" <macpaul@gmail.com>,
	=?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
	Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
	=?utf-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>,
	=?utf-8?B?SHQgTGluICjmnpfngJrlrpcp?= <Ht.Lin@mediatek.com>
Subject: Re: [PATCH v2 4/4] arm64: dts: mediatek: mt8195: add UFSHCI node
Thread-Topic: [PATCH v2 4/4] arm64: dts: mediatek: mt8195: add UFSHCI node
Thread-Index: AQHb+ubXgRU20OqLMkae4UUqDD2kzrQ/dBkA
Date: Wed, 23 Jul 2025 09:34:14 +0000
Message-ID: <fd077934de5ef76c53e5274eb1a1acac123d5392.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-4-macpaul.lin@mediatek.com>
In-Reply-To: <20250722085721.2062657-4-macpaul.lin@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7709:EE_
x-ms-office365-filtering-correlation-id: 71dfc5d9-f1dd-409e-0aa9-08ddc9cc16d8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MEhaVjF0UkgzUFBoaUpaaE5iSzRCZmtFWlM1MjB0NGp0Q2FYcWxWRzl6WVdW?=
 =?utf-8?B?WkVLdllnQWJHK0lyMnUyWTNsNm1DNGVxVU5SOUdMaExmMnViL04wS0xIQ3lr?=
 =?utf-8?B?SkYrRzFnb2NmSFNxV3FCclA2dzUvZ2ZueE9tMnExM25SYVBqRFp0RUNGUFc2?=
 =?utf-8?B?L1I4SnA0QlF4cE5GbHIyb0tOZkxXdVpJMld4TUNmaDI2aDdrUGJVMTFLMW1w?=
 =?utf-8?B?VkdUTWlGTlgwMGNrTGZKZHVCZ01UUnA5UElEbjdpcEZ0bWVwNnNlK29uQzFM?=
 =?utf-8?B?dE9WaFVYUWFaYm1DYWZxRW1kTlNHZFJVT1V0NGs1dityQnliMStLaXE4VHc0?=
 =?utf-8?B?RnBKMEhjOXJqUHJBZmJUZitXYzF0U2tqWmRWVFYxVDJCR3lpa0Yyb1JpekJZ?=
 =?utf-8?B?WXp6azZsSzFrNDUyZGdCeTJUWnJEUzIxOVZmTmtUMjBTZC9NL0FDZlNkR2w1?=
 =?utf-8?B?c3dmS2lKR2tkZ1NuN0d0UVhvb2VPVHlzeWpJc1pKbXBqSjBhWFRqQ1d4Q1ps?=
 =?utf-8?B?SnV0OGMrazBlUlBVYXREN0J2cTZLVkMrR0w2d1l4VVZIY1FnVVg1MHBYZmVC?=
 =?utf-8?B?Y0lBWTdMNGtydjRITmN4MVFRa3ZtVDhEcmsvVk9NaXA4eG5uNW9zWDFIditI?=
 =?utf-8?B?MjVBbkxHUDU5TG9wNW1uRkhENkRuOE5DSnVmTDJxZHpOVDYrSkZiVEF4WDk2?=
 =?utf-8?B?eVB3TEM1bElhZlNpYkhoaFFxYjFyVWxmdC9wTSthNzNHeEVpQ2FZYTZ5azdm?=
 =?utf-8?B?V0Jtd1lIOUxYdlN1TGZ3WXRSbDVPdUtUeGRCYlNUelVtNGJlTTB5Rmwxby9m?=
 =?utf-8?B?emZxZG9hbEhnd3FOVVI4Uit5bC9BT3RQUmh0aDIrVDhvUXBtS1JqazVoZnlX?=
 =?utf-8?B?Uk9DRDM3NHJNWVd6RjRWbFRibElmamErWk9xOVZBeXdZNmI0MHZUOXY1L290?=
 =?utf-8?B?a0crSlR2azlPbkRzSmpzSjQ1bkdDeEExK1FvZm4zdzNNVVlRV1hmcUVKNmo4?=
 =?utf-8?B?bWpONm5GKzdWdThpejc0NnI3UDNKLzVYMS9wZ1U3RzU1V0hKaDVkamx6elMy?=
 =?utf-8?B?QldOaGw0cHhSVkQ5RDd2TnFJbkpubkxmT3hEQ3BLWXM4ODhyWXN2aVJReXdH?=
 =?utf-8?B?T2p0ajlaRmZ6VFo1cjUwVldESFNVQVhSaDhiNktZYlU2Yll4UWtwQ05LRjJn?=
 =?utf-8?B?c1JNMjhmNHdkVzBHeEUwVS9VUjFtVzBxdkgxZEtXZ002R1JsNSsvclRKaEdF?=
 =?utf-8?B?V2xwZHlvUjh3SEl1RFhMZW9uZDJ2emE5UlBoZzRVTmRwRC94endISE02a012?=
 =?utf-8?B?S0tsSXFxRzBuOWpFRWszN3RhZlpmbG9kN1U4NW4xSW0wd3U5cVUzSTVKYVEw?=
 =?utf-8?B?eGJzdEZNa3FyUDJqdDl6a0VCeWpEcmdiZ1REalcrRGZRMmRCSDBtdHp5OURG?=
 =?utf-8?B?YlJYQ2NhdWJQWVJlYjVJVmg1UHM5Vzd0TG5zcjByaUtzb1hXbXh5OWtRb2Vv?=
 =?utf-8?B?MW5BUE8rM3ZwaUxFNU5YVWtlUEI5bUxTWWMrMDBrRzVZWlZKbzhrc3JlQllk?=
 =?utf-8?B?ck9sS3dmbWppRUtOV2NkNWRabXZZOHlnTjNyZDNYNlA5UmZlcWNYRmt3UEJx?=
 =?utf-8?B?UHRZd3o4Y1dHb0pUWnlUTmdoakxSbWtMZTVFQzJFKzZ6VDJYY3BobVBtL3g4?=
 =?utf-8?B?ZHMyMjlwaWFGd1pIL0dOdUJ3MXFDS3BPVE9CTGVESjhBMVRCZ2ZyWmdyREFC?=
 =?utf-8?B?SVB6YmVib21lTFlQOUhpaWtkK3Azb2Zvc0srcmFVanBzd3RPWFc1c0NocTFp?=
 =?utf-8?B?cHBaVlZrYVpEZXF4SzRBaityWk5rdHZpTWhlQUNTb2NibUJrUndVQTVVRlJK?=
 =?utf-8?B?dHhiNU00RHMvNzdkVWFSZWpacmRBdXlPUDdJTWNNVlN0ZGhQaENFa1lkMTJZ?=
 =?utf-8?B?b2NJUTlOTlJuVDZ2MitqckI4WHk4V0tHU1dwWlVQY3NPL2djakdhN2dQUm9v?=
 =?utf-8?Q?9Dz2OAlHvxWKwCNtYbHox/ugvePGu8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUtVWHJNNG44TFd6L3E5YzEwa0ZzYUlKemxpUXBjcDFoS0V4NElzbk1kWTcx?=
 =?utf-8?B?V1Ewb1ZFVDBWdzVwdlJ0eE9BRjlOV3lybXkzYVlMdXk1MW9mVEVpSFNOUW9r?=
 =?utf-8?B?UHdlM1hENWFKWFhNQmszSk5TZ0N4ZVNXa1RuVExoVldEczduSUl5VHo0VTF6?=
 =?utf-8?B?RVRqQ2p2VXA4OWhvUWVWb2phVkNSSENHSzJmZ3FtTWhnbUs3SW9LU3g5YWNI?=
 =?utf-8?B?Uk9pUGJsRS9OeWVlNVBnK3VPVHFZd1dLSDlJZFlxSGgrSHhqakE0RFV3eXY5?=
 =?utf-8?B?Q0NhdWJiY3o5U3RqWDJ4czN3Q0RCQ2o0V3ZNclRvUXF4UE93U3pzY1RiRnlt?=
 =?utf-8?B?QUJ2VGY2WHA5WExpY1RUbXFFN2gzbThyc1VCTnBNVjF5K3pacFdjSDUwc3RC?=
 =?utf-8?B?UE1nNmxjd3NpMUxIQlR5TjRVbWZ0SHQrWjRrN24zY1Z1YmVnZm9PRVZhRkt5?=
 =?utf-8?B?KzdVd1U3U05UUTkrSmtaNWJDYXZheEhEK2FNb1c3Wko2eHpJWHNMN3NwUlRs?=
 =?utf-8?B?NlNaeTUvMlF3Nk1WZy9qdXpjOW0yV0o5aGVMcFBqbHRVSFZ1TFpZVit1Z1g2?=
 =?utf-8?B?akpjVjRabVBWNTc3a1hocCsvRS93K3AwQ1dRWU5Nejh5b0FuVWQwc2hjWFlx?=
 =?utf-8?B?d1RtdmJxZ21SMG90aWFsZWFpZ2tBZXlLSHp5YUU2Q2NIRHJWQnVhVjRSc0VO?=
 =?utf-8?B?c3NBalJFQzhRTFQ1WCtMYnZpSnlUaE9UZEtham9yZzBEUE5pM3BCWnBVSjV1?=
 =?utf-8?B?enBWMktqYVdIdCtTUHdjb0R1TVZDYm94REdBMGdneitCTTBCSEx2bXFpUGRC?=
 =?utf-8?B?RUtCWjBZbTZUNG1hRzcvV1hIMkcvSkM2WWppdlpTUHQ3RW1jSFl2UHkyVE5y?=
 =?utf-8?B?TExjdWxHQmtuZmE0a2RHTmwzc0QyUDlzZDlKYW13d0tFNnhyU1pDRjVoWHdY?=
 =?utf-8?B?V2FjeDdiVTZCWTd2VmxCY1d1VFVJMFBrbDd6c2UyRmZvUXlXMXlINVk2bWhP?=
 =?utf-8?B?dm5WbGhzWjlNaUZaa3E3OU5jS1lkTWpkUDc0RTJFZnNaa00wMXFiNUdJZk5q?=
 =?utf-8?B?NEVGdEhPVUQ5UGRrUTJMYmI0aEl0STl6OGVnd2JSOFowRzRKWElPbGMzYVRE?=
 =?utf-8?B?QnBqcGMvY1M5WWtabXl5TzVzM2tDN0d5SkZjRnN1MURYa2tiS3Y2OVoyWCtr?=
 =?utf-8?B?WVZQNEhlckhsbEVlQzhCdUxRUzBQSlhtNXczSWlLdlJpMU4vdTAwOFNRNVAz?=
 =?utf-8?B?dE5za0FLaWFkTmxUWW4yQkIxWVFYNzB1SytocVNvN3Rvbk9NRFNySitSd3NB?=
 =?utf-8?B?TllxYWdwUG01RU9lYk9QS2Z4ZHlmb0lhYk8xZ0V2NWhkUDFyR3lTQ0hNRmZB?=
 =?utf-8?B?Q3U0c2lJYkdNU3JtY2srdVRHd1c5OStNWldRZEkyWk42NjN0MnFiZENJMmNW?=
 =?utf-8?B?ZTBydEtKbU5wRE1YbGNDQ1RwaHpVZ1VrdURwcFQyWk9McDBubFZ2L0hEY0Yz?=
 =?utf-8?B?Si9hWWN1QXpOVlFnbkRTMW5JOVQ5NkFraWNjeGpDZGVlMlgyODQ3RkowNHA4?=
 =?utf-8?B?QW14WTdJekZHNTBpd2ZUNDFTWUhyWHpJeU53REFtbEhES3ZaeVR3VUFlT09I?=
 =?utf-8?B?ckZTWXdhRzhaQ3N2Y0tkQnJsOUQyUkVRbVdNV1pWbzhPVGluajk5dkNPZy9n?=
 =?utf-8?B?dWxNd1plQm5BbWJ1cVRweW94YTRhbzNVTTkyTC8rYmIzNFNGaC93KzN3dDZD?=
 =?utf-8?B?UFkvRmtOVElQT3B6aVprRk9MZzFpZHdUYlR3c1pHRGluM2NqZHp4eHVwTlpD?=
 =?utf-8?B?ekFyMzBkSm5VT0dPOVZzbnZMMFBPSEVSRkQyUWZhRys0MHU0N2hQeUtvQUF3?=
 =?utf-8?B?dnZzbnA2US9sOHBrbk9jUFFsS211L2JneEhJQTlaUXV4azFHT21FKzFCUG1M?=
 =?utf-8?B?NlQvYSsvQVRzNENWd013MzRYMUJycnQzeldvM3h4V1FISzdjN0Q0d2d6MFFE?=
 =?utf-8?B?UlplVHZybzFqSDkrRFZwYkZVMlZXQ2ZoeWNmcG9Mb1BCMFlkaE1BQ01FeUhp?=
 =?utf-8?B?dE5IL1Z6ZUV2VnJLKzVLMzJUcHdsSldHNjBMZVhzYzdCMURrMTBxN0Flc3Bj?=
 =?utf-8?B?ZUwzZEhXVEFVNVBFMm8rS2MydVR0cWplTjNYaE5wbENRU3ZzRWNaV0txODNy?=
 =?utf-8?B?OFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89C8C0969E45E54A9EA100FAB6FB21AE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71dfc5d9-f1dd-409e-0aa9-08ddc9cc16d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 09:34:14.9862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mt8aMWfQAWnc7JiqTuorn0l/3NUCvNmHM4f096kN/vmnhgRpvURFR+HF5pt95MymeM9OhCC4LKjWz2F4v+v4QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7709

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDE2OjU3ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
RnJvbTogUmljZSBMZWUgPG90X3JpY2V5ai5sZWVAbWVkaWF0ZWsuY29tPg0KPiANCj4gQWRkIGEg
VUZTIGhvc3QgY29udHJvbGxlciBpbnRlcmZhY2UgKFVGU0hDSSkgbm9kZSB0byBtdDgxOTUuZHRz
aS4NCj4gSW50cm9kdWNlIHRoZSAnbWVkaWF0ZWssdWZzLWRpc2FibGUtbWNxJyBwcm9wZXJ0eSB0
byBhbGxvdyBkaXNhYmxpbmcNCj4gTXVsdGlwbGUgQ2lyY3VsYXIgUXVldWUgKE1DUSkgc3VwcG9y
dC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJpY2UgTGVlIDxvdF9yaWNleWoubGVlQG1lZGlhdGVr
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRXJpYyBMaW4gPGh0LmxpbkBtZWRpYXRlay5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IE1hY3BhdWwgTGluIDxtYWNwYXVsLmxpbkBtZWRpYXRlay5jb20+DQo+
IC0tLQ0KPiDCoGFyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ4MTk1LmR0c2kgfCAyNQ0K
PiArKysrKysrKysrKysrKysrKysrKysrKysNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMjUgaW5zZXJ0
aW9ucygrKQ0KPiANCj4gQ2hhbmdlcyBmb3IgdjI6DQo+IMKgLSBObyBjaGFuZ2UuDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDgxOTUuZHRzaQ0KPiBi
L2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ4MTk1LmR0c2kNCj4gaW5kZXggZGQwNjVi
MWJmOTRhLi44ODc3OTUzY2UyOTIgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMv
bWVkaWF0ZWsvbXQ4MTk1LmR0c2kNCj4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRl
ay9tdDgxOTUuZHRzaQ0KPiBAQCAtMTQzMCw2ICsxNDMwLDMxIEBAIG1tYzI6IG1tY0AxMTI1MDAw
MCB7DQo+IMKgCQkJc3RhdHVzID0gImRpc2FibGVkIjsNCj4gwqAJCX07DQo+IMKgDQo+ICsJCXVm
c2hjaTogdWZzaGNpQDExMjcwMDAwIHsNCj4gKwkJCWNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4
MTk1LXVmc2hjaSI7DQo+ICsJCQlyZWcgPSA8MCAweDExMjcwMDAwIDAgMHgyMzAwPjsNCj4gKwkJ
CWludGVycnVwdHMgPSA8R0lDX1NQSSAxMzcNCj4gSVJRX1RZUEVfTEVWRUxfSElHSCAwPjsNCj4g
KwkJCXBoeXMgPSA8JnVmc3BoeT47DQo+ICsJCQljbG9ja3MgPSA8JmluZnJhY2ZnX2FvDQo+IENM
S19JTkZSQV9BT19BRVNfVUZTRkRFPiwNCj4gKwkJCQkgPCZpbmZyYWNmZ19hbyBDTEtfSU5GUkFf
QU9fQUVTPiwNCj4gKwkJCQkgPCZpbmZyYWNmZ19hbw0KPiBDTEtfSU5GUkFfQU9fVUZTX1RJQ0s+
LA0KPiArCQkJCSA8JmluZnJhY2ZnX2FvDQo+IENMS19JTkZSQV9BT19VTklQUk9fU1lTPiwNCj4g
KwkJCQkgPCZpbmZyYWNmZ19hbw0KPiBDTEtfSU5GUkFfQU9fVU5JUFJPX1RJQ0s+LA0KPiArCQkJ
CSA8JmluZnJhY2ZnX2FvDQo+IENMS19JTkZSQV9BT19VRlNfTVBfU0FQX0I+LA0KPiArCQkJCSA8
JmluZnJhY2ZnX2FvDQo+IENMS19JTkZSQV9BT19VRlNfVFhfU1lNQk9MPiwNCj4gKwkJCQkgPCZp
bmZyYWNmZ19hbw0KPiBDTEtfSU5GUkFfQU9fUEVSSV9VRlNfTUVNX1NVQj47DQo+ICsJCQljbG9j
ay1uYW1lcyA9ICJ1ZnMiLCAidWZzX2FlcyIsICJ1ZnNfdGljayIsDQo+ICsJCQkJCSJ1bmlwcm9f
c3lzY2xrIiwNCj4gInVuaXByb190aWNrIiwNCj4gKwkJCQkJInVuaXByb19tcF9iY2xrIiwNCj4g
InVmc190eF9zeW1ib2wiLA0KPiArCQkJCQkidWZzX21lbV9zdWIiOw0KPiArCQkJZnJlcS10YWJs
ZS1oeiA9IDwwIDA+LCA8MCAwPiwgPDAgMD4sDQo+ICsJCQkJCTwwIDA+LCA8MCAwPiwgPDAgMD4s
DQo+ICsJCQkJCTwwIDA+LCA8MCAwPjsNCj4gKw0KPiArCQkJbWVkaWF0ZWssdWZzLWRpc2FibGUt
bWNxOw0KPiArCQkJc3RhdHVzID0gImRpc2FibGVkIjsNCj4gKwkJfTsNCj4gKw0KPiDCoAkJbHZ0
c19tY3U6IHRoZXJtYWwtc2Vuc29yQDExMjc4MDAwIHsNCj4gwqAJCQljb21wYXRpYmxlID0gIm1l
ZGlhdGVrLG10ODE5NS1sdnRzLW1jdSI7DQo+IMKgCQkJcmVnID0gPDAgMHgxMTI3ODAwMCAwIDB4
MTAwMD47DQoNCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tPg0KDQoNCg==
