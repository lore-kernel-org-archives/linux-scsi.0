Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC92E79CF;
	Wed,  7 May 2025 04:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746590619; cv=fail; b=uqXwX34Sow1iAZ2xE6vkYv2rS0KOCuVUAtvdGA756kYVAnq2grHmt0TgvTuxFQ1LMrm585Xjm1C1BbnWvd7Z+nRSW4yldjyYihixjrjpt3w5q0cLYVj5QL7/uvcVKIU3qsbYkx0DIcypJaM9ZvO+KJtlhP+ZAvXnUoiwxp+sBJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746590619; c=relaxed/simple;
	bh=ea2807a/rf7ad7VbVd7+uB3ypZpYD8Ai2VT+Rqlkr8o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rAyg2RBNIPAF81qhQLAYw/J9Qg6S6HN7S/unUc2Eroa4vq6AHUZY/NNQAEZGZmlLZLHEytLjIj9kXEAPZ41biEm9h0oQMY60Uys4k+Ios++kH24hwsMXTFgWZteh6W+Z/liM/dcJSaONJr2fqjN2oPP7nJNvj6rnTQ4jmWp5fG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=llKzWlI8; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BSSkAk3k; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="llKzWlI8";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BSSkAk3k"
X-UUID: 3ba5168a2af811f0813e4fe1310efc19-20250507
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ea2807a/rf7ad7VbVd7+uB3ypZpYD8Ai2VT+Rqlkr8o=;
	b=llKzWlI8EQQskgPYX7tARZV5It2h6QwzOB3hxXou/TLdraBvIUVWfBchSi96SoUtSxmheqCIdHkGa+l+nAoytXsvMBUvqf4TlaGSK31GNm4qKBTVM48CLV6HgPR+vh8sxazPL2nNqamxyOzTEAsieKX6s1uH+HPZrMaqW5QAdCQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:68aecc82-79ae-4d75-ba5a-ca4c2a9f1bdf,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:4e56d102-a4e8-4faa-a873-a300648b31e3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 3ba5168a2af811f0813e4fe1310efc19-20250507
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1848258679; Wed, 07 May 2025 12:03:28 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 7 May 2025 12:03:27 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 7 May 2025 12:03:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPOtMyZy6m9oMwNmgJ6rEvJqThCantTcCd7CSj22fp1rdpwQMhFHTynBGUP7scHWK+VDYJIH9D8xRRb/jdg1Y0pY3r/BUqAnlfHS06XrvychTfl8MtJUs1jsMDDqgs87E7IL6IJScLJKDghCTu0z1QDg/RpUuTKhvsqR3wCyzMkMcBbuvChP9Pt3++vdpsONcs/shkvhvnnigVu1srQa6OP/mc3010deg/u2D2gd4KS33L/NI8HH0qhhNjmXBLkh4qnm34JHaRI10WJXD5364ff9ofmvhlh3zZOGc60gIG0VnavTMS0Mx7O49maaCQhKmUMZweJELLyL4mZfpoQ6lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ea2807a/rf7ad7VbVd7+uB3ypZpYD8Ai2VT+Rqlkr8o=;
 b=xcZIzyU1e84rFZD2ALi1N+Iel59NGNxZlup17NTEccbjYspBudRWpaN3FGmQILnO9Py6rNi27AAkYRBr4hdGo+l8VHBOLQbH0tMVmIDQy2njQsPY9nZXtrFTB6CNu1p6/ZeZ74SE14qq352N3PDEHE+/PnQGW7qNlwoRXSR0cxpFsZ7ObgkIUdiucJHm5lbOL5d3/pnRRghtQwuDsu78vmSE2sagF6rizGSDA0LCRWHahLQ+8dRMjv2uXC/bzoMNsswgSm8nF4lYaq9omq9Snbkd10JvlElsFpNARrbTFXs7Nr/rfVBV4GsmU0W94dFvYh32NpapDrQHGSNTseE8ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ea2807a/rf7ad7VbVd7+uB3ypZpYD8Ai2VT+Rqlkr8o=;
 b=BSSkAk3kNq6Xo5xcptSy2bTokspiGZxP4U9SRbDTAehlIEEFMlHcrNwcjC3qAGR7sdRKCRw+l+IP9VFtvCCpSLOpUDNWInvQFNf27CYJpm7foKQNPjz9zYcXiGl+g4s8EuAvq8nKNJMRCinm+gUa1q2kc0Dtk4Gm6efWcmISzzo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8667.apcprd03.prod.outlook.com (2603:1096:990:91::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Wed, 7 May
 2025 04:03:24 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8699.031; Wed, 7 May 2025
 04:03:24 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?=
	<jiajie.hao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: fix hwq_id type and value
Thread-Topic: [PATCH v1] ufs: core: fix hwq_id type and value
Thread-Index: AQHbvoQWPkIUMOxC50OqQ55NExCIJbPFxwIAgADF6YA=
Date: Wed, 7 May 2025 04:03:24 +0000
Message-ID: <6c9e983154ff8d9b4a1e63eb503e8b147303eb68.camel@mediatek.com>
References: <20250506124038.4071609-1-peter.wang@mediatek.com>
	 <04fc1549-0fa6-4956-b522-df5fbc26100c@acm.org>
In-Reply-To: <04fc1549-0fa6-4956-b522-df5fbc26100c@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8667:EE_
x-ms-office365-filtering-correlation-id: 9124afd0-b917-42a7-a78c-08dd8d1c1d0e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QUhHeGppZlZuMExvNHRrZlQwdUxtVitTclFIb0YwV1VvWWc2VUcwanNuUmZN?=
 =?utf-8?B?dkVKYUxTS2lWM21yYjg2OXVNaCtyeUl1eTArMVBNby9vQTNNRWJabG50WUN1?=
 =?utf-8?B?dVVyLzFPSWJHWTV3MUZTcnI4bHdPVlpYQUtTbkV1eis2WUczbU9PMWFRZDN1?=
 =?utf-8?B?cUFVblFUcWxyTm5tK3pvWWxsUlBGVmlKRVpEQ05qZjBkNkJXRlZFaDlwUzVB?=
 =?utf-8?B?YVI1SzlKYVRRNVZrUXVvMlBEM3dJeU5QS2FDaGNyNnRtdXRTcmF6VzdJU21Q?=
 =?utf-8?B?R2k4WEdHcU5acXR5SFNHMXM3ck9jRHQzdko4b3JwNDVEaGpmeWNaVTNEeldT?=
 =?utf-8?B?eGJDZ0NXQ3dpT21Qcnk3MlR3L1VaMnVDZXU5MlVZY2JXQXZZRHBmdE0rRU14?=
 =?utf-8?B?Zy9ES2J6V0dxVVpFcTJ3bXNZcXNrVE5UZEI1UUduZXFZYmg2QTRXejFqMVdI?=
 =?utf-8?B?aFYvWXl2UHZMRlpNUUhBY2dVUE5MZk0wRHBNc1pyRmFXeHNPWG1CZVBPclpR?=
 =?utf-8?B?M3NUaTRHTms4OTJhQ3oxTFZsMGo3MWdENDNzTnlqc1ZQWmp5dFVLTE9GSTVn?=
 =?utf-8?B?cHBpTVFkUm1jRWwrSXN5eUp5M3A3a1RBK3ZLNk5iSFNZcjhZTGZEOGcyN2cy?=
 =?utf-8?B?YkJ5ZHdIbW1BVDBlU2JtbWoxdGFPRngxcDAzVG1TL3UzcHFYUE5idVhDN0Jq?=
 =?utf-8?B?STJZdEJnZFZ2RkhhVnJOMjJsUU5OM2lmNE9WWjN3RlNjMkptVmVpN2ZkQzJ4?=
 =?utf-8?B?OUNiVnBFQktrSnZBcXpVQnVBUEo2a25zMW1DVmxaSytmbDFpUm05ZmFpSk1L?=
 =?utf-8?B?WVF0YTh1U3gzK2Z6YmRIYnBUVXhhV1Z1c1ZHVThIeWpQdmNiaG1qdTd2SytK?=
 =?utf-8?B?R2tKL0MyVGxpS0tXWkluVGc2SDZINW13RWdWMXBNbTVaa2xzdDhYNkZjMkpV?=
 =?utf-8?B?QmdVbmpaT29WNVZscStQK1ZMS3pHSUF6OEFNREMvNTRnWnBUcFpFTTZKak9Y?=
 =?utf-8?B?TW9zQ2dIa1ZJenpmSzVIcytqWUlyMmFtSk1nai9yUm5NNzh2czVrZUJGeEZB?=
 =?utf-8?B?RklCUVJwSndqQ01wLzFPQnVySTZVbXl0d3BBbzdNNjlCNmprMEt4b3YwOFRV?=
 =?utf-8?B?Nnp4NlpvbWMzcC9RMVlOaTU1U1BFSW1SekVxSHMrTW1JQ1VDd0UxUHBtNGhE?=
 =?utf-8?B?bmRJS1RETWUzcW8zSlRjc3NSZEZ0Y0hRb0VHbU9sTzNnNkQxTEIwY2dYRW10?=
 =?utf-8?B?Uk02ZVJkREtLYXFWMEFJMm55UVFkdE9lSlBOS2hqbWRzOUZjWEVhdjBRQjFi?=
 =?utf-8?B?ZnJab1FBZUxidk1KeEVMMnA3bWVCQjVZRlBGdDBoZ1lvbW1mbEEyN1Awemlj?=
 =?utf-8?B?ZHIzVCtpVFBvSUhEK1NaZzEyaHVlWlhWbnZhRXZrZHg4Q01Bd3g0eGNodS9U?=
 =?utf-8?B?ajVSem5RSnNFVmcrMDZ5WkNhN2NTM3l2bHhiTXFtb2Rwa2c1aG9KRXJHb2lr?=
 =?utf-8?B?UXlQNTRvUVJ1cEhETlltU2tEUW5xU1R2Q0cwMnFqYUMvLzduRXNzWVVKa1Bp?=
 =?utf-8?B?VjFrN2lrQjU5blZKRDBsWDZjeG9HVng3WC9oa1A2L0FSN3hnNTJuSi84dXNR?=
 =?utf-8?B?dlZBMlkwZ2M1YmM2ZkloL1pkaEJ2L0g2VEVRM3EzZXhUKytWQkNlZXdTZHN2?=
 =?utf-8?B?cFJGb1BkOGljZHVQQjZYd3oyKzJNekVCaVBUQjBvM3RVV2FPeEkrRE5NdnRt?=
 =?utf-8?B?VThieTBPSHMyQ0FqTTJvdnNRQ01RMm9qb0doOWErNWgvVy9xR0VHOEo2MUtl?=
 =?utf-8?B?ZFcvaXlxQ2RUK242OFN5VWl2Wm83Z1RTU2NhSDd1ejBZOUE1VUZUVDNEcGZ5?=
 =?utf-8?B?cm81QXloMWlRcXhnNUFvTVQraWk2NEN4SkJmSlk4ekl3ZTQyWWhxcnBjbmtm?=
 =?utf-8?B?MFBLb0NIaDhReEJ1aWxlZlZSa1N3WHpWQlVsUVVPblVGRXJ1LzZKQUphY1o1?=
 =?utf-8?B?bkk1RDBnZWx3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2pid0lja292SWYzakdJTXlraHMzd1BrNzRaM2kxNTdWV1VNYWNTaE5rc2ZL?=
 =?utf-8?B?emJ3YXlLQmZ0dkN2dWVGWWpyUnlyTnMzaEQ2d29yMG03YXplNHR3UEpaQmFC?=
 =?utf-8?B?Qk5IemtPY2t4RWlWS3FueEdpbXBydUpMTTNoa2JrOHhEdkVubVQ2WEhENUt6?=
 =?utf-8?B?YWxmMVR1VlUvMU94WjY1RFlFQXNHQ1doaTZrRzk2bHFLYkdibk1XcDYvQVFQ?=
 =?utf-8?B?T2dmRFY5cllHejYvWmpNdEZmTXlFRXhLaWwwUmtvd1RUV2dZS3Y3NmIrYVlW?=
 =?utf-8?B?RFM4ZUlpbHdZaHdSdmdqNjRJWm9Dd0pBUmlDZStuaGo1MzNaUTlQeFVtQ3B3?=
 =?utf-8?B?WGFITVA5eHY1SmdlVS82YU5VdjZFa25PQUdLeHRYT04vNExWbERsbGRlaXdY?=
 =?utf-8?B?L0pwOFRnU0Y3Mis3ZWJkRmd5ZzJ6NDZXMjVLbmJCTlA5SmpYZWVaUGxOcllx?=
 =?utf-8?B?T2M4N2JHcU1wR016MWt4TXhoSFVKSUx2SkNoOCtJdGthc09HeWxyZXQ3ejlX?=
 =?utf-8?B?ZWJUMXBwWmJHR3Q2bitaUEh5aUpQRzRrN0FMSmVPeUIzZW9oUVVXSytaWDdC?=
 =?utf-8?B?SlNNWWlkU0JWQzVqdkovVVpmbWFIYVZqOFdjbnJYb0t5NmVxTmdTSkY4c1FV?=
 =?utf-8?B?VTdNd3M5TmtrK21wQ3FPSExqNzhjMXFrUDAzTFQ5eW9HditGNmIxeHhtdHRX?=
 =?utf-8?B?ajZqZ0tVRWZiT3dzWnNvVTFJeFJ5czlrY05JQ0dKSTZxbzFrMHZqQXRTaGFI?=
 =?utf-8?B?TTlNOXlqcGdoMWZPajlXejRpYnZTKys4dFpMeGRkRlFmRDFOL3lLR3NZTUlR?=
 =?utf-8?B?V1NOZ3MzQXIwVHlJYzlNQVMrUGhFMjAxRGhhUW5KZWhrNkNyajRzemlOcXUy?=
 =?utf-8?B?MGxoVUtrcTdzK21lTGpHZXdtRnBidGRoRWZRaXJNaXJSN1lPak5uRFVoeW9t?=
 =?utf-8?B?QlBpYWJ4MWsyVlJwRGVRL3plNkNweVZaMlBIZ05vSlZCU3hWUko5bTBJb3B1?=
 =?utf-8?B?WjRXdXpnNURuZHZsNXdEbFJTdzg5UGNaU05YcXBiY3MxMFNIQ1dYMm9IWHN2?=
 =?utf-8?B?RVBYb1FhQzh3dkJYUEVHQnJaWEt0MjczWEJMZzBCK0IxWitoczgvMG1Wa3Za?=
 =?utf-8?B?ZG0yY254blRVeDQ1VmJ3aVpjbmRsUWIwYlhwRmh2Z1NMQTIxTzFHS3VIOGdy?=
 =?utf-8?B?TUphcGlxVHZMMGdKUmhsTmpBaHhrT3dPeThYdHZPKy9aeDRHdXg4WVJsVTRr?=
 =?utf-8?B?SDJXSlhaVDNPUHhqa0dmQkgzUE5IbUR3MURPMDF3dXQyNVVjRUdYSmRIalZP?=
 =?utf-8?B?MVFZZitGK0FEcWM3SHUrc3JQeDZKVUJBSzhNNnY0NFZiWE5CRjNqakZJUkM1?=
 =?utf-8?B?VkJZUDJNcms2SzVqNkdwdG5QUzZlN3BzdGdISkJtUE9DTk8zVUNtbnN2bUc2?=
 =?utf-8?B?U2wwRlMyaVQ0N1o3R2JzVFl5M3JhcmxxWmFPY3FDN1lLRkpDWExTY1FSVHFl?=
 =?utf-8?B?Q1V4NDdBRnRZM0pPeWtrTWRDc3hpWDNLV3BQSm1NUHB1eXhKaWU3M1FMVVZv?=
 =?utf-8?B?N2RxSWlUQzd5K1JQTStlNVNUSFZwU2IwZElnWHFZb3N2SndpNGFLZ21UQjBP?=
 =?utf-8?B?U2hJVTZGdDlKUnRlOHhBc0V5dzM2Qm9mclJzMVR0Y1AzMVRiNzA4WTFjL2pz?=
 =?utf-8?B?ZGdqeXNUTTlrRjl0akY0SXVRZW5qQ0RET1lUMGtvSkdTVFZHT1ZuU29ZK3Bi?=
 =?utf-8?B?Vy9vVWw3SGprL1ZyRDdlODA4RFB4aWJaZFlweUJBQk1USW5sMllTNnBod0li?=
 =?utf-8?B?SVVaUE40Y1ZJby8zVHpNQkZUemZaRERhc0FuWlkxbjlGV2x3d0FZTEVvV29t?=
 =?utf-8?B?UHlNN3hHRWpCVmN3NmR5MTh4emg3bTNoWjc5TDhQV3NQa0RVMlFBSFBBenFM?=
 =?utf-8?B?YndCYm9wcngzWHZ6czZnSTN6cnFwQTBZbU5YZW1pcUxzSE5BTGNQSDJVYkZF?=
 =?utf-8?B?cVFlZVFsTTFtNExMZi84SkhGMmo2Sjgza3UxenNEeXpIVG0yWHNyZE5qKy9q?=
 =?utf-8?B?T2owc2M3NE00Q2pKUlB2T2YyNkU5OSsxY1RYUzFCWHFkdEplbVlPS0VCRzdR?=
 =?utf-8?B?cEtkcmQwam1YY0tCWWo4WHFuU1grYWNYQ2JCTUdPckxiVzlOeE84Z3laMGl6?=
 =?utf-8?B?ekE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0993718745954849A21AEC827716B471@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9124afd0-b917-42a7-a78c-08dd8d1c1d0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 04:03:24.2003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PX9oubZl2R3fWs5Y+IKOjIJbd12Nas/M56R/G99XAZzU7Q5evix74ynzp+HC4OmsHQgwDU3cYFmjvG6glJyJ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8667

T24gVHVlLCAyMDI1LTA1LTA2IGF0IDA5OjE1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBJcyB0aGlzIGNoYW5nZSByZWFsbHkgbmVjZXNzYXJ5PyBJIGxpa2UgdGhlIGN1cnJl
bnQgYmVoYXZpb3IgYmVjYXVzZQ0KPiBpdA0KPiBtYWtlcyBpdCBlYXN5IHRvIGZpZ3VyZSBvdXQg
d2hldGhlciBvciBub3QgTUNRIGhhcyBiZWVuIGVuYWJsZWQuIEV2ZW4NCj4gaWYNCj4gb3RoZXJz
IHdvdWxkIGFncmVlIHdpdGggdGhpcyBjaGFuZ2UsIEkgdGhpbmsgdGhhdCB0aGUgIkZpeGVzOiIg
YW5kDQo+ICJDYzoNCj4gc3RhYmxlIiB0YWdzIGFyZSBvdmVya2lsbCBiZWNhdXNlIEkgZG9uJ3Qg
c2VlIHRoaXMgYXMgYSBidWcgZml4IGJ1dA0KPiByYXRoZXIgYXMgYSBiZWhhdmlvciBjaGFuZ2Ug
dGhhdCBpcyBub3QgYSBidWcgZml4Lg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KDQpI
aSBCYXJ0LA0KDQpXaGV0aGVyIGl0IGlzIG5lY2Vzc2FyeSBvciBub3QgZGVwZW5kcyBvbiBob3cg
d2UgZGVmaW5lICduZWNlc3NhcnkuJyANCklmIHRoZSBjcml0ZXJpb24gaXMgc2ltcGx5IHRvIGF2
b2lkIGVycm9ycywgdGhlbiBpbmRlZWQsIHRoaXMgcGF0Y2ggDQppcyBub3QgbmVjZXNzYXJ5LiBI
b3dldmVyLCBpZiB3ZSBhcmUgYWRkcmVzc2luZyB0aGUgd2FybmluZyBjYXVzZWQgDQpieSBpbmNv
cnJlY3QgYmVoYXZpb3IgKGFzc2lnbmluZyBpbnQgdG8gdTMyKSwgdGhlbiBpdCBpcyBuZWNlc3Nh
cnkgDQp0byBmaXggaXQuIEFmdGVyIGFsbCwgd2Ugc2hvdWxkbid0IGp1c3QgYmUgc2F0aXNmaWVk
IHdpdGggYXZvaWRpbmcgDQplcnJvcnMsIHdlIHNob3VsZCBzdHJpdmUgdG8gbWFrZSB0aGUgTGlu
dXgga2VybmVsIGFzIHBlcmZlY3QgYXMgDQpwb3NzaWJsZSwgc2hvdWxkbid0IHdlPw0KDQpBZGRp
dGlvbmFsbHksIHRoZXJlIGFyZSBtYW55IHdheXMgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgTUNRIGlz
IGVuYWJsZWQsDQppbmNsdWRpbmcgcmVhZGluZyB0aGUgaG9zdCBjYXBhYmlsaXR5IG9yIGNoZWNr
aW5nIGhiYS0+bWNxX2VuYWJsZWQsDQpldGMuIA0KTW9yZW92ZXIsIE1DUSBpcyBub3QgYSBmZWF0
dXJlIHRoYXQgdHJ1biBvbiBhbmQgb2ZmIGF0IHJ1bnRpbWUuDQpJdCBpcyBhdCB0aGUgZW5kIG9m
IHRoZSBVRlMgaW5pdGlhbGl6YXRpb24gdGhhdCB0aGUgc3RhdHVzIG9mIE1DUSANCmlzIGRldGVy
bWluZWQsIHNvIGl0IHNob3VsZG4ndCBiZSBuZWNlc3NhcnkgdG8gcmVseSBvbiB0aGlzIHRvIA0K
ZGV0ZXJtaW5lIHdoZXRoZXIgTUNRIGlzIGVuYWJsZWQsIHJpZ2h0Pw0KDQpUaGFua3MNClBldGVy
DQoNCg0K
