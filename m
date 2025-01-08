Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8310180604;
	Wed,  8 Jan 2025 19:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.86.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736363149; cv=fail; b=DxkL3vesSmqVNa9FbnsS/4ou6PmZP+2Qdmu2CtvGyEGHInfdy1ODu4foX/JWlHT2jks8QIh7vDnn1FYkC9jfpNCRT9DvYMA5o3fxou1kfSBwywDvhpT9oeeRfw/VY32Vfn1ZpWjSTreR/A4OhOEp5J5/UekRrrRKI7P82ZzF2do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736363149; c=relaxed/simple;
	bh=zJskn3tJcpZ8np9KI0Xzv5VR+cpFu3Qw4NgIEfOk57E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fRZAvnngdB/Dc948ZcN+2jKcpEXIgJTKx6CcoZfzqS6jsprn/+C+/Tpur+RQNFLd9kiMh0sL/CFYd0hWqnOz4FhCWogb4sl3bJ1KefEQh2k4j2TsEQaLvhyXiI3m8G/ePkx+T/FYqaWA1vLW67NEAntCpbSrOwu5DTqoQTm9XVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=AxU3ctk5; arc=fail smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="AxU3ctk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1101; q=dns/txt; s=iport;
  t=1736363147; x=1737572747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=13LrOLVzIroVxboGWE/WrU+C1sGpS2TIGxQNgYGCN1o=;
  b=AxU3ctk5e/PiRsThqVPtRBdeXUyZXxRGqHwP3pQYaCbR/0Fv5Q0ANUJ+
   ZThsYn9TC6rcAdwgEL2oWQ8piW6WUycJwktNBaVxPKFguQ7dYL8aausDR
   PNt2j578V6wnBs39FzQO/JyGA7BSspia7HXHYB9qXSW7pz0w1ZKeODjZt
   8=;
X-CSE-ConnectionGUID: YcKyLAgySvGC200dZ9geBQ==
X-CSE-MsgGUID: F/zzkFrgRHiAJofDPwO1SQ==
X-IPAS-Result: =?us-ascii?q?A0AJAAAGzH5n/5H/Ja1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVIHghJIiCEDhE5fhlGCIQOeGIElA1YPA?=
 =?us-ascii?q?QEBDQJEBAEBhQcCinQCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThgiGWgEBAQEDEhUTPxACAQgYHhAxJQIEDgUIGoVEAwGmegGBQ?=
 =?us-ascii?q?AKKK3iBATOBAeAggUgBiE0BimInG4INgVeCaD6ECjuEE4IvBIIzS4Ergllnn?=
 =?us-ascii?q?hxSexwDWSwBVRMXCwcFgSkfKwOBFCaBKgU1QTqCDGlJNwINAjWCHnyCK4Ihg?=
 =?us-ascii?q?j2ER4RYhWaCF4FmAwMWE4I+VB1AAwttPTcUGwUEgTUFmnU8g28BgQ4cgiQpl?=
 =?us-ascii?q?kqwAAqEG6F8F6pTmHykEIRzAgQCBAUCDwEBBoFnPIFZcBWDIlIZD44tFrole?=
 =?us-ascii?q?DwCBwsBAQMJjyaBfQEB?=
IronPort-PHdr: A9a23:ohrsWBVYUYcsWmcLVtqOZJ5ueVrV8K3PAWYlg6HPw5pUeailupP6M
 1Oav7NmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:pRk+la9lyRJFqCCiUNRKDrUDin+TJUtcMsCJ2f8bNWPcYEJGY0x3m
 mdMXG+PP//bYDCmKYojboTl9xkB6p6HydIxQVRqqH1EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E/rauW5xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qoyyHjEAX9gWMsazpEs/nrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kHNq4J3s94EFpQ2
 tdCcGgBXEGMisiPlefTpulE3qzPLeHxN48Z/3UlxjbDALN+EdbIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZP0An1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3Fa4KJI4DRFZ4J9qqej
 kyB7Xb6LAsVDvye4BiC/F6UmciWphquDer+E5X9rJaGmma7xWEJDhASEFmyp/iljVSlc8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BvRMGXddUO/M15RvLyafO5QudQG8eQVZpbN0gqd9zXjcx1
 3eXkN7zQz9iqruYTTSa7Lj8kN+pETIeIWlHYWoPShEIpoGz5ooylRnICN1kFcZZk+HIJN05+
 BjTxAAWjLQIhslN3KK+lW0rSRr1znQVZmbZPjnqY18=
IronPort-HdrOrdr: A9a23:ygZx7qh1pteOhjEmOa+E61qpu3BQX5V23DAbv31ZSRFFG/FwyP
 re/8jzhCWVtN9OYhAdcIi7Sde9qBPnmaKc4eEqTNGftXrdyRqVxeZZnMTfKlzbamHDH4FmpN
 1dmsRFebnN5B1B/LnHCWqDYpgdKbu8gd2VbI7lph8HI3AJGsRdBkVCe3qm+yZNNXB77O8CZe
 GhD7181kKdkBosH6OGL0hAddLu4/fMk5XrawMHARkI1Cmi5AnD1JfKVzKj8lM7ST1g/ZcOmF
 Kpr+X+3MqemsD+7iWZ+37Y7pxQltek4MBEHtawhs8cLSipohq0Zax6Mofy/AwdkaWK0hIHgd
 PMqxAvM4BY8HXKZFy4phPrxk3JzCsu0Xn/0lWV6EGT4vARBQhKSfapt7gpNicx2HBQ++2UF5
 g7mV5xgqAnSC8oWh6NvuQgGSsaznZc6kBS4dL7x0YvIrf2LoUh7LD2OChuYc099OWQ0vF9LM
 B+SM7b//pYalWccjTQuXRu2sWlWjApEg6BWVVqgL3f79F6pgEx86Ij/r1Wol4QsJYmD5VU7e
 XNNapl0LlIU88NdKp4QOMMW9G+BGDBSQ/FdDv6GyWrKIgXf3bW75Ln6rQ84++nPJQO0ZspgZ
 zEFFdVr3Q7dU7iAdCHmJdL7hfOSmOgWimF8LAV27Fp/rnnALb7OyyKT14j18OmvvUEG8XeH+
 2+PZpHasWTW1cG2bw5qDEWd6MiXUX2CvdlyOrTc2j+1/72Fg==
X-Talos-CUID: 9a23:qC1hZWycy5nZqiHnKtj3BgUlEeM0VlTS3UzODGTiUT5leuyaRHWprfY=
X-Talos-MUID: 9a23:fk2T3QqYuvdBKVnreggezx8lJtVrzb6hMmAMuLcBteW8KgspAA7I2Q==
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-08.cisco.com ([173.37.255.145])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 19:05:40 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-08.cisco.com (Postfix) with ESMTPS id 7BE41180001EB;
	Wed,  8 Jan 2025 19:05:40 +0000 (GMT)
X-CSE-ConnectionGUID: cjP2yXYDSkWzKmCNurd5dw==
X-CSE-MsgGUID: kYYOH6d2T1Ca/wRPrhWOZg==
Authentication-Results: rcdn-opgw-2.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,299,1728950400"; 
   d="scan'208";a="25984259"
Received: from mail-bn7nam10lp2042.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.42])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 19:05:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OINxsJ9pc75g/r+sd0RIdCioMO6QOXGK+dhKrTJrYTenZ3XTxoNgfYPSL6az4PYu0m28keaySxBDAIzWk1e4E69eshuu+S1EE1rY99pfrXLl3XXSB2MH+6K0kuHX+xG/BjhE12d4olKOkdY1yocQevUU1OJ2o/BmMvA+ML6j+5VMcJeitYaRAK3PUljhcB33G8jTBnmIHQzj9SBLWycACDm7CyVccFwHqfF9l6b4+rCh44Q9VANgGm/JQDQ6vgVmmGbLz3zjHWn36jtslfFiF/dfmaaVtzAI5u4fxeErzCa1xqMHWvsbOvb2NK1DkNFwrwBtCP0yoa4j/gZtRZO8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13LrOLVzIroVxboGWE/WrU+C1sGpS2TIGxQNgYGCN1o=;
 b=P4hwK0/Vf73SZq0T2q76ISBu2OBUmt1L5qvhXyphR0ZPR1HSc11Iba5ftOQAy+4pUZDOXOELlAby8WELhsNfxjQZbsPViPapQo3D7I59qqfzAWifxwl3kEs+0BKLouL/71zqxImmQCBXPT1rKLAxeunHAdTG084pBd84OZkrHrPIEUi+VskgvUvvpNL9F98tgc2vWkZ3cislO/6ABd/H+XibIGUAvwnkOPcjeX3njQ7vn8gR9Jd6LoDUR+6o4mpAuuyGJ+DtaaNRKE0b0nsdxbANi32oodyM6kU5pLZ6PYbEwI8uOlZtET5VtIEmjcrTVcbSOfhY26lyDwjVRENaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by PH7PR11MB7596.namprd11.prod.outlook.com (2603:10b6:510:27e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 19:05:38 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 19:05:38 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Satish Kharat (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "Arulprabhu Ponnusamy (arulponn)"
	<arulponn@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Arun
 Easi (aeasi)" <aeasi@cisco.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH next] scsi: fnic: silence uninitialized variable warning
Thread-Topic: [PATCH next] scsi: fnic: silence uninitialized variable warning
Thread-Index: AQHbYa4BopBThgZK1keY0N/QXoQBDbMNPLrg
Date: Wed, 8 Jan 2025 19:05:37 +0000
Message-ID:
 <SJ0PR11MB5896580318AA84057145A0CAC3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <99df3555-6763-4870-9af3-fbfa4fbd5268@stanley.mountain>
In-Reply-To: <99df3555-6763-4870-9af3-fbfa4fbd5268@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|PH7PR11MB7596:EE_
x-ms-office365-filtering-correlation-id: 9fc92aa2-4161-4663-5cb1-08dd30177018
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Vts3+An1499Zm+D7jPxt8ampl1a/r4YX36ax021NU0MziKk2vusz5iuP+6Bt?=
 =?us-ascii?Q?7w++yBuRfNLCd4gCeF94ZDtapPgww+SYdT8aI2AqyMFsvHTuEYM8Q4byjYEc?=
 =?us-ascii?Q?Mz1+P3S3+v8WStGXTDQE6V4/gCJ53qwsqMWtuUXXaqAwCioym2SYRLP/EfZV?=
 =?us-ascii?Q?xrT7YAOoEBBafJNbVKiyORxgKTleJipr+EJiBYZYZmSutqcmRpZES/Isoqni?=
 =?us-ascii?Q?SdnagPtrvp2zAE18BjdYxC5V1vg3+uv5Fedd2rqKSSCzWlWXEONowyr+im8e?=
 =?us-ascii?Q?oVTuUQrKVR/Ng0KewcJDkwOSqljT1QD0JaIj8k6Gi67SN6mrNtyKHhLi17eG?=
 =?us-ascii?Q?9ABlBvqVqz63SSsqSROk1bwOmtJLg2nq7j70lWdnDCex/rM2ppF9kO1toa71?=
 =?us-ascii?Q?9Vv/nza3/qt1auKJj8eaNIyGQEJIDT3B/DF+Gr5AKRrO4/wCcIPO789HQokB?=
 =?us-ascii?Q?xDovTYiBtlhRswhrM921WQuF5bajr5qpvioudwC93TQXnAQ8QJ0WRvH3JYAy?=
 =?us-ascii?Q?GkCugrGbLRrs4cDElLAcSdqSes1RKOntjsE+6ykVKXGTuir2xu7VCj0z79ux?=
 =?us-ascii?Q?BzLsAeAzOepaB59zKaV60yn9oTngBkl2xEwQeA4afTk4ghiOky9M+ZU+I5tt?=
 =?us-ascii?Q?nrjB+LFmnLSdwteUPEWvkhbxsRFV1D3yN5bnxyn/vac3DyRtBZTGsGkOdeXC?=
 =?us-ascii?Q?JLbVTQH9wLdwczINaLWQBSEy5q6f99tTekOHJ+fa9BB1tb3i4xG6U8Jbi4WS?=
 =?us-ascii?Q?bzbWXgMTaN0w54wDCDDoIt59ReCXZFZ5di60T25A0FomEALMGFunhKmRLBdf?=
 =?us-ascii?Q?SA5pKC/JKkeZVgmTIv49za+bZ7zP6pcJ1BjsH83C76Mzy79PfoXdjvFJuq0y?=
 =?us-ascii?Q?bUbcWf9dO/YOR68j+0BTi3pe2zdrfnLJKyosfk4/g9oDCm8fdAidTDxI5KRt?=
 =?us-ascii?Q?KDT4qye6EX3Qafr2/qAWubS22Q6NwwwQF5EIMkf4/0XM+fP/DtbnMCKAb0Cl?=
 =?us-ascii?Q?JkR/5Vcak/zBtADX+bqs8qATbxRzuPUIospxOiI1sv+COcKdngZ5A8sew2AV?=
 =?us-ascii?Q?ELwDMAyfAkWocb/+q595f+RKW8d/yhORhwG/AJwc2qNxeIjt5RyjgcQElDuF?=
 =?us-ascii?Q?ZDXIuCryPYGAXrFEmjhJRYj+essnGFq9alEQcCaueGeH6ogWYQDujwMtCn0N?=
 =?us-ascii?Q?JgLR9DWdiU0jw0T6Fqkn6pnLwo0S1VX2/y6ecS4xi+vBOu1w7eF98U8ezNnd?=
 =?us-ascii?Q?LQWR1Hghb3BU+EB+RsVVyHTH+9J2DEAxzyJ8LMGk7DxhD6GNjPNCzZG6cz1o?=
 =?us-ascii?Q?WEgYlilIdENl0EgTPiLn4jH+yWGuNikzBvbzv4InYoigtyzqIyF9ZGRFk6qu?=
 =?us-ascii?Q?t0As3yU5uUOi64UuUd9VcMQp7ZYBOm35eZrvUBxmKYZhUk4Lp0AZWEEgJcMk?=
 =?us-ascii?Q?CUzRjp3UuBMtLRiREUAa8CMAF3RwzFkg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Kh/Tbc7CFEp54Jw+h2IIVzhMYjHeVWyoI3pB2bcnOYJbkD58kHgpO3x12VDo?=
 =?us-ascii?Q?q12RwRrJ5tvnBeaxMXGGmhEHn36+z0zeYk4xibHT819LhEkb4I2/FBPMOeUi?=
 =?us-ascii?Q?bRx2XU41VLaocICGHKdpboW0cnq9rbELjZluxbQnEHItfpZ2nWtBrhiDOrjP?=
 =?us-ascii?Q?Gd2Fr8PCqw66mWNE3MJVRMCQi99NEW7FE95hxsy3HJ9clTc1MtRHXksKVHyG?=
 =?us-ascii?Q?Bz6ICfTNMCKoIKFvDB6Zcdge+jnk+hVuERIi8WpHSm4+BVbASHbPLRZxHeZh?=
 =?us-ascii?Q?UqiN68vB88Rig142UTSn5iTCuM1vuyVPsFqMnb8O8W4ScxSphUh4tr9bh/ng?=
 =?us-ascii?Q?4ev1y+RvUBBI1nkW3zy5J2CDB8XKUgf+wfPnGwrkd4AOlmTUKC+Iv1L1iT79?=
 =?us-ascii?Q?vS7yENj3eqm24udQBelk28dgokn84fJFi1NnAnSYkNxEETdcmWSCrj0YDLJe?=
 =?us-ascii?Q?R/PJSbSAEuf8725465DK6df1BVtO55a4LId7kbBQ+m5id+PK86+vMGA5cszv?=
 =?us-ascii?Q?C272BpKKfutSKRdrVgDV/8obeOALBmU07vpu9luuqJiEYI2PfMLgBmKJQD+/?=
 =?us-ascii?Q?itYu+AmWOQpEJxrFN60w5Rh4F3ePtHwvLpeiQslwqb/dCD6rc3inlISFiGdY?=
 =?us-ascii?Q?oMf9Z15iALw67RQDKtMfGWeQWGVko1tG9dQCChl2XA7oRoBWMb/YjKaQ1SPx?=
 =?us-ascii?Q?RXPhRY1qAwLkUoBZpJuSgSi54jXC3Ms+6Io8SkMxmkUjONVR1W1ahS6l0bZ5?=
 =?us-ascii?Q?Hr5lxT6lEgQ2XwpNV49kYEWZsN/bbVKofWisdKXKNh4CDa7QXGxyYtVYV0wp?=
 =?us-ascii?Q?6M4MDqBIUrWknQgkV3wan1ieuVRaenZjSbUm0pJpsCL86FaJvZqG3f5FYHh5?=
 =?us-ascii?Q?6lU8YEhBheRr4aCoXUUjNwBqvKr0jL2CudfTy3L2HOpbAvYUenttrLE5aTAS?=
 =?us-ascii?Q?aNvJ4W3yqf2G3bHcU/Q0zfhVGpT84qFucHh968HfyCNF9Pos6Cl8bMHZJvRu?=
 =?us-ascii?Q?WRaV2M0XA+zCFpieVigf2h89hL4KeJOiPTRlLny6zqMUZufdJ97J9D6sPQlP?=
 =?us-ascii?Q?TgAViioVtYWc8N9aLo2fhbVdN7sPhiDDg5seP7aYTRI7Yz1Ga2WDtOhed04A?=
 =?us-ascii?Q?aadk7hCpYhthdQ1quTME5B4ZO/4byYhyPxVoCKQ+mZwRae9w4HXzHvl0LOtj?=
 =?us-ascii?Q?NOsHuN8rvWaMNu95MySca5jDsFvRMO8a3wJXdwVEjSjIKBCsBLMakmqmcgF9?=
 =?us-ascii?Q?p2Y8f+B/ME9jB9fuZjgZbO0eGO636XQbJrOmOW7O0UDHmz9yX8hDresOpt5p?=
 =?us-ascii?Q?PbSR9y4cJFqcMmhqDsUbF51vjkTqPYGePxgofuT/ejSL1uebhJI1JVxJZO1M?=
 =?us-ascii?Q?fPAqW1uA3Hmm8QPL99tLOqFEMHcdfAREKuWpkJ8NewssHw8YC36AcZKcTBRv?=
 =?us-ascii?Q?K21sGKCY8tMrW5SJn2PxxoyUoDtTlsUYNbkSUltTndF8oHYphEuAAIaV0911?=
 =?us-ascii?Q?6X7DH+LMNcKUykDEVom8OxlrIlC0aaZrU/FKy5Pyw3EnXWUMXrY3FFlFNshr?=
 =?us-ascii?Q?DwnKpWsXcvza2XN/imbvfFusgGYRfyuB5w0WqXzhtxN8TUCFZLIOCUPZXEr6?=
 =?us-ascii?Q?bWS02oBWnAKOiqnQ0zvxN+Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc92aa2-4161-4663-5cb1-08dd30177018
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 19:05:37.9278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sYxEVlqZmufufPYEabeuXI6PnTGslPl4FptNu5QuZe04WcI4fLIS+pCVodThLGpeLR22dI+CgZHHrQvtQqP4yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: rcdn-l-core-08.cisco.com

On Wednesday, January 8, 2025 1:16 AM, Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> The debug code prints "oxid" but it isn't always initialized.
>
> Fixes: f828af44b8dd ("scsi: fnic: Add support for unsolicited requests an=
d responses")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> drivers/scsi/fnic/fdls_disc.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.=
c
> index 2534af2fff53..7928f94d3202 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -3904,7 +3904,7 @@ fdls_process_abts_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
> uint8_t *frame;
> struct fc_std_abts_ba_acc *pba_acc;
> uint32_t nport_id;
> -     uint16_t oxid;
> +     uint16_t oxid =3D 0;
> struct fnic_tport_s *tport;
> struct fnic *fnic =3D iport->fnic;
> uint16_t frame_size =3D FNIC_ETH_FCOE_HDRS_OFFSET +
> --
> 2.45.2
>
>

The change look good. Thanks!
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
