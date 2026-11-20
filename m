Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795177916;
	b=VdP5wJB21vCFGrxUd05p2153gbRFVm1EAYWzpoGJRgtqSU5PL+VYyGejExURIAONP4MX
	 tGungFF2Z2Yb+6/fgxElsS+6iVKRPB/0Mof44nK0ZgbKvKAkzxUGYsuSxg3Ts4bODRAXH
	 ZCay3m0nE4YIPydvECnL6RuYrZmAKbv5zVAnY10jt5IRktAdbMyihnbSR7Y1++M+dlfh2
	 Y4vHJmswXaH23E8mvBVdWNzCFKKC6rxNVtS33pTa8YoWV+tSNARDP15PmtbFQJUKvXkSd
	 qDLHkTItHdwfeJ8wMdFsebOlHdapP2Em885jO3bWr2fg2Frxqo7z+5EuMhZItcFK0ng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795177916;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=u7oLfGjJfnwud12oVP+VtMA5guCWf/uQbjlyHcikGx4=;
	b=bkoYelyezyIyNxvDcePM6yAqzsGYkM1ahvrC0cB9icH0TzY6HWC1cppk2ntU3S/6MY+i
	 tBrFrNe6nMZeliTtcBihERycEJu8e6HsFWeyE4cJU2JsTEmzuM7Hw+wCZN5ip/l7reaM8
	 J22ZTgK7MjGNP972zM3aARpzHMuWRXp1ItMCnFKVImPCZ1sCBDsHapV0T85jSi/0jUVW/
	 FkQqR3TJBrzeGeIMhcSOlUcf4P1ekaRf2tLijOI2J8YfS6zr1zchjeBZ+o8JN3Y1yKVoT
	 8PY7sfaTNsC/+V2kajR47sojRsqhj3WKRCwLf/xqwzs1ApZ2btqBctuw6X1CaUXjaWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vivo.com;
	spf=pass smtp.mailfrom=vivo.com;
	dkim=pass header.d=vivo.com header.i=@vivo.com header.a=rsa-sha256 header.s=selector2 header.b=Q5XkURap;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.126.71
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012071.outbound.protection.outlook.com [52.101.126.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4923A606A325;
	Fri, 20 Nov 2026 12:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4923A606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=vivo.com header.i=@vivo.com header.a=rsa-sha256 header.s=selector2 header.b=Q5XkURap
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITCtcGLvyr5upiPsWIuHSxH2ymJFfaq7jNa26KSv/G+kZhLDcZiJtahpEddytiD/12sb1FtFtXnXzwfowFb1lILC0M9HXN+cjegLpNqUFKrPKwLcsNib2nP++4+XXD72gSjuqE3w8tPG/THIwQS/PI48QOeRqOZpiCppeBvl10OnnnU+yeJ9ztJyOCilenuOv/3s5wIt/+GOJvK1mRfCs+AfBKQ4ddQu5vAQZadAPNkjwRB2/P0J3ePOqm/W5E9fQlRfORkURcLyqrsAHY2GUglUIyLPC6kib7662R83r3+TmCmL446KeZ1X0UTgqkaNAHfPuLyTnorOphKk6Hyagg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7oLfGjJfnwud12oVP+VtMA5guCWf/uQbjlyHcikGx4=;
 b=JECwXDy3QxwBp1RTk+UEE0Gp8t35S2sWPq0cmBXaE1h+hj5WW0LEHUP0HS4JagitZD01Mrg36E6TOwH22Q77rd7HzHpuD2kR2xALHwH1fYIYEGVgokOdeNeuTPx8RBf1bBU4MbpxrzlvTMkHDoqLLxhuVH09GOjTyACMGC+zkDL+4rRXDGbV8KfF797EuZ+iX/0OjAVRmj8dEdheRx02NaACiOuNt/4z/BxAsL5zokOua3ET8nWaJvOl8zqSu6hwRJ2QKI+8+yJZJo1I2SI+D6pZ0/giNTHgvdNX3M4l/3t5z8BVi0T/rX2oKpbTseordA8uUkkdXuNtooNSEwABGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7oLfGjJfnwud12oVP+VtMA5guCWf/uQbjlyHcikGx4=;
 b=Q5XkURap3ll5asww7mdzAUMPFhkn6g72WH6qAs3JiDakfFeZc7nSTmIv8uZnjM/SfgAL2mdAX1E4Yu76PNECdQU2yF3DArsQi4eEyWkag87JwN3MmC21346eBz7EQd3pMJObdRCbQs6buwXJ4gMeNLOWHs+6eB7aVB0JfzoB2F+jYv/fOuVnNCIRxMdS0jhywDY3vjR9nOObarZTt8C4q+x7Yvbqhf4PYA0HCGPjMB7bYAIOVpEfmgX52Wp9/Lsu+NXb8y3Hvd1vuK7D0XSpSplz0YH2iwgWVhlvh+zEPxAG8GqZOiVOTgYG1PqdSJIkdZDR+Nc0W0tB5PbZp9T/ug==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by KUYPR06MB8938.apcprd06.prod.outlook.com (2603:1096:d10:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.3; Fri, 20 Nov
 2026 12:31:50 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0662.001; Fri, 20 Nov 2026
 12:31:50 +0000
From: =?utf-8?B?6IOh6L+e5Yuk?= <hulianqin@vivo.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Alan Stern
	<stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>, Jens Axboe
	<axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Mike Christie
	<michael.christie@oracle.com>, Damien Le Moal <dlemoal@kernel.org>, John
 Garry <john.g.garry@oracle.com>, Shin'ichiro Kawasaki
	<shinichiro.kawasaki@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject:
 =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjUgMi8yXSB1c2I6IHN0b3JhZ2U6IHNldCBzdXJw?=
 =?utf-8?Q?rise=5Fremoval_flag_on_physical_removal?=
Thread-Topic: [PATCH v5 2/2] usb: storage: set surprise_removal flag on
 physical removal
Thread-Index: Ad1X4bFxAfyJakusTtGaliW161FLLQhA3IWAAAFBdtA=
Date: Fri, 20 Nov 2026 12:31:49 +0000
Message-ID:
 <TYUPR06MB621740804B51F4C0D9F63778D2782@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB621711053AB2B701FECC73FED2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <2026112048-preamble-fifteen-46a3@gregkh>
In-Reply-To: <2026112048-preamble-fifteen-46a3@gregkh>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|KUYPR06MB8938:EE_
x-ms-office365-filtering-correlation-id: 22c8efa7-057b-482e-7a03-08df47024004
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|42112799006|23010399003|366016|22082099003|18002099003|261009223027099003|4143699003|260925022911599003|260925021311599003|260925021911599003|11063799006|56012099006|261026121527099003|261028144727099003|261022075727099003|261022105027099003|261026140227099003|38070700021|10067099003;
x-microsoft-antispam-message-info:
 iPLzNeZv9VCNRkJ4szq0x5JlY2AR2O/FcnFW86sHjNawMyO030KerlF8HL3ajOpwV3gjgJGZKGmrLn8hjeP8fB81/sthXqIFJaHX0geCX9JW313Is1jrngRupwCebxPsQIlvZ44VPnH8bTCnh5mulJhIfEavVhoy4JgUWad6+G6jwMFP3rYe5Y8Xa6j3y2/lX0qWMjfjxFx5ymkS3BWHVq/6rCyb6AUDBtRzAqWeZuGodg1FHICfVvLDX2Uk8Vi36F23gn/rZTSFgGIWkcNfeo4ybrW1owViP0rRQpndYsFjeHdDEamNGYcbmK2wkeQgWnGOCQ02Yj01/EZNuFbyJbo6CyB7j9YHjS3JOrSOb4su+9ucbX815K1ySqe7ZD7rOIEdVNM8elHYgy5aYkSvckv1yvvKg9oiPwO9TM1ptf9m3fqjRsdnW5TST4bBq7ZMqLue50GVyWL9i9K70UZvxZKvXpAMETeHwmKaaRjRDv9HlksMuVzQbnQ43PvCMrbX1pX7O3NK80u2VC2oFHinKIGIXvxpeLiywiSvNzibAqS+1XXjvmEPbIWJnGmFlY3Oz13JIRq5UClPIxFpbK1HmrPcuZcK9cmoSIa01ALWWyzuobu8NCyNJmJ63JGZOCqj4ftP9NVM9qjagqMv77LiABMT+EKUaCMVKAJJXvBtnSY=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(42112799006)(23010399003)(366016)(22082099003)(18002099003)(261009223027099003)(4143699003)(260925022911599003)(260925021311599003)(260925021911599003)(11063799006)(56012099006)(261026121527099003)(261028144727099003)(261022075727099003)(261022105027099003)(261026140227099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NjJ1SnZHcFptditJTnZDcm00NUYxL0RGZEZiVXRoZVpzY1JWNDM3UnJ2OEhD?=
 =?utf-8?B?ZTRmZmNCc3M5bTJxQ3dYU2JtQ1FCUTczUVhQVmFYM2xSVEVqeVBuOWpRYWxx?=
 =?utf-8?B?WHYya3hMMkl0Z1A1aGxhNHlmUmFnMkZUTFdpYUNDZHpkM1J1OENwaTJPbm9p?=
 =?utf-8?B?TjBJMUdBYUgzU2gwQk1zNHA3SXE0a1ZGZ0ZOYVlUai9YeE1vMUF0ZjBvYjB4?=
 =?utf-8?B?YngwV2RaSTRaNHp3ZWNBWUVHTEQ5KytjMmh2eWxJR25RTnowbUpaWnNZbGF6?=
 =?utf-8?B?YkdWeHhZeFh3MTZkeE9VNi9aL1QzeERvYnpJTDZjNm0wcnZQeTBGbWl6VEpU?=
 =?utf-8?B?U3ZBU2h1eUFndkVndmVXTkdtemJGejVSeFdVVktIWmNRMDQvSDQ0UnU2Nnc2?=
 =?utf-8?B?eXRITlYwUUllSTJRM0ZKTXZjMkczQWFKYkErY242WDBRN1hIUTRHR2Q3Z3oz?=
 =?utf-8?B?VTlEdkEySE9lVkJpaHBhWklhS0NuQ1RBQVIzbXdLSVBFTDZzckVHa0R2Um1P?=
 =?utf-8?B?UmRzMzRRaUlRNUwzOGdEb2N3Z1liNndQY0U0aUhaV2l0ZXkxY1pJS2pCQjZG?=
 =?utf-8?B?bXhoUlBzQ1l1QmFkZ0RYZ1BEREt1NGJnMFFVUjZZV2x5NUhReWQwdGJndDlm?=
 =?utf-8?B?YzRkdnVFUy9SZE1BWEVoeW1ubW4zdzZ2bEtpRHJPa1Q5K2ZUOW9hVENxMjJw?=
 =?utf-8?B?ZUc4dWxqQUNOaE1KZWkrbUpxWnc3ODY2Qy9FT0dUWk1HZlJEZFpTZjlwZUFt?=
 =?utf-8?B?YXU3SkVaWmlGWldoYTF2alF2WTEvdEZXYWd5Z0hYaFpuT2M3eG1FT0YzZFNI?=
 =?utf-8?B?UHk5MmJ2eVFiLy9jYW9zV1Y0RXc4V0gvalIrcSt4cUo2bmw4SmRUc3JPTlpq?=
 =?utf-8?B?U2llRXR3K1BWYmtIeGRFQUxlS3pmekd5QTVGMHRiNnFUR2V4RkZLWm1Ma2FK?=
 =?utf-8?B?ZFI4NW5SRktVbDNja2czcE9SSXVlZndrcWpjV054MlhqMFRFOU9WL29lcG5W?=
 =?utf-8?B?dzlMUUFaT1dHbW1PS25XQ0dieFEvTVBsQ25URk80S0ExVUN4ZkUxVEg4TGl6?=
 =?utf-8?B?RlZYK0RSb1hvelBqNmViaGcxcGloeCs5ZnZIWDBnblBYQ1dTZjhQZFc5Kzho?=
 =?utf-8?B?REJKYzVqZGwxaHloUTJtbS9JVFRJdTdhMnUwdCtEbFFmbDB3RmFuUVFmdWNm?=
 =?utf-8?B?YmpJQVhnTEFvUHNZZXpockdhVHVCVmYzbDNiSE9lK0ZSNnY0S0MySkZOVk5E?=
 =?utf-8?B?QlI3NG1aUThGcXpxZXFVS2NIQ0pTL3JQRmp4aW9wd3Zac2VEZU5NaTRWVFVM?=
 =?utf-8?B?SFdZZWN5emtjMWFlMDdDWTFRdktqeUlwbitkTmRKRFBjbzZlcGJXNXAxc3cz?=
 =?utf-8?B?TlhDdGRXZ1VpUlZMOXlpdFh1dTl1M0RwTlJSeWovbTN3T21xVmdWaUNrdE9S?=
 =?utf-8?B?d0J1eEpGbVNHMlA2V2FEK1hzNnI1eUYrRWwvdTJHVU10L3FKNVJ6TnFzcFZn?=
 =?utf-8?B?T2xOQVdzZm9yeWhKRHU4eDBjak5haUo4VDdGQnpBekRMcnR6akcrL1Bwenhw?=
 =?utf-8?B?Mk5HMUd0bk1SZjNPaTRPWW1odkZFZWp1K2FsdDRpTjM5RFhidzdNRHB1eXpz?=
 =?utf-8?B?S3JrNHVwTVY3WWYwZ2ZOanB1WVlWWjBsQVM1ZDhNdDNrbkNEZjlwcG5jZmtM?=
 =?utf-8?B?Y1d0NzB3eFJsVUVHeHhRMk55WERpWWl3VU1XSkwyY3ErMk1zaFVHcHUrbHJV?=
 =?utf-8?B?b25MRnRFa2tNMWUxSThSVnEyMjYwV0MvcGVYTVRURTRGUUdCa1RUYk1acHo4?=
 =?utf-8?B?cGhpK1FlcS9IM0FHRFhuNy9WVFhGZmFWTjd0RnVpWDJRbnJWekVjamd6dHhR?=
 =?utf-8?B?VFRVUkRZQlNvZVdNU0J6cnloNmF2eFdHL1RhemFUMnpHRmQ5WnhCallWeEE2?=
 =?utf-8?B?MG9wVWVOODhLMVJaZVNmVnREVStFR0JtaWw3UXFzUmVkaVY5VUxzUzRsMndO?=
 =?utf-8?B?QjBXcC9Wamh4YVFOcXZOY2p2ckxFcVBMZVFueFhCekJmVW45em01anB0R1U5?=
 =?utf-8?B?WEp4U0lPZWpFVWREK09VaFpOdjRVRkRJT3l6N25PMEIvd1lmNDAwU3VBS0pn?=
 =?utf-8?B?eFl3Qmd1RHZ0VHY0RldEbTRhbkNEc291SDNWam8yTHF2ZHR6UDdSNVVsOERi?=
 =?utf-8?B?bDdpejdIdytGOFhXWDdWbEVNbTdib0NpR3FWajZZVjRhM2VFOEFHakZESkZD?=
 =?utf-8?B?dzVEalBxUGlkOVpBQUs3ZE04SmZmNThPaExlM25hY0ZTWERxNnd4TGpoZysx?=
 =?utf-8?Q?U3HvFKld3e3YeTjUhE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYUPR06MB6217.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c8efa7-057b-482e-7a03-08df47024004
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2026 12:31:49.9160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4OXcb8VJWDC2G+jeCndlhC6sXuxP44DGDk2ajAmXNBed+gUyieePykJK8DIaqH+6+nALSZqTRaCcKwRnPPc5OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR06MB8938

SGkgR3JlZywNCg0KPiA+IFNldCB0aGUgc3VycHJpc2VfcmVtb3ZhbCBmbGFnIGluIHN0cnVjdCBT
Y3NpX0hvc3Qgd2hlbiB0aGUgVVNCIGRldmljZQ0KPiA+IHN0YXRlIGlzIFVTQl9TVEFURV9OT1RB
VFRBQ0hFRCwgaW5kaWNhdGluZyB0aGUgZGV2aWNlIGhhcyBiZWVuDQo+ID4gcGh5c2ljYWxseSBy
ZW1vdmVkIGFuZCBjYW5ub3QgaGFuZGxlIEkvTy4NCj4gPg0KPiA+IFRoaXMgZmxhZyBpcyBjaGVj
a2VkIGJ5IHNkX3JlbW92ZSgpIChhZGRlZCBpbiB0aGUgcHJldmlvdXMgcGF0Y2gpIHRvDQo+ID4g
c2tpcCBzeW5jX2ZpbGVzeXN0ZW0oKSBkdXJpbmcgc3VycHJpc2UgcmVtb3ZhbCwgYXZvaWRpbmcg
YSBoYW5nIHdhaXRpbmcNCj4gPiBmb3IgSS9PIHRoYXQgY2FuIG5ldmVyIGNvbXBsZXRlLg0KPiAN
Cj4gVGhlcmUgaXMgbm8gcHJldmlvdXMgcGF0Y2guDQo+IA0KPiA+IEZvciBvcmRlcmx5IHJlbW92
YWwgKGUuZy4gcm1tb2QsIHN5c2ZzIHVuYmluZCkgdGhlIFVTQiBkZXZpY2Ugc3RhdGUgaXMNCj4g
PiBub3QgTk9UQVRUQUNIRUQsIHNvIHRoZSBmbGFnIGlzIG5vdCBzZXQgYW5kIHN5bmMgcHJvY2Vl
ZHMgbm9ybWFsbHksDQo+ID4gcHJlc2VydmluZyBkaXJ0eSBkYXRhIHdyaXRlYmFjay4NCj4gPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IExpYW5xaW4gSHUgPGh1bGlhbnFpbkB2aXZvLmNvbT4NCj4gDQo+
IERvZXMgbm90IG1hdGNoIHRoZSBGcm9tOiBsaW5lIDooDQoNClRoYW5rcyBmb3IgdGhlIHJldmll
dy4gQXBvbG9naWVzIGZvciB0aGUgaXNzdWVzOg0KDQoxLiBNaXNzaW5nIHByZXZpb3VzIHBhdGNo
DQpQYXRjaCB2NSAxLzIgd2FzIHNlbnQgc2VwYXJhdGVseSB0byB0aGUgU0NTSSBsaXN0Og0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1RZVVBSMDZNQjYyMTdERDMxQjFCM0NEMDlFNDMxQ0Mx
MkQyOTIyQFRZVVBSMDZNQjYyMTcuYXBjcHJkMDYucHJvZC5vdXRsb29rLmNvbS8NCg0KSSBzaG91
bGQgaGF2ZSBzZW50IGJvdGggcGF0Y2hlcyB0b2dldGhlciBhcyBhIHNlcmllcyB3aXRoIGEgY292
ZXINCmxldHRlci4gTXkgbWlzdGFrZS4NCg0KMi4gRnJvbTogLyBTaWduZWQtb2ZmLWJ5IG1pc21h
dGNoDQpUaGUgRnJvbTogaGVhZGVyIHNob3dzIG15IENoaW5lc2UgbmFtZSB3aGlsZSBTaWduZWQt
b2ZmLWJ5OiB1c2VzIHRoZQ0KRW5nbGlzaCB0cmFuc2xpdGVyYXRpb24uIEknbGwgZW5zdXJlIHRo
ZXkgbWF0Y2ggaW4gZnV0dXJlIHN1Ym1pc3Npb25zLg0KDQozLiBUaGlzIHBhdGNoIGlzIHN1cGVy
c2VkZWQNClRoZSBpc3N1ZSBoYXMgYWxyZWFkeSBiZWVuIGZpeGVkIGJ5IEJhcnQgVmFuIEFzc2No
ZSdzIHBhdGNoLCB3aGljaCB3YXMNCm1lcmdlZCB1cHN0cmVhbToNCg0Kc2NzaTogc2Q6IE1hcmsg
dGhlIGRpc2sgZGVhZCBpZiBydW50aW1lIHJlc3VtZSBmYWlscyBpbiBzZF9yZW1vdmUoKQ0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzJjMGM3NmQ3MGYwZmUxOTc5MzI4MzZiOWJjZjg0OTYw
OTUxMzVkMWIuMTc5MjQ0NjkyMS5naXQuYnZhbmFzc2NoZUBhY20ub3JnLw0KDQpCYXJ0J3Mgc29s
dXRpb24gaXMgY2xlYW5lciDigJQgaXQgY2FsbHMgYmxrX21hcmtfZGlza19kZWFkKCkgZGlyZWN0
bHkgaW4NCnNkX3JlbW92ZSgpIHdoZW4gc2NzaV9hdXRvcG1fZ2V0X2RldmljZSgpIGZhaWxzLCB3
aXRob3V0IG5lZWRpbmcgYSBuZXcNCnN1cnByaXNlX3JlbW92YWwgZmxhZy4NCg0KVGhhbmtzLA0K
TGlhbnFpbg0K
