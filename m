Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFC73D34AB;
	Mon, 20 Jul 2026 09:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538919; cv=fail; b=YNADeKl+S4bU1w0d6RL1cB1xZ8quiY1JauWr41eobzA4SBx83B7nr3TfDJ2ljKVXNbn83T3VRR6Ag5Hx9PSRkP4VU6Ap5w/Rw7myLR7FjE7toBtyyOxBfkyA8Xv4ldpMcbmu5I+qrT6uDPKBF2l4BXNu5VnLGP7rogYFSE8BLZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538919; c=relaxed/simple;
	bh=+EpkDyMKzZRKfm5NiZ5c3KCRjQHa5+lB5saU7VAl66w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ScRYPfFt8kHwI1SV6+hgixR7ij4maWJYuM/sEXcdbJUY08dIawfu5q3Ydi1NhrHBjx0Gub9dWwB89Gc6SfZ5lN/9b26YmJVCFoKfU+fmLMrsfbjlEq+AENUx4yZqwX+b5eEerw5GAZRQUDbgVuzja/RbUNd8o1NDYjxZb4ZO1M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZiptzIQ+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=v/IQGRKa; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZiptzIQ+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="v/IQGRKa"
X-UUID: 80a18494841b11f18dc8c9802ae25ab1-20260720
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+EpkDyMKzZRKfm5NiZ5c3KCRjQHa5+lB5saU7VAl66w=;
	b=ZiptzIQ+iw+gWDkrI3Ux/noNQ61AUU7ervNMNaeJENRz00XHeNGG8krYLXLfcH6OnkjwO6Ob9NGTER7VOi75BlaxZwIit48m74c9OQuIKS/DcP646j8n0tdwiKDnwTt+GGfJgV40rvH2OuCm8vjHoU7FqbjVTUkcuwQPl5V4hZs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:11c81105-211b-4f0e-93be-f52c93ab66b2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:6ef3ce90-7807-4a68-9768-5c8a2ca70860,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:
	nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 80a18494841b11f18dc8c9802ae25ab1-20260720
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 928257800; Mon, 20 Jul 2026 17:15:08 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Jul 2026 17:15:06 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Jul 2026 17:15:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wm5w3bgtKxJmw4S3vjAQss0yRLlqKh3rq79xF9hkblfTa2x9kXuI5zRY1i87FF2iD8u72m73OoBzT0/ScA0uQEnAPwWMSfdGVTnWc31PYuTI16fdOnYCzots8nyrJzo084TUOTgUkYMvPVGIfPYTPCR8X3wuviPqcEXCHJzrtLv+JQwbhGLOrY7xKl9M3uERkxJ+eCNGNlDj8ixUU4LR1y70UfHaBrbwH2FoUQsyqKeixCJy3ae1h9Vns0hOXxUR5H0AZhjTVNhiLzq/TaswepV51SbFYG99GV+Q+VvO0OTbDVCX1D3Qk7pglnz0tQaPj5NpxMveaYVrXF8i4UYkzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EpkDyMKzZRKfm5NiZ5c3KCRjQHa5+lB5saU7VAl66w=;
 b=S46osIZB5HG1fbnbJ4sH5rHF4m1c7/XmjagsQbkUwq5MLabMj2lc6kIUUdpfReHwrm4p++q0rMT7K8cDwlboJRFTFqphaFGegXLNOwfU8qFJ232JGZqUih1KsF9sj6SF6N23s60bpoN08Wc2ZKWYaup4HP2z66u3KVerk1QygfXEVacwr0ljaWaLhXgGgnPiFy4vhLhZPDeOOTHFQlSzHEBXkQwghs+cYYGtl8orwiDopgKSGYfv9mpYriSsT6byCIRnwCbMTZ75h6SG9f6AymbF2UGIb1NW6BFyw++NK7in1cCiDBRuqgcZTtl7/er91CUoOFFxQ9BCeSR0iKZ3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EpkDyMKzZRKfm5NiZ5c3KCRjQHa5+lB5saU7VAl66w=;
 b=v/IQGRKaJiQTJ7ADOWGel0x4VIhFPOHjXLBxGHQe/Ta7jtm85LI5onL768b+ApcozVIsDpWiP+Hz3O2t8HCR5QNQ23c7+9qUQqmrDOEfn4xf6peYOoFD+p7JheeMzWrW2qvDt2OsRqgwINrGyp+lPS8JfhSYJ6mhHHnYLBWR+F4=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SE3PR03MB10511.apcprd03.prod.outlook.com (2603:1096:101:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Mon, 20 Jul
 2026 09:15:04 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%6]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:15:04 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"liqiang01@kylinos.cn" <liqiang01@kylinos.cn>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 4/6] scsi: ufs: rpmb: Validate request frame length
 before parsing
Thread-Topic: [PATCH v2 4/6] scsi: ufs: rpmb: Validate request frame length
 before parsing
Thread-Index: AQHdFgKYgowVlJ5wUUGBYgiJNXSYQrZ2JHmA
Date: Mon, 20 Jul 2026 09:15:03 +0000
Message-ID: <7346c980968766d653e526794399675443ffc984.camel@mediatek.com>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-5-liqiang01@kylinos.cn>
In-Reply-To: <20260717153914.26321-5-liqiang01@kylinos.cn>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SE3PR03MB10511:EE_
x-ms-office365-filtering-correlation-id: 4f6aa5a4-af21-4ffb-513b-08dee63f625c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: i3PWRVrdXJdmRRqbI6ixcclnyAcRNL8nRHTIQxV3AU7uXWTtxuxl+HMiZfk2ZkXBk0rOdP68gjJr7aAYe4n+Vk3rY2cE7nL4/7I1yDfuIKz7D8EyozOaCkqGoY/IkPzkDvzvm0Zx3Q3vLWhqtqRvCPbbm1iuTKubhaVkgDIb5p3gKwKlqQ/Tjkx4COhNeWKYdFBwGs7e/SaOFEPubqda9tjYTcPzu0PultPyPel3DVANeEvhQ3btwSSkvHfZqHyK+eKTvRglrUtQ2iwnjixwMPsklOrnCMhihg56pCVNQvsLkayYuvaPkkew00sDPoEfkeToD4l7/Gv5+6fhgIMe7dUHq7O9r5v5UoJxkjY/LRSvCzk77HJkach38BYxnpLrzgjWV1FCbQcMzY2tjKvLPkJp4Kl5waG/cBv1LxATj+SvvLg5BlYRKBHllHxH6tCde6TM6n7VF2Mbau5wTDgDMJ7mLMNQVe4QXqClpT3SqRypyzesOSlXFk4IIoRtIa4aZEfN7hgwRN06SsrRmBJfF/8lnoByhJqWD1zRqoHaPow3q0K89kgR4pIDxxRLkTL7kJYNPm/qQJvhkAG2nesyZfpBgpb+1HQTCdpHLl/YJTWAGGevDlRhEYAR5lLhqzh4oyrbMdIJD8fCIWip79HHoZQGa6QwMYzk1sExVyB86g9xT8oCo3+B9AJUnSRcFKmoP4uxK5FOxwvrSmrQZoiezw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVhQZDNIdTFKazdGdkJGYnhaT2pGb2xwdGd2UkNmekRKaGlKek9lbWk3TzBN?=
 =?utf-8?B?bXFnYVF5K1ZUZS9YbEdObEdHMTZySGlha3AwK0hPZzNtekRtbnVCdW9tNGhY?=
 =?utf-8?B?SDIvZWdWYkpsU3dlZHZqNkZmWFBLYW9MQ1U0R0dtRzJkVExOR1Q4SGJWS1ZP?=
 =?utf-8?B?c3Rxa1JRS3o1MjA5UHhqaFQ5N2NEc1Q0NmJabVZzSThZZmwvaFRNakV0cE9G?=
 =?utf-8?B?TmdLMEVMbU90dFdNT29qSWVXMXZuNXh0YmV1b0xTYTFET2pRU2ptK1JrQjEx?=
 =?utf-8?B?QTJqUTc1OW1MNHQ5NHVaQUN6MG9pTEp3WTJYYVpnaUFwQy83V3VRbmFjWGNU?=
 =?utf-8?B?TkhWUXFzNWFmb3dnOXBGLzQyZGhuSlZDWUFpVWJ3RjQ1ejY3bzRRbUl3SENO?=
 =?utf-8?B?MG5tSlFQSWh3YXB0NUNhNWFyK0s2MW85Z3gwelRPRHpadlp3U3FsUm5rK2pi?=
 =?utf-8?B?WnhtTEFGVGIvcEtlNjFtWlZsck1OMDd0alB1VDlWNFRXQndacm11aHBqUkVp?=
 =?utf-8?B?RnhUWSs4MnBLT3VjN2tRUnpMbUs3eWZyclR4dXR1RlF4MWdwMkUzOEsrQ1Q1?=
 =?utf-8?B?c3V6Qkd0RFY4ZEJob1J1c0gzMVNVVlV6dHplbDBDSlNCUG9ZMURvNERlVU9R?=
 =?utf-8?B?L2lYWjJhK25zbmZ3ajIxSHFCSXZKUmF0NjJmdUJyaTZJNEpIbjlQSnl5VFo0?=
 =?utf-8?B?WW5oUURnMGg3TGxScEJhSmljREphMGFjUmlUV094TUo5czVSc1MvK28wc3Zt?=
 =?utf-8?B?SWRGOTlmZnhKUlVFVitYTi8xdWRDelRJMDNnRVdMMEJDK2tEUDVZTHY1VUk0?=
 =?utf-8?B?amtYRktPc2laL3Nwd29GM2xpM0N3VFhmYkRQMTF4Mjc2T3FJMVhpTEs2Rmh0?=
 =?utf-8?B?aUJ3bjQ3SWgvUGlwT2NNNFNwUUlKelBVOGQ4UnpNYnJGNDR0Q1ErVVVzMFpn?=
 =?utf-8?B?OVVla3NScHh1TW8wZ3dGbWNkcWM4V3g4MlhzTTIvd1N5dDgrT0t3bTRmZEc1?=
 =?utf-8?B?dHpXdWRVa3ovaFVsdWRkT25tbFR5VVpIaW5LYmNNRTUxU0ZSRDc2eVcrVWxa?=
 =?utf-8?B?N0JWbVhoczZxejZ4NXpmajBsdEF5UVJtb3MzMTFCdlZJdUx0Ly95NVoxQ1VM?=
 =?utf-8?B?WmFuT3pRdlZZanBhOStFYmxiTnJTSjVKQnJvV3FIOU5wUTNURTU0Mk01a2hO?=
 =?utf-8?B?NnJaTzZIT1pqT2YxTnpxKzd1eE5EUmZsZ2RyOUxZZWQ0TER6b3ZFTmxkU3Fh?=
 =?utf-8?B?dWd5Q2JoMExkUzRHSnRkdmpwZTRIQy9GMmRiSTA0ejMrOVJQVm1QWHh4Syti?=
 =?utf-8?B?NS9XTFMzZkRuSnRLekNPL2xtVmRFRTF3Mm0wTThxSG9hVTgvbGVNbjA3REdj?=
 =?utf-8?B?QU8yVnlVOGdjNHorekxVZmhOZEJpSEc2aktBdDRva2h5ZVJoajFEMVBzUWUx?=
 =?utf-8?B?OTNxT3FOVUlPZEg3L3I4anAxdVdzbGlwNVo1MnExd1pmUlVxV09xYUdGVFZ4?=
 =?utf-8?B?SXQxY1dKYURYUVltanYzQzRpNmFKdXFNRks1S3p5WXVodTFTTkdjZGVsQzI5?=
 =?utf-8?B?amtqYUsxWGkxTS84UTFKNTNqa2FVY0c2WDl5MjZXSk1ZdjZMQ1ZBOHhBZStC?=
 =?utf-8?B?VVhZdGhFYlZZWU10eUZpaWdmWEdWdDJMMlplWW95elVmN3hObC8rSjZlc1Bo?=
 =?utf-8?B?WGxLQWR0NTlBV29kNkVwNkNIQm85ZkttZElpdWV1SlhTUmM0a3VLSlRQZTlV?=
 =?utf-8?B?UFVTWUdBLzU5alFYV1I5RW5IUHFMcEhzMjFZRXBKejVQb2lRWFFGcUxHeTUr?=
 =?utf-8?B?QTl2Y3FTQlh5Z2twaTZZbDRjendZNHBqVXVjZEtwUGRqTDM4UmVzWkc2czdG?=
 =?utf-8?B?WUdSeTNhTUlkVFhkVGFQRUZvVS9jc05LWUtMd1A5QjVUcnNZUFYvMjVuSW9l?=
 =?utf-8?B?ckZ3cWxFaE91YnZpMTlld3NIRzA4Nmw2SFFJdTU2OHJ3S1lITlFrMUJGM3dW?=
 =?utf-8?B?bzJScG5qZzRFZE5BZ1pjYmFDSXBRcktGVjRKU3kvamtUcjdUR096TTRhdnhT?=
 =?utf-8?B?dmRjc3RMRW5JRnZ0UDduRnN2dnVmV1h4ZXdWWFBsVUJPS0hDcnczTjIyTTJO?=
 =?utf-8?B?YkcvTlJ6ZDRjbjkwN0pBOS9wcHdFM2wvWHEvV2VtVG93VEE3Nk50UUk0K1pZ?=
 =?utf-8?B?YzZxcjdpZm5xdGxqa3BmN0dCRFlhY0N4Y29XQUdNdnl3OGlJNFJRVWZpdVFy?=
 =?utf-8?B?TGh0dm9pSE9KdXptajY3SzZoZjZ5cHAyc09Tbk5nY3M5MHRrcHlMQzlJWFFu?=
 =?utf-8?B?cWR0VmtOQSsrN3R5bGZaakszdDR6SzhqT0g4Q2E0ZlpjaE1Gb2tYNFBHN1BM?=
 =?utf-8?Q?Nx5xcHTr9MOG1EyY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5558571327C190438337CB67CFCAD4AA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sGXl7lqzPi0Djii9St/dAbs0L9oRlP3nOS7rfyeLzCY3f0ZaVHXmBC4XXq64jD/xj3k+fUMZ3eE2ya6GEZApQsjfAsQSW/Mac7WwgT48PVzQcVxUtjDq50XxzXdDORBRXGXKBlaanJaFkZYjbHsVxc8bsJNT58LRuT0Knbq9ie3GCF0mwxgy137ul8nUGqcZMMDeEfgIevOMiJOcID7hHCW4iBLU20DEcq0AyLyPXkxL/qY99tPK3oD+DqhQ6cXSvgKz1uyiZ6w1uUEgI9vPdqWsl634rozIWvY2TY7w0YFIF4tDjXFesDy+FXx7oKQix2GeZCbvo111MjV6bziVuQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f6aa5a4-af21-4ffb-513b-08dee63f625c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2026 09:15:04.0087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7R23iOm/PcCreoCmgnub3XEka4wafR8sj6eTAmSOsvVNRacqqfP+nmKuxbZerIBIDYWDKAGTYYe8TgO4xWvEIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB10511
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDIzOjM5ICswODAwLCBMaSBRaWFuZyB3cm90ZToNCj4gVGhl
IFJQTUIgY29yZSBvbmx5IHZlcmlmaWVzIHRoYXQgcmVxdWVzdCBhbmQgcmVzcG9uc2UgYnVmZmVy
cyBhcmUNCj4gDQo+IG5vbmVtcHR5LiBUaGlzIGNhbGxiYWNrIHJlYWRzIHJlcV9yZXNwIGF0IHRo
ZSBlbmQgb2YgdGhlIGZpcnN0DQo+IHJlcXVlc3QNCj4gDQo+IGZyYW1lIGJlZm9yZSB2YWxpZGF0
aW5nIHRoZSByZXF1ZXN0IGxlbmd0aC4NCj4gDQo+IFJlcXVpcmUgYSBjb21wbGV0ZSBmcmFtZSBi
ZWZvcmUgdGhhdCBhY2Nlc3MuDQo+IA0KPiBGaXhlczogYjA2YjhjNDIxNDg1ICgic2NzaTogdWZz
OiBjb3JlOiBBZGQgT1AtVEVFIGJhc2VkIFJQTUIgZHJpdmVyDQo+IGZvciBVRlMgZGV2aWNlcyIp
DQo+IFNpZ25lZC1vZmYtYnk6IExpIFFpYW5nIDxsaXFpYW5nMDFAa3lsaW5vcy5jbj4NCj4gLS0t
DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
