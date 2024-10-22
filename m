Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C344A3232;
	Tue, 22 Oct 2024 06:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576908; cv=fail; b=jxIfhCRA6lD37KDgWWY9njzfuDm2RO4yA/CCv93m8Ql9Z5bng9499wHe8sKLFEfxpOj4NNG1OIve7dyYkZjdIMLaCfVORUJeafupY0k1MUjrH1TLKjwJ3rRrDpWYck4H0O6EOed9bsWo9PoYuHsY7ky460cYpJJQzbgdo/X3jHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576908; c=relaxed/simple;
	bh=QX5Brsc5erJ27Jpmv0Sz1oje8zVP/zpMyNPLCqcpdQw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pCaT3OkSULHpBqW9h2x7We/V4a31PQb8V54AKQI8mSrCz89GybF9slWa73n9SmcKbwLayn4fQ7vAJl1FAVk+3JE+8xUnXdT+bycae/kOtykGn3BdveyetgVxeSVspx46N3r0jWuuy07SBxBe6Spop2Ij+8HWwJ0hkD5PG4M26GU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mSOi+0bd; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=F1RZtedC; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mSOi+0bd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="F1RZtedC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729576906; x=1761112906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QX5Brsc5erJ27Jpmv0Sz1oje8zVP/zpMyNPLCqcpdQw=;
  b=mSOi+0bdeirOIqI1WMh1Io0c2pGxmI+94aKoOjh7E5+OxCBSzX0U2Sas
   OpLbL7TZrv/+U4w1qRgOJboe0+CIm6Kyu4ZB6APsISFMOwY8Xc1ViOkfs
   JKtx9a6zSCQynt+Pcl5+TbPyJmAbqvSlFA9tILUDZc3HNd/clDTawllcn
   B7mWiJloxFRvVbFRXPPp8EiQMYaEtUVj4NZrvRPDiJutwKYKtYWeRZx2Z
   T+V95ZIXfkGtfTtmz0SmzjEPcXBWi7LjM5P6aNX9ruGNQFqYZ+80bK1k8
   tSZ2ELC/15nPg2B7AoeYTk3/5gSV1GemAroXaehEfBxMR0hGnKhbMPXFy
   A==;
X-CSE-ConnectionGUID: uHjDQCAtQhqY6MebGm04nQ==
X-CSE-MsgGUID: ia7opgYZT7S9Y8fyPnGr1g==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="30660746"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 14:01:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skv+Fi/pC8z8LZOgBiSheEqYcTAPsKQnmGfbi+/yDyDSHbuRYlByrDOFAMzlmKPOmxkMMZhtJy4+htnH0VPZeUyXGUFRvF06wYs610rHK5x9Tg2bE1JB9sPRIg5iis7PbSC5O0Lih2Wts8jpVEgFgEnALGxXeuYdc43c3HtQF3DIBl7ds2VKEraEvwf5vYw1WCymqft28i7EMsMgXIPJVKkJ1lec0D0MXfrPMBAJiOu8DDdcfgXLh1dIPUXP+syemZpt27Br7s+6ABV034iWr1P1NUCRys+VFkCdtdVnavwy7PDZdVL7fmxx1CJnofbOUdIUHvlnzIHsBaAdWYAJXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QX5Brsc5erJ27Jpmv0Sz1oje8zVP/zpMyNPLCqcpdQw=;
 b=KnkVT6MwuX9wjtyG0MLsULVGVZLQjb1L8jh4y5t95aVNX8fQQagXQl2TK9mtRE8i9xFYLE4lwecBB6NCeB3iMsfFMfJoWLO+HEqkc9zHUiKE25f0NL7uzeRWNqqqMwczECGnBsRDukj73nCjt0fDb8bb2+sl9dcK9iTAkcmHDb2CyxqxL+KTmsp5KBVLAfsDKrKWP4gLUXqujauLVd7fjh5Cu62tfof3xNrjtmwKqSBNLan6Cc4fSd/kF5qXP412MBiI8IpZ+bgratF4WGYjLOVgCkW9H6QSx7gRn25dfnW77hjb0/FYNZeTh8ZiOhYl7jvdn7N/HQufhosoN3GPmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QX5Brsc5erJ27Jpmv0Sz1oje8zVP/zpMyNPLCqcpdQw=;
 b=F1RZtedCfCSpC7ha2JqWkfD1YIqiYg5+UJncK3gOPhcRMNsy/8XHbWR64j3YbV6enTqqxSpkRBeDMslm4EtLR2qaV7zlq6DVJokG1JIgXNmtLQA7C9qMHoyJwzdVhh3pqIRM2/mJz4kjAI8uRIEbDAstCMI/tMcJ2gGFRApJFCU=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by CH2PR04MB7109.namprd04.prod.outlook.com (2603:10b6:610:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 06:01:43 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 06:01:43 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] scsi: ufs: core: Use reg_lock to protect HCE register
Thread-Topic: [PATCH 4/4] scsi: ufs: core: Use reg_lock to protect HCE
 register
Thread-Index: AQHbI7GX04FTCZ+iXkyEl3HUW5xNrrKRoRCAgACkxoA=
Date: Tue, 22 Oct 2024 06:01:43 +0000
Message-ID:
 <BL0PR04MB6564D0850FA21E845B558FAEFC4C2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-5-avri.altman@wdc.com>
 <c58e4fce-0a74-4469-ad16-f1edbd670728@acm.org>
In-Reply-To: <c58e4fce-0a74-4469-ad16-f1edbd670728@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|CH2PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: ffd70e14-2b2c-470d-19be-08dcf25f010e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WC9vcm90aHRtK2RNcE53d0dFM3pXc3FSNUFiOUdPdVdrNm9GeSsyQzRwT1cx?=
 =?utf-8?B?R09sQUt6VzBzY0M3dHVTSk1uSXBrYzlvMXpZNjZDUU9jR2R1M0poVXNCRGZM?=
 =?utf-8?B?elZTNzFzM3ViRk91MXE4WmZMalhSUXRBSmxUV3M1OVhrSksrVnVXcjNiR2Zo?=
 =?utf-8?B?b1djWGRJRStxMWU3WXRvUjJMMTRrelhYaGNJNXYwZXZmVUVFZ1NKRzZwZ1FI?=
 =?utf-8?B?alBKQjdvaDQxUjZ5MTN3Qzc0aWVBbU1mTDdXMUNZb3dFc3VlTjhTUUZPTkJX?=
 =?utf-8?B?N2ZIczNoa3pFalo1SDdjQWFDejNJWERlUmdHR0M3S3RkUVFrMStpMkxzQkJV?=
 =?utf-8?B?OG9qaWZ5NjRjb3VHQWxiK3UzUHUwYkYwQ3JRTE9GZ1RERWN6Q2t4VFNDVXRO?=
 =?utf-8?B?dnJpTy9tZE12cjB3dlpIT1A2enloSUFvbmx0SUJCbVN0cFVsajM5TGNMdUxK?=
 =?utf-8?B?NXhhTnlMKytYT0pMd0RXVVhIeVA0ai9VVWZCNTM5VWlhcVArbnpLQjI0emY1?=
 =?utf-8?B?MkFzVjVNc29zTE8zS2srTEJ0SjRHdnJmWGNEbC8vRFYrUE1GTlpRQ0I5Zk9B?=
 =?utf-8?B?cXQ5MUVCR2FJWmRCeW01aXBxRDQ5TDBGRmpPZi8zcnoyYzNZelRhb2FVSFZo?=
 =?utf-8?B?ODJyMTJDSkIxMXM3UGszN2ZMNW5LZTFkTlE1K3BucXJZb0dMVUdYVU1JaWNG?=
 =?utf-8?B?KzA5Mi9zakV6MHNXNDY5YXoxazZwWm40bE5oMEVpSjNPVXlyYVcweXl4bHpG?=
 =?utf-8?B?ZEFCYnFKcVJiK2Jvc3BJZWxNOGR5bVd6MUVhLzdKb3NXSjB4bWRQSS9QVS80?=
 =?utf-8?B?VDJJaXV4YjVHZFdrMzFmTmlBTWxhK1ROVmJvWVJCSmQ0TEViMFRpejhVamxY?=
 =?utf-8?B?elM5TG9FZ2pZZWg4TUJRSmFLSi82OXVmeDZSellrK3BObmpPRTEzS2I1MVNX?=
 =?utf-8?B?UW5wRFllVGoxMHFzRFVhYkNjcFdDbVZBTkRKdVQyNEZkdUpLN2puVmdkZlBq?=
 =?utf-8?B?U1Z1UExUYVQ1VlhMT1VEdkxJTzBacGF0OTQ0WTM4WExibndvb0t4aUFJb0FG?=
 =?utf-8?B?VWU4WUhDc1k2L3E4NVhWYzRrV29CZ1dnNFFwYkRQS1hlMzRMSmRMRExkSnph?=
 =?utf-8?B?ZEZCNExPM213NlB4Sk8yNUdvZjBLeHRYd2x6eDlObXhnaUFxQ3VQZEJONThH?=
 =?utf-8?B?WHlKdFJRUG1hRGxOYlQyeU9XOEZUZDJYdHd3VTVYaERFWEhkRkM0L24vOGJz?=
 =?utf-8?B?aWNBdHZ6RnRpTVlpeThDZVJaU1pMY3NIdjBRUUR4a2JDRTJ6V2E3VTVjeE5Q?=
 =?utf-8?B?K1NwQXdIT3lTUFBWbVRxMFlleWlXMzJDSVdmWjE3cXdpaWNMa1hXWUVLeFph?=
 =?utf-8?B?Vk91K29hRFZSd2Q4TFNEZ3czWlp0NXJycmM1WDNXNlhXczVNUEM3SlN4bkw1?=
 =?utf-8?B?RTdFbzNVajR1eUMvd2tYRWZDdzc4bTBrbS9xS2tIcUZYRzNzOFdOWkowRHhr?=
 =?utf-8?B?NlZmZ0RjOGpSbzhCdEM3QXQ0cDY4a01QSk81MTBsRVN5S0Y3TGdMdzkzdy84?=
 =?utf-8?B?TTlUcUlFbnBlWU1hRTEzd3hQczRETnpHTVZjQ1NIazJoWmtRNVZIa1VBZ2w0?=
 =?utf-8?B?RGpyUjJJSUJtczB4emV1U2xHZjJRSXNSUE1yclNiRDhnR0crMGZlNXhtRHE2?=
 =?utf-8?B?ZGg3by9jd3lkSkhDSTgyaVZFR1pFeE8vLzlxaUU3WDNoNEEvenF1UXN1elhu?=
 =?utf-8?B?V0JoWE1nQWZoUGJIZ1lPZDdJMXR6USt5U2UzZ1RVU25WK290cEw0UGZQQ1Zn?=
 =?utf-8?Q?pHOfSYH/1NSrXOB+fR7ty78KyROReLKamW+eU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2JTSWgvSUJhQXRadnZyNnJtVXYrOTFWSXBvcmpvYlZuYWhLaSt4OWRlOHUw?=
 =?utf-8?B?ellmRVdXdnZoUTVLQkpSZmw3K0NJblhBOGxaVURsUmhDUktEelBLdEJrNEJz?=
 =?utf-8?B?a3hZZ2kvT3ZGais1WTVNS3QzZUdqbWpTcjdvb013ZXV2c1JCbTFNKytEVzFO?=
 =?utf-8?B?ZzNMeTFaY3ZLNEFXdlFlL1FFbnVNRXBKQlI2d3FnSWZsMy9samt4dm5UcjVn?=
 =?utf-8?B?OXVUUlo2WmY3SDF4NnIzMUNhcDRzVWZxRVJMak0rSXZjTjNDY0ZmakN1SGVI?=
 =?utf-8?B?RGZ3eDcxNG1mNHpMaGx5QWZsMVdTbCtLR0hKM20xb3o5ODRyMy9ld0EvbWk4?=
 =?utf-8?B?eVdyME80ZHFEcTRoY1lNV0hJQkhGb25PeWFiWGc4R3JjOUFodGU2dFJtVTdk?=
 =?utf-8?B?dVVRb2JQS2ptdk5vd1I4T3BkYmlMMzJUQmprcHlqR2NQVnBSSEZLOTFDWFhl?=
 =?utf-8?B?c1lOcVQwbC9vNE13UW92U3ZoNndPdi9VTHJORU14VTRyUUFadTcrWFVHTity?=
 =?utf-8?B?Y1ltV1VqTjF2ZkxsVlNFT3lpM3huSkNaYkNXN0tWU2hhc1pvQisxR20vZVM5?=
 =?utf-8?B?TFF6OWpzTkRBNXJSeXdLN1Bia1B1NmhyZEY2MHQrL2Q0bkxjV2trYWgrY2pF?=
 =?utf-8?B?Kzlab09VTkw0UWlWMUdWZnVmanNRcVNYd1AxTmQxRkJmNlpESEZYRzc0dGlS?=
 =?utf-8?B?cFBocnJWMmxKV0s4cGJBeEdWUFRkd1EyY2wvMzZqbGovcUlxVHlVeTVlNSs2?=
 =?utf-8?B?TitkSWp1clQrRWIvZU9BODVBTzNpNHJNK3NHSXYvQzRJTEU1YzdHYWR1am9t?=
 =?utf-8?B?TmpFWk1qWmx6cnZrOEw2SDg5QjJPYTQ5TUVRNUYza2YzM3FDZzdBSDFTb1lZ?=
 =?utf-8?B?VDAxR2ZSVEZNMitBMmtwTzRyUFhxdG9UZjVqZTNXV2V0ZE1GWERUS3Y0OHR4?=
 =?utf-8?B?L1d1OWtTRnlGdytzZFVsUy9BWmUvMlpMYmQ4NFFXMytvUll1ajRHMldWOXdB?=
 =?utf-8?B?bnQ0NFZCc0ROOGNRUmhwZ0RpZTdBS0tjZnEwaG4yMjdELzQwaVJWTkE4d1hq?=
 =?utf-8?B?MkhRSG11QkVFYTV1ODVYY0h6bTROMnhYa3hCUzBrVGpvajczZCtwdkFWdkVh?=
 =?utf-8?B?czlkbjc3OVdrcDlhdkQ0eUx0QU5Ka1E3dWZ5OFU1dXkwRmV1Qlhjb0h3WG0x?=
 =?utf-8?B?VXBNZ1k1WUN1ZDVWcm9ZTURjKzFsVzVUL3p6WnhtNmdMMkFyc3pjWXoxWVJF?=
 =?utf-8?B?bDBaWDNMc1kwS1JKanFiTWJSZHdyTjhwWTIwcjY5S3o5S1BPMWdEUy9kQ1pa?=
 =?utf-8?B?YVovcnZoTFNpZW5NUzRiNnJSZTZvUmhhdlg1TEpkTWE0TnowVEI5RmdVcnVH?=
 =?utf-8?B?blB6bm9ZcEV6b2YvZGMrd3NnRXkxRndLYXNza1VDWTdPWjdlamhiRlhsTitP?=
 =?utf-8?B?RnIvcXNISkNScFJQcGoxbVF1RWVlWmZMWXNPelhBeS9lOTRJL3VkbGY0MkFo?=
 =?utf-8?B?VkxTTlN2emM5Nm1pRVFCVWdHQ0Rad1U2WEZhTDkwb2I0QzNaUUR4WEZhcmpR?=
 =?utf-8?B?M0IyTFY2cWNkVmZZbGxVSEFZTU9UMzZmOVRYS3gyTXc2K3J2VWVkY2k0S3ZM?=
 =?utf-8?B?aDgrMDJvRVJtc29vN1l3UW9wRmlhckxNQnhKQ2JoaHl0SjQxZnljOHQ1cnNs?=
 =?utf-8?B?ekpXNkdQQk5zRHRZWkhZbXY4bXFxdDh6WXprWG9nQUkwc01QZWNCWCt1dWRG?=
 =?utf-8?B?SzNhNityQ3k4Wk8xS2JJblpjZU95R1NuZDNLeDRWR00yOHp6aUhpbG8rRnFq?=
 =?utf-8?B?M2t5eklaT1JrbVJrU2ZOcElXYlA5OWhndVdXOEhGeTQ1TWd1K092cy80NFR6?=
 =?utf-8?B?NmREc1RGaFJBSTJkNzVIVWxsV1lTL04vVlB2dzRJL1RraFV6WEZpZFVMSit4?=
 =?utf-8?B?akY2VHpRbzNyMUU1bFNTenpFYXFveFpLbTFWN0h0VzJFakNwUGFtMW94ODI3?=
 =?utf-8?B?UmUzUVRhdlN6Ymd5UmxFa1NySkpqcG91bmx3NVp1Zmt6ZXNFR2F0U3lnNDNM?=
 =?utf-8?B?R2IxOVNJclJ1WFQ2WGZLNEozeVlhSi9FOGRHSmJYZDdCOXRwRTlTckp1Y2J1?=
 =?utf-8?Q?r3DDSGeVoqZlJBKugK7I3ys8F?=
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
	d1VxxrP4zlrCljMbrsSElHnp3bnijNgfA+kzaNgDwHr2i9kgwdwTyqUE/lPvt3/wsGkOk6y8jOo54jkaTkKsDSyQt5FfZpV7ptHW22biK00vZXeZ/cw/1NOt+U7x1O2f2+DwexoJWzz/IMiFpWo9FMN+LWh7wII2f0sD1jiKbwts09KqQiB9URXCufjhLfP946yTa+IZREPLh32db3UHJfV8Cpnd1QWkSyhj45pF/oIa/kvZTp528TMLC5soaXE8ovQteuDmNw6GFg/dwwjJ565SCeRbPLUxkFYWzzBg54gx3FuBorllPLSyZzZd3gmuF9WH6USxGrdgYw0DpKWQNQXG+u7MnNr/6Nz6TCUlb1xvDCtwf28lAb5MSy9P6krnmio+YOOs+MVSznIsLE70Aw31XkAGXefczmEV9qBSnGXXYKvK+BBuTfVEQNNbA6JyIA68KaFRq+dfFtG/IFKCNQIM8ZQS62k5MQNU6CPYo07KNI0Sm7UFCpl7pEsA/E5pClQpjed4xUba9L0XQVlwen1gienjVWLdXOWRK761fVsCSK2e2Q5s0R9qZz+3BJSxwcFb1krp/BjnZckBGXgvKeGcl9CX1oCk0GltgRN7MZ1jT6UhVy8d8pLLBYVuNslk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd70e14-2b2c-470d-19be-08dcf25f010e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 06:01:43.3062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P4wnG+3264uW6O9Dgs8ubyXj/Y53DEcAWumbsZ4Y7upvLkWztKcgnvzpNl7115+wfzRoUKg6XpBb1CUT5ACj7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7109

PiBPbiAxMC8yMS8yNCA1OjAzIEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBVc2UgdGhlIGhv
c3QgcmVnaXN0ZXIgbG9jayB0byBzZXJpYWxpemUgYWNjZXNzIHRvIHRoZSBIb3N0IENvbnRyb2xs
ZXINCj4gPiBFbmFibGUgKEhDRSkgcmVnaXN0ZXIgYXMgd2VsbCwgaW5zdGVhZCBvZiB0aGUgaG9z
dF9sb2NrLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFu
QHdkYy5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwgNCAr
Ky0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gaW5kZXggNGVlZTczN2E0ZmQ1Li4zY2M4ZmZjNjky
OWYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+ICsrKyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBAQCAtNDc5NSw5ICs0Nzk1LDkgQEAgdm9p
ZCB1ZnNoY2RfaGJhX3N0b3Aoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gPiAgICAgICAgKiBPYnRh
aW4gdGhlIGhvc3QgbG9jayB0byBwcmV2ZW50IHRoYXQgdGhlIGNvbnRyb2xsZXIgaXMgZGlzYWJs
ZWQNCj4gPiAgICAgICAgKiB3aGlsZSB0aGUgVUZTIGludGVycnVwdCBoYW5kbGVyIGlzIGFjdGl2
ZSBvbiBhbm90aGVyIENQVS4NCj4gPiAgICAgICAgKi8NCj4gPiAtICAgICBzcGluX2xvY2tfaXJx
c2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgIHNwaW5fbG9ja19p
cnFzYXZlKCZoYmEtPnJlZ19sb2NrLCBmbGFncyk7DQo+ID4gICAgICAgdWZzaGNkX3dyaXRlbCho
YmEsIENPTlRST0xMRVJfRElTQUJMRSwgIFJFR19DT05UUk9MTEVSX0VOQUJMRSk7DQo+ID4gLSAg
ICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0K
PiA+ICsgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhiYS0+cmVnX2xvY2ssIGZsYWdzKTsN
Cj4gPg0KPiA+ICAgICAgIGVyciA9IHVmc2hjZF93YWl0X2Zvcl9yZWdpc3RlcihoYmEsIFJFR19D
T05UUk9MTEVSX0VOQUJMRSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIENPTlRST0xMRVJfRU5BQkxFLA0KPiA+IENPTlRST0xMRVJfRElTQUJMRSwNCj4gDQo+IEhp
IEF2cmksDQo+IA0KPiBIb3cgYWJvdXQgcHJvY2VlZGluZyBhcyBmb2xsb3dzIGZvciB1ZnNoY2Rf
aGJhX3N0b3AoKToNCj4gKiBSZW1vdmUgdGhlIGNvbW1lbnQgYWJvdmUgdGhlIHVmc2hjZF93cml0
ZWwoKSBjYWxsIGFuZCBhZGQgYQ0KPiAgICBkaXNhYmxlX2lycSgpIGNhbGwgaW5zdGVhZC4NCj4g
KiBDYWxsIGVuYWJsZV9pcnEoKSBhZnRlciB1ZnNoY2Rfd3JpdGVsKCkgaGFzIGZpbmlzaGVkIGFu
ZCBiZWZvcmUNCj4gICAgdWZzaGNkX3dhaXRfZm9yX3JlZ2lzdGVyKCkgaXMgY2FsbGVkLg0KPiAq
IERvIG5vdCBob2xkIGFueSBsb2NrIGFyb3VuZCB0aGUgdWZzaGNkX3dyaXRlbCgpIGNhbGwuDQo+
IA0KPiBBbHRob3VnaCB0aGUgbGVnYWN5IGludGVycnVwdCBpcyBkaXNhYmxlZCBieSBzb21lIGJ1
dCBub3QgYWxsDQo+IHVmc2hjZF9oYmFfc3RvcCgpIGNhbGxlcnMsIEkgdGhpbmsgaXQgaXMgc2Fm
ZSB0byBuZXN0IGRpc2FibGVfaXJxKCkgY2FsbHMuIEZyb20NCj4ga2VybmVsL2lycS9tYW5hZ2Uu
YzoNCj4gDQo+IHZvaWQgX19kaXNhYmxlX2lycShzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2MpIHsNCj4g
ICAgICAgICBpZiAoIWRlc2MtPmRlcHRoKyspDQo+ICAgICAgICAgICAgICAgICBpcnFfZGlzYWJs
ZShkZXNjKTsNCj4gfQ0KVGhhbmtzLiBJIHRoaW5rIEknbGwgZXhjbHVkZSB0aGlzIG9uZSBmcm9t
IHRoaXMgc2VyaWVzLg0KSSB3YW50IGl0IHRvIGJlIGNsZWFyIHRoYXQgYWxsIGluc3RhbmNlcyBh
cmUgYWJvdXQgcmVtb3ZpbmcgcmVkdW5kYW50IGhvc3RfbG9jayBjYWxscyBiZWZvcmUgcmVnaXN0
ZXIgYWNjZXNzLg0KSGVyZSwgaXTigJlzIGEgYml0IGRpZmZlcmVudCBzaW5jZSBuZWVkIHRvIHZl
cmlmeSB0aGF0IHRoZSBVRlMgaW50ZXJydXB0IGhhbmRsZXIgaXMgbm90IGFjdGl2ZSBvbiBhbm90
aGVyIENQVS4NCkkgd2lsbCBmb2xsb3cgeW91ciBzdWdnZXN0aW9uIC0gYnV0IGluIGFub3RoZXIg
c2VyaWVzLg0KDQpUaGFua3MsDQpBdnJpDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0K
