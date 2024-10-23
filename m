Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A905814659D;
	Wed, 23 Oct 2024 06:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729666080; cv=fail; b=DNHWNsE1QOxJ9uRSosGHVFcrCBe+F+wqitTa/r5HMg2X/7k/+DHwseGo9D99dNpRqt+atk8xFK1N4CXTAm9bsS8A07Mzlj2vpNQ9qruEJvPK2Ci8wr792pc8QDX5sMFnyWk1PEgmfBBTghU3DyrxwQFJS3uFkFOWX85CLdmG6o0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729666080; c=relaxed/simple;
	bh=DmjLy7WXqWACyOgyaFIA3H4AGZkK/OAJldNBTpslk4U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ehw5H2ZsBoc1B2AcC23LD6hI6onw0j9JVolvGqrGaaTx4y5XFhJHYLAKp3x4KiaLYTUbCXTaA4ShvmHPYYE1PorwgO9WilKEqelvQRGcqtfJiy9EnzLApFcwW/ZpiPe5/tQTDUWuyifHeSxWvCANK3rAge6ICrTJIkBPySnxdfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dGnA2vKt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=kahGVtwl; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dGnA2vKt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kahGVtwl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729666078; x=1761202078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DmjLy7WXqWACyOgyaFIA3H4AGZkK/OAJldNBTpslk4U=;
  b=dGnA2vKtavGJM+ObZU/J5SxpQx7FvKcWZ5MY5d1Jpq1XpJpDd5+E+bRB
   3D93sOmaouxz+uMDezH6EnrzDfDJtDwmMh0j8lu6473e4lHbwE8lvJvBC
   eMOpogVZLoUSNaB112sSYcQ3xh73BYFCks+aqAy+tnS8ONiiQ56eCPj08
   U1G3GVqNQMVCyhM0rYz87wsvY18DpDsL+BWQ41wqyoOlnGyXJYkPb3ODK
   dtsKvZ50vN+l8HB5zh2jQYFI9ewKPE5d/RMe1FnoXr1ENPaCaPF1v1rxs
   sIvu61avXNnsk6+9Fz9UT0xF6wyM7toBiRIWpgucOIBeBIiN5QrZWIOId
   g==;
X-CSE-ConnectionGUID: t272PovmR7yMo9rJryrgQA==
X-CSE-MsgGUID: o9nvSzm3QKet7MlcXgQ8dg==
X-IronPort-AV: E=Sophos;i="6.11,225,1725292800"; 
   d="scan'208";a="30628605"
Received: from mail-westcentralusazlp17012038.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.6.38])
  by ob1.hgst.iphmx.com with ESMTP; 23 Oct 2024 14:47:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQTptOT0sRvQEpnROUlYKqVhda/DK1w+Dids75wLvg8yHlFTqBdiZlWXiU1k9P287HtjSYlyyF4xlvFyptnPgRM/q0YjfsJZ18hBVlQ8NIPHVS/vhd5UJ824tsFkx49gl41aomMmgNcSmsvooJ+KRuzmry8Rotwg1JuEEj47M3V1tlbKiR7+fR7RTMXROfZZxKsC4U5ycnLL8ol+eCht+rKdytDt4eb3Gt/2ZUuKGSb/7eRBMHE16SQO0x02mGtAruPcZYCHacdYF3YLls7AguOHiyYkUh7lF11p/ZJ3TN/4dLvl9uEc9ZnxBI+w3mLskhsIdxuzF42AiL82dvT2vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmjLy7WXqWACyOgyaFIA3H4AGZkK/OAJldNBTpslk4U=;
 b=PgYJtKWDvi295v9aPY2hgtxh4mVQrQ1agegbiqPeGGbi49Z64PODYezx2GOyugvc1P2dqzIX3Gp5JWpM2iELxp3OOt3piKs3Ne5stE97Of8q6x/gEET8iX1mO2Udb/dEblNe5p8LsXkPF9D+UL3PNUTzYt8vEMD+RQUSNXkVrXwWZiGBnMoS2T5FgywmoGSVMNnNNt4hGfiWN3yUQ9JNdtA9WMkZGZ0foQQ5ZXPgo/BBeiZQHkifndJt2dwQZHrh/mDc7pQNAUHnQRirjBlfN8FBIlYbpQkYR9z2JGw9rFSJ2ErtRjZGqaOtSg0H6Lgp7urzLWctEU7tZUDzCIDMzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmjLy7WXqWACyOgyaFIA3H4AGZkK/OAJldNBTpslk4U=;
 b=kahGVtwlEicFk8BrRfI9SF4NmDf0FtHWQ7I2niPlbYvzYVTFXvDJN2feKiQRyAaM21VjIOmUjK1iVOVzBfb9KZi11E46UzaHwDzQTCJqak74feRuUFtRpyXO0zJk98DBCDNYFyaJEy2iDBgLW831SJ4mjDypLS+38OL6x6PaJCs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA3PR04MB8953.namprd04.prod.outlook.com (2603:10b6:806:397::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Wed, 23 Oct
 2024 06:47:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8093.014; Wed, 23 Oct 2024
 06:47:51 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTMRLDBR.
Thread-Topic: [PATCH v2 1/3] scsi: ufs: core: Remove redundant host_lock calls
 around UTMRLDBR.
Thread-Index: AQHbJFZis7kYObr4c0yHbDcBFunWWbKS/JcAgADoIeA=
Date: Wed, 23 Oct 2024 06:47:51 +0000
Message-ID:
 <DM6PR04MB65750DBFE520C0DDE075146EFC4D2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241022074319.512127-1-avri.altman@wdc.com>
 <20241022074319.512127-2-avri.altman@wdc.com>
 <8e1ec6a0-38db-414e-90da-4d04ea8d6be2@acm.org>
In-Reply-To: <8e1ec6a0-38db-414e-90da-4d04ea8d6be2@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA3PR04MB8953:EE_
x-ms-office365-filtering-correlation-id: e6bc37a2-5672-42a9-2379-08dcf32e9d99
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SUQ2UFZuMy9adDRnZU1BWXBWT0luaENPaVhIOWZTYUdwc0FLNVdkL2J2dmtx?=
 =?utf-8?B?RkVRam9Cd2ovZFBYZUxieHZXR3R1MlNtc25BK0pubGlPS3dCZk8xd1NlQnl1?=
 =?utf-8?B?TlgyWnVIaGdmVFJqOEovckwwVTIwZzFRZGJadkMxQ2NwbUhHVGlMcXRreUlT?=
 =?utf-8?B?Qy9uT3VnRkpYY1pRK1hNbTRZNGgrOHQ5WnRyYTJkdFEzNUFGZ1Y4MktiQkZX?=
 =?utf-8?B?bmp5Ti9XUVdxVG9yWFUzN0hGbjR5dlM1MTEyaGI4V2lJNmJOQ0RkOWw3bzFz?=
 =?utf-8?B?N3QwSmtHL0xTTmRPVFpJbXFOeVBoZk1sT0dqdFM4NTFjUExLa2F2KzRpeDN6?=
 =?utf-8?B?ZkNWWjRpbFlvV2VsQy9WY1RXSUwxSkNneWhHZUJib3c1UU9TV1R5bzZZL3lJ?=
 =?utf-8?B?NjBiVXE4aVdpY3hyR0tmek1tY0p2Q3piaG9pVk5FdU5zYk9wS2xzaWZWYlNm?=
 =?utf-8?B?T0VCbVE3OEhLRmRZOHVPWGFXTjN5dnFqK1JwbHJJNzZ6ODBDOG85bElMUWs5?=
 =?utf-8?B?Rmc5VWZLa3NxNXJkdk1IRFo3aERBOWZEVVB3Um5WZXJwbnNXSWxTRFQ1eWFX?=
 =?utf-8?B?VElvNGh6RTZGalJoOFllWXdEajh3ZWtlZThhVzM2UERmVTJOYlVDU2F0YlZ0?=
 =?utf-8?B?aEhvcDRyL0Ruc2YrSzZJVnB5VU0rbllqLy96T0F5RnZ6NXVlZE0vQXMzM1o1?=
 =?utf-8?B?VGQ2c0Zqcytrc2JKSzQxaDQzNUkrZDIrN2o1WjJqYXJpQjdCdjdkL2NhT1BO?=
 =?utf-8?B?YTdpak1ZOWpIYnl1dUxuNEUwdmxibE16RXB1RTI3aDgxRTFRMnFzemEwWWpP?=
 =?utf-8?B?cEVRbkNlcGpCWjJ4RmV4Um9tL3B4ZHNseTNpUWdJUGx1WVdldjZid3ptWjBa?=
 =?utf-8?B?S2t6YmpQdE9zTUFkZWloSUNRUFdxcDRBMUtCb1RKM0JVcFRvUXkrVFRoQUlt?=
 =?utf-8?B?Z3BIeExHZzNsVWZ2eFQ3SXdtSnRNOHpLT3ZlSnFobmFVYXNQZzVaM0p3dTZi?=
 =?utf-8?B?dGllRXRHaXVRMnAvRWtyNWtHR0V5cHg4NTVIeGpUWUkvWVk1a0Mzd1Y5TlFZ?=
 =?utf-8?B?MG9kNUk1SiswWXA2blVNMzRyazZLWFp5ZGpJMXpWRmoyNFVqQms0MWdrcXhy?=
 =?utf-8?B?blZSTjRLSWF6UnZEbkhsNTlYNFRpUXJ2dkZQd244Z2FLM1FJMEFyOXhIWWpD?=
 =?utf-8?B?NURseXg0aUo0b2tlcG1Cb3NJUkU3dWR2NjlRUXR0cVNlTkw1bzNYc0FVMTBp?=
 =?utf-8?B?ams5VVV4bkg3Y2xJTjA5ek9Ld09GTzUxOGRMQnd4Rit0cWIyS3ZYR0NTdWZo?=
 =?utf-8?B?UzdYdGlpR2dEa0x1clJoT3Jzc3lya1orSkI2eEdrdjZhb0xBcmM5Rno4a3h2?=
 =?utf-8?B?bVV4STYybGF0bXJLK0s1UXRrbTQ2K050b1owcDhoL1NXT1pxSGJaRnNETVpB?=
 =?utf-8?B?TjhUOWZ5clpJRlg0VU9uK3AzdGYzU0dXZG5GSndYU0VOUisvL001WlQ0OFNw?=
 =?utf-8?B?bXp4KzFrV1p6cUJSVS9iMXU2ZXZDM0xUeExoaEs0cjk3ZUhvTWFiS014UXJL?=
 =?utf-8?B?WUZNME1mdEl2bVVTMVNBN0JLQ0ViclRrK1FRNlphUCtKZmR2MUtUcTRaVFor?=
 =?utf-8?B?bUxZbkMyUlozT2dTMXM3SkxGQ1JkWXMwUFltbmZsWWw0OUFwcU1GUW9ZaUpO?=
 =?utf-8?B?dXovRmdicklvRnhqQkY1d3ZKY1I0ck90Y1BlRDRwc25mUFpkK3hnc2E2c2FL?=
 =?utf-8?B?ZG1XeXVpcUFpV2hHT1Q5TDFFTTlPR3puVjMxR3BhSmg0ZDI5ODBXYWVES0JB?=
 =?utf-8?Q?8jPXTXLeQX/zsbDbgd9JYNsW3+3DHdFD+d6BI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dnBTblJ1SG0rcjJBc1dRelJsSTEzNE8wQkM4Zks5VUJSL0VjNys1MnI2UGZD?=
 =?utf-8?B?SFhrcWtEaTBSSVlua252WmMrZEQ3S1JpN3paVzAydE5RY1lsNlpTTUltZ0pG?=
 =?utf-8?B?dVJUNFoyc2JiY1ZBK2lkbW1kZDlTa3VSMWJJQUU3aDlGeWRwc0dUdE9DMjRo?=
 =?utf-8?B?YlRkZGR1OG9XSmV5eGdDa09GenFPSEU3bEU4dXJZUU5nblBlT3daQWpOVHRp?=
 =?utf-8?B?TCtXWVY3MTVLNXBoR1VMSUJJVHpVUnpvZkxjT0V3Y2VqZk1kWkd2T1dqaEd3?=
 =?utf-8?B?d2l0Vy90UHZZcEtTSlQydHNzTDlISCtzMUFoaTRhS1hjdmhTRGlpNmFxRGhN?=
 =?utf-8?B?b0FoeXh0S3JDM3QzMUI3aTFrTUhHVjA3MldDQVVwVEdmTkRRL1dWOHRGNkRw?=
 =?utf-8?B?WnduNlpXZFpPYTFGaDdDTk0rLy9iYkF3WWpwQmNZVUpiUzlHaDV0QnNGYytI?=
 =?utf-8?B?aEsySS9lWGZWYnd2dFZubHpsZXdiZG1yWFBGcTN5V3FJaTBQZS9YNUx0bWxB?=
 =?utf-8?B?Rjk1UXFWMWRHUkdDRzVUNzNRY3B1UW1WYkJFT0dSRTh3Rll1dHZQK2xVZ1Q3?=
 =?utf-8?B?anV0UkhHQy8yWVBqNUlxUWNHM1ZJVno2WmdyTXYrbDIwaXJNdllRL2JURUs1?=
 =?utf-8?B?dFlvSHExZzY0Y0txNDdaVXZNT2R5eC83cWhCNHRsSk9tcG1JSm9mTHlNZ2NB?=
 =?utf-8?B?MXlLTDU5eXM3QjdNTDZ4LzlpV3VxalVJSmMrKzZCenBmQytpZU1lSnhhUVM1?=
 =?utf-8?B?b3IxMlQ5WXdhNGk3dWx0aklhTHFJbmtFd1l3eUNxcWNrcHMwRGVOWmxObms2?=
 =?utf-8?B?TnJZaUNWaXlPeWczRUtDREY5eU0zSXVBemt5MGUvTE9Fam5RRkoxWEdxQmhP?=
 =?utf-8?B?WUpqelI3NUJxQWhxRVh2WUVxdlV3YkFMK0gwMmFGMTBvOTNTdkVhZGxYZkZk?=
 =?utf-8?B?SkRNR1cxTUxiZTVCOHgyL3ZtRUczanJzN0F3ZDRhd1IwejlJUnV1ak12a1ZJ?=
 =?utf-8?B?OEhibDlaeWxrb3JlcEx3VlExa013U2lOR1pwdUxiN004dmpGR3hvaFlTcHFB?=
 =?utf-8?B?NUhjVjljRGQ4dXNVMVMwRktNK0gvQjg3WTBEcGVacEZCSjdZNExGL1VkeUE1?=
 =?utf-8?B?MERXSWFpblRLNWI3WHpYcFpWTXhjckx1eVh1eGRuK2w1bHZ1NCtGMWJ0Z3JL?=
 =?utf-8?B?Z05XUW1tcEdKQmZSb0lWdmxEdHB6OWFCVG82RDVZOE01Tm55MFUvRWtPT2lz?=
 =?utf-8?B?N2E4UUUwYlo5eGlXMThwTHU0VXcxdEJkWTRlMjhzYk95S21pQlhMYmZOMWlB?=
 =?utf-8?B?dWlxbWZuK0pZRzRqMjgxNkI0c25WUjl2NnJmRERPY0RaSEQvN3pkWThNdDJZ?=
 =?utf-8?B?cUhNd3B3TmNEeWdrM2UyNmtrcVErQ0FwZW5kaHNoNjRqbXg0bjVDWGpKNjZn?=
 =?utf-8?B?OCtmb21NQmRYRk04Y25EL0V0SEJUb0FDNVpCU2oybkR3YVBvNUZzQ3RpT3Ja?=
 =?utf-8?B?YXdaSkdsZ0xCLzdkcjkwcTg1MER1S3pDZTJKTGV2YW1NVVAxcjlMVGlNUlNj?=
 =?utf-8?B?VloydGpIME9aUitERnQwVk1WZ1l6WXBWZ1c3T1p6ZlNGckhwU0RuY3owTTJw?=
 =?utf-8?B?NGhpdjVMYWRuTytKSTN5czYzbEI2SFRYK09UeGVvZzhFZnlYYzJpVVRCMmFM?=
 =?utf-8?B?U1U2ZVA3T1p4cEp4eDBCYjB2VThhdDJiU2x0djNvNEllTnhXRkNVQ1FkWHVI?=
 =?utf-8?B?TkVNb254clNGd1YzbGFBTHFyWTdkTlR3cGk1TmhaNkpjS3dRTHY1WUJoTTNN?=
 =?utf-8?B?S1FvTlRDN003ejdRbjZSc0ZZOEg1OWxMM3oxZzhuNCtYdFBodk9jNzFsQ0sw?=
 =?utf-8?B?RGl1OXZkdjloNmp0czZpS0dRSi90T0JZVm9lRm9sOVFqc0hXVGQxUFIyN1N4?=
 =?utf-8?B?SWVXR1JkbVNjQXluY0lrT3J0bVAxK3JsQVNnaGlsdyt2bmpuQzF0ZzZVcTVJ?=
 =?utf-8?B?NUt5ZEpSNk1QbHA2THNaL2lRRk4yOURCQ0R5dXJYdkxnQVZHblBSQVpKclY0?=
 =?utf-8?B?UytrV0EwRE1BaDJsQUl5WmFQOU95b1dxemNZRDcxOEVrQkRuOTJuTXlMa0cw?=
 =?utf-8?B?MEF2V1k1Y3Y0NFUwQXc2YUtET1NJc2pEb0NDV3hEMG1nbTVNaUJjRVdFZzFD?=
 =?utf-8?Q?uwCM89RLSS4LHCIV0ZAvjmAquqMLu8nj3LFD1TdS7bto?=
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
	Lf0ryGv/4QSB861bXlSNkR/elFW6pA57p4bWGYofn/zw9AXrttXnViVYxIuPCpTGNxU+39Qt1KiMf34DrGKp830eMrTnfdEe/vSgpJDYElLaYoysqVS6fXS1ilx1lCV8d7rFge2UBmZwP/+OAvMsh77JsuclEY8si7MAOsQZ3Cw7KKw1mOgI2wvcFQeE0snk0qELo3Ps5ReheHyj75OUiL9SliA1bMzERtUCXk0vi5cQAriY7iD4zWDhJFebVAC1bkCUB0Eo20NQir1P0V5APdiUyNljBFOT1uQU8kjR3d0OWkcDJkfeuxPFDXW6NS/XeDwiLBhJERqk0GwaG3z1JDwZ0vxDdR50RkF935Iv02VPTwKIKVRJxUMRHwp4KX53+7Y5s4nrVyd5ppPEoexTYa57RrsoPTvb92R1qmsGpST/AZpTSVCuCwYvH3XkU/4jLKtclc8z1FLAWbNFJMrLy4KVDa7Pw/+v7GFT4cRL5uB1AailB56+oZe0STu/55UkxEVgP/0x1BRPwizrk+N1sYZD2YsPbqNDfLs77T5SMBa+MZlDoHRprlBJo5YUpEJyZWh/1hrQvRooZaJPWOHF+C/WiV9C1tev1/GLKr3SUorbjJ4nvt8kCbl1XJh1ewgw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6bc37a2-5672-42a9-2379-08dcf32e9d99
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2024 06:47:51.7739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c22nPjKWnEQwg62/1oxggClhz5yMv4BzLKwqU9ssJ9Z0NhRzy7zVIi7bfSBg8R6i7VjFK442bSm4dBCOAw7qSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8953

PiBPbiAxMC8yMi8yNCAxMjo0MyBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gQEAgLTY4Nzcs
MTMgKzY4NzQsMTMgQEAgc3RhdGljIGlycXJldHVybl90IHVmc2hjZF9jaGVja19lcnJvcnMoc3Ry
dWN0DQo+IHVmc19oYmEgKmhiYSwgdTMyIGludHJfc3RhdHVzKQ0KPiA+ICAgICovDQo+ID4gICBz
dGF0aWMgaXJxcmV0dXJuX3QgdWZzaGNkX3RtY19oYW5kbGVyKHN0cnVjdCB1ZnNfaGJhICpoYmEp
DQo+ID4gICB7DQo+ID4gLSAgICAgdW5zaWduZWQgbG9uZyBmbGFncywgcGVuZGluZywgaXNzdWVk
Ow0KPiA+ICsgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gKyAgICAgdW5zaWduZWQgbG9u
ZyBwZW5kaW5nID0gdWZzaGNkX3JlYWRsKGhiYSwNCj4gUkVHX1VUUF9UQVNLX1JFUV9ET09SX0JF
TEwpOw0KPiA+ICsgICAgIHVuc2lnbmVkIGxvbmcgaXNzdWVkID0gaGJhLT5vdXRzdGFuZGluZ190
YXNrcyAmIH5wZW5kaW5nOw0KPiA+ICAgICAgIGlycXJldHVybl90IHJldCA9IElSUV9OT05FOw0K
PiA+ICAgICAgIGludCB0YWc7DQo+ID4NCj4gPiAgICAgICBzcGluX2xvY2tfaXJxc2F2ZShoYmEt
Pmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+IC0gICAgIHBlbmRpbmcgPSB1ZnNoY2RfcmVh
ZGwoaGJhLCBSRUdfVVRQX1RBU0tfUkVRX0RPT1JfQkVMTCk7DQo+ID4gLSAgICAgaXNzdWVkID0g
aGJhLT5vdXRzdGFuZGluZ190YXNrcyAmIH5wZW5kaW5nOw0KPiANCj4gUGxlYXNlIGtlZXAgdGhl
ICdwZW5kaW5nJyBhbmQgJ2lzc3VlZCcgYXNzaWdubWVudHMgaW4gdGhlIGZ1bmN0aW9uIGJvZHku
DQo+IEluaXRpYWxpemluZyB2YXJpYWJsZXMgaW4gdGhlIGRlY2xhcmF0aW9uIGJsb2NrIGlzIGZp
bmUgYnV0IGFkZGluZyBjb2RlIGluIHRoZQ0KPiBkZWNsYXJhdGlvbiBibG9jayB0aGF0IGhhcyBz
aWRlIGVmZmVjdHMgaXMgYSBiaXQgY29udHJvdmVyc2lhbC4NCkRvbmUuDQoNCj4gDQo+ID4gICAg
ICAgZm9yX2VhY2hfc2V0X2JpdCh0YWcsICZpc3N1ZWQsIGhiYS0+bnV0bXJzKSB7DQo+ID4gICAg
ICAgICAgICAgICBzdHJ1Y3QgcmVxdWVzdCAqcmVxID0gaGJhLT50bWZfcnFzW3RhZ107DQo+ID4g
ICAgICAgICAgICAgICBzdHJ1Y3QgY29tcGxldGlvbiAqYyA9IHJlcS0+ZW5kX2lvX2RhdGE7DQo+
IA0KPiBXb3VsZCBpdCBiZSBzdWZmaWNpZW50IHRvIGhvbGQgdGhlIFNDU0kgaG9zdCBsb2NrIGFy
b3VuZCB0aGUNCj4gaGJhLT5vdXRzdGFuZGluZ190YXNrcyByZWFkIG9ubHk/IEkgZG9uJ3QgdGhp
bmsgdGhhdCB0aGUNCj4gZm9yX2VhY2hfc2V0X2JpdCgpIGxvb3AgbmVlZHMgdG8gYmUgcHJvdGVj
dGVkIHdpdGggdGhlIFNDU0kgaG9zdCBsb2NrLg0KVGhhdCBtYXkgY2F1c2UgY29uY3VycmVudCBh
Y2Nlc3MgdG8gdG1mX3Jxcz8NClNvIGJldHRlciB3aXRoZHJhdyBmcm9tIGNoYW5naW5nIHVmc2hj
ZF90bWNfaGFuZGxlcigpIGFuZCBqdXN0IGxlYXZlIHRoZSB3aG9sZSBmdW5jdGlvbiBhcyBpdCBp
cz8NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gT3RoZXJ3aXNlIHRoaXMgcGF0Y2ggbG9va3MgZ29v
ZCB0byBtZS4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
