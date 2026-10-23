Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.156.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792747698;
	b=yVLioQVL/3PqxsAmszNCei1FVzpQWrTLGA8kdpu54c718gPU845BeM8f5gfq7OjSTVrV
	 OKaVIUfqtDxFAur/1ymZbbpvMzt/TS2HBHwenLNTw+8UD0c0Vd6nDWHfxHg1UHofV0NV9
	 uZi3ZxU7jZqwqIzNGOHiEMjrP+kBDe/IJOR1vU/Sg5ltnTYZB+ih0xjMbmZ1EMeTA+4Rp
	 phCWZmnPMbNtFijUD6Ix4moM+whkFsWdhdb/lgVa8tVLiVFokB/NnfLso7D5Stk226j85
	 9nxzJrHtHcOJ8I29tb0MFcZBJ8njPqxINnwE4jdeteBIMNSOfQPLsxeEdzK/glHdWeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747698;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:msip_labels:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version;
	bh=9U/zLQH5BTWxwStvxA/6BX6ghiSV1FcbzWd8ZpYPl2Y=;
	b=yZPtGMayTSuqVrUL40FfLkilpHCKgl9RT922I1ygqIaFknjtHEhTuREMUH2ECA/4lPsJ
	 +vnVXWTdQJ4GULI6wit28SQ2wLeixhI34J3YEb9eavQOGJVLrBYsw06OHOWlcOiuRLITO
	 yi2P6vAJr+DXr9o0iwy761J2HcoXDMDZTxduvxDyE0rOPESkLulAvewbEfL6aQR/hAKd7
	 UVUigOfKC/2Li/5qjJMFzmPkzdQrmzAb+xObSybnNjY5+A4Vyr9f35bm1nIs4wnNoeqiM
	 icmRXcrVAoePs6fy1tr6lk8WJpQqjiGYz5kUKJwZkvsFPnOyCo0VBEgVuGhWp5uW+Cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=rSaYxXbU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D257E606A322
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 09:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D257E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=rSaYxXbU
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7E21r2859431;
	Fri, 23 Oct 2026 02:28:15 -0700
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021092.outbound.protection.outlook.com [40.93.194.92])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hfn6ccqp8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 02:28:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWpCvwZlBMkYhqFUn81RNTFZCQD+Qv7DxwuP4DWz4VAdSg9Khj1WNzBn8OILz4WGqE31SSZVsF/Y+mgmYN0VAXHCjHDEifHKjaDZLnEuIMjJmjCFQHqijPv7klvM+kRF0KslUyHCazxVFoXDzdT3ajnSjhPev+OVnjFzxvnHjpuIEMIw38jVIRaKpfMw9TtfJvohFQ7ic/v3lUHjMyAOq/xzevCjtLtlDTemht+tCUlzM+kCqvESsxv/KfZVD5myfoPIEJ+Mzve/Di2AN3H4EkZCl15XN4+88hp7G9lSJGrZwoirKxxyq6cCLgDnsd3M+E/+fezJowlgurWdqRioBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U/zLQH5BTWxwStvxA/6BX6ghiSV1FcbzWd8ZpYPl2Y=;
 b=mwJSWuuUavBjUnA7EDjVFsDezStB4yepJ+bFEnxZ2TDf3M21iIdnC/lEiK3hVdtnZ77nTD2x4Q7D3kmeZQSOPQxW0go6J4eHuQInQKcPcmLZ8I38fKjEzOZtkdTC5I0Hwc0B/EC616iWbaMzm3JsHKasBdsQB2H1EjcO2QoQOUib1oVPmZXEMxAe6thEvs1IYvEGTzFRVZX2Y4+JnsEb9k64gTYjX+9ROmnS/Ve8Gj0dLQF5PAAYLFvRixuC1ZI1qFYiV7zYjnFd/3lwBznQuEAqmLH0b95hZDMw4SE/uGtJL+KymqzlDFJOG8CZTCw8dlK4FeCA9n2oBi7PxK9/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U/zLQH5BTWxwStvxA/6BX6ghiSV1FcbzWd8ZpYPl2Y=;
 b=rSaYxXbUU1jT0OSMQksD4ao7jcDfS6XI2wHRZjD2zVrFohUsYInl+LMYyif19G8iycdop0GD13PDo7Fjo57DqBHwd/4Nk9QrcqDh4wkHqqkAiFrmT6rQ6sQTiSXWi3bygUh9fAOSYalHdvj+OIhhSODLCLEjWYaUEyddYiGpw+0=
Received: from PH7PR18MB5101.namprd18.prod.outlook.com (2603:10b6:510:157::21)
 by MN2PR18MB3447.namprd18.prod.outlook.com (2603:10b6:208:26d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Fri, 23 Oct
 2026 09:28:11 +0000
Received: from PH7PR18MB5101.namprd18.prod.outlook.com
 ([fe80::7bec:ca48:661:acce]) by PH7PR18MB5101.namprd18.prod.outlook.com
 ([fe80::7bec:ca48:661:acce%6]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 09:28:11 +0000
From: Manish Rangankar <mrangankar@marvell.com>
To: Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        GR-ETH-Storage-Upstream
	<GR-ETH-Storage-Upstream@marvell.com>
Subject: Re: [EXTERNAL] [PATCH] MAINTAINERS: Update Marvell Ethernet storage
 maintainers
Thread-Topic: [EXTERNAL] [PATCH] MAINTAINERS: Update Marvell Ethernet storage
 maintainers
Thread-Index: AQHdYsu/Wx/D8hZB2USlSRl1o811LLcK28vv
Date: Fri, 23 Oct 2026 09:28:10 +0000
Message-ID:
 <PH7PR18MB5101317B1788B62D323E2EE2D8642@PH7PR18MB5101.namprd18.prod.outlook.com>
References: <20261023085112.1378540-1-njavali@marvell.com>
In-Reply-To: <20261023085112.1378540-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR18MB5101:EE_|MN2PR18MB3447:EE_
x-ms-office365-filtering-correlation-id: f1ae0d15-5a2d-4c48-84e5-08df30e7f4ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|18002099003|261021123027099003|22082099003|261022105027099003|10067099003|261009223027099003|11063799006|261021121427099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 F3i43lNT6OCqi4nHqwMUCYwTWdOEqM5/fQkyOZpIWcfHpJvOp6hXZMafptU7TGqbzViLYS8TuOeojM4Box7IMbT+KfgS8GidRbNVw0st0DrU2MLwTRAQym9SFj263cu1H5NoNz68JfhGtc4a6d4+SiKzyOEIA9j6cS7LMxOP09UohnxBuDjXAVqwBZC+PrJ7IEiWX2LETi1cqOQnkJXscPSoAvu02JhIZSuOfQBl0WE+jcexSCVvXbO3Z+tYsH5Iw+dmfq73x6WSmq+ceQ+yQnk8XhpFovsMR8uXIbIMVacsmhwQ5PObmo96cHf831ywy3MXSmCkLXhWFCQgJiEV/HOk/BSuZwaSbnB13TQribOqWfG72ELe5pp0eUw4t3JTJ/E91nmXE/+bE0tbewrxFb9DWXo3DR3arGItUEw7lh3J4FFAQe6nYVPLh1QA+Co9eBSlm0D3N2wb9LQAZsDJkyjIVBLMKOhnQfgM3d7Exhla0Ic3OX4cKOqc6X6WXn1dHHC4sPTDE9S48MJg//tZWnrgGWwsQoYfPJbbxZ/UQ5ArylADhoU8jzEDcMziyxf4zPCV9idy1c91B5AorZGeBofBPYK0MJidUCkP7xytfGb4GzOUGvF1RmLQeIpBz7Di3Y8P+ar2oD9UVZaZQiOd6kXRbVYFt6laiaeQDOF7LxFe8T67rEde/FCS6bGyFQc4GLAYcIIcKZnsdYtpJonEo3+w7jFrMJv0HZidxgzzRLA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR18MB5101.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(18002099003)(261021123027099003)(22082099003)(261022105027099003)(10067099003)(261009223027099003)(11063799006)(261021121427099003)(56012099006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Ukh1SmpOZlRhUm9adzBvMkUzaWxPcEF3cWpWaldrNk1HaFd6bzdvcEk3L29C?=
 =?utf-8?B?b1BhNysxZ3I2eGFrbVIxUjk5c0pIdCtQSzlYcUZvelZQeWtqRm56QmJBRGth?=
 =?utf-8?B?eFpSQjIycnkvOVdzb0JKa2pPdTFwazJZMUdmVHZSNDh0eVNzMlVNNGlNVTNj?=
 =?utf-8?B?MjZna1J4a0Zna3pkRnl2L0ozZmdadXVaNzhsa2xmL2kyREtiaEpKOWVRTk4w?=
 =?utf-8?B?ZFVHN1RXSDlHWVNZZEwxb3p2ZmF6QjBJZkhkL0ZJeGg1WnljSUFRMy96ZUhk?=
 =?utf-8?B?SncxNmVtZ1p1a3NETjBtSUl4dk9PR0ZQeHk0V0JoYW9XWFp5ZW92ZlJyZnB5?=
 =?utf-8?B?dm1BZHdoWW9iUTU5cGZHd1hYRVFpL2NZUkIyL2tMZ2U5THN6R1dGK2VHeG9a?=
 =?utf-8?B?Rzd3bW5JMWQwQkowaWJ1YWZ5VTh3NlV1bzRlQWU2czJCTUFOczJZQ0lLVVlO?=
 =?utf-8?B?WHdNTWhDcXpCcDBFSXNuZG93cWxNUlV0RmdXWEt1dVVjd20zbm1tM1M5V1lh?=
 =?utf-8?B?N1NHWTh0b05tK1BSMkJ4Mlc5a0VES1FaY3ZoNmxoRFFrK1UzUGhyVkNvalIv?=
 =?utf-8?B?VHZMMjU0UW9FSUc0b3VKUWd0YzNDanhoZ2JlZWJhbXFmWlU0UzB5dnlPV3pP?=
 =?utf-8?B?Q3lYVzJWNkFyMGFyTENtOUZGbDkyTnNmbXo3VGI4Y1ZXV0hyVHZjanNkVk1M?=
 =?utf-8?B?M0JkMk5HZzRqbXNqOFhVcHJIYVUzenhnTkJ4NlB4eGJ0SFFCMWlKL3R2YldD?=
 =?utf-8?B?Z2JuS29TdHJyWWtDRmVOTW92RFowL1ZvSGpENGNBMktrN0Q0WFhRQnVIbUxp?=
 =?utf-8?B?RFlKSFdIbHVMcGJ2WXZhRXVEa21kOGNTc3V6TXVpaWY0Y3VZclkvNUo2S2xL?=
 =?utf-8?B?RitadlYrK2FnSnBRdnVrOU5HR05DUldvZ014SmduMHBxbjdtaGdjODJSc0Fp?=
 =?utf-8?B?RjJrWWh1bFV1cmQ1bUJZMGlXMXM0S2k4TjMra1dSWW5JcTB6MjdOZ25LcWkr?=
 =?utf-8?B?YjY1OFF3ZmZIMmxSRXp5QVcwMmNjNlZERm1nMzArcEFtZnZnU3hDOGo4eUF3?=
 =?utf-8?B?M2U4UXdJc0pERmxwcDFXSE1JejFRR0F5bXE1QVBnODREdkRrUzlJeS85eUlZ?=
 =?utf-8?B?QmhLOEZ4M2tjZ0pKdlc1TFVVMDdFNm1ZaWhWWjVMN3gyOTk3d0xXVElhVXBv?=
 =?utf-8?B?ZjFRb0dQKzZtTDE0WDZUZGt3WCtiL3ZFMVBINjUvYnVnbGpaV05HSS9Oa3Fv?=
 =?utf-8?B?bnl6NEFCVkNQbEhPakY5ZWpxb1NCWGpRam9JeG1memNTd2ExVGZHcGZFTm9Y?=
 =?utf-8?B?S05kdmFGdk41Y3MxUUE0VTZRZEU3R1diY3BSZ3NxNEp0MXArYWFtYThnUUEv?=
 =?utf-8?B?Tk5oaHNKeHpONStzbDE4WHVySGlXa0hJb0hBV0NtM0UrMHJNbUU3WFpwSXhH?=
 =?utf-8?B?dXNpOGtkQXdZRG15by8rUkNYbjJmb1MwVXNwQ2lIRU5QUU80QU5KVGgxc0NS?=
 =?utf-8?B?OGxveW9aSk5ZMGx2dmlRTFVlVGQ0Y2owUEUxbnN0VG5zMzMxaTRlbDIybndG?=
 =?utf-8?B?OWJReGUrSUY3N2lYY2xXa3lXT0t6alpJYk8xeGx6TlBWcGdybDQwWjdPcGRQ?=
 =?utf-8?B?NmhGUmsvc3VUVEpBRWtLaFVtUE41WitOVGU5ekJVQlZnRE9SbnhhUFlKM25l?=
 =?utf-8?B?bzBpUklLRjRzcDZuaXR1eHRiRFlLc1Izd3VZZXRNMURseHR4QTQxemdweEZR?=
 =?utf-8?B?bVdJY01DRUtSM00vYkpBTlRJZG0xQkUyQ21hYWU2TDB1NmZDbWppQ2NWN2Va?=
 =?utf-8?B?R2cwMkh4K0NGNFlacHV4SitObmIxZjRkSm55cGVSQkliZm9zRVlmQXVxS1Vs?=
 =?utf-8?B?WlBITnFqQVppNkpvcXpIR0N4WGZkZjUxZ3duRWFUdDFGeUVneGJpMzdNSW1J?=
 =?utf-8?B?WFd4MkZ6SHlXZVAyTmVQaHFUYXAxSWt0ZWVnQUh0QzlLSmFoODBLK3FkZ0xX?=
 =?utf-8?B?SDRKcUF1UC9Lb1NoNHN4OTY1V3Y1Q0JkcE10N0lKcUVGaTBGWExydjFmVGFk?=
 =?utf-8?B?NzRqVmdwK3pEaUlEdHJnZk5iOW1VR0NLUUh5ODhpbVRJVG55TjFER0pUY3RK?=
 =?utf-8?B?RVBDazJxUzRQQUFJaWNuamh3WFZ6Q0JUVVRFdWpSVk56ckppM0lrTWpOYTA2?=
 =?utf-8?B?dnBBSTNTclB6UVNtTHFodGxIUnpVbURMZmNVeUM5My9LeVhzZzFRcUNYTU0z?=
 =?utf-8?B?ZkM2QzRWTXJYOElkT2pBdUtkZlVSUXo4V2M1VStJNUNtQzI4MXBDbjAramN1?=
 =?utf-8?B?YThlMndoN1dVbTUxWUYwQ1laclczeWpWbHM4Z0xzcHpDeW1qMGZkdz09?=
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
X-Exchange-RoutingPolicyChecked:
	NHgr2zpNoRCEgXxgFGzuqxbSrv9UDD0tbeUsdacurd3+h4hDOSkVQ2uuVlUW29DTz8A/Q/ke4FyQHSPF1KEjsqH3r78oyAI2SNCqCx5A6ttSPVWDZmyfujuV+u86TpzqjYhGNz/GFeODvAf2bOZCG64yQ+mNN8KNZws994sCotEnC7L8v7nl0xckhv5+Tm/xvZmr0M1jxaUTi2e2nlSH4Rz9EeUzFryM8vdg72uhbXdzujf61fq6JzxEJyDuabKsPNj9wtBSuylb4x7TvVYuNg2aO3ZJt3GVJe5nMXX26OefgGk3YEYrH04pRT3/ErtVehTEGklHYvquLVvcvPGFSQ==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR18MB5101.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ae0d15-5a2d-4c48-84e5-08df30e7f4ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 09:28:11.0090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nc+WLL956OUPrKx2YITKWWZAmmLiaKgQuMsVpUnqvK+B5qBM6JQHGoTP7n5Y6YLdbgOgxd0vCWl+iKLKrpLUUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3447
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Se9i5fRu c=1 sm=1 tr=0 ts=6adb28af cx=c_pps
 a=FqDfg28UJuADJc1XZx4kXg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=dtRhXEUe8RYxJtPwphMA:9
 a=QEXdDO2ut3YA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzNyBTYWx0ZWRfX+G4JVS20HLZ4
 OwhVmu8uYX5elS9Y9dv65g11TdWOAEdMd7Rq9QDI3FA40L6U1om6r42DJDFLr6uZsJZ/gUqjg04
 bR1kohkqvxca5YuYxmYcfFET7lKnOxOGa6jgD+9aLNgx8lwsa7QeK/wFLaTi7xT9jyspdr0BtyR
 jbzZgT28YnRXJ92foQLiBHkqN/BAhTZAgGqIZ1Ni/YJNBiuvZdZeCNbGaUbcY27DCEGH47kREw3
 UcIMeIi9txsqu/jWdz5El2TDFp9UJE3EaPjigQY3w0O1JyTUJ0MGLKhdAgyFpko4hJrdMGiO5QX
 0M0uw1z+HWo/AB07xn4Pk5OWs0DE06qHpA2AybODkCDvDW3Xmbg+7+z1GUIF51ZyrYiKDLLj8d+
 vqWFNHIM6aVcUuqsFb6dc8SzJy/y5iaSWb31JeySHYd8aWt1M3Z/TbwBiirUmLVfK01sW3EUMlY
 EpweJg6aFYaEyisLsAg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzNyBTYWx0ZWRfX2nOVC4qMZC7C
 hTAzepECJllOpMnaXL73lseYNo8FDEJWuU1LrtpoBxbmIGhoqhL6RU+s4TOmYJivkTejW/P88zu
 6qM5jTH8jnRWM8UxFarbnZQtoSniZZ0=
X-Proofpoint-GUID: 62mkNbdnd_UbfhXh2wBUD_92kc7qxE4L
X-Proofpoint-ORIG-GUID: eIxoXeuKKZGW2q1ivyWxtCtraQP-dXmt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01

QWdyZWUgd2l0aCB0aGlzIGNoYW5nZS4KClNpZ25lZC1vZmYtYnk6IE1hbmlzaCBSYW5nYW5rYXIg
PG1yYW5nYW5rYXJAbWFydmVsbC5jb20+CgpUaGFua3MsCk1hbmlzaApfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkZyb206IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFy
dmVsbC5jb20+ClNlbnQ6IEZyaWRheSwgT2N0b2JlciAyMywgMjAyNiAyOjIxIFBNClRvOiBtYXJ0
aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbSA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+CkNjOiBs
aW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyA8bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc+OyBq
bWVuZWdoaUByZWRoYXQuY29tIDxqbWVuZWdoaUByZWRoYXQuY29tPjsgR1ItRVRILVN0b3JhZ2Ut
VXBzdHJlYW0gPEdSLUVUSC1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPgpTdWJqZWN0OiBb
RVhURVJOQUxdIFtQQVRDSF0gTUFJTlRBSU5FUlM6IFVwZGF0ZSBNYXJ2ZWxsIEV0aGVybmV0IHN0
b3JhZ2UgbWFpbnRhaW5lcnMKCgpBZGQgTmlsZXNoIEphdmFsaSBhbmQgTWFuaXNoIFJhbmdhbmth
ciBhcyBjby1tYWludGFpbmVycyBmb3IgYm54MmZjIGFuZCBxZWRmLiBBbHNvIHVwZGF0ZSBlbWFp
bCBhbGlhcyBmb3IgYm54MmZjLCBibngyaSwgcWVkZiBhbmQgcWVkaS4gU2lnbmVkLW9mZi1ieTog
TmlsZXNoIEphdmFsaSA8bmphdmFsaUDigIptYXJ2ZWxsLuKAimNvbT4gLS0tIE1BSU5UQUlORVJT
IHwgMTYgKysrKysrKystLS0tLS0tLSAxIGZpbGUgY2hhbmdlZCwKWmpRY21RUllGcGZwdEJhbm5l
clN0YXJ0ClByaW9yaXRpemUgc2VjdXJpdHkgZm9yIGV4dGVybmFsIGVtYWlsczoKQ29uZmlybSBz
ZW5kZXIgYW5kIGNvbnRlbnQgc2FmZXR5IGJlZm9yZSBjbGlja2luZyBsaW5rcyBvciBvcGVuaW5n
IGF0dGFjaG1lbnRzClJlcG9ydMKgU3VzcGljaW91cwrCoApaalFjbVFSWUZwZnB0QmFubmVyRW5k
CkFkZCBOaWxlc2ggSmF2YWxpIGFuZCBNYW5pc2ggUmFuZ2Fua2FyIGFzIGNvLW1haW50YWluZXJz
CmZvciBibngyZmMgYW5kIHFlZGYuCkFsc28gdXBkYXRlIGVtYWlsIGFsaWFzIGZvciBibngyZmMs
IGJueDJpLCBxZWRmIGFuZCBxZWRpLgoKU2lnbmVkLW9mZi1ieTogTmlsZXNoIEphdmFsaSA8bmph
dmFsaUBtYXJ2ZWxsLmNvbT4KLS0tCiBNQUlOVEFJTkVSUyB8IDE2ICsrKysrKysrLS0tLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCA3NzZlYjc4ZGViNjMuLmE2MTZi
ZjU5NWIyMyAxMDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTUy
ODEsOSArNTI4MSw5IEBAIEY6CWRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDIuKgog
RjoJZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54Ml8qCiAKIEJST0FEQ09NIEJOWDJG
QyAxMCBHSUdBQklUIEZDT0UgRFJJVkVSCi1NOglTYXVyYXYgS2FzaHlhcCA8c2thc2h5YXBAbWFy
dmVsbC5jb20+Ci1NOglKYXZlZCBIYXNhbiA8amhhc2FuQG1hcnZlbGwuY29tPgotTToJR1ItUUxv
Z2ljLVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20KK006CU5pbGVzaCBKYXZhbGkgPG5qYXZh
bGlAbWFydmVsbC5jb20+CitNOglNYW5pc2ggUmFuZ2Fua2FyIDxtcmFuZ2Fua2FyQG1hcnZlbGwu
Y29tPgorTToJR1ItRVRILVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20KIEw6CWxpbnV4LXNj
c2lAdmdlci5rZXJuZWwub3JnCiBTOglTdXBwb3J0ZWQKIEY6CWRyaXZlcnMvc2NzaS9ibngyZmMv
CkBAIC01MjkxLDcgKzUyOTEsNyBAQCBGOglkcml2ZXJzL3Njc2kvYm54MmZjLwogQlJPQURDT00g
Qk5YMkkgMS8xMCBHSUdBQklUIGlTQ1NJIERSSVZFUgogTToJTmlsZXNoIEphdmFsaSA8bmphdmFs
aUBtYXJ2ZWxsLmNvbT4KIE06CU1hbmlzaCBSYW5nYW5rYXIgPG1yYW5nYW5rYXJAbWFydmVsbC5j
b20+Ci1NOglHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbQorTToJR1ItRVRI
LVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20KIEw6CWxpbnV4LXNjc2lAdmdlci5rZXJuZWwu
b3JnCiBTOglTdXBwb3J0ZWQKIEY6CWRyaXZlcnMvc2NzaS9ibngyaS8KQEAgLTIxOTMzLDkgKzIx
OTMzLDkgQEAgUzoJTWFpbnRhaW5lZAogRjoJZHJpdmVycy9wb3dlci9yZXNldC9xZW11LXZpcnQt
Y3RybC5jCiAKIFFMT0dJQyBRTDQxeHh4IEZDT0UgRFJJVkVSCi1NOglTYXVyYXYgS2FzaHlhcCA8
c2thc2h5YXBAbWFydmVsbC5jb20+Ci1NOglKYXZlZCBIYXNhbiA8amhhc2FuQG1hcnZlbGwuY29t
PgotTToJR1ItUUxvZ2ljLVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20KK006CU5pbGVzaCBK
YXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+CitNOglNYW5pc2ggUmFuZ2Fua2FyIDxtcmFuZ2Fu
a2FyQG1hcnZlbGwuY29tPgorTToJR1ItRVRILVN0b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20K
IEw6CWxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnCiBTOglTdXBwb3J0ZWQKIEY6CWRyaXZlcnMv
c2NzaS9xZWRmLwpAQCAtMjE5NDMsNyArMjE5NDMsNyBAQCBGOglkcml2ZXJzL3Njc2kvcWVkZi8K
IFFMT0dJQyBRTDQxeHh4IElTQ1NJIERSSVZFUgogTToJTmlsZXNoIEphdmFsaSA8bmphdmFsaUBt
YXJ2ZWxsLmNvbT4KIE06CU1hbmlzaCBSYW5nYW5rYXIgPG1yYW5nYW5rYXJAbWFydmVsbC5jb20+
Ci1NOglHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbQorTToJR1ItRVRILVN0
b3JhZ2UtVXBzdHJlYW1AbWFydmVsbC5jb20KIEw6CWxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3Jn
CiBTOglTdXBwb3J0ZWQKIEY6CWRyaXZlcnMvc2NzaS9xZWRpLwotLSAKMi41Mi4wCgoK
