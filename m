Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40931B5EB0;
	Thu, 21 Nov 2024 20:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732222246; cv=fail; b=i8I1QU7KIvAhjMbxnb5wSjkc7JoEQ+wxB1KjcwHgzDEPl6IOTEb8WHeRHRFMK4f8sk9+bnZ+8qvP4wZpHMwvIlAIwZQ+wk8dhBLCD8lZHiipi/dhZqF108G0wwhGAz7owRArnmQpD4IIImJOINu7yd4csKGDpDDkj2VJcw7HNQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732222246; c=relaxed/simple;
	bh=pB37gZCNzBZfaE+NaWaXoglSpTc7L0q+Pxmb/QFxIxY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i0AzkGBybqP9IVxWR9/CyFPA4ctW2VCSB/v6LSqaC9eVN3ImEsalXeS1TWh63XFrj8vZet80lq1C7GXCYyli72exAE5KjF0BoTy9UCDLurua7lqWbggHow7ReZcy37Y5Tq8qJGImydWQNtZ/EEA0ir+mgXkDWxBgX7fOKEBpbxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mjAFLUQ0; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Ga19D2t6; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mjAFLUQ0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Ga19D2t6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732222244; x=1763758244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pB37gZCNzBZfaE+NaWaXoglSpTc7L0q+Pxmb/QFxIxY=;
  b=mjAFLUQ0OHAhI3NO6uWL9HuEpabVvcfWIWVfjBOWJaMIqEEt3RIOlbWv
   EwyHMF1PZHDM5ycHmT/1rKifOSClgsy0YNxUwkWvfwrycfSnu6MLcG+6i
   XXEaQ1dPrpgAu187vtzxgjQJmrFHSogXr3EV1GwJkfYDVJi5ikGVcGfft
   305jSkSBChl2IYOALCMgtCl2iaIOBTup/M9WVOELQ/BF4amzAjptOYOrk
   r2FN9wJq0P9CsDfAnmNSSWdyZ8KP78Z1wDnHA1j2RoFEztu4KJS+5lYog
   eBKXp68MaJsdKpiKroee5ktbKGglsk6XvnqYeH2jFaAdsIZx4NwLO4hkT
   w==;
X-CSE-ConnectionGUID: 8DTjlDrERMOiC/AEn7FjEw==
X-CSE-MsgGUID: Gigt4ljVRRmXDxOhOm2GNw==
X-IronPort-AV: E=Sophos;i="6.12,173,1728921600"; 
   d="scan'208";a="32589924"
Received: from mail-westcentralusazlp17011029.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.29])
  by ob1.hgst.iphmx.com with ESMTP; 22 Nov 2024 04:50:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eWbPvjJR9BB0qjPq1GIIf9DkDHd1TuWdaKpvJydjm41tRuWHCqpiObOYeynPotsjbHeC+uBXWZ5ALarOjqHYvxpGHu4dVaqGqHsL3x9nze0O/DBlhebUjOfrnkSFmSDJSHB2pbcAvkwAxFsKeTijP9TOsPLYRBYI3/wIKEG5L9Ei+v4f5DrbT/e0MAuzmzvPvyRi+yg3ZMIXciTtptdQLLIG24V+Ws/seUNnH9jeUboPTYAPPqhgtE/+mrv42gdU7+h45qvbX+K2nzlj5Oo7dEya6BmKFhkVmrFD8H0XSEBKs2vxzQXp4du+g39qzhQQ+KiXbE5ymDS9FnVdMn81rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pB37gZCNzBZfaE+NaWaXoglSpTc7L0q+Pxmb/QFxIxY=;
 b=u0TUXMb723xK3uILVqq4qiq6Iv9Og43u/FlO1ZSm2eBVXEBvusmMoQsNiJ25ArfSqYjXx/VTPKQ07FnYHCaWxaQn9olPiVcs3MG3huOktEb9r6O/LbtqjPhuUoCwkkXMrWGDmjmhnJysEtWD7sBvgNvHui6dN8/fAbBxipZO0GtTo0hu8fmdhDxdyrHHCF39hJowAn8RYp/1/Irojgw146dhbzJF0zRsdTmDDp975OOMzmqHKVbb7DOeQGZwPXzso6dpAHkP3yVhtYYUxXRNyH/Ua88BV9AmgVV+kXERlvbC82xN9wiWgHeo/TaPmywbAWGBTmw8u6l5dKDoZV9Jhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pB37gZCNzBZfaE+NaWaXoglSpTc7L0q+Pxmb/QFxIxY=;
 b=Ga19D2t6kX8phj6mImDOAHI4coDnvL25+BKBjr9ueYjIJzRoYh+P+lEK6jljRiy8WpUTbtyDDspk3l+HcZHejAI/RMOQfxVjhjKFJEEgutWGndAmNPv/vLulqIUcS3bt0YF+1Iceq+c+u5OId3gZasmmtTqcWAf4kwbgG3bTxd0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY1PR04MB9611.namprd04.prod.outlook.com (2603:10b6:a03:5b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.19; Thu, 21 Nov
 2024 20:50:33 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 20:50:33 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bean Huo
	<beanhuo@micron.com>
Subject: RE: [PATCH v4 1/3] scsi: ufs: core: Prepare to introduce a new
 clock_gating lock
Thread-Topic: [PATCH v4 1/3] scsi: ufs: core: Prepare to introduce a new
 clock_gating lock
Thread-Index: AQHbOchJf8nR0be67kiHV6HwnKGw0rLCNFyAgAAF7hA=
Date: Thu, 21 Nov 2024 20:50:32 +0000
Message-ID:
 <DM6PR04MB6575EEC76CE7536BC97829CCFC222@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
 <20241118144117.88483-2-avri.altman@wdc.com>
 <2e5e888a-a7d8-4b10-a366-3cefd6685e69@acm.org>
In-Reply-To: <2e5e888a-a7d8-4b10-a366-3cefd6685e69@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY1PR04MB9611:EE_
x-ms-office365-filtering-correlation-id: c4f610f9-b8a9-462d-fdfc-08dd0a6e2461
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QzFlbWRPdmptZ3QxNGFEWFU5RlJhR1E5U0REdFBubjJuTzRJTHdBMjFSSHI1?=
 =?utf-8?B?RTRTdjg1NFdqYUZPeC9GT0VZK3dhcnlIaC9tVDVhNk9qem41OXhqNmh3OWpa?=
 =?utf-8?B?MjBndmRVb0xkdU9sZDMyUUo0YkFzbG1yaHFPQnR0eGhGWitrV3cxa3FNckt5?=
 =?utf-8?B?NzhJNktkajFVVmVZQkRBenplN1NIbktML1pFd0F5ZDZyNTU5SHpGNjBVNEtj?=
 =?utf-8?B?aVBmMTBhRkxBemttclovM3dBL1d3RTBESWlWYTVteUNBUW1nK1cvZ1pxSjZL?=
 =?utf-8?B?SGp0SjhSOGM2eDlHVkhpVnNlYTlzaFNLbUhlWlNFMjFVblBSMmtzdUV6Tkc0?=
 =?utf-8?B?aVZIaXhueTRlUThHNW1DRGJOclFrR0VPb0lhSCtIUHY2K1duWk40ZHM3Q253?=
 =?utf-8?B?QTd6RzYzR0ZwT1RBS3pHZ0ZBMGloUU1OcWRRZUJFbk9pcEp0TzFVRExPUE40?=
 =?utf-8?B?Q2lMYlVQTStTemN6aXQwemUvNk9MU2JwQ1NqNUJLUXF0TFR6OUlPS3FrNVdB?=
 =?utf-8?B?TWcvTXdERkxMb28rWFN3a2hGSWZqUHRPeDJacktDUUE1b0JhSnJmSlk5b3M3?=
 =?utf-8?B?Zk8vRVVqUXRsbEJ0NTJlemV2TTFvZ1EvNDArRTRldDNmZkM1YXZwT2lVdFBK?=
 =?utf-8?B?dTk0eGNFR1UyeU9NZUNKOVFhU0NYUXNJZ3UyYXZZVkdEZ3IzVnJqeWoxZ2Nk?=
 =?utf-8?B?b1hsUzBpVnZHODE1ZVFGcGxmY2IwdloyZGZhK2twclR6RmpBeDNLcjcwZzlX?=
 =?utf-8?B?eEFkbFBXbngram1oU3o2ZHlYWjRZazcyaGdnTzhUWFFMUThlMzZWdnBOUlVj?=
 =?utf-8?B?Um9FSmRSaUNUdVVMRytLeGlXZXJsYllLeFpza09EU1R5elVXcjRScjhGVUkv?=
 =?utf-8?B?UTBkeW1wN2t6aUgxWE12Nmp6aGRWb0NWaWdPUmUxVkZiL3FPUE5RZlRqRVpI?=
 =?utf-8?B?L202b0dua1gvSGNBcG0wT1pORE9TeVJlL2Z0a3ozRU9lcHlCRklqU3AvMGZR?=
 =?utf-8?B?emMrc1FacTJUeXFxV1J6T092VHY2M2tCV3p5L3NnRU93MklXSFk2TmljQkNH?=
 =?utf-8?B?eDJkZGIwR3VXOWpsTE45c0Vzelo1b09JWXZpcWFGMkZCNCtzTkVaaHVpV0d1?=
 =?utf-8?B?TExIN0svdHM3bWFWSEVUdnpFTy9POE5uTzRxdUZQZ1BVa1F4dC9jdU1ndHRw?=
 =?utf-8?B?Z1hBTkRFdTJ5dUEyVXc4ekEyUmdQU2p0UFdEYWo4QWF5MWdQdVhpQ0h4Ymdw?=
 =?utf-8?B?UzJNMVRLdzFvSFpjTFZRbitDZDBja1dkUXJwVEpTa21TcDJsNjc2Z1pkVFpG?=
 =?utf-8?B?eVM2NTlzUTBEVjl4anpqWGwvOGwxQWhIaEtKMFpRSDVsaGdGdjlSbUVqNjJl?=
 =?utf-8?B?UXlXSTl3U3BjZ0Z6MXh0R3VkbktrWnEyYS9JQ01jY1lsTHlKVUtPbDJ4N1d1?=
 =?utf-8?B?MmtPM2lIcVR3MS8zZTBYbndCdDBERG4yV3E1WFBXZW5lRW9YVUJnaC91N3dP?=
 =?utf-8?B?LzIyU01CdHEwWHdoRFdGakNHdTNnNnVYVEgxa1JabU00V3I5c1B4czlYMTNV?=
 =?utf-8?B?b1pHemQ1Q0FJVDVoQzlJcHV1aXVVbDBMTnhiK0dQTEFrVE1kRFhYcCtjbW5Y?=
 =?utf-8?B?STR2cGY5ODJVck5MQWJ6Rk44K3JNK055QkU2VVZHeC85dzRUQVVrSnNHdHRj?=
 =?utf-8?B?YXBVYnkrU09JZWdaS3RsYjdIZGxuZWVUbnYrbjJScVdsclhMSStOb20zL2Rx?=
 =?utf-8?B?VmwxbmFCaERLNCtuVUZrQTRNb3RQUXo0dG5MWDRqQlJXSEd0Q2FmcW9qYjR4?=
 =?utf-8?Q?NZz6iC5hFdbYbxUmankVlTrvRJm2ovK8i6SZM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OW13QXI4dlZnTUVYaWZPRVRTREhLNUZKUTNhUTl0a1VIM0RPbEZJejFLY3Jn?=
 =?utf-8?B?MytoSGc5ZEl1aDB0eHYwdE5pNWRFU1ZhdnJWN1cvVVV0VG5qc3hZQlJKanU0?=
 =?utf-8?B?TW1yNDMxazJDNytaZk9xU3JDUS9WanNlc241UER1V2c5WTY3OWMxeGY1cEVW?=
 =?utf-8?B?UlJHWm5hVEpncmU1RkFYTUE0ZVQrd0x2OThnaG81Z1R0WVhlZmc1MjZEaFlY?=
 =?utf-8?B?U3BCeXpEdWsxTHFEanBvVjRIQVh5ZEZDTkxJakQ2UEJKaE5SSmhUallOemNM?=
 =?utf-8?B?UlNFN1U2NkVqaFJqOEZtbno5KzUrRm9WUnE1bmQwbVBINUNnSDdtaFdidEZP?=
 =?utf-8?B?ajBUbHZuUEtmcW8xSTJrN2hveHNoc0ZQNUxReFNGckNyeHRubEx0NEI2OG9y?=
 =?utf-8?B?VGN5N2ZuRmpKdy9TZkR6QklkRW9jSEFwK3BhcWQzcW5peW43N3lPZ3pKaUlM?=
 =?utf-8?B?ZWhUY3NLVUc0Z3ZtS0pJa0FmQXVCUDlaU1lCTGQwREE2Y3JLTlg5KzJqV0c5?=
 =?utf-8?B?Y3ZWQWh2bmkxeCtsK1V1QlBBbUl6MlVnd1p5UjVGZVhBakZpeUh1R2hZdkxI?=
 =?utf-8?B?NTRVbERUcHB1V0JOZEtKRHgyUEo4U2VSWS9vQzY1aU81dmZoSENDa0lacGMv?=
 =?utf-8?B?RW1xTzBsVFkyUkFqcUphVUZidWx0Nkl6Q3FNbjk3UFZVcmgwWmRTeFNWNmFv?=
 =?utf-8?B?QVBtQ01FY0dDRnhDT21RMG1haDRxL2NoK21UZTlnUGFYbnIwcEFFWjdkSWhT?=
 =?utf-8?B?VjJSbFhudEhld2diVEphWFdTdC9BY0gzRk9yTm0xYkZ2Um50K2JHS0RObUts?=
 =?utf-8?B?Tzg5NEN1T2tJa2E0SVRJZEgwamVtQU00T01ib0c1dTlodDdDSlBPZlZqaWVX?=
 =?utf-8?B?NnhKWUVaVHRMdkJxMG5QSzZpTGE2MTJsS3hTTWhnckliNWFFemhzTmJrZ1A2?=
 =?utf-8?B?dGNoaFZlbGU1SlU2TUUzbU52bUx3OHlpZDZmMmUvRGxzYTlObXpybVYxdUFu?=
 =?utf-8?B?Rks2WHUzTU9ueENnK3ppbzVFRjRqbEJOZzUvZHlRNXgrTjB2N2VIaVJaU0t3?=
 =?utf-8?B?Sy90S3lYS1hKeUo1ekx4UUtTRmNmelB6VytLRC9CWXplU1pMNXhjYVlhY3Vu?=
 =?utf-8?B?V2h3b0EwNTcwT28valdYamY2RkxlakJsTkdSMHBGVlgzRis3eVdnN2tONER1?=
 =?utf-8?B?ODJyeVhhZTJ3NWNhNWhsV1JRL0RPbmhROHpSL0laOHlKT2FqT0w3OVRxRnQ4?=
 =?utf-8?B?ZUo1QWsvNWRKK2FQTDJIUFAwdHZLaW9OcDZyNHN1L0V6UWc4ZE1ZR3N5RzRY?=
 =?utf-8?B?Y1dkVFltMW5lUHFsUE5wT0RRSSsvTHIxV0ZrWlhaZU5BZnBudWF5TE9ScXdp?=
 =?utf-8?B?d1ZPMDQ1YjhIQjNPTUU0RldZQ2FId0JEbE9qUGZIaUp2TGpRT3NQN0VvS2Vo?=
 =?utf-8?B?TEo2eGM2ejhRbnNKYnp1OUhHSjZlUHZSaURVVVIzZEkvbndzOXNPUC81VDcx?=
 =?utf-8?B?QUo2eUxQSGRHdTBpcmJRSHk5YVlEMWJIYzFlQnBPTXJXbXZNZzg5Rk9NL0p4?=
 =?utf-8?B?UUQ3amNOUXFVVEFDNTFVSG80V29PT1YwcFMwQyt4WWtJSEdxTEpNVkpwRkcr?=
 =?utf-8?B?eUttZVBTSzcrUmxuYmJrVDZtSUVaMVdRQTNVZWptaVNwSlFCNXllaDFydmts?=
 =?utf-8?B?T1FiRnowMjlmKzZVQkRFUTFnbm9oak9hd1NVdTZ6Y2cvNitZMWVqU0VyNWRF?=
 =?utf-8?B?Q1JScjFORmlEVXdRZTlzSWJNNTJocDNDTHQvNGJqQ1AvRFRvU3NFeDRvbzlw?=
 =?utf-8?B?elkwRlRoUnYzY2lpcFFDUUdSUFlvRWdGdFd2eElkTGJkbUsyL01OMFNXU21R?=
 =?utf-8?B?ZHlYbHdRdC82bTZsT3A3SjlEV3ljUFpsbGV6ZUJSTDJpNVZOY2c4Vk0rc1FU?=
 =?utf-8?B?SWpzUUlGZzZxb1JaMEMrV0ltRUR1QVBOdEt3VkdWUU1QbnZWa3R0VXRRek5T?=
 =?utf-8?B?SmFnYjZDeUN4U0p1Unh4MGZjbVBrNytYV1RsOE90SW5TVEtRWTdWR3E5ZUhQ?=
 =?utf-8?B?N2hob3c2KzhkdnRwZ1lVTUs3NC8vUkhha2pmRkJMcS9zRTB4UjBNeEx5Z0pj?=
 =?utf-8?Q?UrOO/8/znsTEfvAeRmOptmcG2?=
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
	YMp4S3Y1wLSQkh6a9Fa3g+dtNQRGfSHUYZ8pYl2+Hb3NDxrNNUkg7rC7mGQFKHeglNN2b05JWntwiW9pZ4vkPU6gYIEr55zJhqnCawNEJSdv1G6hCpIa88KhF3mnwxwUryHN8DBfYnvPOdhhFMIB0H6uKdPSoOYq3lO+HC3d+aXRMLtrWdTU61DByth3SUZbQcg36WPbDYN8Zw0WIBzZFe7ULczrd7IYnpBqZ+VrBqI5LdGZGKH9CbzlVP7WnT/Mi38xq/of2bxrJ+8jy7s8AIYYQ4M56c7ciCEEIBl+Pkucb6XHaMXY67DXpnZfOlelnDEBazA7gMvBzCY+iPy726JYP0034f6qBUyKWkrPhko5oB1fkFUN1z92tswtVwRcfrS8Jf+U+JaYvNh0QTCV/MJJcmcK1DGF7MeOzUNpHPl2zsrKYmcfULptKmGShbgvZdm79GVRrtIehCI2ZZG3JLnlBdJnuG2H8SviSF3NGEtqcyhzcyyuQXbLjotKBw84AzD+g3uAQQAZYTUkkWKUAiyo3Qw6wOUIUn3yJ5lsS/mjFIWZuV2ul0BT1TDrrm0WMnx8zZcICra70Pf6BIXL2/PuEC9ha6Q9SPE6fpcm1d5P9+Ai0Ab9cRotM7MK96RY
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f610f9-b8a9-462d-fdfc-08dd0a6e2461
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 20:50:32.9276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pQDBnUEZ31OJTkfrzQu4vBo8WaUYT/nlFAixNYifsLFUwtLhJFW6cucL8aLKb7dVOEPc+rL2rtAvEGIadGw4lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR04MB9611

PiBIaSBBdnJpLA0KPiANCj4gSSBzZWUgdHdvIGNoYW5nZXMgaW4gdGhpcyBwYXRjaDogaW50cm9k
dWN0aW9uIG9mIHRoZSBmdW5jdGlvbg0KPiB1ZnNoY2RfaGFzX3BlbmRpbmdfdGFza3MoKSBhbmQg
cmVtb3ZhbCBvZiBoYmEtPmNsa19nYXRpbmcuYWN0aXZlX3JlcXMgZnJvbQ0KPiB1ZnNoY2RfaXNf
dWZzX2Rldl9idXN5KCkuIFNob3VsZG4ndCB0aGlzIHBhdGNoIGJlIHNwbGl0IGludG8gdHdvIHBh
dGNoZXMgLQ0KPiBvbmUgcGF0Y2ggcGVyIGNoYW5nZT8NCkRvbmUuDQoNClRoYW5rcywNCkF2cmkN
Cg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
