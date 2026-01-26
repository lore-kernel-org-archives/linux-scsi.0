Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB732DB7B1;
	Mon, 26 Jan 2026 03:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769398972; cv=fail; b=LItbb0smajWcHGn0vhxjcNBREUVE4LY6Bq/0iGO6dRUvKa7IbHWzIFQ61HP1PA5xiodYuyTzFmQV4ILC8jx1usQYueRMhzhmHWtFVngX01dXui1IoT/GmURa3sbJb7s9RVLPJw164f0SG7prVGWYpRxRR4aSlHAZ71tbZvDK5No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769398972; c=relaxed/simple;
	bh=8yL/BhmbLIZbrKMrG7afRL0+n03IRpc54w8+hzYsq+Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RiQtojHn5AEBJmyJtfK0NnUg/CD5L8KQ8GMOxaMe/8ivBsVMKQi7orR4FyDkYJRIZC0ykl0F239lXA8TDiu/qLJVOEBiZ07LYBBtqywqNyM/zXclgk+xP9nm3ujJTcE7dapUeC6QaAheIjVIbkEZSNP06CXr7VBR82Ze9em/38U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rIXcWFU7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RsXkI+o0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rIXcWFU7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RsXkI+o0"
X-UUID: 0ad52f9afa6911f085319dbc3099e8fb-20260126
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8yL/BhmbLIZbrKMrG7afRL0+n03IRpc54w8+hzYsq+Q=;
	b=rIXcWFU7GrrFUbDKZrt7StCuJeexAKaULYf0YpMBPiqtTa5TK7yYKt76hcpPPUT1FiXhR7dywxo0O14kjA7Z0x1PjHBB7bv1suskidkPCv4u7mbrpqnjbxGsK+EQLxJA7/AY3dK455fOUIJSkS1ClNOAqfvD5x0rnYHb1VGGodo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:707d28d7-574f-4f0e-ac90-95d9d6025920,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:8682efe8-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0ad52f9afa6911f085319dbc3099e8fb-20260126
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1688000780; Mon, 26 Jan 2026 11:42:30 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 26 Jan 2026 11:42:29 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 26 Jan 2026 11:42:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EOPI98NVPRRxE69iJ001I0bhuMSa23t2x1/ZeqaxVWY9tpDWM0GlPcoQIGs6BLrOQClAvVWfWkUDYYix9MrF3Pdada9r8FOhMycfAOL6z38Va2ZtvrSNn4x1RV0jUWUvxtt5fCjuPcv2qrNdKNZ3eAzg1w3YrEIEoJNQGNxYe3NkKop9Iaxa0UxIDjormI4UhwjWfDIPPCKVlmnBFEBuQ3dd0e2ZW983BloIghrw7IClnd+4kAeijShIwVgL1acZDF5rli6RAoOZ5jh6EQyLijMqwXIuylQ6O+5Z5mrLIIu2VUkpp+drBe3/PMKUBLnuRDwv4vLkxYaTlMXKJcS9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yL/BhmbLIZbrKMrG7afRL0+n03IRpc54w8+hzYsq+Q=;
 b=Qs6QILBwAtRGhOuTuZu/kI1Y48LRmvi/lSeH+gG82PNWIHKZwfBmmv+w1rMlXuNCrdjo9PYu1H9lE/thU7bsg7ZFblx002w6Bo+v3Dba73osgjvqkU8/RL/3xC6bSapLAB/jqPt+ux/KRnUU+VdQgBVzJRnU33g1/u5/3K/iA288S5FO7S+I5KwUAFsLAW7cFT8ZI4xCEYQUooEqggO6So+/5iNYRvyM1buI5JDfKosQ4bccMu7Ut14tQniAEcrv+yWJAEQJZ+vnysQ4f+KmdTvN5vtgx3pmUo14/gJrBZh8HrlDvEcbsR4MxGzrLWS3ppnxs1vrkfHS6djG9SyURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yL/BhmbLIZbrKMrG7afRL0+n03IRpc54w8+hzYsq+Q=;
 b=RsXkI+o0mwVyYZcGLNucey46dtlXxVHnPTMnVgbaAcGoLqhff2BBXqhhJhRn69sRyD5jwuIpfQBWn58hrdVX4fAT1sLvzZp6RsR3sXWDhTp8B8Ficm8ytuJOlE9xAIKXJ5CrPGaDPn4SlRIILOxCPnB+BL+Q/DCcdO7uzF58Abs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7785.apcprd03.prod.outlook.com (2603:1096:990:10::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Mon, 26 Jan
 2026 03:42:26 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 03:42:26 +0000
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
Thread-Index: AQHcjDORziQV2W7w4kStKvWNtrcTVrVj0yuA
Date: Mon, 26 Jan 2026 03:42:26 +0000
Message-ID: <99f7a432182123d3bf38e5183cbb18457288b602.camel@mediatek.com>
References: <20260123045504.3507948-1-powenkao@google.com>
In-Reply-To: <20260123045504.3507948-1-powenkao@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7785:EE_
x-ms-office365-filtering-correlation-id: b8182218-8916-4e4c-34d2-08de5c8cec45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aWlnTWlUL2V0cW5PaXhqWlZvM0swVktPc0dxdEtmUEcvKzhIQTlBUm5mOWpE?=
 =?utf-8?B?SXkwVnZGYm9UaEZ4MHA4bGw3Y2hpUktvWnkvNXFUQ0ZTMmNRUExsdW16RmV5?=
 =?utf-8?B?WTBFdEI1WUg4b1ljTDExNzJreHBxcHVUeHhJVjNIU1lLa3lYNExFQWRDNXpa?=
 =?utf-8?B?UE1EbjQycnRJdmRHMGlvQThBbVY0VEtUSnAySVJJaEVDdHJMbzkzdHY0cUVj?=
 =?utf-8?B?bmtoa2w0OEpQVCs1YW5aUFkrYzhSOVVoOEphUUVkbXdZZUM5bDdxRXpka2Ev?=
 =?utf-8?B?OElONUEyZC9FODFnV09SeGczdUZvMisrUGlUQ3NjWEZxektxNS9tbjZDaXha?=
 =?utf-8?B?TmY2a2JDZ25ZcFpoQk0xTzRXT21UTHFGMFZFQXpnOU9XUVlSOWtPUWx1Sktq?=
 =?utf-8?B?NG9rTTlXNnRubUU1emx0M0p0UzFyb254YTlFU3pRMXVBNm8vN2RqWXRsTkw5?=
 =?utf-8?B?TkhHWlN5WEhWcUlXNy9RKzRZL1BMMXdya09aSGd2UXZiWnNJdlR5em1QdXp0?=
 =?utf-8?B?bGFQQmNtQ3BlRGp2U3JFUFI1ckk5Z3JXa3NCUDZmNnVTY1RvZ3FkT2c3UlNl?=
 =?utf-8?B?Z01RYUxlc2U5b2VYSC9seVpHcVQ0eTU0aEhoQmVOTGlhMnpUWndvUmhOaDVU?=
 =?utf-8?B?WXFjbzdYdlRmMTBhWnJHSS9sR1lzeEZ4dlppbTY3MzBBaGtyeEt1UUl5eU5S?=
 =?utf-8?B?bkFBUEpSSzQwMElSdS9yNGhsV3JIdE5sVkVsTE0ycUg3ZzdyNStTKzVCd3pF?=
 =?utf-8?B?elUvdU1HMWVwaVp5VFlwa3B4aU5rdk5oMkVDdlo1b1FwLzZQODhZSURIUFBP?=
 =?utf-8?B?bTVGd2VodHEwc2hVVnNmRkhzY2ZtUnV5bGtLL3lOUW1TZU5qTWZHVW5ETmFS?=
 =?utf-8?B?RGpDWGtXRStGSnZPbHhiTzRLMGE3cGRIaC9mQWtsdUpWVFJsS3ppNjZWcWw5?=
 =?utf-8?B?Ukx2cGFUWFZmakF3NUZvQ1RvZEpjNStabDluNG9iUDBYS21qb2RGcW9DNHBJ?=
 =?utf-8?B?ZG9GUlJqYUkwejFWUkY1OTJHcGdDSGhqSXk5ajFkYWFrNS9SS1RSYmtQOWFZ?=
 =?utf-8?B?R25yZURDQ3FvRGFEU3QyY0lIWmRjcEViZUZUMDBmKy9zVnNqWUhLUTd4cjRa?=
 =?utf-8?B?SzRYKzUwbkN3OCtza0s0aTU5ZWk4cUtRT2x1dGFnUTZSbXVxak5mVE15Qy9C?=
 =?utf-8?B?cDRVOUgwaWFpenZmN2VjckNFVDQrcHJqSTh3MzRZWjNFU0JkMy9xM2kvZy9Y?=
 =?utf-8?B?ajdkWGFUZ3Y3UmhOQWdKR0ZwWkRUSmVqSVRReStqTnN1SFhFdk5wODFhbWFM?=
 =?utf-8?B?MmJHM1BHR050QmJPcWNoZ00xMy8wb1JST2YzaGpSN2lmWmc0Q1hQTHIzTERD?=
 =?utf-8?B?czZyRUk5clVxTWxOT0F2eWhXbWJrVXR0ODdJbXRGWTduNEF3d0dPU1dhell2?=
 =?utf-8?B?SkJRb214bXgwbkJxdmF6OFZwODdBTEZZVlFVVUFrc0hReUZtbVBmVEpPdCti?=
 =?utf-8?B?dElLSWlRMkdhT1VkMUc4UDlQaFIyOFRUcnhzZkt0RHNmYkNrVFQ0Ym13ZlZD?=
 =?utf-8?B?dnFzVXhXVExVbXVxUGpXL0w1TjBQaWhOQ2Z6NlErV3o5V1cvZFJDcW5WZGlB?=
 =?utf-8?B?d3hQTjdVbkJPdHIvWHdhcGJOc0xzNlMzMmtSaHgrcm1EZnIvQ3htQldGRVQ0?=
 =?utf-8?B?R0xxMmpiUjE2SHJvaTkyUFJMS0lZalZRWWNwMmZJMlVWMWI1V3hLeFlIRWd4?=
 =?utf-8?B?cXAwR1YybmE5aWtab096QjNOdU5EajNjM1o3VHU2K3duUStBMmR2cXRLSUxY?=
 =?utf-8?B?VGFFMEFUM25HdWxPZXhoK2dGSjdaRlFEUXFrUG5wWDBtWXNWQTdPelBLTkhT?=
 =?utf-8?B?YnZ0NzF4RU5meE1sdnZRM1V0cXFLcTRNSTRZOXhJS1FCc2pQL01kY1NuZklz?=
 =?utf-8?B?akJlSkNiY2pHTmdodjVNMXdqcDJ2UzlEdUlMejd1ZUs0ei9IVHR4NSs4cXlG?=
 =?utf-8?B?ZVpUMEFoUVNVeDZVVW9QMndnUWtaT3JKR1RoeWlwOGJXdmkxektZRlRjeWEw?=
 =?utf-8?B?UzRLQjZTeFdNNXYwR29paXB2L1JjNTR0VUNKK2hSU2ZUUTF5aDYybVAzb1lQ?=
 =?utf-8?B?dytMaXJleWM4OFhpL3lKc3UwTTk3OU5zTkR4eVdnWCtOTVBWNUlkcEhYWjZt?=
 =?utf-8?Q?g67B9FIUM7dim6I4aTDJo4Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0FKcXNBandzKzAxWHdycVgxaFFVbWxNMmdCUVgvSEZNaVoreXBlM3MwT3hI?=
 =?utf-8?B?V1J0eE5JdWZEUkhMVVduWmRFSnI3b2dwakNBNitaRk5IV3ErNGhtVC9GNm1x?=
 =?utf-8?B?UnRrejVKcmQ0Z1RXSGxXRjl1RzlRbWovWGw4ck9HZXZiQ08yYkNtNUdTM2hJ?=
 =?utf-8?B?bFEzSk40YmZGdEc5U29jTmVKUEhRUTVycjFQTHBYM1UyM1hxVzNSTTcrcnVF?=
 =?utf-8?B?eU1LRXptdGNqMGtvdmQwNkl2eVhVVEhOL1NjbTlCZnd4MWtScE1rVmpYTUtp?=
 =?utf-8?B?YkhJTVhEbHBwbXdtQ3d0VHJzUjBMc0JlS05sZ3o5Q1NCVENManZPUVk0TG1J?=
 =?utf-8?B?M2l1K0RreUNEdCtNcHl3VVVaTFJBMnI1aDRkcGdhdnNZd2RtZG5ia1pmTlVQ?=
 =?utf-8?B?ajJFRzRFbjVES0NjYkhwYlI4WTh5Z0lqelRNaFJ4UStqZmF3WFo5dW0wYkNz?=
 =?utf-8?B?enNkRU84cThvUHRXc01QVnh3UXZXSDhNcTI1dGRsd0NFZUtla25BSU1QYVVX?=
 =?utf-8?B?c05KNFZialYxRlB1WXd4YTdRbTNvSjJhUStDTktjT0FEN2FWS21vWDd1Ymo0?=
 =?utf-8?B?eGloaUNvemZqaGV0NEcyTXcwMWRKQUk3bmxEVzZaWVNlWXFkZ3EvbE9BbHpO?=
 =?utf-8?B?Q01QMkZJUkFtWFRmRVRod2ZPT2plUG01RHdRYXlEa3Yrbk9Pckp5Z0hIYU1n?=
 =?utf-8?B?Mk8rZ0FNOHNoWkMwaE5WZFMrQXVOZTZrUG9IVEl6K2ZFZzR3ZnNYc3N6Zi93?=
 =?utf-8?B?MEtIUFBWeGxOSjV4RXhrbnlORm9KRHU1NjRESUFLVWNXOGdoNUcrdzVnSEtl?=
 =?utf-8?B?dDZvT2VxNk1GOThwbEJRWjg3NXAzVnhPT3phc1RSM0c0dTFKdWhqQkE3dTRa?=
 =?utf-8?B?VnIzN3RTTnNEdmRCSnN5OHlUMm90U2tJWmpnaThmcFZIdndTNnFWUzhFOE0z?=
 =?utf-8?B?bkdURndVTUoyZlpxcmlBR2lOdHprbDJYdEYvS3RYYitDbjRPVlUwd2pHMjRu?=
 =?utf-8?B?eFJHeTlEdGFueUJGbWFvYXVPTEFsRk1PaG85QURmY1ZlL05CUEdEOUV2bnZP?=
 =?utf-8?B?R3ZCV1lqeWJNb1JkZ08xald4V3RETWJFTkt0MjNsdnhtTW01dHdLSmpiRmhi?=
 =?utf-8?B?M1ptQ3Q4NzY0eHFhcm9YNHZLKzFWNWQzeTF6ODE5bjlCOEcxMEdQYzgyYnhz?=
 =?utf-8?B?eTk3NEVwWGFhNWJMd3c5MzFzMm5CaDgrM2lTcGJVRGlWc2IvSnlaUFFjSFgv?=
 =?utf-8?B?WUMrMUNkTjFTQVJvb3VXRDRNb0hkbmtpYTl6NHo4ZXBoNFR1WSs3NDNwRktT?=
 =?utf-8?B?SVFTakFSVTdtdjRmRW1lRytLcmhoUDVTVFdPTzNCZk9sS1ROYVdnSm1iTjdL?=
 =?utf-8?B?KzlqZ00zOHpZZERSakM5OTM5VGQ3eHd1MHFuVTkreWpyaGFKWjdEN2pLQ3Fw?=
 =?utf-8?B?ZGRSaktZZURtMVRPUTJuZ3FDUUxWWWp2WWIzVGFpdStyL1U4WDlRTDZXWnl0?=
 =?utf-8?B?a1ZsVCtKZ1hJOHkyQ1hGZExBZUlaZGhvcmtJaXEvQ2FsZ1l6TTl0bW5MaVRT?=
 =?utf-8?B?ZHl1MVdwVkxVTHhHdU1DYkpZZmxaSys3Tk1nbFJTd1VZK2QzL1lDbmk3cEgz?=
 =?utf-8?B?T2F4cU1uWXloNnc1Uy9VekZQQkNLSVZKTXl3YjJ6WnFPTThyOGxDckVMRmJr?=
 =?utf-8?B?bUlSSmtTdjFYUjhLdTYwVklIZ0F6MDg2cTBHcU51RlhUUGs3Y3dkMDI2azd5?=
 =?utf-8?B?MEc2b2F3MkF1WWltMHNOV0FWYitHdUtWL2RjUjNnQXhxYm9ZN1ZxTllEeFR2?=
 =?utf-8?B?M0xkZ1pnRU1pR25rQUNneDI5UVE2TTMzazlNbStLMm9IODVkakk2V21ac2NI?=
 =?utf-8?B?c3l0bkdCaGhDZUtCTktuaGZDVEwva0ZYaFE0NWtIZ0RiRGg2bE5mVzEvOGJ5?=
 =?utf-8?B?c1JaR1p1Y0NDQTA1VWJHRXZyVWc1c3A1K0Yxd2N1aklHUlFHU2R3SFlWOFBt?=
 =?utf-8?B?d1AxcVAybDdCTm8xcEM4c1IwdGh0Y0NLWGlTaHlXMVVwYmoveU9EVW16M1VL?=
 =?utf-8?B?TjhwL0Y3SWVaVFlFZEFSL29aVEIva05oVS9KdXhra0dzR3I5MDVxeExoUm9u?=
 =?utf-8?B?RDFlc0YvWHlpb0drWGk5N1MxdGdZUng2aXp0dmwrY1NmTmpZMlQ0RjBQVDY0?=
 =?utf-8?B?bDJoWHhiNTY0RHplbTZ0L2UxNU16dWlTRDBtUUN0VW1JQ0xGODU3b0IzK3RO?=
 =?utf-8?B?bmVBZUd0Tm5NZytmd1NySTJCZFdYL0JaUXJEZmhXOWZZL3JYQThnbkZGb2xn?=
 =?utf-8?B?Z0dDUzdiUFc1ekRoZk14OVRENVNXQUpjUmF4ZlhJOEk4MjU1MC9CbDUyeU1S?=
 =?utf-8?Q?6NdNiDuNiIf/9mj4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4855CDE59B21C24FBB49504BEA9E5744@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8182218-8916-4e4c-34d2-08de5c8cec45
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2026 03:42:26.1930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y2ZDgDXhxiQSi2DCpi5A1LUb3PHOp1IjWXVdYwaKRYoRLl7mTEYEUND31ruOWw3MGsTI7+0HsPS7Oyol7zmICg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7785
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDA0OjU0ICswMDAwLCBQby1XZW4gS2FvIHdyb3RlOg0KPiBG
cm9tOiBCcmlhbiBLYW8gPHBvd2Vua2FvQGdvb2dsZS5jb20+DQo+IA0KPiBPbiBXTFVOIHJlc3Vt
ZSBmYWlsZWQsIGNvcmUgZHJpdmVyIGxlYXZlcyB3bHVuIGRldiBpbiBlcnJvciBydW50aW1lDQo+
IFBNIHN0YXRlIHdpdGhvdXQgdGFraW5nIGZ1cnRoZXIgYWN0aW9uLiBUbyBlbnN1cmUgdGhlIGRy
aXZlciBjYW4NCj4gcmVjb3Zlcg0KPiBmcm9tIHN1Y2ggZXJyb3JzLCB0aGlzIHBhdGNoIHNjaGVk
dWxlcyB0aGUgZXJyb3IgaGFuZGxlciB0byBwZXJmb3JtDQo+IGEgZnVsbCByZXNldCB3aGVuIGVy
cm9yIG9jY3VycyBkdXJpbmcgV0xVTiByZXN1bWUuDQo+IA0KDQpIaSBQb3dlbiwNCg0KTWF5IEkg
a25vdyBhdCB3aGljaCBzdGVwIGluIF9fdWZzaGNkX3dsX3Jlc3VtZSB0aGUgZXJyb3Igb2NjdXJy
ZWQ/DQoNCg0KPiBTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLYW8gPHBvd2Vua2FvQGdvb2dsZS5jb20+
DQo+IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCA5ICsrKysrKysrKw0KPiDC
oDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRl
eCAwNTc2NzhmNGM1MGEuLmFjNGRiODQ4NGVlNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMv
Y29yZS91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC0x
MDIzNiw2ICsxMDIzNiwxNSBAQCBzdGF0aWMgaW50IF9fdWZzaGNkX3dsX3Jlc3VtZShzdHJ1Y3Qg
dWZzX2hiYQ0KPiAqaGJhLCBlbnVtIHVmc19wbV9vcCBwbV9vcCkNCj4gwqAJaGJhLT5jbGtfZ2F0
aW5nLmlzX3N1c3BlbmRlZCA9IGZhbHNlOw0KPiDCoAl1ZnNoY2RfcmVsZWFzZShoYmEpOw0KPiDC
oAloYmEtPnBtX29wX2luX3Byb2dyZXNzID0gZmFsc2U7DQo+ICsNCj4gKwlpZiAocmV0KSB7DQo+
ICsJCS8qIHVmc2hjZF9yZXNldF9hbmRfcmVzdG9yZSgpIG1pZ2h0IHNldCBob3N0IHRvDQo+IFVG
U0hDRF9TVEFURV9FUlJPUiAqLw0KPiArCQlzY29wZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwg
aGJhLT5ob3N0LT5ob3N0X2xvY2spDQo+ICsJCQloYmEtPnVmc2hjZF9zdGF0ZSA9IFVGU0hDRF9T
VEFURV9SRVNFVDsNCj4gKw0KPiArCQl1ZnNoY2RfZm9yY2VfZXJyb3JfcmVjb3ZlcnkoaGJhKTsN
Cj4gKwl9DQo+ICsNCj4gwqAJcmV0dXJuIHJldDsNCj4gDQoNCkFmdGVyIHJlY292ZXJ5LCBpcyB0
aGUgcmV0dXJuIHZhbHVlIHN0aWxsIGFuIGVycm9yPw0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCj4g
wqB9DQo+IMKgDQo+IA0KPiBiYXNlLWNvbW1pdDogYTllMDNlYzAxZWYyNjMzMjg4ZmQxYjUwNjk4
MGY1NGFlNDFjNWE4NQ0KDQo=
