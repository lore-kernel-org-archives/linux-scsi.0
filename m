Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F0B1DA305;
	Tue, 29 Oct 2024 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730227154; cv=fail; b=LU9n8/AHCfE8TVbWhzbGui+pU3oGLUg0RfzeWo2iX9n7VkU2w6OQKc6WvGTQ4y4t7yDeMD3I864lLBj1xB8nyVeSN3xP1yicsuXF9oHo1YH6uvWWb/yhk7dE9ShBL9WjvBqTIkd0Xqv8z0bXUXtg19lxJ0QfejobtJEJhrR1PPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730227154; c=relaxed/simple;
	bh=gRmXL2Mxp1+KTd2K+Eh4xFIQSqmBT/9pZ3v8f45kBus=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TbA/hQfNnB6dDYwfiw/DyZqTfYee/p8sucXKhkFPgBshp4pvBl2fcW3v+dvFRdHvgxXspQM4FpnimZlUZD5mTjXeJNDyKqnQofa7t5iehDPHtYWg6CS1mBEF7ZUOv0YRhcJaANBePo0dCvU6GJjL0xSelb68vIuBThK/zSyS1OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ohZwjXxk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=aa63jTGn; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ohZwjXxk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="aa63jTGn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730227151; x=1761763151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gRmXL2Mxp1+KTd2K+Eh4xFIQSqmBT/9pZ3v8f45kBus=;
  b=ohZwjXxkZmt4N4VHmDB/Onh326cbyJxKQGyxp2A6XZhvNJf/TokBqoku
   MM6ZDyULKsD11OEIDKDUpsLLqk3XamLWQikPSZupvieuNkLbP9gSBwWnK
   YNwEzUpEsjpHiqN2GxETIVdZB2tbnqRd6CYcogAlOUBzu6/Hilm/Ax1qU
   BsyBZj0ld5g9MyJBckxiA7kDYz3iBrBS5qnfPJD5eG7FmIEpSuYDazJTu
   6TQu/69M/ofOPSB+A1SxbgN8k56FoCHgundOR4w03THOjOG3kgc0OSh98
   SWw8z25jXnrQhWy59CkVlZ1slFhjh/jpWpTOXugBJsg8oFjvvenLM8Skn
   A==;
X-CSE-ConnectionGUID: Jt8AnjmKRWapU16TdieoUA==
X-CSE-MsgGUID: aFnayRVMTFmN7hT3l/dquQ==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="31268965"
Received: from mail-westcentralusazlp17012039.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.6.39])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2024 02:39:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0OYIo05BZYdRI/Xm9MJlHLQ8BfGUwydcds7UITeTvlIfur7eYlF+THaHl36VHR9HZgVzJnCjSL5sRyICbwb+L+glsC2vJ3iLUuyPZjI+NjJFWAS1hwhX0NzilFEDog8QvssyRjhqBVE3UQD0/8WDIfENu/z1P269vlgsRyTNc5oOb/VoPyE79XMPZX9OrhFegEnT+ZiFyNtAS8LmZCtLAKJZ5flzfGfmcn1FMAdWc8svXfA5FQ0WF3UiN4PUkwG52lBTSuXRVDq8sridMuzmMdbLBwWcrU6q7w0ykoM0LR78ZqtgXavY8VOhulyocjBq4333cXeNY91YpDj4fu1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRmXL2Mxp1+KTd2K+Eh4xFIQSqmBT/9pZ3v8f45kBus=;
 b=WNcMZVOwex8eFrp3A0+w+mIFK7jQggWAwJhtewzshHbxjKxzdKXjqvGLeuLiPDPtdoXb87pgZDtoFnmcz2/5jzGVod2sQTAVDjzXiHiEXTG2ktPOYeqVzDh03Ld3kNZIyHNMIpBi/yL8pvQfywcsIWSyAPVi6kTnMbyC9dDq+um63rPlVlIq+Q9iX4TJoG87JTwTwuskK85+0rPAaCZfOdZa3UMI5YdQCLmZHKoL1rbCW6cspUhXJeBzMLegYq5bXLw/xyVM0pTuski0VXIpIAlT4cEtLAtcCda1d+aIYI95MgcC4zmnbE8U8MRekKqiQ9C+yuFsLUX7C/Vj/lGQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRmXL2Mxp1+KTd2K+Eh4xFIQSqmBT/9pZ3v8f45kBus=;
 b=aa63jTGnvm/jhlP90u8eDdxaXdCIXXvj37+lFCXVDXMiEJFQYjLdSsn3fyTtX0Oe1JtLKXPh3tsD/B7KqXhy8ntKyFsGeKDbxSWFMU14wr955yiTGFoi0wySwHakuFY/mI0walxItZuz8a8RZqnrLd/dsSTSHZoWUTOI6dug4Cs=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by SA1PR04MB8518.namprd04.prod.outlook.com (2603:10b6:806:338::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 18:39:08 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 18:39:08 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbKe3M/6h00Nm5DUau61FIkVY2VrKeCAMAgAAGuyA=
Date: Tue, 29 Oct 2024 18:39:08 +0000
Message-ID:
 <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-2-avri.altman@wdc.com>
 <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
In-Reply-To: <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|SA1PR04MB8518:EE_
x-ms-office365-filtering-correlation-id: 7aa1de7f-d0dd-4c07-7d6f-08dcf848f92d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bWU5VWU4S0JNdjNmRG5GSkVwa2pxRWJ2LzZBYklVbDRUUVFYb0ZQNVBPdEFF?=
 =?utf-8?B?SVV2TVpUY05Kdyt4bXlUWW1wcFZLTVBodDRSaVVRS3FzUjBDQ1BmRWx1NFQ1?=
 =?utf-8?B?WFJESTZxdGhzOHBTbjJ0QjNVNDR6MGx1UnMvZi9YelM1YTZNeVRVTXlVWGp0?=
 =?utf-8?B?NXNCYy85eVpLR3Y2R0pHUThETUVuM3cvdHFiYitpeklZL2lhRHdnazlkVzha?=
 =?utf-8?B?ejZqd0I3bHZtTC8xdDMvSFhOWXZRWjAwc3Zmc1ZFeU1XbnZnZ3NtdEcrZDhs?=
 =?utf-8?B?MEo5djhScm82dmRONlJqVzFsWVRxdTdoQzNTT2I4MGQxUk5CUzErRUMyRWdw?=
 =?utf-8?B?bDNydEJiZ2pSdVplVHFZN1FtY1BhZzV4NmdHKzhHLzZjdk1ncDg2SlNsY0o0?=
 =?utf-8?B?T21SbXpPaDBHNjQ2WjVpV1A5bXBQamRoQXVIbDJWMmhlcHl2aEpFR29TWS9o?=
 =?utf-8?B?UXdaNzZwQlpQam9jV0NJMXdYWDRBYzM3UDF3Y0Jxd2RPRUV2V3VPQlBveDF6?=
 =?utf-8?B?V0FnMGpMQ1ZicVJmNUNPVllMRXZoWGpWcUNBMkRHMC9zUmpPZDJQYkg1NWVW?=
 =?utf-8?B?Yk4yUUhrem0yM2FDYVJmeERJT0NGRUFNcmo1ZzZUOCsvT2NXZml2UFB5SDI5?=
 =?utf-8?B?N0twSnRtMjE5VTN5TVB6NkpKcUtvRXFZanllbkh4aHVrKzlwVlV5Q2JXZ2I3?=
 =?utf-8?B?TWVVYU9lNGRQeTBLOXNaTzk5UzdOV05hbURGb3BiTXFrbDB1WTgxK0RrV0k0?=
 =?utf-8?B?VkQ2OWdpdkFsMFU4L0JLMUhUMXZ2RW5tWmNKVEdQbERYWTAyQlRXcW9IKzhD?=
 =?utf-8?B?QVN2ZDdoWEZOWXNNQjdJcStGbk0vNkxGcms2bEE4Q0NjcU5uUVd2cTlFTEti?=
 =?utf-8?B?eDBzaEd4Y29TZkIxZE5wbmlURVhGQWdzamxqQ1k2SzlaeXpRSlB5OFp3aFVZ?=
 =?utf-8?B?VnNyaDUzbDBnYlZpZnNhMFoxdXpNT2dRWG1wVWxPNHJHZ2UreU9oRkUwaXhP?=
 =?utf-8?B?d29sK25wV01saThDVE55bUY4TkV2MjlKSVc4RFFtSXJwSzBXa2R2S3F5b3k2?=
 =?utf-8?B?TkRDTzZYZXdRczM5NmdkVyt1YVNqT003bDBWdldYZlN3VzRzbjZpZzRNZHNz?=
 =?utf-8?B?MzNjV1BKUGNJUUZyOW5lR2ZiOWdnd1J6WTVrM0pFNVQ2STI1NGtBTzFUamdp?=
 =?utf-8?B?d3pEUTN2TE9LR25BQjNHTkdtbVhNN1dZVkdxT05tZG1SQnpMemtPWENZQ3dz?=
 =?utf-8?B?elhMWnZhR29uaE5xSjdrdWlLVUN3aW9hbzlrbU5NLzJZN1IxZGs1bVlVUlB3?=
 =?utf-8?B?Z3YxTmZXaitKcWJENFgvQ1F0OGZKaVBnSEFnY1cvalVUblAyczFEVmdLaGRD?=
 =?utf-8?B?TUVUSmxwUUtDVENERm5GeEs0UCtIWHV0UW90VUk5d1hkWEpuQzgxTEJWWDdF?=
 =?utf-8?B?ci9icXBVTU1DemxGOGFMRG84c3Jvd1MxVTVXM3d5eFd2ODBXVTFZVFdINGVK?=
 =?utf-8?B?ZjNYR2cwOWUrNWNVU01lSGVET2RkUUFOeENRNDlabllzdEhmQ1U1RmxZSWpY?=
 =?utf-8?B?SjlIUnRpSnhDVkR6eTFlMkk5RWZQS0QwcUk3NVVNNVdWc2lacmN5MUFxNDY4?=
 =?utf-8?B?RUVxMVpaK0hwNWFUdE9MVFp6M1NpL1J0NXFYUUo2U0JtZ0pXRVQxd21QTlBR?=
 =?utf-8?B?MkFicjBya3Vwd1dNZDkwOWpONmFGaytTZ2MrdUEzbWJYdk9RTHlsRE9oWE5T?=
 =?utf-8?B?M3JjZzNjeFBIV25UUTdJTDQ0M25JbHNXMDB5bzNWSVIxU0ZyWDQxUWd0NHdy?=
 =?utf-8?Q?BaxgxwLrfphw6nPDzkE5HiLhyBl86WhN9vW/0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U3dDQ1c0Y3FRcU5lUTZqSHNwSHIyRUVPWFhkdTJCYlQrT21zWnd4RitVa0R5?=
 =?utf-8?B?bERlYWR1QUZ0QUtqVWRNeFdkWUVQaVlMaC8zOE92Wm5YbW5YaEtLd09MWjBM?=
 =?utf-8?B?WlM1WkZBaGFhVUxzdEgzS2cwaGNydS9udlJIbklKeDhGWXN2K2FwdGNyQzJa?=
 =?utf-8?B?aGpSTmZ0ZmFEa0d3OGJKVDV1dmJXU1A1SWlsbDhITlJLTDNiUXhzSzE3b0tP?=
 =?utf-8?B?Mng5eVprS05RYXgzcWRWckwwMjJVaHFVNTNJNEhwRFdtdjMwNzcyVndqMDI5?=
 =?utf-8?B?TFcxSzF0KzQ1elhtb0RHUWFRbDBTbkJjekJQTENydUZXTkJuUExiL2RDWXdD?=
 =?utf-8?B?NnNTbWdXYzZvVVJveVloV2lCOVpZR1FodzFlV0Vhc3BHb1BWNFQ0dDhOUXU3?=
 =?utf-8?B?Qjk0bFBFOHFXcFJSMmx2YktGaTRjY3J5Q3FUZm9VSGw4ZG4xSzBLeERKZnVv?=
 =?utf-8?B?cWNxb016bEY0d1VNTzdsVTVlWkhYTjhadUpQaXd6a0plMnZaVngwMnRpUVlk?=
 =?utf-8?B?QnZNNTJ5cGRnenBDTkRkelMwckhYWXBQaUFaU2YzS2ppNzY3WWpIZldUY1JI?=
 =?utf-8?B?K0RkN2h5bUpTczQ4MWtYL1k5SXVIejladzNDdmppcDZhZDV5cmtxaWZmOGpn?=
 =?utf-8?B?a0pMTCtPQnd0Y0JMV3lhMUxDM2JSL2RPWnhxek5zTkZWTHJvdW1XWWFhR2E5?=
 =?utf-8?B?blptbW4xM3VZcWFSZGxFSnVWMEhVZndFZmNZZ1J6T3RlSFRRK0t3TkxMUFlq?=
 =?utf-8?B?ZmVPc2UreS9ldGlUUFZPTFdVUWZabmFtWVEvZFpwbm55WExBTFJGSFJqZEpH?=
 =?utf-8?B?elVXd2VrVVEzVnFHdnlBR1JITFFIQklkcFZVc21NNlZSV05ZdmpZbTRaS3dK?=
 =?utf-8?B?RVFRUUU5VUNyMkE2QVVzN29pSjc3cnBSSFQyMytQdDlVV3ByMTJSRkR4UWZx?=
 =?utf-8?B?Snk5b2QrM1NMcFY2L2taVHpuNTBQN256ZHlVc3pob0xJeStiTzJybHgzY2c3?=
 =?utf-8?B?cXZKcDN2ZDdpR3lIWmRGUk9vYXFVNXA1Z1lqaEJFUEhnWG8zdThxeUgyRjZ4?=
 =?utf-8?B?Z29TcEY5T0h0ZUdVZ0tNM2lESTFubVU2YjJuVkhWVnU0T0JtYzB2MnVxWUd5?=
 =?utf-8?B?OUV2MUFQZUI1SFRHQmJUL2IxY3AyVGNiRURqU25hQWREWlIxUlZodVd5eDRO?=
 =?utf-8?B?YlFOUDBad1gwRnltcUF5dFJWbjNJUjJTS0pCdVF4MjFLYjlaQ0RQTGRUSFo3?=
 =?utf-8?B?N2hIS0tPQVNiOERtNE5SUFdrR2NYTjFXRlpBR2kvWi90c2pIQVQwZkc4SFdC?=
 =?utf-8?B?c09GYVU3QWltR1IxY3pnOEszMlltMjBaOVYvS3pKSWRxbTBFYlBPN3dMNnZX?=
 =?utf-8?B?dmpDYWpId1B3OUhWajByY2dnMWp3cXkxU3VnM3ZHMlJFYmgvWTVWYURSa0c4?=
 =?utf-8?B?VlZ2RTJoZ0tGUEx5L0xEdWZIaFllUXVZQVBjc0FvQ3BZc1FURnJWVmd1NVd1?=
 =?utf-8?B?bUk0VDZwM1JRQjBzTk5LMCtuZkw2b1lGUlpheEJmaU5uM1lqYXBFbElrN2Ez?=
 =?utf-8?B?SGlSN09JV3NETWcvSHZQUGN3WWdjTWg3TzQ2MjdCc1ZLcHNzWjA0UEhnTG9x?=
 =?utf-8?B?eHFyRWc4amJ0YmQrT01LU2FGZVh0cXAvWmUxeGUwc0YzMUFpUk94M3B4dXl5?=
 =?utf-8?B?STJ4MzI5NmJ1dzlvUDhHRXk3dlk3Njk4YWVTeHdhVEdHQnQvTDVadzZZb1Rt?=
 =?utf-8?B?cFpoS0RocS9sT2hHdDZPZy90cjdHWFZMMGQyMEc0NUk2Z0crYUJmYVZpOG04?=
 =?utf-8?B?ZUtkakZEaU9zMGQ5S2xmWHhVUkRhY0pEZmtQeng4bGF3aEIvL2xjeXU3M21m?=
 =?utf-8?B?VHR6aWplQzQvaWF4Nm40RVgyeXVUNFVERENGMFN3RXpodVZ6eE9qeFd6ZzQ3?=
 =?utf-8?B?UVZPOVFwbGJEZlVDQWZ5N2wzQnVFRExSQWFFNWtCRWV2b1JJN2hZWEZrK0lG?=
 =?utf-8?B?NCtDSUtpdVAwT1BPTytUR0pIY1c1Vi8yR1orUjFFYWp1czdSSWFtaUxpWWVh?=
 =?utf-8?B?a2Y1QlZURTR1ZldTdGJpYjVPM3VZVFJqSkhZbWlNb0JJb0cwSnU3Wjk2M04r?=
 =?utf-8?B?cjN3ajVqcnp5ZEk5SFYrWEVCcXM4RG1kYi80M01MU2x1UnlwY3Q2ejhQSzJL?=
 =?utf-8?Q?Dl1giG8qyrvvokaiiL/jUDuS9/tBxvvK8QWqBjOC1vQo?=
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
	42/EAVDR5C8dWVpCn3CT4mz09b8kLaTAd88rdvqC77fWfU1X+EVwOszXMx3Kt0rq5Xg3nAV2KFzYrII5GaCb74mVqcyq2bpkcuiItzJY3pOKmRyEw1VQtL/Xho3YSYAIXiz5Y8Vc6V86yS6H1Fx3w0N3wRy6BLRH8DYW3/pFqFXizLAEZJ7IKSmFW/foWsWBuKwO5tOSCcghVsiFVMJr85enyI6ngqepJPAl/VggsJJx67IdIrYrsAUfjK1K5ei9Ag3NNjk4m21dieLYUqacKhcKF0RpYzHvuwrZGRqLjzdqgEje/pcX/aT1IH/ICKkhsUUMT6P47K0beXJbcZCrH6mZKm3EHpmN7+/MaEud7e4f5aOdlh7nI7UdNuuAdFeMcNkN5o7rK+DucRx/RkeSS+0JYOvGga+Mx+yWOsxcNxGLt3cyv/aWFAjfD5wfajcfGhd41rNlngIk4tpOfK7uazEeT/RG2rZdMYnXGyhT2Fq5WGKAiiH55EH7DzpGMazI8HdfeDGLgi+G0aFhpIez6d8VwN6FEdwCr7+G7PqpgeV6OLQ1Fzx+WNSXZ2C8myD/fR4meJoYisIticamBhIq7uzX0RyIaGwO9NkaNQ7AuBoYELEij4p8eNEDdcwZ2TgW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa1de7f-d0dd-4c07-7d6f-08dcf848f92d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 18:39:08.0991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D88Oklo9/wadiU6VOQBHkCupW177Y6ILrgKa7NK0sPsT8Eat33B9CO1HrKFExTVcpEn+moNwVFRMxM9uxCrESA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8518

PiBPbiAxMC8yOS8yNCAzOjI5IEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArICAgICBzY29w
ZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwgJmhiYS0+Y2xrX2dhdGluZy5sb2NrKSB7DQo+ID4g
KyAgICAgICAgICAgICAvKg0KPiA+ICsgICAgICAgICAgICAgICogSW4gY2FzZSB5b3UgYXJlIGhl
cmUgdG8gY2FuY2VsIHRoaXMgd29yayB0aGUgZ2F0aW5nIHN0YXRlDQo+ID4gKyAgICAgICAgICAg
ICAgKiB3b3VsZCBiZSBtYXJrZWQgYXMgUkVRX0NMS1NfT04uIEluIHRoaXMgY2FzZSBzYXZlIHRp
bWUgYnkNCj4gPiArICAgICAgICAgICAgICAqIHNraXBwaW5nIHRoZSBnYXRpbmcgd29yayBhbmQg
ZXhpdCBhZnRlciBjaGFuZ2luZyB0aGUgY2xvY2sNCj4gPiArICAgICAgICAgICAgICAqIHN0YXRl
IHRvIENMS1NfT04uDQo+ID4gKyAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAgICAgIGlm
IChoYmEtPmNsa19nYXRpbmcuaXNfc3VzcGVuZGVkIHx8IChoYmEtPmNsa19nYXRpbmcuc3RhdGUg
IT0NCj4gUkVRX0NMS1NfT0ZGKSkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBoYmEtPmNs
a19nYXRpbmcuc3RhdGUgPSBDTEtTX09OOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICB0cmFj
ZV91ZnNoY2RfY2xrX2dhdGluZyhkZXZfbmFtZShoYmEtPmRldiksIGhiYS0NCj4gPmNsa19nYXRp
bmcuc3RhdGUpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gKyAgICAg
ICAgICAgICB9DQo+ID4gKyAgICAgICAgICAgICBpZiAodWZzaGNkX2lzX3Vmc19kZXZfYnVzeSho
YmEpIHx8IGhiYS0+dWZzaGNkX3N0YXRlICE9DQo+IFVGU0hDRF9TVEFURV9PUEVSQVRJT05BTCkN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICAgICAgIH0NCj4gDQo+IFBs
ZWFzZSByZW1vdmUgdGhlIHN1cGVyZmx1b3VzIHBhcmVudGhlc2VzIGZyb20gYXJvdW5kIHRoZSBS
RVFfQ0xLU19PRkYNCj4gdGVzdCANCk9LLg0KQnV0IHRoaXMgaXMgYSBmb3JtYXQgY2hhbmdlIHdo
aWxlIG1ha2luZyBmdW5jdGlvbmFsIGNoYW5nZS4NCg0KPiBhbmQgZG8gbm90IGV4Y2VlZCB0aGUg
ODAgY29sdW1uIGxpbWl0LiBnaXQgY2xhbmctZm9ybWF0IEhFQUReIGNhbiBoZWxwDQo+IHdpdGgg
cmVzdHJpY3RpbmcgY29kZSB0byB0aGUgODAgY29sdW1uIGxpbWl0Lg0KSXNuJ3QgdGhlIDgwIGNo
YXJhY3RlcnMgcmVzdHJpY3Rpb24gd2FzIGNoYW5nZWQgbG9uZyBhZ28gdG8gMTAwIGNoYXJhY3Rl
cnM/DQpJIGFsd2F5cyB1c2Ugc3RyaWN0IGNoZWNrcGF0Y2ggYW5kIGRvZXNuJ3QgZ2V0IGFueSB3
YXJuaW5nIGFib3V0IHRoaXMuDQoNCj4gDQo+ID4gQEAgLTIwNzIsMTggKzIwNTUsMTggQEAgc3Rh
dGljIHNzaXplX3QNCj4gPiB1ZnNoY2RfY2xrZ2F0ZV9lbmFibGVfc3RvcmUoc3RydWN0IGRldmlj
ZSAqZGV2LA0KPiA+DQo+ID4gICAgICAgdmFsdWUgPSAhIXZhbHVlOw0KPiA+DQo+ID4gLSAgICAg
c3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiAtICAg
ICBpZiAodmFsdWUgPT0gaGJhLT5jbGtfZ2F0aW5nLmlzX2VuYWJsZWQpDQo+ID4gLSAgICAgICAg
ICAgICBnb3RvIG91dDsNCj4gPiArICAgICBzY29wZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwg
JmhiYS0+Y2xrX2dhdGluZy5sb2NrKSB7DQo+ID4gKyAgICAgICAgICAgICBpZiAodmFsdWUgPT0g
aGJhLT5jbGtfZ2F0aW5nLmlzX2VuYWJsZWQpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGdv
dG8gb3V0Ow0KPiA+DQo+ID4gLSAgICAgaWYgKHZhbHVlKQ0KPiA+IC0gICAgICAgICAgICAgX191
ZnNoY2RfcmVsZWFzZShoYmEpOw0KPiA+IC0gICAgIGVsc2UNCj4gPiAtICAgICAgICAgICAgIGhi
YS0+Y2xrX2dhdGluZy5hY3RpdmVfcmVxcysrOw0KPiA+ICsgICAgICAgICAgICAgaWYgKHZhbHVl
KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBfX3Vmc2hjZF9yZWxlYXNlKGhiYSk7DQo+ID4g
KyAgICAgICAgICAgICBlbHNlDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGhiYS0+Y2xrX2dh
dGluZy5hY3RpdmVfcmVxcysrOw0KPiA+DQo+ID4gLSAgICAgaGJhLT5jbGtfZ2F0aW5nLmlzX2Vu
YWJsZWQgPSB2YWx1ZTsNCj4gPiArICAgICAgICAgICAgIGhiYS0+Y2xrX2dhdGluZy5pc19lbmFi
bGVkID0gdmFsdWU7DQo+ID4gKyAgICAgfQ0KPiA+ICAgb3V0Og0KPiA+IC0gICAgIHNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiAgICAgICBy
ZXR1cm4gY291bnQ7DQo+ID4gICB9DQo+IA0KPiBQbGVhc2UgdXNlIGd1YXJkKCkgaW5zdGVhZCBv
ZiBzY29wZWRfZ3VhcmQoKSBhbmQgcmVtb3ZlIHRoZSAib3V0OiINCj4gbGFiZWwuDQpEb25lLg0K
DQo+IA0KPiA+IEBAIC05MTczLDExICs5MTU3LDEwIEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldHVw
X2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIG9uKQ0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGNsa19kaXNhYmxlX3VucHJlcGFyZShjbGtpLT5jbGspOw0KPiA+
ICAgICAgICAgICAgICAgfQ0KPiA+ICAgICAgIH0gZWxzZSBpZiAoIXJldCAmJiBvbikgew0KPiA+
IC0gICAgICAgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZs
YWdzKTsNCj4gPiAtICAgICAgICAgICAgIGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT047
DQo+ID4gKyAgICAgICAgICAgICBzY29wZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwgJmhiYS0+
Y2xrX2dhdGluZy5sb2NrKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBoYmEtPmNsa19nYXRp
bmcuc3RhdGUgPSBDTEtTX09OOw0KPiA+ICAgICAgICAgICAgICAgdHJhY2VfdWZzaGNkX2Nsa19n
YXRpbmcoZGV2X25hbWUoaGJhLT5kZXYpLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgaGJhLT5jbGtfZ2F0aW5nLnN0YXRlKTsNCj4gPiAtICAgICAgICAgICAgIHNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiAg
ICAgICB9DQo+IA0KPiBUaGUgYWJvdmUgY2hhbmdlIG1vdmVzIHRoZSB0cmFjZV91ZnNoY2RfY2xr
X2dhdGluZygpIGNhbGwgZnJvbSBpbnNpZGUgdGhlDQo+IHJlZ2lvbiBwcm90ZWN0ZWQgYnkgdGhl
IGhvc3QgbG9jayB0byBvdXRzaWRlIHRoZSByZWdpb24gcHJvdGVjdGVkIGJ5DQo+IGNsa19nYXRp
bmcubG9jay4gSWYgdGhpcyBpcyBpbnRlbnRpb25hbCwgc2hvdWxkbid0IHRoaXMgYmUgbWVudGlv
bmVkIGluIHRoZSBwYXRjaA0KPiBkZXNjcmlwdGlvbj8NClllcy4gSW50ZW50aW9uYWwuDQpEb25l
Lg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
