Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC2433C4;
	Tue, 29 Apr 2025 01:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890145; cv=fail; b=jEgLiO63SnK7GTWataDbYEegeym/IuMYLAT/lZjGx2b1VOmrhVD+TDUcOfe1hnQH1Mbpg59/ksQ+7SxCNhV7UJ1/JF9eIxkbK0P0e2xndX712/W8qmp5+hJ6NWkHZoaOBczInWZJagEaWolfeKw17Y/FKbWqGxdP960/fEJ5k0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890145; c=relaxed/simple;
	bh=eIGSK7AKBr6Cvuof2V5f/9+Z8fayRlVpFsfqD/PF1pU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KXyrntn5hbQF76nKAIlv6pcNFF4PNQ4N1Ozk9K5Z+pxzZLqQ2ISt83ih3J/FxS33AVyZb27vXamHk5Wuc7nR5cnrjLowoEmzfqwP3MJb2S6DQuwE3VniIi6XvNynTj6RA8Df0bphD+lCaXXukHGQejSYNtefAz3r5N1h6DPICM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jRtAgF5v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Be4GlOG+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jRtAgF5v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Be4GlOG+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T13Mn3014327;
	Tue, 29 Apr 2025 01:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=0ip7e9cMOdwwO6P4OZ
	0q2ibUPca9x1mnxzmUeQ1OUMI=; b=jRtAgF5vsH4aMppUgRRUzb1UUVYA5lrpCv
	hbf5bR2n/sEMgn/EGIHyXOQ6L/YnrcPOyp+ayGcIk1fGCfpAoCdTUd+/+BsTIJV6
	qtzFRgO3jhM+mvBuX97kYPnoUyCEENHIMYUubP58T3aQIxbRtrNV18lVHC0Ri2Zn
	SwXVD9EXb3pE1SQ6muZ3iYF5Mdk4n4XOpAPdsFsvDSjafJ5uS72Nkqjy1pgFz4J4
	qKQztYHn4Df+12msxtRjLgN62r5KHfFCMIGrMKZh0FEzLGMAh1ubVU0FQmvVeADk
	d4UEJFLVKp7Lt9X/CKHVhQMRpCGVpjCbmnY7b4a2xw3+GIPhxg4A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46amre00mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:28:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T0Qkea035348;
	Tue, 29 Apr 2025 01:28:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx8xrph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 01:28:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BC0ScS/YYwQ8TM+Fm3YgpNfYM2Vf790lzwrzKvjqcE8lu23gfnNMI5fKNyGJlpqrSuYCp0G1G0ffzrmQtQ0MmYrcgtjkaDJEIBUcY6O+BvAJ46RGKDC9549MyKBDNQiGshBG2TFEvgE5U9qCkEOLCdflmKePyffkpxA/K9LgcBALTCWnP8jIk+UkvhL+Jp1qhydtcXymfMKvZoQZnygm4AWx5+PMr3OBOp5uEhSVcxJMbrOOFUR48vmMnU3JyHGwTomvhbmfmPC+/DS7Prl5fg7NwFn5rRLsLr9wKVAskSHORvx/jM1Hu+hSdH9i41P1mSrC4VZS6uK1qapoLsGPcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ip7e9cMOdwwO6P4OZ0q2ibUPca9x1mnxzmUeQ1OUMI=;
 b=ZODNqPUKESMRDkbDuEPaa9IF2RtU1s6FdSzCOf4YOqr8FRmVzFGOzZhwH+378ZH+YY1P7TpgShS60rnKtOBWcdlKf2EMiW/wRQPdOzN9ucWqqUmOFAG8aQIkxpxQcbcEeoan9YUrANrt1f/z4sBrW1J3So+EVZH5PJjZmSA3BJEcni2X9dqKxBWWDeXX9f55+eeakJwAHJRtu8suj5MF6e4CiN1eTYJpHc+h387xU9R6AuoYMTUvAgBRsl130DSarUA14bTB95e5fm1pMkWkHrxNz8NN6Uly9ietW2hsaJXVfB/i/yRa5hZaMUhSFrPrNxRrXjyDJyVSKoDyctGstg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ip7e9cMOdwwO6P4OZ0q2ibUPca9x1mnxzmUeQ1OUMI=;
 b=Be4GlOG+hYCAPeyfH4lO9neAgXjUL8QdbqAW2628tlKcRxTbstHuW4KDUUWJMWeTDl7QLyIujkcQgC8RXPe9s7ne9W35bnkJ0ggX/Af8AIqEmZNbqtX25/d9+3vzpsJsuVMED7iY6ILk+bNi/PfA+YpiqTqEd7hRU4PcIo2TMfo=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 MN0PR10MB5910.namprd10.prod.outlook.com (2603:10b6:208:3d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 01:28:47 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 01:28:47 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: James Smart <james.smart@broadcom.com>,
        Dick Kennedy
 <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Use secs_to_jiffies() instead of
 msecs_to_jiffies()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250428171625.2499-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Mon, 28 Apr 2025 19:16:26 +0200")
Organization: Oracle Corporation
Message-ID: <yq1selr3ge0.fsf@ca-mkp.ca.oracle.com>
References: <20250428171625.2499-2-thorsten.blum@linux.dev>
Date: Mon, 28 Apr 2025 21:28:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::37) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|MN0PR10MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: c0bb8d8d-2598-4819-7616-08dd86bd3070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HEeU2E2MgtQ7v1ZFpYXj0e+qwFadoXAFtZXxV7oVKFIoT3f/O4qWVAoHUElU?=
 =?us-ascii?Q?ja30/FxG6ULFgoaO/6Cb+eNRQ4+PVh1ZjOFB6cvRDXvZZOInfmV9qvSkqf7L?=
 =?us-ascii?Q?TAOkuRxsQqc/vS1ImiHsj6pGGnvKcgToDNUZIEPpYPIca7gtj5c9gadbGJPa?=
 =?us-ascii?Q?4isH+flZxg5lvfLa1/j6jAzLirjo5S1bM7JXWBjx9MMrFOAFOnshdYOb+vu4?=
 =?us-ascii?Q?l+L1hiPv3mQGl7/+tQ4LHA3ArYrpXxpUBsdnf766AgQo+Rvxk9OskuVJvmQq?=
 =?us-ascii?Q?RmqAlP48YIFqn4+jfAj3o0lJAyl58Z0BVdVzDQX54APbh3+g7UGnSt9wTgbn?=
 =?us-ascii?Q?ouiJzw/ilw3TYip4cdIvnwdBFtHaYvCJy1Iw7+NYusrtKYE0TaM3fPFZamXD?=
 =?us-ascii?Q?0ZG+/aGKtiVxamA/1GZ6Lpx/Gt6EDDxRYgs8aerM0uEPfFiYnxAfMcZrW+9t?=
 =?us-ascii?Q?Tf2Edr24NWO+Rdmh+PON5zK4PXrZMoeLVYSeV3JkqRIdUeFk69/5MHn22bH3?=
 =?us-ascii?Q?2ZFJIw+Lo9cRBq0wlrjd25w3ZyZ3NW5SZ/3PRxcSyxRsPnbpM/eoF/cKEcvq?=
 =?us-ascii?Q?cyjvvxCkgzcLty+5ch4tLx8F45ZA/b/I4xg/BHn+rXLQ9pjzqpWOOj3gqTXZ?=
 =?us-ascii?Q?t9TAF8a7JpKQ1cUd9Pgs93PgCKQNQvKootGQspjJmikeFF6KwKCRhSz6FzuP?=
 =?us-ascii?Q?ljjqi3rRMoiVQCDUmwR1ZqLsJlUcxC1zrBXcnHkAFhDNkZulr8609aOoJD3o?=
 =?us-ascii?Q?E9wtDUMr8w2+3uXSQj/hDE2MXTDLMRiq309J4pwj/O0+0LOcgbhvc7vbP3Yg?=
 =?us-ascii?Q?aOuPZXflWmOmsBbiE8cgO/pxAnFmY1+51YR14Cmue5doZ93CVJsoNrEScD14?=
 =?us-ascii?Q?SUTezcFPL8DM/tgNSveElJlEPawcykQcQNvnJE+Yp+neR6zP7QnS90sPMBGA?=
 =?us-ascii?Q?suoLNKLNgW2o2idgdbLXt655h+jmTPSiUM6TPmZE7M/L46Rzs/nkS0okgKke?=
 =?us-ascii?Q?hVYussdnsb1UBrMY4NoNQ4XqRu4jRi8UbRJo8CAanR2ddmIlmExAtZWWw98t?=
 =?us-ascii?Q?11rDg6GLYJXvet2Hc/GxQELIS966VnqFUofgrCmIe/M4tj/ELM00U0OqgBmk?=
 =?us-ascii?Q?KfOczLpqsURHcuRpjIR7CHqVEMWi5MocURtbsM8wHvP9CPfR2Mt+cebTD57J?=
 =?us-ascii?Q?ofWH/VSeHRXgjOQcyEimqxbVjzY2xw6PVAgCiyCnQ/jpsaI/4ASZHY1gaElo?=
 =?us-ascii?Q?4PrRhOw4T7hxEdBvmm07dAYF7g/HCAWWqlEg1SSA4Hqlsl868S4DVw8mIflE?=
 =?us-ascii?Q?DyCnqFXpW2wLdbA5475/1/IjtnYjUetvhgqUdrXLHtg0gMyIsV+3RWR18DDL?=
 =?us-ascii?Q?IrJNK2EbFo5MvIwY8hkzxjyCiBFUP3gI+n+McXTSF+Z/AP5H6A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8I6pxWzup5DqSrlYRZvpWHqobFB3gxHHHyVZmMjlYy2b+Z1HMq1tSoEFJqCd?=
 =?us-ascii?Q?xd31ZIFrHXI8lif4aFc6VEAng0MoCzhHx8D4I2akUs+Pv98ewNJ7vZwt+QYN?=
 =?us-ascii?Q?DNxMgigfyz4HTIiT/29t2htbpbOuCyXGEAQblVRwe+97UaEeNYSzIJTfmwTm?=
 =?us-ascii?Q?6/Sl58o7GFV6hYSPChXIs6bDF0ARdzLqx1Z5t7X8fVExYjqtpigsC6XoJJvN?=
 =?us-ascii?Q?D4wsosK7A5UNEtrSW01uo1D9wyWJRvFcTP2ZGHWki0vp9fSWsSK0tFvJ65uV?=
 =?us-ascii?Q?JZHDX7M8jI1AH6lWCqax3j9ZujbzmHfQ1kIugBzaxK8bDqwBvUzFA193EDXI?=
 =?us-ascii?Q?/yUjSTfA5U+iT/Q1RENxoVHgbOf+XrhqOJPAXZBlzc5owZ6s1uy5Il3QlSz+?=
 =?us-ascii?Q?vt/DsYb01L7x105IhNr7/CuC5Iy0JCO9Y1BXNWgMlPHuRhwWxP3mJkL/i45h?=
 =?us-ascii?Q?ZFs/oTMEdnXjprG+U367JKSnALpCvtJ1dBnp3HSs6DrqS5RkewjdKB5+MBrB?=
 =?us-ascii?Q?mLWSo0ltCNbjtT+Uy2wydTuFjkh9GpQlEp1qLmf8al3avtEtD/mHM0PetdlO?=
 =?us-ascii?Q?sVy0wO7jCB5u+E9v+Ul5YFV7Hpomtwq7neHvMwmB+jnwdaYR5ansfMFamfQG?=
 =?us-ascii?Q?gHNsOyYuybfelj1aYc/PqcHk8L8dARZ1AOrbNrjfJsvT5HnfcI5UOa2Gx/dx?=
 =?us-ascii?Q?PydQ0cWRu4sjh6b3S9mWoZZnFXFSYC1l5tdRzIw3JZiKYZTbk3OzJUO3tZu1?=
 =?us-ascii?Q?/a9bLIFifGmc2FRbsq0cBTvjiDmyr3tDIymd44p1x0djtXwIbXv4usikqDxO?=
 =?us-ascii?Q?3/VSiscGhHplRWLPw8p5nhNQZBd0gTDC+VHaycWZh3Y1TmV3w20P6tGdLtze?=
 =?us-ascii?Q?jWx/QrfA6nmK9RFLKjklHINVD6Wn+Atm7WKOySw66lz1Nxlfjc6AgARRMpO1?=
 =?us-ascii?Q?++43YOs/87z/7ceH//RXFDovGP1bI0P2owGffMnV+udehj6SXfLIk9PDW43M?=
 =?us-ascii?Q?/F/CMAV76O7B1irnZYdiSnyClGp0RmqiZZg4vHGT/eMe0InllpzgEe4K6HGl?=
 =?us-ascii?Q?C6M4TnpkMXnz9ZnNLo2xTq8P6FU8EstzgDDX5rjIqjSYkaCRg4Ye4ALuYXaT?=
 =?us-ascii?Q?RTsOV6t9lj2MQJ77UnBCbQ+tVefw0/V/3KG9hZhaPPCMTyNbelaYFq1QzXh2?=
 =?us-ascii?Q?sjBWLSqbfkF8EWrtWuNPG6kkl3zVfwEPmzAADQXoh01XPJHBYWFpmrTkZh5b?=
 =?us-ascii?Q?SukdM+txF47rxj9UlY2sWpk3sH1fI9MZ5606rrJNCNunQgWQ2jghLGAhbEih?=
 =?us-ascii?Q?0GMtkgOu8JL5TPjIEtPTOzGwK4PksaLfC+9USacGmi3lfWkAPlrxv62APNIH?=
 =?us-ascii?Q?Niv2uMoh/8UsGqnjTsNpQ+Vy5qm9amPgzazIbb/HYleO1KIWOxlQ90IW/o0W?=
 =?us-ascii?Q?0X2ve8tgngMbxesKddJwJ3hWiZRHJD5iP5+FA3yF2DwNShHC8mEmxn1vsQVC?=
 =?us-ascii?Q?Pqd0oR9d6SpAkWm1l2K+DgeZmtd7PgkjK4iHYskb/dANawXyJ257MWsu6yxf?=
 =?us-ascii?Q?9eu0PAag+o76HJsA2xGTGlRdc5GPQMadXRMmE4MZG5Ppdz9eKKu0+lZPyztP?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1qkrZA9yb7krdsT+MXnzvTVHY+rlSzNXmp6WGbLgmaF7chvrn03TAKu6U5Hqg6omXYJUjGWed/hIVsJxqHd/NAxCNLZiVA1hN5HWZsmIe59Qk/FWBvpBOui4W9nYUns7YPt6YIWFogF+1XecPycUw21B6ixWCtowpYpnucSzmsBIIshkslXquY9G6tKxyD1kDs1CTV/xu2ziSe/eSkAy7SvkF7WZleyQyhKw4UU1Qv+lsmhBbzEijR8ywBB8gxEIGCFh88fGs/Xl83anGtRB7jcCq0gR2amjg5xzDbfErEVZcTGC8PubJkTQNeWlp6ahqDL91lbOcxskD5QzNQcgKzstyGSXpJOi2ts1ZQY4GW3LYSB+AGkCAyts3NBrZwtTg1vt6RhUX6TBv/OPCyeJ9BwK4+TXmMaeqSrI08G4ToO+8F+dIizPVwA8PmjepOdgXuR2GPxb6SBsir1091r90yjKKPO6KhUvY+l+XqW93jOFaZPKtRfbz12ETql9f4IZ9ZbbtXicnYLK5+HvuxEx+RWdaQK2VV+LyzqvqZG9zW3xIE49cerXi64UB7JYCriTXjaYIDZB3RBtK2wQsWpVJ8YaCM5N8is8QwGjfhInKsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bb8d8d-2598-4819-7616-08dd86bd3070
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 01:28:47.7048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wvtI/1FyZ83l3TP3oEM9QuXYiAdEzpoL3EU5+CuhIBso9LZvJCjApPbJyIy6UGVRyVJ/rfYn2Xbe3G7jT3uYVc+Z6JYCS0daQChLYbZW5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5910
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=822 phishscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2504290009
X-Authority-Analysis: v=2.4 cv=d4/1yQjE c=1 sm=1 tr=0 ts=68102b55 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 a=zZCYzV9kfG8A:10 cc=ntf awl=host:14638
X-Proofpoint-GUID: tMCo6hnSl1vAbqbEQQrnYR3pVb5BVB-3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAwOSBTYWx0ZWRfX6bJ6n2BcxSOW br5MiFJ27rqiqcLOSualrsmCCs0MUbMPjpQmjCSGN3F2/H1ufUhBzAdOHgu1jSNkbaNuXPY3bXP 3ZbSj1XLV7D086JecJWOq8rw2BftCcIhUv7WqE8VrqXKrQWBbPPPvPZMXLMDStk9MDb1dH/zK+n
 xm5bp7B5icwL3t9wNf1As661s1nJhIaWqYs/4ddRbyiVNdshvICFrOVlV/ep002ybM95c6WbwCv UvUTlcLrUHWjI4yo0mwXFdXDjAv5FmgOAdBrKeVObDjOBl6dT2uuhOkZe//YOMPDgIqhqAmbgsq 4k7DxejDnSBUhYk98letphwAmVJ1+PC4Y+TEcHgalcEDoTh0owdUMkRjq6L5QmHRbNW+Gh+4Gs7 BppLYezx
X-Proofpoint-ORIG-GUID: tMCo6hnSl1vAbqbEQQrnYR3pVb5BVB-3


Thorsten,

> Use secs_to_jiffies() instead of msecs_to_jiffies() and avoid scaling
> the timeouts to milliseconds.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
