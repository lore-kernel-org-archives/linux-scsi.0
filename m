Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59816193070;
	Wed,  7 Aug 2024 05:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009328; cv=fail; b=GQhvx69ywyDNxR1R8AVi2NsJAgrMWzdp9KoqoMckh2QF4B31q86g7LGpuzvba2ovUD5HXYY5+kBbm4HWA+oOvqixxZFjGCU7rpamoGpppsbJ6zx9YUeNXv2sTyDFd5LQIDxQYQTE5X8kAu9ej4jnUgRyyoQz6zwaEWhou5JG6Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009328; c=relaxed/simple;
	bh=pAUjMWvqjnvmEpFdLlHDD7OH5s2I8zo5Z6CFt3ZNenY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tRkjNsb7QseAp1WCg4KInVCNbH0aLdFs7j/XFXuiCHnmIUb45qrGFwdjSkzIA57ptfNjfS0kT57ffxHzxk1MfHFNHrSmDXUjPF2YMzRo+G2Mn+Bpg77Gz848MxljFQ999Q8fIMxKp6LczC1tF4TYE4RUXn/reXZ7HFOVA6e6IB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gDkP9H+l; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=vZ+1+W2F; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gDkP9H+l";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vZ+1+W2F"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723009327; x=1754545327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pAUjMWvqjnvmEpFdLlHDD7OH5s2I8zo5Z6CFt3ZNenY=;
  b=gDkP9H+lyTt586phyp3WW/Wcna0ih+0avbzEYj9SBCSlNTN3HKDU4aws
   DPmlwzNkQpIZbqaRf9cesf8IRXgTR3o7O5I0td++yuquF2Y0mMwvdU4bt
   wj2O1zZU12YwKV5b8CrujClWlR0PvaUA/MYyQxwbGsSxw91KxJXePaBlf
   NIzVHhxtXU5UcsObA9EoZydJTNiUrGyIocHB3iqCc9vtykf5FErt+kH35
   2gUJmyWu4KI4ckJnXt8AQJ1NDVs5MdJ+Npd2oGG1ZQBbQrtnGBbhFE2Ft
   sKXjmra++DqWSJpNe3JiZdWJ7cQhUZ+hVRCWrHPK/0ukl8RIVUeFc0QIC
   Q==;
X-CSE-ConnectionGUID: 1u7qYoBySTKmlQCrlD5+0g==
X-CSE-MsgGUID: HcWZL5VmT0qeyC9ku4aL7Q==
X-IronPort-AV: E=Sophos;i="6.09,269,1716220800"; 
   d="scan'208";a="23657352"
Received: from mail-northcentralusazlp17010007.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.7])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2024 13:41:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+r+tyxCqCH+7eXJOL9tUvuuegnIbTv7TD7HWANxF8G0z1b4fnmphj16JnrP+QOd+1drniFb4YGgOOzV3IcWZdw562Q+mjKD/MiZToiKgccDlz2QZFMyZE0sHIiD3h+LJn8DoeAmjUIlL8I6DAYrEp6zyTEbslzJwEZpIKDWs4evnlM4Ul/ACuLo/SlKnzepd0KhVl1f1H0BB5XUQUR4iNZjqIqv6yhqUi2Fi4FZN/m0+HEm5OHhr61LdmEtRDcQHahRtBQSDWf3lpnq89arL9NxPkuXYBdQClSUcOrefH6ZXanlLbCApKzzO6VnOJdelSi1qyF+IKcZ4dE+KhILAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAUjMWvqjnvmEpFdLlHDD7OH5s2I8zo5Z6CFt3ZNenY=;
 b=qXJFloxE9xW1Z+uUmrZJC6ssRhRiAtf4+CJStU7zdwC+gbuaSdZ3UzQ/mfJGs52+CiEwshhrLfDkE04V6zUTc6TZNR83N0acj+Z9Eu8idmwJOnB44+0sYRbWyUOqLGKEZvDsQwSduTZxFWW6zY26ikJweKtDVrbOseXb4M0DCnF0TkSgXm9rELrjN/NXnUGgij0OVP3beMjx0BxBKU+tzWwcEmwzDTIoFkLW4zLsp0qhfhnewvZ9HFbzP++Ynx89d2bp0PLgRJ66rNkmqcWWvJVXfjq1GT7ZE1G4hu0KS+v//DVe2Hoez/ooa/vPF1S6bw6hEf6jc2WNqBsdCZGN9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAUjMWvqjnvmEpFdLlHDD7OH5s2I8zo5Z6CFt3ZNenY=;
 b=vZ+1+W2F+PDDIjafnu94yZosVDeYNk0Hnzz9qeLnGshc66ylQix0AYDHktLvdyPNLXVi9t5wNr7vQc4muf0qsTZAlvqcRP4D5aCr5yKszA/qm5iz7nowDFJy9ZdMZR/igDybRwyM6K/Vimoehci9vjFiZ7hnESR7L5kdBnHDeEw=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by SJ2PR04MB8845.namprd04.prod.outlook.com (2603:10b6:a03:53c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Wed, 7 Aug
 2024 05:41:55 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%5]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 05:41:54 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Thread-Topic: [PATCH v2 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
Thread-Index: AQHa5j8YlR4zuIiz40GEv0I5DsYmk7Iay8kAgAB96yA=
Date: Wed, 7 Aug 2024 05:41:54 +0000
Message-ID:
 <BL0PR04MB6564C8FA4C6105DFBFDE0622FCB82@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20240804072109.2330880-1-avri.altman@wdc.com>
 <20240804072109.2330880-2-avri.altman@wdc.com>
 <8a8b93b8-45df-4aaa-95f3-fc2deadf65f1@acm.org>
In-Reply-To: <8a8b93b8-45df-4aaa-95f3-fc2deadf65f1@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|SJ2PR04MB8845:EE_
x-ms-office365-filtering-correlation-id: 6db18e7c-481b-43c7-e82c-08dcb6a3a53f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dWRGeDJwTWRPSVpnbWUxTklBVjgvMHdEb210NU1DM2VYczlUdlVlbGo3eU9r?=
 =?utf-8?B?TFI5M0s4Z2FJTzNPY2VZWklLQk4yRk1zVFpLS0FiL29FRFQ2MWltQXFhb2NP?=
 =?utf-8?B?ZE0zVFQvV2czQ05LS3NMc2Q5czVzMHZYSDlXRWlvK2ZtMWEvWHJYRXA5SCtz?=
 =?utf-8?B?bDlvNkZhWW5wNW1kTFZqRC9HRThGS0IwNDFXaWVrUEVwVHdwS1l6OHkvV01U?=
 =?utf-8?B?dms4NS9CY2dZc1M3WmgwbjVxWk1TbUVlUXduQ2ZFcXhuV0RxQ2xCVlozMFhZ?=
 =?utf-8?B?TnVuOFl3QUloZWVOcVpXOHJUQnlVL3hiU3dzRXUxRVRPYlFnWVFvR2paNkJC?=
 =?utf-8?B?WEQweE5hejVKbndXNnJhUjdVWXhWeGcwLzh5cmpRN3U4dDJqc0I2ZXZLZnRF?=
 =?utf-8?B?L3lwQkFOaVV2N2tpdllYakpnR1dXZFUrRHY3YXZhc3RmbjdnYWpLN3pLcS9m?=
 =?utf-8?B?L2dib1BBTmZ4cjc5VTZMTUVkU1MvTDJnbGpRT2M2N1k1NGU4ZG5RcUljcnM4?=
 =?utf-8?B?S2ltVEl6eVdGYTBKQUI2WDBCMU1BZzU4TXpRM2RMd2lNaUhnUldpYk9VRFJV?=
 =?utf-8?B?OUc3VENSbFUxWWwwUmpIUWFKTnl0U0h2OU9PUEdmM0ZpMVJGZUVpRml1ZlFX?=
 =?utf-8?B?UC9OUE04bGJuNkY5ZE1vTHJPTHlwU3ljb3BrUVo0M2NuRm9sL1diYzN0bHJQ?=
 =?utf-8?B?Q2dyN1ZydG0rNVppS1V2VUc4YlFjMW5JSTFUWGdQZjZ1Ui9XamptMnF4bFBK?=
 =?utf-8?B?ZHNIU3I2ZXhRSXZGeWg0US84MlpaTURlYit6ZzhZd0llZXRhL3lJZzJYMkRn?=
 =?utf-8?B?UUVjMTZ4UTJrMXVYU3Z2ZzJYTUFTam1yeXFiaVdidHUxck9wbnhYbG5PcFBJ?=
 =?utf-8?B?b3V5YUpYbUJSWjFGZys4MlpyOEc5N1BUaFMwWkZBbjJ5d1EzN2xIMlZ2eDVY?=
 =?utf-8?B?dURBYnphWHBsbzFwcWVLcVhaMUdUbW9rRm9kSFQrNjA2cnNUNHVEVlpIYTFY?=
 =?utf-8?B?WUpMeWIwSjBCWi9oZDE1N0NlUWFQMXlkak5QVVJRU0FPTklWeDlFNFB5b1dN?=
 =?utf-8?B?OGIyNVdiOVpsTkFnUFhOY3FDelNWY1BBeE9NVWNGWkZ4bTFLT2tiYiswR2wz?=
 =?utf-8?B?eU92Nmxvc2R1dUtyb3dBKzFxZ0xnL3FtM1h1WmUzdlV6cm1tN1pwU01EVllI?=
 =?utf-8?B?QncwbG5kUnZLUFloS3docDFUbW84WjJ5SVJHRkI1WW1RbncyT0tWaHZGaStP?=
 =?utf-8?B?aVJROGVBcm41S0U5NUlKRG5SRHZNYm85VjMydFBxQVNPTTJlS2pzM0VhWUla?=
 =?utf-8?B?OStDRzFBTzM3cDZieDRzQnRDRENVaG1GUDB4MVpabTdEMHZLY0p6Y3FwUWdR?=
 =?utf-8?B?UWNHaDBCRUVKVHVOdzYraFBScHZ0RkFLUnV4bU9iRUlFQnNsNnBYYkZBTE9w?=
 =?utf-8?B?RndwcFR1MWZxMHpCSVdzdEFxK25FdmpvUXkyeGc2ZEZyZEIzNkVvZndtbllv?=
 =?utf-8?B?MlJVbU4zQlVxS2dYWkx1TWUrNXF6MU9kd3lIOW9qR00zTzllc3lobzhJSU03?=
 =?utf-8?B?aDNCRURlbGpVb3JhZGNSbkpob2FhbVVscytIS1Q3WHV2Nkd0T3JpMytqTi9i?=
 =?utf-8?B?ZW1TWnJzNmEwVUpHVldiYXYxcVRWa2pRYkw2d0dNNGh0UVQ3V05Hd0lqakdn?=
 =?utf-8?B?b0ZEVm5ZMlJqOC9NVzFuSHpBY1NWWFgxT3ZSaW94dTR6cHlEangxaXVIN0xt?=
 =?utf-8?B?Z3gxTzNWcVpHUDdtUlRaK1ViTkJiMEZBRWNCVDMyWVBmbVhQYXpSVnJRM1ZI?=
 =?utf-8?B?dUR6WjYyWWdCdG5yM3l2bmRlcXhkWWdIamt5Y2hvNHljVTJyTytiYnNtbzd0?=
 =?utf-8?B?L0FZMzRmalo2M0VBcXdOTXpOVjhVVjhOTXVyYnpBQlZxdUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUs3YmFGaEpnNVAxajQrVzVwdkMwOWo4VlhOa01ZcGJiWmp1QjlaT2lvZFNv?=
 =?utf-8?B?OExsalR4ZEZ3bmw1aEgyRnBSQURGKzZkMm5YUXRTbVhwd01nR3k4Z08xRkNq?=
 =?utf-8?B?b0JaWSs5bTVJK2V0dmsySlQ1VGpadEVINnBNZ083VVVBRkxML3YyWEhtNGZW?=
 =?utf-8?B?WThHK1NVVVNEam5wTlh6dUkzUmlTMTN4MUMzMksrLzRHQjJoMW1zVERoSURS?=
 =?utf-8?B?QUc2MUIzRTNGREFHZElrcTJ0QmhNcG83Wk9qOTlkeDBScVA5TVd1SGw0bk9L?=
 =?utf-8?B?S29vaHphbjZBTnZKc2dHUXRlc203aTVDR3prNWFsY21LYjhmaytmRitBWkpk?=
 =?utf-8?B?Y2txVUt5Rlp1dGM3dGN2cXoxMlVJRnFwOE9kWFdHallwemZ4cHRkOXJCdXg4?=
 =?utf-8?B?NWRSUm94dlhyMGhFWTR6WEFIMWtsN3RQM2Qza1c4MXFLekZPdTRMTEszakFp?=
 =?utf-8?B?QzE3K1plT21kZVdjaG1sb09kMTBrOEhDQjR2LzZHbStITWpuMFJqcEFhWTgx?=
 =?utf-8?B?R1NpTGNLQWNDcW5lNzRXK1RweWVscmkzc2ZrbzhadGdzT3p5R1JDRGFFK2Yx?=
 =?utf-8?B?WDVjTkVFUlhvYzBvbUNjRXN4ZUxrRGV3ZUQzYWllZG1UaUpGbzFGb3p1NUEw?=
 =?utf-8?B?Y29hRjgvd01iRk1aOVBlbXVLUjNrQXJaNFZzQ1h4a05RY1c3V0pCR042V3VB?=
 =?utf-8?B?dG5iSHNCaThybE5YUE9pUUMxZDhub0NDZmhOTTB1anM4cUdpRTZLalJHaTVv?=
 =?utf-8?B?YnVVVmlSUmpyNVlheXlRM2VPOGVmOWhvTGhXQm9sSHNGK2RkMzJGajRTWE5W?=
 =?utf-8?B?a2x0RzRFWDI3eHM2MjlkQ2lCajU5Rmc4cEpSaFF4cGZORTZFWUpMU1pXdG93?=
 =?utf-8?B?SEFJQmNDSDQzOHJHeWpPeGpjVkVLRXc5VFA0OER0eTVQV1JjYmJJTEdGRExv?=
 =?utf-8?B?alcvclVDUDJCdnZMT1owYjVrY2RmWHVaVDRxY2xoL3pQZkJ4ODk4Uy8rQmdU?=
 =?utf-8?B?NG1TSVVMSFNRUWJHbHpiZ0V2UTFrQk9vV2cwOGRGMnRjN0pFTEwzMHNZSGM0?=
 =?utf-8?B?OSt2SEpoK0VDK3lmcDVQWDF6RDluM3p4QWhWWEU4ckVmekFZTXdGbjFES1Q5?=
 =?utf-8?B?QjZmOHloUDhhT0FaM1R2SlVWa21kZ2c1aU1rRkt4QzVQVTJhY3NlQ0NaQUR2?=
 =?utf-8?B?eU1PQnRjYjNGOXozVDRJR0ZMWjNrVmlOdVlnODNWVm54NjY4R3NMVGlXK1Y2?=
 =?utf-8?B?bWxEU0JWY0FnK3dGR05pWUI2N2QxNDQ1OEZ1UTR5YnFuSG9pSWgrV0tvdXNs?=
 =?utf-8?B?U2ZsN2lyczMxNlYrZk1tNFNRazZ3WkxRV1NUWkFEMWNFc3FGN3UxR1FMMitE?=
 =?utf-8?B?R1FnNmk0WTBiM3haTU1RVDFIY2tMOEtWYXFhZGpxUmVrK2c1YUQzb1ozQk1Q?=
 =?utf-8?B?clEydkxXaGNaK1Z1WEs0U3AycUNTQnBFQzZXUldUdElCRmtJWFhrVzJWVmV4?=
 =?utf-8?B?c2hJN2MzVURJZXd2TnFEQVY1cXNJakNPSjZmT0RpQ3dsS0VLZUF1VzYyMUFt?=
 =?utf-8?B?UWc1ZlNLR3lCd0NrcWJFMVl3OEhYMjFNOFgxbHcrTDB6Vi9xZEV0QnFtZVRo?=
 =?utf-8?B?UXpqQURlRGpoZ1lEUTJFUzV3aEVZeFM5QlpyTUhUWFpIUHdnUDZtdGUyR1RZ?=
 =?utf-8?B?eTVhbzY5eElaaCtWOUdXdGcvVjFBWjBZd0Q3UnZVdE9KVVV6d0hpazNlbWM3?=
 =?utf-8?B?ZkdIbWlGWTJueEN3THlwZENZSFJRTGN2TDlRWFh6NUw5VmNpSFV2Vk4vcnli?=
 =?utf-8?B?VW5yYlNNNjg0VnRUQkxnZmwwQlVTbFJxRmM4YU5kcXZEK2NMVG5rYXVmTWNp?=
 =?utf-8?B?dURmSERhS2hUV3lQUjVjNmc2WWxLd1NtQXUxN0VWODBOdnZUOVlHbFYxUmVl?=
 =?utf-8?B?S09vVmdjTlhlMm1HWlNEVHJRbnl4N0pJZGtwOXlicmtPbWxma3llZDZkY0Ju?=
 =?utf-8?B?Uzhzbm9QTHNXTnBBNnVDRURxY0Q4Vk54aEJpUGNQTlpzeTZaSXZMS2hnSGw1?=
 =?utf-8?B?eXVxMEhQUDZSWG5PNkt5QmJZU1ZIVVUwMTFPTTJFTHl3dVdma1NYdFJPRi9J?=
 =?utf-8?Q?r770G1xNse1cyVIfa66vbCYX7?=
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
	OmWYP2V8DU6NuEgfIa3iK2viu6cxd1wuRZzusiy/vBCrzrMhfxvL5XkTdlHaJBYoeit31koofkhlerWwstBuDH7q5n7r77++bYZi9S7L1OuMEcwzvUSphSi4Su9xSLovWxNq/SeaihK4o5E0OpId9jcfhmDRm/iOq/3/H3QA5idTL9W5eL6LRkrcEjH3PEbjuubsKLsAL1gO5tMy2rUBNentnh9D1uIXqsaxQuFPc+RieJM849CXx5Mn2sr2FE3z4M4J2FqVNuQ117JoMO9pRs3RiLulguCL+t8Lez59LNGCBSQH/YDfn75qbn9ELpuFKgXYJ6UonLfooEMhCpp8u9KuldQ+mV57VUDYKx3GNfa9z++GPuKjlQOGZLvtjbf2O2ZEcZB22NjmDBfXxksU+KO/5yCq4v3+1jzvL8ANVkmH/EtR8xp/7+v/fhJ4m+E/pm2/Iu1G6QlvETSRSjG+9vLWVxkUy4nAN5xwQNUzi9KgrlISt+gQSmbEw2w2TdaJp2SHTojR/2Q5Ct1OmUcd+VsgCsqAzXLt6pfHtLADDO4EJ7hyZScGzzJW4l10DW1UP8/ry2m4okXbfX6b//pBCnwiabk168e49Pr5RjyuYIWiVhyTTC5CoOsCcDLg3SaA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db18e7c-481b-43c7-e82c-08dcb6a3a53f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 05:41:54.7898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PNsUwtnuLjiaCf5W9T4+kn5yCvP+YR0ftVQD0I8MQcQ+6t0dD9ZT/RBSNgpmlgfytLNs7kmCA/YSmQk93k5kRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8845

PiBPbiA4LzQvMjQgMTI6MjEgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IC0gICAgIHVwKCZo
YmEtPmhvc3Rfc2VtKTsNCj4gPiAtICAgICByZXR1cm4gcmV0Ow0KPiA+ICsgICAgIHJldHVybiBz
eXNmc19lbWl0KGJ1ZiwgIiVkXG4iLCB1ZnNoY2RfYWhpdF90b191cyhhaGl0KSk7DQo+ID4gICB9
DQo+IA0KPiBBbGwgdWZzaGNkX3JlYWRfaGNpX3JlZygpIGNhbGxlcnMgY2FsbCBzeXNmc19lbWl0
KCkuIEhvdyBhYm91dCByZW5hbWluZw0KPiB1ZnNoY2RfcmVhZF9oY2lfcmVnKCkgaW50byB1ZnNo
Y2Rfc2hvd19oY2lfcmVnKCksIGFkZGluZyBhbiBhcmd1bWVudCB0aGF0DQo+IGluZGljYXRlcyBo
b3cgdGhlIHJlc3VsdCBzaG91bGQgYmUgZm9ybWF0dGVkIGFuZCBtb3ZpbmcgdGhlDQo+IHN5c2Zz
X2VtaXQoKSBjYWxsIGludG8gdWZzaGNkX3Nob3dfaGNpX3JlZygpPw0KWWVzLCBidXQgd2l0aCB0
aGUgY29zdCBvZjoNCiAtIGNvbXBsaWNhdGlvbiAtIFlvdSB3b3VsZCBuZWVkIHRvIGF0dGVuZCB0
aGUgZXh0cmEgcHJvY2Vzc2luZyBlLmcuIGlmIHVmczQuMCBvciBhcyBpbiBoaWJlcm44IGFoaXRf
dG9fdXMoKSwNCiAtIHJlYWRhYmlsaXR5IC0gcmVhZF9oY2lfcmVnIGRvZXMganVzdCB0aGF0IChy
ZWFkaW5nKSwgYW5kIG5vdGhpbmcgbW9yZQ0KIC0gYnJlYWtzIHRoZSBfc2hvdyBfc3RvcmUgY29u
dmVudGlvbiB0aGF0IG9uZSB3b3VsZCBleHBlY3QgZnJvbSBhIHN5c2ZzIGVudHJ5DQoNCldvdWxk
bid0IGtlZXAgaXQgc2ltcGxlIGJlIGJldHRlcj8NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gVGhh
bmtzLA0KPiANCj4gQmFydC4NCg==
