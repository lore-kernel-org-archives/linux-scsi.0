Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8DA2DECBC;
	Thu, 25 Sep 2025 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758765472; cv=fail; b=UQcZ/r2EKc/340YMtSsupyKB61YaHRUNP3HVdwxokNUO9cTcQk2st1CGd548I3rxn+RZ1lR2TTiTA0y/fRBm2uX1XEsRl27N8v2mAXzWVzhsKGe5gg+834FugBer263BPPA/AtyqXhaP+JJF7BQ44KDxsG3DtbuA5LUDa2jt6mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758765472; c=relaxed/simple;
	bh=IgsgM4VqImoJZX5QmlnXwUgxbJKjlDT628BRMA+sArc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L6rEDg1zWT9v/vOaAgdVPL7L3i7QXb+Fk7qZ3TCUFICEc065fvJNY8GkmAlK5AIlS5nNh3Z5eY5EyaybUf6HgFhBhxbx8lbUmJLjM48uYmPYPfrdr/41/vg2kXpwM3gTwkJNfy38Hyx+FSgAPUpGMzYE4FnVxQa0kEfkQ/K+OWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kvGzHk/E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ygmn3s9u; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kvGzHk/E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ygmn3s9u"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItxKR030318;
	Thu, 25 Sep 2025 01:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8BlDyjhla8owEm64zV
	rpo8j0sUFCf+WCVsMLnDqrzjo=; b=kvGzHk/E4olTFyYs/Mkb/0oa75n6+T4Nyv
	ThUPR4EdoyLZlTQzWhfwYFNe8dBzQBGhx4/qvTJkoIWqfzYYV36UsSeiclGkp1Z4
	8fmiAccZQ7QepQb0vQZb+IPCk4M0Hq1/cG1ygKhZODAA1nyPwJhMh+lMSKVJQe5T
	uKUHhal1j6PV2Q3oK6wbdCcxKmEm54Kn0IBcAr1CQdgu6bKGPEm8TK1i1t/okVkK
	7u7eB/ymm+Ih+ici/X33FKtXGpKCZoT9kP7hlOn5GXWJgtxO2ZfqqrU9cBRCTXwO
	owm8ToeIiIKJmnNgmfZIOhbvRdt7cd3v6GfZJ5Cd3ZGf1ZeXUobg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499m59gyph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:57:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ONuEgH021644;
	Thu, 25 Sep 2025 01:57:45 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jqadj7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:57:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=colmurJG5gC29fn4I15Ei7r3KVAGXqCAkr1gU+Iwdw63XDIcz9E72kuz/tLbp6mxhwShXdcx8rQwGrOrrYH6cmD+i6JKO6ZGGCZjfX4HtQGk/kLFO6lNnaz+ohdVcaockzGTH5ypcMzEcntmUBGTrm+G+Bwn9sl+w+VyF4gqIhZcE4H/6z0aQyltj6A7Pkrw++39F4dcXCBjCy/McLSJ1N1eF4kdojInhpmoDdsuv1AqhwqQ+md97QYfcQDc7gA0CAnJ+XkmLHRKRx39ac7nd5QTdz92Cm3PvxZTMOQHlv6msrYLEsgfCPM/sxFFHTcQfo2LupKUxN/PtqetPGP0MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BlDyjhla8owEm64zVrpo8j0sUFCf+WCVsMLnDqrzjo=;
 b=RvQOdr5vwthHgiXCfJPYv2LsoSK6trjO5zXexVp5jwroiEJnnIUuU74brc5FsJePb7A9I44tFLxyrrqYU1ccvEjg45yOva+uFC1Srm2IoQSSD9EYEN7iovDmGardkHBV7MgLoUgUhVaGw0X2uU5aDNfqy60vYf+SHU4sAR7IGwsMwIdphgIrW5M+hyLgJA0te0YiU8GMDz4IJKlxX4CnnNvgftqner0bfhAhZmgQskQi2dSkBEq5V6OtWMq97vKhjvXaOxZSM/sp5E8DhCT3TI1jw4+gzLNy0kqhSSV6O2aONyDzIVcg8ZzFZk4Xs+SIveQKt0ApFIbfmCgRcHWbpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BlDyjhla8owEm64zVrpo8j0sUFCf+WCVsMLnDqrzjo=;
 b=Ygmn3s9uahSJVHIPY5K8dbW6vS6cGJH0xa2elg4glHtJJM0ZfSIRR/EolCBOt7cL3TDPu31USOZD86bkqFXUurifzEfRvVVs8WlNJPFKS2/OkRkM02pbmNMrA1lB9XAa0I2pcoJre0Xumpa92d6j1y75ZG64A9sJ/VJvEHTSmJA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB7142.namprd10.prod.outlook.com (2603:10b6:208:3f4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 01:57:42 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 01:57:41 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: martin.petersen@oracle.com, hare@suse.de,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libfc: Fix potential buffer overflow in
 fc_ct_ms_fill()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250915183759.768036-1-alok.a.tiwari@oracle.com> (Alok Tiwari's
	message of "Mon, 15 Sep 2025 11:37:57 -0700")
Organization: Oracle Corporation
Message-ID: <yq1tt0rqooy.fsf@ca-mkp.ca.oracle.com>
References: <20250915183759.768036-1-alok.a.tiwari@oracle.com>
Date: Wed, 24 Sep 2025 21:57:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: daf13ccf-2231-4f20-7d4c-08ddfbd6e976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XEtJc1SKgWQKxT1UJaqNyPc9c3eZxH0LzFP3IrlIwgOUMaJOFLofQTmf0GH0?=
 =?us-ascii?Q?74qFsUwy9KZ2ovCRhvfJr/wXOjtptvfGf7Ct7FtxCq4oEVSZ/Rfmi7N03DL3?=
 =?us-ascii?Q?HjVq71FfL3jduY3vNC8SGVlrVl/O99HoRpnSY+x3wvuaPanf5Ijzgt5l5otI?=
 =?us-ascii?Q?VrIz5IKAOdJ2SDphw+0FluE6tXFJ4btnXHDiJyhZPWVEXSopdqlas+ChsnXw?=
 =?us-ascii?Q?TQ9u5iUNKBQ6kaZTwg58KcEH1jloGL7npJickBu9LQ9rXB9v0d1xUwuwOZZZ?=
 =?us-ascii?Q?waRLyeK7ywfhrF0SKUWJYGgwh8wgRlLN1IaUBwEpxScqARHOQVR83XrlmBKX?=
 =?us-ascii?Q?rZ6Wk9tCQ/atnxUwApWQAb4P6+kMMuE8RhkCXZitVWXNZiFStDQds1lpnaMz?=
 =?us-ascii?Q?Ir7MDNSu+7NHBhS/0xZ+50OscS53Qn+UAe7p9yBuWtJYXr0kZLvYd2zanVkj?=
 =?us-ascii?Q?1ROnHbIoQkNg2OxjndCT9CPBJMyPDePvC5oGKAepRkx7t2qGbQP1d4isNZDG?=
 =?us-ascii?Q?dRMP/IR5QHgPb1iGJeLty0BVum6KdWrw1Yok79ZDr31nqn8dOudd7Y0ashdT?=
 =?us-ascii?Q?2Pp8qrNvOChLuPwqVZ2QkOqRqxmFCMkow3myC+zzXiYZyWy9KPWgDIRr8t3q?=
 =?us-ascii?Q?IIhg4OrnzxSwaEFo7+wM9ws3Q03PUEb13Yr5t1TInJaHzagRuVUJdnzX6RWt?=
 =?us-ascii?Q?XezAS+YYjy/ml1S2nUz15TBH+9Q5H8dmOpbSa127FVbJ8/rCMyUC6rDde07B?=
 =?us-ascii?Q?HVQzC0uZwecSjPPw5Bdn5NEj7QBbJY1hWj0HwvcBUndxJYnLBHS6wP6cieOK?=
 =?us-ascii?Q?eytjSYkDtgOozXplSyySMIrdqs0yKD2u1opuhf7Q5u6u01db9Is1clpvzMK4?=
 =?us-ascii?Q?IcMoQiOQ73iEYfkMiDqOhyUMbvdi5IwwT6yFJZbuRmamNhNcP/XkjPuzBQTW?=
 =?us-ascii?Q?ak4zLVv7CtBzAIbqmJPqpvZeag3TMvHPwGAO3kC4Qxr2VPqDz2VdPABWkR8D?=
 =?us-ascii?Q?sXCM1W57cOjMXNxa2k6uKXPiililFhd1Ie+NBOF67QPDLG8MZHptEQIz8VLw?=
 =?us-ascii?Q?4H482DgAp+spKeNu0GtH1gf9CT4OUrxumiveI6TnvtexsR4d3LAW6CmlKsNW?=
 =?us-ascii?Q?pSpAQ4reR8aSW0K7SPQPTtf8l1ALh7eQIwRPK61wjQ1W29qRk6qhPG3xuAbt?=
 =?us-ascii?Q?kuFayOp8wEacUeuPw47hX2Y1lDV1Nhl6MPtrc+tHoZ7pzdjdRa3eS/Bi73C3?=
 =?us-ascii?Q?cHf2mIEUsZaRLNwWKYPgTXVMJLJERwp6/xihG3U//EnDmSYp3ibFM9DZPkew?=
 =?us-ascii?Q?eSD4h/1S45n5Wg54+R9PQewNjsk0kaQ+rm5lYm8UeWUEvlllMwR21yZbUe3T?=
 =?us-ascii?Q?XquzPNwbbnl+raifiZxdwOcm2D8ftgRZPH2039YNV466P/jwcHp8F5X9SuVm?=
 =?us-ascii?Q?uYpwknu90Oc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wBvMMm6I8KF7LkOgPU5j8WSZDZSjt1QAYZXbHtTG6w8/0cwrlH2j8zkVorqR?=
 =?us-ascii?Q?XVOtjRXrq8L2h11bCzDhYCgr8+HKaZQoP5sIcz3IxHAMSwMnK0WpKbRLS5x3?=
 =?us-ascii?Q?1Z7+WxZBOwTvUBsAeMHSDzkgCRZmKjVNic3/TSfS3ZzEHmw0EXChYEWpPowP?=
 =?us-ascii?Q?S+V/GX9FHwCE0+Zbdl3hyhGFfXvfR9IoDytGwtBPOJsFDt+b1CbpHmt1rCqA?=
 =?us-ascii?Q?1NEtxnCzaDaKg9vvhzicZs9sCF2/n9D4fw4xFbNUaeG3EzQfTdmiJmOHu5Qi?=
 =?us-ascii?Q?t1+McJMA6yWg+Qmgo1XiAbZWs9vrTzsYw2dE7sJ2cE0zChJ1aZ/Pjn/eFguj?=
 =?us-ascii?Q?niyr6EeooRLquxt4lgFWERouk9Zv+KRoIARZcud3M2R5amFD1KQauLn7ZLlZ?=
 =?us-ascii?Q?TYHur/lziBTPIyVKqKvUYelPlLJK6c/k9PjDzrhqqU6pn5T5P7pHzACl/x1G?=
 =?us-ascii?Q?uKN5A879RMs9mkn+yymMNn8sHHndQxF2rAeIA89mGWTFObmJi+FTtNEdq2n9?=
 =?us-ascii?Q?hYVWN+kMp/ttaAMVsJCN/vXttP3okBUhdeYLScBMrQB/9TwnOvlJ8VqE/iRK?=
 =?us-ascii?Q?pG2O8L0LXFA+eIk9B85LaYawfBg9VLyl6nYOSLLi6Pco/ekwqZJIPfQha+6C?=
 =?us-ascii?Q?RfiZrX4dgMLrEvnn6YuYqGJq2XZsOT2jbZ8ghYHoQQslc+Tf9UBDLWAUSwnG?=
 =?us-ascii?Q?yHQ6Jrf9SkaR/Q3XfPk0ChFBr+Mw5I8HLOx0+qRg2B9a8ShQtlEn9Gsniu2R?=
 =?us-ascii?Q?R/5sTIgL9jeYW7gDpnt8KZvuf69ZV1WYYkSbAjfYbbyyOsne4C8lPbMf/z4k?=
 =?us-ascii?Q?GM4aDiflXoLYPHNfRC9rt6r6My9n52eCQL/SaBiAWAqhrrV7g1HfYYw8xkwx?=
 =?us-ascii?Q?gD8b8QAzKifSNGcHEBNTXHLr00A9vaaWyOAVz8hyqW+Szm8x7RPV23dtcs6G?=
 =?us-ascii?Q?R59GY7K+gUmHBDPRwvuD2bykZxXIuLo8L1tkHRZGgvbox1bArn3DrppntWJp?=
 =?us-ascii?Q?Deb/osiyAFuFOSiGTSd/TLUGDZgEg4YzDa9Qh1/XKIyWwG1Q+hsg90nW7U8a?=
 =?us-ascii?Q?0l+VY3b5UIHLlg/vogm4Y0SqT/poQkucMHtBFu8OwaCIlZQfU98PCiGB+Yz7?=
 =?us-ascii?Q?gPXg6pMim23CT0u/MaVg/RwOFctNgg7p/tL6rgQ1DxbBmU5lrVUoEZzq6FxI?=
 =?us-ascii?Q?l6YHhLnFJTA4lsGxBdt9BNNPE/fbiXnDJ+sn9d6bLSJkXw7EeGRP5/V3oxXM?=
 =?us-ascii?Q?7mu+SvyvDV7HsaYiqz0YMS0iKvE3PHjGvTgesZUlbjo3noumuhJFiWG6hmR3?=
 =?us-ascii?Q?k82ytC2tyGu7huGy51a2MveYqU+JagB2Knid5npUJnxP3+R3DOcjR+k3G3O6?=
 =?us-ascii?Q?SUl9oM7ZkTB75n5JsF+KgWwntcVOYSOZJ3WCbM1EUnrbTudk/9ezbiOlDb04?=
 =?us-ascii?Q?VAizNGKRnnn+NdrZjklSPwDbUWf/2xeclysJVGgO5/PI46ZhBRGOKtV4G2x+?=
 =?us-ascii?Q?oboNUR4WY9xxeC/aTjUgQtE8QKz+jfEeQGIFUk90gchDJ84gxD88rPOMYJMI?=
 =?us-ascii?Q?uB0M8EP51D5IcgAtoHCWSX/CfvVzMLAu7LeWaTUC+EoD/YXSLWbOdydkY3oP?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hlC5v7bEDrB9aXeP125AhjQYQcPGdQfc9tXes0hMHhMBxiMtby3oGS3q6fYuE9GtX536W8AI2duvfR/nHWtf265DnL9FoP0N0mh6aWjpjiE5KqCJZ/24BPe0a9uXzind0tFxR65GK6YJQJQda6ZhmHhqXQUNXv3wGIcigJs8r5GResdHA+gNUJfo6j0FplBpIa4Qx8Byfu8nie9vZkh0VDVPQFSeI6p9GzQgleMT7+YZqEYSf+4gSnUraXVBKY9egh5/CC/0lH2QrqT3bZ1tDgd5PgvsyzGHEfqG4A8M8L72Ouo3BBx9zmeApJH9WYAwX/htUVVXOn7gOhe6ck5L+y6tKrsOL/LBkE3mteeSlhsH6fDD6jEOO/u64kKDZcztCzsMLCMStMWADs4F7b319biVOGDADuHZ69MdVv6JKThb2BATgIUTn0D5AtjmEyDpi986rW2vJu6/FJKCAbqGIiFHTHNFgkGqEalQU9IsXHlclu4EvrZKUkfZifGr8esyO1ty8NwsF1XaWUV+DXPHJcGq15bHnbxao/TfZHOuo43nxU5OgV915H6w8xPawHFwuMKce7Hl7s8goalt5Vp+vw43MGZFvN5pg/755Es+m5U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daf13ccf-2231-4f20-7d4c-08ddfbd6e976
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 01:57:41.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwLuJVce0N9T0ORB4Qzne9iFWgLzEi1llKGBIj0iXZctIS92Ekp1V/Mtdc9/95mrz/FoFPuim9orMQmv1vfvAYmYBC+LNm8cJ1KioLJOaCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7142
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=922
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250016
X-Proofpoint-ORIG-GUID: UmqA_RXXUoIM7uBgfZNprd6-PJL1_EL0
X-Proofpoint-GUID: UmqA_RXXUoIM7uBgfZNprd6-PJL1_EL0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyOCBTYWx0ZWRfX2JBkL4/gaNQE
 h/dZnJtsHiJ/qeIolY2TlUxbhoDF+etxRVHoWMpI7E97FYw/arY9N9iLdYPxg0jHw1h/8Mbo/oX
 2Y2Xixtzr6lEju7a0luHbR0CahkTsseTCW1AQp1NZdo0W39i+KAKft7bbHuK/8Yb9u6snLnwL+d
 9sPMrmb+ef0hy4kb3suhnGK8iJXFKrkcH/MEp2S6AZ0eHDir2SK91GwCeyppBPKJ27A9TZmLNT7
 +4p0XR/MrP3gCepl1MXalGgw4tK0CsrVlFDs5HI8gjI2Okf4/iLxxUIPbLhM5YTLffUsFwBnhdx
 /qIVG6cgn5ISNVEsC2al9nlPqrNJ9bE3Zzhs3dJg/tFA6Foh2QvWdyjPrAGPaJwtFS48yq3NU6+
 peu4gzC4m2nkEdZuEP7g6ksPt2N1kg==
X-Authority-Analysis: v=2.4 cv=HJrDFptv c=1 sm=1 tr=0 ts=68d4a19a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12089


Alok,

> The fc_ct_ms_fill() helper currently formats the OS name and version
> into entry->value using "%s v%s". Since init_utsname()->sysname and
> ->release are unbounded strings, snprintf() may attempt to write more
> than FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN bytes, triggering a
> -Wformat-truncation warning with W=1.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
