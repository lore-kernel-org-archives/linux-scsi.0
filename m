Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D72712AAF7;
	Thu, 15 Feb 2024 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996835; cv=fail; b=W641wpxX2nj19RX6H3lbzBeA8KmLcOV8+OlPZwnTycCMvzVrKucsDwmt2Adf8ArmhuKO9Zn5xZzg4G1TXaC4xg5f3aiHCUGaQdOmiISJ6tzj1Wp6FBuQichWfUXE+jPTbMQFUcLlfj6KPCB4M/qckTebdoA1NBmlY4kYQSGRVQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996835; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TJS513Qx2GIdQ3t/Ldjl3NOdAdxDTFQFDsPmiuOWMPVemMEwYaoRhEAYbYR3rNGWeDb3j4B/rOC+aVeb+teEvE8RmOnhfd3GKrHjJ4A6jlY7EWHD26d7rFOgok1t+SPt27+BfxZ3ggBax9fCJlahrKNLrzaHfkqUjokyax8Egso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q0/AhDgD; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=iKG+to1L; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q0/AhDgD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iKG+to1L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707996833; x=1739532833;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=q0/AhDgDo4YEYwWbmNI2R389YDnjHEXG8gNoKtuXDjkB+ZaO5oOEfPOt
   +xdZEeyc6SGxiZehPUAQ5EtbXiNo+SI+J3vQkBWlvFA1r+epiISSrw8kY
   GSlbZNZZIJxn7InrGs7+VqAV6jzQu3EDidAZzuu2MaRCou84bq/6XxNEe
   NLESup9BwF5NqgUHzKijhIgdKhVL/CGxq+UeE9Rmq7jRuUNbxtETG4rwb
   ZJU8x5sabBDiIA72+WtyEY0vhiPNz53noRksJC5xr+Is3JhfyL23Jyt5o
   s0FC+Pu8zcjNSrVPLRaPScAZfXPzmIIJC4wCDYBdcDdPzz2sJq0rJnA05
   w==;
X-CSE-ConnectionGUID: h+oLUXptQd+n2Z1xP1+Mew==
X-CSE-MsgGUID: quvRlq1ZTgy4I7HePTR2Tg==
X-IronPort-AV: E=Sophos;i="6.06,161,1705334400"; 
   d="scan'208";a="9317857"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2024 19:33:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmnCtxHcNeL3hY8FDyhmZjbMRWRs6Atyyml9EaRaAK23zm/yd5k5ghMVRlEGq7VxtDn7P4Omi1l/zDUMMvRG9mhUQjc/R+58ChaPNgaDZpE1K1F5AcKVvgia/HRt1Xk0mhLFrlXUTQDAy9S+vMORD7RayRTzQqmf626iXqSRiaABuftygau2zXAhUwSfnXmpDWhBbm3Bb19V+J/BZNMhKWFdQmWRpQwkgGiGsgGvhbbl3jxJ7vGu6pvPLBuH3wmgyOYDIgvmQqwMVbD+bk3dYEa0Ky32+wI7mF980bCQg2ep2BaiTeikvXjQ9dYpuXEADe6qZ1iC3E8BowPSvnbytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=P1VE/ugxAC0U5HzwrzHwOAQTNPSqrWyKVUG0rhMMCafR02sRJqvotajbL5l70zun2MFzgJZBj5VorFeug1gFG2MnHtnVl+Javxq3sDEJ++hfs8zAgGPasnNNHu5jx4FDHy6ut9MktyLHrxZ/MMjDeQ1+txZwbsLQLayuwO6qbvQx6Gmkc8uOxfxxlt9DwMauUzdRVeWsGZpJ7bhH2VpyMxprIrfiHQ5QfYmJs+ZexNioG/g36cGySX3MWrzvGLxwI+yEbraGyM7/mcuQsmeczSkA1UgLyzD8Fz2AP+U1dV4UUaDofl9Nm+ewAEASFeKIe97EU0/RfdVJ5An4rNXA9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=iKG+to1Lbi5LzYSnf5Kig1GlKT5bE/g/MuMayM9/djGxhTF99BE+u2jleioPd6k9E7alrWKWR6i1YAA65jxBaLemgHz/Ei6sYmHQVVb0s19sq2bpnkgPBoulkt/rDnqp9xE1nyPNk82vY4E/yyJhO1WPZDmUfnVGqJBL64zWzFk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB7002.namprd04.prod.outlook.com (2603:10b6:5:241::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.27; Thu, 15 Feb
 2024 11:33:49 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::73c4:a060:8f19:7b28]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::73c4:a060:8f19:7b28%6]) with mapi id 15.20.7292.026; Thu, 15 Feb 2024
 11:33:49 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Naohiro Aota <Naohiro.Aota@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: pscsi: fix bio_put for error case
Thread-Topic: [PATCH] scsi: target: pscsi: fix bio_put for error case
Thread-Index: AQHaX1U764yqILWaPEC+VpeMsby4hrELRwWA
Date: Thu, 15 Feb 2024 11:33:49 +0000
Message-ID: <d70666bd-b330-4269-a8c5-a3326dcb93e9@wdc.com>
References: <20240214144356.101814-1-naohiro.aota@wdc.com>
In-Reply-To: <20240214144356.101814-1-naohiro.aota@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB7002:EE_
x-ms-office365-filtering-correlation-id: 5c483b28-7610-4e0f-161b-08dc2e19fae7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 /8N39iAzmhndh+GPKH3sOoRb9vjTrF6LDPiVBByPlvLGV4HY0qONUB2ess1tSXPYPhDIYNDdsbyZZmRwZwNB/A2+FsIgyLKIsTmdcsh+BCPKS9dVy/DIOcyq5z9fLrsY6ec4S34mIeh8cQ405eaio8ga3qYpFt/7STdjnErG1AcoWw7m3FmnmyGx6YyD+o4l+jaU8sde3tJYjsOH4QO5PlYj1UAAxp8WEpDACBce/Fn76ebhSq5pTE/Tf3DCfi2fDONlqcbXfTsnQs4ipjN+3t9TIP8a/7D4r0rqGeXUZn8NVSVRsDRyAoIAjPBf7LKbhBTL/UvlytAbSYr1GwhYA54iAwpfTTerm0WBcyEb1NSCd9t8FXHymBzIHJIaBc+ib8D1pVdyTZzVMWthu+sP7z1qISWXfnSaQsY8VjdBFLtINeanxpnILO408fT6pmauX3ocUd/tVlz6Nx8msydjdb/vnhGuPgVya/XzPairSo3gOOGVT3MpE/pxYwX2kqo7znayJXnZkHbGKAI0sotgFwj7VdX2wEhY3gBwHh0WH9f3hV+x2vvZ/Zb/Ax3vctv4qBld0BMiEV6r6mzyIaN5n8j3jvnbYmbcwK5PWWveN8VLaivITZ9yldC6vw/oTWZC
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(396003)(376002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(8936002)(8676002)(4326008)(2906002)(5660300002)(19618925003)(38070700009)(2616005)(38100700002)(26005)(86362001)(36756003)(122000001)(558084003)(82960400001)(31696002)(66946007)(316002)(66446008)(66556008)(66476007)(110136005)(64756008)(76116006)(6506007)(6512007)(6486002)(478600001)(71200400001)(31686004)(4270600006)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VEFYR3RpWTFRYmFTc1paZ1REMllqc1hBK2p0SkZvbnAvSzRLZXNnVHNPZUhL?=
 =?utf-8?B?ZkU2T2U5SC9OdHlZVHpFbGVEUk9qWTZVd3h3cEIyWktkNGQrM0gxdVhVZUhD?=
 =?utf-8?B?Y2hJU2tJM1U3QVZFNzBLY1pEVFZ3L3V5TjNWbVJMdFpGSEVFVG11ekE3UDNw?=
 =?utf-8?B?OXhsc3pVM1ltY01VTmZxeUJhYnpOZWMrMlRVVzFsMXRKbEhlSC9Kd0hSeng1?=
 =?utf-8?B?T1dFMmxITlNMTmFGZVovemtNbGVJd3k1RDAxSXVLdXQrZGQwSzJaMHIvR1lO?=
 =?utf-8?B?Zk1KaU1RSzQyUFczYUxjcFZ5L0JVK3BFaDdhZ0dJdzlHNGtIbjBoVXlGRUMr?=
 =?utf-8?B?RnZzY0JZc0VERUxjbG43Qk13RlB6Q3dONFk0NEprVC8zTm53K0xWTVZtZko3?=
 =?utf-8?B?aW5jTklMTnVXaDB5OTZkcW82WkpJSkVWbWROWENEejAwMDFmMytWNDNuaG00?=
 =?utf-8?B?VnZIZTYyYm1IbDd2Y3JLUmF3SXpPRXF0eXcxQXkxMmFRMVVHU3RldDM0R1dq?=
 =?utf-8?B?RTlvOTRENUpWNFQxTzAzY0c4TGdPZ09aT0JZYmtOc1lLMEpIVENkeU9Wazlp?=
 =?utf-8?B?eFpKaUlEbVdPT0pZclBwWk9FMzUwUjhoMmZxejNCTUtVYmJ6M1FzSTV1M3Za?=
 =?utf-8?B?UWpmcFhOWHRzaFUzSEdIVjllOVh6SFhweEtDcFR1ZHRLM25zRW90WjBLNHhq?=
 =?utf-8?B?VHVQa244TjJoUi9GclJQRm43c3E5V0VtMXN4cUFwcUtJbjZrSzZUSzZmTlIx?=
 =?utf-8?B?bDB0UXF2VFY1ZDJsWWxaZzgvOHFxRHp3QWgzZWRvS2NES3ZkNkZPZFZvUmZI?=
 =?utf-8?B?RnZMd1RRdXNFRkFlRWp0TmpBeFdkYWcwZ3crU2hCMGV2QzQyQkRZN1VoNzJa?=
 =?utf-8?B?bkY1ZU52ZitYc3BoK3VZUmlxVU5UNnpzOHZQb3EzSmV4ZUxXRWxJbjYvRjdr?=
 =?utf-8?B?dlE3cE1NNXZqTzllOGM0VGNuSTFSdGdGTWlsN0ZDTGJveTJPamNKMTJZdHlD?=
 =?utf-8?B?WUsyWDBQOXhTa0lkOC84M0FPb3dOY28wdlZqaXROVkROelAvdzJVdXB4d3Q1?=
 =?utf-8?B?UlZzTy80ZVVTNDMzMkdmRlNDL0xIaG94YWhtWkptSnhpUHR6MXQvbWkrSkFZ?=
 =?utf-8?B?Sm00djA4Qk50WXFqRXR3RDByejNJNzE1QXJvN3dMcVF3bDN2WFJNYVlVRUV5?=
 =?utf-8?B?M0hOZUV3K0JDQjlqUnI4VDJkeFM4S2Fwc3RxK2Z6Rm96Tk1HUGZUMmFhMGxp?=
 =?utf-8?B?aEZ0dGM4MUlWWW0rdnYzRHpKb2xtRTd5Nm1KOVduSTlkc0pTbFdiUWJMMDEw?=
 =?utf-8?B?S2llZUF2c1JDeEN3b203NVNyNDQ2V0Zuc3lCU2U1aXVuc0RIM0FYRUk1UlF4?=
 =?utf-8?B?R2FVdUUzSjRpK0hKYnI0V3ZXbTRGVmRCcitLeDBVeXNOU0hQMzQzWWpqRlAw?=
 =?utf-8?B?VWVvYzFPN3hvZVB3eE9zUDNlSm5POXdhVVJtcmJMQjhtU3BOTFJOMFhMQ2ho?=
 =?utf-8?B?djlhdzFVQjVJMGsyM0c5VTV4QTdrVUdzRDZMTEFqVU0yYWIwU3hIak9VZ1Nu?=
 =?utf-8?B?TFJhQ1JydDdRbDRLS1dlVzNEa0JxT0JDL0pGZlVEZHBXWmxQOFVXSUJBdkpC?=
 =?utf-8?B?RWZEbTlqSVZtYlJUOUk5K1VaeStEcXl0T2RJdVlydUpldTRMVjA5aGhDYlBz?=
 =?utf-8?B?TzExVGdNY0NLeURHZnFPemNnangrenJkMERiVVRyZllnMDFqU0hIbHdzVkgz?=
 =?utf-8?B?SllCRHo1QUthMzdKWkd3Mkd0RmRYWURLcm1qR3Bqc3NXZ2xpWnJWWURDUGhh?=
 =?utf-8?B?UExYSGhvMVQ0T0s0MUZYT0x6V1dFL20zNWl0c29qSEk1bmRVdDllNmU0eVcz?=
 =?utf-8?B?VGhXd1pvR0xJenVNejJIMytUTGRhL2RvcldLSTB3cmEycVVBRlYvTDFlV1gr?=
 =?utf-8?B?YU9hbCtWdWgvZTJnU08wMUtVdk1lMHRqN0tQQXJWNTFCVkhScTM5Q0orNGpP?=
 =?utf-8?B?LzFYaHIzdUpnNk1kalFvM1U1ajByc1NyVG5iVzg5anVIdmpwMVlZVGNYUG0x?=
 =?utf-8?B?MlN2MkNLMlV2QU9hSzljZExid1B1WEI2Z1YxOWVmcUFDVnFtbnRoOW1SQ21X?=
 =?utf-8?B?czhqd1lqRmxTRFhZR3o2SkZOQVpobjdLTHhLOWIzVmhEVnhFZ1lYbVR4NHRC?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BFC5F2A3CEA364BB62AB73F0B80B6D6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eMfanrzVflsBVGvbTtv3wMECDzoxE2iFyvhRNIklW3/1CmouoG0sjyhdQw/PvsNcmKGj2wL7PD9WOdWBiNtRlDG2c/jFf/OsIasIqxCM4DbC/MgZ6DJ5JFAkcRYuqJB7kSR+LXXot3lGsw3y6UKvoLU2EwV4jFtdrGo+En0OxgI47VD0BBJEkWueZfRV5IP4seqOWNCp1bR0fQ/xP0NZCjiJYjd76d03Vm3FkNgisvM7K0ea5wXgyt1EcUv1lwAefL9w6DZii1kdxJV/0+spfgE2TpbDwMz606GYsFbGVjBnl+Pswho5nT4a4s0GunWhTEi3J+wGv1oDi0OFyAE+K2SZrKiMbIWQ/GL1ZmB7508CZEUVW7yx7QxDB2sp5AD5I9B3xq/69VNgNoW7/TvpcVWN8KEED4GROJGo2Y4bdxlcHDRVNX9+yZsb4ZL2jXU0bNlin/Xrpqz4So60gbukeO8cLFstRnbOdcgGRm/A2UmZ+iXRi+9mTiKVwihiGYYIw7jYG+hGyduQQpcQDRtrvvqJikM29tdCC+NEpJ8+jV04u3XzVne8GcuAbKFENrF1RGbgJC7UJw2hBEKVPmCYm0v2R8O/lTPUq/d22SVsNiVsXAK4Rhvpo4u2f2C1GREW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c483b28-7610-4e0f-161b-08dc2e19fae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2024 11:33:49.7970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rEmhZZVufTXt/7i35LfE+bRVTz11JccdJgGS9l5mQ4DICluUA8vFoZN2nxSNxt2FgvNldCq+NSmylQOfR8DDVx8ORkyU28P1nShbYUl42Yk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7002

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
