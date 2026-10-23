Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792772589;
	b=SmeVcqrvX1RFrkt7S2ugySMFcP8ivijEIsfVNEKEjKsdLQvaa0QtVqMcpsWtAbiL4kWc
	 tP93ywHnIObDAoXV6N9Ths8wS+nm36feqQZ4Utb3Mq9F5Z5j1lslxYHhujQ4KMr77TUc1
	 VKsgmrm9olnromoBDFMHub3Pn/vQiC79FAAyXijlwwF36UUr2z8xU2D26GCK6UpVMRJY2
	 6Y9Y3b/D8TxzW9tICgGJi+bchSHEWjO1hhwDzZxBXZ0XbXqmy0ITYW+33/f+RDWGNegA6
	 xmpoAKh7GRq3SVCVo3lxZB3EcBfuZk1mxQofFRNqdOAKA8HSX6jCulx1zNbze2/se7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792772589;
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
	bh=txFv3sLJvORnYvcLEwMCSWbJNW89M6HTrSeKFjmr+vg=;
	b=Tcw33hTzWYa56DZcYzMdzC3q/FYd7aGW8HdvhYf3c2Zs1/SudWBp7BRRYqNmO9r/wjrN
	 nB8OdodcFAPrCefP+s6jx/AmtoqZyBGgQnmLxpM9uHZLPQmYs5oQWo/dclykjEJ0/G/q5
	 l62dmnlgpvO6CE/IU1VYDYUU30f0ShGXb3r2YX8yPTQe1yiFRQXb2JgnGGy2DH5hNidjF
	 KVl9hJfKE8QOurtmGvUeaCqVGdnHMRigFeScpc37k69HhMA7xoXiRCjgqwj4ZwDDc9n+b
	 OTCWHzo8RVNxtyhliAQcb1dWwqDAcfBfVPSS8JhOj0VYbr9v6B38OB12way8oy1ko1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=InpDmrWI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.27
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010027.outbound.protection.outlook.com [52.103.23.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCB0606A32A;
	Fri, 23 Oct 2026 16:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBCB0606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=InpDmrWI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZi/Ry7KLtTlVsSFDFm4Jj7UzJnIYF/WOEkRvor2agBIxAvb4/bVCFlpfYTFWi7TNPfb54kJoO3tFR0/BmsY7ODG9azq0xKLFa8ifQVpQTVX3kNMew3EUvwHvsrFpOemZfImPAPxH9bNPmBjFt6R795wOb+HNUbM/WWiBJsjbASxDclyZGbc57eqaG5xZPoeBEB9lYgNccKhMMC23wUSer5pLtE42G48NI8xdur0U38KEWhkNZtHUW/2ZpzoPikojaGadEoN7aNZy9UqnkxbAuUMPHlLj7toLctDuwJ6wKRB7bIbeR37Tgb0LpszLCrj2kqP+UZ51bGj5Pu2tw22xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=txFv3sLJvORnYvcLEwMCSWbJNW89M6HTrSeKFjmr+vg=;
 b=hcbSIPaW9t76E0xKvg6znaHMECUB6o+iXE3ddgGsL5nx1iwbpvZeew5TcpSjkoWfX8iRo8+JnDNIBgOeiEy1UtZAS+0iZNOH/3w/NRPjhztoeSTY98gvjS1yAectSoRel3WpVG07xmrHbf732MSmyE6u/xJd5j/aU1a2zI4hU0ERvS1nJAjLcutsbHegrQhMDBPt0rj6JyHQfm8eovzZx/uYsW//k8LqEzBe3laa29QqxE7maDhG5NSXAcQeJ9pJxwqjoDUfRn/OgVRL3UmXs/peJhzuDlDPIgI+RhMO9mnP9DxTDRz+YDlx767yAnfI0xDMPfUCzWMdoPvtUktLEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txFv3sLJvORnYvcLEwMCSWbJNW89M6HTrSeKFjmr+vg=;
 b=InpDmrWIEk0AjVI4WUFmn8MSVtK82j1gvFjk+0HQeEAJNdLrqxCGY2VKzytdg98H6WmCze4wViwkaZ8tWzhMxAe56pekszulgrWdfr5qJwF9nyFgdj0wL5FQLzdsGeBmtY/6DlA56pzx98QhBKrReErEEK+qIfra5H7r8wuCEHQK7EC5v+HqMs0SM5dCkkleYMtEKtvUph7khxKPZViVzoDa8nX4V5cDIYO3v480nFX4jUKMpXS6c8MNn68KIvD/HbUR/XDmIQjZFsNpyopo4nkQwzHdFbLfFyphsVKM+Zv+eW8y5xonzuLemk+QphahTgsSEeaW7xfRG7wnYZESKA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by IA0PR05MB10120.namprd05.prod.outlook.com
 (2603:10b6:208:3df::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 16:23:06 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 16:23:06 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Bart Van Assche
	<bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Yang Xiuwei
	<yangxiuwei@kylinos.cn>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yingjie Wang <x-professor@outlook.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] scsi: bsg: report io_uring data copyback failures
Thread-Topic: [PATCH v2 2/2] scsi: bsg: report io_uring data copyback failures
Thread-Index: AQHdYwrI7/nqd1tT4k6djVUrsuxpag==
Date: Fri, 23 Oct 2026 16:23:06 +0000
Message-ID:
 <0b35d2d46bf8ff9f2dbba83ae093d17351e950e9.1792772194.git.x-professor@outlook.com>
References: <cover.1792772194.git.x-professor@outlook.com>
In-Reply-To: <cover.1792772194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|IA0PR05MB10120:EE_
x-ms-office365-filtering-correlation-id: 096480ef-65dc-465e-649c-08df3121eba8
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|22091999003|25010399006|8062599012|31061999003|8060799015|19110799012|12121999013|24121999003|15080799012|8022599003|24021099003|26121999007|3071699003|102099032|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?OXoxODZ6VkJBSFlucDlRVU5pakdPMFZmTWxiOTRmc2hRYm4rcW8wL3dLQ0Rh?=
 =?utf-8?B?SHlDdzF1SDB3V0p6VEJsOHVUZ25EUDdsUFhiTFBIVmtXVk1rZEJueWtkR2R5?=
 =?utf-8?B?NExZSHQ1ZXJCN3l2MWJqSWVxNG1BMGdIZmpERzFpTlFaUHhxZmkvWXhMdVRQ?=
 =?utf-8?B?eFJScTZGODlWbGt5c1AxbFUrZDRBeEdoSnloUzRZR2VXd0phRTNoNXRURVdM?=
 =?utf-8?B?bnpSZmIwRlhaL1dsSVNRVXlDNG5VSXZzQm5TbHFrWThLZnB4d1g2bVhyd0Yz?=
 =?utf-8?B?WW1sa0ExYTVXMzdISDNubFdvNmpEQlNPenFlTFVLajl5ZElQTlZpbktmZ1J1?=
 =?utf-8?B?U01id291TkZhQlNoTGkyWVRIcEFQbTRXRVRuaTBPM1p3Y1IxZkUrL2p6SVgz?=
 =?utf-8?B?eUlsekFGN1Q3bk1uVVUvVlpIcENXd3lJNFdaTXY2a3BIQUpwYUFYYXlqSGlS?=
 =?utf-8?B?eXpvSnBvbGd0QUhzM3JjSUR6S0RlY2xjUmp5OGtPc3pXTU9JelJUcnRGNFNx?=
 =?utf-8?B?L2tEQjhMVG1oMFk5TXpFTjJ3ajJSMGVtcFJRWTNXM0tPRUhZZVVKeXFSc2Rn?=
 =?utf-8?B?YXRGNVEwQWs1Qk5HRXdYM2tBQSthazVIakNjQkZ0MHZFZFRJeEpFU2JWcVhp?=
 =?utf-8?B?Vm9oUGNSOWNqQk8xQVVURUlndWxMeVFxYzdpZm0wMVcrano4WEoyUHVOM2Vi?=
 =?utf-8?B?UHhzT3YvREwxblE3UXBkNjFkUWlEZFdEMnIrVHhXMCsrdkdqc3hVclRsZGoy?=
 =?utf-8?B?MzVmNGRHcEVhRTVHVTNXQlMwSDZLVTh4dTdJTzU2SnBwN2VhRy9qRUJGc04x?=
 =?utf-8?B?ZXpSQlQvUEllMHljYUVxMFVPZkNINUtzNW5aYlgzSDBrQnliK204ZUo0bS9J?=
 =?utf-8?B?UTZVeVFKMlh3dWpKM2dMVXlkRWg0Z0t2QmtMSG8yOVBkVXVwQnQwT0p3Z21G?=
 =?utf-8?B?R3FXVlU2Y0Q1RXc4QVg3UEJIUjZrdXlaUnhMNkwvMm9makUvcWpTMjh3djZK?=
 =?utf-8?B?Z1ExWVBnUkJ5M3Y0aTlEc2twVVg0eGdES0VDT2pMYS81akxnN2QxVlF0RnJQ?=
 =?utf-8?B?MjlIemtWU0R2T0lZSWZnUXByQ1FuNXBRLzdlckt4bm05ZkRnZUJWZHovK0ZN?=
 =?utf-8?B?SnFKcEJIYWNSRWpOL3U0cGdxdXBNdmVHRm16R0gvMGtlTk5JTVFyUWluZVdl?=
 =?utf-8?B?QklQbzNqbzRlS2ZUd0lUSVk5MHIwbFV1RW14NTVmakk4andkL0VxZTVaY2wv?=
 =?utf-8?B?ZlpBdGhNUjRoL1FCOVJqY2VsNlY5QnhrOTNWaXVJQW5UMk1ML29PVmlVbmNU?=
 =?utf-8?B?b2cxYXM3bWcwaDZxMUNyZjlmUzlPVXpHTTRrYzJZYVdudmF6WGJvL3hVR2N3?=
 =?utf-8?B?UnNUUnRwZGpPemtDMVZHbUJGQ0VYbnhMVG5UdGhLSEI2SDUwNjJvVTFMamUx?=
 =?utf-8?B?bzg5UDVEOHlHRjNSbHhxVmM4dWpqcWtkRkUzTkJwdzRPUUpJSHpMWVk0RXZW?=
 =?utf-8?Q?ANMfzz2sxG4vgxLDKB+ScT7GpZY?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c1BUODFpOWRmRVZrUzNqS1VMZ1FMaG9uclBURnd0UERKR2s0aTVtVVh3YVFY?=
 =?utf-8?B?MHZOQk5lcVNCWU5OTmJoMWdEaThONU8xTmJVYjJWbmZxVEcwQmpuYkZ1TXRt?=
 =?utf-8?B?eUFvQzluUSt1d1k1NWc0bUtaWWs4bytQTGVOTlVjQkhMWjVmdHdUZzM3b21S?=
 =?utf-8?B?YTdBZS9naHpnVXQ5QXpYVE9ERUtoMkN3dXRLaUZvRUVISk9EeVR3cjFhUVZa?=
 =?utf-8?B?bzdBcTRDVDlJQkN5UTN3cGNTVTdWTXZxNzdHSCtiV0Y5d0l3OHFjbEx4KzU5?=
 =?utf-8?B?eUJ5ZnpUZWlIMGN5cFRxczBORUZCZVB3a3VCVTRLNW53R3hXR3ZTbnhpQ1Yx?=
 =?utf-8?B?cmZQN1B2NHhaR2Y2NVdiYXdtRzVWZnVCOHVSRWZwZFEvdTNGR1dOUzJTekxN?=
 =?utf-8?B?VXVqR0FSZmdHazhNa2o4Zk5URjVNelpuT25TKzZxZDJsZzlyQmUvNFQ2Nyta?=
 =?utf-8?B?bXFTak9mS3kyNmtDZzlYYVR0RVBrRFBqRFRkcWZLL3RWdDBxVXJ1MTlsMWs0?=
 =?utf-8?B?VVNBZXduL1M3KzdpN3d3NGR3amhpbXF3dVpnVDRvYk9SbVVEK284UFVmVStj?=
 =?utf-8?B?S0o1b3VzWU5qRHYxN0ZqSmdyRFJNblZhRFp4S1dQM2xEN1hXM3AycHh1NUlX?=
 =?utf-8?B?VkVRYmFKNkFIaWgvL0tQL3hHb1gySUowVjBQYXc4MmdZa2NuU3NObVdjTjFm?=
 =?utf-8?B?VUpmaFlKbC9SVXFpb0F2dHNES1p4dXJQQlZJWVZpWjAzOFY5YmozYi9DMzNm?=
 =?utf-8?B?dC9URERybjU1dEpvNVpwYllTd0FIa2lBMVFGT05nQUlpQWxMcVJlRWdLVjFD?=
 =?utf-8?B?UjZFSjZkUllSK3d2MEgrcCs4VHNuM0F6N3NSL3QzSzNXeCt5RGZBaVJTUTZi?=
 =?utf-8?B?Z1ZoUnpHT1RKVEZwYno1NUpubVRENytFZHZVeFhmTkFma2Vwb2ZRNS9QSlQ1?=
 =?utf-8?B?YmNTZFkrZElkRXlrSEtjOTBxUHlwZGRESDhTMDd3S2VraXNFaWVxTEN5cjUy?=
 =?utf-8?B?a3lVckJXZVlrWjFVS1ZhMmk4aGY5aEZSWGRmVmx1TlF6UmpMU2xvNUxVWkJX?=
 =?utf-8?B?MGpsbHEwL21GVlZuQ0dDNE92ZmRrbFZXZjNYaE8wNFYwcEs5T3BMMkdwTGxz?=
 =?utf-8?B?MEN6aTBidndQenYwRDNuU1hYRk52TlZGeTVPb3BOS1oyUmE2Y2lEc3ZlbkNp?=
 =?utf-8?B?OHlidUR4amV1YTVSODhjdEhTRVkrbEhjbHp1OXRHb09iTXNFQjdkd1dhMXhM?=
 =?utf-8?B?VmRNL1RzWXBBQ3RtbUJseGYrM1huQXdKVGgydEFuVFIwSTN5cnkxTE45a2Er?=
 =?utf-8?B?TlNoTFZCMkpmNjZHYzhhUHAwVkJvbTBpSWdpeGVCd1FORDRhY3Nwa29JNy9a?=
 =?utf-8?B?eHdGYVlrbjErQTNjSHNkbWJPbGVYdFJUVW8wQVZiektwUVhRaHFOWHQ4TDVR?=
 =?utf-8?B?VWJ0Znp5VmlEWGY5ZmJIcGJCM2JKZFV2YkhmOGEvMTBvN2hPTHVsazZtM1dv?=
 =?utf-8?B?QmpOaFJpUkU3Z2pFeStJNzA1Q2FOUjNpNmRlZ0dDRTlHLzljWTMzYU1DdktK?=
 =?utf-8?B?WHhqMU5veFVDMS9YRVBGRmQ0UmJvZGR0cHhvWjBubExtQkQ2bVBDWVd1OUZ1?=
 =?utf-8?B?bUNMZkowL1JTTTVielVBaUdsRHF2S3N0RmpqZ3I0OSthZXA4b3NMYnd0RDlk?=
 =?utf-8?B?Vm9BdGJ5c0xLTzhSamV2bG5sRG9NYUVGMXZsT0VDaFF3b2wzRFU3N0dyMG05?=
 =?utf-8?B?SUhVdGo3OXphUjIxWnVyVFdWWmFZbHZ3L3VpMm1jNVFvTXo0eEdUckk2aDJ1?=
 =?utf-8?B?eVpmbWJtQ3NDbXJ6c0xLdGp4cWNBNVdNTE5FbkgwYlpLTzhNdkxEQ2JLdTVi?=
 =?utf-8?Q?8q6A6WAFaqRUr?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 096480ef-65dc-465e-649c-08df3121eba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 16:23:06.1563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR05MB10120

c2NzaV9ic2dfdXJpbmdfdGFza19jYigpIGRpc2NhcmRzIHRoZSByZXN1bHQgb2YgYmxrX3JxX3Vu
bWFwX3VzZXIoKS4gRm9yIGEKZGF0YS1pbiBjb21tYW5kIHRoYXQgdXNlcyBhIGJvdW5jZSBidWZm
ZXIsIHRoZSB0YXNrIHdvcmsgY2FuIHRoZXJlZm9yZQpwb3N0IGEgQ1FFIHdpdGggcmVzID09IDAg
ZGVzcGl0ZSBhIGNvcHliYWNrIGZhaWx1cmUuCgpVc2UgdGhlIHVubWFwIHJlc3VsdCBhcyB0aGUg
Q1FFIHN0YXR1cy4gQSBsYXRlciBzZW5zZS1idWZmZXIgY29weSBmYWlsdXJlCmNvbnRpbnVlcyB0
byB0YWtlIHByZWNlZGVuY2UuCgpPbiB4ODZfNjQsIGEgcmF3IEJTRyBJTlFVSVJZIGludG8gYW4g
dW5hbGlnbmVkIGFub255bW91cyBQUk9UX05PTkUKbWFwcGluZyBwb3N0ZWQgYSBDUUUgd2l0aCBy
ZXMgPT0gMCBpbiAyMC8yMCBydW5zIGJlZm9yZSB0aGlzIGNoYW5nZSBhbmQKcmVzID09IC1FRkFV
TFQgaW4gMjAvMjAgcnVucyBhZnRlcndhcmQuIFdyaXRhYmxlIGNvbnRyb2xzIHN1Y2NlZWRlZCBp
bgoyMC8yMCBydW5zIG9uIGJvdGgga2VybmVscy4KCkZpeGVzOiA3YjZkMzI1NWU3ZjggKCJzY3Np
OiBic2c6IGFkZCBpb191cmluZyBwYXNzdGhyb3VnaCBoYW5kbGVyIikKQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRs
b29rLmNvbT4KLS0tCiBkcml2ZXJzL3Njc2kvc2NzaV9ic2cuYyB8IDIgKy0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9zY3NpX2JzZy5jIGIvZHJpdmVycy9zY3NpL3Njc2lfYnNnLmMKaW5kZXggMzczOTNhOGRl
ZGQ4NC4uZTRhNjVkN2EyMzc0MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3Njc2lfYnNnLmMK
KysrIGIvZHJpdmVycy9zY3NpL3Njc2lfYnNnLmMKQEAgLTQxLDcgKzQxLDcgQEAgc3RhdGljIHZv
aWQgc2NzaV9ic2dfdXJpbmdfdGFza19jYihzdHJ1Y3QgaW9fdHdfcmVxIHR3X3JlcSwgaW9fdHdf
dG9rZW5fdCB0dykKIAl1OCBzZW5zZV9sZW5fd3IgPSAwOwogCiAJaWYgKHBkdS0+YmlvKQotCQli
bGtfcnFfdW5tYXBfdXNlcihwZHUtPmJpbyk7CisJCXJldCA9IGJsa19ycV91bm1hcF91c2VyKHBk
dS0+YmlvKTsKIAogCWlmIChzY3NpX3N0YXR1c19pc19jaGVja19jb25kaXRpb24oc2NtZC0+cmVz
dWx0KSkgewogCQlkcml2ZXJfc3RhdHVzID0gRFJJVkVSX1NFTlNFOwotLSAKMi40My4wCgo=
