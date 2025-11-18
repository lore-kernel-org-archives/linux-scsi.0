Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C7F29E11E;
	Tue, 18 Nov 2025 05:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763445362; cv=fail; b=RaWuAMBjL4kzEHWbV+Z9sE3i8Wr075f2RQaU/orkSNzFVS9GJ9RXzooinCYX7kPmnnIY3ZcXl+O3v5021NFBvnd39uCxpj0O5QTieXsMYFEFQEkgo/MHbxAlbQwQ6SfXjjSSc/rm2M87VWXcaMLfSgXuUDEsaPHmt534xsTeqy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763445362; c=relaxed/simple;
	bh=MIDYlTfbK4QSYyvs3RGzHW90hk+bbkq+lIsAzviIqFY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ireZIFyA6VY2yxRj+QTM7cSbDquxSCzkMBz+yhkjYkIhuIE4KzzS/gs/sNkq2sQhahjQVzgwRwkmazpTf1PHeEG5GtGE0rcaIwCWMvRY2I9roydCVfr48x9VWDKrAou3dyouD4Ro7hNFKoI5ZcKMcZdl3+E5UZaBS/x0u7XEljU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=P6WidlTd; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jf07LUJn; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="P6WidlTd";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jf07LUJn"
X-UUID: 3e15461cc44311f08ac0a938fc7cd336-20251118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=MIDYlTfbK4QSYyvs3RGzHW90hk+bbkq+lIsAzviIqFY=;
	b=P6WidlTdtUk7SZWf0AmN9+92xKJBkCwYq0ZgnuE0TXECznwuQZp0RqxQKz/l/0y8uvUvILyrakZBcRBSZbpFogz6sh+9NAzWTt1ACSVMhfpx++9RIu0onf9Z/e4DRuhfeA6jHdhyJOimrQVWV23BQajdNJ+GuyPxtLohlBx8OsQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e6bd965d-c770-4ebb-91d2-b3a066156231,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:ca0ac482-b6af-4b29-9981-6bf838f9504d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3e15461cc44311f08ac0a938fc7cd336-20251118
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1240911591; Tue, 18 Nov 2025 13:55:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 18 Nov 2025 13:55:52 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 18 Nov 2025 13:55:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCC7C2N08UAdhbSXr4cMzoc0OMlpldNAFQ8HhjYKFJwfBTs88sa57rO3HlURJnXc26vdWnBlMg2U6HSt2CJinCrSE9WRYu3Yzy0l4hljNmcZ/5jepo6MNf5meEgaxyvZSH2M+rwJL2riSBi2fMSYHKCDDG4N0sDABzLoqoj7kxZzMDGxKk2H/QgBPYYgKWDeinLDJbRMW35Ns3dloI2p3MRi+C1ROakfH+uXpI0n3NDqC98+fI3N+h1BLErEuhNw/laKMHp9pJKsve4Y7HOL9JEvjvPFwVHCtidpdjn2RSDyAtkKFw7cswiNmNDuL0LC4/s7O1bM3oDJs9IlcP623g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIDYlTfbK4QSYyvs3RGzHW90hk+bbkq+lIsAzviIqFY=;
 b=Pb3g48eoyxjrye7a1hcwZuXbQco+07QpWHZrjL6tMwBAiyy/eLFpRmXX4Wlj5xrWlxW5t0hphES1v9rxGDVEUjZnRdq7lN6fj+++uvTI5k5KFBbRjqUGbr24hVDRGNFn+wn0snruWgwMZg50K6VBhyJFMsvH4BuCV5dGFX+Klx6lpfFGyOJnoe/ZmFTA/LCxtmwKDKcm43hzOS9Icp61tLFN2AbmnUZCsOU9S1aw39CzhMW50UM9a9vqeBAYxy2n6NgIPPX5KeoulCyLrhpU9zcDyGb7wUuYovKXyiAh6e0NNVPLASDQpibODKkJx1cz6FJWfP3mywBGDS+yIlbQqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIDYlTfbK4QSYyvs3RGzHW90hk+bbkq+lIsAzviIqFY=;
 b=jf07LUJnei+zPnKBGtMd5/CLPuqsIjG2IvovM/fTvETn9ddHGCS9WC6bcDe7oRYzArAXB/ratps+fCULPmYhT+EfYJOJ6w7nGE7EnhZPjXmVOpj0HgQww2d31De5Ftl/cl4qT2gcOedtV2L7MhtudsdouaDmaWCMNKWxMleEb5w=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8444.apcprd03.prod.outlook.com (2603:1096:101:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 05:55:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 05:55:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Topic: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAOjIgIABIdaAgAYXzICAAJ+/AIAA3X0A
Date: Tue, 18 Nov 2025 05:55:49 +0000
Message-ID: <a89ccf64710deeadfce9cba08e28867f88463c77.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
	 <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
	 <e3dcb711-990d-4e4e-a128-8a0cd0ce8886@acm.org>
In-Reply-To: <e3dcb711-990d-4e4e-a128-8a0cd0ce8886@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8444:EE_
x-ms-office365-filtering-correlation-id: 328617b1-7291-4e18-dab8-08de26671ffd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SW9MMmJmOWp2UGlTdzVNU051bmhkdHMrUVVBT1B3dmhkWGlSOHRXTmpidE9t?=
 =?utf-8?B?VW5iZTFKNXVUcllrUGNxSlpXRGFiVkVlVHhtMnBXbVVTcWlldnYwV0RRbWFi?=
 =?utf-8?B?SjU5ZWFqRkdSTk5TWk9qbUZLRGh3K2s1ZFY0OEczVzJoblM0U0lsVFl3Tytu?=
 =?utf-8?B?cDNBaHMzODJwb3g0SmVlaWJFbjFOdjVhRE5WZEdhMG5MUmdqdE96SGlvV29Q?=
 =?utf-8?B?cGYwSjNsaTBmczlQNnpSQmdDbTdMUjEycnNQaVVZWUd2b20vTWRNTWI4a2Z2?=
 =?utf-8?B?dC95UjFZYkV6VXpZbUlvaXdWbnZYSDQ5WkRZMUhKTFBNaFJmbllyRHdMbEdR?=
 =?utf-8?B?VnRieWNvNmJsQmRZVGVwcDZuR0VuZnZMM0piODdMNmd2TUdFNGdvR0FXM3kx?=
 =?utf-8?B?YlBuMFdMS2ptc1owbkJWVFRqbUFsb0lPM0dKVkpTZmFObDc1SU1FTWloKzc5?=
 =?utf-8?B?Q1FPM0Zham0xL2lQQjVhS0NQQkxNK2NNR21oRUZnbytIeE1GNGw0Qm11aFVn?=
 =?utf-8?B?ZUpLNEg1djNSdUZRZVNyQ0ZNRi8zUU0zNVU3R1BlT3pIK1R0eXB6U0UrZXhT?=
 =?utf-8?B?ZkNiMk1ZMVZhTk1HRGxucnhIeXN5WWFINUVxR3Y4NkhKZVpwRkZoTmVYZjF6?=
 =?utf-8?B?REFrYkNEdi90QTRDdDhnZVQ4alkzVUZHTWxVNldLL3NQUmw5eUpjZVpMK1R3?=
 =?utf-8?B?Rll2NzdyMExNbU9QQTNrcG0rSmxsZkRBMHdaMlR1RU9EdUlJazFqR0thYXhP?=
 =?utf-8?B?cWtVZ25KN2hPc3JRQ3pYTkphWDNQUGFaZlZhMEFSUjdBOTd0VnlGdDVvR01p?=
 =?utf-8?B?dG5ZcHREdFN3T2F4S3JwcEtoT01jNk82cGowbEx6OGhWazhnZlhvTkdnQ0RY?=
 =?utf-8?B?Y08rNDZTSVh0Sy9ySXNmc0ZQdElqOUNRVndwQm5tbG5OTFF1Z2tvaGNmL1dX?=
 =?utf-8?B?V2FFRHU3c3dNbjdIVXVrYS95a2RpdGl1MXJyQndHMDdlL29Wc3FCTDJlSWZV?=
 =?utf-8?B?MzF4dTlCQVlvT1pLZGxoRlkvamhIT3FReHNYK0lIM1FNUnB0RUZ6S0YyNzF0?=
 =?utf-8?B?ajUxeDdHMDkreThZNWM1WXNuSzlWWmU2aWN1ZXFCZExPbnZjQzU2K2tIRXF5?=
 =?utf-8?B?dEVhNVdRelZoTVh0ODJLckRLN1JobEFvY3M5d3JpSUNWYk55T1RpdGZyUDQx?=
 =?utf-8?B?eFhzejNjVndlM2tBaFpIcnQrWE0zdGFzellDUDlUcVc1TUpHdVVyZHBGeWc3?=
 =?utf-8?B?Y0hldXF2ZEo2Z29sSUUvdWwzZTRBRW1WUkljSWkwbGNQNlp1Y3ZOVGxTVi8w?=
 =?utf-8?B?NDhRS08zR2lQQVgxRk0rOHNXWCtYRzRuME5zcGhGenFxY20rd3I5ckVxbUpk?=
 =?utf-8?B?bldNSms5TlZ0Smd3b2c1aFhoRDFrd3NNUkU2bHFlYlRHTElNMTVrMXFYSDh3?=
 =?utf-8?B?UkZGN3RHSTc3M003Z0hDaTV3MTVxdVE0VmlBS0lDVUUzbzY5YVluUXZWZDVU?=
 =?utf-8?B?dHpSUUx5d2VJNFBXSG5qWU14WjV1czZJaWpTbzdFOG1vck0zMHZOckoyMWgw?=
 =?utf-8?B?ZklJVE1kZVl4aVRQRENKQ3VJaHdXL3dJcjNybGNMSytzb2huWXVsa2pkd3FC?=
 =?utf-8?B?TFhLYVZUd296S2VRMlpjZ2s2bytrd3lFQ2FaNllsYmdUTXFXZmVyOVU3YXhN?=
 =?utf-8?B?VWdYNUZXbTcwN1VOczJ3ZVorQ242S0ZEUnpZY1VtSDNqMUhvaTN1TkpYZEhk?=
 =?utf-8?B?M051WGdvek9UODl6TEdhbmNxWE9BMTRxVUVTRFJObmIzd2lqZnB2YVltdk1J?=
 =?utf-8?B?aVNBUG9BSGZYQVU3TDh5MUhndzVBZk5hT0tiL2x6L0pUc3licUtPcE9lNU5x?=
 =?utf-8?B?OEZCMXN4eVZLb0drOXM5ODM5Wno5YkJmU1E2dmp0aGx5ckdac2tnWGhCc1BF?=
 =?utf-8?B?WDloNk42SXJHWGlVc0pjbmhCcFVoTW41SUMvRHFoU0c1TFZZVWczVGhWRHdr?=
 =?utf-8?B?SEo4OStUNUprekpTTlI3U2NVNlBBTXZab2huM0ZJUytZQXRrYkx3bTVJV0FE?=
 =?utf-8?Q?qFog21?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGtkREFRblBMczNXazhpMUFuTHV3TnQ3Ky82VjNrZzY3TGRLendUYUtDOVpV?=
 =?utf-8?B?WmFOREtRVFEwZTNwaTRGaEw5ZzlVZXpiRTdoL0Z2TEJtY2xBaDJ5QmpienQx?=
 =?utf-8?B?anVhZllnL243MXRLVnBML25VT2tIS0NjekJVNDF1cURpSExTTm05dU5xdmgw?=
 =?utf-8?B?T2IveURrcWtFUWROdjJldG9nVDZUWmdBRDM2Y210aWF2L1dTaXdGdnFhUUdk?=
 =?utf-8?B?SUlrYzQzZmdQb3dic1JURDBUc2FmUkU0YTZ5cXpQWmtRYVU2TFQxTlllNVJO?=
 =?utf-8?B?ZGYxRXdYL3FGa1FRbElEMVIwTU1XRGFEV0x0dFJoWElEWVJmcjJMTXpxek51?=
 =?utf-8?B?QXA0NHR6VmJ2WGFhd0p5R1lJZ2RPZ24xNnFVZXBXdHcyeUI1elN4Z2ZIQzIz?=
 =?utf-8?B?WTZoTjZndTVQdUxRc0s1ZWpZRXU2K1k0cnBuWU85a1pRWUkyQWd2ZHI4Vy94?=
 =?utf-8?B?TU5HaU02MGV6OXFNTm9ndXFjN1lyNkJMT1V5a0IwMlIxNTJSNG9YVFhPbllp?=
 =?utf-8?B?a051R2Q4NDJnMmE0cm16ZURyeC80QVR1TVloMmJGVFB3WXk2ZTdnUm9OM3Nl?=
 =?utf-8?B?Z1FDMEpSdy9KUWRUN3FDelQxbklhUUNpcjJjQStNMDBCS3hHSVpsTUlNUmZa?=
 =?utf-8?B?QWJ1blVXbE1CLzdCNERBY2YvUzRlRU9yQmFjd3Z0T1htUzJ6bE9COXFENHFx?=
 =?utf-8?B?UEl5L0t6T1JTaFA0OHkvUEU1aWQ1bUs0WFNhSVVHQm9pakdqakNvNWFTdzNj?=
 =?utf-8?B?MTdJTElNNlFkaVR6SU1RYlBza0VuTDBjY1dYMis4K2oyN3UyQzZaWjU2WTFM?=
 =?utf-8?B?R1I1NmdYdmVyN3haeDJSZmNVTndGc0t5VHdYdlhJYW1yNEt4L3B3bzBzbk9Z?=
 =?utf-8?B?SXVDVlBvREdxMUE5b0I5dnhIR3NVaTRzbXZFbXVHY0R3ZUc5SWRuSXlxeU1T?=
 =?utf-8?B?Sno1Z2hkbEcwNnNGR05FZEg1VEhLNWYvLy94S0VLZWo4VVJNMXFuVFdNWGdj?=
 =?utf-8?B?Q0prVjdYbnhWd0ZZNElmcHo2OVhiNWhkaVE5VmdCYWNVdThIWmFGVlEwM1BV?=
 =?utf-8?B?QUhtaUZlUGR0VVkwYjR3RXg5alZ0RmhlRHYyK2M2V21BcnpldmRjaFVDekYr?=
 =?utf-8?B?UkxwOWVlbjBkZUVTeG9WZWFqbncrWk9KaDcyNG1Dd3Q0clhMN3JISCtCRG9o?=
 =?utf-8?B?Tlp2NXF6aE12VEJTaU1OT1RWK05Dc3lObC9SK3Y1OGt0MjF2dEh0aVBDVm5I?=
 =?utf-8?B?NEdLTmZzWEZWSGFka3JvbHYxdnRVekpxOXVETDFzU1JoWHN4MkxsQmk2d3V0?=
 =?utf-8?B?U005c0Y0V01TZ0VqSVQvVisvd1B2RFJzUGxlTnpzbi9LdjUwajZQV2F2UWFH?=
 =?utf-8?B?bU9nbnROdUpacWlBZCsvb1RuV1RZNzJwakVicUVlbjJldDl0Z1ZGbDBCVS90?=
 =?utf-8?B?UldHY2o4eHFnNkRQZnA2cnhodlZyb2hoa08xR2hzUkdDVFJQdHdHaW1Ka1Rm?=
 =?utf-8?B?bGVVbGt6WXpiN01pZm4rcE5wVXdiWFR0QzVmSVQzaUJMNUNpeWFjcUdRWkpF?=
 =?utf-8?B?Nk9FNlV1YjdmNGF4dG95ZFB4UldRdGUzb3lCRjNNWHU5UGJLdVhia1BSeXRS?=
 =?utf-8?B?UjdLaHdOVUlzSk1jbjhPMTlxNENKVThHc2hjNFhtSFc5M2J4MlhzQ3JZOG13?=
 =?utf-8?B?SzcvNTRGZWFSRkQwbnNZSHNpOGhhK0xGUzBMMzdTaEZ2ZGtkdDkvclc4T05m?=
 =?utf-8?B?TUxHYis2UzVPVExzcmlWU29pb3loQmpiRnN4RWQ0Y3VMVE1pSDJ1RWtUZHlk?=
 =?utf-8?B?TUJ0ZFhrZkdhcS80dWE2eHF3V0JpTk5mTStqMGg1bHpjdU1CbFdaL1JaS2tU?=
 =?utf-8?B?M0R2T2pRZFkvVGVWZFhhbE9yNmZ5K1hlZ3k3cmlwbWlNcVk1cUtCTEpTSnBU?=
 =?utf-8?B?eTVPMkVObHp2RGtIVUpML2lwMzF0Z3lULzlGQmUyM0ZWWEV4V2dsZ3pWeWhl?=
 =?utf-8?B?dlY5ZVV6YUlFQ2RoNVhhcXFWQzE0T2tHSEQydlJUMlU4cTF6RVlNb1JqaDUw?=
 =?utf-8?B?MFBLUzN4M05CVGdzZ29USDNnZEZValhVRlc4MXphR0ViVUxSdktTdC9PZC83?=
 =?utf-8?B?dUROSXhqdkluR1djM2ZMQWYzZHRhN3N6VjNIamwvYkRWRWFyNUVRalFHNm5G?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE2FA1AFA766E448810EE69F66C2CC4C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328617b1-7291-4e18-dab8-08de26671ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 05:55:49.3017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VfwhPwlW6OvR627VPOM8mQt65wWnBtwGwwi81rMNCykduvmRSo+UmTyXf3nFn/kjY3dPpWvcxXT5X/P9gwZPjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8444

T24gTW9uLCAyMDI1LTExLTE3IGF0IDA4OjQzIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBUaGVyZSBhcmUgbm8gb3RoZXIgU0NTSSBkcml2ZXJzIEkga25vdyBvZiB0aGF0IGhh
dmUgYSByZXRyeSBsb29wDQo+IGFyb3VuZA0KPiB0aGUgY29kZSB0aGF0IHN1Ym1pdHMgdGFzayBt
YW5hZ2VtZW50IGZ1bmN0aW9ucy4gSSBwcm9wb3NlIHRvIHJlZHVjZQ0KPiB0aGUNCj4gcmV0cnkg
Y291bnQgaW4gdGhpcyBmdW5jdGlvbiBmcm9tIDEwMCB0byAxLg0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCg0KSGkgQmFydCBhbmQgU2V1bmdodWksDQoNClNvcnJ5LCBhZnRlciB0aGlua2lu
ZyBpdCB0aHJvdWdoLCB1bmRlciBub3JtYWwgY2lyY3Vtc3RhbmNlcw0KaXQgdXN1YWxseSBvbmx5
IGxvb3BzIG9uY2UsIHNvIGNoYW5naW5nIGl0IHRvIDMwIGlzIGZpbmUuDQpIb3dldmVyLCBpbiBl
eHRyZW1lIGNhc2VzLCBpdOKAmXMgcG9zc2libGUgdGhhdCBhZnRlciBhIDMwLXNlY29uZCANCnRp
bWVvdXQsIHRoZSBkZXZpY2UganVzdCBzZW5kIGEgcmVzcG9uc2UsIGFuZCBhdCB0aGUgc2FtZSB0
aW1lLCANCndoZW4gdGhlIGhvc3QgcmVjZWl2ZXMgdGhlIHJlc3BvbnNlLCB0aGUgSVJRIGlzIHBl
bmRpbmcgYnkgc3lzdGVtLg0KKG90aGVyIGlycSBpcyBleGVjdXRpbmcgb3Igc3Bpbl9sb2NrX2ly
cSwgZXRjKQ0KU28gSSBzdWdnZXN0IG5vdCBjaGFuZ2luZyB0aGlzIHZhbHVlLCBzaW5jZSBpdCBk
b2VzbuKAmXQgYWZmZWN0IA0KdGhlIG5vcm1hbCBleGVjdXRpb24gdGltZS4gQnV0IGluIGV4dHJl
bWUgY2FzZXMsIGl0IGNvdWxkIGluZGVlZCANCmZpeCBhbiBlcnJvci4NCg0KVGhhbmtzDQpQZXRl
cg0KDQo=
