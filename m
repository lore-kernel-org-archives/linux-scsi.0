Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2654C92;
	Thu,  2 Oct 2025 08:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759392034; cv=fail; b=iShurmPoIHr+omxNmU1qbe5kwvMRJb5APWYywL9gcwzsgx2vGNaHMIpiD6WD4OuXaLuQ6aBcQ8aIdN3m3yYt5+FQNMg16yE5ePMUoVopdS2H0CijgLZpnK6TVZcMbx9XZnOP5guwmMTYC7vaWzuZYlWsvSS0fh8nSXxBtlO8LYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759392034; c=relaxed/simple;
	bh=+A6v84gLnM3bRLJaI5WA7OnAJSYb7HxP+EMmICL0lN4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sH5HfO7ULuq+tw0/otndb3cPWHLVHUrXbi3AZosDNtihApiLzrk8eCivMvVcSRrsrRzN66DhbllkEVhcnw1pW/8YARlBVjycva7FkDGhAuTGoYg9i+P1+IN1ISsCgrkRerbC9yHGZg4dCNpB0L9tC92MbOmZzXmb4TWmN3Wbqv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AarZYn8S; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mVmG88lC; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AarZYn8S";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mVmG88lC"
X-UUID: db135a389f6511f08d9e1119e76e3a28-20251002
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=+A6v84gLnM3bRLJaI5WA7OnAJSYb7HxP+EMmICL0lN4=;
	b=AarZYn8SQRuqITQaonJJ3I6akWEUZOk4W13tA0d/aVCEKKlAFU50O44PsX8VFMjURdOzI7yCnrN2tJP6qoUlCE752wq1a8xaf6IEL2AX7zZkWRr3uhUoU26ryKh+JwByLe5PnK/EfCRql+tINti96c9upjBcHbPo8dpaGPoAuKk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:1f9b9d93-1c3b-4586-b17a-3c4bbc1f93a7,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:5617e7e9-2ff9-4246-902c-2e3f7acb03c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: db135a389f6511f08d9e1119e76e3a28-20251002
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1361432010; Thu, 02 Oct 2025 16:00:26 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 2 Oct 2025 16:00:23 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 2 Oct 2025 16:00:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EcdlsWvSDx8K+VXLDzD/Enke3swivBkBzt8GQx65PrZ0UfV/WJfwXsGKPLWRQhh+Hx5A6CTvlqMew0jB7tgSBqSX3KG5S+Ik3jeGx5aHAlVpRUPCx96uPvZrdTN3byYiB+O7ReNOFkNsN9T9Vv8dBfl5XyV1Z067co6kESo3P7Neie4fpG5tGvT3Shpkx5XaRf0DW7qRgHqIneS/uPj3jAM66gNjQawZAdgjqrZaRUsILIz2lrDXRXJlORn4OIZOMX7IAM1nSMzg5uoVPfAgz2YDUfXkbcgDC+haygtxwkDdx0/BOhtYyr5t9/+f4QEfvE727IMFfszBAp2wcdaQdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+A6v84gLnM3bRLJaI5WA7OnAJSYb7HxP+EMmICL0lN4=;
 b=yHmfM0S/vh/+N65K6trbMIPrB6Wy6Z1XZvRlZ+7tcIUfSWDZByw233XTQviC9EevOd9XA8WLZ+q0c/S+mJWH5NqtkWBriUpdzRYU96r+vC98gZeurDcF1qibf3NJXPEAqLwTNRi5WioJhsdLMDQLMOhffq5lhawoig0R3cWOQeK7xQyCb1kaMOGG2S2MaDKot12gkYlyamEdQf+3VSIVwNCiTYOSAR0XvXx/awCRFRxcVKugQ7bx+XWLFpqlLRvusVuZAC+S8zDfqMcSFkIIUbCRTpdF6ZLgHPVFyJnBD1cPRicc3wf1ZnO6kFx4tCMB6389VXQFypHK64pwJRBkMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+A6v84gLnM3bRLJaI5WA7OnAJSYb7HxP+EMmICL0lN4=;
 b=mVmG88lCwf4K/fgIo3NYzA8NOQLJsOuQMqaPySUFfh/UE3PbCw3D0PdJNcwHSSb14RjDu6YS7UviVP3oVwPmy3xu3x0/eyu5FKO/9GAPkeUHNhcEQ22OLJiKtKvI7lKq6C4Ai3DKgHS/wWDuISqMRakExKWH0v/1xUpFKET5TJE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9448.apcprd03.prod.outlook.com (2603:1096:405:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 08:00:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 08:00:21 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"wkon.kim@samsung.com" <wkon.kim@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
Thread-Topic: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
Thread-Index: AQHcM2pVfDeKmO/wsUyopC3IsIwgn7Sufl6A
Date: Thu, 2 Oct 2025 08:00:21 +0000
Message-ID: <9fda4a263951753ca7c8d90b454f00f6815b64c6.camel@mediatek.com>
References: <CGME20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924@epcas1p4.samsung.com>
	 <20251002070027.228638-1-wkon.kim@samsung.com>
In-Reply-To: <20251002070027.228638-1-wkon.kim@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9448:EE_
x-ms-office365-filtering-correlation-id: cd161b3f-5964-41c9-a8f3-08de0189bc88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NUloYVFHM0I0bjdEYmJiVERhRURvazQreVNPNEdYYk84QkNDbmxtZ0p1SnZp?=
 =?utf-8?B?UDVOV3k5YXBDZ29oMkc2ZkJWUENxdUc4WkJ6NGNqc1UvVVBSb2l3dzEzNjhm?=
 =?utf-8?B?ZUZiKzhuSFN1d3FUYlNDdzJmK2Vrckt3TG1LdE1HTXoyTTZvUWZxei9haHhn?=
 =?utf-8?B?cVVCUWl1M0M1eWxhREtCRnRpa0tIRFZKNkVPeUZaWXBveEFPYy9nZ2QrTHhz?=
 =?utf-8?B?cFlIWkZEZHdoVG1hMHYzVFRNd2lPNmhCdEZwdk82VklSZ2ZaSUlaYzRpeENI?=
 =?utf-8?B?bkFiK0dsc3BuK2NPQmdmaWNzMkd1ZERzazlyaFRlbk90cTdpOXhGdks4YzRZ?=
 =?utf-8?B?TzEwVGNVTUdNekVtcXRhdEVpY0hHMFlyTklieWJkcE9xdVlMVWRpcE83bEFY?=
 =?utf-8?B?YTcvbUVhdUpRYkJzTHhlL1pPMmRHUkJQRm5KUC9LTWd0cmNnNWxwTFNFbGZM?=
 =?utf-8?B?U1dHd3ZiZ2wxR0lrN2Y5TVRmckp5TGY5V2xIVDExUmVnSkluRFFtSzFaeTRV?=
 =?utf-8?B?MnlQK3k0MVp3YmdzV3RHMmZnY0tWMWR5VHh1NXBWalVvdG1uaW9xUTVlTUUx?=
 =?utf-8?B?R0NvSmlST0ZML2hkQ2FGbGxxWGZtOGVEQ1JBa0R3UVJvdGFQQ2wxdnM3cy9u?=
 =?utf-8?B?aG1qb1BUN2lEWmIwTytmL2h1WFg3bFVhNXA1SmhVZVZ5OUFKZ2lSWlptUVp5?=
 =?utf-8?B?RHEwbTRkbFVkbnJFamhIS0Vsc2NsL2hLZWVhSUVOVHFKUUZ0TWc3U1grS0Ur?=
 =?utf-8?B?VFVMS1FEdmZkWUxoRkZ4SytNMmViajB5YjBJQktMOWNQODBSUVdqN3BxVEpa?=
 =?utf-8?B?VDRIL1JCNmRQSDlNY1JjYmMybC9lUlZZQ285L2RsaXAzT2haYmlWei9MTVZy?=
 =?utf-8?B?cUI2M1MzQkNVcGZWbVU5YjEvZkp4cDJGZy9Xc09Vb1dBcU1pUW5XM2tQTGZy?=
 =?utf-8?B?UTFmN0Y2RzBYYVk4anptUjJ6ZFZzSUd5QWZxWjZOdU44ay9ka3VFNWwxWnUz?=
 =?utf-8?B?L2xHNVVGb0x6eTk2MUVFVW54UitXcWdBckVNRllneGJBeUhGbEhMb2phM0tC?=
 =?utf-8?B?TGprbCs1MFpQWXlVc3VlWnBxNzlmUzBpUHRXNTBsTkNrWERNMUFsZEd3aVFR?=
 =?utf-8?B?UkZrN1hZejdhaHNoa1QvQmlTOUhSanFYcFpxSHF1TTRUNHBLQUdsZ2RuWUlP?=
 =?utf-8?B?R0NRNHZaZFdIQURxTGZvY2RwRVdheXdzNm9SanBvL3pyWU53ekgzcnBFVmJG?=
 =?utf-8?B?UWc5eFJhVGRhYnA4WC94djJtbFR0MXV2L2pubU55ZDdOZ3IrSkZ6UC93ZGhD?=
 =?utf-8?B?T2VjZzU3UVlRUHNubEdadHM2VVd4VFN5ZGxxMGtXZ0lsRkdJalk5VmlGRG5R?=
 =?utf-8?B?OFZtMUlsNy9vb3RvMnFxWE1XSHVOZ0RYbVZxam1YdmJDM2tEMmZ0YytlTjly?=
 =?utf-8?B?N2ZUSFZxTkJtcEhYWEEyb1Z3TGliWHhSOTRLemVmUHlaTVZVdVpHcXVBanY5?=
 =?utf-8?B?bmIxRlZKL3ZxZy83Zlh3RXlINEFzQm8zbURNVGdSRFRZTjJFbGNzMll5N1dN?=
 =?utf-8?B?MkZKYlhlRnlGZVJzQ2djRjdzTHNIWGFZZ29XM1ZJektyZTc2Q2NYeDFPdyto?=
 =?utf-8?B?QnQ1eDRrZHRjVHY5VUl2VWpmQThyaG90L3dYRWJCSEFibUorNzMzNlQxZXgw?=
 =?utf-8?B?MytSRG5SYW1oSXRUbWZVRm4zWFUzcENkUGtpejJtdUZORXJhVnVmaERnYldL?=
 =?utf-8?B?dkhvWjF6VTRZVCtOVjdabTJNdUVKZEF3RHRoQVN5TUl0dHR6MmFzbGgwUFJt?=
 =?utf-8?B?aWQ5YXpadEQzakJyNkJ0U1FucEREMVEwTlMzMy9UOFBpMVQySkd1MmdQbzZM?=
 =?utf-8?B?d2d0Tzh1K3pSdzgzclo3emJYN3BCOWJnT1N2ckFKVWwwMlZCN3ZZZHB6SjFL?=
 =?utf-8?B?OThHeklNcGYrY0NERlVnQmViaGQvakNQQndtVWdLMjBxRXBTQVFRNVJabG5l?=
 =?utf-8?B?bFZEdkJKWDlvNVlib1dwcjd3SlIvK0pNcTZVandBcWNyUE5RUFJIZFpFS1hZ?=
 =?utf-8?Q?l6v0a5?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUpiM2Q5dUNWeExqRzlqUVM4WVVwUGFFTXFMWGp2T2tGQm1iaWdBU0hReDBi?=
 =?utf-8?B?VnBqMDNpQkFPQjhuOEtaRVZFdnNrWVVsUEt0WlZVdUJ6d2hhRVVBdXdibkJU?=
 =?utf-8?B?UHJFeEFvbEJYbzJ2QS9idFZLbXZxRmQySDIwRnRnNFVNa0FBWnducWI3MTBR?=
 =?utf-8?B?WE15QmFNL2luV1VlVXZkSWFDYXdockt6MzRGdmxxMHdld253eHhKVUJkaVA3?=
 =?utf-8?B?LzROc3ZrTmFCcFpvL25tT2VndFBORDRhR3ZkVG1GUFBUcjJVMnp3Q1Bzb0h1?=
 =?utf-8?B?SHFZQ21DK1lIV2xtNmpGcDVRTzZBUmQ3WnNheDdXQ3dqV3oxTmd0Vmk5OTd2?=
 =?utf-8?B?ODBDT1JCcUViT3hOT1oyWGQ0QmdLRnRVaVQrcFRVbERvemdidEJoWDB2dEN4?=
 =?utf-8?B?QWpXVXJZSHhTWWlmdzNnU01rMVlFTHRURmZJUDRVeE9TRWtscVpSVWdtQUhz?=
 =?utf-8?B?MStQOU9BY1FHMkQ4QjNGVFhmMStZUERZcDBxL2RrOEFTWCtaa1VsQzRyMzA2?=
 =?utf-8?B?UGlVWmZSb0RHRUZZakRud1JRVWFTNmk5Uy9NRGZoL3o1Wjc1UGR5dnVta0JD?=
 =?utf-8?B?ako1MmxFWU5LQkRldHYwbldPQk1QK2R2a1hpeTdTUHBHOUxTQlNabTVzUER6?=
 =?utf-8?B?Z3hDSTdOV2NzRnR2ZUxMTlFYcjBaTHJzZEcrTGdGNG1EUnBiK3BsRzF6VnVV?=
 =?utf-8?B?VVd3cXBNM1JwT21ueFBlQ20zNTZOdU50SVNCcGlHblcyd3JxWDV3cjlRMnRT?=
 =?utf-8?B?UkFhUWZuV0pYZUdSOHVoZVN6U1A4MUw2S2dtcnU2MVo0eVcvVUwrUWMyT1pr?=
 =?utf-8?B?cFdza1daU3hGTlB2WFhRZXZncjJLbDYwZXo4dzlaZWMxcThDSHFRSFBld08w?=
 =?utf-8?B?bDNsVEt6cWJKUkxHb2hlRU9kUjJsYUxPYzZaZjdoMFZZSk94VVdvZXhkaEc1?=
 =?utf-8?B?cUZndFR2S2Q4QnRFV0haMnpYZmdiSktKM1E5SXlNWkN5K0lValU2cGNhK2JR?=
 =?utf-8?B?UlUwcFNsczVERmxaTEQ5NnAralBDQ1gxZjU1SDNCNkZDdGM1T2RhOEhnUzQv?=
 =?utf-8?B?cWlBT2JvQ3NoTFpqdkd2R1Z0TnZpMFltQ3hUd0dwT05jaDk5c1JtYWg0ZkFh?=
 =?utf-8?B?Y3duTnI3VXNob3RwUEhRSTREanUxK1FTck5RemIvcmdzLzJLbk1USmZEUmx6?=
 =?utf-8?B?a3VRRjZXTHkvSDBkU3B6VGV4a1lpbEVmSjJwSW9VY3BHU2F3UkJUWkRXS1BS?=
 =?utf-8?B?eDJsZ3ZLVHlSOTZEQ0xPNU9CbHZmaTFUSXFrWEN0L2NMeGRWVk1PQ3hlZnNj?=
 =?utf-8?B?QkJvYTcxN2pmd2xWQUw0WUd2dFlzTWdHc1JjSVNTL1Bwbkh2K1JYV0NqMTZB?=
 =?utf-8?B?RUltT011YWtpd0NYZGlTSVFHYk1neFR1alNIanRXZlhKZzhuaW5yK3dBSSsy?=
 =?utf-8?B?SnVxdW9VZUZPWVUzOFFIUkRCTnNwVGVnRDY2T2RzdzFnWUttaGtkWWdqYmFC?=
 =?utf-8?B?b3pUSmNVZk5RYlVMMEhEWUtNVnpwVVY0YmJoYVVrSXg4blFlem8xeXNXbmJW?=
 =?utf-8?B?T2dDa1pYTlRLK1gwdHE4S1Bad25mV1BmdVlYQmRPMzdVZXZVVkE1QUVZcUxu?=
 =?utf-8?B?YmZyZmEvaXVRV05xZEVyK3JBcy9jemtRNDdGVmJJS2ZqZ2NLam1xeGhhOG1P?=
 =?utf-8?B?c09oR2hwMlhZYXI4WlJVRDNCcXFmMXVtK0xKV2dmYWU3dlc3RGlNKzdod05l?=
 =?utf-8?B?Y3dhKzUxOE55cERESE5vL1dCcXBNMzVZNm51d1czeWxDSEgvcHZkL3A0L1NZ?=
 =?utf-8?B?MnR6UkpGRS9ncktzclF2YTBUWkRtY3crcVJlZVVRMkJLck9uOVZOb0FCYkVq?=
 =?utf-8?B?VFY5cGpDQVBwVFZNemFGRVB5ZExtdTBrbC9VY1JzcVA2UituWkdZRkhRT21Z?=
 =?utf-8?B?K0p3WENMRTMvZ2g3WW5vSnRGY2xYZ0VNM2tXVlU5UUFXdTloUHNIWHpPZXlp?=
 =?utf-8?B?Ny9CYWVPWEl1QTVnbElRemRxV2pPUUlGOVpyN0RVZldTZzlobHhtR0Q0aEVo?=
 =?utf-8?B?T1BxVUZMMFFUbnBCL3ptOVZ0T1g1VXdpU0MweEpDYVl2UFNTbDF6Q3FPNytQ?=
 =?utf-8?B?ZEtaRk5oM0Z0UXJuUUdsRmgxQnNvMm4vbWZGOVRwcWMreEtpRDRYTk5OTDYx?=
 =?utf-8?B?VFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFDFF3C296D712478272A17774CE5F73@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd161b3f-5964-41c9-a8f3-08de0189bc88
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2025 08:00:21.8326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QMf5eVc1E2kaO7DjHhDg3rV3up+tRSi7RZhYSkNbeXwQUO8Z5PjOn4miE04PazF3STpAH9AUkEJhkxdCkZ6X4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9448

T24gVGh1LCAyMDI1LTEwLTAyIGF0IDE2OjAwICswOTAwLCBXb25rb24gS2ltIHdyb3RlOg0KPiAN
Cj4gSWYgdWZzaGNkX2RtZV9nZXQoKSBmYWlscyB1aWMgY21kIGVycm9yLA0KPiBhIHZhcmlhYmxl
IG1vZGUgaGFzIGEgZ2FyYmFnZSB2YWx1ZS4NCj4gSXQgbWF5IHJldHVybiB1bmludGVuZGVkIHJl
c3VsdCBmb3IgcHdyIG1vZGUgcmVzdG9yZS4NCj4gDQo+IEluaXRpYWxpemUgaXQgYXMgMCBhbmQg
d2lsbCByZXR1cm4gdHJ1ZSB3aGVuIHVmc2hjZF9kbWVfZ2V0KCkgZmFpbHMsDQo+IGJlY2F1c2Ug
UEEgcG93ZXIgbW9kZSAwIGlzIG5vdCBkZWZpbmVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogV29u
a29uIEtpbSA8d2tvbi5raW1Ac2Ftc3VuZy5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMgfCAyICstDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
YyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gaW5kZXggOWE0MzEwMmIyYjIxLi5hNDQz
OGEzY2I3M2EgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gKysr
IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtNjU4MSw3ICs2NTgxLDcgQEAgc3Rh
dGljIGlubGluZSB2b2lkDQo+IHVmc2hjZF9yZWNvdmVyX3BtX2Vycm9yKHN0cnVjdCB1ZnNfaGJh
ICpoYmEpDQo+IMKgc3RhdGljIGJvb2wgdWZzaGNkX2lzX3B3cl9tb2RlX3Jlc3RvcmVfbmVlZGVk
KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+IMKgew0KPiDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgdWZz
X3BhX2xheWVyX2F0dHIgKnB3cl9pbmZvID0gJmhiYS0+cHdyX2luZm87DQo+IC3CoMKgwqDCoMKg
wqAgdTMyIG1vZGU7DQo+ICvCoMKgwqDCoMKgwqAgdTMyIG1vZGUgPSAwOw0KPiANCj4gwqDCoMKg
wqDCoMKgwqAgdWZzaGNkX2RtZV9nZXQoaGJhLCBVSUNfQVJHX01JQihQQV9QV1JNT0RFKSwgJm1v
ZGUpOw0KPiANCj4gLS0NCj4gMi4zNC4xDQo+IA0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8
cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
