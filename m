Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C492750E6;
	Sun, 26 Apr 2026 23:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777246919; cv=fail; b=uF8X3+PjghzQ1FagtdXty6ZvHydJFHfqjDErexBrig62DDF4mtOyE2ZqufmZMA2bl/c+iZAoLMHtybS5R3Sy5jrov10nyD5sy8rPxJLtL19126Adl+WCbaiolHKxogKkdvvG5nSR8KV/U/Mi2KoQ94W58cOgdzcZTy2u9Q6n2BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777246919; c=relaxed/simple;
	bh=hcXvP0RFHVnmQ0Ix3tI4XZDuX+MBHx0CBDgOSNxq5ro=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CLwsA/fM0uFdlVIQKTCaAsT9MM8GCvW8wN82jnIxs7Wm1CXdD/uRHQX9DwDn1UP0t73uPxAElIxaYYerWCE8seHNp4iPskYoJVfa7zCN3MiyqPURC7FfWkX4UxT1zodPIvpUDr4zQAHK8CevzognbyQOrchnzJsXspOtMDv2qlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=H7paiPXb; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Pg2ekjaU; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="H7paiPXb";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Pg2ekjaU"
X-UUID: 7d2a764841c911f19781c1a04af40193-20260427
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hcXvP0RFHVnmQ0Ix3tI4XZDuX+MBHx0CBDgOSNxq5ro=;
	b=H7paiPXbeQe+uMeNfjC/GBsrqLYPxV7vT7V8pYQ8RXX/0OjVlPuRU/DtgEtegrKE24WreCsQT597Y+R1gsQfEbCjQFSBfkQoog2c56nuX8s3ShKlW4Mu+jGnz1zNvF4+L4o+t8+HesazJ5mOkJMO6zIUXXmo4INPHJjuw0i0OVg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:f09b2405-3e2b-4d94-bed6-6c5dd0df4511,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:9d91a164-469e-4eb6-aeb8-4b21454b0f32,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7d2a764841c911f19781c1a04af40193-20260427
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 550893587; Mon, 27 Apr 2026 07:41:46 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 27 Apr 2026 07:41:45 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 27 Apr 2026 07:41:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNAN9y6Hj8c34jZxYdzauHnmGL8ZyocV5x/1VTCg7yj1lAp4gx1rFBBbdeJtGpvfd4mnnqE8mJl42bwU/YHrUC4UJM+xwir28ORQ4XiauynCn8dqoz+iXIEG616160aopfvhoeZaSXp4pTd8E8zfA7BTyXY/J4QdAhOqRoSN+PaXFur7278Oo8SKH3woe/7dLTqhF0TUSSjq4H5XqdJ9g+Abp57LpG8CH+NE4hATghLthbe4sWsrvv0D/H/25DudYw82OeEFIdMrAIRX8WnPUaDhBI/wG3syRKLvIpksAkDfKdAWzDA6Jze38VmsLIx0m1XabIR/MGbqDzj6pb3iBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcXvP0RFHVnmQ0Ix3tI4XZDuX+MBHx0CBDgOSNxq5ro=;
 b=MQbEOSIJLP2nGe18dtV8IUucpZp6KH3ONnleaViNr7P395ioO/KnVIj9ZfYkJ/6xCQ9vCx/pjwBoI0KyRIgM8HsGpgut1bC9Gm+DRmN4YzyV2mawx0Rk1ms+Ga9e4HzdqJbwNIFxd1DOfoCSD9Zr2ciNIzTTDY3smR0G+HguS4Vj3Ys/JNosZzxgthTWAz3OuwLMvdfJpu60d4F+2bMjMq5QmUV32djWtemfCwIpEVZ3Lvp6go4OTuwmQ8neYfVEeeZzl5FJFaAdWE6oxo/tuCjFh8lsFoaoGQ/P1YeWelDqWgOjl8BWJclljZ88pk8SlV95SBAoTQO73Q03uvLDdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcXvP0RFHVnmQ0Ix3tI4XZDuX+MBHx0CBDgOSNxq5ro=;
 b=Pg2ekjaUa2qEMtSyT7uJES6rknvTKEpZKF2OXYBSkZnQipAAdjSxxNeBayIlym3nfGyHogR33NsEFYpobx1jAcW4WCjSZy4Mcj2AbXAZTBF7pmK0qGiXg+P/+ABYX9Z6Ps758Q2BdGSka7CBaoKco5X44g6yV2aZr67wDZRnAME=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 TYUPR03MB7231.apcprd03.prod.outlook.com (2603:1096:400:357::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Sun, 26 Apr 2026 23:41:42 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6%3]) with mapi id 15.20.9846.025; Sun, 26 Apr 2026
 23:41:41 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, wsd_upstream
	<wsd_upstream@mediatek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb()"
Thread-Topic: [PATCH 1/1] Revert "scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb()"
Thread-Index: AQHc07TO6EC6v8Yfx0SSqDEzyo7wQ7Xu05gAgAMxUAA=
Date: Sun, 26 Apr 2026 23:41:41 +0000
Message-ID: <66cfa53dcb40035d07b8ad07ba0ce9d35ef54903.camel@mediatek.com>
References: <20260424063603.382328-2-ed.tsai@mediatek.com>
	 <a496a84b-66c8-452e-99b6-622550afeae5@acm.org>
In-Reply-To: <a496a84b-66c8-452e-99b6-622550afeae5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|TYUPR03MB7231:EE_
x-ms-office365-filtering-correlation-id: 428c28d5-ffee-4056-95f7-08dea3ed5de2
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: Ueukg3e28H8Y3fbCuazBpn8rvDO+gBlnNyrlZevg5h12JD4288innxq4ElT12cc7PYiKbUo1xd1Ab+nnEpOcF3Zq4U6qWsWW7Dac7PHxtK9pjH1Z0nuWqMw9WXzduwmWPmF/YxEyeCSxzVS/Z99ES+maSk9604acv+KCbYc0h6FkX0SdlbdRUcv4ug5LEKqB2gwi1C8FqWXBQ50ui0D1Nd1AOVDCBIDI7zF6Umz0HN3wuXvZQookNK1p0bXi2AGeBkEWhwIGwRq9B7u1+rwRcaK+p57KA06KiC+DJ0orqG9yJHhwE6SlMisYnGhtJMPQWEwD12uMiChvUhQgh7XcEc8K/zFs9LREtmOrv3sSSEUCU8lgo/+hTCkMObcvIdrLkv/+gpMdcHn7DeH4mfq3SdTSRfU3e1+0C6PKnfxjToJnASRVnc5obHxYSZMZmuBtzgRp2WABNCPbl/Dyuy5IbdOtX5hvhvGbzBWjROPz1wwlvsSL+p8qzdjwx1cSUHXFZGBxL9k2qXA2ghes8odZtLpcUG4deH4pfEoPOWMBtLZYNSDMVsrAzpLHycNTGPMTCZWlrprHPlzXxXzsQq/jXTaETMDBns5FFzV0MZXACL10xo1wcrDUxS7QADMyUZS0RP90mFh4mtK2Q7Gl1N3MP4s1SiexkBFf7t1gOopbrgiklbet8d7I84OBwlfuYfpja05gydSbN0PSPAlrexzerdp4Y0cs4bcivN8Sc70Rf7tJObQMtqILarhs4sRuaap3UeRKqWc8rPItkhLyCYhN0VQzk/GJSHWhmOomKbyyZoY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjVhb1B2ZktHN2tEYzZFa0lqT09hbDRraWRRc0J4YXk1M2N2MzU5ZlpGZnZn?=
 =?utf-8?B?OTU0bVE0SUdRdHhObFZDdGMyMzNXU1BhU0hIZ2x3OHdJSERIZXpwZlczZWQx?=
 =?utf-8?B?SDJ1eG5UTUJ5NFpmazlzc3NaSjlwSGF3YytmcUdiZ0czOVRvV01hSXZybEpO?=
 =?utf-8?B?NFYxSlBjdkVsa24vVFpzZW5kekt5YUJ5NXRyVHRXL3labXlZcnR6NmFtVDBJ?=
 =?utf-8?B?c1F3TWsvMXNGeUtDb1pnT3k1enFEZ09EWFZxN3VNdjZGTUMvb3pMYmZSWE1K?=
 =?utf-8?B?c2tRUmZscHZ5K2NMMjNKYTdRamVXOVhoZ1FKc1ZvSFY0VzY3aWx2VFNFdnB2?=
 =?utf-8?B?U1dma3dmYzZKcFIrb1BmSngwZVZWRk9ZNHR4SmVwYlJZOVhBak5TU0RZa0t0?=
 =?utf-8?B?SlV1WFBaOVA4eUJ0alJ1aGM0citVVXZZMHdqRFBDWlJWSkRuTXhsak16VnAz?=
 =?utf-8?B?aXNvV3M0TUk3R1JHNC9LZkgwVGp5M2ZUWEh4VXBXYk9yZ0tLeE9LNC83OWpL?=
 =?utf-8?B?UkNnQ0lTK0tCWlJKQnFFeE16VWI3L0VzeTBGcjlldE93TGJVRktFWE45OTIw?=
 =?utf-8?B?RXRKNkVwM21jNWFoam91WmFqYUprampMRmVUN1pkZEY2RjlzSDF0eVNSZFA0?=
 =?utf-8?B?K3g4eGJHWWJ1VVdjb01FNDNhL1gxWjk5NURmWWJEM3pQMldycCt4MWozV3NE?=
 =?utf-8?B?S0o2REd6OFFtQVFBYzNIMVM1ZVVYR09naEpuZE1qNGNtRE52V0VJaGcyWHA0?=
 =?utf-8?B?RVY1V1hSa0l4NjFZL3JrVkIyRU5SMHEzdjlIM3Z4SnMrUU9xUzJnYXUySVpU?=
 =?utf-8?B?c1FKRCtZTjhXOGZzaVc5VUpRdWYvV3l3TE0xdmhOK1hoZ0d2OU1ZVHM2c3Vj?=
 =?utf-8?B?MGVUYi9SK1J5RWlQcUNGc2MwdFAvTkZtZTNkUGpYSlhERW1WTTBxY0ZHaDli?=
 =?utf-8?B?aTl4V0hOelVtMG1LcEJ5NXRkQ2p1SUhaWWN2bGNFaEhGSlpGY2VQREY5M3Zs?=
 =?utf-8?B?NEpUWTl2MTFoVkMrTzZ2aHNqR2R4THZkaVpvUXR1bDhOR2Q0VnhCejZ5VDlQ?=
 =?utf-8?B?RU1sRDdKR2dsNGxaOE5yenFyajAvcUVVT1lKQmJvTXlMYXFDVHd3Z1JmMWRl?=
 =?utf-8?B?OUsvemoxa210S3lVSlBhQVF3c0R4NEdjNFJUamFYNENNT3N6UHJGekZ6aUN6?=
 =?utf-8?B?QWxKODdZWmxEZElsbUVEZU9TdnRvYVdPVDFJN1FZZjdPaDlKVFVNbmRrWkpR?=
 =?utf-8?B?a3A3c3ZwRXRlRUJxVmJ0YkVJaVovbXhoOWk4WEJLVlN2TVhNK1JGQXREWU83?=
 =?utf-8?B?RGg0SisvaHFacEtkV2U3S3J2bmlEQWdqTHhrOXBpdm5zTExOTUFaWXhDYi8y?=
 =?utf-8?B?ZVJhSWs4dC9yaWF0TW9RTWFkaW5rbHgwZ0JFUUFkckJMT0hyZ1JOcGFCc3JH?=
 =?utf-8?B?YW5YYjZqUURqYllKV09BUVlLZit4c1Y0a2lWSkF4TWxyYWc5RlRrY0tNejI2?=
 =?utf-8?B?ZEFzL0VTbFczYUVFV1VLbVZicEdXMmJVbkNXc1BadlBNR29uSzgwRW5Vd0pi?=
 =?utf-8?B?bTZPOUZRbVoydmQ0YkRhNEFONEFVZy9VTGQ4RUpaVWZLbndYb0xWdUpaUE9w?=
 =?utf-8?B?Y1pLQ3p5dVR3RHRDT204czZ1bEp4bWpqT2QxZzVCa1pvY0FsaTNKaVQ4OEtY?=
 =?utf-8?B?V3Z4Q1FzZ3JYeDV1VE03MEtEU2EvZEtFMkRTKzIvRGxMSHlEbVc3WEJXK29B?=
 =?utf-8?B?RFFSdytxVEJrYmQ5ZVpyMXZYMHVDcWYrTnM2eWhseFpxbzhTbEhRVlRWVUxr?=
 =?utf-8?B?SHpSWG9SdTY1V2dWUEF2bHZzUXNZcU1yQ3ZCTTI4UUpKcVptU3dLNkFIQ1cz?=
 =?utf-8?B?WEVadXlGUGpYUFZBb1BBL0lZdjgydGhhem45RE4xZFlMMFltUXlpNXN6eEpR?=
 =?utf-8?B?ZWZkMXprN1JDOUtycVQ1ZlBWN1NZU2RPSDVsanJBQ3dpQXNqdW0vS3Y4L0dN?=
 =?utf-8?B?U1JzS1kwT1czNkduOFJGS2F6aFRXbE9pbmdmU3VaZEhUdWQwZTE3ZTFncGdF?=
 =?utf-8?B?WWxsZDVoeERXdGFGQVpsMWV2ZWZJT1hEOHlYcHovK3ladGFLTEZBTFEzblVM?=
 =?utf-8?B?aHE1K0ZlZnM2dmxMdE5QSERYUE1kU0dNWEMxVjk5TTNnOVNuNGljOGFoVVFq?=
 =?utf-8?B?SGRwTkJIV2EwWGNCY2lKakpBRHBROXhXbXlKUElNc3ZwZ0t2MkIwZWtWN3gx?=
 =?utf-8?B?YmhCcHJaZ1U3Y3pJRVZGbi9LRytCSnJjeDE1ZGcyaXF4cXJDcng4a1FhR0xX?=
 =?utf-8?B?Q3hPeUxsZUo0a3lqM2xQNC9lUFF5TTN4MWpNc3JMWm9jNHB0YzdZQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B48A8E386BFD974385280F4E46E9D88E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: fLhX60Tx2pPovy/6sSpV+mlfwbkZzc0Sj9TuUK1PnMAKVQZpLoTFOyrZYAThEwbYLRnkUoUXUx2kOY9NNvzQNzLm+ULHv0i1zo9KG2E8DyDWYc1uxB/p2vqCo06L8hZCbN+6/0ZOCKBbivurvbKLp4jSEr3HB+UdH5YtDa0AVKNqhI+42lJIOe0yPK24LRIo3Lj0ZGeJdlS3WtkY/UsXFiVvm5kAJE0iPMCYmMok/rhllrDwYvttaKVhzJ94BagfYeYwMCivyTRstmyPAqhxzz4OwKGf1iOpypczhLrutsWQT6H3mPUy9HWbLocnl0xq1N68G94MjmImtjGEpIu6EQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 428c28d5-ffee-4056-95f7-08dea3ed5de2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2026 23:41:41.0677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HMJl5FgGmJJn/b8HwIDEZzyElsyyGXjMbUR+cQDyT36bg0uaZoPyTmzcGH/3uA9qNQ+g8Ko32fVSVwoZCpmirw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7231
X-MTK: N

T24gRnJpLCAyMDI2LTA0LTI0IGF0IDE1OjU1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDQvMjMvMjYgMTE6MzUgUE0sIGVkLnRzYWlAbWVkaWF0
ZWsuY29twqB3cm90ZToNCj4gPiBOb3RlIHRoYXQgdGhlc2UgRE1BIGFkZHJlc3NlcyBhcmUgb25s
eSB1c2VkIGluIHVmc2hjZF9wcmludF90cigpDQo+ID4gZm9yDQo+ID4gZXJyb3IgbG9nZ2luZywg
c28gdGhlIGltcGFjdCBpcyBsaW1pdGVkIHRvIG1pc2xlYWRpbmcgZXJyb3IgbG9ncy4NCj4gDQo+
IEluc3RlYWQgb2YgZml4aW5nIHRoZXNlIG9mZnNldHMsIHBsZWFzZSByZW1vdmUgdGhlIHVjZF9y
c3BfZG1hX2FkZHINCj4gYW5kDQo+IHVjZF9wcmR0X2RtYV9hZGRyIG1lbWJlcnMgZnJvbSBzdHJ1
Y3QgdWZzaGNkX2xyYi4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNClNvdW5kcyBnb29k
LCBJIHdpbGwgc2VuZCBhIG5ldyBwYXRjaC4gVGhhbmtzLg0K
