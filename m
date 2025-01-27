Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF391FBEAF;
	Mon, 27 Jan 2025 07:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737961671; cv=fail; b=MmkCQGWPFKMw2wiP4Lt+enKZNoMVe2UShLztrO9w7o/P68XUj1VRX6giAenxLijx33o387u29ilNEfQ/mQaHaZ+x4qRonPM5yTzzLeA/CDlZh52Sf0gKwE8+O7nl8M5Y0Jmh2Ym2kUsyHl5thD+gu0O9h+8JaOXh6N7blYKQCJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737961671; c=relaxed/simple;
	bh=NLx+3BC1nu9By3itJSvc55buiKfiWunjMog/ozcZzUY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RH1qbx0ld/bedFhUVbcSC7oyFyPAvvKDA2kchrMfClq+xwK+HjwsNj9+IgPd1MBG1Yu/TY7cImyi2LstHKQ8syKawKz7/6ULJszZ704G9qgBbUpBeZ2+PIEwGGCLdGOH0D4WWhJ4nRPG7wSrto9In2qwlo6oJAF+iZ4xEtdNOKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rKIvbHes; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=pt/swzdM; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rKIvbHes";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pt/swzdM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737961669; x=1769497669;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NLx+3BC1nu9By3itJSvc55buiKfiWunjMog/ozcZzUY=;
  b=rKIvbHesapsbqd+a71bZGijZagnIMzlaBfU3vr6shG0rfQECXWUfuT1x
   +fEFTY7/CUYmioWNVyN2Shyhb4uetgcV0FGRhBK7upcyi7/71lZu120Ut
   1oWoO9bz4G/zAu9Vyv5K6LH7izYWIcCITeyXBPpmTZrIDtuD166fa0dPo
   wEJ7AFWy13xuFg4LLAAbF8KS61+5T5HPLFw3EYcKMJ9W/LzErqg6nDbkr
   I9j1AxMNP/NC0O/mJ5VPKPwp7S++muCt/GJx/kZ/t0soK7TbqmDoFanyA
   RhvhqI8vpcKKoYd/EjVsvQWEaeAco4HlJX9voxJu7lRVZWmjGXXl1l/9B
   w==;
X-CSE-ConnectionGUID: 0Cv4Ak4ETHa+Oz59guIDTg==
X-CSE-MsgGUID: UcuYN6xnR4CDD8P1+AWXzw==
X-IronPort-AV: E=Sophos;i="6.13,237,1732550400"; 
   d="scan'208";a="37890298"
Received: from mail-westcentralusazlp17011031.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.31])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2025 15:07:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s68WS4tgYF6FCKp3QmSwJVZAwREC8/NXM9MaVTMBlN7OwGv3zDq5rm9uNwQ0AxNNKLx/zAKPfHKuLusjC0kIgBF3HMfznl/a4rFEjzuyYOthiJac75BfRvUpYa8F0t0dm1Hvlyk4ds6qmtZ45eELJEbmZPdklZAdrCUkHpifWS5bPsHb+We7mpEWiT8wBvJvBZ0LI2BSCz8IBXGOFOPk+GRUZiDDVfOkuqsmrgHBKfKd4rY/XSROi/WIXlT1nl1b+v3nFKZGBFsOGr5zkFeJYZ9+OU3S1A4EXIt/gLJQpzGlZHIx61WFPgIMux/qXIGlQvcZtvs3TDosOOtS7H6rvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLx+3BC1nu9By3itJSvc55buiKfiWunjMog/ozcZzUY=;
 b=hVX3USlqQxQEHANmnsai0nmjclKJkpyWhV2bE/5S51/MaurThIwt+thar1qQr8+XCRa44JwXUwonc4H3+SmGKO4dI+DLcXEa6Ew0HG2BBU8zvPuszQBhPKG0Gd75JPZHH6pfWLDp9PKURXD7mR/+EOu1jUXA+gNvffZtQSVZ6gNfGxeHQg9tSfcCBEKJGSPeoZFYirh4GvEOO/vZrHU9PVpeshDsdoyObxqPfZ/GHqCpcKKaGXGWR/99wICdwwSTqfmlypVZxqTbi6B6eookhVSFqdLRJa6+6twbu6GTezCC5oxLYxanSEGSdobKjDVrf6XeZPekjMlAuyXS8JJVtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLx+3BC1nu9By3itJSvc55buiKfiWunjMog/ozcZzUY=;
 b=pt/swzdMkH8+bZT4MHftXL5sNwWOBtHm2+WOW/x8eAJugfjz7gVJhsyUdLjOT75Kc1zd0CIPg1evQs0dVbiTNK0x2V9qZWWh0IxcC5EdpCEl2bbkHelSfrbVUmt9AjNx0jYkLlPY8ZbYc2q9ojfaqEH2V9BJE14uzELgu4pP7bA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6847.namprd04.prod.outlook.com (2603:10b6:208:1ef::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 07:07:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 07:07:41 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bean Huo <huobean@gmail.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Bart Van Assche
	<bvanassche@acm.org>, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: RE: [PATCH v3 2/2] scsi: ufs: Fix toggling of clk_gating.state when
 clock gating is not allowed
Thread-Topic: [PATCH v3 2/2] scsi: ufs: Fix toggling of clk_gating.state when
 clock gating is not allowed
Thread-Index: AQHbb75UYt4JvqPgtEewjMQ1OoUlILMpmoEAgACX3uA=
Date: Mon, 27 Jan 2025 07:07:40 +0000
Message-ID:
 <DM6PR04MB6575B1329711C4BE5D75D0B8FCEC2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250126064521.3857557-1-avri.altman@wdc.com>
	 <20250126064521.3857557-3-avri.altman@wdc.com>
 <f069e33f01f8489b4baa8d1e5b3db4eb055ff118.camel@gmail.com>
In-Reply-To: <f069e33f01f8489b4baa8d1e5b3db4eb055ff118.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB6847:EE_
x-ms-office365-filtering-correlation-id: 98a45c7c-4c14-484e-6f03-08dd3ea14a19
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bm5KK0dVcFF1dGVoNGFISDVqSnY1K3ozN0Zoc1dORm5NdUt5UWxXc2o5M1lV?=
 =?utf-8?B?ZGg3elZxdkJwRTZiMUZNQis1SG1zZUpRRmhpYys1VVF6R1RlUDVoMzhMOHdo?=
 =?utf-8?B?L3RWa2NjR1dDcWtOUGZKMW9maWcrRXVDRzBUSGhvRFVOR0N1Q2pMblZkUG01?=
 =?utf-8?B?dVB0UTZ5SFM2YjJSRi9VcWc2OW5lNHhtaWQrL3dtVjVpUUtvNVZLUzR0cFJy?=
 =?utf-8?B?YzJOQmdaK0tvWkphWDQ3eFkrcWU1UU9mbWhCdUsrWVFmbGVuTG54cEhNbmZh?=
 =?utf-8?B?a2FaTTVyTmFsNnJBUS83Q3pTZ0I5SVBCVFVIR1A2VFNkeDJYalR5NE81aEdp?=
 =?utf-8?B?eExKOXptZ051amtkem1zcnp4SFc3M2RIQkFTeUxJcEczMmFENUFZazBEYUJq?=
 =?utf-8?B?K2NMYnkxbkc2Wk1YSEg3UnQ1Um43NEF5bTJPSjBLcUtxYUNYNW1IdXMxM2dB?=
 =?utf-8?B?VkdMTmhxQml1QzhmNnpiRlNSOVZDQWNha3NrVnNLWDRuWDBrVlR4UitOZ1ly?=
 =?utf-8?B?QTQ0MGI2TTJNM1hPV2FmaHRuUFhtMy9XWmtaRGFjOGxKazFCQXZpSDgzRXpY?=
 =?utf-8?B?NVRLZmlBbHFiNUpvNVlWRnozVit1cEtyZVRHeVRZQXhYd2hqTTFZNk9lNnVo?=
 =?utf-8?B?U1N0T3RFN0RtU3hld0xYVlg5ZE1yZVpXVUhONlJNekgrNkdEZkFkYVdmYTY4?=
 =?utf-8?B?bG5FM3I4VDlZamdLMmEySGp6QmpMVEU3MWcxb2NhcGRsN2xuVjg4VjZIWG5U?=
 =?utf-8?B?VzFwZ3laZGNNK1AyMzQ2Z282RHIvbHlDUU1ycllzMHJQR01mV1hoM0kyR2h0?=
 =?utf-8?B?S1dwNE4yT3B3L0c0bVQxYTZOZVMvc1RzbzAzM1NuVlZmY1RWRW5IL0U5Nkds?=
 =?utf-8?B?TS90Kzh4RzNnd0Jxdm1EWlZiUlVjQW9DaEdrT3BEMk9HRStLK0hNUndqQVZM?=
 =?utf-8?B?MnBJa3VnR012a1M0Y1k4emFSWjMwOW1LNDhNUFZHNWc1VUppYTVFRmxKbWdz?=
 =?utf-8?B?bmtXTSt0MVg1ZUNrczh3T2g2cklad0w3RDlpZ0ZVOUdjSUZtQnBOcmZVb2RJ?=
 =?utf-8?B?VnRhYStFTUEvcFNDZjJIMHFUNnVacVdrRnIxYkVWVGdOdExvRWFOclYzSWVO?=
 =?utf-8?B?U2RuOWowTnQzaXdHckszdnJFRmNNdWJEdm5KbGdIOWdVeHRGQUkwOXM2cmFv?=
 =?utf-8?B?clJjTkVuS3ZRTElNZjlSbmpEbWpIYUc2Z3JhbU5uSnlBYTJ3S09obVhrN05j?=
 =?utf-8?B?RUpYSWl5NHBOczNlaVpyZXRWajBxWGpQbStmNzk2VTNSQVk0UWtzWGc1Y0tM?=
 =?utf-8?B?M0ppV1haM3ZqdzJGdjlaM1ZTZmtRVEhGVnV4L0FoeEVWc25FdmdvZCsvL0Q0?=
 =?utf-8?B?dEhQYUZFRENPU05UTU1jVEpVNko1K0JVN3NsN0FlN2c4WVU2SGxocTRJWHBR?=
 =?utf-8?B?TFhZWkU2T2tHdDFRWU9QSzRjRys5WjQ2V085VTFlODFlMmtQMmpTcFgwWm15?=
 =?utf-8?B?NHl6Y0VVVDRmdzhpRncwVThWc2ZEVnlzb0JCM1pIUDM4bDkzSHBEdE5iZ0JW?=
 =?utf-8?B?NTdvbnJCWWk4RW5DT1hzT2grVW1HcTdseUJZRnAzeVY2VUg0c0t5bHJiNWNw?=
 =?utf-8?B?cXJFZlAwTllXSU1Pb2t1WTRFbFFlMXpJNjN3Y1BJWGh4Z2poTkVqcDBQVmFK?=
 =?utf-8?B?ODVTZzduRnFHNllnQVg2VGVhVk9FZktlNnk4SEs0ODhaUjllWU43eXdCMHJ4?=
 =?utf-8?B?QllQeVhsVTlhUTNCTEJkdHYvN0pVQytMeEltWnN6TlpsRUMwNDJHbTg1UUgw?=
 =?utf-8?B?RTNuN3FwMVBoalgrR0FIcHNsYVU1MFd6YkNaS2orTlNOWHNCeDkrbmxaUFpU?=
 =?utf-8?B?N3dJd2dMMHlnMUFyaGl1K1YzbzNBMnF5SlFzb0trYS80NUdLY01rZ2R4a1dw?=
 =?utf-8?Q?+oXNiZ7QI6V5NYfw7ves16O/avod5pIL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NTNJL0p5UVljdVYrRXQvdHVBTkRkMW51T05hUEZXY1lnQjgwWjFGRCsxN3dQ?=
 =?utf-8?B?U3llZFIrektLZ1FydUdjYXBJNE9xZmt4MFhZRzJRVGJLR0ozZGpnQURQbHdS?=
 =?utf-8?B?WUlWNG5mNmdsZTlzQldCQjd0bFN5RG1ZbHlHdG4rR1Q0QkhUMXlIOUZQeVUw?=
 =?utf-8?B?R1hZMDVqSW9HRXhkcEgrQm5YVk5kTmpXcGNicXdSMWNFRDdkRUkyK3JFNGw3?=
 =?utf-8?B?K1RVOGxTMFhFTmRtSms4TmRYTU15WDdBcWwyNU1DcmpFUXNmb0RLWENKdXE4?=
 =?utf-8?B?NnFQMUpFRmttSUdUTEJsNjFScHdNVHlmaWRkS0R1bzJLZVlZUTIrWmduMjlv?=
 =?utf-8?B?cEdRUXdwODlIVGRURG1UNFZtZ0lnQ0NEQTgwSFhvbWFObVo3RkpKdXBzNkdX?=
 =?utf-8?B?L1JPdjkvd0RkYWx2OGR3bXJiY3lNbGdTeXd1ellvSnVUYkZrN0lmR1FPcC94?=
 =?utf-8?B?N2tGbUFySVZacUIrU3pKM1hqR0JJbXYzWERxTC9aSmY4Q2NqSVRlWFJtd1Fj?=
 =?utf-8?B?WDhxNmRtYWlyVSs0Mnpoa1ZwMHlMVFE3NmlhaFlIUmNsRExkZG1pcGJpRHRz?=
 =?utf-8?B?aURFSitVSzhLd2YyMXB6NzJHb3RiU3B4eXNhY1FCYTY2SVF2SlptTzNwdG5E?=
 =?utf-8?B?TGRoZGdadWZ3VHY1d0lneHFXVURFUC9yVmY0YXNoekFUOTMzZG9DcFB4NXln?=
 =?utf-8?B?MnB6cXpVcFdBRFVpQmxCanJvclRRYTJ2Njd2c29EcDZ2cmFVNzZJMU5IQVdY?=
 =?utf-8?B?NHdZbksybGVoRG8xT25FTXhLcFcrR25yRVRPMUVHbndqbkc4RUx2dy9RMk0w?=
 =?utf-8?B?RG9yZlFBcGpJekhVZ2xUUm5KU3NIeUxCcFRZSGhQN3MyTVJ6LzZqRk5mRkpG?=
 =?utf-8?B?bVBicXZuRjFpdVNTeVA3dUl3NjhQc0owM21jZllrUWNnRndvM2Mzbm16RmxZ?=
 =?utf-8?B?NW9OQ0h6bm41SmdNVU9uL2tYZE1PS0FDOXBMbEtHUTBScCtBanAwZk81aFVs?=
 =?utf-8?B?WmdvQXNKbkx2Ty8zYU5CL1czUWZWMlFLRWlHcS9yM3pLZWh5YWp2U1FJM1Z0?=
 =?utf-8?B?T1RMOHVibURENDRWZEJFcGRONitBYjFYMEZUdGpDN21GdXY4UTZkYnZNbVly?=
 =?utf-8?B?WlYvcFFGUS9wdGM2Mms4bEFsZHFWdmZnaXhqMmYxcUYwaXY5eDNVTVRmRmVw?=
 =?utf-8?B?dFEvMGhWKzJZbW5hM2l3eFpCay92NzRQNnVRbW9jRmgzNVdrSHNZc0Z5VHpR?=
 =?utf-8?B?L1BBV2YzbzZDOE5lanoxMGM0Tlo3SWFOWWV6eG00ZklBeWJhclo5QUlwRHRJ?=
 =?utf-8?B?cTNXb0RjOFk2V3VoUVBmLzdSRDcxMWJJVDU2NURib1ZmZ0RmWkMvL2puS0s2?=
 =?utf-8?B?WTB0aS9BR2hJTlkwTHQ4bVc1N1MyNWJ3c0tkaEVGbUVHdUhXZmM1K2Vzbkox?=
 =?utf-8?B?bXVUajNsc1dhMEVGdkkwYm1qcHF2d2VWc3BlMkN6bnZXK0tGVXRMcnNwcytH?=
 =?utf-8?B?SWZsMFR2WFREQTNtVEp1ODZWZ3B1b1Bwdi9PRWlFUmttTXZuN2pteis1MnZE?=
 =?utf-8?B?QjVROUJyYytGOXlHRE1TbHFRNGQwdk5JUFk5ZVlPRUhIc2VOWFJJb3d2eDBW?=
 =?utf-8?B?d1Vjb3lDZGExeWUyS1ZIQXBIUkRWUExqZUdKL1VjWXFiZ2F4WWVpa3BEeVZS?=
 =?utf-8?B?UnhGZUUzcDVuNFFYNkhZNUNNN1pHdXZ2ajRMWFRFOEQzRnZxdFkrbU14RlV6?=
 =?utf-8?B?dXNDc1krVzRDNmtKd2MxajZqNmcyTGZ6Ym0zR053QnpFb3ViWVRiamgxYUlR?=
 =?utf-8?B?UE9wOUFGZUh3Mm9ra1MwY3QwSTdCS1FVcXN4NGlwdURtbFBSdmZpUUQzSkYv?=
 =?utf-8?B?cW45dFMxNUo1Z0h1TzlSSWNoV3p5RmNEdHdlMWhadFR3WHY5M0Fwdm1Fc2o4?=
 =?utf-8?B?eXd1QlJ0dEVvTXM4SUJvN0RWWmRDWXdJNUpkWFpZSXBpRlVGNlNJOUsrbVBs?=
 =?utf-8?B?UVlxcHM4djVmR29sdVdxY2NtRi9SUFZhUndndWFNUGxZTVBjWkhFQmxIMEhU?=
 =?utf-8?B?L24wV0ZhU003YjU5Y0FwMmVzbnhiTlNVeFUxQnRwZzdrbEFmVkFtajlQSWla?=
 =?utf-8?Q?TUNy4P6ChFhSkcYaLMsu92FJH?=
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
	7/ZpjAf576Dvqtpx6f6Saw6eIQLUcaJJGangLX7U+veFvfYgLcQzaZ6wNgemRj3XdqSMvawgwD7Jg3kanagGotr/6SOtco9I85foEGh4WO+Ha3LNK9eSJ4FLPBkPnvmFAtzTu5H2XRJLZDh46cU3uLPhaVzjrO2BGnYgssNnHp124w6M7leudHmwUxs01HYJev5d2wr/oDbopiz/xR8kTwuH8DSvmncpefsXN0bPPR6p6socEk/DFDTTr5/X2TP6Jq8KSuCmTzLzGXjW2g7/rG7+P9jcItCyx9EBd2p4GmTz0poZjmIfzGfu8XTWJxOEygPxL/yuCTrHbEJhFHsfP8i8471rWTiH8WxA1XfGAo6Urd8bwgmwByviytJGk2ECmYSQOMyA3BeMmSdKNOWXRh/DN+0UukJ0N49h6kho4Twya+MUuEg0yAzBCV6A6NJ/nMcP5p2NDrumzK53g3EXN6qfYg8Tz+Rl8//Je/mcOkUtFvINm+SZZ7uwXgNxeG1gSBRk8CNS2+T0J8tWKuHH/4qXZ5LE/ZlN7DGwPfg8PHaehd/VBYYcTmXhKCneF1aAJXKBFJatauNmgU/QPa67RAB1nAsGQQpxca7LuthKjEAd4xqcqbLzRjRagEaqeW2y
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a45c7c-4c14-484e-6f03-08dd3ea14a19
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2025 07:07:40.9766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3swLpFhrnfFO9a9A5mQIn6MfFNlSUcGoMRCMzUj8H6yoJ+c+bouM3uWTbhECcU/4cbPvKwor8PBP6xZXmxpyBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6847

PiBPbiBTdW4sIDIwMjUtMDEtMjYgYXQgMDg6NDUgKzAyMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0K
PiA+ICAgICAgICAgfSBlbHNlIGlmICghcmV0ICYmIG9uICYmIGhiYS0+Y2xrX2dhdGluZy5pc19p
bml0aWFsaXplZCkgew0KPiA+ICAgICAgICAgICAgICAgICBzY29wZWRfZ3VhcmQoc3BpbmxvY2tf
aXJxc2F2ZSwgJmhiYS0+Y2xrX2dhdGluZy5sb2NrKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgIGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT047DQo+ID4gICAgICAgICAgICAgICAg
IHRyYWNlX3Vmc2hjZF9jbGtfZ2F0aW5nKGRldl9uYW1lKGhiYS0+ZGV2KQ0KPiANCj4gQ29uc29s
aWRhdGluZyBhbGwgY2xvY2stcmVsYXRlZCBpbml0aWFsaXphdGlvbiBpbnRvIGEgc2luZ2xlIGZ1
bmN0aW9uLCBzdWNoIGFzDQo+IHVmc2hjZF9pbml0X2Nsb2NrcygpLCBzaG91bGQgYmUgY29uc2lk
ZXJlZC4NCkhpIEJlYW4sDQpJIGRvbid0IHRoaW5rIGl0IHdpbGwgcmVzb2x2ZSB0aGUgaXNzdWUg
dGhhdCBpcyBhZGRyZXNzZWQgaW4gdGhpcyBwYXRjaC4NCg0KSG93ZXZlciwgY29uc29saWRhdGlu
ZyBhbGwgY2xvY2stcmVsYXRlZCBpbml0aWFsaXphdGlvbiBpbnRvIGEgc2luZ2xlIGZ1bmN0aW9u
LCBpcyBpbmRlZWQgYSBnb29kIGlkZWEuDQpJIG1pZ2h0IHRyeSB0byBkbyB0aGF0IC0gYnV0IGlu
IGFub3RoZXIgcGF0Y2guDQoNClRoYW5rcywNCkF2cmkNCg==
