Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4B83EE1C1;
	Tue, 24 Mar 2026 11:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774353300; cv=fail; b=lvuNGkiEzKc7Z8TSQqyc17zF7l64oXOJ2Yqo70dc6viEupCq9w2yvmcAsgFZqf4GjRfVwFdvhJVY/CjjYPM8csS+i5oZd63/IxfO/rV+j1oB2mhIomSKAv1pmtV6tXWofQc/bj5cbEylXAKV6WFLyjtlSOSxSvLPDA3ssrFgRM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774353300; c=relaxed/simple;
	bh=EB7IGihqjyZQdbn0IrIxOzDBYnWRy1mPaQt6Z4faTYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=udnxJskRp4kS6SDslsh+MUOFT3WE4L9zm7A9uO+7ibiEEIqUweavnFZbILxSI9ocuaNU4Y5/8Yvblgy4SumbaJmDovnN5d30nfch9dkM+d5HgwTn0wYLFF05AsQXXwDlto8jN+N9a3nj0CqlZyVESQD3zasmE0A+dTwBA6X6CIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=H+Njd5qw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=P+n20RpJ; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="H+Njd5qw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="P+n20RpJ"
X-UUID: 43e4b24c277811f1a02d4725871ece0b-20260324
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=EB7IGihqjyZQdbn0IrIxOzDBYnWRy1mPaQt6Z4faTYg=;
	b=H+Njd5qwwpp5AA+V5uqB5/JtsWppYPFdJg1k2ccfxbgRaxqj09mG+2gEsL9D9LAOSOdwGol3pdnvhG8UK5tPHJbJZvRpEVZm2teXbKp099rDShNtMy6ZMcLvH/LB87tjcQqPVaNXnj2tNK2sdzrXM4RMWyZAtZryIAiZYg6S4zM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:100a2a76-75ae-41bc-9aab-4dd1992c562e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:e49665e0-cf51-4058-942d-ef4f058f9afa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 43e4b24c277811f1a02d4725871ece0b-20260324
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1909969265; Tue, 24 Mar 2026 19:54:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Mar 2026 19:54:50 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Mar 2026 19:54:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHfJSD8UmOu3ObHRsY32Muslg+Pu6ltW2VW9odhPz81cXwvYXZl9Sjit9DhAebrvDsu2s4WV/YZl/7G1vVWImeAAzNaFvZqF84rPOOow9HikBUHhUFW5WwLvgwpUvun2/qg7tQVbploFlp5+rElIV5aw0aZKwY79U05MAbbQxCHIYLO4IWvFQpdRNu5OIWV7lY0msVEbm74lt/iMfaY4HIwW/qtM1nr3Sxc7xvpYe32YtNgidAgIrxiB3UIf7atpj7912ypIxOjauLfbV4mOgvSB0f+TWD5g8z1NMcDgWMerTbxYYWd3iwQgWuLTsykoLACiXG/oQUTgxJOaCsnuvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB7IGihqjyZQdbn0IrIxOzDBYnWRy1mPaQt6Z4faTYg=;
 b=kszvbCiO+Urehg/NsJIiHb8rSajTE4dJktKuT87/TjTjXQfWZdgsnvaZ+pO6ylKReR/0VF3747tdwr7peZq3002nkDgzWDztEUmJCYCyQp6iyvp8VOah5eN7n7/1cy6bUshzz9AdNj7t1blmVJNnlHcW73PQ/oR1GxEjA/lpg7tvakWEYa17tQTnOYo7sjgpWH+XT9DzvLjXoQDiY1k95DxZYn5ktg13K0LtnEcv9b9NiWOfTL1sQwvoZ9g291Hs6iPpHOZjt1lzPsuVcJgJuUUgbUyrYf+hgd2b0PBJSd/hRC363AnKFOz8g55YkXkjZdKe3zGCwJIBs6EatVPuhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB7IGihqjyZQdbn0IrIxOzDBYnWRy1mPaQt6Z4faTYg=;
 b=P+n20RpJ0XQDtlV4G5s3hKQhe3z8klW5C1di+II9x58PbZJDiNVM7obKVKnJBynRSVSWcddEzhpOEBQychWjhW+tLdiOb96leXiQkKIH1309e3Ods5qybyvQ9w4qlgf3bbt+K4qY6f19CEO5DFCjPu1kHHyo76LOQHAYvAN11EM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8371.apcprd03.prod.outlook.com (2603:1096:405:70::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 11:54:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 11:54:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 04/12] scsi: ufs: core: Add support for TX Equalization
Thread-Topic: [PATCH v4 04/12] scsi: ufs: core: Add support for TX
 Equalization
Thread-Index: AQHcuODketpeGCnm9kK0h5TBPTGiD7W9UtiAgAAn8oCAAB12AA==
Date: Tue, 24 Mar 2026 11:54:46 +0000
Message-ID: <67dbc2869e68a29d5eed452f0db74acd2021c3e3.camel@mediatek.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
	 <bf904a137c1a3b8f6ec0dd712e15611155ce3e11.camel@mediatek.com>
	 <1a038159-c847-4e58-a60c-cd5ecabeeed9@oss.qualcomm.com>
In-Reply-To: <1a038159-c847-4e58-a60c-cd5ecabeeed9@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8371:EE_
x-ms-office365-filtering-correlation-id: 2c39603b-1d21-42dc-6f15-08de899c2515
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: Snc58Yady+s1BjeVH18o9lEVTNyQKCfwm7PuKpm4CLekpXmSU2THzYrnAZMSJdf+qi/aAA5MG8dPh/Ipy/slf/i2lxq5eMGvuBW9vwg31yoqVWTPDC/gStuySvxn0zLAFI2/oiFIwCKmimvMR69XYXDMBP7rlhbPowHlfmaTu4+a09ruGmbBYMYGL96bWnk3e9zaJIeCFZQTH0gXBIalhLKHXwSfvPSgUSvOw26dU6O+XRUN7DZtgaVSV03vjE+/nIF7PrrYVB10RTvRprOL4hmYRzvY9pBWeF7wHOoQbynUstRBd/Pt5P5WWYFoWiLMIjMONELrgaNbKdmskBIMKMBbWDEWr7FFSyc92EPV4tDqfIGWYzZzrzon90HNoexA4gB1D0mafy16IOVkGJq080UjGhhCIo9cpdcurd38Z/i1I/ftBA1FCe0ykE3sxGKarR63ejjgccjlP97LIFdJahHgmzn8eI6MheeOptY3PaJEaceHn8wLVaYjeE1UUO5i0vwEKGqnuTm8Uz1g+jcm/OO0vQgHSe+L0L2qiitNydKLRieNS/r0+kuciC/BQm0o+g3PnlvOUEAJm1r8UoSNTRMjDlkFgLf8eo+SfrN8WiDiIdScr9TpDORCDW4eWj58qvhJ1tQX2vZcjHW8l/QdXI61zgYzUTypk3wdvXaCF2wlhzjN+5Q2THxuxWfT3egGJrOoyDlg1fKiS/aqiThNszmseWCwA2rM/DifHXWR9+YfdX8CshJpMmOPf1yXO7fb/7HRm/j74uJ9cWLF/d8zISJ/QUNXCchPGM+fd+eDNj0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlUzWEZ2U3g2VHp6ZWIyQUU1S0tCK0RsczZxOW5KTVgrbkNYWEkvVk80MDlW?=
 =?utf-8?B?bTdBMlFNSnA3Z0p2SUJGYmpLVnhTamIzYjJ4SFN1RHNOS0N3YmxLSFpvRGxX?=
 =?utf-8?B?a3cxbGNHR2tyZEo2WEI2OVRPVkZBMTB6clJLY2VqSU9MZk9rT21MZjVibHpI?=
 =?utf-8?B?UFg3NVpmWEdocVhmUlNrcmxYUVl4Q3I3dkRVcXpxcUtWd3BRbFZyaDdzZXNG?=
 =?utf-8?B?WEc5S0FGKy90MkpEVkNPejlYSXZrdEJMcFdPWnp0clRERmo0cmpPWlVEdzN6?=
 =?utf-8?B?UW43clVRbFlTVGFwaEM5aHp5ZVB2MllWRHB6OEtucDRvQ25sbTZoL0JQNDJt?=
 =?utf-8?B?UHpzMVMwMzZJbVRaQmFHdHhwTE5HUDdQMHlNYlh6T0ZRK29QTjZRbVNWUndK?=
 =?utf-8?B?MUl5N3dhaDhOWlc3cStVcWVPc2VneUNHU0xnN0RXUUVqWVVaN0tUUFNxSmt3?=
 =?utf-8?B?Ky9mSUN1dmxxUm9xWTRFNjZGdG5hQUN4cmIxdVp3V09xYzFxeFJCL012Y0Ev?=
 =?utf-8?B?UWxGZmUzNWxZdVhOZFl3K0xmTXJYMXc1WURRS05CN2dGdDE3QnN2N0E3b1BP?=
 =?utf-8?B?b2l5bFprWkFtWWhtdjhnWUlvcU55REY4eXhFeDhEM0t2WWZUT3piMnowTkY5?=
 =?utf-8?B?QWJ2YTZQNEplWlkzRGhOOWsrSFNGdUlDVDZtSXI2cEQ2TEljdzlGTFByV3NC?=
 =?utf-8?B?NUpIbTZYTTlDbFVhNVFuN1QyRjc1US9GUlp6VlN1ck1xdE1Na1N2Mk9jc0ZN?=
 =?utf-8?B?NmFoQlZYRkFVQVZHdzlseFViZWZvOWFGS1Qrc3FXVkZUYU1La2h2RmNrNmlt?=
 =?utf-8?B?Tm5VcHlLRTdaekJ2bUxhaVZ6Q1YwVzhkcTBhVWlTWHpvUXFiSjdqMlpVMitJ?=
 =?utf-8?B?ZGxJSCtaaDU4S0NtN1BwcWdDbWtYRkRPUWVJUUZTK0FxcE5WeEV1V1l0R0xj?=
 =?utf-8?B?WDNVeksxdGZQQ2k4SnA5VnVWL21mbWJUTjN4d3pLSm84bEdadkdNcnRVTmRB?=
 =?utf-8?B?NGhJVzVXQVRpeHhUbnhQMk01cC9INEt0dTZDY3BFUkt0cmZCQWtlOXE0N3ZO?=
 =?utf-8?B?ZXBMb0RhMHUxRmRxMnhnaDh3Zkt3UU1xMkVRSVZNMGw1TnowQktlb20wQnNH?=
 =?utf-8?B?Z3g3UVRCdnhtSzloNGFac3pNMWMzNmxhMmtvdzBBWDF2M2NjdVNhVWxkUU1q?=
 =?utf-8?B?azkwdGwwS0pHcGZmZ0I0SWhxZWVzaEN3MG5NNldsazFzYkNYbmFTYWR0ZmlD?=
 =?utf-8?B?YzI3aDJjd1hqL2F1UXNZNzlLQnZISUtSek10ZGFCOGxKTFdRVXE2RFpRalQ4?=
 =?utf-8?B?Z1FDdHJwRVRrUHlEQmsrdkFGSVRBOGowR1QrWjF0bGIvVG0rdGc2SUZjVFZU?=
 =?utf-8?B?bEcwMFlCZGNYOS96YVhUcXdaM2cwNzJqWUNWcXU0eCtlVUdqYldnbGNKd0k3?=
 =?utf-8?B?Tmx1cGtxOGxaamk1OENsT2IweW1ZZXlORERkdFVHOHFpOE9DMFVjS3Z0ZURB?=
 =?utf-8?B?SC8zWkpGaXI5aWs2M1hpWi8zZUlZcHVwdUlXZ1lIREduRlE0K3pZekJNeTk5?=
 =?utf-8?B?TmVwaGZ2UUs0dTZKYkY2M0hKekFNTERpSGJTM1NVSU9mdUd1Yk91UFZQYXNT?=
 =?utf-8?B?aHdrWUE4WExtR1REaGxwaWZ3MDY4UnBza2ZxbGNJWklaSnBoQlN0M1h4WWNs?=
 =?utf-8?B?Z2NSZnFIL2Foeit2bE5JYlhUQWxncGQxWnNOcURDTzRMNnYxUnB0Z3hlNDJz?=
 =?utf-8?B?UE1kUnZpM243TG5lOTR1b2dwc0p2VUJyRzVxbnRGeElIUE82UXlZQStKdkNa?=
 =?utf-8?B?a0VEankzV1BXRnB6eFNXMnhiQkk5WHNqaE9iaXd0ODJuc3JvZ01vR2U0NDhF?=
 =?utf-8?B?YURLKzJKbnVDeFpFekRWOFlaNS9PVVFlb2JFU0xXSzI3NE1ZRllyRVpuVXdT?=
 =?utf-8?B?MncwNmwxbVc2YTlVTldyVFU4Sm4yS24xckE0OE1Md2NqVnBGaXB1UFc1R292?=
 =?utf-8?B?ajBDVEtXN0V2UEdTaFJzMVVpK1lwWnRFdEpaQlhYVUZqTHI4K1JER3VBZGZy?=
 =?utf-8?B?S2hNeXBIVHR3NWFTZVUzazlUbXpNRnI5a3VsNllCUGhJU1NEVnVtZVpCZER4?=
 =?utf-8?B?SlhUekJiRU8wQmxNam5QY1JSTG9YMCtUanFaUFYyU2dUNjRVV0ViL3U2ZFdX?=
 =?utf-8?B?eVhXL0dJMVM4cE9HT2JNVTFnQ2dYejdHSkNGWFBYc0hCdSt4T3NZLzhReHdr?=
 =?utf-8?B?Nk1ra21QMjlTa2NkQndTSEVieEd2d0dYSFg4R2pyNDRrMHJNWEQ4YURlaGh6?=
 =?utf-8?B?ZnZvMFZKSXFNYmgrR3NtODZ6UlMxU3YrMlRTcUdTU0hHVURNRUZ4RkxBdG5k?=
 =?utf-8?Q?sqZJy3VNf6bkpxfM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91A21C84E52CF54492FD3227A12452E4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: nqg0g8AFThBi8JeICwonsyTLfITy0cIPDXXMYD7Y14Iu4oay96039RAxNDbF6ToMBrtnjvVH2w7NC0Wk/1JO4fpydZKAFLQFH9lvLxNafkX14t4KCwOojnZJP04RtSfajpTRV0BD9lrwOs73J+0O4CFf6zd0ahnSrWgCXKSyPiWmIMDH7VQrC0eg3Sg5deUZ6azADbUoE7oAa4swlxMSMLBXioVKqMQuCEp5pNGtCNUIPRxZwqRovNrvxzljXV+2xjoFwwCk79cipJYL2dkh3ODlf8tOtOHthjuEu/sqyIzZ1K3pYnimM0zaGmasw/Hy2iO1nc/AldCa4aC07gPyKA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c39603b-1d21-42dc-6f15-08de899c2515
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2026 11:54:46.2793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DoOcVvggA3MZhJO1KHFXGWeT7xtuaj6kOTThAwdTv+jXqgHeK8ZykUjwQ22cGTVhLRc5/xuVaPlVTiSWQj/nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8371
X-MTK: N

T24gVHVlLCAyMDI2LTAzLTI0IGF0IDE4OjA5ICswODAwLCBDYW4gR3VvIHdyb3RlOgo+ID4gPiAr
wqDCoMKgwqDCoMKgIHBhcmFtcyA9ICZoYmEtPnR4X2VxX3BhcmFtc1tnZWFyIC0gMV07Cj4gPiA+
ICsKPiA+ID4gK8KgwqDCoMKgwqDCoCBpZiAoZ2VhciA8IFVGU19IU19HMSB8fCBnZWFyID4gVUZT
X0hTX0dFQVJfTUFYKSB7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9l
cnIoaGJhLT5kZXYsICJJbnZhbGlkIEhTLUdlYXIgKCV1KSBmb3IgVFgKPiA+ID4gRXF1YWxpemF0
aW9uXG4iLAo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgZ2Vhcik7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlO
VkFMOwo+ID4gPiArwqDCoMKgwqDCoMKgIH0gZWxzZSBpZiAoZ2VhciA8IGFkYXB0aXZlX3R4ZXFf
Z2Vhcikgewo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gMDsKPiA+
ID4gK8KgwqDCoMKgwqDCoCB9Cj4gPiA+IAo+ID4gCj4gPiAiZ2VhciIgc2hvdWxkIGJlIGNoZWNr
ZWQgYmVmb3JlIHVzZT8KPiBJIGRvbid0IHVuZGVyc3RhbmQgdGhpcyBjb21tZW50Lgo+IAoKSGkg
Q2FuLAoKSSBtZWFuIHRoYXQgZ2VhciBpcyB1c2VkIGhlcmU6CnBhcmFtcyA9ICZoYmEtPnR4X2Vx
X3BhcmFtc1tnZWFyIC0gMV07CklmIGdlYXIgaXMgMCwgaXQgY291bGQgYmUgZGFuZ2Vyb3VzIGlm
IHBhcmFtcyBpcyB1c2VkLgoKVGhlcmVmb3JlLCB3ZSBzaG91bGQgbW92ZSB0aGlzIGxpbmUgYWZ0
ZXIgdGhlIGZvbGxvd2luZyBjaGVjazoKaWYgKGdlYXIgPCBVRlNfSFNfRzEgfHwgZ2VhciA+IFVG
U19IU19HRUFSX01BWCkgewogICAuLi4KfQoKVGhhbmtzLgpQZXRlcgoK
