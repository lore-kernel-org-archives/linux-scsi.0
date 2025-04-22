Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475F12F37;
	Tue, 22 Apr 2025 01:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745286821; cv=fail; b=pZlaQdmz/jFHPKqrxfiwjasGXufXwmY+d0hKF2lKD3xi7WrIxfvhWhguvQukrRgftiBl/kW0MhS9ciIKiOaspYHuOFvc1XY2/2h0iTKAZ7YdJkw9+dHKnPEEL1ZeAW5sJ4ACX859LEoGKm5pGrfad1wiAUog9q3blGyA231YcEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745286821; c=relaxed/simple;
	bh=tLdKINLF0rjr4DidK/aZ8d2wJqDV5MhwSjPt/+7otPI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=P7oHrF0Sf7jkis6ZeEsxJ3mrvSCOeha++NCUp97yfhLk/o7BUW8+3Yk9N3CrJ+egEWulJ8U9CsuqD4eg98U66VNLiPgZ8IvNYMx35GcYZclM6CnAn2wZorChQKqPsTTYefReMWp4hu1uLjg9M6KUnZSuk4gV0GpJ9NNatit672M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DGDblKPg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GpiIB6nh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGDblKPg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GpiIB6nh"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0fuxm004722;
	Tue, 22 Apr 2025 01:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=vnDao6hnuSi5OOxdhF
	OEdTt2HrX4Q/QhvVsFCd7P6S0=; b=DGDblKPg4CGz2PI/uFLvD1nz+nxBf1AJA9
	fHIHbwmy4CNw8i/Ek/M8ME6ZXAhNK1uqQQ350YSkKVgLi+aVVfPWJAN3tEfjLDu3
	Crph/goHMrC3WEYVaZdKQ7GKZYqCNtqmtH3OuwZIXxU/iucLRpe7pfEnyP0GiIZ9
	7KUMFDvMqzrEebZ0L0iD5uZTVyfwzD4k/4dUlLGQxOMqJLCE+RNxvkQwxZ/qT04e
	tqM/N5wrvfa7Eljvb35+Y7KCwLRidybuLGAI4U2S2wYO/LbZIEc/7Vn+eRC/ZLxL
	UYqh9/c7pHmZkdfEdCl6sWjZB0il0sMUI8puiy726F+M/a02iKCg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4642m1uk8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:53:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53LNDWs1033437;
	Tue, 22 Apr 2025 01:53:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 464298qtjx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:53:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o+pJ2GU00OBQPTkJS6Ay88p775PapwdKxrXJ1rSm/D9JoLYOfhcKpFcziY2/0JWCmWVGFndVszt7eAoHgxTgxPwu8nTTTvBtIsuFisdDzL4tAzYR3KzoMoBdk6lFlbYBCMsch3f8mkKeeZ1ZcrI1dBBKjAMXNQBpJoGXFvt2lHXqRMdvHxXJWNO/xWdm9NTcxTDA18YYxnDTsUoPgYdaPM3PiyUjN3+h46iV9n7+esZdga4mEBzW4soeXKoX6ttdVxSzdr/R5max1wlmkt5T2fJyPPjeLonuf6q16HlgNPBG8VDrf4qWTLO9dQvSxKXpUuvzhSm9kVraXs2W+BZ6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnDao6hnuSi5OOxdhFOEdTt2HrX4Q/QhvVsFCd7P6S0=;
 b=ot+BhxQqUKvDwSdrOtbR9sNiwuM7qdh2JesV56kJYdPpL5iPXT03sAGfMkvx9B51g6ST3WuSuOzi1I5XyepycAYYNesAHs1HyXC+h9k44sXvZzYncVwym0r5w/j8tdhEzRv9ITTG6uqKGalGdl2lKm7y7uY3kcxIaOayi6mQBch5uAu/lln2R4Ml1LXlVMvRxfYX7aL/F3MaDNUcMforQtcZYLFkvSM4n/mxcL5icDSdj3Sd3F0ypuIX4Xi/CL1QCbznM2m1XxIosu0PAb0J1DEjUAPYCU+BT3FtvOcYt+srcfZI7HAZskScbWA7Sf2GCYh+YcV4abrwNOYK/byggw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnDao6hnuSi5OOxdhFOEdTt2HrX4Q/QhvVsFCd7P6S0=;
 b=GpiIB6nhWzu+oyODE1t/ka2w0wSfcWYYcPUzOWmoACGSrhvg0iY/c/b+XMuW2GFc9oYv/kIuBLUKbSHnAjYnCOSOU6D1bGu0gS7U4MZMnqB/Nd3Yl3OsK1CBReYz/Fw6+ZiyNMAar92En444TO+/ypC5HV3keT8h/VDE6oz5Nkc=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.34; Tue, 22 Apr 2025 01:53:31 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 01:53:31 +0000
To: linux@treblig.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] scsi: qla2xxx deadcoding
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250415002803.135909-1-linux@treblig.org> (linux@treblig.org's
	message of "Tue, 15 Apr 2025 01:27:55 +0100")
Organization: Oracle Corporation
Message-ID: <yq1r01l9d2n.fsf@ca-mkp.ca.oracle.com>
References: <20250415002803.135909-1-linux@treblig.org>
Date: Mon, 21 Apr 2025 21:53:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:408:e8::6) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 613b5832-be27-4890-479a-08dd81407bb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p92IshLZIC9y+VveM938yIHdEIKiufk4zT1Fwp//TlGpjwHjK0pIQTAqY/l6?=
 =?us-ascii?Q?/j0Ng8/u7DJmBkjNKAyxYjOnHbgDOVKvYOtriIZwU6UZaU9Us2wqGdH8V7R/?=
 =?us-ascii?Q?p0AjoKQ8wg3D2oiV5as7etXRbIZrH102Zn5nwI2QJqbZu6CCP+fUUyzxFvXv?=
 =?us-ascii?Q?MnJ0bfMmrV/oQ86TWUB4VsWWRbVTTaX/6R8liVgRRyPIgIJtf6sFFU9ZRBB4?=
 =?us-ascii?Q?/4Ji/Uc+Y19PJWYg1se4d+/QbGetdKJ3+MpZIOQFAc+kotn7ic/AQj9Y6ocX?=
 =?us-ascii?Q?N0aB07eBIKG9Njn19ibyJq+mw8XmMnOVV6XA4zOATe0VQ12WEgKbMudFPXp1?=
 =?us-ascii?Q?JyGPLY1JNs7tp92jE4R04KiazV3Ry/GAPg70tBFUil4lEpyNYWV89Hcx8HcX?=
 =?us-ascii?Q?2VmebdoaQQJikhi4xkrQkKBWYy1ALkMQG4wrWOk+xd4EDf1Pf3qCKvp2hOHX?=
 =?us-ascii?Q?HoT5upXXO/nzHVHArpQDDqesLYom8IfYPayv9XVMo86/h7OLyxNLC3TY0m2C?=
 =?us-ascii?Q?TuZuMjClRxwmHOqPsxGZc0dOumwVcmHA3mhtQUHLLfPCj3UUpMsOxkI6FtMH?=
 =?us-ascii?Q?CgibR8CHFU9OrPCUNRH9Tf+MZ2GJPfelm7bVvv75mqeDTJO49Z+MqG8s/xc+?=
 =?us-ascii?Q?UWdjtuO3+myEzU7J6XKpPh0jaPTyMRL6JWHL1REd/ngxrxD5pekk5R9GjAYx?=
 =?us-ascii?Q?7GFY6Ck4Vx6wx7rK7V+A16O5FoR2BNC6azzxiatyy4CDRP80w/txHJfAULT3?=
 =?us-ascii?Q?FHEOXN37mQIf27LDJRgMab3korloYxRdWHmTqYX0kUw6F/IyNhS5JjG+lpAG?=
 =?us-ascii?Q?Nnq2g6LZZOOdka/+NkwBfhf6SSnHzeou7Ca2LYvJkClP9J/RSuUbviaf7MCc?=
 =?us-ascii?Q?4kBehIfzbVsnQrH21UqvTwt/GSP8uRaYeZMOie5G/T7oFJGQaF3e8x1EAbMx?=
 =?us-ascii?Q?sot3pwco7VANqxB3Vh9ZsYx/4bTk0e5GCi9ziK633AcsHhqrq4jwWeeM4RpG?=
 =?us-ascii?Q?S0weNiSmf8fPv7u3lp3xVx3ppF8wSoNfSDcrpLzLgAeLbMGrSWN5LMLAxuLC?=
 =?us-ascii?Q?cGVmoTw5Kt3vHZGRTPOfuJTPk1wwNGSySmTX6FYYZvK3nTch2rqX4DkD+j3q?=
 =?us-ascii?Q?bo1FMrX3LzzlyTZhACpRDLumnTS0gWEXHX+tJQcXuxN37FKEbxD7SzNUwHgy?=
 =?us-ascii?Q?tSXlTw2SOBzTW7enJTPAyfnqT1J7EEk+6gjhZvXpe0Cj4vDY1BH7lmocFQ77?=
 =?us-ascii?Q?iF009e+mJKSAXiqvvFGj61S6OIDORx2o9oDs+ICgPjK1Jf+DcsQmWbCNvomF?=
 =?us-ascii?Q?uLqNm7l/nK0BYD32upXvfge3ovs0MweHZGA8+NTywwMSnrAWk+ki91HtwF08?=
 =?us-ascii?Q?i3lAw3PmFTNbwUOcwGh+mYmOvy0WUwP7AYQCo9qhRebig2gmvl38O8YNS/WN?=
 =?us-ascii?Q?MFL/0mBrOR8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g7Av4v64DkEtU7XK6KkL1b1BVa3sV0hzw8udt/k3HzqahIvqeB15nhdlSU35?=
 =?us-ascii?Q?TqBvKPEdG1XmrLuLh1D28s293+HpOIEDa0QUp8lpX97+YKHW2eqMOAXIiULQ?=
 =?us-ascii?Q?+cx/jmYpkvzPpbsV9tmnPizBEyMXZxhRkxDM6gxmGxjGCfzU0/coIT2dzc8o?=
 =?us-ascii?Q?0GpbPz6mlyV6gMA70ZAG6g9S3xvyfjBkjcnDMUAEf500AsH2es9aBpDfnhWi?=
 =?us-ascii?Q?r0vM6hIs3DlNetZnMrKaKdf8HLh0HC37VpfsSUCC1LL+DvEHdesSWgyy4EK2?=
 =?us-ascii?Q?jZYG/Kqjlaua97Fnpt9oS1nmOB6MljozzRt19gQrCcftX8ZSAEoBGt7usv9u?=
 =?us-ascii?Q?Jqzg9Qnu5IsnbWQi47YiRA75RD/anveqrSi9jfPrlY6Kt9w+VNynEfw/IEpR?=
 =?us-ascii?Q?sNr3DwgzLDmovKqc0lmKNU6UioPC8zUb1ksEVQ1gAfqL88FUtjG83LyrTh0z?=
 =?us-ascii?Q?bNxfAS7qxqmGb1osVc+cgMo/J2KOrGcOoDIjU4C082RF/VM+8E81PBnpf+Xg?=
 =?us-ascii?Q?4XgKf+k7aGYI3snuyaoJVKx7O/PpPCXgQGSvFgJ4Ppx1KEOPp0Cua78+xQwL?=
 =?us-ascii?Q?5tpPNU+skI75DzMs/ZIOpKBsC2fb0m1W00RkeVQvdqS1mLJ+fxnZnYBQ5xdT?=
 =?us-ascii?Q?uZ5Y8FyZ7ACpiXCkbfz1t580a5rzpIX7zOEHETZwPlIfokg0QpYPGHtE7fqv?=
 =?us-ascii?Q?AuX1Zi/ECGWpFEQotVyk6HEp4g4VEKbI6WOGmRgYJxBMdyIkhuQHoZWhcQ4n?=
 =?us-ascii?Q?Uo8/LOVt22tFRMxyR1YhRYw94i56DLjetEftv2zIiwda6mY40P260H+n+L0A?=
 =?us-ascii?Q?Ls7PMzat9DmU/xBkFPY+qYfAejiER9IpVwr05ihsfZ4Qxv/tjgPLhZcR7V2W?=
 =?us-ascii?Q?mp2ubjvgsrLVXSEUrZhXBg2i89JvokHCFiCHS3PhgtWhJ4zu1bzXNGSarZ92?=
 =?us-ascii?Q?J48GNh8EBS7hnKYS7JFWlO9Umnt2G5GPSYjBHpeskafNY3X+28LE31s98XJs?=
 =?us-ascii?Q?NYkU8+2DWgdz7tXiIhR1Lmf4tlJC39ripIuNLef6apPMsdyfhuAjn5f8YIXT?=
 =?us-ascii?Q?LgwvNQcioUVCRO/NOuZbid+VfStNxBWCEz1N8e07FDHeHSDsjPxa/Och5iA6?=
 =?us-ascii?Q?5JMd1YpsfIQKv78D4e/ThL+sBgnR8n61EBSje2R2pB5KgGSohsnBu2/lRdhw?=
 =?us-ascii?Q?M4zT+3Ih/3UXInCNIgvIzCPM8ScePOJ8oViqrA35lyHtwPVTNFCXfC99hrer?=
 =?us-ascii?Q?iPL4XyL0dv6GI90ZZ8w/8mhVq6QnDVNQcR8Jefsf3lPmf92WUq3+pI/DORnu?=
 =?us-ascii?Q?DLr5UiYRCNbCXyl5yiPZhMg64JoQlP5IDVV6HDCjZ7ordUQuibdEhMvRje2g?=
 =?us-ascii?Q?d4Wz/faIPHVa5iTfOLxnTVaP2RRkRJ6MIIIZXU78ans4YzWtGMUQyrF+eNlN?=
 =?us-ascii?Q?mZd66v6Is8eFEBsK0GgUBuI4/hquMoQZ6t9lyFt60apNo3O27UoHWjJRzjVs?=
 =?us-ascii?Q?62ZqtYIgOcqlFCPMywVNEmaDpTz7woOLo+6gX9S6Y3wxmDrcpRXVy+Dgv7hm?=
 =?us-ascii?Q?X5khQrgH8jD/4UIToMEFbxNAzRsLXTNzHy0Kzpz6m3nURdXQ00JS0mt8zg14?=
 =?us-ascii?Q?mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lK8m3b1GjcEeBq3vxy9Y/rTF5ta8m9DopaPLNbe/3Vp9riof/56BXNa/qG2b/34k/sgSLXj2vDNGuK3p8H4Bmisif1uNoFGy/ZSdCsYS8UcuR8qq/RMOUHeDPxF6L6dUgeVbHCpYSmQ1c7FAIXcg9HwfrY2LGI7H24+ePd6S3dfbqxYFxXlIfTMkFH+l6cdRmwlL/KBh+1hpHxKlqcaPKHAwhVsQGq5fJBoHaKd+A7fM/n1ZT8825G8jLGRxdizk5wiBAVDIofcTIZ15R0haFoKsje6AztEFcoIE7Vd5FZTPvPvtFCrrqzHzoOmLw7Zu3xemFb5tyRpo6Zxzx4Qn8Gzyyu7wy/JqqlL0uxGR003rQsigyPakSZBREFD4TERM2lpf6Ngx1MA2DbtXSprw7vG7cglCGZtPEM6F5mCx50U8ecbd/Yh5ARhBZYCgVZ3J9ST7qqtdcuS8fiWg57hjaRLMCn0j/h27B8BIF2WdV/Ut8aYDvsjdJOMNYFMmVPuodpWmVQ9nVYtphX3hABvVSk3OXi3SAy82Riyc4Dxi1RaZHEJRselNaiL8Evh4ps0KDteYWvvfeoioo7pTI+5mfPvLUzRNwaF5/hPgn65g+00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613b5832-be27-4890-479a-08dd81407bb6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 01:53:31.1113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUuNfeJmK0pCNzCMyYFNRQlnw86+8AFGaeh2C6aW6ZBJdkChPngfuBRlKSJtI4VjpP0+qERDTOhmcBViAf/ZEbAsBqolSqXAozT5gXkF+AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_01,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=602 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504220013
X-Proofpoint-ORIG-GUID: CwTLWYxp2Xkr0qU_drR2yjmbvhCgypJa
X-Proofpoint-GUID: CwTLWYxp2Xkr0qU_drR2yjmbvhCgypJa


>   This is a batch of deadcoding on the qla2xxx driver. Note the last
> patch removes two unused module parameters, so I guess if anyone has
> that in some configs somewhere that might surprise them.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
