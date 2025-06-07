Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9491367;
	Sat,  7 Jun 2025 06:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749276786; cv=fail; b=MUkhMgU2W8AHxkDi0anPh+fWUOmmKL8nqx98z+2PmPRfVlfXaHe9gyVfKFvhpZN5iHADAkB0W/MzW2TvsvH1aKif00o5GtHKb3gaODNYOXtLf2+gbhoiVb8GG4/hSqXG6a2OT4+thhlxrLkH0zc89NnsPIBuk+rjW2EenBOY7lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749276786; c=relaxed/simple;
	bh=OtgrAvIlQM+qQkL4PajejoA/mY2NOiMgzEQdiMTvQn8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oW+wF0Vf44TSjXkTCLb0SfEP/UUkPXFF/0Ah2fGnvuWA+BwvDs8re0kGGZTsBsBg3QSipwuRjYn1k7sM47u5xRtT1zw9Ux1haAwAWgVxruQFNaLR5PzJFN3bz887dfLTFFloCFhrxnktfe72dSlvPJJRz8VBxDsQG3p2uUE7c3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mOE7KYgx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=QnkaoKBm; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mOE7KYgx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QnkaoKBm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1749276784; x=1780812784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OtgrAvIlQM+qQkL4PajejoA/mY2NOiMgzEQdiMTvQn8=;
  b=mOE7KYgxrczczuKJWw3CAvB3BegBXwHj3pGLrqvLLp+NnTjfMEj+SQjH
   2brwZFXngIHQRnNFLckIWkvHknDYVwy2/kd5YJLSNYYkSXXypyjGmrf6B
   RihCSS5rWDdtA6qfYit1mQLTnGW3T8M8GNBE9X2RMqcIiMRVMlJ2lYPCj
   N5l3Bd9d7k0KrVSrb0qi4h+mFckDnVKW8CQo+Orx+4w56Av5tvCmhDhMu
   adpCzdtIYTIj9R2ENHgasG0U1RqpaJZUfvNbzdYUahH7+uvDMz1O42vlE
   a0qcse+PEzCiZiUfe63OhaIUKeqshGrJyLiwnj3n/DBcovQe5oxfR3WqO
   Q==;
X-CSE-ConnectionGUID: I80uQeWCR4mhDtmCilKFfw==
X-CSE-MsgGUID: mo+dhavpRVyjgu7Mm1DZ6A==
X-IronPort-AV: E=Sophos;i="6.16,217,1744041600"; 
   d="scan'208";a="89089659"
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([40.107.244.51])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2025 14:12:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yoQsex3UOW+bbQnljhHvj2z2jyW8dTKqEVNNUix0GxymD/hAHcC9wok2E4HJ29yhq+8ol92F/VljyhOZ6jOQRQyaZ2WyMHZLy+UE02cxGn1zXAUXASC/4VklSXEXoI1LK0Ocr9QSz/F6vui0DXzErkR0k5uevqurJ8xluUNP2ZP10GAOEp717iZaHw6vjThbIRByC/NOBQaVDC7TjXYkMcHprsC30CAL9BeqpNmDvzjo/4NAuDEOVeMcd2d+Nt5rXrLKzPTXkrClrlnJQpQb+i7OKpbrCEO8J3TdAellPeBmjPi/SARsfz5wqPfQ8Ofk7lGFjfSmFwMUDqPLxqpu9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBw+rVbFUZkPjdGImEcnvPowZBUZFRiJz76cTHEXbdQ=;
 b=kfdW0VZOLC5xMRN/QbKIN9Rnu0WGtSN2XFuZDGnKud2bsDQartDL30HmvaO5rSC/AVAaWJs8C+GtZnendnCNHgX1zgSU8LD57rmO6+uHC1QKmrjxJ7niZcL3vzJImryJvBZuupo78lnW3zSLVcDULuWoMjcdDjorqowx1nD9c6AGvVZB23NrxMmS8fDacMHW0KcqIboueyBhsECavK3SfVsi95UcmTFLXRH+nEglhNg0EqeZooh2tEucrgMsMXefOP2BjLAlA1q7Vpz3sBPO42KddJrrpeEHa2qqNzoKnXKg00FE9T2kU2cH8MI7VMFz1RbGbeCa6BmRLqmZFY9xVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBw+rVbFUZkPjdGImEcnvPowZBUZFRiJz76cTHEXbdQ=;
 b=QnkaoKBmoF0KwLM98cdtzbVqakceURdoSc+HUf9+hKdP651pkCsBkvOsIcbLpU/t4EHFBs+wnnQjK39TFdSBcdZk48LIrv17M1poncE37yT9RxXmIkkY3+HNdu3myi1zGBR6F+opH4nQR+OGM4vnunXJiyHN7GUDuUlvYr/GhNk=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SN7PR04MB8570.namprd04.prod.outlook.com (2603:10b6:806:32c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Sat, 7 Jun
 2025 06:12:55 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.8792.034; Sat, 7 Jun 2025
 06:12:54 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Alan Adamson <alan.adamson@oracle.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH blktests] md/002: add atomic write tests for md/stacked
 devices
Thread-Topic: [PATCH blktests] md/002: add atomic write tests for md/stacked
 devices
Thread-Index: AQHb1mvbZXfXEK+a1E2N6RVyMpJqrbP3OZCA
Date: Sat, 7 Jun 2025 06:12:54 +0000
Message-ID: <ncboqvpcxt44wyqukzukg5f27duwj7fcp3ueat3ocjkqlgvlci@ep5nc3at5vjg>
References: <20250605225725.3352708-1-alan.adamson@oracle.com>
In-Reply-To: <20250605225725.3352708-1-alan.adamson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SN7PR04MB8570:EE_
x-ms-office365-filtering-correlation-id: 8af2b897-e5d1-4323-1465-08dda58a576f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?DggXCz+NtKSCLNyc5tJN4+yyDnSLqDtpRDRx8hWXoR3L5oNfsHYta9RNXSYD?=
 =?us-ascii?Q?TYPRmh62s7+oCSerZMJkeo946wsSb0qQxphDpjxjddE2JfNenceOKFQNPOOo?=
 =?us-ascii?Q?Jy5e/82ElwvS9u6bZnjfcG11m7D9cvlKCwGaUl+l7eDYEfXVb3vLXLV4fc8/?=
 =?us-ascii?Q?Bim2LWi8ixJcOekKz6f7S/ZhXmKAALQAT8NCbvkV4RhjjSiBt2ywfaxEbwnh?=
 =?us-ascii?Q?I+c4lg0qoIlscW6kQXi+oycmfXxL57dSWPjWmtMl/LZwG6XNDXA42cdS0dUa?=
 =?us-ascii?Q?Pegky4whlLle0tdnHys+ezoycgx+AB0YArVDeK2jGjWQiYGDVca0wljLQa4/?=
 =?us-ascii?Q?USf4vU+B/XtzUTg5X+WZRT2SFGP4igaSIUvVFIDW7U8bwdq3QO8Q+IsHk9p5?=
 =?us-ascii?Q?cOrHdskpgmQOBZOd9raVLrwpTfWVubC6N2z+F433rMo783uGVmAxyUF5degL?=
 =?us-ascii?Q?QA0anAVa6FbXK/LlKCNMUipVpU6CHshQlzHEosdb16U/JyqiBdbGTl5v+IcR?=
 =?us-ascii?Q?7EGI4eD4z01PAs2hUERMh3lITOE41YvCYADDFdu9lI+AKTY8yn3NP2gD/CGN?=
 =?us-ascii?Q?iY4LaOvt9qeTkIy0M9eFbjLe8PcbyBC1dY06JS6IZY3feC4w9cuuZjVDkd2I?=
 =?us-ascii?Q?Xf2sezqLOQOGKezwUFLsPJadnxBIVtdLl9QHOZn1/H/g/dtA8ZICwLw2WQmu?=
 =?us-ascii?Q?US4xfz1HgkPlYVhNQGZoweNreBm2u9o0K9ZKw0g4sqDsSvMcNaf6J6x+j/bf?=
 =?us-ascii?Q?WdI/ViW50ZuNWaeFsj/98CNkMDJzeTj49rMskK7udGkz4uUBx9rLIcV6+srz?=
 =?us-ascii?Q?iuF4UvzPT3B0x+BugElqbWiJsjzoRedrTvoNoTFS8ylhN9UVezT32iUMLgWe?=
 =?us-ascii?Q?KwJAa7nAPYftRdlrvqeLBgWqH9ACXluzOuI9O0k1fm/zCC6krRqJ/lSsXTxN?=
 =?us-ascii?Q?FPPzp5G8HOB8tIlNnpeLBeM5N6Xe//VdqPoYOx2wm24vE0jPGxu3UPy8IKc2?=
 =?us-ascii?Q?euPGOar6/f8yciPjp3iCVzIb5SRu0pRrvS3dgnTJNI3LYFj0AOR1QxYYlFqJ?=
 =?us-ascii?Q?h3/gDOmZzeOi83xLoXbTH83HxNiV7Qvz7vtkcpdeipzKCk6MH4S+3wIb1xKM?=
 =?us-ascii?Q?UJMaUBGTaV8dQ8W5dOk5M0cL0JagDbtk3qw8fcnuj8Kzr0BzFh2lsw1I0qyP?=
 =?us-ascii?Q?z3PkeqCwIFzBZ2zJOaIOwPlIfSr5bUuD6seL34bGVeXmvKDyEPnXwOcfYYof?=
 =?us-ascii?Q?ogmIijQeklyC5BBsxh1KgzG9VvbQPmLGJXkWYVYYqOtEo0Nz3L3DOEgUjb2P?=
 =?us-ascii?Q?KdTb0ZxuoTPMcjTQQEVQ+/f8ShDWs+TRk2ogQbspzeI5VifUAkGpsQ1w9AWW?=
 =?us-ascii?Q?lsX3FtOMY2oWiBnX7u/4TREwpzvlyx1oGZ0f3C52q63laKobsmKTjR8omPhW?=
 =?us-ascii?Q?sib0alrauGSHEJoQkIyGqGaAfQRfOaIVIIFAG7uwbEO6Ki/reLlaiaqsqtms?=
 =?us-ascii?Q?OY+lbQh/kK7cEI8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?8Z/QM48ewob4JiHaw36dPvgReGCmkBCqmTOGJfFO0EwqiAmjg5/xpp0onorZ?=
 =?us-ascii?Q?LV5p72O+msPp5wqNRpVetmDGUXRuUKdd7iqnWk0NMpaQBwjDpxpTw+FYnpip?=
 =?us-ascii?Q?OedPBrsTKoIIwumDOgTFIAQmiM7ivrBZKjySzocULAa2J+oJS0QTbDGSDS9B?=
 =?us-ascii?Q?+I4QA//nDjSWNi2R26Y0wq1FUL8f0fpuaOuejKVoic9ykpnZYn5UBEX+tm4Q?=
 =?us-ascii?Q?02sStIQfvqOP97oib9yZKIcTi52yWsBFwy7YDjH59qcvQFaIGRfijzTxiR6E?=
 =?us-ascii?Q?n1tDDV+nY+IIh1I2cI+Cy7EsumPMFHMjmH2ji7gEXKAqlNd7SLC+33wRII0a?=
 =?us-ascii?Q?XTKmRpl/URXPzCwfqD00jugf2sCv2LWDamdguXFAYDtdr3p1kMMUatE9VwoL?=
 =?us-ascii?Q?LL5rIbA5Kuv8lONJSpFMGEWjUxUXClujU4K3U6YS2dgtRnrSCQtGntQPn05f?=
 =?us-ascii?Q?AVFSj/CJy6lULzRwKqeI6Cx3vSC2mB8EBfplS8maZDaMsyEEdN9dvXG7zAtr?=
 =?us-ascii?Q?1GUCrhf6nMa1JCMlxVcjFf9SavWGOU6M2D34fmdlHf0OcS9L3k+jyDeeTurS?=
 =?us-ascii?Q?NkASqOI6u3BPpDm8WHDEP22sEjZBYrog887nwQ4+UgK8sv8TYax3aFVl56i0?=
 =?us-ascii?Q?toaMv0rkdoSRulUNS/DrUFOW8l+6zFHD6O1MzR7Uv0MjtsdWurfdodyNlWr1?=
 =?us-ascii?Q?vQ5dvNGBWe5+99xbLb+obSGcMD1DVHs/JKiWLojzGgMQL9+kPdZfE3A/vSl0?=
 =?us-ascii?Q?J0uGOMaaUoVYvDMzesY9OR8uWX9dOtl6pYjzjBsCoSoVou0jILtfi/bzCFcH?=
 =?us-ascii?Q?VP5vlKGYDiu2zAv4t32k5zua0rhyna0njXtFp/+vcg406PWBXGCrmeMHYsjt?=
 =?us-ascii?Q?eF1lEtalO6ZAD1yEgtfBMeBY2F5NhcZcc7A9qPDUpSh4Isx6fT1I2WnUFeud?=
 =?us-ascii?Q?452kssFyUfIXrvv3AXtXDwyqJ6MmISDfi3Bgw3Cbtj7q83fNlKtQhu1EuZye?=
 =?us-ascii?Q?J/fjMziUdWclb0XFFMVG5peCTdCvYOOkUt/anjCrfuUtQNMQPEwJ+PABydW4?=
 =?us-ascii?Q?W8HTzsSUliHPDGij4MO9rPFHUajfEBtAgDNwRB1beGv6CLs6gntuZcCzRHJv?=
 =?us-ascii?Q?zfXCH96ju5wAxu9bs8RC9U+XdU8q68nB5CxlIR/DFzWL1A+gPn2q+rG3dDYh?=
 =?us-ascii?Q?B3q3A+x/Fh/2nhnnz1CDa92RqZV9iHdOsD5CBCdyvXNYeJ0TtNaFjQ/ilAab?=
 =?us-ascii?Q?R7JWNZoGUfeAvlGNKZ297oJWy8vlq/1vOUiganQgx2D7A9GU4EmM/IyCl9eE?=
 =?us-ascii?Q?kWnvDFVmNeHrxmzC5KUnMAwGpnSr8d59gD9yN+QkKO0NA64U4Vv+ninF5Dfd?=
 =?us-ascii?Q?81wLevykwzDInl0LBqHbNGCy6ttaGs+5sMhCAVrZBuOECQPvX5e6HtNBVDfK?=
 =?us-ascii?Q?+fQLEMToZmM6ILvhGSmjdcNcwAchnZfc7LiAFzJdt4zCYEjggA8wNmfr1BaQ?=
 =?us-ascii?Q?xndl1jWzXjvAqG7ZgVkZ08EqiddvaSW9p1MmwCL5m7hL12US2q/HocVu83VC?=
 =?us-ascii?Q?LwXRg0SpyHO65DgnFl4NQcd7lDzKcjODNGvVqWeX+cGznAwAOl0te4X1towu?=
 =?us-ascii?Q?4g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08A4133B36B894418A4D72F1F927E6C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pWOzFKA9LjzQKmLJWX/LRaLThXEFM1JKEgnHm3feHhjupyepGFKhzIh7k6tnBTIzYJLIPiNpdk+pqogbHTGUr+Kaav12GJSuD8ISGCczTLRZHFNENabp7YHdw7KfWoTC63BcXydE4AzRUCrLex3EiibaYxNV9hDRfRDR5axN5LmAxirR+ROmOnIL8qSSRsmPMm5Mx9gz9TnomFl3EwEivF32ErFbltEjlfIPvmGyDeMkGwKMyLUCHxeP7+j6fRFixKdZFOrsYZXQMwZqBWUNf7PMxw4ERxjm0zZbjRmlmIXK5F5ovZSLc3Zn1imTlFKTtRk13Olpku5IMrKUNDDpTJyJBFHuF4v4ZMXPt+lMnF0hTpNLCBYoesTrnCQcS3MKd6jGFE8or76iNna+ux/xt+Td7OKHfpPYtqMCuyQwsDqmYqf9JyTxWU1MypO3eVdmlz7pRxfQBB9XUoVe1YWaksnrabKW/zyYEYVy3AzoX6MRMfBwH2fUIuYvX0WHdAgFR4C72QIItT8Fjj1tvuH3UKwuwgZw/5JkQTQKSyD0lTPgVObhiSRU7SLn/fXs1JabW2p2fzvRlV/A5XFOz6XQN0VN6KXs6ZdDp0AI1cSR7pT8ZmgJ3WP1qD2oGBfz1XIW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af2b897-e5d1-4323-1465-08dda58a576f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2025 06:12:54.7218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+R9x1x2gELHHTuJ0PSFubfKqx61ncSlyI69tlOkCA5kofBHWOwIT+ldUY709kWcI82cOIVwJ0jkLoTViEoY1PzQySdUP1s0WFluAk0Nneg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8570

On Jun 05, 2025 / 15:57, Alan Adamson wrote:
> Add a new test (md/002) to verify atomic write support for MD devices
> (RAID 0, 1, and 10) stacked on top of SCSI devices using scsi_debug with
> atomic write emulation enabled.
>=20
> This test validates that atomic write sysfs attributes are correctly
> propagated through MD layers, and that pwritev2() with RWF_ATOMIC
> behaves as expected on these devices.
>=20
> Specifically, the test checks:
>     - That atomic write attributes in /sys/block/.../queue are consistent
>       between MD and underlying SCSI devices
>     - That atomic write limits are respected in user-space via xfs_io
>     - That statx reports accurate atomic_write_unit_{min,max} values
>     - That invalid writes (too small or too large) fail as expected
>     - That chunk size affects max atomic write limits (for RAID 0/10)
>=20
> Signed-off-by: Alan Adamson <alan.adamson@oracle.com>

Hello Allan, thanks for the patch. I ran the new test case and it looks wor=
king
good. Please find my comments in line.

> ---
>  tests/md/002     | 245 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/md/002.out |  43 +++++++++
>  2 files changed, 288 insertions(+)
>  create mode 100755 tests/md/002
>  create mode 100644 tests/md/002.out
>=20
> diff --git a/tests/md/002 b/tests/md/002
> new file mode 100755
> index 000000000000..4b71ebf7d496
> --- /dev/null
> +++ b/tests/md/002
> @@ -0,0 +1,245 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2025 Oracle and/or its affiliates
> +#
> +# Test SCSI Atomic Writes with MD devices
> +
> +. tests/scsi/rc

I think you meant "tests/md/rc", didn't you?

> +. common/scsi_debug
> +. common/xfs
> +
> +DESCRIPTION=3D"test md atomic writes"
> +QUICK=3D1
> +
> +requires() {
> +	_have_kver 6 14 0

I wanted to confirm that the kernel version check is the only way to
confirm the kernel dependency of this test case. Is there any other
way to check it from userland, such as sysfs attributes?

> +	group_requires

I don't think the line above is necessary.

> +	_have_program mdadm
> +	_have_driver scsi_debug
> +	_have_xfs_io_atomic_write
> +}
> +
> +test() {
> +	local scsi_debug_atomic_wr_max_length
> +	local scsi_debug_atomic_wr_gran
> +	local scsi_sysfs_atomic_max_bytes
> +	local scsi_sysfs_atomic_unit_max_bytes
> +	local scsi_sysfs_atomic_unit_min_bytes
> +	local md_atomic_max_bytes
> +	local md_atomic_min_bytes
> +	local md_sysfs_max_hw_sectors_kb
> +	local md_max_hw_bytes
> +	local md_chunk_size
> +	local md_sysfs_logical_block_size
> +	local md_sysfs_atomic_max_bytes
> +	local md_sysfs_atomic_unit_max_bytes
> +	local md_sysfs_atomic_unit_min_bytes
> +	local bytes_to_write
> +	local bytes_written
> +	local test_desc
> +	local scsi_0
> +	local scsi_1
> +	local scsi_2
> +	local scsi_3
> +	local scsi_dev_sysfs
> +	local md_dev
> +	local md_dev_sysfs
> +	local scsi_debug_params=3D(
> +		delay=3D0
> +		atomic_wr=3D1
> +		num_tgts=3D1
> +		add_host=3D4
> +		per_host_store=3Dtrue
> +	)
> +
> +	echo "Running ${TEST_NAME}"
> +
> +	if ! _configure_scsi_debug "${scsi_debug_params[@]}"; then
> +                return 1
> +                fi

Nit: Whitespaces are used for indenet in the above two lines.

> +
> +	scsi_0=3D"${SCSI_DEBUG_DEVICES[0]}"
> +	scsi_1=3D"${SCSI_DEBUG_DEVICES[1]}"
> +	scsi_2=3D"${SCSI_DEBUG_DEVICES[2]}"
> +	scsi_3=3D"${SCSI_DEBUG_DEVICES[3]}"
> +
> +	scsi_dev_sysfs=3D"/sys/block/${scsi_0}"
> +	scsi_sysfs_atomic_max_bytes=3D$(< "${scsi_dev_sysfs}"/queue/atomic_writ=
e_max_bytes)
> +	scsi_sysfs_atomic_unit_max_bytes=3D$(< "${scsi_dev_sysfs}"/queue/atomic=
_write_unit_max_bytes)
> +	scsi_sysfs_atomic_unit_min_bytes=3D$(< "${scsi_dev_sysfs}"/queue/atomic=
_write_unit_min_bytes)
> +	scsi_debug_atomic_wr_max_length=3D$(< /sys/module/scsi_debug/parameters=
/atomic_wr_max_length)
> +	scsi_debug_atomic_wr_gran=3D$(< /sys/module/scsi_debug/parameters/atomi=
c_wr_gran)
> +
> +	for raid_level in 0 1 10; do

Nit: this for loop block is rather large and has deep nest and long lines, =
then
it would be good to factor out it into another function (Bash users dynamic
scoping then the local variables defined in test() will be usable in the ne=
w
function()). I'm ok with current implementation, just a mere suggestion.

Thanks!=
