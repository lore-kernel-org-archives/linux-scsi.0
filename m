Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23E519E997;
	Sat, 25 Jan 2025 07:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737790344; cv=fail; b=sya2s/lSOQVJ23kQCVO+ShLKwzFj+7oAwBX0G0bySoqublreR9fZ6BxH11JAr9jYryiKydV/24pWAMAANn1RFkWFvQKHO0RomXmLxAHAwSBw8t22Ewa0FarGHT8V4Qlyq9iLdlN2n0ROblkuf+QyoqLVHVfLsInUJqxVZA8pcQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737790344; c=relaxed/simple;
	bh=Prkfd2Nqoqopi1xYLYly+gnGriuMKgy5yroShYFxF1M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pupgjISchDUrnHW45upqtcpt5FQLDLXNZaZ+M18vSwT32zBV0TvdF0AZiO/4s/RY66ZxqqilnO4oxFgTz6AL9GE2AwWRgCp6uQBGQzOP6UObQvEFUrFziOvweZV30hUc4kWOIrWqy3CUitDAIW+duJ0j7JVJ9lpwNVZBJFazLvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=rifIDlxb; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=g3x1Y7qq; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="rifIDlxb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="g3x1Y7qq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737790342; x=1769326342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Prkfd2Nqoqopi1xYLYly+gnGriuMKgy5yroShYFxF1M=;
  b=rifIDlxbrp6qQDTO0FCdZKXt9r7PSpWzjBemT8sEHFwK0PTLYy7Cvbxk
   XTOHG9J1gaImfDyPj/GUUIFMaiHK47+HmseUa2QwbtQo1c5II/DEOQu8K
   UwMwzPF5WSslJtdgcE232fVrCShKaVD7/UYiGjE545VlqMS9EYxWqKb/3
   kd57BFeiyTeHgW7CTWTFU32g9dDNznpqeNBP/xu+RIMgbA31bHymMthUL
   PKYU/W0lKMW5NNRsQeZfgTpjKTG9pxfegllDDhKfybatnarjaaQrEnOIh
   pI0x/+jDU2e6DgnZaaIzIXkMY8mQdO3rDDHsVnsEwr2W9IcHp/VsuYzig
   w==;
X-CSE-ConnectionGUID: 2jPAro7ERMmmJ+NhJ4JwDg==
X-CSE-MsgGUID: OrexZW7PQhSY3xqFH8KxPw==
X-IronPort-AV: E=Sophos;i="6.13,233,1732550400"; 
   d="scan'208";a="37302795"
Received: from mail-southcentralusazlp17012010.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.10])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2025 15:32:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xib0FAJcWDopGyt2KxxDIEqPHW7ECNNohCWFT5sqT6SRkhOhIlY0J4klLqmj7IHAIg2eEYvE/Wr5EArhKj7pi8cuvoWDG+T/0mQs9yGZwRUOgE+PD/CgWcS84qH/INTLlhkJq23z4UBsNFul02Tn15gfxiYVVIzvITwYixdNnwkWtWLihyrr1NGadqFnP+rSaFGkRij/l2jrI/BWnsbr5NuTNHp7Kapd6KVyaS+Ng0se3ZSIYNZLEHxcV9pi9zqlI/eBlMadr+skkHspDEHmG7qVdITOEDz6PQ5HRIYUsF9f2bUhD/UXxhzes22rq0hs95gvAayXhqGuZphMqSvt+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Prkfd2Nqoqopi1xYLYly+gnGriuMKgy5yroShYFxF1M=;
 b=e2NfZ+mLkNPGjrV03MNO32un7p/MpG883zjasvAV6dR1+FrHNvNrgTuEgrDsug9waKDOzO4ZKl4MMSp7E6KUQ8g4CNZlyqR8FiCZJYuYCYqQTbV/PgiXezStX/V/muI7U8dvmDNIF/EkrhL0cSiIe95aSP6FxfbqvlkuF0PufZQ8lQYz/OsQqYS7UuDXSRaq9bOFrYJgoFxCjwBf/rg1dUbnEznnzhGCeHnSgLkiD27tRckOuzun0HSoEMfzUNZkhSk/xDlwEPA9H4OVdRSei7swq8OQ9Er/Stw8Razus+oy0zM8+Nr253qqo6hVPzSZW29Zw4A9Owq4lrmNGS7sAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Prkfd2Nqoqopi1xYLYly+gnGriuMKgy5yroShYFxF1M=;
 b=g3x1Y7qqr2YcBfF3veBG5zEENiAkUfREhTpmdJLdfN/fHPU1+F3zl+EX16Hg3cBizHZmNorg+BRVJzRbZ6RRZQbwHPb100QJzPcywYWpWDtCBSf4/bf5kgq+4OT28O+gLzbllY2IJFXAkwEeIjynv+BXdGtIrtZGBwzJebCDz8Y=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB8004.namprd04.prod.outlook.com (2603:10b6:610:f4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.20; Sat, 25 Jan 2025 07:32:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.009; Sat, 25 Jan 2025
 07:32:10 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Geert Uytterhoeven
	<geert@linux-m68k.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: RE: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Topic: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Index: AQHbbjK7MtFbQrGgbEacrXj0TabXHbMmM7MAgADmTwA=
Date: Sat, 25 Jan 2025 07:32:10 +0000
Message-ID:
 <DM6PR04MB6575F185D39AA7BB10C668B4FCE22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250124073354.3814674-1-avri.altman@wdc.com>
 <4bd2757e-ecc9-481c-b8c7-12fb68e0f526@acm.org>
In-Reply-To: <4bd2757e-ecc9-481c-b8c7-12fb68e0f526@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB8004:EE_
x-ms-office365-filtering-correlation-id: 05f6fb24-f478-4ba6-1579-08dd3d12613d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WWhTNytUMUJscUFkTFB4amI4TkFBMlJsTXVkajlxQTdYQ3gwUDZ4UXIydk1B?=
 =?utf-8?B?T1FESlZoZHU3YSsrWFJwV2hQc2djVXd5YzZxNEdrM0g5NVhaWTJmTmUzTkdQ?=
 =?utf-8?B?STFzdFNUTk1Id0VvNU9mWGVDUFFzSGdQUTNGZHEwcWVuby9LZlpXSjQ0Lzky?=
 =?utf-8?B?bWxQaWQxamJESmovd0w3NitoQ1RVbGZUSm8rQ3lCMUloRndFczBvWlNBaytC?=
 =?utf-8?B?eDl6RE1iZTFITkd0OERaSXp5UWtTVlFRQmVUY05UcDZKTWs4bGw3R0JJamo5?=
 =?utf-8?B?VXdaN0RnMnVWUHUzS1M0dnNsa29VZXI5aTBZck5nTnJYTFBkMXlUalJMNEth?=
 =?utf-8?B?dDJpK2UzR3pHbVROT0s2NHF4bVE2TkxRdXA2dUJoM09Ea3JwZ0FSRXcrb1Fq?=
 =?utf-8?B?OGgzblRiTHdDNVJlcGZDSWE4UXVHdTBMUGR2YkRRUTl1eFNyY1VCOTlFbVJH?=
 =?utf-8?B?V1dvT21ZdzFzYVNnT2h4ODdIOEdMQWoxY05HUWpsUzdSTnNlRkF3YldYYlFa?=
 =?utf-8?B?ZkJ3RGcwam9pSlF4UDAxeWV0SDBneitQZlNqem5yd1FkQ3ROZ2VjaUY2bHd2?=
 =?utf-8?B?VWVJVSt1emhwZTBjMS9EUmp2am0xN1E0ZWpTSStiWDIxNUlaa0FwejBkVUF6?=
 =?utf-8?B?cndmN2x4SXMrRHpBL2U1TkVBbTd5Z0UxMHJ6YTV1NUtseVRoRFdwSEdXcEww?=
 =?utf-8?B?dERFb2prMGFGUlZhK1ZHaTZYZjBVQ3FFcWx1dUt5dHhlK215U3FYT1BHZFFO?=
 =?utf-8?B?SEZ5SXQvcTM0Q0VJWXdycldvWEJCa3l0QVZnVGRmR1BpSFVRVFlrQVduMVZo?=
 =?utf-8?B?bktUUWk3cWx0UklkeXZxS0NvK1dGb0xuSDFxZmtyRGpSMFpkY1kvU0hpZ21Y?=
 =?utf-8?B?dGNMZ3VlS1VqK1lvNHVJTTBGUW9QMnh5KzY1S2h3cExkaHFOV3ZJeGJyOW9s?=
 =?utf-8?B?d04yQ2FyUDg5bFlNaUhtNUVBV0M2M2x6UWFTTFQ0QzFNU2lCRFpyT0dYZHFP?=
 =?utf-8?B?VXpwcldKckk4ZWpNYklwUUlXd010ZEhUajNyUXpVbjFEQWdCcWc5T3VsR3d6?=
 =?utf-8?B?cG8zMG55a245R3htOHYxcnY4eUpYd1pqdyt1QVlEZE1EMWRicFEzb1NmVVkv?=
 =?utf-8?B?UkNINmhnWllKMTlBQytoMUFudXBEU2NJQi9EcEh6RHdIREc4WVNYNm02aFp1?=
 =?utf-8?B?MnVERk1rZWgwZFZMdlczRTBWWTFOc3lkaVZSQUZGYm9scEgxanVWL2N0dndo?=
 =?utf-8?B?aEFNc1FFK09uNlNQNUVjR280dnV5ZWdnOThla0NWRmFEdk04MU4yREw5ZnJ0?=
 =?utf-8?B?M3NvU1cxbXdmdFN1K0ZmdFl2NmVSQ2cxcTNhc2tIcVZCbnNzajRhaVlFZHI3?=
 =?utf-8?B?S2xPM2I5Z1ZwN3c1a3l6eHFZRlJnOFRDSzdyRUV4YllxWnBqeFpmRmI2TWhY?=
 =?utf-8?B?TE5md0JwR2FLS0JZd3FJbWRRaGY2ZXBTczZ2WDhaYTdUMzFKdEl3d0RpZVg0?=
 =?utf-8?B?M0dGWnM4MmZDUG5hajV2RUxpYWlrK2p3NU1aMWZNdVJBSTlXalRaZlF0bTdo?=
 =?utf-8?B?N3NuNjFVbHBGNWhwdVJJb0ZSbkdBZVVEMWxBekR6OXZPdFNvU3VOVTNMTnhr?=
 =?utf-8?B?clB0UGs3S2xhTU9pNWNJQ0JiVHNmMGc3UGNoYitVeUh5dENobXIzcEhPV1Bl?=
 =?utf-8?B?L2JVMkRYT3ZYMmtuS1kzaVJpZ1VFSERkcFZ1Q1JaOTltMUFXVVhUZkZjVWZQ?=
 =?utf-8?B?WHhhaVlOdGJyUUw5M2wySy9OTTJYcDYrUVE1NkVtay96OXdWTzEwc1dYbE8v?=
 =?utf-8?B?Z3h0dDM0bmgrdlA3azJOTDJmbkpkbjFEZ0loNk9yNk1ZMkhJQmxKT2ZYSndn?=
 =?utf-8?B?cU9IUlZTb0RIMExEcFU1TjhhWVpnclRXSVc4em1hMzAzV013R3ZSN3RTY285?=
 =?utf-8?Q?MYIOCghF5c/C9g/SbtqAFFuYviR58vKb?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UmZzRklHR0xWMjNJYkZuRWg0amJkVUpNWGZsTS80YXVzZUN4dTBCODNFQXZF?=
 =?utf-8?B?WC9ic3dJYld1cmx5OU83Unp4L3p4ZG5GQnoyRWZrYVAzZ05LT1ZZYnhlQUVU?=
 =?utf-8?B?RXdNeGc3R2RpS1JqbndLeUFGaFhLampVYVZ5VlY2SFA4dDdIbHVCUTVLaEg1?=
 =?utf-8?B?ZldDMDlnT3pYbklCcEVpWDNoMUdnK1NjLzR4ajVKWXQ0WmNXVzI5RjQwclBT?=
 =?utf-8?B?VVVEUHc3Y3dYZkZJcGo0UStxMk93YnBHZ0taM2c3Um8vNWt4ZHJuQWtHM0k2?=
 =?utf-8?B?VDkycXNSODJDSS81WGpPSENidDh2Y3pPUUV1U2tXYUE3NnltTnNobkdKclpp?=
 =?utf-8?B?bXJ2WlNVMGlaaW0yNktZUmZVZk15OXdldll3MVBjeU96cWo2b04wWGk0LzJC?=
 =?utf-8?B?c3hWTjkzQTBLT3A2UTFtSGNXdktMK3c2bWxicnBVTEtzYm9zTU9BUzZpdm8x?=
 =?utf-8?B?Mjg3aW1naHVGZXh2U0szVFlEb2duOHNmM0RZakdJODEreU1OUUJVTnNsaGpq?=
 =?utf-8?B?RUp3dkJyYzA3dHhYOWIyS0psNy8xcTBNU08zN3NFaWVLbS9KTlpyTzVqb2V0?=
 =?utf-8?B?OFBsMGF1aXBzRENINlh6clFVMURoUTJtVHdjZGtnTkhFZ294OHFtUXJnMXhw?=
 =?utf-8?B?RWF2S1hPSW83UmxoT3RjTDIvVVB0di9GNEhEUklkUzZKNHcvaVA0MXRMaFhP?=
 =?utf-8?B?a012ZENzU1R4Nlc2OUZFSHRVY0dNMEw0QjIzSWZ1THlqRytTQlNqaGRQQjQz?=
 =?utf-8?B?MGV4L1EyRWtkaFptVlBqdUVJN0JUZE5ZZmRjNmhLOWN2SFM0MDY5Ui9jbUU1?=
 =?utf-8?B?UUxibjIwUGt6ZUc0bk01UFdyc2J1MUo0ZWZQWUpLNEF3SGR4U0ZNdUhMR2R0?=
 =?utf-8?B?SHYxc0JlRmVFT3FyMnhYdWJDUTJWUHYrQk9CdUlGNVFrRmlWQ1V5SGlUZ3N2?=
 =?utf-8?B?NmJKang5enJoamRWVTdqMWh5YlBqTkloWnA5UCs0b2I0OUVaaGNzbmhLK2dy?=
 =?utf-8?B?NS9STU1oSTU5cElLcWE2ek56aUlBSUZLUk0waDk1bDM1TllWOTJDRW1lUEtl?=
 =?utf-8?B?NDY4LzNyWjdWRVpXL1NibEpTNGJPbjlHMGNLM2h3NHE0VG5LWHltYXJRK1pJ?=
 =?utf-8?B?RkdnVFRZT2V4ZFdiTHl0U3g1TDVtMEJFcHVmTDR6b2d1dDg0UlhaY2dFek1Y?=
 =?utf-8?B?SlRaK0pTRzNGaFRmU1ZLemJ0TEE4ZTR3WGpObnltK0srbEloVGI4ZGdqRW8y?=
 =?utf-8?B?MXZOQ2hNdDN3bmZRYUN6QzFBTU5VR1E1UlZzMkRiWSs4UDEzR3NRUy9IaDVY?=
 =?utf-8?B?SkQvS0NUb2xTbHRyRDFvSVMySlYvSEk4VUE5QU1yMDdoMjBvOTFRalFDN2h0?=
 =?utf-8?B?RUx6cEJ3bjdreEpIREZFRkpqelJBYWVTcWs4azVsaGdPSVQ5MXk1eVRNeG9J?=
 =?utf-8?B?Y2k0M0tKam5PaDRqek0yQ0d4MkxnRUUyVzl5enphbjJ1UTVJQmlieEpBRlRG?=
 =?utf-8?B?alBpdVpJa085cVp1Qmk1SjBZbENTSHB2bTltS3dla01jTzY2bDlZTmE4SW53?=
 =?utf-8?B?d2NQMEVVbXR3cmpVTm1acnhCTVFUSHNvNGVzQVdqU2h6RFhxY3ppdmZuQ1pD?=
 =?utf-8?B?U2F3MHIzT25NRE04R00raFo4WlE5MlFwY0FSZDZoaFd1enBQZXk4NE81eVJL?=
 =?utf-8?B?cGpMaytlRTdIWlRDMTlvZEc4d0lwSFlNelJKSnNuTjFkaGhTQm90T3NkR3U4?=
 =?utf-8?B?OFpRa0xoL3g3Tjd0ZUNFcUVrMjJMWnpocjVMWnp4TlJkQ2wzWllXMnd3V0N2?=
 =?utf-8?B?WmExWU4yV1E3SXNPRndtU1R0UUNYazBWczBiZG9vYVUxY0FXYS90c0RPbFVW?=
 =?utf-8?B?N0UzL3c4Y2tSNjh4bjBLdzB3aEhjd2ZVa05Db3AxS09JYUxpZXdTbkkrVENG?=
 =?utf-8?B?aEhSdTIvcmRCYlh3QlA1ZHpZTnJIVUVlRU9BRXZxcHdxNTMwTGRyZHRjZ1hQ?=
 =?utf-8?B?RTBsdzRHNmxtTDVOM0ZiYjVUcVBJTVc0M1M5ODVYTDB5VEREUy85RER1QmZl?=
 =?utf-8?B?cGZyNFdVNnVPekxGeDhSZHgzZnNMbEhzeFRzSWhGZGtVNXB6VCtteUQ4N2Fn?=
 =?utf-8?B?K2pTeW85WmlvNTBqdnJhKzRTdUVNVTFOVWd0aGFzTFRaU1JSdFlpanNGUG9s?=
 =?utf-8?Q?A4PBV8IeQkNno8TvDNUMlzE15mUYCklTs9FYrtDZAkRC?=
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
	oVPz7wn4KLo85rYB0HKoEdplrgYMl3hcXrufnQuqCGyq/NfVjOTkxhtvQBKlQW+PwxmW3k9LbQTK4yUNfvymMd7DaBmbgHoYdsy86XQgTujnE6UHy/y1+N/PbGVk3tgMGuzS+chc7O0zcTUXPsectESH1llcRODV9vKItY8ZwSGM8jXJ075EB041JMGtGHp6PxOc0YBxoRUVp9bOHzPoVUAMxGb4sGOoHHTJPl6eXMsW7pM57gqO92tyolZGBTrxsinXp6nEFf9dh/zlxJ9MwJbpR2i3IpX4ZlmBl+jAM183jFtcG7i+PiWfooFywPe+wwhjvdNj3AdokeuOwsixvNqPo/Falp+EQWIQ1C7z39BuzdEtPVZ5+habmTPLRsl/z0szekwf1l/F2AEfxpY6rxkj4jptaAc3BMgiKeLS4L8cEKhBFzy+KJDr+b9ygnSc2PujkOajydo//TmhkiqkSntOW4tViwzKNzVKCStivRKqD+byzZ9cS7txHpUVAX6UX1cRoY9uV9T6uZKteTNvrgUpfh1Xp7tJ95RmpKOBmcf/HnpDsXpuSvk3Op0ysS7hLD0W4It7/cCDi4QuXAry770uEufdyojNX+Yri32L6X193Cz2z9iNexTZNYo8E0XA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f6fb24-f478-4ba6-1579-08dd3d12613d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2025 07:32:10.6491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0kXrdxidW8GnAh7JW7V7HAH1ms9O9KqlwUvapch3UdMbSCbIR8CCx/44lkSvcE3PcsJedJAQNHPktMHT3fQa9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8004

PiBPbiAxLzIzLzI1IDExOjMzIFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArICAgICAvKg0K
PiA+ICsgICAgICAqIEluaXRpYWxpemUgY2xrX2dhdGluZy5sb2NrIGVhcmx5IHNpbmNlIGl0IGlz
IGJlaW5nIHVzZWQgaW4NCj4gPiArICAgICAgKiB1ZnNoY2Rfc2V0dXBfY2xvY2tzKCkNCj4gPiAr
ICAgICAgKi8NCj4gPiArICAgICBpZiAodWZzaGNkX2lzX2Nsa2dhdGluZ19hbGxvd2VkKGhiYSkp
DQo+ID4gKyAgICAgICAgICAgICBzcGluX2xvY2tfaW5pdCgmaGJhLT5jbGtfZ2F0aW5nLmxvY2sp
Ow0KPiANCj4gSW5pdGlhbGl6aW5nIGEgc3BpbmxvY2sgaXMgYSB2ZXJ5IGZhc3Qgb3BlcmF0aW9u
IHNvIHBsZWFzZSBkbyB0aGlzIHVuY29uZGl0aW9uYWxseS4NCkRvbmUuDQoNClRoYW5rcywNCkF2
cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0K
