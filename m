Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB633139E
	for <linux-scsi@vger.kernel.org>; Mon, 25 Dec 2023 07:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cKn4frlf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="TaNhoA6b"
X-UUID: 1c23c1e8a2f611eeba30773df0976c77-20231225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=oBSMWLoJ64PHdO2m4LnMi8mTraFEZGzUSUwf9KfQLKc=;
	b=cKn4frlff3FdFeA+aHqcL8+jDytX8YEiCwM+58nUR4FRyP43lOlXOtgD71zaDm2fvQvSnwSCrmKgyfN3jMfTrc20iw+74H3AdkOWZ5wV5gtQi6zRYTPlPHC8FyiYHzWG5mj6dysVBu+PQzXG3WDeGs/dV6Ar3yH/HaLrPWrhCm8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:2bbb4142-844e-4668-8af7-98e2d9383b8c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:3803a37e-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 1c23c1e8a2f611eeba30773df0976c77-20231225
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 164656395; Mon, 25 Dec 2023 15:20:41 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 25 Dec 2023 15:20:40 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 25 Dec 2023 15:20:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Smg1i/61CtBhyZtPizEWLHuClpGEgX0T/0+mNjhhnICnzNGCJzGxj48W//W1B4utJvcigq4cC3o7QhFIAKBx7tAMfpDywDTt7mc8agqIVm0b5Q0Kg+orcVzZGmtSGqeX6QFPYDd49p/D+0SjtLm/W63ZvyYsLYfO9lFAHi57kpgbuFomM8kP7IRthuOmzGYP9ErfAXpttEQ4OxAjtkhLqzGFjWmTuQmY5p88Z9g+L2ngOHLLxlp+4yZliZL5tQ5TaNr95gprnn6jNFpZ7NjTZgwO8GFZ6hwztzwzIutqWB4KvFGvHqU3tz91yFM8ZPAS6IXSiy9u1+fAvm6RFnxWBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBSMWLoJ64PHdO2m4LnMi8mTraFEZGzUSUwf9KfQLKc=;
 b=O/D/NKl5pppnGRn8eB/77r4kPPfqaNqUDnH6J03TM4Ku0rm1VZ4OixvuhbBHc/3XBYHggbz+8T1AhPAJC7XDZ8U6U48t6ezWbtQs6OgHqdAeRIq8JRKXFkg7iuNg+6jJ2mrmxMs7VaLFy03g1J0yp6FCkG1TF1/VFdsO0P7r2JLtPiRAgemyQ8jExC+ux7W+63lBTHHnV5y+VK4gaX1S4MB1TH9cNU/phN/nrM+WCe4C9saEuZLttcy6gOBSpG5hSuT9Zx3IgUZSUFHkV5t98Q0AhurwhGAXmBliWuGFk2HY23x88NEzoyRNNTrP8tt/L04UUw6hNwxOQDyLlAGeUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBSMWLoJ64PHdO2m4LnMi8mTraFEZGzUSUwf9KfQLKc=;
 b=TaNhoA6bjVSEF9hSCKGAFpaxvub7yHcU59WBxmwmU0qo3FoFAHwnKsCkhIIlaJP1kDcWSk5Cbl/z91+EKdUQ04XuTe03dB0mWLzvj10K0jtFRfF6Vo/5vbkqnAAQyEdKVxYovYJD6Llq85E0BHe3MZ7CedImXNb4xMolFhiAXA4=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by PSAPR03MB5669.apcprd03.prod.outlook.com (2603:1096:301:85::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 07:20:38 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::f561:7963:686d:b2ed]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::f561:7963:686d:b2ed%2]) with mapi id 15.20.7113.022; Mon, 25 Dec 2023
 07:20:38 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?=
	<peter.wang@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 2/3] ufs: host: mediatek: fix mcq mode tm cmd timeout
Thread-Topic: [PATCH v1 2/3] ufs: host: mediatek: fix mcq mode tm cmd timeout
Thread-Index: AQHaM/2XenKbDKTIb0aeGm3OuxSC7bC5nbwA
Date: Mon, 25 Dec 2023 07:20:38 +0000
Message-ID: <6a7ec616c48e45702750efbd62bb48ef946ce1bb.camel@mediatek.com>
References: <20231221110416.16176-1-peter.wang@mediatek.com>
	 <20231221110416.16176-3-peter.wang@mediatek.com>
In-Reply-To: <20231221110416.16176-3-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|PSAPR03MB5669:EE_
x-ms-office365-filtering-correlation-id: 2189382c-7b45-4f91-f36b-08dc0519feca
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hXeYMmt/6bYePSldk32jvAbZv7s5HPZlc8nHJJ1NnILN7MzgWxq3tLF+JiIxrpSIhkUJNeyGZX0XBN+1qpjYEINa8FP5Ao1NLRrf8FprJpxGGlAAibuipHfgrbaVYpMDEXgjL7LfuRpNlryckDd+PTGkiWHG36gg0iCz5HG28//fhRSx7Ah6GC6LDbtqHB6vNna1FGuCp9eT9mEVMh7FbL08d08swhoXw3o9rKlT8JrPbNPNhcqadXYpioWtUf3pauAU52syapJQLy6vkrr8dtVuieVYZYmYSH9328VgBDOMzI/CoIyNsuE0N9kjQUfvHvuotWJmZJEAYbU+Ja3s1vAtic+q9s7uF6K4qyq8gZUhPxDmuXemOcVSpCW3gArbAAihYgUZYgkA4R0MWAYaD7y+iTm9ZraMnHt6btVFURN24V3dcJHmoOX8G30dc7nOpZQAFUivowQcOBzlt+wBYwssI5FhVa0fEnsrAbIaUiTZD9FtK5kgI+BSxBEnnvq0F5m7boTPe5xM3X2A3SgWimuFzuPPtRK7uLR6K+zPlzr9x0PbiJZTjrnWSbwZyqYHbthcVjm9CxL5xU+qKs0lRMiyVQxTdcfk3rhCBD4K8DHHVQQyAQZ0EMLlZ2w5Io4UVqMogGXJhh4WPHQekvB33sJW40gWvqBHPsOHz3eYVsE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(346002)(376002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(5660300002)(2906002)(4001150100001)(6486002)(478600001)(110136005)(2616005)(6512007)(6506007)(71200400001)(26005)(107886003)(38100700002)(85182001)(86362001)(76116006)(66556008)(66446008)(66476007)(66946007)(8936002)(316002)(54906003)(64756008)(4326008)(8676002)(36756003)(41300700001)(122000001)(83380400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWc4aWl2VGdoSmd5dFhSbXVsbEoxY0lSY1hieEtGVmFvaFBJdDNQcnVpZktM?=
 =?utf-8?B?ZVJTekdNNHlZdnp5UjR3SVJyN21NRkIvZWhOanB6NWs2UUJxeGc0dWJlYkN1?=
 =?utf-8?B?Wkk3WlhyKzBwRWE1Uzdla3NBdmdidE1iNW9neUhnNnBUMU5hSy9OZmh1MzJm?=
 =?utf-8?B?UVJWY1EvNS95QktQa29ZZ2kyYVdJbTlycVFBMldGLyt3UHd6aThKVlRWVzY4?=
 =?utf-8?B?WVlLZ2E5UWdsekc2UGJoR1FUU2VGcjBYUUVVdEZucXFhaWRtSEhOdFl1d3Nm?=
 =?utf-8?B?NnlHbllVNFN5aWtEZEZsVTZyTUdvckVXU0lqUjdSeXVHL1ZlM0hsZHF6QUww?=
 =?utf-8?B?NEdlWWptendOeFVWWU9MNWVDOWJpYUN2enVYaXQwbWxadkZvR2RqK2ZQQjBL?=
 =?utf-8?B?VDZGM3k4bVBpYXBnSjJsSTFBeFlZLzhPS3Y0TWx6VDZydW9iUWFJcGFVWW82?=
 =?utf-8?B?UDFBbkY1U0pWS2hMYk5QS3QxVmtaV0g2S2dLUXNwbUxHSDBnczBPSWdJVlZE?=
 =?utf-8?B?UVRqOTRTQ29tWnpnQ0NTT1pzT0ZHdWwya0twcjc3VFFvZWhPNHJxeG1FMVdu?=
 =?utf-8?B?dGFEaXdjNmd2eFNSZE5BMzdxRXJKaGJmTEhDZmc0dkM0L3lvRC9Sc0hkMU5k?=
 =?utf-8?B?YjQ0WHBUWHJFVUJzNTRQZjlabWFZS096dUJLWCtVbzV1bTJRMFRsblk5bng1?=
 =?utf-8?B?bnJpV2Y1VEdxOWFOZmlBNWZZbnZWTDFEbU9RdUVnVHljK29pV3V1RWRKYUdX?=
 =?utf-8?B?RURpaVNNb29CeFdPSHZPYWFtdUdxbDBpSGF5Z0FzOHRTUFRlakovUWhjYitV?=
 =?utf-8?B?eHhCRFRWUk1BR1F6RmdlY0FPTnRuUDJkZjNTdElJZTd4STk4Z2xGSWFkK2dM?=
 =?utf-8?B?eExWRi9aaENwOTdUZytlR1pxS28wWUVJNi8vWTR4TmwrdjJYdmhqTVhKQWR2?=
 =?utf-8?B?MUp3RnJ5T0FLdFZ5Z0x4MjMreEkwRDNPL1l5NnpJblBtc1ZRMXF1a2Z0MTR3?=
 =?utf-8?B?UmNJd1gxemc1MmFKNnAvK3lWYjVBYjdXMDJoZnFSczl5SlhWaDJ6QkM3QkRz?=
 =?utf-8?B?ZGx2L2thYjBXTVlEWE10MEo3SEwvbFhtS2JIQWtjSE8wMVRZT1NUM3B1K01J?=
 =?utf-8?B?WkErNW42OVRwcGZBMnI3emdIRk5vYmFBQXNWdlptYmZpMFptRXdUS3RSYng3?=
 =?utf-8?B?VjR2N2RpZGkyeTVraUx4d0RmTGphSlpYRUUwVmxUeGtnNGpESHIrWjZCR3Jr?=
 =?utf-8?B?anpYOTdBSmJVcjM1RU9wdHB5Q0hZTDVneWFxelh3ODFpOVBTUHBzMURWaUVP?=
 =?utf-8?B?MldHc082ZjdMN2dSL1dtTDBBZldKc3BGK05hS3ZVZDh6UjNyTXpKS0g4MUZD?=
 =?utf-8?B?bWpRWHcrYzcwVXMzN3JhSllLZG1aT3YrOEVnSmZNN1hSRXdBSVJqQTdJU0du?=
 =?utf-8?B?R0RpZnlWbjFBemNOUWJ3K3ozQ3gwb2VTbmh5NDVuUTJYbXlIYUpmZ1paY1lY?=
 =?utf-8?B?MGJhdnNnU2lhZUJ5VTZvbHBOZ1hPSld2V2pDM0RMeVJRUEE5RGtwMTJ1SmZN?=
 =?utf-8?B?TmZqa0V6Qk5xSGU5QVNUenJrUUE2aW1QYno3aVlvMWhjeUh3allXQ2RBOHBX?=
 =?utf-8?B?bDJQZkxqZGk2YWRmRy83a0ZLL2M3UTAvQnlpTC9Xa3N4R3BSYis5blFSR2hL?=
 =?utf-8?B?QTFSbi9WTVk3ZkV1U00vQ1pzQjhOaGRBT05lZWRJcm9IQ3dzNm53dDZjTWJM?=
 =?utf-8?B?KzhqdU4xVFMwdGxFb2VmeGx1cXVKblpwbE04SHFQd2dUTTRTNlNDa2F0S3My?=
 =?utf-8?B?Z0NyZ3p3eXRFL2V4aWZ0TjhEcDh6dmRockhQaDFZZDJKMzNuNmQvVjNoYWcz?=
 =?utf-8?B?Vk5JKy83cjhEd1lydzNSMEtqQS96enVOcHZaWHIyTG9zMktCN3EzSXJscnRZ?=
 =?utf-8?B?NkNKbzlKRmZvVy9wanRSR2RSV0FhRnhUTmV5aERVbk90QTEzcnNKSm4yYXgz?=
 =?utf-8?B?L2NjNVJQeWFvQU0zWjNJVnBzYXM0Zi9wWGRWbm01SW8vdUUvLzVVQittMHBZ?=
 =?utf-8?B?UThKT3NLOXNyYlRrK2dDd3Z4WDMrRFZSUlVQT1RYaEZ6aGR3Q1NHalFCK2pJ?=
 =?utf-8?B?b3d0YkJLNDdpaFdXTExxelBKQzM5TDdDTjQwRlVUcVhHSTdiR2tvMUJodlhV?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A224889CD5F4FC4191BF8E5759FE5241@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2189382c-7b45-4f91-f36b-08dc0519feca
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2023 07:20:38.6727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5fAs/GeGNtqbIdYcK2yy2dIY9SiFSwu/O3YbSKIu0zhs1wSc+XyFvodNYP6ofFDLbAhKRBIZCH/kJ7+DerNI51/+H/Ss+CKtFfvlE98fHhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB5669
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.612100-8.000000
X-TMASE-MatchedRID: qEAy/z09Hq3UL3YCMmnG4oei/mZCYVwugDRlwc+wR6cNcckEPxfz2MWl
	hj9iHeVpD2EF2wJcjhcwTs1+Q8LFKCbhJjVR0U35bT3mGmWPpNdA8JZETQujwkdmDSBYfnJRBo3
	mUgBvvXNOFu8ssjxG86AIPQUyzd3ej+ikqJBaOpRjVtAwIy+afn0tCKdnhB58pTwPRvSoXL2y5/
	tFZu9S3Ku6xVHLhqfxwrbXMGDYqV8LH2qjGZLbHRAeVpNHtlMViP+xT1lg1YnQ9i/L4knmUvykk
	fefdlgL
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.612100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	958EDC4A1D375B1414ED67DF241699F32CA4280B3CCB9E0B38492F9D352551562000:8

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDE5OjA0ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBGaXggdG0gY21kIHRpbWVvdXQgaXNzdWUgaW4gbWNxIG1vZGUgYnkgZGVmYXVsdCByZXN1
bWUgY2FsbA0KPiB1ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWwgdG8gc2V0IHRtIGNtZCBkbWEg
YWRkcmVzcy4NCj4gVGhpcyBmbG93IHNhbWUgYXMgdWZzIGluaXQgbWFrZSBvcGVyYXRpb25hbCBh
ZnRlciBsaW5rIHN0YXJ0dXAgdGhlbg0KPiBzZXQgbWNxIHJlbGF0ZWQgcmVnaXN0ZXIgaWYgdXNl
IG1jcSBtb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0Bt
ZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8
IDExICsrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA2IGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlh
dGVrLmMgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCAxMDQz
NTRhNGQ4OTkuLmViMTkzNDEyNmM4NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91
ZnMtbWVkaWF0ZWsuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+
IEBAIC0xMjIwLDkgKzEyMjAsMTEgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0X2hwbShz
dHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgCX0NCj4gIAl1ZnNoY2Rfc2V0X2xpbmtfYWN0aXZl
KGhiYSk7DQo+ICANCj4gLQlpZiAoIWhiYS0+bWNxX2VuYWJsZWQpIHsNCj4gLQkJZXJyID0gdWZz
aGNkX21ha2VfaGJhX29wZXJhdGlvbmFsKGhiYSk7DQo+IC0JfSBlbHNlIHsNCj4gKwllcnIgPSB1
ZnNoY2RfbWFrZV9oYmFfb3BlcmF0aW9uYWwoaGJhKTsNCj4gKwlpZiAoZXJyKQ0KPiArCQlyZXR1
cm4gZXJyOw0KPiArDQo+ICsJaWYgKGlzX21jcV9lbmFibGVkKGhiYSkpIHsNCj4gIAkJdWZzX210
a19jb25maWdfbWNxKGhiYSwgZmFsc2UpOw0KPiAgCQl1ZnNoY2RfbWNxX21ha2VfcXVldWVzX29w
ZXJhdGlvbmFsKGhiYSk7DQo+ICAJCXVmc2hjZF9tY3FfY29uZmlnX21hYyhoYmEsIGhiYS0+bnV0
cnMpOw0KPiBAQCAtMTIzMSw5ICsxMjMzLDYgQEAgc3RhdGljIGludCB1ZnNfbXRrX2xpbmtfc2V0
X2hwbShzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhKQ0KPiAgCQkJICAgICAgUkVHX1VGU19NRU1fQ0ZH
KTsNCj4gIAl9DQo+ICANCj4gLQlpZiAoZXJyKQ0KPiAtCQlyZXR1cm4gZXJyOw0KPiAtDQo+ICAJ
cmV0dXJuIDA7DQo+ICB9DQo+ICANClJldmlld2VkLWJ5OiBDaHVuLUh1bmcgV3UgPGNodW4taHVu
Zy53dUBtZWRpYXRlay5jb20+DQoNCkNodW4tSHVuZw0K
