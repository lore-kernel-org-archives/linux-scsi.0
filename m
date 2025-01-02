Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9213D1537D4;
	Thu,  2 Jan 2025 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735842019; cv=fail; b=KiIv9YT/Sj6IWEY29kE2Bt4UJR8kIjHQ0yE78qau5sk3b5fjEFGZ4S9fLo/jXPNjosCuFg4WZ3Rig03cXlCs2Nnm2nOW2rz/Mmh2eq1Wmk8ERb6+CdrSCjLvXD+xUsGCbpi24pLpYP64yJje+vylmhMqw+JGkqrntxZVhpJfKdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735842019; c=relaxed/simple;
	bh=lgP2XZ4LsCvA0G33Zzq3VutKmRusHpbPtOXgKK+zVLA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=O+/+SgnNBgcdygwHqnzdrZhUADtdIcsposiPidbAysPEkubp4xHRIiXYofezDFvd5lcwcgxnSgrQ/8T5UQgsqUoow8WTj0f1VLeHTaxiADhQFyL9BxTQY7K0/TVkivyN9u7gxihKu5tNbY5RLOx6BpdjS4dYFb8JYNC66cTgabs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XZNWINbX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xa3KSWfR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XZNWINbX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xa3KSWfR"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXo1o016759;
	Thu, 2 Jan 2025 18:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=ciW+p3b9C9vkZCNbMV
	/RI+iZAUM6FooBhoVdaNOgNXk=; b=XZNWINbXF4CQqWB5WgN//WI+fWh0u26WOc
	6sAvmPwcg8KoFLFKIbMWjtyKgIOWWcxOzy4v01jTBk8J0pKWXwTes8I9U6U60OTw
	XjihGaJucClf6wa3wAq0MUcr2qlQ3NuOAtZl9iM1qMJLpTqyuH96SWhwxx15lcUK
	rBte1BHH218i7KrYJPKxRp3RCWSEQaTeLP+sKpYxMVSwHEaBL5zPryK62J2fnSKe
	1u1ctbZVGjZl4h68YZIq1f4qaJPSzp54UeLwpuQzVtEC2Y/AEenZ+1Qz0DOL0Rq3
	i78fG041cE1X3XoQ/t+w4Ge135MmyI6bflpO7TcxYXuIq1qRd6Tw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t841xa73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:20:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502GoPRC009392;
	Thu, 2 Jan 2025 18:20:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s8ur0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 18:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oaV2X3Mo0ZhBdIfAkmB61KZ3xfiwWoKyM3fzLjCpRSbr2ztkqdvLXrMcd8SnNxEAPEnqs5u/HdseIIqav98SODa6fRAH4l/8IrJ0X48ARY1pSiSFvtqxbIJMwXagZQMUM2Y85Zb1QVXj7MO+3fZog7p8sKyOLFby3aNJqdvKj5hC2+2ye6/Wgsk478Vfa9rthnLmcKZv5F396W6HjwAauLKvPsssGUEHA+ddLDePCbcZ4XEGsaRbP39UFPDTEp0lPcmMaFqIOIlbtfI3d0uCbpEdEcS9Og//wcNMrP+oi/VNs1CDUdE3J+LPBJiGHTZ1C8V/72amH2UbjFdLYwsVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ciW+p3b9C9vkZCNbMV/RI+iZAUM6FooBhoVdaNOgNXk=;
 b=KLKxjMDZBKaZ0j4MhU+TMMLK+cJYD5yNYLOoDFj7jaUT+cpbyLVkn7y0jEXC/ZX4Ugb3/q+sr9nTTxgyN8xZSB/ilr+SEK7HdaVuIriRGvUuHj2fQ3bU1wdZyYzPoc+TAZTu7RwcmAl+YQZCcamuWm8KNkvKMXVPiSJBZVtvwRMtzf+TecswvRxlMPhp0tELaEq8DjHVki4ArjkD47G0MMaFJ2SDTNZYSDlC3eYq2CAnMT09oM/8XqV7OXNnbhU/+nVhRIt1KBLT4Q17oF2TPgDkX7alPkhAcztYWwKnNDq0v+Q/oSo/DYBVr5IgXCfTScfLM4XyVM9paN29NH8uRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ciW+p3b9C9vkZCNbMV/RI+iZAUM6FooBhoVdaNOgNXk=;
 b=xa3KSWfROPsUb2pk1pp3lcCxv7rweAEP91cQSLPvzabrNCRbkz+IYwEY3aqTsge4Op21E3SM/nd6n8+rpaySEs4GbtE1bQvQmI1qJzI1ezhB4QXctQka/5zI4rNEDooQNoQpnbvDtezslkn3B8dQauDdzsS7T6bOXdMBNpoKSRM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4197.namprd10.prod.outlook.com (2603:10b6:610:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Thu, 2 Jan
 2025 18:20:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 18:20:05 +0000
To: linux@treblig.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, a.kovaleva@yadro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Remove unused functions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241222213524.270735-1-linux@treblig.org> (linux@treblig.org's
	message of "Sun, 22 Dec 2024 21:35:24 +0000")
Organization: Oracle Corporation
Message-ID: <yq1cyh5gjsz.fsf@ca-mkp.ca.oracle.com>
References: <20241222213524.270735-1-linux@treblig.org>
Date: Thu, 02 Jan 2025 13:20:03 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0017.namprd14.prod.outlook.com
 (2603:10b6:208:23e::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4197:EE_
X-MS-Office365-Filtering-Correlation-Id: 92134c48-cc81-48d8-67ac-08dd2b5a149a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I9oAf5wP5AMo0zvcaAf+9txsHGPEwv6b742XHpxTFt5Ck/SBVJ5pKoWvktlc?=
 =?us-ascii?Q?6dazvY3utXHpU1y8r8lQrGBYQOdGrjReU2tnJMNMz6RnklZvbzkU2YfNrpmM?=
 =?us-ascii?Q?RonVJciGU5Azzh4HapdRFcL8L/Qd7kbSCOLpiOrZUct/EIBvKoaxc2m44Fe8?=
 =?us-ascii?Q?r4lndAt8BEfkF8b7EIrpfKs8OZvrILW6a+k25UDmgUFCSiTaN5a4PflcmVp7?=
 =?us-ascii?Q?jBmpjqoROJdPuezjm3UMtiU4bCu4otr0+pnYR78Gbj5rM7lOaI26oFKXkVcf?=
 =?us-ascii?Q?/b3yX+37/7Hw88TJVyzzyoX89RQwC5SQ9qB75sR6dKX3CoiEDlzUuSk559iF?=
 =?us-ascii?Q?27E9z5hUniz1xR2FmoE+uWN+BVbR4//KuO/VRyOzU3ABojFVBgsgML0xlMJT?=
 =?us-ascii?Q?Cj0WhnhdjS7YYs/e6Gl2s3sXdFwrUcRM409dLsHMUbR0Y4Eom1W38o7pHORj?=
 =?us-ascii?Q?X3mGAaiARi8X3/NajrM3OE1xCNMpn/nfcyM1WudpnaEM+H9JxHs2ICvJG3N0?=
 =?us-ascii?Q?hk2eTocqDt6Qbx5qVAmjZ4bz5E7lUqWD/jjpiMw3hy54HS9c5feD4ijti/aJ?=
 =?us-ascii?Q?Wq9Gw9vJ7ouvwQ8x2GZqvROQWEfe2j4Lg3aiKpp9MqMrmGNLJ069kGrq0tUP?=
 =?us-ascii?Q?czjxCOtKGb6n9wwmyubyqbfpo1lfuAp/qJL384iK/4g7vO6zd06ZFjPm9Bd6?=
 =?us-ascii?Q?mnjvzvkiljt3cBsWaECtllMaILcfGo+PpkGesmKZQfm+0jUYOPyuTySCu5BK?=
 =?us-ascii?Q?hxfi01fYe0wCm6394YiEE1BUkWI13IcEKkVrBnzDUc0TP2O5HwuD7zR0P6ZX?=
 =?us-ascii?Q?6cNYJ6tuCFGU5iQrjV/jJQ2Dyqr4UCBFB7d3lvlSmt+5T5Nvi9teqN/U4190?=
 =?us-ascii?Q?SI+gf5zGNYBBz0kyvzvlrlI6vbYXaehi0CNMTNiuzXYMuq+Hb3AVkTQiyfnV?=
 =?us-ascii?Q?/vagWhZZChvourMQ2Zlb7XcTB3pS1cJS02PAbmwgPxBZ0t1Rf4AcdOlWlxIx?=
 =?us-ascii?Q?596IUndICgqRMcqy9F0CiGuion8dM7i+VdR+qsNHWP0pkyI7CddXvAtTWOVg?=
 =?us-ascii?Q?UBa4y+A8VHEXAlCBFtN1NxFHa5koWv6X8MUmMUSgyPNWShVFJI+RKl4fpYAY?=
 =?us-ascii?Q?D44hBemUDfrXp1j6EpCoxEGMX9a7N4syNWqQkIJjfyDoCnhJVF5O+Fc53pXt?=
 =?us-ascii?Q?cTX2k4ILusKSCIbWDQS65E1+faEXsCRr/qV6Rj9WvJH6TqQ9YqM5E99Jv32C?=
 =?us-ascii?Q?DMo7p3TmYTBQrIdfvd/sl44kPUZrPCg5IbPSOovwZ2aWFJXLCMcFVvDc4SgN?=
 =?us-ascii?Q?/UfpjGs/dvPeLai5hPpmuUMkISqx9TbD1IiFam7PBA0fA9fiu5myZHP94EWy?=
 =?us-ascii?Q?5PYPk1s/typnOm5Lg/1eJIOe8dgx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vmfdZqtUjAFX/xEd2LzyM2RRE2KADE0BAHQ0qCouZNmhohqHX8TwZ0oz6/Bx?=
 =?us-ascii?Q?kDv7dTEBP/jCG/fmvf3nJGIP0HoH6a6SL2SCDYOwqeiTGBOkpPt86aDqQoqB?=
 =?us-ascii?Q?09Z+a5STzVzUCID1StJ8lP+c97W3n1oCJNSSmt1MOV8siAfYebtJKrCxBTdO?=
 =?us-ascii?Q?P3ALzWWTLK4JvwRVRIcTk/MVL45DrDdiWg85dS66stsy29rpXCodNpH6smFh?=
 =?us-ascii?Q?fjrN+RGr+M/6/SL+pEiDMcptnaMn0AeoEiSbmdEH8ev7OJLDOGpfaK2EQYQ3?=
 =?us-ascii?Q?S4TTmnTbveqaFr2A+xDA2++XMiWsRTWagsBR9XAL6hMAUE/H0b1Uuf4A942m?=
 =?us-ascii?Q?QJcUiWtjd2/8kfWufRLOZ6aGOxz9NNBsNvJmcb+PyKnIhsBY8WndOXomatJB?=
 =?us-ascii?Q?747GufuIronHyOPQFEbapQnE2itadWhVKsYFSmr6peEx+fgVN7Iw9DTDT1up?=
 =?us-ascii?Q?hxNAII4yev9b9U63baKfNoLIKh1GmBiS0wqojRCF1ExlckSGLJRPKvFabXKn?=
 =?us-ascii?Q?zYLfXBNpn3DYpnndKTTqeqEDOa2F6FcZMdDtqaA16rlGkmYLQETGyx9/GPLE?=
 =?us-ascii?Q?eJ74vxG2AhZ9Y3/+mUEQ8eh7jkjiY1XmKwbtHFmfSAehVLkURyOxTDhwKNuD?=
 =?us-ascii?Q?6mrGbcR6d8PSQ0OC6uDKo3rT3NFYysHgSyZDxiIBdrAGYhFyLjp7a63zoNt/?=
 =?us-ascii?Q?4LO7+2pIYOe5jHXJugVdBC9QGYkm/yl7iUgFuQfQsPIVkobp1/0LR1qpwH1i?=
 =?us-ascii?Q?ACFGt/6w31+gIxda0OURRx9VDE7ZJX1GJ7UlVL9W90enDFlALJCwRU/AJbeo?=
 =?us-ascii?Q?Xq/hNIEK9/Ho1jA89GQWoU6wm0lPdr6HEWWBWeUDKvZbHvDD7M1xWwLlMGhO?=
 =?us-ascii?Q?rvmPiUK8c1IfDONu3ZZvyvkwxZC4axDQtWhfHf91knY8N/qrDUTWTO/cN88S?=
 =?us-ascii?Q?RR67bHSJyk7gq3V8f1fQDXjg/6KPI+eSdKAv7hx375Ct/5y5j+sUSsysvbsC?=
 =?us-ascii?Q?tzYIqb6iGM5T9X1jCQNmxfW8BEjS11/lJHDYxpi1C2ZlA9TeVFm+Eklp4Pcj?=
 =?us-ascii?Q?2sKKKgZp/YoXjramnQ34HsARYzgZyvsKK7hgZn87nEYaunv0JhytDT/0vw3v?=
 =?us-ascii?Q?Zu0OlS0J2ZrjBlp8aXT+dAbK90vWoKmq3eCjw0ifKIQhMpGuePqu1zEWr9cs?=
 =?us-ascii?Q?PAJhDL+V0dbGOwG9Lk6BKwCNhdwDSTSKcTXOh+6z/6IthUFbvUKyY6LSKgWM?=
 =?us-ascii?Q?GROjIfXLSKsVcKcHApKVA+Gdd6F7wQfJ4h99vHf7WrknVkYq15ONl73xA3Qk?=
 =?us-ascii?Q?boCqAeImVjE6rtpeR5YQtn/wixqNI8Y2/QY3BXBTUnv2fipI3pGqg7d1U0cF?=
 =?us-ascii?Q?lL4u+9uKHx6KG1B384VfDX+TOMLXKbYaoEUcF7U4eSmLQubUaL+Q8r2SbKl1?=
 =?us-ascii?Q?OuYpLeTy9WTx6L8ShqDV841i6SLSlaAHKXsP5j+HKbbb91jr4BvJKfpiIM5r?=
 =?us-ascii?Q?Z6jTm0762CkdnglUUfXSosrSym/S7mmBWFA+6Bt/I3vXEBP4ueKZVhcvT1KJ?=
 =?us-ascii?Q?0qyQk/ph1hmSe4K74sd3TIb7utUTYMUZW6GFVDCOhBq7wwlWhBpEFK2VV0S+?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FbxmDol05wMqxslqEE113q9vPLKWMMo8lDBXI4ZhgIgtp9cvp2FiCJmQrHU/Fh0NdyYbIMSQCfBmjZyZQLB5iStmL/8M1PrquyIBeFFrkf1ziTIZ4Ib4TbW3nJ6mfx/w4I8C6Hs5E+tvMMce8m4h8aDN7xMQxP+vJda/IDThJRznAYvxfcD9q9bxkK4ueVcWhCdfsn6/Jfu0yDFnboJ+3BAhAMGvR0D8R74S380qM7nfcY71K2Z+/2dKDrK2HsgZmC2vvkGwCBbajBc7iQE8gYTMoEVZZrYlQcNah8rNS9P2LVOMxG1pbeMg2Gk9m1XGhBZCtebEXdSHIgkNXdW9bK1OR8sIyNCMAbKyCF2d+UYKKaMV43EBAMhBn36RxRwCIMgEjjpdSIVP92H8JvAtmvAAljAy9ayET0xBtDAvEbV3PGZzoqHHMKF2WzRL5uUeF+KT/k98pcfHImSwKZbz3FNP2V77SdNdY3P/OJTNzrhBTWBTI7mjrD8xELucfehtrJCbd2ORSsdEZGXIKD5d2RJoJO7uxCMHJ9Cb+soUm82sTadLBqWLCq9i+jkrxLZbFFJ5WPk61dLhsk+6Bd5EwioLGygKmcJ8WLfxzX9bhnM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92134c48-cc81-48d8-67ac-08dd2b5a149a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 18:20:05.0366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9S087+p5+vejGN7UJNdaNMFidFWxvqx+kYcA6l9Mw+Vq+7lDD+FdtDFovtuKcRpFdUM7fI8j+ortSEhDrXkzRa/Vfv1NYFwLUoFODpVQG3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=921 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020160
X-Proofpoint-ORIG-GUID: 1u2Yww2OFxFzK1iq02Ez1mjHYGLkkgOs
X-Proofpoint-GUID: 1u2Yww2OFxFzK1iq02Ez1mjHYGLkkgOs


> The functions:
>   iscsit_check_unsolicited_dataout()
>   iscsit_fail_session()
>   iscsit_create_conn_recovery_datain_values()
>   iscsit_create_conn_recovery_dataout_values()
>   iscsit_tpg_dump_params()
>   iscsit_print_session_params()
>
>   were all added in 2011 by
> commit e48354ce078c ("iscsi-target: Add iSCSI fabric support for
> target v4.1")
>
> but have remained unused.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
