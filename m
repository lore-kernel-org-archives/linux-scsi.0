Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B42310E3;
	Fri, 13 Sep 2024 00:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187242; cv=fail; b=kie2ZkoJbB7qkcIHlk7K4MriWsmQQTEDDOvXsAR0iTi1THuIbJkgUi9od/Eyy4uz0+Xci/TRZua94f8ZSkBjQkwoZMf0TEV944oFbFVIq4CFxU/hgG1hCGFAj5F1+eCGQIqx388EOnReWBNz3fzqFMZi+4Jzhc6o/4c2d2hHyrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187242; c=relaxed/simple;
	bh=SlVrECQLiByE3zukWsYU1uakexcZPIVIlVwGsmmEyxI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BZw3SOlBJ4hN9be8sawNvx01DbVRiPk7LrvKLT7c7lH9u+nNqt253i2/cPKdf0h2WGT+QmGNxe5GD6yi6H30IYeo7Dbkbye9TJUKs77mpUZqVvDlxC7RU5V6kpBD1GWAWIPD8BCVyeLIIG0SvCcWnKAk0oWH1Qm+PG0WVUFpUjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VkWePmrn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V+lsW6E3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VkWePmrn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V+lsW6E3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBf8F023325;
	Fri, 13 Sep 2024 00:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=NpwdP+ggFFoFF5
	hGi6iQnG+vxYWaGA6SDnNzTYZ23m0=; b=VkWePmrncL3/U25CDz3zKP3Jg0xTj+
	81MwlNtmNtnd6QyUBQrTSfxQF4Tvy4+yk0VvykOFwEs0HfLClXV4DjULYTA+71vS
	HEBAlqPOl9daP57H1CVwVA0t/2UCGqYE/EY0couAI798UlA+2hIsrLNPXEXMe3LI
	6YuUMwLfmPzDtZGAVey0xJFHH+Upd9jFZ7H6gnPtNvsChA6znO0tGNo8FnstABPV
	bWf70oD8lvW3hofknjN3ipqIDd2GHGB9naz1isWtFHoohBr9b+TjFY0mur8xbjd4
	qoFsHXaLJgGU+Pe0zN70+szHyMTsML5HmOV29sCsFmCpwUuge/OY3atw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d41xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:27:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CLVlrF033688;
	Fri, 13 Sep 2024 00:27:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c09bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:27:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BRe4gBdLCB7BI6A+qCUSXOUppnKrCCSqwawUmPK0nzyR+N1MBLUCLAOVGjlBBgtNZ7bhT2vgUAGG8kRiQYxYArdPn+osVlF98Efh4tpOdxi5BJdFW5l6X1lHz4lm1/FfoZnV39nomNTcE5uNIH83bPbce6GBkeQ4t/w2P5Tv0YXehSjI2TW9Nb5NWa6JyiiPpeVhlmIiGY30kCydtn94XH0Vq9GlpQAdPtNjSHqpqSNMuT7qZ0LXVakX4WdOYrdFekepWXqkBH9j8nxuU2c/kPTgnUwmKe3aEqoHE1SQosoqwlvJb5wWqI9S3vRcI8/p5ViS347u3gfXxjtAc3Ltew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpwdP+ggFFoFF5hGi6iQnG+vxYWaGA6SDnNzTYZ23m0=;
 b=jyQlg/UYG1ac1QbteiIZOz/h18DEmMx5zDhpUR6npcXetKSPgqekqMGXe+7giMnC8a37dJiDo/omNJ4UsF6hwCRGRq9pp8i+UDAoUIYXzv8HZLWWNarAm0mULb9HcOu9FmZVX4VvLZHcR1zsCvsbsYC+Pw+3OsFv+WVknJ5wE3EQPhPjrz3tQa3K4NkZ5RX67x6Bq16eYHTnrDlH/w6647UqJqjZNGOyEANCQhzipvMQxrhlVbS5N7dh0ny+1tCt3CooAvXDAONCmoVbWJmsLQJ0oJ6nNGnykS2Ck6gKHW0I6N9tLfCBL15AOvrhHOLu76pqnB6cyk53yHWSvSMcEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpwdP+ggFFoFF5hGi6iQnG+vxYWaGA6SDnNzTYZ23m0=;
 b=V+lsW6E3qT7Xj5JhkeP8hT+9YPpNHO5I/Yacj1H+4YhtcNqRDktjW7pPQFw6qkJ7djrVRMOssH0Mf3S8Ny2ycagcA7G9lKJ14Hk4+rBpFhcmN/7jyV+xVz+3eyeVquIPvQGDpj+GeZLfYU3e6htITquHbXHdwMv2HHG3c897Z3U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:27:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:27:13 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] megaraid_sas: Remove trailing space after \n newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902142252.309232-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 15:22:52 +0100")
Organization: Oracle Corporation
Message-ID: <yq134m4z9d0.fsf@ca-mkp.ca.oracle.com>
References: <20240902142252.309232-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:27:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0316.namprd03.prod.outlook.com
 (2603:10b6:408:112::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d81eedf-3c6f-4fbe-90cd-08dcd38ad098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?unULwJ4LcXIEO38zjocnK93nq0R5wcd0r4Te1I+CaRhM5hb4s/821l5LYQtu?=
 =?us-ascii?Q?UUYM+71gsLNwGehoi0X6FnCwruGjbJHI7JciAdM0/TI8s6ncBUDyjy3X9f4N?=
 =?us-ascii?Q?5bUlNJXSwJcnWW1sBFpP5MS3meX+/QVG8zLWRw115/vyxiJ1qJnxSM/iYJWO?=
 =?us-ascii?Q?czQSoCCHnjxRyRX+Dv9FEVgDjdEioyO3wDPV1dplWWGA4h+ruEiGmjXqCvO1?=
 =?us-ascii?Q?K67SnudIgWbT0SYHnbzs9pGJ2QUs5/O50lPmF4jhFmF82Jp/LEe6eyctnM5x?=
 =?us-ascii?Q?GptwfUURbdmxlzfhXExCNJXR/PrmzxfSl0kd2sJPPv61JNxzR4SnQY1ICv24?=
 =?us-ascii?Q?sMCxWv4PVk2jZGBC29GT5X+8/cTFzHDvpzyQRvkT/tJF1lVjR0bwQW7WUXF5?=
 =?us-ascii?Q?9udqWj0W2h4BavSVnCbIu/0yMeK6zuzU0IORaRoM14ZTeTyMwgiW1gdhmiPu?=
 =?us-ascii?Q?OeLqqxGb6yP6/GVlNkSrTvSmg8jiFKlQLPP8ATlzxImu5pUbfUjoGPcvKvAj?=
 =?us-ascii?Q?m1cbdWNKp7ZnHF+1e/HJxsSdTCdt59UcLjgMOapKAXKkh0+PnpHbKVpozvMF?=
 =?us-ascii?Q?NCVS2PPZsRog8DJWiIaAt516ZwVcP/oEPGarkvlHKunbT3NPAWtjyVouOE2H?=
 =?us-ascii?Q?U4/MVXmU9DazpjNZFrZqBtuOaRflk0pkRIeOZWgdBobIV2H44LmT9Gu8Cr6V?=
 =?us-ascii?Q?H9AcaoqPkMJFEa23UkyiPQCHoyLZgT6DJo+20B9rHGNxJXp+y1evrzln0YQW?=
 =?us-ascii?Q?MsRAufRHqv5Tpbp4uxL3QSYbEZwIpQ+affXPvX5EqjJ3HXEy4dhacHzepbto?=
 =?us-ascii?Q?gB6RR58ajE0lvvBCFFqzVXWgmCUo0LGi9EbLcKKVpt0rrRdT79+Kv9Tj3Ow/?=
 =?us-ascii?Q?sk0WBXYFvyvRqNwsR3+UULUD3zXFZPxdhW1KBULb5/FZsRQiLorega/WuUCt?=
 =?us-ascii?Q?dSn4d8P1HlCyeLPpiQQMJNOBOysRftf9p1hDZ1+4CicVtlolKZQJQoha2SIN?=
 =?us-ascii?Q?vhn5hnGCPApUMqqN81cZqw7MvvBg9tgryzHJ/qpAZ0GhwpOJEjUV9K3+/J3/?=
 =?us-ascii?Q?2TlkD8GzPezPvpBKi9Akc4y3oQkKSAzXD4p0Lx/DsLrjpCtU8XiaULbu23qj?=
 =?us-ascii?Q?FKER0zwxbSEpxhkIjMCqxRc9CI7UbOZpTf51TQqWa5um6mVjQzoGs0tG5MVC?=
 =?us-ascii?Q?zQLFySgQ37ti0ZIc2egb9q7EezgwWlT2qZxEJUyPZPClWMXUHMCNvF2xu1f8?=
 =?us-ascii?Q?nYDB7K1HNgYwfuDfhiz5oPkWZGDSzOyKfhGC/5bevHnZAZRxroYHfkwUFsR/?=
 =?us-ascii?Q?XqXSthkuaz8/LszQWCE7Zu8BG+MncDw2DY50vJeKb7/J1g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+AdqwXM9X/0kgkP4kTVvyII+NyEhmr/+H2Nwd/qkws617j9nC2ln6tNb51JP?=
 =?us-ascii?Q?sddi5XKnAvjYYWavz8wd4MdC2JlEuExlT0T/jew0w/Ssf/qzEgP0xOi0UumR?=
 =?us-ascii?Q?Flb3bXLQeqSTZ69spomWxiQS7a7Ejfu/vFK2MNH0Iahl7hUP3w9NRt3ND+/R?=
 =?us-ascii?Q?EryOSVSvveOYoM9++8k7PliiWat7i02LeVRmtS0zk+k6pxqJFrdckLHAgVEV?=
 =?us-ascii?Q?Fr7s2ypaaqY8RU3kTVMbQmwRDQAVUjCLlbXx+n3U6nExpizy6MECLb9Vl0Uu?=
 =?us-ascii?Q?jiTmDG+owiz/xGG4tEnC7HQNk3DK5sH1/9IdLfqjpGukbIScXAUNMX4ZKRYh?=
 =?us-ascii?Q?YxH+ZMjMvqx3770dIted+sP8DDqnT2kH6oE8PMrfqWt12D6gPwRVjUsy69F7?=
 =?us-ascii?Q?3weHFYurOyLazS97vW5Ajyt2cZx0kgUfqAMYr02Q/qdRaK9PDt/uTtE5fUT0?=
 =?us-ascii?Q?8GrCy6EM0ToG+i1aJM9XUSRkwCnCQZkh+OLgizttfLKEa9m/F6ngNKLR3jPq?=
 =?us-ascii?Q?X+Q+LGdaUkXs1ANqxCvznQxCJyyJFMdGlpEHtpQlJ94ePsY9lCvOaSce2iWj?=
 =?us-ascii?Q?w9Z2dQN9ipMbZWtk1uQNVjNexooLSr2dauRQXUeMh91O6mBR/RZepMDgD0Ad?=
 =?us-ascii?Q?J8ELHXd23EAsrUEAezoWClY26x+lpLGieAcdQjQYQ7bC1sLofv1fMX0JPxBQ?=
 =?us-ascii?Q?LKJMFDUJOowHb6UozEcDvm/Ioz7tf5WWB1TUgxsgmqIB6pHGI+Ppw79l1ced?=
 =?us-ascii?Q?5osd7hTX1JXHYngMO9oLxjMROFRsZyby8aSComaBvKARa2TQIPqdOmg7FEwz?=
 =?us-ascii?Q?7CiBtC126WT+YNIf2TOQATEWE5fcu8E//fQtyO6t7qWI9cxHqQ9SWe2Ih0q1?=
 =?us-ascii?Q?aFrdXpBv9O68Yxade9cYr0lyUCYvMXn4N0cGFbv5SFwr/VAx1FXZMDDw5l7J?=
 =?us-ascii?Q?xqFO0gJv9LRu3yO3JCm61XbYXUZT4IZD8XSoxctgeerT8RYzWM7LM12b6a2S?=
 =?us-ascii?Q?boC5BDEf1Vc3E/ilQEQ8gOZJalh2CjA1otpiWLT0dSj9UR6DJMxfVe0AtVGF?=
 =?us-ascii?Q?YabXbdSsRbNTcQ2NV5o8XYnJwjaN4/H+HLQPQA47dMrPqsLcmp3YM6dnqO1e?=
 =?us-ascii?Q?UjTRjdLlvZhHCb3YZzNJkKiUKRnSDfMLHmsJIR+E/ljHLYXSsjH8irC/rBzr?=
 =?us-ascii?Q?HaGRby6Kg/ST3dMhd+3Kyg+QWZQTycgBWKfO7MUMvi2VtShwmC5LdL+dzDY1?=
 =?us-ascii?Q?QT++WPcRa8Q/RfiSxZual12V2UdPhVVEzdExl5kMBpE85Jy/dvab9ZBPxQaB?=
 =?us-ascii?Q?VRBETYp+Co5ufUzVUhDhxnsPM90GGZ5MkCwNopyj1t8UNkF8LfX92P0y1oUD?=
 =?us-ascii?Q?NXD4XXoaQviKp+P0Vma1qcpVsdi+IJe6A/tDBhrWNRd5S5B533a8WmqpUQe4?=
 =?us-ascii?Q?tkWYTkES0BkCJgNPl8TdaJnix7EAuNER1vTr0vbhozHptZYNoW212c8IKXik?=
 =?us-ascii?Q?YGDMuCjutHjNaF+6ixh0hxNO1qClEVEVJe4V2Edkqzx6nBzkMTA2Wn3gtwep?=
 =?us-ascii?Q?cp8xsxrG/rq1MdwoPvCH4dGb8FDd+u4OdffkPNsDMQHJIgf5m3M88w/DqnKR?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yNE9fl2JQHJuP7SQvmD9tVywgbAJToq4JjtktK+1jJJZ2SdZoREn+okgJs+jhB6sYkQyU+mp4SzKVx38OD+X7tRb7NA3enyoRdF8nPDWtbYeg7HK5t6p4gGRu1eUhouH6DkKGSgFQXQYrhANehHfDPI5/EFzYp0o844qw9EUz8bY5Ff2VhHfFHaCcbrzWek/Vq7Sf2jl0IJwzysicuBnaZGYZmXMKAWjwKiPGOH0R1F3+BviXdDqIwlNQIpmgQcWzsI9CIQdjxjwfwi14C6H+C0HpYKKuhVQ4YPf62pul1prnHqNJ++SPsJAE9d9ugYxXJq8Yw37jUUaHv/UdoBAqxvSPJfnbTTrklzEeIHujRCJ5zl7rN6LWRiX/PR+iZs4s1NcXP63eER4bkiaX0N6pDGUe1t386ugKfqNQN2vIrcmv3Vu1A1j7IFTrQGVuS2Oje2f8zjQC2nb/VnbrVbpz8HaXxX2upnJ+3m3FnpL8DiRNtvSncuKfd7w6IJuqmVlS4Dlf6ukUvD4/XyTgQCed1lqkN4d/8V/K+Bc0pw26V4E0zpOsLd0x1uxDSLoUSoBaQtIl+NsFm6Qu5iCzpJayf2mhGgO8COGdMQUpX1MDyA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d81eedf-3c6f-4fbe-90cd-08dcd38ad098
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:27:13.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCn3jOJH/P3PTs+/dkgxq5lDK8QydO/XuEkd61BFeSZwzsgGS10RpLTS+cBZ6hjMVFxTufmSF1clbS40R6fPaHxy018tOLmJj3FAELpPEzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=850
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130001
X-Proofpoint-ORIG-GUID: E-IvCR5aY5PzzQJ8SRON16_sE9Jc3jHQ
X-Proofpoint-GUID: E-IvCR5aY5PzzQJ8SRON16_sE9Jc3jHQ


Colin,

> There is a extraneous space after a newline in a dev_err message.
> Remove it.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
