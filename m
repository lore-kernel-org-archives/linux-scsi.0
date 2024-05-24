Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910E722331;
	Fri, 24 May 2024 06:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716530822; cv=fail; b=HP5bEiNghj1MAGHutYN864BpXxKm+su25FvUcf2L0YM/LYuwdtrPPIUxoWtUbe9rrd/M0vhh+rDLSqmeEDiaWUJJDTf2A6I6q9VXDmz/w1+xf3MV++RuXVNPWlnEKlLGXgnV+UzuAgqzHVkZTELeX1fXVbwVfOUStc6IJJIK+oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716530822; c=relaxed/simple;
	bh=pOWKC++1++RPJycn7bu/bJgAd7/XDCDGaZKT/ja5Rpo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cFUaDJfPlY+lbpc5j+8O+CxunECTHwKa38SvEoN/XuMPEGcZqmKczsZgVBjAOiFeYYcjjmmXCcW95DG6lzuXa2sinJ/aykL6njBcY6LAU72OMvoOfdkGtIb715W09cfxvboZKlWkXLZ5EdUOF2LI+ggnvTJ6rrBxe8S1jYtHMws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=d+yHdEVf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=cAYWillh; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="d+yHdEVf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="cAYWillh"
X-UUID: d0bf3bf0199311ef8c37dd7afa272265-20240524
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=pOWKC++1++RPJycn7bu/bJgAd7/XDCDGaZKT/ja5Rpo=;
	b=d+yHdEVfPltfp8GU4O7tET1NAchmCWCtuxHc/2DrC7gsGoy9axwSSYyN3boLYdQdp+KshQ+2zqOVKO2Uq5Ff3gQd9nmoIyz5vASjDtRi9WR1QUpuCxmzBF4GlajUnAHlmife4JqTo+gDnv67MTnzBg92s/+S6f+xL0Cn8edqK5o=;
X-CID-CACHE: Type:Local,Time:202405241404+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:413c0fd5-a00e-4f59-b858-337d0bd4306c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:82c5f88,CLOUDID:e07f7efc-ed05-4274-9204-014369d201e8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:1,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: d0bf3bf0199311ef8c37dd7afa272265-20240524
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 425319477; Fri, 24 May 2024 14:06:52 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 24 May 2024 14:06:51 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 24 May 2024 14:06:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5fNT4c69JBux3EBTfCRlXq3niAoioCwgfjBTO6Ok7QWDxe0xKhS/LXhjbh/f15TbwMTvbF6zQM8vgOir9ieWUASe2W7DNN34kitpgU55gU5jo20CFGfv7Ym4q03QnsY1snSSIRYP3faYNs9VKMj5k9/KompKAhzlLid9AeWq4YEryVylY71ixZg/6yFKaDaHbbGKAKmop1NOo21EYgUNirXG4J8wA2MA5k+nzDi5f9BwM9WJrHdPlKqxiB6YkeDcluY9F+6qEPiJb0oELjj1lmYAUMvEXYTolsyk53I2cX64pfCBZewl7iJZenegNnbpNrhWOdCmew/wuBnXGp6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOWKC++1++RPJycn7bu/bJgAd7/XDCDGaZKT/ja5Rpo=;
 b=VcEfgyJ1cjfCHbw7I2IHpsF7YLpe4YrCb3d1+Mr8M3l0o2M4xdVoLrPrJMAQlQjmvXgvGfQnmy1k+heBMI85k3+BYLG4d1MYSGjJWligqRO4xE2C01XVXfFIYR1Lswwt1ifR3+2GOGTq07W3CXW7Q8QdvEOR6GmMd9kye3sP3hyE/qBiLNnVDH0RGw/gGufmG1h05j9LiNW9a8qeI3dfhJ7ggta/IpBEXomnJdirh6XNyOxZmzU/EdpCQBxIalL1Hj46HfoWHT2WTNEcrjaKlzmiwpw8iGsbGWVyscsQVCRrf0YC1QCym61wQbtqNtVgmkypLUCTp1oY7cPFyrvFgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOWKC++1++RPJycn7bu/bJgAd7/XDCDGaZKT/ja5Rpo=;
 b=cAYWillhqN0pl56yFfsLt9jsOgZ+WV9QVHhs1ciBFqfHr2qvHqsOrOMgmXHed/Zvgatt94ye097j3QL/Srhn7z/jNZe4C8l8AdhpZxF89kaQ53JoyBMz5TroFYJ5G7tCTXmMuXwhLb+/qFR8AX1Fl8icnq34CbilFbMY5AbXKuU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7106.apcprd03.prod.outlook.com (2603:1096:820:d0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.17; Fri, 24 May
 2024 06:06:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 06:06:49 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "hch@infradead.org" <hch@infradead.org>, "Avri.Altman@wdc.com"
	<Avri.Altman@wdc.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Topic: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Thread-Index: AQHarREB5gyPI+xeYECfbFS+beiFrbGkySSAgAABmICAAAC4gIABG4kA
Date: Fri, 24 May 2024 06:06:49 +0000
Message-ID: <0a57d6bab739d6a10584f2baba115d00dfc9c94c.camel@mediatek.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
	 <20240523125827.818-3-avri.altman@wdc.com> <Zk8-rwjFvgP714Mn@infradead.org>
	 <DM6PR04MB65758584960580363D43AED4FCF42@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <Zk9Anwk1HEjUzSxc@infradead.org>
In-Reply-To: <Zk9Anwk1HEjUzSxc@infradead.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7106:EE_
x-ms-office365-filtering-correlation-id: 7b596697-3e46-4ba0-b218-08dc7bb7b2fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?S1FLN0hkY0duRllZaU8zcS91eFhuYnBOeDBSQmt3RWVCVnF0alM3cmhkclZ3?=
 =?utf-8?B?WWhNMkdRNnRXQmc1dUxsQTNUdGhJeUtFSVVmY3lPdHhUSkpaZXZjQjEvd0F1?=
 =?utf-8?B?d1QzN2hkbnEwNWgxek5oUmhIWkk2NHo2dDhGeDdwdDJNaSt1OTluUnhsaXEv?=
 =?utf-8?B?VVk1RGQyOUFVSWI0MzZMZ0NhMlcwdmtOR2dBbk5BdU9pZ3NMNysxMGtET1p3?=
 =?utf-8?B?QmJCUmRhWVd5NVVEYXVqRHlOVnZLQ1NObURxWThOL1ZLQmZ5Y0FuMjA2Wk5J?=
 =?utf-8?B?eWl1OEd0UWMzK1ZwaUxRZU9paFROLzFsUEFaendpSXUzdEZIbDlBOU1tL3Vq?=
 =?utf-8?B?aEdsSGpEdmlVdmduVVBXU2dwMnlIa0R1amh1QkFhVnVkL25WRzEzV0FJcFc1?=
 =?utf-8?B?VFdHMVpWMlFsMWt4Q1hVNzNRS000OXFtSElreEY2cXZHdTl1TFVlMXdHUDJq?=
 =?utf-8?B?cEpuQ1Jta2NoclI1MHcySEVxaXVHWFpsV2wwaVZsSFdpU1FHVTlQWms0VWRl?=
 =?utf-8?B?Y21wa2QzL0xzS1I3Nno2aDZMMTZveUlxdENHWlBueERaQzI5enU1eTMzNmVH?=
 =?utf-8?B?UXRqQkMvdDl1WTdRck1VRTJEeEFpUDJvZTVqZ0lRMmpLMDVGN1ppSVNYcFcw?=
 =?utf-8?B?dDh5NjJhOTJjWTlBQWZoblh3TXdUbEV1cjdLb2VzRXFvZzIwODBOMlZWVWRN?=
 =?utf-8?B?Nzh6MVlpeCthOHdXTXR1dUFaZkN5SzIxdTc3V2hnSW8yK2FjMTJ6S3EvNUZq?=
 =?utf-8?B?NzNBKzdMN1BrUElZVUhCUlNqVnlTN1dnZ1R3dUUvalVQbGFSc01GNkh4U0Ur?=
 =?utf-8?B?aUJtdXlUV1NBcEdWd2R1aU9vMDZrbjNyQVZjMlYyTFY0NmFldGFmL1VMdzdH?=
 =?utf-8?B?NjVFK0xYdHdtMUtNcXkwZWppNC92ZU5PSy91MHQzZ0w0OWh2MjRJdG1IaDYx?=
 =?utf-8?B?cWJlT25kd1AvVllPK0dpRFNSczZEb3d5MnBSdnpjbldaVzJVUzFlSHhic0lB?=
 =?utf-8?B?Z21oblpVOWFySVp5ZFpDdnlqbDFOUEQzeUFsY0REN3U2cnJ2aEpzMXhUZ1pQ?=
 =?utf-8?B?Q2JlYUtFQ3M3dFJ5M1FOT2FQSW1jVFV3N0hJalpVZm5BcGhFd3RtQ29YK2M2?=
 =?utf-8?B?Y0NSVmhGc0xqa2FvWVU2SUViYmdNd21tNUhIN205cFRQTG0yeGVSeTJEVEsz?=
 =?utf-8?B?M1dOVEF4QTN6QlRBUXd0ak1aSVV4OFAxcVFValhPV0Ewcmk4ME5zTkdia2tw?=
 =?utf-8?B?OXpsUjFQMkVpNEFBUEhINWNaY1k4Sld6QWpCbERPdmkvdFp2akg5eWpTL1NP?=
 =?utf-8?B?MVEvL2ZZRWpWUTdMbXlqU0YycTRYb0NWV05MckpqbXZkSkdCRGVOOHBEZmdV?=
 =?utf-8?B?OFJuTEVxL0xKdytlSlJHUUc4Sk41UTZqektRK3BOVEhrV2JrcTRiQ1kyalMw?=
 =?utf-8?B?eHhnZDJFT0syYUJBV3V0ckpvdkFURjVkV1ZTRHI0TTRvWkZlOVdRVk5hSDRy?=
 =?utf-8?B?dnRMSFhOeksvNzQxZ2lNQ0FFQ0cvRTZ6dHZWVXp6TUE1eisrT1NqRUtxcmZJ?=
 =?utf-8?B?Zi9ndTdvTHRCa1RsOEN0N09DZUxDT2RjbmdITlB5WEhQaUc5T3VnMG9RbzEy?=
 =?utf-8?B?eUpmQ3dLMXg1Nm0wZjFmbjVHcmNjcXdSS3pBeU1XWlJzbjcydjBRYlFDQU5a?=
 =?utf-8?B?VVVPditTRDVkQ1dGWSsrVk9VY0hHb1NJQUR5UmRQUjg1WmJWdEVvMm0zRno2?=
 =?utf-8?B?cTFyWG9wbFYrZkNqQ0lSVmQ2TDhkaURkS3lzVk51L2ZSQTVwZGc1K0RHNG91?=
 =?utf-8?B?YzBxTkpNWkpOQUpHOVpkdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckZqNVVMZTZJMUZGNFBjNGtJd0lKVGNqenE2VlZEQjg3aEhjT2tERFZKK21O?=
 =?utf-8?B?ZG9OVjJ6cUk2cE15UTkrL3hXUXJBbzNVSWFVaHQrWnZpNVoyWjhYWC9aa2Y2?=
 =?utf-8?B?NkxoNkdWRDRrLzJJS2l1RENUYThIZmRkTXllOFM0TnFDY0hRYjVaOWtkaC9S?=
 =?utf-8?B?UTgwbzYyVTJPV0NEckNVYVhxZ0pqSjZkRitGU3BLeDFvQlZ6MisyYm1KWEVy?=
 =?utf-8?B?UUZUK21vTTVNMzdMRGtxRmxVMVUzeEdnZEZLbVU5dXpVYzFRc0hwdG5hWFZH?=
 =?utf-8?B?U1kvY3J1WWIwbnp1Wk5TODFqUUdEUHZLMkJIdmhnZzdDZWJGSjZaK2RwNEJh?=
 =?utf-8?B?aEF3bnR3YjFXQjZqZUo4bUVGa1pPbVQ5UTNpUWVlYWFTVndyOGY2QjlHQmQv?=
 =?utf-8?B?VVVrYXBLQUYxRXBmZ2llclRDSnI0MHlqK3dWQkcwbWNhOXgxYllnQTFGOHlx?=
 =?utf-8?B?M2FzK2JKUDBUUjhwUDJoTVFXOHNuRHlXa3NiMGZId3Fpa2FFTW9vcStMNTNE?=
 =?utf-8?B?dzYxWnRlc0c3SEdCYklEQzUxVkZUaWd4MmlmUFlSNlQ3SElWbXRwOEcvMWVV?=
 =?utf-8?B?ODZtcnFtUTlLdndWbVh4dmVwUk1JQjEyejhWc0JtR2M3RkxTdlpLZ3pvN2JF?=
 =?utf-8?B?TlZCUWRkZDR1Y1JsaEdXVjgzQURLZ2FMUFpTRDRVY2pPOUlWdm5HNGRGQXMv?=
 =?utf-8?B?NFdPdTFRc2tpbW5YV2FuQUsrNElwMTl6YkxPYlQ4RzJINXFnQThuK3ZGVFFu?=
 =?utf-8?B?MGREYmQrUnNHN0NoK29VWEZTaW9uQmlnbHQvejg3MFJCMXBHYmFkZk9RZWlR?=
 =?utf-8?B?c0dabFQ1UWRhMHZtZE5QMmQwOFRpK1RlUFB0ZC9OczdxU1pJdFpTK005OStG?=
 =?utf-8?B?RG5FakIxYXowZlVBNGF2SEFvVDk0UFBYMGQ0U3VWV21ocDQxY2Q4VnFtaW5X?=
 =?utf-8?B?UGtOZVFOaXFISWwxZFJWeklTQ1hPYkhJZlkrWmxoVlJwdG5pOUdvOGZuU1Zm?=
 =?utf-8?B?b0VQb1ZsR0lpSTRzTGRscUI1YWJNcUxYbS9xS29oTkdXdVRSaWFYS0hLRzRl?=
 =?utf-8?B?ejMxbXVNdnRMaGE3QWZvWkUxa2RLeGYrNU9XNGxSaE85Zll6VmRDWlR3NVNX?=
 =?utf-8?B?S1hoMmxFdENBU3o3N2syMmFvSHZtMWhTZzQ0ZDI1SXFwYWdDUC9DWEV3Mmpz?=
 =?utf-8?B?K3JCZEtEb1RQb2htT2FLdGFRL2NYWERJUTQ4aFhBN01iZVV2andVU3JRYks1?=
 =?utf-8?B?d2NwbnFhMnA4Rk91anMwNklZTStIY0pPcHRVelQwRWR0dy9GbXhIVmNFYWV6?=
 =?utf-8?B?UkorS3ZhdUxpelhLaHJ4ZDJoOHFJVDVHNU8zYU1Ga0VwUzVzZ2hjVDVFMWdJ?=
 =?utf-8?B?cGRZVWZGQnR3MHQyQ2RXTGkrci9sMWpyOElvODRuUGZQTTZzRit2bFh6K1Y2?=
 =?utf-8?B?QVo3UXRhSGpQbnBnQm1WcnJ4dXUxeXIvZFJReVA3dmkveVpGcUdobHN1UHh4?=
 =?utf-8?B?eHo3dERCQ2dQVSt6YlB1OEM1RmZwN1dLMFd0dEZuTW9lSUx0MUdSTHhObzRT?=
 =?utf-8?B?VHJGZjlUaDBrTXRoS1RUVkgyOFlENUVHamhUTzAvM0tRUEFsdDNmWXZEWWtq?=
 =?utf-8?B?SmVEWU5XeWg3NFdkUkZHNm00SVEySGtpcEVCVkRrS1V0cHNYalRqZWFEY2tn?=
 =?utf-8?B?bXV1UzBodno4bnVIOGlmeUdQeW5XSktla3ZuWkw0UDVmallNOFlNdHhzQlNq?=
 =?utf-8?B?NlZmYzZmN2ZXWVFVdEx4U2QzTVFnaHU3VEt3bDd3RnJBUVhJUm8zYlVKbHZx?=
 =?utf-8?B?K2crd0wwWktwM203Rkw2RHRFTW9zWU1rU3BYQU8rTjgxUWFoSHp6OUxIc0Ev?=
 =?utf-8?B?ays5U0x6Sy9teGRlZzVFZ0xoZ2l3RXZ5TlBRRDJMNEI0Nzk0RTgzbTREMEJZ?=
 =?utf-8?B?YzlKY2VISmhlL0pwK09SMUN3K2FhS2lhWGhvbHA5YWlUL0lEeW94bC9RZnJt?=
 =?utf-8?B?dWFncE02NnUxaHhkL0w5TG0wbzFYK0g5UXg3NTZmZTdvNm84Q1NHeWlGcUwy?=
 =?utf-8?B?QURjV2Njbk9LcTVnRDNQZ0pmdy9mZ0s4NWZ5U1RlRC9vcC9yVmRUTXZMQlZ2?=
 =?utf-8?B?bk9sbnBzU0N5SkJxc3VVc0h4QzI5VytPVElnUjBYMSt0LzNOWTFwUzBhZ0Nk?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2B808DBA2028349AC8A9DA93B1BD185@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b596697-3e46-4ba0-b218-08dc7bb7b2fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2024 06:06:49.1891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3bLZsvkOOz9PPU9eaHPpKBOTQaJHbCSE2GFZKlvl7w95hZKGJ18Nkvh5yullXGEw9f5o5a+x6ZTblCf44CitZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7106
X-MTK: N

T24gVGh1LCAyMDI0LTA1LTIzIGF0IDA2OjExIC0wNzAwLCBoY2hAaW5mcmFkZWFkLm9yZyB3cm90
ZToNCj4gIAkgDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIg
b3IgdGhlIGNvbnRlbnQuDQo+ICBPbiBUaHUsIE1heSAyMywgMjAyNCBhdCAwMTowOToyNVBNICsw
MDAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiA+IE9uIFRodSwgTWF5IDIzLCAyMDI0IGF0IDAz
OjU4OjI1UE0gKzAzMDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ID4gPiBBbGxvdyBwbGF0Zm9y
bSB2ZW5kb3JzIHRvIHRha2UgcHJlY2VkZW5jZSBoYXZpbmcgdGhlaXIgb3duIHJ0dA0KPiA+ID4g
PiBuZWdvdGlhdGlvbiBtZWNoYW5pc20uICBUaGlzIG1ha2VzIHNlbnNlIGJlY2F1c2UgdGhlIGhv
c3QNCj4gY29udHJvbGxlcidzDQo+ID4gPiA+IG5vcnR0IGNoYXJhY3RlcmlzdGljIG1heSB2YXJ5
IGFtb25nIHZlbmRvcnMuDQo+ID4gPiANCj4gPiA+IFBsYXRmb3JtIHZlbmRvcnMgaGF2ZSBhYnNv
bHV0ZWx5dCBubyBidXNpbmVzcyBzYXlpbmcgYW55dGhpbmcuDQo+ID4gPiANCj4gPiA+IEZvcnR1
bmF0ZWx5IHRoYXQncyBub3Qgd2hhdCB5b3UncmUgYWN0dWFsbHkgZG9pbmcsIGJ1dCBJIHJlYWxs
eQ0KPiBkb24ndCB1bmRlcnN0YW5kDQo+ID4gPiB5b3VyIHZlbmRvciBmZXRpc2guDQo+ID4gSXQg
d2FzIGEgc3BlY2lmaWMgcmVxdWVzdCBmcm9tIE1USyB0byBhbGxvdyBvdmVycmlkZSB0aGVpciBo
b3N0DQo+IGNvbnRyb2xsZXIgY2FwYWJpbGl0aWVzLg0KPiANCj4gVGhlbiB0aGV5IG5lZWQgdG8g
c3VibWl0IGEgcGF0Y2gganVzdCBsaWtlIGFueW9uZSB3aG8gd2FudHMgdG8NCj4gaW1wcm92ZQ0K
PiBMaW51eC4gIEFuZCBub3QgdHJpY2sgdGhlaXIgTkFORCBzdXBwbGllciBpbnRvIGFkZGluZyBh
biB1bnVzZWQgaG9va+KApg0KDQpIaSBBcnZpLA0KDQpDb3VsZCB5b3UgaGVscCBhZGQgYmVsb3cg
cGF0Y2ggZm9yIG1lZGlhdGVrPw0KV2l0aCBiZWxvdyBtZWRpYXRlayBwYXRjaCwgDQoiQWxsb3cg
UlRUIG5lZ290aWF0aW9uIiBwYXRjaCBzZXJpZXMgd2lsbCBtb3JlIGNvbXBsZXRlIGFuZCANCm1l
ZGlhdGVrIHBsYXRmb3JtIG5vdCBhZmZlY3QgYnkgdGhpcyBwYXRjaCBzZXJpZXMuDQoNClRoYW5r
cw0KUGV0ZXINCg0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
YyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KbWVkaWF0ZWsuYw0KaW5kZXggYzRmOTk3MTk2YzU3
Li5mODcyNWYzMzc0ZjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRl
ay5jDQorKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQpAQCAtMTc3Nyw2ICsx
Nzc3LDMyIEBAIHN0YXRpYyBpbnQgdWZzX210a19jb25maWdfZXNpKHN0cnVjdCB1ZnNfaGJhDQoq
aGJhKQ0KICAgICAgICByZXR1cm4gdWZzX210a19jb25maWdfbWNxKGhiYSwgdHJ1ZSk7DQogfQ0K
IA0KK3N0YXRpYyB2b2lkIHVmc19tdGtfc2V0X3J0dChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KK3sN
CisgICAgICAgc3RydWN0IHVmc19kZXZfaW5mbyAqZGV2X2luZm8gPSAmaGJhLT5kZXZfaW5mbzsN
CisgICAgICAgdTMyIHJ0dCA9IDA7DQorICAgICAgIHUzMiBkZXZfcnR0ID0gMDsNCisNCisgICAg
ICAgLyogUlRUIG92ZXJyaWRlIG1ha2VzIHNlbnNlIG9ubHkgZm9yIFVGUy00LjAgYW5kIGFib3Zl
ICovDQorICAgICAgIGlmIChkZXZfaW5mby0+d3NwZWN2ZXJzaW9uIDwgMHg0MDApDQorICAgICAg
ICAgICAgICAgcmV0dXJuOw0KKw0KKyAgICAgICBpZiAodWZzaGNkX3F1ZXJ5X2F0dHJfcmV0cnko
aGJhLCBVUElVX1FVRVJZX09QQ09ERV9SRUFEX0FUVFIsDQorICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBRVUVSWV9BVFRSX0lETl9NQVhfTlVNX09GX1JUVCwgMCwNCjAsICZkZXZf
cnR0KSkgew0KKyAgICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICJmYWlsZWQgcmVhZGlu
ZyBiTWF4TnVtT2ZSVFRcbiIpOw0KKyAgICAgICAgICAgICAgIHJldHVybjsNCisgICAgICAgfQ0K
Kw0KKyAgICAgICAvKiBvdmVycmlkZSBpZiBub3QgbWVkaWF0ZWsgc3VwcG9ydCAqLw0KKyAgICAg
ICBpZiAoZGV2X3J0dCA9PSBNVEtfTUFYX05VTV9SVFQpDQorICAgICAgICAgICAgICAgcmV0dXJu
Ow0KKw0KKyAgICAgICBydHQgPSBNVEtfTUFYX05VTV9SVFQ7DQorICAgICAgIGlmICh1ZnNoY2Rf
cXVlcnlfYXR0cl9yZXRyeShoYmEsIFVQSVVfUVVFUllfT1BDT0RFX1dSSVRFX0FUVFIsDQorICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9BVFRSX0lETl9NQVhfTlVNX09G
X1JUVCwgMCwNCjAsICZydHQpKQ0KKyAgICAgICAgICAgICAgIGRldl9lcnIoaGJhLT5kZXYsICJm
YWlsZWQgd3JpdGluZyBiTWF4TnVtT2ZSVFRcbiIpOw0KK30NCisNCiAvKg0KICAqIHN0cnVjdCB1
ZnNfaGJhX210a192b3BzIC0gVUZTIE1USyBzcGVjaWZpYyB2YXJpYW50IG9wZXJhdGlvbnMNCiAg
Kg0KQEAgLTE4MDUsNiArMTgzMSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdWZzX2hiYV92YXJp
YW50X29wcw0KdWZzX2hiYV9tdGtfdm9wcyA9IHsNCiAgICAgICAgLm9wX3J1bnRpbWVfY29uZmln
ICAgPSB1ZnNfbXRrX29wX3J1bnRpbWVfY29uZmlnLA0KICAgICAgICAubWNxX2NvbmZpZ19yZXNv
dXJjZSA9IHVmc19tdGtfbWNxX2NvbmZpZ19yZXNvdXJjZSwNCiAgICAgICAgLmNvbmZpZ19lc2kg
ICAgICAgICAgPSB1ZnNfbXRrX2NvbmZpZ19lc2ksDQorICAgICAgIC5zZXRfcnR0ICAgICAgICAg
ICAgID0gdWZzX210a19zZXRfcnR0LA0KIH07DQogDQogLyoqDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KbWVkaWF0
ZWsuaA0KaW5kZXggM2ZmMTdlOTVhZmFiLi4wNWQ3NmE2YmQ3NzIgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oDQorKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5oDQpAQCAtMTg5LDQgKzE4OSw3IEBAIHN0cnVjdCB1ZnNfbXRrX2hvc3Qgew0KIC8q
IE1USyBkZWxheSBvZiBhdXRvc3VzcGVuZDogNTAwIG1zICovDQogI2RlZmluZSBNVEtfUlBNX0FV
VE9TVVNQRU5EX0RFTEFZX01TIDUwMA0KIA0KKy8qIE1USyBSVFQgc3VwcG9ydCBudW1iZXIgKi8N
CisjZGVmaW5lIE1US19NQVhfTlVNX1JUVCAyDQorDQogI2VuZGlmIC8qICFfVUZTX01FRElBVEVL
X0ggKi8NCg0K
