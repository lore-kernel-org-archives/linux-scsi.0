Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D154582EA;
	Wed, 30 Sep 2026 07:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754867; cv=fail; b=GoxV+1IFwiYBL1INiiHj3FzGuiwlSQHKJsAKeVyKk3j6dmdgcHIEOSLYOpAaCf+O41CzXBkO658Ycfo7ZyzR2gxAiepShjF/JlGkSB9mjNPCKKdZ11ly4ji1CeVSF91A6AuUeZAqQWT9R5Enp3k1N1/qwl8PRDZEp5dsZk+YgIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754867; c=relaxed/simple;
	bh=KVEe4wnq+yMdHGVIe5Bxd2EnI7lRrxxoRIWhya4vA2Y=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mgBXQTrktoOkx8MXND+qGk8HPSbjMyz/36jJ31bIBdZhsWsjQY48ZnIUGNljFJbxupv+g3Bcs+IDstej8JkKzRkq4HAmi4zxsELLr8VRGSQSE/1HILsOW/VqnNRUnZuJ1OnrwBEVW/mK4IjhciQdz0ggPMqp4UhZrFSQezJMnwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Mrcjo2Gp; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GuYH3DrH; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Mrcjo2Gp";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GuYH3DrH"
X-UUID: 233fa01cbca411f1b1788b6acf885367-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:Message-ID:Date:Subject:CC:To:From; bh=KVEe4wnq+yMdHGVIe5Bxd2EnI7lRrxxoRIWhya4vA2Y=;
	b=Mrcjo2Gp7lHOY2ftPSHvVCmVo2H0Zn9XgZhUoF0ojdC/LINaP67KmOIVqGMOtyE4LD49fwjT9dfZ/EIS7O5GFSDQWL+lhACc1kgmJeVF11jhkvyjqPNO09ZF8u3qcob3CechO8K7tPv/mBEFf21bi7PWbNcmGWOT9vcv/fbVSxg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:8bb23f2e-17bf-4dce-9001-e7e1d0879611,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:0627ab79-69b8-4eeb-9f08-b9b80d2b4ee3,B
	ulkID:nil,BulkQuantity:0,SF:80|83|102|110|111|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 233fa01cbca411f1b1788b6acf885367-20260930
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 748123111; Wed, 30 Sep 2026 15:54:17 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 15:54:16 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 30 Sep 2026 15:54:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvvsLcWpDGsvR8C3z4x32xBZC9Yq3g2irfbPoVlC/nul1b5EHgcbKkLVFzeyu4xkNZtvVtm6owAIvz71v8/nnBNVTED+Ic3GmIMM5zoYLHtr+y2uOY3Bpt8lxXuRFOtMFWYjM2Z7g8INg+z5dtI3EJjLX3D1UopPNMbelV8alnXA6HFuqjN8teXblfsK1YsLiskDvKFPuy5oWhrcMd0ssHQrDDI/QizeHF1F31SXEiKrgTLh9VouuH3fJiDn0H/XmXBOS44divB/wgC/n0LEGo6irl0YrUNzDpv+07UJrS8AiUfwU9atcHAuoiQ7FxX9d2Beqw0Hqn2QMkTYCx5Fcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVEe4wnq+yMdHGVIe5Bxd2EnI7lRrxxoRIWhya4vA2Y=;
 b=osVxnJK2TsQO1JJ1YRQAy0WXTc2HzAAxH5k6T/GIwkj6bLlip7ZWx7/jat4jT1766skXKqSlRWvcfG3Qge6gh6eSZQvt1dVyWB1uB0QN1I5+AFMgfFISIBNvG5CK0XD30DBSxgFhf6o8WEp9WH7ZApflx25bQDncAxZ6i5v1zjS2wicM49je3CuMCVlKaxTuPvjyAVPc0zjXTEHMOal+BqrQW7D51Pts/HycWL2S984E+ls6J5zIw+tuYAc9t3UtR5uYRprZ7I+nyaQ8gtZmWUxTIqKSUm8gBNH8F24W5pldTJdyREMYrw/97QfSXhm8ETvkdcSKK9w2Ygk5/AW+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVEe4wnq+yMdHGVIe5Bxd2EnI7lRrxxoRIWhya4vA2Y=;
 b=GuYH3DrHhOmhyM8kzjttXGT8g6TBHLWOz0ZW8++gT27yMxGU0F9OpbPY0rJQ9gc3RsIHbnP0D6JmpNX3iUMmqFQgF6zIV8L8Hit09xUy6zNnzO3jZ1rWRpK/lst/2t4qYHMwlVw1k6vcjqpqiwItxE2tRA0xHlUwCoqX+YwFwsw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8840.apcprd03.prod.outlook.com (2603:1096:405:a6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 07:54:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 07:54:13 +0000
From: =?iso-2022-jp?B?UGV0ZXIgV2FuZyAoGyRCMiY/Lk0nGyhCKQ==?=
	<peter.wang@mediatek.com>
To: "hyenc.jeong@samsung.com" <hyenc.jeong@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Add the aggregated read query opcode
 and its reply format
Thread-Topic: [PATCH v2 1/2] scsi: ufs: Add the aggregated read query opcode
 and its reply format
Thread-Index: AQHdULDi0Dii1pSejEahRH+QYSNZug==
Date: Wed, 30 Sep 2026 07:54:12 +0000
Message-ID: 08286ada049bcdff4a45db6170fa09d742da2224.camel@mediatek.com
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8840:EE_
x-ms-office365-filtering-correlation-id: c995abd0-2ac4-47d2-f80e-08df1ec804ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|10067099003|11063799006|56012099006|18002099003|38070700021;
x-microsoft-antispam-message-info: 7ObkctHVDUa4Kb0BPcnvN/e0H9++aiEhC9UgjzBZuf9fiWCN6UKQrFsJbkkwPyDJ40Ko+wPTr1546pL2eW0jAGiZtB5uC75VBL+bSpmEL+mS1omchJ5BDeO1MWguU8UScXOp2H5ozRBTtXmzy3w9LFF7OmHASibuZvb0/tVInkdTs6VbtObyf9foZpwjpdBQYfX2CbR/RGbsLuLTcnVRQ7MZ7XILvZb1mzdNzBvnbq52Ae2LgEryyfm8uWMDuIGkM+xNk9ouaJV73wO1ezFYoi/SCuOkmAj4hMYXakLIodtnmou1lmpic+GHoR7CR6IigkOeAd46/TeEllUgFjGahwLkGJgVZNHNYcye/KomyE5jtkW/Earp4ZTBDlQWcr0C8vbhyZxR7tMspR7HDYntilcvnmu6Pt6HzqTP5wPBbdb1R4+g7VdLRXwDqeL6vJoLSF9oVzZRC8YuED8gLk8tCAAWYKmw1u2i/HzAhoUzds4Kr4jMY1hkm5UtDmpsHEwGoN2eJPYrYfeJlOXJx/9YfzZ/8X/D4TdGT0q7fVvD0UMlHKoxywRqAutP7/Td5aQIM6jy0VC95iSK6hlsI32tWM30UBL3njOKtcoSQNZzD6Okx3MJKu6LNRUQvr0l2VVSvG5U7f80evmGEtJ6XUC/AL3iIf7zxAnu4ee018NQ0FM0eRWzDq/+wnt+cOYXgRRT50bGTZTsJ693Oxj9DyeFOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?dDkxK3JaWGZHVDY0R3doVUtRMytoWnBMUWk1clpWYkRTdkcxNnBTTVFn?=
 =?iso-2022-jp?B?dlZkZ01nb25tYTQzL1lKS3FMQzVtSHYxU0paeitmZFVxa0IrMUdZL2ts?=
 =?iso-2022-jp?B?SjVXR0RQNHFzcHk5ZlNxQlBBUTE1TlhXMEUxZCs0L3lDNkpNcTZHQlJm?=
 =?iso-2022-jp?B?K2t3OXV2V3EyeklrZWZSTXhlci9YNkRCbHNEUWQ3ZlVHVUJBRWVUZHBM?=
 =?iso-2022-jp?B?L2l4U1lET2VkcHNWUis4MmhoS1NabGNiTTBpYkh1S3NIQ0g2Q1FCNTJ0?=
 =?iso-2022-jp?B?Nkc0K3A1ZjVJNmlkZDVHK0taTkdnYjFvY3N0Rm0zMklidVc0Y0s5NENz?=
 =?iso-2022-jp?B?K3R5aEN3VnFYOXBnekpQUTZjMlNDUDFEWlpHQ09IQWdHM2xSVzhLUmZh?=
 =?iso-2022-jp?B?YVVYM29qU2dpaTdrUTBpMmIvd2ZyOTdxN3h5Nk1mOWJPeGhRdDBUa2xC?=
 =?iso-2022-jp?B?NXRPSlFqOG1kWG9EWmd1ZzE4aVlXMUNvbG9UUStEWlQxOHgxSm14OWRa?=
 =?iso-2022-jp?B?azFqRkl5dUZpRVBPaG16UlNkb3FRM0FHdXVHOE1peUNHbnE2MVNyajZy?=
 =?iso-2022-jp?B?ZzRIQ3NaYk5RbVlvaFgrRUI5b3ZwZDFsWlpqQ0Q2K01yZCtNalFoMWxD?=
 =?iso-2022-jp?B?Nm1wei9BMkxveXcva2RHMmUrUnY0MGFRQWxRalBxRzBZVWtpWXBZY1Fw?=
 =?iso-2022-jp?B?dGlvL29OK3VJQkpVODJ0SEpFNmJjdC9mUS8yeDB0SHJwNEd6U3JndDla?=
 =?iso-2022-jp?B?bStIMjcxQldqYnhRaWJuTU5UQkpWK21XQXFRSnJNSW4wN2lQQThaUkF5?=
 =?iso-2022-jp?B?bHJwUUlkMEpYWFcrczd4c0xpdkhNWlZuUjgxSlhJcnc1L3hhdEJzWUY1?=
 =?iso-2022-jp?B?YmZyWnJrNnBweDVVQ05zbEJKTFNUeG56eHBMZXRxKzJESy9IdlVhRTRo?=
 =?iso-2022-jp?B?S1RQU01lL3RzVnNDUUpTK2UrTU5mVFhvaGtjcnRaQkpYYXhoZFlpb3ox?=
 =?iso-2022-jp?B?M2ZwRmRPN0NuUHkzT09tM3RHYU90VGtkbWx3V2hDU015STFuWTEyZnVo?=
 =?iso-2022-jp?B?R0FoaUZMZDhnSXVyTVM1WkEwdkFNd1NWSzQ5S0lxeHE2Sng0N1k4c2Vt?=
 =?iso-2022-jp?B?UUdyeFArdHRnMElZMHFmajdnMW9yTmU1L3hsUGNBT2l4MmRVZENOT1Iz?=
 =?iso-2022-jp?B?MnRSdU5SQXZLdXZ0NzVkUnljSUJKdzkwTUd2VXJMdHYzMmFhNkpFSmZ0?=
 =?iso-2022-jp?B?NU82R0l5dWVzQWwxd09oU2NCaHh3VlVZZVY2K25zRUsvY2ZORHBobEpw?=
 =?iso-2022-jp?B?VDV6blcxWHV3VmVtSkc2dGFSOFVUMmw1cnl2NFlMZEl1MEFGMWRQL05o?=
 =?iso-2022-jp?B?R2tmdkZWNU9EbUI4Lzg5VFlBVCtTRm11SEk0aU9sTlpOZ2U5anM4ZFhm?=
 =?iso-2022-jp?B?bEovMGU3SDFNcE9IQUhPSHdmQ1pIZG4yWUg1YVl1ZVFMaGdHTXBmemJz?=
 =?iso-2022-jp?B?L3I2UHl5ZDVOa3lQU2lUVHRmT1pLNEVOa3E0YlhLSExHcHBFNDFHMUxM?=
 =?iso-2022-jp?B?bG5hVUN5T2dRdndMNnFsSjRNd1hoYSt2aXorUnFCZVdmN2F0VDVjZ2xa?=
 =?iso-2022-jp?B?RjBYQ3cvMTYrWWVrcVVBQ1hsWDgvYWdOdy94R2MyZ3VaeklOaGhvWStY?=
 =?iso-2022-jp?B?SnR1YXZhSnJjMzN0NnR5d0oxNjh6SzN5cmRtMWtCcVdwNHp4WDFRczJn?=
 =?iso-2022-jp?B?Z2xUTG5DUk1YRExJT080S1VDVWlvRmE2bDlEMlNrRS80VlJNd3VwV2c3?=
 =?iso-2022-jp?B?d3VUeSt1NEYxZFZlL0hTclUyWWFBQzF0VmdkZThNRkFnVGVDWW1ZZlFV?=
 =?iso-2022-jp?B?U3FIbGlleVp2c3BKMjVkeUx0ZVF1eTNhb3BYbml1Rzk4dFNRQUFLNElQ?=
 =?iso-2022-jp?B?aXhsdW9Rdm5HaStkRE5POXZ1R0NseHdadEhGRDJJTy9VTXZSVCtrbWZG?=
 =?iso-2022-jp?B?TDBuWlY5REVTbUNOUmJKckhra1VFaVYxeTZ3Q1F1K2RTTU1wWTBGcjZo?=
 =?iso-2022-jp?B?bHVVUEczZGlJSFRDRW4wL2Z5dW9KN2FpdVBKaC9xdVNDMDlUd2xNRFVW?=
 =?iso-2022-jp?B?M1NjTWVTdzdML2g3QUt6UVNIUHlaR01CRzVLQnJNR2p2TitIS1hFR0hl?=
 =?iso-2022-jp?B?WEYyOU55VHJPdDl0RFFTQ0YyaHkyTjNZV1ZITzBKcUpLMjlBam94SHdo?=
 =?iso-2022-jp?B?TnhocUJwTjVUaDA3bkg1OE1VMEdwOWM2ODdLMW1ZTGlEeU8vOFJXYSs4?=
 =?iso-2022-jp?B?MGdyY2E1UjJQR0g4OE1WcGJZNGR0Ull0N1U4RDRmL1J5N3VxZmJ3MWpC?=
 =?iso-2022-jp?B?Y3NzNUtZK2tQTXM1ZDI5MnJ6QjJraUtPcjdpb01lZXpUaldUcjhuWXM0?=
 =?iso-2022-jp?B?TEpiUkFiYW0xOVk1c1Y3M2NteXEyQzFFMmdIeXBodVMzSysyb0hWSERa?=
 =?iso-2022-jp?B?a3YzcVgxVFRZVE1tLzQ1aDNZcWF3Rm5zMmJDdz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 1dBUQFmUp9eXhlQgx32Oc56ZO9D1I+9sbB8SS+F3FNgSLmVbUww4rqYEBgPxsvFkQ4Oy4470YHfQdv/QLPzUYaP7z+xJUeSjsDCqFkV/XYkdiFXwtbT9tT5GEFopNY5IadOiSlg3DEf62HHf6qY2AMISAfap84TN55PopcliGrCJ6ACo9RgwK4EZdIAO2OtEwlq1Y2sW58Tyl5JBnvajdiCzrPqdrmPKpIDo/HMzcLB+hWhiedDWgXWL99qjQg0HO+uPp789gzf7NoW9mu8FhSSMoC5HR2cz6uXjMTe3JqVW4AEdqmBhyQuaSyiSSVJH9U3/RaBdByFAb1fO1tDrqw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c995abd0-2ac4-47d2-f80e-08df1ec804ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 07:54:13.1080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +FLZSXk1NxFvicBdSqsVS0GZcm/delcdIImKOY+zXIbXOwRRI1MkRhkxfPdXgzFt1nQLWe7k/YK1u0/BvfR+cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8840
X-MTK: N

On Wed, 2026-09-30 at 14:15 +0900, Hyeoncheol Jeong wrote:=0A=
> UFS 5.0 adds the AGGREGATED READ query opcode (0x9): a single QUERY=0A=
> RESPONSE UPIU returns many descriptors, attributes and flags as a=0A=
> chain=0A=
> of typed groups (JESD220H 10.7.9.14).=0A=
> =0A=
> Add the AGGREGATION TYPE mask, the group types and the group header,=0A=
> and=0A=
> let ufshcd_copy_query_response() copy the reply's data segment like a=0A=
> descriptor read, recording its length in struct ufs_query_res.=0A=
> =0A=
> Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>=0A=
=0A=
Reviewed-by: Peter Wang <peter.wang@mediatek.com>=0A=
=0A=
