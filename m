Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBA013C68A;
	Tue, 23 Jul 2024 07:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721719685; cv=fail; b=GgkP4odoCgqt+ob1Wcy8gaAFXtUSa2+qqNG7taCyln7nbedupaBt2yZFzFdMtRsg2Fh3/u29gIzWDJRYVHEz5YC32YfDrvlJPdAacFG6M2eALkJMw73oj8oeOmoeXW1jJJr8MzWeHsHeJxAE/Ao2esECctbNVnc3A/naE+baliY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721719685; c=relaxed/simple;
	bh=pQnJ6FM72D3DwleGVKbZ5U4Rl4SUvyqCBTN21U7jHF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m/5FBPJDWPv6Phxbx1YFo7Ed+BAo2GXszav9HNKXMin1CdH6lVjfd22le4euRKs4L0djAOa0iuE2fndM9/iIxljQjayq/4MRjZZlxOBESCyizlEqD9l0OdlqF7aNAb4ws78QXyE+EoC/SwxgKh2Y7e/YgSdLFXSQBrpig4aYAU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=R+6ygTgQ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gx4/TCCB; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="R+6ygTgQ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gx4/TCCB"
X-UUID: 12b70e1048c511ef87684b57767b52b1-20240723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=pQnJ6FM72D3DwleGVKbZ5U4Rl4SUvyqCBTN21U7jHF4=;
	b=R+6ygTgQuPVRDUIxKfyQECOxKKegLqZeWgaoqoY/mv7rtF1WUf+1nkdebRJJ7y2m87TBLAv7FWP4L/11ODl/5S/rWvoVeZj+sUGA72WHgGktm4nfULVO6yGr1oD5SI9BFrAPU3xHiZWq7ntk3hk4yT/ifnOuvwux/geTDhLKwLA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:60dc053d-b84b-4639-b094-5e1bf2308c45,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:4101acd5-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 12b70e1048c511ef87684b57767b52b1-20240723
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 987379495; Tue, 23 Jul 2024 15:27:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 Jul 2024 15:27:53 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 23 Jul 2024 15:27:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hbM2BFNZw1ajKTrM3TCOS+niw0xb1ZCrE2APbquIwy06dBuNsHF6uaeCEdPNF/TkiI+e2VITe45JreTg3KY3WUJZmOLEy1E719Ax6ydXS34flqLlC+s/yoG3uJ7YIZ8tqBcs3kxgc9hAf7iF+0VlrxlFoJYeh97SxOiJWGpfmpYQlZ+VSgD/H5wBYPxxcxKbOmXudTGQLz6Dumqfoc94P6z6ZpeZ2B8kdq1QA8svMy0RNgFcJVNuKa1nZ//jXbivJNm9z5/VI5QjEoOyYykna0qwkEze1jB3IMskF9TWSN3oEE/ANoZZiSuB6BG0UA29tZPdqw5PAQ3cMRNhx0A/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQnJ6FM72D3DwleGVKbZ5U4Rl4SUvyqCBTN21U7jHF4=;
 b=BYFZqmQVB6nNG0Zg02fabU5xroS7uoqANopq2PIAIez8mfgeJ+LFremlPxjaLHiGY9jSgapUHBO/TOtRRQ4Ef8P6/D9aqte6Qy6DU4Muy73XlWQK44fKIOVwSlXObbk5+peJS/TOVuqzZm0CaUEFui2a8aiZjCH3SjPaj5hg0E3BD7E3n4wzjzy45XMlAYnExNdyeDpqqfEkNm8e7B3Due1HagrBZ4Fy3qbYv2Hh6DBMlouQNDkv4OhML4uu9ubWYatykq5hX6m70FtikUPVGH2fXxTior3n8mivhh0Xbf7fWdlmyKHUSKWhoQ76NIYRtOWDeMyhYg1HR9QqzLocaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQnJ6FM72D3DwleGVKbZ5U4Rl4SUvyqCBTN21U7jHF4=;
 b=gx4/TCCBuYxGopBaTKq/w+nP7EtfxyWmnzHh8OW+5VayDOwQqEYqd5Y5MVS7WOIRLiwjPlZhTbwSpaxSVlAxQCLhYwtAzxRDHrCvMyalARl0DkPfTawLRmjWQ7jI57bs3xUuCfB8+ncxLckg4Zk8eIkGng7lsBKrrIz+8Y1obDg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7182.apcprd03.prod.outlook.com (2603:1096:400:339::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Tue, 23 Jul
 2024 07:27:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7784.016; Tue, 23 Jul 2024
 07:27:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
Thread-Topic: [PATCH v4 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
Thread-Index: AQHa2KgM9/zJPG/vaESladH9Cpts7bID8lIA
Date: Tue, 23 Jul 2024 07:27:49 +0000
Message-ID: <5370a13d48d42d952442040f71301acf30f9a5ff.camel@mediatek.com>
References: <cover.1721261491.git.quic_nguyenb@quicinc.com>
	 <44dc4790b53e2f8aa92568a9e13785e3bedd617d.1721261491.git.quic_nguyenb@quicinc.com>
In-Reply-To: <44dc4790b53e2f8aa92568a9e13785e3bedd617d.1721261491.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7182:EE_
x-ms-office365-filtering-correlation-id: f5409805-9bb5-4d1d-846a-08dcaae8f490
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UC9rL1Z2eXl0WWhmUjZFd0JPd3V6SFYwaUhvTDdMS2ZESGl4d3BrRm1CekV4?=
 =?utf-8?B?Tk5xUjdlMkhCR094TmJocVh6WXk3cVp6UkUyVVhkQTJjZWJMdk9SVHE4eExQ?=
 =?utf-8?B?RHlvdmdYT1htL21wdW93dnh2M3VlR0lrUFpRN2JuZkFRRk5US1hUd3Y2cEs3?=
 =?utf-8?B?WFdjVkc1ME5ONXMwWEtoajVOSEZuVnlLQWVRd0Z2T1NpczdwQURCY3I5TVpQ?=
 =?utf-8?B?NmRkRm1QbDlYU01iejFyeXdrOFkyNmRYcXRTT2pSU3VQdndjOXIxbzlwcjlS?=
 =?utf-8?B?UlV2UWUrVUpXYzFXc3B3MCtRazZLcWFnN3B3SVJtb2ZucmVyOUVjQmFycVRo?=
 =?utf-8?B?VmF4Uk5QZUNiMExmdi9hYnVSVUMwd3huWUFtZXdDTkdLNThsOVEvMGhuTS9w?=
 =?utf-8?B?ODRhWTAvRTNsRVFSRHlPTGhEbENQdThROVEvczVKcURIZEhMWm9tU1lOZ3Rv?=
 =?utf-8?B?eVBBeDlXamZTd1Y0T1d4UEhzQ21lSnN2eXljUWNRdHk1blB2NExJdlFXaktz?=
 =?utf-8?B?SDE3MWQyRFFIUGp5ZkI2Mkt0K09DckpweEljSGNPaEc3MUoybHhoTkpXdXVN?=
 =?utf-8?B?WlFTMzVNc1lNT3QvVEFRMDRBdjV0MkZUcFppd3NydEY0ZHc0MklWZWlVazI3?=
 =?utf-8?B?QlV5NTVFTVpTNGc1dDNTV3c0c09GcmwrcThlbDd5bnJqdlBwSGR2TmhOMVJt?=
 =?utf-8?B?cnpOM0hTTG9GTXRISGVudHY0RXh1bDFJZnQyUG82K0RHZlhOcUtqNEhQRFpt?=
 =?utf-8?B?czh5MTd0Yy82elBYc2RuNk9OL1Q5YVR1NjQxVkZSVDBVVjlPeGJReUpsZGZV?=
 =?utf-8?B?UTFxTURmaHNjdi9nWDFzczgwTEwvS3IzRmdiQ0hzMEZyTTQvZmFsWkxhc3Fr?=
 =?utf-8?B?UTdLOTZXa0NWOXB1a2NKWGQ5OVNkQlFrM2R5anN0R3JkTXVsNFpIZnFPenAw?=
 =?utf-8?B?RFRqT2NIK1U2RWZaUTJqN205R210VjFTNFUyckVBZVlKakdnYTFRZnUzcm1R?=
 =?utf-8?B?dXFiaVcrcDNaalY5bWthajE5aE90cUM3VVlBdFZ2eTJobENNTFg2L2lzYWJz?=
 =?utf-8?B?N2JiVzlHaVR6Q1p4YlkyeGpjcDI0QThudjgzS3VnNURYamtKSVk2bnBlc2Fw?=
 =?utf-8?B?R3IvaWlhclF5NnJsODlKc3hXeEhoeWlxd2l2Q2VROUpUN1JDQ0xwWHREaGha?=
 =?utf-8?B?YXhobVV2bmpEMVBudVZIL2VrcFI5TVVnNnl5cERjNzNIZWRDYXZqVEtNN1Uz?=
 =?utf-8?B?YktxNGtlTkVRMVJxVkpRU0RwSXloUmtvcnVOSng2V3psVWlVNVpEMmo0bC9n?=
 =?utf-8?B?WG5MN0V4Z1JRV2FsZG0rb09kKzJKTUNrYUhqMUhaSWdtY0pRZWk1QWovczBL?=
 =?utf-8?B?WXp2eHlaYUViUWhKV0s3TnZ6bEl0V3pNblUxTVpMeE45a1FCbWQ5VmIyTm5k?=
 =?utf-8?B?ZklScE12VHpIRnRnT1hxcEl2SEZSL3VqRUhaU3AyRElYK3dDQ1A0MmJtZVpl?=
 =?utf-8?B?aEF3VzhBRk5TQkJBcjduWFdWR21Hc2ZEajRCeWpJOStYbGVkSmpjenVMeFBr?=
 =?utf-8?B?Q1ZSb05ZdXJpTHdRdVNDUTlpZDFnNEZyWnBUT09mZlNoSStVSHhKclJpSld1?=
 =?utf-8?B?UXR1cnE3ejhtLzZ6UHNtZXVZYlBpeW8ydXpEb0l0clVTbnRUN0o2Zi8yVjJO?=
 =?utf-8?B?bytPK2FMQlliaXZhallDRnNjOWljL0VUbGV1aksxTzdjS005MDdvVktUYnNN?=
 =?utf-8?B?VFI4a1JzdFlqSy9zTDZYMVR2R21BTUJYbjhnWk0wS3FTbWJGY1lmREhnRmxT?=
 =?utf-8?B?dkp0OW1VeDJzN3VGb3FTT2FiejV4RDFZRmczL2dRMnYxMGpyNU0xZWp0SmlL?=
 =?utf-8?B?VmFtSm9RQ2NQM3pHY2V5bmVHdXdicDNodzFaR0JhYi9jT1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk44TVhZWG5uUHQ2TURvVzRXWFRKQ1oxVXVTMFlpOVBRUXV4ZmdGMTQwc1NV?=
 =?utf-8?B?T2RvcFFJZkYrVXRvU0lQWVBpWGZqU2owT1d4V0liRVlFaHNKTnA4QlYvRGxr?=
 =?utf-8?B?aDk5YS93aCtkWGJndkxnQTRiL3V0NEV5UExqNFFjWUU2bXhjRnlJbUJ2cnl1?=
 =?utf-8?B?VCtaaTI3MjFEZUh4R0VQU3RtZUd5OS9uL0hPSTZQWkEyeFMrWnhXT293N1Ey?=
 =?utf-8?B?NlFBYjdzelJ6UVNTbjU1S0FNaEdyOHJHMFhJVlJpeWpyOUsvemYvNUkwd25B?=
 =?utf-8?B?M3NaSVpBU0tHRUdiK3NHV1d2ZUtsQjA0TzhaZTVFLzErczNXWkh2eUhGVlJa?=
 =?utf-8?B?TUduelg1c1RUM21QdjBta0dDT3RUTXQwY3ZFYXBmYmRQaWd5WGxhNXNlQUIx?=
 =?utf-8?B?U013Z1dkRXIyTi9WTFk1QUpNc1V6SDcrV2IyZ0J5M0RlWklNZGZZcUZFaXZR?=
 =?utf-8?B?TGVWZ1BrVmQybkdjL3lsbzd3bktTTDdXZFo2SkppSndydkcvNFE4MkdtbGNp?=
 =?utf-8?B?V1NEaHNRUUljdE51TElrM3VnWVNSRHdVc2YySitXVmVUYytHODg1R0Rzc2s0?=
 =?utf-8?B?cmNoTmNINHZQZU5nWFFlY21qOURQZCswY0RrazZuZitLZFR6RnFsYXkrQ1d0?=
 =?utf-8?B?ck9DOUxCK2ZmOVYrYUthWnMvMklXMG5zMS9KZlIyM2U1L3NUOXlybWJrdjVG?=
 =?utf-8?B?clpxMmV6VjBST2FmQzVRNVlTU1crbFhpckI3UHQxZU5DZFJZMEZSdnV2ckdz?=
 =?utf-8?B?RnFEODFML2M4M1hIUFBjWG5XYXFPdVg4VnEyWnpTUi9MTXBDZENIaVJjd3NC?=
 =?utf-8?B?SDNDazluZEtieE1jeENsd241Z0hTUzZhYmZ3SWxDc1hRM1lZN1NaN2dvb2dO?=
 =?utf-8?B?ODNqVnhEZS9pUDZzQXIyQU52b3FjVmNpM3gwbVdCcGZqSFBrR0h5MjNaZ0dS?=
 =?utf-8?B?QnhOeFBKOWNYMUhPU2d3RklMRW9Lam1EODgvRVN6aTVMU1Q3WjF3ZHdMaUJw?=
 =?utf-8?B?M3VmL3MyNEs1a21kbGpjRFNybjZndjlCV1hJaHd0REczSS9Pa0FnS1NtYkNo?=
 =?utf-8?B?aVJPZ3BidlBXNG0xS1QzUWFVci9FRjNzZkNYY0xiV1g2blNIMkxrVm5NS2xW?=
 =?utf-8?B?S0NsQ1dYUk84b2N4a3ppeHlNMXpjVS9LR09OVmdSTGg1bExYUUNuU2NOOE45?=
 =?utf-8?B?NWhWUTJJVkJBZDFLSzU4cXpvQ09ESGIrdDVMVWlTME1WR3dBVFJ4UTFBZXJ0?=
 =?utf-8?B?a0RFeWdnZjM4bThUaW9SUldMSUVBbkV6TEQxYUFhQTh5RGJaQmh2WlR2dUZo?=
 =?utf-8?B?Q3FGUngxUnQyb0tRYzZUN0tpOHpBRW12emVjNXpkQmVsMW51ZWx2UURMbC9G?=
 =?utf-8?B?ckx2eFdnV2FLZFJ6QnVvQUlwK0xXdTh6VHBPdVBMa2FldXhsUUdhOHV0NG1G?=
 =?utf-8?B?QzMrdDAvVHc3WGlqZDZ3QXZ0WGg4VWV5bDJYT2hPeHNJbUl2d2VPV3JITTJx?=
 =?utf-8?B?dWVHRmJtbHRBRDBxRFJiNUxLVmdlRlhQUUxUclJpOUlXMFBZUnlwNkZEYjNM?=
 =?utf-8?B?SndpbDdUemxNdS9ob1ZxbnY2aWluWVdYSXZHL1JtV2ZteE84RncxV3p0Y0tv?=
 =?utf-8?B?NVZFWEtIdEFQMzNPNzZhVlEwM2JqNVIyOUxXTE5lQUUyQU5zeVhuUlJLeE43?=
 =?utf-8?B?SU9ZVEk4NHZydXdhZVovVHlWMmpiUG1FRXBDQ0k0K0dDSjFXRVFIWEJTMHlY?=
 =?utf-8?B?L082U25ydGFJL1VObXFwNi9STmxzWm5rdjMyVS94aHNRVUVMckNBSU8yRTlG?=
 =?utf-8?B?MGlic3l0bkFnNFI2a3QzYUo0a2kvTlhxR3kwYy9wNzJYMjloUGdzOVNqS3FD?=
 =?utf-8?B?SU9OaHdTUDhwZDM3RlhHdmIvOG1XV1NoUURGbFZQT0YydnM3ZWw1M0pwaU0w?=
 =?utf-8?B?RlJJbW5iakxaNWUvQ1NpdmxzQmRvTk9IWnorTlR0YWVzSzBYaHBmS2ltOTFM?=
 =?utf-8?B?cXA1dFpXQVU5aldhbGtvV3NrZytnSUxuaXVRYkhSNlJUY2wvcjVWODBhR2dO?=
 =?utf-8?B?aXVGemVId3dRelFIekJTdGE2Wk5COEJKcUgvTWllcG9LNnRKNUtpWktJM2dt?=
 =?utf-8?B?WndWdHJidUtUVmpSUEhYQ3h4NkdKelVVYXI2MjMxZnhtOGN5bi9oZTBiekR0?=
 =?utf-8?B?dlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DDCF9564D066544960883A390C57388@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5409805-9bb5-4d1d-846a-08dcaae8f490
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 07:27:49.1842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4AI9cle7VVSqu/MwCUaxsfQuDtPLKfmFswhdmWV4MkTOGY1H8NCQvhHNDDwLreg9wfRinSepFMF0XvSqJRaIiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7182
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--18.875700-8.000000
X-TMASE-MatchedRID: UWn79NfEZzbUL3YCMmnG4ia1MaKuob8PCJpCCsn6HCHBnyal/eRn3gzR
	CsGHURLuwpcJm2NYlPAF6GY0Fb6yCp4tFtWKBvRpG5mg0pzqmX5ezmeoa8MJ8+ouc5Rcf1B0BIi
	ptXNoj0aCukcfrdcoGcATk+O/i8f9Gf0D7RCus+wlAj6R+xEl2gzWiCCFQQMB4uxAgOavdLnHES
	Ua8/SV+PbYZPZ20YJltPcdouA3AZ7dM4TtXgVTNKCGZWnaP2nJYKeVO7aMEHPfUZT83lbkEFJtv
	0AtNsDWH5TnHYZFBIhGW/U1VijAOWdvGUEuKvScDko+EYiDQxE7r2Gtb9iBYc1BXOF9hjmy7iii
	6/GaBajL7a7vhpw6CJGTpe1iiCJq0u+wqOGzSV1WdFebWIc3VsRB0bsfrpPIXzYxeQR1DvvsgFo
	z9Cg/vthkqT1/eTr4cXo1jjTZA5B363OPlAo6zoi56+nYUORz
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--18.875700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	6E2887C1C3427C106DA1922B8779D36B9DA82516997FBE2630062C56FDDE15852000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA3LTE3IGF0IDE3OjE3IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiAgCSANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0
aGUgY29udGVudC4NCj4gIFRoZSBkZWZhdWx0IFVJQyBjb21tYW5kIHRpbWVvdXQgc3RpbGwgcmVt
YWlucyA1MDBtcy4NCj4gQWxsb3cgcGxhdGZvcm0gZHJpdmVycyB0byBvdmVycmlkZSB0aGUgVUlD
IGNvbW1hbmQNCj4gdGltZW91dCBpZiBkZXNpcmVkLg0KPiANCj4gSW4gYSByZWFsIHByb2R1Y3Qs
IHRoZSA1MDBtcyB0aW1lb3V0IHZhbHVlIGlzIHByb2JhYmx5IGdvb2QgZW5vdWdoLg0KPiBIb3dl
dmVyLCBkdXJpbmcgdGhlIHByb2R1Y3QgZGV2ZWxvcG1lbnQgd2hlcmUgdGhlcmUgYXJlIGEgbG90
IG9mDQo+IGxvZ2dpbmcgYW5kIGRlYnVnIG1lc3NhZ2VzIGJlaW5nIHByaW50ZWQgdG8gdGhlIHVh
cnQgY29uc29sZSwNCj4gaW50ZXJydXB0IHN0YXJ2YXRpb25zIGhhcHBlbiBvY2Nhc2lvbmFsbHkg
YmVjYXVzZSB0aGUgdWFydCBtYXkNCj4gcHJpbnQgbG9uZyBkZWJ1ZyBtZXNzYWdlcyBmcm9tIGRp
ZmZlcmVudCBtb2R1bGVzIGluIHRoZSBzeXN0ZW0uDQo+IFdoaWxlIHByaW50aW5nLCB0aGUgdWFy
dCBtYXkgaGF2ZSBpbnRlcnJ1cHRzIGRpc2FibGVkIGZvciBtb3JlDQo+IHRoYW4gNTAwbXMsIGNh
dXNpbmcgVUlDIGNvbW1hbmQgdGltZW91dC4NCj4gVGhlIFVJQyBjb21tYW5kIHRpbWVvdXQgd291
bGQgdHJpZ2dlciBtb3JlIHByaW50aW5nIGZyb20NCj4gdGhlIFVGUyBkcml2ZXIsIGFuZCBldmVu
dHVhbGx5IGEgd2F0Y2hkb2cgdGltZW91dCBtYXkNCj4gb2NjdXIgdW5uZWNlc3NhcmlseS4NCj4g
DQo+IEFkZCBzdXBwb3J0IGZvciBvdmVycmlkaW5nIHRoZSBVSUMgY29tbWFuZCB0aW1lb3V0IHZh
bHVlDQo+IHdpdGggdGhlIG5ld2x5IGNyZWF0ZWQgdWljX2NtZF90aW1lb3V0IGtlcm5lbCBtb2R1
bGUgcGFyYW1ldGVyLg0KPiBEZWZhdWx0IHZhbHVlIGlzIDUwMG1zLiBTdXBwb3J0ZWQgdmFsdWVz
IHJhbmdlIGZyb20gNTAwbXMNCj4gdG8gMiBzZWNvbmRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
QmFvIEQuIE5ndXllbiA8cXVpY19uZ3V5ZW5iQHF1aWNpbmMuY29tPg0KPiBTdWdnZXN0ZWQtYnk6
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBSZXZpZXdlZC1ieTogQmFy
dCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QuYyB8IDM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jDQo+IGluZGV4IDIxNDI5ZWUuLmQ2NmRhMTMgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
Yw0KPiBAQCAtNTEsOCArNTEsMTAgQEANCj4gIA0KPiAgDQo+ICAvKiBVSUMgY29tbWFuZCB0aW1l
b3V0LCB1bml0OiBtcyAqLw0KPiAtI2RlZmluZSBVSUNfQ01EX1RJTUVPVVQJNTAwDQo+IC0NCj4g
K2VudW0gew0KPiArCVVJQ19DTURfVElNRU9VVF9ERUZBVUxUCT0gNTAwLA0KPiArCVVJQ19DTURf
VElNRU9VVF9NQVgJPSAyMDAwLA0KPiArfTsNCj4gIC8qIE5PUCBPVVQgcmV0cmllcyB3YWl0aW5n
IGZvciBOT1AgSU4gcmVzcG9uc2UgKi8NCj4gICNkZWZpbmUgTk9QX09VVF9SRVRSSUVTICAgIDEw
DQo+ICAvKiBUaW1lb3V0IGFmdGVyIDUwIG1zZWNzIGlmIE5PUCBPVVQgaGFuZ3Mgd2l0aG91dCBy
ZXNwb25zZSAqLw0KPiBAQCAtMTEzLDYgKzExNSwzMSBAQCBzdGF0aWMgYm9vbCBpc19tY3Ffc3Vw
cG9ydGVkKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpDQo+ICBtb2R1bGVfcGFyYW0odXNlX21jcV9t
b2RlLCBib29sLCAwNjQ0KTsNCj4gIE1PRFVMRV9QQVJNX0RFU0ModXNlX21jcV9tb2RlLCAiQ29u
dHJvbCBNQ1EgbW9kZSBmb3IgY29udHJvbGxlcnMNCj4gc3RhcnRpbmcgZnJvbSBVRlNIQ0kgNC4w
LiAxIC0gZW5hYmxlIE1DUSwgMCAtIGRpc2FibGUgTUNRLiBNQ1EgaXMNCj4gZW5hYmxlZCBieSBk
ZWZhdWx0Iik7DQo+ICANCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgdWljX2NtZF90aW1lb3V0ID0g
VUlDX0NNRF9USU1FT1VUX0RFRkFVTFQ7DQo+ICsNCj4gK3N0YXRpYyBpbnQgdWljX2NtZF90aW1l
b3V0X3NldChjb25zdCBjaGFyICp2YWwsIGNvbnN0IHN0cnVjdA0KPiBrZXJuZWxfcGFyYW0gKmtw
KQ0KPiArew0KPiArCXVuc2lnbmVkIGludCBuOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlyZXQg
PSBrc3RydG91MzIodmFsLCAwLCAmbik7DQo+IA0KSGkgQmFvLA0KDQpuIHR5cGUgaXMgdW5zaWdu
ZWQgaW50LCBzbyBpdCBzaG91bGQgYmUga3N0cnRvdWludD8gDQpBbHRob3VnaCB0aGV5IHNob3Vs
ZCBiZSB0aGUgc2FtZS4NCg0KDQo+ICsJaWYgKHJldCAhPSAwIHx8IG4gPCBVSUNfQ01EX1RJTUVP
VVRfREVGQVVMVCB8fCBuID4NCj4gVUlDX0NNRF9USU1FT1VUX01BWCkNCj4gKwkJcmV0dXJuIC1F
SU5WQUw7DQo+ICsNCj4gKwl1aWNfY21kX3RpbWVvdXQgPSBuOw0KPiArDQo+ICsJcmV0dXJuIDA7
DQo+IA0KDQpDb3VsZCBiZSBqdXN0IHVzZSB0aGlzIGxpbmUgaW5zdGVhZD8NCglyZXR1cm4NCnBh
cmFtX3NldF91aW50X21pbm1heCh2YWwsIGtwLCBVSUNfQ01EX1RJTUVPVVRfREVGQVVMVCwNCgkJ
DQoJCSAgICAgVUlDX0NNRF9USU1FT1VUX01BWCk7DQoNCkl0IHNob3VsZCBiZSBtb3JlIHNpbXBs
ZS4NCg0KPiArfQ0KDQo+ICsNCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3Qga2VybmVsX3BhcmFtX29w
cyB1aWNfY21kX3RpbWVvdXRfb3BzID0gew0KPiArCS5zZXQgPSB1aWNfY21kX3RpbWVvdXRfc2V0
LA0KPiArCS5nZXQgPSBwYXJhbV9nZXRfdWludCwNCj4gK307DQo+ICsNCj4gK21vZHVsZV9wYXJh
bV9jYih1aWNfY21kX3RpbWVvdXQsICZ1aWNfY21kX3RpbWVvdXRfb3BzLA0KPiAmdWljX2NtZF90
aW1lb3V0LCAwNjQ0KTsNCj4gK01PRFVMRV9QQVJNX0RFU0ModWljX2NtZF90aW1lb3V0LA0KPiAr
CQkiVUZTIFVJQyBjb21tYW5kIHRpbWVvdXQgaW4gbWlsbGlzZWNvbmRzLiBEZWZhdWx0cyB0bw0K
PiA1MDBtcy4gU3VwcG9ydGVkIHZhbHVlcyByYW5nZSBmcm9tIDUwMG1zIHRvIDIgc2Vjb25kcyBp
bmNsdXNpdmVseSIpOw0KPiArDQo+ICAjZGVmaW5lIHVmc2hjZF90b2dnbGVfdnJlZyhfZGV2LCBf
dnJlZywgX29uKQkJCQkNCj4gXA0KPiAgCSh7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KPiAgXA0KPiAgCQlpbnQNCj4gX3JldDsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gQEAgLTI0
NjAsNyArMjQ4Nyw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbA0KPiB1ZnNoY2RfcmVhZHlfZm9yX3Vp
Y19jbWQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gIHsNCj4gIAl1MzIgdmFsOw0KPiAgCWludCBy
ZXQgPSByZWFkX3BvbGxfdGltZW91dCh1ZnNoY2RfcmVhZGwsIHZhbCwgdmFsICYNCj4gVUlDX0NP
TU1BTkRfUkVBRFksDQo+IC0JCQkJICAgIDUwMCwgVUlDX0NNRF9USU1FT1VUICogMTAwMCwgZmFs
c2UsDQo+IGhiYSwNCj4gKwkJCQkgICAgNTAwLCB1aWNfY21kX3RpbWVvdXQgKiAxMDAwLCBmYWxz
ZSwNCj4gaGJhLA0KPiAgCQkJCSAgICBSRUdfQ09OVFJPTExFUl9TVEFUVVMpOw0KPiAgCXJldHVy
biByZXQgPT0gMDsNCj4gIH0NCj4gQEAgLTI1MjAsNyArMjU0Nyw3IEBAIHVmc2hjZF93YWl0X2Zv
cl91aWNfY21kKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IHN0cnVjdCB1aWNfY29tbWFuZCAqdWlj
X2NtZCkNCj4gIAlsb2NrZGVwX2Fzc2VydF9oZWxkKCZoYmEtPnVpY19jbWRfbXV0ZXgpOw0KPiAg
DQo+ICAJaWYgKHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmdWljX2NtZC0+ZG9uZSwNCj4g
LQkJCQkJbXNlY3NfdG9famlmZmllcyhVSUNfQ01EX1RJTUVPVQ0KPiBUKSkpIHsNCj4gKwkJCQkJ
bXNlY3NfdG9famlmZmllcyh1aWNfY21kX3RpbWVvdQ0KPiB0KSkpIHsNCj4gIAkJcmV0ID0gdWlj
X2NtZC0+YXJndW1lbnQyICYgTUFTS19VSUNfQ09NTUFORF9SRVNVTFQ7DQo+ICAJfSBlbHNlIHsN
Cj4gIAkJcmV0ID0gLUVUSU1FRE9VVDsNCj4gQEAgLTQyOTgsNyArNDMyNSw3IEBAIHN0YXRpYyBp
bnQgdWZzaGNkX3VpY19wd3JfY3RybChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBzdHJ1Y3QgdWlj
X2NvbW1hbmQgKmNtZCkNCj4gIAl9DQo+ICANCj4gIAlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25f
dGltZW91dChoYmEtPnVpY19hc3luY19kb25lLA0KPiAtCQkJCQkgbXNlY3NfdG9famlmZmllcyhV
SUNfQ01EX1RJTUVPDQo+IFVUKSkpIHsNCj4gKwkJCQkJIG1zZWNzX3RvX2ppZmZpZXModWljX2Nt
ZF90aW1lbw0KPiB1dCkpKSB7DQo+ICAJCWRldl9lcnIoaGJhLT5kZXYsDQo+ICAJCQkicHdyIGN0
cmwgY21kIDB4JXggd2l0aCBtb2RlIDB4JXggY29tcGxldGlvbg0KPiB0aW1lb3V0XG4iLA0KPiAg
CQkJY21kLT5jb21tYW5kLCBjbWQtPmFyZ3VtZW50Myk7DQo+IC0tIA0KPiAyLjcuNA0KPiANCg==
