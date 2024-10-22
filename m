Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D189B13B592;
	Tue, 22 Oct 2024 06:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576965; cv=fail; b=S7w0t1yeNhDlohwLp/vjQ24qDd28rqQyUIY+7y5i3CMMMXENxLoNgua+mQf/Rh5ST+ked7hvrFCk0h59tA9fjfLXm3wEoRwGXlWKsDqiVocYVkiv5vuUVL8oRAoAu4MrIVkmcDWm9N7oq5lHdF7nwumxPHLEBIg/W2SPtAQ7Bxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576965; c=relaxed/simple;
	bh=dZ1fy3zTp8BTf6zSbSjTeLxfBw3ohrkec+ZgDwATI6M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YA4vHofUurbWPD8px4RMyZnwhln8LroiKGyt3OCC40N0UiY1roPc1w5NrpDlnvuwhQbXkC/otzwQs3+uqoxOPjCLk3J3KzVfvyDZk6Ck+iH9PigAKpTfdKpLuIo/o4vpBKr1iL8bTuFIKINZfySTBLEGeBDczJoaZOqRzUVRNdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ndI9ph9W; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=o+7JSXRD; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ndI9ph9W";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="o+7JSXRD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729576964; x=1761112964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dZ1fy3zTp8BTf6zSbSjTeLxfBw3ohrkec+ZgDwATI6M=;
  b=ndI9ph9WEk6zvosFeaygnPm45gPAgRT+8TLHxna4qNG1BEWkjyfpMjWd
   3GqJsSzElLQxo1Rr2Rv1w6zKeyyRHJlq+AZIXuZwMJO3cuy1DbRDehVEQ
   Wpac1wDjNozXgecHxzQ9oW3yg4mDYmEIkyiB/udeDsrIqNoR5ArDMMNyK
   88H2RR3p3yXpW8h20QS7GI0o+FZtR4Tl6Qj4MBoBwqYLNEFJ8wuR2kZJy
   oVu1b9jaExOmobC8H5sjIz/GdNIfSqDbG64RS6z2DTka8SS5mgT0wG1jl
   29EX79vcTkjmPxYOOsjmoubrAqDyU0fNgEhvB1R2JT0Omkae9kNLt6w0u
   w==;
X-CSE-ConnectionGUID: vFaC1SiIRmCOGA1BUz6s3w==
X-CSE-MsgGUID: 449xJdduRe620A0eI840zg==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="28957460"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 14:02:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ClDrUTcIpK73CR5ycH6DVjBV3SHNU3Flug/Lg/u3nhy7eFS6iqIPLBLjkeFNoCldZoTkomi7WMhi07nhnGBI0kkFCyfZO2e3Is3+nRJOLU4d50XrM1uOYc30ba21bNPhLQrwv7yOs1bp4b6KGOHizyNxk+vsnQfslhwTvwJQk2/GEdSMObgQqeGTEgO0zM4Grvjv+xNfhyN/3XdgNSmVysGXFQhIONiBMbL0hcL7cFC33mtxpazZGoqWdOfQDi91rWOUC0Az864jDz/iio9qlSPvh4UyJCcBB2V7yW3pr9NGO6rDEgQyzUcPYDp7c4PPXIFx23Jm2mM4UbNARCAh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZ1fy3zTp8BTf6zSbSjTeLxfBw3ohrkec+ZgDwATI6M=;
 b=uUyRWfePPJrbQ0Ts6I2ZpBdEy7ESOLrLp3Yva7E9PMYErMvt0vmDyWk1ExE+JHS7osfNAIbwRSZ2jqV0babgiqtglqxI2+yZMJDyztjBGcurBd1+Zhpca8mjnrKSk36FtXm+k9PboLA3Fk56N0zsT6Jj8DaDZv8O46hrZ3SU9SgMcBXu5AD2YOEppM8oEm2hzFBQulnYhYUQ8JapkjjZeqIc0Rdw+LldrGZGp6RLeDSwQedBVqnykX51mwtcMEfAiZPles/d4cCdiDdFPyxeiloXwzlRbMQ7N2y6f1NvaS2Y8shz9MAsE/EQtRHUq2uzb8skiM0Y1W97HlT+3oDwyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZ1fy3zTp8BTf6zSbSjTeLxfBw3ohrkec+ZgDwATI6M=;
 b=o+7JSXRDZiGaUdpUCZ1QIT1rFnfGz3RnqoZoU2RPIxy5TnBp371jj9EQsnet3bKzqF5Dbz3xRGc2fhAQKrINwVvNxaSexgMjsgngQMdA14c9M2J9i0+71JUJkgEeoX8G5/lGTBDPVR7WltwqJFeHFfy5TF1catMuNyG7XJbHpEQ=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by CH2PR04MB7109.namprd04.prod.outlook.com (2603:10b6:610:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 06:02:41 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 06:02:41 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] scsi: ufs: core: Use reg_lock to protect UTMRLCLR
Thread-Topic: [PATCH 2/4] scsi: ufs: core: Use reg_lock to protect UTMRLCLR
Thread-Index: AQHbI7GQuaCtr474sE+TXDwKgr8S8LKRpzuAgAChT/A=
Date: Tue, 22 Oct 2024 06:02:41 +0000
Message-ID:
 <BL0PR04MB6564943551782240CAD17557FC4C2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-3-avri.altman@wdc.com>
 <a20841e9-4ec3-4965-8563-3b82673313c4@acm.org>
In-Reply-To: <a20841e9-4ec3-4965-8563-3b82673313c4@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|CH2PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: aafbb68d-1bf1-43c4-bafc-08dcf25f238f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VmxYQy9LT1dsMW9ka3Mzb09uNHRPbDNBZW1hKzRDNWkzUE1seENiRHMzeThh?=
 =?utf-8?B?N0lLK0E0eDNGN3lpS1oxSVdKbEdDTkxCQXg0SE1BZHhxR1EyYThkUnJ6VFE2?=
 =?utf-8?B?cmUzMmtVYjQwTVJVSFRIME45WjlydUVGRzQxcFh1ZERsMUxKbFhUTXRuN0Zn?=
 =?utf-8?B?dktUUFZwZkpRR0hSTWtUNWtvT2lqNEE1R2t4RU9SbmEreGpWelprejBYTUEr?=
 =?utf-8?B?a2ZETUdPczZQaWZudGZyUDRjQ0F5OHpUb0JzcHhPcGRuYjVLVjdmUTZLb3V6?=
 =?utf-8?B?QXNZMHh2b1dBb1hLSGdxeXBKdU0yRkhTcXZoOWhGM0lYQXNrbGpacHZsTmlH?=
 =?utf-8?B?SWZlMlpoZ2R1U3hKRTh5dm9vTEM1SkhrbStZZjdTbXMwblg4QzRPLzBPZ0R6?=
 =?utf-8?B?Uytxa0lqZHJBWXMyb3ZhUkdUaGh6RWN1UzRQT0hVZE5kd3JKQlpuR29xRTlT?=
 =?utf-8?B?Q2hlTDdZd3ZJWnZnOWF3Ukd6ejM2NUFMRk1KTEc2YnpSUGFIRXJSdTR6T0xS?=
 =?utf-8?B?bmlGamJuaDdTMmtBeE1tajA2Z3lDOS95bSt2TE9kMDRJM1Z2Z0s2VFJoMGxq?=
 =?utf-8?B?L2x5WjhkWFJwUnB5aEY0eWlicEZYdW9tT2l1R0MxTjBQUEs0U3F6ZlRmNm5Z?=
 =?utf-8?B?ZWJIeU1GeUdoWURQeDRDUEdBM1JQbG9SQ2VtNWdDUHlER3BybGZzVkhNK1pO?=
 =?utf-8?B?VXhRSzVnTy8yUTNBNXlxb2dYS3pzOXhJQjFFUzBCamtxeUNEK2NMa05kOVBS?=
 =?utf-8?B?MEprdEc4clBYYXpqQ1hMUVhWQVJHcEY4SER6Y2VYTXZRUnFkWHQ0OGd2bGs4?=
 =?utf-8?B?WVNHeEVFbUdFc3B1aVpIaGJ5UGFGYnhpRG5rUSs0cEJmb0M4QlhlVmhvWDBF?=
 =?utf-8?B?dkFONFU0REUxZmFRRjVoNFZFd0FpeExxMmhUUmJHYnMxUmhyR05wTEhqTkNF?=
 =?utf-8?B?WTRHVllKV0NrRk91UDIxdThZV1lodk4wQlFxeDNnMHc2MDRwdHpDMGt6ZkMv?=
 =?utf-8?B?bVI0cXRWT3piTW5UaHhyV2dwZzRLVDBBUW9Dam03aVJLRGRJZDBaVEMycFBh?=
 =?utf-8?B?Wkl0OFR5WDA3ZE9hWXFMZUkxUi93VVAwUHR2QjVGVGI3Uzc0dUNtN0hXUERT?=
 =?utf-8?B?RklGdkFBNDYvUUg3VmRNRSszc0x1Zy9nV3RWRVkvT3czRzUyNWVxd29NTUI1?=
 =?utf-8?B?bG1oZVZ5aHJnREtMcmMveEJJY2ZPZlJDUjZWQzVuNU1FM1V0QXhkTkNIZlh3?=
 =?utf-8?B?TForMExrdWZmS2owcXBkbHpQZTYzSFlscU1sWHNTeHREbUVicFEzTEErOU1Q?=
 =?utf-8?B?RHlmUGY0WVFyNnI3bElIb3ZxRjV5aWh0cFhYWnBNaERKY3p0ZDdoWW12VUtk?=
 =?utf-8?B?TldaVThTQ1pOR3gxbzA5K0RSZjREVXZYTnoxdkVhVnFQd01rdXptNzQ3L2hp?=
 =?utf-8?B?My9xaWhTVFdEekZaVENwZWhTNGFnZEVKS0tFUmpBK2ZheXNpVjdzZTJFeTJv?=
 =?utf-8?B?aEdzeVBiWkJ6NzZlZnRCSlpTNUZCc1Q5cVdTRTlUMkFZbUNOWGkyRU5QdVM5?=
 =?utf-8?B?NkJiV0ozQTRPR283MFpVWHBRUExpRFhkdkg0OFo3TXVmUk1aNHN2VGxwUFox?=
 =?utf-8?B?ejR5VnVEazEvSVp0TVkvRmt4bkNsU2lRSWUrL29HT2xHZUtEVnlqS0VXZWJQ?=
 =?utf-8?B?bTRzU1ZLTHdHcmNxeGh2c1QzeDdKYVkxTkRoRWQ1UE9vTTNiMnIrOHRsd29V?=
 =?utf-8?B?ZW1CSzU3WVdCLytiWHd3NkV5Q1FWbHdSOWdVaElVaFJmZDUzdnNoNm0vQXl0?=
 =?utf-8?Q?d3mJIfI1bkuqWJdYmKszY5LCYozDggM/0B/xs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OFY1ZHBlcDg0cWhHcFRJbXZMRFhObjdpMXF5MDRFZk92d2h1bndiUTZnblpG?=
 =?utf-8?B?RnI0cmR5RmZCZWxxZGtSWWVGWW5WMngwSGVjbWpESEROVVdibjU0QXM5cjlP?=
 =?utf-8?B?SEFGUndrRUJWcyt0blFKU0h3bVdFUXZUNWtOU25namJIT0EyOVMwUzVWb0pT?=
 =?utf-8?B?eW01ZmE2Mlg3WFhkbmNOaUltSHhhMi9kZW5Hc3hmeEU0T29Pa2d6Y0k3d3dG?=
 =?utf-8?B?NExZeGp0aTBrWXhRUExUKzg0TWEwZWVDR1JadVZBSWxlMmlldVNLQTk0ak9a?=
 =?utf-8?B?UDRISVVWWmZhKzA4MWRQenFpMHEyM2lTUU8rcUJtV25NbmRtRzBLMGZyZEdG?=
 =?utf-8?B?Zk9FNWRBbFNkMS91ak9tNmFsTUF0UzZjdjBObVJLbEtJK0Uyc1VhbE5JdmYy?=
 =?utf-8?B?aUN5SUFISWRJRmpLTG50anNWbzY1VU1UMDNQUCtQQ1Z2cmx5L0ZEVE50R01k?=
 =?utf-8?B?Mk5jRk9ISU9tMXRGTW1pVFhuU2pmTi9hVjNaK1hoMGwyR0psVnRuU01JbVNZ?=
 =?utf-8?B?SndJaG84aFVDN3NxQUZ5VEVKSFU2OHZqckVBN2xnUEpyWVBReGRuOWFKRlB2?=
 =?utf-8?B?ck40RXpmRXVTYmVneTcvdUhDSzB4dVY2elFFWVNKVzVqUEEvaDc3SEFDRlFH?=
 =?utf-8?B?RnVyQ080d1NDZGhJOW9OUUY1T0pWalRwVjRDRmVGWXFzODV3cnE0aVAvc0hS?=
 =?utf-8?B?MEw5TThEbDE1eGRFWXJmSDVrUGMxZGlXZUhEem96VmVYUVBGdzVFMnc1YVBW?=
 =?utf-8?B?dzJvTVFsOWNNeTdUWjZqcThCYnRkZ3VwQnd6Ym5UcHZwL3BWV25jR2Y4L2Q0?=
 =?utf-8?B?MUhqcDNOeUpuVnlidmt6YkE1M1hpTnRyZWRIL3kxNHhTRG1VSmQwMnFzNitq?=
 =?utf-8?B?c1Y2Q2twZDN5UE5rNTVrRVczT0tDa0FvVnJmVmJhN0RDc2xtQjl4TnUvdWp3?=
 =?utf-8?B?WXVwc0tVWVl1L2V3dThuQ1kvWHZRTFI0cCs2RGF3UEtWVnJxcFkyRGdkMmx4?=
 =?utf-8?B?ck5IWGxGaWFrQzRVMGk0ZDlSRWhaZWFwNXVSUjl3a1NsUlVveG5RcGtEQmFB?=
 =?utf-8?B?VHViUWszYTdFYlgxUHJGVlh6SmJYKzZIOU4rYUxSaDcwRm5tbVZtWTJiSFZ0?=
 =?utf-8?B?NmZZY0kwM3NUNFF3c0MzalFtSElmVTlpMmtBdWprdDdrYXdHM0NwMnB6Qmd1?=
 =?utf-8?B?b1J3T3AzdFNQbSs1em5nTzRrK3ROQ0hXWEVpN0prM3o4Qk4xNEJ4b001YWVZ?=
 =?utf-8?B?SUVmWkhaWXBpM1BTOXluNzQ4Q2dZOHM1UDVZRnBoRHk0REFJUHlzd3ZNNTF3?=
 =?utf-8?B?VWdmZWJzeVMzVXhyaWdqRktxSzFhNmdBVmJOWUp5bnFGM1haZmd1a28xNTVl?=
 =?utf-8?B?TlFtTnFxMFdOZSt4MFBFSTVOdUNYQjBzSWdXQUtYQVorQndJQUhVcTFqK1R0?=
 =?utf-8?B?YVhxZy9xRTh5UHg1ZmhhR3lmQjRHM2o1em5ZeXhpTlByYnE2cVdvMm5wbUJ1?=
 =?utf-8?B?V1N5T2lGNmw0YTNDb1BBOUV1bjE1cm5xOUczcFhHOUNWaFhkL09IbUthdE16?=
 =?utf-8?B?WHZvSERyUzFZTlJqejVPTVlVbGJGMUJWdVFpSzZQeFNETkdTdml6UjZGalpT?=
 =?utf-8?B?SzlBSmUrdVZvdldSK2JlZlpJYTJzTnRQUFRqdVNXN1k2MUUvY05VN2ZsYlM2?=
 =?utf-8?B?K0Z1RmdTN3VJMmlMZ0c3aU5WYm5FV0RpTHlEMFhiNGMvUFZSWUIwWjVnTWJS?=
 =?utf-8?B?QldRbUpUelhMU1VwZldYVTdVYUJKamVzQ20yRVJpcjJoU1JFN0R3bm9zWFBR?=
 =?utf-8?B?c1lGYUllSldWYTVwanNtRCt5S0ZuYklla3l6TWJSVGZQZjJ4QjhEVm1oTnJh?=
 =?utf-8?B?NjhQR1J1NWsxa3o3eURqNTZXZUUvaUZLK0VvVXA2eUNxRlNGVjgwNmdrZ01B?=
 =?utf-8?B?NTkwMHJkRjhPYjBQSENaM3lJaE1KSDFTMW80aXp2dWM1UUpOakw1SHdON0lZ?=
 =?utf-8?B?bWQxTGx6TkFiaisrTHlVdUd6RUFTaHZ4OFdnSytjV0g3TUxDeExJMllMSXA3?=
 =?utf-8?B?ais5d2ppOUNiV0l4V2NnZWs4NHhQQzlGR0lnY0RXcXg1NWpkc2VCZjM4L0c3?=
 =?utf-8?Q?Q8thxG5pppPCLfsl423editPj?=
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
	dOnKT5POgJblINir7ZxC12TKpv3GRKkf+6pgiJ2S/Up4v0biL5a6GqdnrQbFzdEjDWqi+DK1wCV4dhuJ3ggOMOIwsj141eV+b/A7zMmHTa+skgma89zIWVUb4nDBVYbNY14kgNfgZTfiJn9JADJ0bh1f0JM1uP98OnRxzargl72R6v+oK0zxrS6llHb36/hD0cmYx38dCs7eWOttlaPtnF8LX1V4TrerwiA4rgDb3mR3UfNCjvFPY9t0hPGunk4kFTgG62JcrH+sLXFNdKR1KsaLlvQDxCB6KWgdFc/km4P2lbC1yGdE32LqHAaTRzlrP7Nm85B6TJ0uhmyM7brBITP6sV8O5yY+ydRYlvrjhVJ4d59XonFaTG0ecHf2x1gx6IFu5AOpEUaS7mBAQgxSlSYet4M3yNu1aYAdHA7McFbWfvGgYMmg+B3uGU+3daxGwUKL+RCoB4KwiS8Yy9ldwL1qazQRZ5Hp14OQYd03O7Dpndv6Tr800vkdcdB+TgxJTo1OfKFsYHCtDH3hBxuIaf+uLT/v6ufJGvtN3yNW8Ip3o9w1u5RWGTExUS8HSVKZh+TuHFEgfvKE3CPYL+EG2r4o58KVFWVnm8Qi2ro6wJl7kEDAadn1SOmv8WHq6BtH
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aafbb68d-1bf1-43c4-bafc-08dcf25f238f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 06:02:41.1675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JL5ROdFRxGBxMVluwJM+YYrPLYkUxcrh9qQBRqAERkIrMBtI5rEzLWakD/x6e1ZGRz6Fcs7jMkSLj2jHwuPdFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7109

PiANCj4gT24gMTAvMjEvMjQgNTowMyBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gICAgICAg
aWYgKCF0ZXN0X2JpdCh0YWcsICZoYmEtPm91dHN0YW5kaW5nX3Rhc2tzKSkNCj4gPiAgICAgICAg
ICAgICAgIGdvdG8gb3V0Ow0KPiA+DQo+ID4gLSAgICAgc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5o
b3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiArICAgICBzcGluX2xvY2tfaXJxc2F2ZSgmaGJh
LT5yZWdfbG9jaywgZmxhZ3MpOw0KPiA+ICAgICAgIHVmc2hjZF91dG1ybF9jbGVhcihoYmEsIHRh
Zyk7DQo+ID4gLSAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9j
aywgZmxhZ3MpOw0KPiA+ICsgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhiYS0+cmVnX2xv
Y2ssIGZsYWdzKTsNCj4gPg0KPiA+ICAgICAgIC8qIHBvbGwgZm9yIG1heC4gMSBzZWMgdG8gY2xl
YXIgZG9vciBiZWxsIHJlZ2lzdGVyIGJ5IGgvdyAqLw0KPiA+ICAgICAgIGVyciA9IHVmc2hjZF93
YWl0X2Zvcl9yZWdpc3RlcihoYmEsDQo+IA0KPiBIaSBBdnJpLA0KPiANCj4gdWZzaGNkX3V0bXJs
X2NsZWFyKCkgcGVyZm9ybXMgYSBzaW5nbGUgd3JpdGUgc28gSSBhc3N1bWUgdGhhdCBjYWxscyBv
ZiB0aGF0DQo+IGZ1bmN0aW9uIGRvIG5vdCBoYXZlIHRvIGJlIHNlcmlhbGl6ZWQ/DQpEb25lLg0K
DQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
