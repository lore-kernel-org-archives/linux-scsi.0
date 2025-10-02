Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957EE1DD9AD;
	Thu,  2 Oct 2025 07:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759391975; cv=fail; b=MThQ27tYG4eKZcyfwNxZSbIBeqTs03vVxlXorKnk0g5Q3yq23Xrcl9Qz1iVycP+pfZJtZ/FcSLt5SoB5Alpa5fEJy2am4a51JQ7i3YVGdm5/DUy/ZzSEmhCfPqBOIibBh+o9WahV2tZ+N8uLmTklb+KXUbmSerFt4eDb3FKWWvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759391975; c=relaxed/simple;
	bh=X+5nPSnFhST+TwT/hYB6BJzUXZdd3kXQDMBMOKLG4ts=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RRPRDYfQrEDsb4MB2MORmxY6vdbFoxEaRdqP8CoUHjp34jd1n8FUAEi6NcKXkuF8IE02+/AnnNg4eOskBfnblvU9L0hDsmNkqgO+ma6tX9/1+D4Ii2AByoSyuMFZxCLK7l8PYiAB/mSdZqRhGTk6RQ4CkNE8mvyzRsDg826mYyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=FMpyFjE7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Qkb2sBD3; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="FMpyFjE7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Qkb2sBD3"
X-UUID: b7af04989f6511f08d9e1119e76e3a28-20251002
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=X+5nPSnFhST+TwT/hYB6BJzUXZdd3kXQDMBMOKLG4ts=;
	b=FMpyFjE72G7IcHtLAdsAth+kR1XgoNMyYMZUM87Tqzld0WQTOzVefuu4xzeVegkcRArvIwuLFx0BKQ5j8bD+Qq5wk/u3tGEdXdksixtCSFYRW0eU7BVDMeo990VqlRREyCs8BxRh72wJIXWhSxt5TrL6Ff3fsphF9ofCkl8ReqE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:4b97189a-6bb1-417a-87bb-3791cb114fce,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:1e3d2a6d-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b7af04989f6511f08d9e1119e76e3a28-20251002
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1768677517; Thu, 02 Oct 2025 15:59:27 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 2 Oct 2025 15:59:23 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 2 Oct 2025 15:59:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LIIi8nkNnHRSt06hRT40VJkMlqlnNeBb8PzhgFcDfGe90/Z5K4tBOKiJrQC69U4VUhFGTShPAVV15+FRYSFxvDBUNRVxy1PCa3BewH75NVV3/4kIukxP5wRk/L5Ui34tQtGwHKlLl61JrlKkiZSheBbszU+TzPcvu03L9ItkQkDsSkUkmLOwKhQdz3+I4mLz+XLokIjoJeOljSbMmuhAPyHyhr6nmOBVNQICebys6R7votxnWLTuZzTKc3rYX7KBFmJT6DPVR0Oo4V9h4XVdHVo5mxIFlonsGvNJe16H0Cgz7336W5efvy6QBSIYgoKBMUmNDl52nIKtWgSHUCh6ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+5nPSnFhST+TwT/hYB6BJzUXZdd3kXQDMBMOKLG4ts=;
 b=oinTZDQruR3PANtd+z4PzKP+BjNJVJUfBWV6q908DZssnOgzc2KMKxejUfTUcJzNvAGPn0e1e751jbKpftxlNLfe6b2Ah6iHJJ354L2IQwWRE2qcnpD9IvYes1S1xr2GN9PrdSEojPfqE+qzduQJm31cp/Y9GjsXuI8N5zBFDFPZKh+O5lFtZAqbI4sTnbsqJjPOTXY8aAXibxoAKritn3T9cWNZqSf6xf34x5jrFOcVCZkA4FDAc0nehJANsRa6U3xybguWNnr2f59lF1yX00QKkgl8L/zjE0DumPpAD3Qp91wXAH9vDrOUpiICRcqX1GNbjpmE+ZJzlvDICi4dsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+5nPSnFhST+TwT/hYB6BJzUXZdd3kXQDMBMOKLG4ts=;
 b=Qkb2sBD3gXyDw4ORADBgAwNUJywn3t8ZsMpeWyEFYu6Yb71OL/AgToOhzoh+2QNjP8Ps93BdkV4Bzwtyv4h5Bwx1/bC+xrdb9CkPV3r0hMdAEMItPKirUjDdXffQpScghbHL89wVkSjdksNjopk/l6Yond7s87SkjeUwA59ndZ8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9448.apcprd03.prod.outlook.com (2603:1096:405:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 07:59:22 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 07:59:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Topic: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Index: AQHcMxYfazcJy3COe0ibj/0v49XMcbSufr+A
Date: Thu, 2 Oct 2025 07:59:22 +0000
Message-ID: <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
	 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
In-Reply-To: <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9448:EE_
x-ms-office365-filtering-correlation-id: 55912c6a-4151-423c-cf4c-08de01899909
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eGxtblpPdUwrVllKM09mU3ZFL0ZlWkFOWVI2eUZWcFduWmdzaCtPeVIySkI1?=
 =?utf-8?B?MHArOTlRb3B2L28yODJoTDVQRTd2WENvVGtmQTlFbFdkM1JqQVRsdWh5OFBE?=
 =?utf-8?B?dytrWWdhSEZ3bzdDeDdiYzk0Ym5sRTRJVkQ4K2hyNkRCVlZQTkljeTJLRFh5?=
 =?utf-8?B?ZDd6V0ttTmFlS1VwV2RONDYxMTFCbVFMVVNYUnpNQ3RxMkxMajF0czlhYmlY?=
 =?utf-8?B?ckNCbXBtYzY2Z0pXM245WGFaZHQ3ZE9MQlJubG1VVHZwUjBCV0RLZnJMTkFZ?=
 =?utf-8?B?ckNDZ0tvZ08zbnkyeWIrNEEza0xyNCt3eFZIMTVHOGpKeXJaeHpxSlFmM2Vn?=
 =?utf-8?B?K1N6SUs4WVNNVWczTGNsNWtqRk1wU2dZSWt2QjBONGhBeTZFaFlXV3JWdnFN?=
 =?utf-8?B?dzhsajh6Nkg4c1BRc1NwNUhBK3F4Nnhwck1JdG13YXdXM3UrM0UvaGlaTC9Y?=
 =?utf-8?B?RXkyYmYrNXRGSlFvTEVjUVY3ZEdQTVBoWEk3ZWRBU1RSVEFxMHFJeEFvRG41?=
 =?utf-8?B?aUh0dnNZdS9NdXBHdXdNa2l3WWI5WEJLVG1hSFFnQkd1aWFadmQvQTZnWWYx?=
 =?utf-8?B?L293VHpzeU54Mmw2TE5PMWUzNU9wUzgrQkhjMUIxd0xkbXd6SUwvcnQ3TXk4?=
 =?utf-8?B?QUxoQzJWNzQxTE9OUytKQk9CYUhFQ2Y1czBUak1Vd2Irb0U0dDZmaUZRbzY2?=
 =?utf-8?B?SFBpdTdPU3RUZDhkdVk0UkdCQS9VNUFSS2VZcGdwT29HaEk4UjVNRTNFQ3dV?=
 =?utf-8?B?N2paNUFNYlpjdWdpSnRUTVViQVZ6clJZY0NDSmFZcXJpUGR4NFVvb3FUL0Zx?=
 =?utf-8?B?aGp0VnR5L25KUG5KdnZ4QndiYUphNVl0T3hieXRzelNLQXN2OFF2MUJaSnRE?=
 =?utf-8?B?ZEl2eSt0c1JiS0lLYjNsU2JpKytUa3NFNTdoZEJESzgxWjExckk5Z1Q3b2Vk?=
 =?utf-8?B?cEpOdlVPQ044VGh3YnE0bXovN3lUMDIraTFlemRpR0FMcHVOUWtMWWFENEpu?=
 =?utf-8?B?RDN4bUNVNjBXUGtaKy9PTi9CZzl3dTVXc2J4bkNtamc3eFZHSCtkN0kvcEQw?=
 =?utf-8?B?TjFjaGFtdkhXMEhwRDRPT3dhazc2YnpMcmx1bmlrbG9IdUZQaU1UUy8rTlhP?=
 =?utf-8?B?OTJvNnhRWEJaYnpIckhXY051bDEwbjIrMlVHWXZXYmVJVGpEcG1uZXBwbWlv?=
 =?utf-8?B?cXZYWTQvOUtUT2NFS2dTeCtDTFdpSWtFOXZkOXpKcXFFR1RSUzE3dUJHcm9t?=
 =?utf-8?B?M3J5ZDJCWGJxWGplcWNWdzNIakpmc1lmUmNOWXpzU0d3TmcrWjlKZVVmTWVT?=
 =?utf-8?B?L29lZjZOV3JQZXliSkRVQUIzNllEUGxsRDd4U2RLbWFTb3o2U1FxMWRSZUM3?=
 =?utf-8?B?d2wyMVZ3ZEExT3lid01ObGt2dFRKOU5uaXlGeHVCQkdudnpqNlIzOUlBdnBt?=
 =?utf-8?B?NDAyQjlxNTMrcTNiUjl5Yk9JYlR0YUNMdnk2WCtrU25QNUx2eTUyclFUa3dT?=
 =?utf-8?B?bUFlSENYbW9HRDc3NWU3ckV0eUppMTNXNnA4dTk0c2V5ZERrR0JLOU9qeTZB?=
 =?utf-8?B?RVlzSmVwdE5XbHdPVlhKRU95allVa2ZQSnZFeGcvZWgySDJkV1FtQXFVVXR5?=
 =?utf-8?B?Sm45emtRNDJIYmsydGxiRGJkaUVnYXd4b0pYLzJNV1oyeUlVR3lHTlBWQlpR?=
 =?utf-8?B?amtVaTc4aE0remZRTFpuaFp1Z0ZoTmxHRXQvaHRBQ0E1eXN4eXNzbXV1MlBj?=
 =?utf-8?B?OVF5T21ueFZTV3BidGtoYmJJUGx3MWhsQmxxRDdkeVBjK0N4MitiWHlocWcz?=
 =?utf-8?B?K1pBUE9DdVRKSm5VRFp4SXMrdVk5Tm51WGpLSFMvQkVDUWFRakJHenRjUlpp?=
 =?utf-8?B?ZnhPZnZCOUUvVXAxWFMrUFUvbnRGTWxpV2o4b3JaRFRQYVAwOUh5S3VHbDRQ?=
 =?utf-8?B?V2lCZDF5VkxlQlVoNFlSYWtsak5aU0xWeklhczNqMzNOTlk1TjIvSlBRa2Nz?=
 =?utf-8?B?dEpiT1lQNHdjUW5PK3hnMitGeTJkOGNWSnk1cDZBL1pFc0xHZWdJaFJlZ2NC?=
 =?utf-8?Q?F1tem/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjdrWHFGMS9Dd0RsdTRJdWNqMEk5ZEdpZmNNUzlydHBpcnZBMWt1akVrVGw4?=
 =?utf-8?B?KzdCNXhnL3lGOUVYbnBkdU1WaXlCMUVuMmt2ZG84N0hqUGtrV1NLS3gwR0Q5?=
 =?utf-8?B?WkpHeGRENnNjeU5uaGZaWGZLa0FwRktSQXNrWFNLZnNZZlMzTE9memRyelBU?=
 =?utf-8?B?TFhKRXBZWThXMFdtUU0wRWtsUFhXYit4SW1LTlFydjNSWG1ieWVlc1oyMVZN?=
 =?utf-8?B?UDEyZHRoUS9za0x1UmhiRmVlWTEwS3hwaEc3bjJvNHdJeDJJRGJqVDczWlFJ?=
 =?utf-8?B?TjdwL085RGdZTEMxa2RYVHhCdEFKMVNIS2M2UHlhTFc1Qm43MFRaMGJ4TTFU?=
 =?utf-8?B?TXlnY1RNTGFJUU5EakF5WVRXWkdjWlVQSDIzaVA0ZlpWN3hwY2dXR0UrVzh3?=
 =?utf-8?B?NnJ4d0ZjUkNBWjZ3aHB3c1ZXMUFmZmdocEovdXIvRGFJdlVmUmNqUTd3WXox?=
 =?utf-8?B?VWVwb1VaZ1psNzZHUjU4VlFldDlUWVAyYU5RTUUvU1F1ZWNJTlRaVGMvZDky?=
 =?utf-8?B?KzhxZUZGZGd1Mkw5c1lzVHMyNlNSb09oSmlIZ1VwSTR6YkZreVhwTytMdnVp?=
 =?utf-8?B?ZmJpRVpVbUk5U0JNeEVTNnZVRm9FbVA0WlBZd0dHc2xpSjFuYmExNFlGeDgz?=
 =?utf-8?B?QW1HWVlDNjlSWitNdUpsMGc2YmJvaW1iNlk1b21XTExIOWFxV3gxUUt5cHVB?=
 =?utf-8?B?dnpHOVVuYkFyV0dHUVYwR1FIR2V2WDREM0dGeVdmV2d2bnB2Z2xLaUZHOU5a?=
 =?utf-8?B?cy8wdFNBb1Z6NVlnd1Y5N1VONjZPWFVpWm5BdzBkYkE5TGphV0xoeFVMVXRQ?=
 =?utf-8?B?TkFoeWV2ckEvWEdzWk1XMDg2VTdXckZFWWZFbXBwbjJwaFVGbWIwTWdMaDBK?=
 =?utf-8?B?VDk5M1FOWUFyc0k4NlZFUnNkS042S0Z0Nm83V0NQcm1McUg3ckxOTDFyUkVY?=
 =?utf-8?B?eUg1blJuTEdwMlh1T3JiRzk1M3k2SHZXd1psRno1SDNEbWg0YUM1blAvSVZL?=
 =?utf-8?B?QnhhM0FHMnRwUitsWGdoM1NxZ2xqYlU0UmpSNXlxQkdSYVorOG1aQk1xS2xq?=
 =?utf-8?B?N014dlhWTEVJVzJzeDhqTElaYzRtcURBb0pmTE84eERSWU5mVzQ1Tm0vQmo0?=
 =?utf-8?B?alAra1Z3YkNpcTVFNEZObG1oWmk1YmxvMmxTY0twSEJ4aExrcThIb1FsWElo?=
 =?utf-8?B?Q3YySVlxdGgyQWlSbG8zMkxpN1JsUDFlSTd3UVdoYVFRN0JPNm53TEJCQnQ1?=
 =?utf-8?B?bFVidmtoWnNROHU3U3BJNGRtL01mWmZ5T1gwa05VZVdLUDJxc3FXYWJjTjBV?=
 =?utf-8?B?ZmRrQnBDYndBOGlORlk1NmxrQkI4MmNWZEw2aDIyV01PaSsxTXBxdFhqb3Ju?=
 =?utf-8?B?bG9vVnpXMmNrbWN1UFJFdmdCa3dmL1RyZkxwd2ZsV2tjNlRhTytVK0lFdkVL?=
 =?utf-8?B?TDlCMTl2WEFqSC9sNGVuaVdxQnV4enArWit5U3hGRW1aNERYWmEvYjFxV3dL?=
 =?utf-8?B?UnczeWlBT2lWaVB3ZUJtcGpmMm9DcktLd2tlWXU4SmVYc0lkazNkQ2VhRktG?=
 =?utf-8?B?cGN3aDRueU5FYVFoYjRrMDA1NWVOakRqS1dGQW9pVzBod0EyWHFjU0UyQjY1?=
 =?utf-8?B?Ny9JWng5cFFwcHVBYjJvTWphVHZVdnl2cHNrbStDYXNSc1hLc3hjM1QvVXVk?=
 =?utf-8?B?UURza0E5MUszaGFaYTBTVnJNVXhIbk5JU0kvWFlZd2FjSkllRWMvMTV5SUpB?=
 =?utf-8?B?WjhtWkxlSCtjcG5STTVzdmtUeVJkTklidUxzaEdxS2E2S2F1Rkp4Y0JZSDY5?=
 =?utf-8?B?REZGRG5JamRQaGlGa29mZUFnbGtuNTdjYTRpbnAvS1J6MzY0TmlnV2ZxOVdU?=
 =?utf-8?B?VXVmSWxQZjY2aG9YcCs0UiswNUNncC9FLzVhcmUvdkNKOU5JaG1teW9YU1RN?=
 =?utf-8?B?WGNJK0RqRGxrQTQyS0lobmJjVVNTcFJFMDlDdEw0aFh4d0JpT1ExUHpjZ0Fz?=
 =?utf-8?B?N2dlbGtCUHJBZExYYkJyN24zOG03aERxOVBMS1E2VERxN1J4NFVSekptdmM1?=
 =?utf-8?B?ZTdrQVdqcFl2TGlSN3ZxTHE5aGY2QTdBK0VjZjF6SlRFM0liOFRCeTdhamRt?=
 =?utf-8?B?eTE5SVExQ3JkbjNWaWZPN3lXeGIrZEcvM21tNXlEZ3o3RERSc0RKU293NkIr?=
 =?utf-8?B?V0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44953C875DA137498EAC07B3E432A217@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55912c6a-4151-423c-cf4c-08de01899909
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 07:59:22.2608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zGR5n+hFvvpmRHfzX9jWX3Ud7gAhDBmHNc9YehHD16UulhJOd1NOaq7XSwtHg0FGaV284ZSf+w4bpUiEa1Bftw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9448

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDEzOjU3IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiANCj4gQWZ0ZXIgdGhlIHVmcyBkZXZpY2UgdmNjIGlzIHBvd2VyZWQgb2ZmLCBhbGwgdGhlIHVm
cyBkZXZpY2UNCj4gbWFudWZhY3R1cmVycyByZXF1aXJlIGEgbWluaW11bSBvZiAxbXMgb2YgcG93
ZXItb2ZmIHRpbWUgYmVmb3JlDQo+IHZjYyBjYW4gYmUgcG93ZXJlZCBvbiBhZ2Fpbi4gVGhpcyBy
ZXF1aXJlbWVudCBoYXMgYmVlbiB2ZXJpZmllZA0KPiB3aXRoIGFsbCB0aGUgdWZzIGRldmljZSBt
YW51ZmFjdHVyZXIncyBkYXRhc2hlZXRzLg0KPiBJbXByb3ZlIHRoZSBzeXN0ZW0gcmVzdW1lIGxh
dGVuY3kgYnkgcmVkdWNpbmcgdGhlIHJlcXVpcmVkIHBvd2VyLW9mZg0KPiB0aW1lIGZyb20gNW1z
IHRvIDJtcy4gVGhlIGNob3NlbiAybXMgc2hvdWxkIGluY2x1ZGUgZW5vdWdoDQo+IGFkZGl0aW9u
YWwgYnVmZmVyIHRpbWUgd2l0aG91dCBiZWluZyB3YXN0ZWZ1bC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEJhbyBELiBOZ3V5ZW4gPHF1aWNfbmd1eWVuYkBxdWljaW5jLmNvbT4NCj4gLS0tDQo+IMKg
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCA0NWU1
MDliLi44M2JkNzMxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+
ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTk3NDEsNyArOTc0MSw3IEBA
IHN0YXRpYyB2b2lkIHVmc2hjZF92cmVnX3NldF9scG0oc3RydWN0IHVmc19oYmENCj4gKmhiYSkN
Cj4gwqDCoMKgwqDCoMKgwqDCoCAqIEFsbCBVRlMgZGV2aWNlcyByZXF1aXJlIGRlbGF5IGFmdGVy
IFZDQyBwb3dlciByYWlsIGlzDQo+IHR1cm5lZC1vZmYuDQo+IMKgwqDCoMKgwqDCoMKgwqAgKi8N
Cj4gwqDCoMKgwqDCoMKgwqAgaWYgKHZjY19vZmYgJiYgaGJhLT52cmVnX2luZm8udmNjKQ0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1c2xlZXBfcmFuZ2UoNTAwMCwgNTEwMCk7DQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVzbGVlcF9yYW5nZSgyMDAwLCAyMTAwKTsN
Cg0KSGkgQmFvLA0KDQpUaGlzIGRlbGF5IHNob3VsZCBiZSBjb21wYXRpYmxlIHdpdGggbGVnYWN5
IGRldmljZXMuDQpUaGUgaW5pdGlhbCB2YWx1ZSB3YXMgc2V0IHRvIDVtcywgZG9lcyB0aGF0IG1l
YW4gdGhlcmUgDQppcyBhIGRldmljZSB0aGF0IGFjdHVhbGx5IG5lZWRzIDVtcz8NCg0KVGhhbmtz
DQpQZXRlcg0KDQo=
