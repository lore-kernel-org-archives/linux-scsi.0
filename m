Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE31922F6;
	Wed, 21 May 2025 01:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747790668; cv=fail; b=Z4hpN7x7hFJ0npE9VQw9pfIZeUBkEQXRtwRsQJDO7WZrlG4mhcZdH9WgV8ro2aNkiBP3XHUZ5mpE7DTot40pS3no3XwwL/xSwQANqRZsHxgIamRct0LzowL+wXjRfaJ7ikwbB38d2xPD0M37c7FZcgliGFMhyEDCvXeeJuqBfbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747790668; c=relaxed/simple;
	bh=8DtOWboshzM8ayKxei2x2bKPy21viw4L7SRFHQYBtsY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=E1fHlw1/iIQkQKCtLVKQK2L/r1oHhs8RH1sgAyQqtI+S9VuF35Nz5Wd7sVyVtk40Yl8QEF8mD7yTGRb1Ki/OukFBG3aEvqufOT3tWpKN4bHqndSja5gleAejLwOSHZkFlmu1D5DmwihaJHk6JxEcjlK0LlqKIJS4//YSmFEtebg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QhpmiVXn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sPDivIEB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QhpmiVXn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sPDivIEB"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L1IUnm000873;
	Wed, 21 May 2025 01:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HgDAhdlkfIab9nJH1j
	IIjDT3f3ocpjdDH9gBCWuowLU=; b=QhpmiVXnv5y4dpobf6FuxLNJxBDLeYwan1
	RhMGacbEHMbgkT9hKTLwKKJJeJIMb649AoxTynCg2KZCHlgwZ23cHt5ILmMJmTuQ
	PeUvikUbXGpf7OQFNRPM4Lo+W+jDY4DtqkclGqheCNm2O5k1UbQQxGM1T+t4q6Ai
	769lf+pAz4tAC/Fp6OYHmLZPFzxIkCFBH9+XwxQhgHvzJJOTVfQnxw75PDbCxAk0
	4tvOKC8PSriz+xSTq6cQLkNQaa0SKTyLMlJwrOWWw26hprI/T1P9l9jz8RZZLjbq
	0yw5UEdajfjt01TgQFSd67doPquyTfAvGAPtK+buy71Ib6V4Gjkg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s4ep029f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:23:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L10F3W030414;
	Wed, 21 May 2025 01:23:39 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazon11011010.outbound.protection.outlook.com [40.93.199.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwet89x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 01:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1uicC8g9Gbr+xDL38lpZgWccYVwO+320/Z+7OEVlzb2oqy0dHkdyksL09aCUMWWddAfnPRhZuxfvkfpTG2wIM/IrX5Z9iu8Zv+4qAafRelWnTC7iwS7A+CX3hame20cnXn52hoCSuZYjQDuvFP6eAlAPuErDeVgjg5XeDz1aZNWvRqbniGPHfyMxXO4hLaLOuala49izzT7hY7yY38CZ7NQ/92xAzQuzVSWv6upaeJaVOqxb89UEsyx7Pq73q3JSD7Nd44VicB9dkjWn+5nZy/g0ZfMWNmScwC6p3bVLjpdsJczPX6w5O/VSvK+zExW46jK7fycSv9UUlsdQOKBRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgDAhdlkfIab9nJH1jIIjDT3f3ocpjdDH9gBCWuowLU=;
 b=jL6pZnpssictrmV1jnKsiZv68sP+i7sjJt57hhyOepGwaYWZ3wDTNqYeHl/rsCsYMOBm7VPCrGCnJpS20AsCUFFZOPnGoi44GMDMaghp8mMF6cMvgXEivHBwrlsw2e/UKg1SYv+5dy4rtB/PU5afN9Nd/SWfg49lw9WRnJzjCwLTSG/GxM4CKFHvCwGEr5VNVJTmHtVKCC13hyJ1EYVlxgxYiPfoa3Y8GLLujLMvoH3gg1BGVOqFccZY79kelU9/8pRcNE368A0md/qujTBAheVXZS9v4ZzHNUdlYMUEgnx/EUwdDf65PRvWEgWSY9/vfds/0LyZWe+cWRCWnwpkWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgDAhdlkfIab9nJH1jIIjDT3f3ocpjdDH9gBCWuowLU=;
 b=sPDivIEBmPlbYsMJcAJOjyWNpRSNbpd1B73k//dksMt03UMPHqB1GhinQByRYgtFFFHE3QGqORMTZXModKktYPorhcDvDlABF45dcQrQVPBkZNcYDLwOG+BTdmr3h5RCB25idSATtlpT6Z1wCNUMKWsuDceeY8g4/CVRTmXNW3g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7582.namprd10.prod.outlook.com (2603:10b6:a03:538::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Wed, 21 May
 2025 01:23:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 01:23:35 +0000
To: Kees Cook <kees@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Simon Horman <horms@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Maurizio Lombardi
 <mlombard@redhat.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Eric Biggers <ebiggers@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: core: Convert inet_addr_is_any() to
 sockaddr_storage
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250520173437.make.907-kees@kernel.org> (Kees Cook's message of
	"Tue, 20 May 2025 10:34:38 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ldqqn4f8.fsf@ca-mkp.ca.oracle.com>
References: <20250520173437.make.907-kees@kernel.org>
Date: Tue, 20 May 2025 21:23:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0062.prod.exchangelabs.com
 (2603:10b6:208:25::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: e088ed88-699a-4f73-17a9-08dd98061b2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rlk/hgfDoU2Gvoletj6Xmwp1nHTkepQbeRzaLjLZY9Bt/WIVwxXjjU1ISmGk?=
 =?us-ascii?Q?k5ERaJ5pfGel+K+SWQHtiShwg+ldA6uMR6Rjw3NDEoV1jOeo9cObT79e+vcg?=
 =?us-ascii?Q?Oqv0ilhvaTZpC5Ri4hDx51OIZO7FOPzcOUy8ohEB2jRHpVYAw3nGFjcXlryf?=
 =?us-ascii?Q?IOA+mZivC5rcS1KA1ptIvz11WKQ7CucFtK+egdfIJJidIaGuAUwjmGxDasaM?=
 =?us-ascii?Q?lrIgvGRKhM8ViWl45jI04APM9zTItavBN7M0a6Dy7txSjlKppvWKgZw98S5R?=
 =?us-ascii?Q?WIgy0eFNCldTUUOT5S9QA3dwxKGQLoDxi8Q4DgXN5w1hGe4T3nOBfr12Y/wr?=
 =?us-ascii?Q?IBGdm0J/PcCGZEEAmPXwiSRftpMePn4ZWEmO5FJ5/7NOQXTitneBIzRJRcVR?=
 =?us-ascii?Q?EHEqXiWHGLB7MeOinidr1PTDhng4pFw/APA2WPwNBqIFRScWOnGmPfQV5D+X?=
 =?us-ascii?Q?SFxIb88CdlVSgi8Q3dzjIevQkKxH2HBBthVhKnaeg+Rr+mbFHJ+53uhl6DN7?=
 =?us-ascii?Q?nuAQrCLRePUxMkPUUijapjRZJamVmOSKcMPUkRYk0U4L+tEJU4p8mN48VsVt?=
 =?us-ascii?Q?DZACfaghLcKxc0z9NJGMNAqgIue+HMd7ZVFga2oOINbM8MJGodMCe5wC5Hxm?=
 =?us-ascii?Q?pPAxqbkWQDgsTsaoaI6512FEvIBdqcPFRabGfe287sv5Bb26Wxv8vhiVHwFv?=
 =?us-ascii?Q?prwKiyvxk34FggsqljwARHEg+5oAibOSHRvgz/C2XW4fF+rMZNAY9C8hkjCb?=
 =?us-ascii?Q?76ZEhfZjWCdqO2/7OllEvcre9YBiGaS3wZOEN1m6Kb4OzHv/YCh9HzqXXILZ?=
 =?us-ascii?Q?7/9StVzQKPs0RkXvtP97+Dfq7/kxJwa/tkZxcYvgbxhhlvqflV/Bwf4yKhgE?=
 =?us-ascii?Q?x0/fb4GXmBTXqV9a1p2GM5S6Rzo5OuIMPisQ75kERWefmvSU3JaPCrD00IVt?=
 =?us-ascii?Q?5an1Q6xCDmzvXnsb8YToG+NTULipyvoxYGVyacVTYHb73BB+jZMhaqrllORp?=
 =?us-ascii?Q?sBtuAes5OlT6PiuDONsDJpVED44US1n7yZu6VoXkZtbwlF0GfsyQ57ZEXT2/?=
 =?us-ascii?Q?EXVW7OHQsEYGQ6nsng7X+iZ0R6Qv/wjm+x5MjSqxO4YQfMciTfbJ+sVJumCl?=
 =?us-ascii?Q?3Rdh6l4CDDRmCTUdrYCZXUhwu6qPT1eMlZJeivNKVcENp329Qsyy8ZW3AE4w?=
 =?us-ascii?Q?XtJYJy+iaACzY1yeBQrKf3Z9CS/CAcmUzL1Vd2iecjHiEyjmJL+vNPM+JHjq?=
 =?us-ascii?Q?dcMZV65ufJXdXoVkeQacC26Sp5XrK558ai72qk4aO7p1xur3pkQBbD7sycYk?=
 =?us-ascii?Q?Yq001hBE7VbcIhjpsRZomM5qGOV+xjNdZjs/WaA7C1OtsJEbJSIMcU4+M8KM?=
 =?us-ascii?Q?Z6qS/x7OCRQJt7v2TpMz8eO3Pi0OT9sn7Rw1EdrMLRvO+pyUMcXFOScxh6q1?=
 =?us-ascii?Q?FYq5KqextvI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6MmY3JGjv3tbQRZEF+59qMbLhVSNW8+BDduvfJvYcKdgo95nixjaHgHcGfY9?=
 =?us-ascii?Q?uAPn08+BW2qiXIhtXIhj5JfsM4UmCwazzlIrnA7iyF34CIcy2eZ9GP4uMyUU?=
 =?us-ascii?Q?CKDWbEFDCRFBmfDC8fLhIjma9uXfBNATFOO4YX4KjWQIB4NfxsTgfwuV/2Gf?=
 =?us-ascii?Q?PYOWsqO0WN2jE4J+Xows6fE0h2GhSVYCugEJtP/4aRzvidS3lpbGHrFMmEf+?=
 =?us-ascii?Q?TVtdR6fe7qb1XedeC8+sjtw/g3j4KCgm0iJ4NR24OFF0l9POSdnV/OLOa4pK?=
 =?us-ascii?Q?BewjVjeZhNFsNvNT+OaYoIa9TXNW8aQtHkpL5ocTNvccaII8VqMxtPGCm2NN?=
 =?us-ascii?Q?lvzM5a0xBQanPy75rSkKYDTAoO4j7cYNhj0EkuftcKr3xZcI/gujuitZU7dY?=
 =?us-ascii?Q?3k9uZrR93tbviHNrPj4yG9Mlc4RA9+HGPSlbGjAmFgyjtWA7lXrgEBlm/Dnb?=
 =?us-ascii?Q?bkN/9WlxdxPoHxSjf2jHFKfsI/3zKdGe/jlVAZ73IsTVP0ONyU5INAxGRMzQ?=
 =?us-ascii?Q?urtz6BeqN4U3ZjeyIUSh1/cle8O9Fn1py5ZYKWfS/rx2oJlYpUfRagCFdylE?=
 =?us-ascii?Q?/qrmJocN/+OnyhUMYGP0ZTbShhFEWCQEhJh9BKtZZBWWhHgTnFOQhqdmRapU?=
 =?us-ascii?Q?fTpIrcV1DwqtZMUaxGJEPjd+AiXulb/A98381aWdERPAhgqxCVPAZuSVL85m?=
 =?us-ascii?Q?CoCy3huROripB/ev+ZZqKvKDnQICRxMDSgw2CdmzTnqHonitz7BbvAX77sg1?=
 =?us-ascii?Q?ujKhAkTzY6s9L7YpQ27fnWhH84IMqInOtEQvw7jaCaKxorU4Y/oSHBVLETGl?=
 =?us-ascii?Q?ifpDvaGDw37bULj699nZ2Oowic4Ea5eEdGHyDoDs846xxPhDFrdlGLfGzzbo?=
 =?us-ascii?Q?A+HTcg8uE6iWpcO9lKXzQT+kKCKMJcSHwwr92idLYo6rBlbisqBCQBoOlXdj?=
 =?us-ascii?Q?q0A0BtuR6/zClgDCrW+tWLlrkJCIvM5mgJB0G0VrhQwkbK6SPrcgIqoN+MFq?=
 =?us-ascii?Q?NZXaBrpn/x/7dyxh2FRykemgIQaRrAIHXMVD4akamBkAYmXZRT3ob0vsA4CW?=
 =?us-ascii?Q?tWx27EITioFxdqT8+Uj/nSFPhVUnlJGY4O7kEkxsFkOmVqOpCEiPkX4NoO+6?=
 =?us-ascii?Q?E1bN0cvBMvS0Bqpch8uA7s4uNPqAO53cmKXeLSt3Pz9F/phKyJceNBTuZ+jA?=
 =?us-ascii?Q?WTNrebD4qgJlS1MnlRQi2yRKhowofiyLVEaa2SfHzoh7o/mj+lMe1+xz8QHo?=
 =?us-ascii?Q?lMXZF17ykGl2vDNpLyVc59LgN30fnKiIi+7jJuMj0jNeJ9QTKy6WoCsMuIW9?=
 =?us-ascii?Q?eayiVZKs8gqv0iiCg2OtvALPX4ComErQuGH8AQXZHHRh5OZP0uv3xxc18M/d?=
 =?us-ascii?Q?Qwh4E7VLIhL/97i3B7EcG+0ooJtpjkcF2oSUn95jGjDeO++X7B8tWCmBicwZ?=
 =?us-ascii?Q?lG2duzFtSo17dYwBi/CyLW+yCdMxdnbxjNKsFyHYYrmaKY1lBozfhkJR8Kar?=
 =?us-ascii?Q?VnGxmj7N+ymsZFBKAlPbG0vDZr9a+WQhHO2Gutxul0k5Q1KoIhqQUcNarH2G?=
 =?us-ascii?Q?DFIzqwpbGi9KumPQoZr6tMjgVmzp4uIZYnp1mYnMVOQLuTKR0e5QXM/gdBZn?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9ruTWoNpyDLm6YeOxsZ56e7Plez6OtzKA/cUZXR0CxZIyxQSBl2fa+n9IX1x2nbT5kNnbGf5bt5YG124scsxgJdGzPC7OJBiRwtEGP7k3knprhtKT6kJwrAW12kBtp0dCWwdam7JZGYg2oa+UhN60JI87h/6sR3zobheSnE+1GoOspf69U8/b7HXtr7PYGgrzWwvvVfuYVmlgkNTNS0EHlqIxuzgHX7n34w+F9ckxgc2iBT/ovM7hju8HAA69e0NMQ6EixSBrZXs9B0JvKB2HxpsYIwvvEgHtav4P1MBjwP5p7d0yNHNY4KwrVTsqa4kYfS7hrTkPDXhgh+QURONZQrmRtGoFTUa82/0dcbY/Q2AYmZ1OX5IVkBjt+51uaUTkLSt64oQeam4kLD03T4r9ovVvwcUGYc9Tg1mc6QRs1vQtYi8jjWVMnPeoaROaBag6RAcZKb+VtdVXucsfmeESwFjrZ3eGoAIdwpHyDpEr5Xtb/cxtB34WxGHPPLN6mVj8n86RKj32IPsxs0K8UGTw3Rgm/J+fSs4l+8QFLnk7qAEFkUAdxzK8wpQj2+Jsyq1JDFG4sU+T+TDY0qUJRP51DgXI2C8leFkyPgWABYb6zo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e088ed88-699a-4f73-17a9-08dd98061b2a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 01:23:35.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nrecIflEH2LwhUj5Nm8sJ6VYyYeG1GxZCx26MBV54J9CWAT+ahWN6ny5yJ495zdbIPFYhZ495ACecacJC7jyBXVBXr9bu3g8MGd+fRogxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210012
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxMiBTYWx0ZWRfX2/At5/2Wkl8d N2cI/IhQDg3IzHpZ27E1Itd34mFyAOCoY3aKOxIh+amEiW8NF1dz8HtiFSYe30N09yFSRE58412 0XHq+e4wZeNhfC56wFw/PD2aKXcyzfSm1G+L5xg7Xi/fwu6EfKH+1TpGAkyAm+i8nlFNf1t9x22
 2l6C6DuEYZNRIqbax0VGEbYvxSfaXRlujW0K23h/HHxKtn977ORvaivNKCqmkVeM/36svJEPjLF 8323H79fEC+afoUVxGhgV0TXw5hzUER2qo1jPzRnaZIIXzEJQrG73+Vxh4lN85yd49RwGigCt3p UO884momzgXR1rXZQ3n6U1TE/cGbxQe9VdluJUUTMpWWQ9+PxphQQuYdGxfwAHQwYgIoEfLsyvN
 K34zihIBE6rP8Sp1vd4ncEY+kv7g6XYu2JG+/JjLQsG5TGqYVoIKEsuvnhZax8x7bur+nQeD
X-Authority-Analysis: v=2.4 cv=T4mMT+KQ c=1 sm=1 tr=0 ts=682d2b1b b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=VA8TjvsOcMiS39GMMiwA:9 a=MTAcVbZMd_8A:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:13189
X-Proofpoint-ORIG-GUID: REbkBE_Ln7AdZ-ep8ti6LgjNGcn2K7VI
X-Proofpoint-GUID: REbkBE_Ln7AdZ-ep8ti6LgjNGcn2K7VI


Kees,

> All the callers of inet_addr_is_any() have a sockaddr_storage-backed
> sockaddr. Avoid casts and switch prototype to the actual object being
> used.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI

-- 
Martin K. Petersen
