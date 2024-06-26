Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1405336A;
	Wed, 26 Jun 2024 03:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719373932; cv=fail; b=SHJItIqANtFxspqj2wGrLz62dVoc45LGQT+I6DXTn/I+UU+QjOgSVGiB75gRzV+qjsIC93y8NA5P1UrC3mcPTGqB2kKBNjT9W2AwE/3h2PQGPB/HjuGYRhjd+YlokxNUx9O+oFpshtDe3+F0eb4IVhHMkBsOLo0ugtC6u7zGBKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719373932; c=relaxed/simple;
	bh=Ex6O6S2ltkouHKre1zAE5n2R5Nz3LDrXVuYwfoMf+8w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J7TcWhNsS45xhoZRyL2NKlawXpqPikJqbjq5zGJrk2z3BQve0sgfwj9OwVlf2u6VCMW7bAXOozjx2lB92mRQxKmkE8Q3VIPjDJPwc1fsjNcNgtMUv8aK+59igDPFII7wDPhaImVkEIbkDC7EFhAFjWepYZlKz1lOb1PJr/uFspA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PG1DRiF+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XPzhjtnO; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PG1DRiF+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XPzhjtnO"
X-UUID: 74d19cf2336f11ef8da6557f11777fc4-20240626
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Ex6O6S2ltkouHKre1zAE5n2R5Nz3LDrXVuYwfoMf+8w=;
	b=PG1DRiF+EVtHEyNGLeBd6e4HNLQhEAQUIQD6+SBBxQIU+xLn2bBIiR9npkZK8D/UhURQRA6hZrzTqzvLr9QC4OFGausq3uVYhe/ozTrW1TPnw9MsMUzAkcgZfwqDTTuHe2qNv6GDAG1aECtLZMJ23sCZHbkPis71IK2djZKwHrA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:c3d01cbd-ff9c-408c-b074-38761e008224,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:60437194-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 74d19cf2336f11ef8da6557f11777fc4-20240626
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1818071397; Wed, 26 Jun 2024 11:52:06 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Jun 2024 11:52:05 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 26 Jun 2024 11:52:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJTDam2SHZqzK1unWjsb8c71ZiVIe/7Tp7WAOH0eI974+GsUfO1+iK2h8t9kCl0QYKZxTGFAMwWHS0Bhmp/wCs/O6zAvj4OR0ercepNvKGDepuL581QmevjX3EMKfZ1QoMmXGj79Znh7E0d0r12DCDRUkqPUgAImXmvEs6KoqRMqmZyZdkAIhIDWtZBelXqBV0S+iUMmKWHMyvKWDQHZXgwZSWC8MQodsvR6pR73d+Wpy9L+jJtlKawggSMs6AVQFKxcnkYldbiUAhsUKQp9DJ0bqCyMhh/sQ8g/P1jdpw5s2KbGqvHyNG9zHBZi49udE6mjkyxNvGQAa1/1LQ0HDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ex6O6S2ltkouHKre1zAE5n2R5Nz3LDrXVuYwfoMf+8w=;
 b=ADDXLXVP5Olg5ErN3jECDz2mLFAl88xqMELeFhuxaCSIIasAPs4VQSKTEwnJ6pS5L4wOBykv9kC++2tgdYjZ79jhfP8Zdwoa4YA8VmTLeJ7TjqnEW0ahKHloSrMISHx4zo/GhoJx+UCatIkFBaW6Ib2W8RSTLgsQkSatgJG1sNxp+Z3RV5NIBdXV1KaFEo2AorgLdeQjnfZiqnVaj30vaLk0Nx66Nataj5hvwvrOAEvYiM02NgKvy518ZuiFp42USl16ghNeS9JpmSuZhEhXk1Mc1SccHTxOugItST+8ErnmH0W1VLOTCJQ/peja0PkJ6GfaDHnNLoJ2cJPDJIviIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex6O6S2ltkouHKre1zAE5n2R5Nz3LDrXVuYwfoMf+8w=;
 b=XPzhjtnOYATJtAHfJvRXmumQX3KZB0uFebBNgv54rNgAaA55/RREedq/2/Fghqx0rWwB8byQsw7UjLyozgTknU2lwv0DfgzvV1E60U4nMngGbCeTS/wAdloGpdLfr7Qa8Z2swuoyYtGqTo+bqA/pDuowak1snyEvtsbTxZj+q0I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8536.apcprd03.prod.outlook.com (2603:1096:405:68::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Wed, 26 Jun
 2024 03:52:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 03:52:03 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>, "beanhuo@micron.com"
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
Thread-Index: AQHauMKPrv1V1Cbu00yFMdEhxgAMv7HRN3YAgAWQsQCAAG2eAIAAux8AgADSy4CAAMMzAA==
Date: Wed, 26 Jun 2024 03:52:03 +0000
Message-ID: <e1517d77307e4da0708003f847e456ba4831d9bf.camel@mediatek.com>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
	 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
	 <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
	 <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
	 <ee45ce9429b1f69147c1a01e07b050275b4009bf.camel@mediatek.com>
	 <3c7e776e-df2e-4718-995f-5e5dfa3cc916@acm.org>
In-Reply-To: <3c7e776e-df2e-4718-995f-5e5dfa3cc916@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8536:EE_
x-ms-office365-filtering-correlation-id: 8883d1e7-4cee-493e-3a4b-08dc9593573c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|1800799022|366014|7416012|376012|921018|38070700016;
x-microsoft-antispam-message-info: =?utf-8?B?OHVqSUdxUy9sZmNhVG80RVNQNmhLMGdJb3RuMUFTNDd6L0pKdGMvT2M4c3JX?=
 =?utf-8?B?Z1gzNFpaQlNkSWwwNUlvQ3BwVFg2VXR0QlllWHA2NWV6MjB3OTRYalZPZVhW?=
 =?utf-8?B?NlI2RnhjK1hKMmk3c1R3RkFrM0tDYzNic0NPUTZORlJRN1RMRlNjQll3Ym01?=
 =?utf-8?B?WXVDeTN3ZUtnaG1MNWt2Q3RLeHV3UG41QkE2S21OaVhpSlNNT01wdWlsSTJB?=
 =?utf-8?B?bFdPeGtzcmFIcHB4aWNnNFN2NEJVMUlicW04VFFyU0dpS1NoUU9XTGc3Uzla?=
 =?utf-8?B?NUJYWkF1RTlzSWwzL0xTbFhaYUFNQmxMeFB0TW5IMzBmMS9sNnRnbEh2cE1M?=
 =?utf-8?B?SXd5dnNURFk5MDBwSFhzSVNkZWsrcGFUeWZBaHdlZlgya2s3UXIwcC9WU0lV?=
 =?utf-8?B?cWpPemVXZFBRVmdtbWR2dGQ5UzBwclZ3M1JyaVJNV1lSQjAyWDQyaEsxeWt0?=
 =?utf-8?B?TGFaMnBFMFpKTlBpcUxsZWFtM0FaRnlmTGJ0QktrT09qcURjc0p3RHlIMGRo?=
 =?utf-8?B?aGRvUXlmNjJFYnREMUtDZEYvVmR2bzI3R0lMam92d1BaWGs2cXJ2MEhPL29G?=
 =?utf-8?B?dVUwZWVKV1M3aWhXbGdrVzlKZExacFB6WDdEMDFlOEhqKzBUWDVjbmpvOGp6?=
 =?utf-8?B?Y3FOWFVkUndQdkpaTWVSeXd0dU5JKy9sMnlQeUs2NDk3ZlJTMkt6YnR3QThs?=
 =?utf-8?B?WGp3NUkrUitaMUpOaDVKZFNoQk5MTWVQeExhVVY4TmdwRkdHMU0vZGhTUnl5?=
 =?utf-8?B?THVoL0phWGM2WmdVK2cwRjhvYUtPOXhIL0RFWGRaNWMyc01EWlpLQmpQQzR5?=
 =?utf-8?B?SHIzVmJ6bXNQRVdoZmx6cjYwMHNYZ2lvNUNoZDFTMGUwbEl6d2t1L3crV25z?=
 =?utf-8?B?QkRhdW5PNVdDZ3RyV1lHKzJwZ1hiWHdjMnRmN1I4SGFBQjZDZ1dHZFZzWWVw?=
 =?utf-8?B?eGpOeHVNbzVVSTlCMjg0aGJUMWxDRGZxSGFPR24ycW00czczNWJhUUk0Y080?=
 =?utf-8?B?cElPaTA3STlYWUJFQ3JqODFKalVxR1NWVFFnMHg4ekpYTFlOMDNEY3EzS2N3?=
 =?utf-8?B?Tm1xMlQvMjVHMTE2WllmM2xGWXFtZWMvZXAyZ0tSUVhuVXNDVFdVUEIzTWUw?=
 =?utf-8?B?M0t4ZW9nL1Y0c1dDZ3ZqZUFJWmJhS3VCQUZBdGNvUG5QbE93K3J0WEdJeDl1?=
 =?utf-8?B?OE5BS2U0WGViOFdqMmFBQkRnMmU0UmxETE1ralgvdnhyTGtLbWd2cFd3YkFS?=
 =?utf-8?B?RTNZN0svQzZPeGx2THdCelBwR29lUjVvMm9CSWV1L3lYaU12dDFkTXlwazNu?=
 =?utf-8?B?bVpBZ1RVTEMzUFFRZk5na0VxU25lTHc2b2x2UEhLTVUvVnQwU2RTQ2syS1FH?=
 =?utf-8?B?VkJYR0YrUW1SY1ZuZjJGcCtTTDJlb1NYUnVFa0pkUXJpYnBRdVFkVDI3OTV1?=
 =?utf-8?B?R2w3TUNpNUNwcnFxQTQwTlZQdTlwTUd5c0dzUk5CelQ0SzkrSkFLb0k3Uk5U?=
 =?utf-8?B?dVZUYVlRUFBMY1l2eWJieFBPN2tVWWkwRm5FTlppOWpLSnNIVzVCTzZ5dE9x?=
 =?utf-8?B?NCtpcGJoOGNiTGpkWTA2MWxScHVha1JwLytZRnd4RVdadXV5b21UU2JKZTlQ?=
 =?utf-8?B?c2pEQkdCQldNM2JJeEh0bjdldy84WXZZdWd3WTlGS2JwWTdCd3hYMWRDS3ZS?=
 =?utf-8?B?Nm4zYThaYzJJakk0eHJ5a1FVQ0tpUUhZL1pZR0R0dlhkUkhrY2JXVGFGdEpD?=
 =?utf-8?B?eDRaKzJUWXQ0RHZ1MkJlQzEwd1ZvTUQyZEoxTWxaTmt2L2xSMk5HcFlUKzR3?=
 =?utf-8?B?SUQxbElNREY1Q3VLTU5lUUdSZlIyam1XWlNpK0hZandYZWZ3NG5lWENwSWxF?=
 =?utf-8?Q?wtre3HHLPBRe0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(7416012)(376012)(921018)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkEwRXNZamxTRWhqc1dXN1VPTFNpZ2pxOGE3VVR3MjJkVGNob2dLbkJ4RE9p?=
 =?utf-8?B?ZmZLckNjNjFtUkJaVDlOaERiTW1UUU9HTVFhdlgrK3JTS2dqeEVGeEQwQjhy?=
 =?utf-8?B?SlJ0RWg5TjNub1FSbWoreE5PV1JpU2FCcU1QdURwa3VsTjVrRFFJYzB3eGNk?=
 =?utf-8?B?eitDdmltSGpycWZaYkRZejFwOW54OHBuVUpjcS9NamJpakpwQ1BQZkw1VzJP?=
 =?utf-8?B?WmxxOGY1S0J3b2dBcGVFeTNVcHk5N1Q3bGdoWFlOVlMvSXV4b1hjSkh1T0dO?=
 =?utf-8?B?TTRQRlhhUUIxUTVlSTRVVENETkRqY0s0bE5hWlV4QnduRkpyRFZWQ1MramN5?=
 =?utf-8?B?UlFIZGZoR2JVR0JyaEo1aWY2OFV4MFpGK3BsOEplcXVSNVdlQXRoY2NKeXBj?=
 =?utf-8?B?SEVjcjg1ZG85ZjNubnQwb1RSLzVGRi9zU0VjNlUwWk1YS2s4eGE0VVpmOWV3?=
 =?utf-8?B?ZVdEZE1aWm0vUEI0SEhTUUZ2eDVqeXNLcExsSUp4aUlPendCZkVnUGI3QkR5?=
 =?utf-8?B?N244VDlwRVVJcCthd1FoTFh5NTQwUFlLa3R5dUpuMC8rOUFRaEZSaWx1TkRy?=
 =?utf-8?B?dEF3QjBrbFY3VWVsaERaUm1ENzZYNkREWWlJKzkrT1hVdjkrN0s2SkxoRnFu?=
 =?utf-8?B?WjlIck13L21Kcmh4VGF1ak9VSkVjbFB6V2FvQWpQTWNWc0VOQU5KVmJIWUhi?=
 =?utf-8?B?Y1JGOEtxMWVyWmVVRjdMQSttQUgxaVkxNGIyTGE2MjE0UURwRDJzdkthZ0Z3?=
 =?utf-8?B?ZHFCUG9iSlJydVZzVE1ISEtaRlgzSnk0ZnhqeXpvdWVvTm1GdGFWdUU1R1Ri?=
 =?utf-8?B?OVQzbG90OHo1U0ZFUk8yT2dHdVltOFFNcUducURlc1ZpbE9BVlBwVnI0Rm5h?=
 =?utf-8?B?K3lVcm1EMlpFYUlPMlVVdDRtVzRLZFNRdC9pWlZUMmJMMnprNjRKVU5BZSto?=
 =?utf-8?B?V0F2N2VXZ3FuQzBoRTc4MTlySVREUUtRZlBxeUdoZjFHbThtakpkNGIycUJk?=
 =?utf-8?B?RXN4eFNxSVlySm1zMmF2SDNpbmI2UDR0OWMrdEkrS1FYZTlwSDVLZ013VVpR?=
 =?utf-8?B?K2ZneEVlbHl6bGR1VTlQUWJ3SVNZdm5IRmVRaXZOV1FOVFBtVkowL04wMDZh?=
 =?utf-8?B?NjhGTDZzSldQQkFxVkcxQ29tKy9mL0hkQXR5eFdlY0t5S3AyalVWeWVReEFt?=
 =?utf-8?B?MGx5Vk1CVGZVei9KQnh5M0xDOWFvbktZbVhzbVJ4dkZDMnZXNDJzcGJQNWY4?=
 =?utf-8?B?eEJlL09pZldtalNCZUpXb0M0NUw1aGdOL3hTekpuNXFneERiSkZoYW9VNWdR?=
 =?utf-8?B?akR1R051Nit1SEZDMHhCME1WZFE1SjUxWVRqeFUrd0pzWnZuU2RYSFZjMkpN?=
 =?utf-8?B?a0lwQWdwWW5qUzhmeEtxeDEwZkl6aHk3dU1FdHo2UVlhUmR6aDBhc05mNkdk?=
 =?utf-8?B?bjFkVWpCM09YUFRLR3lwWXQ3eE5RWms5bWQ5Ky9mZmRpRVhyTFU3Ni9nU2F5?=
 =?utf-8?B?eW5zZzNQUVRzZUxOdS9JMHFUWXJyOHdhUEt5amxhbCtVMEhLL0taNlBaT2VE?=
 =?utf-8?B?d1QvZTUzS0h1MnhQR004RVgwK29HZmhWU2lxT2drclZ5Z3VnMC94VVZURzlZ?=
 =?utf-8?B?QW5NVjh5Q2V0ZnJubW1FQnNPTmp3Nm1ZOElUVzc5emZ3ejkycTZtdkxLVnNo?=
 =?utf-8?B?endvd1pLN2J2YXBQOWlZbEM1Z0FzMjVqbHpVT0tjd0Ixd29Vem1kTFY3SXBM?=
 =?utf-8?B?aGQyaXNLY1hrOUFQK0l6b0NOSzZlWVNzS2tUWmpibWQwUlNDTytrZ201L2pi?=
 =?utf-8?B?M055MmVLb1BobEoxekdrQkU3bzB5WTdZL1BLK3YwS1ZWTWRZU0M2dFZMK3FC?=
 =?utf-8?B?bkg3dlByNE1LUHJSVDJPUEl3RmNyNlZYSHUwM0Q0Z1FmcVpkRHI3YXkzUk9v?=
 =?utf-8?B?QVhsOHBHMHdjNEF6ank5bDlLZisyTUUvb0hZSWFLaUlCQnN0RUtEamdJOTdY?=
 =?utf-8?B?Yi8xRWRXQ2prc0l5aEJweTVBSUxnQ0Z0MlZuMGl2Z1NnR21wei9kU3BqMjUr?=
 =?utf-8?B?dWMxbUw1UEt6Q04yTXhLZUZLKzh5NDdnUG9RY2pWVEdHaWcwNWZqNGZyWjQ4?=
 =?utf-8?B?MWt4blF2d054WnQ1ZHZVSlIyQVVrQmRXZ2E3REI0TTJwa1dwMDg4YzZ2aVIw?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2A85EE091700549AA3BF9CC8613615C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8883d1e7-4cee-493e-3a4b-08dc9593573c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2024 03:52:03.5545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GQ2xn6ZcMO4UU/o8OTzWi29JmJZgTqjUJO1ieyX/hMhydKXbHyLVoRMd1oQuvcbtb4vPF5Bxlnp7+PAit/uinQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8536
X-MTK: N

T24gVHVlLCAyMDI0LTA2LTI1IGF0IDA5OjEzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNi8yNC8yNCA4OjM4IFBNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IEJ1dCB1ZnNoY2Rfc2NzaV9ibG9ja19yZXF1ZXN0cyB1c2FnZSBpcyBj
b3JyZWN0IGluIFNEUiBtb2RlLg0KPiANCj4gdWZzaGNkX3Njc2lfYmxvY2tfcmVxdWVzdHMoKSB1
c2VzIHNjc2lfYmxvY2tfcmVxdWVzdHMoKS4gSXQgaXMgYWxtb3N0DQo+IG5ldmVyIGNvcnJlY3Qg
dG8gdXNlIHNjc2lfYmxvY2tfcmVxdWVzdHMoKSBpbiBhIGJsay1tcSBkcml2ZXIgYmVjYXVzZQ0K
PiBzY3NpX2Jsb2NrX3JlcXVlc3RzKCkgZG9lcyBub3Qgd2FpdCBmb3Igb25nb2luZyByZXF1ZXN0
IHN1Ym1pc3Npb24NCj4gY2FsbHMgdG8gY29tcGxldGUuIHNjc2lfYmxvY2tfcmVxdWVzdHMoKSBp
cyBhIGxlZ2FjeSBmcm9tIHRoZSB0aW1lDQo+IHdoZW4NCj4gYWxsIHJlcXVlc3QgZGlzcGF0Y2hp
bmcgYW5kIHF1ZXVlaW5nIHdhcyBwcm90ZWN0ZWQgYnkgdGhlIFNDU0kgaG9zdA0KPiBsb2NrLCBh
IGNoYW5nZSB0aGF0IHdhcyBtYWRlIGluIDIwMTAgb3IgYWJvdXQgMTQgeWVhcnMgYWdvLiBTZWUg
YWxzbw0KPiANCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXNjc2kvMjAxMDExMDUwMDI0
MDkuR0EyMTcxNEBoYXZvYy5ndGYub3JnLw0KPiANCj4gPiBTbywgSSB0aGluayB1ZnNoY2Rfd2Fp
dF9mb3JfZG9vcmJlbGxfY2xyIHNob3VsZCBiZSByZXZpc2UuDQo+ID4gQ2hlY2sgdHJfZG9vcmJl
bGwgaW4gU0RSIG1vZGUuIChiZWZvcmUgOGQwNzdlZGU0OGMxIGRvKQ0KPiA+IENoZWNrIGVhY2gg
SFdRJ3MgYXJlIGFsbCBlbXB0eSBpbiBNQ1EgbW9kZS4gKG5lZWQgdGhpbmsgaG93IHRvIGRvKQ0K
PiA+IE1ha2Ugc3VyZSBhbGwgcmVxdWVzdHMgaXMgY29tcGxldGUsIGFuZCBmaW5pc2ggdGhpcyBm
dW5jdGlvbicgam9iDQo+ID4gY29ycmVjdGx5Lg0KPiA+IE9yIHRoZXJlIHN0aWxsIGhhdmUgYSBn
YXAgaW4gdWZzaGNkX3dhaXRfZm9yX2Rvb3JiZWxsX2Nsci4NCj4gDQo+IHVmc2hjZF93YWl0X2Zv
cl9kb29yYmVsbF9jbHIoKSBzaG91bGQgYmUgcmVtb3ZlZCBhbmQgDQo+IHVmc2hjZF9jbG9ja19z
Y2FsaW5nX3ByZXBhcmUoKSBzaG91bGQgdXNlIGJsa19tcV9mcmVlemVfKigpLg0KPiBTZWUgYWxz
byBteSBwYXRjaCAidWZzOiBTaW1wbGlmeSB0aGUgY2xvY2sgc2NhbGluZyBtZWNoYW5pc20NCj4g
aW1wbGVtZW50YXRpb24iIGZyb20gNSB5ZWFycyBhZ28gDQo+ICgNCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGludXgtc2NzaS8yMDE5MTExMjE3Mzc0My4xNDE1MDMtNS1idmFuYXNzY2hlQGFj
bS5vcmcvDQo+ICkuDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0
LA0KDQpZZXMsIHJlbW92ZSB1ZnNoY2Rfd2FpdF9mb3JfZG9vcmJlbGxfY2xyKCkgaXMgbW9yZSBy
ZWFzb25hYmxlIGlmIHRoaXMNCmZ1bmN0aW9uIGNhbm5vdCBtYWtlIHN1cmUgYWxsIG9uLWdvaW5n
IHJlcXVlc3QgaXMgZG9uZS4NCg0KVGhhbmtzLg0KUGV0ZXINCg==
