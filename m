Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE218A95C;
	Tue, 20 Aug 2024 09:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724145022; cv=fail; b=WoFdJ3heW3mJ2CFFxNg8dKGwaZBY/oQupIK1lKhWtY/rLXkhJb8Ph9Feioa22+VcNvk9Bz1iBEpZshPxIwtLNkdRvg9R+OBIxszV+JezbvzOWA4/gbmfYslmPnuJnNKKV60MAD42digggAei+DELbte9LaHGTxWzJkULZUfE3HI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724145022; c=relaxed/simple;
	bh=bLEGcl+1h2lDOd8iwXce9GrYKYHQwrSsZj04CG+B1JE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ma+iup3dvtVXHG83D5gnd9xuD62SkM75ZZrtIzDd+dD6FHEmS1trRa+k66+wjzNnp3TkJye312TTVEJI8tgq20CLL+ljvfcpOECinf8DozQBuQf3n9tkeqdfUpcWxmvSzZG2rdVfIVcV+FnS+9Kt2y2x7lfuq83xHR9ggou+t4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XRomcEdr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=RASWZ7OU; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XRomcEdr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RASWZ7OU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1724145020; x=1755681020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bLEGcl+1h2lDOd8iwXce9GrYKYHQwrSsZj04CG+B1JE=;
  b=XRomcEdreG3+CUK+aSIf2mgUTwo8QfhuGSy/I/sxpLEJvta5qNHmW7Eo
   24AEYgT90bx8VmcKkKbI4STp9hvA9Ajizo5XM/CQMY8ylA1FtFlg90zZe
   k2dHRaxf7H7cXj1yiy/RrAnMhtvz1AhK70d4KGbMyomPCyKVO0SXPawdO
   nBpUPoDBrLybaJ0fkRBawcdXZOZ6izEKrh9lD/+gKK7v3ysz12fgLhKqL
   ScZcrJh4L0dojSbsHuZvH3j7l97y71Ac3ajy7RfqQSFMs3u7h8RC1vWwB
   NzAQB1Z7wWNbNjVFDElTagp+IxMeyQspd39tGRNHjHyYJoa4OtwUM0X6u
   Q==;
X-CSE-ConnectionGUID: +wQl8/DEQiK2O0++sDK69A==
X-CSE-MsgGUID: Bqki65XcQWK57NB/D5NZaA==
X-IronPort-AV: E=Sophos;i="6.10,161,1719849600"; 
   d="scan'208";a="24088076"
Received: from mail-northcentralusazlp17010004.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.4])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2024 17:10:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eP2/dfRaLnAJD4ASy3w63pNcLosSPZ+87h2Q2jI9Ta85BTonXJw60vt16s2mOmrTj6LtLwEOKoDC3Q+ftoQO/Prd/Fgz+ZfnWcN1Z8QVozhyWObSe1l3Obya+D/sia9cN1JrzkuO0E5bqgWgObsTxy9/Pcl2VRtLSdSQKkmGqdFITT7hmYskoQsrK8kE+Y2k2quEB18CUI2SdDaJgQxrIzx4rTW6slFdmZsnohHTfHboHiFzIiC5wQ7vvuSodadQVtlgQWwf/nrzcQZDMMjtJRB8s3a2pltTQZw89B7is4/tC6Nm9cG/XqAtoaRP/7XmIqM4lkU3ISVQ+qqWQZhouA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLEGcl+1h2lDOd8iwXce9GrYKYHQwrSsZj04CG+B1JE=;
 b=dGqyi9+11ifbr+YAp4quHl3TNPUVASYxnRE0S/xuGFlpnZ/unmpQkl8EqHxLoTIt6vnZVAcp8ChxSn99grrKYIPPleYEGbqXcQTVlQiEmN8TDX2/v+1iGTGilPLs4ARKLB86nz2kbWgAhN/kIHIZEwNYBHdR8UnqNf50igtg5+DGdhdNgWeAxGkC65dtrW/KbvD0Jj6HNz2u4b+hlORZwHSZi6nyasT4adBasHJthq8xtVGq5zBkgTxY8HhrMWwbM22iXOntpvcAVy/lTayNutyFaEcXU6/DK6yTejMyRZ9wcmfGnFYeFwe+bsmze5v+s17BGXYSyo53IxK7jNQRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLEGcl+1h2lDOd8iwXce9GrYKYHQwrSsZj04CG+B1JE=;
 b=RASWZ7OUwNAmC3YWmgsAvY4gbrgUp5R7mrzQDW93/ONX3XHW7uiBu3V2vyfXy/X3p3Jz/JPCGoqYrbn+pqMkARUEfDgbLYpy9Ujh8NL/bs/iszDa7Hr5cCtRfuLYvPmErIgOrBrhpTf41I4k+u2DVJL20w1Tgkc5ic3fbUpUjn0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB6759.namprd04.prod.outlook.com (2603:10b6:610:a2::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.21; Tue, 20 Aug 2024 09:10:08 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 09:10:08 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Move UFS trace events to private header
Thread-Topic: [PATCH] scsi: ufs: Move UFS trace events to private header
Thread-Index: AQHa8rV5h+ucFfkuyUCmQ2xlw2JJ0LIvr4CAgAAsfUA=
Date: Tue, 20 Aug 2024 09:10:08 +0000
Message-ID:
 <DM6PR04MB6575B2E4649561213A15C253FC8D2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240820035826.3124001-1-avri.altman@wdc.com>
 <5f5d42a2-4c6f-4e8d-806b-c802c1881cde@wdc.com>
In-Reply-To: <5f5d42a2-4c6f-4e8d-806b-c802c1881cde@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH2PR04MB6759:EE_
x-ms-office365-filtering-correlation-id: 19927bb7-427f-4f5d-2e08-08dcc0f7e359
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y0x2Z1BhcFNlbkVic2ZwL1NrUlVOZVhDMFRjK2JWRmcwM0EvMW9iS2N6RmVp?=
 =?utf-8?B?QXBhRk9uWUt0WXZJZEdncUpPVlNRR2txbVk4UitXOWlJTW54MG9aQXhxYis0?=
 =?utf-8?B?TDhNVEx5dHZHdXFzR2NWcUJoNFBpeWozWGdxc21ncG1qdjZtNFY2RWIrQ284?=
 =?utf-8?B?RUJ0K0tmcnlocGVHS1BWSGxqZmx6NlpXczNrSFd6VXFrN1NGYWUrT0ZFWTI0?=
 =?utf-8?B?aDA5NmZCYXVHQXdDOTk4aEZBaThITGlaRnRMQmFVUk1uR2o4akVjN21LVjJQ?=
 =?utf-8?B?OFIxdCtSbkJwL0NFei8vTFQ1RW1jTGpoMlJka01DRDg3RnY4R21sQnZsVUkz?=
 =?utf-8?B?cnpobFZrZjAzeTFXMDhhU2I3WElWcjJ5QnRuQmxqMnZGd0s5VEpQSkZ5N3l0?=
 =?utf-8?B?OTR0UGl2bjNRdTNpc2RBTnAwMUVydmd1dXN0QUYxQVdzWE15QkRrMzRNeHF1?=
 =?utf-8?B?QlI0QmROVmN1SHNkbTQvWmQ4Y05JdEU2VWthMTNpODBxOE5rY3RSc2ZtV3J6?=
 =?utf-8?B?ZmxQdDdqdmhRMU9XSFJ1a2NnVlpXMXpOeERxT1BvdFptdjdQYXlubHhPS3lQ?=
 =?utf-8?B?VEZNYWJGT2ZoS3JVTEZKS2dNM1p4VkVsNkhHL21xNk9DYUU3WTFJR01GQTZ5?=
 =?utf-8?B?SVlPeGUzbVB3bXkzTnNsem96ZDBVYlAyeGE1RDBBWDBGelgvcDFmMGprK29w?=
 =?utf-8?B?MjIrcmtXTGNTd0pKbksvcW1aSS9mKytpQ3ZFZHZtS1BncHUzTnBmc1pTbE5K?=
 =?utf-8?B?dVV4YmVXMFd5Z3BranYrbW1meE9yWXlab2RUMEl3YWhxVkp1Zm1LWmVYRUVR?=
 =?utf-8?B?aWY5VVRjTzVIK2RsUTRoWVFFSzJCNGEvb2h2aXpySllZWVM1K0V0cmU4U05Z?=
 =?utf-8?B?alRQVFYydEdBeTU1Z2VqczFUdmtDUjQyNG1xVHJwRTczU0gySUwrWStiKzZ4?=
 =?utf-8?B?ZWc2MGphamFwaUpuY2JGVmUxMWdQWEtwUWVRSHBndVZqMGYyWXpXc21rRzBT?=
 =?utf-8?B?WllBdUxaV0kzU1h2ZTVCc1F2aEQwb1J0U01SMkR0ZGtUT3NVWUZzdmpZNFJF?=
 =?utf-8?B?all4NDhFOWlrcjdoSVBqWGFwQ2RMQk82Rk4xek5rQ1lBTzY0V0w2aWJHeWhn?=
 =?utf-8?B?cHpISmpXaXBTN3hTcTc5MllYOWhSd0dXTExoYmZZY2plQzBma0UxcVBNbTVM?=
 =?utf-8?B?ZEZOQy9mMlBLRmJtRWk2TTdta0xpdXVjUUlEZnMvNG5mZFNvU2NFS2NQUElX?=
 =?utf-8?B?THpleUhjT2dpZjZ0VjQ4bVNhb0pHNmtkVHVYWWJHeUducGRNMnYzMytndGpo?=
 =?utf-8?B?UnBzV2prTHl6VWZFSThtN3RFOGpFdkdNU1JkT0lIeDVyYndhUWpFR2hETEc5?=
 =?utf-8?B?Ky9QMkE3Y1ZXQ001ZUR2cXhsa1c2cHo5V2JIUytvMkxpRWNHSnJmYUY2MXk5?=
 =?utf-8?B?NkNCYjlJUUxxVlhSM0cvZU5oczRqd1ZSYit4bE45TWlFQlV1MXFCcU5ibXRx?=
 =?utf-8?B?TFY4WnJlRmxGb2x3VzIwVDRoenR3YkF1ZGk3RXFER0FQRDg3eXl4MEFGa1Fn?=
 =?utf-8?B?Rmw0Rlk5cTdNYXFyZFlMQlFORVY0bjIvQnl1TW1qY1BMNXp3dFFncWptZGN5?=
 =?utf-8?B?aTlQZXFxVTV0eitWcjBzNTNFejZrb2EvZ1phcTRsK0owdUdIOUk3Yy81eFFh?=
 =?utf-8?B?VThMNlpEK1lxbFovY09Xclhqb3QvdFMrMFRQOGZxS2Q4bmg4VGEwdjZhNElx?=
 =?utf-8?B?ZjFQbWtOUzJlZkNzODYyM3BXb3lrb2s1RU5aUlpyVXQ0SHRqSzM0aTlHNmg3?=
 =?utf-8?B?Y1lKUXBmSEJwZFZqck13VU94Tm5FSzBicUozWGNoYmRRbWhoT1pIdVhhQXdz?=
 =?utf-8?B?ZFdCVG5rNWVVRHhhR281WFliaEROeHJiQ3dtZkZFVWJKUUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZlhpcmMzU3czbjFHdW5zYzJDYzBST3hxcW1nc3Q1VE91Q0hGcFIxYWtNYWhz?=
 =?utf-8?B?akQzWEtMTjU2d1RBWk5EL0J1eEVzUXhaVjdhSUNuZStRUEphZjE2UHpIa3lJ?=
 =?utf-8?B?dTRqWDZ0RUJ1MURIcXRlejR4eDdobEJqd200S08rM3g0OFVXNk8rejd2L0FB?=
 =?utf-8?B?eDlxOWR4bmFLYTQxQ21wWUF6T3RYcC90Ry82d0FJQ21OTDlpK0JORmFBM3JS?=
 =?utf-8?B?U1NOL09VelFnc292NjRGYVdXcGR0R0MycTNjL2xRclAzUlNmNm53RGJEekts?=
 =?utf-8?B?UlM1M1JkVzVDQU95cy82QllEbUI4bm1iMVJpM1grSHBLTHJHd3FrOWk1THNX?=
 =?utf-8?B?ZS8xaTlXSktvaFEwWW1TcFp0bHFqRDZjOFJqVlFaMDQwYmp0d1MwNHpGVVB3?=
 =?utf-8?B?aTc3eDUvNkVib0RkSUlERm03Y1I1TS8xdTM1ZmFVYThLWndsS0E3RUowamN5?=
 =?utf-8?B?VXFENzB0V1FSVFJCQkU4UGVxQ3VUY21idU5jbUVLelBFTzZza3MzMW4rT3pM?=
 =?utf-8?B?cDdMeCs1N1pEcGhhL1hZc0ljSSt1S1JhSnJHZjdBRzF4L0svdGcxb29GeGFT?=
 =?utf-8?B?M2RwYjJTOVhVdG45WjhsU1VGRThscGV2bGJlOGV4M2Z2eXZTMWpWcVBpdTFv?=
 =?utf-8?B?RmZKRmQvK0Q5QTFyZGRLdFBNRzZpbDlTajU3MmFMTE8vRkIzV2Q1WTRuWnNP?=
 =?utf-8?B?bUtMUFNmSkJWYWE0dkVOT2VHSE5OcFJhV3ZLa3VRanVXMi9wOHNFQzhYL2Fy?=
 =?utf-8?B?YnNMc25zMHdJRmljOTBFZVhMcGtpRnpiajI4aFM3MENXY25SbTBKTnlTamE0?=
 =?utf-8?B?dVh1Um56M2syVjZ5WjNRK3ZMUFpTNnZxYXJvcUtscmg5ajhpR1FlRHdEVC9T?=
 =?utf-8?B?ZXpwY3hWSGhFQXRyVzVCcEZ2dWU3VkNJKzkyRDhpYWpJd1NUTHlwUW1aZHJ0?=
 =?utf-8?B?ZXhJV244cmhJNEVkalhkbVBiODlxRyszOENXdWRtcld2bnE2cGpwZG9mTHhE?=
 =?utf-8?B?QUVnUjlUSzdJNFFub0oyNGtyeXg0aDNPeE14ZGFzejZrbUwyalhTUUNyTWRp?=
 =?utf-8?B?Vk8vTS9vWkhobzdvcGd3ckc5bTErdHRwQzJnVnp4MFloeGZzZXpYUnZrQ1VQ?=
 =?utf-8?B?ZDFpd0tKcVlieDhobFhteGtMNk8ycWdTTDMvelJHTTlTWGZlM1AxUGxpb2ZY?=
 =?utf-8?B?T3YySUJWWitKci96WGhmaytkWTU3R3dJTzdoK1FxWXBMbmZQMW9uQmpoR3RP?=
 =?utf-8?B?cWVwZEVFOG5GNXpadmxxaDUyM3M4QWw1YXJPVEdZTGp2TzhrMXF0eTZ6bVpR?=
 =?utf-8?B?RlBzYzZ3Q21vSllPa2t6MW1Da2M3U0FKK2tTek95R2NTK1JRM2J6UmlWZzVH?=
 =?utf-8?B?dm1VSG5OeWF0MmVmclQydWhtYXVOZHBLaFNaTzJMV01BNlA2WTBwa2JtY3Np?=
 =?utf-8?B?dUlITVI1dmRKbEJjcUFtRUdyYXVtUEdlc3ZyQkVRSHJYc0tOVlR0ODEyNHpK?=
 =?utf-8?B?OVl4ZHR3eUhOQy93RHJ3eEgrVDVTbEpBYnZkY1pUM3MzUVVkOVQycHdObHkw?=
 =?utf-8?B?aGVLRFNsL053UGUrYldMR2h0Q09rR3Z4ZkY5ZlJuc0YvSkRvYXN1WHg0Q1Iy?=
 =?utf-8?B?aTBKVE5vODU1N0gyNjU4Ym1NSzM1QUdRdE9ycXlJTEI1NlZjeFprQVlncVFr?=
 =?utf-8?B?N2MzMWJoSXlKZUNiQmxjVnR4OVRaSUJwQUkxeUpDRjE4T1hQamloUHlOOVYr?=
 =?utf-8?B?ZVFxd2lsNXNhbVovMDNjTXhPTWpOUHpnM1lBL3Q4Vy9kZzR3Y3p6QWdaUlY3?=
 =?utf-8?B?Q2JWZjlhQVF5WldKTXN3VWcvUUhZcVRZNGVlSE1oZVAyWFZ2ZmlsUzRpNUx3?=
 =?utf-8?B?QmFieDRYcGRpdzJ5UWpvQWpOOXBDUytQc25kencrMmFDTXdmMldsNzVMUE41?=
 =?utf-8?B?TkdBWU5wWHc0S3h1dmZxSVBFVmlKbGhmTEY3WEcwdTVYMDEvWVRJSGhoMGVk?=
 =?utf-8?B?UDZNRDZDU25nallUK1hiQjlWcTczbUNoUmVLMnZJcmVXRmlKKzVsT25rTXdH?=
 =?utf-8?B?b09rdFQ5b09yRHlBRFJMbnVxR0hqbEJoWmo1WDNMRmtST2RGS1hyL0lUaGYv?=
 =?utf-8?Q?nIds9GDUu8bMvhkJC50siMg5/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hB8FvQ3InfUDX/RlPOUUuHtc8aDQZQ+1F8/ezxk/SNmlWm4eUQWgo9ReyN4j65VPipFHGA3PyIkxqBTBI1nqUS4hBlaJYUJan+qeWKyi5TB1SAcpYdpGkLew+Gi62r3cS1H+QXCPRlRgdRMN5dadb97cINcb6g2cudv9gsxlq6B+BCcywVbi2Pj2dbnAgx7SzvnFR4Rv2BbcDPlKxmVZiIbvwNP5ie58S79IoWlkjM1rzCOoDtyKEY0IxrGOgYQHFSGCfeygtkqxDVBI+VByz2R6LnGynT4Q2te66NNFL1p1QSJ+s0kjMx6SxhrnqA2lHUlJjNMe7ebSmz5BiR2MK08UxlvVGwgwYfdDth1MsbP1CXrRpbJaUR6wEjVy8ipkRxd6saNfGHQbMUoNl23US1/GPn/sNCCos9GzDvcBTPBS1mC/9SyKRTJGae/njllpZWYM/pV832dh4UVjaeKIqBaNn8BllIzgxhq+x6uiyNokoH5rjzjxDWP+1DcCk7v/CrFmB3N41b+R8bePnvo782x0flJE8+TzGbhKZ+vrsr5tUzZ4/AHxoPjMKGbSLLXDOeVSXnamuvsOmPRMcAG+RrVfknaZ1doMRpuNrfraG8mcgFGolFFcGyzc+FwshYN6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19927bb7-427f-4f5d-2e08-08dcc0f7e359
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2024 09:10:08.3432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CQwVupSU9PJKRQ7HLoKZdYL6tHQwhvPivauC09hYWa5NbBYuMy+J2PbSZtCDhLsWS6FVpuo/po8WT096O/mM+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6759

PiBPbiAyMC4wOC4yNCAwNjowMSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gdWZzIHRyYWNlIGV2
ZW50cyBhcmUgY2FsbGVkIGV4Y2x1c2l2ZWx5IGZyb20gdGhlIHVmcyBjb3JlIGRyaXZlcnMuDQo+
ID4gTWFrZSB0aG9zZSBldmVudHMgcHJpdmV0IHRvIHRoZSBjb3JlIGRyaXZlci4NCj4gcHJpdmF0
ZQ0KVGhhbmtzLiAgRG9uZS4NCg0KVGhhbmtzLA0KQXZyaQ0K
