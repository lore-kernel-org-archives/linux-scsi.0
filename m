Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4A52E1757;
	Thu, 25 Sep 2025 02:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758766234; cv=fail; b=lAhcoQeVX8J1mqRIbSAraIg+4oc1zBpFiJZoaN0W795f5bDb+4Yelz6LsluOWXG6dMkXdLr7yRjlD0m0CnX6GNU1w+FR9tXhLue+7B7Qkq0zkeQcK0cwkHGK9EqNz7Te9JOfwm2VsyX+A9nHmF1sD44xrm7viWihsA7tUo0nyfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758766234; c=relaxed/simple;
	bh=/2IszgQ0D7DOrtboU40Mz8o5vBhY2OUY+iEkz/Us6ps=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=F+emg1bEkROsl/CooRah/jLxqQ568np2zdNqwHmfyyWbwBOqvaAtcrppPJmOL1jDTKUsu1t7hWPo6LGN+W3S6AwAbZ2UfwuFhMuNF4TSd9ZrKcEUeEjYptMwm2Zbayz9vwYO67kZzJkNuyy+HOseRVM+G1qCp9kI5+aaa07H7FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=czhAnIn+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L5m2XYFQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="czhAnIn+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L5m2XYFQ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OIu7tS030873;
	Thu, 25 Sep 2025 02:10:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3pM8/RV1iHeUtKeqmg
	tIvOYV65OHl+4/SDhJpcOpjtY=; b=czhAnIn+lgmZh1uPEOTbHPT+gk5t74Surd
	s/Mpl+dRc8JzkunTMhHNR2p4/NaZsoOGYHbxFymCTNNzMIgoAkEe40H035/bSkGu
	DjGaguovg+CBB1VcxO40RzbGPB+bFI3cz3rCXiovG8UyWQs5b8rPaDU2ryUEhBoK
	Nqo8VtzYgBPKe1fSlP/kQc7jC6VKDFNLaPcRfSqI6xonWSzbYYfEhZJBD9uGnsrj
	ZrVSfjMRHTmcH7MFGlAGmoxZrlI8HXtw40clYi1PyGmlHZkex/hSITjCvBZEAo2z
	RUPqCnhXIJsHl4MEOiDJumIthLubuYJSsL8Upz96/KmeD3Q/y7ig==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499m59h00t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 02:10:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P0TAmT030414;
	Thu, 25 Sep 2025 02:10:26 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqam7s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 02:10:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPWN0dv5xFHp07y/CqRjcBKwd6kbGQoXFjFsvHvmT/SPyhFLznt4SIJGGeLtkxOQPl3rfmtKiEEMa7zm76F+WoQu9AyZLgj2Lc7xqZaYeX10y+Avs5Q98+/CdAwrkDb24NnUgHOsybeucKKDe7Y4Hs08X576PL8Bl6HFBFfq9OvrcSbHco4wzTn+mNOnbXHRVYaTR4ZYpN8BFjNACeQWMeJbYzAcuSYPdMj/gTu80p+14Z04DlK/YGp0QQRavo1jPYwjak9Bd6GKyLJt0dClfXcdIH4Ba9VEmyRszaHBwLQdLrn8K1whPqOzDrrsoJaWjty9UMAnePwu4on0k5NLrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pM8/RV1iHeUtKeqmgtIvOYV65OHl+4/SDhJpcOpjtY=;
 b=WzQPHlbwuJfPvhU6XU40Ti0TCPQaWzFQJt5mwhgSnscYsOcCWftdc/uy2Y8EFc8DIU8oN9iPli9ueiW202InNwmp6NJ36y/4Dno6ofmoaC/I/VjcQaX5ydP1iGWB/1L/PFJ8i8DA0QoGz7hYup0qSsle1jTE4zWK/aebFFDXChYTX1ksRUbn/1L4zUnqUKcHmSL6sit5WB5LZ1bG49Bwb9TKrlx/s6WQovTvo288gBjy/mwkXGhsMRog2uWugjk/o0st1EE08cuSJGV2l1NXJgzJOZIEleQtAXYcHaKDd6Q5uJs78LKcS+SkKxdd7kP0lpgifTF2JIPYeqnVxycrnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pM8/RV1iHeUtKeqmgtIvOYV65OHl+4/SDhJpcOpjtY=;
 b=L5m2XYFQ4wZ7phJCZ/reB6aS/KS63CT7u3rZauGR+r+XYw5UuoDsxCBXTSlCKiD1RUkp8GSlD6ez5wZNjETMIsEyU6LYX+GuSuYC5PgQgyK7Liv2bEIDPnF4tcYbLjBx3dL/ss2PznwsTjvrwxFsnVbm6uV6GOQNNFuktQBZ28U=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN0PR10MB6006.namprd10.prod.outlook.com (2603:10b6:208:3ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 02:10:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 02:10:23 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: Replace kzalloc + copy_from_user with
 memdup_user
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250918144031.175148-2-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Thu, 18 Sep 2025 16:40:32 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ikh7qo5u.fsf@ca-mkp.ca.oracle.com>
References: <20250918144031.175148-2-thorsten.blum@linux.dev>
Date: Wed, 24 Sep 2025 22:10:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQXP288CA0029.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c00:41::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN0PR10MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ee71bb-ff8d-444b-3a19-08ddfbd8af7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1yI/ppE8Nyvx3zOzJNtLee2vDsa91Sb5Ordh5GvDc5K4w5hDQfR2uXsdbC5L?=
 =?us-ascii?Q?of2KZhkYADwgs4tVPHmMo7SaItKe78H+2aIR5NxUQVNnH8D/MksSYg/MyQA6?=
 =?us-ascii?Q?9SrnA+RMvWrtOi/erwcepEtIcWeU3La5VqQCSyR6tXXWA3vSHpLDYGgnIu3H?=
 =?us-ascii?Q?IDloB03oHQDIhQ0VLafDiTOCF0IU/57HUe7wBUZd0TWiTlSE36MW4kRlm3BY?=
 =?us-ascii?Q?cvJeXQXIHMXOU6Gj7s85pNf7MD84+VddHWQrnvBLzVulTojRejHYNp8abBgF?=
 =?us-ascii?Q?fixd1bVXXTwNFq27igae4ftSNhp53p1QDSBotGCby8l1L7GLpOCrGiCAY8KK?=
 =?us-ascii?Q?HV6pzZPLjcN4P6NZVEe9vHJlLaTKUXKURICX1FfWZz7AL+tPlx7Loj6B9ifM?=
 =?us-ascii?Q?0uj7Ypqoj5BDoxTiWfnDvfOuyq/upBpda2g/2jOy0mSZrQB+rEl2uT8NEshq?=
 =?us-ascii?Q?0uULSyYtxXI3ymcy4BZf/2ReiOaC7FV6RLUZ7XWyMWKcrjTBuNm5F9adzUcw?=
 =?us-ascii?Q?Mh20eJYAji8xJiSRH/LWuAON0MJVizqtoz1KBulMAjAv7R9ep6SefV0Tod78?=
 =?us-ascii?Q?tij/4VgSuXwPbsKVoVhw6lPeVh4zVkq8MNWqVj/AEnrhlnKaEzSeztOeswzu?=
 =?us-ascii?Q?nUagumnvpGIiPX9OMiclLtYnc8ZGIA1DcNinIw64lJxp8PXQ1tDE1JqkWZdf?=
 =?us-ascii?Q?s0GGU08S+GTcbCoii7GddQ0x6Rk+SkzKqlqG24Qxb6sBhAYrhdoRrO54PLb9?=
 =?us-ascii?Q?b0t5bEGAMS6jwxIDgck/P5CeV60zuyWHcpv9ghv9aT/s1VTLkPidbjEuKh87?=
 =?us-ascii?Q?OvAgotGKKqz8wcI6yNEzo+YPI9+HdihJcDMCq/vJtG++fWr6GxlI4FgzJkvM?=
 =?us-ascii?Q?tin76AgLRdRQBv3vFuab16XwIBvm5CWA9x+/DG8MoV1ZitBuWSoDPHzczwo0?=
 =?us-ascii?Q?Qt+qibZ594acFA7AOOcEOOJqg/6c6UhDCkvpFta9/ZI4U7y7UcZhcQGTbeJ2?=
 =?us-ascii?Q?nYpCA534BtqwbUSCHKlh3CDbOo+aHhMfI0D56VboTDM+p0NgmxaIFe2qGYyI?=
 =?us-ascii?Q?mwTgFRp+9DyK/+MRZ/Za1kAF1QXyQaMpKIFfCweviVxRJgylugg+P9PoQvup?=
 =?us-ascii?Q?Fi6QzI8xnZTOiXB4nUulK8d80SnPsR48LR7rzj+inKtHJYgg9oLt0uNdRkkD?=
 =?us-ascii?Q?h+y/nWpnTyJnnC69AD2f23b3MITdUMy4+vpUB+7t6Pj25D4Hxv75eeLaRomq?=
 =?us-ascii?Q?q01m+JszA/dMJocVGV5XBGJQYu5aTmGEtYXEigWfC1vs/jwqY5y83juNLHVx?=
 =?us-ascii?Q?XgY/XZMq6Xoi8m4U5kNzbdsjsJbqw2EFRdqFdfmRFSFPHcd7vb85/+5fGJri?=
 =?us-ascii?Q?mB8BXDMpMtTOpoSXPDFQR+6kguhxEPNv89sGFC/3ESf7gzQU2xYTlQVX2/cK?=
 =?us-ascii?Q?qiY5Pkw58Qc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2zxYLcadpME+WEm6jyzhgNXcgrX4BsR8NlWdDGj4AnaUOg/N8jF9YUyxRdTH?=
 =?us-ascii?Q?ku1YYKvq3b1HIj5S2HA+0W5NPa8nFUg/TzpHC/KzRQ8BV+/6WHIbNUE2blHD?=
 =?us-ascii?Q?WjsJ+UI94U0C/0mV9gPg+E16DnikHEdlUKiLu1bNGSsteemx4ptxL4IB9r5h?=
 =?us-ascii?Q?Y/KOGy7iA01yz/KxHWoqSk9ONia+MXFMqcranbbQYVqgTfdJiYRMnTWyxPuY?=
 =?us-ascii?Q?840scylLypwCOZTvLqqW8RCysfgYMTMXlYpjJj3op+PxC6p6/kzbtrUCYRb3?=
 =?us-ascii?Q?Psuf6MG9Lesypph+fZT5NWZi1vK8J+oV+L/RF8m31J6Dup7XDsZv+uHc7tyW?=
 =?us-ascii?Q?TenqVngoSkSbhLPDkwN9UT3ELAuEJF6sUjrchyxxISiAbo8wZMHgOsZ5YsoA?=
 =?us-ascii?Q?RMtFeydAY2DHZ+zlBSswz8SXxpg+ljr8hYDZsRqcdkvHe1StWKXio25a/3wd?=
 =?us-ascii?Q?tDXc8ONmQS6BvaK1I3pFdUyGcDpCcwe9b+t04vkUOUrWgP9RRkmjZIdTL6l+?=
 =?us-ascii?Q?EBMsd2GoicUM38DYOniNfNzBR2L+Lwk4NlseJc+qRj7nQAVl9o9s9j37BKka?=
 =?us-ascii?Q?c/UF+NYCr++RS84JAusflG2em7edaol27zhemOwfb+1llIIqmgIMBHZEaClg?=
 =?us-ascii?Q?Dbw+dSg3KsZ65NiUsf6T81PslcBPckBf8hR78/Y1z76n8wjtvhF/Bp/JDU+T?=
 =?us-ascii?Q?Tiv6pIvu4SdgweZsjXPXXuOFBSLzcDYXEKf3EG91VCOmZzAjmycST+z+F8SX?=
 =?us-ascii?Q?/bwK0aknSB9VDVirEykELdCjNsVvbtywd+KhvHdbyp3PWTPmQ50kTX7VWVzT?=
 =?us-ascii?Q?7L2gq3vzGV82HI0zMY/x0gwQz9rkuBhN5doDmLIAGqXp6XGd4gG2Myt/QqAe?=
 =?us-ascii?Q?IRMXgKkzvUwmlrkEbFMEaJ4ku0XFMovuwBnbWycNDh/ZNLmr2qBkX77LKRiP?=
 =?us-ascii?Q?cF1ZhIfpnVjK0vmna3FcDUkdR750+s1fLgd6eYNPgK0Ej4gdNSRGFOWviD8f?=
 =?us-ascii?Q?W2XwaPSju3WZeIU58MPu5uc3/9rZb+v9Gd6qmMP+MZ7flj/tpCgAb0t0sA4H?=
 =?us-ascii?Q?mWQqjppu1f/ntp3jbE/8Ii28p1CFIkdtx5J2DDHu45V2z2oTZbVOpXDdATKA?=
 =?us-ascii?Q?8opxxUwqIUeToCaYsoolGQO4xUUGI3nuDkWmrAscJ/NEDpF13OxvFZDXORbv?=
 =?us-ascii?Q?h3qvT5HazkrzitetTqog/aC/FmDz+2+Zb/HaaFBk4TAHJ8fP+9a8ECiHz0SG?=
 =?us-ascii?Q?pVhH2nmyl7IMiEQzMcwOWQuSMhHXD/Lcv9iOk6CT3903B3kRZYeu41oCCIk3?=
 =?us-ascii?Q?+3NyXZhNdhym1irQQuUvCUPrvtCluKYpbjU4bfFsSgVacbVLdRFVuiH1zJfL?=
 =?us-ascii?Q?f4YFz56uMLBPLeb6ixQz737fIq5TRokqSd1Xtl6qXXGWxbin8lWlS4sHdzu0?=
 =?us-ascii?Q?wrHkT6SLcT/qDrGTyYjUZi58EUcWDU313B0ojqiXlDTtJSUMi47wgzMn1xeu?=
 =?us-ascii?Q?TCNl1j4bmRh5S8gEcLtwzFjepOthoQ1bPYwBGGp/+pPZw+p/yyyaF5rWYp9o?=
 =?us-ascii?Q?w7ONOnfcP4I2JO5be3g++jF9EkRSl5nXsCv4PnpZ+BB+mm+iPQ7vAkwP5gXt?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rIkDacotc0VFjuWqTC+ycu1LXfNYNyVTMFvVdeeeJwXKn36jIJXvr0rgzN4TGDx30tweUtXoKWpuVe4MUgGxnenXmnBUuJ4xVfeCYGTYVv5uKEPlaF4q2GRpC+vOK7IaN41Llk+1AC/CLVSut9kpjeZCgRrhWkcl0ph6qEH62T7fKEiLU+Chj7thHLNxFU8UUyCvqIbGY0SXUXK5KAlGB6PriO37Yq6dbvNa0dBJR2Jpbv0irijJoQfOZL6Ao9XRU8eYJCOs/R4A8PHNyEURyzgBHKNVJEsWCBhKiqTPeaEX2SAeM8UI8X+zovkcXWiBvUBV0nV6HHOBK7oskpol0JxIWW5HoxPpfN+XCWNJSHiKIvwZHeHYnfWqDYIC63v5rkP4ZR6Xg7tGrx0MTfa9HlqytJx2fy8tTfUtyUyH+Xx8uGGrfUpG+bBG33EqirOn6kvOc79jZH7xl2WArv/duIPXya4+JjwhhcSwuhDGMFbZvHGuMp9S/B8GRoI41MsMeI6phAFBOyOulyiw+dVCdLgE5DJAPyu5XLq+iJZdMQt0ndfPYf7x2VssmAFKAtBrlV4fsGpKk8e47Xbgko7399pXqPHaiXsZen31CyL/7+Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ee71bb-ff8d-444b-3a19-08ddfbd8af7e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 02:10:23.3343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5iDeeQT10GdGiH8tF1BZ5SyaYoM3gRO2sTvmgP3/j5JDddXE2E2DEJnwnGKDyOquvcrStOo/At714h4t66oJtW4rbcsakaQ5zZTPGFBDP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB6006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=584 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250018
X-Proofpoint-ORIG-GUID: YjZSIzJ_E36W-qGuRl1JGohZTYHVaf40
X-Proofpoint-GUID: YjZSIzJ_E36W-qGuRl1JGohZTYHVaf40
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyOCBTYWx0ZWRfXxsjLuRmH5JWg
 WUTSl3NLPFeKCFGiDExR5eGtaW4/bzVVZTxQC0IJGeqCuGHBE6eNn4Yq0sxasMW/LYJGH50gI9e
 4JXN/B06KWGaPYyj69wE7sjf5Q6KME6fb4q1nrdP6qmowUBG0QlkhVv1UegpxgpYX9pvcBcV959
 +ldiS3fvGzp0cNcwo4CzI8IXicuAlmnqqEGHh5apPR4S2rKQpTdWspd6czdC+azCc4HqZ+wyakp
 Ok90y5CgmB1PUB7Xv5RCDVTSjeDiaIpDUUJlaflqjmZ3pL/vXV+8nsULQP9SCzsd7boImpXv3Ho
 q+9bQxDiM//c0JN/a+cigR+hfd+fAuiPgl7XWNglMzhfIOVHFoEpTBMaDtfKEsvNM33v6A0vWMc
 B98+Tuea
X-Authority-Analysis: v=2.4 cv=HJrDFptv c=1 sm=1 tr=0 ts=68d4a493 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=S-EHpBKYRhMZ8QOlpRwA:9


Thorsten,

> No functional changes intended other than returning the more idiomatic
> error code -EFAULT.

How can we be sure that this doesn't break existing applications?

-- 
Martin K. Petersen
