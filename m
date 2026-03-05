Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536CA279346;
	Thu,  5 Mar 2026 03:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681333; cv=fail; b=qEID+8xlMSGVEvXQw9S7nEjIZlxUUVVXVZl8WxqNeCHvhaIBc8msLbaB88utbnT7LO1KJadKYvacL9p5YAmxCWLdKMXDIPqKVAXPZqrgajInxTj/CraN0p+bHo+L5shMX66n5ctIPM0CNkVn0QWyzX+bZNvxUBdcJ/S7BeOTWbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681333; c=relaxed/simple;
	bh=MqNFRgkDQmjpB/apGk02shd7hkZl45QoQiaMEuVwRxU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IvTnKWhi77p6bohHhwJPRNa2Eb8b6eAVtPiEVPdy3Ugc0Na/HV2t5WIsRwyOKJfCJ4p7zgWoRgCY/v0a1aj7MM5cHlYzTmc1TH9D6kq4Rhcj62do+cBi39ePpp9XmynO8C04pB0Z4pEksHy7YqmAU8JvEdHF5/O+3Q+ZzpV2y0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NWV3oOGU; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=t8Ok7L1b; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NWV3oOGU";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="t8Ok7L1b"
X-UUID: 6ba1d362184311f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MqNFRgkDQmjpB/apGk02shd7hkZl45QoQiaMEuVwRxU=;
	b=NWV3oOGUpujo6YMgnWXmadt8ZvoG4LoIZtVD1N5BlKG7G/bTBJqx7VmCr9/a26i9QydkYerVLAx5WMS5bwrXo9/GYeMmsE6B9RF926iSUCnLklKDJxCe7KaEw67R38zUyKwtvv0akX9KhyJwjfqdbR9O0xtnwCVz2oL3kCgHdhs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:1d07227e-2503-4015-8810-7be17898afc0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:2fa342ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6ba1d362184311f1bcd7499a721e883d-20260305
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 800545079; Thu, 05 Mar 2026 11:28:47 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 11:28:46 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 11:28:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G0u0TXXv/SUDi15xqMKrWSlEz/xLuj4O/FkpUYFcTRBfVfMGLWmREqvbaQK+k79ZHhRcmiApcwkqqit5Hh8a8bMzrkc2PGZU9Fj1PLJ68pc5GnQ0ltcTC7GRGNHXYwHuaLHpf3V0a/P2Cp+KVw14/Z/ArZCB1VOF9KhWNt9rB4WTMKwB6sFqUAV2w2bq1l7gFBjBptgoKLv3Yz6tVuRYZLd5dGuBhMIgTfnN9SPV5gp2qICIt6ZUsgrXYgaED8ieR53TSt/KqsYyFxkzY1Odn9hniue3JnRvn13WanyJJfpr6G0IMRsA8y7oms3Ad/shWu601OAsnsiBy4tYPkC9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqNFRgkDQmjpB/apGk02shd7hkZl45QoQiaMEuVwRxU=;
 b=c92HfNa6R1HBZ8gDBZ4nlOHN0W+IGdwULE6Jz/QfQRIQdhkoCbTQj6lcnA/KaJYKDsGJOXmwL9FwRPXXeorcGviwHlhdjBLT4Q9mmIipNgDP/ueYLImeeW28m9+9iG5ip1Qa8GW9NSvYF0hQaLgqbRg0+uYDFbSy6lArL7/UohBN2WNmNuDsR78dSuI0rlQlZF27dVLMjUx0/b3m+ftLBw4a/Hj67BgP0xWc2rGJYKci+xLD8llTutIJ1mu3F5JcEtrdvZ69BgVjcmpmeMcTdtNWUoVYknZ1+84pMD9HXdosgOGhHfkwbY4UAiNJcP68tBwupVFcPT23Y155qabRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqNFRgkDQmjpB/apGk02shd7hkZl45QoQiaMEuVwRxU=;
 b=t8Ok7L1b2kgV2dgZ96mCf2qxE+BV/barnWpP6E4IP9YL8UcEI6TfmMz/rP64KDhFcs6r18xZxckSoRwXBgdQmCHKE4CFBE/gPz4tGOrcUQ2vrdYtxqXEbrRpcXzWxtZ/102Ijyd97Usekxe+H5vaYlt708N0iV0opc/d4KwTleg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8163.apcprd03.prod.outlook.com (2603:1096:820:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 03:28:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 03:28:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "vamshigajjela@google.com" <vamshigajjela@google.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "arthur.simchaev@sandisk.com"
	<arthur.simchaev@sandisk.com>
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
Thread-Topic: [PATCH] scsi: ufs: core: Handle MCQ IAG events
Thread-Index: AQHcqm6tlxTa2NfLgkq8161GkZ8vOLWcm0YAgAHf1ICAANBPgA==
Date: Thu, 5 Mar 2026 03:28:32 +0000
Message-ID: <151ef927de40cd3e663b816194761a029c07ab23.camel@mediatek.com>
References: <20260302180117.2797184-1-vamshigajjela@google.com>
	 <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
	 <2cdc620b-b521-4058-a802-87591aa4c253@acm.org>
In-Reply-To: <2cdc620b-b521-4058-a802-87591aa4c253@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8163:EE_
x-ms-office365-filtering-correlation-id: 4ce46039-a889-44ae-a746-08de7a6746fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: ImRE5x9ENXZGCAs0fH+1KHg4aj1ni9kDS9yFwIdc9eQS4KjTvCqa6v7+0YQ0KHdwX2+Ok/XkY3Otorxi/Ejz55+jMto/zKCABT3AbjS+y//SkQlPiu4am/FSnrfcdJKCRnFojKtIXY2a/Ovi+0taTx2tMWPzjiwYfBjJNSdcjbEmNB/csQEt9h2p0QcJLcWbi/ig/7RWX+83syWufeN5pe/pGstNp9cldka92POlfcwYel94mCuX4QSMR2s5ielN6UBy4mtS1sGolZ90S1p8Qsyd31ZCdQfQhZwDseAoGGWxDZW+SgZi2A446KSRs2yr/zbJf2CqqkeGXwOwzgyNQHVQ9CyA6aIrM6gk/7odjBq+vp+1et9YmVno1HyzqPSGPqR18hPyRMbtYVgS0MhV32C9I9Pke+g8DZTPu7YMPBDr7NqEkCI9T3xTKSDnatpYLo00JeBeQnS/bj6TzmixAjrpZi9uxC+Zg8gqAQqiv5CVqyrNvnLT7834s6RHBF0yErX+fLv+Pa7eknJpbBzyL4FqRjwLe4s9/Tj2CxJih8CetA7zGSWJ/H83Qz+G2uhyxXxHEQmqa+CvXy0a/1x/LOekW8OULwz/1d+akxUoa981PdGfrDrUKVOgSiutG9vku9gPskxPzMjHZywWnJrJ97chy+aNad33QjnKx7ECsvW8zCKfjfhswZ/XRb9rLLCExpv1pALbkHxNPtSthJ70XAbjFb3Zgojnid4S35XGs4+/tkDufHPZsKbUEer/JLiRjm09XHUFX7lM0OKCtnlPDaGYymxCTOB3q8DNTMaUQoY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk1lMGxoMkxValRndVdIdEZvc1FleFZHQ2JOK1JzczFuV1JLb3BlZ3NmSmNp?=
 =?utf-8?B?RHJmQWpyTCt6dHkrWGNOdXRUbzB3QmVBR1VsaHNzdXZmOXFGSCs2bnJNRGtK?=
 =?utf-8?B?a0pxVGsyN1E0YkNFMVNCOHgxRGpWOE1wNXBVNzByWGd3aUVTZ0JSVkcraWxx?=
 =?utf-8?B?Nnc2Y28xMXkvU25jMjZJa2gwV1VtMDFMa2dlYi9jV1NlS1RNZVFnVEhYSmk1?=
 =?utf-8?B?dkVNMVNScUtjcFVtM2NQZXgwckQySkxva0xLbGU3WDdObFM2T2dzK25QMFZ0?=
 =?utf-8?B?empXWENYUTNuRVIrUnV3TFJTWmV6bjNGeWFXRFZobzdJMVZudndSc2RPRk9p?=
 =?utf-8?B?SzRCbGhiZzRsTzd5TzREZnFwQTBnb0NkVXhrU25qcGs1TGdyWVZzbVF0VXRn?=
 =?utf-8?B?cTFkNVNzQlNTa3BzSXBscGYzVVJzeC9IcFlFTFpIa3RDOEFXSW01d054K3h6?=
 =?utf-8?B?V3BEcUNKaW1vZHEvaEtKc1BjdWdWRlRaZmpRYkEyYTFSSUt3ckdVblRpd3ZQ?=
 =?utf-8?B?MmNwQml5UG42a3pWVi8xMFNUUUZhQTRmb0puZVU1RFJkZC80UnpOMmpGd2to?=
 =?utf-8?B?b2x5K0NDWS9UaWErb1NBM3JxU3hCY0JHc1VrTVAyekx6VWhyUGdOdmxab3dX?=
 =?utf-8?B?RkIzYU9DZkNOMnU5QW14MUV3LzRIcXA0Wlh6ZDlOSWlKQUVhUmMwVXU4M0lh?=
 =?utf-8?B?T1ZQTFRwQ29UaWZ0Sm1obTc3dnB4cWkwTnc1V29WZThhUmc2eThETVpLUVdl?=
 =?utf-8?B?dzl0ZlBZMm1nUWxBQjNIU1R1d3pQdTVlb01IcFdLcE5xMTFSZDdHTXJ2WEow?=
 =?utf-8?B?OGhYeDV5Y0ZOM2JUanNuS2d5MStadWJXSk95Wno2OHNpY2F4MFUwMGlTdG1p?=
 =?utf-8?B?b1ljT1BULzJPZWc2VEpBRU1pSHB4L2Z4QTJOYWpuQ1lGLzVJakZYSFZpVkNK?=
 =?utf-8?B?NFFsQkxNL1JjMzAvZ2pyalNwMEpRRG9qdExCb2plZGZDWDJPRTdyQVNpVWJH?=
 =?utf-8?B?ZnIyUFZ5bjEyeDFUaUhQMWtRTSt4emNvSXAycXFxZ1ZqVnFIVHdEZkkwVWlY?=
 =?utf-8?B?WTV1b3ZVcUxGOTRvcXdNVjFKZm5ERWlWWWM1bGpMNUZ5T3JoTzFuQjIxeU9N?=
 =?utf-8?B?MnJjMHlKSHVwb04rMUQzUGM3dUFpSS9IS1R4NFY0WkJvR3U3ZTFha3ltSlVS?=
 =?utf-8?B?VXFpWHRiN3BGK09mZTVuNGdvSjNTOTZUa3lzQ25CakI0YnZuRHZSYklGbTBx?=
 =?utf-8?B?ZlNldUlKcXJQTUxGdW85ZmNOY3lPODY1aHBnbFVIR2ZUR0pwQWM0SkRnZ2tz?=
 =?utf-8?B?N0Q4WkF5aTBXZVhielBOM3I0bHROb2piRUdjOFdiYmo2NjBCWDk1OFZabUov?=
 =?utf-8?B?ZTFmcHlPUkZ1UmRITTJIYVArUzJSb0g5YmxneDgyMVltcy8wRW9oRUtncFpR?=
 =?utf-8?B?SEx6bU1RZUMwcG5RTWlBZDNXazVHek9PZThvOXYvSithU2xmc2RnODYwQmkr?=
 =?utf-8?B?ZFBlbllGZjVjdVNBWW5UdlhsaDNCemx1SnJyMllMT1ZXYVRTaFZjZitCNENN?=
 =?utf-8?B?Tm9Pak95eGJHVGZqQXpKSXJrOUhUdGZaYzlETlJ1RW5meDM1TE0xQnRhc1Q2?=
 =?utf-8?B?cVlTam9KdXYvcHJBdnh6VmwvbUM2bzF6Q3AzWXIyRHZLQndnZ2xWYkJYWVpN?=
 =?utf-8?B?QW8rOVZ6UWVSNUFTVW5weHRtRlU4Qi9wc2prdnpMUlVLelpNQlZVVmlvLzVD?=
 =?utf-8?B?TzNWOU9ZbUZrRW1LQjFnTWx1RHR3c0U4eVpJZERqREZRcnoxenBDMkFwMWtG?=
 =?utf-8?B?TjNDTnJab2JFZTNreEQ0NmlreEFPT2NBR3dTellUUGRGQXhRSXpVdEk0Q1Rt?=
 =?utf-8?B?MVg3eXdhajU5ZHdWcW9nWE1EalI3c0ZYK2RtMlVxOHp4MW5qZVlSN3EwckEv?=
 =?utf-8?B?K21JaWZzeUVxc0tyRjZ2YXdYUmVqU0t6Y1NBcERDYXZhUWE2cEM5dmdyeUVz?=
 =?utf-8?B?eU1vem93V081cDVXRGdYZDUxeHkyT2hpbEZTRkVxV1hQTXJ0YUtQQm1HZFY3?=
 =?utf-8?B?dk9rWFlOUFp5VG40bVdDaWFVekpGbDdNVVBCTThlYUhqL2piOUNCTjUweEtt?=
 =?utf-8?B?bnZISmNOWFVnMGowSHhCZjlaN2k4SWprT3JENXdDQ1ozUzZXRk5vT0ZBRGF6?=
 =?utf-8?B?NWNrMVpLSTFMZDhhVUZuN0xYSG92ak1QcGFGUjg5RXdTdE9ub2NQQURvWmV5?=
 =?utf-8?B?OXA5aUgxUEYrYjlHTm9RdmJLSTR4UFROSHRxS2ZsQi9RVjB0aUxvUTNhS3d4?=
 =?utf-8?B?cDQ1QVFOV0ZxK2MrMDRJUTI0YlBwK3hxYWYwNE9nQWJEOE9OalB5eXVQRjNC?=
 =?utf-8?Q?1W25WnsaFDtY5VO8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12F356CA813EEC40AA221D82B15C50B1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PP2fnt8/gOQLppBb9BgtiV33UWhlpeOpyt+QW7TcrL47ZUkSJNfiXLqqRvz2MUP5nnx6LmnAmV9gJXeeJmsuzG6rTkfaImRaSvigs2JcbGhIjeg7LWlwzF2lf8cMyylGFjDqKYkcYiuedlMk8KTm5d92PU1a47Gcz6z/ZpKQbkZxzOl1tLoEzwgpfwhdcnt/RF/NdR4fIM+EBqkSCsdIM4P9Ewe2CZP9QGe7pafM9EHBgH0u9Vq+FOuiRtSe9B3TUuzznKgVBNokX2MSKSvSVQe9nOKJIdDZ4SRPVyQ+AegUREN7H2UiVfzSwshjkR1jSkqhOgrQm5uIiY1d0dbOUg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce46039-a889-44ae-a746-08de7a6746fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 03:28:32.3682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3pfqS5CFnJM7v8wyLWit+tQ7REcyXtqOcWiuf16QNfZvmAoxNYskKGooMrnUAPwcSMkMjC2mnEuYdZz7LIjAmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8163
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDA5OjAyIC0wNjAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IERvZXNuJ3QgdGhpcyBmb2xsb3cgZnJvbSB0aGUgVUZTSENJIHN0YW5kYXJkPyBGcm9tIHRo
ZSBVRlNIQ0kgNS4wDQo+IHN0YW5kYXJkOiAiTUNRIEludGVycnVwdCBBZ2dyZWdhdGlvbiBFdmVu
dCBTdGF0dXMgKElBR0VTKTogVGhpcyBiaXQNCj4gaXMNCj4gdHJhbnNwYXJlbnQgYW5kIGJlY29t
ZXMg4oCYMeKAmSB3aGVuIGFsbCBvZiB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnMgYXJlDQo+IG1l
dA0KPiDigKIgQ29udHJvbGxlciBpcyBvcGVyYXRpbmcgaW4gTUNRIG1vZGUgKENvbmZpZy5RVCA9
IDEpDQo+IOKAoiBFU0kgaXMgbm90IGVuYWJsZWQgKENvbmZpZy5FU0lFID0gMCkNCj4g4oCiIEF0
IGxlYXN0IG9uZSBpbnRlcnJ1cHQgYWdncmVnYXRpb24gZ3JvdXAgaGFzIHRyaWdnZXJlZCwgd2hp
Y2ggbWVhbnMNCj4gaXQNCj4gaGFzIHNhdGlzZmllZCBlaXRoZXIgY291bnRlciBvciB0aW1lciBj
b25kaXRpb24NCj4gDQo+IFdoZW4gaW4gTUNRIG1vZGUsIGFuZCBFU0kgaXMgbm90IHVzZWQsIFNX
IGNhbiB1c2UgdHJhZGl0aW9uYWwNCj4gaW50ZXJydXB0DQo+IGFwcHJvYWNoLiBXaGVuIHRoaXMg
Yml0IGlzIHNldCwgaW50ZXJydXB0IHJvdXRpbmUgbmVlZHMgdG8gc2NhbiBhbGwNCj4gaW50ZXJy
dXB0IGFnZ3JlZ2F0aW9uIGdyb3VwcyB0byBkZXRlcm1pbmUgd2hpY2ggSUFHIGhhcyBjYXVzZWQg
dGhpcw0KPiBpbnRlcnJ1cHQuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0
LA0KDQpJIGtub3cgdGhpcyBpcyBhYnNvbHV0ZWx5IGNvcnJlY3QsIGJ1dCByZWFkaW5nIHRoaXMg
Y29kZSBpcyBjb25mdXNpbmc6DQppZiAoY3EgZXZlbnQpDQogICAgaGFuZGxlIGNxIGV2ZW50DQpp
ZiAoaWFnIGV2ZW50KQ0KICAgIGhhbmRsZSBjcSBldmVudA0KSWYgd2UgY2Fubm90IGNoYW5nZSBp
dCB0bzoNCmlmIChpYWcgZXZlbnQpDQogICAgaGFuZGxlIGlhZyBldmVudA0KQXQgbGVhc3QsIHdl
IHNob3VsZCBjaGFuZ2UgdGhlIGZ1bmN0aW9uIG5hbWUgZnJvbQ0KdWZzaGNkX2hhbmRsZV9tY3Ff
Y3FfZXZlbnRzIHRvIHVmc2hjZF9oYW5kbGVfbWNxX2NxX2lhZ19ldmVudHMuDQoNClRoYW5rcw0K
UGV0ZXINCg==
