Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD27430FF04;
	Fri, 17 Oct 2025 06:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760683996; cv=fail; b=RaPVp3j3hFTbGRPKsw7JCg9SzmKHmanUs6sBorCE77NTVqQZ1UwmnrHvmfTJYnGH6wTBKKD4FqEXTrm86nPr9q0pi9rE8y5OwstYiBoqS9SXgb/Kiim5wEBSHc8drPHBLLJd8XyudQfaln7IA0Ela7/P4gKvDkELT9pCXECtCQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760683996; c=relaxed/simple;
	bh=Lc5vfPDnzGfLEcUe95/XOW4lpzKUWS12A57rw5H2N/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e6c/PYaJnp9URl1x9CQ2iS6QVjf7vSl69oJRESkBn18T5pKgy7XIDqKHtd8vxkGC/S5qUtfQ2FJf6To4MUl5px1W/dvB/oSNviVsyVStNI4wHKnQZGivuwgtFqADDU+OBiCBFQPXiptl+SSV3sUssbsyCne6Ocxu6jlB+/PAqS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DlXv4PVZ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=iTMscp/2; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DlXv4PVZ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="iTMscp/2"
X-UUID: f2590ab4ab2511f0b33aeb1e7f16c2b6-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Lc5vfPDnzGfLEcUe95/XOW4lpzKUWS12A57rw5H2N/0=;
	b=DlXv4PVZozn15cYx0aL0tb9CMrPnBnPUF6fgKJu3uTkbbP4yEpTkmNmA11/WaeEjsrjkMENmavPuUIU+kOQAtBK9E45MMXeFSgBQJD2wvgxAGrGuR6UFjS59iF1eH5QfAZE/cJVou11DQMGX/Ehp7BRXVd2eAOx+7x2+nGMavRU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:2880b82d-b6fa-48a9-b21b-4abad68526b7,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:ef7445b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f2590ab4ab2511f0b33aeb1e7f16c2b6-20251017
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1904276178; Fri, 17 Oct 2025 14:53:11 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 14:53:09 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 14:53:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNtgEZnZC652JUl0aDPSpjdDERNY3nxO6Vv0HVTbJM4LsPfNMGgMeYAP2JNe+4ad3Ml5CBSQlgCpkhmLPLYvBz86pl3CQ8pCqEJi4m6asK5aqfZ2sem01n8tYAEAbOAwVlQAzp7Zml00V70J8EhWLEgSN5tKisTafGg8CQScGa7soQmRl+D5riR9jMPkfLexCQVHWq4XgF8ePCIMA8IGWM7aCiS4MvJv/1lTks009gXf116SJlnlStDv4HIa+3hT8STzNtrCCdRbvqU/Hkc0KzyCgXv/l9/2OVSkIgwhtWEn6EsIa3D6RyFCA1HiwM5Js3aLD9m2aKKGOBql/1KoHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lc5vfPDnzGfLEcUe95/XOW4lpzKUWS12A57rw5H2N/0=;
 b=HtAlRjbaikkD2o8iib4cFrWhBfysE8Z/akCb/y9pYiS3ybNrvDfhfqACoQdXHINRgv7FhuHHO14cBXd22kthf+8NV0Y/14gWqiyMvgo/9VjPfEVpJSOBVUyysmD0lmg9GaCnIFvGGYFxYLO4C4Et/e/1L5La5oB2BL/NfrgomM2HdbVLKsbfTqQdHOFNQLajuAjcXZjR07P5IVYrm2izSzxpPyX4vaUxpQyAoZA825+5HbHX6mtkLAEkmtlS8njOe9nkfpWXPuIkSKc3IVA4f1zvx0QuBy13zEDOD9gR5VpP0ZXqWMWuOviIITfsoHkmQs/hQbgMUSMhULDf3JIhRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lc5vfPDnzGfLEcUe95/XOW4lpzKUWS12A57rw5H2N/0=;
 b=iTMscp/2Q+W4/EQDP9ZyU9uT9ID96d3BIsaqmPWzLdrmciA343oVNK9RJCk5/GPNrxHrTusL4XsoJf+w3IVwN8XceZmCAt1duFs4LLO64FNse+DqL3FUrnLPZJv865kSbju9TcH9aHOkROqVrwNYiYP9272ZhPMxbGA4Yj/gTfU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9367.apcprd03.prod.outlook.com (2603:1096:405:2b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 06:53:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 06:53:02 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, "nicolas.frattaroli@collabora.com"
	<nicolas.frattaroli@collabora.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v2 3/5] scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to
 mtk_sip_svc.h
Thread-Topic: [PATCH v2 3/5] scsi: ufs: mediatek: Move MTK_SIP_UFS_CONTROL to
 mtk_sip_svc.h
Thread-Index: AQHcPpWZvRrn20qEz0yYNKTh1Sf6TrTF6DCA
Date: Fri, 17 Oct 2025 06:53:02 +0000
Message-ID: <a24778e1d7e4359bf898454f0af2b1968f1e1029.camel@mediatek.com>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
	 <20251016-mt8196-ufs-v2-3-c373834c4e7a@collabora.com>
In-Reply-To: <20251016-mt8196-ufs-v2-3-c373834c4e7a@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9367:EE_
x-ms-office365-filtering-correlation-id: 94060c34-226e-4ae2-22af-08de0d49d109
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?aVZPWUk2dXgzT2hYejNsQzUyTWhTWURkVHVNSnNBcnZhN3NzbjRjVDJadjRR?=
 =?utf-8?B?cmhSREovMWdQVzU2OENVR2YydWdoTmxIbTdtVVVFWFdyMFZRQ214dWpSZE1Y?=
 =?utf-8?B?OHNTdXBqR3V3MWhzR0oveTVrT29WQndXWGV5eHdEUk5pTkk1UEVoUEFTd2Q3?=
 =?utf-8?B?Mzh4NlM3elpQYklxZjFkRnhZWldLVVRWVHBkQkczTXlpak1ZOEVrck9Wbjl1?=
 =?utf-8?B?UEFMY3BkdUpZckhZUlBUd1hRT3hqVHpXcjVHdzhjOTRDckVZMFo1SlRCamtO?=
 =?utf-8?B?NEtOQW1sOS8wMHZ4ejFwaUlZTERXQUZ4QnVyVmVORUdEaWNQNXFzNWFRNFNJ?=
 =?utf-8?B?UVV0cXp1MU9zVWowdmJVM1lIRUFXRjJZY3pJdGxzVEcwdzJtazEwWlNTTWIv?=
 =?utf-8?B?R2Jnd3FhcmJUQWdUUmxha1V2YUwvVHRXUVFQalBIMnNHZ1dnTlN3ZVQ1WmN0?=
 =?utf-8?B?VGdWRXhrVWtvVEJrS05NK0hwaXlCWTNrTXlzMG9RdnBrZmVSYzlQRWNaa3Qy?=
 =?utf-8?B?TFdyS3oxTkdKcWdxZ0tGVjBIa1ZyMnFrS0dvVSs5RVZHbkI3dFdSdzFRZUMw?=
 =?utf-8?B?cFJuSjE1RzhaMVZWWFFUV3E4cGlYK2hDb3pzY1JJRnY5bFJQRHMvZUhBeVdN?=
 =?utf-8?B?NUlWTFJrR0dKdmtTQ3ZycEN1QkR1bkptY0dwcWxkWlZWSFZjN3EvckpkOHFO?=
 =?utf-8?B?K0pCSlMyejJVcDZOeVFmVXFYVjBJbWZSZndILzR3c0VNUlN4V3RGdmU4ekth?=
 =?utf-8?B?RS9iMWFFaXNxWlhKQmxkVzVCT3NGcG1vdGROaW8zM09ROHN2V29lUEJvS2Qx?=
 =?utf-8?B?K2w1dzAwU3owMWFLSGk4NzRMWHF5azdIeVBab0YxNlRrK2RyeDRtaEdLd2o3?=
 =?utf-8?B?TzJoOU5mRUR2NTZscDhwRWIwVEUyWXc5NE9HZGV4dW54R2p4bkZvRXQrdlJm?=
 =?utf-8?B?QWFsLzJlSko3MFZSaElaZ2RBMDB1Tjg3V2xMd2JrUlVxUlRIWTMvR3ZJSU8v?=
 =?utf-8?B?SjQ1ejFnL1ZDYVpvcEhkNGExSnBBQ3g0T3lXTG0rQWc1TSs1Mjg1YnNhcWpj?=
 =?utf-8?B?aW9GYUVjU0I2MUYvbWcxYkpmM1FPT0pZR01NTC9TR25QS2pxcjVTb1dJQjRO?=
 =?utf-8?B?dXF5RFhjUWJUZzRwbGwvWDd3MisyZkpPdGJELzdjQ2xNQUR2Zkc3TlRlZy9x?=
 =?utf-8?B?NVhmTUlrMHlZTVFHc0RFa1lEUGlxdDJQZVhjYzlPZCt3UHFpTGNEb1hhbnAw?=
 =?utf-8?B?eXRTWEx4c0RYYlRLZjBQeWdiTlBXTkdaTmpvbFdIR1ovOGpXNDZTKzBrVHI2?=
 =?utf-8?B?QzNQTDErR0VhMEhBWHZNQXByakdyNnNhOC90OXNoTTFwbmNTMjdsLys2M3FR?=
 =?utf-8?B?cC9mZkg3cll5NmF0QlpHWGxoeWhsc3VycjBpaVBzN1N4U0tjdjNkZzlkdGU5?=
 =?utf-8?B?bHpQWklZeHhBUVIyck1Ldkp1aU5jVTM0eTE3T3FMa0F2SnRYM3hHS091Y1ZZ?=
 =?utf-8?B?T2QvaWtEcmxmQVUranFNanJCTHpHc09OdjgwT1RZcnJZRnBSZ2FCUTdLY2JE?=
 =?utf-8?B?SXQ1b3dDSGh6S0V3YTZ3TFl6SzdILytLTmRYRzV6Qk1KSXpHNTZ2bUNQOTN3?=
 =?utf-8?B?Y0owRzlsL2FVR3Jucjk3aXo0ODU0WHowT3FBM1NmQTBTLzgvbGJudWFPQjB2?=
 =?utf-8?B?YmhkMExzSythbEFHZ0I4SHJjeW92ZnZ6K3FUdVJzSkpVQ0hFY2djUGZYUi94?=
 =?utf-8?B?QkE3dzh1d2xiZldNa1FaYTEvWEpBRlJtTWI3QTVtcTFjclVrb05aV1BJZWVr?=
 =?utf-8?B?dmFzelk4Z3pSa3FFTU9sbEVDTVdsd0NLQnA3WVgxUDA5SjJNckdjUjM2VS9O?=
 =?utf-8?B?NmRoQkR5djRBSTExclgvcWo5dmJ5ZnNlL2xLNnFoQ09Yc1ZieExVUExEUTYw?=
 =?utf-8?B?S1cyNnF2VXNva0ppRU50MkwxUTl2ZmV2Tks2U1Z2b0t2SmtKNEZTOENIWU1G?=
 =?utf-8?B?T3dyaTVsekkxVG5DRm54RmhWT1VFKzNFVUlteHNsYTBzM05CbzF4MEtkWXNQ?=
 =?utf-8?B?TnpsN285Rmk1dVBubzBscDB5VjVOTVpRSktkQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tjc2eFB3VnNTclJvSVFBWkZUWWlFUnFxU1NiUE1IbGtuWWdiU1hCalpoUHhh?=
 =?utf-8?B?WkdqZDRuL3QrUWk3Rk02WlVUNFdHNHRjRThHNG1iOTBzenIxUy8xeVNHY1BE?=
 =?utf-8?B?Ny9kd245VzU4bmVkQ21DNk8yeWpldURoMFh3cnFVaGZNdFpIZ09WUE00enRH?=
 =?utf-8?B?UTJKNG5HcVB2Z2FYSDVlOE9ybVAydUtLa1FSbVptc0dabXJLWCt3SWdsTnZZ?=
 =?utf-8?B?WDYzTzdNZTBVYnFzemZ6TGRzcC9BY28yMUtYb1p6SmRoc2ZzZlVNQlo4UUpr?=
 =?utf-8?B?dUI1ZythZ3EreCthU2J3SnlhMWhiSTIxU2x2Lzd3WElSb05EKzYrUkVIZHlI?=
 =?utf-8?B?T0t4clhRNDQ0KzA1TEVPV20wT2RFN2RJdDd2U08wVmpjcHM3YkR1cHZtU2hR?=
 =?utf-8?B?cWtwYXJqNjZwOHp2ZEE0ckY1c2RGcTlyLzBScHBMWktBaXpNdC9uQlJVaW92?=
 =?utf-8?B?bitHSkcvb3lTN0oxbzQwK2ZwWkl5bkdDNUdZb1kvWG5ESGhLWXFoWjVDb0lE?=
 =?utf-8?B?amV4eDRGUU5ONWVKTTdISVEwYmZFU2NwUlh0S0ZmV0tURGZCbUxkTmd2ZmtT?=
 =?utf-8?B?cm9WNGczUXZNUUMyZ1Ura2hWSWNPZ2FjRUFqU0hxWGtjWlIxN3o4dCt4NU5S?=
 =?utf-8?B?M09tWjM4MGZQT3ZiREZ0VDNCbWlTcTF5YmdsY0RqMWpmdWpyejV2OE8wQjEv?=
 =?utf-8?B?cmkydzJBRWhwcExBa0ozSnVLZEFSOVF1ZHRjbWw5RmNTT3pYc3FYOEhPaE5V?=
 =?utf-8?B?N0RBdGc4SG92OE1TVUJJdEtJdVdTMmcrU1hYaUdNdjkzczdobWNUZTJrZWo2?=
 =?utf-8?B?L3A1UHdXeVlCRHdBTE5ydEUvdVc2RUV1VEI5TkNJYU9RMDVnWHhTZEZkVitJ?=
 =?utf-8?B?dWlRajMrRmRySzhnRkFRWit6NXNvM2hlZkVUU2k2eExjUHNvQjZ4RDUwWFN5?=
 =?utf-8?B?YTMwbE9VR21Lam5lc3RPZWlFSHJXNlVmYmJWU0lZSTdoTC8zTjdzYjRRSTZY?=
 =?utf-8?B?VFZxVnN6WnFVdWExa3k0d29VaHJTQldreG9Cc2tPNklzWWRpZVlzYThiODJR?=
 =?utf-8?B?eXI5NkF4S29iODh3dGZiRXVHVnI5YlhFTHNUblNvai9teXBVbGF5ME83N2lv?=
 =?utf-8?B?bnpmNkMxUGdkeXZVcy9QWjhpU2dUcysrQjZoMktncWRBcXlGbExIUTQ1eXBF?=
 =?utf-8?B?eUI0c2FTT1phb2hZNCt5K2JxRFBKTDVKYjBNTWJReXY3UGpRaDM2QU0xU0tM?=
 =?utf-8?B?OHc5V2QwbmJIekQ1R0x2RDdjQVlMUDJaWWdXY1FEKzEvWEh5SjVVVEtocGk5?=
 =?utf-8?B?RmxXVDgrT0x6Q0RvdFQ2YWRmOEVieWUySFZ2WWNjc2xTZEZBbVhEZ3VQRU11?=
 =?utf-8?B?SFZlTnhSSHR6QTBiY2hVR2Q2dmdRd1pIMFduRkNweE9SbEkzQjZlbHFYZzQw?=
 =?utf-8?B?TEt2VTRsaW5KS0szZFJOVEpzb29iWXlDQzUyRVl0SUhndXJmZEo1SVpWRFdl?=
 =?utf-8?B?Y1dmR2doQ3VsdGxHVk1CeDZjYjlLOEhLZkJkOEIrelh1WXVBZGd3ZGlZSVNB?=
 =?utf-8?B?ZUtUV1JzL21UdzI2K0Y4dnphZW8xQitKY2Q0aHpDM0JBSk1pamNPN1NlSzBO?=
 =?utf-8?B?L0VBU0x6dWN6SlRqWXZsTmt0dmNNWk00MkxiS0JCZk9NZ2FXTGpNei9oNkUr?=
 =?utf-8?B?TG1oK0F1UWJGa1NyLzczY25zYnkvUUY4clNoV3BuNk83Y1Y4SmYwaG9HK1Zh?=
 =?utf-8?B?QmZpaTZsbG9jdHplOGxpeUU3ZVEvM2pmb2VURjYrUjBoMUhoVHdGN3hzTnRR?=
 =?utf-8?B?eTRiQnRpcitxWnJwaVR2UFYwblRjMHVjaGFvVzJrQWRJeWFtUU9VVVBwUHo3?=
 =?utf-8?B?Mm9EZGJDREtnbFNRaUloRUV5UnF2aGNoTGpDakRiN1k0TnpHSzZKOUt2di9J?=
 =?utf-8?B?eEJtUHJMUzNyYzhjbXptZlNESjFzOWFaNk5HYmVYUVlhOTdibEtUMFRzVGxr?=
 =?utf-8?B?WDZycENrUm4rMXVyR2tXV2FkQXJLYTh0UTArZTh3SWVSU0lmejlpQThjWm91?=
 =?utf-8?B?ZEtBNHhDTUp0SVZFNjJVVEJYd0NLL2E0QXh6T3J1cGJlczRMNGJqNDYwd3Ru?=
 =?utf-8?B?a29CSjFGeVZqOXlNUjdST0NDc1BOMnFBWGlBV2pIdE1mUll5UW1uQ2kxeXVo?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F486EA8CDAEEF44BF2400175148F26C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94060c34-226e-4ae2-22af-08de0d49d109
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 06:53:02.3950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBkva3rKIjW/+oyaCgVi3dLu8Rg6sHlLwDcKHbbWCvFNV06dKI4FYM8xt2trVWna7MH2axF9AxSLep6f/GpTxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9367

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE0OjA2ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFNNQyBjb21tYW5kcyB1c2VkIGJ5IG11bHRpcGxlIGRyaXZlcnMgbmVlZCB0byBsaXZl
IGluIGEgc2hhcmVkIGhlYWRlcg0KPiBmaWxlIHNvbWV3aGVyZSB0byBhdm9pZCBjb2RlIGR1cGxp
Y2F0aW9uLiBJbiBvcmRlciB0byByZXdvcmsgdGhlIE1QSFkNCj4gcmVzZXQgY29udHJvbCB0byBi
ZSBpbiB0aGUgcGh5LW10ay11ZnMuYyBkcml2ZXIsIGJvdGggdWZzLW1lZGlhdGVrDQo+IGFuZA0K
PiB0aGUgcGh5IGRyaXZlciBuZWVkIGFjY2VzcyB0byB0aGlzIGNvbW1hbmQuDQo+IA0KPiBNb3Zl
IGl0IHRvIG10a19zaXBfc3ZjLmgsIHdoZXJlIG90aGVyIHN1Y2ggY29tbWFuZCBkZWZpbml0aW9u
cw0KPiBhbHJlYWR5DQo+IGxpdmUuDQo+IA0KPiBSZXZpZXdlZC1ieTogQW5nZWxvR2lvYWNjaGlu
byBEZWwgUmVnbm8NCj4gPGFuZ2Vsb2dpb2FjY2hpbm8uZGVscmVnbm9AY29sbGFib3JhLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogTmljb2xhcyBGcmF0dGFyb2xpIDxuaWNvbGFzLmZyYXR0YXJvbGlA
Y29sbGFib3JhLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KDQoNCg==
