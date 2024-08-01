Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AB9647;
	Thu,  1 Aug 2024 07:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722495673; cv=fail; b=JnRdgpc6koi54pIGNRZ8mUDK06KAKw3k0aJAzaiiVQliH6xVtLBj9UlcsiFsFTzewtbx0NwqaBUtLAzOq85k3fOjqbcOkEoirdLkKXklSZXz2wqM4uOrk77093fVqves+Pk+LikSj8n4MfTHyjmlYaIEfDKTOGXHBSiUh5/FTfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722495673; c=relaxed/simple;
	bh=LBvv0bbAQl128tYFjmiP0SZgWXh6XbVHjGQjzJ0JaKQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mu5l4DQyaWjE4zJW8N6aAWm1G9uAn2pB5eQZVmbF8oA2W9x9BUy+of6QXH4zRKaeFPjFBhTpXdCEMVuKJUX3YrPt3RjLrUrOeoytRZy/g2DauioWckwOZQ7rI+6fsH9eCFELgJy4ZRVbqtn8NAlYxYFEQrS3Y2JLZUutL5cRHdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=q57rrTi4; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aRPWbZgl; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="q57rrTi4";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aRPWbZgl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722495671; x=1754031671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LBvv0bbAQl128tYFjmiP0SZgWXh6XbVHjGQjzJ0JaKQ=;
  b=q57rrTi4ggh2r6CgAytv8YBKhZFDA7tNQeTA1Rt0pH21DHYpsGZQl8Ga
   LgJ+fpYQSsvLN53jgqVKtE9htXkqlJzy+j2p/gnZmYqUebhb0ErUGZnlh
   J91SmL+Q2i8zvw69ZQS2WFYdYccb+G0t7B4VoeeQj2c0qzLWGyzZqQmOd
   A5tSygC0UT2CAevf7qlXjrsB6nXsjtGRbagUXtrX55aGbp7+uGS+aQTIL
   JYGTxt6bbgTOi0J74i631qjjYum8UKmPmDHlN14QpzDiA6bALwFjweOll
   MkV9fOj2FVSGdHyVfUAtzF9DUkVW2jxfiZx4SiaAmAbYofhhfYV+EUsX3
   g==;
X-CSE-ConnectionGUID: FZd3GHDTR7eaqZFzUI+m1Q==
X-CSE-MsgGUID: Y6RSqEgWT82+aehq0dNbcg==
X-IronPort-AV: E=Sophos;i="6.09,253,1716220800"; 
   d="scan'208";a="23907685"
Received: from mail-westcentralusazlp17010006.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.6])
  by ob1.hgst.iphmx.com with ESMTP; 01 Aug 2024 15:01:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YrC9VTKyEgV1nSirnYH7qmeXytOfEnK0dvQEe7y8DUr7tP70jdeDVymldI92Hx82ZA4cuuNbJwh8nheKiGtwFs4jzQyj/YZC/hmr7bbFFFXA722PpBlua534CGauL5BxruyT7ATVqF20iSPAviodQFvCK2U7zJfJtDrUDNL/zX5IYll2ud+uJWvjo/joX+KLJbdZxChhDeeRQh2t+CPLe3XrpDzJnBDZLwwIXUnVtORtWozGlAOMmSOzW3pgW4IgmyrHU8O8aqvtN7vwgj9EH5kYC8KQ4qVV9WhHIRAUPl06WMx1zxD1FgizMrlhBK12BRtovQ9U7Sd0DOqwgelB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBvv0bbAQl128tYFjmiP0SZgWXh6XbVHjGQjzJ0JaKQ=;
 b=bpFZc34rC8JDiu7WVsWGnsz/mK0aSgIXM+j3tTuTKrG00bg+SclKFFZDs9aIeQxiTz7PaLP4YZ4NrckVQDFp7GIndjXr6PhaBM/M6hwS2a3VZl+qB5Fus6/txwfj9tWxZVZpJbBRLmqBfw431Atl/mFp05D+OQDJyH+lMrJKn06xExc2GtGfpNvgi5CcFWfsdqrMMweU7Sa+eV0MehSGGuL0wSjSykbgtyKjAIAieStALks6E+aLT4KGQnYn84RalgWdKEqzoKwFxhM34qWBgqA44bHdkvh7+js4xYysuWyhTrIG18hrFYdh5DXYoMXYcGqPebV/7EQaPQ02KB4WQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBvv0bbAQl128tYFjmiP0SZgWXh6XbVHjGQjzJ0JaKQ=;
 b=aRPWbZglX6cs7rPxH5QAsYOARnfJB1j4khJBAGoJX6KXWXTI5vSZg8YbDR3Yb9/SmVAk/ZhzpYM+4Y7im4+cqpqZPyL61jbpqU0Xg2cARrpjGRNVx8LdTwM20UDssZho1pzJDitpcFjZZ6F9Nh5SS+bvCUDDSA5IdONZdUoxgr8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6444.namprd04.prod.outlook.com (2603:10b6:5:1e3::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.22; Thu, 1 Aug 2024 07:01:08 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%5]) with mapi id 15.20.7828.021; Thu, 1 Aug 2024
 07:01:07 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: Add HCI capabilities sysfs group
Thread-Topic: [PATCH 2/2] scsi: ufs: Add HCI capabilities sysfs group
Thread-Index: AQHa40RM0reS/9bYc0aQWhCSO4J75LIRVlkAgACji7A=
Date: Thu, 1 Aug 2024 07:01:07 +0000
Message-ID:
 <DM6PR04MB6575DFBBB1B020FDA23FAC78FCB22@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240731122051.2058406-1-avri.altman@wdc.com>
 <20240731122051.2058406-3-avri.altman@wdc.com>
 <0b3c0120-a680-455a-abfd-b3b6b0ddbed4@acm.org>
In-Reply-To: <0b3c0120-a680-455a-abfd-b3b6b0ddbed4@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|DM6PR04MB6444:EE_
x-ms-office365-filtering-correlation-id: 455c7536-9c3f-4d76-fa9c-08dcb1f7b7a3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c2xYelNTdUw4TlcwVTVTWTFJNFd6ZjE1TDd2bXhQQXdoT1JpUGdoZ254bmwv?=
 =?utf-8?B?dEhveFBrNVJQTytJSVJyTldHREdJbUd3UWVMLzlzcHBNM2FjSVRoSkF3VDhX?=
 =?utf-8?B?Y09uY254NjIxK28veEw0ekVaY0dORndNOUVTOHF1SEFWd2xBd0hyQ1pwZWlD?=
 =?utf-8?B?Rk13bWVMNXpqWVpNS3NoaFROQ0lobURYMHBEaWc2d0VKei94cXlZZXFxUkRV?=
 =?utf-8?B?cHRqRDNubDh2U3JZZ1ZoMVI1N0h0QkU4UTlMaW1MbksxRVBkZ1psbzRndjQy?=
 =?utf-8?B?akxEU2NFMGc0Y2NxYUNvWE9tN3RsS0hvc1Vrb1RaNTg5bGxkUDZKYTYzMlE0?=
 =?utf-8?B?Z0czczZrd1o1SjFSRnNtVWNPQ1ZYUzZjZTA3R2RUTHpKN0UyaVh4eVhwTDJN?=
 =?utf-8?B?ZW5nTXhQV1h2ZGFubTJYVE96T2tUSURGNXhSLzZnbU1FNHFMdGd0SUNXL2Fy?=
 =?utf-8?B?eG0xcDgzR2NobExLdDdnRmV3Z3hjVWh6Zm5CbHBiTThReEJ5bmpmM2tvM1lq?=
 =?utf-8?B?cUxPanllMnV0T2RJaUdtQVV0VG5RWHFHeUp3NUt6amhxeXJTY1VJQmNveEdj?=
 =?utf-8?B?T0c2ZnVneTJjVkpNYlRHMjR6YTlKV2RlTjBtcFgyYmpoTzBWVFBnZzdMdjZt?=
 =?utf-8?B?UkdwdWFjUVZYRXNPV3Urc1d4SzV5OFlMNEJMdUFWV3BXb3V0dzhQUC9XOENP?=
 =?utf-8?B?b0JrSEdCRGE4YTRsckJrbVByN3Zoa3JmcjByYjNCY00vaGUzRmpNVXVWQ2tF?=
 =?utf-8?B?YXRrdmk5dUtjV3hxcG1qZ3lXVW9jV2FrRUNlN3gwclZPR1hJTGI4VUlBM3BI?=
 =?utf-8?B?VnkwRldsUUxsZFNDZldoUnUrRnZYMDBjcmRMOFBkR3ViTzZ1ejhqS2VqZFB6?=
 =?utf-8?B?MStOTDhVNmw3ZEZWZndzVWIzQjhiaEdmamR6MVZLUDRoMS9nSXNYK2N2Y25W?=
 =?utf-8?B?cXg2SUt2am94M0JRaG1ydEFiNTNLbGdvc253RW95UERibHlsU1p0MkltRXVP?=
 =?utf-8?B?a2J4MXhtWDVKaHVNTmMrY0I2VWYydjNaTlRST2FxMTNHYVNCSVpwTlFpMmVG?=
 =?utf-8?B?dXY3M2FjcFY1WldMS3ZKRDNZUEJxR1BQcElJSmFRaXkzUXU1SnpJZGxNWkVJ?=
 =?utf-8?B?a3BwalQ5R0ZsbmhWTXJheHVDaUE4Ny91azNqNU5zNG0xby9zdklTbngxZHUz?=
 =?utf-8?B?MlJrU3ZBaDRoTURHZjFpZFVOUXZLR0U4YW9OL2pwYWIzcHYyY0N1YkZzd25h?=
 =?utf-8?B?d1VQRG8vS3dtRG1kM3NSMlZrZm1xNDFwOVNhTFJvMjhWZi9SQWY2aFdTMjNp?=
 =?utf-8?B?VjRad2lwWEdmUWhGNjBJandRclpFdEhUaXQrMXRyU2xiZlE5WndWa0VLcGd2?=
 =?utf-8?B?UEtybTRtcFFwUW9QR0EwTEVqY28ycU5rU1NLVjVqN3J1OTFSYUVWdlRqNWRx?=
 =?utf-8?B?Qi80dVJhbVhtcDNzTFFuYWtwcEdWb1FwclY1eXhQeS9LSjFMOWgvbEV4aHE2?=
 =?utf-8?B?L2RScEJOVEc1MS9zWXdHakRKSVI4OUhSd3JXRlE3cWNxelZyUkd2ZHJGbEZ3?=
 =?utf-8?B?ZkVZTTQ5TVV2RVJwenVNMDkvRjFVLzFMbCtLcWFxRWd2cXRTellNbE5mMDRi?=
 =?utf-8?B?SklSTE9DYzJld0hGT3MybmN6RTcvb3NuYmxBMWRYaFlhZ0h0endLSUVyYmVu?=
 =?utf-8?B?cG9zTkdTRVV4YXQ2L0ZNREQ3aHJTRmlFK0dSMTU2OS9zc2phRnpDSitOTmlY?=
 =?utf-8?B?TGRNOENvbnBvSkVvMUhQTGpRalZKdWRJNTBYSkV2bysrcnIvWjJFUktXZ0Z6?=
 =?utf-8?B?dG51aGIzdDI4ZWRTc0FxbnB2QnBZV0dFRXBLWk5HRmU3cHQ5ZUJUb1p5dWdC?=
 =?utf-8?B?VjRoWTAxM2dkOUJId0tFaUU0V3lDREQvMFR2b3ZxZnpRbGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZUdXb0p3eGRTcCtHTUZLdC9wZ0l2a1pQN29KbXFoTzRxd05tWnNmSksrRWZw?=
 =?utf-8?B?Ykh1YnZOTW5HYjhmK0ZRcHZad2d2UWlGbzdlZWp4RjlLaHhqTkNXVGdSNFRX?=
 =?utf-8?B?N0pGb1BHY3ZoN1dVUEpQcENnWWdqN2RRU1BxblBaTWw2TGF0ZnJhOTFVVWxp?=
 =?utf-8?B?ZmpxdGFOSVBuckVndUxWVnJ1eTl1bGo2TkhMazNQYmthc29WUG53c1ZDSDlI?=
 =?utf-8?B?MGs5ZEF5bjFtNFNaYWtWMFlvdllkeG0xVUwzeHgzUXRvWk5QUDZWa08wOUdj?=
 =?utf-8?B?eXIvbG96T3ZBWDJCNnJ2WEIxdWx3cEdZWFpoRTdYUHVEUjVFOWxWOGYwWno3?=
 =?utf-8?B?RjZBeVZTU2lpUkZUYWtXZFlJR1BNNGpkdUk2aHFRbWRKekZ2ZjZBWTNqdjcv?=
 =?utf-8?B?cE9SMkxacEQ5SjI1OEdyd0ZJdCsvWTR5c2JpditLSkl0ZHhzWU9NQ2pQUTcv?=
 =?utf-8?B?OFZrejh5WWFjdzFYVXRHUk9DdW5Nb0NrcHpIZWMxbVRLY0lYRU12WUVoK3JR?=
 =?utf-8?B?ZlcwY1JUSTYrSFp3WElCREpSUTRPNi8vdEdra3VMRDhlWW4zSkJINmhGK2Jj?=
 =?utf-8?B?ZHd2cXRTbTdORjRpS2JhN0RXTnJ5NlRIelVMMVNwcjRYeUNDeDFGVjQrM1JF?=
 =?utf-8?B?azNicEdWWFVLbkVtM1NYdmpCb203NzhNdjQ4aDdnUlV0T1REOXBzKzdnWkZv?=
 =?utf-8?B?NWhYeUhNWmtBSjd5RmJxQVF4bDM0Q1k2bzNrVEFCb2FYRy9Kd05DdVh6dFVR?=
 =?utf-8?B?cy9sWlBoK1BiMGZiK084K0pHZ1E1RUYyQVJVckJPMmZyeEU0YjJEWFZhNU5t?=
 =?utf-8?B?MUF5bjg4VXdqRDliV1FQZ0hRcWxMOSs4Mzh6TittK1oxUTZDVXhQNXpTWVp0?=
 =?utf-8?B?dkRyU1k5Z1ZMN1gwdnd6eHJiUEh3elNoUEpiMTh1NHpPM3dwOHdkVDVQZ25q?=
 =?utf-8?B?U3Q2YjM2aWtOYlFyM3A2eU5YZlppdkpEdGhLN201ODVkWlB0LzQ3b2Q5VVho?=
 =?utf-8?B?eWowOTd5TERnWHFuVU1tcEYzSFU0dm9pQURSMHplUXBDY2huZ2Z2YVVMaFkr?=
 =?utf-8?B?ZVJ2UFhUa29vSzNEeEFpVnBGcVpucGx3T3ZXcFdHL2dHY3gvUlZGQ0ZqZDJD?=
 =?utf-8?B?bG8rQm45b0twRUZOYms1UkdoUkJlRzZETTZxOUNESGFMb21hMGVrN3FQOTZS?=
 =?utf-8?B?VmV1SXdDaU9NMzRxRUpadnJ0SitETUlwYnpPQmF4bGxKZ1lUcldCNDRnTWtm?=
 =?utf-8?B?dFVQbUlxMlZaaXQ0TWpmRG5jeWFiVTJSMUwyZDNnRUk2NysrYjNkcFhSWitw?=
 =?utf-8?B?eUpHcHpJNklFM1hKb1I1RXhTaXJjcFYvUDNtQU9ML0d2TktxYnhsWjhOY0lp?=
 =?utf-8?B?akQ2eG11eXBuVWNqOFRhVXp1NDBXTTBSWlJTRDI1NWg0L2dDT0Q3bngrNExt?=
 =?utf-8?B?MUxQdUdnZVdEUGdKUXV6N29MWHhNYkRTRUtNTUMrOWF6MDkzeGlKa2wvWTdW?=
 =?utf-8?B?dVRKdmNyelFNMVp4UVZvV3JnUnRxRnlqZUN1cVp5VlVlVU5vYTNrV3J4WFpz?=
 =?utf-8?B?L0k1OXRiVURnTWZhdUgrbGZLd084VCticExwak05YjFFbXJkSHFlRHdSWWZy?=
 =?utf-8?B?c05CejBxeWlGMTc5YzhSRzZUUDlCQXZqV05qUW9UT1o5M3ZHQ0l1b0tLWXEv?=
 =?utf-8?B?bFJmaDBsR3IvNkNJUjg0RzBLejU0cURtTWZuUXBTVUpNWXRrK0J1QXVaQ2Zh?=
 =?utf-8?B?T2puMUE1MXJJQ2ttWVBjUHFTQ25BU3VNMzVoVHd1NmVtbi9DaVdIZmZrcHg2?=
 =?utf-8?B?cDFLYUJpY05mS1FqSTJ4d2V6ZWwydjhTd0NaRHhXcG4zS2VzdXRYTmxXQkYx?=
 =?utf-8?B?WTJuTW95czM2bWoxUU1jWnZpVStGR1BlR1NpT1BSZkczdnVCVmdtV2lSdmor?=
 =?utf-8?B?cWhIdXJJY3lQL3JndHdMUnBwWkQ1VTJIeiswcEJKdFd3OTY5U1hIaThtUGJ5?=
 =?utf-8?B?VVZtdkFweXNvMHo4aE41dmljYWFxRkNuclROdGJ1QktrVG5RUjV2SlI1TUNs?=
 =?utf-8?B?cUhkbDg0T0dubHFzNUJWWTdnaTQyK0hFOC9qQTRvS201OFNCSXRuS0lHSHhn?=
 =?utf-8?B?K2NWVUVoYlNWY293Q2xZODJkM0RJTUFwVmtnQ1laSmdPL3RURnVFenY0U25y?=
 =?utf-8?Q?XBLPs7enBhHQTgqu0p78oW5T/zeycLQ5wn7UHqw2V2Tm?=
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
	Z+VGgsfMZ5CGtvZqmzQQvqlK83mPTd4uZlTpRAlN8KUgu3lrlNHXIn2OpMxGupFHx1M9qBB+8NLrXN1P3jHTZKFWfpkqWE0ONxeJy8XeZq7BILrHLNqbhyrSByRtlaEyFJRDpWP/TCgeoL5jmRv48OYY6NzIM6nOOozlPNDi+nszQrctvUMYU6ofluU5UPb50sIURrq+Dn5CoD+uaqdjNxA2twgp7LE0bFbBAvxSUN+bBKNxkloT+06AXJGxaKc2PTeHXm1CyVeh1kC6SPQDLG/yeL8yBWzXZdL3pJ292/1at2wm8kbB1m3L7OJkMvcZSQomZ5vyiZUkNwKomtPOsOlzXBRdnU0nUQCJuJ268CB0s+sFWRK28DeSxa14vMt8DNIKojXNRg6EAUDJb5HamRown1Z+iRI41xRpaBSIAnW1s2kA7U11VkbizbQvVzaH/YLUbslHtHC+EMCvyRvUgS5heo6eW2+DUK0L+30KhiQj3aPT3QS6zajR4eSm5MSj9AqTwWUjams0lM171xWk5v7ib6FKHR+zruRsgMq5tM67Jhi7NiNhfxOiC47etlhKAw/c5t3mo8vWEgwvfl5ri7Bh7XUKTce/5GNTTMG5evsrC4SyOk47ciDyFZ5MJM4B
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 455c7536-9c3f-4d76-fa9c-08dcb1f7b7a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2024 07:01:07.5572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PAffLw6CCpPaAry8NBPCH8hZYW3FgWjDjiKDw5KuH6gUFN+zMcPe/9xd4HHBhONQCfDdJgHKFw6UXaupaLzGrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6444

PiBPbiA3LzMxLzI0IDU6MjAgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+ICtzdGF0aWMgc3Np
emVfdCBjYXBhYmlsaXRpZXNfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gKyAgICAgICAg
ICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKSB7DQo+ID4gKyAg
ICAgc3RydWN0IHVmc19oYmEgKmhiYSA9IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KPiA+ICsNCj4g
PiArICAgICByZXR1cm4gc3lzZnNfZW1pdChidWYsICIweCV4XG4iLCBoYmEtPmNhcGFiaWxpdGll
cyk7IH0NCj4gDQo+IEZvciBldmVyeSBuZXcgc3lzZnMgZW50cnkgdGhhdCBpcyBhZGRlZCwgZG9j
dW1lbnRhdGlvbiBtdXN0IGJlIGFkZGVkIGluDQo+IERvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcv
c3lzZnMtZHJpdmVyLXVmcy4NCkRvbmUuDQoNCj4gDQo+ID4gK3N0YXRpYyBzc2l6ZV90IGV4dF9j
YXBhYmlsaXRpZXNfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gKyAgICAgICAgICAgICBz
dHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKSB7DQo+ID4gKyAgICAgaW50
IHJldDsNCj4gPiArICAgICB1MzIgdmFsOw0KPiA+ICsgICAgIHN0cnVjdCB1ZnNfaGJhICpoYmEg
PSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPiArDQo+ID4gKyAgICAgaWYgKGhiYS0+dWZzX3Zl
cnNpb24gPCB1ZnNoY2lfdmVyc2lvbig0LCAwKSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAt
RU9QTk9UU1VQUDsNCj4gPiArDQo+ID4gKyAgICAgcmV0ID0gdWZzaGNkX3JlYWRfaGNpX3JlZyho
YmEsICZ2YWwsDQo+IFJFR19FWFRfQ09OVFJPTExFUl9DQVBBQklMSVRJRVMpOw0KPiA+ICsgICAg
IGlmIChyZXQpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArICAg
ICByZXR1cm4gc3lzZnNfZW1pdChidWYsICIweCV4XG4iLCB2YWwpOyB9DQo+IA0KPiBIb3N0IGNv
bnRyb2xsZXIgcmVnaXN0ZXIgcmVhZHMgbXVzdCBiZSBwcm90ZWN0ZWQgYnkNCj4gdWZzaGNkX3Jw
bV9nZXRfc3luYyhoYmEpIC8gdWZzaGNkX3JwbV9wdXRfc3luYyhoYmEpLg0KRG9uZS4NCkkgZ3Vl
c3MgdGhhdCB0aG9zZSBuZWVkIHRvIGJlIGFkZGVkIHRvIGF1dG9faGliZXJuOF9zaG93IGFzIHdl
bGwuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
