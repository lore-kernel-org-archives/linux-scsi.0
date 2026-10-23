Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.156.173
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792750436;
	b=0xdLAABQBIxi4Ht/H/dlBv1ewYdft9ew35mOOt2R/JZPB7GjFvQbThy92WUC04T8qFZ5
	 Vvvw8o0W6PkHD6qk37BDEL5sUU305EKzkgb6+CiQet9HTaoFkemVsgGgTZqA42xt5yJBW
	 GGHhieAIV8e/2TlOBI4dx77cNl8FAsjwFlIdZsD+mhQ9OAwiAyJXNtbHaOb6pPORbcXIs
	 2/oGDNa/VpeKD2j0thXblEIOXIlb/I/hY2PZS7umtHGFr4Q6uAeaWPS5/hj+5vKpCS7dq
	 qDaLpHpdJdaTWEROjwQmXjUWNtujpmzfZ20JpjtgrBeAMBOiSzivrxV692gHtvkwEQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750436;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:x-ms-publictraffictype:
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
	 X-Proofpoint-Reinject:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=DDPSgyXWnhajcrGe7u2XW7mBAHpBBXGH29iP7dgT5XA=;
	b=TF6LDqLytr1NaTCtNX3xdinz405EBkzGe2xUMn4jmcGwRHd+yfQpqABJubUqIcX/23QU
	 1i8MYI4bWHMDmUKhcqmRD4WBB/+jadZ6TNtSLKgXyc/bNJ+Fr/rMNgP068XpasbLxITxU
	 R3rP08sc/pqoTQSvuQtNaogWMQ7PZ4ZPgRStYQ4lU1cM/HF0mpjhJaZXpNN/Kyun5DeV3
	 vUxhqqUchEbY0otzk5pKBmMGONjjjDzbDZbr1LT2w5sHNNP4HmRDda+tmTRr2zWPdN368
	 CvGIMxFTDjoOl85jUdPrywcv+vBirv17Tin9ZzKzCoYe93eFyHpiUDO4E5+Dc+lvLtw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=Qs3CG0TU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA72606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EA72606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=selector1 header.b=Qs3CG0TU
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADXkL3273150;
	Fri, 23 Oct 2026 03:13:52 -0700
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020079.outbound.protection.outlook.com [52.101.61.79])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b98vw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:13:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AGI6Go+Sut9/S8xm7bnz1eySdjRNr15CPXY4ujgoYMJl16aMQRcromMSHmXZ7m+qZ6LSD8kHDKR0U9Ghbok1/g2CGImEzq0oYtlAXlVHni+L4+2rY8iDPw0s9BgVPQ9PXHlTywQu96+UB0O3W1IlKAR6ntYHuTJbCbpNxRBKJtYbbKHLXOjkWOIp4tEbFHWXrxZS9o+ck44+HovqArvk9e7YETA6r0LzpOYsBgsbkIOnpi7oZANZ7fEO+uMAw/n/vvPpSDWnFEqWZkzqifUl4DVYijNKWAXXnponxcSGR8McEPfFCx7sv8+HHZ+jmNxPAmT8K/teK8hXGyAXR5S/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDPSgyXWnhajcrGe7u2XW7mBAHpBBXGH29iP7dgT5XA=;
 b=ERb9bk37h33M5XKbJa3/btrQFTO4Fg62/sfIHARsqzaj4NIkjSOWGIopgVViGCfM/O46cY7tXZO3uPuUgx/5BiArU96rxNh8dLvJB2h3S/9B2l+JxW0wzik2HvaWMRTj7Axd6JANBgLwPqp12utX6qc8/tOOGsZestL1l9BtLW/pltVFAAcM9sLAfyWu/F/wNSearf7sM/YUaaek2zlWEutV6pu4TFOn1NaTmoh+xDn9Vos2MQf5Yx32ZfH2IsXO4gzMVIdaa740LEgW2/YmG8MeIeFNm4F6FDkvA8vitiwP5MLJMfm7Ze3uxwRD1e9AnylDgQrIr4BDhD8upYmcdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDPSgyXWnhajcrGe7u2XW7mBAHpBBXGH29iP7dgT5XA=;
 b=Qs3CG0TUDRPKZlBqIYUWwxk7lkHecu027LS7WE2uvlnV0pIOHXJ0rG2BqSb7QKsZx3NBkBKPhVvAOG2ObYXADQkCNC2mCsuw7lv5fAY5yTVJ3DebiSNNuYkwzkXWExf42RiY7S5RzBlWxFwhBjautfi56c1s1amDJgAmftG1Ayk=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by LV8PR18MB5938.namprd18.prod.outlook.com (2603:10b6:408:227::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Fri, 23 Oct
 2026 10:09:48 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%4]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 10:09:48 +0000
From: Nilesh Javali <njavali@marvell.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-FC-Storage-Upstream <GR-FC-Storage-Upstream@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jmeneghi@redhat.com"
	<jmeneghi@redhat.com>,
        "hare@suse.com" <hare@suse.com>
Subject: RE: [PATCH 00/14] scsi: qla2xxx: Misc. Bug fixes
Thread-Topic: [PATCH 00/14] scsi: qla2xxx: Misc. Bug fixes
Thread-Index: AQHdYUY+UNU+rxjsjk+sUFBhew31cbcK6YmA
Date: Fri, 23 Oct 2026 10:09:48 +0000
Message-ID:
 <CO6PR18MB4500573914C728B19772EDFAAF642@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
In-Reply-To: <20261021102310.3854868-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|LV8PR18MB5938:EE_
x-ms-office365-filtering-correlation-id: 7bea1b13-7034-40ea-5c9c-08df30edc531
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|38070700021|56012099006|11063799006|261021123027099003|261009223027099003|261021121427099003|10067099003|18002099003|22082099003|6133799003|261022105027099003|261022075727099003;
x-microsoft-antispam-message-info:
 KsMEBOvzBQJ2zIfR4RzIhrj25lpi6DD1T5yOVTXO6wrmRsA+po38zj2UXpdgXArMsJhmwMtF6WtkI/cBbzL4cK0H00G/lumKwP/pE+Eq5IEf/kSyidKeFwUPgMpAOltBJTRbMFQ0IQPvOXLZEfQ6MRPDO0qi6uJTph5EIyQvkNwyXnerW2+hboXjTIM0Fzt8O2FEv2AVWVkret3u8oowJD1Bzntie8D2zML7vLUmSYW/n0wfcJytDPFgQlrn/4epIP1eI3W37xdzTexdGI229O1+qeS5b8a4viK5A5yDBbnNkhtZkbur/AJxfo0lQ63tu2aWiW96aBCS+uaMB6ajLNfxBUU7/VStYYN09uptwzORk71xcoIbdL6buYGvv/MzAhF6Yt42E5WLYX/xRAndgbsYCOFh/uRo/Zk5MvCktB63rNcm3JVFmhNrKbnhF9K/AC2pf2LDqpaMrZSeJNi4QCGohuseVqCzvkqBPpYeeBpNAodsFnSMBW1IpwcFbLaijnmehV1FMNMS+fhAfrQcTDgURkDZ7Y+kaPVAi73SPOuaYGR2+xjy2FDZnbYDupgC6m5xlZFWCDhyuO/d/utsJkjeQN4xDCW2AUdBRS1mZw4ZKjvs6GCyFXQYZ40Gqnn2Udvco9OaXUZ72GKn+O/9B4hoXXZpe49gpmI303J5JjTyDNYzgVgMNRjgQlLhJqlXyYhzVbTmfD6o5cB2nMtpL8B789E8yBMwOfeqBWmOrj0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(38070700021)(56012099006)(11063799006)(261021123027099003)(261009223027099003)(261021121427099003)(10067099003)(18002099003)(22082099003)(6133799003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?WWtLxT8KjsGM6/7JBSbk9vMlzv32OEQV21uppC8B4NLMEvguIkIlXWUfFjqF?=
 =?us-ascii?Q?Rv7j8xdLtJQ5JEoO3CWVJiBQHn20bfoQnRc1qhkhHclhn+yhJrvzH9XFIzk2?=
 =?us-ascii?Q?GOHXdaszOwJGtnJ2udZq31NJDBmRrZcqxPbfqnD2rXEXZzDVUx4mKU/jOI8h?=
 =?us-ascii?Q?bGie/2eMHVeMCkd5QXM79znvNoKDBb2NqXKe85fPLiZvF3t//Pj3AQwJ1EbW?=
 =?us-ascii?Q?nz+6FfRrNUUTPTZfGcIAc6/vUAEjOvBP87g4OET2ckrVKJzqxANUZDH5Oy2Z?=
 =?us-ascii?Q?YeDehe1jUYDgEeRbiWUl33WMyj3iDcCyF3FEnZgJb7g7Y/HmphNksfX6G9gk?=
 =?us-ascii?Q?v1eRXflD50W08khnFh7K2EoiHTR0eTBU514XwMGI/YksVrCka+v0SukGOepW?=
 =?us-ascii?Q?tOmCCY9IWCX9lVrC5C7b37iV3NPDKWBR+4sk5VSHsggFeh8EhnLudNQp+2Uz?=
 =?us-ascii?Q?wlXcHhy8fV6jGTcHL2ygbfCtIHUTMip475oPIRQjgU7DP+cDO74m/ESdI5aR?=
 =?us-ascii?Q?ULDxbZej8/2p11Zfdoq9ECprXj+qBwR1eFAGqceDVxFafFnagGIsXP5N0Kug?=
 =?us-ascii?Q?PXDvSo/JQVH0K7CNKH56N/MBdbjl/i4OuPpINvmtq87hLHy58qDAQ0oiVQjk?=
 =?us-ascii?Q?Rbw3I9VrzTkBIILDnnY0bwhFTZMPeBjyIVW8qmNJoqUawvbpe+YmtBA3N+hw?=
 =?us-ascii?Q?3N6OfosjhNZxnBrB/V7HbPZRrOmkX2PJYEpetAu8PxNobCWI64UPRt1o0X26?=
 =?us-ascii?Q?M+9OpwzriqULfBbuw64t0mXglXSF3JMkaov4HdE9lfEDlT9psgB7NWWONUvc?=
 =?us-ascii?Q?uSuDpf3LEWmm25oT+ewXgex2cUJjbQB2qD1DQv1qlygE0jPZtvd7NbvEKCF7?=
 =?us-ascii?Q?JODYFroG/ybCUwLxz1ngTwabF8ZRNVVErY/so8KnXFx4xnO6ms+9M33m2MPc?=
 =?us-ascii?Q?ODYiLslAvESU8qhvtbv+EYVRZPJNWiStJiMUJQ1LQQy8xpTHKxr3hC7bR6vF?=
 =?us-ascii?Q?L9VgZT+CinVnGHcCUHPXhrswPMd+YQxnVqjSM1iWeSDsWSNShZwaBlAce+vd?=
 =?us-ascii?Q?aRtDzxYVZjo4iIq9KgXD9Zf9h9Qde1A/kwCuGoxNW8B/PglBmneqQ1F2l/kv?=
 =?us-ascii?Q?70ogbc9J1oxhVPR+O9yxuIp04nv/6EDlXvtWdoWPlFpk+8Tn82+ua0bFwMlt?=
 =?us-ascii?Q?+t4JNSoOw2Q0pgxXZ0FB/9yI/64riDtVOAgT9rBRiKJJK5L2Ch5M29VAscTN?=
 =?us-ascii?Q?uxgKvek1gy1zEQcQ5U0yNTrkYmZphLHqfe2EytVZN6niIQxRUMasNUvLH13E?=
 =?us-ascii?Q?f6lhLCGF7Q1ektqke3eE4A0E3UvZ29s9+UXP5afheRK2Zfa5CX2G2PbFUJn0?=
 =?us-ascii?Q?4puUJnJNcLGXNEZWv0cED7712soGWOylvRAyiVJVnKH23kGh1y+NoWNB1iXg?=
 =?us-ascii?Q?qwiHgeTNLXdbHj6PEFtJkdz8ZpHwWvDSLeIyKq1AOIQL1uQ4VdCwmyslYAKW?=
 =?us-ascii?Q?yG6I6kHHXsJRp2nZBuBsauO9PDXK6d8AVC3n5ODahVLyITvzFeK1tYGIcijX?=
 =?us-ascii?Q?Pwr1bPuJS0b1bTAIoVO+0r3aceoMiWBnZia5Ud+IXz8lcQd/Q5/ryc9q4ma7?=
 =?us-ascii?Q?yBYjWpLDKldp34iD+OSHfReaooE0Hsk1tvgp1pKgRLNS3HL3e9D4Dtd2wx0D?=
 =?us-ascii?Q?R2ithNdwfUJZa43b6X/hH2bN4NP7VPIjHMPDObwV4xNG0poA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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
	Z8Z89+nzMSe6z/jrNTOrcq/kbBhW/iwAAmAJj/gkt2XHuWnpp6hRJrn0iWFgJEmwfFUBj5B4QlKPxOf5Op6RhWZYp92MzImvP6cQqvdf7y7iYnc42LrwHV484iwWOZpsi0ZrEdDkYWqjavNFgCpHurBBL6OhGddAaQup0BFspNw/TdVH7BJpPKdJ0D4a7zHo7sRfxSITmrvh2/pRyMviHO3gnmtDfRv3VmKg4UiBsHGl/eK9ef7t6RaYN2QHFRSAgLeoD60U9JES0CiqykNdiluG+K1r/we9VSNFdLxM3PCCzpC/p9xF+Mn7A0BYoQbwvG1fALMJk2NpsOiD2zIl7w==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bea1b13-7034-40ea-5c9c-08df30edc531
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 10:09:48.2777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eof0NLPCVdT5uFqVj5V/4/Mp+gY2GUIfBA2l3V1b8nkVY/F7Cd9M1LWufqKIiOas79LuS60zUdCUNb8Exau7OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR18MB5938
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: npHVWS2v2cLfHa6IIT-I2dvVJU6AjN7f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX66JxqfHNcE97
 t/efj1sREdRLCQLgZJzGF4ZcBE/Red0lBVE6M8jYos2WDsoQTFi3L+tEpUxmffn9xr7VdPrcycC
 ka0TwygOEiglhgIjWTl/oVIgev5NjPM1/jbJtLOD7RV6zePOVX9ycvrEmjjOewZTmytf9omRGkW
 lykTos9WI0L+GF3iIpvCQYJYfn7i/fvU9OediUETwrMlrQ51J7G3wYSRGfQSMT8eSwDg9gHxwLI
 JlSBl1AcJmx5hrxr0YHzIThyORcesbYJBo+OpWAMoAHHAj/W3ArIp/gjXqGu8RK18GT/4mYTOqN
 KphN4J4tCGsio+zkDCBVAv4oMfGrYeypUu6JHajmvrHNzQwDO+8k7AyO626c7Fk4hc5n8SFL4/x
 lPwFP0FCP+3AtPj86YbXmnNU8O688ckmAlgeapFqwpBc8/yyVL/iYGdrCAIsiZNNFOtIvg5VgIh
 1LYe2JByIKuF87LFdgQ==
X-Proofpoint-ORIG-GUID: deIf8ybUF1W0isPQcQ5eej0tMnMzOCGJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXyMHt2Y6wbZjN
 tVsDT+9g4c4dCipcEHJPy5u9jKgGCmigi4WpTH7Jh+ignAkYp2An5io7zkn1HYWALFQrGxbKhyv
 WWlt+6ZdDUVqidXQL5sOOskJlsPhc0w=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb3360 cx=c_pps
 a=tlGIxjjmudfNB24gcMuLIA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=660iZSQnnn4A:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=iox4zFpeAAAA:8
 a=0p2l1DYgpjVUUYS3Rz8A:9 a=CjuIK1q_8ugA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

Hi Martin,

I will send v2 of this patch set with few of the suggestions from Sashiko b=
ot
implemented. The remaining few of the suggestions will be posted as a separ=
ate
patch set.

Thanks,
Nilesh

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Wednesday, October 21, 2026 3:53 PM
> To: martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-FC-Storage-Upstream <GR-FC-Storage-
> Upstream@marvell.com>; emilne@redhat.com; jmeneghi@redhat.com;
> hare@suse.com
> Subject: [PATCH 00/14] scsi: qla2xxx: Misc. Bug fixes
>=20
> This series collects bug fixes and updates for the qla2xxx driver,
> addressing crashes, hard lockups, and races observed during virtual
> port (NPIV) teardown, async fabric scan, and BUS reset, along with
> 29xx-specific async event handling.
>=20
> Manish Rangankar (4):
>   scsi: qla2xxx: Wait for session deletion before full-login LIP
>   scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap
>   scsi: qla2xxx: Skip vport DPC processing during vport deletion
>   scsi: qla2xxx: Add validation check for base vport index during delete
>=20
> Nilesh Javali (10):
>   scsi: qla2xxx: Update MAINTAINERS with new FC storage alias
>   scsi: qla2xxx: Update few AENs for 29xx handling
>   Revert "scsi: qla2xxx: Validate BSG request_len before reading
>     vendor_cmd[]"
>   scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list
>   scsi: qla2xxx: Validate vport before deletion
>   scsi: qla2xxx: Fix use-after-free races during vport deletion
>   scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC
>   scsi: qla2xxx: Yield work_lock in fabric scan path
>   scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters
>   scsi: qla2xxx: Update version to 12.00.00.2610b1
>=20
>  MAINTAINERS                        |  2 +-
>  drivers/scsi/qla2xxx/qla_attr.c    |  6 ++++
>  drivers/scsi/qla2xxx/qla_bsg.c     | 57 +++---------------------------
>  drivers/scsi/qla2xxx/qla_def.h     |  1 -
>  drivers/scsi/qla2xxx/qla_gs.c      | 32 ++++++++++++++---
>  drivers/scsi/qla2xxx/qla_init.c    | 40 ++++++++++++++-------
>  drivers/scsi/qla2xxx/qla_isr.c     | 16 +++++----
>  drivers/scsi/qla2xxx/qla_mid.c     | 33 ++++++++++++++---
>  drivers/scsi/qla2xxx/qla_os.c      | 32 ++++++++++-------
>  drivers/scsi/qla2xxx/qla_version.h |  4 +--
>  10 files changed, 125 insertions(+), 98 deletions(-)
>=20
>=20
> base-commit: 12e67eb89eb2b9516685c744d3f7de0a2d1bd701
> --
> 2.52.0

