Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66274391E4B;
	Mon, 27 Jul 2026 08:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785140750; cv=fail; b=NxnTQ9uk8+xw+7fA3Ij9uhc2kOoBtSKaQ80i5Xl+GnRpysFS38SZ3F0deH7TPP6x+DpE2IH4YSRdy0y/Pul5ZmKEQSVWTojzME6PL06x0Sj45RZYTqU3ACJxN8PpsnkFjOs8m1AvZUymbLu1IYqhGfTkyzmj86pbpvGKQ7x+odM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785140750; c=relaxed/simple;
	bh=qG4f1HQABymK1HtUPLS1cA7Xkvo8LVk4BtYC3qTegFM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ncCiUF2Y6VZmCaVG1Ohiwe1B9Euj7CCPjRqa9NiiNg7s7repA8NUMb8rRJ/AcEa9HPaqYYbB1UTyusvQ/a/3sn/QZweapwwBP2i5vvSlvbrmWC3nL4to/ZkZlxD6DRwhv82M4gDrJlyDQYk+X8rfyUAId2RyQhvfy3Qsg/Z+CL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=JmEdly8R; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="JmEdly8R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=9019; q=dns/txt;
  s=iport01; t=1785140748; x=1786350348;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JHBbgwps/3ZM6gnJO9Zv88tgVRGASYUADoRkEjeH5OE=;
  b=JmEdly8RSkSprUhudE7MNz22hfha6kJdTLwquAyqQtQfj+cfDKIiY4Nj
   2YLZKi2+X/uvQa48VJiIW2Pzor3m5rCIcIswYtSSTz1UZ2Gf9xxEXzOoD
   r324a5GvHTHon8fypy7FD/4MZLPLjDq8ojlOLyuh5+pgAC0BPpgHmUtDS
   eF0tcsCW8FtknpvOI+IAhTJjUSIAneGsSnAOPJ43H4HjYUHuf69ZAnh9O
   Rpm3tVHeUYePrzQGZOeo6M68zYFCGc0jUVGbAn1AaYDRTVC51FKQ3ZV1j
   LyO9boa2mn7x1IRtuNFnjtpEO3SYKXJoWOSql/dBX2vFlD4he9pIXWL1s
   g==;
X-CSE-ConnectionGUID: 7sQ8GyhlRhC9aUciik82Vw==
X-CSE-MsgGUID: oTQyrBFwTuqmmLIFVNenAQ==
X-IPAS-Result: =?us-ascii?q?A0ADAAAmFWdq/4sQJK1aGQEBAQEBAQEBAQEBAQEBAQEBA?=
 =?us-ascii?q?RIBAQEBAQEBAQEBAQFlgRcEAQEBAQELAYFtU4IrGQEBLogjA4RMX4ZYgiEDg?=
 =?us-ascii?q?ROQN4xRFIFqDwEBAQ0CUQQBAYUFAo1gAiY0CQ4BAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QEKAQEFAQEBAgEHBYEOE4ZchloBAQEBAxIoPxACAQgYFgEHEDElAgQBDQUIG?=
 =?us-ascii?q?oJhgnQDAQK4QQGBPQKKKniBNIEB4DcVgTgBiFsBhXcbhGEnG4INgRVCgjE4P?=
 =?us-ascii?q?oFSgjgRDxtGAoNLgjAEgiKBDIJITYFOYox7UngcA1ksAVUTFwsHBYEjQwOBB?=
 =?us-ascii?q?iNLBS0dgSMhHRcWHlgbBwUSICpBRSMDQTY4C0MFgVcCgXg/Ix8DOX+BL3VKd?=
 =?us-ascii?q?y1pAQIQF0o4JINLAoFQAwttPTcUGQMEgTUFjW0jgU5SGQcBBg8bJywLBwwSC?=
 =?us-ascii?q?x0uBAIveBYBHhySbx0HAQIRgxqMcoNWikOVFwqEHZouh2MXqmyZCCOjTxgPg?=
 =?us-ascii?q?SuDVAIEAgQFAhABAQaBaDyBWXAVgVkJgUBTGQ+OLRbPAHk9AQEHAgcOAwuBa?=
 =?us-ascii?q?JAAAQEmB4FPAQE?=
IronPort-PHdr: A9a23:hSkBbBG/2xlbDg8RSceXQJ1GfhMY04WdBeZdwpMjj7QLdbys4NG+e
 kfe/v5qylTOWNaT5/FFjr/Ourv7ESwb4JmHuWwfapEESRIfiMsXkgBhSM6IAEH2NrjrOgQxH
 d9JUxlu+HTTDA==
IronPort-Data: A9a23:xoiG/K816dcghFP6NsLlDrUD6H+TJUtcMsCJ2f8bNWPcYEJGY0x3z
 mEYXzzSP/yON2uje9B/Oorn80JQ78eBmtRmGlA/qCxEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmB4E/rbeSxxZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mvyyHjEAX9gWAsbThLs/vrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2lpJrRI1fd3BVtO3
 q0RFTsMbxPT3dyplefTpulE3qzPLeHiOIcZ/3UlxjbDALN+G9bIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2bMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC9aIeJI4zbGJU9ckCwo
 V7/7n7TLA4mKcWazB6k3EyKi+nmpHauMG4VPPjinhJwu3WXx2oOGFgVWEG9rP2RlEGzQZRcJ
 lYS9y5oqrI9nGSvT9/gT1ijq2WFlgATVsAWEOAg7gyJjK3O7G6k6nMsRzpFbpki8cQxXzFvj
 gXPlNLyDjspu7qQIZ6AyoqpQfqJEXF9BUcJZDQPSk0O5NyLnW35pkunogpLeEJtsuDIJA==
IronPort-HdrOrdr: A9a23:pB57sqMMJhleGcBcT87255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUbbUQqTXc1fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBZHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1ybxp/hZsy+2
 nMlAL0op6kr+y6zRHk0WrS5YR9mdfqyNdPbfb8y/T9LA+Cti+YIKBaH5GStjE8p++irHwwls
 PXnhsmN8Nvr1vMY2Ccu3LWqkrd+Qdrz0Wn5U6TgHPlr8C8bik9EdB9iYVQdQacw1Y8vet7zL
 lA0wuixthq5FL77WHADurzJlZXf3mP0DwfeCko/iViuL4lGftsREokjRto+dk7bXnHAcscYZ
 lT5YnnlYVrmBWhHjDkl1gq5sCwVXIuGRrDaE0DtsuJlwVyphlCvhElLAh1pAZdyHr7IKM0ut
 jsI+BmkqpDQdQRar84DOAdQdGvAmiIWh7UNnmOSG6XX53vFki94qIf2o9FrN2CadgN1t8/iZ
 7BWFRXuSo7fF/vE9SH2NlO/grWSGuwUDzxwoUGjqIJ94HUVf7uK2mOWVoum8yvr7EWBdDaQe
 +6PNZTD+X4JWXjFI5V10n1WoVUK3MZTMoJ0+xLEW6ms4bOMMnnp+bbePHcKP7kFislQHr2Bj
 8ZUD36NKx7nzaWs7/D8W/ssl/WCzjCFMhLYdrnFsAouf0wCrE=
X-Talos-CUID: 9a23:RXQ6PWN9a0NbSO5DBzJepGEFGsQfclaMxUrbIk67WTxXV+jA
X-Talos-MUID: =?us-ascii?q?9a23=3ARXHkCw6K88SZfWYxW6TZJ3rjxoxv352/Emojjqk?=
 =?us-ascii?q?bosyBEQ1eBRGQih2OF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Jul 2026 08:25:41 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPS id EF0F218000153;
	Mon, 27 Jul 2026 08:25:40 +0000 (GMT)
X-CSE-ConnectionGUID: kSCUIH0WSou1ZBQq7NIulQ==
X-CSE-MsgGUID: 06m2250KTN2O13jtPLCsGA==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,188,1779148800"; 
   d="scan'208";a="81868140"
Received: from mail-westus3azon11011049.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.49])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 Jul 2026 08:25:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QxbnSq4ASG7o5InUMIJbiCIbzXJm93s7iCbL6BoN0hw/f9K7bApBLGcz/8cnbO7z4rdh9yWr/iCj9nUnnu3GbpCYG0mSlhY/PgH0s5osLMLUSVII3NMhWnu+BEyn8L6nXCGvHL8hN0bbu5jofwzdNZfgz+VOR389KennMaTh5jVbwUR/ggOyHxAmkZpnxr2k3saow4HitqcEUbGOQ8ZVxM8bMxZbSgS5ndEFg+TEbji0jzY1CrMC1KQ7DqWbgEqQAt9DedKbiA7PKzA3e0eMn90tIoHgIK+yXA6ozMtjYWlT6RaEZWojZbwo6yHJwVLxlthSXrqP9smP33c5S+c8Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHBbgwps/3ZM6gnJO9Zv88tgVRGASYUADoRkEjeH5OE=;
 b=S6w8LTpPV0D1ZbxqMfAMU7J1NcLRANrH/SrKHM4ILn9o0Ei7YkYkxmr1hgBBqQKKrNU9u5Mb+niM0EGM5JGndofXGXhvupcxV1NNEB9PeWw8cHdkoRfrcCuy/h+aCMOt6vLAsIB4+hqcCO76oNsN8siREBRQxibKTOYGbnvLgCDF0l3BiAxBAVoUm4QocUDCahYtatMvZKJ+R9W7n1t9Nd0/aBWlapEOVVJY99X0lKYz0BP6IGiPqIn712k3e9F5HtcsLZdsDws+YuOQP4eafBoq45NQ0JoxhsaQ4RM4QRc/U/rjnl6W8uTis2POOWNDY4dbxpkr5Lq1wul8QMdi/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CH0PR11MB5314.namprd11.prod.outlook.com (2603:10b6:610:bd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 08:25:38 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 08:25:37 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>
CC: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar
 (djhawar)" <djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)"
	<gcboffa@cisco.com>, "Masa Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
	"revers@redhat.com" <revers@redhat.com>, "adakopou@redhat.com"
	<adakopou@redhat.com>, "lduncan@suse.com" <lduncan@suse.com>
Subject: RE: [PATCH v6 00/13] Introduce functionality for NVMe initiator
Thread-Topic: [PATCH v6 00/13] Introduce functionality for NVMe initiator
Thread-Index: AQHdG5St9X+V3aS3MU29IE2vrSAyxbaBCghg
Date: Mon, 27 Jul 2026 08:25:37 +0000
Message-ID:
 <SJ0PR11MB58965463469EC861205623E0C3CC2@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
In-Reply-To: <20260724174811.5118-1-kartilak@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CH0PR11MB5314:EE_
x-ms-office365-filtering-correlation-id: f56d28e5-b095-467d-4400-08deebb8a30e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003|3023799007|38070700021;
x-microsoft-antispam-message-info:
 7/eeXgu0fd3BZb/m1TZgB24b1eDGmKxmLDyGYlEd180/3nzx2VNd6kHdKcmEg+3QtkR4AcMc7gJF5L9IWUQmEA3AeG9HRfvVuXJw1mekz9B92J8awF4ex/ozhjoI3roGCp3LUlCi4VC1q9tcf9CdKUIibDcIWdvYUJ1K5IoEadzb7LWwAAHVOKt1jFlN7IP2ZQWxbnJwP/9LmLsNSXemiKYUK1OfdY8kAq2d7SAJys070c57zdfZv49TRZyCELyN5z+B2AgE1Ii7JRAajwNkvVh9od1owbEUxq0bVGgyrDX1157MnxFMHaQ2OaqkqQadFjbBGznQnAGoVanReky2inUAhOVKoSuMUYTrWAUdXyMUO3NTvHajPdlNoh/FXxIQNhau9O1QX+IgsEWExgah6FZvOZwK2X5Uq8duIDaXj+wfGna2XUChYw5p1xw0xygBUhFaBPMPmVQTOGIJB1OJ7RXvD7F31shEhdeVVbbBSnw90CGBe9opK2qH3jdcPj3eByZgf3cPaQTs2SISQim/NOTcYYW5KvuN7Vx1nyJL1nIEL1MtfX/079+k4GinH4GasqQy5jT/G0RitcP3r9NtoaiA7KXEBHwWnZ8/aJH75IQSIpa1aI1BteX8MTfT7HeR7wQLrKoe2K20SJAB+8nvDm616YJEIURc1vPo6CQ4m2lEFvM+/iOBMIMf6t6zU0I1hpI212XD03NEpKGZ5cjp3PxjkpbYH7tKQeviSaeGcU4=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(3023799007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4eEU4Mzvb53RFssdYYC6AL9IS6G4bgtKtfmngw/xKVrLbjSRe/zDHYyCBbB8?=
 =?us-ascii?Q?SaDEHVxr9y/l/+quVFeg7CRIXPPOqyNnwSNAZE/TMokR2MT8izcBbspVNqFI?=
 =?us-ascii?Q?67caD74ScRglaKtpkfvgSUqLJ8tLnlX8Hdt/I/bGsMB5uemYyrnSJq6c/9/D?=
 =?us-ascii?Q?pu6STz+jpmOOU7rbGX8Ieo+7osQgH/xYa4zAA1PxzeCYJxKFnwperrGTFcJ7?=
 =?us-ascii?Q?mnB97VKbRl5deVZO4sOKZUTJsB4ei3hVr0P8fOwAdcoLuPSL9CrthuXpTLWj?=
 =?us-ascii?Q?FT43L3sdiJoz7T7Ui0DfcPdM/4cPZDEzwELuBsg6Z+DSX85TctAVVErwBvrK?=
 =?us-ascii?Q?eUqeLHrabbRKQKBMulc73/yTe4b6m4aT+sqLvM8fcXiTsyR2TiAeVXJTR2T2?=
 =?us-ascii?Q?jNXO0DInsoF8r5nm7Ju4d9qti/oVQwm2OCWKJU2JJNpu61/S13vAw5ahADbU?=
 =?us-ascii?Q?f+dSOOM1qvX3wSYyaNkboiBtp5tOWcP0TA1vg1cS13+bnONF7otlCChDSZ8s?=
 =?us-ascii?Q?06sZLNBRWer6qyBZs67SVNstaZez6PpAT1ZJxGadqryS+mF0Mfl8EtP7xM6H?=
 =?us-ascii?Q?8arfScbsvHetBW2x2ru5khng15UDqNrlkzFcuYnCUP+FJwUugJhYaNYo/WDs?=
 =?us-ascii?Q?z6EjZ9FRMLD+9ZNhAz9f0Ywxw4RVAHheq50st5o1tDCSfzuoNmd7xDXWp5DW?=
 =?us-ascii?Q?XdWk+TeoIoIFNtqSz4Ou561AlzwPdDg43MeOVob4g6makIgt8tX7cAjSXrL3?=
 =?us-ascii?Q?lBoE7NbpjBHNxi4W/+/x68WWK0/nCA62GRb/OrdiEKUmYLWfbSkk/JCkj/mB?=
 =?us-ascii?Q?QkN4QLa12SFrvtTb23xbzaIGrS9+MXj6ZoprDUzOInx7y6FCW+7QawEFhLBr?=
 =?us-ascii?Q?I/rdwidZRft3XuZHr9YghHkaAdCwrQX9A/Wbo6Jvc2nieKYaCEIkmJuQvcaD?=
 =?us-ascii?Q?kCC+DRB74C+PsROuuvLy72oQY6ciPvPx8RgFB8LhQWKDpiai6eonolmgdBuB?=
 =?us-ascii?Q?HtBtBdHuB1X/G/yZtmCdfIL3taDvF1fcqHlej1MilbtbeSWwTLe/5qbXHUvu?=
 =?us-ascii?Q?3EUTfOk8notxqRBb+bpTWk6huXsNoTa0dCdDBHN+5FwFVM+SZoOpBwfujpjd?=
 =?us-ascii?Q?18Pml3Y+70vngygB7LUhyYEvM9jamp4IZ+W/21V7C0gEk2rb9xMz8Yio2vR4?=
 =?us-ascii?Q?BmUcpJ0ttUTrmKPocsgcrcorguNM+RSSqKVal8jJyqkI6O0I5BHIzfg/VzqT?=
 =?us-ascii?Q?+e5WjONKjafllIbD1RkQS1l+Txo6pCQyidQOB88jC05Yc4Xy0XwIUQq5ASMq?=
 =?us-ascii?Q?5/Xlclz5uGyKhO0aw+r4Yw68BN9H+sX189bpPHnr46eyv5oro4DaCLPikRHl?=
 =?us-ascii?Q?42VRXK2O+LN0cUK5LGnOz2PUT81JpdycWohqm3Uxbuu6ZiA0RCihAp464pWU?=
 =?us-ascii?Q?Cl1Jec1kO0cGkUEpvfQ6QVTDgvPhQBapv1BhUbvQ641B5BzzipKQRRyfGo2q?=
 =?us-ascii?Q?ptkeIuxrM/pb8IC2kXzsaSn7RB7jjDT66Pr3sze67GuZTwvHg3RBnmBcb+uP?=
 =?us-ascii?Q?jUfFRuyhGqu9epqaLBrrp6QIgQMEeGdZKzN5oEYo847s/zNGNjKjsj77EtkV?=
 =?us-ascii?Q?Q0LLw3DuVxLi6SUTfxA7A0d/vrYlv/LD4x7vsetfMV6PmD/wnpCFMuo9Me3e?=
 =?us-ascii?Q?+YqlXLVROwEflq4l23wQmnsXH+8Itua+54AMiz+4BtH05Hay?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mKTPRpXqrzo6+bdhBVaYPQ2f/6V7ftZsrmu4vremhDHNNeN7yY2IRPndRFKvf67PDi2FdakaUdorozvoCfgnHGoQc3cqfK37patM77y9qRWncIKnLyNEdrYQ0oYf0wXxKHOYTE2dlBi/BVlvb5w7buQrRV9N9sidqnbtfprp/O6dr1ySuKeGg7WxpJbgMoj7dlEblyVNCPapysrfazxwvV32xIo4ks4QfSMmlO9648V8D+IAgSMuAF8/y5jxGKZLHkkkE7uRu094Zdv++ASEOL12h0iVwT0Dx0FC9fcRCphIUaOhZ3evbaP9ZyT3mVwbZh2heLuP8Yp4VWZniw1tWA==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56d28e5-b095-467d-4400-08deebb8a30e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2026 08:25:37.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6CqHwEpF6Q/P8CEYr4pK/aTWG85y3Ksu3OwpoFgVOwUdE6OkXOblRZtQNbrPTd52PJiUHTcfIsAl0N57ldyNrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5314
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-4.cisco.com [173.37.147.252];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-02.cisco.com

On Friday, July 24, 2026 11:18 PM, Karan Tilak Kumar <kartilak@cisco.com> w=
rote:
>
> Hi Martin, reviewers,
>
> This series adds functionality for NVMe initiator to the fnic driver.
>
> The changes enable the fnic driver to act as an NVMe initiator over
> Fibre Channel (FC-NVMe), allowing the host to discover and communicate
> with NVMe targets using the existing fnic infrastructure. The patches
> prepare the driver for full FC-NVMe initiator operation while
> maintaining existing SCSI/FC functionality.
>
> These are some of the salient patches:
>
> o. Make fnic debug logging usable by SCSI and NVMe initiator roles.
> o. Use fnic instance numbers for non-SCSI-facing identifiers.
> o. Decode firmware roles for FCP, NVMe, and unsupported targets.
> o. Advertise NVMe initiator service parameters during FC discovery.
> o. Add FDLS role handling for NVMe initiator discovery flows.
> o. Add the NVMe/FC transport path and port registration.
> o. Route completions, resets, and LS frames by initiator role.
> o. Add NVMe LS timeouts, statistics, and debugfs state reporting.
>
> Even though the patches have been made into a series, some patches are
> heavier than others. But, every effort has been made to keep the
> purpose of each patch as a single-purpose, and to compile cleanly.
> All the individual patches compile cleanly. The compiler used is GCC
> 14.2.
>
> This patch set has been tested as a whole. Therefore, the tested-by
> fields have been added only to one patch in the set.
> I've refrained from adding tested-by to most of the patches, so as to
> not mislead the reviewer/reader.
>
> A brief note on the unit tests:
>
> o. Configure multipathing, and run link flaps on single link. IOs drop
> briefly, but pick up as expected.
> o. Configure multipathing, and run link flaps on two links, with a 30
> second delay in between. IOs drop briefly, but pick up as expected.
> o. Repeat the above tests with 1 queue and 64 queues.
> o. Perform tests with Netapp and Pure targets.
>
> All tests were successful.
>
> This set of patches was reviewed before submitting upstream,
> and the following review comments were incorporated.
>
> Incorporate review comments from Hannes Reinecke:
>
> Decode target roles explicitly and report unsupported roles.
> Remove the empty line before the FLOGI completion else block.
> Add a short comment for the NVMe ERSP completion case.
>
> Incorporate review comments from Lee Duncan:
>
> Replace the NVMe LS OXID switch with a direct frame-type check.
> Rename the NVMe frame helper to follow fnic function naming style.
> Convert the NVMe opcode stats helper to a switch statement.
> Share NVMe completion stats accounting and compute duration once.
>
> Changes between v1 and v2:
> Incorporate review comments from Marco Crivellari:
> Explicitly use WQ_PERCPU for the fnic completion workqueue.
>
> Changes between v2 and v3:
> Fix issues reported by kernel bot.
> Add the active OXID to the tport timeout debug print.
> Guard NVMe I/O and LS request debug logs when tport is NULL.
> Validate ERSP response length before copying the response.
> Validate LS response frame and payload lengths before copying.
> Limit nvmef_info debugfs output to the allocated buffer.
>
> Changes between v3 and v4:
> Incorporate review comments from Sashiko:
> Keep role strings private and const.
> Clear NVMe SGL DMA address on map failure.
> Drop fnic lock around NVMe tport registration.
> Unlink unregistered NVMe tports before freeing them.
> Clear NVMe unload completion pointer on exit.
> Take fnic lock before NVMe tport cleanup tag lookup.
> Clear NVMe tport delete completion pointer on unregister failure.
> Arm NVMe LS request timer before exposing the request.
> Free LS ABTS frame when send fails.
> Reuse NVMe LS request cleanup for abort failure.
> Decrement NVMe completion wait queue counter when draining completions.
> Preserve jiffies wrap when computing NVMe abort stats.
>
> Changes between v4 and v5:
> Incorporate review comments from Sashiko:
> Set NVMe wait timestamp before queueing completions
> Use async timer delete for NVMe LS responses
> Complete failed NVMe ITMF aborts
> Track NVMe SGL DMA mapping state
> Detach NVMe LS cleanup before callbacks
> Defer NVMe table frees until cleanup
> Lock NVMe tport IO termination lookup
> Count NVMe ERSP completions as firmware completions
> Gate NVMe completions by initiator role
> Check cleaned buffers before dereferencing them
> Drain OXID reclaim state on reset
> Avoid NVMe LS request send races
> Arm NVMe LS abort timer after send succeeds
> Clean up NVMe debugfs on probe errors
> Clarify that FC-NVMe PRLI must not set Establish Image Pair.
>
> Changes between v5 and v6:
> Synchronize the tport retry timer before remote-port delete completes.
> Avoid requeueing FDLS tport delete from the NVMe remote-port callback.
> Drop the unnecessary else after the tport delete timeout return.
> Name the tport cleanup retry limit instead of using a literal.
> Publish can-free before completion and set cleanup-pending on timeout.
> Incorporate review comments from Sashiko:
> Flush NVMe completions after copy WQ cleanup
> Reset NVMe SGL state before each I/O
> Claim tport I/O before aborting it
> Synchronize LS response timer before done
> Preserve LS requests during abort start
> Drain LS requests on rport unregister failure
> Defer tport free after rport timeout
> Avoid extra PCI device reference for lport
>
> Thanks,
> Karan
> Karan Tilak Kumar (13):
> scsi: fnic: Make debug logging protocol independent
> scsi: fnic: Use fnic_num for non-SCSI identifiers
> scsi: fnic: Decode firmware role configuration
> scsi: fnic: Advertise NVMe initiator service parameters
> scsi: fnic: Add FDLS role handling for NVMe initiators
> scsi: fnic: Add the NVMe/FC transport path
> scsi: fnic: Route completions and resets by initiator role
> scsi: fnic: Handle NVMe LS frames in FDLS
> scsi: fnic: Send NVMe LS requests through FDLS
> scsi: fnic: Abort timed-out NVMe LS requests
> scsi: fnic: Track NVMe transport statistics
> scsi: fnic: Expose NVMe transport state in debugfs
> scsi: fnic: Bump up version number
>
> drivers/scsi/fnic/Makefile       |    1 +
> drivers/scsi/fnic/fcpio.h        |   35 +
> drivers/scsi/fnic/fdls_disc.c    |  978 +++++++------
> drivers/scsi/fnic/fdls_fc.h      |    7 +
> drivers/scsi/fnic/fip.c          |  117 +-
> drivers/scsi/fnic/fip.h          |    2 +-
> drivers/scsi/fnic/fnic.h         |  104 +-
> drivers/scsi/fnic/fnic_debugfs.c |   99 +-
> drivers/scsi/fnic/fnic_fcs.c     |  199 +--
> drivers/scsi/fnic/fnic_fdls.h    |   48 +-
> drivers/scsi/fnic/fnic_io.h      |   24 +-
> drivers/scsi/fnic/fnic_isr.c     |   28 +-
> drivers/scsi/fnic/fnic_main.c    |  214 ++-
> drivers/scsi/fnic/fnic_nvme.c    | 2268 ++++++++++++++++++++++++++++++
> drivers/scsi/fnic/fnic_nvme.h    |  214 +++
> drivers/scsi/fnic/fnic_res.c     |   31 +-
> drivers/scsi/fnic/fnic_res.h     |   32 +-
> drivers/scsi/fnic/fnic_scsi.c    |  251 ++--
> drivers/scsi/fnic/fnic_stats.h   |   28 +
> drivers/scsi/fnic/fnic_trace.c   |    3 +-
> drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
> 21 files changed, 3906 insertions(+), 779 deletions(-)
> create mode 100644 drivers/scsi/fnic/fnic_nvme.c
> create mode 100644 drivers/scsi/fnic/fnic_nvme.h
>
> --
> 2.47.1
>
>

Hi Martin,

Thank you for your patience.

For the v6 fnic NVMe/FC series, we reviewed the Sashiko feedback and
addressed the issues that we believe are valid and within the scope of this
patch series.

Some of the issues we fixed based on Sashiko feedback across the recent
revisions include:

- clearing and tracking NVMe SGL DMA mapping state correctly;
- dropping the fnic lock around NVMe tport registration;
- unlinking unregistered NVMe tports before freeing them;
- clearing NVMe unload and tport-delete completion pointers on failure path=
s;
- using async/synchronized timer deletion for NVMe LS responses;
- detaching NVMe LS cleanup before callbacks;
- draining LS requests on rport unregister failure;
- preserving LS requests during abort start;
- avoiding stale OXID reclaim after pool reset;
- flushing NVMe completions after copy workqueue cleanup;
- avoiding an extra PCI device reference for the lport.

We also reviewed the latest critical Sashiko findings. The items around NVM=
e
PRLI formatting and target capability handling were evaluated against real
targets in our test environment, and we did not observe any discovery or lo=
gin
failures. Based on that testing, we do not believe these are practical
showstoppers for the v6 series.

A few other critical-looking reports are either pre-existing FDLS issues or=
 are
already addressed by later patches in the same v6 series. In our opinion, t=
he
remaining Sashiko findings are not critical enough to hold integration of t=
his
series. They can be handled later if needed.

We would highly appreciate your help in integrating this series.

Thanks,
Karan
