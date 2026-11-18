Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794990794;
	b=nz8426aW9K6D26Wpu8mxjXSZHHQULUNHB2u31gWNaL2WOjFocKGJbs6yOMmfUnc3tp13
	 nEV4dnFFGMtpoH4e2j7rkV01CmooXdjH0oVH8x6FS1avDYDO6GXv6BnCkzwr5MNVv/cVz
	 0bbWYTmeNX/MMgI6bdlocJlm2iRiYq0hOP06pe8rbeQqDb357UrL+ljVCx5A/i1/OsvCM
	 n2ZEQaZpLjrfBcw2/RedLL347I5GY2jsCAiBx+p5O74UWNWVfYqZ6ev8a+e828SvsoREs
	 XMOw5wl4yXbQJEwale1K+zOQFewHTCyyCBBWSGYgZOTUF7FhRWK00UQCAE4cOmbgZtg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990794;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5PSzULzlH9YdYq5Y+2btzYtaHlnNQtxlnbRgbJMQaUY=;
	b=HWsSNptkW2cJRc0MmVefBVO4f9jiMfCQnqISb0H2+F62iuMtyKKX6yDi3t4bT/p3Jd8A
	 5kkVwG8NXuYp0H5L8rQ/YnpQgYeVHXkjliKFcwdRSnknWFUnmTIuE7pkBf2M+Xa/Fz+hR
	 0cbQ00k3cteNNPqmHd4mY2/FIHVSN3t6drBUSJKnhKmnMXf4JGfSWnBVa8f8HNx+xMJA+
	 27FY9xJaxUdsB6GOoOtv+aULbZtMLAlk51HFcuHAF3rOKwnD9biZachfUZhrWQbEp9dOS
	 0AX7/+YGGbLP0gt1YvvYIAW5AEeL1o5M1OAOktfxFHZ4dEE9uzjPtMu/zis6Rw108bA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=tpg49Anj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010005.outbound.protection.outlook.com [52.103.12.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835A7606A893;
	Wed, 18 Nov 2026 08:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 835A7606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=tpg49Anj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bg5kor+Z1E6IHgpdA464Q67pSHNJnFgR/ySpgAgdejBJBO9lC7eumnAgBXHBu0QI0KnJNe0Z58ld4SMTNumIY15JZmmF2w7xG+HMCR2/Xib8/8K/GqJj3vD5gUP+o2NgeTbG4yEDbCBVsMZ0nlv+skG1Hst8f8OjTZSXcQdqG9OqPwhrQ0Q54zq6hVVGFUGKy/PuyW0+BimyV2hTnOu3pIpQHtxuytYbRu7XFC7RTNy+B0YhA3ZQ/LKZ2LNQmUnwkAtXtBPzaRWWSXFt0Wak54yFjXMYH+mRrqt9ONesjHgKnLQVnmdXvHkAM99a764RZNTveVbxt/6Riv59yklVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=5PSzULzlH9YdYq5Y+2btzYtaHlnNQtxlnbRgbJMQaUY=;
 b=Su31Ut7RG2SPaqZU0/N4v70VLQ537xWOzLPB1hmi1Wq281XmCwnMKTAiogOD1LiVKDwuQ1wAhNLWbz8uLY1106j8dx/yaTMS3769ItJ55u9JlnChORHG8ad6zNNjjy5pM8YVSe/AMG5N2L0ayOesluE1XkXcK0rKNhjlMntxssICxpw9J0Vz+ebd12bi0Y4wKy3b5qsH83bgaWhUO5hcC9Gq+I+dZMJNYNe5UJaL/sPKfkAtZci761QF9U42L7UF9XNJhuUmummojUs/g+dhsXuCP+n5oE6fUFGXM/ve3qVUSIRUtUxkkuwZmNN7jG+4lGlh14lu10jGT35ISWZx/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PSzULzlH9YdYq5Y+2btzYtaHlnNQtxlnbRgbJMQaUY=;
 b=tpg49AnjrzpmwysYP3N6YUhtN+P6NE1t3irC2jNrJGIoxvCP0aBylCWAwBJVXlA9CTqGgu+cH9cRfg63KlxSM2DEDNwlo2OOpECiyS6eWqXZL1WQSDR0Pi9ktkg3XPwAtxpbBUAaXDW01DtjttqkKpxLGGpE45aAGbwM2Z2VSuvFEtp32gchvRgmypEgrn6LVo+YskyUGFkGFvMqkXAt0UIzSz8qBnIOgULOEQ5XnmL5u+lHKqcmqReJrmbT3MFv0Kj7kqyFcrqA4Wl/VXXt8MSFwPhUSeMqttB1Ko/l0+fP4sRAj4F+kGXQxW79b7xY8BR/K82NK9t5g5qqp3Yncw==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999481.namprd05.prod.outlook.com
 (2603:10b6:510:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:33:12 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 08:33:11 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/4] scsi: bsg: release synchronous request before user
 copyback
Thread-Topic: [PATCH v4 4/4] scsi: bsg: release synchronous request before
 user copyback
Thread-Index: AQHddzdycODQBexG6keCjXOvy0+b0w==
Date: Wed, 18 Nov 2026 08:33:11 +0000
Message-ID:
 <ad9a3cc9df51d05b2089ceb2afc1fc687098f31c.1794990780.git.x-professor@outlook.com>
References: <cover.1794990780.git.x-professor@outlook.com>
In-Reply-To: <cover.1794990780.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999481:EE_
x-ms-office365-filtering-correlation-id: 2f7d4571-aaa3-4ea0-c844-08df454e94fb
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|25010399006|4140399003|41001999006|38102599003|24121999003|22091999003|8060799015|8062599012|31061999003|19110799012|15080799012|3412199025|4302099013|440099028|102099032|10035399007|12091999003|1602099012|53005399003|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?YkJmZCtTRWpIT21wTkt0T0F1YU0xWXpZMDBRTVkzV3dKbGxKOGEvRXd2dW96?=
 =?utf-8?B?Ymd4aytudUZNSUJMd2VmMmNsdWZMODF2L3VBdGx2OUNwUzRwT3p0NThxQmVp?=
 =?utf-8?B?WlBIY3ltZm5tRmpXejJ2dGVMV1ZHQXFZcGJZVEVkOE9qdzVUUy9CUXdrQ0JZ?=
 =?utf-8?B?YXRjeWo0bmRRSjNlcW5Ea0N3TzBINXVWbVQrSFVZS2RWclJuaWF5N3hFS05a?=
 =?utf-8?B?Zm9uZk1OOEdLZWl6S3NRRkRrcFAveG1NSmxTMHZ6MmhxUUNwMGZmWTltRjh4?=
 =?utf-8?B?QnhaL1J0TVg0b2M2MHJ3VFVod2c5L1hsdXNVSXlhczdrbGhkN2dCK2N0bndD?=
 =?utf-8?B?N3VDSkkraEtXRXVLOThxNkZmc1RtaEFOSFFwZ3lsL0UvVUFqREp0Y0tVWjBv?=
 =?utf-8?B?SzFwTWJDYmdIUjVNSDBieTRmRHd1WEkxNHU3KzJTK0NUUjFpMzFRRWRlQ0lo?=
 =?utf-8?B?bE51TUIwM1dYSk02WlArNHVxZk05VlVsZU8xUGtQa1pmOWhkN3dQZ2M3RlA1?=
 =?utf-8?B?cG0xTWtjblFqR3RHOXo5WTlja1VraXlFQWhUZEJ0VWtscUVNTGc1bTVDM1FR?=
 =?utf-8?B?MWc3TnQ0SFdPaG40eFl3cHBIREhMbEhrUGF3ejlhWjNtMjFaQWMwd2tWL2VM?=
 =?utf-8?B?N0ZhOWhhSlFnSVpJdDdieHlkK0I2cGcxTExyNTh6dGo3WDg1dEFNOTVyY1BV?=
 =?utf-8?B?TUttdE0zZzV2dVVhVHFWMnRWbkRETTVoc0UrZk41dE53d1c4bjNRN0Y1RFc5?=
 =?utf-8?B?eHpsMEdtbTh6U29pMFh3L2hiRitkNG9qOTgxNXc5RTVhczB6NFltK0JEV3lS?=
 =?utf-8?B?TnJ2MzRCMm1yaFhiSlpINjFST0NKQ3o2a2laRWFINzBSaUNWd2tabm9CMnh4?=
 =?utf-8?B?aTJNdGxqUFBZUzN0VnJjeG50ZnRYZlB2dFkzekR6WUtPZWFudzZEQjgzZzh3?=
 =?utf-8?B?WTRKTGFxek1qeHVoZlpxSkJodGRrVDY0TitlQndYRHVJdEtvSm5ackJZYVRp?=
 =?utf-8?B?QUF4Vzk4U0QrQk1IV1pyaXlON1hIbGdrRmVCUHZLVVc1L2dKelpCSzdmRjBQ?=
 =?utf-8?B?K0tDTnNBeGpiM28vcDRQZ0FHVktFWTg0dDdGUm5NZ2RWUGwzWER3cW5ydXBt?=
 =?utf-8?B?TXhneG82bWkvSFFONUxZQ05BWDA1eTZmMnkyWUtLSFhSSlNKRlZpZTdQRFV5?=
 =?utf-8?B?aXF3dU5ubUdHWHAvWVc2T3plcUNxTjA4Q3FYRE02QjAwVkZQUGgxZHM0QW9F?=
 =?utf-8?B?c05LREtmZzFwK01TWFN5RjU5WjJoMStTL3pPNXVJOC9VcnlQcTRtRHdGRENO?=
 =?utf-8?B?RXpRVHpQOHdHS0pXMlQvQ1prN3hoemdiZXEyQWUxUkg1UG8zb0tSVVI1OG5U?=
 =?utf-8?B?enZzOHgyS3AvcTh6bEJneFFSOVBQZU9kQ3g4dlhjOHlnSUZtd3JuQXNjclJ2?=
 =?utf-8?B?a1ZLdjBWd2tId3lISFF1bk5WZkd6ejJwMFFBZEY4TGdYQjYxWHpiRGd4UjlJ?=
 =?utf-8?B?WFVMV0Q1RFBmYzVwS2E2bzdYbmNsYVJhZTJVUHd5QjBwU01OY3JQdkJlM0tp?=
 =?utf-8?Q?LI1S9VF/CBrdRC4bfs5Rf0JzQ=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?emdhV0g3bm1nMWFpaUExdDQzdXloNGNtNk9ZUk1CcHkwY2xpaFJiOC9uSGNV?=
 =?utf-8?B?dFpTckU4bWp0VUpMaFFCYlZWRTdLVkxJWWwxU3pjSjVwcXpkNzRyTnpCTE42?=
 =?utf-8?B?R0xGbUVPTWQ4ZHNjUDhhRUFLY2VSYWFFbmNYZkNwdjIxdmtaMWpqU1EvUk5F?=
 =?utf-8?B?cHVKQzhCNWFCM2tBMmtVSmVPWTNROXJlV0FVclMxN3dDSnpYV25vdmI4T2dx?=
 =?utf-8?B?Wkk4YndMS0d2dys3MmhzNEc0YUszL1V2S3hXd2l0cWdZcG4xb2lXMkJIY2h2?=
 =?utf-8?B?SmFmaklsZXhEVktWV2tXQzRzYWhhL2NSQ2ZiTFVabndMRW0xWkROUUVBaW11?=
 =?utf-8?B?RStJeSs0M2lCdVQxTWp4RTdYcEFLTlhUZ3Z0eXRvYm1ic1ZIVG9BYkN1STlQ?=
 =?utf-8?B?RnNhRXJFaGx2RmZoODRIWVFicnN5VmNpWWdWZEE1ZDQwRE9PR0R6UHE2ckxm?=
 =?utf-8?B?L0psM3NHMUVrOUlaWHAvU3JZZ0ZwTWtaVWtFaVd3Q000bldxdHlsckN4bGdW?=
 =?utf-8?B?Rko5REdKa29CSjZnampnZEYvRGlpc2UzemNQQkdWcjVBd0Z4Z2E5a3BRSktJ?=
 =?utf-8?B?d3RabW15MWphOCtwZ0Zob2N0QUYweGN1Z0VFbC9RYUNRYk9qWG9tWC9QM2JZ?=
 =?utf-8?B?ZDQxeGRQTVVyZVZRa0lZN0VtVGoyWDA4NWdhcWN1ZU1hNzZSL2R1TGl5aDZw?=
 =?utf-8?B?b1J4R0F5NFF2WWlCMEVDMnhydmNNL1R2bk9jeGNlajRHakZKZEdEMkVOTjNM?=
 =?utf-8?B?MUFrOC9jQnArUHh5NmV5a01kNnpXVzhJV01haTFKK2lMdEY5QmwvWGZFM3h4?=
 =?utf-8?B?cGp5YktQeVdsS2wrWGhTN2RsSEpvaVhKM1hMczM1eVNUcVZXbFVYNm9MVnhM?=
 =?utf-8?B?SS9nVE5BWHNSTXlUdHdFVzRzNk1SVlRzd24veFpXMjRDVkxZSDFXeG5UamRE?=
 =?utf-8?B?cDk4azNxK3U1YWZ5cVI1enhsUHlGQWVKK05ER0kyemlGa2ozaGNYVmlaLzhH?=
 =?utf-8?B?bHB1d3ZoclRtZTlYcVV1QXJnNU5aV3JnaDBHZUszRUI3eW1hR01ueUNyU282?=
 =?utf-8?B?b2d5NHo1RWhCOW1Bb3Axb1B4VWUvRGJvVHY0MW9qeGhnNWZPbGw3eWdTVzFv?=
 =?utf-8?B?cnZGZk82VkJReFcrWkZIQTFaY3locVpvTU9rYTc3Rm40RXpPQVpFNUdmSjR5?=
 =?utf-8?B?YWNmc0lpNTJyVXRqQ3BHSndjbmR5Uk1NYWlqRG54RnNaY2VkMXQ1WitBOHhX?=
 =?utf-8?B?M3loTjl2bnlqT3pLVVJlVDYrY2dJaHdpUnRPR1drSmJFUVJQb2YyOUVJaUww?=
 =?utf-8?B?QUQ5TDZpak83d0FCVGlhUGZmSm5TT3gzT2Q2QlMwMUNGT3FYdnNrOFdPTTc0?=
 =?utf-8?B?Q3dndmdYajhEUU9XdnphRW1WM0ZlQnhMU1dQQ3pPeHRrV2ljWmY2aEJpemw1?=
 =?utf-8?B?S2VmK3UwSm5KbTUxMGJhbGVsSjZPVkwzdVpsNXp5NTd1a2lLY3BPY3J3d0RC?=
 =?utf-8?B?MVhzbStEVzM4TjlwUEF2S3hPLzV2NnFVZ1g0WUhILzlPL3d2VXlpdU51Uy9p?=
 =?utf-8?B?QW8ySEtFNVhHWGdlbmo2NHBka0Y0Z001MStNcDZtQ01RcTVYZjM5c1c1U0N4?=
 =?utf-8?B?cVZJZEJRdUVrT1Z6aldJaG90UnRMRTY4b3Z4RHFMOExBd2lDdlpESm9vc3hK?=
 =?utf-8?B?TjBFMDc1QUYvWGZSRG12bmZKL09DR01lRWQ5THdVWmdEcE1ySE9qSVozaFBH?=
 =?utf-8?B?aE95VHZzRW9lVjJkMGlQbnFxY2hWVlFxWEVkVzYwNkl1TWxaNVFFSU02OHhn?=
 =?utf-8?B?RGxJNmVVaEgwRVB3NzV3UU9XelRiOWN4VUpsZTlXTlYyWFVHVGhBMTR2RzlK?=
 =?utf-8?Q?LTvRxGx/5MH2t?=
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
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7d4571-aaa3-4ea0-c844-08df454e94fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 08:33:11.7642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999481

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KClRoZSBzeW5jaHJv
bm91cyBTQ1NJIEJTRyBpb2N0bCBjb3BpZXMgc2Vuc2UgZGF0YSBhbmQgdW5tYXBzIGl0cyB1c2Vy
CmRhdGEgYnVmZmVyIHdoaWxlIHJldGFpbmluZyB0aGUgY29tcGxldGVkIHJlcXVlc3QuIENvcHli
YWNrIGNhbiBmYXVsdAphbmQgbmVlZCBJL08gZnJvbSB0aGUgc2FtZSBxdWV1ZSwgd2hpY2ggY2Fu
bm90IHByb2dyZXNzIHdoZW4gY29tcGxldGVkCnJlcXVlc3RzIHJldGFpbiB0aGUgYXZhaWxhYmxl
IHRhZ3MuCgpGaWxsIHRoZSBrZXJuZWwtcmVzaWRlbnQgb3V0cHV0IGZpZWxkcyBhbmQgc2F2ZSB0
aGUgYm91bmRlZCBzZW5zZSBkYXRhCmJlZm9yZSByZWxlYXNpbmcgdGhlIHJlcXVlc3QuIFBlcmZv
cm0gYm90aCB1c2VyIGNvcGllcyBhZnRlcndhcmQsIHVzaW5nCnRoZSBvcmlnaW5hbCBCSU8gY2hh
aW4gc2F2ZWQgYXQgbWFwcGluZyB0aW1lLiBQcmVzZXJ2ZSB0aGUgY29weWJhY2sKZXJyb3IgcHJl
Y2VkZW5jZSBlc3RhYmxpc2hlZCBieSB0aGUgc2VwYXJhdGUgZXJyb3ItcHJvcGFnYXRpb24gZml4
LgoKVGhlIFNHX0lPIHY0IGltcGxlbWVudGF0aW9uIHByZWRhdGVzIHNjc2ktbXEuIFRoZSBmaXhl
ZCBzY3NpLW1xIHJlcXVlc3QKcG9vbCBpbnRyb2R1Y2VkIHRoaXMgZGVwZW5kZW5jeTsgbW92aW5n
IHRoZSBjYWxsYmFjayBpbnRvIHNjc2lfYnNnLmMKZGlkIG5vdCBjaGFuZ2UgaXRzIG93bmVyc2hp
cCBvcmRlcmluZy4KCkZpeGVzOiBkMjg1MjAzY2Y2NDcgKCJzY3NpOiBhZGQgc3VwcG9ydCBmb3Ig
YSBibGstbXEgYmFzZWQgSS9PIHBhdGguIikKTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
ci8yMDI2MTAyMi5zY3NpLWNvcHliYWNrLXJldmlldy4zMWI4ZDZhNzBmNGNAb3V0bG9vay5jb20K
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogWWluZ2ppZSBXYW5nIDx4
LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvc2NzaV9ic2cuYyB8IDIy
ICsrKysrKysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCsp
LCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2JzZy5jIGIv
ZHJpdmVycy9zY3NpL3Njc2lfYnNnLmMKaW5kZXggM2NmMWNhYWQwMmY3Li41ZmZiZDE4NDM4NjEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX2JzZy5jCisrKyBiL2RyaXZlcnMvc2NzaS9z
Y3NpX2JzZy5jCkBAIC0yMDcsNiArMjA3LDggQEAgc3RhdGljIGludCBzY3NpX2JzZ19zZ19pb19m
bihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHNnX2lvX3Y0ICpoZHIsCiAJc3RydWN0
IHNjc2lfY21uZCAqc2NtZDsKIAlzdHJ1Y3QgcmVxdWVzdCAqcnE7CiAJc3RydWN0IGJpbyAqYmlv
OworCXU4IHNlbnNlX2J1ZmZlcltTQ1NJX1NFTlNFX0JVRkZFUlNJWkVdOworCXVuc2lnbmVkIGlu
dCBzZW5zZV9sZW4gPSAwOwogCWludCByZXQsIHVubWFwX3JldDsKIAogCWlmIChoZHItPnByb3Rv
Y29sICE9IEJTR19QUk9UT0NPTF9TQ1NJICB8fApAQCAtMjY2LDI0ICsyNjgsMjggQEAgc3RhdGlj
IGludCBzY3NpX2JzZ19zZ19pb19mbihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHNn
X2lvX3Y0ICpoZHIsCiAJaGRyLT5yZXNwb25zZV9sZW4gPSAwOwogCiAJaWYgKHNjbWQtPnNlbnNl
X2xlbiAmJiBoZHItPnJlc3BvbnNlKSB7Ci0JCWludCBsZW4gPSBtaW5fdCh1bnNpZ25lZCBpbnQs
IGhkci0+bWF4X3Jlc3BvbnNlX2xlbiwKLQkJCQlzY21kLT5zZW5zZV9sZW4pOwotCi0JCWlmIChj
b3B5X3RvX3VzZXIodXB0cjY0KGhkci0+cmVzcG9uc2UpLCBzY21kLT5zZW5zZV9idWZmZXIsCi0J
CQkJIGxlbikpCi0JCQlyZXQgPSAtRUZBVUxUOwotCQllbHNlCi0JCQloZHItPnJlc3BvbnNlX2xl
biA9IGxlbjsKKwkJc2Vuc2VfbGVuID0gbWluMyhoZHItPm1heF9yZXNwb25zZV9sZW4sIHNjbWQt
PnNlbnNlX2xlbiwKKwkJCQkgc2l6ZW9mKHNlbnNlX2J1ZmZlcikpOworCQltZW1jcHkoc2Vuc2Vf
YnVmZmVyLCBzY21kLT5zZW5zZV9idWZmZXIsIHNlbnNlX2xlbik7CiAJfQogCiAJaWYgKHJxX2Rh
dGFfZGlyKHJxKSA9PSBSRUFEKQogCQloZHItPmRpbl9yZXNpZCA9IHNjbWQtPnJlc2lkX2xlbjsK
IAllbHNlCiAJCWhkci0+ZG91dF9yZXNpZCA9IHNjbWQtPnJlc2lkX2xlbjsKKwlibGtfbXFfZnJl
ZV9yZXF1ZXN0KHJxKTsKKworCWlmIChzZW5zZV9sZW4pIHsKKwkJaWYgKGNvcHlfdG9fdXNlcih1
cHRyNjQoaGRyLT5yZXNwb25zZSksIHNlbnNlX2J1ZmZlciwgc2Vuc2VfbGVuKSkKKwkJCXJldCA9
IC1FRkFVTFQ7CisJCWVsc2UKKwkJCWhkci0+cmVzcG9uc2VfbGVuID0gc2Vuc2VfbGVuOworCX0K
IAogCXVubWFwX3JldCA9IGJsa19ycV91bm1hcF91c2VyKGJpbyk7CiAJaWYgKCFyZXQpCiAJCXJl
dCA9IHVubWFwX3JldDsKKwlyZXR1cm4gcmV0OwogCiBvdXRfcHV0X3JlcXVlc3Q6CiAJYmxrX21x
X2ZyZWVfcmVxdWVzdChycSk7Ci0tIAoyLjQzLjAKCg==
