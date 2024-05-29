Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E231CD31;
	Wed, 29 May 2024 21:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717016945; cv=fail; b=UPB+CI8Y6XTQiMNwHKr8Mdhow8tA9TaeoDdqibHqr7Y31eUWLjPliU/KEZDW7RCPk7QX/+NmiGpUjCgmK3qjUlm27yIQ8alYPDhogbw5DB4bqX4gMHv679rPrtrwwvfcIEZ2L4N3A1Tfb/rEj4/kFSwKLrcxOqRdS3xOqDzRtc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717016945; c=relaxed/simple;
	bh=5G/fGBNulJSzjCJ5VPE/DWAcDvdE4bpcNgwJIVzoDoE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IGXE+QOaYHAHEPmfCRTtqZVsTRsQhDjmxYWrNyR7MHDdQeZ1/xuJQPeY6ZFC0h+7wqy9D0f6sGJaDqjyC6TX2qbFdZksVK3UASGChI3bfsm8W0Nk1Y0XgkcGrBs86/MKaodLa3eRF04Uu2FW66SeD7gqeGXhzPdVC1zF46dvvpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fq7wG614; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=p2jBfBvg; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fq7wG614";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="p2jBfBvg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717016943; x=1748552943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5G/fGBNulJSzjCJ5VPE/DWAcDvdE4bpcNgwJIVzoDoE=;
  b=fq7wG614yp+sJHz4veW2qjYIdp1XtgFYkDUfzqGwmFRWYAPXks7j08uu
   ob2uXiDwxxBB3vd8RX8syM53RyhXzL7bO6G9kvJIOa9aAPKcGd2f3p+db
   YarHcur6sZijVCgI9JX2PqUN+n4UgLcfwT3q+YXdkqJBjB6HYVN6v12oa
   oPyckRgqkSH1JvAGRukNKplWObRTXCqbsMyS02cF2P2wbC9bSlDIISFUS
   PnVRGU6NCYOOPJl9YhpV52GnALejHQ+tRo0jU7aZkescCeUiyyVoPYBy7
   zYu0Dh5bp+a3MhxhAWiG0I3ZThqVCA+40LpOej5HsQPg368x6dj70Bk3M
   Q==;
X-CSE-ConnectionGUID: waeofUgnSgaEcTizWuJ7fA==
X-CSE-MsgGUID: FhD5X3neRMiCI41Lzg0ytA==
X-IronPort-AV: E=Sophos;i="6.08,199,1712592000"; 
   d="scan'208";a="17578814"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2024 05:07:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyTXty5KPLc5WKt1FNhptfpfm++wVMGgvVELSUaH64cYeDL2bs874HeqLW0SH8CmkzjLtULWAJHG4wSw1jPlVCf36zj9VXmbV16EaFq8KBOou4e6kUZjQIiVbzamzihUa6mFPZbn594Y6qGWDhNkSVE3rrf/squSF8atwtxdrycbRRMkv3FTDGK4ekpMf+5KqyP7IALa7nWjiDm1YdmYubPtSD7IwKFPmEQO3yk3NjW1E08yGbBKEWENr3G4wL0LeS5TBdHC/upDi8tnchJHHJmR1VhJf1JFuaxCE3Asa2iGm2pOD5sFodD7h/nYfJg3A6bbJbYuAEegEC4A/xwq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5G/fGBNulJSzjCJ5VPE/DWAcDvdE4bpcNgwJIVzoDoE=;
 b=Woosvw8/K1gTWo+w8MOMmf9IhbFKa6ucKWVoflYdvOa+aaUs7FwoWrJYCgLnNNp4D9j+bffsCzAxHm3lu5LU0aNBKLiGat5ihrchFI94oN2oc4PhP5934BSOXVawxywu+4X2lSChlQhVib4ifzfLt41cmpMqm3uIsIc9mAJ742pYQxvE+t8Ln5lZnQ9KErsMc8SooZZVlkmkcrP2j0rDKnhCMeN4qJvMAEur/VjTvt5Wzl6ryPXmlugkOSHQxoPmvzeJP14BLY27S5ZvBri7hxWxgeucTLhLfFOgwYB37vttyxwGyXRE2lRIQsjSWof8AhTkzK706QV40y2gjXFbFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5G/fGBNulJSzjCJ5VPE/DWAcDvdE4bpcNgwJIVzoDoE=;
 b=p2jBfBvg0qnJh4cqR90L70LpgQiwOMBgpTHo4Joswr9Vbdn0M5KvvinjOG4nZJLkYVXX9+1CQYJNmp3hm6afdaur4hP8LbOuTg8Zgn7fkJyfPkuw+15myIhZF2e30Il4HblHDox/aiiHaZ6WyMOj3ZULfePvgxKkXFg18dQszQs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA6PR04MB9272.namprd04.prod.outlook.com (2603:10b6:806:41b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.17; Wed, 29 May 2024 21:07:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7633.018; Wed, 29 May 2024
 21:07:51 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 2/3] scsi: ufs: Maximum RTT supported by the host
 driver
Thread-Topic: [PATCH v6 2/3] scsi: ufs: Maximum RTT supported by the host
 driver
Thread-Index: AQHar0UgoPDF5tyofEmD9nc9EFYhGrGuqpGAgAAOLRA=
Date: Wed, 29 May 2024 21:07:51 +0000
Message-ID:
 <DM6PR04MB6575E8CF999266A049F7F077FCF22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240526081636.2064-1-avri.altman@wdc.com>
 <20240526081636.2064-3-avri.altman@wdc.com>
 <0555169e-2552-41d8-a515-8c394118cec7@acm.org>
In-Reply-To: <0555169e-2552-41d8-a515-8c394118cec7@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA6PR04MB9272:EE_
x-ms-office365-filtering-correlation-id: b4ffe905-0a8c-4092-5282-08dc802366a4
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?WXRYUzA1NXU3aGprV1pIc0dCNjduZm5FV3hBbGhGNVZrdmY5QTN0MFN0OXlp?=
 =?utf-8?B?dDZGbXV1UndJbFd4dDNUOFBLcEtRRTM0UjFSckcyTEx6dTBBWlBTajRNRlJC?=
 =?utf-8?B?VGFrQkk0WGx0dndxcnY3OXhHWUxDY1FXdjNlaVN2dWVoa0lDWE1weGc5QmR2?=
 =?utf-8?B?UFdWOEFnemNVbzNPUVhPb1dLcEptejU5dEFNUkFlK2YwYUdlRDJ5NDhFdVI4?=
 =?utf-8?B?NHpxQWZhNTF1aGQ4WDh4bWR5ZlF3MUlRYlEvRi9ZWGFYMlViVVA5elErbWE1?=
 =?utf-8?B?NmhZUDV6b3RFdTIxNzk1SDRXUjdxR3lCaEUzTkhmcXF6aXhjaE00M2NuSVFr?=
 =?utf-8?B?N1laQ3piY09JWW9EYnNuVlA1ZzZxTXZBeGxuVm5xQ1ZRRGQ0U2pOeEhqU3Nv?=
 =?utf-8?B?MnBCb25IeXNqOWFORGlkZnBFSG92SFFIQUpGcHVGY0NOREgyNCt6M3kweitS?=
 =?utf-8?B?MWl5Y1dEV0s2RlgwVmUyUVViLzlxRHB5dW1kUzVIM2xuWFhwNjYyNDIrUmFq?=
 =?utf-8?B?QmdzRXpiMktJSWo2ZG1jcm5jYnFQOFBacHRSRWx3QWhUZ0xvOXJMQnVid1RZ?=
 =?utf-8?B?cCtPUFcrOGlGbVNmOUJ5Ky90WEhpcmNITExab2xycUZLeUtobVBoa2Rsdk1i?=
 =?utf-8?B?U3Y1TEY3RjdkbkFQRnFqS0g4dERWQUc5QVdoekEvYTlyUTVsNFdURFFuQWRB?=
 =?utf-8?B?MnFKMEY1YlRkRjdtNVFINmRDUTRMQkpEQ2k1ZXUyRXpJdVBNNmZ3U04rdDBm?=
 =?utf-8?B?MEFScFpRbUt0a0FQeWdKYkpPR3F0VDVvM1BSN0Nad0xhcjE0UVprSW05bXMy?=
 =?utf-8?B?S3F3K2RtR1FvcmxMWjBkZ0tHSTU2bHE3bkFjZWdYSEk5N2tHKzd2VUdnQ1du?=
 =?utf-8?B?SzJMdFNZdzZJWC90VEhrQ2lGVWVUNk52Unc3ME5YcE1jb1lHUEUyS1JudkdO?=
 =?utf-8?B?MkVpK1VYeFRIdE5kbW1yazZnZjBZT3JDMmx6MFVXNE40WExjMjg3enBVWHBS?=
 =?utf-8?B?VDllaWFNcXV1QzVRMEoybGJlVGVMYitBbUFLNlBQRVhYVEN3eWFld0NaWEZt?=
 =?utf-8?B?YXlzVC9qU0Y4WkwwRk56Z0F5Q2VQaEwxaTNKU1d2YXhnOGZJbm1xUStmeDBx?=
 =?utf-8?B?YmRhNjZ6NlhKMkh3dzcwb3FReDZvMHkrN2dFbHZ4cUVUVjJoSDRGRmNZUklN?=
 =?utf-8?B?bG4rUjNlNlFYQTdwRlNPL3BCN1l2WmhXQkRQL0k3aXJYRFBubm5mbXc0S0xY?=
 =?utf-8?B?WEhtdWI0M0s4ZFFvdHpYc01JV2xZVmdBWkttR0JGRWk5ak54V1RXMm5RSHZo?=
 =?utf-8?B?bVlibnhBdmJkeGE5N2FPMmlqNnQrTFQ4cmhvRnJJSnZHWmQvSFMyNzBwZ0FC?=
 =?utf-8?B?R3hyd1ZUaUFZbGU3eithdEhrNGZjcEtKYzltam84Q2ZWeGpDc2JEZTBBVXlw?=
 =?utf-8?B?Vm5iKzhVQk5NQUNDcHRicGN0NEJ3bHhHTC91OEk0SFhzeSsyUko5Q2VFMFEy?=
 =?utf-8?B?M3JXYlYxSmJpU1dYeXRoUXdQQS8rNk95NkJtdFl1MFVBbUk1VjFYbld0NXRp?=
 =?utf-8?B?NndHNzZ2TndzeExER0RYMTBtYnFJek5OZjY5VGNSS1lXV255VWhpblA5S2V5?=
 =?utf-8?B?UnVRRHduRm9TVGIvOFZzT2p3aGZaelFwbUpFd1JaSnVMRTBUYXdaR0l2clQx?=
 =?utf-8?B?YkZCS0ZwYVRLZ1ZWRXpWcG1xdXRwWmNHZ0g3MUdZaXNiY1BJSG9EQlBuUXly?=
 =?utf-8?B?YzVUUURlTi9CamxYOXZSRE1hYUxGZnNVWkVvSVg3K0JGN1VtSG50TmFha2JT?=
 =?utf-8?B?Vi9MUnFBZ2IzOGJqaUpRZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZS9vanhrd2kyODRmTlA2N3ZxbS9ta1Q1VWV0bzM4MEFuSjBVSGJUNUplUzNG?=
 =?utf-8?B?ZlpSREIxRk9iNWJQNEZwc3Z2Q0IvUkZYZllBeWR5d1hhS2tKVnI3OFFVU2hx?=
 =?utf-8?B?TlE0Mm1lQ1FZMGVTeG9BdDV0ZzhMUVdja0lWL2RwZDM3SFFUdnRGOHZXWk1L?=
 =?utf-8?B?OGM0M0FWWjVDNm1Ga0NEUysyUE5sd21zVG9seWRaYkI3OWVqVEVRZHlRbzhw?=
 =?utf-8?B?RUpZTTl2OFkvVEdqdFR0alRnMGYrbTArUnBXSndzVFFUcWdlWnFiTVBZUFhr?=
 =?utf-8?B?N1FEdXRiTDgyZFFnZDQvOFlUV3dzUFdJTWh0OHAyekc5eTV6b0RNYWlYeVNX?=
 =?utf-8?B?SHNkUkswRlA4ZHRhbUNydFkyeER0MXJhR3ZsL3pPRTF3NEFKZjZBeDdnaVNH?=
 =?utf-8?B?WEVNVDlvdk8wZ2RQL3ZCTVhZcVBYVmJScjJIVVZnYUFPc0tPeTltTzgxeXR4?=
 =?utf-8?B?NEpOSllORW1zREhpQ0hmb3NjNUZ5TnpzdVRlT2tmYzNmTDk2RllvMlNQU05u?=
 =?utf-8?B?UEpoN28wVCtwOVZRVUJEYmRyN2hneWtPN2pGTWJaeVo2aDEzZ1lvdlNOSW4y?=
 =?utf-8?B?L1ZpckJ0VHVBMUZBeHdPYSsyNUlhcW9sYmxoSHJTZ0lYME5lRHVzWTUvLzNG?=
 =?utf-8?B?UGpWTW12c3MxSHFpTkJIQTA1djN6Z1VOaEowZ1lZb3JNczlqeTJEdm9MenRV?=
 =?utf-8?B?MXJhelRBejJzQnR2dFVnRVFsYStYc1EvYkczMWJkYlNObHpWWGlyd28zWGhS?=
 =?utf-8?B?cllQS1ZUQkoyL1E3OVlGbVBPZzFKV3ozNWJCYjZzdXlGcnBIT2wxUW8yaGJV?=
 =?utf-8?B?dGZyTTlINXlOa2p1c0VxNlhXSUhjY1ptNnFtZ2UxNUpTcExCeUpRUjllVmd2?=
 =?utf-8?B?bEF4TncyU0xWOTBTelNjVkY1UUNGTHVYaFJiSTBDcE5XVmQ1eVNEQ3BzUXps?=
 =?utf-8?B?MWtZM1MxQTM2U095NEdkQnk5MnIreHdKcUk5TURLZmNBbExpQ2hyTjd0Vm0v?=
 =?utf-8?B?OUpCQ3ZrV0szN0RiZDRRMEhwd0wxTTVjMWQ5a2JPNzZEYnNhL2ZEMlVqQ1R6?=
 =?utf-8?B?L1oycGJGN05NakZRaDV3dmcySFpGV3hCUFVDOFRoSDM4Umk4cjZBMGJKM3Iy?=
 =?utf-8?B?N1VqNTZ1dzkyWG5NdytjOXlraXN4ZVdoUkpiRENlNHVjbUVkejhxRk9VaTQz?=
 =?utf-8?B?cU5MMUx3WG56U3VBSlIxSCt3SEZ4eEt5WjZacG12dmlEaDZocno1TWEyck4r?=
 =?utf-8?B?TGw4MFA4WXE0VzBPWFN1amxxZHhxNkFKTDJIYlZzY1RiY0ZuRGt6N3p0TjlQ?=
 =?utf-8?B?T1dOdWVEVFJ3dndhbzNrTEVYc3hYZUZBZDZvRTBxZ3NvN3JzOGlxNzlPRzc4?=
 =?utf-8?B?ZU90TlFjTGJicVVZalh6eVlGMms3NUZ0UElqbjhieUJFMXNwV1dtSlNraFBr?=
 =?utf-8?B?MWs1dXRHVEMwSFpkNTViekF4blh3eitsbFlSNjVKL2F0dHBZVm5mRnI0eUt1?=
 =?utf-8?B?Um9CRVJWaGo4SEVaN2dOQ0N6Uk1wb0NKUGdzOERVWGFjczhlbGpOUThNVEFE?=
 =?utf-8?B?TnFVd3ZTZlQrYkZtc3ZmTWlWVmsvU21VaXJQd015ek8yMlQ4WVVzUGd2K1I0?=
 =?utf-8?B?eVdLc0xFcS9WTzU5SUs4dWtjUEhUamVCT0lJOUFETFdPbkNXWWpvUmNJV2RY?=
 =?utf-8?B?ZkFoSDdKandTQWNSeGdwa0hBVVpkc3RMZCtaRnJySVRTU01IcGdVUXhqK2Rq?=
 =?utf-8?B?SVZpQmZodU5pTW9iemhXRmlCekQxdXpPZ3JjaDc4eUFGbFoxdmR5Y1V4N3U0?=
 =?utf-8?B?YzRoV1prZlExVXpocDRaZzJKOElaNkN2d2FvRjkvQnZTU01wc3R1MG5Ja1RS?=
 =?utf-8?B?ZFJsTlpwUG9nVnhVaEZDWlgrOThMQmcrL0p2SDIyWVNPemVRNXh5K1hsQzc0?=
 =?utf-8?B?NnZ0c2VIak05SnJMWlRPajlzUlVLRmFySDZkWEJUMFB6anZZVmJlcTFUd210?=
 =?utf-8?B?MlFtcXB3b2hXSmFLSmVYMDFYY1l5S1kzZ05PSlVCcERDVmM2NGRCenFtZmN5?=
 =?utf-8?B?QTN4MUJzYnFLcUhVcDExMHNuaVFwTHFjTUhiOW1yTEZ4anM1UktVUVlqbTFn?=
 =?utf-8?B?dlBMR2ZiSzAzOE1oVHJzbkY4Uk5YUlArQUxvVzBNQ0ptMzVkN2l1MTRra2VW?=
 =?utf-8?Q?JHgvQTP0OQjOYh/qWiCQJXatiGIHIycc7zNzpc5I5lGb?=
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
	LQVay2R5APJs1u5/9OEE1aOMb18Bc6zwQLLYwrBPV81/4eS3yUyVvlkg8lgE9e25d4xPoZLiyzMKPVs6XfhmycmSYfvEAaD0F6HbuBK+WhDWGqUgY5GOIvatggOzcKl/oPsGaRDyNBwczgd/POqG+UAF+yt/oemNFb0xq+hpiMIN7QJavU5DPELV9y3gch+WUxj/0OFFAc8RMnG5k4o/D/6a4bk28Oc8K0E/1O6B0zCoXuHJ9uCAhrvWJyqxmdewSOd7JEqjm683lt44UnLlmDkg1L38PyC3lIW6OaxKjvZoIBwRyymMZy+pecuUBTSvpk8uiP4cDKcdXwTkuO6G++NjSJDGjPVgw7Cl3xiFE8LrVCQKNLP9q3bnMApK8FUJQvmGNtFBDXwjG5N3jipth4Jv6rBdwOBXfJ5kQqreSHD5QdpgGGYwzkG0iExoXXux/d5o7r67JCf+64HZdie65/kQgrzmBf+2Bpn9CXCUy6vgHPqHwv3TRYFsynnjEJ/RkrCTX/KYc6ZHpuqtepC0+kU6IdOK4rh3CjpBvf6/a+bfzB26zYL45I5peDPNeCSvMZWpNS+Zj6qIY5FV8xAAIZow+4Lr9lABnlpMSn27+BgI0UMu/XODshYEx4/Ak/zo
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ffe905-0a8c-4092-5282-08dc802366a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 21:07:51.3837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G2k2E30AS7lRWeQosT/L1xrIqwwL2Vxj0uGBJhRyPL6dPn5Bv+EdSjSldcFMBiNEdZKBRgnMhgxZuXi0Oln0nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR04MB9272

PiANCj4gT24gNS8yNi8yNCAwMToxNiwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gLSAgICAgcnR0
ID0gbWluX3QoaW50LCBkZXZfaW5mby0+cnR0X2NhcCwgaGJhLT5ub3J0dCk7DQo+ID4gKyAgICAg
aWYgKGhiYS0+dm9wcyAmJiBoYmEtPnZvcHMtPm1heF9udW1fcnR0KQ0KPiA+ICsgICAgICAgICAg
ICAgcnR0ID0gaGJhLT52b3BzLT5tYXhfbnVtX3J0dDsNCj4gPiArICAgICBlbHNlDQo+ID4gKyAg
ICAgICAgICAgICBydHQgPSBtaW5fdChpbnQsIGRldl9pbmZvLT5ydHRfY2FwLCBoYmEtPm5vcnR0
KTsNCj4gPiArDQo+IA0KPiBTaG91bGRuJ3Qgd2hhdCB0aGUgY29udHJvbGxlciBzdXBwb3J0cyBi
ZSBjb21wYXJlZCB3aXRoIHdoYXQgdGhlIGRldmljZQ0KPiBzdXBwb3J0cywgZS5nLiBhcyBmb2xs
b3dzPw0KPiANCj4gbWluX3QoaW50LCBkZXZfaW5mby0+cnR0X2NhcCwgaGJhLT52b3BzLT5tYXhf
bnVtX3J0dCA/IDogaGJhLT5ub3J0dCk7DQpZZXMsIHRoaXMgaXMgYW4gb3B0aW9uIHRvby4NClRo
ZSBvbmUgdGhhdCBJIHByb3Bvc2VkIGFsbG93cyB0byBlbnRpcmVseSBvdmVycmlkZXMgdGhlIG5l
Z290aWF0aW9uLg0KSSB0aGluayB5b3VyIHN1Z2dlc3Rpb24gaXMgYmV0dGVyLg0KV2lsbCBjaGFu
Z2UuDQoNCj4gDQo+ID4gICBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29wcyB7DQo+ID4gICAgICAg
Y29uc3QgY2hhciAqbmFtZTsNCj4gPiArICAgICBpbnQgICAgIG1heF9udW1fcnR0Ow0KPiANCj4g
SG1tIC4uLiB3aHkgJ2ludCcgaW5zdGVhZCBvZiBhbiB1bnNpZ25lZCB0eXBlPyBJZiB0aGUgdHlw
ZSB3b3VsZCBiZSBjaGFuZ2VkDQo+IGludG8gJ3U4JyAodGhlIHR5cGUgb2YgcnR0X2NhcCkgdGhl
biB0aGUgYWJvdmUgbWluX3QoKSBjYW4gYmUgY2hhbmdlZCBpbnRvDQo+IG1pbigpLg0KTm9ydHQg
aXMgMCBiYXNlZCwgbWVhbmluZyBpdCBjYW4gYmUgMjU2LCB3aGljaCBzb21lIG9mIHRoZSBwbGF0
Zm9ybXMgaW4gdGhlIG1hcmtldCBkbyB1c2UsICBzbyB1OCBpcyBub3QgZW5vdWdoLg0KDQpUaGFu
a3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
