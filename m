Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529BF1509AB;
	Mon, 20 Jul 2026 09:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539001; cv=fail; b=PXNo+3CwEWKeO0SAfaNURcBW17X2YEJ1E82RetaQ3wjysMmgyMErXMlErDgmF8Bk9jsCORjrO6yyqtVslQPd9bYjIikl6HA4YOcb17b2il6VUzwyK0JYPBUv7hGyKxWt55EKzk7tSKCjYlb/gqrTYVDieprQBoClQh3Un1wOcGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539001; c=relaxed/simple;
	bh=MZ4AUNURl9qEuq7mRd48JKBi+PIHyxC57BzKPFxsoQ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m6LYvLt6H5+wsSeyZsS+CTRjEsxoxxJ10EMgf4FuABdyheZfod6FwG5VQHcRrwnw9gwhuXKuTKZV1+wtIQhr9sr1esnVxJmH662Akq6jB7msnyboD6Y5VeXAIkyqdhMT+RT6APCr8JCKHzQ4fUhVikAVz8XEZLbYcFmMNIa0eOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ozhy3mEz; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CNasUJsF; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ozhy3mEz";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CNasUJsF"
X-UUID: b36928c8841b11f18dc8c9802ae25ab1-20260720
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=MZ4AUNURl9qEuq7mRd48JKBi+PIHyxC57BzKPFxsoQ4=;
	b=ozhy3mEzcpe+1PvU2mBRaYaN5DE4nxuZ3PXPeGGF73ikiFYCsDOpfcn8fEWcbvCxhM/mc6l/o8IJoEokfgf9iTpOOH/lisSsv48qFRiplS4IvY5DOq/FzNGgcctIJvpIjNew1eGimOIEnwmgvszjiEAZDabf7BX8hC130Xkc6bM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:1ceed098-c615-441b-88f0-30f2ca4bc404,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:538b5619-ab14-4403-9336-76696324c5a8,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b36928c8841b11f18dc8c9802ae25ab1-20260720
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 258310369; Mon, 20 Jul 2026 17:16:33 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Jul 2026 17:16:32 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Jul 2026 17:16:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CCV/v5KSVS6TDSZtQTwLfHba/uMYdEA2Q0D6lrM1jy4T5fp0BzHD3R6ZMob5Ah3ed9IVcZv+55sKEcNadfQ+iQ3iUa6ZSpdrHoXc4AzRcG1w1h1MsBfegp5gzlm3AkQwpnzfhiEXAFUo5vgKG5oTeIbCeoN190yrjNMInv9s1XOtFIRo9FYhEKLG8oAFCl8A7c3NidZRGqiqtivabi7p+nLPcBy+zphOh8Ge6q3xMih3yGHtw55I0hKrTRrVLc5E4P+88zCIBvwkrja1OydjL49LVJZlPDYKAocF7ztgymxc0wVTzgTRObdLDVO5X3Yo2hgo0+xZ6RWOch2qio6pGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZ4AUNURl9qEuq7mRd48JKBi+PIHyxC57BzKPFxsoQ4=;
 b=JVCUvoUptEGglQlmhWC2d+hxl3k/ikpUxfoORHOPmWX9p/gCPYyE/b8V/ztkWIp1EWtU+lRkabKPu8z9yNQ6Bz+wkuPOFm4L+OCwDLdIo5eOFV7OCaWOcrtHJHq2U+v9frREfcdKV1okJ1HwhegyejJw5vsWinhsPVfhapQwGaaIajyh0cagC8/M15nE99msvWYZHEK0hEPDFUcXZBrwJ+cex5fK4strZxjFvzdJt041DR4fRSZzl7IsYGZ9wAgYGjZdCHK3btM/JLqHDDIijzWGR736bbUoWcOwxljIg+GvFgAatTdGr8t128vKFeiZrAIyvpmeQxgqSVHdPRmQ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZ4AUNURl9qEuq7mRd48JKBi+PIHyxC57BzKPFxsoQ4=;
 b=CNasUJsFKMSO63kab5hOuXa9Djq3MZRQMGK6P9NFw5FkJCKVY1k1FqYQi3mCOWalrBUfNDOaGeFQyAoADE7OMiA2weI14Xj/mpBi8WTHayG82+3YOnDK4MjSBmYDtfZrQu+lT5+vRfGmlVb+MIRMqvKhSkv2MQRm8xVhYgVi+uM=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SE3PR03MB10511.apcprd03.prod.outlook.com (2603:1096:101:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Mon, 20 Jul
 2026 09:16:28 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%6]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:16:28 +0000
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
Subject: Re: [PATCH v2 6/6] scsi: ufs: debugfs: Reserve space for a string
 terminator
Thread-Topic: [PATCH v2 6/6] scsi: ufs: debugfs: Reserve space for a string
 terminator
Thread-Index: AQHdFgKJK5Xa/zoIwEmUZ4Q82KRQCbZ2JN2A
Date: Mon, 20 Jul 2026 09:16:28 +0000
Message-ID: <ac16a85bf2a882b04bf45d0c84c582590b74a3f3.camel@mediatek.com>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-7-liqiang01@kylinos.cn>
In-Reply-To: <20260717153914.26321-7-liqiang01@kylinos.cn>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SE3PR03MB10511:EE_
x-ms-office365-filtering-correlation-id: fb0a7976-62a4-45f0-44e9-08dee63f9489
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: T6jQbP9o5Xc8GHDJLtyFFQYVO0/wrgPp2MsnRyhzgsrm67iIv7HQlNPpzHIw9o2HFVo6BF8PO7rzUSXeJayS+uuWaon+vxrbu/wWfs/zy9es03HCTur8iv7wIjptR3F543oovdI3yfHizHvbgNcojFaF1R/fc/hmz5hUcRRr0BQce2FluhVV5AWNOwBUtIcMDYYyiIO4LeHipV94apxf3tJXYRf7i+LGc9uryMMVdmnhDA/FcZdlJdFCIPO1TZUW6+2Wls/nIEmNkkfvB/VJmPCZvaPnirn+jjxyXC5xWN8Bqc2p4eiGlVQhgKI67g9YfOjxakEHWCqYRk/WMEdDl7mXl3jv6RIERgYtZdzHcZjNoIdSjsadkydjpbwtXEUKQ7feCVQ5dmA/OojtwJqRaR7SAvCDM9bJfRTEgkVo6SWlCtAOV4zcOEGHa7ppSBUXYr9FACU41pEN2FvryLgOnEc+vxYSFQkL+bWZcpzgXQa6yqSzVn8DG/3mMZrVJT3heqYA+Anf77mKYDZ4tGMXMtb+WsFZ6huLBDs0E4kW1i5KukPG91Yg6K+Lgnsd5Ox+wysbc4VW6Tge3zfhTnNJ1LzayAF28dCSq3bIFR1FXJmiQb9qJnUjvN5Ey609Dn56V2YEKlCQk9Jq6hG/7fr6QemRXyoFYEydcU/Xrm9b4i2oGORu3iF7oLonef4gsjz5AQriTYtDLhuSJ9aYxNcE2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUp5akRKcE5VUklsZHNJblZLb1Z5V0RGRDF6VlRGZjZHREV4WmxROGR1VVFR?=
 =?utf-8?B?V1QvdEUzOGtrY05XUWxzbDBRelJzNGl6U2N2TWthYlpVd3VCNVNDUndVN3V4?=
 =?utf-8?B?a1FIM1FuYzJaKzYwMGZPL2FHaWlteFVNMG9xd3U5QUIzcVE0RG9FS2JqQWhm?=
 =?utf-8?B?ZURSZTJqSU1hOXgwb3BLRk9ITHIyLzJIZGZzMFhTbjduZkRYMzhDaGZ6UnA0?=
 =?utf-8?B?Z1Q4ekVpRUV0anNLRlI4ZUZOd0N5R2tLWnlBL0JLdWdVREFOUVFXOWVxeHRq?=
 =?utf-8?B?eVhRZ0Uvei9pU0N3eDQreEYreGNvT29ncGZhV2JIb2swZlB5aEZiU0lvejhM?=
 =?utf-8?B?RVRDMTZjSEFjN2hSeEFjNzZPUWFyRzErWFgwVkVpRVZJMElLcTVDbnVQaHpP?=
 =?utf-8?B?VzVtTXBTVmRFdEJqNmYyR3JYeWkyS1pCbzRpZVJzVGJGR3dPNHo2bEl2NzRr?=
 =?utf-8?B?cUtUZCs5aVVMdWtXUFRyMElPWjV1ZlBoRGJTZnBoNjRSc2xtNW1vNzNQM0FH?=
 =?utf-8?B?L2Njcm9TMnZjZkg5Rkl2aTA2UHVPa3RVSFp4aG1nSEUvdUJaUG52UW1BN2NN?=
 =?utf-8?B?SVZpd0ZLa2JKdExneXo1M3A0anZ2eGsrNlFPKzZ5MHpYNmZNYVRsWERwdmFT?=
 =?utf-8?B?b3REKys4VlhhRDh0ck5tSWNNdjJKZWMrMFViUWxWaWpSZm5vUk5OOEZScEpT?=
 =?utf-8?B?NnlHUHdrS2lQSHFWd1JYQkpvdm5oaGord2dkbGtrWGJUdkRhOXhvc1llYWoy?=
 =?utf-8?B?SWtpeW5EK2R5cy9IWnA1b3I1NDFud2V1TXV5N2xYT0JVK2RZbjdLQTR4MnB4?=
 =?utf-8?B?My9sWWxBR0hKYXBnWVprT3V3aGFCVHJQZkZWdzBZSCtkUlhzenRRRjNZV1NC?=
 =?utf-8?B?eWdad1I5VWtLQ2wyL1BCK3c1RWE2MjRFSDdROE5hc1dQL0hsWDJmeCs2aWRC?=
 =?utf-8?B?Ui90RlRzWXRTQ1d2WXJDQS92aHRsTC9iNTNCL3djamhjd3JEMGtXWnNlUGli?=
 =?utf-8?B?K3BpalVWNDN6cXBHb1FVUTJCUDMvMy9qbVhJaGpBaDJMcmNPMVlaWjJCcGJ5?=
 =?utf-8?B?ZnBBeTdtS21ablN2VWRTVTBCbmpHTUdsa2J6ZlNZSzRUckxTM0ZiWTN6TnpY?=
 =?utf-8?B?UlYzcUVyU3pvS3c0QkZJbk1SOTNRSkVTT2xSRE9lVzlVbStaWDg0THRkOUhx?=
 =?utf-8?B?YWo4dGJiaWJyN2M2dnJ6RkVOM3h1Ry9DZXR4R0lmdHJxWERrNG12NS9uN245?=
 =?utf-8?B?MW0xV0dMUTZseTEvakFqQkhxanRjS0hiNUtlVWFwV1hoSHRKbThxb1RVSFlS?=
 =?utf-8?B?bnBhS1NOeGo5c0ZTL09DdFlxcEMzVVptcEdGYytrVnJOcHJuVCsyMDI0NEYv?=
 =?utf-8?B?cS9sa3JxSmErVE5kWm5VZ1RlNUFNL09BTmkrWDN3aG5xak1uem14dmdld1Rj?=
 =?utf-8?B?UWhXWFIxVnYxYmc5UjZtMlJ0alVzaW16dGJrOGNOcnkvMFEzL29jZ3VzSVZR?=
 =?utf-8?B?dWhxWnlyWTNYUWJVRFVNcXRMc1Y1a2lYcXFPSlVacVY1bGtNYkVaWFliWTFo?=
 =?utf-8?B?aVNrNXFyQWJ0U21BZlMyUGdLY0s4aDh0djhGTHAxYVpxMXNjdzdEVWtIZnMz?=
 =?utf-8?B?T0V4WWFIendMaUVoc2hVNnNaOC9kUS8rMFNiVWVuMGRoMkQ1VzNNMHhuTE95?=
 =?utf-8?B?aE1XRDV0cEhjNGdlRERBWUd2a0UrNHArOXFCa0Fzd29NQkpqRmxXSDlUOVY4?=
 =?utf-8?B?MS8vOGVXVEEzL0I5V1pYTUs3eDhQc3BiOWdESFZtQnErYUtWaTZmZzVUa2hU?=
 =?utf-8?B?eWRjbzlLNStUUEZNRXNnUjZBSXorS1lDSk05Smc5djBKRmRtUG1oOHJwQU1k?=
 =?utf-8?B?NTlnUU4wZmkwaEZkQ2dRMmtIYnpValI5Rlp2d3lMTElPWXQwaWNOUGN0V2VG?=
 =?utf-8?B?bWdhbjRNd0JTY0UvVENWWTdKMUhmNDFibkM4dG1udUpRSmxjUE5ZS2NUYlp3?=
 =?utf-8?B?QkkvWXhlNFNETG9aZlR5OUZ2bVVyWWwyekdEZ3pBRnV0Wi85WURudXNISUxs?=
 =?utf-8?B?UmxiME1JN3hFT1RrZzg5ZXFKeGhpSEIvT1JSTW5xWEppV1hncVAxZW1ZVFcw?=
 =?utf-8?B?cW9uQXF0ZGtmbmdpektEWmRyM3drKyt5RXU5b3FmTkFlNU1nSnozUmVxYnNW?=
 =?utf-8?B?QXZkWU83aE9yWHovQXZHRkNBdWdZQ1lIM1RaekZHczZ1QlRCYXdVUnlDTmwy?=
 =?utf-8?B?bmUvelhuQk0vcVdzbS9Ka05CaE5hV3ZXUlZ4R294QWQxZG8yRUFwQ3ZPNUNI?=
 =?utf-8?B?VEJZZDdtTVV2Wko0QzJXdUMrWUc5bkhJZTNrZEw0Zy9UOGhyNk9CcGFVQnc5?=
 =?utf-8?Q?cgnb+3l187EKOKxE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8798B8F7CBD19845A8BEA20AAAFED0B1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sU5vScD+Iza7YnoHVsEL+xTiiOrjTBV/G9SY0X/bqV8YfkVDCxkG2kxD/uct0xsFDYe7h66ZtazxckybDdAmHQqsXD0bn0pFtWpTcDO6565KBYupwEdIB5tg9i9wQkEHr3ZJyiH6IcNMBevKQjWOaA9STAay63RKO0ns/2BzI7In9GsZKhYjhCFb9VqhRxIVJoPiDq47YvqXM7BNtlgi5rD4LxnNNdGYn1Ho50uHXinLQUUqwsOzS2qKpgtsZzHjfAZM0HBL7/tfAsZawH3f4yK/onmEHnWh+fzTJqLjw+9F3RWKVZ8FYXvBRwPtKRwcMWw8kCKlHfr1T9UMV5mOjA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb0a7976-62a4-45f0-44e9-08dee63f9489
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2026 09:16:28.2057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TXbnkEd7TgZsgueIncwV/et2n4iljnSmMPnhrFvzQ9kwwmxzLyswoKuCFYDZyRqHn3ajEYtngglQmKl2Powa+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB10511
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDIzOjM5ICswODAwLCBMaSBRaWFuZyB3cm90ZToNCj4gdWZz
X3NhdmVkX2Vycl93cml0ZSgpIGNvcGllcyB1c2VyIGlucHV0IGludG8gYSB6ZXJvLWluaXRpYWxp
emVkIHN0YWNrDQo+IGJ1ZmZlciBhbmQgcGFzc2VzIGl0IHRvIGtzdHJ0b2ludCgpLiBBIHdyaXRl
IHRoYXQgZmlsbHMgdGhlIGVudGlyZQ0KPiBidWZmZXIgb3ZlcndyaXRlcyBpdHMgb25seSB0ZXJt
aW5hdG9yLg0KPiANCj4gUmVqZWN0IGFuIGlucHV0IHdob3NlIGxlbmd0aCBsZWF2ZXMgbm8gcm9v
bSBmb3IgdGhlIHRyYWlsaW5nIE5VTC4NCj4gDQo+IEZpeGVzOiA3MzQwZmFhZTk0NzQgKCJzY3Np
OiB1ZnM6IGNvcmU6IEFkZCBkZWJ1Z2ZzIGF0dHJpYnV0ZXMgZm9yDQo+IHRyaWdnZXJpbmcgdGhl
IFVGUyBFSCIpDQo+IFNpZ25lZC1vZmYtYnk6IExpIFFpYW5nIDxsaXFpYW5nMDFAa3lsaW5vcy5j
bj4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVr
LmNvbT4NCg0K
