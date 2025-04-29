Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAB4C2D1;
	Tue, 29 Apr 2025 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890303; cv=fail; b=bt+/qjiLjbcbc3DLiH/W+2grTZ/ckzE9/FZG5mBs0/mNrWzL4e29hyQyJNvAKG6QTbFK6x7tPYc+CdJEH54uSrFrXdiiu1+Vb8U5b3kP6F8IjDtE6C/eCIZkBwoPhjq8U6FPNnode5HzxcS3ccLtWM+uwRsNBHlfyCZTz+77xYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890303; c=relaxed/simple;
	bh=l5V2nPtFvdvQBw7oYzegAnJZefVxNxw6sBgtCAlQQwY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jZGxxH6R7/Z5AA+TDBhAaMBUscop0Jux2Hd/WA5YOXWFUbC2Tv3AmNe3T37zVAVZIFXXs0aY6QDSib7Gdstx0laavU93PDYFgGNUOVhTdzItSCSjDwt27NIARKp6J3xD4fQDzEUUntwe2KHig9RKFlTv56M03yMkCrH5Zxslw+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JVPttgzG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yucW1dAV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JVPttgzG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yucW1dAV"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T12IDL014079;
	Tue, 29 Apr 2025 01:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Etqs3p7bP6oqVa8aMn
	y0VJTZveydRFqB7BGm2D5ytKE=; b=JVPttgzGIdWQw+RXCumd6BGnakkL19djsb
	J7gRAwaP0yiO1PGWW1LucHoQ/2m4HeczpTK+ULh22qLa0q9wYD3Z5xMsbhOQ4CEq
	QywElPqsVN/VUVIqsQf7AcZ5q9MpxTE2XbN0f9P38u+c8++grQgdqCp1BpAzqTRO
	5Rh65rySnDKSQZGsbLjXHeIp2bBIBNLGBVbfwu0I/tObXAE1PLom3iWj3MWJySiL
	hEivlb9WFTRcpwEM7EuH1SevLfc83xIZubzRYiZf/kl5fqRQrEwquVKQBpPPxgnu
	lV0bdakxPW/s8/HWzQc70XPeSCMJiW9aGCuZyfBflLK4DHVbQEfg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amrer0px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:31:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0ZA4D033376;
	Tue, 29 Apr 2025 01:31:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 468nx96p98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:31:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PR0E2UGyYstJA42ReKJGlSUFq30oM7+D+aqKbPdRWq7YoQ2iMyHLTfmqcQsmhC3/UrXAyjIStdYtTi9Z2g7Bu5hJwPWF03yTHn610r/KZSRahxnRdGn1bWZAkTiQjiAsiOFOWnLsPuHC3WzX2Xdyv7FnHSzviNEm1JN4X/+E2/03x6NwfNhwWCqATzGplagOkMLaVdei7QNqpzz73o8h9tIGgOJKAVyogQ9ObEUuPmquyvh0jFNW+ETG4DuSomdSVs51+P/QFEl+FA/mUlC1NOpsgA8UZnwcSGsoxhYEl1esv5oDbhuSyy9W896CdT1th03q9rBfgkIr9fhAiaPodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Etqs3p7bP6oqVa8aMny0VJTZveydRFqB7BGm2D5ytKE=;
 b=spI2kk8UNiv6YCOoPOi5HO0Mj4R2xlBEUJEhl58Wdk5sjm2WZzUU7p0QBYWhGGy0xqTFPghl4Yo3T/oVsk4xoTMYwFx87kILhItjDJKvTL6PCCB6lLPDHTIMuUMcrwAKzkGvLfrGLmsWeCwXD9rWt2YKt5GHyfAWSD55y/zhtasDl4MGJokiGhqCZnIe8hHqz0wapc2K9BwCHTFYFWmbe7nu7s0vf0wfKTJRZlUG1GCVxmBzEZI92+f0nS5hR1OZ9ugbhGer9oA8IyLlu77cZtkmCCk8qyyBBVNc8+hajxZON20vaQBJ08o5WgRzh2imWNOjMk3MoQjfQPTOvHAsng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Etqs3p7bP6oqVa8aMny0VJTZveydRFqB7BGm2D5ytKE=;
 b=yucW1dAV8oGeNXvpVry8tn3HYKFBBHTN1vtFda/sgJti0GC/n22Xlzllg6G634Pdilx+2BLT27k3C1Atb6lJij90rZp+83fyUJeB2HcJjtgY8Z8aeJHotK4lPCHWnKpx0HWGA77tED3nxCJtpi07F67JbIDwrtY3K2DbwQyTCog=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MN0PR10MB5910.namprd10.prod.outlook.com (2603:10b6:208:3d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 01:31:19 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:31:19 +0000
To: Kees Cook <kees@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove duplicate struct crb_addr_pair
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250426061951.work.272-kees@kernel.org> (Kees Cook's message of
	"Fri, 25 Apr 2025 23:19:52 -0700")
Organization: Oracle Corporation
Message-ID: <yq1msbz3g9x.fsf@ca-mkp.ca.oracle.com>
References: <20250426061951.work.272-kees@kernel.org>
Date: Mon, 28 Apr 2025 21:31:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:408:112::13) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MN0PR10MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: d8401115-6dbe-4072-f57b-08dd86bd8ae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BWoWoIV+nazdUEz7HLyp8nQXmOTTXE5diy+JG8rqEWforG9g07gPsL43RGJK?=
 =?us-ascii?Q?ukdmb8vVg17GBV0DfFIeqdlalqxWahxGH2FrlM0ngiIkrAwH6wfioIeWwnr6?=
 =?us-ascii?Q?G6jjn20zfltKfduy61Uxoy2LMUaaB2EwYVLUlpzRSNW0s6NG5izpkVaNZwl0?=
 =?us-ascii?Q?GqHc1Gx9cyAcvMW1B1AkeBHVzS0TmFthdlvElK6EaadGVbFvX8MNzKSz/Q9/?=
 =?us-ascii?Q?G0fy1rsZ8kb3S3DKqFjXb6XnFJYNV4agjgRkAQuF6TKpCytAwwPDh3yNvlOO?=
 =?us-ascii?Q?aU7Kg7kf1bQOeDD30xq+mH0EM6k5BOwD3nS39uJAKbyb7B9Z3SJzyTjtKkp3?=
 =?us-ascii?Q?AMTJEBAvcFk+HxP0Q5gWw+pN/uOaDFbVOzknWCgk/Cu7GFd9NMPtQImpXtgh?=
 =?us-ascii?Q?j70l1+2K23ySQL7Y6u6s6mdAyvfZVQFR9W+Rrfc8ZIlJmU1VlS1sHZ19muH2?=
 =?us-ascii?Q?yYKltiqPgzc1Vb51pq3vitnJNzOC5XG2XrPOiqo9pjrzHKRbhorv6XVeS8UV?=
 =?us-ascii?Q?165sCo6utoruBVo4E86Yl4tGP5pKKkgPE1Sdb2uDbKpucjwak6BQ9jvHMiIS?=
 =?us-ascii?Q?NlG1wbcKwePbTYAcxn9X0vsw97Juu74Dy8DsRdqcnRm78A/nynWlO3pVs9EN?=
 =?us-ascii?Q?Gy2eS36+6jAQFzOHmMhPcZZ6rZdp6hriQ6vKgbUSJkpGDX07WqL0RP/g6JnF?=
 =?us-ascii?Q?kkxq2wAbni921pnzF7cprbpeeS2uHo/fkxkjfqfgv7OlE3YBiYPNMsSjMADk?=
 =?us-ascii?Q?vKNyeFENeP3Kz8hFn+eUDdRTvJWuJ6FcTC5CyvqGOzVZ/aifa6HdUlf8+YKF?=
 =?us-ascii?Q?rzM01w/8xXCEb2qE3oyOp7bSon/IpdixzC3OoKtPWIZ3VGsGOoC8rJ9OO1BK?=
 =?us-ascii?Q?dcMbjTC1ndioXWSIM6VU26xLhyxcF371CQNHPvoDkNnNvgmphZaAgdl/Ra3V?=
 =?us-ascii?Q?cZWCZFA2pemQTHeykhFdyzz/z+IKArbrxdRzYfzwztWi8mUik+hanm9DsR8N?=
 =?us-ascii?Q?YkkFczi7gj2yME6TLhId6NWyyKnM7ly5U6RRsr5uaDtsMRhsa2wZGeww2ueA?=
 =?us-ascii?Q?eZIjjcmh6AYYhBkGFo2HOrXVOgzqwKluaElxJt+Y3YZPYa6avkNszToQomjr?=
 =?us-ascii?Q?Oyjdp5pYoenix2TGOdaPE+djHLqqXiZMU75fE3jL840TvT8oD4PIAd89eDOL?=
 =?us-ascii?Q?O2/q2SRsB8WwcHcVR9IlhHcCCaB5nRcYmT3SefReiObPW//gOzsqfZ7mvFyB?=
 =?us-ascii?Q?IZSLlyQD2eqF5cab51hLlhPNOkHoKH9xN94D3RhfIiAsolEXRCasIVWs+wR/?=
 =?us-ascii?Q?IQKWwZs4WEmGrmIXHYhV8B9rh4nN0w14TOxewrfI9kOPgkz9npGetm2SicTR?=
 =?us-ascii?Q?bTW4YEKKLcOlS9hLQ1HLiXe0ZKeshXHRHMZq1Lqiw2FJEEVsmtRxp1HUOzAm?=
 =?us-ascii?Q?adzjCWloSLE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x6fx5NgzoO0Ou2dC17lYm+CKnhROzbsvkKjuTzgV5/HjTejuXV6uLVQqEGHe?=
 =?us-ascii?Q?qJPfJtd9IJ+uEb5fRiBjGUz1aM2tl9wJj0bZpkyTgmhr67IN2+tqdynZlp21?=
 =?us-ascii?Q?Jg39faDNYglABWGTds/iFQyn2ra5IoSl2oweSKSG25EOrMNv5qWARaWlyaZ/?=
 =?us-ascii?Q?p1Z1bMfUrFNZ24OqLQtU+qn7mESHwWV5KalwVGBc1N8aA/FlBCqha6ey0wDs?=
 =?us-ascii?Q?MJZHVaQdlesZudukEv7kn1hfrhKN8mHFNNyK9nLQdXQqr2vq7O2vYAv2Gzri?=
 =?us-ascii?Q?Z4ZlA/BrTDQw8Uo11NIsgnkdfpeXHSpUt6nLfYKjK6tNMyJSxy30gBWPsa33?=
 =?us-ascii?Q?ib1k7oyQtmk8uTx/HwtG1K0PvZQyZldVYNm4+PRiET2vDGwCbr1tNej4NO8t?=
 =?us-ascii?Q?WGjf+yeo+BaR4jYG8OfYpKkuNIq3PWCOk2W1qGRasDViPabEk+FU+59ChM06?=
 =?us-ascii?Q?36PA8jvrvxjY2puJLFuBizbieKdJlLKhLpS2KtrcsAuQd8RU8cIeiA4U6Zst?=
 =?us-ascii?Q?tHMVOxvH21ExEkhKJ9QkcrF2rXBJnyypZ4YhhmxJwtDBcsCWGy+vTtSnoM0p?=
 =?us-ascii?Q?c1m4cAKwJtwwmRRd4CEnvNijRf0oKLfWN0pc1BMVKFmQgmUI0VYp/zSw4MZ9?=
 =?us-ascii?Q?xPapB0tlSjpd4Ml55TiNjLEqpgM5sl8f2DtjGFrSmta3RTXZ2AGfn3prUITa?=
 =?us-ascii?Q?xkivJsnJTyfHhh6Lo3dfEmYIu1iJQ2VXb29v27dRNjvkyfU1+6e6llCGR0Q/?=
 =?us-ascii?Q?kIYgjSpgEnyu/hwr42Q83JSjoq+0XmlIlH22wKjdM/D2L2nwx+cvMvUvmc48?=
 =?us-ascii?Q?nRA98fMdQ0Ko2iemUZX4erZhGFPdkRvDaZtxPWerAZMfQZ5AJmAUesnP39hK?=
 =?us-ascii?Q?IVddjLcof+l/ouHWtpWMSQZGnUIYz5NgpsYdbva8qq98xN9m2uYVKkyqYkSb?=
 =?us-ascii?Q?nB9kg3TktP+0u0/VdeFWwwyxz9/yCaGsVmzVFxm+ft6PjZGVWhpGKKlQ2Oyo?=
 =?us-ascii?Q?IknG/8RmvEs3yeJpDLS9keN+H7yOEa3/47q8siTw8eIUzoCFv8747zPiYw8Q?=
 =?us-ascii?Q?o1mwx5aR0gyALxCic1nUqNkxC3Jb9CKft54eqNJbbJ03XAQtWXKBZ7KZs0hg?=
 =?us-ascii?Q?WEWmvE0ZBR5lNXgGQNC9sQpZBeqbG+OGN89L2cf+p+8hrBWKUm1wYbJhR9Lx?=
 =?us-ascii?Q?I8yISHt45ZVGiU4J1NpML/YH+xJMcwhSpGzElAlN7rchtVFmzMeOLko+EPqH?=
 =?us-ascii?Q?qDNGzLsuL91uGs283BjNm0JT7UM/XHUuGgA1op4xRhoh0V9Qp/omJ2YXEA2X?=
 =?us-ascii?Q?9priEM0vVeOsTD1d+AJzNMVWKfOeMLlZGpNsJt7L9remBuJBxQ0Ioyfgq/uw?=
 =?us-ascii?Q?DBltx0l9+4/YQAKgjLvHQLkBC8K5d5ETktj2oHfZfI+MWwNCIEwVHCyzHGJs?=
 =?us-ascii?Q?kH4BPc8tYRIDQzkENJmq3sm+fclDspUMHDdEHDbWeBqEy+fxeIk+uuuVsV5W?=
 =?us-ascii?Q?iBKZTPB/h0tbxMQpn9iGw7zy45KRYHJS1ilJ2O8NsSPhotcPkYQWJC6cmlqL?=
 =?us-ascii?Q?6JEoi3C0VBMeQXKyluX+lfIdPx4xvix35eJNv5Pz0NDO3NKtvyekhoz2SLVP?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pK3DcotSvYHEVr+B1uefk72+o1oMJr9pPc3q6dFoeCxE8glUjMkN0NyPe2wB4//orYCX6Dt/jC7eGp3Rvo4eed1NHHdDnFDwD7ZvKSbi8etFiwp0etDOLON4eGRIEiXdvo5cH8B9IYodBeAtaWNvG178VTfAdlroKppUcNIe7OgvcgHCMBvue3cK6GMbc0cO1zClaKQBBlLIzVIzhGG/M/Fbbc3IWW9mvqK64R9bw5SieEsKDYSGSUhaM8QujAa7RwR8402SgRetIrL2o41/RN5WmohTlvEmg2RZSDF27a/hEPw4J7z2krifx/yWiv8ItB7WW+Geg3Tgz8One9MAsCFDwxYubZQ8/lob49xo0ROV4Oyww06p5t6cI5cUu38nNZqHonlh1fg97mYeZA2sJgFvfa2x60jN8TmQxTqPVo3A/QQWLHetGNSvzD5IZTok2lYXuMqhA0Gl3XvcOYCFMcI23d9mTvHnVMBURXcpdWW03dJ43l6OgHCywsbXl/MFlDDmP3xl0l1GA8ZHtE35Sjd1817cybcjUvDAl5y6+KwJEhFuadV4HWQSwGTau+K7bry5Ad7mAjtP786Mc+ORQp56jJSKPdS1RZP2ROTKpTg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8401115-6dbe-4072-f57b-08dd86bd8ae6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:31:19.4789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yD4FuC8cECK6XHDf/FyjrThG4qSFtMa4XJrjzMne+k9FQ6undMdTjs3T9lX2W7NJKZzwmZguuCQDLlHXbtaPMt+e5ZZ5b1FDx5a53ARmYvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290009
X-Authority-Analysis: v=2.4 cv=O6k5vA9W c=1 sm=1 tr=0 ts=68102bf8 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=cNMCkp2XhuoQE_LABBQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxMCBTYWx0ZWRfX1zQa0rwhMvuE 9slqfO9b/3KsK9NGm9/meixubSHoTWRiTh8tb+YVK9dMlo45I7nXNM7Tn1PXEDYz7XUSgyiQ9kY 6j7oAag8E/d9vxviGEG8RTd6O7bV5aAQxF/H6nhWIs3KMTCEs9EL9yhN3vJ+AF48DRh5nt6JO1O
 AYIxAlFOBJZDliGYL2Zax2/+MbDJ1HUTRXc54Qgu331QpOX9Nr+4jNSkqiBchol1p60peyNH8yb kMl1Nma58o+i+nqK0yzrpKztp0cRMniP0jdld0Ttjox43xvXf69Z64Q1nf6Na4s8Uk6fRqzNn8Y iDehaxxNp0Qu0dhJhPkMDxnc+GEVMn/VYx14hZ1Mebw1CGXkWT6YcTLLhcXSObYx7cuki6Bxx5b pFFWsAn3
X-Proofpoint-ORIG-GUID: cOR541ZGPN08zC5vdX9tptpmlIzPhsKV
X-Proofpoint-GUID: cOR541ZGPN08zC5vdX9tptpmlIzPhsKV


Kees,

> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation
> matches the type of the variable being assigned. (Before, the
> allocator would always return "void *", which can be implicitly cast
> to any pointer type.)

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
