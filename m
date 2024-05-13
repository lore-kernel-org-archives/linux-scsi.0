Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7998D5644E;
	Mon, 13 May 2024 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715596695; cv=fail; b=eLkqSOPnhnWT6LcrX/vgKqPS4yJf79NTZn3ZAxRptM1WpMeN25aVYV3LJ3h0D7TLT2QFPeHbGl0b70ZBELVV8Ci4EpAiMPfi6zR/NApQHGe4GhtGXPAGHQ3pGUB4eLqqWG6W5x6sw2BjNrU1c+FYPQOD3gb+ocQ+cN1xiitqPfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715596695; c=relaxed/simple;
	bh=OmwZDsEOkXN3DL24rv0cSM0dx4sW+VWWWS6vTPIrP9k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MnNGQN9vNibPrx2SQI/qJlERS8ciwbHR3PUKqCPBZ579uZTSiuQYcHP2+jXAVXcs0slQo4c06ndviH3UdFHTWbDgOLmU1HjUOvZ8W6ZpksdxPbPsSJSwdkaFW11fdR0e4DN8CY6EVnVsxRhxRhYBgol8uMgO3kn0b7FV3Gt8f84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KCxN+S5Z; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oIaSefgu; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KCxN+S5Z";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oIaSefgu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715596693; x=1747132693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OmwZDsEOkXN3DL24rv0cSM0dx4sW+VWWWS6vTPIrP9k=;
  b=KCxN+S5ZGrQxnw+/WqLHAK04kexlIOPa77fywBXo5FQA34mrz4iNk/05
   B/9GQzWjMdN8M0plFvgMUfEjFD2C00FNsVIF53WEQ5ByOwNPeoBektnI8
   OKFYKcyeUZ8r+POVaiT9oWzrpC5ShzQ51JyyR8rU9dIza4dG2arzZdpTW
   gCf/Rq+gjgLcqbJIqbnvYBpPIRpO97YK+j/ZNcUUGt/7qQfTnTNGhkUup
   +bW1XZjVIm6/6eULCaheytKg6tO7ogCCPLJbpHCMLOfVNmlbKb2s5/mGa
   YnuSDpLrg2GczSpqt3LE+SQAuqbRurATrevc4+9l4oxlQohZTfAx8+Oa+
   w==;
X-CSE-ConnectionGUID: 5Z0yaaOSQxyaqadrD1k6OA==
X-CSE-MsgGUID: XlV5wqnQRHGA1xjX5whbAw==
X-IronPort-AV: E=Sophos;i="6.08,158,1712592000"; 
   d="scan'208";a="16188871"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 13 May 2024 18:38:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWVQWgHs8iUFQXhhYvEWtdXDJ4X+z3i4ZcflsTZT0lBuybbAtnSRbdZcTSQQe6rOhgEK4o7rsh4DtWmtwWkVB1qKralJ+oAn7AgMilAbFBhnL3rMV6gv8xVdPArVBNXb0Ymxlr1HT+8qe3L1UyRhECBVNZbsgFode2nKiNWkcSusAv01GNJ1ZsC5Ct1yYAcJHapYFGEukHr4d2v28fgi1XHejvgqTM6n30dI1AVdvlgCTgEtrD8TS1kSRToo/f40RTPpbo139eQ8RI7q1Knw9Kl6NKPKdFOhvR9Rj/VebvFH9Nf3ESgnsTCyOFk0ZdvYtvLkyd0KQeKITuQwCyauFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmwZDsEOkXN3DL24rv0cSM0dx4sW+VWWWS6vTPIrP9k=;
 b=ieybhnu+3atImkrpMB57HMzIqniPjL2bRGLueqG56pl29THZR01gU/WIf+P4ji+eOQW4Nr++KdfG4QP3ggbED2LBXIVJTWS6DzPuoe4DzBTLZA9varfQ/BCc63KkC4ZW51B5EoCzSPh45cTR6TLEqlhXwkSVQpnTwTH/CZFFDXqyQVRITb0aIEKz9FScb1Q6gFe2gQ7l7DzqXa7+JmqswYuD01C7e7drgtlM14k7IC1kSQsy+jI4ws5XnhzP1DnPqITJJDuUX9OyoAagrgbNqC+oOIzMX/Rmxu8wWTWMrYhwYc9nRdsych4OpNlAWBgxnB51NSP22Lm/IEo5PhbtGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmwZDsEOkXN3DL24rv0cSM0dx4sW+VWWWS6vTPIrP9k=;
 b=oIaSefgu3L2v4SR/GD/ktFwk8dIqG9obil27WI2N/hmVjJMviS6V2OxNmzaPDMFV8kWsokjL1uHHpJEd2nmDlzOhErcukagX6Mau+6ac197ZrNr3t++pzFx717dYbcI92BePYnQVETSu+M142d/0kf5sSwck4BG7/jyWL6zjuSE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA3PR04MB8978.namprd04.prod.outlook.com (2603:10b6:806:382::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 10:38:08 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 10:38:07 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>
Subject: RE: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHanU3naXbfPalq8kifk3TPwmTFrLGU9mEAgAARQxA=
Date: Mon, 13 May 2024 10:38:07 +0000
Message-ID:
 <DM6PR04MB657566938989AC00F790EA9DFCE22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240503113429.7220-1-avri.altman@wdc.com>
 <95c026bdb884a27bc6f954e3c01113816723c999.camel@mediatek.com>
In-Reply-To: <95c026bdb884a27bc6f954e3c01113816723c999.camel@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA3PR04MB8978:EE_
x-ms-office365-filtering-correlation-id: 828f86a9-5ddc-49ca-dc98-08dc7338c73d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230031|376005|7416005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?VkRYZHphOE5zaHpGZHYvekZBNjAyVUh6a1poN3BFZHB0RmFoeHZBNEs3S1Fp?=
 =?utf-8?B?azdDMTUxa2JkTkZNMjFnUFBzUmUrU1d4bWJ3VU5IOVhGa1NUNG83M0hQWGVS?=
 =?utf-8?B?U2cvOTZRT1N4TjhReUVzTGlMYWc0NWlrVCtrR255SGtoTkVNRm5uVk9ZT0Fl?=
 =?utf-8?B?RW9rNUJpcVNadFlRenUrUVVGeUE3RVlpSkJVTVQwSGNzVEJkRzlPMlBhMU1T?=
 =?utf-8?B?amN6aWI4eGZES2c3UGx0dyt2czdFcDhpQmNVZUxzK213WXF0MSs5dGRDVXd5?=
 =?utf-8?B?OWw4bEZSaDE5bWVuWm85R0pVNXhDcHR1dkgvR3hISEVBZ3lMc3ByQ1pMYVZn?=
 =?utf-8?B?UWhiWkNTZlVFcklMS1NMakxTQkJiRUJad3RWeVJoZWxkeTVqS2g1N3NTb1Vz?=
 =?utf-8?B?WVBKVG01cGtGMEh1NWJ6TTNRdXVVNEZvUEc3eXZIM1I1SEQySkN1d0RHNTY5?=
 =?utf-8?B?MEg5V3AwWDdCZkIvR2gvUTJHQ3ZhMHcvb3d1UUFjd1dvM1ZDOFA2REM5Wm93?=
 =?utf-8?B?T2IraDVTSHo0d3Jub1ZTTHhoUkZLYWJiZmpvWEZtSFpmT0FVc2l6c3Y5Ulp5?=
 =?utf-8?B?dTNBbmZEdzRWT01xd2h0NVVKMXdxb2x6VHcrZWdHSWx3QTlpZ2xSQnl1eEcy?=
 =?utf-8?B?cU1ldHhRM014T2h0a0RZZDBlU2VHNW5jd1YwMFQvWkdQN1pTdzVlVG9mTHdS?=
 =?utf-8?B?UVF3R2FXTlZFTXEzclJyRDNvTnRDRm0xZDY4akJXdzh1a2M3K1FzcHhraW9Y?=
 =?utf-8?B?ZmgxMnRvNUhVbmt2NFFadjh1RE1MNUN1eGREMkJRV1VubFpvK3YxblAzYVRk?=
 =?utf-8?B?TDNDdzY4Q050em1FbVY2TGhrNm5MMjlWODdkV3dMNnBXNzl2bFVSc3ZzT2pz?=
 =?utf-8?B?NnFYKzNJWkptMC9XWm05cXNUb1lQeitJeUw1N0dwNFIvSVZKc1M2bTdoMENV?=
 =?utf-8?B?K01Hd3N5MmFCM2hwVzQ1QUpERHh1RXlFZVB4SW8wb3NUK1RCVmlUZVpDa3Ir?=
 =?utf-8?B?TXVGek1JNEJORk40bEtMM2l0TCtNcFhQS3Zuc05yOElDeVBqak53dVhNSGhW?=
 =?utf-8?B?aHNTVjZPenNKYTlCWE9PQ1F6SHhIYzR4MGlwck1ZUnRHRmFteFFnSjBiOHln?=
 =?utf-8?B?dDNQSjArdkZOb3JURVhNdWhkaHpyZGcxeGtuMnBKM3hZWDRaa3NweXo0bFNw?=
 =?utf-8?B?clBKQTBWNjVkMVpDZnNEdW1hN2U4VDJOSE55VXNULy92b3l1QzFkZzc0eGIw?=
 =?utf-8?B?WGFRTG1KTGZtNmFvbnFDT1ppUjBWVzZoUGJ3ZGtSMUh2dGs5VkcvSTJnN2hS?=
 =?utf-8?B?NDRnRjBQL3NLOGNDMThkcWtCSiszOVJocHk2NWlCelNwT1NYb2NmdUxNaXhx?=
 =?utf-8?B?L20vdHJGTmlVb3A3SmxpeXpGZW9zR0NrK0lTQ2c5Z2JRWEFVK1hsclJkRHE3?=
 =?utf-8?B?RkFGYVpYTmxFQU1WVkQrZVdnTmxHMG5qMytrZ1BFSlZwb29POGltL1didXdx?=
 =?utf-8?B?R2VYVTRTVnB5WE5ZcnBBOVh1M04zdGhrcU5icW9kcFdORkU5a3JPK2NwZHJh?=
 =?utf-8?B?cTB4aGdmeHVNSWtHTUMzN25nYUxwdnhvMUVWb055K05wNHVMNWtoUWE0dzB4?=
 =?utf-8?B?Y0RybGI4M1Bab1NqNVlQUWsrM0VzNGdpNTZzNFNWdVVDemdwM0NDdmdLcVph?=
 =?utf-8?B?UmpMSnpqT3pkUlp6eDMxdmgyMVNZZkRHTGg1VDVGSmoyNUVCSm8rbFN2Vit2?=
 =?utf-8?B?RGJhY1dJcElVYW1odWIwTmxXZW81ckJoVDlJV3NwYTJtV3FBWmtxQm5Pcmtt?=
 =?utf-8?B?cmR6NHUxbWJpZUVJV2FkZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dVl4dDRwS213U3h5RGRKOXdRM3VWb2VJaWFURzBTNnlpdXZtVjQyNjBhWjVl?=
 =?utf-8?B?M1hhclFIUU4xTmo0WEZVbytCQlRsdU5hSWJHendLSVA3bGRlOUR0M0k3SlMr?=
 =?utf-8?B?YzRXYXJiMFUyREZySTU0S1JJQmcxeWdLemxtWVlGTExlRXZLSU8wUEJ1MW5Q?=
 =?utf-8?B?enBTVFNneEhJR0JGTFdaMmlhKzVBWHVNc3BBQXpMVE1jWEF0YWpoTDBPb1pn?=
 =?utf-8?B?KzI4NkhjRFpLTTZoV0F3bEQ2cmVsdnh1dVh6VTY5Y1hRTjZKQU1DVDJnbklS?=
 =?utf-8?B?cTJ0cm5TTFBoRFhkN3VXZHlUWm5TOHUvRVRHVzdUbmdvcURVR0hIeW83Slpj?=
 =?utf-8?B?alFtWHlOUHhLZS8wbkJ1RnFUaG44SCthd1pjQ2ZtV0RZbzltTk81UGZ5cndl?=
 =?utf-8?B?OUtzY2V1N1ViWVBoTE5JRWt2WERwRUxKbGJzcC9Ia3dISGhtdFJtUk1vUUZW?=
 =?utf-8?B?ZlJaSjY3MHI2UnR5dEc2eUNqWVJJaFB1K0pjMHphL2ZoV2pkKzB0c01hUTdx?=
 =?utf-8?B?U1doRFJtbE4rWlZHdVZmR0xQTFhrcVlUeXRNVTZSYmhqSnFRTzdRUUJsMDF1?=
 =?utf-8?B?VVl1bERXQitRQkV2VUdXUVBjRnpuYVU4S0RFa0NwOEYwTzlkcHlHcGhqUVhh?=
 =?utf-8?B?UGpzeUVBSTFxaThVQkVFZnZ1dFNINmFjQjh1YVRnNEEvN2pZaFNaRGhsVllo?=
 =?utf-8?B?c0l5U04zS0NvbWpqYXdEeHdEd1JCNGEzN3BwTVpFSDVuWW9lM29OTi9xQ21v?=
 =?utf-8?B?RzBpdHcwTFRnMXVmTVR0bVMvNmEwWnlKQmxaY3RjTElFb1U4Rm9tdXEwM1VV?=
 =?utf-8?B?bkR1ZVdraDZzdllqUlcrUE44aGJCOFlnZlkwVWxHVnZ5QlM2OXNrcjA1RWYv?=
 =?utf-8?B?cFhtUHVFK3JPcGdzYW1GYWZ5ZzNaNEM3RENxUTZPRmJoZW5PRk0wMkR2djkw?=
 =?utf-8?B?ZnhmSjV6UmdsN255ZzlSSW5IV3libjVjbTJtbzd6RjZLK0ZZU0x1N1lhb2F0?=
 =?utf-8?B?eVk1VXQzTVdKOUtsYVQrSTBheW5SZnNRNU81NXZGUm9lTkgvU3FzWi9YWUQz?=
 =?utf-8?B?cDlEdnA1d1dMTkQ2K1FTTUl0TFptWkhiejlZUlJjZE1TamZnTnhkY3Rzck1P?=
 =?utf-8?B?TlJOeUM0V0ZzbDhPQXpQbEQ2YmE3U3EzcWo5dDhaQ1BvVjk5a2JiTkFrNXl4?=
 =?utf-8?B?TUNyaHdBbGdEUmJuNHRYVVNHb1BKOEtPRmRIMWg4M0JCQzZOTWZpYXlQcmFY?=
 =?utf-8?B?cTc3K0swR2cxcWFWRy90enUyMXZPWkxXSGRRMW9JOU8yMzFmdnBiT0ZYVjAz?=
 =?utf-8?B?OEFwNG92UCtMTm1CcDhSUUNNaUtHQkRTczM0dVlGTDVjL3RhUGtPdGJzdkN4?=
 =?utf-8?B?cG5YL0E0aHR5RUp1QXFXcURUcCswcGEwYmNXTmpQZ2t6Nnk1UE1NZ2pWS0dJ?=
 =?utf-8?B?OUpIT1ltQ1dSbnMrYktLaWJnRXA4eEZMTkZSM0JDNDhIUGxnc3U2NzA5YW9z?=
 =?utf-8?B?d20wbXJBbGk4eURFQld1V1lpbEtFb2pTUkl2VVRTY2VDY1MyU0lTNmtLQmZw?=
 =?utf-8?B?eW5CV1NrSXl0K3FYT3poN1JSbUlqdW1tZzVLZS8wazdvV2FvUjFFRTdMU2k5?=
 =?utf-8?B?ZzBRZmNCUVByVlZGdmh6K3g2RUlQUzFWby9GVGQwY2h2VnlPcXVUUkIxb3Js?=
 =?utf-8?B?b0JmNk02RXhtWGV1YjZXQVhkaklxaTNkY2lWYkNZSS9nOXlRRXhFZXozdEZn?=
 =?utf-8?B?Tkc2OEMza3hsWWgzRFFFYjIyc2VvemI3aUphM2FHQ2FzazRGZVBvVENlZ1Uw?=
 =?utf-8?B?QlVVWlNOZVhST2ttK2l6anBRZXh5Q2o3N0N0L2RGTWpBOEFBQnB6Rk4xMGJq?=
 =?utf-8?B?TGlOWERJMk9tTVRZM2Qwa1lEK1FoV2EwWTNFUm0raGVwdThpbGtxMms2VjZx?=
 =?utf-8?B?eHhVVWpGMm8weXJqNHBDbWl5Q3ZGSS9GVnVFSkgzdnJleC9ybzVYQmc5cVNZ?=
 =?utf-8?B?QVVSSmJCZlB1aFJna0hya3dFUnF6YWsweC92c3FrQWxuOTd6WVVpdi9jSklJ?=
 =?utf-8?B?bFFDbTNKVzVGczFlcXd0aXNPc0lkWG10TkJ6MThPZXdmK0t5U2Qra2hjUlJS?=
 =?utf-8?Q?Kfhp1/pRgmkHeOq9xv4vBzCCV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cVdfnBw2n/Kphlq84zu0MTI6a8JjOQADoTKBLEYQruPv/RC63NurRkJqb0Jra6c6e3d/b4Y2Zpxp+VYTMFjOZQUJpYuCngNxhzUiKwjy98Z6rBKte1ydZk9BNnKFLl9ifXrq8EZ0neAMtuzxZEpoe5UiDWXqE8g8Vj3ciUSfreLhLMbrZHc1bb1I7+qJHS7lhaed4KD8bjI1yhiWJI3T99cqTPAp5pzSQlU8a30j6eTNu4Qja/Q7nmbCEy9yOM3wMXWtlEpwWZuRMpWOlwa2bwhfOe7W/WEA8QioJKf5gF/VGx1NPYjFaZ+4L7vvqBtJCgFCT0kUHex3O6kdrKcL1jhxHQLSgPxkpsBFYfsqfKcX+P6AAQe0YuSYJYyyUyDhYfug97KbSeGdDD/5+U9M51j3dviFQPpk7EFHdDMmH0MLgMBu6F21n+FrhitIoUiNXQ7YDkJCZ9BY+wuQ8K57HPlmY8LFLQL9H0Z4Ez72IW5Mq2Ep804PDSpDjAnfCvBieAg9ySn7g+YE3ENfH96LhBrYRtG1kH//wwnTCll7A1H82KXpjxuRZKWSKW2BKinW88QZnzSaN4sdhpeKfrE5iKne9nXRhEqIfO5oFSg4NPxZ0ueV2rWBxqVq7js3ZiqZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828f86a9-5ddc-49ca-dc98-08dc7338c73d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 10:38:07.7776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p4KkZCbGKvLLnJbBHHauyK0ZMi9+JznW2HWssdlUzsKJiUFijz/o+jSQsvBkGWJ5YPDnvXWIL3BCta//pTZ12Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8978

PiA+DQo+ID4gKyAgICAgaGJhLT5ub3J0dCA9IEZJRUxEX0dFVChNQVNLX05VTUJFUl9PVVRTVEFO
RElOR19SVFQsIGhiYS0NCj4gPiA+Y2FwYWJpbGl0aWVzKSArIDE7DQo+ID4NCj4gDQo+IEhpIEFy
dmkuDQo+IA0KPiBHZXQgbm9ydHQgZnJvbSBOVVRSUyB3aWxsIGhhdmUgcHJvYmxlbSBpbiBtZWRp
YXRlayBwbGF0Zm9ybS4NCk5vdCBzdXJlIEkgZm9sbG93IC0gbm9ydHQgaGFzIGl0cyBvd24gc2xv
dCBpbiB0aGUgaG9zdCBjYXBhYmlsaXRpZXMgLSBNQVNLX05VTUJFUl9PVVRTVEFORElOR19SVFQu
DQoNClRoYW5rcywNCkF2cmkNCg0KPiBUaGUgTlVUUlMgaW4gbWVkYXRlayBwbGF0ZnJvbSBpcyAz
MiBvciA2NCwgYnV0IGFjdHVhbGx5IGhvc3QgcnR0IHN1cHBvcnQgaXMNCj4gb25seSAyLg0KPiBQ
bGVhc2UgYWRkIG5ldyB2b3BzIGZvciBob3N0IHRoZSBzZXQgcmVhbCBydHQgc3VwcG9ydC4NCj4g
DQo+IFRoYW5rcy4NCj4gUGV0ZXINCj4gDQoNCg==
