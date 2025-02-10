Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D019025C6E2;
	Mon, 10 Feb 2025 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739217489; cv=fail; b=XdngjJm99Y5+vvSRy9k5vqf2DvkntiEl4+4BEXnDufzgOHtauBIgx5+ubLXx0qVTRkmBQZttDTZa5FpKQu2dViX9urpVrQWKAPrvVI6aW6AI725xuI0wNgLa8TT1rH/sQlQAR0ImWhTvqsz9k64Sl+wGSoO79vNFWE/3uclmbk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739217489; c=relaxed/simple;
	bh=BiYmhgPYg7GWvOIODtEAPe3samL5a7DjUTnkZWpKoPc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n2yDQLRWI6fHw2qjsnfe1UyXwszR9iL8frgZHFv1ffcRIemeVci1yMZpOkFGZrCJNHsSOrM8VlZDrOziOImvkBi1wSJkJDnUpv4GavPdk4ryVvgMNzgjt2Z0Cp6j/3DJRVY7D4QwWtp7bEiFfJNZa7udJ7rHapWNXAW4Y0YiBwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=qx5BOaae; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="qx5BOaae"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1739217487; x=1770753487;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BiYmhgPYg7GWvOIODtEAPe3samL5a7DjUTnkZWpKoPc=;
  b=qx5BOaae5iiBJFrf66lPzGajf6hiPJPRFkAh9FMFc4ObAlR38h2GyeHn
   qMb/r7gnsmn0a2O7p3K1D8hpSLMf7jxVbo2bfi/myb2Ti9fyPYEGZttLl
   2GP4USKGqPB1R27FZ0focA6dvUrywv2x0f6hYTsOl5ivHIdjgRXxfF9fL
   5bVY0QA8N0SxUyMYICNgjnX0yhbgLoHjBsJcUoMiWBxY1zx3p0gMfC6bl
   Qfm0uhfxAfwgG2Rqhmv5bD1V8QzrwlUjeslbVtZKkYqTNcCYvn7nloOHc
   SoqXy6o+2FgmUs2dXrE5vswZGlu68qZrpS9L4cZV6MciM0fB9Lbq91ZwV
   Q==;
X-CSE-ConnectionGUID: iSnwGGBfSnyyynesO5Kzhg==
X-CSE-MsgGUID: w2uFXJxQTga7rwbG1OTd4g==
X-IronPort-AV: E=Sophos;i="6.13,275,1732550400"; 
   d="scan'208";a="37863977"
Received: from mail-mw2nam10lp2043.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.43])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2025 03:58:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HDbHBs1abF1jvUMACiJWv1Pq/5rssVRTK7FnRO3cNEPKLlG+ttvFp0cguLkmzf5nZee4eMl2+rl/DV9XQWwSrQz+CwrKM7RUTQK+8c25YZ2a/fNU+nS4hoRhscViVVZBkP3WAzh2c1rdQdOT4x3dMl2jfqX2wSXNnH2VUU9RAeEheDolFskJ/6z1ESahq+MOsMUEyWWNgi26/0Cc109zI2s9Eo+gVkmuh2SZ17NCHY2pzBXqjYMg5Jg9WChveZ/JpqZMICNTc29hPvTJL3BIRivZjCFs3tSXVDfiYtBC2A+3YhrIOLxQ7rPE/XNqhTlhzwAP118dE+0AiMlw9qizWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BiYmhgPYg7GWvOIODtEAPe3samL5a7DjUTnkZWpKoPc=;
 b=TDLPBdS3jK4CYk5jIV/BfXc/CRRaGCfCKxJ7Pnz2Ejmw8GVNT+YIk6ViS5lEoX7bGo7xN0H1xCbu8CAZ3FS7t+Ed0l9t1PfFDXZaLPEcje7B6g742adms/0J0jwti4Ns+62mqfL3cW1tDlU/SalAbXJWhK2rD8xwXDuFmcTGdnKMonX+z4aIaCX9dW6v7qBf4Aey4N5UQfU9fw/E2eCqN0Te2jmSaMiEbJ8QrNIuAc4JZkZ6mcCtwGJrCBmgCRLvZQP6FZQc0J/E0rCmDblHMZcSl8t59j/LM0MxqkSCc19c+Uqz3CdKF8b2Y/5W8LY9ha0uQvKEZ2Oppt8Cp//Mow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by BLAPR16MB3794.namprd16.prod.outlook.com (2603:10b6:208:254::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Mon, 10 Feb
 2025 19:57:58 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::e087:8329:baea:5808%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 19:57:57 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: ufs: critical health condition
Thread-Topic: [PATCH v3] scsi: ufs: critical health condition
Thread-Index: AQHbe+nnmVPIaAX370GGVv9uGiAu8bNA83UA
Date: Mon, 10 Feb 2025 19:57:57 +0000
Message-ID:
 <PH7PR16MB61963D9EB09E61AED31B93B7E5F22@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250210135814.50783-1-avri.altman@wdc.com>
 <01d47263-50a1-4626-ad34-446996ac970e@acm.org>
In-Reply-To: <01d47263-50a1-4626-ad34-446996ac970e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|BLAPR16MB3794:EE_
x-ms-office365-filtering-correlation-id: 7dab469e-a04b-46d6-5fb7-08dd4a0d371b
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dkdqMEFGTU4vZnlaNUJvb3ZtRGNvMmpXUXZEQkRpcng5NTl6dS9paCtDcGNV?=
 =?utf-8?B?elFINlE1SDJxY3JWazBGZ1JWNGVhZ0ZLaVlwd1VMaGNlWWNMVTljdnNKZ25h?=
 =?utf-8?B?TVBXaDVNWjdVYWd2VG5JMFI0ZWxvTUVlWk1WOWNFaDM5TEFGSXZkRDhyS2lj?=
 =?utf-8?B?QkhTSTEwelJaVWhMbWpSVklnbXVJM3JPZlIwZ0ZuYVE3ZFZQMEJrQ0MxUnph?=
 =?utf-8?B?QVFFeUNoMGFCeVUvTVhneWpoWDRkMXY5N3ZQM25oNXl4UEtMTGJjMjdkRXhE?=
 =?utf-8?B?bGtGVDRVYW9UM2tjUThnd3FaKzJlbHNleWJCUmp2NnJVL29Ob1JxTkY2ME5s?=
 =?utf-8?B?c2N6WENUT2pxNUxURjF5Y2k5ZUdxekNoQnp4eDlpTnB0cFlySXZiM2pXVmpB?=
 =?utf-8?B?dlhYSEhzaWdTS0Vsd2V3OHZUZk1sQzZhZ3JIbGYxV2RkVTBiakpqcnBEZCtC?=
 =?utf-8?B?TzJ3VDVIL3BnL1pSWTNKSXBKamJXVVlVSjlqTVpxeEIyWWZJV2NVNENxOTRs?=
 =?utf-8?B?em9ZL0o5VGFHcDdrbWNtS3MrSkJHT1FhMU5mcnhoRCtyL25XbUdZWE5xNnJk?=
 =?utf-8?B?YW5oNjN2cVgrNEdSRXB0eVNXOHFBOUk4ZTN6WnN3a1NJbkwyVVFVdDdzK0R2?=
 =?utf-8?B?NkJNNm8wbnlKd1FNcXlNcnNYMWZRVTF0N0FIaVFhL0dDWmt1eWtKZTU2ZUpQ?=
 =?utf-8?B?emdMSWpKblMrWGRZenNKRmhvYk8xSkd6bWdGZjY3UEtLTzdDV1dFM0Y5TG90?=
 =?utf-8?B?c2twdEd6clhpUEJHL2xhcGlyL3JWL1c0K3poT01vQ09sMzdkV1dyZEhpUG0v?=
 =?utf-8?B?eTVCVzRpS1J5VkluVFA2alBMVERzUkR0K2t4M3RBV05ZUGczSFo1WmhwQmZN?=
 =?utf-8?B?MlV0ci9ZUm5QSGFlazVVcUdTTThPYjNWRjJTQnJLWWQrTDFIU0FjdkJVS0o1?=
 =?utf-8?B?NmdiNG4vSkhVWTFJMEQ2a0lwZ25pQ01sR0lQZU5DY1lmeDdvbTdCOFZ3Tm1I?=
 =?utf-8?B?akxyVzRMaHRHb2ljOTlWM1phZVM3YmRYQkJ1SnR3TlJtYkxLZmNGWGN0dDd6?=
 =?utf-8?B?THVMdytvYWpqKytqaEljQnIxbk9pUjIrTW85b1pOVTJRQTBVc054cUtXRDI3?=
 =?utf-8?B?Y3lWUFdpUEpkbEJRcXlPaXNtMXdWNjJPMlNmN1gzSnNQeU81M3JDY0o1K1pH?=
 =?utf-8?B?blZ5NkNFU2ZiMjNYWEthUGNJNXdnNzU1NjdESFZEZm1ucDByOWVDcFBnZEla?=
 =?utf-8?B?cTI3b1VYMms0WUhqY3h3YXEwUEpwdy9UK2NUdTFFc3ZIRUlSanQvblNXamRp?=
 =?utf-8?B?cUo3dlhSM2FHbGM3T3Rab3JtUjFTemJoNXZrS21DazZ5WE9GbUJQN1ZGUkww?=
 =?utf-8?B?NllSNXpKVE5OL0ZOMFE3SzlISHEyQzRwdDcvYkNsanFUUkJUNi9YVU9BbjVi?=
 =?utf-8?B?bWpQa0ttVG1HSWs0d3RKM2x6cGt2VkhYMTIydzZacWdVTjVOTElObU4zekox?=
 =?utf-8?B?bXdoeFArdHY3L1BnVkhZVk5rVER6RVlzMTNWbGZrMXl6Sk9FcDZjVmpsbys4?=
 =?utf-8?B?UG16YTF2Mzg1U0FZbUxwTkhVSGlUUVNzSVI1NEpPRmcyVUZoeENZMnB5azZY?=
 =?utf-8?B?WTZzMHlOajU2bk1TZ2hkeFBRSitSUUVmT2RsR2FJSmN6MHFWNGdhRmlCUGFa?=
 =?utf-8?B?ODE5bDhxMVdtTFpKeDloNVdNa2Y1RTNLcGtnSUtGWTBjc0NLYmV4cUZwaFhH?=
 =?utf-8?B?R3NvYnZHUnhBYXpyWEVORFR2Mm9WZ21JTHNtb1RobVVMU2c2QS9lQ1hwN3RJ?=
 =?utf-8?B?aHRyTzU4UjlHMXF6NnpkcGdhWkF0cFc5cFNwWUxXeGV2NWlwTzBZam1ZWTR5?=
 =?utf-8?B?L1hPM2Q3QTZISEVKSmwwb1ZKS0pIVWtRRFNQSDBRYlNnQTlkMnlkRUcyKzc3?=
 =?utf-8?Q?9mr+w6uN6kMIz1gYCDUw0Cn7PbDtZrud?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUdTUnBwaEJGRG9TdUg4UnAxRzZFQXNIdDhsYk0zT1REMU5YZGN4VWc0NTdk?=
 =?utf-8?B?MmYxRjY4ZXhDQmE4U2hsbERoQ2E3ajJTMHpOMy9wajF6clRJVEZoY3pydFhL?=
 =?utf-8?B?U1k4ckp2SXhsQXlFZG1PZ0ttc0V5bUF5bVN0ZTZ3NEhpdXJRZk1TQ01QVitE?=
 =?utf-8?B?bEFiTHNtYURGbHV0dGVzR2lYU1FJT202QTgxUjNzY3BTS1ZGYjl4TUZjRGdR?=
 =?utf-8?B?NVFWTTgwRk9waXBvS3RDZmQ3SUZEQXhHRWJndXRKeE9USTJGRks0TFZkb3dW?=
 =?utf-8?B?aTFNY2oydEVIVDhjSVZpbkVWcGIxZ3c4YlE0ek1PbGJqZm5kTWRXOVczdnM3?=
 =?utf-8?B?Q09BZXRhYllJbUlpVlNkdmpIblkwajNxUlZsb0htYXJOS0VTU25vQVRXSFd2?=
 =?utf-8?B?Wk53WVM0ekt0U0Y0NW9wb0RDQTJjY2swbnVPaGErTHRYd1ZWbS9QMkhka0h5?=
 =?utf-8?B?UCtXdVdYZzZXRG1NK1NhODZkdUZxb1kvQjRQWFAyQS8ydUZ1UVplNEZGdi9J?=
 =?utf-8?B?RUZ3OWd6c0FyZjFad2l1VVkxOVB1Yjk4L1ppRThRVlA5RWlvS01kT0JkYzg4?=
 =?utf-8?B?RERqZTNhM3psMmhacGdxb2hINnZiRkI2L0NYWWZwRmYvSEJ6aHQ4WjRwTDVy?=
 =?utf-8?B?czNUQU9qd0hyUWFaTnZPMXBCdjA4dGNLd3UvZVFobW5ERlZCVmttbW9HZjVM?=
 =?utf-8?B?VWFrZENheWVKRElNelZ4STFCZzM3RUtzaGRUQ0UrR0s2eUNKVVRMZUFuc3ZQ?=
 =?utf-8?B?bjNqQUhQS29ONDB3YkcwK3ZvUzg4djE0VWhoNFRHNDVEMklMNHNQRXVsVWZy?=
 =?utf-8?B?VjA2SGRBSDROakZxM0tySWpheHZCWmxRclpjU21NTkdvUGNIU3JRdVRJZnd6?=
 =?utf-8?B?WTAwOTlUWkNTcm5NaFZ6Qkp6ekdqa1dVTWJLVzF6NVZTZVBOZEM1L2twV3hE?=
 =?utf-8?B?NEp1UmI3OFJuVVp1MUJHN1ZLbjR5cjU5MEZONVJyd2gzSERBemc1amFtRHVw?=
 =?utf-8?B?OC9nZmZpb25hZVB3MUtSdUVaOVZKb2IvV2lEVkZKMk1PL2RjR1NoRTQ2L2Ju?=
 =?utf-8?B?V2dDSndISzdyUjdCQ2Z1QXBQNDd0WkMySWVJSUFYc1dWbFlLMHJTOFZuM0wv?=
 =?utf-8?B?S21MUXRjQ095dmUwWHF4aExtdXplRWtCRnQveTY4OEdlSFhuR3hkdTcvdzMr?=
 =?utf-8?B?bkFoSUpId0tDV1FpakRUYVdMMHVZZTdZcmJ3djh1akRjd3lyRzNRQVhhdE9X?=
 =?utf-8?B?bEc3T2htaDREYkZpTVcvdGYrTi82OUtENCtrZStRakV2ZmJEbXpCWG9HT0Fu?=
 =?utf-8?B?L1pSUUowdDZ1N25uRFRIb1VadWptNnVOZXYwcnFBWmtZakZabEY5b0RVdXZN?=
 =?utf-8?B?SEFVdEd4bXYxNjdJOVhmK2lEUlVNY0VXUTNoUnViSHFkOGorMEtFdjNndlQ5?=
 =?utf-8?B?NWQvU0R6U25xeWhTcjdyL0JUTTloSTBaQW1YYW5kcHhCb0toS05TNTdUMzFo?=
 =?utf-8?B?cGtsVGJyaFFmdFhBVktWQ3lFenBibENIVDU4L2lvZVVQR2pkaDhqeUVQQkZ5?=
 =?utf-8?B?S1RTdFRnb0xiSGs5bnNrM1hRU3grSXBaRmQrSnRNMWdVaHprUDBXRmFiMDRN?=
 =?utf-8?B?M1ZZNGdBcnRSQ0dxVW1HTWpRQm0yVlNFaFAyT3JTVnZhYm5SamFOSlZBTzUx?=
 =?utf-8?B?U1NqUGR3SWUxR01MYmdlaWRZK295TnZNdkY2UmY1b2kyQno5QWZYc2ZQM1Nn?=
 =?utf-8?B?MFNHb3lXUkM5WlNpQzJBajdGZWR6cnJEOGRqVmdOOUdWMS9vRkU5YVNhVm9Q?=
 =?utf-8?B?bXROeWM0YktUOFVxWndoVVJFRHhaa0ttNGdDcnVvSm9uQXRDQk9yVTd4QStW?=
 =?utf-8?B?UkdIcmx5YWIyempPamhSa1pTZDk2d3NjYUVmTGhsNi92d05vQjhqOWpTQ0tt?=
 =?utf-8?B?T0ZETzNRK2Z6M0QyTTBJcEpESjFWTlp1S2E4OFk2RFFPVkZCZzE0bTF3dysr?=
 =?utf-8?B?Nnc0aGIrN3FGQnkvRjh2SVI0Vy9wUWFWSk5YcHdqaEF5QVprRTg3NXlGYnBZ?=
 =?utf-8?B?MW5XNm5LK2RqZ3ZDb0hLc045ZVUwUlV2dkNTRGM2bUFoeW8waVpUM0xKUDQv?=
 =?utf-8?B?eDVhalRaWEc2ZmxHMTdCZTZURlpoMklLekV6RUNocWpHV09tdkdkZTFxUWhn?=
 =?utf-8?Q?txk/R4Q9mAatBmdBo5Ij03VUalZtYWoeJC+D+XI2Xrip?=
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
	FZ3k7M93bI6CnmtIVE+pRGhjAxXfM/2G9MWItzcOM2z6h1EFN0creZDmEhox+8x9kASlIFR8QfE3X9o/xl6G7f+SDatK3Q7PgRkUxjeO8OZg90ktUdsu5f6VxKlHfwsNlcxqS49w6PtDlOgv01dbswDrsuuSPTV63qIPysZoNsj9dazUIYiobCeBcGAP374n/ADtQK/JCepgiMtt2Wbg2oF11x1vWxtzXhOP4ywcYDLTFyJWHINOY7kfRb/2ySPSIiGGQTu72hY6LUif/1yLwIxcnJui1pL8cfRCUeAt4e71YKmkH/TnLMeTY8Q0DJaZSvPHkXmw8E8TkMtrX3zG0tL+B6tEEcwoCfQzD/x4QWAXM7sLvQRcj+gZ2LotSbUeFOVl6E3All0+sfh+vGkLCnyS7YYgXJFdKdPyACkCraFskPEPjuGbtnfvFL3DU8svCjKBIEerpQSBBmWwbgPYhisQOOh36QWFKl1//aWlf3ujojLygDLOLo3XdycF+POumtwn2rnO+w8MemSQTKoqrE4PPlQYDpFT5MOMbBSKrroWHc5B4SJUDHCAiZHtRFttHXg3LHF0glfdz3vrchIjVkDUcyBpH/dz6PEpL8hYCexx9lILM6QumAzeEap8RtsvIbVXTOk8ymc4ViL6zCDlgA==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dab469e-a04b-46d6-5fb7-08dd4a0d371b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2025 19:57:57.5465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SqfgMTqUt4s9rKpJldxcU4cttKKZqr5k4zv8m+FwfDLkeju4NgWKY051OqucWroS1BPSNbmeRE/YwjlfuT6xYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR16MB3794

IA0KPiBPbiAyLzEwLzI1IDU6NTggQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IFRvIGhhbmRs
ZSB0aGlzIG5ldyBgc3lzZnNgIGVudHJ5LCBlaXRoZXIgYHVkZXZgIHJ1bGVzIG9yIHNvbWUgb3Ro
ZXINCj4gPiBwb2xsaW5nIGNvZGUgY2FuIGJlIGNvbmZpZ3VyZWQgdG8gbW9uaXRvciBjaGFuZ2Vz
IGluIHRoZQ0KPiA+IGBjcml0aWNhbF9oZWFsdGhgIGF0dHJpYnV0ZS4NCj4gDQo+IEhtbSAuLi4g
SSdtIG5vdCBhd2FyZSBvZiBhbnkgc3VwcG9ydCBpbiB1ZGV2ZCB0byBwb2xsIG9uIHN5c2ZzIGF0
dHJpYnV0ZXM/IEkNCj4gdGhpbmsgdGhhdCBjYWxsaW5nIHNlbGVjdCgpLCBwb2xsKCkgb3IgZXBv
bGwoKSBpcyByZXF1aXJlZCB0byB3YWl0IGZvciBhIHN5c2ZzX25vdGlmeSgpDQo+IGNhbGwuDQpE
b25lLg0KSXTigJlzIGEgbGVmdG92ZXIgZnJvbSB0aGUgcHJldmlvdXMgY29tbWl0IGxvZy4NCkJ0
dyBJIHRlc3RlZCBpdCB3aXRoIGEgdWRldiBydWxlLCBhbmQgaXQgd29ya3MgZmluZSBhcyB3ZWxs
Lg0KDQo+IA0KPiA+ICtEZXNjcmlwdGlvbjoJUmVwb3J0IHRoZSBudW1iZXIgb2YgdGltZXMgYSBj
cml0aWNhbCBoZWFsdGggZXZlbnQgaGFzIGJlZW4NCj4gPiArCQlyZXBvcnRlZCBieSBhIFVGUyBk
ZXZpY2UuIGZ1cnRoZXIgaW5zaWdodCBpbnRvIHRoZSBzcGVjaWZpYw0KPiANCj4gZnVydGhlciAt
PiBGdXJ0aGVyPw0KRG9uZS4NCg0KPiANCj4gPiArc3RhdGljIHNzaXplX3QgY3JpdGljYWxfaGVh
bHRoX3Nob3coc3RydWN0IGRldmljZSAqZGV2LA0KPiA+ICsJCQkJICAgIHN0cnVjdCBkZXZpY2Vf
YXR0cmlidXRlICphdHRyLCBjaGFyICpidWYpIHsNCj4gPiArCXN0cnVjdCB1ZnNfaGJhICpoYmEg
PSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gc3lzZnNfZW1pdChi
dWYsICIlZFxuIiwgaGJhLT5jcml0aWNhbF9oZWFsdGgpOyB9DQo+IA0KPiBOb3cgdGhhdCB0aGUg
ZGF0YSB0eXBlIG9mIGhiYS0+Y3JpdGljYWxfaGVhbHRoIGhhcyBiZWVuIGNoYW5nZWQgZnJvbQ0K
PiBib29sZWFuIGludG8gaW50ZWdlciwgc2hvdWxkIGl0cyBuYW1lIHBlcmhhcHMgYmUgY2hhbmdl
ZCBpbnRvDQo+IGhiYS0+Y3JpdGljYWxfaGVhbHRoX2NvdW50Pw0KRG9uZS4NCg0KPiANCj4gPiBA
QCAtMTEzMCw2ICsxMTMxLDkgQEAgc3RydWN0IHVmc19oYmEgew0KPiA+ICAgCXN0cnVjdCBkZWxh
eWVkX3dvcmsgdWZzX3J0Y191cGRhdGVfd29yazsNCj4gPiAgIAlzdHJ1Y3QgcG1fcW9zX3JlcXVl
c3QgcG1fcW9zX3JlcTsNCj4gPiAgIAlib29sIHBtX3Fvc19lbmFibGVkOw0KPiA+ICsNCj4gPiAr
CS8qIEhFQUxUSF9DUklUSUNBTCBleGNlcHRpb24gcmVwb3J0ZWQgKi8NCj4gPiArCWludCBjcml0
aWNhbF9oZWFsdGg7DQo+ID4gICB9Ow0KPiANCj4gUGxlYXNlIGxlYXZlIG91dCB0aGUgaW5saW5l
IGNvbW1lbnQgc2luY2UgQGNyaXRpY2FsX2hlYWx0aCBhbHJlYWR5IGhhcyBhDQo+IGtlcm5lbC1k
b2MgY29tbWVudC4NCkRvbmUuDQoNClRoYW5rcywNCkF2cmkNCj4gDQo+IFRoYW5rcywNCj4gDQo+
IEJhcnQuDQo=
