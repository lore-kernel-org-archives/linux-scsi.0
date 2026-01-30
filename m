Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B142D9EEF;
	Fri, 30 Jan 2026 09:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769763874; cv=fail; b=hAiff2VasVjLrQy3sa7TFUgvRJvK6CH0jyshD1deWE8dCFhBZ1N8phxpkmmy80TrDLBNtZ74bTZVtoegPAps0ksscXpFaykmWUxu329t/3m84lnl9Rqiw28U5JoYTZs4PWaXAsBabzhoQHI41fDSldj6NNvVTnwrsjLgHfcCsT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769763874; c=relaxed/simple;
	bh=9pMvBB9nOwlWr/UDYvEVVySmBzQ8uK6qhgLmIh/Zgks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M6HlY+RXgGMrlfd6nxtZKxcndlPYwfheDTdNaiU1BRvT0arWF4lQ4V53ZX60tAjKlXoZuws6EX4/xyI67x5219SAUOokOjswGtaJF3XMjq+nieUlB5os5Vrg1EYVAZKelmsfDxFpXDPrjMLpHpdoc3HJ2L88vPPtfgndbH2Pcso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=UsdFWsrD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BT0PCES+; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UsdFWsrD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BT0PCES+"
X-UUID: ac08175cfdba11f0b7fc4fdb8733b2bc-20260130
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=9pMvBB9nOwlWr/UDYvEVVySmBzQ8uK6qhgLmIh/Zgks=;
	b=UsdFWsrDeVROsRvRuo6rRNoj7SAdyDfISgLUap6aCCxFKXNy3wYFsQxgVi894i2Vt3AeDr0ZOQ8mFx3vgDSadNZSlKYZNFsyfInLwc1Smb5lHjyEJSFLDEp+fm5869KImkovIjf9OxwFX+2+wynjVzNriGWBOnn9TUvdjJ28Mp0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:049ccd58-7245-4c94-83a4-29a404b277d0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:5c8b667a-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ac08175cfdba11f0b7fc4fdb8733b2bc-20260130
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 333549574; Fri, 30 Jan 2026 17:04:24 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Jan 2026 17:04:22 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 30 Jan 2026 17:04:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DW9I+6wRqs34Ax5t29VANA0HuVGZL3rQ6fUvkDiOnR1X/WIRcA0yIGoX6z6sw9z7QHTJKY8dpJJqf1bA9JVFWcSukBiMzUMAud8UIpx+yN40vdeUyoQrtx3XjR46CdboYxPmxoAuztpvR/oNQqmZ80aciHw76Lfg++7ka3F4Ex4bEcja+GgK5eFq+jcKGUPByzBnjCrPh1VjTc9fPu6ncQvIF5mvExpZ1JtlPclhJDkM9qDwLy1lXKwxkF+bMbHZ7qHYGNbppS2/5+cDEA7OACV7uYVnMsEVNEh7L8kxiHAGbXM3yhty5+Hd8+CdWt7KcygX5C/9jIWBsPGFEJlVRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pMvBB9nOwlWr/UDYvEVVySmBzQ8uK6qhgLmIh/Zgks=;
 b=Dur15KB8VOqmQw74nq5LBRz9un1cwHmwj38/tC/L47G4la4fLUU3PdkovmLTW/nhzAz6Gb27oynljxbiRFNK4ZpT9/SJ1z8LbyDAjgnVE9BNUcAHYP973ZfxmPudMFA2h/QolbwzcPy4OOKcdztTczu/eaRM1YVS+kAusYFyXWxnVsUzL3R2vCusH1Q+MxulrDfQETPa7zmgv4uSRgoEJDbf4s6TpDDqV+phQhQxW5/hlGY5tjx2s0YsSVFSr0XoYN7P6Yiy2pv/zdAv86K6v1t6uNUQP/OVmhWHnON4lSVKgU9BkAfHw2UFSyjwTIb/huz35mBfTQPaI+l/F96vPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pMvBB9nOwlWr/UDYvEVVySmBzQ8uK6qhgLmIh/Zgks=;
 b=BT0PCES++fkX+CrcyaQMCaghQleSJS6X1c5AdhF4XF47hX9NTgeEjaH4/55WPBtHFnhZ4QGYU4HIxShV88BpFcRk7oMTUvzhxU8Y7hZAz4HlBfvNj4/gegJWYkHfle3Z8u9xQ28sS/xXLBnI4PUQy3xXahCuV7sLnHSt++NnQoU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7537.apcprd03.prod.outlook.com (2603:1096:101:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 09:04:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 09:04:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "powenkao@google.com" <powenkao@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Schedule EH on WLUN resume failure
Thread-Topic: [PATCH 1/1] scsi: ufs: core: Schedule EH on WLUN resume failure
Thread-Index: AQHcjDORziQV2W7w4kStKvWNtrcTVrVqdmmA
Date: Fri, 30 Jan 2026 09:04:16 +0000
Message-ID: <cb88235a21c4effd8171b33f6ee904067908d230.camel@mediatek.com>
References: <20260123045504.3507948-1-powenkao@google.com>
In-Reply-To: <20260123045504.3507948-1-powenkao@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7537:EE_
x-ms-office365-filtering-correlation-id: f467dfa2-ead7-4362-720e-08de5fde8bb3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Q1NsWlRCVGNqbVBDbzlGRFJzY2VESFlkVjRBTGZyYnN4ckIwSWpFeUVQYXR6?=
 =?utf-8?B?R3gwZENPM3JnS3ErejZJSnBVYVFPTjExQ2FDTEV6YS9rOFYzNVg0M2dLc2dm?=
 =?utf-8?B?azZZSnFmMjA5WkdRK3NuOXY5b2FxYmpOWUdHSnF3NVZJeXFDaUd6Ti9hdWpE?=
 =?utf-8?B?RGVBNTA5a0VBZEhyeEdlL1BJOHRwS1BENXFXVmlzSERCc0tYK3JYZ0Q4enE4?=
 =?utf-8?B?RVozMGRiWUw1VmVPakZlYWRPT0RiRjRRSkJZUE1JbnRHRmRLN01qdWlYR0xF?=
 =?utf-8?B?REtHclVqNnVtcmhRcDFpbEkyakVtQ1d3THM2TGhwZ2NZc0x4NDVmL3U0TGpX?=
 =?utf-8?B?cEFMSHJNWlpzem9uTGdiRUVpc1J1TXBPaHBnSE1CVGl1OU5xS1h2OGFPd2h3?=
 =?utf-8?B?d3I3QnJTWmQ1TEg4V2dTM0c5VkhOZ3hjQ1lRczdzWWg4YlNFaWNqY3UwcFRQ?=
 =?utf-8?B?N3h5K0ZIYzR4TnhwTWs1V1plbUN4Q0ZlQnc1MGppVTFOT2tXL2I5dmFud04v?=
 =?utf-8?B?UisvNE1XeW9wWU01Zk5zbnlqbzFMS0J0emJJejh4ZlMrK3dxbjROeWpvc21J?=
 =?utf-8?B?V3FMVUE3WGNGUGljTmw3cGNIS29NZzZJZ096aW1GMHFscmhqWUlZUEYvNnRG?=
 =?utf-8?B?K3dENnFhRmJYMkJCZ3VMNUp2WlYzK21YQUVGQ1dzdTIxSm5EZGQ3OXlNcWU1?=
 =?utf-8?B?RW1hTVNtWVpVWEkxeDNaV0h3K1pldzRDRnlEMXhFa1J6d2swVHI1c1Z3V1VW?=
 =?utf-8?B?RmYwbEJBejY2VjdYc296bGlXUFA1NTNnOS90elF0K3p4U0ZZZndNM29WM2M4?=
 =?utf-8?B?R1M1K3JRMVZqbGZRTU1JaE9JSkJFQ3hiWmQyTWsvL0Rhb0UrUS9QV1BpUW8v?=
 =?utf-8?B?MDZ0MmlaUFhoUDduZDY4TGRGQWdIWFVPV3hmOTRHaXNUcUJJcVNNYlJzR0x4?=
 =?utf-8?B?U0FWTFhjWTUyY2xiTkpuNDBBeUhGNWtRa2VwdFNQdEJjYm1Ob0VjSytzM1pV?=
 =?utf-8?B?TzFuVFFLWVJUaUF5RTg1bUZRYzdSTGNsdFdUNGcrYk45U2xxOUJ5NDRBandH?=
 =?utf-8?B?NmZ1MzFqQ1RQUTN6SHV3YTFJcGttby9yNWpEVk1mTjFxeWhXTHJwcytkV1A3?=
 =?utf-8?B?c0MrQnJGVitMVExHb2F5cUdmYlpJK0ZlZGJDckNxQml1Q200b0d1TDZGbk1X?=
 =?utf-8?B?M1hnS2tyMmFreE1kSW04dFIvWHNSdFdMZmVydFhvaVZzNklNSUhSS0VQbGl1?=
 =?utf-8?B?Y2pzcmI0b3htZXhiUWhURm9SR2FBLzdlSkJLakNpd0FwU0JBVHRpdkl0aVRn?=
 =?utf-8?B?c1haZXlaSGM4elFDUkIxSjRHVTgrY2MyS2g5cUZEd1BBdmJVUkppMiszVDVQ?=
 =?utf-8?B?VDhFWkNoeUhoeTNCUDR1bUlyMFpNNFlzLzJPVE9tYzFVM3NkNkhYcWNqMzVD?=
 =?utf-8?B?WGpxUDlnM0lDZWRUY0tGbnZ3YXFZbE5XMjFsK2UzVk5wWjZaUWNBdEd0T3pM?=
 =?utf-8?B?UTNYN0xQWlEreEw4WGlQK05JS2RQWnJMdlBmeE9ITEVnd0l3bFBrSk1IcDhv?=
 =?utf-8?B?aTRpZTNCRmVJR3RDeXZ3cHB5SVIvK01hb2UvekFUWU8rQTcwUWJvem9MMXVV?=
 =?utf-8?B?UDROMWJ3TUZBNlNTY0hDL2szWjFwNnRXTmJ0cFdPcVhua3VuRDdTd0ZiSjc4?=
 =?utf-8?B?cWdVc0Z1UUZFeTRmR1orWjJYZXVlUlRJU0xscTNhd1V1VS90eWsvdDgyMEg3?=
 =?utf-8?B?Sk1hakJlc0svMkluV1MxTXJaSk1RUFZEZWYyYVJjNFBLMHkwZ3R2cjJxWDJN?=
 =?utf-8?B?UzUwU3lmWG5Td0VVSWZvSjBuWkxXVTVJTndXV1lQRlQvYlJwY0wyOTdOUm9x?=
 =?utf-8?B?aVZ0ZWlZUEt2VFFoRlY3c3h1Q3RuUnFEVzhGK3huaHozOHF3N2d0eHh2QnVR?=
 =?utf-8?B?Ry9wcG9iVUQvUk5IcnRVam9YM0hQODMyYnR6S3RGVVpXazVFSEh1RFN5Z3Rr?=
 =?utf-8?B?QTJqOU1kb3pZaUI1MzRZVUY4ZGZEZUhpMDhWbjlYUDZ3bnVabjM0eHpUN00w?=
 =?utf-8?B?S01pVGJEUUxpdnM1RStxVmZtSkFkL2xhbWhyQnp4OWEwWFBzdTJwYmRDTUpJ?=
 =?utf-8?B?V3NtS08yQnBoMVByY3poRkJZZllXWGxWZkJuL3NPVkMrcXV5ZHdjcmdCNXZV?=
 =?utf-8?Q?fLrgixnxg8excw6ZfDOsu5w=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WW0xK3NtaTJNeEN6MnJnd0dPckF5ZDJ2TjBhYWdsbVgrSmNKTWh5aThTRXV1?=
 =?utf-8?B?eEorTXVJRnRRLzFvbE1xTlN5dWgrSmhwdTR4ekhQVkw4YndpRkJmb2Z5aWtC?=
 =?utf-8?B?WGpyZWhUVTZSRGNaclMrQWVnSDdGcUphcnd4V2p2OVh4RjlPdVFDNWlsZkl3?=
 =?utf-8?B?RDU1R1ZpL1huN3BndU5EWlQ1S2xaVnVJTTZuWjRYVkNDK1RRNUhxdFR4Qmo3?=
 =?utf-8?B?OGNSVjBKMldadnhGMk93ejY4TWl2b3dIaVJYV2QxMGlJaVQzSTdHWXFWMVY5?=
 =?utf-8?B?aGh0aTF3WllFUXprY2tjQXhKdStiZ2k0WTFEdVNYYTBRd0R0RHpMeXA0MFJ1?=
 =?utf-8?B?a0ZkOHpPWHhsbm9OZXJ3K21tMzZic2oveWNpbGgxSnR2b01PMEN0VVRPRldx?=
 =?utf-8?B?TWoyVThFZnB5WlFjZGMrOXZTSHhOZ2JxZ09IWkp6bThxa041RkN3Tk16U1BC?=
 =?utf-8?B?YlVPZDFxUnhiZEF0ZUFUQkVvZlZEVC9UalYrd1dtQWVTUmc4MEJqTjFVT3FX?=
 =?utf-8?B?TGxIRGlPYmk0MkZOTTA1RFhUQWY5WDdpamRWZi9Uc3I3VnpQWnNFa2VKdTlZ?=
 =?utf-8?B?T2lBRVpsYThwRWFGS1JJbm1zQkpsZ0hmZXY4KzFWMnZ0QU9tSkNocGZLaVFJ?=
 =?utf-8?B?V3JtbHhoQzZhdjBUYzZoUDZBbGkzRGRUVUFjbWxYSC9vSnBmdEpkRmV3ekd1?=
 =?utf-8?B?SVFzeHliOVdXNGt0RktKOGFuWmpJbDViM0lsRGZHbmpQcTJkR0lkMEdmbVJP?=
 =?utf-8?B?TzlyR1RkcWZIM0drRXhTTFFjenNEVmpLVUNuc1NaV2JlZmxxcjNrRk8xMlQ3?=
 =?utf-8?B?c2JiMTMxWHR0ck8wSTNwZzEwSVVTTHBFUXQxOEtSMm95Z2VwTmNRWGt1N0U3?=
 =?utf-8?B?cVVGOGR0WXhvcDFKWnQrVWNCbm0yMWlxeWpVMXR4SjJ0Qlc3R3J4TXBkdDJR?=
 =?utf-8?B?WjhkM0FWQlAzZ1pBY0ZsTmZMbUdVQldCUzgxR1J4WVNTZWE2VVdOVXVrNWo0?=
 =?utf-8?B?dythSDZKOFFsU3V1U1ZtZEh3QXF4ek9QWXpnT2dlUjVpQjQ5T1prSnUxNDJM?=
 =?utf-8?B?U0s4Qis3cE9id29BN0d3UGhtOHh1VVIrcHd5ekFWZWpCMUEyVkt1cjdRRE9C?=
 =?utf-8?B?QzVmbXhsdkhhQnJndFF2REQ3c01OZnJSZ2dJNFVOZCtnM3Y5Q1FJOWpOdVMx?=
 =?utf-8?B?Z0FranB1UUZMRlJWeTB4dmFIRWx0U0UyWmc0RDM4NmlpYUlNanpZMkFXdW0y?=
 =?utf-8?B?WjJ0eklYMXZFY3QrMzhEemlTaythcnJxd1Z5dU4wZmprbVcweVpJeXlRY2ZD?=
 =?utf-8?B?OGFVNmZBMHN3Q1Nxc1BrbllBVlVrUVprKyt5akNyaHFyUjBwYUQ0Ny8yYTd4?=
 =?utf-8?B?VmVjNmc5eTJRUDNvc2tJNEtMQXdRNktCOGZSckw3Y2NOUVRuelN4eTNWZW40?=
 =?utf-8?B?THRkb0FFWkdsbjNpczlWUUk2cE03cFl1TUVvMTAvb25zblJ4MG9HUjd4b2VB?=
 =?utf-8?B?ZW8yV1YzYzBMUzZhcmFVSGdJMUFPREMrcGMwdlk3K1ZxelZ6UTFGdU5nWXZ3?=
 =?utf-8?B?ZnVMaWpETEluUzNHQzd2M0lYNVVPblpBaldWbkVHRnRQYTVjWXgxYlBUUTZP?=
 =?utf-8?B?eGFNdWFuN2lieHFTRzF4Sy9GUVk1dHZHY0tNVEdZb0Zia0U3THhTd09aTTEv?=
 =?utf-8?B?TWROdnZVTE1hUGdlRXAvb2tWbmFvcmtnWkRINENzSzVuVU9yTkQyaUhXa250?=
 =?utf-8?B?cHRPS2ZNVHBkekhKQzg2ODB1L29WQzIzK3g2ZjQ1MU9nL3d6THFSVUdlL1JV?=
 =?utf-8?B?Mk0yblEzWUdqeFlzbGU1RGNydmV5TVRlajkxS1h0WFEzU1RMdDVQSE1yRGdJ?=
 =?utf-8?B?eWc4ckRSUURXYjVuM1hDalBscFBSQVh2TTN1UUVaa0x2UWJXQU9tYzJvRmRS?=
 =?utf-8?B?RWllY0NDczB1RXJnRGJrb1lnZnpYZ3pIV0RyZ3RFYmdRLzlVaVU0NzNRTkFj?=
 =?utf-8?B?MW1remUyVjFla2ZPanNMcHlSWklvbGJjcGtHTnI2bHY5QlRCV3RTRzZCNmpw?=
 =?utf-8?B?Z1BQU3lFNFM2SVYrODEreU0vUzVUZnpELytlZGJ5MDNuZkgyZGRsc0dJLzBJ?=
 =?utf-8?B?eVB4WjZ5ckpIUHdObTE3b1pZUFhkU2VOcENSUm1lMS9JZDV6SzJmOUxEeWdV?=
 =?utf-8?B?U3NhYVc2Qm5GNHRKUWQzUXpSODd2TE1YZHJaa0ZTaTBWd3BGR0wrUkE5ekh2?=
 =?utf-8?B?MUEreDBCUXBJN0pLa29SbXBGSndDdFg0U3d3dFRIWXBxZkZpQWh1c0swN1Z5?=
 =?utf-8?B?R0cxNUhjMlJjdGNycEZIY1VDY3hvRU9OQWdPQmlPUnNRYlloWkFwa1Rnclht?=
 =?utf-8?Q?lWITxuPyk/4IRRF8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A22BADFB58B4EC40BF7DB8F76A6EF8D0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f467dfa2-ead7-4362-720e-08de5fde8bb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 09:04:16.3784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aA6MqMSyN/Jou20AkRxXj0W1fl+qB5Vzbx5KTJoGzTtEJ4Xu1LqzhAhS/X0awpj9U6IuyZ9FCc6L6FGUsZPfBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7537
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDA0OjU0ICswMDAwLCBQby1XZW4gS2FvIHdyb3RlOg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gaW5kZXggMDU3Njc4ZjRjNTBhLi5hYzRkYjg0ODRlZTUgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiBAQCAtMTAyMzYsNiArMTAyMzYsMTUgQEAgc3RhdGljIGludCBfX3Vmc2hjZF93
bF9yZXN1bWUoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgZW51bSB1ZnNfcG1fb3AgcG1fb3ApDQo+
IMKgCWhiYS0+Y2xrX2dhdGluZy5pc19zdXNwZW5kZWQgPSBmYWxzZTsNCj4gwqAJdWZzaGNkX3Jl
bGVhc2UoaGJhKTsNCj4gwqAJaGJhLT5wbV9vcF9pbl9wcm9ncmVzcyA9IGZhbHNlOw0KPiArDQo+
ICsJaWYgKHJldCkgew0KPiArCQkvKiB1ZnNoY2RfcmVzZXRfYW5kX3Jlc3RvcmUoKSBtaWdodCBz
ZXQgaG9zdCB0bw0KPiBVRlNIQ0RfU1RBVEVfRVJST1IgKi8NCj4gKwkJc2NvcGVkX2d1YXJkKHNw
aW5sb2NrX2lycXNhdmUsIGhiYS0+aG9zdC0+aG9zdF9sb2NrKQ0KPiArCQkJaGJhLT51ZnNoY2Rf
c3RhdGUgPSBVRlNIQ0RfU1RBVEVfUkVTRVQ7DQo+ICsNCj4gKwkJdWZzaGNkX2ZvcmNlX2Vycm9y
X3JlY292ZXJ5KGhiYSk7DQo+ICsJfQ0KPiArDQo+IMKgCXJldHVybiByZXQ7DQo+IMKgfQ0KPiDC
oA0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo=
