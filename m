Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012034.outbound.protection.outlook.com [40.107.75.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC11A41D4FC;
	Fri, 16 Oct 2026 08:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137850; cv=fail; b=PQ0ZOambh+Qy61880IMcimMRIL1muIYQA40LIKLfNDIhToOZzdrsZQQpslcYOj+I+7srI8emOMzH8LVbmis1fiQdmgHb5HFw94gMvHZXzD97/uCzJnSMsCPaA0VNbWUm3AOOPHALVLIh3v1mCMCjIRQj4eftnqAdnh+e6siGipg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137850; c=relaxed/simple;
	bh=NSWMMFsHXPlfNn/nc5d9xixtj4hloUgwSx94FyFAsEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LJucY9TRDbltsRnsJNRPUxgzGoeMs73Ztgl9UJHu340BTVZgLNL3jQPheDSxZXW1PhVBnnF/Z2mnIGVO8XZLxK1f0ARqRfik8xSWFAOXkkT58pbcAXHJGCCrONpxQsqPMqasAr8BioglJpUQFnq9LwziKgZpV7CVbbhYXca3XKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=na79dRmx; arc=fail smtp.client-ip=40.107.75.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="na79dRmx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sTndON9xDaKfW8/rNdvIQI94K/rptaCslExCvg4LxRBgY5jhlcev9CA3ytiZd0B5E8nQckaOOQCh5rl+/o47DieUk3c1w5XpJPKIlw2dBMTY3jLtcVhsthGDm5xUvig/zjSuC22JS5HdmVLLBdSxa4XAQde2JDPLjJHU2ZbhY76PbQTTtoJjzfHbRYiYgzaupvQctF3csHVjR/k4rB5MbPCHF2vnBxxBctUpMoVV3DkSe3qhIX+kjgJDEIeBtP8txEKIt7ztdCd2xUI/xQrpsFtzdLtEJIWxR1jR2l6vTuKMV5PG5SMKTlvaTlNhq11wFtKoDmLNNItgfvfz4Ysh/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSWMMFsHXPlfNn/nc5d9xixtj4hloUgwSx94FyFAsEc=;
 b=ak93gGYr9YXw/baSfrd5/4nnDaSAehOtuoDM49KizEqevN24e5i9sLKrcRiHoi6YaF8HZvs7WF1CzmJDABPyIHy1jhhRuYIRn2N9dTyVbcajkTAcCqfQI1Mi5tZM4Nb/Nz6NR9PY9leo3kSPaXj8W0oe/2MYKMX7AU997qNo8a8PUyYpZI1Wj6bh1H3HogbqXKvjzJHMUKdIiQj08e9iunrjXUcEdxUYSseS+7qyAT7KDO3SKM1zoWyIEaJKrV/aaWLotqJUntTjPzQGBYxQOGYPh6mE44eYXvJutpaT+4DdsZrvFOPJmBBHkdCQyPN9n5jmCrZ/CZ2ouL3ybK9oKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSWMMFsHXPlfNn/nc5d9xixtj4hloUgwSx94FyFAsEc=;
 b=na79dRmxCVAZakDPBpXtFsSyAZ1V8AQeupD8bdTp6Y8Hy06LvJMYr+9Ooo+hVdVtEeSnM9w7vWPuZldf5jlkedNcaZiM5zV7aXx6ZCeNX3i9PcT9+qzn1Ga1KMmgRfbzG5uLEdTN+a2xkdVXfJuGuuM3G0QdlhOCiRVIeOtlY448Spb1T9LnA3DuXevba4nVUd1s78WiSh1phJbQAt1DmgocMOh14aOpuhOV9IXvT3xkOZKV12PdPgBrx9b+wWcPX+Tp5B5c3nFmoYho4E1gwsaNO2Vcgd4O8fFkT9UFYIb8mLGSB0ipF22jZfMyK5OGmEQLsAK+D/3zeH57BtN6QA==
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com (2603:1096:400:358::7)
 by PUZPR06MB5887.apcprd06.prod.outlook.com (2603:1096:301:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 08:04:02 +0000
Received: from TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc]) by TYUPR06MB6217.apcprd06.prod.outlook.com
 ([fe80::8d51:58c7:42f3:ecc%4]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 08:04:01 +0000
From: =?gb2312?B?uvrBrMfa?= <hulianqin@vivo.com>
To: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, Hannes
 Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>, Damien
 Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject:
 =?gb2312?B?tPC4tDogtPC4tDogtPC4tDogW1BBVENIIHY1IDEvMl0gc2NzaTogc2Q6IG1h?=
 =?gb2312?B?cmsgZGlzayBkZWFkIG9uIHN1cnByaXNlIGhvc3QgcmVtb3ZhbCB0byBhdm9p?=
 =?gb2312?Q?d_I/O_hang?=
Thread-Topic:
 =?gb2312?B?tPC4tDogtPC4tDogW1BBVENIIHY1IDEvMl0gc2NzaTogc2Q6IG1hcmsgZGlz?=
 =?gb2312?B?ayBkZWFkIG9uIHN1cnByaXNlIGhvc3QgcmVtb3ZhbCB0byBhdm9pZCBJL08g?=
 =?gb2312?Q?hang?=
Thread-Index:
 Ad1X4Nn5DvzfrXBnSoCZVyBu705+6gCeASuAABfIUFAAG63OgAAVJJUAACZ6+YAADGEYMAA/Yf4g
Date: Fri, 16 Oct 2026 08:04:01 +0000
Message-ID:
 <TYUPR06MB6217FBAE5A652C085950869DD29B2@TYUPR06MB6217.apcprd06.prod.outlook.com>
References:
 <TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <20261012144923.GA10852@lst.de>
 <TYUPR06MB62172FD04314EFE34D8091EAD29E2@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <9c28fbe7-089f-4d72-86be-5805bfebb213@acm.org>
 <TYUPR06MB62173975C70E0BBCE434475ED29D2@TYUPR06MB6217.apcprd06.prod.outlook.com>
 <889a01a1-cae0-4038-b0ad-2ad29231152b@acm.org>
 <TYUPR06MB621717C0153DFB5C495A93A7D29C2@TYUPR06MB6217.apcprd06.prod.outlook.com>
In-Reply-To:
 <TYUPR06MB621717C0153DFB5C495A93A7D29C2@TYUPR06MB6217.apcprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYUPR06MB6217:EE_|PUZPR06MB5887:EE_
x-ms-office365-filtering-correlation-id: fd5f46ea-3c99-4767-4a1a-08df2b5c0a44
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|42112799006|38070700021|56012099006|4143699003|261009223027099003|11063799006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 u6Y4u2+OfjARoIAD3/K1zY7LMdJnT8w+d+TXkJ+R7udQT/gDuRzRBxYF2mRbEhViY4Xv1We4jd8b+xXvNXKLHlzZDB1DfqHEmyI1gQpO8JT2L/J+u565vxKUu0Ys/WoVp8zoxIT7ylHSGajJKVRTb49wegz3mrmA2W/Dz5YPzJWLlE21tSRxPCiI6I2xcIYben9a9Y+3pranpqRPe5kzwbAlMaWmkM97pwm+QYy91AeVQ4QT6NFuyk6Al8iRRGbKf5+zcyS+1tqSfKJYuLz9LUY68nR+hb6kIwEepTDvAK4pJuamGkeC+HM+uyBwgpE1vIN2tBxlr4Ut7XzAtlYyMmkezL6y4MjILvVPzt9gdcNzRvRhNH8YCjURVOm8dZ/OmFecTYoucIbhlnv9EGjEPI2gnCO7blOEMh2ggAE6C5PRw36ZHZf90s2WtW7EC3njZQ5SY3RTk9udaxhjAt+U1RWqc0/vBcfV5lRiMnQZOZXaCtJOADS3dDzUBAaPyH3gPgbrugIZyuU8WA1cmt8qfmR2Ux9g9wn0DqsAR/UtgBuQ/USCfczsyLhucwNMbDVWtic7evN6v70LfcwQqar3UlmFEHaVXxR1yvhmFYY+PLmbW0T7z3gU8GqDew6i+Oi6M1KCZwxTq6pEF9y1tvXNjXqw4bF2oamLhE9DTWvP01dqA/G5OYZONnPZjviFqGcH
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYUPR06MB6217.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(42112799006)(38070700021)(56012099006)(4143699003)(261009223027099003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?eDlaYnVuMTAremI0OVpMMnpzb1JraWpzWFFZTWJYZzRWWGdRY0taamVMYkpZ?=
 =?gb2312?B?SHQ2akRyeURWQXIxV2MvUDlzajlqY2pReXdRMFNWdCtHeVRVbEsyUWEvL28w?=
 =?gb2312?B?VHBHcVVVWG10cXFqMmFTODlld1BBbUtENUJ1b1F4Wmp1K2t2UE9VbWR4akll?=
 =?gb2312?B?cCt4MWZySUpiTVJDK09yM2pXT1QzTDRaSmVONzRKMEVOUXBEYXpSeEVXYU90?=
 =?gb2312?B?Q09xZ0QzMEpQdElpY0JycVJHRVlmR3d1S1RxWFFpNWs5ekhaclFvQW9xek0v?=
 =?gb2312?B?WGV3SVpOSWJjYXF5dzFNdDJFaTl6alg5aXpRWkRwOXdkM3gyenlUK1MzVFh0?=
 =?gb2312?B?d1Z3S01RMHlzR3pKWHFYc20wR3QxREM1U2hFLzluZ3lXVjlpZ0pNVUo0M25y?=
 =?gb2312?B?RnJvK1RnUVY5d3ZkVEc5NlV0cVJVWW5WUlM5RzZja29CdWNMYUNkaGFQY3hi?=
 =?gb2312?B?TlZzY1h0T2dWb0ROQ0Fqb0paTzArUFJnSFFGWWVsakI0UHlxeFpVR1VOK0Jl?=
 =?gb2312?B?QWhiZno5ZVBCb1BxMTZGeXlzdGZKam1mU3A2UXBzQkVsbkowTEtDOHRGVTNs?=
 =?gb2312?B?ZWRqL09va08xQ0hnREswS0ZiYXlaMytRWmo4SWltQTF4QXhLRXFiL1hmUVN0?=
 =?gb2312?B?djNIR2d5NTZrZ0RyUUVXRzRNaklrMW1mcUdnRkpjTVNyNjExYzZubkFiZ3lX?=
 =?gb2312?B?MWdiQnBUZHRXQXBFUE44V2ZURmt4Q2pWRVl2bHgxb1dqeG11U2Y2SlVQMng0?=
 =?gb2312?B?NDMwKzZIMFVsUEhUMWNvK0M0eGpOWUxzak1LNkxsUVlpanoyMjhDTDdONXUz?=
 =?gb2312?B?eC9lYVBtUGVnbVZ0OE9VZDJJVjdFN1pJd1VDOUxpOTRFbXpCd0VEZXRXekU0?=
 =?gb2312?B?TG02WnhmUTVvSEwreWFqQnFnd3ZtMUNOMVBaVnVDQWVtUjg3RENOd3ZQR0M3?=
 =?gb2312?B?eWh5Ty9pSDhIbWRZNXBXcFZOV0MrL1NZczBvdTRzdUtQUmZUSmsrVjRxYnpp?=
 =?gb2312?B?VmMySVhSOXYzNW4zSUZBRE93dVZPVmhlN0tkVmJvenJzMElaMHU0UVBqd3Vl?=
 =?gb2312?B?Mm9lT21JUFVsNiszYlRpYTJhRlgzN2pXVXo1UDFyVnBMUFhnUEhFdVhodmlE?=
 =?gb2312?B?ZEp6RnltVkk2aHRnS2J0T3JqYlJqTUVSN2hpdmVYWXVJaysrNU0wVjg4TVpk?=
 =?gb2312?B?WENuSi9iVGcxekttWkY0eGNvZmNXNWVFRWNKQWJlKzJGZk04dVg0YS9wOU9I?=
 =?gb2312?B?UCt1bkMyZFZMTVUrQXZGV1pISldySmZZUmZ0cGRLQTVMY0RtbU93NjBXejhK?=
 =?gb2312?B?QnBjM3FNNDZxVUd4bnM0aGd3ZmttaDdhb2psUE1iUUhwZk1JbkJJWFd0eER6?=
 =?gb2312?B?Zy9EZm9hc0NzbldGLzE1dXFrZDEwYTZqVXo0alpIbUNHWDhPWXlmamFJYzA2?=
 =?gb2312?B?M09sRGpUL1Q3UTBsWFRqa3V5N002K1JuNk5pYWwwcDJXdG85MTdyZ1NQZWRT?=
 =?gb2312?B?L2d6djhtUXU1aFcxOTFSdngzemlNMWJkSFRINGE1Wmp0NFQ4c0hpb3NkTE52?=
 =?gb2312?B?R2tCVkExdnMrM3RmOGdpVVhXK05WYjY0K0VkRklPeVBieWFCeHZ3V1pGYy9S?=
 =?gb2312?B?Qno5R1BvaXJNVDN4ZXZHMFp5UXdtWkxkREFCSnlBRUVYMDI4bVJhYTRucUs2?=
 =?gb2312?B?RHVKdW0xOGF0VEhuN1R5RXVwd1dRb3h4Z3Fjb0FzMEtkcURXa2RLM1RxYXZn?=
 =?gb2312?B?VWRROEJCcGtpZ0FabHZLMHFkUVJ2c09kRkdERkpkbE1BblV5QUdCZDh6RWNE?=
 =?gb2312?B?azltdWFlVml3SUZoV3dVWCtyMFZ1Vzd0cFdLbkY3T3oxQlRmcDZpVFloZUFN?=
 =?gb2312?B?VFhKVjM1UWNETjVwdDBKTDV0ZmR4emJVN1hKb21EN3lSSzlqeitTTS94N0tv?=
 =?gb2312?B?UUY0bmFKdVRZNjYzOW1IMEhMNWtqQkJiVUNaZVRTRGYvU1dENVR0bWtaZlQr?=
 =?gb2312?B?WFN4VnNHWGlyZXorZ3BjWFRtdjdQWnhXeklFZG5wK2dZb2w3VEJaMTY4UFMx?=
 =?gb2312?B?VE9SRGlHOElBbUJpQzBNcVFhZjRYR29wVkpRUHhuL0FwK01QV1ZibzVjcjR3?=
 =?gb2312?B?b2pLZkU1YUZ4TEh3dStaM3B2QWl6WVYxRFkrTlo3cE8yMVhnQlZhZTRBamR2?=
 =?gb2312?B?eGIydDczclV0bDhpMzJ3R0FkcHZ6SnpRZ1BVMkF2SFNrWlpwb0E5Y0syNG5T?=
 =?gb2312?Q?b32l4Onj4hpVXUEvLbGPjkNq42tY2Krx4EPxPtmxN4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYUPR06MB6217.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5f46ea-3c99-4767-4a1a-08df2b5c0a44
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 08:04:01.8783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r2TkiqKD2aH+UllssihG6HJpv4mrRiWmW+F6PujfefDxuuuJ9BhAUPO1LF/zde3lAfRZfF1ieTQoKCAvSjD1gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5887

SGkgQmFydCwNCg0KPiA+IFN1YmplY3Q6IFtQQVRDSF0gc2NzaTogc2Q6IE1hcmsgdGhlIGRpc2sg
ZGVhZCBpZiBydW50aW1lIHJlc3VtZSBmYWlscyBpbg0KPiA+IHNkX3JlbW92ZSgpDQo+ID4NCj4g
PiBJZiBhIFNDU0kgZGlzayBpcyB1bnBsdWdnZWQgd2hpbGUgcnVudGltZSBzdXNwZW5kZWQsIGl0
cyByZXF1ZXN0IHF1ZXVlDQo+ID4gaXMgc3RpbGwgaW4gdGhlIHBtLW9ubHkgc3RhdGUgd2hlbiBz
ZF9yZW1vdmUoKSBpcyBjYWxsZWQuIFRoZSBydW50aW1lDQo+ID4gcmVzdW1lIGF0dGVtcHRlZCBi
eSBzY3NpX2F1dG9wbV9nZXRfZGV2aWNlKCkgZmFpbHMgYmVjYXVzZSB0aGUgcGFyZW50DQo+ID4g
ZGV2aWNlLCBlLmcuIGEgVVNCIGRldmljZSBpbiB0aGUgVVNCX1NUQVRFX05PVEFUVEFDSEVEIHN0
YXRlLCBjYW5ub3QgYmUNCj4gPiByZXN1bWVkLiBIZW5jZSwgc2Rldl9ydW50aW1lX3Jlc3VtZSgp
IGlzIG5vdCBjYWxsZWQgYW5kIHRoZSBwbS1vbmx5DQo+ID4gc3RhdGUgaXMgbm90IGNsZWFyZWQu
IE5leHQsIGRlbF9nZW5kaXNrKCkgY2FsbHMNCj4gPiBibGtfcmVwb3J0X2Rpc2tfZGVhZChkaXNr
LCBmYWxzZSksIHdoaWNoIGNhbGxzIHN5bmNfZmlsZXN5c3RlbSgpLiBBbnkNCj4gPiBiaW8gc3Vi
bWl0dGVkIGJ5IHRoZSBmaWxlc3lzdGVtIHdhaXRzIGZvcmV2ZXIgaW4gX19iaW9fcXVldWVfZW50
ZXIoKQ0KPiA+IGJlY2F1c2UgdGhlIHF1ZXVlIHdpbGwgbmV2ZXIgbGVhdmUgdGhlIHBtLW9ubHkg
c3RhdGUgYW5kIGJlY2F1c2UNCj4gPiBHRF9ERUFEIGhhcyBub3QgeWV0IGJlZW4gc2V0Og0KPiA+
DQo+ID4gICBfX2Jpb19xdWV1ZV9lbnRlcisweGI4LzB4MTc0DQo+ID4gICBibGtfbXFfc3VibWl0
X2JpbysweDY0MC8weDdlNA0KPiA+ICAgWyAuLi4gXQ0KPiA+ICAgZXhmYXRfc3luY19mcysweGE0
LzB4ZTANCj4gPiAgIHN5bmNfZmlsZXN5c3RlbSsweGE4LzB4ZGMNCj4gPiAgIGZzX2JkZXZfbWFy
a19kZWFkKzB4MzAvMHg4OA0KPiA+ICAgYmRldl9tYXJrX2RlYWQrMHg1NC8weGM0DQo+ID4gICBi
bGtfcmVwb3J0X2Rpc2tfZGVhZCsweDhjLzB4ZDQNCj4gPiAgIGRlbF9nZW5kaXNrKzB4YTAvMHgy
ZjgNCj4gPiAgIHNkX3JlbW92ZSsweDMwLzB4NjANCj4gPiAgIFsgLi4uIF0NCj4gPiAgIHNjc2lf
cmVtb3ZlX2hvc3QrMHg4OC8weDE4Yw0KPiA+ICAgdXNiX3N0b3JfZGlzY29ubmVjdCsweDY4LzB4
ZjQNCj4gPg0KPiA+IEZpeCB0aGlzIGhhbmcgYnkgY2FsbGluZyBibGtfbWFya19kaXNrX2RlYWQo
KSBpZiBydW50aW1lIHJlc3VtZSBmYWlscy4NCj4gPiBUaGlzIHNldHMgR0RfREVBRCwgdGVsbHMg
dGhlIGZpbGVzeXN0ZW0gdGhhdCB0aGUgZGlzayBoYXMgYmVlbiByZW1vdmVkDQo+ID4gd2l0aG91
dCBhdHRlbXB0aW5nIHRvIHN5bmMgaXQsIGFuZCB3YWtlcyB1cCBhbnkgYmlvcyB0aGF0IGFyZSB3
YWl0aW5nDQo+ID4gaW4gX19iaW9fcXVldWVfZW50ZXIoKS4gU3luY2luZyB0aGUgZmlsZXN5c3Rl
bSBpcyBub3QgcG9zc2libGUgYW55d2F5DQo+ID4gaWYgcnVudGltZSByZXN1bWUgZmFpbGVkLCBz
byBubyBkYXRhIGlzIGxvc3QgdGhhdCBjb3VsZCBvdGhlcndpc2UgaGF2ZQ0KPiA+IGJlZW4gd3Jp
dHRlbi4gSWYgcnVudGltZSByZXN1bWUgc3VjY2VlZHMsIGJlaGF2aW9yIGlzIG5vdCBjaGFuZ2Vk
LiBNYWtlDQo+ID4gdGhpcyBjaGFuZ2UgaW4gc2RfcmVtb3ZlKCkgaW5zdGVhZCBvZiBpbiBhIFND
U0kgTExEIHN1Y2ggdGhhdCBpdCB3b3Jrcw0KPiA+IGZvciBhbGwgU0NTSSB0cmFuc3BvcnRzLg0K
PiA+DQo+ID4gUmVwb3J0ZWQtYnk6IExpYW5xaW4gSHUgPGh1bGlhbnFpbkB2aXZvLmNvbT4NCj4g
PiBDbG9zZXM6DQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1RZVVBSMDZNQjYyMTdE
RDMxQjFCM0NEMDlFNDMxQ0MxMkQyOTIyQFRZVVBSMDZNQjYyMTcuYXBjcHJkMDYucHJvZC5vdXRs
b29rLmNvbS8NCj4gPiBGaXhlczogNmY4MTkxZmRmNDFkICgiYmxvY2s6IHNpbXBsaWZ5IGRpc2sg
c2h1dGRvd24iKQ0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gU2lnbmVkLW9m
Zi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+ID4gLS0tDQo+ID4g
ICBkcml2ZXJzL3Njc2kvc2QuYyB8IDEwICsrKysrKysrKy0NCj4gPiAgIDEgZmlsZSBjaGFuZ2Vk
LCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9zZC5jDQo+ID4gaW5kZXggYTFiMjFlYTE0
ZTU0Li4yMDhiOTE1ZjI1YTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9zY3NpL3NkLmMNCj4g
PiArKysgYi9kcml2ZXJzL3Njc2kvc2QuYw0KPiA+IEBAIC00MjcwLDcgKzQyNzAsMTUgQEAgc3Rh
dGljIHZvaWQgc2RfcmVtb3ZlKHN0cnVjdCBzY3NpX2RldmljZSAqc2RwKQ0KPiA+ICAgCXN0cnVj
dCBkZXZpY2UgKmRldiA9ICZzZHAtPnNkZXZfZ2VuZGV2Ow0KPiA+ICAgCXN0cnVjdCBzY3NpX2Rp
c2sgKnNka3AgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPg0KPiA+IC0Jc2NzaV9hdXRvcG1f
Z2V0X2RldmljZShzZGtwLT5kZXZpY2UpOw0KPiA+ICsJLyoNCj4gPiArCSAqIElmIHJ1bnRpbWUg
cmVzdW1lIGZhaWxzLCBlLmcuIGJlY2F1c2UgdGhlIGRldmljZSB3YXMgdW5wbHVnZ2VkDQo+ID4g
KwkgKiB3aGlsZSBydW50aW1lIHN1c3BlbmRlZCwgdGhlIHJlcXVlc3QgcXVldWUgc3RheXMgaW4g
dGhlIHBtLW9ubHkNCj4gPiArCSAqIHN0YXRlIGFuZCBhbnkgSS9PIHN1Ym1pdHRlZCBieSBkZWxf
Z2VuZGlzaygpLCBlLmcuIGZyb20NCj4gPiArCSAqIHN5bmNfZmlsZXN5c3RlbSgpLCB3b3VsZCB3
YWl0IGZvcmV2ZXIgaW4gX19iaW9fcXVldWVfZW50ZXIoKS4NCj4gPiArCSAqIFByZXZlbnQgdGhp
cyBieSBtYXJraW5nIHRoZSBkaXNrIGRlYWQuDQo+ID4gKwkgKi8NCj4gPiArCWlmIChzY3NpX2F1
dG9wbV9nZXRfZGV2aWNlKHNka3AtPmRldmljZSkgPCAwKQ0KPiA+ICsJCWJsa19tYXJrX2Rpc2tf
ZGVhZChzZGtwLT5kaXNrKTsNCj4gPg0KPiA+ICAgCWRldmljZV9kZWwoJnNka3AtPmRpc2tfZGV2
KTsNCj4gPiAgIAlkZWxfZ2VuZGlzayhzZGtwLT5kaXNrKTsNCj4gDQoNCkkgdGVzdGVkIHlvdXIg
cGF0Y2ggb24gb3VyIGtlcm5lbCAodjYuMTgpIHdpdGggdGhlIGZvbGxvd2luZyBzY2VuYXJpbzoN
ClVTQiBtYXNzIHN0b3JhZ2UgZGV2aWNlIHdpdGggZXhGQVQgZmlsZXN5c3RlbSwgYXV0b3N1c3Bl
bmQgZW5hYmxlZCwNCnBoeXNpY2FsIHJlbW92YWwgZHVyaW5nIHN5c3RlbSBzdXNwZW5kLg0KDQpU
ZXN0IHJlc3VsdDogMTUwMCBpdGVyYXRpb25zLCBubyBodW5nX3Rhc2sgb2JzZXJ2ZWQuIFRoZSBw
cmV2aW91cw0KMTQ3KyBzZWNvbmQgaGFuZyBpcyBjb21wbGV0ZWx5IHJlc29sdmVkLg0KDQpUaGUg
cGF0Y2ggd29ya3MgYXMgZXhwZWN0ZWQuIFRoYW5rIHlvdSBmb3IgdGhpcyBjbGVhbiBmaXguDQoN
ClRlc3RlZC1ieTogTGlhbnFpbiBIdSA8aHVsaWFucWluQHZpdm8uY29tPg0KDQpUaGFua3MsDQpM
aWFucWluDQo=
