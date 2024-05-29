Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1861C9EC0;
	Wed, 29 May 2024 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717017180; cv=fail; b=TlZ5/x7gWLPvNTPlfxBFX8zLJdRSuHbc60j/6GG2a1AOfjU07c67TZgrjeNeArN3m/yjzWdHOhl9mlomT+49euG1qciTabKFM0volBEZFOHWLHM4CIy6d7KwhbR5dxwHy6YPTUplCVfNExHDekXK+Is+GI106UU5aNabN0oNH00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717017180; c=relaxed/simple;
	bh=cjKaKJeQcZ+zb6cAwk8W5UdOnn06hQp1mSXOYR8CDHc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m10VSvle8J3wN5YQU8PM+F6ftZXB6YGQM/NgVq8FdyYOzUNI0ftFXPTDrx7PAJb94GDik1jOZg4igNuj2diKt5mdtDwr6Lvz4c8a5Swej5u+OJVvNTxmqDJTpy3NdCJOzuEyOJ1UCvv9FcPr9gusY9yrRIWMAx48Ift2I98Gdmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ObcIPy1z; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=uuilizGH; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ObcIPy1z";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uuilizGH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717017178; x=1748553178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cjKaKJeQcZ+zb6cAwk8W5UdOnn06hQp1mSXOYR8CDHc=;
  b=ObcIPy1z7YRMdnKcKosSa/FzoM3DoRjmCEdUcZMZdhGbHPlEjlgpFb7O
   aT0rXwX+MIDP8ljnJH1KaQjW/YMzKNXrSv4KA3sM+ljhkFRxQujRATeCh
   cmIfYDiSdSVi21DBE80a1C05tCYzRlQ+mblLXq6Fn6mWc+B958AuvchvU
   5essa+z4dQWJ0kx9lxFasdH04XbztUY2bFuW814utNY9ARoDLMp7X1C7I
   n8OlWGkl9SD0dhcsCJ4tCbCZxdYhwdLn3RimaZ32L8DQDzm3HmYPnh32p
   YK/Ki1c2pzpA++17ntFVqpimFLCGXrSy1dsBW8Ave+hm8iEk9q6eLAaVs
   A==;
X-CSE-ConnectionGUID: lvVSj9iMQsKuUQrlRXQOZQ==
X-CSE-MsgGUID: qHaR4zaeTAak+E2/qMPBbA==
X-IronPort-AV: E=Sophos;i="6.08,199,1712592000"; 
   d="scan'208";a="17579050"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2024 05:12:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZiwMp9H7f6mSaQ5YoTQC1MoGWaCAGEuRmfQiyzlTWtTzbrp5B5tTeYeZRg7Z8O2iALd3RqX79g/mMol+LcupTb2kbYLtaa+Nmpk1r9NLb4sELEuMBqYhfmknrbfqs2YjTmFFsLgEUCZohjktfzjXE/LtHh6gHldC2INTnm1wfVJuiW+FyLWTfA7CAxY82IGZaDnQAfAdFin7OFXCTpN2vc6biuWr1CDLekLTYyxKzZBG1a3+Z/Qio9OYq3OcgujSMD+es2KkdvnTcBIPT8As9awi10E+JAhuObj2URzGaUeyyrMSxXn7YPo6s0k/wgvfcamL1q4IkSIKNce1iOseA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjKaKJeQcZ+zb6cAwk8W5UdOnn06hQp1mSXOYR8CDHc=;
 b=lhIXjpSUtMNMziFQBz8jxPnDEqED97RQ6+LcK9V145cBJCqQ8r6cKxA+eQICPmKwelo7lGKwYbHLysGw9cZoWkiw/AbTc8O9SxIsqP6/9tRJ07/Ewa2RLsloduPrdVlk/LxFp8tFME12kZ5+DYVYfM4c19P3m8ezCkghgR+A/SABCSW9ZvI2eCfzHtyzRXFzMnRDPDTWq8VyHemKEVTgABH+uonjh4Qd4gbtLO0fI11kgCMm/Rs58C7BlLYpvOmqrBmlh37F9U8OGUerfzVHgrDKKhURg0drp+CiEnjbrcYO3w9DEWJ98xFqrsFgmwNSYGO6lT9jxsx//FGDAVMSzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjKaKJeQcZ+zb6cAwk8W5UdOnn06hQp1mSXOYR8CDHc=;
 b=uuilizGHL1Wwms8/KHpQYeWGu0ZJGjS50luVK/7m0iehQv15Ttbdp8NcLSWl350liAxzuiLHs4vdWRFWoT/qqXd+7mc5Mzr49AI+Y5OV2h3WWEsWHmTR5NBxwQuoZ1/XUL1MFo7hoFuVJgjEX3drS8Pruil3qovQL/auP4LXfCY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN8PR04MB6417.namprd04.prod.outlook.com (2603:10b6:408:d9::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.17; Wed, 29 May 2024 21:12:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%6]) with mapi id 15.20.7633.018; Wed, 29 May 2024
 21:12:54 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
Thread-Topic: [PATCH v6 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
Thread-Index: AQHar0UoMeVU5ed1zkatPuNQitj8NbGup6KAgAASgXA=
Date: Wed, 29 May 2024 21:12:54 +0000
Message-ID:
 <DM6PR04MB6575DBC319949EABA3D5226BFCF22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240526081636.2064-1-avri.altman@wdc.com>
 <20240526081636.2064-4-avri.altman@wdc.com>
 <4251566e-0a1a-48f1-b170-d5987bbabd90@acm.org>
In-Reply-To: <4251566e-0a1a-48f1-b170-d5987bbabd90@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BN8PR04MB6417:EE_
x-ms-office365-filtering-correlation-id: 809bf010-50a6-4da0-cdc5-08dc80241b83
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?QXB0ZENURGZENHlvV2d4eWsvajU1VjNoaVhldkZDMzBrQldaMDFBYTJERUtP?=
 =?utf-8?B?TSsxeXh4Wloyc3d6eEFGT2g2Q2lqTmU4NUFic2RzMWpRZnA5OWJmRjZ5YnEz?=
 =?utf-8?B?VysxN0kxZS9Ya0NtSSszdDc3YVh1Ukt5VS9oa1NYM3hKeFNmMEZxVDQwZktR?=
 =?utf-8?B?MXd6MnVBVG0rUTNhMjFKVTdkbEVNZWY1SlFsUjJwYjRPKzJuTklGUHVOZk8v?=
 =?utf-8?B?cFhiVCs4MDMvTzNnaGZnV1ZGNEgzWGhYemxUVmRwb1BMVTBpRTR0azIrWEZO?=
 =?utf-8?B?dVhjVjU0U3JLRVZxYmw2UnNZWFhDNG51a1VwclhnUHlHUVhvQSt1R2dvZW1p?=
 =?utf-8?B?akZSZjBXME1yK1RSNG0rS1Yva21QYzNPUXJmRlBBa0pIRTBsR1Zvak5tczNL?=
 =?utf-8?B?ekduNElXMlpUdkdETktVbG5pb1RubDhFQ1B5ZWhMc1FyNnI2TzFBaTRsUUxP?=
 =?utf-8?B?VktheVFUanpUclNOeTJNQVIwcWxhWXpkNzNoL1lzV3hleDJuaFFUTzlaTTlE?=
 =?utf-8?B?NFpnbC9OVU1BbUJ5WkhOZUdHYzNxUEpsMXZMOGpEQWU2SzFpQWxTRTMxOHBQ?=
 =?utf-8?B?Q3N2MnRaUFp6S2ZmcUdsR1BkeU1mWkV6OWJQMmRsM3hxbjhpODk4WGk2QTVV?=
 =?utf-8?B?TmpvZ3dySnU2N0JnYjAycFdzeVV6Smo2Um9tQlhLaTJjOUJZYmJtWS9HUk1S?=
 =?utf-8?B?dWRnN01iRWFOL1MwR2hFWm54d2hNT0NaRTRTQkZIdzF2aHE5dUZuVWxqenVi?=
 =?utf-8?B?R3BHbVh3K1hwZFhmZlk2Z2RWNTFRa094RjJXSEh1VDZnemdwRllDeG94ZU0v?=
 =?utf-8?B?elF5aUgxM3NEL01EV2g1bU16dVBIZHBLdXYwWnFjbytBT1JIdVpNRGs2UUVB?=
 =?utf-8?B?T1RDaU5sRWRVdjNxekVqM1Nsc1g0OVY4WnlNOEhJTkpRM1ZHcnZJRjFGYTh0?=
 =?utf-8?B?ZGNadmpMeG50cm1NeWlLY28vek1oSEp0VWxldHVDOWFCM3Z6RE5KMEhQQS9z?=
 =?utf-8?B?ZHBlVkNLVFByTmZEcGRtVmdVMld5b2djYUJETE9xNkpPWmRPMFlPcFp0TDg0?=
 =?utf-8?B?NGZjWCtLL0dZTk9rcXgranVlL1pKTjVFWUVBY1J0U1VWMzJJS0JRcEx6dGoz?=
 =?utf-8?B?WkxIemIzcjVEckJGZi9QZlN3S3NmVTNMY1NlS1ROSG1uQTRlNUo0elFpTXMv?=
 =?utf-8?B?QU9GQk01eHM3Yjd1KzBlakxvZ1dXak1zQklGUjNZanNYMWFGWGNxOG03K280?=
 =?utf-8?B?WGJCZWhrOEszRjdnSTdkdjdIV3ovWmhSb1RoVUcyYVg4NFlhb3FZRFJmTDg0?=
 =?utf-8?B?ZFVRSHVEVld3UEFacm9WVXBnRTBSZFMydlplYlVhOXBHNTRhNUh4TU1qalVQ?=
 =?utf-8?B?bzlzSDdaaEJZNlFNR0FWdWdDclRnQ1pycU9iSTFvTThLRmtyNVZmZHBhYVFG?=
 =?utf-8?B?Q1d0K1U2a2JaZktHUWw5RzRRcHdySHNXc2NWQUloQXBWa1piOTlsUmdaWm13?=
 =?utf-8?B?bnRNUEJpNm9ueTVvSmRLZmZDOEtMOHZ5Tkp2MkNNMU04RkxFaW00MnBEYm5t?=
 =?utf-8?B?d3QxTXRwL0FJaVRlRStlVlNJYnk5OEh5RzdYRFNMWHVmaThWa2NCYzYySUt1?=
 =?utf-8?B?RjlYY2Rub0NuZjFuWWJxeUphanVvZXBTZlYwazdrd0VjZi82NlRRRnlpS3hy?=
 =?utf-8?B?emtzTTZpWk1CVm0zditwRWtQd1lDWFV2d1plbTNIeGowdTRILzVFOG9PWXVE?=
 =?utf-8?B?Ty9EdmQySWM4bVVGTkpFcFRXNy9GSlNLTHUwY3lrQmU1MDltSTg5bDJnY0Vm?=
 =?utf-8?B?K0pMS2ZRd0c3RC9QWUoxQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dlhXY0NPNXRsL3NPRFhRU29aK3NpdUVrcVdSb1IwTGpVbWRmU0dGa1RmL2JG?=
 =?utf-8?B?TDlhZXFtWjV6Z2ZHTXQxaDFiOUNYS2RHem9TbzFKT1hVSzN2amF0WGlhQ05L?=
 =?utf-8?B?TGIrTWh2bGpUaVY3RG1wT2UvWFY3L1NkeDhLejB5YkVtQUMxRnVNN29SQXE5?=
 =?utf-8?B?YjVPWVV1T2UvejEySm1CdW9HT0JYb2ovdkl4VVR3dFRyMThCcnY3SEN4OFc2?=
 =?utf-8?B?YXBKdEFmTkk5WWdZZjBzUU9OZzVCVFQwUENCc29lKzA2RTlJQjVac2JqV0hD?=
 =?utf-8?B?anE1VE5xOFB5cHh0STl0WWFHaXlFZE9KdzYrVXc0M0kzM0tTQUdLQ1M5K1Ba?=
 =?utf-8?B?UXgxMDgzRDF2MVhyZ3U5a0NWeHltNGNFdmpncW9pS2pKRkc5eGVYZTJsd3dh?=
 =?utf-8?B?dG1iMUZrQm1OaW9IV05uOW5kcmcraHVOY3hlZnE2YU9XVnNQRkFmTDIrbFU1?=
 =?utf-8?B?K2lBQldjcWgrZE1OMWR3c29GS0UwdzBGc21NMWZmcmlTQWZROUczZGRzSGdk?=
 =?utf-8?B?Ym1qSndYNWtlREZ1b3ltUEwrMWRqQzBoc0ZyaGJSdm9EVlpUMEJZMm82WHND?=
 =?utf-8?B?YVRIREk0L3hxcEJ0enpxSW5VSkRGekROdndVZndpdFBtdllxVUg5aEY1dS9i?=
 =?utf-8?B?c2ZvZ3FDa2JNa2ZRaXlCc1h1Mnp1T0NXTEI3TUV2U2d6R2VzMUFSS3lKcWtZ?=
 =?utf-8?B?eVl5Wnh0TFNyNVYyOWdDVFU4RjlUaEFPSkVBN3ZrV0ZFWFVMamd0VU1RRmNi?=
 =?utf-8?B?eUR1akZtOWJSQ1pQYm5JY2ZjZzFtU0kzRzdBMWVJQmQ3Nnh2aWROSS9Hc3Rh?=
 =?utf-8?B?K09MOUFBenF0Uy9reVdiMUdUNEk4Qyt1TkFxVSt2ZTRrZFV0dnQrU3U1dGRu?=
 =?utf-8?B?WThERTJLRjNNUWE4NXNaNTN1NmIwUmFsVTZlNVdKWWhHZzFXKzFxRXA2R0sy?=
 =?utf-8?B?TDB4azU0RFJJSXByeXdoMHRieU5pK2xrMjJHMUhtTmR3eUx1cVZhTk5IaXE1?=
 =?utf-8?B?L3VrZHZkcXkrR3RoVjFISTZaQUdkNjZHeGJLZVBmTVpCZmNKanVRVHNITmN0?=
 =?utf-8?B?L3RXMUZ3dmZKcWd5SUFMWGZWWXdkalkwZ0lNb0hmdkp5NmJLMW1hdWFTN1pI?=
 =?utf-8?B?MHljSkZMK2FFMGpNZnVySHJhdVVFRG9SNGx2WVpkN0NmYmY2TUkwY3RLWVdw?=
 =?utf-8?B?Y05VanJRQ21XRkZBcFQ5WFIvNC9ISkc0cWIrVkkrc2tjMWg5M1NiTFZpdkJr?=
 =?utf-8?B?U3ZkbHVIcTRmMkVaZjNUVkt2SFZicFJJRzlWOWRxdjNCR2FQL3FKM2pTRnN5?=
 =?utf-8?B?Wk45NkNWVW9kRDJKL0VoWkhBbmxPWjNIQTdEc1NSU3BRWjZNTzByN0RCbUFo?=
 =?utf-8?B?ZXdqMjJkNlZpczQydGhPQWxtTlJLekJSa1hXZlhYQ29qSlJtOTVaSDdBWmU5?=
 =?utf-8?B?Q2hSaHVadUMxbldJOWZDUnpYUXVyQWlDL2x0RXFYL1pLWjZRc2dnanNpNFdV?=
 =?utf-8?B?SFgrbGMxZUNQQWJsMkEzSlMxZ3kvSGx0QkJNZzR1aGtVbHduNllCbGdHbHVv?=
 =?utf-8?B?cStLTzk1ckE3SUxZOUgvUVJyY1JsaDl1QVZaMFNRN2FkcWJtbzVRTWYwNzJi?=
 =?utf-8?B?dThLU3RWQ25ncnRMVm5va0g4dmdDaTJKNy91WXN3a3lmMXRHYzdXaXRUd05L?=
 =?utf-8?B?c0pYWjNwWVlIMGN4aE1tNUtzL3lUZkUzNm9BMktFNjRsSCtuc2FLRTdCOW9V?=
 =?utf-8?B?RTIxVGlCWUdia3F0RHhCTmprODRUNXYxZWxaU1A0RkEyZ05lS2duVGdDNFFB?=
 =?utf-8?B?RDRjQXc1YWovYmR1QnMzemdsVW91NjI5VEdNZW01UmFkOGJsL0VTVDdiRjd3?=
 =?utf-8?B?YXc1TkJjOGxERnBESFRsOVFBRlVXVGovdW9ZdWlPdXVScDREc3pmdSs2cWpt?=
 =?utf-8?B?SFY1czZrSUg2WGszMWtnOHVrTUp0VDJ4K0cybWpCWXdLU1lOVXlnRlhSbDhi?=
 =?utf-8?B?VVJrdU5UWElvNEFJZTJvS1BhTm8yc1pKT0p2aDIxOHduNWIxNE8rdmk1Ti9K?=
 =?utf-8?B?T3FrSC9UbzA4OTNjdzJyYStMSnB3c2JFUUxMd1RvN0xNblRSSnd4dnFTdWs2?=
 =?utf-8?B?dXUxS0xKYzdnL1AzUWFobW1KRDcra1llbzYvbk9RbThrSWNtNXFMTUtCbkRp?=
 =?utf-8?Q?WfcwGDnb/Z5jNJYLqcYPxZISczh7J9RqG2PbV8z306Zs?=
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
	5uPiDFfA1s6cUwfAP+65XQrGN5XFeGPF9MOr4bkihF9izoemacf8u00Lw0564PWx5hgih4JBMOitwLLzjaSNcgXS8kWEoYXJEWcjEtp9G2RUrlCsMlDc2czE/S37qKicHkmibHk7j1qGgzudfAJtBA6K6zlyhSGwO8r+E7M+OSExsIIQX1Tj5npJd0b3ym1WgCIpuwUtFeiVTJom2XdNlTbG/L6WQkg38QSaIjIGO0mWH0zQE4dYO6bYpaDynwFr2T65XRRExcbRl0E9L4Bk9ftxqaiBxrSGdob4Iaq68bw/F7hI2xSB+KUUZRROuIuFn+fw3b25gSEPFgXQkcjo041wY4UVC5STe3SNNcqyj99MHlzCfUzI/G3c4mgonhgSDwqwDRPEYmfvsQaowmC38f1QBr/DeGphmWM+A0mk+DLqfHuJbAVlk3vS1KH+jPU9WyY+huBzx6M4KI25/sK1sej7ywbAyJyKS0eX98SkDnj18PFd1y/3TZFki/zscGL1EmPD7/6bJUXNa8HRHAbr0QjK9CGpEnfAHLqxhupJQHYTxqfar1gB1Zw7DKDzGUjuKTG/7tSD8Dd++SO+X7FgWBmbwd8ZqesW/f4lDc5hdYk18q6YTasQTN34iaBe0sDx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809bf010-50a6-4da0-cdc5-08dc80241b83
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 21:12:54.8410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KsZcuj5pQ+WTOMHtdSTIXBEFNpqbcefTLESjSUteWi/frrAm6Immb8CkomoJCH6GY0xn9BG8Y0Fm9YmvBEe2dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6417

PiBPbiA1LzI2LzI0IDAxOjE2LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArc3RhdGljIGlubGlu
ZSB2b2lkIHVmc2hjZF9mcmVlel9od19xdWV1ZXMoc3RydWN0IHVmc19oYmEgKmhiYSkgew0KPiA+
ICsgICAgIHN0cnVjdCBzY3NpX2RldmljZSAqc2RldjsNCj4gPiArDQo+ID4gKyAgICAgc2hvc3Rf
Zm9yX2VhY2hfZGV2aWNlKHNkZXYsIGhiYS0+aG9zdCkgew0KPiA+ICsgICAgICAgICAgICAgaWYg
KHNkZXYgPT0gaGJhLT51ZnNfZGV2aWNlX3dsdW4pDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
IGNvbnRpbnVlOw0KPiA+ICsgICAgICAgICAgICAgYmxrX21xX2ZyZWV6ZV9xdWV1ZShzZGV2LT5y
ZXF1ZXN0X3F1ZXVlKTsNCj4gPiArICAgICAgICAgICAgIGJsa19tcV9xdWllc2NlX3F1ZXVlKHNk
ZXYtPnJlcXVlc3RfcXVldWUpOw0KPiA+ICsgICAgIH0NCj4gPiArfQ0KPiA+ICsNCj4gPiArc3Rh
dGljIGlubGluZSB2b2lkIHVmc2hjZF91bmZyZWV6X2h3X3F1ZXVlcyhzdHJ1Y3QgdWZzX2hiYSAq
aGJhKSB7DQo+ID4gKyAgICAgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2Ow0KPiA+ICsNCj4gPiAr
ICAgICBzaG9zdF9mb3JfZWFjaF9kZXZpY2Uoc2RldiwgaGJhLT5ob3N0KSB7DQo+ID4gKyAgICAg
ICAgICAgICBpZiAoc2RldiA9PSBoYmEtPnVmc19kZXZpY2Vfd2x1bikNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgY29udGludWU7DQo+ID4gKyAgICAgICAgICAgICBibGtfbXFfdW5xdWllc2Nl
X3F1ZXVlKHNkZXYtPnJlcXVlc3RfcXVldWUpOw0KPiA+ICsgICAgICAgICAgICAgYmxrX21xX3Vu
ZnJlZXplX3F1ZXVlKHNkZXYtPnJlcXVlc3RfcXVldWUpOw0KPiA+ICsgICAgIH0NCj4gPiArfQ0K
PiANCj4gV2h5IGhhdmUgdGhlc2UgZnVuY3Rpb25zIGJlZW4gZGVjbGFyZWQgaW5saW5lPyBibGtf
bXFfZnJlZXplX3F1ZXVlKCkgbWF5DQo+IHNsZWVwIGFuZCBoZW5jZSBwZXJmb3JtYW5jZSBpcyBu
b3QgYW4gYXJndW1lbnQgdG8gaW5saW5lIHRoZXNlIGZ1bmN0aW9ucy4NCj4gQWRkaXRpb25hbGx5
LCB0aGUgV0xVTiBzaG91bGQgbm90IGJlIHNraXBwZWQgd2hlbiBmcmVlemluZyBvciB1bmZyZWV6
aW5nDQo+IHJlcXVlc3QgcXVldWVzLiBUaGUgYmxrX21xX3F1aWVzY2VfcXVldWUoKSBhbmQNCj4g
YmxrX21xX3VucXVpZXNjZV9xdWV1ZSgpIGNhbGxzIGFyZSBub3QgbmVjZXNzYXJ5IGluIHRoZSBh
Ym92ZSBjb2RlLg0KPiBQbGVhc2UgcmVtb3ZlIHRoZXNlLg0KT0suDQoNClRoYW5rcywNCkF2cmkN
Cg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
