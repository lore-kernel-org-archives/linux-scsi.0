Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CA23093DD;
	Thu, 29 Jan 2026 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769694181; cv=fail; b=JjavsZATMfzL/iskEKFMfeJcQJx0TCtIGSwrXUVsPDNJeJ0ekvsDINFhGs7agmlEN50wDbebxJbKJcOEGfbvzTH2KxHyKjDVtt04cQtFGMQCCSQPlJX8FJijGFBtjIL6fkC3jGZDKMjHWbnMJHP6bEn51C4YukFMh49gBHoIPUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769694181; c=relaxed/simple;
	bh=TPeuaaUkyNriynov2WLAkAlYdbFC9VfKUmUD6uCmZUU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r8MrM/uEC5dN5TCMftssHO8pksgeS9CxYdHm+ApOeIg2NWVAqUrYXn1sG1DK9089IQ/GOT2U4hoGEkxAUB4IYJbGu2TglDfzBpmCmZfLCazhO4Mf3gNpob4sW1RW3CpuVguS4IwlrsBKsytCoPGvuVbp3n29ZJdrJ6MwXS75KFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LNeDIOOn; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=bWrRsmPR; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LNeDIOOn";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="bWrRsmPR"
X-UUID: 67612b40fd1811f085319dbc3099e8fb-20260129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=TPeuaaUkyNriynov2WLAkAlYdbFC9VfKUmUD6uCmZUU=;
	b=LNeDIOOnahMTUXACFF+Ui8xSSCBrfq1w/0SRxpOPIWfWIsj11B9HVwTbH3HMqCHCOnV3vYZJCoaAevH9gP3mcJXVo6owocaqwUqyf/qSx6rZqChpBeGlaDUxLv4nqcUfrCdehAZVc0GgFYlzrdZQ01e++mBUurCHA/tP6EkX4UU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:a5a444bb-4ab2-4850-9aba-fa42b6fb625a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:58c616e9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 67612b40fd1811f085319dbc3099e8fb-20260129
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 512459730; Thu, 29 Jan 2026 21:42:50 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 29 Jan 2026 21:42:49 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 29 Jan 2026 21:42:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZh3iFXyKSNc07S3Kc2cYESWSnKcSbWWvgerLh02lQkTLbWooyoXi9cRnnBN/UPilL0aGcOMOPQ6DBYmZ6HX9ZS8aLt/Cubzb0w6yETyUnu/nYKXhdkmtS0zhs56IA5bijdDZrgIh5isH03XAQjZqH1DJQvoUNevdmNzOr8VGnISkDuxJIPEpq5/Ms7SWFzWU+BU3vrdqk3TpLVytY2DhKhFnLSGYJWkt6ylj50SW298gkPv8uDTgx7d7oweAZDps8V6euAKjGeZS9zyHGKxHycAThn9Nu+xCoUj9YNpgTS1ynuIEjGWyIu7bRHFJWHw+2KT8V+4LyiecxV770Iq0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPeuaaUkyNriynov2WLAkAlYdbFC9VfKUmUD6uCmZUU=;
 b=cCpjiZ68uGTLyvMBDGp9qEZPlrQc583wCbianALOOb8ykuSSsactRGpwBhl2NMWF9lOrJgTemZeH3Zo4Ztyw5ctkwqToox6xZ8WpjwO/Nz+DOnXSIrP1h5dvBg6Uibzh0T2haa+qHO/pFbF5XyzvolwQ7w7E5rEnn8ukFGsZT3HnTsLdOZpPkF28qYcJ+5iPHzUJeYZe9K39Q1DV08AwRDVQDfyw+7Z5oQWNdnld3GzwhOuLJHYsljBKbwQ0luvP1EjxpXT0cd9PFnLTxOpkitaU2BrC1AG9kBeZ3ZvKCtL7/RCDGQCE3nNpfdHnGfrVqHCevqtwqBdwu8TIlOmf1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPeuaaUkyNriynov2WLAkAlYdbFC9VfKUmUD6uCmZUU=;
 b=bWrRsmPR/SEh89JBVZ9jBVgIL+HqnTIxrRe3m6VUw0amTPiLRrIBiBoyrpHGIxYLiYOUI/LfxKnUN98WXhGFsmg4cwch5T17d/CrZhzcOuClEw8mbWM/KzhHfbVENGHt0xPSlp91+BbjFek4Bb/xWlcORieIDw7SMTXkY93/A2c=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8286.apcprd03.prod.outlook.com (2603:1096:820:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 13:42:45 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 13:42:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "thomasyen@google.com" <thomasyen@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
Thread-Topic: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
Thread-Index: AQHckO4DHn7o7tsqMUqo0R+jIL1dq7VpKG4A
Date: Thu, 29 Jan 2026 13:42:45 +0000
Message-ID: <f0c22fa51bd46aa0af8321df508c14ae7d41fcea.camel@mediatek.com>
References: <20260129070657.678532-1-thomasyen@google.com>
In-Reply-To: <20260129070657.678532-1-thomasyen@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8286:EE_
x-ms-office365-filtering-correlation-id: 3a1edeb6-f945-45e8-ec05-08de5f3c48a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZjhaWkt0UzBHT3hpZ0N6YWFPUFBmNjNTd0dXcGhtaHJOVlhDTTNKZVZMMlB2?=
 =?utf-8?B?bmM1QUp2dGp6Qjl5UEJqR0RjWkVpcEhBSURGTDJ4ZHFpUWV1WEl3b2VYdExV?=
 =?utf-8?B?OGllV2F0d2lITDlaMTNabVZZSDBETjZVenREMTMxcEdaK2dXd3lBN1psVFZI?=
 =?utf-8?B?eSt4dTd5SHJRT3VaWXFWOFVROWxxSmRmRVl5M01hQzVJY0R6N0RzQW5COFpj?=
 =?utf-8?B?bnJLVTQvWlpGbDJpWUlCbUlFclEvM2hVQXZ5ak96Vm5NV0lRSms3SEthbjlD?=
 =?utf-8?B?VWtPSmZBVXdsdkVMQ0UxcjFlSDg2ZXVHR1dEa2V3QlZQcFl6SzdDVHJTUlZD?=
 =?utf-8?B?dWdiMXRTYUEyT1UyUUFocndrZGZzM0RqL0FsUHNtY2dtbnNPdzkycmE1bjIr?=
 =?utf-8?B?emJ1NVZEZmlUQlpIRUoyUWFIT1pMbnlpTmZQVCtHYUJLVHhycFdselQ3dksx?=
 =?utf-8?B?U1Z0NnRIM1hGajMyaU5VWUw4NkNaaXowNjFoSFJHUGh3Mk5nNmlDSVNIU3Iz?=
 =?utf-8?B?NC9XR0JDWE1iWTJJVUR6NWMvcDR3R1FNTG5SUHcyNzQ3OFhsODUrZkR1dTVs?=
 =?utf-8?B?UTloczBKeHh3RVp3RXV4amFSZGQrcWczaTUzRWdoSXZ1U0ZHZGtYYmVlQlFa?=
 =?utf-8?B?UVpKNGdSRUlKS3JjckNoV0lQbGNlMENYQmVua3JoNWVlVlA5T1ZHZVpMY1Jy?=
 =?utf-8?B?NmFXaGZnejRCZklMODNLam1VdDhqVmRQUDk0QXBYNTM3RGlPNXVJSzF5eXZL?=
 =?utf-8?B?ck0xTTJmVDZhT1JZWGdtZkUxWjY4QlBNUW9sMlAxWjZQZGVFMWdjWEdwK1VB?=
 =?utf-8?B?bFFPcnZ3Y1U1dGRmZ01UWDJZT0g0OTFTZDRnWDI3V0p2bVBkN0IrS2lteDFh?=
 =?utf-8?B?ZTI1SjFvRStjT3o4UHk1ZUxnOCtHNDRnd3ppUHZsaFROSnkybUZNTzNvTGpJ?=
 =?utf-8?B?VjRyeGxnSVI3bTNQM0x5dlB2VitXeTJ1a0VqazlUd2NRVGgwdmwwWGUxWGxm?=
 =?utf-8?B?ZW80dVBGak83YjdtRmdNWlhBWHk4OUZzd1lscDZ3ZGN6RnZGWTltSjZnNGY0?=
 =?utf-8?B?WERNTTVqa1YwSFNrV3RhOXMvZXJBM3E3NmlKanowY0VoRm0xaHNyU1o5NFJQ?=
 =?utf-8?B?RVhuWm1kT0t5MFJCNFBDc0RTYS9IL0pKK3JSd3BrVUFMZHBheTZyRktzUjQ3?=
 =?utf-8?B?ZnIxdWlxWXA5eGpMczkvc2U4WkZKa09kSFpUTkMvWTZUSGNIQTRZL0ZCUUpD?=
 =?utf-8?B?RVk4Yy8wTlFWSUZBOFdYTHhxZ2thamVOdy9WMHVud1JIRjJUNCtTVlBod3l1?=
 =?utf-8?B?U1ZIVzRvVjUvd0dFMFRVUXNyVElSRExjcEZ6RWZsQ0E0OEwyY0k2Y2tLNDFI?=
 =?utf-8?B?WkVtWmxUeWJ4ZHF4bmZ0MEhDWjlxS3g1ckdpS3NXV3Aybmk2SmxNQUFzQzVi?=
 =?utf-8?B?VCtFS0NQMkhpU045emdoREJyNDlNTGxiOUhNWnMycHc4cVFiU25UVnRZNEJz?=
 =?utf-8?B?S2l3SHNqZVkrd0xMMVR2U0NPZk5DT1g0M3VKY0dsZUxyazBiaTFyZmV0SS83?=
 =?utf-8?B?UHBYMlp2bXluaDdGNUc0ZThyQmh0QW5mRmZ1M0F1VTNtczFINGlGR3oyMk1v?=
 =?utf-8?B?cmpMTTZSbjdRWGxYOFZaaUFDL3gwOENEZTM3a05wUHRiYlZBRDB3REU5MjV2?=
 =?utf-8?B?RmJhVy9qSk5DNklQM3lySlJyVFFiQ0o5UFRDYi96SVgyeDFCQ2gyQkJsMTVh?=
 =?utf-8?B?YTFOV09pU1EydlRpbHEyZGF0NjM0VTRQd0g0K0pEWjdtNXRURXZGZHNQL25u?=
 =?utf-8?B?bHplY21INGZFeHIybTAzcERTUmh1dHZPYkp0YnVhOXhrU2JqaWs0NlM4UmR0?=
 =?utf-8?B?bjBwTjlOWGM1eFpLTEhZUkFnOVlNTTVxT2dZMjFTT1U4TlV5VmZ4ZTVCelJj?=
 =?utf-8?B?dFNmTkRqeEUwZnhoU0tMK2szdmRQeEp1Y1Z1Y3JQL2ROYU5uVE5FT29NcFVp?=
 =?utf-8?B?MEdKNGwwbjAzZytPdnJpdDJoQmxoUUI1aDl6OUdzaVZ2Q1NOdHNqYVg0NFMy?=
 =?utf-8?B?RkdmTXBOYWFuQjBEYjZLWC9MRzJ3TFZFbE1wbndxZnBvbm5MVWdBZ0lZZmx6?=
 =?utf-8?B?YXRVdmV0OWdFc0NYNUMrejRKZ1VrZWJDeEk5Y0JoalB2RGFDell0RHpNOWdF?=
 =?utf-8?Q?N+BBZ65zuoePe/uCpDQBU4Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azZJMmRWVkpwalROZFVnTWdpNy9zZGQ1SmNnaEtXRFc5aTlGVS9oMXZHc1hT?=
 =?utf-8?B?S3ZFaXBkVlRkajlnaDBKV1lKSElCQ1lwQ0swWkdzOVhLWHRSZkszNExyVEEr?=
 =?utf-8?B?cHVBZ1VNMFhhSmdYeUwvNzNKdnlUeFp2R3FreS9tUGptSnBta2lKekhCaVpT?=
 =?utf-8?B?dVVweG1OdGRSM1JERnRvNHF6N1pLam9qSlBqRWcyY0NZWWNzUm5KQXhnVDlt?=
 =?utf-8?B?azlmb0NTcTVPeFZmZ3ZwYkxpQzVoVU5pRlcxcEpRWURUOTdPS0duOG9IRE5z?=
 =?utf-8?B?NGJsM0EwTVp0WWt2VUJ0Y2RBNEEwUzVWOUxFZUdSZm04TU0vNWhBOFNIZ0pX?=
 =?utf-8?B?ck1rRUFhWER6UTk5WThYSU5UNjc1bVcvanJPdUVPdExlU1hKVWZ4UElYSEw0?=
 =?utf-8?B?K0YrLytzUmpVTFhXV2NJRW5OTW91ZHNmQUZ6cFUrSjMwREF6Wi9nbzZNbFZq?=
 =?utf-8?B?ZU4rdVRLT3dNL3JzK3RDMDNIYm0rTXNHQVZjZmRsK29oYU84STd4MTNVcXVI?=
 =?utf-8?B?TmJRa1cwMWFYMzRkQlkrU0x5SzZ0VjVTM01zTTR5SUpOQXYrZTQ3TkduK1I2?=
 =?utf-8?B?Y2dxWm84V2wzV2VURVNYWkx1NklRTndmSGV1T0hUK2NmZ1ZkQkxvSVBhamgr?=
 =?utf-8?B?Rlkva1BKVUJ4VHJXTmRKREcyU1NCeHl5ZjE2azduaE5IQ0gyMTNBMmF3enFj?=
 =?utf-8?B?NHZEQyt0b0VienM5SVNVMlBwOU8rL2o3Z1pNVGZaUmg1QXhuYVlkSzRYVGhW?=
 =?utf-8?B?cmNRT0tUaGJUdFlJd1NDRGFIeWpmZml4MWlUamFlR2JhSlkrMkVVMTYyQk9W?=
 =?utf-8?B?MU1aOGROQlNiL3hJQ2tzdUNpZC91dlhLTW9Ebno3QjgvaloxRGhTNzMwaG51?=
 =?utf-8?B?ZDlCYjJubk95bTUzZnM3WmNNeGdLdlZ4b1c3ZFd0c3FuL2JUR3czZWptWkly?=
 =?utf-8?B?cXJrb2NtTzJLaEYyOXNJV05obGNQdWxxSnZ5VnhqTTd6K2pqb0M3SGMrL2hF?=
 =?utf-8?B?bWFIVkdoT2hSdTgyZEZpMGFEaURuN3gwOU9uVXEvcDZWdHptbVdwSlhVMFQ4?=
 =?utf-8?B?TkNQRkwwaEVWY292WHNFZ1Q2U1hrZVlnbmZBK3dkTlBiQkJDN2tFYThMMjRi?=
 =?utf-8?B?RExUWnNIc01MSVVqT3ljRjFTS2svWEpqd2RjUE5PbzI5WVZYUXdMUUU5L2JV?=
 =?utf-8?B?bVhBNHltRG9IMEZ1cTZPdko4WnBySXZiOVVYYUw5dkxSMDZvQVhYcTZGaUxS?=
 =?utf-8?B?R0o5amJZYm1GcVA3Y1lSS2xvVTRyN29PZ0xlUlZ2VFB6V0srSnUwdnJKN1Jr?=
 =?utf-8?B?MGxJNVJJbFJoNWxyV2tzN3BDdnFuNVNNQVNML0NHV1BtVTUrMnNnZFh1akU0?=
 =?utf-8?B?OElwNVVCV205bUVUbk1FQWxoazAwSVVSUDYyZm05bkNMQUMzbEE1eW1nQ3hh?=
 =?utf-8?B?SmQwd05SelUyYnhTNnA1ekZzRWdBd25nMkJYOUM2YjJ3aU01SFBuQklUZDhQ?=
 =?utf-8?B?MThuRkVFOVpNTlhsb1ZKV1FUNjZla3F4elpseDB1a05sdEpBZ2YyZWdNc252?=
 =?utf-8?B?Y2N6MFAvd3gvNmpQUkRzVVdiVXowSmhRTVRZNXgvSHJwYVdZNjM4SzVqbWhK?=
 =?utf-8?B?emcxeUdoN2g3czFib1k0anUrU2ZyTklNSEZjZTA2enM3NExwZmZVL0dlbStG?=
 =?utf-8?B?NDd4T0YrR3Vha3JrR2h0a2NUc2dDblE3bndkak1kWUZpbDZoSCtac2kwb0tK?=
 =?utf-8?B?SFpXdFY3ajI5Yitmd2czN2RvMTZJcmNUdnhCdnR5UmVvcHY1NURkMlhnK0ZH?=
 =?utf-8?B?R3hlamNKQnlramh1SkM5VHpiVzhnZThGN0dBY3JEajNEc3RjSVBmWWEya2hw?=
 =?utf-8?B?aHI3UnpONXhpVzYreXhrQWo3NTJ5b1R3MHp0aVNzVnhYY0tQd0VDeUhXVzM1?=
 =?utf-8?B?NUZ2dzltRnN3bkxzdWhXMTAzbW52V0g3dGw0dXZJK05VeTVGRU9FYnBmOEV6?=
 =?utf-8?B?WmdnRzJKWmc5cERhSXR2U1Fob3dDRFRackMxOGZKL3JuWnY5TzRyQjUxOHZT?=
 =?utf-8?B?Q1NISlFsUmlXUDZuTzlla0Y4Rkp4a0hSVEtWcExxWjVOUkF1WE10ZzlqSlRo?=
 =?utf-8?B?dHVoR0VMY1hZYkJaUU52OEl2TzFZL1NiRHRrMENlc3VReDQvK0s3UFl0NFU3?=
 =?utf-8?B?ZjRaYnl2cU9WM3paNGZIaUs3ckNnTXRkR1Y2OGxWenpOWWFkdHRHZTdtSHhw?=
 =?utf-8?B?Zkt0VXlkNGxvbjIvYXI4ZUloRnBtWjhhUlR2OW5oMjhQUTlsR0tWdm5zd25C?=
 =?utf-8?B?MG8zOFFETmFVc1V5ZmtndW9tN2dmelc3a3gyUU12Y0ltdWVHZDEzVGdzU29V?=
 =?utf-8?Q?NgIw7cTkAXwdVnW8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <401091EDCD19A542B7DC44FAAACC625A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1edeb6-f945-45e8-ec05-08de5f3c48a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 13:42:45.4583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZyKMFmEJAbE2obcq1r6rjRkB4zvAI2lQyQ6a+/yIxNGS7xYzHZnkfcDtCRpHVTyX0l22RZrLwEJPyPgp5C4nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8286
X-MTK: N

T24gVGh1LCAyMDI2LTAxLTI5IGF0IDE1OjA2ICswODAwLCBUaG9tYXMgWWVuIHdyb3RlOg0KPiBF
bnN1cmUgdGhhdCB0aGUgZXhjZXB0aW9uIGV2ZW50IGhhbmRsaW5nIHdvcmsgaXMgZXhwbGljaXRs
eSBmbHVzaGVkDQo+IGR1cmluZyBzdXNwZW5kIHdoZW4gdGhlIHJ1bnRpbWUgcG93ZXIgbWFuYWdl
bWVudCBsZXZlbCBpcyBzZXQgdG8NCj4gVUZTX1BNX0xWTF8wLg0KPiANCj4gV2hlbiB0aGUgUlBN
IGxldmVsIGlzIHplcm8sIHRoZSBkZXZpY2UgcG93ZXIgbW9kZSBhbmQgbGluayBzdGF0ZSBib3Ro
DQo+IHJlbWFpbiBhY3RpdmUuIFByZXZpb3VzbHksIHRoZSBVRlMgY29yZSBkcml2ZXIgYnlwYXNz
ZWQgZmx1c2hpbmcNCj4gZXhjZXB0aW9uIGV2ZW50IGhhbmRsaW5nIGpvYnMgaW4gdGhpcyBjb25m
aWd1cmF0aW9uLiBUaGlzIGNyZWF0ZWQgYQ0KPiByYWNlDQo+IGNvbmRpdGlvbiB3aGVyZSB0aGUg
ZHJpdmVyIGNvdWxkIGF0dGVtcHQgdG8gYWNjZXNzIHRoZSBob3N0DQo+IGNvbnRyb2xsZXINCj4g
dG8gaGFuZGxlIGFuIGV4Y2VwdGlvbiBhZnRlciB0aGUgc3lzdGVtIGhhZCBhbHJlYWR5IGVudGVy
ZWQgYSBkZWVwDQo+IHBvd2VyLWRvd24gc3RhdGUsIHJlc3VsdGluZyBpbiBhIHN5c3RlbSBjcmFz
aC4NCj4gDQo+IEV4cGxpY2l0bHkgZmx1c2ggdGhpcyB3b3JrIGFuZCBkaXNhYmxlIGF1dG8gQktP
UHMgYmVmb3JlIHRoZSBzdXNwZW5kDQo+IGNhbGxiYWNrIHByb2NlZWRzLiBUaGlzIGd1YXJhbnRl
ZXMgdGhhdCBwZW5kaW5nIGV4Y2VwdGlvbiB0YXNrcw0KPiBjb21wbGV0ZQ0KPiBhbmQgcHJldmVu
dHMgaWxsZWdhbCBoYXJkd2FyZSBhY2Nlc3MgZHVyaW5nIHRoZSBwb3dlci1kb3duIHNlcXVlbmNl
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVGhvbWFzIFllbiA8dGhvbWFzeWVuQGdvb2dsZS5jb20+
DQo+IENjOiBTdGFibGUgVHJlZSA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gLS0tDQoNCg0K
UmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
