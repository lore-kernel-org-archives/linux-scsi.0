Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAE82D12EC;
	Tue, 16 Jun 2026 10:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606204; cv=fail; b=s5o/Xe/C75zngBqu/K+o+ZvCBDipjUIsKPEArcviy17PuYZ4ZouWAbrzK95A6tyBI3bnAhRPflXS6wZybSSf6W16Z27v4UktTUGd3NhU/EJbZr0XUMf6RuyPewIiSEkVRSzrNWmIk3rgKEJb0FcImSZbtZc6skqPksC/HbFLTfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606204; c=relaxed/simple;
	bh=IsQ7L4AZVK5Y8hmiabX4WsMHaO+UV2+BDqFs4hlJYY8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s3X28jKVn13bKAp8BmC7orOyV65y9NBHoJYVAGZdy1vgA31RyJKaUICqME8YUjZlwa4bvY4Km6WGc90KZhKl4PHzRiUJm/C8eEAjoKa97gt9oSo6YWtlS0PsSjUPC068OZkJX1cYlnOYRQsr4lVYjDOyXJ+OvfU0Nv1lTuV5+To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GpAoxdnH; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=HAbSceJ8; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GpAoxdnH";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="HAbSceJ8"
X-UUID: 41bf4016696f11f18dc8c9802ae25ab1-20260616
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=IsQ7L4AZVK5Y8hmiabX4WsMHaO+UV2+BDqFs4hlJYY8=;
	b=GpAoxdnHyHyYK67e348JxBNoh8Z/9GcW+gqTCmflP2eUAghM6xHCpGh8ZvpWNwChNvRdz+nOp7VwxwO6jChHflhiVntWnWs/KAByuShj2n6YUoFy+kGlo1ccDrKF+1pOW0KU8Q2cQibsWJxQyt7zCxSwo+P/NQLeoDaybIrD4vA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:fa738ae4-ddfc-46d2-a26c-5d43a0367fc7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:16272b5f-e8d6-486f-848f-3ae1d0432240,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 41bf4016696f11f18dc8c9802ae25ab1-20260616
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 966705249; Tue, 16 Jun 2026 18:36:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Jun 2026 18:36:37 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 16 Jun 2026 18:36:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izDMkMPMqt/WBwwBy4q0EGkyaORmy3xMyAtTH+NkuGTyccpbNxf2qepdcW/QUme8ap9YTMXsvg9gfcKoZqZkdr6s9xaGePCtJOAu++yxBo/5AaL3xM6+tBcaxJf58Dslv80Rpu0LAyEeYRnRt6pXUbNlGYAbLflU51SxZrA4+0EKE5W6/VWs7D7AAvVi/GDb8gZlSQaTRHTCQXAQ47ebw7nDr/Gt+St/G4AQ2f+vb2nnDzoQuTWa7RgM2YfpKku1FsO901c7Qet4Id+SsmgOBzFXlp8DMZz10WTfhhihunOqr5nAVbpv9smW797UTvGAhmGsjkglJxgHWLXfqZjcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsQ7L4AZVK5Y8hmiabX4WsMHaO+UV2+BDqFs4hlJYY8=;
 b=lds+tYYIItW+1ylH8j9CnEwJuMD3jUx1RlJU67UaWiMHGCmYRBAhOVcV2a+psBZhRs1a6SvNmbjS4yYhxwEOBSScWKb4oJcsvc+3ftBcoNMw+44zKdXoFNN9Lqq3zEWUwzVe7NJguaUAcbFzfPvqTIJftX+7f3z2yac+sf1nSjDgqjcRHN+BgAEa12U2PXW8zBRbN/66A2Tu+N7aUkSogGEOABhzp6QbMf1GZzXv4f9AS8C7+Ietg17pRYu+9RC+dDwwPntmgWTsvceDLmaKKMus8O0gLBnwkzIB7mtl4/bTuDKa8r6FEO1ehcFZAmZdpKwgA0Zh47WR0r3Yb4Ntlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsQ7L4AZVK5Y8hmiabX4WsMHaO+UV2+BDqFs4hlJYY8=;
 b=HAbSceJ8HTNp1/b9mJtqt/mGHoR9JxglXOvTwzsMlaUS0n28s0z1j/NJYlqwgo8cTeI6WzBavZB2Q3GnhnCrOaXFhEN/gnixhKnS9d4hJn7zje00MPcSt4ZJWrp/V3NQDC6/pde0sJE3OFUfcTttAAS8bRSfGkwq2Hxq1ggzVZk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUYPR03MB10553.apcprd03.prod.outlook.com (2603:1096:d10:78::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Tue, 16 Jun
 2026 10:36:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0113.013; Tue, 16 Jun 2026
 10:36:35 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "krzk@kernel.org"
	<krzk@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "zhml@posteo.com"
	<zhml@posteo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"robh@kernel.org" <robh@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>
Subject: Re: [PATCH v9 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Thread-Topic: [PATCH v9 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Thread-Index: AQHc/Mr5YAtsXdWJXUu3fMP9ufH277ZA/msA
Date: Tue, 16 Jun 2026 10:36:35 +0000
Message-ID: <965a4faf2f4e3a0731988765aa32c97d757d75e1.camel@mediatek.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
	 <20260615132834.2985346-2-can.guo@oss.qualcomm.com>
In-Reply-To: <20260615132834.2985346-2-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUYPR03MB10553:EE_
x-ms-office365-filtering-correlation-id: 2c72f316-c087-45bd-6ec6-08decb9323b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|38070700021|18002099003|22082099003|56012099006|11063799006|4143699003;
x-microsoft-antispam-message-info: ldbSQZ80E+uV5JmcT511BlseZy3gcVej/zoAax02XCelUdOWHDFOF/LJwCp3v2RHZfrLcueRPEVCrcYpqyLc0rj/6eX+6gG9PaHTU+jeUlwbcUM0UBgH+6LUlfj+TlkQAU1r9fOUjfH0fmP3Nz3/pUJW7fYRTuBtEJI1hYSfUz4DfUuCuUvCd9MffNP0B0PHJt5o2JXPaZXKg6BNxfl5Bmw/knBym+JSwju+s08GwxYxh9INktUHODs16EwmhuoJh3tTMVVjZKge+69G5u4EeV445a6lneDB9jdJ6cn/5cIdKKaN5KEMXfcDLmI+5dYxkICPMZ1GGIeV7tCQ5iRB+Cn6pcr3VwoAcb24E4dyvpA8oWNdakCIiyQEjRLoT6mtxoagoL209baRwJV+kq3x0jq5u4iaiVyFLD7gaHbStiW6zRnOnXaB6QqUSgv8RQTbS7vRvw51eRYRIn2wX/Id8dDnMghjT9WSHmJ1mPU0CXTVIz7xk4fPw4heRLC+3OHU6yJgAJ2sEUsHwxGFDqtUZzv++146IsGX8Fwvc36bcNqskhwe7zIdkIOHUTPipukSZuv8mE56daaP171/CmVhGYMvxIF8mmCK+lsIWg/A5HEU4/jgheEg15BWHivb93RH4LBQ2K0cX/tp0RbWvQ6PXMdA6ewI24H4/ui6J5BOSbgIa4+cg3Qj/1QUMWEsem5OWHimy4/IFZp+6JSS5MKDC23HJc9LML6gvPrR2oxERUA79Qy756J03hDIuS1dvwfP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(38070700021)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVB0dFBpamVWdHBlUGo2RE9GWng0aERSdUZmaXl2dVJwemRZRWZtSGphUlZY?=
 =?utf-8?B?ZGtaeXFSeFlMUTRPUzVXWDlBREtNYWxVak8vcnhZVjQrSmlvWEhFcE5ITzhV?=
 =?utf-8?B?QWZIK2NtSDlaanI2YjRSUHg4THhBc09KUlhmdFhoQnNWN3U1NFVRNHlsVzdH?=
 =?utf-8?B?Rmx0M2Z6VFVTQ3VRRGs3SkNTdUZGdURSejBqbW1ZTXpXdUJMVlg2bE5wcGg0?=
 =?utf-8?B?VWYzYjhvZ2xaeFc5dTlUOTlSZ2pFenhKcllLMDZyN1NOVzVxZE1TR3JQSmw1?=
 =?utf-8?B?NnFMdzZadUQ5VXVORGlMaFNDZEJKWWtkaU01T3JqeFowS3JPNGVKUG1vY2ZY?=
 =?utf-8?B?MTVKbFdTT3hvbzA1THpjMG5ybUNSakpPd09RSUt3cE5mcU5UQ0VESUtUYUFw?=
 =?utf-8?B?N1ZqREFVemt6VmpCeEJTcEhWYUlqWDh6ZFV6dUNYVTY1NDdDbU5BZXVJam5q?=
 =?utf-8?B?bTdJWjNFUkxJUjZjblJZSlMxQ3NPQjZrZlpLNzBJTWxDOGR0Y29YREpEVzNK?=
 =?utf-8?B?akVEcXJaZ0JEenQ3ZTRURVI5b0w1YmZ4UllJQVlxVmZ0WmQrTy9UQTdtYTNZ?=
 =?utf-8?B?dFhuQmhiSW1JYXgwVUJjdXhMU0dqWGI3TmpuTmNnaWZ3T3NVTnJhMjJiN1lE?=
 =?utf-8?B?U213ZGRDa2kvNC9FWHNrTFM5YTlBRk8zbGtQVjdSSkduRmp6dVRWQUdtckJt?=
 =?utf-8?B?NW5rbnFVSndCaEtJb1ppQXJOdGp0OXd5MUk1ZE1RUFJYWHlZYlBtZURYT3Zv?=
 =?utf-8?B?UTc1VFhQdUc3WHJ1N3F4eko1REFVZkhiTGVyVEV6VmxIK01QMEZxdzlKR0xl?=
 =?utf-8?B?NmlQcFRtazAzOUFENVZHSUVxeFpRTzQxbk45bjlCVzRMdDRVaS9IWXdzSmZh?=
 =?utf-8?B?a1NxNzY5amZqU1ZYeW5KckdMRjN1SzRtM0ROd3FOV2JoRnhWQVc4eE9JODB6?=
 =?utf-8?B?cG5rM1N1a1M0dGcrOTRoaytkbXl3bFIrR3RzY0NhN21KRnRKaWE4Ym93bVBT?=
 =?utf-8?B?bDA2UWJQaVAvb1VZaFBKZ2t1dFBhVkxaZ3puYm1xcEMxQ1N5NEJtTitWSnRh?=
 =?utf-8?B?emZIdy90ZjJVYzBGRENLcWQxWUcwRGRST2Nod3FXMm1ZTUdUWEVNZU1xOXVZ?=
 =?utf-8?B?NmxUVWZab1JvZTZPeE5hcnFqb1Z1ait1WGlGRzFER1VOc2pnOEhldnFMUHFk?=
 =?utf-8?B?RFN6VmhRNE5YVFphSzdTRUtPZ3I2ZHprRXg5elNNWXpieU4xYklhYk9YMjZn?=
 =?utf-8?B?Ty9zS211aGh5b2U2bDdUNjlHK3RNc1RGeGFBZUNpWHk2ODF2Rm1PNkFZcm9x?=
 =?utf-8?B?NzA5RTY4NTlLaXJMbnBCOHBURXBMSTJad2JBcGpaQVFQZjRkalVVU1lqZmQv?=
 =?utf-8?B?dVFBY2lGMFBvQitZYS9mazNsVFIzVlJJVm5xczVvVXBkL1MwRWJFWTRxMjhD?=
 =?utf-8?B?WkpZbk8ycUIrTHpjcllsejBtOEcvd3BoVGNKK0k1K1Ezb2xvUzNPRm1Mdm82?=
 =?utf-8?B?d2RjeXdQM2dKUkVMWFBSbXNXWFBRRUVsSmtHQ0xoQjNOUnZhd21GNGJrUWQy?=
 =?utf-8?B?Vk9tbEIvcXVaVEttTFBvcHFkZzgyR3daUGNRUEpxa3IwcGs4RGp0WjJxeEJ0?=
 =?utf-8?B?K0RCeGtsUzFhY2psRTlsaUsxS3lzNUJTZXlQckowRjMzTlhmVVJvcTRDSDZZ?=
 =?utf-8?B?Nm8yVkNpYkNabVRqcUFIUmxXSDdkdzNBdHA1SjRtS3VUZ0Q1TWllVlRwR21Y?=
 =?utf-8?B?TjJFRFI1SGRERnEzRnQ4UVdIWUwxc2Rhalp2bktYVjR5bTJOb1RNd1RpV1do?=
 =?utf-8?B?VXFCSXhOVkkvSkZxRXFwbDFSY044MkVjbDloU1h6NXZCaUdWeG9UWS9oUk1G?=
 =?utf-8?B?V29vbzM0RHFidEdpbGlLRFpQRzIrTnpzcDR1OHJrSmJYZ25McnJjWjg5Q2Ez?=
 =?utf-8?B?eEJJc3k4SjZkMUwrNDlJZXY0b0ViZTlFbERYeC9YVldCcVg1anc3ZENKalpP?=
 =?utf-8?B?aWVna1FRZ2daWmpaMGFXaHpMb3NRZHVQUHJnT2NTRWJlMHhDaHJNakFoYytq?=
 =?utf-8?B?U2JSSVVVem1qNUhzdFl5MHZkUWtJTFBGck9WRkwrakdWbFE0UUIyWXZoQzhY?=
 =?utf-8?B?Y28rMzl4eTJSSjMyYk5ZSm5yQkpTT282WmZFeWcrS1Y3Q3pkcEhXQWVBNWRM?=
 =?utf-8?B?aXFEYnJrbkF4cVlrUCtoMGZXMUMrL3lzSUExSVBuVGtoZkFLL3k2WTRNS3pi?=
 =?utf-8?B?b3BOU3cyNDd2NFlmUDNHRXJDR1ozV2NzQU1mTmtyOGxyNnk2am8yNGxzeXp2?=
 =?utf-8?B?Qjl3TS94elZObnlpbGtFMlQzNHNLczRGL213alY2MVBIMmZ5VlBhb2tubk50?=
 =?utf-8?Q?wdYPbJyWyjKw7RMo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E90B7E433CAB0E4A9A4D99CFE5343DC3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: V4qMT1AdXgJYwLYjqIbBcbiHv1B9abcukv9fA6n4bpNJ4C/rRo6aQHiV1N9HQ6jsnCggW9wiUAAxxKsyDEnyRPZAaG+rBnZSc9IMbU4eQMtIs6flpEj0tJTVPpDhDAjB5DX++XJrHRACqGOmFN4miOmOUL6fwX2rKJJ8B5K4XBuEsIRtAewL/5CZ3egUkSqClCQEOoZ4fYX1vrEMgXjGEGRit2VAVRsqfUkYqena9D7QCmZIlPPo3T2YF9MKo9tyo+k9YNhyEoDRDCury8AL5+6KFLGL+EBGhFNzrOPZZD6cXM9sX8bJcgcn0pSAS5g3rW/opmwoLIc0tPdTidU1iQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c72f316-c087-45bd-6ec6-08decb9323b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2026 10:36:35.1695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2KgXBNciedzvURaP2cJXsVJpPE1AF2gHSJQ3ZU8hfktlB47iNYbfX43ezgT5H379ekl6OoqeUX9x2wNeD+vs2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR03MB10553
X-MTK: N

T24gTW9uLCAyMDI2LTA2LTE1IGF0IDA2OjI4IC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBVRlMg
djUuMC9VRlNIQ0kgdjUuMCBhZGRzIEhTLUc2IHN1cHBvcnQgKDQ2LjYgR2Jwcy9sYW5lKSB2aWEg
VW5pUHJvDQo+IHYzLjAgYW5kIE0tUEhZIHY2LjAuIFRoZXNlIHNwZWNzIGRlZmluZSBUWCBFcXVh
bGl6YXRpb24gZm9yIGFsbA0KPiBIaWdoLVNwZWVkIEdlYXJzIChub3Qgb25seSBIUy1HNikgdG8g
Y29tcGVuc2F0ZSBjaGFubmVsIGxvc3MgYW5kDQo+IGltcHJvdmUgc2lnbmFsIGludGVncml0eSBh
dCBoaWdoIHNwZWVkLg0KPiANCj4gRm9yIEhTLUc2LCBNLVBIWSB1c2VzIFBBTTQgMWIxYiBsaW5l
IGNvZGluZy4gUHJlLUNvZGluZyBtYXkgYWxzbyBiZQ0KPiByZXF1aXJlZCBkZXBlbmRpbmcgb24g
Y2hhbm5lbCBjaGFyYWN0ZXJpc3RpY3MuDQo+IA0KPiBEb2N1bWVudCB2ZW5kb3ItbmV1dHJhbCBw
cm9wZXJ0aWVzIGluIHVmcy1jb21tb24ueWFtbDoNCj4gLSB0eGVxLXByZXNob290LWdbMS02XQ0K
PiAtIHR4ZXEtZGVlbXBoYXNpcy1nWzEtNl0NCj4gLSB0eC1wcmVjb2RlLWVuYWJsZS1nNg0KPiAN
Cj4gVmFsdWVzIGFyZSBwZXItbGFuZSBIb3N0L0RldmljZSB0dXBsZXMgKDIgdmFsdWVzIGZvciB4
MSwgNCB2YWx1ZXMgZm9yDQo+IHgyKS4gUHJlU2hvb3QvRGVFbXBoYXNpcyByYW5nZSBmcm9tIDAu
LjcsIGFuZCBQcmVjb2RlIGlzIDAvMS4NCj4gDQo+IFRoZXNlIGFyZSBib2FyZC1zcGVjaWZpYyBz
aWduYWwtaW50ZWdyaXR5IHR1bmluZyB2YWx1ZXMuIFRoZXkgZGVwZW5kDQo+IG9uDQo+IGNoYW5u
ZWwgU0kvUEhZIGNoYXJhY3Rlcml6YXRpb24gYW5kIHZhbGlkYXRpb24gKGhvc3QgUEhZLCBkZXZp
Y2UgUEhZLA0KPiBwYWNrYWdlLCBhbmQgYm9hcmQgcm91dGluZyksIGFuZCBhcmUgZGV0ZXJtaW5l
ZCBieSBIVy9QSFkgZGVzaWduZXJzLg0KPiANCj4gQWx0aG91Z2ggVUZTSENJIHY1LjAgc3VwcG9y
dHMgVFggRXF1YWxpemF0aW9uIFRyYWluaW5nIHZpYSBVbmlQcm8NCj4gdjMuMCwNCj4gd2hpY2gg
YWxsb3dzIGhvc3Qgc29mdHdhcmUgdG8gZGV0ZXJtaW5lIG9wdGltYWwgVFggRXF1YWxpemF0aW9u
IGF0DQo+IHJ1bnRpbWUsIHN0YXRpYyBib2FyZC1zcGVjaWZpYyBUWCBFcXVhbGl6YXRpb24gc2V0
dGluZ3MgaW4gdGhlIERldmljZQ0KPiBUcmVlIGFyZSBzdGlsbCBuZWNlc3NhcnkgYmVjYXVzZToN
Cj4gLSBUWCBFcXVhbGl6YXRpb24gVHJhaW5pbmcgaXMgbm90IHN1cHBvcnRlZCBmb3IgSFMtRzMg
YW5kIGJlbG93DQo+IC0gVFggRXF1YWxpemF0aW9uIFRyYWluaW5nIGlzIGRpc2FibGVkIG9uIHNv
bWUgcGxhdGZvcm1zDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW4uZ3VvQG9zcy5x
dWFsY29tbS5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20+DQoNCg==
