Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6322A1E0DB3;
	Tue, 29 Oct 2024 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730237613; cv=fail; b=WtpGG815jmLyPX4ObaEw7maVQZ6XMi6xYZKrEJvYXo7uEFxF94xMcwYGfmBjQECD/R4Mf/uogivKzWjc2c5O/kxTUYXY/Egl+j6aNpltqsAbqvtk4CSwFS99daK/Aeb3gbqFCWCOxBOL31sCgt4xwewA4kVjDPa+8ADfwaqe7jU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730237613; c=relaxed/simple;
	bh=6vGqfbioVlu8O1HaIsJKKjLn105IxL1GbTHJnc5/fXM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pxB2A7z9V7QPG54mdd+6EEv72VjhRvrp1PF0eD3aXeF2hfHAPdrqO968EOwo98A9fxYzbRluzq1RZ0eyiBe/xLiUgmj8xg8asbP/NbdlUXjbTqE5UJ2YNvZNraXGykDQe8OzMpIPniEovwaKM2EvXpJuiJoO1HTtiBJypRhPIj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=LvSMK5oS; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ldnnOk5t; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LvSMK5oS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ldnnOk5t"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730237611; x=1761773611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6vGqfbioVlu8O1HaIsJKKjLn105IxL1GbTHJnc5/fXM=;
  b=LvSMK5oS3R57nGqQGY6ACyJqH7+6nMNVNJ0HA4JB+3FrogXeNQmNKDfb
   3kiOvqm6v+6n3BA3554LeLPYrgaQdJW0Nunxpq1La80KSCihdXad3cTRE
   3OgSBnlGRCPoK1121WWkHaScyHSYqTYp4bGj4NsasYOtV6r172SXSJ4Ej
   JpKAFFKAZcPgsfZVZg25lWXm9U88Kp0C82xI82+bvfl9zPwV4o0VbtIRh
   56Mhdb2n3kTjiULRYjSKyNARNNy13ajcw3nS86FiRYa8DBl9FFNmQrB84
   RT2f+wSDwJl/GuJnWbHhTnJqWZ2lRRcEOMH9ZDyYzgZ3z1H+H0IeSpRW+
   w==;
X-CSE-ConnectionGUID: EIRbqNqERDud+CnH38RH/Q==
X-CSE-MsgGUID: wntU4tJ6TqCKpa+3BpeRVg==
X-IronPort-AV: E=Sophos;i="6.11,243,1725292800"; 
   d="scan'208";a="30663644"
Received: from mail-westusazlp17013075.outbound.protection.outlook.com (HELO SJ2PR03CU002.outbound.protection.outlook.com) ([40.93.1.75])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2024 05:33:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYlYrh+kTe3e2yeROMRzNtje7UTXuXFLoDsQKlKBZfFaN/Adb9wjoQQ1gCFBLcKzCQrHio0lxM5WUPXT7gBxC15XeYE3D5QtoDAQoZ2kJHhOR7ufZlLzlPXDRZI954C+Jx8uL0hgn+sRAuuxytYB9aNySByomSk0j4IZlgyoxJ76czp+hNX1p5DJsvAWCoyLoaGm3t2FlFs2IHNAS9u26EGaWzUKw5mt9SMIwamFMCeV7uU7pmp7tO6AvaYafB0+IVCprf9zmJFtFbQecIHvHd0uEvUpg7laeiK3xvk0DKohHJ5RX969kjBW8lO7jDeZS5zJcYyZbZcZyzvXFyZ5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vGqfbioVlu8O1HaIsJKKjLn105IxL1GbTHJnc5/fXM=;
 b=mbn9Ds0a3wcuf3YqcYZqzqrevC/7YDVNCpmZHHnqrat8V3wpgMJUlidSS0tiPh3J1NmWFYHzAR0x1a6yD07nevJE8hzkcltbqUWYJhy7UjgWI7Xt/YqVPkcNfmLow9AAjyEg0xC7GZJ3kkrHnDqhuNqEdhrKrHT/GuvfgJ1CsgF7zg+pF5kFdEd0PH3sGx5yyQ6wv1TThA2DFT9Bis2Ki7fD2XbGcE9IBBR2BfxGxWRF4KNIDesR2DzFOsCFEHSA5Q90wNAyk4c8LIhe22JFfrIpSyYQdsudpKjDjb4JcIVJf0oUEMzINyy1LjxLZhuoyjzrqIghzP0PaaXGNqIMkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vGqfbioVlu8O1HaIsJKKjLn105IxL1GbTHJnc5/fXM=;
 b=ldnnOk5tyK4Cog4vW+v/czw5EJkEqCRV9m2q7zcQfd32z14wfQ1uToQHa5j8u19pJhOb9r7eEk9WoZe5QaH4lLbqsjPOa31qbQvRcabTH61gDe1HYzBrgBdojkuQlS1/aiFgTJI9B8cKIB5h0ZsGFTibXLaeJb/5RS+yC+8B0Yw=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by SA2PR04MB7707.namprd04.prod.outlook.com (2603:10b6:806:143::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Tue, 29 Oct
 2024 21:33:24 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 21:33:24 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbKe3M/6h00Nm5DUau61FIkVY2VrKeCAMAgAAGuyCAAApCAIAAJ2QA
Date: Tue, 29 Oct 2024 21:33:24 +0000
Message-ID:
 <BL0PR04MB65640AD67700DA31A3E192D6FC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-2-avri.altman@wdc.com>
 <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
 <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
 <c48cfcbd-0f8b-42fe-b804-1a3da473a7fe@acm.org>
In-Reply-To: <c48cfcbd-0f8b-42fe-b804-1a3da473a7fe@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|SA2PR04MB7707:EE_
x-ms-office365-filtering-correlation-id: d0a39cab-d1f7-4d51-0e7c-08dcf8615164
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?V3Z3SFpYazhHeTRySXZjN2YvRzNlZVVWdUFxcm9pUmwweGRjc0t2WVNhTmR2?=
 =?utf-8?B?Zm5iUW9hVXA3RFRNeUNzWk5YR1Bva1hLY1dBRStMeGlWME1uYktGYnAwN1Vq?=
 =?utf-8?B?RUcvRWVtOTl5SVdQRHpBei9YbHlsQXRvSVNFYTl2aE03bElIRUsxQk1taFIy?=
 =?utf-8?B?L014b1JnU1BVcW1oTytEVWZWRUtKZUkwcmx2UWxXdzN4dXZDbEgxZllsMFpq?=
 =?utf-8?B?OSsyT29HdG1tbW9uMU5LdWIycUxiS3R4M21PVExIYVNRUVNZalVwU3NhSVNY?=
 =?utf-8?B?b3k0a0tXRnU5WC9CN2dEeVFEZlNRZkNMa3l4NE1NMXgralkwZTg0THJwRm9S?=
 =?utf-8?B?cWVkd3ZsRUxJekYwVklKUDdWYllTMy9vNEhTYWRCS25MRXAzbWdxOUtqcno4?=
 =?utf-8?B?Z0o5c0s3dnhDT2JJWW5mWEJQTXZMRUZ3My9BdWt4N2hYVzJYaDVVTHZDT0t5?=
 =?utf-8?B?TEN4bmdpbFE5ZXJPS015ZjI5Mkh3c2EyeE0zdFNGZ0I0MlloYzBsaGxVWjZp?=
 =?utf-8?B?eUJOYnlpQ3hRbVNXZUMxTEVHb1Y4ZjVlcWZkREpaV296VEQ0ZVAwcXRBSWJG?=
 =?utf-8?B?eCtudUN3bVlYREgrOWtDNTRicDJIemEwbEJET1pVc1hhN0xHZlVvc0dlSzlv?=
 =?utf-8?B?RHBzREx5YXg3LzRWNjhxQWtPZ0d1RGZoK2ZReFJIQ0dlSGErWWhtbHNkYjBV?=
 =?utf-8?B?Q1FBTXhjdy8rKzhzQlVtU1BZM2ZVb2VKMlF1b05iM2E4QmZON0oyMktTQU8r?=
 =?utf-8?B?UlNCV3d5SXo2U3JFdzNtZ29rYVFiV056NTdJQmZ4eUtOYmR4NzNxcHBvcFBG?=
 =?utf-8?B?STh3WnZ4aTUzTjdOM1daQTZvTmRIR2VWY3hUS3p5MHZMUE5KdjhoZDRPRlh0?=
 =?utf-8?B?WlJnaGpiZlNjM2pleS9STnRVbVJGYUZ3VS9qcWUwSlIvTEVQRStiWGZyM09o?=
 =?utf-8?B?ZEcwOS9Ycnptd3RsVU5ncGIyRHlpY2x4SklST3laWUg3M3plRjJ3Zi9Ga3hZ?=
 =?utf-8?B?Tk41b1VUVDN5QVF1SE9jazkxR3lQMWQxOHBCL2wraW5ycWlJejNvMlRmeS9a?=
 =?utf-8?B?Z3ptcWhHL21STllaeVhTaXBjc3F5TjlBVjljdXBKNzljVVRIbFR6U0lsSndT?=
 =?utf-8?B?YzQ0cmtSbnlEUm1FdDlNSHd2YzBBY0FjSXZ0VGdGSXdrQlhTb1A4eWdVaHBV?=
 =?utf-8?B?TXBmUUM3VDY0bGxzMDE4c2R4VThUdjhKUndsM2J0TEV5ZS92elNuVXQzQ0RK?=
 =?utf-8?B?ZUIzcFF2eG5xcjN6d1N6SkFoSDdCbzVFZzMyWlFlSVFucDM5dHdQSWtPRjFj?=
 =?utf-8?B?eSthYlViSDdER3R6VzlWQkRMVkhEakkrOE1QY3ViS3l2T3ZCMktlRCtuN0F3?=
 =?utf-8?B?ZmJLYjBwZU1WQzdzaDVHWEtZemZlZHpRRVBDZE1SMXpmOTZlWjlNVTVvOXZT?=
 =?utf-8?B?dks2dHhuZGloUDc1MEFYMG5JdzBWZzhiQ1orOW91ZmVjdWZUSzNOUnk4MXFD?=
 =?utf-8?B?QTZBRnZuSURJVXNTWmR1QVpZMGIvK0pXT2E2VDNTTG1JeEgxdDJxMDlxT2lk?=
 =?utf-8?B?Z2xFTVJYcVd2eXZTS0lXaDJDemtNRkVIaDdJUWFoc0JBaGJnYzlqK2hmdFFB?=
 =?utf-8?B?L2JhY2p3ZDllSktsMGZBNE5lUSt2cFRsMEdJUEVjempjd1NibU0ydXE0U1p0?=
 =?utf-8?B?NVp6b3RnMUhxTFlYS0RpTnlxSFVoTlRSR0VzY01JZkRjWHkycTA3ZlpSTzhZ?=
 =?utf-8?B?WVpCMEV1WW9RczRBZG56ODlVbWo5aDhKQWQrQVpkTUtzRC9hYXI1SUdwVSt1?=
 =?utf-8?Q?tpfVLjOKyNwzwDIaTbDuGEuDFty9tUpRcpUtE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aEtvTWxWaGtMY2g3enBYMFpUanZHK211RkkvSzVWZkh2VHd3ZkJVQkFZRGtP?=
 =?utf-8?B?VDZFZ0xkNVlTd0N4UnpBS3h3SUtzRXVHTmt4dTFFSStXdGhyMFliL0VGWFlt?=
 =?utf-8?B?blprQWpDeURyRVZaVHMvVmFHaW15TE1ENFA0L3lqNWRJMWdtaEZ4UkpwNmlE?=
 =?utf-8?B?Wks4MzhrVTVXZllPd1oyamYyMjlOUUhkYmN4bkJaUnM2N0k2RDJFVjUzTSth?=
 =?utf-8?B?YlVtam02Rmo4YXJrUlJTMGFHSC9IcEx2bU85QU14a3JqUTB5OUJoK1JQNHFM?=
 =?utf-8?B?Z2dJanc3KzJDdElMYlE1dzVjTWwwVFFkZVhWNWJnNWNtbWc2ZUxvcWg1dG9K?=
 =?utf-8?B?bXdRbE1VT1NTMkRIcHJ4czgrbE5UaWlvajNvM3JuU2c1Y1FlVDBCMnhpR2I5?=
 =?utf-8?B?U1d2QkRLRnExWEZCMmZKa0ZYL21NZGNSdG1IUC9IK0ppNE5yV1p2b3dFRlFO?=
 =?utf-8?B?SzB5S1dFajFhM2VMK05oMGMyYWFOcVE5YkZPVytTSnBEbFQ5V29vdmhpczY3?=
 =?utf-8?B?U3R0aFB6YmJnN3JJUjdTSnpKM1d4VkpBUFpYaGhTQjEvTnBRZVBRbTNnbksz?=
 =?utf-8?B?S1YwNnhsYVVsUTB0STB1UXVHRzcvWkV3aEJiNkNTZG12Q2pveGNrT2g1QUhr?=
 =?utf-8?B?MnltRHBmNkd2dmlpanBJSGxBYTRrWmc1K0tSQkVYTCsvcTBiTWtmVW91dzR4?=
 =?utf-8?B?cVpnOXpEUHhhYVV1a09OKzl6Q0xTQnhWOHBRWnhJYUJuanpOMWNzeFBYNVBo?=
 =?utf-8?B?VittRkhMTTlrTFlwRlk3dmt1QVNKWThGR04zZENaL2FxQk9XUWpORWZXSTFN?=
 =?utf-8?B?QmdCL2VaWTB5RldLV2pSTGZUbnFpbm10QTBSQ1Z0ZWxGaFlKZ29wTGdLOTJF?=
 =?utf-8?B?akp4NEZyRW01TXZwZWgyK0s5bDl0SkZBWFhGc2wwMDdvSkl3QU12RERpMFU2?=
 =?utf-8?B?eVArLzFzcFhORVpqcjFTaWVIZHNZeVVpd0hxbXpkVlFzTEg2SUVOMlM5ZmZp?=
 =?utf-8?B?SUJkVmxhSUpqVTQ5T0lmQ0RpRWZUT2VoUUtaQndXcEFmclRweFFQQ0ZiWnll?=
 =?utf-8?B?aHhtVFhsZTBTQkp4Z2kzVVZ4dThMY3BtVXJKazllNHFoV0pUVDZPdi9HM0Vx?=
 =?utf-8?B?WmFSZ3oxOVYzYkZ2YUNBamlGalJSa0p4UkZWNTY4Ym4vajFUSTQ4eVJRWTRE?=
 =?utf-8?B?K3ZpV21wK0hCUS9FMW94S28vOEtqai8xY3hUM2dJR2xvWnRPQ2ZXaTVjbm91?=
 =?utf-8?B?b2xkTlI1THBNdXZvZFREbG5jeXpIQTN2dWxTYjloQ2NqUzV0eGkzV1o4a2F0?=
 =?utf-8?B?K0JZaFhCMTBodnM4aEx5dHdqdlhrUFBuaHNrUDlBSUFxTHE1TGU5VE81K2VN?=
 =?utf-8?B?eGVTRGplbFEwOVNmYUZteElDcDhTdmh5bDBpcTNjOFJWYzAzTGZiNUVPcnBt?=
 =?utf-8?B?VzM5M0FLWXdXTjBzMk9JMldMSTNmNG1WbUhrNGdYYnFsK01GR1AweW1MQlpx?=
 =?utf-8?B?alh2MkU3SktJbGxXOE0zSUtacGhEVlFON3Y4Ui9XdzZiNU9BQ3VYTGhMdENC?=
 =?utf-8?B?RkczODFGcEFlVGlZNTVOWkxjQnN1a0kzRHZ2TGxYcmNWYVZCa2F3MzM4SU5H?=
 =?utf-8?B?TUgveGtkQXFibUM5Q2tndmpjdFZDbmpnYUNUWmIybkF2TkJLSTJkaDkrZVpn?=
 =?utf-8?B?M1Y2a2tuVHRnVEVVbUJqaU9HQ1dEUWZLRmtCYlJ2NmZHY3RvSkZYWVN4OVNa?=
 =?utf-8?B?cWE5WVY5YUptWXN4TVFiTHRrQ0IzNnV6THc5VU85bkFkdUMzUFk3Z1NMSGRK?=
 =?utf-8?B?NkVBVkRzVVQ3a0tBaWxSTHRyQkJ3N3hvSG00UnFibkVHVlF1OHhraGk4Tlpz?=
 =?utf-8?B?NDROc21wWEtpcTRCS3JmQ1NaQk1lSlRIdzdRZndLcFRZWlFxSEFseXZpL0lD?=
 =?utf-8?B?R3BTc0ZsTjVpazJVa1Z5TjJBMk9KRTRCYlZHQTVvS0pjWGswbWZTcVQyenVj?=
 =?utf-8?B?RXpWUGdzcUtBeENWaVVuREpWaitmWDJqTEppSVpvNVRsREhISkdCM1pGL1pl?=
 =?utf-8?B?MVlJVnk5MHptQWluZ0JpbmVnSGE4Rm9FNDl0RWpJTmhnN0twdzlCY3lCTXI2?=
 =?utf-8?B?cXcyVHRVMldyaU5Wcm9hQ1d1VS9mTmVhYlpMYS9LaHVRd0g0RFdkVEhBUGV1?=
 =?utf-8?Q?xScixoNe9urczTUrgJBiFHevzphgkbMQkmd65RKWRg0X?=
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
	tH3iI6qr3rlIn5lvzvL0NJWaLBdEXHPFuFV4P2Vo1hlLo0GW0+H0NYApwZ5jb0RVdMN+sD6xBf1uUkY7zutmQKHg1Allq0Zu9mz0dgelXtm8uTWufQcy0s7C+HWTuUeKwAz771DulHImClLKTiqvkP8rf9VEQgfS+LSFIaKSWMU2GRWIzY3csa1KC6ODVtclJJsgsP618i02Fwy1dDXSUPXWEu7MrhoNFFDpg0cXAfTwuuw+2hYwDo2zxRsClhIh5l6x4ksspESun0yl2KnPUdrngxrQ/kTt1+oRV7pZvDUPD2FFlgLZ6rOyk6kiyy7HWdlKVDXXLp9Zh9yYts7/8xCjIHMoHulyTsLkxQenyVmU+uk7fxu3Am4mxKvhmUuow/KK+zA+cUDBr18RJHJNEETZcdmQH1Byn8w0ZAr0XyoWbEjzGeT8pKMDcyVEvAn0AWV6zm636EvC6LRI2KujZk0vpazYKSpLKebD0AjjCkmvInQFIpApjl9dA2sEVikJSLxSRau7YponipQQ75F19HKm/uhj5AWbgo1FeMrdC/Vu1WzDFXGXvCoWSet2BDi7gv7ia5O88C4BIcnLg/gQvxnoxKb1QfybASNdeVKjj1SHxDx3fji0caKdYnE4269r
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a39cab-d1f7-4d51-0e7c-08dcf8615164
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 21:33:24.0490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zC3PkR2CwoO4sjvZwqOzUQnCOtIqcg+mv6Pi89o7/FfUAHPzlQpjc4Ygj6lyIMeQrR6DT7uaLBhHmysdQC7Q8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7707

DQo+IE9uIDEwLzI5LzI0IDExOjM5IEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gT24gMTAv
MjkvMjQgMzoyOSBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+IGFuZCBkbyBub3QgZXhjZWVk
IHRoZSA4MCBjb2x1bW4gbGltaXQuIGdpdCBjbGFuZy1mb3JtYXQgSEVBRF4gY2FuDQo+ID4+IGhl
bHAgd2l0aCByZXN0cmljdGluZyBjb2RlIHRvIHRoZSA4MCBjb2x1bW4gbGltaXQuDQo+ID4gSXNu
J3QgdGhlIDgwIGNoYXJhY3RlcnMgcmVzdHJpY3Rpb24gd2FzIGNoYW5nZWQgbG9uZyBhZ28gdG8g
MTAwIGNoYXJhY3RlcnM/DQo+ID4gSSBhbHdheXMgdXNlIHN0cmljdCBjaGVja3BhdGNoIGFuZCBk
b2Vzbid0IGdldCBhbnkgd2FybmluZyBhYm91dCB0aGlzLg0KPiANCj4gODAgY29sdW1ucyBpcyB0
aGUgbGltaXQgY3VycmVudGx5IHVzZWQgaW4gdGhlIFVGUyBkcml2ZXIgc28gSSB0aGluayB3ZSBz
aG91bGQgc3RpY2sNCj4gdG8gdGhpcyBsaW1pdCB0byBrZWVwIGZvcm1hdHRpbmcgb2YgdGhlIFVG
UyBkcml2ZXIgY29uc2lzdGVudC4gSGVyZSBhcmUgdHdvDQo+IGFkZGl0aW9uYWwgYXJndW1lbnRz
Og0KPiAqIEZyb20gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL2NvZGluZy1zdHlsZS5yc3Q6DQo+IA0K
PiAgICBUaGUgcHJlZmVycmVkIGxpbWl0IG9uIHRoZSBsZW5ndGggb2YgYSBzaW5nbGUgbGluZSBp
cyA4MCBjb2x1bW5zLg0KPiANCj4gKiBGcm9tIC5jbGFuZy1mb3JtYXQ6DQo+IA0KPiAgICBDb2x1
bW5MaW1pdDogODANCkRvbmUuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gDQo+IFRoYW5rcywN
Cj4gDQo+IEJhcnQuDQo=
