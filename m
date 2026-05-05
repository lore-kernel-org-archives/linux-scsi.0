Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42FA3B4EB0;
	Tue,  5 May 2026 05:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777960150; cv=fail; b=G3MRW8js4M+4DMKpjA7XM+5x5d54022EQVV15C5lz0ebjz+M4gTYTNz/RJbKws38bfO+byImXvIzOYLgtlpizbK3oHTK7Mnmoc1R9rHVfCq9fm9ofld0Z5fP9Mndd/uqhMtBlsXjiiyVv5Qb0GjqVdUNNToAxnNBIff5BQunWUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777960150; c=relaxed/simple;
	bh=bVO85Ae338QPJjC4MDkpCuwNs7Oqy7rT1omK62RrjlA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J3ZPA2ebRY0lSVZG9GiibGdQpTnqvHWhPY1DF3GpJOLTe+MHfG9YTK1F/EsOMHRKOotMtvSVVII0lNGfW03wcKiiOvWWW8g/YfVao1m0Up4ZPZfeKJYUUGPXGvVO9gqQC/QdBBGsCS30Pwsx5PbKuZLddU/OoD3bB9NWe80rf6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kwaWOskI; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=cJdR/6BI; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kwaWOskI";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="cJdR/6BI"
X-UUID: 1f0084c6484611f1b96f91537e34a508-20260505
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=bVO85Ae338QPJjC4MDkpCuwNs7Oqy7rT1omK62RrjlA=;
	b=kwaWOskIWUTCtd6zFPlqGtQs5VdBtN3uYuVERT6+VCdd++WoRZN8BHBDKSN2u7m6HNBVT+ZQPidRkCsonh0+WOc0vG2Hgf7cBX8/Q3MAVd3+7A1pLRibDPGaN6gmcrV3nO0dcw3rNhNR8rnCGuqb9+4gGYfwfgWKjtd8CqOwcmM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8b8bf4ae-b585-43de-9ef0-1556051859a5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:dd30f370-3b7f-4b26-b2f9-40f0deecb36d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f0084c6484611f1b96f91537e34a508-20260505
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 838716115; Tue, 05 May 2026 13:49:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 5 May 2026 13:49:01 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 5 May 2026 13:49:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NCQEiW9dI1UfNX8mlkRl4M7qQDlqIcG01pTBU1J5kn3HoEmgWG28sNfKkSa8Az7yaahiD9pZ5yw7DL1ym5MK+mpo6hBnG2bwpJw9Ta/Qse93ZU+KFW1qG84MGclIsxxz0SBG/yg+wH2eSsq4uFnH12fa7LDQgVnHbOUyt0e/+WQCp4zURnRq6Kq+oocJh07+s+iQvfBZ2ShJxbD+nwVQzo/WTRx6izDOgwb8dOPn+lTy+/niO8gt2dpy2646NpS3Re22QDslaT+6wVhpw3oMdxjj+lJagH4lvF6nJuO0fbKv4Ica/2vq0CTTXLjeLjt1F6wcx3z6H7KSJgkgH41WuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVO85Ae338QPJjC4MDkpCuwNs7Oqy7rT1omK62RrjlA=;
 b=XghFhOlOO+P6ezLkaJA2ZJCVTlReeWh5n3KMc6FOyCGVZQZP/ingbE/4GWPWzkqsJRPfJnJ0PBn5ILyQfq8Z49HRF0pHH909oRUNzwTzaxXzPYBAGj68EeAomq25y8kN+JpOG6/+iLM5vkan+GgNmucXZFraqb0gD3Sk3jhq1fTGzihvBru2plmPDU+iquI9DR9CxvRf/aGYxqLKO/PKksY/g5z5yXKz6IcSc7ygC+CYpjie8V+1JFnzafO/QmHDwBQSy9Otqp9slMqQJrnF0VAoplhKbo1MWsZ/ChXG/1KKEO/68uyFaZXJkbUgF89RW22t2iO8ulZaM1Kj9cRbjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVO85Ae338QPJjC4MDkpCuwNs7Oqy7rT1omK62RrjlA=;
 b=cJdR/6BI0cUkdyKUDdDDpQ9IAxR8KRBXtDeb7gqZkbWB7KfRFSu37/LOinMvwWejxvrY+NlDGmy6BBLVHSWYRgMgzl6CiemuAKlmO6ANK20jQAqXZTR7AJNNVnUDMP3O27zC6n1PZlknmPzv0YI/eBqOzNbaNPp/wr7rX4x/TAw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8740.apcprd03.prod.outlook.com (2603:1096:101:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.14; Tue, 5 May
 2026 05:48:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9891.008; Tue, 5 May 2026
 05:48:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
Thread-Index: AQHc2WzyAK9ykRAzgEuKYwXzeINk5bX9m0IAgAA8cICAARstAA==
Date: Tue, 5 May 2026 05:48:57 +0000
Message-ID: <a747ee82d832f5cf5861eb7f2f11cc1857b531fb.camel@mediatek.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
	 <20260501131641.826258-2-can.guo@oss.qualcomm.com>
	 <a173bb1733968d41690f8472d13b95028c8975c5.camel@mediatek.com>
	 <8a1cf09d-7293-464e-b581-5337f4087593@oss.qualcomm.com>
In-Reply-To: <8a1cf09d-7293-464e-b581-5337f4087593@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8740:EE_
x-ms-office365-filtering-correlation-id: 20fae4f0-855e-4eba-b0c2-08deaa69ffc4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: ltrxt4quFZgWt4So04a4DjDmTmlSAYRpIxywgqh8KSdwcmL+TJJ9XYuQXrMWijVbzDgvm58msxH6UWN22dxdysjT/QpfvfNHXu8WY7MBqRzknjh/jsNTXf5DPYnNHRb0M7o3xfzTTNsEynU1F5zkHbIHlPXZ+pKd9ye+OuaLpg+0jKHx2RML30FgDdmhkM8c+u8MlZeN17K5e1LS9FBj41AaD7g5wpu7qKa0cG+H/+lOsBNBlRxE5x+DSciGf8K3Uh4RKMajKoH8tccMKIymPGJUkngVuNz+5p2W1dKCu1Q1nsLM3HSlTTBdvVWYfVDWMMbLDEkFIQTwU64/UB3BhKwifmM4dKTcAOiUWuAaPLvuLGK7FIdvaZOFL0N8+v9MAGf1JZ72Yd5jB+zqBDXHkK9lA61GngethZ1r4NRKxoPg2NJRpmrF+n1DK3+tBUsDHc3PRfPm4QdBRC8RXQ1IFS9joxC8BwLCTpWFSVHAJjXQNBF1rEdKd7RcqOZ1IoBB2aF3VAisp4CzMuYrnrg8q5oI8rFmQy5uevZ9jpVFznHRbwjo/NA+oaoBeNwHNzdr/fRrEatwjwL6E5WO51Na0bb2I0wyDCYoPtzoHRP9OcP9AT6UzwmMf5irWALKCq2t0hEUgK7kXYbxD3EJGp1O5BAFuI0rhkISED7D3EktD22zQ7ImaqpXZRDHscx4hOsezSwcKIzWcrTQjhRuIqztvhLh7cyRba5M7PWaw+2fYn0VotWyKnGLiK8yu7B7fIjC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUdFZDZyQ25lR3FOYU03Y1dLcDM5WDNGcWJ0YWpZbTdLeWExeDdDUnhyK1di?=
 =?utf-8?B?cXBwUUZuUjRBTXlBR1M4czhEekQydHNSU1REaEJEOWR6aW5aelcvTEVhL053?=
 =?utf-8?B?dFNRUFVRNWIzL01RdkJTbDdzeVU5cHE3cFArc2ZTUXVHRkdLQVIxMVFwYkRi?=
 =?utf-8?B?S1NPV2cwU1pPTU9Dd2I5YURjd2I3YngxaDJSNXVhanYzekZZT3R3ZkdDTEJh?=
 =?utf-8?B?N0tOZkxYcEFjTGlQdzJXWUc2TmxKVEpwaUdNaTk4RVJ4RlRlc2lEZ0NhZE94?=
 =?utf-8?B?dmZLYlFYbDdZemdYVW9IZHZwQm5hV1NvdlA3YStNSDRTN25vSEIxeWhJRnVP?=
 =?utf-8?B?V0xyZlkzbDNXN1RKNUx6dkpyTUpMeDlNSnNESXl5U1VodEVhdXZvVXRoajRJ?=
 =?utf-8?B?eTZ0eFozTVZMZ2FVSnVMbGF1cHluVDcySFM4SmRERlpwNkc4QldPdnpTTFpq?=
 =?utf-8?B?TkxwSHdZc3ZKSUFvMmhRWnlsL2liT0NDOCtUMzF4UFJVL3BzL0hoeHVxaVJN?=
 =?utf-8?B?RzdpMFFqWm5LS1dwNUE2L1JrK0loS1hjb3VUVEw0K0JTOWVreGlkb3pkRFBB?=
 =?utf-8?B?N213Zm5ZaFBiWDZaV3NDNDhiK3FxYVJRaTdObEx1ckxOd2FCUG43elF0RzVq?=
 =?utf-8?B?d2NjTm9HRnFjY0dwNXhLSSt1Q2lHTGdUQ0xkOVBXN21NY001NUtHZi8veEpW?=
 =?utf-8?B?TFpvZDRIeDVzOG05SHI0QlZQaEF3RmhjV3ZSZFo5QkU4Z05BbWsyYjk0bmlM?=
 =?utf-8?B?N2FMUnJTRWUrN1BTd1FUcEpmbFBaRFlGVWVnTVZxaUc5eVNWTVY2WnJTK3ZW?=
 =?utf-8?B?MzJGa0dGU3JxcmJVb1FnV3dwTXBzMXI5T3FEeEpMdWRUVFA1aWZ5aVNNR2VH?=
 =?utf-8?B?VWJRaVR2RVpTWEFvQ1RDWWxXand5MS8zTWcxdkFmdUhGR1VGendwcE5Pdlp5?=
 =?utf-8?B?LzZFVUF1N2dXckhnb2czc1o0dG9rWXRUa25aWEw3NVlNK00yY0hXQVczZjZn?=
 =?utf-8?B?OTBNYlhBcEtON1FHRC81MlFNeURkWWFhNHdKbElBZ2x0QWV6RUdESjJkbHgr?=
 =?utf-8?B?NW16TTVpWXN2N2JmVUVRRUZsUFJGd2xsV0hwdmxSTFVFTEdRY1N3N3hjNkth?=
 =?utf-8?B?TlNicGE5UlZtdmRKV0V6Y09vZ1pja0k0NHorbDZjUE9JTWVlUEN1YTgyUXlN?=
 =?utf-8?B?Tk5zWFVWeGlSWVdMb1FMWldwWG5VdFpKNXhZZnNRZHhPL0hsNlRDTTJJVGly?=
 =?utf-8?B?aUVnSm9qT2FTbjZ1cExqVDVKeXVPamVybzk3WnJZRWdZWTNXS0paak43d1RM?=
 =?utf-8?B?WUpaYVc0UjBkNVI0VVVTMzdIZGtLb2lsbVo1OXBBOFROcmtuT1VIT2V3eElq?=
 =?utf-8?B?Z2FwTXBlRGNtSUEzMnJHVUcrTFVOeDk5Rm8rOCtMNFVpMHFTYlZZRU92TFQx?=
 =?utf-8?B?V2FrbUxPa3RZYzVUOHc1OEJ5YkJrbi9FN2hiZ2FkNTVrWnZXUjdVckpqZmtr?=
 =?utf-8?B?dVE1azBVQXlnR2lWekxUYXIxQnR2V2tnbUhiUEdlYlhMUjlYQlN3Ulp3WWc2?=
 =?utf-8?B?N2ord1FsdXQ2U29Kc3gxMDFTVG92S1JOQXNMbk9DY0RkeGlDOVJDYW85enM2?=
 =?utf-8?B?NitqOVBJSVQ2Ymt0emRYb1B5MXRIcTh4eFNHbGgxZTh0RSsySHpraGR3T09w?=
 =?utf-8?B?cUZ1M0ZMSEJNNEhsNUl3MkRLTUdMcHdTczJxRzNzbmphOVNqZUFhR1p3akti?=
 =?utf-8?B?YWVockE0cnNyVWNBVS85bjJ0dzR3YUtSaDNFVkpTZGZTajNXcERsd25HN0Jt?=
 =?utf-8?B?ZjRiVU5nN3VQOUdOaE5NSWgyQlVqMG1RT0RpQm1ndkVZWGo1MTFTZXplcW9m?=
 =?utf-8?B?VWZUY1IxS2I2djZmTTVQaWZGS1MwT1l6VFRxMEtQRWF0Q1hDYnIxakc0ak1Z?=
 =?utf-8?B?RS9NSEpwWWs3N1RmL3ZaY2ZzWjBqRTJENllsdTdscFoxSVJjVDg3RTNjMVRt?=
 =?utf-8?B?dU9GNkJXY3RBdmsvWEpGay8zTWlkK1MwYnZ3T3N4Yi8rSVJGaENwSSs0MEpM?=
 =?utf-8?B?dE1QUnFVbnRGV0kvNE43S04yR0lGdjBDNUFFaG5FUERjUXMwdTZWN1JmZmhn?=
 =?utf-8?B?TTRPNVNHUTRBUWZRaFFUMkNWN09pelpVNkRZK0Z2WGJ3Um1nUUxUaVYwZVl3?=
 =?utf-8?B?citCcHZFTnFRTnRWdkhhbXdOdEtCcE1LQ1pUVzZhYTRjSjNPLzlSUHhUMWZi?=
 =?utf-8?B?a2RINE5BMUFjWC9YcUd0bFBxeFRZOU1ldGFwV0dOM0NCQ3Mzc0ljRmpnNWVq?=
 =?utf-8?B?K0hxemhlQmUxcEhnenErYkNDRVYvWlZtRS9CakxUbHBTN0x1QzBqNEh5TUU2?=
 =?utf-8?Q?wi9tsfOpXu9hppdI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <804B24C530D5E048ACC17613D8219AED@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: OCww+vGLbJN5CIbTkNCHK2P9QSKBaJ2qBXQGVFwk/Nu1IfJHcK6p4nEIeWx0sYCaQDbR5PtLptHBr39Ok3rBcpY0AQ6PY2Z2+if5xcvmaDpQ1Dw6RMR1zL7P1ZstLUIjXQHKS5N+QAnL8qFP6kKthMHbVPqbXjG29/CXiKmpX5N6tzaXYlRtfcbtF1DxUeOpKPvIiWiIp+4+D2WBHmpjBFYDbHkEk2eYdqSJcGWWdI1Xya+FgUAbTI6j0R4Mg6WQcQS2i3YDVKUeehZoLIttBm6seYpd9pGxy8p7P0sFkFlxzTk1GGVfBukzJdTdKdJ8XhL8/ia0u+aNFeNAZk4msQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fae4f0-855e-4eba-b0c2-08deaa69ffc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2026 05:48:57.2287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +hSoikzHdEiriA8v0zcEb7Pgd/rHmNXcoj7qlscfRP0Fkvlf1Pp24Cv+tOqtGuZI2+XcKxYmaMB45coPyObOuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8740
X-MTK: N

T24gTW9uLCAyMDI2LTA1LTA0IGF0IDIwOjU1ICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBIaSBQ
ZXRlciwNCj4gDQo+IFRoYW5rcyBmb3IgcmFpc2luZyB0aGlzOyBpdCBpcyBhIGdvb2QgcXVlc3Rp
b24uIEFuZCBJIGhhZCBzcGVudCBxdWl0ZQ0KPiBzb21lIHRpbWUNCj4gb24gdGhpcyBvbmUgdHJ5
aW5nIHRvIG1ha2UgaXQgYXMgc2ltcGxlIGFzIHBvc3NpYmxlLi4uDQo+IA0KPiBGaXJzdGx5LCBp
dCBpcyBpbnRlbmRlZC4gSW4gVFggRVFUUiBmbG93LCB0aGUgaG9zdCBzb2Z0d2FyZSBwcm9ncmFt
cw0KPiBhIEFkYXB0DQo+IExlbmd0aCB2YWx1ZSB0byBQQV9UWEFEQVBUTEVOR1RIX0VRVFIgYW5k
IGluaXRpYXRlcyBUWCBFUVRSDQo+IHByb2NlZHVyZS4NCj4gV2l0aCB0aGlzIHF1aXJrIGVuYWJs
ZWQsIHRoZSBob3N0IHNvZnR3YXJlIGlzIGFsbG93ZWQgKGJ5IEhvc3QgSFcpIHRvDQo+IGNvbnRp
bnVlDQo+IFRYIEVRVFIgZXZlbiB3aXRoIGEgdmFsdWUgd2hpY2ggaXMgYWJvdmUgdGhlIHNwZWMg
bWF4LCBzbyB0aGUgSG9zdA0KPiBzb2Z0d2FyZQ0KPiBjYW4gYXR0ZW1wdCBhbiBleHRlbmRlZCAo
b3V0LW9mLXNwZWMpIHZhbHVlLg0KPiANCj4gVGhlbiB0aGUgb3V0Y29tZSBpcyBuYXR1cmFsbHkg
ZGV0ZXJtaW5lZCBieSB0aGUgcGVlciBkZXZpY2U6DQo+IDEuIElmIHRoZSBkZXZpY2UgdG9sZXJh
dGVzIHRoZSBleHRlbmRlZCB2YWx1ZSwgVFggRVFUUiBzdWNjZWVkcy4NCj4gMi4gSWYgdGhlIGRl
dmljZSBkb2VzIG5vdCwgVFggRVFUUiBmYWlscyBhcyBwYXJ0IG9mIG5vcm1hbCBFUVRSDQo+IGJl
aGF2aW9yLg0KPiANCj4gU28gdGhlIHF1aXJrIGlzIGludGVudGlvbmFsbHkgaG9zdC1vbmx5Lg0K
PiANCj4gQSBzZXBhcmF0ZSBkZXZpY2UgcXVpcmsgY291bGQgYmUgYWRkZWQsIGJ1dCBmb3IgdGhp
cyBwYXRoIGl0IHdvdWxkIGJlDQo+IHJlZHVuZGFudA0KPiBhbmQgd291bGQgaW5jcmVhc2UgbWFp
bnRlbmFuY2UgYnVyZGVuIChmb3IgdHJhY2tpbmcgYSBsaXN0IG9mIHN1Y2gNCj4gZGV2aWNlcykg
d2l0aG91dA0KPiBjaGFuZ2luZyB0aGUgb3V0Y29tZS4NCj4gDQo+IEkgaG9wZSBJIGhhdmUgYW5z
d2VyZWQgeW91ciBxdWVzdGlvbiBhbmQgeW91IGNhbiB1bmRlcnN0YW5kIG15DQo+IGNvbnNpZGVy
YXRpb25zLg0KPiANCj4gVGhhbmtzLA0KPiBDYW4gR3VvLg0KPiANCg0KSGkgQ2FuLA0KDQpUaGFu
ayB5b3UgZm9yIHRoZSBjbGFyaWZpY2F0aW9uLiBJIGhhdmUgbm8gZnVydGhlciBxdWVzdGlvbnMu
DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
