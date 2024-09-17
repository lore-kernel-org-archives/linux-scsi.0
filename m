Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1145C613;
	Tue, 17 Sep 2024 07:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726557042; cv=fail; b=T2pgwoewFCVcnNuD1iy5dJVtlwcfFSt9yjGjhsuBsc0rM2SpLBEtswqKPDy9Ih5uxP66OzVT/mlbnGTnGRSmdztW3WWn9nvDGAks5VaE1PtIuyGrZTn/eC3RLj2lQQdwSNmQQLRxD3AUwxBz5vBKd19r/rq4e/EPjuMrb4bliGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726557042; c=relaxed/simple;
	bh=Lls0g1u+buzQPpUFZCL98dXRMaeWrxvuCLCk6nmC9xc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LacnSxZDtzma6ypFI72/4z4R8y5jSqNdONT/DmvaSvc8LlN1DBomhj/1Dw1fGks9lDMul0svSCs7BntIIOV8UnKLtGcXjrJWLbEoUkH6F8KBvcZtTFHLxcdxcxHl8yqN4zGTicJuCA75n/EtHMozmmJWTibNIP8EkHamWMVNKVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QFY2rXwN; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tvhwO+EZ; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QFY2rXwN";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tvhwO+EZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726557040; x=1758093040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lls0g1u+buzQPpUFZCL98dXRMaeWrxvuCLCk6nmC9xc=;
  b=QFY2rXwNPMo4BDLOfHqTvMppIRbLiFeK/CZ5rQ1MvmE8drfxtHU3ryM6
   Pvca2PGtdc1WS8gOUmHaS/wEaLAjNjQiE6vTIQP20f5Ygrt7UmVh8C/iF
   fECn/i/UY4Lo3QUO5B7tHF1ICcL43/rE7UrSp5UZ7vOhM2V1xLdhAhiUp
   wzrJOLUQiuKlQ7KFr+iiOvcgjL/K3X0Ujyfx91qpjcXB2uBMQ0TIcG/6b
   cGARmwJzZiWHVkXpZ7Z0ChHWW3ikNf8wdSnoPmgzHbg0aZEu85sr9tXwV
   1tHQQTEpdBEO2S/diVdxsJDf3bRn2dQwqfrx2PvQiyxY/HmUGnNHf10ik
   A==;
X-CSE-ConnectionGUID: EtfsQ7C1QYSC52XlwZBdcA==
X-CSE-MsgGUID: x3d5tUhBQ8m9U5LmktXyMA==
X-IronPort-AV: E=Sophos;i="6.10,234,1719849600"; 
   d="scan'208";a="27865134"
Received: from mail-westusazlp17010005.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([40.93.1.5])
  by ob1.hgst.iphmx.com with ESMTP; 17 Sep 2024 15:10:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkgkHnNwwpUrToj3dJZTF/kNsXZsFDl0mUTl4o/HjrOrRB9PRnygLXSftG75hn0ZlWCRHUZFrbBg7vqQo93ifIDyv+JB5VAe+yZHhrJvIgD6XiGQpNlTFm7w8+i/sc0gy0/EhpwC78soSEu0AFPa2rjIUam+3s6cx2yT08K8XwsbldCJGFAw5ONXOrqdSmtFW0YvUyCG9TFxo7JmEy8iMszjvlaU0Nx6ZDyhsq/xtdX738vI9XG9+Wz96/3OuAf+Z/5BizrxQc/veifQKk00T6L8el1kxlLxoVk0JiyM+cwAsF7/xzbG0XWRfTPKL38K88mPt9P5mOtwgUQ+U+kKTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lls0g1u+buzQPpUFZCL98dXRMaeWrxvuCLCk6nmC9xc=;
 b=aP0xDraPkSltl7jpCTS7ioo+QqxQYdcWwqd9K4VV+/oIU1zNYhBxADUdYHcw+pSX5kminFjRjauv7Er8tC+mYFTXnl95EwDEkhEU9Q6/TIcjHNQ+zkTs1p4wTd01XP89WFaubFurC9OVLqzQcHBWngo6Xig8ZdEFORftIGifTHCb9owR8QsRw5vFoWNPyQQDrp4mTydCC3FsVeXlVAH6s1Z+d16CEnRc4OZLDDmh+Bmm2dsaJySNS4KDzq4uRtVu7LgHVKiveaWzpR3wWBeCmNXT/t9Ov69XlFYL9A9aSKe4s1MG+ScF1B6hbDcTdcAWGE2dBSo1OgIVjME8O/TfBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lls0g1u+buzQPpUFZCL98dXRMaeWrxvuCLCk6nmC9xc=;
 b=tvhwO+EZWqxrfncNNGEQ2r1EKE4NJIwgdI8J70va8Edccmj/430UEDbZA74P+3koyi9142LXYgkioUQl0WaDB91dUE+MHiCQYHFV75Yck6Q3af33I8Qr09YuL1haSmfJWN4mjVLgYHX/+ZXO9KRzxAy3SBwek7R08C6HtlJIoVo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB6848.namprd04.prod.outlook.com (2603:10b6:208:1e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.23; Tue, 17 Sep
 2024 07:10:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7962.022; Tue, 17 Sep 2024
 07:10:27 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Avri Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>
Subject: RE: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Topic: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
Thread-Index: AQHbAzySHjbFr5s36kG7QyddcK5yL7JTLpoAgACMVUCAB9+NkA==
Date: Tue, 17 Sep 2024 07:10:27 +0000
Message-ID:
 <DM6PR04MB6575BE76713B8A4D53784583FC612@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
 <f47a00da-a072-491d-80a0-59b984ea92b0@acm.org>
 <DM6PR04MB65757788C5B69C27E9CCB936FC642@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To:
 <DM6PR04MB65757788C5B69C27E9CCB936FC642@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB6848:EE_
x-ms-office365-filtering-correlation-id: d29f97fe-a6bc-4669-5dc7-08dcd6e7cedb
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OEh6WG1aWWd3c2ZKUU5pK3hHcUxFQVFhOUkrTTFEcE1TcUtyVmJnNVZWeFhJ?=
 =?utf-8?B?dm1LUks0Y25PZGpGNmZteHNQUll4R1lSTEJ4NnJHV3pnNkNPMUo1eXBFSHRY?=
 =?utf-8?B?MWUzSTRsYU5uRzVEZFMxVlBRc2pxMVB2cXNMTmo3SHZhTGpWZld6bkxjVGFY?=
 =?utf-8?B?UWtaYlp3YVBzNWNXQ1JOWnZQZk9RUVNoZHMxWVFhOEwwclAzNkdXM3NROUcw?=
 =?utf-8?B?ZU0xbkNPVVlVejRSUXBCTlZNMC9mdWFUNVBtcHl6ak9jNDRjQ1k1MWRpNUNx?=
 =?utf-8?B?NUFJeGU1eEJCaGsrRU4ycWppNS9UMXp1ekI0dlBRTURMS0lmaHZjcjVsUW1j?=
 =?utf-8?B?aHNVK2VMQVZ1aG9CSjZqcTVrZVQ1dUVoME1SWUlsb3ZpMnhVcmJzZEUzSGJk?=
 =?utf-8?B?NjZXRTR3SUlxQlgzbFBIWXdwT2JleitiU1NFcGFNc2hvVjNxOGMwbE9rdlJ0?=
 =?utf-8?B?eHRtVjJ4eUJ1YjhrK05DUFdDcDE4R0lkYXZDeHBzK2xkdTNNT2VOc1NGdE1D?=
 =?utf-8?B?bUNnQlJKRG16T2lMQk9DZEJPTXE5aEpDbDY3K0V5VHg1Zkx6WFA3R1VRdTJl?=
 =?utf-8?B?UW51U1lzQVEyKzZiTWtwbWxBSDJjKzdGY0JnN2R4ZnlXZUR6THAwaTk4bDJI?=
 =?utf-8?B?T1JqMUhTck5tb0xiRURJTUlNYWxrQnRVcndGdFNXbmxGeFJ2KytNbmdsbWZP?=
 =?utf-8?B?SVFIeWU3QXRhdVNEQk1hVVpqV0JyYWFhbVZBbC8reHVPdkwzVnkvSDd0T0Zt?=
 =?utf-8?B?UWtuaW13aEl1NXBoUXVVOEloZjZRbnlEb2dZUlVIVjlZMlc4RnpkM1hOdWdW?=
 =?utf-8?B?NnVEaUgvNkI5UERzZFJpRVdTT1RzNTNaTXI0bDY0WEhnTUFUNTJDSXdQTTls?=
 =?utf-8?B?THA5U2VpMXpiZG5LUXNMY28wK3RKdFpCcU9nK0U5THpGZUNWaGVMWTkrQjMx?=
 =?utf-8?B?Tk9VbFNnSGpGQk9qdkIvdC9HZDZGL1htNDJkL3UrdjNCUEVZL0VwNHM4dm9k?=
 =?utf-8?B?cUt1K25kWXdOSjVjbkNHcnUwc1ZoblB0K2FHZ1M0Yy9EV21jQ0pqcks0U0o0?=
 =?utf-8?B?L0hVZ3dvSVFFbHNqY1I0Y3V5ejlwNlFtUEFhSWNBQStEV0Y3YmRnaVNaTUo5?=
 =?utf-8?B?SGszRGlwWE9SUjNYQ0Z6ejZNS3huRk1aUUF0SzE5eXBpRC9HeFJYME9aenha?=
 =?utf-8?B?b2FWS2hFWUtESlgxNDFBdVRpS0dETm1saFZyZlo0Y0RpUWQwbHVHUmp0eGdV?=
 =?utf-8?B?d1d6RG1WUGFQNktwUkNxcjdNTlE2OHNJRERRS2NDTVhDd3p0TG8xS05rZWxy?=
 =?utf-8?B?dThJU1lKR2pJVTdGcEFiMlBtcU4vZ2J3dkRSTU5NbWdmNDNwK1hSbTRNOVJo?=
 =?utf-8?B?bFRrNW5GQXVuUXJMWVFHbndENkpRWk1JMEcrRnFOeVRFYm10T1IwcHdqUG80?=
 =?utf-8?B?V0grNkJVRmdTVTNxMjIvOXgvRnl4ZkxIcS81WkZKRlNZWW9LQ3JQL3JpVmlJ?=
 =?utf-8?B?VGV4bEZKcUtaMmU0eU93ZXRQUXE3Z0dDWm00bmYxQzBYQVlUZUhvNHYyOEFa?=
 =?utf-8?B?cHpLbXRMWkhiS3Fqbk51UEpxUlppbDZRTWV3aVZCVlBNTXlTTzMwTFNjUC9P?=
 =?utf-8?B?bGoweU85M2xqZ213bWc0TzBGOWNacWFWTEFnZm5rUjZEWkQvZmxHVHFYZTNV?=
 =?utf-8?B?WFhZbzFuSnE4YnpBdzZ3RWxWemJyQXB4OS9LbGV2ajAyR01ZeDFXWXUrSEVv?=
 =?utf-8?B?OWFSMUtjUW85U0k3NDlFdHoxbUpwK1VmTkdCOGZQTGFvTFBvQnZkbnF0cUl3?=
 =?utf-8?B?SC9tMjh6dk0xY2ZmTE9OS2lRd3FNMlhNZGxKU1JOM1p4aUoyN0R2RWdoTUVi?=
 =?utf-8?B?MUE4VFdwT2pTOW5qS3FwKzF1OEYrallLV1hrQk5uazUvWkE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bkZSSkFhaTdLY3BUdE9CQmc5YU84d1NtM2FTTUt5NXhRWlRoMUc4R25ncTlU?=
 =?utf-8?B?OXRIdjFhaVI2OVk5OUVwTU1IeEZ6LzUxYXV6TU02QnRma0VnSXZMMU1sTXMz?=
 =?utf-8?B?eSswNWhSakExZStnYXpxL3NhZk1XZzNabHhIZitRd3VMYmk5NG1yMCtEM1Ny?=
 =?utf-8?B?b0FXTHhjeis5MmpYMmVCbEhoUmcyZ0wzdlNPM0dFbjdWRGYvMDdkZytUTzV1?=
 =?utf-8?B?S2xXV0ZBeittY0dqMjNTUGJCSWI3ZzIrZzRhTm44a1A3MEJCZ2oxZ1grWW10?=
 =?utf-8?B?eTgxKy9OVkgrZzlqQWFaQ2JaTVE2MnVndVcrNzMycHZnaHgxQ2huUHVnN2Vo?=
 =?utf-8?B?aGtndE50V3o3cElML29zOWVXYVkzQlh3cE1SY2cxWFJjeWpSNWw3NlJFSXNP?=
 =?utf-8?B?OWdBc1A5Wnl4UkFHV1lhNUk3WGJOZmxtL0dIUE83VHpSZjlxT0dkZXhZdmJq?=
 =?utf-8?B?UUlwU0J5TjdaVlpPT2ZkTG5OTFFYdE83cWc5SW55dnlFcTZieHBFbXFneFZU?=
 =?utf-8?B?d0JuY3JLd2RCYXByekhUWkVkbFpHQVJlKzh3dW1Ta0M1ZWRZaEVJcnl3MWlJ?=
 =?utf-8?B?RUU3MmhZMHJ0cVlyZDVFR0NEb24zK1k2ZGZZTzJKaVZaYnNzYWNWTVZnV01J?=
 =?utf-8?B?NU9lN3hvSjZXTnljTGFleDIwZUYvb21QWjlBQ3VGTk80cGZUR1N1UTdKYnZn?=
 =?utf-8?B?MGd4b3FacEwwUCsyK0VZVVkvdGZsM2RWbmZTZis2L2hsT1Z6Z2dZU2pCb09D?=
 =?utf-8?B?WjEwS2JVTzBMbjNyNzB5MnV3V3lENlQvWlRGOUlLMVpKQ1VLNnNOOWRHUGJS?=
 =?utf-8?B?REJWdzMwRmtmYXh4bzIyd0lid3F6M1E2ODE2aW1jODZGcUtEVEMzOXZiaEtp?=
 =?utf-8?B?VnhOQUNsMTJPNkhGZ0lIckU4dmdRYVVHMlFWOThJaEEwMFJNWkJ1QUtOVlhU?=
 =?utf-8?B?d2Q2dDgzU3VNTjVmL1EvKzY0bUQxR3pFbzRaVU9FWFBUM0xvbEp1U0pMRFQz?=
 =?utf-8?B?N0NBNFU5bmYyTDhRSUFCZzlkK29naHJlRGplZW1sOVZRSWkzTTBkeWNEVE9I?=
 =?utf-8?B?MVFoMm9HanZOc2xVK0pOTmk4NTBIcnh3SWYrSWk0eUJJTjJkcGtRSzBldkxX?=
 =?utf-8?B?UmF1Ym9sUktncXNyc2kzc2VubWlMYURWWXFveVRCSnltQldiMVZhc1lpdnc3?=
 =?utf-8?B?VkJKRVkwMHNCL1RFZzhBTzNMV1daTit6RjlqdnhEZmh4T3VmL0oyQ0JCTDZJ?=
 =?utf-8?B?NXVGaHNhbWw2eDRMOVdhREVuUW9QaGFhR1RxclhadXVjb1VxdnRERHRjbkFQ?=
 =?utf-8?B?L2JXZjRTVWU4WlluSERqUkxHWjBhUDVWT3NNaXVlSHFSVGRxWG8rblkxOTlu?=
 =?utf-8?B?cDRlMnozMVN1alRYM0dsK2dRUzYxZW14RFFPOVp6aGNQdmgyZ3A1Y3pJaHNn?=
 =?utf-8?B?SmIrVFE5K1JhVlZRZ3RnWklYT2tLOUI0RUZuRXFmczM2MU5BSHZKc1d4TkVz?=
 =?utf-8?B?alA4S3NEU3A4Yk9FOEhjcCtFZ0ZrVFFQdVVuUjNpZXVoZmh1dzg2eVhkbVM2?=
 =?utf-8?B?NW41NnVqUjRGeElyaU9KZXcrMzcrem1lQ1VDTUxlcEVpZ0xEUGVEd05KVURz?=
 =?utf-8?B?cUY0UU81by9LNG1ZbWt5dFB3Z09hdXRQTlJrTzZWWHpmL2grblpPTHV6RWsv?=
 =?utf-8?B?VG1xbUx2d2hIMWdHenNlRTlGWU4vRnVoMTUxcExvbE56ZUt6WFZtQVBid2tE?=
 =?utf-8?B?VnNzNkpseC9BekgvTDgvV283V0l4SW8zYUxwYkcwQ1R0M1VqbVhDQ0Nyblox?=
 =?utf-8?B?cE83RkhHQkEzNnBJOGMxS0VneG1UMUcyY1hzS3dYaGhiWlpoQS82RU1VdnR4?=
 =?utf-8?B?WUFPWnBxWlpaT0l0MjNScWJ0K2l5SXN5ZkdmT09OcE5sQjJLTEhuU09KMFpH?=
 =?utf-8?B?clhSR2UrUkZsMitHK1JiSVNuSDVyU3JKRjk4bUF4WkRoWThtNjZMTmt0Q2tG?=
 =?utf-8?B?V0ZiMXA3UlRpUjdWNTJQaDVSRFlFSEFLT1hiUzZPeDNSbkFJaHhRRytQaVE3?=
 =?utf-8?B?M2FjaTFBUHI5TW1pTlNCangwZ1EyRWtCMkJ3eE5vd3ZaZVpkSGh0eUlJMktr?=
 =?utf-8?Q?qIekIqXYycK9p35NvpvKnp63d?=
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
	fpY9nijPSifAszQG8ijiDr0S8GuVZ08w04DwFEADOq+rrYX+tivQrwb3rS79OS6LENUfih4Dxt9sCqIJzBFz2ozR7JT8U2eop6CgM6G1kw+tkNLC0sybvDyZQkH4DaX/R6pGRA9h/2PCj+FGxcaiZ7grKAacyKQ+jr5VYykcKM8Pq75tJEZ+TT+C9xM8h2nTpkUcgcBgfcvZ3CNqemkEvaAsjEXpYnxZj2FunUgZwpy54e/M2Hmtz6kVi0t4+qYM7scxsQHBjEduAagPRYInFqoZDKR7fXo+JG9ef4TCw+E6wPVTml4R9DpsC4djjfYc+bcyGVaq5z8IDPLFb8bxg+v2MYM/25muV173Ah7eh6i9Y9gZlj9UeWjJebS2hthnWPnBx8WDRB/kt9+oA7izJhWOG4g7bz6dBe603QfigzV4UzZXPeBEI119Ls47tXK6CcA1XrAfPG2+1BYev8hkIFfWR7fRuOQWbfXxd718x+44ckcSSqJ6s0mgibp+TXq3CFVvW4VhYnMLk85pJT445M+ASO9RUTAQuEvWI3ZDRjPJZAZ8AwReiyr8j7NdWTjbmMBJnIo6WdtC7wlvFNiqinC56s4O56Qam/FHLi9mRWgtErLSGfQF1NWeDT+AY5r1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29f97fe-a6bc-4669-5dc7-08dcd6e7cedb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2024 07:10:27.5531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jE2nWt2TNMt1mIRZxN00xSKGW6Aptal0bkjslwk8b0tJfZE0iNn+69WbKZW9xGKRarI0C3n4RnC7bUpfR/8GgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6848

K0FsaW0NCg0KPiA+IE9uIDkvOS8yNCA5OjQ1IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiA+
IFJlcGxhY2UgbWFudWFsIG9mZnNldCBjYWxjdWxhdGlvbnMgZm9yIHJlc3BvbnNlX3VwaXUgYW5k
IHByZF90YWJsZQ0KPiA+ID4gaW4NCj4gPiA+IHVmc2hjZF9pbml0X2xyYigpIHdpdGggcHJlLWNh
bGN1bGF0ZWQgb2Zmc2V0cyBhbHJlYWR5IHN0b3JlZCBpbiB0aGUNCj4gPiA+IHV0cF90cmFuc2Zl
cl9yZXFfZGVzYyBzdHJ1Y3R1cmUuIFRoZSBwcmUtY2FsY3VsYXRlZCBvZmZzZXRzIGFyZSBzZXQN
Cj4gPiA+IGRpZmZlcmVudGx5IGluIHVmc2hjZF9ob3N0X21lbW9yeV9jb25maWd1cmUoKSBiYXNl
ZCBvbiB0aGUNCj4gPiA+IFVGU0hDRF9RVUlSS19QUkRUX0JZVEVfR1JBTiBxdWlyaywgZW5zdXJp
bmcgY29ycmVjdCBhbGlnbm1lbnQgYW5kDQo+ID4gPiBhY2Nlc3MuDQo+ID4NCj4gPiBXaXRoIHdo
aWNoIGhvc3QgY29udHJvbGxlcnMgaGFzIHRoaXMgcGF0Y2ggYmVlbiB0ZXN0ZWQ/DQo+IFF1YWxj
b21tIFJCNSBwbGF0Zm9ybS4NCj4gSSBndWVzcyBJJ2xsIGJlIG5lZWRpbmcgaGVscCB3aXRoIHRl
c3RpbmcgaXQgb24gYW4gZXh5bm9zIHBsYXRmb3Jtcz8NCldvdWxkIGFwcHJlY2lhdGUgYW55IGhl
bHAgdGVzdGluZyBpdCBvbiBFeHlub3MuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtz
LA0KPiBBdnJpDQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+DQo+ID4gQmFydC4NCg0K
