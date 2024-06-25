Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314FB71750;
	Tue, 25 Jun 2024 03:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719286748; cv=fail; b=ETrRxwSeLdqiAmhMUotNOW/Vw5DBF1yGwyJ1A+uuVilPKeVUy61WELESkxPZ3JKe9Vtd2QUgDf6tf49R7qc2EYfnIlxPF29v3BY2Ypj4Bud1yOFOVkot3d7Ia7qC1Mo80BtRKB1+WwYbHSEetdrBanDBCeby/ZV3mmQ61e3BqtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719286748; c=relaxed/simple;
	bh=DGMODZ+r87pRnpa8OVwRkx6SjDcv2OSOeZkDOF5t6z0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ESBS+oAjlcwZqjs4NO2FtY41XJ8hLuxhAwKQjQ3ZHTRVrRaUj7PqBq9f9pnNg/VZpWo9osRm8xlITIdUsoY1yKuw0F2uoKU5Q14ilwiUYIuusRQZXymyXOiPpbRLEXUqwNjQ4gkYhSmDTotFrVHEDh9ZBbCGEX01sumHtEviZ+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EaARx30M; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=NOd8QeN8; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EaARx30M";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="NOd8QeN8"
X-UUID: 76150b1032a411ef8da6557f11777fc4-20240625
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=DGMODZ+r87pRnpa8OVwRkx6SjDcv2OSOeZkDOF5t6z0=;
	b=EaARx30MBxIkf4JnhRjl3GOJn51byLMowUeksNMN3vSAtXNH9jr+HNOQ/4BG8+avIP1bymzHBzq4OH8Ugmhg2Owak/vAXJQFk3d/E//IJWuN4cjsTzBLymu+ZaqYv7ZrN2ifFscYqfKTmhJtrOFeYKQP7tsssfq9J3bilLOdblM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:a1b19d8e-57c8-4eb4-8a6a-0fd694437bda,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:8a3c7e85-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 76150b1032a411ef8da6557f11777fc4-20240625
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1524914679; Tue, 25 Jun 2024 11:39:00 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 24 Jun 2024 20:38:59 -0700
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 25 Jun 2024 11:38:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsnUH1VvWZwe2oVglLfy8zIAHobFyroDtu5S73Gicn9N+aZk7j9pXFyVD7wTNBsu9QvhWml7KSqfiaLqZmoJUtUtJdaONrXbFXA97dA+lFt845U5EeNAOJIcJbt3ydwWLP2wsq8YJSyOKLvJ7ApQL+yUbaLi/FeVG+CzcsXS9Pi5sZ3nN/r1eUJ0PeSI2Z1w5MiVmMwIT/OZRPnWuBwVEXeo4SSjtBiM46q7ussX84lgjrp4w8FQvc2M0//om0k0Ob9VgEO0rRU50Kx8UphjKVjhFQrufZbaBcRw7g/JrlvVHH5GRxKn4li6E8NbPz54AEjxDYqQ8vSCtKtdGRze6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGMODZ+r87pRnpa8OVwRkx6SjDcv2OSOeZkDOF5t6z0=;
 b=fX8RycAiR/9QTunlsVFhx6sYpJbSLIWK8dToYBeDv7MhJamJrioe1UxRcJ73WFH7+jX7pd1M2G6XoBeu1ip8jodhEgbtov5/ocRe2XeuCcNIz53s8tP5KZ/3HUszpu5Ngc/Hq8QDoJccaPSG9QnifPmow18xlLCjFtJCcUptCQUVM7+K+Z5hqyXupBoTTZydbdHtUnwsH8jPGXOeozhCOfEAbhWBEFqLUKyjwc6doeU/qATgcyDqkdoEkrCOFxK9Y9ozUbkkjppNwFh5PM3Qqnz/E8IoVIzexJ0J+S/bRLXHfX95UExy3Lx9iW+XiwX1ujelNcJnugT8Ac/h44SX+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGMODZ+r87pRnpa8OVwRkx6SjDcv2OSOeZkDOF5t6z0=;
 b=NOd8QeN8m2D//f2JLh/a+PxXgfuhwh3uO/sG9K9IPOVLer6qp5gGKj42JVz9oLcsH0dfJsmsP6pmLJ93ngHezarVSBO3Kx2guYWnHFqAibCuPWNi8LItKEtrPE3s1Q5YGldHwu/comTnFabqMQNnj42IPhSfI2kLfwzSJ7i5Qvo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6798.apcprd03.prod.outlook.com (2603:1096:400:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 03:38:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 03:38:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "junwoo80.lee@samsung.com"
	<junwoo80.lee@samsung.com>, "mani@kernel.org" <mani@kernel.org>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
Thread-Topic: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
Thread-Index: AQHauMKPrv1V1Cbu00yFMdEhxgAMv7HRN3YAgAWQsQCAAG2eAIAAux8A
Date: Tue, 25 Jun 2024 03:38:57 +0000
Message-ID: <ee45ce9429b1f69147c1a01e07b050275b4009bf.camel@mediatek.com>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
	 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
	 <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
	 <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
In-Reply-To: <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6798:EE_
x-ms-office365-filtering-correlation-id: 0adcbc83-8947-4bcd-ef99-08dc94c8581c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|7416011|1800799021|376011|366013|921017|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?dWkyOWNHems3alpBdGlLODJXWVVTUG5ZdVdjUVVtY3ZLTHBLUFY5YThEN29U?=
 =?utf-8?B?eFhCcmlQcWQwMTd4QjF3UEg3U3Vsd2d1b0E3UjVkM3dkL0tnVmJ5aVlZQUJH?=
 =?utf-8?B?OGdIUzJuS3FScVVhR0w4MEZieEFrUWZ0UnF0eW5HSGlmSGo3QjcxeVdLaTRj?=
 =?utf-8?B?RFdrWHIxRTBBdGZhOFUxMU9HQ1cvQnpEbVdOemZJQXQzZW5zalN5VDRxb3Zy?=
 =?utf-8?B?YTZiOU1TTGtkYlZzcnJzMDltUUttaFdlaExyaEJ0WldqbTFaaklieURxZzU0?=
 =?utf-8?B?T1p4SjZyVmVPcXFkc0RCdnV0eThlVmltRzZDSTliTFFRWnE4a25OaFVSK2dJ?=
 =?utf-8?B?a1JjMTZyZUV3d0M1WDdjcFJyeXZuaWw4VWQyWU5jbGpwMVpINXdJV29ZRERi?=
 =?utf-8?B?eVFoTE1hRllNYk13TVdmRXZtYWd2cnF0NTVPNWkzWFFWNjFDbm1vdXF6S2c2?=
 =?utf-8?B?cGN5a2laelVtSnlXMktoUGNNbWppTlhRUzdOcFdWZWRkYnA2L0RTVDhVVnNt?=
 =?utf-8?B?dDU1dDFSbUpIaG4vYzhBaUV1ME5la3RXOVhWRXVRWG90S2l5b2pRNyt1TDh4?=
 =?utf-8?B?akc5dkdjM0pnSEl2V01SamJ0LzhZNytnSFQyMEhQeHZQalN4bm14VFpqcWxJ?=
 =?utf-8?B?eWdMRE9XWTRoem5hYXl5NndOcFprVFVxVlFCTmN1eTg5bjE0WXZ4eE8xR1Bl?=
 =?utf-8?B?SHNVRFc3aHRBOXh1NHJJQ3lHeXNoNk1yczUzRVZ1bTRYazBRMUpmUW1PblZj?=
 =?utf-8?B?TWYzeklnUFZHZDNpRGt5M0o5biswSThHaEErbnlCdnhPMnkvRWMxeStRd1Q5?=
 =?utf-8?B?RzNTcEVOd3ZQMm12L0tpSGw2NnVWdHg1RWxsOHZOb0tKT3hCZEpEQTl4Y3Zq?=
 =?utf-8?B?bFBVb0NMTlBPVlJxQ3J5ZzF3WGRGNmR6R0NMR3BpRG5sQ2ZMRk1nUVEyUGV4?=
 =?utf-8?B?UXdFRkdWbjZITS82djBFQVFiaWpoSko4ZklFRHJ5eTRadU14Ykl2SVRKWGU4?=
 =?utf-8?B?b2E1N2Fna1pjL0VJVzFpdFJxaVFGMGQwKzhkbkNwd2FaWVZyRUhMclhYSmxU?=
 =?utf-8?B?VXBuaG9zZ2RzM2N0Z2JObi9ndmFWVDAzdk9ScnVsa2o2c0hvcU5SdHdpSy9H?=
 =?utf-8?B?elRFQjB0VldsYVJoRjVjaWgreEhYZmtoRytNOTQ2WVF3dkRITjhqdkJpbEFj?=
 =?utf-8?B?K2g2djUwekladzlEaGErU2wySnNTZDdVd1F1WG9DMTBuc05MeVo5UXJOMnow?=
 =?utf-8?B?YlJpM3FPVHoydFRoSStYQUFwcnZLWU4vek5jWmI5YXFSSks4N1lYbjlTeDUx?=
 =?utf-8?B?Y0R1Q0FwT3pJa2lrMXhCVnVubUNYSHZPUWZaUklHVEZnMVJVQ1hRSDJ5VHJI?=
 =?utf-8?B?THNyMjN2RFRzVFpZcXNjRUZWNkNRLzkwZFBKKzhjWVVheEh4eENWM2VnSnJt?=
 =?utf-8?B?Mm01bU1NdkhjejVwRlQyYVdCeTV2N1lUcFlTaUdDZ3B3aWowTUJERjMwSjR3?=
 =?utf-8?B?RVJjTEh4VGdydnBaMi9yUUYydDF2dVNkTlFaN2VycUZrOE9LN0hCS2VmVEox?=
 =?utf-8?B?a3V1NjZJQi9EOFV6ajl6U0l6M2pHa1BydmtZVmdMd0ZNdUEyM0JPazRtWUE4?=
 =?utf-8?B?a2hKOWpyNjZjekF3am1oSnY2Y3V4WC8wbXFya2xVNzZwMVE1ckN0TlhLaHNn?=
 =?utf-8?B?UUNBVVBsMmVrcG9TOFpGUW9MeDRDcnJsWThwMU1VYkZLc0xJVFc2dHlNaG5X?=
 =?utf-8?B?bVk5clJaU1FCSVZtZXNTeFZsTHV4UVNocHhEdjBGSTdWREJlczh6MlZlVHVV?=
 =?utf-8?B?dElYMS9jS0xPMkdxMnp3aXZuVVZFSjB6eldOYmFpbU1EeVgxVVlBeXlCckVM?=
 =?utf-8?B?UGwrSnlZUmZXaTI2REpKdy9ERGsxeFNidnNOanA3ZWI4b2doT3NQS1lXb213?=
 =?utf-8?Q?4OaI093y520=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(1800799021)(376011)(366013)(921017)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzhrM2JhdTEzQ0dkNkR3UHYyV2hKTi9ITG1HbTl1Wng3V0JhVWQ2REM0K1ow?=
 =?utf-8?B?V0JCbTBwOUpJY1Azc3VhYkpoTGd1eURpK1JzME9uU3BwWEcyeFVhK3NJMnVS?=
 =?utf-8?B?aWFsdHViMVdUUjU2SUo1K1JDZlMvQkpPNWtXOEliTmE0emFIR1RXZzlGS2Jr?=
 =?utf-8?B?TDVBdW1oaUo4TnM0eCtWaHVoVG5zcUJrUEU4SGJkNEJ6Q1k0TXpvbUVMa0RM?=
 =?utf-8?B?NXdOeVlxcmZVTWt3UDFNb2owNzZsTW9NVS8vUm5DUjZtVnBJR3Yva0VxdlF0?=
 =?utf-8?B?WTNtZGJTTHEwbFVlb1hDSURmcE9SQ1o1SUNRWlRQeG5XSFhPd1lVZ0d5b3Vv?=
 =?utf-8?B?a0k1alFCcHdZcEhocVdhWXFlNkMxV0lPRDZiQlpoTGYvNk54cG93SjY0WmUz?=
 =?utf-8?B?SkpWVzhkZ2RvcStva0ZKaWMzL0xGOUYxR2QyeW82dmx4N0JObzhTQ25qR1Bu?=
 =?utf-8?B?eHhIZ3lsSXpYanRiZXBFWDVOTGRWN2R1QTI4OVpKRk1pQmdBY1VQR1ZWWVdP?=
 =?utf-8?B?bnBzdTJNZ0djU1diU0JxcVlJUFk4Y0JnWWk3MFpMZk1ZRlIrRVVuNkhDdU14?=
 =?utf-8?B?OUF5S2V2R0lYancvamlqSVVuaUNEeWRtZy9jOXBPMExwWHlsY2lmQzQ0L3pv?=
 =?utf-8?B?eHFqZFpUVTF1dURYTFZsdDdWYnJtOUs0Zm5neXEvV2JMWnZTK1F0MWpSdy9V?=
 =?utf-8?B?TjVPNnU0VVgzZTRINFczRnZoV3VUSFFuWlN1YXFuWXROd004Mzg2OG5VbnQ3?=
 =?utf-8?B?ejd3YXVCL2JZQmxFaWl6U1hNYUJJM2lKbVBBQWpCQUE1c01ZY1U5bk5iVlVr?=
 =?utf-8?B?Qk9YSkNBMC81OExrK2FQaHh3akNqUnNkWUIzaVB5TnlLc0Z0T0czN3AzSzJL?=
 =?utf-8?B?OFZqTks1bWZ5WXY5TWc3MU9kaTUrVmx0cjkwOU04eVRWQUhlcTZudU1hd3NU?=
 =?utf-8?B?bktJM2lnRndNb3lzY3ZncW4yRk1aZlcrcUdHcVlkNGRmWXgrOUVpNGhESUFI?=
 =?utf-8?B?a2hGbWpTbHRUZG10N1VnNDc1V0NOcnovZGV2SDN0WGkyd3RMcnVvTEFLRmVD?=
 =?utf-8?B?cmEzTHFEdFVjVjJmYitEUG5ndjZXakJUT3FpdjZPdEJLS0tUckJrejV1d2ZD?=
 =?utf-8?B?L3FUNFV1K3o3L3A1Sk9lNk9xZVFhcGZUY1ZiQmNBbWttdVRWdXJENUxqZHhL?=
 =?utf-8?B?aVR4akhmUzV6QjhIcVkrY1VjSE04UVdGbkV6OWxaOEdaMDlwRkdPb0FmUmhR?=
 =?utf-8?B?cXBxY0tqOWJyTlVoSDhlWEFUdmFUZnJRcmkzR1ZOaTBGbjRobldyTmtkd0t1?=
 =?utf-8?B?aklxcTVVQ0Y4OUtoQ1hYb2xXbktWanVLVGNzbUZvcTNSQlhDelRQQitDN1Ev?=
 =?utf-8?B?MzRYYmRLczU5T0tQdHYxc0c0dmZpQis1ZFJoTmlTc2g0T1F5Z3QrMWRiUk1j?=
 =?utf-8?B?WFlObzJhdFNXQzNmQSt1ZllaOWFvYWc1S0RmNnFIQnhsRURzWWppNm1pWkx1?=
 =?utf-8?B?ZFpnelcwV1FGOFZsZ2wyU1dETGVxeFFyYjFJRWdRRjVsTHlsbWpuM1VtcHRv?=
 =?utf-8?B?WVV2eENhQkpzRTdSUS9jUnlwZWhzUStHTHBuT0lQdWRGOUxkbjI3ME9yR1U3?=
 =?utf-8?B?am83eHRVZDhCUlRaWTRaUi8va0dQSEJBUFpPOXA1anlZbUcxbS9IbWpzV3gy?=
 =?utf-8?B?YllXc2hCU2ZPTnEyc2kvbGpUWmJYdlVDV3B5a1hIekNEZWR5YVlxTEs4U3Rl?=
 =?utf-8?B?dFE4WlQxZHNQc3VhNnEyTUx4VlQ2cXdtTjlNR3hOWjVkNzEwQzZpZHhRUWI4?=
 =?utf-8?B?RFRMOGR4aWFyNE5ESHpDOXgwdnhTZ0IvSFB3cGI5M0Fqd24wOXNaZm8zTW1U?=
 =?utf-8?B?K3J5WWFYT05BR2hVc21XWndncTJrdWVWcVVaWXExelhlT1JqWE5YU2VIV1My?=
 =?utf-8?B?SURIczdWWHpnU2I0VXZRaXMxOTBmNEpUMHRBSXB5K29hUVFaK2ViSGNLcWdx?=
 =?utf-8?B?ZzlPREp3dGRDbkRWdS9XTndOMWlCSXVWZ0xpZFM2N1JLek14SE1VbC8wVERL?=
 =?utf-8?B?Unh0d200L0paVExBT3RFSHdiaGkrOFhodjJtVWI2OTNabG9zVk5MQ2JUWS9S?=
 =?utf-8?B?QkJuZ0NjMG9DYTNVWHZmaVc4Z3pBYndnQWVXQlQ3TVN6OEQ5dGs0K0pDa0lZ?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47F603C0B256164F90EB2827794BFAE8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0adcbc83-8947-4bcd-ef99-08dc94c8581c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 03:38:57.1835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uxB4wChhxaAagDSb9u/yw3RxT/S0QkDrJ29gNRiQDmOpGRwQKA//pfm3oUKWfS86DkOpsprthryKFq8fuisqOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6798
X-MTK: N

T24gTW9uLCAyMDI0LTA2LTI0IGF0IDA5OjI5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yNC8yNCAyOjU2IEFNLCBaaXFpIENoZW4gd3JvdGU6DQo+
ID4gMS4gV2h5IGRvIHdlIG5lZWQgdG8gY2FsbCBibGtfbXFfcXVpZXNjZV90YWdzZXQoKSBpbnRv
IA0KPiA+IHVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3RzKCkgaW5zdGVhZCBkaXJlY3RseSByZXBs
YWNlIGFsbCANCj4gPiB1ZnNoY2Rfc2NzaV9ibG9ja19yZXF1ZXN0cygpIHdpdGggYmxrX21xX3F1
aWVzY2VfdGFnc2V0KCk/DQo+IA0KPiBCZWNhdXNlIHVmc2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3Rz
KCkgaGFzIG1vcmUgY2FsbGVycyB0aGFuIHRoZSBjbG9jaw0KPiBzY2FsaW5nIGNvZGUgYW5kIGJl
Y2F1c2UgYWxsIGNhbGxlcnMgb2YgdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoKQ0KPiBzaG91
bGQgYmUgZml4ZWQuDQo+IA0KPiA+IDIuIFRoaXMgcGF0Y2ggbmVlZCB0byB0byBkbyBsb25nLXRl
cm0gc3RyZXNzIHRlc3QsIEkgdGhpbmsgbWFueQ0KPiBPRU1zIA0KPiA+IGNhbid0IHdhaXQgYXMg
aXQgaXMgYSBibG9ja2VyIGlzc3VlIGZvciB0aGVtLg0KPiBQYXRjaCAic2NzaTogdWZzOiBjb3Jl
OiBRdWllc2NlIHJlcXVlc3QgcXVldWVzIGJlZm9yZSBjaGVja2luZw0KPiBwZW5kaW5nDQo+IGNt
ZHMiIGlzIGFscmVhZHkgaW4gTGludXMnIG1hc3RlciBicmFuY2guIEkgd2lsbCByZWJhc2UgbXkg
cGF0Y2ggb24NCj4gdG9wDQo+IG9mIGxpbnV4LW5leHQuDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+
IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpCdXQgdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMg
dXNhZ2UgaXMgY29ycmVjdCBpbiBTRFIgbW9kZS4NClNvLCBJIGRvbid0IHRoaW5rIGl0IGlzIHVm
c2hjZF9zY3NpX2Jsb2NrX3JlcXVlc3RzIGJ1Zy4gDQpBY3R1YWxseS4gdGhpcyBidWcgaXMgdHJp
Z2dlcmVkIGJ5IHRoaXMgcGF0Y2guDQo4ZDA3N2VkZTQ4YzEgKCJzY3NpOiB1ZnM6IGNvcmU6IHNj
c2k6IHVmczogT3B0aW1pemUgdGhlIGNvbW1hbmQNCnF1ZXVlaW5nIGNvZGUiKQ0KV2hpY2ggYWZ0
ZXIgdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMsIHVmcyBjYW5ub3QgbWFrZSBzdXJlIG9uZ29p
bmcNCnJlcXVlc3QgDQppcyBhbGwgY29tcGxldGVkIGJ5IHVmc2hjZF93YWl0X2Zvcl9kb29yYmVs
bF9jbHIuDQpUaGF0IGlzIG1lYW5zLCBpdCBpcyB1ZnNoY2Rfd2FpdF9mb3JfZG9vcmJlbGxfY2xy
IGJ1Zy4NCg0KU28sIEkgdGhpbmsgdWZzaGNkX3dhaXRfZm9yX2Rvb3JiZWxsX2NsciBzaG91bGQg
YmUgcmV2aXNlLg0KQ2hlY2sgdHJfZG9vcmJlbGwgaW4gU0RSIG1vZGUuIChiZWZvcmUgOGQwNzdl
ZGU0OGMxIGRvKSANCkNoZWNrIGVhY2ggSFdRJ3MgYXJlIGFsbCBlbXB0eSBpbiBNQ1EgbW9kZS4g
KG5lZWQgdGhpbmsgaG93IHRvIGRvKQ0KTWFrZSBzdXJlIGFsbCByZXF1ZXN0cyBpcyBjb21wbGV0
ZSwgYW5kIGZpbmlzaCB0aGlzIGZ1bmN0aW9uJyBqb2INCmNvcnJlY3RseS4gDQpPciB0aGVyZSBz
dGlsbCBoYXZlIGEgZ2FwIGluIHVmc2hjZF93YWl0X2Zvcl9kb29yYmVsbF9jbHIuDQpBbmQgc29t
ZWRheSBzb21lYm9keSdzIHBhdGNoIG1heSBzdGVwcGluZyBpbnRvIGl0IGluIHRoZSBmdXR1cmUu
DQoNClRoYW5rcy4NClBldGVyDQoNCg0KDQoNCiANCg==
