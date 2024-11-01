Received: from SE2P216CU007.outbound.protection.outlook.com (mail-koreacentralazon11021076.outbound.protection.outlook.com [40.107.42.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1C7196;
	Fri,  1 Nov 2024 00:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.42.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420689; cv=fail; b=hfwfXzROs6NU4EqdDv/IPz66Ojgub2Byi3Nq0z8w4IqaihFCfjDLe38rg/ksRAyK6MQ6bLzVqj+sMQzNG/ub9sa82YXIcuUU0Ys5DCkjeYO+tGasqPXPJCBBLWUsAXY7LvtOd/VGZE+psUvO/EXKa7vXQpGoIAzf4D2+aEurLEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420689; c=relaxed/simple;
	bh=2mrnDUvIRVIJUVVowJtn1GTLQS/fNeX6i/JswA0nb9o=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=j7sZDPqSJz5HHffifnD0FAAfn94bymrnunFHQzPF8/SSfBCcZwVPw8svJKYwmsRceGbjoAISt88s3avkMii3mVtyne6uzj1U4TDJayFA2VQ2LDcXKcJUsEf8ovDEjgHuhVKAgtrDk+jdxDdxP+kNKRcsHujOyJuqc078T1Yhxa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr; spf=pass smtp.mailfrom=unist.ac.kr; dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b=fAS0U3cB; arc=fail smtp.client-ip=40.107.42.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unist.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=unist.ac.kr header.i=@unist.ac.kr header.b="fAS0U3cB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUWR1v/wDrWmwgeEElszsorFnQEZW2J1UrcONARnGYaz8xcZw6Ql8odd3WVSfdVBYxMbnp1k+qR8AHMaM2BZT/PxDJY/mVi4OAo1Bb06GURzd7nXs3m8xribHhh62FkMN/7cxMNA0bq0GnZrR0S70bSuN0PuXZQHx8xvHj9AOvMVv1M8jtF5IDXCIMk0YkabLSz32LGXSDB0KDtyJNcizgYIqFeJjStw40URWA+PyiZsvmWpW8X8VbeLbqdiHnXE/hZguCsVsHUcm/27IcswrfiznOw9d7nhub1icQ27YnDIU+AEvqXZd9vrO9gOAS5qiWiJRLNFQo2o8eZbkP/Puw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mrnDUvIRVIJUVVowJtn1GTLQS/fNeX6i/JswA0nb9o=;
 b=N0lKigKiAJzdf1Km9Dj2Ov+IMhHFk/xxTCVBnIpNp7jsu9eUACOYvppFy4UOcs10WD6xQTRwz2ZT/A5Jc0GfIvP3Y1dHqsJlEMBE9CuI4jeaKyF/cgkxLA7WpwsjwKZK6hJEvvsHCpxH3UHERwpaqHZTKH5Nqh5bIjBdmF+pIHMGS6F+xnYjWifi8y9fkkAc0aMNlA+9OXzfQGyHEbTYJh1H5UChs0IcketMk1AMdC+WiXWIoaZlc9YfDIHnIzyYOv7xRHXvkDhzifp1kcQ+gpPsIln6PkoVzmj+GtggnFp6uUPWWNrJLg79SVXlyTofoXMA+VpDCBf2nuldMSO6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=unist.ac.kr; dmarc=pass action=none header.from=unist.ac.kr;
 dkim=pass header.d=unist.ac.kr; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unist.ac.kr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mrnDUvIRVIJUVVowJtn1GTLQS/fNeX6i/JswA0nb9o=;
 b=fAS0U3cBJmwxFInJ3PWoqT6OK8wnG2hHgweRrS+DDl82cVVtH8cu08ZA/YO5rG/KGxg3oy9+SNJUiJ1jTZGKePxPShIvCL4PXMUhNldszvqyBt1JYKeJDOeaoS61kvNTQ2Ur94870D6U5j5gBij33sTcuivf3cRxo28QuDhbyME=
Received: from PU4P216MB2281.KORP216.PROD.OUTLOOK.COM (2603:1096:301:12b::12)
 by SL2P216MB2109.KORP216.PROD.OUTLOOK.COM (2603:1096:101:155::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.25; Fri, 1 Nov
 2024 00:24:37 +0000
Received: from PU4P216MB2281.KORP216.PROD.OUTLOOK.COM
 ([fe80::40c8:79b6:9574:33f0]) by PU4P216MB2281.KORP216.PROD.OUTLOOK.COM
 ([fe80::40c8:79b6:9574:33f0%4]) with mapi id 15.20.8114.023; Fri, 1 Nov 2024
 00:24:37 +0000
From: =?ks_c_5601-1987?B?KMfQu/0pIMDlwM6x1CAoxMTHu8XNsPjH0LD6KQ==?=
	<ingyujang25@unist.ac.kr>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "njavali@marvell.com" <njavali@marvell.com>,
	"GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] qla2xxx: Fix START_SP_W_RETRIES returns positive EINVAL
Thread-Topic: [PATCH] qla2xxx: Fix START_SP_W_RETRIES returns positive EINVAL
Thread-Index: Adsr8+qItYqDP0lKRa+kdzC7A22B0g==
Date: Fri, 1 Nov 2024 00:24:36 +0000
Message-ID:
 <PU4P216MB228137E6848B4C5BB032D577FD562@PU4P216MB2281.KORP216.PROD.OUTLOOK.COM>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=unist.ac.kr;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PU4P216MB2281:EE_|SL2P216MB2109:EE_
x-ms-office365-filtering-correlation-id: 254f0213-ebc4-49f5-aa90-08dcfa0b915e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|41320700013|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?ks_c_5601-1987?B?cEhSOEV6MXVpZ1RoV1RRSHp3aG40dDFFemhsUzdVdEU1Ymw1NUVt?=
 =?ks_c_5601-1987?B?TWNiV2N2THdPdGVJcjBab0pxWDJ3cUZqU05FTk5yTjI3TDdDVDcr?=
 =?ks_c_5601-1987?B?aGVORkcwcmNKVkRxN2pHNlVNaGZFV1dSTUphbGs4TFFWUUIwVVBy?=
 =?ks_c_5601-1987?B?UGRoTHowdXZSbkJzcXZSdC93bE9uR3ZtMVhabDZibjdQVC9oYitz?=
 =?ks_c_5601-1987?B?MDhUaWt6ZzdBV3hjQWdXYUpuU2hBN1E3ZjZEM1FWUGpqSEhpQlNt?=
 =?ks_c_5601-1987?B?MUVYZE1wb3pxdVI5eklWQitrV0ZSaUZBL2xRbGlnZGJGYUk4MCto?=
 =?ks_c_5601-1987?B?YkQ4dytvMExZTUJ4dmV4akU0ZXE4SFJ3aEM2empydW1OUkpoNC92?=
 =?ks_c_5601-1987?B?Rk42R1pRRUJIbTFtUk9zUVhvQzVkY3UvZ2JSR216Rm94b200c1RB?=
 =?ks_c_5601-1987?B?dzNLektDanVVd0lQMWZ3R2ZRQ2hyWDBvWHNscUV0NlBTQ25vbVp5?=
 =?ks_c_5601-1987?B?SW03KzlIYWNiKytQY2RBMHE5Ym95RWJmUUwrYjlHTk0vS2c0NmpH?=
 =?ks_c_5601-1987?B?SWFXMkhHRzhLNlFpVzQ0RWRJeU13bnhRaVFoZjBHWEtxVkU0OFVj?=
 =?ks_c_5601-1987?B?QTUwRlkwaVcvQnQyZTdCRXdwYjdUNFErWXZJNEEwTWoyNWptRnlQ?=
 =?ks_c_5601-1987?B?UTRBVE5IYTlSWm1IUStlak04NnoyVTIwM2dLOXV4VUt5M1NURDRU?=
 =?ks_c_5601-1987?B?elpsQVM3ZHpBTU5tRHlnRDVPWnJRaCtMbkovK1NKVjh3UzFjRzJa?=
 =?ks_c_5601-1987?B?c2E2THI4ZE93M2pSd2dWa2lXUHNvNWV1Qm5XRFQxWkM1QlhON25n?=
 =?ks_c_5601-1987?B?elJPZEFXcUVPVXgrWG9QYWRkeWkrRzRUYjc5TVUrOUw0UnRFYnB5?=
 =?ks_c_5601-1987?B?ZEk5N2ovZG53S2s1aDJsNVpYVHlGNWU2TE9EZVVFWHFTWDRaekg1?=
 =?ks_c_5601-1987?B?WUdGS1RocU9jUkJFeld5RkdUdEEzQVNoTEozYWFFL0xaM0xHYzhs?=
 =?ks_c_5601-1987?B?THIwSUhoSStZbkJuNFFtNllXYzk5NGsyUUU5aGk0NVJTdE52UFUx?=
 =?ks_c_5601-1987?B?NElrMStidXo3SklkYUozbXQyMmVObUl6K2d6aHhDeC9sUGI3SFJt?=
 =?ks_c_5601-1987?B?V3lMZ2dleU9zVE9RTnA5c3BnRnpVa1A5NlhhaWdreHFHbXpKSkN0?=
 =?ks_c_5601-1987?B?MlQ4SVcvTnFqVVRZbG5lZ3Q2RUZER1ZjOUp6YVZhOEJiVEFZdnVU?=
 =?ks_c_5601-1987?B?anFTcVNxREZ4WTZKYVZHanZ0cVBWUVgrOVVxSDVET01QdEUxMm9Q?=
 =?ks_c_5601-1987?B?dVF5NU4xdjhoNTJZRWozdUNYTlVWbmRkZFp0YTBJZlM0aU5kM3V5?=
 =?ks_c_5601-1987?B?VzdEeFRKN0E4elVyWndadE5kZ2kxRWNMc2JRU1U4WjFmMFZVWlB3?=
 =?ks_c_5601-1987?B?WjB4a1FzMVRzYUdrOGI3YU8wK05wTXBYM0RaM2hjbVN3Yk1ZQ0N6?=
 =?ks_c_5601-1987?B?QzRNbXh4NytpaXJTa1BzSGRqa3JraHFjN0wxU2hmK2U4cXBhME1m?=
 =?ks_c_5601-1987?B?Mm9uK01maU1nYU0rR0REWWxRZXRsYzZhbWljS2ZER05UQlRUbHE3?=
 =?ks_c_5601-1987?B?bjAwclJ6YVkrSVh4Wm4vU0ZTbXBhTXI3UXhOaUN1Y1BES1FtOStL?=
 =?ks_c_5601-1987?B?OEtSZTB4VzZrNGNuMnZ2bVFCL0lSTjc3eGg2M1Vranpvb296bHdw?=
 =?ks_c_5601-1987?B?eVV3TXBlcG14aFhleHpGdVJqaEFXa09MWkY5bGNLMDlzUUsrajJp?=
 =?ks_c_5601-1987?B?NENnR0VhODhRL1VYZDl0QkFBMmVvZjlnbFZQVTVBOTQ4b2VqbHZm?=
 =?ks_c_5601-1987?B?OWwrL0dUclRSQit0dFQ2L01SQzhQaTBaaStNQkZkV0tIdWx3QkxB?=
 =?ks_c_5601-1987?B?TUljRnJLTUZ5OHJBM0p1OFExY2hUOS85NGdZWW9lM2Y0eTI2Vkpy?=
 =?ks_c_5601-1987?B?WmJ4ZEZOaDhhTFdWVE0zY0xZS1F2RXN1RTFoUTJwd3R1L2pTU1Jq?=
 =?ks_c_5601-1987?Q?vygMSn+5vdskLb9DQrUJWE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ko;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PU4P216MB2281.KORP216.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(41320700013)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?ks_c_5601-1987?B?ZmI5cm9OUkVJd0s5Um9HRTFTUmVlUkVVc3RPcmpUYmFYcVhvaFVt?=
 =?ks_c_5601-1987?B?WndodHJ4d3RmN1VWNHlPMmlDRVhqQXFweEpsVmRSZFV3Rm9ZTlZm?=
 =?ks_c_5601-1987?B?d3IvMzZqNFloN2ROY0pLV0NLcXlaZURISDYrczVhRHQwUTA2Q2tN?=
 =?ks_c_5601-1987?B?VEtqVDRxL3MrS09NdldROEFxR1pzdGRJeStZOXBvT3VYeS80M3dp?=
 =?ks_c_5601-1987?B?Yy9rZG1XczJTUVV2ck04d0dQOHA3VXEvMURTNEgrN0dJUWZJYm1N?=
 =?ks_c_5601-1987?B?RHNHWnBJTCtEQmt0cXpIZGFIbTlNZWEwSEtxR2wvblB2T0YyRWdE?=
 =?ks_c_5601-1987?B?YVRrQzV0NnJHSm9sS2F5ektwN0tIWGJuZ2VEUVdxN2VaQnBVSFZC?=
 =?ks_c_5601-1987?B?bnE3VmhvelRHK2NqREhVMy9CSDUxOGdPY0QzL3cvRGM2RmtydlEz?=
 =?ks_c_5601-1987?B?SjQva01lSnFvOHM4WWM1YUVwVjJlTW5hLzZVOVlqTWx3ajdOeFJH?=
 =?ks_c_5601-1987?B?UmdkWHNxdlpLQThmb21wQ2pNY2FRU0U4R3FycnN1dm5pem1Ma3kv?=
 =?ks_c_5601-1987?B?T0xHMis1WmdKUVR5cDA3ci8wQklqZDN5dnBtbmVNNm5ScXlsNytk?=
 =?ks_c_5601-1987?B?eTlyMDljRjJieGtKdUJUbVVrZWVpN3RPRGlURU1KdEwrRFk5VGtP?=
 =?ks_c_5601-1987?B?TlFHYXFzd2JiV1BwdW9sTGkwS21yK0g3RHMrMUdpOENOa1JnVzNJ?=
 =?ks_c_5601-1987?B?UDg4OTBhSjBNQ1p4THdpZjY5M3haVXhSUnJSMDhSZFJXNldJUWZT?=
 =?ks_c_5601-1987?B?YkQyclF4dnRIWFU0V1kvZHNMQXNjTm9sMmo4TndaN1dJQlBvbTlZ?=
 =?ks_c_5601-1987?B?eStCNjRab2Zoc1lmSzJ2ZTZUZFFqR2hQNHAwVXhUQlRXRlM0Tit0?=
 =?ks_c_5601-1987?B?bVhmTVdyV2VnUEFxNDRpYWxDOXZUc05YcTZ5NDJ0amx1YU9zVXlZ?=
 =?ks_c_5601-1987?B?ZVVqOGZWVHpxM2d3Tjgya1QxRWI1UnkwZjdaOHJodFpIeU8wbWZ0?=
 =?ks_c_5601-1987?B?SHBENitNdFY4NXZWbFdSeHNtNGJxQkRNdlVLaHBEendobWFjL3RI?=
 =?ks_c_5601-1987?B?NlUyYWlQZmFOTEhZWU42WGMyMkh2VnhmMHF2ZFY4dDhaTDkzaVhD?=
 =?ks_c_5601-1987?B?RVFoMzh4YzRidlFqZkNuVFpiRG9KRHNkR282dlZHVWRwWEhndmxs?=
 =?ks_c_5601-1987?B?UmJIN1gzVlZKVS92Q1h1VkNydlZGc1pac21GSmtyQ3BxUkdxYXZF?=
 =?ks_c_5601-1987?B?Zm4zNFltTTRiVEZacmRlVkYydU1sYkVld3dCU2xSNGlFaHUybFBw?=
 =?ks_c_5601-1987?B?TlkyUkpnTklEU0ZKN3lrMUJtdHpQYjF3bml5SEpOamRqbzNyd1NX?=
 =?ks_c_5601-1987?B?N25WTHNkR2YvSkxCY0JGTUNoQ2V5ci9vVjZJQXhSYkc4eGdHemt0?=
 =?ks_c_5601-1987?B?NThGRWd0SFo4c3MyYUtXb3h1c2lXMU1leDdCMGFSUktTRm9hUUtx?=
 =?ks_c_5601-1987?B?RkEzTnFReVpkMEJhUHpDVXp4NS83UlU3YnkwcTUwbFhmNWpic1FQ?=
 =?ks_c_5601-1987?B?ZDV5RVNqSTR2U3ZabTVQVisrSVkyQy9FUUF6MDgrMWFyKy9waEFi?=
 =?ks_c_5601-1987?B?TC9uR0FCSzJCdTUrOVU3UktTckNXRHNtQ0ZpT010STlxTmU2dmg1?=
 =?ks_c_5601-1987?B?aTd0djU3cFFNMENERWVuYjVtV1RESUhsdXFBaFBnYkZtSnRtWmFm?=
 =?ks_c_5601-1987?B?UzhzdXZQTXJCYkFJU2k0TlRhVWRaNk9TUjFOK3R0a3lwMlluWW51?=
 =?ks_c_5601-1987?B?RHVpK205blQ4NThHeVhlVFBEL2dWRWhxc1hlUUI0THBobEdVUHVz?=
 =?ks_c_5601-1987?B?Z01QWDdXOXpSNlEwTWVSckdYY0Y5ZlY3QWlDOFhYeDg5UjVWK1p6?=
 =?ks_c_5601-1987?B?cWp0dEoya0dER0h0YmIxd3o3UWtIdUtKb2lpb0pPTGJTRDdzY0s1?=
 =?ks_c_5601-1987?B?SGdrTnNMV1FZWFpydFVSbHRxQkJ4R0llVTZHWFRQbDhMK2JrS2p6?=
 =?ks_c_5601-1987?B?K3RPSDBtNGhuOGk2Q2o0Q1ZVczFkNUN0bmkzYkNsZ2ZqRmVvR05Z?=
 =?ks_c_5601-1987?B?OUVtL0c4MXBZTGZJczQyRFdXTHl3QTR6K0UySi9CRzRyMmpadzNB?=
 =?ks_c_5601-1987?B?V29rMGhzak5LYkhKTzRXK2ZpZmtEOVp5bDV6NHErS2lLWlVhUVl5?=
 =?ks_c_5601-1987?B?RE9Ca2xWQXI5bXBOZDhCNWJ5dG1XYjlXNklicXB4bFEvMHlaWTF3?=
 =?ks_c_5601-1987?B?aGZVbjNRZmdNN3FKK29oZWxvQW1iZkFXVERCczI2WkI5cm1ENU9o?=
 =?ks_c_5601-1987?Q?OBWeU+fQI+Rcx6qphFSQMVTccaI1ulUs+w8d6rVv?=
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: unist.ac.kr
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PU4P216MB2281.KORP216.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 254f0213-ebc4-49f5-aa90-08dcfa0b915e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2024 00:24:36.9668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8715ec0-6179-432a-a864-54ea4008adc2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pa85GlspiRRQ+0NWvvzGKkPLmbw7L5LbkrAKI5W5sWVHKoD968oO3RFLkdfSQYOsR+t8sjsLWViKi6tJk1bzeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2P216MB2109

RnJvbSA2ZTc4ZmYyM2I5ZjExZjY4OTZjMDkyOTllMGEzOGI0NDQzNDIwZWVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSW5neXUgSmFuZyA8aW5neXVqYW5nMjVAdW5pc3QuYWMua3I+
DQpEYXRlOiBGcmksIDEgTm92IDIwMjQgMDk6MDU6NDQgKzA5MDANClN1YmplY3Q6IFtQQVRDSF0g
cWxhMnh4eDogRml4IFNUQVJUX1NQX1dfUkVUUklFUyByZXR1cm5zIHBvc2l0aXZlIEVJTlZBTA0K
DQpUaGUgU1RBUlRfU1BfV19SRVRSSUVTIG1hY3JvIHByZXZpb3VzbHkgcmV0dXJuZWQgYSBwb3Np
dGl2ZSBFSU5WQUwgY29kZQ0Kd2hlbiBjaGlwIGdlbmVyYXRpb24gb3IgbG9naW4gZ2VuZXJhdGlv
biBtaXNtYXRjaGVzIHdlcmUgZGV0ZWN0ZWQsDQpwb3RlbnRpYWxseSBsZWFkaW5nIHRvIGltcHJv
cGVyIGVycm9yIGhhbmRsaW5nIGluIGNhbGxlciBmdW5jdGlvbnMgYW5kDQpjcmVhdGluZyBzZWN1
cml0eSByaXNrcyBpZiB0aGUgZXJyb3Igc3RhdGUgd2FzIG1pc2ludGVycHJldGVkLg0KDQpUaGlz
IHBhdGNoIHVwZGF0ZXMgdGhlIG1hY3JvIHRvIHJldHVybiAtRUlOVkFMLCBhbGlnbmluZyB3aXRo
IGtlcm5lbA0KZXJyb3IgaGFuZGxpbmcgY29udmVudGlvbnMgYW5kIG1pdGlnYXRpbmcgdW5pbnRl
bmRlZCBiZWhhdmlvciBpbg0KZXJyb3IgaGFuZGxpbmcuDQoNClNpZ25lZC1vZmYtYnk6IEluZ3l1
IEphbmcgPGluZ3l1amFuZzI1QHVuaXN0LmFjLmtyPg0KLS0tDQogZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2luaXQuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEg
ZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0
LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQppbmRleCAzMWZjNmEwZWNhM2Uu
LjA4OWQ1NjBlNDExNCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0
LmMNCisrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCkBAIC0yMDU5LDcgKzIw
NTksNyBAQCBzdGF0aWMgdm9pZCBxbGFfbWFya2VyX3NwX2RvbmUoc3JiX3QgKnNwLCBpbnQgcmVz
KQ0KIAlpbnQgY250ID0gNTsgXA0KIAlkbyB7IFwNCiAJCWlmIChfY2hpcF9nZW4gIT0gc3AtPnZo
YS0+aHctPmNoaXBfcmVzZXQgfHwgX2xvZ2luX2dlbiAhPSBzcC0+ZmNwb3J0LT5sb2dpbl9nZW4p
IHtcDQotCQkJX3J2YWwgPSBFSU5WQUw7IFwNCisJCQlfcnZhbCA9IC1FSU5WQUw7IFwNCiAJCQli
cmVhazsgXA0KIAkJfSBcDQogCQlfcnZhbCA9IHFsYTJ4MDBfc3RhcnRfc3AoX3NwKTsgXA0KLS0g
DQoyLjM0LjENCg0K
